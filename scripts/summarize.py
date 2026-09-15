#!/usr/bin/env python3
"""Meeting summarizer and action-item extractor.

Implements the contract required by RecordBot:
1. Reads transcripts marked `status: awaiting-summary`.
2. Resolves speaker names with evidence and talk times.
3. Formats summary with:
   - Overview
   - Who was in it
   - Answer to question (if watch_for was set)
   - What was covered
   - Decisions
   - Action items table (| Owner | Action | Due | Source | Confidence |)
   - Open questions
   - Notes on transcript quality
4. Writes to Summaries/<name>.md.
5. Updates ACTION-ITEMS.md (newest meeting first).
6. Flips transcript status to `status: summarized`.

Usage:
  ./scripts/summarize.py                    # process all awaiting transcripts
  ./scripts/summarize.py --prompt-only     # print the LLM prompt to stdout
  ./scripts/summarize.py --file Transcripts/xyz.md
  ./scripts/summarize.py --dry-run
"""

from __future__ import annotations

import argparse
import datetime
import json
import os
import re
import sys
import urllib.request
import urllib.error
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "evals"))

try:
    from parse import split_frontmatter, header_fields, parse_speakers, stem_meeting_id
except ImportError:
    # Standalone fallback if evals/parse.py is not in path
    def split_frontmatter(text: str) -> tuple[str, str]:
        m = re.match(r"\A---\n(.*?)\n---\n?", text, re.DOTALL)
        return (m.group(1), text[m.end():]) if m else ("", text)

    def header_fields(header: str) -> dict[str, str]:
        fields = {}
        for line in header.splitlines():
            if ":" in line and not line.startswith((" ", "-", "\t")):
                k, _, v = line.partition(":")
                fields[k.strip()] = v.strip().strip('"')
        return fields

    def parse_speakers(header: str) -> dict[str, str]:
        out = {}
        in_sp = False
        for line in header.splitlines():
            if line.startswith("speakers:"):
                in_sp = True
                continue
            if in_sp:
                if line.startswith("speaker_evidence:") or (line and not line.startswith((" ", "\t"))):
                    break
                m = re.match(r'^\s*-\s*"(?P<label>[^"]+)":\s*"(?P<resolved>[^"]*)"', line)
                if m:
                    out[m.group("label")] = m.group("resolved")
        return out

    def stem_meeting_id(path: Path) -> str:
        name = path.name[:-3] if path.name.endswith(".md") else path.name
        return name.split("__", 1)[0]


SUMMARIZER_INSTRUCTIONS = """You are an expert executive assistant and meeting summarizer.
Your job is to read the meeting transcript, user metadata, and human-written notes, then generate:
1. Speaker identification with confidence and evidence.
2. A comprehensive, precise summary.
3. An action items table.

Follow these strict rules:
- Hand-written notes are authoritative. Where notes and the transcript disagree, notes win.
- Only assign action items to a specific person if there is clear evidence. If confidence is low or speaker is unknown, mark as Speaker N or unassigned.
- Action table MUST contain these exact columns, using exact casing for enum values:
| Owner | Action | Due | Source | Confidence |
Confidence MUST be exactly one of: high, medium, or low. Do not write anything else.
Source MUST be exactly one of: transcript, notes, or both. Do not write "transcript, notes". Do not blend columns.
Due must be specific if stated, or "Not stated".
- If a question was provided in "watch_for", answer it directly under "## Answer to your question".
- Output only the requested markdown format.
"""


def build_prompt(transcript_path: Path) -> str:
    content = transcript_path.read_text(encoding="utf-8")
    header, body = split_frontmatter(content)
    fields = header_fields(header)
    speakers = parse_speakers(header)

    prompt = f"""Summarize the following meeting according to the standard schema:

Meeting Title: {fields.get('title', 'Untitled')}
Recorded: {fields.get('recorded', 'Unknown')}
Context provided by user: {fields.get('context', 'None')}
Question to answer: {fields.get('watch_for', 'None')}
Known Speakers: {json.dumps(speakers, indent=2)}

Transcript and notes:
\"\"\"
{body}
\"\"\"

Output format must be:
```yaml
speakers:
  - "Speaker 1": "Name (confidence)"
speaker_evidence:
  - "Speaker 1": "evidence description"
```
followed by:
# {fields.get('title', 'Untitled')}
_{fields.get('recorded', '')} · [Duration]_

[2-3 paragraph summary overview]

## Who was in it
- [Name] ([Speaker Label], [inferred/known], [confidence]) — [talk time], [role in call]

## Answer to your question
**Question:** {fields.get('watch_for', '')}
[Answer or 'Not covered in this meeting']

## What was covered
- [Key discussion point 1]
- [Key discussion point 2]

## Decisions
- [Decision 1]
- [Decision 2]

## Action items

| Owner | Action | Due | Source | Confidence |
| --- | --- | --- | --- | --- |
| [Name] | [Specific task] | [Due date/Not stated] | [transcript/notes/both] | [high/medium/low] |

## Open questions
- [Unresolved question 1]

## Notes on transcript quality
[Notes on audio quality, speaker separation, or mic status]
"""
    return prompt


def parse_llm_response(response: str) -> tuple[dict[str, str], dict[str, str], str]:
    """Extracts speaker map, speaker evidence, and summary body from LLM output."""
    speakers = {}
    evidence = {}

    yaml_block = re.search(r"```yaml\s*\n(speakers:.*?)\n```", response, re.DOTALL)
    if yaml_block:
        ytext = yaml_block.group(1)
        in_sp = False
        in_ev = False
        for line in ytext.splitlines():
            if line.startswith("speakers:"):
                in_sp, in_ev = True, False
                continue
            elif line.startswith("speaker_evidence:"):
                in_sp, in_ev = False, True
                continue
            m = re.match(r'^\s*-\s*"(?P<k>[^"]+)":\s*"(?P<v>[^"]*)"', line)
            if m:
                if in_sp:
                    speakers[m.group("k")] = m.group("v")
                elif in_ev:
                    evidence[m.group("k")] = m.group("v")

    # Body is everything starting with "# "
    idx = response.find("\n# ")
    if idx == -1 and response.startswith("# "):
        body = response
    elif idx != -1:
        body = response[idx + 1:]
    else:
        body = response

    return speakers, evidence, body.strip()


def read_config() -> dict[str, str]:
    """Reads default settings from scripts/config.sh."""
    config = {
        "SUMMARIZER_BACKEND": "local",
        "LOCAL_LLM_MODEL": "qwen2.5:14b",
        "OLLAMA_HOST": "http://localhost:11434",
    }
    cfg_file = ROOT / "scripts" / "config.sh"
    if cfg_file.exists():
        for line in cfg_file.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            for k in config:
                if line.startswith(f"{k}="):
                    val = line.split("=", 1)[1].strip().strip('"\'')
                    if val:
                        config[k] = val
    return config


def call_local_ollama(prompt: str, model: str = "qwen2.5:14b", host: str = "http://localhost:11434") -> str:
    """Calls local Ollama server on Apple Silicon."""
    url = f"{host.rstrip('/')}/api/generate"
    payload = {
        "model": model,
        "system": SUMMARIZER_INSTRUCTIONS,
        "prompt": prompt,
        "stream": False,
        "keep_alive": 0,
        "options": {
            "temperature": 0.2,
            "num_ctx": 16384,
        }
    }
    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"}
    )
    try:
        with urllib.request.urlopen(req, timeout=300) as resp:
            result = json.loads(resp.read().decode("utf-8"))
            return result.get("response", "").strip()
    except Exception as err:
        print(f"Local Ollama model {model} failed: {err}", file=sys.stderr)
        return ""


def call_gemini(prompt: str, api_key: str) -> str:
    """Calls Gemini API."""
    candidate_models = ["gemini-3.7-flash", "gemini-3.5-flash", "gemini-flash-lite-latest"]
    data = {
        "contents": [{"parts": [{"text": SUMMARIZER_INSTRUCTIONS + "\n\n" + prompt}]}]
    }
    body_bytes = json.dumps(data).encode("utf-8")
    headers = {"Content-Type": "application/json"}

    for model in candidate_models:
        url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={api_key}"
        req = urllib.request.Request(url, data=body_bytes, headers=headers)
        try:
            with urllib.request.urlopen(req, timeout=60) as resp:
                result = json.loads(resp.read().decode("utf-8"))
                return result["candidates"][0]["content"]["parts"][0]["text"]
        except Exception as err:
            print(f"Gemini model {model} failed: {err}", file=sys.stderr)
    return ""


def call_anthropic(prompt: str, api_key: str) -> str:
    """Calls Anthropic Claude API."""
    url = "https://api.anthropic.com/v1/messages"
    data = {
        "model": "claude-3-5-sonnet-20241022",
        "max_tokens": 4096,
        "system": SUMMARIZER_INSTRUCTIONS,
        "messages": [{"role": "user", "content": prompt}]
    }
    req = urllib.request.Request(
        url,
        data=json.dumps(data).encode("utf-8"),
        headers={
            "x-api-key": api_key,
            "anthropic-version": "2023-06-01",
            "Content-Type": "application/json"
        }
    )
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            result = json.loads(resp.read().decode("utf-8"))
            return result["content"][0]["text"]
    except Exception as err:
        print(f"Anthropic call failed: {err}", file=sys.stderr)
    return ""


def call_llm(
    prompt: str,
    backend: str | None = None,
    local_model: str | None = None,
    host: str | None = None
) -> str:
    """Dispatches prompt to local Ollama, Gemini API, or Anthropic."""
    cfg = read_config()
    backend = (backend or os.environ.get("SUMMARIZER_BACKEND") or cfg.get("SUMMARIZER_BACKEND") or "local").lower()
    local_model = local_model or os.environ.get("LOCAL_LLM_MODEL") or cfg.get("LOCAL_LLM_MODEL") or "qwen2.5:14b"
    host = host or os.environ.get("OLLAMA_HOST") or cfg.get("OLLAMA_HOST") or "http://localhost:11434"

    gemini_key = os.environ.get("GEMINI_API_KEY")
    if not gemini_key:
        token_file = ROOT / ".gemini_token"
        if token_file.exists():
            gemini_key = token_file.read_text(encoding="utf-8").strip()

    anthropic_key = os.environ.get("ANTHROPIC_API_KEY")

    # 1. Local backend
    if backend in {"local", "ollama"}:
        res = call_local_ollama(prompt, model=local_model, host=host)
        if res:
            return res
        print(f"Local Ollama ({local_model}) failed. Try starting Ollama: `ollama serve`", file=sys.stderr)
        return ""

    # 2. Auto backend (try local first, fallback to cloud API)
    if backend == "auto":
        res = call_local_ollama(prompt, model=local_model, host=host)
        if res:
            return res
        print("Local model unavailable, falling back to Gemini API...", file=sys.stderr)
        if gemini_key:
            res = call_gemini(prompt, gemini_key)
            if res:
                return res
        if anthropic_key:
            res = call_anthropic(prompt, anthropic_key)
            if res:
                return res
        return ""

    # 3. Explicit Gemini backend
    if backend in {"gemini", "google"}:
        if gemini_key:
            return call_gemini(prompt, gemini_key)
        print("GEMINI_API_KEY not found.", file=sys.stderr)
        return ""

    # 4. Explicit Anthropic backend
    if backend in {"anthropic", "claude"}:
        if anthropic_key:
            return call_anthropic(prompt, anthropic_key)
        print("ANTHROPIC_API_KEY not found.", file=sys.stderr)
        return ""

    return ""


def update_action_items_doc(summary_path: Path, summary_content: str, title: str, date_str: str) -> None:
    action_doc = ROOT / "ACTION-ITEMS.md"
    existing = action_doc.read_text(encoding="utf-8") if action_doc.exists() else "# Meetings and Action Items\n\n"

    # Extract action table from summary
    table_match = re.search(r"(\| Owner \| Action \|.*?)(?=\n\n## |\Z)", summary_content, re.DOTALL)
    table_text = table_match.group(1).strip() if table_match else "| Owner | Action | Due | Source | Confidence |\n|---|---|---|---|---|\n| unassigned | No actions found | Not stated | transcript | low |"

    rel_summary = f"Summaries/{summary_path.name}"
    new_section = f"""## {title} — {date_str}

[Full summary]({rel_summary})

{table_text}
"""

    # If this summary is already in ACTION-ITEMS.md, replace its section
    pattern = re.compile(rf"## [^\n]+ — {re.escape(date_str)}.*?(?=\n## |\Z)", re.DOTALL)
    if pattern.search(existing):
        updated = pattern.sub(new_section.strip(), existing, count=1)
    else:
        # Prepend new meeting right under top header
        parts = existing.split("\n\n", 1)
        header = parts[0]
        rest = parts[1] if len(parts) > 1 else ""
        now_stamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        updated = f"# Meetings and Action Items\n_Last updated: {now_stamp}_\n\n{new_section}\n{rest}"

    action_doc.write_text(updated, encoding="utf-8")


def update_transcript_header(
    transcript_path: Path,
    speakers: dict[str, str],
    evidence: dict[str, str]
) -> None:
    text = transcript_path.read_text(encoding="utf-8")
    header, body = split_frontmatter(text)

    # Update status to summarized
    header = re.sub(r"^status:.*$", "status: summarized", header, flags=re.MULTILINE)

    # Insert evidence if speakers found
    if evidence and "speaker_evidence:" not in header:
        ev_lines = ["speaker_evidence:"]
        for k, v in evidence.items():
            ev_lines.append(f'  - "{k}": "{v}"')
        header += "\n" + "\n".join(ev_lines)

    new_content = f"---\n{header.strip()}\n---\n{body}"
    transcript_path.write_text(new_content, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--file", type=Path, help="Specific transcript file to summarize")
    parser.add_argument("--backend", choices=["auto", "local", "gemini", "anthropic"], help="Summarizer backend")
    parser.add_argument("--local-model", help="Local Ollama model name (e.g. qwen2.5:14b, llama3.1:8b)")
    parser.add_argument("--host", help="Ollama server host (default: http://localhost:11434)")
    parser.add_argument("--prompt-only", action="store_true", help="Print prompt to stdout and exit")
    parser.add_argument("--dry-run", action="store_true", help="Run without modifying files")
    args = parser.parse_args()

    files = [args.file] if args.file else sorted((ROOT / "Transcripts").glob("*.md"))

    pending = []
    for f in files:
        if not f.is_file() or f.name == ".DS_Store":
            continue
        content = f.read_text(encoding="utf-8")
        if "status: awaiting-summary" in content or args.file:
            pending.append(f)

    if not pending:
        print("No transcripts awaiting summary.")
        return 0

    print(f"Found {len(pending)} transcript(s) to process.")

    for t_path in pending:
        prompt = build_prompt(t_path)
        if args.prompt_only:
            print(f"=== Prompt for {t_path.name} ===")
            print(prompt)
            continue

        print(f"Summarizing {t_path.name} using backend '{args.backend or 'default'}'...")
        response = call_llm(prompt, backend=args.backend, local_model=args.local_model, host=args.host)

        if not response:
            print(f"Summarization failed. Check that Ollama is running (`ollama serve`) or API keys are set.", file=sys.stderr)
            return 1

        speakers, evidence, summary_body = parse_llm_response(response)
        fields = header_fields(split_frontmatter(t_path.read_text(encoding="utf-8"))[0])
        title = fields.get("title", "Untitled meeting")
        date_str = fields.get("recorded", datetime.datetime.now().strftime("%Y-%m-%d"))[:10]

        summary_file = ROOT / "Summaries" / t_path.name
        if not args.dry_run:
            summary_file.write_text(summary_body + "\n", encoding="utf-8")
            update_action_items_doc(summary_file, summary_body, title, date_str)
            update_transcript_header(t_path, speakers, evidence)
            print(f"Saved summary: Summaries/{summary_file.name}")
            print(f"Updated: ACTION-ITEMS.md and Transcripts/{t_path.name}")
        else:
            print(f"[DRY-RUN] Would write to Summaries/{summary_file.name}")
            print(summary_body[:400] + "...\n")

    return 0


if __name__ == "__main__":
    sys.exit(main())

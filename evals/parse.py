"""Parsers for RecordBot markdown: transcript headers, summary tables, action-items."""

from __future__ import annotations

import re
from pathlib import Path

SPEAKER_LINE = re.compile(
    r'^\s*-\s*"(?P<label>[^"]+)":\s*"(?P<resolved>[^"]*)"'
)
TABLE_ROW = re.compile(r"^\|(.+)\|$")
FRONTMATTER = re.compile(r"\A---\n(.*?)\n---\n?", re.DOTALL)
BLOCK_SPEAKER = re.compile(r"^\*\*(.+?)\*\*\s*·", re.MULTILINE)


def split_frontmatter(text: str) -> tuple[str, str]:
    match = FRONTMATTER.match(text)
    if not match:
        return "", text
    return match.group(1), text[match.end() :]


def parse_speakers(header: str) -> dict[str, str]:
    """Speaker label -> resolved name, including confidence suffix if present."""
    out: dict[str, str] = {}
    in_speakers = False
    for line in header.splitlines():
        if line.startswith("speakers:"):
            in_speakers = True
            continue
        if in_speakers:
            if line.startswith("speaker_evidence:") or (
                line and not line.startswith(" ") and not line.startswith("\t")
            ):
                break
            match = SPEAKER_LINE.match(line)
            if match:
                out[match.group("label")] = match.group("resolved")
    return out


def header_fields(header: str) -> dict[str, str]:
    fields: dict[str, str] = {}
    for line in header.splitlines():
        if ":" not in line or line.startswith(" ") or line.startswith("-"):
            continue
        key, _, value = line.partition(":")
        fields[key.strip()] = value.strip().strip('"')
    return fields


def canonical_name(resolved: str) -> str:
    """Gayatri (high) -> gayatri; unresolved stays unresolved."""
    name = resolved.strip()
    name = re.sub(r"\s*\((high|medium|low)\)\s*$", "", name, flags=re.I)
    return re.sub(r"\s+", " ", name).strip().lower()


def transcript_speakers_in_body(body: str) -> set[str]:
    return {match.group(1) for match in BLOCK_SPEAKER.finditer(body)}


def parse_action_table(text: str) -> list[dict[str, str]]:
    """Rows from the first markdown table after '## Action items'."""
    idx = text.lower().find("## action items")
    block = text[idx:] if idx >= 0 else text
    rows: list[dict[str, str]] = []
    headers: list[str] = []
    for line in block.splitlines():
        match = TABLE_ROW.match(line.strip())
        if not match:
            if headers and line.startswith("## "):
                break
            continue
        cells = [c.strip() for c in match.group(1).split("|")]
        if all(set(c) <= set("-: ") and c for c in cells):
            continue
        if not headers:
            headers = [c.lower() for c in cells]
            continue
        if len(cells) != len(headers):
            continue
        rows.append(dict(zip(headers, cells)))
    return rows


def stem_meeting_id(path: Path) -> str:
    """2026-08-26_21-32-40__evening-scrum-call-wd-dmod -> 2026-08-26_21-32-40"""
    name = path.name
    if name.endswith(".md"):
        name = name[:-3]
    return name.split("__", 1)[0]


def load_transcript(path: Path) -> dict:
    text = path.read_text(encoding="utf-8")
    header, body = split_frontmatter(text)
    fields = header_fields(header)
    return {
        "path": path,
        "id": stem_meeting_id(path),
        "fields": fields,
        "speakers": parse_speakers(header),
        "body": body,
        "body_speakers": transcript_speakers_in_body(body),
        "text": text,
    }


def load_summary(path: Path) -> dict:
    text = path.read_text(encoding="utf-8")
    return {
        "path": path,
        "id": stem_meeting_id(path),
        "actions": parse_action_table(text),
        "text": text,
        "title": text.splitlines()[0].lstrip("# ").strip() if text else "",
    }


def unnamed_owner(owner: str) -> bool:
    lowered = owner.strip().lower()
    if not lowered or lowered in {"unassigned", "unknown", "?"}:
        return True
    if re.match(r"^speaker\s+\d+\b", lowered):
        return True
    if "name not clear" in lowered or "name uncertain" in lowered:
        return True
    return False

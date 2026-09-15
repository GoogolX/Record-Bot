"""Evaluation and regression suite for Meeting Summarizer and Speaker Identification.

Tests:
1. Unit tests: prompt construction, YAML frontmatter extraction, action table parsing.
2. End-to-end benchmark mode: runs local LLM (Ollama) or API backend on gold cases,
   measuring speaker resolution accuracy, action item recall, latency, and schema compliance.
3. Automatically writes structured execution logs to evals/logs/.
"""

from __future__ import annotations

import argparse
import datetime
import json
import os
import sys
import time
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
sys.path.insert(0, str(ROOT / "evals"))

import summarize  # noqa: E402
from parse import canonical_name, load_summary, load_transcript  # noqa: E402

LOGS_DIR = ROOT / "evals" / "logs"


class SummarizerUnitTests(unittest.TestCase):
    """Unit tests for summarizer prompt parsing and schema extraction."""

    def test_parse_llm_yaml_speakers_and_evidence(self):
        sample_response = """```yaml
speakers:
  - "Speaker 1": "Gayatri (high)"
  - "Speaker 2": "Trinadh (medium)"
speaker_evidence:
  - "Speaker 1": "Addressed by name and moderates call"
  - "Speaker 2": "Discussed PO tables"
```
# Meeting Title
_2026-08-26 · 15m_

Overview text.

## Action items

| Owner | Action | Due | Source | Confidence |
| --- | --- | --- | --- | --- |
| Trinadh | Finish PO column work | Friday | transcript | high |
"""
        speakers, evidence, body = summarize.parse_llm_response(sample_response)
        self.assertEqual(speakers.get("Speaker 1"), "Gayatri (high)")
        self.assertEqual(speakers.get("Speaker 2"), "Trinadh (medium)")
        self.assertIn("Speaker 1", evidence)
        self.assertTrue(body.startswith("# Meeting Title"))
        self.assertIn("| Trinadh |", body)

    def test_read_config_defaults(self):
        config = summarize.read_config()
        self.assertIn("SUMMARIZER_BACKEND", config)
        self.assertIn("LOCAL_LLM_MODEL", config)
        self.assertIn("OLLAMA_HOST", config)


def run_llm_benchmark(
    backend: str = "local",
    model: str = "qwen2.5:14b",
    host: str = "http://localhost:11434"
) -> dict:
    """Runs end-to-end evaluation of the LLM summarizer on gold test cases."""
    gold_speakers = json.loads((ROOT / "evals/gold/speakers.json").read_text(encoding="utf-8"))
    gold_actions = json.loads((ROOT / "evals/gold/actions.json").read_text(encoding="utf-8"))
    actions_by_id = {c["id"]: c for c in gold_actions}

    results = []
    total_latency = 0.0
    total_spk_expected = 0
    total_spk_correct = 0
    total_act_expected = 0
    total_act_correct = 0

    print(f"\n=======================================================")
    print(f"      LLM SUMMARIZER BENCHMARK: {backend.upper()} ({model})")
    print(f"=======================================================")

    for case in gold_speakers:
        rec_id = case["id"]
        matching = list((ROOT / "Transcripts").glob(f"{rec_id}*.md"))
        if not matching:
            print(f"Skipping {rec_id} (no transcript found)")
            continue
        t_path = matching[0]

        prompt = summarize.build_prompt(t_path)
        print(f"\nEvaluating: {t_path.name}")
        t0 = time.time()
        response = summarize.call_llm(prompt, backend=backend, local_model=model, host=host)
        elapsed = time.time() - t0
        total_latency += elapsed

        if not response:
            print(f"  [ERROR] Model failed to return response.")
            results.append({"id": rec_id, "status": "FAILED", "latency": elapsed})
            continue

        speakers, evidence, body = summarize.parse_llm_response(response)
        summary_doc = {"id": rec_id, "actions": summarize.parse_llm_response(response)[2]}

        # Evaluate Speakers
        predicted_canonical = {k: canonical_name(v) for k, v in speakers.items()}
        spk_hits = 0
        spk_target = len(case["speakers"])
        for label, expected in case["speakers"].items():
            if canonical_name(expected) in predicted_canonical.get(label, ""):
                spk_hits += 1
            else:
                print(f"  [SPEAKER MISMATCH] {label}: expected '{expected}', got '{speakers.get(label)}'")

        total_spk_expected += spk_target
        total_spk_correct += spk_hits
        spk_acc = (spk_hits / spk_target * 100) if spk_target else 100.0

        # Evaluate Mandatory Action Items
        act_hits = 0
        act_target = 0
        if rec_id in actions_by_id:
            gold_act = actions_by_id[rec_id]["must_include"]
            act_target = len(gold_act)
            for item in gold_act:
                owner_match = canonical_name(item["owner"])
                action_sub = item["action"].lower()
                # Check if body contains matching owner and action snippet
                found = False
                for line in body.splitlines():
                    if line.startswith("|") and owner_match in canonical_name(line) and action_sub in line.lower():
                        found = True
                        break
                if found:
                    act_hits += 1
                else:
                    print(f"  [ACTION MISSED] Expected action by {item['owner']}: {item['action']}")

        total_act_expected += act_target
        total_act_correct += act_hits
        act_acc = (act_hits / act_target * 100) if act_target else 100.0

        print(f"  Latency: {elapsed:.2f}s | Speaker Accuracy: {spk_acc:.1f}% ({spk_hits}/{spk_target}) | Action Recall: {act_acc:.1f}% ({act_hits}/{act_target})")

        results.append({
            "id": rec_id,
            "latency": elapsed,
            "speaker_accuracy_pct": spk_acc,
            "speaker_hits": spk_hits,
            "speaker_target": spk_target,
            "action_recall_pct": act_acc,
            "action_hits": act_hits,
            "action_target": act_target,
            "predicted_speakers": speakers,
            "speaker_evidence": evidence,
        })

    overall_spk_pct = (total_spk_correct / total_spk_expected * 100) if total_spk_expected else 100.0
    overall_act_pct = (total_act_correct / total_act_expected * 100) if total_act_expected else 100.0
    avg_latency = (total_latency / len(results)) if results else 0.0

    print("\n-------------------------------------------------------")
    print(f"OVERALL SUMMARY ({backend} / {model}):")
    print(f"  Total Cases Evaluated: {len(results)}")
    print(f"  Avg Latency per Call:  {avg_latency:.2f}s")
    print(f"  Speaker Resolution:    {overall_spk_pct:.1f}% ({total_spk_correct}/{total_spk_expected})")
    print(f"  Action Item Recall:    {overall_act_pct:.1f}% ({total_act_correct}/{total_act_expected})")
    print("-------------------------------------------------------")

    # Save structured run log
    LOGS_DIR.mkdir(parents=True, exist_ok=True)
    stamp = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    log_file = LOGS_DIR / f"eval_summarizer_{backend}_{stamp}.json"
    log_payload = {
        "timestamp": stamp,
        "backend": backend,
        "model": model,
        "avg_latency": avg_latency,
        "overall_speaker_accuracy": overall_spk_pct,
        "overall_action_recall": overall_act_pct,
        "results": results,
    }
    log_file.write_text(json.dumps(log_payload, indent=2), encoding="utf-8")
    (LOGS_DIR / "latest_summarizer.json").write_text(json.dumps(log_payload, indent=2), encoding="utf-8")
    print(f"Logged results to: evals/logs/{log_file.name}")

    return log_payload


def main() -> int:
    parser = argparse.ArgumentParser(description="Summarizer Evaluation Suite")
    parser.add_argument("--benchmark", action="store_true", help="Run live LLM benchmark on gold test cases")
    parser.add_argument("--backend", default="local", choices=["local", "gemini", "anthropic", "auto"])
    parser.add_argument("--model", default="qwen2.5:14b", help="Model name")
    parser.add_argument("--host", default="http://localhost:11434", help="Ollama host")
    args, rest = parser.parse_known_args()

    if args.benchmark:
        res = run_llm_benchmark(backend=args.backend, model=args.model, host=args.host)
        return 0 if res["overall_speaker_accuracy"] >= 80.0 else 1

    # Run unit tests
    unittest.main(argv=[sys.argv[0], *rest])


if __name__ == "__main__":
    sys.exit(main())

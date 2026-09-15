"""Regression against frozen speaker maps and must-include action items."""

from __future__ import annotations

import json
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))

from parse import canonical_name, load_summary, load_transcript  # noqa: E402


def _summaries_by_id() -> dict[str, dict]:
    return {doc["id"]: doc for p in (ROOT / "Summaries").glob("*.md") if (doc := load_summary(p))}


def _transcripts_by_id() -> dict[str, dict]:
    return {doc["id"]: doc for p in (ROOT / "Transcripts").glob("*.md") if (doc := load_transcript(p))}


def _contains(haystack: str, needle: str) -> bool:
    return canonical_name(needle) in canonical_name(haystack) or canonical_name(needle) in haystack.lower()


class SpeakerGold(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.gold = json.loads((ROOT / "evals/gold/speakers.json").read_text(encoding="utf-8"))
        cls.transcripts = _transcripts_by_id()

    def test_named_speakers_match(self):
        for case in self.gold:
            doc = self.transcripts.get(case["id"])
            with self.subTest(case["id"]):
                if doc is None:
                    self.fail(f"no transcript for gold case {case['id']}")
                predicted = {k: canonical_name(v) for k, v in doc["speakers"].items()}
                for label, expected in case["speakers"].items():
                    self.assertIn(label, predicted, f"missing {label}")
                    self.assertEqual(predicted[label], canonical_name(expected))
                for label in case.get("unresolved", []):
                    self.assertEqual(predicted.get(label), "unresolved")


class ActionGold(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.gold = json.loads((ROOT / "evals/gold/actions.json").read_text(encoding="utf-8"))
        cls.summaries = _summaries_by_id()

    def test_must_include_actions(self):
        for case in self.gold:
            doc = self.summaries.get(case["id"])
            with self.subTest(case["id"]):
                if doc is None:
                    self.fail(f"no summary for gold case {case['id']}")
                rows = doc["actions"]
                for item in case["must_include"]:
                    hits = [
                        row
                        for row in rows
                        if canonical_name(item["owner"]) in canonical_name(row.get("owner", ""))
                        and _contains(row.get("action", ""), item["action"])
                    ]
                    self.assertTrue(
                        hits,
                        f"missing action owner={item['owner']!r} containing {item['action']!r}",
                    )

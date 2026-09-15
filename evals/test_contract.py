"""Schema checks on live Transcripts/, Summaries/, and ACTION-ITEMS.md."""

from __future__ import annotations

import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))

from parse import load_summary, load_transcript, parse_action_table, stem_meeting_id  # noqa: E402

ALLOWED_STATUS = {"awaiting-summary", "summarized", "skipped"}
REQUIRED_HEADER = {"title", "recorded", "status", "duration_seconds", "model", "language"}
REQUIRED_ACTION_COLS = {"owner", "action", "due", "source", "confidence"}


class TranscriptContract(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        folder = ROOT / "Transcripts"
        cls.files = sorted(p for p in folder.glob("*.md") if p.name != ".DS_Store")

    def test_at_least_one_transcript_or_skip(self):
        if not self.files:
            self.skipTest("no transcripts yet")

    def test_frontmatter_and_status(self):
        self.assertTrue(self.files, "no transcripts")
        for path in self.files:
            with self.subTest(path.name):
                doc = load_transcript(path)
                missing = REQUIRED_HEADER - set(doc["fields"])
                self.assertFalse(missing, f"{path.name} missing {missing}")
                self.assertIn(doc["fields"]["status"], ALLOWED_STATUS)
                self.assertIn("## Transcript", doc["body"])

    def test_summarized_has_matching_summary(self):
        summaries = {stem_meeting_id(p) for p in (ROOT / "Summaries").glob("*.md")}
        for path in self.files:
            doc = load_transcript(path)
            if doc["fields"].get("status") != "summarized":
                continue
            with self.subTest(path.name):
                self.assertIn(doc["id"], summaries)


class SummaryContract(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.files = sorted(p for p in (ROOT / "Summaries").glob("*.md") if p.name != ".DS_Store")

    def test_action_tables(self):
        self.assertTrue(self.files, "no summaries")
        for path in self.files:
            with self.subTest(path.name):
                doc = load_summary(path)
                self.assertTrue(doc["actions"], f"{path.name} has no action rows")
                for row in doc["actions"]:
                    self.assertTrue(REQUIRED_ACTION_COLS <= set(row), row.keys())
                    self.assertIn(row["confidence"].lower(), {"high", "medium", "low"})
                    self.assertIn(row["source"].lower(), {"transcript", "notes", "both"})


class ActionItemsIndexContract(unittest.TestCase):
    def test_index_covers_every_summary(self):
        index = ROOT / "ACTION-ITEMS.md"
        self.assertTrue(index.exists())
        text = index.read_text(encoding="utf-8")
        for path in sorted((ROOT / "Summaries").glob("*.md")):
            with self.subTest(path.name):
                self.assertIn(path.name, text)
                summary_rows = load_summary(path)["actions"]
                index_rows = parse_action_table(
                    text[text.find(path.name) :] if path.name in text else ""
                )
                self.assertEqual(
                    [(r.get("owner"), r.get("action")) for r in summary_rows],
                    [(r.get("owner"), r.get("action")) for r in index_rows],
                    f"ACTION-ITEMS.md drifted from {path.name}",
                )

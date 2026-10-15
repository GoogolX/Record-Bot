"""Regression tests for the live quality scorecard."""

from __future__ import annotations

import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "evals"))

from quality import unresolved_speaker  # noqa: E402


class UnresolvedSpeakerTests(unittest.TestCase):
    def test_common_placeholders_are_unresolved(self):
        for value in ("", " ", "?", "Unresolved", "UNKNOWN", "n/a"):
            with self.subTest(value=value):
                self.assertTrue(unresolved_speaker(value))

    def test_real_names_are_resolved(self):
        for value in ("Kaushik", "Speaker One", "Ravi"):
            with self.subTest(value=value):
                self.assertFalse(unresolved_speaker(value))


if __name__ == "__main__":
    unittest.main()

#!/usr/bin/env python3
"""Sandbox-only summary stand-in used by queue integration tests."""
import os
import sys
import time
from pathlib import Path

root = Path(os.environ.get("QUEUE_ROOT", Path(__file__).resolve().parent.parent))
transcript = Path(sys.argv[2] if len(sys.argv) > 2 and sys.argv[1] == "--file" else sys.argv[1])
if not transcript.is_file():
    raise SystemExit(f"Transcript not found: {transcript}")
print(f"Mock summarizing {transcript.name}...", flush=True)
time.sleep(float(os.environ.get("MOCK_JOB_SECONDS", "0.1")))
(root / "Summaries" / transcript.name).write_text("Sandbox test summary\n", encoding="utf-8")
print(f"Finished {transcript.name}")

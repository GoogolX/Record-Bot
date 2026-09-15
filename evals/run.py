#!/usr/bin/env python3
"""Run RecordBot evals.

  python evals/run.py              # unit + contract + gold, then a quality audit
  python evals/run.py --unit
  python evals/run.py --contract
  python evals/run.py --gold
  python evals/run.py --quality    # audit only, always exits 0
  python evals/run.py --strict-quality   # fail if speakers stay unresolved or owners are Speaker N

Gold files in evals/gold/ are a freeze of what a good run should still contain.
Edit them when you correct a speaker name or decide an action item was wrong.
The quality audit is the live scorecard over whatever is in Transcripts/ and Summaries/.
"""

from __future__ import annotations

import argparse
import os
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EVALS = Path(__file__).resolve().parent
VENV_PY = ROOT / "vendor/venv/bin/python"

# Attribution tests import scripts/attribute.py, which needs numpy from the
# diarization venv. Re-exec there when the caller used system python3.
if VENV_PY.exists() and Path(sys.executable).resolve() != VENV_PY.resolve():
    os.execv(str(VENV_PY), [str(VENV_PY), *sys.argv])

sys.path.insert(0, str(EVALS))

from quality import audit, format_report  # noqa: E402

import datetime
import io

LOGS_DIR = ROOT / "evals" / "logs"

SUITES = {
    "unit": "test_attribute",
    "summarizer": "test_summarizer",
    "contract": "test_contract",
    "gold": "test_gold",
}


def run_suite(name: str) -> unittest.TestResult:
    loader = unittest.TestLoader()
    suite = loader.loadTestsFromName(name)
    runner = unittest.TextTestRunner(verbosity=2)
    return runner.run(suite)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--unit", action="store_true")
    parser.add_argument("--summarizer", action="store_true")
    parser.add_argument("--contract", action="store_true")
    parser.add_argument("--gold", action="store_true")
    parser.add_argument("--quality", action="store_true")
    parser.add_argument("--strict-quality", action="store_true")
    parser.add_argument("--benchmark-summarizer", action="store_true", help="Run end-to-end LLM benchmark")
    parser.add_argument("--backend", default="local", choices=["local", "gemini", "anthropic", "auto"])
    parser.add_argument("--model", default="qwen2.5:14b", help="Model name for benchmark")
    args = parser.parse_args()

    if args.benchmark_summarizer:
        import test_summarizer
        res = test_summarizer.run_llm_benchmark(backend=args.backend, model=args.model)
        return 0 if res["overall_speaker_accuracy"] >= 80.0 else 1

    selected = [key for key in SUITES if getattr(args, key)]
    quality_only = args.quality and not selected and not args.strict_quality
    if not selected and not args.quality:
        selected = list(SUITES)

    failed = False
    log_stream = io.StringIO()

    for key in selected:
        print(f"\n=== {key} ===")
        log_stream.write(f"\n=== {key} ===\n")
        result = run_suite(SUITES[key])
        if not result.wasSuccessful():
            failed = True

    if selected or args.quality or args.strict_quality:
        if not quality_only:
            print("\n=== quality ===")
            log_stream.write("\n=== quality ===\n")
        report = audit()
        rep_str = format_report(report)
        print(rep_str)
        log_stream.write(rep_str + "\n")
        if args.strict_quality:
            if report["speaker_unresolved"] or report["actions_unnamed_owner"] or report["orphan_summaries"]:
                failed = True

    # Write execution log
    try:
        LOGS_DIR.mkdir(parents=True, exist_ok=True)
        stamp = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        log_text = log_stream.getvalue()
        (LOGS_DIR / "latest_eval.log").write_text(log_text, encoding="utf-8")
        (LOGS_DIR / f"eval_run_{stamp}.log").write_text(log_text, encoding="utf-8")
    except Exception as e:
        print(f"Failed to write eval log: {e}", file=sys.stderr)

    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())

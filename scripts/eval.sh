#!/bin/bash
# RecordBot evals. Safe to run any time; does not touch recordings.
#
#   ./scripts/eval.sh
#   ./scripts/eval.sh --gold
#   ./scripts/eval.sh --quality
#   ./scripts/eval.sh --benchmark
set -uo pipefail

HOME_DIR="${RECORDBOT_HOME:-$(cd "$(dirname "$0")/.." && pwd)}"
PY="$HOME_DIR/vendor/venv/bin/python"
[ -x "$PY" ] || PY="$(command -v python3)"

if [ "${1:-}" = "--benchmark" ]; then
  shift
  exec "$PY" "$HOME_DIR/evals/reference_gemini.py" "$@"
fi

exec "$PY" "$HOME_DIR/evals/run.py" "$@"

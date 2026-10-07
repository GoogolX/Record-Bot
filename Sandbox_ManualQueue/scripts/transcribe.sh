#!/bin/bash
set -euo pipefail
ROOT_DIR="${QUEUE_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
wav="${1:?audio path required}"
base="$(basename "$wav" .wav)"
[[ -f "$wav" ]] || { echo "Recording not found: $wav" >&2; exit 1; }
printf 'Mock transcribing %s...\n' "$base"
sleep "${MOCK_JOB_SECONDS:-0.1}"
printf '%s\n' '---' 'status: awaiting-summary' '---' "Mock transcript for $base" > "$ROOT_DIR/Transcripts/${base}__mock-title.md"
printf 'Finished %s\n' "$base"

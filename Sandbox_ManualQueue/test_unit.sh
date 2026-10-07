#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
TMP="$HERE/.test-tmp/unit"
trap 'rm -rf "$TMP"' EXIT
rm -rf "$TMP"
mkdir -p "$TMP/Recordings" "$TMP/Transcripts" "$TMP/Summaries"
touch "$TMP/Recordings/2026-01-01_10-00-00.wav" \
      "$TMP/Recordings/2026-01-01_10-00-00.mic.wav" \
      "$TMP/Recordings/2026-01-01_10-00-01.wav" \
      "$TMP/Recordings/meeting with spaces.wav"
touch "$TMP/Transcripts/2026-01-01_10-00-00__planning.md" \
      "$TMP/Transcripts/2026-01-01_10-00-010__prefix-collision.md"
touch "$TMP/Summaries/2026-01-01_10-00-00__planning.md"

mgr="$HERE/scripts/queue_manager.sh"
actual="$(QUEUE_ROOT="$TMP" "$mgr" list_transcribe)"
[[ "$actual" == *"2026-01-01_10-00-01"* ]] || { echo "FAIL: missing pending wav: $actual"; exit 1; }
[[ "$actual" == *"meeting with spaces"* ]] || { echo "FAIL: spaces mishandled: $actual"; exit 1; }
[[ "$actual" != *".mic.wav"* ]] || { echo "FAIL: mic track counted"; exit 1; }
[[ "$actual" != *"2026-01-01_10-00-00"* ]] || { echo "FAIL: transcript pairing failed"; exit 1; }

summaries="$(QUEUE_ROOT="$TMP" "$mgr" list_summarize)"
[[ "$summaries" == *"2026-01-01_10-00-010__prefix-collision.md"* ]] || { echo "FAIL: missing pending summary: $summaries"; exit 1; }
[[ "$summaries" != *"2026-01-01_10-00-00__planning.md"* ]] || { echo "FAIL: existing summary counted"; exit 1; }

state="$(QUEUE_ROOT="$TMP" "$mgr" count)"
python3 - "$TMP/.state/status.json" <<'PY'
import json, sys
d=json.load(open(sys.argv[1]))
assert d['pending_transcribe'] == 2, d
assert d['pending_summarize'] == 1, d
assert d['status'] == 'idle', d
PY
QUEUE_ROOT="$TMP" "$mgr" set_status transcribing 'Transcribing (1/2)...' ''
python3 - "$TMP/.state/status.json" <<'PY'
import json, sys
d=json.load(open(sys.argv[1]))
assert d['status'] == 'transcribing' and d['transcribe_progress'] == 'Transcribing (1/2)...', d
PY
echo "Unit and regression checks passed."

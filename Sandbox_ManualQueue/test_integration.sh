#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$HERE/.." && pwd)"
TMP="$HERE/.test-tmp/integration"
export QUEUE_ROOT="$TMP"
export QUEUE_TRANSCRIBE_SCRIPT="$HERE/scripts/transcribe.sh"
export QUEUE_SUMMARIZE_SCRIPT="$HERE/scripts/summarize.py"
export MOCK_JOB_SECONDS=0.05
trap 'rm -rf "$TMP"' EXIT
rm -rf "$TMP"
mkdir -p "$TMP/Recordings" "$TMP/Transcripts" "$TMP/Summaries"
touch "$TMP/Recordings/2026-02-01_09-00-00.wav" \
      "$TMP/Recordings/2026-02-01_09-00-00.mic.wav" \
      "$TMP/Recordings/2026-02-01_09-01-00.wav"
printf '%s\n' '---' 'status: awaiting-summary' '---' 'existing transcript' > "$TMP/Transcripts/2026-02-01_08-00-00__already-done.md"

mgr="$PROJECT_ROOT/scripts/queue_manager.sh"
processor="$PROJECT_ROOT/scripts/process_queue.sh"
state="$TMP/.state/status.json"

"$mgr" count >/dev/null
python3 - "$state" <<'PY'
import json, sys
d=json.load(open(sys.argv[1]))
assert d['pending_transcribe'] == 2, d
assert d['pending_summarize'] == 1, d
PY

# A live lock prevents a second click from starting a duplicate batch.
mkdir "$TMP/.state/process.lock"
if "$processor" all; then echo "FAIL: duplicate processor was accepted"; exit 1; fi
rmdir "$TMP/.state/process.lock"

"$processor" transcribe
python3 - "$state" "$TMP" <<'PY'
import json, pathlib, sys
d=json.load(open(sys.argv[1])); root=pathlib.Path(sys.argv[2])
assert d['pending_transcribe'] == 0, d
assert d['pending_summarize'] == 3, d
assert d['status'] == 'idle' and not d['transcribe_progress'], d
assert not list((root/'Summaries').glob('*.md')), 'transcription auto-ran summary'
assert (root/'Transcripts/2026-02-01_09-00-00__mock-title.md').is_file()
assert (root/'Transcripts/2026-02-01_09-01-00__mock-title.md').is_file()
assert not (root/'Transcripts/2026-02-01_09-00-00.mic__mock-title.md').exists()
PY

"$processor" summarize
mkdir "$TMP/.state/process.lock"
printf '99999999\n' > "$TMP/.state/process.lock/pid"
"$processor" summarize
python3 - "$state" "$TMP" <<'PY'
import json, pathlib, sys
d=json.load(open(sys.argv[1])); root=pathlib.Path(sys.argv[2])
assert d['pending_transcribe'] == 0 and d['pending_summarize'] == 0, d
assert d['status'] == 'idle' and not d['summarize_progress'], d
assert len(list((root/'Summaries').glob('*.md'))) == 3
log=(root/'.state/queue.log').read_text()
assert 'Starting transcription for 2026-02-01_09-00-00 (1/2)' in log
assert 'Starting transcription for 2026-02-01_09-01-00 (2/2)' in log
assert 'Starting summary for 2026-02-01_08-00-00__already-done.md (1/3)' in log
assert 'Queue processing finished (summarize).' in log
assert 'Removing stale queue lock from PID 99999999.' in log
PY
echo "Queue integration checks passed."

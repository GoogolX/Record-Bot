#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${RECORDBOT_HOME:-${QUEUE_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}}"
REC_DIR="$ROOT_DIR/Recordings"
TRANS_DIR="$ROOT_DIR/Transcripts"
SUM_DIR="$ROOT_DIR/Summaries"
STATE_DIR="$ROOT_DIR/.state"
STATE_FILE="$STATE_DIR/status.json"
LOG_FILE="$STATE_DIR/queue.log"
mkdir -p "$STATE_DIR" "$REC_DIR" "$TRANS_DIR" "$SUM_DIR"

log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "$LOG_FILE"
}

list_transcriptions() {
    local wav base transcript found
    shopt -s nullglob
    for wav in "$REC_DIR"/*.wav; do
        [[ "$wav" == *.mic.wav ]] && continue
        base="$(basename "$wav" .wav)"
        found=0
        for transcript in "$TRANS_DIR/$base.md" "$TRANS_DIR/$base"__*.md; do
            if [[ -f "$transcript" ]]; then found=1; break; fi
        done
        (( found )) || printf '%s\n' "$base"
    done
}

list_summaries() {
    local transcript filename
    shopt -s nullglob
    for transcript in "$TRANS_DIR"/*.md; do
        [[ -f "$transcript" ]] || continue
        filename="$(basename "$transcript")"
        if grep -q '^status: awaiting-summary$' "$transcript" && [[ ! -f "$SUM_DIR/$filename" ]]; then
            printf '%s\n' "$filename"
        fi
    done
}

refresh_counts() {
    local pending_t=0 pending_s=0 item
    while IFS= read -r item; do [[ -n "$item" ]] && pending_t=$((pending_t + 1)); done < <(list_transcriptions)
    while IFS= read -r item; do [[ -n "$item" ]] && pending_s=$((pending_s + 1)); done < <(list_summaries)
    python3 - "$STATE_FILE" "$pending_t" "$pending_s" <<'PY'
import json, os, sys, tempfile
path, pending_t, pending_s = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
try:
    with open(path, encoding="utf-8") as f: state = json.load(f)
except (OSError, ValueError):
    state = {"status": "idle", "transcribe_progress": "", "summarize_progress": ""}
state.update(pending_transcribe=pending_t, pending_summarize=pending_s)
fd, temp_path = tempfile.mkstemp(prefix="status.", dir=os.path.dirname(path))
try:
    with os.fdopen(fd, "w", encoding="utf-8") as f: json.dump(state, f)
    os.replace(temp_path, path)
finally:
    try: os.unlink(temp_path)
    except FileNotFoundError: pass
PY
}

set_status() {
    local status="$1" transcribe_progress="${2:-}" summarize_progress="${3:-}"
    refresh_counts
    python3 - "$STATE_FILE" "$status" "$transcribe_progress" "$summarize_progress" <<'PY'
import json, os, sys, tempfile
path, status, transcribe_progress, summarize_progress = sys.argv[1:]
with open(path, encoding="utf-8") as f: state = json.load(f)
state.update(status=status, transcribe_progress=transcribe_progress,
             summarize_progress=summarize_progress)
fd, temp_path = tempfile.mkstemp(prefix="status.", dir=os.path.dirname(path))
try:
    with os.fdopen(fd, "w", encoding="utf-8") as f: json.dump(state, f)
    os.replace(temp_path, path)
finally:
    try: os.unlink(temp_path)
    except FileNotFoundError: pass
PY
}

case "${1:-}" in
    count) refresh_counts; cat "$STATE_FILE" ;;
    list_transcribe) list_transcriptions ;;
    list_summarize) list_summaries ;;
    set_status) [[ $# -ge 2 ]] || exit 2; set_status "$2" "${3:-}" "${4:-}" ;;
    log) shift; log "$*" ;;
    *) echo "Usage: $0 {count|list_transcribe|list_summarize|set_status <status> [transcribe_progress] [summarize_progress]|log <message>}" >&2; exit 2 ;;
esac

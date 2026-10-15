#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${QUEUE_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
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
    local wav base found transcript
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
    local transcript filename stem summary found
    shopt -s nullglob
    for transcript in "$TRANS_DIR"/*.md; do
        [[ -f "$transcript" ]] || continue
        filename="$(basename "$transcript")"
        stem="${filename%.md}"
        found=0
        for summary in "$SUM_DIR/$filename" "$SUM_DIR/$stem"__*.md; do
            if [[ -f "$summary" ]]; then found=1; break; fi
        done
        (( found )) || printf '%s\n' "$filename"
    done
}

write_state() {
    local status="$1" transcribe_progress="$2" summarize_progress="$3" pending_t="$4" pending_s="$5"
    python3 - "$STATE_FILE" "$status" "$transcribe_progress" "$summarize_progress" "$pending_t" "$pending_s" <<'PY'
import json, os, sys, tempfile
path, status, tp, sp, pt, ps = sys.argv[1:]
try:
    with open(path, encoding="utf-8") as f: old = json.load(f)
except (OSError, ValueError):
    old = {}
old.update(status=status, transcribe_progress=tp, summarize_progress=sp,
           pending_transcribe=int(pt), pending_summarize=int(ps))
fd, tmp = tempfile.mkstemp(prefix="status.", dir=os.path.dirname(path))
try:
    with os.fdopen(fd, "w", encoding="utf-8") as f: json.dump(old, f)
    os.replace(tmp, path)
finally:
    try: os.unlink(tmp)
    except FileNotFoundError: pass
PY
}

refresh_counts() {
    local count_t=0 count_s=0 item
    while IFS= read -r item; do [[ -n "$item" ]] && count_t=$((count_t + 1)); done < <(list_transcriptions)
    while IFS= read -r item; do [[ -n "$item" ]] && count_s=$((count_s + 1)); done < <(list_summaries)
    python3 - "$STATE_FILE" "$count_t" "$count_s" <<'PY'
import json, os, sys, tempfile
path, ct, cs = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
try:
    with open(path, encoding="utf-8") as f: d=json.load(f)
except (OSError, ValueError):
    d={"status":"idle", "transcribe_progress":"", "summarize_progress":""}
d.update(pending_transcribe=ct, pending_summarize=cs)
fd,tmp=tempfile.mkstemp(prefix="status.",dir=os.path.dirname(path))
try:
    with os.fdopen(fd,"w",encoding="utf-8") as f: json.dump(d,f)
    os.replace(tmp,path)
finally:
    try: os.unlink(tmp)
    except FileNotFoundError: pass
PY
}

case "${1:-}" in
    count)
        refresh_counts
        cat "$STATE_FILE"
        ;;
    list_transcribe) list_transcriptions ;;
    list_summarize) list_summaries ;;
    set_status)
        refresh_counts
        write_state "$2" "${3:-}" "${4:-}" "$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["pending_transcribe"])' "$STATE_FILE")" "$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["pending_summarize"])' "$STATE_FILE")"
        ;;
    log) log "${*:2}" ;;
    *) echo "Usage: $0 {count|list_transcribe|list_summarize|set_status <status> [transcribe_progress] [summarize_progress]|log <message>}" >&2; exit 2 ;;
esac

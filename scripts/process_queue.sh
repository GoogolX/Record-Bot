#!/bin/bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${RECORDBOT_HOME:-${QUEUE_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}}"
Q_MGR="$SCRIPT_DIR/queue_manager.sh"
TRANSCRIBE_SCRIPT="${QUEUE_TRANSCRIBE_SCRIPT:-$SCRIPT_DIR/transcribe.sh}"
SUMMARY_SCRIPT="${QUEUE_SUMMARIZE_SCRIPT:-$SCRIPT_DIR/summarize.py}"
SUMMARY_PYTHON="${QUEUE_SUMMARIZE_PYTHON:-$ROOT_DIR/vendor/venv/bin/python}"
[[ -x "$SUMMARY_PYTHON" ]] || SUMMARY_PYTHON="$(command -v python3)"
LOCK_DIR="$ROOT_DIR/.state/process.lock"
mkdir -p "$ROOT_DIR/.state"

log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "$ROOT_DIR/.state/queue.log"
}

set_state() { "$Q_MGR" set_status "$1" "${2:-}" "${3:-}"; }

process_transcriptions() {
    local requested_base="${1:-}"
    local -a pending=()
    local base total count=0
    if [[ -n "$requested_base" ]]; then
        # Accept only a single recording basename; never let an argument escape Recordings/.
        if [[ "$requested_base" == */* || "$requested_base" == *$'\n'* || "$requested_base" == *.mic ]]; then
            log "Rejected invalid targeted transcription name: $requested_base"
            return 2
        fi
        while IFS= read -r base; do
            [[ "$base" == "$requested_base" ]] && pending+=("$base")
        done < <("$Q_MGR" list_transcribe)
        if ((${#pending[@]} == 0)); then
            log "Targeted transcription skipped: $requested_base is missing or already transcribed."
            return 2
        fi
    else
        while IFS= read -r base; do [[ -n "$base" ]] && pending+=("$base"); done < <("$Q_MGR" list_transcribe)
    fi
    total=${#pending[@]}
    for base in "${pending[@]}"; do
        count=$((count + 1))
        log "Starting transcription for $base ($count/$total)"
        set_state transcribing "Transcribing ($count/$total)..." ""
        if RECORDBOT_HOME="$ROOT_DIR" /bin/bash "$TRANSCRIBE_SCRIPT" "$ROOT_DIR/Recordings/$base.wav" >> "$ROOT_DIR/.state/queue.log" 2>&1; then
            log "Transcription completed for $base"
        else
            result=$?
            log "ERROR: Transcription failed for $base (exit $result)"
        fi
        "$Q_MGR" count >/dev/null
    done
}

process_summaries() {
    local -a pending=()
    local filename total count=0
    while IFS= read -r filename; do [[ -n "$filename" ]] && pending+=("$filename"); done < <("$Q_MGR" list_summarize)
    total=${#pending[@]}
    for filename in "${pending[@]}"; do
        count=$((count + 1))
        log "Starting summary for $filename ($count/$total)"
        set_state summarizing "" "Summarizing ($count/$total)..."
        if RECORDBOT_HOME="$ROOT_DIR" "$SUMMARY_PYTHON" "$SUMMARY_SCRIPT" --file "$ROOT_DIR/Transcripts/$filename" >> "$ROOT_DIR/.state/queue.log" 2>&1; then
            log "Summary completed for $filename"
        else
            result=$?
            log "ERROR: Summary failed for $filename (exit $result)"
        fi
        "$Q_MGR" count >/dev/null
    done
}

action="${1:-}"
requested_base="${2:-}"
case "$action" in
    transcribe|summarize|all) ;;
    transcribe-one) [[ -n "$requested_base" ]] || { echo "Usage: $0 transcribe-one <recording-basename>" >&2; exit 2; } ;;
    *) echo "Usage: $0 {transcribe|summarize|all|transcribe-one <recording-basename>}" >&2; exit 2 ;;
esac

# mkdir is atomic, preventing simultaneous button clicks from starting two batches.
if ! mkdir "$LOCK_DIR" 2>/dev/null; then
    lock_pid=""
    [[ -f "$LOCK_DIR/pid" ]] && read -r lock_pid < "$LOCK_DIR/pid"
    if [[ "$lock_pid" =~ ^[0-9]+$ ]] && ! kill -0 "$lock_pid" 2>/dev/null; then
        log "Removing stale queue lock from PID $lock_pid."
        rm -f "$LOCK_DIR/pid"
        rmdir "$LOCK_DIR" 2>/dev/null || true
    fi
    if ! mkdir "$LOCK_DIR" 2>/dev/null; then
        log "Queue request ignored: another processor holds the lock."
        exit 1
    fi
fi
printf '%s\n' "$$" > "$LOCK_DIR/pid"

cleanup() {
    rm -f "$LOCK_DIR/pid"
    rmdir "$LOCK_DIR" 2>/dev/null || true
    set_state idle "" ""
    "$Q_MGR" count >/dev/null
    log "Queue processor stopped."
}
trap cleanup EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

log "Queue processor started ($action)."
case "$action" in
    transcribe) process_transcriptions ;;
    transcribe-one) process_transcriptions "$requested_base" ;;
    summarize) process_summaries ;;
    all) process_transcriptions; process_summaries ;;
esac
log "Queue processing finished ($action)."

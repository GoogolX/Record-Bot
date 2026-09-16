#!/bin/bash
# Where is everything? Run:  ./scripts/status.sh
# Options:
#   -w, --watch     refresh every 2 seconds
#   -c, --clean     clean up resolved failure markers and stale locks
#   -r, --retry     retry all failed jobs that still have audio
#   -k, --kill JOB  terminate a running job by name
#   -h, --help      show this help
set -uo pipefail

HOME_DIR="${RECORDBOT_HOME:-$(cd "$(dirname "$0")/.." && pwd)}"
STATUS_DIR="$HOME_DIR/Status"
RECORDINGS_DIR="$HOME_DIR/Recordings"
TRANSCRIBE_SCRIPT="$HOME_DIR/scripts/transcribe.sh"

shopt -s nullglob

count() {
  local n=0 f
  for f in "$@"; do [ -e "$f" ] && n=$((n + 1)); done
  printf '%d' "$n"
}

clean_status() {
  local count=0
  for f in "$STATUS_DIR"/*.failed; do
    rm -f "$f"
    count=$((count + 1))
  done
  for f in "$STATUS_DIR"/*.lock; do
    rmdir "$f" 2>/dev/null || rm -rf "$f"
    count=$((count + 1))
  done
  printf 'Cleaned %d status/lock markers.\n' "$count"
}

retry_failed() {
  local retried=0
  for f in "$STATUS_DIR"/*.failed; do
    local name wav
    name="$(basename "$f" .failed)"
    wav="$RECORDINGS_DIR/$name.wav"
    if [ -f "$wav" ]; then
      rm -f "$f"
      printf 'Retrying %s in background...\n' "$name"
      bash "$TRANSCRIBE_SCRIPT" "$wav" &
      retried=$((retried + 1))
    else
      printf 'Cannot retry %s: audio was deleted.\n' "$name"
    fi
  done
  [ "$retried" -eq 0 ] && printf 'No retriable failed jobs found.\n'
}

kill_job() {
  local target="${1:-}"
  [ -z "$target" ] && { echo "Specify a job name to kill." >&2; exit 1; }
  target="$(basename "$target" .status)"
  local f="$STATUS_DIR/$target.status"
  if [ -f "$f" ]; then
    read -r _ _ pid _ < "$f"
    if [ -n "${pid:-}" ] && [ "$pid" -gt 0 ] 2>/dev/null; then
      if kill -0 "$pid" 2>/dev/null; then
        kill -15 "$pid"
        printf 'Sent SIGTERM to %s (PID %s).\n' "$target" "$pid"
        return 0
      fi
    fi
    rm -f "$f"
    printf 'Job %s was not running. Removed status marker.\n' "$target"
  else
    printf 'No active job named %s found.\n' "$target"
  fi
}

show() {
  printf '\033[1mRecordBot\033[0m  %s\n\n' "$(date '+%H:%M:%S')"

  local active=0 f
  printf '\033[1mIn progress\033[0m\n'
  for f in "$STATUS_DIR"/*.status; do
    local stage="" started="" pid="" name="" elapsed=0
    name="$(basename "$f" .status)"
    read -r stage started pid _ < "$f" 2>/dev/null || true

    # If PID is known, verify process is alive
    if [ -n "${pid:-}" ] && [ "$pid" -gt 0 ] 2>/dev/null; then
      if ! kill -0 "$pid" 2>/dev/null; then
        printf 'process exited unexpectedly (PID %s died)\n' "$pid" > "$STATUS_DIR/$name.failed"
        rm -f "$f"
        continue
      fi
    fi

    active=1
    case "${started:-}" in
      ''|*[!0-9]*) started="$(date +%s)" ;;
    esac
    elapsed=$(( $(date +%s) - started ))
    local pid_disp="${pid:+(pid $pid)}"
    printf '  %-22s %-13s %dm%02ds  %s\n' "$name" "$stage" $((elapsed / 60)) $((elapsed % 60)) "$pid_disp"
  done
  [ "$active" -eq 0 ] && printf '  nothing running\n'

  local failed=0
  for f in "$STATUS_DIR"/*.failed; do
    if [ "$failed" -eq 0 ]; then printf '\n\033[31mFailed\033[0m\n'; failed=1; fi
    printf '  %-22s %s\n' "$(basename "$f" .failed)" "$(cat "$f")"
  done

  printf '\n\033[1mWaiting on Summary\033[0m\n'
  local waiting=0
  for f in "$HOME_DIR"/Transcripts/*.md; do
    if grep -q '^status: awaiting-summary' "$f" 2>/dev/null; then
      waiting=$((waiting + 1))
      printf '  %s\n' "$(basename "$f" .md)"
    fi
  done
  [ "$waiting" -eq 0 ] && printf '  none\n'

  printf '\n\033[1mCounts\033[0m\n'
  printf '  recordings kept: %d   transcripts: %d   summaries: %d\n' \
    "$(count "$RECORDINGS_DIR"/*.wav)" \
    "$(count "$HOME_DIR"/Transcripts/*.md)" \
    "$(count "$HOME_DIR"/Summaries/*.md)"

  printf '\n\033[1mLast log lines\033[0m\n'
  tail -n 5 "$HOME_DIR/recordbot.log" 2>/dev/null | sed 's/^/  /' || printf '  no log yet\n'
}

case "${1:-}" in
  -w|--watch)
    while true; do clear; show; sleep 2; done
    ;;
  -c|--clean)
    clean_status
    ;;
  -r|--retry)
    retry_failed
    ;;
  -k|--kill)
    kill_job "${2:-}"
    ;;
  -h|--help)
    grep -E '^#   ' "$0" | sed 's/^#   //'
    ;;
  *)
    show
    ;;
esac

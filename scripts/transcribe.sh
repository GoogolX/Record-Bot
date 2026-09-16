#!/bin/bash
# Turns one recording into a speaker-attributed transcript.
#
# Called by the menu bar app after each stop, and safe to run by hand:
#   ./scripts/transcribe.sh Recordings/2026-08-25_14-30-00.wav
#
# Pipeline: convert both tracks to 16 kHz mono, transcribe each with whisper.cpp,
# diarize the call audio with pyannote, then align the two and work out which
# speaker is you by comparing mic energy against call energy.
#
# Every stage is optional going down: no mic track means no "Me" label, no
# diarization means a plain unattributed transcript. Nothing hard-fails because
# an extra was missing.
set -uo pipefail

HOME_DIR="${RECORDBOT_HOME:-$(cd "$(dirname "$0")/.." && pwd)}"
LOG="$HOME_DIR/recordbot.log"
STATUS_DIR="$HOME_DIR/Status"
WHISPER_DIR="$HOME_DIR/vendor/whisper.cpp"
VENV_PY="$HOME_DIR/vendor/venv/bin/python"
TOKEN_FILE="$HOME_DIR/.hf_token"
START_EPOCH="$(date +%s)"

log() { printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "$LOG"; }

# shellcheck source=/dev/null
[ -f "$HOME_DIR/scripts/config.sh" ] && source "$HOME_DIR/scripts/config.sh"
WHISPER_MODEL="${WHISPER_MODEL:-ggml-large-v3-turbo-q5_0.bin}"
WHISPER_LANGUAGE="${WHISPER_LANGUAGE:-en}"
DIARIZE="${DIARIZE:-auto}"
MIN_SPEAKERS="${MIN_SPEAKERS:-}"
MAX_SPEAKERS="${MAX_SPEAKERS:-}"
MY_NAME="${MY_NAME:-}"
KEEP_AUDIO="${KEEP_AUDIO:-no}"

WAV="${1:-}"
if [ -z "$WAV" ] || [ ! -f "$WAV" ]; then
  log "ERROR no input file: '${WAV}'"
  exit 1
fi

BASE="$(basename "$WAV" .wav)"
mkdir -p "$STATUS_DIR" "$HOME_DIR/Transcripts"

stage() {
  printf '%s %s %s %s\n' "$1" "$START_EPOCH" "$$" "$WAV" > "$STATUS_DIR/$BASE.status"
  log "$1 $BASE (pid $$)"
}

fail() {
  printf '%s\n' "$1" > "$STATUS_DIR/$BASE.failed"
  rm -f "$STATUS_DIR/$BASE.status"
  log "ERROR $BASE: $1"
  exit 1
}

cleanup() {
  code=$?
  [ -n "${LOCK:-}" ] && rmdir "$LOCK" 2>/dev/null
  [ -n "${WORK:-}" ] && rm -rf "$WORK"
  if [ "$code" -ne 0 ] && [ -f "$STATUS_DIR/$BASE.status" ]; then
    printf 'exited unexpectedly (code %s), see recordbot.log\n' "$code" > "$STATUS_DIR/$BASE.failed"
    rm -f "$STATUS_DIR/$BASE.status"
    log "ERROR $BASE: exited with code $code"
  fi
}
# A signal-killed shell reports $? as 0 inside the EXIT trap, so convert signals
# into ordinary non-zero exits first. Without this, a job killed at logout or by
# pkill sits in "transcribing" forever with no failure marker and no way to retry.
trap 'exit 130' INT
trap 'exit 143' TERM
trap 'exit 129' HUP
trap cleanup EXIT

# One job per recording. Two overlapping runs would fight over the output file
# and delete each other's audio.
LOCK="$STATUS_DIR/$BASE.lock"
if ! mkdir "$LOCK" 2>/dev/null; then
  LOCK=""
  log "SKIP  $BASE is already being processed"
  exit 0
fi

rm -f "$STATUS_DIR/$BASE.failed"
stage queued

MODEL="$WHISPER_DIR/models/$WHISPER_MODEL"
BIN="$WHISPER_DIR/build/bin/whisper-cli"
[ -x "$BIN" ] || BIN="$WHISPER_DIR/build/bin/main"

[ -x "$BIN" ]   || fail "whisper binary missing, run scripts/setup.sh"
[ -f "$MODEL" ] || fail "model missing at $MODEL, run scripts/setup.sh"

# Sidecars written by the app.
META="${WAV%.wav}.meta"
NOTES="${WAV%.wav}.notes"
SYNC="${WAV%.wav}.sync"
MIC="${WAV%.wav}.mic.wav"

MIC_OFFSET="0"
if [ -f "$SYNC" ]; then
  MIC_OFFSET="$(sed -n 's/^mic_offset_seconds: //p' "$SYNC" | head -1)"
  [ -n "$MIC_OFFSET" ] || MIC_OFFSET="0"
fi
[ -f "$MIC" ] || MIC=""

MIC_NOTE="no"
[ -n "$MIC" ] && MIC_NOTE="yes"

WORK="$(mktemp -d)"
DURATION="$(afinfo "$WAV" 2>/dev/null | awk -F': ' '/estimated duration/ {printf "%d", $2}')"
log "START $BASE (${DURATION:-?}s, model $WHISPER_MODEL, mic track: $MIC_NOTE)"

# ---- 1. Convert -------------------------------------------------------------
# whisper.cpp and pyannote both want 16 kHz mono. afconvert ships with macOS.
stage converting
afconvert -f WAVE -d LEI16@16000 -c 1 "$WAV" "$WORK/system16.wav" 2>>"$LOG" \
  || fail "afconvert could not read the call audio"

if [ -n "$MIC" ]; then
  if ! afconvert -f WAVE -d LEI16@16000 -c 1 "$MIC" "$WORK/mic16.wav" 2>>"$LOG"; then
    log "WARN  could not convert the mic track, continuing without it"
    MIC=""
    MIC_NOTE="no"
  fi
fi

# ---- 2. Transcribe ----------------------------------------------------------
stage transcribing
THREADS="${WHISPER_THREADS:-$(sysctl -n hw.ncpu 2>/dev/null || echo 4)}"
LANG_ARG="$WHISPER_LANGUAGE"
[ -z "$LANG_ARG" ] && LANG_ARG="auto"

run_whisper() {
  # $1 = 16 kHz wav, $2 = output prefix. whisper.cpp appends .txt and .json.
  local args=(
    -m "$MODEL"
    -f "$1"
    -t "$THREADS"
    -l "$LANG_ARG"
    --suppress-nst
    --no-speech-thold 0.6
    --logprob-thold -1.0
    --entropy-thold 2.4
    --vad
    -vm "$WHISPER_DIR/models/ggml-silero-v6.2.0.bin"
    --output-txt
    --output-json
    --output-file "$2"
  )
  if [ -n "${WHISPER_PROMPT:-}" ]; then
    args+=(--prompt "$WHISPER_PROMPT")
  fi
  "$BIN" "${args[@]}" >>"$LOG" 2>&1
}

run_whisper "$WORK/system16.wav" "$WORK/system" || fail "whisper exited with an error"

MIC_JSON=""
if [ ! -s "$WORK/system.txt" ]; then
  if [ -n "$MIC" ]; then
    log "INFO  system track is empty, falling back to mic track (dictation mode)"
    if run_whisper "$WORK/mic16.wav" "$WORK/mic" && [ -s "$WORK/mic.json" ]; then
      cp "$WORK/mic.txt" "$WORK/system.txt"
      cp "$WORK/mic.json" "$WORK/system.json"
      MIC="" # Disable secondary mic logic since mic is now the primary track
    else
      fail "whisper produced an empty transcript on both system and mic tracks"
    fi
  else
    fail "whisper produced an empty transcript"
  fi
else
  if [ -n "$MIC" ]; then
    if run_whisper "$WORK/mic16.wav" "$WORK/mic" && [ -s "$WORK/mic.json" ]; then
      MIC_JSON="$WORK/mic.json"
    else
      log "WARN  whisper gave nothing usable for the mic track; it can still identify you, but your words come from the call audio"
    fi
  fi
fi

# ---- 3. Diarize -------------------------------------------------------------
DIAR_OK="no"
if [ "$DIARIZE" != "no" ]; then
  if [ -x "$VENV_PY" ] && [ -s "$TOKEN_FILE" ]; then
    stage diarizing

    # Positional parameters rather than a string of arguments: a string breaks on
    # spaces in TMPDIR, and zsh does not word-split it at all.
    set -- "$WORK/system16.wav" --out "$WORK/diar.json"
    [ -n "$MIN_SPEAKERS" ] && set -- "$@" --min-speakers "$MIN_SPEAKERS"
    [ -n "$MAX_SPEAKERS" ] && set -- "$@" --max-speakers "$MAX_SPEAKERS"

    if HF_TOKEN="$(cat "$TOKEN_FILE")" "$VENV_PY" "$HOME_DIR/scripts/diarize.py" "$@" \
         >>"$LOG" 2>&1; then
      DIAR_OK="yes"
    else
      log "WARN  diarization failed, falling back to an unattributed transcript"
      [ "$DIARIZE" = "yes" ] && fail "diarization failed and DIARIZE is set to yes"
    fi
  elif [ "$DIARIZE" = "yes" ]; then
    fail "DIARIZE=yes but diarization is not installed, run scripts/setup-diarization.sh"
  else
    log "INFO  diarization not installed, skipping (scripts/setup-diarization.sh enables it)"
  fi
fi

# ---- 4. Attribute -----------------------------------------------------------
BODY=""
SPEAKER_LIST=""
if [ "$DIAR_OK" = "yes" ]; then
  stage attributing

  set -- --diarization "$WORK/diar.json" \
         --system-json "$WORK/system.json" \
         --system-audio "$WORK/system16.wav" \
         --my-name "$MY_NAME" \
         --out "$WORK/body.md" \
         --speakers-out "$WORK/speakers.txt"

  # The mic audio identifies you even when its own transcript came back empty.
  [ -n "$MIC" ] && set -- "$@" --mic-audio "$WORK/mic16.wav" --offset "$MIC_OFFSET"
  [ -n "$MIC_JSON" ] && set -- "$@" --mic-json "$MIC_JSON"

  if "$VENV_PY" "$HOME_DIR/scripts/attribute.py" "$@" >>"$LOG" 2>&1 && [ -s "$WORK/body.md" ]; then
    BODY="$WORK/body.md"
    [ -s "$WORK/speakers.txt" ] && SPEAKER_LIST="$WORK/speakers.txt"
  else
    log "WARN  attribution failed, falling back to an unattributed transcript"
  fi
fi

# ---- 5. Write ---------------------------------------------------------------
stage writing

HUMAN_DATE="$(printf '%s' "$BASE" | sed 's/_/ /; s/-\([0-9][0-9]\)-\([0-9][0-9]\)$/:\1:\2/')"

TITLE=""; CONTEXT=""; WATCH=""
if [ -f "$META" ]; then
  TITLE="$(sed -n 's/^title: //p' "$META" | head -1)"
  CONTEXT="$(sed -n 's/^context: //p' "$META" | head -1)"
  WATCH="$(sed -n 's/^watch_for: //p' "$META" | head -1)"
fi
[ -z "$TITLE" ] && TITLE="Untitled meeting"

# Header values are free text from the app, so a colon or a # in a title would
# otherwise produce a header that no YAML parser will read.
yaml_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

SLUG="$(printf '%s' "$TITLE" \
  | tr '[:upper:]' '[:lower:]' \
  | sed 's/[^a-z0-9][^a-z0-9]*/-/g; s/^-//; s/-$//' \
  | cut -c1-40 \
  | sed 's/-$//')"
[ -z "$SLUG" ] && SLUG="untitled"

OUT="$HOME_DIR/Transcripts/${BASE}__${SLUG}.md"

{
  echo "---"
  echo "title: \"$(yaml_escape "$TITLE")\""
  echo "recorded: \"$HUMAN_DATE\""
  [ -n "$CONTEXT" ] && echo "context: \"$(yaml_escape "$CONTEXT")\""
  [ -n "$WATCH" ] && echo "watch_for: \"$(yaml_escape "$WATCH")\""
  echo "duration_seconds: ${DURATION:-0}"
  echo "model: \"$WHISPER_MODEL\""
  echo "language: \"$LANG_ARG\""
  [ -s "$NOTES" ] && echo "has_my_notes: yes"
  echo "diarized: $DIAR_OK"
  [ -n "$MIC" ] && echo "own_mic_track: yes"

  # Editable speaker map. The summarizer proposes names for the "?" entries;
  # correct any it gets wrong here and set status back to awaiting-summary.
  if [ -n "$SPEAKER_LIST" ]; then
    echo "speakers:"
    while IFS='|' read -r label seconds resolved; do
      [ -n "$label" ] || continue
      if [ "${seconds:-0}" -ge 60 ]; then
        HOW_MUCH="$(( (seconds + 30) / 60 )) min of speech"
      else
        HOW_MUCH="${seconds:-0} sec of speech"
      fi
      echo "  - \"$(yaml_escape "$label")\": \"$(yaml_escape "$resolved")\"  # $HOW_MUCH"
    done < "$SPEAKER_LIST"
  fi

  echo "status: awaiting-summary"
  echo "---"
  echo

  # Hand-typed notes come first and are marked as human-written, so the
  # summarizer can trust them over anything the speech recognizer thought it heard.
  if [ -s "$NOTES" ]; then
    echo "## My notes"
    echo
    echo "_Typed by hand during or after the meeting. Authoritative where it conflicts with the transcript below._"
    echo
    cat "$NOTES"
    echo
  fi

  echo "## Transcript"
  echo
  if [ -n "$BODY" ]; then
    cat "$BODY"
  else
    # No diarization. whisper's txt output is one line per segment and never
    # blank, so group them into paragraphs rather than emitting the whole
    # meeting as a single unbroken line.
    sed 's/^[[:space:]]*//' "$WORK/system.txt" \
      | awk 'NF { buf = buf $0 " "; n++ }
             n >= 8 { print buf; print ""; buf = ""; n = 0 }
             END { if (buf != "") print buf }'
  fi
} > "$OUT"

# ---- 6. Summarize -----------------------------------------------------------
if [ -x "$VENV_PY" ]; then
  stage summarizing
  "$VENV_PY" "$HOME_DIR/scripts/summarize.py" --file "$OUT" >>"$LOG" 2>&1 || log "WARN  summarization failed"
fi

ELAPSED=$(( $(date +%s) - START_EPOCH ))
log "DONE  $BASE -> Transcripts/$(basename "$OUT") ($(wc -w < "$OUT" | tr -d ' ') words, took ${ELAPSED}s)"
rm -f "$STATUS_DIR/$BASE.status"

# Sidecars go with the audio, never before it: keeping the audio without its
# .sync file would make a rerun misalign every mic segment.
if [ "$KEEP_AUDIO" != "yes" ]; then
  rm -f "$META" "$NOTES" "$SYNC" "$WAV" "${WAV%.wav}.mic.wav"
  log "CLEAN removed audio for $BASE"
fi

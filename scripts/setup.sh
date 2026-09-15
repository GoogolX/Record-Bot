#!/bin/bash
# One-time setup: build whisper.cpp, fetch a model, build the menu bar app.
# Safe to re-run.
set -euo pipefail

HOME_DIR="${RECORDBOT_HOME:-$(cd "$(dirname "$0")/.." && pwd)}"
cd "$HOME_DIR"

# shellcheck source=/dev/null
[ -f scripts/config.sh ] && source scripts/config.sh
WHISPER_MODEL="${WHISPER_MODEL:-ggml-large-v3-turbo-q5_0.bin}"
MODEL_NAME="${WHISPER_MODEL#ggml-}"
MODEL_NAME="${MODEL_NAME%.bin}"

say() { printf '\n\033[1m==> %s\033[0m\n' "$*"; }
die() { printf '\n\033[31mError: %s\033[0m\n' "$*" >&2; exit 1; }

say "Checking prerequisites"
[ "$(uname -s)" = "Darwin" ] || die "This is macOS only."
MAJOR="$(sw_vers -productVersion | cut -d. -f1)"
[ "$MAJOR" -ge 13 ] || die "macOS 13 (Ventura) or newer is required for system audio capture."

command -v xcodebuild >/dev/null 2>&1 || command -v swift >/dev/null 2>&1 \
  || die "Swift toolchain missing. Install Xcode or the Command Line Tools: xcode-select --install"

MISSING=()
command -v git   >/dev/null 2>&1 || MISSING+=(git)
command -v cmake >/dev/null 2>&1 || MISSING+=(cmake)
if [ ${#MISSING[@]} -gt 0 ]; then
  die "Missing: ${MISSING[*]}. Install with: brew install ${MISSING[*]}"
fi
echo "Prerequisites look fine."

say "Fetching whisper.cpp"
mkdir -p vendor
if [ -d vendor/whisper.cpp/.git ]; then
  git -C vendor/whisper.cpp pull --ff-only || echo "(could not update, using the existing checkout)"
else
  git clone --depth 1 https://github.com/ggml-org/whisper.cpp vendor/whisper.cpp
fi

say "Building whisper.cpp (Metal accelerated)"
cmake -B vendor/whisper.cpp/build -S vendor/whisper.cpp -DCMAKE_BUILD_TYPE=Release >/dev/null
cmake --build vendor/whisper.cpp/build --config Release -j "$(sysctl -n hw.ncpu)"

say "Downloading model: $WHISPER_MODEL"
if [ -f "vendor/whisper.cpp/models/$WHISPER_MODEL" ]; then
  echo "Already present."
else
  echo "Fetching $MODEL_NAME, around 800 MB for the default turbo model."
  ( cd vendor/whisper.cpp && bash ./models/download-ggml-model.sh "$MODEL_NAME" ) \
    || die "Download failed. Check that '$MODEL_NAME' is a name download-ggml-model.sh knows: run
  bash vendor/whisper.cpp/models/download-ggml-model.sh
to list them, then set WHISPER_MODEL in scripts/config.sh accordingly."
  [ -f "vendor/whisper.cpp/models/$WHISPER_MODEL" ] \
    || die "Downloaded, but not to the expected filename $WHISPER_MODEL. Check scripts/config.sh."
fi

say "Building RecordBot.app"
bash scripts/build-app.sh

mkdir -p Recordings Transcripts Summaries Status
[ -f ACTION-ITEMS.md ] || cat > ACTION-ITEMS.md <<'MD'
# Action Items

_No meetings processed yet. Record something and the summarizer will fill this in._
MD

chmod +x scripts/*.sh

say "Done"
cat <<'NEXT'
Two things left, both one-time:

1. Open RecordBot.app (double-click it in this folder). It appears as a small
   dot in your menu bar, no Dock icon.

2. The first time you hit record, macOS will refuse and open
   System Settings > Privacy & Security > Screen & System Audio Recording.
   Switch RecordBot on, then quit and reopen the app.
   It also asks for the microphone on first launch, which is what lets it tell
   your voice apart from everyone else's. Declining still records the meeting.

After that: Control-Option-R starts and stops recording.
Transcripts land in Transcripts/ within a few minutes of stopping.

Optional extras:
   bash scripts/setup-diarization.sh   # who spoke when, ~2 GB, one Hugging Face token
   bash scripts/install-login-item.sh  # start RecordBot at login
   bash scripts/status.sh -w           # watch what the pipeline is doing
NEXT

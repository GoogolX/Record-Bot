#!/bin/bash
# Optional one-time setup for speaker diarization.
#
# Installs pyannote.audio into a private virtualenv and stores your Hugging Face
# token. Roughly 2 GB of dependencies, mostly PyTorch. Everything runs locally
# after this; the token is only used to download the pretrained models once.
set -euo pipefail

HOME_DIR="${RECORDBOT_HOME:-$(cd "$(dirname "$0")/.." && pwd)}"
cd "$HOME_DIR"

VENV="$HOME_DIR/vendor/venv"
TOKEN_FILE="$HOME_DIR/.hf_token"

say() { printf '\n\033[1m==> %s\033[0m\n' "$*"; }
die() { printf '\n\033[31mError: %s\033[0m\n' "$*" >&2; exit 1; }

say "Checking Python"
command -v python3 >/dev/null 2>&1 || die "python3 not found. Install it with: brew install python"
PYVER="$(python3 -c 'import sys; print("%d.%d" % sys.version_info[:2])')"
echo "python3 is $PYVER"

say "Creating the virtualenv at vendor/venv"
python3 -m venv "$VENV"
"$VENV/bin/pip" install --quiet --upgrade pip wheel

say "Installing pyannote.audio and PyTorch (this is the slow part)"
# 4.0.1 or newer is required, not optional: pyannote 3.x calls
# torchaudio.list_audio_backends(), which torchaudio removed in 2.9, so the older
# line only works against a pinned-back torch that no longer builds on new Pythons.
"$VENV/bin/pip" install --upgrade "pyannote.audio>=4.0.1" "numpy>=2.0" torch torchaudio --prefer-binary \
  || die "Install failed. If pip could not find wheels, your Python ($PYVER) may be newer than PyTorch supports yet. Create the venv with an older interpreter, for example:
  brew install python@3.12
  rm -rf vendor/venv
  python3.12 -m venv vendor/venv
then re-run this script."

say "Hugging Face token"
cat <<'WHY'
pyannote's pretrained models are gated, so a free token is needed to download
them once. Before pasting one, open these pages and click through the terms:

  https://hf.co/pyannote/speaker-diarization-community-1
  https://hf.co/pyannote/speaker-diarization-3.1
  https://hf.co/pyannote/segmentation-3.0

The community-1 model is the current one and gets tried first; the other two are
the fallback. Accepting all three costs nothing and saves a second trip here.

Then create a read token at https://hf.co/settings/tokens

WHY

if [ -s "$TOKEN_FILE" ]; then
  printf 'A token is already saved. Replace it? [y/N] '
  read -r replace
  case "$replace" in
    [yY]*) ;;
    *) echo "Keeping the existing token."; SKIP_TOKEN=1 ;;
  esac
fi

if [ -z "${SKIP_TOKEN:-}" ]; then
  printf 'Paste your token (input hidden): '
  read -rs TOKEN
  echo
  [ -n "$TOKEN" ] || die "No token entered."
  printf '%s\n' "$TOKEN" > "$TOKEN_FILE"
  chmod 600 "$TOKEN_FILE"
  echo "Saved to .hf_token (readable only by you)."
fi

say "Testing the pipeline"
echo "This downloads the models, so expect a minute or two the first time."
echo "Whatever diarize.py will do at transcription time is exactly what runs now."
if HF_TOKEN="$(cat "$TOKEN_FILE")" "$VENV/bin/python" "$HOME_DIR/scripts/diarize.py" --selftest; then
  say "Done"
  echo "Diarization is live. New recordings will be split by speaker automatically."
  echo "Optional: set MIN_SPEAKERS and MAX_SPEAKERS in scripts/config.sh for better results."
else
  die "Could not load a pipeline. The messages above say which models were tried and why each
one refused. The usual cause is not having accepted the terms on the model pages."
fi

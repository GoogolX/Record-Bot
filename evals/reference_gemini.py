#!/usr/bin/env python3
"""Dual-Track Reference Generator and Benchmarking via Gemini Audio API.

Creates ground-truth reference transcripts from raw meeting audio:
1. Aligns call audio (Left channel) and mic audio (Right channel) using .sync.
2. Sends the 2-channel audio to Gemini 2.0/2.5 Audio API.
3. Generates gold reference transcripts with definitive "Me" vs "Other" separation.
4. Evaluates RecordBot's output against the reference:
   - User Speech Recall (how many words spoken into mic were retained vs lost)
   - Attribution Accuracy (were user utterances tagged as "Me")
   - Overall Word Overlap & Alignment
   - Side-by-side comparison table

Usage:
  python evals/reference_gemini.py                     # process all recordings in Recordings/
  python evals/reference_gemini.py --id 2026-08-26_12-49-55
  python evals/reference_gemini.py --compare-only      # compare existing reference transcripts
"""

from __future__ import annotations

import argparse
import base64
import json
import math
import os
import re
import sys
import tempfile
import urllib.error
import urllib.request
import wave
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
RECORDINGS_DIR = ROOT / "Recordings"
TRANSCRIPTS_DIR = ROOT / "Transcripts"
REFERENCE_DIR = ROOT / "evals" / "reference"


def get_gemini_api_key() -> str:
    key = os.environ.get("GEMINI_API_KEY", "").strip()
    if key:
        return key

    token_file = ROOT / ".gemini_token"
    if token_file.exists():
        content = token_file.read_text(encoding="utf-8").strip()
        if content:
            return content

    # Check scripts/config.sh for GEMINI_API_KEY
    config_file = ROOT / "scripts" / "config.sh"
    if config_file.exists():
        for line in config_file.read_text(encoding="utf-8").splitlines():
            if line.startswith("GEMINI_API_KEY="):
                val = line.split("=", 1)[1].strip().strip('"\'')
                if val:
                    return val
    return ""


def read_wav_16k_mono(path: Path) -> np.ndarray:
    """Reads a WAV file and converts to 16kHz mono float32 array in [-1.0, 1.0]."""
    with wave.open(str(path), "rb") as w:
        channels = w.getnchannels()
        rate = w.getframerate()
        width = w.getsampwidth()
        nframes = w.getnframes()
        raw = w.readframes(nframes)

    if width != 2:
        raise ValueError(f"Expected 16-bit audio in {path}, got {width * 8}-bit")

    data = np.frombuffer(raw, dtype="<i2").astype(np.float32) / 32768.0
    if channels > 1:
        data = data.reshape(-1, channels).mean(axis=1)

    if rate != 16000:
        # Simple high-quality linear resample to 16000
        target_len = int(len(data) * 16000.0 / rate)
        indices = np.linspace(0, len(data) - 1, target_len)
        data = np.interp(indices, np.arange(len(data)), data).astype(np.float32)

    return data


def create_aligned_stereo_wav(system_wav: Path, mic_wav: Path | None, offset: float, out_path: Path) -> float:
    """Creates a 16kHz stereo WAV: Left = System Audio, Right = User Mic Audio.
    Returns the total duration in seconds.
    """
    sys_audio = read_wav_16k_mono(system_wav)
    rate = 16000

    if mic_wav and mic_wav.exists():
        mic_audio = read_wav_16k_mono(mic_wav)
        offset_samples = int(offset * rate)

        total_len = max(len(sys_audio), len(mic_audio) + max(0, offset_samples))
        left = np.zeros(total_len, dtype=np.float32)
        right = np.zeros(total_len, dtype=np.float32)

        left[:len(sys_audio)] = sys_audio

        if offset_samples >= 0:
            end_pos = min(total_len, offset_samples + len(mic_audio))
            right[offset_samples:end_pos] = mic_audio[:end_pos - offset_samples]
        else:
            # Mic started before system stream
            abs_off = abs(offset_samples)
            if abs_off < len(mic_audio):
                avail = mic_audio[abs_off:]
                right[:len(avail)] = avail
    else:
        # No mic audio available, stereo duplicate
        left = sys_audio
        right = np.zeros_like(sys_audio)
        total_len = len(sys_audio)

    # Interleave to stereo 16-bit PCM
    stereo = np.empty((total_len, 2), dtype=np.float32)
    stereo[:, 0] = left
    stereo[:, 1] = right
    pcm = (np.clip(stereo, -1.0, 1.0) * 32767.0).astype("<i2")

    with wave.open(str(out_path), "wb") as w:
        w.setnchannels(2)
        w.setsampwidth(2)
        w.setframerate(rate)
        w.writeframes(pcm.tobytes())

    return total_len / float(rate)


def upload_to_gemini_files(file_path: Path, api_key: str) -> str:
    """Uploads large audio file to Gemini Files API and returns the file URI."""
    file_size = file_path.stat().st_size
    display_name = file_path.name

    # Step 1: Initial resumable upload request
    init_url = f"https://generativelanguage.googleapis.com/upload/v1beta/files?key={api_key}"
    headers = {
        "X-Goog-Upload-Protocol": "resumable",
        "X-Goog-Upload-Command": "start",
        "X-Goog-Upload-Header-Content-Length": str(file_size),
        "X-Goog-Upload-Header-Content-Type": "audio/wav",
        "Content-Type": "application/json",
    }
    init_body = json.dumps({"file": {"display_name": display_name}}).encode("utf-8")
    req = urllib.request.Request(init_url, data=init_body, headers=headers, method="POST")

    with urllib.request.urlopen(req, timeout=30) as resp:
        upload_url = resp.headers.get("X-Goog-Upload-URL")

    if not upload_url:
        raise RuntimeError("Failed to get resumable upload URL from Gemini API")

    # Step 2: Upload file bytes
    file_bytes = file_path.read_bytes()
    upload_headers = {
        "Content-Length": str(file_size),
        "X-Goog-Upload-Offset": "0",
        "X-Goog-Upload-Command": "upload, finalize",
    }
    upload_req = urllib.request.Request(upload_url, data=file_bytes, headers=upload_headers, method="POST")

    with urllib.request.urlopen(upload_req, timeout=120) as resp:
        res = json.loads(resp.read().decode("utf-8"))
        return res["file"]["uri"]


def call_gemini_audio(stereo_wav: Path, duration_sec: float, api_key: str) -> str:
    """Generates ground-truth speaker-attributed transcript using Gemini."""
    prompt = """You are transcribing a synchronized dual-channel meeting recording:
- Channel 0 (Left channel): Call audio containing all other meeting participants.
- Channel 1 (Right channel): The user's close-talking microphone.

Your goal is to produce an accurate, verbatim speaker-attributed transcript:
1. When there is speech on Channel 1 (Right channel / user mic), label the speaker strictly as "**Me**".
2. When there is speech on Channel 0 (Left channel / call audio), identify individual speakers as "**Speaker 1**", "**Speaker 2**", etc. (or their names if clearly addressed in conversation).
3. Format each utterance as:
**Speaker Name** · HH:MM:SS
Spoken text.

Be accurate with timestamps and attribution."""

    file_size = stereo_wav.stat().st_size
    candidate_models = ["gemini-3.6-flash", "gemini-flash-latest", "gemini-flash-lite-latest"]

    parts = []
    if file_size > 15 * 1024 * 1024:
        file_uri = upload_to_gemini_files(stereo_wav, api_key)
        parts = [
            {"file_data": {"mime_type": "audio/wav", "file_uri": file_uri}},
            {"text": prompt}
        ]
    else:
        b64_audio = base64.b64encode(stereo_wav.read_bytes()).decode("utf-8")
        parts = [
            {"inline_data": {"mime_type": "audio/wav", "data": b64_audio}},
            {"text": prompt}
        ]

    body = {"contents": [{"parts": parts}]}
    last_err = None

    for model in candidate_models:
        url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={api_key}"
        req = urllib.request.Request(
            url,
            data=json.dumps(body).encode("utf-8"),
            headers={"Content-Type": "application/json"}
        )
        try:
            with urllib.request.urlopen(req, timeout=300) as resp:
                res = json.loads(resp.read().decode("utf-8"))
                candidates = res.get("candidates", [])
                if not candidates:
                    raise RuntimeError("Gemini returned empty response")
                return candidates[0]["content"]["parts"][0]["text"]
        except Exception as err:
            last_err = err
            print(f"Model {model} failed ({err}), trying fallback...", file=sys.stderr)
            continue

    raise RuntimeError(f"All Gemini candidate models failed. Last error: {last_err}")


def extract_speaker_words(text: str) -> dict[str, list[str]]:
    """Extracts words grouped by speaker from a markdown transcript."""
    current_speaker = "Unattributed"
    words_by_spk: dict[str, list[str]] = {}

    for line in text.splitlines():
        m = re.match(r"^\*\*(.+?)\*\*\s*·", line)
        if m:
            current_speaker = m.group(1).strip()
            continue
        if line.startswith("## ") or line.startswith("---"):
            continue
        clean_words = re.findall(r"\b\w+\b", line.lower())
        if clean_words:
            words_by_spk.setdefault(current_speaker, []).extend(clean_words)

    return words_by_spk


def evaluate_against_reference(test_transcript: Path, ref_transcript: Path) -> dict:
    """Calculates accuracy metrics comparing RecordBot transcript against reference."""
    test_text = test_transcript.read_text(encoding="utf-8")
    ref_text = ref_transcript.read_text(encoding="utf-8")

    test_words = extract_speaker_words(test_text)
    ref_words = extract_speaker_words(ref_text)

    # User Recall
    ref_me_words = ref_words.get("Me", [])
    test_me_words = test_words.get("Me", [])

    ref_me_set = set(ref_me_words)
    test_me_set = set(test_me_words)

    matched_me_words = ref_me_set.intersection(test_me_set)
    user_recall = (len(matched_me_words) / len(ref_me_set)) if ref_me_set else (1.0 if not test_me_set else 0.0)

    # All words
    all_test_words = [w for words in test_words.values() for w in words]
    all_ref_words = [w for words in ref_words.values() for w in words]

    overlap_words = set(all_test_words).intersection(set(all_ref_words))
    overall_recall = (len(overlap_words) / len(set(all_ref_words))) if all_ref_words else 1.0

    return {
        "id": test_transcript.stem.split("__")[0],
        "ref_me_words_count": len(ref_me_words),
        "test_me_words_count": len(test_me_words),
        "user_speech_recall": user_recall,
        "total_ref_words": len(all_ref_words),
        "total_test_words": len(all_test_words),
        "overall_vocabulary_overlap": overall_recall,
        "ref_speakers": list(ref_words.keys()),
        "test_speakers": list(test_words.keys()),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--id", help="Process specific recording ID (e.g. 2026-08-26_12-49-55)")
    parser.add_argument("--compare-only", action="store_true", help="Only run comparison over existing references")
    args = parser.parse_args()

    api_key = get_gemini_api_key()

    if not args.compare_only and not api_key:
        print("ERROR: GEMINI_API_KEY is not set.")
        print("To use the Option A Gemini reference route:")
        print("  export GEMINI_API_KEY='your-key-here'")
        print("or place your key in .gemini_token")
        return 1

    wav_files = sorted(RECORDINGS_DIR.glob("*.wav"))
    sys_wavs = [p for p in wav_files if not p.name.endswith(".mic.wav")]

    if args.id:
        sys_wavs = [p for p in sys_wavs if args.id in p.name]

    if not sys_wavs and not args.compare_only:
        print(f"No WAV files found in {RECORDINGS_DIR}. Audio retention is enabled in config.sh.")
        print("Recordings made tomorrow will be preserved here for benchmarking at EoD.")
        return 0

    REFERENCE_DIR.mkdir(parents=True, exist_ok=True)

    if not args.compare_only:
        print(f"Processing {len(sys_wavs)} recording(s) through Gemini Audio Reference Route...")
        for sys_wav in sys_wavs:
            base = sys_wav.stem
            mic_wav = RECORDINGS_DIR / f"{base}.mic.wav"
            sync_file = RECORDINGS_DIR / f"{base}.sync"

            offset = 0.0
            if sync_file.exists():
                for line in sync_file.read_text(encoding="utf-8").splitlines():
                    if line.startswith("mic_offset_seconds:"):
                        try:
                            offset = float(line.split(":", 1)[1].strip())
                        except ValueError:
                            offset = 0.0

            ref_output = REFERENCE_DIR / f"{base}__gemini_reference.md"
            if ref_output.exists():
                print(f"Reference already exists: {ref_output.name}")
                continue

            with tempfile.TemporaryDirectory() as tmpdir:
                stereo_wav = Path(tmpdir) / f"{base}_stereo.wav"
                print(f"Aligning tracks for {base} (mic offset: {offset:.3f}s)...")
                dur = create_aligned_stereo_wav(sys_wav, mic_wav if mic_wav.exists() else None, offset, stereo_wav)

                print(f"Calling Gemini Audio API ({dur:.1f}s audio)...")
                try:
                    ref_transcript = call_gemini_audio(stereo_wav, dur, api_key)
                    header = f"""---
source: gemini-2.0-flash-reference
recording_id: {base}
duration_seconds: {int(dur)}
channels: stereo (L: call, R: mic)
---

## Transcript

"""
                    ref_output.write_text(header + ref_transcript.strip() + "\n", encoding="utf-8")
                    print(f"Saved reference: {ref_output.name}")
                except Exception as err:
                    print(f"Failed to generate reference for {base}: {err}", file=sys.stderr)

    # Comparison / Scorecard Phase
    print("\n=======================================================")
    print("           BENCHMARK SCORECARD VS REFERENCE            ")
    print("=======================================================")

    ref_files = sorted(REFERENCE_DIR.glob("*__gemini_reference.md"))
    if not ref_files:
        print("No reference transcripts available yet.")
        return 0

    for ref_path in ref_files:
        rec_id = ref_path.name.split("__")[0]
        # Find corresponding RecordBot transcript
        matching_transcripts = sorted(TRANSCRIPTS_DIR.glob(f"{rec_id}*.md"))
        if not matching_transcripts:
            # Check by date matching
            matching_transcripts = [p for p in TRANSCRIPTS_DIR.glob("*.md") if rec_id[:10] in p.name]

        if not matching_transcripts:
            print(f"No RecordBot transcript found for reference {rec_id}")
            continue

        test_path = matching_transcripts[0]
        score = evaluate_against_reference(test_path, ref_path)

        print(f"\nMeeting: {rec_id}")
        print(f"  RecordBot Transcript: {test_path.name}")
        print(f"  Reference Transcript: {ref_path.name}")
        print(f"  Reference Speakers:   {', '.join(score['ref_speakers'])}")
        print(f"  RecordBot Speakers:   {', '.join(score['test_speakers'])}")
        print(f"  User 'Me' Words:")
        print(f"    - In Reference:     {score['ref_me_words_count']} words")
        print(f"    - In RecordBot:     {score['test_me_words_count']} words")
        recall_pct = score['user_speech_recall'] * 100
        print(f"  User Speech Recall:   {recall_pct:.1f}%")
        overlap_pct = score['overall_vocabulary_overlap'] * 100
        print(f"  Vocabulary Overlap:   {overlap_pct:.1f}%")

        if score['ref_me_words_count'] > 0 and score['test_me_words_count'] == 0:
            print("  [CRITICAL DEFECT DETECTED]: Mic track had user speech in reference, but RecordBot dropped it completely!")

    return 0


if __name__ == "__main__":
    sys.exit(main())

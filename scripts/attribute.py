#!/usr/bin/env python3
"""Turns diarization plus transcription into a speaker-attributed transcript.

Three jobs, all of them arithmetic rather than inference:

1. Assign each transcribed segment to the speaker who was talking during it,
   by maximum temporal overlap with the diarization timeline.
2. Work out which speaker cluster is you, by comparing energy in your
   microphone track against the call audio over each cluster's segments. Your
   voice is loud in the mic and absent from the call, so the winner is obvious
   and no model is needed.
3. Where you were speaking, prefer the words from your own microphone. A
   close-talking mic transcribes better than your voice after a round trip
   through a conferencing codec.
"""

import argparse
import json
import math
import os
import re
import sys
import wave

import numpy as np

# How much louder, in dB, your cluster must be in the mic than in the call audio
# before we are willing to call it you.
ME_MIN_DB = 6.0
# And how far clear of the runner-up, so a noisy room cannot produce a coin flip.
ME_MARGIN_DB = 4.0
# And how much overlapping mic audio must exist before the comparison means
# anything. A mic that died thirty seconds in should not get to decide who you
# are for the rest of the meeting.
ME_MIN_SECONDS = 20.0
EPS = 1e-9

# Minimum RMS energy on the microphone track for a segment to be considered active speech.
MIC_MIN_RMS = 0.025
# Window around mic segments (seconds) to search for matching system speech.
BLEED_SEARCH_WINDOW = 5.0


def log(message):
    print(f"attribute: {message}", file=sys.stderr, flush=True)


def read_wav_mono(path):
    """Reads a 16-bit mono WAV into a float array plus its sample rate."""
    with wave.open(path, "rb") as handle:
        channels = handle.getnchannels()
        width = handle.getsampwidth()
        rate = handle.getframerate()
        frames = handle.readframes(handle.getnframes())

    if width != 2:
        raise ValueError(f"{path}: expected 16-bit samples, got {width * 8}-bit")

    samples = np.frombuffer(frames, dtype="<i2").astype(np.float32) / 32768.0
    if channels > 1:
        samples = samples.reshape(-1, channels).mean(axis=1)
    return samples, rate


def rms(samples, rate, start, end):
    """Root mean square over a time window. Boundary offsets (such as slight mic
    sync deltas) clamp to available samples as long as at least 75% of the window
    or 0.2s of audio is preserved."""
    first = int(start * rate)
    last = int(end * rate)
    first_clamped = max(0, first)
    last_clamped = min(len(samples), last)
    if last_clamped <= first_clamped:
        return None
    valid_len = last_clamped - first_clamped
    orig_len = max(1, last - first)
    if (valid_len / orig_len < 0.75) and (valid_len / rate < 0.2):
        return None
    window = samples[first_clamped:last_clamped]
    if window.size == 0:
        return None
    return float(np.sqrt(np.mean(np.square(window))))


def load_whisper_segments(path, shift=0.0):
    """whisper.cpp JSON to [(start, end, text)], times in seconds."""
    if not path or not os.path.exists(path):
        return []

    with open(path, "r", encoding="utf-8") as handle:
        payload = json.load(handle)

    out = []
    for item in payload.get("transcription", []):
        offsets = item.get("offsets") or {}
        text = (item.get("text") or "").strip()
        if not text:
            continue
        start = offsets.get("from")
        end = offsets.get("to")
        if start is None or end is None:
            continue
        out.append((start / 1000.0 + shift, end / 1000.0 + shift, text))
    out.sort(key=lambda s: s[0])
    return out


def overlap(a_start, a_end, b_start, b_end):
    return max(0.0, min(a_end, b_end) - max(a_start, b_start))


def speaker_for(start, end, diarization):
    """The diarized speaker overlapping this span the most."""
    best_label, best_overlap = None, 0.0
    for segment in diarization:
        shared = overlap(start, end, segment["start"], segment["end"])
        if shared > best_overlap:
            best_label, best_overlap = segment["speaker"], shared

    if best_label is not None:
        return best_label

    # No overlap at all, which happens on segments that land in a gap. Take the
    # nearest neighbour if it is close, otherwise leave it unattributed.
    nearest, distance = None, float("inf")
    for segment in diarization:
        gap = max(segment["start"] - end, start - segment["end"], 0.0)
        if gap < distance:
            nearest, distance = segment["speaker"], gap
    return nearest if distance <= 1.0 else None


def find_me(diarization, system, system_rate, mic, mic_rate, offset):
    """Which cluster is the user, judged by mic-versus-call energy in dB."""
    if mic is None:
        return None, {}

    totals = {}
    for segment in diarization:
        start, end = segment["start"], segment["end"]
        call = rms(system, system_rate, start, end)
        own = rms(mic, mic_rate, start - offset, end - offset)
        if call is None or own is None:
            continue
        weight = end - start
        bucket = totals.setdefault(segment["speaker"], {"call": 0.0, "own": 0.0, "weight": 0.0})
        bucket["call"] += call * weight
        bucket["own"] += own * weight
        bucket["weight"] += weight

    covered = sum(bucket["weight"] for bucket in totals.values())
    if covered < ME_MIN_SECONDS:
        log(f"only {covered:.1f}s of mic audio lines up with the call, not enough to identify you")
        return None, {}

    scores = {}
    for label, bucket in totals.items():
        if bucket["weight"] <= 0:
            continue
        call = bucket["call"] / bucket["weight"]
        own = bucket["own"] / bucket["weight"]
        scores[label] = 20.0 * math.log10((own + EPS) / (call + EPS))

    if not scores:
        return None, {}

    ranked = sorted(scores.items(), key=lambda pair: pair[1], reverse=True)
    top_label, top_db = ranked[0]
    runner_up_db = ranked[1][1] if len(ranked) > 1 else -math.inf

    for label, value in ranked:
        log(f"cluster {label}: mic is {value:+.1f} dB relative to call audio")

    if top_db < ME_MIN_DB:
        log(f"no cluster is clearly you (best {top_db:+.1f} dB, need {ME_MIN_DB:+.1f})")
        return None, scores
    if runner_up_db > -math.inf and (top_db - runner_up_db) < ME_MARGIN_DB:
        log(f"{top_label} leads by only {top_db - runner_up_db:.1f} dB, too close to call it")
        return None, scores

    log(f"{top_label} is you ({top_db:+.1f} dB)")
    return top_label, scores


def is_acoustic_bleed(start, end, text, mic, mic_rate, system, system_rate, offset, system_segments):
    """Determines whether a mic segment is acoustic bleed from the call audio.

    Returns True if the segment is acoustic bleed or inactive (should be filtered out),
    False if it represents genuine speech from the local user ("Me").
    """
    clean_text = re.sub(r"[^\w\s]", "", text.lower()).strip()
    words = [w for w in clean_text.split() if len(w) > 1]
    if not words:
        return True

    # Drop isolated filler words
    if clean_text in {"um", "uh", "mm", "mhm"}:
        return True

    m_rms = rms(mic, mic_rate, start - offset, end - offset) if mic is not None else None
    if m_rms is None or m_rms < 0.005:
        return True

    if system is None or not system_segments:
        return False

    s_rms = rms(system, system_rate, start, end) or 0.0
    diff_db = 20.0 * math.log10((m_rms + EPS) / (s_rms + EPS))

    overlapping_sys = [
        stext for ss, se, stext in system_segments
        if overlap(start, end, ss - BLEED_SEARCH_WINDOW, se + BLEED_SEARCH_WINDOW) > 0
    ]
    if overlapping_sys:
        sys_combined = " ".join(overlapping_sys)
        sys_clean = re.sub(r"[^\w\s]", "", sys_combined.lower()).strip()
        sys_words = set(w for w in sys_clean.split() if len(w) > 1)

        matched_words = [w for w in words if w in sys_words]
        word_ratio = len(matched_words) / len(words)

        bigrams = [f"{words[i]} {words[i+1]}" for i in range(len(words) - 1)]
        matched_bg = [bg for bg in bigrams if bg in sys_clean]
        bg_ratio = (len(matched_bg) / len(bigrams)) if bigrams else word_ratio

        # Text matching bleed
        if bg_ratio >= 0.30 or word_ratio >= 0.55:
            return True
        if s_rms >= 0.035 and (bg_ratio >= 0.15 or word_ratio >= 0.40):
            return True

    # Removed energy-based bleed filter. If the mic text doesn't strongly overlap
    # with the system track text, it is genuine cross-talk, not acoustic bleed.

    return False


def hhmmss(seconds):
    seconds = int(max(0.0, seconds))
    return f"{seconds // 3600:02d}:{(seconds % 3600) // 60:02d}:{seconds % 60:02d}"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--diarization", required=True)
    parser.add_argument("--system-json", required=True)
    parser.add_argument("--system-audio", required=True)
    parser.add_argument("--mic-json", default="")
    parser.add_argument("--mic-audio", default="")
    parser.add_argument("--offset", type=float, default=0.0,
                        help="seconds to add to mic times to reach system time")
    parser.add_argument("--my-name", default="")
    parser.add_argument("--out", required=True)
    parser.add_argument("--speakers-out", default="")
    args = parser.parse_args()

    with open(args.diarization, "r", encoding="utf-8") as handle:
        diarization = json.load(handle).get("segments", [])
    if not diarization:
        log("diarization produced no segments")
        return 1

    system_segments = load_whisper_segments(args.system_json)
    if not system_segments:
        log("no transcribed segments from the call audio")
        return 1

    system, system_rate = read_wav_mono(args.system_audio)

    mic, mic_rate = None, 0
    if args.mic_audio and os.path.exists(args.mic_audio):
        mic, mic_rate = read_wav_mono(args.mic_audio)

    me_label, _ = find_me(diarization, system, system_rate, mic, mic_rate, args.offset)

    # Everything the call audio heard, attributed. Your own lines are set aside
    # rather than dropped, because the mic version might not survive the filter
    # below and losing your half of the meeting is the worst outcome here.
    attributed = []
    mine_from_call = []

    for start, end, text in system_segments:
        label = speaker_for(start, end, diarization)
        item = {"start": start, "end": end, "label": label, "text": text}
        if me_label is not None and label == me_label:
            mine_from_call.append(item)
        else:
            attributed.append(item)

    # Process mic track: decouple "Me" from call-track diarization clusters.
    # Active mic speech passing VAD and acoustic bleed filtering is attributed to "Me".
    has_mic_text = bool(args.mic_json and os.path.exists(args.mic_json))
    replaced_spans = []

    if has_mic_text:
        mic_segments = load_whisper_segments(args.mic_json, shift=args.offset)

        # Drop repetitive silence hallucinations from quiet mic tracks (e.g. repeated "Thank you.")
        cleaned_mic = []
        last_norm = ""
        repeat_count = 0
        for start, end, text in mic_segments:
            norm = re.sub(r"[^\w\s]", "", text.strip().lower())
            if norm == last_norm and norm in {"thank you", "thanks for watching", "bye", "subtitles", "you"}:
                repeat_count += 1
                if repeat_count >= 2:
                    continue
            else:
                repeat_count = 1
                last_norm = norm
            cleaned_mic.append((start, end, text))
        mic_segments = cleaned_mic

        for start, end, text in mic_segments:
            if is_acoustic_bleed(
                start, end, text, mic, mic_rate, system, system_rate, args.offset, system_segments
            ):
                continue
            attributed.append({"start": start, "end": end, "label": "Me", "text": text})
            replaced_spans.append((start, end))

        log(f"kept {len(replaced_spans)} of {len(mic_segments)} mic segments as your speech")

        # If a call diarization cluster was identified as "Me", restore any segments
        # that the mic did not cover from call audio.
        restored = 0
        for item in mine_from_call:
            duration = max(item["end"] - item["start"], EPS)
            done = sum(overlap(item["start"], item["end"], a, b) for a, b in replaced_spans)
            if done / duration < 0.5:
                attributed.append(item)
                restored += 1
        if restored:
            log(f"restored {restored} of your segments from the call audio, uncovered by the mic")
    else:
        attributed.extend(mine_from_call)

    attributed.sort(key=lambda item: item["start"])

    # Names: Me first, then Speaker N in order of first appearance.
    display = {"Me": "Me"}
    if me_label is not None:
        display[me_label] = "Me"
    counter = 0
    for item in attributed:
        label = item["label"]
        if label is None or label in display:
            continue
        counter += 1
        display[label] = f"Speaker {counter}"

    # Merge neighbouring segments from the same speaker into readable blocks.
    blocks = []
    for item in attributed:
        name = display.get(item["label"], "Unattributed")
        if blocks and blocks[-1]["name"] == name:
            blocks[-1]["text"].append(item["text"])
            blocks[-1]["end"] = item["end"]
        else:
            blocks.append({"name": name, "start": item["start"], "end": item["end"],
                           "text": [item["text"]]})

    with open(args.out, "w", encoding="utf-8") as handle:
        for block in blocks:
            handle.write(f"**{block['name']}** · {hhmmss(block['start'])}\n\n")
            handle.write(" ".join(block["text"]).strip() + "\n\n")

    # Talk time per speaker, which gives the naming pass something to work with:
    # the person who talked for twenty minutes is rarely the one who said hello.
    if args.speakers_out:
        talk = {}
        for block in blocks:
            talk[block["name"]] = talk.get(block["name"], 0.0) + (block["end"] - block["start"])
        # Unattributed is a bucket of unknown people, not a speaker, so it never
        # goes in the map for naming.
        talk.pop("Unattributed", None)
        order = sorted(talk.items(), key=lambda pair: (pair[0] != "Me", -pair[1]))
        with open(args.speakers_out, "w", encoding="utf-8") as handle:
            for name, seconds in order:
                resolved = args.my_name if (name == "Me" and args.my_name) else "?"
                handle.write(f"{name}|{int(round(seconds))}|{resolved}\n")

    log(f"{len(blocks)} blocks across {len(set(b['name'] for b in blocks))} speakers")
    return 0


if __name__ == "__main__":
    sys.exit(main())

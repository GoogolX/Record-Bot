#!/usr/bin/env python3
"""Speaker diarization with pyannote.audio.

Answers who spoke when, and nothing about what was said. Works on voice
characteristics rather than words, so accent and language do not matter here.

Writes JSON:  {"segments": [{"start": 12.31, "end": 15.02, "speaker": "SPEAKER_01"}, ...]}

Two compatibility notes, both learned the hard way:

* pyannote 3.x calls torchaudio.list_audio_backends(), which torchaudio 2.9
  removed, so 4.x is required on any recent install. 4.0 also renamed the
  `use_auth_token` argument to `token`. Both spellings are tried below.
* Rather than handing pyannote a file path, which sends it down a decoding path
  that wants FFmpeg via torchcodec, the WAV is read here with the standard
  library and passed in as a waveform. Fewer moving parts, no system codecs.
"""

import argparse
import json
import os
import sys
import wave

MODELS = [
    "pyannote/speaker-diarization-community-1",
    "pyannote/speaker-diarization-3.1",
]


def log(message):
    print(f"diarize: {message}", file=sys.stderr, flush=True)


def load_pipeline(token, preferred=""):
    """Loads the first pipeline that will actually load, across pyannote versions."""
    from pyannote.audio import Pipeline

    candidates = [preferred] if preferred else []
    candidates += [name for name in MODELS if name != preferred]

    problems = []
    for name in candidates:
        for keyword in ("token", "use_auth_token"):
            try:
                pipeline = Pipeline.from_pretrained(name, **{keyword: token})
            except TypeError as exc:
                # Wrong argument name for this version; try the other spelling.
                problems.append(f"{name} ({keyword}): {exc}")
                continue
            except Exception as exc:
                problems.append(f"{name} ({keyword}): {exc}")
                break
            if pipeline is not None:
                log(f"loaded {name}")
                return pipeline, name
            problems.append(f"{name}: returned None, the token probably lacks access")
            break

    for problem in problems:
        log(problem)
    return None, ""


def read_waveform(path):
    """16-bit WAV to a (1, samples) float tensor, without any audio backend."""
    import numpy as np
    import torch

    with wave.open(path, "rb") as handle:
        channels = handle.getnchannels()
        width = handle.getsampwidth()
        rate = handle.getframerate()
        frames = handle.readframes(handle.getnframes())

    if width != 2:
        raise ValueError(f"{path}: expected 16-bit samples, got {width * 8}-bit")

    samples = np.frombuffer(frames, dtype="<i2").astype("float32") / 32768.0
    if channels > 1:
        samples = samples.reshape(-1, channels).mean(axis=1)

    return torch.from_numpy(samples.copy()).unsqueeze(0), rate


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("audio", nargs="?", help="16 kHz mono WAV")
    parser.add_argument("--out", default="")
    parser.add_argument("--min-speakers", type=int, default=0)
    parser.add_argument("--max-speakers", type=int, default=0)
    parser.add_argument("--model", default="", help="override the pipeline to load")
    parser.add_argument("--token", default="")
    parser.add_argument("--selftest", action="store_true",
                        help="load the pipeline and exit, used by setup")
    args = parser.parse_args()

    token = args.token or os.environ.get("HF_TOKEN", "")
    if not token:
        log("no Hugging Face token, cannot load the pretrained pipeline")
        return 2

    try:
        import torch  # noqa: F401
        from pyannote.audio import Pipeline  # noqa: F401
    except ImportError as exc:
        log(f"missing dependency: {exc}")
        log("run scripts/setup-diarization.sh")
        return 3

    pipeline, _ = load_pipeline(token, args.model)
    if pipeline is None:
        log("could not load any diarization pipeline")
        log("the models are gated: accept the terms at")
        for name in MODELS:
            log(f"  https://hf.co/{name}")
        return 4

    if args.selftest:
        log("selftest passed")
        return 0

    if not args.audio or not args.out:
        log("need an audio file and --out")
        return 2

    import torch

    # MPS gives a solid speedup but has had gaps in op coverage, so fall back to
    # CPU rather than dying halfway through a meeting.
    device = "cpu"
    if torch.backends.mps.is_available():
        try:
            pipeline.to(torch.device("mps"))
            device = "mps"
        except Exception as exc:
            log(f"mps unavailable ({exc}), using cpu")
            pipeline.to(torch.device("cpu"))
    log(f"running on {device}")

    hints = {}
    if args.min_speakers > 0:
        hints["min_speakers"] = args.min_speakers
    if args.max_speakers > 0:
        hints["max_speakers"] = args.max_speakers

    try:
        waveform, rate = read_waveform(args.audio)
        annotation = pipeline({"waveform": waveform, "sample_rate": rate}, **hints)
    except Exception as exc:
        log(f"diarization failed: {exc}")
        return 5

    # pyannote 4 wraps the annotation; older versions return it directly.
    annotation = getattr(annotation, "speaker_diarization", annotation)

    segments = [
        {"start": round(turn.start, 3), "end": round(turn.end, 3), "speaker": label}
        for turn, _, label in annotation.itertracks(yield_label=True)
        if turn.end - turn.start >= 0.2  # drop blips that carry no words
    ]
    segments.sort(key=lambda s: s["start"])

    speakers = sorted({s["speaker"] for s in segments})
    with open(args.out, "w", encoding="utf-8") as handle:
        json.dump({"segments": segments, "speakers": speakers}, handle, indent=1)

    log(f"{len(segments)} segments across {len(speakers)} speakers")
    return 0


if __name__ == "__main__":
    sys.exit(main())

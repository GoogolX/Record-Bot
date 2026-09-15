"""Unit tests for speaker attribution arithmetic. No models, no meetings."""

from __future__ import annotations

import sys
import tempfile
import unittest
import wave
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

import attribute  # noqa: E402


def write_sine(path: Path, seconds: float, amplitude: float, rate: int = 16_000) -> None:
    n = int(seconds * rate)
    t = np.arange(n, dtype=np.float32)
    samples = (amplitude * np.sin(2 * np.pi * 220.0 * t / rate)).clip(-1, 1)
    pcm = (samples * 32767).astype("<i2")
    with wave.open(str(path), "wb") as handle:
        handle.setnchannels(1)
        handle.setsampwidth(2)
        handle.setframerate(rate)
        handle.writeframes(pcm.tobytes())


class OverlapTests(unittest.TestCase):
    def test_partial_overlap(self):
        self.assertAlmostEqual(attribute.overlap(0, 10, 8, 12), 2.0)

    def test_no_overlap(self):
        self.assertEqual(attribute.overlap(0, 1, 2, 3), 0.0)

    def test_contained(self):
        self.assertAlmostEqual(attribute.overlap(0, 10, 2, 5), 3.0)


class SpeakerForTests(unittest.TestCase):
    def setUp(self):
        self.diar = [
            {"start": 0.0, "end": 4.0, "speaker": "A"},
            {"start": 4.0, "end": 8.0, "speaker": "B"},
        ]

    def test_max_overlap_wins(self):
        self.assertEqual(attribute.speaker_for(3.0, 5.0, self.diar), "A")
        self.assertEqual(attribute.speaker_for(3.5, 7.0, self.diar), "B")

    def test_gap_within_one_second_uses_nearest(self):
        diar = [{"start": 0.0, "end": 1.0, "speaker": "A"}]
        self.assertEqual(attribute.speaker_for(1.2, 1.5, diar), "A")

    def test_far_gap_is_unattributed(self):
        diar = [{"start": 0.0, "end": 1.0, "speaker": "A"}]
        self.assertIsNone(attribute.speaker_for(5.0, 6.0, diar))


class WhisperJsonTests(unittest.TestCase):
    def test_offsets_are_milliseconds(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "system.json"
            path.write_text(
                '{"transcription":[{"text":" hello ","offsets":{"from":1500,"to":2200}}]}',
                encoding="utf-8",
            )
            segs = attribute.load_whisper_segments(str(path), shift=0.1)
            self.assertEqual(len(segs), 1)
            start, end, text = segs[0]
            self.assertAlmostEqual(start, 1.6)
            self.assertAlmostEqual(end, 2.3)
            self.assertEqual(text, "hello")


class FindMeTests(unittest.TestCase):
    def test_loud_mic_cluster_is_me(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            # 22s of "me" (loud mic, quiet call) then 4s of someone else.
            write_sine(root / "system.wav", 26.0, 0.08)
            write_sine(root / "mic.wav", 26.0, 0.08)
            system, srate = attribute.read_wav_mono(str(root / "system.wav"))
            mic, mrate = attribute.read_wav_mono(str(root / "mic.wav"))

            me_end = int(22 * srate)
            system[:me_end] *= 0.05
            mic[me_end:] *= 0.05

            diar = [
                {"start": 0.0, "end": 22.0, "speaker": "SPEAKER_00"},
                {"start": 22.0, "end": 26.0, "speaker": "SPEAKER_01"},
            ]
            label, scores = attribute.find_me(diar, system, srate, mic, mrate, 0.0)
            self.assertEqual(label, "SPEAKER_00")
            self.assertGreater(scores["SPEAKER_00"], attribute.ME_MIN_DB)
            self.assertGreater(
                scores["SPEAKER_00"] - scores["SPEAKER_01"], attribute.ME_MARGIN_DB
            )

    def test_short_mic_coverage_refuses_to_guess(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            write_sine(root / "system.wav", 8.0, 0.1)
            write_sine(root / "mic.wav", 8.0, 0.8)
            system, srate = attribute.read_wav_mono(str(root / "system.wav"))
            mic, mrate = attribute.read_wav_mono(str(root / "mic.wav"))
            diar = [{"start": 0.0, "end": 8.0, "speaker": "SPEAKER_00"}]
            label, _ = attribute.find_me(diar, system, srate, mic, mrate, 0.0)
            self.assertIsNone(label)


class AcousticBleedTests(unittest.TestCase):
    def test_genuine_me_speech_not_bleed(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            write_sine(root / "system.wav", 10.0, 0.001)
            write_sine(root / "mic.wav", 10.0, 0.1)
            system, srate = attribute.read_wav_mono(str(root / "system.wav"))
            mic, mrate = attribute.read_wav_mono(str(root / "mic.wav"))
            sys_segs = [(0.0, 4.0, "hello everyone on the call")]
            # User talking into mic with distinct words
            bleed = attribute.is_acoustic_bleed(
                2.0, 6.0, "i am giving my update now",
                mic, mrate, system, srate, 0.0, sys_segs
            )
            self.assertFalse(bleed)

    def test_speaker_acoustic_bleed_detected_by_text(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            write_sine(root / "system.wav", 10.0, 0.08)
            write_sine(root / "mic.wav", 10.0, 0.08)
            system, srate = attribute.read_wav_mono(str(root / "system.wav"))
            mic, mrate = attribute.read_wav_mono(str(root / "mic.wav"))
            sys_segs = [(1.0, 5.0, "do you want to go first with the update")]
            # Mic picked up speaker text through bleed
            bleed = attribute.is_acoustic_bleed(
                1.0, 5.0, "do you want to go first with the update",
                mic, mrate, system, srate, 0.0, sys_segs
            )
            self.assertTrue(bleed)

    def test_speaker_acoustic_bleed_detected_by_energy(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            write_sine(root / "system.wav", 10.0, 0.1)
            write_sine(root / "mic.wav", 10.0, 0.03)  # Mic is much quieter than call audio
            system, srate = attribute.read_wav_mono(str(root / "system.wav"))
            mic, mrate = attribute.read_wav_mono(str(root / "mic.wav"))
            sys_segs = [(1.0, 5.0, "someone speaking loud on the conference")]
            bleed = attribute.is_acoustic_bleed(
                1.0, 5.0, "muffled speech picked up faintly",
                mic, mrate, system, srate, 0.0, sys_segs
            )
            self.assertTrue(bleed)

    def test_silent_mic_filtered_as_bleed_or_inactive(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            write_sine(root / "system.wav", 10.0, 0.001)
            write_sine(root / "mic.wav", 10.0, 0.001)  # Quiet mic below VAD threshold
            system, srate = attribute.read_wav_mono(str(root / "system.wav"))
            mic, mrate = attribute.read_wav_mono(str(root / "mic.wav"))
            bleed = attribute.is_acoustic_bleed(
                1.0, 5.0, "hallucinated whisper text during silence",
                mic, mrate, system, srate, 0.0, []
            )
            self.assertTrue(bleed)


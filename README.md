# RecordBot

A menu bar app that records whatever audio is playing on your Mac, transcribes it locally,
and hands the text to a local LLM for summaries and a running action-items list.

Nothing here talks to a paid API. Whisper runs on your machine; the summarizing runs inside
Ollama instantly in the background.

## Install

```bash
cd ~/Documents/Record-Bot
bash scripts/setup.sh
```

That builds whisper.cpp, downloads the model, compiles the app, and creates the folders.
Expect five to ten minutes the first time, mostly model download and the C++ build.

Then:

1. Double-click `RecordBot.app`. A small dot appears in your menu bar. No Dock icon.
2. Press `⌃⌥R`. macOS blocks the first attempt and opens
   **System Settings › Privacy & Security › Screen & System Audio Recording**.
   Turn RecordBot on, quit the app, reopen it.
3. Press `⌃⌥R` again. The menu bar shows `● REC` with a running clock.

Optional, so you never have to think about it again:

```bash
bash scripts/install-login-item.sh
```

## Using it

`⌃⌥R` starts. `⌃⌥R` stops. That's the whole interface, though the menu bar dropdown
has the same controls plus shortcuts to the folders.

When you stop, a panel appears with four optional fields:

- **Title** — becomes part of the filename, so the folder is skimmable.
- **Who was there, what it was for** — lets the summarizer reason about who said what.
- **A question for the summarizer** — answered in its own section of the summary, or
  explicitly marked unanswered.
- **Your own notes** — multi-line, paste-friendly. These are treated as authoritative:
  where your notes and the transcript disagree, your notes win, and every action item
  says whether it came from your notes, the transcript, or both.

Hit Skip and it files as "Untitled meeting". Hit Discard and the recording is
immediately removed without transcribing. Your notes are worth typing even when the
audio was bad, since a meeting with good notes and unusable speech still gets a real
summary.

Then the app fires the transcription in the background and gets out of the way.
A 45-minute meeting takes roughly two to four minutes to transcribe on Apple Silicon with
the small model. You can start another recording while one is transcribing.

## Speakers

Two mechanisms, and they work independently.

**Your own track.** RecordBot records your microphone to a separate file alongside the
call audio. Since both are captured by the same process, lining them up is bookkeeping
rather than guesswork, and your voice being loud in one and absent from the other
identifies your own speech by comparing energy. No model involved. Your lines are also
transcribed from the mic rather than from call audio that has been through a codec, which
is noticeably more accurate.

**Diarization.** Optional, and worth the setup:

```bash
bash scripts/setup-diarization.sh
```

That installs pyannote.audio into `vendor/venv` and stores a Hugging Face token, which is
only used to download the gated models once. About 2 GB, mostly PyTorch, then everything
runs locally. Afterwards transcripts arrive split by speaker:

```
**Me** · 00:04:12
I said we would send the revised numbers on Thursday.

**Speaker 1** · 00:04:31
That works. October is fine for the migration.
```

Set `MIN_SPEAKERS` and `MAX_SPEAKERS` in `scripts/config.sh` when you know roughly how
many people to expect. It measurably improves the clustering.

Without diarization installed you still get transcripts, just unattributed. Nothing
hard-fails for want of an extra.

### Putting names to speakers

`Speaker 1` is not much use on its own, so the summarizer works out who each one is. It
reads the transcript for direct address, uses your context field as the candidate list,
and weighs talk time and topic fit. Then it writes its conclusions into the transcript
header with a confidence and the evidence behind each one:

```yaml
speakers:
  - "Me": "K"  # 12 min of speech
  - "Speaker 1": "Priya Nair (high)"  # 18 min of speech
  - "Speaker 2": "unresolved"  # 4 min of speech
speaker_evidence:
  - "Speaker 1": "addressed as Priya twice, describes the finance team as my team"
```

Header values are quoted because meeting titles contain colons and hash marks often
enough to break a parser otherwise.

Only high and medium confidence names appear in the summary. Anything weaker stays as
`Speaker N` rather than being asserted.

If it gets one wrong, fix the name in that block and set `status:` back to
`awaiting-summary`. The next run regenerates the summary with your correction and treats
it as fact.

## Checking on a transcription

Three ways, in increasing detail.

**Menu bar title.** `◉` idle, `● 4:12` recording, `⋯` while a transcription runs,
`⋯3` for three of them, `⚠` when one failed.

**The dropdown.** A Transcription section lists each running job with its stage
(`queued`, `converting`, `transcribing`, `writing`), PID, and elapsed time. Click any
running job to cancel it immediately. Failed jobs appear with a Retry entry; hover
to see the failure reason. Below that, a Summaries section shows how many transcripts
are still awaiting summarization.

**The terminal.**

```bash
bash scripts/status.sh            # snapshot
bash scripts/status.sh -w         # refreshes every 2 seconds
bash scripts/status.sh -r         # retry all failed jobs
bash scripts/status.sh -c         # clean resolved failure markers and stale locks
bash scripts/status.sh -k <job>   # terminate a running job
```

Under the hood each job tracks its PID in `Status/`. Stale markers from terminated
or crashed processes are automatically detected and marked for retry.

## Where things land

| Path | What's in it |
|---|---|
| `Recordings/` | Call audio plus a `.mic.wav` track, deleted after transcription unless `KEEP_AUDIO="yes"` |
| `Status/` | One marker file per in-flight job. Empty means nothing is running |
| `Transcripts/` | One file per meeting, named `<timestamp>__<title-slug>.md` |
| `Summaries/` | One summary per meeting, matching the transcript filename |
| `ACTION-ITEMS.md` | The live doc: one section per meeting, newest first, each with its own action table |
| `recordbot.log` | What happened, in order, when something looks stuck |

## Settings

`scripts/config.sh` holds everything worth changing. The default model is
`large-v3-turbo-q5_0`, around 800 MB, multilingual, and much better on accented English
than the English-only models of similar size while running faster than medium on Metal.

`WHISPER_LANGUAGE` defaults to `en`, which stops a multilingual model from deciding a
heavily accented passage is another language and translating it. Set it to `auto` if your
meetings genuinely switch languages mid-sentence.

`MY_NAME` labels your own track. `DIARIZE` can force diarization on or off rather than
using it when available. `KEEP_AUDIO="yes"` keeps both tracks after transcription, which
is about 10 MB per minute for the pair.

Changing the model means re-running `scripts/setup.sh` to fetch it.

## The Summarizer

A background task automatically runs when transcription completes. For each transcript marked
`status: awaiting-summary` it writes one file into `Summaries/` covering that meeting
alone: what it was for, what was covered, decisions, an action table with owners and a
confidence column, open questions, and a note on transcript quality when the audio was
rough. Then it adds a section for that meeting to `ACTION-ITEMS.md` and flips the status
so nothing is processed twice.

Nothing is merged across meetings. `ACTION-ITEMS.md` is an index of per-meeting tables,
so a commitment made in one call never gets silently blended with a similar one from
another.

Scheduled tasks only run while the Claude app is open. If it was closed when the hour
turned, the task catches up on next launch, so a closed laptop means slightly later
summaries, not lost ones.

You can also run the summarizer manually at any time or generate prompts for web LLMs:

```bash
./scripts/summarize.py                  # summarizes any pending transcript using GEMINI_API_KEY or ANTHROPIC_API_KEY
./scripts/summarize.py --prompt-only    # prints formatted schema prompt for any web LLM
./scripts/summarize.py --dry-run        # previews summary without modifying files
```

## Troubleshooting

**Nothing captured.** Some conferencing apps route audio in a way ScreenCaptureKit
can't see if they hold an exclusive device. Check `recordbot.log`; if the WAV was under
1 KB, no audio reached the stream.

**Hotkey does nothing.** Another app already owns `⌃⌥R`. The menu bar dropdown still
works; to change the key, edit `kVK_ANSI_R` in `Sources/RecordBot/main.swift` and
re-run `scripts/build-app.sh`.

**Transcript is garbled.** You are already on the largest practical model. Check
`WHISPER_LANGUAGE` matches what was actually spoken, and look at the log for the mic
format warning, which means your own track was dropped.

**No `**Me**` blocks appear.** The log says why. Either the mic track was missing, or the
energy comparison could not separate you from the room, which happens on laptop speakers
at high volume. Headphones fix it. The diarization still works, you just show up as a
numbered speaker.

**Diarization never runs.** It only runs when `vendor/venv` and `.hf_token` both exist.
Set `DIARIZE="yes"` in the config to make a missing install a hard failure instead of a
silent skip.

**Permission prompt keeps returning.** The app must be launched as the bundle, not as
the bare binary in `.build/`. Re-run `scripts/build-app.sh` and open `RecordBot.app`.

## A note on consent

Recording other people in a meeting is governed by law that varies by state and country,
and by whatever your employer's policy says. Announcing it at the top of the call covers
almost every case.

## Rebuilding after edits

```bash
bash scripts/build-app.sh
```

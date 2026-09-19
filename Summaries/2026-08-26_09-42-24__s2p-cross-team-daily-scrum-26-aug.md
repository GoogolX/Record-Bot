# S2P Cross-Team Daily Scrum  26-Aug
_2026-08-26 09:42 · 8 min_

Short cross-team standup on the WD Data Modernization engagement, covering procurement, the EDW table build, and the Model N handover. Procurement is stalled behind an open issue, so nothing moved there. The EDW build is the healthy stream: four more tables closed overnight to reach 46, with seven more targeted for tonight's call and the rest of EDW promised by end of week, handing off to Fanny's team for validation as each one lands. Model N is the problem area, with shipment building and sales order both blocked and now slipping to 31 August because most of the engineers are out on Friday the 28th. The meeting ended on a handoff-quality complaint about how the Model N SQL files are being dropped into SharePoint without notice or structure.

## Who was in it

- **Mary** (Speaker 2, inferred, medium confidence) — about 3 min. Ran the round, pressed for numbers and dates on EDW and Model N, and screen-shared the SharePoint documentation folder.
- **Speaker 3** — about 3 min. Reported for the team building the EDW tables; owns the counts, the handoff to Fanny's team, and the complaint about handoff quality. Name not determinable from the audio.
- **Speaker 1** — about 20 sec. Opened the procurement round and little else.
- **Speaker 4** — about 15 sec, nearly all of it corrupted audio.

## What was covered

- Procurement is at a standstill: an issue is still open, so there was no progress on the procurement data set.
- EDW table build moved from four done in the morning to four more closed out of the five in the pipeline, putting the running total at 46. Seven more are targeted for tonight's call, expected complete by US morning tomorrow (27 Aug).
- Speaker 3 committed to the rest of EDW by end of this week, with no external dependencies inside the team.
- Completed EDW tables go to Fanny's team for validation as they are finished.
- Model N is blocking shipment building and sales order. Engineers revised their timelines and most are out on Friday 28 Aug, so both slip to 31 Aug. The sales order fact is not fully built either and carries the same Model N dependency.
- Total table count stands at 180, unchanged; 9 have been handed over on the Model N side.
- AR transaction documentation was uploaded to the finance SharePoint folder on Monday, but Speaker 3's team was unaware. They asked for a notification whenever a new model is uploaded rather than having to re-check the folder.
- Speaker 3 flagged the current Model N folder layout as a bad pattern: "this is exactly how we don't want our handoffs to be in future," referencing a discussion held with Vishwa the previous day.

## Decisions

- Shipment building and sales order Model N deliverables move to 31 August, since Friday 28 August is largely unavailable (agreed between Mary and Speaker 3).
- Tonight's call is the checkpoint for seven additional EDW tables, with completion expected by US morning on 27 August.
- Mary agreed to copy the AR transaction documentation link across rather than leaving the team to find it in SharePoint.
- Handoff format for Model N will be respecified; Speaker 3 said he would walk through the expected structure on the shared screen.

## Action items

| Owner | Action | Due | Source | Confidence |
| --- | --- | --- | --- | --- |
| Speaker 3 | Close out seven more EDW tables and report at tonight's call | 2026-08-27, US morning | transcript | high |
| Speaker 3 | Finish the remaining EDW tables and hand them to Fanny's team for validation | end of week (2026-08-28) | transcript | high |
| Speaker 3 | Find out what is actually blocking Model N on shipment building and sales order, and bring exact details to tonight's call | tonight's call (2026-08-26) | transcript | high |
| Speaker 3 | Ask Vodas for the target date to hand over the additional Model N tables | not stated | transcript | high |
| Mary | Copy the AR transaction documentation link to the team | not stated | transcript | high |
| Mary | Send a notification when a new model is uploaded to the SharePoint folder, instead of relying on the team to re-check it | ongoing | transcript | medium |
| Speaker 3 | Walk through the expected Model N handoff structure, per the discussion with Vishwa | not stated | transcript | medium |

## Open questions

- What specifically is blocking Model N for shipment building and sales order. Speaker 3 had not yet connected with the engineers and was relaying a high-level account.
- The target date for handing over the additional Model N tables, pending an answer from Vodas.
- Whether the procurement issue has an owner or a path to resolution; the standup noted it was open and moved on.

## Notes on transcript quality

- A roughly 50-second stretch from 04:54 to 05:45 is destroyed. Whisper looped the phrase "I'm supposed to pay for that" across five speaker turns and three `**Unattributed**` blocks. Nothing in that window is recoverable, and it sits right after the mention of supply chain, so a topic may have been lost.
- `own_mic_track: yes` is set, but there are no `**Me**` blocks at all. Either you did not speak or your microphone track was not captured.
- Only one speaker could be named. Speaker 3 is the main reporter for the whole meeting and stays anonymous, so most of the substance above is attributed to a label rather than a person.
- The address to Mary at 07:19 is answered by two different labels within twelve seconds, which is why the Mary assignment is medium rather than high.
- Several proper nouns are Whisper's best guess and may be misspelled: "Fanny" (validation team lead), "Vodas", "Vishwa", and "Model N" as a system name. Numbers are stated clearly and were confirmed aloud, so 46, 180, 9, five, four and seven should be reliable.

# Meeting on CDC Framework with Hari
_2026-08-25 22:58 · 26 min_

This was a code-review walkthrough of the incremental CDC framework being built for the AWS Gold layer, presented to Hari with Shubham and Trinadh on the call. The presenter walked through the mechanics: pull changed primary keys from each silver table since the last successful watermark, union them with keys from the driving table (item effectivity), re-run the full calculation logic for only those keys, then merge the result into the final table and update the watermark in DynamoDB. Surrogate keys are deliberately left untouched on update, because updating them broke dimension-to-fact joins previously. Hari accepted the base flow but pushed hard on three edge cases the design does not yet cover, most seriously the case where a lookup or left-outer-join table changes without its watermark column being updated. The meeting ended without those cases resolved; the agreed next step is a hands-on test tomorrow using one fact table and a couple of dimensions, running both an incremental and a full refresh to confirm keys stay stable and joins do not break.

## Answer to your question

> What does Hari want?

Hari wants proof, not a design walkthrough. He said the logic is acceptable to him in principle but that he still has reservations, and the specific thing he wants is a side-by-side validation: take one fact table and two or three dimensions, compare how the integration-ID lookup and surrogate key logic is designed in the current EDW against how it is built on AWS, then run both an incremental load and a full refresh and confirm zero data loss and zero join breakage from key changes. His three unresolved concerns are (1) changes on lookup / left-outer-join tables where more than 20 tables are involved and no trigger fires on the driver, (2) multi-level snowflaked lookups, for example a business sub-segment updated two or three joins away from item or item line, and (3) records where the source last-modified date does not change at all, which the presenter conceded the current approach would not catch. He also wants the same CDC framework carried forward to procurement.

## What was covered

- Incremental CDC mechanics: collect line-identifier keys inserted or updated in each silver table since the last successful run (example baseline: full refresh on 24 August), union them with keys from the driving table (item effectivity), run the calculation logic for that key set only.
- Merge behaviour: for each returned identifier, insert if absent from the final table, otherwise compare columns and update in place. The presenter expects roughly 99% of matched records to show a change.
- Surrogate keys are excluded from updates. Fact tables carry multiple surrogate keys; dimension tables typically only one or two. Updating them previously caused dimension-fact join failures.
- Watermark state is held in DynamoDB and updated as part of the returned result set.
- Testing so far covers two tables only: item and item effectivity, and the silver-side changes were introduced manually rather than arriving naturally from source.
- Gap acknowledged on the call: if a contributing silver table's watermark column is not updated, the change will not be picked up. The presenter said plainly that in that scenario the approach would not work.
- Full-refresh safety: the point of the MD5 hash approach is to avoid key churn, so a full refresh must reproduce identical keys with no join breakage. This needs explicit validation.
- Scheduling: tomorrow is a holiday for part of the team. The KT call is being pushed to Thursday.
- A reconciliation view carried over from EDW was raised — the earlier decision was that it should always be a full refresh rather than incremental. Nobody on the call could recall the reasoning; parked for a short discussion tomorrow.

## Decisions

- The union-of-changed-keys CDC framework will be the standard pattern applied to all remaining silver tables, including procurement, rather than a per-domain approach.
- Surrogate keys will not be updated during incremental merges.
- The KT call scheduled for tomorrow is pushed to Thursday because of the holiday.
- Validation will be done as a paired incremental plus full-refresh run on one fact table and two or three dimensions, with EDW and AWS logic compared side by side.

## Action items

| Owner | Action | Due | Source | Confidence |
| --- | --- | --- | --- | --- |
| Hari | Review how the integration-ID lookup and surrogate key logic is designed in the current EDW for the chosen fact and dimensions, and compare against the AWS build | tomorrow (2026-08-26) | transcript | high |
| Presenter (CDC framework owner, name not clear in audio) | Run an incremental load and a full refresh on one fact table plus two or three dimensions and confirm identical keys and no join breakage | tomorrow (2026-08-26) | transcript | high |
| Presenter (CDC framework owner) | Produce a worked example of the snowflaked-lookup case (e.g. business sub-segment updated two or three joins away) to show whether the framework catches it | not stated | transcript | medium |
| Hari | Check the EDW-vs-AWS mapping sheet for which tables are supposed to be Type 2 | not stated | transcript | medium |
| unassigned | Decide how to handle silver tables whose watermark / last-modified column does not update on change | not stated | transcript | medium |
| Trinadh (name uncertain) | Confirm availability tomorrow given the holiday, and notify the colleague referred to as "Cowship" in the audio if working | tomorrow (2026-08-26) | transcript | low |
| unassigned | Revisit whether the reconciliation view carried over from EDW must always be a full refresh | tomorrow (2026-08-26), short discussion | transcript | medium |

## Open questions

- How does the framework capture a change that occurs two or three join levels away from the driving table, on a context or category lookup, when neither item nor item line changes?
- What happens when the source system's last-modified date is not updated despite a real data change? The presenter conceded the current design misses this.
- Does a full refresh genuinely reproduce identical surrogate and integration keys, so that fact-dimension joins survive it intact?
- Why was the reconciliation view originally designated always-full-refresh? Nobody present could recall.
- Does the same framework hold for procurement, whose table structures differ? The stated plan is yes, but this has not been tested.

## Notes on transcript quality

The audio is unlabeled multi-speaker Whisper output and speaker attribution is unreliable throughout. Hari is identifiable because he is addressed by name; the person presenting the framework is never named, and Shubham and Trinadh cannot be separated from each other in the text. Several passages are garbled: "bottom mark" and "bottom column" are almost certainly "watermark" and "watermark column"; "WD Off" is likely "WFH" or a name plus "off"; "Cowship" is a mangled name; "KTEA" is the KT call; "ADW" and "EDW" are used interchangeably and refer to the same system; "MDFI hash" is almost certainly "MD5 hash"; "regular flow rate" is likely "regular flow". One long stretch in the middle repeats the sentence "So let's assume that this is not updated at all" roughly thirty times, which is a transcription loop, not speech — the actual content of that portion of the meeting is lost. There were no user notes to check any of this against.

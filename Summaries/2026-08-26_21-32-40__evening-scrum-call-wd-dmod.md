# Evening scrum call WD DMOD
_2026-08-26 21:32 · 19 min_

This was an evening status check on the WD Data Modernization project between Gayatri, Trinadh, and Abhay, following up on the morning scrum. The main blocker is still the PO (purchase order) columns, where Trinadh found that source code from Fanny's team doesn't match actual table data (hardcoded zeros in code but real values in the table), forcing a rework of the CDC start date to the 28th. Abhay walked through Dim Organization, recommending it be treated as a full load rather than CDC given its low row counts don't justify the incremental-load effort, which Gayatri approved on the numbers alone. Gayatri also raised frustration that QA/QTest issues from WD's team are eating into the team's own CDC time and plans to escalate timing and scope questions to Zabi.

## Who was in it
- Gayatri (Speaker 1, inferred, high confidence) — 11 min, drove status review, made the full-load call on Dim Organization, planning escalation to Zabi
- Abhay (Speaker 3, inferred, high confidence) — 4 min, reported table-by-table status (Dim Supply Site, Dim Organization, CPN)
- Trinadh (Speaker 2, inferred, high confidence) — 4 min, reported PO column blockers and dependency on Fanny's team

## Answer to your question
**Question:** Overall status and person-wise priorities.

Overall: CDC start is slipping to the 28th because PO column work isn't finished; the root cause is incomplete/incorrect source code from Fanny's team on the D and F purchase-cost tables. Dim Organization will be recommended as a full load rather than CDC (Abhay's call, approved by Gayatri, based on low row counts across most of its 20 source tables). CPN is confirmed full load. QTest handling from WD's side is seen as a drag on the team's CDC timeline and Gayatri plans to push back on that scope with Zabi.

Person-wise: Trinadh finishes PO tomorrow (all day), then moves to CDC; he needs the full D/F table update code from Fanny and will escalate to Zabi if it doesn't arrive in time. Abhay validates the supplier table (quick), finalizes the Dim Organization full-load recommendation, then picks up Employee and two fact tables (Fact Purchase Requisition Line, Fact Invoice Receipt Line) starting the 28th, doing full coding and validation before handing off. Shubham (not on this call) is expected to close AP transaction today/tomorrow, plus Fact Daily Exchange and Fact Global Exchange, and needs to be pulled off QTest support so WD's team owns that investigation.

## What was covered
- Trinadh found that 20 of his assigned PO columns are hardcoded as zero in the converted AWS code (carried over from the EDW D/F purchase-cost table logic), but the actual table has real data, meaning the code doesn't reflect the true update logic. He plans to ask Fanny for all code touching the D and F tables at once rather than asking column by column.
- Fanny had not responded as of the call; he's reportedly on leave and in back-to-back calls. Gayatri told Trinadh to escalate to Zabi if the wait continues.
- Abhay closed out Dim Supply Site as done.
- Dim Organization is in a messy state: dev and QA don't match at the schema level, likely due to legal-entity mergers changing join logic, and QA hasn't had a silver refresh. Abhay recommends full load since most of the 20 source tables are small (many under 5–60 rows), making CDC effort disproportionate to the benefit; Gayatri confirmed the recommendation should be based purely on the numbers, not on avoiding CDC difficulty.
- CPN is confirmed as full load.
- Ownership confusion surfaced on GR Line/IR Line/Purchase Requisition Line status flags (old vs. CDC status); Trinadh confirmed GR is not his, CDC owner is Trinadh for that table per current notes, and Gayatri asked for the owner filter to be fixed on the tracker.
- Abhay committed to having both coding and validation complete (not just coding) before handing off Fact Purchase Requisition Line and Fact Invoice Receipt Line, to avoid rework for whoever picks it up next.
- Gayatri flagged that QTest issues from WD's/Fanny's team have consumed 2–3 days that should have gone to CDC, and wants that work transitioned back to WD's team rather than absorbed by Shubham.
- Trinadh suggested checking whether the 20–30 flagged columns are even used in the Power BI dashboard before continuing to fix them; Gayatri agreed this is worth raising with Fanny but not to delay other work over it.
- Gayatri plans to set time with Zabi to flag dependencies and scope issues, and separately mentioned Hari and Michael Satish as points of contact given a public holiday may affect availability.
- Gayatri raised the team's other, delayed project and suggested that if the 31st (a Saturday) is needed, the team should use lighter days to start ramping on that new project instead.

## Decisions
- Abhay's Dim Organization full-load recommendation approved by Gayatri, based on source table size/effort math.
- CPN confirmed as full load.
- Shubham to be pulled off QTest investigation; that work is to transition back to Fanny's/WD's team.
- Team members should complete both coding and validation before moving to the next table, not just coding.

## Action items

| Owner | Action | Due | Source | Confidence |
|---|---|---|---|---|
| Trinadh | Finish PO column work | Tomorrow (all day) | transcript | high |
| Trinadh | Get full D/F table update code from Fanny; escalate to Zabi if not received by tomorrow morning | Tomorrow morning | transcript | high |
| Trinadh | Move into CDC after PO closes | 28th | transcript | high |
| Trinadh | Ask whether Fanny/team can push testing prioritization based on actual Power BI column usage | Not stated | transcript | medium |
| Abhay | Validate the supplier table (coding already done by Trinadh) | Not stated | transcript | high |
| Abhay | Finalize Dim Organization full-load write-up, color-code it with the other full-load table, and confirm with Fanny | Not stated | transcript | medium |
| Abhay | Complete Employee and Fact Purchase Requisition Line coding and validation | 28th (first half) | transcript | high |
| Abhay | Complete Fact Invoice Receipt Line coding and validation, scope depending on issues found | Not stated | transcript | medium |
| Gayatri | Set up time with Zabi to flag dependencies and unresolved QTest/scope issues | Tomorrow | transcript | high |
| Gayatri (via Trinadh) | Connect with Fanny tonight and again tomorrow if unavailable | Tonight / tomorrow | transcript | high |
| Shubham (assigned by Gayatri, not present) | Wrap up AP transaction, then Fact Daily Exchange, Fact Global Exchange, and Open IRGR-related issues | Today/tomorrow (28th likely) | transcript | medium |

## Open questions
- Whether Fanny will respond with the full D/F table update code before Trinadh needs it tomorrow morning.
- Whether the flagged 20–30 PO columns are actually consumed by the Power BI dashboard, which would affect prioritization.
- Whether WD's team will take ownership of QTest investigation in time to avoid further delay to CDC.
- Ownership and status accuracy for GR Line, IR Line, and Purchase Requisition Line on the tracker (old status vs. current CDC status).

## Notes on transcript quality
No `**Me**` blocks appear despite `own_mic_track: yes` and the context field listing "Me" as a participant; Kaushik is referenced only in the third person ("filter out the status column, Kaushik," "this is what I asked Kaushik and Trinad") rather than as a labeled speaker, so his own commitments in this meeting could not be separately captured. Some names in the audio are inconsistently rendered (Fanny/Funny, Zabi, Michael Satish) and are kept as transcribed since they don't appear in the `context` field for cross-checking.

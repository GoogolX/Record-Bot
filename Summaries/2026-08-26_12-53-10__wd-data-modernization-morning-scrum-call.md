# WD Data Modernization Morning Scrum Call 26-Aug 2026
_2026-08-26 12:53 · 12 min_

This was the team's morning scrum on the WD Data Modernization project, with Friday set as the target close given Monday is the engagement's last day. The bulk of the call worked through how to split remaining PO (purchase order) column fixes and CDC work across Sharath, Trinadh, and Abhay, and Shubham walked through his incremental-load status on AP transactions and Open IRGR. Several items were pushed to a follow-up: Gayatri asked Sharath to build a plan with per-table owners and dates rather than assign live on the call, and to sync separately with Hari on timing.

## Who was in it
- Gayatri (Speaker 3, inferred, medium confidence) — 5 min, ran the meeting, set priorities and the Friday deadline
- Sharath (Speaker 1, inferred, high confidence) — 3 min, working PO columns and CDC handoff
- Shubham (Speaker 6, inferred, high confidence) — 3 min, incremental load status on AP and Open IRGR
- Trinadh (Speaker 2, inferred, low confidence) — 52 sec, discussed PO column split
- Abhay (Speaker 5, inferred, medium confidence) — 13 sec, organization/supplier-site validation
- Speaker 4 (unresolved) — 15 sec, continued the supplier-site validation point

## Answer to your question
**Question:** Per person action items.
See the Action items table below — each row is attributed to the person who committed to it on the call.

## What was covered
- Of 45 PO columns with issues, roughly 8 were Sharath's, 10 Trinadh's, and 20 Utkarsh's (not otherwise identified in this meeting).
- Sharath is finishing PO work then moving to CDC; Trinadh takes over the columns Sharath already has context on.
- Abhay is fixing supplier-site validation issues left from the prior day, then moving to organization and eventually location.
- Gayatri flagged that reopening PO after declaring it "done" already cost 1.5–2 person-days and wants a written per-table plan with dates instead of live assignment.
- Shubham reported ~80–85% fill rate on some columns, traced possibly to a dimension-table gap causing missing surrogate keys; targeting AP incremental completion by 5pm and Open IRGR after.
- CPN table load type is unresolved — Shubham needs Fanny to confirm whether it's a full load.
- Of five committed datasets, the team is aiming to deliver at least three today and the remaining two within two days.
- Shubham pushed code to main (merged by Pratik) but flagged that framework.zip is not yet in the repository, raising a deployment question for orchestration.
- Dim Legal Entity Balance Segment Value table was reported as structurally present in QA but entirely empty; the team agreed to leave it for now since no downstream table appears to use it.

## Decisions
- Gayatri decided Sharath will build a detailed per-table plan (owner + date) offline rather than have tasks assigned live on the call.
- Shubham and Sharath agreed to sync in an hour on orchestration and the framework.zip deployment question, deferred to later that evening.

## Action items

| Owner | Action | Due | Source | Confidence |
|---|---|---|---|---|
| Sharath | Build a per-table CDC/PO plan with owner and date per table, then review with Gayatri | Same day | transcript | high |
| Trinadh | Close out PO columns from the list Sharath handed off | Next day | transcript | medium |
| Abhay | Finish supplier-site validation fixes, then organization, then location | Not stated | transcript | medium |
| Shubham | Complete AP incremental load including known issues | Same day, 5pm | transcript | high |
| Shubham | Investigate Open IRGR record-count mismatch vs. EDW, then build incremental | Not stated | transcript | medium |
| Shubham | Confirm with Fanny whether CPN is a full-load table | Not stated | transcript | medium |
| Shubham | Check whether Dim Legal Entity Balance Segment Value table has been populated | Not stated | transcript | low |
| Gayatri | Follow up with Hari on start timing for additional help on CDC | Not stated | transcript | medium |

## Open questions
- Whether CPN should be treated as a full load table (pending Fanny's confirmation).
- Why Open IRGR is returning more records than the EDW source.
- How to add framework.zip to the repository for orchestration/deployment.
- Whether Dim Legal Entity Balance Segment Value is used anywhere downstream.

## Notes on transcript quality
Several names came through garbled ("Karshik", "Utkarsh", "Zabi", "Trinath/Srinath/Trinadh") — spellings above use the `context` field where it overlapped, but "Utkarsh" and "Zabi" don't appear in `context` and could be mis-transcribed names of people outside this meeting. Speaker 4 could not be confidently identified and may be a diarization split of Abhay's turn rather than a distinct person. No `**Me**` blocks appeared despite `own_mic_track: yes`, so the user's own speech in this meeting could not be specially verified.

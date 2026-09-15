# WD DMOD Evening Scrum Call 02 Sep 2026

_2026-09-02 20:31:22 · 26 min_

Team tackled CDC incremental loading logic issues (particularly for IRGR table), orchestration DAG completion, and data validation mismatches. CDC performance remains a blocker: incremental takes 26+ minutes vs. full load at 34 minutes. Shubham working through IRGR flag update logic when applying incremental-only datasets. Trinadh making progress on orchestration (first job complete, second DAG in progress). Abhay debugging DIMCPN reconcile structure issue in QA. Conference page link updates needed.

## Who was in it

- Sharath: ~2 min — CDC performance issues and troubleshooting (medium confidence)
- Trinadh: ~7 min — Orchestration DAG work, PySpark merge statement guidance (medium confidence)
- Shubham: ~9 min — IRGR table incremental logic, data mismatch investigation (medium-high confidence)
- Abhay: ~3 min — DIMCPN reconcile debugging, CDC testing documentation (high confidence)
- Speaker 4: ~2 min — Minimal participation (unresolved)

## Answer to your question

**Question:** "What are the open items from each person?"

**Answer:** 

- **Sharath:** Fix CDC logic for incremental (currently running 26+ min); no solution yet; will share code with Trinadh
- **Trinadh:** Complete orchestration DAG project 2 (couple hours, possibly early tomorrow); start new full-load DAG tomorrow (2–3 hours); help Shubham debug merge statement on Glue
- **Shubham:** Resolve IRGR flag update logic for incremental data; run merge statement on Glue (not Athena) once full load issues resolved; investigate full load data mismatches (waiting for Pani to provide AWS table copy); find/prepare test case documentation for Mary
- **Abhay:** Debug DIMCPN reconcile with stale QA copy (missing watermark map return); provide CDC testing documentation; investigate framework differences between production and QA

## What was covered

- CDC performance: Full load completes in 34 minutes; incremental still running at 26+ minutes. Sharath trying multiple approaches since morning with no success. CDC logic not working as expected (not a column count issue).
- Orchestration: Trinadh completed first job, working on second DAG project (couple hours to close). Proposed new DAG to allow parameter-based full table load (to be completed tomorrow, 2–3 hours).
- IRGR table complexity: Incremental load cannot update flag values correctly because context requires full dataset grouping logic (receipt number/line matching with amounts/quantities). Running separate merge statement after incremental load proposed as solution; Trinadh suggesting Glue merge (Athena permissions blocking).
- Full load data mismatches: Row counts mismatched across entire filter (not month-specific). Shubham requested AWS table copy from Pani for root cause analysis using minus query.
- Procurement job funding: Trinadh debugging Airflow/Glue connection issue (not finding job); may require configuration changes.
- DIMCPN reconcile: Stale QA copy with incorrect structure (not returning watermark map per framework). Different scripts needed for QA vs. production. Abhay investigating least-invasive fix. Trinadh notes a fact table CDC without watermark map return still ran on production (contradicts expected behavior).
- CDC testing documentation: Needed; Abhay to provide.
- Test cases: Mary requesting full load test case documentation; Shubham to locate or prepare.

## Decisions

- Shubham to run merge statement on Glue (not Athena) for incremental IRGR updates
- Abhay to investigate DIMCPN QA framework mismatch and propose fix
- Offer working session to help debug/accelerate DIMCPN resolution
- Status to be provided to Gayatri (noting at least one more day needed)

## Action items

| Owner | Action | Due | Source | Confidence |
|-------|--------|-----|--------|------------|
| Sharath | Fix CDC incremental logic (26+ min performance issue) | Not stated | Transcript | High |
| Sharath | Share CDC code with Trinadh | Today 2026-09-02 | Transcript | High |
| Sharath | Request AWS table copy from Pani for root cause analysis | Not stated | Transcript | Medium |
| Trinadh | Complete orchestration DAG project 2 | Today 2026-09-02 or tomorrow 2026-09-03 | Transcript | High |
| Trinadh | Start and complete new full-load DAG (parameter-based) | Tomorrow 2026-09-03 | Transcript | High |
| Trinadh | Debug Airflow/Glue procurement job connection issue | Not stated | Transcript | High |
| Shubham | Resolve IRGR incremental flag update logic | Today 2026-09-02 | Transcript | High |
| Shubham | Run merge statement on Glue for incremental IRGR updates (once full load fixed) | Not stated | Transcript | High |
| Shubham | Investigate full load data mismatch root cause (using AWS table copy from Pani) | Not stated | Transcript | High |
| Shubham | Close incremental work at least by end of day (per Gayatri message) | Today 2026-09-02 | Transcript | Medium |
| Shubham | Locate/prepare test case documentation for Mary (full load) | Not stated | Transcript | Medium |
| Abhay | Debug DIMCPN reconcile stale QA copy and watermark issue | Not stated | Transcript | High |
| Abhay | Provide CDC testing documentation | Not stated | Transcript | High |
| Abhay | Attend working session if needed to accelerate DIMCPN resolution | Not stated | Transcript | Medium |
| Team | Update conference page links | Not stated | Transcript | Low |
| Team | Provide status to Gayatri (note: at least one more day needed) | By end of day | Transcript | Medium |

## Open questions

- What is the root cause of CDC incremental taking longer than full load?
- Can Shubham's merge statement approach resolve the IRGR flag update issue?
- When will AWS table copy be available from Pani for full load mismatch analysis?
- Will DIMCPN reconcile fix unblock Abhay's CDC testing documentation work?

## Notes on transcript quality

Significant quality issues: Large section of repetitive "I think that's a good question" text (lines 150–177), making transcript hard to follow. No "Me" (Kaushik) speaker block despite `own_mic_track: yes` header, suggesting transcript diarization may be incomplete. Speaker 4 identified as unresolved due to minimal speech and unclear role. Phone rendering issues: "KaSyck" (likely "K" or "Kaushik"), "UOCDC" unclear, "Connie" may be "Pani" (context from lines suggests Pani is the source table owner). Overall technical content is recoverable but presentation quality is degraded.

# Call with Ravi to Clarify Open Questions before Call with Tommy Want - 9 Sep 2026
_2026-09-09 19:18:56 · [Duration]_

## Who was in it
- Kaushik (Me, known, high) — 34:37, primary participant
- Ravi (Speaker 1, inferred, medium) — 34:23, providing clarifications

## Answer to your question
**Question:** All the questions I asked and Ravi's answers to them, in great detail without summarising or compressing
[Answer:]
- **Q**: What are we doing for silver checks?
- **A**: Row count checks, column count checks, and audit column checks.
- **Q**: Are there any cleanup transformations from bronze to silver?
- **A**: No, it's just a view. Cleanup is done in the silver-to-gold transformation.
- **Q**: Why are we doing QA for specific tables?
- **A**: These are part of prioritized datasets (PCS, finance, time and labor, TMS).
- **Q**: What about tolerance values for numeric checks?
- **A**: Supriya hasn't done it yet. Need to check with Mohit.
- **Q**: Why have we built Bronze and Silver layers if Gold is reconciled against DB2?
- **A**: Bronze is raw ingestion, silver includes data quality checks and cleansing, while gold is business-level aggregation.

## What was covered
- [Key discussion point 1] Checks for silver layer (row count, column count)
- [Key discussion point 2] Cleanup transformations from bronze to silver

## Decisions
- [Decision 1] Silver layer: view only; no cleanup
- [Decision 2] Gold layer: business-level aggregation

## Action items

| Owner | Action | Due | Source | Confidence |
| --- | --- | --- | --- | --- |
| Kaushik | Ping Mohit for tolerance values | Not stated | Notes | Medium |

## Open questions
- [Unresolved question 1] What is the exact value of numeric check tolerances?

## Notes on transcript quality
[Notes on audio quality, speaker separation, or mic status]
The audio quality was good enough to understand most of the conversation. Speaker identification was challenging due to similar sounding names and lack of context clues.

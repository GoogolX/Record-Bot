# Morning Meeting with Supriyo to get QA Status of SIlver and Bronze Tables (VF)
_2026-09-07 11:04:29 · [Duration]_

During the meeting, Kaushik and Supriyo discussed the status of various tables in the bronze and silver layers. They went through specific issues such as column count mismatches, date format discrepancies, row count differences, and other QA defects. The conversation focused on identifying whether these issues were due to placeholder values, formatting errors, or actual data discrepancies that needed fixing.

## Who was in it
- **Kaushik** (Me, known, high) — [talk time], Project Manager/Lead Engineer
- **Supriyo** (Speaker 1, inferred, high) — [talk time], QA Tester

## Answer to your question
**Question:** Status of each tables across bronze and silver layers
The meeting covered several specific tables in the bronze and silver layers. For example, issues were discussed for tables like 8020, CKTIMEFL, TBFDLBR, and others. The status varied from confirmed placeholder values being acceptable to needing further investigation or fixes.

## What was covered
- **QA Status of Tables:** Discussed specific QA defects in bronze and silver layers.
- **Placeholder Values:** Determined if certain column mismatches were due to placeholder values that could be ignored.
- **Row Count Mismatches:** Investigated row count discrepancies between tables, determining whether these were sync issues or actual data differences.

## Decisions
- **8020 Table:** Confirmed as a placeholder value issue and can be ignored if it's only one value in the column.
- **CKTIMEFL Table:** Needs further investigation to determine if there is an ingestion bug or if the column can be dropped.

## Action items

| Owner | Action | Due | Source | Confidence |
| --- | --- | --- | --- | --- |
| Supriyo | Check if 8020 column got added due to landing part and note findings. | Not stated | notes | high |
| Supriyo | Investigate CKTIMEFL table for ingestion bug or drop column if not useful. | Not stated | transcript | medium |

## Open questions
- **Further investigation needed:** What is the exact reason for row count mismatches in certain tables?

## Notes on transcript quality
The audio was clear, and speaker separation was good throughout the meeting.

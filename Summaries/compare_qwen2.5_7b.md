# Call with Ravi to Clarify Open Questions before Call with Tommy Want - 9 Sep 2026
_2026-09-09 19:18:56 · [Duration]_

Kaushik (Me, inferred, low) and an unnamed speaker (Speaker 1, unknown, low) had a detailed discussion to clarify open questions before a call with Tommy Want. The conversation covered several aspects of the data processing pipeline from bronze to gold layers.

## Who was in it
- Kaushik ([Me], inferred, low) — [talk time] minutes, primary speaker and questioner.
- Speaker 1 (Unknown, ?) — [talk time] minutes, provided answers and instructions.

## Answer to your question
**Question:** All the questions I asked and Ravi's answers to them, in great detail without summarising or compressing

Kaushik asked several detailed questions about the data processing pipeline from bronze to gold layers. Speaker 1 responded with specific details:

- **Silver Layer Checks**: Kaushik asked if row count checks, column count checks, and audit column checks were performed for silver tables but no data count checks. Speaker 1 confirmed that only view-based transformations are done in the silver layer.
  
- **Tolerance Value for Numeric Checks**: Kaushik requested to check with Mohit about the tolerance value used for numeric checks.

- **QA Testing Scope**: Kaushik questioned why QA was performed on specific tables, and Speaker 1 provided background information that during R1 and R2, many additional source tables were ingested. After reviewing with Heidi, some bronze tables were removed from scope, leading to a difference in the number of bronze and silver tables.

- **Silver Table Comparisons**: Kaushik noted that some silver tables are compared against DWH Prod instead of Bronze. Speaker 1 confirmed this is done on a case-to-case basis due to filtered views existing only on Prod.

- **Gold Layer Reconciliation**: Kaushik asked about the necessity of maintaining bronze and silver layers if gold layer is reconciled with DB2. Speaker 1 explained that bronze contains source data, which is crucial for maintaining the source of truth, while gold provides business-level aggregation.

## What was covered
- Clarification on transformations from bronze to silver.
- Tolerance value for numeric checks.
- QA testing scope and background information.
- Comparison of silver tables against DWH Prod.
- Necessity of maintaining bronze and silver layers despite gold layer reconciliation with DB2.

## Decisions
- No specific decisions were made during this call, but several tasks were assigned.

## Action items

| Owner | Action | Due | Source | Confidence |
| --- | --- | --- | --- | --- |
| Kaushik | Ping Mohit for tolerance value of numeric checks. | Not stated | Notes | Medium |
| Kaushik | Connect Supriya and Arun to set up data comp utility installation. | Not stated | Notes | Low |
| Kaushik | Investigate if there's a way to capture proof that Gold layer is built from Bronze and Silver layers. | Not stated | Notes | Medium |

## Open questions
- None explicitly stated, but Kaushik mentioned the possibility of future work on capturing proof for gold layer data lineage.

## Notes on transcript quality
The audio quality was good, with clear speaker separation. The mic status was stable throughout the call.

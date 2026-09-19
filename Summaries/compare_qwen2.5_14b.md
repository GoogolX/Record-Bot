# Call with Ravi to Clarify Open Questions before Call with Tommy Want - 9 Sep 2026
_2026-09-09 19:18:56 · [Duration]_

Kaushik and Ravi discussed the details of data transformations from bronze to silver layers, QA processes for specific datasets, and the rationale behind maintaining bronze and silver layers despite reconciling gold with DB2. They also touched upon the differences in table counts between bronze and silver due to historical ingestion practices during R1 and R2 phases.

## Who was in it
- **Kaushik** (Me, known, high) — [talk time], Lead Engineer
- **Ravi** (Speaker 1, inferred, high) — [talk time], Project Manager

## Answer to your question
**Question:** All the questions I asked and Ravi's answers to them, in great detail without summarising or compressing
- Kaushik: From Bronze to Silver, what transformations are we doing? Are there any deluplication steps?
  - Ravi: The bronze to silver transformation involves renaming columns and adding audit columns. No other data transformations are done; it's essentially a view.
- Kaushik: What is the tolerance value for numeric checks in Data Compi? Should I ask Mohit about this?
  - Ravi: Yes, ping Mohit to clarify the tolerance values as Supriya might not have set them yet.
- Kaushik: Why did we do QA on specific tables and what are these datasets?
  - Ravi: The QA was done on prioritized datasets such as PCS, finance, time and labor, and TMS. There were around 120 silver tables and 45 gold tables in scope.
- Kaushik: What is the background of bronze and silver table counts? Why are there differences?
  - Ravi: During R1 and R2 phases, we ingested all source system tables from JD and AS400. For R3, only specific tables were needed, leading to a reduction in bronze layer tables but not in silver.
- Kaushik: Some silver tables compare against DWH Prod instead of Bronze; why is this the case?
  - Ravi: This happens when filtered views exist on Prod and direct source system data was picked up for Bronze. It's identified on a case-by-case basis.
- Kaushik: If Gold reconciles with DB2, why do we need bronze and silver layers?
  - Ravi: The bronze layer captures transactional data from multiple sources, while the silver layer aggregates this data to form dimensions and facts. The gold layer provides business-level aggregation and ensures compatibility views match DB2 for report consistency.

## What was covered
- **Data Transformation Process**: Discussion on transformations between Bronze and Silver layers.
- **QA Scope**: Clarification on why QA is done on specific datasets.
- **Table Counts Explanation**: Background on differences in bronze and silver table counts.
- **Silver Table Comparisons**: Why some silver tables compare against DWH Prod instead of Bronze.
- **Purpose of Layers**: Rationale behind maintaining Bronze and Silver layers despite reconciling Gold with DB2.

## Decisions
- Connect Supriya and Arun to set up Data Compi utility for future use.
- Provide background on bronze and silver table counts during the call with Tommy.

## Action items

| Owner | Action | Due | Source | Confidence |
| --- | --- | --- | --- | --- |
| Kaushik | Ping Mohit about tolerance values for numeric checks in Data Compi. | Not stated | notes | high |
| Unassigned | Connect Supriya and Arun to set up Data Compi utility. | Not stated | transcript | medium |

## Open questions
- What is the exact tolerance value for numeric checks in Data Compi?

## Notes on transcript quality
The audio was clear, allowing for accurate identification of speakers based on content and context clues.

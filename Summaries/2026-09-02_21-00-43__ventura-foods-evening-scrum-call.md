# Ventura Foods Evening Scrum Call
_2026-09-02 21:00:43 · ~24 minutes_

The team held their evening scrum call to review the status of Release 3 deliverables across QA execution, data pipeline development, data modeling, and report repointing. Kaushik confirmed that QA test execution for bronze and silver layers is 100% complete, with remaining defects on track to be closed by Friday, while the gold layer test suite is prepared for review with Tommy. Development tables are progressing, though high complexity in VF-DWH finance tables and TMS has required deprioritization of certain non-critical audit and fact tables.

Lakshmi raised concerns regarding competing priorities impacting Manjeet's bandwidth on Release 3, emphasizing the importance of immediate escalation if timelines risk slipping. Manjeet clarified that temporary platform stability work from Release 1 and Release 2 alongside custom Informatica/DBT pipeline mapping adjustments accounted for the delays, but committed to focusing fully on Release 3 deliverables going forward.

Finally, Rajeshwari presented the completed report repointing and table mappings for oil trading. To manage QA scope—which increased from an expected 50 to 62/63 reports—Manjeet and Arvind agreed to meet at 4:00 PM to filter out reports with redundant underlying table dependencies so Lakshmi can propose a streamlined QA scope to business stakeholder Andy.

## Who was in it
- Lakshmi (Speaker 3, known, high) — ~9 min, Scrum Lead / Facilitator moderating project tracking and timeline accountability.
- Manjeet (Speaker 2, known, high) — ~6 min, On-site Lead Developer discussing TMS/TNL pipelines, data modeling, and platform stability.
- Ravi (Speaker 6, known, high) — ~4 min, Lead Technical Lead explaining VF-DWH complexity, table dependencies, and testing roadmap.
- Kaushik (Me, known, high) — ~2 min, QA Lead providing status on bronze/silver/gold test suites.
- Arvind (Speaker 1, known, high) — ~1.5 min, Project Lead / Architect overseeing data model approvals and business coordination.
- Rajeshwari (Speaker 4, known, high) — ~1 min, Developer/Analyst presenting report repointing and mapping sheet updates.
- Shashvat (Speaker 5, known, high) — ~30 sec, Developer providing updates on table development target dates.

## Answer to your question
**Question:** Action items per person

- **Kaushik (Me):** Share the gold layer test suite with Tommy via email thread for offline review once bronze/silver defect closure is finalized by Friday.
- **Lakshmi:** Send a meeting invite to Tommy for early next week to conduct the gold/silver review.
- **Manjeet:**
  - Confirm with Siddharth regarding the CAB request status for the OFR branch transfer.
  - Review and assign completion dates for new VF-DWH tables with Ravi.
  - Finish mapping Carrier Activity F table and share with the team; verify Kronos table data staleness with Andre.
  - Update the TNL/employee table in the data model and send to Arvind for sign-off.
  - Meet with Arvind at 4:00 PM to review report mappings and identify reports to defer to UAT.
- **Ravi:**
  - Finalize target delivery dates for newly added VF-DWH finance tables in collaboration with Manjeet.
  - Prepare and send out the finance underlying data structures mapping by tomorrow.
  - Initiate gold layer and report testing for oil trading and PCS.
- **Arvind:** Connect with Manjeet at 4:00 PM to review report reductions before engaging Andy/business, and review/approve the updated data model.

## What was covered
- **QA Testing Progress:** Bronze and silver layer test executions are 100% complete. Identified defects are assigned to developers and targeted for closure by Friday. Gold layer test suite is prepared for stakeholder review.
- **Development & Complexity:** High complexity in VF-DWH Informatica mappings (specifically TMS and finance tables) has delayed schedule estimates; audit tables and independent facts (e.g., Adaptive Insights) have been deprioritized to prioritize core report-blocking tables.
- **Resource Allocation:** Lakshmi reinforced the requirement that Release 3 must remain the top priority for Manjeet, who noted 20–30% capacity had been drawn by Release 1 and 2 platform stabilization.
- **Report Scope Reduction Strategy:** Total P1 reports increased to 62/63 against a QA testing capacity of 50. The team agreed on a strategy to filter out reports sharing common, pre-tested underlying tables to be covered during UAT rather than core QA.

## Decisions
- Gold layer offline review with Tommy will be scheduled for early next week following the closure of silver and bronze defects this Friday.
- Oil trading and PCS gold layer and report testing will begin immediately (next day).
- The team will not inform business stakeholders of an arbitrary report scope cut; instead, they will frame the recommendation around underlying table test coverage and defer duplicate report validations to UAT.

## Action items

| Owner | Action | Due | Source | Confidence |
| --- | --- | --- | --- | --- |
| Manjeet | Confirm with Siddharth whether an open CAB request exists for the OFR branch transfer | Not stated | transcript | high |
| Kaushik | Share the gold layer test suite via email with Tommy for offline review | Friday, 2026-09-04 | transcript | high |
| Lakshmi | Send a meeting invite to Tommy for early next week for QA review | Early next week | transcript | high |
| Ravi & Manjeet | Finalize and populate target completion dates for the new VF-DWH finance tables | Today (2026-09-02) | transcript | high |
| Ravi | Prepare and send out the underlying data structures mapping for finance | Tomorrow (2026-09-03) | transcript | high |
| Manjeet | Confirm stale data status for Kronos table with Andre | Today (2026-09-02) | transcript | high |
| Manjeet | Update the employee/TNL table in the data model and send to Arvind for approval | Today (2026-09-02) | transcript | high |
| Arvind | Review and approve the updated data model from Manjeet | Not stated | transcript | high |
| Manjeet & Arvind | Connect at 4:00 PM to review report table mappings and finalize reports to defer to UAT | Today at 4:00 PM | transcript | high |
| Lakshmi & Arvind | Present the filtered report list and UAT testing strategy to Andy | After internal alignment | transcript | high |

## Open questions
- Whether Manjeet requires Co-Pilot access approval from Arvind to expedite VF-DWH pipeline generation.
- Specific delivery target dates for the newly added VF-DWH finance tables.

## Notes on transcript quality
- Occasional overlapping speech and audio loop artifacts occurred around timestamps 00:14:00–00:14:10 and 00:16:22–00:16:45, but context remained fully discernible.

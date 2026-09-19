# Untitled meeting
_2026-08-26 21:05 · 20 min_

This was a QA/testing and data-migration status meeting, likely for a Snowflake migration program, covering report validation progress, missing reports, and a new time-and-labor data modeling workstream. Lakshmi restated the hard deadline: all gold and reports testing must finish by September 21st, with two weeks of regression and performance testing after, and UAT running October 5th through end of month. The bulk of the discussion was troubleshooting three specific reports that couldn't be located, and Manjeet's discovery of additional sensitive employee data sources needed for the time-and-labor reports. The meeting ended mid-topic as Lakshmi asked to speak with Ravi privately about "Harvan R2 invoices."

## Who was in it
- Lakshmi (Speaker 2, inferred, high confidence) — 7 min, drove the QA schedule and deadlines
- Manjeet (Speaker 4, inferred, high confidence) — 6 min, time-and-labor data modeling and TMS pipeline work
- Arvind (Speaker 5, inferred, medium confidence) — 3 min, data sensitivity review and personal-folder reports
- Ravi (Speaker 1, inferred, high confidence) — 2 min, heat map tracker and domain status updates
- Rajeshwari (Speaker 3, inferred, high confidence) — 2 min, reported on three untraceable reports

## What was covered
- Lakshmi set the hard deadline: all gold and report testing complete by September 21st, regression/performance testing September 21–October 2nd, UAT October 5th through end of month.
- Ravi flagged that oil trading and other domains still lack a final table/report list; Andy committed to deliver it by end of week, with Ravi following up Friday if there's no response.
- The planned TMS call fell through because the contact Michael gave (via Ben) said they weren't the right point of contact; Ravi is still working out how to proceed on TMS.
- Rajeshwari flagged three reports she couldn't fully account for: one was in a personal folder (found, in Alexis's folder), and two others (including one called "oil forecast") could not be located anywhere.
- The team agreed the untraceable reports may have been renamed or repurposed; Rajeshwari will email Lakshmi (copying Manjeet and Arvind) with details so Lakshmi can chase it through her main thread with the business side.
- For personal-folder reports, the team will ask the report owner (Alexis) to publish a shared-folder version so the objects involved can be identified, without necessarily forcing full replication yet.
- Manjeet reported that time-and-labor reports use employee data; Monica (people analytics) confirmed name and hours data is fine, but flagged that the existing people-analytics employee dimension may not cover all employees/non-employees needed for time-and-labor, requiring an additional data source (from Ceridian/Chronos systems in DB2).
- Manjeet also noted the DB2 employee dimension contains sensitive fields (hire date, termination date) that should not be brought into Snowflake unless actually needed for the report.
- On TMS, Manjeet is validating the carrier-activity ETL pipeline (following the VFDWH template) and expects to hand it to the development team by the next day; full TMS tables are now expected to slip past August 31st to the following Friday.

## Decisions
- Lakshmi decided all QA/reports testing must be 100% complete by September 21st, no exceptions, tracked daily.
- Team decided to have the report owner (Alexis) publish reports to a shared folder rather than personal folders, so objects can be identified.
- Manjeet and Arvind will meet separately before looping in Monica again, since there's a separate pending item on Monica's side to address first.
- TMS table completion timeline pushed to the Friday after August 31st.

## Action items

| Owner | Action | Due | Source | Confidence |
|---|---|---|---|---|
| Ravi | Follow up with Andy on final table/report list for oil trading and other domains | Friday (if no response) | transcript | high |
| Ravi | Determine new approach for TMS point of contact | Not stated | transcript | medium |
| Rajeshwari | Send email to Lakshmi (cc Manjeet, Arvind) with details of the three untraceable reports | Not stated | transcript | high |
| Lakshmi | Escalate the untraceable-reports issue through her main thread with business users | Not stated | transcript | medium |
| Manjeet | Check with Alexis about publishing a shared-folder version of the personal report | Not stated | transcript | medium |
| Manjeet | Build new time-and-labor-specific employee dimension table (without touching existing people-analytics table) | By September 21st (part of overall QA deadline) | transcript | medium |
| Manjeet | Complete carrier-activity ETL pipeline check and hand off to development | Next day | transcript | high |
| Manjeet | Update team on TMS timeline, targeting the Friday after August 31st | Not stated | transcript | medium |
| Arvind | Send email this morning on data models | Same day | transcript | medium |
| Arvind and Manjeet | Meet separately to align before re-engaging Monica | Not stated | transcript | medium |

## Open questions
- Whether TMS's actual point of contact can be identified, since Michael's referral was rejected.
- Whether the two untraceable reports were renamed, repurposed, or are simply gone.
- What additional employee/non-employee data sources are needed to fully cover time-and-labor reporting.
- What the separate pending item is on Monica's side that needs resolving before the joint call.

## Notes on transcript quality
No YAML `context` field was provided, so speaker names were inferred entirely from in-transcript direct address; treat identifications as reasonably solid but not user-confirmed. Several names are spelled inconsistently in the source audio (Manjeet/Manjita/Manjit, Rajeshwari/Rajeshwar) and are normalized here to the most common spelling. "Harvan R2 invoices," mentioned at the very end, is unclear and may be a mis-transcription.

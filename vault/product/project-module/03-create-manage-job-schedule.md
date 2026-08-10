---
title: Project Module
source: confluence/TCG/Project Module
migrated: 2026-08-10
updated: 2026-04-30
status: unverified
conflicts_with: []
jira: []
topics: [scheduling, jobs, daily-allocation, dispatch, assets, customers]
entities: [schedule, job, das, asset, customer]
part_of: product/project-module/INDEX.md
---
# **Create & Manage Job Schedule**

## **User Story**

As a Dispatcher,I want to schedule a job across multiple dates and shifts,So that I can plan execution without re-entering job details for each day.

## **User Flow**

1. User opens Job → Schedule tab
2. Clicks **Create Schedule**
3. Selects start date and end date
4. Chooses whether to include Saturdays and Sundays
5. System generates schedule rows for each date
6. User sets on-site start and end time for each date
7. Optionally enables second shift and adds shift timings
8. Edits or removes specific dates if needed
9. Saves schedule
10. Scheduled job becomes available in dispatch (DAS)

## **Acceptance Criteria**

* User picks a start date and end date and system auto-creates all dates in between — no manual row creation needed
* User can choose to include or exclude Saturdays and Sundays before generating the schedule
* Each date row shows: Date, On-Site Start Time, On-Site End Time
* User can edit start and end times per date independently — changing one date does not affect others
* A second shift option is available per date  when turned on, shift timing fields appear for that date only
* User can delete a specific date from the schedule without affecting other dates
* Saving the schedule shows a success message
* All job details (customer, crane type, location etc.) from the job automatically carry over to every scheduled date  nothing needs to be re-entered
* Each scheduled date appears as a separate job card in DAS on that specific date
* If an asset is already assigned to another job during the same time on the same date, the system shows a warning
* The Schedule tab inside the job always shows the latest real-time view — any changes made from DAS are also reflected here

## **EPIC : PLANS** 


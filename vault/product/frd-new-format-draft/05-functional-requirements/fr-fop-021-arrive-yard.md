---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, yards, inspections, compliance, labor-payroll, time-tracking]
entities: [yard, field-ticket, labor-record, job, job-site, inspection]
part_of: product/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-021 — Arrive Yard

| Field | Detail |
| --- | --- |
| ID | FR-FOP-021 |
| Title | Arrive Yard |
| Workflow position | Previous: User leaves job site. Current: User records arrival back at yard. Next: Compliance checklist and labor details. |
| Description | The Application must allow the user to record arrival back at the yard. Arrive Yard does not automatically close the ticket. |
| Functional requirements | Provide Arrive Yard action. Capture exact timestamp. Allow manual adjustment with reason. Support GPS/Samsara validation where available. Trigger required post-arrival actions. |
| Business rules | Time after returning to yard may still be billable if tied to the job (fueling, parking, paperwork, post-inspection). A configured completion reminder may trigger after Arrive Yard. |
| Acceptance criteria | User can record Arrive Yard. Required post-arrival actions appear. Ticket remains incomplete until compliance and labor submission are complete. |
| Priority | Must have |

---


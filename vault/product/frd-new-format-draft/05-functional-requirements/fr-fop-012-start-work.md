---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, time-tracking, labor-payroll, jobs, safety, ticket-workflow]
entities: [job, boom-time, field-ticket, tailboard-jsa, lunch-record]
part_of: product/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-012 — Start Work

| Field | Detail |
| --- | --- |
| ID | FR-FOP-012 |
| Title | Start Work |
| Workflow position | Previous: JSA step is completed. Current: User records Start Work. Next: Work execution and lunch tracking begin. |
| Description | The Application must allow field users to record when actual work begins. Start Work is distinct from Arrive Job and is the basis for boom pay calculations. |
| Functional requirements | Provide Start Work action. Capture exact timestamp. Allow adjusted time with reason. Update ticket workflow status. Use Start Work time for boom pay and work-time calculations where applicable. |
| Business rules | Start Work is different from Arrive Job. Safety preparation time between Arrive Job and Start Work may be part of job time but not necessarily boom pay. Boom pay begins from Start Work where applicable. |
| Acceptance criteria | User can record Start Work. System stores exact and adjusted time. Ticket advances to active work state. |
| Priority | Must have |

---


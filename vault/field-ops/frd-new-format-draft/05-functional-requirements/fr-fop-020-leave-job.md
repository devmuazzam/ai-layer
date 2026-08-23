---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/assets, module/customers, module/field-ops, module/projects-jobs, kind/frd, time-tracking, signatures, geolocation, yards]
entities: [job, field-ticket, job-site, yard, signature]
part_of: field-ops/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-020 — Leave Job

| Field | Detail |
| --- | --- |
| ID | FR-FOP-020 |
| Title | Leave Job |
| Workflow position | Previous: Work is ended and final signature step is handled. Current: User records Leave Job. Next: Travel back to yard. |
| Description | The Application must allow the user to record departure from the job site. |
| Functional requirements | Provide Leave Job action. Capture timestamp. Update ticket status. Support GPS/Samsara validation where available. |
| Business rules | Leave Job supports travel-time calculation. Manual override remains auditable. Leave Job occurs after work completion unless exception is recorded. |
| Acceptance criteria | User can record Leave Job. Ticket status updates. Travel-back phase begins. |
| Priority | Must have |

---


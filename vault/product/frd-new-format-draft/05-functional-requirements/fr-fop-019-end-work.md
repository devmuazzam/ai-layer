---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, time-tracking, jobs, labor-payroll, signatures, yards, assets]
entities: [job, yard, signature, asset, labor-record, boom-time]
part_of: product/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-019 — End Work

| Field | Detail |
| --- | --- |
| ID | FR-FOP-019 |
| Title | End Work |
| Workflow position | Previous: Work is completed. Current: User records End Work. Next: Final signature and Leave Job. |
| Description | The Application must allow the user to record when active work ends. End Work is distinct from Leave Job and Arrive Yard. |
| Functional requirements | Provide End Work action. Capture exact timestamp. Allow manual adjustment with reason. Use End Work for boom pay and labor calculations where applicable. |
| Business rules | End Work ends active crane/job work time. Downstream payroll distinguishes work time from travel and yard time. |
| Acceptance criteria | User can record End Work. Timestamp is stored. Workflow advances to final signature / Leave Job step. |
| Priority | Must have |

---


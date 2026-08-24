---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/customers, module/field-ops, module/payroll, module/projects-jobs, kind/frd, time-tracking, geolocation, inspections, signatures]
entities: [job, field-ticket, job-site, signature]
part_of: field-ops/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-010 — Arrive Job

| Field | Detail |
| --- | --- |
| ID | FR-FOP-010 |
| Title | Arrive Job |
| Workflow position | Previous: User completes pre-trip and travels. Current: User records arrival at job site. Next: Site safety and signature steps. |
| Description | The Application must allow the user to record arrival at the job site. |
| Functional requirements | Provide Arrive Job action. Capture exact timestamp. Support manual adjustment with reason. Support GPS/Samsara validation where integration is available. Update ticket status. |
| Business rules | Arrival time is used for job tracking and downstream validation. Exact time and adjusted time are stored separately. GPS/Samsara data may validate but must not remove manual override in early versions. |
| Acceptance criteria | User can record Arrive Job. Ticket status updates. Timestamp is available for payroll/billing validation. |
| Priority | Must have |

---


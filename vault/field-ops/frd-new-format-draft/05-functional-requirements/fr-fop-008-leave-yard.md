---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/assets, module/customers, module/field-ops, module/payroll, module/projects-jobs, kind/frd, yards, inspections, time-tracking, permits]
entities: [yard, field-ticket, job-site, permit, union-code]
part_of: field-ops/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-008 — Leave Yard

| Field | Detail |
| --- | --- |
| ID | FR-FOP-008 |
| Title | Leave Yard |
| Workflow position | Previous: Ticket is active. Current: User records Leave Yard. Next: Pre-trip checklist and travel to job site. |
| Description | The Application must allow the user to record the Leave Yard event, starting the ticket execution clock. |
| Functional requirements | Provide Leave Yard action. Capture exact system timestamp. Allow adjusted time entry where permitted. Require reason for manual time adjustment. Store both exact and payroll/billing-rounded timestamps. |
| Business rules | Leave Yard starts the ticket execution clock. Manual time changes are auditable. Time rounding follows company/union rules. Exact time is preserved for audit and processing. |
| Acceptance criteria | User can record Leave Yard. System stores exact timestamp. User can adjust time with reason. Workflow advances to pre-trip checklist. |
| Priority | Must have |

---


---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, time-tracking, labor-payroll, compliance, yards, jobs]
entities: [job, yard, permit, labor-record, lunch-record, union-code]
part_of: product/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-038 — Time Rounding

| Field | Detail |
| --- | --- |
| ID | FR-FOP-038 |
| Title | Time Rounding |
| Applies to | Leave Yard, Arrive Job, Start Work, End Work, Leave Job, Arrive Yard, Lunch, and Labor. |
| Description | The Application must support both exact timestamps and rounded payroll/billing times. Exact time is never overwritten by rounded time. |
| Functional requirements | Capture exact timestamp at every time event. Calculate rounded time per configured rules. Allow manual adjustment with reason where permitted. Preserve full audit trail. |
| Business rules | Time rounding follows company/union rounding rules. Rounding rules are configurable. Exact time is preserved for audit and system processing. |
| Acceptance criteria | Exact and rounded times are both stored. Manual adjustment requires reason. Audit trail is available for every time event. |
| Priority | Must have |

---


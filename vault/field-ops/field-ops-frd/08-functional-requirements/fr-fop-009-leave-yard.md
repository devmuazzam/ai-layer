---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [field-ops/frd-new-format-draft/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/assets, module/field-ops, module/payroll, kind/frd, yards, inspections, time-tracking]
entities: [yard, field-ticket, labor-record]
part_of: field-ops/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-009 — Leave Yard

| Field | Detail |
| --- | --- |
| ID | FR-FOP-009 |
| Module | Labor |
| Title | Leave Yard |
| Description | The Application shall support recording departure from the yard. |
| Functional requirements | The Application shall support Leave Yard actions. The Application shall capture departure timestamps. The Application shall support comments and location capture where applicable. The Application shall transition ticket status following departure. The Application shall preserve audit information. |
| Business rules | Pre-trip requirements shall be satisfied prior to departure where configured. Departure activities shall remain auditable. |
| Acceptance criteria | **AC-001** Given departure requirements have been satisfied, When the user records Leave Yard, Then departure timestamps shall be captured. **AC-002** Given mandatory pre-trip activities remain incomplete, When Leave Yard is attempted, Then progression shall be prevented. |

---


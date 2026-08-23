---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [field-ops/frd-new-format-draft/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/field-ops, module/payroll, kind/frd, time-tracking, inspections, compliance, requirements]
entities: [labor-record, field-ticket]
part_of: field-ops/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-016 — End Work

| Field | Detail |
| --- | --- |
| ID | FR-FOP-016 |
| Module | Labor |
| Title | End Work |
| Description | The Application shall support recording the completion of work activities. |
| Functional requirements | The Application shall support End Work actions. The Application shall capture End Work timestamps. The Application shall support comments and preserve audit information. The Application shall transition ticket status following completion of work activities. The Application shall support visibility into work completion status. |
| Business rules | End Work activities shall remain auditable. End Work timestamps shall contribute to labor calculations. Detailed labor calculations shall be defined within the BRS. |
| Acceptance criteria | **AC-001** Given work activities have concluded, When End Work is recorded, Then End Work timestamps shall be captured. **AC-002** Given End Work has been recorded, When workflow progression occurs, Then Compliance Checklist activities shall become available. |

---


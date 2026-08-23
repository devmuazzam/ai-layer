---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [field-ops/frd-new-format-draft/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, yards, time-tracking, labor-payroll, inspections, requirements-spec]
entities: [yard, labor-record, field-ticket, employee]
part_of: field-ops/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-020 — Arrive Yard

| Field | Detail |
| --- | --- |
| ID | FR-FOP-020 |
| Module | Labor |
| Title | Arrive Yard |
| Description | The Application shall support recording arrival back at the yard following completion of field activities. |
| Functional requirements | The Application shall support Arrive Yard actions. The Application shall capture arrival timestamps. The Application shall support comments and location capture where applicable. The Application shall preserve audit information and update ticket status accordingly. |
| Business rules | Arrive Yard activities shall remain auditable. Arrive Yard timestamps shall contribute to labor visibility. Detailed labor calculations shall be maintained within the BRS. |
| Acceptance criteria | **AC-001** Given employees return to the yard, When Arrive Yard is recorded, Then arrival timestamps shall be captured. **AC-002** Given Arrive Yard has been completed, When workflow progression occurs, Then Post-Trip Checklist activities shall become available. |

---


---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [product/frd-new-format-draft/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, labor-payroll, time-tracking, yards, jobs, permissions-roles, requirements-spec]
entities: [labor-record, job, yard, field-ticket]
part_of: product/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-023 — Labor Details

| Field | Detail |
| --- | --- |
| ID | FR-FOP-023 |
| Module | Labor |
| Title | Labor Details |
| Description | The Application shall provide visibility into labor information associated with ticket execution. |
| Functional requirements | The Application shall display all labor-driving events and their timestamps: Leave Yard, Arrive Job, Start Work, End Work, Leave Job, and Arrive Yard. The Application shall display submitted labor information, labor modification history, and labor adjustment information where applicable. The Application shall preserve audit information. Operator and Oiler labor records shall remain individually attributable. |
| Business rules | Detailed labor calculations shall be defined within the BRS. Labor visibility shall respect user permissions. Labor modifications shall remain auditable. |
| Acceptance criteria | **AC-001** Given labor information exists, When Labor Details are reviewed, Then labor-driving events shall be displayed. **AC-002** Given labor modifications have occurred, When Labor Details are reviewed, Then modification history shall remain visible. |

---


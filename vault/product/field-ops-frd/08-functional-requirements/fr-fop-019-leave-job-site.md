---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [product/frd-new-format-draft/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, jobs, time-tracking, labor-payroll, job-sites, yards, requirements-spec]
entities: [job, job-site, labor-record, field-ticket, yard]
part_of: product/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-019 — Leave Job Site

| Field | Detail |
| --- | --- |
| ID | FR-FOP-019 |
| Module | Labor |
| Title | Leave Job Site |
| Description | The Application shall support recording departure from the job site. |
| Functional requirements | The Application shall support Leave Job actions. The Application shall capture departure timestamps. The Application shall support comments and location capture where applicable. The Application shall preserve audit information and update ticket status accordingly. |
| Business rules | End Work activities shall occur prior to Leave Job actions. Leave Job activities shall remain auditable. Leave Job timestamps shall contribute to labor visibility. Detailed labor calculations shall be maintained within the BRS. |
| Acceptance criteria | **AC-001** Given work activities have concluded, When Leave Job is recorded, Then departure timestamps shall be captured. **AC-002** Given Leave Job activities have been completed, When workflow progression occurs, Then Arrive Yard activities shall become available. |

---


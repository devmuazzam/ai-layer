---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [field-ops/frd-new-format-draft/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/customers, module/field-ops, module/payroll, module/projects-jobs, kind/frd, time-tracking, safety]
entities: [job-site, job, field-ticket, employee, labor-record]
part_of: field-ops/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-010 — Arrive Job Site

| Field | Detail |
| --- | --- |
| ID | FR-FOP-010 |
| Module | Labor |
| Title | Arrive Job Site |
| Description | The Application shall support recording arrival at the job site. |
| Functional requirements | The Application shall support Arrive Job actions. The Application shall capture arrival timestamps. The Application shall support comments and location capture where applicable. The Application shall transition ticket status following arrival. The Application shall preserve audit information. |
| Business rules | Arrival activities shall remain auditable. Arrival shall occur prior to Job Safety Analysis activities. |
| Acceptance criteria | **AC-001** Given the employee reaches the job site, When Arrive Job is recorded, Then arrival timestamps shall be captured. **AC-002** Given arrival has been recorded, When the workflow progresses, Then Job Safety Analysis activities shall become available. |

---


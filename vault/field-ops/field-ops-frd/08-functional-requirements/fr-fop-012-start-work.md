---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [field-ops/frd-new-format-draft/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/field-ops, module/payroll, kind/frd, time-tracking, safety, requirements]
entities: [labor-record, tailboard-jsa, field-ticket]
part_of: field-ops/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-012 — Start Work

| Field | Detail |
| --- | --- |
| ID | FR-FOP-012 |
| Module | Labor |
| Title | Start Work |
| Description | The Application shall support recording the commencement of work activities. |
| Functional requirements | The Application shall support Start Work actions. The Application shall capture Start Work timestamps. The Application shall support comments and preserve audit information. The Application shall transition ticket status following work commencement. The Application shall support visibility into work status. |
| Business rules | JSA requirements shall be completed prior to Start Work. Start Work activities shall remain auditable. Start Work timestamps shall contribute to labor calculations. Detailed labor calculations shall be defined within the BRS. |
| Acceptance criteria | **AC-001** Given JSA requirements have been satisfied, When the user selects Start Work, Then Start Work timestamps shall be captured. **AC-002** Given JSA remains incomplete, When Start Work is attempted, Then progression shall be prevented. |

---


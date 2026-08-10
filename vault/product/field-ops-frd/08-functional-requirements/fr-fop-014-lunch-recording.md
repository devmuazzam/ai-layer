---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [product/frd-new-format-draft/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, lunch-breaks, time-tracking, compliance, requirements-spec]
entities: [lunch-record, field-ticket]
part_of: product/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-014 — Lunch Recording

| Field | Detail |
| --- | --- |
| ID | FR-FOP-014 |
| Module | Lunch |
| Title | Lunch Recording |
| Description | The Application shall support recording lunch periods during ticket execution. |
| Functional requirements | The Application shall support Start Lunch and End Lunch actions. The Application shall capture Lunch Start and Lunch End timestamps. The Application shall support comments and preserve audit information. The Application shall support multiple lunch periods and visibility into previously recorded lunches. |
| Business rules | Lunch records shall contribute to compliance evaluations. Detailed lunch calculations shall be defined within the BRS. Lunch recording activities shall remain auditable. |
| Acceptance criteria | **AC-001** Given lunch recording is initiated, When Start Lunch is selected, Then Lunch Start timestamps shall be captured. **AC-002** Given lunch recording is completed, When End Lunch is selected, Then Lunch End timestamps shall be captured. |

---


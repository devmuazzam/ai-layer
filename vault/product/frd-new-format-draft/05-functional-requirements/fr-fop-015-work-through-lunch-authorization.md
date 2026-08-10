---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, lunch-breaks, permissions-roles, signatures, labor-payroll, customers]
entities: [lunch-record, signature, field-ticket, customer, employee]
part_of: product/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-015 — Work-Through-Lunch Authorization

| Field | Detail |
| --- | --- |
| ID | FR-FOP-015 |
| Title | Work-Through-Lunch Authorization |
| Workflow position | Previous: User does not take required lunch. Current: User records work-through-lunch. Next: Required authorization is captured. |
| Description | The Application must allow users to record work-through-lunch events and capture required authorization. |
| Functional requirements | Provide Work Through Lunch option when lunch is missed. Require reason/comment. Identify which lunch was missed. Trigger required authorization/signature flow. Associate authorization with ticket and crew where applicable. If customer is unavailable, employee records reason and acknowledges the attempt. |
| Business rules | Work-through-lunch may impact payroll and billing. Customer signature is required where business rules specify. For Operator/Oiler crew-level tickets, authorization may apply to the crew. Third Man/Laborer lunch handling requires further client confirmation on signature ownership. |
| Acceptance criteria | User can record missed lunch. Required authorization is captured. Payroll/billing receives work-through-lunch indicator. Missing authorization is flagged. |
| Priority | Must have |

---


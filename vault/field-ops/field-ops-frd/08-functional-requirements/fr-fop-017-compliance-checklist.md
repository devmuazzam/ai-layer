---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [field-ops/frd-new-format-draft/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/admin, module/field-ops, module/payroll, module/projects-jobs, kind/frd, compliance, wtl, inspections, permissions-roles, signatures, permits]
entities: [lunch-record, field-ticket, employee, deficiency, permit, signature]
part_of: field-ops/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-017 — Compliance Checklist

| Field | Detail |
| --- | --- |
| ID | FR-FOP-017 |
| Module | Compliance |
| Title | Compliance Checklist |
| Description | The Application shall provide a final validation experience to ensure required operational activities have been completed prior to ticket finalization. |
| Functional requirements | The Application shall validate required completion activities. The Application shall automatically evaluate lunch obligations and display each applicable obligation individually. The Application shall indicate whether lunch requirements have been satisfied. The Application shall display Lunch Taken, Work Through Lunch Authorization, and Action Required statuses. The Application shall support employee acknowledgements, employee signatures where applicable, and comments. The Application shall preserve audit information. The Application shall prevent completion when mandatory compliance requirements remain unresolved. |
| Compliance states | **Lunch Taken** — applicable lunch obligations satisfied through recorded lunch periods. **Work Through Lunch Authorization** — applicable lunch obligations satisfied through approved Work Through Lunch workflows. **Action Required** — applicable lunch obligations remain unresolved and require corrective action. |
| Business rules | Compliance evaluations shall occur prior to ticket completion. Lunch evaluations shall contribute to compliance outcomes. Mandatory compliance deficiencies shall prevent progression. Detailed compliance calculations shall be defined within the BRS. |
| Acceptance criteria | **AC-001** Given ticket completion activities begin, When the Compliance Checklist is displayed, Then required compliance evaluations shall be performed. **AC-002** Given lunch obligations apply, When the Compliance Checklist is reviewed, Then each obligation shall display its corresponding status. **AC-003** Given unresolved compliance deficiencies exist, When ticket completion is attempted, Then progression shall be prevented. **AC-004** Given all compliance requirements have been satisfied, When ticket completion proceeds, Then users shall be permitted to continue to subsequent workflow activities. |

---


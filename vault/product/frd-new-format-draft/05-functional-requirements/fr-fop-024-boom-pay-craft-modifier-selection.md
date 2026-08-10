---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, labor-payroll, assets, jobs]
entities: [boom-time, craft-code, asset, labor-record, field-ticket, job]
part_of: product/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-024 — Boom Pay / Craft Modifier Selection

| Field | Detail |
| --- | --- |
| ID | FR-FOP-024 |
| Title | Boom Pay / Craft Modifier Selection |
| Workflow position | Previous: User reviews labor details. Current: User confirms boom/craft modifier. Next: Payroll receives labor modifiers. |
| Description | The Application must support boom pay and craft modifier capture. Planned vs actual configuration differences must be trackable. |
| Functional requirements | Show available craft modifiers based on user role and asset configuration. Differentiate Oiler and Operator modifier options. Prefill modifier where system can infer from job/crane configuration. Allow user to add/modify actual configuration used. Require reason/comment when actual differs from planned configuration. |
| Business rules | Boom pay applies based on boom length and role-specific rate rules. Travel time does not qualify for boom pay. Boom pay is calculated based on active work/setup/breakdown rules, not total ticket time. Planned vs actual configuration differences are tracked. |
| Acceptance criteria | User can confirm boom modifier. System limits irrelevant modifier options. Changes from planned setup are logged. Payroll can review planned vs actual modifier. |
| Priority | Must have |

---


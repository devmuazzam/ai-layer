---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/admin, module/customers, module/field-ops, module/projects-jobs, kind/frd, signatures, time-tracking, permissions-roles]
entities: [signature, customer, field-ticket, job]
part_of: field-ops/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-016 — Initial Customer Signature

| Field | Detail |
| --- | --- |
| ID | FR-FOP-016 |
| Title | Initial Customer Signature |
| Workflow position | Previous: User arrives at job and completes pre-work steps. Current: Customer signs initial authorization. Next: User starts work. |
| Description | The Application must allow required customer/site representative signature before work begins. |
| Functional requirements | Capture signer name. Capture signature. Capture timestamp. Attach terms and conditions. Store signature against ticket/job. Support early capture if customer may leave site. |
| Business rules | Oiler is responsible for main customer signature in Operator/Oiler flow. Third Man/Laborer does not capture main customer signature unless explicitly assigned. Signature flow is consistent across forms. Signature is auditable. |
| Acceptance criteria | Signer name and signature are captured. Signature is linked to ticket. User can proceed to Start Work after required signature. |
| Priority | Must have |

---


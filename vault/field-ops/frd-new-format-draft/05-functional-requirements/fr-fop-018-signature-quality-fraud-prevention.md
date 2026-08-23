---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, signatures, engineering-process]
entities: [signature]
part_of: field-ops/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-018 — Signature Quality / Fraud Prevention _(Updated v1.1)_

| Field | Detail |
| --- | --- |
| ID | FR-FOP-018 |
| Title | Signature Quality / Fraud Prevention |
| Workflow position | Previous: Signature capture is initiated. Current: System captures and validates signature context. Next: Signature is saved or flagged. |
| Description | The Application must reduce invalid signatures and support stronger signature evidence. Photo capture is now a configurable deployment toggle, not a future enhancement. |
| Functional requirements | Require signer name before signature. Detect obviously invalid signatures where feasible. Support configurable photo capture during signature collection. Support automatic photo capture upon signature completion where enabled. Clearly indicate when photo evidence collection is active. Show terms/disclaimer before signature. Store signature metadata. |
| Business rules | Fraud prevention must not make field workflow overly slow. Photo capture is configurable per deployment. Photo collection requirements comply with approved legal language. Signature photo requirements apply consistently across all signature types when enabled. Invalid or questionable signatures are flagged for review. |
| Acceptance criteria | Signature cannot be submitted without signer name. Signature metadata is stored. Photo capture can be enabled or disabled per deployment configuration. When enabled, capture state is clearly visible to the signer. |
| Priority | Must have |

---


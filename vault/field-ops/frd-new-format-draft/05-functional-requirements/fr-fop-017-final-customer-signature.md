---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, signatures, customers, jobs, time-tracking, yards]
entities: [signature, customer, job, yard]
part_of: field-ops/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-017 — Final Customer Signature

| Field | Detail |
| --- | --- |
| ID | FR-FOP-017 |
| Title | Final Customer Signature |
| Workflow position | Previous: User ends work. Current: Customer signs completion confirmation. Next: User leaves job / returns to yard. |
| Description | The Application must allow required final customer signature for work completion. |
| Functional requirements | Capture signer name. Capture final signature. Capture timestamp. Allow completion signature to be captured earlier with disclaimer if customer is leaving. Show whether signature was captured before actual end time. |
| Business rules | Final signature confirms completion status, job-site condition, and related acknowledgements. If captured early, system stores actual signature time separately. Early signature requires acknowledgement/disclaimer. |
| Acceptance criteria | Final signature can be captured. Early signature is clearly marked. Missing final signature is flagged for review. |
| Priority | Must have |

---


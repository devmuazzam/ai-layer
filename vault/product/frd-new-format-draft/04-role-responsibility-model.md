---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, labor-payroll, inspections, signatures, ticket-workflow, customers, compliance, notifications]
entities: [field-ticket, labor-record, signature, customer, job, asset, certification, notification]
part_of: product/frd-new-format-draft/INDEX.md
---
## 4. Role Responsibility Model

### 4.1 Operator + Oiler

The Oiler owns the main ticket. The Operator's labor is captured within the shared ticket but the Operator does not process paperwork or collect signatures.

| Responsibility | Oiler | Operator |
| --- | --- | --- |
| Process main LEM ticket | ✓ | — |
| Complete ticket paperwork | ✓ | — |
| Capture customer signatures | ✓ | — |
| Complete pre-trip checklist (crane, tractor, trailer, support loads) | ✓ | — |
| Record operator-related labor details | ✓ | — |
| Access app and view job information | ✓ | ✓ |
| View profile, labor, certifications, notifications | ✓ | ✓ |
| Review labor history and post-submission changes | ✓ | ✓ |

### 4.2 Third Man / Laborer

Third Man and Laborer users are fully self-contained. They own their ticket end to end and are not responsible for crew-level signature flows.

| Responsibility | Third Man / Laborer |
| --- | --- |
| Process own assigned ticket | ✓ |
| Complete own pre-trip and vehicle checklist | ✓ |
| Record own labor details | ✓ |
| Complete compliance confirmations | ✓ |
| Submit own ticket | ✓ |
| Main customer signature capture | — |
| Operator/Oiler paperwork | — |

---


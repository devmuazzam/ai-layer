---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [field-ops/frd-new-format-draft/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/customers, module/field-ops, module/projects-jobs, kind/frd, signatures, permits, time-tracking]
entities: [signature, customer, field-ticket, permit]
part_of: field-ops/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-018 — Customer Signatures

| Field | Detail |
| --- | --- |
| ID | FR-FOP-018 |
| Module | Signatures |
| Title | Customer Signatures |
| Description | The Application shall support the collection of customer acknowledgements and signatures required during ticket completion. Customer signatures provide confirmation that the services performed align with customer expectations and support operational record keeping. |
| Functional requirements | The Application shall support collection of primary and secondary customer signatures where applicable. The Application shall display the name and title or relationship of the individual providing the signature. The Application shall support configurable signature requirements and signature comments. The Application shall support configurable photo capture during signature workflows and automatic photo capture where enabled. The Application shall preserve signature metadata and capture signature timestamps. The Application shall support viewing previously captured signatures prior to submission and updating signatures prior to final submission where permitted. |
| Business rules | Signature requirements shall be configurable and may vary based on ticket type. Signatures shall remain editable until final ticket submission where permitted. Finalized tickets shall preserve signature history. Signature activities shall remain auditable. |
| Acceptance criteria | **AC-001** Given signatures are required, When the user reaches the signature workflow, Then required signatures shall be collected. **AC-002** Given signature photo capture is enabled, When signatures are completed, Then associated photo evidence shall be captured. **AC-003** Given signatures remain incomplete, When ticket submission is attempted, Then progression shall be prevented. |

---


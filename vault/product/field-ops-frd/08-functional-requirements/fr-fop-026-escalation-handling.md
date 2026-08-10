---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [product/frd-new-format-draft/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, escalation, notifications, deficiencies, inspections, compliance, safety, downtime-delays]
entities: [deficiency, notification, inspection, downtime, category]
part_of: product/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-026 — Escalation Handling

| Field | Detail |
| --- | --- |
| ID | FR-FOP-026 |
| Module | Deficiencies |
| Title | Escalation Handling |
| Description | The Application shall support escalation workflows for events requiring additional awareness, intervention, or approval. |
| Escalation sources | Blocking deficiencies, safety concerns, inspection outcomes, operational interruptions, downtime events, compliance failures. |
| Functional requirements | The Application shall support escalation initiation, categorization, and comments. The Application shall support escalation notifications and tracking escalation status. The Application shall support escalation resolution updates. The Application shall preserve escalation audit information. |
| Business rules | Escalation workflows and recipients shall be configurable. Blocking deficiencies shall require escalation. Detailed escalation routing shall be defined within the BRS. Escalation activities shall remain auditable. |
| Acceptance criteria | **AC-001** Given escalation conditions are satisfied, When escalation processing occurs, Then escalation records shall be created. **AC-002** Given escalation notifications are configured, When escalations occur, Then notifications shall be distributed appropriately. |

---


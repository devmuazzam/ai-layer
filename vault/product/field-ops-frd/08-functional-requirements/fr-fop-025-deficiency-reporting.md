---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [product/frd-new-format-draft/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, deficiencies, escalation, inspections, documents-attachments, categories, permissions-roles]
entities: [deficiency, field-ticket, inspection, attachment, category]
part_of: product/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-025 — Deficiency Reporting

| Field | Detail |
| --- | --- |
| ID | FR-FOP-025 |
| Module | Deficiencies |
| Title | Deficiency Reporting |
| Description | The Application shall support the identification, documentation, and tracking of deficiencies identified during ticket execution and inspection activities. Deficiencies represent conditions requiring awareness, corrective action, escalation, or maintenance intervention. |
| Severity levels | **Normal** — deficiencies requiring documentation and future attention. **Urgent** — deficiencies requiring elevated visibility and timely follow-up. **Blocking** — deficiencies preventing continuation of operational activities until resolution occurs. |
| Functional requirements | The Application shall support creation and categorization of deficiencies. The Application shall support deficiency descriptions, photo attachments, and supporting comments. The Application shall support associating deficiencies with tickets, inspections, equipment, and trucks. The Application shall support review of previously identified deficiencies. The Application shall preserve audit information. |
| Business rules | Deficiency severity shall be configurable by authorized personnel. Blocking deficiencies shall initiate escalation workflows. Urgent deficiencies shall receive elevated visibility. Deficiency activities shall remain auditable. |
| Acceptance criteria | **AC-001** Given deficiencies are identified, When deficiency information is recorded, Then deficiencies shall be associated with the applicable workflow activity. **AC-002** Given deficiencies include supporting evidence, When deficiency processing occurs, Then photo evidence shall be preserved. **AC-003** Given blocking deficiencies exist, When workflow progression is attempted, Then escalation requirements shall be initiated. |

---


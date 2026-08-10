---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [product/frd-new-format-draft/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, inspections, deficiencies, safety, escalation, yards, permits, documents-attachments]
entities: [inspection, deficiency, yard, asset, permit, attachment]
part_of: product/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-008 — Pre-Trip Checklist

| Field | Detail |
| --- | --- |
| ID | FR-FOP-008 |
| Module | Inspections |
| Title | Pre-Trip Checklist |
| Description | The Application shall support completion of inspections prior to departure from the yard. |
| Functional requirements | The Application shall support configurable checklist templates. The Application shall support mandatory and optional checklist items. The Application shall support deficiency reporting, photo attachments, and comments. The Application shall support guided checklist execution and flexible checklist navigation where permitted. The Application shall support electronic acknowledgement and saving progress. |
| Business rules | Safety-sensitive checklist items shall remain mandatory. Checklist behavior shall be configurable. Oiler users shall complete crane-related inspections and inspections associated with the Operator Load. Support Load personnel shall complete inspections associated with their assigned support loads and trucks. Deficiencies identified during inspections may trigger escalation workflows. |
| Acceptance criteria | **AC-001** Given pre-trip inspections are required, When the user begins the checklist, Then required checklist items shall be displayed. **AC-002** Given mandatory items remain incomplete, When the user attempts completion, Then progression shall be prevented. **AC-003** Given deficiencies are identified, When checklist completion occurs, Then deficiencies shall be recorded. |

---


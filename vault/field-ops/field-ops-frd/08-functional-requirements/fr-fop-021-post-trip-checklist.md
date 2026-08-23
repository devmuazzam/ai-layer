---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [field-ops/frd-new-format-draft/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, inspections, deficiencies, escalation, documents-attachments]
entities: [deficiency, inspection, attachment]
part_of: field-ops/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-021 — Post-Trip Checklist

| Field | Detail |
| --- | --- |
| ID | FR-FOP-021 |
| Module | Inspections |
| Title | Post-Trip Checklist |
| Description | The Application shall support completion of inspections following the conclusion of field activities. The purpose of Post-Trip inspections is to identify deficiencies requiring follow-up actions and to maintain operational readiness. |
| Functional requirements | The Application shall support configurable Post-Trip checklist templates. The Application shall support mandatory and optional checklist items. The Application shall support deficiency reporting, photo attachments, and comments. The Application shall support electronic acknowledgements and saving progress. The Application shall support deficiency severity classifications and maintenance escalation workflows. |
| Business rules | Post-Trip requirements shall be configurable. Organizations shall determine whether Post-Trip inspections are mandatory. Deficiencies identified during Post-Trip inspections may trigger escalation workflows. Blocking deficiencies shall initiate escalation procedures. Urgent deficiencies shall receive elevated visibility. Post-Trip activities shall remain auditable. |
| Acceptance criteria | **AC-001** Given Post-Trip inspections are required, When the user begins the checklist, Then required checklist items shall be displayed. **AC-002** Given mandatory checklist items remain incomplete, When checklist completion is attempted, Then progression shall be prevented. **AC-003** Given deficiencies are identified, When Post-Trip completion occurs, Then deficiencies shall be recorded. |

---


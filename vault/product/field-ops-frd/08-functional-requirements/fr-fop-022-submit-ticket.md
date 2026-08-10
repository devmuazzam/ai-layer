---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [product/frd-new-format-draft/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, ticket-workflow, time-tracking, signatures, compliance, labor-payroll]
entities: [field-ticket, deficiency, signature]
part_of: product/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-022 — Submit Ticket

| Field | Detail |
| --- | --- |
| ID | FR-FOP-022 |
| Module | Tickets |
| Title | Submit Ticket |
| Description | The Application shall support final submission of completed tickets. Ticket submission represents the conclusion of field activities for the assigned ticket. |
| Functional requirements | The Application shall support ticket submission. The Application shall validate mandatory completion requirements and support final review prior to submission. The Application shall preserve audit information and capture submission timestamps. The Application shall transition ticket status to Submitted. The Application shall prevent modification following submission except by authorized personnel. The Application shall support displaying submission confirmations. |
| Business rules | All mandatory activities shall be satisfied prior to submission. Compliance deficiencies and incomplete required signatures shall prevent submission. Submitted tickets shall remain auditable. Detailed payroll processing activities shall be defined within the BRS. |
| Acceptance criteria | **AC-001** Given all required activities have been completed, When ticket submission occurs, Then ticket status shall transition to Submitted. **AC-002** Given mandatory requirements remain unresolved, When ticket submission is attempted, Then submission shall be prevented. **AC-003** Given ticket submission has been completed, When users access ticket information, Then submission details shall remain visible. |

---


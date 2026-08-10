---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [product/frd-new-format-draft/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, ticket-workflow, time-tracking, notifications]
entities: [field-ticket]
part_of: product/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-005 — Ticket Acceptance

| Field | Detail |
| --- | --- |
| ID | FR-FOP-005 |
| Module | Tickets |
| Title | Ticket Acceptance |
| Description | The Application shall support acknowledgement of assigned tickets. |
| Functional requirements | The Application shall allow users to accept assigned tickets. The Application shall capture acceptance timestamps. The Application shall update ticket status following acceptance. The Application shall support acceptance acknowledgements. The Application shall notify relevant stakeholders upon acceptance where applicable. |
| Business rules | Only assigned users may accept tickets. Accepted tickets shall transition into the active workflow state. Acceptance activities shall be auditable. |
| Acceptance criteria | **AC-001** Given an assigned ticket exists, When the user accepts the ticket, Then the ticket status shall be updated accordingly. **AC-002** Given ticket acceptance occurs, When the acceptance is processed, Then an acceptance timestamp shall be recorded. |

---


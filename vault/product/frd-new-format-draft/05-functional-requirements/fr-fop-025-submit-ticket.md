---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, ticket-workflow, labor-payroll, permits]
entities: [field-ticket, permit, labor-record]
part_of: product/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-025 — Submit Ticket

| Field | Detail |
| --- | --- |
| ID | FR-FOP-025 |
| Title | Submit Ticket |
| Workflow position | Previous: Labor details reviewed. Current: User submits ticket. Next: Ticket moves to Completed or Review Required. |
| Description | The Application must allow the user to submit the ticket after all required steps are complete. Missing items are surfaced before submission is permitted. |
| Functional requirements | Provide a clear Submit / Complete Ticket action. Validate required steps before submission. Show missing items before submission is permitted. Allow user to return to incomplete items. Update ticket status after submission. |
| Business rules | Ticket cannot be completed if required items are missing. Draft/incomplete tickets remain visible until completed. Submission makes the ticket available for payroll/billing review. Ticket completion is auditable. |
| Acceptance criteria | User can submit a complete ticket. Incomplete ticket cannot be submitted without resolving required items. System shows missing items clearly. Ticket status updates to Completed or Review Required. |
| Priority | Must have |

---


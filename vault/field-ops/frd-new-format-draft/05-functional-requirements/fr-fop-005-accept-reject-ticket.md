---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/dispatch, module/field-ops, kind/frd, ticket-workflow, time-tracking, notifications]
entities: [field-ticket]
part_of: field-ops/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-005 — Accept / Reject Ticket

| Field | Detail |
| --- | --- |
| ID | FR-FOP-005 |
| Title | Accept / Reject Ticket |
| Workflow position | Previous: User receives ticket assignment. Current: User accepts or rejects. Next: Accepted ticket becomes active; rejected ticket returns to Dispatch. |
| Description | The Application must allow field users to accept or reject assigned tickets when the workflow requires confirmation. |
| Functional requirements | Provide Accept and Reject actions where applicable. Show ticket summary before action. Require rejection reason when user rejects. Update ticket status after action. Notify Dispatch on rejection. |
| Business rules | Acceptance confirms user acknowledgement. Rejection does not delete the ticket. Rejected tickets are escalated to Dispatch for reassignment or correction. System tracks timestamp, user, and action for audit. |
| Acceptance criteria | User can accept ticket. User can reject ticket with reason. Accepted ticket becomes active. Rejected ticket is visible to Dispatch as an issue. |
| Priority | Must have |

---


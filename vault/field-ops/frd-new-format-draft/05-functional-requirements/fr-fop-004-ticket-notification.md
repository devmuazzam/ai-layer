---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, notifications, dispatch, jobs, ticket-workflow, safety]
entities: [field-ticket, notification, job]
part_of: field-ops/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-004 — Ticket Notification

| Field | Detail |
| --- | --- |
| ID | FR-FOP-004 |
| Title | Ticket Notification |
| Workflow position | Previous: Dispatch finalises assignment. Current: Ticket is sent to field user. Next: User accepts, rejects, or views default accepted assignment. |
| Description | The Application must notify field users when a ticket is assigned to them. |
| Functional requirements | Send mobile notification on assignment. Display assigned ticket on Home and Jobs. Indicate whether acceptance is required. Show assignment details before the user takes action. |
| Business rules | Standard allocations may be considered accepted by default unless explicit acceptance is required. After-hours or emergency assignments require explicit accept/reject. Rejection notifies Dispatch and flags the job for resolution. |
| Acceptance criteria | User receives ticket assignment notification. Ticket appears in Home and Jobs. User can see whether action is required. Dispatch is notified if ticket is rejected. |
| Priority | Must have |

---


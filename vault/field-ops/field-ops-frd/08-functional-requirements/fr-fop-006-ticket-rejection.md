---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [field-ops/frd-new-format-draft/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/field-ops, module/projects-jobs, kind/frd, ticket-workflow, permits, time-tracking, notifications]
entities: [field-ticket, permit]
part_of: field-ops/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-006 — Ticket Rejection

| Field | Detail |
| --- | --- |
| ID | FR-FOP-006 |
| Module | Tickets |
| Title | Ticket Rejection |
| Description | The Application shall support rejection of assigned tickets where permitted. |
| Functional requirements | The Application shall allow users to reject assigned tickets. The Application shall require rejection reasons. The Application shall capture rejection timestamps. The Application shall notify appropriate stakeholders. The Application shall support free-text comments. |
| Business rules | Ticket rejection capabilities shall be configurable. Only eligible users shall be permitted to reject tickets. Rejected tickets shall remain auditable. |
| Acceptance criteria | **AC-001** Given ticket rejection is permitted, When the user rejects a ticket, Then a rejection reason shall be required. **AC-002** Given rejection occurs, When processing completes, Then the rejection event shall be recorded. |

---


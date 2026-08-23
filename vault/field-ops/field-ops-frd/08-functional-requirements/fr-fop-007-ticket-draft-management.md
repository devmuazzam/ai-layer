---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [field-ops/frd-new-format-draft/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, ticket-workflow, permissions-roles]
entities: [field-ticket, employee]
part_of: field-ops/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-007 — Ticket Draft Management

| Field | Detail |
| --- | --- |
| ID | FR-FOP-007 |
| Module | Tickets |
| Title | Ticket Draft Management |
| Description | The Application shall preserve ticket progress throughout execution. |
| Functional requirements | The Application shall automatically save ticket progress. The Application shall support continuation of incomplete tickets. The Application shall visually distinguish draft tickets. The Application shall preserve entered information. The Application shall support exiting and resuming ticket workflows. The Application shall support visibility into incomplete activities. The Application shall allow authorized personnel to review draft progress. |
| Business rules | Draft tickets shall not constitute completed tickets. Ticket ownership shall remain with the assigned employee until submission. Draft visibility shall respect role permissions. |
| Acceptance criteria | **AC-001** Given ticket progress exists, When a user exits the workflow, Then progress shall be preserved. **AC-002** Given a draft ticket exists, When the user resumes work, Then previously entered information shall be available. |

---


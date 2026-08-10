---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [product/frd-new-format-draft/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, ticket-workflow, customers, jobs, scheduling, permissions-roles]
entities: [field-ticket, customer, job, schedule, job-site]
part_of: product/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-004 — Ticket Details

| Field | Detail |
| --- | --- |
| ID | FR-FOP-004 |
| Module | Jobs |
| Title | Ticket Details |
| Description | The Application shall provide users with detailed information related to an assigned ticket to support execution of field activities. |
| Functional requirements | The Application shall display Ticket Number, Job Number, Customer Name, Customer Contact Information where available, Job Site Location, Scheduled Date, Scheduled Time, Ticket Status, assigned personnel, assigned equipment information, Operator Load information, Support Load information, customer notes, and dispatcher notes where applicable. The Application shall display ticket progress indicators. The Application shall support navigation to workflow activities. The Application shall support continuation of draft workflows. |
| Business rules | Only information relevant to the authenticated user shall be displayed. Ticket visibility shall respect user permissions. Draft tickets shall remain editable until final submission. Submitted tickets shall become read-only unless modified by authorized personnel. |
| Acceptance criteria | **AC-001** Given a user selects a ticket, When Ticket Details are opened, Then all relevant ticket information shall be displayed. **AC-002** Given a ticket is in draft status, When Ticket Details are displayed, Then users shall be able to continue ticket processing. |

---


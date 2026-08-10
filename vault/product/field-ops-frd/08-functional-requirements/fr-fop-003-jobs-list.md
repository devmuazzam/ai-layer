---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [product/frd-new-format-draft/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, jobs, ticket-workflow, customers, scheduling, authentication]
entities: [field-ticket, job, customer, schedule]
part_of: product/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-003 — Jobs List

| Field | Detail |
| --- | --- |
| ID | FR-FOP-003 |
| Module | Jobs |
| Title | Jobs List |
| Description | The Application shall provide users with visibility into tickets assigned to them. |
| Functional requirements | The Application shall display assigned jobs. The Application shall display Ticket Number, Customer Name, Customer Location, Scheduled Date, Scheduled Time, Ticket Status, Assigned Equipment Summary, Draft Indicators, and Completion Indicators. The Application shall support navigation into Ticket Details. The Application shall support filtering of jobs. The Application shall support sorting of jobs. |
| Business rules | Only tickets assigned to the authenticated user shall be displayed. Historical ticket visibility shall respect role permissions. Draft tickets shall remain distinguishable from completed tickets. |
| Acceptance criteria | **AC-001** Given assigned jobs exist, When the user accesses the Jobs List, Then assigned jobs shall be displayed. **AC-002** Given a ticket is selected, When the user taps the ticket, Then Ticket Details shall be displayed. **AC-003** Given draft tickets exist, When the Jobs List is displayed, Then draft tickets shall be visually distinguishable. |

---


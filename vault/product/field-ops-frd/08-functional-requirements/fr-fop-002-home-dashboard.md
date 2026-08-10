---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [product/frd-new-format-draft/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, dashboard, ticket-workflow, notifications, authentication, certifications, permissions-roles]
entities: [field-ticket, certification, notification, task]
part_of: product/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-002 — Home Dashboard

| Field | Detail |
| --- | --- |
| ID | FR-FOP-002 |
| Module | Home |
| Title | Home Dashboard |
| Description | The Home Dashboard shall provide users with an overview of items requiring attention. |
| Functional requirements | The Application shall display active tickets. The Application shall display upcoming tickets. The Application shall display incomplete tickets. The Application shall display certification alerts. The Application shall display task summaries. The Application shall display operational notifications. The Application shall provide access to ticket continuation when draft tickets exist. |
| Business rules | Only information relevant to the authenticated user shall be displayed. Information visibility shall respect role permissions. |
| Acceptance criteria | **AC-001** Given active tickets exist, When the user accesses the Home Dashboard, Then active tickets shall be displayed. **AC-002** Given incomplete tickets exist, When the Home Dashboard is displayed, Then users shall be able to resume the incomplete ticket. |

---


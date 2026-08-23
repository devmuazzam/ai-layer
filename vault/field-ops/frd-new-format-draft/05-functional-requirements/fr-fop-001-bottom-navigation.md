---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, notifications, navigation-ui, jobs, authentication, yards, dispatch]
entities: [job, notification, field-ticket, yard]
part_of: field-ops/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-001 — Bottom Navigation

| Field | Detail |
| --- | --- |
| ID | FR-FOP-001 |
| Title | Bottom Navigation |
| Workflow position | Previous: User logs in. Current: User accesses the main app shell. Next: User opens Home, Jobs, Notifications, or Menu. |
| Description | The Application must provide a modern bottom navigation structure for field operations users. Navigation is role-aware and scoped to field operations functionality only. |
| Functional requirements | Bottom navigation displayed after login. Four items: Home, Jobs, Notifications, Menu. No side navigation on mobile. Navigation visibility is role-scoped — field users do not see Sales, Dispatch, Yard, or Mechanic functionality. Navigation persists unless user is inside a focused workflow step that intentionally hides it. |
| Business rules | Home must prioritise current operational work. Jobs must provide access to assigned and historical tickets. Notifications must show alerts requiring attention. Menu must contain secondary functions. |
| Acceptance criteria | User can switch between all four navigation items. Role-specific items are absent. Navigation is accessible after login throughout the application. |
| Priority | Must have |

---


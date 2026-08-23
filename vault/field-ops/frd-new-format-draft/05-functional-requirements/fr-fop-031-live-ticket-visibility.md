---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/admin, module/field-ops, kind/frd, permissions-roles, ticket-workflow]
entities: [field-ticket, employee]
part_of: field-ops/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-031 — Live Ticket Visibility _(New v1.1)_

| Field | Detail |
| --- | --- |
| ID | FR-FOP-031 |
| Title | Live Ticket Visibility |
| Workflow position | Previous: User has started but not submitted a ticket. Current: Ticket is in draft/in-progress state. Next: User resumes and completes. |
| Description | The Application must preserve ticket progress visibility throughout completion and allow authorised personnel to review in-progress ticket data subject to role permissions. |
| Functional requirements | Ticket information remains available to the assigned user while in draft status. Draft status is clearly indicated as work-in-progress. Users can exit and resume draft tickets without loss of progress. Authorised personnel (e.g. supervisors) may review ticket progress before submission, subject to role permissions. |
| Business rules | Draft visibility does not constitute ticket completion. Ticket ownership remains with the assigned field employee until submission. Access to in-progress ticket data by non-assigned users respects role permissions. Supervisory access supports operational oversight without requiring submission. |
| Acceptance criteria | Draft tickets remain visible to the assigned user. Ticket progress persists after app exit. User can resume without loss of information. Authorised personnel can view in-progress data where role permissions allow. |
| Priority | Must have |

---


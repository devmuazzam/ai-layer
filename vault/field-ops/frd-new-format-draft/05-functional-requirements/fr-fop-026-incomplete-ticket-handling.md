---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, ticket-workflow, signatures, labor-payroll, notifications, downtime-delays, offline-reliability]
entities: [field-ticket]
part_of: field-ops/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-026 — Incomplete Ticket Handling _(Updated v1.1)_

| Field | Detail |
| --- | --- |
| ID | FR-FOP-026 |
| Title | Incomplete Ticket Handling |
| Workflow position | Previous: User starts ticket but does not complete all items. Current: System keeps ticket in draft state. Next: User resumes and completes. |
| Description | The Application must prevent incomplete tickets from being lost or ignored. Enforcement behaviour is configurable across three tiers — warning, soft-block, and hard-block. |
| Enforcement tiers | **Warning** — user is notified that unresolved tickets exist; no restriction applied. **Soft-block** — user can proceed to subsequent tickets but receives persistent warnings. **Hard-block** — user cannot progress into subsequent ticket workflows until the incomplete ticket is resolved. |
| Functional requirements | Auto-save ticket progress. Show incomplete tickets on Home. Show missing required actions. Notify user after configured time if ticket remains incomplete. Support all three enforcement tiers as configurable options. |
| Business rules | Incomplete tickets delay payroll and billing. Ticket progress is preserved automatically during completion. Users can exit and resume incomplete tickets without loss of data. Draft tickets are visually distinguishable from completed tickets. The active enforcement tier is configured with client sign-off before implementation. |
| Acceptance criteria | Incomplete ticket remains visible on Home. User can resume from last saved step. User receives warning when unresolved tickets exist. User experiences the configured enforcement tier. User can identify the incomplete ticket preventing progression where hard-block is active. |
| Priority | Must have |

---


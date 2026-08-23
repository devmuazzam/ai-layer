---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/admin, module/field-ops, module/projects-jobs, kind/frd, inspections, safety, permissions-roles]
entities: [deficiency, field-ticket, job]
part_of: field-ops/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-027 — Deficiency Capture _(Updated v1.1)_

| Field | Detail |
| --- | --- |
| ID | FR-FOP-027 |
| Title | Deficiency Capture |
| Workflow position | Previous: User completes checklist or identifies issue. Current: User records deficiency. Next: Issue routed per severity. |
| Description | The Application must allow field users to record deficiencies with formal three-tier severity classification. |
| Severity tiers | **Normal** — standard routing for maintenance review. **Urgent** — elevated visibility and expedited routing. **Blocking** — immediately initiates escalation workflow. |
| Functional requirements | Allow deficiency selection. Require comment. Support Normal, Urgent, and Blocking severity tiers. Allow photo upload where applicable. Attach deficiency to unit, ticket, job, and user. Show deficiency status where available. |
| Business rules | Normal deficiencies route to standard maintenance review. Urgent deficiencies receive elevated visibility and expedited routing. Blocking deficiencies immediately initiate escalation workflows. Deficiency severity is modifiable by authorised users after initial capture. Safety-related deficiencies are clearly identifiable. |
| Acceptance criteria | User can log deficiency. Required comment is enforced. User can select Normal, Urgent, or Blocking severity. Deficiency is attached to the correct unit/job/ticket. Urgent deficiency receives elevated visibility. Blocking deficiency triggers escalation workflow. |
| Priority | Must have |

---


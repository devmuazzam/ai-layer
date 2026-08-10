---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, inspections, deficiencies, time-tracking, safety, job-sites]
entities: [deficiency, field-ticket, job, job-site, yard, asset]
part_of: product/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-009 — Pre-Trip Checklist _(Updated v1.1)_

| Field | Detail |
| --- | --- |
| ID | FR-FOP-009 |
| Title | Pre-Trip Checklist |
| Workflow position | Previous: User records Leave Yard. Current: User completes pre-trip checklist(s). Next: Travel to job site. |
| Description | The Application must allow field users to complete required pre-trip checklist(s) for assigned unit(s). Checklist execution mode is configurable — guided or flexible — through checklist templates. |
| Functional requirements | Generate required checklist(s) based on assigned unit(s). Allow checklist completion from mobile. Require all mandatory questions to be answered. Allow deficiency selection with mandatory comment and priority. Allow photo attachment where required. Associate checklist with ticket, user, unit, job, and timestamp. Support guided progression (sequential) and flexible navigation (open) as configurable execution modes. |
| Business rules | Oiler completes checklist items for Operator/Oiler setup including crane, tractor, trailer, and support loads. Third Man / Laborer completes their own vehicle/equipment checklist. Safety-sensitive checklist items are mandatory regardless of execution mode. Deficiencies must be visible for downstream handling. |
| Acceptance criteria | User can complete checklist. System blocks completion if mandatory answers are missing. Deficiency requires comment. Checklist is linked to ticket and unit. Execution mode (guided or flexible) is applied as configured in the template. |
| Priority | Must have |

---


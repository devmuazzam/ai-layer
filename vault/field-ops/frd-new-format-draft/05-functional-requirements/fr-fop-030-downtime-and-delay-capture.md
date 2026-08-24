---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/assets, module/customers, module/field-ops, module/payroll, module/projects-jobs, kind/frd]
entities: [downtime, field-ticket, customer, category, job]
part_of: field-ops/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-030 — Downtime and Delay Capture _(New v1.1)_

| Field | Detail |
| --- | --- |
| ID | FR-FOP-030 |
| Title | Downtime and Delay Capture |
| Workflow position | Previous: Active work is in progress. Current: Unexpected delay occurs. Next: Delay resolved, work resumes. |
| Description | The Application must support recording of delays impacting job execution during active ticket processing. Delay category determines whether customer acknowledgement is required. |
| Downtime categories | Customer Delay — customer acknowledgement required. TCG Delay — no acknowledgement required. Weather Delay — no acknowledgement required. Equipment Delay — customer acknowledgement required. Other — no acknowledgement required. |
| Functional requirements | Allow user to initiate a downtime event from within the active ticket. Require delay classification from the defined category list. Require supporting notes. Record delay duration. Require customer acknowledgement where classification demands it. Allow work to resume after delay resolution. Associate downtime record with the active ticket. |
| Business rules | Downtime events remain associated with the active ticket throughout. Delay handling does not interrupt ticket continuity — ticket remains in progress. Delay duration and category flow to payroll and billing review. |
| Acceptance criteria | User can initiate a downtime event. Delay classification is captured. Customer acknowledgement is collected when required. Work resumes after delay resolution. Downtime record is attached to the ticket. |
| Priority | Must have |

---


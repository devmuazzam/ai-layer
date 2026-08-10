---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, inspections, time-tracking, signatures, offline-reliability, ticket-workflow]
entities: [field-ticket, signature, job, yard, certification, deficiency]
part_of: product/frd-new-format-draft/INDEX.md
---
## 7. Non-Functional Requirements

| Requirement | Detail |
| --- | --- |
| Audit trail | Every time event, status change, manual edit, signature capture, checklist completion, and deficiency must be logged with user, timestamp, and action. Audit records are not editable by field users. |
| Auto-save | Progress is saved after every completed action. App crash or forced exit must not result in loss of signatures, timestamps, checklist answers, or labor details. |
| Time accuracy | Exact timestamps are always captured and stored separately from rounded payroll/billing times. Rounding rules are configurable. Exact time is never overwritten. |
| Role enforcement | All navigation, workflow steps, data visibility, and ticket access are scoped to the user's assigned role. Users cannot access functionality outside their role group. |
| Offline capability | Ticket workflow must support partial offline operation where network connectivity is unavailable in the field. Progress is queued and synced on reconnection. |
| GPS/Samsara integration | Location validation is available for Arrive Job, Leave Job, and Arrive Yard events where Samsara integration is active. Manual override remains available in all cases. |
| Performance | Ticket screens, checklist rendering, and signature capture must load within acceptable response times under field network conditions. |
| Configurability | Checklist execution mode, incomplete ticket enforcement tier, lunch thresholds, photo capture, time rounding rules, and certification expiry alerts are all configurable without code changes. |

---


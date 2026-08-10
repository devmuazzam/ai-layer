---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, lunch-breaks, notifications, labor-payroll]
entities: [lunch-record, field-ticket, notification, union-code]
part_of: product/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-013 — Lunch Timer and Alerts

| Field | Detail |
| --- | --- |
| ID | FR-FOP-013 |
| Title | Lunch Timer and Alerts |
| Workflow position | Previous: Work has started. Current: System monitors lunch thresholds. Next: User takes lunch or records work-through-lunch. |
| Description | The Application must notify field users before lunch deadlines. First, second, third, and fourth lunch threshold rules must each be configurable. |
| Functional requirements | Calculate lunch timing from applicable shift/work start rules. Send alert before each lunch threshold is due. Support multiple lunch thresholds. Show lunch status inside active ticket. Support push notification and other configured channels. |
| Business rules | Lunch rules are union/payroll-sensitive. Each lunch threshold is configured independently. Alerts must occur before penalty thresholds. Missed lunch requires work-through-lunch flow. |
| Acceptance criteria | User receives lunch alert before due threshold. Ticket shows lunch status. Missed lunch can be recorded through work-through-lunch flow. |
| Priority | Must have |

---


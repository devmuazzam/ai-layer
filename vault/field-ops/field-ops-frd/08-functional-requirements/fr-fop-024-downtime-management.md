---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [field-ops/frd-new-format-draft/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/assets, module/customers, module/field-ops, kind/frd, requirements]
entities: [downtime, field-ticket, customer, category]
part_of: field-ops/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-024 — Downtime Management

| Field | Detail |
| --- | --- |
| ID | FR-FOP-024 |
| Module | Downtime |
| Title | Downtime Management |
| Description | The Application shall support recording delays impacting ticket execution. Downtime events provide visibility into interruptions that may influence operations and downstream processing activities. |
| Downtime categories | Customer Delay, TCG Delay, Equipment Delay, Weather Delay, Other. |
| Functional requirements | The Application shall support initiating and ending downtime events. The Application shall support downtime classification, comments, and capturing durations. The Application shall support customer acknowledgements where applicable. The Application shall preserve audit information. The Application shall support multiple downtime events within a single ticket and maintain visibility into active downtime events. |
| Business rules | Downtime events shall remain associated with the active ticket. Downtime acknowledgement requirements shall be configurable. Detailed downtime implications shall be defined within the BRS. Downtime activities shall remain auditable. |
| Acceptance criteria | **AC-001** Given interruptions occur during ticket execution, When downtime activities are initiated, Then downtime events shall be recorded. **AC-002** Given downtime classifications are required, When downtime information is captured, Then downtime categories shall be selected. **AC-003** Given downtime events have concluded, When downtime processing completes, Then durations shall be preserved. |

---


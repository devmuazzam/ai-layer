---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/assets, module/customers, module/field-ops, module/projects-jobs, kind/frd, signatures, ticket-workflow, inspections, time-tracking, yards]
entities: [field-ticket, customer, signature, job, yard, labor-record, tailboard-jsa, lunch-record]
part_of: field-ops/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-007 — Guided Ticket Workflow

| Field | Detail |
| --- | --- |
| ID | FR-FOP-007 |
| Title | Guided Ticket Workflow |
| Workflow position | Previous: User opens active ticket. Current: System guides user through ticket execution. Next: User completes each step in sequence. |
| Description | The Application must provide a guided workflow for processing field tickets. The current free-form button approach must be replaced. |
| Primary workflow | Ticket Active → Leave Yard → Pre-Trip Checklist → Travel → Arrive Job → Customer Sign-Off → JSA → Start Work → Lunch Handling → End Work → Final Signature → Leave Job → Arrive Yard → Compliance Checklist → Labor Details → Submit Ticket → Completed |
| Functional requirements | Show current step and next required step at all times. Prevent users from skipping mandatory steps. Allow users to resume incomplete workflow. Auto-save progress at each step. Support role-specific workflow variations. |
| Business rules | Oiler workflow includes main ticket and customer signature responsibilities. Third Man / Laborer workflow excludes main customer signature steps. The workflow must remain flexible enough to support legitimate corrections. |
| Acceptance criteria | User can follow the workflow step by step. User always sees what is required next. User cannot accidentally lose progress. Oiler and Third Man/Laborer flows differ where required. |
| Priority | Must have |

---


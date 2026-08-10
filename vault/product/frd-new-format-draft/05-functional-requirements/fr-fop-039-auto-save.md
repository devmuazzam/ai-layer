---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, offline-reliability, ticket-workflow, inspections, signatures, labor-payroll]
entities: [field-ticket, signature, labor-record]
part_of: product/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-039 — Auto-Save

| Field | Detail |
| --- | --- |
| ID | FR-FOP-039 |
| Title | Auto-Save |
| Applies to | Ticket workflow, checklists, signatures, labor entry, and all supporting forms. |
| Description | The Application must auto-save user progress throughout ticket execution. Auto-save must not trigger final submission. |
| Functional requirements | Save progress after each completed action. Support draft state. Allow users to resume incomplete tickets. Prevent loss of signatures, times, checklist answers, and labor details. |
| Business rules | Auto-save does not submit the ticket. Draft data remains editable until explicit submission. Final submission is always an explicit user action. |
| Acceptance criteria | User progress is preserved after app crash or timeout. User can resume draft from last saved step. |
| Priority | Must have |

---


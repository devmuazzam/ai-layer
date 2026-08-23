---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, labor-payroll, time-tracking, yards, jobs, inspections, compliance]
entities: [labor-record, field-ticket, job, yard, craft-code, employee, union-code]
part_of: field-ops/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-023 — Labor Detail Entry _(Updated v1.1)_

| Field | Detail |
| --- | --- |
| ID | FR-FOP-023 |
| Title | Labor Detail Entry |
| Workflow position | Previous: Compliance checklist is completed. Current: User reviews and submits labor details. Next: Ticket submission. |
| Description | The Application must allow field users to review and submit labor details for the ticket. The labor screen now surfaces the underlying ticket timestamps so users can verify what drove their calculated hours before submitting. |
| Timestamp display | Leave Yard, Arrive Job, Start Work, End Work, Leave Job, Arrive Yard |
| Functional requirements | Show labor details for the assigned user. Calculate total hours from ticket timestamps where possible. Display the underlying ticket events and their timestamps contributing to calculated labor. Allow manual correction with reason. Show class/union code and craft code from employee profile. Support craft modifiers where applicable. Allow notes/comments. |
| Business rules | Labor data supports payroll processing. Operator/Oiler labor entries remain individually identifiable. Third Man/Laborer labor entries remain individually accountable. Manual edits are tracked. System reduces repeated manual entry. |
| Acceptance criteria | User can review labor details. User can see the ticket timestamps driving labor calculations. User can identify discrepancies requiring correction before submission. Manual adjustment requires reason. Labor record is tied to ticket and user. |
| Priority | Must have |

---


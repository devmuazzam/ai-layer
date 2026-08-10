---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, escalation, jobs, safety, notifications, deficiencies, dispatch, time-tracking]
entities: [job, deficiency, notification]
part_of: product/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-028 — Blocking Issue / Emergency Escalation

| Field | Detail |
| --- | --- |
| ID | FR-FOP-028 |
| Title | Blocking Issue / Emergency Escalation |
| Workflow position | Previous: User identifies deficiency blocking job execution. Current: System escalates. Next: Dispatch/mechanics notified. |
| Description | The Application must support escalation when a field issue blocks job execution. |
| Functional requirements | Allow user to mark issue as blocking. Require description. Allow photos. Trigger urgent notification to configured internal teams. Record escalation timestamp. |
| Business rules | Blocking issue is distinct from normal deficiency priority. Blocking issue may delay job execution. Dispatch and maintenance response workflows are outside this FRD but must receive the escalation. |
| Acceptance criteria | User can mark issue as blocking. Urgent alert is created. Issue is visible for downstream handling. |
| Priority | Must have |

---


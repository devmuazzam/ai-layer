---
title: Scheduling — section index
source: shared-folder/Project-Repository-2026-09-04 — the __ERP_Sales Process scheduling playbooks, the Job Schedule Master workbook, and two Value Engine flowcharts
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/dispatch, kind/index, scheduling, permits]
entities: []
---

# Scheduling — section index

TCG's **current, manual** process for getting a job from a customer phone call onto Dispatch's
board. Six playbooks and one workbook, all delivered 2026-08-06 / 2026-08-11 by Ryan.

**How the pieces fit.** A customer asks for a crane → the Sales Coordinator works the
**Ready to Schedule** checklist → completes the **Scheduling Sheet**, which computes a permit path
→ hands the job to Dispatch as **Green**, **Yellow** or **Red** → sends the customer a **day-prior
confirmation** at 08:00 with Dispatch copied. Changes and cancellations, in and out of hours, have
their own playbooks and always route back through Ready to Schedule.

## Files

| File | Answers | KB |
| --- | --- | --- |
| [ready-to-schedule.md](ready-to-schedule.md) | The gate: what must be collected before Dispatch is contacted, and the 14-field Scheduling Sheet | 8.9 |
| [dispatch-scheduling-path.md](dispatch-scheduling-path.md) | **The permit clock** and the Green / Yellow / Red decision. The rule-densest document in the set | 11.4 |
| [job-schedule-master-workbook.md](job-schedule-master-workbook.md) | The workbook that computes the path automatically — and the rules it states that no playbook does | 11.7 |
| [schedule-changes-and-after-hours.md](schedule-changes-and-after-hours.md) | Changes, reschedules and cancellations, including the overnight ownership handover | 8.6 |
| [day-prior-confirmation-email.md](day-prior-confirmation-email.md) | The 08:00 day-before customer confirmation, its 12 required fields and its exception rules | 7.3 |
| [scheduling-and-closing-out-value-engines.md](scheduling-and-closing-out-value-engines.md) | The two flowcharts — including the **Sub Out** third-party branch documented nowhere else | 6.0 |

## The rule to remember

**Thursday 12:00 noon through Monday start of business does not count toward permit lead time.**
Roughly 3.5 countable days a week. It is why so many jobs land on the Red Path, and it is stated
identically by the playbook and the workbook.

## What is unsettled

- **The playbook and the workbook define Green / Yellow / Red differently.** The playbook's colours
  are about lead time; the workbook's are about whether an annual permit already exists. The drop
  does not say which governs.
- **Yellow** means "a satisfied longer lead time" in one playbook and "permit lead times exceed the
  standard window, create a placeholder" in another.
- **No Confirmations playbook arrived**, though the scheduling flowchart marks it as PLAYBOOK.
  (The **Sub Out** playbook it also marks did arrive — see
  [`../../vendors-agencies/sub-out-crane-and-trucking.md`](../../vendors-agencies/sub-out-crane-and-trucking.md).)
- Three different systems of record are named across the set — NexgenFMS/FCC, iCranetrax,
  HubSpot/CRM.

## Related

- [../city-permits/INDEX.md](../city-permits/INDEX.md) — the permit side of every decision here
- [../project-module/03-create-manage-job-schedule.md](../project-module/03-create-manage-job-schedule.md)
  — the **in-product** Job → Schedule tab (Confluence, 2026-04-30)
- [../lift-plans/post-scheduling-lift-plan-completion.md](../lift-plans/post-scheduling-lift-plan-completion.md)
  — scheduling a job whose lift plan is not finished
- `dispatch/` — what happens after the handoff

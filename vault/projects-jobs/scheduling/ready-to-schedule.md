---
title: Ready to Schedule — the gate before Dispatch is contacted
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Playbook_-_Ready_to_Schedule.docx · Value_Engine_-_Sales_Coordinator_Scheduling_Playbook.docx · The_Crane_Guys_Playbook_-_Scheduling_Sheet.docx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/dispatch, module/quotations, kind/sop, scheduling, permits, compliance, requirements]
entities: []
---

# Ready to Schedule — the gate before Dispatch is contacted

**What this is.** Three overlapping playbooks from TCG's "Value Engine" series that together define
**what must be true before a crane job may be handed to Dispatch**. `Ready to Schedule` is the
checklist; `Value Engine – Sales Coordinator Scheduling a Job with Dispatch` is the same checklist
inside an end-to-end narrative; `Scheduling Sheet` is the final quality-control document that
carries the job to Dispatch. All are owned by the **Sales Coordinator** role.

**The rule all three state:** the job **cannot** be scheduled until every required item has been
collected. Missing information, an unresolved permit issue, or a missing engineering document
requires the Sales Coordinator to **stop and obtain it before contacting Dispatch**.

## Trigger

A customer requests to schedule a crane job **by phone, email or text**.

## Roles

| Role | Primary responsibility |
| --- | --- |
| **Sales Coordinator** | Owns Ready to Schedule; validates all required information |
| **Dispatch** | Confirms scheduling feasibility; **approves Red Path requests** |
| **Project Engineering** | Provides lift plans, FAA/NOTAM support, technical guidance |
| **Accounting** | Supports billing for permit, lift plan and third-party costs |

## The Ready to Schedule checklist

Eight sections. The `Value Engine` version adds one section (**Fleet Flexibility**) the
`Ready to Schedule` version does not have; otherwise the two lists agree item for item.

**Customer** — new or existing · customer name · billing address · customer contact ·
**ordered by** · **purchase order received**

**Project** — project name · job-site address · **detailed scope of work** · job comments

**Compliance** — **Davis-Bacon / federally funded?** · **certified payroll required?**

**Crane** — lift weights · pick radius · set radius · hook height · setup distance ·
crane configuration · requested crane (number) · **two alternate crane options**

**Fleet flexibility** *(Value Engine version only)* — can another Crane Guys crane perform the
work? · can a third-party crane perform the work?

**Equipment** — rigging · trucking · additional equipment · **traffic control ordered**

**Permits** *(Value Engine version)* — FAA required? · NOTAM required? · **required permits
included before scheduling**

**Engineering** — FAA required · NOTAM required · **lift plan attached (billable)** ·
job layout attached

**Third parties** — companies identified · contacts · schedule confirmed · *(Value Engine adds)*
responsibilities

Two items are worth pulling out because they are commercial rules stated as checklist lines:
**"Lift Plan Attached (must be a billable line item)"** and **"two alternate crane options"** —
requesting only one crane is listed as a common mistake.

## Go / No-Go

**GO** — every checklist item complete and supporting documentation attached. Proceed to the
Scheduling Decision Path ([dispatch-scheduling-path.md](dispatch-scheduling-path.md)).

**NO-GO** — any missing information, unresolved permit issue, or missing engineering document.
Stop; obtain it; do not contact Dispatch.

## Then: the Scheduling Sheet

The Scheduling Sheet is described as "the **final quality control checkpoint** before a job is sent
to Dispatch". It is triggered *after* Ready to Schedule is complete. Standard rule: **every job must
have a completed Scheduling Sheet before it is submitted to Dispatch; incomplete sheets should not
be forwarded unless an approved exception process is being followed.**

Its 14 required, individually verified fields:

`Customer Name` · `Job Number / Quote Number` · `Project Name` · `Job Site Address` ·
`On-Site Contact` · `Requested Date & Time` · `Crane Requested` · `Scope of Work` ·
`Lift Plan Attached (if required)` · `Permit Status` · `Traffic Control Required` ·
`Rigging / Support Equipment` · `Special Instructions` · `PO Received (if required)`

The sheet is **emailed** to Dispatch with permits, lift plans and supporting documents attached.
Dispatch reviews on receipt, identifies missing information immediately, schedules once satisfied,
and notifies the Sales Coordinator of discrepancies.

The Sales Coordinator opens the Scheduling Sheet, **selects the requested crane and city, and the
sheet determines the permit path** — that is, the Scheduling Sheet is not only a checklist but the
instrument that computes Green / Yellow / Red. The workbook that does this is
[job-schedule-master-workbook.md](job-schedule-master-workbook.md).

## The end-to-end sequence

From the `Value Engine – Sales Coordinator Scheduling a Job with Dispatch` playbook:

1. **Verify customer information** — new or existing; for new customers verify name, billing
   address, contact information.
2. **Verify required scheduling information** — the checklist above. If anything is missing,
   keep collecting. **Do not schedule.**
3. **Ready to schedule** — open the Scheduling Sheet, select crane and city; the sheet determines
   the permit path (Green / Yellow / Red).
4. **Job scheduled** — send the customer a confirmation and **CC Dispatch**.
5. **Automatic reminder** — an Outlook auto-send **08:00 reminder the day before the job**; see
   [day-prior-confirmation-email.md](day-prior-confirmation-email.md).
6. **Dispatch ownership** — Dispatch assigns crane, crew and equipment, coordinates third parties,
   and issues job details.

## Exception playbooks named at the end of the Value Engine

1. **Dispatch cannot approve a Red Path** → return to Ready to Schedule.
2. **Customer changes the date** → Accounting bills permit, lift-plan and third-party costs; notify
   the customer; return to Ready to Schedule.
3. **Customer cancels during business hours** → bill applicable costs, notify the customer, notify
   Dispatch, cancel third parties, return to Ready to Schedule.
4. **Customer cancels after hours** → Dispatch removes the job and cancels third parties; the next
   business day the Sales Coordinator coordinates billing and customer communication, then returns
   to Ready to Schedule. Detail in
   [schedule-changes-and-after-hours.md](schedule-changes-and-after-hours.md).

## Quality standards and metrics

`Ready to Schedule` states: 100% checklist completion before scheduling · **zero dispatch callbacks
for missing information** · 100% permit compliance · customer documentation attached to the job
record. The Value Engine adds: 0 jobs scheduled without required documentation · 100% customer
confirmations sent · 100% reminder emails sent · reduced dispatch callbacks · **fewer emergency
permit requests** · consistent handoff to Dispatch.

Common mistakes listed: scheduling before receiving a required PO · missing lift plan or job layout ·
failing to identify Davis-Bacon or certified-payroll requirements · requesting only one crane ·
not confirming third-party schedules · submitting incomplete scheduling sheets · incorrect job
addresses or contacts · **assuming Dispatch already has required documents**.

## How this relates to what the vault already holds

`projects-jobs/project-module/03-create-manage-job-schedule.md` (migrated from Confluence,
2026-04-30) describes the **in-product** Job → Schedule tab: a dispatcher picks a start and end
date, chooses whether to include weekends, and the system generates a row per date. **These
playbooks describe the manual, pre-product process that feeds it** — the information-gathering gate
and the email handoff to Dispatch. They do not contradict each other; they describe different
stages. Neither source says whether the Ready to Schedule checklist is meant to become a gate in
the product, and **no source in this drop states that it should be.**

## Source

- `3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Playbook_-_Ready_to_Schedule.docx`
  — ~3.1 KB, `.docx` → pandoc GFM. Sections 1–9, no version number or date.
- `.../Value_Engine_-_Sales_Coordinator_Scheduling_Playbook.docx` — ~3.8 KB. The narrative version;
  adds the Fleet Flexibility section, the Red/Yellow/Green summary, and the four exception playbooks.
- `.../The_Crane_Guys_Playbook_-_Scheduling_Sheet.docx` — ~3.3 KB, marked **Version 1.0**.

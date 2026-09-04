---
title: Post-scheduling lift plan completion — the controlled exception
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Playbook_-_Post_Scheduling_Lift_Plan_Completion.docx
migrated: 2026-09-04
updated: 2026-07-01
status: unverified
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/dispatch, kind/sop, lift-plans, safety, scheduling, notifications]
entities: []
---

# Post-scheduling lift plan completion — the controlled exception

**What this is.** *THE CRANE GUYS — POST-SCHEDULING LIFT PLAN COMPLETION*, Version 1.0, July 2026,
process owner **Sales Coordination / Project Engineering**. It governs the case where a job **must
be scheduled before its lift plan is finished**. The document labels its own control level
"**Exception process — not the standard scheduling method**", and states the standard expectation up
front: *"A completed lift plan should be attached before a job is scheduled. This playbook applies
only when legitimate time constraints require a controlled exception."*

It is the lift-plan analogue of the Red Path in
[../scheduling/dispatch-scheduling-path.md](../scheduling/dispatch-scheduling-path.md): the job may
move, but only with a named owner, a written notice and a tracked commitment.

## Trigger and core rule

**Trigger:** a customer requests an accelerated schedule, the job cannot wait for the lift plan to
be completed, **and the remaining job information is sufficient to begin a documented exception
process**.

**Core rule:** *"Scheduling without a completed lift plan is an exception — not a shortcut. A job may
move forward only when the lift plan **has already been requested**, the responsible teams **are
notified**, and the missing plan is **actively tracked to completion**."*

## Roles

| Role | Owns | Required actions |
| --- | --- | --- |
| **Sales Coordinator** | The exception workflow | Confirm readiness · mark **Lift Plan Pending** · notify all parties · monitor completion · send the final plan to Dispatch · **confirm receipt** |
| **Project Engineering** | Technical completion | Acknowledge the request · complete the plan · **verify the selected crane and setup assumptions** · immediately communicate conflicts |
| **Dispatch** | Operational control | Flag the job as pending · **avoid treating the package as final** · confirm receipt of the completed plan |
| **Manager / Approver** | Exception oversight | Approve any exception presenting unusual risk, insufficient technical information, or a compressed completion window |

## The seven-step exception workflow

| # | Action | Standard |
| --- | --- | --- |
| 1 | **Confirm the exception** | Verify the time constraints are real and that **all other Ready to Schedule requirements are complete** |
| 2 | **Request the lift plan** | Submit to Project Engineering with drawings, weights, radii, heights, setup location, photos and customer requirements |
| 3 | **Obtain acknowledgment** | Project Engineering must acknowledge **and provide a target completion time** |
| 4 | **Notify Dispatch** | Email that the job is scheduled with the lift plan pending — job number, date, crane, project, expected completion time |
| 5 | **Mark the job clearly** | Use the status **`LIFT PLAN PENDING`** in the scheduling record and job file so the exception is visible |
| 6 | **Monitor to completion** | The Sales Coordinator owns follow-up until the final plan is received |
| 7 | **Send and confirm** | Send the completed plan to Dispatch immediately and **confirm the job package has been updated** |

## The go / no-go gate

**GO — may proceed:** lift plan request submitted · Project Engineering acknowledged · **Dispatch
notified in writing** · critical lift data available · responsible owner and target time identified ·
the exception is visible in the schedule.

**NO-GO — stop:** the lift plan has not been requested · critical weights, radii, heights or setup
data are missing · Project Engineering cannot validate assumptions · Dispatch has not been notified ·
safety or crane selection cannot be reasonably verified · no clear owner or completion commitment
exists.

> **Safety override:** *"Time pressure never replaces technical review. If the available information
> is not sufficient to evaluate the lift, stop the process and escalate."*

## What the pending notice must contain

Job number · customer and project name · jobsite address · scheduled date and expected start time ·
**requested crane number and backup crane options** · **reason the lift plan is pending** ·
assigned Project Engineering contact · **target lift plan completion time** · available drawings,
photos, layout and technical information · **the specific action required from Dispatch**.

The playbook supplies the full email template. Its subject line format is
**`LIFT PLAN PENDING – Job #[JOB NUMBER] – [CUSTOMER / PROJECT]`**, it is addressed to Dispatch **and**
Project Engineering together, it repeats the field list above as labelled lines, and it closes with:
*"Please flag this job as LIFT PLAN PENDING. The Sales Coordinator will send the completed plan
immediately upon receipt and confirm that the job package has been updated."*

## Escalation and exception rules

- **Crane selection changes** → immediately notify Dispatch, Project Engineering and the Sales
  Coordinator. **Do not rely on an earlier plan or assumption.**
- **Customer changes scope, weight, radius, height or setup** → treat as **new technical
  information**; Project Engineering must review it before the plan is considered final.
- **Plan will not be ready before mobilization** → escalate to management and Dispatch immediately.
  *"The job must not be treated as fully released merely because it appears on the schedule."*
- **A third-party crane is substituted** → confirm the lift plan is valid for the **actual** crane,
  configuration, capacities and setup. *"A plan for one crane should not be assumed valid for
  another."*
- **Dispatch cannot support the exception** → return the job to Ready to Schedule and resolve the
  timing, equipment or documentation issue first.

## Common mistakes and the audit

Scheduling without clearly marking the plan pending · sending a request to Project Engineering but
**not obtaining acknowledgment** · failing to give Dispatch an expected completion time · **assuming
the completed plan was received without confirmation** · not updating the plan after a crane, scope,
radius, weight or setup change · **allowing a pending exception to become the normal scheduling
process**.

Manager audit: was the exception necessary and documented · were all other Ready to Schedule
requirements complete · did Project Engineering acknowledge · was Dispatch notified in writing · was
the job marked LIFT PLAN PENDING · was the completed plan sent and **receipt confirmed** · were any
crane or scope changes **revalidated**.

**Success standard:** *"Dispatch is never surprised by a missing lift plan, every exception has a
named owner and completion commitment, and the final plan is delivered and confirmed before
mobilization whenever reasonably possible."*

## The quick-reference strip

| Before scheduling | At scheduling | While pending | At completion |
| --- | --- | --- | --- |
| Request submitted · PE acknowledged · critical data available | Mark **LIFT PLAN PENDING** · notify Dispatch · include target time | Sales Coordinator follows up · communicate changes immediately | Send final plan · update job package · **confirm Dispatch receipt** |

## What this implies for the product

`LIFT PLAN PENDING` is described as a **status in the scheduling record and the job file**, not a
comment — that is a state the job carries, distinct from the plan's own approval status in
`projects-jobs/project-module/04-create-and-approve-lift-plans.md`. That page's product model gives
the *plan* a status (Pending Approval / Approved / Customer Approved) but gives the *job* no
"scheduled without a plan" state. **The playbook does not say the product should carry that status**;
it says the scheduling record and job file must show it today.

The playbook also states, in its crane-change and third-party rules, that a lift plan is valid **for
one crane configuration only** — which is consistent with the existing vault page's requirement that
"each Lift Plan must be linked to a specific crane/resource so Dispatch knows which plan belongs to
which crane."

## Source

`3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Playbook_-_Post_Scheduling_Lift_Plan_Completion.docx`
— ~10.2 KB, 11 sections plus a revision-history table (Version 1.0, July 2026, "Initial
controlled-exception playbook", owner The Crane Guys). `.docx` → pandoc GFM; the callout boxes
rendered as single-cell HTML tables.

`.../The_Crane_Guys_Playbook_-_Post_Scheduling_Lift_Plan_Completion 1.docx` is the **same document**
— a machine diff shows only table-width and cell-alignment attributes differing, with **no textual
difference whatsoever**. It contributes nothing.

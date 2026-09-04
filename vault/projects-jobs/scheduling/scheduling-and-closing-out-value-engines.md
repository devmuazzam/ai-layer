---
title: The scheduling and closing-out flowcharts (Value Engine samples)
source: shared-folder/Project-Repository-2026-09-04/TCG_Value_Engine_SAMPLES-ONLY/2026-06-23 samples/Scheduling jobs.pdf and Closing out jobs revised 5-7-26.pdf
migrated: 2026-09-04
updated: 2026-05-07
status: unverified
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/dispatch, module/accounting, kind/source, scheduling, invoicing, permits]
entities: []
---

# The scheduling and closing-out flowcharts (Value Engine samples)

**What this is.** Two single-page process flowcharts from TCG's "Value Engine" set, delivered in a
folder the client labelled **SAMPLES-ONLY**. They are diagrams, not prose: the PDFs contain only the
box labels, and `pdftotext -layout` recovers the labels but **not the arrows**. What follows records
every label and the sequence the layout implies — **where a connection is ambiguous, this page says
so rather than guessing.**

Treat both as **indicative of the current manual process**, not as specification. The client marked
the folder samples-only, and `Closing out jobs` is stamped "revised 5-7-26".

## Scheduling jobs

Three intake channels feed one flow: **Email · Text · Call-Ins**, converging on **Schedule**.

**The crane-availability branch.** From availability the flow forks on a yes/no. Where the answer is
**NO**, it goes to *Workout Flexibility with Customer*; a second NO leads to **Sub Out (PLAYBOOK)**
→ *Find Crane Company* → *Send Job Detail* → *Confirm Job with Customer* → *Confirm details with
Crane company*. Where availability is **YES**, the flow continues into the date/permit lane.

**The permit lane.** *Date* → **Permits (PLAYBOOK)** → the chart splits into two labelled routes,
**Single Permits** and **Annuals**:

- **Single Permits** → *Confirm Permit Lead time* → *Order Permits* → *Permits Approved* →
  *Attached to Job/Permit Folder*.
- **Annuals** → *Confirm Job Date* → *Schedule Job*.

**The confirmation lane.** *Schedule Job* → **Confirmations (PLAYBOOK)** → *Customer confirms Job* →
on **Yes**: *Set Schedule / Assigned Equipment* → **Dispatch (PLAYBOOK)** → *Field Confirmations* →
**Job Complete**. On **No**: *Cancel Job* → *Rescheduled* → *Back To Availability*.

Four boxes are marked **PLAYBOOK**, meaning a separate document governs them: **Sub Out**,
**Permits**, **Confirmations**, **Dispatch**. The **Sub Out** playbook did arrive elsewhere in this
drop and is written up at
[`../../vendors-agencies/sub-out-crane-and-trucking.md`](../../vendors-agencies/sub-out-crane-and-trucking.md);
the Permits and Dispatch playbooks are covered by [../city-permits/INDEX.md](../city-permits/INDEX.md)
and the `dispatch/` module. **No Confirmations playbook arrived.**

**What this chart adds that the written scheduling playbooks do not:** it puts the **Sub Out**
branch on the main scheduling spine — when no TCG crane is available, the work is placed with a
third-party crane company, with its own job-detail send, customer confirmation and
confirm-back-to-the-crane-company step. The Ready to Schedule checklist's *Fleet Flexibility*
question ("can a third-party crane perform the work?") is the entry point; the procedure itself is
Dispatch's and is written up in `vendors-agencies/`. The chart also draws the **single-permit vs
annual** split as the first real decision after the date is set — matching the Job Schedule Master's
"annual active → 0 days" rule.

## Closing out jobs

**Entry:** *Job completed* → two parallel starts, *Send summary to TCG Billing* and
*Run job report from FCC (Playbook)*.

**The hours lane.** *Verify if all Hrs. are on report* → *Are all Hrs on report?* On **No**:
*Go to TCG HR & request, push through for payroll processor*. On **Yes**, continue.

**The parts/materials lane.** *Are all parts/materials added in report?* On **No**: *Request Parts
department to add parts/materials to FCC*. On **Yes**, continue.

**The additional-charges lane.** *Was there additional charges (Play Book)?* On **Yes**:
*Add to report*, then *Convert to a Invoice*.

**The invoicing lane.** *Was this a Quote or need to make invoice? Quickbooks (Play Book)* —
on **Yes**: *Print Quickbooks Invoice*; on **No**: *Make Invoice In Quickbooks*. Then
*Run cost break down (Play Book)* → *Give packet to TRG AP for entry into Excel* →
**Final invoice sent to Customer**.

Three more boxes are marked **Play Book** — *additional charges*, *Quickbooks*, *cost break down* —
and **none of those playbooks is in this drop**.

**Systems named:** **FCC** (the job report and the parts/materials record), **QuickBooks** (invoicing),
**TCG HR** (for missing hours, routed to a payroll processor), and **TRG AP** (accounts payable,
which enters the packet into Excel). "TRG" is spelled that way in the source and is not explained;
it may be a typo for TCG.

**Precise connections are uncertain.** The arrows did not survive conversion, and the four lanes
above are laid out side by side rather than in a single chain. The order given here follows the
page's left-to-right, top-to-bottom layout; **do not treat it as a verified sequence.** In
particular, whether *Convert to a Invoice* and *Make Invoice In Quickbooks* are the same step
reached two ways, or two different steps, cannot be determined from the text layer.

## How this relates to the rest of the module

- The **Permits** box is the whole of [../city-permits/](INDEX.md) — lead time, order, approve,
  attach to the job/permit folder.
- The **Dispatch** box hands off to
  `projects-jobs/project-module/03-create-manage-job-schedule.md` and the DAS in `dispatch/`.
- The **closing-out** chart is the only end-to-end description of job → invoice in this drop, and it
  is an accounting flow; the vault's `accounting/` module is the place any invoicing specification
  would belong. Nothing here states product intent.

## Source

- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-23 samples/Scheduling jobs.pdf` — 1 page, ~3.0 KB of text,
  `pdftotext -layout`. A flowchart; **only box labels survived conversion, not the connectors.**
- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-23 samples/Closing out jobs revised 5-7-26.pdf` — 1 page,
  ~4.7 KB, same conversion and the same limitation.

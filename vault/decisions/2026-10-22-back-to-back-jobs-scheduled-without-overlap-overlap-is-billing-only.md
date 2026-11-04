---
title: "Back-to-back jobs are scheduled without overlap: TCG sets the jobs' times so they do not overlap, DAS does not support intentional double booking, and the overlap is a billing matter (Melissa McNutt with Kyle Harlow, 2026-10-22) — decision"
source: decision/client recorded call (Melissa McNutt, President, with Kyle Harlow, VP of Fleet, ERP Demo Walkthrough Part 2, 2026-10-22)
decided: 2026-10-22
decided_by: >-
  Melissa McNutt (TCG, President), with Kyle Harlow (TCG, VP of Fleet), on the recorded 2026-10-22
  ERP Demo Walkthrough Part 2. Roles are from the unverified admin/engagement-directory-and-org-charts.md.
  Sources: meetings/2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md §5;
  transcript meetings/transcripts/2026-10-22-erp-demo-walkthrough-part-2.md, 37:00–41:34.
  Brian Petros (TCG) asked whether the ERP would allow double booking (37:00). ehtesham.anwar
  (CodingCops) said it does not (37:41). Melissa gave TCG's reason for doubling up small cranes (38:21).
  ehtesham.anwar then put the choice to TCG: "how would you guys like to handle this within the
  operational system?", and named what allowing double booking would cost (39:40). Melissa answered
  (40:03–40:23): set the jobs' start and end times so they do not overlap, and bill the customer from
  the ticket times. Kyle agreed (40:36–40:47): "they won't be actually double booked on the schedule,
  right? … that's something that has to be done on the billing side". Both answers are hedged ("I
  think", "right?"). ehtesham.anwar left the billing calculation to "dive deeper into" (40:31,
  41:14). Only the scheduling half is recorded as decided. Not confirmed in writing. Recorded by
  tcg-scrum on 2026-10-23 at the request of syed.haris (CodingCops).
status: verified
conflicts_with: []
resolves: []
related_decisions:
  - 2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md
  - 2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md
jira: []
tags: [module/dispatch, module/accounting, kind/decision, scheduling, daily-allocation, das, invoicing]
---

# Back-to-back jobs are scheduled without overlap; the overlap is billing-only

## Decision

Melissa McNutt, with Kyle Harlow, 2026-10-22: **when TCG doubles up a crane on back-to-back jobs,
the jobs are scheduled so that they do not overlap.** Dispatch sets the first job's end time and the
second job's start time so that the times do not overlap. The schedule and DAS show where the crew and
crane actually are. The ERP does not need to support intentional double booking. Any overlap belongs
on the **billing** side only.

This decision covers scheduling only. What the second job's invoice bills is not decided (see *What
was not decided*).

## The exchange — verbatim

Source: [../meetings/transcripts/2026-10-22-erp-demo-walkthrough-part-2.md](../meetings/transcripts/2026-10-22-erp-demo-walkthrough-part-2.md).

> **Brian Petros (37:00, 37:41):** *"… some of the vehicles are double booked or even triple booked. …
> I was just curious like if the new system will allow double booking or how maybe there's a
> operational … reason that we would kind of want to do that for like tentative jobs and how it would
> display on the screen."*
>
> **ehtesham.anwar (37:41):** *"Yeah, so we are not allowing double booking. … our allocations are time
> based. For example, a person can be booked on three different jobs, but they cannot overlap."*
>
> **Melissa McNutt (38:21):** *"Yeah, for the time, if we're doubling up because it's portal to portal.
> … the ticket time goes from the yard to the job. … So like for the 22 tons, they have three hour
> minimums. but we have to pay the guys 4 hours. So that's just one scenario where it helps make up
> some of that charge that we lose is just to double up the job, especially for the smaller cranes. …
> So they look like they're in the same place at the same time, but they're not."*
>
> **Kyle Harlow (38:57):** *"… that would be a thing on the billing side … They don't get the double
> book, right? Only we do for billing purposes. … But the employee is only paid what they do, right? …
> they never will be in two places or on two jobs at the same time. … It's in the contract that they
> cannot do that."*
>
> **ehtesham.anwar (39:40):** *"So how would you guys like to handle this within the operational
> system? Because... If we allow the double booking within the system, then it's going to create all
> kinds of mess. … we won't be able to identify if it is an intentional double booking or it's an error
> or a problem."*
>
> **Melissa McNutt (40:03):** *"I think if we have start times, like if start if job one is at like 8
> A.m. and start and job 2 is at 930, they would just have to adjust the end times on the on this time,
> but the customer will be billed off the ticket time. So I think we'll just have to do our start end
> times where they will allow it to double book without really double booking it."*
>
> **Melissa McNutt (40:23):** *"and then the ticket times will be the actual times. Because just because
> the job says start time, our travel time is always going to be different."*
>
> **ehtesham.anwar (40:31):** *"All right, seems like another thing that we need to dive deeper into."*
>
> **Kyle Harlow (40:36, 40:47):** *"Yeah, it's something they're gonna have to look into. I think, I
> think scheduling wise, it it won't Matt, they won't be actually double booked on the schedule, right?
> Um, but... when they happen, there will be overlapping time for billing, but there's not actually
> overlapping time for the people and what's actually happening. So I think that's something that has
> to be done on the billing side of how it bills that customer versus what's actually happening in live
> data."*
>
> **ehtesham.anwar (40:55):** *"Yes, absolutely."*

("it won't Matt" is left as transcribed, probably *"it won't matter"*.)

## Why

- **The crew is never in two places.** Kyle: the employee is paid only for time worked, and the
  contract forbids working two jobs at once (38:57). A schedule that showed an overlap would be false
  for the people on it.
- **The overlap only exists on the invoice.** Doubling up recovers the gap between a small crane's
  billing minimum (3 hours for a 22-ton) and the crew's 4-hour pay (38:21). That gap belongs on the
  customer's bill, not in the live schedule (Kyle, 40:47).
- **An allowed overlap cannot be told apart from a mistake.** ehtesham.anwar gave this reason
  (39:40), and Melissa's answer avoids the problem.

## What was not decided

- **What the second job's invoice bills.** Melissa said the customer is billed *"off the ticket
  time"* (40:03). At 38:21 she said billing is portal to portal from the yard, and that the ticket time
  *"goes from the yard to the job"*, not from job one to job two. Whether the second job's ticket or
  invoice starts at the yard or at the end of job one was not settled. ehtesham.anwar left the
  calculation to *"dive deeper into"* (40:31, 41:14). This is (a) and (c) of the accounting gap below.
- **Whether each job bills its full minimum.** Kyle said *"billing is going to get a three hour
  minimum for every single one"* (38:57) while describing current practice. Nobody asked TCG to choose
  on this point, so it is not recorded as decided here. This is (b) of the gap.
- **Warn or block.** This note says how TCG will schedule. It does not say whether DAS should refuse
  an overlapping drop or only warn about it. That stays with *Allocating by shift time (TCG-186)*,
  part (h), in [../dispatch/gaps.md](../dispatch/gaps.md), against the `unverified` specs cited in
  [2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md](2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md).
- **Tentative jobs.** Brian asked about double booking for *"tentative jobs"* (37:41). Nobody answered
  that part.
- **Which window counts as an overlap.** Start → Estimated End, and whether the drive back counts,
  stays with TCG-186 (a).

## Conflicts and interactions

- **No decision-note conflict.** No earlier decision note covers intentional double booking.
- **Narrows TCG's earlier ask.** [../meetings/2026-08-12-sell-side-workflow-and-scheduling.md](../meetings/2026-08-12-sell-side-workflow-and-scheduling.md)
  (`unverified`) asked the ERP to *"support double booking when short jobs allow the same crane to
  perform multiple jobs in one day"*. Under this note, that need is met by scheduling the jobs without
  overlap. It does not need an overlapping booking in DAS.
- **Agrees with the built rule and one side of the DAS conflict.** The no-overlap allocation (TCG-186,
  `@tcg/shared` `shiftWindowsOverlap`) agrees. So does
  [../dispatch/daily-allocation-system.md](../dispatch/daily-allocation-system.md):48 (`unverified`):
  *"the same asset can be assigned to two non-overlapping jobs on the same day"*. That file is one side
  of the open conflict in [../dispatch/daily-allocation-INDEX.md](../dispatch/daily-allocation-INDEX.md).
  This note settles a single point and does not adjudicate that conflict.
- **Consistent with invoicing from tickets.**
  [2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md](2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md)
  (`verified`) builds invoices from a job day's tickets. Melissa's *"billed off the ticket time"*
  agrees with it. It is not a separate decision here.
- **Not a pay rule (G4).** The crew is paid for time worked (Kyle, 38:57), and this note changes
  nothing in payroll. Their 4-hour minimum is PAY-040 in
  [../payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md).

## Effect on the vault

- No status flips. No file wins or is superseded, and no `conflicts_with` changes. The DAS conflict
  stub stays as it is.
- No register entry was closed. In [../accounting/gaps.md](../accounting/gaps.md) → *Back-to-back
  jobs billed portal to portal — billed time overlaps, crew time must not*, (d) is answered for the
  schedule only, and (a)–(c) stay open. The entry stays open. An *Update 2026-10-23* line was added
  there.
- Done in this pass: a row for this note in the decisions table of [../INDEX.md](../INDEX.md), and
  the *Candidates for a decision note* section of the 2026-10-22 curated notes updated to point here.
- Not edited: the pointer update on [../dispatch/gaps.md](../dispatch/gaps.md) → *Allocating by shift
  time (TCG-186)*.

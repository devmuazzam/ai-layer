---
title: "Paid time runs yard to yard — dispatch start time to crane parked, rounded up to 30 minutes — decision"
source: decision/client recorded call (Kyle Harlow and Joe Schacatano, 2026-09-03 payroll call) + transcript
decided: 2026-09-03
decided_by: Kyle Harlow (TCG **VP of Fleet** — the call's field/operations authority, [../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md)) at 47:15–47:57, 49:36, 50:33 and 53:54, and Joe Schacatano (TCG **VP of Operations**, speaking for dispatch) at 48:00–48:24, 49:57 and 52:02–52:28. Corrina Bustos (Payroll Manager; the engagement directory lists her as HR Manager) concurring at 47:10, 48:23 and 54:21. Confirmed against the built schedule configuration on screen (Ehtesham Anwar, 49:12).
status: verified
provenance_note: >-
  2026-10-07: PROVISIONAL TENSION, not an overrule. Melissa McNutt (TCG President), in written Teams
  answers posted on or before 2026-10-06, said a holdover crew on days 2+ reports straight to the job
  site and their time starts when they "arrive at the job site". The question asked about "billable"
  time, so it may mean customer billing rather than pay. TCG then asked CodingCops to hold those
  answers until an updated version is sent. This note has no holdover exception. Recorded in
  decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md
  (status: reference, T4) and open in payroll/gaps.md under "Holdover days 2+". This note still
  governs. Body unchanged.
resolves: [PAY-017, PAY-021, PAY-043, PAY-044, dispatch/gaps.md#schedule-fields--the-build-already-agrees-and-the-new-fields-are-written-nowhere]
tags: [module/payroll, module/dispatch, module/field-ops, kind/decision, time-tracking, scheduling, boom, payroll-rules]
---

# Decision

**Paid time starts at the dispatch start time at the yard and ends when the crane is back in the
yard, fuelled, parked and the paperwork is done — then rounds up to the next 30 minutes.**

## Start — the dispatch start time, not the moment the crane rolls

Kyle Harlow, **47:15–47:48**:

> Actually, it starts, it's. The days when they actually start their work is when they… get paid
> from, right? So…
> they don't even leave the yard. So a lot of times they won't leave the yard for 15 to 20, maybe
> even 30 minutes after they've already been getting paid. So they have a start time that is given by
> dispatch and they have a leave time that is also given by dispatch. That's usually the same thing,
> but we all know that they are supposed to do their pre-trip and I would say
> On average, it's between 15 and 30 minutes they're leaving the yard within that time period.

Asked whether that pre-departure window is paid, Kyle at **47:57**:

> They're paid the whole entire time, yes.

Joe Schacatano, **48:00–48:24**:

> So, so. Their time should start, like, let's say a job is dispatched, right? It's going to have a
> start time of 6 A.m., which is their technically their leave time, right? That's when they're
> reporting to the yard. They'll facilitate the inspection that Kyle's talking to, but that time
> that's inputted into the system on their dispatch should be…
> Exactly when their time starts.
> Not before it, not after it, right at that time. So if it's 6 A.m. start, that means they're
> reporting the yard, they're reporting to do their pre-trip inspections, do whatever they need to
> do. They're actually vacating the yard within 15, 20 minutes, and they're on their way to the job.

So the dispatch start time is a **single** value that is simultaneously the report-to-yard time
and the start of paid time. The physical departure is 15–30 minutes later and is **not** a
separate payable boundary.

## The field is called "start time", not "leave yard time"

The schedule was on screen. Ehtesham Anwar, **49:12**:

> So we are treating it as leave yard time, onsite time and estimated end time. So, our page starts
> from leave your time. and this configuration of Schedule. I just wanted to confirm this. Is it
> right?

Kyle Harlow, **49:36–49:48**:

> Yes.
> Did you leave yard is going to be your start time also?
> But physically, the machine's not going to leave at that exact time. It's going to leave after that
> time.

Joe Schacatano, **49:57**:

> I would just have it be start time, not leave yard time. Just, it's start time.

**Rename the field.** "Leave yard time" is factually wrong — the crane has not left — and the label
is the whole reason the question was asked.

## The three schedule fields, confirmed as built

Ehtesham Anwar, **50:03**: *"Okay, it's start time, on-site time and end time."* Joe Schacatano,
**50:17**: *"Yeah, I think that that's all you need for Dispatch."* (Kyle at **50:12**: *"No, this
is for Dispatch"* — these are dispatch fields, not payroll fields.)

On what "end time" means, Joe at **52:02–52:28**, after Ehtesham confirmed the built field records
leaving the job site, not returning to the yard:

> So then I would put leave job time.
> Okay, so yeah, so estimated job end time would be okay. All right, that's why I asked. I thought
> you were talking about when they would leave the job, not when they got back to the yard.
> Perfect. Okay, so estimated job end time. Gotcha.

**Confirmed set:** `start time` (at the yard) · `on-site time` · `estimated job end time` (= leave
job time). No change to the built configuration beyond the rename.

## End — back at the yard, everything done

Kyle Harlow, **50:33**:

> Back to the yard, fuel the crane, any supplies or anything necessary, all paperwork, crane parked
> in its spot and leaving the yard. All those things had to be done, and then they rounded up from
> there to the nearest 30 minutes.

Restated and confirmed — Ehtesham Anwar at **53:30**, Kyle Harlow at **53:54**:

> Okay, all right. Kyle, a clarification. Their job, the paid job time starts whenever they arrive at
> the yard and then whenever they leave with all of the paperwork done and leave the equipment back
> at the yard. That's where their pay paid hours are done, right?
> Yes.

**The return leg is paid time, and so is the post-trip work at the yard.** Paid span is yard to
yard, not yard to job to job-exit.

## Rounding — up, to the next 30 minutes

Kyle Harlow, **54:01**: *"In A 30 minute, in a 30 minute increment."* Then Ehtesham Anwar at
**54:13**, Corrina Bustos at **54:21**, Kyle Harlow at **54:22**:

> over the ceiling. For example, if it's 12 or 5, it's going to be considered 1230, right?
> Correct.
> Yes.
> Yep. Even if it's 1231, it would be considered one.

(12:05 → 12:30; 12:31 → 13:00. "12 or 5" is the ASR rendering of *12:05*.)

**This is not a new rule.** It is the end-side half of the already-decided rounding method:
[`decisions/2026-08-24-payroll-time-rounding-method.md`](2026-08-24-payroll-time-rounding-method.md)
— start times round **down**, end times round **up**, 30-minute increments, all employees union and
non-union, implemented that way in the as-built engine (`usp_Prepare_Continuous_Labor`). What the
2026-09-03 call adds is **which event** the end-rounding applies to: crane parked at the yard, not
job exit. Nothing about the method changed; do not treat this as a second, competing rounding rule.

# Boom window — build-up through breakdown, hook work included

Recorded here because it was decided in the same passage and bounds the same day.

Kyle Harlow, **44:34–45:15**, on when a crane is *not* built up on arrival:

> I guess actually that's wrong. If it's a crane's already been built up, right, and we're showing up
> and the crane's already ready to go, you can go straight to work.
> That would be a holdover, or it would be a tower crane job, or it would be a… Yeah, any job that
> you're just reporting to a job site and the machine's already ready to go to work.

Asked whether a tower crane job is therefore always a holdover, Kyle at **45:15**: *"Yes."*

Corrina Bustos, **45:32**, on current practice:

> So the currently we pay the boom pay build up through breakdown, including the hook work.

Kyle Harlow, **45:31–45:59**:

> No.
> Yeah, breakdown.
> All hook work. So building the machine up and hook work is a boom time. So build up and break down.
> The only time you're not paid is travel. And like if you meet with the customer, say you job, a lot
> of times the guys will go to the job site, they will go meet with the customer, say they walk the
> job if the job doesn't have a plan.
> and they figure out how they're going to do their work. And then once they set the machine in place
> and start working, that's their, that is their boom time.

**Boom window = first moment of build-up → last moment of breakdown, all hook work inside.**
Excluded: travel (yard→site and site→home, confirmed at **46:02–46:20**), and meeting the customer
or walking the job before the machine is set. Note the asymmetry that makes this worth writing
down: **that excluded time is still paid time** — it is inside the yard-to-yard span above. Boom
pay is a premium window inside the paid day, not the paid day.

# Open item, not a decision

Joe Schacatano, **53:03**, asked for a fourth schedule field:

> I think an estimated yard arrival time would be good. And if it could populate it or predict it
> based on the time it actually took to get to the job, that would be ideal because then we would
> know they're done at their job. This is an estimated time they're going to arrive. So we have an
> idea of when their hours are going to end.

and at **53:23**: *"so that that way we know how that may affect the next hours of service, whether
that's that evening or the next day."*

**This is an ask, not a decision.** Nobody committed to building it and no field was agreed. It is
registered against
[`dispatch/gaps.md#schedule-fields--the-build-already-agrees-and-the-new-fields-are-written-nowhere`](../dispatch/gaps.md#schedule-fields--the-build-already-agrees-and-the-new-fields-are-written-nowhere).

# Effect on the vault

Register edits were made by the calling agent on 2026-09-07, in the same pass. Nothing here is a
handoff.

- [`payroll/rules/PAY-017-time-source-selection.md`](../payroll/rules/PAY-017-time-source-selection.md)
  — **partially resolved.** The paid span a reconstructed time must cover is now fixed at yard to
  yard; source *priority* between labor entry, ticket and schedule is still open.
- [`payroll/rules/PAY-021-l12-standard-work-window.md`](../payroll/rules/PAY-021-l12-standard-work-window.md)
  — **partially resolved.** The window's start and end events are fixed; the rule's other open items
  stand.
- [`payroll/rules/PAY-043-long-boom-premium.md`](../payroll/rules/PAY-043-long-boom-premium.md) and
  [`PAY-044-lattice-boom-premium.md`](../payroll/rules/PAY-044-lattice-boom-premium.md) —
  **partially resolved.** The premium *window* (build-up→breakdown incl. hook work, excl. travel and
  pre-set walkthrough) is confirmed as current practice by both the field and payroll. Eligibility,
  rate and the boom-length/group thresholds are untouched.
- [`dispatch/gaps.md#schedule-fields--the-build-already-agrees-and-the-new-fields-are-written-nowhere`](../dispatch/gaps.md#schedule-fields--the-build-already-agrees-and-the-new-fields-are-written-nowhere)
  — **partially resolved.** The three time fields are confirmed and one is renamed; the estimated
  yard-arrival field is added as an open ask. The entry's other subjects (job status enum, sales
  coordinator, scheduled hours) are untouched and it stays `open`.
- Related and unchanged:
  [`decisions/2026-08-24-payroll-time-rounding-method.md`](2026-08-24-payroll-time-rounding-method.md)
  (rounding method), and the multi-job boom bucketing recorded the next day in
  [`payroll/client-message-findings.md`](../payroll/client-message-findings.md).
- Curated meeting notes:
  [`meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md`](../meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md) §§2–3.
- **No vault file body was edited by this note, and no frontmatter was flipped by it.**

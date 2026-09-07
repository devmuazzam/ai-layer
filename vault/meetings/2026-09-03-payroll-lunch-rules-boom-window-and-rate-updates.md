---
title: Payroll call — lunch rules and "paid straight through", paid-time boundaries, boom window, bulk rate updates (3 September 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-09-03_Payroll - transcript.docx"
migrated: 2026-09-07
updated: 2026-09-03
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, module/field-ops, module/dispatch, kind/meeting-notes, wtl, time-tracking, boom, craft-code, scheduling, yards, compliance]
entities: []
meeting_date: 2026-09-03
---

# Payroll call — lunch rules, paid-time boundaries, boom window, bulk rate updates — 3 September 2026

Curated from [transcripts/2026-09-03-payroll-lunch-rules-and-dispatch-times.md](transcripts/2026-09-03-payroll-lunch-rules-and-dispatch-times.md)
(1 h 1 m). Present: Brian Petros, Corrina Bustos, Micaela Dipane, Wes Staley, Melissa McNutt,
Kyle Harlow (from ~30:24), Joe Schacatano, ehtesham.anwar, syed.haris, abdulrehman, Patrick (IT).
Ehtesham framed it as *"a generalized call to just clear out some concepts"*, starting from Brian's
Teams message about the lunch-rule update.

> **Forward-looking.** Statements below are what named people said on the call. Decisions that bind
> are recorded as decision notes in `decisions/` (linked); everything else is registered as a gap or
> a rule bullet and says where.

## 1. Lunches — the new tokens, and "paid straight through" (2:52 – 43:30)

**What TCG does today (Brian, Corrina).** The legacy app counted only *worked-through* lunches;
Brian inferred lunches taken from the allowed count (one per five consecutive hours). The payroll
department now needs both: a token for a lunch **taken** and a token for a lunch **worked through**;
**no token means nothing is added or deducted**. Corrina: with no token the old process *"was
automatically just assuming that they took a lunch, so it was taking it out when it shouldn't."*

**"Paid straight through" (PST).** The employee marks every lunch as taken but records no times,
no customer signature is obtained, no WTL penalty is applied, and they are paid start to end.
Corrina: the employee chooses it, **day by day**; internally called PST, *"we can't have that on
there because it could be flagged… it's kind of like finding the loophole in the union system."*
Kyle: crews *"almost never"* take lunch — they arrive during the meal window and are building up;
customers will not stop the job; *"they're being overpaid… that box is what we need."*

**The ruling.** Wes Staley (13:54): *"I don't think that we can put this in our system. It's
illegal… whether we say it in different verbiage or not… this system will lock us in to lie."*
Ehtesham (37:11, 38:29): *"we cannot put this in ERP… we shouldn't create a trail that can be
audited… if we put this within the system that we are building for ourselves, that means we are
enabling each other to not follow the rules."* Melissa asked that no field-workflow decision be
made without Kyle; Kyle agreed the wider conversation belongs off this call. Brian: the union rule
is that a worked-through 30 minutes is **double time (triple on a holiday)**, so paying "straight
through" at the running rate is not the same as applying the rule; he has **sent questions to the
union**. Wes: **California law supersedes the union**, so the labor-law attorney must weigh in too.
→ **Decision note:** [../decisions/2026-09-03-paid-straight-through-not-in-erp.md](../decisions/2026-09-03-paid-straight-through-not-in-erp.md).

**What the ERP keeps doing.** Ehtesham: the mobile flow already shows each lunch the employee is
entitled to and when, and offers *take it* or *work through with the customer's WTL penalty*. Brian
(24:32, 40:38): the step-by-step prompt at each five-hour interval is *"essential"* — the
load-bearing data is **when** the lunch was taken or worked through, because the half-hour may fall
in ST, OT, DT or a holiday and *"how it's handled is actually quite different"*. Corrina: only
~20 % of crews consistently mark lunches, and many complete tickets after the fact, so timestamps
need coaching to be real. Melissa's compliance-page idea (lunch box auto-stamps 30 minutes) was
answered by Wes with the audit argument. **Self-signing a WTL** is allowed only with a stated
reason — customer not on site, or driving during the meal window (Corrina 12:59); never simply
skipped.

## 2. Boom window and holdovers (43:30 – 46:28) — Kyle Harlow

- Every crane is built up on arrival **unless it is already built** — a **holdover**, or a **tower
  crane job (always a holdover)**.
- **Boom pay runs from build-up through breakdown, including all hook work.** Not boom time: travel,
  and meeting the customer / walking the job before the machine is set. Corrina confirms this is
  current practice.

## 3. Paid time — where it starts and ends, and rounding (46:28 – 54:29)

- **Start:** the dispatch **start time**, at the yard — pre-trip inspection is paid; the crane
  physically leaves 15–30 minutes later (Kyle, Joe). Joe: the field should be called *start time*,
  not *leave yard time*; the ERP's schedule config (start · on-site · estimated job end) is right.
- **End:** back at the yard, crane fuelled and parked, paperwork done — **then rounded up to the
  nearest 30 minutes** (12:05 → 12:30; *"even if it's 12:31, it would be considered one"*).
  Consistent with [../decisions/2026-08-24-payroll-time-rounding-method.md](../decisions/2026-08-24-payroll-time-rounding-method.md).
- Joe's ask: an **estimated yard-arrival time** on the schedule, ideally predicted from the actual
  travel time, so hours of service for the evening / next day are visible.
→ **Decision note:** [../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md);
dispatch ask → [../dispatch/gaps.md](../dispatch/gaps.md) → *Schedule fields*.

## 4. Bulk craft-rate update (54:51 – 58:40)

Corrina, asked whether a rule exists behind bulk updates: *"Yes, because all of the groups, so
groups one through nine, they always increase in the same dollar amount."* Ehtesham demoed the
accounting bulk-rate updater (add an amount to every selected row) and committed to the same for
craft-code rates. Brian: rates must be set **in advance** with an effective date; Ehtesham: the
update takes the new effective date and the previous rates are auto-ended the day before.
→ **Decision note:** [../decisions/2026-09-03-l12-bulk-rate-update-uniform-delta.md](../decisions/2026-09-03-l12-bulk-rate-update-uniform-delta.md);
closes [../payroll/gaps.md](../payroll/gaps.md) → *Annual craft-rate change*.

## 5. Boom pay across a multi-job day (59:07) — Corrina

The bucket a boom hour falls into (ST/OT/DT) must be decided against **the whole day's work**, not
the boom job alone — e.g. four hours without boom then ten with. She will send examples — these
are the breakdowns logged the next day in
[../payroll/client-message-findings.md](../payroll/client-message-findings.md#2026-09-04--long-boom-day-breakdowns-drive-time-included-corrina-bustos-teams).
Ehtesham: the engine's chain semantics already price boom slices in the day's cumulative buckets.

## Also

Patrick (IT) confirmed Micaela's remote SQL connection needs no second encryption layer over the
tunnel (1:40) — legacy-app access for the payroll team, not an ERP item.

## Action items

| Who | What |
| --- | --- |
| Brian Petros | Union questions on meal-period handling — responses pending |
| Wes Staley | Labor-law attorney on meal periods vs California law; convene "everybody in the same room" |
| Melissa McNutt / Kyle Harlow | Field-side lunch practice — decide off-call, with Kyle |
| Corrina Bustos | Send multi-job boom-pay breakdowns (done 2026-09-04) |
| CodingCops | Bulk craft-rate update with future effective date; consider estimated yard-arrival time on the schedule |

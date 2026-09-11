---
title: Payroll call — ST/OT/DT bucket rules, the rest chain, holiday minimums, work orders, paper tickets (10 September 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-09-10_Mostly Payroll - transcript.docx"
migrated: 2026-09-11
updated: 2026-09-10
status: unverified
conflicts_with: [decisions/2026-08-25-boom-adder-on-top-unmultiplied.md]
jira: []
tags: [module/payroll, module/field-ops, module/dispatch, kind/meeting-notes, time-tracking, overtime, holidays, boom, rest-period, craft-code, work-orders, paper-tickets, offline, timezone, non-union]
entities: []
meeting_date: 2026-09-10
---

# Payroll call — rate buckets, rest chain, holiday minimums, work orders, paper tickets — 10 September 2026

Curated from [transcripts/2026-09-10-payroll-rate-buckets-work-orders-paper-tickets.md](transcripts/2026-09-10-payroll-rate-buckets-work-orders-paper-tickets.md)
(1 h 2 m 17 s). Present: Brian Petros, **Corrina Bustos** (TCG Payroll Manager, joins 13:57),
Kyle Harlow, Micaela Dipane, ehtesham.anwar, abdulrehman.

> **Forward-looking.** Statements below are what named people said on the call. Decisions that bind
> are recorded as decision notes in `decisions/` (linked); everything else is registered as a gap or
> a rule bullet and says where.

> **What this call was *not* about.** Brian sent three payroll topics ahead of it — the `#1`
> lunch/break scenarios workbook, anniversary checks, and the special-earnings generalization.
> **None of the three was discussed.** The words *lunch*, *meal*, *WTL*, *anniversary*, *commission*
> and *bonus* do not appear in the transcript at all. Only **paper tickets** — the fourth topic —
> was reached, at 52:11.

## 1. Rate buckets: how ST / OT / DT are assigned (7:16 – 31:00)

Worked live against two examples on Abdul Rehman's screen, then re-derived by Corrina.

**The rule as the call settled it, for a weekday, non-holiday, L12:**

| Shift start | ST | OT | DT |
| --- | --- | --- | --- |
| **After 06:00** | first 8 h | after 8 h ST | after 12 h total |
| **Before 06:00 but after midnight** | 8 h **starting at 06:00** — the pre-06:00 hours do **not** consume the ST bank | the pre-06:00 hours, then again after the ST bank | after 12 h total |
| **Before midnight (previous calendar day)** | **none — the 06:00 rule is "a wash"** | **first 12 h** | after 12 h total |

- **Brian (8:18, 8:42):** *"They need to work a full 8 hours of standard time before they qualify
  for the overtime… the accrual of the hours for standard time starts at actually 6 A.M."*
- **Kyle (9:04):** *"It doesn't follow the standard rules of California law because we work under an
  operating agreement… it falls under the Local 12's labor laws."*
- **Worked example A — 04:00 to 23:30 (19.5 h), weekday.** 04:00–06:00 = **2 OT**; 06:00–14:00 =
  **8 ST**; 14:00–16:00 = **2 OT**; 16:00–23:30 = **DT** (the 12-hour mark falls at 16:00).
  Confirmed line by line by Corrina at 24:14–24:49.
- **Worked example B — 22:00 to 14:00 next day (16 h).** Abdul and Brian first modelled it as
  8 OT + 4 ST + 4 DT. **Corrina overruled that** (15:18): *"it would be 12 hours of overtime and
  four hours of double time because they are starting on overtime before midnight… they have to hit
  12 hours of overtime before they can get double time."* At 16:33: *"if they start on overtime
  before midnight, they have to work 12 hours of OT and then everything else is doubled. **They
  don't, it doesn't start over at 6 A.M.**"* At 17:22: *"That 6 A.M. rule is a wash and the 12 hours
  of overtime rule hits."* Kyle (16:13) accepted the correction: *"that's the rule that I missed and
  I apologize."* Brian (16:30): *"Oh, I forgot about that."*
- **Worked example C — midnight to 14:00 (14 h).** Corrina (20:40, 21:02): 00:00–06:00 = **6 OT**;
  06:00–12:00 = **6 ST** — *"because they can still only work, they still, after 12 hours, have to
  hit double time"*; 12:00–14:00 = **2 DT**. **Note the ST bank is cut to 6, not 8** — the 12-hour
  DT cap binds first. So the "8 hours of ST" is a ceiling, not a guarantee.
- **Nothing above DT except a holiday.** Corrina (30:44): *"The only time it would ever convert is
  if they worked into a holiday."*

## 2. ⚠️ Boom / craft adders — Brian stated the OPPOSITE of the working decision, and of his own spreadsheet (18:07 – 23:23)

Brian Petros, **21:48–22:09**, explaining *no pyramiding*:

> whatever we determine as the multiplier for that slice of time, for each 30 minute slice of time,
> there's only one multiplier being applied… with respect to long boom… I'm just determining what
> long boom applies for that 30 minute slice and then the multiplier that's applied at the end gets
> applied to the long boom… **the long boom is just an addition to the base rate, like the lattice
> pay or the foreman pay or the military base pay, it gets added to the base rate, and then at the
> end, the multiplier that's applied gets applied to the whole thing.**

Ehtesham had already put the same shape to Corrina at 18:43 — *"12 OT long boom and 4 DT long
boom, right?"* — and she answered **"Correct."** (18:49, 19:14).

**This is the into-the-rate reading.** It contradicts, in three directions at once:

1. [../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md](../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md) — the working decision
   `SCRUM-926` was built on: the adder is *"a flat dollars-per-hour figure × boom hours… **not
   multiplied** by OT / DT / holiday multipliers… **not folded into the base rate** for computing
   overtime."* That note is `status: reference`, was decided by **Syed Haris (CodingCops acting
   product owner)** and not by TCG, and **states on its face that TCG payroll must confirm it.**
   This call is that confirmation arriving — and it lands the other way.
2. **Brian's own scenario workbook**, sent the same day: the grid prices an OT-with-boom half-hour
   at **$62.00** = $60.00 OT base + $2.00 flat boom. Into-the-rate would be ($40 + $2) × 1.5 =
   **$63.00**. See [../payroll/lunch-break-scenarios-2026-09-11.md](../payroll/lunch-break-scenarios-2026-09-11.md).
3. **The MLA's literal clause** —
   [../payroll/mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md](../payroll/mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md):
   *"The additional rate added to the regular rate shall be the base rate when computing overtime
   pay."* — which **agrees with what Brian said on this call** and disagrees with the working
   decision, exactly as that note warned.

**Not resolved here, and not resolvable by this note.** Registered in
[../payroll/gaps.md](../payroll/gaps.md) → *Boom adder — into the rate or on top*. Getting it wrong
underpays overtime on every long-boom hour.

## 3. The rest chain — under 8 hours off (24:52 – 30:14)

Corrina, with Brian and Ehtesham working it through:

- **The current shift starts in the bucket the previous shift ended in**, and fills to the 12-hour
  mark before double time. Corrina (25:21): *"if the day before they were already… ended on double
  time, this entire job would be double time."* (27:26): previous day 10 h → ended on OT → *"the
  first two hours of the next day's job would be overtime… because it fills up the 12-hour bucket
  and then everything else would be doubled."* (28:12): previous day 6 h → ended on ST → *"it would
  fill up the straight time until the 8 hours… and then it would go into four hours of overtime."*
- **The 06:00 rule still outranks it.** Corrina (29:20): a 04:00 start after a short rest *"started
  that, that's in the overtime spot. So they would start on overtime and fill up until the 12 hours
  is full."* The pre-06:00 bucket wins over the carried-forward ST.
- **The length of the short rest is irrelevant.** Ehtesham (28:43): *"doesn't matter if they got 7,
  6, 4, three, two, one… the exact rest time does not matter, right?"* Corrina: **"Correct,
  correct."** Only the binary *did they get 8* matters.
- **Depth of the chain — the two sides said different things and nobody reconciled it.** Brian
  (25:45, 26:10) describes walking **backwards until an 8-hour gap is found** and grouping every
  entry in between *"as if it was one shift"*. Ehtesham (27:06) proposed only ever checking the
  immediately previous entry, and **Corrina agreed**: *"Right, it would just be the previous day."*
  For a two-day chain these agree; for three or more consecutive short rests they do not.

## 4. Holiday minimum — 8 hours at triple, from either end (31:00 – 35:46)

- **A holiday shift is triple time throughout, with an 8-hour minimum.** Corrina (31:29, 31:43):
  *"They get an 8-hour minimum. But everything is on triple time."*
- **Any contact with a holiday triggers the full minimum.** Corrina (34:34): *"no matter how much
  time, **even if they only work half an hour on the holiday**, that has to get converted to 8 hour
  minimum."* And (34:49) it works at the back end too — a non-holiday shift running to 00:30 into a
  holiday converts those 30 minutes to the 8-hour minimum. This **confirms**
  [../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md](../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md) (b) from the same
  person, now on a recorded call.
- **⚠️ Corrina explicitly deferred one case.** For a shift *starting* on a holiday at 22:00 and
  running to 10:00 the next, non-holiday, day, she could not say whether the post-midnight hours
  stay at triple or revert (33:46): *"this is like very rare that it happens, so my brain is not
  like…"* and (34:02, 34:10): **"I'll double check with our rep with this one… whether it's they
  stay on triple time or they revert back. So I'll double check with him for this."** **Owed by
  Corrina; the union rep is the source.**
- **Guaranteed minimums are per calendar day, not per labor entry.** Brian (36:07), confirmed by
  Corrina: the holiday 8-hour minimum, the 4-hour shift minimum and the 4-hour boom minimum are
  *"based on the calendar work day"*, so **more than one labor entry can be involved** — the
  examples above were worked assuming a single entry, which is not the general case.

## 5. Union vs non-union — the scope boundary, stated plainly (36:54 – 51:41)

- **Every dispatched job is L12.** Corrina (38:20): *"any job that's quoted is going to be L12."*
  Non-union means **California Labor Law**, and those are *"admin people, so that's not in the
  field — they wouldn't get a job that's correlated to Local 12 rules."*
- **Three payroll populations, not one:** field employees (L12, job codes → job tickets);
  **work-order** employees; and **salaried** employees, who have no labor entered at all
  (Brian, 42:30). Ehtesham (41:19): *"we haven't focused on the office employees. We need to figure
  out what that is."*
- **Work orders are the non-job labor path** — attached to a PO or a piece of equipment, not a job
  (Corrina 42:12). Used by **yard technicians (California Labor Law)** and **mechanics/HDRs
  (Local 12 — same payroll logic as the field)**. Corrina (50:43) corrected the record: **there is
  no such thing as a non-union mechanic** — *"we can't have that position"* (Kyle).
- **Crossover is real and is currently manual.** Mechanics occasionally work a job site and are
  billed to the job; an HDR may go third man. Corrina (49:07): *"it would be nice if they would be
  able to have access to work orders and job tickets, because **right now it's one or the other**."*
  Kyle (49:39): *"otherwise, it's a manual entry. And so that needs to be all automated."* It can
  happen **within one day** (Corrina 51:15).
- **Craft code lives on the employee and is overridable on the entry** — Brian (39:23, 40:07);
  effective-dated, *"because they may transition from one craft code to another and it needs to know
  when the labor happened"* (50:58). **Union → non-union on a single entry does not happen** —
  Corrina (40:36): *"No, that doesn't happen."*

## 6. Paper tickets — why they exist, and what would retire them (52:11 – 55:34)

Brian opened the topic he had flagged in writing. **The reasons are three, and only one is a
training problem:**

1. **Unfamiliarity.** Corrina (52:40): an operator sent out as a third man does the paperwork the
   oiler normally does for them, *"and they just don't want to do it because they're not used to
   it."* Kyle (53:07): *"or don't even know how and haven't tried to do it."* Both call this
   manageable.
2. **Non-billable labor with nowhere to go — the real driver.** Corrina (53:09): after a job they
   *"come back after the job and they do something in the shop or something, wash their crane,
   whatever, that is not billable to that customer — they need to be able to add that labor onto
   their hours without it being attached to that ticket. **Because that's a lot of reason why there's
   a lot of papers right now too, because we don't have that function right now.**"* Same for drug
   testing and accidents.
3. **Work-order / job-ticket crossover**, from §5 — Kyle (49:20): *"right now it's a problem and we
   have to do paper tickets for those things."*

**What TCG asked for instead of paper.** Kyle (54:23): *"giving them the ability to just do a basic
time ticket with a very open — they could just write in what they're doing. It would be very vague —
and who approved it. And it could be pretty simple. I don't think it has to be very complicated. And
that way to get rid of that."* With **a billing code** and a description, and **not originating from
Dispatch**.

**Nobody said paper must be kept as a backup.** Brian asked *"can we get rid of this whole paper
ticket or do we need it as a backup?"* — the answers addressed the *causes*, not the fallback, and
the fallback question was never answered. It stays open, narrowed, in
[../field-ops/gaps.md](../field-ops/gaps.md) → *Paper Job Tickets*.

**Offline mode — Kyle raised it, Ehtesham committed.** Kyle (54:23): *"when we don't have cell phone
reception, we work in a lot of remote areas. Will the ERP be able to work offline?"* Ehtesham
(55:07, 55:15): *"that's the idea… it's going to detect that we don't have service, everything is
going to get saved on the device"* and upload on reconnect. Kyle (55:34): *"that will solve some of
those problems, too."* **A commitment on a call, with no ticket and no written scope.**

## 7. Time zones (1:03 – 6:15)

Abdul Rehman proposed anchoring payroll to a single yard time zone for now. Brian agreed
practically — TCG is West Coast/PST, will expand east eventually — and described the hard case
himself: a **holdover** where day 1 travels into another zone and day 2 is contained entirely in
that other zone. Agreed: **single time zone now, multi-zone later.** Consistent with the four
2026-09-09 tenant-timezone decisions already in `decisions/`. Brian's instinct — *"anchor the time
zone to where they started"* — is recorded but not adopted.

## 8. Rollout, beta testers and the next two meetings (55:45 – 1:01:25)

- **Nobody on the client side has looked at the portal yet.** Corrina: *"I will be honest, I have
  not."* Kyle: *"No."* Brian: *"I have not."*
- **Walkthrough, from scratch, sequential** — assets, billing codes, quotation, job, permits,
  dispatch, field, payroll. Ehtesham (1:00:18) planned it for both of next week's meetings; Brian
  (59:53) had asked for exactly this instead of handing over a URL.
- **Beta testers:** one or two to start, people who know field-level work (abdulrehman 56:48). Kyle
  will pick *"one good person from each pool."* Ehtesham (57:31): operators and **primarily oilers,
  because they are responsible for tickets**.
- **Field employees have no Microsoft email** — Brian (58:08). Login identity will be the
  **mobile phone number**.
- **Plan:** walkthroughs from the **15th** (Tuesday); Thursday reserved for field testers if enough
  is ready, otherwise field onboarding slips to the following Tuesday.

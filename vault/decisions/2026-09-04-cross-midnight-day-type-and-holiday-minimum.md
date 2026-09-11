---
title: Cross-midnight day type takes the higher rate, and spilling into a holiday owes the full 8-hour minimum: decision
source: decision/client written statement (Corrina Bustos, TCG Payroll Manager, Teams, 2026-09-04) + as-built engine + MLA
decided: 2026-09-04
decided_by: Corrina Bustos (TCG Payroll Manager), in writing on Teams, 2026-09-04, answering a direct question from Ehtesham Anwar about the cross-midnight drive on her own hand-worked long-boom day breakdown. She is the person the legacy engine's own config row names as the owner of this decision (`cfg.CrossMidnightDayTypePolicy`: *"Default until Payroll Manager confirms otherwise"*). Full verification in payroll/client-message-findings.md.
status: verified
resolves: [PAY-019, payroll/gaps.md#long-boom-day-breakdowns--drive-time-cross-midnight-and-the-20-hour-day, payroll/gaps.md#holiday-8-hour-minimum-on-a-shift-that-only-spills-past-midnight-into-the-holiday]
tags: [module/payroll, kind/decision, payroll-rules, time-tracking, overtime, holidays, guaranteed-hours, union-agreement, legacy-payroll-app]
---

# Decision

Ehtesham asked: example 2's last drive crosses midnight between two weekdays, so no rate
changes. If it ran into a Saturday, Sunday or holiday instead, do the hours after midnight pay
at the new day's rate, or does the whole shift stay on the rate for the day it started?

Corrina Bustos, verbatim:

> the question would remain irrelevant if they worked into Saturday or Sunday due to the fact
> that they were already on Double time. if they were to work into a holiday they would be owned
> an additional 8 hours at triple time as the rule is that the ee is owed a minimum of 8 hours.

Two rulings follow.

## (a) The higher rate governs after midnight, never a downgrade

A shift already at double time does not drop to Saturday x1.5 when the clock passes 00:00.

This is the already-active `cfg.CrossMidnightDayTypePolicy = CalendarDay` read through the
no-pyramiding precedence chain, where `DT` outranks `SATURDAY`, and it is equally what the
inactive `AnchorFloor` policy (a `max`) would produce. **No config flip is required and no
engine change is needed.** The parked decision resolves to *keep `CalendarDay`*.

The only reading Corrina's answer rules out is Brian Petros's written summary, *"the entire job
is associated with the date in which the labor started"*, which would have paid the start day's
rates straight through. The `AnchorFloor` branch and its 10-case test harness
(`test.Case_CrossMidnight_DayType`, `usp_Test_CrossMidnight_DayTypePolicy`) can remain in place
as dead config.

> **⚠️ Wording flagged 2026-09-11 — "an additional 8 hours".** Brian Petros has marked this phrase
> as *"a bit controversial… it can be interpreted differently"*: read literally it pays 2 worked +
> 8 additional = 10 TRI; read as the app, the legacy engine and the ERP all implement it, the
> minimum is **8 hours total** and the top-up is 8 − worked. Corrina's same sentence says *"a
> minimum of 8 hours"*, which supports the second reading, but she has not been asked which she
> meant. Until she answers, ruling (b) below settles *that the minimum fires* on a spill-over —
> not *how many hours it adds*. See PAY-033 and payroll/gaps.md → *Holiday shift-start
> continuation and the 8-total-vs-8-additional minimum*.

## (b) Spilling into a holiday is holiday work

Post-midnight slices price at x3, and the MLA's 8-hour holiday minimum fires.

Contract basis, [MLA Article III, Holidays §1](../payroll/mcog-l12-mla-2025-2028/01-article-iii-working-rules.md):
*"A minimum of eight (8) hours at triple (3) time the regular rate of pay as herein provided
shall be paid for all work performed under this Agreement on the following holidays."*
Unconditional, with no minimum duration.

# Scope of the holiday minimum, resolved from the record the same day

Corrina's answer left the *scope* of that minimum unstated. It was settled without asking her,
from two independent sources that agree: **the holiday minimum is owed once per employee per
calendar date, summing every entry that touches the day, not once per shift.**

- **Code.** [`payroll/legacy-payroll-app-db-extract/sql/app/usp_Apply_GuaranteedHours.PROC.sql`](../payroll/legacy-payroll-app-db-extract/sql/app/usp_Apply_GuaranteedHours.PROC.sql)
  lines 443-487. The `HolidayGroups` CTE declares `ScopeBasis = 'CalendarDate'` and
  `GroupScope = 'EmployeeCalendarDate'`, sets `ShiftAnchorDate = CONVERT(date, NULL)` explicitly,
  and closes `GROUP BY EmpID, CalendarDate`. The gap is `8.00 - SUM(Slice_Hours)` over that
  date's holiday slices, allocated to the latest holiday-slice entry
  (`AllocationMethod = 'LastHolidaySliceEntry'`, line 742). There is **no spillover suppression
  anywhere**: the only switch is `cfg.Craft_MinimumPayPolicy.ApplyMinimumPay` (lines 140, 464), a
  per-craft flag used to exempt admin crafts.
- **Recording.** [`meetings/transcripts/2026-06-11-payroll-app-demo-02.md`](../meetings/transcripts/2026-06-11-payroll-app-demo-02.md).
  Corrina Bustos at 19:11: *"Put 8 hours per day guaranteed on a holiday"*, and at 19:16 on
  the non-holiday case: *"it's a four-hour minimum per day or their true time."* Brian Petros at
  19:21 describes the grouping as *"looking at the entire day for the employee… they actually
  work 6 hours that day, so the rule didn't apply."*

**Worked consequence:** a 0.5-hour spillover past midnight plus a later 6-hour holiday shift is
one day at 6.5 hours and a 1.5-hour gap at x3. It is **not** two 8-hour minimums.

# Carry this into the ERP build: the two minimums do not mean the same "day"

In plain language Corrina says "per day" for both the 4-hour daily minimum and the 8-hour
holiday minimum, but the engine means two different days:

| Minimum | Grouped on | rules-plain-language |
| --- | --- | --- |
| Daily minimum, long-boom minimum | `ShiftAnchorDate` | §5, §6 |
| Holiday minimum, special-Saturday minimum | `CalendarDate` | §7 |

This is deliberate in the code: each group emits its own named `ScopeBasis`, and the
calendar-date holiday group sits in the same CTE block as the shift-anchored groups. The two
definitions diverge **only** on a cross-midnight shift, which is precisely the case where the
holiday date is in dispute. That makes the asymmetry load-bearing exactly where it is least
visible, and easy to flatten by accident in a rewrite. A rewrite that collapses both minimums
onto one notion of "day" will be wrong on the case this decision was asked about.

# Effect on the vault

All of these were written on 2026-09-04, before this note. Nothing here is a handoff.

- [`payroll/rules/PAY-019-cross-midnight-processing.md`](../payroll/rules/PAY-019-cross-midnight-processing.md)
  is **done**: `status: conflicted` → `settled`, carrying Corrina's quote and both rulings.
- [`payroll/rules/PAY-021`](../payroll/rules/PAY-021-l12-standard-work-window.md),
  [`PAY-033`](../payroll/rules/PAY-033-holiday-pay.md),
  [`PAY-043`](../payroll/rules/PAY-043-long-boom-premium.md): **done**, updated with the
  resolutions. All three stay `status: open` on their own remaining items: PAY-033 still owes the
  Labor Day emergency workflow.
- [`payroll/rules/INDEX.md`](../payroll/rules/INDEX.md): **done**, now 4 settled / 67 open /
  2 conflicted.
- [`payroll/gaps.md`](../payroll/gaps.md): **done**, both entries `resolved 2026-09-04`:
  *Long-boom day breakdowns, drive time, cross-midnight, and the 20-hour day*, and *Holiday
  8-hour minimum on a shift that only spills past midnight into the holiday*.
- [`payroll/client-message-findings.md`](../payroll/client-message-findings.md#2026-09-04--long-boom-day-breakdowns-drive-time-included-corrina-bustos-teams)
  is **done**, and holds the full verification, an 8-row claim table and both of Corrina's replies.
- **No vault file body was edited by this note, and no frontmatter was flipped by it.** The rule
  register uses its own `status:` vocabulary (settled / open / conflicted) and PAY-019 already
  reads `settled`.

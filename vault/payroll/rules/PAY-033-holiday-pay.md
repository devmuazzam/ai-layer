---
id: PAY-033
title: PAY-033 — Holiday pay
section: D-weekend-holiday-shift
status: open
updated: 2026-09-04
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-033 — Holiday pay

**Rule:** Pay actual and guaranteed hours at applicable holiday rate.

**Applies to:** Eligible L12 labor. **Trigger:** Work occurs on configured holiday.
**Requires:** Hours; rate; holiday multiplier.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-033` — baseline: *Existing baseline*
- **FRD** (target design): [05-weekend-holiday-and-shift-rules.md](../erp-payroll-module-frd/05-weekend-holiday-and-shift-rules.md) `PR-019` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §3+§7
- **Contract**: [01-article-iii-working-rules.md](../mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)

## Open

- **Blocking (matrix):** Confirm Labor Day emergency workflow
- **Gap placement semantics:** holiday/special-Sat shortfall pays at **the day's own multiplier** (×3 / ×2) on the day's latest entry — "as if worked that day", agreeing with the client's added-hours doctrine.
- **Spillover into a holiday triggers the full 8-hour minimum — Corrina, 2026-09-04:** asked what
  happens when a shift crosses midnight into a holiday, she answered that the employee *"would be
  owned an additional 8 hours at triple time as the rule is that the ee is owed a minimum of 8
  hours."* The MLA is unconditional — *"A minimum of eight (8) hours at triple (3) time... shall be
  paid for all work performed under this Agreement on the following holidays"* (Article III,
  Holidays §1) — and the engine agrees by construction, because §7 groups the holiday minimum by
  **calendar day**, so any slices > 0 on the holiday give `gap = 8 - hours worked that day` at x3.
- **✅ Scope of that minimum resolved the same day, from the record — no client question needed:**
  the holiday minimum is owed **once per employee per calendar date**, summing every entry that
  touches the day. `usp_Apply_GuaranteedHours.PROC.sql:443-487` declares
  `ScopeBasis = 'CalendarDate'`, `GroupScope = 'EmployeeCalendarDate'`, nulls `ShiftAnchorDate`
  explicitly and closes `GROUP BY EmpID, CalendarDate`; the gap is `8.00 - SUM(Slice_Hours)` over
  that date's holiday slices, allocated to the latest one (`AllocationMethod =
  'LastHolidaySliceEntry'`, `:742`). Corrina said the same thing on the **2026-06-11** demo
  recording at 19:11 — *"Put 8 hours per day guaranteed on a holiday"* — with Brian at 19:21
  describing the grouping as *"looking at the entire day for the employee."* So a 0.5-hour
  spillover plus a later 6-hour holiday shift is one day at 6.5 hours and a 1.5-hour gap, not two
  minimums. There is **no spillover suppression** anywhere: the only switch is
  `cfg.Craft_MinimumPayPolicy.ApplyMinimumPay`, a per-craft flag used to exempt admin crafts.
- **⚠️ Known asymmetry to carry into the ERP:** in plain language Corrina says "per day" for both
  the 4-hour and the 8-hour minimum, but the engine means **`ShiftAnchorDate`** for the daily and
  long-boom minimums (§5, §6) and **`CalendarDate`** for the holiday and special-Saturday minimums
  (§7). The two definitions diverge only on a cross-midnight shift — which is exactly the case
  where the holiday date is in dispute. Deliberate in the code (each group emits its own named
  `ScopeBasis`), but easy to flatten by accident in a rewrite.
  Detail: [gaps.md](../gaps.md#holiday-8-hour-minimum-on-a-shift-that-only-spills-past-midnight-into-the-holiday).
- **Re-confirmed on a recorded call, 2026-09-10, by the same person who decided it in writing**
  ([../../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md](../../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md) §4). Corrina Bustos 31:43: a holiday shift is *"all of it… on triple time"* with an
  **8-hour minimum**; 34:34: *"**no matter how much time, even if they only work half an hour on the
  holiday**, that has to get converted to 8 hour minimum"*; 34:49 — and it fires at the back end too,
  a non-holiday shift running to 00:30 into a holiday converts those 30 minutes to the 8-hour
  minimum. This corroborates [../../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md](../../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md) (b) on
  the record.
- **⚠️ Explicitly deferred by Corrina on the same call — the holiday-start continuation.** For a
  shift **starting** on a holiday at 22:00 and running to 10:00 the next, non-holiday day, she could
  not say whether the post-midnight hours stay at triple or revert (33:46: *"this is very rare that
  it happens, so my brain is not like…"*), and undertook to **check with the union rep**: *"I'll
  double check with him how it would work on the holiday… whether they stay on triple time or they
  revert back."* (34:02, 34:10). **Owed by Corrina Bustos; the union rep is the source. Do not
  infer it from the cross-midnight decision** — that note answers spilling *into* a holiday, not
  running *out of* one.
- **Guaranteed minimums are per calendar day, not per labor entry** — Brian Petros 36:07, confirmed
  by Corrina: the holiday 8-hour minimum, the 4-hour shift minimum and the 4-hour boom minimum are
  *"based on the calendar work day"*, so **more than one labor entry can be in scope**. Every
  worked example on the call assumed a single entry, which is not the general case.

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
- **Brian Petros, 2026-09-11, in writing, on the three holiday scenarios sent to Corrina (Veterans'
  Day Wed Nov 11; whole-shift, 2-hour spill-in, holiday start running past midnight):** *"Corrina
  is the best one to answer. Based on my knowledge and our internal Payroll App logic… all 3
  examples look correct to me."* On the deferred case he gives the reasoning the app uses:
  *"midnight changes the applicable day type, but midnight by itself should not reset the
  employee's continuous shift or worked-hour accumulation… Thursday is no longer a holiday, so the
  Thursday hours should not automatically remain TRI. However, the employee also does not suddenly
  receive a new block of straight-time hours at midnight… At 10am the employee has reached exactly
  12 actual worked hours; any applicable DT treatment would begin only after that threshold."* So
  the app's answer is **8 TRI + 10 OT**, not 12 TRI — *"we believe the ERP should split the worked
  timeline at midnight for day-type pricing while preserving the continuous shift for OT/DT
  accumulation."* **What he still wants the rep to confirm:** *"whether the agreement contains a
  special rule stating that a shift that begins on a holiday remains at the holiday rate for the
  entire continuous shift even after midnight"* — if such a *holiday shift-start* rule exists, #3
  becomes a specific exception and the whole 12 hours stay TRI. **Status:** Brian's reading and the
  app's; Corrina has not yet answered; the rep is the source for the exception question.
- **⚠️ Brian flags the minimum itself as contested — "8 hours total" vs "8 additional hours".**
  Same day, listing five concepts and marking this one as *"a bit controversial… it can be
  interpreted differently"*: *"Holiday minimum is **8 hours total, not 8 additional hours**. If 2
  hours were actually worked on the holiday, PayrollAPP adds a 6-hour guarantee/top-up, so the
  employee ends up paid for 8 holiday hours."* Corrina's own written words on 2026-09-04 were
  *"owed an **additional** 8 hours at triple time as the rule is that the ee is owed a minimum of
  8 hours"* — literally read, 2 worked + 8 additional = 10 TRI. **The ERP, the legacy engine and
  Brian's app all implement top-up-to-8** (`guarantee.ts` → `applyPremiumDayMinimums`: *"a
  0.5-hour spillover plus a later 6-hour holiday shift is one day at 6.5 hours, owed 1.5"*; legacy
  `HOLIDAY_MIN_8`). So three engines agree with Brian and the only source for "additional 8" is one
  sentence of Corrina's, which her own *"minimum of 8 hours"* in the same sentence contradicts.
  Needs her explicit confirmation — and it is worth **$480.00** per occurrence at an $80 base
  (2 extra TRI hours). Registered in [../gaps.md](../gaps.md) → *Holiday shift-start continuation
  and the 8-total-vs-8-additional minimum*.
- **The other three concepts in the same message, all consistent with the vault as it stands:**
  holiday worked time is 3.00× (PAY-033); **the guarantee is not worked time** — *"It should not
  advance OT/DT thresholds, rest calculations, WTL, etc. It is effectively a separate pay
  component"* (matches `rest-period.ts:79` and the legacy `Gap_*` columns, and is what makes #3
  come out at 10 OT rather than 4 OT + 6 DT); midnight changes day type without breaking the
  continuous shift (the CalendarDay policy, PAY-019); long-boom pay attaches only to the
  build-up/work/breakdown portion and *"should not determine whether the hours are ST/OT/TRI"*
  (PAY-043).
- **✅ Union ruling, 2026-09-12, via Corrina Bustos — decision note [../decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md](../decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md).** Holiday
  22:00 → non-holiday 06:00 = **8 TRI · 4 OT · 2 DT**. (a) The minimum is **8 hours total** — 2
  worked → 8 TRI; (b) **no holiday shift-start rule** — after midnight *"would start at the
  applicable rate"*, continuous shift preserved; (c) **the guaranteed hours count toward the
  12-hour DT mark** — DT at 04:00 = 8 guaranteed + 4 OT. (c) contradicts Brian's 2026-09-11
  *"should not advance OT/DT thresholds"*, his app, the legacy engine and the ERP, and is the
  union's reading. **The ERP currently overpays both holiday-start cases** (14 TRI and 18 TRI
  instead of 8/4/2 and 8/4/6) because the A4 fix floors post-midnight slices at the anchor day's
  ×3. Rest trigger, weekly OT and meal spans were not ruled on.

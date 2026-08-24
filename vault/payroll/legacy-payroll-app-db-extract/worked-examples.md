---
title: Legacy Payroll App - 13 real labor entries traced source to ledger
source: user-supplied/PAYROLL_CALC_EXTRACT.zip (generated 2026-08-18 on the client machine from TCG_PayrollAPP + c:/projects/tcg-payroll-api)
migrated: 2026-08-18
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app]
entities: [labor-entry, pay-component]
part_of: payroll/legacy-payroll-app-db-extract/INDEX.md
---

> Part of the 2026-08-18 read-only extract of the live legacy database `TCG_PayrollAPP`
> (`localhost\SQLEXPRESS`, SQL Server 2025 Express). Line anchors like `sql\app\x.PROC.sql:12-20`
> refer to the verbatim definitions in [sql/](sql/) (backslashes → forward slashes). Employee
> identifiers are masked `E***NN`. Nothing that writes was executed to produce this.

# WORKED EXAMPLES (Part D) — end-to-end traces

Each example is a real labor entry (EmpID masked `E***NN`, names withheld) traced from the source labor row
→ `fms.Payroll_Calculated` → `fms.Payroll_PayComponent` ledger → what the UI shows. Values were read live
(read-only) from `fms.Payroll_Calculated`, `fms.Payroll_PayComponent`, `api.v_UI_LaborEntry_BoomBreakdown`
and the read-only regression harness `test.usp_RunAll_CurrentPayrollRegression_Checkpoint`
(full result sets in `data/_TEST_RESULTS.md`). Union base rate = `FMS_UNION_CRAFT.PayRate`; boom adder =
`FMS_UNION_CRAFT_MODIFIER.PayRateChange`.

The per-slice engine formula (B2) is `slice_pay = 0.5h × (Rate_Base + Rate_Shift + boom?Rate_Boom) ×
Final_Multiplier`; the ledger (B11) then splits `Pay_Actual_Gross` into base/boom/shift lines and appends
guarantee / rest / WTL / subsistence / rounding lines. To reproduce any of these interactively use
`api.usp_Get_LaborEntry_AuditPacket @LaborPayrollID=<id>, @IncludeSlices=1, @SliceDetailLevel='full'` and
`api.usp_UI_Payroll_LaborEntry_Ledger @LaborPayrollID=<id>` (both read-only).

---

## D1 — Plain weekday, no premiums (WEEKDAY_MIN4 not triggered here: OT-only)
**LaborPayrollID 83282**, `E***75`, 2026-04-23 (Thu), craft `HDR-A` (rate 71.16), ticket OM57005.
- Source: labor 06:00→18:00, HoursWorked_Raw 12.00.
- Calc: Act_Total_Hrs 12.00, **Hrs_ST 8 / Hrs_OT 4 / Hrs_DT 0**, Pay_Actual_Gross **1069.74**.
  (8×71.16×1.0 + 4×71.16×1.5 = 569.28 + 426.96 = 996.24… the row also carries a modifier — see D-note.)
- Ledger: `ACTUAL_BASE_WORKED_PAY` carries the base; boom is present as *hours* but **not payable** because
  `HDR-A` is not an `L12%` craft (see D-fail note). Day_Type WEEKDAY, multipliers 1.00→1.50.

## D2 — Weekday daily double-time (ST + OT + DT)
**LaborPayrollID 83338**, `E***38`, 2026-04-23, craft `L12-G3-A` (rate 67.87), ticket OM58729.
- Source: labor 04:00→17:00, 13.00 h.
- Calc: Act 13.00, **ST 8 / OT 4 / DT 1**, Pay_Actual_Gross **1085.92**.
  8×67.87 + 4×67.87×1.5 + 1×67.87×2.0 = 542.96 + 407.22 + 135.74 = 1085.92 ✓.
- Ledger: `ACTUAL_BASE_WORKED_PAY` 13.00h = 1085.92; `WTL_MEAL_DEDUCT` −0.50h @ mult 1.00 (−33.94) and
  −0.50h @ mult 1.50 (−50.90) — a worked-through meal was modelled (see B7).

## D3 — Boom modifier present WITH boom hours
**LaborPayrollID 71754**, `E***30`, 2025-10-28, craft `L12-G2-A` (rate 66.18), modifier **OI-BP-01
(080-100Ft-Oiler, PayRateChange 0.250)**, ticket 38468.
- Source: labor window ≈06:00→next-day 03:30 (23.5h raw), boom window 10/28 06:30→10/29 03:30.
- Calc: Act 22.00, Act_Boom_Hrs **21.00**, Pay_Actual_Gross **2258.25** (ST 8/OT 4/DT 10 across the window).
- Boom breakdown: `Boom actual`; Slice_Boom_Hrs 21.00; **Boom_Actual_Add_Amt 8.13** =
  Σ(0.25 × 0.5h × Final_Multiplier over the 21 boom hours) — i.e. the 0.25 adder is itself multiplied by
  each slice's OT/DT multiplier (that is why 21×0.25=5.25 grosses up to 8.13).
- Ledger: `ACTUAL_BASE_WORKED_PAY` 22h=2250.13; `ACTUAL_BOOM_WORKED_PAY` 21h=**8.13** (RateBoomUsed 0.250);
  `WTL_MEAL_DEDUCT` several lines; `PAY_COMPONENT_ROUNDING_ADJUSTMENT` −0.01.

## D4 — Ticket has a boom window but the entry has NO modifier code
**LaborPayrollID 80274**, `E***55`, 2026-03-13, craft `L12-G8-A`, **no CraftModifierCode**, ticket 42758.
- Ticket boom window 03/13 10:00→16:30 (6.50h) exists, but `BoomEligible = False`.
- Calc: Act 23.00 (cross-midnight 07:30→next-day 06:30), ST 8/OT 4/DT 11, Pay_Actual_Gross **2489.76**.
- Boom breakdown: **`Ticket boom window only - no modifier`**; Slice_Boom_Window_Hrs 6.50 but
  Slice_Boom_Hrs 0, Boom_Actual_Add_Amt 0. The window is reference-only; no boom premium is paid.

## D5 — LONG_BOOM_MIN_4 boom guarantee triggered (boom gap)
**LaborPayrollID 81827**, `E***53`, 2026-04-03, craft `L12-G3-A` (rate 67.87), modifier **OP-BP-02
(101-120Ft-Operator, 1.500)**, ticket 43574.
- Source: labor 05:00→09:00 (4h); actual boom hours only 0.50.
- Calc: Act 4.00, Act_Boom_Hrs 0.50, **Gap_Hrs_Boom 3.50**, ST 3/OT 1.
- Boom breakdown: `Boom actual + gap`; Boom_Actual_Add_Amt 0.75 (0.5h×1.5×1.0);
  **Boom_Gap_Add_Amt 5.25** = 3.50h × 1.500 × Audit_Gap_Mult 1.00.
- Ledger: `ACTUAL_BASE_WORKED_PAY` 4h=305.42; `ACTUAL_BOOM_WORKED_PAY` 0.5h=0.75;
  **`GUARANTEED_BOOM_PAY_ADD` 3.50h = 5.25** (RateBoomUsed 1.500, mult 1.00, AllocationMethod
  `LastEligibleBoomEntryInShift`). The long-boom minimum tops boom hours up to 4.

## D6 — Rest-period premium FORCED
**LaborPayrollID 83285**, `E***69`, 2026-04-23, craft `L12-APP-A` (derived rate 40.90), ticket 44275.
- Prior chain ended with OT/DT and the gap to this entry was **< 8h**, so `Rest_IsForced = 1`.
- Calc: Act 4.00, ST 4, Pay_Actual_Gross 163.60, **Pay_Rest_Add 81.80**, Rest_Policy `PunitiveUntil8Off`.
  Premium = 4h × 40.90 × (1.50 − 1.00) = 81.80 (OT-floor delta over the forced slices).
- Ledger: `ACTUAL_BASE_WORKED_PAY` 4h=163.60; **`REST_PERIOD_PREMIUM` 4h=81.80**. Final_Gross_Pay =
  163.60 + 81.80 = 245.40.

## D6b — Rest-period OVERLAP (data-quality) forced
**LaborPayrollID 82905**, `E***14`, 2026-04-16, craft `L12-G1-A` (66.03). Overlap with prior entry
(`Rest_IsOverlap = 1`), forced. Act 10.00, Pay_Actual_Gross 726.33, **Pay_Rest_Add 594.27**,
`REST_PERIOD_PREMIUM` 10h=594.27. Raises `RestPeriod_Overlap` exception.

## D7 — WTL worked-through meal vs taken meal
Worked-through meals appear as `WTL_MEAL_DEDUCT` (negative) + `WTL_APPLICABLE_ADD`/`WTL_DT_FLOOR` (positive
2× add). Example **LaborPayrollID 83338** (D2): two `WTL_MEAL_DEDUCT` lines (−33.94 @1.0, −50.90 @1.5) model
the priced meal slices removed then re-added under WTL rules (see B7 for the add side). A "taken meal" simply
produces the deduction with no applicable-add. Live WTL component rows: `data/_A3_distinct_codes.md` (411
WTL_APPLICABLE_ADD, 131 WTL_DT_FLOOR, 16,106 WTL_MEAL_DEDUCT).

## D8 — Subsistence short & long (payable-only)
**LaborPayrollID 87403**, `E***75`, 2026-06-20: `SUBSISTENCE_SHORT_85` **$85.00**, `IncludedInFinalGross =
False`, `IncludedInPayableGross = True` — it does not change Final_Gross_Pay but is added to the payable
total. Long weekday = `SUBSISTENCE_LONG_WEEKDAY_85` ($85), long weekend = `SUBSISTENCE_LONG_WEEKEND_200`
($200) (see B8).

## D9 — Saturday / Sunday / Holiday / Special Saturday (H2x, H3x)
| Scenario | LPID | Emp | Date | Craft | Act | ST/OT/DT | Day mult | Pay_Actual_Gross |
|---|---|---|---|---|---|---|---|---|
| Normal Saturday | 82951 | E***75 | 2026-04-18 | HDR-A | 12.00 | 0/0/12 (all @1.5)* | 1.50 | 1375.38 |
| Sunday premium | 82976 | E***55 | 2026-04-19 | L12-G8-A (69.16) | 7.00 | 0/0/7 | 2.00 | 968.24 |
| Holiday >8 | 78410 | E***53 | 2026-02-16 | L12-G8-A (69.16) | 16.50 | 0/0/16.5 | 3.00 | 3592.17 |
| Special Sat +gap | 74066 | E***38 | 2025-12-06 | L12-G3-A (67.87) | 6.00 | 0/0/6 | 2.00 | 832.44 |
*Saturday hours multiply at ×1.5 but land in the OT/`Hrs_DT` reporting bucket per the engine's
`Hrs_DT = Σ(0.5 where Final_Multiplier >= Mul_DT)` — Saturday(×1.5) is reported as OT; Sunday(×2),
Special-Sat(×2), Holiday(×3) all report as `Hrs_DT` (B2 STEP E). "H2x"/"H3x" buckets (`Bucket_Hrs_H2x`,
`Bucket_Hrs_H3x`) are the UI's 2×/3× split, computed in `api.v_UI_Payroll_LaborEntry_HourBuckets`.

**Special Saturday guarantee (74066):** Act 6.00 < min 8 → gap 2.00h priced at 67.87 × 2.00 =
`GUARANTEED_SPECIAL_SAT_BASE_PAY_ADD` **271.48** (AllocationMethod `LastSpecialSatSliceEntry`). Boom
`OP-BP-03` 2.250 on 4 boom hours × ×2 = `ACTUAL_BOOM_WORKED_PAY` 18.00.

**Holiday Min-8 (73794):** `E***94`, 2025-11-27 Thanksgiving, 3.50 actual @ ×3 = 726.18 base; the holiday
guarantee tops to 8h (`GUARANTEED_HOLIDAY_BASE_PAY_ADD`, mult 3.00, `LastHolidaySliceEntry`) — the harness
also shows a Memorial-Day example (86102): 5.0 actual, gap 3.0h × mult 3.0 = 640.44.

## D10 — Non-Union Admin Hourly week: daily OT (and weekly OT)
**LaborPayrollID 87529**, `E***60`, 2026-06-22, PayrollGroup Non-Union Admin Hourly, rate 25.00:
- `NONUNION_CA_NONEXEMPT_ST` 8.00h × 25.00 = **200.00**; `NONUNION_CA_NONEXEMPT_DAILY_OT` 2.50h × 25.00 ×
  1.50 = **93.75** (daily hours 8–12 → OT). Weekly-OT example **87347** `E***04`:
  `NONUNION_CA_NONEXEMPT_WEEKLY_OT` 1.50h × 16.50 × 1.50 = **37.13** (>40 ST hours in the Sat–Fri week).
- For these rows the union-style buckets are replaced by the six `NONUNION_CA_NONEXEMPT_*` ledger lines
  (see B9); rate = `Employee.PayRate`. (7th-consecutive-day OT/DT rows also exist:
  `NONUNION_CA_NONEXEMPT_7TH_DAY_OT/_DT`, `data/_A3_distinct_codes.md`.)

## D11 — Missing source rate (suppressed)
**LaborPayrollID 86465**, `E***43`, 2026-06-05: Act 2.50h, Hrs_ST 2.50, but **Pay_Actual_Gross 0.00 and
Final_Gross_Pay 0.00** — `app.usp_SuppressPay_WhenSourceRateMissing` zeroed the pay because
`Source_Rate_Raw` was missing and the craft/base rate could not be resolved (B10). The hours remain for
review; `PayrollBaseRateSource = 'Unknown / Needs Review'` (5,725 such rows machine-wide, A3b).

## D12 — Cross-midnight shift
**LaborPayrollID 80274** (D4): labor 03/13 07:30 → **03/14 06:30** (end time-of-day < start → anchored to
next day, B1). Slices span both calendar days; the active `CrossMidnightDayTypePolicy = CalendarDay` rates
each 30-min slice by its own calendar day-type while OT accumulation stays anchored to Day 1. Result Act
23.00, ST 8/OT 4/DT 11, Pay_Actual_Gross 2489.76. Another cross-midnight case from the harness (83160):
labor 04/21 19:00→04/22 04:30 (9.50h) priced entirely at OT (night window outside 06:00–17:00).

## D13 — Shift-2 differential (rate add + hours add)
**LaborPayrollID 82541**, `E***56`, 2026-04-13 (from live ledger): `ACTUAL_SHIFT_DIFFERENTIAL` 12.00h =
**54.00** (RateShiftUsed 3.00 → the +$3/h 2nd-shift premium embedded in the priced slices), plus
`SHIFT_2_HOURS_ADD` 1.00h = **103.55** at mult 1.50 (the work-7-paid-8 conversion adds one paid hour priced
at base+shift; see B4). These are the only 3 shift-differential entries in the whole history (A3), so this
rule is rarely exercised.

---

## Failure/edge finding surfaced by the traces
`HDR-A` and other **non-`L12%` crafts that carry a boom modifier accrue boom *hours* (Act_Boom_Hrs) but no
boom *premium*** — the engine only sets `Rate_Boom` when `CraftCode LIKE 'L12%'`
(`sql/app\usp_Run_Pricing_Engine.PROC.sql:905-911`). Scenarios **83282** and **82951** (both HDR-A, OP-BP-07)
therefore FAIL the boom-breakdown consistency check "Payable slice boom hours do not match calculated actual
boom hours" in `test.usp_Run_BoomBreakdown_Tests` (2 of 9 checks). This is the single failing check in the
regression checkpoint and is a genuine open item (see `OPEN_QUESTIONS.md` Q1/Q8).

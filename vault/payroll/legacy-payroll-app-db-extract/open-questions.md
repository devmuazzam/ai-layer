---
title: Legacy Payroll App - direct answers to the 11 open questions (boom length, minimums, shift, rest, CA OT, base rates, absent premiums, ADP, week/day, tests)
source: user-supplied/PAYROLL_CALC_EXTRACT.zip (generated 2026-08-18 on the client machine from TCG_PayrollAPP + c:/projects/tcg-payroll-api)
migrated: 2026-08-18
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
topics: [payroll, legacy-payroll-app, payroll-rule]
entities: [payroll-rule]
part_of: payroll/legacy-payroll-app-db-extract/INDEX.md
---

> Part of the 2026-08-18 read-only extract of the live legacy database `TCG_PayrollAPP`
> (`localhost\SQLEXPRESS`, SQL Server 2025 Express). Line anchors like `sql\app\x.PROC.sql:12-20`
> refer to the verbatim definitions in [sql/](sql/) (backslashes → forward slashes). Employee
> identifiers are masked `E***NN`. Nothing that writes was executed to produce this.

# OPEN QUESTIONS (Part E) — direct answers

Answers are anchored to code in `sql/...` and rule rows in `data/...`. "Not in this system" is stated
explicitly where true.

## 1. Boom-length (feet) logic, oiler vs operator boom rate, exclusion of travel/curfew from boom pay?
- **Boom length:** present ONLY as a craft-modifier code bracket that resolves to a flat per-hour adder.
  Modifier codes `OP-BP-01..18` (Operator) and `OI-BP-01..15` (Oiler) describe 20-foot bands
  (080-100Ft … 421-440Ft) and each maps to `FMS_UNION_CRAFT_MODIFIER.PayRateChange`
  (`data/_A3b_craft_boom_and_exception_templates.md`). There is **no numeric feet arithmetic, no jib logic,
  no lattice branch** anywhere in the priced code path — a full-text search of every dumped definition for
  `foreman|military|davis|lattice|LATT|hazmat|hazard|prevailing|curfew|travel|jib|feet` returned **no
  matches**.
- **Oiler vs operator:** distinguished only by the `OI-` vs `OP-` code prefix and its (smaller) oiler adder;
  no separate operator/oiler code branch — the difference is the resolved `PayRateChange`
  (`sql/app\v_Base_LaborPayroll.VIEW.sql:39`, engine `sql/app\usp_Run_Pricing_Engine.PROC.sql:905-911`).
- **Travel / curfew exclusion:** none. The boom window is `StartWorkTime→EndWorkTime` (fallback
  `ArrivedJob→LeftJob`); there is no travel/curfew carve-out.
- **Related finding:** the boom adder is only applied to `L12%` crafts. Non-L12 crafts that carry a boom
  modifier (e.g. `HDR-A`) accrue boom *hours* but **$0 boom premium** — the one failing regression check
  (see Q11).

## 2. Actual MinimumHours per guarantee rule; is LONG_BOOM_MIN_4 really 4 hours?
From `data/cfg.GuaranteedHoursRule.md`: **DAILY_MIN_4 = 4.00**, **HOLIDAY_MIN_8 = 8.00**,
**LONG_BOOM_MIN_4 = 4.00**, **SPECIAL_SAT_MIN_8 = 8.00**. Yes — LONG_BOOM_MIN_4 is 4 boom hours.
Caveat (see B5): `app.usp_Apply_GuaranteedHours` **hard-codes** 4/8/4/8 and the multipliers as literals; the
`cfg.GuaranteedHoursRule.MinimumHours`/`DefaultMultiplier` columns are not read into the calculation — the
table is used only for `IsEnabled` and `BoomNoModifierTreatment`. The effective values nonetheless equal the
config.

## 3. Shift-2 and shift-3 Premium_Hourly_Add and paid-hours rules?
From `data/cfg.Union_Shift_Rules.md`: Shift **1** = +0.00/h (work 8 paid 8); Shift **2** = **+3.00/h**, work
**7** paid **8** (`Is_Base_Rate_Modifier = 1`); Shift **3** = **+4.00/h**, work **6.5** paid **8**
(`Is_Base_Rate_Modifier = 1`). The +$/h premium is embedded per-slice in the engine (`Rate_Shift`) and the
"work→paid" delta (+1h for shift 2, +1.5h for shift 3) is added by `app.usp_Apply_ShiftDifferentialHoursAdd`
as `SHIFT_2_HOURS_ADD`/`SHIFT_3_HOURS_ADD` (B4).

## 4. RequiredRestHours and OTFloorMultiplier?
From `data/cfg.RestPeriod_Rule.md` (row `PunitiveUntil8Off`): **RequiredRestHours = 8.00**,
**OTFloorMultiplier = 1.50**, StitchGapMinutes = 30, TriggerMode = `HrsOTDTPositive`. A rest premium is
forced when the prior chain had OT/DT and the off-gap was < 8h; forced slices are floored to ×1.50 (or ×2.0
past the 12h DT limit) and the multiplier delta is paid as `REST_PERIOD_PREMIUM` (B6).

## 5. CA non-union thresholds/multipliers and where stored?
`app.usp_Apply_CA_NonUnionAdminHourly_OT` — thresholds are **hard-coded in the proc** (no config table):
- Daily: 0–8h straight; **>8 to 12h → OT ×1.50**; **>12h → DT ×2.00**.
- Weekly: **>40 straight-time hours → weekly OT ×1.50** (workweek = Saturday→Friday).
- **7th consecutive worked day**: first 8h → OT ×1.50; beyond 8h → DT ×2.00.
- Rate used = `Employee.PayRate`. Hours land in the six `NONUNION_CA_NONEXEMPT_*` component codes; the
  union-style buckets/adds are cleared for these rows (B9). Group membership `Non-Union Admin Hourly` is
  derived in `api.v_UI_Employee_PayrollGroupRate` / `v_UI_Employee_TypeRate`.

## 6. Standard_Start_Time, Standard_End_Time, Standard_Hours_Daily, DoubleTime_Threshold_Daily, and all multipliers in cfg.Union_Master_Rules?
From `data/cfg.Union_Master_Rules.md` (single row, UnionCode `L12`):
Standard_Start_Time **06:00**, Standard_End_Time **17:00**, Standard_Hours_Daily **8.0**,
DoubleTime_Threshold_Daily **12.0**, OT_Multiplier **1.50**, DT_Multiplier **2.00**,
Saturday_Multiplier **1.50**, Sunday_Multiplier **2.00**, Holiday_Multiplier **3.00**
(EffectiveDate 2025-07-01, ExpirationDate 2028-06-30).

## 7. Where do employee base rates come from (source table/column)? Is there a craft rate table? (printed)
- **Union field/mechanic (L12):** the employee-master `PayRate` is 0; the base rate is looked up by the
  **labor row's `CraftCode`** in **`FMS_UNION_CRAFT.PayRate`**
  (`sql/app\v_Base_LaborPayroll.VIEW.sql:35, 127-128`; engine prefers it when `CraftCode LIKE 'L12%'`).
- **Non-union admin (hourly/salary):** **`Employee.PayRate`** (`FMS_EMPLOYEES.PayRate`).
- `PayrollBaseRateSource` distribution (A3): `Labor.CraftCode → UNION_CRAFT.PayRate` 59,655 rows;
  `Employee.PayRate` 21,348; `Unknown / Needs Review` 5,725.
- **The craft rate table (`FMS_UNION_CRAFT`, UnionCode L12), printed** — note the `-A/-B/-C` suffix encodes
  straight / ×1.5 / ×2 variants of the same craft (the engine uses the `-A` base and applies its own
  multipliers):

| CraftCode | PayRate | | CraftCode | PayRate | | CraftCode | PayRate |
|---|---|---|---|---|---|---|---|
| HDR-A | 71.160 | | L12-G1-A | 66.030 | | L12-G6-A | 68.410 |
| HDR-B | 106.740 | | L12-G2-A | 66.180 | | L12-G7-A | 68.660 |
| HDR-C | 142.320 | | L12-G3-A | 67.870 | | L12-G8-A | 69.160 |
| HOLIDAY | 0.000 | | L12-G4-A | 67.990 | | L12-G9-A | 71.160 |
| L12-APP-A | 40.900 | | L12-G5-A | 68.160 | | SUB | 200.000 |

Apprentice steps `L12-APP1..6-A` run 40.90→61.34; `-B`/`-C` variants are 1.5×/2× the `-A` value
(e.g. L12-G8-A 69.16 / -B 103.74 / -C 138.32). Full 53-row table: `data/_A4_source_feed.md` (FMS_UNION_CRAFT)
plus this printout.

## 8. Anything for Foreman, Military/Davis-Bacon, Lattice boom, Hazmat — code, token, column, config row?
**Not in this system.** A full-text search of all 141 dumped programmable definitions for
`foreman|military|davis|lattice|LATT|hazmat|hazard|prevailing|curfew|travel|jib|feet|ft` returned **zero
matches** in code. The comment-token grammar (`app.v_LaborPayroll_CommentTokens`) recognizes only
`SHIFT_2, SHIFT_3, WTL_0..4, SUB_SHORT, SUB_LONG` — no `LATT_*`/foreman/hazmat tokens (B4). The only
boom-length concept is the `OP-BP/OI-BP` modifier-code feet brackets in the source reference tables, resolved
purely as a rate adder. No Davis-Bacon/prevailing-wage or certified-payroll rate logic is applied in the
calc (certified-payroll is carried only as a labels/flag, `v_Base_LaborPayroll` `UseCertifiedPayroll`).

## 9. What exactly is sent to ADP today, from where, in what layout, hours or dollars?
**Not on this machine** (see `OUTPUTS.md`). The .NET API (`c:\projects\tcg-payroll-api\Program.cs`, 15
endpoints) returns **JSON only — no endpoint emits a file** (no CSV/XLSX/stream, no `/export`/`/download`/
`/adp` route). None of the 13 `rpt.*` views is an ADP paydata layout. No `.xlsx/.pq/.m/.dtsx/.rdl` artefacts,
no SSIS/SSRS, and **no linked servers** exist on this box. The only ADP touchpoint here is the **ADP File
Number**, stored as an employee external identifier (`app.EmployeeExternalIdentifier`), read by the worklist
and written by `POST /employee-external-identifier`. The calculated hours **and** dollars live per-component
in `fms.Payroll_PayComponent` (`ComponentHours`, `ComponentAmount`, `IncludedInPayableGross`). Conclusion:
the ADP export workbook (the brief's `qPayrollComponents.m` / `tblCfgADPTempRates` / `4RZ` names point to an
Access/Excel+Power Query tool) lives **elsewhere** (a shared drive or the payroll clerk's PC) and consumes
this DB's component data + ADP File Number. **The payroll team should confirm where that workbook resides.**

## 10. What is a "week" (Sat–Fri?) and a "day" for daily rules?
- **Week = Saturday→Friday.** `app.fn_PayPeriodStart_SatFri` snaps any date back to the Saturday on/before
  it, using reference Saturday `2020-01-04` (`sql/app\fn_PayPeriodStart_SatFri.FN.sql:1-11`). The CA
  non-union weekly-OT boundary is the same Sat–Fri week (B9).
- **Day = calendar day, shift-anchored.** Time prep anchors punches to the row `WorkDate` and builds
  continuous chains broken by ≥8h gaps, with `Pricing_Date` = first WorkDate of the chain (B1). Daily OT/DT
  accumulates over the continuous shift from its actual start; each 30-min slice is day-typed by its own
  calendar day under the active `cfg.CrossMidnightDayTypePolicy = CalendarDay` (OT accumulation stays
  anchored to Day 1) (B2).

## 11. Which test.* procs currently pass? (run read-only)
Executed live (results in `data/_TEST_RESULTS.md`):
- **`test.usp_RunAll_CorePayroll_Tests` — ALL PASS.** DailyOTDT_Split (83338: ST8/OT4/DT1 ✓); Holiday_Min8
  (86102 ✓); SpecialSaturday_Min8 (86498 ✓); SundayPremium_Bucket (78294: 8.5h all DT ✓);
  RestPeriod_Cases (gap 150 min ✓); CrossMidnight_DayTypePolicy for **both** `CalendarDay` and `AnchorFloor`
  (10/10 each ✓).
- **`test.usp_RunAll_CurrentPayrollRegression_Checkpoint` — 7 of 8 sub-suites pass; overall FALSE** due to
  one sub-suite:
  - CorePayrollScenario_Baseline **16/16 pass**; TimeSourceConsistency **5/5**; SliceViewAlignment
    **16/16**; JobTicketStatus + LaborEntryUIDisplay **16/16**; 
  - **BoomBreakdown_Tests 7/9 — FAIL** on scenarios 82951 (NORMAL_SATURDAY) and 83282 (WEEKDAY_OT_ONLY),
    both craft `HDR-A` with modifier `OP-BP-07`: "Payable slice boom hours do not match calculated actual
    boom hours" — because `HDR-A` is not `L12%`, boom hours are counted but no boom premium is priced (Q1).
- **`test.usp_RunAll_PricingEngine_Tests` — NOT RUN (would violate read-only rules).** Its children
  `test.usp_Test_PricingEngine_HoursOnly` and `_TicketedDay` both `EXEC app.usp_Run_Pricing_Engine`
  (`sql/test\usp_Test_PricingEngine_HoursOnly.PROC.sql:35`, `..._TicketedDay.PROC.sql:12`), which writes
  `fms.Payroll_Calculated`/`fms.Payroll_CalcException`. **What I would have run:** `EXEC
  test.usp_RunAll_PricingEngine_Tests;` — it picks a recent hours-only day and a recent ticketed day,
  reprices just that day, and asserts `Errors=0 AND Warnings>=1` (hours-only → Shift_Assumed) and that a
  ticketed day produces boom/shift windows without errors. Not executed to honour the read-only mandate.

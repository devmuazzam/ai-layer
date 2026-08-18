---
title: Legacy Payroll App - how pay is calculated (B1-B12, verbatim SQL anchors)
source: user-supplied/PAYROLL_CALC_EXTRACT.zip (generated 2026-08-18 on the client machine from TCG_PayrollAPP + c:/projects/tcg-payroll-api)
migrated: 2026-08-18
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
topics: [payroll, legacy-payroll-app, pricing-engine, payroll-rule, boom, shift-differential, guaranteed-hours, rest-period, wtl, subsistence, ca-nonunion-ot, ledger]
entities: [pricing-engine, pay-component, craft-modifier, guaranteed-hours, rest-period, wtl, subsistence, payroll-group]
part_of: payroll/legacy-payroll-app-db-extract/INDEX.md
---

> Part of the 2026-08-18 read-only extract of the live legacy database `TCG_PayrollAPP`
> (`localhost\SQLEXPRESS`, SQL Server 2025 Express). Line anchors like `sql\app\x.PROC.sql:12-20`
> refer to the verbatim definitions in [sql/](sql/) (backslashes → forward slashes). Employee
> identifiers are masked `E***NN`. Nothing that writes was executed to produce this.

# CALCULATIONS — how pay is calculated in TCG_PayrollAPP

This document explains every formula, rule value, input read and output written in the TCG payroll
calculation, anchored to verbatim code in `sql/<schema>\<object>.<TYPE>.sql`. Rule values live in `data/cfg.*.md`
and `data/dim.*.md`; distinct code values in `data/_A3_distinct_codes.md` and
`data/_A3b_craft_boom_and_exception_templates.md`; source-feed shape in `data/_A4_source_feed.md`.
Employee identifiers are masked (`E***NN`), names as initials.

## The calculation pipeline at a glance
1. **Raw refresh** — `TCG_RawFMS` is refreshed and exposed to this DB through `src.*` synonyms (40 of them,
   pointing at `TCG_RawFMS.api.v_FMS_*` views). See B12 for how the refresh is triggered.
2. **Time preparation** (B1) — `app.usp_Prepare_Continuous_Labor` rebuilds `fms.Labor_PreProcessed`
   (30-min-rounded labor intervals). `calc.TicketTimeline` is populated with shift/boom windows from job
   tickets.
3. **Pricing engine** (B2) — `app.usp_Run_Pricing_Engine` cuts each labor entry into 30-minute slices,
   classifies day-type and OT/DT, and writes one row per `LaborPayrollID` to `fms.Payroll_Calculated`
   (`Act_Total_Hrs, Act_Boom_Hrs, Hrs_ST/OT/DT, Pay_Actual_Gross, Final_Gross_Pay`).
4. **Post-processors** (B4–B11), run in a fixed order by `app.usp_FinalizePayrollOutputs_AfterPricing` (B12):
   base-pay fallback → guaranteed hours → rest premium → suppress-when-rate-missing → CA non-union OT →
   rebuild pay-component ledger → non-union ledger → shift-differential hours add → WTL meal periods →
   ledger reconciliation → subsistence → rounding normalization.
5. **Output** — the .NET API serves JSON views over `fms.Payroll_*`; there is no file export on this machine
   (Part C / `OUTPUTS.md`).

**Two rate adders, one formula.** In the engine each 30-minute slice is priced as
`0.5 * Hourly_Rate_Raw * Final_Multiplier`, where
`Hourly_Rate_Raw = Rate_Base + Rate_Shift + (Is_Boom_Active ? Rate_Boom : 0)`. So the **shift differential**
and the **boom adder** are base-rate adders that ARE multiplied by the OT/DT/holiday day multiplier.
`Rate_Base` = `FMS_UNION_CRAFT.PayRate` (union) or `Source_Rate_Raw`; `Rate_Shift` =
`cfg.Union_Shift_Rules.Premium_Hourly_Add`; `Rate_Boom` = `FMS_UNION_CRAFT_MODIFIER.PayRateChange` (the
craft-modifier / boom-pole-length adder).

---


---

## B1 — Time preparation

### B1.1 `app.usp_Prepare_Continuous_Labor` — rebuild `fms.Labor_PreProcessed`

**Plain English.** A full destructive rebuild. It reads raw labor rows, throws away the *date* portion of the
punch times, re-anchors every punch to the row's `WorkDate`, resolves cross-midnight shifts, rounds to
30-minute boundaries (start **down**, end **up**), groups consecutive entries per employee into "continuous
labor chains" (a new chain starts after an 8-hour gap), and writes one row per valid source labor entry. It
does **not** create gap/ghost rows.

**Object:** `app.usp_Prepare_Continuous_Labor` — `sql/app\usp_Prepare_Continuous_Labor.PROC.sql:1-289`.
**Reads:** `src.FMS_LABOR_PAYROLL_Raw`. **Writes:** `fms.Labor_PreProcessed` (TRUNCATE + INSERT).

Full-rebuild + "no gap rows" is explicit in the header and body:
```
sql/app\usp_Prepare_Continuous_Labor.PROC.sql:3-6
    Rebuild fms.Labor_PreProcessed from raw labor rows, creating:
      - REAL worked labor rows only (one per valid source record)
    This procedure does NOT materialize "gap/ghost" rows.
sql/app\usp_Prepare_Continuous_Labor.PROC.sql:30
        TRUNCATE TABLE fms.Labor_PreProcessed;
```

**Rounding rule (start down / end up, 30 min).** Times are converted to seconds-of-day, then:
```
sql/app\usp_Prepare_Continuous_Labor.PROC.sql:117-129
    /* 4) Round Start DOWN and End UP to nearest 30-minute boundary (1800 seconds) */
        StartSecRoundedDown = (S.StartSecOfDay / 1800) * 1800
        EndSecRoundedUp     = ((X.EndSecAnchored + 1799) / 1800) * 1800
```

**Cross-midnight resolution.** Only the time-of-day of TimeStart/TimeEnd is trusted; the raw date is ignored.
If the end time-of-day is earlier than the start time-of-day, the end is anchored to `WorkDate + 1 day`
(add 86400 s):
```
sql/app\usp_Prepare_Continuous_Labor.PROC.sql:87-114
    WorkDate_Anchor = CAST(P.WorkDate AS date),
    StartTOD        = CAST(P.TimeStart AS time(7)),   -- time only (ignore raw date)
    EndTOD          = CAST(P.TimeEnd   AS time(7))
    ...
    EndSecAnchored = CASE ... WHEN S.EndSecOfDay < S.StartSecOfDay THEN S.EndSecOfDay + 86400 ELSE S.EndSecOfDay END
```
Only rows with `Pay_End > Pay_Start` and non-null WorkDate/TimeStart/TimeEnd survive
(`...PROC.sql:150-154`).

**What "continuous" means / chaining.** A new chain begins on the first row for an EmpID or when the gap from
the previous end to this start is **≥ 480 minutes (8 hours)**; `ChainGroup` is the running count of chain
starts; `Pricing_Date` is the **first `WorkDate` in the chain**:
```
sql/app\usp_Prepare_Continuous_Labor.PROC.sql:169-173   -- BreakFlag
    WHEN B.Prev_End IS NULL THEN 1
    WHEN DATEDIFF(MINUTE, B.Prev_End, B.Pay_Start) >= 480 THEN 1 ELSE 0
sql/app\usp_Prepare_Continuous_Labor.PROC.sql:211-216   -- Pricing_Date
    FIRST_VALUE(G.WorkDate) OVER (PARTITION BY G.EmpID, G.ChainGroup ORDER BY G.Pay_Start, G.LaborPayrollID ...)
```

**`Is_Gap_Row`.** This procedure always writes `Is_Gap_Row = 0` (`...PROC.sql:270`). The column exists in
`fms.Labor_PreProcessed` (see `ddl/fms.Labor_PreProcessed.sql`) but **this build never sets it to 1** — gap
hours are instead computed downstream by `calc.v_Calc_Labor_Timeline` and priced by
`app.usp_Apply_GuaranteedHours` (see B5). *Finding: the "gap row" materialisation described in older docs is
not present in the current proc.*

**Pricing_Date vs Actual_WorkDate.** `Actual_WorkDate` = the source `WorkDate` of the individual entry;
`Pricing_Date` = the WorkDate of the first entry in the continuous chain (`...PROC.sql:225-266`). Downstream
day-type/OT logic keys off `WorkDate` per row, but the chain anchor is preserved for continuity.

**Columns written** (`fms.Labor_PreProcessed`): `Original_LaborID, EmpID, JobCode, CraftCode, UnionCode,
Pricing_Date, Actual_WorkDate, Pay_Start, Pay_End, Total_Hrs (= DATEDIFF(MINUTE,Pay_Start,Pay_End)/60.0),
Is_Gap_Row (=0)` (`...PROC.sql:245-271`).

### B1.2 `calc.v_Calc_Labor_Timeline` — rounded timeline, gaps, overlap, chains

**Plain English.** A view over `fms.Labor_PreProcessed` (real rows only, `Is_Gap_Row = 0`) that re-rounds the
times, computes the gap to the previous entry, flags overlaps, and re-derives the continuous chain. This is
the "one-row-per-labor-entry timeline" the pricing engine consumes; it does **not** itself cut 30-minute
slices — slicing happens in the pricing engine (B2 STEP D).

**Object:** `calc.v_Calc_Labor_Timeline` — `sql/calc\v_Calc_Labor_Timeline.VIEW.sql:1-164`.

- Rounded times (start down, end up), same 30-min rule as B1.1 (`...VIEW.sql:24-31`).
- `Gap_Minutes_Raw` = minutes from previous `Pay_End_Rounded` to this `Pay_Start_Rounded` via LAG
  (`...VIEW.sql:58-70`); `Is_Overlap = 1` when `Gap_Minutes_Raw < 0` (`...VIEW.sql:78-83`); negative gaps are
  floored to 0 for `Gap_Minutes`/`Gap_Hours` (`...VIEW.sql:85-97`).
- `IsChainStart` when previous is NULL or `Gap_Minutes_Raw >= 480`; `ChainGroup` cumulative
  (`...VIEW.sql:99-119`); `ChainStart = MIN(Pay_Start_Rounded)` over the chain (`...VIEW.sql:158-162`).
- `Duration_Total_Payable = DATEDIFF(MINUTE, Pay_Start_Rounded, Pay_End_Rounded)/60.0`
  (`...VIEW.sql:138-143`) — used by the rest-period logic (B6).

### B1.3 Ticket windows — `calc.TicketTimeline`

Two procs populate `calc.TicketTimeline` (one row per JobTicketID). Shift windows are *audit/reference only*
for pricing (the engine prices from labor times, not ticket times — see B2 STEP C); boom windows drive boom
eligibility overlap.

**(a) `calc.usp_Upsert_TicketTimeline_ForTicketIDList`** — `sql/calc\usp_Upsert_TicketTimeline_ForTicketIDList.PROC.sql:1-136`.
Builds the **boom window** from job-ticket work times, anchored to `TicketDate`:
```
sql/calc\usp_Upsert_TicketTimeline_ForTicketIDList.PROC.sql:51-55
    T04_StartWorkTime = CAST(COALESCE(StartWorkTime, ArrivedJob) AS time(0)),
    T07_EndWorkTime   = CAST(COALESCE(EndWorkTime,   LeftJob)    AS time(0))
```
Day offsets add +1 day each time a later stamp rolls before an earlier one (cross-midnight,
`...PROC.sql:59-90`); `Boom_Window_Start` rounds down, `Boom_Window_End` rounds up to 30 min
(`...PROC.sql:91-102`). Only tickets with a valid `Act_BoomEnd > Act_BoomStart` are inserted
(`...PROC.sql:115-117`). It DELETEs then INSERTs the affected tickets (`...PROC.sql:122-134`).

**(b) `calc.usp_Apply_TicketWindows_FromJobTicketTimes`** — `sql/calc\usp_Apply_TicketWindows_FromJobTicketTimes.PROC.sql:1-149`.
Overlays **shift and boom windows** from the standardized TkTm slots (`calc.v_JobTicket_Times`):
```
sql/calc\usp_Apply_TicketWindows_FromJobTicketTimes.PROC.sql:13-19
      Shift:  Start = TkTm01 else TkTm02 (round down);  End = TkTm10 else TkTm09 (round up)
      Boom:   Start = TkTm04 else TkTm03 (round down);  End = TkTm07 else TkTm08 (round up)
```
where (`sql/calc\v_JobTicket_Times.VIEW.sql:4-20`) `TkTm01=TimeStart, TkTm02=YardOutTime,
TkTm03=ArrivedJob, TkTm04=StartWorkTime, TkTm07=EndWorkTime, TkTm08=LeftJob, TkTm09=YardInTime,
TkTm10=TimeEnd`. Cross-midnight adds +1 day (`...PROC.sql:99-107`); windows round start-down/end-up
(`...PROC.sql:117-131`); the source slot used is recorded in `Shift_Source_Start/End` and
`Boom_Source_Start/End`.

**What the `*_Source_*` values mean (observed distribution, from A3):**
- `Shift_Source_Start/End`: `TkTm01→TkTm10` (TimeStart→TimeEnd) in 28,777 of 28,799 tickets; rare fallbacks
  `TkTm01→TkTm09`, `TkTm02→TkTm10`.
- `Boom_Source_Start/End`: `TkTm03→TkTm08` (ArrivedJob→LeftJob) for all 28,799 rows — i.e. in practice
  `StartWorkTime`(TkTm04) and `EndWorkTime`(TkTm07) are usually NULL so the boom window falls back to
  ArrivedJob→LeftJob.

---

## B2 — The pricing engine `app.usp_Run_Pricing_Engine`

**Object:** `sql/app\usp_Run_Pricing_Engine.PROC.sql:1-1477`. Params `@WorkDateFrom`, `@WorkDateTo` (both
NULL = full rebuild). **Reads:** `app.v_Base_LaborPayroll`, `app.v_LaborPayroll_CommentTokens`,
`calc.v_Calc_Labor_Timeline`, `calc.TicketTimeline` (+ the two ticket-window procs), `cfg.Union_Master_Rules`,
`cfg.Union_Shift_Rules`, `cfg.Craft_MinimumPayPolicy`, `dim.LU12_Holiday`, `rpt.v_UI_Payroll_Reconstruction_Audit`.
**Writes:** `fms.Payroll_Calculated` (one row per LaborPayrollID), `fms.Payroll_CalcException`, `etl.RunLog`.

Concurrency guard: exclusive session applock `app.usp_Run_Pricing_Engine`; a second run THROWs 51000
(`...PROC.sql:25-34`). A `RunId` is taken from `SESSION_CONTEXT('PayrollAPP_RunLogID')` or a new `etl.RunLog`
row is created (`...PROC.sql:66-98`). `@IsRange = 1` when either bound is supplied; range runs
delete-by-range, full runs TRUNCATE (`...PROC.sql:44-59, 1290-1300`).

**STEP A — base set `#LP`** (`...PROC.sql:100-227`). Pulls labor rows in the WorkDate window from
`app.v_Base_LaborPayroll` joined to comment tokens. `Has_Boom_Modifier` = labor row has a non-empty
`CraftModifierCode` (`...PROC.sql:129-136`). `ShiftCode_ForPricing` = 1 if conflicting shift tokens else
`PayrollShiftCode_FromComments` (default 1) (`...PROC.sql:140-146`). Two DELETE passes drop zero-hour / no-time
placeholder rows (`...PROC.sql:174-224`).

**Minimum-pay eligibility `#MinPayPolicy`** (`...PROC.sql:229-243`): join `cfg.Craft_MinimumPayPolicy`,
default `ApplyMinimumPay = 1`. (ADMIN-A/B/C = 0, so admin crafts get no min-pay gap.)

**Exception passes** before pricing (`...PROC.sql:245-407`): housekeeping delete; `Warn_DuplicateWindow`
(same Emp + identical rounded start/end) `...PROC.sql:268-343`; `Warn_Overlap` (Prev_End > Start)
`...PROC.sql:345-407`.

**STEP B1 — shift window `#LaborAgg`** (`...PROC.sql:409-530`). One shift window per LaborPayrollID, chosen by
this precedence (`...PROC.sql:434-452`):
1. `Timeline` — MIN(Pay_Start_Rounded) / MAX(Pay_End_Rounded) from `calc.v_Calc_Labor_Timeline`.
2. `LaborTimes` — the row's own TimeStart/TimeEnd, rounded, cross-midnight-corrected (`...PROC.sql:458-498`).
3. `StdStart+Hours` — fallback: start at `Standard_Start_Time` (06:00) on WorkDate, length =
   `CEILING(HoursWorked_Raw*2)*30` minutes (`...PROC.sql:500-524`). This is the "Shift_Assumed" case.

`#RestMeta` (`...PROC.sql:626-661`): `Is_RestRule_Active = 1` when there is an overlap, or the previous gap is
in `[0, 480)` minutes — used to switch the pre-6AM ST-bank behaviour.

**STEP B2 — ticket windows `#TicketAgg`** (`...PROC.sql:663-731`). Calls `usp_Upsert_TicketTimeline...` then
`usp_Apply_TicketWindows...` for the run's ticket IDs, then reads valid Shift/Boom windows from
`calc.TicketTimeline`. **STEP B2.5** writes `Shift_Start NULL` / `Shift_End NULL` / `Shift_End <= Shift_Start`
exceptions (`...PROC.sql:733-821`).

**STEP C — `#RawRange`** (`...PROC.sql:823-963`) assembles the per-entry pricing inputs. Key rules:
- **Pricing shift window = labor only** (`Shift_Start/End = LA.Shift_Start/End`); ticket shift windows are
  carried as `JT_*` for audit only (`...PROC.sql:847-855`).
- **Boom window carried only when the labor row has a modifier** (`...PROC.sql:857-876`):
  `Boom_Eligible = Has_Boom_Modifier`; `Boom_Start/End = TA.Boom_*` only if `Has_Boom_Modifier=1`.
- **Rate_Base** (`...PROC.sql:884-901`): `CraftPayRate` (= `FMS_UNION_CRAFT.PayRate`) when `CraftCode LIKE
  'L12%'` and non-null; else `Source_Rate_Raw`.
- **Rate_Shift** = `Union_Shift_Rules.Premium_Hourly_Add` for the pricing shift code (`...PROC.sql:903`,
  join `...PROC.sql:947-949`).
- **Rate_Boom** (`...PROC.sql:905-911`): `CraftModifierPayRateAdjustment` (= `FMS_UNION_CRAFT_MODIFIER.PayRateChange`,
  the **ST** adder) when `L12` and has modifier; else 0.
- **Multipliers** from `cfg.Union_Master_Rules` (OT 1.50, DT 2.00, Sat 1.50, Sun 2.00), holiday from
  `dim.LU12_Holiday.PayRateMultiplier` else Master `Holiday_Multiplier` 3.00 (`...PROC.sql:920-925`).
- **Limits**: `Limit_Reg = Standard_Hours_Daily` (8), `Limit_OT = DoubleTime_Threshold_Daily` (12)
  (`...PROC.sql:927-928`). Standard window `Cfg_Start_Time` 06:00, `Cfg_End_Time` 17:00 (`...PROC.sql:917-918`).
- **Special Saturday** computed in-engine: `MONTH IN (6,12) AND weekday = Saturday AND DAY <= 7`
  (`...PROC.sql:930-936`).

**STEP D — 30-minute slices `#CalculatedSlices`** (`...PROC.sql:965-1143`). A bounded tally (≤500 slices)
expands each `#RawRange` window into 30-min slices where `DATEADD(minute,30*N,Shift_Start) < Shift_End`
(`...PROC.sql:1133-1134`). Per slice:
- `Is_Boom_Active` = boom-eligible AND slice fully inside `[Boom_Start, Boom_End]` (`...PROC.sql:986-993`).
- `Is_Outside_Window` = slice time-of-day `< 06:00` or `>= 17:00` (`...PROC.sql:996-1000`).
- `Accumulation_Status` = `DT_Daily` when `(N+1)*0.5 > 12`; else `OT_Daily` when weekday cumulative hours
  exceed 8 (with a special pre-6AM ST-bank rule modulated by `Is_RestRule_Active`); else `Reg_Daily`
  (`...PROC.sql:1056-1114`).
- `Day_Type` ∈ `SPECIAL_SAT | HOLIDAY | SUNDAY | SATURDAY | WEEKDAY` (`...PROC.sql:1116-1122`).

**Cross-midnight day-type policy.** The active `cfg.CrossMidnightDayTypePolicy = CalendarDay`: each slice is
rated by its own calendar day-type but OT accumulation stays anchored to the shift's Day 1 (matches the
in-engine per-slice Day_Type with cumulative `(N+1)*0.5` OT counting).

**STEP E — final rates & aggregation** (`...PROC.sql:1145-1277`).
- `Final_Multiplier` (`...PROC.sql:1157-1167`): HOLIDAY→`Mul_Hol`(3); SUNDAY→`Mul_Sun`(2); SPECIAL_SAT→
  `Mul_DT`(2); `DT_Daily`→`Mul_DT`(2); weekday `Is_Outside_Window`→`Mul_OT`(1.5); prev-day ST re-entry
  block→`Mul_OT`; `OT_Daily`→`Mul_OT`; SATURDAY→`Mul_Sat`(1.5); else 1.0.
- **Per-slice hourly rate** (`...PROC.sql:1168-1170`):
  `Hourly_Rate_Raw = Rate_Base + Rate_Shift + (Is_Boom_Active ? Rate_Boom : 0)`.
- **Per-slice pay** and aggregation to one row per LaborPayrollID (`...PROC.sql:1176-1196`):
  - `Act_Total_Hrs = SUM(0.5)`; `Act_Boom_Hrs = SUM(0.5 where Is_Boom_Active)`.
  - **`Pay_Actual_Gross = SUM(0.5 * Hourly_Rate_Raw * Final_Multiplier)`** (`...PROC.sql:1181`).
  - `Hrs_ST = SUM(0.5 where Final_Multiplier = 1.0)`; `Hrs_OT = SUM(0.5 where = Mul_OT)`;
    `Hrs_DT = SUM(0.5 where >= Mul_DT)` (`...PROC.sql:1182-1184`). **Consequence:** Sunday(×2),
    Special Saturday(×2) and Holiday(×3) hours all land in the **DT bucket** (they are `>= Mul_DT`), which is
    why the test scenarios show Sunday/Special-Sat hours as `Hrs_DT`.

Gap/guarantee fields are set to 0 here; `Audit_Min_Rule = 0.0`, `Audit_Gap_Mult = 1.0`; guaranteed hours are
applied later by `app.usp_Apply_GuaranteedHours` (B5) (`...PROC.sql:1240-1255`). `Final_Gross_Pay =
Pay_Actual_Gross` at this stage (`...PROC.sql:1251`).

**STEP F — load** into `fms.Payroll_Calculated` in a short transaction (`...PROC.sql:1282-1326`), then **F.5**
appends reconstruction-audit warnings from `rpt.v_UI_Payroll_Reconstruction_Audit`
(`Warn_Reconstruction_ShiftMismatch`, `Warn_Reconstruction_Possible24Plus`, and the combined form)
(`...PROC.sql:1328-1431`).

**Every `fms.Payroll_CalcException.Reason` the engine can raise** (with condition):
| Reason | Where | Condition |
|---|---|---|
| `Warn_DuplicateWindow (Cnt=..;Start=..;End=..)` | `:307-343` | same Emp + identical rounded Start/End (dup labor rows) |
| `Warn_Overlap (PrevLPID=..;PrevEnd=..;GapMinRaw=..)` | `:369-407` | this start < previous rounded end (negative gap) |
| `Shift_Assumed (StdStart+HoursWorked)` | `:535, 601-622` | shift window fell back to StdStart+Hours |
| `Shift_Assumed (LaborTimesInvalid End<=Start)` | `:536, 543-546` | labor times invalid, window assumed |
| `Shift_Start NULL` / `Shift_End NULL` / `Shift_End <= Shift_Start` | `:762-766, 800-814` | no usable shift window |
| `Warn_Reconstruction_ShiftMismatch` / `_Possible24Plus` / combined | `:1357-1366` | labor-vs-ticket shift mismatch or >24h reconstruction |
(Observed counts per template are in `data/_A3b_craft_boom_and_exception_templates.md`.)

---

## B3 — Craft modifiers and boom pay

### B3.1 Where CraftCode and CraftModifierCode come from
Both are per-labor-row columns on `src.FMS_LABOR_PAYROLL_Raw` (`CraftCode`, `CraftModifierCode`), surfaced by
`app.v_Base_LaborPayroll` (`sql/app\v_Base_LaborPayroll.VIEW.sql:33, 37`). Their rate meanings resolve there:
```
sql/app\v_Base_LaborPayroll.VIEW.sql:35        UC.PayRate AS CraftPayRate,                     -- FMS_UNION_CRAFT.PayRate (base)
sql/app\v_Base_LaborPayroll.VIEW.sql:39        UCM.PayRateChange AS CraftModifierPayRateAdjustment,  -- FMS_UNION_CRAFT_MODIFIER.PayRateChange (ST boom adder)
sql/app\v_Base_LaborPayroll.VIEW.sql:127-133   JOIN FMS_UNION_CRAFT UC ON CraftCode ;  JOIN FMS_UNION_CRAFT_MODIFIER UCM ON CraftModifierCode AND UnionCode
```

**Full modifier list (boom-pole length brackets).** Craft modifiers ARE boom-length brackets. `OP-BP-##` =
Operator, `OI-BP-##` = Oiler, in 20-foot bands from 080-100Ft up to 421-440Ft, each with a `PayRateChange`
ST adder (and unused `PayRateChangeOT`/`PayRateChangeDB` columns in source). Full list with descriptions and
`PayRateAdjustment` values is in `data/_A3b_craft_boom_and_exception_templates.md` (33 rows). Examples:
`OP-BP-01` 080-100Ft-Operator = 0.750; `OP-BP-06` 181-200Ft-Operator = 4.500; `OI-BP-01` 080-100Ft-Oiler =
0.250; `OI-BP-06` 181-200Ft-Oiler = 1.500. Source per-code OT/DB variants (e.g. OP-BP-01: PayRateChange 0.750
/ OT 1.125 / DB 1.500) exist in `src.FMS_UNION_CRAFT_MODIFIER_Raw` but are **not** read — the engine and the
UI both take the ST `PayRateChange` and multiply it by the day multiplier.

### B3.2 BoomEligible and BoomDisplayStatus
`BoomEligible` / `HasCraftModifier` = the labor row has a non-empty `CraftModifierCode`
(`sql/api\v_UI_LaborEntry_BoomBreakdown.VIEW.sql:124-138`; same test as the engine's `Has_Boom_Modifier`).
The 8 `BoomDisplayStatus` branches (`...BoomBreakdown.VIEW.sql:202-235`), observed counts from A3:
| BoomDisplayStatus | Condition (quoted logic) |
|---|---|
| `No boom modifier` | no modifier AND Act_Boom_Hrs=0 AND Gap_Hrs_Boom=0 (`:213-216`) |
| `Ticket boom window only - no modifier` | no modifier AND Slice_Boom_Window_Hrs>0 (`:209-211`) |
| `Review: calculated boom hours without modifier` | no modifier AND Act_Boom_Hrs>0 AND Boom_Actual_Add_Amt=0 (`:204-207`) |
| `Boom actual` | modifier present AND Act_Boom_Hrs>0 (`:223-225`) |
| `Boom actual + gap` | modifier present AND Act_Boom_Hrs>0 AND Gap_Hrs_Boom>0 (`:218-221`) |
| `Boom gap` | modifier present AND Gap_Hrs_Boom>0 (`:227-229`) |
| `Modifier present, no boom hours` | modifier present, no actual/gap boom hours (`:231-232`) |
| `Review` | fallthrough (`:234`) |

### B3.3 Boom hours and amounts
Computed in `api.v_UI_LaborEntry_BoomBreakdown` over the advanced slice view
`api.v_UI_Pricing_Slices_Advanced`:
- **`Act_Boom_Hrs`** (in `fms.Payroll_Calculated`) = engine sum of boom-active slice half-hours (B2 STEP E).
- **`Ticket_Boom_Window_Hrs`** = ticket boom-window duration `DATEDIFF(MINUTE,Boom_Window_Start,End)/60`
  (`...BoomBreakdown.VIEW.sql:147-156`) — reference only.
- **`Slice_Boom_Window_Hrs`** = slice hours where `Is_Boom_Active=1` (`...VIEW.sql:23-24`).
- **`Slice_Boom_Hrs`** = slice hours where `Is_Boom_Active=1 AND Rate_Boom_Applied<>0` (payable)
  (`...VIEW.sql:26-33`).
- **`Boom_Actual_Add_Amt`** = `SUM(Rate_Boom_Applied * Slice_Hours * Final_Multiplier)` over payable boom
  slices (`...VIEW.sql:35-45`). **So the boom adder IS multiplied by the OT/DT/day multiplier.**
- **`Boom_Gap_Add_Amt`** = `Gap_Hrs_Boom * CraftModifierPayRateAdjustment * Audit_Gap_Mult`
  (`...VIEW.sql:173-178`).
- **`Boom_Total_Add_Amt`** = `Boom_Actual_Add_Amt + Boom_Gap_Add_Amt` (`...VIEW.sql:180-188`).
- **`RateBoomUsed`** = `Rate_Boom_Applied` = the modifier `PayRateChange` on payable boom slices;
  `Boom_Rate_Min/Max`, `Boom_Multiplier_Min/Max` expose its range (`...VIEW.sql:47-81`).

**Is boom a per-hour adder or a rate switch?** A per-hour **adder on top of base** (`Rate_Base + Rate_Shift +
Rate_Boom`), applied only on slices inside the ticket boom window, and multiplied by the day/OT/DT multiplier.
It is not a rate replacement.

### B3.4 Boom length / operator-vs-oiler / travel-curfew
- **Boom length (feet):** present only as the modifier-code bracket → `PayRateChange` lookup. There is **no**
  numeric feet computation, jib logic, or lattice-specific branch anywhere in the priced path (see also E1/E8).
- **Operator vs Oiler:** encoded in the modifier code prefix (`OP-BP-*` vs `OI-BP-*`) with different adder
  values; the oiler pays a smaller adder. There is no separate operator/oiler code branch — the difference is
  entirely the resolved `PayRateChange`.
- **Travel / curfew exclusion:** none. The boom window is `StartWorkTime→EndWorkTime` (falling back to
  ArrivedJob→LeftJob), i.e. on-job work time; there is no travel/curfew carve-out in the boom overlap logic.

### B3.5 `LONG_BOOM_MIN_4` guarantee and `@BoomNoModifierTreatment`
`cfg.GuaranteedHoursRule` row `LONG_BOOM_MIN_4`: `ScopeBasis=ShiftAnchorDate`, `GroupScope=EmployeeShiftBoom`,
`MinimumHours=4.00`, `PayComponent=BoomOnly`, `DefaultMultiplier=NULL`, `BoomNoModifierTreatment=EXCLUDE_NO_MODIFIER`.
It guarantees a minimum of 4 **boom** hours per shift. `EXCLUDE_NO_MODIFIER` means a labor entry with no craft
modifier code is excluded from the boom-guarantee qualifying set (a boom minimum is not manufactured for
non-boom work). Detailed mechanics (qualifying-hours count, `LastEligibleBoomEntryInShift` allocation, gap
pricing at `RateBoomUsed × MultiplierUsed`) are in **B5**. Observed `MultiplierUsed` on boom-guarantee groups:
1.00 (2,955 groups), 1.50 (1,026), 2.00 (128) — i.e. the boom-gap top-up is priced at the day multiplier of
the anchoring slice.

### B3.6 Employee_CraftCode vs Labor_CraftCode mismatch
`CraftCodeMismatchFlag` compares the employee-master craft to the labor-row craft (23,643 of 86,728 rows =
True; see A3b). **Labor wins**: the pricing engine and `v_Base_LaborPayroll` resolve `CraftPayRate` and the
modifier adder from the **labor row's** `CraftCode`/`CraftModifierCode`
(`sql/app\usp_Run_Pricing_Engine.PROC.sql:884-911`, `sql/app\v_Base_LaborPayroll.VIEW.sql:33-39`). The
employee-master craft is surfaced only as a review/mismatch flag in `api.v_UI_LaborEntry_TypeRateResolution`
and the WithBuckets view.


---

## B4 — Shift differential (2nd / 3rd shift)

Shift differential in TCG has **two independent mechanisms** that both key off the same comment-derived shift code:

1. **The per-slice rate adder ("SD Rate Add", ledger `ACTUAL / ACTUAL_SHIFT_DIFFERENTIAL`)** — the pricing engine (`app.usp_Run_Pricing_Engine`) folds the union's `Premium_Hourly_Add` into every worked slice's hourly rate, so it is multiplied by the OT/DT/day multiplier. (Section c.)
2. **The paid-hours add ("SD Hrs Add", ledger `SHIFT_DIFFERENTIAL / SHIFT_2_HOURS_ADD` / `SHIFT_3_HOURS_ADD`)** — the post-processor `app.usp_Apply_ShiftDifferentialHoursAdd` adds the extra *paid* hours a short shift is credited (2nd shift works 7 but is paid 8 → +1 hr; 3rd shift works 6.5 but is paid 8 → +1.5 hr) as a separate ledger component. (Sections d, e.)

Both mechanisms depend on the token detection in `app.v_LaborPayroll_CommentTokens` (Section a) and the config in `cfg.Union_Shift_Rules` (Section b).

---

### (a) Token grammar — `app.v_LaborPayroll_CommentTokens`

**Objects:** `app.v_LaborPayroll_CommentTokens` (view), sourcing `src.FMS_LABOR_PAYROLL_Raw.Comments` de-RTF'd via `app.fn_StripRTF`.

**Comment source column & cleaning.** The raw comment column is `src.FMS_LABOR_PAYROLL_Raw.Comments`. It is stripped of RTF, trimmed, and `NULLIF`'d to NULL when empty:

```sql
    LaborComments_Raw =
        TRY_CONVERT(nvarchar(max), p.Comments),

    LaborComments_Clean =
        NULLIF
        (
            LTRIM
            (
                RTRIM
                (
                    TRY_CONVERT
                    (
                        nvarchar(max),
                        app.fn_StripRTF(TRY_CONVERT(nvarchar(max), p.Comments))
                    )
                )
            ),
            N''
        )
FROM src.FMS_LABOR_PAYROLL_Raw p
```
`sql/app\v_LaborPayroll_CommentTokens.VIEW.sql:16-35`

**Search normalization.** Matching is done against an UPPER-cased copy in which non-breaking-space (`CHAR(160)`), tab (`CHAR(9)`), CR (`CHAR(13)`) and LF (`CHAR(10)`) are all replaced with a single space; it falls back `Clean → Raw → ''`:

```sql
    LaborComments_Search =
        UPPER
        (
            REPLACE
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            COALESCE(r.LaborComments_Clean, r.LaborComments_Raw, N''),
                            CHAR(160),
                            N' '
                        ),
                        CHAR(9),
                        N' '
                    ),
                    CHAR(13),
                    N' '
                ),
                CHAR(10),
                N' '
            )
        )
```
`sql/app\v_LaborPayroll_CommentTokens.VIEW.sql:42-66`

**Token detection.** Every flag is a `LIKE` test (there is no regex / no CHARINDEX in this view) accepting **both** a `(PAY:TOKEN)` form and a bare `(TOKEN)` form:

- `Has_SHIFT_2` — `LIKE N'%(PAY:SHIFT_2)%' OR LIKE N'%(SHIFT_2)%'` — `sql/app\v_LaborPayroll_CommentTokens.VIEW.sql:74-81`
- `Has_SHIFT_3` — `LIKE N'%(PAY:SHIFT_3)%' OR LIKE N'%(SHIFT_3)%'` — `sql/app\v_LaborPayroll_CommentTokens.VIEW.sql:83-90`
- `Has_SUB_SHORT` — `LIKE N'%(PAY:SUB_SHORT)%' OR LIKE N'%(SUB_SHORT)%'` — `sql/app\v_LaborPayroll_CommentTokens.VIEW.sql:92-99`
- `Has_SUB_LONG` — `LIKE N'%(PAY:SUB_LONG)%' OR LIKE N'%(SUB_LONG)%'` — `sql/app\v_LaborPayroll_CommentTokens.VIEW.sql:101-108`
- `Has_WTL_0..4` — `LIKE N'%(PAY:WTL_n)%' OR LIKE N'%(WTL_n)%'` — `sql/app\v_LaborPayroll_CommentTokens.VIEW.sql:110-153`
- `Has_WTL_Legacy` — `LIKE N'%(PAY:WTL)%' OR LIKE N'%(WTL)%'` — `sql/app\v_LaborPayroll_CommentTokens.VIEW.sql:155-162`

Verbatim, the two shift patterns (the ones that drive shift differential):

```sql
        Has_SHIFT_2 =
            CONVERT(bit,
                CASE
                    WHEN n.LaborComments_Search LIKE N'%(PAY:SHIFT_2)%'
                      OR n.LaborComments_Search LIKE N'%(SHIFT_2)%'
                    THEN 1 ELSE 0
                END
            ),

        Has_SHIFT_3 =
            CONVERT(bit,
                CASE
                    WHEN n.LaborComments_Search LIKE N'%(PAY:SHIFT_3)%'
                      OR n.LaborComments_Search LIKE N'%(SHIFT_3)%'
                    THEN 1 ELSE 0
                END
            ),
```
`sql/app\v_LaborPayroll_CommentTokens.VIEW.sql:74-90`

**Note on `LATT_*`:** searched for; **not found**. There is no `LATT_`, `LATT_*`, or any `LATT` token anywhere in `app.v_LaborPayroll_CommentTokens`. The only tokens the view recognizes are `SHIFT_2`, `SHIFT_3`, `SUB_SHORT`, `SUB_LONG`, `WTL_0..4`, and legacy `WTL`.

**`Has_ConflictingShiftTokens`** — set to 1 only when BOTH shift tokens are present on the same entry:

```sql
    Has_ConflictingShiftTokens =
        CONVERT(bit,
            CASE
                WHEN Has_SHIFT_2 = 1 AND Has_SHIFT_3 = 1
                THEN 1 ELSE 0
            END
        ),
```
`sql/app\v_LaborPayroll_CommentTokens.VIEW.sql:270-276`

(For completeness, the WTL analogue `Has_ConflictingWTLTokens` — >1 of WTL_0..4, or legacy WTL together with any numbered WTL — is at `sql/app\v_LaborPayroll_CommentTokens.VIEW.sql:210-236`. There is no combined SHIFT×WTL conflict flag.)

**`PayrollShiftCode_FromComments`** — an `int` that can take values **3, 2, or 1** (3 wins over 2; default 1 = day shift). Note that when both tokens are present this expression alone would return 3, so consumers must gate on `Has_ConflictingShiftTokens` separately (the pricing engine does — see Section c):

```sql
    PayrollShiftCode_FromComments =
        CASE
            WHEN Has_SHIFT_3 = 1 THEN 3
            WHEN Has_SHIFT_2 = 1 THEN 2
            ELSE 1
        END,
```
`sql/app\v_LaborPayroll_CommentTokens.VIEW.sql:278-283`

(Subsistence's parallel field `SubsistenceCode_FromComments` returns `'SUB_LONG' / 'SUB_SHORT' / NULL` at `sql/app\v_LaborPayroll_CommentTokens.VIEW.sql:285-290`.)

---

### (b) Config rows — `cfg.Union_Shift_Rules` (3 rows, UnionCode L12)

From `data/cfg.Union_Shift_Rules.md:1-7`:

| ShiftRuleID | UnionCode | ShiftCode | Description | Premium_Hourly_Add | Is_Base_Rate_Modifier | Full_Shift_Work_Hours | Full_Shift_Paid_Hours |
|---|---|---|---|---|---|---|---|
| 1 | L12 | 1 | Standard Day Shift | 0.00 | False | 8.0 | 8.0 |
| 2 | L12 | 2 | Second Shift | 3.00 | True | 7.0 | 8.0 |
| 3 | L12 | 3 | Third Shift | 4.00 | True | 6.5 | 8.0 |

- **`Premium_Hourly_Add`** — the hourly rate adder folded into the per-slice rate by the engine (Section c): Shift 1 +0.00, Shift 2 +3.00, Shift 3 +4.00.
- **`Is_Base_Rate_Modifier`** — 0 for day shift, 1 for 2nd/3rd shift (marks the premium as a base-rate modifier, i.e. multiplied by OT/DT).
- **`Full_Shift_Work_Hours` / `Full_Shift_Paid_Hours`** — the worked-vs-paid gap that the SD **Hrs Add** monetizes: Shift 2 works 7 / paid 8 (gap 1.0), Shift 3 works 6.5 / paid 8 (gap 1.5), Shift 1 works 8 / paid 8 (gap 0). These raw config gaps match the hard-coded `ShiftAddHours` constants in the proc (Section d) — the proc does not read these columns at runtime, it hard-codes 1.00 / 1.50.

---

### (c) SD Rate Add — how `RateShiftUsed` / `ACTUAL_SHIFT_DIFFERENTIAL` is applied per slice

**Object:** `app.usp_Run_Pricing_Engine`.

The comment shift code becomes `ShiftCode_ForPricing`, which forces day shift (1) whenever the tokens conflict, otherwise takes `PayrollShiftCode_FromComments`:

```sql
            ShiftCode_ForPricing =
                CONVERT(int,
                    CASE
                        WHEN ISNULL(CT.Has_ConflictingShiftTokens, 0) = 1 THEN 1
                        ELSE ISNULL(CT.PayrollShiftCode_FromComments, 1)
                    END
                ),
```
`sql/app\usp_Run_Pricing_Engine.PROC.sql:140-146`

That code joins `cfg.Union_Shift_Rules` (alias `S`) on `UnionCode='L12'` and `ShiftCode = ShiftCode_ForPricing`:

```sql
        LEFT JOIN cfg.Union_Shift_Rules S
          ON S.UnionCode = 'L12'
         AND S.ShiftCode = ISNULL(P.ShiftCode_ForPricing, 1)
```
`sql/app\usp_Run_Pricing_Engine.PROC.sql:947-949`

`Rate_Shift` on each slice is the union's `Premium_Hourly_Add`:

```sql
            Rate_Shift = ISNULL(S.Premium_Hourly_Add, 0.00),
```
`sql/app\usp_Run_Pricing_Engine.PROC.sql:903`

At final pricing, `Rate_Shift` is **added into `Hourly_Rate_Raw` alongside base and boom**, and that combined raw rate is then multiplied by `Final_Multiplier`:

```sql
                (COALESCE(Rate_Base,0.00) + COALESCE(Rate_Shift,0.00)
                    + CASE WHEN Is_Boom_Active = 1 THEN COALESCE(Rate_Boom,0.00) ELSE 0.00 END
                ) AS Hourly_Rate_Raw,
```
`sql/app\usp_Run_Pricing_Engine.PROC.sql:1168-1170`

Slice pay is `0.5 * Hourly_Rate_Raw * Final_Multiplier`:

```sql
                CAST(SUM(COALESCE(0.5 * F.Hourly_Rate_Raw * F.Final_Multiplier, 0.0)) AS decimal(12,2)) AS Pay_Actual_Gross,
```
`sql/app\usp_Run_Pricing_Engine.PROC.sql:1181`

**Consequence:** because `Rate_Shift` is inside `Hourly_Rate_Raw`, the shift premium **IS multiplied** by the OT (1.5) / DT (2.0) / Saturday (1.5) / Sunday (2.0) / Holiday (3.0) / Special-Sat (2.0) day multiplier chosen at `sql/app\usp_Run_Pricing_Engine.PROC.sql:1157-1167`. This priced-in premium is what the ledger surfaces as `ACTUAL / ACTUAL_SHIFT_DIFFERENTIAL` (per _SHARED_CONTEXT.md:66). This is separate from the flat paid-hours add in Section d.

---

### (d) SD Hrs Add — `app.usp_Apply_ShiftDifferentialHoursAdd`

**Object:** `app.usp_Apply_ShiftDifferentialHoursAdd(@WorkDateFrom, @WorkDateTo, @RunId)`. Writes to `fms.Payroll_PayComponent` (ledger rows) and updates `fms.Payroll_Calculated.Final_Gross_Pay`.

**Work→paid hours conversion.** The extra *paid* hours are **hard-coded constants** (not read from config at runtime): 2nd shift = **1.00**, 3rd shift = **1.50**, else 0 — exactly the `Full_Shift_Paid_Hours − Full_Shift_Work_Hours` gaps from Section b (8−7=1, 8−6.5=1.5):

```sql
            ShiftAddHours =
                CONVERT(decimal(10,2),
                    CASE
                        WHEN ct.PayrollShiftCode_FromComments = 2 THEN 1.00
                        WHEN ct.PayrollShiftCode_FromComments = 3 THEN 1.50
                        ELSE 0.00
                    END
                )
```
`sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:77-84`

**Eligibility.** Only entries whose tokens are non-conflicting and resolve to shift 2 or 3 qualify:

```sql
        WHERE pc.WorkDate >= @FromDate
          AND pc.WorkDate <  DATEADD(DAY, 1, @ToDate)
          AND ISNULL(ct.Has_ConflictingShiftTokens, 0) = 0
          AND ct.PayrollShiftCode_FromComments IN (2, 3)
```
`sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:88-91`

**Which slice prices the add.** The proc picks the **last priced slice** of the entry (from `api.v_UI_Pricing_Slices_Advanced`, requiring `Slice_Hours > 0`), ranked by `Slice_End DESC, SliceIndex DESC`, and captures that slice's `Rate_Base`, `Rate_Shift`, `Final_Multiplier` (boom rate is captured only as `RateBoomSeenOnLastSlice` for audit — it is NOT used):

```sql
            RateBaseUsed =
                CONVERT(decimal(12,4), ISNULL(s.Rate_Base, 0.00)),

            RateShiftUsed =
                CONVERT(decimal(12,4), ISNULL(s.Rate_Shift, 0.00)),

            RateBoomSeenOnLastSlice =
                CONVERT(decimal(12,4), ISNULL(s.Rate_Boom_Applied, 0.00)),

            MultiplierUsed =
                CONVERT(decimal(10,2), ISNULL(s.Final_Multiplier, 1.00)),

            rn = ROW_NUMBER() OVER
            (
                PARTITION BY se.LaborPayrollID
                ORDER BY s.Slice_End DESC, s.SliceIndex DESC
            )
        FROM ShiftEntries se
        JOIN api.v_UI_Pricing_Slices_Advanced s
            ON s.LaborPayrollID = se.LaborPayrollID
        WHERE ISNULL(s.Slice_Hours, 0.00) > 0.00
```
`sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:105-125`

**Pricing the add.** `ComponentAmount = ShiftAddHours * (RateBaseUsed + RateShiftUsed) * MultiplierUsed`. Boom is explicitly forced to 0 (`RateBoomUsed`), so **the added hours receive base+shift only, at the last slice's multiplier**:

```sql
        /* Important: SD Hrs Add does NOT receive boom pay/rate. */
        RateBoomUsed = CONVERT(decimal(12,4), 0.00),

        RateBoomSeenOnLastSlice,
        MultiplierUsed,

        ComponentAmount =
            CONVERT(decimal(19,4),
                ShiftAddHours
              * (ISNULL(RateBaseUsed, 0.00) + ISNULL(RateShiftUsed, 0.00))
              * ISNULL(MultiplierUsed, 1.00)
            ),
```
`sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:172-183`

The `#NewShiftHoursAdd` build only keeps the last slice (`rn = 1`) and requires positive add hours and positive base+shift rates:

```sql
    FROM LastSlice
    WHERE rn = 1
      AND ShiftAddHours > 0.00
      AND ISNULL(RateBaseUsed, 0.00) > 0.00
      AND ISNULL(RateShiftUsed, 0.00) > 0.00;
```
`sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:187-191`

**Idempotent rerun.** Before recomputing, the proc deletes prior SD-Hrs-Add ledger rows in range and captures affected LPIDs so removed-token cases still get `Final_Gross` reset:

```sql
    DELETE p
        OUTPUT deleted.LaborPayrollID INTO #AffectedShiftHoursAdd(LaborPayrollID)
    FROM fms.Payroll_PayComponent p
    WHERE p.WorkDate >= @FromDate
      AND p.WorkDate <  DATEADD(DAY, 1, @ToDate)
      AND p.ComponentGroup = 'SHIFT_DIFFERENTIAL'
      AND p.ComponentCode IN ('SHIFT_2_HOURS_ADD', 'SHIFT_3_HOURS_ADD');
```
`sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:47-53`

**Ledger insert (`fms.Payroll_PayComponent`).** `ComponentGroup='SHIFT_DIFFERENTIAL'`; `ComponentCode` / `ComponentLabel` / `SourceRuleCode` / `SourceRuleName` are chosen by shift code (`sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:136-158`). `SourceSchema='app'`, `SourceTable='v_LaborPayroll_CommentTokens'`, `DisplaySort=13`, and both `IncludedInFinalGross` and `IncludedInPayableGross` are 1. The added hours are classified into ST/OT/DT buckets by the captured multiplier:

```sql
        ShiftAddHours,

        Hrs_ST =
            CASE WHEN ISNULL(MultiplierUsed, 1.00) = 1.00
                 THEN ShiftAddHours ELSE NULL END,

        Hrs_OT =
            CASE WHEN ISNULL(MultiplierUsed, 1.00) > 1.00
                   AND ISNULL(MultiplierUsed, 1.00) < 2.00
                 THEN ShiftAddHours ELSE NULL END,

        Hrs_DT =
            CASE WHEN ISNULL(MultiplierUsed, 1.00) >= 2.00
                 THEN ShiftAddHours ELSE NULL END,
```
`sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:250-263`

The insert header (columns) and group/sort/flags:

```sql
    INSERT fms.Payroll_PayComponent
    (
        RunId, CalcID, LaborPayrollID, WorkDate, JobTicketID, JobCode, EmpID, Employee_Name,
        ComponentCode, ComponentGroup, ComponentLabel, SourceSchema, SourceTable, SourceID,
        SourceRuleCode, SourceRuleName, ComponentHours, Hrs_ST, Hrs_OT, Hrs_DT,
        RateBaseUsed, RateShiftUsed, RateBoomUsed, MultiplierUsed, ComponentAmount,
        IncludedInFinalGross, IncludedInPayableGross, DisplaySort, Explanation
    )
```
`sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:201-232` (with `'SHIFT_DIFFERENTIAL'`, `'app'`, `'v_LaborPayroll_CommentTokens'`, `13`, `bit 1,1` supplied in the SELECT at `sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:233-272`). A human-readable `Explanation` string is built at `sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:273-300`, and only rows with non-zero amount are inserted (`WHERE ISNULL(ComponentAmount,0.00) <> 0.00`, `sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:301-302`).

**Reconciliation into `fms.Payroll_Calculated` (`Rule_Hrs_ShiftAdd` / `Rule_Amt_ShiftAdd`).** The proc does **not** write columns literally named `Rule_Hrs_ShiftAdd` or `Rule_Amt_ShiftAdd` — searched, **not found** in this proc. Reconciliation is instead done by recomputing `Final_Gross_Pay` for affected LPIDs as `Pay_Actual_Gross + Pay_Gap_Add + Pay_Rest_Add + (aggregated SD Hrs Add amount)`:

```sql
    NewAgg AS
    (
        SELECT
            LaborPayrollID,
            ShiftHoursAddAmount =
                CONVERT(decimal(19,4), SUM(ISNULL(ComponentAmount, 0.00)))
        FROM #NewShiftHoursAdd
        GROUP BY LaborPayrollID
    )
    UPDATE pc
       SET pc.Final_Gross_Pay =
            CONVERT(decimal(12,2),
                ISNULL(pc.Pay_Actual_Gross, 0.00)
              + ISNULL(pc.Pay_Gap_Add, 0.00)
              + ISNULL(pc.Pay_Rest_Add, 0.00)
              + ISNULL(na.ShiftHoursAddAmount, 0.00)
            )
    FROM fms.Payroll_Calculated pc
    JOIN Affected a
        ON a.LaborPayrollID = pc.LaborPayrollID
    LEFT JOIN NewAgg na
        ON na.LaborPayrollID = pc.LaborPayrollID;
```
`sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:322-343`

So the SD-Hrs-Add hours/amount live in the `fms.Payroll_PayComponent` ledger (as `ComponentHours` / `ComponentAmount` under group `SHIFT_DIFFERENTIAL`), and their dollar total flows back into `fms.Payroll_Calculated.Final_Gross_Pay` via the `LEFT JOIN NewAgg` (a NULL join, i.e. removed-token rows, correctly contributes 0). Note the base formula (`sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:306-315`) does **not** re-add `Pay_Actual_Gross`'s already-priced SD *Rate* Add — that premium is inside `Pay_Actual_Gross` from the engine; only the extra paid-hours amount is added here.

**Worked example:** could not run a live query to produce input→output (read-only session, no example LaborPayrollID in `_SHARED_CONTEXT.md` is tagged as a 2nd/3rd-shift case). Arithmetic per the code, for a straight-time 2nd-shift entry with base 40.00 and shift 3.00: `ShiftAddHours = 1.00`, `ComponentAmount = 1.00 * (40.00 + 3.00) * 1.00 = 43.00`, classified to `Hrs_ST`. A 3rd-shift entry (add 1.50, shift 4.00, base 40.00) on a DT slice (mult 2.00): `1.50 * (40.00 + 4.00) * 2.00 = 132.00`, classified to `Hrs_DT`.

---

### (e) Exceptions this proc can raise

`app.usp_Apply_ShiftDifferentialHoursAdd` does **not** write to `fms.Payroll_CalcException` and contains **no `Reason=` strings** — searched, **not found**. It only raises hard `THROW` errors (guard clauses), all before any data work:

- `THROW 51001, '@WorkDateFrom cannot be greater than @WorkDateTo.', 1;` — `sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:14-17`
- `THROW 51002, 'Missing app.v_LaborPayroll_CommentTokens.', 1;` — `sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:22-23`
- `THROW 51003, 'Missing api.v_UI_Pricing_Slices_Advanced.', 1;` — `sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:25-26`
- `THROW 51004, 'Missing fms.Payroll_PayComponent.', 1;` — `sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:28-29`
- `THROW 51005, 'Missing fms.Payroll_Calculated.', 1;` — `sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:31-32`

At the end it emits three informational `PRINT` lines (deleted / inserted / Final_Gross-updated row counts) at `sql/app\usp_Apply_ShiftDifferentialHoursAdd.PROC.sql:347-349` — these are diagnostics, not exceptions.


---

## B5 — Guaranteed / minimum hours (app.usp_Apply_GuaranteedHours)

**Object:** `app.usp_Apply_GuaranteedHours` (`sql/app\usp_Apply_GuaranteedHours.PROC.sql`, 1065 lines)
**Config:** `cfg.GuaranteedHoursRule` (4 rows), `cfg.Craft_MinimumPayPolicy` (39 rows)
**Writes:** `fms.Payroll_GuaranteeGroup`, `fms.Payroll_GuaranteeAllocation`, and the compatibility fields on `fms.Payroll_Calculated`.
**Reads:** `api.v_UI_Pricing_Slices_Advanced` (per 30-min slices), `app.v_Base_LaborPayroll`, `calc.v_Calc_Labor_Timeline`, `dim.LU12_Holiday`.

This post-processor runs during `app.usp_FinalizePayrollOutputs_AfterPricing`, AFTER the pricing engine has written actual gross pay per `LaborPayrollID`. It "tops up" pay to a contractual minimum by computing a **gap** = Minimum − Actual and pricing that gap, then re-computes `Final_Gross_Pay`. It never reduces pay (gap can only be positive; see the `WHERE GapHours > 0` filter at line 574).

---

### Parameters and the `@BoomNoModifierTreatment` resolution

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:3-8
CREATE     PROCEDURE [app].[usp_Apply_GuaranteedHours]
      @WorkDateFrom date = NULL
    , @WorkDateTo   date = NULL
    , @RunId        int  = NULL
    , @BoomNoModifierTreatment varchar(30) = NULL
```

The boom-treatment parameter defaults to NULL, then is resolved from the `LONG_BOOM_MIN_4` config row, then hard-defaulted to `EXCLUDE_NO_MODIFIER`:

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:32-44
    IF @BoomNoModifierTreatment IS NULL
    BEGIN
        SELECT TOP (1)
            @BoomNoModifierTreatment = BoomNoModifierTreatment
        FROM cfg.GuaranteedHoursRule
        WHERE RuleCode = 'LONG_BOOM_MIN_4';
    END;

    IF @BoomNoModifierTreatment IS NULL
        SET @BoomNoModifierTreatment = 'EXCLUDE_NO_MODIFIER';

    IF @BoomNoModifierTreatment NOT IN ('EXCLUDE_NO_MODIFIER', 'COUNT_TOWARD_MIN')
        THROW 51002, '@BoomNoModifierTreatment must be EXCLUDE_NO_MODIFIER or COUNT_TOWARD_MIN.', 1;
```

Config row `LONG_BOOM_MIN_4.BoomNoModifierTreatment = EXCLUDE_NO_MODIFIER` (`data/cfg.GuaranteedHoursRule.md:7`), so the resolved value matches config.

`@RunId` defaults to NULL and is pulled from session context when not passed (line 29-30): `SET @RunId = TRY_CONVERT(int, SESSION_CONTEXT(N'PayrollAPP_RunLogID'));`

---

### (a) The 4 rule rows and how the proc consumes each field

`cfg.GuaranteedHoursRule` (`data/cfg.GuaranteedHoursRule.md:5-8`):

| RuleCode | ScopeBasis | GroupScope | MinimumHours | PayComponent | DefaultMultiplier | BoomNoModifierTreatment |
|---|---|---|---|---|---|---|
| DAILY_MIN_4 | ShiftAnchorDate | EmployeeShift | 4.00 | BaseShift | 1.00 | (null) |
| HOLIDAY_MIN_8 | CalendarDate | EmployeeCalendarDate | 8.00 | Holiday | 3.00 | (null) |
| LONG_BOOM_MIN_4 | ShiftAnchorDate | EmployeeShiftBoom | 4.00 | BoomOnly | (null) | EXCLUDE_NO_MODIFIER |
| SPECIAL_SAT_MIN_8 | CalendarDate | EmployeeCalendarDate | 8.00 | SpecialSaturday | 2.00 |  |

**Important: the proc HARD-CODES ScopeBasis, GroupScope, MinimumHours, PayComponent and the multipliers as literals in four CTEs; it does NOT read those columns from the config table.** The config table is used only (i) to resolve `BoomNoModifierTreatment`, and (ii) as an on/off gate via `WHERE EXISTS (... r.RuleCode = '...' AND r.IsEnabled = 1)`. So the config table's `MinimumHours`/`DefaultMultiplier` values are documentation that happens to agree with the literals; changing them in config would NOT change the calc unless the literals are also edited.

**1) DAILY_MIN_4 — BaseShift, min 4, mult 1.00, scope EmployeeShift/ShiftAnchorDate** (`Daily4Groups` CTE):

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:335-362
            RuleCode       = CONVERT(varchar(40), 'DAILY_MIN_4'),
            RuleName       = CONVERT(varchar(120), 'Daily 4-hour minimum'),
            ScopeBasis     = CONVERT(varchar(30), 'ShiftAnchorDate'),
            GroupScope     = CONVERT(varchar(40), 'EmployeeShift'),
            ...
            MinimumHours =
                CAST(4.00 AS decimal(10,2)),
            ...
            PayComponent   = CONVERT(varchar(40), 'BaseShift'),
            MultiplierUsed = CAST(1.00 AS decimal(10,2))
```

**2) LONG_BOOM_MIN_4 — BoomOnly, min 4 (capped at actual hrs if <4), mult from boom slices, scope EmployeeShiftBoom** (`BoomGroups` CTE):

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:378-397
            RuleCode       = CONVERT(varchar(40), 'LONG_BOOM_MIN_4'),
            RuleName       = CONVERT(varchar(120), 'Long boom 4-hour premium minimum'),
            ScopeBasis     = CONVERT(varchar(30), 'ShiftAnchorDate'),
            GroupScope     = CONVERT(varchar(40), 'EmployeeShiftBoom'),
            ...
            MinimumHours =
                CAST(
                    CASE
                        WHEN SUM(ISNULL(p.Act_Total_Hrs, 0)) < 4.00
                        THEN SUM(ISNULL(p.Act_Total_Hrs, 0))
                        ELSE 4.00
                    END
                AS decimal(10,2)),
```

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:426-427
            PayComponent   = CONVERT(varchar(40), 'BoomOnly'),
            MultiplierUsed = CAST(ISNULL(MAX(bsa.BoomMultiplierUsed), 1.00) AS decimal(10,2))
```

Note the boom minimum is capped: if the worker's whole day is < 4 actual total hours, the "minimum" for the boom rule shrinks to the actual total-hours worked (you cannot guarantee more boom than the shift itself). Its multiplier is taken from the boom slices (`BoomMultiplierUsed`, the day OT/DT multiplier applied to the boom-eligible slices), defaulting to 1.00.

**3) HOLIDAY_MIN_8 — Holiday, min 8, mult 3.00, scope EmployeeCalendarDate/CalendarDate** (`HolidayGroups` CTE):

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:446-473
            RuleCode       = CONVERT(varchar(40), 'HOLIDAY_MIN_8'),
            RuleName       = CONVERT(varchar(120), 'Holiday 8-hour minimum'),
            ScopeBasis     = CONVERT(varchar(30), 'CalendarDate'),
            GroupScope     = CONVERT(varchar(40), 'EmployeeCalendarDate'),
            ...
            MinimumHours =
                CAST(8.00 AS decimal(10,2)),
            ...
            PayComponent   = CONVERT(varchar(40), 'Holiday'),
            MultiplierUsed = CAST(COALESCE(MAX(HolidayMultiplier), 3.00) AS decimal(10,2))
```

Holiday multiplier is read from `dim.LU12_Holiday.PayRateMultiplier` per slice (`HolidayMultiplier`, joined at line 218-219), defaulting to the literal 3.00 — matching `DefaultMultiplier 3.00` in config.

**4) SPECIAL_SAT_MIN_8 — SpecialSaturday, min 8, mult 2.00, scope EmployeeCalendarDate/CalendarDate** (`SpecialSatGroups` CTE):

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:492-519
            RuleCode       = CONVERT(varchar(40), 'SPECIAL_SAT_MIN_8'),
            RuleName       = CONVERT(varchar(120), 'Special Saturday 8-hour minimum'),
            ScopeBasis     = CONVERT(varchar(30), 'CalendarDate'),
            GroupScope     = CONVERT(varchar(40), 'EmployeeCalendarDate'),
            ...
            MinimumHours =
                CAST(8.00 AS decimal(10,2)),
            ...
            PayComponent   = CONVERT(varchar(40), 'SpecialSaturday'),
            MultiplierUsed = CAST(2.00 AS decimal(10,2))
```

Special-Saturday detection is in-engine (month IN (6,12), Saturday, day-of-month ≤ 7), computed in `#SliceBase.IsSpecialSaturdayCalendar`:

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:207-213
            IsSpecialSaturdayCalendar =
                CASE
                    WHEN MONTH(CAST(s.Slice_Start AS date)) IN (6, 12)
                     AND DATENAME(weekday, CAST(s.Slice_Start AS date)) = 'Saturday'
                     AND DAY(CAST(s.Slice_Start AS date)) <= 7
                    THEN 1 ELSE 0
                END
```

Holiday groups explicitly exclude special-Saturday days (`IsHolidayCalendar = 1 AND IsSpecialSaturdayCalendar = 0`, line 476-477) so a day cannot be double-counted under both rules.

---

### (b) ActualQualifyingHours, GapHours, and gap pricing

**How ActualQualifyingHours is counted per rule:**

- **DAILY_MIN_4**: sum of `Act_Total_Hrs` from `#PcBase`, grouped by `EmpID, ShiftAnchorDate` (line 344-345): `ActualQualifyingHours = CAST(SUM(ISNULL(Act_Total_Hrs, 0)) AS decimal(10,2))`.
- **LONG_BOOM_MIN_4**: `MAX(bsa.QualifyingBoomHours)` — the boom-active slice hours from `#BoomShiftAgg` (line 387-388).
- **HOLIDAY_MIN_8 / SPECIAL_SAT_MIN_8**: sum of `Slice_Hours` for the qualifying calendar-date slices (line 455-456 / 501-502): `ActualQualifyingHours = CAST(SUM(ISNULL(Slice_Hours, 0)) AS decimal(10,2))`.

`QualifyingBoomHours` (what counts toward the boom minimum) is where `@BoomNoModifierTreatment` bites (see (e)):

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:265-281
        QualifyingBoomHours =
            CAST(SUM(
                CASE
                    WHEN Is_Boom_Active = 1
                     AND
                     (
                         @BoomNoModifierTreatment = 'COUNT_TOWARD_MIN'
                         OR
                         (
                             CraftModifierCode IS NOT NULL
                             AND ISNULL(Rate_Boom_Applied, 0.00) <> 0.00
                         )
                     )
                    THEN Slice_Hours
                    ELSE 0.00
                END
            ) AS decimal(10,2)),
```

**How GapHours is derived (Minimum − Actual):** each CTE first checks `MAX(ApplyMinimumPay) = 0 THEN 0.00` (kills the gap when minimum-pay is disabled), then only fills a positive gap when actual hours are between 0 and the minimum. DAILY_MIN_4 example:

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:350-359
            GapHours =
                CAST(
                    CASE
                        WHEN MAX(CONVERT(tinyint, ApplyMinimumPay)) = 0 THEN 0.00
                        WHEN SUM(ISNULL(Act_Total_Hrs, 0)) > 0
                         AND SUM(ISNULL(Act_Total_Hrs, 0)) < 4.00
                        THEN 4.00 - SUM(ISNULL(Act_Total_Hrs, 0))
                        ELSE 0.00
                    END
                AS decimal(10,2)),
```

The boom gap is more involved (uses PayableBoomHours>0 as a precondition and the capped minimum):

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:399-424
            GapHours =
                CAST(
                    CASE
                        WHEN MAX(CONVERT(tinyint, p.ApplyMinimumPay)) = 0 THEN 0.00

                        WHEN ISNULL(MAX(bsa.PayableBoomHours), 0.00) <= 0.00 THEN 0.00

                        WHEN ISNULL(MAX(bsa.QualifyingBoomHours), 0.00) > 0.00
                         AND ISNULL(MAX(bsa.QualifyingBoomHours), 0.00)
                             <
                             CASE
                                 WHEN SUM(ISNULL(p.Act_Total_Hrs, 0)) < 4.00
                                 THEN SUM(ISNULL(p.Act_Total_Hrs, 0))
                                 ELSE 4.00
                             END
                        THEN
                             CASE
                                 WHEN SUM(ISNULL(p.Act_Total_Hrs, 0)) < 4.00
                                 THEN SUM(ISNULL(p.Act_Total_Hrs, 0))
                                 ELSE 4.00
                             END
                             - ISNULL(MAX(bsa.QualifyingBoomHours), 0.00)

                        ELSE 0.00
                    END
                AS decimal(10,2)),
```

Only groups with `GapHours > 0` survive into `#AllGroups` (line 574): `FROM RawGroups WHERE GapHours > 0`.

**Gap pricing — which rate, which multiplier.** Pricing is `GapHours * <rate> * MultiplierUsed`, cast to decimal(12,2), and it differs by allocation method:

- **DAILY_MIN_4 → `AllocatedGapPay = GapHours * BaseShiftRateUsed * MultiplierUsed`** where `BaseShiftRateUsed = MAX(Rate_Base + Rate_Shift)` from `#EntryRate` (line 237-238). RateBaseUsed/RateShiftUsed are stored, RateBoomUsed = 0:

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:646-656
            RateBaseUsed  = ISNULL(er.RateBaseUsed, 0.00),
            RateShiftUsed = ISNULL(er.RateShiftUsed, 0.00),
            RateBoomUsed  = CONVERT(decimal(12,4), 0.00),

            AllocatedGapPay =
                CAST
                (
                    g.GapHours
                    * ISNULL(er.BaseShiftRateUsed, 0.00)
                    * g.MultiplierUsed
                AS decimal(12,2)),
```

- **LONG_BOOM_MIN_4 → `AllocatedGapPay = GapHours * BoomRateUsed * MultiplierUsed`** where `BoomRateUsed = MAX(Rate_Boom_Applied)` from `#BoomEligibleLaborRows`. Base/Shift stored as 0, RateBoomUsed populated:

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:697-707
            RateBaseUsed  = CONVERT(decimal(12,4), 0.00),
            RateShiftUsed = CONVERT(decimal(12,4), 0.00),
            RateBoomUsed  = ber.BoomRateUsed,

            AllocatedGapPay =
                CAST
                (
                    g.GapHours
                    * ISNULL(ber.BoomRateUsed, 0.00)
                    * g.MultiplierUsed
                AS decimal(12,2)),
```

- **HOLIDAY_MIN_8 and SPECIAL_SAT_MIN_8 → `AllocatedGapPay = GapHours * MAX(Rate_Base + Rate_Shift) * MultiplierUsed`** (boom excluded), Holiday shown:

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:744-754
            RateBaseUsed  = MAX(ISNULL(s.Rate_Base, 0.00)),
            RateShiftUsed = MAX(ISNULL(s.Rate_Shift, 0.00)),
            RateBoomUsed  = CONVERT(decimal(12,4), 0.00),

            AllocatedGapPay =
                CAST
                (
                    g.GapHours
                    * MAX(ISNULL(s.Rate_Base, 0.00) + ISNULL(s.Rate_Shift, 0.00))
                    * g.MultiplierUsed
                AS decimal(12,2)),
```

Special-Saturday pricing is identical (line 810-820). So: DAILY and HOLIDAY/SPECIAL_SAT price the gap on **base+shift**; only LONG_BOOM prices on the **boom adder alone**.

---

### (c) Allocation methods — which labor entry the gap is pinned to

A gap is computed per *group* (per employee-shift or employee-calendar-day), but it must be recorded against a single `LaborPayrollID`. Each rule's candidate set is ranked with `ROW_NUMBER()` and only rank 1 is kept (`WHERE AllocationRank = 1`, line 903).

- **`LastLaborEntryInShift`** (DAILY_MIN_4) — the latest-ending labor entry in the shift:

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:658-663
            AllocationRank =
                ROW_NUMBER() OVER
                (
                    PARTITION BY g.TempGroupID
                    ORDER BY w.Labor_End DESC, p.LaborPayrollID DESC
                )
```

- **`LastEligibleBoomEntryInShift`** (LONG_BOOM_MIN_4) — the latest-ending boom-eligible entry:

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:709-714
            AllocationRank =
                ROW_NUMBER() OVER
                (
                    PARTITION BY g.TempGroupID
                    ORDER BY ber.LastEligibleBoomSliceEnd DESC, ber.LaborPayrollID DESC
                )
```

`#BoomEligibleLaborRows` only contains rows with `Is_Boom_Active = 1 AND CraftModifierCode IS NOT NULL AND Rate_Boom_Applied <> 0.00` (line 313-316), so this method always targets a genuinely boom-paid entry.

- **`LastHolidaySliceEntry`** (HOLIDAY_MIN_8) — the entry with the latest holiday slice end. Because this branch aggregates by `s.LaborPayrollID`, the ORDER BY uses `MAX(s.Slice_End)`:

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:756-761
            AllocationRank =
                ROW_NUMBER() OVER
                (
                    PARTITION BY g.TempGroupID
                    ORDER BY MAX(s.Slice_End) DESC, s.LaborPayrollID DESC
                )
```

- **`LastSpecialSatSliceEntry`** (SPECIAL_SAT_MIN_8) — identical ranking on the special-Saturday slices:

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:822-827
            AllocationRank =
                ROW_NUMBER() OVER
                (
                    PARTITION BY g.TempGroupID
                    ORDER BY MAX(s.Slice_End) DESC, s.LaborPayrollID DESC
                )
```

The full gap of a group lands on that single rank-1 entry (`AllocatedGapHours = a.GapHours`, line 983); the gap is NOT split across multiple entries.

---

### (d) TriggeredFlag / SatisfiedFlag and the writes

**Flag meaning.** In `fms.Payroll_GuaranteeGroup`, `TriggeredFlag` = "a shortfall existed and pay was added"; `SatisfiedFlag` = "already at/above the minimum, no gap":

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:955-956
        TriggeredFlag = CONVERT(bit, CASE WHEN GapHours > 0 THEN 1 ELSE 0 END),
        SatisfiedFlag = CONVERT(bit, CASE WHEN GapHours = 0 THEN 1 ELSE 0 END),
```

Note: because `#AllGroups` is filtered to `GapHours > 0` (line 574), **every** row actually persisted has `TriggeredFlag = 1` and `SatisfiedFlag = 0`. Satisfied (no-gap) groups are dropped before insert, so `SatisfiedFlag = 1` is effectively never written by this proc. The flag logic is written generically but only triggered rows reach the table.

**Group insert** — `INSERT INTO fms.Payroll_GuaranteeGroup ... SELECT ... FROM #AllGroups` (line 916-960). One row per (rule, employee, date) with a gap. `CalculatedAtUTC` is set to `@CalcRunAtUTC` (a single `SYSUTCDATETIME()` captured at line 27), which is later used to join back.

**Allocation insert** — `INSERT INTO fms.Payroll_GuaranteeAllocation ... FROM #AllAlloc a JOIN fms.Payroll_GuaranteeGroup gg ON gg.GroupKey = a.GroupKey AND gg.CalculatedAtUTC = @CalcRunAtUTC` (line 962-1005). `AllocatedGapHours = a.GapHours`, `AllocatedGapPay = a.AllocatedGapPay`, plus the rate columns and an `Explanation` string:

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:990-1000
        Explanation =
            CONCAT
            (
                a.RuleCode,
                ': ',
                CONVERT(varchar(30), a.ActualQualifyingHours),
                ' actual qualifying hrs / ',
                CONVERT(varchar(30), a.MinimumHours),
                ' required; gap=',
                CONVERT(varchar(30), a.GapHours)
            ),
```

**Update back to `fms.Payroll_Calculated`.** An `AllocAgg` CTE re-reads the just-inserted allocations for `@CalcRunAtUTC`, splits gap hours by boom vs non-boom, sums gap pay, and takes MAX of the min/mult for audit:

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:1017-1030
            Gap_Hrs_Total =
                CAST(SUM(CASE WHEN g.PayComponent <> 'BoomOnly' THEN a.AllocatedGapHours ELSE 0.00 END) AS decimal(10,2)),

            Gap_Hrs_Boom =
                CAST(SUM(CASE WHEN g.PayComponent = 'BoomOnly' THEN a.AllocatedGapHours ELSE 0.00 END) AS decimal(10,2)),

            Pay_Gap_Add =
                CAST(SUM(a.AllocatedGapPay) AS decimal(12,2)),

            Audit_Min_Rule =
                CAST(MAX(g.MinimumHours) AS decimal(4,1)),

            Audit_Gap_Mult =
                CAST(MAX(g.MultiplierUsed) AS decimal(4,2))
```

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:1038-1057
    UPDATE pc
       SET
            pc.Gap_Hrs_Total = ISNULL(a.Gap_Hrs_Total, 0.00),
            pc.Gap_Hrs_Boom  = ISNULL(a.Gap_Hrs_Boom, 0.00),
            pc.Pay_Total_Hrs = ISNULL(pc.Act_Total_Hrs, 0.00) + ISNULL(a.Gap_Hrs_Total, 0.00),
            pc.Pay_Gap_Add   = ISNULL(a.Pay_Gap_Add, 0.00),
            pc.Audit_Min_Rule = ISNULL(a.Audit_Min_Rule, 0.0),
            pc.Audit_Gap_Mult = ISNULL(a.Audit_Gap_Mult, 1.0),
            pc.Final_Gross_Pay =
                CONVERT(decimal(12,2),
                    ISNULL(pc.Pay_Actual_Gross, 0.00)
                + ISNULL(a.Pay_Gap_Add, 0.00)
                + ISNULL(pc.Pay_Rest_Add, 0.00)
                )
    FROM fms.Payroll_Calculated pc
    LEFT JOIN AllocAgg a
        ON a.AllocatedLaborPayrollID = pc.LaborPayrollID
    WHERE
        pc.WorkDate >= @FromDT
        AND pc.WorkDate < @ToExDT;
```

So `Final_Gross_Pay = Pay_Actual_Gross + Pay_Gap_Add + Pay_Rest_Add`. `Gap_Hrs_Boom` receives only `BoomOnly` gap hours; `Gap_Hrs_Total` receives everything else (Daily, Holiday, Special-Sat). Note `Gap_Hrs_Total` does NOT include boom hours despite the name.

At the very start (before rebuild) these fields are reset to 0 and `Final_Gross_Pay` is set back to `Pay_Actual_Gross + Pay_Rest_Add` (line 93-109), so the proc is idempotent for its window. Existing group/alloc rows for the window are deleted first (line 60-86).

---

### (e) `ApplyMinimumPay` and `@BoomNoModifierTreatment = EXCLUDE_NO_MODIFIER`

**`cfg.Craft_MinimumPayPolicy.ApplyMinimumPay`** is joined onto every labor entry in `#PcBase` (line 145-146, default 1 when the craft has no policy row): `ApplyMinimumPay = CONVERT(tinyint, ISNULL(mp.ApplyMinimumPay, 1))`. In config only `ADMIN-A/B/C` are `False` (`data/cfg.Craft_MinimumPayPolicy.md:5-7`); all other 36 crafts are `True`. Every rule's GapHours CASE opens with `WHEN MAX(CONVERT(tinyint, ApplyMinimumPay)) = 0 THEN 0.00`, so any group containing an opted-out craft yields zero gap — the guarantee is entirely suppressed for admin crafts.

**`EXCLUDE_NO_MODIFIER` and LONG_BOOM_MIN_4.** With the default `EXCLUDE_NO_MODIFIER`, a boom-active slice counts toward the boom minimum **only if the labor row carries a craft modifier code AND the applied boom rate is non-zero**. This is the `QualifyingBoomHours` CASE (line 265-281 above): under `EXCLUDE_NO_MODIFIER` the `COUNT_TOWARD_MIN` disjunct is false, so the slice must satisfy `CraftModifierCode IS NOT NULL AND ISNULL(Rate_Boom_Applied, 0.00) <> 0.00`. Boom time worked without a modifier code (i.e. no boom-pole length bracket) is excluded from the qualifying count, so it neither reduces the gap nor is treated as satisfying the minimum. Switching the parameter to `COUNT_TOWARD_MIN` would let all boom-active hours count regardless of modifier. `PayableBoomHours` (line 254-263) always requires the modifier, and it gates the gap (`PayableBoomHours <= 0.00 THEN 0.00`, line 404) — so if there was no modifier-coded boom pay at all, the boom guarantee does not fire even under COUNT_TOWARD_MIN.

---

### (f) Where Holiday "Min 8" and Special Saturday "Min 8" live

- **Holiday Min 8** (DefaultMultiplier 3.00): the `HolidayGroups` CTE, `sql/app\usp_Apply_GuaranteedHours.PROC.sql:443-488`. Minimum literal 8.00 at line 458-459; multiplier `COALESCE(MAX(HolidayMultiplier), 3.00)` at line 473, where `HolidayMultiplier` = `dim.LU12_Holiday.PayRateMultiplier` (join line 218-219). Allocation/pricing at lines 723-785.
- **Special Saturday Min 8** (DefaultMultiplier 2.00): the `SpecialSatGroups` CTE, `sql/app\usp_Apply_GuaranteedHours.PROC.sql:489-533`. Minimum literal 8.00 at line 504-505; multiplier literal 2.00 at line 519. In-engine day detection at lines 207-213. Allocation/pricing at lines 787-850.

Both scope on `CalendarDate` / `EmployeeCalendarDate` and price the gap on base+shift (boom excluded).

---

### (g) Exceptions / Reasons raised

The proc raises three parameter/pre-flight `THROW`s (no per-row "Reason" rows are written):

```sql
sql/app\usp_Apply_GuaranteedHours.PROC.sql:13-16
    IF @WorkDateFrom IS NOT NULL
       AND @WorkDateTo IS NOT NULL
       AND @WorkDateFrom > @WorkDateTo
        THROW 51001, '@WorkDateFrom cannot be greater than @WorkDateTo.', 1;
```

- `THROW 51001` — `@WorkDateFrom` > `@WorkDateTo` (line 16).
- `THROW 51002` — `@BoomNoModifierTreatment` not in the allowed set (line 44).
- `THROW 51003/51004/51005` — missing required objects `api.v_UI_Pricing_Slices_Advanced`, `fms.Payroll_Calculated`, `app.v_Base_LaborPayroll` (lines 46-53).

The proc ends with two `PRINT`s of group/allocation counts (line 1062-1063); no exception "Reasons" are logged.

---

### Worked examples (real masked data, queried read-only from the two audit tables)

**LONG_BOOM_MIN_4 — LaborPayrollID 81827, E***53, shift 2026-04-03** (BOOM_GAP scenario):
- ActualQualifyingHours 0.50, MinimumHours 4.00 → GapHours 3.50.
- AllocationMethod `LastEligibleBoomEntryInShift`; RateBoomUsed 1.5000, RateBase/Shift 0; MultiplierUsed 1.00.
- `AllocatedGapPay = 3.50 * 1.5000 * 1.00 = 5.25` (matches stored 5.25). PayComponent `BoomOnly` → feeds `Gap_Hrs_Boom = 3.50`. TriggeredFlag=1, SatisfiedFlag=0.

**SPECIAL_SAT_MIN_8 — LaborPayrollID 74066, E***38, calendar date 2025-12-06** (SPECIAL_SAT_MIN8_GAP scenario):
- ActualQualifyingHours 6.00, MinimumHours 8.00 → GapHours 2.00.
- AllocationMethod `LastSpecialSatSliceEntry`; RateBaseUsed 67.8700, RateShift 0, RateBoom 0; MultiplierUsed 2.00.
- `AllocatedGapPay = 2.00 * 67.8700 * 2.00 = 271.48` (matches stored 271.48). PayComponent `SpecialSaturday` → feeds `Gap_Hrs_Total = 2.00`. TriggeredFlag=1, SatisfiedFlag=0.

Both confirm the pricing formula `GapHours * rate * MultiplierUsed`: boom uses the boom-adder rate at mult 1.00; special-Saturday uses base+shift at mult 2.00.


---

## B6 — Rest-period premium (app.usp_Apply_RestPeriod_Premium and app.usp_Prototype_RestPeriod_SliceChain)

Plain-English: TCG pays a punitive "rest-period" premium when an employee returns to work without getting a full 8-hour rest break after a chain of work that hit OT/DT. Labor entries are stitched into work "chains" (gaps <= 30 min join a chain). A `RestForced` state machine turns ON when the previous chain had OT/DT and the gap before the next chain is < 8h, and stays ON until a real >= 8h break happens. While forced, each 30-minute pricing slice is floored to at least the OT multiplier (1.50), or to DT (2.00) once cumulative rest-chain hours reach the OT limit (12h). The premium is the delta between the floored multiplier and the slice's normal multiplier, priced at the slice hourly rate. It is stored separately in `Pay_Rest_Add` (NOT embedded in `Pay_Actual_Gross`) and added into `Final_Gross_Pay`.

Objects involved:
- `app.usp_Apply_RestPeriod_Premium` (the committing proc that actually runs in production) — `sql/app\usp_Apply_RestPeriod_Premium.PROC.sql`
- `app.usp_Prototype_RestPeriod_SliceChain` (read-only diagnostic/what-if proc, emits result sets; used by UI/report/test procs) — `sql/app\usp_Prototype_RestPeriod_SliceChain.PROC.sql`
- `cfg.RestPeriod_Rule` (config) — `data/cfg.RestPeriod_Rule.md`
- `app.usp_FinalizePayrollOutputs_AfterPricing` (orchestrator; calls the Apply proc) — `sql/app\usp_FinalizePayrollOutputs_AfterPricing.PROC.sql`
- `app.usp_Rebuild_PayComponentLedger` (writes the REST_PERIOD_PREMIUM component row) — `sql/app\usp_Rebuild_PayComponentLedger.PROC.sql`
- Sources read: `calc.v_Calc_Labor_Timeline`, `api.v_UI_Pricing_Slices_Advanced`, `fms.Payroll_Calculated`

---

### (a) cfg.RestPeriod_Rule values and how the proc reads them

Config row (`data/cfg.RestPeriod_Rule.md:1-5`) — 1 row:

```
| RestRuleID | RuleName | RequiredRestHours | OTFloorMultiplier | StitchGapMinutes | TriggerMode | IsEnabled | UpdatedAtUTC |
| 1 | PunitiveUntil8Off | 8.00 | 1.50 | 30 | HrsOTDTPositive | True | 02/23/2026 08:33:24 |
```

So: **RequiredRestHours 8.00, OTFloorMultiplier 1.50, StitchGapMinutes 30, TriggerMode HrsOTDTPositive**, RuleName PunitiveUntil8Off, IsEnabled True.

The Apply proc reads the top row by descending RestRuleID and applies defaults/guards (`sql/app\usp_Apply_RestPeriod_Premium.PROC.sql:50-77`):

```sql
    DECLARE
        @IsEnabled bit,
        @ReqRestHrs decimal(9,2),
        @OTFloor decimal(9,2),
        @StitchGapMin int,
        @TriggerMode varchar(30);

    SELECT TOP (1)
        @IsEnabled     = IsEnabled,
        @ReqRestHrs    = RequiredRestHours,
        @OTFloor       = OTFloorMultiplier,
        @StitchGapMin  = StitchGapMinutes,
        @TriggerMode   = TriggerMode
    FROM cfg.RestPeriod_Rule
    ORDER BY RestRuleID DESC;

    IF ISNULL(@IsEnabled, 0) = 0
    BEGIN
        PRINT 'RestPeriod premium disabled (cfg.RestPeriod_Rule.IsEnabled=0).';
        RETURN;
    END;

    IF @TriggerMode IS NULL OR @TriggerMode NOT IN ('ActHoursOver8','HrsOTDTPositive')
        SET @TriggerMode = 'HrsOTDTPositive';

    IF @ReqRestHrs IS NULL SET @ReqRestHrs = 8.00;
    IF @OTFloor IS NULL SET @OTFloor = 1.50;
    IF @StitchGapMin IS NULL SET @StitchGapMin = 30;
```

Note: when `IsEnabled=0` the Apply proc simply PRINTs and RETURNs (no-op). The Prototype proc instead THROWs when disabled (`...SliceChain.PROC.sql:60-68`). Defaults match config exactly (8.00 / 1.50 / 30 / HrsOTDTPositive), so even a missing config would produce identical behavior.

---

### (b) Chain-stitching, gap fields, the 8-hour rest requirement, and when Rest_IsForced = 1

**Windowing.** Each LaborPayrollID becomes one canonical window `[ActualStart, ActualEnd]` from `calc.v_Calc_Labor_Timeline` (`Pay_Start_Rounded` MIN / `Pay_End_Rounded` MAX), carrying `Act_Total_Hrs, Hrs_ST, Hrs_OT, Hrs_DT` from `fms.Payroll_Calculated`. Windows load with a 7-day lookback (`@FromDT_Lookback = DATEADD(DAY,-7,@FromDT)`, line 21) so chains that begin before the window are seen (`...Apply....PROC.sql:94-126`).

**Stitching (StitchGapMinutes = 30).** Per employee, ordered by start, a new chain begins on the first row or when the gap from the previous entry's end exceeds `@StitchGapMin` (`...Apply....PROC.sql:130-166`):

```sql
        GapMin    = DATEDIFF(MINUTE, LAG(w.ActualEnd) OVER (PARTITION BY w.EmpID ORDER BY w.ActualStart, w.LaborPayrollID), w.ActualStart),
        ...
        NewChainFlag = CASE
                          WHEN LAG(w.ActualEnd) OVER (...) IS NULL THEN 1
                          WHEN DATEDIFF(MINUTE, LAG(w.ActualEnd) OVER (...), w.ActualStart) > @StitchGapMin THEN 1
                          ELSE 0
                      END
```
`ChainId` is a running `SUM(NewChainFlag)` per employee (lines 149-166). So consecutive entries within 30 minutes of each other belong to the same work chain.

**`Rest_Gap_Hrs_FromPrevChain` = hours between one chain and the previous chain.** Computed per chain (`...Apply....PROC.sql:222-227`); overlap is clamped to 0.00:

```sql
           cc.GapHrsFromPrev =
               CASE
                   WHEN c2.PrevChainEnd IS NULL THEN NULL
                   WHEN cc.ChainStart < c2.PrevChainEnd THEN 0.00
                   ELSE CONVERT(decimal(9,2), DATEDIFF(MINUTE, c2.PrevChainEnd, cc.ChainStart) / 60.0)
               END,
```
This becomes column `Rest_Gap_Hrs_FromPrevChain` (aggregated as `GapHrsFromPrevChain = MAX(sc.GapHrsFromPrev)`, line 532). It is the measured "time off" between chains; the 8-hour rest requirement is met when this value `>= @ReqRestHrs (8.00)`.

**`ChainHadOT` (the trigger evaluation).** Whether a chain "had OT" under `TriggerMode HrsOTDTPositive` means OT or DT hours were positive (`...Apply....PROC.sql:176-182`):

```sql
        ChainHadOT = MAX(
            CASE
                WHEN @TriggerMode = 'ActHoursOver8' AND ISNULL(Act_Total_Hrs,0) > 8.00 THEN 1
                WHEN @TriggerMode = 'HrsOTDTPositive' AND (ISNULL(Hrs_OT,0) + ISNULL(Hrs_DT,0)) > 0 THEN 1
                ELSE 0
            END
        )
```
So with the active TriggerMode, a chain triggers rest-forcing potential when `Hrs_OT + Hrs_DT > 0`. (The alternative `ActHoursOver8` — actual hours > 8 — exists but is not the configured mode.)

**When `Rest_IsForced` is set to 1 — the recursive state machine** (`...Apply....PROC.sql:238-272`). ChainSeq 1 is never forced; each later chain inherits/transitions:

```sql
    ;WITH r AS
    (
        SELECT EmpID, ChainId, ChainSeq, PrevChainHadOT, GapHrsFromPrev,
            RestForced = CONVERT(bit, 0)
        FROM #C
        WHERE ChainSeq = 1

        UNION ALL

        SELECT c.EmpID, c.ChainId, c.ChainSeq, c.PrevChainHadOT, c.GapHrsFromPrev,
            RestForced =
                CONVERT(bit,
                    CASE
                        WHEN r.RestForced = 1 THEN
                            CASE WHEN ISNULL(c.GapHrsFromPrev, 9999) >= @ReqRestHrs THEN 0 ELSE 1 END
                        ELSE
                            CASE WHEN ISNULL(c.PrevChainHadOT, 0) = 1 AND ISNULL(c.GapHrsFromPrev, 9999) < @ReqRestHrs THEN 1 ELSE 0 END
                    END
                )
        FROM #C c
        JOIN r ON r.EmpID = c.EmpID AND r.ChainSeq = c.ChainSeq - 1
    )
    UPDATE c SET c.RestForced = r.RestForced ... OPTION (MAXRECURSION 32767);
```

In words:
- **Turn ON:** when NOT already forced, `Rest_IsForced = 1` iff the previous chain had OT/DT (`PrevChainHadOT = 1`) AND the gap to this chain was < 8h (`GapHrsFromPrev < @ReqRestHrs`).
- **Stay ON / turn OFF:** once forced, it stays forced (1) until a chain is finally preceded by a full rest (`GapHrsFromPrev >= @ReqRestHrs`), at which point it flips to 0.
- A NULL gap is treated as 9999 (i.e. effectively "rested", never forces).

The Prototype proc contains the byte-for-byte identical state machine (`...SliceChain.PROC.sql:280-327`).

**`RestChainHoursBeforeSlice`** = cumulative worked hours preceding the current slice within the same rest segment (a rest segment resets only after a true >= 8h break). It is `RestHoursBeforeChain` (sum of prior chains' actual hours in the segment) + `SliceHoursBeforeInChain` (sum of prior slice hours in this chain) (`...Apply....PROC.sql:274-329, 445-472`):

```sql
            RestChainHoursBeforeSlice =
                CONVERT(decimal(10,2),
                    ISNULL(o.RestHoursBeforeChain, 0.00)
                  + ISNULL(o.SliceHoursBeforeInChain, 0.00)
                )
```
This drives the OT-floor-vs-DT-floor decision in (c). Segment start flag resets only on `GapHrsFromPrev >= @ReqRestHrs` (lines 281-286).

---

### (c) RestReason / Rest_Policy values, and the multiplier -> premium -> Pay_Rest_Add arithmetic

**`Rest_Policy` literal — one value.** The Apply proc hard-codes the policy string on the update (`...Apply....PROC.sql:628`):
```sql
        pc.Rest_Policy = 'PunitiveUntil8Off',
```
That is the only `Rest_Policy` value written (matches `cfg.RestPeriod_Rule.RuleName`).

**`RestReason` values — only produced by the Prototype proc** (the Apply proc does NOT compute a RestReason). Full CASE (`...SliceChain.PROC.sql:560-656`). Distinct string literals:
- `NULL` — when not forced, or RestMultiplier is NULL
- `'Special Saturday premium exceeds rest-chain DT floor'`
- `'Special Saturday premium meets rest-chain DT floor'`
- `'Special Saturday premium exceeds rest floor'`
- `'Special Saturday premium meets rest floor'`
- `'Holiday premium exceeds rest-chain DT floor'`
- `'Holiday premium meets rest-chain DT floor'`
- `'Holiday premium exceeds rest floor'`
- `'Holiday premium meets rest floor'`
- `'Sunday premium exceeds rest-chain DT floor'`
- `'Sunday premium meets rest-chain DT floor'`
- `'Sunday premium exceeds rest floor'`
- `'Sunday premium meets rest floor'`
- `'Normal premium exceeds rest floor'`
- `'Normal already meets rest floor'`
- `'Rest chain over 12 hrs'`
- `'Rest floor to OT'` (the ELSE)

These are explanatory only (diagnostic output); they are never written to `fms.Payroll_Calculated`.

**Multiplier -> premium arithmetic** (identical logic in both procs; Apply at `...Apply....PROC.sql:474-524`).

1. `RestMultiplier` — only set when forced; DT floor once cumulative rest-chain hours reach the OT limit, else the OT floor 1.50 (`:478-486`):
```sql
            RestMultiplier =
                CONVERT(decimal(10,2),
                    CASE
                        WHEN ISNULL(c1.RestForced, 0) = 0 THEN NULL
                        WHEN c1.RestChainHoursBeforeSlice >= ISNULL(c1.Limit_OT, 12.00)
                            THEN ISNULL(c1.Mul_DT, 2.00)
                        ELSE @OTFloor
                    END
                )
```

2. `FinalEffectiveMultiplier` = the greater of the slice's normal multiplier and the rest floor (never reduces pay) (`:493-500`):
```sql
            FinalEffectiveMultiplier =
                CONVERT(decimal(10,2),
                    CASE
                        WHEN c2.RestMultiplier IS NULL THEN c2.NormalMultiplier
                        WHEN c2.NormalMultiplier >= c2.RestMultiplier THEN c2.NormalMultiplier
                        ELSE c2.RestMultiplier
                    END
                )
```

3. `RestPremiumDelta` (per slice) = only the incremental multiplier above normal, priced at the rest hourly rate (`:505-514`):
```sql
        RestPremiumDelta =
            CONVERT(decimal(19,4),
                CASE
                    WHEN ISNULL(c3.FinalEffectiveMultiplier, 0.00) > ISNULL(c3.NormalMultiplier, 0.00)
                        THEN ISNULL(c3.Slice_Hours, 0.00)
                           * ISNULL(c3.RestHourlyRateForCalc, 0.00)
                           * (ISNULL(c3.FinalEffectiveMultiplier, 0.00) - ISNULL(c3.NormalMultiplier, 0.00))
                    ELSE 0.00
                END
            ),
        RestPremiumAffectedHours = ... CASE WHEN FinalEffectiveMultiplier > NormalMultiplier THEN Slice_Hours ELSE 0.00 END
```

4. `Pay_Rest_Add` = SUM of slice deltas per LaborPayrollID; `Rest_Premium_Hrs` = SUM of affected hours (`:539-543`):
```sql
        RestPremiumHrs = CONVERT(decimal(9,2), SUM(ISNULL(sc.RestPremiumAffectedHours, 0.00))),
        RestPremiumAdd = CONVERT(decimal(19,4), SUM(ISNULL(sc.RestPremiumDelta, 0.00))),
```
and the final write (`:630-636`): `pc.Pay_Rest_Add = CONVERT(decimal(19,4), ap.RestPremiumAdd)`.

**Which rate is used — `RestHourlyRateForCalc` / `RestHourlyRateSource`.** The slice's own `Hourly_Rate_Raw` is preferred; if that is 0, the proc derives an effective rate from the entry's weighted gross. In the Apply proc (`...Apply....PROC.sql:396-431`):
```sql
        RestHourlyRateForCalc =
            CONVERT(decimal(19,6),
                CASE
                    WHEN ISNULL(s.Hourly_Rate_Raw, 0.00) > 0.00
                        THEN ISNULL(s.Hourly_Rate_Raw, 0.00)
                    WHEN (Hrs_ST + 1.5*Hrs_OT + 2.0*Hrs_DT) > 0
                        THEN (Pay_Actual_Gross-excl-rest) / NULLIF(Hrs_ST + 1.5*Hrs_OT + 2.0*Hrs_DT, 0.00)
                    ELSE 0.00
                END )
```
The Prototype proc labels this with `RestHourlyRateSource` (`...SliceChain.PROC.sql:455-469`) — the **three `RestHourlyRateSource` values**:
- `'SliceHourlyRate'` — used slice `Hourly_Rate_Raw`
- `'DerivedFromEntryWeightedGross'` — derived (gross - rest) / weighted hours
- `'ZeroOrMissingRate'` — no usable rate (0)

The weighting used to derive a rate is `WeightedHrs = Hrs_ST + 1.5*Hrs_OT + 2.0*Hrs_DT` (`...Apply....PROC.sql:370-375`).

---

### (d) Overlap handling — Rest_IsOverlap

Overlap is detected two ways and OR'd. Entry-level overlap: current entry starts before the previous entry's end (`...Apply....PROC.sql:134-138`):
```sql
        IsOverlap = CASE
                        WHEN LAG(w.ActualEnd) OVER (...) IS NOT NULL
                         AND w.ActualStart < LAG(w.ActualEnd) OVER (...)
                        THEN 1 ELSE 0
                    END,
```
Chain-level overlap: chain starts before previous chain's end -> `OverlapFromPrev = 1` (and its gap is clamped to 0.00) (`:228-232`). The slice-level flag combines both (`:361`):
```sql
        IsOverlap = CONVERT(bit, CASE WHEN c.OverlapFromPrev = 1 OR e.IsOverlap = 1 THEN 1 ELSE 0 END),
```
and is rolled up as `IsOverlap = MAX(...)` per entry (`:533`) then written to `pc.Rest_IsOverlap` (`:626`). Overlap does NOT stop the premium math — it is a warning flag; overlapping chains simply get `GapHrsFromPrev = 0.00` (so, being < 8h, they keep RestForced ON) and raise an exception Reason (see (g)).

---

### (e) Columns written to fms.Payroll_Calculated and the REST_PERIOD_PREMIUM component

The single UPDATE against `fms.Payroll_Calculated` (`...Apply....PROC.sql:621-639`):
```sql
    UPDATE pc
       SET
        pc.Rest_IsForced = ap.RestForced,
        pc.Rest_ChainId  = ap.ChainId,
        pc.Rest_Gap_Hrs_FromPrevChain = ap.GapHrsFromPrevChain,
        pc.Rest_IsOverlap = ap.IsOverlap,
        pc.Rest_Premium_Hrs = ap.RestPremiumHrs,
        pc.Rest_Policy = 'PunitiveUntil8Off',

        pc.Pay_Actual_Gross = CONVERT(decimal(12,2), ap.ActualGrossBeforeRest),
        pc.Pay_Rest_Add     = CONVERT(decimal(19,4), ap.RestPremiumAdd),
        pc.Final_Gross_Pay  = CONVERT(decimal(12,2),
                                  ISNULL(ap.ActualGrossBeforeRest, 0.00)
                                + ISNULL(pc.Pay_Gap_Add, 0.00)
                                + ISNULL(ap.RestPremiumAdd, 0.00)
                              )
    FROM fms.Payroll_Calculated pc
    JOIN #Apply ap ON ap.LaborPayrollID = pc.LaborPayrollID;
```

Columns written: `Rest_IsForced`, `Rest_ChainId`, `Rest_Gap_Hrs_FromPrevChain`, `Rest_IsOverlap`, `Rest_Premium_Hrs`, `Rest_Policy`, `Pay_Rest_Add`, plus recomputed `Pay_Actual_Gross` and `Final_Gross_Pay`.

**Premium is stored SEPARATELY, not embedded in Pay_Actual_Gross.** The header comment states the architecture (`...Apply....PROC.sql:2-7`): "Pay_Actual_Gross excludes rest premium. Pay_Rest_Add stores rest premium. Final_Gross_Pay = Pay_Actual_Gross + Pay_Gap_Add + Pay_Rest_Add." The proc also defensively backs out any previously-embedded rest amount into `ActualGrossBeforeRest` before recomputing (`:377-394`), so re-runs are idempotent. So the premium IS included in `Final_Gross_Pay` but is NOT part of `Pay_Actual_Gross`.

**REST_PERIOD_PREMIUM pay component** is NOT written by the Apply proc; it is emitted later by `app.usp_Rebuild_PayComponentLedger` from `Pay_Rest_Add` (`sql/app\usp_Rebuild_PayComponentLedger.PROC.sql:539-618`):
```sql
        'REST_PERIOD_PREMIUM',
        'REST_PERIOD',
        'Rest Period Premium',
        ...
        CONVERT(decimal(19,4), ISNULL(pc.Pay_Rest_Add, 0)),   -- ComponentAmount
        CONVERT(bit, 1),  -- IncludedInFinalGross
        CONVERT(bit, 1),  -- IncludedInPayableGross
        40,               -- DisplaySort
        ...
    FROM fms.Payroll_Calculated pc
    WHERE ... AND ISNULL(pc.Pay_Rest_Add, 0) <> 0;
```
ComponentGroup `REST_PERIOD` / ComponentCode `REST_PERIOD_PREMIUM`, amount = `Pay_Rest_Add`, IncludedInFinalGross = 1, only when `Pay_Rest_Add <> 0`.

---

### (f) Difference between the two procs — which one runs in FinalizePayrollOutputs

**`app.usp_Apply_RestPeriod_Premium` is the one that runs in production.** `app.usp_FinalizePayrollOutputs_AfterPricing` calls it as post-processing step 3 (`sql/app\usp_FinalizePayrollOutputs_AfterPricing.PROC.sql:27-32`):
```sql
       3) Rest period premium
    EXEC app.usp_Apply_RestPeriod_Premium
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo,
          @RunId        = @RunId;
```

`app.usp_Prototype_RestPeriod_SliceChain` is never called by the finalizer. It is invoked only by read/report/test objects (`sql/_INDEX.md`): `api.usp_UI_RestPeriod_SliceDetail`, `app.usp_Report_RestPeriod_SliceChain_Impact`, `test.usp_Test_RestPeriod_Punitive`, `test.usp_Test_RestPeriod_SliceChain_Prototype`.

Key differences:
- **Writes vs. reads:** Apply UPDATEs `fms.Payroll_Calculated` and can INSERT into `fms.Payroll_CalcException`. Prototype writes nothing to base tables — it returns up to two result sets (`Detail` and `Rollup`, controlled by `@OutputMode`, lines 689-787) comparing prototype-computed premium vs. the already-stored `Pay_Rest_Add`.
- **Disabled behavior:** Apply PRINT+RETURN (`:66-70`); Prototype THROWs 51000 (`:60-61`).
- **Parameters/scoping:** Prototype adds `@EmpID`, `@LaborPayrollID`, `@IncludeNonForced`, `@LookbackDays`, `@OutputMode` for ad-hoc slicing; Apply takes only date range + `@RunId`.
- **Extra output columns:** Prototype computes and surfaces `RestHourlyRateSource`, `RestReason`, `NormalSlicePay`, `RestAdjustedSlicePay`, and `Difference…` comparison columns that the Apply proc does not.
- The core stitching / RestForced state machine / segment / multiplier math is essentially identical between the two.

---

### (g) Exception Reasons raised

Both are INSERTed into `fms.Payroll_CalcException` by the Apply proc (guarded by column existence and de-duped by LaborPayrollID + Reason + WorkDate):

1. **`RestPeriod_RateMissing (Forced but RateUsed_Est<=0)`** (`...Apply....PROC.sql:571, 591-605`) — raised when an entry is `RestForced = 1` with `RestPremiumHrs > 0` but the derived rate `RateUsed_Est <= 0` (cannot price the premium).
2. **`RestPeriod_Overlap (Start < PrevEnd)`** (`...Apply....PROC.sql:652, 672-685`) — raised for every entry where `IsOverlap = 1` (overlapping chains/entries).

The Prototype proc raises generic argument THROWs (51000) for bad params and the disabled rule, but no rest-specific Reason strings.

---

### Worked example — LaborPayrollID 83285 (REST_FORCED), masked

Read-only SELECT of `fms.Payroll_Calculated` (EmpID masked E***69, name C. S.):

| Field | Value |
|---|---|
| LaborPayrollID | 83285 |
| EmpID | E***69 |
| Employee_Name | C. S. |
| WorkDate | 2026-04-23 |
| Act_Total_Hrs / Hrs_ST / Hrs_OT / Hrs_DT | 4.00 / 4.00 / 0.00 / 0.00 |
| Pay_Actual_Gross (excl. rest) | 163.60 |
| Pay_Gap_Add | 0.00 |
| Pay_Rest_Add | 81.8000 |
| Final_Gross_Pay | 245.40 |
| Rest_IsForced | 1 (True) |
| Rest_ChainId | 106 |
| Rest_Gap_Hrs_FromPrevChain | 5.00 |
| Rest_IsOverlap | 0 (False) |
| Rest_Premium_Hrs | 4.00 |
| Rest_Policy | PunitiveUntil8Off |

Walkthrough: the prior chain had OT/DT and the gap to this chain was 5.00h < 8.00h required, so `Rest_IsForced = 1`. All 4 hours are ST (NormalMultiplier 1.00), and cumulative rest-chain hours are below the 12h OT limit, so `RestMultiplier = OTFloor = 1.50` and `FinalEffectiveMultiplier = 1.50`. Derived rate = `Pay_Actual_Gross / WeightedHrs = 163.60 / 4.00 = 40.90`/hr. Premium = `hours * rate * (1.50 - 1.00) = 4.00 * 40.90 * 0.50 = 81.80` -> `Pay_Rest_Add = 81.80`, `Rest_Premium_Hrs = 4.00`. `Final_Gross_Pay = 163.60 + 0.00 + 81.80 = 245.40` (premium added separately, not in Pay_Actual_Gross).


---

## B7 — Worked-through-lunch (app.usp_Apply_WTL_MealPeriods)

Plain-English: The WTL post-processor looks at the labor a crew member actually worked, figures out
how many meal periods the shift span was *entitled to*, reads the `(PAY:WTL_n)` token from the FCC labor
comment to learn how many of those meals were *worked through / missed*, and then writes three kinds of
0.5-hour pay components: it **deducts** the full priced value of each meal that was *taken*, and **adds** a
premium for each meal that was *worked through* (either a DT-floor top-up on weekday ST-start blocks, or a
flat 0.5h-at-DT "applicable add" everywhere else). Any structural problem (span over threshold, conflicting
tokens, unmatched slice, grouped/overlapping entries, missing token) is logged to
`fms.Payroll_CalcException` as a WTL review/warning/error row instead of, or alongside, the components.

Objects involved:
- `app.usp_Apply_WTL_MealPeriods` (proc, 1225 lines) — `sql/app\usp_Apply_WTL_MealPeriods.PROC.sql`
- `cfg.WTL_Rule` (1 row) and `cfg.WTL_MaxMealThreshold` (5 rows) — read at proc start
- `app.v_LaborPayroll_CommentTokens` (view) — parses `(PAY:WTL_n)` tokens — `sql/app\v_LaborPayroll_CommentTokens.VIEW.sql`
- Inputs: `fms.Labor_PreProcessed`, `api.v_UI_Pricing_Slices_Advanced`
- Writes: `fms.Payroll_PayComponent`, `fms.Payroll_CalcException`
- **`app.LaborBreakOverride` is NOT referenced by this proc** — see (e).

---

### (a) cfg.WTL_Rule / cfg.WTL_MaxMealThreshold values and how the proc reads them

cfg.WTL_Rule (`data/cfg.WTL_Rule.md:5`), single enabled L12 row `L12_WTL_2025`, EffectiveStart 2025-01-01:

| Field | Value |
|---|---|
| MealPeriodHours | **0.50** |
| GroupLookbackDays / GroupLookaheadDays | **4 / 4** |
| StitchGapMinutes | **0** |
| MissingTokenBehavior | **ASSUME_WTL_0_WARN** |
| MealAssignmentPolicy | **TAKEN_EARLIEST_THEN_WTL_REMAINDER** |
| WeekdaySTStartMode | **WTL_DT_FLOOR** |
| NonSTStartMode / Saturday / Sunday / SpecialSaturday / Holiday Mode | **WTL_APPLICABLE_ADD** (all five) |
| AddRateBasis | **BASE_PLUS_SHIFT_EXCLUDE_BOOM** |
| AddMultiplier | **2.00** |
| DeductBasis | **FULL_SELECTED_PRICED_SLICE** |
| SuppressComponentsOnTokenError | **True** |

Note: `MealAssignmentPolicy`, `AddRateBasis`, and `DeductBasis` are columns in `cfg.WTL_Rule` but the proc
does **not** SELECT them into variables — their semantics are hard-coded in the component logic (see (c),(d)).
The proc reads only the variables it declares (`sql/...:59-93`):

```sql
    DECLARE
        @MealPeriodHours decimal(10,2),
        @GroupLookbackDays int,
        @GroupLookaheadDays int,
        @StitchGapMinutes int,
        @MissingTokenBehavior varchar(50),
        @WeekdaySTStartMode varchar(50),
        @NonSTStartMode varchar(50),
        @SaturdayMode varchar(50),
        @SundayMode varchar(50),
        @SpecialSaturdayMode varchar(50),
        @HolidayMode varchar(50),
        @AddMultiplier decimal(10,2),
        @SuppressComponentsOnTokenError bit;

    SELECT TOP (1)
        @MealPeriodHours = r.MealPeriodHours,
        ...
        @AddMultiplier = r.AddMultiplier,
        @SuppressComponentsOnTokenError = r.SuppressComponentsOnTokenError
    FROM cfg.WTL_Rule r
    WHERE r.UnionCode = @UnionCode
      AND r.IsEnabled = 1
      AND @WorkDateFrom >= r.EffectiveStartDate
      AND (r.EffectiveEndDate IS NULL OR @WorkDateFrom <= r.EffectiveEndDate)
    ORDER BY r.EffectiveStartDate DESC, r.WTL_RuleID DESC;

    IF @MealPeriodHours IS NULL
    BEGIN
        THROW 51003, 'No enabled cfg.WTL_Rule row was found for the requested union/date.', 1;
    END;
```

cfg.WTL_MaxMealThreshold (`data/cfg.WTL_MaxMealThreshold.md:5-9`), 5 enabled L12 brackets mapping shift span
to allowed meal count: 0.50–5.00h → **0**; 5.50–10.50 → **1**; 11.00–16.00 → **2**; 16.50–21.50 → **3**;
22.00–27.00 → **4**. It is not read into scalars; it is joined by span in step 5 (see (b)).

`AddRateBasis=BASE_PLUS_SHIFT_EXCLUDE_BOOM`, `AddMultiplier=2.00` and `DeductBasis=FULL_SELECTED_PRICED_SLICE`
manifest in the pricing arithmetic in (d); `MealAssignmentPolicy=TAKEN_EARLIEST_THEN_WTL_REMAINDER` manifests
in the `MealAction` ordering in (c); `MissingTokenBehavior=ASSUME_WTL_0_WARN` in the warning at `:460-466`.

---

### (b) Expected meal count from the shift span (MaxMealThreshold span → meal-count brackets)

The group span is computed in step 4 as (max Pay_End − min Pay_Start) in minutes / 60, to 2 decimals
(`sql/...:298-299`):

```sql
        GroupSpanHours =
            CONVERT(decimal(10,2), DATEDIFF(MINUTE, MIN(gl.Pay_Start), MAX(gl.Pay_End)) / 60.0),
```

In step 5 it is mapped to `Computed_Max_Meals` (= `th.MaxMealPeriods`) by a range LEFT JOIN. Because the join
is a LEFT JOIN, a span **outside every bracket** (e.g. > 27h, or a zero-length edge case) yields
`Computed_Max_Meals = NULL`, which downstream becomes `Warning_SpanExceedsThreshold` and `WTL_Mode='MANUAL_REVIEW'`
(`sql/...:431` and `:494-500`):

```sql
        th.MaxMealPeriods AS Computed_Max_Meals,
        ...
    FROM #GroupAgg ga
    LEFT JOIN cfg.WTL_MaxMealThreshold th
        ON th.UnionCode = @UnionCode
       AND th.IsEnabled = 1
       AND ga.GroupWorkDate >= th.EffectiveStartDate
       AND (th.EffectiveEndDate IS NULL OR ga.GroupWorkDate <= th.EffectiveEndDate)
       AND ga.GroupSpanHours >= th.MinSpanHours
       AND ga.GroupSpanHours <= th.MaxSpanHours
```

`Warning_SpanExceedsThreshold = CASE WHEN th.MaxMealPeriods IS NULL THEN 1 ELSE 0 END` (`sql/...:457-458`).

---

### (c) The WTL token state machine + grouping + taken vs worked-through

**Token parsing (`app.v_LaborPayroll_CommentTokens`).** The FCC comment is de-RTF'd (`fn_StripRTF`),
whitespace-normalized and upper-cased (`v_LaborPayroll_CommentTokens.VIEW.sql:5-67`), then five discrete
`Has_WTL_n` bit flags plus a legacy flag are set by `LIKE '%(PAY:WTL_n)%' OR '%(WTL_n)%'`
(`VIEW:110-162`). The "state" is then derived (`VIEW:165-237`):

- `WTL_TokenCount` = count of distinct WTL_0..WTL_4 flags present (`VIEW:170-175`).
- `WTL_Token_MissedMeals` = the single missed-meal number, but **NULL unless exactly one** WTL_n flag is set;
  otherwise it resolves highest-first (`VIEW:177-195`):
```sql
        WTL_Token_MissedMeals =
            CASE
                WHEN ( ...WTL_0..WTL_4 count... ) <> 1 THEN NULL
                WHEN tf.Has_WTL_4 = 1 THEN 4
                WHEN tf.Has_WTL_3 = 1 THEN 3
                WHEN tf.Has_WTL_2 = 1 THEN 2
                WHEN tf.Has_WTL_1 = 1 THEN 1
                WHEN tf.Has_WTL_0 = 1 THEN 0
                ELSE NULL
            END,
```
- `Has_WTL` = any WTL_n or legacy `(PAY:WTL)`/`(WTL)` (`VIEW:197-208`).
- `Has_ConflictingWTLTokens` = more than one WTL_n flag, OR legacy present together with any numeric WTL_n
  (`VIEW:210-236`).

So the effective "WTL_TokenState" values the proc reasons over are: **no token** (count 0, assume WTL_0),
**one valid numeric token 0–4**, **legacy-only** (`GroupHasLegacyWTL`), and **conflicting/multiple**
(`GroupHasConflictingWTLTokens`).

**Grouping of labor entries (GroupLookback/ahead = 4, StitchGapMinutes = 0).** The grouping window is widened
by ±4 days so a shift that straddles the requested range is fully seen (`sql/...:100-101`):
```sql
    DECLARE @GroupDateFrom date = DATEADD(DAY, -@GroupLookbackDays, @WorkDateFrom);
    DECLARE @GroupDateTo   date = DATEADD(DAY,  @GroupLookaheadDays, @WorkDateTo);
```
Base labor is non-gap L12 rows with valid Pay_Start/Pay_End (`sql/...:119-138`). Entries per EmpID are ordered
by Pay_Start and a new group starts whenever the gap from the previous entry's Pay_End exceeds
`@StitchGapMinutes` (0 → any positive gap breaks the group; back-to-back/overlapping stitch together)
(`sql/...:150-189`):
```sql
            NewGroupFlag =
                CASE
                    WHEN o.PrevPayEnd IS NULL THEN 1
                    WHEN DATEDIFF(MINUTE, o.PrevPayEnd, o.Pay_Start) <= @StitchGapMinutes THEN 0
                    ELSE 1
                END
        ...
        WTL_GroupSeq = SUM(gs.NewGroupFlag) OVER (PARTITION BY gs.EmpID ORDER BY ...)
```
Step 4 aggregates each group's tokens: `GroupTokenCount = SUM(...WTL_TokenCount...)`,
`GroupTokenValue = MAX(...WTL_Token_MissedMeals...)`, and rolls up conflict/legacy/overlap flags
(`sql/...:337-365`). `GroupHasOverlap` = any negative inter-entry gap (`sql/...:328-329`);
`Warning_GroupedLaborEntries` = LaborEntryCount > 1 (`sql/...:468-469`).

**Taken vs worked-through decision (`sql/...:522-542`).** Given `Computed_Max_Meals` (span entitlement) and
the token (missed count):
```sql
        WTL_Missed_Meals =                       -- worked-through count
            ... WHEN gs.HasWTLToken = 0 THEN 0    -- no token => assume WTL_0 => 0 missed
                ELSE gs.WTL_Token_MissedMeals END,
        WTL_Taken_Meals =
            ... WHEN gs.HasWTLToken = 0 THEN gs.Computed_Max_Meals             -- all meals taken
                ELSE gs.Computed_Max_Meals - gs.WTL_Token_MissedMeals END,     -- remainder taken
```
i.e. **Taken = Max − Missed** (all remaining modeled meals are treated as taken), and both are forced NULL on
any blocking error / span-exceeds. This is the `TAKEN_EARLIEST_THEN_WTL_REMAINDER` policy: modeled meal
opportunities are seeded at fixed offsets from GroupStart — **5.0h, 10.5h, 16.0h, 21.5h** (300/630/960/1290
min), each a 30-min window (`sql/...:578-613`) — and the **earliest** `WTL_Taken_Meals` opportunities are
tagged TAKEN_DEDUCT, the rest WORKED_THROUGH (`sql/...:615-620`):
```sql
        MealAction =
            CASE
                WHEN mo.MealOpportunityNumber <= ISNULL(gs.WTL_Taken_Meals, 0)
                    THEN 'TAKEN_DEDUCT'
                ELSE 'WORKED_THROUGH'
            END
```
Each modeled meal opportunity is matched to the earliest overlapping priced slice
(`ps.Slice_Start < MealSlice_End AND ps.Slice_End > MealSlice_Start`, `rn=1` ordered NULL-last then by
Slice_Start, `sql/...:659-682`). An opportunity with **no** overlapping slice keeps `LaborPayrollID = NULL`
and flags the group `HasBlockingReview = 1` (`sql/...:686-698`).

---

### (d) Pricing of WTL_MEAL_DEDUCT, WTL_APPLICABLE_ADD, WTL_DT_FLOOR

The `ComponentCode` is chosen from `MealAction` × `WTL_Mode` (`sql/...:746-753`):
```sql
        ComponentCode =
            CASE
                WHEN LaborPayrollID IS NULL THEN 'WTL_REVIEW_NO_MATCHED_SLICE'
                WHEN MealAction = 'TAKEN_DEDUCT' THEN 'WTL_MEAL_DEDUCT'
                WHEN MealAction = 'WORKED_THROUGH' AND WTL_Mode = 'WTL_DT_FLOOR' THEN 'WTL_DT_FLOOR'
                WHEN MealAction = 'WORKED_THROUGH' AND WTL_Mode = 'WTL_APPLICABLE_ADD' THEN 'WTL_APPLICABLE_ADD'
                ELSE 'WTL_REVIEW'
            END,
```

**`WTL_Mode` per day-type (`sql/...:482-491`)** — this is the "MealBucket" driver. It is decided from the
**first payable slice's** Day_Type / OT-DT bucket:
```sql
        WTL_Mode =
            CASE
                WHEN th.MaxMealPeriods IS NULL THEN 'MANUAL_REVIEW'
                WHEN fs.Day_Type = 'SATURDAY' THEN @SaturdayMode
                WHEN fs.Day_Type = 'SUNDAY' THEN @SundayMode
                WHEN fs.Day_Type = 'SPECIAL_SAT' THEN @SpecialSaturdayMode
                WHEN fs.Day_Type = 'HOLIDAY' THEN @HolidayMode
                WHEN fs.Slice_Bucket IN ('OT', 'DT') THEN @NonSTStartMode
                ELSE @WeekdaySTStartMode
            END
```
With the config values: Sat/Sun/SpecialSat/Holiday and any non-ST (OT/DT) weekday start → `WTL_APPLICABLE_ADD`;
only a **weekday ST-start** block → `WTL_DT_FLOOR`. `Slice_Bucket` itself is derived in the pricing-slice pull
(`sql/...:230-235`): `Final_Multiplier >= Mul_DT → 'DT'`, `= Mul_OT → 'OT'`, else `'ST'`.

**ComponentAmount arithmetic (`sql/...:794-822`):**
```sql
        ComponentAmount =
            CONVERT(decimal(19,4),
                CASE
                    WHEN LaborPayrollID IS NULL THEN NULL

                    WHEN MealAction = 'TAKEN_DEDUCT'
                        THEN -1.00 * ISNULL(Slice_Pay, 0)

                    WHEN MealAction = 'WORKED_THROUGH'
                     AND WTL_Mode = 'WTL_DT_FLOOR'
                        THEN
                            @MealPeriodHours
                          * (ISNULL(Rate_Base, 0) + ISNULL(Rate_Shift, 0))
                          * CASE
                                WHEN @AddMultiplier - ISNULL(Final_Multiplier, 0) > 0
                                THEN @AddMultiplier - ISNULL(Final_Multiplier, 0)
                                ELSE 0
                            END

                    WHEN MealAction = 'WORKED_THROUGH'
                     AND WTL_Mode = 'WTL_APPLICABLE_ADD'
                        THEN
                            @MealPeriodHours
                          * (ISNULL(Rate_Base, 0) + ISNULL(Rate_Shift, 0))
                          * @AddMultiplier

                    ELSE NULL
                END
            ),
```

- **WTL_MEAL_DEDUCT** (`DeductBasis=FULL_SELECTED_PRICED_SLICE`): the *entire* priced slice value is removed,
  `-1 * Slice_Pay`. Recall `Slice_Pay = 0.5 * Hourly_Rate_Raw * Final_Multiplier` and
  `Hourly_Rate_Raw = Rate_Base + Rate_Shift + (boom active ? Rate_Boom : 0)` — so the deduct **includes base,
  shift, boom, and the OT/DT/holiday multiplier** (confirmed by `RateBoomUsed = Rate_Boom_Applied` on deducts,
  `sql/...:827-832`, and the Explanation at `:882-883`).
- **WTL_APPLICABLE_ADD** (`AddRateBasis=BASE_PLUS_SHIFT_EXCLUDE_BOOM`, `AddMultiplier=2.0`): a fresh 0.5h at DT
  on base+shift only, boom excluded: `0.5 * (Rate_Base + Rate_Shift) * 2.0`.
- **WTL_DT_FLOOR** (weekday ST-start): tops the worked-through half-hour *up to* the DT floor —
  `0.5 * (Rate_Base + Rate_Shift) * MAX(AddMultiplier − Final_Multiplier, 0)`. Because it is the ST-start
  bucket, `Final_Multiplier` is typically 1.0, giving a `(2.0 − 1.0) = 1.0` top-up factor; if the slice were
  already at/above DT the floor factor clamps to 0.

Supporting columns: `RateBaseUsed = Rate_Base`, `RateShiftUsed = Rate_Shift` (`sql/...:824-825`);
`RateBoomUsed` = the slice's applied boom on deducts else 0 (`sql/...:827-832`); `MultiplierUsed` =
`Final_Multiplier` on deducts, `@AddMultiplier` on worked-through (`sql/...:834-840`). ComponentHours are
`-0.5` (deduct) / `+0.5` (add) (`sql/...:757-764`), and are split into Hrs_ST/Hrs_OT/Hrs_DT by bucket:
deduct hours land in the slice's own bucket as negatives; **all worked-through add hours land in Hrs_DT**
(`sql/...:766-792`).

Verified against live data (masked): deduct LPID 66632 (E***90) Rate_Base 68.16 + boom 3.00, ×0.5×1.50 =
**−53.37** ✓ (boom included); add LPID 84393 (E***56) Rate_Base 66.03 + Shift 3.00 = 69.03, ×0.5×2.0 =
**+69.03** ✓, Hrs_DT +0.50, RateBoomUsed 0.

---

### (e) Effect of app.LaborBreakOverride

**Not found in this proc.** `app.LaborBreakOverride` is never referenced by `usp_Apply_WTL_MealPeriods` — the
proc derives "worked through vs taken" purely from the `(PAY:WTL_n)` comment token via
`app.v_LaborPayroll_CommentTokens` plus the span→meal-count thresholds. `LaborBreakOverride` is a **separate,
UI-review mechanism** (table has **0 rows**, `data/_TABLE_ROWCOUNTS.md:7`):

- DDL (`ddl/app.LaborBreakOverride.sql:1-10`): `LaborPayrollID` PK, `Breaks_NotTaken_Count tinyint` (CHECK
  0–9 or NULL), `Notes`, `UpdatedAt`, `UpdatedBy`.
- Maintained by `app.usp_Set_LaborBreakOverride` / `app.usp_Clear_LaborBreakOverride`.
- Consumed only by `api.v_LaborPayroll_BreakReview` (`sql/api\v_LaborPayroll_BreakReview.VIEW.sql:38-59`),
  which surfaces `Breaks_NotTaken_Count` and drives `BreaksReviewNeeded` / `NeedsBreakReview_Reason`
  (`WorkedThruLunch='Yes' AND no override entered`). It feeds review dashboards, not the WTL calculation.

So the override table has **no effect on WTL pay-component output**; the WTL calc and the break-review UI are
independent code paths that both trace back to the same FCC comment.

---

### (f) Every WTL exception Reason and its condition

All review/warning/error strings are set in `ReviewReason` in step 9 (`sql/...:910-927`), evaluated in this
priority order (first matching wins), and only for groups touching the primary range with at least one flag
set (`sql/...:939-949`):

```sql
        ReviewReason =
            CASE
                WHEN gs.Warning_SpanExceedsThreshold = 1
                    THEN 'WTL review: grouped labor span exceeds configured threshold.'
                WHEN gs.Error_MultipleWTLTokens = 1
                    THEN 'WTL error: multiple or conflicting WTL tokens found.'
                WHEN gs.Error_TokenExceedsComputedMax = 1
                    THEN 'WTL error: WTL token exceeds computed maximum meal periods.'
                WHEN gs.HasBlockingReview = 1
                    THEN 'WTL review: one or more modeled meal periods did not match a priced slice.'
                WHEN gs.GroupHasOverlap = 1
                    THEN 'WTL warning: grouped labor entries overlap.'
                WHEN gs.Warning_GroupedLaborEntries = 1
                    THEN 'WTL warning: labor entry grouped with another labor entry for WTL rules.'
                WHEN gs.Warning_MissingWTLToken = 1
                    THEN 'WTL warning: no WTL token found; assuming WTL_0.'
                ELSE NULL
            END
```

| Reason string | Trigger condition (source) |
|---|---|
| `WTL review: grouped labor span exceeds configured threshold.` | `Warning_SpanExceedsThreshold=1` → `th.MaxMealPeriods IS NULL`, span fits no bracket (`:457-458`). Blocks components. |
| `WTL error: multiple or conflicting WTL tokens found.` | `Error_MultipleWTLTokens=1` → `GroupTokenCount>1` OR `GroupHasConflictingWTLTokens=1` (`:443-448`; conflict from view `:210-236`). Blocking error. |
| `WTL error: WTL token exceeds computed maximum meal periods.` | `Error_TokenExceedsComputedMax=1` → `GroupTokenValue > th.MaxMealPeriods` (`:450-455`). Blocking error. |
| `WTL review: one or more modeled meal periods did not match a priced slice.` | `HasBlockingReview=1` → a modeled meal opportunity matched no priced slice (`LaborPayrollID IS NULL`, `:686-698`). Non-blocking: valid matched meals still write. |
| `WTL warning: grouped labor entries overlap.` | `GroupHasOverlap=1` → any negative inter-entry gap within group (`:328-329`). |
| `WTL warning: labor entry grouped with another labor entry for WTL rules.` | `Warning_GroupedLaborEntries=1` → `LaborEntryCount>1` (`:468-469`). |
| `WTL warning: no WTL token found; assuming WTL_0.` | `Warning_MissingWTLToken=1` → `MaxMealPeriods>0 AND GroupTokenCount=0 AND @MissingTokenBehavior='ASSUME_WTL_0_WARN'` (`:460-466`). |

Also `WTL_Mode='MANUAL_REVIEW'` when span fits no bracket (`:484`), and component-level codes
`WTL_REVIEW_NO_MATCHED_SLICE` / `WTL_REVIEW` (`:746-753`) which are filtered out of the committed insert
(only the 3 real codes are written). On commit, prior WTL exceptions in range are cleared via
`ex.Reason LIKE 'WTL%'` (`:970-974`).

"Blocking" gating: `HasTokenBlockingError = Error_MultipleWTLTokens OR Error_TokenExceedsComputedMax`
(`:515-520`); groups with a blocking error or span-exceeds are excluded from `#MealOpportunities`
(`:627-628`) and from the component INSERT/preview (`:1054-1055`, `:1128-1129`) — consistent with
`SuppressComponentsOnTokenError=True`.

---

### (g) Columns written and Rule_Hrs_WTL_Net / Rule_Amt_WTL reconciliation

**fms.Payroll_PayComponent** — the WTL components are inserted here (only on `@CommitChanges=1`),
`ComponentGroup='WTL'`, with `IncludedInFinalGross=1` and `IncludedInPayableGross=1` (`sql/...:976-1055`).
Columns written: `RunId, CalcID (from fms.Payroll_Calculated by LaborPayrollID), LaborPayrollID, WorkDate,
JobTicketID, JobCode, EmpID, Employee_Name, ComponentCode, ComponentGroup, ComponentLabel,
SourceSchema='app', SourceTable='usp_Apply_WTL_MealPeriods', SourceID=LaborPayrollID, SourceRuleCode,
SourceRuleName, ComponentHours, Hrs_ST, Hrs_OT, Hrs_DT, RateBaseUsed, RateShiftUsed, RateBoomUsed,
MultiplierUsed, ComponentAmount, IncludedInFinalGross=1, IncludedInPayableGross=1, DisplaySort, Explanation,
CalculatedAtUTC`. Only `WTL_MEAL_DEDUCT`, `WTL_DT_FLOOR`, `WTL_APPLICABLE_ADD` are inserted, and only for
groups without a blocking error / span-exceeds.

**fms.Payroll_CalcException** — review/warning/error rows (`sql/...:1057-1088`):
`CalcRunAt, Reason, LaborPayrollID, WorkDate, EmpID (TRY_CONVERT int), Employee_Name, JobTicketID, JobCode,
Shift_Start (=GroupStart), Shift_End (=GroupEnd), EmpID_Raw, RunId`.

**Note — `fms.Payroll_Calculated` is only READ, never written by this proc.** It is LEFT JOINed solely to fetch
`CalcID` for the component insert (`sql/...:1041-1042`). The task's `Rule_Hrs_WTL_Net` / `Rule_Amt_WTL`
columns are **not found** in this proc's text — this proc does not reference or update either name. They are
presumably rolled up by the downstream finalizer (`app.usp_FinalizePayrollOutputs_AfterPricing`) or a
reporting view from the `ComponentGroup='WTL'` ledger. From the ledger the reconciliation is a straight sum:
- `Rule_Hrs_WTL_Net` ≡ `SUM(ComponentHours)` over WTL = worked-through adds (+0.5 each) minus taken deducts
  (−0.5 each).
- `Rule_Amt_WTL` ≡ `SUM(ComponentAmount)` over WTL = adds (DT premium / DT floor) minus full-slice deducts.

Live totals (`fms.Payroll_PayComponent WHERE ComponentGroup='WTL'`, read-only): WTL_MEAL_DEDUCT 16,106 rows,
−8,053.00 hrs, −$669,283.56; WTL_DT_FLOOR 131 rows, +65.50 hrs, +$3,665.81; WTL_APPLICABLE_ADD 411 rows,
+205.50 hrs, +$27,493.92. Net WTL: −7,782.00 hrs / −$638,123.83.

---

**Worked example (masked, live data).**
- Deduct: LPID 66632 (E***90) — `WTL_MEAL_DEDUCT`, Rate_Base 68.16, boom applied 3.00, OT slice
  (mult 1.50). `Slice_Pay = 0.5 × (68.16+3.00) × 1.50 = 53.37` → **ComponentAmount −53.3700**, ComponentHours
  −0.50, Hrs_OT −0.50. (Full slice incl. boom removed.)
- Add: LPID 84393 (E***56) — `WTL_APPLICABLE_ADD`, Rate_Base 66.03, Rate_Shift 3.00 (shift-2 crew), boom
  excluded. `0.5 × (66.03+3.00) × 2.00 = 69.03` → **ComponentAmount +69.0300**, ComponentHours +0.50, Hrs_DT
  +0.50, MultiplierUsed 2.00.


---

# B8 & B9 — Subsistence pay and California non-union Admin-Hourly overtime

Source objects (dumped verbatim):
- `sql/app\usp_Apply_SubsistencePay.PROC.sql` (209 lines)
- `sql/app\usp_Apply_CA_NonUnionAdminHourly_OT.PROC.sql` (889 lines)
- `sql/app\usp_Rebuild_PayComponentLedger_NonUnionAdminHourly_CA_NonExempt.PROC.sql` (610 lines)
- `sql/api\v_UI_Employee_PayrollGroupRate.VIEW.sql` (220 lines)
- `sql/api\v_UI_Employee_TypeRate.VIEW.sql` (189 lines)
- `sql/app\usp_Preview_CA_NonUnionAdminHourly_OT.PROC.sql`
- `sql/app\usp_Preview_CA_NonUnionAdminHourly_OT_LaborRow.PROC.sql`

---

## B8 — Subsistence (app.usp_Apply_SubsistencePay)

### (a) Plain English
This post-processor writes **per-diem / subsistence allowances** into `fms.Payroll_PayComponent`
for labor rows whose payroll comments carry a subsistence token. It is idempotent: it deletes any
existing `SUBSISTENCE`-group rows in the date range, then re-inserts from the comment tokens. The
amounts are **flat dollar allowances** (not hour × rate), and they are **payable-only** — they are
paid to the employee but are deliberately excluded from `Final_Gross_Pay`.

### (b) Objects involved
- `app.usp_Apply_SubsistencePay` (the proc)
- Reads `fms.Payroll_Calculated pc` joined to `app.v_LaborPayroll_CommentTokens ct` (token flags
  `Has_SUB_SHORT`, `Has_SUB_LONG`, plus `LaborComments_Clean`)
- Writes `fms.Payroll_PayComponent`

### (c) Where the SUB_SHORT / SUB_LONG amounts are configured — LITERAL CONSTANTS IN THE PROC
There is **no config table** for the dollar amounts. They are **hard-coded decimal literals** inside
the proc, documented in a header comment and implemented in the `ComponentAmount` expression.

Header comment stating the rule — `sql/app\usp_Apply_SubsistencePay.PROC.sql:41-49`:
```sql
    /* ------------------------------------------------------------
       Insert subsistence from exact payroll comment tokens only.

       Current rule:
         SUB_SHORT = $85 any day
         SUB_LONG  = $85 weekday, $200 Saturday/Sunday

       This is included in payable gross, but not Final_Gross_Pay.
       ------------------------------------------------------------ */
```

The literal amounts — `sql/app\usp_Apply_SubsistencePay.PROC.sql:125-132`:
```sql
            ComponentAmount =
                CONVERT(decimal(19,4),
                    CASE
                        WHEN Has_SUB_LONG = 1 AND IsWeekend = 1
                            THEN 200.00
                        ELSE 85.00
                    END
                )
```
So: SUB_SHORT and SUB_LONG-weekday both = **$85.00**; SUB_LONG on a weekend = **$200.00**. There is no
separate weekend amount for SUB_SHORT (short is always $85; only LONG splits weekday $85 / weekend $200).

### (d) Component codes actually written (note the `_85` / weekend variant)
`sql/app\usp_Apply_SubsistencePay.PROC.sql:88-96`:
```sql
            ComponentCode =
                CASE
                    WHEN Has_SUB_LONG = 1 AND IsWeekend = 1
                        THEN 'SUBSISTENCE_LONG_WEEKEND_200'
                    WHEN Has_SUB_LONG = 1
                        THEN 'SUBSISTENCE_LONG_WEEKDAY_85'
                    ELSE 'SUBSISTENCE_SHORT_85'
                END,
```
The three codes:
- `SUBSISTENCE_SHORT_85` — short subsistence, $85, any day
- `SUBSISTENCE_LONG_WEEKDAY_85` — long subsistence on a weekday, $85
- `SUBSISTENCE_LONG_WEEKEND_200` — long subsistence on Sat/Sun, $200 (the weekend variant)

The `_85` / `_200` suffix encodes the dollar amount into the code itself. All rows carry
`ComponentGroup = 'SUBSISTENCE'` (literal at `:177`).

Matching labels (`:98-105`): "Short Subsistence", "Long Subsistence - Weekday",
"Long Subsistence - Weekend". Matching `SourceRuleCode` (`:107-114`): `SUB_SHORT`,
`SUB_LONG_WEEKDAY`, `SUB_LONG_WEEKEND`.

### (e) How eligibility is decided from comment tokens (SUB_SHORT / SUB_LONG)
Eligibility comes entirely from the token-flag columns on `app.v_LaborPayroll_CommentTokens`. Only
labor rows whose cleaned comment fired one of the two token flags are pulled in — `:79-83`:
```sql
          AND
          (
              ct.Has_SUB_SHORT = 1
              OR ct.Has_SUB_LONG = 1
          )
```
Selection of the flags — `:62-65`:
```sql
            ct.Has_SUB_SHORT,
            ct.Has_SUB_LONG,
            ct.LaborComments_Clean,
```
Precedence in the code/amount CASEs: `SUB_LONG` wins over `SUB_SHORT` (LONG is tested first; the
`ELSE` branch is SHORT). Weekend vs weekday is decided by `IsWeekend`, computed from the WorkDate,
NOT from a token — `:66-73`:
```sql
            IsWeekend =
                CONVERT(bit,
                    CASE
                        WHEN DATEDIFF(DAY, CONVERT(date, '19000106'), CONVERT(date, pc.WorkDate)) % 7 = 0 -- Saturday
                          OR DATEDIFF(DAY, CONVERT(date, '19000107'), CONVERT(date, pc.WorkDate)) % 7 = 0 -- Sunday
                        THEN 1 ELSE 0
                    END
                )
```
(`19000106` was a Saturday, `19000107` a Sunday — the modulo-7 anchor pattern used throughout the DB.)

### (f) WHY it is payable-only — IncludedInFinalGross = 0, IncludedInPayableGross = 1
The INSERT column list (`:135-166`) maps to the SELECT (`:167-202`). The two inclusion flags are
supplied as literals just after `ComponentAmount` — `sql/app\usp_Apply_SubsistencePay.PROC.sql:192-194`:
```sql
        ComponentAmount,
        CONVERT(bit, 0),      -- IncludedInFinalGross
        CONVERT(bit, 1),      -- IncludedInPayableGross
```
Column positions confirm the mapping: in the INSERT list `IncludedInFinalGross` is at `:162` and
`IncludedInPayableGross` at `:163`, and the SELECT supplies `CONVERT(bit,0)` then `CONVERT(bit,1)` in
the same order. So every subsistence row has **IncludedInFinalGross = 0** and
**IncludedInPayableGross = 1**.

Why: subsistence is a flat expense/per-diem allowance, not earned wages, so it must be **paid out**
(payable gross) yet must NOT inflate `Final_Gross_Pay` (the wage figure that drives downstream wage
calculations). The header comment at `:47-48` states this intent directly: *"This is included in
payable gross, but not Final_Gross_Pay."* Consistent with that, all the hour/rate/multiplier columns
are inserted as `NULL` (`:184-191` — `ComponentHours, Hrs_ST, Hrs_OT, Hrs_DT, RateBaseUsed,
RateShiftUsed, RateBoomUsed, MultiplierUsed` all NULL) because the amount is a flat dollar figure, not
hours × rate. `DisplaySort` = 50 (`:195`). `SourceSchema`/`SourceTable`/`SourceID` =
`'app'` / `'v_LaborPayroll_CommentTokens'` / `LaborPayrollID` (`:179-181`).

### (g) Idempotency delete
`sql/app\usp_Apply_SubsistencePay.PROC.sql:33-39`:
```sql
    DELETE p
    FROM fms.Payroll_PayComponent p
    WHERE p.WorkDate >= @FromDate
      AND p.WorkDate <  DATEADD(DAY, 1, @ToDate)
      AND p.ComponentGroup = 'SUBSISTENCE';

    DECLARE @DeletedRows int = @@ROWCOUNT;
```

### (h) Exception Reasons (THROW list)
Guard clauses at the top of the proc:
- `THROW 51001, '@WorkDateFrom cannot be greater than @WorkDateTo.', 1;` — `:17` (bad date range)
- `THROW 51002, 'Missing app.v_LaborPayroll_CommentTokens.', 1;` — `:23` (token view absent)
- `THROW 51003, 'Missing fms.Payroll_PayComponent.', 1;` — `:26` (target table absent)

`@RunId` fallback: if not passed, taken from `SESSION_CONTEXT(N'PayrollAPP_RunLogID')` — `:19-20`.

---

## B9 — California non-union OT (app.usp_Apply_CA_NonUnionAdminHourly_OT)

### (a) How an employee lands in PayrollGroup = 'Non-Union Admin Hourly'

`PayrollGroup` is just a pass-through rename of `PayrollEmployeeType`, which is **derived entirely in
`api.v_UI_Employee_TypeRate`** and surfaced through `api.v_UI_Employee_PayrollGroupRate`.

**The full derivation CASE (every PayrollGroup value)** — `sql/api\v_UI_Employee_TypeRate.VIEW.sql:50-70`:
```sql
    PayrollEmployeeType =
        CASE
            WHEN e.CraftCode LIKE 'SYS%' THEN 'System-Testing-VendorAccess'

            WHEN e.CraftCode LIKE 'L12%' AND ISNULL(e.EmpTypeId, -1) = 3
                THEN 'L12 Labor Union Mechanic'

            WHEN e.CraftCode LIKE 'L12%' AND ISNULL(e.EmpTypeId, -1) <> 3
                THEN 'L12 Labor Union Field'

            WHEN e.CraftCode LIKE 'ADMIN%' AND e.PayType = 'H'
                THEN 'Non-Union Admin Hourly'

            WHEN e.CraftCode LIKE 'ADMIN%' AND e.PayType = 'S'
                THEN 'Non-Union Admin Salary'

            WHEN e.CraftCode LIKE 'ADMIN%'
                THEN 'Non-Union Admin - Unknown PayType'

            ELSE 'Unknown / Needs Review'
        END,
```
So an employee is **Non-Union Admin Hourly** iff `CraftCode LIKE 'ADMIN%'` **and** `PayType = 'H'`.
Full value map:
- `CraftCode LIKE 'SYS%'` → **System-Testing-VendorAccess**
- `CraftCode LIKE 'L12%'` and `EmpTypeId = 3` → **L12 Labor Union Mechanic**
- `CraftCode LIKE 'L12%'` and `EmpTypeId <> 3` (or NULL) → **L12 Labor Union Field**
- `CraftCode LIKE 'ADMIN%'` and `PayType = 'H'` → **Non-Union Admin Hourly**
- `CraftCode LIKE 'ADMIN%'` and `PayType = 'S'` → **Non-Union Admin Salary**
- `CraftCode LIKE 'ADMIN%'` (other PayType) → **Non-Union Admin - Unknown PayType**
- anything else → **Unknown / Needs Review**

**BaseHourlyRate & BaseHourlyRateSource per branch** — `sql/api\v_UI_Employee_TypeRate.VIEW.sql:82-98`:
```sql
    BaseHourlyRate =
        CAST(
            CASE
                WHEN e.CraftCode LIKE 'L12%' THEN uc.PayRate
                WHEN e.CraftCode LIKE 'ADMIN%' THEN e.PayRate
                WHEN e.CraftCode LIKE 'SYS%' THEN 0.00
                ELSE NULL
            END
        AS decimal(12,4)),

    BaseHourlyRateSource =
        CASE
            WHEN e.CraftCode LIKE 'L12%' THEN 'Employee.CraftCode -> UNION_CRAFT.PayRate'
            WHEN e.CraftCode LIKE 'ADMIN%' THEN 'Employee.PayRate'
            WHEN e.CraftCode LIKE 'SYS%' THEN 'System access / non-payroll'
            ELSE 'Unknown / Needs Review'
        END,
```
So Non-Union Admin (Hourly or Salary) draws its base rate from **`Employee.PayRate`**; L12 union rows
draw from `FMS_UNION_CRAFT.PayRate` (join `uc`); SYS rows are 0.00. The `uc` join is
`src.FMS_UNION_CRAFT_Raw` on CraftCode with UnionCode matching (or NULL, or `'L12'`) —
`v_UI_Employee_TypeRate.VIEW.sql:173-179`.

`PayrollEmployeeTypeSort` (`:72-80`): L12 Field=10, L12 Mechanic=20, ADMIN H=30, ADMIN S=40, SYS=90,
else 99.

**`api.v_UI_Employee_PayrollGroupRate`** wraps that view. It overrides the type to
`System-Testing-VendorAccess` (sort 90, rate NULL, source `'System/default placeholder / non-payroll'`)
for a **default placeholder** employee (EmpID `'DFLT'`/`'DEFAULT'`, or name "DEFAULT EMPLOYEE") —
`v_UI_Employee_PayrollGroupRate.VIEW.sql:8-17` (IsDefaultPlaceholder) and `:66-92`. Then it renames the
columns — `sql/api\v_UI_Employee_PayrollGroupRate.VIEW.sql:149-165`:
```sql
SELECT
    n.*,

    PayrollGroup =
        n.PayrollEmployeeType,

    PayrollGroupSort =
        n.PayrollEmployeeTypeSort,

    PayrollGroupReviewFlag =
        n.EmployeeTypeReviewFlag,
    ...
```
Net: `PayrollGroup` == `PayrollEmployeeType` (except default-placeholder → System-Testing-VendorAccess),
and `BaseHourlyRate` / `BaseHourlyRateSource` carry through unchanged from `v_UI_Employee_TypeRate`
unless the placeholder override fires.

The OT proc filters exactly on this — `sql/app\usp_Apply_CA_NonUnionAdminHourly_OT.PROC.sql:100-105`:
```sql
        LEFT JOIN api.v_UI_Employee_PayrollGroupRate pgr
            ON pgr.EmpID = b.EmpID
        WHERE b.WorkDate >= @WorkDateFrom
          AND b.WorkDate <= @WorkDateTo
          AND ISNULL(pgr.IsVisibleInPayrollUI, 1) = 1
          AND pgr.PayrollGroup = 'Non-Union Admin Hourly'
```

### (b) Thresholds, multipliers, workweek boundary, and hour assignment

**Workweek boundary = Saturday → Friday.** The period start/end are computed with the `19000106`
(a Saturday) modulo-7 anchor — `sql/app\usp_Apply_CA_NonUnionAdminHourly_OT.PROC.sql:71-74`:
```sql
            PeriodStart =
                DATEADD(day, -((DATEDIFF(day, '19000106', CAST(b.WorkDate AS date)) % 7 + 7) % 7), CAST(b.WorkDate AS date)),
            PeriodEnd =
                DATEADD(day, 6 - ((DATEDIFF(day, '19000106', CAST(b.WorkDate AS date)) % 7 + 7) % 7), CAST(b.WorkDate AS date)),
```
`PeriodStart` = the Saturday on/before WorkDate; `PeriodEnd` = the following Friday (`DayOffset` 0..6).
The 7th-day component explanations confirm it: *"seventh day of the **Saturday-Friday workweek**"*
(rebuild proc `:343`, `:363`).

**Daily thresholds and quotas** — `sql/app\usp_Apply_CA_NonUnionAdminHourly_OT.PROC.sql:258-295`.
`IsSeventhConsecutiveDay` = 7 worked days in the week AND this is DayOffset 6 (`:258-259`):
```sql
        IsSeventhConsecutiveDay =
            CAST(CASE WHEN WorkedDayCount = 7 AND DayOffset = 6 THEN 1 ELSE 0 END AS bit),
```
Straight-time quota (`:264-271`):
```sql
        DailySTQuota =
            CAST(
                CASE
                    WHEN WorkedDayCount = 7 AND DayOffset = 6 THEN 0
                    WHEN DailyActualHours <= 8 THEN DailyActualHours
                    ELSE 8
                END
            AS decimal(12,4)),
```
Daily OT quota (`:273-282`):
```sql
        DailyOTQuota =
            CAST(
                CASE
                    WHEN WorkedDayCount = 7 AND DayOffset = 6
                        THEN CASE WHEN DailyActualHours <= 8 THEN DailyActualHours ELSE 8 END
                    WHEN DailyActualHours > 8
                        THEN CASE WHEN DailyActualHours <= 12 THEN DailyActualHours - 8 ELSE 4 END
                    ELSE 0
                END
            AS decimal(12,4)),
```
Daily DT quota (`:284-295`):
```sql
        DailyDTQuota =
            CAST(
                CASE
                    WHEN WorkedDayCount = 7 AND DayOffset = 6 AND DailyActualHours > 8
                        THEN DailyActualHours - 8
                    WHEN WorkedDayCount = 7 AND DayOffset = 6
                        THEN 0
                    WHEN DailyActualHours > 12
                        THEN DailyActualHours - 12
                    ELSE 0
                END
            AS decimal(12,4))
```
Reading the arithmetic out:
- **Normal day (not 7th):** first **8h → ST**; hours **>8 and ≤12 → daily OT** (max 4h);
  hours **>12 → daily DT**.
- **7th consecutive worked day:** ST quota = 0; first **8h → OT** (7th-day OT); hours **>8 → DT**
  (7th-day DT). So on the 7th day everything is premium — nothing is straight time.

**Weekly OT threshold = 40 ST hours.** After daily rules, any straight-time hours beyond 40 in the
Sat-Fri week are reclassified from ST to OT, taken from the **latest** ST hours —
`sql/app\usp_Apply_CA_NonUnionAdminHourly_OT.PROC.sql:445-474`:
```sql
        WeeklyOT_FromThisRow =
            CAST(
                CASE
                    WHEN WeekSTThrough <= 40 THEN 0
                    WHEN WeekSTBefore >= 40 THEN RowST_DailyBase
                    ELSE WeekSTThrough - 40
                END
            AS decimal(12,4)),

        PreviewST =
            CAST(
                RowST_DailyBase -
                CASE
                    WHEN WeekSTThrough <= 40 THEN 0
                    WHEN WeekSTBefore >= 40 THEN RowST_DailyBase
                    ELSE WeekSTThrough - 40
                END
            AS decimal(12,4)),

        PreviewOT =
            CAST(
                RowOT_BeforeWeekly +
                CASE
                    WHEN WeekSTThrough <= 40 THEN 0
                    WHEN WeekSTBefore >= 40 THEN RowST_DailyBase
                    ELSE WeekSTThrough - 40
                END
            AS decimal(12,4)),

        PreviewDT = RowDT,
```
The running weekly-ST windows `WeekSTBefore`/`WeekSTThrough` are cumulative sums of `RowST_DailyBase`
ordered by WorkDate then time-of-day (`:376-402`). Note weekly OT is drawn from ST hours only — daily
OT and DT already removed from the ST pool, so there is no pyramiding.

**The six NONUNION_CA_NONEXEMPT_* codes and their hour sources** are materialized by the rebuild proc
(the apply proc computes PreviewST/OT/DT; the rebuild proc splits them into the six ledger codes).
From `usp_Rebuild_PayComponentLedger_NonUnionAdminHourly_CA_NonExempt.PROC.sql`:
- `NONUNION_CA_NONEXEMPT_ST` ← `PreviewST`, multiplier **1.00** (`:254-267`)
- `NONUNION_CA_NONEXEMPT_DAILY_OT` ← `RowOT_BeforeWeekly` when NOT 7th day, multiplier **1.50**,
  ">8 and through 12 hours" (`:271-287`)
- `NONUNION_CA_NONEXEMPT_WEEKLY_OT` ← `WeeklyOT_FromThisRow`, multiplier **1.50**, ">40 straight-time
  hours" (`:291-306`)
- `NONUNION_CA_NONEXEMPT_DAILY_DT` ← `RowDT` when NOT 7th day, multiplier **2.00**, ">12 hours"
  (`:310-326`)
- `NONUNION_CA_NONEXEMPT_7TH_DAY_OT` ← `RowOT_BeforeWeekly` when 7th day, multiplier **1.50**, "first 8
  hours" on the 7th day (`:330-346`)
- `NONUNION_CA_NONEXEMPT_7TH_DAY_DT` ← `RowDT` when 7th day, multiplier **2.00**, ">8 hours" on the 7th
  day (`:350-366`)

Note the 7th-day split reuses the same `RowOT_BeforeWeekly`/`RowDT` columns but the rebuild proc's own
allocation (`Seventh_OT_*` / `Seventh_DT_*`, `:183-186`) routes first-8h into OT and >8h into DT on the
seventh day. Multiplier summary: ST ×1.0, all OT (daily/weekly/7th) ×1.5, all DT (daily/7th) ×2.0.

### (c) The rate used, and what happens to the union-style buckets

**Rate used = `RegularRate = CAST(pgr.BaseHourlyRate AS decimal(19,4))`** — i.e. `Employee.PayRate`
for ADMIN employees (see B9-a). Set at `sql/app\usp_Apply_CA_NonUnionAdminHourly_OT.PROC.sql:80`:
```sql
            RegularRate = CAST(pgr.BaseHourlyRate AS decimal(19,4)),
```
Gross is `Rate × (ST + 1.5·OT + 2.0·DT)`, computed unrounded and cents-rounded —
`:486-538` (`PreviewPayActualGross_Unrounded` and `PreviewPayActualGross = ROUND(..., 2)`).

**The union-style buckets are OVERWRITTEN** for these rows (only when `@PreviewOnly = 0`). The proc
replaces `Hrs_ST/OT/DT` and `Pay_Actual_Gross` with the CA-nonexempt preview values and **zeros out all
the union-only fields** (gap/guarantee, rest premium) so no L12 logic bleeds through —
`sql/app\usp_Apply_CA_NonUnionAdminHourly_OT.PROC.sql:583-618`:
```sql
    IF @PreviewOnly = 0
    BEGIN
        BEGIN TRANSACTION;

        UPDATE pc
            SET
                pc.Hrs_ST = r.PreviewST,
                pc.Hrs_OT = r.PreviewOT,
                pc.Hrs_DT = r.PreviewDT,
                pc.Pay_Actual_Gross = r.PreviewPayActualGross,

                pc.Gap_Hrs_Total = 0,
                pc.Gap_Hrs_Boom = 0,
                pc.Pay_Total_Hrs = r.Act_Total_Hrs,
                pc.Pay_Gap_Add = 0,

                pc.Pay_Rest_Add = 0,
                pc.Final_Gross_Pay = r.PreviewPayActualGross,

                pc.Audit_Min_Rule = 0,
                pc.Audit_Gap_Mult = 0,

                pc.Rest_IsForced = 0,
                pc.Rest_ChainId = NULL,
                pc.Rest_Gap_Hrs_FromPrevChain = NULL,
                pc.Rest_IsOverlap = 0,
                pc.Rest_Premium_Hrs = 0,
                pc.Rest_Policy = NULL
        FROM fms.Payroll_Calculated pc
        JOIN #RowPreview r
            ON r.LaborPayrollID = pc.LaborPayrollID;

        SET @RowsUpdated = @@ROWCOUNT;

        COMMIT TRANSACTION;
    END;
```
So for these non-union rows: `Final_Gross_Pay` is set equal to `Pay_Actual_Gross` (the CA-OT gross),
`Pay_Total_Hrs` = actual hours, and every gap/guarantee/rest field is forced to 0/NULL. The proc header
(`:39-48`) explicitly disclaims all L12 rules (no guarantee/minimum, no outside-window OT, no
holiday/special-Saturday override, no boom/modifier, no WTL, no rest premium, no subsistence, no ticket
validation). `@PreviewOnly` defaults to **1** (`:5`) so by default nothing is written.

Eligibility filter for the daily/allocation steps additionally requires the **labor** craft code to be
ADMIN and positive hours/rate — `:229-231`, `:337-339`:
```sql
        WHERE ISNULL(LaborCraftCode, '') LIKE 'ADMIN%'
          AND Act_Total_Hrs > 0
          AND ISNULL(RegularRate, 0) > 0
```

### (d) The rebuild proc and the two preview procs

**`app.usp_Rebuild_PayComponentLedger_NonUnionAdminHourly_CA_NonExempt`**
(`@WorkDateFrom date, @WorkDateTo date, @PreviewOnly bit = 1, @RequestedBy sysname = NULL`) —
`:2-6`. It **rebuilds the pay-component ledger** (`fms.Payroll_PayComponent`) for Non-Union Admin
Hourly rows: it re-runs the identical daily/weekly/7th-day allocation math (`:37-246`), then explodes
each labor row's PreviewST/OT/DT into the **six `NONUNION_CA_NONEXEMPT_*` component rows** via the
`UNION ALL` block (`:250-373`), each with its `ComponentCode`, `ComponentGroup='NONUNION_CA_NONEXEMPT'`,
`MultiplierUsed`, and `DisplaySort` 110-160. `ComponentAmount = ROUND(ComponentHours × RegularRate ×
MultiplierUsed, 2)` (`:370`), and a **rounding true-up** is added to the last component per
LaborPayrollID so the ledger reconciles exactly to `fms.Payroll_Calculated.Pay_Actual_Gross`
(`:375-420`, esp. `:408`, `:414-416`). These ledger rows are booked with
**`IncludedInFinalGross = 1` and `IncludedInPayableGross = 1`** (`:409-410`) — unlike subsistence,
CA-OT wages DO count in final gross. When `@PreviewOnly = 0` it **deletes** existing ledger rows for
those LaborPayrollIDs and **inserts** the rebuilt set inside a transaction (`:453-533`); otherwise it
only returns preview/reconciliation result sets (`:535-608`). `SourceTable` on each row is
`'usp_Rebuild_PayComponentLedger_NonUnionAdminHourly_CA_NonExempt'` (`:396`).

**`app.usp_Preview_CA_NonUnionAdminHourly_OT`** (`@WorkDateFrom date, @WorkDateTo date`) — `:2-4`.
Read-only preview (no `@PreviewOnly`, no writes; `SET NOCOUNT ON` only). Loads eligible
Non-Union Admin Hourly labor rows (same `pgr.PayrollGroup = 'Non-Union Admin Hourly'` /
`IsVisibleInPayrollUI` filter, `:47-55`) and returns review + **day-level and week-level** preview
result sets (temp tables `#DailyRaw`, `#DailyBaseRule`, `#DayPreview`, `#WeekPreview`, `:20-23`). Purpose:
a purely informational daily/weekly rollup of what the CA OT rules would produce, with no row-level
allocation ordering.

**`app.usp_Preview_CA_NonUnionAdminHourly_OT_LaborRow`** (`@WorkDateFrom date, @WorkDateTo date`) —
`:2-4`. Also read-only (no writes). The **row-level** counterpart: it reproduces the full
anchored-time allocation (trusted WorkDate anchor; TimeStart/TimeEnd contribute time-of-day only;
overnight when end-TOD < start-TOD moves anchored end to WorkDate+1; missing start time → LaborPayrollID
fallback ordering flagged for review — header `:25-31`, columns `:43-80`). It emits per-labor-row
ST/OT/DT allocation detail so an analyst can audit exactly how each row's hours were classified before
any apply. Purpose: row-by-row allocation/ordering audit preview.

---

### Worked-example note
Per the SHARED_CONTEXT ground rules the DB is read-only and no non-union Admin-Hourly LaborPayrollID is
listed among the sample `test.Case_CorePayrollScenario` IDs (those are all L12/union boom/rest/holiday
cases), so no committed real masked example is quoted here. To produce one, the safe path is to call
`app.usp_Preview_CA_NonUnionAdminHourly_OT_LaborRow @WorkDateFrom, @WorkDateTo` (read-only, no
`@PreviewOnly=0`) for a date range containing an ADMIN/PayType='H' employee and read result set 4
(row allocation detail) — described, not executed.


---

# B10 / B11 — Base-rate fallback + suppression, and the Pay-Component Ledger

All code quoted verbatim with `sql/...:Lstart-Lend` anchors. Read-only documentation; no DB writes were run.

---

## B10 — Base-rate fallback and suppression

Two "safety net" post-processors that run after pricing/guarantee/rest, both keyed on
`app.v_Base_LaborPayroll.Source_Rate_Raw` (the raw FMS source rate). One *fills* pay when it was
missed but a source rate exists; the other *zeroes* pay when no source rate exists at all.

### B10.1 `app.usp_Apply_BasePay_Fallback_FromSource` — fill base pay from `Source_Rate_Raw`

**Plain English.** For labor rows in range that ended up with **zero** `Pay_Actual_Gross` but which
*do* have positive priced hours (`Hrs_ST + Hrs_OT + Hrs_DT > 0`), recompute a fallback gross from the
raw source rate only. It deliberately does **not** fall back to CraftPayRate, `Source_Amount_Raw`, or
`HoursWorked_Raw` (header comment, `usp_Apply_BasePay_Fallback_FromSource.PROC.sql:2-9`).

**Object:** `app.usp_Apply_BasePay_Fallback_FromSource` (params `@WorkDateFrom`, `@WorkDateTo`).

**Exact selection condition + rate/hours math** — `sql/app\usp_Apply_BasePay_Fallback_FromSource.PROC.sql:29-46`:

```sql
            WeightedHrs =
                CONVERT(decimal(19,4),
                    ISNULL(pc.Hrs_ST, 0.0)
                  + 1.5 * ISNULL(pc.Hrs_OT, 0.0)
                  + 2.0 * ISNULL(pc.Hrs_DT, 0.0)
                ),

            EffRate =
                NULLIF(CONVERT(decimal(19,6), ISNULL(blp.Source_Rate_Raw, 0.0)), 0.0)

        FROM fms.Payroll_Calculated pc
        LEFT JOIN app.v_Base_LaborPayroll blp
            ON blp.LaborPayrollID = pc.LaborPayrollID
        WHERE pc.WorkDate >= @FromDT
          AND pc.WorkDate <  @ToExDT
          AND ISNULL(pc.Pay_Actual_Gross, 0.0) = 0.0
          AND (ISNULL(pc.Hrs_ST, 0.0) + ISNULL(pc.Hrs_OT, 0.0) + ISNULL(pc.Hrs_DT, 0.0)) > 0.0
```

So the **trigger condition** is: `Pay_Actual_Gross = 0` AND `(Hrs_ST + Hrs_OT + Hrs_DT) > 0` within
the WorkDate window. `EffRate` is `Source_Rate_Raw` (NULL if 0). Note `WeightedHrs` bakes the OT/DT
multipliers (1.5 / 2.0) directly into the hours — the source rate is treated as a straight-time base
rate and weighted up.

**What it writes** — the `NewPay` derivation and the `UPDATE` — `usp_Apply_BasePay_Fallback_FromSource.PROC.sql:47-66`:

```sql
    calc AS
    (
        SELECT
            LaborPayrollID,
            OldPay,
            NewPay =
                CASE
                    WHEN EffRate IS NOT NULL AND EffRate > 0 AND WeightedHrs > 0
                        THEN CONVERT(decimal(19,4), EffRate * WeightedHrs)
                    ELSE CONVERT(decimal(19,4), 0.0)
                END
        FROM x
    )
    UPDATE pc
       SET pc.Pay_Actual_Gross = c.NewPay,
           pc.Final_Gross_Pay  = pc.Final_Gross_Pay + (c.NewPay - ISNULL(pc.Pay_Actual_Gross, 0.0))
    FROM fms.Payroll_Calculated pc
    JOIN calc c
        ON c.LaborPayrollID = pc.LaborPayrollID
    WHERE c.NewPay > 0;
```

- `NewPay = Source_Rate_Raw * (Hrs_ST + 1.5*Hrs_OT + 2.0*Hrs_DT)`, only when `EffRate>0` and `WeightedHrs>0`.
- **Columns written:** `Pay_Actual_Gross := NewPay`; `Final_Gross_Pay := Final_Gross_Pay + (NewPay - old Pay_Actual_Gross)`.
  Because the selection guarantees the old `Pay_Actual_Gross = 0`, the delta added to `Final_Gross_Pay`
  equals `NewPay`. Rows only update when `NewPay > 0` (missing/zero source rate leaves the row untouched
  for the suppress step below to handle).

### B10.2 `app.usp_SuppressPay_WhenSourceRateMissing` — zero pay when `Source_Rate_Raw` missing

**Plain English.** Final cleanup: if a worked row (`Act_Total_Hrs > 0`) has **no** usable
`Source_Rate_Raw`, force all pay outputs to zero but keep the hours/buckets for review visibility
(header comment, `usp_SuppressPay_WhenSourceRateMissing.PROC.sql:2-12`).

**Object:** `app.usp_SuppressPay_WhenSourceRateMissing` (params `@WorkDateFrom`, `@WorkDateTo`).

**Exact condition + the UPDATE** — `sql/app\usp_SuppressPay_WhenSourceRateMissing.PROC.sql:25-43`:

```sql
    UPDATE pc
       SET Pay_Actual_Gross = CONVERT(decimal(12,2), 0.00),
           Pay_Gap_Add      = CONVERT(decimal(12,2), 0.00),
           Pay_Rest_Add     = CONVERT(decimal(19,4), 0.0000),
           Final_Gross_Pay  = CONVERT(decimal(12,2), 0.00)
    FROM fms.Payroll_Calculated pc
    JOIN app.v_Base_LaborPayroll b
        ON b.LaborPayrollID = pc.LaborPayrollID
    WHERE pc.WorkDate >= @FromDT
      AND pc.WorkDate <  @ToExDT
      AND ISNULL(pc.Act_Total_Hrs, 0) > 0
      AND NULLIF(CONVERT(decimal(19,6), ISNULL(b.Source_Rate_Raw, 0.0)), 0.0) IS NULL
      AND
      (
            ISNULL(pc.Pay_Actual_Gross, 0) <> 0
         OR ISNULL(pc.Pay_Gap_Add, 0) <> 0
         OR ISNULL(pc.Pay_Rest_Add, 0) <> 0
         OR ISNULL(pc.Final_Gross_Pay, 0) <> 0
      );
```

- **Trigger condition:** `Act_Total_Hrs > 0` AND `Source_Rate_Raw` is missing (i.e.
  `NULLIF(Source_Rate_Raw,0) IS NULL` — NULL or 0) AND at least one of the four pay columns is currently
  non-zero.
- **Columns set (value):** `Pay_Actual_Gross = 0.00`, `Pay_Gap_Add = 0.00`, `Pay_Rest_Add = 0.0000`,
  `Final_Gross_Pay = 0.00`. Hours columns are intentionally left intact.
- **Effect on `Final_Gross_Pay`:** it is forced to `0.00` for these rate-less rows (the row is worked but
  unpayable until a source rate is supplied).

---

## B11 — The ledger (`app.usp_Rebuild_PayComponentLedger`), rounding, reconciliation

`app.usp_Rebuild_PayComponentLedger` (params `@WorkDateFrom`, `@WorkDateTo`, `@RunId`) deletes then
rebuilds `fms.Payroll_PayComponent` rows for the range (`usp_Rebuild_PayComponentLedger.PROC.sql:16-19`),
inserting one row per pay component. It reads priced slices from `api.v_UI_Pricing_Slices_Advanced` and
guarantee allocations from `fms.Payroll_GuaranteeAllocation`.

### (a) Splitting `Pay_Actual_Gross` into base / shift / boom lines

The stated identity (`usp_Rebuild_PayComponentLedger.PROC.sql:21-30`):
`Pay_Actual_Gross = ACTUAL_BASE_WORKED_PAY + ACTUAL_BOOM_WORKED_PAY + ACTUAL_SHIFT_DIFFERENTIAL`, with the
**base** component absorbing the penny/rounding true-up so the ledger matches
`fms.Payroll_Calculated.Pay_Actual_Gross` exactly.

**Per-slice sums** (`SliceSplit` CTE) — `usp_Rebuild_PayComponentLedger.PROC.sql:31-88`. Each amount is
`SUM(Slice_Hours * Rate_x * Final_Multiplier)`; the "hours" for shift/boom lines only count slices whose
respective rate is non-zero:

```sql
            ActualBaseWorkedPay_Raw =
                SUM(CONVERT(decimal(19,4),
                    ISNULL(ps.Slice_Hours, 0)
                  * ISNULL(ps.Rate_Base, 0)
                  * ISNULL(ps.Final_Multiplier, 1)
                )),

            ActualShiftDifferential =
                SUM(CONVERT(decimal(19,4),
                    ISNULL(ps.Slice_Hours, 0)
                  * ISNULL(ps.Rate_Shift, 0)
                  * ISNULL(ps.Final_Multiplier, 1)
                )),

            ActualBoomWorkedPay =
                SUM(CONVERT(decimal(19,4),
                    ISNULL(ps.Slice_Hours, 0)
                  * ISNULL(ps.Rate_Boom_Applied, 0)
                  * ISNULL(ps.Final_Multiplier, 1)
                )),
...
            ShiftSliceHours =
                SUM(CONVERT(decimal(10,2),
                    CASE WHEN ISNULL(ps.Rate_Shift, 0) <> 0
                         THEN ISNULL(ps.Slice_Hours, 0) ELSE 0 END)),
            BoomSliceHours =
                SUM(CONVERT(decimal(10,2),
                    CASE WHEN ISNULL(ps.Rate_Boom_Applied, 0) <> 0
                         THEN ISNULL(ps.Slice_Hours, 0) ELSE 0 END)),
            MaxRateBase   = MAX(CONVERT(decimal(12,4), ISNULL(ps.Rate_Base, 0))),
            MaxRateShift  = MAX(CONVERT(decimal(12,4), ISNULL(ps.Rate_Shift, 0))),
            MaxRateBoomApplied = MAX(CONVERT(decimal(12,4), ISNULL(ps.Rate_Boom_Applied, 0)))
```

**The penny true-up** applied to the base line (`ActualSplit` CTE) — `usp_Rebuild_PayComponentLedger.PROC.sql:111-135`:

```sql
            ActualBaseWorkedPay =
                CONVERT(decimal(19,4),
                    ISNULL(ss.ActualBaseWorkedPay_Raw, 0)
                  + (
                        CONVERT(decimal(19,4), ISNULL(pc.Pay_Actual_Gross, 0))
                      - CONVERT(decimal(19,4),
                            ISNULL(ss.ActualBaseWorkedPay_Raw, 0)
                          + ISNULL(ss.ActualShiftDifferential, 0)
                          + ISNULL(ss.ActualBoomWorkedPay, 0)
                        )
                    )
                ),
```

i.e. `ActualBaseWorkedPay = Raw base + (Pay_Actual_Gross − (Raw base + Shift + Boom))`, forcing
base+shift+boom to total exactly `Pay_Actual_Gross`. Only rows with `Pay_Actual_Gross <> 0` are processed
(`:132-134`).

**The three line rows** are produced by a `CROSS APPLY (VALUES ...)` and inserted only where
`ComponentAmount <> 0` (`WHERE ISNULL(v.ComponentAmount,0) <> 0`, `:287`). Column mapping per line
(`usp_Rebuild_PayComponentLedger.PROC.sql:199-287`):

| ComponentCode | Group | ComponentHours | RateBaseUsed | RateShiftUsed | RateBoomUsed | MultiplierUsed | ComponentAmount | DisplaySort |
|---|---|---|---|---|---|---|---|---|
| `ACTUAL_BASE_WORKED_PAY` | ACTUAL | `ActualSliceHours` (all slice hrs) | `MaxRateBase` | 0 | 0 | NULL | `ActualBaseWorkedPay` (true-up) | 10 |
| `ACTUAL_SHIFT_DIFFERENTIAL` | ACTUAL | `ShiftSliceHours` | 0 | `MaxRateShift` | 0 | NULL | `ActualShiftDifferential` | 12 |
| `ACTUAL_BOOM_WORKED_PAY` | ACTUAL | `BoomSliceHours` | 0 | 0 | `MaxRateBoomApplied` | NULL | `ActualBoomWorkedPay` | 14 |

The base line also carries `Hrs_ST/Hrs_OT/Hrs_DT` from `Payroll_Calculated` (`:213-214`, `a.Hrs_ST/OT/DT`);
shift and boom lines write NULL for those. `MultiplierUsed` is NULL on all three actual lines because the
multiplier is already folded into `Final_Multiplier` inside each amount. Verbatim VALUES block for the base line, `usp_Rebuild_PayComponentLedger.PROC.sql:202-222`:

```sql
        (
            'ACTUAL_BASE_WORKED_PAY',
            'ACTUAL',
            'Actual Base Worked Pay',
            'api',
            'v_UI_Pricing_Slices_Advanced',
            a.CalcID,
            NULL,
            'Actual base worked pay',
            a.ActualSliceHours,
            a.Hrs_ST,
            a.Hrs_OT,
            a.Hrs_DT,
            a.MaxRateBase,
            CONVERT(decimal(12,4), 0),
            CONVERT(decimal(12,4), 0),
            NULL,
            a.ActualBaseWorkedPay,
            10,
            'Actual worked base pay from pricing slices; includes penny true-up to fms.Payroll_Calculated.Pay_Actual_Gross.'
        ),
```

### (b) Every ComponentGroup and DisplaySort ordering

The rebuild proc emits these groups/codes with fixed `DisplaySort`:

| DisplaySort | ComponentGroup | ComponentCode(s) | Meaning | Proc:line |
|---|---|---|---|---|
| 10 | `ACTUAL` | `ACTUAL_BASE_WORKED_PAY` | Worked base pay from priced slices (with penny true-up) | `:220` |
| 12 | `ACTUAL` | `ACTUAL_SHIFT_DIFFERENTIAL` | Worked shift-differential adder (`Slice_Hours*Rate_Shift*Final_Multiplier`) | `:241` |
| 14 | `ACTUAL` | `ACTUAL_BOOM_WORKED_PAY` | Worked boom-pole premium (`Slice_Hours*Rate_Boom_Applied*Final_Multiplier`) | `:262` |
| 20 | `GUARANTEE` | `GUARANTEED_BASE_PAY_ADD` / `GUARANTEED_HOLIDAY_BASE_PAY_ADD` / `GUARANTEED_SPECIAL_SAT_BASE_PAY_ADD` | Guaranteed-hours base gap pay (`AllocatedGapHours*RateBaseUsed*MultiplierUsed`); code chosen by RuleCode | `:334-369` |
| 22 | `GUARANTEE` | `GUARANTEED_SHIFT_DIFFERENTIAL_ADD` | Shift-diff portion split out of the guarantee (`*RateShiftUsed*`) | `:425-448` |
| 30 | `GUARANTEE` | `GUARANTEED_BOOM_PAY_ADD` | Boom portion of the guarantee (`*RateBoomUsed*`) | `:504-527` |
| 40 | `REST_PERIOD` | `REST_PERIOD_PREMIUM` | Rest-period premium = `Pay_Rest_Add`; ComponentHours = `Rest_Premium_Hrs` | `:587-606` |

DisplaySort values injected by the **other two procs** (so the ledger sorts as one list):
- `35` `GUARANTEE` / `GUARANTEE_RECONCILIATION_ADJUSTMENT` (finalizer, `usp_Finalize_...:101-120`).
- `90` `ROUNDING` / `PAY_COMPONENT_ROUNDING_ADJUSTMENT` (normalize `:196-207`; finalizer `:306-325`).

Per `_SHARED_CONTEXT.md:65-71`, other groups written elsewhere in the pipeline (not by this proc) include
`SHIFT_DIFFERENTIAL/SHIFT_2_HOURS_ADD`, `SUBSISTENCE/*` (payable-only, `IncludedInFinalGross=0`),
`WTL/WTL_APPLICABLE_ADD|WTL_DT_FLOOR|WTL_MEAL_DEDUCT`, and `NONUNION_CA_NONEXEMPT/*`. Ordering is by
ascending `DisplaySort`: actual (10/12/14) → guarantee reconciliation (35) → guarantee base/shift/boom
(20/22/30) → rest (40) → rounding (90). Note the guarantee reconciliation adjustment (35) sorts *ahead*
of the guarantee base adds (20 is actually lower — so base adds 20/22, boom 30, then reconciliation 35).

All rebuild-proc rows are inserted with `IncludedInFinalGross = 1` and `IncludedInPayableGross = 1`
(`usp_Rebuild_PayComponentLedger.PROC.sql:194-195`, and repeated per insert).

### (c) `app.fn_RoundMoney` and how rounding-adjustment rows are generated

**`app.fn_RoundMoney` — full definition, `sql/app\fn_RoundMoney.FN.sql:1-12`:**

```sql

CREATE   FUNCTION app.fn_RoundMoney
(
    @Amount decimal(38,10)
)
RETURNS decimal(19,2)
WITH SCHEMABINDING
AS
BEGIN
    RETURN CONVERT(decimal(19,2), ROUND(@Amount, 2));
END;
```

Plain half-away-from-zero `ROUND(...,2)` returning `decimal(19,2)`.

**`app.usp_Normalize_PayComponentLedger_Rounding`** (params `@WorkDateFrom/@To/@RunId`) does four things:

1. Rounds the money columns on `fms.Payroll_Calculated` (`Pay_Actual_Gross`, `Pay_Gap_Add`,
   `Pay_Rest_Add`, `Final_Gross_Pay`) via `fn_RoundMoney` (`:36-44`).
2. Deletes any existing `PAY_COMPONENT_ROUNDING_ADJUSTMENT` rows in range (`:52-56`) for idempotency.
3. Rounds every non-rounding component amount to cents, only where it differs by `>= 0.0001` (`:68-81`).
4. Inserts **one** rounding-adjustment row per labor entry when needed. The comparison is **WTL-aware**:
   the ledger sum excludes `WTL_MEAL_DEDUCT`, `WTL_DT_FLOOR`, `WTL_APPLICABLE_ADD`.

**The WTL-excluding ledger sum + the diff** — `usp_Normalize_PayComponentLedger_Rounding.PROC.sql:100-146`:

```sql
    ;WITH Ledger AS
    (
        SELECT
            p.LaborPayrollID,
            LedgerFinalGross_ExcludingWTL =
                SUM
                (
                    CASE
                        WHEN p.IncludedInFinalGross = 1
                         AND p.ComponentCode NOT IN
                            (
                                'WTL_MEAL_DEDUCT',
                                'WTL_DT_FLOOR',
                                'WTL_APPLICABLE_ADD'
                            )
                            THEN CONVERT(decimal(19,4), ISNULL(p.ComponentAmount, 0))
                        ELSE CONVERT(decimal(19,4), 0)
                    END
                )
        FROM fms.Payroll_PayComponent p
        WHERE p.WorkDate >= @FromDate
          AND p.WorkDate <  DATEADD(DAY, 1, @ToDate)
        GROUP BY p.LaborPayrollID
    ),
    Diff AS
    (
        SELECT
            ...
            RoundingDiff =
                app.fn_RoundMoney
                (
                    CONVERT(decimal(38,10), ISNULL(pc.Final_Gross_Pay, 0))
                  - CONVERT(decimal(38,10), ISNULL(l.LedgerFinalGross_ExcludingWTL, 0))
                )
        FROM fms.Payroll_Calculated pc
        LEFT JOIN Ledger l ON l.LaborPayrollID = pc.LaborPayrollID
        WHERE ...
    )
```

The insert writes `ComponentCode='PAY_COMPONENT_ROUNDING_ADJUSTMENT'`, `ComponentGroup='ROUNDING'`,
`SourceRuleCode='FINAL_GROSS_LEDGER_ROUNDING'`, `DisplaySort=90`, `ComponentAmount = RoundingDiff`,
only for rows where `ABS(RoundingDiff) >= 0.01` (`:179-210`). Net effect: the non-WTL ledger is forced to
tie exactly to `fms.Payroll_Calculated.Final_Gross_Pay`.

### (d) Reconciliation rows and tie-out checks (`app.usp_Finalize_PayComponentLedger_Reconciliation`)

Params `@WorkDateFrom/@To`. Five steps:

0. Delete existing `PAY_COMPONENT_ROUNDING_ADJUSTMENT` rows for idempotency (`:20-24`).
1. **Delete stale guarantee components** where the current calculated row has no gap pay —
   `usp_Finalize_...:32-39`:

```sql
    DELETE p
    FROM fms.Payroll_PayComponent p
    JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = p.LaborPayrollID
    WHERE p.WorkDate >= @FromDate
      AND p.WorkDate <  DATEADD(DAY, 1, @ToDate)
      AND p.ComponentGroup = 'GUARANTEE'
      AND ISNULL(pc.Pay_Gap_Add, 0) = 0;
```

2. **Insert a guarantee reconciliation row** where `Pay_Gap_Add <> 0` but no guarantee ledger amount
   exists (`GuaranteeLedgerAmount = 0`) — `ComponentCode='GUARANTEE_RECONCILIATION_ADJUSTMENT'`,
   `SourceRuleCode='PAY_GAP_ADD_RECONCILIATION'`, `DisplaySort=35`, `ComponentAmount = Pay_Gap_Add`
   (`:47-128`, filter at `:125-128`).
3. **True-up guarantee components** so the guarantee ledger equals `Pay_Gap_Add` exactly. The diff is
   applied to a single chosen guarantee row (top by DisplaySort desc, |amount| desc, id desc) —
   `usp_Finalize_...:149-199`:

```sql
    d AS
    (
        SELECT
            pc.LaborPayrollID,
            DiffAmount =
                CONVERT(decimal(19,4), ISNULL(pc.Pay_Gap_Add, 0))
              - CONVERT(decimal(19,4), ISNULL(g.GuaranteeLedgerAmount, 0))
        ...
          AND ABS( ... Pay_Gap_Add ... - ... GuaranteeLedgerAmount ... ) >= 0.0001
    ),
    ...
    UPDATE p
       SET p.ComponentAmount =
                CONVERT(decimal(19,4), p.ComponentAmount + t.DiffAmount),
```

4. **Insert explicit final-gross rounding adjustment** — same WTL-aware comparison as the normalize proc,
   but here `RoundingDiff` is a plain subtraction (not wrapped in `fn_RoundMoney`) and every diff row is
   inserted (no `>= 0.01` guard on the insert; the `>= 0.0001` guard is in the `diff` CTE) —
   `usp_Finalize_...:216-263`:

```sql
    ;WITH ledger AS
    (
        SELECT
            p.LaborPayrollID,
            LedgerFinalGross_ExcludingWTL =
                SUM
                (
                    CASE
                        WHEN p.IncludedInFinalGross = 1
                        AND p.ComponentCode NOT IN
                            ('WTL_MEAL_DEDUCT','WTL_DT_FLOOR','WTL_APPLICABLE_ADD')
                            THEN CONVERT(decimal(19,4), p.ComponentAmount)
                        ELSE CONVERT(decimal(19,4), 0)
                    END
                )
        FROM fms.Payroll_PayComponent p
        WHERE ... GROUP BY p.LaborPayrollID
    ),
    diff AS
    (
        SELECT
            ...
            RoundingDiff =
                CONVERT(decimal(19,4), ISNULL(pc.Final_Gross_Pay, 0))
            - CONVERT(decimal(19,4), ISNULL(l.LedgerFinalGross_ExcludingWTL, 0))
        FROM fms.Payroll_Calculated pc
        LEFT JOIN ledger l ON l.LaborPayrollID = pc.LaborPayrollID
        WHERE ...
        AND ABS( Final_Gross_Pay - LedgerFinalGross_ExcludingWTL ) >= 0.0001
    )
    INSERT fms.Payroll_PayComponent (...) SELECT ... 'PAY_COMPONENT_ROUNDING_ADJUSTMENT', 'ROUNDING', ...
```

**`LedgerTieOutStatus` is NOT set in this proc.** The finalizer only PRINTs counters (`:331-335`); it emits
no status column. The actual **`LedgerTieOutStatus`** value lives in the reporting view
`api.v_UI_Payroll_LaborEntry_Ledger_Summary` — `sql/api\v_UI_Payroll_LaborEntry_Ledger_Summary.VIEW.sql:210-229`:

```sql
    LedgerTieOutStatus =
        CASE
            WHEN ca.LaborPayrollID IS NULL THEN 'No ledger rows'
            WHEN ABS(
                ISNULL(ca.LedgerPayableGross, 0)
              - (
                    ISNULL(ca.LedgerFinalGross, 0)
                  + ISNULL(ca.PayableOnlyAmount, 0)
                )
            ) <= 0.01
             AND ABS(
                ISNULL(ca.LedgerFinalGross, 0)
              - (
                    ISNULL(pc.Final_Gross_Pay, 0)
                  + ISNULL(ca.WTLAmount, 0)
                )
             ) <= 0.01
            THEN 'Balanced'
            ELSE 'Out of balance'
        END,
```

So `LedgerTieOutStatus` values are **`'No ledger rows'`**, **`'Balanced'`**, **`'Out of balance'`**.
Two conditions must both hold (within 0.01): (i) `LedgerPayableGross = LedgerFinalGross + PayableOnlyAmount`,
and (ii) `LedgerFinalGross = Final_Gross_Pay + WTLAmount`.

A second, parallel status **`ReconciliationStatus`** ('OK' / 'Out of balance') lives in
`api.v_UI_Payroll_PayComponent_Summary.VIEW.sql:223-229`, comparing `Final_Gross_Pay` to both
`LedgerFinalGross` and `LedgerPayableGross` within 0.01.

### (e) Final formulas as the code computes them

The five named formulas are **not** produced by the ledger/rounding/reconciliation procs — they are
columns in the reporting view `api.v_UI_Payroll_LaborEntry_Ledger_Summary`. The underlying ledger
aggregates (`ComponentAgg` CTE, `:4-129`) define:
`LedgerFinalGross = SUM(ComponentAmount WHERE IncludedInFinalGross=1)` (`:15-20`);
`LedgerPayableGross = SUM(ComponentAmount WHERE IncludedInPayableGross=1)` (`:22-27`);
`PayableOnlyAmount = SUM(ComponentAmount WHERE IncludedInPayableGross=1 AND IncludedInFinalGross=0)` (`:29-35`);
`WTLAmount = SUM(ComponentAmount WHERE ComponentGroup='WTL' OR ComponentCode LIKE 'WTL%')` (`:71-77`).

| Formula | Expression (as coded) | Anchor |
|---|---|---|
| **Final_Gross_Pay** | `= fms.Payroll_Calculated.Final_Gross_Pay` (surfaced as `PayrollCalculated_FinalGross`, and again as `Final_Gross_Pay` in the PayComponent summary) | Ledger_Summary `:146`; PayComponent_Summary `:166-167` |
| **LaborGross_BeforeWTL** | `= CAST(ISNULL(pc.Final_Gross_Pay,0) AS decimal(19,4))` — the calculated final gross *before* WTL adjustments | Ledger_Summary `:148-149` |
| **LaborGross_AfterWTL** | `= CAST(ISNULL(ca.LedgerFinalGross,0) AS decimal(19,4))` — the ledger final gross, which by construction = Final_Gross_Pay + WTL components | Ledger_Summary `:154-155` |
| **PayableOnlyAmount** | `= CAST(ISNULL(ca.PayableOnlyAmount,0) AS decimal(19,4))` = SUM of components with `IncludedInPayableGross=1 AND IncludedInFinalGross=0` (e.g. subsistence) | Ledger_Summary `:160-161` (agg `:29-35`) |
| **TotalPayableGross** | `= CAST(ISNULL(ca.LedgerPayableGross,0) AS decimal(19,4))` = SUM(ComponentAmount WHERE IncludedInPayableGross=1) = LaborGross_AfterWTL + PayableOnlyAmount | Ledger_Summary `:163-164` (agg `:22-27`) |

Verbatim, `sql/api\v_UI_Payroll_LaborEntry_Ledger_Summary.VIEW.sql:146-164`:

```sql
    pc.Final_Gross_Pay AS PayrollCalculated_FinalGross,

    LaborGross_BeforeWTL =
        CAST(ISNULL(pc.Final_Gross_Pay, 0) AS decimal(19,4)),

    WTLAdjustment =
        CAST(ISNULL(ca.WTLAmount, 0) AS decimal(19,4)),

    LaborGross_AfterWTL =
        CAST(ISNULL(ca.LedgerFinalGross, 0) AS decimal(19,4)),

    SubsistenceAllowance =
        CAST(ISNULL(ca.SubsistenceAmount, 0) AS decimal(19,4)),

    PayableOnlyAmount =
        CAST(ISNULL(ca.PayableOnlyAmount, 0) AS decimal(19,4)),

    TotalPayableGross =
        CAST(ISNULL(ca.LedgerPayableGross, 0) AS decimal(19,4)),
```

The intended relationships (asserted by `ExpectedLedgerTotalAmount` and the tie-out at `:172-194`):
`TotalPayableGross = LaborGross_AfterWTL + PayableOnlyAmount`, and `LaborGross_AfterWTL = LaborGross_BeforeWTL + WTLAdjustment`.

**Payable Hrs = ST + OT + DT + H2x + H3x — CONFIRMED.** Computed in
`api.v_UI_Payroll_LaborEntry_HourBuckets` as the sum of the five actual-slice buckets plus the five
matching rule buckets (`sql/api\v_UI_Payroll_LaborEntry_HourBuckets.VIEW.sql:257-269`):

```sql
    Payable_Hrs =
        CAST(
            ISNULL(sb.Actual_Hrs_ST, 0)
          + ISNULL(sb.Actual_Hrs_OT, 0)
          + ISNULL(sb.Actual_Hrs_DT, 0)
          + ISNULL(sb.Actual_Hrs_H2x, 0)
          + ISNULL(sb.Actual_Hrs_H3x, 0)
          + ISNULL(rbc.Rule_Hrs_ST, 0)
          + ISNULL(rbc.Rule_Hrs_OT, 0)
          + ISNULL(rbc.Rule_Hrs_DT, 0)
          + ISNULL(rbc.Rule_Hrs_H2x, 0)
          + ISNULL(rbc.Rule_Hrs_H3x, 0)
        AS decimal(10,2)),
```

where H2x = `Day_Type='SPECIAL_SAT'` hours and H3x = `Day_Type='HOLIDAY'` hours (`:36-48`); the exported
`Hrs_ST/OT/DT/H2x/H3x` columns (`:271-284`) each combine the actual-slice bucket with the rule bucket, and
`Payable_Hrs` is their total. So `Payable Hrs = Hrs_ST + Hrs_OT + Hrs_DT + Hrs_H2x + Hrs_H3x` exactly.
```


---

## B12 — Orchestration

This section documents the orchestration layer of the TCG payroll system: the wrapper procedures that
sequence the post-pricing pipeline, the nightly ETL driver, the UI-triggered refresh, and the pay-period
freeze/snapshot process. All quotes are verbatim from the dumped `.sql` files with `file:line` anchors.
Work is read-only; none of these write procedures were executed.

---

### (a) `app.usp_FinalizePayrollOutputs_AfterPricing` — the post-pricing pipeline

**Plain English.** This is the wrapper that owns the entire post-pricing chain. After the pricing engine has
written one row per `LaborPayrollID` into `fms.Payroll_Calculated`, this proc runs the post-processors in a
fixed order and rebuilds the pay-component ledger. Several steps are gated on an explicit `@WorkDateFrom` /
`@WorkDateTo` date range (CA non-union OT, non-union ledger rebuild, and WTL are skipped with a `PRINT`
message if either date is NULL). Parameters: `@WorkDateFrom date=NULL`, `@WorkDateTo date=NULL`,
`@RunId int=NULL`.

**Objects involved:** `app.usp_FinalizePayrollOutputs_AfterPricing` (wrapper) calling
`app.usp_Apply_BasePay_Fallback_FromSource`, `app.usp_Apply_GuaranteedHours`,
`app.usp_Apply_RestPeriod_Premium`, `app.usp_SuppressPay_WhenSourceRateMissing`,
`app.usp_Apply_CA_NonUnionAdminHourly_OT`, `app.usp_Rebuild_PayComponentLedger`,
`app.usp_Rebuild_PayComponentLedger_NonUnionAdminHourly_CA_NonExempt`,
`app.usp_Apply_ShiftDifferentialHoursAdd`, `app.usp_Apply_WTL_MealPeriods`,
`app.usp_Finalize_PayComponentLedger_Reconciliation`, `app.usp_Apply_SubsistencePay`,
`app.usp_Normalize_PayComponentLedger_Rounding`.

**Exact call order (numbered to match the quoted code).** Note: the code's own comment numbering skips around
(step 4 = suppress, 4.5 = CA OT, 5 = ledger, 5.5 = non-union ledger, 6 = shift-diff, 7 = WTL, 8 =
reconciliation, 9 = subsistence, 10 = rounding). The list below is the ACTUAL EXEC execution order top to
bottom in the procedure body:

1. **Base pay fallback** — `app.usp_Apply_BasePay_Fallback_FromSource` (`@WorkDateFrom`, `@WorkDateTo`).
2. **Guaranteed hours / minimum pay** — `app.usp_Apply_GuaranteedHours` (`@WorkDateFrom`, `@WorkDateTo`, `@RunId`).
3. **Rest period premium** — `app.usp_Apply_RestPeriod_Premium` (`@WorkDateFrom`, `@WorkDateTo`, `@RunId`).
4. **Suppress pay when source rate missing** — `app.usp_SuppressPay_WhenSourceRateMissing` (`@WorkDateFrom`, `@WorkDateTo`).
5. **CA non-union admin hourly OT/DT** — `app.usp_Apply_CA_NonUnionAdminHourly_OT` (date-gated).
6. **Rebuild pay-component ledger** — `app.usp_Rebuild_PayComponentLedger` (`@WorkDateFrom`, `@WorkDateTo`, `@RunId`).
7. **Rebuild non-union admin hourly CA nonexempt ledger** — `app.usp_Rebuild_PayComponentLedger_NonUnionAdminHourly_CA_NonExempt` (date-gated).
8. **Shift differential hours add** — `app.usp_Apply_ShiftDifferentialHoursAdd` (`@WorkDateFrom`, `@WorkDateTo`, `@RunId`).
9. **WTL / meal periods** — `app.usp_Apply_WTL_MealPeriods` (date-gated).
10. **Final-gross ledger reconciliation** — `app.usp_Finalize_PayComponentLedger_Reconciliation` (`@WorkDateFrom`, `@WorkDateTo`).
11. **Subsistence** — `app.usp_Apply_SubsistencePay` (`@WorkDateFrom`, `@WorkDateTo`, `@RunId`).
12. **Normalize cents-level rounding** — `app.usp_Normalize_PayComponentLedger_Rounding` (`@WorkDateFrom`, `@WorkDateTo`, `@RunId`).

Steps 1–4 verbatim — `sql/app\usp_FinalizePayrollOutputs_AfterPricing.PROC.sql:11-39`:

```sql
    /* ------------------------------------------------------------
       1) Base pay fallback
       ------------------------------------------------------------ */
    EXEC app.usp_Apply_BasePay_Fallback_FromSource
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo;

    /* ------------------------------------------------------------
       2) Guaranteed hours / minimum pay
       ------------------------------------------------------------ */
    EXEC app.usp_Apply_GuaranteedHours
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo,
          @RunId        = @RunId;

    /* ------------------------------------------------------------
       3) Rest period premium
       ------------------------------------------------------------ */
    EXEC app.usp_Apply_RestPeriod_Premium
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo,
          @RunId        = @RunId;

    /* ------------------------------------------------------------
       4) Suppress calculated pay when Source_Rate_Raw is missing
       ------------------------------------------------------------ */
    EXEC app.usp_SuppressPay_WhenSourceRateMissing
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo;
```

Step 4.5 CA non-union OT (date-gated) — `sql/app\usp_FinalizePayrollOutputs_AfterPricing.PROC.sql:52-64`:

```sql
    IF @WorkDateFrom IS NOT NULL
       AND @WorkDateTo IS NOT NULL
    BEGIN
        EXEC app.usp_Apply_CA_NonUnionAdminHourly_OT
              @WorkDateFrom = @WorkDateFrom,
              @WorkDateTo   = @WorkDateTo,
              @PreviewOnly  = 0,
              @RequestedBy  = N'app.usp_FinalizePayrollOutputs_AfterPricing';
    END
    ELSE
    BEGIN
        PRINT 'Non-union hourly CA OT/DT skipped because app.usp_FinalizePayrollOutputs_AfterPricing was called without an explicit date range.';
    END;
```

Step 5 ledger rebuild — `sql/app\usp_FinalizePayrollOutputs_AfterPricing.PROC.sql:75-78`:

```sql
    EXEC app.usp_Rebuild_PayComponentLedger
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo,
          @RunId        = @RunId;
```

Step 5.5 non-union ledger rebuild (date-gated) — `sql/app\usp_FinalizePayrollOutputs_AfterPricing.PROC.sql:93-105`:

```sql
    IF @WorkDateFrom IS NOT NULL
       AND @WorkDateTo IS NOT NULL
    BEGIN
        EXEC app.usp_Rebuild_PayComponentLedger_NonUnionAdminHourly_CA_NonExempt
              @WorkDateFrom = @WorkDateFrom,
              @WorkDateTo   = @WorkDateTo,
              @PreviewOnly  = 0,
              @RequestedBy  = N'app.usp_FinalizePayrollOutputs_AfterPricing';
    END
    ELSE
    BEGIN
        PRINT 'Non-union hourly CA nonexempt ledger rebuild skipped because app.usp_FinalizePayrollOutputs_AfterPricing was called without an explicit date range.';
    END;
```

Step 6 shift-diff hours add — `sql/app\usp_FinalizePayrollOutputs_AfterPricing.PROC.sql:114-117`:

```sql
    EXEC app.usp_Apply_ShiftDifferentialHoursAdd
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo,
          @RunId        = @RunId;
```

Step 7 WTL meal periods (date-gated) — `sql/app\usp_FinalizePayrollOutputs_AfterPricing.PROC.sql:132-148`:

```sql
    IF @WorkDateFrom IS NOT NULL
       AND @WorkDateTo IS NOT NULL
    BEGIN
        EXEC app.usp_Apply_WTL_MealPeriods
              @WorkDateFrom      = @WorkDateFrom,
              @WorkDateTo        = @WorkDateTo,
              @UnionCode         = 'L12',
              @RunId             = @RunId,
              @CommitChanges     = 1,
              @UseTestOverrides  = 0,
              @TestOverrideSet   = NULL,
              @ReturnResults     = 0;
    END
    ELSE
    BEGIN
        PRINT 'WTL skipped because app.usp_FinalizePayrollOutputs_AfterPricing was called without an explicit date range.';
    END;
```

Steps 8, 9, 10 (reconciliation, subsistence, rounding) — `sql/app\usp_FinalizePayrollOutputs_AfterPricing.PROC.sql:162-182`:

```sql
    EXEC app.usp_Finalize_PayComponentLedger_Reconciliation
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo;

    /* ------------------------------------------------------------
       9) Subsistence

          Payable-only component. Does not change Final_Gross_Pay.
       ------------------------------------------------------------ */
    EXEC app.usp_Apply_SubsistencePay
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo,
          @RunId        = @RunId;

    /* ------------------------------------------------------------
       10) Normalize cents-level rounding
       ------------------------------------------------------------ */
    EXEC app.usp_Normalize_PayComponentLedger_Rounding
          @WorkDateFrom = @WorkDateFrom,
          @WorkDateTo   = @WorkDateTo,
          @RunId        = @RunId;
```

**Ordering constraints stated in code comments:** WTL must run after the ledger rebuild
(`:71-73`); non-union hourly ledger replacement must run after the main rebuild (`:73`); the final-gross
reconciliation must run after main rebuild + non-union replacement + shift-diff + WTL (`:152-160`);
subsistence is payable-only and does not change `Final_Gross_Pay` (`:169`).

---

### (b) `etl.usp_RunNightly_PayrollAPP` — the nightly ETL driver

**Plain English.** The nightly driver. It reads the lookback window from `cfg.Nightly_RunSettings`, takes an
exclusive session applock to prevent overlapping runs, logs the run in `etl.RunLog` + per-step
`etl.RunLogDetail`, then runs the 4-step chain: refresh synonyms -> prepare continuous labor -> run pricing
engine -> finalize outputs after pricing. Signature: `@RebuildAll bit=0`, `WITH EXECUTE AS OWNER`.

**Lookback window.** Config is read from `cfg.Nightly_RunSettings` (`LookbackDays`, `UseYesterdayAsToDate`),
defaulting to 30 days if missing/invalid. Per `data/cfg.Nightly_RunSettings.md`, the single live row (SettingsID 1)
is **LookbackDays = 210, UseYesterdayAsToDate = True** (updated 05/11/2026 03:22:01). So `@WorkDateTo` =
yesterday (GETDATE()-1), and `@WorkDateFrom` = `@WorkDateTo - 209 days` (a 210-day inclusive window ending
yesterday). — `sql/etl\usp_RunNightly_PayrollAPP.PROC.sql:17-39`:

```sql
    -------------------------------------------------------------------------
    -- Window config
    -------------------------------------------------------------------------
    DECLARE @LookbackDays int = 30;
    DECLARE @UseYesterday bit = 1;

    SELECT TOP (1)
        @LookbackDays = LookbackDays,
        @UseYesterday = UseYesterdayAsToDate
    FROM cfg.Nightly_RunSettings
    ORDER BY SettingsID DESC;

    IF @LookbackDays IS NULL OR @LookbackDays < 1
        SET @LookbackDays = 30;

    DECLARE @WorkDateTo date =
        CASE
            WHEN @UseYesterday = 1
                THEN DATEADD(DAY, -1, CONVERT(date, GETDATE()))
            ELSE CONVERT(date, GETDATE())
        END;

    DECLARE @WorkDateFrom date = DATEADD(DAY, 1 - @LookbackDays, @WorkDateTo);
```

**Applock (overlap guard).** Exclusive session applock on resource `N'etl.usp_RunNightly_PayrollAPP'` with
`@LockTimeout = 0`; if not acquired (`@LockResult < 0`) it writes a `'Skipped'` RunLog row and returns 0. —
`sql/etl\usp_RunNightly_PayrollAPP.PROC.sql:41-62`:

```sql
    EXEC @LockResult = sys.sp_getapplock
        @Resource = N'etl.usp_RunNightly_PayrollAPP',
        @LockMode = N'Exclusive',
        @LockOwner = N'Session',
        @LockTimeout = 0;

    IF @LockResult < 0
    BEGIN
        INSERT INTO etl.RunLog
            (RunType, StartedAtUTC, EndedAtUTC, Status, HostName, AppName, LoginName, ErrorMessage)
        VALUES
            ('NightlyPayroll', SYSUTCDATETIME(), SYSUTCDATETIME(), 'Skipped',
             HOST_NAME(), APP_NAME(), ORIGINAL_LOGIN(),
             'Another PayrollAPP run is already in progress.');

        RETURN 0;
    END;

    SET @HaveLock = 1;
```

**RunLog header.** A `'Running'` header row is inserted and `@RunId = SCOPE_IDENTITY()` —
`sql/etl\usp_RunNightly_PayrollAPP.PROC.sql:64-69`:

```sql
    INSERT INTO etl.RunLog
        (RunType, StartedAtUTC, Status, HostName, AppName, LoginName)
    VALUES
        ('NightlyPayroll', SYSUTCDATETIME(), 'Running', HOST_NAME(), APP_NAME(), ORIGINAL_LOGIN());

    SET @RunId = SCOPE_IDENTITY();
```

**The full 4-step chain.** Each step inserts a `'Running'` `etl.RunLogDetail` row, EXECs the work proc,
counts rows, and updates the detail row to `'Succeeded'` with `Notes`:

- **Step 1 RefreshSynonyms** — `EXEC etl.usp_RebuildSynonyms_RawFMS @TargetSchema=N'src', @DoIt=1, @Quiet=1;`
  then counts `src.FMS%_Raw` synonyms. — `sql/etl\usp_RunNightly_PayrollAPP.PROC.sql:82-98`.
- **Step 2 PrepareContinuousLabor** — `EXEC app.usp_Prepare_Continuous_Labor;` then counts
  `fms.Labor_PreProcessed` rows (Total / Gap). — `:110-125`.
- **Step 3 RunPricingEngine** — `EXEC app.usp_Run_Pricing_Engine @WorkDateFrom, @WorkDateTo;` then counts
  `fms.Payroll_Calculated` rows in window. — `:137-157`.
- **Step 4 FinalizePayrollOutputsAfterPricing** — `EXEC app.usp_FinalizePayrollOutputs_AfterPricing
  @WorkDateFrom, @WorkDateTo, @RunId;` then computes reconciliation counters. — `:179-250`.

Step 1 verbatim — `sql/etl\usp_RunNightly_PayrollAPP.PROC.sql:75-98`:

```sql
        INSERT INTO etl.RunLogDetail
            (RunId, StepName, StartedAtUTC, Status)
        VALUES
            (@RunId, 'RefreshSynonyms', SYSUTCDATETIME(), 'Running');

        SET @RunDetailId = SCOPE_IDENTITY();

        EXEC etl.usp_RebuildSynonyms_RawFMS
            @TargetSchema = N'src',
            @DoIt = 1,
            @Quiet = 1;

        DECLARE @SynCount int;

        SELECT @SynCount = COUNT(*)
        FROM sys.synonyms
        WHERE SCHEMA_NAME(schema_id) = N'src'
          AND name LIKE N'FMS%_Raw';

        UPDATE etl.RunLogDetail
        SET EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Succeeded',
            Notes = CONCAT('src synonyms ensured; count=', @SynCount)
        WHERE RunDetailId = @RunDetailId;
```

Steps 2 and 3 EXECs — `sql/etl\usp_RunNightly_PayrollAPP.PROC.sql:110` and `:137-139`:

```sql
        EXEC app.usp_Prepare_Continuous_Labor;
```
```sql
        EXEC app.usp_Run_Pricing_Engine
            @WorkDateFrom = @WorkDateFrom,
            @WorkDateTo   = @WorkDateTo;
```

Step 4 EXEC — `sql/etl\usp_RunNightly_PayrollAPP.PROC.sql:179-182`:

```sql
        EXEC app.usp_FinalizePayrollOutputs_AfterPricing
            @WorkDateFrom = @WorkDateFrom,
            @WorkDateTo   = @WorkDateTo,
            @RunId        = @RunId;
```

**Success / release.** On success the RunLog header is set `'Succeeded'` and the applock is released —
`sql/etl\usp_RunNightly_PayrollAPP.PROC.sql:255-268`:

```sql
        UPDATE etl.RunLog
        SET EndedAtUTC = SYSUTCDATETIME(),
            Status = 'Succeeded',
            ErrorMessage = NULL
        WHERE RunId = @RunId;

        IF @HaveLock = 1
        BEGIN
            EXEC sys.sp_releaseapplock
                @Resource = N'etl.usp_RunNightly_PayrollAPP',
                @LockOwner = N'Session';

            SET @HaveLock = 0;
        END;
```

**Error handling.** The `BEGIN CATCH` (`:272-310`) builds a formatted `@Err` string, marks the open
`RunLogDetail` row `'Failed'`, marks the `RunLog` header `'Failed'` with `ErrorMessage`, releases the applock,
then `RAISERROR(@Err,16,1); RETURN 1;`.

---

### (c) `api.usp_UI_RefreshPayroll_FromNexGen` — UI-triggered refresh

**Plain English.** This is what the Payroll UI ("browser refresh") calls. It does NOT use a linked server, SSIS
package, or SQL Agent job to pull raw data. It does the raw pull by **calling a stored proc in a second
database on the SAME instance** — `TCG_RawFMS.etl.usp_RunNightly_RawFMS` (three-part name, cross-database EXEC)
— and then recalculates by calling `etl.usp_RunNightly_PayrollAPP` in the current DB. Signature:
`@AnyDateInWeek date`, `@RequestedBy sysname=NULL`, `@AllowProcessed bit=0`.

**Objects involved:** `api.usp_UI_RefreshPayroll_FromNexGen` calling
`TCG_RawFMS.etl.usp_RunNightly_RawFMS` (raw pull, cross-DB) and `etl.usp_RunNightly_PayrollAPP` (recalc);
logs to `etl.UIRefreshLog`; reads `TCG_RawFMS.etl.RunLog` and `etl.RunLog` to capture child run IDs/status.

**Period math + guards.** The proc computes a canonical Saturday–Friday period from `@AnyDateInWeek` anchored
to Saturday 2020-01-04 (`:30-35`), inserts a `'Running'` `etl.UIRefreshLog` row (`:37-64`), blocks the refresh
if the period is already `'Processed'` and `@AllowProcessed=0` (`:66-96`), and takes an exclusive session
applock `N'api.usp_UI_RefreshPayroll_FromNexGen'` with `@LockTimeout=0` (`:98-119`).

**Step 1 — raw pull (the cross-DB EXEC chain).** — `sql/api\usp_UI_RefreshPayroll_FromNexGen.PROC.sql:121-148`:

```sql
    BEGIN TRY
        /* Step 1: refresh RawFMS from FCC NexGen */
        SELECT @RawBefore = ISNULL(MAX(RunId), 0)
        FROM TCG_RawFMS.etl.RunLog;

        EXEC TCG_RawFMS.etl.usp_RunNightly_RawFMS;

        SELECT TOP (1)
            @RawRunId = RunId,
            @RawStatus = Status
        FROM TCG_RawFMS.etl.RunLog
        WHERE RunId > @RawBefore
        ORDER BY RunId DESC;

        IF @RawRunId IS NULL
        BEGIN
            SELECT TOP (1)
                @RawRunId = RunId,
                @RawStatus = Status
            FROM TCG_RawFMS.etl.RunLog
            ORDER BY RunId DESC;
        END;

        UPDATE etl.UIRefreshLog
        SET
            RawFMS_RunId = @RawRunId,
            RawFMS_Status = @RawStatus
        WHERE UIRefreshID = @UIRefreshID;
```

So the "raw pull" = `EXEC TCG_RawFMS.etl.usp_RunNightly_RawFMS` (a proc in the sibling `TCG_RawFMS` database
that itself pulls from "FCC NexGen", per the comment). If that run's `Status` is not `'Succeeded'`, the
refresh aborts before recalculation and PayrollAPP is not started (`:150-176`).

**Step 2 — "rebuild for the period" recalculation.** Despite the UI passing a single week, the recalc it
triggers is the FULL nightly proc `etl.usp_RunNightly_PayrollAPP @RebuildAll=0`, which recomputes over the
210-day `cfg.Nightly_RunSettings` window (not just the selected week). The proc's own comment says as much. —
`sql/api\usp_UI_RefreshPayroll_FromNexGen.PROC.sql:178-206`:

```sql
        /* Step 2: recalculate PayrollAPP using cfg.Nightly_RunSettings = 210 days */
        SELECT @PayrollBefore = ISNULL(MAX(RunId), 0)
        FROM etl.RunLog;

        EXEC etl.usp_RunNightly_PayrollAPP @RebuildAll = 0;

        SELECT TOP (1)
            @PayrollRunId = RunId,
            @PayrollStatus = Status
        FROM etl.RunLog
        WHERE RunId > @PayrollBefore
          AND RunType = 'NightlyPayroll'
        ORDER BY RunId DESC;

        IF @PayrollRunId IS NULL
        BEGIN
            SELECT TOP (1)
                @PayrollRunId = RunId,
                @PayrollStatus = Status
            FROM etl.RunLog
            WHERE RunType = 'NightlyPayroll'
            ORDER BY RunId DESC;
        END;

        UPDATE etl.UIRefreshLog
        SET
            PayrollAPP_RunId = @PayrollRunId,
            PayrollAPP_Status = @PayrollStatus
        WHERE UIRefreshID = @UIRefreshID;
```

On success it writes a summary message with both child run IDs, releases the applock, and returns the
`etl.UIRefreshLog` row to the caller (`:236-259`). The `CATCH` logs `'Failed'`, releases the applock, and
re-`THROW`s (`:261-285`).

**Answer to the routing question:** raw data is pulled via a **cross-database stored-procedure call**
(`TCG_RawFMS.etl.usp_RunNightly_RawFMS`) on the same SQL instance — **not** a linked server, **not** an SSIS
package, **not** a SQL Agent job. Note synonym rebuild (`etl.usp_RebuildSynonyms_RawFMS`) is NOT called here
directly — it runs inside `etl.usp_RunNightly_PayrollAPP` Step 1 as part of the Step-2 recalc.

---

### (d) `app.usp_ProcessPayroll_PayPeriod` — freeze / snapshot a pay period

**Plain English.** This is the "process / freeze the period" action. For a given Saturday
`@PeriodStartDate` it: ensures an `app.PayPeriod` row exists, RE-RUNS the calc chain for just that
Saturday–Friday week (pricing engine + finalize), then FREEZES the result by copying every
`fms.Payroll_Calculated` row in the period into an immutable snapshot (`app.PayrollSnapshot` header +
`app.PayrollSnapshot_Detail` rows), and marks the `app.PayPeriod` as `'Processed'`. Signature:
`@PeriodStartDate date` (Saturday), `@ProcessedBy sysname=NULL`, `@SnapshotNote nvarchar(max)=NULL`.
(This is a write proc — not executed; documented from source only.)

**What it re-runs** — `sql/app\usp_ProcessPayroll_PayPeriod.PROC.sql:28-36`:

```sql
    -- Run calc chain for the period
    EXEC app.usp_Run_Pricing_Engine
        @WorkDateFrom = @PeriodStartDate,
        @WorkDateTo   = @PeriodEndDate;

    EXEC app.usp_FinalizePayrollOutputs_AfterPricing
        @WorkDateFrom = @PeriodStartDate,
        @WorkDateTo   = @PeriodEndDate,
        @RunId        = NULL;
```

(`@PeriodEndDate = DATEADD(DAY, 6, @PeriodStartDate)` — `:11`. Because it passes an explicit date range, all
the date-gated finalize sub-steps — CA OT, non-union ledger, WTL — DO run.)

**What it freezes (the snapshot).** A `app.PayrollSnapshot` header is inserted, then all in-period rows are
copied into `app.PayrollSnapshot_Detail`. — `sql/app\usp_ProcessPayroll_PayPeriod.PROC.sql:38-66`:

```sql
    -- Create snapshot header
    DECLARE @SnapshotID bigint;
    INSERT app.PayrollSnapshot(PayPeriodID, SourceRunId, SnapshotNote, CreatedBy)
    VALUES (@PayPeriodID, NULL, @SnapshotNote, COALESCE(@ProcessedBy, ORIGINAL_LOGIN()));

    SET @SnapshotID = SCOPE_IDENTITY();

    -- Snapshot detail (freeze rows for this pay period)
    INSERT app.PayrollSnapshot_Detail
    (
        SnapshotID,
        CalcID, LaborPayrollID, JobTicketID, JobCode, EmpID, Employee_Name, TicketDate, WorkDate,
        Act_Total_Hrs, Act_Boom_Hrs, Gap_Hrs_Total, Gap_Hrs_Boom, Pay_Total_Hrs,
        Hrs_ST, Hrs_OT, Hrs_DT,
        Pay_Actual_Gross, Pay_Gap_Add, Final_Gross_Pay,
        Audit_Min_Rule, Audit_Gap_Mult, CalculatedAt,
        Pay_Rest_Add, Rest_IsForced, Rest_ChainId, Rest_Gap_Hrs_FromPrevChain, Rest_IsOverlap, Rest_Premium_Hrs, Rest_Policy
    )
    SELECT
        @SnapshotID,
        CalcID, LaborPayrollID, JobTicketID, JobCode, EmpID, Employee_Name, TicketDate, WorkDate,
        Act_Total_Hrs, Act_Boom_Hrs, Gap_Hrs_Total, Gap_Hrs_Boom, Pay_Total_Hrs,
        Hrs_ST, Hrs_OT, Hrs_DT,
        Pay_Actual_Gross, Pay_Gap_Add, Final_Gross_Pay,
        Audit_Min_Rule, Audit_Gap_Mult, CalculatedAt,
        Pay_Rest_Add, Rest_IsForced, Rest_ChainId, Rest_Gap_Hrs_FromPrevChain, Rest_IsOverlap, Rest_Premium_Hrs, Rest_Policy
    FROM fms.Payroll_Calculated
    WHERE WorkDate >= @PeriodStartDate
      AND WorkDate <  DATEADD(DAY, 1, @PeriodEndDate);
```

**Snapshot columns (frozen).** `app.PayrollSnapshot_Detail` copies these columns from
`fms.Payroll_Calculated`: `CalcID, LaborPayrollID, JobTicketID, JobCode, EmpID, Employee_Name, TicketDate,
WorkDate, Act_Total_Hrs, Act_Boom_Hrs, Gap_Hrs_Total, Gap_Hrs_Boom, Pay_Total_Hrs, Hrs_ST, Hrs_OT, Hrs_DT,
Pay_Actual_Gross, Pay_Gap_Add, Final_Gross_Pay, Audit_Min_Rule, Audit_Gap_Mult, CalculatedAt, Pay_Rest_Add,
Rest_IsForced, Rest_ChainId, Rest_Gap_Hrs_FromPrevChain, Rest_IsOverlap, Rest_Premium_Hrs, Rest_Policy`.
(Note: the snapshot detail captures the calc-engine and rest-premium fields; it does NOT copy the
`fms.Payroll_PayComponent` ledger rows.)

**Mark processed** — `sql/app\usp_ProcessPayroll_PayPeriod.PROC.sql:68-79`:

```sql
    -- Mark period processed
    UPDATE app.PayPeriod
    SET Status = 'Processed',
        ProcessedAtUTC = SYSUTCDATETIME(),
        ProcessedBy = COALESCE(@ProcessedBy, ORIGINAL_LOGIN())
    WHERE PayPeriodID = @PayPeriodID;

    SELECT
        PayPeriodID = @PayPeriodID,
        SnapshotID  = @SnapshotID,
        PeriodStartDate = @PeriodStartDate,
        PeriodEndDate   = @PeriodEndDate;
```

Once `app.PayPeriod.Status = 'Processed'`, `api.usp_UI_RefreshPayroll_FromNexGen` will BLOCK a UI refresh for
that period unless called with `@AllowProcessed = 1` (see (c), `:66-96`). That is the interlock between the
freeze process and the UI refresh.

---

### Orchestration call graph (summary)

```
Nightly (scheduled externally — see jobs/sql_agent_jobs.md):
  etl.usp_RunNightly_PayrollAPP  @RebuildAll=0
    ├─ applock: etl.usp_RunNightly_PayrollAPP (Exclusive/Session)
    ├─ RunLog 'Running' + per-step RunLogDetail
    ├─ 1. etl.usp_RebuildSynonyms_RawFMS  (src FMS%_Raw synonyms)
    ├─ 2. app.usp_Prepare_Continuous_Labor
    ├─ 3. app.usp_Run_Pricing_Engine  @WorkDateFrom..@WorkDateTo (210-day window)
    └─ 4. app.usp_FinalizePayrollOutputs_AfterPricing
             1  usp_Apply_BasePay_Fallback_FromSource
             2  usp_Apply_GuaranteedHours
             3  usp_Apply_RestPeriod_Premium
             4  usp_SuppressPay_WhenSourceRateMissing
             5  usp_Apply_CA_NonUnionAdminHourly_OT            (date-gated)
             6  usp_Rebuild_PayComponentLedger
             7  usp_Rebuild_PayComponentLedger_NonUnionAdminHourly_CA_NonExempt (date-gated)
             8  usp_Apply_ShiftDifferentialHoursAdd
             9  usp_Apply_WTL_MealPeriods                       (date-gated)
            10  usp_Finalize_PayComponentLedger_Reconciliation
            11  usp_Apply_SubsistencePay
            12  usp_Normalize_PayComponentLedger_Rounding

UI "Refresh" button:
  api.usp_UI_RefreshPayroll_FromNexGen  @AnyDateInWeek
    ├─ applock: api.usp_UI_RefreshPayroll_FromNexGen (Exclusive/Session)
    ├─ blocks if app.PayPeriod.Status='Processed' (unless @AllowProcessed=1)
    ├─ 1. EXEC TCG_RawFMS.etl.usp_RunNightly_RawFMS   (cross-DB raw pull from FCC NexGen)
    └─ 2. EXEC etl.usp_RunNightly_PayrollAPP @RebuildAll=0   (full 210-day recalc above)

Freeze a week:
  app.usp_ProcessPayroll_PayPeriod  @PeriodStartDate (Saturday)
    ├─ app.usp_Run_Pricing_Engine   (this week only)
    ├─ app.usp_FinalizePayrollOutputs_AfterPricing (this week only)
    ├─ snapshot -> app.PayrollSnapshot + app.PayrollSnapshot_Detail
    └─ app.PayPeriod.Status='Processed'
```


---


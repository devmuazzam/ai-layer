---
title: Legacy Payroll App - every pay rule in plain language, one at a time
source: derived from legacy-payroll-app-db-extract (calculations.md, config-values.md, worked-examples.md), 2026-08-18
migrated: 2026-08-18
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app, payroll-rules, boom, craft-modifier, shift-differential, guaranteed-hours, rest-period, wtl, subsistence, overtime]
entities: [pricing-engine, pay-component, craft-modifier, guaranteed-hours, rest-period, wtl, subsistence, payroll-group]
part_of: payroll/legacy-payroll-app-db-extract/INDEX.md
---

# Every pay rule in plain language — one at a time

Same facts as [calculations.md](calculations.md), stripped to what a payroll person needs:
**when** the rule fires, **how** it is applied, **the formula**, **one worked number**, and
**where** it lives. Rates come from NexGen (`FMS_UNION_CRAFT`, `FMS_UNION_CRAFT_MODIFIER`,
`FMS_EMPLOYEES`); rule values from `cfg.*` (printed in [config-values.md](config-values.md)).
Everything is per **labor entry** (one NexGen labor row) unless stated.

---

## A. Who is who — the groups, and how they connect to the calculation

### A1. Union vs non-union
- There is **one union in the system: Local 12** (`UnionCode = L12`, "Mobile Crane Operators
  Group – Local 12"). There is no L1…L11 — the "12" is the local's number. All union rule
  tables (`cfg.Union_Master_Rules`, `cfg.Union_Shift_Rules`, `cfg.WTL_Rule`) have exactly one
  union code, `L12`.
- **Union** = the labor row's craft code starts with `L12` (e.g. `L12-G3-A`).
  **Non-union** = anything else: `ADMIN-*` (office), `HDR-*`, `YARD-*`, `HOLIDAY`, `SUB`.
- The engine decides *per labor row*, by the row's craft, not by a union flag on the employee.

### A2. Payroll groups (how the app labels an employee)
Derived from the **employee master** (`FMS_EMPLOYEES`) in `api.v_UI_Employee_TypeRate`:

| Payroll group | Rule | Base rate comes from | Which calculation path |
| --- | --- | --- | --- |
| **L12 Labor Union Field** | craft `L12…` and EmpTypeId ≠ 3 | `FMS_UNION_CRAFT.PayRate` by craft | full union engine: rules 1–11 |
| **L12 Labor Union Mechanic** | craft `L12…` and EmpTypeId = 3 (Mechanic; 1 = Operator, 2 = Oiler) | same | **same path as Field** — the code keys on `L12%`, not on the group |
| **Non-Union Admin Hourly** | craft `ADMIN…` and PayType `H` | `FMS_EMPLOYEES.PayRate` | rule 12 (California OT); every union extra zeroed; no minimum pay (`ADMIN-*` exempt) |
| **Non-Union Admin Salary** | craft `ADMIN…` and PayType `S` | `FMS_EMPLOYEES.PayRate` | no salary-specific rule exists; the CA proc applies only to PayType `H` |
| System-Testing-VendorAccess | craft `SYS…` | 0 | none |
| Unknown / Needs Review | anything else | none → suppressed (rule 13) | flagged |

The payroll group is a **label for the worklist**; the pricing itself looks at the **labor
row's** craft (A3) and modifier (A4). When the employee-master craft and the labor-row craft
disagree (27 % of rows), the labor row wins and a `CraftCodeMismatchFlag` is raised.

### A3. Crafts — the L12 wage groups and the others
- **`L12-G1` … `L12-G9`** are the Local 12 **wage groups** (crane size classes) with the
  hourly rate in `FMS_UNION_CRAFT`: G1 66.03 · G2 66.18 · G3 67.87 · G4 67.99 · G5 68.16 ·
  G6 68.41 · G7 68.66 · G8 69.16 · G9 71.16 (rates effective 2025-07-01).
- **`L12-APP-A`** apprentice 40.90, and steps **`L12-APP1-A` … `L12-APP6-A`** 40.90 → 61.34.
  There is no step-progression logic; each step is just a craft code with a rate.
- **`L12-BG-A`** exists (817 rows) — a further L12 craft in the same table.
- The **`-A / -B / -C` suffix** is NexGen's own regular / overtime / double-time variant of the
  same craft (`FMS_CRAFTS.PayType` R / O / D; `-B` = 1.5 × `-A`, `-C` = 2 × `-A`). The payroll
  engine always prices from the `-A` rate and applies its own multipliers.
- **Non-`L12` crafts:** `ADMIN-A/B/C` (office; minimum pay off), `HDR-A/B/C` (71.16 base; is in
  the craft table but is **not** `L12%`, so no boom premium — see rule 4), `YARD-A/B`,
  `HOLIDAY` (rate 0), `SUB` (200.00, the subsistence craft row).

### A4. Craft modifiers — the boom brackets
A second code on the labor row, `CraftModifierCode`: **`OP-BP-01…18`** (Operator) and
**`OI-BP-01…15`** (Oiler), each a **20-foot boom-length bracket** (080–100 ft … 421–440 ft) with
a **$/h adder** in `FMS_UNION_CRAFT_MODIFIER.PayRateChange` (operator 0.75 → 13.50, oiler 0.25 →
3.75). The bracket is chosen in NexGen when the row is entered. It only produces pay when the
craft is `L12…` **and** the ticket has a boom window (rule 4). 69 % of labor rows carry no
modifier.

### A5. Comment tokens — the third input on the labor row
The NexGen **comment** text can carry `(PAY:SHIFT_2)`, `(PAY:SHIFT_3)`, `(PAY:SUB_SHORT)`,
`(PAY:SUB_LONG)`, `(PAY:WTL_0…4)` (also without `PAY:`). Nothing else is read.

### A6. How it all chains together

```
Employee master ──► CraftCode / PayType / EmpTypeId ──► Payroll group (label, base-rate source)
Labor row ─────────► CraftCode  ──► FMS_UNION_CRAFT.PayRate  ──► Rate_Base   (union)
                 ├─► CraftModifierCode ──► FMS_UNION_CRAFT_MODIFIER ──► Rate_Boom (only L12 + boom window)
                 ├─► Comments  ──► SHIFT_2/3 ──► Rate_Shift (+3/+4) and hours-add
                 │              ──► SUB_SHORT/LONG ──► subsistence line
                 │              ──► WTL_n ──► meals worked through
                 └─► TimeStart/TimeEnd + WorkDate ──► 30-min slices, day type, OT/DT
Job ticket ────────► ArrivedJob → LeftJob ──► boom window (which slices are boom-active)
cfg.* / dim.* ─────► multipliers, thresholds, minimums, holidays
```

Union rows go through rules 1–11 and 13–14; Non-Union Admin Hourly rows are re-priced by rule
12 and lose every union extra.

---

## B. Client terminology — the words as they use them

Read this once; every later section uses these words unqualified. "Where you meet it" gives the
NexGen field, the database column, the UI label and the ADP column, when they exist.

### B1. People, groups, crafts

| Term | What the client means | Where you meet it |
| --- | --- | --- |
| **Employee** | a worker in NexGen's employee master | `FMS_EMPLOYEES` (`EmpID`, `CraftCode`, `PayType` H/S, `EmpTypeId`, `UnionCode`, `PayRate`) |
| **EmpID** | the NexGen employee id, e.g. `E…` (masked in our copies) | every table; UI worklist rows; the ERP-side key |
| **ADP File Number / File #** | the employee's id inside ADP (1–6 chars in the app, digits ≥ 51 in ADP) | `app.EmployeeExternalIdentifier`; UI worklist "ADP File Number"; ADP sheet **File #** |
| **Employee type** | Operator (1), Oiler (2), Mechanic (3) … 15 types | `FMS_EMPLOYEE_TYPES`; only "= 3 Mechanic" matters to the app |
| **Union / Local 12 / L12** | Mobile Crane Operators Group – Local 12, the only union | `UnionCode = 'L12'`; `cfg.Union_Master_Rules`; craft codes starting `L12-` |
| **Non-union / Admin** | office staff, crafts `ADMIN-A/B/C` | `FMS_CRAFTS` description "ADMIN" |
| **Payroll Group** | the app's classification of an employee (L12 Field, L12 Mechanic, Non-Union Admin Hourly, Non-Union Admin Salary, System, Unknown) | `api.v_UI_Employee_PayrollGroupRate.PayrollGroup`; UI worklist "Payroll Group" chip; the current-state pack's "Employee Type" |
| **Craft / Craft code** | the wage classification of a labor row: `L12-G1…G9` (Local 12 wage groups), `L12-APP…` (apprentice), `HDR-*`, `YARD-*`, `ADMIN-*` | NexGen `CraftCode` on employee and on labor row; `FMS_UNION_CRAFT.PayRate`; UI "Craft" |
| **Wage group / G1–G9** | Local 12's rate classes (G1 66.03 … G9 71.16 $/h) | inside the craft code |
| **-A / -B / -C** | NexGen's regular / overtime / double-time variant of a craft (`FMS_CRAFTS.PayType` R/O/D); the app uses `-A` only | craft code suffix |
| **Apprentice step** | `L12-APP1-A … L12-APP6-A`, each with its own rate 40.90 → 61.34 | craft code; no progression logic |
| **HDR** | a non-L12 craft priced 71.16 (`HDR-A`); gets boom *hours* but no boom *pay* | craft code |
| **Craft mismatch** | employee-master craft ≠ labor-row craft; the labor row prices | UI flag `CraftCodeMismatchFlag` |

### B2. Craft modifiers (the boom brackets) — the client's own words

| Term | What the client means | Where you meet it |
| --- | --- | --- |
| **Craft modifier / Modifier code** | a second code on the labor row that adds $/h to the craft rate; in practice **always a boom-length bracket** | NexGen `CraftModifierCode`; `FMS_CRAFT_MODIFIER` (description), `FMS_UNION_CRAFT_MODIFIER` (adder); UI "Modifier Code" in the boom row |
| **OP-BP-nn / OI-BP-nn** | **OP**erator / **OI**ler, **B**oom **P**ole bracket nn: 01 = 080–100 ft, 02 = 101–120, … each +20 ft, up to 18 = 421–440 ft | modifier code; description e.g. `181-200Ft-Operator` |
| **Boom pay / Long boom pay / LB** | the extra $/h for working with a long boom — the modifier's adder, paid on slices inside the ticket's boom window | UI "Boom", "Boom actual", "Boom gap"; ledger `ACTUAL_BOOM_WORKED_PAY`; ADP **LB REG / LB OT / LB DBL / LB TRI** |
| **PayRateChange** | the modifier's straight-time adder (0.75 … 13.50 operator, 0.25 … 3.75 oiler); the OT/DB columns next to it are unused | `FMS_UNION_CRAFT_MODIFIER.PayRateChange`; UI `CraftModifierPayRateAdjustment`; ledger `RateBoomUsed`; ADP **Temporary Rate** |
| **Boom window** | the span of the job ticket during which boom hours count — in practice ArrivedJob → LeftJob | `calc.TicketTimeline.Boom_Window_Start/End`; UI "Boom Start / Boom End / Window" |
| **Boom-active / boom hours** | a 30-min slice fully inside the boom window on a row that has a modifier | `Is_Boom_Active`; `Act_Boom_Hrs`; UI "Slice_Boom_Hrs" |
| **Boom eligible** | the labor row has a modifier code | `BoomEligible` / `HasCraftModifier` |
| **Boom gap** | hours added by the long-boom 4-hour minimum | `Gap_Hrs_Boom`; ledger `GUARANTEED_BOOM_PAY_ADD`; UI badge "Boom gap" |
| **BoomDisplayStatus** | the UI's one-line verdict: *No boom modifier* · *Boom actual* · *Boom actual + gap* · *Ticket boom window only – no modifier* · *Modifier present, no boom hours* · *Review…* | UI boom row |
| **Temp rate / Temporary Rate** | ADP's word for a per-line hourly rate; TCG puts the boom adder there, one line per bracket | ADP ROLL sheet |

### B3. Time and tickets

| Term | What the client means | Where you meet it |
| --- | --- | --- |
| **FMS / NexGen / FCC** | the field-management system where tickets, labor and employees are entered; its raw copy is `TCG_RawFMS` | `src.FMS_*_Raw` synonyms |
| **Labor entry / Labor row / LaborPayrollID** | one NexGen labor record: employee, work date, start/end, craft, modifier, job, ticket, comment. The unit everything is priced on | `FMS_LABOR_PAYROLL`; `fms.Payroll_Calculated.LaborPayrollID`; UI "labor entry" |
| **Job ticket / JobTicketID** | the crane job's ticket with its time stamps (yard out, arrived, start work, end work, left, yard in) | `FMS_JOB_TICKET`; UI "Job Ticket #" |
| **TkTm01 … TkTm10** | the ten standardised ticket time slots: 01 TimeStart, 02 YardOut, 03 ArrivedJob, 04 StartWork, 07 EndWork, 08 LeftJob, 09 YardIn, 10 TimeEnd | `calc.v_JobTicket_Times`; `Shift_Source_*`, `Boom_Source_*` |
| **Shift** | the continuous stretch an employee works (entries < 8 h apart chain into one shift); also "shift window" = the entry's start/end used for pricing | `ChainGroup`, `Pricing_Date`; UI "Shift Start / Shift End" |
| **Shift anchor date** | the first work date of the shift chain — the date guarantees and daily rules group on | `Pricing_Date`, `ShiftAnchorDate` |
| **Work date** | the NexGen `WorkDate` on the row; punches are re-anchored to it | `Actual_WorkDate`, `WorkDate` |
| **Slice** | one 30-minute increment of a shift; the atom of pricing | `api.v_UI_Pricing_Slices_Advanced`; UI "Pricing Slices" |
| **Shift assumed** | the entry had no usable start/end, so the app assumed 06:00 + hours worked | exception `Shift_Assumed`; UI issue "Shift times assumed" |
| **Reconstruction** | rebuilding the shift from labor + ticket times; mismatches are warnings | `Warn_Reconstruction_*` |
| **Day type** | WEEKDAY / SATURDAY / SUNDAY / HOLIDAY / SPECIAL_SAT for a slice | `Day_Type` |
| **Special Saturday** | first Saturday of June and December (day ≤ 7), paid ×2 (contract clause A.4) | engine; `dim.LU12_Holiday` "June/December Special Saturday" |
| **Standard day / window** | 06:00–17:00; outside it a weekday slice is OT | `cfg.Union_Master_Rules` |
| **Pay period / week** | Saturday → Friday | `app.PayPeriod`; `fn_PayPeriodStart_SatFri` |

### B4. Pay buckets and components

| Term | What the client means | Where you meet it |
| --- | --- | --- |
| **ST / OT / DT** | straight time (×1.0), overtime (×1.5), double time (≥ ×2.0) hours | `Hrs_ST/OT/DT`; UI columns; ADP Reg / OT / DT Hours |
| **H2x / H3x** | UI-only split of DT hours: H2x = special-Saturday hours, H3x = holiday hours | `Bucket_Hrs_H2x/H3x`; ADP Holiday 2x / 3x Hours |
| **Actual (pay / hours)** | what the slices priced, before any rule | `Act_Total_Hrs`, `Pay_Actual_Gross`; ledger group `ACTUAL` |
| **Gap / Min gap / Guarantee** | hours added to reach a minimum (daily 4, holiday 8, special-Sat 8, boom 4) and their pay | `Gap_Hrs_Total`, `Gap_Hrs_Boom`, `Pay_Gap_Add`; UI badges "Min gap", "Boom gap"; ledger group `GUARANTEE` |
| **Rest premium / Rest floor** | extra for returning < 8 h after a chain with OT/DT; slices floored to ×1.5 | `Pay_Rest_Add`, `Rest_Premium_Hrs`; UI "Rest floor hrs"; ledger `REST_PERIOD_PREMIUM` |
| **Rest chain** | consecutive entries ≤ 30 min apart, used for the rest rule | `Rest_ChainId` |
| **SD / Shift differential** | 2nd/3rd shift: **SD Rate Add** (+3/+4 $/h inside actual) and **SD Hrs Add** (+1.0/+1.5 paid hours) | ledger `ACTUAL_SHIFT_DIFFERENTIAL`, `SHIFT_2/3_HOURS_ADD`; UI "SD"; ADP Shift Diff 2/3 |
| **WTL / Worked-through-lunch** | meal periods a crew skipped; taken meals are deducted, worked-through meals are paid at 2× | `WTL_MEAL_DEDUCT`, `WTL_APPLICABLE_ADD`, `WTL_DT_FLOOR`; UI "WTL"; comment token `WTL_n` |
| **Meal opportunity** | the modelled 30-min meal slot at 5.0 / 10.5 / 16.0 / 21.5 h into a group | WTL proc; UI markers |
| **Sub / Subsistence / Per diem** | flat allowance: **Short** $85, **Long** $85 weekday / $200 weekend; paid but not gross | `SUBSISTENCE_*`; comment tokens `SUB_SHORT`/`SUB_LONG`; UI "Subsistence / Allowance"; ADP **SUB PAY** / Substpay |
| **Payable-only** | included in what is paid, excluded from Final Gross (today: subsistence) | `IncludedInPayableGross = 1, IncludedInFinalGross = 0` |
| **Final Gross Pay** | actual + gap + rest + SD hours-add (the wage figure) | `Final_Gross_Pay` |
| **Labor gross before / after WTL** | Final Gross, then Final Gross + WTL lines | ledger summary |
| **Total payable gross** | labor gross after WTL + payable-only lines | `TotalPayableGross`; UI "Total payable" |
| **Pay component / Ledger** | one named line per dollar (code, group, hours, rates used, multiplier, amount, explanation) | `fms.Payroll_PayComponent`; UI "Pay components" |
| **Tie-out / Balanced** | the ledger sums to the calc row within a cent | `LedgerTieOutStatus` |
| **Token / PAY token** | the `(PAY:…)` marker typed into a NexGen labor comment | `app.v_LaborPayroll_CommentTokens` |
| **Source rate** | the `Rate` NexGen carried on the labor row, used as fallback / cross-check | `Source_Rate_Raw`; UI "FMS source rate" |
| **Exception / Issue** | a warning or error row from pricing (duplicate window, overlap, shift assumed, WTL …) | `fms.Payroll_CalcException`; UI issue pills |

### B5. Process words

| Term | What the client means | Where you meet it |
| --- | --- | --- |
| **Refresh from NexGen** | pull raw data again and recalc the whole 210-day window | UI button; `api.usp_UI_RefreshPayroll_FromNexGen` |
| **Nightly** | the scheduled full recalc | `etl.usp_RunNightly_PayrollAPP` |
| **Pricing / Pricing engine / Pricing run** | the slice calculation | `app.usp_Run_Pricing_Engine`; `RunId` |
| **Finalize** | the twelve post-processors after pricing | `app.usp_FinalizePayrollOutputs_AfterPricing` |
| **Process / Processed** | freeze the week into a snapshot; blocks refresh | `app.usp_ProcessPayroll_PayPeriod`; `app.PayPeriod.Status` |
| **Worklist** | the UI's one-row-per-employee list for a week | `/worklist` |
| **Batch / Worksheet** | ADP's word for one import sheet (ROLL = field, SALARY, PTO001) | ADP screens |

---

## 0. The order things happen (once, per run)

1. Clean the punches → 30-minute slices (rule 1).
2. Price every slice: base + shift adder + boom adder, × the day multiplier (rules 1–4).
3. Then, in this order: missing-rate fallback (13) → guaranteed minimums (5–7) → rest premium
   (9) → suppress no-rate rows (13) → California non-union OT (12) → build the ledger → shift
   hours-add (8) → worked-through-lunch (10) → reconciliation → subsistence (11) → rounding (14).

Result per entry: `Final_Gross_Pay = actual + guarantee gap + rest premium + shift hours-add`;
the ledger adds WTL lines; subsistence is paid on top but is not part of gross.

---

## 1. Base pay — the slice formula

**When:** every labor entry with valid times.

**How:** the entry's start is rounded *down* and end *up* to 30 minutes, then cut into 30-minute
slices. Each slice gets one hourly rate and one multiplier.

**Formula:** `slice_pay = 0.5 h × (Rate_Base + Rate_Shift + [boom? Rate_Boom]) × multiplier`
Entry `Pay_Actual_Gross` = sum of its slices.

**Rate_Base:** union crafts (`L12…`) → `FMS_UNION_CRAFT.PayRate` for the *labor row's* craft
(e.g. L12-G3-A = 67.87, L12-G6-A = 68.41, L12-APP-A = 40.90). Non-union admin (`ADMIN…`) →
`FMS_EMPLOYEES.PayRate`. If the labor craft and the employee's craft differ, **the labor row's
craft wins**.

**Example:** 8 h weekday, L12-G3-A: 16 slices × 0.5 × 67.87 × 1.0 = **542.96**.

**Where:** `app.usp_Prepare_Continuous_Labor` (rounding), `app.usp_Run_Pricing_Engine :884–911,
1168–1181`.

---

## 2. Overtime and double time (union)

**When:** a weekday slice is beyond 8 cumulative hours in the shift (OT), beyond 12 (DT), or
falls outside 06:00–17:00 (OT). Cumulative hours count from the shift's actual start; a shift
that crosses midnight keeps counting.

**How:** the slice's multiplier becomes 1.5 (OT) or 2.0 (DT). No pyramiding — one multiplier
per slice, the highest that applies.

**Formula:** slices 1–16 (8 h) → ×1.0; slices 17–24 (8–12 h) → ×1.5; slice 25+ (>12 h) → ×2.0;
any slice starting before 06:00 or at/after 17:00 → at least ×1.5.

**Example:** 04:00–17:00 (13 h), L12-G3-A: 8 h × 67.87 + 4 h × 67.87 × 1.5 + 1 h × 67.87 × 2
= 542.96 + 407.22 + 135.74 = **1,085.92** (entry 83338).

**Where:** engine `:1056–1114` (accumulation), `:1157–1167` (multiplier);
`cfg.Union_Master_Rules` (06:00–17:00, 8 h, 12 h, ×1.5, ×2.0).

---

## 3. Saturday, Sunday, holiday, special Saturday

**When:** by the calendar day of each slice (a cross-midnight shift can change day type at
00:00; OT counting still runs from the shift start).

**How / formula:**
- Saturday → every slice ×**1.5** (reported as OT hours).
- Sunday → ×**2.0** (reported as DT hours).
- Holiday (`dim.LU12_Holiday`, 9 holidays a year) → ×**3.0** (reported as DT hours; the UI
  shows them as "H3x").
- Special Saturday = the first Saturday of June and December (day ≤ 7) → ×**2.0** (UI "H2x").
- Holiday beats Sunday beats special Saturday beats DT beats OT beats Saturday.

**Example:** Sunday 7 h, L12-G8-A 69.16: 7 × 69.16 × 2 = **968.24** (entry 82976).
Presidents' Day 16.5 h at 69.16 × 3 = **3,592.17** (entry 78410).

**Where:** engine `:930–936` (special Saturday), `:1116–1122` (day type), `:1157–1167`.

---

## 4. Boom pay (craft modifier) — when and how

**When — all four must be true for a slice:**
1. the labor row carries a **craft-modifier code** (`OP-BP-nn` operator, `OI-BP-nn` oiler — a
   20-ft boom-length bracket chosen in NexGen when the row is entered);
2. the labor row's craft is a **union craft** (`L12…`);
3. the job ticket has a **boom window** (in practice `ArrivedJob → LeftJob`, rounded to 30 min);
4. the slice lies **fully inside** that window.

If the ticket has a boom window but the row has no modifier code → **no boom pay** (UI badge
"Ticket boom window only – no modifier"). If the row has a modifier but no slice falls in the
window → no boom pay ("Modifier present, no boom hours"). If the craft is not `L12…` (e.g.
`HDR-A`) → boom **hours** are counted but **$0** premium (a known defect).

**How:** the modifier's `PayRateChange` is **added to the hourly rate** on those slices, and the
sum is multiplied by the day/OT/DT multiplier — so boom pay grows on OT, DT, weekends, holidays.
It is an adder, never a rate switch. Boom hours = 0.5 × number of boom-active slices.

**Formula:** `boom_pay = Σ boom-active slices: 0.5 h × Rate_Boom × multiplier`
(ledger line `ACTUAL_BOOM_WORKED_PAY`; base pay is unaffected).

**Adder values (per hour):** operator 0.75 (80–100 ft), 1.50, 2.25, 3.00, 3.75, 4.50 (181–200),
5.25, 6.00, 6.75, 7.50, 8.25, 9.00, 9.75, 10.50, 11.25, 12.00, 13.50 (421–440 ft);
oiler 0.25 (80–100), 0.50, 0.75, 1.00, 1.25, 1.50 (181–200), 1.75, 2.00, 2.25, 2.50, 2.75, 3.00,
3.25, 3.50, 3.75. Nothing else about boom length exists — no feet arithmetic, no jib, no
travel/curfew exclusion, no lattice branch.

**Example:** oiler OI-BP-01 (+0.25) on a 22 h entry with 21 boom hours spread over ST/OT/DT
slices → boom pay **8.13** (21 h × 0.25 = 5.25, grossed up by the OT/DT multipliers) (entry
71754). Operator OP-BP-03 (+2.25), 4 boom hours on a special Saturday (×2) → 4 × 2.25 × 2 =
**18.00** (entry 74066).

**Where:** engine `:857–876` (window carried only with a modifier), `:905–911` (adder, L12
only), `:986–993` (boom-active), `:1168–1170`; `api.v_UI_LaborEntry_BoomBreakdown :35–45,
173–188`; adders in `FMS_UNION_CRAFT_MODIFIER` ([data/craft-modifiers-and-boom-status.md](data/craft-modifiers-and-boom-status.md)).

---

## 5. Long-boom minimum — 4 boom hours (`LONG_BOOM_MIN_4`)

**When:** in a shift (grouped per employee per shift anchor date), the worker had *some*
boom-paid hours (modifier present, adder ≠ 0) but **fewer than 4**. If the whole shift is
shorter than 4 h, the minimum shrinks to the shift length. Rows without a modifier never count
toward or trigger it (`EXCLUDE_NO_MODIFIER`). Admin crafts are exempt from all minimums.

**How:** the missing boom hours are paid **at the boom adder only** (not base), at the
multiplier of the boom slices, and pinned to the last boom-paid entry of the shift.

**Formula:** `gap = min(4, shift hours) − boom hours`; `pay = gap × Rate_Boom × multiplier`
(ledger `GUARANTEED_BOOM_PAY_ADD`, hours in `Gap_Hrs_Boom`).

**Example:** 4 h shift, boom 0.5 h, OP-BP-02 (+1.50): gap 3.5 h × 1.50 × 1.0 = **5.25** (entry
81827).

**Where:** `app.usp_Apply_GuaranteedHours :265–281, 378–427, 697–714`. The "4" is hard-coded in
the proc; `cfg.GuaranteedHoursRule` supplies only enable + the no-modifier treatment.

---

## 6. Daily minimum — 4 hours (`DAILY_MIN_4`)

**When:** an employee's shift (all entries in the same shift anchor date) totals more than 0 but
**less than 4 actual hours**, and the craft is not `ADMIN-*`.

**How:** the shortfall is paid at **base + shift adder** (no boom), ×1.0, on the last entry of
the shift; the gap hours are added to payable hours (`Pay_Total_Hrs`).

**Formula:** `gap = 4 − actual hours`; `pay = gap × (Rate_Base + Rate_Shift) × 1.0`
(ledger `GUARANTEED_BASE_PAY_ADD`, hours in `Gap_Hrs_Total`).

**Example:** 3 h at L12-G6-A 68.41 → 1 h × 68.41 = **68.41**.

**Where:** `app.usp_Apply_GuaranteedHours :335–362, 646–663`.

---

## 7. Holiday minimum 8 h and special-Saturday minimum 8 h

**When:** on a holiday (`dim.LU12_Holiday`) or a special Saturday, the employee's slices that
calendar day total more than 0 but **less than 8 hours**.

**How:** the shortfall is paid at **base + shift adder** (no boom) at the day's multiplier —
holiday ×3.0, special Saturday ×2.0 — on the entry with the latest slice that day. A day is
never counted under both rules.

**Formula:** `gap = 8 − hours worked that day`; `pay = gap × (Rate_Base + Rate_Shift) × 3.0`
(holiday) or `× 2.0` (special Saturday) — ledger `GUARANTEED_HOLIDAY_BASE_PAY_ADD` /
`GUARANTEED_SPECIAL_SAT_BASE_PAY_ADD`.

**Example:** Memorial Day 5 h → 3 h × 71.16 × 3 = **640.44** (entry 86102). Special Saturday
6 h at 67.87 → 2 h × 67.87 × 2 = **271.48** (entry 74066).

**Where:** `app.usp_Apply_GuaranteedHours :443–533, 744–761, 810–827` (8 and the multipliers
hard-coded).

---

## 8. Second / third shift differential

**When:** the NexGen labor **comment** contains `(PAY:SHIFT_2)` or `(SHIFT_2)` — or the
`SHIFT_3` forms. Both present = conflict → treated as day shift. (There is no shift field; only
the comment.)

**How — two separate things happen:**
- **Rate add:** +$3.00/h (shift 2) or +$4.00/h (shift 3) is added into every slice's rate, so
  it is multiplied by OT/DT/day multipliers (ledger `ACTUAL_SHIFT_DIFFERENTIAL`).
- **Hours add:** the entry gets **+1.0 h** (shift 2, works 7 paid 8) or **+1.5 h** (shift 3,
  works 6.5 paid 8), paid at (base + shift adder) × the multiplier of the entry's *last* slice,
  **no boom** (ledger `SHIFT_2_HOURS_ADD` / `SHIFT_3_HOURS_ADD`; added to `Final_Gross_Pay`).

**Formula:** rate add: `Σ 0.5 × Rate_Shift × multiplier`; hours add:
`add_hours × (Rate_Base + Rate_Shift) × last_multiplier`.

**Example:** 12 h on shift 2 at 66.03 → rate add 12 × 3.00 = **54.00** (inside actual gross);
hours add 1.0 × (66.03 + 3.00) × 1.5 = **103.55** (entry 82541). Used 3 times in the whole
history.

**Where:** `app.v_LaborPayroll_CommentTokens :74–90, 278–283`; engine `:903, 947–949`;
`app.usp_Apply_ShiftDifferentialHoursAdd :77–84, 172–183, 322–343` (1.0/1.5 hard-coded);
`cfg.Union_Shift_Rules` (3.00 / 4.00).

---

## 9. Rest-period premium ("came back too soon")

**When:** entries ≤ 30 min apart form a work chain. The **next** chain is *rest-forced* when
the previous chain had any OT or DT hours **and** the time off between them was **less than
8 hours**. Once forced, every following chain stays forced until one is preceded by ≥ 8 h off.

**How:** on forced slices the multiplier is raised to a floor of **×1.5** (×2.0 once cumulative
hours in the rest chain reach 12). Only the **increase** over the slice's normal multiplier is
paid — a slice already at ×1.5 or higher gets nothing extra. Overlapping entries are flagged but
still priced.

**Formula:** `premium = Σ forced slices: 0.5 h × rate × (floor − normal multiplier)`
(`Pay_Rest_Add`; ledger `REST_PERIOD_PREMIUM`; hours in `Rest_Premium_Hrs`).

**Example:** prior chain had OT, 5 h off, then 4 h of straight time at 40.90 → 4 × 40.90 × (1.5
− 1.0) = **81.80** (entry 83285; final gross 163.60 + 81.80 = 245.40).

**Where:** `app.usp_Apply_RestPeriod_Premium :238–272, 478–514, 621–639`;
`cfg.RestPeriod_Rule` (8 h, ×1.5, 30 min, `HrsOTDTPositive`).

---

## 10. Worked-through-lunch (WTL) — deducts and adds

**When:** for every group of back-to-back entries (any gap breaks the group), the total span
decides how many meals were *expected*: ≤5.0 h → 0; 5.5–10.5 h → 1; 11.0–16.0 h → 2;
16.5–21.5 h → 3; 22.0–27.0 h → 4. Meal opportunities are placed at 5.0 / 10.5 / 16.0 / 21.5 h
after the group start, 30 minutes each. The comment token `(PAY:WTL_n)` says how many were
**worked through**; **no token = 0 worked through** (a warning is logged), i.e. all expected
meals are treated as taken.

**How:**
- **Taken meal** → `WTL_MEAL_DEDUCT`: the whole priced 30-minute slice at the opportunity is
  removed (base + shift + boom, × its multiplier).
- **Worked-through meal** → an add of 30 minutes at **double time on base + shift (no boom)**:
  `WTL_APPLICABLE_ADD` = 0.5 × (base + shift) × 2.0 on Sat/Sun/holiday/special-Sat or any
  block that started in OT/DT; `WTL_DT_FLOOR` = 0.5 × (base + shift) × (2.0 − slice multiplier)
  on a weekday block that started in straight time (tops the half hour up to ×2).
- Conflicting tokens, a token higher than the expected count, or a span outside every bracket
  → no components, an error/review row instead.
- The UI's `LaborBreakOverride` table is **not** read.

**Formula:** deduct `−0.5 × (Rate_Base + Rate_Shift + Rate_Boom) × multiplier`;
add `+0.5 × (Rate_Base + Rate_Shift) × 2.0` (or `× (2.0 − multiplier)`).

**Example:** deduct on an OT slice with boom: −0.5 × (68.16 + 3.00) × 1.5 = **−53.37** (entry
66632). Add for a shift-2 worker: +0.5 × (66.03 + 3.00) × 2.0 = **+69.03** (entry 84393).
WTL lines live only in the ledger: `LaborGross_AfterWTL = Final_Gross_Pay + WTL lines`.

**Where:** `app.usp_Apply_WTL_MealPeriods :482–491, 522–542, 578–620, 746–753, 794–822`;
`cfg.WTL_Rule`, `cfg.WTL_MaxMealThreshold`.

---

## 11. Subsistence

**When:** the labor comment contains `(PAY:SUB_SHORT)` or `(PAY:SUB_LONG)`.

**How:** a flat dollar line, **paid but not part of Final Gross** (`IncludedInFinalGross = 0`,
`IncludedInPayableGross = 1`). Weekend is decided from the work date, not the token.

**Formula:** SUB_SHORT → **$85** any day (`SUBSISTENCE_SHORT_85`); SUB_LONG → **$85** Mon–Fri
(`SUBSISTENCE_LONG_WEEKDAY_85`) or **$200** Sat/Sun (`SUBSISTENCE_LONG_WEEKEND_200`).

**Where:** `app.usp_Apply_SubsistencePay :88–96, 125–132, 192–194` (amounts hard-coded).

---

## 12. Non-union admin hourly — California overtime

**When:** the employee's craft is `ADMIN…` and PayType is `H` (payroll group "Non-Union Admin
Hourly"). Rate = `FMS_EMPLOYEES.PayRate`.

**How:** the union results for these rows are thrown away and replaced. Every union extra
(minimums, boom, rest, WTL, subsistence, outside-window OT, holidays) is zeroed.

**Formula (per Sat–Fri week):**
- each day: first 8 h straight, hours 8–12 → OT ×1.5, beyond 12 → DT ×2.0;
- week: straight-time hours beyond 40 → OT ×1.5, taken from the latest straight-time hours;
- 7th consecutive worked day: no straight time — first 8 h OT, beyond 8 h DT.
Gross = `rate × (ST + 1.5 × OT + 2 × DT)`; ledger = six lines `NONUNION_CA_NONEXEMPT_ST /
_DAILY_OT / _WEEKLY_OT / _DAILY_DT / _7TH_DAY_OT / _7TH_DAY_DT`.

**Example:** 10.5 h day at $25 → 8 × 25 + 2.5 × 25 × 1.5 = 200.00 + **93.75** (entry 87529).
A 49 h week (Sat 4 + Mon–Fri 9 each) at $25 → 40 ST, 5 daily OT, 4 weekly OT → 25 × (40 + 1.5
× 9) = **1,337.50**.

**Where:** `app.usp_Apply_CA_NonUnionAdminHourly_OT :71–74, 258–295, 445–474, 583–618`
(thresholds hard-coded); group in `api.v_UI_Employee_TypeRate :50–70`.

---

## 13. Missing rate — fallback and suppression

**When / how:**
- Priced hours but $0 gross and a NexGen source rate exists → gross =
  `Source_Rate × (ST + 1.5 × OT + 2 × DT)` (`app.usp_Apply_BasePay_Fallback_FromSource`).
- Hours worked but **no** source rate → all pay columns set to **0**, hours kept for review
  (`app.usp_SuppressPay_WhenSourceRateMissing`). About 5,725 rows sit in "Unknown / Needs
  Review".

**Example:** 2.5 h, no rate → Final Gross **0.00** (entry 86465).

---

## 14. Rounding and the ledger tie-out

**How:** money is rounded to cents (`ROUND(x, 2)`); the ledger's base line absorbs the penny
difference so base + shift + boom = `Pay_Actual_Gross` exactly; one
`PAY_COMPONENT_ROUNDING_ADJUSTMENT` row per entry forces the non-WTL ledger to equal
`Final_Gross_Pay`; a guarantee true-up row keeps guarantee lines equal to `Pay_Gap_Add`.
`LedgerTieOutStatus` = Balanced / Out of balance / No ledger rows.

**Formulas the UI shows:** `LaborGross_BeforeWTL = Final_Gross_Pay`;
`LaborGross_AfterWTL = Final_Gross_Pay + WTL lines`; `TotalPayableGross = LaborGross_AfterWTL +
subsistence`; `Payable Hrs = ST + OT + DT + H2x + H3x`.

**Where:** `app.usp_Rebuild_PayComponentLedger`, `app.usp_Normalize_PayComponentLedger_Rounding`,
`app.usp_Finalize_PayComponentLedger_Reconciliation`, `api.v_UI_Payroll_LaborEntry_Ledger_Summary`.

---

## Not calculated anywhere

Foreman premium · military base / Davis-Bacon · lattice boom · hazardous material · boom-length
arithmetic / jib / travel or curfew exclusion · sick, PTO, on-call (those exist only on the ADP
sheet). Any comment token other than `SHIFT_2, SHIFT_3, SUB_SHORT, SUB_LONG, WTL_0..4, WTL` is
ignored.

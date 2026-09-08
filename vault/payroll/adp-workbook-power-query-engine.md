---
title: PAYROLL for ADP workbook — the Power Query engine (v3.8)
source: shared-folder/Project-Repository-2026-09-04/3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL for ADP v3.0 - current/__PAYROLL for ADP v3.8 (MASTER template).xlsm — DataMashup part (customXml/item4.xml, UTF-16, 166 KB of M) plus the hidden configuration sheets; v3.7 and July 25-31 2026.xlsm carry byte-identical M
migrated: 2026-09-04
updated: 2026-09-08
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/source, adp, earning-codes, craft-code, boom, shift-differential, subsistence, holidays, legacy-payroll-app, integrations]
entities: []
---

# PAYROLL for ADP workbook — the Power Query engine (v3.8)

> **v5.1 (2026-09-06) changes this page in four places** — the roster now comes from the Payroll App
> database, not FCC; Foreman and Military reach the export (`FRR–FRT`, `MLR–MLT`, 28 Hours-4 slots);
> a `BASE_RATE_OVERRIDE` row type exists; and the workbook displays the app's recommendations. Only
> the differences are recorded: [adp-workbook-v5.1-engine.md](adp-workbook-v5.1-engine.md). Everything
> else below still runs unchanged.

**What this is.** The calculation and export logic of TCG's live payroll workbook, read from
its embedded Power Query (M) code on 2026-09-04. The August pass recorded the workbook as
"machinery, not migrated"; the VBA was read on the nested-content pass
([adp-workbook-vba-macros.md](adp-workbook-vba-macros.md)) and found to contain no pay logic —
*"the pay rules live in the sheets' formulas and Power Query."* This page is that Power Query:
fourteen queries, 166 KB of M, in a `DataMashup` part stored as UTF-16 (which is why two earlier
extraction attempts found nothing). **v3.8, v3.7 (Mac) and the live July 25–31 2026 file carry
byte-identical M**, so this describes all three.

**What it settles.** How FCC employee data reaches the workbook (a SQL query, quoted below), how
the week and the ADP batch are defined, how each hour bucket becomes an ADP earnings code, what
the temporary-rate premiums are worth, and what the export validates before it will let a CSV
out. It also exposes three things nobody had written down — see *What the code reveals*.

> Read alongside [adp-workbook-column-rules.md](adp-workbook-column-rules.md) (the sheet columns
> and the multiplier ladder) and [adp-bucket-crosswalk.md](adp-bucket-crosswalk.md) (the ADP
> codes). Where those pages and this code disagree, **the code is what actually runs** — but it
> is still `unverified` as a statement of what *should* run.

## The fourteen queries

| # | Query | Load | Role |
| --- | --- | --- | --- |
| 1 | `fnFccNativeQuery` | function | Runs native SQL against FCC's `NexGenFMS` SQL Server using the server/database names in the hidden `__hiddenParams` sheet (`nmParam_ServerName`, `nmParam_DatabaseName`) |
| 2 | `fxGetNamedRangeValue` | function | Reads a one-cell named range |
| 3 | `src_FccEmployees` | `PAYROLL_START` → `tblFccEmployees` | **The employee roster for the selected week, pulled live from FCC** — §1 |
| 4 | `dim_PayrollWeek` | `__PayrollWeeks` → `tblPayrollWeeks` | Generates the Saturday–Friday payroll calendar — §2 |
| 5 | `tblCfgCraftRates` · `tblCfgCraftModRates` · `tblCfgHolidays` | config | Load the three hidden config tables — §5 |
| 6 | `qEmployeePayrollRaw` | connection only | Stacks every `tbl___<ADPFileNo>` employee sheet into one table — §3 |
| 7 | `qPayrollComponents` | connection only | **Turns wide sheet rows into a normalised component ledger** — §3 |
| 8 | `qADPPrimaryRows` | connection only | One ADP "primary" row per employee per week — §4 |
| 9 | `qADPRateRows` | connection only | One ADP "temp-rate" row per employee × code × rate — §4 |
| 10 | `qADPImportReview` | `ADP_IMPORT_REVIEW` → `tblADPImportReview` | The staged CSV rows, in review order — §4 |
| 11 | `qADPImportValidation` | `ADP_IMPORT_VALIDATION` → `tblADPImportValidation` | Fifteen checks; `PASS` / `WARNING` / `ERROR` — §6 |

## 1. Who is on payroll this week — `src_FccEmployees`

The roster is **not maintained in Excel**; it is queried from FCC for the pay period in the
named ranges `nmPayStartDate` / `nmPayEndDate`. The SQL, verbatim in substance:

```sql
FROM dbo.FMS_EMPLOYEES e
LEFT JOIN dbo.FMS_EMPLOYEE_TYPES et ON et.EmpTypeID = e.EmpTypeId
WHERE craft.CraftType <> 'SYS-ACCESS'
  AND craft.CraftCodeClean IS NOT NULL
  AND COALESCE(e.RehireDate, e.StartDate) < DATEADD(day, 1, @PayrollEndDate)
  AND (e.TermDate IS NULL OR e.TermDate >= @PayrollStartDate)
```

Rules the query encodes:

- **Active during the week** means: hired or rehired on or before the week's end, and not
  terminated before the week's start. Rehire date wins over start date.
- **Employees with no craft code are excluded**, and so are `SYS%` (system-access) crafts.
- `CraftType` is derived from the FCC craft-code prefix: `L12…` → **L12**, `ADMIN…` → **ADMIN**,
  `SYS…` → SYS-ACCESS, anything else → *Other CraftCode*.
- **The FCC craft code is truncated by its last two characters** to match `tblCfgCraftRates` —
  so FCC's `L12-G3-A` becomes `L12-G3`. The suffix (the `-A` seen on real tickets, see
  [../field-ops/e-ticket-worked-example-44944.md](../field-ops/e-ticket-worked-example-44944.md))
  is dropped for rate lookup.
- `PayType` `H` → *Hourly*, `S` → *Salary*, anything else → `Review: <value>`. **All pay types are
  included**, salary too — the column is "informational only" per the comments.
- `EmployeeName` is `LName, FName`; `EmpID` is text, and a **normalised key** strips leading zeros
  (`0004` → `4`) so it can join the Excel table `tblCfgEmpInfoDetails`, which is where
  **`ADPFileNo` and `SheetName` live** — an Excel-maintained mapping from FCC employee to ADP
  file number. Duplicate normalised keys are detected and stop the query.
- The fiscal-year craft rates (`FY25-26`, `FY26-27`) are merged in from `tblCfgCraftRates`.

## 2. The week — `dim_PayrollWeek` and `tblPayrollWeeks`

- **Weeks run Saturday to Friday.** Week 01 of a payroll year begins on the first Saturday on or
  after January 1. Only complete weeks are generated, from `nmParam_CalendarStartDate`
  (2025-07-01) to `nmParam_CalendarEndDate` (2028-06-30).
- Each week carries: `Pay Period` label (`2026 (Jan 3 - Jan 9)`), start, end, **payday = the
  Thursday six days after the week ends**, payroll year/month/week, **`Payroll YrMoWk`** (e.g.
  `260103`) — which becomes the **ADP Batch ID** — and **`ADP File Name`** `EPI4RZnn`.
- **The ADP file-name counter restarts every payroll year**: `EPI4RZ01` names the week of
  2025-07-05 *and* the week of 2025-12-20 (payroll year 2026, week 01). The Batch ID does not
  collide, but the file name does — worth knowing before anyone keys an archive by file name.
- Company code `4RZ` and company name `THE CRANE GUYS LLC` come from `__hiddenParams`. **This
  confirms `4RZ` as the ADP Co Code**; the `631` seen on the ADP worksheet screenshot is
  therefore something else (client/batch number), not the company code.

## 3. From sheet rows to a component ledger — `qEmployeePayrollRaw` + `qPayrollComponents`

`qEmployeePayrollRaw` stacks every table named `tbl___<ADPFileNo>` (the TEMPLATE table `tbl___`
is excluded), keeps the seven dated rows *including NO WORK rows* plus any manual extra rows
that carry data, and stamps each row with `SourceTable`, `SourceADPFileNo`, `SourceRow` and
`FileNumberMatch` (1 if the row's File # equals the table's own number).

`qPayrollComponents` then explodes each row into components — **zero-value components are
omitted; blanks are never turned into zeros**:

| Sheet column | Component | ADP field | Group |
| --- | --- | --- | --- |
| `ST` | `REG` → *Reg Hours* | Reg Hours | PRIMARY |
| `OT` | `OT` → *O/T Hours* | O/T Hours | PRIMARY |
| `DT` | `DT` *Double Time* | Hours 3 | PRIMARY |
| `H2x` | `HDD` *Holiday Double* | Hours 3 | PRIMARY |
| `H3x` | `HOL` *Holiday Triple* | Hours 3 | PRIMARY |
| `Subsistence` | `SUB` — an **Amount**, not hours | Earnings 3 | PRIMARY |
| `Sick Hrs` | `SIC` | Hours 3 | PRIMARY |
| `LB ST` / `LB OT` / `LB DT` / `LB 3X` | `LBH` / `LBO` / `LBD` / `LBT` *BOOM REG/OT/DBL/TRI* at the row's `LB … Rate` | Hours 4 | TEMP_RATE |

**Premium tokens** on the row — `LATT_OPER`, `LATT_OILER`, `SHIFT_2`, `SHIFT_3` — are expanded
through the hidden `tblCfgADPTempRates` table, which maps token × hour bucket → ADP code and
**temporary rate**:

| Token | Bucket → code | Temp rate ($/hr) |
| --- | --- | --- |
| `LATT_OPER` | ST→`LPR` · OT→`LPO` · DT+H2x→`LPD` · H3x→`LPT` | **1.00 · 1.50 · 2.00 · 3.00** |
| `LATT_OILER` | ST→`LOR` · OT→`LOO` · DT+H2x→`LOD` · H3x→`LOT` | **0.50 · 0.75 · 1.00 · 1.50** |
| `SHIFT_2` | ST→`S2R` · OT→`S2O` · DT+H2x→`S2D` · H3x→`S2T` | **3.00 · 4.50 · 6.00 · 9.00** |
| `SHIFT_3` | ST→`S3R` · OT→`S3O` · DT+H2x→`S3D` · H3x→`S3T` | **4.00 · 6.00 · 8.00 · 12.00** |

So the lattice adders are the MLA's $1.00 operator / $0.50 oiler and the shift differentials the
MLA's $3.00 / $4.00, each **pre-multiplied by 1 / 1.5 / 2 / 3** and sent to ADP as separate
temp-rate hours rather than folded into the base rate. Double time and holiday-double share one
bucket (`DT + H2x`).

## 4. The ADP rows — `qADPPrimaryRows`, `qADPRateRows`, `qADPImportReview`

- **One primary row per employee per week**: `Co Code` (4RZ) · `Batch ID` (YrMoWk) · `File #` ·
  `Reg Hours` · `O/T Hours` · Hours-3 pairs in a fixed order — **01 DT · 02 HDD · 03 HOL · 04
  SIC** — and `SUB` as **Earnings 3 pair 01**.
- **Temp-rate rows**: one per `File # + ADP code + Temp Rate`, hours summed over the week. The
  same code at two different rates yields two rows. Each has exactly one Hours-4 pair, placed in
  a **fixed slot by code**: `01 LBH 02 LBO 03 LBD 04 LBT · 05 LPR 06 LPO 07 LPD 08 LPT · 09 LOR
  10 LOO 11 LOD 12 LOT · 13 S2R 14 S2O 15 S2D 16 S2T · 17 S3R 18 S3O 19 S3D 20 S3T`.
- Review order per employee: primary row, then boom rows, lattice operator, lattice oiler,
  second shift, third shift; same code at multiple rates sorted by rate. The `Name` column stays
  for review and is stripped by the VBA exporter.

## 5. The configuration tables (hidden sheets)

**`CraftRates`** — the L12 base rates the sheets look up by cleaned craft code:

| Craft | FY25-26 | FY26-27 |
| --- | ---: | ---: |
| `L12-APP1` … `L12-APP6` | 40.90 · 44.30 · 47.71 · 51.12 · 54.53 · 61.34 | +$0.60 to +$0.90 |
| `L12-G1` … `L12-G9` | 66.03 · 66.18 · 67.87 · 67.99 · 68.16 · 68.41 · 68.66 · 69.16 · 71.16 | **each exactly +$1.00** |

The FY25-26 group rates match the Local 12 notice of 2025-08-15
([mcog-l12-mla-2025-2028/local-12-wage-notice-2025-08-15.md](mcog-l12-mla-2025-2028/local-12-wage-notice-2025-08-15.md))
and the apprentice steps are 60 / 65 / 70 / 75 / 80 / 90 % of Group 5. **The FY26-27 column is the published
figure**: the union's rate sheet *Revised June 2026* allocates $1.00 of the $5.00 total-package
increase to wages on every group (67.03 … 72.16) —
[mcog-l12-mla-2025-2028/wage-rate-sheet-2026-07-01.md](mcog-l12-mla-2025-2028/wage-rate-sheet-2026-07-01.md).
(This paragraph first called the column "an assumption" on 2026-09-04; corrected the same day once
the rate sheet was read.)

**`CraftModRates`** — 52 rows: `OI-BP-01…26` (oiler, $0.25 per 20-ft bracket from 080–100 ft)
and `OP-BP-01…26` (operator, $0.75 per bracket), exactly the ladder
[adp-workbook-column-rules.md](adp-workbook-column-rules.md) derives. The sheet formulas apply
the bracket's `BaseRateAdd` × 1 / 1.5 / 2 / 3 to produce `LB ST Rate` … `LB 3X Rate`.

**`Holidays`** (`tblCfgHolidays`) — 2025 through 2028, columns `Date · Day · HolidayName ·
RuleApplied · PayRateMultiplier · IsWorkRestricted`. Nine holidays at **×3**, the **June and
December Special Saturdays at ×2** (`Contract Clause A.4`), **Labor Day flagged
`IsWorkRestricted = 1`**, and the observed-day rules applied explicitly — Independence Day 2027
moved to Monday July 5 (*Observed (Sunday Rule)*), Christmas and New Year 2027/28 moved to the
Friday before (*Observed (Sat Rule)*).

**`__hiddenParams`** also defines the **comment-token vocabulary** the sheets recognise:
`(PAY:WTL_0)`–`(PAY:WTL_4)` for meal periods missed, `(PAY:SUB_SHORT)` / `(PAY:SUB_LONG)`,
`(PAY:SHIFT_2)` / `(PAY:SHIFT_3)`, `(PAY:LATT_OILER)` / `(PAY:LATT_OPER)`, `(PAY:FOREMAN)`,
`(PAY:MILITARY)`.

## 6. What the export refuses — `qADPImportValidation`

Fifteen checks, each `ERROR` (blocks export) or `WARNING` (visible, does not block); a single
`PASS / READY` row when clean. Verbatim from the query's own list: missing or inconsistent
company code · missing Batch ID · missing or invalid ADP file numbers · missing review names ·
missing or duplicate primary rows · invalid PRIMARY/TEMP_RATE row types · missing or invalid
temp-rate codes · missing or invalid temp rates · Hours-4 code in the wrong slot · more or fewer
than one Hours-4 pair on a rate row · unpaired code/amount fields · DT/HDD/HOL/SIC/SUB in the
wrong place · a source table whose File # does not match its own table name · **a temp-rate
component that had hours but never received a rate** · zeros that should be blank. The VBA
exporter reads this table and stops on any ERROR.

## What the code reveals that no page said

1. **WTL, subsistence tier, foreman and military are tokens the sheets know but the ADP ledger
   does not.** `qPayrollComponents` expands only `LATT_*` and `SHIFT_*` tokens. There is **no WTL
   component, no foreman component, no military component** in the export path. Subsistence
   reaches ADP only as the `Subsistence` dollar column (`SUB`). Whatever WTL, foreman and
   military premiums are paid must therefore be folded into the ST/OT/DT/H2x/H3x hours on the
   sheet *before* the ledger sees them — the code cannot say how. This is a real gap between the
   token vocabulary and the export.
2. **The FY26-27 wage column matches the union's June-2026 rate sheet** — $1.00 to wages on every group (§5); an earlier reading of this page called it an assumption, wrongly.
3. **ADP file names repeat across payroll years** (§2).
4. **Salaried employees are pulled into the roster** and are only distinguished by a display
   column; nothing in the M excludes them from hour-based export.
5. **`FileNumberMatch`** exists because an employee sheet can be renamed or copied without its
   table being renamed — the validation catches the mismatch, which implies it has happened.

## The NEW_PAYROLL v1.1 workbook, for contrast

`PAYROLL_CURRENT/__NEW_PAYROLL_v1.1__MASTER-TEMPLATE.xlsx` carries a much smaller engine (7.8 KB
of M, 6 queries): the same three config tables, an Excel-maintained `tblCfgEmployees` (with
`EmpType`, `ClassCode`, `UnionCode`, `PayType`, `CraftCode`, `EmployeePayRate`, both FY rates,
`SheetName`), and `qCombinedEmployeeTime`, which stacks per-employee tables named
**`tblTime_<name>`** and left-joins the employee config. Its 77 employee sheets are named by
surname (`ALDRIDGE-J`, `VELEZ-C-Grp3` / `VELEZ-C-Grp9` — one person with two craft groups gets
two sheets). It has **no FCC query, no ADP row builder and no validation** — it is the manual
predecessor (or a manual fallback) of the v3.x line, with the same column set.

## Source

`__PAYROLL for ADP v3.8 (MASTER template).xlsm` → `customXml/item4.xml` (UTF-16 `DataMashup`,
base64 → package zip → `Formulas/Section1.m`, 166,465 characters), read in full; hidden sheets
`__hiddenParams`, `__PayrollWeeks`, `Holidays`, `CraftRates`, `CraftModRates`, `ADP TempRates`
read from the cell dump. The FCC server host name in `__hiddenParams` is deliberately not
recorded. Formula patterns of the `TEMPLATE` sheet (40 distinct) confirmed the bracket-rate
multiplication and the `Hrs Match` check (`Total Hrs = ST+OT+DT+H2x+H3x`).

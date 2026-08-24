---
title: Legacy Payroll App - extract README (counts, folder map, key numbers, findings)
source: user-supplied/PAYROLL_CALC_EXTRACT.zip (generated 2026-08-18 on the client machine from TCG_PayrollAPP + c:/projects/tcg-payroll-api)
migrated: 2026-08-18
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app, provenance]
entities: [pricing-engine]
part_of: payroll/legacy-payroll-app-db-extract/INDEX.md
---

> Part of the 2026-08-18 read-only extract of the live legacy database `TCG_PayrollAPP`
> (`localhost\SQLEXPRESS`, SQL Server 2025 Express). Line anchors like `sql\app\x.PROC.sql:12-20`
> refer to the verbatim definitions in [sql/](sql/) (backslashes → forward slashes). Employee
> identifiers are masked `E***NN`. Nothing that writes was executed to produce this.

# PAYROLL_CALC_EXTRACT — how pay is calculated in TCG_PayrollAPP

A complete, self-contained record of how the TCG payroll is calculated, extracted so someone who has never
seen this database can re-implement it exactly. Every claim about a calculation points at `schema.object` and,
for long bodies, a line range in the dumped `.sql` files.

- **Generated:** 2026-08-18 (calc/config values reflect DB state on that date).
- **Server / DB:** `localhost\SQLEXPRESS`, database **TCG_PayrollAPP** (Windows auth). Raw feed lives in
  `TCG_RawFMS`, surfaced here via 40 `src.*` synonyms.
- **Mode:** read-only. No procedure that writes was executed. Rule values were `SELECT`ed; definitions came
  from `sys.sql_modules` via .NET `SqlClient` (not `sqlcmd`, which truncates long text). Employee identifiers
  are masked `E***NN` (last 2 digits kept); names withheld. No connection strings, passwords, or keys are
  printed anywhere.

## Read this in this order
1. **CALCULATIONS.md** — the narrative (Part B), sections B1–B12, anchored to `sql/...:line-range`.
   This is the primary document. Start at "The calculation pipeline at a glance".
2. **WORKED_EXAMPLES.md** — Part D. 13 real masked labor entries traced source → calc → ledger → UI.
3. **OPEN_QUESTIONS.md** — Part E. 11 numbered direct answers (boom length, minimums, shift/rest/CA values,
   base-rate sources, Foreman/Davis-Bacon/etc., ADP, week/day definitions, which tests pass).
4. **OUTPUTS.md** — Part C. Every .NET API endpoint (JSON only, no file export) and the ADP-handoff search.
5. Reference material: `sql/`, `ddl/`, `data/`, `jobs/` (below).

## Folder map
| Path | What |
|---|---|
| `CALCULATIONS.md` | Part B narrative (B1 time prep, B2 pricing engine, B3 boom, B4 shift, B5 guarantees, B6 rest, B7 WTL, B8 subsistence, B9 CA non-union OT, B10 fallback/suppress, B11 ledger, B12 orchestration). |
| `WORKED_EXAMPLES.md` | Part D end-to-end traces. |
| `OPEN_QUESTIONS.md` | Part E numbered answers. |
| `OUTPUTS.md` | Part C (API + ADP). |
| `sql/_INDEX.md` | One row per programmable object: schema, name, type, line count, referenced entities; plus all 40 synonyms → base objects. |
| `sql/<schema>\<name>.<TYPE>.sql` | **All 141 definitions verbatim** (61 PROC, 67 VIEW, 10 TVF, 3 FN). |
| `ddl/<schema>.<table>.sql` | Full DDL for all **38** tables (columns, types, identity, defaults, computed cols, PK/unique, indexes, FKs, checks). |
| `data/cfg.*.md`, `data/dim.LU12_Holiday.md` | Every configuration/rule row, printed. |
| `data/test.Case_*.md`, `data/*Backup*.md` | Test scenario tables and the two definition-backup tables (older bodies dumped under `data/backups\`). |
| `data/_A3_distinct_codes.md`, `data/_A3b_...md` | Distinct code values actually in use (pay components, exception reasons, craft modifiers, boom statuses, payroll groups, rate sources). |
| `data/_A4_source_feed.md` | Every `src.*` synonym: base object, columns, row count, 3 masked sample rows. |
| `data/_TABLE_ROWCOUNTS.md` | Row counts for all 38 tables. |
| `data/_TEST_RESULTS.md` | Live results of the two read-only test suites (masked). |
| `jobs/sql_agent_jobs.md` | SQL Agent enumeration (see note below). |
| `parts/` | The per-section source files that were concatenated into `CALCULATIONS.md` (provenance; `_SHARED_CONTEXT.md` records the config values and rules used). |

## Object counts (match the reference DATABASE_STORED_PROCEDURES.md)
61 stored procedures, 67 views, 10 inline TVFs, 3 scalar functions, 40 synonyms, 38 user tables — all
present and dumped. No extra or missing programmable objects were found versus the reference counts.

## Key numbers you will need (full rows in `data/cfg.*.md`)
- Union **L12**: standard day 06:00–17:00, 8 ST hrs/day, DT after 12 hrs/day; OT ×1.5, DT ×2.0, Sat ×1.5,
  Sun ×2.0, Holiday ×3.0; Special Saturday ×2.0 (June/December, first Saturday, day ≤ 7).
- Shift 2 = +$3.00/h (work 7 paid 8); Shift 3 = +$4.00/h (work 6.5 paid 8).
- Guarantees: Daily min 4h, Holiday min 8h (×3), Long-boom min 4 boom-h, Special-Sat min 8h (×2).
- Rest: 8h required off, OT-floor ×1.50, stitch 30 min, TriggerMode HrsOTDTPositive.
- WTL: meal 0.5h, add ×2.0 on base+shift (exclude boom); span→meal brackets in `data/cfg.WTL_MaxMealThreshold.md`.
- Subsistence: SUB_SHORT $85, SUB_LONG weekday $85, SUB_LONG weekend $200 (payable-only, not in Final Gross).
- CA non-union hourly: daily OT >8–12 ×1.5, DT >12 ×2.0, weekly OT >40 ×1.5, 7th-day OT/DT; rate = Employee.PayRate.
- Base rate: union = `FMS_UNION_CRAFT.PayRate` by labor CraftCode (employee PayRate is 0); non-union = `FMS_EMPLOYEES.PayRate`.
- Boom adder: `FMS_UNION_CRAFT_MODIFIER.PayRateChange` (craft-modifier = boom-pole-length bracket, OP-BP/OI-BP).

## What was skipped, and why
- **`app.usp_Run_Pricing_Engine`, `app.usp_ProcessPayroll_PayPeriod`, `etl.usp_RunNightly_*`, all
  committing `app.usp_Apply_*`, `app.usp_Prepare_Continuous_Labor`, `calc.usp_Upsert/Apply_*`** — never
  executed (they write). Their behaviour is documented from their dumped bodies.
- **`test.usp_RunAll_PricingEngine_Tests`** — not run: its children `EXEC app.usp_Run_Pricing_Engine`
  (a write). Described in OPEN_QUESTIONS.md Q11 instead. The read-only suites were run.
- **ADP export tooling** — not present on this machine (no file-returning endpoint, no `.xlsx/.pq/.m/.dtsx/
  .rdl`, no linked server). Documented as an external artefact to be located by the payroll team (OUTPUTS.md,
  OPEN_QUESTIONS.md Q9).
- **SQL Agent** — this is SQL Server **Express** (no usable Agent; the service is stopped and the only job is
  the built-in `syspolicy_purge_history`). Nightly scheduling is therefore external (Windows Task Scheduler /
  the UI refresh proc). See `jobs/sql_agent_jobs.md` and CALCULATIONS.md B12.

## Notable findings (elaborated in the Part B/E docs)
1. `app.usp_Prepare_Continuous_Labor` does **not** materialise gap/"ghost" rows (`Is_Gap_Row` always 0);
   gap hours are derived downstream by `calc.v_Calc_Labor_Timeline` and priced by `usp_Apply_GuaranteedHours`.
2. Shift-differential and boom adders are **base-rate adders multiplied by the OT/DT/day multiplier**, not
   flat adds. Gap-boom uses `Audit_Gap_Mult`.
3. The guarantee proc **hard-codes** minimums/multipliers; `cfg.GuaranteedHoursRule` supplies only
   enable + boom-no-modifier treatment.
4. Non-`L12%` crafts carrying a boom modifier accrue boom **hours but no boom premium** — the single failing
   regression check (2 of 9 boom-breakdown assertions).
5. Sunday(×2), Special-Sat(×2) and Holiday(×3) hours are all reported in the `Hrs_DT` bucket by the engine;
   the 2×/3× split is a UI concept (`Bucket_Hrs_H2x/H3x`).

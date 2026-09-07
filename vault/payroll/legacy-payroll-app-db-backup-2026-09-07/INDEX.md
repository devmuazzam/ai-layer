---
title: Legacy Payroll App — the 2026-09-07 backup, restored and diffed against the 2026-08-18 extract
source: user-supplied/PayrollAPP_2026-09-07.zip → TCG.PayrollApp_backup2026-09-07.7z → TCG_PayrollAPP_20260907.bak (643 MB) + TCG_RawFMS_20260907.bak (1.5 GB, not restored) + TCG.PayrollApi + TCG.PayrollWeb; Brian Petros, 2026-09-07. Restored into SQL Server 2025 (Docker) on 2026-09-07 and catalogued read-only
migrated: 2026-09-07
updated: 2026-09-07
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app, rest-period, non-union, wtl, provenance, architecture]
entities: [pricing-engine, rest-period, payroll-group, pay-component, nightly-run]
part_of: payroll/INDEX.md
---

# Legacy Payroll App — the 2026-09-07 backup

**Short version.** Brian sent this the day he wrote *"no change to the way the 8-hour rest rule
should be calculated… the only change is how our internal Payroll App is displaying the results"*
([client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham](../client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham)). The code confirms him, more precisely than he said it. **The rule
procedures are unchanged** — `app.usp_Apply_RestPeriod_Premium` is byte-identical to the
2026-08-18 extract after whitespace normalisation, and `app.usp_Apply_CA_NonUnionAdminHourly_OT`
differs only by a `@ReturnResults` switch. Every one of the four fixes he described lives in the
**layers around** the rule procedures: a post-pricing *rest-slice adjustment* table that re-sources
the ST/OT/DT buckets, a *bucket-source selector* that stops non-union rows inheriting L12 day-type
classification, salary exclusion **before** pricing, and a strict-labor-times switch that turns the
"assumed 06:00 shift" fallback off. Plus a new Excel-facing layer and rule-narrative views that
produce the *Applied Payroll Rules* text in his workbook. Config rows: **none changed.**

The [2026-08-18 extract](../legacy-payroll-app-db-extract/INDEX.md) stays the document of record
for every unchanged object and all line anchors cited in `rules/`. This folder holds only what
moved: `sql/` has the **16 new** and **16 materially changed** definitions, `diffs/` the unified
diffs for the changed ones. Everything else compared identical (whitespace-only differences in
~110 objects are the extract's header comments, not code).

## The database

| | |
| --- | --- |
| Backed up | 2026-09-07 02:00 server-local, 643 MB; compat 130, `SQL_Latin1_General_CP1_CI_AS` |
| Objects | 41 tables (+3), 69 procs (+8), 75 views (+8), 10 TVFs, 3 functions, 44 synonyms (+4) |
| Rows | `Payroll_Calculated` 90,959 · `Payroll_PayComponent` 147,473 · `Payroll_CalcException` 429,944 · **`Payroll_RestSliceAdjustment` 14,431 (new)** · `PayPeriod` 53 · `etl.RunLog` 755 (last `NightlyPayroll` 2026-09-07 08:02, five runs that morning) |
| Sibling `TCG_RawFMS` | 1.5 GB `.bak` in the same zip, **not restored** — synonyms dangle; the ETL side is out of scope here |
| Code layer | `TCG.PayrollApi/Program.cs` (2,296 lines, last edited 2026-06-11) and `payroll-ui` (last edit 2026-06-11): the **same 15 endpoints and same pages** as [legacy-payroll-app-source-tree-2026-06-10.md](../legacy-payroll-app-source-tree-2026-06-10.md). The app's display changes are entirely SQL-side. The web folder carries `.env.local`, dev certificates and password hashes — **not copied** |

## What changed, by mechanism

### 1. Rest period — hours now land in DT *because a shadow slice layer re-sources the buckets*

- `app.usp_Apply_RestPeriod_Premium` — **unchanged.** `cfg.RestPeriod_Rule` — unchanged
  (`RequiredRestHours 8.00 · OTFloorMultiplier 1.50 · StitchGapMinutes 30 · HrsOTDTPositive`, row
  dated 2026-02-23).
- **New** `fms.Payroll_RestSliceAdjustment` + `app.usp_Rebuild_RestSliceAdjustment` (2026-09-04):
  after pricing, runs the already-existing `usp_Prototype_RestPeriod_SliceChain` (`@LookbackDays = 7`)
  and persists one row per **rest-forced slice** — `RestChainHoursBeforeSlice`, `NormalMultiplier`,
  `RestMultiplier`, `EffectiveMultiplier`, `RestReason`, `RestPremiumDelta` — keeping only slices
  whose entry `Payroll_Calculated.Rest_IsForced = 1` *after* group corrections (*"this naturally
  excludes the Non-Union Admin Hourly rows"*).
- **New** `api.v_UI_Pricing_Slices_Effective` → `api.v_UI_Pricing_Slices_PayrollEffective`: the
  original `Final_Multiplier` is preserved; `Effective_Final_Multiplier = COALESCE(rest, original)`
  becomes *"the authoritative multiplier for downstream classification"*.
- `api.v_UI_Payroll_LaborEntry_HourBuckets` (rewritten), `tvf_EmployeeWeekDailySummary`,
  `tvf_UI_Payroll_EmployeeDayTotals_ForDateRange`, `v_UI_Payroll_LaborEntry_WeekDetail_WithBuckets`
  now read the *effective* slices, so a forced slice is **counted in the DT bucket** instead of
  staying in its natural bucket with a premium dollar amount alongside. That is what Brian meant
  by *"not calculating the ST/OT/DT hour buckets for this rule"* — the money was always right; the
  hours column was not.
- `app.usp_FinalizePayrollOutputs_AfterPricing` calls the rebuild before the ledger rebuild.
- **The exhibit, in the data** (employee masked): `RestReason` and multipliers for the week of
  2026-08-22 —

  | WorkDate | Entry hrs | Chain hrs before slice | Normal ×| Rest × | Δ $ | Reason |
  | --- | ---: | --- | --- | --- | ---: | --- |
  | 08-24 pm | 5.0 | 6.0 → 10.5 | 1.5 | 1.5 | 0.00 | *Normal already meets rest floor* |
  | 08-25 am | 8.0 | 11.0 → 18.5 | 1.0–1.5 | **1.5 → 2.0** | 487.62 | *Rest chain over 12 hrs* |
  | 08-25 pm | 10.0 | 19.0 → 28.5 | 1.5 | 2.0 | 348.30 | same |
  | 08-26 ×3 | 6.5 / 5.0 / 5.0 | 29.0 → 45.0 | 1.0–1.5 | 2.0 | 400.55 / 174.15 / 174.15 | same |
  | 08-27 | 11.5 | 45.5 → 56.5 | 1.0–1.5 | 2.0 | 679.19 | same |

  The chain accumulates all week because no gap reaches 8 h; the ×2.0 floor starts at the slice
  where the chain passes 12 h. `RestReason` vocabulary across all 14,431 rows: *Rest chain over 12
  hrs* (11,239), *Normal already meets rest floor* (1,972), *Rest floor to OT* (1,113), *Sunday
  premium meets rest-chain DT floor* (95), *Sunday premium exceeds rest floor* (12).
- **WTL now reads the rest-adjusted slices:** `usp_Apply_WTL_MealPeriods` switched its slice
  source from `v_UI_Pricing_Slices_Advanced` to `v_UI_Pricing_Slices_PayrollEffective`, so the
  WTL *deduct* basis (`FULL_SELECTED_PRICED_SLICE`) is the rest-adjusted slice pay. One real
  interaction between PAY-045 and PAY-047 that the register did not have.

### 2. Non-union — the CA procedure is untouched; the *bucket source* was wrong

`v_UI_Payroll_LaborEntry_HourBuckets` header, verbatim: *"Eligible Non-Union Admin Hourly / ADMIN\*
labor rows use the dedicated California ST/OT/DT classification already persisted in
`fms.Payroll_Calculated`. Non-Union Admin Hourly does not inherit L12 Special Saturday or Holiday
H2x/H3x classification. This changes canonical bucket SOURCE selection only. It does NOT modify the
CA Non-Union calculation procedure."* Bucket source is now tagged (`PAYROLL_CALCULATED_NONUNION_CA`
vs `PRICING_SLICES`) with a tie-out check (`Bucket_Hrs_TieOut_Status`). This is the *"mixing up the
logic during some of the steps"* — union day-type buckets leaking into non-union display rows.

### 3. Salary excluded before pricing

`usp_Run_Pricing_Engine` now joins `src.FMS_EMPLOYEES_Raw` and drops `PayType = 'S'` rows before
any pricing or time validation; `v_UI_Employee_TypeRate` classifies `PayType S` as *Salary* (ADMIN →
*Non-Union Admin Salary*) ahead of the L12 predicates and suppresses rate-review warnings for them;
new `test.usp_Test_PricingEngine_SalaryExcluded` asserts zero calculated and zero exception rows.
Register: PAY-013's *"not calculated from labor"* is now enforced at the front of the pipeline.

### 4. Strict labor times — the assumed-shift fallback is off by default

`usp_Run_Pricing_Engine @StrictLaborTimes bit = 1`: the `StdStart+Hours` reconstruction
(06:00 + hours worked, PAY-018) is used **only when `@StrictLaborTimes = 0`**. Entries with
missing or equal start/end now become exceptions `Missing_Required_Labor_Times` /
`Invalid_Labor_Time_Interval` (only when `HoursWorked_Raw > 0`) instead of being priced from an
assumed shift. Warning text is appended after the primary reason rather than prepended.

### 5. Refresh and run lineage

- `etl.usp_RunNightly_PayrollAPP` takes an optional explicit window; interactive (web/Excel) calls
  must be **exactly seven days starting Saturday**, and with `@RequireFreshPriorContext = 1` the
  run is **blocked** if any prior-week `Payroll_Calculated` row is older than its RawFMS source row
  or a prior-week eligible labor row has no calculation. The prior week is read-only context; only
  the requested week is recalculated and persisted. `RunId` is now carried on `Payroll_Calculated`
  and every ledger rebuild via `SESSION_CONTEXT('PayrollAPP_RunLogID')`.
- `api.usp_UI_RefreshPayroll_FromNexGen` delegates to new `api.usp_RefreshPayrollWeek_Core`;
  `api.usp_ResolveAuthoritativePayrollRun` picks the run a week's outputs come from.
- `cfg.Nightly_RunSettings` still `LookbackDays = 210` for the scheduled run.

### 6. Excel and rule-narrative layer (new)

`api.usp_Excel_RefreshEmployees`, `usp_Excel_RefreshPayrollWeek`, `usp_Excel_PayrollRunInfo`,
`usp_Excel_PayrollRecommendations` (104 KB) feed the *Payroll App Recommendations* block in the
weekly workbook; `v_UI_Payroll_LaborEntry_AppliedRuleDetail/Summary`,
`v_UI_Payroll_EmployeeDay_AppliedRuleSummary`, `…CalculationReviewDetail/Summary` generate the
*Applied Payroll Rules* and *Calculation / Review Notes* text (*"8-hour rest rule: 7.0h raised to DT;
rest premium $…"*, *"CA weekly overtime: …"*, *"Cross-midnight OT carryover: …"*, *"Guarantee
reconciliation: …"*). The literal vocabulary is a ready-made list of every rule the legacy engine
can name — see `sql/api/v_UI_Payroll_LaborEntry_AppliedRuleDetail.VIEW.sql`.

### Also changed

`v_UI_Payroll_PayComponent_Summary` (subsistence matched by `ComponentGroup`), `v_UI_LaborEntry_TypeRateResolution`,
`usp_Rebuild_PayComponentLedger_NonUnionAdminHourly_CA_NonExempt` (RunId), the two pricing-engine
test procs, and two `audit.*` backup tables the client now keeps for module definitions.

## What it means for the register

| Rule | Consequence |
| --- | --- |
| PAY-045 | Confirmed as written: ×1.5 floor, ×2.0 past 12 chain hours, chain grouped across gaps < 8 h, only the delta paid. The ERP should present forced hours **in the DT bucket** (this backup's whole point) while keeping the premium as its own component |
| PAY-047 | WTL deduct basis now reads rest-adjusted slice pay — order of operations: rest before WTL |
| PAY-012 | Non-union bucket source must be the CA classifier; never union day-type buckets |
| PAY-013 | Salary rows excluded before pricing; a regression test exists for it |
| PAY-018 | The assumed-shift fallback is **disabled in production** — missing times are exceptions, not priced |
| PAY-064 / PAY-002 | Run lineage on every output row; interactive recalculation is a whole Sat–Fri week with a fresh-prior-week guard — the client's own answer to the recalculation question of 2026-09-04 |

Restore method: `docker run mcr.microsoft.com/mssql/server:2025-latest` (the 2022 image refuses
database version 998), `RESTORE DATABASE … WITH MOVE`; definitions read from `sys.sql_modules`;
diffs after whitespace normalisation. Nothing that writes was executed. Employee identifiers masked.

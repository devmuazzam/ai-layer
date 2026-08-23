---
title: TCG Payroll App (legacy) - Testing and validation guide
source: onedrive/OneDrive_1_8-11-2026/PAYROLL_APP_build/PayrollAPP_0.5/TCG_PayrollAPP_AI_Knowledge_Pack_2026-06-23.zip#09_TESTING_AND_VALIDATION_GUIDE.md
migrated: 2026-08-13
updated: 2026-06-23
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app]
entities: [regression-test, smoke-test, payroll-calculation-run]
part_of: payroll/payroll-app-current-state/INDEX.md
---

## Purpose

This guide gives the vendor a repeatable way to validate the restored databases, API, Web UI, and SQL calculation outputs.

## Restore validation

Run after restoring both databases:

```sql
SELECT
    name,
    compatibility_level,
    collation_name,
    recovery_model_desc,
    containment_desc,
    state_desc,
    user_access_desc,
    is_read_committed_snapshot_on,
    is_auto_create_stats_on,
    is_auto_update_stats_on
FROM sys.databases
WHERE name IN ('TCG_RawFMS', 'TCG_PayrollAPP');
```

Expected:

| Database | Compatibility | Collation | Recovery |
|---|---:|---|---|
| `TCG_RawFMS` | 170 | `SQL_Latin1_General_CP1_CI_AS` | SIMPLE |
| `TCG_PayrollAPP` | 130 | `SQL_Latin1_General_CP1_CI_AS` | SIMPLE |

## Synonym validation

```sql
USE TCG_PayrollAPP;
GO

SELECT
    name AS SynonymName,
    base_object_name AS TargetObject
FROM sys.synonyms
ORDER BY name;
```

Critical examples:

```text
FMS_LABOR_PAYROLL_Raw -> [TCG_RawFMS].[api].[v_FMS_LABOR_PAYROLL]
FMS_EMPLOYEES_Raw -> [TCG_RawFMS].[api].[v_FMS_EMPLOYEES]
FMS_JOB_TICKET_Raw -> [TCG_RawFMS].[api].[v_FMS_JOB_TICKET]
FMS_UNION_CRAFT_Raw -> [TCG_RawFMS].[api].[v_FMS_UNION_CRAFT]
FMS_UNION_CRAFT_MODIFIER_Raw -> [TCG_RawFMS].[api].[v_FMS_UNION_CRAFT_MODIFIER]
```

If synonyms need refreshing:

```sql
USE TCG_PayrollAPP;
GO
EXEC etl.usp_RebuildSynonyms_RawFMS;
```

## SQL smoke checks

```sql
USE TCG_PayrollAPP;
GO

SELECT TOP 5 RunId, RunType, StartedAtUTC, EndedAtUTC, Status, ErrorMessage
FROM etl.RunLog
ORDER BY RunId DESC;

SELECT COUNT(*) AS PayrollCalculatedRows
FROM fms.Payroll_Calculated;

SELECT COUNT(*) AS PayComponentRows
FROM fms.Payroll_PayComponent;

SELECT COUNT(*) AS PayrollExceptionsRows
FROM fms.Payroll_CalcException;

SELECT TOP 20 *
FROM rpt.v_UI_Payroll_Issues_Summary_LatestRun
ORDER BY IssueCount DESC;
```

## Source access smoke check

```sql
USE TCG_PayrollAPP;
GO

SELECT TOP 10 *
FROM src.FMS_LABOR_PAYROLL_Raw;
```

## Web build validation

Run from:

```powershell
cd C:\TCG\TCG.PayrollWeb\payroll-ui
```

Commands:

```powershell
node -v
npm -v
npm install
npm run build
npm run dev
```

Observed source environment:

```text
Node.js: v24.14.0
npm: 11.9.0
Next.js: 16.1.6
Local: http://localhost:3000
```

Known warnings from current build:

- Multiple lockfiles detected; Next.js inferred workspace root from parent `package-lock.json`.
- `middleware` file convention deprecated; Next.js recommends `proxy` instead.
- `npm audit` reports vulnerabilities; review before production.

## UI smoke test

Open:

```text
http://localhost:3000/worklist/
```

Confirm:

- Worklist loads.
- Employees display.
- Payroll Group displays.
- ADP File Number displays.
- Issue counts display.
- Refresh button behavior is understood/controlled.

Open a known employee detail URL, adjusting host as needed:

```text
http://localhost:3000/worklist/employee/7288?anyDateInWeek=2026-06-10&lpid=86686
```

Confirm:

- Employee header loads.
- Daily summary loads.
- Labor entries load.
- Selected labor entry detail loads.
- Pay component ledger loads.
- WTL/rate/guarantee/rest/boom/ticket sections load as applicable.

## Regression test objects

Representative test areas:

| Test area | Representative objects |
|---|---|
| Core payroll scenarios | `test.Case_CorePayrollScenario`, `test.usp_Run_CorePayrollScenario_Baseline` |
| Pricing engine | `test.usp_RunAll_PricingEngine_Tests` |
| Daily OT/DT | `test.usp_Test_DailyOTDT_Split` |
| Holiday/special Saturday/Sunday | `test.usp_Test_Holiday_Min8`, `test.usp_Test_SpecialSaturday_Min8`, `test.usp_Test_SundayPremium_Bucket` |
| Rest period | `test.Case_RestPeriod`, `test.usp_Test_RestPeriod_Cases`, `test.usp_Test_RestPeriod_Punitive` |
| Cross-midnight | `test.Case_CrossMidnight_DayType`, `test.usp_Test_CrossMidnight_DayTypePolicy` |
| UI readiness | `test.usp_Run_LaborEntryUIDisplay_Readiness_Tests`, `test.usp_Run_BoomBreakdown_Tests`, `test.usp_Run_JobTicketStatus_Tests` |
| Checkpoint | `test.usp_RunAll_CurrentPayrollRegression_Checkpoint` |

## Manual recalculation warning

This recalculates current output tables:

```sql
USE TCG_PayrollAPP;
GO

EXEC etl.usp_RunNightly_PayrollAPP
    @RebuildAll = 1;
```

Only run when intentionally validating recalculation behavior.

## Recommended new tests

Add tests for:

- Payroll Group resolution.
- L12 Field vs L12 Mechanic behavior.
- Non-Union Admin Hourly CA nonexempt ST/OT/DT/weekly/7th-day components.
- Non-Union Admin Salary exempt review behavior.
- WTL not-applicable behavior for non-union rows.
- ADP File Number validation and duplicate errors.
- Ledger payable gross vs final gross vs WTL-aware gross.
- API response shape for selected labor-entry ledger and employee detail.

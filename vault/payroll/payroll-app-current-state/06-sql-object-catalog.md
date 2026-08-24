---
title: TCG Payroll App (legacy) - SQL object catalog
source: onedrive/OneDrive_1_8-11-2026/PAYROLL_APP_build/PayrollAPP_0.5/TCG_PayrollAPP_AI_Knowledge_Pack_2026-06-23.zip#08_SQL_OBJECT_CATALOG.md
migrated: 2026-08-13
updated: 2026-06-23
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app, architecture]
entities: [pricing-engine, pay-component, payroll-exception, guarantee]
part_of: payroll/payroll-app-current-state/INDEX.md
---

## Purpose

This catalog lists the highest-value SQL objects for vendor onboarding. It is not a full database schema export. Use actual SQL scripts/database definitions as the final source of truth.

## Core source objects

| Object | Role |
|---|---|
| `src.FMS_LABOR_PAYROLL_Raw` | Raw labor payroll rows from `TCG_RawFMS.api.v_FMS_LABOR_PAYROLL`. |
| `src.FMS_EMPLOYEES_Raw` | Employee master source. |
| `src.FMS_EMPLOYEE_TYPES_Raw` | Employee type lookup. |
| `src.FMS_JOB_TICKET_Raw` | Job ticket time/source fields. |
| `src.FMS_JOB_MASTER_Raw` | Job master context. |
| `src.FMS_UNION_CRAFT_Raw` | Craft base rates. |
| `src.FMS_UNION_CRAFT_MODIFIER_Raw` | Craft modifier/boom rate changes. |
| `src.FMS_CLASSIFICATIONS_Raw` | Labor/material/both classification. |
| `src.FMS_ACTIVITIES_Raw` | Activity lookup. |
| `src.FMS_UNITS_Raw` | Unit/equipment source. |

## Core base views

| Object | Role |
|---|---|
| `app.v_Base_LaborPayroll` | Main enriched source labor view. |
| `app.v_Base_Employees` | Employee master enrichment. |
| `app.v_LaborPayroll_CommentTokens` | Parses payroll comment tokens such as WTL, shift, and subsistence. |
| `api.v_UI_Employee_PayrollGroupRate` | Worklist-facing Payroll Group/rate view. |

## Main calculation procedures

| Object | Role |
|---|---|
| `etl.usp_RunNightly_PayrollAPP` | Main PayrollAPP refresh orchestration. |
| `api.usp_UI_RefreshPayroll_FromNexGen` | Browser-triggered RawFMS + PayrollAPP refresh. |
| `app.usp_Run_Pricing_Engine` | Main actual worked time pricing engine. |
| `app.usp_FinalizePayrollOutputs_AfterPricing` | Ordered post-pricing wrapper. |
| `app.usp_Apply_BasePay_Fallback_FromSource` | Controlled fallback after pricing. |
| `app.usp_Apply_GuaranteedHours` | Applies minimum/guaranteed hours. |
| `app.usp_Apply_RestPeriod_Premium` | Applies rest-period premium. |
| `app.usp_SuppressPay_WhenSourceRateMissing` | Suppresses pay when required source rate is missing. |
| `app.usp_Rebuild_PayComponentLedger` | Rebuilds component ledger from calculated output. |
| `app.usp_Apply_ShiftDifferentialHoursAdd` | Adds shift paid-hours components. |
| `app.usp_Apply_WTL_MealPeriods` | Applies WTL/meal-period components and issues. |
| `app.usp_Apply_SubsistencePay` | Adds token-driven subsistence components. |
| `app.usp_Normalize_PayComponentLedger_Rounding` | Rounds and balances component ledger. |
| `app.usp_ProcessPayroll_PayPeriod` | Processes/closes a pay period and writes snapshot. |

## Core persisted tables

| Object | Role |
|---|---|
| `fms.Payroll_Calculated` | Main current calculated output, one row per calculated labor entry. |
| `fms.Payroll_PayComponent` | Pay component ledger. |
| `fms.Payroll_CalcException` | Errors, warnings, review issues. |
| `fms.Labor_PreProcessed` | Preprocessed labor timeline/input. |
| `fms.Payroll_GuaranteeGroup` | Grouped guarantee/minimum pay decisions. |
| `fms.Payroll_GuaranteeAllocation` | Allocated guarantee pay per labor entry. |
| `calc.TicketTimeline` | Cached ticket shift/boom windows. |
| `app.PayPeriod` | Pay-period records. |
| `app.PayrollSnapshot` | Pay-period snapshot header. |
| `app.PayrollSnapshot_Detail` | Frozen detail rows for processed periods. |
| `app.EmployeeExternalIdentifier` | External identifiers such as ADP File Number. |

## Rule/config tables

| Object | Role |
|---|---|
| `cfg.Union_Master_Rules` | L12 rule thresholds/multipliers. |
| `cfg.Union_Shift_Rules` | Shift premiums/paid-hours settings. |
| `cfg.Craft_MinimumPayPolicy` | Craft-level minimum-pay applicability. |
| `cfg.GuaranteedHoursRule` | Guaranteed/minimum hour rule definitions. |
| `cfg.RestPeriod_Rule` | Rest premium settings. |
| `cfg.WTL_Rule` | WTL rule settings. |
| `cfg.WTL_MaxMealThreshold` | Expected modeled meal thresholds. |
| `cfg.Nightly_RunSettings` | Nightly lookback and run settings. |
| `cfg.LaborType_TicketPolicy` | Ticket expectations by labor type/atom labor. |
| `dim.LU12_Holiday` | Local 12 holiday/special calendar. |
| `dim.Date` | Date/calendar dimension. |

## API/reporting surfaces

| Object | Role |
|---|---|
| `api.tvf_UI_Payroll_Worklist_ForPayPeriodDate` | Main worklist source. |
| `api.tvf_UI_Payroll_EmployeeDayTotals_ForDateRange` | Employee/day totals. |
| `api.tvf_EmployeeWeekDailySummary` | Employee week/day summary. |
| `api.v_Payroll_LaborEntry_WeekDetail` | Employee detail labor entries. |
| `api.v_UI_Pricing_Slices` | Slice detail. |
| `api.v_UI_Pricing_Slices_Advanced` | Deep slice/rate detail. |
| `api.usp_UI_Payroll_LaborEntry_Ledger` | Selected labor-entry ledger result sets. |
| `api.v_UI_WTL_LaborEntry_Status` | WTL status per labor entry. |
| `api.v_UI_LaborEntry_RateResolution` | Rate-resolution details. |
| `api.v_UI_LaborEntry_BoomBreakdown` | Boom breakdown. |
| `api.v_UI_LaborEntry_JobTicketStatus` | Job-ticket status. |
| `rpt.v_UI_Payroll_Issues_Summary_LatestRun` | Issue summary. |
| `rpt.v_UI_Payroll_Issues_Enriched_LatestRun` | Detailed issue view. |

## Recommended SQL script exports for vendor

Export these categories as `.sql` files:

```text
schemas/
tables/
views/
stored_procedures/
functions/
indexes_constraints/
configuration_data/
test_cases/
```

Also export selected configuration data as CSV/JSON for AI ingestion:

- `cfg.Union_Master_Rules`
- `cfg.Union_Shift_Rules`
- `cfg.Craft_MinimumPayPolicy`
- `cfg.GuaranteedHoursRule`
- `cfg.RestPeriod_Rule`
- `cfg.WTL_Rule`
- `cfg.WTL_MaxMealThreshold`
- `cfg.LaborType_TicketPolicy`
- `dim.LU12_Holiday`

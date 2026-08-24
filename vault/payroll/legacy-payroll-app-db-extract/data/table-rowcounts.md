---
title: Legacy Payroll App - row counts for all 38 tables
source: user-supplied/PAYROLL_CALC_EXTRACT.zip (generated 2026-08-18 on the client machine from TCG_PayrollAPP + c:/projects/tcg-payroll-api)
migrated: 2026-08-18
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app, reference-data]
entities: [pay-component, craft-modifier]
part_of: payroll/legacy-payroll-app-db-extract/INDEX.md
---

> Part of the 2026-08-18 read-only extract of the live legacy database `TCG_PayrollAPP`
> (`localhost\SQLEXPRESS`, SQL Server 2025 Express). Line anchors like `sql\app\x.PROC.sql:12-20`
> refer to the verbatim definitions in [sql/](sql/) (backslashes → forward slashes). Employee
> identifiers are masked `E***NN`. Nothing that writes was executed to produce this.

# Table Row Counts (sys.dm_db_partition_stats)

| schema | table | rows |
|---|---|---:|
| app | _Backup_51K_Payroll_Calculated_PreSourceRateOnly | 83854 |
| app | EmployeeExternalIdentifier | 108 |
| app | LaborBreakOverride | 0 |
| app | PayPeriod | 38 |
| app | PayrollNote_EmployeeDay | 3 |
| app | PayrollNote_EmployeePayPeriod | 3 |
| app | PayrollNote_PayPeriod | 3 |
| app | PayrollSnapshot | 5 |
| app | PayrollSnapshot_Detail | 1713 |
| app | StoredProcedureDefinitionBackup | 4 |
| calc | TicketTimeline | 28799 |
| cfg | Craft_MinimumPayPolicy | 39 |
| cfg | CrossMidnightDayTypePolicy | 2 |
| cfg | GuaranteedHoursRule | 4 |
| cfg | LaborType_TicketPolicy | 6 |
| cfg | Nightly_RunSettings | 1 |
| cfg | PayrollUI_ExcludedEmpID | 2 |
| cfg | RestPeriod_Rule | 1 |
| cfg | Union_Master_Rules | 1 |
| cfg | Union_Shift_Rules | 3 |
| cfg | WTL_MaxMealThreshold | 5 |
| cfg | WTL_Rule | 1 |
| dim | Date | 7671 |
| dim | LU12_Holiday | 44 |
| etl | RunLog | 607 |
| etl | RunLogDetail | 921 |
| etl | UIRefreshLog | 34 |
| fms | Labor_PreProcessed | 58059 |
| fms | Payroll_CalcException | 508327 |
| fms | Payroll_Calculated | 86441 |
| fms | Payroll_GuaranteeAllocation | 4758 |
| fms | Payroll_GuaranteeGroup | 4758 |
| fms | Payroll_PayComponent | 136794 |
| test | Case_CorePayrollScenario | 16 |
| test | Case_CrossMidnight_DayType | 10 |
| test | Case_RestPeriod | 1 |
| test | Case_TimeSourceConsistency | 6 |
| test | ObjectDefinitionBackup | 13 |

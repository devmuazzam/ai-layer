---
title: Legacy Payroll App - one row per programmable object (141) plus the 40 src synonyms
source: user-supplied/PAYROLL_CALC_EXTRACT.zip (generated 2026-08-18 on the client machine from TCG_PayrollAPP + c:/projects/tcg-payroll-api)
migrated: 2026-08-18
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app, architecture]
entities: [sql-object]
part_of: payroll/legacy-payroll-app-db-extract/INDEX.md
---

> Part of the 2026-08-18 read-only extract of the live legacy database `TCG_PayrollAPP`
> (`localhost\SQLEXPRESS`, SQL Server 2025 Express). Line anchors like `sql\app\x.PROC.sql:12-20`
> refer to the verbatim definitions in [sql/](sql/) (backslashes → forward slashes). Employee
> identifiers are masked `E***NN`. Nothing that writes was executed to produce this.

# sql/ Object Index

Generated from live TCG_PayrollAPP on localhost\SQLEXPRESS. One file per programmable object under sql/<schema>\<name>.<type>.sql.

**Counts:** TVF=10, PROC=61, VIEW=67, FN=3, SYNONYM=40

| schema | object | type | lines | referenced entities (reads/writes) |
|---|---|---|---:|---|
| api | tvf_Employees_Active_FieldOnly_ForPayPeriodDate | TVF | 34 | api.tvf_Employees_ActiveInRange, app.fn_PayPeriodStart_SatFri, cfg.PayrollUI_ExcludedEmpID |
| api | tvf_Employees_ActiveButNoLabor | TVF | 41 | api.tvf_Employees_ActiveInRange, app.v_Base_LaborPayroll |
| api | tvf_Employees_ActiveButNoLabor_FieldOnly | TVF | 57 | api.tvf_Employees_ActiveInRange, app.v_Base_LaborPayroll, cfg.PayrollUI_ExcludedEmpID |
| api | tvf_Employees_ActiveButNoLabor_FieldOnly_ForPayPeriodDate | TVF | 22 | api.tvf_Employees_ActiveButNoLabor_FieldOnly, app.fn_PayPeriodStart_SatFri |
| api | tvf_Employees_ActiveButNoLabor_ForPayPeriodDate | TVF | 22 | api.tvf_Employees_ActiveButNoLabor, app.fn_PayPeriodStart_SatFri |
| api | tvf_Employees_ActiveInPayPeriodForDate | TVF | 22 | api.tvf_Employees_ActiveInRange, app.fn_PayPeriodStart_SatFri |
| api | tvf_Employees_ActiveInRange | TVF | 31 | app.v_Base_Employees |
| api | tvf_EmployeeWeekDailySummary | TVF | 210 | api.v_UI_Payroll_LaborEntry_Ledger_Summary, rpt.v_Payroll_LaborEntry_WeekDetail |
| api | tvf_UI_Payroll_EmployeeDayTotals_ForDateRange | TVF | 110 | api.v_Pricing_LaborPayroll_RateHealth, api.v_UI_Payroll_LaborEntry_Ledger_Summary, app.v_Base_LaborPayroll, dim.LU12_Holiday, fms.Payroll_Calculated |
| api | tvf_UI_Payroll_Worklist_ForPayPeriodDate | TVF | 442 | api.v_Payroll_Exceptions_LatestPricingRun, api.v_Payroll_LaborEntry_WeekDetail, api.v_PayrollNotes_EmployeeDay, api.v_PayrollNotes_EmployeePayPeriod, api.v_PayrollNotes_PayPeriod, app.fn_PayPeriodStart_SatFri, app.PayPeriod, app.v_Base_Employees, cfg.PayrollUI_ExcludedEmpID |
| api | usp_EnsurePayPeriod_ForDate | PROC | 25 | app.PayPeriod, app.usp_UpsertPayPeriod_ForDate |
| api | usp_Get_LaborEntry_AuditPacket | PROC | 115 | api.v_Calc_Pricing_Detailed, api.v_LaborEntry_AuditHeader, api.v_UI_Pricing_Slices, api.v_UI_Pricing_Slices_Advanced, calc.v_Calc_Pricing_Master_Audit |
| api | usp_Prepare_Continuous_Labor | PROC | 12 | app.usp_Prepare_Continuous_Labor |
| api | usp_Run_Pricing_Engine | PROC | 9 | app.usp_Run_Pricing_Engine |
| api | usp_UI_Payroll_EmployeeWeek_Guarantees | PROC | 127 | api.v_UI_GuaranteeAllocations, api.v_UI_GuaranteeGroups, app.fn_PayPeriodStart_SatFri |
| api | usp_UI_Payroll_LaborEntry_Ledger | PROC | 243 | api.v_UI_Payroll_LaborEntry_Ledger_Summary, app.v_LaborPayroll_CommentTokens, fms.Payroll_CalcException, fms.Payroll_PayComponent |
| api | usp_UI_RefreshPayroll_FromNexGen | PROC | 287 | app.PayPeriod, etl.RunLog, etl.UIRefreshLog, etl.usp_RunNightly_PayrollAPP, etl.usp_RunNightly_RawFMS |
| api | usp_UI_RestPeriod_SliceDetail | PROC | 98 | app.fn_PayPeriodStart_SatFri, app.usp_Prototype_RestPeriod_SliceChain |
| api | usp_UI_SaveEmployeeExternalIdentifier | PROC | 176 | app.EmployeeExternalIdentifier, src.FMS_EMPLOYEES_Raw |
| api | v_Calc_Pricing_Detailed | VIEW | 4 | calc.v_Calc_Pricing_Detailed_API |
| api | v_Calc_Pricing_Master_Audit | VIEW | 6 | calc.v_Calc_Pricing_Master_Audit |
| api | v_Calc_Pricing_Slices | VIEW | 6 | calc.v_Calc_Pricing_Slices_API |
| api | v_Labor_PreProcessed | VIEW | 6 | fms.Labor_PreProcessed |
| api | v_LaborEntry_AuditHeader | VIEW | 6 | audit.v_LaborEntry_AuditHeader |
| api | v_LaborPayroll_BreakReview | VIEW | 61 | app.fn_StripRTF, app.LaborBreakOverride, app.v_Base_LaborPayroll, src.FMS_LABOR_PAYROLL_Raw |
| api | v_Payroll_Calculated | VIEW | 7 | fms.Payroll_Calculated |
| api | v_Payroll_Exceptions_LatestPricingRun | VIEW | 14 | etl.RunLog, rpt.v_UI_Payroll_Exceptions |
| api | v_Payroll_Exceptions_LatestRun | VIEW | 5 | rpt.v_UI_Payroll_Exceptions_LatestRun |
| api | v_Payroll_Exceptions_Summary_LatestPricingRun | VIEW | 19 | etl.RunLog, rpt.v_UI_Payroll_Exceptions |
| api | v_Payroll_LaborEntry_WeekDetail | VIEW | 70 | api.v_UI_LaborEntry_BoomBreakdown, api.v_UI_LaborEntry_JobTicketStatus, rpt.v_Payroll_LaborEntry_WeekDetail |
| api | v_PayrollNotes_EmployeeDay | VIEW | 27 | app.PayPeriod, app.PayrollNote_EmployeeDay |
| api | v_PayrollNotes_EmployeePayPeriod | VIEW | 26 | app.PayPeriod, app.PayrollNote_EmployeePayPeriod |
| api | v_PayrollNotes_PayPeriod | VIEW | 31 | app.PayPeriod, app.PayrollNote_PayPeriod |
| api | v_Pricing_Detailed_UI | VIEW | 21 | api.v_Payroll_Calculated |
| api | v_Pricing_LaborPayroll_RateHealth | VIEW | 14 | api.v_UI_Pricing_Slices_Advanced |
| api | v_PricingEngine_Run_Latest | VIEW | 8 | etl.RunLog |
| api | v_UI_Employee_PayrollGroupRate | VIEW | 220 | api.v_UI_Employee_TypeRate |
| api | v_UI_Employee_TypeRate | VIEW | 189 | app.EmployeeExternalIdentifier, src.FMS_CRAFTS_Raw, src.FMS_EMPLOYEE_TYPES_Raw, src.FMS_EMPLOYEES_Raw, src.FMS_UNION_CRAFT_Raw |
| api | v_UI_GuaranteeAllocations | VIEW | 39 | fms.Payroll_Calculated, fms.Payroll_GuaranteeAllocation, fms.Payroll_GuaranteeGroup |
| api | v_UI_GuaranteeGroups | VIEW | 27 | fms.Payroll_GuaranteeGroup |
| api | v_UI_LaborEntry_BoomBreakdown | VIEW | 243 | api.v_UI_Pricing_Slices_Advanced, app.v_Base_LaborPayroll, calc.TicketTimeline, fms.Payroll_Calculated |
| api | v_UI_LaborEntry_JobTicketStatus | VIEW | 193 | app.v_Base_LaborPayroll, app.v_JobTicket_Status_Enriched, cfg.LaborType_TicketPolicy |
| api | v_UI_LaborEntry_RateResolution | VIEW | 151 | app.v_Base_LaborPayroll, fms.Payroll_Calculated |
| api | v_UI_LaborEntry_RateSourceReview | VIEW | 297 | app.v_Base_LaborPayroll, fms.Payroll_Calculated, src.FMS_EMPLOYEES_Raw |
| api | v_UI_LaborEntry_TypeRateResolution | VIEW | 248 | app.v_Base_LaborPayroll, src.FMS_CRAFTS_Raw, src.FMS_EMPLOYEE_TYPES_Raw, src.FMS_EMPLOYEES_Raw, src.FMS_UNION_CRAFT_Raw |
| api | v_UI_Payroll_LaborEntry_HourBuckets | VIEW | 370 | api.v_UI_Pricing_Slices_Advanced, fms.Payroll_Calculated, fms.Payroll_PayComponent |
| api | v_UI_Payroll_LaborEntry_Ledger_Detail | VIEW | 95 | api.v_UI_WTL_LaborEntry_Status, fms.Payroll_PayComponent |
| api | v_UI_Payroll_LaborEntry_Ledger_Summary | VIEW | 247 | api.v_UI_WTL_LaborEntry_Status, fms.Payroll_Calculated, fms.Payroll_PayComponent |
| api | v_UI_Payroll_LaborEntry_WeekDetail_WithBuckets | VIEW | 75 | api.v_Payroll_LaborEntry_WeekDetail, api.v_UI_LaborEntry_TypeRateResolution, api.v_UI_Payroll_LaborEntry_HourBuckets |
| api | v_UI_Payroll_PayComponent_Detail | VIEW | 62 | fms.Payroll_PayComponent |
| api | v_UI_Payroll_PayComponent_EmployeeDaySummary | VIEW | 88 | api.v_UI_Payroll_PayComponent_Summary |
| api | v_UI_Payroll_PayComponent_Summary | VIEW | 236 | fms.Payroll_Calculated, fms.Payroll_PayComponent |
| api | v_UI_Payroll_RateResolution_Issues | VIEW | 114 | api.v_UI_LaborEntry_RateSourceReview |
| api | v_UI_Pricing_Slices | VIEW | 62 | api.v_Calc_Pricing_Slices |
| api | v_UI_Pricing_Slices_Advanced | VIEW | 32 | api.v_Calc_Pricing_Slices |
| api | v_UI_WTL_Component_Detail | VIEW | 17 | fms.Payroll_PayComponent |
| api | v_UI_WTL_EmployeeDay_Summary | VIEW | 53 | api.v_UI_WTL_LaborEntry_Status |
| api | v_UI_WTL_Exceptions_LatestRun | VIEW | 34 | fms.Payroll_CalcException |
| api | v_UI_WTL_LaborEntry_Status | VIEW | 114 | api.v_UI_WTL_Exceptions_LatestRun, app.v_LaborPayroll_CommentTokens, fms.Payroll_Calculated, fms.Payroll_PayComponent |
| api | v_WhoAmI | VIEW | 10 |  |
| app | fn_PayPeriodStart_SatFri | FN | 11 |  |
| app | fn_RoundMoney | FN | 12 |  |
| app | fn_StripRTF | FN | 425 |  |
| app | usp_Apply_BasePay_Fallback_FromSource | PROC | 79 | app.v_Base_LaborPayroll, fms.Payroll_Calculated |
| app | usp_Apply_CA_NonUnionAdminHourly_OT | PROC | 889 | api.v_UI_Employee_PayrollGroupRate, app.v_Base_LaborPayroll, fms.Payroll_Calculated, pc |
| app | usp_Apply_GuaranteedHours | PROC | 1065 | api.v_UI_Pricing_Slices_Advanced, app.v_Base_LaborPayroll, calc.v_Calc_Labor_Timeline, cfg.Craft_MinimumPayPolicy, cfg.GuaranteedHoursRule, dim.LU12_Holiday, fms.Payroll_Calculated, fms.Payroll_GuaranteeAllocation, fms.Payroll_GuaranteeGroup |
| app | usp_Apply_RestPeriod_Premium | PROC | 697 | api.v_UI_Pricing_Slices_Advanced, c, calc.v_Calc_Labor_Timeline, cc, cfg.RestPeriod_Rule, e, fms.Payroll_Calculated, pc |
| app | usp_Apply_ShiftDifferentialHoursAdd | PROC | 351 | api.v_UI_Pricing_Slices_Advanced, app.v_LaborPayroll_CommentTokens, fms.Payroll_Calculated, fms.Payroll_PayComponent, p, pc |
| app | usp_Apply_SubsistencePay | PROC | 209 | app.v_LaborPayroll_CommentTokens, fms.Payroll_Calculated, fms.Payroll_PayComponent |
| app | usp_Apply_WTL_MealPeriods | PROC | 1225 | api.v_UI_Pricing_Slices_Advanced, app.v_LaborPayroll_CommentTokens, cfg.WTL_MaxMealThreshold, cfg.WTL_Rule, fms.Labor_PreProcessed, fms.Payroll_CalcException, fms.Payroll_Calculated, fms.Payroll_PayComponent, gs |
| app | usp_Clear_LaborBreakOverride | PROC | 11 | app.LaborBreakOverride |
| app | usp_Diagnose_WTL_ReviewGroups | PROC | 727 | api.v_UI_Pricing_Slices_Advanced, app.v_LaborPayroll_CommentTokens, cfg.WTL_MaxMealThreshold, cfg.WTL_Rule, fms.Labor_PreProcessed, gs |
| app | usp_Finalize_PayComponentLedger_Reconciliation | PROC | 337 | fms.Payroll_Calculated, fms.Payroll_PayComponent |
| app | usp_FinalizePayrollOutputs_AfterPricing | PROC | 184 | app.usp_Apply_BasePay_Fallback_FromSource, app.usp_Apply_CA_NonUnionAdminHourly_OT, app.usp_Apply_GuaranteedHours, app.usp_Apply_RestPeriod_Premium, app.usp_Apply_ShiftDifferentialHoursAdd, app.usp_Apply_SubsistencePay, app.usp_Apply_WTL_MealPeriods, app.usp_Finalize_PayComponentLedger_Reconciliation, app.usp_Normalize_PayComponentLedger_Rounding, app.usp_Rebuild_PayComponentLedger, app.usp_Rebuild_PayComponentLedger_NonUnionAdminHourly_CA_NonExempt, app.usp_SuppressPay_WhenSourceRateMissing |
| app | usp_Normalize_PayComponentLedger_Rounding | PROC | 219 | app.fn_RoundMoney, fms.Payroll_Calculated, fms.Payroll_PayComponent |
| app | usp_Prepare_Continuous_Labor | PROC | 289 | fms.Labor_PreProcessed, src.FMS_LABOR_PAYROLL_Raw |
| app | usp_Preview_CA_NonUnionAdminHourly_OT | PROC | 444 | api.v_UI_Employee_PayrollGroupRate, app.v_Base_LaborPayroll, fms.Payroll_Calculated |
| app | usp_Preview_CA_NonUnionAdminHourly_OT_LaborRow | PROC | 763 | api.v_UI_Employee_PayrollGroupRate, app.v_Base_LaborPayroll, fms.Payroll_Calculated |
| app | usp_Preview_WTL_PayComponents | PROC | 882 | api.v_UI_Pricing_Slices_Advanced, app.v_LaborPayroll_CommentTokens, cfg.WTL_MaxMealThreshold, cfg.WTL_Rule, fms.Labor_PreProcessed, gs |
| app | usp_ProcessPayroll_PayPeriod | PROC | 81 | app.PayPeriod, app.PayrollSnapshot, app.PayrollSnapshot_Detail, app.usp_FinalizePayrollOutputs_AfterPricing, app.usp_Run_Pricing_Engine, fms.Payroll_Calculated |
| app | usp_Prototype_RestPeriod_SliceChain | PROC | 789 | api.v_UI_Pricing_Slices_Advanced, c, calc.v_Calc_Labor_Timeline, cc, cfg.RestPeriod_Rule, e, fms.Payroll_Calculated |
| app | usp_Rebuild_PayComponentLedger | PROC | 622 | api.v_UI_Pricing_Slices_Advanced, fms.Payroll_Calculated, fms.Payroll_GuaranteeAllocation, fms.Payroll_GuaranteeGroup, fms.Payroll_PayComponent |
| app | usp_Rebuild_PayComponentLedger_NonUnionAdminHourly_CA_NonExempt | PROC | 610 | api.v_UI_Employee_PayrollGroupRate, app.v_Base_LaborPayroll, fms.Payroll_Calculated, fms.Payroll_PayComponent, pc |
| app | usp_Report_RestPeriod_SliceChain_Impact | PROC | 153 | app.usp_Prototype_RestPeriod_SliceChain |
| app | usp_Run_Pricing_Engine | PROC | 1477 | app.v_Base_LaborPayroll, app.v_LaborPayroll_CommentTokens, calc.JobTicketIDList, calc.TicketTimeline, calc.usp_Apply_TicketWindows_FromJobTicketTimes, calc.usp_Upsert_TicketTimeline_ForTicketIDList, calc.v_Calc_Labor_Timeline, cfg.Craft_MinimumPayPolicy, cfg.Union_Master_Rules, cfg.Union_Shift_Rules, dim.LU12_Holiday, e, etl.RunLog, fms.Payroll_CalcException, fms.Payroll_Calculated, lp, rpt.v_UI_Payroll_Reconstruction_Audit |
| app | usp_SaveNote_EmployeeDay | PROC | 34 | app.PayPeriod, app.PayrollNote_EmployeeDay |
| app | usp_SaveNote_EmployeePayPeriod | PROC | 33 | app.PayPeriod, app.PayrollNote_EmployeePayPeriod |
| app | usp_SaveNote_PayPeriod | PROC | 39 | app.PayPeriod, app.PayrollNote_PayPeriod |
| app | usp_Set_LaborBreakOverride | PROC | 36 | app.LaborBreakOverride |
| app | usp_SuppressPay_WhenSourceRateMissing | PROC | 47 | app.v_Base_LaborPayroll, fms.Payroll_Calculated |
| app | usp_UpsertPayPeriod_ForDate | PROC | 23 | app.fn_PayPeriodStart_SatFri, app.PayPeriod |
| app | v_Base_Employees | VIEW | 110 | src.FMS_CLASSIFICATIONS_Raw, src.FMS_CRAFTS_Raw, src.FMS_EMPLOYEE_TYPES_Raw, src.FMS_EMPLOYEES_Raw, src.FMS_ETHNICITY_Raw |
| app | v_Base_LaborPayroll | VIEW | 144 | src.FMS_ACTIVITIES_Raw, src.FMS_CLASSIFICATIONS_Raw, src.FMS_CRAFT_MODIFIER_Raw, src.FMS_CRAFTS_Raw, src.FMS_EMPLOYEES_Raw, src.FMS_LABOR_PAYROLL_Raw, src.FMS_SCHEDULE_TYPES_Raw, src.FMS_UNION_CRAFT_MODIFIER_Raw, src.FMS_UNION_CRAFT_Raw, src.FMS_UNIT_TYPES_Raw, src.FMS_UNITS_Raw |
| app | v_JobTicket_Status_Enriched | VIEW | 282 | src.FMS_JOB_TICKET_Raw, src.FMS_TICKET_STATUS_Raw |
| app | v_LaborPayroll_CommentTokens | VIEW | 303 | app.fn_StripRTF, src.FMS_LABOR_PAYROLL_Raw |
| audit | v_LaborEntry_AuditHeader | VIEW | 47 | calc.TicketTimeline, fms.Payroll_Calculated |
| calc | usp_Apply_TicketWindows_FromJobTicketTimes | PROC | 149 | calc.JobTicketIDList, calc.TicketTimeline, calc.v_JobTicket_Times |
| calc | usp_Upsert_TicketTimeline_ForTicketIDList | PROC | 136 | calc.JobTicketIDList, calc.TicketTimeline, src.FMS_JOB_TICKET_Raw, TT |
| calc | v_Calc_Labor_Timeline | VIEW | 164 | fms.Labor_PreProcessed |
| calc | v_Calc_Pricing_Detailed_API | VIEW | 39 | calc.v_Calc_Pricing_Slices_API |
| calc | v_Calc_Pricing_Master_Audit | VIEW | 82 | dim.LU12_Holiday, fms.Payroll_Calculated |
| calc | v_Calc_Pricing_Slices_API | VIEW | 174 | app.v_Base_LaborPayroll, calc.v_Calc_Pricing_Slices_API_Legacy_Pre51K |
| calc | v_Calc_Pricing_Slices_API_Legacy_Pre51K | VIEW | 292 | app.v_Base_LaborPayroll, app.v_LaborPayroll_CommentTokens, calc.v_Calc_Labor_Timeline, calc.v_Calc_Ticket_Timeline_Fast, cfg.Union_Master_Rules, cfg.Union_Shift_Rules, dim.LU12_Holiday |
| calc | v_Calc_Ticket_Timeline_Fast | VIEW | 10 | calc.TicketTimeline |
| calc | v_JobTicket_Times | VIEW | 21 | stg.FMS_JOB_TICKET_Raw |
| etl | usp_RebuildSynonyms_RawFMS | PROC | 124 |  |
| etl | usp_RunNightly_PayrollAPP | PROC | 312 | app.usp_FinalizePayrollOutputs_AfterPricing, app.usp_Prepare_Continuous_Labor, app.usp_Run_Pricing_Engine, app.v_Base_LaborPayroll, cfg.Nightly_RunSettings, etl.RunLog, etl.RunLogDetail, etl.usp_RebuildSynonyms_RawFMS, fms.Labor_PreProcessed, fms.Payroll_Calculated, fms.Payroll_GuaranteeAllocation, fms.Payroll_GuaranteeGroup, fms.Payroll_PayComponent |
| rpt | v_Payroll_LaborEntry_WeekDetail | VIEW | 299 | api.v_Payroll_Exceptions_LatestPricingRun, app.v_Base_LaborPayroll, calc.v_Calc_Pricing_Master_Audit, calc.v_JobTicket_Times, fms.Payroll_Calculated |
| rpt | v_UI_Employees_FieldOnly_NoLabor_Count_CurrentPayPeriod | VIEW | 16 | api.tvf_Employees_ActiveButNoLabor_FieldOnly, app.fn_PayPeriodStart_SatFri |
| rpt | v_UI_Payroll_Audit | VIEW | 37 | calc.v_Calc_Labor_Timeline, fms.Payroll_Calculated |
| rpt | v_UI_Payroll_Exceptions | VIEW | 36 | app.v_Base_LaborPayroll, cfg.LaborType_TicketPolicy, fms.Payroll_CalcException |
| rpt | v_UI_Payroll_Exceptions_LatestRun | VIEW | 14 | fms.Payroll_CalcException, rpt.v_UI_Payroll_Exceptions |
| rpt | v_UI_Payroll_Issues | VIEW | 23 | fms.Payroll_CalcException |
| rpt | v_UI_Payroll_Issues_Enriched | VIEW | 39 | calc.v_Calc_Labor_Timeline, fms.Payroll_CalcException, rpt.v_UI_Payroll_Issues |
| rpt | v_UI_Payroll_Issues_Enriched_LatestRun | VIEW | 13 | fms.Payroll_CalcException, rpt.v_UI_Payroll_Issues_Enriched |
| rpt | v_UI_Payroll_Issues_LatestRun | VIEW | 12 | fms.Payroll_CalcException, rpt.v_UI_Payroll_Issues |
| rpt | v_UI_Payroll_Issues_SeverityTotals_LatestRun | VIEW | 18 | fms.Payroll_CalcException, rpt.v_UI_Payroll_Issues |
| rpt | v_UI_Payroll_Issues_Summary_LatestRun | VIEW | 21 | fms.Payroll_CalcException, rpt.v_UI_Payroll_Issues |
| rpt | v_UI_Payroll_Reconstruction_Audit | VIEW | 248 | app.v_Base_LaborPayroll, calc.TicketTimeline, calc.v_Calc_Labor_Timeline, fms.Payroll_Calculated |
| rpt | v_UI_RestPeriod_Overlap_LatestRun | VIEW | 6 | rpt.v_UI_Payroll_Issues_Enriched_LatestRun |
| test | usp_Get_CorePayrollScenario_AuditPacket | PROC | 423 | api.v_UI_GuaranteeAllocations, api.v_UI_GuaranteeGroups, api.v_UI_Pricing_Slices_Advanced, app.v_Base_LaborPayroll, calc.TicketTimeline, calc.v_Calc_Labor_Timeline, fms.Payroll_CalcException, fms.Payroll_Calculated, test.Case_CorePayrollScenario |
| test | usp_Run_BoomBreakdown_Tests | PROC | 239 | api.v_UI_GuaranteeAllocations, api.v_UI_LaborEntry_BoomBreakdown, test.Case_CorePayrollScenario |
| test | usp_Run_CorePayrollScenario_Baseline | PROC | 440 | api.v_UI_GuaranteeAllocations, fms.Payroll_CalcException, fms.Payroll_Calculated, test.Case_CorePayrollScenario |
| test | usp_Run_JobTicketStatus_Tests | PROC | 508 | api.v_UI_LaborEntry_JobTicketStatus, app.v_JobTicket_Status_Enriched, test.Case_CorePayrollScenario |
| test | usp_Run_LaborEntryUIDisplay_Readiness_Tests | PROC | 297 | api.v_Payroll_LaborEntry_WeekDetail, api.v_UI_LaborEntry_BoomBreakdown, test.Case_CorePayrollScenario |
| test | usp_Run_SliceViewAlignment_Tests | PROC | 127 | api.v_UI_Pricing_Slices_Advanced, fms.Payroll_Calculated, test.Case_CorePayrollScenario |
| test | usp_Run_TimeSourceConsistency_Tests | PROC | 289 | api.v_UI_Pricing_Slices_Advanced, calc.TicketTimeline, calc.v_Calc_Labor_Timeline, fms.Payroll_Calculated, test.Case_TimeSourceConsistency |
| test | usp_RunAll_CorePayroll_Tests | PROC | 22 | test.usp_Test_CrossMidnight_DayTypePolicy, test.usp_Test_DailyOTDT_Split, test.usp_Test_Holiday_Min8, test.usp_Test_RestPeriod_Cases, test.usp_Test_SpecialSaturday_Min8, test.usp_Test_SundayPremium_Bucket |
| test | usp_RunAll_CurrentPayrollRegression_Checkpoint | PROC | 39 | test.usp_Run_BoomBreakdown_Tests, test.usp_Run_CorePayrollScenario_Baseline, test.usp_Run_JobTicketStatus_Tests, test.usp_Run_LaborEntryUIDisplay_Readiness_Tests, test.usp_Run_SliceViewAlignment_Tests, test.usp_Run_TimeSourceConsistency_Tests |
| test | usp_RunAll_PricingEngine_Tests | PROC | 13 | test.usp_Test_PricingEngine_HoursOnly, test.usp_Test_PricingEngine_TicketedDay |
| test | usp_Test_CrossMidnight_DayTypePolicy | PROC | 50 | cfg.CrossMidnightDayTypePolicy, test.v_CrossMidnight_DayType_Actual |
| test | usp_Test_DailyOTDT_Split | PROC | 86 | fms.Payroll_Calculated, test.Case_CorePayrollScenario |
| test | usp_Test_Holiday_Min8 | PROC | 121 | api.v_UI_GuaranteeAllocations, api.v_UI_GuaranteeGroups, dim.LU12_Holiday, fms.Payroll_Calculated |
| test | usp_Test_PricingEngine_HoursOnly | PROC | 65 | app.usp_Run_Pricing_Engine, app.v_Base_LaborPayroll, etl.RunLog, fms.Payroll_CalcException |
| test | usp_Test_PricingEngine_TicketedDay | PROC | 65 | app.usp_Run_Pricing_Engine, app.v_Base_LaborPayroll, calc.TicketTimeline, etl.RunLog, fms.Payroll_CalcException |
| test | usp_Test_RestPeriod_Cases | PROC | 44 | calc.v_Calc_Labor_Timeline, test.Case_RestPeriod |
| test | usp_Test_RestPeriod_Punitive | PROC | 103 | app.usp_Prototype_RestPeriod_SliceChain, fms.Payroll_Calculated |
| test | usp_Test_RestPeriod_SliceChain_Prototype | PROC | 135 | app.usp_Prototype_RestPeriod_SliceChain |
| test | usp_Test_SpecialSaturday_Min8 | PROC | 121 | api.v_UI_GuaranteeAllocations, api.v_UI_GuaranteeGroups, dim.LU12_Holiday, fms.Payroll_Calculated |
| test | usp_Test_SundayPremium_Bucket | PROC | 41 | fms.Payroll_Calculated |
| test | v_CrossMidnight_DayType_Actual | VIEW | 64 | cfg.CrossMidnightDayTypePolicy, test.Case_CrossMidnight_DayType |

## Synonyms (sys.synonyms -> base object)

| synonym | base_object_name |
|---|---|
| FMS_ACTIVITIES_Raw | [TCG_RawFMS].[api].[v_FMS_ACTIVITIES] |
| FMS_CHECK_LIST_DETAILS_Raw | [TCG_RawFMS].[api].[v_FMS_CHECK_LIST_DETAILS] |
| FMS_CHECK_LIST_Raw | [TCG_RawFMS].[api].[v_FMS_CHECK_LIST] |
| FMS_CHECKED_TAKEN_Raw | [TCG_RawFMS].[api].[v_FMS_CHECKED_TAKEN] |
| FMS_CLASSIFICATIONS_Raw | [TCG_RawFMS].[api].[v_FMS_CLASSIFICATIONS] |
| FMS_CRAFT_MODIFIER_Raw | [TCG_RawFMS].[api].[v_FMS_CRAFT_MODIFIER] |
| FMS_CRAFTS_Raw | [TCG_RawFMS].[api].[v_FMS_CRAFTS] |
| FMS_CUSTOMER_CONTACTS_Raw | [TCG_RawFMS].[api].[v_FMS_CUSTOMER_CONTACTS] |
| FMS_CUSTOMER_LOCATIONS_Raw | [TCG_RawFMS].[api].[v_FMS_CUSTOMER_LOCATIONS] |
| FMS_CUSTOMER_NOTES_Raw | [TCG_RawFMS].[api].[v_FMS_CUSTOMER_NOTES] |
| FMS_CUSTOMERS_Raw | [TCG_RawFMS].[api].[v_FMS_CUSTOMERS] |
| FMS_DEPARTMENTS_Raw | [TCG_RawFMS].[api].[v_FMS_DEPARTMENTS] |
| FMS_EMPLOYEE_TYPES_Raw | [TCG_RawFMS].[api].[v_FMS_EMPLOYEE_TYPES] |
| FMS_EMPLOYEES_Raw | [TCG_RawFMS].[api].[v_FMS_EMPLOYEES] |
| FMS_ETHNICITY_Raw | [TCG_RawFMS].[api].[v_FMS_ETHNICITY] |
| FMS_ETS_TICKET_SUB_SECTION_Raw | [TCG_RawFMS].[api].[v_FMS_ETS_TICKET_SUB_SECTION] |
| FMS_INDUSTRIES_Raw | [TCG_RawFMS].[api].[v_FMS_INDUSTRIES] |
| FMS_JOB_CHECKLIST_Raw | [TCG_RawFMS].[api].[v_FMS_JOB_CHECKLIST] |
| FMS_JOB_EMPLOYEES_Raw | [TCG_RawFMS].[api].[v_FMS_JOB_EMPLOYEES] |
| FMS_JOB_MASTER_Raw | [TCG_RawFMS].[api].[v_FMS_JOB_MASTER] |
| FMS_JOB_STATUS_Raw | [TCG_RawFMS].[api].[v_FMS_JOB_STATUS] |
| FMS_JOB_TICKET_EMP_UNIT_Raw | [TCG_RawFMS].[api].[v_FMS_JOB_TICKET_EMP_UNIT] |
| FMS_JOB_TICKET_Raw | [TCG_RawFMS].[api].[v_FMS_JOB_TICKET] |
| FMS_JOB_TYPES_Raw | [TCG_RawFMS].[api].[v_FMS_JOB_TYPES] |
| FMS_JOB_UNIT_CHECK_LIST_Raw | [TCG_RawFMS].[api].[v_FMS_JOB_UNIT_CHECK_LIST] |
| FMS_JOB_UNITS_Raw | [TCG_RawFMS].[api].[v_FMS_JOB_UNITS] |
| FMS_LABOR_PAYROLL_Raw | [TCG_RawFMS].[api].[v_FMS_LABOR_PAYROLL] |
| FMS_RESOURCE_CHECKLIST_ADHOC_Raw | [TCG_RawFMS].[api].[v_FMS_RESOURCE_CHECKLIST_ADHOC] |
| FMS_SALES_PERSON_Raw | [TCG_RawFMS].[api].[v_FMS_SALES_PERSON] |
| FMS_SCHEDULE_TYPES_Raw | [TCG_RawFMS].[api].[v_FMS_SCHEDULE_TYPES] |
| FMS_TERMS_Raw | [TCG_RawFMS].[api].[v_FMS_TERMS] |
| FMS_TICKET_SECTIONS_SUBLIST_Raw | [TCG_RawFMS].[api].[v_FMS_TICKET_SECTIONS_SUBLIST] |
| FMS_TICKET_STATUS_Raw | [TCG_RawFMS].[api].[v_FMS_TICKET_STATUS] |
| FMS_UNION_CRAFT_MODIFIER_Raw | [TCG_RawFMS].[api].[v_FMS_UNION_CRAFT_MODIFIER] |
| FMS_UNION_CRAFT_Raw | [TCG_RawFMS].[api].[v_FMS_UNION_CRAFT] |
| FMS_UNIT_CHECK_LIST_Raw | [TCG_RawFMS].[api].[v_FMS_UNIT_CHECK_LIST] |
| FMS_UNIT_TYPE_DETAILS_Raw | [TCG_RawFMS].[api].[v_FMS_UNIT_TYPE_DETAILS] |
| FMS_UNIT_TYPES_Raw | [TCG_RawFMS].[api].[v_FMS_UNIT_TYPES] |
| FMS_UNITS_Raw | [TCG_RawFMS].[api].[v_FMS_UNITS] |
| FMS_UNITTYPE_JOBTYPES_Raw | [TCG_RawFMS].[api].[v_FMS_UNITTYPE_JOBTYPES] |

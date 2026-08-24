---
title: Legacy Payroll App - live results of the read-only regression suites
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

# Test run results (read-only suites)

Executed live. Employee names masked.

## test.usp_RunAll_CorePayroll_Tests

_result set 1_ (1 rows):

| TestName | LaborPayrollID | Act_Total_Hrs | Hrs_ST | Expected_ST | Hrs_OT | Expected_OT | Hrs_DT | Expected_DT |
|---|---|---|---|---|---|---|---|---|
| DailyOTDT_Split | 83338 | 13.0000 | 8.0000 | 8.0000 | 4.0000 | 4.0000 | 1.0000 | 1.0000 |

_result set 2_ (1 rows):

| TestName | LaborPayrollID | RuleCode | RuleName | GuaranteeDate | HolidayName | GroupActualQualifyingHours | MinimumHours | GroupGapHours | AllocatedGapHours | AllocatedGapPay | MultiplierUsed | AllocationMethod | PayrollCalculated_Act_Total_Hrs | PayrollCalculated_Pay_Total_Hrs | PayrollCalculated_Gap_Hrs_Total | PayrollCalculated_Pay_Gap_Add |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Holiday_Min8 | 86102 | HOLIDAY_MIN_8 | Holiday 8-hour minimum | 05/25/2026 00:00:00 | Memorial Day | 5.0000 | 8.0000 | 3.0000 | 3.0000 | 640.4400 | 3.0000 | LastHolidaySliceEntry | 5.0000 | 8.0000 | 3.0000 | 640.4400 |

_result set 3_ (1 rows):

| TestName | LaborPayrollID | RuleCode | RuleName | GuaranteeDate | HolidayName | GroupActualQualifyingHours | MinimumHours | GroupGapHours | AllocatedGapHours | AllocatedGapPay | MultiplierUsed | AllocationMethod | PayrollCalculated_Act_Total_Hrs | PayrollCalculated_Pay_Total_Hrs | PayrollCalculated_Gap_Hrs_Total | PayrollCalculated_Pay_Gap_Add |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| SpecialSaturday_Min8 | 86498 | SPECIAL_SAT_MIN_8 | Special Saturday 8-hour minimum | 06/06/2026 00:00:00 | June Special Saturday | 4.5000 | 8.0000 | 3.5000 | 3.5000 | 475.0900 | 2.0000 | LastSpecialSatSliceEntry | 4.5000 | 8.0000 | 3.5000 | 481.0900 |

_result set 4_ (1 rows):

| LaborPayrollID | WorkDate | IsSunday | Act_Total_Hrs | Hrs_ST | Hrs_OT | Hrs_DT |
|---|---|---|---|---|---|---|
| 78294 | 02/15/2026 00:00:00 | 1 | 8.5000 | 0.0000 | 0.0000 | 8.5000 |

_result set 5_ (1 rows):

| CaseID | EmpID | Prev_LaborPayrollID | Curr_LaborPayrollID | Expected_GapMinutes | Prev_End | Curr_Start | GapMinutes |
|---|---|---|---|---|---|---|---|
| 1 | E***23 | 76564 | 76606 | 150 | 01/21/2026 23:30:00 | 01/22/2026 02:00:00 | 150 |

_result set 6_ (10 rows):

| CaseID | CaseName | ActivePolicy | AnchorDayType | PostMidnightDayType | Minutes_PreMidnight | Minutes_PostMidnight | ExpectedHighMinutes | ActualHighMinutes | Pass | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Weekday_to_Holiday | CalendarDay | Weekday | Holiday | 240 | 180 | 180 | 180 | True | Expected: pre-midnight ST day-type; post-midnight Holiday day-type. |
| 2 | Holiday_to_Weekday | CalendarDay | Holiday | Weekday | 240 | 180 | 240 | 240 | True | Expected: CalendarDay drops to weekday after midnight; AnchorFloor keeps holiday across midnight. |
| 3 | Weekday_to_Saturday | CalendarDay | Weekday | Saturday | 240 | 180 | 180 | 180 | True | CalendarDay: post-midnight Saturday only. AnchorFloor: same (anchor lower). |
| 4 | Saturday_to_Weekday | CalendarDay | Saturday | Weekday | 240 | 180 | 240 | 240 | True | CalendarDay: pre-midnight Saturday only. AnchorFloor: all minutes (anchor higher). |
| 5 | Weekday_to_Sunday | CalendarDay | Weekday | Sunday | 240 | 180 | 180 | 180 | True | CalendarDay: post-midnight Sunday only. AnchorFloor: same (anchor lower). |
| 6 | Sunday_to_Weekday | CalendarDay | Sunday | Weekday | 240 | 180 | 240 | 240 | True | CalendarDay: pre-midnight Sunday only. AnchorFloor: all minutes (anchor higher). |
| 7 | Weekday_to_SpecialSaturday | CalendarDay | Weekday | SpecialSaturday | 240 | 180 | 180 | 180 | True | CalendarDay: post-midnight Special Saturday only. AnchorFloor: same (anchor lower). |
| 8 | SpecialSaturday_to_Weekday | CalendarDay | SpecialSaturday | Weekday | 240 | 180 | 240 | 240 | True | CalendarDay: pre-midnight Special Saturday only. AnchorFloor: all minutes (anchor higher). |
| 9 | Holiday_to_Saturday | CalendarDay | Holiday | Saturday | 240 | 180 | 420 | 420 | True | Sanity: both days are premium day-types so both policies treat all minutes as high. |
| 10 | Saturday_to_Holiday | CalendarDay | Saturday | Holiday | 240 | 180 | 420 | 420 | True | Sanity: both days are premium day-types so both policies treat all minutes as high. |

_result set 7_ (10 rows):

| CaseID | CaseName | ActivePolicy | AnchorDayType | PostMidnightDayType | Minutes_PreMidnight | Minutes_PostMidnight | ExpectedHighMinutes | ActualHighMinutes | Pass | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Weekday_to_Holiday | AnchorFloor | Weekday | Holiday | 240 | 180 | 180 | 180 | True | Expected: pre-midnight ST day-type; post-midnight Holiday day-type. |
| 2 | Holiday_to_Weekday | AnchorFloor | Holiday | Weekday | 240 | 180 | 420 | 420 | True | Expected: CalendarDay drops to weekday after midnight; AnchorFloor keeps holiday across midnight. |
| 3 | Weekday_to_Saturday | AnchorFloor | Weekday | Saturday | 240 | 180 | 180 | 180 | True | CalendarDay: post-midnight Saturday only. AnchorFloor: same (anchor lower). |
| 4 | Saturday_to_Weekday | AnchorFloor | Saturday | Weekday | 240 | 180 | 420 | 420 | True | CalendarDay: pre-midnight Saturday only. AnchorFloor: all minutes (anchor higher). |
| 5 | Weekday_to_Sunday | AnchorFloor | Weekday | Sunday | 240 | 180 | 180 | 180 | True | CalendarDay: post-midnight Sunday only. AnchorFloor: same (anchor lower). |
| 6 | Sunday_to_Weekday | AnchorFloor | Sunday | Weekday | 240 | 180 | 420 | 420 | True | CalendarDay: pre-midnight Sunday only. AnchorFloor: all minutes (anchor higher). |
| 7 | Weekday_to_SpecialSaturday | AnchorFloor | Weekday | SpecialSaturday | 240 | 180 | 180 | 180 | True | CalendarDay: post-midnight Special Saturday only. AnchorFloor: same (anchor lower). |
| 8 | SpecialSaturday_to_Weekday | AnchorFloor | SpecialSaturday | Weekday | 240 | 180 | 420 | 420 | True | CalendarDay: pre-midnight Special Saturday only. AnchorFloor: all minutes (anchor higher). |
| 9 | Holiday_to_Saturday | AnchorFloor | Holiday | Saturday | 240 | 180 | 420 | 420 | True | Sanity: both days are premium day-types so both policies treat all minutes as high. |
| 10 | Saturday_to_Holiday | AnchorFloor | Saturday | Holiday | 240 | 180 | 420 | 420 | True | Sanity: both days are premium day-types so both policies treat all minutes as high. |


## test.usp_RunAll_CurrentPayrollRegression_Checkpoint

_result set 1_ (1 rows):

| TotalScenarios | PassedScenarios | FailedScenarios | KnownIssueScenarios | OverallPass |
|---|---|---|---|---|
| 16 | 16 | 0 | 0 | True |

_result set 2_ (16 rows):

| ScenarioID | ScenarioCode | ScenarioGroup | ScenarioName | LaborPayrollID | IsKnownIssue | KnownIssueNote | ScenarioPass | FailedCheckCount | FailedChecks |
|---|---|---|---|---|---|---|---|---|---|
| 1 | BOOM_ACTUAL_HOURS | Boom | Actual boom premium hours | 71754 | False |  | True | 0 |  |
| 2 | BOOM_GAP_HOURS | Boom | Boom gap hours | 81827 | False |  | True | 0 |  |
| 3 | HOLIDAY_MIN8_GAP | Holiday | Holiday minimum 8 with gap | 73794 | False |  | True | 0 |  |
| 4 | HOLIDAY_OVER8 | Holiday | Holiday over 8 actual hours | 78410 | False |  | True | 0 |  |
| 5 | HOURS_ONLY_SHIFT_ASSUMED | Input shape | Hours-only labor entry | 72987 | False |  | True | 0 |  |
| 14 | WEEKDAY_MIN4_GAP | Minimum pay | Weekday minimum-pay gap | 83178 | False |  | True | 0 |  |
| 7 | REST_FORCED | Rest period | Rest-period premium forced | 83285 | False |  | True | 0 |  |
| 8 | REST_NOT_FORCED | Rest period | Rest-period not forced after 8+ hour gap | 83287 | False |  | True | 0 |  |
| 9 | REST_OVERLAP_WARNING | Rest period | Rest-period overlap / data quality | 82905 | False |  | True | 0 |  |
| 16 | WEEKDAY_OUTSIDE_WINDOW | Slice classification | Weekday outside 6 AM to 5 PM window | 80274 | False |  | True | 0 |  |
| 10 | SPECIAL_SAT_MIN8_GAP | Special Saturday | Special Saturday minimum 8 with gap | 74066 | False |  | True | 0 |  |
| 11 | SPECIAL_SAT_OVER8 | Special Saturday | Special Saturday over 8 actual hours | 74068 | False |  | True | 0 |  |
| 13 | WEEKDAY_DAILY_DT | Time buckets | Weekday daily double-time | 83338 | False |  | True | 0 |  |
| 15 | WEEKDAY_OT_ONLY | Time buckets | Weekday OT only, no DT | 83282 | False |  | True | 0 |  |
| 6 | NORMAL_SATURDAY | Weekend | Normal Saturday | 82951 | False |  | True | 0 |  |
| 12 | SUNDAY_PREMIUM | Weekend | Sunday premium | 82976 | False |  | True | 0 |  |

_result set 3_ (1 rows):

| TotalCases | PassedCases | FailedCases | OverallPass |
|---|---|---|---|
| 5 | 5 | 0 | True |

_result set 4_ (5 rows):

| CaseID | CaseCode | LaborPayrollID | EmpID | Employee_Name | WorkDate | JobTicketID | JobCode | Labor_Start | Labor_End | Expected_Labor_Hrs | Labor_Hrs | Ticket_Shift_Start | Ticket_Shift_End | Expected_Ticket_Hrs | Ticket_Hrs | Slice_Start | Slice_End | Slice_Hrs | SliceCount | Expected_Act_Total_Hrs | Act_Total_Hrs | Hrs_ST | Hrs_OT | Hrs_DT | PayrollUsesLaborTimeline | PayrollUsesTicketShift | SliceUsesLaborTimeline | SliceUsesTicketShift | Pass | Finding | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | BASELINE_OUTSIDE_WINDOW_23_VS_11 | 80274 | E***55 | (masked) | 03/13/2026 00:00:00 | 42758 | OM58045 | 03/13/2026 07:30:00 | 03/14/2026 06:30:00 | 23.00 | 23.00 | 03/13/2026 07:30:00 | 03/13/2026 18:30:00 | 11.00 | 11.00 | 03/13/2026 07:30:00 | 03/14/2026 06:30:00 | 23.00 | 46 | 23.00 | 23.00 | 8.00 | 4.00 | 11.00 | True | False | True | False | True | PASS: Final payroll and slice path use LaborPayroll/timeline shift hours. | Existing baseline scenario where LaborPayroll/timeline = 23.00 and JobTicket shift reference = 11.00. |
| 2 | LABOR_13_TICKET_12 | 83171 | E***75 | (masked) | 04/22/2026 00:00:00 | 44203 | OM57005 | 04/22/2026 05:00:00 | 04/22/2026 18:00:00 | 13.00 | 13.00 | 04/22/2026 06:00:00 | 04/22/2026 18:00:00 | 12.00 | 12.00 | 04/22/2026 05:00:00 | 04/22/2026 18:00:00 | 13.00 | 26 | 13.00 | 13.00 | 8.00 | 4.00 | 1.00 | True | False | True | False | True | PASS: Final payroll and slice path use LaborPayroll/timeline shift hours. | Ticketed row where LaborPayroll/timeline = 13.00 and JobTicket shift = 12.00. Payroll must use 13.00. |
| 3 | LABOR_8_5_TICKET_20_5 | 83253 | E***88 | (masked) | 04/22/2026 00:00:00 | 44210 | OM58362 | 04/22/2026 06:00:00 | 04/22/2026 14:30:00 | 8.50 | 8.50 | 04/22/2026 06:00:00 | 04/23/2026 02:30:00 | 20.50 | 20.50 | 04/22/2026 06:00:00 | 04/22/2026 14:30:00 | 8.50 | 17 | 8.50 | 8.50 | 8.00 | 0.50 | 0.00 | True | False | True | False | True | PASS: Final payroll and slice path use LaborPayroll/timeline shift hours. | Ticketed row with very large JobTicket shift window. Payroll must use LaborPayroll/timeline 8.50. |
| 5 | LABOR_9_5_TICKET_7_5_NIGHT | 83160 | E***34 | (masked) | 04/21/2026 00:00:00 | 44200 | OM58709 | 04/21/2026 19:00:00 | 04/22/2026 04:30:00 | 9.50 | 9.50 | 04/21/2026 21:00:00 | 04/22/2026 04:30:00 | 7.50 | 7.50 | 04/21/2026 19:00:00 | 04/22/2026 04:30:00 | 9.50 | 19 | 9.50 | 9.50 | 0.00 | 9.50 | 0.00 | True | False | True | False | True | PASS: Final payroll and slice path use LaborPayroll/timeline shift hours. | Night/cross-midnight candidate. Payroll must use LaborPayroll/timeline 9.50. |
| 6 | LABOR_13_5_TICKET_12_EARLY_DT | 83487 | E***94 | (masked) | 04/24/2026 00:00:00 | 44325 | OM57006 | 04/24/2026 04:30:00 | 04/24/2026 18:00:00 | 13.50 | 13.50 | 04/24/2026 06:00:00 | 04/24/2026 18:00:00 | 12.00 | 12.00 | 04/24/2026 04:30:00 | 04/24/2026 18:00:00 | 13.50 | 27 | 13.50 | 13.50 | 8.00 | 4.00 | 1.50 | True | False | True | False | True | PASS: Final payroll and slice path use LaborPayroll/timeline shift hours. | Replacement case: current ticketed row where LaborPayroll/timeline = 13.50, JobTicket shift = 12.00, Act_Total_Hrs = 13. |

_result set 5_ (15 rows):

| ScenarioID | ScenarioCode | ScenarioGroup | ScenarioName | LaborPayrollID | WorkDate | EmpID | Employee_Name | JobTicketID | Act_Total_Hrs | SliceHours | Pay_Actual_Gross | Pay_Rest_Add | Expected_SlicePay | SlicePay_Total | Min_Day_Type | Max_Day_Type | Min_Multiplier | Max_Multiplier | Pass_Hours | Pass_Pay | Pass | Finding |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | BOOM_ACTUAL_HOURS | Boom | Actual boom premium hours | 71754 | 10/28/2025 00:00:00 | E***30 | (masked) | 38468 | 22.00 | 22.00 | 2258.25 | 0.0000 | 2258.2500 | 2258.2450 | WEEKDAY | WEEKDAY | 1.00 | 2.00 | True | True | True | PASS |
| 2 | BOOM_GAP_HOURS | Boom | Boom gap hours | 81827 | 04/03/2026 00:00:00 | E***53 | (masked) | 43574 | 4.00 | 4.00 | 306.17 | 0.0000 | 306.1700 | 306.1650 | WEEKDAY | WEEKDAY | 1.00 | 1.50 | True | True | True | PASS |
| 3 | HOLIDAY_MIN8_GAP | Holiday | Holiday minimum 8 with gap | 73794 | 11/27/2025 00:00:00 | E***94 | (masked) |  | 3.50 | 3.50 | 726.18 | 0.0000 | 726.1800 | 726.1800 | HOLIDAY | HOLIDAY | 3.00 | 3.00 | True | True | True | PASS |
| 4 | HOLIDAY_OVER8 | Holiday | Holiday over 8 actual hours | 78410 | 02/16/2026 00:00:00 | E***53 | (masked) | 41846 | 16.50 | 16.50 | 3592.17 | 0.0000 | 3592.1700 | 3592.1700 | HOLIDAY | HOLIDAY | 3.00 | 3.00 | True | True | True | PASS |
| 14 | WEEKDAY_MIN4_GAP | Minimum pay | Weekday minimum-pay gap | 83178 | 04/22/2026 00:00:00 | E***53 | (masked) | 44245 | 3.00 | 3.00 | 203.61 | 0.0000 | 203.6100 | 203.6100 | WEEKDAY | WEEKDAY | 1.00 | 1.00 | True | True | True | PASS |
| 7 | REST_FORCED | Rest period | Rest-period premium forced | 83285 | 04/23/2026 00:00:00 | E***69 | (masked) | 44275 | 4.00 | 4.00 | 163.60 | 81.8000 | 163.6000 | 163.6000 | WEEKDAY | WEEKDAY | 1.00 | 1.00 | True | True | True | PASS |
| 8 | REST_NOT_FORCED | Rest period | Rest-period not forced after 8+ hour gap | 83287 | 04/23/2026 00:00:00 | E***88 | (masked) | 44257 | 8.50 | 8.50 | 579.08 | 0.0000 | 579.0800 | 579.0750 | WEEKDAY | WEEKDAY | 1.00 | 1.50 | True | True | True | PASS |
| 9 | REST_OVERLAP_WARNING | Rest period | Rest-period overlap / data quality | 82905 | 04/16/2026 00:00:00 | E***14 | (masked) |  | 10.00 | 10.00 | 726.33 | 594.2700 | 726.3300 | 726.3300 | WEEKDAY | WEEKDAY | 1.00 | 1.50 | True | True | True | PASS |
| 16 | WEEKDAY_OUTSIDE_WINDOW | Slice classification | Weekday outside 6 AM to 5 PM window | 80274 | 03/13/2026 00:00:00 | E***55 | (masked) | 42758 | 23.00 | 23.00 | 2489.76 | 0.0000 | 2489.7600 | 2489.7600 | WEEKDAY | WEEKDAY | 1.00 | 2.00 | True | True | True | PASS |
| 10 | SPECIAL_SAT_MIN8_GAP | Special Saturday | Special Saturday minimum 8 with gap | 74066 | 12/06/2025 00:00:00 | E***38 | (masked) | 39773 | 6.00 | 6.00 | 832.44 | 0.0000 | 832.4400 | 832.4400 | SPECIAL_SAT | SPECIAL_SAT | 2.00 | 2.00 | True | True | True | PASS |
| 11 | SPECIAL_SAT_OVER8 | Special Saturday | Special Saturday over 8 actual hours | 74068 | 12/06/2025 00:00:00 | E***53 | (masked) | 39772 | 9.00 | 9.00 | 1242.66 | 0.0000 | 1242.6600 | 1242.6600 | SPECIAL_SAT | SPECIAL_SAT | 2.00 | 2.00 | True | True | True | PASS |
| 13 | WEEKDAY_DAILY_DT | Time buckets | Weekday daily double-time | 83338 | 04/23/2026 00:00:00 | E***38 | (masked) | 44271 | 13.00 | 13.00 | 1085.92 | 0.0000 | 1085.9200 | 1085.9200 | WEEKDAY | WEEKDAY | 1.00 | 2.00 | True | True | True | PASS |
| 15 | WEEKDAY_OT_ONLY | Time buckets | Weekday OT only, no DT | 83282 | 04/23/2026 00:00:00 | E***75 | (masked) | 44251 | 12.00 | 12.00 | 1069.74 | 0.0000 | 1069.7400 | 1069.7400 | WEEKDAY | WEEKDAY | 1.00 | 1.50 | True | True | True | PASS |
| 6 | NORMAL_SATURDAY | Weekend | Normal Saturday | 82951 | 04/18/2026 00:00:00 | E***75 | (masked) | 44095 | 12.00 | 12.00 | 1375.38 | 0.0000 | 1375.3800 | 1375.3800 | SATURDAY | SATURDAY | 1.50 | 1.50 | True | True | True | PASS |
| 12 | SUNDAY_PREMIUM | Weekend | Sunday premium | 82976 | 04/19/2026 00:00:00 | E***55 | (masked) | 44160 | 7.00 | 7.00 | 968.24 | 0.0000 | 968.2400 | 968.2400 | SUNDAY | SUNDAY | 2.00 | 2.00 | True | True | True | PASS |

_result set 6_ (9 rows):

| ScenarioID | ScenarioCode | ScenarioGroup | ScenarioName | LaborPayrollID | JobTicketID | EmpID | Employee_Name | WorkDate | CraftCode | CraftModifierCode | CraftModifierDescription | CraftModifierPayRateAdjustment | BoomEligible | BoomDisplayStatus | Expected_Act_Boom_Hrs | Actual_Act_Boom_Hrs | Expected_Gap_Boom_Hrs | Actual_Gap_Boom_Hrs | Guarantee_BoomGap_Hrs | Guarantee_BoomGap_Pay | Guarantee_BoomAllocCount | Guarantee_MaxBoomMultiplier | Ticket_Boom_Window_Hrs | Slice_Boom_Window_Hrs | Slice_Boom_Hrs | Boom_Actual_Add_Amt | Boom_Gap_Add_Amt | Boom_Total_Add_Amt | Boom_Window_Start | Boom_Window_End | First_Boom_Window_Slice_Start | Last_Boom_Window_Slice_End | First_Boom_Slice_Start | Last_Boom_Slice_End | Pass_ActualBoomHours | Pass_GapBoomHours | Pass_GuaranteeBoomCompat | Pass_PayableSliceBoomHours | Pass | Finding |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | BOOM_ACTUAL_HOURS | Boom | Actual boom premium hours | 71754 | 38468 | E***30 | (masked) | 10/28/2025 00:00:00 | L12-G2-A | OI-BP-01 | 080-100Ft-Oiler | 0.250 | True | Boom actual | 21.00 | 21.00 | 0.00 | 0.00 | 0.0000 | 0.0000 | 0 |  | 21.00 | 21.00 | 21.00 | 8.13 | 0.00 | 8.13 | 10/28/2025 06:30:00 | 10/29/2025 03:30:00 | 10/28/2025 06:30:00 | 10/29/2025 03:30:00 | 10/28/2025 06:30:00 | 10/29/2025 03:30:00 | True | True | True | True | True | PASS |
| 2 | BOOM_GAP_HOURS | Boom | Boom gap hours | 81827 | 43574 | E***53 | (masked) | 04/03/2026 00:00:00 | L12-G3-A | OP-BP-02 | 101-120Ft-Operator | 1.500 | True | Boom actual + gap | 0.50 | 0.50 | 3.50 | 3.50 | 3.5000 | 5.2500 | 1 | 1.0000 | 0.50 | 0.50 | 0.50 | 0.75 | 5.25 | 6.00 | 04/03/2026 06:00:00 | 04/03/2026 06:30:00 | 04/03/2026 06:00:00 | 04/03/2026 06:30:00 | 04/03/2026 06:00:00 | 04/03/2026 06:30:00 | True | True | True | True | True | PASS |
| 16 | WEEKDAY_OUTSIDE_WINDOW | Slice classification | Weekday outside 6 AM to 5 PM window | 80274 | 42758 | E***55 | (masked) | 03/13/2026 00:00:00 | L12-G8-A |  | Unknown |  | False | Ticket boom window only - no modifier | 0.00 | 0.00 | 0.00 | 0.00 | 0.0000 | 0.0000 | 0 |  | 6.50 | 6.50 | 0.00 | 0.00 | 0.00 | 0.00 | 03/13/2026 10:00:00 | 03/13/2026 16:30:00 | 03/13/2026 10:00:00 | 03/13/2026 16:30:00 |  |  | True | True | True | True | True | PASS: Ticket boom window shown as reference-only because no modifier exists. |
| 10 | SPECIAL_SAT_MIN8_GAP | Special Saturday | Special Saturday minimum 8 with gap | 74066 | 39773 | E***38 | (masked) | 12/06/2025 00:00:00 | L12-G3-A | OP-BP-03 | 121-140Ft-Operator | 2.250 | True | Boom actual | 4.00 | 4.00 | 0.00 | 0.00 | 0.0000 | 0.0000 | 0 |  | 4.00 | 4.00 | 4.00 | 18.00 | 0.00 | 18.00 | 12/06/2025 06:00:00 | 12/06/2025 10:00:00 | 12/06/2025 06:00:00 | 12/06/2025 10:00:00 | 12/06/2025 06:00:00 | 12/06/2025 10:00:00 | True | True | True | True | True | PASS |
| 11 | SPECIAL_SAT_OVER8 | Special Saturday | Special Saturday over 8 actual hours | 74068 | 39772 | E***53 | (masked) | 12/06/2025 00:00:00 | L12-G3-A | OP-BP-02 | 101-120Ft-Operator | 1.500 | True | Boom actual | 7.00 | 7.00 | 0.00 | 0.00 | 0.0000 | 0.0000 | 0 |  | 7.00 | 7.00 | 7.00 | 21.00 | 0.00 | 21.00 | 12/06/2025 06:30:00 | 12/06/2025 13:30:00 | 12/06/2025 06:30:00 | 12/06/2025 13:30:00 | 12/06/2025 06:30:00 | 12/06/2025 13:30:00 | True | True | True | True | True | PASS |
| 13 | WEEKDAY_DAILY_DT | Time buckets | Weekday daily double-time | 83338 | 44271 | E***38 | (masked) | 04/23/2026 00:00:00 | L12-G3-A |  | Unknown |  | False | Ticket boom window only - no modifier | 0.00 | 0.00 | 0.00 | 0.00 | 0.0000 | 0.0000 | 0 |  | 7.50 | 7.50 | 0.00 | 0.00 | 0.00 | 0.00 | 04/23/2026 06:30:00 | 04/23/2026 14:00:00 | 04/23/2026 06:30:00 | 04/23/2026 14:00:00 |  |  | True | True | True | True | True | PASS: Ticket boom window shown as reference-only because no modifier exists. |
| 15 | WEEKDAY_OT_ONLY | Time buckets | Weekday OT only, no DT | 83282 | 44251 | E***75 | (masked) | 04/23/2026 00:00:00 | HDR-A | OP-BP-07 | 201-220Ft-Operator | 5.250 | True | Boom actual | 12.00 | 12.00 | 0.00 | 0.00 | 0.0000 | 0.0000 | 0 |  | 12.00 | 12.00 | 0.00 | 0.00 | 0.00 | 0.00 | 04/23/2026 06:00:00 | 04/23/2026 18:00:00 | 04/23/2026 06:00:00 | 04/23/2026 18:00:00 |  |  | True | True | True | False | False | FAIL: Payable slice boom hours do not match calculated actual boom hours. |
| 6 | NORMAL_SATURDAY | Weekend | Normal Saturday | 82951 | 44095 | E***75 | (masked) | 04/18/2026 00:00:00 | HDR-A | OP-BP-07 | 201-220Ft-Operator | 5.250 | True | Boom actual | 12.00 | 12.00 | 0.00 | 0.00 | 0.0000 | 0.0000 | 0 |  | 12.00 | 12.00 | 0.00 | 0.00 | 0.00 | 0.00 | 04/18/2026 06:00:00 | 04/18/2026 18:00:00 | 04/18/2026 06:00:00 | 04/18/2026 18:00:00 |  |  | True | True | True | False | False | FAIL: Payable slice boom hours do not match calculated actual boom hours. |
| 12 | SUNDAY_PREMIUM | Weekend | Sunday premium | 82976 | 44160 | E***55 | (masked) | 04/19/2026 00:00:00 | L12-G8-A |  | Unknown |  | False | Ticket boom window only - no modifier | 0.00 | 0.00 | 0.00 | 0.00 | 0.0000 | 0.0000 | 0 |  | 3.50 | 3.50 | 0.00 | 0.00 | 0.00 | 0.00 | 04/19/2026 07:30:00 | 04/19/2026 11:00:00 | 04/19/2026 07:30:00 | 04/19/2026 11:00:00 |  |  | True | True | True | True | True | PASS: Ticket boom window shown as reference-only because no modifier exists. |

_result set 7_ (1 rows):

| TotalScenarios | PassedScenarios | FailedScenarios | OverallPass |
|---|---|---|---|
| 16 | 16 | 0 | True |

_result set 8_ (16 rows):

| ScenarioID | ScenarioCode | ScenarioGroup | ScenarioName | LaborPayrollID | WorkDate_Date | EmpID | Employee_Name | JobTicketID | JobCode | Has_JobTicket | CraftCode | CraftDescription | CraftPayRate | CraftModifierCode | CraftModifierDescription | CraftModifierPayRateAdjustment | TimeStart_Labor | TimeEnd_Labor | HoursWorked_Raw | HasCraftModifier | BoomEligible | BoomDisplayStatus | Ticket_Boom_Window_Hrs | Slice_Boom_Window_Hrs | Slice_Boom_Hrs | Boom_Actual_Add_Amt | Boom_Gap_Add_Amt | Boom_Total_Add_Amt | Pass_WeekDetailRow | Pass_CraftCode | Pass_CraftDescription | Pass_CraftRate | Pass_BoomBreakdownRow | Pass_BoomStatus | Pass_BoomAmounts | Pass | Finding |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | BOOM_ACTUAL_HOURS | Boom | Actual boom premium hours | 71754 | 10/28/2025 00:00:00 | E***30 | (masked) | 38468 | OM55685 | True | L12-G2-A | Oiler >80T | 66.180 | OI-BP-01 | 080-100Ft-Oiler | 0.250 | 10/30/2025 06:00:00 | 10/30/2025 04:00:00 | 23.50 | True | True | Boom actual | 21.00 | 21.00 | 21.00 | 8.13 | 0.00 | 8.13 | True | True | True | True | True | True | True | True | PASS |
| 2 | BOOM_GAP_HOURS | Boom | Boom gap hours | 81827 | 04/03/2026 00:00:00 | E***53 | (masked) | 43574 | OM58386 | True | L12-G3-A | OP up to 40T | 67.870 | OP-BP-02 | 101-120Ft-Operator | 1.500 | 04/03/2026 05:00:00 | 04/03/2026 09:00:00 | 4.00 | True | True | Boom actual + gap | 0.50 | 0.50 | 0.50 | 0.75 | 5.25 | 6.00 | True | True | True | True | True | True | True | True | PASS |
| 3 | HOLIDAY_MIN8_GAP | Holiday | Holiday minimum 8 with gap | 73794 | 11/27/2025 00:00:00 | E***94 | (masked) |  | OM56340 | False | L12-G8-A | OP & Tower OP >350T-550T | 69.160 |  | Unknown |  | 12/02/2025 19:00:00 | 12/02/2025 22:30:00 | 3.50 | False | False | No boom modifier |  | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | True | True | True | True | True | True | True | True | PASS |
| 4 | HOLIDAY_OVER8 | Holiday | Holiday over 8 actual hours | 78410 | 02/16/2026 00:00:00 | E***53 | (masked) | 41846 | OM57581 | True | L12-G8-A | OP & Tower OP >350T-550T | 69.160 | OP-BP-10 | 261-280Ft-Operator | 7.500 | 02/18/2026 15:00:00 | 02/18/2026 07:30:00 | 18.00 | True | True | Boom actual | 7.50 | 7.50 | 7.50 | 168.75 | 0.00 | 168.75 | True | True | True | True | True | True | True | True | PASS |
| 5 | HOURS_ONLY_SHIFT_ASSUMED | Input shape | Hours-only labor entry | 72987 | 11/14/2025 00:00:00 | E***55 | (masked) |  |  | False | L12-G3-A | OP up to 40T | 67.870 |  | Unknown |  |  |  | 4.00 | False | False | No boom modifier |  | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | True | True | True | True | True | True | True | True | PASS |
| 14 | WEEKDAY_MIN4_GAP | Minimum pay | Weekday minimum-pay gap | 83178 | 04/22/2026 00:00:00 | E***53 | (masked) | 44245 | OM58661 | True | L12-G3-A | OP up to 40T | 67.870 |  | Unknown |  | 04/22/2026 06:00:00 | 04/22/2026 09:00:00 | 3.00 | False | False | Ticket boom window only - no modifier | 1.00 | 1.00 | 0.00 | 0.00 | 0.00 | 0.00 | True | True | True | True | True | True | True | True | PASS |
| 7 | REST_FORCED | Rest period | Rest-period premium forced | 83285 | 04/23/2026 00:00:00 | E***69 | (masked) | 44275 | OM58616 | True | L12-APP-A | Apprentice (INACTIVE) | 40.900 |  | Unknown |  | 04/23/2026 07:00:00 | 04/23/2026 11:00:00 | 4.00 | False | False | Ticket boom window only - no modifier | 2.00 | 2.00 | 0.00 | 0.00 | 0.00 | 0.00 | True | True | True | True | True | True | True | True | PASS |
| 8 | REST_NOT_FORCED | Rest period | Rest-period not forced after 8+ hour gap | 83287 | 04/23/2026 00:00:00 | E***88 | (masked) | 44257 | OM58362 | True | L12-G2-A | Oiler >80T | 66.180 |  | Unknown |  | 04/23/2026 06:00:00 | 04/23/2026 14:30:00 | 8.00 | False | False | Ticket boom window only - no modifier | 8.50 | 8.50 | 0.00 | 0.00 | 0.00 | 0.00 | True | True | True | True | True | True | True | True | PASS |
| 9 | REST_OVERLAP_WARNING | Rest period | Rest-period overlap / data quality | 82905 | 04/16/2026 00:00:00 | E***14 | (masked) |  | OM56928 | False | L12-G1-A | Oiler 80T & under | 66.030 |  | Unknown |  | 04/17/2026 06:00:00 | 04/17/2026 16:00:00 | 10.00 | False | False | No boom modifier |  | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | True | True | True | True | True | True | True | True | PASS |
| 16 | WEEKDAY_OUTSIDE_WINDOW | Slice classification | Weekday outside 6 AM to 5 PM window | 80274 | 03/13/2026 00:00:00 | E***55 | (masked) | 42758 | OM58045 | True | L12-G8-A | OP & Tower OP >350T-550T | 69.160 |  | Unknown |  | 03/14/2026 07:30:00 | 03/14/2026 06:30:00 | 11.50 | False | False | Ticket boom window only - no modifier | 6.50 | 6.50 | 0.00 | 0.00 | 0.00 | 0.00 | True | True | True | True | True | True | True | True | PASS |
| 10 | SPECIAL_SAT_MIN8_GAP | Special Saturday | Special Saturday minimum 8 with gap | 74066 | 12/06/2025 00:00:00 | E***38 | (masked) | 39773 | OM56426 | True | L12-G3-A | OP up to 40T | 67.870 | OP-BP-03 | 121-140Ft-Operator | 2.250 | 12/06/2025 05:00:00 | 12/06/2025 11:00:00 | 8.00 | True | True | Boom actual | 4.00 | 4.00 | 4.00 | 18.00 | 0.00 | 18.00 | True | True | True | True | True | True | True | True | PASS |
| 11 | SPECIAL_SAT_OVER8 | Special Saturday | Special Saturday over 8 actual hours | 74068 | 12/06/2025 00:00:00 | E***53 | (masked) | 39772 | OM56306 | True | L12-G3-A | OP up to 40T | 67.870 | OP-BP-02 | 101-120Ft-Operator | 1.500 | 12/06/2025 05:30:00 | 12/06/2025 14:30:00 | 9.50 | True | True | Boom actual | 7.00 | 7.00 | 7.00 | 21.00 | 0.00 | 21.00 | True | True | True | True | True | True | True | True | PASS |
| 13 | WEEKDAY_DAILY_DT | Time buckets | Weekday daily double-time | 83338 | 04/23/2026 00:00:00 | E***38 | (masked) | 44271 | OM58729 | True | L12-G3-A | OP up to 40T | 67.870 |  | Unknown |  | 04/23/2026 04:00:00 | 04/23/2026 17:00:00 | 13.00 | False | False | Ticket boom window only - no modifier | 7.50 | 7.50 | 0.00 | 0.00 | 0.00 | 0.00 | True | True | True | True | True | True | True | True | PASS |
| 15 | WEEKDAY_OT_ONLY | Time buckets | Weekday OT only, no DT | 83282 | 04/23/2026 00:00:00 | E***75 | (masked) | 44251 | OM57005 | True | HDR-A | Mech (INACTIVE) | 71.160 | OP-BP-07 | 201-220Ft-Operator | 5.250 | 04/23/2026 06:00:00 | 04/23/2026 18:00:00 | 12.00 | True | True | Boom actual | 12.00 | 12.00 | 0.00 | 0.00 | 0.00 | 0.00 | True | True | True | True | True | True | True | True | PASS |
| 6 | NORMAL_SATURDAY | Weekend | Normal Saturday | 82951 | 04/18/2026 00:00:00 | E***75 | (masked) | 44095 | OM57005 | True | HDR-A | Mech (INACTIVE) | 71.160 | OP-BP-07 | 201-220Ft-Operator | 5.250 | 04/18/2026 06:00:00 | 04/18/2026 18:00:00 | 12.00 | True | True | Boom actual | 12.00 | 12.00 | 0.00 | 0.00 | 0.00 | 0.00 | True | True | True | True | True | True | True | True | PASS |
| 12 | SUNDAY_PREMIUM | Weekend | Sunday premium | 82976 | 04/19/2026 00:00:00 | E***55 | (masked) | 44160 | OM58672 | True | L12-G8-A | OP & Tower OP >350T-550T | 69.160 |  | Unknown |  | 04/19/2026 05:30:00 | 04/19/2026 12:30:00 | 7.50 | False | False | Ticket boom window only - no modifier | 3.50 | 3.50 | 0.00 | 0.00 | 0.00 | 0.00 | True | True | True | True | True | True | True | True | PASS |

_result set 9_ (1 rows):

| TotalChecks | PassedChecks | FailedChecks | OverallPass |
|---|---|---|---|
| 8 | 7 | 1 | False |



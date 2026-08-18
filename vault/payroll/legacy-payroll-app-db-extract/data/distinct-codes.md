---
title: Legacy Payroll App - distinct pay-component codes, exception reasons, guarantee/rest/ticket values actually in use
source: user-supplied/PAYROLL_CALC_EXTRACT.zip (generated 2026-08-18 on the client machine from TCG_PayrollAPP + c:/projects/tcg-payroll-api)
migrated: 2026-08-18
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
topics: [payroll, legacy-payroll-app, reference-data]
entities: [pay-component, craft-modifier]
part_of: payroll/legacy-payroll-app-db-extract/INDEX.md
---

> Part of the 2026-08-18 read-only extract of the live legacy database `TCG_PayrollAPP`
> (`localhost\SQLEXPRESS`, SQL Server 2025 Express). Line anchors like `sql\app\x.PROC.sql:12-20`
> refer to the verbatim definitions in [sql/](sql/) (backslashes → forward slashes). Employee
> identifiers are masked `E***NN`. Nothing that writes was executed to produce this.

# A3 - Distinct code values actually in use

All queries run against full table history (not date-filtered) unless noted. Generated live from TCG_PayrollAPP.

## fms.Payroll_PayComponent - component catalogue (grouped)

| ComponentGroup | ComponentCode | ComponentLabel | SourceRuleCode | SourceRuleName | rows_ | hrs | amt | first_seen | last_seen | inFinal | inPayable |
|---|---|---|---|---|---|---|---|---|---|---|---|
| ACTUAL | ACTUAL_BASE_WORKED_PAY | Actual Base Worked Pay | *(null)* | Actual base worked pay | 80172 | 448495.00 | 40638372.5575 | 07/06/2020 00:00:00 | 06/22/2026 00:00:00 | 1 | 1 |
| ACTUAL | ACTUAL_BOOM_WORKED_PAY | Actual Boom Worked Pay | BOOM_ACTUAL | Actual boom worked pay | 24412 | 156074.50 | 546702.3725 | 07/06/2020 00:00:00 | 06/22/2026 00:00:00 | 1 | 1 |
| ACTUAL | ACTUAL_SHIFT_DIFFERENTIAL | Actual Shift Differential | SHIFT_DIFFERENTIAL | Actual shift differential | 3 | 36.00 | 162.0000 | 04/13/2026 00:00:00 | 05/06/2026 00:00:00 | 1 | 1 |
| GUARANTEE | GUARANTEED_BASE_PAY_ADD | Guaranteed Base Pay Add | DAILY_MIN_4 | Daily 4-hour minimum | 509 | 822.50 | 50463.8755 | 07/12/2020 00:00:00 | 06/21/2026 00:00:00 | 1 | 1 |
| GUARANTEE | GUARANTEED_BOOM_PAY_ADD | Guaranteed Boom Pay Add | LONG_BOOM_MIN_4 | Long boom 4-hour premium minimum | 4107 | 6708.50 | 16914.9145 | 07/06/2020 00:00:00 | 06/22/2026 00:00:00 | 1 | 1 |
| GUARANTEE | GUARANTEED_HOLIDAY_BASE_PAY_ADD | Guaranteed Holiday Base Pay Add | HOLIDAY_MIN_8 | Holiday 8-hour minimum | 8 | 20.50 | 4047.5000 | 02/17/2025 00:00:00 | 05/25/2026 00:00:00 | 1 | 1 |
| GUARANTEE | GUARANTEED_SPECIAL_SAT_BASE_PAY_ADD | Guaranteed Special Saturday Base Pay Add | SPECIAL_SAT_MIN_8 | Special Saturday 8-hour minimum | 32 | 98.00 | 12872.7200 | 12/05/2020 00:00:00 | 06/06/2026 00:00:00 | 1 | 1 |
| NONUNION_CA_NONEXEMPT | NONUNION_CA_NONEXEMPT_7TH_DAY_DT | Non-Union CA Nonexempt Seventh-Day Double Time | NONUNION_CA_NONEXEMPT_7TH_DAY_DT | California seventh consecutive day double time over 8 hours | 3 | 5.00 | 173.5000 | 11/07/2025 00:00:00 | 06/19/2026 00:00:00 | 1 | 1 |
| NONUNION_CA_NONEXEMPT | NONUNION_CA_NONEXEMPT_7TH_DAY_OT | Non-Union CA Nonexempt Seventh-Day Overtime | NONUNION_CA_NONEXEMPT_7TH_DAY_OT | California seventh consecutive day overtime first 8 hours | 4 | 16.00 | 498.0000 | 11/07/2025 00:00:00 | 06/19/2026 00:00:00 | 1 | 1 |
| NONUNION_CA_NONEXEMPT | NONUNION_CA_NONEXEMPT_DAILY_DT | Non-Union CA Nonexempt Daily Double Time | NONUNION_CA_NONEXEMPT_DAILY_DT | California daily double time over 12 hours | 290 | 544.50 | 21544.5000 | 08/21/2025 00:00:00 | 06/17/2026 00:00:00 | 1 | 1 |
| NONUNION_CA_NONEXEMPT | NONUNION_CA_NONEXEMPT_DAILY_OT | Non-Union CA Nonexempt Daily Overtime | NONUNION_CA_NONEXEMPT_DAILY_OT | California daily overtime over 8 and through 12 hours | 1231 | 2445.50 | 78466.4600 | 08/04/2025 00:00:00 | 06/22/2026 00:00:00 | 1 | 1 |
| NONUNION_CA_NONEXEMPT | NONUNION_CA_NONEXEMPT_ST | Non-Union CA Nonexempt Straight Time | NONUNION_CA_NONEXEMPT_ST | Non-union CA nonexempt straight time | 2996 | 8030.50 | 181680.0000 | 08/04/2025 00:00:00 | 06/22/2026 00:00:00 | 1 | 1 |
| NONUNION_CA_NONEXEMPT | NONUNION_CA_NONEXEMPT_WEEKLY_OT | Non-Union CA Nonexempt Weekly Overtime | NONUNION_CA_NONEXEMPT_WEEKLY_OT | California weekly overtime over 40 straight-time hours | 62 | 130.00 | 4137.0400 | 09/19/2025 00:00:00 | 06/19/2026 00:00:00 | 1 | 1 |
| REST_PERIOD | REST_PERIOD_PREMIUM | Rest Period Premium | PunitiveUntil8Off | Rest Period Premium | 3790 | 27181.50 | 1438486.8820 | 07/10/2020 00:00:00 | 06/22/2026 00:00:00 | 1 | 1 |
| ROUNDING | PAY_COMPONENT_ROUNDING_ADJUSTMENT | Pay Component Rounding Adjustment | FINAL_GROSS_LEDGER_ROUNDING | Final gross ledger rounding | 2460 | *(null)* | -17.6020 | 07/10/2020 00:00:00 | 06/22/2026 00:00:00 | 1 | 1 |
| SHIFT_DIFFERENTIAL | SHIFT_2_HOURS_ADD | 2nd Shift Hours Add | SHIFT_2_HOURS_ADD | 2nd shift paid-hours add | 3 | 3.00 | 272.9500 | 04/13/2026 00:00:00 | 05/06/2026 00:00:00 | 1 | 1 |
| SUBSISTENCE | SUBSISTENCE_LONG_WEEKDAY_85 | Long Subsistence - Weekday | SUB_LONG_WEEKDAY | Long subsistence weekday allowance | 26 | *(null)* | 2210.0000 | 05/13/2026 00:00:00 | 06/17/2026 00:00:00 | 0 | 1 |
| SUBSISTENCE | SUBSISTENCE_SHORT_85 | Short Subsistence | SUB_SHORT | Short subsistence allowance | 38 | *(null)* | 3230.0000 | 05/06/2026 00:00:00 | 06/20/2026 00:00:00 | 0 | 1 |
| WTL | WTL_APPLICABLE_ADD | WTL Applicable Add | WTL_APPLICABLE_ADD | Worked Through Lunch applicable add | 411 | 205.50 | 27493.9200 | 05/06/2026 00:00:00 | 06/20/2026 00:00:00 | 1 | 1 |
| WTL | WTL_DT_FLOOR | WTL DT Floor | WTL_DT_FLOOR | Worked Through Lunch DT floor | 131 | 65.50 | 3665.8100 | 06/02/2026 00:00:00 | 06/19/2026 00:00:00 | 1 | 1 |
| WTL | WTL_MEAL_DEDUCT | WTL Meal Deduction | WTL_MEAL_DEDUCT | Worked Through Lunch meal deduction | 16106 | -8053.00 | -669283.5600 | 08/02/2025 00:00:00 | 06/22/2026 00:00:00 | 1 | 1 |


## fms.Payroll_CalcException - distinct Reason (with counts)

| Reason | rows_ | first_seen | last_seen |
|---|---|---|---|
| Shift_Assumed (StdStart+HoursWorked) | 239783 | 07/17/2020 00:00:00 | 11/14/2025 00:00:00 |
| Warn_Reconstruction_ShiftMismatch | 169097 | 07/06/2020 00:00:00 | 06/22/2026 00:00:00 |
| Shift_Start NULL | 30672 | 07/17/2020 00:00:00 | 01/25/2026 00:00:00 |
| Shift_Assumed (LaborTimesInvalid End<=Start) | 11712 | 07/07/2020 00:00:00 | 06/15/2026 00:00:00 |
| WTL warning: no WTL token found; assuming WTL_0. | 9297 | 08/02/2025 00:00:00 | 06/22/2026 00:00:00 |
| RestPeriod_Overlap (Start < PrevEnd) | 6174 | 07/06/2020 00:00:00 | 06/22/2026 00:00:00 |
| Warn_Reconstruction_Possible24Plus \| Shift_Assumed (LaborTimesInvalid End<=Start) | 2721 | 07/13/2022 00:00:00 | 06/06/2026 00:00:00 |
| WTL warning: labor entry grouped with another labor entry for WTL rules. | 1579 | 08/02/2025 00:00:00 | 06/20/2026 00:00:00 |
| Warn_Reconstruction_ShiftMismatch+Possible24Plus | 1076 | 07/19/2020 00:00:00 | 06/19/2026 00:00:00 |
| Warn_Reconstruction_Possible24Plus | 913 | 12/30/2020 00:00:00 | 06/11/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=4; Start=2026-03-03 05:00; End=2026-03-03 21:00) | 520 | 03/03/2026 00:00:00 | 03/03/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=3; Start=2026-03-05 08:00; End=2026-03-05 12:00) | 375 | 03/05/2026 00:00:00 | 03/05/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=3; Start=2026-03-04 08:00; End=2026-03-04 12:00) | 366 | 03/04/2026 00:00:00 | 03/04/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=3; Start=2026-04-09 05:00; End=2026-04-09 19:00) | 327 | 04/09/2026 00:00:00 | 04/09/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-01-16 09:30; End=2026-01-16 15:30) | 308 | 01/16/2026 00:00:00 | 01/16/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-03-17 06:30; End=2026-03-17 17:30) | 296 | 03/17/2026 00:00:00 | 03/17/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-11-22 05:30; End=2025-11-22 17:00) | 296 | 11/22/2025 00:00:00 | 11/22/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-03-19 04:00; End=2026-03-19 17:00) | 294 | 03/19/2026 00:00:00 | 03/19/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-03-12 07:30; End=2026-03-12 16:00) | 288 | 03/12/2026 00:00:00 | 03/12/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-03-11 11:00; End=2026-03-11 23:00) | 282 | 03/11/2026 00:00:00 | 03/11/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-03-09 06:30; End=2026-03-09 18:00) | 274 | 03/09/2026 00:00:00 | 03/09/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-03-04 05:00; End=2026-03-04 17:30) | 266 | 03/04/2026 00:00:00 | 03/04/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-03-03 06:30; End=2026-03-03 19:00) | 260 | 03/03/2026 00:00:00 | 03/03/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-03-31 05:30; End=2026-03-31 20:00) | 250 | 03/31/2026 00:00:00 | 03/31/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-03-07 18:00; End=2026-03-08 06:00) | 248 | 03/07/2026 00:00:00 | 03/07/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-02-27 11:00; End=2026-02-27 22:30) | 236 | 02/27/2026 00:00:00 | 02/27/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-02-26 05:30; End=2026-02-26 13:30) | 230 | 02/26/2026 00:00:00 | 02/26/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-02-26 05:00; End=2026-02-26 11:30) | 230 | 02/26/2026 00:00:00 | 02/26/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-04-08 04:00; End=2026-04-08 21:30) | 222 | 04/08/2026 00:00:00 | 04/08/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-04-08 05:00; End=2026-04-08 16:00) | 222 | 04/08/2026 00:00:00 | 04/08/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-11-06 03:30; End=2025-11-06 20:30) | 216 | 11/06/2025 00:00:00 | 11/06/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-02-24 18:00; End=2026-02-24 23:00) | 206 | 02/24/2026 00:00:00 | 02/24/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-04-10 08:00; End=2026-04-10 14:00) | 200 | 04/10/2026 00:00:00 | 04/10/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-04-15 06:00; End=2026-04-15 18:00) | 198 | 04/15/2026 00:00:00 | 04/15/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-04-16 10:30; End=2026-04-16 16:00) | 196 | 04/16/2026 00:00:00 | 04/16/2026 00:00:00 |
| WTL warning: grouped labor entries overlap. | 172 | 08/06/2025 00:00:00 | 06/22/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-02-13 08:00; End=2026-02-13 09:00) | 170 | 02/13/2026 00:00:00 | 02/13/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-02-12 03:00; End=2026-02-12 15:30) | 168 | 02/12/2026 00:00:00 | 02/12/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-02-05 06:00; End=2026-02-05 12:00) | 156 | 02/05/2026 00:00:00 | 02/05/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-02-05 12:30; End=2026-02-05 13:30) | 156 | 02/05/2026 00:00:00 | 02/05/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-02-04 04:00; End=2026-02-04 08:30) | 154 | 02/04/2026 00:00:00 | 02/04/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-02-02 02:30; End=2026-02-02 03:00) | 154 | 02/02/2026 00:00:00 | 02/02/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-01-20 03:30; End=2026-01-20 20:30) | 154 | 01/20/2026 00:00:00 | 01/20/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-11-24 05:00; End=2025-11-24 18:30) | 154 | 11/24/2025 00:00:00 | 11/24/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-01-26 07:00; End=2026-01-26 11:00) | 154 | 01/26/2026 00:00:00 | 01/26/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80490; PrevEnd=2026-03-17 13:30; GapMinRaw=-450) | 148 | 03/17/2026 00:00:00 | 03/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80604; PrevEnd=2026-03-17 20:30; GapMinRaw=-930) | 148 | 03/17/2026 00:00:00 | 03/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80600; PrevEnd=2026-03-17 17:30; GapMinRaw=-630) | 148 | 03/17/2026 00:00:00 | 03/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80601; PrevEnd=2026-03-17 17:00; GapMinRaw=-660) | 148 | 03/17/2026 00:00:00 | 03/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80709; PrevEnd=2026-03-18 16:30; GapMinRaw=-420) | 148 | 03/18/2026 00:00:00 | 03/18/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80608; PrevEnd=2026-03-17 15:00; GapMinRaw=-540) | 147 | 03/17/2026 00:00:00 | 03/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80814; PrevEnd=2026-03-19 17:00; GapMinRaw=-780) | 147 | 03/19/2026 00:00:00 | 03/19/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80674; PrevEnd=2026-03-17 16:30; GapMinRaw=-600) | 147 | 03/17/2026 00:00:00 | 03/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80714; PrevEnd=2026-03-17 05:30; GapMinRaw=-60) | 146 | 03/17/2026 00:00:00 | 03/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80132; PrevEnd=2026-03-12 06:00; GapMinRaw=-150) | 145 | 03/12/2026 00:00:00 | 03/12/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80940; PrevEnd=2026-03-23 11:30; GapMinRaw=-30) | 144 | 03/23/2026 00:00:00 | 03/23/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80255; PrevEnd=2026-03-13 03:00; GapMinRaw=-420) | 144 | 03/12/2026 00:00:00 | 03/12/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80145; PrevEnd=2026-03-12 16:30; GapMinRaw=-630) | 144 | 03/12/2026 00:00:00 | 03/12/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80267; PrevEnd=2026-03-12 16:30; GapMinRaw=-540) | 144 | 03/12/2026 00:00:00 | 03/12/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80147; PrevEnd=2026-03-12 17:00; GapMinRaw=-630) | 144 | 03/12/2026 00:00:00 | 03/12/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80156; PrevEnd=2026-03-11 18:30; GapMinRaw=-780) | 142 | 03/11/2026 00:00:00 | 03/11/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80936; PrevEnd=2026-03-20 11:30; GapMinRaw=-90) | 142 | 03/20/2026 00:00:00 | 03/20/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80946; PrevEnd=2026-03-19 20:00; GapMinRaw=-840) | 142 | 03/19/2026 00:00:00 | 03/19/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80830; PrevEnd=2026-03-19 16:30; GapMinRaw=-660) | 142 | 03/19/2026 00:00:00 | 03/19/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80155; PrevEnd=2026-03-11 16:00; GapMinRaw=-660) | 142 | 03/11/2026 00:00:00 | 03/11/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80142; PrevEnd=2026-03-11 23:30; GapMinRaw=-1110) | 142 | 03/11/2026 00:00:00 | 03/11/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80727; PrevEnd=2026-03-19 20:30; GapMinRaw=-870) | 142 | 03/19/2026 00:00:00 | 03/19/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80161; PrevEnd=2026-03-11 13:00; GapMinRaw=-390) | 142 | 03/11/2026 00:00:00 | 03/11/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80130; PrevEnd=2026-03-11 06:00; GapMinRaw=-210) | 142 | 03/11/2026 00:00:00 | 03/11/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80165; PrevEnd=2026-03-12 19:30; GapMinRaw=-840) | 141 | 03/12/2026 00:00:00 | 03/12/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80265; PrevEnd=2026-03-11 23:00; GapMinRaw=-510) | 141 | 03/11/2026 00:00:00 | 03/11/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80925; PrevEnd=2026-03-23 07:30; GapMinRaw=-180) | 141 | 03/23/2026 00:00:00 | 03/23/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80355; PrevEnd=2026-03-12 16:00; GapMinRaw=-600) | 140 | 03/12/2026 00:00:00 | 03/12/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80352; PrevEnd=2026-03-13 06:00; GapMinRaw=-660) | 140 | 03/12/2026 00:00:00 | 03/12/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80356; PrevEnd=2026-03-12 18:30; GapMinRaw=-30) | 140 | 03/12/2026 00:00:00 | 03/12/2026 00:00:00 |
| Warn_Overlap (PrevLPID=81143; PrevEnd=2026-03-24 18:30; GapMinRaw=-840) | 139 | 03/24/2026 00:00:00 | 03/24/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79979; PrevEnd=2026-03-09 19:00; GapMinRaw=-810) | 137 | 03/09/2026 00:00:00 | 03/09/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79895; PrevEnd=2026-03-09 20:00; GapMinRaw=-870) | 137 | 03/09/2026 00:00:00 | 03/09/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79875; PrevEnd=2026-03-09 06:00; GapMinRaw=-180) | 137 | 03/09/2026 00:00:00 | 03/09/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80019; PrevEnd=2026-03-11 18:30; GapMinRaw=-690) | 136 | 03/11/2026 00:00:00 | 03/11/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80450; PrevEnd=2026-03-11 16:30; GapMinRaw=-540) | 136 | 03/11/2026 00:00:00 | 03/11/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79687; PrevEnd=2026-03-05 11:30; GapMinRaw=-330) | 135 | 03/05/2026 00:00:00 | 03/05/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79531; PrevEnd=2026-03-04 17:30; GapMinRaw=-720) | 133 | 03/04/2026 00:00:00 | 03/04/2026 00:00:00 |
| Warn_Overlap (PrevLPID=81240; PrevEnd=2026-03-16 18:30; GapMinRaw=-60) | 131 | 03/16/2026 00:00:00 | 03/16/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80585; PrevEnd=2026-03-16 09:00; GapMinRaw=-180) | 131 | 03/16/2026 00:00:00 | 03/16/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79395; PrevEnd=2026-03-03 21:00; GapMinRaw=-120) | 130 | 03/03/2026 00:00:00 | 03/03/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79516; PrevEnd=2026-03-04 05:00; GapMinRaw=-90) | 130 | 03/04/2026 00:00:00 | 03/04/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79357; PrevEnd=2026-03-03 20:00; GapMinRaw=-720) | 130 | 03/03/2026 00:00:00 | 03/03/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79686; PrevEnd=2026-03-05 00:00; GapMinRaw=-360) | 130 | 03/04/2026 00:00:00 | 03/04/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79534; PrevEnd=2026-03-04 17:30; GapMinRaw=-630) | 130 | 03/04/2026 00:00:00 | 03/04/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79261; PrevEnd=2026-03-03 05:00; GapMinRaw=-120) | 130 | 03/03/2026 00:00:00 | 03/03/2026 00:00:00 |
| Warn_Overlap (PrevLPID=81579; PrevEnd=2026-03-31 13:30; GapMinRaw=-390) | 128 | 03/31/2026 00:00:00 | 03/31/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79776; PrevEnd=2026-03-07 06:00; GapMinRaw=-510) | 128 | 03/06/2026 00:00:00 | 03/06/2026 00:00:00 |
| Warn_Overlap (PrevLPID=81687; PrevEnd=2026-03-31 20:00; GapMinRaw=-870) | 125 | 03/31/2026 00:00:00 | 03/31/2026 00:00:00 |
| Warn_Overlap (PrevLPID=81668; PrevEnd=2026-03-31 17:30; GapMinRaw=-750) | 125 | 03/31/2026 00:00:00 | 03/31/2026 00:00:00 |
| Warn_Overlap (PrevLPID=81612; PrevEnd=2026-03-31 15:30; GapMinRaw=-630) | 125 | 03/31/2026 00:00:00 | 03/31/2026 00:00:00 |
| Warn_Overlap (PrevLPID=81695; PrevEnd=2026-03-31 15:30; GapMinRaw=-510) | 125 | 03/31/2026 00:00:00 | 03/31/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79868; PrevEnd=2026-03-06 06:00; GapMinRaw=-510) | 125 | 03/05/2026 00:00:00 | 03/05/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79203; PrevEnd=2026-03-02 13:30; GapMinRaw=-210) | 124 | 03/02/2026 00:00:00 | 03/02/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79539; PrevEnd=2026-03-01 14:30; GapMinRaw=-360) | 124 | 03/01/2026 00:00:00 | 03/01/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79866; PrevEnd=2026-03-04 12:00; GapMinRaw=-150) | 122 | 03/04/2026 00:00:00 | 03/04/2026 00:00:00 |
| Warn_Overlap (PrevLPID=81456; PrevEnd=2026-03-19 08:30; GapMinRaw=-30) | 121 | 03/19/2026 00:00:00 | 03/19/2026 00:00:00 |
| Warn_Overlap (PrevLPID=81454; PrevEnd=2026-03-17 12:00; GapMinRaw=-30) | 120 | 03/17/2026 00:00:00 | 03/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79299; PrevEnd=2026-02-27 19:00; GapMinRaw=-450) | 118 | 02/27/2026 00:00:00 | 02/27/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79326; PrevEnd=2026-02-27 19:00; GapMinRaw=-900) | 118 | 02/27/2026 00:00:00 | 02/27/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82058; PrevEnd=2026-04-07 15:00; GapMinRaw=-600) | 116 | 04/07/2026 00:00:00 | 04/07/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82048; PrevEnd=2026-04-07 03:30; GapMinRaw=-60) | 116 | 04/07/2026 00:00:00 | 04/07/2026 00:00:00 |
| Warn_Overlap (PrevLPID=78948; PrevEnd=2026-02-26 11:30; GapMinRaw=-390) | 115 | 02/26/2026 00:00:00 | 02/26/2026 00:00:00 |
| Warn_Overlap (PrevLPID=78946; PrevEnd=2026-02-26 10:30; GapMinRaw=-360) | 115 | 02/26/2026 00:00:00 | 02/26/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79105; PrevEnd=2026-02-26 21:30; GapMinRaw=-480) | 115 | 02/26/2026 00:00:00 | 02/26/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79103; PrevEnd=2026-02-26 11:30; GapMinRaw=-390) | 115 | 02/26/2026 00:00:00 | 02/26/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79211; PrevEnd=2026-02-26 13:30; GapMinRaw=-420) | 115 | 02/26/2026 00:00:00 | 02/26/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79102; PrevEnd=2026-02-26 13:30; GapMinRaw=-480) | 115 | 02/26/2026 00:00:00 | 02/26/2026 00:00:00 |
| Warn_Overlap (PrevLPID=81958; PrevEnd=2026-04-03 07:00; GapMinRaw=-60) | 113 | 04/03/2026 00:00:00 | 04/03/2026 00:00:00 |
| Warn_Overlap (PrevLPID=81957; PrevEnd=2026-04-03 15:00; GapMinRaw=-540) | 113 | 04/03/2026 00:00:00 | 04/03/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82026; PrevEnd=2026-04-05 10:30; GapMinRaw=-360) | 112 | 04/05/2026 00:00:00 | 04/05/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82240; PrevEnd=2026-04-08 16:00; GapMinRaw=-540) | 111 | 04/08/2026 00:00:00 | 04/08/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82229; PrevEnd=2026-04-08 16:30; GapMinRaw=-780) | 111 | 04/08/2026 00:00:00 | 04/08/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82059; PrevEnd=2026-04-07 15:00; GapMinRaw=-360) | 110 | 04/07/2026 00:00:00 | 04/07/2026 00:00:00 |
| Shift_End <= Shift_Start | 110 | 07/07/2020 00:00:00 | 09/12/2023 00:00:00 |
| Warn_Overlap (PrevLPID=82343; PrevEnd=2026-04-09 19:00; GapMinRaw=-840) | 109 | 04/09/2026 00:00:00 | 04/09/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82248; PrevEnd=2026-04-09 11:00; GapMinRaw=-90) | 109 | 04/09/2026 00:00:00 | 04/09/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82350; PrevEnd=2026-04-09 16:00; GapMinRaw=-300) | 109 | 04/09/2026 00:00:00 | 04/09/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82360; PrevEnd=2026-04-09 18:00; GapMinRaw=-720) | 109 | 04/09/2026 00:00:00 | 04/09/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82219; PrevEnd=2026-04-08 21:30; GapMinRaw=-1050) | 108 | 04/08/2026 00:00:00 | 04/08/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-11-06 06:30; End=2025-11-06 17:00) | 108 | 11/06/2025 00:00:00 | 11/06/2025 00:00:00 |
| Warn_Overlap (PrevLPID=82373; PrevEnd=2026-04-08 17:30; GapMinRaw=-780) | 108 | 04/08/2026 00:00:00 | 04/08/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79301; PrevEnd=2026-02-25 19:30; GapMinRaw=-810) | 106 | 02/25/2026 00:00:00 | 02/25/2026 00:00:00 |
| Warn_Overlap (PrevLPID=78944; PrevEnd=2026-02-25 18:00; GapMinRaw=-690) | 106 | 02/25/2026 00:00:00 | 02/25/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79282; PrevEnd=2026-02-24 18:00; GapMinRaw=-60) | 103 | 02/24/2026 00:00:00 | 02/24/2026 00:00:00 |
| Warn_Overlap (PrevLPID=78716; PrevEnd=2026-02-23 18:30; GapMinRaw=-30) | 100 | 02/23/2026 00:00:00 | 02/23/2026 00:00:00 |
| Warn_Overlap (PrevLPID=78792; PrevEnd=2026-02-23 14:30; GapMinRaw=-420) | 100 | 02/23/2026 00:00:00 | 02/23/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82650; PrevEnd=2026-04-14 17:30; GapMinRaw=-750) | 99 | 04/14/2026 00:00:00 | 04/14/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82651; PrevEnd=2026-04-14 13:00; GapMinRaw=-420) | 99 | 04/14/2026 00:00:00 | 04/14/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82646; PrevEnd=2026-04-14 14:30; GapMinRaw=-360) | 99 | 04/14/2026 00:00:00 | 04/14/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82783; PrevEnd=2026-04-15 16:30; GapMinRaw=-690) | 98 | 04/15/2026 00:00:00 | 04/15/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82474; PrevEnd=2026-04-13 14:00; GapMinRaw=-90) | 98 | 04/13/2026 00:00:00 | 04/13/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82790; PrevEnd=2026-04-15 13:00; GapMinRaw=-420) | 98 | 04/15/2026 00:00:00 | 04/15/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82777; PrevEnd=2026-04-15 17:00; GapMinRaw=-750) | 98 | 04/15/2026 00:00:00 | 04/15/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82905; PrevEnd=2026-04-16 16:00; GapMinRaw=-570) | 97 | 04/16/2026 00:00:00 | 04/16/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82898; PrevEnd=2026-04-16 11:30; GapMinRaw=-330) | 97 | 04/16/2026 00:00:00 | 04/16/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82871; PrevEnd=2026-04-16 14:00; GapMinRaw=-480) | 97 | 04/16/2026 00:00:00 | 04/16/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82723; PrevEnd=2026-04-06 18:00; GapMinRaw=-150) | 94 | 04/06/2026 00:00:00 | 04/06/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83345; PrevEnd=2026-04-23 16:30; GapMinRaw=-300) | 94 | 04/23/2026 00:00:00 | 04/23/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83023; PrevEnd=2026-04-17 16:00; GapMinRaw=-570) | 94 | 04/17/2026 00:00:00 | 04/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83346; PrevEnd=2026-04-23 16:30; GapMinRaw=-300) | 94 | 04/23/2026 00:00:00 | 04/23/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83028; PrevEnd=2026-04-17 17:30; GapMinRaw=-600) | 93 | 04/17/2026 00:00:00 | 04/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83026; PrevEnd=2026-04-17 17:00; GapMinRaw=-630) | 93 | 04/17/2026 00:00:00 | 04/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83627; PrevEnd=2026-04-22 10:30; GapMinRaw=-300) | 89 | 04/22/2026 00:00:00 | 04/22/2026 00:00:00 |
| Warn_Overlap (PrevLPID=78666; PrevEnd=2026-02-18 14:30; GapMinRaw=-60) | 89 | 02/18/2026 00:00:00 | 02/18/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83776; PrevEnd=2026-04-28 18:30; GapMinRaw=-750) | 88 | 04/28/2026 00:00:00 | 04/28/2026 00:00:00 |
| Warn_Overlap (PrevLPID=78670; PrevEnd=2026-02-17 10:00; GapMinRaw=-60) | 88 | 02/17/2026 00:00:00 | 02/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83763; PrevEnd=2026-04-28 13:30; GapMinRaw=-390) | 88 | 04/28/2026 00:00:00 | 04/28/2026 00:00:00 |
| Warn_Overlap (PrevLPID=78340; PrevEnd=2026-02-17 07:30; GapMinRaw=-240) | 88 | 02/17/2026 00:00:00 | 02/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83774; PrevEnd=2026-04-28 19:00; GapMinRaw=-1050) | 88 | 04/28/2026 00:00:00 | 04/28/2026 00:00:00 |
| Warn_Overlap (PrevLPID=78188; PrevEnd=2026-02-13 19:00; GapMinRaw=-30) | 85 | 02/13/2026 00:00:00 | 02/13/2026 00:00:00 |
| Warn_Overlap (PrevLPID=78221; PrevEnd=2026-02-13 18:30; GapMinRaw=-30) | 85 | 02/13/2026 00:00:00 | 02/13/2026 00:00:00 |
| Warn_Overlap (PrevLPID=78187; PrevEnd=2026-02-13 18:00; GapMinRaw=-120) | 85 | 02/13/2026 00:00:00 | 02/13/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83907; PrevEnd=2026-04-30 10:30; GapMinRaw=-30) | 84 | 04/30/2026 00:00:00 | 04/30/2026 00:00:00 |
| Warn_Overlap (PrevLPID=78103; PrevEnd=2026-02-12 13:30; GapMinRaw=-90) | 84 | 02/12/2026 00:00:00 | 02/12/2026 00:00:00 |
| Warn_Overlap (PrevLPID=77969; PrevEnd=2026-02-11 07:00; GapMinRaw=-120) | 83 | 02/11/2026 00:00:00 | 02/11/2026 00:00:00 |
| Warn_Overlap (PrevLPID=78041; PrevEnd=2026-02-11 10:00; GapMinRaw=-120) | 83 | 02/11/2026 00:00:00 | 02/11/2026 00:00:00 |
| Warn_Overlap (PrevLPID=78000; PrevEnd=2026-02-10 16:00; GapMinRaw=-600) | 82 | 02/10/2026 00:00:00 | 02/10/2026 00:00:00 |
| Warn_Overlap (PrevLPID=77949; PrevEnd=2026-02-09 16:30; GapMinRaw=-600) | 81 | 02/09/2026 00:00:00 | 02/09/2026 00:00:00 |
| Warn_Overlap (PrevLPID=77850; PrevEnd=2026-02-09 16:00; GapMinRaw=-120) | 81 | 02/09/2026 00:00:00 | 02/09/2026 00:00:00 |
| Warn_Overlap (PrevLPID=77832; PrevEnd=2026-02-09 19:00; GapMinRaw=-660) | 81 | 02/09/2026 00:00:00 | 02/09/2026 00:00:00 |
| Warn_Overlap (PrevLPID=78863; PrevEnd=2026-02-09 18:00; GapMinRaw=-120) | 81 | 02/09/2026 00:00:00 | 02/09/2026 00:00:00 |
| Warn_Overlap (PrevLPID=74150; PrevEnd=2025-12-08 15:00; GapMinRaw=-150) | 78 | 12/08/2025 00:00:00 | 12/08/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73728; PrevEnd=2025-11-25 19:00; GapMinRaw=-810) | 78 | 11/25/2025 00:00:00 | 11/25/2025 00:00:00 |
| Warn_Overlap (PrevLPID=75562; PrevEnd=2025-12-08 15:30; GapMinRaw=-30) | 78 | 12/08/2025 00:00:00 | 12/08/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73800; PrevEnd=2025-11-25 19:00; GapMinRaw=-660) | 78 | 11/25/2025 00:00:00 | 11/25/2025 00:00:00 |
| Warn_Overlap (PrevLPID=78085; PrevEnd=2026-02-05 13:30; GapMinRaw=-30) | 78 | 02/05/2026 00:00:00 | 02/05/2026 00:00:00 |
| Warn_Overlap (PrevLPID=75878; PrevEnd=2026-01-07 11:00; GapMinRaw=-300) | 77 | 01/07/2026 00:00:00 | 01/07/2026 00:00:00 |
| Warn_Overlap (PrevLPID=76744; PrevEnd=2026-01-22 18:00; GapMinRaw=-690) | 77 | 01/22/2026 00:00:00 | 01/22/2026 00:00:00 |
| Warn_Overlap (PrevLPID=76588; PrevEnd=2026-01-20 10:00; GapMinRaw=-150) | 77 | 01/20/2026 00:00:00 | 01/20/2026 00:00:00 |
| Warn_Overlap (PrevLPID=77214; PrevEnd=2026-01-30 14:00; GapMinRaw=-120) | 77 | 01/30/2026 00:00:00 | 01/30/2026 00:00:00 |
| Warn_Overlap (PrevLPID=75001; PrevEnd=2025-12-18 13:00; GapMinRaw=-420) | 77 | 12/18/2025 00:00:00 | 12/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=75664; PrevEnd=2026-01-13 19:00; GapMinRaw=-720) | 77 | 01/13/2026 00:00:00 | 01/13/2026 00:00:00 |
| Warn_Overlap (PrevLPID=73455; PrevEnd=2025-11-24 18:30; GapMinRaw=-810) | 77 | 11/24/2025 00:00:00 | 11/24/2025 00:00:00 |
| Warn_Overlap (PrevLPID=75417; PrevEnd=2025-12-22 14:00; GapMinRaw=-60) | 77 | 12/22/2025 00:00:00 | 12/22/2025 00:00:00 |
| Warn_Overlap (PrevLPID=77302; PrevEnd=2026-01-29 06:30; GapMinRaw=-30) | 77 | 01/29/2026 00:00:00 | 01/29/2026 00:00:00 |
| Warn_Overlap (PrevLPID=75226; PrevEnd=2025-12-29 10:30; GapMinRaw=-210) | 77 | 12/29/2025 00:00:00 | 12/29/2025 00:00:00 |
| Warn_Overlap (PrevLPID=74563; PrevEnd=2025-12-10 19:30; GapMinRaw=-870) | 77 | 12/10/2025 00:00:00 | 12/10/2025 00:00:00 |
| Warn_Overlap (PrevLPID=75819; PrevEnd=2026-01-09 07:30; GapMinRaw=-60) | 77 | 01/09/2026 00:00:00 | 01/09/2026 00:00:00 |
| Warn_Overlap (PrevLPID=74418; PrevEnd=2025-12-11 17:30; GapMinRaw=-630) | 77 | 12/11/2025 00:00:00 | 12/11/2025 00:00:00 |
| Warn_Overlap (PrevLPID=77373; PrevEnd=2026-02-02 18:00; GapMinRaw=-930) | 77 | 02/02/2026 00:00:00 | 02/02/2026 00:00:00 |
| Warn_Overlap (PrevLPID=76318; PrevEnd=2026-01-15 21:30; GapMinRaw=-1050) | 77 | 01/15/2026 00:00:00 | 01/15/2026 00:00:00 |
| Warn_Overlap (PrevLPID=76324; PrevEnd=2026-01-18 12:00; GapMinRaw=-270) | 77 | 01/18/2026 00:00:00 | 01/18/2026 00:00:00 |
| Warn_Overlap (PrevLPID=75057; PrevEnd=2025-12-22 18:00; GapMinRaw=-360) | 77 | 12/22/2025 00:00:00 | 12/22/2025 00:00:00 |
| Warn_Overlap (PrevLPID=76042; PrevEnd=2026-01-15 11:00; GapMinRaw=-360) | 77 | 01/15/2026 00:00:00 | 01/15/2026 00:00:00 |
| Warn_Overlap (PrevLPID=74939; PrevEnd=2025-12-17 10:30; GapMinRaw=-240) | 77 | 12/17/2025 00:00:00 | 12/17/2025 00:00:00 |
| Warn_Overlap (PrevLPID=74780; PrevEnd=2025-12-17 18:30; GapMinRaw=-630) | 77 | 12/17/2025 00:00:00 | 12/17/2025 00:00:00 |
| Warn_Overlap (PrevLPID=74802; PrevEnd=2025-12-17 12:00; GapMinRaw=-240) | 77 | 12/17/2025 00:00:00 | 12/17/2025 00:00:00 |
| Warn_Overlap (PrevLPID=76863; PrevEnd=2026-01-20 11:00; GapMinRaw=-60) | 77 | 01/20/2026 00:00:00 | 01/20/2026 00:00:00 |
| Warn_Overlap (PrevLPID=75663; PrevEnd=2026-01-13 19:00; GapMinRaw=-720) | 77 | 01/13/2026 00:00:00 | 01/13/2026 00:00:00 |
| Warn_Overlap (PrevLPID=84352; PrevEnd=2026-05-06 11:00; GapMinRaw=-60) | 76 | 05/06/2026 00:00:00 | 05/06/2026 00:00:00 |
| Warn_Overlap (PrevLPID=84342; PrevEnd=2026-04-27 18:30; GapMinRaw=-30) | 76 | 04/27/2026 00:00:00 | 04/27/2026 00:00:00 |
| Warn_Overlap (PrevLPID=84331; PrevEnd=2026-04-21 18:00; GapMinRaw=-270) | 76 | 04/21/2026 00:00:00 | 04/21/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82235; PrevEnd=2026-03-01 19:00; GapMinRaw=-300) | 75 | 03/01/2026 00:00:00 | 03/01/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80822; PrevEnd=2026-03-19 14:30; GapMinRaw=-600) | 75 | 03/19/2026 00:00:00 | 03/19/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82527; PrevEnd=2026-03-01 16:00; GapMinRaw=-90) | 75 | 03/01/2026 00:00:00 | 03/01/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83238; PrevEnd=2026-03-19 15:00; GapMinRaw=-570) | 75 | 03/19/2026 00:00:00 | 03/19/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80823; PrevEnd=2026-03-19 14:30; GapMinRaw=-600) | 75 | 03/19/2026 00:00:00 | 03/19/2026 00:00:00 |
| Warn_Overlap (PrevLPID=84446; PrevEnd=2026-05-01 06:30; GapMinRaw=-210) | 74 | 05/01/2026 00:00:00 | 05/01/2026 00:00:00 |
| Warn_Overlap (PrevLPID=73457; PrevEnd=2025-11-22 12:30; GapMinRaw=-390) | 74 | 11/22/2025 00:00:00 | 11/22/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73129; PrevEnd=2025-11-20 16:30; GapMinRaw=-630) | 72 | 11/20/2025 00:00:00 | 11/20/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73159; PrevEnd=2025-11-20 16:30; GapMinRaw=-630) | 72 | 11/20/2025 00:00:00 | 11/20/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73392; PrevEnd=2025-11-20 13:30; GapMinRaw=-90) | 72 | 11/20/2025 00:00:00 | 11/20/2025 00:00:00 |
| Warn_Overlap (PrevLPID=80822; PrevEnd=2026-03-19 14:30; GapMinRaw=-540) | 72 | 03/19/2026 00:00:00 | 03/19/2026 00:00:00 |
| Warn_Overlap (PrevLPID=73059; PrevEnd=2025-11-19 16:30; GapMinRaw=-630) | 71 | 11/19/2025 00:00:00 | 11/19/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73136; PrevEnd=2025-11-19 19:30; GapMinRaw=-690) | 71 | 11/19/2025 00:00:00 | 11/19/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73104; PrevEnd=2025-11-19 16:30; GapMinRaw=-630) | 71 | 11/19/2025 00:00:00 | 11/19/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73389; PrevEnd=2025-11-19 13:30; GapMinRaw=-480) | 71 | 11/19/2025 00:00:00 | 11/19/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73137; PrevEnd=2025-11-19 19:30; GapMinRaw=-690) | 71 | 11/19/2025 00:00:00 | 11/19/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73063; PrevEnd=2025-11-18 09:00; GapMinRaw=-120) | 70 | 11/18/2025 00:00:00 | 11/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73314; PrevEnd=2025-11-18 07:00; GapMinRaw=-30) | 70 | 11/18/2025 00:00:00 | 11/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73096; PrevEnd=2025-11-18 17:00; GapMinRaw=-540) | 70 | 11/18/2025 00:00:00 | 11/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73138; PrevEnd=2025-11-18 17:00; GapMinRaw=-540) | 70 | 11/18/2025 00:00:00 | 11/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73050; PrevEnd=2025-11-18 23:00; GapMinRaw=-330) | 70 | 11/18/2025 00:00:00 | 11/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73000; PrevEnd=2025-11-18 16:30; GapMinRaw=-630) | 70 | 11/18/2025 00:00:00 | 11/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73039; PrevEnd=2025-11-18 17:00; GapMinRaw=-540) | 70 | 11/18/2025 00:00:00 | 11/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73025; PrevEnd=2025-11-18 16:30; GapMinRaw=-630) | 70 | 11/18/2025 00:00:00 | 11/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73054; PrevEnd=2025-11-18 17:00; GapMinRaw=-540) | 70 | 11/18/2025 00:00:00 | 11/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73062; PrevEnd=2025-11-18 17:00; GapMinRaw=-540) | 70 | 11/18/2025 00:00:00 | 11/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73061; PrevEnd=2025-11-18 17:00; GapMinRaw=-540) | 70 | 11/18/2025 00:00:00 | 11/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73139; PrevEnd=2025-11-18 17:00; GapMinRaw=-540) | 70 | 11/18/2025 00:00:00 | 11/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73313; PrevEnd=2025-11-18 07:00; GapMinRaw=-30) | 70 | 11/18/2025 00:00:00 | 11/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73291; PrevEnd=2025-11-18 17:00; GapMinRaw=-540) | 70 | 11/18/2025 00:00:00 | 11/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=72939; PrevEnd=2025-11-17 16:30; GapMinRaw=-630) | 69 | 11/17/2025 00:00:00 | 11/17/2025 00:00:00 |
| Warn_Overlap (PrevLPID=72977; PrevEnd=2025-11-17 17:00; GapMinRaw=-540) | 69 | 11/17/2025 00:00:00 | 11/17/2025 00:00:00 |
| Warn_Overlap (PrevLPID=72976; PrevEnd=2025-11-17 17:00; GapMinRaw=-540) | 69 | 11/17/2025 00:00:00 | 11/17/2025 00:00:00 |
| Warn_Overlap (PrevLPID=72978; PrevEnd=2025-11-17 15:00; GapMinRaw=-420) | 69 | 11/17/2025 00:00:00 | 11/17/2025 00:00:00 |
| Warn_Overlap (PrevLPID=72979; PrevEnd=2025-11-17 15:00; GapMinRaw=-420) | 69 | 11/17/2025 00:00:00 | 11/17/2025 00:00:00 |
| Warn_Overlap (PrevLPID=72967; PrevEnd=2025-11-17 16:30; GapMinRaw=-510) | 69 | 11/17/2025 00:00:00 | 11/17/2025 00:00:00 |
| Warn_Overlap (PrevLPID=72914; PrevEnd=2025-11-14 15:00; GapMinRaw=-270) | 66 | 11/14/2025 00:00:00 | 11/14/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-10-24 04:30; End=2025-10-24 21:00) | 66 | 10/24/2025 00:00:00 | 10/24/2025 00:00:00 |
| Warn_Overlap (PrevLPID=72915; PrevEnd=2025-11-14 15:00; GapMinRaw=-270) | 66 | 11/14/2025 00:00:00 | 11/14/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-10-23 06:00; End=2025-10-23 10:00) | 64 | 10/23/2025 00:00:00 | 10/23/2025 00:00:00 |
| Warn_Overlap (PrevLPID=72823; PrevEnd=2025-11-12 17:30; GapMinRaw=-570) | 63 | 11/12/2025 00:00:00 | 11/12/2025 00:00:00 |
| Warn_Overlap (PrevLPID=72821; PrevEnd=2025-11-12 18:00; GapMinRaw=-720) | 63 | 11/12/2025 00:00:00 | 11/12/2025 00:00:00 |
| Warn_Overlap (PrevLPID=73038; PrevEnd=2025-11-12 17:00; GapMinRaw=-660) | 63 | 11/12/2025 00:00:00 | 11/12/2025 00:00:00 |
| Warn_Overlap (PrevLPID=72694; PrevEnd=2025-11-08 20:00; GapMinRaw=-870) | 58 | 11/08/2025 00:00:00 | 11/08/2025 00:00:00 |
| Warn_Overlap (PrevLPID=72610; PrevEnd=2025-11-07 17:30; GapMinRaw=-690) | 55 | 11/07/2025 00:00:00 | 11/07/2025 00:00:00 |
| Warn_Overlap (PrevLPID=85130; PrevEnd=2026-05-13 14:30; GapMinRaw=-120) | 54 | 05/13/2026 00:00:00 | 05/13/2026 00:00:00 |
| Warn_Overlap (PrevLPID=85264; PrevEnd=2026-05-19 11:00; GapMinRaw=-300) | 52 | 05/19/2026 00:00:00 | 05/19/2026 00:00:00 |
| Warn_Overlap (PrevLPID=85403; PrevEnd=2026-05-20 19:30; GapMinRaw=-810) | 49 | 05/20/2026 00:00:00 | 05/20/2026 00:00:00 |
| Warn_Overlap (PrevLPID=71996; PrevEnd=2025-10-30 18:00; GapMinRaw=-780) | 43 | 10/30/2025 00:00:00 | 10/30/2025 00:00:00 |
| Warn_Overlap (PrevLPID=71995; PrevEnd=2025-10-30 14:00; GapMinRaw=-390) | 43 | 10/30/2025 00:00:00 | 10/30/2025 00:00:00 |
| Warn_Overlap (PrevLPID=71765; PrevEnd=2025-10-29 19:00; GapMinRaw=-60) | 42 | 10/29/2025 00:00:00 | 10/29/2025 00:00:00 |
| Warn_Overlap (PrevLPID=71985; PrevEnd=2025-10-28 17:30; GapMinRaw=-750) | 41 | 10/28/2025 00:00:00 | 10/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=75028; PrevEnd=2025-10-28 22:30; GapMinRaw=-750) | 41 | 10/28/2025 00:00:00 | 10/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=71984; PrevEnd=2025-10-28 18:30; GapMinRaw=-780) | 41 | 10/28/2025 00:00:00 | 10/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=72074; PrevEnd=2025-10-28 18:00; GapMinRaw=-750) | 41 | 10/28/2025 00:00:00 | 10/28/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-06-01 06:00; End=2026-06-01 11:00) | 40 | 06/01/2026 00:00:00 | 06/01/2026 00:00:00 |
| Warn_Overlap (PrevLPID=85355; PrevEnd=2026-05-20 02:30; GapMinRaw=-150) | 37 | 05/20/2026 00:00:00 | 05/20/2026 00:00:00 |
| Warn_Overlap (PrevLPID=71998; PrevEnd=2025-10-26 02:30; GapMinRaw=-1080) | 34 | 10/25/2025 00:00:00 | 10/25/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-06-02 06:00; End=2026-06-02 10:00) | 34 | 06/02/2026 00:00:00 | 06/02/2026 00:00:00 |
| Warn_Overlap (PrevLPID=71584; PrevEnd=2025-10-24 21:00; GapMinRaw=-870) | 33 | 10/24/2025 00:00:00 | 10/24/2025 00:00:00 |
| Warn_Overlap (PrevLPID=71666; PrevEnd=2025-10-23 11:00; GapMinRaw=-30) | 32 | 10/23/2025 00:00:00 | 10/23/2025 00:00:00 |
| Warn_Overlap (PrevLPID=71267; PrevEnd=2025-10-23 06:30; GapMinRaw=-270) | 32 | 10/23/2025 00:00:00 | 10/23/2025 00:00:00 |
| Warn_Overlap (PrevLPID=71618; PrevEnd=2025-10-23 14:30; GapMinRaw=-180) | 32 | 10/23/2025 00:00:00 | 10/23/2025 00:00:00 |
| Warn_Overlap (PrevLPID=86048; PrevEnd=2026-05-28 20:00; GapMinRaw=-720) | 31 | 05/28/2026 00:00:00 | 05/28/2026 00:00:00 |
| Warn_Overlap (PrevLPID=86033; PrevEnd=2026-05-21 11:00; GapMinRaw=-30) | 31 | 05/21/2026 00:00:00 | 05/21/2026 00:00:00 |
| Warn_Overlap (PrevLPID=70984; PrevEnd=2025-10-22 15:00; GapMinRaw=-30) | 30 | 10/22/2025 00:00:00 | 10/22/2025 00:00:00 |
| Warn_Overlap (PrevLPID=71173; PrevEnd=2025-10-22 05:00; GapMinRaw=-720) | 26 | 10/21/2025 00:00:00 | 10/21/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=5; Start=2021-06-04 05:30; End=2021-06-04 10:30) | 25 | 06/04/2021 00:00:00 | 06/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=86341; PrevEnd=2026-06-03 12:30; GapMinRaw=-360) | 24 | 06/03/2026 00:00:00 | 06/03/2026 00:00:00 |
| Warn_Overlap (PrevLPID=85468; PrevEnd=2026-05-04 17:00; GapMinRaw=-60) | 24 | 05/04/2026 00:00:00 | 05/04/2026 00:00:00 |
| Warn_Overlap (PrevLPID=86342; PrevEnd=2026-06-03 12:30; GapMinRaw=-360) | 24 | 06/03/2026 00:00:00 | 06/03/2026 00:00:00 |
| WTL error: multiple or conflicting WTL tokens found. | 19 | 06/03/2026 00:00:00 | 06/20/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=3; Start=2025-05-13 06:00; End=2025-05-13 18:30) | 18 | 05/13/2025 00:00:00 | 05/13/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=3; Start=2025-05-12 04:00; End=2025-05-12 14:30) | 18 | 05/12/2025 00:00:00 | 05/12/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=3; Start=2025-01-24 06:00; End=2025-01-24 22:00) | 18 | 01/24/2025 00:00:00 | 01/24/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=3; Start=2025-05-13 04:00; End=2025-05-13 10:00) | 18 | 05/13/2025 00:00:00 | 05/13/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=3; Start=2025-01-15 06:00; End=2025-01-15 22:00) | 18 | 01/15/2025 00:00:00 | 01/15/2025 00:00:00 |
| Warn_Overlap (PrevLPID=85094; PrevEnd=2026-05-16 10:30; GapMinRaw=-450) | 18 | 05/16/2026 00:00:00 | 05/16/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-05-19 13:30; End=2026-05-19 16:30) | 16 | 05/19/2026 00:00:00 | 05/19/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=3; Start=2023-06-29 05:30; End=2023-06-29 13:00) | 15 | 06/29/2023 00:00:00 | 06/29/2023 00:00:00 |
| Warn_Overlap (PrevLPID=81129; PrevEnd=2026-03-25 06:30; GapMinRaw=-90) | 15 | 03/25/2026 00:00:00 | 03/25/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=3; Start=2024-04-17 05:30; End=2024-04-17 23:30) | 15 | 04/17/2024 00:00:00 | 04/17/2024 00:00:00 |
| Warn_Overlap (PrevLPID=81128; PrevEnd=2026-03-25 06:30; GapMinRaw=-90) | 15 | 03/25/2026 00:00:00 | 03/25/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=3; Start=2024-03-13 19:00; End=2024-03-14 08:00) | 15 | 03/13/2024 00:00:00 | 03/13/2024 00:00:00 |
| WTL review: grouped labor span exceeds configured threshold. | 15 | 09/22/2025 00:00:00 | 05/20/2026 00:00:00 |
| Warn_Reconstruction_Possible24Plus \| Shift_Assumed (StdStart+HoursWorked) | 15 | 09/06/2022 00:00:00 | 08/05/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-01-06 06:30; End=2025-01-06 11:30) | 14 | 01/06/2025 00:00:00 | 01/06/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-08-06 06:00; End=2025-08-06 18:00) | 14 | 08/06/2025 00:00:00 | 08/06/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-01-10 04:30; End=2025-01-10 13:00) | 14 | 01/10/2025 00:00:00 | 01/10/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-01-09 11:30; End=2025-01-09 19:30) | 14 | 01/09/2025 00:00:00 | 01/09/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-06-13 05:30; End=2026-06-13 15:30) | 14 | 06/13/2026 00:00:00 | 06/13/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-01-10 02:30; End=2025-01-10 17:00) | 14 | 01/10/2025 00:00:00 | 01/10/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-06-25 05:30; End=2025-06-25 22:30) | 12 | 06/25/2025 00:00:00 | 06/25/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-05-14 06:30; End=2025-05-14 14:30) | 12 | 05/14/2025 00:00:00 | 05/14/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-04-11 06:30; End=2025-04-11 10:30) | 12 | 04/11/2025 00:00:00 | 04/11/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-01-20 05:00; End=2025-01-20 21:00) | 12 | 01/20/2025 00:00:00 | 01/20/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-04-21 19:00; End=2025-04-22 07:00) | 12 | 04/21/2025 00:00:00 | 04/21/2025 00:00:00 |
| Warn_Overlap (PrevLPID=86675; PrevEnd=2026-06-08 19:30; GapMinRaw=-30) | 12 | 06/08/2026 00:00:00 | 06/08/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-07-10 05:30; End=2025-07-10 19:00) | 12 | 07/10/2025 00:00:00 | 07/10/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-05-22 05:00; End=2025-05-22 16:30) | 12 | 05/22/2025 00:00:00 | 05/22/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-05-02 06:00; End=2025-05-02 16:30) | 12 | 05/02/2025 00:00:00 | 05/02/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-06-11 05:00; End=2025-06-11 09:00) | 12 | 06/11/2025 00:00:00 | 06/11/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-05-14 03:30; End=2025-05-14 10:30) | 12 | 05/14/2025 00:00:00 | 05/14/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-05-15 08:00; End=2025-05-15 12:00) | 12 | 05/15/2025 00:00:00 | 05/15/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-01-25 06:00; End=2025-01-25 16:00) | 12 | 01/25/2025 00:00:00 | 01/25/2025 00:00:00 |
| Warn_Overlap (PrevLPID=83990; PrevEnd=2026-05-02 09:00; GapMinRaw=-120) | 12 | 05/02/2026 00:00:00 | 05/02/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-05-13 03:30; End=2025-05-13 16:00) | 12 | 05/13/2025 00:00:00 | 05/13/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-05-06 06:30; End=2025-05-06 19:30) | 12 | 05/06/2025 00:00:00 | 05/06/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-05-13 22:00; End=2025-05-14 04:00) | 12 | 05/13/2025 00:00:00 | 05/13/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-03-03 07:00; End=2025-03-03 16:30) | 12 | 03/03/2025 00:00:00 | 03/03/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-01-17 05:00; End=2025-01-18 02:00) | 12 | 01/17/2025 00:00:00 | 01/17/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-01-25 06:00; End=2025-01-25 22:00) | 12 | 01/25/2025 00:00:00 | 01/25/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2025-05-01 06:00; End=2025-05-01 16:30) | 12 | 05/01/2025 00:00:00 | 05/01/2025 00:00:00 |
| Warn_Overlap (PrevLPID=79435; PrevEnd=2026-03-04 15:00; GapMinRaw=-420) | 11 | 03/04/2026 00:00:00 | 03/04/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79518; PrevEnd=2026-03-05 10:00; GapMinRaw=-240) | 11 | 03/05/2026 00:00:00 | 03/05/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79517; PrevEnd=2026-03-05 10:00; GapMinRaw=-240) | 11 | 03/05/2026 00:00:00 | 03/05/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79536; PrevEnd=2026-03-05 15:30; GapMinRaw=-450) | 11 | 03/05/2026 00:00:00 | 03/05/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2023-06-28 03:00; End=2023-06-28 16:00) | 10 | 06/28/2023 00:00:00 | 06/28/2023 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-10-18 10:00; End=2024-10-18 12:00) | 10 | 10/18/2024 00:00:00 | 10/18/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-10-17 06:00; End=2024-10-17 15:30) | 10 | 10/17/2024 00:00:00 | 10/17/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2020-07-10 21:00; End=2020-07-10 23:00) | 10 | 07/10/2020 00:00:00 | 07/10/2020 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2020-07-16 06:30; End=2020-07-16 12:00) | 10 | 07/16/2020 00:00:00 | 07/16/2020 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2020-12-22 07:00; End=2020-12-22 10:30) | 10 | 12/22/2020 00:00:00 | 12/22/2020 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2022-01-19 07:00; End=2022-01-19 12:00) | 10 | 01/19/2022 00:00:00 | 01/19/2022 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2020-07-18 07:00; End=2020-07-18 13:30) | 10 | 07/18/2020 00:00:00 | 07/18/2020 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2022-05-09 03:30; End=2022-05-09 17:30) | 10 | 05/09/2022 00:00:00 | 05/09/2022 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-09-03 06:00; End=2024-09-03 18:00) | 10 | 09/03/2024 00:00:00 | 09/03/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-03-28 08:00; End=2024-03-28 15:00) | 10 | 03/28/2024 00:00:00 | 03/28/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2022-04-07 05:00; End=2022-04-07 11:30) | 10 | 04/07/2022 00:00:00 | 04/07/2022 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-03-16 19:00; End=2024-03-17 08:00) | 10 | 03/16/2024 00:00:00 | 03/16/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2023-09-19 18:00; End=2023-09-19 21:00) | 10 | 09/19/2023 00:00:00 | 09/19/2023 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-03-18 19:00; End=2024-03-19 08:00) | 10 | 03/18/2024 00:00:00 | 03/18/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-01-24 07:00; End=2024-01-24 19:00) | 10 | 01/24/2024 00:00:00 | 01/24/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2020-07-06 15:30; End=2020-07-06 16:30) | 10 | 07/06/2020 00:00:00 | 07/06/2020 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-03-21 19:00; End=2024-03-22 08:00) | 10 | 03/21/2024 00:00:00 | 03/21/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-03-20 19:00; End=2024-03-21 08:00) | 10 | 03/20/2024 00:00:00 | 03/20/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-06-22 03:00; End=2024-06-22 17:00) | 10 | 06/22/2024 00:00:00 | 06/22/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2023-07-13 04:30; End=2023-07-13 10:00) | 10 | 07/13/2023 00:00:00 | 07/13/2023 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-03-12 19:00; End=2024-03-13 08:00) | 10 | 03/12/2024 00:00:00 | 03/12/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-03-14 19:00; End=2024-03-15 08:00) | 10 | 03/14/2024 00:00:00 | 03/14/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2020-07-26 07:00; End=2020-07-26 08:30) | 10 | 07/26/2020 00:00:00 | 07/26/2020 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2020-10-22 06:00; End=2020-10-22 14:30) | 10 | 10/22/2020 00:00:00 | 10/22/2020 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2020-09-03 06:00; End=2020-09-03 14:30) | 10 | 09/03/2020 00:00:00 | 09/03/2020 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-12-10 05:00; End=2024-12-10 11:00) | 10 | 12/10/2024 00:00:00 | 12/10/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2020-12-30 12:00; End=2020-12-30 12:30) | 10 | 12/30/2020 00:00:00 | 12/30/2020 00:00:00 |
| Warn_Overlap (PrevLPID=80563; PrevEnd=2026-03-16 09:00; GapMinRaw=-90) | 10 | 03/16/2026 00:00:00 | 03/16/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2022-05-20 03:30; End=2022-05-20 20:00) | 10 | 05/20/2022 00:00:00 | 05/20/2022 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2022-12-23 07:30; End=2022-12-23 15:30) | 10 | 12/23/2022 00:00:00 | 12/23/2022 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-02-28 17:00; End=2024-02-29 07:00) | 10 | 02/28/2024 00:00:00 | 02/28/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-01-26 07:00; End=2024-01-26 19:00) | 10 | 01/26/2024 00:00:00 | 01/26/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-07-18 06:00; End=2024-07-18 18:00) | 10 | 07/18/2024 00:00:00 | 07/18/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2022-04-14 17:00; End=2022-04-15 04:00) | 10 | 04/14/2022 00:00:00 | 04/14/2022 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-11-26 07:30; End=2024-11-26 16:00) | 10 | 11/26/2024 00:00:00 | 11/26/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-08-15 03:30; End=2024-08-15 17:00) | 10 | 08/15/2024 00:00:00 | 08/15/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2020-08-14 14:30; End=2020-08-14 16:30) | 10 | 08/14/2020 00:00:00 | 08/14/2020 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2021-06-24 06:00; End=2021-06-24 07:00) | 10 | 06/24/2021 00:00:00 | 06/24/2021 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-06-04 04:30; End=2024-06-04 14:30) | 10 | 06/04/2024 00:00:00 | 06/04/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2020-07-26 14:30; End=2020-07-26 15:00) | 10 | 07/26/2020 00:00:00 | 07/26/2020 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2023-06-28 06:30; End=2023-06-28 21:00) | 10 | 06/28/2023 00:00:00 | 06/28/2023 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2023-06-22 03:30; End=2023-06-22 12:30) | 10 | 06/22/2023 00:00:00 | 06/22/2023 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2020-07-15 07:00; End=2020-07-15 15:30) | 10 | 07/15/2020 00:00:00 | 07/15/2020 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-01-25 07:00; End=2024-01-25 19:00) | 10 | 01/25/2024 00:00:00 | 01/25/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-05-14 06:30; End=2024-05-14 13:30) | 10 | 05/14/2024 00:00:00 | 05/14/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2020-09-26 04:30; End=2020-09-26 11:30) | 10 | 09/26/2020 00:00:00 | 09/26/2020 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-03-23 19:00; End=2024-03-24 08:00) | 10 | 03/23/2024 00:00:00 | 03/23/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-03-01 19:00; End=2024-03-02 09:00) | 10 | 03/01/2024 00:00:00 | 03/01/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2023-04-10 05:00; End=2023-04-10 20:00) | 10 | 04/10/2023 00:00:00 | 04/10/2023 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2022-06-20 08:00; End=2022-06-20 14:30) | 10 | 06/20/2022 00:00:00 | 06/20/2022 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-02-29 19:00; End=2024-03-01 07:00) | 10 | 02/29/2024 00:00:00 | 02/29/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-03-11 17:00; End=2024-03-12 08:00) | 10 | 03/11/2024 00:00:00 | 03/11/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2022-05-05 06:30; End=2022-05-05 14:30) | 10 | 05/05/2022 00:00:00 | 05/05/2022 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2022-05-23 07:00; End=2022-05-23 13:30) | 10 | 05/23/2022 00:00:00 | 05/23/2022 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2022-07-01 06:00; End=2022-07-01 18:00) | 10 | 07/01/2022 00:00:00 | 07/01/2022 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-12-11 04:30; End=2024-12-11 16:30) | 10 | 12/11/2024 00:00:00 | 12/11/2024 00:00:00 |
| Warn_Overlap (PrevLPID=80568; PrevEnd=2026-03-16 09:00; GapMinRaw=-90) | 10 | 03/16/2026 00:00:00 | 03/16/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2022-04-01 10:30; End=2022-04-01 11:00) | 10 | 04/01/2022 00:00:00 | 04/01/2022 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2022-05-17 06:30; End=2022-05-17 12:00) | 10 | 05/17/2022 00:00:00 | 05/17/2022 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-01-09 05:00; End=2024-01-09 19:30) | 10 | 01/09/2024 00:00:00 | 01/09/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-03-17 19:00; End=2024-03-18 08:00) | 10 | 03/17/2024 00:00:00 | 03/17/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2022-07-29 05:00; End=2022-07-29 13:00) | 10 | 07/29/2022 00:00:00 | 07/29/2022 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2023-06-08 06:00; End=2023-06-08 17:00) | 10 | 06/08/2023 00:00:00 | 06/08/2023 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2022-10-05 19:00; End=2022-10-06 05:30) | 10 | 10/05/2022 00:00:00 | 10/05/2022 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2022-05-16 04:00; End=2022-05-16 10:30) | 10 | 05/16/2022 00:00:00 | 05/16/2022 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-03-19 19:00; End=2024-03-20 08:00) | 10 | 03/19/2024 00:00:00 | 03/19/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-08-29 06:00; End=2024-08-29 16:00) | 10 | 08/29/2024 00:00:00 | 08/29/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-03-22 19:00; End=2024-03-23 08:00) | 10 | 03/22/2024 00:00:00 | 03/22/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-03-21 06:00; End=2024-03-21 16:00) | 10 | 03/21/2024 00:00:00 | 03/21/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2020-10-27 07:00; End=2020-10-27 13:30) | 10 | 10/27/2020 00:00:00 | 10/27/2020 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-12-10 09:00; End=2024-12-10 14:00) | 10 | 12/10/2024 00:00:00 | 12/10/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2021-02-04 12:30; End=2021-02-04 16:30) | 10 | 02/04/2021 00:00:00 | 02/04/2021 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-12-02 19:00; End=2024-12-03 00:00) | 10 | 12/02/2024 00:00:00 | 12/02/2024 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2024-12-06 06:00; End=2024-12-06 15:00) | 10 | 12/06/2024 00:00:00 | 12/06/2024 00:00:00 |
| Warn_Overlap (PrevLPID=81826; PrevEnd=2026-04-02 23:00; GapMinRaw=-90) | 9 | 04/02/2026 00:00:00 | 04/02/2026 00:00:00 |
| Warn_Overlap (PrevLPID=81841; PrevEnd=2026-04-03 11:00; GapMinRaw=-240) | 9 | 04/03/2026 00:00:00 | 04/03/2026 00:00:00 |
| Warn_Overlap (PrevLPID=84862; PrevEnd=2026-05-13 23:30; GapMinRaw=-690) | 8 | 05/13/2026 00:00:00 | 05/13/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-06-04 06:00; End=2026-06-04 14:30) | 8 | 06/04/2026 00:00:00 | 06/04/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-06-19 06:00; End=2026-06-19 12:30) | 8 | 06/19/2026 00:00:00 | 06/19/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79530; PrevEnd=2026-03-04 12:00; GapMinRaw=-150) | 8 | 03/04/2026 00:00:00 | 03/04/2026 00:00:00 |
| Warn_Overlap (PrevLPID=86905; PrevEnd=2026-06-08 10:00; GapMinRaw=-120) | 8 | 06/08/2026 00:00:00 | 06/08/2026 00:00:00 |
| Warn_Overlap (PrevLPID=86937; PrevEnd=2026-06-05 14:00; GapMinRaw=-60) | 8 | 06/05/2026 00:00:00 | 06/05/2026 00:00:00 |
| Warn_Overlap (PrevLPID=51677; PrevEnd=2025-01-06 18:00; GapMinRaw=-600) | 7 | 01/06/2025 00:00:00 | 01/06/2025 00:00:00 |
| Warn_Overlap (PrevLPID=80019; PrevEnd=2026-03-11 18:30; GapMinRaw=-660) | 7 | 03/11/2026 00:00:00 | 03/11/2026 00:00:00 |
| Warn_Overlap (PrevLPID=69571; PrevEnd=2025-09-25 17:30; GapMinRaw=-720) | 7 | 09/25/2025 00:00:00 | 09/25/2025 00:00:00 |
| Warn_Overlap (PrevLPID=84884; PrevEnd=2026-05-14 09:00; GapMinRaw=-30) | 7 | 05/14/2026 00:00:00 | 05/14/2026 00:00:00 |
| Warn_Overlap (PrevLPID=51952; PrevEnd=2025-01-10 13:00; GapMinRaw=-300) | 7 | 01/10/2025 00:00:00 | 01/10/2025 00:00:00 |
| Warn_Overlap (PrevLPID=69911; PrevEnd=2025-09-30 11:00; GapMinRaw=-180) | 7 | 09/30/2025 00:00:00 | 09/30/2025 00:00:00 |
| Warn_Overlap (PrevLPID=68671; PrevEnd=2025-09-11 15:00; GapMinRaw=-240) | 7 | 09/11/2025 00:00:00 | 09/11/2025 00:00:00 |
| Warn_Overlap (PrevLPID=67846; PrevEnd=2025-08-27 01:00; GapMinRaw=-570) | 7 | 08/26/2025 00:00:00 | 08/26/2025 00:00:00 |
| Warn_Overlap (PrevLPID=87003; PrevEnd=2026-06-01 14:00; GapMinRaw=-60) | 7 | 06/01/2026 00:00:00 | 06/01/2026 00:00:00 |
| Warn_Overlap (PrevLPID=69175; PrevEnd=2025-09-19 13:00; GapMinRaw=-270) | 7 | 09/19/2025 00:00:00 | 09/19/2025 00:00:00 |
| Warn_Overlap (PrevLPID=69910; PrevEnd=2025-09-30 11:00; GapMinRaw=-330) | 7 | 09/30/2025 00:00:00 | 09/30/2025 00:00:00 |
| Warn_Overlap (PrevLPID=51816; PrevEnd=2025-01-09 17:30; GapMinRaw=-240) | 7 | 01/09/2025 00:00:00 | 01/09/2025 00:00:00 |
| Warn_Overlap (PrevLPID=51949; PrevEnd=2025-01-10 15:30; GapMinRaw=-450) | 7 | 01/10/2025 00:00:00 | 01/10/2025 00:00:00 |
| Warn_Overlap (PrevLPID=51675; PrevEnd=2025-01-06 11:30; GapMinRaw=-300) | 7 | 01/06/2025 00:00:00 | 01/06/2025 00:00:00 |
| Warn_Overlap (PrevLPID=69886; PrevEnd=2025-09-30 14:00; GapMinRaw=-180) | 7 | 09/30/2025 00:00:00 | 09/30/2025 00:00:00 |
| Warn_Overlap (PrevLPID=84936; PrevEnd=2026-05-13 20:30; GapMinRaw=-90) | 7 | 05/13/2026 00:00:00 | 05/13/2026 00:00:00 |
| Warn_Overlap (PrevLPID=68570; PrevEnd=2025-09-09 18:30; GapMinRaw=-780) | 7 | 09/09/2025 00:00:00 | 09/09/2025 00:00:00 |
| Warn_Overlap (PrevLPID=69369; PrevEnd=2025-09-23 10:30; GapMinRaw=-300) | 7 | 09/23/2025 00:00:00 | 09/23/2025 00:00:00 |
| Warn_Overlap (PrevLPID=68141; PrevEnd=2025-09-03 02:00; GapMinRaw=-60) | 7 | 09/03/2025 00:00:00 | 09/03/2025 00:00:00 |
| Warn_Overlap (PrevLPID=68571; PrevEnd=2025-09-09 18:30; GapMinRaw=-690) | 7 | 09/09/2025 00:00:00 | 09/09/2025 00:00:00 |
| Warn_Overlap (PrevLPID=87008; PrevEnd=2026-06-01 17:00; GapMinRaw=-150) | 7 | 06/01/2026 00:00:00 | 06/01/2026 00:00:00 |
| Warn_Overlap (PrevLPID=69569; PrevEnd=2025-09-25 22:00; GapMinRaw=-930) | 7 | 09/25/2025 00:00:00 | 09/25/2025 00:00:00 |
| Warn_Overlap (PrevLPID=70548; PrevEnd=2025-10-09 02:00; GapMinRaw=-810) | 7 | 10/08/2025 00:00:00 | 10/08/2025 00:00:00 |
| Warn_Overlap (PrevLPID=70587; PrevEnd=2025-10-09 02:00; GapMinRaw=-810) | 7 | 10/08/2025 00:00:00 | 10/08/2025 00:00:00 |
| Warn_Overlap (PrevLPID=67845; PrevEnd=2025-08-27 01:00; GapMinRaw=-600) | 7 | 08/26/2025 00:00:00 | 08/26/2025 00:00:00 |
| Warn_Overlap (PrevLPID=68670; PrevEnd=2025-09-11 15:00; GapMinRaw=-240) | 7 | 09/11/2025 00:00:00 | 09/11/2025 00:00:00 |
| Warn_Overlap (PrevLPID=84935; PrevEnd=2026-05-13 19:30; GapMinRaw=-30) | 7 | 05/13/2026 00:00:00 | 05/13/2026 00:00:00 |
| Warn_Overlap (PrevLPID=69174; PrevEnd=2025-09-19 13:00; GapMinRaw=-270) | 7 | 09/19/2025 00:00:00 | 09/19/2025 00:00:00 |
| Warn_Overlap (PrevLPID=52455; PrevEnd=2025-01-15 22:00; GapMinRaw=-930) | 6 | 01/15/2025 00:00:00 | 01/15/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61820; PrevEnd=2025-05-20 19:00; GapMinRaw=-810) | 6 | 05/20/2025 00:00:00 | 05/20/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62041; PrevEnd=2025-05-21 10:30; GapMinRaw=-300) | 6 | 05/21/2025 00:00:00 | 05/21/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62517; PrevEnd=2025-05-28 12:00; GapMinRaw=-30) | 6 | 05/28/2025 00:00:00 | 05/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=53144; PrevEnd=2025-01-28 16:00; GapMinRaw=-600) | 6 | 01/28/2025 00:00:00 | 01/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62464; PrevEnd=2025-05-29 22:30; GapMinRaw=-240) | 6 | 05/29/2025 00:00:00 | 05/29/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62040; PrevEnd=2025-05-20 16:00; GapMinRaw=-300) | 6 | 05/20/2025 00:00:00 | 05/20/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62238; PrevEnd=2025-05-21 20:30; GapMinRaw=-900) | 6 | 05/21/2025 00:00:00 | 05/21/2025 00:00:00 |
| Warn_Overlap (PrevLPID=59359; PrevEnd=2025-04-18 13:00; GapMinRaw=-360) | 6 | 04/18/2025 00:00:00 | 04/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=63202; PrevEnd=2025-06-03 16:00; GapMinRaw=-570) | 6 | 06/03/2025 00:00:00 | 06/03/2025 00:00:00 |
| Warn_Overlap (PrevLPID=82027; PrevEnd=2026-04-07 10:00; GapMinRaw=-30) | 6 | 04/07/2026 00:00:00 | 04/07/2026 00:00:00 |
| Warn_Overlap (PrevLPID=61263; PrevEnd=2025-05-14 14:30; GapMinRaw=-450) | 6 | 05/14/2025 00:00:00 | 05/14/2025 00:00:00 |
| Warn_Overlap (PrevLPID=53011; PrevEnd=2025-01-23 23:00; GapMinRaw=-300) | 6 | 01/23/2025 00:00:00 | 01/23/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61436; PrevEnd=2025-05-13 17:00; GapMinRaw=-540) | 6 | 05/13/2025 00:00:00 | 05/13/2025 00:00:00 |
| Warn_Overlap (PrevLPID=60305; PrevEnd=2025-05-01 13:00; GapMinRaw=-480) | 6 | 05/01/2025 00:00:00 | 05/01/2025 00:00:00 |
| Warn_Overlap (PrevLPID=53067; PrevEnd=2025-01-24 22:00; GapMinRaw=-180) | 6 | 01/24/2025 00:00:00 | 01/24/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61728; PrevEnd=2025-05-15 19:30; GapMinRaw=-900) | 6 | 05/15/2025 00:00:00 | 05/15/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62046; PrevEnd=2025-05-21 13:30; GapMinRaw=-480) | 6 | 05/21/2025 00:00:00 | 05/21/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61442; PrevEnd=2025-05-15 11:00; GapMinRaw=-210) | 6 | 05/15/2025 00:00:00 | 05/15/2025 00:00:00 |
| Warn_Overlap (PrevLPID=51977; PrevEnd=2025-01-11 16:00; GapMinRaw=-60) | 6 | 01/11/2025 00:00:00 | 01/11/2025 00:00:00 |
| Warn_Overlap (PrevLPID=63123; PrevEnd=2025-06-03 16:00; GapMinRaw=-360) | 6 | 06/03/2025 00:00:00 | 06/03/2025 00:00:00 |
| Warn_Overlap (PrevLPID=52276; PrevEnd=2025-01-16 18:30; GapMinRaw=-60) | 6 | 01/16/2025 00:00:00 | 01/16/2025 00:00:00 |
| Warn_Overlap (PrevLPID=53066; PrevEnd=2025-01-23 22:00; GapMinRaw=-960) | 6 | 01/23/2025 00:00:00 | 01/23/2025 00:00:00 |
| Warn_Overlap (PrevLPID=60348; PrevEnd=2025-05-01 16:30; GapMinRaw=-630) | 6 | 05/01/2025 00:00:00 | 05/01/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62038; PrevEnd=2025-05-22 13:00; GapMinRaw=-300) | 6 | 05/22/2025 00:00:00 | 05/22/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62026; PrevEnd=2025-05-22 09:00; GapMinRaw=-240) | 6 | 05/22/2025 00:00:00 | 05/22/2025 00:00:00 |
| Warn_Overlap (PrevLPID=80072; PrevEnd=2026-03-11 19:00; GapMinRaw=-210) | 6 | 03/11/2026 00:00:00 | 03/11/2026 00:00:00 |
| Warn_Overlap (PrevLPID=53068; PrevEnd=2025-01-24 10:30; GapMinRaw=-390) | 6 | 01/24/2025 00:00:00 | 01/24/2025 00:00:00 |
| Warn_Overlap (PrevLPID=80073; PrevEnd=2026-03-11 19:00; GapMinRaw=-210) | 6 | 03/11/2026 00:00:00 | 03/11/2026 00:00:00 |
| Warn_Overlap (PrevLPID=60598; PrevEnd=2025-05-06 19:30; GapMinRaw=-510) | 6 | 05/06/2025 00:00:00 | 05/06/2025 00:00:00 |
| Warn_Overlap (PrevLPID=57557; PrevEnd=2025-03-25 17:30; GapMinRaw=-720) | 6 | 03/25/2025 00:00:00 | 03/25/2025 00:00:00 |
| Warn_Overlap (PrevLPID=60873; PrevEnd=2025-05-09 17:00; GapMinRaw=-540) | 6 | 05/09/2025 00:00:00 | 05/09/2025 00:00:00 |
| Warn_Overlap (PrevLPID=55851; PrevEnd=2025-02-26 17:30; GapMinRaw=-450) | 6 | 02/26/2025 00:00:00 | 02/26/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62916; PrevEnd=2025-06-05 17:00; GapMinRaw=-390) | 6 | 06/05/2025 00:00:00 | 06/05/2025 00:00:00 |
| Warn_Overlap (PrevLPID=53009; PrevEnd=2025-01-23 14:30; GapMinRaw=-510) | 6 | 01/23/2025 00:00:00 | 01/23/2025 00:00:00 |
| Warn_Overlap (PrevLPID=63788; PrevEnd=2025-06-17 18:00; GapMinRaw=-750) | 6 | 06/17/2025 00:00:00 | 06/17/2025 00:00:00 |
| Warn_Overlap (PrevLPID=55269; PrevEnd=2025-02-21 13:30; GapMinRaw=-30) | 6 | 02/21/2025 00:00:00 | 02/21/2025 00:00:00 |
| Warn_Overlap (PrevLPID=65129; PrevEnd=2025-07-10 17:30; GapMinRaw=-780) | 6 | 07/10/2025 00:00:00 | 07/10/2025 00:00:00 |
| Warn_Overlap (PrevLPID=57546; PrevEnd=2025-03-27 11:00; GapMinRaw=-360) | 6 | 03/27/2025 00:00:00 | 03/27/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61435; PrevEnd=2025-05-14 04:00; GapMinRaw=-30) | 6 | 05/14/2025 00:00:00 | 05/14/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62365; PrevEnd=2025-05-28 18:00; GapMinRaw=-600) | 6 | 05/28/2025 00:00:00 | 05/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61960; PrevEnd=2025-05-22 13:30; GapMinRaw=-60) | 6 | 05/22/2025 00:00:00 | 05/22/2025 00:00:00 |
| Warn_Overlap (PrevLPID=57638; PrevEnd=2025-03-25 20:30; GapMinRaw=-900) | 6 | 03/25/2025 00:00:00 | 03/25/2025 00:00:00 |
| Warn_Overlap (PrevLPID=57408; PrevEnd=2025-03-24 10:30; GapMinRaw=-330) | 6 | 03/24/2025 00:00:00 | 03/24/2025 00:00:00 |
| Warn_Overlap (PrevLPID=60919; PrevEnd=2025-05-09 14:30; GapMinRaw=-120) | 6 | 05/09/2025 00:00:00 | 05/09/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62312; PrevEnd=2025-05-28 12:30; GapMinRaw=-60) | 6 | 05/28/2025 00:00:00 | 05/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62960; PrevEnd=2025-06-03 16:30; GapMinRaw=-600) | 6 | 06/03/2025 00:00:00 | 06/03/2025 00:00:00 |
| Warn_Overlap (PrevLPID=55845; PrevEnd=2025-02-28 16:00; GapMinRaw=-690) | 6 | 02/28/2025 00:00:00 | 02/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=86169; PrevEnd=2026-06-02 11:30; GapMinRaw=-60) | 6 | 06/02/2026 00:00:00 | 06/02/2026 00:00:00 |
| Warn_Overlap (PrevLPID=62415; PrevEnd=2025-05-28 11:30; GapMinRaw=-240) | 6 | 05/28/2025 00:00:00 | 05/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=53071; PrevEnd=2025-01-24 01:30; GapMinRaw=-150) | 6 | 01/23/2025 00:00:00 | 01/23/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61439; PrevEnd=2025-05-14 10:30; GapMinRaw=-330) | 6 | 05/14/2025 00:00:00 | 05/14/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61682; PrevEnd=2025-05-19 14:00; GapMinRaw=-360) | 6 | 05/19/2025 00:00:00 | 05/19/2025 00:00:00 |
| Warn_Overlap (PrevLPID=65108; PrevEnd=2025-07-09 13:00; GapMinRaw=-510) | 6 | 07/09/2025 00:00:00 | 07/09/2025 00:00:00 |
| Warn_Overlap (PrevLPID=87124; PrevEnd=2026-06-16 10:30; GapMinRaw=-30) | 6 | 06/16/2026 00:00:00 | 06/16/2026 00:00:00 |
| Warn_Overlap (PrevLPID=61265; PrevEnd=2025-05-14 11:00; GapMinRaw=-180) | 6 | 05/14/2025 00:00:00 | 05/14/2025 00:00:00 |
| Warn_Overlap (PrevLPID=57637; PrevEnd=2025-03-27 19:30; GapMinRaw=-780) | 6 | 03/27/2025 00:00:00 | 03/27/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61715; PrevEnd=2025-05-13 18:30; GapMinRaw=-720) | 6 | 05/13/2025 00:00:00 | 05/13/2025 00:00:00 |
| Warn_Overlap (PrevLPID=65950; PrevEnd=2025-07-24 05:30; GapMinRaw=-60) | 6 | 07/24/2025 00:00:00 | 07/24/2025 00:00:00 |
| Warn_Overlap (PrevLPID=53267; PrevEnd=2025-01-31 16:00; GapMinRaw=-600) | 6 | 01/31/2025 00:00:00 | 01/31/2025 00:00:00 |
| Warn_Overlap (PrevLPID=54639; PrevEnd=2025-02-18 11:30; GapMinRaw=-30) | 6 | 02/18/2025 00:00:00 | 02/18/2025 00:00:00 |
| Warn_Overlap (PrevLPID=56334; PrevEnd=2025-03-13 08:00; GapMinRaw=-120) | 6 | 03/13/2025 00:00:00 | 03/13/2025 00:00:00 |
| Warn_Overlap (PrevLPID=53168; PrevEnd=2025-01-29 15:30; GapMinRaw=-390) | 6 | 01/29/2025 00:00:00 | 01/29/2025 00:00:00 |
| Warn_Overlap (PrevLPID=63783; PrevEnd=2025-06-17 20:30; GapMinRaw=-870) | 6 | 06/17/2025 00:00:00 | 06/17/2025 00:00:00 |
| Warn_Overlap (PrevLPID=53745; PrevEnd=2025-02-04 13:30; GapMinRaw=-60) | 6 | 02/04/2025 00:00:00 | 02/04/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62500; PrevEnd=2025-05-28 13:30; GapMinRaw=-420) | 6 | 05/28/2025 00:00:00 | 05/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61324; PrevEnd=2025-05-15 00:00; GapMinRaw=-30) | 6 | 05/14/2025 00:00:00 | 05/14/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61253; PrevEnd=2025-05-13 14:30; GapMinRaw=-390) | 6 | 05/13/2025 00:00:00 | 05/13/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62068; PrevEnd=2025-05-20 17:30; GapMinRaw=-540) | 6 | 05/20/2025 00:00:00 | 05/20/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61959; PrevEnd=2025-05-22 13:30; GapMinRaw=-60) | 6 | 05/22/2025 00:00:00 | 05/22/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62311; PrevEnd=2025-05-28 12:30; GapMinRaw=-60) | 6 | 05/28/2025 00:00:00 | 05/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62463; PrevEnd=2025-05-29 22:30; GapMinRaw=-240) | 6 | 05/29/2025 00:00:00 | 05/29/2025 00:00:00 |
| Warn_Overlap (PrevLPID=57126; PrevEnd=2025-03-21 21:00; GapMinRaw=-570) | 6 | 03/21/2025 00:00:00 | 03/21/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62031; PrevEnd=2025-05-22 04:00; GapMinRaw=-60) | 6 | 05/22/2025 00:00:00 | 05/22/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62915; PrevEnd=2025-06-05 21:00; GapMinRaw=-780) | 6 | 06/05/2025 00:00:00 | 06/05/2025 00:00:00 |
| Warn_Overlap (PrevLPID=57406; PrevEnd=2025-03-22 12:00; GapMinRaw=-510) | 6 | 03/22/2025 00:00:00 | 03/22/2025 00:00:00 |
| Warn_Overlap (PrevLPID=51978; PrevEnd=2025-01-11 23:30; GapMinRaw=-930) | 6 | 01/11/2025 00:00:00 | 01/11/2025 00:00:00 |
| Warn_Overlap (PrevLPID=65223; PrevEnd=2025-07-10 19:00; GapMinRaw=-810) | 6 | 07/10/2025 00:00:00 | 07/10/2025 00:00:00 |
| Warn_Overlap (PrevLPID=53869; PrevEnd=2025-02-01 18:00; GapMinRaw=-720) | 6 | 02/01/2025 00:00:00 | 02/01/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61546; PrevEnd=2025-05-16 11:00; GapMinRaw=-60) | 6 | 05/16/2025 00:00:00 | 05/16/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62912; PrevEnd=2025-06-05 10:30; GapMinRaw=-300) | 6 | 06/05/2025 00:00:00 | 06/05/2025 00:00:00 |
| Warn_Overlap (PrevLPID=63370; PrevEnd=2025-06-11 15:00; GapMinRaw=-60) | 6 | 06/11/2025 00:00:00 | 06/11/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62067; PrevEnd=2025-05-21 10:00; GapMinRaw=-240) | 6 | 05/21/2025 00:00:00 | 05/21/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62411; PrevEnd=2025-05-28 11:30; GapMinRaw=-240) | 6 | 05/28/2025 00:00:00 | 05/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62515; PrevEnd=2025-05-28 08:00; GapMinRaw=-120) | 6 | 05/28/2025 00:00:00 | 05/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=52214; PrevEnd=2025-01-15 13:00; GapMinRaw=-390) | 6 | 01/15/2025 00:00:00 | 01/15/2025 00:00:00 |
| Warn_Overlap (PrevLPID=51902; PrevEnd=2025-01-13 20:00; GapMinRaw=-840) | 6 | 01/13/2025 00:00:00 | 01/13/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62427; PrevEnd=2025-05-28 11:30; GapMinRaw=-210) | 6 | 05/28/2025 00:00:00 | 05/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62240; PrevEnd=2025-05-22 16:30; GapMinRaw=-570) | 6 | 05/22/2025 00:00:00 | 05/22/2025 00:00:00 |
| Warn_Overlap (PrevLPID=65225; PrevEnd=2025-07-10 19:30; GapMinRaw=-900) | 6 | 07/10/2025 00:00:00 | 07/10/2025 00:00:00 |
| Warn_Overlap (PrevLPID=55106; PrevEnd=2025-02-20 14:00; GapMinRaw=-180) | 6 | 02/20/2025 00:00:00 | 02/20/2025 00:00:00 |
| Warn_Overlap (PrevLPID=52398; PrevEnd=2025-01-16 20:30; GapMinRaw=-30) | 6 | 01/16/2025 00:00:00 | 01/16/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62958; PrevEnd=2025-06-03 10:00; GapMinRaw=-270) | 6 | 06/03/2025 00:00:00 | 06/03/2025 00:00:00 |
| Warn_Overlap (PrevLPID=57593; PrevEnd=2025-03-28 11:00; GapMinRaw=-360) | 6 | 03/28/2025 00:00:00 | 03/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=65222; PrevEnd=2025-07-09 18:30; GapMinRaw=-750) | 6 | 07/09/2025 00:00:00 | 07/09/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62030; PrevEnd=2025-05-20 23:30; GapMinRaw=-360) | 6 | 05/20/2025 00:00:00 | 05/20/2025 00:00:00 |
| Warn_Overlap (PrevLPID=54637; PrevEnd=2025-02-11 20:00; GapMinRaw=-90) | 6 | 02/11/2025 00:00:00 | 02/11/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61567; PrevEnd=2025-05-15 18:00; GapMinRaw=-840) | 6 | 05/15/2025 00:00:00 | 05/15/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61772; PrevEnd=2025-05-20 15:30; GapMinRaw=-180) | 6 | 05/20/2025 00:00:00 | 05/20/2025 00:00:00 |
| Warn_Overlap (PrevLPID=52898; PrevEnd=2025-01-23 11:30; GapMinRaw=-330) | 6 | 01/23/2025 00:00:00 | 01/23/2025 00:00:00 |
| Warn_Overlap (PrevLPID=51976; PrevEnd=2025-01-15 09:00; GapMinRaw=-240) | 6 | 01/15/2025 00:00:00 | 01/15/2025 00:00:00 |
| Warn_Overlap (PrevLPID=53503; PrevEnd=2025-01-28 18:00; GapMinRaw=-720) | 6 | 01/28/2025 00:00:00 | 01/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62518; PrevEnd=2025-05-28 16:00; GapMinRaw=-150) | 6 | 05/28/2025 00:00:00 | 05/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=59805; PrevEnd=2025-04-23 00:00; GapMinRaw=-60) | 6 | 04/22/2025 00:00:00 | 04/22/2025 00:00:00 |
| Warn_Overlap (PrevLPID=51871; PrevEnd=2025-01-11 06:30; GapMinRaw=-300) | 6 | 01/11/2025 00:00:00 | 01/11/2025 00:00:00 |
| Warn_Overlap (PrevLPID=52635; PrevEnd=2025-01-21 14:00; GapMinRaw=-570) | 6 | 01/21/2025 00:00:00 | 01/21/2025 00:00:00 |
| Warn_Overlap (PrevLPID=57639; PrevEnd=2025-03-24 20:30; GapMinRaw=-930) | 6 | 03/24/2025 00:00:00 | 03/24/2025 00:00:00 |
| Warn_Overlap (PrevLPID=58308; PrevEnd=2025-03-31 12:30; GapMinRaw=-540) | 6 | 03/31/2025 00:00:00 | 03/31/2025 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-04-17 06:30; End=2026-04-17 17:00) | 6 | 04/17/2026 00:00:00 | 04/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=62428; PrevEnd=2025-05-28 13:30; GapMinRaw=-90) | 6 | 05/28/2025 00:00:00 | 05/28/2025 00:00:00 |
| Warn_Overlap (PrevLPID=61674; PrevEnd=2025-05-15 16:00; GapMinRaw=-540) | 6 | 05/15/2025 00:00:00 | 05/15/2025 00:00:00 |
| Warn_Overlap (PrevLPID=55454; PrevEnd=2025-02-25 14:30; GapMinRaw=-570) | 6 | 02/25/2025 00:00:00 | 02/25/2025 00:00:00 |
| Warn_Overlap (PrevLPID=62462; PrevEnd=2025-05-29 22:30; GapMinRaw=-240) | 6 | 05/29/2025 00:00:00 | 05/29/2025 00:00:00 |
| Warn_Overlap (PrevLPID=66345; PrevEnd=2025-07-29 11:30; GapMinRaw=-30) | 6 | 07/29/2025 00:00:00 | 07/29/2025 00:00:00 |
| Warn_Overlap (PrevLPID=316; PrevEnd=2020-08-28 12:00; GapMinRaw=-30) | 5 | 08/28/2020 00:00:00 | 08/28/2020 00:00:00 |
| Warn_Overlap (PrevLPID=603; PrevEnd=2020-09-24 10:30; GapMinRaw=-210) | 5 | 09/24/2020 00:00:00 | 09/24/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3294; PrevEnd=2021-05-17 13:00; GapMinRaw=-60) | 5 | 05/17/2021 00:00:00 | 05/17/2021 00:00:00 |
| Warn_Overlap (PrevLPID=14021; PrevEnd=2022-07-19 11:00; GapMinRaw=-240) | 5 | 07/19/2022 00:00:00 | 07/19/2022 00:00:00 |
| Warn_Overlap (PrevLPID=6285; PrevEnd=2021-11-02 12:00; GapMinRaw=-60) | 5 | 11/02/2021 00:00:00 | 11/02/2021 00:00:00 |
| Warn_Overlap (PrevLPID=25005; PrevEnd=2023-04-27 11:30; GapMinRaw=-60) | 5 | 04/27/2023 00:00:00 | 04/27/2023 00:00:00 |
| Warn_Overlap (PrevLPID=65; PrevEnd=2020-07-17 10:30; GapMinRaw=-270) | 5 | 07/17/2020 00:00:00 | 07/17/2020 00:00:00 |
| Warn_Overlap (PrevLPID=924; PrevEnd=2020-10-20 10:30; GapMinRaw=-30) | 5 | 10/20/2020 00:00:00 | 10/20/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1522; PrevEnd=2020-12-11 12:00; GapMinRaw=-60) | 5 | 12/11/2020 00:00:00 | 12/11/2020 00:00:00 |
| Warn_Overlap (PrevLPID=14300; PrevEnd=2022-07-27 12:00; GapMinRaw=-60) | 5 | 07/27/2022 00:00:00 | 07/27/2022 00:00:00 |
| Warn_Overlap (PrevLPID=40753; PrevEnd=2024-04-16 16:00; GapMinRaw=-480) | 5 | 04/16/2024 00:00:00 | 04/16/2024 00:00:00 |
| Warn_Overlap (PrevLPID=105; PrevEnd=2020-07-24 16:00; GapMinRaw=-390) | 5 | 07/24/2020 00:00:00 | 07/24/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2951; PrevEnd=2021-04-19 06:30; GapMinRaw=-30) | 5 | 04/19/2021 00:00:00 | 04/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5258; PrevEnd=2021-09-15 06:30; GapMinRaw=-60) | 5 | 09/15/2021 00:00:00 | 09/15/2021 00:00:00 |
| Warn_Overlap (PrevLPID=961; PrevEnd=2020-08-09 16:30; GapMinRaw=-750) | 5 | 08/09/2020 00:00:00 | 08/09/2020 00:00:00 |
| Warn_Overlap (PrevLPID=5645; PrevEnd=2021-10-04 11:30; GapMinRaw=-60) | 5 | 10/04/2021 00:00:00 | 10/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=6710; PrevEnd=2021-11-23 12:00; GapMinRaw=-210) | 5 | 11/23/2021 00:00:00 | 11/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4265; PrevEnd=2021-07-17 08:30; GapMinRaw=-90) | 5 | 07/17/2021 00:00:00 | 07/17/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4677; PrevEnd=2021-08-12 15:00; GapMinRaw=-540) | 5 | 08/12/2021 00:00:00 | 08/12/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5186; PrevEnd=2021-09-10 12:30; GapMinRaw=-120) | 5 | 09/10/2021 00:00:00 | 09/10/2021 00:00:00 |
| Warn_Overlap (PrevLPID=50643; PrevEnd=2024-12-10 15:30; GapMinRaw=-450) | 5 | 12/10/2024 00:00:00 | 12/10/2024 00:00:00 |
| Warn_Overlap (PrevLPID=2947; PrevEnd=2021-04-16 12:00; GapMinRaw=-120) | 5 | 04/16/2021 00:00:00 | 04/16/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3834; PrevEnd=2021-06-21 09:00; GapMinRaw=-60) | 5 | 06/21/2021 00:00:00 | 06/21/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4194; PrevEnd=2021-07-13 12:30; GapMinRaw=-60) | 5 | 07/13/2021 00:00:00 | 07/13/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4244; PrevEnd=2021-07-16 11:30; GapMinRaw=-30) | 5 | 07/16/2021 00:00:00 | 07/16/2021 00:00:00 |
| Warn_Overlap (PrevLPID=9084; PrevEnd=2022-02-24 23:00; GapMinRaw=-180) | 5 | 02/24/2022 00:00:00 | 02/24/2022 00:00:00 |
| Warn_Overlap (PrevLPID=14433; PrevEnd=2022-07-27 08:00; GapMinRaw=-120) | 5 | 07/27/2022 00:00:00 | 07/27/2022 00:00:00 |
| Warn_Overlap (PrevLPID=998; PrevEnd=2020-10-26 07:30; GapMinRaw=-30) | 5 | 10/26/2020 00:00:00 | 10/26/2020 00:00:00 |
| Warn_Overlap (PrevLPID=41429; PrevEnd=2024-05-09 09:00; GapMinRaw=-240) | 5 | 05/09/2024 00:00:00 | 05/09/2024 00:00:00 |
| Warn_Overlap (PrevLPID=40816; PrevEnd=2024-04-17 23:30; GapMinRaw=-1020) | 5 | 04/17/2024 00:00:00 | 04/17/2024 00:00:00 |
| Warn_Overlap (PrevLPID=46831; PrevEnd=2024-09-18 22:00; GapMinRaw=-990) | 5 | 09/18/2024 00:00:00 | 09/18/2024 00:00:00 |
| Warn_Overlap (PrevLPID=5637; PrevEnd=2021-10-04 10:30; GapMinRaw=-90) | 5 | 10/04/2021 00:00:00 | 10/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=13959; PrevEnd=2022-07-23 13:00; GapMinRaw=-390) | 5 | 07/23/2022 00:00:00 | 07/23/2022 00:00:00 |
| Warn_Overlap (PrevLPID=3489; PrevEnd=2021-05-28 09:30; GapMinRaw=-30) | 5 | 05/28/2021 00:00:00 | 05/28/2021 00:00:00 |
| Warn_Overlap (PrevLPID=8423; PrevEnd=2022-02-08 13:30; GapMinRaw=-30) | 5 | 02/08/2022 00:00:00 | 02/08/2022 00:00:00 |
| Warn_Overlap (PrevLPID=38868; PrevEnd=2024-03-06 19:30; GapMinRaw=-750) | 5 | 03/06/2024 00:00:00 | 03/06/2024 00:00:00 |
| Warn_Overlap (PrevLPID=839; PrevEnd=2020-10-13 09:30; GapMinRaw=-120) | 5 | 10/13/2020 00:00:00 | 10/13/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3251; PrevEnd=2021-05-13 13:00; GapMinRaw=-30) | 5 | 05/13/2021 00:00:00 | 05/13/2021 00:00:00 |
| Warn_Overlap (PrevLPID=32178; PrevEnd=2023-09-26 13:30; GapMinRaw=-150) | 5 | 09/26/2023 00:00:00 | 09/26/2023 00:00:00 |
| Warn_Overlap (PrevLPID=287; PrevEnd=2020-08-26 11:00; GapMinRaw=-60) | 5 | 08/26/2020 00:00:00 | 08/26/2020 00:00:00 |
| Warn_Overlap (PrevLPID=5588; PrevEnd=2021-09-30 11:30; GapMinRaw=-240) | 5 | 09/30/2021 00:00:00 | 09/30/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2080; PrevEnd=2021-02-01 10:30; GapMinRaw=-60) | 5 | 02/01/2021 00:00:00 | 02/01/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4117; PrevEnd=2021-07-08 10:30; GapMinRaw=-90) | 5 | 07/08/2021 00:00:00 | 07/08/2021 00:00:00 |
| Warn_Overlap (PrevLPID=217; PrevEnd=2020-08-16 12:00; GapMinRaw=-120) | 5 | 08/16/2020 00:00:00 | 08/16/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3605; PrevEnd=2021-06-07 11:30; GapMinRaw=-30) | 5 | 06/07/2021 00:00:00 | 06/07/2021 00:00:00 |
| Warn_Overlap (PrevLPID=6143; PrevEnd=2021-10-27 14:30; GapMinRaw=-60) | 5 | 10/27/2021 00:00:00 | 10/27/2021 00:00:00 |
| Warn_Overlap (PrevLPID=19131; PrevEnd=2022-12-12 03:30; GapMinRaw=-30) | 5 | 12/12/2022 00:00:00 | 12/12/2022 00:00:00 |
| Warn_Overlap (PrevLPID=23621; PrevEnd=2023-03-23 15:00; GapMinRaw=-300) | 5 | 03/23/2023 00:00:00 | 03/23/2023 00:00:00 |
| Warn_Overlap (PrevLPID=2737; PrevEnd=2021-03-31 07:00; GapMinRaw=-60) | 5 | 03/31/2021 00:00:00 | 03/31/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4484; PrevEnd=2021-08-02 09:00; GapMinRaw=-30) | 5 | 08/02/2021 00:00:00 | 08/02/2021 00:00:00 |
| Warn_Overlap (PrevLPID=14428; PrevEnd=2022-08-02 09:00; GapMinRaw=-30) | 5 | 08/02/2022 00:00:00 | 08/02/2022 00:00:00 |
| Warn_Overlap (PrevLPID=3383; PrevEnd=2021-05-21 11:00; GapMinRaw=-60) | 5 | 05/21/2021 00:00:00 | 05/21/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4110; PrevEnd=2021-07-08 08:00; GapMinRaw=-60) | 5 | 07/08/2021 00:00:00 | 07/08/2021 00:00:00 |
| Warn_Overlap (PrevLPID=8080; PrevEnd=2022-01-28 11:30; GapMinRaw=-30) | 5 | 01/28/2022 00:00:00 | 01/28/2022 00:00:00 |
| Warn_Overlap (PrevLPID=44364; PrevEnd=2024-07-22 13:30; GapMinRaw=-420) | 5 | 07/22/2024 00:00:00 | 07/22/2024 00:00:00 |
| Warn_Overlap (PrevLPID=280; PrevEnd=2020-08-25 17:00; GapMinRaw=-420) | 5 | 08/25/2020 00:00:00 | 08/25/2020 00:00:00 |
| Warn_Overlap (PrevLPID=5243; PrevEnd=2021-09-14 12:00; GapMinRaw=-30) | 5 | 09/14/2021 00:00:00 | 09/14/2021 00:00:00 |
| Warn_Overlap (PrevLPID=32836; PrevEnd=2023-10-11 09:00; GapMinRaw=-30) | 5 | 10/11/2023 00:00:00 | 10/11/2023 00:00:00 |
| Warn_Overlap (PrevLPID=51312; PrevEnd=2024-12-23 15:30; GapMinRaw=-630) | 5 | 12/23/2024 00:00:00 | 12/23/2024 00:00:00 |
| Warn_Overlap (PrevLPID=9028; PrevEnd=2022-02-23 07:30; GapMinRaw=-30) | 5 | 02/23/2022 00:00:00 | 02/23/2022 00:00:00 |
| Warn_Overlap (PrevLPID=14436; PrevEnd=2022-07-29 13:00; GapMinRaw=-420) | 5 | 07/29/2022 00:00:00 | 07/29/2022 00:00:00 |
| Warn_Overlap (PrevLPID=15324; PrevEnd=2022-08-23 14:30; GapMinRaw=-90) | 5 | 08/23/2022 00:00:00 | 08/23/2022 00:00:00 |
| Warn_Overlap (PrevLPID=501; PrevEnd=2020-09-16 11:00; GapMinRaw=-60) | 5 | 09/16/2020 00:00:00 | 09/16/2020 00:00:00 |
| Warn_Overlap (PrevLPID=40275; PrevEnd=2024-04-09 08:00; GapMinRaw=-120) | 5 | 04/09/2024 00:00:00 | 04/09/2024 00:00:00 |
| Warn_Overlap (PrevLPID=38072; PrevEnd=2024-02-13 13:30; GapMinRaw=-390) | 5 | 02/13/2024 00:00:00 | 02/13/2024 00:00:00 |
| Warn_Overlap (PrevLPID=50842; PrevEnd=2024-12-13 20:30; GapMinRaw=-900) | 5 | 12/13/2024 00:00:00 | 12/13/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1506; PrevEnd=2020-12-10 18:00; GapMinRaw=-120) | 5 | 12/10/2020 00:00:00 | 12/10/2020 00:00:00 |
| Warn_Overlap (PrevLPID=29898; PrevEnd=2023-08-03 12:00; GapMinRaw=-90) | 5 | 08/03/2023 00:00:00 | 08/03/2023 00:00:00 |
| Warn_Overlap (PrevLPID=3880; PrevEnd=2021-06-23 11:00; GapMinRaw=-60) | 5 | 06/23/2021 00:00:00 | 06/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5050; PrevEnd=2021-09-01 23:30; GapMinRaw=-720) | 5 | 09/01/2021 00:00:00 | 09/01/2021 00:00:00 |
| Warn_Overlap (PrevLPID=13019; PrevEnd=2022-06-24 14:30; GapMinRaw=-480) | 5 | 06/24/2022 00:00:00 | 06/24/2022 00:00:00 |
| Warn_Overlap (PrevLPID=91; PrevEnd=2020-07-23 09:30; GapMinRaw=-60) | 5 | 07/23/2020 00:00:00 | 07/23/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1460; PrevEnd=2020-12-04 13:00; GapMinRaw=-90) | 5 | 12/04/2020 00:00:00 | 12/04/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4446; PrevEnd=2021-07-29 15:30; GapMinRaw=-90) | 5 | 07/29/2021 00:00:00 | 07/29/2021 00:00:00 |
| Warn_Overlap (PrevLPID=8462; PrevEnd=2022-02-09 15:00; GapMinRaw=-60) | 5 | 02/09/2022 00:00:00 | 02/09/2022 00:00:00 |
| Warn_Overlap (PrevLPID=46122; PrevEnd=2024-08-29 14:00; GapMinRaw=-240) | 5 | 08/29/2024 00:00:00 | 08/29/2024 00:00:00 |
| Warn_Overlap (PrevLPID=3382; PrevEnd=2021-05-21 11:30; GapMinRaw=-60) | 5 | 05/21/2021 00:00:00 | 05/21/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4301; PrevEnd=2021-07-20 11:30; GapMinRaw=-60) | 5 | 07/20/2021 00:00:00 | 07/20/2021 00:00:00 |
| Warn_Overlap (PrevLPID=39285; PrevEnd=2024-03-14 08:00; GapMinRaw=-240) | 5 | 03/14/2024 00:00:00 | 03/14/2024 00:00:00 |
| Warn_Overlap (PrevLPID=4189; PrevEnd=2021-07-13 12:30; GapMinRaw=-30) | 5 | 07/13/2021 00:00:00 | 07/13/2021 00:00:00 |
| Warn_Overlap (PrevLPID=37547; PrevEnd=2024-01-26 08:00; GapMinRaw=-150) | 5 | 01/26/2024 00:00:00 | 01/26/2024 00:00:00 |
| Warn_Overlap (PrevLPID=542; PrevEnd=2020-09-18 14:00; GapMinRaw=-120) | 5 | 09/18/2020 00:00:00 | 09/18/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3414; PrevEnd=2021-05-24 12:00; GapMinRaw=-120) | 5 | 05/24/2021 00:00:00 | 05/24/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3928; PrevEnd=2021-06-25 12:00; GapMinRaw=-30) | 5 | 06/25/2021 00:00:00 | 06/25/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4626; PrevEnd=2021-08-10 13:00; GapMinRaw=-90) | 5 | 08/10/2021 00:00:00 | 08/10/2021 00:00:00 |
| Warn_Overlap (PrevLPID=16462; PrevEnd=2022-09-19 13:00; GapMinRaw=-300) | 5 | 09/19/2022 00:00:00 | 09/19/2022 00:00:00 |
| Warn_Overlap (PrevLPID=39638; PrevEnd=2024-03-27 10:30; GapMinRaw=-180) | 5 | 03/27/2024 00:00:00 | 03/27/2024 00:00:00 |
| Warn_Overlap (PrevLPID=42514; PrevEnd=2024-06-04 17:30; GapMinRaw=-690) | 5 | 06/04/2024 00:00:00 | 06/04/2024 00:00:00 |
| Warn_Overlap (PrevLPID=3278; PrevEnd=2021-05-14 12:30; GapMinRaw=-60) | 5 | 05/14/2021 00:00:00 | 05/14/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3462; PrevEnd=2021-05-26 12:30; GapMinRaw=-60) | 5 | 05/26/2021 00:00:00 | 05/26/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5662; PrevEnd=2021-10-04 13:00; GapMinRaw=-30) | 5 | 10/04/2021 00:00:00 | 10/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=39558; PrevEnd=2024-03-24 08:00; GapMinRaw=-60) | 5 | 03/24/2024 00:00:00 | 03/24/2024 00:00:00 |
| Warn_Overlap (PrevLPID=26198; PrevEnd=2023-05-16 12:30; GapMinRaw=-270) | 5 | 05/16/2023 00:00:00 | 05/16/2023 00:00:00 |
| Warn_Overlap (PrevLPID=463; PrevEnd=2020-09-11 13:30; GapMinRaw=-30) | 5 | 09/11/2020 00:00:00 | 09/11/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3792; PrevEnd=2021-06-18 07:30; GapMinRaw=-30) | 5 | 06/18/2021 00:00:00 | 06/18/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2116; PrevEnd=2021-02-03 14:30; GapMinRaw=-90) | 5 | 02/03/2021 00:00:00 | 02/03/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3360; PrevEnd=2021-05-20 10:00; GapMinRaw=-60) | 5 | 05/20/2021 00:00:00 | 05/20/2021 00:00:00 |
| Warn_Overlap (PrevLPID=46833; PrevEnd=2024-09-19 22:30; GapMinRaw=-930) | 5 | 09/19/2024 00:00:00 | 09/19/2024 00:00:00 |
| Warn_Overlap (PrevLPID=880; PrevEnd=2020-10-15 10:30; GapMinRaw=-90) | 5 | 10/15/2020 00:00:00 | 10/15/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3961; PrevEnd=2021-06-28 07:30; GapMinRaw=-150) | 5 | 06/28/2021 00:00:00 | 06/28/2021 00:00:00 |
| Warn_Overlap (PrevLPID=240; PrevEnd=2020-08-20 11:00; GapMinRaw=-60) | 5 | 08/20/2020 00:00:00 | 08/20/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3651; PrevEnd=2021-06-10 07:00; GapMinRaw=-30) | 5 | 06/10/2021 00:00:00 | 06/10/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3835; PrevEnd=2021-06-21 12:00; GapMinRaw=-30) | 5 | 06/21/2021 00:00:00 | 06/21/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2074; PrevEnd=2021-01-30 12:30; GapMinRaw=-330) | 5 | 01/30/2021 00:00:00 | 01/30/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3174; PrevEnd=2021-05-06 12:00; GapMinRaw=-30) | 5 | 05/06/2021 00:00:00 | 05/06/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4714; PrevEnd=2021-08-16 09:00; GapMinRaw=-180) | 5 | 08/16/2021 00:00:00 | 08/16/2021 00:00:00 |
| Warn_Overlap (PrevLPID=13810; PrevEnd=2022-07-13 15:00; GapMinRaw=-600) | 5 | 07/13/2022 00:00:00 | 07/13/2022 00:00:00 |
| Warn_Overlap (PrevLPID=46453; PrevEnd=2024-09-09 15:30; GapMinRaw=-30) | 5 | 09/09/2024 00:00:00 | 09/09/2024 00:00:00 |
| Warn_Overlap (PrevLPID=2738; PrevEnd=2021-03-31 07:00; GapMinRaw=-60) | 5 | 03/31/2021 00:00:00 | 03/31/2021 00:00:00 |
| Warn_Overlap (PrevLPID=48028; PrevEnd=2024-10-11 14:00; GapMinRaw=-300) | 5 | 10/11/2024 00:00:00 | 10/11/2024 00:00:00 |
| Warn_Overlap (PrevLPID=50958; PrevEnd=2024-12-16 14:30; GapMinRaw=-480) | 5 | 12/16/2024 00:00:00 | 12/16/2024 00:00:00 |
| Warn_Overlap (PrevLPID=790; PrevEnd=2020-10-08 14:30; GapMinRaw=-120) | 5 | 10/08/2020 00:00:00 | 10/08/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2694; PrevEnd=2021-03-25 09:30; GapMinRaw=-90) | 5 | 03/25/2021 00:00:00 | 03/25/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2038; PrevEnd=2021-01-27 12:30; GapMinRaw=-30) | 5 | 01/27/2021 00:00:00 | 01/27/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2747; PrevEnd=2021-03-31 14:30; GapMinRaw=-150) | 5 | 03/31/2021 00:00:00 | 03/31/2021 00:00:00 |
| Warn_Overlap (PrevLPID=8849; PrevEnd=2022-02-17 14:00; GapMinRaw=-60) | 5 | 02/17/2022 00:00:00 | 02/17/2022 00:00:00 |
| Warn_Overlap (PrevLPID=39459; PrevEnd=2024-03-18 08:00; GapMinRaw=-120) | 5 | 03/18/2024 00:00:00 | 03/18/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1150; PrevEnd=2020-11-05 08:30; GapMinRaw=-30) | 5 | 11/05/2020 00:00:00 | 11/05/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1869; PrevEnd=2021-01-13 07:00; GapMinRaw=-240) | 5 | 01/13/2021 00:00:00 | 01/13/2021 00:00:00 |
| Warn_Overlap (PrevLPID=1905; PrevEnd=2021-01-15 12:00; GapMinRaw=-60) | 5 | 01/15/2021 00:00:00 | 01/15/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2183; PrevEnd=2021-02-09 09:30; GapMinRaw=-60) | 5 | 02/09/2021 00:00:00 | 02/09/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5380; PrevEnd=2021-09-21 12:30; GapMinRaw=-30) | 5 | 09/21/2021 00:00:00 | 09/21/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4137; PrevEnd=2021-07-09 11:30; GapMinRaw=-60) | 5 | 07/09/2021 00:00:00 | 07/09/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4533; PrevEnd=2021-08-04 08:30; GapMinRaw=-60) | 5 | 08/04/2021 00:00:00 | 08/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=39286; PrevEnd=2024-03-15 08:00; GapMinRaw=-150) | 5 | 03/15/2024 00:00:00 | 03/15/2024 00:00:00 |
| Warn_Overlap (PrevLPID=2325; PrevEnd=2021-02-22 14:00; GapMinRaw=-60) | 5 | 02/22/2021 00:00:00 | 02/22/2021 00:00:00 |
| Warn_Overlap (PrevLPID=22574; PrevEnd=2023-03-02 21:30; GapMinRaw=-900) | 5 | 03/02/2023 00:00:00 | 03/02/2023 00:00:00 |
| Warn_Overlap (PrevLPID=24950; PrevEnd=2023-04-25 12:00; GapMinRaw=-30) | 5 | 04/25/2023 00:00:00 | 04/25/2023 00:00:00 |
| Warn_Overlap (PrevLPID=39012; PrevEnd=2024-03-04 19:00; GapMinRaw=-780) | 5 | 03/04/2024 00:00:00 | 03/04/2024 00:00:00 |
| Warn_Overlap (PrevLPID=42517; PrevEnd=2024-06-04 14:30; GapMinRaw=-510) | 5 | 06/04/2024 00:00:00 | 06/04/2024 00:00:00 |
| Warn_Overlap (PrevLPID=10991; PrevEnd=2022-04-22 10:00; GapMinRaw=-60) | 5 | 04/22/2022 00:00:00 | 04/22/2022 00:00:00 |
| Warn_Overlap (PrevLPID=29897; PrevEnd=2023-08-03 12:00; GapMinRaw=-90) | 5 | 08/03/2023 00:00:00 | 08/03/2023 00:00:00 |
| Warn_Overlap (PrevLPID=33128; PrevEnd=2023-10-18 11:30; GapMinRaw=-180) | 5 | 10/18/2023 00:00:00 | 10/18/2023 00:00:00 |
| Warn_Overlap (PrevLPID=46127; PrevEnd=2024-08-29 10:00; GapMinRaw=-150) | 5 | 08/29/2024 00:00:00 | 08/29/2024 00:00:00 |
| Warn_Overlap (PrevLPID=47175; PrevEnd=2024-09-26 07:00; GapMinRaw=-300) | 5 | 09/26/2024 00:00:00 | 09/26/2024 00:00:00 |
| Warn_Overlap (PrevLPID=694; PrevEnd=2020-10-01 10:30; GapMinRaw=-120) | 5 | 10/01/2020 00:00:00 | 10/01/2020 00:00:00 |
| Warn_Overlap (PrevLPID=841; PrevEnd=2020-10-13 13:00; GapMinRaw=-30) | 5 | 10/13/2020 00:00:00 | 10/13/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3363; PrevEnd=2021-05-20 12:00; GapMinRaw=-60) | 5 | 05/20/2021 00:00:00 | 05/20/2021 00:00:00 |
| Warn_Overlap (PrevLPID=48560; PrevEnd=2024-10-26 04:30; GapMinRaw=-30) | 5 | 10/26/2024 00:00:00 | 10/26/2024 00:00:00 |
| Warn_Overlap (PrevLPID=43006; PrevEnd=2024-06-17 07:30; GapMinRaw=-30) | 5 | 06/17/2024 00:00:00 | 06/17/2024 00:00:00 |
| Warn_Overlap (PrevLPID=4277; PrevEnd=2021-07-19 10:00; GapMinRaw=-60) | 5 | 07/19/2021 00:00:00 | 07/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=9324; PrevEnd=2022-03-03 11:30; GapMinRaw=-60) | 5 | 03/03/2022 00:00:00 | 03/03/2022 00:00:00 |
| Warn_Overlap (PrevLPID=39037; PrevEnd=2024-03-07 19:30; GapMinRaw=-750) | 5 | 03/07/2024 00:00:00 | 03/07/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1427; PrevEnd=2020-12-01 15:30; GapMinRaw=-420) | 5 | 12/01/2020 00:00:00 | 12/01/2020 00:00:00 |
| Warn_Overlap (PrevLPID=8451; PrevEnd=2022-02-09 10:00; GapMinRaw=-30) | 5 | 02/09/2022 00:00:00 | 02/09/2022 00:00:00 |
| Warn_Overlap (PrevLPID=85; PrevEnd=2020-07-22 13:30; GapMinRaw=-510) | 5 | 07/22/2020 00:00:00 | 07/22/2020 00:00:00 |
| Warn_Overlap (PrevLPID=430; PrevEnd=2020-09-09 23:30; GapMinRaw=-720) | 5 | 09/09/2020 00:00:00 | 09/09/2020 00:00:00 |
| Warn_Overlap (PrevLPID=5713; PrevEnd=2021-10-07 13:00; GapMinRaw=-30) | 5 | 10/07/2021 00:00:00 | 10/07/2021 00:00:00 |
| Warn_Overlap (PrevLPID=7640; PrevEnd=2022-01-17 09:00; GapMinRaw=-30) | 5 | 01/17/2022 00:00:00 | 01/17/2022 00:00:00 |
| Warn_Overlap (PrevLPID=28261; PrevEnd=2023-06-29 08:00; GapMinRaw=-150) | 5 | 06/29/2023 00:00:00 | 06/29/2023 00:00:00 |
| Warn_Overlap (PrevLPID=532; PrevEnd=2020-09-18 14:30; GapMinRaw=-90) | 5 | 09/18/2020 00:00:00 | 09/18/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1293; PrevEnd=2020-11-17 10:00; GapMinRaw=-30) | 5 | 11/17/2020 00:00:00 | 11/17/2020 00:00:00 |
| Warn_Overlap (PrevLPID=34711; PrevEnd=2023-11-16 21:00; GapMinRaw=-900) | 5 | 11/16/2023 00:00:00 | 11/16/2023 00:00:00 |
| Warn_Overlap (PrevLPID=2813; PrevEnd=2021-04-07 11:30; GapMinRaw=-30) | 5 | 04/07/2021 00:00:00 | 04/07/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5933; PrevEnd=2021-10-19 10:00; GapMinRaw=-210) | 5 | 10/19/2021 00:00:00 | 10/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=9891; PrevEnd=2022-03-14 19:30; GapMinRaw=-750) | 5 | 03/14/2022 00:00:00 | 03/14/2022 00:00:00 |
| Warn_Overlap (PrevLPID=17688; PrevEnd=2022-10-26 10:00; GapMinRaw=-30) | 5 | 10/26/2022 00:00:00 | 10/26/2022 00:00:00 |
| Warn_Overlap (PrevLPID=34501; PrevEnd=2023-11-14 22:00; GapMinRaw=-960) | 5 | 11/14/2023 00:00:00 | 11/14/2023 00:00:00 |
| Warn_Overlap (PrevLPID=46081; PrevEnd=2024-08-29 15:30; GapMinRaw=-510) | 5 | 08/29/2024 00:00:00 | 08/29/2024 00:00:00 |
| Warn_Overlap (PrevLPID=5585; PrevEnd=2021-09-30 09:00; GapMinRaw=-90) | 5 | 09/30/2021 00:00:00 | 09/30/2021 00:00:00 |
| Warn_Overlap (PrevLPID=50964; PrevEnd=2024-12-16 17:00; GapMinRaw=-720) | 5 | 12/16/2024 00:00:00 | 12/16/2024 00:00:00 |
| Warn_Overlap (PrevLPID=582; PrevEnd=2020-09-23 09:00; GapMinRaw=-60) | 5 | 09/23/2020 00:00:00 | 09/23/2020 00:00:00 |
| Warn_Overlap (PrevLPID=615; PrevEnd=2020-09-25 12:00; GapMinRaw=-30) | 5 | 09/25/2020 00:00:00 | 09/25/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4160; PrevEnd=2021-07-12 07:30; GapMinRaw=-30) | 5 | 07/12/2021 00:00:00 | 07/12/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4220; PrevEnd=2021-07-15 11:00; GapMinRaw=-60) | 5 | 07/15/2021 00:00:00 | 07/15/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4390; PrevEnd=2021-07-26 12:30; GapMinRaw=-60) | 5 | 07/26/2021 00:00:00 | 07/26/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4934; PrevEnd=2021-08-26 22:30; GapMinRaw=-720) | 5 | 08/26/2021 00:00:00 | 08/26/2021 00:00:00 |
| Warn_Overlap (PrevLPID=678; PrevEnd=2020-09-30 10:00; GapMinRaw=-60) | 5 | 09/30/2020 00:00:00 | 09/30/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1918; PrevEnd=2021-01-16 15:00; GapMinRaw=-540) | 5 | 01/16/2021 00:00:00 | 01/16/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3875; PrevEnd=2021-06-23 06:30; GapMinRaw=-30) | 5 | 06/23/2021 00:00:00 | 06/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=6302; PrevEnd=2021-11-03 09:00; GapMinRaw=-90) | 5 | 11/03/2021 00:00:00 | 11/03/2021 00:00:00 |
| Warn_Overlap (PrevLPID=14029; PrevEnd=2022-07-26 11:30; GapMinRaw=-390) | 5 | 07/26/2022 00:00:00 | 07/26/2022 00:00:00 |
| Warn_Overlap (PrevLPID=39180; PrevEnd=2024-03-15 10:00; GapMinRaw=-180) | 5 | 03/15/2024 00:00:00 | 03/15/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1151; PrevEnd=2020-11-05 12:00; GapMinRaw=-120) | 5 | 11/05/2020 00:00:00 | 11/05/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3447; PrevEnd=2021-05-26 09:30; GapMinRaw=-90) | 5 | 05/26/2021 00:00:00 | 05/26/2021 00:00:00 |
| Warn_Overlap (PrevLPID=48685; PrevEnd=2024-10-24 15:30; GapMinRaw=-420) | 5 | 10/24/2024 00:00:00 | 10/24/2024 00:00:00 |
| Warn_Overlap (PrevLPID=51172; PrevEnd=2024-12-20 05:30; GapMinRaw=-30) | 5 | 12/20/2024 00:00:00 | 12/20/2024 00:00:00 |
| Warn_Overlap (PrevLPID=50855; PrevEnd=2024-12-13 15:00; GapMinRaw=-630) | 5 | 12/13/2024 00:00:00 | 12/13/2024 00:00:00 |
| Warn_Overlap (PrevLPID=497; PrevEnd=2020-09-15 10:30; GapMinRaw=-150) | 5 | 09/15/2020 00:00:00 | 09/15/2020 00:00:00 |
| Warn_Overlap (PrevLPID=5240; PrevEnd=2021-09-14 12:00; GapMinRaw=-210) | 5 | 09/14/2021 00:00:00 | 09/14/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5420; PrevEnd=2021-09-23 09:30; GapMinRaw=-270) | 5 | 09/23/2021 00:00:00 | 09/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2601; PrevEnd=2021-03-18 23:30; GapMinRaw=-690) | 5 | 03/18/2021 00:00:00 | 03/18/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3071; PrevEnd=2021-04-27 13:30; GapMinRaw=-30) | 5 | 04/27/2021 00:00:00 | 04/27/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3488; PrevEnd=2021-05-28 08:00; GapMinRaw=-30) | 5 | 05/28/2021 00:00:00 | 05/28/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4123; PrevEnd=2021-07-08 15:00; GapMinRaw=-450) | 5 | 07/08/2021 00:00:00 | 07/08/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4552; PrevEnd=2021-08-05 08:00; GapMinRaw=-30) | 5 | 08/05/2021 00:00:00 | 08/05/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5303; PrevEnd=2021-09-16 09:30; GapMinRaw=-30) | 5 | 09/16/2021 00:00:00 | 09/16/2021 00:00:00 |
| Warn_Overlap (PrevLPID=43206; PrevEnd=2024-06-24 19:30; GapMinRaw=-30) | 5 | 06/24/2024 00:00:00 | 06/24/2024 00:00:00 |
| Warn_Overlap (PrevLPID=53; PrevEnd=2020-07-14 14:30; GapMinRaw=-300) | 5 | 07/14/2020 00:00:00 | 07/14/2020 00:00:00 |
| Warn_Overlap (PrevLPID=312; PrevEnd=2020-08-28 09:30; GapMinRaw=-30) | 5 | 08/28/2020 00:00:00 | 08/28/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3216; PrevEnd=2021-05-11 09:00; GapMinRaw=-30) | 5 | 05/11/2021 00:00:00 | 05/11/2021 00:00:00 |
| Warn_Overlap (PrevLPID=11903; PrevEnd=2022-05-14 15:30; GapMinRaw=-480) | 5 | 05/14/2022 00:00:00 | 05/14/2022 00:00:00 |
| Warn_Overlap (PrevLPID=298; PrevEnd=2020-08-27 07:00; GapMinRaw=-60) | 5 | 08/27/2020 00:00:00 | 08/27/2020 00:00:00 |
| Warn_Overlap (PrevLPID=738; PrevEnd=2020-10-05 09:00; GapMinRaw=-30) | 5 | 10/05/2020 00:00:00 | 10/05/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3334; PrevEnd=2021-05-19 09:00; GapMinRaw=-30) | 5 | 05/19/2021 00:00:00 | 05/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4651; PrevEnd=2021-08-11 10:30; GapMinRaw=-90) | 5 | 08/11/2021 00:00:00 | 08/11/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3940; PrevEnd=2021-06-25 12:30; GapMinRaw=-30) | 5 | 06/25/2021 00:00:00 | 06/25/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4988; PrevEnd=2021-08-30 11:30; GapMinRaw=-60) | 5 | 08/30/2021 00:00:00 | 08/30/2021 00:00:00 |
| Warn_Overlap (PrevLPID=39249; PrevEnd=2024-03-12 23:00; GapMinRaw=-1080) | 5 | 03/12/2024 00:00:00 | 03/12/2024 00:00:00 |
| Warn_Overlap (PrevLPID=50859; PrevEnd=2024-12-14 12:30; GapMinRaw=-390) | 5 | 12/14/2024 00:00:00 | 12/14/2024 00:00:00 |
| Warn_Overlap (PrevLPID=2783; PrevEnd=2021-04-02 18:30; GapMinRaw=-120) | 5 | 04/02/2021 00:00:00 | 04/02/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3067; PrevEnd=2021-04-27 09:30; GapMinRaw=-60) | 5 | 04/27/2021 00:00:00 | 04/27/2021 00:00:00 |
| Warn_Overlap (PrevLPID=120; PrevEnd=2020-07-14 14:30; GapMinRaw=-510) | 5 | 07/14/2020 00:00:00 | 07/14/2020 00:00:00 |
| Warn_Overlap (PrevLPID=711; PrevEnd=2020-10-02 10:30; GapMinRaw=-30) | 5 | 10/02/2020 00:00:00 | 10/02/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2626; PrevEnd=2021-03-22 13:00; GapMinRaw=-30) | 5 | 03/22/2021 00:00:00 | 03/22/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4013; PrevEnd=2021-06-30 10:00; GapMinRaw=-60) | 5 | 06/30/2021 00:00:00 | 06/30/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4115; PrevEnd=2021-07-08 09:00; GapMinRaw=-30) | 5 | 07/08/2021 00:00:00 | 07/08/2021 00:00:00 |
| Warn_Overlap (PrevLPID=22575; PrevEnd=2023-03-02 15:00; GapMinRaw=-480) | 5 | 03/02/2023 00:00:00 | 03/02/2023 00:00:00 |
| Warn_Overlap (PrevLPID=37548; PrevEnd=2024-01-27 08:00; GapMinRaw=-60) | 5 | 01/27/2024 00:00:00 | 01/27/2024 00:00:00 |
| Warn_Overlap (PrevLPID=25; PrevEnd=2020-07-06 15:00; GapMinRaw=-330) | 5 | 07/06/2020 00:00:00 | 07/06/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3293; PrevEnd=2021-05-17 11:00; GapMinRaw=-60) | 5 | 05/17/2021 00:00:00 | 05/17/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3337; PrevEnd=2021-05-19 12:00; GapMinRaw=-60) | 5 | 05/19/2021 00:00:00 | 05/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4749; PrevEnd=2021-08-17 13:00; GapMinRaw=-60) | 5 | 08/17/2021 00:00:00 | 08/17/2021 00:00:00 |
| Warn_Overlap (PrevLPID=36592; PrevEnd=2024-01-09 09:30; GapMinRaw=-30) | 5 | 01/09/2024 00:00:00 | 01/09/2024 00:00:00 |
| Warn_Overlap (PrevLPID=220; PrevEnd=2020-08-16 13:30; GapMinRaw=-90) | 5 | 08/16/2020 00:00:00 | 08/16/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2216; PrevEnd=2021-02-11 12:30; GapMinRaw=-120) | 5 | 02/11/2021 00:00:00 | 02/11/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4854; PrevEnd=2021-08-23 10:30; GapMinRaw=-60) | 5 | 08/23/2021 00:00:00 | 08/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4930; PrevEnd=2021-08-26 08:30; GapMinRaw=-150) | 5 | 08/26/2021 00:00:00 | 08/26/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5778; PrevEnd=2021-10-12 10:00; GapMinRaw=-30) | 5 | 10/12/2021 00:00:00 | 10/12/2021 00:00:00 |
| Warn_Overlap (PrevLPID=16442; PrevEnd=2022-09-23 16:00; GapMinRaw=-600) | 5 | 09/23/2022 00:00:00 | 09/23/2022 00:00:00 |
| Warn_Overlap (PrevLPID=25008; PrevEnd=2023-04-27 11:00; GapMinRaw=-60) | 5 | 04/27/2023 00:00:00 | 04/27/2023 00:00:00 |
| Warn_Overlap (PrevLPID=40398; PrevEnd=2024-04-11 08:00; GapMinRaw=-270) | 5 | 04/11/2024 00:00:00 | 04/11/2024 00:00:00 |
| Warn_Overlap (PrevLPID=9907; PrevEnd=2022-03-21 17:30; GapMinRaw=-600) | 5 | 03/21/2022 00:00:00 | 03/21/2022 00:00:00 |
| Warn_Overlap (PrevLPID=5168; PrevEnd=2021-09-09 14:00; GapMinRaw=-60) | 5 | 09/09/2021 00:00:00 | 09/09/2021 00:00:00 |
| Warn_Overlap (PrevLPID=9139; PrevEnd=2022-02-28 09:30; GapMinRaw=-60) | 5 | 02/28/2022 00:00:00 | 02/28/2022 00:00:00 |
| Warn_Overlap (PrevLPID=293; PrevEnd=2020-08-26 15:30; GapMinRaw=-90) | 5 | 08/26/2020 00:00:00 | 08/26/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2112; PrevEnd=2021-02-03 10:30; GapMinRaw=-60) | 5 | 02/03/2021 00:00:00 | 02/03/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2472; PrevEnd=2021-03-05 12:00; GapMinRaw=-90) | 5 | 03/05/2021 00:00:00 | 03/05/2021 00:00:00 |
| Warn_Overlap (PrevLPID=40416; PrevEnd=2024-04-06 21:00; GapMinRaw=-120) | 5 | 04/06/2024 00:00:00 | 04/06/2024 00:00:00 |
| Warn_Overlap (PrevLPID=3001; PrevEnd=2021-04-21 14:00; GapMinRaw=-30) | 5 | 04/21/2021 00:00:00 | 04/21/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3871; PrevEnd=2021-06-22 12:30; GapMinRaw=-60) | 5 | 06/22/2021 00:00:00 | 06/22/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3914; PrevEnd=2021-06-24 15:00; GapMinRaw=-30) | 5 | 06/24/2021 00:00:00 | 06/24/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4844; PrevEnd=2021-08-23 11:00; GapMinRaw=-300) | 5 | 08/23/2021 00:00:00 | 08/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5466; PrevEnd=2021-09-27 10:00; GapMinRaw=-30) | 5 | 09/27/2021 00:00:00 | 09/27/2021 00:00:00 |
| Warn_Overlap (PrevLPID=7651; PrevEnd=2022-01-17 11:00; GapMinRaw=-90) | 5 | 01/17/2022 00:00:00 | 01/17/2022 00:00:00 |
| Warn_Overlap (PrevLPID=4562; PrevEnd=2021-08-05 11:30; GapMinRaw=-30) | 5 | 08/05/2021 00:00:00 | 08/05/2021 00:00:00 |
| Warn_Overlap (PrevLPID=438; PrevEnd=2020-09-10 10:30; GapMinRaw=-90) | 5 | 09/10/2020 00:00:00 | 09/10/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1459; PrevEnd=2020-12-04 13:00; GapMinRaw=-90) | 5 | 12/04/2020 00:00:00 | 12/04/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2753; PrevEnd=2021-03-31 14:30; GapMinRaw=-150) | 5 | 03/31/2021 00:00:00 | 03/31/2021 00:00:00 |
| Warn_Overlap (PrevLPID=43680; PrevEnd=2024-07-09 13:30; GapMinRaw=-360) | 5 | 07/09/2024 00:00:00 | 07/09/2024 00:00:00 |
| Warn_Overlap (PrevLPID=2617; PrevEnd=2021-03-19 14:00; GapMinRaw=-60) | 5 | 03/19/2021 00:00:00 | 03/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=39283; PrevEnd=2024-03-12 08:00; GapMinRaw=-270) | 5 | 03/12/2024 00:00:00 | 03/12/2024 00:00:00 |
| Warn_Overlap (PrevLPID=46133; PrevEnd=2024-08-28 12:30; GapMinRaw=-270) | 5 | 08/28/2024 00:00:00 | 08/28/2024 00:00:00 |
| Warn_Overlap (PrevLPID=43; PrevEnd=2020-07-11 16:00; GapMinRaw=-360) | 5 | 07/11/2020 00:00:00 | 07/11/2020 00:00:00 |
| Warn_Overlap (PrevLPID=666; PrevEnd=2020-10-29 14:00; GapMinRaw=-480) | 5 | 10/29/2020 00:00:00 | 10/29/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1601; PrevEnd=2020-12-18 09:30; GapMinRaw=-30) | 5 | 12/18/2020 00:00:00 | 12/18/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2618; PrevEnd=2021-03-19 14:00; GapMinRaw=-60) | 5 | 03/19/2021 00:00:00 | 03/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2727; PrevEnd=2021-03-30 10:30; GapMinRaw=-60) | 5 | 03/30/2021 00:00:00 | 03/30/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3135; PrevEnd=2021-05-04 13:30; GapMinRaw=-90) | 5 | 05/04/2021 00:00:00 | 05/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=8152; PrevEnd=2022-02-01 10:00; GapMinRaw=-30) | 5 | 02/01/2022 00:00:00 | 02/01/2022 00:00:00 |
| Warn_Overlap (PrevLPID=24986; PrevEnd=2023-04-26 11:00; GapMinRaw=-30) | 5 | 04/26/2023 00:00:00 | 04/26/2023 00:00:00 |
| Warn_Overlap (PrevLPID=40208; PrevEnd=2024-04-06 08:00; GapMinRaw=-180) | 5 | 04/06/2024 00:00:00 | 04/06/2024 00:00:00 |
| Warn_Overlap (PrevLPID=51310; PrevEnd=2024-12-23 09:00; GapMinRaw=-300) | 5 | 12/23/2024 00:00:00 | 12/23/2024 00:00:00 |
| Warn_Overlap (PrevLPID=340; PrevEnd=2020-08-31 12:30; GapMinRaw=-60) | 5 | 08/31/2020 00:00:00 | 08/31/2020 00:00:00 |
| Warn_Overlap (PrevLPID=10135; PrevEnd=2022-03-20 19:00; GapMinRaw=-120) | 5 | 03/20/2022 00:00:00 | 03/20/2022 00:00:00 |
| Warn_Overlap (PrevLPID=566; PrevEnd=2020-09-22 08:00; GapMinRaw=-30) | 5 | 09/22/2020 00:00:00 | 09/22/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1152; PrevEnd=2020-11-05 10:30; GapMinRaw=-30) | 5 | 11/05/2020 00:00:00 | 11/05/2020 00:00:00 |
| Warn_Overlap (PrevLPID=600; PrevEnd=2020-09-24 09:30; GapMinRaw=-30) | 5 | 09/24/2020 00:00:00 | 09/24/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4698; PrevEnd=2021-08-13 11:30; GapMinRaw=-30) | 5 | 08/13/2021 00:00:00 | 08/13/2021 00:00:00 |
| Warn_Overlap (PrevLPID=36844; PrevEnd=2024-01-08 19:30; GapMinRaw=-810) | 5 | 01/08/2024 00:00:00 | 01/08/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1909; PrevEnd=2021-01-15 16:30; GapMinRaw=-630) | 5 | 01/15/2021 00:00:00 | 01/15/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2456; PrevEnd=2021-03-04 08:30; GapMinRaw=-30) | 5 | 03/04/2021 00:00:00 | 03/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4671; PrevEnd=2021-08-12 10:00; GapMinRaw=-30) | 5 | 08/12/2021 00:00:00 | 08/12/2021 00:00:00 |
| Warn_Overlap (PrevLPID=1944; PrevEnd=2021-01-19 10:00; GapMinRaw=-120) | 5 | 01/19/2021 00:00:00 | 01/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5080; PrevEnd=2021-09-03 10:00; GapMinRaw=-60) | 5 | 09/03/2021 00:00:00 | 09/03/2021 00:00:00 |
| Warn_Overlap (PrevLPID=42866; PrevEnd=2024-06-12 16:00; GapMinRaw=-420) | 5 | 06/12/2024 00:00:00 | 06/12/2024 00:00:00 |
| Warn_Overlap (PrevLPID=4465; PrevEnd=2021-07-30 10:00; GapMinRaw=-30) | 5 | 07/30/2021 00:00:00 | 07/30/2021 00:00:00 |
| Warn_Overlap (PrevLPID=40413; PrevEnd=2024-04-09 17:00; GapMinRaw=-510) | 5 | 04/09/2024 00:00:00 | 04/09/2024 00:00:00 |
| Warn_Overlap (PrevLPID=43952; PrevEnd=2024-07-13 19:00; GapMinRaw=-120) | 5 | 07/13/2024 00:00:00 | 07/13/2024 00:00:00 |
| Warn_Overlap (PrevLPID=13873; PrevEnd=2022-07-20 02:30; GapMinRaw=-360) | 5 | 07/19/2022 00:00:00 | 07/19/2022 00:00:00 |
| Warn_Overlap (PrevLPID=40502; PrevEnd=2024-04-16 04:00; GapMinRaw=-450) | 5 | 04/15/2024 00:00:00 | 04/15/2024 00:00:00 |
| Warn_Overlap (PrevLPID=614; PrevEnd=2020-09-25 11:30; GapMinRaw=-90) | 5 | 09/25/2020 00:00:00 | 09/25/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1021; PrevEnd=2020-10-27 09:30; GapMinRaw=-30) | 5 | 10/27/2020 00:00:00 | 10/27/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2905; PrevEnd=2021-04-14 10:00; GapMinRaw=-60) | 5 | 04/14/2021 00:00:00 | 04/14/2021 00:00:00 |
| Warn_Overlap (PrevLPID=13346; PrevEnd=2022-07-01 19:30; GapMinRaw=-660) | 5 | 07/01/2022 00:00:00 | 07/01/2022 00:00:00 |
| Warn_Overlap (PrevLPID=5599; PrevEnd=2021-09-30 10:30; GapMinRaw=-60) | 5 | 09/30/2021 00:00:00 | 09/30/2021 00:00:00 |
| Warn_Overlap (PrevLPID=394; PrevEnd=2020-09-04 08:30; GapMinRaw=-30) | 5 | 09/04/2020 00:00:00 | 09/04/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3274; PrevEnd=2021-05-14 14:00; GapMinRaw=-60) | 5 | 05/14/2021 00:00:00 | 05/14/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4054; PrevEnd=2021-07-01 12:00; GapMinRaw=-120) | 5 | 07/01/2021 00:00:00 | 07/01/2021 00:00:00 |
| Warn_Overlap (PrevLPID=11876; PrevEnd=2022-05-17 09:30; GapMinRaw=-30) | 5 | 05/17/2022 00:00:00 | 05/17/2022 00:00:00 |
| Warn_Overlap (PrevLPID=39141; PrevEnd=2024-03-14 15:30; GapMinRaw=-450) | 5 | 03/14/2024 00:00:00 | 03/14/2024 00:00:00 |
| Warn_Overlap (PrevLPID=45343; PrevEnd=2024-08-13 10:00; GapMinRaw=-120) | 5 | 08/13/2024 00:00:00 | 08/13/2024 00:00:00 |
| Warn_Overlap (PrevLPID=50823; PrevEnd=2024-12-14 11:00; GapMinRaw=-270) | 5 | 12/14/2024 00:00:00 | 12/14/2024 00:00:00 |
| Warn_Overlap (PrevLPID=456; PrevEnd=2020-09-11 09:00; GapMinRaw=-60) | 5 | 09/11/2020 00:00:00 | 09/11/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2551; PrevEnd=2021-03-12 08:00; GapMinRaw=-30) | 5 | 03/12/2021 00:00:00 | 03/12/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5214; PrevEnd=2021-09-13 14:00; GapMinRaw=-30) | 5 | 09/13/2021 00:00:00 | 09/13/2021 00:00:00 |
| Warn_Overlap (PrevLPID=50429; PrevEnd=2024-12-05 17:00; GapMinRaw=-30) | 5 | 12/05/2024 00:00:00 | 12/05/2024 00:00:00 |
| Warn_Overlap (PrevLPID=38831; PrevEnd=2024-03-01 11:00; GapMinRaw=-180) | 5 | 03/01/2024 00:00:00 | 03/01/2024 00:00:00 |
| Warn_Overlap (PrevLPID=584; PrevEnd=2020-09-23 12:00; GapMinRaw=-90) | 5 | 09/23/2020 00:00:00 | 09/23/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3902; PrevEnd=2021-06-24 09:00; GapMinRaw=-30) | 5 | 06/24/2021 00:00:00 | 06/24/2021 00:00:00 |
| Warn_Overlap (PrevLPID=29852; PrevEnd=2023-08-03 07:30; GapMinRaw=-30) | 5 | 08/03/2023 00:00:00 | 08/03/2023 00:00:00 |
| Warn_Overlap (PrevLPID=228; PrevEnd=2020-08-19 13:00; GapMinRaw=-120) | 5 | 08/19/2020 00:00:00 | 08/19/2020 00:00:00 |
| Warn_Overlap (PrevLPID=6711; PrevEnd=2021-11-23 08:00; GapMinRaw=-30) | 5 | 11/23/2021 00:00:00 | 11/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=38810; PrevEnd=2024-03-01 14:30; GapMinRaw=-450) | 5 | 03/01/2024 00:00:00 | 03/01/2024 00:00:00 |
| Warn_Overlap (PrevLPID=42912; PrevEnd=2024-06-12 09:00; GapMinRaw=-150) | 5 | 06/12/2024 00:00:00 | 06/12/2024 00:00:00 |
| Warn_Overlap (PrevLPID=45336; PrevEnd=2024-08-13 15:30; GapMinRaw=-450) | 5 | 08/13/2024 00:00:00 | 08/13/2024 00:00:00 |
| Warn_Overlap (PrevLPID=5208; PrevEnd=2021-09-13 08:30; GapMinRaw=-30) | 5 | 09/13/2021 00:00:00 | 09/13/2021 00:00:00 |
| Warn_Overlap (PrevLPID=13863; PrevEnd=2022-07-19 10:30; GapMinRaw=-30) | 5 | 07/19/2022 00:00:00 | 07/19/2022 00:00:00 |
| Warn_Overlap (PrevLPID=3900; PrevEnd=2021-06-24 07:00; GapMinRaw=-30) | 5 | 06/24/2021 00:00:00 | 06/24/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5112; PrevEnd=2021-09-07 12:30; GapMinRaw=-30) | 5 | 09/07/2021 00:00:00 | 09/07/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5295; PrevEnd=2021-09-15 21:00; GapMinRaw=-720) | 5 | 09/15/2021 00:00:00 | 09/15/2021 00:00:00 |
| Warn_Overlap (PrevLPID=11667; PrevEnd=2022-05-09 17:30; GapMinRaw=-690) | 5 | 05/09/2022 00:00:00 | 05/09/2022 00:00:00 |
| Warn_Overlap (PrevLPID=2878; PrevEnd=2021-04-13 10:30; GapMinRaw=-30) | 5 | 04/13/2021 00:00:00 | 04/13/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3659; PrevEnd=2021-06-10 12:00; GapMinRaw=-30) | 5 | 06/10/2021 00:00:00 | 06/10/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4679; PrevEnd=2021-08-12 12:00; GapMinRaw=-60) | 5 | 08/12/2021 00:00:00 | 08/12/2021 00:00:00 |
| Warn_Overlap (PrevLPID=46126; PrevEnd=2024-08-29 16:00; GapMinRaw=-540) | 5 | 08/29/2024 00:00:00 | 08/29/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1799; PrevEnd=2021-01-07 10:30; GapMinRaw=-30) | 5 | 01/07/2021 00:00:00 | 01/07/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2974; PrevEnd=2021-04-20 09:00; GapMinRaw=-60) | 5 | 04/20/2021 00:00:00 | 04/20/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3435; PrevEnd=2021-05-25 10:30; GapMinRaw=-30) | 5 | 05/25/2021 00:00:00 | 05/25/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3687; PrevEnd=2021-06-11 11:00; GapMinRaw=-120) | 5 | 06/11/2021 00:00:00 | 06/11/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2323; PrevEnd=2021-02-22 09:30; GapMinRaw=-90) | 5 | 02/22/2021 00:00:00 | 02/22/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2457; PrevEnd=2021-03-04 11:30; GapMinRaw=-60) | 5 | 03/04/2021 00:00:00 | 03/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3720; PrevEnd=2021-06-15 07:30; GapMinRaw=-30) | 5 | 06/15/2021 00:00:00 | 06/15/2021 00:00:00 |
| Warn_Overlap (PrevLPID=1251; PrevEnd=2020-11-13 10:00; GapMinRaw=-30) | 5 | 11/13/2020 00:00:00 | 11/13/2020 00:00:00 |
| Warn_Overlap (PrevLPID=9617; PrevEnd=2022-03-14 13:00; GapMinRaw=-90) | 5 | 03/14/2022 00:00:00 | 03/14/2022 00:00:00 |
| Warn_Overlap (PrevLPID=20397; PrevEnd=2023-01-12 15:00; GapMinRaw=-510) | 5 | 01/12/2023 00:00:00 | 01/12/2023 00:00:00 |
| Warn_Overlap (PrevLPID=38999; PrevEnd=2024-03-04 12:00; GapMinRaw=-300) | 5 | 03/04/2024 00:00:00 | 03/04/2024 00:00:00 |
| Warn_Overlap (PrevLPID=811; PrevEnd=2020-10-09 17:30; GapMinRaw=-690) | 5 | 10/09/2020 00:00:00 | 10/09/2020 00:00:00 |
| Warn_Overlap (PrevLPID=6463; PrevEnd=2021-11-10 11:30; GapMinRaw=-30) | 5 | 11/10/2021 00:00:00 | 11/10/2021 00:00:00 |
| Warn_Overlap (PrevLPID=14026; PrevEnd=2022-07-21 14:00; GapMinRaw=-330) | 5 | 07/21/2022 00:00:00 | 07/21/2022 00:00:00 |
| Warn_Overlap (PrevLPID=39698; PrevEnd=2024-03-27 08:00; GapMinRaw=-120) | 5 | 03/27/2024 00:00:00 | 03/27/2024 00:00:00 |
| Warn_Overlap (PrevLPID=45510; PrevEnd=2024-08-15 13:30; GapMinRaw=-330) | 5 | 08/15/2024 00:00:00 | 08/15/2024 00:00:00 |
| Warn_Overlap (PrevLPID=2132; PrevEnd=2021-02-04 12:00; GapMinRaw=-30) | 5 | 02/04/2021 00:00:00 | 02/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5294; PrevEnd=2021-09-15 23:00; GapMinRaw=-720) | 5 | 09/15/2021 00:00:00 | 09/15/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2450; PrevEnd=2021-03-03 14:00; GapMinRaw=-30) | 5 | 03/03/2021 00:00:00 | 03/03/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4349; PrevEnd=2021-07-23 11:00; GapMinRaw=-60) | 5 | 07/23/2021 00:00:00 | 07/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=6718; PrevEnd=2021-11-24 08:30; GapMinRaw=-60) | 5 | 11/24/2021 00:00:00 | 11/24/2021 00:00:00 |
| Warn_Overlap (PrevLPID=10136; PrevEnd=2022-03-21 19:00; GapMinRaw=-690) | 5 | 03/21/2022 00:00:00 | 03/21/2022 00:00:00 |
| Warn_Overlap (PrevLPID=33155; PrevEnd=2023-10-16 14:00; GapMinRaw=-360) | 5 | 10/16/2023 00:00:00 | 10/16/2023 00:00:00 |
| Warn_Overlap (PrevLPID=51003; PrevEnd=2024-12-14 06:30; GapMinRaw=-60) | 5 | 12/14/2024 00:00:00 | 12/14/2024 00:00:00 |
| Warn_Overlap (PrevLPID=134; PrevEnd=2020-07-30 16:00; GapMinRaw=-510) | 5 | 07/30/2020 00:00:00 | 07/30/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3976; PrevEnd=2021-06-28 12:30; GapMinRaw=-60) | 5 | 06/28/2021 00:00:00 | 06/28/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5319; PrevEnd=2021-09-17 07:00; GapMinRaw=-180) | 5 | 09/17/2021 00:00:00 | 09/17/2021 00:00:00 |
| Warn_Overlap (PrevLPID=40503; PrevEnd=2024-04-16 07:00; GapMinRaw=-60) | 5 | 04/16/2024 00:00:00 | 04/16/2024 00:00:00 |
| Warn_Overlap (PrevLPID=51222; PrevEnd=2024-12-20 07:30; GapMinRaw=-30) | 5 | 12/20/2024 00:00:00 | 12/20/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1872; PrevEnd=2021-01-13 11:00; GapMinRaw=-90) | 5 | 01/13/2021 00:00:00 | 01/13/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3053; PrevEnd=2021-04-26 12:30; GapMinRaw=-240) | 5 | 04/26/2021 00:00:00 | 04/26/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4526; PrevEnd=2021-08-03 20:30; GapMinRaw=-720) | 5 | 08/03/2021 00:00:00 | 08/03/2021 00:00:00 |
| Warn_Overlap (PrevLPID=1149; PrevEnd=2020-11-05 08:30; GapMinRaw=-60) | 5 | 11/05/2020 00:00:00 | 11/05/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4592; PrevEnd=2021-08-07 12:30; GapMinRaw=-60) | 5 | 08/07/2021 00:00:00 | 08/07/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2215; PrevEnd=2021-02-11 10:00; GapMinRaw=-30) | 5 | 02/11/2021 00:00:00 | 02/11/2021 00:00:00 |
| Warn_Overlap (PrevLPID=418; PrevEnd=2020-09-09 11:00; GapMinRaw=-60) | 5 | 09/09/2020 00:00:00 | 09/09/2020 00:00:00 |
| Warn_Overlap (PrevLPID=41327; PrevEnd=2024-05-07 08:00; GapMinRaw=-270) | 5 | 05/07/2024 00:00:00 | 05/07/2024 00:00:00 |
| Warn_Overlap (PrevLPID=288; PrevEnd=2020-08-26 13:00; GapMinRaw=-30) | 5 | 08/26/2020 00:00:00 | 08/26/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4177; PrevEnd=2021-07-13 10:00; GapMinRaw=-30) | 5 | 07/13/2021 00:00:00 | 07/13/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5183; PrevEnd=2021-09-10 15:00; GapMinRaw=-390) | 5 | 09/10/2021 00:00:00 | 09/10/2021 00:00:00 |
| Warn_Overlap (PrevLPID=38673; PrevEnd=2024-02-26 21:30; GapMinRaw=-900) | 5 | 02/26/2024 00:00:00 | 02/26/2024 00:00:00 |
| Warn_Overlap (PrevLPID=3911; PrevEnd=2021-06-24 11:00; GapMinRaw=-90) | 5 | 06/24/2021 00:00:00 | 06/24/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4329; PrevEnd=2021-07-22 09:30; GapMinRaw=-30) | 5 | 07/22/2021 00:00:00 | 07/22/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5612; PrevEnd=2021-10-01 12:00; GapMinRaw=-30) | 5 | 10/01/2021 00:00:00 | 10/01/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5012; PrevEnd=2021-08-31 12:00; GapMinRaw=-60) | 5 | 08/31/2021 00:00:00 | 08/31/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5259; PrevEnd=2021-09-15 06:30; GapMinRaw=-60) | 5 | 09/15/2021 00:00:00 | 09/15/2021 00:00:00 |
| Warn_Overlap (PrevLPID=385; PrevEnd=2020-09-03 10:00; GapMinRaw=-60) | 5 | 09/03/2020 00:00:00 | 09/03/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4041; PrevEnd=2021-07-01 11:30; GapMinRaw=-30) | 5 | 07/01/2021 00:00:00 | 07/01/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4412; PrevEnd=2021-07-27 11:30; GapMinRaw=-90) | 5 | 07/27/2021 00:00:00 | 07/27/2021 00:00:00 |
| Warn_Overlap (PrevLPID=42503; PrevEnd=2024-06-04 11:30; GapMinRaw=-30) | 5 | 06/04/2024 00:00:00 | 06/04/2024 00:00:00 |
| Warn_Overlap (PrevLPID=10411; PrevEnd=2022-03-31 00:30; GapMinRaw=-420) | 5 | 03/30/2022 00:00:00 | 03/30/2022 00:00:00 |
| Warn_Overlap (PrevLPID=18104; PrevEnd=2022-11-09 13:00; GapMinRaw=-360) | 5 | 11/09/2022 00:00:00 | 11/09/2022 00:00:00 |
| Warn_Overlap (PrevLPID=2827; PrevEnd=2021-04-08 09:30; GapMinRaw=-30) | 5 | 04/08/2021 00:00:00 | 04/08/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4248; PrevEnd=2021-07-16 11:30; GapMinRaw=-30) | 5 | 07/16/2021 00:00:00 | 07/16/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4348; PrevEnd=2021-07-23 11:00; GapMinRaw=-60) | 5 | 07/23/2021 00:00:00 | 07/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5044; PrevEnd=2021-09-01 15:00; GapMinRaw=-150) | 5 | 09/01/2021 00:00:00 | 09/01/2021 00:00:00 |
| Warn_Overlap (PrevLPID=269; PrevEnd=2020-08-25 08:30; GapMinRaw=-60) | 5 | 08/25/2020 00:00:00 | 08/25/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4339; PrevEnd=2021-07-22 22:00; GapMinRaw=-810) | 5 | 07/22/2021 00:00:00 | 07/22/2021 00:00:00 |
| Warn_Overlap (PrevLPID=37469; PrevEnd=2024-01-26 15:30; GapMinRaw=-570) | 5 | 01/26/2024 00:00:00 | 01/26/2024 00:00:00 |
| Warn_Overlap (PrevLPID=38829; PrevEnd=2024-03-01 07:00; GapMinRaw=-30) | 5 | 03/01/2024 00:00:00 | 03/01/2024 00:00:00 |
| Warn_Overlap (PrevLPID=373; PrevEnd=2020-09-02 11:30; GapMinRaw=-60) | 5 | 09/02/2020 00:00:00 | 09/02/2020 00:00:00 |
| Warn_Overlap (PrevLPID=581; PrevEnd=2020-09-23 10:30; GapMinRaw=-90) | 5 | 09/23/2020 00:00:00 | 09/23/2020 00:00:00 |
| Warn_Overlap (PrevLPID=25626; PrevEnd=2023-05-09 10:00; GapMinRaw=-30) | 5 | 05/09/2023 00:00:00 | 05/09/2023 00:00:00 |
| Warn_Overlap (PrevLPID=4797; PrevEnd=2021-08-18 13:30; GapMinRaw=-150) | 5 | 08/18/2021 00:00:00 | 08/18/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4283; PrevEnd=2021-07-19 13:30; GapMinRaw=-180) | 5 | 07/19/2021 00:00:00 | 07/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5079; PrevEnd=2021-09-03 10:00; GapMinRaw=-30) | 5 | 09/03/2021 00:00:00 | 09/03/2021 00:00:00 |
| Warn_Overlap (PrevLPID=33127; PrevEnd=2023-10-18 11:30; GapMinRaw=-180) | 5 | 10/18/2023 00:00:00 | 10/18/2023 00:00:00 |
| Warn_Overlap (PrevLPID=41487; PrevEnd=2024-05-09 16:00; GapMinRaw=-600) | 5 | 05/09/2024 00:00:00 | 05/09/2024 00:00:00 |
| Warn_Overlap (PrevLPID=11662; PrevEnd=2022-05-17 08:30; GapMinRaw=-90) | 5 | 05/17/2022 00:00:00 | 05/17/2022 00:00:00 |
| Warn_Overlap (PrevLPID=49592; PrevEnd=2024-11-19 16:00; GapMinRaw=-480) | 5 | 11/19/2024 00:00:00 | 11/19/2024 00:00:00 |
| Warn_Overlap (PrevLPID=50705; PrevEnd=2024-12-10 11:00; GapMinRaw=-300) | 5 | 12/10/2024 00:00:00 | 12/10/2024 00:00:00 |
| Warn_Overlap (PrevLPID=529; PrevEnd=2020-09-18 13:30; GapMinRaw=-120) | 5 | 09/18/2020 00:00:00 | 09/18/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4627; PrevEnd=2021-08-10 11:30; GapMinRaw=-60) | 5 | 08/10/2021 00:00:00 | 08/10/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5036; PrevEnd=2021-09-01 10:30; GapMinRaw=-210) | 5 | 09/01/2021 00:00:00 | 09/01/2021 00:00:00 |
| Warn_Overlap (PrevLPID=29626; PrevEnd=2023-07-31 11:00; GapMinRaw=-60) | 5 | 07/31/2023 00:00:00 | 07/31/2023 00:00:00 |
| Warn_Overlap (PrevLPID=38073; PrevEnd=2024-02-14 17:00; GapMinRaw=-660) | 5 | 02/14/2024 00:00:00 | 02/14/2024 00:00:00 |
| Warn_Overlap (PrevLPID=5587; PrevEnd=2021-09-30 10:00; GapMinRaw=-30) | 5 | 09/30/2021 00:00:00 | 09/30/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5606; PrevEnd=2021-10-01 09:00; GapMinRaw=-60) | 5 | 10/01/2021 00:00:00 | 10/01/2021 00:00:00 |
| Warn_Overlap (PrevLPID=800; PrevEnd=2020-10-09 06:00; GapMinRaw=-30) | 5 | 10/09/2020 00:00:00 | 10/09/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3295; PrevEnd=2021-05-17 13:30; GapMinRaw=-30) | 5 | 05/17/2021 00:00:00 | 05/17/2021 00:00:00 |
| Warn_Overlap (PrevLPID=7706; PrevEnd=2022-01-19 13:30; GapMinRaw=-90) | 5 | 01/19/2022 00:00:00 | 01/19/2022 00:00:00 |
| Warn_Overlap (PrevLPID=313; PrevEnd=2020-08-28 07:00; GapMinRaw=-60) | 5 | 08/28/2020 00:00:00 | 08/28/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4986; PrevEnd=2021-08-30 09:30; GapMinRaw=-60) | 5 | 08/30/2021 00:00:00 | 08/30/2021 00:00:00 |
| Warn_Overlap (PrevLPID=14298; PrevEnd=2022-07-27 10:00; GapMinRaw=-120) | 5 | 07/27/2022 00:00:00 | 07/27/2022 00:00:00 |
| Warn_Overlap (PrevLPID=24; PrevEnd=2020-07-06 12:30; GapMinRaw=-180) | 5 | 07/06/2020 00:00:00 | 07/06/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1205; PrevEnd=2020-11-10 09:30; GapMinRaw=-30) | 5 | 11/10/2020 00:00:00 | 11/10/2020 00:00:00 |
| Warn_Overlap (PrevLPID=33157; PrevEnd=2023-10-17 11:00; GapMinRaw=-210) | 5 | 10/17/2023 00:00:00 | 10/17/2023 00:00:00 |
| Warn_Overlap (PrevLPID=40461; PrevEnd=2024-04-12 16:30; GapMinRaw=-720) | 5 | 04/12/2024 00:00:00 | 04/12/2024 00:00:00 |
| Warn_Overlap (PrevLPID=80830; PrevEnd=2026-03-19 16:30; GapMinRaw=-630) | 5 | 03/19/2026 00:00:00 | 03/19/2026 00:00:00 |
| Warn_Overlap (PrevLPID=14434; PrevEnd=2022-07-27 13:00; GapMinRaw=-150) | 5 | 07/27/2022 00:00:00 | 07/27/2022 00:00:00 |
| Warn_Overlap (PrevLPID=48682; PrevEnd=2024-10-24 18:30; GapMinRaw=-690) | 5 | 10/24/2024 00:00:00 | 10/24/2024 00:00:00 |
| Warn_Overlap (PrevLPID=2270; PrevEnd=2021-02-17 15:30; GapMinRaw=-30) | 5 | 02/17/2021 00:00:00 | 02/17/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4398; PrevEnd=2021-07-27 08:30; GapMinRaw=-60) | 5 | 07/27/2021 00:00:00 | 07/27/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5128; PrevEnd=2021-09-08 08:00; GapMinRaw=-60) | 5 | 09/08/2021 00:00:00 | 09/08/2021 00:00:00 |
| Warn_Overlap (PrevLPID=37537; PrevEnd=2024-01-23 19:30; GapMinRaw=-750) | 5 | 01/23/2024 00:00:00 | 01/23/2024 00:00:00 |
| Warn_Overlap (PrevLPID=383; PrevEnd=2020-09-04 14:30; GapMinRaw=-510) | 5 | 09/04/2020 00:00:00 | 09/04/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3663; PrevEnd=2021-06-10 12:30; GapMinRaw=-60) | 5 | 06/10/2021 00:00:00 | 06/10/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4350; PrevEnd=2021-07-23 10:00; GapMinRaw=-30) | 5 | 07/23/2021 00:00:00 | 07/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=46019; PrevEnd=2024-08-27 11:00; GapMinRaw=-300) | 5 | 08/27/2024 00:00:00 | 08/27/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1496; PrevEnd=2020-12-09 14:30; GapMinRaw=-510) | 5 | 12/09/2020 00:00:00 | 12/09/2020 00:00:00 |
| Warn_Overlap (PrevLPID=27266; PrevEnd=2023-06-08 17:00; GapMinRaw=-660) | 5 | 06/08/2023 00:00:00 | 06/08/2023 00:00:00 |
| Warn_Overlap (PrevLPID=34830; PrevEnd=2023-11-21 16:00; GapMinRaw=-570) | 5 | 11/21/2023 00:00:00 | 11/21/2023 00:00:00 |
| Warn_Overlap (PrevLPID=3797; PrevEnd=2021-06-18 12:30; GapMinRaw=-120) | 5 | 06/18/2021 00:00:00 | 06/18/2021 00:00:00 |
| Warn_Overlap (PrevLPID=25009; PrevEnd=2023-04-27 12:00; GapMinRaw=-360) | 5 | 04/27/2023 00:00:00 | 04/27/2023 00:00:00 |
| Warn_Overlap (PrevLPID=2879; PrevEnd=2021-04-13 12:00; GapMinRaw=-30) | 5 | 04/13/2021 00:00:00 | 04/13/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3056; PrevEnd=2021-04-26 12:00; GapMinRaw=-60) | 5 | 04/26/2021 00:00:00 | 04/26/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4759; PrevEnd=2021-08-17 13:00; GapMinRaw=-90) | 5 | 08/17/2021 00:00:00 | 08/17/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4960; PrevEnd=2021-08-27 23:30; GapMinRaw=-720) | 5 | 08/27/2021 00:00:00 | 08/27/2021 00:00:00 |
| Warn_Overlap (PrevLPID=26197; PrevEnd=2023-05-17 16:00; GapMinRaw=-330) | 5 | 05/17/2023 00:00:00 | 05/17/2023 00:00:00 |
| Warn_Overlap (PrevLPID=4761; PrevEnd=2021-08-18 08:30; GapMinRaw=-150) | 5 | 08/18/2021 00:00:00 | 08/18/2021 00:00:00 |
| Warn_Overlap (PrevLPID=35472; PrevEnd=2023-12-05 15:30; GapMinRaw=-450) | 5 | 12/05/2023 00:00:00 | 12/05/2023 00:00:00 |
| Warn_Overlap (PrevLPID=51314; PrevEnd=2024-12-23 12:30; GapMinRaw=-210) | 5 | 12/23/2024 00:00:00 | 12/23/2024 00:00:00 |
| Warn_Overlap (PrevLPID=2909; PrevEnd=2021-04-15 08:00; GapMinRaw=-60) | 5 | 04/15/2021 00:00:00 | 04/15/2021 00:00:00 |
| Warn_Overlap (PrevLPID=50932; PrevEnd=2024-12-17 15:30; GapMinRaw=-540) | 5 | 12/17/2024 00:00:00 | 12/17/2024 00:00:00 |
| Warn_Overlap (PrevLPID=472; PrevEnd=2020-09-14 10:00; GapMinRaw=-30) | 5 | 09/14/2020 00:00:00 | 09/14/2020 00:00:00 |
| Warn_Overlap (PrevLPID=692; PrevEnd=2020-10-01 11:00; GapMinRaw=-90) | 5 | 10/01/2020 00:00:00 | 10/01/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3517; PrevEnd=2021-06-01 08:30; GapMinRaw=-120) | 5 | 06/01/2021 00:00:00 | 06/01/2021 00:00:00 |
| Warn_Overlap (PrevLPID=1541; PrevEnd=2020-12-12 12:00; GapMinRaw=-390) | 5 | 12/12/2020 00:00:00 | 12/12/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4162; PrevEnd=2021-07-12 09:30; GapMinRaw=-30) | 5 | 07/12/2021 00:00:00 | 07/12/2021 00:00:00 |
| Warn_Overlap (PrevLPID=8445; PrevEnd=2022-02-08 10:30; GapMinRaw=-30) | 5 | 02/08/2022 00:00:00 | 02/08/2022 00:00:00 |
| Warn_Overlap (PrevLPID=38296; PrevEnd=2024-02-26 12:00; GapMinRaw=-510) | 5 | 02/26/2024 00:00:00 | 02/26/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1556; PrevEnd=2020-12-15 11:30; GapMinRaw=-30) | 5 | 12/15/2020 00:00:00 | 12/15/2020 00:00:00 |
| Warn_Overlap (PrevLPID=14025; PrevEnd=2022-07-20 11:30; GapMinRaw=-330) | 5 | 07/20/2022 00:00:00 | 07/20/2022 00:00:00 |
| Warn_Overlap (PrevLPID=527; PrevEnd=2020-09-18 08:30; GapMinRaw=-120) | 5 | 09/18/2020 00:00:00 | 09/18/2020 00:00:00 |
| Warn_Overlap (PrevLPID=786; PrevEnd=2020-10-08 10:00; GapMinRaw=-120) | 5 | 10/08/2020 00:00:00 | 10/08/2020 00:00:00 |
| Warn_Overlap (PrevLPID=30198; PrevEnd=2023-08-11 13:00; GapMinRaw=-390) | 5 | 08/11/2023 00:00:00 | 08/11/2023 00:00:00 |
| Warn_Overlap (PrevLPID=461; PrevEnd=2020-09-11 08:30; GapMinRaw=-30) | 5 | 09/11/2020 00:00:00 | 09/11/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1557; PrevEnd=2020-12-15 15:00; GapMinRaw=-60) | 5 | 12/15/2020 00:00:00 | 12/15/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3570; PrevEnd=2021-06-03 11:00; GapMinRaw=-60) | 5 | 06/03/2021 00:00:00 | 06/03/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3890; PrevEnd=2021-06-23 15:00; GapMinRaw=-90) | 5 | 06/23/2021 00:00:00 | 06/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=12431; PrevEnd=2022-06-08 14:00; GapMinRaw=-360) | 5 | 06/08/2022 00:00:00 | 06/08/2022 00:00:00 |
| Warn_Overlap (PrevLPID=41480; PrevEnd=2024-05-09 12:30; GapMinRaw=-330) | 5 | 05/09/2024 00:00:00 | 05/09/2024 00:00:00 |
| Warn_Overlap (PrevLPID=50740; PrevEnd=2024-12-12 09:00; GapMinRaw=-270) | 5 | 12/12/2024 00:00:00 | 12/12/2024 00:00:00 |
| Warn_Overlap (PrevLPID=51161; PrevEnd=2024-12-17 17:30; GapMinRaw=-660) | 5 | 12/17/2024 00:00:00 | 12/17/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1759; PrevEnd=2021-01-04 13:00; GapMinRaw=-30) | 5 | 01/04/2021 00:00:00 | 01/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5418; PrevEnd=2021-09-22 15:00; GapMinRaw=-90) | 5 | 09/22/2021 00:00:00 | 09/22/2021 00:00:00 |
| Warn_Overlap (PrevLPID=1142; PrevEnd=2020-11-04 09:30; GapMinRaw=-150) | 5 | 11/04/2020 00:00:00 | 11/04/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3238; PrevEnd=2021-05-12 12:30; GapMinRaw=-30) | 5 | 05/12/2021 00:00:00 | 05/12/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5123; PrevEnd=2021-09-07 13:30; GapMinRaw=-30) | 5 | 09/07/2021 00:00:00 | 09/07/2021 00:00:00 |
| Warn_Overlap (PrevLPID=7265; PrevEnd=2021-12-23 09:30; GapMinRaw=-30) | 5 | 12/23/2021 00:00:00 | 12/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=42123; PrevEnd=2024-05-22 07:00; GapMinRaw=-30) | 5 | 05/22/2024 00:00:00 | 05/22/2024 00:00:00 |
| Warn_Overlap (PrevLPID=43181; PrevEnd=2024-06-18 16:30; GapMinRaw=-600) | 5 | 06/18/2024 00:00:00 | 06/18/2024 00:00:00 |
| Warn_Overlap (PrevLPID=3320; PrevEnd=2021-05-18 14:30; GapMinRaw=-270) | 5 | 05/18/2021 00:00:00 | 05/18/2021 00:00:00 |
| Warn_Overlap (PrevLPID=136; PrevEnd=2020-07-30 16:00; GapMinRaw=-180) | 5 | 07/30/2020 00:00:00 | 07/30/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3639; PrevEnd=2021-06-09 11:00; GapMinRaw=-60) | 5 | 06/09/2021 00:00:00 | 06/09/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4739; PrevEnd=2021-08-17 09:00; GapMinRaw=-30) | 5 | 08/17/2021 00:00:00 | 08/17/2021 00:00:00 |
| Warn_Overlap (PrevLPID=13018; PrevEnd=2022-06-24 14:30; GapMinRaw=-480) | 5 | 06/24/2022 00:00:00 | 06/24/2022 00:00:00 |
| Warn_Overlap (PrevLPID=33074; PrevEnd=2023-10-12 14:00; GapMinRaw=-360) | 5 | 10/12/2023 00:00:00 | 10/12/2023 00:00:00 |
| Warn_Overlap (PrevLPID=50965; PrevEnd=2024-12-16 22:30; GapMinRaw=-210) | 5 | 12/16/2024 00:00:00 | 12/16/2024 00:00:00 |
| Warn_Overlap (PrevLPID=3729; PrevEnd=2021-06-15 11:30; GapMinRaw=-60) | 5 | 06/15/2021 00:00:00 | 06/15/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4238; PrevEnd=2021-07-16 09:30; GapMinRaw=-30) | 5 | 07/16/2021 00:00:00 | 07/16/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4693; PrevEnd=2021-08-13 15:00; GapMinRaw=-600) | 5 | 08/13/2021 00:00:00 | 08/13/2021 00:00:00 |
| Warn_Overlap (PrevLPID=10130; PrevEnd=2022-03-23 21:00; GapMinRaw=-660) | 5 | 03/23/2022 00:00:00 | 03/23/2022 00:00:00 |
| Warn_Overlap (PrevLPID=26874; PrevEnd=2023-06-01 14:30; GapMinRaw=-360) | 5 | 06/01/2023 00:00:00 | 06/01/2023 00:00:00 |
| Warn_Overlap (PrevLPID=227; PrevEnd=2020-08-19 11:30; GapMinRaw=-90) | 5 | 08/19/2020 00:00:00 | 08/19/2020 00:00:00 |
| Warn_Overlap (PrevLPID=48370; PrevEnd=2024-10-17 15:30; GapMinRaw=-540) | 5 | 10/17/2024 00:00:00 | 10/17/2024 00:00:00 |
| Warn_Overlap (PrevLPID=378; PrevEnd=2020-09-03 12:00; GapMinRaw=-120) | 5 | 09/03/2020 00:00:00 | 09/03/2020 00:00:00 |
| Warn_Overlap (PrevLPID=612; PrevEnd=2020-09-25 09:30; GapMinRaw=-30) | 5 | 09/25/2020 00:00:00 | 09/25/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2129; PrevEnd=2021-02-04 11:30; GapMinRaw=-60) | 5 | 02/04/2021 00:00:00 | 02/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4740; PrevEnd=2021-08-17 08:30; GapMinRaw=-30) | 5 | 08/17/2021 00:00:00 | 08/17/2021 00:00:00 |
| Warn_Overlap (PrevLPID=386; PrevEnd=2020-09-03 13:30; GapMinRaw=-30) | 5 | 09/03/2020 00:00:00 | 09/03/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3891; PrevEnd=2021-06-23 15:00; GapMinRaw=-90) | 5 | 06/23/2021 00:00:00 | 06/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=740; PrevEnd=2020-10-05 11:30; GapMinRaw=-30) | 5 | 10/05/2020 00:00:00 | 10/05/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4014; PrevEnd=2021-06-30 10:30; GapMinRaw=-30) | 5 | 06/30/2021 00:00:00 | 06/30/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4345; PrevEnd=2021-07-23 07:30; GapMinRaw=-30) | 5 | 07/23/2021 00:00:00 | 07/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=14023; PrevEnd=2022-07-19 18:30; GapMinRaw=-690) | 5 | 07/19/2022 00:00:00 | 07/19/2022 00:00:00 |
| Warn_Overlap (PrevLPID=858; PrevEnd=2020-10-14 10:00; GapMinRaw=-120) | 5 | 10/14/2020 00:00:00 | 10/14/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3184; PrevEnd=2021-05-07 11:30; GapMinRaw=-30) | 5 | 05/07/2021 00:00:00 | 05/07/2021 00:00:00 |
| Warn_Overlap (PrevLPID=50666; PrevEnd=2024-12-09 11:00; GapMinRaw=-90) | 5 | 12/09/2024 00:00:00 | 12/09/2024 00:00:00 |
| Warn_Overlap (PrevLPID=4113; PrevEnd=2021-07-08 12:00; GapMinRaw=-60) | 5 | 07/08/2021 00:00:00 | 07/08/2021 00:00:00 |
| Warn_Overlap (PrevLPID=50704; PrevEnd=2024-12-10 14:00; GapMinRaw=-180) | 5 | 12/10/2024 00:00:00 | 12/10/2024 00:00:00 |
| Warn_Overlap (PrevLPID=50795; PrevEnd=2024-12-12 15:30; GapMinRaw=-330) | 5 | 12/12/2024 00:00:00 | 12/12/2024 00:00:00 |
| Warn_Overlap (PrevLPID=662; PrevEnd=2020-09-29 12:30; GapMinRaw=-30) | 5 | 09/29/2020 00:00:00 | 09/29/2020 00:00:00 |
| Warn_Overlap (PrevLPID=767; PrevEnd=2020-10-07 08:30; GapMinRaw=-120) | 5 | 10/07/2020 00:00:00 | 10/07/2020 00:00:00 |
| Warn_Overlap (PrevLPID=855; PrevEnd=2020-10-14 09:00; GapMinRaw=-60) | 5 | 10/14/2020 00:00:00 | 10/14/2020 00:00:00 |
| Warn_Overlap (PrevLPID=925; PrevEnd=2020-10-20 10:30; GapMinRaw=-30) | 5 | 10/20/2020 00:00:00 | 10/20/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3345; PrevEnd=2021-05-19 13:00; GapMinRaw=-90) | 5 | 05/19/2021 00:00:00 | 05/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3581; PrevEnd=2021-06-04 11:00; GapMinRaw=-90) | 5 | 06/04/2021 00:00:00 | 06/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4280; PrevEnd=2021-07-19 14:30; GapMinRaw=-210) | 5 | 07/19/2021 00:00:00 | 07/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5184; PrevEnd=2021-09-10 13:00; GapMinRaw=-270) | 5 | 09/10/2021 00:00:00 | 09/10/2021 00:00:00 |
| Warn_Overlap (PrevLPID=7579; PrevEnd=2022-01-14 08:30; GapMinRaw=-60) | 5 | 01/14/2022 00:00:00 | 01/14/2022 00:00:00 |
| Warn_Overlap (PrevLPID=40978; PrevEnd=2024-04-26 10:30; GapMinRaw=-180) | 5 | 04/26/2024 00:00:00 | 04/26/2024 00:00:00 |
| Warn_Overlap (PrevLPID=4437; PrevEnd=2021-07-29 10:30; GapMinRaw=-60) | 5 | 07/29/2021 00:00:00 | 07/29/2021 00:00:00 |
| Warn_Overlap (PrevLPID=8446; PrevEnd=2022-02-08 10:30; GapMinRaw=-30) | 5 | 02/08/2022 00:00:00 | 02/08/2022 00:00:00 |
| Warn_Overlap (PrevLPID=140; PrevEnd=2020-07-31 11:30; GapMinRaw=-180) | 5 | 07/31/2020 00:00:00 | 07/31/2020 00:00:00 |
| Warn_Overlap (PrevLPID=708; PrevEnd=2020-10-02 06:30; GapMinRaw=-90) | 5 | 10/02/2020 00:00:00 | 10/02/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1946; PrevEnd=2021-01-19 14:00; GapMinRaw=-120) | 5 | 01/19/2021 00:00:00 | 01/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=12753; PrevEnd=2022-06-16 22:30; GapMinRaw=-60) | 5 | 06/16/2022 00:00:00 | 06/16/2022 00:00:00 |
| Warn_Overlap (PrevLPID=38635; PrevEnd=2024-02-27 21:00; GapMinRaw=-780) | 5 | 02/27/2024 00:00:00 | 02/27/2024 00:00:00 |
| Warn_Overlap (PrevLPID=403; PrevEnd=2020-09-08 13:00; GapMinRaw=-120) | 5 | 09/08/2020 00:00:00 | 09/08/2020 00:00:00 |
| Warn_Overlap (PrevLPID=38678; PrevEnd=2024-02-26 19:00; GapMinRaw=-840) | 5 | 02/26/2024 00:00:00 | 02/26/2024 00:00:00 |
| Warn_Overlap (PrevLPID=40754; PrevEnd=2024-04-17 18:30; GapMinRaw=-90) | 5 | 04/17/2024 00:00:00 | 04/17/2024 00:00:00 |
| Warn_Overlap (PrevLPID=45513; PrevEnd=2024-08-15 17:00; GapMinRaw=-540) | 5 | 08/15/2024 00:00:00 | 08/15/2024 00:00:00 |
| Warn_Overlap (PrevLPID=4807; PrevEnd=2021-08-20 08:00; GapMinRaw=-60) | 5 | 08/20/2021 00:00:00 | 08/20/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3031; PrevEnd=2021-04-23 13:00; GapMinRaw=-30) | 5 | 04/23/2021 00:00:00 | 04/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4444; PrevEnd=2021-07-29 13:30; GapMinRaw=-30) | 5 | 07/29/2021 00:00:00 | 07/29/2021 00:00:00 |
| Warn_Overlap (PrevLPID=43011; PrevEnd=2024-06-17 15:30; GapMinRaw=-480) | 5 | 06/17/2024 00:00:00 | 06/17/2024 00:00:00 |
| Warn_Overlap (PrevLPID=44431; PrevEnd=2024-07-24 15:00; GapMinRaw=-60) | 5 | 07/24/2024 00:00:00 | 07/24/2024 00:00:00 |
| Warn_Overlap (PrevLPID=45196; PrevEnd=2024-08-08 15:30; GapMinRaw=-330) | 5 | 08/08/2024 00:00:00 | 08/08/2024 00:00:00 |
| Warn_Overlap (PrevLPID=31048; PrevEnd=2023-08-30 19:30; GapMinRaw=-750) | 5 | 08/30/2023 00:00:00 | 08/30/2023 00:00:00 |
| Warn_Overlap (PrevLPID=1602; PrevEnd=2020-12-18 13:00; GapMinRaw=-60) | 5 | 12/18/2020 00:00:00 | 12/18/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3379; PrevEnd=2021-05-21 10:00; GapMinRaw=-90) | 5 | 05/21/2021 00:00:00 | 05/21/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3441; PrevEnd=2021-05-25 13:00; GapMinRaw=-30) | 5 | 05/25/2021 00:00:00 | 05/25/2021 00:00:00 |
| Warn_Overlap (PrevLPID=19556; PrevEnd=2021-07-30 16:00; GapMinRaw=-480) | 5 | 07/30/2021 00:00:00 | 07/30/2021 00:00:00 |
| Warn_Overlap (PrevLPID=1961; PrevEnd=2021-01-20 15:00; GapMinRaw=-60) | 5 | 01/20/2021 00:00:00 | 01/20/2021 00:00:00 |
| Warn_Overlap (PrevLPID=437; PrevEnd=2020-09-10 09:00; GapMinRaw=-90) | 5 | 09/10/2020 00:00:00 | 09/10/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1255; PrevEnd=2020-11-13 13:00; GapMinRaw=-30) | 5 | 11/13/2020 00:00:00 | 11/13/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3338; PrevEnd=2021-05-19 12:00; GapMinRaw=-30) | 5 | 05/19/2021 00:00:00 | 05/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=13364; PrevEnd=2022-06-29 09:00; GapMinRaw=-30) | 5 | 06/29/2022 00:00:00 | 06/29/2022 00:00:00 |
| Warn_Overlap (PrevLPID=3756; PrevEnd=2021-06-16 15:00; GapMinRaw=-60) | 5 | 06/16/2021 00:00:00 | 06/16/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5013; PrevEnd=2021-08-31 12:00; GapMinRaw=-60) | 5 | 08/31/2021 00:00:00 | 08/31/2021 00:00:00 |
| Warn_Overlap (PrevLPID=613; PrevEnd=2020-09-25 11:30; GapMinRaw=-90) | 5 | 09/25/2020 00:00:00 | 09/25/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1355; PrevEnd=2020-11-21 15:00; GapMinRaw=-600) | 5 | 11/21/2020 00:00:00 | 11/21/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4324; PrevEnd=2021-07-21 17:00; GapMinRaw=-480) | 5 | 07/21/2021 00:00:00 | 07/21/2021 00:00:00 |
| Warn_Overlap (PrevLPID=768; PrevEnd=2020-10-07 09:30; GapMinRaw=-30) | 5 | 10/07/2020 00:00:00 | 10/07/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1707; PrevEnd=2020-12-30 11:00; GapMinRaw=-30) | 5 | 12/30/2020 00:00:00 | 12/30/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3833; PrevEnd=2021-06-21 11:00; GapMinRaw=-60) | 5 | 06/21/2021 00:00:00 | 06/21/2021 00:00:00 |
| Warn_Overlap (PrevLPID=49721; PrevEnd=2024-11-21 19:30; GapMinRaw=-810) | 5 | 11/21/2024 00:00:00 | 11/21/2024 00:00:00 |
| Warn_Overlap (PrevLPID=3908; PrevEnd=2021-06-24 12:00; GapMinRaw=-60) | 5 | 06/24/2021 00:00:00 | 06/24/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5211; PrevEnd=2021-09-13 13:00; GapMinRaw=-180) | 5 | 09/13/2021 00:00:00 | 09/13/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5293; PrevEnd=2021-09-15 13:30; GapMinRaw=-30) | 5 | 09/15/2021 00:00:00 | 09/15/2021 00:00:00 |
| Warn_Overlap (PrevLPID=37080; PrevEnd=2024-01-22 23:30; GapMinRaw=-30) | 5 | 01/22/2024 00:00:00 | 01/22/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1097; PrevEnd=2020-11-02 11:30; GapMinRaw=-60) | 5 | 11/02/2020 00:00:00 | 11/02/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3853; PrevEnd=2021-06-22 11:00; GapMinRaw=-60) | 5 | 06/22/2021 00:00:00 | 06/22/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5144; PrevEnd=2021-09-08 15:30; GapMinRaw=-570) | 5 | 09/08/2021 00:00:00 | 09/08/2021 00:00:00 |
| Warn_Overlap (PrevLPID=41549; PrevEnd=2024-05-07 10:00; GapMinRaw=-150) | 5 | 05/07/2024 00:00:00 | 05/07/2024 00:00:00 |
| Warn_Overlap (PrevLPID=332; PrevEnd=2020-08-31 09:30; GapMinRaw=-90) | 5 | 08/31/2020 00:00:00 | 08/31/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3638; PrevEnd=2021-06-09 11:00; GapMinRaw=-60) | 5 | 06/09/2021 00:00:00 | 06/09/2021 00:00:00 |
| Warn_Overlap (PrevLPID=13494; PrevEnd=2022-07-06 08:00; GapMinRaw=-60) | 5 | 07/06/2022 00:00:00 | 07/06/2022 00:00:00 |
| Warn_Overlap (PrevLPID=39700; PrevEnd=2024-03-27 16:00; GapMinRaw=-330) | 5 | 03/27/2024 00:00:00 | 03/27/2024 00:00:00 |
| Warn_Overlap (PrevLPID=7486; PrevEnd=2022-01-11 12:30; GapMinRaw=-30) | 5 | 01/11/2022 00:00:00 | 01/11/2022 00:00:00 |
| Warn_Overlap (PrevLPID=2401; PrevEnd=2021-02-26 09:00; GapMinRaw=-90) | 5 | 02/26/2021 00:00:00 | 02/26/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2829; PrevEnd=2021-04-08 12:30; GapMinRaw=-60) | 5 | 04/08/2021 00:00:00 | 04/08/2021 00:00:00 |
| Warn_Overlap (PrevLPID=13538; PrevEnd=2022-07-08 10:30; GapMinRaw=-30) | 5 | 07/08/2022 00:00:00 | 07/08/2022 00:00:00 |
| Warn_Overlap (PrevLPID=19771; PrevEnd=2022-12-22 16:30; GapMinRaw=-660) | 5 | 12/22/2022 00:00:00 | 12/22/2022 00:00:00 |
| Warn_Overlap (PrevLPID=42910; PrevEnd=2024-06-11 19:30; GapMinRaw=-840) | 5 | 06/11/2024 00:00:00 | 06/11/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1233; PrevEnd=2020-11-12 14:00; GapMinRaw=-60) | 5 | 11/12/2020 00:00:00 | 11/12/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2591; PrevEnd=2021-03-17 15:00; GapMinRaw=-90) | 5 | 03/17/2021 00:00:00 | 03/17/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3907; PrevEnd=2021-06-24 11:00; GapMinRaw=-60) | 5 | 06/24/2021 00:00:00 | 06/24/2021 00:00:00 |
| Warn_Overlap (PrevLPID=37082; PrevEnd=2024-01-22 23:30; GapMinRaw=-30) | 5 | 01/22/2024 00:00:00 | 01/22/2024 00:00:00 |
| Warn_Overlap (PrevLPID=50568; PrevEnd=2024-12-06 15:00; GapMinRaw=-510) | 5 | 12/06/2024 00:00:00 | 12/06/2024 00:00:00 |
| Warn_Overlap (PrevLPID=28264; PrevEnd=2023-06-29 13:00; GapMinRaw=-450) | 5 | 06/29/2023 00:00:00 | 06/29/2023 00:00:00 |
| Warn_Overlap (PrevLPID=1569; PrevEnd=2020-12-16 10:00; GapMinRaw=-60) | 5 | 12/16/2020 00:00:00 | 12/16/2020 00:00:00 |
| Warn_Overlap (PrevLPID=39461; PrevEnd=2024-03-19 08:00; GapMinRaw=-60) | 5 | 03/19/2024 00:00:00 | 03/19/2024 00:00:00 |
| Warn_Overlap (PrevLPID=3339; PrevEnd=2021-05-19 13:30; GapMinRaw=-60) | 5 | 05/19/2021 00:00:00 | 05/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5405; PrevEnd=2021-09-22 13:30; GapMinRaw=-120) | 5 | 09/22/2021 00:00:00 | 09/22/2021 00:00:00 |
| Warn_Overlap (PrevLPID=6825; PrevEnd=2021-12-02 13:30; GapMinRaw=-510) | 5 | 12/02/2021 00:00:00 | 12/02/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2402; PrevEnd=2021-02-26 10:30; GapMinRaw=-90) | 5 | 02/26/2021 00:00:00 | 02/26/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3641; PrevEnd=2021-06-09 11:30; GapMinRaw=-30) | 5 | 06/09/2021 00:00:00 | 06/09/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4715; PrevEnd=2021-08-16 09:00; GapMinRaw=-60) | 5 | 08/16/2021 00:00:00 | 08/16/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4457; PrevEnd=2021-07-30 06:30; GapMinRaw=-90) | 5 | 07/30/2021 00:00:00 | 07/30/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2184; PrevEnd=2021-02-09 12:30; GapMinRaw=-90) | 5 | 02/09/2021 00:00:00 | 02/09/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3230; PrevEnd=2021-05-12 12:00; GapMinRaw=-90) | 5 | 05/12/2021 00:00:00 | 05/12/2021 00:00:00 |
| Warn_Overlap (PrevLPID=99; PrevEnd=2020-07-24 10:00; GapMinRaw=-60) | 5 | 07/24/2020 00:00:00 | 07/24/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3482; PrevEnd=2021-05-27 10:30; GapMinRaw=-60) | 5 | 05/27/2021 00:00:00 | 05/27/2021 00:00:00 |
| Warn_Overlap (PrevLPID=27920; PrevEnd=2023-06-21 19:00; GapMinRaw=-510) | 5 | 06/21/2023 00:00:00 | 06/21/2023 00:00:00 |
| Warn_Overlap (PrevLPID=194; PrevEnd=2020-08-11 14:30; GapMinRaw=-510) | 5 | 08/11/2020 00:00:00 | 08/11/2020 00:00:00 |
| Warn_Overlap (PrevLPID=299; PrevEnd=2020-08-27 10:00; GapMinRaw=-90) | 5 | 08/27/2020 00:00:00 | 08/27/2020 00:00:00 |
| Warn_Overlap (PrevLPID=405; PrevEnd=2020-09-08 14:30; GapMinRaw=-90) | 5 | 09/08/2020 00:00:00 | 09/08/2020 00:00:00 |
| Warn_Overlap (PrevLPID=30196; PrevEnd=2023-08-11 06:30; GapMinRaw=-180) | 5 | 08/11/2023 00:00:00 | 08/11/2023 00:00:00 |
| Warn_Overlap (PrevLPID=43182; PrevEnd=2024-06-18 19:30; GapMinRaw=-780) | 5 | 06/18/2024 00:00:00 | 06/18/2024 00:00:00 |
| Warn_Overlap (PrevLPID=50739; PrevEnd=2024-12-11 16:30; GapMinRaw=-630) | 5 | 12/11/2024 00:00:00 | 12/11/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1240; PrevEnd=2020-11-12 16:00; GapMinRaw=-90) | 5 | 11/12/2020 00:00:00 | 11/12/2020 00:00:00 |
| Warn_Overlap (PrevLPID=49547; PrevEnd=2024-11-20 16:30; GapMinRaw=-630) | 5 | 11/20/2024 00:00:00 | 11/20/2024 00:00:00 |
| Warn_Overlap (PrevLPID=3212; PrevEnd=2021-05-11 06:30; GapMinRaw=-30) | 5 | 05/11/2021 00:00:00 | 05/11/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3291; PrevEnd=2021-05-17 08:30; GapMinRaw=-30) | 5 | 05/17/2021 00:00:00 | 05/17/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5043; PrevEnd=2021-09-01 15:00; GapMinRaw=-150) | 5 | 09/01/2021 00:00:00 | 09/01/2021 00:00:00 |
| Warn_Overlap (PrevLPID=31956; PrevEnd=2023-09-18 06:00; GapMinRaw=-60) | 5 | 09/18/2023 00:00:00 | 09/18/2023 00:00:00 |
| Warn_Overlap (PrevLPID=39213; PrevEnd=2024-03-15 20:00; GapMinRaw=-720) | 5 | 03/15/2024 00:00:00 | 03/15/2024 00:00:00 |
| Warn_Overlap (PrevLPID=37475; PrevEnd=2024-01-26 22:30; GapMinRaw=-990) | 5 | 01/26/2024 00:00:00 | 01/26/2024 00:00:00 |
| Warn_Overlap (PrevLPID=51315; PrevEnd=2024-12-23 21:00; GapMinRaw=-960) | 5 | 12/23/2024 00:00:00 | 12/23/2024 00:00:00 |
| Warn_Overlap (PrevLPID=3564; PrevEnd=2021-06-03 09:00; GapMinRaw=-30) | 5 | 06/03/2021 00:00:00 | 06/03/2021 00:00:00 |
| Warn_Overlap (PrevLPID=14443; PrevEnd=2022-07-23 13:30; GapMinRaw=-330) | 5 | 07/23/2022 00:00:00 | 07/23/2022 00:00:00 |
| Warn_Overlap (PrevLPID=43184; PrevEnd=2024-06-18 12:00; GapMinRaw=-330) | 5 | 06/18/2024 00:00:00 | 06/18/2024 00:00:00 |
| Warn_Overlap (PrevLPID=49591; PrevEnd=2024-11-19 13:30; GapMinRaw=-450) | 5 | 11/19/2024 00:00:00 | 11/19/2024 00:00:00 |
| Warn_Overlap (PrevLPID=28135; PrevEnd=2023-06-27 13:30; GapMinRaw=-330) | 5 | 06/27/2023 00:00:00 | 06/27/2023 00:00:00 |
| Warn_Overlap (PrevLPID=41217; PrevEnd=2024-05-01 19:30; GapMinRaw=-30) | 5 | 05/01/2024 00:00:00 | 05/01/2024 00:00:00 |
| Warn_Overlap (PrevLPID=762; PrevEnd=2020-10-06 15:00; GapMinRaw=-120) | 5 | 10/06/2020 00:00:00 | 10/06/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2130; PrevEnd=2021-02-04 11:30; GapMinRaw=-60) | 5 | 02/04/2021 00:00:00 | 02/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2848; PrevEnd=2021-04-09 08:30; GapMinRaw=-90) | 5 | 04/09/2021 00:00:00 | 04/09/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5236; PrevEnd=2021-09-14 11:30; GapMinRaw=-270) | 5 | 09/14/2021 00:00:00 | 09/14/2021 00:00:00 |
| Warn_Overlap (PrevLPID=36846; PrevEnd=2024-01-09 19:30; GapMinRaw=-780) | 5 | 01/09/2024 00:00:00 | 01/09/2024 00:00:00 |
| Warn_Overlap (PrevLPID=660; PrevEnd=2020-09-29 06:30; GapMinRaw=-30) | 5 | 09/29/2020 00:00:00 | 09/29/2020 00:00:00 |
| Warn_Overlap (PrevLPID=5110; PrevEnd=2021-09-07 08:30; GapMinRaw=-120) | 5 | 09/07/2021 00:00:00 | 09/07/2021 00:00:00 |
| Warn_Overlap (PrevLPID=661; PrevEnd=2020-09-29 10:00; GapMinRaw=-120) | 5 | 09/29/2020 00:00:00 | 09/29/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3152; PrevEnd=2021-05-05 06:30; GapMinRaw=-90) | 5 | 05/05/2021 00:00:00 | 05/05/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4290; PrevEnd=2021-07-19 11:00; GapMinRaw=-30) | 5 | 07/19/2021 00:00:00 | 07/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=32413; PrevEnd=2023-10-02 14:00; GapMinRaw=-480) | 5 | 10/02/2023 00:00:00 | 10/02/2023 00:00:00 |
| Warn_Overlap (PrevLPID=3336; PrevEnd=2021-05-19 10:30; GapMinRaw=-30) | 5 | 05/19/2021 00:00:00 | 05/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4386; PrevEnd=2021-07-26 10:00; GapMinRaw=-60) | 5 | 07/26/2021 00:00:00 | 07/26/2021 00:00:00 |
| Warn_Overlap (PrevLPID=1507; PrevEnd=2020-12-10 09:00; GapMinRaw=-60) | 5 | 12/10/2020 00:00:00 | 12/10/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1741; PrevEnd=2021-01-04 09:00; GapMinRaw=-60) | 5 | 01/04/2021 00:00:00 | 01/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5707; PrevEnd=2021-10-07 08:30; GapMinRaw=-60) | 5 | 10/07/2021 00:00:00 | 10/07/2021 00:00:00 |
| Warn_Overlap (PrevLPID=40706; PrevEnd=2024-04-17 18:30; GapMinRaw=-690) | 5 | 04/17/2024 00:00:00 | 04/17/2024 00:00:00 |
| Warn_Overlap (PrevLPID=693; PrevEnd=2020-10-01 17:00; GapMinRaw=-660) | 5 | 10/01/2020 00:00:00 | 10/01/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4774; PrevEnd=2021-08-18 12:00; GapMinRaw=-120) | 5 | 08/18/2021 00:00:00 | 08/18/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5154; PrevEnd=2021-09-09 12:30; GapMinRaw=-510) | 5 | 09/09/2021 00:00:00 | 09/09/2021 00:00:00 |
| Warn_Overlap (PrevLPID=39637; PrevEnd=2024-03-27 15:30; GapMinRaw=-480) | 5 | 03/27/2024 00:00:00 | 03/27/2024 00:00:00 |
| Warn_Overlap (PrevLPID=2304; PrevEnd=2021-02-19 12:30; GapMinRaw=-30) | 5 | 02/19/2021 00:00:00 | 02/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2553; PrevEnd=2021-03-12 12:00; GapMinRaw=-30) | 5 | 03/12/2021 00:00:00 | 03/12/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3796; PrevEnd=2021-06-18 14:00; GapMinRaw=-60) | 5 | 06/18/2021 00:00:00 | 06/18/2021 00:00:00 |
| Warn_Overlap (PrevLPID=50913; PrevEnd=2024-12-16 17:30; GapMinRaw=-30) | 5 | 12/16/2024 00:00:00 | 12/16/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1004; PrevEnd=2020-10-26 11:00; GapMinRaw=-30) | 5 | 10/26/2020 00:00:00 | 10/26/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1724; PrevEnd=2020-12-30 22:30; GapMinRaw=-720) | 5 | 12/30/2020 00:00:00 | 12/30/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3335; PrevEnd=2021-05-19 10:30; GapMinRaw=-30) | 5 | 05/19/2021 00:00:00 | 05/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=820; PrevEnd=2020-10-12 06:00; GapMinRaw=-90) | 5 | 10/12/2020 00:00:00 | 10/12/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4479; PrevEnd=2021-07-04 16:30; GapMinRaw=-120) | 5 | 07/04/2021 00:00:00 | 07/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=14030; PrevEnd=2022-07-21 17:30; GapMinRaw=-630) | 5 | 07/21/2022 00:00:00 | 07/21/2022 00:00:00 |
| Warn_Overlap (PrevLPID=15714; PrevEnd=2022-09-06 12:30; GapMinRaw=-30) | 5 | 09/06/2022 00:00:00 | 09/06/2022 00:00:00 |
| Warn_Overlap (PrevLPID=973; PrevEnd=2020-10-23 10:00; GapMinRaw=-30) | 5 | 10/23/2020 00:00:00 | 10/23/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4210; PrevEnd=2021-07-14 14:00; GapMinRaw=-390) | 5 | 07/14/2021 00:00:00 | 07/14/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5204; PrevEnd=2021-09-13 08:30; GapMinRaw=-60) | 5 | 09/13/2021 00:00:00 | 09/13/2021 00:00:00 |
| Warn_Overlap (PrevLPID=8450; PrevEnd=2022-02-09 12:00; GapMinRaw=-30) | 5 | 02/09/2022 00:00:00 | 02/09/2022 00:00:00 |
| Warn_Overlap (PrevLPID=51313; PrevEnd=2024-12-23 18:30; GapMinRaw=-750) | 5 | 12/23/2024 00:00:00 | 12/23/2024 00:00:00 |
| Warn_Overlap (PrevLPID=4586; PrevEnd=2021-08-06 19:00; GapMinRaw=-480) | 5 | 08/06/2021 00:00:00 | 08/06/2021 00:00:00 |
| Warn_Overlap (PrevLPID=41344; PrevEnd=2024-05-07 16:30; GapMinRaw=-300) | 5 | 05/07/2024 00:00:00 | 05/07/2024 00:00:00 |
| Warn_Overlap (PrevLPID=38728; PrevEnd=2024-02-29 15:00; GapMinRaw=-480) | 5 | 02/29/2024 00:00:00 | 02/29/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1708; PrevEnd=2020-12-30 10:30; GapMinRaw=-30) | 5 | 12/30/2020 00:00:00 | 12/30/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2403; PrevEnd=2021-02-26 12:00; GapMinRaw=-30) | 5 | 02/26/2021 00:00:00 | 02/26/2021 00:00:00 |
| Warn_Overlap (PrevLPID=6867; PrevEnd=2021-12-06 12:00; GapMinRaw=-60) | 5 | 12/06/2021 00:00:00 | 12/06/2021 00:00:00 |
| Warn_Overlap (PrevLPID=42164; PrevEnd=2024-05-22 05:00; GapMinRaw=-720) | 5 | 05/21/2024 00:00:00 | 05/21/2024 00:00:00 |
| Warn_Overlap (PrevLPID=439; PrevEnd=2020-09-10 12:00; GapMinRaw=-120) | 5 | 09/10/2020 00:00:00 | 09/10/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1930; PrevEnd=2021-01-18 13:00; GapMinRaw=-120) | 5 | 01/18/2021 00:00:00 | 01/18/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3628; PrevEnd=2021-06-08 18:00; GapMinRaw=-600) | 5 | 06/08/2021 00:00:00 | 06/08/2021 00:00:00 |
| Warn_Overlap (PrevLPID=417; PrevEnd=2020-09-09 09:00; GapMinRaw=-90) | 5 | 09/09/2020 00:00:00 | 09/09/2020 00:00:00 |
| Warn_Overlap (PrevLPID=659; PrevEnd=2020-09-29 11:00; GapMinRaw=-90) | 5 | 09/29/2020 00:00:00 | 09/29/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3292; PrevEnd=2021-05-17 12:00; GapMinRaw=-120) | 5 | 05/17/2021 00:00:00 | 05/17/2021 00:00:00 |
| Warn_Overlap (PrevLPID=29856; PrevEnd=2023-08-03 11:00; GapMinRaw=-30) | 5 | 08/03/2023 00:00:00 | 08/03/2023 00:00:00 |
| Warn_Overlap (PrevLPID=31194; PrevEnd=2023-09-01 14:30; GapMinRaw=-150) | 5 | 09/01/2023 00:00:00 | 09/01/2023 00:00:00 |
| Warn_Overlap (PrevLPID=1568; PrevEnd=2020-12-16 10:30; GapMinRaw=-90) | 5 | 12/16/2020 00:00:00 | 12/16/2020 00:00:00 |
| Warn_Overlap (PrevLPID=38828; PrevEnd=2024-02-29 07:00; GapMinRaw=-60) | 5 | 02/29/2024 00:00:00 | 02/29/2024 00:00:00 |
| Warn_Overlap (PrevLPID=3211; PrevEnd=2021-05-11 06:30; GapMinRaw=-30) | 5 | 05/11/2021 00:00:00 | 05/11/2021 00:00:00 |
| Warn_Overlap (PrevLPID=39284; PrevEnd=2024-03-13 08:00; GapMinRaw=-120) | 5 | 03/13/2024 00:00:00 | 03/13/2024 00:00:00 |
| Warn_Overlap (PrevLPID=5237; PrevEnd=2021-09-14 12:30; GapMinRaw=-330) | 5 | 09/14/2021 00:00:00 | 09/14/2021 00:00:00 |
| Warn_Overlap (PrevLPID=34713; PrevEnd=2023-11-16 19:00; GapMinRaw=-720) | 5 | 11/16/2023 00:00:00 | 11/16/2023 00:00:00 |
| Warn_Overlap (PrevLPID=37987; PrevEnd=2024-02-13 11:00; GapMinRaw=-180) | 5 | 02/13/2024 00:00:00 | 02/13/2024 00:00:00 |
| Warn_Overlap (PrevLPID=39355; PrevEnd=2024-03-19 17:00; GapMinRaw=-570) | 5 | 03/19/2024 00:00:00 | 03/19/2024 00:00:00 |
| Warn_Overlap (PrevLPID=538; PrevEnd=2020-09-18 10:30; GapMinRaw=-30) | 5 | 09/18/2020 00:00:00 | 09/18/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1797; PrevEnd=2021-01-07 09:30; GapMinRaw=-30) | 5 | 01/07/2021 00:00:00 | 01/07/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3688; PrevEnd=2021-06-11 13:00; GapMinRaw=-120) | 5 | 06/11/2021 00:00:00 | 06/11/2021 00:00:00 |
| Warn_Overlap (PrevLPID=14694; PrevEnd=2022-08-08 14:00; GapMinRaw=-420) | 5 | 08/08/2022 00:00:00 | 08/08/2022 00:00:00 |
| Warn_Overlap (PrevLPID=246; PrevEnd=2020-08-21 09:30; GapMinRaw=-60) | 5 | 08/21/2020 00:00:00 | 08/21/2020 00:00:00 |
| Warn_Overlap (PrevLPID=38809; PrevEnd=2024-03-01 17:30; GapMinRaw=-630) | 5 | 03/01/2024 00:00:00 | 03/01/2024 00:00:00 |
| Warn_Overlap (PrevLPID=4340; PrevEnd=2021-07-22 11:30; GapMinRaw=-120) | 5 | 07/22/2021 00:00:00 | 07/22/2021 00:00:00 |
| Warn_Overlap (PrevLPID=31050; PrevEnd=2023-08-30 22:00; GapMinRaw=-930) | 5 | 08/30/2023 00:00:00 | 08/30/2023 00:00:00 |
| Warn_Overlap (PrevLPID=1639; PrevEnd=2020-12-22 10:30; GapMinRaw=-60) | 5 | 12/22/2020 00:00:00 | 12/22/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2103; PrevEnd=2021-02-02 15:30; GapMinRaw=-90) | 5 | 02/02/2021 00:00:00 | 02/02/2021 00:00:00 |
| Warn_Overlap (PrevLPID=40520; PrevEnd=2024-04-16 15:30; GapMinRaw=-510) | 5 | 04/16/2024 00:00:00 | 04/16/2024 00:00:00 |
| Warn_Overlap (PrevLPID=41334; PrevEnd=2024-05-07 11:30; GapMinRaw=-330) | 5 | 05/07/2024 00:00:00 | 05/07/2024 00:00:00 |
| Warn_Overlap (PrevLPID=457; PrevEnd=2020-09-11 11:00; GapMinRaw=-90) | 5 | 09/11/2020 00:00:00 | 09/11/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1201; PrevEnd=2020-11-09 14:00; GapMinRaw=-180) | 5 | 11/09/2020 00:00:00 | 11/09/2020 00:00:00 |
| Warn_Overlap (PrevLPID=39296; PrevEnd=2024-03-18 18:30; GapMinRaw=-690) | 5 | 03/18/2024 00:00:00 | 03/18/2024 00:00:00 |
| Warn_Overlap (PrevLPID=39425; PrevEnd=2024-03-19 19:00; GapMinRaw=-630) | 5 | 03/19/2024 00:00:00 | 03/19/2024 00:00:00 |
| Warn_Overlap (PrevLPID=2137; PrevEnd=2021-02-04 14:30; GapMinRaw=-120) | 5 | 02/04/2021 00:00:00 | 02/04/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2955; PrevEnd=2021-04-19 12:00; GapMinRaw=-120) | 5 | 04/19/2021 00:00:00 | 04/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3030; PrevEnd=2021-04-23 12:00; GapMinRaw=-120) | 5 | 04/23/2021 00:00:00 | 04/23/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5111; PrevEnd=2021-09-07 11:30; GapMinRaw=-120) | 5 | 09/07/2021 00:00:00 | 09/07/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2072; PrevEnd=2021-01-30 07:00; GapMinRaw=-60) | 5 | 01/30/2021 00:00:00 | 01/30/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4530; PrevEnd=2021-08-03 13:30; GapMinRaw=-30) | 5 | 08/03/2021 00:00:00 | 08/03/2021 00:00:00 |
| Warn_Overlap (PrevLPID=41455; PrevEnd=2024-05-10 18:30; GapMinRaw=-660) | 5 | 05/10/2024 00:00:00 | 05/10/2024 00:00:00 |
| Warn_Overlap (PrevLPID=2828; PrevEnd=2021-04-08 11:00; GapMinRaw=-60) | 5 | 04/08/2021 00:00:00 | 04/08/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4411; PrevEnd=2021-07-27 10:30; GapMinRaw=-120) | 5 | 07/27/2021 00:00:00 | 07/27/2021 00:00:00 |
| Warn_Overlap (PrevLPID=11768; PrevEnd=2022-05-17 12:00; GapMinRaw=-150) | 5 | 05/17/2022 00:00:00 | 05/17/2022 00:00:00 |
| Warn_Overlap (PrevLPID=30195; PrevEnd=2023-08-11 11:00; GapMinRaw=-330) | 5 | 08/11/2023 00:00:00 | 08/11/2023 00:00:00 |
| Warn_Overlap (PrevLPID=38824; PrevEnd=2024-03-01 21:00; GapMinRaw=-840) | 5 | 03/01/2024 00:00:00 | 03/01/2024 00:00:00 |
| Warn_Overlap (PrevLPID=40938; PrevEnd=2024-04-26 13:30; GapMinRaw=-330) | 5 | 04/26/2024 00:00:00 | 04/26/2024 00:00:00 |
| Warn_Overlap (PrevLPID=3400; PrevEnd=2021-05-22 10:30; GapMinRaw=-60) | 5 | 05/22/2021 00:00:00 | 05/22/2021 00:00:00 |
| Warn_Overlap (PrevLPID=6836; PrevEnd=2021-12-03 12:30; GapMinRaw=-30) | 5 | 12/03/2021 00:00:00 | 12/03/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2152; PrevEnd=2021-02-05 12:00; GapMinRaw=-90) | 5 | 02/05/2021 00:00:00 | 02/05/2021 00:00:00 |
| Warn_Overlap (PrevLPID=6812; PrevEnd=2021-12-02 08:30; GapMinRaw=-30) | 5 | 12/02/2021 00:00:00 | 12/02/2021 00:00:00 |
| Warn_Overlap (PrevLPID=10589; PrevEnd=2022-04-08 16:30; GapMinRaw=-690) | 5 | 04/08/2022 00:00:00 | 04/08/2022 00:00:00 |
| Warn_Overlap (PrevLPID=39182; PrevEnd=2024-03-12 14:00; GapMinRaw=-360) | 5 | 03/12/2024 00:00:00 | 03/12/2024 00:00:00 |
| Warn_Overlap (PrevLPID=96; PrevEnd=2020-07-24 09:30; GapMinRaw=-150) | 5 | 07/24/2020 00:00:00 | 07/24/2020 00:00:00 |
| Warn_Overlap (PrevLPID=40895; PrevEnd=2024-04-24 08:00; GapMinRaw=-60) | 5 | 04/24/2024 00:00:00 | 04/24/2024 00:00:00 |
| Warn_Overlap (PrevLPID=39557; PrevEnd=2024-03-24 20:00; GapMinRaw=-60) | 5 | 03/24/2024 00:00:00 | 03/24/2024 00:00:00 |
| Warn_Overlap (PrevLPID=43214; PrevEnd=2024-06-24 10:00; GapMinRaw=-120) | 5 | 06/24/2024 00:00:00 | 06/24/2024 00:00:00 |
| Warn_Overlap (PrevLPID=458; PrevEnd=2020-09-11 12:30; GapMinRaw=-120) | 5 | 09/11/2020 00:00:00 | 09/11/2020 00:00:00 |
| Warn_Overlap (PrevLPID=642; PrevEnd=2020-09-28 09:30; GapMinRaw=-60) | 5 | 09/28/2020 00:00:00 | 09/28/2020 00:00:00 |
| Warn_Overlap (PrevLPID=37546; PrevEnd=2024-01-25 08:00; GapMinRaw=-90) | 5 | 01/25/2024 00:00:00 | 01/25/2024 00:00:00 |
| Warn_Overlap (PrevLPID=103; PrevEnd=2020-07-24 13:30; GapMinRaw=-90) | 5 | 07/24/2020 00:00:00 | 07/24/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1110; PrevEnd=2020-11-03 10:00; GapMinRaw=-90) | 5 | 11/03/2020 00:00:00 | 11/03/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1628; PrevEnd=2020-12-21 13:00; GapMinRaw=-60) | 5 | 12/21/2020 00:00:00 | 12/21/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3341; PrevEnd=2021-05-19 12:30; GapMinRaw=-30) | 5 | 05/19/2021 00:00:00 | 05/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4201; PrevEnd=2021-07-13 11:30; GapMinRaw=-30) | 5 | 07/13/2021 00:00:00 | 07/13/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3509; PrevEnd=2021-05-28 23:00; GapMinRaw=-720) | 5 | 05/28/2021 00:00:00 | 05/28/2021 00:00:00 |
| Warn_Overlap (PrevLPID=50738; PrevEnd=2024-12-11 17:00; GapMinRaw=-60) | 5 | 12/11/2024 00:00:00 | 12/11/2024 00:00:00 |
| Warn_Overlap (PrevLPID=647; PrevEnd=2020-09-28 10:00; GapMinRaw=-30) | 5 | 09/28/2020 00:00:00 | 09/28/2020 00:00:00 |
| Warn_Overlap (PrevLPID=5122; PrevEnd=2021-09-07 13:30; GapMinRaw=-30) | 5 | 09/07/2021 00:00:00 | 09/07/2021 00:00:00 |
| Warn_Overlap (PrevLPID=25936; PrevEnd=2023-05-11 19:30; GapMinRaw=-810) | 5 | 05/11/2023 00:00:00 | 05/11/2023 00:00:00 |
| Warn_Overlap (PrevLPID=244; PrevEnd=2020-08-21 09:30; GapMinRaw=-90) | 5 | 08/21/2020 00:00:00 | 08/21/2020 00:00:00 |
| Warn_Overlap (PrevLPID=38323; PrevEnd=2024-02-26 17:00; GapMinRaw=-600) | 5 | 02/26/2024 00:00:00 | 02/26/2024 00:00:00 |
| Warn_Overlap (PrevLPID=4310; PrevEnd=2021-07-21 08:00; GapMinRaw=-60) | 5 | 07/21/2021 00:00:00 | 07/21/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2110; PrevEnd=2021-02-03 08:00; GapMinRaw=-30) | 5 | 02/03/2021 00:00:00 | 02/03/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4557; PrevEnd=2021-08-05 11:00; GapMinRaw=-30) | 5 | 08/05/2021 00:00:00 | 08/05/2021 00:00:00 |
| Warn_Overlap (PrevLPID=5968; PrevEnd=2021-10-19 15:00; GapMinRaw=-300) | 5 | 10/19/2021 00:00:00 | 10/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=6170; PrevEnd=2021-10-28 14:30; GapMinRaw=-120) | 5 | 10/28/2021 00:00:00 | 10/28/2021 00:00:00 |
| Warn_Overlap (PrevLPID=1211; PrevEnd=2020-11-10 12:30; GapMinRaw=-120) | 5 | 11/10/2020 00:00:00 | 11/10/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1617; PrevEnd=2020-12-21 07:00; GapMinRaw=-30) | 5 | 12/21/2020 00:00:00 | 12/21/2020 00:00:00 |
| Warn_Overlap (PrevLPID=50169; PrevEnd=2024-11-26 11:30; GapMinRaw=-270) | 5 | 11/26/2024 00:00:00 | 11/26/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1779; PrevEnd=2021-01-06 10:00; GapMinRaw=-60) | 5 | 01/06/2021 00:00:00 | 01/06/2021 00:00:00 |
| Warn_Overlap (PrevLPID=2965; PrevEnd=2021-04-19 14:00; GapMinRaw=-60) | 5 | 04/19/2021 00:00:00 | 04/19/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3795; PrevEnd=2021-06-18 11:30; GapMinRaw=-90) | 5 | 06/18/2021 00:00:00 | 06/18/2021 00:00:00 |
| Warn_Overlap (PrevLPID=42656; PrevEnd=2024-06-06 15:30; GapMinRaw=-570) | 5 | 06/06/2024 00:00:00 | 06/06/2024 00:00:00 |
| Warn_Overlap (PrevLPID=3568; PrevEnd=2021-06-03 10:30; GapMinRaw=-30) | 5 | 06/03/2021 00:00:00 | 06/03/2021 00:00:00 |
| Warn_Overlap (PrevLPID=3960; PrevEnd=2021-06-28 07:30; GapMinRaw=-210) | 5 | 06/28/2021 00:00:00 | 06/28/2021 00:00:00 |
| Warn_Overlap (PrevLPID=4723; PrevEnd=2021-08-16 11:00; GapMinRaw=-60) | 5 | 08/16/2021 00:00:00 | 08/16/2021 00:00:00 |
| Warn_Overlap (PrevLPID=40273; PrevEnd=2024-04-09 19:00; GapMinRaw=-750) | 5 | 04/09/2024 00:00:00 | 04/09/2024 00:00:00 |
| Warn_Overlap (PrevLPID=4563; PrevEnd=2021-08-05 10:30; GapMinRaw=-90) | 5 | 08/05/2021 00:00:00 | 08/05/2021 00:00:00 |
| Warn_Overlap (PrevLPID=13876; PrevEnd=2022-07-20 11:00; GapMinRaw=-30) | 5 | 07/20/2022 00:00:00 | 07/20/2022 00:00:00 |
| Warn_Overlap (PrevLPID=104; PrevEnd=2020-07-24 16:00; GapMinRaw=-600) | 5 | 07/24/2020 00:00:00 | 07/24/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2345; PrevEnd=2020-10-12 07:30; GapMinRaw=-90) | 5 | 10/12/2020 00:00:00 | 10/12/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2742; PrevEnd=2021-03-31 11:30; GapMinRaw=-60) | 5 | 03/31/2021 00:00:00 | 03/31/2021 00:00:00 |
| Warn_Overlap (PrevLPID=26876; PrevEnd=2023-06-01 14:30; GapMinRaw=-360) | 5 | 06/01/2023 00:00:00 | 06/01/2023 00:00:00 |
| Warn_Overlap (PrevLPID=40540; PrevEnd=2024-04-16 15:30; GapMinRaw=-450) | 5 | 04/16/2024 00:00:00 | 04/16/2024 00:00:00 |
| Warn_Overlap (PrevLPID=41121; PrevEnd=2024-04-24 21:30; GapMinRaw=-150) | 5 | 04/24/2024 00:00:00 | 04/24/2024 00:00:00 |
| Warn_Overlap (PrevLPID=500; PrevEnd=2020-09-16 09:00; GapMinRaw=-60) | 5 | 09/16/2020 00:00:00 | 09/16/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4909; PrevEnd=2021-08-25 08:00; GapMinRaw=-30) | 5 | 08/25/2021 00:00:00 | 08/25/2021 00:00:00 |
| Warn_Overlap (PrevLPID=23781; PrevEnd=2023-03-30 12:30; GapMinRaw=-30) | 5 | 03/30/2023 00:00:00 | 03/30/2023 00:00:00 |
| Warn_Overlap (PrevLPID=3436; PrevEnd=2021-05-25 13:00; GapMinRaw=-90) | 5 | 05/25/2021 00:00:00 | 05/25/2021 00:00:00 |
| Warn_Overlap (PrevLPID=30251; PrevEnd=2023-08-14 17:30; GapMinRaw=-690) | 5 | 08/14/2023 00:00:00 | 08/14/2023 00:00:00 |
| Warn_Overlap (PrevLPID=1210; PrevEnd=2020-11-10 12:30; GapMinRaw=-120) | 5 | 11/10/2020 00:00:00 | 11/10/2020 00:00:00 |
| Warn_Overlap (PrevLPID=100; PrevEnd=2020-07-24 12:00; GapMinRaw=-60) | 5 | 07/24/2020 00:00:00 | 07/24/2020 00:00:00 |
| Warn_Overlap (PrevLPID=85048; PrevEnd=2026-05-15 19:00; GapMinRaw=-720) | 5 | 05/15/2026 00:00:00 | 05/15/2026 00:00:00 |
| Warn_Overlap (PrevLPID=4565; PrevEnd=2021-08-05 15:00; GapMinRaw=-180) | 5 | 08/05/2021 00:00:00 | 08/05/2021 00:00:00 |
| Warn_Overlap (PrevLPID=40509; PrevEnd=2024-04-13 08:00; GapMinRaw=-120) | 5 | 04/13/2024 00:00:00 | 04/13/2024 00:00:00 |
| Warn_Overlap (PrevLPID=4134; PrevEnd=2021-07-09 11:00; GapMinRaw=-90) | 5 | 07/09/2021 00:00:00 | 07/09/2021 00:00:00 |
| Warn_Overlap (PrevLPID=41333; PrevEnd=2024-05-07 12:00; GapMinRaw=-510) | 5 | 05/07/2024 00:00:00 | 05/07/2024 00:00:00 |
| Warn_Overlap (PrevLPID=5061; PrevEnd=2021-09-02 14:00; GapMinRaw=-420) | 5 | 09/02/2021 00:00:00 | 09/02/2021 00:00:00 |
| Warn_Overlap (PrevLPID=14437; PrevEnd=2022-07-28 13:30; GapMinRaw=-450) | 5 | 07/28/2022 00:00:00 | 07/28/2022 00:00:00 |
| Warn_Overlap (PrevLPID=28298; PrevEnd=2023-06-29 20:30; GapMinRaw=-750) | 5 | 06/29/2023 00:00:00 | 06/29/2023 00:00:00 |
| Warn_Overlap (PrevLPID=14438; PrevEnd=2022-07-26 11:30; GapMinRaw=-390) | 5 | 07/26/2022 00:00:00 | 07/26/2022 00:00:00 |
| Warn_Overlap (PrevLPID=1690; PrevEnd=2020-12-29 10:00; GapMinRaw=-90) | 5 | 12/29/2020 00:00:00 | 12/29/2020 00:00:00 |
| Warn_Overlap (PrevLPID=3660; PrevEnd=2021-06-10 14:00; GapMinRaw=-30) | 5 | 06/10/2021 00:00:00 | 06/10/2021 00:00:00 |
| Warn_Overlap (PrevLPID=14022; PrevEnd=2022-07-20 12:30; GapMinRaw=-450) | 5 | 07/20/2022 00:00:00 | 07/20/2022 00:00:00 |
| Warn_Overlap (PrevLPID=284; PrevEnd=2020-08-26 06:30; GapMinRaw=-30) | 5 | 08/26/2020 00:00:00 | 08/26/2020 00:00:00 |
| Warn_Overlap (PrevLPID=4234; PrevEnd=2021-07-15 12:30; GapMinRaw=-30) | 5 | 07/15/2021 00:00:00 | 07/15/2021 00:00:00 |
| Warn_Overlap (PrevLPID=45339; PrevEnd=2024-08-13 18:00; GapMinRaw=-600) | 5 | 08/13/2024 00:00:00 | 08/13/2024 00:00:00 |
| Warn_Overlap (PrevLPID=1218; PrevEnd=2020-11-09 14:00; GapMinRaw=-180) | 5 | 11/09/2020 00:00:00 | 11/09/2020 00:00:00 |
| Warn_Overlap (PrevLPID=1627; PrevEnd=2020-12-21 10:00; GapMinRaw=-60) | 5 | 12/21/2020 00:00:00 | 12/21/2020 00:00:00 |
| Warn_Overlap (PrevLPID=2380; PrevEnd=2021-02-25 10:30; GapMinRaw=-30) | 5 | 02/25/2021 00:00:00 | 02/25/2021 00:00:00 |
| Warn_Overlap (PrevLPID=83383; PrevEnd=2026-04-24 09:30; GapMinRaw=-90) | 4 | 04/24/2026 00:00:00 | 04/24/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80165; PrevEnd=2026-03-12 19:30; GapMinRaw=-810) | 4 | 03/12/2026 00:00:00 | 03/12/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83402; PrevEnd=2026-04-24 11:30; GapMinRaw=-90) | 4 | 04/24/2026 00:00:00 | 04/24/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-06-19 06:30; End=2026-06-19 07:00) | 4 | 06/19/2026 00:00:00 | 06/19/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83403; PrevEnd=2026-04-24 11:30; GapMinRaw=-90) | 4 | 04/24/2026 00:00:00 | 04/24/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79534; PrevEnd=2026-03-04 17:30; GapMinRaw=-600) | 3 | 03/04/2026 00:00:00 | 03/04/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79376; PrevEnd=2026-03-03 11:30; GapMinRaw=-150) | 3 | 03/03/2026 00:00:00 | 03/03/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79269; PrevEnd=2026-03-03 13:00; GapMinRaw=-60) | 3 | 03/03/2026 00:00:00 | 03/03/2026 00:00:00 |
| Warn_Overlap (PrevLPID=86981; PrevEnd=2026-06-15 19:30; GapMinRaw=-90) | 3 | 06/15/2026 00:00:00 | 06/15/2026 00:00:00 |
| Warn_Overlap (PrevLPID=82219; PrevEnd=2026-04-08 21:30; GapMinRaw=-1020) | 3 | 04/08/2026 00:00:00 | 04/08/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83028; PrevEnd=2026-04-17 17:00; GapMinRaw=-570) | 3 | 04/17/2026 00:00:00 | 04/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=86980; PrevEnd=2026-06-15 19:30; GapMinRaw=-90) | 3 | 06/15/2026 00:00:00 | 06/15/2026 00:00:00 |
| RestPeriod_RateMissing (Forced but RateUsed_Est<=0) | 3 | 02/24/2021 00:00:00 | 06/16/2021 00:00:00 |
| Warn_Overlap (PrevLPID=81602; PrevEnd=2026-03-31 20:00; GapMinRaw=-780) | 3 | 03/31/2026 00:00:00 | 03/31/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79377; PrevEnd=2026-03-03 18:30; GapMinRaw=-300) | 3 | 03/03/2026 00:00:00 | 03/03/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79609; PrevEnd=2026-03-06 07:30; GapMinRaw=-90) | 3 | 03/06/2026 00:00:00 | 03/06/2026 00:00:00 |
| Warn_Overlap (PrevLPID=84295; PrevEnd=2026-05-07 10:00; GapMinRaw=-240) | 2 | 05/07/2026 00:00:00 | 05/07/2026 00:00:00 |
| Warn_Overlap (PrevLPID=76465; PrevEnd=2026-01-20 13:00; GapMinRaw=-600) | 2 | 01/20/2026 00:00:00 | 01/20/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83702; PrevEnd=2026-04-28 16:30; GapMinRaw=-60) | 2 | 04/28/2026 00:00:00 | 04/28/2026 00:00:00 |
| WTL error: WTL token exceeds computed maximum meal periods. | 2 | 06/18/2026 00:00:00 | 06/19/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-06-22 05:30; End=2026-06-22 19:30) | 2 | 06/22/2026 00:00:00 | 06/22/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79695; PrevEnd=2026-03-05 05:00; GapMinRaw=-90) | 2 | 03/05/2026 00:00:00 | 03/05/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83765; PrevEnd=2026-04-28 15:30; GapMinRaw=-510) | 2 | 04/28/2026 00:00:00 | 04/28/2026 00:00:00 |
| Warn_DuplicateWindow (Cnt=2; Start=2026-04-29 06:00; End=2026-04-29 12:00) | 2 | 04/29/2026 00:00:00 | 04/29/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83701; PrevEnd=2026-04-28 16:30; GapMinRaw=-60) | 2 | 04/28/2026 00:00:00 | 04/28/2026 00:00:00 |
| Shift_End NULL | 2 | 01/10/2023 00:00:00 | 01/10/2023 00:00:00 |
| Warn_Overlap (PrevLPID=83483; PrevEnd=2026-04-24 18:00; GapMinRaw=-120) | 2 | 04/24/2026 00:00:00 | 04/24/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83700; PrevEnd=2026-04-28 16:30; GapMinRaw=-60) | 2 | 04/28/2026 00:00:00 | 04/28/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83764; PrevEnd=2026-04-28 15:30; GapMinRaw=-510) | 2 | 04/28/2026 00:00:00 | 04/28/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80608; PrevEnd=2026-03-17 15:00; GapMinRaw=-510) | 1 | 03/17/2026 00:00:00 | 03/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80002; PrevEnd=2026-03-11 14:30; GapMinRaw=-210) | 1 | 03/11/2026 00:00:00 | 03/11/2026 00:00:00 |
| Warn_Overlap (PrevLPID=86664; PrevEnd=2026-06-10 13:30; GapMinRaw=-420) | 1 | 06/10/2026 00:00:00 | 06/10/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80714; PrevEnd=2026-03-18 07:00; GapMinRaw=-30) | 1 | 03/18/2026 00:00:00 | 03/18/2026 00:00:00 |
| Warn_Overlap (PrevLPID=87069; PrevEnd=2026-06-17 14:30; GapMinRaw=-600) | 1 | 06/17/2026 00:00:00 | 06/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83026; PrevEnd=2026-04-17 17:00; GapMinRaw=-570) | 1 | 04/17/2026 00:00:00 | 04/17/2026 00:00:00 |
| Warn_Overlap (PrevLPID=87382; PrevEnd=2026-06-19 20:30; GapMinRaw=-900) | 1 | 06/19/2026 00:00:00 | 06/19/2026 00:00:00 |
| Warn_Overlap (PrevLPID=86615; PrevEnd=2026-06-08 16:30; GapMinRaw=-120) | 1 | 06/08/2026 00:00:00 | 06/08/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83497; PrevEnd=2026-04-26 06:00; GapMinRaw=-30) | 1 | 04/26/2026 00:00:00 | 04/26/2026 00:00:00 |
| Warn_Overlap (PrevLPID=87194; PrevEnd=2026-06-18 08:00; GapMinRaw=-60) | 1 | 06/18/2026 00:00:00 | 06/18/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80145; PrevEnd=2026-03-12 16:00; GapMinRaw=-600) | 1 | 03/12/2026 00:00:00 | 03/12/2026 00:00:00 |
| Warn_Overlap (PrevLPID=86613; PrevEnd=2026-06-08 11:30; GapMinRaw=-180) | 1 | 06/08/2026 00:00:00 | 06/08/2026 00:00:00 |
| Warn_Overlap (PrevLPID=86561; PrevEnd=2026-06-08 14:30; GapMinRaw=-150) | 1 | 06/08/2026 00:00:00 | 06/08/2026 00:00:00 |
| Warn_Overlap (PrevLPID=83496; PrevEnd=2026-04-26 06:00; GapMinRaw=-30) | 1 | 04/26/2026 00:00:00 | 04/26/2026 00:00:00 |
| Warn_Overlap (PrevLPID=87381; PrevEnd=2026-06-19 20:30; GapMinRaw=-900) | 1 | 06/19/2026 00:00:00 | 06/19/2026 00:00:00 |
| Warn_Overlap (PrevLPID=79976; PrevEnd=2026-03-11 10:00; GapMinRaw=-60) | 1 | 03/11/2026 00:00:00 | 03/11/2026 00:00:00 |
| Warn_Overlap (PrevLPID=86559; PrevEnd=2026-06-08 08:30; GapMinRaw=-60) | 1 | 06/08/2026 00:00:00 | 06/08/2026 00:00:00 |
| Warn_Overlap (PrevLPID=80160; PrevEnd=2026-03-11 23:00; GapMinRaw=-510) | 1 | 03/11/2026 00:00:00 | 03/11/2026 00:00:00 |


## fms.Payroll_Calculated - distinct Rest_Policy

| Rest_Policy | rows_ |
|---|---|
| PunitiveUntil8Off | 54906 |
| *(null)* | 31535 |


## fms.Payroll_Calculated - distinct Audit_Min_Rule

| Audit_Min_Rule | rows_ |
|---|---|
| 0.0 | 81752 |
| 4.0 | 4645 |
| 8.0 | 41 |
| 2.5 | 2 |
| 1.0 | 1 |


## fms.Payroll_Calculated - distinct Audit_Gap_Mult

| Audit_Gap_Mult | rows_ |
|---|---|
| 1.00 | 81515 |
| 0.00 | 3738 |
| 1.50 | 1026 |
| 2.00 | 154 |
| 3.00 | 8 |


## fms.Payroll_GuaranteeGroup - distinct RuleCode/ScopeBasis/GroupScope/PayComponent

| RuleCode | ScopeBasis | GroupScope | PayComponent | MultiplierUsed | rows_ | triggered | satisfied |
|---|---|---|---|---|---|---|---|
| DAILY_MIN_4 | ShiftAnchorDate | EmployeeShift | BaseShift | 1.00 | 608 | 608 | 0 |
| HOLIDAY_MIN_8 | CalendarDate | EmployeeCalendarDate | Holiday | 3.00 | 8 | 8 | 0 |
| LONG_BOOM_MIN_4 | ShiftAnchorDate | EmployeeShiftBoom | BoomOnly | 1.50 | 1026 | 1026 | 0 |
| LONG_BOOM_MIN_4 | ShiftAnchorDate | EmployeeShiftBoom | BoomOnly | 2.00 | 128 | 128 | 0 |
| LONG_BOOM_MIN_4 | ShiftAnchorDate | EmployeeShiftBoom | BoomOnly | 1.00 | 2955 | 2955 | 0 |
| SPECIAL_SAT_MIN_8 | CalendarDate | EmployeeCalendarDate | SpecialSaturday | 2.00 | 33 | 33 | 0 |


## fms.Payroll_GuaranteeAllocation - distinct AllocationMethod

| AllocationMethod | rows_ | gaphrs | gappay |
|---|---|---|---|
| LastEligibleBoomEntryInShift | 4109 | 6710.50 | 16919.83 |
| LastLaborEntryInShift | 608 | 1024.00 | 50463.96 |
| LastSpecialSatSliceEntry | 33 | 102.00 | 12872.72 |
| LastHolidaySliceEntry | 8 | 20.50 | 4047.50 |


## calc.TicketTimeline - distinct Shift_Source_Start / Shift_Source_End

| Shift_Source_Start | Shift_Source_End | rows_ |
|---|---|---|
| TkTm01 | TkTm10 | 28777 |
| TkTm01 | TkTm09 | 9 |
| TkTm02 | TkTm10 | 8 |
| TkTm01 | *(null)* | 5 |


## calc.TicketTimeline - distinct Boom_Source_Start / Boom_Source_End

| Boom_Source_Start | Boom_Source_End | rows_ |
|---|---|---|
| TkTm03 | TkTm08 | 28799 |


## api.v_UI_Employee_PayrollGroupRate - distinct PayrollGroup/PayType/BaseHourlyRateSource

| PayrollGroup | PayType | BaseHourlyRateSource | rows_ |
|---|---|---|---|
| L12 Labor Union Field | H | Employee.CraftCode -> UNION_CRAFT.PayRate | 145 |
| Non-Union Admin Salary | S | Employee.PayRate | 33 |
| Non-Union Admin Hourly | H | Employee.PayRate | 20 |
| Unknown / Needs Review | H | Unknown / Needs Review | 17 |
| L12 Labor Union Mechanic | H | Employee.CraftCode -> UNION_CRAFT.PayRate | 10 |
| System-Testing-VendorAccess | H | System access / non-payroll | 9 |
| Unknown / Needs Review | S | Unknown / Needs Review | 5 |
| System-Testing-VendorAccess | H | System/default placeholder / non-payroll | 1 |
| L12 Labor Union Mechanic | S | Employee.CraftCode -> UNION_CRAFT.PayRate | 1 |
| L12 Labor Union Field | S | Employee.CraftCode -> UNION_CRAFT.PayRate | 1 |



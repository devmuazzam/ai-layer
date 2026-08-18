---
title: Legacy Payroll App - every configuration and dimension row (cfg.*, dim.LU12_Holiday) as of 2026-08-18
source: user-supplied/PAYROLL_CALC_EXTRACT.zip (generated 2026-08-18 on the client machine from TCG_PayrollAPP + c:/projects/tcg-payroll-api)
migrated: 2026-08-18
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
topics: [payroll, legacy-payroll-app, config, payroll-rule]
entities: [union-master-rules, shift-rules, guaranteed-hours, rest-period, wtl, holiday-calendar]
part_of: payroll/legacy-payroll-app-db-extract/INDEX.md
---

> Part of the 2026-08-18 read-only extract of the live legacy database `TCG_PayrollAPP`
> (`localhost\SQLEXPRESS`, SQL Server 2025 Express). Line anchors like `sql\app\x.PROC.sql:12-20`
> refer to the verbatim definitions in [sql/](sql/) (backslashes → forward slashes). Employee
> identifiers are masked `E***NN`. Nothing that writes was executed to produce this.

# cfg.Craft_MinimumPayPolicy  (39 rows)

| CraftCode | ApplyMinimumPay | Notes | UpdatedAtUTC | UpdatedBy |
|---|---|---|---|---|
| ADMIN-A | False | Admin staff: minimum pay does not apply (per Payroll Manager) | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| ADMIN-B | False | Admin staff: minimum pay does not apply (per Payroll Manager) | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| ADMIN-C | False | Admin staff: minimum pay does not apply (per Payroll Manager) | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| HDR-A | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| HDR-B | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| HDR-C | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| HOLIDAY | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-APP-A | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-APP-B | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-APP-C | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-BG-A | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-BG-B | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-BG-C | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G1-A | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G1-B | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G1-C | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G2-A | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G2-B | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G2-C | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G3-A | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G3-B | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G3-C | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G4-A | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G4-B | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G4-C | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G5-A | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G5-B | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G5-C | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G6-A | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G6-B | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G6-C | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G7-A | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G7-B | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G7-C | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G8-A | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G8-B | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| L12-G8-C | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| YARD-A | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |
| YARD-B | True | Default: apply minimum pay | 03/03/2026 22:41:14 | AzureAD\BrianPetros |

---

# cfg.CrossMidnightDayTypePolicy  (2 rows)

| PolicyCode | PolicyName | IsActive | Notes |
|---|---|---|---|
| AnchorFloor | Per increment, apply max(AnchorDayTypeRate, CalendarDayTypeRate) unless higher rule applies. | False | Use if Payroll Manager wants shift-start day type to floor the whole entry. |
| CalendarDay | Rate each 30-min increment by its calendar day type; OT accumulation still anchored to Day 1. | True | Default until Payroll Manager confirms otherwise. |

---

# cfg.GuaranteedHoursRule  (4 rows)

| GuaranteedHoursRuleID | RuleCode | RuleName | ScopeBasis | GroupScope | MinimumHours | PayComponent | DefaultMultiplier | BoomNoModifierTreatment | IsEnabled | CreatedAtUTC | UpdatedAtUTC |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | DAILY_MIN_4 | Daily 4-hour minimum | ShiftAnchorDate | EmployeeShift | 4.00 | BaseShift | 1.00 |  | True | 05/05/2026 07:22:58 |  |
| 2 | HOLIDAY_MIN_8 | Holiday 8-hour minimum | CalendarDate | EmployeeCalendarDate | 8.00 | Holiday | 3.00 |  | True | 05/05/2026 07:22:58 |  |
| 3 | LONG_BOOM_MIN_4 | Long boom 4-hour premium minimum | ShiftAnchorDate | EmployeeShiftBoom | 4.00 | BoomOnly |  | EXCLUDE_NO_MODIFIER | True | 05/05/2026 07:22:58 |  |
| 4 | SPECIAL_SAT_MIN_8 | Special Saturday 8-hour minimum | CalendarDate | EmployeeCalendarDate | 8.00 | SpecialSaturday | 2.00 |  | True | 05/05/2026 07:22:58 |  |

---

# cfg.LaborType_TicketPolicy  (6 rows)

| LaborType | Is_AtomLabor | TicketExpectation | Notes |
|---|---|---|---|
| Both | False | NotExpected | Non-ATOM both: not ticketed (0%) |
| Both | True | Expected | ATOM labor: usually ticketed (~94%) |
| Labor | False | NotExpected | Non-ATOM labor: not ticketed (0%) |
| Labor | True | Optional | ATOM labor: mixed (~16.5% ticketed) |
| Unknown | False | NotExpected | Non-ATOM unknown: not ticketed (0%) |
| Unknown | True | Expected | ATOM labor: almost always ticketed (~99.5%) |

---

# cfg.Nightly_RunSettings  (1 rows)

| SettingsID | LookbackDays | UseYesterdayAsToDate | UpdatedAtUTC |
|---|---|---|---|
| 1 | 210 | True | 05/11/2026 03:22:01 |

---

# cfg.PayrollUI_ExcludedEmpID  (2 rows)

| EmpID | Reason | IsEnabled | UpdatedAtUTC |
|---|---|---|---|
| E***56 | test/system user | True | 02/24/2026 05:37:40 |
| E***12 | test/system user | True | 02/24/2026 05:37:40 |

---

# cfg.RestPeriod_Rule  (1 rows)

| RestRuleID | RuleName | RequiredRestHours | OTFloorMultiplier | StitchGapMinutes | TriggerMode | IsEnabled | UpdatedAtUTC |
|---|---|---|---|---|---|---|---|
| 1 | PunitiveUntil8Off | 8.00 | 1.50 | 30 | HrsOTDTPositive | True | 02/23/2026 08:33:24 |

---

# cfg.Union_Master_Rules  (1 rows)

| RuleID | UnionCode | Description | EffectiveDate | ExpirationDate | Standard_Start_Time | Standard_End_Time | Standard_Hours_Daily | DoubleTime_Threshold_Daily | OT_Multiplier | DT_Multiplier | Saturday_Multiplier | Sunday_Multiplier | Holiday_Multiplier | _CreatedDate |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | L12 | Mobile Crane Operators Group - Local 12 | 07/01/2025 00:00:00 | 06/30/2028 00:00:00 | 06:00:00 | 17:00:00 | 8.0 | 12.0 | 1.50 | 2.00 | 1.50 | 2.00 | 3.00 | 01/31/2026 10:44:35 |

---

# cfg.Union_Shift_Rules  (3 rows)

| ShiftRuleID | UnionCode | ShiftCode | Description | Premium_Hourly_Add | Is_Base_Rate_Modifier | Full_Shift_Work_Hours | Full_Shift_Paid_Hours | _CreatedDate |
|---|---|---|---|---|---|---|---|---|
| 1 | L12 | 1 | Standard Day Shift | 0.00 | False | 8.0 | 8.0 | 01/31/2026 10:44:52 |
| 2 | L12 | 2 | Second Shift | 3.00 | True | 7.0 | 8.0 | 01/31/2026 10:44:52 |
| 3 | L12 | 3 | Third Shift | 4.00 | True | 6.5 | 8.0 | 01/31/2026 10:44:52 |

---

# cfg.WTL_MaxMealThreshold  (5 rows)

| WTL_MaxMealThresholdID | UnionCode | EffectiveStartDate | EffectiveEndDate | MinSpanHours | MaxSpanHours | MaxMealPeriods | IsEnabled | Notes | CreatedAtUTC | ModifiedAtUTC |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | L12 | 01/01/2025 00:00:00 |  | 0.50 | 5.00 | 0 | True | WTL threshold: no meal period required/allowed. | 05/25/2026 10:04:15 |  |
| 2 | L12 | 01/01/2025 00:00:00 |  | 5.50 | 10.50 | 1 | True | WTL threshold: one meal period. | 05/25/2026 10:04:15 |  |
| 3 | L12 | 01/01/2025 00:00:00 |  | 11.00 | 16.00 | 2 | True | WTL threshold: two meal periods. | 05/25/2026 10:04:15 |  |
| 4 | L12 | 01/01/2025 00:00:00 |  | 16.50 | 21.50 | 3 | True | WTL threshold: three meal periods. | 05/25/2026 10:04:15 |  |
| 5 | L12 | 01/01/2025 00:00:00 |  | 22.00 | 27.00 | 4 | True | WTL threshold: four meal periods. | 05/25/2026 10:04:15 |  |

---

# cfg.WTL_Rule  (1 rows)

| WTL_RuleID | UnionCode | RuleName | EffectiveStartDate | EffectiveEndDate | MealPeriodHours | GroupLookbackDays | GroupLookaheadDays | StitchGapMinutes | MissingTokenBehavior | MealAssignmentPolicy | WeekdaySTStartMode | NonSTStartMode | SaturdayMode | SundayMode | SpecialSaturdayMode | HolidayMode | AddRateBasis | AddMultiplier | DeductBasis | SuppressComponentsOnTokenError | IsEnabled | Notes | CreatedAtUTC | ModifiedAtUTC |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | L12 | L12_WTL_2025 | 01/01/2025 00:00:00 |  | 0.50 | 4 | 4 | 0 | ASSUME_WTL_0_WARN | TAKEN_EARLIEST_THEN_WTL_REMAINDER | WTL_DT_FLOOR | WTL_APPLICABLE_ADD | WTL_APPLICABLE_ADD | WTL_APPLICABLE_ADD | WTL_APPLICABLE_ADD | WTL_APPLICABLE_ADD | BASE_PLUS_SHIFT_EXCLUDE_BOOM | 2.00 | FULL_SELECTED_PRICED_SLICE | True | True | WTL token means number of worked-through/missed meal periods. Missing token assumes WTL_0 and warns. Taken meals deduct earliest modeled meal opportunities. WTL add/premium uses base + shift, excludes boom, and uses DT multiplier. | 05/25/2026 10:04:15 |  |

---

# dim.LU12_Holiday  (44 rows)

| LU12_HolidayID | Date | HolidayName | PayRateMultiplier | IsWorkRestricted | RuleApplied |
|---|---|---|---|---|---|
| 1 | 01/01/2025 00:00:00 | New Year's Day | 3.00 | False | Actual |
| 2 | 07/04/2025 00:00:00 | Independence Day | 3.00 | False | Actual |
| 3 | 11/11/2025 00:00:00 | Veterans' Day | 3.00 | False | Actual |
| 4 | 12/25/2025 00:00:00 | Christmas Day | 3.00 | False | Actual |
| 5 | 02/17/2025 00:00:00 | Presidents' Day | 3.00 | False | Actual |
| 6 | 05/26/2025 00:00:00 | Memorial Day | 3.00 | False | Actual |
| 7 | 09/01/2025 00:00:00 | Labor Day | 3.00 | True | Actual |
| 8 | 11/27/2025 00:00:00 | Thanksgiving Day | 3.00 | False | Actual |
| 9 | 11/28/2025 00:00:00 | Day after Thanksgiving | 3.00 | False | Actual |
| 10 | 01/01/2026 00:00:00 | New Year's Day | 3.00 | False | Actual |
| 11 | 07/04/2026 00:00:00 | Independence Day | 3.00 | False | Actual |
| 12 | 11/11/2026 00:00:00 | Veterans' Day | 3.00 | False | Actual |
| 13 | 12/25/2026 00:00:00 | Christmas Day | 3.00 | False | Actual |
| 14 | 02/16/2026 00:00:00 | Presidents' Day | 3.00 | False | Actual |
| 15 | 05/25/2026 00:00:00 | Memorial Day | 3.00 | False | Actual |
| 16 | 09/07/2026 00:00:00 | Labor Day | 3.00 | True | Actual |
| 17 | 11/26/2026 00:00:00 | Thanksgiving Day | 3.00 | False | Actual |
| 18 | 11/27/2026 00:00:00 | Day after Thanksgiving | 3.00 | False | Actual |
| 19 | 01/01/2027 00:00:00 | New Year's Day | 3.00 | False | Actual |
| 20 | 07/05/2027 00:00:00 | Independence Day | 3.00 | False | Observed (Sunday Rule) |
| 21 | 11/11/2027 00:00:00 | Veterans' Day | 3.00 | False | Actual |
| 22 | 12/24/2027 00:00:00 | Christmas Day | 3.00 | False | Observed (Sat Rule) |
| 23 | 02/15/2027 00:00:00 | Presidents' Day | 3.00 | False | Actual |
| 24 | 05/31/2027 00:00:00 | Memorial Day | 3.00 | False | Actual |
| 25 | 09/06/2027 00:00:00 | Labor Day | 3.00 | True | Actual |
| 26 | 11/25/2027 00:00:00 | Thanksgiving Day | 3.00 | False | Actual |
| 27 | 11/26/2027 00:00:00 | Day after Thanksgiving | 3.00 | False | Actual |
| 28 | 12/31/2027 00:00:00 | New Year's Day | 3.00 | False | Observed (Sat Rule) |
| 29 | 07/04/2028 00:00:00 | Independence Day | 3.00 | False | Actual |
| 30 | 11/11/2028 00:00:00 | Veterans' Day | 3.00 | False | Actual |
| 31 | 12/25/2028 00:00:00 | Christmas Day | 3.00 | False | Actual |
| 32 | 02/21/2028 00:00:00 | Presidents' Day | 3.00 | False | Actual |
| 33 | 05/29/2028 00:00:00 | Memorial Day | 3.00 | False | Actual |
| 34 | 09/04/2028 00:00:00 | Labor Day | 3.00 | True | Actual |
| 35 | 11/23/2028 00:00:00 | Thanksgiving Day | 3.00 | False | Actual |
| 36 | 11/24/2028 00:00:00 | Day after Thanksgiving | 3.00 | False | Actual |
| 37 | 06/07/2025 00:00:00 | June Special Saturday | 2.00 | False | Contract Clause A.4 |
| 38 | 12/06/2025 00:00:00 | December Special Saturday | 2.00 | False | Contract Clause A.4 |
| 39 | 06/06/2026 00:00:00 | June Special Saturday | 2.00 | False | Contract Clause A.4 |
| 40 | 12/05/2026 00:00:00 | December Special Saturday | 2.00 | False | Contract Clause A.4 |
| 41 | 06/05/2027 00:00:00 | June Special Saturday | 2.00 | False | Contract Clause A.4 |
| 42 | 12/04/2027 00:00:00 | December Special Saturday | 2.00 | False | Contract Clause A.4 |
| 43 | 06/03/2028 00:00:00 | June Special Saturday | 2.00 | False | Contract Clause A.4 |
| 44 | 12/02/2028 00:00:00 | December Special Saturday | 2.00 | False | Contract Clause A.4 |

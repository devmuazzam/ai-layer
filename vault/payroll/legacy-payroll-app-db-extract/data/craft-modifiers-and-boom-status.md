---
title: Legacy Payroll App - the 33 craft-modifier (boom bracket) codes with adders, craft codes, rate sources, boom statuses, exception templates
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

# A3 (part 2) - Distinct craft/boom/rate values from api.v_UI_Payroll_LaborEntry_WeekDetail_WithBuckets

Materialized full view (86728 labor-entry rows) then grouped.

## Distinct CraftModifierCode / Description / PayRateAdjustment

| CraftModifierCode | CraftModifierDescription | CraftModifierPayRateAdjustment | rows_ |
|---|---|---|---|
| *(null)* | Unknown | *(null)* | 59910 |
| OP-BP-06 | 181-200Ft-Operator | 4.500 | 3224 |
| OP-BP-02 | 101-120Ft-Operator | 1.500 | 2574 |
| OI-BP-06 | 181-200Ft-Oiler | 1.500 | 2558 |
| OP-BP-03 | 121-140Ft-Operator | 2.250 | 2557 |
| OP-BP-05 | 161-180Ft-Operator | 3.750 | 1862 |
| OP-BP-07 | 201-220Ft-Operator | 5.250 | 1749 |
| OP-BP-01 | 080-100Ft-Operator | 0.750 | 1629 |
| OI-BP-05 | 161-180Ft-Oiler | 1.250 | 1587 |
| OP-BP-04 | 141-160Ft-Operator | 3.000 | 1558 |
| OI-BP-07 | 201-220Ft-Oiler | 1.750 | 1125 |
| OI-BP-04 | 141-160Ft-Oiler | 1.000 | 1019 |
| OI-BP-03 | 121-140Ft-Oiler | 0.750 | 870 |
| OP-BP-10 | 261-280Ft-Operator | 7.500 | 789 |
| OI-BP-01 | 080-100Ft-Oiler | 0.250 | 623 |
| OP-BP-09 | 241-260Ft-Operator | 6.750 | 606 |
| OP-BP-08 | 221-240Ft-Operator | 6.000 | 591 |
| OI-BP-02 | 101-120Ft-Oiler | 0.500 | 512 |
| OI-BP-10 | 261-280Ft-Oiler | 2.500 | 477 |
| OI-BP-09 | 241-260Ft-Oiler | 2.250 | 389 |
| OI-BP-08 | 221-240Ft-Oiler | 2.000 | 323 |
| OP-BP-11 | 281-300Ft-Operator | 8.250 | 43 |
| OP-BP-13 | 321-340Ft-Operator | 9.750 | 39 |
| OI-BP-13 | 321-340Ft-Oiler | 3.250 | 31 |
| OP-BP-12 | 301-320Ft-Operator | 9.000 | 26 |
| OI-BP-11 | 281-300Ft-Oiler | 2.750 | 19 |
| OI-BP-12 | 301-320Ft-Oiler | 3.000 | 12 |
| OI-BP-14 | 341-360Ft-Oiler | 3.500 | 8 |
| OP-BP-15 | 361-380Ft-Operator | 11.250 | 7 |
| OP-BP-14 | 341-360Ft-Operator | 10.500 | 5 |
| OI-BP-15 | 361-380Ft-Oiler | 3.750 | 4 |
| OP-BP-18 | 421-440Ft-Operator | 13.500 | 1 |
| OP-BP-16 | 381-400Ft-Operator | 12.000 | 1 |


## Distinct CraftCode (top 60 by rows)

| CraftCode | rows_ |
|---|---|
| ADMIN-A | 20149 |
| L12-G3-A | 13639 |
| L12-G2-A | 9184 |
| L12-G6-A | 8958 |
| L12-APP-A | 8837 |
| L12-G7-A | 7571 |
| HDR-A | 4728 |
| L12-G8-A | 3877 |
| L12-G1-A | 1936 |
| L12-G4-A | 1839 |
| ADMIN-B | 1078 |
| L12-BG-A | 817 |
| L12-APP-B | 784 |
| HDR-B | 772 |
| L12-G5-A | 674 |
| HDR-C | 204 |
| L12-APP-C | 186 |
| L12-G7-C | 180 |
| L12-G9-A | 147 |
| L12-G6-C | 133 |
| L12-G7-B | 122 |
| ADMIN-C | 121 |
| L12-G3-B | 108 |
| L12-G2-B | 107 |
| L12-G2-C | 104 |
| L12-G6-B | 97 |
| L12-G3-C | 80 |
| L12-G8-B | 62 |
| L12-APP4-A | 47 |
| L12-G8-C | 39 |
| L12-G1-B | 26 |
| L12-APP2-A | 24 |
| L12-G5-B | 20 |
| L12-APP3-A | 13 |
| L12-APP5-A | 13 |
| HOLIDAY | 12 |
| YARD-A | 8 |
| L12-G1-C | 8 |
| L12-APP6-A | 7 |
| L12-G4-B | 6 |
| L12-G5-C | 4 |
| L12-BG-B | 3 |
| L12-G4-C | 2 |
| YARD-B | 1 |
| L12-BG-C | 1 |


## Distinct PayrollBaseRateSource

| PayrollBaseRateSource | rows_ |
|---|---|
| Labor.CraftCode -> UNION_CRAFT.PayRate | 59655 |
| Employee.PayRate | 21348 |
| Unknown / Needs Review | 5725 |


## Distinct PayrollModifierRateSource

| PayrollModifierRateSource | rows_ |
|---|---|
| No labor craft modifier | 33014 |
| Labor.CraftModifierCode -> UNION_CRAFT_MODIFIER.PayRateChange | 26641 |
| Not applicable to non-union admin | 21348 |
| Unknown / Needs Review | 5725 |


## Distinct BoomDisplayStatus

| BoomDisplayStatus | BoomEligible | HasCraftModifier | rows_ |
|---|---|---|---|
| No boom modifier | False | False | 44254 |
| Boom actual | True | True | 20522 |
| Ticket boom window only - no modifier | False | False | 15373 |
| Boom actual + gap | True | True | 4109 |
| Modifier present, no boom hours | True | True | 2183 |
| *(null)* | *(null)* | *(null)* | 287 |


## Distinct TicketExpectationFinding

| TicketExpectationFinding | rows_ |
|---|---|
| OK | 85056 |
| Missing expected Job Ticket | 1672 |


## Distinct JobTicketStatusDisplay

| JobTicketStatusDisplay | rows_ |
|---|---|
| No Job Ticket | 43117 |
| Completed | 41872 |
| Missing expected Job Ticket | 1672 |
| Ended | 26 |
| Not Started | 10 |
| Arrived Yard | 6 |
| Arrived Job | 5 |
| Viewed | 4 |
| 1st Signature | 4 |
| Cancelled | 3 |
| Started | 3 |
| 2nd Signature | 2 |
| Sent | 2 |
| Left Yard | 1 |
| Left Job | 1 |


## Distinct CraftCodeMismatchFlag

| CraftCodeMismatchFlag | rows_ |
|---|---|
| False | 63085 |
| True | 23643 |


## fms.Payroll_CalcException - normalized Reason templates (digits->#)

| Reason template (digits replaced by #) | total_rows |
|---|---:|
| Shift_Assumed (StdStart+HoursWorked) | 239783 |
| Warn_Reconstruction_ShiftMismatch | 169097 |
| Shift_Start NULL | 30672 |
| Warn_Overlap (PrevLPID=#; PrevEnd=#-#-# #:#; GapMinRaw=-#) | 25179 |
| Shift_Assumed (LaborTimesInvalid End<=Start) | 11712 |
| Warn_DuplicateWindow (Cnt=#; Start=#-#-# #:#; End=#-#-# #:#) | 9786 |
| WTL warning: no WTL token found; assuming WTL_#. | 9297 |
| RestPeriod_Overlap (Start < PrevEnd) | 6174 |
| Warn_Reconstruction_Possible#Plus \| Shift_Assumed (LaborTimesInvalid End<=Start) | 2721 |
| WTL warning: labor entry grouped with another labor entry for WTL rules. | 1579 |
| Warn_Reconstruction_ShiftMismatch+Possible#Plus | 1076 |
| Warn_Reconstruction_Possible#Plus | 913 |
| WTL warning: grouped labor entries overlap. | 172 |
| Shift_End <= Shift_Start | 110 |
| WTL error: multiple or conflicting WTL tokens found. | 19 |
| Warn_Reconstruction_Possible#Plus \| Shift_Assumed (StdStart+HoursWorked) | 15 |
| WTL review: grouped labor span exceeds configured threshold. | 15 |
| RestPeriod_RateMissing (Forced but RateUsed_Est<=#) | 3 |
| Shift_End NULL | 2 |
| WTL error: WTL token exceeds computed maximum meal periods. | 2 |


---
title: PayrollAPP rule/logic examples catalog
source: onedrive/OneDrive_1_8-11-2026/PAYROLL_APP_build/PayrollAPP_LABOR-LOGIC-EXAMPLES.xlsx
migrated: 2026-08-13
updated: 2026-08-11
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference]
entities: [labor-entry, payroll-group, test-scenario]
---

# PayrollAPP rule / logic examples catalog

Real labor entries in the legacy Payroll App, each picked to demonstrate one payroll rule.
This is the **best available seed for a regression-test suite** — every row is a rule area, a
variation, and the exact `LaborPayrollID` that exhibits it.

> **Employee names removed on migration.** The source workbook names the employee on every row.
> `EmpID` and `LaborPayrollID` are the keys that actually identify the scenario, so the names were
> dropped rather than copied into a second system — consistent with the knowledge pack's
> `SECURITY_REDACTION_CHECKLIST.md`. The names remain in the source workbook if a lookup is needed.

## Rule sources cited by the workbook

| Scope | Source |
| --- | --- |
| Local 12 union labor entry rules/logic | Southern California Contractors Association — Labor Agreements, <https://sccaweb.org/labor-relations/labor-agreements/> |
| Direct PDF (bypasses the Adobe wrapper on the SCCA page) | <https://sccaweb.org/wp-content/uploads/2026/01/OE-Local-12-MLA-25-28-Comp.pdf> |
| Non-union rules/logic | State of California, DIR, Labor Commissioner's Office — Overtime, <https://www.dir.ca.gov/dlse/faq_overtime.htm> (exempt = salary; non-exempt = hourly, rules apply) |

The workbook warns that its own text-extracted copy of the MLA "may [contain] some minor (but
important) errors when converting" and should be double-checked against the original.

## `ValidationStatus` column

The workbook grades each example: **Confirmed**, **Strong Candidate**, **Strong Candidate -
Complex**, or **Candidate - Has WTL** (i.e. the example is contaminated by an overlapping WTL
rule and is not a clean isolation of the rule under test).

## Catalog


### Payroll Rule Examples

| RuleArea | Variation | EmpID | WorkDate | LaborPayrollID | JobCode | WoCode | TicketNumber | RelatedLaborPayrollID | PayrollGroup | ValidationStatus | WhyGoodExample |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| L12 Holiday | 8-hour minimum / gap (issue with WTL on holiday) | 4001 | 2026-05-25 | 85598 | OM59250 |   | 45454 |   | L12 Labor Union Field | Confirmed | Clean holiday guarantee example already validated in SQL / ledger / UI. |
| L12 Special Saturday | 8-hour minimum / gap | 8038 | 2025-12-06 | 74066 | OM56426 |   | 39773 |   | L12 Labor Union Field | Confirmed | Clean December Special Saturday guarantee example already validated in SQL / ledger / UI. |
| Non-Union Admin Hourly | Daily double-time | 3840 | 2025-11-14 | 73287 |   | CU-20155 |   |   | Non-Union Admin Hourly | Confirmed | Clean non-union daily DT example already validated in SQL / ledger / UI. |
| Non-Union Admin Hourly | Weekly overtime | 3840 | 2026-04-10 | 82386 |   | YD-20158 |   |   | Non-Union Admin Hourly | Confirmed | Clean non-union weekly OT example already validated in SQL / ledger / UI. |
| L12 Base / Day Type | Outside-window OT after 5 PM | 7288 | 2026-06-10 | 86686 | OM59365 |   | 45969 |   | L12 Labor Union Field | Strong Candidate | Clean after-window example: 17:30-21:30 shift, all 4.00 hours after the 17:00 standard end, all OT, only ACTUAL_BASE_WORKED_PAY. |
| L12 Base / Day Type | Outside-window OT before 6 AM | 8600 | 2026-06-10 | 86661 | OM59431 |   | 45967 |   | L12 Labor Union Field | Strong Candidate | Clean before-window example: 05:30-09:00 shift, 0.50 hour before the 06:00 standard start, 3.00 ST and 0.50 OT, only ACTUAL_BASE_WORKED_PAY. |
| L12 Base / Day Type | Regular Saturday | 755 | 2026-05-30 | 85986 | OM59283 |   | 45691 |   | L12 Labor Union Field | Strong Candidate | Clean regular Saturday example: SATURDAY day type, 4.00 Saturday OT hours, no boom, no guarantee, no WTL, no rest, and only ACTUAL_BASE_WORKED_PAY. |
| L12 Base / Day Type | Sunday | 6464 | 2026-05-31 | 86326 |   | SAFETY-20185 |   |   | L12 Labor Union Field | Strong Candidate | Clean Sunday example: SUNDAY day type, 4.00 Sunday DT hours, no boom, no guarantee, no WTL, no rest, and only ACTUAL_BASE_WORKED_PAY. |
| L12 Base / Day Type | Weekday double-time allocation | 7943 | 2026-02-23 | 78716 | OM57006 |   | 41981 |   | L12 Labor Union Field | Strong Candidate | Clean weekday double-time allocation example: WEEKDAY day type with 12.50 total hours split into 8.00 ST, 4.00 OT, and 0.50 DT, only ACTUAL_BASE_WORKED_PAY. Also useful for explaining no-pyramiding behavior because the row includes after-window hours. |
| L12 Base / Day Type | Weekday overtime allocation | 8600 | 2026-06-09 | 86622 | OM59379 |   | 45930 |   | L12 Labor Union Field | Strong Candidate | Clean weekday overtime allocation example: WEEKDAY day type, 7.00 ST hours and 0.50 OT hours, no boom, no guarantee, no WTL, no rest, and only ACTUAL_BASE_WORKED_PAY. |
| L12 Base / Day Type | Weekday straight-time only | 6464 | 2026-06-10 | 86655 | OM58641 |   | 45944 |   | L12 Labor Union Field | Strong Candidate | Clean weekday straight-time example: WEEKDAY day type, 4.00 ST hours, no OT/DT, no boom, no guarantee, no WTL, no rest, and only ACTUAL_BASE_WORKED_PAY. |
| L12 Boom / Modifier | Actual boom worked pay | 7515 | 2026-05-22 | 85531 | OM59230 |   | 45413 |   | L12 Labor Union Field | Strong Candidate | Clean actual boom worked pay example with only ACTUAL_BASE_WORKED_PAY and ACTUAL_BOOM_WORKED_PAY. Shows 5.00 actual hours, 4.00 boom hours, OP-BP-01 modifier, $0.75 boom rate, and $3.00 boom component amount. |
| L12 Boom / Modifier | Guaranteed boom pay add / long boom minimum | 4457 | 2026-06-09 | 86598 | OM59129 |   | 45916 |   | L12 Labor Union Field | Strong Candidate | Clean long-boom minimum example: 3.00 actual qualifying boom hours / 4.00 required, 1.00 guaranteed boom hour added. |
| L12 Holiday | Holiday actual hours / no guarantee gap | 4596 | 2025-09-01 | 68660 | OM54598 |   |   |   | L12 Labor Union Field | Strong Candidate | Clean Labor Day actual-hours example: HOLIDAY day type, 10.50 DT hours, no holiday guarantee gap, no boom, no WTL, no rest, and only ACTUAL_BASE_WORKED_PAY. |
| L12 Special Saturday | June Special Saturday actual hours / no guarantee gap | 4 | 2025-06-07 | 63000 | OM52719 |   | 33386 |   | L12 Labor Union Field | Strong Candidate | Clean June Special Saturday actual-hours example: SPECIAL_SAT day type, 9.00 DT hours, no special-Saturday guarantee gap, no boom, no WTL, no rest, and only ACTUAL_BASE_WORKED_PAY. |
| Non-Union Admin Hourly | Seventh consecutive day OT and DT | 9770 | 2025-11-07 | 72647 |   |   |   |   | Non-Union Admin Hourly | Strong Candidate | Only current seventh-day non-union example found; has 8.00 seventh-day OT hours and 0.50 seventh-day DT hours. |
| Rest Period | Rest premium triggered, no overlap | 3574 | 2026-06-05 | 86493 | OM59320 |   | 45871 |   | L12 Labor Union Field | Strong Candidate | Clean rest-period premium example: 4.00 rest premium hours, $276.64 rest premium, Rest_IsForced=1, Rest_IsOverlap=0, no boom/WTL/guarantee components. |
| Shift Differential | Shift 2 paid-hours add | 3856 | 2026-04-13 | 82541 | OM57005 |   | 43858 |   | L12 Labor Union Field | Strong Candidate - Complex | Shows SHIFT_2_HOURS_ADD plus ACTUAL_SHIFT_DIFFERENTIAL; ledger explains 1.00 added hour at base + $3 shift premium and 1.50 multiplier. Complex example because it also includes boom and WTL. |
| Subsistence | Long weekday subsistence $85 payable-only | 4001 | 2026-06-09 | 86618 | OM58701 |   | 45937 |   | L12 Labor Union Field | Candidate - Has WTL | Good SUBSISTENCE_LONG_WEEKDAY_85 payable-only example; component is included in payable gross but excluded from Final_Gross_Pay. Not isolated because current available long-weekday-subsistence examples also include WTL. |
| Subsistence | Short subsistence $85 payable-only | 7033 | 2026-06-04 | 86358 | OM55783 |   | 45815 |   | L12 Labor Union Field | Candidate - Has WTL | Good SUBSISTENCE_SHORT_85 payable-only example; component is included in payable gross but excluded from Final_Gross_Pay. Not isolated because current available short-subsistence examples also include WTL. |

### Rate Review / Data Quality Examples

| RuleArea | Variation | EmpID | WorkDate | LaborPayrollID | JobCode | WoCode | TicketNumber | RelatedLaborPayrollID | PayrollGroup | ValidationStatus | WhyGoodExample |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Rate Review / Data Quality | Duplicate labor window | 8151 | 2026-03-09 | 79918 | OM57931 |   | 42542 | 79898 | L12 Labor Union Field | Strong Candidate | Clean duplicate labor-window example using a real named employee. Duplicate pair is 79898 and 79918. LPID 79918 has no WTL, boom, rest, guarantee, or subsistence components and only ACTUAL_BASE_WORKED_PAY. |
| Rate Review / Data Quality | Missing job ticket | AA | 2026-06-10 | 86677 |   |   |   |   | L12 Labor Union Field | Strong Candidate | Clean missing-ticket example: JobCode and JobTicketID are NULL on a 0.50-hour L12 row, with normal source/craft rate and only ACTUAL_BASE_WORKED_PAY. |
| Rate Review / Data Quality | Missing labor start or end time | 9346 | 2025-11-14 | 73148 |   |   |   |   | L12 Labor Union Field | Strong Candidate | Clean time-quality example: TimeStart_Labor and TimeEnd_Labor are both NULL on an 8.00-hour row. Useful for explaining fallback ordering and required ERP time fields. |
| Rate Review / Data Quality | Overlapping labor entries | 9787 | 2026-04-23 | 83343 | OM55783 |   | 44259 | 83345 | L12 Labor Union Field | Strong Candidate | Clean overlap example: same employee and WorkDate, overlap against related LPID 83345 from 11:30 to 12:00. Row has no WTL, boom, rest, guarantee, or subsistence components and only ACTUAL_BASE_WORKED_PAY. |
| Rate Review / Data Quality | Source rate vs craft + modifier mismatch | 9876 | 2026-06-09 | 86599 | OM59383 |   | 45919 |   | L12 Labor Union Field | Strong Candidate | Clean rate-review example: Source_Rate_Raw is 68.870 while CraftPayRate + modifier is 67.870, creating a 1.000 audit delta. Row is otherwise clean with only ACTUAL_BASE_WORKED_PAY. |
| Rate Review / Data Quality | Zero source rate / suppressed pay | 4743 | 2026-06-05 | 86432 | OM59450 |   | 45868 |   | L12 Labor Union Field | Strong Candidate | Strong suppressed-pay example: Source_Rate_Raw is 0.000 on a 5.00-hour L12 row with craft/modifier rates available. Pay_Actual_Gross and Final_Gross_Pay are both 0.00, demonstrating zero-rate suppression/review behavior. |
| Rate Review / Data Quality | Labor start date differs from WorkDate | 7943 | 2026-06-09 | 86656 | OM55521 |   | 45942 |   | L12 Labor Union Field | Strong Candidate - Complex | Clear date-quality example: WorkDate is 2026-06-09 but TimeStart_Labor is 2026-06-10 20:00:00. Complex because the row also includes boom and WTL components. |
| Rate Review / Data Quality | Source amount / implied rate mismatch | 614 | 2021-01-29 | 2067 | OM33067 |   | 2805 |   | L12 Labor Union Field | Candidate | Clear source amount / implied rate mismatch: Source_Amount_Raw 456.080 divided by 10.00 raw hours implies 45.608, while Source_Rate_Raw is 57.010. Older row but useful for ERP source-data validation discussion. |

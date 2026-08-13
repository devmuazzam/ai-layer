---
title: CodingCops Payroll Rule Matrix
source: onedrive/OneDrive_1_8-11-2026/CodingCops_Payroll_Rule_Matrix.xlsx
migrated: 2026-08-13
updated: 2026-08-05
status: unverified
conflicts_with: []
jira: []
topics: [payroll, erp-payroll, payroll-rules, requirements, implementation-tracker]
entities: [payroll-rule, payroll-group, pay-component, adp-export, guaranteed-hours, wtl, subsistence, fringe-contribution]
---

# CodingCops Payroll Rule Matrix

**68 rules.** The Crane Guys' summary requirements and implementation tracker for the
ERP Payroll Module, prepared for CodingCops and generated 2026-08-05.

> **Rule ID warning.** These `PR-###` ids are **not** the same ids as the `PR-###` ids in
> [erp-payroll-module-frd/](erp-payroll-module-frd/INDEX.md). The two documents number
> their rules independently, so `PR-010` is *L12 union base rate* here and *Reporting time*
> there. **Always cite the document as well as the id.** See
> [payroll/INDEX.md](INDEX.md).

## Status legend

| Status | Meaning |
| --- | --- |
| Existing baseline | Function exists in the current TCG Payroll App and can guide ERP design |
| Redesign required | Existing logic exists, but the ERP target behavior has changed or needs improvement |
| New ERP requirement | Not fully implemented in the current Payroll App |
| Confirmation required | Management, payroll, legal, or union interpretation is still needed |

## Source basis

- MCOG Union 12 Master Labor Agreement, July 1, 2025 through June 30, 2028 — payroll-specific summary.
- TCG Payroll App System Walkthrough — Current State, updated May 29, 2026.
- Current TCG payroll design decisions and project context through August 5, 2026.
- This workbook is a requirements starter and is **not legal advice**; open interpretations remain marked for confirmation.

## Implementation-tracking columns (blank in the source)

The source workbook carries ten further columns, all empty, for active project tracking:
CodingCops Owner, CodingCops Status, Source System/Table, Configuration Table, Earning Code,
Blocking Severity, Test Scenario IDs, Management Approved By, Approval Date, Notes/Open Questions.


## A. Payroll Foundation and Source Data

| Rule ID | Activity / Rule | Applies To | Trigger | Required Information | Required Logic / Output | Current Status | Confirmation / Open Decision |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PR-001 | Saturday-Friday payroll week | All employees | Any work date or selected payroll date | Work date; payroll calendar | Assign each record to the correct Saturday-Friday period | Existing baseline | Confirmed TCG design |
| PR-002 | Pay-period status workflow | All payroll periods | Period creation, calculation, approval, export, or close | Period dates; status; user; timestamp | Track Open, Calculated, Review, Approved, Exported, Closed, and Reopened statuses | Partial baseline | Management approval workflow |
| PR-003 | Employee master import | All employees | Employee created or changed | EmpID; name; status; CraftCode; PayType; EmpTypeID; rate; union; dates | Maintain effective employee payroll setup | Existing source baseline | Confirm final ERP field mapping |
| PR-004 | Labor-entry import | Employees with labor | Labor entered or source data refreshed | Employee; date; time; hours; job; WO; ticket; craft; modifier; comments; rate | Preserve source record and create payroll calculation input | Existing baseline | Confirm source ERP tables |
| PR-005 | Job-ticket import | Ticket-related labor | Labor entry references a job ticket | Ticket times; job; equipment; work window; boom window | Validate labor and supply equipment/job context | Existing baseline | Confirm authoritative time fields |
| PR-006 | ADP File Number mapping | Employees exported to ADP | Employee included in payroll export | EmpID; ADP File Number; active status | Preserve leading zeros; maximum six alphanumeric characters; enforce uniqueness | Partial baseline | Confirm CodingCops/ADP mapping design |
| PR-007 | System/testing employee exclusion | System, vendor, and placeholder records | Worklist or export generated | Employee CraftCode/payroll group | Exclude from production payroll review and export | Existing TCG design | Confirm exclusion codes |
| PR-008 | Effective-dated configuration | All payroll rules | Rule or rate changes | Effective from/to; rule version; approver | Historical recalculation must use rules effective on the work date | New ERP requirement | Confirm configuration ownership |

## B. Payroll Group and Rate Determination

| Rule ID | Activity / Rule | Applies To | Trigger | Required Information | Required Logic / Output | Current Status | Confirmation / Open Decision |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PR-009 | Payroll group classification | All employees | Employee or labor entry processed | Employee CraftCode; labor CraftCode; EmpTypeID; PayType | Assign L12 Field, L12 Mechanic, Non-Union Hourly, Non-Union Salary, or System/Testing | Redesign required | Confirm final mapping rules |
| PR-010 | L12 union base rate | L12 Field and eligible Mechanics | Labor CraftCode begins with L12 | Labor CraftCode; union craft rate; work date | Use effective union craft rate as base straight-time rate | Redesign required | Confirm mechanic applicability |
| PR-011 | L12 modifier/boom rate | Eligible L12 labor entries | Valid labor craft modifier exists | Modifier code; effective modifier rate; qualifying time window | Add modifier to base rate only during eligible time | Partial baseline | Confirm modifier source and windows |
| PR-012 | Non-union hourly rate | Non-Union Admin Hourly | Payroll group is hourly admin | Employee PayRate; effective date | Use employee-master hourly rate; do not use union craft rate | TCG design direction | Confirm rate-effective-date handling |
| PR-013 | Non-union salary rate | Non-Union Admin Salary | Payroll group is salary admin | Salary/rate; pay frequency; effective date | Produce salary-period amount and job-costing reference values | New ERP requirement | Management/legal confirmation |
| PR-014 | Rate comparison and validation | All paid labor | More than one rate source exists or rate is missing | Source rate; craft rate; modifier; employee rate | Flag missing, zero, expired, duplicate, or materially different rates | Existing partial baseline | Confirm tolerance thresholds |
| PR-015 | Higher rate for day/job | Eligible L12 employees | Employee works at multiple qualifying rates | All daily jobs, crafts, modifiers, and rates | Identify higher qualifying rate and create true-up component | New ERP requirement | Union/legal interpretation required |
| PR-016 | Apprentice wage step | L12 apprentices | Employee reaches configured accumulated-hour threshold | Apprentice status; hours; step; journeyman group | Apply effective apprentice percentage and flag step advancement | New ERP requirement | Confirm authoritative apprentice hours |

## C. Time Reconstruction and Premium Classification

| Rule ID | Activity / Rule | Applies To | Trigger | Required Information | Required Logic / Output | Current Status | Confirmation / Open Decision |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PR-017 | Time-source selection | Labor entries | Entry has one or more time sources | Labor times; ticket times; schedule; source hours | Select authoritative source using configured priority and record source used | Existing partial baseline | Confirm source priority |
| PR-018 | Assumed shift | Entries without reliable times | Valid hours exist but times are unavailable | Work date; hours; standard start | Construct review-only shift and create warning | Existing baseline | Confirm when assumption is allowed |
| PR-019 | Cross-midnight processing | Overnight shifts | End time is earlier than start time | Work date; start; end; day type | Continue into next date and apply configured calendar-day treatment | Existing baseline | Confirm final day-type policy |
| PR-020 | Half-hour reckoning | L12 labor | Eligible time is priced | Start/end times; rounding policy | Price work in half-hour increments using approved method | Existing baseline | Union/payroll confirmation of method |
| PR-021 | L12 standard work window | Eligible L12 labor | Weekday labor is processed | Time; work date; shift; agreement configuration | Identify time inside/outside 6:00 a.m.-5:00 p.m. window | Existing baseline | Confirm mechanic applicability |
| PR-022 | Daily straight time | Eligible hourly employees | First qualifying daily hours | Daily accumulated hours | Classify eligible hours as straight time | Existing baseline | Confirm payroll-group matrix |
| PR-023 | Daily overtime | Eligible hourly employees | Daily qualifying hours exceed eight | Employee/day accumulated hours | Classify hours over eight through twelve at applicable OT rate | Existing baseline for L12 | Confirm non-union calculation |
| PR-024 | Daily double time | Eligible hourly employees | Daily qualifying hours exceed twelve | Employee/day accumulated hours | Classify hours after twelve at applicable DT rate | Existing baseline for L12 | Confirm non-union calculation |
| PR-025 | Weekly overtime | Non-Union Admin Hourly | Weekly qualifying hours exceed legal threshold | Saturday-Friday worked hours | Apply California nonexempt weekly overtime without duplicating daily premium | New ERP requirement | Legal confirmation |
| PR-026 | Seventh consecutive day | Non-Union Admin Hourly | Employee works seven consecutive days in workweek | Daily work indicators; hours | Apply configured seventh-day OT/DT allocation | New ERP requirement | Legal confirmation |
| PR-027 | No pyramiding | L12 and other configured groups | Multiple premium rules apply to same time | Day type; daily status; premium eligibility | Select controlling multiplier while retaining additive base-rate premiums | Existing baseline | Confirm rule priority |
| PR-028 | Duplicate labor detection | All labor entries | Same employee has matching entry/window | Employee; date; start/end; source IDs | Create warning and prevent unexplained duplicate pay | Existing baseline | Confirm blocking severity |
| PR-029 | Overlapping labor detection | All labor entries | Employee labor windows overlap | Employee; actual/reconstructed windows | Create warning or error and identify related entries | Existing baseline | Confirm blocking severity |

## D. Weekend, Holiday, and Shift Rules

| Rule ID | Activity / Rule | Applies To | Trigger | Required Information | Required Logic / Output | Current Status | Confirmation / Open Decision |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PR-030 | Ordinary Saturday | Eligible L12 labor | Work occurs Saturday and no higher-priority rule applies | Work date; day type | Apply configured Saturday multiplier | Existing baseline | Confirm mechanic applicability |
| PR-031 | Sunday pay | Eligible L12 labor | Work occurs Sunday | Work date; hours; rate | Apply Sunday double-time treatment | Existing baseline | Confirm minimum-hours rule |
| PR-032 | L12 holiday calendar | Eligible L12 labor | Work date matches holiday/observed date | Effective holiday calendar | Identify holiday name, multiplier, and minimum guarantee | Existing baseline | Confirm annual maintenance owner |
| PR-033 | Holiday pay | Eligible L12 labor | Work occurs on configured holiday | Hours; rate; holiday multiplier | Pay actual and guaranteed hours at applicable holiday rate | Existing baseline | Confirm Labor Day emergency workflow |
| PR-034 | June/December Special Saturday | Eligible L12 labor | First Saturday following first Friday in June or December | Work date; calendar configuration | Apply double time and eight-hour minimum | Existing baseline | Confirm naming and non-construction exception |
| PR-035 | First shift | Eligible L12 labor | Shift 1 selected | Shift code; actual hours | Eight hours worked/eight paid; no shift premium | Existing baseline | Confirm shift source |
| PR-036 | Second shift | Eligible L12 labor | Shift 2 selected and shift conditions met | Shift code; operation dates; notification | Seven hours worked/eight paid; add $3/hour to base | Existing partial baseline | Confirm union-notification data |
| PR-037 | Third shift | Eligible L12 labor | Shift 3 selected and shift conditions met | Shift code; operation dates; notification | 6.5 hours worked/eight paid; add $4/hour to base | Existing partial baseline | Confirm union-notification data |
| PR-038 | Hazardous-material premium | Eligible L12 labor | Employee performs Level A or B regulated work | Hazard level; work window; approval | Add configured premium to base for qualifying time | New ERP requirement | Confirm source and approvals |

## E. Guaranteed Hours and Special Pay

| Rule ID | Activity / Rule | Applies To | Trigger | Required Information | Required Logic / Output | Current Status | Confirmation / Open Decision |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PR-039 | Reporting pay-no work | Eligible L12 employees | Employee reports and no work is provided | Schedule; reporting time; notification; reason | Pay two hours unless a contractual exception applies | Partial baseline | Confirm structured source fields |
| PR-040 | Work-provided minimum | Eligible L12 employees | Employee reports and performs work | Actual hours; day type; rate | Apply minimum four paid hours where applicable | Existing guarantee baseline | Confirm exclusions |
| PR-041 | Crane remains on job | Eligible L12 employees | Subsequent day and crane remains assigned to job | First/subsequent day; shutdown reason; actual hours | Apply four-, six-, or eight-hour decision tree | Partial baseline | Management/union confirmation |
| PR-042 | First-day travel/assembly exception | Eligible L12 employees | First day contains only travel, assembly, or preparation | Activity type; customer work indicator | Do not automatically apply eight-hour guarantee | New ERP requirement | Confirm activity coding |
| PR-043 | Long-boom premium | Eligible operators/oilers | Qualifying boom length is used | Boom length; crane type; classification; time window | Apply tiered premium and qualifying minimum | Partial baseline | Confirm equipment source data |
| PR-044 | Lattice-boom premium | Eligible Group 6+ employees | Qualifying lattice boom is used | Equipment group; employee role | Add operator/oiler premium according to agreement | New ERP requirement | Confirm interaction with long boom |
| PR-045 | Rest-period premium | Eligible L12 employees | Employee returns after OT without eight hours off | Previous chain; return time; rest gap | Apply OT floor until qualifying rest is received | Existing baseline | Confirm mechanic applicability |
| PR-046 | Meal opportunity | Eligible L12 employees | Continuous work exceeds configured meal threshold | Continuous span; actual meal periods | Determine expected meal opportunities | Existing WTL baseline | Confirm structured meal data |
| PR-047 | Worked-through-lunch adjustment | Eligible L12 employees | Expected meal is worked or WTL token indicates missed meal | WTL token/meal record; day type; rate | Create explicit WTL pay component and exceptions | Existing baseline | Confirm contract interpretation by day type |
| PR-048 | Standard subsistence | Eligible L12 employees | Overnight/distance/equipment conditions are met | Home yard; job; distance; overnight; equipment status | Add effective allowance as payable component | Existing token baseline | Confirm structured eligibility |
| PR-049 | Weekend subsistence | Eligible L12 employees | Qualifying long-distance weekend condition occurs | Distance; weekend dates; employer election | Pay weekend allowance or portal option, not both | New ERP requirement | Confirm election workflow |

## F. Contributions, Reimbursements, and Other Payments

| Rule ID | Activity / Rule | Applies To | Trigger | Required Information | Required Logic / Output | Current Status | Confirmation / Open Decision |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PR-050 | Union fringe contributions | Covered L12 employees | Worked or paid hours are finalized | Contribution hours; fund rates; apprentice status | Calculate Health, Pension, Annuity, Vacation-Holiday, Training, Dues, and Admin Fund | New ERP requirement | Trust reporting confirmation |
| PR-051 | Step I pension exclusion | Qualifying apprentices | Apprentice is within first qualifying 1,000 hours | Indenture date; cumulative hours | Exclude pension contribution when agreement criteria apply | New ERP requirement | Confirm apprentice source |
| PR-052 | Mileage reimbursement | Eligible approved travel | Employee uses approved personal vehicle | Miles; purpose; job; approval; effective rate | Calculate reimbursement using effective-dated rate | New ERP requirement | Confirm policy/rate ownership |
| PR-053 | Toll reimbursement | Eligible travel | Approved toll road is used | Toll amount; trip; receipt | Create reimbursement component | New ERP requirement | Confirm approval process |
| PR-054 | Parking reimbursement | Eligible employees | Free parking is unavailable under agreement conditions | Receipt; job location; approval | Reimburse actual approved cost | New ERP requirement | Confirm module ownership |
| PR-055 | Cell-phone reimbursement | Approved employees | Monthly approval is active | Eligibility dates; monthly amount | Create monthly or prorated reimbursement | New ERP requirement | Confirm HR/payroll ownership |
| PR-056 | Injury-day pay | Eligible L12 employee | Workplace injury prevents completion of day | Injury event; physician determination; hours worked | Pay full day at straight-time rate where required | New ERP requirement | Legal/HR confirmation |
| PR-057 | Vacation eligibility/pay | Eligible L12 employee | Service and annual-hour thresholds are met | Hire date; anniversary; qualifying hours | Calculate eligibility and vacation pay | New ERP requirement | HR/union confirmation |
| PR-058 | Final wages/waiting time | Separated employees | Layoff, discharge, or resignation occurs | Separation type/time; wages due; payment time | Calculate final wages and potential waiting-time exposure | New ERP requirement | Legal/HR confirmation |

## G. Audit, Review, Approval, and Export

| Rule ID | Activity / Rule | Applies To | Trigger | Required Information | Required Logic / Output | Current Status | Confirmation / Open Decision |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PR-059 | Pay-component ledger | All calculated payroll | Any earning or adjustment is calculated | Hours; rate; multiplier; amount; rule; source | Store each amount as a separate explainable component | Existing strong baseline | Confirm ERP component taxonomy |
| PR-060 | Missing-data issues | All payroll records | Required information is unavailable | Rule-specific required fields | Create Error, Warning, Review, or Informational issue | Existing baseline | Confirm severity matrix |
| PR-061 | Employee payroll worklist | Payroll staff | Pay period is reviewed | Employee; hours; gross; issues; status | Show employee-level review and approval summary | Existing baseline | Confirm CodingCops UI design |
| PR-062 | Labor-entry detail | Payroll staff | User opens employee/day/entry | Source, calculation, components, issues | Explain time, rate, premium, guarantee, and final pay | Existing baseline | Confirm required UI depth |
| PR-063 | Manual adjustment | Authorized payroll users | Approved correction is needed | Component; amount/hours; reason; approver | Add separate adjustment without overwriting original calculation | New ERP requirement | Confirm approval levels |
| PR-064 | Calculation run log | All payroll runs | Calculation starts or ends | Run ID; period; version; counts; status | Preserve calculation-run audit history | Existing baseline | Confirm retention period |
| PR-065 | Payroll approval | Payroll period | Review is complete | Outstanding issues; approvals | Block approval for configured critical errors | Partial baseline | Management confirmation |
| PR-066 | Payroll snapshot | Approved/closed period | Payroll is processed | Source records; configuration; components; approvals | Freeze immutable historical payroll result | Existing baseline | Confirm reopen/correction policy |
| PR-067 | ADP export | Approved employees/pay period | Export is requested | ADP ID; earning codes; hours; amounts | Validate mappings and generate export-ready records | New ERP requirement | Confirm ADP file specification |
| PR-068 | Retroactive correction | Previously processed payroll | Historical rate/rule/source correction occurs | Original snapshot; corrected data; affected periods | Calculate delta adjustment without rewriting original payroll | New ERP requirement | Confirm correction workflow |

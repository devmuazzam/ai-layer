---
title: TCG Payroll App (legacy) - Payroll group and rule applicability matrix
source: onedrive/OneDrive_1_8-11-2026/PAYROLL_APP_build/PayrollAPP_0.5/TCG_PayrollAPP_AI_Knowledge_Pack_2026-06-23.zip#06_EMPLOYEE_TYPE_AND_RULE_MATRIX.md
migrated: 2026-08-13
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app]
entities: [payroll-group, rule-eligibility, union-craft-rate]
part_of: payroll/payroll-app-current-state/INDEX.md
---

> **2026-08-18 — current behaviour is now code-verified.** For the "Confirm" cells below: the
> engine keys every L12 rule on `CraftCode LIKE 'L12%'`, so **L12 Mechanic entries run the same
> path as L12 Field** (standard day, outside-window OT, Sat/Sun/holiday/special-Sat, guarantees,
> boom modifier, rest premium, WTL, subsistence tokens). Non-Union Admin Hourly is repriced by
> `app.usp_Apply_CA_NonUnionAdminHourly_OT`, which zeroes every union field. `ADMIN-A/B/C` are
> the only crafts with `ApplyMinimumPay = 0`. Policy confirmation with management is still a
> separate question; this note states what the system does. Source:
> [../legacy-payroll-app-db-extract/](../legacy-payroll-app-db-extract/INDEX.md).

## Terminology

Use **Payroll Group** as the application/UI classification label. Avoid using "Employee Type" in the UI unless referring specifically to the source FCC Employee Type field.

## Current Payroll Groups

| Payroll Group | Source/classification intent | UI behavior |
|---|---|---|
| `L12 Labor Union Field` | Employee master CraftCode begins with `L12`, and employee is not mechanic type. | Display in payroll UI. |
| `L12 Labor Union Mechanic` | Employee master CraftCode begins with `L12`, and Employee.EmpTypeID = 3. | Display in payroll UI. |
| `Non-Union Admin Hourly` | Employee master CraftCode begins with `ADMIN`, and Employee.PayType = `H`. | Display in payroll UI. |
| `Non-Union Admin Salary` | Employee master CraftCode begins with `ADMIN`, and Employee.PayType = `S`. | Display in payroll UI with salary/exempt review path. |
| `System-Testing-VendorAccess` | SYS/testing/vendor/fake/default employees. | Exclude from payroll UI. |

## Worklist-facing source of truth

Worklist-facing Payroll Group and base rate should come from employee master data:

- `TCG_RawFMS.stg.FMS_EMPLOYEES_Raw` / source employee view
- `EmpID`
- `PayType`
- `UnionCode`
- `CraftCode`
- `PayRate`
- `EmpTypeId`
- employee type/description from employee type lookup

Recommended worklist SQL surface:

```sql
api.v_UI_Employee_PayrollGroupRate
```

## Labor-entry rule source of truth

For labor-entry detail/rules/calculation, classification may need labor-entry CraftCode plus employee master fields.

Current guidance:

- L12 labor entry: labor CraftCode begins with `L12`.
- Non-union labor entry: labor CraftCode begins with `ADMIN`.
- Mechanic vs field split uses employee master `EmpTypeID`.
- Hourly vs salary split uses employee master `PayType`.

## Rate-source matrix

| Payroll Group | Worklist base rate | Labor-entry pricing rate direction |
|---|---|---|
| `L12 Labor Union Field` | Employee CraftCode -> `UNION_CRAFT.PayRate` | Labor CraftCode -> `UNION_CRAFT.PayRate`; modifier -> `UNION_CRAFT_MODIFIER.PayRateChange`; avoid double-counting source combined rate. |
| `L12 Labor Union Mechanic` | Employee CraftCode -> `UNION_CRAFT.PayRate` | Same L12 union rate model, with mechanic classification. |
| `Non-Union Admin Hourly` | Employee.PayRate | Employee.PayRate; no boom modifier unless future confirmed. |
| `Non-Union Admin Salary` | Employee.PayRate / salary equivalent review | Separate salary/exempt review; not nonexempt hourly pricing by default. |
| `System-Testing-VendorAccess` | $0 or excluded | Excluded from payroll UI/calculation review. |

## Rule applicability starter matrix

| Rule | L12 Field | L12 Mechanic | Non-Union Admin Hourly | Non-Union Admin Salary | System/Testing |
|---|---|---|---|---|---|
| Display in payroll UI | Yes | Yes | Yes | Yes | No |
| ADP File Number display/edit | Yes | Yes | Yes | Yes | No |
| Duplicate/overlap warnings | Yes | Yes | Yes | Review/Yes if rows exist | No/Ignore |
| Missing/invalid time warnings | Yes | Yes | Yes | Review/Yes if rows exist | No/Ignore |
| L12 standard day 06:00-17:00 | Yes | Confirm | No | No | No |
| L12 outside-window OT | Yes | Confirm | No | No | No |
| L12 Saturday/Sunday/Holiday/Special Saturday | Yes | Confirm | No | No | No |
| L12 guaranteed/minimum hours | Yes | Confirm | No unless confirmed | No unless confirmed | No |
| L12 boom/modifier premium | Yes if modifier applies | Confirm | No unless confirmed | No | No |
| L12 rest-period premium | Yes | Confirm | No unless confirmed | No | No |
| L12 WTL token requirement | Yes | Confirm | No | No | No |
| L12 subsistence token | Maybe/when token exists | Confirm | Confirm/no by policy | No unless confirmed | No |
| Non-union CA nonexempt daily/weekly/7th-day OT | No | No | Yes | No | No |
| Salary/exempt threshold review | No | No | No | Consider/confirm | No |
| Pay component ledger display | Yes | Yes | Yes | Maybe/review | No |

## Recommended configuration model

Avoid hard-coded branching. Add/extend configuration tables such as:

```sql
cfg.PayrollGroup
cfg.PayrollGroupAssignmentRule
cfg.RuleDefinition
cfg.PayrollGroupRuleEligibility
cfg.RuleSeverityByPayrollGroup
```

A useful eligibility model:

| Field | Meaning |
|---|---|
| `PayrollGroupCode` | L12_FIELD, L12_MECHANIC, NONUNION_ADMIN_HOURLY, etc. |
| `RuleCode` | DAILY_OT, OUTSIDE_WINDOW_OT, WTL, GUARANTEE, etc. |
| `IsCalculationEnabled` | Whether to calculate the rule. |
| `IssueMode` | Error, Warning, Review, Ignore, NotApplicable. |
| `EffectiveStartDate` | Date rule becomes active. |
| `EffectiveEndDate` | Optional rule sunset date. |
| `Notes` | Management/payroll confirmation details. |

## Immediate implementation recommendations

1. Resolve Payroll Group once in a stable SQL view.
2. Expose Payroll Group in worklist and employee detail API responses.
3. Make WTL missing-token warnings Payroll Group aware.
4. Make Local 12 guarantees/rest/outside-window/special-day rules Payroll Group aware.
5. Implement non-union hourly under a separate component prefix.
6. Keep non-union salary in a separate salary/exempt review path.
7. Add tests for each Payroll Group and each applicable/non-applicable rule.

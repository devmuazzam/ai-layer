---
title: TCG Payroll App (legacy) - Payroll rule catalog
source: onedrive/OneDrive_1_8-11-2026/PAYROLL_APP_build/PayrollAPP_0.5/TCG_PayrollAPP_AI_Knowledge_Pack_2026-06-23.zip#05_PAYROLL_RULE_CATALOG.md
migrated: 2026-08-13
updated: 2026-06-23
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app, payroll-rules, overtime, wtl, subsistence]
entities: [overtime, double-time, shift-premium, boom-premium, guaranteed-hours, rest-premium, wtl, subsistence]
part_of: payroll/payroll-app-current-state/INDEX.md
---

## Purpose

This document summarizes the payroll rules currently represented or planned in the TCG Payroll App. It separates:

- contractual/source-policy concept
- current implementation behavior
- open design decisions

This is not legal advice. Management, payroll leadership, and legal/compliance should confirm final rule applicability.

## Rule families

| Rule family | Current implementation status | Notes |
|---|---|---|
| L12 regular/OT/DT pricing | Implemented for union baseline | Standard day window, daily accumulation, outside-window behavior, day-type multipliers. |
| L12 Saturday/Sunday/Holiday/Special Saturday | Implemented | Special Saturday wording/UI may need cleanup. |
| Shift differential | Implemented | Shift 2 and Shift 3 premiums and paid-hours add components. |
| Boom/modifier premium | Implemented/reviewed | Need to avoid double-counting when source rate already includes modifier. |
| Guaranteed/minimum hours | Implemented | Post-pricing guarantees with group/allocation tables and ledger rows. |
| Rest-period premium | Implemented | Punitive until required rest satisfied. |
| WTL / meal period | Implemented for L12-style token path | Needs Payroll Group eligibility filtering. |
| Subsistence | Implemented as token-driven payable-only components | UI/tie-out must distinguish payable gross vs final gross. |
| Rounding normalization | Implemented | Ledger rounding adjustments. |
| Duplicate/overlap data quality | Implemented | Broadly useful across Payroll Groups. |
| Rate review / source-rate review | Implemented | Current and future behavior needs clear union/non-union split. |
| Non-union CA nonexempt hourly | Design clarified; implementation/validation needed | Applies to `Non-Union Admin Hourly`. |
| Non-union salary/exempt review | Design needed | Should not use nonexempt hourly OT path. |
| ADP File Number mapping | Implemented on worklist | Edit allowed for payrollmanager/itadmin, read-only for payrollteam. |

## Local 12 baseline rules

### Standard day / outside-window / OT / DT

Current Local 12 baseline uses:

| Setting | Current value |
|---|---:|
| Standard day window | 06:00-17:00 |
| Standard daily straight-time threshold | 8.0 hours |
| Daily double-time threshold | after 12.0 hours |
| OT multiplier | 1.50 |
| DT multiplier | 2.00 |
| Saturday multiplier | 1.50 |
| Sunday multiplier | 2.00 |
| Holiday multiplier | generally 3.00 |

Current pricing uses 30-minute slices and one controlling multiplier per slice to avoid pyramiding.

### Day type priority

Current day-type behavior includes:

- Special Saturday
- Holiday
- Sunday
- Saturday
- Weekday

Special Saturday is the first Saturday in June and December and currently receives double-time behavior.

### Shift differential

| Shift | Work hours | Paid hours | Premium add |
|---|---:|---:|---:|
| Shift 1 | 8.0 | 8.0 | $0.00 |
| Shift 2 | 7.0 | 8.0 | $3.00/hour |
| Shift 3 | 6.5 | 8.0 | $4.00/hour |

Shift tokens are parsed from labor comments. Conflicting or missing shift tokens may default to standard shift behavior depending on the current SQL configuration/procedure logic.

### Boom / modifier premium

For L12 union rows:

- Base rate comes from the labor/craft/rate model under current implementation rules.
- Modifier/boom add comes from craft modifier data when applicable.
- Source rate may already include craft + modifier in some FMS data; avoid double-counting.
- The current project direction is that `Source_Rate_Raw` is audit/reference for L12 rows if it already includes combined craft+modifier, while craft/modifier tables should drive base plus boom pricing. Verify current SQL before changing.

### Guaranteed/minimum hours

Current guaranteed-hours logic is post-pricing and represented in:

```sql
fms.Payroll_GuaranteeGroup
fms.Payroll_GuaranteeAllocation
fms.Payroll_PayComponent
```

Representative ledger components:

- `GUARANTEED_BASE_PAY_ADD`
- `GUARANTEED_BOOM_PAY_ADD`
- `GUARANTEED_HOLIDAY_BASE_PAY_ADD`
- `GUARANTEED_SPECIAL_SAT_BASE_PAY_ADD`
- `GUARANTEE_RECONCILIATION_ADJUSTMENT`

### Rest-period premium

The current rest rule is punitive until required rest is satisfied. It requires 8 hours of rest after overtime before a straight-time shift. When forced, affected straight-time hours are escalated to at least the overtime floor.

Main object:

```sql
app.usp_Apply_RestPeriod_Premium
```

Representative ledger component:

```text
REST_PERIOD_PREMIUM
```

### WTL / meal-period rule

WTL is token-driven and post-pricing ledger-based.

Representative token states:

- `WTL_0`
- `WTL_1`
- `WTL_2`
- `WTL_3`
- `WTL_4`

Representative WTL components:

- `WTL_MEAL_DEDUCT`
- `WTL_DT_FLOOR`
- `WTL_APPLICABLE_ADD`

Known need: WTL warnings such as missing token should not apply to Payroll Groups where WTL is not applicable.

### Subsistence

Subsistence is currently comment-token driven and payable-only.

Representative components:

- `SUBSISTENCE_SHORT_85`
- `SUBSISTENCE_LONG_WEEKDAY_85`
- `SUBSISTENCE_LONG_WEEKEND_200`

Known UI/API semantics issue: payable gross including subsistence must be distinguished from `fms.Payroll_Calculated.Final_Gross_Pay`.

## Non-union admin hourly rules

Current design direction:

- Payroll Group: `Non-Union Admin Hourly`
- Use employee master `Employee.PayRate` as hourly rate.
- Apply California nonexempt hourly OT rules for actual worked time.
- Legal payroll/workweek remains Saturday-Friday.
- Sick/holiday/paid-non-worked time is not currently available from source FCC; future processing pages may collect it.
- OT should be based on actual hours worked.
- Do not apply Local 12-specific rules unless explicitly confirmed.

> **2026-08-18 correction:** these are no longer "potential" — the six codes below are live in
> `fms.Payroll_PayComponent`, written by `app.usp_Rebuild_PayComponentLedger_NonUnionAdminHourly_CA_NonExempt`
> after `app.usp_Apply_CA_NonUnionAdminHourly_OT`. Thresholds (8/12/40 h, 7th day, Sat–Fri week)
> are hard-coded in that proc; rate = `Employee.PayRate`. See
> [../legacy-payroll-app-db-extract/calculations.md](../legacy-payroll-app-db-extract/calculations.md) B9.

Potential component code prefix:

```text
NONUNION_CA_NONEXEMPT_
```

Potential components:

- `NONUNION_CA_NONEXEMPT_ST`
- `NONUNION_CA_NONEXEMPT_DAILY_OT`
- `NONUNION_CA_NONEXEMPT_WEEKLY_OT`
- `NONUNION_CA_NONEXEMPT_DAILY_DT`
- `NONUNION_CA_NONEXEMPT_7TH_DAY_OT`
- `NONUNION_CA_NONEXEMPT_7TH_DAY_DT`

## Non-union admin salary rules

Current design direction:

- Payroll Group: `Non-Union Admin Salary`
- Do not run through nonexempt hourly OT path by default.
- Consider a salary/exempt review path.
- Potential warning: compare salary/pay-rate equivalent against California exempt salary threshold, subject to management/legal confirmation.

## Data quality rules

Broadly useful across Payroll Groups:

- duplicate labor window warnings
- overlap warnings
- missing/invalid time warnings
- missing source/reference data warnings
- ticket expectation warnings where applicable
- rate mismatch/review warnings where applicable

Severity should become configurable by Payroll Group.

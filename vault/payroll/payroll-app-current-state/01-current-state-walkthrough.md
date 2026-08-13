---
title: TCG Payroll App (legacy) - Current-state technical walkthrough
source: onedrive/OneDrive_1_8-11-2026/PAYROLL_APP_build/PayrollAPP_0.5/TCG_PayrollAPP_AI_Knowledge_Pack_2026-06-23.zip#02_CURRENT_STATE_TECHNICAL_WALKTHROUGH.md
migrated: 2026-08-13
updated: 2026-06-23
status: reference
conflicts_with: []
jira: []
topics: [payroll, payroll-app, current-state, sql-first]
entities: [payroll-group, pricing-engine, pay-component, adp-file-number]
part_of: payroll/payroll-app-current-state/INDEX.md
---

**Updated:** 2026-06-23  
**Current source database:** `TCG_RawFMS`  
**Payroll app database:** `TCG_PayrollAPP`  
**Application stack:** SQL Server + C# API + Next.js Web UI

## Executive technical summary

The Payroll App is a SQL-first payroll calculation and review system. Source FCC/FMS data is exposed through `TCG_RawFMS`. The payroll calculation, rule configuration, ledger, audit, test, reporting, and API-facing SQL surfaces live in `TCG_PayrollAPP`.

The Web UI is a payroll review application. It does not calculate payroll independently. It displays SQL-calculated outputs, review issues, ledger rows, selected labor-entry detail, rate review, WTL status, guarantee information, rest-period detail, boom/ticket status, and ADP File Number mapping.

## Major current-state components

| Area | Current component / schema | Role |
|---|---|---|
| Raw source | `TCG_RawFMS.api.*` | FCC/FMS-style source views. |
| Source access | `TCG_PayrollAPP.src.*` synonyms | Thin references to RawFMS source views. |
| Base enrichment | `app.v_Base_LaborPayroll`, `app.v_Base_Employees` | Normalize source data for calculation and UI. |
| Calculation | `app.usp_Run_Pricing_Engine`, `calc.*`, `fms.Payroll_Calculated` | Pricing, slices, hours, gross pay, warnings. |
| Finalization | `app.usp_FinalizePayrollOutputs_AfterPricing` | Ordered post-pricing steps. |
| Ledger | `fms.Payroll_PayComponent` | Explainable component-level pay audit. |
| Guarantees | `fms.Payroll_GuaranteeGroup`, `fms.Payroll_GuaranteeAllocation` | Minimum/guaranteed hours decisions and allocations. |
| Exceptions | `fms.Payroll_CalcException` | Errors, warnings, review issues. |
| UI/API SQL | `api.*`, `rpt.*` | Stable consumer surfaces. |
| Snapshot/close | `app.PayPeriod`, `app.PayrollSnapshot`, `app.PayrollSnapshot_Detail` | Pay-period state and frozen close snapshots. |
| Tests | `test.*` | Regression tests and scenario validation. |

## Current pipeline

High-level flow:

```text
TCG_RawFMS source views
  -> TCG_PayrollAPP src synonyms
  -> base views / preprocessing
  -> pricing engine
  -> post-pricing finalization
  -> pay component ledger
  -> API/rpt SQL surfaces
  -> C# API
  -> Next.js browser UI
```

Current refresh paths:

1. Browser/UI refresh path through `api.usp_UI_RefreshPayroll_FromNexGen`.
2. PayrollAPP nightly/manual path through `etl.usp_RunNightly_PayrollAPP`.
3. Pay-period process/close path through `app.usp_ProcessPayroll_PayPeriod`.

## Important current implementation points

### Pricing and finalization

`app.usp_Run_Pricing_Engine` is the main actual-work pricing procedure. It produces current calculated payroll output in `fms.Payroll_Calculated`.

Post-pricing finalization is consolidated under:

```sql
app.usp_FinalizePayrollOutputs_AfterPricing
```

The finalization wrapper applies, in order, base-pay fallback/suppression, guarantees, rest premium, pay component ledger rebuild, shift add, WTL, reconciliation, subsistence, and rounding normalization.

### Pay component ledger

`fms.Payroll_PayComponent` is the key audit ledger. It explains pay by component group/code, such as:

- actual worked base pay
- actual boom pay
- shift differential
- guaranteed base/boom/holiday/special Saturday pay
- rest-period premium
- WTL meal-period components
- subsistence payable-only components
- rounding adjustments

### WTL / meal-period implementation

WTL is implemented after core pricing as a ledger-based rule. It reads comment tokens, models expected meals, creates explicit WTL components, and writes WTL warnings/reviews/errors.

WTL should not be assumed to apply to every employee/payroll group. The next design step is to make WTL warning/calculation eligibility payroll-group aware.

### Payroll Group classification

The project uses **Payroll Group** as the UI/application classification label to avoid confusion with source FCC Employee Type.

Current Payroll Groups:

- `L12 Labor Union Field`
- `L12 Labor Union Mechanic`
- `Non-Union Admin Hourly`
- `Non-Union Admin Salary`
- `System-Testing-VendorAccess`

`System-Testing-VendorAccess` should be excluded from payroll UI.

### ADP File Number

ADP File Number mapping is stored in:

```sql
app.EmployeeExternalIdentifier
```

with:

```sql
ExternalSystemCode = 'ADP'
ExternalIdentifierName = 'FILE_NUMBER'
```

Format intent:

- text value
- preserve leading zeros
- uppercase alphanumeric
- max length 6
- unique among active ADP FILE_NUMBER mappings

## Current system status themes

The app currently has strong implementation coverage for Local 12 payroll rules and supporting review/audit surfaces. The largest next work area is rule applicability by Payroll Group, especially distinguishing:

- L12 union field/mechanic rules
- Non-union admin hourly California nonexempt rules
- Non-union admin salary/exempt review rules
- System/testing/vendor access exclusions

## Key current design recommendation

Do not hard-code Payroll Group branching deep inside the pricing engine if avoidable. Prefer a configuration-driven model:

- Resolve Payroll Group early.
- Define rule applicability by Payroll Group.
- Allow each rule to calculate, warn, review, ignore, or suppress based on configuration.
- Preserve component ledger transparency.
- Add regression tests for each Payroll Group/rule combination.

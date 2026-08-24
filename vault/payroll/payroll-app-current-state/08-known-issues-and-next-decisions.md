---
title: TCG Payroll App (legacy) - Known issues and next decisions
source: onedrive/OneDrive_1_8-11-2026/PAYROLL_APP_build/PayrollAPP_0.5/TCG_PayrollAPP_AI_Knowledge_Pack_2026-06-23.zip#10_KNOWN_ISSUES_AND_NEXT_DECISIONS.md
migrated: 2026-08-13
updated: 2026-06-23
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app, open-questions]
entities: [payroll-group, wtl, final-gross-pay, payable-gross]
part_of: payroll/payroll-app-current-state/INDEX.md
---

## Purpose

This document tells the vendor what is not finished, what is known to be confusing, and what decisions are still needed. It should be read before refactoring or integrating the Payroll App into the ERP system.

## Highest priority next design area

### Payroll Group / rule applicability

The current system grew from an L12 union payroll-rule baseline. The next major design step is to make rule eligibility explicit by Payroll Group.

Current Payroll Groups:

- `L12 Labor Union Field`
- `L12 Labor Union Mechanic`
- `Non-Union Admin Hourly`
- `Non-Union Admin Salary`
- `System-Testing-VendorAccess`

Needed:

1. Confirm final rule applicability with management/payroll/legal.
2. Add configuration-driven rule eligibility.
3. Update warning/error generation to respect rule applicability.
4. Add tests for each Payroll Group.

## Known calculation/ledger semantics issues

### Final gross vs WTL-aware gross vs payable gross

Current semantics must be kept clear:

- `fms.Payroll_Calculated.Final_Gross_Pay` represents core calculated gross after actual, guarantee, and rest.
- WTL components are explicit ledger rows and can affect WTL-aware final-gross comparison.
- Subsistence is payable-only and should be included in payable gross, not necessarily `Final_Gross_Pay`.

Known issue: ledger rows with subsistence can appear out-of-balance if UI expects only `Final_Gross_Pay + WTLAmount`.

### WTL missing-token warnings

WTL missing-token warnings were expected after WTL implementation, but they should likely be restricted to WTL-eligible Payroll Groups.

Needed:

- Suppress or display `Not applicable` for non-union rows.
- Add WTL-specific regression tests.
- Confirm WTL applicability for L12 mechanics.

### Source rate / craft rate / modifier behavior

The project has had multiple rate-source refinements. Current guidance:

- Worklist base rate comes from employee master.
- L12 pricing should use craft base plus modifier where applicable and avoid double-counting if source rate already includes modifier.
- Non-union admin hourly uses employee master `PayRate`.
- Non-union salary uses separate salary/exempt review path.

Vendor should inspect current SQL before modifying any rate logic.

## UI cleanup items

### Special Saturday badge wording

Current row badge can show:

```text
Holiday: December Special Saturday
```

Preferred:

```text
Special Saturday: December
```

or:

```text
December Special Saturday
```

### Non-union WTL card wording

For `Non-Union Admin Hourly`, current selected-labor-entry WTL UI can show confusing missing-token language.

Preferred:

```text
Not applicable
WTL rule does not apply to Non-Union Admin Hourly rows.
```

### Zero display formatting

For no modifier / no boom rows, display:

```text
-
```

instead of:

```text
$0.00
```

where that improves clarity.

For zero entries/issues in summary cards, display `-` where appropriate.

## Setup/security issues

### Do not share `.env.local`

Share only `.env.local.example`.

The vendor should generate its own:

- `PAYROLL_API_KEY`
- `PAYROLL_WEB_AUTH_SECRET`
- local web-user password hashes
- SQL login password

The Web and API must use the same local API key.

### Multiple lockfiles warning

The Web build currently warns that Next.js detected multiple lockfiles and inferred workspace root from parent folder. Vendor should review whether both lockfiles are needed.

### Deprecated middleware convention

Next.js warns that `middleware` file convention is deprecated and recommends `proxy`. This is not currently blocking but should be handled during cleanup.

### npm audit vulnerabilities

The current Web install reports vulnerabilities. Vendor should review before production deployment.

## SQL Server / scheduling note

Current local environment uses SQL Server Express. SQL Server Express does not include SQL Server Agent. Refresh/runs are handled through stored procedures, browser refresh flow, manual SSMS execution, or external scheduling.

## Decisions needed from TCG management/payroll/legal

1. Which rules apply to L12 mechanics?
2. Which rules apply to non-union hourly employees?
3. Should non-union hourly use California nonexempt daily/weekly/7th-day OT rules only?
4. Should non-union salary rows be payroll-calculated, audit-only, or excluded from payroll calculation?
5. Should non-union salary have an exempt salary threshold warning?
6. Should WTL tokens be required only for L12 union rows?
7. Should subsistence token applicability vary by Payroll Group?
8. What is the exact payable gross definition for final ERP integration?
9. What is the ADP File Number source of truth after ERP migration?
10. What data should be masked/sanitized before vendor development/testing?

## Recommended implementation roadmap

1. Freeze and document current behavior.
2. Add Payroll Group / rule eligibility configuration.
3. Add automated tests for Payroll Group classification.
4. Add WTL applicability filtering.
5. Implement non-union hourly rule path with clear component codes.
6. Add non-union salary review path.
7. Clean up ledger gross semantics and UI labels.
8. Harden API/Web config/secrets handling.
9. Prepare ERP integration contract.
10. Convert final payroll calculation outputs into an ERP-ready export/API format.

---
id: PAY-061
title: PAY-061 — Employee payroll worklist
section: G-audit-review-export
status: open
updated: 2026-09-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-061 — Employee payroll worklist

**Rule:** Show employee-level review and approval summary.

**Applies to:** Payroll staff. **Trigger:** Pay period is reviewed.
**Requires:** Employee; hours; gross; issues; status.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-061` — baseline: *Existing baseline*
- **FRD** (target design): [09-data-quality-ledger-and-review.md](../erp-payroll-module-frd/09-data-quality-ledger-and-review.md) `PR-049` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: no direct counterpart (new in the ERP target)
- **SQL**: `api.tvf_UI_Payroll_Worklist_ForPayPeriodDate`

## Open

- **Blocking (matrix):** Confirm CodingCops UI design
- **Worklist inclusion rule, client message 2026-06-09 (Brian Petros — payroll-group determination + FCC profile screenshot):** for the selected payroll week show all **Active** employees **plus ~~Inactive employees who have labor entries that week~~** (see *Superseded* below); `SYS%` never shown. Extract complement: `api.tvf_Employees_ActiveButNoLabor_FieldOnly`. **The Active half and the `SYS%` exclusion stand unchanged.**

## Superseded — the INACTIVE clause only

**The 2026-06-09 message's "plus Inactive employees who have labor entries that week" clause is
superseded.** Nothing else in that message is affected: *Active employees are shown* and *`SYS%` is
never shown* both still hold, and the extract complement is untouched.

- **Superseded by:** [decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md](../../decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md)
  (DEC-0915, Q2), **on 2026-09-15**. Its gate table settles the question the other way — line 57,
  verbatim: `| INACTIVE | not assignable, hidden from default pickers | no | excluded |`, the last
  column being *Payroll worklist*. The same table includes `ACTIVE` and `ON_LEAVE` (*"included (PTO/sick
  are payroll's business, not the status's)"*) and excludes `PENDING_ONBOARDING` and `TERMINATED`.
- **The code matches the later decision, and the code is right.**
  `apps/api/src/usecase/payroll/payroll.service.ts:150` —
  `const PAYROLL_WORKLIST_STATUSES = new Set(['ACTIVE', 'ON_LEAVE']);`, documented in the line above
  it as *"Statuses that keep an employee on the payroll worklist (DEC-0915 Q2 gate table)"*. The gate
  is applied at `payroll.service.ts:169` — `if (!PAYROLL_WORKLIST_STATUSES.has(employee.status)) return 'STATUS';`
  — and `payroll.service.ts:154-159` records that the exclusion is checked in the usecase, before a
  `PayrollEmployeeInput` is built, so it also removes the employee from the ADP export, which rebuilds
  from what was persisted. **An INACTIVE employee with labor entries that week is excluded.**
- **The chain, for the next reader:** client message 2026-06-09 (include INACTIVE-with-labor) →
  **superseded** by decision 2026-09-15 (exclude INACTIVE) → implemented as `PAYROLL_WORKLIST_STATUSES`.
  No application code changed here; this note was the thing that was wrong. Verified against HEAD on
  2026-09-24.
- **Not reopened by this correction:** the `Blocking (matrix): Confirm CodingCops UI design` item
  above is a separate, still-open product question.

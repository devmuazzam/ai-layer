---
id: PAY-061
title: PAY-061 — Employee payroll worklist
section: G-audit-review-export
status: open
updated: 2026-08-24
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

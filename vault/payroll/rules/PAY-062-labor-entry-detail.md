---
id: PAY-062
title: PAY-062 — Labor-entry detail
section: G-audit-review-export
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-062 — Labor-entry detail

**Rule:** Explain time, rate, premium, guarantee, and final pay.

**Applies to:** Payroll staff. **Trigger:** User opens employee/day/entry.
**Requires:** Source, calculation, components, issues.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-062` — baseline: *Existing baseline*
- **FRD** (target design): [09-data-quality-ledger-and-review.md](../erp-payroll-module-frd/09-data-quality-ledger-and-review.md) `PR-050 + PR-051` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: no direct counterpart (new in the ERP target)

## Open

- **Blocking (matrix):** Confirm required UI depth
- **Status (client, 2026-08-24 batch):** *"still some known issues with displaying the correct number of hours in some of the rule scenarios"* — the display defects in [08-known-issues-and-next-decisions.md](../payroll-app-current-state/08-known-issues-and-next-decisions.md) (non-union WTL UI language, zero-display formatting, …) remain open upstream. The ERP detail view inherits the *requirements*, not the defects.

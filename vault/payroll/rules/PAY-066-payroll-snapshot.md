---
id: PAY-066
title: PAY-066 — Payroll snapshot
section: G-audit-review-export
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-066 — Payroll snapshot

**Rule:** Freeze immutable historical payroll result.

**Applies to:** Approved/closed period. **Trigger:** Payroll is processed.
**Requires:** Source records; configuration; components; approvals.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-066` — baseline: *Existing baseline*
- **FRD** (target design): [10-approval-close-export-and-adjustments.md](../erp-payroll-module-frd/10-approval-close-export-and-adjustments.md) `PR-054` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §0 (snapshot)
- **SQL**: `app.PayrollSnapshot_Detail` (ddl/)

## Open

- **Blocking (matrix):** Confirm reopen/correction policy

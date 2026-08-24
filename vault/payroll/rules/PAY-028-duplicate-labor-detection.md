---
id: PAY-028
title: PAY-028 — Duplicate labor detection
section: C-time-and-premium
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-028 — Duplicate labor detection

**Rule:** Create warning and prevent unexplained duplicate pay.

**Applies to:** All labor entries. **Trigger:** Same employee has matching entry/window.
**Requires:** Employee; date; start/end; source IDs.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-028` — baseline: *Existing baseline*
- **FRD** (target design): [09-data-quality-ledger-and-review.md](../erp-payroll-module-frd/09-data-quality-ledger-and-review.md) `PR-046` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: no direct counterpart (new in the ERP target)

## Open

- **Blocking (matrix):** Confirm blocking severity

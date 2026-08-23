---
id: PAY-029
title: PAY-029 — Overlapping labor detection
section: C-time-and-premium
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-029 — Overlapping labor detection

**Rule:** Create warning or error and identify related entries.

**Applies to:** All labor entries. **Trigger:** Employee labor windows overlap.
**Requires:** Employee; actual/reconstructed windows.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-029` — baseline: *Existing baseline*
- **FRD** (target design): [09-data-quality-ledger-and-review.md](../erp-payroll-module-frd/09-data-quality-ledger-and-review.md) `PR-046` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: no direct counterpart (new in the ERP target)

## Open

- **Blocking (matrix):** Confirm blocking severity

---
id: PAY-018
title: PAY-018 — Assumed shift
section: C-time-and-premium
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-018 — Assumed shift

**Rule:** Construct review-only shift and create warning.

**Applies to:** Entries without reliable times. **Trigger:** Valid hours exist but times are unavailable.
**Requires:** Work date; hours; standard start.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-018` — baseline: *Existing baseline*
- **FRD** (target design): [09-data-quality-ledger-and-review.md](../erp-payroll-module-frd/09-data-quality-ledger-and-review.md) `PR-047` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §0

## Open

- **Blocking (matrix):** Confirm when assumption is allowed

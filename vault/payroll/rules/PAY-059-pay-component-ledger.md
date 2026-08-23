---
id: PAY-059
title: PAY-059 — Pay-component ledger
section: G-audit-review-export
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-059 — Pay-component ledger

**Rule:** Store each amount as a separate explainable component.

**Applies to:** All calculated payroll. **Trigger:** Any earning or adjustment is calculated.
**Requires:** Hours; rate; multiplier; amount; rule; source.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-059` — baseline: *Existing strong baseline*
- **FRD** (target design): [09-data-quality-ledger-and-review.md](../erp-payroll-module-frd/09-data-quality-ledger-and-review.md) `PR-048` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §14
- **SQL**: pay-component ledger objects — `../legacy-payroll-app-db-extract/sql-object-index.md`

## Open

- **Blocking (matrix):** Confirm ERP component taxonomy

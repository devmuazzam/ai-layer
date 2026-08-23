---
id: PAY-047
title: PAY-047 — Worked-through-lunch adjustment
section: F-contributions-other
status: conflicted
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-047 — Worked-through-lunch adjustment

**Rule:** Create explicit WTL pay component and exceptions.

**Applies to:** Eligible L12 employees. **Trigger:** Expected meal is worked or WTL token indicates missed meal.
**Requires:** WTL token/meal record; day type; rate.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-047` — baseline: *Existing baseline*
- **FRD** (target design): [07-rest-meal-and-subsistence.md](../erp-payroll-module-frd/07-rest-meal-and-subsistence.md) `PR-036` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §10
- **Contract**: [01-article-iii-working-rules.md](../mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)
- **Test cases**: [rule-examples-catalog.md](../rule-examples-catalog.md) — WTL rows

## Open

- **Blocking (matrix):** Confirm contract interpretation by day type
- **Conflict:** Contract interpretation **by day type** unconfirmed (matrix open decision); the payroll team’s own lookup: `../wtl-charts.md`.

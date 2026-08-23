---
id: PAY-046
title: PAY-046 — Meal opportunity
section: F-contributions-other
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-046 — Meal opportunity

**Rule:** Determine expected meal opportunities.

**Applies to:** Eligible L12 employees. **Trigger:** Continuous work exceeds configured meal threshold.
**Requires:** Continuous span; actual meal periods.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-046` — baseline: *Existing WTL baseline*
- **FRD** (target design): [07-rest-meal-and-subsistence.md](../erp-payroll-module-frd/07-rest-meal-and-subsistence.md) `PR-035` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §10
- **Contract**: [01-article-iii-working-rules.md](../mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)

## Open

- **Blocking (matrix):** Confirm structured meal data
- **Cross-module consistency verified:** the engine's expected-meal brackets (≤5→0, 5.5–10.5→1, 11–16→2, 16.5–21.5→3, 22–27→4; opportunities at 5.0/10.5/16.0/21.5 h) line up with the Atom app's lunch deadlines (before 5 / 10.5 / 16.5 / 22 h, US-11) — field-ops capture and payroll expectation agree on the boundaries.
- **Three distinct grouping thresholds now on record:** WTL grouping breaks on **any gap** (§10), the rest chain on **> 30 min** (`Rest_ChainId`), the shift chain on **≥ 8 h** (`ChainGroup`). The client's big summary describes back-to-back grouping for lunch (consistent with any-gap) and the "<8 h between labor = one labor" chain — but never distinguishes the three. A split-entry gap of 15/45/500 minutes lands in three different regimes. Confirm all three thresholds are intended.

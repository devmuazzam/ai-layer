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
- **Client message 2026-06-10 ("WTL priced automatically at double time") — agrees, and the vault is more precise.** Extract §10 + `cfg.WTL_Rule` row `L12_WTL_2025`: *taken* meal → `WTL_MEAL_DEDUCT` removes the whole priced slice (base+shift+boom × multiplier); *worked-through* meal → `WTL_APPLICABLE_ADD` = 0.5 × (base + shift) × 2.0 — **boom excluded, per explicit config `BASE_PLUS_SHIFT_EXCLUDE_BOOM`** — with `WTL_DT_FLOOR` topping weekday ST-start blocks to ×2.0. The client's screenshot reproduces the extract's own worked example to the cent: +$69.03 = 0.5 × (66.03 base + 3.00 shift-2) × 2.0 (entry 84393); slice $111.42 = (66.03 + 3.00 + 5.25 boom `OP-BP-07`) × 1.5.
- **Contract question raised by the asymmetry:** deduct includes boom, add excludes it — deliberate in config, but is boom-exclusion from the WTL premium MLA-compliant/intended? Sits alongside this rule's open day-type interpretation.

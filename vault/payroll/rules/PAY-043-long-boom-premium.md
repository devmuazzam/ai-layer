---
id: PAY-043
title: PAY-043 — Long-boom premium
section: E-guarantees-special-pay
status: conflicted
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-043 — Long-boom premium

**Rule:** Apply tiered premium and qualifying minimum.

**Applies to:** Eligible operators/oilers. **Trigger:** Qualifying boom length is used.
**Requires:** Boom length; crane type; classification; time window.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-043` — baseline: *Partial baseline*
- **FRD** (target design): [06-boom-equipment-and-guaranteed-hours.md](../erp-payroll-module-frd/06-boom-equipment-and-guaranteed-hours.md) `PR-026` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §5
- **Contract**: [02-article-iv-classifications-and-wage-rates.md](../mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md)
- **Test cases**: [rule-examples-catalog.md](../rule-examples-catalog.md) — long-boom rows

## Open

- **Blocking (matrix):** Confirm equipment source data
- **Conflict:** Into-the-rate vs on-top (see PAY-011); boom-length arithmetic not in the legacy engine.

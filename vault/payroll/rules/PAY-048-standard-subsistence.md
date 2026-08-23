---
id: PAY-048
title: PAY-048 — Standard subsistence
section: F-contributions-other
status: conflicted
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-048 — Standard subsistence

**Rule:** Add effective allowance as payable component.

**Applies to:** Eligible L12 employees. **Trigger:** Overnight/distance/equipment conditions are met.
**Requires:** Home yard; job; distance; overnight; equipment status.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-048` — baseline: *Existing token baseline*
- **FRD** (target design): [07-rest-meal-and-subsistence.md](../erp-payroll-module-frd/07-rest-meal-and-subsistence.md) `PR-037` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §11
- **Contract**: [travel](../mcog-l12-mla-2025-2028/INDEX.md)
- **Test cases**: [rule-examples-catalog.md](../rule-examples-catalog.md) — subsistence rows

## Open

- **Blocking (matrix):** Confirm structured eligibility
- **Conflict:** Trigger changes shape: legacy is **token-driven** (`SUB_SHORT`/`SUB_LONG`, amounts hard-coded); target is distance/overnight **conditions**. `SUB` collides as earnings + deduction code (C-19, `../source-attribution-and-conflicts.md`).

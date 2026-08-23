---
id: PAY-045
title: PAY-045 — Rest-period premium
section: F-contributions-other
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-045 — Rest-period premium

**Rule:** Apply OT floor until qualifying rest is received.

**Applies to:** Eligible L12 employees. **Trigger:** Employee returns after OT without eight hours off.
**Requires:** Previous chain; return time; rest gap.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-045` — baseline: *Existing baseline*
- **FRD** (target design): [07-rest-meal-and-subsistence.md](../erp-payroll-module-frd/07-rest-meal-and-subsistence.md) `PR-034` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §9
- **Contract**: [01-article-iii-working-rules.md](../mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)

## Open

- **Blocking (matrix):** Confirm mechanic applicability
- **Two distinct chain concepts (extract):** the shift chain groups entries **< 8 h apart** (`ChainGroup`), but the rest rule chains entries **≤ 30 min apart** (`Rest_ChainId`). The client's back-to-back split convention interacts with *both* — a split gap of, say, 45 min keeps the shift chained but breaks the rest chain. Confirm both thresholds are intended for the ERP.

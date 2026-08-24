---
id: PAY-049
title: PAY-049 — Weekend subsistence
section: F-contributions-other
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-049 — Weekend subsistence

**Rule:** Pay weekend allowance or portal option, not both.

**Applies to:** Eligible L12 employees. **Trigger:** Qualifying long-distance weekend condition occurs.
**Requires:** Distance; weekend dates; employer election.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-049` — baseline: *New ERP requirement*
- **FRD** (target design): [07-rest-meal-and-subsistence.md](../erp-payroll-module-frd/07-rest-meal-and-subsistence.md) `PR-038` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §11
- **Contract**: [travel](../mcog-l12-mla-2025-2028/INDEX.md)

## Open

- **Blocking (matrix):** Confirm election workflow
- **Conflict:** **C-05 — weekday long-subsistence $85 or $200?** Silent across all 56 recorded calls (`../source-attribution-and-conflicts.md`). Weekend-vs-portal employer election unconfirmed.
- **C-05 ANSWERED:** **long subsistence = $200/day, over 77.5 mi, every day of the holdover job, worked or not** (08-20 SME, corroborated 08-21). The legacy engine's $85-Mon-Fri hard-coding is therefore the defect. "Holdover job" is the criterion — a multi-day stay-out assignment vs daily commuting.

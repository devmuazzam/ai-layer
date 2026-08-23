---
id: PAY-011
title: PAY-011 — L12 modifier/boom rate
section: B-group-and-rate
status: conflicted
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-011 — L12 modifier/boom rate

**Rule:** Add modifier to base rate only during eligible time.

**Applies to:** Eligible L12 labor entries. **Trigger:** Valid labor craft modifier exists.
**Requires:** Modifier code; effective modifier rate; qualifying time window.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-011` — baseline: *Partial baseline*
- **FRD** (target design): [03-payroll-groups-and-rate-determination.md](../erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md) `PR-008` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §4
- **Contract**: [02-article-iv-classifications-and-wage-rates.md](../mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md)

## Open

- **Blocking (matrix):** Confirm modifier source and windows
- **Conflict:** MLA says boom/modifier-class premiums go **into the base rate** before multipliers; the legacy slice formula partly agrees; “on top” never confirmed — Corrina had left the call (`../source-attribution-and-conflicts.md` → *Into the rate vs on top*).

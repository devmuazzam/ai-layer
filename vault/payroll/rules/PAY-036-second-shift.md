---
id: PAY-036
title: PAY-036 — Second shift
section: D-weekend-holiday-shift
status: conflicted
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-036 — Second shift

**Rule:** Seven hours worked/eight paid; add $3/hour to base.

**Applies to:** Eligible L12 labor. **Trigger:** Shift 2 selected and shift conditions met.
**Requires:** Shift code; operation dates; notification.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-036` — baseline: *Existing partial baseline*
- **FRD** (target design): [05-weekend-holiday-and-shift-rules.md](../erp-payroll-module-frd/05-weekend-holiday-and-shift-rules.md) `PR-024` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §8
- **Contract**: [01-article-iii-working-rules.md](../mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)
- **Test cases**: [rule-examples-catalog.md](../rule-examples-catalog.md) — shift rows

## Open

- **Blocking (matrix):** Confirm union-notification data
- **Conflict:** Into-the-rate vs on-top (see PAY-011) — MLA: shift premium “will become the base rate for the entire shift”.
- **Live sighting (client screenshot 2026-06-10):** the $3.00 second-shift adder inside a priced slice — (66.03 + **3.00** + 5.25) × 1.5 = $111.42/h.

---
id: PAY-037
title: PAY-037 — Third shift
section: D-weekend-holiday-shift
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-037 — Third shift

**Rule:** 6.5 hours worked/eight paid; add $4/hour to base.

**Applies to:** Eligible L12 labor. **Trigger:** Shift 3 selected and shift conditions met.
**Requires:** Shift code; operation dates; notification.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-037` — baseline: *Existing partial baseline*
- **FRD** (target design): [05-weekend-holiday-and-shift-rules.md](../erp-payroll-module-frd/05-weekend-holiday-and-shift-rules.md) `PR-025` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §8
- **Contract**: [01-article-iii-working-rules.md](../mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)
- **Test cases**: [rule-examples-catalog.md](../rule-examples-catalog.md) — shift rows

## Open

- **Blocking (matrix):** Confirm union-notification data
- **Conflict:** Into-the-rate vs on-top (see PAY-011).
- **Placement doctrine confirmed (see PAY-036):** +1.5 h at (base + shift) × last-slice multiplier, appended after actual work — matches the client's added-hours message exactly.
- **Into-rate reading adjudicated by contract verbatim — see PAY-011.**

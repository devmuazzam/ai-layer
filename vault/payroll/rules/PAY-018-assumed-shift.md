---
id: PAY-018
title: PAY-018 — Assumed shift
section: C-time-and-premium
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-018 — Assumed shift

**Rule:** Construct review-only shift and create warning.

**Applies to:** Entries without reliable times. **Trigger:** Valid hours exist but times are unavailable.
**Requires:** Work date; hours; standard start.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-018` — baseline: *Existing baseline*
- **FRD** (target design): [09-data-quality-ledger-and-review.md](../erp-payroll-module-frd/09-data-quality-ledger-and-review.md) `PR-047` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §0

## Open

- **Blocking (matrix):** Confirm when assumption is allowed
- **The "creative-magic" decoded** (extract, rules-plain-language table row *Shift assumed*): no usable start/end → the app **assumes a 06:00 start + hours worked** and raises `Shift_Assumed` / "Shift times assumed". Client's 2026-06-09 FYI promised "I can explain more later" — the extract already answers it; confirm this reading with Brian instead of waiting.
- **Exhibit (client message 2026-06-09, "creative-magic" FYI):** Job `OM58178` / ticket `45888`, Sat 2026-06-06 — three sources on one ticket: customer-recorded intervals → **0.00 h** (placeholder 2:00 PM in four fields), workflow timestamps → **0.98 h** (rolling into 6/7 — cross-midnight), labor rows → **24.00 h × 2 employees = 48.00 h**. Not previously in the vault.

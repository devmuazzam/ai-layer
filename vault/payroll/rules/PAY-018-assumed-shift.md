---
id: PAY-018
title: PAY-018 — Assumed shift
section: C-time-and-premium
status: open
updated: 2026-09-07
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
- **The cap behind the exhibit (same client thread):** reconstruction can only handle **≤ 23.5 h per entry** — reconstructing from (date, duration) at half-hour granularity cannot unambiguously represent ≥ 24 h, and 23.5 = 24 − one slice. Our derivation; confirm the basis with Brian. The exhibit's 24.00-h rows are therefore *beyond-limit data*, which is why they price nonsensically.
- **Disabled in production (2026-09-07 backup, [legacy-payroll-app-db-backup-2026-09-07/INDEX.md](../legacy-payroll-app-db-backup-2026-09-07/INDEX.md)):** `usp_Run_Pricing_Engine` gained
  `@StrictLaborTimes bit = 1`; the 06:00-start + hours reconstruction runs only when the caller
  passes 0. Entries with missing or equal start/end raise `Missing_Required_Labor_Times` /
  `Invalid_Labor_Time_Interval` (when `HoursWorked_Raw > 0`) and are not priced. So the blocking
  question "when is the assumption allowed" now has the client's operating answer: **never, by
  default** — review the entry instead. The ERP has real timestamps and needs no reconstruction;
  the exception path is what to mirror.

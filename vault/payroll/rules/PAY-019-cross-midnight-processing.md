---
id: PAY-019
title: PAY-019 — Cross-midnight processing
section: C-time-and-premium
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-019 — Cross-midnight processing

**Rule:** Continue into next date and apply configured calendar-day treatment.

**Applies to:** Overnight shifts. **Trigger:** End time is earlier than start time.
**Requires:** Work date; start; end; day type.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-019` — baseline: *Existing baseline*
- **FRD** (target design): [04-work-time-reconstruction.md](../erp-payroll-module-frd/04-work-time-reconstruction.md) `PR-013` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §0

## Open

- **Blocking (matrix):** Confirm final day-type policy
- **Exhibit:** ticket `45888`'s workflow timestamps roll from 6/6 into 6/7 (signatures and Left Job at 3:30–3:35 the next day) — a live cross-midnight case attached to the same message as PAY-017's source-disagreement exhibit.

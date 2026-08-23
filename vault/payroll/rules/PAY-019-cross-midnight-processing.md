---
id: PAY-019
title: PAY-019 — Cross-midnight processing
section: C-time-and-premium
status: conflicted
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
- **⚠️ Summary-vs-engine contradiction (client big-summary message):** Brian — *"the entire job is associated with the date in which the labor started"* (anchor date governs everything). The engine — §3: **day type changes at 00:00 per slice** ("a cross-midnight shift can change day type at 00:00; OT counting still runs from the shift start"). The anchor date governs *accumulation, grouping and guarantees* (`ShiftAnchorDate`), **not** premium day-type. Consequence that moves money: Friday 10 PM → Saturday 4 AM pays Saturday ×1.5 after midnight in the engine, straight Friday rates in Brian's summary. This *is* the matrix's open "confirm final day-type policy" — now with two named sides.

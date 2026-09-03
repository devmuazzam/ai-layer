---
id: PAY-045
title: PAY-045 — Rest-period premium
section: F-contributions-other
status: open
updated: 2026-09-04
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
- **Config truth (raw extract zip, `cfg.RestPeriod_Rule`):** `RequiredRestHours=8.00`, `OTFloorMultiplier=1.50`, **`StitchGapMinutes=30`** — the 30-minute rest-chain threshold is a config value, not a constant. `TriggerMode='HrsOTDTPositive'`, **changed from the DDL default** `'ActHoursOver8'` — a deliberate tuning worth confirming as intended when the thresholds question (findings #7) is answered.
- **Phantom hours must not affect the rest rule (client, explicit):** added hours "would not affect the 8-hour rest rule" — gap measurement uses actual entry windows ✓ by construction. **Precise check still required:** the trigger `TriggerMode='HrsOTDTPositive'` — does it read *actual-worked* OT/DT or *payable* OT/DT? Holiday-minimum gap hours are "reported as DT hours"; if the trigger reads payable columns, phantom DT could force rest on the next chain — exactly what the client says must not happen. One column-lineage check in `usp_Apply_RestPeriod_Premium` settles it.
- **Lineage verified in code:** the trigger reads `Hrs_OT + Hrs_DT` from actual priced slices (`Act_` family); gap/phantom hours live in `Gap_*` columns and **cannot reach the trigger**. The client's twice-stated invariant holds as-built. Threshold intent: `TriggerMode` was deliberately changed from its DDL default — config evidence of tuning, corroborated by both August meetings discussing the rule.
- **Selection window vs rule window (client thread, 2026-09-04):** Brian's legacy refresh selects **7 days backward** for this rule; Ehtesham objected that only the **8 hours** before a job start matter, and Brian agreed — his 7 days is the *initial select of candidate labor dates out of a data warehouse*, deliberate overshoot, not the rule. **Do not implement a 7-day lookback.** The rule stays the 8-hour gap with the 30-minute stitch; what the ERP owes is the ability to *see* the prior entry at all — `payroll.service.ts:151-155` currently loads only the period being calculated.

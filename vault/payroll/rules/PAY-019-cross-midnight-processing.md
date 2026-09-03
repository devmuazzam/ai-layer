---
id: PAY-019
title: PAY-019 — Cross-midnight processing
section: C-time-and-premium
status: settled
updated: 2026-09-04
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
- **The conflict's true shape (raw extract zip, `cfg.CrossMidnightDayTypePolicy` — also in [config-values.md](../legacy-payroll-app-db-extract/config-values.md)):** the engine implements **both** behaviors behind a config switch. Active: `CalendarDay` — *"Rate each 30-min increment by its calendar day type; OT accumulation still anchored to Day 1. **Default until Payroll Manager confirms otherwise.**"* Inactive: `AnchorFloor` — *"max(AnchorDayTypeRate, CalendarDayTypeRate)… **Use if Payroll Manager wants** shift-start day type to floor the whole entry."* A 10-case test harness ships with it (`test.Case_CrossMidnight_DayType`, `usp_Test_CrossMidnight_DayTypePolicy`). So this is a **deliberately parked decision awaiting Corrina**, not an engineering contradiction — and note `AnchorFloor` is a *max*, not Brian's pure-anchor summary: Weekday→Saturday still pays Saturday post-midnight under both implemented policies; only his summary denies it. The adjudication is now one question to the Payroll Manager plus one config flip, and the decision note should cite the config row and the harness.
- **✅ Settled 2026-09-04 — Corrina Bustos, in writing (Teams, answering a direct question about a
  cross-midnight long-boom day):** *"the question would remain irrelevant if they worked into
  Saturday or Sunday due to the fact that they were already on Double time. if they were to work
  into a holiday they would be owned an additional 8 hours at triple time as the rule is that the
  ee is owed a minimum of 8 hours."* Two rulings. **(a) The higher rate governs, never a
  downgrade** — a shift already at DT does not drop to Saturday x1.5 after midnight. This is the
  active `CalendarDay` policy read through the no-pyramiding precedence chain (`DT` outranks
  `SATURDAY`), and equally what the inactive `AnchorFloor` (`max`) would give, so **no config flip
  is required**; the parked decision resolves to *keep `CalendarDay`*. **(b) Spilling into a
  holiday is holiday work** — post-midnight slices price at x3 and the 8-hour holiday minimum
  fires (PAY-033). The only reading her answer rules out is Brian's pure-anchor summary, *"the
  entire job is associated with the date in which the labor started"*, which would have paid the
  start day's rates straight through. The `AnchorFloor` branch and its 10-case harness can stay as
  dead config; nothing needs changing in the engine. **Owed:** a `decisions/` note.
  Verification: [client-message-findings.md](../client-message-findings.md#2026-09-04--long-boom-day-breakdowns-drive-time-included-corrina-bustos-teams).

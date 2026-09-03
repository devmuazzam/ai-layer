---
id: PAY-021
title: PAY-021 — L12 standard work window
section: C-time-and-premium
status: open
updated: 2026-09-04
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-021 — L12 standard work window

**Rule:** Identify time inside/outside 6:00 a.m.-5:00 p.m. window.

**Applies to:** Eligible L12 labor. **Trigger:** Weekday labor is processed.
**Requires:** Time; work date; shift; agreement configuration.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-021` — baseline: *Existing baseline*
- **FRD** (target design): [04-work-time-reconstruction.md](../erp-payroll-module-frd/04-work-time-reconstruction.md) `PR-015` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §2
- **Contract**: [01-article-iii-working-rules.md](../mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)

## Open

- **Blocking (matrix):** Confirm mechanic applicability
- **Pre-6AM ST-bank rule corroborated by a named human, 2026-09-04 (first time):** Corrina
  Bustos's hand-worked long-boom breakdown splits a `4:00am-8:00am` drive as **2 OT + 2 ST** while
  the day still pays a **full 8 ST**. That is only reproducible under the engine's *"special pre-6AM
  ST-bank rule"* (`calculations.md:248`, `usp_Run_Pricing_Engine :1056-1114`): pre-6AM slices price
  as outside-window OT at x1.5 **and do not consume the 8-hour straight-time bank**, while still
  counting toward the 12-hour DT threshold. This matters because
  [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §2's
  slice-index prose reads the other way (*"slices 1-16 → x1.0"* with an outside-window floor, which
  would give 6 ST / 6 OT), while its own worked example (entry 83338, `04:00-17:00` → 8 / 4 / 1)
  agrees with Corrina. **Her breakdown is the tiebreak; the §2 prose is the thing that is wrong.**
  Whole day verified segment by segment: `4am-11:30pm` → 8 ST / 4 OT / 7.5 DT, engine and Corrina
  identical. Source: [client-message-findings.md](../client-message-findings.md#2026-09-04--long-boom-day-breakdowns-drive-time-included-corrina-bustos-teams).

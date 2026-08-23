---
id: PAY-020
title: PAY-020 — Half-hour reckoning
section: C-time-and-premium
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-020 — Half-hour reckoning

**Rule:** Price work in half-hour increments using approved method.

**Applies to:** L12 labor. **Trigger:** Eligible time is priced.
**Requires:** Start/end times; rounding policy.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-020` — baseline: *Existing baseline*
- **FRD** (target design): [04-work-time-reconstruction.md](../erp-payroll-module-frd/04-work-time-reconstruction.md) `PR-014` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §1
- **SQL**: `app.usp_Run_Pricing_Engine`

## Open

- **Blocking (matrix):** Union/payroll confirmation of method
- **Why 23.5:** the entry-duration cap (see PAY-004/PAY-018) equals 24 h minus one half-hour slice — the cap is an artifact of this rule's reckoning granularity.
- **Three-way agreement — ready for a decision note:** client (big summary): *"starting times rounded down/back to 30-minute increments, ending times rounded up/forward — all Union and non-union"* = engine §1 verbatim (`usp_Prepare_Continuous_Labor`: start down, end up, then 30-min slices) = MLA half-hour reckoning. The FRD's approval item (part 11, decision 6) reduces to confirming this in writing.

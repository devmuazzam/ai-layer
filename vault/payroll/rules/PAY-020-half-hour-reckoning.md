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

---
id: PAY-024
title: PAY-024 — Daily double time
section: C-time-and-premium
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-024 — Daily double time

**Rule:** Classify hours after twelve at applicable DT rate.

**Applies to:** Eligible hourly employees. **Trigger:** Daily qualifying hours exceed twelve.
**Requires:** Employee/day accumulated hours.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-024` — baseline: *Existing baseline for L12*
- **FRD** (target design): [04-work-time-reconstruction.md](../erp-payroll-module-frd/04-work-time-reconstruction.md) `PR-016` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §2
- **Contract**: [01-article-iii-working-rules.md](../mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)

## Open

- **Blocking (matrix):** Confirm non-union calculation
- **Confirmed 2026-09-10 by Corrina Bustos** ([../../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md](../../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md) §1): double time is a **flat 12-hours-of-paid-time
  trigger** in every start case — after 06:00, before 06:00, or before midnight — and Brian Petros
  10:04 contrasts it with the overtime logic for exactly that reason: *"it's much simpler with the
  double time, because double time will always kick in at 12 hours."* **Nothing sits above DT except
  a holiday** — Corrina 30:44: *"The only time it would ever convert is if they worked into a
  holiday."* Note the interaction that catches implementations out: the 12-hour cap can **cut the
  straight-time bank short** (midnight→14:00 pays only 6 h ST, not 8).

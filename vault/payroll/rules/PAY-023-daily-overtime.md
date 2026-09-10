---
id: PAY-023
title: PAY-023 — Daily overtime
section: C-time-and-premium
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-023 — Daily overtime

**Rule:** Classify hours over eight through twelve at applicable OT rate.

**Applies to:** Eligible hourly employees. **Trigger:** Daily qualifying hours exceed eight.
**Requires:** Employee/day accumulated hours.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-023` — baseline: *Existing baseline for L12*
- **FRD** (target design): [04-work-time-reconstruction.md](../erp-payroll-module-frd/04-work-time-reconstruction.md) `PR-016` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §2
- **Contract**: [01-article-iii-working-rules.md](../mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)

## Open

- **Blocking (matrix):** Confirm non-union calculation
- **Chain semantics verified (extract):** entries **< 8 h apart chain into one shift** (`ChainGroup`); cumulative OT/DT hours count *from the shift's actual start* and keep counting across midnight; guarantees and daily rules group on the chain's `ShiftAnchorDate`. This is what makes the client's split-entry convention ("back-to-back entries, each < 23.5 h — handled for all of the rules") work: the *shift* accumulates even though *entries* are capped.
- **Bucket assignment worked live with the Payroll Manager, 2026-09-10** ([../../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md](../../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md) §1). Three cases,
  weekday non-holiday L12, and the third one was a correction:
  1. **Start after 06:00** — 8 h ST, then OT, then DT after 12 h total.
  2. **Start before 06:00 but after midnight** — the pre-06:00 hours are **OT and do not consume the
     ST bank**; the 8 h of ST begins at 06:00. Worked example 04:00–23:30: 2 OT · 8 ST · 2 OT · DT
     from 16:00. Brian Petros 8:42: *"the accrual of the hours for standard time starts at actually
     6 A.M."*
  3. **Start before midnight** — **there is no straight time at all.** Corrina Bustos 16:33: *"if
     they start on overtime before midnight, they have to work 12 hours of OT and then everything
     else is doubled. **They don't, it doesn't start over at 6 A.M.**"* 17:22: *"That 6 A.M. rule is
     a wash and the 12 hours of overtime rule hits."* Worked example 22:00→14:00 = **12 OT + 4 DT**,
     not the 8 OT / 4 ST / 4 DT that Brian and Abdul Rehman had modelled; Kyle Harlow 16:13 accepted
     the correction, Brian 16:30 *"Oh, I forgot about that."*
  **The 8 hours of ST is a ceiling, not a guarantee** — in the midnight→14:00 case Corrina gives
  only **6 h ST** (00:00–06:00 OT, 06:00–12:00 ST, 12:00–14:00 DT) because the 12-hour DT cap binds
  first (21:02). Any implementation that seeds an 8-hour ST bank and decrements it will get this
  case wrong.

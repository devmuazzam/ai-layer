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

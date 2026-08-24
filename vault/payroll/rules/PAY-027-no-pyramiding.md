---
id: PAY-027
title: PAY-027 — No pyramiding
section: C-time-and-premium
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-027 — No pyramiding

**Rule:** Select controlling multiplier while retaining additive base-rate premiums.

**Applies to:** L12 and other configured groups. **Trigger:** Multiple premium rules apply to same time.
**Requires:** Day type; daily status; premium eligibility.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-027` — baseline: *Existing baseline*
- **FRD** (target design): [04-work-time-reconstruction.md](../erp-payroll-module-frd/04-work-time-reconstruction.md) `PR-017` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: no direct counterpart (new in the ERP target)
- **Contract**: [01-article-iii-working-rules.md](../mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)

## Open

- **Blocking (matrix):** Confirm rule priority

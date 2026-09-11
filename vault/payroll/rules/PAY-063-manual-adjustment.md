---
id: PAY-063
title: PAY-063 — Manual adjustment
section: G-audit-review-export
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-063 — Manual adjustment

**Rule:** Add separate adjustment without overwriting original calculation.

**Applies to:** Authorized payroll users. **Trigger:** Approved correction is needed.
**Requires:** Component; amount/hours; reason; approver.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-063` — baseline: *New ERP requirement*
- **FRD**: — *(matrix-only rule; no FRD counterpart — the FRD is Draft 0.1 and does not cover it)*
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §14 (adjustment components)

## Open

- **Blocking (matrix):** Confirm approval levels
- **Today's mechanism confirmed (08-20):** the weekly workbook's "base rate override" column → separate ADP row per distinct rate; the decision (craft-locked, super/payroll-controlled) replaces it in the ERP — see decisions/2026-08-20-craft-locked-rate-override.md.
- **The client's own framing, 2026-09-11 (Brian Petros):** *"This is related to the need for our
  payroll department to be able to manually enter and/or modify information/entries that affect
  payroll."* He arrives at it from the anniversary check — a row whose hours, rate and amount are
  **entered by Payroll and preserved exactly**, *"I would not recalculate the amount using our union
  pricing rules"* — and generalizes it to sales commissions and bonuses, union and non-union. That
  makes this rule's *"add separate adjustment"* only half the requirement: the other half is a
  **manually created pay row that the engine never calculates at all**. The two are different
  mechanisms and the matrix has an id only for the first. Blocking item *"confirm approval levels"*
  is now also Brian's ask, and Corrina Bustos is named as the person who can enumerate which check
  types qualify. Full entry: [../gaps.md](../gaps.md) → *Special earnings — a pay row the rule
  engine must not touch, and the payroll department's manual-entry path*.

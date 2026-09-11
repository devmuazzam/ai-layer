---
id: PAY-057
title: PAY-057 — Vacation eligibility/pay
section: F-contributions-other
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-057 — Vacation eligibility/pay

**Rule:** Calculate eligibility and vacation pay.

**Applies to:** Eligible L12 employee. **Trigger:** Service and annual-hour thresholds are met.
**Requires:** Hire date; anniversary; qualifying hours.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-057` — baseline: *New ERP requirement*
- **FRD**: — *(matrix-only rule; no FRD counterpart — the FRD is Draft 0.1 and does not cover it)*
- **Legacy engine**: no direct counterpart (new in the ERP target)

## Open

- **Blocking (matrix):** HR/union confirmation
- **Now sourced, 2026-09-11 — the contract states the thresholds and the payout, and FCC pays it
  today.** Brian Petros sent an FCC *Labor for Payroll Pre-Processor* screenshot of an "Anniversary
  Check": 40 hours × $79.660 = $3,186.40, class `L12 Anniversary`, no job, zero actual time, ST-only
  on a Saturday, approved by hand. The MLA is explicit
  ([../mcog-l12-mla-2025-2028/04-articles-vi-to-xv-funds-and-contributions.md](../mcog-l12-mla-2025-2028/04-articles-vi-to-xv-funds-and-contributions.md) §1): one year of
  continuous work *"or after his anniversary date, whichever comes first"* **plus at least 1200
  hours in that year** → *"one (1) week's vacation with pay for forty (40) hours at the employee's
  **regular rate of pay**."* §2 adds a **prorated** payout on layoff over ten consecutive days or on
  quitting, at an average of 100 hours/month, restarting the anniversary year if paid and recalled.
  So the *"service and annual-hour thresholds"* in this rule are **1 year / 1200 hours**, from the
  contract — the matrix's *HR/union confirmation* is still needed for how TCG applies it, not for
  what it says. **Four things remain unwritten:** which craft rate counts as *"regular rate of pay"*
  for an operator who worked several groups that year; whether the ERP computes eligibility or
  accepts a manual row; which date the row carries (the example uses the payroll-week start, not the
  hire anniversary); and whether the 40 hours consume the [PAY-025](PAY-025-weekly-overtime.md)
  weekly-overtime threshold. Full entry and evidence: [../gaps.md](../gaps.md) → *Anniversary Checks
  — the L12 vacation payout, live in FCC and specified nowhere*.

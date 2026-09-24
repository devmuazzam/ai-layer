---
id: PAY-069
title: PAY-069 — Money rounding and rounding-adjustment components
section: G-audit-review-export
status: open
updated: 2026-09-23
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-069 — Money rounding and rounding-adjustment components

**Rule:** Round money to cents and insert explicit rounding-adjustment ledger components so the ledger ties out exactly (legacy §14 behaviour). **In no kept catalog** — surfaced by the 2026-08-24 verification of the client’s June-9 rule list: the matrix’s PAY-020/PR-020 covers half-hour *time* reckoning only.

## Sources

- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §14 — the only written definition
- **Matrix / FRD**: absent — candidate for absorption into PAY-059 (ledger)

## Implemented — the money-rounding half

`packages/payroll-engine/src/money.ts` rounds **half away from zero**, matching T-SQL
`ROUND(x, 2)`. It first snaps the absolute value to **15 significant digits**, which
repairs float products like `1.5 × 16.33 = 24.494999…`. Then it shifts through the decimal
string form, so binary-float halves (`1.015`, `10.075`, `0.145`) round as their decimal form
reads. A rounded-away negative returns `0`, never `-0`. `money.spec.ts` pins the table on
both signs, plus the float-product and `-0` cases. The snap and `-0` handling came from
PR #657's review (app commit `0952501a2`). Source and reasoning: the *Money rounding to cents (PAY-069)* row in
[payroll-rules-provenance.md](../payroll-rules-provenance.md) §7.

The previous `Math.round(n * 100) / 100` rounded half toward +∞, so it under-deducted a
penny on an exact negative half — reachable, because PAY-046 posts the meal deduction with
−0.5 h. It would have surfaced as an unexplained diff in the July 25–31 golden-week
parallel run.

The **rounding-adjustment component** half stays **closed — inapplicable**: legacy §14
needed the adjustment row because `usp_Rebuild_PayComponentLedger` reconciled a ledger
against an independently computed `Final_Gross_Pay`, and the ERP derives the total from the
ledger instead (`calculate.ts` — `round2(components.reduce(...))`). There is no second
number to tie out to.

## Open

- **Blocking:** adopt into the matrix (likely as a PAY-059 sub-rule) and confirm the adjustment-component taxonomy. Time-rounding interpretation is separate — PAY-020’s FRD part-04 approval item.

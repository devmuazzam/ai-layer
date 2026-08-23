---
id: PAY-069
title: PAY-069 — Money rounding and rounding-adjustment components
section: G-audit-review-export
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-069 — Money rounding and rounding-adjustment components

**Rule:** Round money to cents and insert explicit rounding-adjustment ledger components so the ledger ties out exactly (legacy §14 behaviour). **In no kept catalog** — surfaced by the 2026-08-24 verification of the client’s June-9 rule list: the matrix’s PAY-020/PR-020 covers half-hour *time* reckoning only.

## Sources

- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §14 — the only written definition
- **Matrix / FRD**: absent — candidate for absorption into PAY-059 (ledger)

## Open

- **Blocking:** adopt into the matrix (likely as a PAY-059 sub-rule) and confirm the adjustment-component taxonomy. Time-rounding interpretation is separate — PAY-020’s FRD part-04 approval item.

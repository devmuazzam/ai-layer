---
id: PAY-073
title: PAY-073 — Sick / PTO / on-call pay
section: F-contributions-other
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-073 — Sick / PTO / on-call pay

**Rule (scope open):** sick, PTO and on-call amounts exist **only on the ADP sheet** today (legacy “Not calculated anywhere”). No kept rule says whether the ERP calculates them or ADP keeps them.

## Sources

- [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) → *Not calculated anywhere*
- [adp-sop-v3.8.md](../adp-sop-v3.8.md) — where they live today

## Open

- **Blocking:** explicit in/out decision. If out, record it as a decision so the omission stops looking like an oversight.
- **Scope refinement (client big summary):** *non-union sick hours are the one sick/PTO item currently entered into ADP*; nothing union-side, no PTO mentioned. The in/out decision for the ERP still stands, now with the as-is precisely stated.

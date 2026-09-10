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
- **ADP-side code inventory (8-18 pull):** `SIC` (Sick) and `PTP` (PTO Payout) exist, plus CA-compliance codes `1XQ` (CA SPSL 22), `1XX`, `VT1` — and the pull notes these CA codes "appear in no TCG document." The in/out decision should name which of these the ERP feeds.
- **Likely the same mechanism as an anniversary check (2026-09-11).** Brian Petros' spec for the
  `L12 Anniversary` class — preserve source hours/rate/amount, exclude from ST/OT/DT, weekly >40,
  seventh-day, rest continuity, WTL, guaranteed hours, Saturday/holiday rules and shift
  differential, require no job and no valid times — describes a **non-computed pay row**, and
  `ADMIN PTO`, `SICK`, `BER`, `DRUG` and `ON CALL` are classifications sitting in the same FCC table
  as `ANNIVERSAR` ([../fcc-employee-master-reference-data.md](../fcc-employee-master-reference-data.md) §3). This rule's in/out decision should
  be taken **as part of** that class question rather than separately, or the ERP acquires two
  parallel paths for the same shape of row. See [../gaps.md](../gaps.md) → *Special earnings — a pay
  row the rule engine must not touch, and the payroll department's manual-entry path*.

---
id: PAY-011
title: PAY-011 — L12 modifier/boom rate
section: B-group-and-rate
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-011 — L12 modifier/boom rate

**Rule:** Add modifier to base rate only during eligible time.

**Applies to:** Eligible L12 labor entries. **Trigger:** Valid labor craft modifier exists.
**Requires:** Modifier code; effective modifier rate; qualifying time window.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-011` — baseline: *Partial baseline*
- **FRD** (target design): [03-payroll-groups-and-rate-determination.md](../erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md) `PR-008` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §4
- **Contract**: [02-article-iv-classifications-and-wage-rates.md](../mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md)

## Open

- **Blocking (matrix):** Confirm modifier source and windows
- **Conflict:** MLA says boom/modifier-class premiums go **into the base rate** before multipliers; the legacy slice formula partly agrees; “on top” never confirmed — Corrina had left the call (`../source-attribution-and-conflicts.md` → *Into the rate vs on top*).
- **Client statement, client message 2026-06-09 (Brian Petros — payroll-group determination + FCC profile screenshot):** modifier rate = `UNION_CRAFT_MODIFIER.PayRateChange`, applied **only when a Craft Modifier Code is selected on the labor entry** — selection-driven, on top of the boom-window eligibility this rule states. Does not settle into-rate vs on-top.
- **Live sighting (client screenshot 2026-06-10):** modifier `OP-BP-07` (201–220 ft Operator) = **$5.250** riding inside the slice rate and multiplied — into-rate in the as-built engine — while the WTL add excludes it (`BASE_PLUS_SHIFT_EXCLUDE_BOOM`). Per-component composition rules differ; the into-rate-vs-on-top adjudication must state them per component.
- **Composition data point (lattice):** the MLA phrases lattice as "$1.00/$0.50 **over and above the hourly wage rate**" — an into-the-wage add-on by construction, and Corrina's 08-04 statement says lattice **stacks** with boom pay. Another per-component entry for the into-rate adjudication table.
- **Two more into-rate exhibits:** the Foreman (`FRR/FRO/FRD/FRT`) and Military (`MLR/MLO/MLD/MLT`) ADP families each carry REG/OT/DT/**TRI** buckets — flat adders would need one code; four buckets mean the +$3/+$10 ride the base rate through every multiplier. The composition table keeps filling in on the into-rate side.
- **Composition adjudicated by contract text (conflict → resolved reading):** shift — *"will become the base rate for the entire shift"* (Art III, verbatim); boom — becomes base when computing overtime (attribution register's MLA quote); lattice — "over and above the hourly wage rate"; foreman/military — four-bucket ADP families. **Into-the-rate across the board**, with two deliberate carve-outs: the WTL penalty pays 2× (base+shift) *excluding boom* (MLA "straight hourly rate"), and guarantee adds pay base+shift. Decision note pending; treated as the working reading.

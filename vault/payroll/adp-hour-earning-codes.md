---
title: ADP Hours/Earnings validation-table export (Company Code 631)
source: onedrive/OneDrive_1_8-11-2026/PAYROLL_APP_build/ADP-specific_files/HOUR_EARNING_CODES_20260604T184729Z.csv
migrated: 2026-08-13
updated: 2026-06-04
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, adp, earning-codes, reference-data]
entities: [adp-code, earning-code, hours-earnings]
---

# ADP Hours/Earnings validation table — Company Code 631

Exported 2026-06-04. This is the ADP-side list of Hours/Earnings codes the payroll export can
target.

> ## ⚠ SUPERSEDED 2026-08-13
>
> **Use [adp-api-responses/pay-data-input-meta.md](adp-api-responses/pay-data-input-meta.md)
> instead.** A live call to ADP's Payroll Data Input `/meta` endpoint returned the complete
> current table — **52 codes** against this file's 24 — and settled both warnings below.
>
> This file is kept as the historical record of what was believed on 2026-06-04, and because the
> `Accumulators` / `Category` / `Include in Total Hours Worked` columns it carries are **not**
> returned by the API. For those attributes it remains the only source, partial as it is
> (crosswalk **D-009**).

> **Identifier warning — RESOLVED.** This export is stamped **Company Code 631**, while the
> paydata workbook uses **4RZ**. ADP's live response gives the company codes as **`4RZ`**
> (THE CRANE GUYS LLC) and **`4RY`** (The Crane Guys, LLC - Ventura). **`631` is not a company
> code**, so the two were never competing values for the same field. Do not carry the ambiguity
> forward.

> **Incomplete — CONFIRMED, and now closed.** The codes flagged missing here really are absent
> from this export: the lattice premiums (`LPR/LPO/LPD/LPT`, `LOR/LOO/LOD/LOT`), the shift
> differentials (`S2R/S2O/S2D/S2T`, `S3R/S3O/S3D/S3T`), and `LBT`. **All of them exist in ADP** —
> this export was partial, not evidence of absence. Also missing from it and live in ADP: the
> Foreman codes `FRR/FRO/FRD/FRT`, the Military codes `MLR/MLO/MLD/MLT`, plus `CAO`, `1XQ`, `1XX`
> and `VT1`. One code listed here, **`LOB`**, does **not** appear in the live table at all.


| Code | Description-English (US) | Classification | Default Field Number | Status | Short Description | Accumulators | Category | Include in Total Hours Worked |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| ANV | Anniversary | B | 3 | Y | ANNIVE | Y | Other | N |
| BN | Bonus | B | 3 | Y | Bonus | Y | Other | N |
| BV | Bereavement | B | 3 | Y | Bereav | Y | Other | N |
| CM | Commission | B | 3 | Y | Comm | Y | Other | N |
| DT | Double Time | B | 4 | Y | DT | Y | Other | Y |
| FLA | FMLA | B | 3 | Y | FMLA | Y | Other | N |
| HDD | Holiday Double | B | 4 | Y | HolDBL | Y | Other | Y |
| HOL | Holiday | B | 3 | Y | Holidy | Y | Other | N |
| LBD | LONGBOOM DT | B | 3 | Y | LB DBL | Y |   | N |
| LBH | LONGBOOM HRLY | B | 3 | Y | LB HRL | Y |   | N |
| LBO | LONGBOOM OT | B | 3 | Y | LB OT | Y |   | N |
| LOB |   | B | 3 | Y |   | N |   | N |
| ONC | On Call NT | B | 3 | Y | OnCall | Y | Other | N |
| OTH |   | B | 3 | Y |   | N |   | N |
| PPD | PRIOR PERIO | B | 3 | Y | PRPDDT | Y | Other | N |
| PPO | PRIOR PERIO | B | 3 | Y | PRPDOT | Y | Other | N |
| PTO | P.T.O. | B | 3 | Y | PTO | Y | Other | N |
| PTP | PTO Payout | B | 3 | Y | PTOOut | Y | Other | N |
| RET | Retroactive | B | 3 | Y | Retro | Y | Other | N |
| SD | Shift Diff | B | 3 | Y | Shift | Y | Other | N |
| SIC | Sick | B | 3 | Y | Sick | Y | Other | N |
| SUB | Substpay NT | B | 3 | Y | SubNT | Y | Other | N |
| UJD | Unpd Jurydu | B | 3 | Y | Unpdjd | Y | Other | N |
| USR | UNIFRM SVC | B | 3 | Y | USERRA | Y | Other | N |

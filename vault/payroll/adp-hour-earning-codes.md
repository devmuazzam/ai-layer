---
title: ADP Hours/Earnings validation-table export (Company Code 631)
source: onedrive/OneDrive_1_8-11-2026/PAYROLL_APP_build/ADP-specific_files/HOUR_EARNING_CODES_20260604T184729Z.csv
migrated: 2026-08-13
updated: 2026-06-04
status: unverified
conflicts_with: []
jira: []
topics: [payroll, adp-export, earning-codes, reference-data]
entities: [adp-code, earning-code, hours-earnings]
---

# ADP Hours/Earnings validation table — Company Code 631

Exported 2026-06-04. This is the ADP-side list of Hours/Earnings codes the payroll export can
target.

> **Identifier warning.** This export is stamped **Company Code 631**, while the current paydata
> workbook uses **ADP Co Code 4RZ**. The crosswalk instructs that these be treated as *different*
> ADP identifiers until ADP confirms their intended contexts — **do not substitute one for the
> other**. See [adp-bucket-crosswalk.md](adp-bucket-crosswalk.md), decision **D-001**.

> **Incomplete for the target design.** Several codes the crosswalk depends on are **absent** from
> this export — notably the lattice premiums (`LPR/LPO/LPD/LPT`, `LOR/LOO/LOD/LOT`), the shift
> differentials (`S2R/S2O/S2D/S2T`, `S3R/S3O/S3D/S3T`), and `LBT`. Two codes (`LOB`, `OTH`) carry
> no description at all. Crosswalk decision **D-001** asks for a complete re-export; treat this
> file as partial evidence, not the validation table.


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

---
title: FCC unit-type to job-type allow list — the 42 permitted pairings
source: shared-folder/Project-Repository-2026-09-04/3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL_APP_build/PayrollAPP_0.5/TCG_SQL_backup_2026-06-23.7z → TCG_RawFMS_20260623.bak, restored 2026-09-04 and read from stg.FMS_UNITTYPE_JOBTYPES_Raw
migrated: 2026-09-04
updated: 2026-09-04
status: reference
conflicts_with: []
jira: []
tags: [module/assets, module/quotations, kind/reference, reference-data]
part_of: payroll/tcg-rawfms-staging-database/INDEX.md
---

> Rows exactly as FCC NexGen held them when the nightly copy ran at 08:00 UTC on 2026-06-23.
> Audit columns (`CreatedBy`, `CreatedDate`, `ModifiedBy`, `ModifiedDate`, `trg*`, the two
> `_…AtUTC` load stamps) are dropped from the tables below; the full column set is in
> [../ddl/stg.FMS_UNITTYPE_JOBTYPES_Raw.sql](../ddl/stg.FMS_UNITTYPE_JOBTYPES_Raw.sql). This is what the system **held**, not
> what TCG has decided it should hold — treat every row as a fact about FCC, not a requirement.

# FCC unit-type ↔ job-type allow list — 42 rows

`FMS_UNITTYPE_JOBTYPES` says which job types a unit type may be booked under. `UnitTypeID`
resolves through the unit-type lookup in
[../../../assets/fcc-units-and-schedule-types.md](../../../assets/fcc-units-and-schedule-types.md);
`JobTypeCode` through [fcc-job-status-type-and-department-codes.md](fcc-job-status-type-and-department-codes.md).
The estimate-template mapping in
[../../../quotations/fcc-estimate-templates-by-job-type.md](../../../quotations/fcc-estimate-templates-by-job-type.md)
is the quoting-side view of the same pairing.

| JobTypeYardID | JobTypeCode | UnitTypeID |
|---|---|---|
| `4` | H | 3 |
| `6` | Z | 9 |
| `7` | Z | 7 |
| `8` | Z | 21 |
| `9` | Z | 8 |
| `10` | Z | 22 |
| `11` | H | 5 |
| `13` | H | 20 |
| `14` | H | 4 |
| `15` | Z | 23 |
| `16` | Z | 6 |
| `29` | Z | 28 |
| `30` | H | 6 |
| `31` | Z | 5 |
| `32` | H | 23 |
| `33` | Z | 20 |
| `34` | Z | 3 |
| `35` | Z | 4 |
| `36` | H | 7 |
| `37` | H | 21 |
| `38` | H | 8 |
| `39` | H | 22 |
| `40` | H | 9 |
| `41` | H | 28 |
| `42` | H | 31 |
| `44` | B | 33 |
| `45` | H | 34 |
| `47` | H | 41 |
| `48` | O | 48 |
| `55` | H | 56 |
| `59` | Z | 56 |
| `62` | H | 63 |
| `63` | Z | 63 |
| `64` | Z | 34 |
| `65` | H | 65 |
| `66` | Z | 65 |
| `67` | H | 67 |
| `68` | Z | 67 |
| `69` | H | 69 |
| `70` | H | 70 |
| `71` | Z | 70 |
| `72` | H | 71 |

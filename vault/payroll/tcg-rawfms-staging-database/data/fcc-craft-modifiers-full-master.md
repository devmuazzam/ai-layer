---
title: FCC craft modifiers — the full 52-bracket master and the Local 12 adders per bracket
source: shared-folder/Project-Repository-2026-09-04/3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL_APP_build/PayrollAPP_0.5/TCG_SQL_backup_2026-06-23.7z → TCG_RawFMS_20260623.bak, restored 2026-09-04 and read from stg.FMS_CRAFT_MODIFIER_Raw
migrated: 2026-09-04
updated: 2026-09-04
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, craft-modifier, boom, pricing, reference-data]
part_of: payroll/tcg-rawfms-staging-database/INDEX.md
---

> Rows exactly as FCC NexGen held them when the nightly copy ran at 08:00 UTC on 2026-06-23.
> Audit columns (`CreatedBy`, `CreatedDate`, `ModifiedBy`, `ModifiedDate`, `trg*`, the two
> `_…AtUTC` load stamps) are dropped from the tables below; the full column set is in
> [../ddl/stg.FMS_CRAFT_MODIFIER_Raw.sql](../ddl/stg.FMS_CRAFT_MODIFIER_Raw.sql). This is what the system **held**, not
> what TCG has decided it should hold — treat every row as a fact about FCC, not a requirement.

# FCC craft modifiers — all 52 boom-length brackets and their Local 12 adders

The legacy payroll extract lists the **33 modifier codes actually used on labor rows**
([../../legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md](../../legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md)).
This is the **full FCC master**: 26 oiler brackets (`OI-BP-01…26`) and 26 operator brackets
(`OP-BP-01…26`), each a 20-foot band from 80–100 ft up to 581–600 ft, all `Status = 1`.

The second table is the money: one row per (union, modifier) with the straight-time adder
and its pre-multiplied overtime (×1.5) and double-time (×2) values, effective-dated from April
2020 with no end date. The operator adder steps **$0.75 per bracket**; the oiler adder steps
**$0.50 per bracket** — which is the lattice-boom premium the MLA describes
([../../mcog-l12-mla-2025-2028/INDEX.md](../../mcog-l12-mla-2025-2028/INDEX.md)) and the ADP
workbook applies as `LATT_OPER` / `LATT_OILER`
([../../adp-workbook-power-query-engine.md](../../adp-workbook-power-query-engine.md)).

## `FMS_CRAFT_MODIFIER` — 52 codes

| CraftModifierCode | Description | Status |
|---|---|---|
| `OI-BP-01` | 080-100Ft-Oiler | 1 |
| `OI-BP-02` | 101-120Ft-Oiler | 1 |
| `OI-BP-03` | 121-140Ft-Oiler | 1 |
| `OI-BP-04` | 141-160Ft-Oiler | 1 |
| `OI-BP-05` | 161-180Ft-Oiler | 1 |
| `OI-BP-06` | 181-200Ft-Oiler | 1 |
| `OI-BP-07` | 201-220Ft-Oiler | 1 |
| `OI-BP-08` | 221-240Ft-Oiler | 1 |
| `OI-BP-09` | 241-260Ft-Oiler | 1 |
| `OI-BP-10` | 261-280Ft-Oiler | 1 |
| `OI-BP-11` | 281-300Ft-Oiler | 1 |
| `OI-BP-12` | 301-320Ft-Oiler | 1 |
| `OI-BP-13` | 321-340Ft-Oiler | 1 |
| `OI-BP-14` | 341-360Ft-Oiler | 1 |
| `OI-BP-15` | 361-380Ft-Oiler | 1 |
| `OI-BP-16` | 381-400Ft-Oiler | 1 |
| `OI-BP-17` | 401-420Ft-Oiler | 1 |
| `OI-BP-18` | 421-440Ft-Oiler | 1 |
| `OI-BP-19` | 441-460Ft-Oiler | 1 |
| `OI-BP-20` | 461-480Ft-Oiler | 1 |
| `OI-BP-21` | 481-500Ft-Oiler | 1 |
| `OI-BP-22` | 501-520Ft-Oiler | 1 |
| `OI-BP-23` | 521-540Ft-Oiler | 1 |
| `OI-BP-24` | 541-560Ft-Oiler | 1 |
| `OI-BP-25` | 561-580Ft-Oiler | 1 |
| `OI-BP-26` | 581-600Ft-Oiler | 1 |
| `OP-BP-01` | 080-100Ft-Operator | 1 |
| `OP-BP-02` | 101-120Ft-Operator | 1 |
| `OP-BP-03` | 121-140Ft-Operator | 1 |
| `OP-BP-04` | 141-160Ft-Operator | 1 |
| `OP-BP-05` | 161-180Ft-Operator | 1 |
| `OP-BP-06` | 181-200Ft-Operator | 1 |
| `OP-BP-07` | 201-220Ft-Operator | 1 |
| `OP-BP-08` | 221-240Ft-Operator | 1 |
| `OP-BP-09` | 241-260Ft-Operator | 1 |
| `OP-BP-10` | 261-280Ft-Operator | 1 |
| `OP-BP-11` | 281-300Ft-Operator | 1 |
| `OP-BP-12` | 301-320Ft-Operator | 1 |
| `OP-BP-13` | 321-340Ft-Operator | 1 |
| `OP-BP-14` | 341-360Ft-Operator | 1 |
| `OP-BP-15` | 361-380Ft-Operator | 1 |
| `OP-BP-16` | 381-400Ft-Operator | 1 |
| `OP-BP-17` | 401-420Ft-Operator | 1 |
| `OP-BP-18` | 421-440Ft-Operator | 1 |
| `OP-BP-19` | 441-460Ft-Operator | 1 |
| `OP-BP-20` | 461-480Ft-Operator | 1 |
| `OP-BP-21` | 481-500Ft-Operator | 1 |
| `OP-BP-22` | 501-520Ft-Operator | 1 |
| `OP-BP-23` | 521-540Ft-Operator | 1 |
| `OP-BP-24` | 541-560Ft-Operator | 1 |
| `OP-BP-25` | 561-580Ft-Operator | 1 |
| `OP-BP-26` | 581-600Ft-Operator | 1 |

## `FMS_UNION_CRAFT_MODIFIER` — 52 rate rows

| UnionCraftModifierID | UnionCode | CraftModifierCode | PayRateChange | PayRateChangeOT | PayRateChangeDB | Status | StartDate | EndDate |
|---|---|---|---|---|---|---|---|---|
| `1` | L12 | OP-BP-01 | .750 | 1.125 | 1.500 | 1 | 2020-04-10 00:00:00.0000000 |  |
| `2` | L12 | OP-BP-02 | 1.500 | 2.250 | 3.000 | 1 | 2020-04-10 00:00:00.0000000 |  |
| `3` | L12 | OP-BP-03 | 2.250 | 3.375 | 4.500 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `4` | L12 | OP-BP-04 | 3.000 | 4.500 | 6.000 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `5` | L12 | OP-BP-05 | 3.750 | 5.625 | 7.500 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `6` | L12 | OP-BP-06 | 4.500 | 6.750 | 9.000 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `7` | L12 | OP-BP-07 | 5.250 | 7.875 | 10.500 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `8` | L12 | OP-BP-08 | 6.000 | 9.000 | 12.000 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `9` | L12 | OP-BP-09 | 6.750 | 10.125 | 13.500 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `10` | L12 | OP-BP-10 | 7.500 | 11.250 | 15.000 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `11` | L12 | OP-BP-11 | 8.250 | 12.375 | 16.500 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `12` | L12 | OP-BP-12 | 9.000 | 13.500 | 18.000 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `13` | L12 | OP-BP-13 | 9.750 | 14.625 | 19.500 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `14` | L12 | OP-BP-14 | 10.500 | 15.750 | 21.000 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `15` | L12 | OP-BP-15 | 11.250 | 16.875 | 22.500 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `16` | L12 | OI-BP-01 | .250 | .375 | .500 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `17` | L12 | OI-BP-02 | .500 | .750 | 1.000 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `18` | L12 | OI-BP-03 | .750 | 1.125 | 1.500 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `19` | L12 | OI-BP-04 | 1.000 | 1.500 | 2.000 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `20` | L12 | OI-BP-05 | 1.250 | 1.875 | 2.500 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `21` | L12 | OI-BP-06 | 1.500 | 2.250 | 3.000 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `22` | L12 | OI-BP-07 | 1.750 | 2.625 | 3.500 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `23` | L12 | OI-BP-08 | 2.000 | 3.000 | 4.000 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `24` | L12 | OI-BP-09 | 2.250 | 3.375 | 4.500 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `25` | L12 | OI-BP-10 | 2.500 | 3.750 | 5.000 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `26` | L12 | OI-BP-11 | 2.750 | 4.125 | 5.500 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `27` | L12 | OI-BP-12 | 3.000 | 4.500 | 6.000 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `28` | L12 | OI-BP-13 | 3.250 | 4.875 | 6.500 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `29` | L12 | OI-BP-14 | 3.500 | 5.250 | 7.000 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `30` | L12 | OI-BP-15 | 3.750 | 5.625 | 7.500 | 1 | 2020-04-14 00:00:00.0000000 |  |
| `31` | L12 | OI-BP-16 | 4.000 | 6.000 | 8.000 | 1 |  |  |
| `32` | L12 | OI-BP-17 | 4.250 | 6.375 | 8.500 | 1 |  |  |
| `33` | L12 | OP-BP-16 | 12.000 | 18.000 | 24.000 | 1 |  |  |
| `34` | L12 | OP-BP-17 | 12.750 | 19.125 | 25.500 | 1 |  |  |
| `35` | L12 | OI-BP-18 | 4.500 | 6.750 | 9.000 | 1 |  |  |
| `36` | L12 | OI-BP-19 | 4.750 | 7.125 | 9.500 | 1 |  |  |
| `37` | L12 | OI-BP-20 | 5.000 | 7.500 | 10.000 | 1 |  |  |
| `38` | L12 | OI-BP-21 | 5.250 | 7.875 | 10.500 | 1 |  |  |
| `39` | L12 | OI-BP-22 | 5.500 | 8.250 | 11.000 | 1 |  |  |
| `40` | L12 | OI-BP-23 | 5.750 | 8.625 | 11.500 | 1 |  |  |
| `41` | L12 | OI-BP-24 | 6.000 | 9.000 | 12.000 | 1 |  |  |
| `42` | L12 | OI-BP-25 | 6.250 | 9.375 | 12.500 | 1 |  |  |
| `43` | L12 | OI-BP-26 | 6.500 | 9.750 | 13.000 | 1 |  |  |
| `44` | L12 | OP-BP-18 | 13.500 | 20.250 | 27.000 | 1 |  |  |
| `45` | L12 | OP-BP-19 | 14.250 | 21.375 | 28.500 | 1 |  |  |
| `46` | L12 | OP-BP-20 | 15.000 | 22.500 | 30.000 | 1 |  |  |
| `47` | L12 | OP-BP-21 | 15.750 | 23.625 | 31.500 | 1 |  |  |
| `48` | L12 | OP-BP-22 | 16.500 | 24.750 | 33.000 | 1 |  |  |
| `49` | L12 | OP-BP-23 | 17.250 | 25.875 | 34.500 | 1 |  |  |
| `50` | L12 | OP-BP-24 | 18.000 | 27.000 | 36.000 | 1 |  |  |
| `51` | L12 | OP-BP-25 | 18.750 | 28.125 | 37.500 | 1 |  |  |
| `52` | L12 | OP-BP-26 | 19.500 | 29.250 | 39.000 | 1 |  |  |

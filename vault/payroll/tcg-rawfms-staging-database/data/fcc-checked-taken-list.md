---
title: FCC Checked-by / Taken-by list — the 31 coordinator rows jobs and quotes point at
source: shared-folder/Project-Repository-2026-09-04/3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL_APP_build/PayrollAPP_0.5/TCG_SQL_backup_2026-06-23.7z → TCG_RawFMS_20260623.bak, restored 2026-09-04 and read from stg.FMS_CHECKED_TAKEN_Raw
migrated: 2026-09-04
updated: 2026-09-04
status: reference
conflicts_with: []
jira: []
tags: [module/quotations, module/projects-jobs, kind/reference, reference-data]
part_of: payroll/tcg-rawfms-staging-database/INDEX.md
---

> Rows exactly as FCC NexGen held them when the nightly copy ran at 08:00 UTC on 2026-06-23.
> Audit columns (`CreatedBy`, `CreatedDate`, `ModifiedBy`, `ModifiedDate`, `trg*`, the two
> `_…AtUTC` load stamps) are dropped from the tables below; the full column set is in
> [../ddl/stg.FMS_CHECKED_TAKEN_Raw.sql](../ddl/stg.FMS_CHECKED_TAKEN_Raw.sql). This is what the system **held**, not
> what TCG has decided it should hold — treat every row as a fact about FCC, not a requirement.

# FCC "Checked by / Taken by" list — 31 rows

The people a job or quote can be recorded as *taken by* (order entry) or *checked by*. This is
the list the commissions engine reads to pay coordinators
([../../../quotations/sales-commissions.md](../../../quotations/sales-commissions.md) §11):
`FMS_JOB_MASTER.TakenID` / `CheckID` point at `CheckTakenID` here, not at the sales-person
table. `Flag` is `B` for a TCG person and `C` for the single *Customer* row; `Status = 0` rows
are people no longer at TCG but still referenced by historical jobs. `EmpID` is empty on every
row — the list was never linked to the employee master.

| CheckTakenID | LastName | FirstName | EmpID | Flag | Status | GroupNumb |
|---|---|---|---|---|---|---|
| `1` | Nunley | Michael |  | B | 0 | 00 |
| `2` | Customer |  |  | C | 1 | 00 |
| `3` | Anazaldo | Lisette |  | B | 1 | 00 |
| `4` | Sarver | Danielle |  | B | 0 | 00 |
| `5` | Lopez | Liz |  | B | 1 | 00 |
| `6` | Ryan | Corey |  | B | 0 | 00 |
| `7` | Schacatano | Joe |  | B | 1 | 00 |
| `9` | Ramirez | Brenda |  | B | 0 | 00 |
| `10` | McNutt | Melissa |  | B | 1 | 00 |
| `11` | Staley | Wes |  | B | 1 | 00 |
| `12` | Staley | Michelle |  | B | 1 | 00 |
| `13` | Bustos | Mallorie |  | B | 0 | 00 |
| `14` | Faria | Greg |  | B | 0 | 00 |
| `15` | Hernandez | Armando |  | B | 0 | 00 |
| `16` | Otovic | Johnny |  | B | 0 | 00 |
| `17` | Oliver | John |  | B | 0 | 00 |
| `18` | Flores | Jason |  | B | 1 | 00 |
| `19` | Alexander | William |  | B | 0 | 00 |
| `20` | Deitrick | Joe |  | B | 1 | 00 |
| `21` | Snyder | Scott |  | B | 0 | 00 |
| `22` | Cellier | Brian |  | B | 1 | 00 |
| `23` | Camasto | Adam |  | B | 1 | 00 |
| `24` | Fenimore | Chris |  | B | 1 | 00 |
| `25` | Gutierrez | Leonardo |  | B | 1 | 00 |
| `26` | O'Neill | Taylor |  | B | 1 | 00 |
| `27` | Deitrick | David |  | B | 1 | 00 |
| `28` | Deitrick | Daivd |  | B | 0 | 00 |
| `29` | Petros | Brian |  | B | 1 | 00 |
| `30` | Masterson | Dylan |  | B | 1 | 00 |
| `31` | Harlow | Kyle |  | B | 1 | 00 |
| `32` | Adams | Ryan |  | B | 1 | 00 |

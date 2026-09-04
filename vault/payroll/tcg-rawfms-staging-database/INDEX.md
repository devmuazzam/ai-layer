---
title: TCG_RawFMS — the nightly staging copy of FCC NexGen that feeds the legacy payroll app (schema, ETL, run history, code)
source: shared-folder/Project-Repository-2026-09-04/3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL_APP_build/PayrollAPP_0.5/TCG_SQL_backup_2026-06-23.7z → TCG_RawFMS_20260623.bak (1.35 GB), restored into SQL Server 2025 on 2026-09-04 and catalogued read-only
migrated: 2026-09-04
updated: 2026-09-04
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, module/all, kind/reference, legacy-payroll-app, architecture, integrations, data-migration, reference-data, provenance]
part_of: payroll/INDEX.md
---

# TCG_RawFMS — the staging copy of FCC NexGen

**What this is.** `TCG_RawFMS` is the second database in the 2026-06-23 SQL backup the client
dropped beside the payroll app source. It is **not FCC's database** — it is a nightly,
table-by-table copy of **40 of FCC NexGen's tables**, pulled over a linked server into a
`stg` schema, that the legacy payroll app reads through its 40 `src.*` synonyms
([../legacy-payroll-app-db-extract/data/source-feed.md](../legacy-payroll-app-db-extract/data/source-feed.md)).
Until this backup was restored, the vault knew those tables only as column lists and three
masked sample rows each. Now it holds the real DDL, the ETL code that fills them, the run
history, and the full contents of the small reference tables.

**Why it matters for the ERP.** This is the only place in the repository where FCC's core
job / ticket / labour / customer / unit tables exist **with their real SQL Server types,
primary keys and row volumes** — the export workbooks under `2.1.1_DATA-MIGRATION` are
spreadsheets of the same tables. And the ETL is a working, tested pattern for reading FCC
incrementally by `ModifiedDate`, which is exactly what a migration or a parallel-run bridge
has to do.

**Where the copy lives.** The restored databases were catalogued and then dropped; the
`.7z` itself and a tab-delimited export of every table (82 files, 1.6 GB) are kept on
Haris's machine outside the deleted SharePoint drop
(`~/Desktop/Office Projects/haris_profile/TCG/tcg-project-repository-keep/`). **That export
contains employee SSNs, driver-licence numbers, dates of birth, home addresses and pay rates
(`stg.FMS_EMPLOYEES_Raw`) and customer federal tax IDs** — nothing from those columns is in
the vault, and the folder must be treated as confidential.

## Files in this folder

| File | What |
| --- | --- |
| [sql/](sql/) | All **98** programmable objects verbatim: 41 procedures (`etl.usp_RunNightly_RawFMS` + 40 `etl.usp_Refresh_*`), 1 scalar function (`dbo.fn_StripRTF`), 56 views (40 `api.v_FMS_*` pass-throughs, 8 `api.v_Base_*` and 8 `rpt.v_Base_*` flattened reporting views) |
| [ddl/](ddl/) | Column-level DDL for all **44** tables, with PK / index lines, generated from `sys.columns` |
| [data/fcc-ticket-status-matrix.md](data/fcc-ticket-status-matrix.md) | The 53-row status decoder, four ticket types |
| [data/fcc-job-status-type-and-department-codes.md](data/fcc-job-status-type-and-department-codes.md) | Job status (7), job type (11), department (10) |
| [data/fcc-craft-modifiers-full-master.md](data/fcc-craft-modifiers-full-master.md) | All 52 boom brackets and the Local 12 adders per bracket |
| [data/fcc-checklist-templates.md](data/fcc-checklist-templates.md) | Every question on every FCC checklist, by phase |
| [data/fcc-eticket-layout-tables.md](data/fcc-eticket-layout-tables.md) | E-ticket section / sub-section rows |
| [data/fcc-unittype-jobtype-allow-list.md](data/fcc-unittype-jobtype-allow-list.md) | Which unit types may be booked under which job types |
| [data/fcc-checked-taken-list.md](data/fcc-checked-taken-list.md) | The 31 "taken by / checked by" coordinator rows |

Reference tables **already printed elsewhere from newer (July 2026) exports** were not
duplicated: crafts, union craft rates, employee types, classifications, ethnicity
([fcc-employee-master-reference-data.md](../fcc-employee-master-reference-data.md)); units,
unit types, schedule types, unit-type details
([../../assets/fcc-units-and-schedule-types.md](../../assets/fcc-units-and-schedule-types.md));
industries, terms, sales persons
([../../customers/fcc-legacy-customer-data-model.md](../../customers/fcc-legacy-customer-data-model.md));
activity codes ([../../admin/fcc-activity-code-master-list.md](../../admin/fcc-activity-code-master-list.md)).
Their 2026-06-23 rows are in the kept TSV export if a point-in-time comparison is ever needed.

## The database at a glance

| | |
| --- | --- |
| Created | 2026-01-20 (database), compatibility level 170 (SQL Server 2025), collation `SQL_Latin1_General_CP1_CI_AS` |
| Backed up | 2026-06-23 02:00 server-local, full backup, 1.35 GB; data file 1.48 GB, log 1.82 GB, simple recovery |
| Schemas | `stg` (40 raw tables), `etl` (4 control tables), `api` (48 views), `rpt` (8 views), `dbo` (1 function) |
| Rows | 4,674,324 across 44 tables — 4.13 M of them are checklist answers (`FMS_JOB_UNIT_CHECK_LIST_Raw`) |
| Consumer | `TCG_PayrollAPP` via `etl.usp_RebuildSynonyms_RawFMS` → 40 synonyms `src.FMS_*_Raw` → `api.v_FMS_*` |

### Tables, row counts, column counts, primary key

Only nine `stg` tables have a primary key; the rest are heap reloads. `FMS_JOB_MASTER_Raw`
carries an extra computed `EffectiveModifiedUTC` and a supporting index; `FMS_JOB_TICKET_Raw`
has a covering index over every time-stamp column, which is what the payroll app's ticket
timeline reads.

| Table | Rows | Columns | Primary key |
| --- | ---: | ---: | --- |
| `etl.LoadWatermark` | 6 | 5 | TableName |
| `etl.RefreshStep` | 40 | 4 | StepOrder |
| `etl.RunLog` | 214 | 12 | RunId |
| `etl.RunLogDetail` | 7,494 | 11 | RunDetailId |
| `stg.FMS_ACTIVITIES_Raw` | 100 | 27 | ActivityCode |
| `stg.FMS_CHECKED_TAKEN_Raw` | 31 | 14 | — |
| `stg.FMS_CHECK_LIST_DETAILS_Raw` | 7,728 | 21 | — |
| `stg.FMS_CHECK_LIST_Raw` | 630 | 15 | — |
| `stg.FMS_CLASSIFICATIONS_Raw` | 24 | 12 | — |
| `stg.FMS_CRAFTS_Raw` | 74 | 23 | — |
| `stg.FMS_CRAFT_MODIFIER_Raw` | 52 | 10 | — |
| `stg.FMS_CUSTOMERS_Raw` | 6,057 | 103 | — |
| `stg.FMS_CUSTOMER_CONTACTS_Raw` | 9,546 | 28 | — |
| `stg.FMS_CUSTOMER_LOCATIONS_Raw` | 26,060 | 48 | — |
| `stg.FMS_CUSTOMER_NOTES_Raw` | 119 | 13 | — |
| `stg.FMS_DEPARTMENTS_Raw` | 10 | 18 | — |
| `stg.FMS_EMPLOYEES_Raw` | 242 | 129 | — |
| `stg.FMS_EMPLOYEE_TYPES_Raw` | 15 | 11 | — |
| `stg.FMS_ETHNICITY_Raw` | 7 | 10 | — |
| `stg.FMS_ETS_TICKET_SUB_SECTION_Raw` | 42 | 13 | — |
| `stg.FMS_INDUSTRIES_Raw` | 33 | 11 | — |
| `stg.FMS_JOB_CHECKLIST_Raw` | 55,438 | 9 | JobCode,CheckListID |
| `stg.FMS_JOB_EMPLOYEES_Raw` | 56,486 | 26 | — |
| `stg.FMS_JOB_MASTER_Raw` | 29,609 | 192 | JobCode |
| `stg.FMS_JOB_STATUS_Raw` | 7 | 8 | — |
| `stg.FMS_JOB_TICKET_EMP_UNIT_Raw` | 129,742 | 44 | — |
| `stg.FMS_JOB_TICKET_Raw` | 46,336 | 135 | JobTicketID |
| `stg.FMS_JOB_TYPES_Raw` | 11 | 10 | — |
| `stg.FMS_JOB_UNITS_Raw` | 76,312 | 64 | — |
| `stg.FMS_JOB_UNIT_CHECK_LIST_Raw` | 4,132,600 | 35 | JobUnitCheckListID |
| `stg.FMS_LABOR_PAYROLL_Raw` | 86,728 | 84 | LaborPayrollID |
| `stg.FMS_RESOURCE_CHECKLIST_ADHOC_Raw` | 1,237 | 17 | — |
| `stg.FMS_SALES_PERSON_Raw` | 32 | 23 | — |
| `stg.FMS_SCHEDULE_TYPES_Raw` | 25 | 14 | — |
| `stg.FMS_TERMS_Raw` | 12 | 18 | — |
| `stg.FMS_TICKET_SECTIONS_SUBLIST_Raw` | 21 | 10 | — |
| `stg.FMS_TICKET_STATUS_Raw` | 53 | 15 | — |
| `stg.FMS_UNION_CRAFT_MODIFIER_Raw` | 52 | 15 | UnionCraftModifierID |
| `stg.FMS_UNION_CRAFT_Raw` | 53 | 14 | UnioncraftID |
| `stg.FMS_UNITS_Raw` | 356 | 158 | — |
| `stg.FMS_UNITTYPE_JOBTYPES_Raw` | 42 | 9 | — |
| `stg.FMS_UNIT_CHECK_LIST_Raw` | 14 | 10 | — |
| `stg.FMS_UNIT_TYPES_Raw` | 71 | 17 | — |
| `stg.FMS_UNIT_TYPE_DETAILS_Raw` | 563 | 13 | — |

## How the copy is refreshed

**Linked server.** Every refresh procedure reads FCC through `OPENQUERY([FCC_NexGen], '…')`
against `NexGenFMS.dbo.FMS_*` with an **explicit column list** built from the `stg` table's
own `sys.columns` (never `SELECT *`), so a column FCC adds is ignored until someone adds it to
the staging table. The linked-server name and target database are in the code; the host,
login and mapping are not (they live in the server's linked-server definition, which the
backup does not contain).

**Two strategies, chosen per table** (`etl.RefreshStep`, 40 rows, all enabled):

| Strategy | Tables | How |
| --- | --- | --- |
| **Full** (34) | every lookup, customers, contacts, locations, notes, employees, job employees, job units, units, checklists | pull into `#SourceData`, `TRUNCATE` the `stg` table inside a transaction, `INSERT … WITH (TABLOCK)`, report `@RowsLoaded` |
| **Incremental** (6) | `FMS_JOB_CHECKLIST`, `FMS_JOB_MASTER`, `FMS_JOB_TICKET`, `FMS_JOB_TICKET_EMP_UNIT`, `FMS_JOB_UNIT_CHECK_LIST`, `FMS_LABOR_PAYROLL` | read `etl.LoadWatermark`, subtract a **5-second overlap**, pull rows with `ModifiedDate >` watermark (`COALESCE(ModifiedDate, CreatedDate)` for job checklists), **dedupe to the latest row per key**, `UPDATE` only where the incoming `ModifiedDate` is newer, `INSERT` where the key is absent, then advance the watermark **after** the commit. `FMS_JOB_MASTER` is pulled in 7-day chunks ("vendor-safe batching"). |

Every procedure takes an exclusive application lock on its own name (`sp_getapplock`, zero
timeout) and throws if another run holds it; the nightly runner takes one too, and logs a
`Skipped` run instead of waiting. The runner
([sql/etl.usp_RunNightly_RawFMS.PROC.sql](sql/etl.usp_RunNightly_RawFMS.PROC.sql)) executes as
owner, iterates its own hard-coded 40-step manifest (identical to `etl.RefreshStep`), and
writes one `etl.RunLogDetail` row per step with `rows=`, `delta=`/`loaded=` and `durSec=` in
`Notes`. A failing step marks the run `Failed` and re-throws, so a later step never runs
against a half-refreshed earlier one.

**Watermarks at backup time** (`etl.LoadWatermark`): all six incremental tables had last
run on 2026-06-23 08:00–08:02 UTC with watermarks between 2026-06-22 20:30 and 2026-06-23
03:31 — FCC's `ModifiedDate` is server-local time, the watermark column is named UTC, and the
5-second overlap is what papers over that.

## Run history — 2026-02-02 to 2026-06-23

| | |
| --- | --- |
| Runs logged | 214 (`etl.RunLog`), 7,494 step rows |
| Schedule | once a night at **01:00 server-local / 08:00 UTC**, invoked by `SQLCMD` under the developer's Azure AD login; ad-hoc runs from SSMS and from the payroll API's *Refresh from NexGen* button appear in between |
| Outcome | 171 `Succeeded`, 22 `Success` (the 2026-02-02 build day, before the status spelling settled), 8 `Failed`, 13 left `Running` (interrupted, never closed) |
| Duration | mean 179 s. Heaviest steps: `JOB_UNITS` full 48 s, `JOB_EMPLOYEES` full 31 s, `JOB_TICKET` incremental 22 s, `CUSTOMER_LOCATIONS` full 19 s; everything else under 8 s |
| Failures | 2026-02-02 ×4 (syntax and a missing `RunLogID` column — build-day bugs); 2026-05-11 ×4 — *"Access to the remote server is denied because no login-mapping exists"* then *"Cannot find the object FMS_ACTIVITIES_Raw"*, the afternoon the API login was being wired to trigger the refresh (the PayrollAPP side of that story is in [../legacy-payroll-app-db-backup-2026-06-23.md](../legacy-payroll-app-db-backup-2026-06-23.md)) |

The **largest incremental delta ever logged** was 3,904,980 rows for `FMS_JOB_UNIT_CHECK_LIST`
(the initial seed); steady-state nightly deltas are in the hundreds.

## The views

- **`api.v_FMS_*` (40)** — one per staging table, `SELECT` of every column, no logic. These are
  what the payroll app's synonyms point at, so the app never touches `stg` directly.
- **`api.v_Base_*` and `rpt.v_Base_*` (8 + 8)** — flattened reporting views over customers,
  contacts, locations, notes, employees, job master, job ticket and labor payroll: codes joined
  to their descriptions, `Status` bits rendered as *Active/Inactive*, RTF note fields cleaned
  through `dbo.fn_StripRTF`, sales-person names concatenated. The `rpt` copies were created
  in `dbo` and moved by `ALTER SCHEMA` (their bodies still say `CREATE VIEW [dbo].…`). They are
  the closest thing FCC has to a documented customer / job / ticket read model and are worth
  reading before designing the migration's extract queries —
  [sql/rpt.v_Base_JobTicket.VIEW.sql](sql/rpt.v_Base_JobTicket.VIEW.sql),
  [sql/rpt.v_Base_LaborPayroll.VIEW.sql](sql/rpt.v_Base_LaborPayroll.VIEW.sql).
- **`dbo.fn_StripRTF`** — the same RTF-stripping function the payroll app carries as
  `app.fn_StripRTF`; FCC stores several note and direction fields as RTF.

## What this changes in the vault

- FCC's **ticket status is a matrix, not a column** — see the data page; the dispatch and
  service guides describe the result, the table is the rule.
- FCC's checklists were **copied per unit**, not referenced — 630 checklist rows for 14
  checklist kinds. Any "how many checklists does TCG have" answer depends on which count you
  mean.
- The **incremental-by-ModifiedDate pattern works against FCC** and has run nightly for five
  months without a data failure; the failures on record are all permission plumbing.
- The full 52-bracket **craft-modifier master** with OT/DT adders is now on record; the payroll
  extract's 33 are the subset in use.

## Restoring it again

```bash
# SQL Server 2025 is required — the backups are database version 998 (2022 refuses them)
docker run -d --platform linux/amd64 --name tcgsql -e ACCEPT_EULA=Y \
  -e MSSQL_SA_PASSWORD='<choose>' -e MSSQL_PID=Developer \
  -v "<folder with the .bak files>:/bak:ro" -p 14333:1433 mcr.microsoft.com/mssql/server:2025-latest
# then, in sqlcmd:
RESTORE DATABASE TCG_RawFMS FROM DISK='/bak/TCG_RawFMS_20260623.bak'
  WITH MOVE 'TCG_RawFMS' TO '/var/opt/mssql/data/TCG_RawFMS.mdf',
       MOVE 'TCG_RawFMS_log' TO '/var/opt/mssql/data/TCG_RawFMS_log.ldf';
```

Restore takes about 20 seconds on a laptop under emulation.

## Source

`3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL_APP_build/PayrollAPP_0.5/TCG_SQL_backup_2026-06-23.7z`
(172 MB) → `TCG_RawFMS_20260623.bak`. Header: backup taken 2026-06-23 02:00:01–02:00:03 by
`NT AUTHORITY\SYSTEM` on the client's SQL Server 2025 instance (build 17.0.1115). Catalogued
2026-09-04 from `sys.tables`, `sys.columns`, `sys.indexes`, `sys.foreign_keys`,
`sys.sql_modules`, `etl.RefreshStep`, `etl.LoadWatermark`, `etl.RunLog`, `etl.RunLogDetail`.
Read-only; nothing that writes was executed. Sibling database in the same archive:
[../legacy-payroll-app-db-backup-2026-06-23.md](../legacy-payroll-app-db-backup-2026-06-23.md).

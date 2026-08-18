---
title: Legacy Payroll App - SQL Agent enumeration (Express: no usable Agent, one system job)
source: user-supplied/PAYROLL_CALC_EXTRACT.zip (generated 2026-08-18 on the client machine from TCG_PayrollAPP + c:/projects/tcg-payroll-api)
migrated: 2026-08-18
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
topics: [payroll, legacy-payroll-app, scheduling]
entities: [nightly-run]
part_of: payroll/legacy-payroll-app-db-extract/INDEX.md
---

> Part of the 2026-08-18 read-only extract of the live legacy database `TCG_PayrollAPP`
> (`localhost\SQLEXPRESS`, SQL Server 2025 Express). Line anchors like `sql\app\x.PROC.sql:12-20`
> refer to the verbatim definitions in [sql/](sql/) (backslashes → forward slashes). Employee
> identifiers are masked `E***NN`. Nothing that writes was executed to produce this.

# SQL Agent Jobs (read-only enumeration)

**Instance:** `localhost\SQLEXPRESS` — **Express Edition (64-bit), product version 17.0.1000.7,
EngineEdition = 4 (Express)**. **SQL Server Agent service status = Stopped.**

## Key finding: no payroll SQL Agent jobs exist / Agent is not usable on this instance

SQL Server **Express Edition does not include a usable SQL Server Agent** — the scheduler service is present
in the catalog but is **Stopped** and cannot be started to run scheduled jobs on Express. Enumerating
`msdb.dbo.sysjobs` returned exactly **one** job, and it is the built-in system-maintenance job that ships with
every SQL Server install — **not** a payroll job:

| # | job_id | name | enabled | description |
|---|---|---|---|---|
| 1 | 7b697811-19ea-4ccf-a708-e011e4f749a6 | `syspolicy_purge_history` | 1 (enabled) | No description available. |

There are **no** jobs referencing `etl.usp_RunNightly_PayrollAPP`, `TCG_RawFMS.etl.usp_RunNightly_RawFMS`,
`api.usp_UI_RefreshPayroll_FromNexGen`, `app.usp_ProcessPayroll_PayPeriod`, or any other payroll object.
**Payroll orchestration is NOT driven by SQL Agent on this instance.**

### How scheduling is actually driven (inference)

Because SQL Agent is unavailable on Express and no payroll job is defined, the nightly run
(`etl.usp_RunNightly_PayrollAPP`) must be launched by an **external mechanism**, most likely:

- **Windows Task Scheduler** (or a similar external scheduler) invoking `sqlcmd`/PowerShell that calls
  `EXEC etl.usp_RunNightly_PayrollAPP`, and/or
- the **application / UI** itself calling `api.usp_UI_RefreshPayroll_FromNexGen` on demand (the "Refresh"
  button), which internally chains the raw pull + the full recalc.

The procs themselves are built to tolerate being triggered ad hoc / concurrently: each takes an exclusive
`sp_getapplock` (session-scoped, `@LockTimeout=0`) so an overlapping trigger is safely **Skipped** rather than
run twice. See `parts/B12_orchestration.md` sections (b) and (c). No Windows Task Scheduler task list was
inspected as part of this read-only DB enumeration (out of scope; would require `schtasks`/`Get-ScheduledTask`).

---

## Job detail: `syspolicy_purge_history` (system job, not payroll)

Built-in job that purges Policy-Based-Management health/history records. Included here only for completeness.

**Schedule** — from `msdb.dbo.sysschedules` (`syspolicy_purge_history_schedule`, enabled):
`freq_type=4` (**daily**), `freq_interval=1` (**every 1 day**), `freq_subday_type=1` (**once, at the start
time**), `active_start_time=20000` -> **02:00:00**. Plain English: **runs once daily at 02:00 AM** — but note
this will not actually fire because the **Agent service is Stopped** on this Express instance.

**Steps** — from `msdb.dbo.sysjobsteps` (no passwords/tokens present; nothing masked):

| step_id | step_name | subsystem | target DB | command |
|---|---|---|---|---|
| 1 | Verify that automation is enabled. | TSQL | master | see below |
| 2 | Purge history. | TSQL | master | see below |
| 3 | Erase Phantom System Health Records. | PowerShell | master | see below |

Step 1 command:

```sql
EXECUTE AS LOGIN = '##MS_PolicyTsqlExecutionLogin##' WITH NO REVERT;
        IF (msdb.dbo.fn_syspolicy_is_automation_enabled() != 1)
        BEGIN
            RAISERROR(34022, 16, 1)
        END
```

Step 2 command:

```sql
EXECUTE AS LOGIN = '##MS_PolicyTsqlExecutionLogin##' WITH NO REVERT;
        EXEC msdb.dbo.sp_syspolicy_purge_history
```

Step 3 command (PowerShell subsystem):

```powershell
$SQLServerConnection = New-Object System.Data.SqlClient.SqlConnection
$SQLServerConnection.ConnectionString = "Data Source=$(ESCAPE_NONE(SRVR));Initial Catalog=master;Integrated Security=SSPI;Application Name=syspolicy_purge_history"
$PolicyStoreConnection = New-Object Microsoft.SqlServer.Management.Sdk.Sfc.SqlStoreConnection($SQLServerConnection)
$PolicyStore = New-Object Microsoft.SqlServer.Management.Dmf.PolicyStore ($PolicyStoreConnection)
$PolicyStore.EraseSystemHealthPhantomRecords()
```

(The connection string uses `Integrated Security=SSPI` — no password or token to mask.)

---

## Queries used (read-only)

```sql
SELECT j.job_id, j.name, j.enabled, j.description FROM msdb.dbo.sysjobs j ORDER BY j.name;
SELECT step_id, step_name, subsystem, database_name, command FROM msdb.dbo.sysjobsteps WHERE job_id=... ORDER BY step_id;
SELECT sch.freq_type, sch.freq_interval, sch.freq_subday_type, sch.active_start_time
  FROM msdb.dbo.sysjobschedules js
  JOIN msdb.dbo.sysschedules sch ON sch.schedule_id = js.schedule_id
 WHERE js.job_id = ...;
SELECT SERVERPROPERTY('Edition'), SERVERPROPERTY('ProductVersion'), SERVERPROPERTY('EngineEdition');
SELECT status_desc FROM sys.dm_server_services WHERE servicename LIKE '%Agent%';
```

---
title: Legacy Payroll App — the 2026-06-23 database backup, restored and compared with the 2026-08-18 extract
source: shared-folder/Project-Repository-2026-09-04/3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL_APP_build/PayrollAPP_0.5/TCG_SQL_backup_2026-06-23.7z → TCG_PayrollAPP_20260623.bak (502 MB), restored into SQL Server 2025 on 2026-09-04 and catalogued read-only
migrated: 2026-09-04
updated: 2026-09-04
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app, architecture, provenance, time-tracking]
part_of: payroll/INDEX.md
---

# Legacy Payroll App — the 2026-06-23 database backup

**Short version.** The `.bak` in the SharePoint drop is a full backup of `TCG_PayrollAPP`
taken 2026-06-23. Its **code is byte-for-byte the code the vault already holds** from the
2026-08-18 live extract
([legacy-payroll-app-db-extract/INDEX.md](legacy-payroll-app-db-extract/INDEX.md)): the same
141 programmable objects, same 38 tables, same 40 synonyms, and every definition compares
identical after whitespace normalisation. So the extract stays the document of record for
*how pay is calculated*. What the backup adds is **data and operating history** — the pay
periods, the nightly run log, and the log of the *Refresh from NexGen* button — which is
what this page records. Its sibling database, `TCG_RawFMS`, was new to the vault and has its
own folder: [tcg-rawfms-staging-database/INDEX.md](tcg-rawfms-staging-database/INDEX.md).

## The database

| | |
| --- | --- |
| Created | 2026-02-02 01:02, compatibility level 130, collation `SQL_Latin1_General_CP1_CI_AS`, simple recovery |
| Backed up | 2026-06-23 02:00 server-local, 502 MB; data file 545 MB, log 880 MB |
| Objects | 38 tables, 61 procedures, 67 views, 10 table-valued functions, 3 scalar functions, 40 synonyms — identical set and bodies to the 2026-08-18 extract |
| Most recent code change | `app.usp_FinalizePayrollOutputs_AfterPricing` and the CA non-union OT procedures, 2026-06-09 |

### Row counts on 2026-06-23

| Table | Rows |
| --- | ---: |
| `fms.Payroll_CalcException` | 508,327 |
| `fms.Payroll_PayComponent` | 136,794 |
| `fms.Payroll_Calculated` | 86,441 |
| `app._Backup_51K_Payroll_Calculated_PreSourceRateOnly` | 83,854 |
| `fms.Labor_PreProcessed` | 58,059 |
| `calc.TicketTimeline` | 28,799 |
| `dim.Date` | 7,671 |
| `fms.Payroll_GuaranteeGroup` / `_GuaranteeAllocation` | 4,758 / 4,758 |
| `app.PayrollSnapshot_Detail` | 1,713 |
| `etl.RunLogDetail` / `etl.RunLog` | 921 / 607 |
| `app.EmployeeExternalIdentifier` | 108 |
| `dim.LU12_Holiday` | 44 |
| `cfg.Craft_MinimumPayPolicy` | 39 |
| `etl.UIRefreshLog` | 33 |
| `app.PayPeriod` | 32 |
| `test.Case_CorePayrollScenario` | 16 |
| `cfg.WTL_MaxMealThreshold` | 5 |
| `app.PayrollSnapshot` | 5 |
| every other `cfg.*` / `test.*` / note table | 0–6 |

Six exceptions for every calculated row is the ratio to remember when sizing an exception
UI — 508 K exceptions against 86 K priced labour rows.

## Pay periods — 32 rows, 2 processed

`app.PayPeriod` holds Saturday–Friday weeks from 2025-08-30 to 2026-06-26. IDs are not in date
order (period 13 is November, period 2 is February), consistent with periods being created
on demand by `api.usp_EnsurePayPeriod_ForDate` as someone opened a week. Only two are
`Processed`, both on 2026-02-24 during API smoke testing — period 2 (2026-02-14 → 02-20) and
period 1, which runs **Sunday 2026-02-15 → Saturday 02-21**, the one non-Sat–Fri row and
carries the note *"hello from API"*. All five `app.PayrollSnapshot` rows are from the same
afternoon (two by `test`, three by the developer). **No production pay period was ever
processed through the app** as of the backup; every week is `Open`.

`cfg.Nightly_RunSettings`: `LookbackDays = 210`, `UseYesterdayAsToDate = 1`, last changed
2026-05-11 — the nightly recalculates the trailing 30 weeks.

## The nightly — 607 runs

`etl.RunLog` records pairs of `NightlyPayroll` and `PricingEngine` runs every night from
2026-02-02 to 2026-06-23, starting at **08:02 UTC, immediately after `TCG_RawFMS` finishes its
own nightly at 08:00** (same `SQLCMD` job, same login). A nightly payroll run takes about
50 seconds; the pricing engine about 7.

## The *Refresh from NexGen* button — `etl.UIRefreshLog`, 33 rows

The payroll UI can trigger `api.usp_UI_RefreshPayroll_FromNexGen`, which runs the RawFMS
nightly and then the payroll nightly for the week containing a chosen date and logs both run
IDs. The log is a compact history of getting that to work:

| When | What |
| --- | --- |
| 2026-05-11 03:35 | First success from SSMS under the developer's login |
| 2026-05-11 04:16 – 06:07 | Nine failed attempts from the API login, one permission at a time: `SELECT` denied on `TCG_RawFMS.etl.RunLog` → *no login-mapping on the linked server* → *Cannot find FMS_ACTIVITIES_Raw* (after recreating the linked server) → `CREATE SYNONYM` denied → *sa is not able to access TCG_RawFMS* |
| 2026-05-11 18:39 | Success "after PayrollAPP trustworthy on" — i.e. `EXECUTE AS OWNER` plus `TRUSTWORTHY ON` on the database, which is how the API login now reaches the linked server |
| 2026-05-12 → 06-09 | Routine use from the Payroll UI; a refresh takes **3–3.5 minutes**; a second click while one runs is logged `Skipped` ("Another Payroll UI refresh is already running") |
| 2026-05-25/26 | Four runs labelled *WTL integration test*, *WTL valid/invalid FCC token test* — the work-through-lunch comment-token feature being verified end to end |
| 2026-06-09 | *Non-union hourly integration test* — the CA non-union admin OT feature |

The permission chain is worth knowing before anyone reproduces the app: the API login
(`User_Payroll_API`) has no direct rights on `TCG_RawFMS`; everything runs as the database
owner through a trustworthy database.

## Where the backup is kept

The SharePoint drop is being deleted. The `.7z` (172 MB) and a tab-delimited export of every
table in both databases (82 files, 1.6 GB) are on Haris's machine at
`~/Desktop/Office Projects/haris_profile/TCG/tcg-project-repository-keep/`. The export is
**confidential**: `stg.FMS_EMPLOYEES_Raw` in the RawFMS half carries SSNs, driver-licence
numbers, dates of birth and pay rates, and the payroll tables carry per-employee pay. None of
that is in the vault.

## Restoring it

Same recipe as the RawFMS page
([tcg-rawfms-staging-database/INDEX.md](tcg-rawfms-staging-database/INDEX.md) → *Restoring it
again*); logical file names `TCG_PayrollAPP` and `TCG_PayrollAPP_log`. **SQL Server 2025 is
required** — the backup header says database version 998 and a 2022 instance refuses it.
Restore takes under ten seconds.

## Source

`3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL_APP_build/PayrollAPP_0.5/TCG_SQL_backup_2026-06-23.7z`
→ `TCG_PayrollAPP_20260623.bak`; header read with `RESTORE HEADERONLY`, catalogued 2026-09-04
from `sys.*`, `app.PayPeriod`, `app.PayrollSnapshot`, `cfg.Nightly_RunSettings`, `etl.RunLog`,
`etl.UIRefreshLog`. Read-only. Definitions compared line-by-line (blank lines and trailing
whitespace ignored) against
[legacy-payroll-app-db-extract/sql/](legacy-payroll-app-db-extract/sql/) — 141 of 141 identical.

---
title: TCG Payroll App (legacy) - Architecture and data flow
source: onedrive/OneDrive_1_8-11-2026/PAYROLL_APP_build/PayrollAPP_0.5/TCG_PayrollAPP_AI_Knowledge_Pack_2026-06-23.zip#04_ARCHITECTURE_AND_DATA_FLOW.md
migrated: 2026-08-13
updated: 2026-06-23
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app, architecture]
entities: [tcg-rawfms, tcg-payrollapp, pricing-engine, pay-component]
part_of: payroll/payroll-app-current-state/INDEX.md
---

## Architecture principle

The TCG Payroll App is SQL-first. SQL Server owns payroll calculation, rule configuration, ledger generation, exception generation, and audit surfaces. The API and Web UI should not silently duplicate payroll logic that already exists in SQL.

## System components

```text
+----------------------+       +-------------------------+
|  TCG_RawFMS          |       |  External FCC/NexGen    |
|  source database     | <---- |  source data pipeline   |
+----------+-----------+       +-------------------------+
           |
           | source views in TCG_RawFMS.api
           v
+----------+-----------+
| TCG_PayrollAPP.src   |
| synonyms             |
+----------+-----------+
           |
           v
+----------+-----------+
| app/calc/fms/cfg/dim |
| payroll SQL engine   |
+----------+-----------+
           |
           v
+----------+-----------+
| api/rpt SQL surface  |
+----------+-----------+
           |
           v
+----------+-----------+       +-------------------------+
| C# API               | ----> | Next.js Payroll UI      |
+----------------------+       +-------------------------+
```

## Database roles

### `TCG_RawFMS`

Raw/source FCC/FMS-style data warehouse. The Payroll App should treat it as source data. The Payroll App should not write payroll results back into `TCG_RawFMS`.

Important source objects are exposed through `TCG_RawFMS.api.*` views.

### `TCG_PayrollAPP`

Payroll application database. It includes:

- source synonyms
- base normalized views
- configuration/rule tables
- calculation procedures
- pay component ledger
- review/exception tables
- API-facing views/procedures
- reporting views
- tests
- pay-period close/snapshot tables

## Main schemas in `TCG_PayrollAPP`

| Schema | Role |
|---|---|
| `src` | Synonyms to `TCG_RawFMS.api.*` source views. |
| `app` | Application tables, base views, main procedures, pay-period/notes/snapshot logic. |
| `calc` | Timeline, ticket, slice, and calculation helper objects. |
| `fms` | Persisted calculation, ledger, guarantee, exception tables. |
| `cfg` | Configuration tables for rules and policies. |
| `dim` | Calendar and holiday dimensions. |
| `api` | Stable SQL surface for C# API/UI consumers. |
| `rpt` | Reporting and issue-summary views. |
| `etl` | Refresh orchestration and run logs. |
| `test` | Regression test tables/procedures. |

## Primary data flow

### 1. Source data exposure

`TCG_RawFMS.api.*` views expose raw FMS data such as labor payroll, employees, job tickets, crafts, classifications, units, union craft rates, and modifiers.

### 2. Synonym layer

`TCG_PayrollAPP.src.*` synonyms point to RawFMS API views. Example:

```text
src.FMS_LABOR_PAYROLL_Raw -> [TCG_RawFMS].[api].[v_FMS_LABOR_PAYROLL]
src.FMS_EMPLOYEES_Raw -> [TCG_RawFMS].[api].[v_FMS_EMPLOYEES]
src.FMS_JOB_TICKET_Raw -> [TCG_RawFMS].[api].[v_FMS_JOB_TICKET]
```

### 3. Base enrichment

`app.v_Base_LaborPayroll` joins labor, employee, craft, modifier, classification, ticket, and other reference data into a stable base view.

`app.v_Base_Employees` enriches employee master data used by worklist, payroll group/rate surfaces, and employee-level review.

### 4. Pricing and finalization

The main actual-work pricing procedure is:

```sql
app.usp_Run_Pricing_Engine
```

The current post-pricing wrapper is:

```sql
app.usp_FinalizePayrollOutputs_AfterPricing
```

### 5. Ledger and audit

Calculated gross and supporting data are stored in:

```sql
fms.Payroll_Calculated
```

Explainable pay components are stored in:

```sql
fms.Payroll_PayComponent
```

Warnings/errors/review issues are stored in:

```sql
fms.Payroll_CalcException
```

### 6. API/UI surface

The C# API and UI should consume stable SQL surfaces under `api` and `rpt`, not internal temp or helper objects.

Important pattern:

```text
SQL api/rpt object -> C# API endpoint -> Next.js UI card/table
```

## Current Web UI flow

The primary user workflow is:

1. User logs in to Web UI.
2. User opens `/worklist`.
3. Worklist loads pay-period employee rows, issue counts, Payroll Group, ADP File Number, and review flags.
4. User opens `/worklist/employee/[empID]`.
5. Employee detail page loads week/day summaries, labor entries, selected labor entry detail, ledger, WTL, guarantee, rest, rate, boom, ticket, and notes surfaces.

## Operational refresh flow

Browser-triggered refresh:

```sql
api.usp_UI_RefreshPayroll_FromNexGen
```

This refreshes raw/source data and runs PayrollAPP recalculation for the relevant pay period when permitted.

Nightly/manual PayrollAPP refresh:

```sql
etl.usp_RunNightly_PayrollAPP
```

Pay-period close/snapshot:

```sql
app.usp_ProcessPayroll_PayPeriod
```

---

> **Production-hosting reality (client statement, 2026-08-24 batch):** the *entire* legacy
> payroll production stack — SQL Express instance, both databases, the API, the web apps,
> automated scheduling (Windows Task Scheduler), backups, security and firewall — runs on
> **Brian's desktop work computer**, all free-tier software. Proper hosting is gated on TCG
> IT ("someday, maybe, Patrick will provide the ability to run custom apps in a normal way").
> Two consequences: (1) any **parallel-run** period depends on a single unmanaged desktop —
> treat as a fragile dependency with an explicit backup/availability ask; (2) the ERP should
> carry **no on-prem custom-app dependency**, or it inherits the same gate.

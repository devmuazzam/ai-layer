---
title: Legacy Payroll App — source tree of the 2026-06-10 backup
source: shared-folder/Project-Repository-2026-09-04/3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL_APP_build/PayrollAPP_0.5/TCG - backup - 2026-06-10_L12andNU.7z
migrated: 2026-09-04
updated: 2026-06-10
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app, permissions-roles, integrations, architecture]
entities: []
part_of: payroll/INDEX.md
---

# Legacy Payroll App — source tree of the 2026-06-10 backup

**What this is.** The `.7z` application backup that ships inside the payroll folder was recorded
on 2026-08-13 as *"Binaries and environment setup — not migrated"* without being opened. On
2026-09-04 it was opened. It is not binaries: it is the **full source** of the legacy Payroll App
as of **10 June 2026** — a .NET 9 minimal API and a Next.js UI — plus their build output,
`node_modules`, and the UI's git repository. This page records what is in it and how it relates
to the code the vault already describes, so nobody has to open a 99 MB archive to find out.

**Relation to what the vault already holds.** `Program.cs` in this backup is **2,296 lines** —
the same length the vault's [legacy-payroll-app-code-extract.md](legacy-payroll-app-code-extract.md)
records for the `projects.rar` copy received 2026-08-13 (files dated to July 2026). The rules that
page extracts therefore apply to this snapshot too. The API and UI *surface* below is otherwise
documented by the knowledge pack's contract guide,
[payroll-app-current-state/05-api-and-ui-contract.md](payroll-app-current-state/05-api-and-ui-contract.md),
which names 12 of the 15 API endpoints; the three it does not name are marked ⚑ below.

## Layout

```
TCG - backup - 2026-06-10_L12andNU/
  TCG.PayrollApi/TCG.PayrollApi/      .NET 9 minimal API — Program.cs (2,296 lines), csproj,
                                      appsettings*.json, launchSettings.json, bin/, obj/
  TCG.PayrollWeb/payroll-ui/          Next.js app — app/, components/, lib/, middleware.ts,
                                      types/, scripts/, public/, certificates/, .git/, .next/,
                                      node_modules/
```

The UI's git history has **one commit** — `5b5dd88 · 2026-03-03 · Initial commit from Create
Next App`. Every subsequent change was made without a commit; the history carries no information
about how the app evolved.

## Stack

| Tier | What | Evidence |
| --- | --- | --- |
| API | .NET 9 (`net9.0`), nullable + implicit usings, **one** package: `Microsoft.Data.SqlClient 6.1.4` | `TCG.PayrollApi.csproj` |
| API pattern | Single-file minimal API; every endpoint opens a `SqlConnection` and calls a stored procedure or ad-hoc SQL directly — no ORM, no service layer | `Program.cs` |
| UI | Next.js (App Router), React; dependencies `next`, `react`, `react-dom`, **`bcryptjs`**, **`jose`** — nothing else | `package.json` (`payroll-ui 0.1.0`) |
| UI auth | Cookie session signed with `jose`; password hashes via `bcryptjs`; a `scripts/hash-password.mjs` helper for minting users | `lib/auth/session.ts`, `lib/auth/password.ts` |
| Local TLS | Self-signed `localhost.pem` / `localhost-key.pem` checked into `certificates/` | present in the archive |

## API endpoints — `Program.cs`

Every endpoint except `/health` first calls `IsAuthorized(req)` and returns `401` otherwise.

| Method | Route | What it does | In the contract guide? |
| --- | --- | --- | --- |
| GET | `/health` | `{ ok, utc, env }` — no auth | ⚑ no |
| GET | `/payperiod/ensure?anyDateInWeek=YYYY-MM-DD` | Calls `api.usp_EnsurePayPeriod_ForDate` and returns the pay-period row for the week containing that date, creating it if absent | ⚑ no |
| GET | `/worklist` | The pay-period worklist | yes |
| GET | `/employee-day-totals` | Per-day totals for one employee | yes |
| GET | `/employee-week-daily-summary` | Week view, one row per day | yes |
| GET | `/employee-week-guarantees` | Guaranteed-hours evaluation for the week | yes |
| GET | `/employee-week-pay-components` | Pay components for the week | yes |
| GET | `/labor-entry-audit` | Audit trail for a labor entry | yes |
| GET | `/labor-entry-ledger` | Ledger lines for a labor entry | yes |
| GET | `/labor-entry-week-detail` | Week-level labor-entry detail | yes |
| GET | `/rest-period-slice-detail` | 8-hour-rest slice detail | yes |
| POST | `/employee-external-identifier` | Sets an employee's external (ADP) identifier | yes |
| POST | `/notes/bulk` | In one transaction: an optional pay-period note plus a batch of per-employee pay-period notes (`PeriodStartDate`, `PayPeriodNote`, `EmployeeNotes[]`, `CreatedBy`) | ⚑ no |
| POST | `/payroll/process` | Calls `app.usp_ProcessPayroll_PayPeriod(@PeriodStartDate, @ProcessedBy, @SnapshotNote)` with **no command timeout** — the run of the whole pricing engine for a period | named in the code-extract page, not the contract guide |
| POST | `/payroll/refresh-from-nexgen` | Re-pulls labor from the NexGen source feed | yes |

## UI — `payroll-ui/app`

**Pages:** `/` · `/login` · `/worklist` · `/worklist/employee/[empID]` (with `GuaranteedHoursCard`
and `RestPeriodSliceDetailCard` components) · `/payrollWeek`.

**Server routes (`app/api/…`)** — a one-to-one proxy of the API above, plus `auth/login`,
`auth/logout`, `auth/me`. There is no UI route for `/payroll/process`, `/notes/bulk`,
`/payperiod/ensure` or `/health` in this snapshot.

## Roles and permissions — `lib/auth/roles.ts` + `middleware.ts`

Three roles, four permissions. This is the only place in the vault the legacy app's
authorisation model is written down.

| Permission | `payroll_team` | `payroll_manager` | `it_admin` |
| --- | :---: | :---: | :---: |
| `canReadPayroll` | ✓ | ✓ | ✓ |
| `canEditPayrollNotes` | — | ✓ | ✓ |
| `canRefreshFromNexGen` | — | ✓ | ✓ |
| `canUseAdminDiagnostics` | — | — | ✓ |

`middleware.ts` maps every path to one of those permission sets and redirects unauthenticated
requests to `/login`; `/login`, the two auth routes and static assets are public. The three
avatar images in `public/avatars/` (`itadmin`, `payrollmanager`, `payrollteam`) are the same
three roles.

## Secrets present in the archive — deliberately not copied

`appsettings.json` carries a SQL Server connection string; `payroll-ui/.env.local` carries the
session secret and API base URL; `certificates/` carries a private key. **None of it is
reproduced here.** The archive sits in a shared SharePoint folder — treat those as exposed.

## Not migrated from the archive, and why

`bin/`, `obj/`, `.next/`, `node_modules/` (build output and dependencies — regenerable);
`.git/objects` (one commit, nothing to recover); `public/*.svg`, favicon, branding PNGs.

## Source

`3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL_APP_build/PayrollAPP_0.5/TCG - backup - 2026-06-10_L12andNU.7z`
— 99 MB, 23,555 entries, extracted with `unar`; 63 source files remain after pruning build output.
`Program.cs` read for endpoint names and the three endpoints the contract guide omits;
`roles.ts` and `middleware.ts` read in full; `package.json`, `csproj`, `README.md` read in full.
The sibling `TCG_SQL_backup_2026-06-23.7z` holds two SQL Server `.bak` files
(`TCG_PayrollAPP_20260623.bak`, `TCG_RawFMS_20260623.bak`) — a database backup that cannot be
read without SQL Server; its content is what
[legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md) already documents from
the 2026-08-18 read-only extract.

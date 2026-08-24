---
title: Legacy Payroll App - what leaves the system: the 15 API endpoints (JSON only) and the ADP hand-off search
source: user-supplied/PAYROLL_CALC_EXTRACT.zip (generated 2026-08-18 on the client machine from TCG_PayrollAPP + c:/projects/tcg-payroll-api)
migrated: 2026-08-18
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app, integrations, adp]
entities: [api-endpoint, adp-export]
part_of: payroll/legacy-payroll-app-db-extract/INDEX.md
---

> Part of the 2026-08-18 read-only extract of the live legacy database `TCG_PayrollAPP`
> (`localhost\SQLEXPRESS`, SQL Server 2025 Express). Line anchors like `sql\app\x.PROC.sql:12-20`
> refer to the verbatim definitions in [sql/](sql/) (backslashes → forward slashes). Employee
> identifiers are masked `E***NN`. Nothing that writes was executed to produce this.

# OUTPUTS (Part C)

Scope: what LEAVES the TCG payroll system — the .NET API surface and the ADP hand-off.
Read-only investigation. No connection strings / secrets printed. EmpIDs masked where quoted.

Source of truth for the API: `c:\projects\tcg-payroll-api\Program.cs` (single-file minimal API,
.NET 9, 2297 lines). It is the ONLY hand-written C# source file — the rest of `*.cs` under
`c:\projects\tcg-payroll-api\obj\...` are generated build artefacts.

---

## C1 — .NET API endpoints

The API is a minimal-API app. Every endpoint is registered with `app.MapGet` / `app.MapPost`.
Auth is a shared `X-API-Key` header checked by `IsAuthorized` (`Program.cs:13-20`); every endpoint
except `/health` returns `401` if it is missing/wrong.

**All results are produced with `Results.Ok(...)`, `Results.BadRequest(...)`, `Results.Problem(...)`
or `Results.Json(...)` — i.e. JSON only.** There is no `Results.File`, `Results.Stream`,
`Results.Bytes`, no `FileStreamResult`, no `Content-Disposition`/`attachment`, no `text/csv` or
`application/vnd...xlsx` writer, no EPPlus/ClosedXML, no manual `StreamWriter`/CSV building anywhere
in the file (grep for all of these returned **no matches**).

> **No endpoint returns a file — all 15 endpoints return JSON.**

Binary column values, if any ever appear, are base64-encoded *inside* the JSON
(`NormalizeDbValue`, `Program.cs:2232-2243`) — still JSON, not a file download.

### Endpoint inventory (method + route + backing object + response shape)

| # | Method | Route | Backing DB object | Response (top-level JSON) |
|---|--------|-------|-------------------|---------------------------|
| 1 | GET | `/health` | none | `{ ok, utc, env }` (`:29-37`) |
| 2 | GET | `/payperiod/ensure` | proc `api.usp_EnsurePayPeriod_ForDate` | `{ ok, payPeriodID, periodStartDate, periodEndDate, status, processedAtUTC, processedBy, createdAtUTC }` (`:39-78`) |
| 3 | GET | `/worklist` | TVF `api.tvf_UI_Payroll_Worklist_ForPayPeriodDate` + view `api.v_UI_Employee_PayrollGroupRate` | `{ ok, anyDateInWeek, rows[] }`; each row ~70 fields incl. `adpFileNumber`, `adpFileNumber*Flag`, payroll-group + base-rate fields (`:80-243`) |
| 4 | GET | `/employee-day-totals` | proc `api.usp_EnsurePayPeriod_ForDate` then TVF `api.tvf_UI_Payroll_EmployeeDayTotals_ForDateRange` | `{ ok, anyDateInWeek, periodStart, periodEnd, empID, rows[] }`; rows carry hrs (ST/OT/DT), gross, WTL, subsistence, payable gross (`:245-384`) |
| 5 | GET | `/employee-week-daily-summary` | TVF `api.tvf_EmployeeWeekDailySummary` + inline CTE over `fms.Payroll_PayComponent` (non-union CA buckets) | `{ ok, anyDateInWeek, empID, employeeName, periodStart, periodEnd, rows[] }` (`:386-602`) |
| 6 | GET | `/labor-entry-week-detail` | view `api.v_UI_Payroll_LaborEntry_WeekDetail_WithBuckets` (+ ledger/comment/subsistence/timeline joins) | `{ ok, anyDateInWeek, periodStart, periodEnd, filters, rows[] }`; rows are very wide (rates, boom, rest, hrs, gross, issues) (`:604-1215`) |
| 7 | GET | `/labor-entry-audit` | proc `api.usp_Get_LaborEntry_AuditPacket` (4 result sets) | `{ ok, filters, header, detail, slices, master }` (`:1217-1349`) |
| 8 | GET | `/rest-period-slice-detail` | proc `api.usp_UI_RestPeriod_SliceDetail` | `{ ok, empID, anyDateInWeek, laborPayrollID, rows[] }`; per-slice rest-premium detail (`:1351-1457`) |
| 9 | POST | `/employee-external-identifier` | proc `api.usp_UI_SaveEmployeeExternalIdentifier` | `{ ok, empID, externalSystemCode, externalIdentifierName, adpFileNumber, message }` — this is where the **ADP File Number is written back** onto an employee (`:1460-1558`) |
| 10 | POST | `/notes/bulk` | procs `app.usp_SaveNote_PayPeriod` / `_EmployeePayPeriod` / `_EmployeeDay` (in a tx) | `{ ok, payPeriodNoteId, employeeNotesSaved, employeeDayNotesSaved }` (`:1560-1633`) |
| 11 | POST | `/payroll/process` | proc `app.usp_ProcessPayroll_PayPeriod` (WRITE/commit) | `{ ok, periodStartDate }` (`:1635-1675`) |
| 12 | POST | `/payroll/refresh-from-nexgen` | proc `api.usp_UI_RefreshPayroll_FromNexGen` | `{ ok, uiRefreshID, ... , status, message, rawFMS_*, payrollAPP_* }` (`:1677-1761`) |
| 13 | GET | `/employee-week-guarantees` | proc `api.usp_UI_Payroll_EmployeeWeek_Guarantees` (2 result sets) | `{ ok, empID, anyDateInWeek, groups[], allocations[] }` (`:1763-1831`) |
| 14 | GET | `/employee-week-pay-components` | views `api.v_UI_Payroll_PayComponent_EmployeeDaySummary`, `_Summary`, `_Detail`, `api.v_UI_Payroll_LaborEntry_Ledger_Summary`, `api.v_UI_LaborEntry_RateSourceReview`, `_RateResolution` (5 result sets) | `{ ok, empID, anyDateInWeek, periodStart, periodEnd, daySummary[], laborSummary[], componentDetail[], rateSourceReview[], rateResolution[] }` (`:1833-2095`) |
| 15 | GET | `/labor-entry-ledger` | proc `api.usp_UI_Payroll_LaborEntry_Ledger` (2 result sets) | `{ ok, laborPayrollID, summary, rows[] }` (`:2098-2148`) |

Request DTOs (records, `Program.cs:2270-2297`): `BulkNotesRequest`, `EmployeeNote`, `EmployeeDayNote`,
`SaveEmployeeExternalIdentifierRequest`, `ProcessPayrollRequest`, `RefreshPayrollFromNexGenRequest`.

**ADP relevance of the API:** the only "ADP" the API touches is the **ADP File Number** (an employee
external identifier): surfaced read-side in `/worklist` (`adpFileNumber` and its missing/invalid/review
flags) and written back via POST `/employee-external-identifier`. The API does **not** produce an ADP
paydata file, CSV, or XLSX, and has no `/export`, `/download`, `/adp`, `/file`, or `/report` route.

---

## C2 — ADP hand-off / rpt.* export views

13 `rpt.*` view definitions exist at `c:\projects\PAYROLL_CALC_EXTRACT\sql/rpt\*.VIEW.sql`.

**Key finding: NONE of them is an ADP / paydata export layout.** A case-insensitive grep across the
whole `rpt` folder for the tell-tale ADP paydata column names — `Reg Hours`, `O/T`, `Hours 3`,
`Hours 4`, `Temp Rate`/`TempRate`, `ADP`, `4RZ`, `Paydata`, `File Number`, `Batch` — returned
**no matches**. These `rpt.*` views are UI / audit / exceptions reporting views (screen-shaped, verbose
column names), not a fixed-position payroll-import layout. They read from the *calculated* payroll
tables (`fms.Payroll_Calculated`, `fms.Payroll_CalcException`, `fms.Payroll_PayComponent`) and
`app.v_Base_LaborPayroll` — i.e. they expose the engine's output, they do not format an ADP feed.

Below, each view: what it reads from TCG_PayrollAPP + its output column layout. Columns tagged
**HOURS** / **DOLLARS** / **CODE** where the ADP-style classification applies; UI/audit views also
carry many ID / text / flag / datetime columns (tagged **META**).

### 1. `rpt.v_UI_Payroll_Audit` (`v_UI_Payroll_Audit.VIEW.sql:1-37`)
Reads `fms.Payroll_Calculated C` LEFT JOIN `calc.v_Calc_Labor_Timeline L`.
The closest thing to a human "audit sheet", but still not ADP layout.
- `LaborPayrollID`, `JobTicketID`, `EmpID` — META (ids)
- `Employee` (Employee_Name), `Job Code` — META
- `WorkDate_Raw`, `Work Date` (MM/dd/yyyy) — META (date)
- `Shift Start`, `Shift End` (hh:mm tt) — META (time)
- `Hours Worked` (Act_Total_Hrs) — **HOURS**
- `Gap Hours (Min)` (Gap_Hrs_Total), `Gap Hours (Boom)` (Gap_Hrs_Boom) — **HOURS**
- `Flag: Min Guarantee`, `Flag: Boom Premium`, `Flag: Missing Rate` — META (YES/'' flags)
- `Gross Pay` (Final_Gross_Pay) — **DOLLARS**
- `Cost of Guarantee` (Pay_Gap_Add) — **DOLLARS**

### 2. `rpt.v_Payroll_LaborEntry_WeekDetail` (`v_Payroll_LaborEntry_WeekDetail.VIEW.sql:1-299`)
Internal wide detail, 1 row / LaborPayrollID. Reads `app.v_Base_LaborPayroll` LEFT JOIN
`fms.Payroll_Calculated`, `calc.v_Calc_Pricing_Master_Audit`, `calc.v_JobTicket_Times`, and
`api.v_Payroll_Exceptions_LatestPricingRun`. ~120 columns. Notable measure columns:
- **HOURS**: `Act_Total_Hrs`, `Act_Boom_Hrs`, `Gap_Hrs_Total`, `Gap_Hrs_Boom`, `Pay_Total_Hrs`,
  `Hrs_ST`, `Hrs_OT`, `Hrs_DT`, `Rest_Premium_Hrs`, plus derived `Labor_Hrs_From_TimeBounds`,
  `Ticket_Shift_Hrs_From_Refs`, `Ticket_Boom_Hrs_From_Refs`, `Diff_Hours_ActTotal_vs_HoursWorkedRaw`.
- **DOLLARS**: `Pay_Actual_Gross`, `Pay_Gap_Add`, `Final_Gross_Pay`, `Pay_Rest_Add`,
  `Source_Amount_Raw`, `RateUsed_Est`, `Diff_Rate_RateUsedEst_vs_SourceRate`,
  `Diff_Gross_Final_vs_SourceAmount`. (Rates are $/hr.)
- **CODE**: `JobCode`, `WoCode`, `CraftCode`, `CraftModifierCode`, `ClassCode`, `UnitCode`,
  `ActivityCode`, `Shift_Code_Raw`, `WorkerCompCode`, `BurdenCode`, `UnionCode`.
- Everything else META (ids, ticket TkTm01..TkTm10 raw times, flags, statuses, issue reasons).

### 3. `rpt.v_UI_Payroll_Reconstruction_Audit` (`v_UI_Payroll_Reconstruction_Audit.VIEW.sql:1-247`)
Cross-checks labor timeline vs ticket timeline vs calculated hours. Reads
`app.v_Base_LaborPayroll`, `calc.v_Calc_Labor_Timeline`, `calc.TicketTimeline`,
`fms.Payroll_Calculated`.
- **HOURS**: `HoursWorked_Raw`, `LA_Total_Hrs`, `TT_Shift_Hrs`, `TT_Boom_Hrs`, `Act_Total_Hrs`,
  `Act_Boom_Hrs`, `Pay_Total_Hrs`, `Hrs_ST`, `Hrs_OT`, `Hrs_DT`, and the `Diff_*_Hrs` deltas.
- **DOLLARS**: `Final_Gross_Pay`.
- **CODE**: `JobCode`.
- META: ids, start/end datetimes, `Diff_*_Min`, `Flag_*` mismatch flags, `Audit_Status`,
  `Needs_Manager_Review`.

### 4. `rpt.v_UI_Payroll_Exceptions` (`v_UI_Payroll_Exceptions.VIEW.sql:1-35`)
Exceptions list. Reads `fms.Payroll_CalcException e` LEFT JOIN `app.v_Base_LaborPayroll`,
`cfg.LaborType_TicketPolicy`. Columns: `RunId`, `CalcRunAt`, `Severity` (derived Warning/Error),
`Reason`, `LaborPayrollID`, `WorkDate`, `EmpID`, `EmpID_Raw`, `Employee_Name`, `JobTicketID`,
`JobCode` (CODE), `Shift_Start`, `Shift_End`, `LaborType`, `Is_AtomLabor`, `Is_AtomLabor_Label`,
`TicketExpectation`, `TicketExpectation_Notes`. **No HOURS/DOLLARS** — all META/CODE/text.

### 5. `rpt.v_UI_Payroll_Exceptions_LatestRun` (`...:1-13`)
`SELECT e.*` from view #4 filtered to `MAX(RunId)`. Same columns as #4, latest run only.

### 6. `rpt.v_UI_Payroll_Issues` (`v_UI_Payroll_Issues.VIEW.sql:1-22`)
Reads `fms.Payroll_CalcException` directly. Columns: `RunId`, `CalcRunAt`, `Reason`, `Severity`
(derived), `LaborPayrollID`, `WorkDate`, `EmpID`, `Employee_Name`, `JobTicketID`, `JobCode` (CODE),
`Shift_Start`, `Shift_End`. **No HOURS/DOLLARS.**

### 7. `rpt.v_UI_Payroll_Issues_LatestRun` (`...:1-11`)
`SELECT i.*` from #6 filtered to `MAX(CalcRunAt)`. Same columns.

### 8. `rpt.v_UI_Payroll_Issues_Enriched` (`v_UI_Payroll_Issues_Enriched.VIEW.sql:1-38`)
View #6 + shift start/end back-filled from `calc.v_Calc_Labor_Timeline`. Same column set as #6
(with `Shift_Start`/`Shift_End` coalesced). **No HOURS/DOLLARS.**

### 9. `rpt.v_UI_Payroll_Issues_Enriched_LatestRun` (`...:1-12`)
`SELECT e.*` from #8 filtered to `MAX(CalcRunAt)`.

### 10. `rpt.v_UI_Payroll_Issues_SeverityTotals_LatestRun` (`...:1-17`)
Aggregate over #6 (latest run): `Severity`, `IssueCount`, `EmpCount`, `WorkDays` — all counts (META).

### 11. `rpt.v_UI_Payroll_Issues_Summary_LatestRun` (`...:1-20`)
Aggregate over #6 (latest run) by `Severity, Reason`: `IssueCount`, `EmpCount`, `WorkDays`,
`MinWorkDate`, `MaxWorkDate` — counts/dates (META).

### 12. `rpt.v_UI_RestPeriod_Overlap_LatestRun` (`...:1-5`)
`SELECT *` from #9 filtered `Reason LIKE 'RestPeriod_Overlap%'`. Same columns as #8.

### 13. `rpt.v_UI_Employees_FieldOnly_NoLabor_Count_CurrentPayPeriod` (`...:1-15`)
Reads `api.tvf_Employees_ActiveButNoLabor_FieldOnly` for the current Sat–Fri pay period.
Columns: `PeriodStart`, `PeriodEnd` (META/date), `MissingEmpCount` (count). **No HOURS/DOLLARS/CODE.**

**Conclusion for C2:** the ADP paydata export layout (Reg Hours / O/T Hours / Hours 3 Code+Amount /
Hours 4 Code+Amount / Temp Rate, keyed by ADP File Number) is **not present in the SQL database**
(`TCG_PayrollAPP`) as any `rpt.*` view, and the API does not emit it. The DB and API produce the
*calculated* hours/dollars per labor entry and per pay component; some downstream tool must reshape
that into the ADP paydata columns — see C3.

---

## C3 — Excel / Power Query / scheduled export / linked server search results

**Nothing found on this machine.** Absence is the finding here.

- **Excel / Power Query / SSIS / SSRS artefacts** — searched recursively (with
  `-ErrorAction SilentlyContinue`) under `C:\projects`, `%USERPROFILE%\Documents`, `Downloads`,
  `Desktop`, `OneDrive`, and then a second broader sweep of **all of `C:\Users`** (excluding
  `node_modules` and `AppData` noise) for `*.xlsx`, `*.xlsm`, `*.xlsb`, `*.pq`, `*.m`, `*.dtsx`,
  `*.rdl`:
  - **0 workbooks (.xlsx/.xlsm/.xlsb) found.**
  - **0 Power Query files (.pq / .m) found.**
  - **0 SSIS packages (.dtsx) found.**
  - **0 SSRS report definitions (.rdl) found.**
  - Filename search for `paydata`, `ADP`, `4RZ`, `qPayrollComponents`, `tblCfgADPTempRates`,
    `TempRate`: the only hits were unrelated JavaScript files inside
    `C:\projects\tcg-payroll-ui\node_modules` (`ariaDpubRoles.js`, `readPkgUp.*` — coincidental
    substring matches on "aDp"/"Up"), i.e. **no genuine ADP artefact**.

- **Linked servers** — `SELECT name, product, provider, data_source FROM sys.servers WHERE
  is_linked=1` against `localhost\SQLEXPRESS.TCG_PayrollAPP` returned **no rows**. There is no linked
  server pointing at ADP or any export target.

- **The `.m`/`.pq`/`.dtsx`/`.rdl` text query quoting requested is N/A** — none of those files exist to
  read.

**Interpretation / open item for the payroll team.** The names in the task brief
(`qPayrollComponents`, `tblCfgADPTempRates`, `TempRate`, `4RZ`, the Reg/OT/Hours-3/Hours-4/Temp-Rate
paydata layout) strongly suggest the ADP hand-off is built **outside this machine** — most likely an
**Access database** (`q...` = Access query, `tbl...` = Access table) and/or an **Excel + Power Query
workbook** that the payroll clerk runs against `TCG_PayrollAPP` and pastes/uploads into ADP
(the `4RZ` looks like an ADP company/batch code). None of that tooling lives on this box, and the SQL
database does not contain the layout. **Recommendation: the payroll team should confirm where the ADP
paydata workbook/Access file actually lives** (a shared drive, the clerk's own PC, or an ADP
Workforce Now import template). What this machine provides toward that hand-off is: (1) the calculated
hours/dollars/pay-components in `TCG_PayrollAPP`, exposed via the API's JSON endpoints, and (2) the
**ADP File Number** per employee (written via POST `/employee-external-identifier`, read via
`/worklist`) — i.e. the join key the external ADP export would use, but not the export itself.

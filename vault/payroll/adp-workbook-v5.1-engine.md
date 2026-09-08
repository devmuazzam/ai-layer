---
title: PAYROLL for ADP workbook v5.1 — Power Query, VBA and configuration, diffed against v3.8
source: shared-folder/Project-Repository-2026-09-08/3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL for ADP v5.1 - current/__VS_CODE_Payroll for ADP/v5.1.7z (21 .pq + 5 .bas, plain text); cross-checked against the DataMashup and vbaProject.bin of 8.22-8.28 ADP v5.1_2026-09-06_2006_ProcessedCOPY.xlsm and its hidden sheets
migrated: 2026-09-08
updated: 2026-09-06
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/source, adp, earning-codes, foreman-premium, military-premium, boom, legacy-payroll-app, integrations]
entities: [adp-export, excel-workbook, power-query, payroll-app, pay-component]
---

# PAYROLL for ADP workbook v5.1 — the engine, diffed against v3.8

**What this is.** The client supplied the v5.1 workbook's logic as plain text on 2026-09-08 — the
first time it has arrived as source rather than being recovered from an `.xlsm`. This page records
what is **new or changed since v3.8**; the v3.8 pages remain the description of everything that did
not move: [adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md) (the queries),
[adp-workbook-vba-macros.md](adp-workbook-vba-macros.md) (the macros),
[adp-workbook-column-rules.md](adp-workbook-column-rules.md) (the sheet columns). The operating
procedure is [adp-sop-v5.1.md](adp-sop-v5.1.md). Per the client, v5 has run production payroll
for three weeks with no known issues.

**Integrity, verified 2026-09-08.** The 21 `.pq` files diff at zero lines against the M embedded in
the week-36 workbook (330,681 characters, 22 queries — the workbook carries one query the folder
does not, `qPayrollAppRefresh`, the mutating one). The five `.bas` files match the embedded VBA
except identifier casing. `3.7_qADPPreview.pq` and `4.3_qADPPreview.pq` are the same query filed
twice. `Holidays`, `CraftRates` and `CraftModRates` are cell-for-cell identical to v3.8; the week,
Batch ID, `EPI4RZnn` counter, payday rule and the 13-token comment vocabulary are unchanged.

## 1. What changed, in one table

| | v3.8 | v5.1 |
| --- | --- | --- |
| Roster source | inline SQL against FCC's `FMS_EMPLOYEES` through `fnFccNativeQuery` | **`EXEC api.usp_Excel_RefreshEmployees @PayrollStartDate, @PayrollEndDate`** on the internal `TCG_PayrollAPP` database (*"server-side path TCG_PayrollAPP → TCG_RawFMS → FCC linked server"*). `fnFccNativeQuery` is gone; **Excel no longer connects to FCC at all** |
| Calculation | none — the sheet is typed | the Payroll App's recalculation is **triggered from Excel** and its results displayed under each sheet (§3) |
| Employee-sheet columns | `Employee · Unit_Asset · Date · Day · Total Hrs …` | adds **`BASE RATE OVERRIDE`** (between Day and Total Hrs), **`Foreman`**, **`Military`** dropdowns; a recommendation block in rows 36–43 |
| ADP row types | `PRIMARY`, `TEMP_RATE` | adds **`BASE_RATE_OVERRIDE`** (§2) |
| Hours-4 slot map | 20 slots (boom, lattice, shift) | **28**: `21 FRR 22 FRO 23 FRD 24 FRT · 25 MLR 26 MLO 27 MLD 28 MLT` |
| `ADP TempRates` | 16 rows | **24**: `FOREMAN` → `FRR/FRO/FRD/FRT` at **3.00 / 4.50 / 6.00 / 9.00**; `MILITARY` → `MLR/MLO/MLD/MLT` at **10.00 / 15.00 / 20.00 / 30.00** |
| Validation | 15 checks | `MISSING_PRIMARY_ROW` becomes `MISSING_BASE_PAY_ROW`; **seven new ERROR codes** for overrides (§2); a dead clause in the temp-rate test dropped |
| Review order | query order | explicit: name (upper, blanks last) → File # → row type PRIMARY / BASE_RATE_OVERRIDE / TEMP_RATE; `ReviewRow` numbered after sorting so `ADP_PREVIEW` and the CSV agree |
| Preview | — | new `qADPPreview` → `ADP_PREVIEW`: the review rows with codes turned into ADP's column names (*Double Time, Holiday Double, BOOM REG, Military OT, Subsistence…*), File # padded to six digits, a Batch Totals row, Temp Rate never totalled |
| Export macro | one step, refresh + write | **two steps**: `PrepareADPPaydata` (recalc, refresh review → preview → validation, configure the preview's total row, no CSV) then `ExportADPPaydataCSV` (no refresh; write). `HOURS4_SLOT_COUNT = 28` |
| `Temp Rate` column in the CSV | written only when some Hours-4 pair was used | **written whenever any row carries one** — override rows use it without an Hours-4 pair |
| Modules | 4 | 5: `mod_RefreshAllDataInFile` removed; `mod_ClearSlicersAndFilters` and **`mod_PayrollAppRefresh`** added; the sheet builder is unchanged |
| `__hiddenParams` | FCC server + database | **Payroll App server + database** instead; app version 5.1 |

The CSV emission order, from the exporter: `Co Code · Batch ID · File # · Reg Hours · O/T Hours` →
Hours-3 pairs 01–03 (DT · HDD · HOL) *if used* → **`Temp Rate`** → Hours-4 pairs 01–28 *if used* →
Earnings-3 01 (SUB) → **Hours-3 04 (SIC), last**. That is why `EPI4RZ36.csv` has 24 columns with
`SIC` trailing after `SUB`: this week used DT, six Hours-4 slots (**LBH LBO LBD MLR MLO MLD**), SUB
and SIC. The SIC-after-SUB order is inherited from v3.8 and unexplained in either version; it most
likely mirrors the ADP paydata template (inferred).

## 2. The base-rate override — a rule no page had

A dollar figure typed in a row's **`BASE RATE OVERRIDE`** sends that row's ST/OT/DT/H2x/H3x hours to
ADP on their **own row**, `RowType = BASE_RATE_OVERRIDE`, with the override in `Temp Rate` and no
Hours-4 pair. Verified in `qADPPrimaryRows` and `qADPImportValidation`:

- Rows are grouped by File # **and** override; blank → the ordinary `PRIMARY` row; the same override
  on several days merges; different overrides give separate rows.
- The override applies to the base hours only — *"Subsistence and Sick may coexist … Boom and other
  premiums remain separate"* (query comment).
- Bounds `0 < rate ≤ 999.9999`. An override on a row with no base hours, or with a rate code, or with
  an Hours-4 premium, is an export-blocking ERROR (`BASE_OVERRIDE_MISSING_TEMP_RATE`,
  `BASE_OVERRIDE_INVALID_TEMP_RATE`, `BASE_OVERRIDE_HAS_RATE_CODE`, `BASE_OVERRIDE_NO_ELIGIBLE_HOURS`,
  `BASE_OVERRIDE_HAS_HOURS4_PREMIUM`), and two source-level checks
  (`SOURCE_BASE_OVERRIDE_INVALID_RATE`, `SOURCE_BASE_OVERRIDE_WITHOUT_HOURS`) stop an override
  vanishing silently before the ledger.
- A `MISSING_BASE_PAY_ROW` error fires when an employee has neither a PRIMARY nor an override row;
  *"no more than one ordinary PRIMARY"* is still enforced.
- The `TEMPLATE` sheet's "ADP Rate / Hours" block (rows 29–33) sums the base hours per distinct
  override rate, up to four.

The week-36 export carries **one such row, at `72.16`** — the L12 Group-9 FY26-27 base rate — for an
employee whose primary row is elsewhere. **What the override is *for* is not stated anywhere in the
code or SOP.** The candidates the register already holds: an employee working a different craft
group than their own (PAY-010 — labor-entry craft vs employee craft), or the fiscal-year rate
ambiguity the column-rules page lists. Findings question 40.

## 3. The recommendations flow — verified from `mod_PayrollAppRefresh` and `04_PAYROLL_APP_DATA`

1. The clerk picks a pay period on `PAYROLL_START` and presses **Refresh Payroll App
   Recommendations** (`RefreshPayrollAppRecommendations`). The macro talks **only** to the Payroll
   App database named in `__hiddenParams`; never to FCC.
2. It refreshes `tblPayrollAppRefresh`, whose query runs **`EXEC api.usp_Excel_RefreshPayrollWeek
   @PayStartDate, @PayEndDate`** (five-minute timeout) — per its comments a targeted FCC → `TCG_RawFMS`
   pull plus a full PayrollAPP recalculation of that week. **This query mutates the client's
   database from Excel.** The macro refuses to continue unless exactly one row comes back with
   `PayrollAppRunStatus = SUCCEEDED`, a `PayrollAppRunId > 0`, and the returned period equals the
   selected one. A one-time `ConfigurePayrollAppQueriesManualOnly` marks every `qPayrollApp*`
   connection *not* refresh-with-Refresh-All and *not* refresh-on-open, precisely because of this.
3. With that `RunId` it refreshes `tblPayrollAppRecommendations` (**`api.usp_Excel_PayrollRecommendations
   @PayStartDate, @PayEndDate, @EmpID = NULL, @ADPFileNo = NULL, @RunId`**) and `tblPayrollAppRunInfo`
   (**`api.usp_Excel_PayrollRunInfo @RunId`**). These are the *Excel and rule-narrative* procedures
   found in the 2026-09-07 backup
   ([legacy-payroll-app-db-backup-2026-09-07/INDEX.md](legacy-payroll-app-db-backup-2026-09-07/INDEX.md) §6).
4. `qPayrollAppRecommendations_ByEmployeeDay` rolls the per-labor-entry rows to one per employee-day:
   hours summed; boom rate per bucket, **flagged as a conflict when entries with hours carry
   different rates**; narrative fields taken once. `…_ForEmployeeSheets` builds the lookup key
   (`UPPER(File #) | yyyy-mm-dd`, numeric File # de-padded — SQL's canonical form is six-digit
   zero-padded, the sheets use the number) and blocks a key that is not ready, duplicated, or
   rolled up from a blocked day. 53 columns land on `__PayrollAppRecommendations`.
5. **The workbook only displays.** Rows 37–43 of every employee sheet are `INDEX/MATCH` formulas on
   that key: Block / Review flags, recommended ST…H3x, LB hours and rates, Subsistence, *Applied
   Payroll Rules*, *Calculation / Review Notes* (`REVIEW:` + `PayrollReviewReasons`, `INFO:` +
   `CalculationInfoNotes`), *Block Reasons*, and a typed **"Need to fix in Payroll App"** column.
   The macro auto-fits those rows and writes nothing into the sheets. Nothing is pre-filled, nothing
   is compared programmatically, and the export path reads only the typed rows. (SOP §5.4.3's
   *"loads those results into each individual employee sheet"* is true in the display sense only.)

`qWorkbookPayroll_ByEmployeeDay` — *"the workbook side of the upcoming side-by-side comparison"* —
rolls the typed rows to employee-day, flags multiple rows per day, LB-rate conflicts and File #
mismatches, and is **referenced by nothing and loaded nowhere**: scaffolding for a comparison not
yet wired. `qPayrollAppRecommendations_Check` is a connection-only diagnostic (row / employee /
RunId / period counts, blocked, review, ledger-blocked, boom-review, bucket tie-out failures,
unhandled components, and expected-vs-ledger gross).

## 4. `__PayrollAppMapping` — the client's own status board for the app's rules

`tblPayrollAppFieldMap`, 37 rows, referenced by no query or macro — a contract document. Its
`ImplementationStatus` column is the most useful thing in the drop for the register, because it is
the client stating which of the app's outputs are real:

| Scope | Workbook field → Payroll App column | Status |
| --- | --- | --- |
| KEY | `EmpID`, `ADP FileNo` (*preserve leading zeros*), `Employee`, `Date → WorkDate`, `LaborPayrollID` | — |
| AUDIT | `Payroll Group`, `Payroll RunId`, `LB Total`, `Ledger Difference` (*expected 0.0000*), `Ledger Additional Payable` | — |
| EMPLOYEE_SHEET | `ST/OT/DT/H2x/H3x → Recommended_*_Hours`; `LB ST/OT/DT/3X` hours and rates; `Subsistence → Recommended_Subsistence_Amount` | **ACTIVE**. On H2x/H3x: *"maps to HDD/HOL; ADP semantics still need confirmation"* |
| QUERY_ONLY | **`Rest Premium → Recommended_RestPremium_Amount`**, **`WTL Net → Recommended_WTL_Net_Amount`** | **`SQL_READY_ADP_PENDING`** — *"dedicated ADP code still TBD"*. Computed, not shown on sheets, no route to ADP |
| REVIEW | `ExportBlockingFlag/Reasons`, `ReviewWarningFlag/Reasons` | — |
| FUTURE | `2nd Shift`, `3rd Shift` | `FUTURE_RECOMMENDATION` |
| FUTURE | `Lattice Oiler`, `Lattice Oper`, `Foreman`, `Military` | **`NOT_IMPLEMENTED`** — *"add after Payroll App … rules"* |
| MANUAL | `Sick Hrs` | `MANUAL_SOURCE` — *"ERP paid-leave source not yet available"* |

So on 2026-09-06, by the client's own table: **the app recommends base hours, boom and subsistence;
computes rest premium and WTL as dollars with nowhere to send them; and does not recommend lattice,
shift, foreman or military at all** — those four are typed by the clerk from the dropdowns, which
is how `MLR/MLO/MLD` reached week 36.

`__PayrollAppRunInfo` holds the refresh control row (`RawFMSRunId`, `PayrollAppRunId`, status,
work-date window, run and refresh timestamps UTC and local, workflow start/complete) — the saved
state is one `Succeeded` run for 2026-08-22 → 28, refreshed the morning of 2026-09-07 UTC, which
matches the `etl.RunLog` reading on the backup page.

## 5. Consequences for the register

1. **Foreman and Military now reach ADP** as temp-rate families at $3 and $10 × 1 / 1.5 / 2 / 3, via
   sheet dropdowns and the token vocabulary. This closes the v3.8 page's finding that the export had
   no foreman or military component, and it **confirms the multiplied reading** of both premiums
   ([foreman-and-military-premiums.md](foreman-and-military-premiums.md)) — a `30.00` `MLT` rate is
   configured, and `MLR/MLO/MLD` at 10 / 15 / 20 shipped in week 36. **WTL and the subsistence tier
   still have no export path**; the token is read by the app, not by the export.
2. **The base-rate override** is a new ERP requirement candidate with no stated purpose — question 40.
3. **The Excel-or-API question** now has a sharper Excel side: the file contract is 5 fixed columns +
   `Temp Rate` + up to 28 Hours-4 slots + SUB + trailing SIC, three row types, 22 validation codes,
   alphabetical order. If the interim CSV path survives, this is what the ERP must reproduce.
4. **The client's own status board says lattice, shift, foreman, military and sick are not in the
   app's rules yet.** Where the register cites the legacy procedures for those (PAY-036/037,
   PAY-073, the foreman/military page), the citation is to intent, not to running code.
5. **Salary**: the roster query still pulls every pay type (unchanged); the app excludes `PayType =
   'S'` before pricing (backup INDEX). Salaried people therefore get sheets and no recommendation
   rows — inferred, consistent with the client saying Corrina keys salary into ADP separately.
6. **Non-union**: `PayrollGroup` is carried for display; the workbook applies no group-specific logic.
7. **One boom rate per bucket per day** is now enforced for display, matching the SOP's
   *separate row per modifier*.
8. **Refresh from Excel is a write to the client's production calculation database**, guarded only
   by the manual-refresh flags. Worth knowing before anyone opens the workbook with *Refresh All*
   habits, and worth knowing for the parallel-run design.

## Source

Read in full 2026-09-08: the 21 `.pq` (≈330 KB) and 5 `.bas` (≈135 KB) files; the week-36
workbook's `customXml` DataMashup, `vbaProject.bin` (olevba), and the sheet XML of `__hiddenParams`,
`__PayrollAppMapping`, `__PayrollAppRunInfo`, `ADP TempRates`, `Holidays`, `CraftRates`,
`CraftModRates`, `TEMPLATE`; the v3.8 master's DataMashup and VBA for the diff. No employee rows
were read from the employee sheets; the FCC and Payroll App host names are not recorded.

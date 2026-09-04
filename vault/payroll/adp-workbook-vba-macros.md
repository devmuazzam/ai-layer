---
title: PAYROLL for ADP workbook — the VBA macros (v3.7, v3.8, and a live week)
source: shared-folder/Project-Repository-2026-09-04/3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL for ADP v3.0 - current/ — __PAYROLL for ADP v3.8 (MASTER template).xlsm, __PAYROLL for ADP v3.7 (MASTER template) Mac version.xlsm, July 25-31 2026.xlsm (vbaProject.bin in each, dumped with olevba 2026-09-04)
migrated: 2026-09-04
updated: 2026-07-31
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/source, adp, legacy-payroll-app, earning-codes, integrations]
entities: []
---

# PAYROLL for ADP workbook — the VBA macros

**What this is.** The three macro-enabled payroll workbooks in the drop were dispositioned on
2026-08-13 as *"live payroll data and workbook machinery — not migrated"*, on the grounds that
the SOP describes the process. The **machinery** had never been read. On 2026-09-04 the
`vbaProject.bin` of each was dumped with `olevba`. The three carry the **same four modules**
(v3.7 Mac: 48 procedures · v3.8: 56 · the July 25–31 2026 live week: 44); v3.8 is documented
here as the current master. No employee data is in the code. The SOP that drives these macros is
[adp-sop-v3.8.md](adp-sop-v3.8.md); the columns they read are in
[adp-workbook-column-rules.md](adp-workbook-column-rules.md).

## The four modules

| Module | Entry point | What it does |
| --- | --- | --- |
| `modCreateEmployeeSheets` | `CreateEmployeeSheets()` | Builds one worksheet per employee from a template — §1 |
| `mod_RefreshAllDataInFile` | `RefreshAllDataInFile()` | Synchronous refresh of every query-backed table, then every PivotTable |
| `mod_RefreshAllDataOnSheet` | `RefreshAllDataOnSheet()` | Same, for the active sheet only; temporarily unprotects the sheet because *"Power Query may need to add, remove, or resize table rows"* |
| `modADPExport_FastRefresh` | `ExportADPPaydataCSV()` | Produces the ADP paydata import CSV — §2 |

## 1. `CreateEmployeeSheets` — the per-employee tabs

This is why the live workbooks have 80+ sheets. Configuration constants:

| Constant | Value | Meaning |
| --- | --- | --- |
| `TEMPLATE_SHEET` | `TEMPLATE` | the sheet that is copied |
| `TEMPLATE_TABLE` | `tbl___` | the table on it — three underscores, no suffix |
| `EMPLOYEE_TABLE` | `tblFccEmployees` | the roster the macro walks, **on the active sheet only** |
| `COL_EMPLOYEE_NAME / COL_EMPLOYEE_ID / COL_ADP_FILE_NO / COL_SHEET_NAME` | `EmployeeName`, `EmpID`, `ADPFileNo`, `SheetName` | the four roster columns it reads |
| `EMPLOYEE_TABLE_PREFIX` | `tbl___` | each copied sheet's table is renamed `tbl___<ADPFileNo>` |
| `EMPLOYEE_NAME_CELL` | `H3` | where the employee's label is written on the copy |

Rules the code enforces:

- Only **visible** roster rows are processed — filter the roster to choose who gets a sheet.
- **`ADPFileNo` and `SheetName` are both required**; a row missing either is skipped and
  counted.
- **A valid ADP File Number is 1–6 ASCII letters or digits** (`IsValidADPFileNo`); it is
  upper-cased before use. So `164`, `00165` and `A12` are valid; anything with a space,
  hyphen or accent is not. (Compare the vault's note that the *app's* File # validation had a
  bug — [legacy-payroll-app-code-extract.md](legacy-payroll-app-code-extract.md).)
- Sheet names are cleaned to Excel's rules (no `[]:*?/\`, no leading/trailing apostrophe, ≤ 31
  characters, no control characters or doubled spaces).
- An employee worksheet is *identified* by its table name: `tbl___` alone is the template,
  `tbl___164` is an employee. After creation all employee sheets are **moved to the end and
  sorted alphabetically by sheet name**, leaving non-employee sheets in their existing order.
- The template's protection settings are captured and re-applied to every copy;
  `SHEET_PROTECTION_PASSWORD` is blank in all three files.
- The template is made visible only for the duration of the copy, because *"a hidden worksheet
  may not copy reliably, particularly when the workbook is used in both Windows and Mac"*.

The macro cannot run while workbook structure protection is on, and it refuses if the roster
table is not on the sheet that was active when it started.

## 2. `ExportADPPaydataCSV` — the file that goes to ADP

Reads two tables — **`tblADPImportReview`** (the rows) and **`tblADPImportValidation`** (the
checks) — refreshing only those two synchronously (*"It does NOT use Workbook.RefreshAll"*), then
writes the CSV. Column policy, in the code's own words and order:

- Fixed leading columns: **`Co Code` · `Batch ID` · `File #` · `Reg Hours` · `O/T Hours`**.
- Then **`Temp Rate`**, and the code/amount pairs — **`Hours 3 Code` / `Hours 3 Amount`** used
  repeatedly, and **`Hours 4 Code` / `Hours 4 Amount`** — *"omits unused ADP code/amount pairs"*:
  a pair is written only if any row has data in it (`AddPairIfUsed`, `PairHasAnyData`).
- **Repeated header names are written exactly as ADP expects** — the same literal `Hours 3
  Code` heading appears as many times as there are used pairs.
- Internal `ReviewRow` and `Name` columns are **excluded**.
- **Quantitative zeros become blanks** (`Reg Hours`, `O/T Hours`, `Temp Rate` and every amount
  column — `IsQuantitativeColumn`).
- Numbers are written invariant-culture; fields are CSV-quoted when needed.
- Before writing, `ReadValidationResults` walks `tblADPImportValidation` and lists any failing
  row by `File #`; the run summary reports total `Reg Hours` and `O/T Hours` and the sum of
  Hours-4 amounts.
- Save path: a dialog, with a **per-user fallback folder** *"when Excel for Mac cannot display a
  dialog"*; the extension is forced to `.csv`.

This is the code behind the `EPI…csv` files in the same folder and the bucket mapping in
[adp-bucket-crosswalk.md](adp-bucket-crosswalk.md): the workbook's earning buckets are
flattened into ADP's `Hours 3/4 Code + Amount` pairs, one pair per bucket actually used that
week.

## What differs between the three files

The module set and every entry point are identical. v3.8 has eight more private helpers than
v3.7 (the validation-results reader and the summary formatting), and the July live week is the
v3.8 code with four fewer helpers — consistent with the live file being saved from an earlier
v3.8 build. No calculation logic is in any of them; **the pay rules live in the sheets'
formulas and Power Query, not in VBA** — the Power Query is now read: [adp-workbook-power-query-engine.md](adp-workbook-power-query-engine.md).

## Source

`olevba --decode` over the three `.xlsm` files, 2026-09-04: 3,042 / 1,965 / 2,163 lines of
decoded VBA respectively, saved beside this session's scratch as `vba/2-…v3.8…`, `3-…v3.7…`,
`4-July_25-31_2026…`. Only procedure names, constants and comments are quoted above; no cell
data.

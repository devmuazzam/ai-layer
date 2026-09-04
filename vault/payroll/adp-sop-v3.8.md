---
title: PAYROLL for ADP - Standard Operating Procedure v3.8
source: onedrive/OneDrive_1_8-11-2026/PAYROLL for ADP v3.0 - current/PAYROLL for ADP - SOP v3.8.docx; embedded screenshots read from shared-folder/Project-Repository-2026-09-04/3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL for ADP v3.0 - current/PAYROLL for ADP - SOP v3.8.docx
migrated: 2026-08-13
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, adp, legacy-payroll-app]
entities: [adp-export, payroll-week, excel-workbook, power-query]
---

> **This is the process the ERP Payroll Module is meant to replace.** It documents how payroll
> is produced *today* — an Excel workbook driven by Power Query, SQL and VBA, pulling from
> FCC-NexGen and importing into ADP. Read it for the current manual steps, the sheet-by-sheet
> data model, and the ADP import mechanics the new module has to reproduce. It is **not** a
> statement of the target design; for that see
> [erp-payroll-module-frd/](erp-payroll-module-frd/INDEX.md).

PAYROLL for ADP\
Standard Operating Procedure (SOP)

**The Crane Guys, LLC**

Version 3.8 \| Effective Date: August 5, 2026

**Document Control**

| Document Title | PAYROLL for ADP - SOP |
| --- | --- |
| Document Owner | Data Engineer |
| Department | Human Resources - Payroll |
| System | Excel workbook + Power Query + SQL + VBA FCC-NexGen + ADP |
| Last Updated | August 5, 2026 |
| Approver(s) | _________________________ |

## 1. Purpose

This SOP defines the standard process to create weekly payroll files and importing into ADP.

## 2. Scope

Applies to all active employees during the pay period.

## 3. Audience

### Primary users

- Payroll manager responsible for payroll processing

- Data/IT support for troubleshooting refresh/connectivity issues

## 4. System Overview

| FCC (Operations) Employees | Payroll for ADP Workbook input payroll data | ADP import payroll data |
| --- | --- | --- |

## 5. Weekly Payroll Processing

### 5.1 Open the template workbook

Open the “\_\_PAYROLL for ADP v3.7 (MASTER template)” workbook from the approved OneDrive location (currently located):\
[Payroll](https://craneguys-my.sharepoint.com/:f:/r/personal/cbustos_craneguys_com/Documents/Payroll?d=w90c819d49fe74dd2afa22be46eece02c&csf=1&web=1&e=dXmf70) (this link goes to the OneDrive folder below...)

> Note: This is an Excel workbook with macros. The file must be opened using Excel on the computer (it will **not** work properly in Excel in the browser).

### 5.2 Enabling the file

When opening the Excel file, there will be a few security prompts asking to enable the macros and to allow connection to the FCC database. Enable both.

Enable Macros (when opening the Excel file)

Enable Content (at top of screen when Excel file opens)

In addition, the first time opening this Excel file, do the following to allow the database queries to run.

Go to the \[Data\] tab in the Excel menu and click the down arrow on the “Get Data” button and select “Launch Power Query Editor…”

The Power Query Editor will open in a new window.

In the Power Query Editor menu, go to the \[Home\] tab and click the “Options” button.

In the Options screen, go to the \[Privacy\] section and make sure the checkbox is selected… then click the ‘Save’ button in the Options screen.

Then, in the Power Query Editor window, click the “Close & load" button.

And then Save the Excel workbook.

Now, the Excel workbook should be fully functional (with the ability to connect directly to FCC-NexGen, and all buttons in the workbook will be enabled).

### 5.3 All visible sheets in the Excel workbook

### 5.3.1 Emp_ADP#s and SheetNames

Every employee must be listed on this sheet first (before using the PAYROLL_START) sheet.

This sheet is used to manually type in (storing) the list of ADP ID and desired SheetName for each employee.

Note: this Excel workbook is **not** directly connected to ADP… and FCC does not have employees’ ADP IDs, so it is important to have the correct ADP ID listed here for each employee.

For each employee, double-check and/or type in:

- **FCC EmpID**: employee code/ID from FCC (must be correct)

- **ADPFileNo**: employee code/ID from ADP (must be correct)

- **SheetName**: desired sheet name used by macro when creating employee sheets

- **EmployeeName in ADP**: for reference only (not used by anything in this Excel workbook)

- **Employee Name in FCC**: for reference only (not used by anything in this Excel workbook)

To add or remove employees on the list :

- Right-click on a row and select Insert Row or Delete Row

### 5.3.2 PAYROLL_START

#### This sheet contains:

- Pay Period: this is a dropdown list… select pay period to be processed

- FCC table/report: all active employees for the selected pay period (use ‘Refresh All’ button to refresh data)

- Macro buttons:

  - Refresh FCC employee table/report

    - - Generate/create individual employee sheets

    - #### Process:

Select pay period to be processed from the dropdown list…

A message will pop up when macro is finished. For example…

The grayed-out cells above and below automatically populate based on the pay period selected.

##### **How to control which employee sheets are created when clicking the ‘Create Employee Sheets’ button:**

Green slicers above the table and/or the table filters can be used to filter the rows showing in the table.

When the employee sheets are created, only employee showing in the table that have an “ADPFileNo” and “SheetName” will get their own sheet.

For example, in the picture below, only Anthony Albergo and Jonathen Aldridge will have a sheet created.

Important note: All blue columns in this table is data from FCC… to change these, update FCC and then ‘Refresh’ the table here.

The ‘Create Employee Sheets’ button will create a separate sheet for each employee on the list (using the “TEMPLATE” sheet as the template) … and sorts/orders all employee sheets alphabetically by SheetName.

#### This macro will not create a new sheet for an employee:

- If the **ADPFileNo** for that employee is blank

- If the **SheetName** for that employee is blank

- If there is already a sheet for that employee

When the “Create Employee Sheets” macro is finished, it will display a message with a summary. For example…

#### How to add a NEW EMPLOYEE sheet:

Note: the “TEMPLATE” sheet is now hidden.\
Do **not** use the TEMPLATE sheet to manually create a new employee sheet… and do **not** copy/duplicate an existing employee sheet to create a new employee sheet.

To add a new employee sheet (after the individual employees sheets have already been generated) …

… simply follow the same process/steps as before.

First, make sure to update the employee table on this sheet…

Then go through the same 3 steps on this sheet…

This works for adding new employee sheets as well because the ‘Create Employee Sheets’ button does the following:

- Creates a new employee sheet **only** when both ADPFileNo **and** SheetName are populated.

- Existing employee sheets are **not** changed, replaced, or deleted.

- If a matching employee sheet or employee table already exists, that employee is skipped.

- Then all employee sheets are placed at the end of the workbook and sorted alphabetically.

### 5.3.3 All Hidden Sheets

There are several hidden sheets in the Excel workbook:

- **\_\_hiddenParams**

  - Used for variables/parameters

    - Org/company name, app name, and app version

    - FCC server name

    - FCC database name

    - Calendar start/end dates

- **\_\_PayrollWeeks**

  - Contains the auto-generated payroll week list based on the calendar start/end dates in “\_\_hiddenParams” sheet

- **Holidays**

  - Contains list of Labor Union holidays

  - Note: this is **not** connected to anything outside of this Excel workbook

- **CraftRates**

  - Contains the list of all Craft Codes and rates per fiscal year (FY)

  - Note: this is **not** connected to FCC

- **CraftModRates**

  - Contains the list of all Craft Code Modifiers for both Operators and Oilers with rate for each

  - Note: this is **not** connected to FCC

- **ADP TempRates**

  - Contains the list of all ADP Temp Rates (for Lattice Operator, Lattice Oiler, 2nd Shift, 3rd Shift)

  - Note: this is **not** connected to FCC

- **TEMPLATE**

  - Sheet used by the macro button to generate each individual employee sheet

## 6. Entering Data into Employee Sheets

### 6.1 Process for entering payroll data

All gray cells fill in automatically with formulas.

There is a row for each day of the week in the pay period.

The **Unit_Asset** column is a text field to be used for entering the units/assets used by the employee (or used to type in notes for that day).

The next several columns are used to type in the “Total Hrs” worked for that day and the breakdown of ST/OT/DT/H2x/H3x.

ST = standard time (a.k.a.: regular time)\
OT = overtime\
DT = double time\
H2x = special (June & December) Labor Union holidays\
H3x = Labor Union holidays (except the two special holidays)

First type in total number of hours in the “**Total Hrs**” field.

“**Hrs_Match**” will have a red X until the breakdown of ST/OT/DT/H2x/H3x are filled in correctly…

… when the other columns match, then it changes into a green check…

Below is a summary of hours for the entire week automatically calculated…

The next group of columns to the right are for indicating if the hours for that day/row qualify for Lattice and/or Shift Differential. Each is a drop down list with one option per column/row…

The next group of columns to the right are for entering Craft Modifier code and hours…

The “Craft Modifier” field is a dropdown menu… select the correct code.

Then type in the total number of boom hours for that day.

The rate for each will automatically show when hours are filled in…

… and the summary at the bottom automatically calculates totals…

The last group of columns are:

**Subsistence**: enter total dollar amount for that day to be paid for subsistence

**Sick Hrs**: enter total hours of sick time for the day (non-Union employees)

**Holiday**: this automatically shows holiday details when the date matches a day on the Holidays sheet/list

There is a cell towards the bottom of each employee sheet for typing in payroll notes for that employee/week…

### 6.2 Process for "closing out” the weekly Payroll and importing into ADP

#### Go to the “ADP_IMPORT_REVIEW” sheet…

After clicking on the ‘Refresh All’ button and the table will populate with the ADP data to review.

After the macro is completed, it will display a message like…

#### Then go to the “ADP_IMPORT_VALIDATION” sheet…

This sheet shows if/when the ADP data is ready to be exported as a CSV file.

If there are any errors, the errors will show in the table on this sheet…

If the ‘Create CSV’ button is clicked when there are errors, it will show a message like…

#### Click ‘Refresh All’ button to refresh table on this sheet…

Once the validation show “PASS” “READY”… then it’s ready to create the CSV file… click the button to create/save the CSV file to your computer…

On a Windows computer, the Save As dialog looks like this…

On a Mac computer, a special Apple Script needs to be installed to make this work properly… although it will still allow you to save to a system folder.

#### Then log in to ADP WorkforceNow:

- Go to the Payroll Dashboard in ADP

- Go to the payroll week that needs to be imported

- Import the CSV file and review information in ADP before submitting

  - Note any changes/modifications needed so we can update this Excel process (as needed)

## What the SOP's screenshots show — read 2026-09-04

The docx embeds 46 images; 28 were extracted and read (eight are the same logo and Excel
security-dialog crops as the Sales Commissions SOP; ten — the tab crops, the hidden-sheet
list, the Lattice / Shift-Differential dropdowns, the boom summary, the Subsistence/Sick/
Holiday columns, the notes cell and the two ADP-tab crops — were not recoverable). Every workbook screen carries the
header **PAYROLL v3.7**: the v3.8 SOP documents the v3.7 MASTER template, as §5.1 says. Only
what the text does not already say is recorded; the column semantics are in
[adp-workbook-column-rules.md](adp-workbook-column-rules.md) and the macros in
[adp-workbook-vba-macros.md](adp-workbook-vba-macros.md).

**The OneDrive folder** shows two sibling files the SOP never mentions: `EMPLOYEE PAYROLL
DETAIL .xlsx` and `MASTER (use this one).xlsx`. What they are is not stated.

**Tab strip before generation:** `Emp_ADP#s and SheetNames` · `PAYROLL_START` ·
`ADP_IMPORT_REVIEW` · `ADP_IMPORT_VALIDATION` — four visible sheets; the employee sheets are
appended after them.

**Emp_ADP#s and SheetNames.** Title *"Employees' ADP #'s and Sheet Names"*, banner *"(Enter
employees' "ADPFileNo" and "SheetName" into the table below…)"*, then *"One row (on table below)
per employee / FCC Employee ID must be correct / Employee must have the correct ADPFileNo and
SheetName desired before clicking button to generate employee sheet(s)"*. Columns `FCC EmpID ·
ADPFileNo · SheetName · EmployeeName in ADP · Employee Name in FCC`, with over-captions *"type
in employee ID from FCC"*, *"type in ADPFileNo (populates table on PAYROLL_START sheet)"*,
*"type in SheetName (populates table on PAYROLL_START sheet)"* and *"(this is for reference
only)"* over the two name columns. Conventions visible in the rows: `FCC EmpID` is usually a
one-to-four-digit number but can be initials (`AA`) or zero-padded (`0004`, `0319`, `0823`);
`ADPFileNo` is a three-digit number; **`SheetName` is `Lastname-FirstInitial`** (`Albergo-A`,
`ALDRIDGE-J`, `BAKER-K` — case is not normalised); salaried/admin staff have a blank
`SheetName`, which is what stops a sheet being generated for them. The ADP and FCC name
columns differ in form (ADP carries middle names and some all-caps entries).

**PAYROLL_START.** The header block:

```
Company:        THE CRANE GUYS LLC   4RZ
ADP Week:       Weekly #33
ADP File Name:  EPI4RZ33
Pay Period:     2026 (Aug 1 - Aug 7)      ← dropdown
Payday Date:    8/13/2026   Thu
From Start Date: 8/1/2026   Sat
To End Date:     8/7/2026   Fri
```

So the **ADP company code is `4RZ`**, the **ADP file name is `EPI` + company code + ADP week
number**, the pay week runs **Saturday → Friday**, and **payday is the Thursday after the week
ends** (six days later). The dropdown lists weeks as `2026 (Jul 18 - Jul 24)`, `2026 (Jul 25 -
Jul 31)`, … Three step boxes sit under it — *Step 1: Select Pay Period, then click "Refresh"
button. This updates the list of employees with all active employees in FCC during that pay
period* → `Refresh All`; *Step 2: Filter this list to only the employees that need individual
sheets. Only the employees with "SheetName" will get a sheet… Go to "Emp_ADP#s and SheetNames"
to update employee SheetName*; *Step 3: … click the "Create Employee Sheets" button. This will
create a sheet for every employee on the filtered list with a "SheetName"* → `Create Employee
Sheets`.

Five slicers, whose values are the FCC classification code lists as of Aug 2026:

| Slicer | Values |
| --- | --- |
| `CraftType` | `ADMIN` · `L12` |
| `PayType` | `Hourly` · `Salary` |
| `ClassCode` | `ACCOUNTING` · `DISPATCH` · `FIELD EMP` · `HR` · `MANAGEMENT` · `MECH LABOR` · `OFC ADMIN` · `OWNER` · `SAFETY DEP` · `SALES` · `SUPERINTEN` · `YARD LABOR` |
| `EmpType` | `3rd Man` · `Accounting Admin` · `Driver` · `Management` · `Mechanic` · `Oiler` · `Operator` · `Rigger` · `Safety Admin` · `Sales Admin` · `Salesmen` · `Yard Man` |
| `CraftCode` | `ADMIN` · `L12-APP2` · `L12-APP3` · `L12-APP5` · `L12-APP6` · `L12-BG` · `L12-G1` … `L12-G9` |

The roster table's columns: `EmployeeName · EmpID · ADPFileNo · ClassCode · EmpType · UnionCode
· PayType · CraftType · CraftCode · EmployeePayRate · FY25-26 · FY26-27 · FirstName · LastName ·
SheetName` — blue headers are FCC data, tan (`ADPFileNo`, `SheetName`) come from the Emp_ADP#s
sheet. A pattern holds in every visible row: employees with `UnionCode L12` / `PayType Hourly`
/ `CraftType L12` have a **blank `EmployeePayRate` and values in `FY25-26` and `FY26-27`**;
employees with `CraftType ADMIN` (salaried or hourly non-union) have an **`EmployeePayRate` and
blank FY columns**. That is, the FY columns are the craft-rate lookup by fiscal year and
`EmployeePayRate` is FCC's own rate — the screenshot shows the pattern; the SOP does not state
it as a rule. Individual rates were not copied.

Dialogs: *"Refresh Complete — Sheet update complete! Worksheet: PAYROLL_START / Connected
tables refreshed: 1 / PivotTables refreshed: 0"* (the same dialog names `ADP_IMPORT_REVIEW` and
`ADP_IMPORT_VALIDATION` on those sheets); *"Create Employee Sheets — Source worksheet:
PAYROLL_START / 2 employee sheet(s) created. Employee worksheets ordered alphabetically. / 2
row(s) skipped: – Missing required ADPFileNo for <name> [EmpID nnnn]"*.

**An employee sheet.** Column order as captured: `Employee · Unit_Asset · Date · Day` |
`Total Hrs · Hrs_Match · ST · OT · DT · H2x · H3x` | (Lattice / Shift Differential — not
recoverable) | `Craft Modifier · LB_Total · LB_Match · LB ST · LB ST Rate · LB OT · LB OT Rate
· LB DT · LB DT Rate · LB 3X · LB 3X Rate`. Rows run Sat 7/25/2026 → Fri 7/31/2026. `Unit_Asset`
holds a unit number (`10001` in the example). `Hrs_Match` shows a red ✗ until the buckets sum
to `Total Hrs`, then a green ✓; a weekly summary row below repeats `Total Hrs · Hrs_Match · ST
· OT · DT · H2x · H3x`. The `Craft Modifier` dropdown values are boom-length brackets suffixed
by role — `080-100Ft-Oiler`, `101-120Ft-Oiler`, `121-140Ft-Oiler`, `141-160Ft-Oiler`, …,
`181-200Ft-Oiler` (the Operator entries were below the visible scroll). The worked example
selects `181-200Ft-Oiler` with `LB_Total 5.0 = LB ST 4.0 + LB OT 1.0`, and the sheet shows
**`LB ST Rate $1.50` and `LB OT Rate $2.25`** — the OT adder is the ST adder × 1.5, as the
column-rules page states.

> The SOP's own illustration keys **8.0 ST + 2.0 OT on a Saturday**. The sheet accepts it —
> `Hrs_Match` only checks the sum — which is the point column-rules makes (*"the workbook does
> not calculate"*), but it sits against that page's *"Saturday can never show ST"*. Whether the
> example is a deliberate simplification or a real week is not stated.

**ADP_IMPORT_REVIEW.** Title *"ADP Import Review"*, caption *"Click to refresh ADP Import data
below…"*, `Refresh All`. Columns: `ReviewRow · Co Code · Batch ID · File # · Name · Reg Hours ·
O/T Hours · H3_Code_01 · H3_Amount_01 · H3_Co[de_02] …` — the "Hours 3" code/amount pairs are
numbered. `Co Code` is `4RZ`; `Batch ID` is a six-digit number (`260833` in the ADP-week-33
example; how it is composed is not stated). An employee with double time gets a **second
`ReviewRow` carrying `H3_Code_01 = DT` and the DT hours in `H3_Amount_01`** — DT travels to ADP
as an Hours-3 code, not as a third hours column.

**ADP_IMPORT_VALIDATION.** Title *"ADP Import Validation"*, `Refresh All`, caption *"Click to
generate CSV file for ADP Import"* over a CSV-download icon button. Columns: `Severity ·
IssueCode · IssueMessage · ReviewRow · File # · Name · RowType · RateCode · Temp Rate ·
ADPFileName`. Two states are shown:

| Severity | IssueCode | IssueMessage | ADPFileName |
| --- | --- | --- | --- |
| `ERROR` | `REVIEW_EMPTY` | *qADPImportReview contains no rows.* | |
| `PASS` | `READY` | *No ADP import validation errors or warnings were found.* | `EPI4RZ33` |

`qADPImportReview` is the Power Query behind the review sheet. The blocked-export dialog:
*"ADP Export Blocked — 1 ADP validation error(s) must be corrected before the CSV can be
exported. – ERROR [REVIEW_EMPTY]: qADPImportReview contains no rows."* The Windows save dialog
is titled *"Choose the folder for the ADP Paydata CSV"*. No other `IssueCode` values are shown.

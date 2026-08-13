---
title: PAYROLL for ADP - Standard Operating Procedure v3.8
source: onedrive/OneDrive_1_8-11-2026/PAYROLL for ADP v3.0 - current/PAYROLL for ADP - SOP v3.8.docx
migrated: 2026-08-13
updated: 2026-08-05
status: unverified
conflicts_with: []
jira: []
topics: [payroll, adp-export, legacy-process, standard-operating-procedure]
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

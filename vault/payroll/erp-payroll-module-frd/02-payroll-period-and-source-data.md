---
title: The Crane Guys ERP Payroll Module - Payroll period, processing calendar and source data
source: onedrive/OneDrive_1_8-11-2026/The Crane Guys ERP Payroll Module.pdf
migrated: 2026-08-13
updated: 2026-08-05
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/frd, provenance]
entities: [pay-period, employee-master, labor-entry, job-ticket, adp-file-number]
part_of: payroll/erp-payroll-module-frd/INDEX.md
---

## 3. Payroll Period and Processing Calendar

### PR-001 — Payroll Workweek

Current TCG requirement

The legal and operational payroll week is:

- Saturday through Friday

Required information

- Work date
- Pay-period calendar
- Pay-period start and end dates
- Pay-period status
- Employee status during the period

System trigger

When a user selects any date, the system must identify the Saturday-through-Friday payroll period
containing that date.

Required processing

The system must:

1. group labor and payroll calculations into the proper payroll week;
2. accumulate weekly hours within that week;
3. prevent approved or processed periods from being unintentionally recalculated;
4. allow authorized users to reopen or recalculate a period with a recorded reason;
5. preserve the originally approved payroll snapshot.

Outputs

- Pay-period header
- Start date
- End date
- Status
- Calculation run
- Approval status
- Processed date and user
- Export status

### PR-002 — Payroll Period Status

Recommended statuses:

- Open
- Source Data Loaded
- Calculated
- Needs Review

- Approved
- Exported
- Processed/Closed
- Reopened
- Corrected

The ERP must record every status change, the user who made the change, the date and time, and any
required explanation.

## 4. Source Data Collection

### PR-003 — Required Employee Master Information

The employee master should provide at least:

- Employee ID
- Employee name
- Employment status
- Hire/start date
- Termination date
- Employee CraftCode
- Employee Type ID
- Pay type: hourly or salary
- Union code
- Employee pay rate
- Office/field indicator
- Payroll group
- Home yard or reporting location
- ADP File Number
- Apprentice status and step, when applicable
- Relevant classification or class code
- Burden and workers’ compensation codes, when needed
- Eligibility for union rules and fringe contributions

ADP File Number

The ADP File Number should:

- be stored as text;
- preserve leading zeros;
- permit uppercase letters and numbers;
- have a maximum length of six characters;
- be unique among active ADP mappings.

Payroll-team users may view the number. Editing should be limited to authorized roles such as payroll
manager and IT administrator.

### PR-004 — Required Labor Entry Information

Each labor entry should provide at least:

- Labor entry ID
- Employee ID
- Work date
- Start time
- End time
- Source-reported hours
- Job code
- Work-order code
- Job-ticket number
- Labor-entry CraftCode
- Craft modifier or boom code
- Shift code or shift token
- Worked-through-lunch token
- Subsistence token or eligibility data
- Labor type
- Activity/classification
- Source-reported rate
- Source-reported amount
- User-entered comments
- Source record creation and modification dates

The ERP must retain the original source values even when normalized values are used for payroll
calculation.

### PR-005 — Required Job-Ticket and Equipment Information

Where applicable, the system should receive:

- Job-ticket ID
- Job code
- Work-order code
- Customer
- Job location
- Yard departure time
- Arrival time
- Work start time
- Work end time
- Job departure time
- Yard return time
- Equipment/unit
- Crane capacity

- Crane type
- Boom type
- Actual boom length
- Whether an oiler or second operator is required
- Whether equipment remained at the job for future work
- Whether the work was travel, assembly, preparation, operation, maintenance, or customer work

Job-ticket information may be used to validate labor entries and determine boom windows, shift windows,
subsistence, travel, minimum guarantees, and equipment-based premiums.

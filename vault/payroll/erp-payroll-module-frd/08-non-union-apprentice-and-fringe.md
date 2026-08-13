---
title: The Crane Guys ERP Payroll Module - Non-union payroll rules, apprentice steps, fringe and other payments
source: onedrive/OneDrive_1_8-11-2026/The Crane Guys ERP Payroll Module.pdf
migrated: 2026-08-13
updated: 2026-08-05
status: unverified
conflicts_with: []
jira: []
topics: [payroll, erp-payroll, non-union, fringe-benefits]
entities: [non-union-hourly, non-union-salary, apprentice-step, fringe-contribution]
part_of: payroll/erp-payroll-module-frd/INDEX.md
---

## 16. Non-Union Payroll Rules

### PR-041 — Non-Union Admin Hourly

This payroll group should use the employee-master hourly rate.

The intended rule path includes California nonexempt overtime processing, including applicable daily,
weekly, and consecutive-day logic. Exact legal calculations, inclusion/exclusion of paid non-worked time,
and interaction among premium rules must be reviewed and approved before production implementation.

Rules that should generally not apply to this group unless separately configured:

- L12 outside-window overtime
- L12 holiday calendar and multipliers
- L12 special Saturday
- L12 guaranteed-hours rules
- L12 boom premiums
- L12 shift rules
- L12 rest-period premium
- L12 WTL-token requirement
- L12 subsistence
- L12 ticket requirements

Duplicate, overlap, missing-time, missing-rate, and other source-data validations should still apply.

### PR-042 — Non-Union Admin Salary

Salary employees should follow a separate salary-review workflow.

Recommended review items:

- salary amount;
- pay frequency;
- salary effective date;
- exempt/nonexempt classification;
- expected salary payment for the period;
- unpaid leave or partial-period adjustment;
- approved additional compensation;
- missing or inconsistent salary setup.

Labor entries may be retained for job costing without automatically changing salary payroll.

## 17. Apprentice, Fringe, and Trust-Fund

Requirements

### PR-043 — Apprentice Wage Step

The agreement establishes apprentice wage percentages based on accumulated hours.

The ERP needs:

- apprentice status;
- indenture date;
- accumulated qualifying hours;
- current step;
- applicable base journeyman group;
- effective percentage;
- step advancement date;
- manual correction history.

The system should automatically create a review when accumulated hours indicate that the employee
should advance to the next step.

### PR-044 — Fringe Contributions

The ERP should maintain effective-dated contribution rates for:

- Health and Welfare
- Pension
- Defined Contribution/Annuity
- Vacation-Holiday
- Apprenticeship and Retraining
- Supplemental Dues
- Political Action Committee, when applicable
- Contract Administration/Promotion Fund

The agreement generally requires contributions on hours worked or paid, including straight-time and
overtime hours, rather than multiplying contribution hours by the wage multiplier.

The ERP must separately calculate:

- wage hours;
- paid guarantee hours;
- contribution hours;
- non-contributory paid hours;
- contribution rate;

- contribution amount;
- trust/fund;
- reporting period.

Special handling is required for the first apprentice step because pension contributions may not apply
during the initial 1,000 hours for qualifying apprentices.

## 18. Other Payroll and Reimbursement

Requirements
The following requirements may be implemented in Payroll, HR, Expenses, or a connected module, but they
must be accounted for in the ERP design:

- vacation eligibility after the required service and hour threshold;
- vacation pay;
- injury-day full-day pay;
- approved monthly cell-phone reimbursement;
- parking reimbursement;
- approved tool replacement;
- final wages for terminated employees;
- waiting-time calculations when final wages are not timely;
- reporting pay;
- drug-testing and pre-trip-inspection work time;
- approved portal-to-portal travel;
- mileage reimbursement;
- toll reimbursement.

Each item should have:

- an effective-dated rule;
- eligibility criteria;
- structured supporting data;
- approval workflow;
- payroll earning or reimbursement code;
- audit documentation.

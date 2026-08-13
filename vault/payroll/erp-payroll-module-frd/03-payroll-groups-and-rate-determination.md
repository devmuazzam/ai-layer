---
title: The Crane Guys ERP Payroll Module - Employee payroll groups and rate determination
source: onedrive/OneDrive_1_8-11-2026/The Crane Guys ERP Payroll Module.pdf
migrated: 2026-08-13
updated: 2026-08-05
status: unverified
conflicts_with: []
jira: []
topics: [payroll, erp-payroll, payroll-group, rates]
entities: [payroll-group, union-craft-rate, craft-modifier, employee-pay-rate]
part_of: payroll/erp-payroll-module-frd/INDEX.md
---

## 5. Employee Payroll Groups

### PR-006 — Payroll Group Determination

The ERP should support the following payroll groups:

1. L12 Labor Union Field
2. L12 Labor Union Mechanic
3. Non-Union Admin Hourly
4. Non-Union Admin Salary
5. System-Testing-VendorAccess

Worklist-level classification

The main employee worklist should determine the employee’s payroll group from the employee master.

Current classification design:

  Payroll group                  Employee-master indicators

                                 Employee CraftCode begins with L12 and Employee Type ID is not the
  L12 Labor Union Field
                                 mechanic value

                                 Employee CraftCode begins with L12 and Employee Type ID indicates
  L12 Labor Union Mechanic
                                 mechanic

  Non-Union Admin Hourly         Employee CraftCode begins with ADMIN and PayType is hourly

  Non-Union Admin Salary         Employee CraftCode begins with ADMIN and PayType is salary

  System-Testing-
                                 Employee CraftCode begins with the designated SYS code
  VendorAccess

System-testing, vendor-access, placeholder, and fake employees must not appear in the production payroll
worklist.

Labor-entry rule classification

For individual labor-entry calculations, the system should evaluate:

- the CraftCode recorded on the labor entry;
- the employee’s Employee Type ID;
- the employee’s pay type;
- the employee’s union status;
- any authorized payroll-group override.

This distinction is important because an employee may perform work under a labor-entry craft that differs
from the employee-master craft.

Exception handling

The system must create a review issue when:

- the employee master and labor-entry classification conflict;
- the payroll group cannot be determined;
- the employee has an unsupported CraftCode;
- an active employee is assigned to a system/testing group;
- a manual payroll-group override is used.

## 6. Rate Determination

### PR-007 — L12 Union Base Rate

Applies to

- L12 Labor Union Field
- L12 Labor Union Mechanic, subject to confirmed rule eligibility

Required information

- Labor-entry CraftCode
- Union code
- Work date
- Effective-dated union craft rate
- Employee and labor-entry classification

System trigger

The labor-entry CraftCode begins with L12 , and the employee/labor entry is eligible for the L12
agreement.

Required processing

The base straight-time rate must be obtained by joining the labor-entry CraftCode to the effective-dated
union craft rate.

The current ERP target design is:

L12 base rate = union craft rate for the labor-entry CraftCode.

The source-reported labor rate should be retained for audit and comparison, but it should not automatically
replace the contractual union craft rate.

Important migration note

The May 29, 2026 technical walkthrough describes the then-current Payroll App as using
Source_Rate_Raw as the pricing base-rate truth.

Later TCG design decisions changed the target model for the ERP:

- L12 base rate should come from the union craft table.
- The modifier should come from the union craft modifier table.
- The source rate should be audit/reference information because it may already contain both the base
craft rate and the modifier.

CodingCops should implement the later target design rather than copying the older Source_Rate_Raw
calculation behavior without review.

### PR-008 — L12 Craft Modifier / Boom Rate

Required information

- Labor-entry CraftCode
- Craft modifier code
- Union code
- Effective date
- Applicable boom or modifier window

System trigger

The labor entry contains a valid modifier code and the employee is eligible for the modifier.

Required processing

The modifier rate must be obtained from the effective-dated union craft modifier table.

Target formula:

L12 hourly rate before multiplier = union craft base rate + applicable modifier +
applicable shift premium

The modifier must not be added a second time when the source-reported rate already contains the
modifier.

Outputs

- Modifier code
- Modifier rate
- Applicable modifier hours
- Modifier pay
- Source of modifier window
- Missing or invalid modifier issue

### PR-009 — Non-Union Hourly Rate

Applies to

- Non-Union Admin Hourly

Required information

- Employee master PayRate
- Effective date
- Pay type
- Payroll group

System trigger

Payroll group equals Non-Union Admin Hourly.

Required processing

The base hourly rate must come from the employee master, not from the union craft or union modifier
tables.

Union boom, guaranteed-hours, special Saturday, L12 holiday, L12 shift, WTL-token, union rest, and union
subsistence rules must not be applied unless a separate configuration explicitly makes them applicable.

### PR-010 — Non-Union Salary Rate

Applies to

- Non-Union Admin Salary

The system should retain:

- employee salary or employee pay rate;
- the method by which the source system stores the salary;
- approximate annual equivalent;
- approximate monthly equivalent;
- approximate hourly equivalent, when needed for reporting.

Salary employees should not be routed through the nonexempt hourly overtime engine unless
management specifically classifies the employee as nonexempt.

The system should support a separate review rule for salary classification and minimum exempt-salary
thresholds. Final legal requirements must be confirmed by management and employment counsel.

### PR-011 — Rate Validation

The ERP should compare available rates and produce review issues for:

- missing union craft rate;
- missing employee-master rate;
- missing modifier rate;
- source rate substantially above or below the configured rate;
- source rate that appears to include an unrecognized modifier;
- inactive or expired rate;
- multiple active rates;
- negative or zero rates;
- labor-entry craft incompatible with employee payroll group.

Rate differences should normally be warnings or review items rather than silent substitutions.

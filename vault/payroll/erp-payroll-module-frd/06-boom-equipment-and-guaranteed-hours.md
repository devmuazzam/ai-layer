---
title: The Crane Guys ERP Payroll Module - Boom, equipment, special rates, reporting time and guaranteed hours
source: onedrive/OneDrive_1_8-11-2026/The Crane Guys ERP Payroll Module.pdf
migrated: 2026-08-13
updated: 2026-08-05
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/frd, boom, guaranteed-hours]
entities: [long-boom-premium, lattice-boom, reporting-pay, guaranteed-hours]
part_of: payroll/erp-payroll-module-frd/INDEX.md
---

## 11. Boom, Equipment, and Special Rate Rules

### PR-026 — Long Boom Pay

The agreement establishes additional hourly pay based on boom length and specifies that the premium
becomes part of the base rate when calculating overtime.

The ERP will need:

- crane type;
- crane group;
- operator or oiler classification;
- boom length;
- jib length;
- whether the boom is lattice or telescopic;
- actual period during which the qualifying boom was used;
- applicable four-hour job minimum;
- whether time is travel or curfew time, when long-boom pay does not apply.

The current Payroll App uses source craft modifiers and ticket boom windows. CodingCops should
determine whether that source data fully supports the agreement’s tiered boom-length requirements.

### PR-027 — Lattice Boom Premium

For qualifying Group 6 and above equipment, the agreement provides separate additional rates for
operators and oilers.

The ERP must avoid combining this rule with ordinary long-boom tiers unless both are contractually
applicable.

### PR-028 — Hazardous Material Premium

Employees required to suit up and perform qualifying Level A or Level B hazardous-material work receive an
additional hourly amount that becomes part of the base rate.

Required trigger information:

- hazardous-work indicator;
- Level A or Level B classification;
- qualifying work start and end times;
- approval or job designation;
- employee working-partner requirement.

### PR-029 — Higher Rate for Entire Day

When an L12 employee works at a higher rate during the day, the agreement may require that higher rate
to apply to all time worked on that job or during that calendar day, subject to stated exceptions.

The ERP must:

1. identify all rates worked by the employee during the applicable day;
2. determine the highest qualifying rate;
3. recalculate affected labor entries;
4. preserve the original labor-entry rate;
5. create a higher-rate true-up component;
6. display why the higher rate was selected.

This rule should be confirmed carefully because the agreement contains both “job during that day” and
broader “entire calendar day” language in different sections.

## 12. Reporting Time and Guaranteed Hours

### PR-030 — Reporting With No Work Provided

The agreement generally provides two hours of reporting pay when an employee reports at the regular
starting time and no work is provided, subject to notification and inclement-weather exceptions.

Required information:

- employee reported indicator;
- scheduled reporting time;
- actual arrival;
- whether work was provided;
- prior notification;
- time of notification;
- inclement-weather policy;
- reason no work was provided.

### PR-031 — Work Provided Minimum

An employee who reports and is provided work generally receives at least four hours of pay.

The ERP must distinguish:

- actual worked hours;
- guaranteed added hours;
- rate and multiplier applied to actual hours;
- rate and multiplier applied to guarantee hours;
- reason for the guarantee.

### PR-032 — Crane Remaining on Job

For qualifying subsequent days when the crane remains on the job, the agreement includes an eight-hour
minimum, with different minimums for certain rain, wind, mechanical, or electronic shutdown scenarios.

Potential outcomes include:

- minimum four hours;
- minimum six hours;
- minimum eight hours;
- actual hours when greater than the applicable minimum.

Required source information:

- first day or subsequent day;
- equipment remained on job;
- shutdown reason;
- whether employee was requested to remain;
- actual hours worked;
- dispatcher contact;
- alternative work offered;
- customer work performed.

This is a complex rule and should be modeled as a decision tree rather than a single “minimum hours” field.

### PR-033 — First-Day Travel, Assembly, or Preparation

The agreement states that the eight-hour minimum does not automatically apply when the first day
consists only of travel, assembly, or preparation.

The ERP needs an activity classification that distinguishes:

- travel;
- assembly;
- preparation;
- customer work;
- crane operation;
- maintenance;
- standby.

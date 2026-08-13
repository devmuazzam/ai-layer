---
title: The Crane Guys ERP Payroll Module - Purpose, scope and core design principles
source: onedrive/OneDrive_1_8-11-2026/The Crane Guys ERP Payroll Module.pdf
migrated: 2026-08-13
updated: 2026-08-05
status: unverified
conflicts_with: []
jira: []
topics: [payroll, erp-payroll, requirements]
entities: [payroll-rule, payroll-group, pay-component]
part_of: payroll/erp-payroll-module-frd/INDEX.md
---

The Crane Guys ERP Payroll Module
Payroll Business Rules and System Requirements
Document status: Draft 0.1 – Initial requirements catalog
Prepared for: CodingCops
Company: The Crane Guys
Purpose: Define the activities, source information, payroll rules, system triggers, calculations, review
controls, and outputs required for the Payroll module of the new ERP system.

## 1. Purpose and Scope

The Payroll module must convert employee, labor, job-ticket, rate, schedule, and configuration data into a
complete, auditable payroll result.

The module must do more than calculate gross wages. It must also:

1. Determine which payroll rules apply to each employee and labor entry.
2. determine the correct base rate and premium rates;
3. reconstruct payable work time;
4. classify hours as straight time, overtime, double time, or another premium category;
5. apply guaranteed or minimum paid hours;
6. calculate additional pay such as shift premiums, boom premiums, rest-period premiums, meal-
period adjustments, and subsistence;
7. identify missing or inconsistent source information;
8. allow payroll personnel to review the calculations;
9. preserve an audit trail showing exactly why each amount was paid;
10. export approved payroll results to ADP or another payroll provider.

The existing TCG Payroll App provides a technical and functional baseline, including a SQL pricing engine,
30-minute pricing slices, guarantee processing, rest-period processing, WTL processing, a pay-component
ledger, exceptions, API surfaces, and browser review pages.

This document describes the intended ERP requirements. It should not be interpreted as final legal advice.
Union contract interpretations and California payroll rules should be reviewed and approved by The Crane
Guys’ management, payroll team, labor counsel, and union representatives where necessary.

## 2. Core Design Principles

2.1 Configuration-Driven Rules
Payroll rules must not be embedded exclusively in application code.

The ERP should maintain effective-dated configuration tables for:

- employee payroll groups;
- employee-group rule eligibility;
- union agreements;
- craft rates;
- craft modifiers;
- shift premiums;
- overtime and double-time thresholds;
- holidays;
- special Saturdays;
- minimum-pay and guaranteed-hours policies;
- rest-period requirements;
- meal-period rules;
- subsistence rates;
- fringe-benefit contribution rates;
- payroll issue severity;
- mileage and reimbursement rates;
- effective dates.

A payroll rule change should normally be accomplished by updating an effective-dated configuration record
rather than changing program code.

2.2 Explainable Calculations
Every calculated dollar must be traceable to:

- the employee;
- the labor entry;
- the applicable payroll group;
- the source work time;
- the base rate;
- any premium rate;
- the applicable multiplier;
- the number of hours;
- the rule that created the amount;
- the configuration version in effect;
- the payroll calculation run;
- any manual adjustment or approval.

2.3 Rule Eligibility Before Rule Calculation
The system must first determine whether a rule applies.

For example, the system should not calculate a union meal-period rule and later remove it from a non-
union employee. It should determine that the rule is not applicable before running the calculation.

Each rule should support one of the following outcomes for each payroll group:

- Calculate
- Review only
- Warn
- Not applicable
- Blocked pending missing information

2.4 Effective-Dated Processing
Rates, rules, holidays, classifications, contribution amounts, and policies must be effective-dated.

When recalculating a historical payroll period, the ERP must use the configuration that was effective on the
work date—not the configuration that is active today.

2.5 No Unexplained Overwriting
Source information should be preserved even when the ERP determines that a different value must be
used.

For example, the system may store:

- source-reported rate;
- employee-master rate;
- union craft rate;
- craft modifier;
- calculated effective rate;
- final approved rate;
- reason the final rate was selected.

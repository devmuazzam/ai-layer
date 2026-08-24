---
title: The Crane Guys ERP Payroll Module - Security, required decisions, acceptance criteria and implementation priority
source: onedrive/OneDrive_1_8-11-2026/The Crane Guys ERP Payroll Module.pdf
migrated: 2026-08-13
updated: 2026-08-05
status: unverified
conflicts_with: []
jira: []
tags: [module/admin, module/payroll, kind/frd, permissions-roles, requirements]
entities: [payroll-role, acceptance-criteria, implementation-phase]
part_of: payroll/erp-payroll-module-frd/INDEX.md
---

## 24. Security and Roles

Recommended payroll roles:

| Role | Typical permissions |
| --- | --- |
| Payroll Team | View calculations, review issues, enter notes |
| Payroll Manager | Approve payroll, edit authorized mappings, enter adjustments |
| Operations Manager | Review labor/job information and resolve operational issues |
| HR | Maintain employee/pay classification data |
| IT Administrator | Maintain integrations and technical configuration |
| ERP Administrator | Maintain effective-dated rule configuration |
| Read-Only Auditor | View source data, calculations, approvals, and snapshots |

Changes to rates, rule configuration, employee payroll groups, external identifiers, and approved payroll
results must be audited.

## 25. Required Management and Legal Decisions

The following issues should be resolved before CodingCops treats the rule catalog as final:

1. Exact employee-type and payroll-group mapping.
2. Final separation between L12 Field and L12 Mechanic rules.
3. Which L12 rules apply to mechanics.
4. Final non-union hourly overtime matrix.
5. Salary employee payroll and labor-costing treatment.
6. Half-hour rounding method.
7. Source priority for labor times and job-ticket times.
8. Cross-midnight day-type policy.
9. Sunday minimum-pay requirement.
10. Exact reporting-time and crane-remains-on-job decision tree.
11. Long-boom and lattice-boom source-data requirements.
12. Higher-rate-for-the-day interpretation.
13. Worked-meal calculation for weekdays versus weekends and holidays.
14. WTL token replacement with structured meal records.
15. Subsistence distance calculation and employer-election workflow.
16. Portal, mileage, and toll processing.
17. Apprentice-hour accumulation source.
18. Fringe-benefit contribution treatment for each paid component.
19. Vacation, final-pay, waiting-time, and injury-day integration.
20. ADP earning-code and export mapping.
21. Which errors block payroll approval.
22. Who may reopen a processed payroll period.
23. Required record-retention period.
24. Required supporting attachments and approvals.

## 26. Recommended CodingCops Requirements

### Matrix

CodingCops should maintain a detailed implementation matrix with one row per rule.

Recommended columns:

| Column | Description |
| --- | --- |
| Rule ID | Permanent identifier such as PR-034 |
| Rule name | Human-readable rule |
| Rule category | Rate, time, premium, guarantee, reimbursement, validation |
| Agreement/source | Contract article, management policy, or legal requirement |
| Payroll groups | Groups to which the rule applies |
| Effective from/to | Rule-effective dates |
| Required inputs | Source fields needed |
| Trigger | Condition that starts the rule |
| Calculation | Formula or decision tree |
| Priority | Interaction with other rules |
| Output component | Payroll component produced |
| Tax/fringe treatment | How the amount is reported |
| Severity when missing | Error, warning, review, ignore |
| User override | Whether override is allowed |
| Approval required | Required approver |
| UI display | Where the result is shown |
| Test cases | Required validation scenarios |
| Status | Draft, confirmed, developed, tested, approved |

## 27. Acceptance Criteria

A payroll rule should not be considered complete until:

1. the business rule is documented;
2. applicable payroll groups are confirmed;
3. required source information is available;
4. effective dates are supported;
5. the calculation is represented as a pay component;
6. missing-data behavior is defined;
7. the result is visible in the review interface;
8. manual override behavior is defined;
9. audit history is preserved;
10. normal and edge-case tests pass;
11. management approves the result;
12. payroll staff validate real employee examples;
13. the ADP export treatment is confirmed.

## 28. Initial Implementation Priority

Recommended implementation sequence:

Phase 1 – Foundation

- Pay-period calendar
- Employee payroll groups
- Employee and labor source integration
- Effective-dated configuration
- Rate resolution
- Time reconstruction
- Pay-component ledger
- Issues and audit logging

Phase 2 – Core L12 Rules

- Straight time, overtime, and double time
- Outside-window overtime
- Saturday, Sunday, and holidays
- Special Saturdays
- Shift rules
- Boom/modifier premiums
- Guaranteed hours
- Rest-period premium
- WTL/meal periods
- Subsistence

Phase 3 – Non-Union Rules

- Non-Union Admin Hourly
- Non-Union Admin Salary
- Employee-specific earning policies
- Salary and nonexempt review controls

Phase 4 – Fringe and Payroll Export

- Apprentice steps
- Fringe contributions
- ADP mapping
- ADP export
- Payroll approval and snapshot
- Corrections and retroactive adjustments

Phase 5 – Additional Contractual Payments

- Mileage
- Toll reimbursement

- Parking
- Cell phone
- Vacation
- Injury-day pay
- Final-pay and waiting-time workflows
- Other approved contractual payments

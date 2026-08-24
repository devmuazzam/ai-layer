---
title: The Crane Guys ERP Payroll Module - Approval, close, export and manual adjustments
source: onedrive/OneDrive_1_8-11-2026/The Crane Guys ERP Payroll Module.pdf
migrated: 2026-08-13
updated: 2026-08-05
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/frd, adp]
entities: [payroll-snapshot, adp-export, manual-adjustment, calculation-run]
part_of: payroll/erp-payroll-module-frd/INDEX.md
---

## 22. Approval, Close, and Export

### PR-052 — Payroll Calculation Run

Every calculation run must record:

- run ID;
- period;
- source-data version;
- configuration version;
- start and end time;
- user or scheduled process;
- status;

- employee count;
- labor-entry count;
- issue counts;
- error message;
- superseded run, when applicable.

### PR-053 — Approval

The system should support approval at one or more levels:

- labor entry;
- employee/day;
- employee/pay period;
- complete pay period.

Approval should be blocked when unresolved critical errors remain.

### PR-054 — Payroll Snapshot

When payroll is approved or processed, the ERP must preserve a frozen snapshot containing:

- employee setup used;
- source labor data;
- calculated hours;
- rates;
- pay components;
- issues;
- overrides;
- approvals;
- export values.

Later recalculations must not change the historical snapshot.

### PR-055 — ADP Export

The export should include:

- ADP File Number;
- earning code;
- regular hours;
- overtime hours;
- double-time hours;
- additional earnings;
- reimbursements, where appropriate;
- department/job allocation where required;
- pay-period dates;
- correction or adjustment indicator.

The system must validate required ADP mappings before generating the export.

## 23. Manual Adjustments and Overrides

Authorized users should be able to enter controlled adjustments.

Every adjustment must require:

- employee;
- pay period;
- work date, when applicable;
- earning or component code;
- hours, rate, or amount;
- reason;
- supporting note or attachment;
- requesting user;
- approving user;
- creation and approval timestamps.

The system must never overwrite the original calculated value. It should add a separate adjustment
component and show the resulting final amount.

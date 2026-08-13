---
title: The Crane Guys ERP Payroll Module - Data quality rules, pay component ledger and payroll review interface
source: onedrive/OneDrive_1_8-11-2026/The Crane Guys ERP Payroll Module.pdf
migrated: 2026-08-13
updated: 2026-08-05
status: unverified
conflicts_with: []
jira: []
topics: [payroll, erp-payroll, pay-component-ledger, payroll-review]
entities: [pay-component, payroll-exception, worklist]
part_of: payroll/erp-payroll-module-frd/INDEX.md
---

## 19. Data Quality and Payroll Review Rules

### PR-045 — Missing Information

The ERP should identify at least:

- missing employee;
- inactive employee with labor;
- missing payroll group;
- missing CraftCode;
- missing base rate;
- missing modifier rate;
- missing time;
- zero-duration time;
- invalid cross-midnight time;
- missing job or work order;
- missing required ticket;
- missing shift identifier;
- missing WTL information;
- missing subsistence eligibility information;
- missing ADP File Number before export.

### PR-046 — Duplicate and Overlapping Labor

The system should detect:

- exact duplicate labor windows;
- duplicate source labor IDs;
- same employee with overlapping entries;
- grouped WTL entries that overlap;
- multiple employees improperly assigned to the same required equipment position;
- conflicting job-ticket and labor windows.

These items should not necessarily stop the entire payroll run. They should be assigned configurable
severities:

- Error
- Warning
- Review
- Informational
- Ignored for this payroll group

### PR-047 — Assumed or Reconstructed Time

When the ERP cannot use reliable actual times and constructs a shift from reported hours or another
fallback, the record should be marked:

- Shift assumed
- Time source used
- Confidence level
- Review required
- User approval, when applicable

## 20. Pay Component Ledger

### PR-048 — Componentized Payroll Result

The ERP should not store only one final gross number.

Each payroll result should be separated into components such as:

- Actual base worked pay
- Actual boom/modifier pay
- Actual shift premium
- Daily overtime
- Daily double time
- Saturday premium
- Sunday premium
- Holiday premium
- Special Saturday pay
- Guaranteed base pay
- Guaranteed boom pay
- Rest-period premium
- WTL adjustment
- Shift paid-hours addition
- Subsistence
- Mileage reimbursement
- Toll reimbursement
- Other approved earnings
- Rounding adjustment
- Manual correction

For each component, store:

- component code;
- component group;
- employee;

- labor entry;
- work date;
- hours or units;
- base rate;
- premium rate;
- multiplier;
- amount;
- rule ID;
- configuration record;
- inclusion in gross wages;
- inclusion in taxable wages;
- inclusion in fringe hours;
- inclusion in payable total;
- explanation.

The existing Payroll App already uses an auditable pay-component ledger, which is a strong model for the
ERP design.

## 21. Payroll Review Interface

### PR-049 — Employee Worklist

The worklist should show:

- employee;
- payroll group;
- ADP File Number;
- employment status;
- pay-period hours;
- straight-time hours;
- overtime hours;
- double-time hours;
- gross wages;
- payable additions;
- error count;
- warning count;
- review count;
- approval status;
- notes;
- last calculation date.

System/testing employees must be excluded.

### PR-050 — Employee Detail

The employee detail page should provide:

- daily summary;
- labor entries;
- job and work-order information;
- ticket number;
- source times;
- reconstructed times;
- pricing slices;
- rate source and rate comparison;
- boom/modifier detail;
- shift detail;
- guarantee detail;
- rest-period detail;
- WTL detail;
- subsistence detail;
- pay-component ledger;
- issues;
- notes;
- manual adjustments;
- approval history.

### PR-051 — Rule Explanation

For each amount, the user should be able to see a plain-language explanation such as:

6.0 actual hours were worked on a Local 12 holiday. The holiday rule guarantees 8.0 paid
hours at 3.0 times the applicable base rate. The system added 2.0 guaranteed holiday hours.

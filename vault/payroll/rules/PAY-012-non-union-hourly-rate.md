---
id: PAY-012
title: PAY-012 — Non-union hourly rate
section: B-group-and-rate
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-012 — Non-union hourly rate

**Rule:** Use employee-master hourly rate; do not use union craft rate.

**Applies to:** Non-Union Admin Hourly. **Trigger:** Payroll group is hourly admin.
**Requires:** Employee PayRate; effective date.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-012` — baseline: *TCG design direction*
- **FRD** (target design): [03-payroll-groups-and-rate-determination.md](../erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md) `PR-009` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §12

## Open

- **Blocking (matrix):** Confirm rate-effective-date handling
- **Client confirmation, client message 2026-06-09 (Brian Petros — payroll-group determination + FCC profile screenshot):** `Base hourly rate = Employee.PayRate` ("very important"), CA DIR overtime rules linked (dir.ca.gov/dlse/faq_overtime). Display approximations ×40 / ×2080/12 / ×2080 confirmed as-built in `v_UI_Employee_TypeRate.VIEW.sql`.
- **Blocking item grounded:** "confirm rate-effective-date handling" is no longer abstract — FCC overwrites `Employee.PayRate` in place too; the ERP's employee-rate model needs effective dating for the same reason the union table does (PAY-008).

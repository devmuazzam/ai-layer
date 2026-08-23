---
id: PAY-009
title: PAY-009 — Payroll group classification
section: B-group-and-rate
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-009 — Payroll group classification

**Rule:** Assign L12 Field, L12 Mechanic, Non-Union Hourly, Non-Union Salary, or System/Testing.

**Applies to:** All employees. **Trigger:** Employee or labor entry processed.
**Requires:** Employee CraftCode; labor CraftCode; EmpTypeID; PayType.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-009` — baseline: *Redesign required*
- **FRD** (target design): [03-payroll-groups-and-rate-determination.md](../erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md) `PR-006` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §A

## Open

- **Blocking (matrix):** Confirm final mapping rules

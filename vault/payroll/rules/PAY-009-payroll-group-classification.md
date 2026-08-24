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
- **Client confirmation, client message 2026-06-09 (Brian Petros — payroll-group determination + FCC profile screenshot):** the five groups and their exact predicates, in writing — `L12%` + `EmpTypeID <> 3` (Field) / `= 3` (Mechanic; 1 = Operator, 2 = Oiler per extract), `ADMIN%` + `PayType H/S`, `SYS%` hidden. Matches [04-payroll-group-and-rule-applicability.md](../payroll-app-current-state/04-payroll-group-and-rule-applicability.md) row-for-row. The blocking item (final ERP mapping) now has a written client baseline.

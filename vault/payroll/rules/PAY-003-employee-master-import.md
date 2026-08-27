---
id: PAY-003
title: PAY-003 — Employee master import
section: A-foundation-source-data
status: open
updated: 2026-08-27
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-003 — Employee master import

**Rule:** Maintain effective employee payroll setup.

**Applies to:** All employees. **Trigger:** Employee created or changed.
**Requires:** EmpID; name; status; CraftCode; PayType; EmpTypeID; rate; union; dates.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-003` — baseline: *Existing source baseline*
- **FRD** (target design): [02-payroll-period-and-source-data.md](../erp-payroll-module-frd/02-payroll-period-and-source-data.md) `PR-003` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §A

## Open

- **Blocking (matrix):** Confirm final ERP field mapping
- **ADP identifiers (client message 2026-08-27):** store Associate ID/OID on the employee; File # + Company Code + Position ID belong to a *position*, of which an employee may have several. `model Employee` has only `adpFileNumber`. See gaps → *Employee ↔ ADP position*.

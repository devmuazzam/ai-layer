---
id: PAY-004
title: PAY-004 — Labor-entry import
section: A-foundation-source-data
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-004 — Labor-entry import

**Rule:** Preserve source record and create payroll calculation input.

**Applies to:** Employees with labor. **Trigger:** Labor entered or source data refreshed.
**Requires:** Employee; date; time; hours; job; WO; ticket; craft; modifier; comments; rate.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-004` — baseline: *Existing baseline*
- **FRD** (target design): [02-payroll-period-and-source-data.md](../erp-payroll-module-frd/02-payroll-period-and-source-data.md) `PR-004` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §0

## Open

- **Blocking (matrix):** Confirm source ERP tables

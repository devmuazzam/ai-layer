---
id: PAY-002
title: PAY-002 — Pay-period status workflow
section: A-foundation-source-data
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-002 — Pay-period status workflow

**Rule:** Track Open, Calculated, Review, Approved, Exported, Closed, and Reopened statuses.

**Applies to:** All payroll periods. **Trigger:** Period creation, calculation, approval, export, or close.
**Requires:** Period dates; status; user; timestamp.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-002` — baseline: *Partial baseline*
- **FRD** (target design): [02-payroll-period-and-source-data.md](../erp-payroll-module-frd/02-payroll-period-and-source-data.md) `PR-002` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §0

## Open

- **Blocking (matrix):** Management approval workflow
- **Operational window (client big summary):** union payroll must be **completed by the Wednesday** after the Friday week-end; Corrina distributes checks **Thursday**. Consistent with the live ADP schedule's six-day close-to-pay gap. The ERP's processing pipeline has a hard Sat–Fri → Wed deadline.

---
id: PAY-002
title: PAY-002 — Pay-period status workflow
section: A-foundation-source-data
status: open
updated: 2026-09-04
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
- **Built shape is narrower than this rule (verified 2026-09-04):** `PayrollPeriodStatus` in `apps/api/prisma/schema.prisma:200-206` is `OPEN · CALCULATED · REVIEW · APPROVED · EXPORTED` — **`Closed` and `Reopened` do not exist**. Five of the seven statuses this rule names are built, and the two missing ones are exactly the two the client's 2026-09-04 correction question needs.

---
id: PAY-064
title: PAY-064 — Calculation run log
section: G-audit-review-export
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-064 — Calculation run log

**Rule:** Preserve calculation-run audit history.

**Applies to:** All payroll runs. **Trigger:** Calculation starts or ends.
**Requires:** Run ID; period; version; counts; status.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-064` — baseline: *Existing baseline*
- **FRD** (target design): [10-approval-close-export-and-adjustments.md](../erp-payroll-module-frd/10-approval-close-export-and-adjustments.md) `PR-052` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: no direct counterpart (new in the ERP target)

## Open

- **Blocking (matrix):** Confirm retention period
- **Golden-week fixture available:** the client preserved a complete real processed week (July 25–31 workbook + `EPI4RZ32.csv` export, `sources/`). ERP acceptance: replay that week, diff the generated export against the preserved one — the strongest single end-to-end test the record offers.


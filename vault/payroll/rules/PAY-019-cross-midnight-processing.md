---
id: PAY-019
title: PAY-019 — Cross-midnight processing
section: C-time-and-premium
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-019 — Cross-midnight processing

**Rule:** Continue into next date and apply configured calendar-day treatment.

**Applies to:** Overnight shifts. **Trigger:** End time is earlier than start time.
**Requires:** Work date; start; end; day type.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-019` — baseline: *Existing baseline*
- **FRD** (target design): [04-work-time-reconstruction.md](../erp-payroll-module-frd/04-work-time-reconstruction.md) `PR-013` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §0

## Open

- **Blocking (matrix):** Confirm final day-type policy

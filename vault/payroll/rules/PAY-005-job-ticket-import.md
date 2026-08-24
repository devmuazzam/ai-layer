---
id: PAY-005
title: PAY-005 — Job-ticket import
section: A-foundation-source-data
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-005 — Job-ticket import

**Rule:** Validate labor and supply equipment/job context.

**Applies to:** Ticket-related labor. **Trigger:** Labor entry references a job ticket.
**Requires:** Ticket times; job; equipment; work window; boom window.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-005` — baseline: *Existing baseline*
- **FRD** (target design): [02-payroll-period-and-source-data.md](../erp-payroll-module-frd/02-payroll-period-and-source-data.md) `PR-005` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §0

## Open

- **Blocking (matrix):** Confirm authoritative time fields

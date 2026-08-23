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
- **Entry-duration cap, client message 2026-06-09 (follow-up):** the legacy app handles **≤ 23.5 hours per labor entry** — a hard limit of the date/time reconstruction. Longer work must be **split into back-to-back entries**, each < 23.5 h. In no vault document before this message. ERP import validation must either enforce the cap + split convention (FCC-migrated data) or represent long spans natively (ERP-born entries have real timestamps).

---
id: PAY-001
title: PAY-001 — Saturday-Friday payroll week
section: A-foundation-source-data
status: settled
updated: 2026-08-24
tags: [module/payroll, kind/rule]
---

# PAY-001 — Saturday-Friday payroll week

**Rule:** Assign each record to the correct Saturday-Friday period.

**Applies to:** All employees. **Trigger:** Any work date or selected payroll date.
**Requires:** Work date; payroll calendar.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-001` — baseline: *Existing baseline*
- **FRD** (target design): [02-payroll-period-and-source-data.md](../erp-payroll-module-frd/02-payroll-period-and-source-data.md) `PR-001` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §0
- **SQL**: `api.usp_UI_RefreshPayroll_FromNexGen` (refresh entry point)

## Open

- **Blocking (matrix):** Confirmed TCG design
- **Client re-confirmation (message, 2026-08-24 batch):** *"Payroll is processed weekly for Union and non-Union… and (for both) is always Saturday – Friday."* Now quadruple-sourced: matrix (settled, "Confirmed TCG design") · **live ADP pay schedule** (27/27 observed periods exactly Sat–Fri — [pay-schedule.md](../adp-api-responses/pay-schedule.md)) · the engine (Sat–Fri hard-coded incl. CA weekly OT) · this client statement.
- **Implementation note carried from the live-data doc:** anchor ERP periods to **ADP's `payPeriodID`**, not an ERP-side week computation — the two must never be able to disagree.

---
id: PAY-012
title: PAY-012 — Non-union hourly rate
section: B-group-and-rate
status: open
updated: 2026-09-07
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-012 — Non-union hourly rate

**Rule:** Use employee-master hourly rate; do not use union craft rate.

**Applies to:** Non-Union Admin Hourly. **Trigger:** Payroll group is hourly admin.
**Requires:** Employee PayRate; effective date.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-012` — baseline: *TCG design direction*
- **FRD** (target design): [03-payroll-groups-and-rate-determination.md](../erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md) `PR-009` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §12

## Open

- **Blocking (matrix):** Confirm rate-effective-date handling
- **Client confirmation, client message 2026-06-09 (Brian Petros — payroll-group determination + FCC profile screenshot):** `Base hourly rate = Employee.PayRate` ("very important"), CA DIR overtime rules linked (dir.ca.gov/dlse/faq_overtime). Display approximations ×40 / ×2080/12 / ×2080 confirmed as-built in `v_UI_Employee_TypeRate.VIEW.sql`.
- **Blocking item grounded:** "confirm rate-effective-date handling" is no longer abstract — FCC overwrites `Employee.PayRate` in place too; the ERP's employee-rate model needs effective dating for the same reason the union table does (PAY-008).
- **Legacy procedure was mixing union logic into non-union rows (client, 2026-09-07):** Brian reports
  the app *"was mixing up the logic/calculations for these with the Labor Union payroll rules during
  some of the procedures/steps"* and has fixed it — so `usp_Apply_CA_NonUnionAdminHourly_OT` as
  extracted on 2026-08-18 (plain-language §12) is a **known-defective source**; which steps were wrong
  is not stated (findings question 34). **ERP status, verified:** `priceNonUnionHourly`
  (`packages/payroll-engine/src/calculate.ts:241-253`) is a separate path with no union extras, but it
  prices the 8/12 daily thresholds **per ticket rather than per workday**, weekly > 40 only flags
  (`WEEKLY_OT_APPLIED`, `calculate.ts:444-452`), and there is no seventh-day rule. Full verification:
  [client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham](../client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham).
- **Clarified, same day (Brian's reply, 2026-09-07):** *"no change to how the non-Union rules should
  be calculated"* — the **descriptions** are the source of truth and stand; only the extracted
  procedure's *results* were wrong, now fixed in his app. Read the bullet above as "the 2026-08-18
  procedure's output was unreliable", not as doubt about §12's rule text. Correction logged at
  [client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham](../client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham) → *Correction*.

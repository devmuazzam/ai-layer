---
id: PAY-013
title: PAY-013 — Non-union salary rate
section: B-group-and-rate
status: open
updated: 2026-09-07
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-013 — Non-union salary rate

**Rule:** Produce salary-period amount and job-costing reference values.

**Applies to:** Non-Union Admin Salary. **Trigger:** Payroll group is salary admin.
**Requires:** Salary/rate; pay frequency; effective date.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-013` — baseline: *New ERP requirement*
- **FRD** (target design): [03-payroll-groups-and-rate-determination.md](../erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md) `PR-010 + PR-042` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §12

## Open

- **Blocking (matrix):** Management/legal confirmation
- **Client confirmation, client message 2026-06-09 (Brian Petros — payroll-group determination + FCC profile screenshot):** salary employees "may or may not currently have a Pay Rate in FCC… still undecided exactly how much information will be contained" — corroborates this rule's open scope in the client's own words.
- **Client restatement (2026-09-07, [non-union-hourly-rules-2026-09-07.md](../non-union-hourly-rules-2026-09-07.md) §15):** salary is a separate group; the system must not
  generate ST/OT/DT of any kind from recorded labor; pay comes from configured salary information;
  no boom/modifier. Brian asks to *"discuss more about 'salary' (exempt) employee payroll"* — this
  rule's blocking item, now on the client's own agenda (findings question 38). Engine today: one
  `PAY-013` "Salary period amount" from `hourlyRate`, flagged `SALARY_AMOUNT_ASSUMED`.
- **Verified in the 2026-09-07 backup ([legacy-payroll-app-db-backup-2026-09-07/INDEX.md](../legacy-payroll-app-db-backup-2026-09-07/INDEX.md)):** `PayType = 'S'` labor is now dropped inside
  `usp_Run_Pricing_Engine` before pricing or time validation, `v_UI_Employee_TypeRate` classifies
  it as *Salary* ahead of the L12 predicates, and `test.usp_Test_PricingEngine_SalaryExcluded`
  asserts zero calculated and zero exception rows. The rule text (no ST/OT/DT from labor) is now
  enforced at the front of the legacy pipeline; how salary *is* paid remains unspecified.
- **How salary is paid today (client message 2026-09-08, [client-message-findings.md](../client-message-findings.md) → *2026-09-08*):** *"Corrina currently enters Salary employee payroll into ADP separately"* — outside the Excel process, by hand, the `SALARY` batch seen on 2026-08-18. Salaried people still get a workbook sheet (the roster keeps pay type `S`) and no recommendation rows. Amount, frequency and whether the ERP owns that batch: gaps → *Post-import ADP entry*, findings question 41.

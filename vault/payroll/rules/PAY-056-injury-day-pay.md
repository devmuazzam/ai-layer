---
id: PAY-056
title: PAY-056 — Injury-day pay
section: F-contributions-other
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-056 — Injury-day pay

> **Deferred, not a gap.** Absent from the engine by choice — parked, "leave until asked". See [payroll-engine-status-2026-09-12.md](../payroll-engine-status-2026-09-12.md) → *Not on any list*. Do not file a ticket for the absence.

**Rule:** Pay full day at straight-time rate where required.

**Applies to:** Eligible L12 employee. **Trigger:** Workplace injury prevents completion of day.
**Requires:** Injury event; physician determination; hours worked.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-056` — baseline: *New ERP requirement*
- **FRD**: — *(matrix-only rule; no FRD counterpart — the FRD is Draft 0.1 and does not cover it)*
- **Legacy engine**: no direct counterpart (new in the ERP target)

## Open

- **Blocking (matrix):** Legal/HR confirmation
- **First live exhibit (client message, 2026-08-24 batch):** employee Jonathen (1092), L12-G3-A + 141-160Ft-Oiler, cross-midnight 10:30 PM → 1:00 PM — *"Had incident happen at 6am, left to go drug test at 10:30am and was takin back to yard at 1pm"*. Hours paid through the return (14.50 derived / 15.00 entered) though off-site for the drug test — the incident-day pay-continuation case this rule must govern. Also payable-but-not-billable: see PAY-004.
- **Invoice side of the incident-day case:** drug-test departures are on the ops/AR **deduct-from-invoice** list (company-caused) — completing the exhibit: payroll pays through return, billing deducts. See the invoicing taxonomy in accounting/.
- **Contract source located — the rule is MLA-verbatim:** Art III §7: injured and unable to continue → *"paid for a full day at his straight-time rate; ability determined by a qualified physician."* And Art III (DOT clause): *"All time required to meet DOT **Drug Testing** and Pre-Trip Inspections **shall be considered work time**"* — the drug-test exhibit's payment was contractually mandatory, not discretionary.

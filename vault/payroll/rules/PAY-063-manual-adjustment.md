---
id: PAY-063
title: PAY-063 — Manual adjustment
section: G-audit-review-export
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-063 — Manual adjustment

**Rule:** Add separate adjustment without overwriting original calculation.

**Applies to:** Authorized payroll users. **Trigger:** Approved correction is needed.
**Requires:** Component; amount/hours; reason; approver.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-063` — baseline: *New ERP requirement*
- **FRD**: — *(matrix-only rule; no FRD counterpart — the FRD is Draft 0.1 and does not cover it)*
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §14 (adjustment components)

## Open

- **Blocking (matrix):** Confirm approval levels
- **Today's mechanism confirmed (08-20):** the weekly workbook's "base rate override" column → separate ADP row per distinct rate; the decision (craft-locked, super/payroll-controlled) replaces it in the ERP — see decisions/2026-08-20-craft-locked-rate-override.md.

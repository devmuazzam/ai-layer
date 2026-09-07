---
id: PAY-026
title: PAY-026 — Seventh consecutive day
section: C-time-and-premium
status: open
updated: 2026-09-07
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-026 — Seventh consecutive day

**Rule:** Apply configured seventh-day OT/DT allocation.

**Applies to:** Non-Union Admin Hourly. **Trigger:** Employee works seven consecutive days in workweek.
**Requires:** Daily work indicators; hours.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-026` — baseline: *New ERP requirement*
- **FRD**: — *(matrix-only rule; no FRD counterpart — the FRD is Draft 0.1 and does not cover it)*
- **Legacy engine**: no direct counterpart (new in the ERP target)
- **Contract**: [01-article-iii-working-rules.md](../mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)

## Open

- **Blocking (matrix):** Legal confirmation
- **Needs data from outside the payroll week (client, 2026-09-04):** Brian lists seventh-day among the non-union CA rules his refresh cannot evaluate from the week's own dates. **Not implemented in `packages/payroll-engine/src`**, so the ERP's period-scoped calculate window (`payroll.service.ts:151-155` — the week and nothing else) does not yet produce a wrong number here; it will the day this rule is built. See [gaps.md](../gaps.md#a-labor-entry-edit-can-reprice-an-approved-week--and-the-erp-has-no-path-for-it).
- **Rule text and acceptance tests (client, 2026-09-07):** triggers only when **all seven days of the
  Sat–Fri workweek** are worked — a six-day week with one non-worked day never triggers, whatever the
  calendar position; first 8 h Seventh-Day OT (1.5×), over 8 Seventh-Day DT (2.0×); evaluated before
  weekly OT. Tests 6 and 7 in [non-union-hourly-rules-2026-09-07.md](../non-union-hourly-rules-2026-09-07.md). Because the count is bounded by the workweek, this rule needs
  **no** data from outside the week after all — the 2026-09-04 concern above applies to the rest
  rule, not this one. Verification: [client-message-findings.md#2026-09-07--non-union-hourly-rules-summary-and-nine-validation-scenarios-brian-petros](../client-message-findings.md#2026-09-07--non-union-hourly-rules-summary-and-nine-validation-scenarios-brian-petros).

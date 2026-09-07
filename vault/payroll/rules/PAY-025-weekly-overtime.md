---
id: PAY-025
title: PAY-025 — Weekly overtime
section: C-time-and-premium
status: open
updated: 2026-09-07
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-025 — Weekly overtime

**Rule:** Apply California nonexempt weekly overtime without duplicating daily premium.

**Applies to:** Non-Union Admin Hourly. **Trigger:** Weekly qualifying hours exceed legal threshold.
**Requires:** Saturday-Friday worked hours.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-025` — baseline: *New ERP requirement*
- **FRD** (target design): [08-non-union-apprentice-and-fringe.md](../erp-payroll-module-frd/08-non-union-apprentice-and-fringe.md) `PR-041 (non-union only)` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §12 (non-union only)
- **Contract**: [01-article-iii-working-rules.md](../mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)

## Open

- **Blocking (matrix):** Legal confirmation
- **Workweek anchor confirmed by client statement:** the CA weekly-OT workweek is the same Sat–Fri week for non-union — matching the engine's hard-coded `usp_Apply_CA_NonUnionAdminHourly_OT` (weekly >40 → OT, 7th-day rules, Sat–Fri week).
- **Rule text and acceptance tests (client, 2026-09-07):** weekly OT is evaluated **after** daily and
  seventh-day; it converts only hours that would otherwise remain ST once 40 ST is exceeded; Daily
  OT/DT and Seventh-Day OT/DT are never re-counted. Tests 4 and 5 in [non-union-hourly-rules-2026-09-07.md](../non-union-hourly-rules-2026-09-07.md). **Not built** — the
  engine only raises `WEEKLY_OT_APPLIED` (`packages/payroll-engine/src/calculate.ts:444-452`).
  Verification: [client-message-findings.md#2026-09-07--non-union-hourly-rules-summary-and-nine-validation-scenarios-brian-petros](../client-message-findings.md#2026-09-07--non-union-hourly-rules-summary-and-nine-validation-scenarios-brian-petros).

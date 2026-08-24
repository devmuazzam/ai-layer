---
id: PAY-008
title: PAY-008 — Effective-dated configuration
section: A-foundation-source-data
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-008 — Effective-dated configuration

**Rule:** Historical recalculation must use rules effective on the work date.

**Applies to:** All payroll rules. **Trigger:** Rule or rate changes.
**Requires:** Effective from/to; rule version; approver.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-008` — baseline: *New ERP requirement*
- **FRD**: — *(matrix-only rule; no FRD counterpart — the FRD is Draft 0.1 and does not cover it)*
- **Legacy engine**: no direct counterpart (new in the ERP target)

## Open

- **Blocking (matrix):** Confirm configuration ownership
- **The why, verified (client message + source feed):** FCC's `UNION_CRAFT` has `StartDate`/`EndDate` columns but uses neither — **rates are overwritten in place** (sample rows: `ModifiedBy=corrinab, ModifiedDate=2025-08-26` — last year's rollover), one row per craft, no history. Union rates change **every fiscal year (July–June)** per the MLA; the 2026 rollover happened "tonight at midnight" (≈2026-06-30) per the client. Effective-dating in the ERP must cover **wage and billing rates both**.
- **Migration asset:** the DB extract was built from the **2026-06-23 backup** — the vault holds the complete **pre-rollover FY25-26 rate table** that FCC itself can no longer produce. Pre-July-2026 recalculation is recoverable from it; earlier years from the MLA columns + per-row `Source_Rate_Raw`.
- **FY2026-27 rates recovered from TCG's own workbook** (`CraftRates` sheet, July 25–31 week): G1–G9 each **+$1.00** (67.03 … 72.16), apprentices +0.60–0.90 — so the MLA's $5.00 increase allocated **$1.00 to wages**, $4.00 to funds. The FY25-26 column matches the extract archive digit-for-digit. Two-year effective-dated rate history now complete in the record.

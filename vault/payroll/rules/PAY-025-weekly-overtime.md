---
id: PAY-025
title: PAY-025 — Weekly overtime
section: C-time-and-premium
status: open
updated: 2026-09-24
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
  OT/DT and Seventh-Day OT/DT are never re-counted. Tests 4 and 5 in [non-union-hourly-rules-2026-09-07.md](../non-union-hourly-rules-2026-09-07.md).
  **Built as written — see *Built* below** (this bullet previously read "Not built"; corrected
  2026-09-24).
  Verification: [client-message-findings.md#2026-09-07--non-union-hourly-rules-summary-and-nine-validation-scenarios-brian-petros](../client-message-findings.md#2026-09-07--non-union-hourly-rules-summary-and-nine-validation-scenarios-brian-petros).

## Built

**Implemented and pinned by test. Verified against HEAD on 2026-09-24.** This section records
*implementation*, not product sign-off — the `Blocking (matrix): Legal confirmation` item above is
a product question and is **still open**, which is why `status:` stays `open`. See
[gaps.md → *A rule file's `status:` records the product question, not whether the rule is built*](../gaps.md#a-rule-files-status-records-the-product-question-not-whether-the-rule-is-built--so-build-status-in-the-register-drifts-silently).

- **Where.** `packages/payroll-engine/src/non-union.ts` — `classifyNonUnionWeek` (`non-union.ts:69`)
  classifies every half hour of one employee's Sat–Fri week. A half hour becomes
  `'Weekly overtime'` **only** when it would otherwise have been Straight time *and* the week's
  ST-only bank has already reached 40 h: `non-union.ts:97-98`
  (`} else if (weeklyStraightTime >= WEEKLY_ST_HOURS) {` → `reason = 'Weekly overtime';`).
  `WEEKLY_ST_HOURS = 40` at `non-union.ts:54`.
- **Priced at 1.5×** via `NON_UNION_MULTIPLIER` — `packages/payroll-engine/src/calculate.ts:432-439`,
  with `'Weekly overtime': 1.5` at `calculate.ts:435`. The reason string survives onto the
  component label (§8), so the *why* is auditable.
- **Test pinning Brian's §5 example** — `packages/payroll-engine/src/calculate.spec.ts:677-698`,
  *"non-union: straight time past 40 in the week becomes weekly OT"*: Sat 8, Sun off, Mon–Fri 8;
  asserts Friday's `stHours === 0`, `otHours === 8`, and a `Weekly overtime` component of 8 h.
- **The ladder, per half hour** (`non-union.ts:90-102`), which is the mechanism behind
  [PAY-027](PAY-027-no-pyramiding.md): seventh-day (`:90-92`) → daily DT over 12 (`:93`,
  `DAILY_DT_AFTER_HOURS = 12` at `:53`) → daily OT over 8 (`:95`, `DAILY_ST_HOURS = 8` at `:52`)
  → weekly 40 (`:97`) → ST (`:100`). **The 40-hour bank counts ST hours only** —
  `weeklyStraightTime += SLICE_HOURS` runs in the ST branch and nowhere else (`non-union.ts:101`).
  So weekly-40 and the daily / seventh-day rungs can never double-premium the same hour, and
  weekly OT is evaluated *after* them, exactly as the client's §7 order requires.
- **Corroborating vault rows** (both already accurate; it was this file that drifted):
  [payroll-engine-status-2026-09-12.md:60](../payroll-engine-status-2026-09-12.md) — *"Non-union
  hourly: daily 8/12 → 7th day → weekly 40, in that order, reasons preserved | Brian 2026-09-07,
  written, 9 scenarios | ✅ | Audit re-run A9"* — and
  [payroll-rules-provenance.md:119](../payroll-rules-provenance.md) (**Confirmed**).

### Correction log — 2026-09-24

This file was accurate on 2026-09-07 and was overtaken by `packages/payroll-engine/src/non-union.ts`,
added in commit `56091e98f` (2026-09-11) and refined by `015136f79` (2026-09-11, the implementation
audit). Two claims were removed as wrong at HEAD:

- *"the engine only raises `WEEKLY_OT_APPLIED`"* — **`WEEKLY_OT_APPLIED` does not exist in the
  payroll engine.** The only occurrence repo-wide is
  `apps/web/src/features/payroll/components/payroll-issue-catalog.ts:84`, a **web display catalog**
  entry (`{ severity: 'warning', title: 'Weekly overtime not reclassified' }`) — a label for an
  issue code, not an engine signal.
- *"`packages/payroll-engine/src/calculate.ts:444-452`"* — that range now sits inside
  `priceNonUnionHourlyWeek`, the non-union pricing function, and has nothing to do with the claim.

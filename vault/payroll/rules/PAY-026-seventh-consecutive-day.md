---
id: PAY-026
title: PAY-026 — Seventh consecutive day
section: C-time-and-premium
status: open
updated: 2026-09-24
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
- **Needs data from outside the payroll week (client, 2026-09-04):** Brian lists seventh-day among the non-union CA rules his refresh cannot evaluate from the week's own dates. ~~**Not implemented in `packages/payroll-engine/src`**, so the ERP's period-scoped calculate window does not yet produce a wrong number here; it will the day this rule is built.~~ **Stale as of 2026-09-24 — the rule IS built** (see *Built* below), and the period-scoped window is not a problem for it: the seventh-day count is bounded by the Sat–Fri week, as the 2026-09-07 bullet below already concluded. `classifyNonUnionWeek` needs nothing from outside the week. See [gaps.md](../gaps.md#a-labor-entry-edit-can-reprice-an-approved-week--and-the-erp-has-no-path-for-it).
- **Rule text and acceptance tests (client, 2026-09-07):** triggers only when **all seven days of the
  Sat–Fri workweek** are worked — a six-day week with one non-worked day never triggers, whatever the
  calendar position; first 8 h Seventh-Day OT (1.5×), over 8 Seventh-Day DT (2.0×); evaluated before
  weekly OT. Tests 6 and 7 in [non-union-hourly-rules-2026-09-07.md](../non-union-hourly-rules-2026-09-07.md). Because the count is bounded by the workweek, this rule needs
  **no** data from outside the week after all — the 2026-09-04 concern above applies to the rest
  rule, not this one. Verification: [client-message-findings.md#2026-09-07--non-union-hourly-rules-summary-and-nine-validation-scenarios-brian-petros](../client-message-findings.md#2026-09-07--non-union-hourly-rules-summary-and-nine-validation-scenarios-brian-petros).

## Built

**Implemented and pinned by test. Verified against HEAD on 2026-09-24.** This section records
*implementation*, not product sign-off — the `Blocking (matrix): Legal confirmation` item above is
a product question and is **still open**, which is why `status:` stays `open`. See
[gaps.md → *A rule file's `status:` records the product question, not whether the rule is built*](../gaps.md#a-rule-files-status-records-the-product-question-not-whether-the-rule-is-built--so-build-status-in-the-register-drifts-silently).

- **The trigger is all seven days, exactly as the rule says.** `packages/payroll-engine/src/non-union.ts:75`:
  `const seventhDay = week.every((date) => worked.has(date)) ? week[6] : null;` — non-null only when
  every one of the seven Sat–Fri dates was worked, so **a six-day week never triggers**, whatever the
  calendar position. `worked` is built from entries with `sliceCount > 0` (`non-union.ts:73`), and
  `week` from `datesInPeriod(periodStart)` (`non-union.ts:74`).
- **First 8 h OT, then DT.** `non-union.ts:90-92` — on that date,
  `dayHours < SEVENTH_DAY_OT_HOURS ? 'Seventh-day overtime' : 'Seventh-day double time'`, with
  `SEVENTH_DAY_OT_HOURS = 8` at `non-union.ts:55`. Priced 1.5× / 2.0× by `NON_UNION_MULTIPLIER` —
  `packages/payroll-engine/src/calculate.ts:432-439`, `'Seventh-day overtime': 1.5` at
  `calculate.ts:436` and `'Seventh-day double time': 2` at `calculate.ts:438`.
- **Evaluated before weekly OT**, as required. The seventh-day branch is the *first* rung of the
  per-half-hour ladder (`non-union.ts:90-102`): seventh-day → daily DT over 12 (`:93`) → daily OT
  over 8 (`:95`) → weekly 40 (`:97`) → ST (`:100`). **The 40-hour weekly bank counts ST hours
  only** — `weeklyStraightTime += SLICE_HOURS` runs in the ST branch and nowhere else
  (`non-union.ts:101`) — so a seventh-day hour is never also counted toward weekly 40, and the two
  rules can never double-premium the same hour. This is the mechanism behind
  [PAY-027](PAY-027-no-pyramiding.md).
- **Test pinning Brian's §6 example** — `packages/payroll-engine/src/calculate.spec.ts:700-724`,
  *"non-union: the seventh consecutive day pays 7th-day OT, then 7th-day DT past 8"*: six 8-h days
  then 8.5 h on the seventh; asserts `Seventh-day overtime` of 8 h and `Seventh-day double time`
  of 0.5 h.
- **Corroborating vault rows** (both already accurate; it was this file that drifted):
  [payroll-engine-status-2026-09-12.md:60](../payroll-engine-status-2026-09-12.md) — *"Non-union
  hourly: daily 8/12 → 7th day → weekly 40, in that order, reasons preserved | Brian 2026-09-07,
  written, 9 scenarios | ✅ | Audit re-run A9"* — and
  [payroll-rules-provenance.md:119](../payroll-rules-provenance.md) (**Confirmed**).

### Correction log — 2026-09-24

This file was accurate on 2026-09-07 and was overtaken by `packages/payroll-engine/src/non-union.ts`,
added in commit `56091e98f` (2026-09-11) and refined by `015136f79` (2026-09-11, the implementation
audit). The 2026-09-04 "not implemented / needs data from outside the week" bullet above has been
struck through rather than deleted, so the chain stays followable: the concern was real when
written, the rule is now built, and the out-of-week worry was already retracted by the 2026-09-07
bullet on the rule's own grounds.

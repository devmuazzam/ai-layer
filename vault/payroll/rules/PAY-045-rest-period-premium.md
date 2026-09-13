---
id: PAY-045
title: PAY-045 — Rest-period premium
section: F-contributions-other
status: open
updated: 2026-09-07
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-045 — Rest-period premium

**Rule:** Apply OT floor until qualifying rest is received.

**Applies to:** Eligible L12 employees. **Trigger:** Employee returns after OT without eight hours off.
**Requires:** Previous chain; return time; rest gap.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-045` — baseline: *Existing baseline*
- **FRD** (target design): [07-rest-meal-and-subsistence.md](../erp-payroll-module-frd/07-rest-meal-and-subsistence.md) `PR-034` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §9
- **Contract**: [01-article-iii-working-rules.md](../mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)

## Open

- **Blocking (matrix):** Confirm mechanic applicability
- **Two distinct chain concepts (extract):** the shift chain groups entries **< 8 h apart** (`ChainGroup`), but the rest rule chains entries **≤ 30 min apart** (`Rest_ChainId`). The client's back-to-back split convention interacts with *both* — a split gap of, say, 45 min keeps the shift chained but breaks the rest chain. Confirm both thresholds are intended for the ERP.
- **Config truth (raw extract zip, `cfg.RestPeriod_Rule`):** `RequiredRestHours=8.00`, `OTFloorMultiplier=1.50`, **`StitchGapMinutes=30`** — the 30-minute rest-chain threshold is a config value, not a constant. `TriggerMode='HrsOTDTPositive'`, **changed from the DDL default** `'ActHoursOver8'` — a deliberate tuning worth confirming as intended when the thresholds question (findings #7) is answered.
- **Phantom hours must not affect the rest rule (client, explicit):** added hours "would not affect the 8-hour rest rule" — gap measurement uses actual entry windows ✓ by construction. **Precise check still required:** the trigger `TriggerMode='HrsOTDTPositive'` — does it read *actual-worked* OT/DT or *payable* OT/DT? Holiday-minimum gap hours are "reported as DT hours"; if the trigger reads payable columns, phantom DT could force rest on the next chain — exactly what the client says must not happen. One column-lineage check in `usp_Apply_RestPeriod_Premium` settles it.
- **Lineage verified in code:** the trigger reads `Hrs_OT + Hrs_DT` from actual priced slices (`Act_` family); gap/phantom hours live in `Gap_*` columns and **cannot reach the trigger**. The client's twice-stated invariant holds as-built. Threshold intent: `TriggerMode` was deliberately changed from its DDL default — config evidence of tuning, corroborated by both August meetings discussing the rule.
- **Selection window vs rule window (client thread, 2026-09-04):** Brian's legacy refresh selects **7 days backward** for this rule; Ehtesham objected that only the **8 hours** before a job start matter, and Brian agreed — his 7 days is the *initial select of candidate labor dates out of a data warehouse*, deliberate overshoot, not the rule. **Do not implement a 7-day lookback.** The rule stays the 8-hour gap with the 30-minute stitch; what the ERP owes is the ability to *see* the prior entry at all — `payroll.service.ts:151-155` currently loads only the period being calculated.
- **Forced multiplier is now DT, not the ×1.5 floor (client comparison run, 2026-09-07):** Brian's
  updated app — and the payroll department's **manual** sheet it was compared against — price every
  rest-forced hour at **×2.0 from the first hour** (premium $487.62 = 7.0 h × $69.66 × 1.0 on an
  ST block; $348.30 = 10.0 h × $69.66 × 0.5 on an OT block). That contradicts this file's *"apply OT
  floor"* and the 2026-08-18 config `OTFloorMultiplier=1.50` (×2 only past 12 h). Brian describes the
  change as *"now calculating the ST/OT/DT hour buckets for this rule"*. The contract's *"applicable
  overtime rate"* does not settle it. **Trigger also looks changed:** an entry 6 h after a chain that
  *contained* 0.5 h OT but *ended* in ST was not forced — reads as "prior chain ended in OT/DT", not
  `HrsOTDTPositive`. Both are findings questions (33); the gaps entry is
  [gaps.md → Rest-period premium — ×1.5 floor or double time](../gaps.md#rest-period-premium--15-floor-or-double-time-from-the-first-forced-hour).
  Full verification: [client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham](../client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham).
- **Withdrawn, same day (Brian's reply, 2026-09-07):** *"no change to the way the '8-hour rest' rule
  should be calculated"*. The DT-from-the-first-hour reading above was ours: the rest chain groups
  entries across gaps **< 8 h**, and the ×2.0 floor applies **once the chain reaches 12 cumulative
  hours** — Aug 24 contributes 11.0 h, so the first hour of Aug 25 reaches 12 and the remaining 7.0 h
  are floored to ×2.0 ($487.62). The trigger inference is withdrawn with it. **This file's rule
  stands as written; build from it.** The one new question is whether WTL added hours count toward
  the 12 — [gaps.md](../gaps.md#do-wtl-added-hours-count-toward-the-rest-chains-12-hour-double-time-threshold),
  waiting on Corrina's WTL review. Correction logged at [client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham](../client-message-findings.md#2026-09-07--legacy-app-comparison-run-rest-rule-now-moves-hours-to-dt-non-union-separated-wtl-still-open-brian-petros--ehtesham) → *Correction*.
- **Verified in the 2026-09-07 backup ([legacy-payroll-app-db-backup-2026-09-07/INDEX.md](../legacy-payroll-app-db-backup-2026-09-07/INDEX.md)):** `usp_Apply_RestPeriod_Premium` and
  `cfg.RestPeriod_Rule` are **unchanged** since the extract. The client's "buckets" fix is a new
  post-pricing `fms.Payroll_RestSliceAdjustment` + `v_UI_Pricing_Slices_PayrollEffective` layer that
  makes forced slices *count in the DT bucket*; the exhibit's rows carry `RestReason = 'Rest chain
  over 12 hrs'` with the multiplier stepping 1.5 → 2.0 at the slice where the chain passes 12 h.
  **Rest now runs before WTL:** `usp_Apply_WTL_MealPeriods` reads the rest-adjusted slices, so a WTL
  deduct on a forced slice is priced at the rest-adjusted rate. ERP: present forced hours in DT,
  keep the premium as its own component, evaluate rest before WTL.
- **The chain rules, stated by the Payroll Manager on a recorded call, 2026-09-10**
  ([../../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md](../../meetings/2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md) §3, 24:52–30:14). When the prior gap is under 8 hours, **the new shift starts in the
  bucket the previous shift ended in and fills to the 12-hour mark before double time**:
  previous ended on DT → *"this entire job would be double time"* (25:21); previous was 10 h, ended
  on OT → the first 2 h of the new job are OT, *"because it fills up the 12-hour bucket and then
  everything else would be doubled"* (27:33); previous was 6 h, ended on ST → fill ST to 8, then
  4 h OT, then DT (28:12). **The 06:00 rule still outranks the carry-forward** — a 04:00 start after
  a short rest begins on OT regardless (29:20). **The length of the short rest is irrelevant**:
  Ehtesham Anwar 28:43 — *"doesn't matter if they got 7, 6, 4, three, two, one… the exact rest time
  does not matter, right?"* — Corrina Bustos: **"Correct, correct."** Only the binary *did they get
  eight* matters, which retires any need for a graduated premium by gap length.
- **⚠️ Unreconciled on the same call — how deep the chain goes.** Brian Petros (25:45, 26:10)
  describes walking **backwards until an 8-hour gap is found** and grouping every entry in between
  *"as if it was one shift"*. Ehtesham Anwar (27:06) proposed checking **only the immediately
  previous entry** and Corrina agreed — *"Right, it would just be the previous day."* The two agree
  on a two-day chain and diverge on three or more consecutive short rests. Nobody noticed the
  divergence. This is the same `REST_STITCH_MINUTES` / chain-depth question this register already
  carries under *Rest chain — is a job-to-job gap a "rest period" at all?*.
- **Trigger confirmed as "any OT/DT in the prior chain" — Brian Petros, 2026-09-13, by calling the
  opposite a bug.** Screenshot (Albergo, Mon 2026-08-24): 05:30–11:30 priced 5.5 ST / 0.5 OT
  (+0.5 WTL at DT), then 17:30–22:30 six hours later — *"This should be triggering the '8-hour rest'
  rule... but is not for some reason."* He is fixing his app. The morning entry **contained** OT
  (the pre-06:00 half hour) but **ended** on ST — exactly the case this file logged on 2026-09-07 as
  a possible "prior chain *ended* in OT/DT" reading. That reading is now the defect, not the rule:
  `HrsOTDTPositive` stands. **The ERP already does this** (`rest-period.ts` `hasActualOtDt` — any
  OT/DT slice in the prior chain arms it; gap 6 h < 8 → forced). **Parallel-run note:** on this
  entry the evening hours are all OT and the floor is ×1.5 (chain 11 h < 12), so the uplift is $0
  either way. Brian's app shows a *Rest floor hrs* badge whenever the rule is armed; ours reports
  `restForcedHours` only for slices the floor actually raised, so his badge will appear where ours
  reads 0 with identical money. Not a defect on either side.
- **Brian, 2026-09-13, follow-up:** the non-fire *"appears to be an 'order of operations' issue…
  where our Payroll App needs to change the order in which the payroll rules are applied."* So his
  app's rest trigger was reading slices after some later rule had already rewritten them (the
  2026-09-07 backup already showed WTL reading rest-adjusted slices, i.e. rest before WTL; the
  trigger itself evidently sat in the wrong place). **The ERP's order, for the record and for the
  parallel run** (`calculate.ts`, per employee-week): (1) slice pricing per chain — ST/OT/DT ladder
  with the premium-day top-up bump; (2) holiday / special-Saturday minimums, per calendar date;
  (3) **rest premium, per chain, reading the priced slices** — before any phantom hours exist;
  (4) shift hours-add, per chain; (5) daily 4-h and long-boom 4-h minimums, per calendar day;
  (6) meals, per gapless group; (7) subsistence; then every day's total restated from its ledger.
  Rest reads actual slices only, by construction. **Expect a further backup after his fix and a
  changed set of rest badges on chains like Albergo's Mon 24 Aug** — same money on that one, but
  other weeks may move where the floor reached ×2.0.

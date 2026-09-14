---
title: Payroll engine status — rules written vs rules built, 2026-09-12
source: consolidation of decisions/, rules/PAY-*, implementation-audit-2026-09-11.md (re-audit 2026-09-12), and the engine executed on app main e11e8cd60
migrated: 2026-09-12
updated: 2026-09-12
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, payroll-rules, audit, as-built, status]
part_of: payroll/INDEX.md
---

# Payroll engine status — 2026-09-12

**What this is.** One page answering *"are the rules written, and does the engine do them?"* as
of today. Every row points at the source that settles the rule and the code that implements it.
Money is at an **$80.00 base** unless stated. **Describes code; never a source for a spec.**

**Engine:** `packages/payroll-engine` on app `main` `e11e8cd60` (PR #531 merged), rebuilt and
executed; 86/86 tests pass. The detailed rule-by-rule comparison is
[implementation-audit-2026-09-11.md](implementation-audit-2026-09-11.md) (re-audited this
morning); this page applies **today's three client rulings** on top of it.

## What changed today

| Ruling | Who | Effect |
| --- | --- | --- |
| Holiday minimum is **8 hours total** — 2 worked → 6-hour top-up | Union BA via Corrina Bustos, in writing | Brian's "controversial" flag answered his way. Engine already does this. |
| A holiday-start shift **reverts at midnight** to the applicable rate; the shift stays continuous | Union BA via Corrina | No holiday shift-start rule. **Engine does the opposite** (keeps ×3 through) — N1. |
| **Guaranteed holiday hours count toward the 12-hour DT mark** — 22:00→10:00 = 8 TRI / 4 OT / 6 DT | Union BA via Corrina; Corrina confirmed the 10am version: *"yes your example is correct"* | Contradicts Brian's app, the legacy engine and ours. New engine change. |

Decision note: [../decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md](../decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md).

## Rules written — settled by a named human, with the engine's status

| Rule | Settled by | Engine | Verified |
| --- | --- | --- | --- |
| **ST/OT/DT ladder, after-06:00 start** — 8 ST, OT, DT after 12 | Corrina 2026-09-10 (24:14–24:49) | ✅ | Ran 04:00→23:30 = 8/4/7.5 |
| **Pre-06:00 start** — pre-window hours are OT and do not spend the ST bank | Corrina 2026-09-10; Brian 8:42 | ✅ | Ran 00:00→14:00 = 6/6/2 |
| **Before-midnight start** — no ST at all; 12 OT then DT | Corrina 2026-09-10 (15:18–17:22) | ✅ on 22:00→14:00 = 0/12/4 | Ran. Built on the **categorical** reading (`afterStartDate` rung): 23:00→13:00 = 0/12/2. The legacy mechanical reading gives 1 ST. **Corrina has not ruled on 23:00→13:00** — see open items |
| **Nothing above DT except a holiday** | Corrina 2026-09-10 (30:44) | ✅ | — |
| **Rest chain** — under 8 h off, the new shift starts in the bucket the previous ended in, fills to 12, then DT; gap length irrelevant | Corrina 2026-09-10 (25:21–29:20) | ✅ | Ran 3-entry chains, matches |
| **Rest premium = ×1.5 floor, ×2.0 past 12 chain hours, increase only** | Legacy config; Brian 2026-09-07 withdrew the DT-first reading | ✅ | Rest-forced DT slice pays $0 premium, as intended |
| **Work chains stitch only back-to-back** (meal grouping); the 30-min stitch was a bug | Brian 2026-09-09, `verified` | ✅ meals (`groupGaplessEntries`, gap 0) · ⏸ rest stitch still 30 — parked in the decision note (A7) | Ran 3 h + 3 h back-to-back → one meal |
| **Craft adders (boom, lattice, foreman, military) go into the rate and ride the multiplier** | Brian 2026-09-10 (21:48), Corrina concurring; confirmed in writing 2026-09-11 | ✅ | Ran foreman 8 ST + 4 OT = $42.00; boom OT half-hour = $63.00 |
| **Boom pay only on captured build-up/work/breakdown**; travel is not boom time | Kyle Harlow 2026-09-03 | ✅ | `boomWindows` / `sliceIsOnBoom` |
| **Taken meal deducts the whole priced half-hour, in its bucket, boom included** | Brian's scenario #1 workbook, method confirmed 2026-09-11 | ✅ | Ran: $42.00 ST+boom, $60.00 OT — to the cent |
| **Worked-through meal** — deduct, then +0.5 h at ≥ ×2 on base+shift, boom excluded | MLA Meal Periods §1; four-source resolution in PAY-047 | ✅ | `meal-periods.ts` |
| **"Paid straight through" is not built, in any verbiage** | Wes Staley 2026-09-03, `verified` | ✅ (absent by design) | — |
| **Self-signed WTL only with a stated reason** | Corrina 2026-09-03 (12:59) | 🟡 capture-side rule, mobile | — |
| **Holiday: all work at ×3, 8-hour minimum, fires on any contact incl. spill-in, per calendar date** | Corrina 2026-06-11, 2026-09-04 (`verified`), 2026-09-10 (34:34) | ✅ | Ran Tue 16:00→Hol 02:00 = 1 ST / 7 OT / 2 H3X + 6 h top-up |
| **Holiday minimum = 8 total (top-up), not 8 additional** | Union BA via Corrina 2026-09-12 | ✅ | Same run — 6 h top-up on 2 h worked |
| **Holiday-start shift reverts at midnight; continuous shift preserved** | Union BA via Corrina 2026-09-12 | ✅ fixed — PR #565 (was N1) | Ran Hol 22:00→10:00 = 8 TRI / 4 OT / 6 DT, $3,360 |
| **Guaranteed holiday hours advance the 12-hour DT mark** | Union BA via Corrina 2026-09-12, confirmed on 22:00→10:00 — **⚠️ contested by Brian Petros 2026-09-11, before Corrina's confirmation**; see gaps → *Added hours* | ✅ fixed — PR #565, `premiumDayTopUpHours`, bumped once on leaving the premium date, boundary-in-gap included | Ran 22:00→06:00 = 8/4/2 $2,720; 22:00→10:00 = 8/4/6 $3,360 |
| **Cross-midnight into Sat/Sun/holiday — higher rate governs, never a downgrade** (DT earned by hours does not drop to Sat ×1.5) | Corrina 2026-09-04, `verified` | ✅ upward | Ran Fri 22:00→Sat 14:00 = 12 OT / 4 DT |
| **Daily 4-h minimum at the rate the shift ended on**, per calendar day | Corrina 2026-06-11; Brian/Corrina 2026-09-10 (36:07) | ✅ | Audit re-run A5, A6 |
| **Special Saturday** = first Saturday after the first Friday, June & December, ×2, 8-h minimum | MLA; Brian 2026-08-24 | ✅ | Audit re-run B2, B6 |
| **Holiday observance shifting** (Sun → Mon; Christmas/New Year on Sat → Fri) | MLA | ✅ | Audit re-run B5 |
| **Shift differential $3 / $4, into the rate; 7 → 8 and 6½ → 8 hours-add** | MLA Art. III Shifts; Brian 2026-08-24 | ✅ rates · ✅ hours-add once per chain, on the last 2nd/3rd-shift entry — fixed, PR #565 (was N2) | Test: two back-to-back 2nd-shift tickets → one add |
| **Non-union hourly: daily 8/12 → 7th day → weekly 40, in that order, reasons preserved** | Brian 2026-09-07, written, 9 scenarios | ✅ | Audit re-run A9 |
| **Non-union is admin/yard only; every dispatched job is L12; no non-union mechanics** | Corrina 2026-09-10 (38:20, 50:43) | 🟡 scope statement — work-order and salaried populations not modelled | — |
| **Subsistence $85 (45–77.5 mi) / $200 (>77.5 mi), per job not per craft** | 2026-08-20 SME call; decision 2026-09-01 | 🟡 built, **unreachable** — no DTO/UI sets the job fields (B4) | — |
| **Anniversary check: L12 vacation payout, 40 h at regular rate, 1 yr + 1200 h; preserved as entered, exempt from every rule; special-earning policy, not a labor row** | MLA Vacation §1; Brian's spec + as-built app 2026-09-11; FCC pattern ruled out for the ERP | ❌ not built — special-earnings model undecided (flag / entity / ledger) | — |
| **SICK is a special earning** (falls through to NORMAL_WORK in Brian's app today; being fixed) | Brian 2026-09-11 | ❌ not built | — |

## Rules open — no named human has settled them

| Question | Owner | Why it matters | Where |
| --- | --- | --- | --- |
| **23:00 → 13:00** — categorical (0 ST) or mechanical (1 ST at 06:00–07:00)? The engine chose categorical | Corrina | One hour per such shift; decides the `afterStartDate` rung's correctness | gaps → *The before-midnight bucket rule* |
| **Which rules' added hours reach which thresholds?** Brian 2026-09-11: none, ever — contesting the one decided cell (holiday top-up → 12-h rung). Grid of 5 rules × 4 thresholds, one cell decided | Corrina, with the BA; Brian to align or argue | Parallel run diverges from Brian's app on every holiday-start shift until settled | gaps → *Added hours* |
| **Sunday-start → Monday**: does Sunday ×2 carry past midnight? Same principle as the holiday ruling says no (2 DT + 10 OT); engine pays 12 DT | Corrina — one line | $400 per such shift | this page (ran it) |
| **Rest-chain stitch: 30 → 0, measured on the rounded window** — ✅ Corrina confirmed via Brian 2026-09-13 (back-to-back or overlapping only); the minute-apart objection dissolves once the gap is measured on PAY-020 rounded times | CodingCops — small change, ready | Closes A7 | decision 2026-09-09 (updated) |
| **Rest-chain depth** — walk back to an 8-h gap (Brian) vs previous entry only (Corrina agreed on the call) | Brian | Three or more consecutive short rests | PAY-045 |
| **Paid time starts at dispatch start time, not punch-in?** | Kyle / Joe | Early taps pay from the rounded punch | A11; decision 2026-09-03 |
| **Meal thresholds** 16.0/21.5 vs 16.5/22; three or four lunches | Corrina | Third/fourth meal is DT money | field-ops + payroll gaps |
| **Scenario `#1` written instructions; break start+end pair; meal in OT while boom runs; do taken meals reduce the 12/40 clocks** | Brian | Unblocks `#2`/`#3` | payroll gaps |
| **Special-earnings model, member list (policy table), approval levels, CA bonus regular-rate** | Brian (table), Corrina (approvals), counsel (bonus) | Anniversary, sick, PTO, commissions, bonuses | gaps → *Special earnings* |
| **Anniversary: which craft rate is "regular rate"; ERP proposes eligibility or manual; prorated layoff path; "separate check" = separate ADP payment?** | Corrina / Brian | $ per check | gaps → *Anniversary Checks* |
| **Work-order and salaried payroll** — the two populations the ERP has not modelled | Corrina / Kyle | Bounds the parallel run | gaps → *three populations* |
| **Paper tickets as a declared fallback; offline capture scope** | Kyle / Melissa; CodingCops | Capture side | field-ops gaps |

## Engine defects open today

Fixed and **merged to app `main` as PR #565 (`e9d45ecbf`, 2026-09-13)** — 92/92 engine tests, `@tcg/api` builds: **N1**
holiday-start ×3 carry + top-up double-pay; **the 12-hour bump** for guarantee hours; **N2**
hours-add per ticket; and Sunday-start ×2 carry, by the same principle. **Note:** repo CI
(Affected CI, CodeQL, Snyk) has failed on every `main` run since at least `5372e0a29` with zero
steps executed — a runner/config failure, not a code result; merged on the local gates.

| # | Defect | Per occurrence | Fix |
| --- | --- | --- | --- |
| **B4** | Subsistence unreachable — no UI for `subsistenceDistanceMiles` / `subsistenceHoldover` | –$85 to –$200 per eligible day | Job form fields + DTO |
| — | Before-midnight built on the categorical reading | ±1 h on 23:00-type starts if Corrina says mechanical | Await her answer; no change until then |
| — | Sunday-start now reverts at midnight (2 DT + 10 OT, was 12 DT) | $400 per such shift, now *less* | Applied by principle from the holiday ruling — one line to Corrina to confirm, easy to reverse |

**Regression rows for the N1 fix, all with confirmed answers:** Hol 22:00→06:00 = 8 TRI / 4 OT /
2 DT ($2,720) · Hol 22:00→10:00 = 8 TRI / 4 OT / 6 DT ($3,360) · Tue 16:00→Hol 02:00 = 1 ST /
7 OT / 8 TRI (unchanged) · Hol 04:00→23:30 = 19.5 TRI (unchanged) · Fri 22:00→Sat 14:00 = 12 OT /
4 DT (unchanged).

## Not on any list — never spoken by the client, not in the legacy app

2-h reporting pay (PAY-039) · crane-remains-on-job 4/6/8 (PAY-041) · first-day travel/assembly
exception (PAY-042) · hazmat $2 (PAY-038) · injury-day pay (PAY-056) · higher-rate-for-the-day
(PAY-015). Leave until asked.

## Where the rules live

- Settled: [../decisions/](../decisions/) — one note per ruling, `status: verified` where a named
  human decided it on record.
- Per rule: [rules/](rules/INDEX.md) `PAY-001`–`PAY-073`, each with its sources and open items.
- Open: [gaps.md](gaps.md) — `grep -n '^- \*\*Status:\*\* open' gaps.md`.
- Engine vs rules, line by line: [implementation-audit-2026-09-11.md](implementation-audit-2026-09-11.md).

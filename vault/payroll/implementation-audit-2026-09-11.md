---
title: Payroll implementation audit — engine vs client rules, 2026-09-11
source: audit of packages/payroll-engine + apps/api payroll usecase against meeting notes/decisions (tier 1), legacy Payroll App db extract (tier 2), FRD/matrix/MLA (tier 3)
migrated: 2026-09-11
updated: 2026-09-12
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, payroll-rules, audit, as-built]
part_of: payroll/INDEX.md
---

# Payroll implementation audit — 2026-09-11, re-audited 2026-09-12

**What this is.** A rule-by-rule comparison of the shipped payroll engine against what the
client has said the rules are. **Describes as-built code on `fix/timezone-business-day` at
commit `886c00550`; it is not a spec.** Where a row says "client", the citation is a meeting
note or `decisions/` note; where it says "legacy", the 2026-08-18 db extract (and the
2026-09-07 backup where it differs).

**Source precedence used:** meeting notes / decisions › legacy Payroll App › FRD, rule matrix,
MLA. Where the tiers disagree the row says which one the code follows.

**Code audited:**
- `packages/payroll-engine/src/{calculate,day-type,slices,guarantee,rest-period,meal-periods,types}.ts`
- `apps/api/src/usecase/payroll/payroll.service.ts` (input wiring), `apps/api/src/utility/seed-data.ts` (premium catalog)
- `apps/api/src/usecase/ticket-time-entries/derive-ticket-times.ts` (paid window, boom windows, meal events)

**How verified.** Every code claim cites a line. Item 1 was additionally run against the built
engine (`dist/day-type.js`) on the client's three worked examples — A and C pass, B fails.
Everything else is read, not executed.

---

## Re-audit 2026-09-12 — after `56091e98f` and PR #531 (`015136f79`)

**Method.** Same source precedence. Every item below was re-read in the current code on app
`main` `e11e8cd60`, and the money-affecting ones were **executed** against a fresh build of
`packages/payroll-engine` (86/86 engine tests pass; scenario script kept in the session
scratchpad, results quoted here). "VERIFIED" = ran; "READ" = code inspected, not executed.

**Net position.** Of the 18 items in sections A and B, **14 are now fixed, 2 remain by design
(decision pending), 1 is built but unreachable, and 1 was a question**. The fix pass also
introduced **two new defects** (N1, N2) — both overpayments, both on the shift hours-add /
holiday-minimum code that was new. Non-union, foreman/military/lattice, the pre-midnight ladder,
cross-midnight upgrade, holiday and Special-Saturday minimums, calendar-day grouping, meal
grouping and holiday observance all verify.

| # | Rule | Status 2026-09-12 | Evidence |
| --- | --- | --- | --- |
| A1 | Pre-midnight start earns no ST | **Fixed — VERIFIED.** 22:00→14:00 = `{ST:0, OT:12, DT:4}`; 04:00→23:30 and 00:00→14:00 still match Corrina | `day-type.ts:190` `afterStartDate` rung ("Cross-midnight OT carryover"), wired at `calculate.ts:200` |
| A2 | Foreman / military / lattice multiplied | **Fixed — VERIFIED.** Foreman on 8 ST + 4 OT = 8×3.00 + 4×4.50 = $42.00 | `calculate.ts:288-297` (foreman), `:325-338` (HOURLY catalog premiums). DAILY premiums stay flat — no client statement |
| A3 | Seeded shift differential $3 / $4 | **Fixed — READ.** `SHIFT_2 amount: 3`, `SHIFT_3 amount: 4` | `apps/api/src/utility/seed-data.ts:566, :580` |
| A4 | Cross-midnight upgrade; spill into holiday | **Fixed (upward) — VERIFIED.** Tue 22:00→Wed(holiday) 04:00 = 2 OT + 4 H3X + 4 h holiday minimum. **Downward** (Sunday/holiday start running into a weekday) deliberately keeps the start day's type — see N1 and §D | `day-type.ts:137 sliceDayType` (rank, never downgrades), `calculate.ts:198` |
| A5 | Daily 4-h minimum at the ending multiplier | **Fixed — VERIFIED.** 2-h Sunday job → 2 DT + 2 h minimum @ $132.06 (2×) | `guarantee.ts:99-101` `multiplierOf(endingBucket)` |
| A6 | Minimums per calendar day | **Fixed — VERIFIED.** 2 h at 06:00 + 4 h at 17:00 same date (two chains) → no PAY-040 | `calculate.ts:729 applyCalendarDayMinimums` groups by `day.workDate` across chains |
| A7 | Rest stitch 30 → 0 | **Unchanged by design.** Still `REST_STITCH_MINUTES = 30`; the 2026-09-09 decision note parks it. Decision still owed | `shared/constants/payroll.ts:36` |
| A8 | Rest trigger ignores H3X/H2X; rate excludes shift + boom | **Unchanged — downgraded to Low.** Executing the scenario shows the trigger gap is practically unreachable: any return inside 8 h is already one *pricing* chain, so the ladder carries cumulative hours and pays ≥ the rest floor (holiday 9 h then 00:30→08:30 priced 3 OT + 5 DT with no rest line needed). Only the rate basis (`baseRate` alone) is a real, small drift | `rest-period.ts:83, :182` |
| A9 | Non-union weekly OT, 7th day, order, reasons | **Fixed — VERIFIED.** 6×8 h = 40 ST + 8 Weekly OT @ 1.5×; 7th day 10 h = 8 Seventh-day OT + 2 Seventh-day DT. Reasons survive in the component label; rule id stays `PAY-012` for all six | `non-union.ts` (Brian's §7 order), `calculate.ts:438` |
| A10 | Meals across a continuous span | **Fixed — VERIFIED.** 3 h + 3 h back-to-back with a taken lunch at 11:30 → one PAY-046 deduct | `calculate.ts:803 groupGaplessEntries` (gap 0), `:830 applyContinuousMealPeriods` |
| A11 | Paid span = dispatch start time vs punch-in | **Unchanged — still a question.** Paid window is still `WORK_TIME` punch-in; the schedule field is still named `leaveYardTime` (`schema.prisma:3604`) which Joe asked to rename to *start time* | `derive-ticket-times.ts` |
| B1 | Holiday 8-h minimum at 3× | **Built — VERIFIED.** 0.5 h on Veterans' Day → 0.5 H3X + 7.5 h minimum = $1,584.73. Implements **8 total** (top-up to 8), which is Brian's reading and the legacy app's; Corrina's "additional 8" sentence is registered as contested in `gaps.md` | `guarantee.ts:183 applyPremiumDayMinimums` |
| B2 | Special Saturday 8-h minimum at 2× | **Built — READ.** Same function, `H2X` multiplier | `guarantee.ts:183` |
| B3 | Shift hours-add +1.0 / +1.5 h | **Built — VERIFIED, with a new defect (N2).** 18:00→02:00 2nd shift → +1 h @ (66.03+3)×1.5 = $103.55 | `calculate.ts:274-284` |
| B4 | Subsistence $85 / $200 | **Built but unreachable — VERIFIED in the engine, not in the product.** 60 mi + holdover, two tickets same job/day → one $85; not holdover → none. But `Job.subsistenceDistanceMiles` / `subsistenceHoldover` have **no DTO and no UI** — nothing in `apps/web` or `apps/api/src/presentation` sets them, so every job prices $0 until a screen exists. PAY-049's "every day of the holdover, worked or not" deliberately not built (`gaps.md`) | `subsistence.ts`, `calculate.ts:893`, `schema.prisma:3376-3377` |
| B5 | Holiday observance shifting | **Fixed — VERIFIED.** 2027: `07-05` (Mon for Sun Jul 4), `12-24` (Fri for Sat Dec 25); 2028 New Year → `2027-12-31`, and `holidaysForPeriod` unions year+1 so a late-December period sees it | `day-type.ts:46 observedDate`, `:80 holidaysForPeriod` |
| B6 | Special Saturday = first Saturday after the first Friday | **Fixed — VERIFIED.** `2029-12-08` true, `2029-12-01` false, `2026-06-06` true | `day-type.ts:102` (`d >= 2 && d <= 8`) |
| B7 | Rounding-adjustment component | **Closed as inapplicable** — the engine computes a day's total one way only, so the tie-out line could never be non-zero. Documented in `gaps.md` (overlay `9a5c5a1`) | — |

### New findings from the re-audit

| # | Defect | Evidence | Severity |
| --- | --- | --- | --- |
| **N1** | **Holiday-start shift running past midnight is paid twice.** 22:00 (Veterans' Day) → 10:00 next day, 12 h worked: the engine prices **all 12 h at H3X** (start-day type kept, `sliceDayType`) **and then adds a 6-h holiday minimum**, because `hoursByDate` credits only the 2 h before midnight to the holiday date. Result **18 h paid at 3× = $3,565.62 for 12 h worked**; a plain 12-h holiday day pays $2,377.08. Neither reading of the rule produces this: keep-holiday-type → 12 H3X and no minimum (12 ≥ 8); Brian's 2026-09-11 reading (day type flips at midnight, accumulation continues) → 8 TRI + 10 OT = $2,575.17. The minimum must measure hours *priced as holiday*, not hours on the calendar date — or the day type must flip, which is the open §D question. **Introduced by PR #531**; overpays **$1,188.54** per occurrence | VERIFIED — scenario "OPEN holiday start 22:00 → 10:00": `PAY-033 Holiday 3x: 12h` + `PAY-033 Holiday 8-hour minimum: 6h`. Code: `calculate.ts:198` vs `:224-227` vs `guarantee.ts:190-200` | **High** (rare shape, large amount, overpay) |
| **N2** | **Shift hours-add fires per ticket, not per shift.** A 2nd-shift day split over two back-to-back tickets (18:00–22:00, 22:00–02:00) pays **two** `Second shift hours add` lines = +2 h, $207.10. The MLA's 7-worked/8-paid is per shift; the legacy app fires per entry too but its entries are one per day, whereas in the ERP every job is its own ticket. Should fire once per calendar day / gapless group, on the last entry | VERIFIED — scenario "B3 risk"; code `calculate.ts:274-284` runs inside `priceL12JobDay` | **Medium** (overpay, every multi-job night shift) |
| N3 | Comment drift only: `day-type.ts:41` says "MLK" for the third-Monday-of-February holiday; the code and the MLA both mean Presidents' Day. No money effect | READ | Cosmetic |

### Still open with the client (unchanged from §D, plus)

- **Holiday-start continuation** — Brian 2026-09-11: day type flips at midnight, accumulation
  continues (8 TRI + 10 OT); wants the rep to confirm whether a *holiday shift-start* exception
  exists. Corrina has not answered. **N1 sits on exactly this case** — whichever way it lands,
  the double-pay has to go.
- **Holiday minimum: 8 total vs 8 additional** — Brian says total (engine, legacy and his app
  agree); Corrina's one sentence says additional. Worth $480 at an $80 base per occurrence.
- **Rest stitch** (A7), **paid-span start** (A11) — as before.

### Updated per-occurrence table (2026-09-12)

| Defect | Per occurrence | Status |
| --- | --- | --- |
| Holiday-start past midnight double-paid (N1) | **+$1,189** overpay | open |
| Shift hours-add per ticket (N2) | **+$104** overpay per extra ticket on a 2nd shift | open |
| Subsistence unreachable (B4) | –$85 to –$200 per eligible day | open (needs UI) |
| Everything in the 2026-09-11 table below | — | fixed, verified |

**Suggested order now:** N1 and N2 (both new, both overpay, both small code changes), then the
subsistence job fields UI, then put the three §D questions to Corrina in one message.

---

# Baseline audit — 2026-09-11 (kept as written; statuses superseded by the table above)

## 0. How wrong are we — the short version

Of the ~30 money-affecting rules the client has actually stated, **~20 are built correctly, 11
are built but diverge from the client's latest ruling, and 7 are not built.** The correct set is
the common path: weekday day shifts, the 8/12 ladder, boom, rest, WTL. The divergences are at
the edges — night starts, holidays, minimums, premiums other than boom — and in non-union
weekly rules and subsistence.

**Every defect except item 6 underpays.** Scale per occurrence, at the 2025-07-01 G1 rate
$66.03 (MLA Art. IV):

| Defect | Per occurrence |
| --- | --- |
| Holiday 8-h minimum not built (B1) | –$1,486 on a half-hour holiday call-out; –$396 on a 6-h holiday day |
| Shift starting before midnight gets 4 h ST (A1) | –$132 per such shift |
| Shift hours-add not built (B3) | –$69 to –$138 per 2nd/3rd-shift day |
| Seeded shift differential $1/$1.50 not $3/$4 (A3) | –$28 per 2nd-shift day (8 ST + 4 OT) |
| Subsistence not built (B4) | –$85 to –$200 per eligible day |
| Non-union weekly OT not applied (A9) | –$140 on a 48-h week at $35/h |
| 4-h minimum priced flat, not at the ending multiplier (A5) | –$132 on a 2-h job that ended on DT |
| Foreman / military flat, not multiplied (A2) | –$6 / –$20 per 12-h day |
| Minimum grouped per chain not calendar day (A6) | **+$132** (overpay) on a 2-h + 4-h split day |

**Suggested order:** A1, A2, A3, A9 and B1 first — pure money on shifts that happen every week.
Then A4, A6, A10, B2, B3, B4. Section D items are questions for Corrina/Brian before any code.

---

## A. Built, but wrong against the client's stated rule

| # | Rule | Client (tier 1) | Code | Legacy (tier 2) | Severity |
| --- | --- | --- | --- | --- | --- |
| A1 | **Shift starting before midnight earns no ST** (PAY-021/023) | Corrina Bustos 2026-09-10 15:18–17:22: 22:00→14:00 = **12 OT + 4 DT**; "it doesn't start over at 6 A.M… that 6 A.M. rule is a wash". Kyle/Brian accepted. `meetings/2026-09-10-…md:50-57` | `packages/payroll-engine/src/day-type.ts:119` opens a fresh 8-h ST bank at 06:00 of the next calendar day → **8 OT / 4 ST / 4 DT**. **VERIFIED by running the engine.** Fix = the legacy guard: a slice can be ST only when its calendar date equals the shift's anchor date | `OT_Daily` has a same-date guard; next-day 06:00–17:00 → `Is_PrevDay_ST_Reentry_Block` → OT. `usp_Run_Pricing_Engine.PROC.sql:1002-1010, 1056-1114` | **High** — $132/shift, every night start |
| A2 | **Foreman, military, lattice adders go into the rate and ride the multiplier** (PAY-070/071/044) | Decision `decisions/2026-09-10-craft-adders-are-into-the-rate-multiplied.md` — Brian 21:48: "the long boom is just an addition to the base rate, like the lattice pay or the foreman pay or the military base pay… the multiplier that's applied gets applied to the whole thing." Corrina concurred; Brian confirmed in writing 2026-09-11. v5.1 workbook: FOREMAN 3.00/4.50/6.00/9.00, MILITARY 10/15/20/30 (`foreman-and-military-premiums.md:105-110`) | `calculate.ts:317` pays foreman flat `actualHours × foremanPerHour`; `calculate.ts:345` pays every catalog premium flat `units × amount`. Only boom (`:299`) and shift (`:308`) are multiplied | Not implemented (zero hits for foreman/military/lattice in 141 objects) | **Medium** — $6–$20/day, every foreman/military/lattice day |
| A3 | **Shift differential $3.00 / $4.00** (PAY-036/037) | MLA Art. III Shifts; Brian's config; Corrina 2026-08-04 1:00:19 "$4 extra an hour" | Engine default correct (`types.ts:20-21`), **but the seed catalog is $1.00 / $1.50** (`apps/api/src/utility/seed-data.ts:639, :652`) and `premiumRates()` prefers an ACTIVE seeded row (`payroll.service.ts` `rateFor`) → every seeded tenant pays $1/$1.50 | `cfg.Union_Shift_Rules` +3.00 / +4.00 | **High** on any 2nd/3rd-shift job; one-line data fix |
| A4 | **Cross-midnight: higher rate governs after 00:00, never a downgrade; spill into a holiday is holiday work** (PAY-019, `settled`) | Decision `decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md` (Corrina, `verified`): into Sat/Sun "irrelevant… already on Double time"; into a holiday → 3× **plus the 8-h minimum** | Day type classified **once** from the first slice (`calculate.ts:164`) and reused for every slice. `day-type.ts:134 bucketForSliceAnchored` implements the ruling exactly but **nothing calls it** (grep: only its own definition). A Thursday shift running into Friday July 4 pays weekday rates through | WorkDate-anchored too; `cfg.CrossMidnightDayTypePolicy` is never read by the engine. Both systems wrong; client ruling is the tiebreak | **Medium** — rare, large when it happens |
| A5 | **Daily 4-h minimum pays at the rate the shift left off at** (PAY-040) | Corrina 2026-06-11 21:55: "they would leave off on whatever they finished, whether that's overtime or double time, and it would be a four-hour minimum"; Melissa 23:19: "4 hours at the double time rate". `transcripts/2026-06-11-payroll-app-demo-02.md:158-174` | `guarantee.ts:90` pays `(base + shift) × DAILY_MINIMUM_MULTIPLIER` with the multiplier fixed at **1.0** (`shared/constants/payroll.ts:43`) | Flat × 1.00 — the code copied legacy | **Medium** — tiers directly oppose; one confirming question to Corrina, then change |
| A6 | **Minimums group per calendar work day** (PAY-040/043/033) | Brian 36:07 / Corrina 2026-09-10: holiday 8-h, shift 4-h, boom 4-h are "based on the calendar work day", more than one labor entry in scope. `meetings/2026-09-10-…md:138-141` | Grouped per **8-hour pricing chain** (`calculate.ts:459 CHAIN_GAP_HOURS`, `applyChainRules`). A 2-h 06:00 job + 4-h 17:00 job (9-h gap) → two chains → first gets a 2-h top-up the client says is not owed | Per `WorkDate` (`ShiftAnchorDate`) | **Low–Medium** — overpays |
| A7 | **Rest-chain stitch: back-to-back only** (PAY-045) | Brian 2026-09-09, written: the ≤30-min stitch "is **not itself a payroll entitlement rule**" — a bug in his app. `decisions/2026-09-09-work-chains-stitch-only-when-there-is-no-gap.md` | `REST_STITCH_MINUTES = 30` (`shared/constants/payroll.ts:36`), consumed at `rest-period.ts:106`. The decision note deliberately parks the ERP question (every ERP job is its own ticket, so `0` would rest-force two consecutive jobs a minute apart) | 30, hard-coded fallback too | **Decision needed**, not a silent copy either way |
| A8 | **Rest trigger and rest rate** (PAY-045) | Rule fires after any OT/DT period; forced hours continue the prior shift's rate (Corrina 2026-09-10 25:21–28:12) | `rest-period.ts:83 hasActualOtDt` counts only `OT`/`DT` buckets — a **holiday (H3X) or Special-Saturday (H2X)** chain never arms the rule. `rest-period.ts:182` prices the uplift on `baseRate` alone, **excluding shift and boom** | Trigger `Hrs_OT + Hrs_DT > 0` (holiday/special-Sat sit in `Hrs_DT`); rate = full slice rate incl. shift + boom | **Low** |
| A9 | **Non-union: weekly OT >40 and 7th-day, evaluated in order, six named components** (PAY-025/026/012) | Brian 2026-09-07, written, with 9 acceptance scenarios: daily → 7th-day → weekly; "CodingCops should not simply total the week's hours and calculate OT afterward". `non-union-hourly-rules-2026-09-07.md:43-97, 133-149` | `calculate.ts:399 priceNonUnionHourly` does daily 8/12 only. Weekly >40 raises an issue **named `WEEKLY_OT_APPLIED` but applies nothing** (`calculate.ts:771`). No 7th-day. All three lines carry one rule id `PAY-012` — the client wants the reason preserved | Fully built: `usp_Apply_CA_NonUnionAdminHourly_OT` — daily, 7th day, weekly, six ledger codes | **High** — every non-union 6-day week |
| A10 | **Meal periods are owed against the continuous work span** (PAY-046) | MLA: five consecutive hours; Brian 2026-09-03 3:55 "every five consecutive hours" | Meals resolved **per ticket** (`calculate.ts:280-297`). Two back-to-back 3-h tickets = 6 h continuous → one meal owed; the engine sees two 3-h entries and owes none | Groups gapless entries (`StitchGapMinutes = 0`), counts meals on the group span | **Low–Medium** |
| A11 | **Paid time starts at the dispatch start time** (PAY-017/021) | Decision `decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md` (Kyle Harlow, Joe Schacatano, `verified`): "that time that's inputted into the system on their dispatch should be… Exactly when their time starts. Not before it, not after it." | Paid window = `WORK_TIME` punch-in → Review & Complete (`derive-ticket-times.ts:299`). An early tap at 05:50 for a 06:00 dispatch pays from 05:30 after rounding | Uses keyed labor times | **Question** — the call was about dispatch fields, but the wording is unambiguous. Confirm before changing |

## B. Client-stated rules that are not built

| # | Rule | Client | Legacy | Notes | Severity |
| --- | --- | --- | --- | --- | --- |
| B1 | **Holiday 8-hour minimum at 3×** (PAY-033) | Corrina 2026-06-11 19:11 "Put 8 hours per day guaranteed on a holiday"; 2026-09-10 31:29–34:49 "even if they only work half an hour on the holiday, that has to get converted to 8 hour minimum"; per calendar date, summing every entry (`decisions/2026-09-04-…holiday-minimum.md`) | `HOLIDAY_MIN_8`: gap × (base + shift) × 3.00, pinned to the last holiday-slice entry | No code path. MLA Art. III Holidays §1 is unconditional | **High** |
| B2 | **Special Saturday 8-hour minimum at 2×** (PAY-034) | Brian 2026-08-24 summary "June+Dec specials ×2"; MLA "a minimum of eight (8) hours shall be paid at the double (2) time rate" | `SPECIAL_SAT_MIN_8`: gap × (base + shift) × 2.00 | Engine buckets `H2X` correctly (`day-type.ts:52 isSpecialSaturday`) but never tops up | **Medium** (two days a year) |
| B3 | **2nd/3rd shift hours-add — 7 worked → 8 paid, 6½ → 8** (PAY-036/037) | MLA Art. III Shifts; Brian 2026-08-24 "pay+time adds", placed at the end, priced "as if actually worked there" at the last slice's multiplier (`client-message-findings.md:190, 238`) | `usp_Apply_ShiftDifferentialHoursAdd`: +1.00 h / +1.50 h × (base + shift) × last-slice multiplier, boom excluded | Only the $/h adder exists | **Medium** |
| B4 | **Subsistence** (PAY-048/049) | 2026-08-20 SME call: **$85/day, 45–77.5 mi, days actually worked; $200/day, >77.5 mi, every day of the holdover worked or not** (`2026-08-20-payroll-rules-meeting-notes.md:97-106`). Decision `2026-09-01-subsistence-not-a-craft-attribute.md`: per job/trip, not per craft | Token-driven `$85` / `$85 Mon–Fri, $200 Sat–Sun` — the weekend hard-coding is the defect the client corrected | Export column hard-coded `0` (`xlsx-rows.ts:44, :80`). Needs yard→site distance on the job and a holdover flag | **Medium** |
| B5 | **Holiday observance shifting** (PAY-032) | MLA: Sunday holiday → Monday observed; Christmas or New Year on Saturday → preceding Friday | `dim.LU12_Holiday` carries the 2027 observed rows (07-05, 12-24, 12-31) | `day-type.ts:35 l12HolidaysForYear` uses fixed dates. **2027-07-04 (Sun) and 2027-12-25 (Sat) will misprice.** 2026-07-04 (Sat) is correct — the Saturday rule names only Christmas/New Year | **Low now, High in 2027** |
| B6 | **Special Saturday = first Saturday following the first Friday** | MLA text | `DAY <= 7` — same simplification | `day-type.ts:57`. Diverges only when the 1st is a Saturday (Dec 2029, Jun 2030) | **Low** |
| B7 | **Rounding-adjustment ledger component** (PAY-069) | Register-only | `PAY_COMPONENT_ROUNDING_ADJUSTMENT` when ledger ≠ gross by ≥ $0.01 | Components `round2`'d individually; no tie-out line | **Low** |

**In the MLA/FRD only — never spoken by the client, not in the legacy app.** Leave until asked:
2-h reporting pay (PAY-039) · crane-remains-on-job 4/6/8 tree (PAY-041) · first-day
travel/assembly exception (PAY-042) · hazmat $2 (PAY-038) · injury-day pay (PAY-056) ·
higher-rate-for-the-day (PAY-015).

## C. Built and consistent with the client's latest position

- Saturday–Friday week (PAY-001); start-down / end-up 30-min rounding (PAY-020,
  `slices.ts:29-41`); half-hour slices; one multiplier per slice, no pyramiding (PAY-027).
- 06:00–17:00 window; pre-06:00 hours are OT and **do not consume** the 8-h ST bank
  (`day-type.ts:93-123` — Corrina's example A, 04:00→23:30 = 2 OT / 8 ST / 2 OT / 7.5 DT,
  **passes**); 12-h DT on elapsed hours, and the 12-h cap binds first (example C, 00:00→14:00
  = 6 OT / 6 ST / 2 DT, **passes**).
- Saturday all OT then DT after 12 (PAY-030 — every source agrees; no 8-h Saturday rule exists
  anywhere); Sunday DT (PAY-031); holiday 3× (PAY-033); Special Saturday 2× (PAY-034);
  precedence Holiday › Sunday › Special Sat › DT › outside-window OT › daily OT › Saturday › ST
  matches legacy.
- Cumulative OT/DT carried across entries < 8 h apart (`CHAIN_GAP_HOURS`) — this is Corrina's
  2026-09-10 "starts in the bucket the previous shift ended in and fills to 12" model, so
  Brian's issue #2 (his app restarting per entry) does not exist here.
- Boom adder **into the rate, multiplied** (decision 2026-09-10; `calculate.ts:299`); window =
  build-up + boom + break-down, travel excluded (`derive-ticket-times.ts BOOM_PAY_TYPES`,
  decision 2026-09-03); slice must sit fully inside a window (legacy §4); adder from the
  bracket selected on the ticket, never from the crane's boom length; 4-h boom minimum, adder
  only, grouped per shift, priced at the **highest** boom bucket (legacy `MAX(Final_Multiplier)`
  — client has not confirmed "highest"; `gaps.md`).
- Rest period: 8 h required, 1.5× floor, 2× once the chain reaches 12 h, only the delta paid,
  guarantee gap hours never trigger it (Brian 2026-08-24 "added hours must not affect the
  8-hour rest rule"); prior-day context entries set state without being paid.
- WTL/meals (PAY-046/047): taken meal deducts the full priced slice **incl. boom**; worked-through
  adds back 0.5 × (base + shift) at a **2× floor**, boom excluded — so a holiday WTL stays at 3×
  (Brian 2026-09-03 34:20), deliberately *not* legacy's fixed 2×; recorded times win, the
  5 / 10.5 / 16 / 21.5 schedule is the fallback; **no lunch token → nothing added or deducted**
  (Corrina 2026-09-03 — correctly not copying legacy `ASSUME_WTL_0`).
- Lattice $1.00 / $0.50, Group 6+, whole job, job-level flag (PAY-044); military $10 for every
  employee on the job (PAY-071) — amounts right, multiplier wrong (A2).
- Non-union daily 8 / 12 on `Employee.hourlyRate` (decision 2026-08-25); no union components on
  non-union rows (Brian's scenario 9); salary excluded from labor pricing (matches the 2026-09-07
  legacy change); SYS employees excluded (PAY-007).
- Rate resolution refuses to guess: blocked rate → $0 + `RATE_*` issue (PAY-014); craft-locked
  secondary override (decision 2026-08-20/25); L12 mechanic priced as field with an
  `MECHANIC_RULES_UNCONFIRMED` issue.

## D. Open with the client — do not build either way yet

| Question | Who owes it | Where registered |
| --- | --- | --- |
| Shift **starting** on a holiday and running past midnight — stays 3× or reverts? | Corrina → union rep (2026-09-10 33:46) | `rules/PAY-033` |
| Rest-chain depth — previous entry only (Corrina) vs walk back until an 8-h gap (Brian) | unreconciled 2026-09-10 | `rules/PAY-045:70-76` |
| Do WTL added hours count toward the 12-h DT escalation? | Corrina to review/approve (Brian 2026-09-07) | `client-message-findings.md:700` |
| Lunch thresholds 16 / 21.5 (charts, legacy, engine) vs 16.5 / 22 (Atom app, meetings); first missed lunch absorbed vs added | Brian owes an update after TCG's 2026-09-09 internal meeting | `gaps.md`, `lunch-break-scenarios-2026-09-11.md` |
| 2nd shift "paid as if daytime" — Corrina 2026-08-04 implies the 06:00–17:00 window does not apply on a declared night shift; legacy applies it; engine applies it | not asked | new |
| Rest stitch 30 → 0 in the ERP (A7) | CodingCops to put the "what is the rest chain for" question | `decisions/2026-09-09-…`, `gaps.md` |
| Paid span starts at dispatch start time vs punch-in (A11) | confirm with Kyle/Joe | new |
| Luffers — lattice or boom-pay only | Kyle | `rules/PAY-044` |
| Non-union holidays, PTO, sick, shift differential | Brian: "no finalized rules" | `non-union-hourly-rules-2026-09-07.md:117-123` |

---

*Sources read for this audit: `meetings/2026-08-05` → `2026-09-10` summaries, `payroll/2026-08-20-payroll-rules-meeting-notes.md`, `non-union-hourly-rules-2026-09-07.md`, `lunch-break-scenarios-2026-09-11.md`, `client-message-findings.md` (by section), all `decisions/` notes tagged payroll; `legacy-payroll-app-db-extract/{rules-plain-language,config-values,worked-examples,open-questions}.md`, `calculations.md` (by section), `legacy-payroll-app-db-backup-2026-09-07/INDEX.md`; `erp-payroll-module-frd/`, `codingcops-rule-matrix.md`, `rules/PAY-###.md`, `payroll-rule-dependency-matrix.md`, `wtl-charts.md`, `adp-workbook-column-rules.md`, `source-attribution-and-conflicts.md`, `mcog-l12-mla-2025-2028/01,02,03`.*


---

## Post-audit note, 2026-09-12 — A4 reopened

The A4 fix in `015136f79` (`bucketForSliceAnchored` = `max(anchor day type, slice day type)`)
implements a **holiday shift-start floor** the union BA has now ruled does not exist
([../decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md](../decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md)). Run against the BA's own example after the fix: holiday 22:00 → 06:00 prices
**14 TRI = $3,360.00** against the union's **8 TRI · 4 OT · 2 DT = $2,720.00**; 22:00 → 10:00
prices **18 TRI** against **8 TRI · 4 OT · 6 DT**. Post-midnight slices must take
`max(cumulative-hours bucket, own calendar day type)`, not the anchor day's type. A second change
is new, not a regression: the holiday top-up hours must advance the 12-hour DT counter. Both in
`day-type.ts` / `guarantee.ts`; regression rows in the decision note.

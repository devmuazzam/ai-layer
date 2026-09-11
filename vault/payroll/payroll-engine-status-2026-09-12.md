---
title: Payroll engine — what is done and what is not, 2026-09-12
source: implementation-audit-2026-09-11.md re-audit, executed against app main e11e8cd60
migrated: 2026-09-12
updated: 2026-09-12
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, payroll-rules, as-built, status]
part_of: payroll/INDEX.md
---

# Payroll engine — done / not done

**As of app `main` `e11e8cd60` (2026-09-12).** Plain checklist for the dev. The evidence,
line numbers and client citations are in
[implementation-audit-2026-09-11.md](implementation-audit-2026-09-11.md); this page only says
which side of the line each rule is on. ✅ = built and executed against the client's worked
example · ☑️ = built, read but not executed · ❌ = not built or wrong · ❓ = waiting on the client.

## Done ✅

| Rule | What the engine does |
| --- | --- |
| Pay week | Saturday–Friday |
| Rounding | Start down, end up, 30-min; half-hour slices; one multiplier per slice |
| 06:00–17:00 window | Pre-06:00 is OT and does not eat the 8-h ST bank; 12-h DT on elapsed hours |
| Shift starting before midnight | No ST after midnight — 22:00→14:00 = 12 OT + 4 DT |
| Saturday / Sunday | Saturday all OT then DT after 12 h; Sunday DT |
| Holidays | 9 L12 holidays at 3×; Sunday → Monday observed; Christmas/New Year on Saturday → Friday |
| Holiday 8-h minimum | Top-up to 8 h at 3×, per calendar date, across entries |
| Special Saturday | First Saturday after the first Friday of June/December, 2×, 8-h minimum |
| Cross-midnight upgrade | Hours after midnight take the higher day type; spill into a holiday is holiday work + minimum |
| Cumulative OT/DT across tickets | Entries < 8 h apart continue the ladder (Corrina's "starts in the bucket the previous shift ended in") |
| Boom / long boom | Adder into the rate, multiplied; build-up + boom + break-down windows only; slice fully inside; 4-h boom minimum, adder only |
| Foreman / military / lattice | Into the rate, multiplied per bucket; lattice Group 6+, operator/oiler split; military all employees |
| Shift differential | $3 / $4 into the rate, multiplied; +1.0 h / +1.5 h hours-add at the last slice's multiplier |
| Daily 4-h minimum | Per calendar day; pays at the multiplier the shift ended on; admin exempt |
| Rest period | 8 h required; 1.5× floor, 2× once the chain reaches 12 h; only the delta paid; guarantee hours never trigger it |
| Meals / WTL | Grouped across gapless tickets; taken meal deducts the priced slice incl. boom; worked-through adds 0.5 h at a 2× floor on base + shift (3× on a holiday); no lunch token → nothing added or deducted |
| Non-union hourly | Daily 8/12 → 7th day → weekly > 40, in Brian's order, six reasons preserved; no union components |
| Salary | Excluded from labor pricing |
| Rate resolution | Blocked rate → $0 + issue, never a guess; craft-locked secondary override; L12 mechanic priced as field with a warning |
| SYS employees | Excluded |

## Built but not usable ☑️

| Rule | Why it pays nothing today |
| --- | --- |
| Subsistence $85 / $200 | Engine is right, but `Job.subsistenceDistanceMiles` and `subsistenceHoldover` have **no DTO and no UI** — every job prices $0 until a screen sets them |
| Subsistence on unticketed holdover days | Deliberately not built — needs a capture mechanism for which employee / which days |

## Wrong ❌ (new, introduced by the 2026-09-11 fix pass)

| # | Defect | Money |
| --- | --- | --- |
| N1 | Shift **starting on a holiday and running past midnight** is priced 12 h at 3× **and** given a 6-h holiday minimum — 18 h paid for 12 worked. The minimum measures calendar-date hours while the pricing keeps the holiday type past midnight | **+$1,189** overpay per occurrence |
| N2 | 2nd/3rd-shift **hours-add fires once per ticket**, not once per shift — a night split over two tickets gets +2 h | **+$104** overpay per extra ticket |

## Not built — never asked for by the client, MLA/FRD only

2-h reporting pay (PAY-039) · crane-remains-on-job 4/6/8 tree (PAY-041) · first-day
travel/assembly exception (PAY-042) · hazmat $2 (PAY-038) · injury-day pay (PAY-056) ·
higher-rate-for-the-day (PAY-015). Leave until asked.

## Waiting on the client ❓ — do not build either way

| Question | Who owes it |
| --- | --- |
| Holiday-start shift past midnight — stays 3×, or flips to weekday with continuous accumulation (Brian: 8 TRI + 10 OT)? **N1 sits on this case** | Corrina → union rep |
| Holiday minimum: 8 hours **total** (engine, legacy, Brian) or 8 **additional** (Corrina's one sentence)? | Corrina |
| Rest-chain stitch: back-to-back only (Brian, 2026-09-09) vs the 30-min tolerance the engine copied | CodingCops to ask; decision note parks it |
| Paid time starts at the **scheduled dispatch start** (Kyle/Joe) vs the crew's punch-in the engine uses; schedule field still named `leaveYardTime` | Kyle / Joe |
| Rest-chain depth — previous entry only (Corrina) vs walk back to an 8-h gap (Brian) | unreconciled |
| Do WTL added hours count toward the 12-h DT escalation? | Corrina |
| Lunch thresholds 16/21.5 vs 16.5/22; first missed lunch absorbed vs added | Brian owes an update |
| 2nd shift "paid as if daytime" — does the 06:00–17:00 window apply on a declared night shift? | not yet asked |
| Non-union holidays, PTO, sick, shift differential | Brian: "no finalized rules" |

## Next steps, in order

1. Fix N1 and N2 (small, both overpay).
2. Add the subsistence fields to the job DTO/UI so PAY-048 can pay.
3. Send Corrina the first four ❓ questions in one message.

---
title: Non-union hourly payroll rules — Brian Petros' summary and validation scenarios, 2026-09-07
source: user-supplied/chat — Brian Petros to Ehtesham, 2026-09-07 (eleven screenshots of an internal document, sections 4–11, 14, 15, plus the workweek statement and nine tests typed in the message)
migrated: 2026-09-07
updated: 2026-09-07
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, payroll-rules, non-union, overtime, seventh-day, open-questions]
entities: [payroll-rule, payroll-group, non-union-admin-hourly, non-union-admin-salary, pay-component, workweek]
part_of: payroll/INDEX.md
---

# Non-union hourly payroll rules — client summary, 2026-09-07

Brian Petros, prefacing it: *"nothing regarding the non-Union payroll rules have changed… nothing
different, just a summary."* It is nonetheless the **first single written statement** of the
non-union hourly rule set, the calculation order, the component taxonomy, and an acceptance test
list — everything before it was the legacy procedure's code (`rules-plain-language.md` §12) and
the 2026-06-09 group-predicate message. Sections 1–3, 12 and 13 of the underlying document were
**not in the message**; the numbering below is the document's own. Transcribed from screenshots;
verified against the register in [client-message-findings](client-message-findings.md#2026-09-07--non-union-hourly-rules-summary-and-nine-validation-scenarios-brian-petros).

## Payroll workweek

Saturday through Friday. All weekly-overtime and seventh-consecutive-day calculations are evaluated
inside that week. (Register: PAY-001, settled.)

## 4. California daily overtime

For a normal workday, Non-Union Admin Hourly:

| Hours worked during the workday | Classification | Multiplier |
| --- | --- | ---: |
| First 8 hours | Straight time | 1.0× |
| Over 8 through 12 | Daily overtime | 1.5× |
| Over 12 | Daily double time | 2.0× |

Example: $35.00/h, 13.00 h → 8 ST × 35 = 280.00; 4 OT × 52.50 = 210.00; 1 DT × 70.00 = 70.00;
total **$560.00**.

## 5. Weekly overtime

Evaluated **after** daily OT/DT and seventh-day. Once the employee exceeds **40 straight-time hours**
in the Sat–Fri week, remaining otherwise-straight-time hours become **Weekly OT at 1.5×**.

**No double counting:** hours already classified Daily OT, Daily DT, Seventh-Day OT or Seventh-Day DT
are never also counted as weekly OT. Weekly OT converts only hours that would otherwise remain ST.
*"Daily/seventh-day premiums are calculated first. Weekly OT is then applied only to remaining ST
hours."*

Example: Sat 8, Sun off, Mon–Fri 8 each → 40 ST by end of Thursday → Friday's 8 h = **8 Weekly OT**.
Seventh-day does not apply (Sunday not worked).

## 6. Seventh consecutive day

The system determines whether the employee worked **all seven days of the Sat–Fri workweek**. On the
seventh consecutive day:

| Hours on the seventh day | Classification |
| --- | --- |
| First 8 | Seventh-Day OT — 1.5× |
| Over 8 | Seventh-Day DT — 2.0× |

Example: 8.5 h on the seventh day → 8.00 Seventh-Day OT + 0.50 Seventh-Day DT.

## 7. Required calculation order

*"CodingCops should not simply total the week's hours and calculate OT afterward."*

1. Determine the employee's payroll workweek.
2. Determine the applicable workday for every labor entry.
3. Combine/summarize the employee's hours for that workday.
4. Determine whether the workday is the seventh consecutive day.
5. Apply Daily ST / OT / DT or Seventh-Day OT / DT.
6. Accumulate the remaining straight time across the Sat–Fri workweek.
7. Once remaining ST exceeds 40 hours, convert the applicable later ST hours to Weekly OT.
8. Calculate pay using the employee's regular non-union rate and the applicable multiplier.
9. Preserve the classification/reason for every resulting pay component, for audit.

## 8. Payroll components / audit categories

The legacy app's six explicit non-union components:

| Component | Meaning | Final bucket |
| --- | --- | --- |
| `NONUNION_CA_NONEXEMPT_ST` | Straight time | ST |
| `NONUNION_CA_NONEXEMPT_DAILY_OT` | Daily overtime | OT |
| `NONUNION_CA_NONEXEMPT_WEEKLY_OT` | Weekly overtime | OT |
| `NONUNION_CA_NONEXEMPT_DAILY_DT` | Daily double time | DT |
| `NONUNION_CA_NONEXEMPT_7TH_DAY_OT` | Seventh-day overtime | OT |
| `NONUNION_CA_NONEXEMPT_7TH_DAY_DT` | Seventh-day double time | DT |

The ERP need not use these names but **must preserve the reason hours became ST/OT/DT** — daily >8,
weekly >40 and seventh-day must stay distinguishable. *"Simply storing everything as generic 'OT'
would lose useful payroll/audit information."* Brian: every rule trigger is categorized so the
effect/cost of each rule can be reported.

## 9. Actual hours — no union minimums or guarantees

Non-union hourly is paid on **actual compensable worked hours**. None of: 4-hour minimum, 8-hour
guarantee, holiday guarantee, Special Saturday guarantee, long-boom minimum, union daily minimum.

## 10. Cross-midnight labor

7:00 PM → 1:30 AM is a positive duration ending the next calendar day. The employee's payroll
workday must remain available so daily accumulation, weekly accumulation, seventh-day status and
ST/OT/DT classification are right; cross-midnight entries must not lose hours or land in the wrong
workweek.

## 11. Time / data-quality controls

Flag missing start/end, invalid ranges, cross-midnight inconsistencies, duplicate and overlapping
labor records, other time-quality issues. *"The ERP should avoid silently producing payroll from
obviously invalid labor data."* (Register: PAY-028, PAY-029, PAY-060.)

## 14. Holidays, PTO, sick, vacation, etc. — **not yet finalized**

The non-union hourly specification has **no finalized rules** for: paid holidays, PTO, vacation,
sick pay, holiday eligibility, holiday-worked premiums, non-union minimum-hours rules, non-union
shift differential, bonuses, allowances, other administrative premiums. *"Not be inferred from the
Union payroll rules"* — separate configuration/policy items needing Payroll/Management confirmation.
Brian: *"we should discuss these more."*

## 15. Non-union admin salary

A separate payroll group. The system must **not** generate ST, Daily OT, Weekly OT, Daily DT,
Seventh-Day OT/DT from recorded labor hours. Compensation comes from configured salary/pay
information, not union craft rates; no boom/modifier calculations. Brian: *"we should also discuss
more about 'salary' (exempt) employee payroll… to make sure the ERP is able to process payroll for
these as well."*

## Suggested validation scenarios (non-union hourly)

*"Before we consider the ERP implementation complete, CodingCops should be able to demonstrate at
least the following tests."* ERP status verified 2026-09-07 against `packages/payroll-engine/src/calculate.ts`.

> **Update 2026-09-11 — all nine now pass,** as does the split-day caveat and the §8 reason
> requirement (six reason-labelled PAY-012 components). Built in
> `packages/payroll-engine/src/non-union.ts`, pinned by tests in `calculate.spec.ts`; see
> [gaps.md → *Payroll engine verification 2026-09-11*](gaps.md). The *ERP today* column below is
> the 2026-09-07 state, kept as the record of what was missing.

| # | Scenario | Expected | ERP today |
| --- | --- | --- | --- |
| 1 | Normal day, 8 h | 8 ST | ✅ `priceNonUnionHourly` (:241-253) — **per ticket**; two tickets on one day each get a fresh 8 h of ST, so a split day fails |
| 2 | Daily OT, 10 h | 8 ST · 2 Daily OT | ✅ same caveat |
| 3 | Daily DT, 13 h | 8 ST · 4 Daily OT · 1 Daily DT | ✅ same caveat |
| 4 | Weekly OT: 40 eligible ST reached before the last workday, then 8 more otherwise-ST hours | first 40 ST · additional 8 Weekly OT | ❌ weekly > 40 only raises `WEEKLY_OT_APPLIED` and flags the week; nothing is reclassified (:444-452) |
| 5 | Daily OT earlier in the week, then weekly accumulation | Daily OT stays Daily OT; Weekly OT converts only remaining eligible ST | ❌ as 4 |
| 6 | Seventh consecutive day: all seven days worked, 8.5 h Friday | 8.0 Seventh-Day OT · 0.5 Seventh-Day DT | ❌ no seventh-day rule in the engine |
| 7 | Missed day: six days worked, one non-worked day | seventh-day does **not** trigger; normal rules | ❌ (nothing to trigger yet — passes vacuously, fails as a rule) |
| 8 | Cross-midnight entry | positive duration, correct workday, correct daily/weekly accumulation, correct ST/OT/DT | ◐ duration and workday via `sliceWindow` (first slice's date); weekly accumulation does not exist yet |
| 9 | Union-rule isolation: non-union employee on data that would trigger L12 boom, guarantee, WTL, subsistence or Special Saturday | none of those components generated | ✅ `applyWtl` exits for non-L12 (:66); `priceNonUnionHourly` emits ST/OT/DT only. Existing spec covers only holiday classification (`calculate.spec.ts:345`) — add the nine as tests |
| — | §8 audit reason | daily vs weekly vs seventh-day distinguishable | ❌ components are `PAY-012` "Straight time / Overtime / Double time"; no reason beyond the bucket |

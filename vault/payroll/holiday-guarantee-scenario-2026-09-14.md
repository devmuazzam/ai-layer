---
title: "Brian's holiday-guarantee workbook — Labor Day 22:00 → 10:00, 'contract vs union rep' (14 September 2026)"
source: user-supplied/client-authored workbook — `___holidayGuaranteeScenario.xlsx`, Project Repository → `3.7.1_MODULE-HR-LABOR-PAYROLL`, sent by Brian Petros 2026-09-14 (two Teams messages, 05:02 and 05:11 PKT)
original_file: "___holidayGuaranteeScenario.xlsx — one sheet, 'holidayGuaranteeScenario'"
migrated: 2026-09-17
updated: 2026-09-17
status: unverified
conflicts_with: [decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md]
jira: []
tags: [module/payroll, kind/worked-example, holidays, guaranteed-hours, overtime, meal-periods, union-agreement, payroll-rules]
entities: [labor-entry, meal-period]
---

# Brian's holiday-guarantee workbook — 14 September 2026

Client-authored. Brian Petros's position is that the union rep's reading of the holiday 8-hour
guarantee overpays by **$1,440 per employee** ($5,760 for a four-person job) and conflicts with the
contract. **This file records what the workbook says and checks its arithmetic. It decides
nothing.** The open question is in [gaps.md](gaps.md) → *Holiday-start guarantee — Brian's
2026-09-14 workbook*.

Assets: [the workbook](assets/2026-09-14-brian-holiday-guarantee-scenario.xlsx) ·
[screenshot sent 05:02](assets/2026-09-14-brian-holiday-guarantee-scenario-0502.png) ·
[screenshot sent 05:11](assets/2026-09-14-brian-holiday-guarantee-scenario-0511.png).

## Brian's messages, verbatim

**Monday 2026-09-14, 05:02 PKT:**

> I have concerns about the recent Holiday scenario with Guaranteed 8-hours pay.
> I have created the scenario visually in Excel to explain how the Labor Union contract requires
> versus how our Labor Union rep explained to us.
>
> The difference is substantial... with the wrong interpretation resulting in an overpayment of
> $1,440 (assuming an hourly base rate of $80 per hour).
>
> That is an overpayment of $1,440 per employee...
> ... so would be closer to an overpayment of $5,760 (with 4 employees for that single job/day)
>
> I definitely do not want to "fix" our Payroll App calculations/logic with that interpretation.
>
> It conflicts with what the Labor Union contract language specifically/clearly explains/requires.
>
> Needs to be reviewed.
> Might be able to discuss during our meeting tomorrow (when talking about WTL scenarios)... if
> not, then next chance we should discuss to clarify.

**05:11 PKT:**

> Just updated a few formulas...
> ... same overpayment results as before.

05:02 PKT is Sunday evening in California. So "our meeting tomorrow (when talking about WTL
scenarios)" is most likely TCG's **internal** Monday 2026-09-14 WTL meeting ([gaps.md](gaps.md) →
*WTL scenarios `#2` and `#3`*). **No outcome from that meeting is on record.** The holiday question
did not come up on the 2026-09-15 or 2026-09-16 client calls; neither transcript mentions a
holiday.

## The scenario

| | |
| --- | --- |
| Shift | Mon 2026-09-07 22:00 (Labor Day) → Tue 2026-09-08 10:00 = **12.0 h** |
| Meal periods | 2 × 30 min, both taken, unpaid: **03:00–03:30** and **08:30–09:00** |
| Base rate | **$80.00/h**. Each timeline cell is a 30-min slot: TRI $120, OT $60 |

Cell formula (row 20 / row 26): `IF(TRI, base×3/2, IF(DT, base×2/2, IF(OT, base×1.5/2, IF(ST, base/2))))`.

| Row | 22:00–00:00 (holiday) | 00:00–06:00 (Tuesday) | 06:00–10:00 (Tuesday) |
| --- | --- | --- | --- |
| **"Without Holiday guarantee"** (rows 18/20) | TRI | OT | OT |
| **"With GUARANTEED 8 hours Holiday"** (rows 24/26) | TRI | **TRI** | OT |

The columns on the sheet:

- **"Original"** (row 18): 2 TRI + 10 OT = 12 h, **$1,680**.
- **"Employee did not work all allowed meal periods"**, Brian's reading (row 24, less the two
  breaks): **7.5 TRI + 3.5 OT = 11 h**.
- **"Union Rep wrong interpretation"**: the same row-24 hours, **plus 6 hours TRI** (`=E11*3*6` =
  **$1,440**), labelled *"substantial OVERPAYMENT"*. Row 54: `=AB48*4` = **$5,760** for four
  employees.

## What the three versions of the sheet compute

The sheet changed between the two messages ("updated a few formulas"). The copy in the shared
folder, downloaded 2026-09-17, is a third state.

| | Brian's reading, "Final" | Union column, "Total Pay" | Gap claimed |
| --- | --- | --- | --- |
| 05:02 screenshot | $1,680 − $120 − $60 = **$1,500**, next to a breakdown of 8.0 TRI / 4.0 OT / 12.0 | $1,500 + $1,440 = **$2,940** | $1,440 |
| 05:11 screenshot | $2,220 − $120 − $60 = **$2,040**, breakdown 7.5 / 3.5 / 11.0 | $2,040 + $1,440 = **$3,480** | $1,440 |
| Workbook as downloaded | `SUM(26:27)` $2,400 − $180 = **$2,220** | `SUM(26:26)` $2,220 − $180 = $2,040, + $1,440 = **$3,480** | $1,440 |

**Arithmetic checks, each reproducible from the formulas above:**

1. **05:02:** the "Final" starts from the *without-guarantee* total ($1,680, row 20). The
   breakdown beside it is the *with-guarantee* row, which prices at $2,400. The breakdown also
   says "minus 0.5 hours" but still totals 12.0.
2. **05:11:** row 26 already leaves the two lunch cells empty (they moved to row 27). So its
   $2,220 is already net of the breaks, and subtracting $180 again takes them off twice.
3. **As downloaded:** Brian's column is now consistent: 7.5 × $240 + 3.5 × $120 = **$2,220**.
   The union column still sums row 26 only and then subtracts the breaks, so it still deducts them
   twice. Priced the same way as Brian's column, it would be $2,220 + $1,440 = **$3,660**.
4. **In every version**, the "overpayment" is just the 6-hour top-up, 6 × $240 = $1,440. That
   figure never depended on the rest of the sheet.

## Against the record — what each reading pays

Same shift, **before meal deductions** (the only basis all the recorded readings share), $80 base:

| Reading | 22:00–00:00 | 00:00 → 10:00 | Pay |
| --- | --- | --- | --- |
| **Union BA via Corrina, 2026-09-12** ([decision](../decisions/2026-09-12-holiday-start-reverts-at-midnight-and-guarantee-hours-count-toward-twelve.md); confirmed on this exact 22:00→10:00 shape) | 2 worked + 6 top-up = 8 TRI | 4 OT, then 6 DT | **$3,360** |
| **Brian's app / Brian in writing, 2026-09-11** (reading (a) in the closed gaps entry) | 2 worked + 6 top-up = 8 TRI | 10 OT | **$3,120** |
| **Brian's workbook, 2026-09-14** ("contract") | 2 TRI | **6 TRI** (00:00–06:00), then 4 OT | **$2,400** |
| **Brian's workbook, 2026-09-14** ("union rep") | 2 TRI | 6 TRI, then 4 OT, **+ 6 TRI top-up** | **$3,840** |

Two observations. Both are arithmetic, not rulings:

- **The "union rep" column is not the BA's breakdown on record.** The BA priced the post-midnight
  hours at the Tuesday rate (*"after midnight would start at the applicable rate"*: 4 OT, then DT)
  and reached 8 TRI with the top-up. The pink column pays 00:00–06:00 at triple **and** adds the
  top-up. No named person on the record has stated that reading. If the rep explained something
  else to TCG after 2026-09-12, that explanation is not in the vault.
- **Brian's "contract" row pays six Tuesday hours at triple.** That meets the 8-hour minimum
  with worked time that falls after midnight. It departs from:
  - ruling (b) of the 2026-09-12 decision, which was not in dispute;
  - his own 2026-09-11 recommendation to *"split the worked timeline at midnight for day-type
    pricing"* and to keep the holiday minimum *"as a separate guarantee/top-up component"*;
  - his app's 8 TRI + 10 OT.

  It also pays **less** than every earlier reading: $960 below the BA ruling and $720 below his
  own app.

The contract text Brian cites
([mcog-l12-mla-2025-2028/01-article-iii-working-rules.md](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)
→ *Holidays* §1): *"A minimum of eight (8) hours at triple (3) time the regular rate of pay as
herein provided shall be paid for all work performed under this Agreement on the following
holidays"*. The clause says nothing about hours worked after midnight on a non-holiday.

## Not modelled by the sheet

- The 12-hour double-time mark: the sheet has no DT in any column. The BA's ruling (c) is the
  contested point in the *Added hours* entry.
- How the unpaid meal periods interact with the guarantee, or with the 12-hour counter. No one
  has ruled on either.

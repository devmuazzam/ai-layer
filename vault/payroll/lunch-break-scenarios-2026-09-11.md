---
title: "TCG lunch/break scenarios workbook — scenario #1 worked example (11 September 2026)"
source: user-supplied/client-authored workbook — `___LUNCH-BREAK_SCENARIOS.xlsx`, Project Repository → `3.7.1_MODULE-HR-LABOR-PAYROLL`, sent by Brian Petros 2026-09-11
original_file: "___LUNCH-BREAK_SCENARIOS.xlsx — sheet '#1 example (2)' (received as a CSV export of that one tab; the other tabs have not been seen)"
migrated: 2026-09-11
updated: 2026-09-11
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/worked-example, wtl, meal-periods, boom, overtime, payroll-rules]
entities: [labor-entry, meal-period, boom-premium]
---

# TCG lunch/break scenarios — scenario `#1`, worked example

The first client-authored pricing example for the meal/break scenario list Brian Petros opened on
2026-09-10 (`#0` break start/end times · `#1` employee takes all available breaks · `#2` employee
works all available breaks · `#3` employee takes only some). This file covers **`#1` only**.

> **Brian's own caveat, in the covering message:** *"these scenarios assume we don't know the
> start/end times of the lunch/breaks... but in the ERP will know when each employee started/ended
> each break"*. Read every placement below as the **entitlement schedule**, not observed data.

## The example

| | |
| --- | --- |
| Day type | Weekday, not holiday |
| Shift | 5:30 AM – 5:30 PM = **12.0 h** |
| Base rate | **$80.00**/h ($40.00 per 30-min slot) |
| Boom premium | **$4.00**/h ($2.00 per 30-min slot) |
| Meal periods allowed | **2** × 30 min = 1.0 h |
| Meals placed at | **10:30 AM** (5.0 h after start) and **4:00 PM** (10.5 h after start) |

**Rate buckets as the sheet draws them** — ST 8.0 h, OT 4.0 h, DT 0, HT 0:

- **5:30–6:00 AM → OT.** Outside the MLA's 6:00 a.m.–5:00 p.m. window
  ([mcog-l12-mla-2025-2028/01-article-iii-working-rules.md](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md) Art. III §1;
  [rules/PAY-021-l12-standard-work-window.md](rules/PAY-021-l12-standard-work-window.md)).
- **6:00 AM–2:00 PM → ST.** The eight straight-time hours start at 6:00 AM, so **the pre-window
  half hour does not consume the ST bank** — a modelling detail worth stating explicitly, because
  a plain "OT after 8 worked hours" reading would end ST at 1:30 PM.
- **2:00–5:30 PM → OT.**
- **Boom 6:30 AM – 3:30 PM = 9.0 h** (build-up through breakdown; the 5:30–6:30 AM hour is yard +
  travel, and the 3:30–5:30 PM tail is the return, matching
  [../decisions/2026-09-03-paid-straight-through-not-in-erp.md](../decisions/2026-09-03-paid-straight-through-not-in-erp.md)'s companion boom-window note in
  [../meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md](../meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md) §2).

**Original pay = $1,156.00** — ST 8 × $80 = $640, OT 4 × $120 = $480, boom 9 × $4 = $36. The
24 half-hour cells in the sheet's own grid sum to exactly $1,156.00.

## What the sheet asserts about a **taken** meal

1. **A taken meal is deducted from the bucket the meal actually falls in**, not from a default
   bucket: ST 8.0 → **7.5** (first break), OT 4.0 → **3.5** (second break). This is the concrete
   form of Brian's 2026-09-03 point that *when* the meal fell is load-bearing.
2. **The deduction is the whole priced slice at that moment, boom included.** Meal 1 at 10:30 AM
   deducts **$42.00** = $40 ST base + $2 boom. Meal 2 at 4:00 PM deducts **$60.00** = OT base only,
   because boom has already ended. This matches the legacy `WTL_MEAL_DEDUCT` basis
   (*full selected priced slice*) recorded in [rules/PAY-047-worked-through-lunch-adjustment.md](rules/PAY-047-worked-through-lunch-adjustment.md).
3. **Total duration drops 12.0 → 11.0 h.** The meal time is unpaid and leaves the hour totals.
4. **Boom is an unmultiplied adder.** The grid prices an OT-with-boom slot at **$62.00** = $60 + $2,
   not $63 — confirming [../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md](../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md) from the client side.

## ⚠️ The sheet's stated total does not follow from its own method

The Final column reads: `$1,114.00` (unlabelled) → `$(42.00)` *minus first break* → `$(60.00)`
*minus second break* → **Total pay `$1,012.00`**.

`$1,114.00` is `$1,156.00 − $42.00`, i.e. the first break **already removed**. Subtracting both
breaks again lands on $1,012.00, so **the first break is deducted twice**.

Both independent routes give the same correct figure:

| Route | Result |
| --- | --- |
| Grid sum − meal 1 − meal 2 = 1,156 − 42 − 60 | **$1,054.00** |
| Final buckets: ST 7.5 × 80 + OT 3.5 × 120 + boom 8.5 × 4 | **$1,054.00** |
| Stated on the sheet | $1,012.00 — **$42.00 low** |

**✅ Confirmed by the author, 2026-09-11.** Brian Petros, in writing, on being shown the
double-deduction: *"Yes… good catch. You are absolutely correct… that is a problem with the
scenario in the Excel… thank you."* and *"Next time I go into that Excel, I'll update the formula."*
So the **method in this file is TCG's, and the $1,012.00 figure is a spreadsheet defect** — read
every rule below as client-confirmed and the stated total as void until he reissues the sheet.
**The corrected total is $1,054.00** under the workbook's own flat-boom pricing, or **$1,057.00**
under the multiplied-boom treatment the ERP implements — see the *Boom adder* entry in
[gaps.md](gaps.md), which is **not** settled by this confirmation.

## What this example does **not** settle

- **Meal count thresholds.** At 12.0 h every competing source says 2 meals (legacy
  `cfg.WTL_MaxMealThreshold` 11.0–16.0 → 2; SCRUM-864 / Atom 5 h and 10.5 h deadlines both passed),
  so the 16.0-vs-16.5 and 21.5-vs-22 disagreement and the three-vs-four-lunch question are untouched.
- **Rolling vs cumulative meal clock.** Meal 2 at 4:00 PM is *both* 10.5 h after shift start and
  5.0 h after meal 1 ended. The example cannot distinguish the two schedules.
- **Whether boom is multiplied inside the deduction.** The discriminating case is a meal falling in
  an OT or DT slot *while boom is running* — deduct $63.00 (boom multiplied, the legacy
  `(base+shift+boom) × multiplier` formula) or $62.00 (boom flat, as the grid prices it). Meal 2
  lands 30 minutes after boom ends, so the sheet never tests it. **Ask for this case.**
- **Which hour figure drives the downstream clocks.** Paid duration falls to 11.0 h. Whether the
  DT-after-12-hours trigger (MLA Art. III §1) and the weekly-40 clock read 12.0 or 11.0 is not
  stated and does not bite at exactly 12.0 h.
- **Scenarios `#2` and `#3`** — worked meals and partly-taken meals — are not in this file.

## Related

- Register: [gaps.md](gaps.md) → *Field-ops lunch capture vs payroll WTL*
- Rules: [rules/PAY-046-meal-opportunity.md](rules/PAY-046-meal-opportunity.md), [rules/PAY-047-worked-through-lunch-adjustment.md](rules/PAY-047-worked-through-lunch-adjustment.md), [rules/PAY-021-l12-standard-work-window.md](rules/PAY-021-l12-standard-work-window.md)
- Raw export of the sheet: [assets/2026-09-11-lunch-break-scenarios-1-example-2.csv](assets/2026-09-11-lunch-break-scenarios-1-example-2.csv)
- Prior context: [../meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md](../meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md) §1

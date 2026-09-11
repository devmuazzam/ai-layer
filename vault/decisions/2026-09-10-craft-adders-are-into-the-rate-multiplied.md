---
title: "Craft adders go into the base rate and ride the multiplier — decision, superseding the 2026-08-25 on-top note"
source: decision/client recorded call (Brian Petros, 2026-09-10) + written confirmation (2026-09-11) + MLA Art. IV + as-built engine
decided: 2026-09-10
decided_by: Brian Petros (TCG — payroll consultant and author of the legacy Payroll App, the system of record for every pay rule in this module), unprompted and at length on the recorded 2026-09-10 "CC TCG ERP System" call at 21:48–22:09, explaining the no-pyramiding clause. Corrina Bustos (TCG Payroll Manager) concurred at 18:49 and 19:14 on the same call. Brian confirmed our reading in writing on 2026-09-11. Unopposed by anyone on the call.
status: verified
supersedes: decisions/2026-08-25-boom-adder-on-top-unmultiplied.md
resolves: [PAY-011, PAY-043, PAY-044, PAY-070, PAY-071, payroll/gaps.md#boom-and-craft-adders--into-the-rate-or-on-top-the-working-decision-now-has-tcg-saying-the-opposite]
tags: [module/payroll, kind/decision, boom, craft-modifier, overtime, union-agreement, payroll-rules]
---

# Decision

**A craft adder is added to the base rate first, and the day's multiplier then applies to the
sum.** This covers **long boom, lattice, foreman premium and military base premium**, and the
shift differential is priced the same way.

So on a $80.00 base with a $4.00 boom adder, an overtime half hour with the boom running pays
**$63.00** — ($40.00 + $2.00) × 1.5 — not $60.00 + $2.00 flat.

## The client's words

Brian Petros, **21:48–22:09**, arriving at it himself while explaining *no pyramiding*:

> whatever we determine as the multiplier for that payroll, for that slice of time, for each 30
> minute slice of time, there's only one multiplier being applied. So when it comes to whether it's
> one or 1 1/2 or two or three […] with respect to long boom, you know, there is no like, I'm not, I
> don't have a rate for like overtime, double time, long boom, you know, I'm just determining what
> long boom applies for that 30 minute slice and then the multiplier that's applied at the end, you
> know, to that 30 minute slice gets applied to the long boom. or whatever gets added to the base
> rate. **So like the long boom is just an addition to the base rate, like the lattice pay or the
> foreman pay or the military base pay, it gets added to the base rate, you know, and then at the
> end, the multiplier that's applied gets applied to the whole thing.** Not sure if that's exactly
> how you'll do it, but that's the way that seems to work out. And that satisfies the need to have
> like this no pyramiding of rates applied.

Ehtesham Anwar had already put the same shape to the Payroll Manager at **18:43** — *"it's going to
be 12 OT long boom and 4 DT long boom, right?"* — and Corrina Bustos answered **"Correct."**
(18:49), and again at 19:14 when asked whether any separate rule applies to long boom: *"Correct."*

Brian confirmed our reading in writing on **2026-09-11**: *"Nice… you understand it correctly."*

## Why this is the safe direction as well as the stated one

The literal clause of the agreement says the same thing, which is what makes this a low-risk
decision rather than a contested one —
[payroll/mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md](../payroll/mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md):

> The additional rate added to the regular rate shall be the base rate when computing overtime pay.

And the SCCA Southern California agreement says it of the foreman premium in the same terms —
*"added to the regular rate and become the base rate for the entire shift"*
([ocr-southern-california-mla-2025-2028-full-text.md](../payroll/mcog-l12-mla-2025-2028/ocr-southern-california-mla-2025-2028-full-text.md) → *R. Foreman*).

**This decision therefore requires no labor-counsel referral.** The obligation attached to the
superseded note existed precisely because that note sided *against* the contract's literal reading;
this one follows it.

## Why the 2026-08-25 note is superseded rather than amended

[2026-08-25-boom-adder-on-top-unmultiplied.md](2026-08-25-boom-adder-on-top-unmultiplied.md)
ruled the opposite — flat dollars per hour, *"not multiplied by OT / DT / holiday multipliers"*. It
was `status: reference`, decided by **Syed Haris (CodingCops, acting product owner)** rather than by
TCG, and it stated on its own face that it *"sides with a cleaned-up meeting transcript against a
literal clause of the Master Labor Agreement"*, that **TCG payroll and labor counsel must confirm
it**, and that the confirmation obligation travelled to `SCRUM-920`. That confirmation has now
arrived from the client and landed the other way. The obligation is discharged.

Two corrections of record, both established 2026-09-11:

1. **The note described behaviour the engine has never had.** It states `SCRUM-926` was built on it.
   `packages/payroll-engine/src/calculate.ts:299` prices the adder at
   `boomAdderPerHour * multiplierOf(bucket)`, and `calculate.spec.ts:578` asserts
   `ot.rate === BOOM_ADDER * 1.5` under the comment *"PAY-011: the adder rides the multiplier"* —
   unchanged since the module's first commit `61d0fd7d`. **No code change is required by this
   decision.** The shift differential (`calculate.ts:308`) and the meal deduction
   (`meal-periods.ts:173`) already follow the same treatment, so the engine is internally consistent.
2. **The remaining outlier is Brian's own scenario workbook.** `___LUNCH-BREAK_SCENARIOS.xlsx`
   prices an OT half hour with boom at **$62.00** — flat — giving a scenario #1 gross of $1,156.00
   against the $1,159.00 this decision produces. The $3.00 is the 1.5 boom hours sitting in overtime
   (14:00–15:30). Raised with Brian on 2026-09-11 and **not corrected by him**; he committed only to
   fixing the double-deduction in the Final column. **Expect scenarios #2 and #3 to arrive with the
   same flat-boom grid, and reconcile them to this decision rather than to the sheet.**

# Effect on the vault

- [`payroll/gaps.md#boom-and-craft-adders`](../payroll/gaps.md) — **closed** by this note.
- [`payroll/rules/PAY-011-l12-modifier-boom-rate.md`](../payroll/rules/PAY-011-l12-modifier-boom-rate.md)
  — its *"Decision note pending"* is answered, and its into-the-rate reading of the contract is the
  ruling. [`PAY-043`](../payroll/rules/PAY-043-long-boom-premium.md),
  [`PAY-044`](../payroll/rules/PAY-044-lattice-boom-premium.md),
  [`PAY-070`](../payroll/rules/PAY-070-foreman-premium.md),
  [`PAY-071`](../payroll/rules/PAY-071-military-base-premium.md) follow it.
- [`payroll/source-attribution-and-conflicts.md`](../payroll/source-attribution-and-conflicts.md) →
  *Into the rate vs on top* — **resolved: into the rate.** The 2026-08-20 meeting notes' *"add on
  top of whichever rate applies"* is `status: unverified`, cleaned from a transcript, and is
  overruled by the speaker's own later recorded explanation.
- [`payroll/lunch-break-scenarios-2026-09-11.md`](../payroll/lunch-break-scenarios-2026-09-11.md) —
  its observation that the grid prices boom flat stands as a **record of the sheet**, no longer as
  corroboration of a rule.
- `SCRUM-920` — the confirmation obligation carried from the superseded note is **discharged**.

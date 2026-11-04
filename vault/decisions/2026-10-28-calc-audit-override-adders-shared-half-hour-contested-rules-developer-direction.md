---
title: "Calculation audit 2026-10-28: a base-rate override on a no-craft-rate day still takes the boom adder and group premiums; back-to-back tickets sharing a rounded half hour are flagged, pay unchanged; contested pay rules held as questions; two defects against confirmed rows fixed (adders ride the rest floor; rest floor before meals): developer direction"
source: decision/Ali Riaz, developer direction in a Claude Code session, 2026-10-28 (Rulings 2–4 at 12:03 UTC, after the payroll calculation audit; Rulings 5–6 later the same session, after the gaps pass)
decided: 2026-10-28
decided_by: >-
  Ali Riaz (CodingCops developer; commits under the shared devmohsinakram git profile, as in the
  2026-10-06 payroll notes). At 12:03 UTC he answered three structured questions (Rulings 2–4),
  put to him as one batch after the 2026-10-28 calculation audit. Later in the same session he
  answered two more (Rulings 5–6). Those two came up after the gaps pass found the items were
  defects against confirmed rows, not contested readings. Where an option carries "(Recommended)",
  the session that asked added the tag. It does not reflect any TCG preference. He chose against it
  only in Ruling 3. These are developer directions, not TCG product decisions. They are therefore
  `status: reference`, on the same basis as
  2026-10-27-adp-re-export-of-a-sent-week-developer-direction.md. TCG payroll (Corrina Bustos,
  Brian Petros) was not consulted. They bind implementation now, and TCG can overrule them.
  Recorded by tcg-scrum 2026-10-28.
status: reference
supersedes: []
supersedes_partial: []
conflicts_with: []
related:
  - decisions/2026-10-19-pm-pa-manual-base-rate-override-kept-as-built.md
  - decisions/2026-08-20-craft-locked-rate-override.md
  - decisions/2026-08-24-payroll-time-rounding-method.md
  - decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md
  - decisions/2026-10-22-back-to-back-jobs-scheduled-without-overlap-overlap-is-billing-only.md
  - decisions/2026-09-10-craft-adders-are-into-the-rate-multiplied.md
  - ../payroll/rules/PAY-045-rest-period-premium.md
  - ../payroll/rules/PAY-047-worked-through-lunch-adjustment.md
  - ../payroll/legacy-payroll-app-db-extract/sql/calc/v_Calc_Pricing_Slices_API.VIEW.sql
  - ../payroll/payroll-rules-provenance.md
  - ../payroll/gaps.md
tags: [module/payroll, kind/decision, api, payroll-engine, pricing, payroll-rules, open-questions]
---

## Decision

These are five rulings from one session. Rulings 2–4 came in one batch at 12:03 UTC. Rulings 5–6
came after the gaps pass. Each is quoted verbatim and then stated plainly. (Ruling 1 of the same
session is
[2026-10-28-auto-recalc-reprices-pending-weeks-keeps-approved-weeks-frozen-developer-direction.md](2026-10-28-auto-recalc-reprices-pending-weeks-keeps-approved-weeks-frozen-developer-direction.md).)

### Ruling 2: a base-rate override on a day with no craft rate

**Question, verbatim:**

> "When a base-rate override covers a day whose craft rate is blocked (no craft rate configured),
> the boom adder and group-gated premiums can't be resolved today, so the override pays flat. Your
> rule was "add boom rate in 15$". What should happen?"

**Chosen, verbatim:**

> **Resolve boom & premiums anyway (Recommended)**: "Resolve the boom adder and craft group from the
> employee's craft/modifier even when the base-rate row is missing, so the override + adders applies
> as you specified. Also raise a non-blocking warning so the missing craft-rate setup stays
> visible."

**What it means.** On a day with no craft rate configured, the override is still the base rate.
The boom adder and the craft-group-gated premiums are now priced on top of it, as they are on a
normal day.

**Before:** on such a day the override paid flat. The adder and the premiums were not applied,
because the code could not resolve them without the base-rate row.

**The warning.** A non-blocking `OVERRIDE_WITHOUT_CRAFT_RATE` warning is raised. Its message is
*"No craft rate is configured for this day (…) — paid at the base-rate override."*

**What it extends.** This extends an earlier ruling Ali Riaz made the same day. That ruling has no
decision note of its own. It is recorded in the
[payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md) row *"Base-rate
override drives the ERP calc, not just the ADP export"* (ADP-PAYDATA-EXPORT U5d). Its words were
*"now add boom rate in 15$ and everyother thing will be added into 15$"*.

**As built** (checked in the platform working tree on branch
`fix/auto-recalc-preserves-approved-weeks`, uncommitted, 2026-10-28):

- When only the base-rate row is missing, the resolver returns `craftOnly`
  (`apps/api/src/service/craft-rate-resolver/craft-rate-resolver.service.ts`).
  - `craftOnly` holds the craft its existing `resolveCraft` settles for the day, plus that craft's
    boom adder and wage group.
  - So the rules for which craft and union supply the adder are unchanged (2026-09-25, 2026-09-28).
    Only the base-rate lookup is bypassed.
- `apps/api/src/usecase/payroll-pricing/pay-week-assembly.ts` prices the day on `craftOnly` when an
  override is set, and adds the warning.

**What this ruling rests on.** The override itself is
[2026-10-19-pm-pa-manual-base-rate-override-kept-as-built.md](2026-10-19-pm-pa-manual-base-rate-override-kept-as-built.md)
(`reference`, pending ratification). That note's `conflicts_with` names the `verified`
[2026-08-20-craft-locked-rate-override.md](2026-08-20-craft-locked-rate-override.md), which says
*"never a free-text dollar override"*. This ruling only changes how the override prices on one kind
of day. If TCG upholds 2026-08-20 against the override, this ruling falls with it.

### Ruling 3: back-to-back tickets that share a rounded half hour

**Question, verbatim:**

> "Back-to-back tickets that hand over off a half-hour mark (e.g. A 06:00–12:10, B 12:10–15:00)
> each round outward, so the shared half hour is paid twice — 20 such tickets paid 20h for 10h of
> work. No rule says to pay a slot twice. How should I handle it?"

**Chosen, verbatim:**

> **Only flag it, don't change pay**: "Raise an OVERLAPPING_LABOR issue when the rounded windows
> overlap so a reviewer sees it, but keep paying both tickets in full."

**Rejected:** **Fix: one ticket owns each slot (Recommended).** On the example, A and B together
are paid 9.5 h / $615 today. The fix would have paid 9.0 h / $570, the same as one 06:00–15:00
ticket.

**What it means: pay is unchanged.**

- Each ticket is still rounded on its own, start down and end up to the half hour. That is the
  `verified` [2026-08-24-payroll-time-rounding-method.md](2026-08-24-payroll-time-rounding-method.md).
- So a half hour shared by a handover off the half-hour mark is paid on both tickets.
- The engine now raises `OVERLAPPING_LABOR` when the **rounded** windows overlap, even though the
  clock times do not.

**As built** (same working tree):

- The check is `flagOverlappingLabor` in `packages/payroll-engine/src/calculate.ts`.
- `OVERLAPPING_LABOR` has `warning` severity
  (`packages/shared/src/constants/payroll-issue-severity.ts`). The default approval-blocking list
  excludes warnings, so it does not block approval.
- The PAYROLL-FLAGS `OVERLAPPING_JOBS` flag works differently. That is the "overlap" flag in
  Corrina's `verified`
  [2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md),
  which blocks approval.
  - It measures raw clock windows (`overlapHours` in
    `apps/api/src/usecase/payroll-flags/payroll-flag-detection.service.ts`).
  - So it does **not** fire on a 12:10 handover. This ruling does not change it.

### Ruling 4: contested pay rules found by the 2026-10-28 calculation audit

**Question, verbatim:**

> "The ~15 contested pay rules (meal penalties on weekends/holidays, 2nd+ WTL, rest premium on
> adders, lunch vs 4h minimum, holiday observance, Sunday carryover, etc.) — several cite the union
> contract, but the engine was written the other way on purpose and the vault lists them as owed by
> Brian/Corrina."

**Chosen, verbatim:**

> **Record as questions, no pay change (Recommended)**: "Write each into vault gaps.md with the
> probe evidence, dollar impact and the named owner (Brian Petros / Corrina Bustos). Pay stays as-is
> until they rule. Required by the pay-rule guardrail (G4)."

**What it means:**

- No engine change for any of these rules.
- Each one is an open question: see the entries dated 2026-10-28 in
  [payroll/gaps.md](../payroll/gaps.md), which are being written separately.
- **This note rules on none of them.** It does not record which way any rule should go, and it
  takes no side on the contract readings. It records only that pay stays as built until Brian Petros
  or Corrina Bustos rules.
- **Two items were later taken out of this set.** Ruling 4 covers the items that are actually
  contested. The later gaps pass found that two items on the audit's list were defects: the engine
  contradicted rows the provenance table already marks **Confirmed**. Those two were put to the
  developer separately, as Rulings 5 and 6 below, and are fixed rather than held. Everything else
  on the list stays under Ruling 4.

### Ruling 5: the rest-period premium applies to the adders too (PAY-045)

**Question, verbatim:**

> "The rest-period premium (PAY-045) lifts only the base rate to the 1.5×/2× floor; shift, boom,
> foreman, lattice and military adders stay at 1×. The verified 2026-09-10 decision (Brian, MLA Art.
> IV) says adders go into the rate and ride every multiplier, and the legacy app prices rest on
> base + shift + boom. I'd listed this as contested, but nothing defends base-only. Fix it?"

**Chosen, verbatim:**

> **Fix: adders ride the rest floor (Recommended)**: "Rest premium = (base + shift +
> foreman/lattice/military, + boom on boom hours) × (floor − bucket). Cites the verified 2026-09-10
> decision in provenance. Raises pay on every rest-forced shift that has an adder."

**Rejected:** **Keep base-only, record as a question.**

**What it means.** On a half hour that the 8-hour rest rule forces up to the ×1.5 or ×2.0 floor,
the floor now applies to the whole hourly rate, not just the base:

- base, plus shift differential, plus foreman, lattice and military premiums;
- plus the boom adder, on boom hours only.

This **raises pay** on every rest-forced shift that has an adder.

**Sources it rests on:**

- **[2026-09-10-craft-adders-are-into-the-rate-multiplied.md](2026-09-10-craft-adders-are-into-the-rate-multiplied.md)**
  (`verified`; Brian Petros, MLA Art. IV). Brian's words: *"the multiplier that's applied gets
  applied to the whole thing"*.
  - That note does not name the rest premium.
  - Applying it to the rest floor is the developer's reading of "the multiplier that's applied"
    for a slice. That reading is what this ruling adopts.
- **Provenance rows** in [payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md):
  - *"Craft adders go into the rate and ride the multiplier"* (**Confirmed** + **Contract**).
  - *"8-hour rest — effect"* (**Confirmed** + **Legacy**): ×1.5 floor, ×2.0 once the chain passes
    12 h, increase only.
- **The legacy pricing view**,
  [payroll/legacy-payroll-app-db-extract/sql/calc/v_Calc_Pricing_Slices_API.VIEW.sql](../payroll/legacy-payroll-app-db-extract/sql/calc/v_Calc_Pricing_Slices_API.VIEW.sql):
  - Lines 126–131 build `Hourly_Rate_Raw` as `Rate_Base + Rate_Shift + Rate_Boom_Applied`.
  - Lines 171–172 price every slice as that rate × `Final_Multiplier`.
  - In the view it reads from
    (`v_Calc_Pricing_Slices_API_Legacy_Pre51K.VIEW.sql`, line 231), a prior-day ST re-entry slice
    takes `Mul_OT`.
  - The view describes itself as a *"diagnostic/UI reconstruction"* that *"must mirror
    app.usp_Run_Pricing_Engine"*. It is evidence of what the legacy app did, not a ruling.

### Ruling 6: price the rest floor first, then meals (PAY-047)

**Question, verbatim:**

> "Meals are priced before the rest floor. So a taken meal on a rest-forced half hour deducts only
> the pre-rest rate and leaves part of an unpaid meal paid, and a worked-through lunch there stacks
> on the floor. PAY-047 records the legacy order as rest first, then meals, and the engine's own
> comment says the deduction removes what the half hour was actually priced at. Fix the order?"

**Chosen, verbatim:**

> **Fix: rest floor first, then meals (Recommended)**: "Price meals on the rest-adjusted bucket, so
> a taken meal removes exactly what its half hour paid, and the worked-through lunch floor is
> measured against the rest floor. Cites PAY-047's verified order of operations in provenance."

**Rejected:** **Keep current order, record as a question.**

**What it means.** Meals are now priced on the bucket after the rest floor has been applied.

- **A taken meal** on a rest-forced half hour deducts what that half hour actually paid. Before, it
  deducted only the pre-rest rate, so part of an unpaid meal stayed paid.
- **A worked-through lunch** there is measured against the rest floor. Before, it stacked on top of
  the floor.

**Sources it rests on:**

- **[payroll/rules/PAY-047-worked-through-lunch-adjustment.md](../payroll/rules/PAY-047-worked-through-lunch-adjustment.md)**,
  *"Order of operations, verified in the 2026-09-07 backup"* (line 38).
  - `usp_Apply_WTL_MealPeriods` takes its slices from the rest-adjusted
    `v_UI_Pricing_Slices_PayrollEffective`, so the deduction basis is priced after the rest floor:
    *"Rest before WTL."*
  - **"Verified" there means checked against the legacy code** in the 2026-09-07 backup. No person
    adjudicated it. The rule file itself is `status: open`.
- **Provenance rows:**
  - *"Taken meal — deduction"* (**Confirmed**): *"Deduct the whole priced half-hour, in the bucket
    it fell in, boom included"*.
  - *"Worked-through meal — penalty"* (**Contract** + **Confirmed**): deduct, then +0.5 h at
    **≥ ×2** on base + shift, boom excluded.

## Why

- **Ruling 2.** Under the same-day ruling, an override pays the override plus the adders. On a day
  with no craft rate, it paid the override alone, which did not match. The warning keeps the
  missing craft-rate setup visible, so the override does not hide it.
- **Ruling 3.** No reason beyond the chosen option's own text was given, and none is supplied here.
  The result is that pay stays where the engine already had it, and the question of how to pay it
  stays with Brian (below).
- **Ruling 4.** As the option says: guardrail G4. A pay rule changes only with a source in
  `payroll/payroll-rules-provenance.md`, and none of these has a client ruling.
- **Rulings 5 and 6.** Unlike the Ruling 4 items, these already have a source: Confirmed provenance
  rows, and for Ruling 5 a `verified` decision. The engine was the outlier. In the Ruling 5
  question's words: *"nothing defends base-only."* Fixing them follows written sources, which is
  why they were not held as questions. G4 still applies: each fix cites its source in the
  provenance table in the same commit.

## Relation to existing notes

**Supersedes nothing.** No clause of any note is overturned, in full or in part.

- **Ruling 2** extends the provenance row named above, which has no decision note of its own. It
  does not touch 2026-10-19 or 2026-08-20; their standing is described under Ruling 2.
- **Ruling 3** leaves these unchanged:
  - the verified 2026-08-24 rounding note;
  - [2026-09-09-work-chains-stitch-only-when-there-is-no-gap.md](2026-09-09-work-chains-stitch-only-when-there-is-no-gap.md);
  - the verified 2026-09-30 flag list.
- **For whoever takes the Ruling 3 question to Brian:** on 2026-10-22 Kyle Harlow said the employee
  is *"paid only for time worked"*. This is recorded in the `verified`
  [2026-10-22-back-to-back-jobs-scheduled-without-overlap-overlap-is-billing-only.md](2026-10-22-back-to-back-jobs-scheduled-without-overlap-overlap-is-billing-only.md),
  38:57. He said it about double booking, and that note states it changes nothing in payroll. It is
  context here, not a conflict this note settles.
- **Ruling 4** changes no note.
- **Ruling 5** applies the `verified` 2026-09-10 note to the rest premium. It neither supersedes nor
  changes that note.
- **Ruling 6** follows the order recorded in PAY-047. It changes no decision note. The verified
  2026-08-24 rounding note and the PAY-045 rest rule (the floor values) are unchanged.

## What this does not decide

1. **Ruling 2:**
   - Whether TCG ratifies the base-rate override at all. See 2026-10-19, pending Corrina Bustos and
     Brian Petros.
   - A day whose **craft** cannot be resolved, as opposed to one missing only its base-rate row.
     The ruling speaks only of the missing base-rate row.
   - The open item already on the provenance row: whether an override should re-rate the guaranteed
     and long-boom-gap hours that the ADP export keeps on PRIMARY.
2. **Ruling 3:** how overlapping labor is **paid**. It stays open with Brian Petros. See the
   provenance row *"Duplicate / overlapping labor (PAY-028/029)"*, where Brian wrote on 2026-09-09:
   *"not sure if/how we will handle overlapping labor entries in ERP yet"*.
3. **Ruling 4:** every contested rule. Each has its own entry dated 2026-10-28 in `payroll/gaps.md`.
   The owners are Brian Petros and Corrina Bustos.
4. **Ruling 5:** the open item already on the *"8-hour rest — effect"* row is unchanged. Chain depth
   on 3+ short rests is still Brian versus Corrina.
5. **Ruling 6:** the open items on PAY-047 are unchanged. These are ×3 on holidays, which the engine
   floors at ≥ ×2, and Brian's pending WTL rework.
6. **Rulings 5 and 6:** how they were built. This note does not describe or check the
   implementation; the PR does.

## Effect on the vault

- **No `status` changed anywhere.** No file is verified or superseded, and no other file's
  frontmatter was edited.
- **Done.** [payroll/INDEX.md](../payroll/INDEX.md) → *Decisions that bind this module*: one line
  added for this note.
- **Not done in this pass:**
  - `payroll/payroll-rules-provenance.md`: being linked separately. Rulings 2, 5 and 6 change pay,
    so G4 applies. Ruling 3 adds an engine warning and leaves pay unchanged.
  - The *Effect on the vault* section and the INDEX line were updated when Rulings 5–6 were added,
    the same day.
  - `payroll/gaps.md` (the Ruling 4 entries): being written separately.

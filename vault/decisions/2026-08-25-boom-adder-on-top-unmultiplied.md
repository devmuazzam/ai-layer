---
title: Boom adder is paid ON TOP, flat $/h × boom hours, unmultiplied — WORKING decision, not confirmed by labor counsel
source: decision/acting-product-owner, relayed via the SCRUM-926 coordinator
decided: 2026-08-25
decided_by: Syed Haris (CodingCops, acting product owner), 2026-08-25, relayed via the SCRUM-926 coordinator and recorded in aidlc/SCRUM-926/spec.md §12 Q3. NOT confirmed by TCG payroll (Corrina Bustos / Brian Petros) and NOT reviewed by labor counsel, both of which this decision itself requires.
status: reference
resolves: aidlc/SCRUM-926/spec.md#q3
conflicts_with: [payroll/mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md]
jira: [SCRUM-926, SCRUM-920]
tags: [module/payroll, kind/decision, boom, craft-modifier, overtime, union-agreement, payroll-rules]
---

# Boom adder is paid on top of the multiplied rate — and this is a working decision

> **Read the status line before you build on this.** `status: reference`, not `verified`.
> A named human decided it and `SCRUM-926` was built on it, but it **sides with a
> cleaned-up meeting transcript against a literal clause of the Master Labor Agreement**,
> and **a planning decision does not amend a collective bargaining agreement**. TCG payroll
> and labor counsel must confirm it. The confirmation obligation travels to `SCRUM-920`.

## Decision

The boom adder is paid **ON TOP**.

1. It is a **flat dollars-per-hour figure × boom hours**.
2. It is **not multiplied** by OT / DT / holiday multipliers.
3. It is **not folded into the base rate** for computing overtime.

## Why

Two written sources point opposite ways, and neither is verified:

- **`payroll/mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md`**
  (9.6 KB, `updated: 2026-06-23`) — *"The additional rate added to the regular rate shall be
  the base rate when computing overtime pay."* Read literally, that is **into the rate**: the
  adder joins the base before the multiplier, so a long-boom hour at double time pays double
  the adder too.
- **`payroll/2026-08-20-payroll-rules-meeting-notes.md`** (8.5 KB, `2026-08-20`,
  `status: unverified`, cleaned from a transcript) — *"Boom-time premiums are unaffected —
  they add **on top** of whichever rate applies."*

`payroll/rules/PAY-011-l12-modifier-boom-rate.md` reads the contract as into-the-rate across
the board with two carve-outs, and states plainly **"Decision note pending"** — it is a working
reading, not an adjudication. `payroll/source-attribution-and-conflicts.md` → *Into the rate vs
on top* carries the same conflict.

The decision chose the meeting notes: it reflects how TCG says it actually pays, and the
`LB` OT / DBL / TRI columns in the ADP export were cited as corroboration.

**This is exactly where the reasoning stops being sufficient**, and the note says so rather
than dressing it up:

- The MLA is a **collective bargaining agreement**. A CodingCops planning call cannot amend
  one, and the meeting notes it relies on are `status: unverified` and were cleaned from a
  transcript.
- **Getting this wrong underpays overtime on every long-boom hour** — a wage-and-hour
  exposure, not a rounding difference.
- The corroborating claim is itself unsourced: **no `LB` earning code appears anywhere in the
  vault.** `payroll/rules/PAY-067-adp-export.md` is `status: conflicted`. The closest written
  analogue is the REG/OT/DT/TRI shape recorded for the Foreman (`FRT`) and Military (`MLT`)
  premiums in `payroll/foreman-and-military-premiums.md` — which raise the *same*
  multiplied-or-not question and do not answer it. Treat the `LB`-column citation as the
  decision's own claim, not as evidence.

## Why nothing in SCRUM-926 is at risk either way

**This epic composes nothing.** REQ-20 returns the base rate and the boom adder as **two
separate values** and leaves the arithmetic to the payroll engine — a design choice that stays
correct under both readings, which is precisely why it was made. The as-built resolver
(`apps/api/src/service/craft-rate-resolver/craft-rate-resolver.service.ts`) documents the adder
as *"a flat dollars-per-hour figure **on top**; how it combines with overtime multipliers is
the engine's decision"* and returns `boomAdder` alongside `baseRate` without combining them.

So REQ-20 **keeps its `[CONFLICT]` flag** and the confirmation obligation travels with the flag
to the payroll-engine ticket under **`SCRUM-920`**, where the composition actually happens.
Nothing here is blocked on it.

## Two implications for SCRUM-920

1. **On top, unmultiplied means the adder needs boom hours as its own quantity**, not a rate
   adjustment. That is a different shape from every premium that rides the base rate, and it
   has to exist in the data model before the engine can price it.
2. **The ADP export is affected.** Whichever way this lands, the `LB` OT / DBL / TRI columns
   have to be reconciled against `PAY-067` (`status: conflicted`) and against the `FRT` / `MLT`
   precedent, and the earning code has to be sourced from someone at TCG — the vault does not
   contain it.

## What would settle it

A reading of MLA Article IV from **TCG payroll (Corrina Bustos / Brian Petros) or labor
counsel**, answering **per pay component** rather than once — `PAY-011` notes that the
composition has to be stated component by component, and a single global answer will not
survive contact with the carve-outs.

One-line-answerable form: *"On a double-time hour with an 80 ft boom, does the crew member
earn 2 × (base + boom adder), or 2 × base + boom adder?"*

## Effect on the vault

- **No winner declared, and no `status:` flipped.** The MLA article and the meeting notes
  still disagree; this note records which side the build took and why, not which document is
  right. `payroll/mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md` and
  `payroll/2026-08-20-payroll-rules-meeting-notes.md` are untouched.
- `payroll/rules/PAY-011-l12-modifier-boom-rate.md`'s *"Decision note pending"* is **partly**
  answered: this is that note, and it is a working decision. The rule's own blocking items stay
  open.
- `aidlc/SCRUM-926/spec.md` §12 Q3 → resolved as a working decision (see this note); REQ-20
  keeps `[CONFLICT]`.
- No vault file body was edited.

---

## 2026-09-09 — the confirmation this note demanded has arrived, and it lands the other way

This note requires confirmation by TCG payroll. Two independent things now contradict point **2**
(*"not multiplied by OT / DT / holiday multipliers"*):

**1. TCG's own system of record multiplies it.** Brian Petros sent a real Payroll App entry on
2026-09-09 — Rafael Garcia, ticket `43694`, 2026-04-08, modifier `OI-BP-05` at **$1.25/hr**, boom
window `7:00 AM–9:00 PM` split `7.0 ST / 1.5 OT / 5.5 DT`. The printed boom add is **$25.31**.

- Flat, unmultiplied, as this note decides: `14.0 × $1.25 = $17.50`.
- Multiplied per bucket: `7.0×1.25 + 1.5×1.875 + 5.5×2.50 = $25.3125` → **$25.31**.

The entry is arithmetically closed — its base rate recovers as `($2,107.61 − $25.31) / 30 = $69.41`,
the L12 Group VI rate on the wage sheet exactly — so the $25.31 is not a rounding artefact.
Exhibit: [../payroll/client-message-findings.md](../payroll/client-message-findings.md), 2026-09-09
long-boom section.

**2. The ERP already ships the opposite of this decision.**
`packages/payroll-engine/src/calculate.ts:299` computes
`input.boomAdderPerHour * multiplierOf(bucket)`. Whatever was decided here, it is not what was
built, and what was built agrees with TCG's app to the cent.

This also removes the note's central tension: it sided with a cleaned-up transcript **against**
MLA Article IV, and the incumbent's arithmetic sides with the MLA. **Nothing here should be built on
point 2 without re-adjudication** — that is the owner's call, not this appendix's, which is why the
`status` line is untouched. Registered in [../payroll/gaps.md](../payroll/gaps.md).

**3. The recordings say it too, repeatedly, and predate this note.** The multiplied reading is not a
single exhibit — four named people describe boom hours as themselves falling into ST/OT/DT buckets:

- Corrina Bustos, 2026-08-04 payroll process, **19:53** — *"we're going to need the long boom and
  that'll be hourly overtime, double time, triple time."*
- Corrina Bustos, 2026-06-11 payroll app demo, **41:40** — *"where it says 7 regular 0.5 OT, that's
  only their long boom hours"*; and **54:51**, listing the ADP columns *"long boom regular hours, long
  boom overtime, long boom double time."*
- Melissa McNutt, 2026-05-28 mobile app payroll, **44:50** — *"they get a different pay rate and that
  pay rate is either on straight time, overtime, or double time."*
- Brian Petros, 2026-06-23, **35:43** — ADP itemises *"the boom pay for standard time and the boom pay
  for overtime."*

A flat unmultiplied adder has no ST/OT/DT split to itemise, so the ADP layout alone is inconsistent
with point 2. **This question should not be put to the client again — it is answered in the record.**
What remains is an internal re-adjudication of this note.

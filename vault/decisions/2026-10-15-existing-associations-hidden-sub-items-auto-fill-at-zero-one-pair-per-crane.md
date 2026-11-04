---
title: "Existing non-employee associations start hidden on both quote types; on Hourly w/ Mob, Sub-item associations fill the Mobilization group automatically (Demobilization twin at 0) and new Mobilization lines start at quantity 0, priced from the price list or billing code; each main crane gets its own crane-named pair, on the Resources tab and on the customer PDF and print, each crane's Mob then Demob together in crane order; on Hourly a row appears exactly when its Hourly Show is ticked (Syed Haris, ticket owner, 2026-10-14/15) — decision"
source: decision/Syed Haris — answers to TCG-218 questions Q1, Q3, Q4, Q5, Q6, Q17, 2026-10-14 and 2026-10-15
decided: 2026-10-15
decided_by: >-
  Syed Haris (syed.haris, CodingCops developer, assignee and owner of Linear TCG-218), in Claude Code
  sessions on 2026-10-14 (Q1, Q3, Q4, Q5, Q17) and 2026-10-15 (Q6, and the Q4 rate answer recorded
  under REQ-22), recorded in `.ai/aidlc/TCG-218/spec.md` §12. The client basis is narrower: Joe
  Schacatano asked for a separate, crane-labelled Mob/Demob per crane on one quote (2026-10-07,
  decisions/2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md,
  `verified`) and for Demobilization lines to start at 0 and mirror Mobilization adds (2026-10-01,
  decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md points 4 and 8,
  `verified`). Hiding existing associations, automatic fill, Mobilization lines at 0 and the group
  order are the ticket owner's alone and were not asked of Joe. Status `reference`: it binds the
  build, and TCG can overrule it. Implemented under TCG-218 units U1 (#789), U3 (#793), U4a (#796),
  U4b (#799), U4d (#804) and U8 (#805). Recorded by tcg-scrum 2026-10-17.
status: reference
conflicts_with: []
amends: []
superseded_in_part_by:
  - decisions/2026-10-16-mob-demob-twin-rule-is-symmetric.md (rule 3 — a twin added into Mobilization from Demobilization starts at 1, not 0; point 4 below otherwise stands)
resolves:
  - aidlc/TCG-218/spec.md#q1--existing-non-employee-associations-shown-or-hidden
  - aidlc/TCG-218/spec.md#q3--do-sub-item-associations-fill-the-groups-automatically
  - aidlc/TCG-218/spec.md#q4--initial-quantityhoursrate-of-mobilization-lines
  - aidlc/TCG-218/spec.md#q5--two-main-cranes-on-one-hourly-w-mob-quote-before-tcg-220
  - aidlc/TCG-218/spec.md#q6--sub-items-its-parent-ticked-on-hourly
  - aidlc/TCG-218/spec.md#q17--order-of-the-two-cranes-groups-non-blocking
related_decisions:
  - 2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md
  - 2026-10-06-employee-type-associations-start-hidden-on-the-quote.md
  - 2026-10-06-nested-association-quote-visibility-stored-per-parent.md
  - 2026-10-06-quotation-type-hourly-or-hourly-with-mob.md
  - 2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md
  - 2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md
  - 2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md
  - 2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md
  - 2026-10-16-mob-demob-twin-rule-is-symmetric.md
  - 2026-10-16-quotation-type-switch-re-lays-out-and-keeps-edits.md
  - 2026-10-16-dispatch-slots-required-optional-none.md
jira: []
tags: [module/quotations, module/assets, kind/decision, mob-demob, pricing]
---

# Existing associations hidden; Sub items auto-fill the pair at 0; one pair per crane

Current Mob/Demob rules, with status per rule:
[../quotations/mob-demob-current-rules.md](../quotations/mob-demob-current-rules.md).

**Numbering warning.** The Q numbers here are the TCG-218 spec §12 numbers. The 2026-10-07 log
([2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md](2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md))
uses an earlier, different numbering: its Q6 is "show/hide is for the quote only", its Q17 is "type
once per quote". Neither is the Q6 or Q17 below.

## Decision

| # | Rule | Source (spec §12), verbatim |
| --- | --- | --- |
| 1 | **Existing non-employee associations start hidden.** When the settings arrive, every existing asset sub-category and custom-type association starts with Hourly Show off and Mob/Demob Show off, on both quote types. (Employee-type rows were already backfilled hidden by [the employee note](2026-10-06-employee-type-associations-start-hidden-on-the-quote.md) point 2.) | Q1, 2026-10-14 — *"hidden"* |
| 2 | **Sub-item associations fill the groups automatically.** On an Hourly w/ Mob quote, picking an item adds its Sub-item associations into its Mobilization group without the salesperson adding them, each mirrored into Demobilization at 0. | Q3, 2026-10-14 — *"automatically"* |
| 3 | **Demobilization lines start at 0.** The ticket owner deferred this to Joe's existing rule rather than deciding it. | Q4, 2026-10-14 — *"demob is 0 if joe has mentioned"*; Joe 2026-10-01 30:21, [10-01 note](2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md) point 4 |
| 4 | **New lines inside Mobilization start at quantity 0**, like Demobilization. Only the quantity starts at 0. The rate is priced as for any other quote line: the customer's price list, else the billing code. | Q4, 2026-10-14 — *"start at 0 we can present and if they want to change we can"*; rate, 2026-10-15 — *"Billing code / price list"* (recorded under spec REQ-22) |
| 5 | **Each main crane gets its own crane-named Mobilization/Demobilization pair**, e.g. "90 Ton Crane – Mobilization", on the Resources tab **and on the customer PDF and print**. This brings TCG-220's per-crane-pair work into TCG-218. The tab rename and activity log stay in TCG-220. | Q5, 2026-10-14 — *"two pair of mob/demob 90 ton crane mob/demob 250 ton crane mob/demob and reflect on print as well"* |
| 6 | **Group order with two cranes:** each crane's Mobilization then its Demobilization, pair by pair, in the order of the cranes, all at the bottom. | Q17, 2026-10-14 — *"90 Ton Mob, 90 Ton Demob, 250 Ton Mob, 250 Ton Demob"* |
| 7 | **On Hourly, a row appears exactly when its Hourly Show is ticked.** The ticket's "sub-items its parent ticked" means the "also brings along" rows whose Hourly Show is ticked under that parent. Hidden rows never appear. | Q6, 2026-10-15 — *"whatever is hidden it's hidden, what's shown is shown"* |

### Already ruled elsewhere — not restated

- **The per-association settings, their defaults for new picks, and the independence of the two Show
  settings:** [2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md](2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md).
- **"Also brings along" rows hidden by default, cleared while the parent is hidden, quoted with the
  parent:** [2026-10-06-nested-association-quote-visibility-stored-per-parent.md](2026-10-06-nested-association-quote-visibility-stored-per-parent.md)
  points 3–4. Rule 7 confirms that reading for Hourly; it adds nothing new to it.
- **Hourly layout wording** ("the associations it shows on Hourly"):
  [2026-10-06-quotation-type-hourly-or-hourly-with-mob.md](2026-10-06-quotation-type-hourly-or-hourly-with-mob.md) point 3.
- **A pair per crane, labelled with the crane; one invoice:** Joe, [two-cranes note](2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md)
  points 1–3 (`verified`). Rule 5 adds only the TCG-218 scope and "on print as well".
- **Which items get a pair:** only an item with at least one Sub item (spec Q32b), and **the item
  itself is the first line of its own Mobilization group at 0**:
  [2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md](2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md).
  Rule 5's "each main crane" is narrowed by that note to a crane with a Sub item.
- **Twin rules** (adding in Mobilization adds to Demobilization at 0; adding in Demobilization adds to
  Mobilization **at 1**; quantities independent): [2026-10-16-mob-demob-twin-rule-is-symmetric.md](2026-10-16-mob-demob-twin-rule-is-symmetric.md)
  rules 1 and 3.
- **Groups stay last after a type switch; removing a crane removes its pair:**
  [2026-10-16-quotation-type-switch-re-lays-out-and-keeps-edits.md](2026-10-16-quotation-type-switch-re-lays-out-and-keeps-edits.md).
- **What a Mob/Demob line prints** (Qty = visits, Rate = one visit's total):
  [2026-10-17-customer-documents-show-no-discount-every-line-net.md](2026-10-17-customer-documents-show-no-discount-every-line-net.md).

## Why

The ticket owner gave a reason only for rule 4: *"we can present and if they want to change we
can"*. That makes 0 a starting value to show Joe at the sprint review, not a client rule. Rule 3
rests on Joe's 2026-10-01 reason, *"I'd rather have it all populated 0 so that they have to manually
put it in because they're all going to be different"* (30:21). For rule 6, the ticket owner says it
was discussed in the meeting. The 2026-10-07 transcript supports keeping each crane's pair separate
(Joe 45:24, *"if we have two separate assets doing a job and they're both mobilizing, we would want
to keep those separate"*), but it states no order. The order is the ticket owner's. No reason was
given for rules 1, 2 or 7.

## What this does not settle

- **Saved quotes under rule 1.** Q1 does not say whether quotes saved before the backfill keep their
  association lines. Spec REQ-03 treats them as unchanged, by analogy with the employee note's point
  2, and flags that for confirmation at sign-off. This note does not confirm it.
- **Newly picked associations.** Rule 1 covers rows that **existed** when the settings arrived. The
  settings note gives new non-employee picks a default of **shown, Main item**. The same ticket owner
  later answered spec §12 **Q21(a)**, *"Hidden, like everything"*: every newly picked association
  starts hidden. Q21(a) departs from the settings note. **No decision note records Q21(a) yet**, and
  this note does not record it.
- **A line picked by hand directly into Mobilization.** Q4's wording, *"new lines inside
  Mobilization"*, and REQ-22's acceptance (*"a line added to or auto-filled into Mobilization has qty
  0"*) both give it 0. The twin note's only exception is a twin created from a Demobilization add,
  which starts at 1. The twin note explains that 1 with *"a pick's default is 1"*; that is its
  recorder's gloss, not a ruling on hand picks into Mobilization.
- **Initial hours** of a Mobilization line: not specified (REQ-22).
- **TCG has not seen rules 1, 2, 4 and 6.** One-line questions, if they need confirming. Owner: Joe
  Schacatano.
  - *"When the new Show settings go live, should every existing associated asset start unticked
    (off the quote until an admin ticks it), or ticked?"*
  - *"Should new lines inside Mobilization start at quantity 0, like Demobilization, or at 1?"*
  - *"With two cranes, should the quote list 90 Ton Mob, 90 Ton Demob, 250 Ton Mob, 250 Ton Demob,
    or both Mobilizations first?"*

## Conflicts — surfaced, not resolved

- **No decision-note conflict.** `conflicts_with: []`.
- **Not an amendment of the settings note's decided points.** That note set the default for a
  *newly picked* association and said that whether existing ones should start shown "was not
  asked". Rule 1 answers that open point. The settings note's *Conflicts* section still describes
  the consequence of its default as *"every existing field-asset association stays on the quote until
  an admin unticks it"*; rule 1 makes that description outdated. A `provenance_note:` on that note
  now points here.
- **Narrowed later, by the same ticket owner:** rule 4 by the twin note's rule 3 (a twin added into
  Mobilization from Demobilization starts at 1), recorded as `superseded_in_part_by:`; rule 5 by spec
  Q32b (only an item with a Sub item gets a pair), recorded in the 2026-10-16 item-in-its-pair note.
- **Interaction with dispatch, not a conflict:** with rule 1, an existing **Optional** association
  is off every new quote until an admin ticks it. Under rule 7 of
  [2026-10-16-dispatch-slots-required-optional-none.md](2026-10-16-dispatch-slots-required-optional-none.md),
  an Optional association left off the quote is not a DAS slot. That rule 7 is a ticket-owner
  assumption pending Lisette Anzaldo. Spec Q22 allows "Optional and hidden on both" as a
  combination that does nothing.

## Effect on the vault

- This note: `status: reference`. **Done.**
- `aidlc/TCG-218/spec.md` §12 Q1, Q3, Q4, Q5, Q6, Q17: a `- **Decision note:**` line was added to
  each, and each "decision note pending" label was replaced. **Done.** Spec REQ-03, REQ-08, REQ-09
  and REQ-22, and the §1 ledger row for REQ-03, still say "pending note". They were left untouched
  on instruction.
- `quotations/INDEX.md`: listed under *Decisions that bind this module*.
  `quotations/mob-demob-current-rules.md`: rows added. **Done.**
- `decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md`:
  `provenance_note:` added, pointing here for existing rows and at spec Q21(a) for new picks. Its
  status (`verified`) and `conflicts_with` are unchanged. **Done.**
- No status flips. No register entry closed.

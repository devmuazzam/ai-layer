---
title: "On an Hourly w/ Mob quote the item itself is the first line of its own Mobilization group (quantity 0, priced like any new group line) with its Demobilization twin at 0, and also stays its own line on top; only an item with a Sub item gets a pair; FCC's per-block comments are not adopted (Syed Haris, 2026-10-16) — decision"
source: decision/Syed Haris — answer to TCG-218 question Q42, 2026-10-16
decided: 2026-10-16
decided_by: >-
  Syed Haris (syed.haris, CodingCops developer, assignee and owner of Linear TCG-218), answering
  TCG-218 Q42 in a Claude Code session on 2026-10-16, raised by himself in the U7 browser review.
  Recorded in `.ai/aidlc/TCG-218/spec.md` §12 Q42 ("Yes, auto-added first"; "Keep Q32b"). Prompted
  by FCC's Hourly w/ Mob template (quotations/fcc-estimate-templates-by-job-type.md §2), which is
  FCC as held, `unverified`, not a TCG statement that the ERP should copy it. Joe Schacatano was not
  asked. This is the ticket owner's ruling, not a TCG client confirmation, so the status is
  `reference`: it binds the build, and TCG can overrule it. Recorded by tcg-scrum 2026-10-16.
status: reference
conflicts_with: []
resolves: aidlc/TCG-218/spec.md#q42--the-crane-itself-inside-its-mobilizationdemobilization-pair-raised-by-the-ticket-owner-in-u7-browser-review-2026-10-16
amends: decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md (point 3 only)
related_decisions:
  - 2026-10-06-quotation-type-hourly-or-hourly-with-mob.md
  - 2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md
  - 2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md
  - 2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md
jira: []
tags: [module/quotations, kind/decision, mob-demob, pricing]
---

# The item itself leads its own Mob/Demob pair (Hourly w/ Mob)

Current Mob/Demob rules, with status per rule:
[../quotations/mob-demob-current-rules.md](../quotations/mob-demob-current-rules.md).

## Decision

Syed Haris (ticket owner), TCG-218 Q42, 2026-10-16:

1. **The item itself is the first line of its own Mobilization group.** Picking an item on an
   **Hourly w/ Mob** quote also adds **the same item** as the first line of its Mobilization group,
   ahead of its Sub items. It is priced like any new group line (customer price list, else billing
   code) at **quantity 0**, the rule TCG-218 REQ-22 gives every new Mobilization line.
2. **Its Demobilization twin is added too, at 0**, paired as every Mob/Demob line is (TCG-218
   §11b D5b).
3. **The item also stays as its own line on top**, outside the groups, as before.
4. **Pair scope is unchanged** (TCG-218 Q32b, "Keep Q32b"): only an item with **at least one Sub
   item** gets a Mobilization/Demobilization pair. An item with no Sub items still has none, so it
   does not get a group just to hold itself.
5. **FCC's per-block comments are not adopted.** FCC's template labels the crane's two group lines
   *"Travel in and Build up"* and *"4 Hour Minimum Portal to Portal"*; ours start with no comment.

This **amends point 3** of
[2026-10-06-quotation-type-hourly-or-hourly-with-mob.md](2026-10-06-quotation-type-hourly-or-hourly-with-mob.md).
That point read: *"the item alone, then its Main items as their own lines, then the Mobilization and
Demobilization groups (its Sub items) at the bottom."* It now reads, in effect: the item, then its
Main items as their own lines, then the Mobilization and Demobilization groups (**the item itself,
then its Sub items**) at the bottom. Points 1, 2, 4 and 5 of that note are untouched. Spec side:
TCG-218 REQ-07 is amended the same way ("its Sub items" → "the item itself, then its Sub items");
built as unit U4d, before U8.

## Why

The ticket owner gave the outcome, not a reason. The prompt was FCC's own *Hourly w/ Mob* estimate
template for the 100 Ton crane
([../quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md)
§2, *Estimate — `Hourly w/ Mob`*, `unverified`): line 1 of the Mobilization block and line 10 of the
De-Mobilization block are both *100 Ton Crane*, at 0.00 Hours, ticked Sub-Item, and the crane's
own hours appear again as an unticked customer-visible line (19). The crane's travel and build-up
time is billed inside the bundle that way. The decision adopts FCC's placement, and drops its
comments.

## What this does not settle

- **Whether the item's line inside the group is shown to the customer.** Q42 does not say. The
  client rule that the customer receives *"Mobilization, Demobilization and the main items only"*
  ([2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md](2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md)
  point 3, `verified`) covers lines inside a group as written; nothing here changes it, and nothing
  here confirms how the build applies it to this line.
- **Whether the per-visit multiplier applies to it** is not separately stated. The visits rule
  ([2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md](2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md))
  multiplies every line inside the group; this note adds a line to the group and does not carve it out.
- **TCG never saw this.** Whether TCG wants the crane's own time inside the mob/demob bundle on
  every Hourly w/ Mob quote was not asked. One-line question, if it needs confirming: *"On an
  Hourly w/ Mob quote, should the crane itself be the first line of its Mobilization and
  Demobilization groups (starting at 0), as in FCC's template?"* Owner: Joe Schacatano.

## Conflicts — surfaced, not resolved

- **No decision note conflicts.**
  [2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md](2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md)
  point 2 defines a *Sub item* as "a line inside the Mobilization and Demobilization groups". It
  says what a Sub item is, not that the groups hold only Sub items, so it is not contradicted; the
  item's own group line is not an association and is not governed by those settings.

## Effect on the vault

- **Done:** [2026-10-06-quotation-type-hourly-or-hourly-with-mob.md](2026-10-06-quotation-type-hourly-or-hourly-with-mob.md)
  — a dated *Amendment — 2026-10-16* section appended, a pointer beside point 3, `provenance_note:`
  and `related_decisions:` updated. Its status stays `reference` (points 1, 2, 4, 5 and the rest of
  point 3 stand); it is amended, not superseded. Its point 3 text is kept as decided.
- **Done:** [../quotations/mob-demob-current-rules.md](../quotations/mob-demob-current-rules.md) —
  one row added under *On the quote*; [../quotations/INDEX.md](../quotations/INDEX.md) — listed
  under *Decisions that bind this module*.
- No vault-file status flips. No register entry closed. The source conflict stub
  [../quotations/mob-demob-INDEX.md](../quotations/mob-demob-INDEX.md) is not adjudicated.

---
title: "Each sub-category association carries its own quote settings: Hourly Show, and Mob/Demob Show with Main item / Sub item, configurable from the front end (approved by Joe Schacatano, 2026-10-07); the two Show settings are independent (ticket owner) — decision"
source: decision/Syed Haris (TCG-218 design, 2026-10-06) — approved by Joe Schacatano on the recorded 2026-10-07 sprint review
decided: 2026-10-06
decided_by: >-
  Designed by Syed Haris (syed.haris, CodingCops developer, assignee and owner of Linear TCG-218) in
  a Claude Code session on 2026-10-06/07, relayed to tcg-scrum on 2026-10-07. Shown to Joe Schacatano
  (TCG VP of Sales, the quotation owner) on the recorded 2026-10-07 sprint review
  (meetings/2026-10-07-sprint-review-offline-tickets-holdover-and-mob-demob-sign-off.md §7,
  33:36–37:45 and 48:42–50:30). Joe: "Yeah, it looks good" (36:23); "So we can customize it to
  however we want it to be basically… I'd rather have it be that way" (49:55); "I like how that's
  built out" (50:10). Points 1 and 2 (the per-association settings, configurable) are therefore
  client-approved. Point 3 (the two Show settings are independent) and the later ticket-owner
  answers are Syed Haris's alone; Joe did not discuss them. Written 2026-10-07; ported to overlay
  main 2026-10-09. Built on branch feat/association-document-visibility, under review.
status: verified
provenance_note: >-
  EXISTING ROWS: the same ticket owner answered TCG-218 Q1 on 2026-10-14 ("hidden") — existing
  non-employee associations start hidden on both quote types when the settings arrive, so the
  Conflicts section's "every existing field-asset association stays on the quote until an admin
  unticks it" no longer describes the build. See
  decisions/2026-10-15-existing-associations-hidden-sub-items-auto-fill-at-zero-one-pair-per-crane.md
  (status: reference). NEW PICKS: TCG-218 spec §12 Q21(a), 2026-10-15 ("Hidden, like everything"),
  departs from this note's "a direct non-employee association starts shown"; no decision note
  records it yet. Points 1–3 unchanged; status and conflicts_with unchanged. Added 2026-10-17 by
  tcg-scrum (bookkeeping only).
conflicts_with:
  - decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md
resolves: []
related_decisions:
  - 2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md
  - 2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md
  - 2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md
  - 2026-10-06-employee-type-associations-start-hidden-on-the-quote.md
  - 2026-10-06-nested-association-quote-visibility-stored-per-parent.md
  - 2026-10-06-quotation-type-hourly-or-hourly-with-mob.md
  - 2026-10-07-field-assets-configuration-tab-rename-and-activity-log.md
jira: []
tags: [module/quotations, module/assets, kind/decision, mob-demob, pricing]
---

# Per-association quote settings on the sub-category

Current Mob/Demob rules, with status per rule:
[../quotations/mob-demob-current-rules.md](../quotations/mob-demob-current-rules.md).

## Decision

*Asset Management → Sub-Categories → Associated Field Assets* (to be renamed **Field Assets
Configuration**, see
[2026-10-07-field-assets-configuration-tab-rename-and-activity-log.md](2026-10-07-field-assets-configuration-tab-rename-and-activity-log.md)):
every association keeps its Field Setting, which is unchanged, and gains:

1. **Hourly · Quote/Invoice: Show.** Whether the association appears on an **Hourly** quote as a
   line under its item. *(Client-approved, Joe 2026-10-07.)*
2. **Mob/Demob · Quote/Invoice: Show.** Whether it appears on an **Hourly w/ Mob** quote at all.
   While it is shown, it is either:
   - **Main item**: its own visible line beside the item; or
   - **Sub item**: a line inside the Mobilization and Demobilization groups, hidden from the customer.

   *(Client-approved, Joe 2026-10-07.)* The settings are changed from the front end by anyone with
   the permission; nothing about which association may show is fixed in code.
3. **The two Show settings are independent.** An association hidden on Hourly is **not**
   automatically rolled into Mob/Demob. It follows its own Mob/Demob setting. *(Ticket owner —
   Syed Haris; TCG-218 Q18, 2026-10-07. Joe did not discuss it.)*

Defaults: a direct non-employee association starts **shown** on both quote types, as a Main item.
Employee types and an association's own associations start **hidden** — see
[2026-10-06-employee-type-associations-start-hidden-on-the-quote.md](2026-10-06-employee-type-associations-start-hidden-on-the-quote.md)
and [2026-10-06-nested-association-quote-visibility-stored-per-parent.md](2026-10-06-nested-association-quote-visibility-stored-per-parent.md).
The defaults were shown to Joe on 2026-10-07 (§7: *"Sub-items and employees start unticked"*).

## Why

This is how the product delivers two client statements:

- Joe's 2026-10-01 instruction that the quote carries what is billed
  ([2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md](2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md));
- his description of mob/demob, where some lines are main items and the rest roll up
  ([2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md](2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md)).

The "Sub item" term follows FCC's *Sub-Item* tick (`quotations/fcc-estimate-templates-by-job-type.md`)
and Joe's 2026-10-01 11:29 *"something that's required to complement the main item"*. On
2026-10-07 Joe preferred configurable settings over a restricted rule: *"if we took the other route
where we completely restricted it… We're gonna run into a scenario"* (50:20–50:25).

## Ticket-owner answers that refine this note (2026-10-07, Syed Haris — `reference` weight)

From the TCG-218 question log
([2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md](2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md)):

- **Q18 — yes, set separately.** Point 3.
- **Q16 — associations on a quote follow the sub-category page's order.**
- **Q6 and the later U8 answer — show/hide is for the quote only.** *"for DAS, everything which is
  in the association will be shown, the show/hide is only for quote."* Every billable association of
  a quoted item, Always Included and Optional, at every depth, becomes a job resource / DAS slot on
  conversion, whatever its Show settings. An association whose item has no ACTIVE billing code is
  still not materialised. Only Always Included associations raise the DAS missing-components
  warning.

## Conflicts and interactions — surfaced, not resolved

- **[2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md](2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md)**
  (`reference`, Syed Haris). Conversion there drops **Optional** associations the quotation did not
  carry. The ticket owner's Q6/U8 answer above dispatches every billable association whatever the
  quote carries. Both are developer rulings; neither is a client's. Joe's 2026-10-01 13:37 puts these
  resources *"on the job end when it's dispatched"*, and his 2026-09-16 rule says resources are
  dispatch-side, which leans toward the U8 answer but does not decide the Optional case. Owner:
  Lisette Anzaldo (DAS) / Joe Schacatano. One-line question: *"Should every Optional associated asset
  become a DAS slot on the job, or only the ones the salesperson kept on the quote?"*
- **[2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md)**
  (`verified`). Non-employee associations **default to shown on both quote types**, so every
  existing field-asset association stays on the quote until an admin unticks it. Joe saw these
  defaults on 2026-10-07 and approved the configurable approach; whether every existing association
  should start shown was not asked.
- **Open register questions this answers by construction:** [../quotations/gaps.md](../quotations/gaps.md)
  → *Estimate defaults per resource type / job type / yard* (d), *"Does a line need to be able to be
  a child and visible?"* A Sub item is a hidden child and a Main item is visible. Also → *Quote line
  items vs dispatch resources* (a): the requirement is held on the sub-category's associations. Both
  entries stay open for TCG.

## Effect on the vault

- No vault-file status flips. No vault body is a winner or a loser.

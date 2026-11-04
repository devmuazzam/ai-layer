---
title: "Mobilization/Demobilization twins mirror both ways: adding, renaming or deleting a line in either group does the same to its twin; a twin added into Demobilization starts at 0, one added into Mobilization at 1, and the two quantities stay independent; a hand-added twin takes the same position; the Price Adjustment rate copies both ways; an automatic line with no billing code is still created and warns, and resolving the code on either twin clears both; linked crane pairs only (Syed Haris, ticket owner, 2026-10-15/16) — decision"
source: decision/Syed Haris — answers to TCG-218 questions Q8, Q38, Q39, Q50, Q53, 2026-10-15 and 2026-10-16
decided: 2026-10-16
decided_by: >-
  Syed Haris (syed.haris, CodingCops developer, assignee and owner of Linear TCG-218), in Claude Code
  sessions on 2026-10-15 (Q8) and 2026-10-16 (Q38, Q39, Q50, Q53), recorded in
  `.ai/aidlc/TCG-218/spec.md` §12. Q50 he raised himself while testing U9. The client basis is
  narrower: Joe Schacatano agreed on the recorded 2026-10-01 call that adding a line to Mobilization
  adds it to Demobilization, and that Demobilization lines start at 0
  (decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md points 4 and 8,
  `verified`). Everything else here, including the Demobilization → Mobilization direction, is the
  ticket owner's ruling and was not asked of Joe. Status `reference`: it binds the build, and TCG
  can overrule it. Implemented under TCG-218 units U6 (#802) and Q50 (#807). Recorded by tcg-scrum
  2026-10-17.
status: reference
conflicts_with: []
resolves:
  - aidlc/TCG-218/spec.md#q50--twin-rule-both-ways-on-add-auto-created-lines-with-a-missing-billing-code-raised-by-the-ticket-owner-while-testing-u9-2026-10-16
  - aidlc/TCG-218/spec.md#q38--u6-build-twins-on-unlinked-groups-price-adjustment-outside-a-group-server-side-billing-code-rule-as-built-details-raised-by-tcg-executor-on-u6-2026-10-16
  - aidlc/TCG-218/spec.md#q53--q50-as-built-price-adjustment-added-in-demobilization-placement-of-a-mobilization-twin-raised-by-tcg-executor-on-q50-2026-10-16-non-blocking
  - aidlc/TCG-218/spec.md#q8--twin-edge-rules-renamedelete
related_decisions:
  - 2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md
  - 2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md
  - 2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md
  - 2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md
  - 2026-10-16-dispatch-slots-required-optional-none.md
jira: []
tags: [module/quotations, kind/decision, mob-demob, pricing]
---

# The Mob/Demob twin rule is symmetric

A **twin** is the line of the same name in the partner group of a crane's Mobilization/Demobilization
pair. Current Mob/Demob rules, with status per rule:
[../quotations/mob-demob-current-rules.md](../quotations/mob-demob-current-rules.md).

## Decision

| # | Rule | Source (spec §12) |
| --- | --- | --- |
| 1 | **Adding a line to either group adds its twin to the other.** Adding in Mobilization adds the twin to Demobilization (Joe's rule), and adding in Demobilization now adds the twin to Mobilization. | Q50(1) — *"deleting deletes both and adding adds on both as well"*. Supersedes Q38(d)'s "add mirrors Mob→Demob only" |
| 2 | **Renaming or deleting a line does the same to its twin, in both directions. Only the basic rule applies:** no special handling for duplicate names, and no quantity rule beyond it. | Q8 — *"Only the basic rule"* (2026-10-15); Q38(d) "rename/delete mirror both ways" |
| 3 | **Starting quantity:** a twin added into Demobilization starts at **0**. A twin added into Mobilization starts at **1**. **The two quantities are independent** and are never mirrored. | Q50 — *"at 1, but the quantity is not identical, mob can have 8 hours and demob can have 5"*; 0 into Demobilization is Joe's (10-01 point 4) |
| 4 | **Position:** a twin added by hand goes to the **same position** in the other group as its source line holds in its own group, clamped to the end. This applies in both directions. The crane's own automatic line stays first in its group. | Q53(2) — *"insert at the matching position in mob, and vice versa"*. Supersedes "appended last" (Q38(d)) |
| 5 | **Price Adjustment rate:** a Price Adjustment twin takes its source line's rate. A rate typed on either Price Adjustment twin fills the other while the other is empty or still equal to the previous source rate. Once a twin is edited by hand, it is left alone. | Q39(1) — *"Twin copies the rate"*; Q53(1) — *"Both ways"* |
| 6 | **Automatic lines with no billing code:** they are still created and show the existing *"Billing Code missing."* warning. Resolving the billing code on **either** twin clears the other twin's warning too. | Q50(2) — *"create automatic lines but show that billing code is missing … if billing code is entered either in mob or demob it should automatically clear the other row's warning"* |
| 7 | **Scope: linked pairs only.** The rule mirrors only within a crane's linked pair. Plain *Mobilization* / *Demobilization* groups on older quotes, which have no crane, behave as they did before. | Q38(a) — *"No, linked pairs only"* |
| 8 | **Accepted as built** (Q38(d), *"OK all"*): no twin is added when the partner group already has a line of that name; a rename whose twin is missing does nothing; clearing a line's item leaves its twin; a renamed twin is re-priced as a new pick and keeps its quantity. | Q38(d) |

Related rulings in the same answers, recorded here because they sit on twin lines:

- **The Price Adjustment exemption applies only inside a Mob/Demob group.** Elsewhere, a Price
  Adjustment line keeps the ordinary "Billing Code missing." and whole-dollar rules. Source: Q38(b),
  *"Inside groups only"*. The rate must still be greater than 0 (Q38(d)).
- **A line must have a billing code to be on a quote,** so conversion keeps skipping non-billable
  associations. Source: Q50, *"an always included machine will not be quoted if it doesn't have a
  billing code so it's already reflected on the job — to be on quote it needs to have a billing
  code"*. See [2026-10-16-dispatch-slots-required-optional-none.md](2026-10-16-dispatch-slots-required-optional-none.md).

## Why

Joe's reason for the original mirroring was *"so that we don't miss it on that end… we want the
numbers typically to match up"* (10-01 point 8). The ticket owner applied the same reasoning to the
other direction while testing U9: a line added only in Demobilization had no partner, and rename and
delete were already mirrored both ways. **A twin added into Mobilization starts at 1, not 0,**
because a pick's default is 1. The ticket owner kept the quantities independent because the two
groups are different work (*"mob can have 8 hours and demob can have 5"*). Copying the Price
Adjustment rate exists because a Price Adjustment line has no billing code to price its twin from,
and the save requires a rate above 0 (Q39(1)).

## Developer decisions, not product rules

The following are developer decisions, not requirements, and are not restated here:

- how a twin is matched (by name within the linked pair, D5b);
- how a Price Adjustment line is recognised (Q38(d));
- the API's quantity message;
- the helper and prop names.

They are recorded in `.ai/aidlc/TCG-218/spec.md` §11b D5b and §12 Q38(d), Q39 *As built* and Q53.

## Left open

- **Server-side billing-code and whole-dollar checks.** Today the API checks neither. This was
  deferred by the ticket owner (Q38(c), *"No, follow-up"*) and is logged at
  [../quotations/gaps.md → *Should the API enforce billing codes and whole-dollar rates on quote lines?*](../quotations/gaps.md#should-the-api-enforce-billing-codes-and-whole-dollar-rates-on-quote-lines).
- **Mobile** keeps its own behaviour until Linear TCG-219 (Q9, Q39(4)).
- **TCG has not seen the Demobilization → Mobilization direction.** If it needs confirming, the
  one-line question is: *"When a line is added to Demobilization, should it also appear in
  Mobilization (starting at 1)?"* Owner: Joe Schacatano.

## Conflicts

None. This note extends point 8 of
[2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md](2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md)
(Mob → Demob, client) to the other direction. It also finalises that note's *Update 2026-10-08*
reading of rename and delete: the earlier build reading (*"a twin is left alone while another line in
the source group still has its name"*) gave way to Q8's "basic rule only". The ticket-owner log's
Q14 row
([2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md](2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md))
says *"Adding was already mirrored"*. That is still true, and adding is now mirrored in both
directions.

## Effect on the vault

- This note: `status: reference`. **Done.**
- `aidlc/TCG-218/spec.md` §12 Q8, Q38, Q39, Q50, Q53: a `- **Decision note:**` line was added to each,
  and Q8's "decision note pending" label was replaced. **Done.**
- `quotations/INDEX.md`: listed. `quotations/mob-demob-current-rules.md`: a row added under *On the
  quote*. **Done.**
- `decisions/2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md`: its
  `provenance_note:` now points here for its Q14 row. **Done.**
- No status flips. No register entry closed.

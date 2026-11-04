---
title: "Switching a quote's Quotation Type re-lays out each item's automatic lines for the new type and keeps their edits; it asks first whenever the quote has lines; hand-added lines stay unless the new layout removes their place; unlinked old groups are left alone; groups stay last; removing a crane removes its pair; the web drops the \"In total\" checkbox (Syed Haris, ticket owner, 2026-10-15/16) — decision"
source: decision/Syed Haris — answers to TCG-218 questions Q30, Q31, Q34, Q35, Q36, Q37 and the 2026-10-15 U5 confirmation answer
decided: 2026-10-16
decided_by: >-
  Syed Haris (syed.haris, CodingCops developer, assignee and owner of Linear TCG-218), in Claude Code
  sessions on 2026-10-15 (the confirmation trigger, recorded in `.ai/aidlc/TCG-218/units.md`,
  "Resolved 2026-10-15") and 2026-10-16 (Q30, Q31, Q34–Q37, recorded in `.ai/aidlc/TCG-218/spec.md`
  §12). He raised Q30 himself in the U3 browser review. The client basis is thin. Joe Schacatano saw a
  type switch "with a confirmation popup" demoed at the recorded 2026-10-07 sprint review and raised
  no objection. He was not asked what a switch keeps or drops. Status `reference`: this binds the
  build, and TCG can overrule it. The mobile builder (Linear TCG-219) and TCG-220 must match it.
  Implemented under TCG-218 units U5a (#800), U5b (#801) and U6 (#802). Recorded by tcg-scrum
  2026-10-17.
status: reference
conflicts_with: []
resolves:
  - aidlc/TCG-218/spec.md#q34--u5-what-a-type-switch-rebuilds-old-groups-groups-last-copy-raised-before-u5-after-the-u1u4-end-to-end-test-2026-10-16
  - aidlc/TCG-218/spec.md#q35--u5-build-split-at-the-size-cap-header-row-choices-what-the-switch-rebuild-needs-answered-raised-by-tcg-executor-on-u5-2026-10-16
  - aidlc/TCG-218/spec.md#q30--the-in-total-checkbox-on-mobdemob-group-lines-raised-by-the-ticket-owner-in-u3-browser-review-2026-10-16
  - aidlc/TCG-218/spec.md#q31--removing-a-crane-from-an-hourly-w-mob-quote-raised-before-u4-2026-10-16
amends: decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md (point 4 only)
related_decisions:
  - 2026-10-06-quotation-type-hourly-or-hourly-with-mob.md
  - 2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md
  - 2026-10-16-mob-demob-twin-rule-is-symmetric.md
  - 2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md
  - 2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md
  - 2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md
jira: []
tags: [module/quotations, kind/decision, mob-demob]
---

# A Quotation Type switch re-lays out the quote and keeps its edits

The *automatic lines* of an item are the lines its configuration brings onto the quote:

- on Hourly, the associations shown on Hourly;
- on Hourly w/ Mob, its Main items under it and its Sub items in its linked Mobilization/Demobilization
  pair.

The layouts themselves are in
[2026-10-06-quotation-type-hourly-or-hourly-with-mob.md](2026-10-06-quotation-type-hourly-or-hourly-with-mob.md),
with point 3 amended by
[2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md](2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md).

Once a quote has a configuration snapshot, the switch reads the snapshot
([2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md](2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md)
rule 4).

## Decision

| # | Rule | Source |
| --- | --- | --- |
| 1 | **Re-lay out, keep edits.** Each item's automatic lines are rearranged for the new type. **Hourly → Hourly w/ Mob:** Sub items move into a new linked pair, and Main items stay under the item. **Hourly w/ Mob → Hourly:** the item's linked pair is removed and its Hourly lines are added. A line that exists in both layouts keeps its quantity, rate, unit, discount, price hike, surcharge, comments and additional information. New lines are priced as a pick: from the price list, otherwise from the billing code. New Demobilization twins start at 0. | Q34(a) *"Re-lay out, keep edits"*; Q35(v) *"OK all"* |
| 2 | **When it asks:** a switch asks for confirmation **whenever the quote already has lines**, meaning at least one top-level row, even a blank one. A quote with no lines switches without asking. | units.md, *Resolved 2026-10-15* (*"agree"*); Q34(a); Q35(vi). Amends point 4 of the 10-06 note (*"when the switch will change rows"*) |
| 3 | **Copy:** title *"Change Quotation Type?"*. Body *"Switching to &lt;type&gt; rebuilds this quote's lines for the new layout. Lines you added by hand are kept, except lines inside a Mobilization or Demobilization group the new layout removes."* Buttons *"Cancel"* / *"Change type"*. "Change type" keeps the shared dialog's red style and cannot be pressed while the catalogs load. | Q34(d), body superseded by Q35; Q36(2) *"Keep red"*; Q35(vii) |
| 4 | **Hand-added lines stay where they are, unless the new layout removes their place.** A hand-added line inside a linked pair on Hourly w/ Mob → Hourly is dropped with the pair. So is a hand-added line under an automatic line that moves into a group. | Q34(a); Q35(i) *"Dropped"* |
| 5 | **Automatic or hand-added is decided by name.** A line is automatic when its name is one of its parent's catalog associations. Inside a linked pair, it is also automatic when its name is one of the item's Sub items. A hand-added line with an association's name is therefore treated as automatic. | Q35(ii) *"By name"* |
| 6 | **Matching a line across layouts:** by item name within the item's lines. The same parent is searched first, then anywhere under the item (Q37 F1). A Mobilization line is matched before its Demobilization twin, and on Hourly w/ Mob → Hourly the twin is dropped. | Q35(v); Q37(F1) *"Fix: match by parent first"* |
| 7 | **A line leaving a group keeps its quantity, unless that quantity is 0, in which case it gets 1.** Its other fields carry over. | Q36(1) *"0 becomes 1"* |
| 8 | **Deleted lines stay deleted.** A line deleted in the old layout stays deleted after the switch, at every level of that item, and a re-pick refills it. Automatic lines that belong to neither layout are dropped, edits included. An example is a line shown on Hourly whose Mob/Demob Show is unticked. | Q35(iii)+(iv) *"OK both"*; Q37(F2) *"Accept as built"*; Q33(b) |
| 9 | **Every item is rebuilt**, not only cranes: every top-level, non-group line with an item. This is because any item with a Sub item gets a pair. | Q35(ix); Q32(b) |
| 10 | **Old unlinked groups are left untouched.** Plain Mobilization/Demobilization groups with no crane, from before TCG-218, are ignored by the rebuild. | Q34(b) *"Leave untouched"* |
| 11 | **Groups stay last on Hourly w/ Mob.** New lines are inserted above the groups. A line cannot be dragged among or below the groups, and a group cannot be dragged above the lines. Pairs return to crane order after any drag. A quote that is already out of order is not re-sorted when it opens. | Q34(c) *"Enforce in U5"*; Q35(f) |
| 12 | **Removing a crane removes its pair** and the lines in it. Re-picking the crane rebuilds the pair. | Q31 *"Removed with it"* |
| 13 | **The "In total" checkbox is gone from the web.** Every group line counts. A quote saved with an excluded line keeps its total. On the detail view such a legacy line shows an *"Excluded"* badge. Mobile keeps its toggle until Linear TCG-219. Removing the checkbox completely (schema, API, PDF, approvals, mobile) is not part of TCG-218. | Q30 *"i don't think i need in total"*; Q39(2) *"Keep 'Excluded' badge for legacy"* |
| 14 | **Group header rows** (Q35 U5a (a)–(h), *"OK all as built"*): a Mob/Demob group shows as a header row carrying its visits and its total. It is collapsed each time the Resources tab is opened, and opens automatically when a line inside it has an error on save. Crane Time groups are not header rows. | Q35(a)–(h) |

## Why

The ticket owner did not give his reasons in the answers. The reasons below come from the question
text he accepted:

- The 10-06 note allowed a switch to discard manual edits once the user confirmed. After the U1–U4
  end-to-end test, he chose to keep them (Q34(a)), so a salesperson does not lose priced lines by
  changing type.
- Rule 4's exception exists because a line that was hand-added inside a pair the new layout removes
  has nowhere to go (Q35(i)).
- The dialog body was rewritten to say so, so the copy does not promise more than the switch does.
- On "In total" (Q30): every line is either a Sub item, which rolls up, or a Main item, and price
  changes go through the Price Adjustment line. The checkbox had no vault or spec source.

## Developer decisions, not product rules

The following are developer decisions, not requirements:

- the split into U5a and U5b;
- test IDs: the dialog reuses the shared `confirm-modal-confirm` / `confirm-modal-cancel` IDs and is
  found by its title (Q35(viii));
- header-row test IDs;
- module and helper names;
- the 200-line function limit.

They are recorded in `.ai/aidlc/TCG-218/spec.md` §12 Q35 and Q36(3) and are not restated here.

## Left open

- **TCG has not been asked what a switch keeps.** If it needs confirming, the one-line question is:
  *"When a salesperson switches a quote between Hourly and Hourly w/ Mob, should prices and comments
  already typed on lines in both layouts be kept?"* Owner: Joe Schacatano.
- **Mobile** (Linear TCG-219) has none of this yet.

## Conflicts

- **Amends point 4 of
  [2026-10-06-quotation-type-hourly-or-hourly-with-mob.md](2026-10-06-quotation-type-hourly-or-hourly-with-mob.md)**:
  - the confirmation is now asked whenever the quote has lines, where point 4 said "when the switch
    will change rows";
  - edits are kept where a line exists in both layouts, where point 4 said they "may be discarded".

  The same ticket owner made both rulings, so this is an amendment, not a conflict. The 10-06 note's
  status stays `reference`. The same applies to the Q15 row of
  [2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md](2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md).

## Effect on the vault

- This note: `status: reference`. **Done.**
- `decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md`:
  - `superseded_in_part_by:` names this note (point 4) and the Q42 note (point 3);
  - `provenance_note:` extended;
  - status unchanged (`reference`).

  **Done.**
- `decisions/2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md`: `provenance_note:`
  points here for its Q15 row. **Done.**
- `aidlc/TCG-218/spec.md` §12 Q30, Q31 and Q34–Q37: a `- **Decision note:**` line was added to each.
  **Done.**
- `quotations/INDEX.md`: listed. `quotations/mob-demob-current-rules.md`: a row added. **Done.**
- No register entry closed.

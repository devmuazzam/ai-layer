---
title: "A Mobilization/Demobilization group's visits are a whole number of at least 1 (lines inside keep two-decimal quantities); saved Mob/Demob groups whose stored quantity was not 1 were reset to 1 by a one-way data migration that kept no copy of the old values; a group counts as Mob/Demob by its stored name, linked or not, on any quote type (Syed Haris, ticket owner, 2026-10-14 to 2026-10-16) — decision"
source: decision/Syed Haris — answers to TCG-218 questions Q2, Q20, Q40, Q41, 2026-10-14 to 2026-10-16
decided: 2026-10-16
decided_by: >-
  Syed Haris (syed.haris, CodingCops developer, assignee and owner of Linear TCG-218), in Claude Code
  sessions on 2026-10-14 (Q2, "reset to 1"), 2026-10-15 (Q20, "agree but hours you can add 2.5")
  and 2026-10-16 (Q40, "Plain reset"; Q41), recorded in `.ai/aidlc/TCG-218/spec.md` §12. Joe
  Schacatano confirmed that the Mobilization quantity is the number of visits, default 1
  (decisions/2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md rule 1,
  `verified`). He was not asked about the bounds or the reset. Q2 named him to confirm "if totals
  of sent quotes would move", and that was not done. Status `reference`: it binds the build, and
  TCG can overrule it. Implemented under TCG-218 unit U7 (#803), with migration
  `reset_group_visits_to_one`. Recorded by tcg-scrum 2026-10-17.
status: reference
conflicts_with: []
resolves:
  - aidlc/TCG-218/spec.md#q20--allowed-values-for-a-groups-visits-non-blocking-raised-by-the-decomposer-2026-10-15
  - aidlc/TCG-218/spec.md#q40--u7-before-build-reset-migration-group-kind-detection-visits-enforcement-split-raised-2026-10-16
  - aidlc/TCG-218/spec.md#q2--existing-saved-quotes-whose-mobilization-group-has-a-stored-quantity-other-than-1
related_decisions:
  - 2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md
  - 2026-10-06-quotation-type-hourly-or-hourly-with-mob.md
  - 2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md
jira: []
tags: [module/quotations, kind/decision, mob-demob, pricing]
---

# Visits are whole numbers ≥ 1; saved groups were reset to 1

The rule that a Mob/Demob group's quantity is its number of visits, and multiplies its lines, is
[2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md](2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md).
This note fixes the values the visits may take and what happened to quotes saved before the rule.

## Decision

| # | Rule | Source (spec §12) |
| --- | --- | --- |
| 1 | **Visits are a whole number, at least 1.** The lines inside a group keep two-decimal quantities, for example 2.5 hours. | Q20 — *"agree but hours you can add 2.5"* |
| 2 | **Enforced on the web and by the API.** The visits box takes whole numbers of at least 1, and the API refuses any other value. Web message: *"Visits must be a whole number of at least 1"*. Typing a "." stops the input, so "2.5" stays "2". | Q40(3) *"Web + API 400"*; Q41(1) *"Stop at the dot"*, Q41(2) |
| 3 | **Saved quotes were reset to 1 visit.** A saved Mobilization/Demobilization group whose stored quantity was not 1 was set to 1, so that no existing total would start multiplying unexpectedly. | Q2 — *"reset to 1"* |
| 4 | **The reset was plain and one-way.** Only Mob/Demob group rows with a quantity other than 1 were updated. Crane Time was not touched. **The old values were not kept**: there is no snapshot and no audit copy. | Q40(1) *"Plain reset"* |
| 5 | **Which groups count as Mob/Demob:** a group row whose **stored name** is Mobilization or Demobilization, whether or not it is linked to a crane, on **any** quote type. | Q40(2) *"Stored name, any quote type"* |
| 6 | **A line renamed into a group is reset to 1.** On the web, when a row's item changes to Mobilization/Demobilization, its quantity becomes 1. Without this, a line quantity of 8 or 2.5 would turn into visits. Mobile gets the same under Linear TCG-219. | Q41(3) *"Web now, mobile in TCG-219"* |

## Why

The quantity of a group row was stored but ignored by every rollup before TCG-218. Once visits
multiply, any stored value other than 1 would have changed the money on a saved quote without anyone
editing it (Q2). Resetting to 1 keeps every saved total as it was. Whole numbers of at least 1
follow from what the number means: a count of visits. The decimals the ticket owner wanted to keep
belong to the hours on the lines (Q20).

## Irreversibility

Rule 4 is the only data migration on TCG-218 that cannot be undone. The quantities it overwrote are
recorded nowhere except as a count:

- the PR (#803) carried a pre-deploy count query;
- on the local development database it found **0 rows** to reset (Q40(1)).

What it reset on any other environment is not recorded in the vault. If TCG later says that some
saved group quantities were meant as visits, they cannot be restored from the database.

## Developer decisions, not product rules

The following are developer decisions, not requirements:

- the migration's name and shape;
- that the group-kind rule is kept in three copies (shared, API, web — Q41 follow-ups);
- the API message text;
- the helper names (`getGroupVisits`, `findGroupVisitsViolation`);
- the U7 split line (Q40(4)).

They are recorded in `.ai/aidlc/TCG-218/spec.md` §12 Q40 and Q41 and `units.md` U7, and are not
restated here.

## Left open

- **TCG did not confirm the reset.** Q2 asked to *"confirm with Joe if totals of sent quotes would
  move"*. The reset was chosen so that they do not move, and Joe was not asked. If it needs
  confirming, the one-line question is: *"Is a Mobilization's number of visits always a whole
  number, at least 1?"* Owner: Joe Schacatano.
- **An unlinked group on an Hourly quote** is still multiplied by a quantity the user cannot edit
  there (Q41 follow-ups). New groups start at 1.

## Conflicts

None. This note adds bounds to rule 1 of the visits note ("defaults to 1 and can be edited"). It does
not touch rule 5 (only Mob/Demob multiply), and rule 5 above applies it by stored name.

## Effect on the vault

- This note: `status: reference`. **Done.**
- `aidlc/TCG-218/spec.md` §12 Q2, Q20, Q40 and Q41: a `- **Decision note:**` line was added to each.
  In Q2, the "decision note pending" label was also replaced. **Done.**
- `quotations/INDEX.md`: listed. `quotations/mob-demob-current-rules.md`: a row added. **Done.**
- No status flips. No register entry closed.

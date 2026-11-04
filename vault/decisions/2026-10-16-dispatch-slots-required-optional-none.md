---
title: "Dispatch comes from the asset configuration. Each job resource is a REQUIRED, OPTIONAL or NONE slot. Equipment quoted only inside Mobilization that conversion would not create (unconfigured, or an Optional association) is OPTIONAL; its Demobilization twin, configured machines inside a group and price lines are NONE. An OPTIONAL slot can be filled on any day and never blocks allocation completed or Send Tickets, and is shown with an \"Optional\" badge and counted apart from the required numbers. An Optional association left off the quote is not a slot. These are ticket-owner assumptions pending Lisette Anzaldo's review (Syed Haris, 2026-10-14 to 2026-10-16) — decision"
source: decision/Syed Haris — answers to TCG-218 questions Q10–Q16, Q18, Q47–Q49, Q52, Q54, Q55, 2026-10-14 to 2026-10-16
decided: 2026-10-16
decided_by: >-
  Syed Haris (syed.haris, CodingCops developer, assignee and owner of Linear TCG-218), in Claude
  Code sessions on 2026-10-14 (Q10), 2026-10-15 (Q12–Q16, Q18) and 2026-10-16 (Q47–Q49, Q52, Q54,
  Q55), recorded in `.ai/aidlc/TCG-218/spec.md` §12. Q12, Q13, Q14, Q15, Q16 and Q18 are recorded
  there as "answered by ticket owner as an assumption — to be reviewed by Lisette Anzaldo at the
  demo". On Q47(1) he chose to "Build now" on those assumptions, with "Lisette reviews at the
  demo". Lisette Anzaldo (Dispatch Manager, TCG) has not been asked, and neither has Joe
  Schacatano. Status `reference`: it binds the build, and TCG can overrule it. Rules 7–9 are
  explicitly provisional until Lisette reviews them. Implemented under TCG-218 units U9 (#806) and
  U10 (#808). Recorded by tcg-scrum 2026-10-17.
status: reference
conflicts_with: []
resolves:
  - aidlc/TCG-218/spec.md#q47--u9-before-build-proceed-on-assumptions-column-type-the-cranes-configuration-the-cranes-own-mob-line-raised-2026-10-16
  - aidlc/TCG-218/spec.md#q48--u9-build-the-board-never-shows-a-line-under-a-group-unlinked-groups-optional-sub-items-materialization-under-group-lines-raised-by-tcg-executor-on-u9-2026-10-16
  - aidlc/TCG-218/spec.md#q49--u9-after-q48-as-built-confirm-raised-by-tcg-executor-on-u9-2026-10-16-non-blocking
  - aidlc/TCG-218/spec.md#q52--u10-before-build-how-an-optional-slot-is-shown-raised-2026-10-16-unitsmd-u10-presentation-not-specified--executor-asks
  - aidlc/TCG-218/spec.md#q54--u10-as-built-other-readers-of-the-required-counts-builder-names-and-copy-raised-by-tcg-executor-on-u10-2026-10-16-non-blocking
  - aidlc/TCG-218/spec.md#q55--u10-review-and-end-to-end-test-pre-checklist-source-and-labels-dylen-chip-completion-recalculation-names-raised-2026-10-16
related_decisions:
  - 2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md
  - 2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md
  - 2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md
  - 2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md
  - 2026-08-31-quotation-qty-not-das-sets.md
  - 2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md
  - 2026-10-16-mob-demob-twin-rule-is-symmetric.md
  - 2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md
jira: []
tags: [module/dispatch, module/projects-jobs, module/quotations, kind/decision, daily-allocation, mob-demob]
---

# Dispatch slots: REQUIRED, OPTIONAL, NONE

> **Assumptions pending Lisette Anzaldo's review.** Every rule below is the ticket owner's. The
> answers to Q12, Q13, Q14, Q15, Q16 and Q18 are recorded in spec §12 as *working assumptions — to be
> reviewed by Lisette Anzaldo at the demo*, and U9/U10 were built on them (Q47(1), *"Build now"*). A
> dispatch-side answer from Lisette replaces any of them.

Which machine the job needs comes from the item's asset configuration, read from the quote's
snapshot once it has one:
[2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md](2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md).
That note covers when the configuration is read. This note covers what the job's rows become on the
dispatch board.

## Decision

**What is a slot (classification at conversion)**

| # | Rule | Source (spec §12) | Weight |
| --- | --- | --- | --- |
| 1 | **Dispatch comes from the asset configuration.** Rows inside Mobilization/Demobilization add no slots of their own. The item's top line is its one slot. | Q10 — *"they're dispatched rows, what is in the asset configuration as required, they will show on the dispatch"*; *"dispatch comes from asset configuration…"* (reading confirmed); Q47(4) | ticket owner |
| 2 | **Each job resource is one of three kinds:** **REQUIRED** (a slot that must be filled), **OPTIONAL** (a slot that may be filled), or **NONE** (not a slot). | Q47(2) | ticket owner |
| 3 | **NONE:** (a) a machine inside a group that conversion would create from the configuration anyway, i.e. reachable from the item through **Always Included** links only, because its slot comes from the configuration; (b) the **Demobilization twin** of a Mobilization line, because there is one slot per machine; (c) **price lines** inside groups (custom types, employee types); (d) **the item's own line** inside its group. | Q47(3)–(4) *"Any association of the crane"*, *"NONE"*; Q48(2)/(4) *"its Demobilization twin is `NONE`"*; Q49(b) | ticket owner |
| 4 | **OPTIONAL:** equipment quoted inside Mobilization that conversion would **not** create. This covers equipment not in the item's configuration, an **Optional** association at any depth, and an Always Included machine reachable only through an Optional link. It also covers equipment quoted **only in Demobilization**, with no Mobilization twin, and rows created under an OPTIONAL line. | Q48(2)/(4) *"Mob only, incl. Optional assoc"*; Q49(a) *"Accept all"*, (b) *"Match depth + nested Optional"* — developer: *"OPTIONAL"* for the nested-under-Optional case, *"so no machine is left without a slot"* | ticket owner |
| 5 | **REQUIRED: everything else.** This includes the item's top line, its Main items, Crane Time groups and their lines, rows of old **unlinked** groups (not classified, as before), and rows added later on the job's Resources tab. | Q48(3)/(5) *"Keep all five"*; Q49(a) | ticket owner |
| 6 | **Equipment a salesperson adds that is not in the configuration still reaches the board to assign.** Inside Mobilization it becomes OPTIONAL under rule 4. As its own top-level line it is REQUIRED under rule 5. | Q18 — *"yes"* (answers Q11) | **assumption — Lisette** |
| 7 | **An Optional association that the salesperson left off the quote is not a slot.** This takes the 2026-09-12 side and reverses the ticket owner's own 2026-10-07 Q6/U8 answer for Optional associations. A hidden **Always Included** association still reaches the job. | Q12 — *"no"*; REQ-15 | **assumption — Lisette** |
| 8 | **Only billable lines are quoted, so only billable associations are created on conversion.** Non-billable associations are still skipped, and no job-side change was made. | Q50 — *"to be on quote it needs to have a billing code"* | ticket owner |

**When and how an OPTIONAL slot is filled**

| # | Rule | Source | Weight |
| --- | --- | --- | --- |
| 9 | **No day restriction.** Equipment quoted only inside Mob/Demob, Operator Load and Sub items can be allocated on any day dispatch chooses. Visits create no required dispatch days. **A one-day job is one trip.** **Holdover items go to all days**, as holdover works today. | Q13 *"we don't restrict day, where dispatch add it can be sent"*; Q14 *"then yes"*; Q15 *"we don't restrict for now"*; Q16(1) *"whoever is holdover can go to all days"* | **assumption — Lisette** |
| 10 | **An empty OPTIONAL slot never blocks "allocation completed" or Send Tickets.** A day whose only slots are OPTIONAL counts as completed. Completion is also worked out when a job's sub-jobs are created or scheduled, so such a day starts out completed. | Q16(2) *"go with a"*; Q54(3) *"Completed"*; Q55(3) *"Recalc on conversion"* | **assumption — Lisette** (Q16); ticket owner (Q54, Q55) |

**How it is shown**

| # | Rule | Source |
| --- | --- | --- |
| 11 | An OPTIONAL slot uses the same drag-and-drop slot as any other, with an **"Optional" badge** beside the Set title (e.g. *"Set 2 (Support Load 1) · Optional"*). An empty optional slot is **never shown as missing or red**. Badge tooltip: *"Optional — leaving this Set empty does not block allocation completed or Send Tickets"*. | Q52(1) *"\"Optional\" tag on the Set"*; Q54(2) *"Accept"* |
| 12 | An OPTIONAL row whose parent is not a slot gets **its own Set**. These Sets come after the item's Sets, in group order. REQUIRED rows under Crane Time or unlinked groups keep the Sets they had before. | Q48(1) *"Own Set on the board"*; Q49(a) |
| 13 | **Counts:** the required counts include only REQUIRED slots, and OPTIONAL slots are counted separately. On the job card this reads, for example, *"Required Assets: 2 · Optional: 2"*. The Pre-checklist and the dispatch packet show required x/y plus a separate *"Optional a/b"*. Dylen shows required only, and its "unassigned" chip counts only empty REQUIRED slots. | Q52(2) *"Required only, + optional count"*; Q54(1) *"Required x/y + Optional separately"*; Q55(2) *"Exclude optional"* |

## Why

The reasons below come from the question text and the vault, as the ticket owner adopted them:

- **Rule 1 and the asset configuration.** The quote carries billing codes, and the resources are a
  dispatch-side requirement. This is Joe Schacatano's rule of 2026-09-16
  ([2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md),
  `verified`): *"The billing codes should dictate the resources and the assets for dispatch."*
- **Rule 3(b), one slot per machine.** Without it, a support load added in Mobilization would put
  two rows for one machine on the board (Q48(5)).
- **Rule 4, nested-under-Optional.** It was chosen *"so no machine is left without a slot"*
  (Q49(b)).
- **Rules 9 and 10.** The visit-days rule (below) has no day mapping, and quote dates are schedule
  placeholders. So the ticket owner left the days to dispatch and made the slot non-blocking.

## Developer decisions, not product rules

The following are developer decisions and are not requirements:

- how a row's kind is stored (an enum on the job resource, NOT NULL, default REQUIRED — Q47(2));
- that the copy from quote to job is unchanged and the board builds Sets from it (D7, Q48(1));
- the Set-root rule shared by allocation save and loadout defer (Q49(2));
- that the Pre-checklist reads the slot kind from the board data (Q55(1));
- the tenant guard on the association lookup (Q49(c));
- response field names, test IDs and helper names (Q48, Q49, Q54(2), Q55).

They are recorded in `.ai/aidlc/TCG-218/spec.md` §11b D7 and §12 Q47–Q49, Q54, Q55.

## Left open

- **Lisette Anzaldo's review** of rules 6, 7, 9 and 10. These are the one-line questions, if they need asking:
  - *"Should an Optional asset the salesperson removed from the quote still appear on the dispatch board?"*
  - *"Is equipment quoted only inside Mob/Demob dispatched on fixed days (first/last/each visit), or
    whenever dispatch chooses?"*
  - *"Should an empty slot for that equipment block 'allocation completed'?"*
- **Logged follow-ups, not decided** (Q49(d) and the U9 contract trace):
  - a sub-category that is both an Optional direct association and Always Included deeper gets two slots;
  - the holdover picker and the board's Recommended panel still list NONE lines from inside Mob/Demob;
  - stored slot kinds are not re-evaluated if the configuration, or Lisette's review, changes the rules;
  - Dylen lift information drops an OPTIONAL row's additional-info sections;
  - the defer "Set N" label counts differently from the board;
  - a REQUIRED row added later under a NONE parent cannot be reached on the board;
  - existing sub-jobs are not recalculated on a schedule save (Q55 follow-ups).
- **Q11** (how "same machine as the main item" is decided) has no separate answer; Q18 and rule 3(a)
  stand in for it.

## Conflicts — surfaced, not adjudicated

- **[2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md](2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md)
  against the Q6/U8 row of
  [2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md](2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md).**
  Both are Syed Haris's rulings. With Q12 (rule 7) he now takes the 09-12 side for Optional
  associations, and this is what is built (REQ-15). **This is not an adjudication.** It is a
  developer revising his own developer ruling. 09-12 named Lisette Anzaldo, Melissa McNutt or Joe
  Schacatano as the people whose confirmation would settle it, and none of them has. Both notes keep
  their `conflicts_with`, and both now carry a `provenance_note:` pointing here.
- **[2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md](2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md)**:
  - **Rules 1–3 (Joe's) stand.** A build-only support load goes out first and last day. Rule 9 above
    does not stop dispatch doing that; it only does not enforce it.
  - **Rules 4–5 were not built as day rules.** Rule 4 (three visits → three trips) is the ticket
    owner's, and rule 5 (Operator Load and Sub items the same) is an interpretation. The ticket
    owner's later answers (Q13, Q15) say *"we don't restrict"*. Not superseded, because those are
    assumptions pending Lisette. That note's `provenance_note:` now points here.

## Effect on the vault

- This note: `status: reference`. Rules 6, 7, 9 and 10 are marked as assumptions. **Done.**
- `decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md`:
  `provenance_note:` extended. Status and `conflicts_with` unchanged. **Done.**
- `decisions/2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md`: `provenance_note:`
  points here for its Q6/U8 row (Optional associations). Status and `conflicts_with` unchanged. **Done.**
- `decisions/2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md`:
  `provenance_note:` added. Status unchanged. **Done.**
- `aidlc/TCG-218/spec.md` §12:
  - Q10–Q16, Q18, Q47–Q49, Q52, Q54 and Q55 each have a `- **Decision note:**` line.
  - Q10's "decision note pending" label was replaced.
  - The status lines of Q11–Q16 and Q18 were left unchanged and still say "assumption — to be
    reviewed by Lisette Anzaldo".

  **Done.**
- `dispatch/INDEX.md`, `projects-jobs/INDEX.md`, `quotations/INDEX.md`: listed.
  `quotations/mob-demob-current-rules.md`: rows added under *Dispatch*. **Done.**
- No register entry closed.

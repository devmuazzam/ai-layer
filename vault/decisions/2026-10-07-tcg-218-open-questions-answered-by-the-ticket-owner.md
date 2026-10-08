---
title: "TCG-218 (Mobilization/Demobilization on the quote) — the ticket owner's answers to its open questions, 2026-10-07 to 2026-10-08: one total everywhere; visits multiply Mob/Demob only, adjustments included; show/hide is for the quote only; employee backfill keeps saved quotes; type once per quote; mirroring on rename/delete; only Price Adjustment is hand-priced (Syed Haris) — decision log"
source: decision/Syed Haris — Linear TCG-218 question log (spec §12), 2026-10-07 and 2026-10-08
decided: 2026-10-07
decided_by: >-
  Syed Haris (syed.haris, CodingCops developer, assignee and scope owner of Linear TCG-218), in the
  Claude Code sessions that elaborated and built TCG-218, 2026-10-07 and 2026-10-08. First reply,
  verbatim: "q1: ignore for now create ticket in backlog / q2: Yes / q3: Yes / q4: go with
  recommended / q5: go with recommended / q6: go with recommended / q7: go with recommended / q8: go
  with recommended / q9: yes / q10: drop / for the rest go with recommendation". "Recommended" means
  the recommendation the elaborator printed for that question; where none was printed (Q13, Q14,
  Q17, Q19) nothing was answered then. Later answers on 2026-10-07 and 2026-10-08 are quoted where
  given. One reversal (Q5/Q8) is attributed to ehtesham.anwar (CodingCops). Several questions were
  addressed to Joe Schacatano or Lisette Anzaldo; the ticket owner has authority over TCG-218's
  scope and build, and whether he can decide the customer-facing ones for TCG is not established.
  That is why this log is `reference`. Where a TCG person has since decided the same point, the
  answer says so and links the note that carries the client's words. The TCG-218 spec and its
  question log exist only on overlay branch feat/association-document-visibility (under review);
  this log is the product record of the answers, ported to overlay main 2026-10-09.
status: reference
conflicts_with:
  - decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md
resolves: []
related_decisions:
  - 2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md
  - 2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md
  - 2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md
  - 2026-10-06-employee-type-associations-start-hidden-on-the-quote.md
  - 2026-10-06-nested-association-quote-visibility-stored-per-parent.md
  - 2026-10-06-quotation-type-hourly-or-hourly-with-mob.md
  - 2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md
  - 2026-10-07-unbilled-custom-type-in-a-mob-demob-group-is-a-price-adjustment.md
  - 2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md
  - 2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md
  - 2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md
  - 2026-09-11-quotation-footer-discount-and-price-hike-rows.md
  - 2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md
  - 2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md
jira: [TCG-218, TCG-219, TCG-220]  # Linear ids, not Jira
tags: [module/quotations, module/assets, module/dispatch, kind/decision, mob-demob, pricing]
---

# TCG-218 open questions, answered by the ticket owner

The current rule for each topic, with its status, is in
[../quotations/mob-demob-current-rules.md](../quotations/mob-demob-current-rules.md). This log is the
record of what the ticket owner answered and when; where a later answer or a client statement
changed it, the row says so.

## Product answers

| Q | Answer (final) | Reply / authority |
| --- | --- | --- |
| Q1 Mobile quote builder | **Deferred** to Linear **TCG-219** (Backlog). Until it ships, the mobile builder computes group totals at ×1. | "ignore for now create ticket in backlog" |
| Q2 One total | **Yes.** Every server surface shows the same visits-multiplied total. One quote, one total. | "Yes" |
| Q3 Visits multiplier | **Yes.** At N visits the customer is charged N × the per-visit sum of the group's lines; line quantities stay per visit; the lines' discount, surcharge and price hike scale × N. | "Yes". **Lines-per-visit and N × sum client-confirmed by Joe Schacatano, 2026-10-08** (Q30); adjustment scaling remains the ticket owner's |
| Q4 Which groups | **Mobilization and Demobilization only.** Other group parents (e.g. Crane Time) roll up at ×1. | recommended |
| Q5 Nested rows | First "never shown" (recommended, following Joe 2026-10-01); **reversed** later on 2026-10-07: "Editable, quoted with parent" — ehtesham.anwar's decision, "same solution for main item and sub-item, so there is no fix rule". **Joe approved the configurable approach on 2026-10-07** (sprint review 49:55–50:30). Final: configurable, hidden by default. | see [nested note](2026-10-06-nested-association-quote-visibility-stored-per-parent.md) |
| Q6 / U8 Hidden association and dispatch | **Show/hide is for the quote only.** *"for DAS, everything which is in the association will be shown, the show/hide is only for quote."* Every **billable** association of a quoted item (Always Included and Optional, every depth) becomes a job resource / DAS slot on conversion; an association whose item has no ACTIVE billing code is not. Only Always Included associations raise the DAS missing-components warning. Also answers Q23, Q26, Q27. | recommended, then the U8 reply. **Conflicts with 2026-09-12** — see below |
| Q7 Employee backfill | **Yes to both.** Existing employee-type associations are hidden; saved quotes keep their lines when reopened. | recommended |
| Q11 Quantity precision | **Two decimal places.** | recommended |
| Q12 Price Adjustment rate | **May carry cents.** | recommended |
| Q13 Which custom lines | **Only the "Price Adjustment" custom type** is hand-priced inside Mob/Demob; any other code-less custom line needs a billing code. Supersedes the 2026-10-07 any-custom-type rule. | 2026-10-08, "q13: no"; reading confirmed 2026-10-09, "q13: yes" — [note](2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md) |
| Q14 Mirroring | **The twin follows**: renaming or deleting a line in Mobilization renames/deletes its Demobilization twin, and the reverse. Adding was already mirrored. | 2026-10-08, "q14: twin follow" |
| Q15 Switching type | **Confirm before switching when the switch will change rows**; a switch with nothing to rebuild is silent. | recommended, refined 2026-10-07 |
| Q16 Association order | **Follow the sub-category page's order.** | recommended |
| Q17 Type once per quotation | **Once per quote.** One quotation cannot mix an hourly crane with a mob/demob crane. | 2026-10-08, "q17: once per quote" |
| Q18 Independent Show settings | **Yes, set separately.** | recommended |
| Q19 Employee type tickable | **Not answered.** Joe's 2026-10-07 approval makes ticking possible; whether it is the route for a charged operator is open. | — |
| Q22 Older quotes | **Existing quotes are Hourly** — no inference from their groups, no backfill. | "existing is just hourly" (supersedes the recommended inference) |
| Q25 Approval margin | **Yes to both** — multiply a Mob/Demob group's lines (revenue and cost) by visits; leave out lines unticked inside a group. | 2026-10-07 |
| Q30 Lines per visit | **Every checked line inside the group is per visit**; a one-off cost goes on its own line outside the group. **Client-confirmed by Joe Schacatano, 2026-10-08** for the per-visit rule. | [visits note](2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md), *The exchange* |
| Q31 Mob/Demob-only equipment | **Goes out on every visit**: day 1 to build and the last day to break down, and again for each extra visit. Operator Load and Sub-item associations treated the same way — **interpretation, not confirmed**. | 2026-10-08 — [note](2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md) |

## Build answers (not product rules)

Q8 (integrity of the per-parent nested-id lists: validated, de-duplicated, sub-item ids a subset of
shown ids), Q9 (association and quotation-resource models to be tenant-scoped by id), Q10 (an unused
per-line "hidden on document" column dropped), Q20 (quotation type stored as a short string, not an
enum, because the job-type list is not closed), Q21 (adding an association runs in a transaction).
These bind the TCG-218 build only.

## Why

The reasons are the elaborator's, as printed under each question; the ticket owner gave no reasons
of his own beyond adopting them, except where a reply is quoted. The ones that carry weight:

- **Q2:** a caller that rolled up a group without its quantity treated every group as ×1, so one
  quote showed different totals on different surfaces.
- **Q4:** Joe spoke only of Mobilization; nothing written says Crane Time or any other group
  multiplies.
- **Q6/U8:** the `verified` 2026-09-16 rule (resources are dispatch-side, the quote is billing codes)
  and Joe's 2026-10-01 13:37 (*"always included on the job end when it's dispatched"*). Quote
  visibility is a billing-document concern; it should not decide dispatch.

## Conflicts — surfaced, not resolved

- **Q6/U8 against [2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md](2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md)**
  (`reference`, also Syed Haris). 09-12: an **Optional** association the quotation did not carry is
  not materialised on conversion — *"If the salesperson removed it, the quotation is the record that
  they did."* U8: every billable association becomes a DAS slot whatever the quote carries. Both are
  developer rulings; neither is a client's. 09-12 named Lisette Anzaldo or Melissa McNutt as the
  people whose confirmation would settle it; none has. **Not adjudicated**; both stay `reference`
  and list each other in `conflicts_with`. It changes what the DAS board shows for every Optional
  association (e.g. an Optional Rigger).
- **Q3 against [2026-09-11-quotation-footer-discount-and-price-hike-rows.md](2026-09-11-quotation-footer-discount-and-price-hike-rows.md)**
  point 2 (group parent = sum of included children): **settled for Mob/Demob groups by Joe's
  2026-10-08 confirmation** — visits × sum. Recorded in the visits note; 09-11 carries a
  `provenance_note:`.
- **Q5 against [2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md](2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md)**
  (`verified`): **closed** — Joe himself approved the configurable, hidden-by-default rule on
  2026-10-07.

## Effect on the vault

All done in the pass that ported this log to overlay main (2026-10-09):

- `decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md` →
  `conflicts_with` gains this log; `provenance_note:` added pointing at the Q6/U8 answer. Status
  unchanged (`reference`). **Done.**
- `decisions/2026-10-07-unbilled-custom-type-in-a-mob-demob-group-is-a-price-adjustment.md` →
  `superseded` by the Q13 note. **Done** (recorded in that note).
- Not touched: `quotations/gaps.md` → *Quote line items vs dispatch resources* and *Estimate defaults
  per resource type / job type / yard*. Both are TCG's questions; a developer's answer does not close
  them.

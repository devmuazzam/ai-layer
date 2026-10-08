---
title: "Mobilization/Demobilization on the quote — several billing codes with their own quantities rolled into one line, an editable Mobilization quantity, Demob at 0, customer sees mob, demob and main items only, groups at the bottom (Joe Schacatano, 2026-10-01) — decision"
source: decision/client recorded call (Joe Schacatano, 2026-10-01)
decided: 2026-10-01
decided_by: >-
  Joe Schacatano (TCG executive; "Vice President of Sales" in the reporting chart of
  admin/engagement-directory-and-org-charts.md:133 and "VP of Operations" in its directory table,
  line 33; the owner of how TCG quotes), on the recorded 2026-10-01 "Quotes and Billing Codes"
  call, walking through mob/demob in FCC on his own screen. Points 1, 2, 5 and 6 are his
  unprompted statements. Points 3, 4 and 8 answered direct questions from ehtesham.anwar
  (CodingCops): 27:11 "Yes. Exactly", 30:21, 1:03:07. Point 7 was prompted by Brian Petros (TCG,
  29:02). Brian Petros and Melissa McNutt (TCG) were present and did not object. Not confirmed in
  writing. When the meeting was curated on 2026-10-02, no decision note was written. This note was
  written on 2026-10-07 because Linear TCG-218 builds against these statements, and ported to
  overlay main on 2026-10-09 with the 2026-10-08 answers. It rests on the same basis as
  decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md.
  Where Joe was describing FCC practice rather than stating what the ERP must do, the point says so.
  The 2026-10-08 update below carries its own attribution per point.
status: verified
conflicts_with: []
resolves: []
related_decisions:
  - 2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md
  - 2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md
  - 2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md
  - 2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md
  - 2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md
  - 2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md
  - 2026-09-11-quotation-footer-discount-and-price-hike-rows.md
jira: []
tags: [module/quotations, kind/decision, mob-demob, pricing, requirements]
---

# Mobilization and Demobilization on the quote

> **Conflict stub first.** Mob/demob has a conflict stub,
> [../quotations/mob-demob-INDEX.md](../quotations/mob-demob-INDEX.md): the migrated
> [../quotations/mobilization-and-demobilization.md](../quotations/mobilization-and-demobilization.md)
> (`unverified`), and a second Confluence page that was never migrated, carrying FR-01…FR-12.
> **This note does not adjudicate between them.** It records what the quotation owner said on
> 2026-10-01. Where that agrees with the migrated page's FR-1, FR-2, FR-6 and FR-7, the note says so.
>
> All current Mob/Demob rules, with their status, are listed in
> [../quotations/mob-demob-current-rules.md](../quotations/mob-demob-current-rules.md).

## Decision

Joe Schacatano, 2026-10-01:

1. **A Mobilization holds several billing codes, each with its own quantity, totalling into one
   line** (22:53–23:37). *"if I have five things that are included in my mobilization, it would be
   5 billing codes. Every quantity would be different."* Demobilization works the same way.
2. **Every sub item and main item is quoted on its own billing code, and every quantity can be
   edited while quoting** (26:50 → 27:11, *"Yes. Exactly"*).
3. **The customer receives Mobilization, Demobilization and the main items only** (same exchange).
   The lines inside Mob and Demob are never shown to the customer. This agrees with FR-6 of the
   migrated page. **This covers both customer documents**, the server PDF and the browser print.
   The browser print breaking it is a bug, tracked as Linear `TCG-202`.
4. **Demobilization quantities start at 0, not copied from Mobilization** (30:19 → 30:21). *"I'd
   rather have it all populated 0 so that they have to manually put it in because they're all
   going to be different."*
5. **A line left at quantity 0 stays out of the total** (51:01–51:35). Unused support loads on a
   365 ton crane stay at 0, *"and then it's going to stay out of the mobilization"*.
6. **A Price Adjustment line inside mob/demob carries costs that have no billing code** (37:16).
   Examples: *"a hotel, food, just random stuff that we don't really generate billing codes for, or
   if we want to just add extra money in there"*. Joe was pointing at FCC's line and raised it
   *"before I forget"*. That counts as asking for it, not only describing it. Which lines qualify
   was narrowed on 2026-10-08 — see the update below.
7. **The Mobilization line's own quantity must be editable** (29:02–29:35). Brian noticed FCC
   fixes it at 1. Joe: *"that's an issue we have with this system… We need the option to be able to
   multiply the mobilization as many times as we want because we might be doing 5 different visits
   to the job… this mobilization quantity, we want to be able to change that as much as we
   want."* What it multiplies was confirmed by Joe on 2026-10-08 — see the update below.
8. **Adding a line to Mob adds it to Demob** (1:02:57 → 1:03:07). ehtesham.anwar proposed it. Joe:
   *"Yeah, if it's automated, yeah, because then that way we don't miss it on that end… we want
   the numbers typically to match up."* With point 4, the mirrored line arrives at quantity 0.
9. **The Mob/Demob groups go at the bottom of the quote** (1:01:56–1:02:14). Joe opened with *"I
   have no preference on it"*, then: *"it's like looking at a balance sheet. You're looking at the
   total on the bottom… if we want to change the quantity of the mobilizations, taking it from one
   to three… we're not maybe going through all the line items and then missing it because it's at
   the top. So I think on the bottom is better."* **Record this as his stated preference, not a
   hard requirement.**

## Quoting practice Joe described (not a system rule)

- **Operator Load sits inside mob and demob, not on the customer's list** (38:18–39:30). On a
  one-day job it is 0.5 in Mobilization and 0.5 in Demobilization, *"still capturing the one day
  cost"*. On a multi-day (holdover) job it is charged on the first and last day only. This is how
  salespeople fill the quote. For the system, it means **a line inside a group must accept a
  fractional quantity**. No TCG person stated a precision; the ticket owner set two decimal places
  for TCG-218 (Q11, see
  [2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md](2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md)).
- **Crew overtime and double time go inside mob** (34:05–34:45), *"hiding but capturing the cost at
  the same time"*.
- **What the hours mean** (32:24–36:23): Mob runs from leaving the yard until build-up is complete.
  Demob runs from the start of breakdown until the crew is back at the yard. The crane line after
  them is hook time.
- **A support load that only goes to build sits inside mob/demob; one that stays on site is a main
  item** (52:08–52:54). This is the client basis of
  [2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md](2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md).

## Why

Joe, 26:11: mob/demob is *"travel to the job setup, and any other associated costs… or maybe things
you want to hide in it, and then it populates as the one line item… we're incorporating a bunch of
charges to come up with a flat rate."* The customer gets a short quote, and the internal lines stay
for costing (FR-7 of the migrated page). The editable Mobilization quantity exists because a job
may need several visits (29:15). Demob starts at 0 because its lines *"are all going to be
different"* (30:21).

## Conflicts

- **None with a `verified` source.** This matches FR-1, FR-2, FR-6 and FR-7 of
  [../quotations/mobilization-and-demobilization.md](../quotations/mobilization-and-demobilization.md)
  (`unverified`). It also matches 2026-09-16 §4 (*"so that we're not showing 50 billing codes"*),
  recorded in [../quotations/gaps.md](../quotations/gaps.md) → *Estimate defaults per resource type
  / job type / yard*, update 2026-09-16 (d).
- **Point 7 and [2026-09-11-quotation-footer-discount-and-price-hike-rows.md](2026-09-11-quotation-footer-discount-and-price-hike-rows.md)**
  (`reference`), which shows a Mob/Demob group parent's Amount as *"the sum of its included
  children"*. Joe confirmed on 2026-10-08 that the Mobilization quantity multiplies that sum. The
  09-11 note's figure therefore holds at quantity 1 only; recorded in
  [2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md](2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md).
- **Not a conflict:** [2026-08-31-quotation-qty-not-das-sets.md](2026-08-31-quotation-qty-not-das-sets.md)
  gives children a default quantity of 1. It also says explicitly that *"Mobilization /
  Demobilization / Crane Time group billing rules are unchanged"*, so point 4 (Demob at 0) sits
  outside it.

## What this does not settle

- **The per-machine mob/demob template with minimum quantities** (Melissa McNutt and Joe,
  47:38–49:59), and **the quoted-versus-scheduled hours alert** (45:25). Neither was decided.
- **Whether an invoice carries exactly the quote's lines** (ehtesham.anwar 11:34; Joe answered a
  different point). Filed in [../accounting/gaps.md](../accounting/gaps.md) → *Does the invoice
  carry exactly the quotation's lines*.

## Update 2026-10-08 — answers that refine this note

Each point carries its own authority. This note's status (`verified`) rests on Joe's 2026-10-01
words only; the ticket-owner points below do not inherit it.

- **Point 7 — what the Mobilization quantity multiplies. Client-confirmed (Joe Schacatano, Teams,
  2026-10-08).** Lines inside Mobilization are entered as for one visit; the Mobilization line's
  quantity is the number of visits and multiplies the line. The exchange is quoted verbatim in
  [2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md](2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md).
- **Point 8 — mirroring extends to rename and delete. Ticket owner (syed haris, 2026-10-08,
  TCG-218 Q14, "q14: twin follow").** Renaming or deleting a line in Mobilization renames or deletes
  its Demobilization twin, and the reverse; adding was already mirrored. Build reading recorded
  with the answer: a twin is left alone while another line in the source group still has its name;
  a rename keeps the twin's quantity and re-prices it. Joe has not been asked.
- **Point 6 — only the Price Adjustment item is hand-priced. Ticket owner (syed haris, 2026-10-08,
  TCG-218 Q13).** See
  [2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md](2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md).
- **Two cranes on one job. Client (Joe Schacatano, 2026-10-07 sprint review).** One quote, a
  separate Mobilization/Demobilization per crane, labelled with the crane. See
  [2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md](2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md).

## Effect on the vault

- **No status flips.** [../quotations/mobilization-and-demobilization.md](../quotations/mobilization-and-demobilization.md)
  is confirmed in **part** only: FR-1, FR-2, FR-6 and FR-7. FR-3, FR-4, FR-5, FR-8, REQ-1 to REQ-5
  and the 2026-09-04 additions were not addressed. Flipping the whole file to `verified` would
  over-claim. It also sits under an unadjudicated conflict stub. The file stays `unverified`.
- **Not resolved:** the retired root register's `gaps.md#mobilization-and-demobilization`
  (*which page is authoritative*). Nothing here chooses a page.

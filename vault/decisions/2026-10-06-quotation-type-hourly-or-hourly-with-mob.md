---
title: "A quotation has one Quotation Type, Hourly or Hourly w/ Mob, chosen once for the whole quote (default Hourly), which lays out the Resources tab; switching rebuilds the rows after a confirmation; existing quotes are Hourly (Syed Haris, 2026-10-06 – 2026-10-08) — decision"
source: decision/Syed Haris — TCG-218 design and TCG-218 question answers, 2026-10-06 to 2026-10-08
decided: 2026-10-06
decided_by: >-
  Syed Haris (syed.haris, CodingCops developer, assignee and owner of Linear TCG-218). Decided in a
  Claude Code session on 2026-10-06/07 (the names 'hourly' / 'hourly_w_mob' chosen 2026-10-06),
  refined by his answers to TCG-218 Q15, Q20 and Q22 on 2026-10-07, and Q17 ("q17: once per quote")
  on 2026-10-08. The two type names are FCC's job types; that is FCC as held, not a TCG decision
  that the ERP adopts them. The type switch was demoed to Joe Schacatano on the recorded 2026-10-07
  sprint review (§7, "with a confirmation popup") and he raised no objection, but he was not asked
  whether the type is per quote or per crane. This is the ticket owner's ruling, not a TCG client
  confirmation, so the status is `reference`: it binds the build, and TCG can overrule it. Written
  2026-10-07; ported to overlay main 2026-10-09. Built on branch feat/association-document-visibility,
  under review.
status: reference
provenance_note: >-
  POINT 3 AMENDED 2026-10-16 by the same ticket owner (TCG-218 Q42) — see
  decisions/2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md (status:
  reference). On Hourly w/ Mob the Mobilization and Demobilization groups now hold the item itself
  (first line, quantity 0) then its Sub items, not its Sub items alone. Points 1, 2, 4 and 5 stand.
  Status stays reference; the note is amended, not superseded. Point 3's original text is kept below.
conflicts_with: []
resolves: []
related_decisions:
  - 2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md
  - 2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md
  - 2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md
  - 2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md
jira: []
tags: [module/quotations, kind/decision, mob-demob, pricing]
---

# Quotation Type: Hourly / Hourly w/ Mob

## Decision

Syed Haris (ticket owner):

1. **A quotation carries one Quotation Type**: *Hourly* or *Hourly w/ Mob*, default Hourly, carried
   on duplicate, set by a chip beside Price List. Stored as a short string (`'hourly'` |
   `'hourly_w_mob'`), not an enum, because the job-type list is not closed (Q20).
2. **It is chosen once per quotation** (Q17, 2026-10-08). One quotation cannot mix an Hourly crane
   with a Mob/Demob crane. With two main cranes on one quote, both follow the quote's type.
3. **The Resources tab lays out by it.**
   - **Hourly:** each item, with the associations it shows on Hourly (and any "also brings along"
     rows its parent shows).
   - **Hourly w/ Mob:** the item alone, then its Main items as their own lines, then the
     Mobilization and Demobilization groups (its Sub items) at the bottom.

   > **Amended 2026-10-16 (Q42):** the groups hold **the item itself, then its Sub items** — see
   > [Amendment — 2026-10-16](#amendment--2026-10-16) below.
4. **Switching type rebuilds the rows.** The user confirms first **when the switch will change
   rows**; a switch with nothing to rebuild happens silently. Manual edits may be discarded only
   after that confirmation (Q15, refined 2026-10-07).
5. **Existing quotes are Hourly.** No inference on open and no backfill: every quote saved before
   the type existed opens as Hourly, whatever groups it carries ("existing is just hourly",
   2026-10-07 — this supersedes the earlier Q22 answer that inferred Hourly w/ Mob from the groups).

## Why

The client basis for two quote shapes:
- **Joe Schacatano, 2026-10-01:** quotes are either hourly or mob/demob. ehtesham.anwar at
  1:05:05: *"while we are building for the hourly and while we are building for the mob demob"*.
  The prototype's second pass at 1:00:59 had a button converting an hourly quote to mob/demob.
- **FCC's job types** *Hourly* and *Hourly w/ Mob*: `quotations/fcc-estimate-templates-by-job-type.md`.
  The un-migrated Confluence page in [../quotations/mob-demob-INDEX.md](../quotations/mob-demob-INDEX.md)
  also mentions an *"Hourly with Mob" quote type*.

The ticket owner gave no stated reason for "once per quotation".

## Conflicts — surfaced, not resolved

- **No decision note conflicts.**
- **Open register questions it answers by construction**, not closed:
  [../quotations/gaps.md](../quotations/gaps.md) → *Estimate defaults per resource type / job type /
  yard — FCC has them, TCG has no job type at all*:
  - **(a)** *What is the full job-type list?* The product has two. FCC also has Bare and Storage,
    and the extract shows codes `B`, `H`, `S` and `Z`.
  - **(f)** *Does the job type sit on the quotation as a whole or per resource row?* FCC keys it per
    resource type, so one FCC quote could mix an Hourly crane with an Hourly w/ Mob one. This note
    says **whole quotation**, on the ticket owner's authority.
  - Both stay open, owned by Joe Schacatano / Ryan Adams.
- **Two cranes on one quote.** Joe (2026-10-07) wants a separate Mob/Demob per crane on one quote
  ([2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md](2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md)).
  That fits point 2 when both cranes mobilise. A job where one crane is hourly and the other is
  mobilised was not discussed by Joe; point 2 forbids it on one quote.

## The one-line question for TCG (Joe Schacatano), if it needs confirming

*"Is Hourly vs Hourly w/ Mob chosen once for the whole quotation, or can one quotation mix an hourly
crane with a mob/demob crane?"* The ticket owner answers **once per quotation**.

## Amendment — 2026-10-16

**Point 3, Hourly w/ Mob, amended by the same ticket owner** (Syed Haris, TCG-218 Q42, 2026-10-16,
Claude Code session): picking an item on an Hourly w/ Mob quote also puts **the item itself as the
first line of its own Mobilization group** (same item, priced like any new group line — customer
price list, else billing code — at quantity 0), with its Demobilization twin at 0. The item also
stays as its own line on top. Only an item with at least one Sub item gets a pair (Q32b unchanged).
FCC's per-block comments are not adopted. Point 3 now reads, in effect: *the item, then its Main
items as their own lines, then the Mobilization and Demobilization groups (the item itself, then its
Sub items) at the bottom.* The text above is kept as it was decided. Full record:
[2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md](2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md).

## Effect on the vault

- No status flips. No register entry was closed.
- 2026-10-16: point 3 amended (see above); this note stays `reference`, not superseded.

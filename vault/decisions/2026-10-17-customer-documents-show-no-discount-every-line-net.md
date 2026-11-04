---
title: "Customer documents show no discount: the customer sees the rates, the discount is kept internal (client-stated by Joe Schacatano, Teams, 2026-10-17); a Mob/Demob line prints Qty = visits, Rate = one visit's total, Amount = Qty × Rate (client-confirmed). Every line net of discount and price hike, net Rate to cents, no Discount / Price Hike rows, Surcharge row stays, Subtotal = sum of printed Amounts, approval-reason box off the print (ticket owner) — decision"
source: decision/client written reply (Joe Schacatano, Microsoft Teams, 2026-10-08 thread, replies relayed 2026-10-17), applied by Syed Haris (ticket owner, TCG-218 Q45, Q62, Q63)
decided: 2026-10-17
decided_by: >-
  Joe Schacatano (TCG VP of Sales, the quotation owner), in written replies in the Microsoft Teams
  thread of 2026-10-08, to two questions syed haris posted there on 2026-10-16 and 2026-10-17. His
  replies were relayed verbatim by Syed Haris on 2026-10-17 and are recorded in
  `.ai/aidlc/TCG-218/spec.md` §12 Q45; they are quoted under "The exchange". Joe's replies settle
  rules 1–3 below (client). Everything else — price hike treated like discount, the net Rate rounded
  to cents, the Surcharge row, the customer Subtotal, the approval-reason box — is the ruling of
  Syed Haris (syed.haris, CodingCops developer, assignee and owner of Linear TCG-218) in Claude Code
  sessions on 2026-10-16 and 2026-10-17 (Q45 reading, Q62, Q63), which Joe did not address. Implemented
  under TCG-218 unit U12. Recorded by tcg-scrum 2026-10-17.
status: verified
conflicts_with: []
resolves:
  - aidlc/TCG-218/spec.md#q45--u8-as-built-helper-names-sibling-6-crane-label-copy-edge-rows-raised-by-tcg-executor-on-u8-2026-10-16
  - quotations/gaps.md#branch-fixdas-fixes--archive-gate-rate-error-precedence-discount-and-price-hike-footer-rows (the printed-quote half of (c) only)
related_decisions:
  - 2026-09-11-quotation-footer-discount-and-price-hike-rows.md
  - 2026-09-02-one-surcharge-per-quote.md
  - 2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md
  - 2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md
jira: []
tags: [module/quotations, kind/decision, pricing, mob-demob]
---

# Customer documents show no discount

"Customer documents" = the quotation the customer receives: the PDF and the printed quote, and any
customer-facing list of its lines (e.g. the signing/delivery email's "includes" list). Internal
screens (create/edit, the detail view, approvals) are **not** covered by this note; they keep the
on-screen rules of [2026-09-11-quotation-footer-discount-and-price-hike-rows.md](2026-09-11-quotation-footer-discount-and-price-hike-rows.md).

Current Mob/Demob rules, with status per rule:
[../quotations/mob-demob-current-rules.md](../quotations/mob-demob-current-rules.md).

## Decision

| # | Rule | Authority |
| --- | --- | --- |
| 1 | A Mobilization / Demobilization line on a customer document prints **Qty = number of visits, Rate = one visit's total, Amount = Qty × Rate** (the lines inside stay hidden). | **Client-confirmed** — Joe Schacatano, 2026-10-17: *"#1. Yes"* |
| 2 | **The customer sees the rates; the discount is seen internally only.** | **Client-stated** — Joe, 2026-10-17: *"The rates would just show to the customer and the discount would need to be seen internally."* |
| 3 | **No discount line on any customer document**, for lines inside or outside Mob/Demob — a discounted line shows only its discounted price. | **Client-stated** — Joe, 2026-10-17, answering the either/or follow-up: *"Discount kept internal. We don't want a discount line to show to the customer."* |
| 4 | **Price hikes are treated the same as discounts**: every line prints **net of its discount and its price hike**, and there are **no Discount and no Price Hike foot rows** on the customer's copy. | Ticket owner — Syed Haris, 2026-10-17 (Q45 widening). Joe spoke of discounts only |
| 5 | The **Rate column shows the net rate**. When net Amount ÷ Qty is not whole cents, the Rate is **rounded to cents** and the Amount is the **stored net amount** — so Qty × Rate may miss the Amount by a few cents, and the totals match every internal screen and the stored Total. A line with no discount or hike, and a quantity-0 line, print their stored Rate. | Ticket owner — Q63(1) option **a**, 1b, 1c |
| 6 | A Mob/Demob line's Rate and Amount are **after** the discounts / price hikes of the lines inside it (× visits); those inner adjustments appear in no foot row. | Ticket owner — Q45(2) reading of Joe's #2, then widened to every line by rule 4 |
| 7 | The **Surcharge row stays** on the customer document; inner lines' surcharge stays in it, amount and % unchanged. Lines are netted of discount and price hike only, never of surcharge. | Ticket owner — Q62(3), Q45 widening. Consistent with the verified one-surcharge row ([2026-09-02-one-surcharge-per-quote.md](2026-09-02-one-surcharge-per-quote.md)) |
| 8 | The customer **Subtotal = the sum of the printed Amounts**, so Subtotal + Surcharge = Total on the page. The internal detail view keeps its own subtotal. | Ticket owner — Q62(2) |
| 9 | The "Reason for Internal Approval" box, which names discounted lines and their %, is **off the printed quote**; internal screens still show the reasons. | Ticket owner — Q63(3), superseding Q45(3) for the print |
| 10 | Lines inside Mob/Demob never appear on a customer-facing surface; every other line does — including the signing/delivery email's "includes" list, which uses the same lines as the PDF. | Ticket owner — Q45(3) |

## The exchange

**Question 1** — sent by syed haris to Joe Schacatano as a reply in the 2026-10-08 Teams thread,
2026-10-16, verbatim (spec §12 Q45):

> Hi Joe, following up on this: with visits in place, a Mobilization with 3 visits now prints on the
> customer's quote as one line, with the lines inside hidden: **100 Ton Crane – Mobilization | 3 | Each | $1,230.00 | $3,690.00**.
> 1. Is that right: Qty = number of visits, Rate = one visit's total, Amount = Qty × Rate?
> 2. If a line inside the Mobilization has a discount or price hike, should the Mobilization's Rate
>    and Amount show the price **before** it, with the discount as its own row at the bottom (as it
>    works for every other line today), or **after** it?

**Answer** — Joe Schacatano, relayed by Syed Haris 2026-10-17, verbatim:

> #1. Yes
>
> #2. The rates would just show to the customer and the discount would need to be seen internally.

**Follow-up** — sent by Syed Haris in the same thread, 2026-10-17, verbatim:

> Thanks Joe, that helps. So on the customer's quote, a Mobilization or Demobilization line will show
> its price **after** any discount or price hike on the items inside it, with no separate discount
> line for it. For example, if the Operator Load inside a 3-visit Mobilization has 10% off:
> **100 Ton Crane – Mobilization | 3 | Each | $1,219.00 | $3,657.00**. The customer sees only that
> line. The $33 discount stays visible internally (in the quote itself and in approvals), not on the
> customer's copy.
> One thing to confirm: lines **outside** Mob/Demob (for example the crane's hourly rate) still show
> the full rate on the customer's quote, with the discount as its own line near the total. Should
> those stay that way, or should they also show only the discounted rate, with the discount kept
> internal?

**Answer** — Joe Schacatano, relayed by Syed Haris 2026-10-17, verbatim:

> Discount kept internal. We don't want a discount line to show to the customer.

**What it settles, and what it does not.** Rules 1–3 are Joe's. He named **discounts** only: that
price hikes are also kept off the customer's copy (rule 4) is the ticket owner's extension, as are the
rounding, Surcharge, Subtotal and approval-box rules (5–10). Joe did not address surcharge; the
Surcharge row is unchanged and still rests on the verified 2026-09-02 note.

## Why

Joe: the customer should see rates, and the discount is an internal matter — *"We don't want a
discount line to show to the customer."* The ticket owner applied it to price hikes for the same
reason (an internal adjustment), and chose rounding the Rate rather than recomputing the Amount (Q63
option a) so that every Amount and the Total on the customer's copy equal the stored figures every
internal screen shows; Qty × Rate missing the Amount by cents was accepted as the smaller cost. The
customer Subtotal follows the printed Amounts so the page adds up (Q62(2)). The approval-reason box
was taken off the print because it would otherwise show a discount on a printed copy (Q63(3)).
Corroboration, `unverified`: TCG's real quote prints Subtotal, surcharge and Estimate Total with no
discount or hike row ([../quotations/quote-terms-and-rate-card.md](../quotations/quote-terms-and-rate-card.md):50-52).

## Conflicts

- **Not a conflict — settles what it left open:** [2026-09-11-quotation-footer-discount-and-price-hike-rows.md](2026-09-11-quotation-footer-discount-and-price-hike-rows.md)
  (`reference`, Fouzan Shakil) puts Discount and Price Hike foot rows on **create/edit and detail**
  (internal screens) and lists *"Whether the printed quote carries Discount and Price Hike rows"* under
  *What this does not settle*. Its on-screen rules stand; this note answers the printed half: no. Not
  superseded; its `provenance_note:` now points here.
- **Not a conflict:** [2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md](2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md)
  rule 6 (a group's discount / surcharge / price hike scale × visits) — still how the money is
  computed; this note changes only where it is shown on the customer's copy.
- **Not a conflict:** [2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md](2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md)
  point 3 (the customer sees Mobilization, Demobilization and main items only) — rule 10 is the same.

## Effect on the vault

- This note: `status: verified` for rules 1–3 (Joe Schacatano, 2026-10-17); rules 4–10 are the ticket
  owner's and carry `reference` weight inside it, as marked per row. **Done.**
- `decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md`: `provenance_note:` extended
  to say the printed half of its open question is answered here. Status stays `reference`,
  `conflicts_with` stays `[]`. **Done.**
- `aidlc/TCG-218/spec.md` §12 Q45: `- **Decision note:**` line added. **Done.**
- `quotations/INDEX.md` and `quotations/mob-demob-current-rules.md`: rows added. **Done.**
- [`../quotations/gaps.md#branch-fixdas-fixes--archive-gate-rate-error-precedence-discount-and-price-hike-footer-rows`](../quotations/gaps.md#branch-fixdas-fixes--archive-gate-rate-error-precedence-discount-and-price-hike-footer-rows):
  the printed-quote half of (c) marked resolved (Status line narrowed to (b) and (d), struck through
  under *Still open*, dated *Resolved in part 2026-10-17* bullet pointing here, Discount row
  attributed to Joe and Price Hike row to the ticket owner); `resolves:` above names it. **Done**
  2026-10-17 (TCG-218 close-ticket pass). (b) and (d) stay open.
- [`../quotations/gaps.md#per-row-surcharge-now-has-no-ui-on-createedit-and-final-amount-means-two-different-numbers`](../quotations/gaps.md#per-row-surcharge-now-has-no-ui-on-createedit-and-final-amount-means-two-different-numbers)
  (its *Update 2026-09-19* UAT bullet cites 09-11 rules 2–3): **not closed** — it is about the
  editing screen's hover tooltip, which this note does not cover; a dated pointer saying so was
  appended. 2026-10-17.

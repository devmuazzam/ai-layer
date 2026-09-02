---
title: A quotation carries exactly one surcharge, resolved at quote level and named from its record
source: decision/Melissa McNutt (client), implemented 2026-09-02
decided: 2026-05-05
decided_by: Melissa McNutt (TCG, President) — answering ans.nisar's direct question in the 2026-05-05 ERP system review, corroborated by Brian Petros and Joe Schacatano in the same call and by Joe on 2026-03-12. `status: verified` — this is a named client stating the rule about their own billing, not an inference from code.
status: verified
conflicts_with: []
resolves: quotations/gaps.md#the-surcharge-is-blanket-in-the-contract-but-per-resource-in-the-model-and-it-has-no-name
jira: []
tags: [module/quotations, kind/decision, surcharge, billing, price-list, requirements]
entities: [quotation, surcharge, price-listing, billing-code]
---

## Decision

**One surcharge per quotation.** One rate, one customer-visible line, one name.

- **The rate** is the quote's price-list surcharge if it has one, otherwise the tenant-wide
  billing-code surcharge. A price list **replaces** the rate; it never adds a second surcharge.
- **The rate does not vary by line.** Whether a particular item sits on the price list has no
  bearing on which rate applies to the quote.
- **Per line, only membership varies** — `BillingCode.applySurcharge` decides whether a line is
  inside the surcharge base.
- **The printed quote shows one row**, named, with clean line amounts above it.

## Why — the client stated it

The question was put to the client directly in the 2026-05-05 ERP system review:

> **ans.nisar @ 1:13:10** — *"does it affect surcharge for all the quotations, or does it vary?"*
> **Melissa McNutt @ 1:13:24-29** — *"It'll be all the quotations. **One line for all the
> quotations. Yeah, one price.** Actually, on price list there may be different, but we can set
> those up per the price list."*

Three corroborations, all naming one surcharge and never two:

- **Melissa @ 1:00:41** — *"the last item is this fuel insurance surcharge, and it's at a
  percentage. That one percentage goes on top of every single item included in the bid."*
- **Brian Petros @ 1:03:00** — *"it goes for every single quote. We may want to make it a standard
  that shows up on every quote so nobody forgets it ever."*
- **Joe Schacatano, 2026-03-12 @ 1:09:55** — the quote gives *"the machine, the operator load, the
  travel permit and the fuel insurance and surcharge"* — a line item alongside the others.
- **Micaela Dipane, 2026-07-23 @ 18:49**, at invoicing — *"the NOTAM, the travel permit, and then
  **our surcharge**"* — singular, definite.

The contract agrees and is unconditional: *"ALL CHARGES ARE SUBJECT TO A 12% FUEL & INSURANCE
SURCHARGE."* The arithmetic on quote OM-35140 is subtotal-wide: `4,605.00 × 0.12 = 552.60`.

## Membership is per line; the rate is not

The two were conflated. They are different things, and Melissa separated them herself:

> **@ 1:03:10** — *"in FCC right now, when we set up the billing code, it has where you can click
> that the percentage applies to… if there's line items that don't have a surcharge, you can make
> where it doesn't add the percentage to it — then it wouldn't show up on the quote and wouldn't be
> included in it."*
> **Joe @ 1:03:44** — *"I can't give you like a single example. I would just say we have to have the
> option to apply to the code like you just explained it."*

So the opt-out is a **capability with no known exclusions today**, and it lives on the billing
code. Also settled in the same exchange: Ehtesham asked *"the fuel surcharge is only for vehicles,
right?"* — Melissa: *"It's for most all the line items."* Not vehicle-only. And **ans.nisar @
1:04:46: "it's not editable, it should be system generated"** — the amount is computed, never typed.

## The name is data, not a constant

`Surcharge.label`, defaulted in the database to `Fuel & Insurance Surcharge`.

TCG charges exactly one and calls it that — Melissa @ 1:02:55, purpose stated outright: *"For fuel
and insurance, just to cover our cost."* But the name is billing copy rather than an identifier:
TCG has asked to be able to rename it, and the wider industry bills **emissions, environmental and
damage-waiver** surcharges through the same mechanism ([Herc Rentals](https://www.hercrentals.com/services-associated-charges.html)
runs a separate Emissions and Environmental Surcharge alongside fuel, and splits fuel itself into
variable and fixed components).

Nothing hardcodes the string. Where no surcharge record exists the printed quote **omits the row**
rather than inventing a name for a money line.

## What it does not settle

- **Whether invoicing recomputes the surcharge against actual hours**, and against which subtotal.
  The T&C says the surcharge *"WILL BE APPLIED ON FINAL INVOICES"*, so the quote figure is an
  estimate over estimated hours. Open — `quotations/gaps.md` sub-question (c), owner TCG.
- **Whether a per-resource surcharge column belongs on the quotation editing UI.** That question was
  blocked on this one and is now answerable in isolation — `quotations/gaps.md`, owner product team.
- **The 10% subcontractor markup** — *"ALL SUBCONTRACTORS WILL BE BILLED AT A MINIMUM OF 10% MARK
  UP"* — is unmodelled anywhere and is not part of this decision.

## Implementation

`resolveQuoteSurcharge` in `apps/api/src/usecase/price-listings/price-listings.service.ts` resolves
the single rate and label; `resolveRate` applies it to every line and keeps `applySurcharge` as the
per-line membership test. The printed quote subtracts the surcharge from each line and appends one
named row (`print-quotation.helpers.ts`).

`QuotationResource.finalAmount` still stores the surcharge-inclusive figure. Redefining it reaches
invoicing, so it was left alone — the customer-facing document reconciles without it.

## Related

- [`quotations/quote-terms-and-rate-card.md`](../quotations/quote-terms-and-rate-card.md) §1 — the
  worked arithmetic from quote OM-35140
- [`quotations/billing-code-and-price-list.md`](../quotations/billing-code-and-price-list.md):31-32
  — *"Re-design surcharge placement"*, the only prior vault mention, UI feedback only

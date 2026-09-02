---
title: Quotation resource rates are whole dollars — cents are rejected
source: Jahanzaib Nadeem (in-session decision while fixing quotation resource nesting)
migrated: 2026-08-31
updated: 2026-08-31
status: reference
conflicts_with: []
tags: [module/quotations, module/price-lists, kind/decision, validation]
entities: [QuotationResource, PriceListItem]
---

# Quotation resource rates are whole dollars

Decided by **Jahanzaib Nadeem** on 2026-08-31, when asked whether the existing
whole-number rate rule on the Resources tab was intended or accidental.

## The rule

A resource line's **Rate must be a positive whole number**. A rate carrying cents
(`125.50`) is rejected. This matches price lists, which already enforce the same
constraint on rate entry (`create-price-list-form.tsx`, `price-list-items-card.tsx`),
so the quotation rule is deliberate and stays.

## What was actually wrong

The rule was never the problem — the **message** was. A rate with cents was reported
as `Rate must be greater than 0`, which is plainly false for `125.50` and sent people
looking for the wrong problem. Validation now distinguishes the two cases:

- not a number, or `<= 0` → `Rate must be greater than 0`
- has cents → `Rate must be a whole number (no cents)`

Implemented in `getResourceRateError` in
`apps/web/src/features/quotations/views/create-quotation.helpers.ts`.

## Still open

Whether the **API** should enforce the same rule. Today `rate` is validated only as
`@IsNumber()` on `CreateQuotationResourceDto`, so a non-integer rate submitted by any
client other than the web wizard is accepted and stored in a `Decimal(15,2)` column.
The client rule is therefore a UI convention, not an invariant. Raise before relying
on rate integrality anywhere downstream.

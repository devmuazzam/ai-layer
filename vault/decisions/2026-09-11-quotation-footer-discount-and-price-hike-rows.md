---
title: Quotation resources footer — Discount and Price Hike rows work like the surcharge row — decision
source: decision/Fouzan Shakil
decided: 2026-09-11
decided_by: >-
  Fouzan Shakil (CodingCops), stated 2026-09-11 in a Claude Code review session
  of branch `fix/das-fixes`, in answer to explicit questions. Not a TCG
  client-side product-owner sign-off. Recorded `status: reference` — binding on
  the CodingCops build, open to being overruled by TCG.
status: reference
conflicts_with: []
resolves:
  # part (c), the on-screen half; the printed-quote half stays open
  - quotations/gaps.md#branch-fixdas-fixes--archive-gate-rate-error-precedence-discount-and-price-hike-footer-rows
jira: []
tags: [module/quotations, kind/decision, pricing]
---

# Quotation resources footer: Discount and Price Hike rows, like the surcharge row

## Decision

Fouzan Shakil, 2026-09-11:

1. **Discount** and **Price Hike** are footer rows in the Resources table. They work **exactly
   like the Fuel & Insurance Surcharge row**.
2. **Each resource row's Amount is the amount before any adjustment**, meaning before discount,
   price hike and surcharge:
   - an ordinary line shows **qty × rate**;
   - a **Mob/Demob group parent** shows **the sum of its included children**.
3. **The footer rows carry the adjustment money.** So the Amount column, resource rows plus footer
   rows, **sums to the Total**.
4. This applies on **create/edit** and on the **detail** tab.

## Why

No reason was stated beyond *"exactly like the surcharge row"*. The row it copies comes from
[2026-09-02-one-surcharge-per-quote.md](2026-09-02-one-surcharge-per-quote.md) (`verified`,
Melissa McNutt), which puts the surcharge in one named row above clean line amounts. This extends
the same treatment to discount and hike, so every adjustment is a footer row and no line amount
has an adjustment folded into it.

## Effect on the vault

- **Done (gaps):**
  [`../quotations/gaps.md#branch-fixdas-fixes--archive-gate-rate-error-precedence-discount-and-price-hike-footer-rows`](../quotations/gaps.md#branch-fixdas-fixes--archive-gate-rate-error-precedence-discount-and-price-hike-footer-rows).
  The on-screen half of (c) is resolved. The printed-quote half stays open.

## What this does not settle

- **Whether the printed quote carries Discount and Price Hike rows.** The verified 2026-09-02
  decision settles only the printed surcharge row. TCG's real quote prints Subtotal, surcharge and
  Estimate Total, with no discount or hike row
  ([../quotations/quote-terms-and-rate-card.md](../quotations/quote-terms-and-rate-card.md):50-52,
  `unverified`).
- **Whether discount and hike may both be non-zero on one quote.** This decides whether both rows
  can ever show at once:
  [`../quotations/gaps.md#billing-code-and-price-list-rules-the-e2e-suite-asserts-with-no-written-source--pr-488`](../quotations/gaps.md#billing-code-and-price-list-rules-the-e2e-suite-asserts-with-no-written-source--pr-488)
  (e).
- **Stored fields.** This note covers what the Amount column **shows**. It does not redefine any
  stored field (`amount`, `amountBeforeDiscount`, `finalAmount`).
- **The per-row tooltip, the Surcharged badge and the "Final Amount" label.** Still open at
  [`../quotations/gaps.md#per-row-surcharge-now-has-no-ui-on-createedit-and-final-amount-means-two-different-numbers`](../quotations/gaps.md#per-row-surcharge-now-has-no-ui-on-createedit-and-final-amount-means-two-different-numbers).

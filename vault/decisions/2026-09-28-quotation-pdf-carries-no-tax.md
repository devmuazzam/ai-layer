---
title: The customer-facing quotation PDF prints no tax and no Sales Tax row; its Total equals the on-screen quotation Total, until tax on quotations is decided (Jz-Nd, TCG-51) — decision
source: decision/Jz-Nd (CodingCops developer) — TCG-51, Claude Code session 2026-09-28
decided: 2026-09-28
decided_by: >-
  The developer working Linear ticket TCG-51, git identity "Jz-Nd"
  <jahanzaib.nadeem@codingcops.com>, in a Claude Code session on 2026-09-28,
  choosing option (a) "No tax on PDF" from three options put to them. An
  interim developer ruling on what the PDF does until tax is decided — not a
  product decision on tax. TCG-51 itself says "Should quotes have tax at all?
  If yes, on which amount (before or after discount)? A named person must
  decide." — this note does not answer that. Not confirmed by product: the
  owners of quotation pricing on quotations/gaps.md are Joe Schacatano with
  Melissa McNutt (with Ryan Adams on quotation send), and none of them has
  seen or ratified this. A
  developer ruling, not a TCG sign-off, so `status: reference`: binding on the
  CodingCops build now, open to being overruled by TCG.
status: reference
conflicts_with: []
resolves: []
jira: [TCG-51]
tags: [module/quotations, kind/decision, pricing, signatures]
---

# The customer-facing quotation PDF carries no tax

## Decision

The developer chose the option labelled **"No tax on PDF"**:

1. **The PDF Total equals the on-screen quotation Total.** The customer-facing quotation
   PDF — the document emailed to the customer and wrapped by DocuSign — prints a Total
   computed the same way as the quotation screens: the shared resource totals, group
   children counted once through their parent, unchecked children excluded. **No tax is
   added.**
2. **No "Sales Tax" row.** The row that previously printed on every quote (showing $0.00
   for every web-created quote) is removed.
3. **Taxable quotes lose their tax line on the PDF until tax is decided.** A quote flagged
   `isTaxable` can only be created via the API, seed, import or migration — the web UI has
   no `isTaxable` writer — and such quotes now print no tax either.

Shipped under the same ticket, engineering rather than product: sending, emailing or
resending a quote **no longer rewrites the quotation's stored `subtotal`, `tax` and
`total`**.

## Why

- **UAT reported the mismatch.** The UAT register row *Quotation email PDF shows the wrong
  total* is **NOT DONE**: *"No fix found for the total mismatch between the emailed PDF and
  the quotation on screen"* ([uat/register-2026-09-18.md](../uat/register-2026-09-18.md):224,
  UAT 1, `unverified`). The PDF Total was higher than the screen whenever tax applied.
- **The PDF was the only surface adding tax.** No quotation screen, print view or email body
  shows tax, so the PDF disagreed with everything else the customer or the salesperson sees.
- **The tax it added was computed on the wrong base.** The base counted grouped lines two or
  three times. Canonical fixture from the session: a $1,448 quote produced $231.61 tax at
  9.5%, where 9.5% of $1,448 is $137.56.
- **The three options put to the developer:**
  - (a) no tax on the PDF — **chosen**;
  - (b) keep a $0.00 Sales Tax row but never add tax;
  - (c) keep tax on a corrected base. The PDF would then still disagree with every screen.

  Both (a) and (b) make the PDF Total match the screens. (a) was chosen over (b) because a
  $0.00 Sales Tax row would read to the customer as a decision that no tax applies, and
  nobody has made that decision.
- **Nearby written sources, none of which settles quote tax.** Taken together they show tax
  is a live concern for TCG. Nothing here says TCG does not charge sales tax, so the answer
  to "do quotations carry tax" is **not** presumptively no:
  - TCG's review of FCC's billing-code screens says *"Taxable: Not needed"* (slide 3) and
    *"We don't use/need 'Taxable'"* (slide 10). That is about the per-billing-code flag, not
    whether TCG charges tax or whether a quotation carries it
    ([quotations/billing-code-and-price-list.md](../quotations/billing-code-and-price-list.md):73;
    [quotations/fcc-billing-data-and-price-lists.md](../quotations/fcc-billing-data-and-price-lists.md):383, :389;
    both `unverified`).
  - FCC's Avalara guide says Avalara calculates tax on invoices only: *"Tax calculation on
    Quotes … not available in this release"*. It does not say what a quote uses instead
    ([accounting/avalara-sales-tax-in-nexgen.md](../accounting/avalara-sales-tax-in-nexgen.md):36–40,
    `unverified`, FCC reference rather than a TCG requirement).
  - **Contrary evidence: TCG expects sales tax in some cases.** Two meeting transcripts
    record this. They are statements in meetings, not decisions, and both are `unverified`.
    - 2026-03-20, on the customer *Taxable* field: *"The taxable we don't charge sales tax
      unless it's a. I would keep taxable because if we do bare rentals and stuff, I think
      ideally we're supposed to be charging tax."*
      ([meetings/transcripts/2026-03-20-fcc-fields-screens-review.md](../meetings/transcripts/2026-03-20-fcc-fields-screens-review.md):83)
    - 2026-07-28, in an invoicing discussion that starts from the mechanic / maintenance
      side, Kyle Harlow: *"we should be charging the customer sales tax based on their
      location"* (:133). He also says *"every county and city, well, not everyone, but they
      all have their own sales tax. And that's something we'll have to build out for
      anything that we charge"* (:135). ehtesham.anwar: *"We are going to add that sales tax
      only to tools and rankings that we are billing for the adding within the invoice for
      the customer."* (:142)
      ([meetings/transcripts/2026-07-28-invoicing-details-contracts-certs-trainings.md](../meetings/transcripts/2026-07-28-invoicing-details-contracts-certs-trainings.md))

    Both are about invoices or bare rentals, not the quotation PDF. They do not conflict
    with this interim ruling, which leaves tax undecided rather than deciding against it.

## What this does not settle

Owner of all of these: product. Joe Schacatano owns quotation pricing with Melissa McNutt,
and Ryan Adams owns quotation send. They are open on
[quotations/gaps.md → *Does a quotation carry sales tax at all…*](../quotations/gaps.md#does-a-quotation-carry-sales-tax-at-all-and-if-so-on-which-amount).

- **Whether quotations carry tax at all.** TCG-51 asks this and a named person must answer
  it. This note does not.
- **If they do, on which amount:** the pre-discount subtotal, or the total after discount,
  price hike and surcharge.
- **If they do, whether tax must then appear on the screens, the print view and the email
  body too**, so the PDF is no longer the odd one out.
- **Which number is "the total" at all.** That stays open on
  [*Per-row surcharge now has no UI on create/edit, and "Final Amount" means two different numbers*](../quotations/gaps.md#per-row-surcharge-now-has-no-ui-on-createedit-and-final-amount-means-two-different-numbers)
  and
  [*Q-24 — List and summary disagree on resource-less quotation totals*](../quotations/gaps.md#q-24--list-and-summary-disagree-on-resource-less-quotation-totals).
  This note does not re-raise either.
- **What the stored `tax` column means.** Send no longer rewrites it. Whether a duplicate
  should carry or recompute it stays open on
  [*Quotation duplicate — what a copy carries…*](../quotations/gaps.md#quotation-duplicate--what-a-copy-carries-and-what-a-fresh-copy-resets) (c).
- **Product ratification.** Joe Schacatano / Melissa McNutt / Ryan Adams should confirm or
  overrule this.

## Effect on the vault

- No vault file is verified or superseded, and no frontmatter was changed. Nothing in the
  vault specified tax on the quotation PDF, so there is no winner and no loser.
- No existing `quotations/gaps.md` entry asked whether a quotation is taxable, so a new open
  entry was added there, linking this note:
  [*Does a quotation carry sales tax at all, and if so on which amount?*](../quotations/gaps.md#does-a-quotation-carry-sales-tax-at-all-and-if-so-on-which-amount).
  It stays **open**.
- [uat/register-2026-09-18.md](../uat/register-2026-09-18.md):224 is a verbatim Confluence
  transcription and was not edited.
- `.ai/aidlc/` has no TCG-51 folder, so there is no `spec.md` §12 to hold the question.
- Shipped on branch `fix/misc-fixes-2026-09-25` under TCG-51.

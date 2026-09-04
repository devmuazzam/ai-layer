---
title: Billing code and price ist
source: confluence/TCG/Billing code and price ist; extended 2026-09-04 with shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_MAINTAIN_CODES-BILLING (reviewed by TCG).pptx
migrated: 2026-08-10
updated: 2026-09-04
status: unverified
conflicts_with: [meetings/2026-06-26-discussion-points-with-tcg-team.md]
jira: []
tags: [module/assets, module/quotations, kind/reference, pricing, yards]
entities: [billing-code, yard, price-list, category, fcc]
---

**Billing code**

* FCC

    * GL account
    * auto allocate
    * taxable
    * % Applied
    * billing code type

* Add billing code type CRUD
* For custom – we should be able to re-use same sub categories multiple times

**Price list**

* Discount toggle should not be red
* Rename rate as list rate
* Type should be displayed user friendly way - show sub category on index page
* Re-design surcharge placement
* Apply surcharge heading should be

Should we make billing code and price list specific to yards

or will it be same price for all yards

---

## Added 2026-09-04 — TCG's answers on the FCC billing-code screens

*Source: `1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_MAINTAIN_CODES-BILLING (reviewed by
TCG).pptx` — 14 slides of FCC screenshots with TCG's own margin notes. Full write-up, together
with the FCC import contract and the billing-code catalogue, is in
[fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md).*

**The closing question on this page is answered — half of it.** The page ends:

> *"Should we make billing code and price list specific to yards, or will it be same price for all
> yards"*

TCG states the answer twice on these slides, on slides 3 and 8:

> **"Billing Codes per Yard: Need to have ability to have separate Billing Codes per Yard."**

**Nothing on the slides says anything about price lists per yard**, so the second half of the
question is still open. (FCC does scope *billing costs* by yard — `Yards` is a column on the
Billing Costs tab, [quote-profit-forecast.md](quote-profit-forecast.md) §2 — so the pattern
exists in the product.)

**Three of the FCC fields listed above are rejected by TCG:**

| This page lists | TCG's note on the screens |
| --- | --- |
| `taxable` | *"**Taxable: Not needed**"* (slide 3) and *"We don't use/need 'Taxable'"* (slide 10) |
| — | *"We don't use/need these **'Exceptions'**"* (slide 7) |
| — | *"We don't use/need these **'Billing Costs'**"* (slide 9) |

`GL account`, `auto allocate` and `% Applied` are all real columns on FCC's billing-code import
contract and are **not** rejected — see
[fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §1. `% Applied` in
particular is the surcharge-base flag, which is what Melissa asked for as *"a % applied for
surcharges"* in the ERP review log ([erp-review-log.md](../erp-review-log.md) → *#10*).

**Two new asks appear on the same slides and are recorded nowhere else in the vault:**

- **Burden Codes**, *"to track overhead expenses per billable labor hour"*, with **effective-dated
  changes that can be backdated** and reporting that can be filtered by burden rate.
- **Detailed information on Pending Quotes** alongside the existing Lost Quote statuses,
  *"so we can follow-up and will eventually be marked as 'Won' or 'Lost'"*.

Both are transcribed in full in
[fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §5.

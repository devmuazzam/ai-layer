---
title: New Customer Packet — what TCG sends a first-time customer
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/New Customer Packet 10-23-2025_1[70].pdf
migrated: 2026-09-04
updated: 2025-10-23
status: unverified
conflicts_with: []
jira: []
tags: [module/customers, module/accounting, kind/source, requirements, compliance, invoicing, pricing]
entities: []
---

# New Customer Packet — what TCG sends a first-time customer

**What this is.** TCG's actual onboarding packet, dated **2025-10-23**, filed under
`TCG_FORMS_(paper_and_electronic)`. It is the bundle a first-time customer receives: a welcome
letter stating the payment terms, three forms to fill in and return, a lien-notice information
request, TCG's W-9, and marketing collateral. It matters to the customers module because it is the
only source in the drop that says **what TCG collects from a customer before the first job**, and
because the ERP already has a `preQuoteData` JSON blob on `Customer` waiting to hold something of
this shape.

**The packet is a paper/PDF process.** Nothing in it says any of this should be, or is being,
built into the ERP. Two other vault sources want it automated — see *Where this connects* below —
but the packet itself is just the forms.

Several forms collect credit-card numbers, security codes, bank account numbers and personal
guarantor details. **Those fields are described here, never their values** — the packet is a blank
template, but treat any filled copy as sensitive. TCG's own federal tax ID appears on the W-9 and
is deliberately not transcribed.

## The stated commercial terms for a new customer

From the welcome letter, verbatim in substance:

- A **50% deposit** is required for the first job, with the remaining balance on **COD terms**.
- Payment on-site by **cash, check, ACH or credit card**.
- After the job, the customer receives the final invoice **by email through QuickBooks** for review
  and approval.
- The customer replies to that email either authorising TCG to run the card on file, or naming one
  of the other payment methods.
- **If no response within 24 hours** of the invoice being sent, TCG processes payment using the
  card on file.
- Before the scheduled lift, the customer must return: the **credit application**, the **credit
  card authorization form**, and a **signed copy of the quote**. The letter's stated reason is
  "this will allow us to enter you into our system and dispatch the crane accordingly."
- A footnote asks the customer to add a different contact to the email thread if invoice approval
  belongs to someone else.

That last clause is the packet's own version of the Ordered-By / Report-To / billing-contact
distinction the rest of the module models structurally.

The credit application's terms-and-conditions block adds two more:

- "Agrees all accounts are **COD until a credit application has been completed, reviewed, and
  approved**."
- Unpaid balances bear interest at **the lesser of 1.5% per month or the maximum rate permitted by
  applicable law**, and the signer personally agrees to pay collection costs including attorney's
  fees.

And the credit card authorization adds a **3% service fee for each use of a credit card**.

None of these is stated anywhere as an ERP rule. They are the paper policy as of 2025-10-23.

## What each form collects

### Credit Card Authorization

Company name · address / city / state / zip · e-mail · phone · fax · **contractor license #** ·
**union affiliation (Y/N)** · card type · name on card · company name on card · card billing
address · state/province · zip · billing phone · **card number** · **expiration date** ·
**security code** · authorised-by name · signature · date. Plus three invoice-number /
amount-of-charge pairs at the foot, for recording individual charges against the authorisation.

[card number, expiry and security code are collected by the source form — deliberately not
represented as fields to be stored anywhere; see the source PDF]

### Credit Application

- **General:** company name · address · state/province/zip · **e-mail for processing invoices**
  (distinct from the company e-mail) · phone · fax · date of application · **federal tax ID** ·
  **state of corporation** · **company composition** — Individual / Partnership / LLC /
  Corporation / Sub-Chapter S Corp · **union affiliation (Y/N)** and name of union.
- **Principals/owners:** two blocks, each name / address / state-province-zip / phone / e-mail.
- **Bank:** bank name · bank contact and number · bank address · **type of account and account
  number**.
- **Trade references:** two blocks, each name / address / state-province-zip / phone and fax /
  e-mail / relationship / years known / type of account / account number.
- **Signature:** name · title · signature · date.

The company-composition list and the union-affiliation flag are the two enumerations here that
have no counterpart anywhere in the FCC schema or the ERP's `Customer` model.

### Deposit Form

Customer name · date of job · **quote #** · sales representative name · job address ·
**prevailing wage (Y/N)** · method of payment (credit card / check / ACH — "for ACH please call
for account information").

This form ties a customer to a **quote number** and a **job address**, and carries the
**prevailing wage** flag at the point of deposit.

### Preliminary Notice Information Request Form

The California mechanics-lien preliminary-notice data set. Customer name · date · **job #** ·
**P.O. #** · **prevailing wage (Y/N)**, then four name/address/phone blocks:

- **Job information**
- **Owner**
- **Original contractor**
- **Sub-contractor** — annotated *"( Our Customer )"*

That annotation is the useful part: on a preliminary notice TCG's own customer is the
**sub-contractor**, and the owner and original contractor are third parties TCG must record per
job. Nothing in the FCC customer schema or the ERP's `Customer` / `JobSite` models holds an owner
or original contractor. This is also the counterpart to the `Do Not Pre Lien` free-text field
found on 82 QuickBooks customers — see
[quickbooks-customer-table-audit.md](quickbooks-customer-table-audit.md).

### IRS Form W-9

TCG's own completed W-9 (Rev. March 2024), classification LLC / S corporation, signed 2025-01-08 —
supplied *to* the customer, not collected from them.
[TCG's employer identification number appears on the form — deliberately not copied; see the
source PDF.]

## The collateral, and the rate minimums in it

The packet closes with TCG's capability statement and a services/rates sheet. Most of it is
marketing, but two parts are factual and referenced by other modules.

**Registration identifiers on the capability statement:** CA contractor licence #967520 ·
NAICS codes **238990** (all other specialty trade contractors), **484110** (general freight
trucking, local) and **532412** (construction, mining and forestry machinery/equipment rental) ·
ISNetworld # · CAGE code · DUNS number. Also: Woman Owned, Small Business, and Local Small
Business Enterprise; family-owned since 2006; EMR of 0.58.

**Hour minimums by equipment class**, from the rate sheet — the customer-facing statement of the
same minimums the quotation module prices against:

| Equipment | Minimum |
| --- | --- |
| 22 Ton Boom Truck | **3 hour** |
| 30 / 35 Ton Self Loader, 40 Ton Boom Truck | 4 hour |
| 45–500 Ton Truck and All Terrain Cranes (45, 60, 75, 90, 100, 110, 120, 140, 175, 200, 265, 275, 500) | 4 hour |
| 90 Ton Rough Terrain Crane | *(no minimum printed)* |
| All trucking — 12'/26' flat bed, 20'/30'/40'/45'/48' trailer, 48' drop deck, 48'–68' stretch deck, 65 ton lowboy | 4 hour |

The **22-ton boom truck's 3-hour minimum is the only exception** to a flat 4-hour minimum across
the whole fleet. The sheet does not say whether the minimum is billable time, on-site time, or
portal-to-portal.

Services listed as chargeable alongside the crane: qualified riggers and signal persons ("at an
additional cost"), 3-D lift plans, **city permit processing**, **FAA permit processing**,
integrated traffic control, local and long-haul trucking, on-site secured storage, scrap metal
removal, suspended and fixed personnel platforms (1 to 6 persons), spreader bars.

## Where this connects

- **`Customer.preQuoteData`** in `apps/api/prisma/schema.prisma` is a JSON column with a
  `preQuoteDataCompletedAt` timestamp, commented *"Pre-Quote Data (compliance / onboarding) …
  stored as JSON so the field set can evolve without extra migrations"*. The packet is the paper
  version of exactly that stage. **The schema comment does not name the fields and this packet is
  not cited as their source** — whether they correspond is unverified.
- **[erp-review-log.md](../erp-review-log.md) entry #3** (Melissa, Accounting, 2026-04-02) asks for
  **automatic customer packet generation**: a per-customer packet template that assembles the right
  documents automatically, plus customer-specific extra forms. That entry's "attached sample
  packets" are presumably relatives of this file.
- **[customer-and-job-sites.md](customer-and-job-sites.md)** item 3 asks TCG to "provide pre quote
  form -- we need to assicate this data with customers". This packet is a candidate for what that
  form is; no source says it is.
- **[customer-onboarding-flow-chart.md](customer-onboarding-flow-chart.md)** is the internal
  process around this packet — who chases it, and the credit-vs-COD decision it gates.
- The **prevailing-wage** flag appears on two of the four forms and is a payroll concern — see the
  certified-payroll material under `payroll/`.

## Source

`1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/New Customer Packet
10-23-2025_1[70].pdf` — converted with `pdftotext -layout`, 472 lines of text across roughly a
dozen printed pages. The PDF has a full text layer; no OCR was needed. Blank form fields
throughout — nothing was filled in except TCG's own W-9 and capability statement.
**Credit-card, bank-account and tax-identifier fields exist on the source forms and their values
were not transcribed** (the template is blank; TCG's own EIN on the W-9 was omitted deliberately).

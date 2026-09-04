---
title: Avalara sales tax in NexGen — setup and per-invoice behaviour
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/NexGen_Avalara_Setup_User_Guide_v3.0.pdf
migrated: 2026-09-04
updated: 2024-07-01
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, module/customers, module/assets, kind/reference, invoicing, integrations, compliance, geolocation, reference-data]
entities: []
---

# Avalara sales tax in NexGen — setup and per-invoice behaviour

**What this is.** Fleet Cost & Care's *Avalara Setup and User Guide*, v3.0, **July 2024**,
covering the AvaTax integration available in **NexGen 2024.1**. Avalara is a third-party sales-tax
engine; the guide documents how NexGen is configured to call it and what happens on each invoice.

**Why it matters.** Sales-tax management is on the accounting wishlist
([2026-07-accounting-team-erp-wishlist.md](2026-07-accounting-team-erp-wishlist.md)), TCG bills
across many California jurisdictions, and this is the only document in the vault describing how
tax is actually calculated on an invoice. It also introduces a **hard dependency on validated
job-site addresses** that reaches straight into the customers and field-ops modules.

> **Availability is not use.** The guide describes a capability of NexGen 2024.1. **Nothing in
> this drop says whether TCG has Avalara switched on.** The guide is explicit that without
> credentials the system silently falls back: *"if the fields have not been filled in, NexGen
> will default to the native tax engine for calculating taxes on invoices."* None of the six
> real invoices in this drop carries a tax line
> ([invoice-packets-2026-04-worked-examples.md](invoice-packets-2026-04-worked-examples.md)) —
> which is consistent with tax-exempt or non-taxable billing, and settles nothing.

## Scope in 2024.1

> *"Within the 2024.1 Avalara is only available for calculating invoices specifically on
> Invoices. **Tax calculation on Quotes and the P2P functions are not available in this release**
> and are planned for future releases."*

So a quote's tax figure and an invoice's tax figure come from different engines. The guide does
not say what a quote uses instead.

**Enhancements listed for 2024.1**, verbatim: disable editing of the invoice number on all
invoices after the initial tax call; pass **Yard code** to Avalara on all invoice tax calls;
**require the yard address to be present** when making invoice tax calls; pass the **Purchase
Order** field to Avalara.

## Setup, in the order the guide gives it

| Where | What is set |
| --- | --- |
| `Admin → Set System Defaults → Features` | turn AvaTax integration on |
| `… → AvaTax Configuration` | **Post and Commit transactions** — *"if not selected, Avalara will still calculate taxes but will not store the invoice to tax information in its system"* · **Default Freight Tax Code** *(future use; leave blank — NexGen needs a separate billing code and Avalara item tax code for freight)* · **Default Labor Code** — the Avalara item tax code defaulted onto service-invoice labor lines, overridable per invoice · **Enable logging** — API calls and responses, **retained 10 days** · **Enable address validation** |
| Company record → **AvaTax** tab | URL, Account, **License Key**, company code, with a connection test. *"If a specific company does not have credentials completed, the Avalara tax engine will not be called."* |
| `Maintain → Codes → Sales Tax` | a NexGen Sales Tax Code flagged as an **Avalara Tax Code**. State designation *"does not matter but is required"*. One Sales Tax Item beneath it, requiring **Description**, **GL Account**, **Status = Active**, **Use Tax = No** |
| `Maintain → Customers → Avalara Entity Use Code` | a user-maintained table of **entity use codes** — *"codes Avalara will use to identify if a customer is Tax exempt"*. Codes are supplied by Avalara |
| Customer record | select the **Avalara Entity Use Description**; null is valid. Also an **Inter-Company** checkbox — *"Avalara uses this during its tax calculations"* |
| Customer job site | entity use code **defaults from the customer** and can be overridden per site |
| Billing codes / parts / activity codes | an **Avalara item tax code** per record where it is not fully taxable tangible personal property |
| `Maintain → Resources → Units` (Buy/Sell tab) | **Apply SMM Tax**, **Accelerated Tax Paid**, **Heavy Machinery**, **Texas Terp Eligible** |
| Job schedule | **Job date unknown** checkbox — *"to let Avalara know if there is no known end date to the rental job"* |

*(Credentials — URL, account, licence key — are configuration fields described by the guide; no
values appear in any file in this drop.)*

## The default that decides everything

> *"By default, if a billing code does not have an Avalara Tax ID associated with it in NexGen,
> **Avalara will treat the item as fully taxable tangible personal property and use an item tax
> code `P0000000`.**"*

The same sentence is repeated verbatim for **parts** and for **activity codes**. And for
order-based invoices: *"All non-part number items will be treated as fully taxable if the
customer is not exempt."*

**The fail-open default is "fully taxable".** Every billing code that is not fully taxable
tangible personal property — every crane-hour, operator-hour, permit pass-through and surcharge
line on a real invoice — must carry an explicit Avalara item tax code, *"identified by the user
and the Avalara implementation consultant"*, or it will be taxed as goods. The guide adds one
further requirement: *"For Billing codes that require an operator to be provided, they will need
to be identified on the Billing Code record."*

## Address validation — the gate

Sales tax is sourced from the **customer job site address**, and NexGen will not calculate tax
against an unvalidated one.

> *"When sending an invoice to Avalara for tax calculation, if the job site address has not been
> validated, the user will receive a message and will be instructed to validate the job site
> address before Avalara calculates taxes."*

The exceptions the guide names: **customer pickup of parts at a yard**, and **job-storage
invoices** where goods are stored at the yard — both of which use the **yard address** instead,
selected by a `customer pickup` checkbox on the invoice.

How validation behaves:

- A job site **created in Atom** appears in NexGen with a **validate button** at the bottom of
  the screen. Pressing it calls Avalara, which returns the original address beside a
  *recommended Avalara-formatted address*. The user chooses **Keep original address** or **Use
  validated address**, and the choice is written into a **Validation Status** field. If the
  address cannot be validated, Avalara returns a message and that too is recorded in the status
  field. *"The validation button will disappear after the initial call."*
- A job site **created directly in NexGen** validates **on save** instead, with no separate
  button. Editing the address and saving triggers a fresh validation call.
- An **Address Unknown** checkbox lets the user enter **longitude and latitude** instead;
  address validation then does not occur. Atom has the same checkbox.
- **Yard addresses are not automatically validated in this release** — *"User will need to make
  sure the address loaded into NexGen for each Yard record is the valid address."*

This is a direct dependency of the accounting system on data captured in the field. Atom-created
job sites arrive unvalidated by construction, and someone must resolve each one before the
invoice can be taxed. Job sites are a customers-module concern
([../customers/customer-and-job-sites.md](../customers/customer-and-job-sites.md)); the
Atom-created path is field-ops.

## What happens per invoice

The same six-step sequence is documented for **WPF invoices**, **legacy rental invoices**,
**parts invoices**, **invoices from orders**, **parts job invoices** and **legacy service
invoices** — identically:

1. On **Save**, NexGen calls Avalara. The job-site address must already be validated (or, for
   customer pickup, the yard address is used).
2. NexGen sends **address, billing codes, quantities, unit price, entity use code, item tax
   code**.
3. Avalara calculates and returns the tax.
4. **Tax is stored at the line level and in the invoice header.**
5. *"The process can be repeated as many times as the user wants **up until the invoice is
   exported**."*
6. **Once an invoice has been sent to Avalara for initial tax calculation, the invoice number
   field is locked from editing.**

On **export**: one final call to Avalara; Avalara calculates and **commits the transaction on
its side**; final tax comes back at line and header level; and *"Invoice will be locked down in
NexGen from exporting process."*

On **delete before export**: *"A call will be made to Avalara to void the uncommitted
transaction on its side."*

> **Step 6 is the invoice-number immutability the QBO checklist asks for — but only when Avalara
> is on.** TCG's connector review names editable invoice numbers as *"the root of your mismatch
> pain"* and recommends locking them
> ([nexgen-quickbooks-integration/02-integration-review-checklist.md](nexgen-quickbooks-integration/02-integration-review-checklist.md)).
> This guide shows NexGen already enforcing exactly that lock — as a **side effect of the first
> Avalara tax call**. Whether TCG gets that lock therefore depends on whether Avalara is
> enabled, which no source in this drop establishes. Worth putting to the client directly.

## What the guide does not cover

Quotes and procure-to-pay (out of scope in 2024.1), how NexGen's **native** tax engine works
when Avalara is off, how the calculated tax reaches QuickBooks (the connector mapping has no
tax field —
[nexgen-quickbooks-integration/01-fcc-connector-field-mapping.md](nexgen-quickbooks-integration/01-fcc-connector-field-mapping.md)),
exemption-certificate handling beyond the entity-use-code selector, and any list of actual
Avalara item tax codes beyond the `P0000000` default.

## Source

`1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/NexGen_Avalara_Setup_User_Guide_v3.0.pdf` — 32
pages, `pdftotext -layout`. Screenshot-led throughout: several sections consist of a caption and
an image, so field labels are captured where the caption names them and the screenshots' own
contents were not reconstructed.

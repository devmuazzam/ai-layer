---
title: QuickBooks Online setup for the FCC connector — account numbers and items
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/QuickBooks Online Billing Codes and GL Accounts.pdf and QuickBooks Online Enabling Chart of Account Numbers v.9.25.pdf
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, module/quotations, kind/sop, integrations, invoicing, pricing, reference-data]
entities: []
---

# QuickBooks Online setup for the FCC connector — account numbers and items

**What this is.** Two very short FCC-supplied setup sheets, both screenshot-led with only a few
lines of instruction text. They cover the **QuickBooks-side** configuration the connector
assumes: turning on account numbers, and creating a QuickBooks Service item for every NexGen
billing code. `v.9.25` in the second filename is a September-2025 version stamp.

**Why it matters.** Small documents, one load-bearing rule: **QuickBooks Product/Service names
must match NexGen billing-code names exactly**, by copy-and-paste. That is a hand-maintained
string join between the pricing catalogue and the accounting system, and it is stated nowhere
else in the vault.

## Enabling chart-of-account numbers

Four steps, verbatim in substance:

1. Settings gear, top right in QuickBooks Online
2. **Account and Settings**
3. **Advanced**
4. Set **"Enable account numbers"** to On, under **Chart of accounts**

## Billing codes → QuickBooks items

The rules the sheet states, each quoted or close-paraphrased:

- Account numbers are set up **by the user**, in QBO, under Settings → Advanced → Chart of
  accounts.
- *"Customers/Vendors Only Name sync over Account numbers are behind the scenes. **No account
  numbers will be seen in Online Version.**"* — the `AccountNumber` field the connector writes
  `CustCode`/`VendorCode` into ([01-fcc-connector-field-mapping.md](01-fcc-connector-field-mapping.md))
  is **not visible in the QuickBooks Online UI**. It is there, and staff cannot see it.
- *"Billing code name copy over only **Revenue accounts not expense accounts**. **No GL number
  comes over.**"*
- Items are created under Settings gear → **Products and Services** → **Service**.
- ***"Billing Codes Needs to Match Product/Services Name Exactly. Just copy and paste from
  NexGen Billing Codes."***

## What this means in practice

Three consequences, each stated only as far as the documents support:

1. **The billing-code ↔ item join is a string match maintained by hand.** A renamed billing
   code in NexGen breaks it silently. The documents give no validation step, no report, and no
   direction of authority beyond "copy and paste from NexGen".
2. **Only revenue-side billing codes get items.** Expense accounts are excluded, and no GL
   number crosses with the name — which is consistent with, and part of the reason for, the
   `GLLINK`-populated-on-export behaviour described in
   [01-fcc-connector-field-mapping.md](01-fcc-connector-field-mapping.md).
3. **QuickBooks Online hides the field the integration keys on.** Anyone auditing the customer
   or vendor record in the QBO UI cannot see the NexGen code it carries.

The billing codes in question are the customer-facing ones visible on real invoices —
`200 Ton Crane`, `Operator Load`, `Fuel & Insurance Surcharge`, `Edison Support Vehicles
Counterweight Load`
([../invoice-packets-2026-04-worked-examples.md](../invoice-packets-2026-04-worked-examples.md)).
Their maintenance in NexGen is described in
[../fcc-invoicing-in-nexgen.md](../fcc-invoicing-in-nexgen.md); the vault's billing-code page is
[../../quotations/billing-code-and-price-list.md](../../quotations/billing-code-and-price-list.md).

**Neither document says** how many items exist, who maintains them, what happens when a billing
code is added, or whether anyone reconciles the two lists.

## Source

- `1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/QuickBooks Online Billing Codes and GL Accounts.pdf` — 2 pages, `pdftotext -layout`. Almost entirely annotated screenshots; the extracted text above is essentially the whole of the prose.
- `…/QuickBooks Online Enabling Chart of Account Numbers v.9.25.pdf` — 1 page, same conversion.

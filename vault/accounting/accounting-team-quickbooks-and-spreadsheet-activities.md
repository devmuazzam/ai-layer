---
title: Accounting team activities — who does what in QuickBooks, Excel and OneDrive
source: shared-folder/Project-Repository-2026-09-04/3.8.1_MODULE-ACCOUNTING-AP-AR/__Accounting activities.txt
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, kind/source, invoicing, reporting, purchase-orders, permits, requirements]
entities: []
---

# Accounting team activities — who does what in QuickBooks, Excel and OneDrive

**What this is.** A client message to CodingCops, sent with the `3.8.1_MODULE-ACCOUNTING-AP-AR`
archive of the 2026-09-04 Project Repository drop. It is the accounting team's own list, person
by person, of **what they actually do in QuickBooks**, plus a named inventory of the **Excel
sheets** and **OneDrive folders** the department runs on. It is undated. The covering line says
copies of the artefacts are still being gathered: *"we are working on collecting copies of
things mentioned in the list below."*

**Why it matters.** Every prior accounting source in the vault is a meeting or a wishlist. This
is the first written **inventory of the current-state tooling** — and the spreadsheets it names
are the shadow systems any accounting-side reporting has to either read or replace.

> ## ⚠️ The 3.8.1 accounting archive arrived truncated — re-request it
>
> The `3.8.1_MODULE-ACCOUNTING-AP-AR` archive in this drop contained **only this text file**,
> plus an **empty `AR - Billing Processes/Ariba/` folder** and a partial video. The archive is
> named for the AP/AR module and contains no AP/AR module content: no billing-process
> documents, nothing under Ariba, no SOPs, no reports. **The folder structure survived; the
> files did not.**
>
> Two things follow. First, **the empty `AR - Billing Processes/Ariba/` path is itself
> evidence** — TCG has an Ariba-based AR billing process (Ariba is SAP's supplier network,
> used by large customers to receive supplier invoices) that is documented *somewhere*, and no
> other source in this vault mentions Ariba at all. Second, **everything else this archive
> should have carried is missing and must be re-requested from the client** before the
> accounting module is specified. Do not treat the absence as "there is nothing there".

---

## QuickBooks — by person

Four named people, verbatim in substance from the list.

### Kaitlin

- Adding credit memos
- Marking invoices paid
- **Creating invoices for RCS (Roadway Construction Services) travel permits that are not tied
  to a specific job in FCC** (Fleet Cost & Care FCC-NexGen)

That third item is the one with teeth: it is an invoice that **originates in QuickBooks, not in
FCC**, because the charge has no job to hang off. It is also the same RCS permit traffic that
appears as a pass-through line on real invoices
([invoice-packets-2026-04-worked-examples.md](invoice-packets-2026-04-worked-examples.md)).

### Sammy

- Bank transaction matching
- Reconciling bank accounts
- Running reports for AR/AP
- Running reports for month-end items
- Chart of accounts, to verify reconciliations are correct
- Balance Sheet
- P&L (Profit and Loss) sheet
- Bank Deposit, after marking items paid, to make sure it matches the bank *(the list notes
  "Tia uses it more")*
- The QuickBooks search engine, to research any transaction

### Tia

- Aging report
- Record payments
- Match Sammy's deposit
- Send invoices & statements

### Sam

- **Inputting invoices that don't require a Purchase Order** (the list names SC Fuels, Islas
  Tires, Samsara as examples)
- **Attaching the invoice PDF to invoices imported from FCC**
- Bank transactions for matching
- **Batch transactions when inputting payroll checks**
- Reports: chart of accounts, **to add General Ledger codes to match FCC**; AP aging, for
  reconciliation of accounts
- The search engine, when researching invoices and checks

> **Sam's chart-of-accounts line is a partial answer to an open question.** The GL gap
> ([gaps.md](gaps.md#gl-codes--fccerp-chart-vs-quickbooks-and-who-owns-the-mapping)) asks
> whether FCC's GL codes and QuickBooks's chart of accounts are the same list, a mapped pair,
> or independent. This message says a person runs the QuickBooks chart of accounts report
> **"to add General Ledger codes to match FCC"** — i.e. they are two lists, kept aligned by
> hand, with QuickBooks the one being edited. That is consistent with the connector
> documentation, which has **no GL sync** and populates the link opportunistically
> ([nexgen-quickbooks-integration/INDEX.md](nexgen-quickbooks-integration/INDEX.md)). It does
> **not** say who owns the mapping or which list is authoritative when they disagree — the gap
> stays open.

**The four-person split is itself a finding.** Credit memos and invoice status (Kaitlin),
reconciliation and financial statements (Sammy), cash application and customer-facing sends
(Tia), AP entry and GL alignment (Sam). Any permissions model for an accounting module has this
shape to answer to; the message does not name roles or titles, only tasks.

---

## The Excel sheets

Fifteen entries as listed. This is the shadow-system inventory.

| Sheet | What the list says it is for |
| --- | --- |
| Working collections sheet | track all vendor invoices and what's been paid |
| SCE cash forecasting | shows Southern California Edison's projected payments |
| Vendor permit sheet | track what vendor invoices we need for each job |
| AR cashflow daily check-in | *(no description given)* |
| Budget Tracker | based off P&L reporting |
| Roll Sheet | track outstanding payroll |
| Cashflow Tracker | tracking all payments needed / payments received |
| Expense Sheets | — |
| Sales Expense Sheets | — |
| Monthly close sheet | — |
| Vendor permit list | — |
| Owner expense – Amex | — |
| Roll sheet *(listed twice)* | — |
| Business licenses | Excel **and** OneDrive |
| Outstanding checks sheet | — |

Notes on the list as written: **"Roll Sheet" appears twice** and **"Vendor permit sheet" and
"Vendor permit list" are listed as separate items** — the message does not say whether these
are duplicates or genuinely distinct artefacts.

Three of these already have a foothold in the vault:

- **AR cashflow daily check-in** is the *AR Cash Flow Daily Check-In KPI spreadsheet* named in
  the 2026-08-28 walkthrough as the place recorded payments are re-entered to drive cash
  forecasting and collections
  ([../meetings/2026-08-28-accounting-process-discussion.md](../meetings/2026-08-28-accounting-process-discussion.md)).
- **SCE cash forecasting** matches the *"We're only tracking Edison on an Excel"* remark
  Melissa McNutt made on 2026-07-29, cited in
  [gaps.md](gaps.md#project-detail-accounting-tab--what-it-shows-and-what-it-shows-before-the-module-exists).
- **Roll Sheet — "track outstanding payroll"** is an accounting-side payroll artefact not
  previously named anywhere in the vault, payroll register included.

The rest — Budget Tracker, Cashflow Tracker, Monthly close, Owner expense Amex, Outstanding
checks, Expense/Sales Expense sheets, Business licenses — are **new to the vault**. They map
one-for-one onto asks already on the accounting wishlist (budgeting, cash-flow forecasting,
digital expense reports, credit-card integration, month-end close), which is worth saying
plainly: **the wishlist items are not aspirational features, they are descriptions of
spreadsheets that already exist**
([2026-07-accounting-team-erp-wishlist.md](2026-07-accounting-team-erp-wishlist.md)).

## OneDrive

Four folders:

- Receivers PO (Purchase Order) requests
- RCS invoices
- Receivers
- Business licenses

Consistent with the 2026-08-28 statement that *"invoices are received through shared OneDrive
folders"*. **"Receivers"** and **"Receivers PO requests"** are the receiving side of the
PO/voucher process; the message does not define the term, and no vault source does either.

---

## What this source does *not* say

Deliberately listed, because the temptation to fill these in is strong:

- No frequency, owner-of-record, or retention for any sheet.
- No statement that any of this **should** move into the ERP. The message is an inventory
  supplied on request, not a requirement.
- No description of the Ariba AR billing process the (empty) folder implies.
- No column structures, no sample rows, no file paths — *"we are working on collecting copies"*.

## Source

`3.8.1_MODULE-ACCOUNTING-AP-AR/__Accounting activities.txt` — plain text, 2.1 KB, copied as-is.
The rest of that archive (`AR - Billing Processes/Ariba/`, and a partial video) carried **no
extractable content**; see the banner above.

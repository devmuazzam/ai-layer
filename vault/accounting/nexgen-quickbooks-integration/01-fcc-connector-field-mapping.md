---
title: FCC connector field mapping — NexGen to QuickBooks, as built
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/QB_Connector/External Quickbooks Online Integration.pdf
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, module/payroll, module/vendors-agencies, kind/reference, integrations, invoicing, architecture, reference-data]
entities: []
---

# FCC connector field mapping — NexGen → QuickBooks, as built

**What this is.** Fleet Cost & Care's own product document, *"Accounting Integration –
QuickBooks"*, 8 pages, undated. It is the vendor's field-by-field statement of what the NexGen
→ QuickBooks connector writes, and the only description of the current seam that comes from the
system's builder rather than from TCG. It was **attached by FCC support to case 39995** in
November 2025 ([05-case-39995-data-sync-incident.md](05-case-39995-data-sync-incident.md)).

Everything below is the document's content. Where it is silent, that is said.

## Preconditions the document states

- **Touch points:** Customer · Invoices · Employee · Labor Payroll · Vendor · Vouchers ·
  GL Account Check. Nothing else.
- **QODBC is mandatory:** *"QODBC Driver to be purchased by the customers since this
  integration works with QODBC only."* Separate drivers for QuickBooks Pro/Premier, Enterprise
  (Advanced Inventory) and **QuickBooks Online**.
- **One company per database:** *"Multiple company setup in QuickBooks requires separate
  instances of NexGen database per company given the integration challenges related to
  supporting multiple companies."*
- The section headed *"Business Rules/Customizations"* in the table of contents is **empty in
  the document** — the heading exists, the content does not.

## The mappings

Direction is NexGen → QuickBooks throughout unless noted. `ListID` is QuickBooks's internal
key for a list record; `TxnID` for a transaction.

### Customer

| QuickBooks | NexGen |
| --- | --- |
| `List ID` | *(QB primary key)* |
| `AccountNumber` | `CustCode` |
| `Name`, `CompanyName` | `Name1` *(both from the same field)* |
| `IsActive` | `Status = 'A'` or `'I'` → 1 or 0 |
| `BillAddressAddr1–4` | `Name1`, `Name2`, `Address1`, `Address2` |
| `BillAddressCity/State/PostalCode/Country` | `City`, `StateCode`, `Zip`, `Country` |
| `Contact` | `BillContact1` |
| `Phone`, `Fax`, `Email` | `Phone`, `Fax`, `Email` |
| `CreditLimit` | `CreditLimit` |
| `TermsRefListID` | `ListID` from the `TERMS` table |

**The address lines are offset by two.** `BillAddressAddr1` receives the *customer name*, not a
street — the street lands in `Addr3`. That is what the document says.

### Invoice header

| QuickBooks | NexGen |
| --- | --- |
| `CustomerRefListID` | *(QB primary key)* |
| `ARAccountRefListID` | Company screen A/R GL Account (`GLLink`, `FMS_GL_ACCOUNTS`) |
| `TxnDate` | Invoice Date |
| `RefNumber` | **Invoice Code** |
| `SalesRepRefListID` | Salesperson |
| `IsPending` | hard-coded `'0'` |
| `DueDate` | Due Date |
| `IsToBePrinted` | hard-coded `'0'` |
| `PONumber` | `PoNumb` |
| `TermsRefListID` | Term ID from Invoices, reverse-lookup `ListID` in QB |

### Invoice line

| QuickBooks | NexGen |
| --- | --- |
| `InvoiceLineItemRefListID` | *(QB primary key)* — **Final GL Account** |
| `InvoiceLineRate` | **hard-coded `1`** |
| `InvoiceLineAmount` | `Amount` from `FMS_VW_INVOICE_EXPORT` |
| `FQSaveToCache` | `1` |

> **This is the single most consequential line in the document.** There is **no item, no
> quantity, no unit of measure and no description** in the invoice-line mapping. Rate is
> literally `1` and the whole line value sits in Amount. Everything the printed invoice shows —
> `Edison 275 Ton, 13.00 Hours, $335.00`
> ([../invoice-packets-2026-04-worked-examples.md](../invoice-packets-2026-04-worked-examples.md))
> — collapses to a single GL-coded dollar figure on the QuickBooks side. Revenue can be read by
> GL account and by customer; **it cannot be read by billing code, by crane, by hour, or by
> job.**

### Credit memo / credit-memo line

Mirrors the invoice exactly, with two differences: `CustomerRefListID` comes from the **Cust
Code on the invoice**, and `SalesRepRefListID` is described as a **name-based lookup** —
*"Lookup sales rep List ID using the Sales Rep names from NexGen and pass it back to QB."*
`CreditMemoLineRate` is likewise `1`; the account comes from `ARGLLINK`.

### Employee

Synced from NexGen, `AccountNumber` ← Employee Code. Fields: `FirstName`, `MiddleName`,
`LastName`, address, `PrintAs`, `Phone`, **`SSN` (XXX-XX-XXXX format)**, `Email`, `HiredDate` ←
Start Date, `BirthDate` ← Birth Date.

Two notes the document makes itself:

- **The name mapping is visibly wrong as printed:** `MiddleName ← Fname + Mname` and
  `LastName ← Fname + Lname`.
- *"This sync process would be disabled if the external payroll systems like ADP or PayChecks
  is enabled."* — TCG runs ADP
  ([../../decisions/2026-06-30-adp-erp-employee-data-ownership.md](../../decisions/2026-06-30-adp-erp-employee-data-ownership.md)),
  so **whether this sync runs at TCG at all is not established by this document**.
- `PayrollInfoUseTimeDataToCreatePaychecks` is annotated *"Not available in QuickBooks
  Online."*

**SSN is a mapped field.** No actual values appear in any document in this drop; the fact that
the field is in the contract is the finding. TCG's own checklist flags it — see
[02-integration-review-checklist.md](02-integration-review-checklist.md).

### Labor payroll / TimeTracking

| QuickBooks | NexGen |
| --- | --- |
| `EntityRefListID` | Employee ID |
| `PayrollItemWageRefListID` | `AcctIntCode` — `FMS_CRAFTS` |
| `DurationMinutes` | Worked Hours × 60 (`FMS_LABOR_DETAILS`) |
| `TxnDate` | `EndPayDt` — `FMS_USERS` |
| `BillableStatus` | hard-coded `'NotBillable'` |

`PayrollItemWage.ListID` is resolved **from** QuickBooks by looking up `AcctPayType` in
`FMS_CRAFTS` and writing the found `ListID` back into that table's `Acct Int Code` column — the
one place the document describes a value flowing QB → NexGen and being persisted.

**Only "Worked Hours" is sent.** No ST/OT/DT/HT split. The craft code
([../../payroll/rules/INDEX.md](../../payroll/rules/INDEX.md)) is what selects the QuickBooks
wage item, and the date is the **pay-period end**, not the work date.

### Vendor

Same shape as Customer: `AccountNumber` ← `VendorCode`, `Name`/`CompanyName` ← `Name1`,
`IsActive` from `Status`, the same two-line address offset (`VendorAddressAddr1` ← `Name1`),
`Contact` ← `Contact1`, and `TermsRefListID` from `TERMS`.

### Vouchers → Bills and Vendor Credits

| QuickBooks | NexGen |
| --- | --- |
| `BILL.VendorRefListID` | Vendor Code → lookup ListID in the QB Vendor table |
| `BILL.APAccountRefListID` | `GLLink` — `FMS_GL_ACCOUNTS` |
| `BILL.TxnDate` | Invoice Date (`FMS_VOUCHERS`) |
| `BILL.RefNumber` | `VendorInvNumb` (`FMS_VOUCHERS`) |
| `BILL.TermsRefListID`, `DueDate` | Term ID Invoice, DueDate |
| `BILLEXPENSELINE.ExpenseLineAccountRefListID` | `GLLINK` — `FMS_GL_ACCOUNTS` |
| `BILLEXPENSELINE.ExpenseLineAmount` | `Amount` — `FMS_VW_VOUCHER_EXPORT_VIEW` |

`VENDORCREDIT` and `VENDORCREDITEXPENSELINE` mirror the same shape. AP expense lines have the
same shape as AR invoice lines: **GL account and amount, nothing else.**

*(The PDF spells these tables `FMS_VOUHCERS` and `FMS_VW_VOUHCER_EXPORT_VIEW`; TCG's own
workbook spells them `FMS_VOUCHERS` / `FMS_VW_VOUCHER_EXPORT_VIEW`. Transposition in the vendor
document, not two different objects.)*

### GL Account — and the sentence the GL gap has been waiting for

| QuickBooks | NexGen |
| --- | --- |
| `Account.AccountType` | *(blank in the document)* |
| `Account.AccountNumber` | `GLAcctCode` (`FMS_GL_ACCOUNTS`) |

Verbatim note, in the document, under that table:

> *"we don't have any GL Sync to update the GLLINK column in FMS_GL_ACCOUNTS table. They update
> from Export Invoice when the GLLINK not found in the table it updates."*

**There is no chart-of-accounts synchronisation.** The `GLLINK` column — the join between a
NexGen GL account and a QuickBooks account — is populated **as a side effect of exporting an
invoice**, only when the link is found missing. Nothing reconciles the two lists, nothing
reports on accounts that have no link, and nothing prevents a new QuickBooks account from being
invisible to NexGen until an invoice happens to reference it.

This is a direct, sourced contribution to
[../gaps.md](../gaps.md#gl-codes--fccerp-chart-vs-quickbooks-and-who-owns-the-mapping), which
records *"nothing in the vault names a GL code"* and asks whether the two charts are one list,
a mapped pair, or independent. **The answer this document gives: two independent lists joined
by `FMS_GL_ACCOUNTS.GLLINK`, with QuickBooks as the account authority and no process keeping
them aligned.** It does **not** answer who owns the mapping, nor what happens on a mismatch.

## What the document does not cover

- **Job code, ticket number, unit/crane** — none of these reach QuickBooks anywhere in the
  mapping. Job costing on the QuickBooks side is not supported by this contract.
- Payments, deposits, or cash application — AR receipts are not a touch point.
- Sales tax. Tax is calculated NexGen-side (natively or via Avalara,
  [../avalara-sales-tax-in-nexgen.md](../avalara-sales-tax-in-nexgen.md)); how the tax amount
  reaches QuickBooks is not described.
- Error handling, retry, or conflict resolution of any kind.
- Direction of truth on any field where both systems can be edited.

## Source

`1.0.2_FCC-RESOURCES-GUIDES/QB_Connector/External Quickbooks Online Integration.pdf` — 8 pages,
`pdftotext -layout`. Page 8 is blank; the *Business Rules/Customizations* section is an empty
heading in the original.

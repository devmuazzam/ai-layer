---
title: Proposed QBO reimplementation — ID-based joins and system-of-record rules
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/QB_Connector/NexGen_QBO_Integration_Proposed_Reimplementation - Overview.docx and - Detailed Specs.docx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, kind/source, integrations, architecture, invoicing, requirements]
entities: []
---

# Proposed QBO reimplementation — ID-based joins and system-of-record rules

**What this is.** Two TCG-authored documents proposing how the NexGen ↔ QuickBooks Online
integration should be rebuilt. The **Overview** is written for owners and the CFO — plain
language, ending in a decision to approve; the **Detailed Specs** is written for *"IT Manager,
FCC Integration Team, CFO"* and carries the field-level tables. They are the same proposal at
two altitudes and are read as one.

**Why it matters.** It states, in the client's own words, **what "correct" looks like for an
accounting integration at TCG** — a set of principles that survive the change of technology.
The 2026-09-01 decision moved the ERP off QODBC and onto an API
([../gaps.md](../gaps.md#wishlist-vs-committed-scope--nobody-has-tiered-the-accounting-list)),
but every principle below is transport-independent.

> **Proposal, not agreement.** Nothing in the drop shows FCC accepting or scheduling any of
> this. Section 6 of the Overview is a recommendation *to* the owner/CFO, so it is not even
> established that TCG approved it internally.

## The ownership split it standardises on

> *"NexGen = operational 'source of truth' — Jobs, customers, vendors, employees, invoices
> (content/amounts), and hours originate here.
> QuickBooks Online = accounting 'source of truth' — Chart of accounts, terms, payroll items,
> and final financial balances live here."*

The integration's job is stated as *"mirror NexGen data into QBO correctly and consistently,
using **stable system IDs** instead of names that people can change."*

## The five design principles

1. **Use QBO IDs for all system links.** Lists (Customers, Vendors, Employees, Accounts, Terms,
   Items) join on `ListID`; transactions (Invoices, Bills, Vendor Credits, Time Entries) on
   `TxnID`. Every relationship — customer on invoice, vendor on bill, GL on line — is
   ID-based.
2. **Treat NexGen codes as business keys, not join keys.** `CustCode`, `VendorCode`,
   `EmployeeCode`, Job Code are stored in QBO (in `AccountNumber` or a custom field) and are
   **do-not-change labels**; joins never use them.
3. **Avoid name-based lookups.** *"Integration logic must not rely on any name as the unique
   key."*
4. **One system of record per entity.** As above.
5. **Round-trip IDs on creation.** On creating anything in QBO the connector must read back the
   `ListID`/`TxnID` and **store it in NexGen**, then use it for all future links.

Principle 5 is what the current connector does not do — hence
*"No more guessing based on customer name, vendor name, or invoice number."*

## The risks it names

Stated as the case for change, verbatim in substance:

- **Matching issues** — invoices and customers don't line up cleanly between systems
- **Higher error & rework** — staff hunt down which invoice/job/customer is which
- **Control & audit risk** — *"harder to prove a clean chain from job → invoice → GL → cash"*
- **Automation bottlenecks** — commission calculation, job profitability and analytics become
  fragile

The stated cause: *"some parts of the integration rely on **names and numbers that people can
change manually** (e.g. editing invoice numbers to match job codes, changing customer names in
QBO)."*

## The proposed field additions

The Detailed Specs proposes a `QB_ListID` / `QB_TxnID` column on each NexGen entity. Summarised
across its five tables:

| Entity | Proposed NexGen field | QBO counterpart | Who is authoritative |
| --- | --- | --- | --- |
| Customer | `FMS_CUSTOMERS.QB_ListID` | `Customer.ListID` | **QBO generates**; NexGen stores |
| Customer code | `CustCode` | `Customer.AccountNumber` | **NexGen**; not edited in QBO |
| Vendor | `FMS_VENDORS.QB_ListID` | `Vendor.ListID` | QBO generates; NexGen stores |
| Employee | `EMPLOYEE.QB_ListID` | `Employee.ListID` | QBO generates; NexGen stores |
| Wage item | `FMS_CRAFTS.AcctIntCode` | `PayrollItemWage.ListID` | **QBO is truth** |
| Hours | NexGen labor tables | `TimeTracking.DurationMinutes` | **NexGen is truth** |
| Invoice | `FMS_INVOICE_MASTER.QB_TxnID` | `Invoice.TxnID` | QBO generates; NexGen stores |
| Invoice number | `InvoiceCode` | `Invoice.RefNumber` | **NexGen**; *"users should not change in QBO"* |
| AR account | `GLLink` | `ARAccountRefListID` | **QBO defines accounts**; NexGen stores the ListID |
| Terms | NexGen Terms + QBO ID | `TermsRefListID` | **QBO defines Terms** |
| PO number | `PoNumb` | `PONumber` | NexGen |
| Sales rep | salesperson + QBO ID | `SalesRepRefListID` | *"Must be ID-based, not name-based"* |
| Invoice line GL/item | Final GL Account / Item code | `InvoiceLineItemRefListID` / AccountRef | ListID-based, **via a mapping table** |
| Invoice line rate/amount | NexGen export fields | `InvoiceLineRate`, `InvoiceLineAmount` | NexGen |

On transaction content it is explicit: *"Edits that affect amounts, lines, or structure should
be made in NexGen and re-synced; **QBO edits should be limited to posting/collections
notes.**"*

## The five things it asks FCC to do

1. Add QBO ID fields in NexGen (`QB_CustomerListID`, `QB_VendorListID`, `QB_EmployeeListID`,
   `QB_AccountListID`/`GLLINK`, `QB_TermsListID`, `QB_InvoiceTxnID`, `QB_BillTxnID`, …).
2. Change the connector to be **ID-based, not name-based**.
3. Lock NexGen codes as read-only business keys inside QBO.
4. Capture IDs on insert and persist them.
5. **Document the rules** — a short technical document naming, per field, which system is
   authoritative and how changes are to be made.

## What it deliberately leaves out

- No mention of **job code, ticket, or line-level detail** reaching QBO — the gap the checklist
  raises ([02-integration-review-checklist.md](02-integration-review-checklist.md)) is not
  addressed by the reimplementation proposal.
- No timeline, cost or owner. Section 6 asks the owner/CFO to approve the standard and
  *"authorize IT to work with FCC"*; the next step is stated as FCC returning an implementation
  plan.
- No conflict-resolution rule — only the instruction that one should be documented (action
  item 5, *"Conflict resolution approach"*).

## Relevance to the ERP

Even with QODBC out of scope, four of these carry over intact and are worth treating as
requirements-shaped input when the accounting seam is designed:

- **Join on immutable system identifiers, never on names or human-editable codes** — the ERP's
  own identity standard already works this way (UUID PK + per-tenant business code).
- **Persist the far system's identifier on the near record**, captured at creation.
- **One system of record per entity, written down per field**, with edits outside it
  restricted to non-structural fields.
- **The invoice number is immutable once posted.**

The 2026-09-01 boundary — QuickBooks keeps the books, the ERP takes the reporting — makes the
direction of most of these the reverse of what the document assumes, since the ERP will *read*
QuickBooks rather than write it. The principles are unaffected; the direction is not settled
here and this page does not settle it.

## Source

- `1.0.2_FCC-RESOURCES-GUIDES/QB_Connector/NexGen_QBO_Integration_Proposed_Reimplementation - Overview.docx` — pandoc gfm, 6 sections
- `…/NexGen_QBO_Integration_Proposed_Reimplementation - Detailed Specs.docx` — pandoc gfm, 4 sections with 5 mapping tables

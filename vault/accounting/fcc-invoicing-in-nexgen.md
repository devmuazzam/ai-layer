---
title: Invoicing in FCC NexGen — how an invoice is built and exported
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/InvoicingGuidev1.2.pdf and .../NexGen_WPF_Invoicing_User_Guide_v3.0.pdf
migrated: 2026-09-04
updated: 2022-12-01
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, module/quotations, module/field-ops, kind/reference, invoicing, pricing, ticket-workflow, permissions-roles]
entities: []
---

# Invoicing in FCC NexGen — how an invoice is built and exported

**What this is.** Two Fleet Cost & Care user guides for the system TCG bills from today:

- **`InvoicingGuidev1.2`** — *NexGen Invoicing User Guide*, v1.2 2nd draft, **1 June 2017**, by
  David Thornton. The **legacy desktop screens**. Task-by-task: create an invoice, a parts
  invoice, a service invoice, set up recurring billing.
- **`NexGen_WPF_Invoicing_User_Guide_v3.0`** — *WPF Invoicing User Guide*, v3.0, **December
  2022**. The **modernised (WPF) rewrite** of the rental-invoice and billing-code screens.

They are attributed **per section** below; the two describe different generations of the same
screens and do not conflict.

**Why it matters.** These are the mechanics behind every artefact in this module: the fields
that become the printed invoice
([invoice-packets-2026-04-worked-examples.md](invoice-packets-2026-04-worked-examples.md)), the
`Export OK` gate the QuickBooks connector reads
([nexgen-quickbooks-integration/INDEX.md](nexgen-quickbooks-integration/INDEX.md)), and the
billing-code/price-list structures the quotations module models.

> **Vendor documentation, not TCG process.** Both are FCC's generic manuals, and both note that
> features may be switched on or off per installation. Nothing here establishes what TCG
> actually uses. Where TCG's own practice is on record it is cross-referenced.

---

## Invoice types NexGen supports

*(v1.2 for the legacy set; WPF v3.0 for the modernisation status.)*

| Type | Screen | What it bills |
| --- | --- | --- |
| **Invoice** (rental) | `Enter → Invoices → Invoices` | a completed job — *"Each invoice is based upon information associated with the completed job."* |
| **Parts Invoice** | `Enter → Invoices → Parts Invoices` | parts only — *"does not connect with labor details or work orders"* |
| **Service Invoice** | `Enter → Invoices → Service Invoices` | customers billed via **work orders**; has Labor and Materials tabs |
| **Recurring Invoice** | `Maintain → Recurring Billings`, then `Enter → Invoices → Recurring Invoices` | fixed-cycle billing on long-running jobs |

WPF v3.0 states the modernisation is **rental invoices only**: *"This first iteration of the
Invoice screen modernization targets rental invoices… If a user tries to navigate to an invoice
of a different type, then that invoice will be opened in the legacy screen."* The old
`Enter → Invoices → Invoice` menu entry was renamed **`Parts Job Invoice`** with the rental
aspect removed.

---

## Building a rental invoice — the Main tab

*(v1.2, with WPF v3.0 noting the same fields regrouped.)*

Numbered as the guide numbers them:

1. **Job No.** — *"Many of the fields will auto-populate based on information within the job."*
   The invoice is a projection of the job, not an independent document.
2. **Bill To** — defaulted, overridable from a dropdown.
3. **Cust PO** — *"a general text field and can hold other information like job number, site
   code, etc."* That is exactly what the real invoices show: SCE `TD…, STR:…` identifiers in
   the PO field.
4. **Export Status** — *"The only status that allows export is **Export OK**."* Example value
   shown is `Under Review`. **This is the gate the QuickBooks connector waits on.**
5. **Tax** checkbox, revealing a **Tax Code** dropdown.
6. **Terms** — *"based on company or yard."*
7. **Inv Date** — defaults to today; changeable *"(e.g. month end)"*.
8. **Footer** — chosen per organisational policy.
9. **Retainage** — a percentage *"if retainage is held on a job based on customer agreement"*,
   deducted from the Detail-tab line total.
10. **Billing Description** — *"carries through to the invoice from the original quote. This may
    be modified along the way."*

### The taxability rule, stated twice

> *"If a line item's **Billing Code** is not marked as taxable; regardless of Tax Code chosen,
> there will be no tax calculated. If tax should be included, go back to Schedule Jobs and enter
> a Billing Code for that line item that is marked taxable."*

**Taxability is a property of the billing code, not of the invoice or the customer.** Fixing it
means going back to the job and changing the billing code — not editing the invoice. The
customer-exempt check is separate (*"and the customer is not tax exempt"*).

## The Detail tab

*(v1.2.)* Line items arrive from the job carrying `Billing Code`, `Date From`/`Date To`,
`Ordered Qty Quoted`, `Est Rate`, `Est Amount`. The biller then:

- checks `Date From` / `Date To` and corrects them if wrong;
- enters **`Qty To Bill`** — *"with the appropriate amount associated with the Qty Quoted"*, or
  the correct amount if the quoted figure is wrong;
- corrects `Unit Meas` or `Rate` where those are wrong;
- uses the per-line **Comments** field *"to relay information to the customer about that
  specific item"*, or the last line's comment for the whole invoice.

**This is where "final billing may differ from the quote" actually happens** — the ERP review
log's requirement that *"actual job times and line items may vary, and the system must support
that without changing the signed quote"*
([../erp-review-log.md](../erp-review-log.md) → *Tickets, billing and reporting*). In NexGen it is
`Qty To Bill` sitting beside `Qty Quoted`, with the estimate preserved and the billed figure
entered next to it.

Totals block, as defined by the guide: `Sub Total` · `Taxable Amt` (total of taxable billing
codes) · `Total Invoice` (including taxes) · `Retainage` (the % applied to Sub Total) · `Tax` ·
`Amount Due`. The guide states the reconciliation: *"The Sub Total from the Detail tab should
match the Total Before Tax on the Main Tab and the Total Invoice from the Detail tab should
match the Total After Tax on the Main Tab."*

### The nested summary/sub-item structure

*(WPF v3.0 — not in v1.2.)* Detail lines are a **two-level hierarchy**: summary items with sub
items nested under them, *"a nested set of grids (Summary Items and Sub Items)"*, with a worked
example of a mobilization billed that way. The guide is explicit that this is a re-presentation,
not a change: *"The mathematical and accounting relationships between sub-items and
summary-lines are the same between the screens, and the rendering on invoice documents sent to
customers also remains unchanged."* Sub-items can be dragged between summary groups, and a
sub-item can be promoted out of a group.

### Credit to Employee

*(WPF v3.0.)* A grid on the detail form naming **the employees associated with a revenue/billing
code**. The rules it states:

- The dropdown shows *"all eligible employees based on the dates of the billing code and the
  unit they worked with (defined in Schedule > Job)"*; job-level employees not nested under a
  unit *"always appear… within their worked date range"*.
- Duplicate entries raise a notification, shown both on the grid and on the Details grid.
- If an employee's date range falls outside the billing code's, *"the system will clear the grid
  or notify the user"*.
- **Employees cannot be declared on a summary line** — *"this is consistent with Credit to
  Unit."*
- **No constraint on Unit of Measure or Quantity**, deliberately, *"to support the various
  billing code models"*. Three scenarios given: one employee for the full 8 hours; a billing
  code representing two or more employees, each at 8 hours; or a code representing 8 billable
  hours where the employee did not contribute the full 8 *"(e.g., meal period)"*.
- **Reporting on it is out of the product:** *"Reporting for Credit to Employee is currently
  being handled through custom Microsoft Power BI dashboards."*

That last line matters — the revenue-to-employee attribution behind commission and per-employee
profitability is **not a NexGen report**, it is a Power BI dashboard built per customer.

## E-Tickets and Invoice History

*(v1.2 for the tab; WPF v3.0 for the changes.)* The **E-Tickets** tab lists all e-tickets
associated with the invoice; double-clicking opens a printable ticket preview. v1.2: *"This tab
is for reference only and is not required for invoice processing."* WPF v3.0 moves the same grid
onto the **Details** tab so billing staff can read tickets while populating lines.

**Invoice History** *(WPF v3.0, new)* — *"a complete listing of all completed invoices that are
related to the same job"*, regardless of whether each was emailed or closed, **and it shows
whether a particular invoice was emailed to a customer.**

## Printing, and the printed-flag

*(v1.2, repeated identically for all three invoice types.)* Print offers `Form`, `Plain Paper`
and `Letter Head`; the guide instructs **Plain Paper** — *"this is the report type associated
with the yard logo for invoices."* On a first print a dialog asks whether it printed correctly,
and *"If Yes is chosen, then when exporting invoices, the invoice will show a check mark in the
Printed checkbox."* **A human's answer to a dialog box sets a flag the export reads.**
*(The QuickBooks connector hard-codes `IsToBePrinted = '0'` regardless —
[nexgen-quickbooks-integration/01-fcc-connector-field-mapping.md](nexgen-quickbooks-integration/01-fcc-connector-field-mapping.md).)*

## Invoice Approval

*(WPF v3.0.)* An optional accountability layer, enabled in `Admin → Set System Defaults`
(requires a NexGen restart). Once on:

- a new **`Reports → Invoices → Invoice Approval Report`** appears, filterable eight ways
  including *by salesperson, export status and terms*;
- a new **`Maintain → Footers → Unapproved Invoice Footer`** is defined — rich text, unlimited
  length — and **appears on every invoice that has not been expressly approved**;
- *"When a user attempts to print/email an unapproved invoice, it will always include the
  footer. Once approved, the footer is removed."*
- **Permission to set the approval flag is per-user**, in `Admin → Users`.

This is a genuine control pattern worth noting: the unapproved state is not blocked, it is
**marked on the customer-facing document**.

## Parts and Service invoices — what differs

*(v1.2.)*

**Parts invoice** — customer, Ship To, Bill To, PO No, **Dept and Yard**, tax details including
`Tax Exempt #`, Footer, **Sales Person**, Terms, Invoice Date, Export Status. Detail lines are
parts: `Part No` (pulls from inventory), Description, Quantity, `Unit Meas`, Price,
`Delivery Dt. Est`, `Taxable`, `Discountable`, and — the notable pair — **`Sales GL Account` and
`COGS GL Account` per line**. Saving generates the invoice number.

**Service invoice** — same Main tab as a rental invoice, then three further tabs: **Details**
(costing/quantities), **Labor** (*"where validation will occur for labor"*; blank on a
parts-only invoice), and **Materials** — all parts assigned to the work order, *"and any
comments provided by the service representative that completed the work order"*, with a **`Bill`
checkbox per line to exclude an item from billing.**

## Recurring billing

*(v1.2.)* Set up in `Maintain → Recurring Billings` against a Job No: `Cust PO`, `Terms`,
**`Frequency`** *(days, weeks or months)*, **`Next Bill`** date, **`Prompt To Bill`** frequency,
Footer, a **Detail/Summary** toggle, Retainage, and a Billing Description. Detail lines carry
`Billing Code`, **`Credit To`**, `Billing Qty To Bill`, `Unit Meas`, `Rate`, Comments.
Constraint stated: *"the line items should remain the same for the duration of the recurring
billing instance."* Invoices are then generated by selecting records in
`Enter → Invoices → Recurring Invoices`, filtered by company, yard, department and dates.

## Credit on tax already exported

*(v1.2, the guide's only FAQ.)* Load the original invoice number in the invoice screen and
choose **`Credit Tax`** from the toolbar: *"This will create a credit invoice for the tax
amount only, of the original invoice generated."* The guide instructs recording the reason in
the Detail-tab **Comment** field and in the **In House** tab against the job number.

## Billing Codes and Price Lists

*(WPF v3.0.)* The billing-code screen is where the codes on the printed invoices are maintained.
Tabs: **Main** · **Price Lists** · **Yards** · **Taxable** · **Billing Costs**. Behaviour the
guide states:

- The grid is **read-only**; all edits are made in a form, savable per tab — *"When users
  navigate from one tab to another, they are prompted to save the tab they are leaving."*
- Billing codes can be **exported to Excel or PDF**.
- **Price Lists** has two sub-tabs, `Price Lists` (Name, Description, **Sales Discount %**) and
  `Exceptions` (the billing-code ↔ price-list associations). *"The function of the Price List
  feature remains unchanged."*
- The Exceptions view consolidates what previously lived in two places —
  `Maintain → Codes → Billing Codes → Price Lists` and
  `Maintain → Customers → Price List → Billing Codes` — and can now be grouped by
  **Billing Type, GL Account, Unit or Credit To**, which the guide says users had requested.
- **Billing Costs** is deferred to the *Quote Profit Forecast User Guide*.

The example price-list names shown in the guide's screenshots are `TIER ONE` and `TIER TWO`.
Vault page for this subject: [../quotations/billing-code-and-price-list.md](../quotations/billing-code-and-price-list.md).

## What neither guide says

- Nothing about **who** may do any of this at TCG, beyond the per-user approval permission.
- Nothing about how a **surcharge** (the invoices' `Fuel & Insurance Surcharge`) or a
  **markup** on a pass-through cost is configured — those appear as ordinary billing-code lines
  on the printed invoices, but no guide describes their calculation.
- Nothing about emailing invoices from NexGen; TCG emails from QuickBooks
  ([../meetings/2026-08-28-accounting-process-discussion.md](../meetings/2026-08-28-accounting-process-discussion.md)).

## Source

- `1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/InvoicingGuidev1.2.pdf` — 23 pages, `pdftotext -layout`. Version control table: v1.0 2017-05-18 (David Thornton et al.), v1.1 2017-05-25, v1.2 2017-06-01 draft. Heavily screenshot-led; running footers read *"Procurement User Guide"*, a template artefact.
- `…/FCC-USER-GUIDES/NexGen_WPF_Invoicing_User_Guide_v3.0.pdf` — 31 pages, December 2022, same conversion. Its *General Features* chapter (grid grouping, filtering, column chooser, settings) is UI mechanics and is not reproduced here.
- Also in the drop and **not migrated**: `1.0.2_FCC-RESOURCES-GUIDES/FCC_YouTube/Training_Invoicing_101.url` — a Windows shortcut whose only content is a YouTube link (`https://youtu.be/5d0XKIgw1aI`). Recorded for provenance; no text to migrate.

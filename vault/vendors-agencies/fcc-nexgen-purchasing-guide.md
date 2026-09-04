---
title: FCC NexGen purchasing — requisition, PO, receiver, voucher
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/Purchasing Guide.v.2.1.docx (text and its 17 embedded screenshots, read 2026-09-04) and User Guide - NexGen - PO Requisition .pdf
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/vendors-agencies, module/accounting, module/assets, kind/reference, purchase-orders, invoicing, permissions-roles, reporting]
entities: []
---

# FCC NexGen purchasing — requisition, PO, receiver, voucher

**What this is.** The vendor's own user documentation for the purchasing module of
**NexGen**, the desktop application in the Fleet Cost & Care suite — the legacy system TCG
runs today. Two files: the **NexGen Purchasing User Guide v2.1**, written by David Thornton
at Fleet Cost & Care and dated **24 July 2017** (still marked "2nd Draft"), and a slide-style
**PO Requisition** user guide covering the same first stage in more field-by-field detail.
It matters because it is the reference model the TCG P&Ps in
[purchase-orders-fcc/](purchase-orders-fcc/INDEX.md) sit on top of — and because it shows
several capabilities (requisition approval limits, PO variance, receivers) that the TCG P&Ps
never mention.

**This is generic vendor documentation, not TCG configuration.** The guide says outright that
"some functionality and images in this manual represent options that may be turned on or off
by the system administrator and other functions may not be available in a specific version".
Nothing here establishes which options TCG has enabled, what TCG's approval limits or
variance thresholds are, or who its approvers are.

## The four-stage chain

```
PO Requisition  →  Purchase Order  →  Receiver  →  Voucher  →  export to accounting
   (forecast,      (Conv PO;          (confirm     (vendor      (Export Status
    approval)       locks pricing)     receipt)     invoice)     "Export OK")
```

- **PO Requisitions** "are used to forecast spending and obtain approval from management for
  purchases. Providing more detail during the PO Req stage ensures accurate forecasting
  models." Menu: **Enter → PO Requisition**.
- **Receivers** confirm receipt of a service, item or material bought on a PO. Menu:
  **Enter → Receivers**.
- **Vouchers** are vendor invoices, used to close out purchase orders. Menu:
  **Enter → Vouchers → Vouchers**.

## PO Requisition — Main tab fields

Per the PO Requisition guide and the Purchasing Guide together:

| Field | Behaviour |
| --- | --- |
| **Req No** | Auto-populates; do not modify |
| **Company**, **Yard**, **Dept** | May pre-populate from the user's settings; the Department is chosen from a dropdown for whichever department the PO is being generated for |
| **Vendor** | Type-ahead; magnifying glass opens a detailed search (by phone, address, etc.); **New** adds a vendor. The PO Requisition guide instead says *"For NEW Vendors refer to your AP Department for instruction"* — i.e. the system allows it but the process gates it |
| **Will Call** | Identifies the vendor location the order is placed from. **Only used with the Great Plains and Sage accounting applications** |
| **Order Date** | Usually today |
| **Ship VIA** | Carrier — e.g. NDA, Ground, Pick Up |
| **F.O.B.** | Freight On Board; only used by specific organisations, per internal policy |
| **Confirm To** | The person spoken to at the vendor, "or note the website in which the order will be placed (for documentation purposes)". May be left blank if there has been no vendor contact at requisition stage |
| **Buyer** | The individual placing the order — usually but not necessarily the requisition's creator |
| **Terms** | Populates from the vendor; if blank, ask the organisation's PO manager |
| **Purch Disc %** | May pre-populate from Maintain Vendor |
| **Drop Ship** block | Name1/Name2, Address, City, State, Zip for delivery to a separate location |
| **Vendor Order #** | "an order number, confirmation number, or any other reference number for the order" — this is the field TCG's PO-001 requires the vendor's estimate number in |
| **Requested By** | Populates with the creating user's name |
| **Comments** | PO-level information. The guide is explicit that "there is a separate field for entering item-specific information" |
| **Created By / Modified By** | Capture user ID plus date and time, for creation and last modification |

The vendor address, phone and fax populate after vendor selection, which the PO Requisition
guide notes "is helpful in verifying that the accurate Vendor has been selected".

## PO Requisition — Detail tab fields

Add a line with **Add Part**, **Ctrl + A**, or right-click.

| Field | Behaviour |
| --- | --- |
| **Part No** | **Reserved for stocked parts only.** Entering it populates the Description, and the Yard/Loc/Bin field then shows whether the part is in stock and where — which is also the location the purchased quantity posts to on receipt |
| **Description** | For non-inventory items, enter part number *and* description here. **If the part number is typed into Description rather than Part No, the cost will not populate and must be entered manually** |
| **New / Used** | Indicated where applicable |
| **Qty Ordered**, **Unit Meas**, **Retail Price**, **Cost**, **Purch Disc %** | Line pricing |
| **Burden** | "additional costs to the cost of a part to reflect true cost (e.g. labor associated with generating a PO, placing an order)" — per company policy |
| **GL Account** | Should pre-populate; must be checked where the company uses different yards/departments |
| **Comments on PO** | Line-specific, **prints on the PO** |
| **In House Comments** | "internal use only, are only viewable from this window, and **will not print on any documents**" |
| **Job Number** | Associates the PO with a job |
| **Job Line Item** | Editable only once a Job Number is entered |
| **Work Order** | Associates the PO with a work order |
| **Unit Code** | Associates the PO with a unit; auto-populates and greys out when a unit-related Work Order is selected |
| **Activity** | Editable only once a Work Order is entered |
| **Classification** | Groups parts; "Do not confuse this use of Classification with other windows, as they are used differently" |
| **Delivery Date** | Left blank unless a delay is expected — the guide's example is a crane ordered today for delivery in six months. Feeds accounting's **Past Due Report** |
| **Parts/Labor** + **Tax** checkbox | Whether the line is a part or labour, and whether taxable |

The PO Requisition guide records a capability the P&Ps never use: *"there may be multiple
parts per W/O, or multiple W/O's per PO, and the same PO for Stock and a JOB/WO – all can be
accommodated within a single PO"*.

Saving generates the Requisition Order #.

## Approval limits and Convert to PO

- Approval requirements depend on **the security settings of the user who created the
  requisition**, and on **pre-set dollar thresholds** requiring **one or two approvals** from
  the appropriate person(s). Limits are "arbitrary limits set by an administrator"; to learn
  them, ask a system administrator.
- If the limits are not exceeded, the creator can convert the requisition themselves with
  **Conv PO**. The system prompts for confirmation and generates the PO number automatically.
- **If the requisition exceeds the approval limits, Conv PO is greyed out.** Either the
  approver runs a report of pending PO Reqs, or the requisitioner notifies them so the limit
  can be overridden. Depending on internal policy, either the requestor or the approver does
  the conversion.
- **Copy PO Req** re-creates a previous requisition without re-keying detail; the system asks
  for a new order date, "because there is a good chance that the original PO Req was done in
  the past".

## PO Variance — the control that gates export

> "PO Variance is a method of tracking changes to POs from PO Req through the Voucher. The
> pricing expectation is set in the PO Req when the one generating the PO Req sets the cost
> per line item. If any changes are made to these amounts after the PO Req has been approved,
> then a variance will exist."

- A variance threshold is configured in **Set System Defaults**. **NexGen supports four
  thresholds, each of which can have approvers.**
- Once a PO Req is converted, **no further changes can be made to the PO Req** — this locks
  the pricing structure. Any later change to price or quantity on a single PO line requires
  approval before export.
- If a voucher cannot be exported, the **Voucher Items Exceeding Variance** report
  (Report → Vouchers → Voucher Items Exceeding Variance) lists every voucher over threshold.
  Double-clicking a row opens the voucher and can tunnel back to the PO Req. Ticking
  **Approved** on the voucher's Detail tab sets Export Status to **Export OK**.

## Receivers

Enter the **PO No** and press Tab — the window populates and attachments such as a packing
slip can be added. Enter **Date Received** and **Received By**; **Packing Slip No** and
**Comments** are optional; select the received line (it greys when selected) and enter
**Qty Rec** and **Cost** — the pre-populated cost "can be adjusted to reflect actual cost".
Saving generates a Receiver number.

**Partial shipments** are handled by receiving only the selected line items — which is why the
guide discourages the Receive button on the Purchase Orders toolbar: it "receives all items
for a PO in one instance, which is not usually the case… Developing a habit of using this
button can result in heartache and additional work." Best practice is Enter → Receivers.

To find what is ready to voucher, the guide offers **Reports → Receivers → Receivers Not
Invoiced**, while noting this "would be a matter of internal policy".

## Vouchers — three routes

| Route | Menu | Use |
| --- | --- | --- |
| **Vouchers** | Enter → Vouchers → Vouchers | The general vendor-invoice entry |
| **Quick Vouchers** | Enter → Vouchers → Quick Vouchers | "purchases made that are not associated with a PO, job, or work order. For example, utilities payments, monthly uniform costs" |
| **Vouchers From Receivers** | Enter → Vouchers → Vouchers From Receivers | Enter PO No + Receiver No; the window and its detail lines populate from the receiver |

Common Main-tab fields: Company, Yard, Department, Vendor; **Remit To** (Sage and Great Plains
only); Reference; **Amount**, **Sales Tax Billed By Vendor**, **Use Tax Adjustment**; Terms,
Invoice Date, Discount Date, Due Date; Purch Disc %; Discountable + Discount Amt; Tax
checkbox; **Retainage**; **GST amount / GST Account**; and **Export Status**.

**Export Status is the gate.** "The only status that will export a voucher is 'Export OK'."
The field may not be modifiable by every user — the guide says to contact a manager — and on
Quick Vouchers, "Only individuals with specific permission can set this status to 'Export
OK'". Saving a voucher as Export OK when the PO/Receiver violates the PO Variance policy
raises a message refusing the status.

Detail lines carry Quantity, Cost, Unit Meas, Purch Disc %, Burden, GL Account, line
Comments, **Job No + Job Line Item** or **Work Order + Unit Code + Activity**, Classification,
and the Taxable checkbox. Saving populates the Voucher number on the Main tab.

## Printing and emailing a PO

Printing a **PO** offers two options, **Vendor** and **Internal Use** — Vendor produces the
formatted PO to send out; the guide argues internal copies should be unnecessary because
"NexGen does an excellent job of file storage". To email instead: open print preview,
**Save As**, choose a format (pdf, csv, several Excel formats, HTML), set Destination to
Email, and fill in To/CC/Subject and a body. Addresses can be stored for reuse. Additional
setup and permissions may be required.

## Shared UI conventions

- **Magnifying glass** — detailed search, throughout NexGen.
- **Lightning bolt** — attachments, at the top-right of any window allowing them. Three
  states: unavailable (record not saved), available with none recorded, available with
  attachments present. This is the icon TCG's walkthrough uses to attach PO documents.
- **Refresh** — refreshes dropdown data, for when one user lacks permission and another must
  enter the information first.
- **Save Layout** — retains column width/order changes made during the session.

## Version history of the guide

| Date | Author | Version | Release | Change notes |
| --- | --- | --- | --- | --- |
| 07/24/17 | David Thornton | 2.1 | Draft | Added PO Variance, Vouchers from Receivers, and Quick Vouchers modules |
| 06/01/17 | David Thornton | 2.0 | Draft | Post initial team review and edit |
| 05/25/17 | David Thornton | 1.2 | — | Post compilation and initial formatting |
| 05/18/17 | David Thornton, et al. | 1.0 | — | Original compilation of modules |

## What this leaves open for the new ERP

The guide describes capabilities the TCG P&Ps are silent about — requisition-stage approval
limits, PO variance thresholds, receivers as a distinct step, and the Export OK permission
gate. **Nothing in this drop says whether TCG uses them.** PO-001's procedure starts at
**Enter → Purchase Orders**, skipping the requisition screen entirely, but does not say
whether that is a deliberate bypass. Do not assume either way.

## Source

- `1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/Purchasing Guide.v.2.1.docx`
  — 22-page .docx → pandoc GFM, ~31 KB of text. All screenshots and icon images dropped in
  conversion, so icon glyphs appear as empty `()` in the original text and are described by
  name here. The 17 embedded screenshots were extracted from the `.docx` and viewed
  separately on 2026-09-04 — see *What the screenshots show* above.
- `1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/User Guide - NexGen - PO Requisition .pdf`
  — slide-style PDF → `pdftotext -layout`, ~7 KB. **The same file also appears at**
  `1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/User Guide - NexGen - PO Requisition .pdf`;
  the two converted texts are byte-identical. Only the field notes survived conversion; every
  slide's screenshot did not.

A third file in the drop,
`1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_ENTER_PURCHASE-ORDERS-and-REQUISITIONS.pptx`,
covers the same screens but converted to **11 slides containing zero text** — it is an
images-only deck. Its content is not recorded anywhere; it would need OCR.

## What the screenshots show — read 2026-09-04

The 17 images embedded in `Purchasing Guide.v.2.1.docx` were extracted and viewed on
2026-09-04 (one further image, the cover logo, is the Fleet Cost & Care wordmark shared with
the other guides). The screens are the vendor's own demo database — company "Fleet Cost &
Care", yards "Atlanta Yard" and "Raleigh", vendors named `1110 Vendor` / `1112 Vendor` /
`Automotive supply` — so the example values are FCC test data, not TCG configuration. Only
what the text above did not already give is recorded here.

### The NexGen menu bar and the Enter menu

The top-level menus are **File · Edit · Favorites · Admin · Maintain · Enter · Display ·
Schedule · Reports · Utilities · Export/Import · Window**. The **Enter** menu, in order:
Labor ▸ · Materials ▸ · Inventory Stock Adjustments · Quotes ▸ · Order Entry · Order Pick
Ticket Shipment · Job Parts Shipment · Work Orders · Work Orders From Due PM's · PO's from
Job/WO Estimates · Job Line Items · Job Change Order · Equipment Allocation · Equipment
Allocation From Excel · Current Hrs/Miles · Preventative Maintenance · **PO Requisition ·
Purchase Orders · Receivers · Vouchers ▸ · Invoices ▸** · Journal Entries.

The **Vouchers** submenu has **four** entries, not the three the text describes: *Vouchers ·
Vouchers from Receivers · **Vouchers from Contract PO** · Quick Vouchers*. The guide never
mentions "Vouchers from Contract PO"; the screenshot shows it exists and nothing more.

### PO Requisition — what the Main tab actually carries

Window toolbar: `New PO Req · Copy PO Req · Conv PO · Refresh · Save Layout · Save · Print ·
Close` (three further slots read `N/A`). Header: a **Req Order** search/dropdown and a
**View** dropdown defaulting to **`Open`**. Two tabs, **Main** and **Detail**.

Fields visible on Main that the text does not list:

| Field | As shown |
| --- | --- |
| **Req No** | pre-filled with the literal `AUTO` before save |
| **Vendor** | a **Name / Code** radio pair above the vendor dropdown — the vendor can be picked by either; the `NEW` button sits beside the magnifying glass |
| **Will Call** | defaults to **`Corporate Address`** in the demo |
| **Order Date** | defaults to the current date |
| **Approval Limit1** / **Approval Limit2** | two checkboxes, each with a greyed name field and a greyed date field beside it — the on-screen form of the "one or two approvals" the text describes. Both are greyed on a fresh requisition |
| **Closed Date** | a date field showing `00/00/0000` until set |
| **PO No** | greyed; populated when the requisition is converted |
| **Parts · Contract Labor · Req Total** | three read-only money totals at the right edge — the requisition splits its total into parts and contract labour |

The **Vendor Information** block (Address, Phone, Fax) is read-only and fills after vendor
selection, as the text says. **Created By / Created Date / Modified By / Modified Date** are
four separate read-only fields.

### PO Requisition — Detail tab

The line grid columns are **Part No · Description · Job Number · Work Order · Unit Code ·
Qty Ordered · Cost · Amount**, with a `Record 1 of 1` counter. Defaults on a new line:
**Qty Ordered `1.00`**, **Unit Meas `Each`**, **Purch Disc % `0.00`**, **Cost `0.0000`**
(cost is held to **four decimals**; Retail Price and Amount to two), **Parts/Labor `Parts`**,
**Tax checkbox ticked**. **GL Account** is a dropdown with a read-only description beside it.
There is an **Order No** search field beside Job Number / Work Order that the text does not
mention. **Burden** and **Classification** are dropdowns; **Delivery date** is a date dropdown.

**Contradiction with the text:** the text lists a **New / Used** indicator on the requisition
Detail tab. No such field is visible in the requisition screenshot. `New/Used` does appear as
a dropdown (default `New`) on the **Receiver** and **Vouchers From Receivers** detail panes.
The document does not say whether the field is hidden by a setting on the requisition screen.

### Receivers

Toolbar on the Receivers window: `New Rec · Del Line · First · Previous · Next · Last`. Header
fields, left to right: **Receiver No** (`AUTO`) · **Voucher No** (greyed) · **PO No** (search +
dropdown) · **Vendor** (read-only) · **PO Amount** (read-only) · **Date Received**
(`00/00/0000`) · **Received By** (dropdown); second row **Packing Slip No** and **Comments**.

After a PO is chosen the line grid shows **Part No · Description**, and the line pane shows:
**PO Line · Part No · Description**; **Yard/Loc/Bin** (dropdown, demo value
`Raleigh / Not Assigned`) and **New/Used** (`New`); an **Ordered** group (`Qty Ord · Cost ·
Amount`), then **Qty Oth Rec** and **Qty Open** — i.e. quantity already received on other
receivers and quantity still open — then a **Received** group (`Qty Rec · Cost · Amount`);
**Job No · Unit Code · Activity · Work Order · Order No**; Created/Modified by and date; and
two footer totals, **PO Amount** and **Receiver Amount**. The demo shows a PO number of
five digits and an Order No of three; nothing says what TCG's sequences look like.

### Vouchers — Main tab fields the text omits

In addition to the fields listed above: **Vendor Invoice No** (a separate field from
**Reference**), **Use Tax Payable** (read-only, beside the Use Tax Adjustment + Tax checkbox),
**Contract Labor** and **Parts** read-only sub-totals, and three footer totals —
**Voucher Amount · Distributed · Remaining To Distribute**. **Inv Date** and **Due Date**
default to the current date; **Disc Date** to `00/00/0000`. The **GST Account** default in the
demo is `000-1130-00` — a `000-0000-00` account-number shape, which is the vendor demo's chart,
not TCG's. **Remit To** defaults to `Corporate Address`. The Vendor block here shows both a
name and a **vendor code** beside it (demo code `AUTO SU`, i.e. a short alphabetic code).

**Export Status shows `Export OK` pre-selected on a blank, unsaved voucher** in all three
voucher screenshots (Vouchers, Quick Vouchers, Vouchers From Receivers). The text says only
permitted users can set that status. The screenshots do not say whether `Export OK` is the
default for every user or only for the (administrator) user who took them.

Detail tab grid: **Part No · Description · Job No · WO No · Unit Code · Quantity · Cost ·
Amount**; same field set and defaults as the requisition Detail tab, plus **Taxable** (ticked
by default) and a footer of **Voucher Amount · Remaining To Distribute · Total**.

### Quick Vouchers — the Detail tab is a different shape

The Quick Voucher **Main** tab mirrors the Vouchers Main tab (minus the Name/Code radio). Its
**Detail** tab, however, is a flat grid of just **Amount · GL Account · Description ·
Comments** — no part, quantity, job, work order or unit fields at all. This is the on-screen
form of "purchases not associated with a PO, job, or work order".

### Vouchers From Receivers

Main tab: **Company, Yard and Dept are greyed** (inherited from the receiver); **PO No** and
**Receiver No** are search + dropdown fields. The Detail line pane adds an **Approved**
checkbox with a greyed approver-name field and a datetime field beside it (placeholder
`1/1/1900 12:00:00 AM`) — the PO-variance approval control the text describes — plus
**Yard/Location**, **New/Used**, and an **Activity** dropdown (demo value `200 hr. serv.
lower.`, i.e. activities are named service intervals). The footer is **Sub Total · Tax ·
Freight · Remaining To Distribute · Total** — **Freight** is a voucher-level amount not
mentioned in the text. In the demo line the **Taxable** box is unticked.

### Voucher Items Exceeding Variance report — layout

Report header: company name, **All Yards**, **All Departments**, a From/To date range.
Columns: **Voucher No / Status** (stacked) · **Req No / PO No** (stacked) · **Vendor Name** ·
**Original Cost** · **Voucher Cost** · **Variance %** · **Comments**. Status values seen:
**`Pending`** and **`Approved`**; an approved row carries an `Approved By : <user> <date>
<time>` sub-line. The demo rows show how Variance % is computed: original `$10.00` → voucher
`$30.00` prints **200.00%**; original `$0.00` → voucher `$100.00` prints **100.00%** (a zero
original is treated as 100% variance, not division by zero).

### Attachments

The lightning-bolt window is titled **Maintain File Links – Purchase Order** and lists
**File Name · Comments · Created By / Created Date · Modified By / Modified Date**. The demo
row is a UNC path into a `FCC_Job_Attachments\<n>\` share — attachments are stored as
**file links to a network share**, not as blobs in the database. The document does not say
what TCG's share is.

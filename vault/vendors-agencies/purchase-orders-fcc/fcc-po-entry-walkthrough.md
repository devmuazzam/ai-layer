---
title: FCC PO entry walkthrough — quote to PO to job
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/SOP_example_for_sales_PO-SOP.docx and the walkthrough appended to P&P – PO-001
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/vendors-agencies, module/quotations, kind/sop, purchase-orders, requirements]
entities: []
---

# FCC PO entry walkthrough — quote to PO to job

**What this is.** The click-by-click FCC/NexGen walkthrough that sits behind
[PO-001](po-001-pre-job-purchase-orders.md). It appears **twice in the drop, word for word**:
once appended to the PO-001 policy document, and once as a standalone file
`SOP_example_for_sales_PO-SOP.docx` whose opening line reads *"This is more of the detailed
process for Sales Team creating Pos for Jobs that need traffic control (including before the
Job is created in FCC)… with screenshots…"*. It is captured once here rather than duplicated
across two pages. The walkthrough is **screen navigation for the legacy FCC system**; it is
useful as evidence of what the current process actually is, not as a specification for the
new ERP.

The worked example: a salesperson needs **RCS Roadway (traffic control)** for **Quote
OM-33923**, before the Job exists. The Job that eventually results is **OM56195**.

## 1. Start from the quote

FCC menu **Enter → Quotes → Job Quotes**. Type the Quote No, or click the magnifying glass to
open the Quote Lookup screen; double-click the Quote No there to open the quote.

## 2. Create the purchase order

FCC menu **Enter → Purchase Orders**.

This is a **new** PO — not a search for an existing PO No. The **PO No** field on the
**[Main]** tab reads **"AUTO"**: FCC generates the PO No when the new PO is saved.

**[Main] tab**

- Fill in the header fields.
- Include the **Vendor Order No**.
- **Important, verbatim from the source:** *"in the Comments box, type in the Quote No (this
  is how we will find and attach the Purchase Order to the Job, if the Job is not already
  created)"*.

**[Detail] tab**

- Add a line item with the **"Add Part"** button on the toolbar, or **Ctrl + A**.
- Include the **Job Number** — if there is no Job yet, leave it blank.
- **Important, verbatim:** *"this Job Number field **must** contain the Job Number for this
  Purchase Order to be attached to the Job"*.

**Finish**

- Click the **lightning bolt** icon to attach PO documents. (The FCC Purchasing Guide
  confirms the lightning bolt is the attachments control across NexGen — see
  [../fcc-nexgen-purchasing-guide.md](../fcc-nexgen-purchasing-guide.md).)
- Click **Save** on the toolbar.

## 3. Verify once the job exists

When the Job is created — example **Job OM56195** — open it via **Schedule → Job**. Type the
Job Number, or use the magnifying glass to open the Job Search screen and double-click the
Job No.

On the Job's **[Main]** tab, the **Related Information** panel at the bottom-right shows
attached **PO(s)**. Click the blue **"PO(s)"** link to open the POs attached to this Job, and
click the **+** next to a PO Number to expand its detail.

## The two anchors, and why both matter

The walkthrough makes the mechanism concrete: the **Comments box holds the Quote No** and is
how a pre-job PO is *found* later; the **Detail-tab Job Number is what actually attaches**
the PO to the Job. Neither substitutes for the other. That is why
[PO-003](po-003-linking-pre-job-pos-to-jobs.md) exists as a separate procedure — finding the
PO and attaching it are two different operations in FCC.

## What the deck's screenshots show — read from the images on 2026-09-04

`FCC_ENTER_PURCHASE-ORDERS-and-REQUISITIONS.pptx` converted to eleven slides of zero text; its
thirteen embedded images were extracted and read directly. They are FCC screens against TCG's
live data (Nov–Dec 2025), and they settle several things the P&Ps only assert.

**1. PO numbers are prefixed by department.** The `PO Lookup` grid (All POs, 11/1/2025–12/31/2025)
lists `OM-2986 … OM-2044` with Department `OPERATED & M[AINTAINED]` and `FL-1664 … FL-1647` with
Department `FLEET`, plus `SH-13 … SH-11` for `SHOP` and one `RG-1646` for `RIGGING` on the
requisition side. **The prefix is the department code**, and each department has its own running
sequence. The P&Ps' `OM-` examples are therefore Operated & Maintained POs specifically. Every row
is `Main Yard`. Grid columns: `PO No · Order Date · Vendor · Vend Order# · Yard · Department ·
Total · Printed`. Vendors visible in the window include Mcmaster-Carr, Inland Kenworth, Coastline
Equipment, **RCS Safety LLC** (four POs in one week, $1,286–$7,568), Fleet Cost & Care, Uline,
Mardian, Velocity Truck Centers, Globe Gas, California Clutch & Gear, Fleet Services, Cintas, RA
Batcholer, Simpson Chevrolet, **Quality Permits LLC**, G3 Creative, CNS.

**2. The PO has three tabs, and three different comment fields.** `PO OM-2177` (Globe Gas
Corporation, propane, $365.34, created by `samg` 1/15/2026):

- **Main**: PO No · Company · Yard · Dept · Vendor (Name/Code radio, **NEW** button, lookup) · PO
  Type (`General`) · Order Date · Ship Via · F.O.B · Confirm To · Buyer · Purch Disc % · Terms
  (`Net 30`) · Footer · Vendor Information (code `GLO002`, address, phone, fax) · Drop Ship
  Information (Name1/2, Address1/2, City, State, Zip) · Vendor Order No · Taxable · Closed Date ·
  **Comments** (free text) · Parts total · Contract Labor total · Created/Modified By/Date.
- **Detail**: grid `Part No · Description · Job Number · Work Order · Unit Code · Qty Ord · Cost ·
  Amount`, and per line: Part No (**New** button) · Description · Qty Ord · Unit Meas (`Each`) ·
  Retail Price · Purch Disc % · Cost · Burden · Amount · **GL Account** (Code/Name radio — `SYSM
  Shop/Yard Supplies and…`) · **Comments On PO** · **In House Comments** · Qty Received ·
  **Job Number** (lookup) · Job Line Item · Work Order (lookup) · Classification · Unit Code
  (lookup) · Activity · Order No · Est Delivery date · Parts/Labor (`Parts`) · Tax · Sub Total /
  Taxable Amt / Tax / Total.
- **Rec/Vouchers**: `Receiver · Voucher No · Part No · Description · Qty Rec · Cost · Amount` —
  here Receiver `OM-2446`, Voucher `OM-2471`. Receivers and vouchers share the department prefix.
- A **Maintain File Links – Purchase Order** window (File Name · Available On Vouchers · Comments ·
  Created/Modified By/Date) hangs off the PO for attachments.

> **This is the field-level evidence behind the commissioning-thread objection.** The P&Ps say
> to write the Quote Number in the *[Main] tab Comments*. The Detail tab has two more: **Comments
> On PO** (prints) and **In House Comments** (does not). Melissa's 3 Dec 2025 remark that
> *"in house comments don't come up on reports"* is about the third field. Three comment fields,
> one of which is invisible to AP, and the P&P names the one on a different tab from where the Job
> Number lives. See [commissioning-email-thread.md](commissioning-email-thread.md).

**3. The requisition-to-PO link.** `PO Requisition FL-1628` (Liebherr, cam position sensor
$444.55, `Requested By Stricker, Jeff`, created `jstricker` 12/2/2025): Main tab carries
**Approval Limit1 ☐ / Approval Limit2 ☐** with two blank approver fields each, a `Closed Date`
(12/02/2025), and **`PO No FL-1723`** — the PO the requisition became. Detail tab adds
`Yard/Loc/Bin` (`Main Yard / Parts Cag…`), `New/Used` (`New`), `Warranty ☐`, `Work Order
FL-21828`, `Unit Code 27501`, `GL Account R&M Repairs & Maintenance`. The `PO Requisition Lookup`
grid (`Req No · Order Date · Vendor · Yard · Department · Total · Printed`) shows `FL-1665 …
FL-1643` and `RG-1646`, all FLEET except the RIGGING one — every one raised by Fleet for parts.
The toolbar has **New PO Req · Del PO Req · Copy PO Req · Conv PO**.

> **So requisitions are a Fleet parts workflow with a two-level dollar approval; Sales/Dispatch
> POs go straight to `Enter → Purchase Orders`.** That is what the P&Ps describe and the
> requisition screen confirms — the approval-limit gate exists only on the requisition path. The
> question the H-group report raised (do Sales/Dispatch POs bypass approval limits?) is answered
> *structurally* yes; whether that is intended is still not stated anywhere.

**4. The second example PO.** `PO FL-1648` (Coastline Equipment, vendor code `COA003`, *Rear Stab
Cylinder* part `4900166.003`, $2,990.20, `Work Order FL-21766`, `Unit Code SL03`, `GL Account
SL03 SL03 Expenses`, `Req No FL-1556`, Receiver `FL-2160`, created `jstricker` 11/4/2025). Note
the **GL account named after the unit** (`SL03 Expenses`) — fleet repair cost is being booked to a
per-unit GL account, not to a generic R&M account.

**5. The menus.** `Enter` menu order: Labor · Materials · Inventory Stock Adjustments/Transfers ·
Quotes · Order Entry · Parts Shipment · Work Orders · Work Order From Deficiencies · Deficiencies
Reported As No Repair Needed · Reqs/POs from Parts Reorder Points · PO Req's from Job/WO
Estimates · Work Orders From Due PM's · Job Line Items · Job Change Order · Equipment Allocation ·
Equipment Allocation From Excel · Current Hrs/Miles · Preventative Maintenance · **PO Requisition ·
Purchase Orders · Receivers** · Vouchers · Invoices. `Maintain` menu (lower half): Chk\Taken By ·
Job Types · Line Items · Quote Status · Classifications · Geographies · WO Reason · WO Priorities ·
Work Order Status · Units of Measure · Terms · Documents · **Vendors** · Salespeople · Field
Names · Recurring Billings · Job Checklist · Export Status · Deficiency Degree/Priority ·
Telematics Provider · Regions.

## Source

Two files with identical walkthrough content:

- `1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/SOP_example_for_sales_PO-SOP.docx`
  — .docx → pandoc GFM, ~4.4 KB, 15 embedded screenshots not converted.
- The walkthrough section appended to
  `1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/P&P – PO-001 – Pre-Job Purchase Orders (POs) in FCC.docx`
  — same 15 screenshots, same captions, larger rendered image sizes.

Every step above is text; the screenshots themselves were not converted, so field-level
layout of the FCC screens is not recorded here.

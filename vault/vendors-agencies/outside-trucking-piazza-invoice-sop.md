---
title: Outside trucking — putting Piazza invoices into FCC
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/SOP - Outside Trucking.docx (text and its five embedded screenshots)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/vendors-agencies, module/accounting, kind/sop, invoicing, pricing]
entities: []
---

# Outside trucking — putting Piazza invoices into FCC

**What this is.** A step-by-step accounting SOP for taking a **Piazza Trucking** invoice out
of email and onto the customer's FCC invoice. Melissa McNutt attached it to Brian Petros on
**3 December 2025** as the **format model** for the PO P&Ps — *"Please see the attached sample
SOP we have for accounting. Can you please simplify the SOPs and add in the visuals so if
someone that has never seen FCC before can step by step follow the SOP"* (see
[purchase-orders-fcc/commissioning-email-thread.md](purchase-orders-fcc/commissioning-email-thread.md)).

> **This file is misfiled relative to the folder it sits in.** It lives in
> `TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/` and its name suggests a trucking PO procedure, but
> **it is not about purchase orders at all** — it never mentions a PO, a PO number, a
> requisition or a voucher. It is a vendor-invoice-to-customer-invoice procedure that works
> off the **OM job number printed on the Piazza invoice**. It was included in that folder as
> an example of SOP *style*, not as PO content. Read it that way.

It is the only source in the drop that records the **actual mark-up arithmetic** applied to a
subcontracted trucking cost.

## Getting the invoices

Piazza invoices always arrive from an address ending `@piazzatrucking.com`. Download them,
keep them in a desktop folder named "Piazza Invoices" — the SOP walks through creating it —
and open them in Adobe Acrobat, singly or all at once.

## Adding a Piazza invoice to FCC

1. Open FCC, click **Schedule Job**, and type the **OM number listed on the Piazza invoice**.
2. Check whether **Invoice History** shows a **"1"**. That means an invoice already exists, so
   Piazza can be added straight onto that invoice's line items.
3. If it does: click **Invoice History**, click the box with the arrow under **Go-To** to open
   the invoice, then **Details → "Click here to add new item"**.
4. Add the line item using the arithmetic below.
5. On the **Main** tab, change the invoice number to **`P<Job Number>`** — the worked example
   is job 53490 becoming invoice **`P53490`** — and save.

**If no invoice has been created yet:** open the job, go to the **estimates** tab on the left,
add the same line items there and save; add a note in the **In-House Comments** tab (bottom
left) reading "Piazza added to estimates tab!"; save again.

## The mark-up arithmetic

Both cases add **10% to the Piazza invoice total**, then divide by an hourly rate to convert
the vendor's dollar cost into billable hours against a billing code:

| Case | Divisor | Billing code to look up | Worked example (invoice total $710.52) |
| --- | --- | --- | --- |
| All normal cranes (non-self-loaders) | **$35** | **"Edison Support Vehicles Counterweight Load"** | $710.52 + 10% = $781.57 ÷ $35 = **22.33 hours** |
| Self-loaders | **$58.50** | **"Edison Stretch Semi"** | $710.52 + 10% = $781.57 ÷ $58.50 = **13.36 hours** |

Enter the resulting figure as the **quantity** and switch the **UM** to **Hours**. In the line
item description box, add **"Piazza (invoice #)"**.

> The SOP does not say where the 10%, the $35 or the $58.50 come from, whether they are
> customer-specific (both billing codes are named "Edison"), or when they were last reviewed.
> It does not say what to do for a customer other than Edison, or for a truck type that is
> neither a normal crane nor a self-loader.
>
> The instructions also carry a transcription defect in the source: the self-loader case
> computes **13.36 hours** but the following step still says *"enter 22.33 into the quantity"*,
> copied from the non-self-loader case. Treat the 22.33 in the self-loader step as an error in
> the document, not as a rule — but note that the vault is recording what the document says.

## Filing the invoice afterwards

Back in Adobe: **File → Save As → Desktop**, and name the file by **"Piazza Invoice Number, OM
number, date"** — the example given is `P290612 CRANE GUYS OM53490 08.25.2025`. Then open the
**"Bills for Invoices"** shared OneDrive folder in a browser, and drag the completed invoices
into the **Piazza** folder. The SOP then hands off: *"Refer to 'Collections Sheet SOP' for next
steps!"* — that document is not in this drop.

## How this relates to the PO policies

The P&Ps in [purchase-orders-fcc/](purchase-orders-fcc/INDEX.md) say a Piazza order should be
covered by a PO raised by Dispatch, carrying the vendor's estimate number, which AP then
vouchers against. This SOP describes the invoice arriving and being keyed straight onto the
customer invoice by OM number, with no PO step anywhere. **Whether this SOP predates the PO
policy, coexists with it, or is exactly the practice PO-001's "If you buy it, you PO it" rule
was written to replace, no source in the drop says.**

## What the SOP's screenshots show — read 2026-09-04

All five embedded screenshots were extracted and read. They are the worked example the text
describes — the same Piazza invoice, the same job — captured 25–27 Aug 2025, and they settle
several things the text leaves open. Employee names on the screens were not copied.

**The Piazza invoice.** A standard vendor invoice from *PIAZZA TRUCKING*, South Gate CA:
`Invoice Number` (`P######`), `Invoice Date`, `Page`, the word *Duplicate*; `Bill To` / `Ship
to` both *CRANE GUYS, ATTN: <a TCG employee>, 10850 Portal Drive, Los Alamitos*; a grid
`Customer ID` (**`CRAGU`**) · **`Customer PO`** (the OM job number — the field the SOP
highlights) · `Payment Terms` (`Net 30 Days`); `Sales Rep ID · Shipping Method (Courier) · Ship
Date · Due Date`; one line `Quantity 1.00 · Item · Description "FREIGHT - SURFACE" · Unit Price ·
Amount`; `Subtotal / Sales Tax / Total Invoice Amount / Payment/Credit Applied / TOTAL`; a
`Check/Credit Memo No:` box. **The OM job number reaches Piazza as TCG's "Customer PO"** — the
job number is being given to the vendor as the purchase-order reference, which is exactly the
"Job Numbers as verbal POs" practice [PO-001](purchase-orders-fcc/po-001-pre-job-purchase-orders.md)
rule 1 forbids.

**The FCC job.** *Schedule > Job* for the OM number: customer Southern California Edison, yard
`Allen Yard`, terms **`Net 10`**, `Price List SO CAL EDISON`, `Status Confirmed`, `Equipment
Required "Self Loader + Rigger"`, a Description Of Work that begins *"6/20 self loader to
deliver at 0800 & crane onsite at 0800"*, and the Job's `PO Number` field holding two customer
(SCE) PO numbers. *Related Information*: `Quote OM-30740 · PO(s) none · Tool(s) none · Lift Info
none | Storage Item(s) none · Latest Invoice 8/25/2025 · Invoice History 1 (highlighted) · Daily
none`; the In-House Comments icon carries a badge of 2. **`PO(s) none`** — no FCC purchase order
exists for the trucking on this job, which is the "no PO step anywhere" observation above, now
visible on the record.

> **The example contradicts its own rule.** The job's equipment is a **self loader**, so by the
> SOP's arithmetic it is the `$58.50` / *"Edison Stretch Semi"* case — yet the line actually
> entered (next screenshot) is *"Edison Support Vehicles Counterweight Load"* at `$35.00` with
> `22.33` hours, the non-self-loader case. Either "self-loader" in the SOP means something other
> than the crane on the job, or the example was keyed under the wrong case. The document does
> not say which.

**The invoice line — FCC's Data Form.** Fields: `* Billing Description` (lookup — `Edison
Support Vehicles Counterweight Load`) · `Credit To Schedule Type` · `Credit To Unit` (greyed) ·
`Line Item` · `Date From` / `Date To` (both the job date) · `Quantity` (`22.33`, greyed) · `UM`
(`Hours`) · **`Rate` (`$35.00`, greyed)** · **`Amount` (`$781.55`, greyed)** · `Comments`
(**`Piazza 290612`**) · `Billing Complete ☐` · `Taxable ☐` · an *Estimated* block (`Quantity
0 / 0 / 0`, `UM`, `Rate $0.00`, `Amount $0.00`) · a *Credit to Employee* grid (`Alert · Actions ·
Employee · Work Date · UM · Q…`, "Click here to add new item") · Created/Modified stamps.
Three things follow. **The rate is not typed** — it is greyed and comes from the billing
description's price-list rate, so the SOP's "divide by $35" is back-solving the quantity so
that *quantity × price-list rate ≈ vendor invoice + 10%*; the `$35` and `$58.50` are the SO CAL
EDISON price-list rates of those two billing descriptions, which is why both are named
"Edison". The amount comes out at `$781.55`, not the `$781.57` in the text (22.33 × 35 rounds
differently from 710.52 × 1.1). And the comment convention actually used is **`Piazza 290612`**
— the invoice digits without the `P` prefix and without the word "invoice".

**The OneDrive folder.** *Bills for Invoices* (in a TCG employee's OneDrive, shared) holds four
subfolders: `All RCS Invoices` (50 items), `Billed` (2), `Piazza` (48), `Quality Permits` (83),
last modified June–July. So the same folder collects **RCS (traffic control) and Quality Permits
vendor invoices** alongside Piazza; the SOP covers only the Piazza case and does not say
whether the same mark-up procedure applies to the other two. The fifth image is the FCC save
icon.

## Source

`1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/SOP - Outside Trucking.docx`
— .docx → pandoc GFM, ~4.1 KB. The five embedded screenshots were read directly on 2026-09-04
(see *What the SOP's screenshots show*); the mark-up figures in the table above are from the
SOP text. The document carries no version or revision date of its own; its example dates are
25–27 Aug 2025.

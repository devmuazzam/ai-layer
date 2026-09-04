---
title: FCC needs — the email thread that commissioned the PO P&Ps
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/Re_ FCC Needs - (P&Ps for POs).msg
migrated: 2026-09-04
updated: 2025-12-04
status: unverified
conflicts_with: [vendors-agencies/purchase-order.md]
jira: []
tags: [module/vendors-agencies, module/accounting, kind/discussion, purchase-orders, invoicing, reporting]
entities: []
---

# FCC needs — the email thread that commissioned the PO P&Ps

**What this is.** A four-message Outlook thread between **Melissa McNutt (President)**,
**Brian Petros (Data Analyst)** and **Wes Staley**, running **1–4 December 2025**. It is the
commissioning record for the three PO P&Ps and — more valuable — it carries Melissa's own
description of how the PO process is meant to tie together, a **PO-type taxonomy that
contradicts what the vault already holds**, and an unresolved objection to the mechanism the
drafts rely on. Read it as management intent stated in passing, not as an approved
specification: Melissa says of her own account *"This is by no means an SOP just a quick over
view"* and flags that Sammy has done it more than she has.

## Timeline

| Date | From | What it says |
| --- | --- | --- |
| Mon 1 Dec 2025, 14:22 | Melissa → Wes, Brian | "FCC Needs" list, ending with the request for PO SOPs |
| Mon 1 Dec 2025, 14:47 | Brian → Melissa (cc Wes) | Sends the three draft P&Ps for review; asks whether to share with Sammy, others, or Courtney at FCC first |
| Wed 3 Dec 2025, 11:55 | Melissa → Brian | Attaches the sample accounting SOP as a format model; asks for simplification and visuals |
| Wed 3 Dec 2025, 15:30 | Brian → Melissa (cc Wes) | Will pull together this material, the FCC user guides and the Courtney meetings |
| Thu 4 Dec 2025, 03:51 | Melissa → Brian (cc Wes) | The substantive reply: PO types, the end-to-end walkthrough, the in-house-comments objection |

## What was asked for

Melissa's original "FCC Needs" list (1 Dec) is broader than POs. Alongside Power BI reporting
demo, burden rates for TRG, fringe cost on work orders, "kits" for customers with special
pricing, ATOM, report review, weekly utilization, and job checklists vs unit checklists, it
closes with:

> "Also I asked Brian to produce a How to / SOP for the PO system so we can give it to
> everyone for reference. Once we have this we can do a quick refresher on the PO process and
> get that going **so we don't have to change the invoice numbers**."

The three SOPs requested, verbatim:

1. SOP for creating a PO
2. SOP for where to put it within the job / tie it to the job
3. SOP for AP to match that PO to the job

Those map one-to-one onto [PO-001](po-001-pre-job-purchase-orders.md),
[PO-003](po-003-linking-pre-job-pos-to-jobs.md) and
[PO-002](po-002-vendor-billing-and-customer-invoicing.md).

On 3 December Melissa restates the business reason: *"We need to get the SOP's made and
departments trained on how to utilize the PO process so we can move forward using the
automated invoice numbers through FCC."* The link between PO discipline and being able to
stop hand-editing invoice numbers is asserted twice but never explained.

She also attaches `SOP - Outside Trucking.docx` as the **format** example — "Can you please
simplify the SOPs and add in the visuals so if someone that has never seen FCC before can
step by step follow the SOP to create PO, Add a Po to a job and find what job the Po belongs
too." See [../outside-trucking-piazza-invoice-sop.md](../outside-trucking-piazza-invoice-sop.md).

## Melissa's two PO types — and the conflict with the vault

In the 4 December message, quoted in full:

> **"Type 1: The PO the customer gives to us. This goes on the schedule job tab- we do not
> need this for any reporting. We just need it on our invoices for the customer to reference
> for payment on their side.**
>
> **Type 2: The PO that we give to our vendors to track our job cost / billing accurately –
> The Salesmen would need to reference the quote number within the PO screen."**

**This is not the same taxonomy as [../purchase-order.md](../purchase-order.md)**, which
splits POs by *what is being bought and who owns the process* (Type 1 = permit and vendor POs
owned by Liz Lopez in Dispatch; Type 2 = parts and maintenance POs owned by Jeff Stricker in
the warehouse). Melissa splits them by *direction* — inbound customer PO versus outbound
vendor PO. Both sources use the words "two PO types". Neither is verified. The conflict is
set out in full in [INDEX.md](INDEX.md) → *Stated conflict*; **do not answer "what are the
two PO types" from either page alone.**

## The end-to-end flow Melissa describes

Her "quick preview" of how the pieces tie together, in her sequence:

1. The PO screen is where the PO is made.
2. The **job tab** is where the **customer's** PO shows on the job screen.
3. There is an in-house comments tab — and this is where she raises the objection below.
4. **When AP receives the invoice from the vendor, they go to the PO screen and type in the
   PO number provided by the vendor.**
5. Once AP finds the invoice they can **attach the vendor's invoice to the job** if it is not
   already attached. This *"now automatically puts the vendors cost on the invoice screen for
   AR to see for billing purposes."*
6. That shows AR **what needs to be billed plus the mark-up**, and *"eliminates the manual
   entering of the material expenses costs for AR"*.
7. Those material expenses then **show up on reporting**, giving total profitability per job.

The claim in steps 5–7 — that vendor cost flows automatically from the PO/voucher through to
AR's billing screen and then to profitability reporting — is the stated *purpose* of the
whole PO discipline. Nothing in the drop demonstrates it working; Melissa presents it as her
first take, to be reviewed with Sammy.

## The unresolved objection

Verbatim, on the in-house comments tab:

> "Open that one tab to view the in house comments **This part we need to work through to see
> if we would use this step. The issue is the in house comments don't come up on reports so
> it wouldn't help ap find it. I think the quote or job # needs to be referened in the po
> screen, we can confrim with Courtney.**"

This directly undercuts the mechanism [PO-001](po-001-pre-job-purchase-orders.md) rule 2 and
[PO-003](po-003-linking-pre-job-pos-to-jobs.md) Step 2 both depend on — putting the Quote
Number in a comments field and searching on it later. **The drop contains no answer.** Note
that PO-001 and the walkthrough say the **Comments box on the PO [Main] tab**, while the FCC
Purchasing Guide distinguishes that header **Comments** field from a line-level **In House
Comments** field that is *"internal use only… only viewable from this window, and will not
print on any documents"*. Whether Melissa's objection is about the same field the P&Ps
specify is not settled by any source here.

## People named

Melissa McNutt (President), Brian Petros (Data Analyst), Wes Staley, Sammy / Sammy McKiernan
(has run the PO process more than Melissa; the sample SOP is hosted under her OneDrive),
Courtney (at Fleet Cost & Care — ran the walkthrough for the sales team and is the escalation
point for FCC behaviour questions).

## The full thread and its screenshots — parsed 2026-09-04

The `.msg` was re-read with a proper Outlook parser (`extract_msg`). The body came through
complete, and the **seven inline screenshots** Melissa refers to were recovered and read. Nothing
above is contradicted; what follows is what the string scan could not give.

**The thread, in order.**

| When | Who | What |
| --- | --- | --- |
| Mon 1 Dec 2025 14:22 | Melissa → Wes, Brian | *"FCC Needs"* — a nine-item agenda (below) plus the ask for three PO SOPs |
| Mon 1 Dec 14:47 | Brian → Melissa, cc Wes | Sends the three draft P&Ps; asks whether to share with Sammy or send to Courtney (FCC) for review first |
| Wed 3 Dec 11:55 | Melissa → Brian, cc Wes | Attaches `SOP - Outside Trucking.docx` as the *format* example; asks for simplified SOPs with visuals *"so if someone that has never seen FCC before can step by step follow"*: create a PO, add a PO to a job, find what job a PO belongs to. *"…so we can move forward using the automated invoice numbers through FCC."* |
| Wed 3 Dec 15:30 | Brian → Melissa, cc Wes | Will pull together the P&Ps, the FCC user guides and the Courtney meetings |
| Thu 4 Dec 08:51 | Melissa → Brian | Asks whether Courtney's walkthrough for the sales team was screen-recorded; offers Sammy's help; states the **two PO types**; walks the process in seven screenshots |

**The "FCC Needs" list (1 Dec).** Nine items that are *not* about POs, and that appear nowhere
else in the vault: **Power BI reporting demo** · **review current burden rates with Brent and
Courtney — the different burden rates for TRG and how to get their burden rates onto the work
orders** · whether **fringe cost can show on work orders for TRG**, or must be inside the burden
rate · **"Kits" for customers with special pricing** · **ATOM** · review the reports, which are
recommended, and whether the numbers are accurate · **utilization weekly as a report** · **job
checklists vs unit checklists** · **auto-filling the unit / job checklists**. Note **"TRG"** — a
second entity with its own burden rates, which is also the prefix on the `TCG-TRG_Org_Chart`
filenames. No source in the drop says what TRG is.

**The seven screenshots, in the order the 4 Dec message places them:**

1. *"Here is the PO screen to make the PO"* — `Purchase Orders` Main tab, `PO No AUTO`, Dept
   `OPERATED & MAINTAINED`, Vendor **`The Crane Guys`** (vendor code `THE003` — TCG set up
   *itself* as a vendor for the walkthrough), Order Date 12/03/2025, Terms Net 30, Comments
   *"Test"*.
2. *"…on the job tab where the customer's PO will be"* — `Schedule > Job` for test job
   **`OM56424`**, customer `The Crane Guys, LLC (CRA004)`, Salesperson/Checked/Taken By all
   *McNutt, Melissa*, status `Tentative`, **PO Number `CUSTOMER PO# 12345`** — the *Type 1* PO,
   on the job's Main tab. Related Information shows **`PO(s) 1`**, `Quote no quote`, Latest
   Invoice 12/3/2025.
3. *"Open that one tab to view the in house comments"* — the job's **In-House Comments** grid:
   one row, `PO # OM-1727`, with a **`For Invoice`** checkbox (unticked). This is the field
   Melissa says *"don't come up on reports"*.
4. The job's **Purchase Orders** panel: `OM-1727 · The Crane Guys · 12/3/2025 · $5,000.00` —
   the *Type 2* PO, attached to the job.
5. *"When AP receives the invoice from the vendor they will go to the PO screen and type in the
   PO number"* — `Enter > Invoices > Rental Invoices`, Main tab for job `OM56424`: Invoice Number
   `Auto`, **Export Status `Export Not OK`** (with an `Approved` flag), **PO Number `CUSTOMER
   PO# 12345`** carried onto the invoice with a **`Need PO`** checkbox, Terms Net 30, Due Date
   1/2/2026, Retain % / Retainage fields, all money fields $0.00.
6. *"…attach the vendor's invoice to the job… automatically puts the vendor's cost on the invoice
   screen for AR"* — the invoice's **Purchase Order** tab: `OM-1727 · The Crane Guys · Part
   PERMITS AND TRAFFIC CONTROL · Outside Permit and Traffic Control · Qty 1 · Qty Open 1 · Unit
   Cost $5,000.0000 · Extended $5,000.00`. So the vendor PO surfaces on the AR invoice screen as a
   line to be billed *"+ the mark up"*.
7. *"This is where the material expenses show up on our reporting"* — a job-profitability report
   row (Main Yard, salesperson Joe Deitrick): `Job No OM55497 · Southern California Edison ·
   Total Revenue $1,633.75 · Labor Hours 6.00 · Labor Expenses $411.21 · Union Expenses $213.00 ·
   WorkComp $21.34 · Burden $558.00 · Equipment $154.38 · Material Expenses $0.00 · Total
   Expenses $1,357.93 · Profit/Loss $275.82 · Profit% 16.88%` — with `Material Expenses` being the
   column the PO flow is meant to populate.

**What the screenshots add to the record.** The Type-1 customer PO lives in the job's `PO
Number` field and is copied to the invoice's `PO Number` with a `Need PO` flag — so *"we do not
need this for any reporting"* is literally how FCC treats it. The Type-2 vendor PO is what
appears under `PO(s)` and on the invoice's Purchase Order tab, and its part (`PERMITS AND TRAFFIC
CONTROL`) is the line AR marks up. And the `Export Not OK` status on a brand-new invoice is the
AR hold that PO-002 describes. The seven-column profitability report is the first sight in the
vault of how FCC breaks job cost into **Labor · Union · WorkComp · Burden · Equipment · Material**.

The remaining seventeen inline images are signature blocks, social-media icons and a digital
badge; the `.msg` carried no file attachments.

## Source

`1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/Re_ FCC Needs - (P&Ps for POs).msg`
— 1.6 MB Outlook .msg. First read by a UTF-16 string scan (body and headers clean, screenshots
not extracted); **re-parsed on 2026-09-04 with `extract_msg`** — full body, 24 inline images, of
which seven are the FCC screenshots transcribed above. Every
quotation above is verbatim from the recovered body, spelling included. Email addresses,
signature blocks and confidentiality notices were not copied.

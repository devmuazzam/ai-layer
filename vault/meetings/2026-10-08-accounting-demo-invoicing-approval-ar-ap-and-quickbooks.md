---
title: Accounting Demo — invoicing from completed tickets, sales approval, customer packet, AR/AP tracking with QuickBooks sync, collections check-ins, multi-company QuickBooks (8 October 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-10-08_Accounting demo_update - transcript.docx"
migrated: 2026-10-09
updated: 2026-10-09
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, module/vendors-agencies, module/payroll, module/admin, kind/meeting-notes, invoicing, purchase-orders, integrations, reporting, notifications, requirements]
meeting_date: 2026-10-08
---

# Accounting Demo — invoicing, sales approval, AR/AP and QuickBooks — 8 October 2026

Curated from [transcripts/2026-10-08-accounting-demo-invoicing-ar-ap-and-quickbooks-sync.md](transcripts/2026-10-08-accounting-demo-invoicing-ar-ap-and-quickbooks-sync.md)
(54 m 28 s). This was the *"accounting designs"* slot the
[2026-10-07 sprint review](2026-10-07-sprint-review-offline-tickets-holdover-and-mob-demob-sign-off.md) §10
booked for Thursday. **ehtesham.anwar** demoed the accounting flows on a shared screen. TCG speakers:
**Brent Wagstaff** (CFO), **Tia Brenneise** (Accounts Receivable), **Joe Schacatano** (VP of Sales),
**Brian Petros**, **Melissa McNutt**. **Sammy Garrett** (Controller) was present and said only goodbye.
CodingCops: ehtesham.anwar, abdulrehman, syed.haris. Roles are from
[../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md).

> **Status.** §2–§4 describe **designs** shown by CodingCops, not shipped code, and not a spec.
> ehtesham.anwar closed by saying TCG gave *"very little feedback on the call"* (50:30). §5–§8 are
> TCG asks and questions, none agreed as scope. Nothing here was decided in a way that warrants a
> decision note. The file is `status: unverified`.

## 1. Before the demo: payroll (1:32–5:18)

- **Samsara unit cleanup in FCC is still pending.** Brian is waiting on **Jeff Stricker** (1:58–2:21).
- **The union rep changed Brian's reading of the contract.** Brian *"was originally doing the payroll
  based on what the union contract says, but then the rep has … certain interpretations that
  complicate it"* (3:16–3:38). He is finalising TCG's internal payroll app against those, working
  through **lunch rules**, **"synthetic hours"** (*"hours that are not worked but they're added on
  to the labor entry"*) and how they interact with the **eight-hour rest rule** (3:57–4:18).
- **Brian will send a summary package**, *"probably by tomorrow"*, of the rules as he now reads them,
  without the FCC workarounds, for CodingCops to compare against the ERP (4:27–4:51). **Corrina** is
  back and still owes her response to the payroll-rules list CodingCops sent (2:29, 4:51).
- syed.haris: that list covers **payroll rules only, not the payroll flags** (3:01).
- The ADP test is on Friday 2026-10-09 (5:10).

## 2. Invoicing from completed tickets (6:28)

ehtesham.anwar walked one invoice end to end:

- **Tickets ready to invoice.** Accounting sees every ticket that can be invoiced, **even on a job
  still in progress**, marked **payroll-clean or not** and **completed or not**. A quick action
  **reminds payroll** to fix a ticket with payroll problems. Accounting can select **a whole day or
  one ticket**.
- **Preview before creation.** Line items with quantity, rate, amount and the **source ticket**;
  the ticket summary (total shift, travel and boom time); and every field-app step (pre-trip
  inspection, left yard, driving …) with its details, *"the verification of tickets that our
  accounting needs to do"*.
- **Quoted versus actual.** The preview flags a mismatch, e.g. a line quoted at 6 hours that worked 8.
- **Customer packet.** The documents of every selected ticket and job (permits, the customer PO …)
  gather automatically, and the user can add more. The packet stays editable after the invoice is
  created.
- **Create** makes the invoice in the ERP **and in QuickBooks at the same time**, linked. The invoice
  page shows customer, job, customer PO, QuickBooks connection and **QuickBooks invoice status**,
  line items, the packet, and the customer's terms.
- **What appears on the invoice follows the quotation configuration.** Tickets link to the quoted
  resources automatically. *Joe (27:20): "the only thing that's going to push through are the billing
  codes, correct?" ehtesham.anwar: "Yes."*

## 3. Sales approval, sending, and QuickBooks status (6:28, continued)

- **Send for approval** moves the invoice to *Awaiting Sales Approval*. Sales gets a new nav tab,
  **Invoice for Approval**, and can **approve** or **request changes**. Who requested what is logged.
- Accounting sees *Changes requested* on its **Invoiced** tab, edits, and **resubmits** with a
  comment. Sales sees *Resubmitted after changes* and approves. Sales can also add to the packet.
- Once approved, accounting **sends it to the client by e-mail** with the packet attached.
  ehtesham.anwar offered a **download-the-whole-packet** option as well. Status becomes *Sent to
  client*.
- **QuickBooks invoice status is pulled back automatically** and updates the ERP invoice.
- **But at 53:16 the send was described differently.** Brian asked for a view of the printed invoice
  before it goes to the customer. ehtesham.anwar: *"we are trying to run that flow through QuickBooks
  as it is right now. So we don't want anybody to download an invoice from our ERP and then send it to
  customer because we already have a process of sending the Invoices from the QuickBooks … we are
  going to fetch that view from the QuickBooks."* Which system sends the invoice was left there.

## 4. Accounts receivable and accounts payable (6:28–23:30)

**Accounts receivable.**

- A list of every invoice by customer: sent date, invoice number, amount, **open balance** (0 when
  paid, partial when part-paid). Search by customer, invoice, status and balance; filter by month;
  sort by date or amount.
- Header figures: **total outstanding (excluding retention)**, **0–30, 31–60 and 60+ days**, and
  **retention held** across all sent invoices.
- **Projections.** *"Since each invoice has the 10 day period where … our customers get the
  discount"*, that period is used to compute a **promised amount per week**, shown as projected
  against received, with a **goal** that can be set.
- A tracking board: transactions to bill, drafts, awaiting sales approval, ready to submit,
  submitted / awaiting payment, collection. The **Collections** tab tags invoices at **30** and
  **90 days** overdue so staff can follow up (17:28).

**Accounts payable.** Scoped to the **vendor POs that jobs already create** for permits, plans and
DAS allocations. Parts POs join when the maintenance module starts.

- **Receive an invoice** against a PO: upload it, enter invoice number, received date and amount,
  and compare the vendor on the invoice with the vendor on the PO.
- **Create the bill** in QuickBooks from there. The amount must equal the received invoice. The
  **vendor's PDF is attached** to the QuickBooks bill (25:22). **The PO closes when the bill is paid.**
- An AP list of vendors and bills with open balance and paid / partial / unpaid status.

**The QuickBooks boundary as presented.** *"All of the voucher creation, all of the crazy stuff that
you guys are doing in QuickBooks … You guys are still going to do that. We are not going to touch
that."* Invoice and bill statuses changed in QuickBooks are pulled back into the ERP.

## 5. TCG's questions about QuickBooks (23:30–31:06)

- **Brian (23:30–25:12):** today FCC creates the invoice and pushes it to QuickBooks, *"one-time,
  one-way"*. He asked what information is shared, and whether QuickBooks **blocks updates once an
  invoice reaches a certain status**, *"or does it have a reopen change status?"*. ehtesham.anwar
  answered the first part (the ERP creates the invoice through the API, tracks it, can update it and
  attach documents). **The locking question was not answered.**
- **Tia (28:05): an invoice sent a month ago needs a change or a credit memo. Is that done in
  QuickBooks or in the ERP?** ehtesham.anwar: *"I think we are going to incorporate that in here."*
  abdulrehman: QuickBooks appears to support two-way sync, to be confirmed by exploring the API.
- **What a credit memo is (29:32–30:16).** Tia: money taken off an invoice. Joe: the customer gets a
  **credit voucher** to apply to an open invoice or a future job, as a separate document processed
  through QuickBooks. ehtesham.anwar will check the discovery recordings and decide whether credit
  memos are created in the ERP or stay in QuickBooks.

## 6. Collections check-ins and reporting (31:06–43:38)

- **Brent's weekly collections task (32:29–35:33).** Every **Monday** he runs the list of invoices
  **over 30 days** *"as of"* that date, so it doesn't move during the week. He then contacts each
  customer. He wants that as a **checklist in the ERP**: tick a customer when contacted (*"I called
  or I emailed"*), record when, have it **drop off until next week**, and see who is left. Today it is
  a spreadsheet. ehtesham.anwar: *"I think we can add this"*, and will show an idea **on Tuesday**.
- **AR and AP reports (36:32–39:02).** What Brent needs is **AR total and AP total, each in aging
  buckets**, used to decide who to chase (AR) and to pay within terms (AP). He sees **no clear benefit
  in a netted AR-minus-AP report** but would try one. *"As of a date"* matters.
- **Graphs (40:13–43:38).** abdulrehman proposed charts. Brent wants **AR movement** for a period:
  opening balance, plus billed, minus received. He wants it company-wide and per customer, over
  months. He also wants **each customer's average days-to-pay**, used to project which customer will
  pay how much on which day this month. abdulrehman suggested AI forecasting on top, and the same
  graphs for other modules.

## 7. Other TCG asks (43:41–50:30)

- **Melissa (43:41): notify when a job's customer payment is marked paid in QuickBooks, so the
  subcontractor on that job can be paid.** ehtesham.anwar added the two rules he will build in:
  **LADWP:** subcontractors are paid **before** TCG bills LADWP. **Everyone else:** TCG is paid
  **before** it pays the subcontractor (44:08–44:35).
- **Brian (44:39–45:49): break AR down by type of service**, as FCC's reports can (e.g. *operated
  and maintained* cranes versus storage). ehtesham.anwar: these will come as the maintenance and
  storage modules are added.
- **Brian (46:43–49:21): two companies, two QuickBooks.** TCG has The Crane Guys and **The Repair
  Guys (TRG)** as separate organisations. QuickBooks holds one company per file, and **FCC allows many
  yards and companies but only one accounting connection** (Melissa, 50:04). Could the ERP connect to
  **several QuickBooks companies** and give one combined view, for reporting or as a working list of
  one customer's invoices across both companies? ehtesham.anwar: yes, through the APIs, to be worked
  out when the TRG and storage workflows are covered.

## 8. Next

- **CodingCops** sends the designs to TCG for feedback (50:30).
- **Brian** meets the accounting team to collect what else they need in these flows (50:30).
- **Tuesday 2026-10-13:** ehtesham.anwar shows Brent the collections check-in idea, the PO-paid
  workflow and the invoicing flow (51:20–51:29, 54:00).
- **QuickBooks access.** abdulrehman (51:31) asked to be invited to TCG's real QuickBooks account,
  with **syed.haris**, as developers, to explore the API on real data. Melissa can add a user but
  doesn't know developer access. **CodingCops e-mails who needs access, with instructions**
  (52:23–52:44).
- **Brian** sends the payroll-rules summary package (§1). **Corrina** answers the payroll-rules list.

## Against the vault

- **Shifts the boundary set on 2026-09-01.** [2026-09-01 §1](2026-09-01-accounting-boundary-and-erp-onboarding.md)
  recorded ehtesham.anwar saying QuickBooks keeps the books and *"we are not creating again an
  invoicing software … that would be foolish to build within the ERP"*, with the ERP taking reporting
  fed **from** QuickBooks. Here the ERP **originates** invoices and bills and pushes them **to**
  QuickBooks, as FCC does today (Brian, 23:53), and runs a sales approval before sending. The books
  (vouchers, ledger) still stay in QuickBooks, so this is a shift in who creates the invoice, not a
  reversal. It bears on [accounting/gaps.md → *Wishlist vs committed scope*](../accounting/gaps.md#wishlist-vs-committed-scope--nobody-has-tiered-the-accounting-list),
  where the 09-01 answer is recorded as the outer edge.
- **Credit memos are a QuickBooks task today.** On
  [2026-08-28](2026-08-28-accounting-process-discussion.md) they were shown being issued in
  QuickBooks (*Issue Credit Memo*, e.g. Edison's 2% discount), and the
  [team activity list](../accounting/accounting-team-quickbooks-and-spreadsheet-activities.md) gives
  them to Kaitlin. FCC's QuickBooks connector also maps credit memos
  ([nexgen-quickbooks-integration/01](../accounting/nexgen-quickbooks-integration/01-fcc-connector-field-mapping.md)).
  That is the material ehtesham.anwar said he would check (30:27).
- **The "10-day discount period on each invoice" is not in the vault.** The only payment-discount
  evidence is Edison's **2%** taken per its terms (2026-08-28). Whether every customer has a 10-day
  discount window, which the AR projection is built on, is unsourced.
- **Retention appears for the first time.** The AR design shows *retention held* and *outstanding
  excluding retention*. No accounting, quotation or customer file in the vault mentions retention
  (retainage) on invoices.
- **Consistent with the whiteboard flow** in
  [ap-ar-value-engine-and-whiteboard-flow.md](../accounting/ap-ar-value-engine-and-whiteboard-flow.md):
  ticket completeness starts billing, *Approve Tickets to Bill* is a gate (here the payroll-clean and
  completed markers), a *Mock Invoice* is reviewed (here the preview), **LADWP has its own path**, and
  **a subcontractor branch** pays the sub. Melissa's pay-the-sub notification (§7) is that branch.
  The whiteboard escalates collections at **90 days** to a lien. The design tags 30 and 90, while the
  [wishlist](../accounting/2026-07-accounting-team-erp-wishlist.md) lists reminders at days 15/30/45,
  a call at 46 and a hold at 90.
- **Matches the wishlist's reporting asks:** aging, *"payment history with average-days-outstanding"*
  per customer, and cash-flow forecasting. Brent's per-customer days-to-pay projection (§6) is the
  first time a TCG speaker described how they would use it.
- **Two companies.** [accounting/gaps.md → *GL codes*](../accounting/gaps.md#gl-codes--fccerp-chart-vs-quickbooks-and-who-owns-the-mapping)
  already records a GL account valid for both The Crane Guys and The Repair Guys. Brian's
  multi-QuickBooks question (§7) is new.
- **New, not in the vault:** sales approval of invoices (§3); Brent's weekly collections check-in
  (§6); AR movement and days-to-pay projections (§6); AR by type of service (§7); the
  pay-the-subcontractor notification and the LADWP pay-before-bill rule as stated here (§7).

## Candidates for a decision note (for `tcg-scrum`)

None. Nobody at TCG approved a design on this call, and the asks in §5–§7 were accepted by
CodingCops as ideas, not agreed as scope.

## 9. Questions this raises (not yet filed)

No ticket folder covers accounting yet. When one does, they belong in its spec §12. Until then they
are candidates for [accounting/gaps.md](../accounting/gaps.md).

1. **Which system sends the invoice to the customer:** the ERP's e-mail with the packet (§3), or
   QuickBooks as today (53:16)? And where does the customer packet go if QuickBooks sends?
2. **Credit memos and changes after sending:** created in the ERP and pushed, or kept in QuickBooks
   and synced back (Tia, 28:05)? Does QuickBooks lock an invoice at some status (Brian, 24:49)?
3. **Retention:** which customers or jobs hold retention, at what percentage, and when is it
   released and billed?
4. **The 10-day discount:** is it every customer's terms, or only some (e.g. Edison's 2%)?
5. **Sales approval:** which salesperson approves (the quote's salesperson?), and is every invoice
   routed, or only some?
6. **Pay-the-subcontractor rule:** is it "TCG is paid first" for every customer except LADWP, and
   does LADWP's pay-before-bill cover all its jobs?

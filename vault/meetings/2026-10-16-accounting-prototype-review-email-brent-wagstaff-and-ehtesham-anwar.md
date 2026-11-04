---
title: "Review of Accounting Workflow — Brent Wagstaff's written review of the accounting prototype, and Ehtesham Anwar's reply: status meanings, the proposed vendor-bill flow, days-to-pay, approval reminders, AP payment marking, cash flow and reports (e-mail, 16 October 2026)"
source: user-supplied/client e-mail thread "Re: Review of Accounting Workflow" — forwarded to CodingCops "FYI only" by Melissa McNutt or a colleague; relayed to tcg-scrum by the Claude Code session of syed.haris on 2026-10-20
original_file: none (e-mail thread; Brent's message relayed verbatim, Ehtesham's reply relayed as a close summary)
migrated: 2026-10-20
updated: 2026-10-20
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, module/vendors-agencies, module/quotations, kind/source, invoicing, purchase-orders, integrations, reporting, notifications, requirements]
message_date: 2026-10-16
---

# Review of Accounting Workflow — Brent's review of the prototype, and CodingCops' reply — 16 October 2026

An e-mail exchange about the accounting prototype at <https://tcg-accountin-demo.netlify.app/>.
It is the written review that
[2026-10-13 §6](2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md)
set up: *"CodingCops sends the accounting designs to TCG for review. TCG says what to add, remove,
or what data the ERP doesn't have."*

- **Brent Wagstaff** (TCG, CFO) wrote on Fri 2026-10-16 at 1:25 AM.
- **Ehtesham Anwar** (ehtesham.anwar, CodingCops PM) replied the same day at 3:18 AM.
- Ehtesham's separate demo-update message at 3:23 AM (Create & Link to QB always clickable, new
  invoices at the top of *Invoiced*, a sidebar Reset, *Avg. days to pay* bands, the detailed reports)
  is the build that answers several of Brent's points. It is recorded with
  [../decisions/2026-10-20-holdovers-billed-weekly-or-monthly-other-jobs-daily-one-job-per-invoice.md](../decisions/2026-10-20-holdovers-billed-weekly-or-monthly-other-jobs-daily-one-job-per-invoice.md)
  only as context. It is not a client decision.

Roles are from [../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md).

> **Status.** **Brent's e-mail (§1) is client-stated**: questions and asks from TCG's CFO, in
> writing. **None of it is a decision.** He approves nothing and chooses between nothing.
> **Ehtesham's reply (§2) is CodingCops' answers and proposals**: what the prototype means, how it
> could work, and questions back to Brent. Every one of those questions is unanswered as of
> 2026-10-20. The relay was *"FYI only"*. The file is `status: unverified`.
>
> **Provenance.** Brent's message is verbatim as relayed. Ehtesham's reply was relayed as a close
> summary, not the full e-mail. Quoted fragments in §2 are the relay's wording.

## 1. Brent Wagstaff's e-mail — verbatim (Fri 2026-10-16, 1:25 AM)

The indentation follows the relay. Each indented line is a question or ask under the prototype
section named above it.

```
Billing codes
      what does inactive categories mean
Price List - nothing right now
Tickets for Invoicing
      In invoiced what does pending approval and changes mean in status
Vendor Bills
      do we have description of status's
Accounts Receivable
      collections tab. Add average days paid so we can have forecasting for when to expect payments
      when invoices are waiting for approval what kind of reminders are sent(interval)?
      Can we have a tab made for Accounts Receivable like Accounts Payable v2?
Collections - nothing right now
Accounts Payable 
Accounts Payable v2
      Can we mark invoices to be paid? We send for payment to bank and they are paid?
      Can we mark invoices for partial payment?
CashFlow Overview
      Can we have a Forecasted cashflow and actual cashflow?
      Are View reports buttons available for use? Doesn't seem to work.
```

*"nothing right now"* (Price List, Collections) is read as *no comments on that section*. Brent
does not say whether *Accounts Payable* (no line under it) is approved or simply not commented on.

## 2. Ehtesham Anwar's reply (Fri 2026-10-16, 3:18 AM) — CodingCops answers and proposals

**Everything in this section is CodingCops' explanation or design. It is not TCG's.**

### Billing codes

- *"Inactive"* means categories or billing codes that are no longer used can be marked inactive,
  and their history is kept.

### Tickets for Invoicing

- **Pending Approval:** the invoice is waiting for the salesperson's approval.
- **Changes Requested:** the salesperson reviewed it and asked for changes.
- An invoice-open bug was fixed.

### Vendor Bills — the statuses as built in the prototype

| Status | Meaning (CodingCops) |
| --- | --- |
| Requested | Payment of the vendor invoice is requested, so the customer invoice can proceed |
| To Verify | The vendor invoice is attached. The bill is not yet created in QuickBooks |
| Ready to Bill | The customer invoice is processed. The vendor bill can be created in QuickBooks |
| Held | The bill is created. Payment is on hold until the customer pays TCG |
| Released | The customer paid TCG. The vendor bill can be paid |
| Paid | Paid |

### Vendor Bills — PROPOSED simplification: create the QuickBooks bill only when it is ready to pay

**Case 1. The vendor is paid after the customer pays TCG.**

`PO Open → Invoice Received → Held → Released / Ready to Bill → Pending Payment → Paid`

- Held → Released is automatic when the customer pays TCG.
- The user clicks **Create Bill** in the ERP. That creates the QuickBooks bill, and the status
  becomes Pending Payment.
- When full payment is recorded in QuickBooks, the status becomes Paid.

**Case 2. The vendor must be paid before the customer invoice is sent.**

`PO Open → Invoice Received → Requested → Ready to Bill → Pending Payment → Paid`

- **Create Bill** makes the status Pending Payment.
- Payment recorded in QuickBooks makes it Paid.

Ehtesham asked Brent whether these align with his process. **Unanswered.**

### Accounts Receivable

- **Average days to pay** was added to Collections, per customer. The bands are green ≤45 days,
  amber 46–60 and red >60 (the 3:23 AM demo update). The bands are CodingCops' choice.
- **Reminders for invoices waiting for approval:** in-app notifications are planned, and e-mail
  is possible. **No interval is agreed.** Ehtesham asked Brent what interval he wants.
- **An AR tab like AP v2:** Ehtesham asked Brent to clarify which layout or features he means.

### Accounts Payable v2

- **Marking bills to be paid, or "sent to bank":** today the bills are created and managed in
  QuickBooks, and their paid status syncs back to the ERP. Selecting bills for payment and tracking
  *"Sent to Bank"* would be an additional workflow, still to be defined.
- **Partial payment: yes.** It is recorded against the vendor bill in QuickBooks. The ERP shows the
  status and the outstanding balance.

### Cash Flow Overview

- **What the page does now:** it compares forecast customer collections with actual QuickBooks
  receipts.
- **Questions back to Brent:**
  - Expected against actual for both receipts **and** payments, with the difference highlighted?
  - Customer receipts and vendor payments only, or also payroll, overhead, taxes and loans?
  - Weekly, monthly, or both?
  - Opening and closing cash balances from QuickBooks bank data?
  - A sample of an existing cash-flow report.
- **View Reports** buttons are now built: AR & AP Ageing, Cash Forecast, Collections Performance.
  Ehtesham asked which breakdowns each report should include.

## 3. What Brent asked for — client-stated asks, none yet agreed as scope

| Ask, Brent's words | Seen before in the vault | Where it stands |
| --- | --- | --- |
| *"collections tab. Add average days paid so we can have forecasting for when to expect payments"* | Third time. [2026-10-08 §6](2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md) (*each customer's average days-to-pay*); [2026-10-13 §6](2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md) (days-to-pay forecasting); [wishlist](../accounting/2026-07-accounting-team-erp-wishlist.md) (*"payment history with average-days-outstanding"*) | **Client ask, built in the prototype.** The 45/60 bands and how the forecast uses the figure are CodingCops design |
| *"when invoices are waiting for approval what kind of reminders are sent(interval)?"* | Sales approval itself is CodingCops design ([2026-10-08 §3](2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md)). In FCC today the salesperson runs a report of invoices awaiting approval ([../vendors-agencies/purchase-orders-fcc/po-002-vendor-billing-and-customer-invoicing.md](../vendors-agencies/purchase-orders-fcc/po-002-vendor-billing-and-customer-invoicing.md) Step 4, `unverified`) | **A question, not an ask.** He expects reminders, but neither the interval nor the channel is set. Open |
| *"Can we have a tab made for Accounts Receivable like Accounts Payable v2?"* | AP per vendor, paid / unpaid / partial ([2026-10-13 §6](2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md), Brent 31:05) | **Client ask.** What he means is unclarified. Open |
| *"Can we mark invoices to be paid? We send for payment to bank and they are paid?"* | Not in the vault. QuickBooks keeps the books (2026-09-01 boundary, [../accounting/gaps.md → *Wishlist vs committed scope*](../accounting/gaps.md#wishlist-vs-committed-scope--nobody-has-tiered-the-accounting-list)) | **A question with an implied ask.** Whether it is in scope is open |
| *"Can we mark invoices for partial payment?"* | Partial payments shown per vendor ([2026-10-13 §6](2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md)) | **Client ask.** CodingCops says yes, recorded in QuickBooks. Brent has not confirmed that is enough |
| *"Can we have a Forecasted cashflow and actual cashflow?"* | Cash-flow overview design ([2026-10-13 §6](2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md)); AR movement with an opening balance ([2026-10-08 §6](2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md)); wishlist *"13-week projected balance (payroll, vendors, collections, loans, taxes)"*; the *Cashflow Tracker* sheet ([../accounting/accounting-team-quickbooks-and-spreadsheet-activities.md](../accounting/accounting-team-quickbooks-and-spreadsheet-activities.md)) | **Client ask.** Scope, cadence and balances are open |
| *"do we have description of status's"* (Vendor Bills); the meanings of *inactive*, *pending approval* and *changes* | — | **Questions.** Answered by CodingCops in §2. They are definitions of a design, not TCG rules |
| *"Are View reports buttons available for use? Doesn't seem to work."* | — | **Prototype defect.** Now built. The breakdowns are open |

## Against the vault

- **When the QuickBooks bill is created has now been shown three ways, and nothing at TCG has
  chosen.** None of these is a decision:
  - **At receipt:** [2026-10-08 §4](2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md)
    and [2026-10-13 §3](2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md):
    *"Create bill"* sends it to QuickBooks at the invoice amount when the vendor invoice is received.
  - **After the customer invoice is processed:** the prototype's own statuses (§2, *Ready to Bill*
    and then *Held*).
  - **Only when ready to pay:** this proposal.

  The verified
  [../decisions/2026-10-13-vendor-invoice-attachment-goes-to-quickbooks-with-the-bill.md](../decisions/2026-10-13-vendor-invoice-attachment-goes-to-quickbooks-with-the-bill.md)
  says only that the vendor's invoice document goes to QuickBooks **with** the bill. Its exchange
  quotes the 10-08 design (*"whenever we are going to create the QuickBooks bill"*). It is
  compatible with any of the three timings. Under the proposal, though, the document reaches
  QuickBooks only at payment time. **Not resolved here.**
- **A consequence of the proposal to check with Brent (inference, not a source):** a bill held
  until the customer pays would not exist in QuickBooks while it is held. Brent described paying
  from AP aging *"within terms"*
  ([2026-10-08 §6](2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md)) and
  owed-versus-paid per vendor
  ([2026-10-13 §6](2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md)),
  and the AP view reads QuickBooks. So held liabilities would be missing from QuickBooks' AP until
  release. Whether that matters to TCG is a question for Brent.
- **Which vendor bills wait for the customer's payment is still unsourced.**
  - On [2026-10-08 §7](2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md),
    ehtesham.anwar stated the rule as one for subcontractors: TCG is paid first, except LADWP, where
    subcontractors are paid before TCG bills.
  - On 2026-10-13 the demo applied the hold to a permit bill.
  - Case 1 and Case 2 here split the bills the same way, but name no rule for which bill falls
    into which case.
  - Both meetings list the question as unfiled (10-08 §9 Q6, 10-13 §10 Q2). It is now filed in
    `accounting/gaps.md` (see §4).
- **Case 2 puts a blocker on the customer invoice that TCG has not confirmed.** The vendor must be
  paid before the customer invoice is sent.
  - The related 10-13 bills-received blocker is recorded as **proposed, not agreed** in the
    vendor-attachment decision.
  - FCC's draft SOP holds customer invoices *"Waiting on Sub"* until sub bills are received and
    vouchered: [po-002](../vendors-agencies/purchase-orders-fcc/po-002-vendor-billing-and-customer-invoicing.md)
    Steps 2–3, `unverified`. That is about **receipt**, not **payment**.
- **The PO's own status is still split, and the proposal adds a status chain beside it.**
  - [../decisions/2026-09-11-po-closed-means-closed-out-not-cancelled.md](../decisions/2026-09-11-po-closed-means-closed-out-not-cancelled.md)
    (`reference`, CodingCops): a PO auto-closes when an Invoice-category attachment is uploaded.
    Under the proposal that is *Invoice Received*.
  - The 10-08 design closes the PO when the bill is paid.
  - The proposed chain starts at *PO Open* but says nothing about when the PO closes.
- **Invoice-approval status names drift between designs.**
  - 2026-10-08 §3: *Awaiting Sales Approval*, *Changes requested*, *Resubmitted after changes*.
  - This reply: *Pending Approval*, *Changes Requested*.

  Both are CodingCops design, so there is no conflict with a TCG source. Who approves, and whether
  every invoice is routed, is still 10-08 §9 Q5, unfiled. It is noted in the reminder entry.
- **Days-to-pay fits the verified customer-level collections decision.**
  [../decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md](../decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md)
  makes the worklist per customer, and the average is per customer. The 45/60 bands have no TCG
  source. The wishlist's collection reminders at days 15/30/45, a call at 46 and a hold at 90 are a
  different thing (collections, not approval).
- **Billing-code and category "inactive"** has no source in `quotations/` (searched
  `quotations/billing-code-and-price-list.md` and `quotations/gaps.md`). Ehtesham's definition is
  design.
- **Cash flow.** The wishlist's *"13-week projected balance (payroll, vendors, collections, loans,
  taxes)"* bears directly on Ehtesham's scope and cadence questions. It is a July client wishlist,
  never tiered, so it does not answer them.
- **New, not in the vault:** marking AP bills for payment or *"sent to bank"*; an AR tab modelled
  on AP v2; forecast-against-actual cash flow as Brent's own ask; approval reminders.

## Candidates for a decision note (for `tcg-scrum`)

**None.** Brent asked questions and made asks. He chose nothing, and none of Ehtesham's proposals
was answered. Do not record the proposed vendor-bill flow as decided until Brent replies.

## 4. Questions this raises — filed 2026-10-20

No ticket owns accounting, so these are in [../accounting/gaps.md](../accounting/gaps.md):

1. [*Vendor-bill flow — when is the QuickBooks bill created, and which bills wait for the customer's payment?*](../accounting/gaps.md#vendor-bill-flow--when-is-the-quickbooks-bill-created-and-which-bills-wait-for-the-customers-payment)
   (folds in 10-08 §9 Q6 and 10-13 §10 Q2). Pointer in
   [../vendors-agencies/gaps.md](../vendors-agencies/gaps.md).
2. [*Invoice-approval reminders — what interval, and by what channel?*](../accounting/gaps.md#invoice-approval-reminders--what-interval-and-by-what-channel)
3. [*"An AR tab like Accounts Payable v2" — what does Brent want on it?*](../accounting/gaps.md#an-ar-tab-like-accounts-payable-v2--what-does-brent-want-on-it)
4. [*AP payment marking — selecting bills for payment, "sent to bank", and partial payments: ERP or QuickBooks?*](../accounting/gaps.md#ap-payment-marking--selecting-bills-for-payment-sent-to-bank-and-partial-payments-erp-or-quickbooks)
5. [*Forecast vs actual cash flow — what it covers, how often, and from which balances*](../accounting/gaps.md#forecast-vs-actual-cash-flow--what-it-covers-how-often-and-from-which-balances)
6. [*Accounting reports — what breakdowns each View Reports report needs, and the days-to-pay bands*](../accounting/gaps.md#accounting-reports--what-breakdowns-each-view-reports-report-needs-and-the-days-to-pay-bands)

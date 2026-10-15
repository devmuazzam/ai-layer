---
title: "The vendor's invoice document, attached when a vendor bill is recorded against a PO, goes to QuickBooks with the bill (Brent Wagstaff, 2026-10-13) — decision"
source: decision/client recorded call (Brent Wagstaff, CFO, Accounting and Safety discussion, 2026-10-13)
decided: 2026-10-13
decided_by: >-
  Brent Wagstaff (TCG, CFO; per the unverified admin/engagement-directory-and-org-charts.md;
  Accounts Payable reports through him), on the recorded 2026-10-13 Accounting and Safety discussion
  (meetings/2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md §3;
  transcript meetings/transcripts/2026-10-13-accounting-and-safety-discussion.md, 21:49–22:17).
  Brent asked whether the attachment is "fed to QuickBooks or does that just stay here".
  ehtesham.anwar (CodingCops) answered "That's your decision" and offered either. Brent: "Yeah, I
  like, I like it in QuickBooks." (22:17). It is one line, but it is an explicit choice between two
  named options, made by the person the choice was put to. It confirms what ehtesham.anwar had
  described on 2026-10-08 (transcript 25:22). Not confirmed in writing. Recorded by tcg-scrum on
  2026-10-15 at the request of syed.haris (CodingCops).
status: verified
conflicts_with: []
resolves: []
related_decisions:
  - 2026-09-05-po-types-and-quote-to-invoice-workflow.md
  - 2026-09-11-po-closed-means-closed-out-not-cancelled.md
jira: []
tags: [module/accounting, module/vendors-agencies, kind/decision, purchase-orders, integrations, invoicing]
---

# The vendor's invoice document goes to QuickBooks with the bill

## Decision

Brent Wagstaff, 2026-10-13: **when a vendor bill is recorded in the ERP against a PO, the vendor's
invoice document attached to it is sent to QuickBooks along with the bill.** It does not stay in the
ERP only.

## The exchange — verbatim

Source: [../meetings/transcripts/2026-10-13-accounting-and-safety-discussion.md](../meetings/transcripts/2026-10-13-accounting-and-safety-discussion.md).

> **ehtesham.anwar (20:03):** *"and then the amount of the invoice. Attach the invoice. itself that is
> received …"*
>
> **ehtesham.anwar (20:29):** *"… Once you review all of this, you can create a bill on it. This
> creation of bill is going to go over into the queue. It's going to pull up the invoice amount. You
> can save and link to QB."* ("the queue" is left unresolved in the transcript, possibly *QB*.)
>
> **Brent Wagstaff (21:49):** *"Mm. Okay, real quick, if you, we have attaching like an invoice on here,
> does that get fed to QuickBooks or does that just stay here? Is that, does that make sense?"*
>
> **ehtesham.anwar (22:04):** *"Mhm. Yeah, it does make sense. That's your decision. If you want this
> attachment to go over into the bin, ABI can do that. So we can."* ("into the bin, ABI can do that"
> is left unresolved in the transcript, probably *"into QB, we can do that"*. Brent's question names
> QuickBooks, so the choice is clear either way.)
>
> **Brent Wagstaff (22:17):** *"Yeah, I like, I like it in QuickBooks."*

**The design it confirms, 2026-10-08.** Source:
[../meetings/transcripts/2026-10-08-accounting-demo-invoicing-ar-ap-and-quickbooks-sync.md](../meetings/transcripts/2026-10-08-accounting-demo-invoicing-ar-ap-and-quickbooks-sync.md).

> **ehtesham.anwar (25:22):** *"… within the vendor bills, whenever we are going to create the
> QuickBooks bill, we are going to send the PDF, the invoice PDF that we received. with the QuickBook
> bill. So whenever you are going to see the QuickBook bill within the QuickBooks, you are going to see
> bill all of the line items and then the attachment as well that we send there."*

## Why

Brent gave no reason on tape. The context: under the 2026-09-01 boundary QuickBooks keeps the books
([../accounting/gaps.md → *Wishlist vs committed scope*](../accounting/gaps.md#wishlist-vs-committed-scope--nobody-has-tiered-the-accounting-list)),
so the bill and its source document sit together where AP pays it.

## What was not decided

- **Whether the ERP keeps its own copy.** Brent chose QuickBooks over "just stay here". He did not
  say to remove it from the ERP. The §4 design reuses vendor documents in the customer packet, which
  needs them in the ERP. That is design, not decided.
- **Other vendor documents.** Only the vendor's invoice was discussed. Supporting documents such as
  Piazza Trucking's employee tickets (§4) were not.
- **The customer setting for vendor documents (§4).** Brent asked for automatic for some customers
  and drag-and-drop for others (25:35), and Melissa said it should be a customer setting (26:15).
  The details were not settled. Which customers it applies to is unresolved (*"pool companies"* as
  transcribed).
- **The bills-received blocker (§4).** ehtesham.anwar (26:21): if the customer setting is on, every
  third-party bill on the job must be received before the invoice can be created. **Proposed, not
  agreed.** Brent's reply is *"Cost. Yeah."* as transcribed (26:41).
- **Holding payment until the customer pays.** The demo showed a permit bill that could not be paid
  until the customer's invoice was paid (21:28). Nobody at TCG confirmed it on 10-13. On 10-08 it was
  a subcontractor rule with an LADWP exception. Question 2 of the curated notes' §10 covers it, and
  it is not yet filed.
- **The amount on the bill.** It is logged at the vendor's amount, and the markup goes only on TCG's
  invoice to the customer (Melissa 21:09–21:15). That is a separate statement, not part of this
  decision. It matches the vault (curated notes, *Against the vault*).

## Conflicts and interactions

- **No decision-note conflict.**
- **When a PO closes is not touched here, and the record is split.**
  [2026-09-11-po-closed-means-closed-out-not-cancelled.md](2026-09-11-po-closed-means-closed-out-not-cancelled.md)
  (`reference`, CodingCops) auto-closes a PO when an Invoice-category attachment is uploaded to it.
  The 2026-10-08 design ([../meetings/2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md](../meetings/2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md)
  §4) closes the PO when the bill is paid. This note does not reconcile them.

## Effect on the vault

- No status flips. No register entry closed.

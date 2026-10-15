---
title: Accounting and Safety Discussion — invoicing by whole day, vendor bills and the customer packet, collections tab, AP and cash-flow views, safety field audits (13 October 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-10-13_Accounting and Safety discussion - transcript.docx"
migrated: 2026-10-15
updated: 2026-10-15
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, module/vendors-agencies, module/field-ops, module/payroll, kind/meeting-notes, invoicing, purchase-orders, integrations, reporting, holdover, safety, inspections, requirements]
meeting_date: 2026-10-13
---

# Accounting and Safety Discussion — day invoicing, vendor bills, collections, field audits — 13 October 2026

Curated from [transcripts/2026-10-13-accounting-and-safety-discussion.md](transcripts/2026-10-13-accounting-and-safety-discussion.md)
(transcribed 0:27–1:01:35; the recording header says 3 h 8 m, but transcription stopped at 1:01:35; syed.haris confirmed on
2026-10-15 that nothing of substance followed).
This was the Tuesday follow-up the [2026-10-08 accounting demo](2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md) §8
booked. **ehtesham.anwar** showed revised accounting designs on a shared screen, then opened discovery on
**safety field audits**. TCG speakers: **Brent Wagstaff** (CFO), **Tia Brenneise** (Accounts
Receivable), **Melissa McNutt** (President), **Kyle Harlow** (VP of Fleet and Field Operations),
**Dennene "Dee" Jones** (Safety Manager), **Joe Schacatano**, **Brian Petros** (Data Analyst, ERP
Project Coordinator), and "IT Support" (probably **Patrick McKiernan**). CodingCops: ehtesham.anwar,
abdulrehman. Roles are from [../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md).

> **Speaker labels are wrong for the safety half.** From 36:41 Dee speaks on Brian Petros's microphone,
> as on [2026-09-29](2026-09-29-safety-discussion-onboarding-certifications-incidents-and-facility-compliance.md).
> Every safety-process statement in §8 that the transcript labels "Brian Petros" is attributed here to
> Dee. The transcript header lists the evidence and the turns that are probably Brian's own.

> **Status.** §2–§6 are **designs** shown by CodingCops, not shipped code and not a spec. One point was
> agreed by TCG on the call: invoicing by whole day (§2), listed under *Candidates for a decision note*.
> §8 is TCG describing its current, manual audit process and what it would like. The file is
> `status: unverified`.

## 1. Before accounting (0:27–7:41)

- **Crane photos and names.** Brian photographed the cranes in the yard (number on the side, CA number,
  licence plate) for his reconciliation of FCC units against Samsara (1:29–2:13). Kyle: **Noah** (social
  media) plans **one media folder per machine** in a shared location (2:13–2:48). Most cranes have
  names, given in turn by Kyle, Melissa, Joe and Wes as they are bought (3:08–3:24).
- **Payroll.** Brian spent the weekend on TCG's internal payroll logic. He moved **lunch handling from
  the end of the flow to the beginning**, which cascaded through the rest (4:35). He expects a summary of
  the suggested flow *"in a few days"*, for CodingCops to compare (4:35–5:51). On
  [2026-10-08](2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md) §1 it was *"probably
  by tomorrow"*. abdulrehman is building the payroll manager/admin adjustment workflow. syed.haris has
  the core calculations (3:47).
- **Local 12 is the hard case.** Brian: a vendor of another ERP (*"Rib Yacht"* as transcribed) said
  Local 12 has by far the most complicated rules of the unions it knows. It named Bragg as a company
  working with about 11 unions (6:13). abdulrehman and ehtesham.anwar: the rules will become per-tenant
  configuration when the product is sold as SaaS (7:02, 7:56).

## 2. Invoicing by whole day, not by ticket (7:56–19:17)

- **The question.** The design lets accounting pick one ticket, or several tickets across days. TCG's
  current process, as seen in demos, invoices one ticket at a time (7:56–9:36).
- **What a ticket is, as ehtesham.anwar explained it (9:57–13:42).** One ticket per **allocation**.
  The operator and oiler share one ticket, which the oiler fills in. Each person on a support vehicle has
  their own. An allocation can run **up to 48 hours**. A crew scheduled on two separate days gets two
  tickets. How many tickets a job produces depends on how Lisette schedules it.
- **The proposal (13:42).** Accounting selects a **day**, and every ticket of that job on that day is
  selected automatically. This avoids missing a ticket by mistake. **If any ticket that day is
  payroll-flagged, the whole day cannot be invoiced** until payroll clears it (14:47–16:14).
- **Melissa (15:06):** *"we'd want to hold the invoice until the payroll is figured out because we charge
  based off the hours … we don't want to bill the customer and have to rebill."* **Days are independent**
  (17:19): Wednesday can be billed while Tuesday waits on payroll. Several days can go on **one invoice**
  (17:47–17:54).
- **Agreed.** Brent (18:38): *"is there a situation when you don't pull all five?"* Tia: *"No."* Brent:
  *"So I think we can do it by day."* ehtesham.anwar (18:58): days blocked by ticket rules are logged, a
  day is billed once it becomes available, and several days can be grouped.
- **Holdover.** Tia (17:34) would not bill a holdover day by day (*"I went bill each day individually"*
  as transcribed). ehtesham.anwar: a holdover job is **invoiced once, as a whole job**. Holdover designs
  are being finalised this week, hopefully built by Friday 2026-10-16 (17:47).

## 3. Vendor bills (19:20–22:17)

- **Receiving a vendor invoice against a PO.** Choose the PO (permit, job work …). The vendor comes from
  the PO. Enter the invoice number, received date, due date if given, and amount, and attach the invoice.
  A linked permit opens in a new tab. **Create bill** sends it to QuickBooks at the invoice amount.
- **Markup.** Melissa confirmed that the percentage TCG adds to third-party costs goes **only on TCG's
  invoice to the customer**, not on the vendor's bill to TCG (21:09–21:15). The bill is logged at the
  vendor's amount.
- **Payment is held until the customer pays.** The demo bill (a permit) showed it could not be paid out
  until the customer invoice it belongs to is marked paid (21:28).
- **Brent (21:49–22:17): the vendor invoice attachment should go to QuickBooks.** *"I like it in
  QuickBooks."*

## 4. Vendor documents in the customer packet (22:20–26:46)

- When the invoice is created, every bill received against the job's POs is listed, and its documents
  can be attached to the relevant lines.
- **The proposal (22:20):** attach the documents the customer needs when the vendor bill is recorded.
  Example: Piazza Trucking sends its employee tickets with its invoice. They are then available, or added
  automatically, when the customer packet is built.
- **Brent (25:11, 25:35):** not every customer needs these documents, and TCG doesn't want to send them
  to the ones that don't. He asked for **automatic for some and drag-and-drop for others**. **Melissa
  (26:15):** make it a **customer setting** (*"your pool companies"* as transcribed, unresolved).
- **ehtesham.anwar (26:21):** a customer setting. When it is on, **every third-party bill on the job must
  be received before the invoice can be created**, a blocker like the payroll flag. Nobody at TCG
  confirmed the blocker. Brent's reply is *"Cost. Yeah."* as transcribed.

## 5. Collections tab (26:46–30:23)

This is the design answer to Brent's weekly collections ask on
[2026-10-08](2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md) §6.

- **One row per customer, not per invoice**, showing overdue (30+ days) and aging invoices. Click through
  to see the customer's pending invoices. There is a KPI strip at the top.
- **Log a call:** reached or not, **promise to pay** (date and amount, with a quick-select for the full
  amount), notes, next follow-up. Outcomes include left voicemail, no answer, e-mail and disputed. Logged
  customers drop into *done for the week*, and the rest stay in *still to contact*.
- **Brent (28:01):** *"We definitely want it at the customer level. … that's what we're looking for."*
- **Past weeks (29:05–29:37).** Brent asked to look back at an earlier week. ehtesham.anwar offered a
  week date-range selector. Past contacts already show at the bottom of a customer's view, and Brent:
  *"Maybe that would be enough then."*
- **Source.** AR flows from invoices created in the ERP. An invoice joins collections when it reaches
  30+ days (29:54–30:23).

## 6. Accounts payable and cash flow (30:25–36:24)

- **AP view.** QuickBooks status shows what was paid this week and what is unpaid. A *bills due this week*
  view can come from the bill due dates or from an SLA TCG sets. ehtesham.anwar doesn't know the SLAs.
- **Brent (31:05): paid and unpaid per party**, e.g. $10,000 owed, $7,000 paid. ehtesham.anwar: select a
  vendor to see its bills as paid, unpaid or partially paid, with the totals following the filter. Brent:
  this replaces *"another one of the side spreadsheets that we run"* (32:14).
- **Cash-flow overview (32:41).** Balances, activity by month, forecasts (this week, rest of month, next
  30 days), customer and vendor filters, receivables against payables.
- **Days-to-pay forecasting (33:15–35:10).** Brent asked again for a forecast of when each customer will
  pay, from payment date against invoice date. ehtesham.anwar: a model once ERP data flows, possibly
  seeded from QuickBooks history. **Brent: don't spend much time loading past data.** Maybe a few
  customers to test it, only if it's quick.
- **Next step for these designs.** CodingCops sends the accounting designs to TCG for review. TCG says
  what to add, remove, or what data the ERP doesn't have (35:21–36:24).

## 7. What changed since 2026-10-08

- **Invoice selection.** The 10-08 design let accounting select *"a whole day or one ticket"*. Now it is
  **whole days only** (§2).
- **Collections.** The 30/90-day tags of the 10-08 tracking board became a **customer-level collections
  tab** with call logging (§5).
- **New on this call:** vendor bills with due date and attachment (§3), the customer setting for vendor
  documents (§4), and the cash-flow overview (§6).

## 8. Safety: field audits (36:24–1:00:47)

Field audits were the topic the [2026-09-29 safety discussion](2026-09-29-safety-discussion-onboarding-certifications-incidents-and-facility-compliance.md) §8
left for a later session.

**How it works today (Dee, 37:28–45:54).**

- Operators' field packages (their paperwork) go into a **box outside the safety office door**.
- Dee's **field auditors** visit job sites, fill in **paper** audit forms, and type them into **Excel**
  back at the office. They have tablets but don't use them for the forms (40:43).
- The spreadsheet has a **monthly tab** (e.g. September) that feeds a **coaching completed** tab by
  formula. It has dropdowns, but auditors don't use the same words, so the data is hard to search
  (43:27–44:37).
- **Photos and videos** of the crew's forms, the crane and the set-up go to a **Teams channel/folder**,
  separate from the spreadsheet (44:37–45:42).
- Dee sorts packages from the operators and the auditors by job by hand. *"My fear is someone's gonna
  ask me for a package on the job … and I'm gonna have to scramble to find it"* (39:37).
- **What she wants:** **one place, by job number**, with every package from that job: the operators', the
  auditors', and anyone else who was there (38:08–38:28, 45:42).

**How jobs are picked for audit.**

- Today: by **job type and area** (e.g. start in the Inland Empire and work down). Auditors pick one job
  they want and fit others around it (46:18).
- **Melissa (46:40–47:01):** the ERP should track **when each employee was last audited**. Example:
  *"Devin Kelley … hasn't been audited in three weeks. Here's his job and … four other jobs in the
  surrounding area."* It should suggest an efficient route. An auditor can override with a project they
  need to visit and be rerouted to the nearest jobs. Dee (52:53): *"We want to make sure that every
  employee is being seen."*
- **Kyle (47:23): manager sign-off.** **Jeff Kelley** (Crane Superintendent) reviews audits for coaching
  beyond what the safety team did. He should be alerted to audits waiting for his sign-off.
  ehtesham.anwar: add it to the existing crane-super view (48:05).

**What an audit is.**

- The auditor checks that what the crew's package claims is true: the huddle happened, PPE is worn, and
  the crane is set up as it should be (51:52–52:17).
- **Kyle (53:02):** a safety-team visit counts as an audit, and **the audit form is always the same**.
  What varies is the forms the crew uses on different jobs. Dee (49:41): *"Safety uses the same
  document."*
- **Forms.** There are many form types, and which ones are used depends on the visit and the job
  (49:24–49:41). Today they sit in a cubby and auditors take what they need. Joe (49:53): a **dropdown to
  select the forms that apply** to the job.
- **ehtesham.anwar (48:30): the whole workflow on the iPad**, with an office dashboard on the web, and no
  second way of entering the data.
- Melissa (53:46–53:52): the audit forms are **not** in the field app today.

**The on-site scope of work (54:11–56:31).**

- **Kyle:** it has to stay on paper, displayed on the windshield, *"according to the cost"* (as
  transcribed; the document is unresolved). Joe (55:12): *"it just states it has to be done."*
- **ehtesham.anwar:** make a photo of it a step before starting work. **Kyle:** the crew doesn't know the
  radius until mid-job, which is the field's complaint. **Melissa:** fill it in the cab before work.
- **Melissa (56:02): digitise it.** TCG's auditor opens the job on his tablet, sees the JSA and on-site
  scope of work there, and adds photos without asking the operator. **Kyle (56:29):** an external auditor
  (e.g. Edison's) would still have to stop the crew.

**Sending documents to the customer on site (56:31–57:27).**

- **Melissa:** e-mail the JSA and other documents to a customer's safety person from the job site.
- **Kyle:** the oiler, on request. **Joe:** anyone must be able to, because of single-man cranes.
- ehtesham.anwar: to be added to the mobile app.

**The safety dashboard (58:24–59:51).**

- Asked whether jobs are found by job number or customer, ehtesham.anwar showed Lisette's jobs view.
- He proposed a safety page like it, with the **checklist** central, jobs shown by Dee's SLAs and a date
  range.

**Dee to send (57:31–1:00:34):**

- **every blank form template**, with what each is for and why it's used
- **a couple of example packets** reviewed on an audit, with how that audit ran
- **the department's SLAs** (e.g. an employee not audited in three weeks)
- **the Excel files**

## 9. Next

- **CodingCops** sends the accounting designs to TCG (35:21, 35:50).
- **Dee** sends the templates, example packets, SLAs and spreadsheets (§8).
- **Next Thursday** (1:00:56): ehtesham.anwar reviews the accounting flows for anything missed, then
  safety discovery continues. ehtesham.anwar: *"That's going to be our top priority for the discoveries
  so that we can complete the safety and then move on to the next module."* The date wasn't stated:
  2026-10-15 or 2026-10-22.
- **Holdover designs** to be finalised this week (§2).
- **Brian's** payroll summary is still outstanding (§1).

## Against the vault

- **Invoice granularity moves from the 10-08 design.** [2026-10-08 §2](2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md)
  recorded selecting *"a whole day or one ticket"*. This call settled on whole days (§2).
- **Consistent with holdover tickets.** [decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md](../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md)
  records one ticket each holdover day. Here the invoice covers the whole holdover job. Daily tickets
  with one invoice is consistent, but **when** a long holdover is invoiced was not said.
- **Markup on the customer side only matches the vault.** [vendors-agencies/outside-trucking-piazza-invoice-sop.md](../vendors-agencies/outside-trucking-piazza-invoice-sop.md)
  gives the Piazza markup arithmetic (10% / $35 / $58.50), and
  [accounting/invoice-packets-2026-04-worked-examples.md](../accounting/invoice-packets-2026-04-worked-examples.md)
  shows 10%, 15% and no markup on real invoices. Melissa confirmed where the markup goes, not its rate.
- **Holding a bill until the customer pays is wider than on 10-08.** On
  [2026-10-08 §7](2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md) it was a
  **subcontractor** rule with an **LADWP exception** (subs paid before TCG bills LADWP). Here the demo
  applied it to a **permit** bill, and LADWP wasn't mentioned. Whether it covers every vendor bill is
  unsourced.
- **Field audits.** [field-ops/safety-compliance/03-field-audit-and-safety-value.md](../field-ops/safety-compliance/03-field-audit-and-safety-value.md)
  records two audit instruments, the Field Crane Audit Form and the Safety Value Assessment. Its §4 open
  point 4 asks which one is live. This call says the form is *"always the same"* but doesn't say which.
  Its open point 6 (photos and video as required evidence) gets support: auditors already take both (§8).
- **On-site scope of work.** [field-ops/gaps.md → *On-site scope-of-work form*](../field-ops/gaps.md#on-site-scope-of-work-form--the-recording-is-the-only-source-and-a-done-ticket-looks-like-coverage)
  is open. Its 2026-03-26 source has the form written on paper and put on the windows for auditors. On
  this call Kyle says paper on the windshield is **required**, citing a document the transcript doesn't
  resolve, and Melissa wants it digital. That is new evidence on the open question, not an answer.
- **The crane-super view exists.** [decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md](../decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md)
  defines a *Crane Supervisor — Returned Entries* view. Jeff Kelley's audit sign-off (§8) would be a
  second job for that role.
- **New, not in the vault:**
  - invoicing by whole day, with a payroll-flagged day blocked (§2)
  - the customer setting for vendor documents, and the bills-received blocker (§4)
  - the customer-level collections tab with promise-to-pay (§5)
  - the cash-flow overview (§6)
  - per-employee audit recency and route suggestion (§8)
  - superintendent sign-off on audits (§8)
  - e-mailing JSAs to a customer from site (§8)

## Candidates for a decision note (for `tcg-scrum`)

1. **Invoices are created per whole day of a job, never per ticket.** Every ticket of that job that day is
   included. A day with a payroll-flagged ticket cannot be invoiced until payroll clears it. Several days
   can share one invoice. Brent Wagstaff (CFO), 18:38–18:55, after Tia Brenneise's *"No"*. Melissa
   McNutt supports it, 15:06 and 17:19.
2. **Collections are worked at customer level, not invoice level.** Brent Wagstaff, 28:01.
3. **Vendor invoice attachments go to QuickBooks with the bill.** Brent Wagstaff, 22:17.

**All three written, 2026-10-15 (`tcg-scrum`, at syed.haris's request). None declined.** Each is
`verified` on the folder's convention for a named TCG owner on a recorded call (*"Not confirmed in
writing"* in its `decided_by:`), and each records only what was decided:

1. [../decisions/2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md](../decisions/2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md).
   **Holdover invoicing as a whole job is recorded as not decided**: ehtesham.anwar said it, and no
   one at TCG confirmed it. Several days on one invoice is recorded as permitted, not required.
2. [../decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md](../decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md).
   Only the customer-level choice is decided. Promise-to-pay, weekly done/still-to-contact, the week
   selector and the 30-day entry are design.
3. [../decisions/2026-10-13-vendor-invoice-attachment-goes-to-quickbooks-with-the-bill.md](../decisions/2026-10-13-vendor-invoice-attachment-goes-to-quickbooks-with-the-bill.md).
   The §4 bills-received blocker is recorded as **proposed, not agreed**.

## 10. Questions this raises (not yet filed)

No ticket folder covers accounting or safety yet. When one does, these belong in its spec §12. Until
then they are candidates for [accounting/gaps.md](../accounting/gaps.md) (1–3) and
[field-ops/gaps.md](../field-ops/gaps.md) (4–7).

1. **Holdover invoicing:** is a holdover job invoiced only at the end, whatever its length? Can a long
   holdover be invoiced in parts?
2. **Holding vendor bills:** does "not paid until the customer pays" apply to every vendor bill (permits,
   plans), or only subcontractors as on 10-08? Does LADWP's pay-before-bill still apply?
3. **Vendor documents setting:** which customers need vendor documents in the packet (*"pool companies"*
   as transcribed)? And is TCG happy that, for them, the invoice is blocked until every third-party bill
   is received?
4. **Which audit form** is the one *"always the same"*: the Field Crane Audit Form or the Safety Value
   Assessment?
5. **On-site scope of work:** which document requires it on paper on the windshield, and can a digital
   copy satisfy it?
6. **Audit SLAs:** how often must each employee be audited? "Three weeks" was Melissa's example, not a
   rule.
7. **Who can e-mail job documents to a customer on site:** anyone on the crew (Joe), or the oiler on
   request (Kyle)?

---
title: Accounting Module — tickets for invoicing, payroll flags before invoicing, rounded vs actual times, AR / AP / cash flow review, third-party bills and held POs, salesperson Outlook e-mail, crane configuration and substitutions (3 November 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-11-03_Accounting module - transcript.docx"
migrated: 2026-11-05
updated: 2026-11-05
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, module/payroll, module/vendors-agencies, module/quotations, module/assets, module/dispatch, module/admin, module/field-ops, kind/meeting-notes, invoicing, ticket-workflow, purchase-orders, integrations, quickbooks, reporting, notifications, holdover, time-rounding, commissions, email, crane-configuration, data-migration, requirements]
meeting_date: 2026-11-03
---

# Accounting Module — payroll flag before invoice, rounded times, AR / AP, held POs, salesperson Outlook — 3 November 2026

Curated from [transcripts/2026-11-03-accounting-module.md](transcripts/2026-11-03-accounting-module.md) (0:12–1:14:05,
complete). **ehtesham.anwar** walked the accounting prototype on a shared screen. TCG speakers: **Brent Wagstaff**
(CFO), **Tia Brenneise** (Accounts Receivable), **Sammy Garrett** (Controller), **Joe Schacatano** (VP of Sales),
**Kyle Harlow** (VP of Fleet and Field Operations), **Brian Petros** (Data Analyst, ERP Project Coordinator),
**Patrick McKiernan** (IT Manager, labelled "IT Support"). **Ryan Adams** spoke only before the call. CodingCops:
ehtesham.anwar, abdulrehman, umer.islam (one word). Roles are from
[../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md).

> **Who was absent matters.** **Corrina Bustos** and **Micaela Dipane** were doing payroll (Brian, 46:45), and most
> of the call was about their work. Melissa McNutt did not speak. Brian will send them the questions and the
> recording. The vault also calls Micaela "Micaela Slykhuis".

> **Timestamps.** Long turns carry only their start (ehtesham.anwar 9:54, 13:46, 26:55, 33:05, 37:21, 45:43, 53:30,
> 54:53, 55:51, 1:00:36, 1:07:24, 1:11:56; Brent 29:35; abdulrehman 1:02:06). A point made inside one is cited by
> that start time.

> **Status.** §2–§4 and §8–§11 are a **prototype** walked by CodingCops, not shipped code and not a spec.
> ehtesham.anwar: *"I'll still resend this demo that we have created"*, then *"we can move forward with accounting
> development"* (1:00:36). What TCG said is marked; a design nobody at TCG answered stays a design. The file is
> `status: unverified`.

## 1. Before the demo (0:12–9:26)

- **Field testers and tablets.** Brian (2:05, 2:25): getting the system ready for everyone to test is the biggest thing,
  and Kyle was to name field staff. Patrick (2:40): the app can be pushed to tablets; *"if anybody's using their
  personal phones, then we just got to work with them one by one."* Some use a tablet, some a phone, some both
  (3:24–3:32).
- **Kyle Harlow, 3:02:** *"I'll get a list of who's on tablet. And then once I have a list on who's on tablet, I will
  pick from them."* Going forward, *"our plan is that it will be a requirement once the ERP is in full swing that every
  tablet."* The sentence stops there as captured.
- **abdulrehman, 3:36:** the mobile app needs updates to be responsive on tablets; the web app already is. *"I think
  it's not a major change."*
- **Test data.** ehtesham.anwar (5:31) wants TCG to enter its own data from scratch. Brian (5:56) will ask Brent what
  needs entering.
- **Go-live.** Patrick (6:12) asked how test data gets scrubbed. ehtesham.anwar (6:35): each company's access is its
  own tenant; at go-live TCG gets *"a new tenant where FCC data is there"*. **Brent, 7:16:** *"how much data are we
  bringing in from the past … Is that like 2026? Is it, does it go back further?"* ehtesham.anwar, 7:32: *"It still
  needs and needs to be determined."* That talk starts once functionality is stable (7:48). Since accounting closes the
  ticket loop, the import can be worked on in parallel with storage and maintenance (8:09).
- **Ryan Adams, 0:47:** *"I got to get some stuff ready for the ERP as well."* He asked Brian to catch up after the call.

## 2. Tickets for invoicing — the prototype (9:54–23:06)

**The chips.** The *All* tab lists every job with something to invoice, with a legend. As described (9:54, 13:46):
*before billing / waiting tickets*; *ready for invoice*; *escalated, one day past cut*, automatic, from *"our SLA that we
need to create invoices within the next 24 hours"*; *escalated, manager notified*, after *"a couple of days"*; *held, payroll
flag*; a blocked tag (e.g. a vendor has not sent its invoice); *draft*; *waiting sales approval*; *changes requested*;
one for when the *"CFO. adds the discount on an invoice"*; *approved*; *submitted*; *rejected in portal*; awaiting
payment; *paid*, with a QuickBooks tag, set automatically from the QuickBooks status; *partial*; *retention open*;
*fully invoiced*.

**A clean day (13:46).**

- All tickets submitted, no payroll problem and no quotation mismatch means *create invoice* for that day.
- The lines are the quotation's: *"75 ton crane, operator travel permit and traffic control services"*, with the POs
  raised around them, and the quoted figure beside each (*"quantity is 8, rate is 310, quoted 8 at 310"*).
- A mismatch is flagged. *"you can edit the invoice. Quantities yourself. But the quoted ones. Stay the same."*
- The customer packet links the e-ticket and other documents automatically, and more can be added.
- The tag *"2% early payment discount, if paid within 10 days"* is shown with its amount.
- *Create and link to QB* creates the invoice in the ERP and in QuickBooks. The invoice shows the QuickBooks status.
  From there: preview the PDF, edit, add the discount, send to sales for approval, and once approved send to the client.

**A third-party line (13:46).**

- On traffic control *"by file"* (unresolved in the transcript), TCG gets the third party's invoice and packet and
  must pass them to the client.
- *"we have this bill not created as a flag … It also shows why you cannot create this image as of yet. That bill needs
  to be created."* (INFERRED: "image" is *invoice*.)
- *Create bill* fetches the PO. The vendor name is an input now, a dropdown later. Then invoice number, received date,
  due date, amount, document. *Save and continue*: *"This is now created. in QB. as well linked to the PO"*.
- *"right now we are focused on creating the invoice, not focused on closing out the PO. We'll look at that later on."*

**Client portal (13:46):** *"in a couple of weeks, we are going to introduce, thinking of introducing the client portal"*,
which is where *rejected in portal* would come from.

## 3. A flagged ticket — who fixes it, and does it hold the invoice? (13:46–39:00)

**What the demo showed (13:46).** A day with two completed tickets, one with a quotation mismatch. Accounting can open
the details, edit the ticket (the original value is shown), save and approve it, or *send reminder* to payroll or the
crane super. Beside it, for the discussion, an option to invoice despite a payroll flag (26:55).

**ehtesham.anwar put two questions (13:46):** should Micaela be able to create an invoice on a ticket with a payroll
flag; and if the crane super must resolve something, may she edit and approve it, or only send it on? He described
today's split: payroll and invoicing are disconnected, *"Micaela is the one who is editing the ticket and approving it
to be invoiced"*. In the new system she *"shouldn't be able to click on mark clean and approve for the payroll"*.

- **Kyle Harlow, 23:06:** *"I think it should be fixed first before it's billed."* Reason: going back weeks later and
  *"asking for money back"*. It should be *"brought to the at least to the superintendent's attention"*.
- **Joe Schacatano, 24:07–25:39:** *"No, I agree."* Then alerts by level: to the individual, to the superintendent, and
  visible to *"everybody in Accounting"*, with set reminders, *"parameters and rules"*, and per-flag handling: *"we can
  individually kind of set how it's handled through the workflow"*.
- **Kyle, 25:45: the contract limit.** *"the language in the contract that says that the system cannot take away time or
  modify time. So it will have to be carefully worded."* It can suggest (*"Is there something missed here?"*); too
  aggressive *"will run into grievances"*. Then the manager decides. *"it cannot be used for discipline or for adjusting
  time."* He did not name the clause.
- **ehtesham.anwar, 26:55:** *"there is not a rule that removes an hour from people"*; the usual case is extra or missing
  time, such as an unverified work through lunch.
- **Joe, 29:01: the other way.** *"I don't want to restrict invoicing and waiting"*. A classification: *"if it is pop up here,
  it has to hold it. But if it doesn't necessarily need to hold up the invoicing, we can still move forward"*. Nobody took
  this up.
- **Brent, 34:34,** asked where a payroll disconnect goes (manager, employee, both). **ehtesham.anwar, 36:13–36:43:** payroll
  sees the same tickets with its own flags, and can send to the crane super, fix it themselves, or either can send it to the
  field employee ("field labeling" as captured).
- **Brent, 38:48:** *"I think payroll should be getting completed before invoicing, right?"*

**ehtesham.anwar's conclusion, 45:43:** *"based on our today's conversation, I'm going to remove this. So they will have a
ticket, they can not create an invoice on it, and then they cannot mark it clean. They will have to ask to. Payroll to clean
it for them."* Nobody at TCG answered that turn. **Brian, 46:45:** *"I'll definitely send them the questions … and then ask
them to listen to them, to the recording."*

## 4. 24 hours versus Tuesday payroll (26:55–34:30)

- **ehtesham.anwar, 26:55:** *"Micaela said that she needs to create and Brent said they need to create an invoice within the
  next 24 hours and send it to the customer … But on the other hand, payroll, Corrina processes on every Tuesday. So there is a
  gap of operations."*
- **Brent, 29:35:** the Tuesday run is just getting the checks out. *"There's no reason why … we can't have hours completed,
  you know, the next day"*, in *"the theoretical perfect world"*. Paper tickets and other barriers need working through.
  *"we can't really invoice till the next day, right, when the hours are dialed in."*
- **Brent, same turn:** *"we do run into work through lunches where it wasn't approved, but it was put on, and then that reduces
  hours."* **ehtesham.anwar, 31:19–32:19:** invoicing an unverified penalty, then payroll rejecting it, is where the two differ;
  the engine does not remove hours, invoicing does: *"You guys have that that option that you can choose not to bill an hour."*
- **ehtesham.anwar, 33:05 (a suggestion):** a job that ends at night is processed by Corrina and the crane super by midday,
  *"within the next 12 hours so the rest of the 12 hours can be given to Accounting"*. He asked whether vendors can invoice
  within 24 hours.
- **Brent, 33:53:** *"ASAP … ideally the next day, but there is always some that won't"*. TCG has its own process for *"gross
  offenders"*.

## 5. A payroll change after the invoice exists (36:47–38:48)

- **Brian, 36:47–37:05:** *"there may be payroll changes after the invoice is created"*, and some may need to *"trickle down into
  the invoice"*. The attempt could give *"some sort of warning or notification that the invoice has already been created"*.
- **ehtesham.anwar, 37:21:** a further chip: invoiced, then payroll changed, update the invoice. Example: *"we bill six hours"*,
  payroll says eight, so two hours go on the invoice. *"we need to figure out the rules."*
- **Brian, 38:19:** the aim is payroll done before the invoice, but *"there would be special approval on that"*, through *"Micaela
  or whoever's handling it … so they're aware on the invoice level that there is a change."*

## 6. Rounded versus actual times (39:00–45:39)

- **Kyle, 39:00–39:55:** the screens show actuals, *"not rolled up to 30s"*. When it pushes over, it should roll automatically so
  nobody adjusts by hand. ehtesham.anwar and Kyle work the example (40:15–40:31): a 5:40 start *"it's going to go back to 530"*; a
  5:05 end *"will roll up to 530"*.
- **Kyle, 40:54–41:56:** summaries show rounded; *"if you wanted to dig in … then you can break it down further"*. Actuals belong
  only *"for investigational purposes"*: *"it's not valuable to the employee because that's not how we're going to pay, that's not
  how we're going to charge"*.
- **Brian, 41:35:** *"every presentation that we have to the customer, right, is rounded time. Every presentation we have to the
  employee even I think is rounded time."* Real time perhaps only on the job ticket for payroll.
- **ehtesham.anwar, 42:17:** summaries rounded; the ticket keeps actuals, for verification. Kyle (43:01): *"I mean, that's fine."*
- **Tia Brenneise, 43:02, 43:22:** *"What about what gets sent to the customer? … What about customers that request a ticket?"*
  ehtesham.anwar: *"The rounded numbers are going to get sent to the customer. We are not going to send them the actual numbers"*
  (43:12), with the information masked (43:26), e.g. 5:40 becomes 5:30 (43:40).
- **abdulrehman, 43:52,** suggested showing both, actual with an arrow to rounded, or rounded in the summary and actual on the job.
  **Kyle, 44:35:** *"the actuals can be problematic customers"*, because a crew with no service fills them in later, and *"that
  becomes an argument, so I really think that we it should be just the rounded numbers."* If asked: *"our system automatically
  rounds to our local 12 adherence of payroll"*.
- **ehtesham.anwar, 45:13–45:33:** on the invoicing side the ticket shows numbers masked, and someone who wants the original turns
  it off. Kyle: *"That would be helpful."*

## 7. Holdover weeks (45:43)

A holdover weekly job with two weeks: one processed, so *"This is going to create an invoice for one week"*; week 2 shows it has not
started. Nobody at TCG commented.

## 8. Accounts receivable (47:01–49:58)

- **Brent, 47:36–49:23:** *"this is what I'm looking for"*. He likes the top blue snapshot. **The goal:** *"where do you change the goal
  on that?"* ehtesham.anwar (47:59): it was an average over weeks; *"we should be able to just edit a goal for the week."*
- **AR paid column:** *"I like that it shows on AR that it was it was that AR was paid. That's really super helpful for us"*; today it
  takes *"spreadsheets and formulas"*. *"Reports and stuff are down, not down the line, but they're after we get this dialed. But this,
  I like this. This is what I'm looking for, 100%."*
- **ehtesham.anwar, 49:30:** the list filters by paid, partial and unpaid and downloads as is, so no separate report function is
  needed. Brent: *"Yeah, that's what I want … Yep, I like it."*

## 9. Commissions and invoice type (49:58–53:28)

- **Brian, 50:04, 51:33:** commissions drill into QuickBooks invoices for categories, because some charges are not commissionable. Could
  this list flag or sort by type? **Brent, 51:06, 51:24:** *"in a perfect world, we'd have something like this for commissions and the
  ability to mark that it was paid. But I don't know if that's a right now thing."* A filter beside *All types*: *"maybe we could add
  something like that there"* (52:12). Brian: *"Yeah, maybe."*
- **ehtesham.anwar, 52:19:** a commission engine is in the backlog (*"one of the things Ryan also mentioned"*). The engine calculates from
  rules, accounting feeds payroll. *"Right now we haven't like covered the payroll for any of the office employees"*: later yard, maintenance,
  sales and all staff (53:03–53:15).

## 10. Accounts payable and held POs (53:30–55:46)

- **ehtesham.anwar, 53:30:** vendors, amounts due and bills, paid or unpaid, open balance, scheduled or not. He spotted a gap himself: POs
  with no bill yet do not show. *"we need to update this to also show us the POs that we haven't even created the bill on."*
- **Sammy Garrett, 54:42:** *"would this be the screen too that would kind of take over the sheet? Like if we got paid by Edison, then now we
  owe RCS kind of thing."*
- **ehtesham.anwar, 54:53:** *"PO has two statuses, the one is open, the other one is closed. And I believe like we should add another status
  and that should be once we receive the invoice from the third party, then we should move it to held status until our customer base."* (INFERRED:
  *"pays"*.) *"as soon as this invoice gets updated from draft to bid, then we can release these POs and then they are the ones that you have to pay
  out."* (INFERRED: *"paid"*.) **Sammy, 55:46:** *"Perfect. Thank you."*

## 11. Cash flow, collections, watch list (55:51–1:01:46)

- **Shown (55:51):** cash-flow summary; receivables against payables at 30, 60 and 60+ days; daily forecast; vendor payment planning; monthly AR
  movement (opening balance, billed, receipts, credits, adjustments, closing); collections progress; a promised figure from the collections tab.
- **Watch list:** Edison and RCS today, more through settings. A search bar over customers and vendors will be added. ehtesham.anwar suggests two or
  three.
- **Brent, 1:00:08:** *"I think this is fine. I'm intrigued to see. how the forecasting works … I'm intrigued to see how it looks with actual data in it,
  like a consistent like six months or 12 months."* ehtesham.anwar: what is deferred comes as the next layer, *"based on need"*. Tia was asked for
  feedback (55:51), and Brent answered.
- **Close (1:00:36):** *"I think, Brent, we are very close to"*, Brent: *"Yup"* (1:01:40), *"what Accounting needs right now."*

## 12. QuickBooks, FCC and the ERP (55:51, 1:06:20)

*"There is one item, agenda item that is still open and that is just reconciling with the QB, FCC and the ERP … What is the gap"*. CodingCops is working
through the data in all three and will finalize a plan (55:51). At 1:06:20: *"right now we are working through all of the QB items that you have in the QB,
all of the settings, and we are working through if we can. sync both of these within the ERP."* Also in progress: client portal, how invoicing works,
safety department flows.

## 13. Salesperson e-mail — Outlook (1:02:06–1:05:21)

- **abdulrehman, 1:02:06:** quote e-mail today uses the platform's support address; Joe wants it personal. **Option 1:** send from the shared address, with
  replies to the salesperson's inbox; simple, but the company's address still sends. **Option 2:** every salesperson connects their own Outlook; OAuth 2.0
  gives an access token and the mail goes from them, with their own inbox and sent items; *"complete isolation"*.
- **Joe Schacatano, 1:04:28:** *"Option 2. Option 2."*
- **abdulrehman, 1:04:31:** needs **two test accounts** on the craneguys.com domain, removable after the integration. Patrick (1:04:50) checked they are for
  testing only. **Brian, 1:05:21:** *"I'll work with Patrick to get those."*

## 14. Crane configuration (1:05:26–1:14:01)

Brian had booked this for Joe. **ehtesham.anwar showed Brian where it lives** and asked TCG to review; Joe's only later turn is *"Thank you."*

- **Where.** Category, then subcategory, in asset management; *"there's going to be one configuration for four cranes"*. Two switches on each associated field
  asset: hourly quotation and mob/demob. To test: create a quote in draft, change the setting, *"You will
  have to refresh"* (1:07:24). Brian: *"these configurations for what should show up on the quote, they're set on the category and subcategory screens for the
  assets"* (1:09:44); ehtesham.anwar agreed.
- **Dispatch.** Asked whether dispatch is affected, ehtesham.anwar first said *"No, no, Dispatch doesn't"* (1:10:20), then *"these resources, they become sets in
  daily allocation system"* (1:10:41). Brian: *"it does impact the Dispatch"*. ehtesham.anwar: *"Yeah"* (1:10:54).
- **Existing records.** *"I'm not sure it's going to impact the older ones"* (1:11:07).
- **Associated versus substitution (1:11:56, 1:13:25).** *"Associated is everything that is going to go with the crane when this crane needs to go on a field
  job. The substitution is basically if you can send any other crane in place of this one."* A crane removed from the substitution list could not be picked:
  *"this is not allowed, so you cannot send"*.
- **ehtesham.anwar, 1:13:46:** *"go through it and figure out if there is some problem there. If you still don't understand anything, I can get on a call with
  you guys."*

## 15. Next

- **TCG:** Brian sends the questions and recording to Corrina and Micaela (46:45); Brian asks Brent what test data to enter (5:56); Kyle lists who is on a tablet and
  picks testers (3:02); Brian and Patrick get two craneguys.com test accounts (1:05:21); Brian checks with Ryan about sales, and with ehtesham.anwar next day about
  the Thursday topic (1:05:48–1:06:16); TCG reviews the crane configuration (1:13:46); Brent reviews the demo.
- **CodingCops:** send Brent an update and answer the item in his e-mail that ehtesham.anwar could not recall (1:00:36); resend the demo (1:00:36); add the toggle to
  the original time (45:33); remove the invoice-despite-flag option (45:43); make the AR goal editable (47:59); show POs with no bill in AP (53:30); the watch-list search
  (55:51); the vendor dropdown on the bill (13:46); the QuickBooks, FCC and ERP plan (55:51); Outlook integration (1:04:31); say by next day what is ready for Thursday
  (1:06:20): ehtesham.anwar was unsure there would be a proper discussion.

## Against the vault

Checked 2026-11-05 against the vault and, where marked, the code on `staging`. **[code]** `apps/api/src/usecase` has no invoice, vendor-bill or QuickBooks usecase, so
everything in §2–§11 is prototype.

- **Agrees with verified decisions.**
  - Whole-day invoice held by a payroll flag: [../decisions/2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md](../decisions/2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md) (Kyle 23:06, Brent 38:48).
  - Start down, end up: [../decisions/2026-08-24-payroll-time-rounding-method.md](../decisions/2026-08-24-payroll-time-rounding-method.md) (5:40 → 5:30, 5:05 → 5:30).
  - Holdovers invoiced in weeks: [../decisions/2026-10-20-holdovers-billed-weekly-or-monthly-other-jobs-daily-one-job-per-invoice.md](../decisions/2026-10-20-holdovers-billed-weekly-or-monthly-other-jobs-daily-one-job-per-invoice.md). This replaces what ehtesham.anwar said on 10-13, that a holdover is invoiced once as a whole job, which nobody at TCG had confirmed.
- **Conflict — the crane superintendent in the flag path.** Corrina's verified [../decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md](../decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md): *"please update all flags to go to the payroll admin and payroll manager. not the crane superintendent"*, and [../decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md](../decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md): payroll corrects directly. Here the demo sends reminders to *"the payroll or the crane super"* (13:46) and payroll *"can send it to the crane super"* (36:13), and Kyle (23:06) and Joe (24:18) want the superintendent told. Corrina was not on the call. Not resolved.
- **Conflict — Joe's flag classes against "any flag holds the day".** Joe (29:01) wants flags that do not hold the invoice. The 10-13 decision, point 2, says *"A day with any payroll-flagged ticket cannot be invoiced"*, and [../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md) says every flag blocks payroll approval. Nobody took Joe's up; Kyle and Brent spoke the other way. Not resolved.
- **Conflict — Micaela as the person who may not mark clean.** ehtesham.anwar (13:46, 45:43) treats her as the invoicer who should not approve for payroll. Corrina, in the 09-29 note above: *"Right now the Payroll Administrator is Micaela Slykhuis"*, and both payroll roles *"need to get all of the flags and be able to adjust"*; [../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md](../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md) puts that role under HR. The 2026 chart lists her under Accounts Receivable. Brian (38:19) places her on the invoice side, and at 46:45 doing payroll. The rule may hold per role and not per person (INFERRED); nobody said so. Not resolved.
- **Conflict among designs — the QuickBooks bill.** The demo creates it at receipt (13:46), as on 10-08 and 10-13. The 10-16 e-mail proposed creating it only when ready to pay; Brent has not answered. Now also a **PO** status *held* (54:53), where 10-16's *Held* is a **bill** status. [../decisions/2026-09-11-outbound-po-subtypes-and-modal-fields.md](../decisions/2026-09-11-outbound-po-subtypes-and-modal-fields.md) and [../decisions/2026-09-11-po-closed-means-closed-out-not-cancelled.md](../decisions/2026-09-11-po-closed-means-closed-out-not-cancelled.md) (`reference`, CodingCops) lock `OPEN | CLOSED` and auto-close on an Invoice attachment, which is the moment *held* would start. [code] `PurchaseOrderStatus` is `OPEN`, `CLOSED`. See [../accounting/gaps.md](../accounting/gaps.md) *Vendor-bill flow*; LADWP's exception was not mentioned.
- **The bills-received blocker now sits in the demo.** The vendor-attachment decision records it as *proposed, not agreed*, and on 10-13 it was a customer setting (Melissa). Here *"bill not created"* stops the invoice on a third-party line (13:46), with no customer setting mentioned and no TCG comment.
- **Client portal timing.** *"in a couple of weeks"* (13:46), and *"we are also working on client portal"* (1:06:20), against *"after the first scope closes"* in [../accounting/gaps.md](../accounting/gaps.md) *Wishlist vs committed scope* (c). The 10-29 notes flagged the same.
- **The 24-hour invoicing SLA has no source in the vault.** ehtesham.anwar attributes it to Micaela and Brent (26:55). A search of the accounting notes and transcripts finds no such statement, and Brent's *"the next day"* here (29:35) is the nearest. It also meets the worker's own 24-hour window to complete a ticket ([../decisions/2026-10-15-late-and-incomplete-tickets.md](../decisions/2026-10-15-late-and-incomplete-tickets.md), developer direction on Melissa's provisional answers): a late ticket can arrive as the invoice falls due (INFERRED).
- **Kyle's contract clause is not in the vault.** The MLA text holds an in-cab camera MOU (the Southern California MLA's contents call that section *Cameras and Telematics*): *"Employers shall not use data collected under this MOU to initiate discipline"*, *"Except in cases of vehicle-related incidents"* ([../payroll/mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md](../payroll/mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md)). That bears on Samsara flags, but it covers **cameras**, not time. Nothing found says *the system cannot take away or modify time*. Whether Kyle means this MOU is unknown.
- **Change after billing agrees with a provisional answer.** The note on Melissa's 2026-10-06 answers: *"An invoiced or payroll-processed ticket needs approval. A change after billing triggers re-approval"* ([../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md](../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md)). Brian's warning and special approval (§5) fit it; who approves and what happens to the invoice are new.
- **Rounded and actual.** [../field-ops/frd-new-format-draft/05-functional-requirements/fr-fop-038-time-rounding.md](../field-ops/frd-new-format-draft/05-functional-requirements/fr-fop-038-time-rounding.md) requires both to be stored, and the June field app shows the rounding (*"Rounded down/up to 30 min in your favor"*, [../field-ops/field-app-demo-2026-06.md](../field-ops/field-app-demo-2026-06.md)). Where each one shows, and the masked customer copy, are new. So is whether a customer who signed on site already saw the actual times (INFERRED question). The 10-08 design shows every field-app step in the invoice preview.
- **Discount, 10-day term and retention.** Still unsourced beyond Edison's 2% Net 10 ([../accounting/invoice-packets-2026-04-worked-examples.md](../accounting/invoice-packets-2026-04-worked-examples.md), 2026-08-28). The 10-08 notes listed retention and the 10-day discount as questions and never filed them; filed now. The CFO's discount chip is new.
- **Salesperson e-mail answers an open question.** [../quotations/gaps.md](../quotations/gaps.md) *The signing email should come from the salesperson, not from DocuSign* asked per-user OAuth or a from-name change; Joe chose the first, again. [code] No Outlook or Microsoft Graph integration exists (the only `outlook` hits are in the e-mail letterhead template). DocuSign's place under it is still open.
- **Tablets.** The RFP gives Field Crew tablets ([../admin/tcg-erp-rfp-2026-02-26.md](../admin/tcg-erp-rfp-2026-02-26.md) §5, per [../decisions/2026-09-22-tablet-is-an-active-conversion-target-for-the-web-portal.md](../decisions/2026-09-22-tablet-is-an-active-conversion-target-for-the-web-portal.md)), and that note says *"now converting to tablet"*, for the web. abdulrehman says the web is done and the mobile app needs work. Kyle's tablet requirement is new.
- **Testers.** Kyle now picks from the tablet list; on 10-27 it was one operator, one oiler, one third man, one rigger, chosen with the superintendent. This is the fourth time the record has him promising names.
- **Substitution** agrees with the 2026-10-22 walkthrough §2, where the vendor-path exception stays unaddressed.
- **Commissions.** [../quotations/sales-commissions.md](../quotations/sales-commissions.md) is the invoice-driven workbook between FCC and QuickBooks. The engine and the category filter are new here; Brent says not now.
- **Unfiled from 10-08, still unfiled:** §9 Q1 (which system sends the invoice) and Q2 (credit memos). This call did not address them.

## Candidates for a decision note (for `tcg-scrum`)

1. **Times display rounded everywhere, including everything sent to a customer; actuals only on ticket detail, for investigation** (§6). Kyle Harlow, with Brian Petros; Tia raised the customer case. The strongest candidate, but Corrina and Micaela were absent.
2. **Quotes are e-mailed from the salesperson's own Outlook, by per-user OAuth** (§13). Joe Schacatano, *"Option 2. Option 2."* (1:04:28), a direct either/or by the owner. Whether it covers more than quotes was not asked.
3. **Accounting cannot create an invoice on a payroll-flagged ticket and cannot mark it clean; payroll cleans it** (§3). The block restates the 10-13 decision (Kyle, Brent). *"cannot mark it clean"* is ehtesham.anwar's conclusion, unanswered, with the payroll owners absent. **Partly agreed:** hold until Corrina and Micaela reply.
4. **The AR view as shown, with an editable weekly goal and the AR paid column; the list filters and downloads as the report** (§8). Brent Wagstaff, *"This is what I'm looking for, 100%"* (49:23). A review of a prototype, not a scope commitment.

Not candidates (floated only): Joe's flag classes and alert rules (§3); next-day hours (§4, Brent's *"perfect world"*); the 12 + 12 split (§4); the warning and special approval after invoicing (§5); the held PO status (§10, Sammy's *"Perfect"* is not Brent's answer); the commission engine (§9); Kyle's tablet requirement (§1).

## 16. Questions this raises — filed 2026-11-05

1. **Who may edit or clear a flag from invoicing; any flag that does not hold the invoice** (§3). New: [../accounting/gaps.md](../accounting/gaps.md) *Flags on the invoicing screen*. Update on [../payroll/gaps.md](../payroll/gaps.md) *Flagged entries go to payroll, not the crane superintendent*.
2. **The 24-hour clock against Tuesday payroll** (§4). New: [../accounting/gaps.md](../accounting/gaps.md) *24-hour invoicing against Tuesday payroll*.
3. **A payroll change after invoicing** (§5). New: [../accounting/gaps.md](../accounting/gaps.md) *A payroll change after the invoice exists*.
4. **Rounded and actual, the customer copy** (§6). New: [../accounting/gaps.md](../accounting/gaps.md) *Rounded vs actual times*. Pointer in payroll.
5. **Discounts, the 10-day tag, retention** (§2). New: [../accounting/gaps.md](../accounting/gaps.md) *Invoice discounts, the 10-day early-payment tag and retention*.
6. **Commissions and invoice type** (§9). New: [../accounting/gaps.md](../accounting/gaps.md) *Commissions in the ERP*.
7. **Kyle's contract clause, unapproved WTL** (§3, §4). New: [../payroll/gaps.md](../payroll/gaps.md) *The system cannot take away or modify time*.
8. **Go-live data** (§1). New: [../admin/gaps.md](../admin/gaps.md) *Go-live — how much history comes over*. Pointer in accounting.
9. **Configuration changes on existing records** (§14). New: [../assets/gaps.md](../assets/gaps.md) *Does changing a subcategory's configuration reach quotes and jobs that already exist?*
10. **Updates, no new entry:** [../accounting/gaps.md](../accounting/gaps.md) *Vendor-bill flow*, *An AR tab like Accounts Payable v2*, *Accounting reports*, *Forecast vs actual cash flow*, *Billing cadence*, *Does the invoice carry exactly the quotation's lines*, *Wishlist vs committed scope*; [../vendors-agencies/gaps.md](../vendors-agencies/gaps.md) *PO state following Vendor state*; [../quotations/gaps.md](../quotations/gaps.md) *The signing email should come from the salesperson*; [../admin/gaps.md](../admin/gaps.md) *Field beta test*.

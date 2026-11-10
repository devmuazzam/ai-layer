---
title: Customer Portal — the crane set's line order and counterweight loads, the customer portal prototype (quote approval and e-signature, the PO number and PO document, change requests, customer self-scheduling, what a customer sees of a job, invoices and Pay Now), a job permit beside an asset's annual, role dashboards and the Scalable scoreboard (5 November 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-11-05_Customer Portal - transcript.docx"
migrated: 2026-11-10
updated: 2026-11-10
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/customers, module/accounting, module/projects-jobs, module/dispatch, module/assets, module/admin, kind/meeting-notes, crane-configuration, signatures, purchase-orders, scheduling, notifications, geolocation, invoicing, integrations, permits, reporting, requirements]
meeting_date: 2026-11-05
---

# Customer Portal — crane set order, quote approval and the PO, job visibility, Pay Now, permits, dashboards — 5 November 2026

Curated from [transcripts/2026-11-05-customer-portal.md](transcripts/2026-11-05-customer-portal.md) (0:08–50:11,
complete). **ehtesham.anwar** walked the customer portal prototype on a shared screen. TCG speakers: **Joe
Schacatano** (VP of Sales), **Ryan Adams** (Sales Manager), **Wes Staley** (Owner, from 46:33). **Tia Brenneise**
(Accounts Receivable) left at 1:33 when Joe said the call was about sales. CodingCops: ehtesham.anwar, abdulrehman.
Roles are from [../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md).

> **Who was absent matters.** No one from Accounting stayed for the invoice half of the portal (§7): Brent, Tia,
> Sammy, Corrina and Micaela did not hear it. No one from Dispatch (Lisette, Kyle) heard the self-scheduling idea
> (§4) or the job-visibility answer (§5), and both lean on dispatch.

> **Timestamps.** Long turns carry only their start (ehtesham.anwar 2:28, 7:33, 9:26, 14:32, 21:27, 24:57, 26:40,
> 31:56, 35:11, 36:31, 42:24, 43:45, 45:07; Ryan 22:11, 23:12). A point made inside one is cited by that start time.

> **Status.** §3–§7 are a **prototype** walked by CodingCops, not shipped code and not a spec. ehtesham.anwar: *"we
> have created this prototype for the customer portal"* (14:32), with a separate e-mail prototype still to come. What
> TCG said is marked; a design nobody at TCG answered stays a design. The file is `status: unverified`.

## 1. The crane configuration — Joe's review (1:52–4:23)

- **Joe, 1:57–2:19:** *"I sat with Brian. It looked proper the way that it's built out."* As go-live nears, TCG will
  *"set the actual configurations that will be utilized"*. *"I think it's in line with where it needs to be. I didn't
  really see any issues with it."* This answers the 11-03 action item *TCG reviews the crane configuration*.
- **One switch reaches every crane.** Joe had asked by message to change *always included* on an asset. ehtesham.anwar
  (2:28): the switch lives on the subcategory. To make something optional on the operator load, *"you go to the
  subcategory of operator load"*, and *"this is going to change all of the operator loads that you have added in
  different cranes. That's like a kind of a drawback."* **Ryan, 4:10–4:16:** *"So, it will do it for every crane"*;
  *"Is there any way to separate that … for each crane?"* ehtesham.anwar (4:23) answered with the design's intent:
  the configuration decides what goes, so sales and dispatch do not guess. A tractor and an operator always go with
  an operator load; an oiler always goes with the crane. Per-crane separation was not offered.
- **Support loads.** ehtesham.anwar (5:04): *"for a support load, you have always going to be a third man, but rigger
  can go there. So they are optional."*

## 2. The crane set on the quote — full package, line order, counterweights (5:34–14:30)

- **Full package or add-ons.** Ryan (5:34) floated a full package on every crane, *"put subsistence in there and
  everything and then you uncheck what's not needed"*. **Joe, 6:03:** for the additionals, *"I wouldn't want it to
  populate 10 things when you only need three and then you got to exclude the seven. I'd rather add the seven and
  have the three populate."*
- **The machine itself goes out at full capability.** Ryan (6:58–7:22): populate all the counterweight loads and
  remove the ones the configuration does not need. ehtesham.anwar (9:26) showed it on a new hourly quote: support
  loads marked optional can be removed. **Ryan, 10:16:** *"That's perfect. So we can make a full boat, Joe, and then
  you could delete whatever you don't need."* **Joe, 13:40:** *"It's going to automatically set to that machine going
  out full capability. And then when you're in the quoting stage … you remove what you don't need."* Joe, 14:00: the
  100 ton populates with its operator load, *"what's necessary"*. ehtesham.anwar (14:04): the configuration also says
  whether a line is removable at all. Joe: *"Correct."*
- **Counterweight loads labelled by weight.** Ryan (6:33): counterweight configurations differ by crane, *"44,000 is 1
  configuration, 88 is the next"*. Could each support load be relabelled per machine type? ehtesham.anwar (7:33) read
  it as load count: one load is the 44 minimum, two make 88, three make 132. **Ryan, 8:50:** *"I think we'd want it by
  the weight of the counterweights, because that shows the configuration of the crane itself."* Joe (7:22) asked
  whether, at dispatch, the load then carries its actual weight; Ryan: *"Yes, sir."* Not settled.
- **Line order.** ehtesham.anwar (10:21): the order on the quote had not been thought through. Should it follow the
  order the associations were added, or a default? **Ryan, 10:52–11:11:** *"we'd normally would do the crane, the
  operator load, and then counterweight one, two, three, 4 … and then we do a rigger and then a travel permit, so on
  and so forth, and then at the end would be your fuel and insurance surcharge."*
- **Set precedence or drag and drop.** ehtesham.anwar (11:25) wants the order set as data on the subcategories, not
  in code. abdulrehman (12:09) proposed drag and drop on the associated assets. ehtesham.anwar (12:15): then each
  configuration must be managed. Ryan (12:47): a set precedence *"allows us not to forget anything every time"*.
  **Joe, 13:21:** *"When it comes to the machine, it should be a set precedence on the equipment itself, and then you
  change it from there."* ehtesham.anwar (13:30) read that back as *"by default, it follows a set pattern"*, with a
  per-crane change. Joe did not correct it.
- **Ryan, 14:30:** *"No, sir, it looks good."*

## 3. The customer portal — access, dashboard, quotations (14:32–20:01)

As walked by ehtesham.anwar (14:32), on the prototype:

- **Access.** The first e-mail says a quotation has arrived and carries **the link and a passcode**. The customer
  signs in with the passcode. A separate prototype of every e-mail and its flow is still to come.
- **Dashboard.** First a to-do section, then overdue invoices, running projects and jobs, invoices to be paid, every
  invoice for the customer, approved quotations and recent documents.
- **Quotations tab.** Quotes that need approval, change requests, new ones and older ones.
- **Sending.** The salesperson creates the quote in the main portal and uses *send quotation to customer*. The
  customer gets an e-mail with the portal link. A checkbox, **share in the client portal for approval and
  e-signature**, is **on by default**. If it is off, the customer gets the quotation *"along with the client portal
  access"* (as captured). **Once the customer has logged in to the portal, the box cannot be unchecked.**
- **The customer's choices.** Open the new item, then **decline**, **request changes** or **approve and sign**. They
  see the schedule, the whole quotation, the summary and the salesperson's details, and **can change the schedule
  inside a change request**.
- **Change requests.** The salesperson is notified, and the status becomes **changes requested**. A **correspondence
  tab** carries messages both ways. The salesperson sends a revision (*"Schedule has been changed, review"*). The
  customer's dashboard then shows it as **revised**, with the same choices.
- **Approve and sign.** The customer ticks a confirmation (26:40, captured as *"this is their Esq measures"*) and
  enters **their PO number**. ehtesham.anwar: *"This is the PO number that we are going to attach with the project …
  with the job, and then later on … in the invoicing."*
- **PO document.** **Ryan, 20:01–20:20:** can they drag and drop a PO? *"a lot of times they create a PO and then
  they have it in a PDF … then we have a what we would consider a hard copy PO."* ehtesham.anwar (20:37): *"We'll add
  another option to add a PO document here."*

## 4. Customer self-scheduling — Ryan's idea (20:44–26:40)

- **Ryan, 20:44–20:55:** can customers schedule their own job, if the system knew crane availability and permit
  times? ehtesham.anwar (20:47): today they can only change the schedule and ask TCG to confirm it. (21:07): *"Yes, we
  can."*
- **ehtesham.anwar's version (21:27):** the customer selects the crane, resources and counterweight, sees which dates
  work, and requests. TCG approves, sends the final quotation, and the job is scheduled. No quote need go first.
- **Ryan's version (22:11, 23:12):** keep the quote first, *"because the size crane, we have to know exactly what's
  happening there"*. After that, a link lets the customer schedule within TCG's permit times, and *"if they decide to
  change it, automatically sends a bill for that change"*. *"It saves a phone call, it saves an e-mail, and it goes
  directly over to Dispatch."* The salesperson is e-mailed when the customer schedules. Ryan: *"I think what I was
  asking was, is the option available? … I definitely want to bring that up to the team."*
- **The hard part.** ehtesham.anwar (23:43, 24:57): scheduling is easy. The checks salespeople make in their heads
  are not: is there space for a 265? Is that the right crane at all? *"Can you give us a write-up of all of those
  rules?"*
- **Ryan, 24:22:** Brian sent a permit schedule per city with lead times, and Ryan will resend it. On a quote for a 90
  ton, let the customer choose only among 90 tons that are open. But *"a lot of times if that crane is not available,
  we move it to a different crane, so there's a lot to think about there."* **Ryan, 26:15:** perhaps quote one crane
  and put **two backup cranes** inside the quote, *"but probably the architecture behind that's probably going to
  come from Dispatch"*. Ryan will talk to Joe. Not decided; no dispatch voice on the call.

## 5. Projects and jobs — what a customer sees (26:40–35:09)

- **As walked (26:40):** the customer cannot create a project; they only approve quotations. Projects and their jobs
  appear once TCG creates them. A completed job showed the operator, the oiler, *"two tickets"* and progress. An
  in-progress job showed where the crew is working and what they have submitted. ehtesham.anwar asked: live
  tracking, the information only after the job ends, or nothing?
- **Joe, 29:06:** *"I would say that they don't see this. I would say maybe like an alert or something."* Perhaps a
  link to Samsara once the job is confirmed, to check where the crane is en route.
- **Milestone notifications.** ehtesham.anwar (29:31, 30:38) proposed a few updates: *crew on the way*, *arrived and
  working* (setup and JSAs count as working), and *completed*. **Joe, 30:15 and 31:23:** a late or edited timestamp
  makes the customer's view wrong (*"they started at 7, because at 8 they can change it to reflect 7 on the
  ticket"*), and *"we end up having to probably spend a lot of time and energy if we're giving them a ton of
  information"*.
- **Samsara will not do either.** Ryan (31:38) asked about geotracking. ehtesham.anwar (31:56): jobs are billed yard
  to job site, but crews go job to job. A crew 1½ hours away on another job would show as stationary when the customer
  expects them to leave the yard 3 hours out. **Joe, 33:11–33:17:** *"I almost think we have to not do any of it
  because again, if it's relying on the user. Could be misinformation … and … if we're stacking jobs, if it's off the
  Samsara, it's going to throw off the billing."*
- **Where it landed.** ehtesham.anwar (33:52, 34:24) proposed this: stop at the job's status (*scheduled, invoiced,
  approved, waiting to be approved, in progress*), show **the number of assets and the number of crew members** in
  place of the ticket count, the basic schedule, and *"the tracking of the progress. That's all."* **Joe, 34:10:**
  *"Yeah, I'm good with that."* **Joe, 34:46:** *"Yeah, I agree with that."* **Ryan, 34:55:** his old company did
  hard quotes, so job-jumping did not matter; with hourly jobs, *"probably the only way"*.
- **Later.** ehtesham.anwar (35:11) may ask Dispatch whether customers call or message them, and add correspondence to
  jobs like the salesperson's.

## 6. Invoices and Pay Now (35:11–38:12)

As walked (35:11, 36:31):

- **Lists.** Invoices to be paid (overdue, upcoming) and all invoices, including paid ones.
- **The invoice.** *"the same invoice that we are sending right now for QuickBooks"*, with the customer packet and its
  attachments in the PDF. The packet can be downloaded, paid or unpaid.
- **Pay Now.** *"This pay now button is the same pay now button we are going to use as we have on the invoice right
  now. The [Pay Now] functionality from QuickBooks. We are just updating UI here."* The customer checks out in
  QuickBooks, and the invoice moves to paid.
- **Confirmations.** An e-mail confirms an approved quotation. A paid invoice gets an e-mail with the document and the
  payment date.
- **Past-due alerts.** **Ryan, 36:23:** *"Does this automatically send alerts to them too once they're past due?"*
  ehtesham.anwar: *"Yeah, yeah, that's the whole setup is there in the background and that is going to be from our
  portal."* No interval, wording or sender was given.
- Ryan, 38:12: *"Very nice, creates a lot of synergies."* Joe, 38:20: *"Great."* Nobody from Accounting was on the
  call.

## 7. DocuSign and the salesperson's e-mail (38:22–38:58)

- **ehtesham.anwar, 38:22:** *"we'll add this. This will remove our DocuSign as well."* Nobody at TCG answered.
- **Salesperson e-mail.** abdulrehman and team are connecting each individual's e-mail to the portal, *"we are going to
  check which user is supposed to send that and then we are going to send through that"*. **abdulrehman, 38:58:**
  *"that's already started, and I hope that will be up on portal in our next sprint."* This is the per-user OAuth
  Joe chose on 11-03.

## 8. Safety next (39:12, 49:58)

ehtesham.anwar (39:12) is working through **Dee's** requested functionalities and requirements (Dennene Jones, Safety
Manager). An initial draft comes *"next week"*. The next meeting is **Tuesday, on safety** (49:58), i.e. 2026-11-10.

## 9. Permits — a job permit beside the asset's annual (39:57–43:12)

- **abdulrehman, 39:57–41:32:** if an asset has a yearly permit, can a job still get its own travel permit?
- **Joe, 40:50:** *"if they have to travel through multiple cities"*. A county permit may cover Los Angeles, *"but then
  you enter a different city and you don't have an annual for that, you would need what's called a single trip for
  that. So you could have multiple permits for one asset on one job."* **Joe, 41:50:** *"not if you have an annual for
  every city, but not every city offers those annuals … the answer is yes."*
- **Ryan, 41:16:** a freeway usually needs one permit, and leaving it lands you in one city. Sometimes you cross one
  city to reach the next.
- **Renewing an annual.** **Ryan, 42:08:** when an annual nears expiry and a new one is entered, the dates overlap.
  Delete the old one? **ehtesham.anwar, 42:24:** a notification arrives as it nears expiry, the renewal runs as an
  application on top of the old permit, and the new permit has its own start and end. *"If they overlap, we go with
  the new one."* **Ryan, 43:12:** *"Very good."*

## 10. Dashboards, goals and the Scalable scoreboard (43:12–49:58)

- **Ryan, 43:12:** on opening the ERP, will a user see goals and metrics, e.g. *"you got to make 2 quotes today"*, red
  when behind and green when close?
- **ehtesham.anwar, 43:45:** showed the accounting dashboard, *"the first proper dashboard that we have created for
  any team"*. None exists yet for Ryan's team, Dee's team or overall. Each department gets its own, not the current
  deployed dashboard. *"I would like every manager to send us a write-up of what is needed on that dashboard for each
  kind of employee."* (45:07): he wants Joe's, Melissa's and Wes's questions too, for example quotation counts and
  trends, safety-problem trends and collections trends.
- **Joe, 46:10:** *"we actually have a drafted dashboard"*, worked on with Ryan. TCG will review it and share it.
- **Wes Staley, 46:33–47:04:** show the **Scalable** dashboard too. *"Scalable is a part of our company"*. Metrics are
  added or removed by team members entering them, as a live dashboard beside an executive dashboard. *"So on Tuesdays,
  we know everything's in."* **Joe, 46:42 and 47:38:** hesitant. Scalable is still evolving, and *"they're going to
  build everything on the back … to pull it, and if we get rid of it"*. **Wes, 47:59:** *"The scalable … the entering
  of the numbers would stay always a manual process."* **Joe, 48:06, 48:36:** a manual scoreboard; each manager or
  department head pulls their data and enters KPIs weekly, and the executives and management review it in a monthly
  meeting. The ERP dashboard pulls the higher-level data. Wes, 48:18: *"Hundred percent."*
- **ehtesham.anwar, 48:20 and 49:12:** a dedicated conversation on Scalable is owed. He wants the dashboard and report
  needs **now**, not at the end, *"to see the gaps in the background that we have, and then fill in those gaps"*.
  Joe, 49:55: *"Makes sense. Sounds good."*

## 11. Next

- **TCG:** Joe sets the actual configurations nearer go-live (2:06); Ryan talks to Joe and the team about
  self-scheduling and backup cranes (22:11, 26:15); Ryan resends the per-city permit schedule (24:22); a write-up of
  the rules salespeople check before a crane is right for a job (owed to ehtesham.anwar, 23:43); Joe and Ryan review
  their drafted dashboard and share it (46:10); every manager writes up their dashboard needs per kind of employee
  (43:45); a separate conversation on Scalable (48:20); safety on Tuesday (49:58).
- **CodingCops:** a PO document upload on approval (20:37); a set precedence for the crane set on the quote (11:25,
  13:30); the job view reduced to status, counts and schedule (34:24); the e-mail prototype (14:32); per-user e-mail
  *"in our next sprint"* (38:58); an initial draft of Dee's safety functionality *"next week"* (39:12).

## Against the vault

Checked 2026-11-10 against the vault and, where marked, the code on `staging` (`0d6c794b2`). **[code]** No
customer-portal code exists in `apps/api/src` or `apps/web/src` (no `client portal`, `customer portal` or `passcode`
hits), so §3–§7 are prototype.

- **The portal's place in the plan has moved again.** [../accounting/gaps.md](../accounting/gaps.md) *Wishlist vs
  committed scope* (c) has CodingCops placing the portal *"after the first scope closes"* (2026-09-02). The client's
  RFP lists *"customer portal for quote approval and invoice review"* as **nice-to-have**
  ([../admin/tcg-erp-rfp-2026-02-26.md](../admin/tcg-erp-rfp-2026-02-26.md)). The 11-03 notes said *"in a couple of
  weeks"*. Now a prototype covers quotes, jobs and invoices. No TCG owner has placed it in scope.
- **DocuSign.** *"This will remove our DocuSign"* (38:22) restates ehtesham.anwar's 09-15 *"already discussed and
  finalized"*, which no vault note records, and Joe's 09-15 wish, which he labelled his own opinion. Nobody answered it
  here. [../decisions/2026-09-28-docusign-signed-copy-stored-as-attachment.md](../decisions/2026-09-28-docusign-signed-copy-stored-as-attachment.md)
  (`reference`) keeps the DocuSign signed PDF on the quotation, project and job. Where a portal-signed copy goes is
  unwritten. The 09-15 design said *one-time customer credentials*. The prototype's *link and passcode* fits that.
  Whether the passcode is single-use is not said.
- **Statuses.** [code] `QuotationStatus` already has `CHANGES_REQUESTED` and `IN_REVISION`. The portal's *changes
  requested* and *revised* fit them (INFERRED mapping). Whether a customer's change request may move the quote out
  of `SENT_TO_CUSTOMER` without the salesperson is not said.
- **The customer PO.** [../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md](../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md)
  puts the customer PO on the job and schedule tab, *"not a quotation field"*, while its own diagram logs the PO
  before *convert to job*. [../quotations/gaps.md](../quotations/gaps.md) *The customer PO arrives before the job
  exists* asks which reading is meant. The prototype takes **capture at approval**, carried to the project, job and
  invoice. That is CodingCops' design; no TCG owner chose it. Ryan's PO document is new. *Can one job carry more than
  one Customer PO?* ([../vendors-agencies/gaps.md](../vendors-agencies/gaps.md)) was not touched: the portal takes one
  number per quote.
- **The crane set fits what is written.** The operator load is mandatory and the `.1`, `.2`, `.3` loads are optional
  ([../dispatch/crane-configurations.md](../dispatch/crane-configurations.md)).
  [../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md](../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md)
  (`reference`) leaves an always-included child with no delete control, so only optional lines can be removed.
  *Full capability, remove what you don't need* (Joe, Ryan) works only through optional support loads, which is
  what ehtesham.anwar showed.
- **Line order is not stored.** [code] `SubCategoryAssociatedResource` has no position or sort column. Ryan's order
  matches FCC's implicit grouping by line number (OM-40822: crane, then tractors, operator load, support loads 1–10;
  [../quotations/gaps.md](../quotations/gaps.md) *Several main cranes on one quotation*). Two parts of his list meet written
  rules. Fuel and insurance are **one surcharge per quote**
  ([../decisions/2026-09-02-one-surcharge-per-quote.md](../decisions/2026-09-02-one-surcharge-per-quote.md),
  verified), printed as one row, so *"at the end"* agrees. A travel permit as a quote line is still open
  ([../quotations/gaps.md](../quotations/gaps.md) *Permits in Resources — is a permit a quotation line at all*).
- **Counterweight weights.** The 10-29 entry's (f) asks where the weights live, and they exist only for the 190 T.
  Ryan now wants the support loads **named** by weight, per machine type. ehtesham.anwar's 44 / 88 / 132 sums by load
  count are his own reading, and Ryan answered *by weight*.
- **One switch for every crane** adds a second reach to [../assets/gaps.md](../assets/gaps.md) *Does changing a
  subcategory's configuration reach quotes and jobs that already exist?*: the change reaches **every crane** that uses
  the subcategory, not only existing quotes. [../decisions/2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md](../decisions/2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md)
  (`reference`) covers quotes already sent; nothing covers the crane-by-crane case Ryan asked about.
- **Job visibility.** Internally, Live Tracking is shown disabled on Progress Tracking
  ([../decisions/2026-09-11-progress-tracking-chat-and-reminders-shown-disabled.md](../decisions/2026-09-11-progress-tracking-chat-and-reminders-shown-disabled.md)).
  Nothing in the vault said what a customer sees. ehtesham.anwar's billing reason (yard to job, crews job to job) is
  the same overlap filed in [../accounting/gaps.md](../accounting/gaps.md) *Back-to-back jobs billed portal to
  portal*. Joe's concern rests on crews correcting start and end on the ticket after the fact (31:23), which is his
  statement here; this check did not trace it to a field-ops rule.
- **Pay Now is new to the vault.** The only *Pay now* in the vault is the AP side (paying vendors, [../accounting/ap-ar-value-engine-and-whiteboard-flow.md](../accounting/ap-ar-value-engine-and-whiteboard-flow.md)).
  A customer paying through QuickBooks fits the 09-01 boundary (*QuickBooks keeps the books*). The July wishlist's
  *"view invoices · pay online · auto-send statements"* ([../accounting/2026-07-accounting-team-erp-wishlist.md](../accounting/2026-07-accounting-team-erp-wishlist.md))
  is the nearest client source. **Automatic past-due alerts** to customers have no interval, sender or owner anywhere.
  [../decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md](../decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md)
  (verified) is a manual worklist, not customer-facing reminders.
- **Permits agree with what is written.** Annual permits carry no PO; single-job permits do
  ([../decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md](../decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md)).
  Annual Travel is tied to one city
  ([../decisions/2026-11-04-permit-vendor-required-annual-city-agency-filter.md](../decisions/2026-11-04-permit-vendor-required-annual-city-agency-filter.md),
  owner direction). Joe's answer follows: a route through a city with no annual needs a single-trip permit, so one
  asset on one job may carry several. **The overlap rule is new.** *"If they overlap, we go with the new one"* is
  CodingCops' answer, accepted by Ryan. The expiry notification has no lead time stated, and
  [../projects-jobs/gaps.md](../projects-jobs/gaps.md) *Permit expiry reminders — neither 90 nor 30 shipped* is still
  open.
- **Dashboards.** The RFP puts *Reporting & Analytics (operations, finance and executive KPI dashboards)* in **Phase 3**
  (Q1 2027) and an executive dashboard as nice-to-have. The sales workbooks already keep a `Salesperson Scoreboard`
  ([../quotations/sales-reporting-workbooks.md](../quotations/sales-reporting-workbooks.md)). TCG runs on Ryan Deiss's
  *Get Scalable* method ([../domain/value-engines-and-playbooks-method.md](../domain/value-engines-and-playbooks-method.md)),
  so Wes's *Scalable* is most likely its scoreboard (INFERRED). Per-role dashboards and per-user goals are written
  nowhere else.

## Candidates for a decision note (for `tcg-scrum`)

1. **A customer sees a job's status, its number of assets and crew, and its basic schedule; no live tracking, no
   crew timestamps, no Samsara position** (§5). Joe Schacatano, *"Yeah, I agree with that"* (34:46), to a direct
   proposal. Dispatch was absent, and whether any milestone notification survives is open.
2. **The crane set populates at the machine's full capability in a set precedence; the salesperson removes what the
   job does not need** (§2). Joe (13:21, 13:40) and Ryan (10:16, 12:47). Ryan's order is the only order given; where
   the precedence is stored is CodingCops' call.
3. **The customer can attach a PO document as well as type the PO number when approving** (§3). Ryan's ask, agreed
   by ehtesham.anwar (20:37). An ask accepted by CodingCops, not a TCG decision on the PO's home.

Not candidates (floated only): self-scheduling and backup cranes (§4, Ryan wants the team's view); milestone
notifications (§5, Joe: *"not do any of it"*); the share-in-portal default and lock (§3, CodingCops' design, no
reply); retiring DocuSign (§7, no reply); past-due alerts (§6); the overlapping-annual rule (§9, CodingCops' rule,
Ryan's *"Very good"*); dashboards and Scalable (§10).

## 12. Questions this raises — filed 2026-11-10

1. **Customer portal approval rules** (§3). New: [../quotations/gaps.md](../quotations/gaps.md) *Customer portal
   quote approval — the prototype's rules, which no TCG owner has specified*.
2. **The crane set's order on the quote** (§2). New: [../quotations/gaps.md](../quotations/gaps.md) *Order of the
   crane set on the quote — one set precedence, stored where?*
3. **Customer self-scheduling** (§4). New: [../dispatch/gaps.md](../dispatch/gaps.md) *Customer self-scheduling from
   the portal — an idea, with its rules owed*.
4. **What a customer sees of a job** (§5). New: [../projects-jobs/gaps.md](../projects-jobs/gaps.md) *What a customer
   sees of a job on the portal*.
5. **Overlapping annual permits** (§9). New: [../projects-jobs/gaps.md](../projects-jobs/gaps.md) *Two annual permits
   for the same asset overlap — the newer one wins?*
6. **Role dashboards, goals and Scalable** (§10). New: [../admin/gaps.md](../admin/gaps.md) *Role dashboards and
   per-user goals — every manager owes a write-up; the Scalable scoreboard beside them*.
7. **Updates, no new entry:** [../quotations/gaps.md](../quotations/gaps.md) *The signing email should come from the
   salesperson*, *The customer PO arrives before the job exists*, the 10-29 *fully built up* update; [../accounting/gaps.md](../accounting/gaps.md)
   *Wishlist vs committed scope*; [../assets/gaps.md](../assets/gaps.md) *Does changing a subcategory's
   configuration reach quotes and jobs that already exist?*

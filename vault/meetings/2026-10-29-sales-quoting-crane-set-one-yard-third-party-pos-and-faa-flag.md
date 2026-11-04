---
title: Sales Quoting — the crane set on the quote, one yard per quote, zero-quantity optional lines, sales coordinator as sales admin, third parties and their POs, the FAA / NOTAM airport flag, quote documents and contracts (29 October 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-10-29_Sales-Quoting - transcript.docx"
migrated: 2026-10-30
updated: 2026-10-30
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/assets, module/dispatch, module/vendors-agencies, module/customers, module/accounting, kind/meeting-notes, associated-assets, crane-configuration, billing-codes, pricing, yards, scheduling, daily-allocation, purchase-orders, permits, lift-plans, geolocation, map-view, notifications, quickbooks, certified-payroll, requirements]
meeting_date: 2026-10-29
---

# Sales Quoting — the crane set on the quote, one yard per quote, third parties and POs, the FAA / NOTAM flag — 29 October 2026

Curated from [transcripts/2026-10-29-sales-quoting.md](transcripts/2026-10-29-sales-quoting.md) (0:32–1:16:16,
complete). **ehtesham.anwar** walked **Ryan Adams** (Sales Manager) through the quotation in the test tenant,
one item of Ryan's list at a time; **Joe Schacatano** (VP of Sales) answered for sales. Other TCG speakers:
**Brian Petros** (Data Analyst, ERP Project Coordinator), **Kyle Harlow** (VP of Fleet and Field Operations),
**Melissa McNutt** (President); before the call, **Corrina Bustos** (HR Manager), **Micaela Dipane** and
**Kaitlin Kiesel** (Accounts Receivable Specialist). CodingCops: ehtesham.anwar, abdulrehman, syed.haris.
Roles are from the 2026 chart in [../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md)
(Joe's and Kyle's titles changed from the 2025 chart; earlier notes use the old ones).

> **Speakers.** Ryan speaks on the conference-room microphone labelled "Brian Petros"; the transcript
> header gives the evidence. Mic turns from 12:30 to 1:14:12 are attributed to Ryan, except 54:29 and
> 1:02:56–1:08:17, which may be either man and are cited as "the room mic". Two mic turns (14:29,
> 1:02:56) are a Brian–Ryan exchange inside one label.

> **Timestamps.** Long turns carry only their start (ehtesham.anwar 16:03, 19:33, 25:36, 30:11, 51:28,
> 57:56, 59:14, 1:08:43, 1:12:07; the room mic 14:29, 1:02:56). A point made inside one is cited by that
> start time.

> **Status.** §2 (the configuration) and the vendor allocation in §7 are CodingCops describing what is
> **built**. Everything else is TCG asking for behaviour — Ryan's list, with Joe, Kyle and Melissa — and
> CodingCops' proposed answers. Nothing here was demonstrated as built unless it says so. The file is
> `status: unverified`.

## 1. Before the call (0:32–10:55)

- **Certified payroll e-tickets.** Micaela Dipane, 1:25: *"for the CPR stuff, will the new ERP send
  Samantha the e-tickets directly? Or no?"* — Corrina Bustos: *"We haven't even got there … When we build
  that out, yes."* Today each ticket is downloaded one by one from FCC, *"especially at CC, you can't just
  like drag and drop"* (1:43), which is slow for a whole crew.
- **QuickBooks access.** Melissa can give normal access, not API access (7:17). abdulrehman will send the
  steps for inviting CodingCops as an **API developer** (7:25). ehtesham.anwar: the API developer role
  reaches the sandbox; CodingCops also needs **one regular user** to see TCG's real data — invite
  ehtesham.anwar for that, abdulrehman for the API (7:36). At 1:15:36 abdulrehman said Melissa had
  already given him access; ehtesham.anwar still needs adding.
- **Configuration review.** Joe Schacatano has not yet looked at the updated configuration in the portal
  and will go over it with Brian today (8:41–9:47). ehtesham.anwar: Joe led that conversation; CodingCops
  wants his confirmation that *"everything is there that is needed for TCG"*.
- **The payroll sheet.** Brian brought Corrina for payroll questions and to give feedback on *"the sheet
  … that Haris gave us"*. abdulrehman: put comments on the sheet; CodingCops will compile them (10:31–10:45).

## 2. The crane set on the quote (15:39–35:37)

- **Ryan's ask** (15:39): adding a crane should auto-populate *"all the counterweight loads, with the sport
  trucks, with the fuel insurance"*. Joe, 16:00: *"They've already got that going."*
- **Built — the subcategory configuration** (ehtesham.anwar, 16:03, 25:36, 30:11, 33:22). Each subcategory
  (here a 100 ton hydraulic) has its **associated field assets**. Each one has a **show** toggle for the
  quotation and the invoice, and is **always included** or **optional**.
  - With nothing shown, the quote and the invoice show only the 100 ton. The job created from that quote
    (job 46) still carries the whole set — crane, oiler, operator load, tractor — and the DAS sends all of
    it (25:36, 30:11).
  - With *show* on for operator load and operator, they appear on the quote grouped with the crane, *"not
    as a separate line item"*. Mob/demob was not tagged, so it showed nothing extra (25:36).
  - An **optional** item can be removed from the quote without an error. A delete icon should be there
    but was not on screen: *"it's a good catch … look into that"* (30:11). Support load 1 made optional
    could be deleted on a new quote (33:22).
  - *"We haven't configured it through the code … you will have the option to configure what shows up on
    the quotation and the invoice. Not us, or not the code"* (30:11).
- **Ryan, 29:11–29:41:** choosing a crane should bring it **fully built up** — crane, operator load and
  support loads, *"go down in a line so you can see each line item"*. It should also add **a travel permit
  for that size crane** automatically, **a line for a potential rigger**, and fuel and insurance. He wants
  to insert lines in between and *"check the box to delete that line item"* when not all the counterweights
  are needed. Repeated at 32:50: *"select the crane and it populate everything that has a line item with
  that crane, which would include a travel permit."*
- **Joe, 32:15–33:00:** e.g. a 265 populates the operator load plus three support loads; the salesperson
  deletes a support load or adds a rigger to get the codes for that quote — *"which is how we'll build it"*.
- **Ryan, 34:42:** put the **counterweight load weights** on the configuration — *"operator load maybe
  44,000, next one would be 88, so on and so forth"* — so picking the 100 ton populates every line. *"We
  would do this in the back end, correct?"* ehtesham.anwar: yes.
- **Adding lines:** *new item* adds a line outside the set (35:37); any item can be added, even another
  crane — *"You don't have any limitation"* (34:25).

## 3. Optional lines at quantity 0 (36:12–37:56)

- **Ryan, 36:26:** add a rigger at 0 — *"a lot of times we're trying to sell a rigger. They're not sure if
  they want it yet, but they want to see the pricing."* He asked Joe (37:10): *"Should we have the optional
  line items with the rate in there, but not adding to the total so that it gives our customers an
  opportunity to add on to each quote?"*
- **Joe, 37:22:** *"you just select quantity 0 and then it's just a note if required … in the comment
  section."*
- **ehtesham.anwar, 37:30–37:45:** today a check stops a quantity of 0; CodingCops will allow it. He tied it
  to the customer portal (*"This opens up a new like idea for client portal"*).

## 4. One yard per quote (17:22–25:36)

- **Picking the yard.** ehtesham.anwar asked whether the yard can be identified automatically (17:22).
  **Joe, 17:47:** by assigning the asset to a yard — a job using that asset then populates from that yard.
  **Kyle Harlow, 18:03–18:49:** from the job location, *"we build a map out"* and populate the yard to pull
  from — asset availability in that yard first, then whether that yard is closer, against *"a map of where
  the cutoff is"*. That yard (not named) has *"a self-loader, a 20, a 40 ton, and a 90 ton"*.
- **Employees in two yards.** **Melissa McNutt, 19:07:** in FCC, sending an asset to the other yard means
  re-assigning its employees to that yard and toggling back, *"and then it messes up payroll and
  everything. So we're actually not able to utilize it"*. She asked for employees assignable to both
  yards. ehtesham.anwar: *"we can"* (19:33).
- **What sales cares about.** ehtesham.anwar, 19:33: at quote time sales cares whether the subcategory is
  available, not which unit. An asset has a default yard; **Joe, 20:53–21:05:** it can change if equipment
  moves.
- **Joe, 21:05–21:27:** when entering the job-site address, the salesperson selects **the yard the quote
  comes out of**. When the quote becomes a job, the auto-populated asset is the one at that yard, with a
  tag that *"this is quoted to come out of this yard"*.
- **Multiple yards on one quote?** **Joe, 22:01:** *"It could definitely be a possibility"* — more for
  project quotations; when each machine is quoted separately, each quote's yard is tagged to its equipment.
- **The rule.** ehtesham.anwar (22:25–23:56): a crane can go job to job, but **billing is always yard to
  job site, never job to job** (Joe and Melissa: *"Correct"*, *"Right"*). *"Quotation always is going to be
  for one yard, from one yard."* **Joe, 24:23: *"Exactly correct."*** Dispatch can still send from any yard,
  from another job, or assemble a fleet from several. Melissa checked that jobs *"up in that area"* are
  quoted from Ventura; Joe: yes, the yard is tagged at the quote (24:32–24:38). ehtesham.anwar: the point
  is billing the customer from the closest yard (24:45).
- **Then:** the DAS should **surface the yard** much more clearly than it does now (ehtesham.anwar, 24:24,
  25:06).

## 5. What must exist before a job is scheduled (38:00–41:31)

- **Ryan, 38:14:** a quote can go ahead without the *Report To* name, but *"before we are able to finalize
  scheduling the job or maybe dispatching it, could we put an alert there that would send everything that's
  needed about this job to the salesperson or sales admin?"*
- **Joe, 39:28:** the alert goes to the sales team and the salesperson, *"so they receive a prompt to make
  sure they fill in that information"*.
- **Ryan, 40:34–40:55:** he must be able to send a quote without the **on-site contact**, and without the
  **lift plan, FAA permit, site plan, encroachment permit, travel permit** — *"But I gotta be able to stop
  it before the scheduling happens without that."*
- **ehtesham.anwar** (38:49, 40:59): put the step at *mark as won* / converting to a job, shown like the
  customer view — the salespeople review and enter what is missing. Ryan, 41:31: *"That is correct."*
  abdulrehman asked which of those fields are required at project creation, like the customer PO (39:50).
  Not answered field by field.

## 6. Sales admin is the sales coordinator (41:33–44:12)

- **Ryan, 41:33:** the sales admin needs access to the same sheet, and *"I need to be able to add a sales
  admin to each quote"*. There are several; they see **all** quotations and can act on all (41:52–42:07).
- ehtesham.anwar: then no field is needed. **Ryan, 42:18:** it is — *"they have commission based off of
  which quotes they're working on"*. Either the sales admin or the salesperson adds it (42:37). Changes are
  logged in the **activity log** (43:05–43:13).
- **Joe, 43:15:** *"the sales coordinator and the sales admin are the same exact thing."* Ryan: *"They are,
  yes."* Keep the **sales coordinator** field: **one** sales coordinator and **one** salesperson per quote;
  sometimes the same person. *"I need to be able to pull it up from sales coordinator versus salesperson and
  separate them"* (43:24–44:01). ehtesham.anwar: *"We'll keep it as it is"* (44:12).

## 7. Third parties on the quote, and their POs (44:18–1:02:28)

- **Ryan, 44:18–45:56:** trucking, machinery moving, street closures — *"to price it out, sometimes we have
  to get third parties involved and then we would be moving that cost over to our customer"*. On the quote
  he wants the third party's name, what they will do, date and time, **the amount charged to the customer
  as a line item**, what the third party **charges TCG**, and **a PO** to send them.
- ehtesham.anwar, 44:30: street closures are being built; **all third parties are vendors**, and Dispatch
  allocates them.
- **Ryan, 47:11:** a **markup percentage** on their charge, so the customer sees the final cost; a PO
  number; **drag-and-drop of their estimate** — *"everything all in one place per job"*.
- **Two options** (ehtesham.anwar, 46:46–48:33): (a) pick a vendor and their price on the quote, with a
  description; (b) mark an existing line — *"this hundred-ton crane"* — as handled by a third party. Either
  way the line uses **the markup, not the billing codes**. His example: 600 at 20 % → *"840"* (20 % of 600
  is 120, so 720; 840 is 40 %).
- **Ryan, 49:29–50:12:** *"we need to show third party as a line item, but not to the customer"* — a pop-up
  with a description (*"transportation"*) and, behind it, the company, their billing and the PO. When a
  crane is not available, Dispatch finds the third party after the quote.
- **Built — vendors in the DAS** (ehtesham.anwar, 50:24–51:28): after the quote becomes a job, Dispatch
  drops a vendor anywhere, allocates their assets (basic details, internal category / subcategory for later
  mapping) and people (name, phone; e-mail and SSN optional), and creates **an internal PO** — the number
  given to the vendor. CodingCops will **prototype both quote options** for TCG to choose (51:28).
- **The gap he showed** (53:18–55:08): a vendor can be allocated, but there is **no communication to the
  vendor** — tickets go only to TCG's own people. *"That's something that I want to discuss with"*
  Lisette, back **Monday 2026-11-02** (53:13–53:18; the transcript reads *"Dallas"*).
- **Who sends the PO.** The room mic, 54:29: *"let's say we hire RCS … would sales be sending the PO number
  over to them, or would Dispatch?"* **Joe, 55:06:** *"they both need the ability."*
- **Joe, 55:50–57:41 — the split:** Dispatch mostly assigns trucking vendors for support loads, or another
  crane company to cover a job. On the quoting side, e.g. **Roadway** (permitting and traffic control) quotes
  5,000 and TCG quotes the customer 6,000: *"that $5,000 amount should generate a PO on the quoting end
  that gets sent directly to Roadway because we're having them proceed and also confirm the job"*, and
  Dispatch sends no PO for that service. Same for machinery movers. *"If we know on the quoting end a
  specific service is 100% being done by a third party, it needs to be produced there. If it's on the
  dispatch end, it's because of asset availability."* Asked by Melissa about a same-day sub-out by Lisette
  (57:23): that is Dispatch, on asset availability.
- **ehtesham.anwar's read** (57:56–1:00:54): gap 1 — the quote cannot mark third-party work to charge the
  customer for it. Gap 2 — when the quote is won, the vendor should get the job details and the PO number;
  the vendor would then be allocated and the PO created automatically, with nothing for Lisette to do in the
  DAS. If Dispatch decides, Lisette creates the PO and e-mails the vendor. **Joe, 1:00:27:** the quote is
  not updated afterwards. **Melissa, 1:00:35:** a PO created on the job should e-mail the vendor like one
  from the quote — Joe: yes. ehtesham.anwar: *"right now we have not implemented anything for the third
  party communication within the portal."*
- **Vendor bills on the job.** Ryan, 1:01:11: drop the vendor's billing into the job *"so everything's saved
  within the same job, and that way we could pull P&L"*. ehtesham.anwar: that is being built for Accounting
  and is on Tuesday's agenda; he invited Ryan (1:01:32–1:02:28).

## 8. Sales in the field (10:55–12:11, 1:02:56)

- **Two things sales built recently** (Brian, 10:55–12:11): a **dispatch scheduling coordination board**
  showing **crane availability**, where coordinators or sales can suggest a time or *"make a reservation
  basically on a crane in advance, but mainly to see the availability"* — *"you can think about how we can
  integrate it into the ERP"*. And a **field form**: a salesperson submits a new job and an e-mail goes to
  the sales coordinator, who enters it for the quote.
- **Playbooks** (13:28–14:23): ehtesham.anwar has the sheet with agencies and permit lead times that tells a
  salesperson whether the job can be done. Brian: *"quite a few"* playbooks were shared. ehtesham.anwar
  wants them talked through, not just sent.
- **Mobile** (the room mic, 1:02:56, Brian and Ryan): could salespeople fill in the quote — or a quote
  calculator or short form — in the field, on a phone or tablet, with pictures, forms and site plans?
  *"Hopefully this is easy enough to where we don't have to have like a separate form."* CodingCops did
  not answer the mobile part.

## 9. The FAA / NOTAM airport flag (1:02:56–1:08:43)

- **The ask** (the room mic, 1:04:30–1:04:54): *"we have a lot of airports right around us, and in a
  certain distance from the airport, we either have to get an FAA or a NOTAM. Is there a way when you enter
  an address, if it's within a certain amount of distance from each airport, that it would automatically
  flag for FAA or NOTAM and add that … as a line item to a quote?"*
- **Map today.** ehtesham.anwar: no map yet, only the job-site location (1:04:16). syed.haris: creating a new
  job site shows a map where the location is pinned (1:05:16). ehtesham.anwar: the system does not yet
  identify whether the pin is inside the FAA / NOTAM range (1:05:36) — but see *Against the vault*: an
  airport check is in the code.
- **Proposed** (ehtesham.anwar, 1:05:53): from the dropped pin, find the nearest airports through a Google
  service; if one is within range, flag FAA. He first said *"30 kilometers"*. The room mic: the FAA keeps a
  certified list of airports (1:05:46).
- **The distance — not settled.** **Joe, 1:06:47:** *"Minimum is 3 miles."* The room mic: *"three nautical
  miles"* (1:06:49). **Joe, 1:07:57:** *"best practices is 3 miles … anytime you actually run the report on
  the FAA … anything at the three mile mark flags it … So that's why I think 3 miles is safer than three
  nautical miles."* The room mic, 1:08:17: *"use 3 miles instead of three nautical miles."* Joe asked
  Melissa to agree (1:08:29); no answer is recorded. **ehtesham.anwar closed with the opposite:** *"I think,
  like Joe, it's going to be safer if we use the nautical miles"* (1:08:43). Three nautical miles is about
  5.56 km, three statute miles about 4.83 km.

## 10. Write-ups, quote documents and contracts (1:08:43–1:14:12)

- **The sales flow.** ehtesham.anwar, 1:08:43: attachments on a quote cannot be tracked. If salespeople must
  photograph the site before a job is scheduled, that is an operational step and needs a flow. He asked for
  **one write-up**, start to scheduled, of the data salespeople capture. Ryan, 1:10:29: *"I'll work on
  that."*
- **A documents page on the quote** (Ryan, 1:10:29–1:10:59): **operator licences** for certain cranes,
  attached per crane size; customer forms such as **a W-9 or a new customer set-up**, sent automatically
  with the quote — *"Or would you want that separate Melissa on the form side?"* ehtesham.anwar: the quote's
  attachment structure already sends the customer form the first time, as Melissa asked (1:11:20).
- **Returned contracts** (Ryan, 1:11:24–1:11:57): drop a customer's signed contract or forms into that
  customer, with start and end dates. ehtesham.anwar (1:12:07): a contract that comes in on a quote updates
  the quote; **contract management is not built**; he asked for a second write-up — how contracts arrive,
  when they are generated and how they are used. Today one PDF goes out.
- **Customer portal:** in progress; requests on the portal will replace the PDF forms, and the write-ups will
  feed it. A preview was shown (1:12:07). Ryan: *"You've got a long way since I've seen you last"* (1:14:12).

## 11. Next

- **TCG:** Ryan writes up the sales flow and contract management, *"for Tuesday"* (1:10:29, 1:14:25). Joe
  reviews the updated configuration with Brian today (9:03). Melissa or Brian adds ehtesham.anwar as a
  regular QuickBooks user (1:14:28, 1:15:36). Brian and Corrina comment on the payroll sheet (10:31–10:45).
- **CodingCops:** allow quantity 0 (§3); the delete icon on optional items (§2); the missing-information
  prompt at won / convert (§5); show the yard in the DAS (§4); prototype the two third-party options (§7);
  vendor communication, with Lisette from 2026-11-02 (§7); the airport check (§9); the steps for the
  QuickBooks API-developer invite (§1).
- **Tuesday 2026-11-03:** accounting, with Brent (Brian, 1:15:46); Ryan invited for vendor bills and job
  P&L (§7). If CodingCops has no QuickBooks user by then, it works from Ryan's documents (1:14:28).

## Against the vault

Checked 2026-10-30 against the vault, the open ticket specs and, where marked, the code. Only the conflicts
and the new points are listed in detail.

- **The airport check already exists, at 5 miles** (§9). [code] `Airport.radiusMeters` defaults to **8047 m
  (5 statute miles)**; migration `20260728140000_scrum_414_airports` seeds 34 airports at that radius, and
  `job-site-location-insights.service.ts` returns `faa.required` and a `faaPermitRequired` suggestion from
  the job site's coordinates. Neither CodingCops speaker mentioned it. The call offered 30 km, 3 statute
  miles (Joe) and 3 nautical miles (the room mic, then ehtesham.anwar); none matches the build, and no
  distance is written anywhere in the vault. [../quotations/sales-intake-and-job-walk.md](../quotations/sales-intake-and-job-walk.md)
  lists *"Near airport"* under airspace, and the Sales Coordinator manual §5
  ([../quotations/sales-operating-system/03-sales-coordinator-operations-manual.md](../quotations/sales-operating-system/03-sales-coordinator-operations-manual.md))
  says *"Evaluate FAA permit, NOTAM and A1 Survey requirements immediately"*. Filed as a new gap (Q1 below).
- **Quantity 0 is blocked by the web only** (§3). [code] The API allows it (`create-quotation.dto.ts`,
  `@Min(0)`, *"Zero is allowed"*). The web allows 0 only inside a Mob/Demob group
  (`create-quotation.helpers.ts`, `isResourceQuantityValid`: *"Quantity must be greater than 0"*). The
  verified [../decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md](../decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md)
  pt 5 (Joe) already says *"A line left at quantity 0 stays out of the total"* — for Mob/Demob lines. Joe's
  answer here extends it to any line, as a priced note. Not the same question as the open *A billing code
  rate may never be zero* in [../quotations/gaps.md](../quotations/gaps.md), which is about the rate.
- **Ryan's "fully built up" crane mostly fits the verified quote model; two parts do not** (§2). The
  verified [../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md)
  (Joe: *"100 ton operator load, travel permit, and a surcharge. That's it."*) and
  [../decisions/2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md](../decisions/2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md)
  (verified; default, not rule) keep the crew and the load's tractor off the quote — the demo showed the
  same (§2: the job carries the oiler, the quote does not). The verified
  [../decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md](../decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md)
  is the *show* toggle demonstrated. **Fuel and insurance** are one surcharge per quote
  ([../decisions/2026-09-02-one-surcharge-per-quote.md](../decisions/2026-09-02-one-surcharge-per-quote.md),
  verified; FCC prints *"Fuel & Insurance Surcharge · 12.00%"*), not lines per crane. **A rigger line by
  default** runs into [../dispatch/crane-configuration-rules.md](../dispatch/crane-configuration-rules.md)
  §9 (the approved sheet dropped the Rigger row, *"Treat it as withdrawn"*); Ryan wants it as an optional,
  priced line, which §3 would allow. **Counterweight weights** exist only for the 190 T trailer capacities
  (*"44000 / 88000 / 119000"*, §5.2; §8 *"No weight field"*). **A travel permit per crane size** lands on
  the open *Permits in Resources — is a permit a quotation line at all*.
- **The delete icon is in the code** (§2). [code] `resource-row.tsx` shows it when `canRemove && !readOnly`,
  with `canRemove = !isChild || resource._childItemRequired !== true`. Its absence on screen needs a repro
  on the test tenant; [../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md](../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md)
  is the rule it implements.
- **Sales admin = sales coordinator answers an open point** (§6). [../dispatch/gaps.md](../dispatch/gaps.md)
  *Schedule fields — the build already agrees, and the new fields are written nowhere* says of the Sales
  Admin column and the sales coordinator *"whether those are one role is not stated"*. Joe and Ryan say
  they are one. [code] `Quotation.salesCoordinatorId` exists, and `quotation-activity-logger.ts` logs
  created, updated (with a diff) and status changes. [../quotations/sales-commissions.md](../quotations/sales-commissions.md)
  pays coordinators per row, with a different rate where the coordinator is also the salesperson — Ryan's
  commission reason agrees.
- **One yard per quote fits the billing rule; the model does not** (§4). Billing yard to job, never job to
  job, agrees with the verified [../decisions/2026-10-22-back-to-back-jobs-scheduled-without-overlap-overlap-is-billing-only.md](../decisions/2026-10-22-back-to-back-jobs-scheduled-without-overlap-overlap-is-billing-only.md)
  (*portal to portal*). Dispatch changing the origin yard agrees with the 2026-03-19 summary. [code]
  `Quotation.yard` is **free text**, which is the open *Quote / Job yard free-text vs Yard master FK* in
  [../projects-jobs/gaps.md](../projects-jobs/gaps.md) — Joe's *"tag"* on the asset needs a real yard.
  **Employees in two yards:** FCC's reference data says *"Some Employees may be working/associated with more
  than one Yard"* ([../payroll/fcc-employee-master-reference-data.md](../payroll/fcc-employee-master-reference-data.md),
  [../admin/fcc-nexgen-administration-and-security.md](../admin/fcc-nexgen-administration-and-security.md));
  [code] `Employee.yardId` is a single FK. Melissa's payroll side effect, and Kyle's auto-pick by
  availability and distance, are new. Joe's *"could definitely be a possibility"* for multi-yard project
  quotes (22:01) and his *"Exactly correct"* to one yard (24:23) are both on tape; the second answered the
  narrower restatement.
- **"Send without, block scheduling" fits the written intent; nothing enforces it** (§5). [code]
  `reportToContactId` is optional; the quote carries `liftPlanRequiredForJob`, `sitePlanRequiredForJob`,
  `needTravelPermit`, `faaPermitRequired`, `encroachmentPermitRequired`. [../decisions/2026-09-11-quote-to-project-permits-plans-flow.md](../decisions/2026-09-11-quote-to-project-permits-plans-flow.md)
  mints those checklist items at conversion, and the Sales Coordinator manual §4–§5 gates them *"before
  scheduling"*. Today *Mark as won* requires only a comment or attachment
  ([../decisions/2026-09-14-quotation-mark-won-requires-comment-or-attachment.md](../decisions/2026-09-14-quotation-mark-won-requires-comment-or-attachment.md)).
  The open *Ready-to-schedule / publish-without-permit gates unenforced* ([../projects-jobs/gaps.md](../projects-jobs/gaps.md))
  is this; the alert to the salesperson and sales coordinator is new. ehtesham.anwar's check at *won* /
  convert sits earlier than Ryan's *"before the scheduling happens"*.
- **Third parties: Joe's split agrees with the PO playbook** (§7). [../vendors-agencies/purchase-orders-fcc/po-001-pre-job-purchase-orders.md](../vendors-agencies/purchase-orders-fcc/po-001-pre-job-purchase-orders.md):
  Sales raises POs for *"roadway / traffic control … permits … ordered during quote/pre-planning"*, anchored
  on the quote number, with the vendor's estimate number. [../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md](../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md)
  (Brian, reference): *"Vendor PO issued early (optional, at quote stage)"*.
  [../vendors-agencies/sub-out-crane-and-trucking.md](../vendors-agencies/sub-out-crane-and-trucking.md)
  says *"Neither sub-out file says who raises the PO or when"* — Joe answers it: Dispatch, at dispatch.
  Markup: [../quotations/quote-profit-forecast.md](../quotations/quote-profit-forecast.md) has *"ALL
  SUBCONTRACTORS WILL BE BILLED AT A MINIMUM OF 10% MARK UP"*; a markup % per line is new. [code]
  `PurchaseOrder` has no quotation relation and there is no markup field; the DAS vendor PO
  (`JobVendorAssetPoAssignment`) is built. [../vendors-agencies/purchase-order.md](../vendors-agencies/purchase-order.md)
  has a non-empty `conflicts_with` — read it through [../vendors-agencies/agencies-vendors-INDEX.md](../vendors-agencies/agencies-vendors-INDEX.md).
  The open register entry is *Purchase orders at three levels — Joe and Ryan on tape, nothing written*.
- **Vendor bills on the job agree** (§7) with the verified [../decisions/2026-10-13-vendor-invoice-attachment-goes-to-quickbooks-with-the-bill.md](../decisions/2026-10-13-vendor-invoice-attachment-goes-to-quickbooks-with-the-bill.md)
  (Brent) and the commissioning thread's *"total profitability per job"*. [code] No vendor-bill model yet.
- **Quote documents and contracts** (§10). [code] The quote's send has an *"Include New Customer Packet"*
  toggle (a separate e-mail); [../customers/new-customer-packet.md](../customers/new-customer-packet.md)
  includes TCG's W-9 — so §10's W-9 ask is built. [../quotations/contracts-and-coi-sop.md](../quotations/contracts-and-coi-sop.md)
  covers routing only; there is no contract model. Operator licences on the quote and contracts per
  customer with dates are new. The customer portal *"in progress"* conflicts with
  [../accounting/gaps.md](../accounting/gaps.md) *Wishlist vs committed scope* (c), where CodingCops placed
  it *"after the first scope closes"* (2026-09-02).
- **Sales on mobile** (§8). [code] `apps/mobile/app/(sales)/quotes/` and `job-walk.tsx` exist; the mobile
  quote builder was deferred to TCG-219 ([../decisions/2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md](../decisions/2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md)
  Q1). The form that e-mails the coordinator is unwritten. The availability board matches the manual
  crane-by-day board in [../quotations/sales-reporting-workbooks.md](../quotations/sales-reporting-workbooks.md)
  §3 (Tentative and Hold states) and the open *Availability at quote time*.
- **Certified-payroll e-tickets** (§1) are new. "Samantha" is not in the vault; certified payroll is Rose
  Aguilera on the 2026 chart. `Quotation.certifiedPayroll` exists; nothing routes tickets.
- **Agrees, nothing to add:** the subcategory configuration (§2) is the 10-06 decision as built; the vendor
  allocation in the DAS (§7) is the 09-22 demo; the playbooks (§8) are under
  [../quotations/sales-operating-system/](../quotations/sales-operating-system/).

## Candidates for a decision note (for `tcg-scrum`)

1. **A quotation is for one yard; billing is yard to job site** (§4). Joe Schacatano (VP of Sales):
   *"Exactly correct"* (24:23), after allowing multi-yard project quotes two minutes earlier. Filed as
   evidence on the yard gap, not written: the restatement was CodingCops', and the multi-yard case is
   unresolved.
2. **The sales coordinator is the sales admin; one per quote, kept as its own field** (§6). Joe and Ryan,
   choosing between adding a field and keeping one. A real choice by the sales owners — the strongest
   candidate. Filed on the dispatch *Schedule fields* gap.
3. **Quantity 0 on any quote line, out of the total** (§3). Joe, answering Ryan's either/or. Filed as a new
   quotations gap with the answer on it.
4. **A service known to be third-party at quote time gets its PO from Sales; a sub-out for availability gets
   it from Dispatch** (§7). Joe. Filed on *Purchase orders at three levels*; the quote-side shape awaits
   CodingCops' prototype.

Not candidates: the airport distance (unsettled on the call); the yard auto-pick (ideas, no choice).

## 12. Questions this raises — filed 2026-10-30

1. **Airport radius** (§9). New: [../quotations/gaps.md](../quotations/gaps.md) *FAA / NOTAM airport radius —
   built at 5 miles, the call said 3 miles or 3 nautical miles*.
2. **Quantity 0** (§3). New: [../quotations/gaps.md](../quotations/gaps.md) *Quantity 0 on an Hourly quote
   line — Joe says it is a priced note, the web blocks it*.
3. **The built-up crane** (§2). Update on [../quotations/gaps.md](../quotations/gaps.md) *Quote line items vs
   dispatch resources …*, and on *Permits in Resources — is a permit a quotation line at all* (the travel
   permit per crane size).
4. **Availability board** (§8). Update on [../quotations/gaps.md](../quotations/gaps.md) *Availability at quote
   time — what sales can see before quoting*.
5. **One yard per quote, employees in two yards** (§4). Update on [../projects-jobs/gaps.md](../projects-jobs/gaps.md)
   *Quote / Job yard free-text vs Yard master FK*.
6. **Block scheduling until documents exist** (§5). Update on [../projects-jobs/gaps.md](../projects-jobs/gaps.md)
   *Ready-to-schedule / publish-without-permit gates unenforced*.
7. **Sales admin** (§6). Update on [../dispatch/gaps.md](../dispatch/gaps.md) *Schedule fields — the build
   already agrees, and the new fields are written nowhere*.
8. **Third parties, POs, markup, vendor communication** (§7). Update on
   [../vendors-agencies/gaps.md](../vendors-agencies/gaps.md) *Purchase orders at three levels — Joe and Ryan
   on tape, nothing written*.
9. **Contracts and quote documents** (§10). New: [../customers/gaps.md](../customers/gaps.md) *Customer
   contracts and quote documents — stored per customer with dates, operator licences per crane size; not
   built, write-up owed by Ryan*.
10. **Certified-payroll e-tickets** (§1). New: [../payroll/gaps.md](../payroll/gaps.md) *Certified payroll —
    sending completed e-tickets to the preparer, not written*.

---
title: ERP Demo Walkthrough Part 2 — Samsara tracking, asset management, double booking, quotation to project and job, daily allocation, first right of refusal, permit tracker (22 October 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-10-22_ERP DEMO-WALKTHROUGH Part 2 - transcript.docx"
migrated: 2026-10-23
updated: 2026-10-23
status: unverified
conflicts_with: []
jira: []
tags: [module/assets, module/quotations, module/customers, module/projects-jobs, module/dispatch, module/payroll, module/accounting, kind/meeting-notes, samsara, associated-assets, crane-configuration, scheduling, daily-allocation, das, map-view, permits, purchase-orders, tools-rigging, lift-plans, mob-demob, holdover, overtime, pricing, data-migration, requirements]
meeting_date: 2026-10-22
---

# ERP Demo Walkthrough Part 2 — assets, double booking, quotation to project, DAS and permits — 22 October 2026

Curated from [transcripts/2026-10-22-erp-demo-walkthrough-part-2.md](transcripts/2026-10-22-erp-demo-walkthrough-part-2.md)
(1 h 16 m 2 s, transcribed 0:27–1:16:01). It continues
[Part 1](2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md)
from asset management. **ehtesham.anwar** walked TCG through the test tenant from the documentation, from
assets to sending tickets, and stopped at progress tracking. TCG speakers: **Brian Petros** (Data Analyst,
ERP Project Coordinator), **Kyle Harlow** (VP of Fleet), **Melissa McNutt** (President), **Jeff Stricker**
(Fleet Manager), **Brent Wagstaff** (CFO), **Patrick McKiernan** (IT Manager, labelled *IT Support*),
**Micaela Dipane**. CodingCops: ehtesham.anwar, abdulrehman, syed.haris. Roles are from
[../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md).

> **Timestamps.** ehtesham.anwar's demo turns are long and the transcript stamps only their start
> (16:24, 27:44, 41:34, 57:13, 1:10:07). A point made inside one is cited by that start time.

> **Status.** §1–§3 and §5–§9 are CodingCops describing what is **built** in the test tenant. Nothing was
> demonstrated against a spec. TCG raised three things of its own: fuel cost per job (§4), jobs booked
> back to back for billing (§5), and the first-right-of-refusal rule (§9). None was settled on the call.
> The file is `status: unverified`.

## 1. Samsara on the assets, and the asset clean-up (8:55–15:36, before the walkthrough)

- **Brian showed Samsara inside the ERP**: an asset's tracking tab shows the vehicle's location for today
  and for earlier days (9:07–11:23). abdulrehman: the test tenant's assets were **linked to the vehicles
  already in Samsara**, and any asset can be **linked or unlinked by hand** from its edit page (10:26–10:57).
  Engine hours can also be calculated from it (10:05).
- **Kyle: trailers carry no tracker.** An asset without the *tracked* marker is a trailer; it shows a
  location only when a tracked truck is hooked to it (11:10–11:21). Kyle: it is the same data as the
  Samsara view, *"but it's nice that it's in there … You don't have to go back and forth"* (11:48).
- **Asset clean-up before go-live** (Brian, 12:18–13:12). Haris asked TCG to compare the assets.
  Brian is working with **Jeff Stricker** to check that every asset moves across cleanly (VIN, serial and
  model numbers) and **which assets have trackers**. Some European cranes' electrical systems do not work
  with the tracker, so **the tracker is on the tractor instead** (Kyle, per Brian).
- Jeff got the platform link and the shared admin login (13:48–15:36). ehtesham.anwar suggested Brian
  **onboard the office employees** so each person tests under their own access (16:44).

## 2. Asset management: categories, subcategories, assets (16:24)

- **Three levels.** A **category** (e.g. mobile crane) holds **subcategories** (e.g. 90-ton, 100-ton), and
  each subcategory holds **individual assets** (unit numbers). Configuration set on the subcategory flows to
  its assets, so it is not entered asset by asset. Categories and subcategories can be created, edited and
  deleted. A category lists its subcategories with an asset count.
- **Subcategory fields shown:**
  - a **target utilization**, e.g. 160 hours a month;
  - **associated attributes**: sections of custom fields with a field type and a *required* flag. The values
    are entered on each asset, not on the subcategory;
  - **associated field assets**: the employees and assets that go with the crane on every job.
- **Associated field assets.** The example 101-ton crane needs an **operator** (employee) and an
  **operator load**. The operator load is itself a subcategory under trailers, with its own associated
  **tractor (semi)** and **operator**. Components nest: each brings its own associated assets, so they are
  not added again on the crane. Each associated item is either:
  - **always included**: dispatch cannot remove it when allocating; or
  - **optional**: dispatch may send it or not.
- **Show or hide on quotations.** Each associated item has two switches, one for the **hourly quotation**
  and one for the **mob/demob quotation**. Off (the default) hides it. §6 shows the effect.
- **Substitutions.** A subcategory lists the subcategories that may stand in for it. The example was a
  101-ton crane that may be replaced by a 100-, 110- or 140-ton. **Dispatch can pick only from that list**,
  and not any other crane. When a substitute is sent, **its own** associated field assets are used. The
  asset manager owns the rule set.

## 3. Creating an asset, its billing code, and tracking (27:34–34:28)

- **Samsara link.** The asset form has a dropdown of the vehicles registered in Samsara (abdulrehman,
  27:34). Picking one fills the **asset name, make and model** from Samsara.
- **Other fields:** unit number; dimensions, transmission and engine; basic unit information.
- **Mobile checklist type:** one of **three types, crane, tractor and trailer**. This is the checklist field
  workers fill on the mobile app.
- **Accounting:** buy and sell information.
- **Additional information** shows the attribute sections from the subcategory or category. More sections
  can be added.
- **Attachments** are grouped as general, product guide, owner's manuals, load charts, equipment drawings
  and meter evidence. Field employees and mechanics pull the files from here. TCG can ask for more groups.
- **A billing code is the last step.** Without one, the subcategory cannot be quoted or used in DAS. A
  quotation on it shows a **"billing code missing"** warning to users with the right access. **Salespeople
  do not see it.** The new billing code had a name, the subcategory, a unit of measure, a default rate (700)
  and the surcharge switch. With the code saved, the warning was gone.
- **Tracking.** The asset's tracking tab shows the Samsara data. The **DAS map view** shows where each
  allocated asset is, which job it is on, and its sensor data.

## 4. Fuel cost per job — asked, not decided (34:28–36:45)

- **Brian** asked whether assets can track **fuel** (fuel card, unit number and mileage) to give a **P&L
  per job**. He would also add the crane's cost and interest rate to get a P&L per job per day (35:01).
  **Brent:** *"details on the cost for each job is super helpful"* (35:17).
- **Melissa:** trucks often fill at the yard the night before, so fuel cannot always be tied to the next
  day's job. Fuel is also delivered on site (*"wet fuel"*) sometimes, on holdovers (35:25–35:42).
- **Brian:** the yard pump could use a keypad that asks for a code, unit number and miles before it pumps
  (35:44). **Jeff:** Samsara already tracks fuel. The asset showed 88% (36:07–36:09). **Kyle:** the shop
  needs a better system. Drivers would enter mileage and the day's job number each time they fill, and
  only a daily record would be accurate (36:22).
- **ehtesham.anwar:** it can be added to the ERP and the mobile app, but how the two sources connect is
  still to be worked out (34:43, 36:45). No owner, no decision.

## 5. Double booking — the build forbids overlaps; TCG books back to back for billing (37:00–41:34)

- **Brian:** the FCC scheduling board shows vehicles double- or triple-booked, the same vehicle in three
  cities at the same minute. Will the ERP allow that, or is there an operational reason for it (37:00)?
- **ehtesham.anwar:** **no double booking.** Allocations are time-based. An asset or employee can be on
  three jobs in a day, but the times cannot overlap (37:41).
- **Melissa (38:21):** billing is **portal to portal**. Ticket time runs from the yard to the job, not
  from job one to job two. *"For the 22 tons, they have three hour minimums, but we have to pay the guys 4
  hours."* To recover that, small cranes are **doubled up** on back-to-back jobs, *"so they look like
  they're in the same place at the same time, but they're not."*
- **Kyle (38:57–40:55):** it is a **billing** matter. The crew is never in two places, is paid only for
  time worked, and the contract forbids working two jobs at once. Each job still bills its own **three-hour
  minimum**. *"There will be overlapping time for billing, but there's not actually overlapping time for the
  people."*
- **Melissa (40:03):** set the jobs' start and end times so that they don't overlap. The customer is billed
  from the **ticket times**, not the scheduled times.
- **ehtesham.anwar:** allowing overlaps would make an intentional double booking indistinguishable from a
  mistake (39:40). A job has three times: start, onsite and estimated end. Back-to-back jobs need all three
  set on both, without overcomplicating dispatch or billing. *"Another thing that we need to dive deeper
  into"* (40:31, 41:34). No decision.

## 6. Quotations (41:34)

- **Statuses:** draft; pending approval and internal approval; sent (waiting for the customer to review or
  sign); **won** once signed; **lost** if declined through the flow or set by hand; expired; archived
  (deleted). A quote can also be **set to won by hand**.
- **Internal approval** has two triggers as stated: a total of **$50,000 and above**, and **any change from
  the billing code's rate**. See *Against the vault*.
- **The form:**
  - the yard;
  - a customer and a job site, either picked or created inline. A new job site takes a name, an address,
    a phone and a fax. Both then appear in the **Customers** module, which also holds customer details,
    work-order information, contacts and job sites;
  - **Quoted To** and **Report To**: a contact added here is saved to the customer profile. Name is
    required;
  - document requirements;
  - **customer PO**, which may be left empty on the quote and is asked for when the quote becomes a project
    (§7);
  - equipment required, description of work, comments, in-house notes;
  - the schedule;
  - **salesperson** and **sales coordinator**, picked from employees with those roles;
  - **billing type** (rental or parts). The field exists but nothing acts on it yet.
- **Resources and the show/hide switches.** On an **hourly** quote with every associated item hidden, adding
  the 101-ton crane added only the crane and a **fuel surcharge** line, because its billing code carries the
  surcharge. After switching the oiler to *show* (a page refresh was needed), the oiler came in too. A
  **mob/demob** quote uses the mob/demob switches. With operator load shown there, the operator load
  appeared and the other associated items did not. Changing the quote type re-applies the matching set.
- **Per-line surcharge.** Each line has a surcharge marker. Turning it off takes the line out of the
  surcharge amount, and the total changes.
- **Tools and rigging** on the quote are checked against the quantity in inventory: the example line
  showed *max 4*. Whether that blocks or only warns was not shown (see *Against the vault*).
- **The subcategory's attributes show on the quote line** as additional information to fill in.
- **Lift planning.** There were two ideas for the attributes: details on each asset, and lift information
  like FCC's. ehtesham.anwar: lift planning now looks like it needs **its own place**, so this structure may
  change.
- **Sending.** The quote is previewed and sent by e-mail through the DocuSign flow. The customer approves
  or rejects. Approval sets it to won. For time, the demo set it to won by hand.

## 7. Projects and jobs (the 41:34 and 57:13 turns)

- **Won → create project.** On won, a popup offers to **create a project**, which sets up the scheduled
  job for DAS. The salesperson can skip it and use **Create Project** later. The popup took a project name
  and the **customer PO** left empty on the quote.
- **Requirements become requests.** The example quote needed a **travel permit**, so a permit request was
  created for dispatch. Larger quotes create several permit and plan requests, all identified from the
  quote at conversion (1:10:07).
- **A project holds many quotations and jobs.** The summary shows the customer, dates, schedule,
  quotation revenue against status, and a job summary.
- **Several customers per project** (*"one of the requirements from Wes"*). A new quotation started from
  the project should **default to the project's customer** and let it be changed. **In the demo it did not
  default.** ehtesham.anwar: *"I don't see the customer … auto selected"*, *"Customer should be
  auto-selected"* (41:34–57:13).
- **Project tabs:** POs, permits and plans, activity log, in-house comments, attachments. **They gather
  every job in the project**; the same tabs on a job show only that job.
- **The job page** carries the quotation's details and quick links to the **quotation** and to the **price
  list** it was priced on (a customer's own list, if linked, otherwise the general one; Part 1 §8). It
  also shows the customer PO and an **invoice history**, which stays empty until invoicing, still being
  designed with Brent's team, is built. Its other tabs are resources, schedule, tools and riggings,
  additional information (the attribute values), POs, permits, attachments and activity.

## 8. The job schedule (57:13)

- Each day has a **start time, onsite time and end time**. Setting the first row offers **copy to all
  days**.
- **Holdover** and **add another day** change the schedule that came from the quote. Dispatch managers can
  do this today. ehtesham.anwar: if the quote's schedule must be the only one, the action can be taken away
  from them. Nobody answered either way.
- The holdover demo was deferred to Tuesday.

## 9. Daily allocation system (57:13–1:08:09)

- **Open until ready.** A new job (job 43) is **open**, so it can't be dispatched, until its **pre-job
  checklist** is met. In the example the checklist was a permit, three assets, two employees, and tools and
  rigging. A tool flagged as needing a **spotter** shows here and on the yard-operations page (Part 1 §6).
- **The layout.** DAS is Lisette's team's command centre. The left panel shows assets by subcategory, with
  vendors at the bottom; assets and vendors can both be allocated. The right panel shows employees,
  operators and temp employees. Each asset shows its status and its Samsara and *available* tags.
- **Recommended panels.** Opening a job switches both panels to a **recommended** set built from the
  associated field assets: the crane, the oiler, the operator load (the trailer), the tractor and the
  operator.
- **Allocating.** Dropping an item where it doesn't fit gives an error. Allocations can be cancelled all at
  once, or saved, and saving updates the checklist. A holdover can be made from DAS too.
- **The next-day rule.** ehtesham.anwar said the recommendations will change after the last session with
  Lisette, where someone said that if a person works a job one day, TCG is legally obliged to ask them first
  for the next day.
- **Kyle's correction (1:08:22–1:10:01):**
  - The rule applies **only when the crew ended on overtime** (premium time) **and the crane goes out again
    before 6 AM the next day**. Then *"that crew has first right of refusal for that crane."*
  - If the crane leaves **at 6 or later**, *"we can put anybody in that machine."*
  - Think of it as the **machine** being paid: *"It's only if they ended on an overtime and the crane's going
    to start again on, in the same shift."*
  - He gave the times as *"before the next day at 6 P.m."* (1:08:40), then *"before 6 A.m."* (1:08:58), then
    *"if it's going to leave at 4 P.m."* and *"at 6 or later"*. Read as 6 AM from the second statement and the
    *same shift* framing. The rule *"is very specific … we'll probably have to like refine that."*
  - ehtesham.anwar: it *"adds another check to our recommendation engine"* (1:09:45).
- **Copy allocation to the remaining days.** It lists the job's remaining days, lets you pick shifts, and
  copies employees, assets or both. The example copied both to the 25th. A job not yet made a holdover keeps
  its next day open.
- **Sending tickets.** Once every allocation and checklist item is green, the job becomes **allocation
  completed** and tickets can be sent. The dialog lets you choose **payroll premiums** and shows each
  employee's ticket number, start time and shift. After sending, the job shows **view progress**. Copy
  allocations and make holdover stay available for the remaining days. The tenant's e-mail addresses are
  demo ones (syed.haris, 1:13:57).
- **Progress tracking** is reached from the job page. It shows the ticket as sent but not opened
  (*"Taylor has not opened this ticket"*), and shift activity from the mobile app appears there once it
  starts.

## 10. Permit tracker (1:10:07)

- The auto-created permit appears under **all permits**, the permit tracker. The tabs follow the process:
  open, application submitted, approved, cancelled. The plan tracker works the same way.
- **Submitting:** mark the application submitted, add an attachment, the **expected return date** and the
  submission method.
- **Approving:** **upload the approved permit**. The upload is **required**, because the file is attached
  to the field employees' documents.
- **The permit PO.** Before approval the purchase-order field was optional. Once the approved permit is
  uploaded, a **PO is required**: create a new one or pick a previously auto-generated one. That PO feeds
  the accounting flows later.
- The job's pre-job checklist updates as each permit and plan is completed.

## 11. What was not covered

- Progress tracking in detail, the mobile app, and how the job reaches payroll (1:13:59).
- The holdover demo (57:13).
- Permit and plan trackers in depth, offered for the next call (57:13).

## 12. Next

- **Tuesday — 2026-10-27, if the next Tuesday was meant:** continue from progress tracking, then mobile and
  payroll, and the holdover (1:13:59, 1:15:47).
- **TCG:** Brian onboards the office employees so each person tests under their own login (16:44). Brian
  and Jeff check the asset data and which assets have trackers (12:52–13:12).
- **CodingCops, discuss further:** fuel per job (§4), back-to-back jobs and billing minimums (§5), the
  first-right-of-refusal check (§9), and where lift planning lives (§6).
- **Feedback at the close:** Melissa: *"Exciting. Looks good. I think it's going to streamline so much."*
  Micaela: *"Life-changing."* (1:15:39–1:15:44)

## Against the vault

Checked 2026-10-23 against every vault file except this note. Most of what was shown repeats the
2026-09-15 and 2026-09-22 demos ([demo 01](2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md),
[demo 02](2026-09-22-erp-live-demo-02-project-schedule-permits-das-allocation-and-vendors.md), both
`unverified`). Only the conflicts and the new points are listed here.

- **Approval triggers conflict again.** *"50,000 and above"* and *"any change from the billing code"* (§6)
  repeat the 10-20 documentation. The build triggers only on a rate **below** the reference rate, or on a
  total **over** $50,000 (`totalAmount > approvalThreshold`). That matches
  [../erp-review-log.md](../erp-review-log.md) *Quote approval (8)*: *"charging above standard rate is
  fine"*. The wording is CodingCops' to correct; see [Part 1](2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md)
  *Against the vault* and [../quotations/gaps.md](../quotations/gaps.md) *Is the $50,000 approval
  threshold inclusive or exclusive?*.
- **Tools over inventory: a warning, not a cap.** [../assets/gaps.md](../assets/gaps.md) *Branch
  fix/das-fixes — a quote may request more tools than exist* records the blocking error turned into a
  warning, *"Exceeds available inventory (max N)"*. The *max 4* in §6 is that warning.
- **Customer PO.** Optional on the quote and asked for at conversion (§6, §7). This agrees with demo 02
  (*"optional because it may arrive later"*). It also agrees with
  [../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md](../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md)
  (`reference`), which says it is *"not a quotation field"*. Nothing says it is required at conversion.
- **Show/hide defaults** (§2, §6) are settled by the verified notes of 2026-10-06:
  - [../decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md](../decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md):
    a direct non-employee association starts **shown**;
  - employee types and nested rows start hidden;
  - [../decisions/2026-10-15-existing-associations-hidden-sub-items-auto-fill-at-zero-one-pair-per-crane.md](../decisions/2026-10-15-existing-associations-hidden-sub-items-auto-fill-at-zero-one-pair-per-crane.md)
    hides existing rows.

  ehtesham.anwar's *"by default … hidden"* is true for those rows. For a new direct pick it is the newer
  spec answer, which has no decision note yet
  ([../quotations/mob-demob-current-rules.md](../quotations/mob-demob-current-rules.md)). The vault calls
  the second quote type *Hourly w/ Mob*.
- **Always included** (§2) is recorded in
  [../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md](../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md)
  (`reference`). That note conflicts with the verified
  [../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md):
  resources are dispatch-side. Today's demo applied *always included* to **dispatch** only, which is how
  the 09-16 note leaves it.
- **Substitutions** (§2). The allowed list agrees with FCC's unit-type table
  ([../assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md) §5,
  `unverified`). Two points don't:
  - *"Dispatch can only pick from the list"* had a **vendor-path exception** as of the 2026-09-18 UAT
    register: vendor assets bypass the substitution check.
  - *"The substitute's own associated assets are used"* is not in the vault.
- **Samsara** (§1, §3). Linking an asset to its Samsara vehicle agrees with demo 01, which filled make,
  model and **VIN** (today it filled name, make and model). Engine hours come from the **lower engine
  only**; upper-engine hours stay manual
  ([../assets/asset-record-requested-additions.md](../assets/asset-record-requested-additions.md)).
  The tracker-on-the-tractor point is already in [../assets/gaps.md](../assets/gaps.md) *One Asset ↔ one
  Samsara asset*.
- **Double booking** (§5). The build's no-overlap rule agrees with
  [../dispatch/daily-allocation-system.md](../dispatch/daily-allocation-system.md), read through its
  stub, and with TCG-186. TCG's *"support double booking"* ask
  ([2026-08-12-sell-side-workflow-and-scheduling.md](2026-08-12-sell-side-workflow-and-scheduling.md))
  now reads as **billing-only** overlap. The reason was not in the vault before: recovering the gap
  between a 22-ton's 3-hour billing minimum and the crew's 4-hour pay
  ([../customers/new-customer-packet.md](../customers/new-customer-packet.md); PAY-040).
- **Pre-job checklist** (§9). The spec lists lift, site and travel plans. The build adds tools and
  rigging. A drop on the wrong slot is an **error**; the spec has unavailable resources *"greyed out but
  still drag-gable with a system warning"*.
- **Permit PO** (§10). This agrees with
  [../decisions/2026-09-11-permit-approval-requires-linked-po.md](../decisions/2026-09-11-permit-approval-requires-linked-po.md)
  (`reference`). That note exempts annual (purple) travel permits, which the demo did not mention.
  Picking an *auto-generated* PO, and recording the submission method at submission, are not in the vault.
- **New, not in the vault:**
  - the first-right-of-refusal rule (§9);
  - several customers per project, and the project's customer as the default on a new quote (§7). The
    code does not pre-fill it;
  - project tabs gather every job's POs, permits and attachments (§7);
  - the *billing code missing* warning is hidden from salespeople (§3). That sits against the review
    log's *"do not show quoteable items without valid pricing"*;
  - the sales coordinator field on the quote (§6);
  - the *equipment drawings* and *meter evidence* attachment groups (§3);
  - lift planning to leave the sub-category attributes (§6);
  - fuel cost per job and the yard-pump keypad (§4).

## Candidates for a decision note (for `tcg-scrum`)

1. **First right of refusal on the next day's crane** (§9). Kyle Harlow (VP of Fleet) corrected the rule
   CodingCops had from Lisette: it applies only when the crew ended on overtime and the crane goes out again
   before 6 AM. He stated it as an existing rule, not as a choice between options. He also said it *"is very
   specific … we'll probably have to like refine that"*, and his times are garbled once (*6 P.m.* / *6
   A.m.* / *4 P.m.*). It is filed as a gap with his words as evidence.
2. **Back-to-back jobs: no overlap on the schedule, bill from ticket times** (§5). Melissa McNutt
   (President), 40:03: *"we'll just have to do our start end times where they will allow it to double book
   without really double booking it … the ticket times will be the actual times."* Kyle agreed it belongs
   on the billing side. That supports the built no-overlap rule, but ehtesham.anwar left it to *"dive deeper
   into"*, and it doesn't say what the invoice bills. It is filed as a gap.

Nothing else on the call was a TCG owner choosing between alternatives.

**One declined, one written, 2026-10-23 (`tcg-scrum`, at syed.haris's request).**

1. **Declined.** Under the folder's convention
   ([../decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md](../decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md);
   Part 1's decline), a note records only a point where a TCG owner **chose between named
   alternatives**. Kyle did not choose. He corrected the facts of an existing rule that ehtesham.anwar
   had described as a legal obligation (57:13). The narrowing on its own (*"not every next day, only
   after overtime"*) was considered and also declined, because its condition is the unclear part:
   - Asked *"Overtime for them, or overtime as a general?"* (1:08:45), Kyle answered *"for the machine
     … think of it as like the machine gets paid"* (1:08:58). Whose overtime triggers the rule is still
     open.
   - The cut-off time is transcribed three ways (1:08:40, 1:08:58, 1:09:17).
   - Kyle twice said the rule needs refining (1:09:32, 1:09:58).
   - Where the rule comes from (the union agreement, a contract or practice) is unknown. If it is a
     contract clause, that clause is the authority, not a paraphrase of it.

   **G4 does not apply as stated.** The rule decides who is offered the next day's crane, not what
   anyone is paid, so it has no place in
   [../payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md). It *reads* a payroll
   fact, whether the shift ended on overtime. Any check would take that from payroll's
   classification and leave it unchanged. G4 would apply only if the source turns out to attach pay to
   the right, for example pay owed when the crew is passed over. Nobody said that.

   The entry [../dispatch/gaps.md](../dispatch/gaps.md) *First right of refusal on the next day's
   crane* stays open and unedited. Its question (a)–(f) already holds Kyle's words, including the
   narrowing, so nobody should build the broad *"always ask yesterday's crew"* version from it. A note
   can be written once Kyle (or Corrina Bustos, if it is a union rule) confirms the trigger in writing
   or picks between stated options on a call.
2. **Written, scheduling half only:** [../decisions/2026-10-22-back-to-back-jobs-scheduled-without-overlap-overlap-is-billing-only.md](../decisions/2026-10-22-back-to-back-jobs-scheduled-without-overlap-overlap-is-billing-only.md).
   It is `verified` on the folder's convention for a named TCG owner on a recorded call (*"Not
   confirmed in writing"* in its `decided_by:`). ehtesham.anwar put the choice to TCG: allowing double
   booking in the system would make an intentional overlap look the same as an error, so *"how would you
   guys like to handle this within the operational system?"* (39:40). Melissa chose: set the start and
   end times so the jobs do not overlap (40:03–40:23). Kyle agreed: *"they won't be actually double
   booked on the schedule, right?"*, and the overlap is *"done on the billing side"* (40:36–40:47). Both
   hedged (*"I think"*), and the note says so. ehtesham.anwar's *"dive deeper into"* (40:31, 41:14) was
   about the billing calculation, so the following are recorded as not decided:
   - what the second job's invoice bills (from the yard, or from the end of job one);
   - whether each job bills its full minimum;
   - whether DAS warns or blocks;
   - tentative jobs.

   [../accounting/gaps.md](../accounting/gaps.md) *Back-to-back jobs billed portal to portal* stays open,
   with an *Update 2026-10-23* line: (d) is answered for the schedule, and (a)–(c) are open.

## 13. Questions this raises — filed 2026-10-23

No ticket covers these, so each went to a module register: a new entry where none existed, otherwise an
*Update 2026-10-23* on the open entry.

1. **First right of refusal** (§9). New: [../dispatch/gaps.md](../dispatch/gaps.md) *First right of
   refusal on the next day's crane — Kyle's overtime-before-6-AM rule, written nowhere*.
2. **Back-to-back jobs and billing minimums** (§5). New: [../accounting/gaps.md](../accounting/gaps.md)
   *Back-to-back jobs billed portal to portal — billed time overlaps, crew time must not*. There is a
   pointer update on [../dispatch/gaps.md](../dispatch/gaps.md) *Allocating by shift time (TCG-186)*.
3. **Fuel cost per job** (§4). New: [../accounting/gaps.md](../accounting/gaps.md) *Fuel cost per job —
   where the fuel figure comes from, and whether the ERP reports profit per job*.
4. **Several customers per project** (§7). New: [../projects-jobs/gaps.md](../projects-jobs/gaps.md)
   *Several customers in one project — "a requirement from Wes" written nowhere*.
5. **Approval wording** (§6). Update on [../quotations/gaps.md](../quotations/gaps.md) *Is the $50,000
   approval threshold inclusive or exclusive?*. This is CodingCops' to correct, not a TCG question.
6. **"Billing code missing" hidden from salespeople** (§3). Update on [../quotations/gaps.md](../quotations/gaps.md)
   *Should the API enforce billing codes and whole-dollar rates on quote lines?*.
7. **Lift planning out of the attributes** (§6). Update on [../quotations/gaps.md](../quotations/gaps.md)
   *Additional Information on a quotation — does a sent quote freeze it …*.
8. **Asset clean-up and trackers** (§1). Update on [../assets/gaps.md](../assets/gaps.md) *Which
   dispatchable cranes are untracked, and what stands in for them*.
9. **Dispatch changing the quoted schedule** (§8). Update on [../dispatch/gaps.md](../dispatch/gaps.md)
   *Make Holdover — every unit of a line, who may set it, and at what stage?*, part (b).

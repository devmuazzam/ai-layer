---
title: Sales Operations and HubSpot Playbook — the CRM opportunity lifecycle and data standards
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The Crane Guys Sales Operations and HubSpot Playbook copy.docx
migrated: 2026-09-04
updated: 2026-08-06
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/customers, kind/sop, integrations, requirements, reference-data, reporting, lift-plans, permits]
entities: []
---

# Sales Operations and HubSpot Playbook — the CRM opportunity lifecycle and data standards

**What this is.** A 20-chapter sales manual, subtitled *"Using HubSpot as Our Sales Operating
System"*, written in the Sales Manager's voice. Most of it is coaching and culture. **Four
chapters are substantive for the ERP** — the opportunity lifecycle (ch. 6), CRM data standards
(ch. 7), quoting standards (ch. 9) and the Sales-Operations division of labour (ch. 5) — and this
page covers those, with the rest summarised.

**Why it matters.** HubSpot is one of the six systems of record the operating architecture names,
and it is the one that owns **opportunity stage, next action, follow-up and lost reason**
([sales-operating-system/01-operating-system-architecture.md](sales-operating-system/01-operating-system-architecture.md)
§9). This document defines those states. It is also the only place in the drop that says what a
*good* customer record contains.

> **HubSpot's 12 stages and the Process Map's 13 stages are different lists.** They overlap but
> neither is a renaming of the other — HubSpot ends with Invoiced and Customer Follow-Up; the
> Process Map ends with Job Closeout and never mentions invoicing. **Nothing in the drop maps one
> onto the other.**

---

## 1. What HubSpot is, and is not

Two lists from chapter 2, useful because they scope the CRM against the ERP:

> **What HubSpot Is** — a shared system of record for opportunities, customers, contacts,
> activity, follow-up and forecasting.
>
> **What HubSpot Is NOT** — the document is explicit that it is not a surveillance tool, not a
> replacement for judgement, and not a substitute for talking to customers.

The stated problem it solves: *"One salesperson calls a project 'Pending.' Another calls it
'Quoting.' Someone else leaves it as 'New.' Before long, nobody knows the true status of the
opportunity."*

## 2. The 12-stage opportunity lifecycle

| # | Stage | What it means, and what must happen |
| ---: | --- | --- |
| 1 | **New Opportunity** | Created *"as soon as we identify a legitimate customer need"*. Sources listed: incoming call · email inquiry · website lead · referral · repeat customer · **job walk request** · salesperson prospecting · **emergency call**. Minimum fields: customer name, contact name, phone, email, project location, brief description of work, assigned salesperson. *"If additional information is unknown, that's okay."* **"Do NOT leave opportunities sitting here. Every new opportunity should have a scheduled next action before the end of the day."** |
| 2 | **Qualification** | *"Not every phone call becomes a project."* Determines: what is being lifted · weight · location · when needed · **does the customer have a budget** · do we have capable equipment · is more information required. Also identifies additional services — rigging, transportation, **storage**, engineering, lift planning, traffic control |
| 3 | **Job Walk (if required)** | *"Not every project requires a job walk. However, complex projects should be evaluated before pricing."* Identify: crane setup location · ground conditions · access limitations · power lines · **underground utilities** · overhead obstructions · **swing radius restrictions** · delivery access · customer concerns · safety concerns. *"**Photos should always be taken whenever possible… uploaded into HubSpot**, so Sales Operations, Dispatch, and Operations have access to them later."* |
| 4 | **Quoting** | The quote must reflect equipment, operator, rigging, transportation, travel time, permits, engineering, lift planning, traffic control, additional labour and *"any other anticipated project costs"*. *"**Do not assume additional services are included.** If something is required to complete the job, it should either be included or discussed with the customer before sending the proposal."* |
| 5 | **Customer Review** | *"This stage does not mean we stop communicating. In fact, this is where follow-up becomes most important."* Four scripted follow-up lines are supplied |
| 6 | **Awarded** | *"Winning the project simply starts the next phase."* Immediately confirm: **Purchase Order · Contract requirements · Certificates of Insurance · Requested dates · Customer contact information · Billing information · Special project requirements** |
| 7 | **Pre-Scheduling** | *"This stage belongs primarily to Sales Operations."* Review customer info, project info, PO, contract status, insurance requirements, **Lift Plan, FAA permit, NOTAM, travel permits**, special instructions, customer requested schedule. *"Nothing should be sent to Dispatch until these items have been reviewed."* |
| 8 | **Ready for Dispatch** | Sales has sold the work; Sales Operations has completed the administrative requirements. *"Dispatch should receive a complete package rather than several phone calls asking for missing information."* |
| 9 | **Scheduled** | Dispatch has assigned crane, operator, support equipment, date, time, travel requirements. *"The customer should receive confirmation once scheduling has been finalized."* Changes after scheduling *"should immediately be documented in HubSpot"* |
| 10 | **Completed** | Record notes on additional work, customer feedback, project issues and future opportunities |
| 11 | **Invoiced** | *"Accounting has completed billing… Customer service doesn't stop once the invoice is sent."* |
| 12 | **Customer Follow-Up** | *"This is the stage many companies skip. We won't."* Four scripted questions supplied, including *"Was our crew on time?"* |

**Opportunity rules — seven, stated as absolutes:**

- Every opportunity must have an **assigned owner**
- Every opportunity must have an **expected close date**
- Every opportunity must have a **scheduled next activity**
- Every opportunity must be **updated when its status changes**
- Every opportunity must be **moved to Closed Won or Closed Lost once the outcome is known**
- **Closed Lost opportunities should include the reason whenever possible**
- *"Never leave opportunities sitting in a stage that no longer reflects reality"*

**"Closed Won / Closed Lost" is a thirteenth and fourteenth state** the stage list does not
contain — the lifecycle runs to *Customer Follow-Up*, but the rules require a Won/Lost close. FCC
carries the same three outcomes on its side (`WON` / `PEND` / `LOST` with a lost code) —
[sales-reporting-workbooks.md](sales-reporting-workbooks.md) §2. **Two systems, two status
vocabularies, and the drop does not say how they stay in step.**

## 3. CRM data standards

The stated goal is the clearest requirement in the chapter:

> *"**If someone who has never worked with that customer opens their HubSpot record, they should
> be able to understand who the customer is, who to contact, what work we perform for them, and
> where the current project stands.**"*

**Company record** — full legal company name · main office address · website · main phone ·
industry · **customer type (Utility, General Contractor, Industrial, Commercial, Municipality, EPC
Contractor, etc.)** · **payment terms** · **credit status (when available)** · general notes.
*"If a company has multiple offices, branches, or divisions, make sure the correct location is
associated with the project."*

**Contact record** — full name · job title · direct phone · mobile phone · email · office location
· department · **preferred method of communication**. *"Do not rely on one contact."*

**The roles a customer contact may hold**, as listed: Project Manager · Superintendent ·
Estimator · Purchasing · Safety Manager · Project Engineer · Foreman · Operations Manager ·
Dispatcher · Accounts Payable · Facility Manager · Property Manager · Utility Representative.

> **That is a 13-value contact-role vocabulary and the vault has none.**
> [customers/customer.md](../customers/customer.md) and the Atom guide's *Ordered By / Report To*
> dropdown are the nearest things, and both are far coarser.

**Jobsite information** — jobsite address · **access instructions** · **gate codes (when
appropriate)** · site contact · site phone · **delivery restrictions** · **working hours** ·
**parking restrictions** · **customer safety requirements**.

**Notes.** The document gives a worked contrast:

> Instead of *"Called customer."* — write *"Spoke with John Smith regarding transformer
> replacement at the Anaheim facility. Customer expects final schedule next Tuesday and requested
> a revised quote including rigging."*
>
> *"Avoid personal opinions or emotional comments. Remember that many people inside the company
> may eventually read these notes."*

**Opportunity naming convention** — **`Customer Name – Project Name – City`**. Examples given:
*"Southern California Edison – Pole Replacement – Anaheim"*, *"ABC Mechanical – Chiller
Replacement – Irvine"*, *"Turner Construction – Steel Erection – Los Angeles"*. Explicitly
forbidden: *Crane Job · New Project · Lift · Quote · Miscellaneous*.

**Required before a quote is sent** — customer name · contact information · project name · jobsite
address · description of work · **estimated lift weight** · **estimated lift radius** · requested
schedule · **recommended crane** · additional services required · special customer requirements.
*"If information is unavailable, **document what is still outstanding** so Sales Operations knows
what needs to be collected."*

**Required before scheduling** — complete customer information · complete jobsite information ·
PO (if required) · contract status · COI requirements · **lift plan status** · **FAA permit
status** · **NOTAM status** · **travel permit status** · requested date · requested start time ·
on-site contact · special instructions.

**Documents to upload** — jobsite photos · site drawings · lift plans · engineering drawings ·
purchase orders · contracts · customer specifications · safety requirements · equipment layouts.

## 4. Sales vs Sales Operations

Chapter 5 defines the split, and the six-step Sales Operations workflow inside it.

| Sales Representative | Sales Operations Coordinator |
| --- | --- |
| Builds customer relationships | Supports the sales process |
| Finds new opportunities | Creates and maintains CRM records |
| **Conducts job walks** | Verifies customer and project information |
| **Prepares and presents pricing** | **Coordinates COIs, contracts, permits, FAA, NOTAMs** |
| Negotiates and closes work | Tracks documentation and uploads files |
| **Owns the customer relationship** | **Owns the administrative workflow** |
| Looks for additional business | **Prepares complete job packages for Dispatch** |
| Resolves customer concerns | Maintains data quality in HubSpot |

**The Sales Operations workflow, six steps:**

1. **Opportunity Review** — confirm the opportunity is legitimate; enter it with all available
   information; chase what is missing before moving forward.
2. **Customer Verification** — customer name · billing address · jobsite address · main contact ·
   **on-site contact** · phone numbers · email addresses · **purchase order requirements** ·
   credit terms.
3. **Project Documentation** — site drawings · photos · lift plans · engineering drawings ·
   **utility requirements** · special customer instructions · access information · **crane setup
   location** · delivery restrictions · safety requirements. *"The objective is to eliminate
   surprises before scheduling."*
4. **Permits and Regulatory Requirements** — city travel permits · **route reviews** · FAA permits
   · NOTAM requests · customer-required documentation · traffic control coordination ·
   third-party vendors. *"These items often require additional lead time, so they should be
   started as early as possible."*
5. **Contract and Insurance Coordination** — send contracts for review · coordinate redlines
   **through Sales Management** · request COIs · coordinate endorsements · verify insurance
   requirements · track document completion.
6. **Scheduling Preparation** — verify twelve items before Dispatch (the same list as *Required
   before scheduling* in §3). *"Only after this information has been confirmed should the project
   move to Dispatch."*

**Step 5 agrees with the Contracts and COI SOP** on routing redlines through Sales Management —
see [contracts-and-coi-sop.md](contracts-and-coi-sop.md) — though this document has Sales
Operations, not the salesperson, sending the contract.

## 5. Quoting and customer-communication standards

Chapter 9. The operationally testable parts:

**Follow-up cadence, stated as a guideline:**

- **Within 24–48 hours** — confirm the customer received the quote
- **Within one week** — check on project status
- *"Continue following up professionally until the project is awarded or closed"*

**Fifteen questions to ask before quoting** — what is being lifted · weight · location · when
scheduled · **required lift radius** · **hook height needed** · **how much setup space is
available** · overhead obstructions · underground utilities · **is the ground suitable for crane
setup** · road closure or traffic control · lift plan needed · permits required · restricted
access · rigging or transportation required.

**Twelve things a quote should identify** — crane provided · operator included · **estimated
duration** · travel charges · rigging (if included) · transportation · permit costs · lift
planning · engineering services · **overtime rates** · **standby rates** · ***"any assumptions
made during estimating"***.

**Six things never to promise** — equipment availability without confirmation · **schedules that
Dispatch has not approved** · permit approval dates · FAA approval timelines · engineering
completion dates.

**Quote revisions** — *"Respond promptly. Update the opportunity in HubSpot. **Document what
changed.** Save the revised proposal. **Avoid creating confusion by having multiple versions with
unclear naming.**"*

> That last line is the CRM-side statement of the same problem [quotations.md](quotations.md)
> raises as *"Change revisions for quotations"*, *"why do we have resend and resend quote"* and
> *"resend should be 1 button and it should send latest quote"*. **Neither document defines what a
> revision is.**

**Don't guess** — where crane selection, lift capacity, rigging requirements, permit requirements,
FAA restrictions or engineering concerns are uncertain, *"Ask for assistance. Work with Sales
Operations, Project Engineering, or Management."*

## 6. The rest of the document

Summarised rather than transcribed, because it is coaching rather than specification:

| Chapters | Content |
| --- | --- |
| 1–4 | Mission · why HubSpot · sales philosophy · the sales representative's role, daily responsibilities, and what must be logged (**phone calls, emails, meetings, job walks**) |
| 8 | Daily workflow and time management — *"Start Every Day in HubSpot"*, task/email/calendar management, working with Sales Operations, common time wasters |
| 10 | From awarded project to dispatch — the handoff, and what must be verified before scheduling |
| 11 | Building customer relationships |
| 12 | Performance expectations and accountability |
| 13 | Managing opportunities the right way |
| 14 | Working as one team — *"One Team. One Process. One Customer Experience."* |
| 15 | The Sales Playbook — the process followed on every opportunity |
| 16 | Follow-up and customer retention |
| 17 | Growing your territory and developing new business |
| 18 | **25 "Golden Rules"** — including *#17 Every Opportunity Needs a Next Step*, *#23 Learn From Every Lost Opportunity*, *#12 Don't Create Surprises* |
| 19 | Daily / weekly / monthly / quarterly success checklists, plus a **customer visit checklist**, a **job walk checklist** and an **opportunity health checklist** |
| 20 | A closing message from the Sales Manager |

## Source

`3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The Crane Guys Sales Operations and HubSpot Playbook copy.docx`
— 173 KB docx → pandoc gfm, 3,564 non-blank lines, 20 chapters. **The document carries no author,
version or date block**; it is written in the first person as the Sales Manager. Chapters 5, 6, 7
and 9 are transcribed or tabulated above; the remainder is summarised. **No customer data appears
in it** — the named examples (John Smith, ABC Mechanical, Turner Construction) are illustrative.

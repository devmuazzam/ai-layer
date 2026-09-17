---
title: ERP live demo 01 — configuration through DAS, and "quote line items are not dispatch resources" (15 September 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-09-15_ERP LIVE DEMO 01 - transcript.docx"
migrated: 2026-09-17
updated: 2026-09-15
status: unverified
conflicts_with: [decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md]
jira: []
tags: [module/quotations, module/assets, module/dispatch, module/projects-jobs, module/payroll, module/admin, module/field-ops, kind/meeting-notes, pricing, signatures, craft-code, craft-modifier, yards, permits, lift-plans, daily-allocation, tools-rigging, geolocation, authentication, integrations, sprint-planning]
entities: []
meeting_date: 2026-09-15
---

# ERP live demo 01 — configuration through DAS, and quote lines vs dispatch resources — 15 September 2026

Curated from [transcripts/2026-09-15-erp-live-demo-01.md](transcripts/2026-09-15-erp-live-demo-01.md)
(1 h 22 m 2 s). Labelled speakers: Brian Petros, Corrina Bustos, Micaela Dipane, Melissa McNutt,
**Joe Schacatano** (VP of Sales), Ryan Adams (Sales Manager), Kyle Harlow, "IT Support" (Patrick),
ehtesham.anwar (presenting), abdulrehman, syed.haris. Wes Staley present, with no labelled turn.
**Lisette Anzaldo absent**. She is back Friday 2026-09-18 and will watch the recording (Corrina 4:55,
1:17:07). This is the first of the from-scratch walkthroughs Brian asked for on 2026-09-10
([2026-09-10 notes](2026-09-10-rate-buckets-rest-chain-holiday-minimum-and-work-orders.md) §8).

> **A demo describes shipped code. It is not a source for a spec.** §1 records what
> CodingCops showed on a clean tenant, as a dated description of the build. It does not show that
> anyone at TCG asked for or accepted that behaviour. Where it touches an open question, the
> question stays open.

> **Forward-looking.** §2–§7 are what named TCG people said. **No binding client decision was made
> on this call**, so no decision note was written. The one near-decision, Joe's in §2, gave a
> principle and left the model to be supplied later. Each item says where it is registered.

## 1. What was demonstrated (dev team, as built on 2026-09-15)

The demo ran in a **clean tenant**. Ehtesham said a second, seeded tenant (FCC-derived data plus
configuration) exists and would be handed over after the demos (7:20, 1:16:04).

| At | Area | What was shown, and what the presenter said about it |
| --- | --- | --- |
| 6:17 | Dashboard | Placeholder. Per-employee and per-department dashboards are **still to be decided**. |
| 6:17–7:20 | Yards | Multiple yards; physical and mailing address; attachments. **Per-yard counters** for minting artefact numbers (employee, quotation, job…) are built but **not enabled**, *"we haven't decided on the exact nomenclature of all of these artifacts"*. Yard selection appears on the quotation. |
| 7:20 | Departments | Created before employees; web module access set per department (*No access* = no web). |
| 7:20 | Unions | L12 with classifications. Non-union is modelled as a union named *non-union* with a *non-union* classification. |
| 7:20–13:16 | Craft codes | e.g. `L12 T1`; active/inactive; union classification; role type (operator); group (seeded groups; *"group 6 and above qualifies for the long lattice pay premium"*, consistent with `payroll/rules/PAY-044-lattice-boom-premium.md`). Effective-dated rates, with open-ended = current, and an overlap error when a rate already covers the date. |
| 13:18 | Craft modifiers | Quick-action bracket generator: start, end and step (default 20); per-step adders shown as **placeholders**, operator +0.75 and oiler +0.25; *long boom* brackets **80 → 400**; brackets can be added above and below the range with rates auto-managed. (The 2026-09-02 demo showed 80 → 520 ft and +4.25 oiler. These values are demo inputs, not rates.) |
| 13:18–20:42 | Employee profile | ID auto-minted from counters if blank; contact, SSN, department and role. **Roles and permissions are built but not applied yet.** An interim *employee type* is used instead. Payroll profile: role *operator* auto-selects **Craft-Based Hourly**, and *Salary* shows pay status, **ADP file number**, amount, frequency, effective dates, union status and payroll group. Primary craft code with over-scale; secondary craft codes (an operator's **oiler** craft code is picked up automatically when he goes out as an oiler). Tabs for employment history (re-hire rows), leaves, managed assets, activity log, notes, attachments, training, performance, classifications, drug tests and certifications. |
| 20:23 | Emergency contacts | Asked by Corrina and shown to exist (§6). |
| 20:58–24:42 | Assets | Category → sub-category (e.g. *Mobile Cranes* → *100 Ton*, with target utilisation hours per month and attributes) → asset. One asset links to one **Samsara** asset, which auto-fills make, model and VIN. Tabs cover upper/lower meter hours, miles, registration, mechanical, transmission, dimensions, purchase and sale, rates, and attachments (product guides, load charts, owner manuals). A **tracking tab** maps all assets from Samsara (*"we are just consuming this information"*). Company defaults to The Crane Guys. |
| 24:42–24:48 | Checklists | Read-only settings view: pre-trip/post-trip forms for cranes, tractors and trailers, *"added in the back end"* and **not yet functional**. |
| 24:48–31:28 | Associated field assets | Built on the **sub-category**, not the asset: a *100 Ton* crane carries an oiler and an **operator load**, and an operator load (a trailer sub-category) carries an operator and a truck. Ehtesham presented this as the set that auto-fills a quotation. **This is the configuration Joe objected to in §2.** |
| 31:28–54:21 | Quotation | Customer, job site and contacts, each with inline create. Yard, customer PO, and document requirements (lift plan, site plan, FAA permit, sub-hauler, encroachment permit) that drive what the project and job create. Salesperson auto-attached, and it needed an employee typed *salesman* (syed.haris, 36:07). Certified payroll from the customer profile. The associated set auto-filled into Resources. Admin-only **quick-create billing code** from the quotation. Billing codes are the **master price list**. Price list: the customer's list is preferred, falling back to master per billing code. Approval: salesperson → sales coordinator, and on to **sales manager at the $50,000 rule or on a charge below the billing-code rate**. A new customer is auto-detected, which turns the new-customer toggle **off**. Billing information / pre-labor form. DocuSign send, covering email and welcome/new-customer-packet email. Customer view, sign, and **customer PO entered at signing**; status flips to **Won** on signature. Signed PDF and signature detail. |
| 45:27–54:21 | Project and job | Project created from the Won quotation, with PO carried. Plan and permit artefacts minted from the quotation's requirements. Multiple quotations per project. Job shows customer, site, PO and linked quotation, plus the required permits and plans. |
| 55:04–56:42 | Quotation actions | **Duplicate** (within the same project or detached); customer revision request through DocuSign, then resend or cancel, and auto-cancel-and-resend after updates; **manual Mark as Won** (sign date, comment, attachment); Mark as Lost; delete; archive. Internal change requests. |
| 1:00:01 | Job detail | Linked price list (blank = master); customer PO (enterable if the customer left it blank); invoice history (placeholder); **Schedule**: start/end dates, add days, leave-yard, on-site and estimated end times, apply-to-all or per day. **Jobs longer than 24 h, where the end time changes the date, are "within the next two weeks in development".** |
| 1:02:52–1:09:40 | DAS | Assets left, employees right, the day's jobs in the middle. Job-readiness pre-checklist (lift plan, site plan, permits, required field assets, tools and riggings). Recommended assets and employees for an opened job; allocation by sub-category with the concrete asset changeable. **Allocating an employee with no matching primary craft code prompts for a craft code to use on this job.** Job stays open until allocations are saved; checklist rows turn green as satisfied. |
| 1:02:52 | Permit / planning trackers | Artefacts open with due-date tags (*due today* here, because the job was dated today). Uploading a lift plan converts it to approved, and the DAS checklist updates live without refresh. Permit: application submitted → approved upload, with cost, application number, date received, and a **required PO** for that format; POs created inline, **open/close**, closed once an invoice is attached. No agencies in the clean tenant, so that part was deferred. |
| 1:09:52–1:11:04 | Not reached | The detailed DAS rules and statuses, yard operations, progress tracking (live ticket updates) and the Samsara map were deferred to the next session. |

## 2. ⚠️ Quote line items are not dispatch resources — Joe Schacatano (39:38 – 45:27)

The substantive client correction of the call. Joe, watching the associated set auto-fill the
quotation's Resources:

- **39:45:** *"we have resources mixed with our billing codes… it should just be like 100 ton, should
  be 100 ton operator load, travel permit, surcharge. **Oiler, operator, semi, those things don't get
  charged. Those are the resources utilized in dispatching.**"*
- **40:17 / 40:22:** asked what a 100-ton quote shows: *"100 ton operator load, travel permit, and a
  surcharge. That's it."* *"The oiler and the oiler operator semi. Those are the resources to tie
  to the assets when it's dispatched."*
- **42:12:** *"first things first, **we've got to separate resources from assets completely**…
  from a quoting standpoint, the quoting should populate off of what asset is being used or what
  line item is being charged."* **42:33:** a quote can carry *"100 ton, 100 ton operator load,
  travel permit, lift plan, rigger, trucking, material bin, miscellaneous"*, *"but then the resource
  is what is utilized to facilitate the need related to that line item… if you had 10 of those items
  you're quoting, **you don't want the 10 resources populating with it, with charges for it**."* He
  allowed that it *could* be a sub-category, *"we have to just keep them separate when it's quoted"*.
- **41:07:** he had raised this before and showed Brian the difference, because *"you were going off
  of the Dispatch"*. He asked Brian whether that material reached CodingCops. **Brian (41:38):** he
  sent it, *"so we have both"*.
- **Ehtesham's response:** the associated-asset configuration came from Lisette and Ryan and reflects
  what goes out on dispatch (40:31, 44:17). A *"check"* or a **resources tab on the sub-category** could
  separate field assets from quoted items (44:36), and *"I don't think it's going to be a huge
  change"*. He later said the configuration will move *"instead of on quotation to just show on
  Dispatch"* (45:27). He called it **"a critical thing that we have missed a while in the
  discovery"** (45:10), and at close named it **the one missing configuration step: "assets
  configurations for the field versus asset configuration for the quotation"** (1:16:04), asking
  for the information *"as quickly as possible"*.
- **Owed by TCG:** Ehtesham asked Brian to get from Joe *"the relationship between the billing codes and
  the resources and the field assets, these three things"* (44:43). Joe (44:58) will send copies,
  work with Ryan on specifics, and offered another screen-share walkthrough. Brian (1:11:04, 1:18:01)
  will *"get with Joe about the pricing and the resources"*.
- **Followed up the next day** on a dedicated call:
  [2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md](2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md)
  (*"the quote carries codes, dispatch carries resources"*). Read that call for how the relationship
  was explained. This note records only where the objection was first raised against working
  software.

**Why this is a gap and not a decision.** Joe is the sales owner, and his principle is plain:
dispatch-only resources carry no charge and do not populate the quote. But he did not say how the
two lists relate or where either is configured, and that model is still owed. It also cuts against
recorded material:
[../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md](../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md)
(`reference`, CodingCops design) auto-populates associated children **onto the quotation** and bars
removing *Always Included* ones, which is exactly the oiler/operator case Joe says must not be quoted.
[../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md](../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md)
materialises job resources and DAS slots from the quotation's priced lines plus its *Always Included*
children (it skips only *Optional* associations the quote never priced), so taking dispatch resources
off the quote removes the source their slots come from today. Registered in [../quotations/gaps.md](../quotations/gaps.md), with pointers from
[../assets/gaps.md](../assets/gaps.md) and [../dispatch/gaps.md](../dispatch/gaps.md).

## 3. Rates vs price lists — Joe corrects Brian (41:55 – 44:07)

- **Brian (41:55–42:10):** is pricing only on the quote line item, or also on the *"smaller items"*
  under it? Ehtesham: on the line item. **Not otherwise answered.**
- **Brian (43:22):** *"that's where the pricing lists come into play… those pricing lists are based on
  the group."* **Joe (43:28):** *"Nope, totally different… **pricing list is specific to a
  customer.** So you have your general rates that populate your standard rates… If you have a
  specific rate set for a specific customer, that price list would populate when you're quoting for
  that customer **or scheduling that customer**."* (44:00): *"an extension of it depending on who the
  customer is and what you have negotiated with them."*
- This agrees with the demoed fallback (customer list first, then master per billing code, 45:27). It
  is the sales owner's own description of the model, not a new rule. Note *"or scheduling"*: Joe
  expects the customer's price list to apply at scheduling too. Nothing shown covered that.

## 4. Redlined contracts — Ryan Adams (54:21 – 57:14)

- **Ryan (54:29):** if the customer **redlines** the DocuSign contract and the negotiation goes to
  email, can the PO be entered manually afterwards? (56:20): *"once we agree on that red line, is
  there a place where I could put the new contract or quote into this job so that **Accounting could
  see it and look at the different terms**?"*
- **Ehtesham:** attachments, update resources, internal change request, and the customer's DocuSign
  change request (56:42). He also pointed to duplicate and manual Mark as Won (55:04). **Ryan:
  "Great, thank you."** (57:14). He accepted the answer, but nothing marks a redlined agreement as the
  governing terms for accounting. Registered as an update in
  [../quotations/gaps.md](../quotations/gaps.md) → *The signing email should come from the
  salesperson, not from DocuSign*, because it is the same sending-and-signing surface.

## 5. DocuSign — Joe restates it as a preference, and Ryan backs him (57:16 – 1:00:01)

- **Joe (57:16):** is signing **without DocuSign**, from the salesperson's own email with a digital
  signature option, still being looked at? Ehtesham: send via DocuSign or send via e-mail (57:34).
  **The e-mail path has no electronic signature** (57:47: *"No, it does not."*).
- **Joe (58:07):** *"I would like to get away from DocuSign completely… I want it to be personal… **This
  is just my opinion from the salesperson.** I am not a fan of DocuSign."* (58:28): signing from the
  salesperson's email is his *"preference"*. (58:57): *"We can get rid of DocuSign. We're not paying a
  subscription on it."* **Ryan (58:52):** *"I think you nailed it."*
- **Brian (57:59):** a later option would be *"send through the portal"* once a customer portal exists.
- **Ehtesham (59:04, 59:22):** *"we are going to get rid of DocuSign. We have already discussed and
  finalized this functionality that we are going to create customer portal"*, with electronic
  signature or email reply, and **one-time credentials** for the customer. **No decision note, ticket
  or scope for this exists in the vault.** It is a dev-team statement of intent.
- **Ryan (59:39)** suggested showing CodingCops a product he uses as a model (the name did not
  transcribe, *"a line"*). **Joe (59:54):** they will schedule a separate call to show it.
- Joe self-labelled this as opinion, so it is **not** a decision. It moves the existing entry from
  *"sender identity"* toward *"retire DocuSign for an in-house portal"*. Registered as an update to
  [../quotations/gaps.md](../quotations/gaps.md) → *The signing email should come from the
  salesperson, not from DocuSign*.

## 6. Other client questions and reactions

- **Corrina (20:23):** *"Is there a spot that has their emergency contacts?"* The spot was shown.
  *"Okay, perfect."* (20:34).
- **Melissa (30:23):** *"Yes."* This confirmed Ehtesham's statement that an operator-load trailer
  needs an operator with it. (Dispatch practice, consistent with §2.)
- **Corrina (31:25):** *"Yes."* This answered the room's check that everyone was following.
- **Brian (3:47):** he had been in the FCC-login tenant: *"A lot going on in there… You guys have been
  super busy."* (1:09:40): he took notes, has **questions he will type up and send**. They are not
  in the vault yet.
- **Verdict. Brian (1:11:04):** *"I feel like you deserve a standing ovation… This is absolutely
  amazing."* **The 1:12:13 turn, labelled Brian Petros** and answering Ehtesham's *"Wes, what do you
  think?"*: *"I think it's amazing… you understand our business."* It may be Wes on Brian's
  microphone. The label is not corrected.
- **Joe (1:19:07):** asked Brian to **re-forward system access to the managers** *"so they can start
  doing it"*. **Brian (1:19:13):** testing should happen in the **FCC migration tenant**. Joe agreed.
  Ehtesham said to continue there, and that an updated tenant with newer (not yet tested) data would
  follow **this week** (1:19:23).
- **Brian (1:15:54):** *"Is there anything that we need to do to keep the momentum rolling… like
  getting the employees uploaded?"* Ehtesham named the §2 information as the main need (1:16:04).
  Employee upload was not answered.

## 7. Mobile access, SMS and sign-in identity (1:12:22 – 1:15:54)

- **The mobile app is blocked on SMS.** The app uses **AWS SNS**, still in the **sandbox**, where only a
  registered test number receives messages, and production access awaits AWS approval (abdulrehman
  1:13:19, 1:13:41). Ehtesham (1:12:22): if not approved *"within a day"*, they will build a separate
  **invite-by-email** flow so that TCG can be onboarded. **Patrick (1:14:50):** he completed his
  side. AWS reported a mishap on their end that they say is fixed, and he will check.
- abdulrehman (1:15:22) invited Brian and Patrick to **App Store Connect**. Install **TestFlight**; the
  app installs, but it will not work on real phone numbers until SNS is in production.
- **Sign-in identity. Brian (1:14:00):** *"currently now we're still signing in using like those fake
  IDs… but eventually it's going to be tied to our Apple IDs, I guess, or just our work e-mail."*
  **Patrick (1:14:15):** *"the work e-mail, the domain is tied into the Apple ID. They're both joined
  already… **You always be using your Entra or Office 365 set of credentials.**"*
- **That does not sit with the 2026-09-10 call**, where Brian noted *field employees don't have a
  Microsoft e-mail* and Ehtesham answered *"mobile phone number"* (2026-09-10 transcript 58:08–58:22),
  nor with the SMS-OTP build this call describes. Most likely Patrick meant office staff, but nobody
  said which population each method is for, and TCG's RFP asks for **Microsoft 365 SSO via Azure AD**
  ([../admin/gaps.md](../admin/gaps.md) → *Integrations — HubSpot, Microsoft 365, Dialpad, Mapsly*).
  Registered as a new entry in [../admin/gaps.md](../admin/gaps.md).

## 8. Dev-team statements of intent (no ticket, no written scope)

Recorded so they can be checked later. **None is a client decision.**

- Separate field vs quotation asset configuration: a resources tab or check on the sub-category (§2).
- Build **development and discovery timelines** by **Monday 2026-09-21**, prioritising what is built
  next (Ehtesham 1:00:01).
- Multi-day schedule rows, where the end time falls on a later date, **within two weeks** (1:00:01).
  This bears on [../dispatch/gaps.md](../dispatch/gaps.md) → *Overnight DAS shifts*.
- Customer portal replacing DocuSign, with one-time credentials (§5).
- Documentation of the quotation flow steps (draft → pending internal approval → internal approval →
  sent) for Ryan and the team (45:27).
- A **feedback channel** created for TCG's questions (1:11:37). (Brian had undertaken to open a Teams
  channel on 2026-09-01.)
- Updated, richer tenant data handed to Brian after the demos, possibly this week (1:16:04, 1:19:23).
- abdulrehman (1:18:47): *"batch cases and bugs"* still being worked. TCG asked to use the app and
  send feedback.

## 9. Next session

The follow-up session covers the detailed DAS rules and statuses, yard operations, the field app and
ticketing, and progress tracking. It is set for **Thursday 2026-09-17**, or **Friday 2026-09-18** if
Lisette can join. Brian proposed Friday (1:17:16). **Joe (1:17:43) objected** to asking Lisette
*"to come in after being gone and give up her time"* and suggested Monday or Tuesday. **Kyle
(1:18:06) will ask her.** Ehtesham (1:18:11): Friday if she can, otherwise keep Thursday and share the
recording.

## Where each item is registered

| Item | Registered in |
| --- | --- |
| §2 quote line items vs dispatch resources | [../quotations/gaps.md](../quotations/gaps.md), new entry; pointers in [../assets/gaps.md](../assets/gaps.md) and [../dispatch/gaps.md](../dispatch/gaps.md) |
| §4 redlines, §5 DocuSign / customer portal | [../quotations/gaps.md](../quotations/gaps.md) → *The signing email should come from the salesperson, not from DocuSign* (update) |
| §7 sign-in identity | [../admin/gaps.md](../admin/gaps.md), new entry |
| §1 per-yard counters not enabled pending nomenclature | not registered: a dev statement, and the counters are off |
| §3 price list applies *"when… scheduling that customer"* | noted in the §2 quotations entry |

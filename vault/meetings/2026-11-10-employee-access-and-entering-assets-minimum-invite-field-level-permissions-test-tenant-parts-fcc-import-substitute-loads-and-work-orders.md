---
title: Employee access and entering assets — the plan to use the basic system by 1 January, the minimum employee record to invite, field-level permissions, the employee ID and the ADP file number, Microsoft sign-in and the wrong tenant, parts and maintenance, importing assets from FCC, trailers and additional equipment, a substitute crane's loads and "add custom", non-union employees on jobs and work orders, a test tenant with no real customers, feedback channels, and an on-screen tenant indicator (10 November 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-11-10_Employee access and entering assets - transcript.docx"
migrated: 2026-11-12
updated: 2026-11-12
status: unverified
conflicts_with: []
jira: []
tags: [module/admin, module/payroll, module/assets, module/dispatch, module/quotations, module/customers, kind/meeting-notes, permissions, adp, crane-configuration, data-migration, requirements]
meeting_date: 2026-11-10
---

# Employee access and entering assets — invite, permissions, parts, FCC import, substitute loads, work orders — 10 November 2026

Curated from [transcripts/2026-11-10-employee-access-and-entering-assets.md](transcripts/2026-11-10-employee-access-and-entering-assets.md)
(2:48–1:24:07, complete). TCG speakers: **Brian Petros** (Data Analyst, ERP Project Coordinator), with **Jeff
Stricker** (Fleet Manager) on Brian's microphone in the conference room; **Corrina Bustos** (HR Manager), **Melissa
McNutt** (President), **Kyle Harlow** (VP of Fleet), **Joe Schacatano**, **Wes Staley** (Owner, 43:46–44:20),
**Patrick McKiernan** (TCG IT Manager, labelled "IT Support"). CodingCops: ehtesham.anwar, abdulrehman, syed.haris.
Roles are from [../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md).

> **Who said it.** Jeff Stricker speaks on Brian's label. The turns read as Jeff are listed in the transcript's
> header note (6:18 from *"Well, my only concern"*, 8:45, 24:22, 27:44, 29:08), and this file names him there.

> **Timestamps.** Long turns carry only their start (the transcript header lists them). A point made inside one is
> cited by that start time.

> **Status.** Mostly TCG asks, with CodingCops' answers and its description of the build. Nothing here was shown as
> a finished feature except the employee create and invite flow (§2, §4) and the DAS view of a quoted crane
> (§9). The file is `status: unverified`; no decision was written.

## 1. The plan — "it's go time" (3:42–5:37)

- **Brian, 4:01:** *"We have a plan to get started using the system, basic system, by the 1st of the year. So it's
  go time."* TCG wants to *"start testing for real now"*.
- **The order Brian set out (4:01–5:25):** first the employees, with *"all the fake employees out and the general
  login out"*; enough employee data to invite each person, *"so everybody has their own login"*, but not the
  sensitive data; then the roles, *"assigned properly and working properly"*; then the assets; then parts.
- **Kyle, 5:43:** should parts and service stay out until *"an operational state first of operations to billings"*,
  with maintenance *"as a separate circuit"*? *"I think that's what we talked about doing."* §5 answers it.

## 2. Creating an employee — the minimum record to invite (9:49–19:51)

- **What Brian tried (9:49–10:36):** he added an **IT** department, then created himself with a photo, employee ID,
  name, birthday, phone and e-mail, and left out the Social Security number and *"certain things"*. It saved as a
  draft, but would not move on to the next step without the missing fields. **Brian, 10:36:** *"Can we get this to
  be able to save without requiring this information so we can invite the employee?"*
- **The employee ID.** **Corrina, 10:28:** *"It might be good to have the employee ID match the ADP so that they're
  the same on both platforms. Just a thought."* Brian did not know whether the field would hold the FCC ID (9:49).
  No one answered either point.
- **abdulrehman, 16:24:** *"we need to make a couple of fields as optional. So for example, compensation type,
  salary amount"*, so that TCG can start onboarding with minimal information, adding requirements back later.
- **ehtesham.anwar, 18:52:** *"for this particular use case right now for testing … we'll make only the basic
  information required"*; everything else optional *"for now"*. *"The only thing … apart from basic information that
  we would absolutely need is the department and roles."*
- **Brian, 19:35:** *"I think the phone number and the emails should stay required."* **Corrina, 19:40:** *"Yeah,
  because that's how they have to log in."* **ehtesham.anwar, 19:42:** *"name, phone number, e-mail, and department
  and role. These are going to be things that are going to be required."*
- **ADP.** **Melissa, 15:57:** TCG can extract everyone's profile from ADP and import it. **abdulrehman, 16:05 and
  17:03:** the ADP integration is in progress *"in this sprint"*: type an **ADP file number**, review what ADP
  returns in a modal, press Apply, and the form fills. Asked whether a few people could be taken from ADP by hand
  now (17:45), he said no: it needs the API connection first (17:55, 18:19). **Corrina, 22:52:** if TCG generates
  the report, CodingCops can *"just upload it on your back end to get us started"*. Nobody answered this directly;
  §7 has the list Corrina prepares.
- **In the walkthrough (1:13:16),** abdulrehman still entered a salary (*"let's say $40 … Weekly"*) and set the role,
  and Brian (1:18:30) typed *"$10 or something"* to get past the form. That was on the build as it then stood.

## 3. Permissions inside a module — sensitive fields (11:00–15:24)

- **Brian, 11:00:** the role access levels are *"can't view, view, can edit, full access"*. *"Is there any special
  sectioning of like more sensitive information?"* **Corrina, 11:21:** *"Like hidden fields."* **Brian, 11:40:**
  *"maybe there needs to be like a payroll … and then sensitive payroll information."*
- **Brian, 11:53–12:12:** on **Owner**, *full permission* does not reach the last few modules; they show no access.
  Nobody explained it on the call.
- **Patrick, 13:04–13:19:** within quotations a role has only no access, view or edit. *"Is there a level that we
  can then specifically say what they can and cannot view? Or, edit."* **Brian, 13:27:** TCG will tell CodingCops
  which modules need separate levels.
- **Joe, 14:04:** these questions will come from the testers, and TCG will specify them then. **Corrina, 14:12:**
  ADP's own user-permission setup is a good model *"if we wanted to add that extra layer"*.
- **ehtesham.anwar, 14:32–14:51:** *"we are going to have another permission level and that's where you guys come
  in."* For example, a role may see an employee's profile but not the SSN, or not the payroll information, *"and
  there are going to be some people who will never have access to see numbers."* **Corrina, 15:05:** *"different
  tiers."* No list was given.

## 4. Invite, Microsoft sign-in and the wrong tenant (19:51–24:02, 32:34–33:58, 1:11:08–1:24:07)

- **What Brian saw (19:51–21:10):** the invite arrived after a few minutes. In his e-mail client it showed only a
  **Sign in with Microsoft** button. Signing in that way showed *"not my e-mail"*, no settings, and departments
  without the IT and Marketing he had added: *"it's not the same database."*
- **abdulrehman, 21:10:** *"right now the sign in with Microsoft, it's still in progress"*; he asked Patrick for test
  accounts. For now, sign in with e-mail and password. Brian had no password; the e-mail had no link to set one
  (22:28). abdulrehman checked the **MS Clarity** log (22:10) and sent him to *forgot password* (22:36).
- **ehtesham.anwar, 32:59 and 33:36:** don't wait for meetings. Message on Teams and CodingCops will join a call.
  The Clarity log showed Brian had reached the set-password page.
- **The walkthrough (1:11:35–1:24:07).** abdulrehman created and invited an employee on his own test tenant. He
  said the flow *"is partially working, but we need to resolve some bugs"* (1:13:16); use **Accept invitation**,
  set a password, and you land in the inviting tenant. Brian: an hour earlier his invite had no Accept button
  (1:15:16). It was there but hidden (1:19:08). abdulrehman: likely the HTML template's CSS in Outlook (1:15:27,
  1:22:37), to be fixed before TCG invites anyone. **The Microsoft path sent Brian to an old tenant** from earlier
  testing (1:19:40). With a fresh invite and a password, he was in the right tenant (1:22:00).
- **Which tenant am I in?** **Brian, 1:12:15 and 1:12:36:** is there an indicator? He asked about *"a production
  domain and a test domain and a build domain"* and something small on screen showing which one. **abdulrehman,
  1:12:53 and 1:23:27:** *"we'll do that"*, the tenant name under the TCG / The Crane Guys text. Brian's ask is the
  environment; the offer is the tenant name. §13.
- **Brian's instruction to his team until the fix (1:22:41):** use the e-mail invite link, not the Microsoft
  button, and check the e-mail address is right.

## 5. Parts, maintenance and storage (5:15–8:45, 23:35–27:53)

- **Brian, 5:25:** *"There's hundreds or thousands of parts"*, so all the fields must be there before a mass import;
  Jeff can explain how parts link to assets.
- **Jeff, 6:18:** his concern was only the **parts assigned to units** when units are uploaded, *"not every part in
  FCC"*. Adding them back by hand would be tedious.
- **Kyle, 7:07 and 8:18:** some FCC parts data *"is not current and or valid"* and was never entered the same way.
  *"I don't honestly think it has much value to us. I think we should just go forward … unless we know it's
  accurate."* What is assigned to a unit as its base filters and base parts is reliable; *"every purchased part"*
  since FCC began is not.
- **Jeff, 8:45:** *"everything assigned to the units is pretty accurate"*, entered as it is bought: filters and
  hard-to-find parts. Someone (*"Eli"*) used it the other day to find a belt for a crane.
- **ehtesham.anwar, 25:22–26:16:** CodingCops is closing **one loop**: field employees go out on jobs, then payroll,
  then invoicing, with POs for third parties. Parts and Tools & Rigging are their own CRUDs. Parts *"is needed in
  assets"*, but mostly in **maintenance**. *"We have two major modules that are still pending. One is our storage
  and the other one is maintenance. Right now we are working on safety."* After safety comes storage or maintenance.
- **Jeff, 27:44:** *"so you don't need parts to close that first loop"*; that is the work-order side.

## 6. Bringing FCC data over — what is in now, everything later (27:55–32:17)

- **Kyle, 27:55:** can the rest of the equipment be pulled from FCC, or must it be entered by hand?
- **ehtesham.anwar, 28:09–28:34:** *"all of the information that we have within the old ERP needs to come into the
  new ERP. Old information as well, because eventually … we want FCC to go away."* CodingCops will build bulk
  imports, clean the old data and import old and current data.
- **ehtesham.anwar, 29:13:** TCG does not need to clean FCC first; CodingCops cleans the data once, as it pulls it
  out, with *"a whole plan"*. **30:07:** this applies to every entity, not only assets and parts, and *"maybe January
  onwards"* CodingCops will have time for these conversions.
- **Kyle, 29:54:** he had been going to have Jeff enter more equipment by hand; a bulk transfer is better.
- **Kyle, 30:39:** apart from rigging and some specialty assets, there is enough equipment in the system now to
  dispatch and test once the people are in.
- **ehtesham.anwar, 31:42:** the structure is category → subcategory → asset. Once TCG lists the assets it needs
  and finds the categories or subcategories missing, a dedicated session converts them.

## 7. The test plan, the test tenant and customers (32:24–39:49)

- **Brian, 32:34:** he wanted *"a clear pathway to start testing"*: invite himself, then the others, and check
  with Kyle and Corrina on *"the two field employees"* who will help test.
- **Melissa, 34:00:** Corrina makes a list of employees for CodingCops to import. **Corrina, 34:17:** name, phone,
  e-mail, department, role and the ADP file number. ehtesham.anwar (34:10) asked her to help Brian list departments
  and roles too.
- **The order (Melissa, 34:34; Kyle, 34:43):** employees, then sales quotes, then Lisette converts a quote into a
  job, then dispatch. The sales admin too.
- **ehtesham.anwar, 34:43:** test through the DocuSign flow as built; once the client portal exists, test again.
- **Customers.** Brian (35:32, 37:02) asked whether to load a few hundred real customers for sales to pick from.
  **ehtesham.anwar, 35:43 and 38:13:** no real customers yet. A tester can click a button and send an e-mail without
  knowing it. Use personal or company e-mails as customers. **abdulrehman, 36:06:** dummy customers, because the
  **QuickBooks integration** is in progress and customers may have to be created there too. *"Just consider this
  tenant as a testing tenant for now"*; it may be wiped and started again.
- **Joe, 37:40 and 38:55–39:09:** don't upload customers. Salespeople will enter them by hand, as they will for new
  customers live. *"We'll do it internally in the sales team. I'll be the one that sends them out, acts like I'm the
  customer."* Kyle (39:05) offered to be a customer too.
- **ehtesham.anwar, 39:19:** a 15–30 minute call **tomorrow** (2026-11-11) with Joe and Brian to draft the test
  plan; he will prepare something.

## 8. Trailers and additional equipment for dispatch (39:52–41:08)

- **Kyle, 39:52–40:31:** *"I think all the cranes and trucks are in there. We need to get all the trailers that
  support the cranes"*, then the **additional equipment**. Those two are *"not clear yet"* to him and Jeff.
- **Kyle, 31:09:** *"all the extra equipment, I want to be an actual asset so that when it goes and get dispatched,
  they can be drug into the job and called for."* Jeff can supply the information or show where it is.
- **ehtesham.anwar, 40:37:** a dedicated call with Brian, Kyle and Jeff; TCG gives the information and CodingCops
  translates it into the structure.

## 9. A substitute crane's loads, and "add custom" on the DAS (41:09–57:44)

- **Brian, 41:09:** the subcategory configurations (what can substitute for each, and the associated field assets)
  must be checked with Kyle, Joe and Lisette.
- **Kyle, 41:59:** *"If the 275 is going out, you don't need all the counterweight. So is there a way that we
  organize how much counterweight goes to cover that job? When it's substituting."* **ehtesham.anwar, 42:22:**
  *"I don't think so. It's set up right now"*; *"not a huge change"*.
- **Kyle, 42:54–43:13:** *"the 275 doesn't go full boat to cover it … it needs to go with less trailers to cover the
  same job"*. He wants it **programmed**: *"If it's going out as a 110 ton machine, but it's the 275, it goes with
  this many trailers and this many people, and it's already in the system"*, so neither sales nor dispatch has to
  decide.
- **Wes, 43:46:** share the sales team's **crane cheat sheet** with ehtesham.anwar, with a new column for the
  machines in each configuration. **Joe, 44:22:** the sheets are built differently, but they can be rebuilt *"to
  what we're talking about"*; it takes time. **Kyle, 44:44:** **Lisette has a chart** of how machines cover each
  other, built for her by Jeff or Garrett; *"that might be easier than us starting from scratch"*. Kyle also
  expects *"gray areas"* and *"sticky spots"*.
- **What the build does (ehtesham.anwar, 45:50–52:33):** he showed a quoted 200 ton crane on the DAS: operator load,
  support load 1, support load 2 and oiler; on each load a tractor, a third man and an optional rigger. *"This 200
  ton, if you need to substitute it, these are going to be the allowed substitutions. 365, 275, 265, 350. **But the
  configuration of the job remains the same as of 200.**"* A 175 ton is not in the system (48:43).
- **Joe, 47:08–48:09:** *"I think it's already built out the way that we want it because it's a drag and drop"*; you
  assign the actual asset and the restrictions travel with it. *"If a 265 is covering 100 ton, it's built out to do
  exactly what you're saying."* Kyle (48:03): *"Oh, I see. Never mind."* Then Kyle (52:55): heavier machines may
  need **more** loads for the same job. Can equipment be added?
- **ehtesham.anwar, 53:06–53:46:** *"Right now, this configuration is static on the Dispatch end. I am planning on
  creating another section here which just says **add custom**"*: configured cranes take out the human element;
  *"if you need human element there, you have the option of adding custom equipment"*. **Kyle, 56:19:** *"adding
  that custom field is going to be important."* **Brian, 56:51:** custom for equipment and **for employees** too.
  **ehtesham.anwar, 56:35 and 57:13:** the rules are still being worked out. One example: a quote takes only load
  one of a 200 ton crane; adding a custom item should offer load two from the crane's configuration, not rebuild it.
- **Extra equipment on the quote.** **ehtesham.anwar, 53:59–56:16:** a tractor added on the quote becomes **its own
  set** on the DAS, beside the 200 ton crane's set. Kyle (53:46) asked about trucking added at the job site; the
  answer was through the quote.
- **Kyle, 51:50:** *"I know we talked about two sizes for every job"* (the sales hand-off of alternates); he thinks
  some jobs need more.

## 10. Work orders and non-union employees on jobs (57:44–1:02:40)

- **Brian, 57:44–58:15:** non-union hourly employees' labour is recorded in FCC as a **work order**, not tied to a
  job. The ERP attaches labour only to what is scheduled. Is that in the launch, or for later?
- **Kyle, 58:59:** non-union people are not scheduled to jobs; *"they just come and go as they do audits"* (safety).
  **Joe, 59:15–59:26:** *"We do for piloting. We schedule safety and yard guys to do piloting"*; *"you should have
  all employees accessible."*
- **Kyle, 59:30:** all employees should be on the DAS. Labour not connected to a job belongs to **maintenance**,
  in the yard, and storage, *"which is not part of what we're doing"*. **Kyle, 1:00:27:** *"the mechanics and the
  yard guys at times do"* go to the field. *"If they go in the field, they're getting applied to the job."*
  **1:00:51:** *"guys today were used that were not operators or oilers, but they went and did rigging jobs and they
  get a ticket."*
- **ehtesham.anwar, 1:00:45 and 1:00:53:** *"every allocation from here is going to create a ticket."*
- **Joe, 1:01:36–1:01:47:** *"They're getting a job ticket if they're going to a job … They're getting a work order
  if they're doing maintenance."* *"It could be union or non-union."* **Brian, 1:01:49:** *"I didn't know that there
  was a possibility of a non-union getting a job ticket until now."*
- **Who shows on the DAS.** **Brian, 1:02:05:** the employee form has a *dispatchable* checkbox. **ehtesham.anwar,
  1:02:31–1:02:40:** it is on the roles, and *"if it's not already in the roles on production, it will be after the
  sprint."*
- Whether **work orders** are in the launch was not answered.

## 11. Feedback, Clarity and meeting cadence (1:02:47–1:11:04)

- **Kyle, 1:02:47:** how should testers raise questions without dragging CodingCops through calls? **ehtesham.anwar,
  1:03:14:** anything clear enough to answer. He suggested **Loom**, screenshots with notes or a phone recording.
  **Brian, 1:03:57:** TCG's Teams has a **feedback and testing channel**.
- **abdulrehman, 1:04:15:** *"we have installed the MS Clarity. So whatever you guys are doing, all the sessions are
  recorded in that tool."* At public launch CodingCops will create a new account on TCG's domain and hand it to
  Patrick or Brian. Nobody from TCG commented.
- **Cadence.** Safety on **Thursday (2026-11-12)**: ehtesham.anwar shows initial designs, and Dee's feedback decides
  Tuesday's meeting (1:08:56). Minor questions go to separate calls; *"We have enough work on the product side …
  that we cannot afford to"* spend the main meetings on them (1:06:53). Brian asked for agendas two or three
  meetings ahead (1:08:27). ehtesham.anwar: each meeting decides the next, so check in a day before (1:08:56).
  **Brian, 1:10:07:** does Dennene need to prepare anything? ehtesham.anwar: no (1:10:28).
- **Kyle, 1:06:02:** make him and **Jeff Kelley** users; he will send field names.

## 12. Next

- **TCG:** Corrina's list of employees: name, phone, e-mail, department, role and ADP file number (34:17). With
  Brian, the departments and roles (34:10). Brian makes Kyle and Jeff Kelley users (1:06:02). Kyle sends the field
  testers' names (1:06:13), and Brian checks with Kyle and Corrina on the two field employees (32:34). Joe and Ryan
  plan the sales testing, with Joe acting as the customer (37:40, 39:09). Brian's test plan call with Joe and
  ehtesham.anwar, 2026-11-11 (39:19). Kyle and Jeff list the trailers and additional equipment for dispatch, on a
  dedicated call (39:52, 40:37). Brian, Kyle, Joe and Lisette check the substitutions and associated assets on each
  subcategory (41:09). Joe and Wes rebuild the crane cheat sheet, or Kyle gets Lisette's coverage chart (43:46, 44:44).
  Brian checks with Corrina which non-union employees go on jobs (1:02:05). TCG says which modules need finer
  permission levels as testing shows them (13:27, 14:04). Safety, Thursday (1:06:35).
- **CodingCops:** make everything but name, phone, e-mail, department and role optional on the employee, for now
  (18:52). Finish the ADP file-number lookup *"in this sprint"* (17:03). Fix the invite e-mail's hidden Accept
  button (1:22:37). Finish Microsoft sign-in, with test accounts from Patrick (21:10). Show the tenant name on
  screen (1:23:27). Ship the dispatchable flag on roles to production after the sprint (1:02:40). Design the DAS
  *add custom* section and its rules (53:06, 56:35). A future permission layer inside modules (14:32). Bulk imports
  and FCC data cleanup, *"maybe January onwards"* (30:07). Storage or maintenance after safety (26:16). A test plan
  draft for TCG (39:19).

## Against the vault

Checked 2026-11-12 against the vault and, where marked, the code on `staging` (`75ffd42da`).

- **The minimum record mostly exists now.** [../decisions/2026-11-11-employee-compensation-type-optional-developer-direction.md](../decisions/2026-11-11-employee-compensation-type-optional-developer-direction.md)
  (`reference`, developer direction) made Compensation Type and the craft, salary and rate fields under it
  optional the day after this call. [code] It is merged on `staging` (PR #1072). The note records no client source.
  **This call is one:** Brian asked for it (10:36), and ehtesham.anwar and abdulrehman agreed (16:24, 18:52).
  [code] `CreateEmployeeDto` requires first name, last name, e-mail and work cell phone. The department-and-role
  requirement ehtesham.anwar named was not traced in this check. Whether the profile's *finalize* still needs more
  is [../payroll/gaps.md](../payroll/gaps.md) *Employee-module rules the E2E suite asserts* (e).
- **Employee ID vs ADP file number.** [../decisions/2026-06-30-adp-erp-employee-data-ownership.md](../decisions/2026-06-30-adp-erp-employee-data-ownership.md)
  (`verified`): ADP mints the file number; the ERP stores it as a cross-reference and never generates one. Making
  the ERP's employee ID equal to it (Corrina) is a different thing. The ID would then be ADP's, and
  [../payroll/gaps.md](../payroll/gaps.md) *Employee ↔ ADP position — one person, possibly several File Numbers*
  says one person may hold more than one. Filed new.
- **Permissions.** The build grants per module and action (`view | create | edit | archive`). Nothing in the vault
  grants per field. The 2026-11-12 pointer [../admin/gaps.md](../admin/gaps.md) *Field-level edit rights on asset
  identity data* is the same kind of ask for assets (Brian, VIN and plate). Brian's *Owner lacks the last few
  modules* (12:12) was not traced.
- **Sign-in.** [../admin/gaps.md](../admin/gaps.md) *Sign-in identity — Microsoft 365 (Entra) credentials, or phone
  number and SMS code* is open. This call adds that Microsoft sign-in is being built and that it took Brian to a
  stale tenant. [../decisions/2026-09-25-password-reset-accepts-a-pending-invitation.md](../decisions/2026-09-25-password-reset-accepts-a-pending-invitation.md)
  covers Brian's forgot-password route.
- **Clarity.** [../admin/gaps.md](../admin/gaps.md) *Microsoft Clarity session recording on the web portal — who
  approved it* asks (a) who at TCG accepted it. On this call abdulrehman told Brian, Patrick, Corrina and Melissa
  that every session is recorded and that the account passes to TCG at launch. Nobody objected. That is disclosure,
  not the approval (a)–(d) ask for.
- **Go-live data.** [../admin/gaps.md](../admin/gaps.md) *Go-live — how much history comes over from FCC and
  QuickBooks* is open. ehtesham.anwar now says **all of it, history too**, because FCC goes away (28:09). Kyle says
  FCC parts history has little value (8:18). **That is an open disagreement, not an answer.** abdulrehman's *"testing
  tenant"* (36:06) is CodingCops' answer to that entry's (c): nothing entered while testing carries over.
- **Who goes on a job ticket — conflict.** [../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md](../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md)
  (`verified`, Corrina Bustos in writing) Q5: field crew, HDRs through their can-also-fill list, the Crane
  Superintendent, and (follow-up) Local 12 managers. *"NEVER yard techs."* By her "only", Safety is out too. Here
  **Joe** (59:19: *"We schedule safety and yard guys to do piloting"*; 1:01:47: *"union or non-union"*) and **Kyle**
  (1:00:27: *"the mechanics and the yard guys at times do"*; 1:00:51, rigging jobs, *"they get a ticket"*) say
  otherwise. Corrina had left the call. Not adjudicated here; flagged for `tcg-scrum` and filed as an update on
  [../dispatch/gaps.md](../dispatch/gaps.md) *Sales Persons in the DAS Employees tab — dispatchability*.
- **Work orders.** [../payroll/gaps.md](../payroll/gaps.md) *Payroll has three populations, and the ERP has scoped
  one* holds the 09-10 account: work orders are the non-job path (yard techs, mechanics), and crossover in a day is
  real. Brian's question (is it in the launch?) is that entry's, still unanswered. Kyle places it in maintenance.
- **Parts and the next loops.** [../assets/gaps.md](../assets/gaps.md) *The "storage" loop after accounting* is
  open. ehtesham.anwar now puts **safety** first, then storage or maintenance, order undecided (26:16). No vault
  entry asks which FCC parts come over.
- **A substitute's loads.** [../decisions/2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md](../decisions/2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md)
  (`reference`) and [../dispatch/gaps.md](../dispatch/gaps.md) *Requested vs dispatched resources* (the
  confirmations playbook: *"verify the crane size requested against the crane size assigned"*, then the travel
  permit and extra loads) are the nearest. The build keeps the **requested** crane's configuration on a
  substitution (52:33). Kyle wants it to follow the pair. Nothing written decides it. Filed new.
- **Test tenant, customers.** [../admin/gaps.md](../admin/gaps.md) *Field beta test and parallel run with FCC* had
  **four** field testers (one operator, one oiler, one third man, one rigger). Brian now says **two** field employees
  (32:34). Not reconciled.

## Candidates for a decision note (for `tcg-scrum`)

1. **To create and invite an employee, only name, phone, e-mail, department and role are required; the rest is
   optional for now** (§2). Brian (10:36, 19:35), Corrina (19:40), agreed by ehtesham.anwar (19:42). It gives the
   2026-11-11 developer direction a client source. *"For now"* and *"for testing"* bound it.
2. **The test tenant holds no real customers; sales tests internally, with Joe acting as the customer** (§7). Joe
   (39:09), ehtesham.anwar (38:13), Kyle (39:05).
3. **A field employee sent to a job gets a job ticket, union or non-union; a work order is for maintenance** (§10).
   Joe (1:01:36–1:01:47), Kyle (1:00:27, 1:00:51). **Conflicts with Corrina's verified Q5**, so it needs her before
   it can be written.
4. **An on-screen tenant indicator** (§4). Brian's ask, accepted by abdulrehman (1:12:53, 1:23:27). Whether it shows
   the tenant or the environment is open.

Not candidates (floated or CodingCops' plan only): field-level permissions (§3, no list yet); *add custom* on the
DAS (§9, rules unwritten); bulk import of all FCC history (§6, Kyle disagrees on parts); the employee ID matching
ADP (§2, *"just a thought"*); the order of storage and maintenance (§5).

## 13. Questions this raises — filed 2026-11-12

1. **Field-level access inside a module** (§3). New: [../admin/gaps.md](../admin/gaps.md) *Field-level access inside
   a module — SSN, pay and "numbers" hidden from roles that can open the module*.
2. **Tenant and environment indicator** (§4). New: [../admin/gaps.md](../admin/gaps.md) *Which tenant, which
   environment — an on-screen indicator*.
3. **Employee ID and the ADP file number** (§2). New: [../payroll/gaps.md](../payroll/gaps.md) *Employee ID — the
   ADP file number, or the ERP's own?*
4. **Parts at go-live** (§5). New: [../assets/gaps.md](../assets/gaps.md) *Parts from FCC — only those assigned to
   units, none until maintenance, or all of them?*
5. **Trailers and additional equipment** (§8). New: [../assets/gaps.md](../assets/gaps.md) *Trailers and additional
   equipment as dispatchable assets — who lists them, and entered by hand now or imported later?*
6. **A substitute crane's loads** (§9). New: [../dispatch/gaps.md](../dispatch/gaps.md) *A substitute crane's loads
   — the requested crane's configuration, one per substitution pair, or dispatch adds custom?*
7. **Updates, no new entry:** [../admin/gaps.md](../admin/gaps.md) *Sign-in identity*, *Microsoft Clarity session
   recording*, *Field beta test and parallel run with FCC*, *Go-live — how much history comes over*;
   [../payroll/gaps.md](../payroll/gaps.md) *Employee-module rules the E2E suite asserts* (e), *Payroll has three
   populations*; [../assets/gaps.md](../assets/gaps.md) *The "storage" loop after accounting*;
   [../dispatch/gaps.md](../dispatch/gaps.md) *Sales Persons in the DAS Employees tab — dispatchability* (the
   conflict above).

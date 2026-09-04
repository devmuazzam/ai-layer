---
title: Field Ops — open questions
status: reference
kind: gaps
updated: 2026-09-04
tags: [module/field-ops, kind/gaps, open-questions]
---

# Field Ops — open questions

Live register per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*. Ticket-raised
questions do **not** go here — they belong in that ticket's `spec.md` §12.

Entry format (unchanged from the retired registers, so the global sweep still works):

```markdown
## <question title>
- **Status:** open
- **Asked:** YYYY-MM-DD — by whom / which work raised it
- **Question:** one paragraph
- **Sources checked:** what was read before declaring this open
```

## Lunch thresholds and work-through-lunch authorization

- Question: Are the lunch thresholds in SCRUM-864 (5 / 10.5 / 16.5 / 22 hours, alert one
  hour before each) confirmed values and by whom, is it three lunches or four, and when no
  customer is available to authorize a work-through lunch does the employee record a reason
  and proceed or is WTL blocked?
- Candidates:
  - `SCRUM-864` "Lunch & Work Through Lunch Management" — **In Progress**, Epic SCRUM-582
    "Atom App", reported by Umair Khan, created 2026-08-06. The only source anywhere with
    numeric threshold values. Cites no origin for them. Assumes **four** lunches and makes
    WTL customer authorization unconditional (name + signature + photo).
  - `brs.md` (9.2 KB, 2026-06-10) — BRS-LUNCH-005 "Lunch Threshold Values" is
    marked *Needs Supporting Documentation*; OD-002 / OD-003 / OD-004 all *Need
    Documentation*. BRS-LUNCH-002 lists **three** known lunches (First, Second, Third) and
    is marked **✓ Confirmed**.
  - `field-ops/field-ops-frd/11-open-questions-future-considerations.md` (FR-TCG-FOP-002
    v2.0 DRAFT) — open question 1, "Exact lunch thresholds and union variations".
  - `field-ops/frd-new-format-draft/08-open-questions.md` (FR-TCG-FOP-001 v1.1 REVIEWED) —
    open question 4, "What are the final lunch threshold rules for first, second, third,
    and fourth lunch?", owner Corrina, status Open. Open question 1 (owners Wes + Corrina)
    additionally leaves signature ownership for Third Man/Laborer undecided.
  - `field-ops/frd-new-format-draft/05-functional-requirements/fr-fop-015-work-through-lunch-authorization.md`
    — the only source with a customer-unavailable fallback: "employee records reason and
    acknowledges the attempt". Neither SCRUM-864 nor FR-TCG-FOP-002 has it.
- Note: this is not a documentation conflict but an unsourced decision already in flight —
  numeric values reached a ticket that is being built while every specification records
  those same values as undecided. The three-versus-four disagreement means one side is
  already implemented wrong. Verified against the ticket and all four vault files on
  2026-08-11 before escalating.
- Escalated: not yet. Verified against the ticket and the vault on 2026-08-11 and ready to
  raise, but nothing has been posted to Jira or sent to the team. Whoever picks this up is
  raising it for the first time.
- Blocked: nothing hard — both FRDs require thresholds to be configurable without a code
  change, so building them as server-driven config (N lunches, configurable alert lead
  time) makes the answer a config change rather than a re-release. The values cannot be
  fixed and the WTL no-customer path cannot be finalised until this is answered.
- Owner: product team — Corrina owns the threshold question in FR-TCG-FOP-001; Wes +
  Corrina own signature ownership.
- Update 2026-08-11 — the values now appear in a second place. **This is evidence inside the
  conflict, not the answer to it.** `confluence/TCG/Atom Mobile Application ( User stories )`
  (page id 95158273) was edited 2026-08-11 and now states the thresholds explicitly: Lunch 1
  before 5 hours, Lunch 2 before 10.5, Lunch 3 before 16.5, Lunch 4 before 22, with a
  notification one hour before each — SCRUM-864's set exactly, and four lunches. Nothing that
  made this a gap has changed: the page cites no origin, so the values are still unsourced;
  `brs.md` BRS-LUNCH-002 still lists **three** lunches and is still marked
  **✓ Confirmed**; both FRDs still carry the thresholds as open questions; and the page still
  has no customer-unavailable path for WTL, stating only that it "requires customer
  authorization" with name, signature and photo. The likeliest reading is that the ticket's
  values were pasted into the page, which spreads the unsourced decision to one more location
  rather than resolving it. Recency is not authority — a page edited today does not outrank a
  BRS item marked Confirmed. The vault's migrated copy
  (`field-ops/atom-mobile-app-user-stories/03-ticket-workflow.md:138`) carries no numbers and was
  deliberately **not** re-migrated: the page was mid-edit when observed (two sections numbered
  US-11, an epic titled "PIC 10", epics 5-9 absent, US-12 missing).
- Update 2026-09-04 (Project Repository ingest): five new sources bear on this and none decides it.
  (a) **FCC's own checklist templates** — the crane `Time Stamps` checklist carries **four** lunch
  slots (items 8, 9, 11, 12: *Lunch Time*, *2nd*, *3rd*, *4th Lunch*, 54 active unit copies each)
  and the `Work Through Lunch` checklist ends in the attestation *"in the event that I worked more
  than five hours in one workday, I have taken one or more thirty minute mea[l periods]…"*
  ([fcc-checklist-templates.md](../payroll/tcg-rawfms-staging-database/data/fcc-checklist-templates.md)
  → *Time Stamps*, BLJ phase; *Work Through Lunch*); the tractor template has **one** slot and the
  paper Daily Operator Log has **two** ([field-paper-forms.md](field-paper-forms.md) §3, item 4).
  **Legacy-system facts — current FCC practice, not a TCG decision** — and none of them carries a
  threshold hour. (b) The **union agreement** states the first threshold: Truck Crane MLA, *Meal
  Periods* §1 — *"No employee shall be required to work more than five (5) hours consecutively
  without a one-half (½) hour meal period. If meal periods are worked, they shall be paid at double
  (2) time"*
  ([truck-crane-mla-2025-2028-full-text.md](../payroll/mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md)
  → *Meal Periods*). The SCCA parent agreement adds *"a one-half hour meal period for every five (5)
  hours thereafter"* once overtime runs past 6:30 PM
  ([ocr-southern-california-mla-2025-2028-full-text.md](../payroll/mcog-l12-mla-2025-2028/ocr-southern-california-mla-2025-2028-full-text.md)
  → *J. Meal Periods*) — a 5-hour cadence, not 10.5 / 16.5 / 22 and not a count of lunches, and
  whether any TCG work falls under that parent agreement is unestablished (its `INDEX.md`). The
  e-ticket's WTL checklist and the paper ticket's T&C §15 present the same 5-hour rule to the
  customer ([e-ticket-worked-example-44944.md](e-ticket-worked-example-44944.md) → *The Work
  Through Lunch Authorization*). (c) A **contradicting third set of values**: the payroll
  rule-dependency document, citing *"the latest Payroll Manager direction"*, gives meal-count
  brackets **0 → ≤5.0 · 1 → 5.5–10.5 · 2 → 11.0–16.0 · 3 → 16.5–21.5 · 4 → 22.0–27.0** (opportunities
  at 5.0 / 10.5 / **16.0** / **21.5**), says they *"should be configuration rows rather than nested
  code"*, and models **four** meals
  ([payroll-rule-dependency-matrix.md](../payroll/payroll-rule-dependency-matrix.md) §11) — agreeing
  with SCRUM-864 on 5, 10.5 and four lunches, disagreeing by half an hour at lunches 3 and 4. It is a
  CodingCops document relaying the Payroll Manager, not a client-authored one. (d) The **June 2026
  demo build** implements **three** lunches on a rolling 5-hour clock, a **mandatory third after two
  WTLs** (which its own page says no written source states), and a WTL path requiring the customer's
  name, live photo and signature with **no customer-unavailable branch**
  ([field-app-demo-2026-06.md](field-app-demo-2026-06.md) §3) — a fourth position on the count.
  (e) The only **client statement** on WTL authorization in the drop is Melissa Di Pane's review
  annotation on the FRD PDF, p. 5: *"During the pre lift tailboard we'd like the crews to have an
  option to do the WTL if the customer says ahead of time that they are approving it"*
  ([field-ops-frd/INDEX.md](field-ops-frd/INDEX.md) → *Melissa's review annotations*) — pre-approval
  at the tailboard, which adds a path and does not answer the no-customer case. Still needs the
  client: who fixed 5 / 10.5 / 16.5 / 22 against payroll's 16.0 / 21.5; three or four lunches (FCC,
  the Atom page, payroll and the rule-dependency document say four; BRS-LUNCH-002 and the demo say
  three); and whether WTL without a customer proceeds on a recorded reason or is blocked — nothing
  in the ingest says.
- **Status:** open
- **From (frozen original):** [gaps.md#lunch-thresholds-and-work-through-lunch-authorization](../gaps.md#lunch-thresholds-and-work-through-lunch-authorization)

## On-site scope-of-work form — the recording is the only source, and a Done ticket looks like coverage

- Question: is there a **mobile, operator-filled on-site scope-of-work form** — separate from the
  portal Site Plan and from the JSA — and must mid-lift scope changes be logged in it?
- Candidates:
  - Recording **2026-03-26 "TCG CC Product Sync"** — **Wes Staley at 19:31**: *"It'll be a digital
    form, site, site scope plan… not a lift plan, it's a site scope plan, **same piece of paper,
    different wording**."* At **19:56**: *"That will be part of the paperwork that we're going to
    need to have on the Adam app… **We're going to have to have a section where the guys can put all
    that information.**"* At **20:27**: *"the on-site scope of work happens on site. So we give the
    **operators and oilers** measurements, and then they go out on site and they do what is actually
    there… So they have a JSA."* At **20:47**: *"they currently **write them out on paper and put
    them up on their windows** so if somebody comes to audit, that they have that information."* At
    **21:54**: *"in the middle of the lift, the customer is like, hey, can you go pick this over
    here?… **yes, any changes would need to be logged.** They don't necessarily have to be approved."*
    At **22:58**: *"On-site scope of work allows us to be very fluid and change things as we need to."*
  - Same ask, three weeks earlier — recording **2026-03-06**, **Melissa McNutt at 40:35**: *"There is
    a **site scope of work** that we do that the guys fill out a **paper form on site**. So maybe when
    we get to the job level we can add that."* Melissa also promised sample forms in the chat
    (line 575); **no such artefact is in the vault.**
  - `projects-jobs/project-module/04-create-and-approve-lift-plans.md:47-62` — *"User Story 4: Create a
    Site Plan"*: *"As a **Project Engineer**, I want to create a Site Plan…"*, created from the
    **portal** Plans tab, *"submits the plan for approval"*, *"Plan goes to Pending Approval"*.
    **Different actor, different surface, different timing, and an approval gate Wes explicitly said
    the field form does not need.** (Note the numbering hazard: this "User Story 4" lives in the part
    file numbered `04-`, which is itself "User Story 3" — see `projects-jobs/project-module/INDEX.md`.)
  - `field-ops/field-ops-frd/08-functional-requirements/fr-fop-011-job-safety-analysis-jsa.md`
    (**FR-TCG-FOP-002 v2.0 DRAFT**) — JSA only. No measurements, no radius, no scope-change logging.
  - **The decisive negative:** a search for *site plan / lift plan / site scope / measurement /
    radius* across **all three** field-ops document sets — `field-ops/field-ops-frd/`,
    `field-ops/frd-new-format-draft/`, `field-ops/atom-mobile-app-user-stories/` — returns **zero hits**.
    A vault-wide search for the phrase returns only this gaps entry and a `purchase-order.md` field
    of the same name.
  - `SCRUM-236` *Create a Site Plan* — **Done**; its description is a verbatim copy of the portal
    user story above. `SCRUM-862` *JSA / Tailboard* — **QA**; a verbatim copy of atom `US-10`. A sweep
    of the entire mobile epic finds **no mobile site-plan or scope-of-work ticket**.
- Note: **this is the most dangerous shape of gap in the set — a name collision where a Done ticket
  looks like coverage.** Anyone grepping "Site Plan" finds `SCRUM-236` and a shipped portal feature
  and concludes the requirement is met. It is a different feature. The mobile form Wes described —
  operator-entered actual measurements, no approval gate, mid-lift change logging, auditable from the
  cab — exists in **no** written source. `field-ops/frd-new-format-draft/08-open-questions.md:19`
  carries the adjacent unanswered question (*"What exact JSA form should be digitized?"*, owner
  Client, Open), which is the JSA, not this. Two named TCG people asked for it three weeks apart and
  nothing was ever written down.
- Blocked: everything about it — there is no requirement to build from. The first move is not a spec
  but Melissa's promised paper forms.
- Owner: Wes Staley (specified it in detail on 2026-03-26) and Melissa McNutt (raised it first, and
  owes the sample forms); Kyle Harlow for the field/ticket consequence.
- Update 2026-09-04 (Project Repository ingest): **the sample form Melissa promised is now in the
  vault.** `1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/TCG_On-site scope of work
  form.pdf` and its photographed paper twin (`3.6.1_MODULE-SAFETY-COMPLIANCE/Safety FORMS/TCG On-Site
  Scope of Work (paper version).jpg`, identical field for field) are migrated as
  [safety-compliance/02-jsa-and-lift-planning-forms.md](safety-compliance/02-jsa-and-lift-planning-forms.md)
  §4. It is a one-page **lift capacity calculation**: crane description, jib used/stowed, outrigger
  position, counterweight, a deduction list → Gross − Deductions = Net Capacity, load weight, line
  pull, parts of line, the ≥ 75 %-of-net-capacity and two-machine critical-lift triggers, the
  personnel-platform trigger, and a crane diagram with boom length / tip height / angle / load
  radius — signed by **Operator and Foreman**, under the rule *"MUST be completed before any crane
  operations begin and each time crane configuration changes"* and *"Show on-site supervisor this
  form and related chart(s)… Both sign form and keep with supervisor."* That is the artefact behind
  Wes's *"same piece of paper, different wording"*: the crew's on-site lift plan, filled from what
  is actually there. The 2026-06-09 JSA form's Crane Guys Standard names **"JSA, lift scope"** as
  paperwork that must be signed *"before starting the lift"* (same page → *The Crane Guys Standard
  is a hard gate*), and the field crane audit records **as-executed** pick values distinct from
  the planned ones on this form
  ([03-field-audit-and-safety-value.md](safety-compliance/03-field-audit-and-safety-value.md) →
  *At the time of Pick*). **Blank paper forms — evidence of current practice, not a decision.**
  Neither FRD mentions the form; the migration page records the same question as its open point 4,
  unrouted. Still needs the client: whether this form is in scope for the mobile app, and whether
  the mid-lift scope-change logging Wes described is a requirement — the form's own
  re-do-on-configuration-change rule is the nearest thing to it and is a paper frequency rule, not a
  change log.
- **Status:** open
- **From (frozen original):** [gaps.md#on-site-scope-of-work-form-the-recording-is-the-only-source-and-a-done-ticket-looks-like-coverage](../gaps.md#on-site-scope-of-work-form-the-recording-is-the-only-source-and-a-done-ticket-looks-like-coverage)

## Who fills the ticket — the schema has already picked a side against the only REVIEWED document

- Question: when a crane goes out with an oiler and an operator in one truck, is there **one shared
  ticket** covering both (the oiler's, carrying crane + tractor + trailer and both names), or **one
  ticket per employee**?
- Candidates:
  - Recording **2026-05-14 "Loading/Scheduling Pre-Ticketing"**. The speaker is labelled **"Brian
    Petros"** but does dispatch work in the first person (*"I can just do one ticket"*, *"they will
    call me and be like, hey, can you add this"*) — **inferred to be Lisette Anzaldo**. At **9:07**:
    *"when it's just **crane plus one truck only, it's the oiler. He does all the paperwork for the
    operator. So he includes both of their timing**… we do have other cranes that have the operator,
    the oiler, and then four other trucks, **each other driver will do their own ticket**."* At
    **14:58**: *"The oiler does everything. So **in his ticket, it should include the crane, his
    tractor, and the trailer**, and then three pieces of equipment, and then **his name and the
    operator's name**."*
  - **A trap in the same passage.** At **9:41** the same speaker says *"It will be 1 ticket. per
    employee. on the same job."* — and **corrects it fifteen seconds later at 9:56**, asked directly
    about an oiler and operator going out together: *"**One. Wine with both of them in it.**"*
    ("One, with both of them in it".) At 10:12: *"I can just do one ticket with both of them on that
    ticket and then one of them can complete it."* **Anyone quoting 9:41 alone gets the opposite
    answer.**
  - `field-ops/frd-new-format-draft/04-role-responsibility-model.md:17` (**FR-TCG-FOP-001 v1.1
    REVIEWED** — the only reviewed field-ops document) — *"The Oiler owns the main ticket. The
    Operator's labor is captured within the shared ticket but the Operator does not process paperwork
    or collect signatures."* And
    `field-ops/frd-new-format-draft/05-functional-requirements/fr-fop-009-pre-trip-checklist.md`
    (**FR-TCG-FOP-001**, *not* `fr-fop-009` in the other FRD, which is *Leave Yard* — `INDEX.md`
    caveat 3) — *"Oiler completes checklist items for Operator/Oiler setup including crane, tractor,
    trailer, and support loads."* **Both match the recording.**
  - `field-ops/field-ops-frd/05-role-definitions.md` (**FR-TCG-FOP-002 v2.0 DRAFT**) hedges: *"Executing
    assigned tickets"* is listed for **both** roles, and the oiler *"completes the **primary** ticket
    completion workflow"* — "primary" implies a non-primary ticket exists, i.e. the operator has one.
    `field-ops/atom-mobile-app-user-stories/` is **silent** on the question.
  - `field-ops/frd-new-format-draft/08-open-questions.md:27` — open question 11, *"Should Operator have
    any active approval or confirmation step in the shared Operator/Oiler ticket flow?"*, owner
    **Wes + Client**, status **Open**. The model itself is admitted to be unsettled.
  - `SCRUM-249` *DAS Per day job ticket creation and assignment* — **Done**, created **2026-05-01**
    (thirteen days *before* the meeting), Done **2026-06-30** (after it). AC 2: tickets are created
    *"**against all employees that had allocations**"*. **No requester named.**
- Note: **the build has already decided this and cannot represent the alternative.**
  `model JobTicket` in `apps/api/prisma/schema.prisma` carries `allocationId` plus `employeeId?` /
  `vendorEmployeeId?` with a schema comment stating *"Exactly one of the two personnel FKs is set"*
  and a partial unique index enforcing at most one non-cancelled ticket **per allocation**;
  `job-tickets.service.ts` creates one *"for every allocated personnel slot"*. **There is no column
  that could hold a second name**, so the shared oiler+operator ticket is not merely unbuilt — it is
  unrepresentable without a migration. That makes this the highest-cost pair in the set: the only
  REVIEWED field-ops document says one thing, the schema says the other, `SCRUM-249` is Done, and
  nothing adjudicates. Answering it also answers open question 11.
- Blocked: `SCRUM-249` (Done) and the `JobTicket` schema; every labor-capture and payroll handoff
  that assumes one person per ticket; open question 11 in FR-TCG-FOP-001.
- Owner: Kyle Harlow (field/tickets) with Wes Staley, who owns open question 11; Lisette Anzaldo
  described the dispatch practice.
- Update 2026-09-04 (Project Repository ingest): **FCC's own ticket model holds two people on one
  ticket.** (a) The vendor's cardinality rule: a Job Ticket is *"unit-based — one unit only, and
  therefore at most two employees"*, generation requires the unit's **`Primary Employee`** checkbox,
  and on a LEM ticket one declared Primary Employee *"will represent the collective group and collect
  signatures from the customer"* while the others *"receive a secondary copy"* and may enter their
  own labor or have the Primary enter it
  ([fcc-nexgen-dispatch-guide.md](../dispatch/fcc-nexgen-dispatch-guide.md) §5). (b) The table:
  `stg.FMS_JOB_TICKET_Raw` carries `EmpID` / `JobEmpID` **and** `OilerEmpID` / `OilerJobEmpID` on
  the same row as the single `UnitCode`, `SignatureIn` / `SignatureOut` and `WorkThruLunch`
  ([ddl/stg.FMS_JOB_TICKET_Raw.sql](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_JOB_TICKET_Raw.sql):30,40,100–101),
  and the 129,742-row `stg.FMS_JOB_TICKET_EMP_UNIT_Raw` joins one ticket to many (employee, unit)
  pairs with a `PrimaryEmp` bit and separate `JobOperComments` / `JobOilerComments`
  ([ddl/stg.FMS_JOB_TICKET_EMP_UNIT_Raw.sql](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_JOB_TICKET_EMP_UNIT_Raw.sql):8–12,39–40).
  (c) A real ticket in use: 44944 is **one ticket** with the Oiler on the crane block, the Operator
  on the operator-load and tractor blocks, both labor entries (`161-180Ft-Oiler`,
  `161-180Ft-Operator`) on the same Labor & Unit Details report and a `Team Labor Details` total
  across both ([e-ticket-worked-example-44944.md](e-ticket-worked-example-44944.md) → *Team
  Information is per unit*, *The labor entry*); the vendor guide adds that when several units on a
  ticket carry checklists *"the primary employee receives them all"*
  ([fcc-e-ticket-and-atom-guides.md](fcc-e-ticket-and-atom-guides.md) → *Job vs unit vs ad-hoc*),
  and the dispatch grid's unit row carries `Operator` and `Oiler` dropdowns directly
  ([fcc-nexgen-dispatch-guide.md](../dispatch/fcc-nexgen-dispatch-guide.md) → *The Schedule Jobs
  window*). (d) Melissa Di Pane's FRD annotation groups *"1. Operator and Oiler"* as one class of
  field employee and every support-load driver as "Third Man"
  ([field-ops-frd/INDEX.md](field-ops-frd/INDEX.md) → *Melissa's review annotations*, p. 4) — a
  role taxonomy, not a statement about tickets. **All of (a)–(c) is legacy-system practice: it
  matches the 2026-05-14 recording and FR-TCG-FOP-001 (primary = oiler, operator inside the shared
  ticket) and is not a TCG decision for the ERP.** `model JobTicket` is unchanged as of 2026-09-04
  (`allocationId` plus one of `employeeId` / `vendorEmployeeId`). Still needs the client: keep FCC's
  primary-plus-oiler ticket, or `SCRUM-249`'s one-per-allocation; open question 11 remains.
- **Status:** open
- **From (frozen original):** [gaps.md#who-fills-the-ticket-the-schema-has-already-picked-a-side-against-the-only-reviewed-document](../gaps.md#who-fills-the-ticket-the-schema-has-already-picked-a-side-against-the-only-reviewed-document)

## SOS — Dispatch was asked for and agreed on the call, and is in neither the docs nor the code

- Question: should the mobile SOS screen include a **Dispatch** option, and is **"broadcast SOS to
  office"** a real requirement or something built without one?
- Candidates:
  - Recording **2026-06-18 "Dispatch Permits"** at 1:18:33, `ehtesham.anwar` listing what was built —
    911, safety officer, crane superintendent, nearest hospital, *"or just a general broadcast SOS to
    office. And Melissa, this and Wes, this is something you guys wanted on this, alright?"* →
    **Melissa McNutt: *"Yeah, that looks good."*** → **Brian Petros at 1:18:58: *"They need, they
    should have **Dispatch** on there"*** → Melissa: *"Yes, let's see."* → **`ehtesham.anwar`: *"No,
    we'll we'll also add Dispatch then."*** The "Brian Petros" label here addresses Lisette by name
    and is consistent with the **real** Brian Petros. **Asked by a named TCG person, assented to by a
    second, accepted by CodingCops on the call.**
  - `field-ops/atom-mobile-app-user-stories/06-safety-and-self-service.md:34-50` — US-21 lists 911,
    Safety contact, Crane Superintendent contact, nearest-hospital display, call and navigate.
    **No Dispatch, no broadcast.** The file was **re-migrated 2026-08-13 (Confluence v10), nearly two
    months after the meeting** — the omission survived a refresh.
  - `field-ops/frd-new-format-draft/05-functional-requirements/fr-fop-037-emergency-contacts.md`
    (**FR-TCG-FOP-001**) — *"Provide emergency contact list including **Dispatch, Maintenance, Yard,
    and Office**"*. **The exact inverse of US-21**: it has Dispatch and Office and omits 911, Safety
    Officer, Crane Superintendent and hospital.
  - **FR-TCG-FOP-002 v2.0 DRAFT has no SOS or emergency-assistance requirement at all** — a search
    across `field-ops/field-ops-frd/` returns nothing; its `fr-fop-026-escalation-handling.md` is
    deficiency escalation, a different thing.
  - `field-ops/frd-new-format-draft/08-open-questions.md:24` — open question 8, *"What emergency
    contacts should be available in the phonebook?"*, owner **Wes**, status **Open**. This pair is
    literally that question.
  - `SCRUM-880` *SOS / Emergency Assistance* — **In Review**, AC a **verbatim copy of US-21**;
    Dispatch and broadcast absent from the ticket too. Its only trace of the subject is a QA comment
    (2026-08-17): *"We will not implement Nearest Hospital action for now. And **Broadcast SOS to
    Office option is also non functional**. Please confirm how it will work"* — which also walks back
    the hospital action that *is* in the AC. **No "add Dispatch to SOS" ticket exists.**
- Note: `apps/mobile/lib/contacts.ts` defines exactly four SOS rows — 911, Safety Officer, Crane
  Superintendent, nearest hospital. **No Dispatch row** (a `DISPATCH_CONTACT` exists but is wired to
  the login screen's "Contact dispatcher"). Meanwhile `sos-overlay.tsx` **does** render a *"Broadcast
  SOS to office"* button firing a stub toast. So the two items moved in opposite directions: the
  thing a named TCG person asked for and got agreement on is in **neither** the docs nor the code,
  and the thing **no** TCG turn ever requested was built. `apps/mobile/ARCHITECTURE.md` additionally
  notes SOS contacts are *"permanently hardcoded to fixture data"*. This is a three-way document
  conflict, so it also belongs under §*Field operations mobile app*; recording it there as evidence
  is more useful than treating it as a fourth source.
- Blocked: `SCRUM-880` (In Review) will ship without Dispatch; open question 8 in FR-TCG-FOP-001;
  the hardcoded contact fixtures.
- Owner: Brian Petros (asked for Dispatch) and Wes Staley (owner of open question 8); Melissa McNutt
  assented on the call.
- Update 2026-09-04 (Project Repository ingest): the **June 2026 demo build** —
  `CC_FRD-Field-Ops-Mobile-App_DEMOs/TCG Field App DEMO 2026-06-16.html`, two days before the
  2026-06-18 call — has SOS as a persistent floating button whose confirmation sends *"your GPS
  location, name, and job number to **Dispatch, the Safety Officer, and 911 simultaneously**"*
  ([field-app-demo-2026-06.md](field-app-demo-2026-06.md) §8), and that page records that neither
  FRD mentions an SOS or 911 path (its open point 7). So **Dispatch was already a recipient in the
  prototype CodingCops showed before the call**; its absence from US-21, `SCRUM-880` and
  `contacts.ts` is a departure from the demo, not an idea that was never built. The demo has no
  hospital action, no per-contact list and no "broadcast to office" either. The only client words in
  the drop that touch emergency contacts are Melissa Di Pane's FRD annotation asking the
  JSA/tailboard to pre-fill *"nearest hospital with address link"*
  ([field-ops-frd/INDEX.md](field-ops-frd/INDEX.md) → *Melissa's review annotations*, p. 15) — the
  hospital, not Dispatch; the *"Emergency contacts"* in review-log #12
  ([erp-review-log.md](../erp-review-log.md)) are the employee's own next-of-kin, a different thing.
  **A prototype is CodingCops' build, not a TCG decision.** Still needs the client: Dispatch on the
  SOS screen, and whether "broadcast to office" is a requirement; open question 8 remains.
- **Status:** open — needs confirmation
- **From (frozen original):** [gaps.md#sos-dispatch-was-asked-for-and-agreed-on-the-call-and-is-in-neither-the-docs-nor-the-code](../gaps.md#sos-dispatch-was-asked-for-and-agreed-on-the-call-and-is-in-neither-the-docs-nor-the-code)

## Signer photo — CodingCops committed on the call and no ticket exists

- Question: is the **photo of the customer signer optional** (consent-based, so a customer who
  refuses can still sign), or required as the app enforces today?
- Candidates:
  - Recording **2026-08-12 "ERP Sprint Review"**. **Melissa McNutt at 28:45**: *"But just get
    consent, but if they say no, they're gonna have to go say no."* At **29:08**: *"It does look
    required. It does look required."* At **29:26**: *"**Could the person signing, could they deny
    getting a picture taken of them? Or is it required?**"* → `abdulrehman`: *"I think it's required,
    I guess."* → **`ehtesham.anwar` at 29:54: *"Right now, then, as a required item, but **not a huge
    change. We can just change it to optional.**"*** → `abdulrehman`: *"Yeah, we can, we can do
    that."* Melissa at 30:11: *"what do you do if a customer says you're not taking a picture of
    me?… **If they're not gonna accept it, we're not gonna start a fight over it.** We try to
    encourage it."*
  - **Attribution caveat, and it matters here.** The `Melissa McNutt` label in this file is a room mic
    covering several people — at 34:26 the same label says *"mine has W in it"* while discussing
    signature legibility, which is **Wes Staley**. Treat "Melissa McNutt" as the best available
    attribution, not a certainty.
  - `field-ops/frd-new-format-draft/05-functional-requirements/fr-fop-018-signature-quality-fraud-prevention.md`
    (**FR-TCG-FOP-001 v1.1**) — *"Photo capture is now a **configurable deployment toggle**… Photo
    capture can be enabled or disabled per deployment configuration."*
  - `field-ops/field-ops-frd/08-functional-requirements/fr-fop-018-customer-signatures.md`
    (**FR-TCG-FOP-002 v2.0** — same id, different requirement; `INDEX.md` caveat 3) — *"shall support
    **configurable** photo capture during signature workflows"*. **Both FRDs say configurable.**
  - **CONTRADICTING** — `field-ops/atom-mobile-app-user-stories/02-ticket-assignment-and-pre-trip.md:136`:
    *"Applicable customer photo is captured as part of the authorization flow; **if the required
    photo is removed, it must be retaken**."* And `04-completion-and-return.md:32` states the same
    unconditionally for the final signature. **This page was re-migrated 2026-08-13 — the day after
    the meeting — and still says "required photo".**
  - `SCRUM-861` *Arrive Job & Customer First Authorization* — **QA**, last updated **2026-08-12**, the
    day of the meeting. Its AC is a near-verbatim copy of atom US-09 that **stops one bullet short and
    omits the photo entirely**, in either direction. **Zero comments.** A sweep of every ticket
    created since 2026-08-01 finds **no ticket for the change CodingCops agreed to**.
- Note: state (d), and unusually it is a **delivery-commitment** gap as much as a requirements one —
  CodingCops said on the call it would be changed and nothing was raised. The app still enforces it:
  `apps/mobile/features/field-ticket/steps/Sig1Body.tsx` gates the Continue button on
  `!!identityPhotoAttachmentId`. The wire schema already tolerates absence
  (`identityPhotoAttachmentId: z.string().optional()`, with a test asserting it is *"additive, not
  required"*), so Ehtesham's *"not a huge change"* is accurate — the gap is a UI gate and a decision,
  not engineering. TCG's own position was explicitly soft (*"we're not gonna start a fight over
  it"*), which is precisely the kind of ask that evaporates without a ticket. The doc-vs-doc half —
  two FRDs saying configurable against an atom page saying required — belongs under §*Field
  operations mobile app*.
- Blocked: `SCRUM-861` (QA) will ship with the photo required; the atom page line 136; any
  per-deployment configuration story implied by both FRDs.
- Owner: Melissa McNutt (raised the consent question — best available attribution, see caveat), with
  Kyle Harlow for the field consequence. CodingCops owes the ticket regardless of the answer.
- Update 2026-09-04 (Project Repository ingest): two facts, no decision. (a) The **June 2026 demo
  build** captures *"an identity photo of the signer through a live camera"* at **both** customer
  signature steps and again inside every WTL authorization (customer name + live photo +
  signature), with no consent or refusal branch — its only escape is *"Customer not available for
  final signature"*, which replaces the whole signature with a mandatory reason
  ([field-app-demo-2026-06.md](field-app-demo-2026-06.md) §3, §7); that page notes this is what
  `FR-FOP-018` was built as, so the required photo predates the 2026-08-12 call by two months and
  is the prototype's choice, not a client instruction. (b) **FCC captures no signer photo at all**:
  `stg.FMS_JOB_TICKET_Raw` stores `SignatureIn` / `SignatureOut` as images with
  `SignatureInName` / `SignatureOutName` and times, and no photo or picture column exists in any of
  the 44 staging DDLs
  ([ddl/stg.FMS_JOB_TICKET_Raw.sql](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_JOB_TICKET_Raw.sql):26–27,31–32;
  `grep -i 'photo\|image\|picture' ddl/*.sql`, 2026-09-04) — current practice is signature-only,
  a legacy-system fact, not a decision. Melissa Di Pane's eight FRD annotations say nothing about
  the photo ([field-ops-frd/INDEX.md](field-ops-frd/INDEX.md)). Still needs the client: optional /
  consent-based or required — and the ticket CodingCops owes either way.
- **Status:** open — needs confirmation
- **From (frozen original):** [gaps.md#signer-photo-codingcops-committed-on-the-call-and-no-ticket-exists](../gaps.md#signer-photo-codingcops-committed-on-the-call-and-no-ticket-exists)


## Post-trip inspection — Melissa says it does not happen, two signed documents say it does

- **Status:** open
- **Asked:** 2026-09-01 — processing the e-ticket and quote Melissa McNutt supplied 2026-08-31.
- **Question:** does a post-trip inspection exist? Melissa's covering message says plainly
  *"here is a sample of the pre-trip, **we currently don't do post trips**. I'll check with Kyle
  and see if we can use the same template."* But the ticket the crew signed that day, and the
  contract the customer signed, both assert one. If the ERP builds pre-trip only, it ships a
  workflow whose own attestation text is false; if it builds post-trip, it ships a step nobody
  performs. And billing depends on it: charges *"begin and end with Pre & Post trip inspections"*.
- **Sources checked:**
  [e-ticket-worked-example.md](e-ticket-worked-example.md) §5 item 13 — the employee attestation
  on ticket 45954, signed by Jonathen A at 14:27 on 2026-06-10: *"By signing this check list I am
  also signing that I performed and completed my Pre Trip Inspection, Rigging Inspection and
  **Post Trip Inspection**."* Also
  [quotations/quote-terms-and-rate-card.md](../quotations/quote-terms-and-rate-card.md) §7, from
  quote OM-35140 p.2: *"All charges begin and end with **Pre & Post trip inspections** at
  equipment(s) dispatched location(s)."* Against those:
  [fr-fop-009-pre-trip-checklist.md](frd-new-format-draft/05-functional-requirements/fr-fop-009-pre-trip-checklist.md)
  and [fr-fop-007](frd-new-format-draft/05-functional-requirements/fr-fop-007-guided-ticket-workflow.md)
  specify **pre-trip only**; `grep -ri "post.?trip"` across `field-ops/` returns no functional
  requirement for one. So the FRD matches Melissa's practice and contradicts both signed documents.
- **Note:** Melissa named the owner herself — *"I'll check with Kyle"* — so this has a live path to
  an answer. A third possibility neither document rules out: the post-trip is performed but recorded
  as the *arrival-at-yard* leg of the same checklist rather than a separate one, which would make
  the attestation true and the FRD incomplete rather than wrong.
- **Update 2026-09-04 (Project Repository ingest):** the record now shows the practice **changed
  during 2026**, and the client's statements disagree by date — so this stays open, and it needs
  Kyle's answer, not a reading. (a) **FCC ran a Post-Trip Inspection checklist and crews answered it
  through 2025, then stopped.** `FMS_UNIT_CHECK_LIST` row 2 *Post-Trip Inspection* is `Status = 1`,
  and the checklist sits on 48 unit-level copies as a 28-item *After Arrived Yard* list (Load Line /
  Hook … Fuel Cap Secured, Additional Comments) —
  [fcc-checklist-templates.md](../payroll/tcg-rawfms-staging-database/data/fcc-checklist-templates.md)
  → *The checklist kinds* and *Post-Trip Inspection — 56 distinct questions*. Computed 2026-09-04
  from `stg.FMS_JOB_UNIT_CHECK_LIST_Raw` in the restored 2026-06-23 backup (year = row
  `CreatedDate`, "answered" = Checked or N/A set): 2024 — 435 tickets carried it, 154 with at least
  one answer; 2025 — 663 tickets, 341 answered; **2026 to 06-23 — zero rows**, while *Crane Pre-Trip
  Inspection* ran on 3,740 tickets over the same months. So by the backup date the post-trip was no
  longer being issued on tickets at all, which is what Melissa's 2026-08-31 *"we currently don't do
  post trips"* describes. That is a legacy-system fact about current practice, **not a TCG
  decision** — the record does not say who stopped it or why. (b) **Three months earlier the client
  said the opposite, on the record.** Wes Staley,
  [2026-05-21](../meetings/transcripts/2026-05-21-crane-configurations-job-tickets.md) 1:10:17 —
  *"When they get back to the yard, they do a post-trip inspection"*, and 1:11:09 — *"The post-trip
  isn't filled out the best. It's at the end of the day, they just want to get home."* Melissa
  McNutt, [2026-05-19](../meetings/transcripts/2026-05-19-crane-configurations-job-tickets.md)
  42:09 — *"They do the pre and post trip for their crane, their assigned truck, and their assigned
  trailer"* (already carried as rule 4.3 in
  [dispatch/crane-configuration-rules.md](../dispatch/crane-configuration-rules.md)), and 43:37 —
  *"after their post-trip, then they can end their time"*. On
  [2026-06-04](../meetings/transcripts/2026-06-04-mobile-app-job-lem-tickets.md) 48:26, of the
  attestation item: *"This should always be a completed."* On
  [2026-06-16](../meetings/transcripts/2026-06-16-field-ops-mobile-app-demo.md) 32:35 she proposed
  dropping the attestation item *because* the app would require the inspections — *"if it's already
  in the app as required, we could take that out."* And when the ERP's post-trip step was demoed on
  [2026-08-12](../meetings/transcripts/2026-08-12-erp-sprint-review.md) 35:43 her only comment was
  *"Maybe that post should be smaller"* — not that it should go. (c) **This entry's "no functional
  requirement" claim was wrong**: the Confluence FRD FOP-002, migrated 2026-08-10 and confirmed
  against its PDF in this drop, has
  [FR-FOP-021 Post-Trip Checklist](field-ops-frd/08-functional-requirements/fr-fop-021-post-trip-checklist.md)
  (*"Organizations shall determine whether Post-Trip inspections are mandatory"*), FR-FOP-020 AC-002
  makes it available after Arrive Yard, the ATOM stories carry
  [US-16](atom-mobile-app-user-stories/04-completion-and-return.md) (open on whether it is
  mandatory), and the June demo has it as step 12 with its own photo slots
  ([field-app-demo-2026-06.md](field-app-demo-2026-06.md) §4). Only `frd-new-format-draft/`
  (FOP-001) lacks one. Melissa's eight review annotations on the FOP-002 PDF
  ([field-ops-frd/INDEX.md](field-ops-frd/INDEX.md) → *Melissa's review annotations*) do not mention
  post-trip either way. **Still needs the client** (Melissa → Kyle, as she offered): whether the
  2026 stop is policy or lapse; whether the ERP ships FR-FOP-021 as optional-by-configuration or
  not at all; and whether the attestation text and the quote's *"Pre & Post trip inspections"*
  billing language are to be corrected or kept. Nothing from Kyle is in the record.
- **Owner:** Melissa McNutt → Kyle.
- **Update 2026-09-04, from the record (computed the same day from `stg.FMS_JOB_UNIT_CHECK_LIST_Raw` and `stg.FMS_CHECK_LIST_Raw` in the restored 2026-06-23 backup):** the post-trip did not stop by a decision anyone wrote down; it was **switched off unit by unit**. The last ticket carrying a *Post-Trip Inspection* checklist is dated **2025-10-06**; monthly issuance ran 2,100–2,700 rows a month through June 2025, then 980 / 1,092 / 1,372 in July–September and 280 in October 2025, then nothing. Of the 48 per-unit copies, 40 are `Status = 0`, deactivated in batches — 20 on 2023-03-09, 4 on 2025-01-16, 3 on 2025-02-11, 6 on 2025-06-19, 1 on 2025-10-07, 3 on 2025-11-20 — and the 8 still active (last edited 2020–2022) sit on units that issued no post-trip after October 2025. So Melissa's 2026-08-31 statement is accurate for the last eleven months and the May–June 2026 recordings describe the practice up to autumn 2025; both are true in their moment. Whether that lapse is the intended end state is still Kyle's to say.

## Lunch slots differ between the crane ticket and the tractor ticket

- **Status:** open
- **Asked:** 2026-09-01 — processing the e-ticket Melissa McNutt supplied 2026-08-31.
- **Question:** on ticket 45954 the crane's Time Stamps checklist offers **four** lunch slots
  (Lunch Time, 2nd, 3rd, 4th) and the tractor's offers **one**. Is the number of lunch slots a
  property of the unit type — a tractor driver cannot plausibly reach a fourth lunch, a crane crew
  on a 22-hour day can — or have two checklist templates simply drifted apart? This decides whether
  the ERP renders lunch capture from a per-template configuration or from one shared rule applied to
  every unit on the ticket.
- **Sources checked:** [e-ticket-worked-example.md](e-ticket-worked-example.md) §5 — crane `10003`
  items 9–12 are Lunch / 2nd / 3rd / 4th; tractor `AT15` item 9 is Lunch alone, and its list
  continues straight to the two attestations at 10 and 11, so items 10–12 are **absent**, not blank.
  `payroll/wtl-charts.md` and `SCRUM-864` both define **four** thresholds without qualifying them by
  unit. `brs.md` BRS-LUNCH-002 lists **three** and is marked ✓ Confirmed. None of the three mentions
  unit type at all.
- **Note:** related to but separate from the *Lunch thresholds* entry in
  [payroll/gaps.md](../payroll/gaps.md) — that one is about **when** each lunch is due, this one is
  about **how many slots exist and for which unit**. The e-ticket does not carry threshold hours, so
  it does not touch the first question.
- **Update 2026-09-04 (Project Repository ingest):** the FCC record answers the *mechanism* and a
  second ticket rules out one-off drift, but nothing states which count is intended — still open.
  (a) **In FCC the slot count is a property of the per-unit checklist copy, not of a unit type.**
  `FMS_CHECK_LIST` holds one row per checklist **per unit** (*Time Stamps* exists on 184 unit-level
  copies, no template row), and the questions are copied per unit into `FMS_CHECK_LIST_DETAILS` —
  [fcc-checklist-templates.md](../payroll/tcg-rawfms-staging-database/data/fcc-checklist-templates.md)
  → *How FCC stores a checklist* and *Time Stamps — 97 distinct questions*. Across those copies the
  lunch rows are **not uniform**: in the *Before Left Job* phase 55 copies (54 signature-required,
  1 not) carry `Lunch Time: 2nd / 3rd / 4th Lunch`, while the remaining copies in every phase carry a single `Lunch Time` (in two
  wordings). FCC has no unit-type rule for this; a unit gets whatever list was attached to it under
  `Maintain > Units` ([fcc-e-ticket-and-atom-guides.md](fcc-e-ticket-and-atom-guides.md) §2). The
  vault page collapses the copies, so **which units carry the four-slot variant is not recorded**
  — the crane-vs-tractor correlation is still only the two tickets' evidence. Legacy-system fact,
  not a TCG decision. (b) **A second ticket shows the identical split**: on 44944 crane `10002` has
  four slots and tractor `AT25` one, omitting the same rows
  ([e-ticket-worked-example-44944.md](e-ticket-worked-example-44944.md) → *The Time Stamps
  checklist — 14 items on the crane, 11 on the tractor*), so drift
  on a single ticket is no longer a likely explanation. (c) The client has spoken to the 3rd and
  4th slots only as things to N/A: Melissa McNutt,
  [2026-06-04](../meetings/transcripts/2026-06-04-mobile-app-job-lem-tickets.md) 48:07 — *"their
  3rd and 4th lunch, if it's not applicable, they can just hit an A."* The paper day-log has **two**
  meal breaks ([field-paper-forms.md](field-paper-forms.md) §3 point 4) and the June demo models
  **three** ([field-app-demo-2026-06.md](field-app-demo-2026-06.md) §9), neither by unit type.
  **Still needs the client:** whether the ERP renders lunch slots per unit type, per checklist
  template, or as one rule for every unit on the ticket — the record shows only what FCC happened
  to hold.
- **Update 2026-09-04, from the record (computed the same day from `stg.FMS_CHECK_LIST_DETAILS_Raw` joined to `stg.FMS_UNITS_Raw` / `FMS_UNIT_TYPES_Raw`, restored 2026-06-23 backup):** the four-slot *Time Stamps* copy (`Lunch Time` plus 2nd/3rd/4th) is on **55 units** and the one-slot copy on **31**; the split follows unit type closely but not exactly. Four-slot: every crane type that carries the checklist (40 Ton ×6, 100 Ton ×4, 140 Ton ×3, 110 Ton AT ×2, RT ×2 …), the 30 Ton self-loaders ×5, support loads 1/2/3 ×9, stretch decks ×3, flatbed trucks ×3 — **and 3 of the tractor-semis**. One-slot: **22 of the tractor-semis**, yard trucks ×4, 22 Ton boom trucks ×3, and two cranes (a 60 Ton and the 265 Ton AT). So FCC's rule of thumb was "cranes and their loads get four lunch slots, tractors get one", applied by hand per unit copy with a handful of exceptions each way; there is no unit-type rule in the data to migrate, only the pattern. The count the ERP should render, and whether it keys on category, sub-category or the unit, still needs the client.

## Were mobile pickers in scope for "move dropdowns to the backend"?

- **Status:** open
- **Asked:** 2026-09-02 — PR review of branch `feat/move-dropdowns-BE` (no ticket, no
  `.ai/aidlc/` folder, no `processed.log` row); tcg-scrum escalation. Routed here as the module
  that owns the mobile surface.
- **Question:** The branch converts web entity pickers to server-searched, paged reads and adds a
  pre-push guard against whole-table reads. It touches **no mobile file** (191 web paths, 63 API,
  plus the guard script and `pre-push`), and the guard scans `apps/web/src/**` only
  (`scripts/check-dropdown-preloads.sh`:20, `WEB_GLOB`). Mobile therefore **keeps the exact
  pattern the branch removed from web**, and nothing will report it: `apps/mobile/data/services/
  resource-catalog/resource-catalog.service.ts` declares unparameterised `listSubCategories()`,
  `listEmployeeTypes()` and `listBillingCodeCustomTypes()`, and its own doc comment (:13–16) says
  it *"mirrors web's combination of `assetManagementApi.getSubCategories()`,
  `useGetEmployeeTypes()`, `useBillingCodeCustomTypesList()`"* — three of the readers now on the
  guard's `READERS` deny-list. Two parts: (a) was mobile **deliberately out of scope** for this
  change, or simply not done? (b) if the app-wide asks (`SCRUM-952` *"each dropdown across the
  app"*, `SCRUM-703` *"across the app"*) cover mobile, **which ticket carries that work**, and
  should the guard be extended to `apps/mobile` so the divergence is detectable?
- **Sources checked:** **Vault — nothing on mobile picker data loading.** `INDEX.md`;
  [field-ops-mobile-INDEX.md](field-ops-mobile-INDEX.md) and all three competing documents;
  [atom-mobile-app-user-stories/INDEX.md](atom-mobile-app-user-stories/INDEX.md);
  `../decisions/` (24 notes, none on mobile pickers or scope); `.ai/claude/contexts/mobile.md`
  (no `dropdown`, `picker`, `select`, `combobox` or `preload` — and it warns of itself that
  *"gaps here are unwritten rather than intentional"*). `.ai/aidlc/` — no ticket folder mentions
  dropdowns or pickers on mobile.
- **Jira has one live ticket on exactly this seam, and it is unresolved.** **`SCRUM-912`**
  *Align Quotation Resources Tab UI on Mobile with Web* (**In Progress**, 2026-08-19) records the
  two surfaces already diverging on this control — *"Web: users first select a resource, then a
  category, then a subcategory. Mobile: the bottom sheet displays subcategories, employees and
  custom resources together in a consolidated list"* — and asks outright *"Is this difference
  intentional, or should the mobile experience be aligned with the web flow?"* **That question was
  open before this branch and the branch changes the web side of it**, so whatever answer
  `SCRUM-912` gets is now aimed at a moved target. No other ticket scopes mobile dropdowns.
- **Blocked:** nothing ships broken — mobile works as before, and the API routes are dual-mode so
  its unparameterised calls still return bare arrays. This needs an answer before `SCRUM-912` is
  resolved, and before anyone reads a green pre-push as meaning the app has no preloaded pickers.
- **Owner:** Fouzan Shakil for the scope and guard question; whoever owns `SCRUM-912` for the
  parity half.

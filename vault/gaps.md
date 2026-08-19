# Gaps

**RETIRED 2026-08-20 — do not append here.** This single-register design (one growing file
covering every product topic) is being replaced by gaps that live inside a per-module vault
folder mirroring the backend's module structure, so lookup is scoped instead of blind. That
restructure hasn't happened yet — the plan is to do it as each module's vault content is
cleaned up and moved into its own folder, at which point that module's gaps move with it.
Until then, no agent should append a new entry here or treat this file as the live gaps
mechanism. The 24 entries below are kept for their content — still citable by anchor, e.g.
from a conflict stub — but are a historical snapshot, not an active register.

Open questions raised by the Confluence migration of 2026-08-10 and by everything since.
Each product entry is a conflict the migration deliberately did not resolve. Agents must not
pick a winner from these sets — surface the conflict and cite all candidates.

**Not for ticket questions.** A question raised while working a ticket goes to that ticket's
§12 of `.ai/aidlc/SCRUM-###/spec.md` — never here. This file holds only what belongs to no
ticket: the migrated Confluence backlog, and product-wide questions raised outside the loop.
`grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md` sweeps the ticket registers.

**Two registers, one format.** Product and process gaps live here. **Payroll and ADP gaps
live in [`payroll/gaps.md`](payroll/gaps.md)** — same entry shape, same rules, split out
because that register is three times this size and belongs to a separate source set. Both
are retired under the same note above.

**Read by section, never whole.** `grep -n '^## ' .ai/vault/gaps.md` lists every entry in one
screen; then read only the entries for the area you are working on. Reading this file top to
bottom costs more context than the four surface rule files put together and almost none of it
will be about your ticket.

## Field operations mobile app

- Question: which of these is authoritative?
- Candidates:
  - `product/frd-new-format-draft/INDEX.md` — 57 KB (9 parts), updated 2026-06-09. Document ID **FR-TCG-FOP-001**, Version **1.1**, Status **REVIEWED**.
  - `product/field-ops-frd/INDEX.md` — 48 KB (12 parts), updated 2026-06-16. Document ID **FR-TCG-FOP-002**, Version **2.0**, Status **DRAFT**.
  - `product/atom-mobile-app-user-stories/INDEX.md` — 16 KB (6 parts), updated 2026-07-22. 20 user stories across 5 epics, no document ID.
- Note: FR-TCG-FOP-001 v1.1 REVIEWED versus FR-TCG-FOP-002 v2.0 DRAFT with different
  document IDs means these are probably two deliverables, not two drafts — and every
  heuristic anyone would reach for (newer wins, bigger wins, reviewed wins) gives a
  different answer. Newest is the 16 KB user-story page; largest is FOP-001; only
  reviewed is FOP-001; highest version number is FOP-002. There is no ordering that
  resolves this without a human who knows what was actually delivered.
- Blocked: nothing yet — will block spec work on the Atom / field operations mobile app.
- Owner: product team
- Status: open

## Quotations

- Question: which of these is authoritative?
- Candidates:
  - `product/quotation.md` — 1.0 KB, updated 2026-06-23. Punch list from the JZ feedback folder.
  - `product/quotation-flow-process.md` — 2.1 KB, updated 2026-07-09. Stage/lifecycle flow.
  - `product/quotations.md` — 2.0 KB, updated 2026-07-14. Punch list from the Mohsin feedback folder.
  - `product/user-story-and-tasks.md` — 5.1 KB, updated 2026-04-22. Quotation management user stories, from a personal space.
- Note: these appear to be four different scopes (punch list, lifecycle, punch list,
  user stories) rather than four versions of one document, so the answer may be "all
  of them, merged" rather than a single winner.
- Blocked: nothing yet — will block spec work on the Quotations module.
- Owner: product team
- Status: open

## Customer

- Question: which of these is authoritative?
- Candidates:
  - `product/customer-and-job-sites.md` — 1.5 KB, updated 2026-06-12.
  - `product/customer.md` — 6.4 KB, updated 2026-07-16.
  - `product/discussion-points-with-mohsin.md` — 0.5 KB, updated 2026-06-25.
  - `product/discussion-points-with-tcg-team.md` — 1.1 KB, updated 2026-06-25.
  - `product/user-story-and-tasks.md` — 5.1 KB, updated 2026-04-22. Customer management user stories, from a personal space.
- Note: this is not four independent documents. `discussion-points-with-mohsin.md` is
  word-for-word the "Job Site" section of `customer-and-job-sites.md`, including the
  same two typos, and the customer bullets in `discussion-points-with-tcg-team.md` are
  the same lines as its "Customer" section. Resolving this is mostly deleting copies,
  not choosing between competing specs.
- Blocked: nothing yet — will block spec work on the Customer and Job Site modules.
- Owner: product team
- Status: open

## Agencies and vendors

- Question: which of these is authoritative?
- Candidates:
  - `product/agencies.md` — 1.3 KB, updated 2026-04-30. User stories.
  - `product/vendors.md` — 4.0 KB, updated 2026-04-30. User stories.
  - `product/agency-and-vendor.md` — 0.4 KB, updated 2026-06-22. Punch list.
  - `product/agencies-module.md` — 1.6 KB, updated 2026-07-22. Punch list.
- Note: the two newest files are the two smallest, and both are punch lists rather than
  specifications. Recency ordering would discard the only user-story-level content.
- Blocked: nothing yet — will block spec work on the Agencies and Vendors modules.
- Owner: product team
- Status: open

## Daily Allocation System (DAS)

- Question: which of these is authoritative?
- Candidates:
  - `product/daily-allocation-system.md` — 9.1 KB, updated 2026-04-30. User stories.
  - `product/job-project-das.md` — 1.9 KB, updated 2026-07-16. Punch list.
- Note: the newer file is roughly one fifth the size and covers job/project linkage
  rather than DAS behaviour, so these may be complementary rather than competing.
- Blocked: nothing yet — will block spec work on the Daily Allocation System.
- Owner: product team
- Status: open

## Mobilization and demobilization

- Question: which of these is authoritative?
- Candidates:
  - `product/mobilization-and-demobilization.md` — 5.4 KB, migrated 2026-08-10 from
    `confluence/TCG/Mobilization & Demobilization` (page id 142049281, itself edited
    2026-08-10). Prose requirements for the new ERP, plus the only coverage of the field
    ticketing / mobile app relationship to the quotation.
  - `confluence/TCG/Mob & demob` (page id 143458306) — **not migrated**, created/edited
    2026-08-11, same author. Numbered client functional requirements FR-01 to FR-12, a
    worked 265-ton example, and a step-by-step account of the current FCC process.
- Note: two live Confluence pages on one topic by the same author, one migrated and one not.
  They are not obviously versions of each other — the newer page is structured as a numbered
  FR set and drops the field-ticketing section entirely, while the older carries it. Detected
  by the 2026-08-11 drift check, not by the original migration. The newer page skips section 7
  (numbering runs 6 → 8), so it may still be in progress.
- Blocked: nothing yet — will block spec work on Mobilization/Demobilization in the quotation
  module, and any ticket citing FR-01 to FR-12, since those ids exist in only one of the two.
- Owner: product team
- Status: open

## Sprint 7 date range

- Question: what were the actual start and end dates of Sprint 7?
- Candidates:
  - The Sprint 7 report page (`confluence/TCG/Sprint 7 report`, not migrated) states
    "June 29, 2026 – July 10, 2026" — byte-identical to the Sprint 6 report, and
    therefore almost certainly a copy-paste error, since Sprint 8 begins July 27, 2026.
  - The page's embedded Jira query filters on `Sprint = 233`, a numeric board id rather
    than a sprint name, so the range cannot be recovered from the page itself.
- Note: this is resolvable in about thirty seconds by anyone with Jira board access —
  open sprint id 233 and read its dates. The Sprint 7 report was dropped from the
  migration as unrecoverable content; only its date range is worth recovering.
- Blocked: nothing yet — will block any reconstruction of the sprint timeline between
  Sprint 6 (ends 2026-07-10) and Sprint 8 (starts 2026-07-27).
- Update 2026-08-11 — the drift check found `confluence/TCG/Sprint 8 report` (page id
  136740865, edited 2026-08-11), which states "Sprint Dates: July 27, 2026 – Aug 7th, 2026".
  That **confirms the upper boundary** already assumed here and rules out Sprint 7 running to
  July 27. It does not answer the question: Sprint 7's own dates are still recorded nowhere,
  and the gap between 2026-07-10 and 2026-07-27 is still unaccounted for. Jira sprint id 233
  remains the way to settle it.
- Owner: product team
- Status: open

## Feedback punch lists are not scoped to the module they are filed under

- Question: should the cross-module feedback punch lists be split by module and
  attached to the relevant specs?
- Candidates (all are single files covering many modules):
  - `product/job-project-das.md` — 1.7 KB, updated 2026-07-16. Filed as DAS, but DAS is
    **one of nine sections**; it also covers Billing code, Price list, Project, PO, Sub
    category, Permit, Plan and Agency.
  - `product/quotations.md` — 1.8 KB, updated 2026-07-14. Filed as Quotations; trails
    into Assets, Tools & Rigging and Billing code.
  - `product/quotation.md` — 0.8 KB, updated 2026-06-23. Filed as Quotations; trails
    into Job and DAS.
  - `product/agencies-module.md` — 1.4 KB, updated 2026-07-22. Filed as Agencies;
    carries an "Across the app" block (US date format, breadcrumb spacing, activity-log
    refresh) that is not agency-specific.
- Note: this is why the DAS "conflict" is weaker than the other four — an 8.7 KB
  specification and a punch list that is only ~20% about DAS are complementary, not
  rivals. Filing these by their first heading makes them look like competing module
  specs when they are cross-cutting feedback captured in one sitting.
- Blocked: nothing yet — but it inflates four of the conflict sets with content that
  does not actually belong to them.
- Deliberately not done during the 2026-08-10 restructure: splitting these is content
  restructuring and needs its own pass with its own byte-level verification, not a side
  effect of indexing.
- Update 2026-08-19 — the drift check found a **fifth** cross-module punch list, **not
  migrated**: `confluence/TCG/13-august-QA` (page id 145195009, created by Aiman Farooq,
  edited 2026-08-17). Sections Auth, Customer, Quotation, Project, DAS, Yard Operations,
  Across App, Devs Feedback; several numbered items are empty (`DAS 1.`, `Yard Operations
  1. e`), so it is mid-edit and was held. Unlike the four above it is **QA-authored, not
  client-authored**, and most items already carry a ticket: `SCRUM-890`, `895`, `896`, `897`,
  `898`, `899`, `900`, `902`, `903`, `904`. Five items state product intent beyond a bug —
  *delete is being replaced by archive across the app* (896), *in-house comment should be
  chat across the app* (898), *tools & rigging not editable on a job* (899), *a mobile ticket
  cannot start before load-out* (902), *offline save in yard operations, marked "(client
  feedback)"* (904). None of those five is written in the vault; the ticket is the only
  source. One item ("quotation marked Signed auto-created Project and Job without Convert to
  Job / Create Project") is a behaviour question, not a bug report, and has no ticket on the
  page.
- Owner: product team
- Status: open

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
  - `product/brs.md` (9.2 KB, 2026-06-10) — BRS-LUNCH-005 "Lunch Threshold Values" is
    marked *Needs Supporting Documentation*; OD-002 / OD-003 / OD-004 all *Need
    Documentation*. BRS-LUNCH-002 lists **three** known lunches (First, Second, Third) and
    is marked **✓ Confirmed**.
  - `product/field-ops-frd/11-open-questions-future-considerations.md` (FR-TCG-FOP-002
    v2.0 DRAFT) — open question 1, "Exact lunch thresholds and union variations".
  - `product/frd-new-format-draft/08-open-questions.md` (FR-TCG-FOP-001 v1.1 REVIEWED) —
    open question 4, "What are the final lunch threshold rules for first, second, third,
    and fourth lunch?", owner Corrina, status Open. Open question 1 (owners Wes + Corrina)
    additionally leaves signature ownership for Third Man/Laborer undecided.
  - `product/frd-new-format-draft/05-functional-requirements/fr-fop-015-work-through-lunch-authorization.md`
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
  `product/brs.md` BRS-LUNCH-002 still lists **three** lunches and is still marked
  **✓ Confirmed**; both FRDs still carry the thresholds as open questions; and the page still
  has no customer-unavailable path for WTL, stating only that it "requires customer
  authorization" with name, signature and photo. The likeliest reading is that the ticket's
  values were pasted into the page, which spreads the unsourced decision to one more location
  rather than resolving it. Recency is not authority — a page edited today does not outrank a
  BRS item marked Confirmed. The vault's migrated copy
  (`product/atom-mobile-app-user-stories/03-ticket-workflow.md:138`) carries no numbers and was
  deliberately **not** re-migrated: the page was mid-edit when observed (two sections numbered
  US-11, an epic titled "PIC 10", epics 5-9 absent, US-12 missing).
- Status: open

## Labor Compliance module — no vault coverage

- Question: what is the Labor Compliance module, end to end?
- Candidates: [meetings/2026-08-07-labor-compliance-certified-payroll.md](meetings/2026-08-07-labor-compliance-certified-payroll.md)
  is the **only source in the vault**. There is no FRD, no user stories, no BRS section.
- Note: the module name was **agreed in that meeting** — "Labor Compliance" chosen as the primary
  name because it encompasses Certified Payroll, Davis-Bacon and related requirements. It spans
  quotation (a compliance indicator captured at quote time), payroll (Certified Payroll reports
  generated from payroll data), and billing (processing fees, recurring compliance charges,
  Non-Performance reporting). It also has an external integration, the **LCP Tracker**, linked by
  project name.
- The stated failure mode is worth repeating: **if a job is not marked as a Labor Compliance job
  it will never appear in Certified Payroll reports.** Missed compliance reporting delays customer
  payment. That argues the flag cannot be a field added later.
- Blocked: any Labor Compliance work; also the Compliance Checklist action item on CC, which
  cannot be specified before Corrina supplies the Davis-Bacon identification criteria.
- Owner: Corrina (TCG) for the Davis-Bacon business rules and identification criteria; TCG for the
  Labor Compliance setup form and Tracking Register; CC for the checklist evaluation.
- Status: open

## Sell-side scheduling artefacts — no vault coverage

- Question: what are the Job Schedule Master, the Ready-to-Schedule Checklist, the One-Page
  Customer Intake, the Geographic Heat Map, and "Red Path"?
- Candidates: [meetings/2026-08-12-sell-side-workflow-and-scheduling.md](meetings/2026-08-12-sell-side-workflow-and-scheduling.md)
  only. Brian Petros shared source files in the meeting; **those files are not in the vault**.
- Note: **"Red Path" is undefined.** It is used as though established. Add it to the undefined-terms
  list. Two scheduling rules stated in the meeting — cranes under maintenance must not be
  selectable, and double booking must be *supported* where short jobs allow — belong to the Daily
  Allocation System, and neither of that area's two conflicting sources covers either rule.
- Note also: **permits** (annual vs job-specific, city eligibility, crane-travel permits) have no
  vault coverage. The field-ops FRD lists permits only as a *Pending* BRS topic.
- Blocked: the Customer Intake action item on CC, which depends on TCG confirming the intake
  questions, fields and business rules.
- Owner: TCG team for intake questions/fields/rules; Brian Petros for the workflow source files.
- Status: open

## Integrations — HubSpot, Microsoft 365, Dialpad, Mapsly

- Question: what do the existing integrations do, and what should move into the ERP?
- Candidates: **none of substance.** HubSpot appears once, in `product/user-story-and-tasks.md`,
  which was migrated from an individual's personal Confluence space and carries a
  `provenance_note` warning it may be a private draft rather than agreed specification.
  **Dialpad, Mapsly and Microsoft 365 appear nowhere in the vault.**
- Note: the 12 August minutes record that Patrick will demonstrate the working solution at the next
  meeting. Until then there is no written source, and the one HubSpot mention should not be treated
  as one.
- Blocked: the action item to review existing integrations for ERP incorporation.
- Owner: Patrick (demo), then whoever writes it down.
- Status: open

## Meeting recordings disagree with the vault — 2026-08-19 review

- Question: which side is right, in each of the pairs below?
- Candidates: the OneDrive drop `OneDrive_1_8-19-2026` (55 TCG–CodingCops meeting recordings,
  2026-01-15 → 2026-08-13) was read in full on 2026-08-19 and every product ask checked against
  the vault and all 902 SCRUM issues. Full report (1,501 items; 502 with no ticket and no
  vault coverage, 348 in the vault with no ticket):
  https://claude.ai/code/artifact/8d4b706b-9eaa-4369-a9b2-d78fe26233db . The rows below are the
  ones where a recording **contradicts** a vault file or a ticket. Payroll ones are in
  `payroll/gaps.md` under the same heading.
- **Recency is not authority.** A recording is a data point inside the conflict, not its
  resolution — several of these are TCG changing its mind between meetings. Do not pick a side.
- **Confluence and Jira are CodingCops' record, not the client's.** TCG does not use Confluence.
  A recording that disagrees with a vault file or a ticket is therefore first a defect in *our*
  write-up of what the client said; it becomes a client question only where TCG itself said two
  different things, or where CC agreed to something on the call and never wrote it down.
- Note: room-mic recordings label Lisette, Dylan, Liz and Wes as "Brian Petros"; speakers below
  are inferred from content.
- Pairs:
  - **2026-03-06** — Customer show page has an internal Comments section for
    accounting/dispatch/anyone interacting with the customer — *vault/ticket:*
    product/customer-and-job-sites.md ("Notes - do TCG team use this feature?") — *jira:*
    SCRUM-49 (Remove Comments Section from Customer Show Page — Done), SCRUM-52 (Not
  - **2026-03-06** — Quotation form carries a PO number field ("the PO number is going to be
    available") — *vault/ticket:* product/quotation.md ("Customer PO"),
    product/customer-and-job-sites.md (associate customer POs) — *jira:* SCRUM-149 (PO number
    field — remove it, Done), SCRUM-575 (Pre-Quote Data Form &
  - **2026-03-06** — Approved quote is automatically converted into a Project (draft) once
    transmitted to dispatch — *vault/ticket:*
    product/project-module/01-create-and-track-projects.md says salesperson clicks "Create
    Project" on a signed quotation (manual one-click), and a project can also be created without
    a quotation — *jira:* SCRUM-894 (Prevent Automatic Project and Job Creation Before
    Conversion, To Do),
  - **2026-03-06** — Row 184 phased rollout: "Phase 1 = mirror existing FCC functionality
    (customers, quotes, jobs) … within ~6 months; subsequent phases = project layer, safety,
    CRM, analytics" — transcript (1969-1970) has Ans putting the *project… — *vault/ticket:*
    none
  - **2026-03-12** — Rename "billing codes" to "price list" for simplicity. — *vault/ticket:*
    product/billing-code-and-price-list.md keeps both entities — *jira:* SCRUM-80 and SCRUM-97
    keep both
  - **2026-03-12** — POs must be creatable at quotation level, at job level, and standalone for
    the business; every PO must have a trail to why it exists; job-level POs auto-link; PO
    cancelled if quote lost. — *vault/ticket:* product/sprint-4-additional.md says "Every PO
    must be linked to a job number — required, not optional" — *jira:* SCRUM-518, SCRUM-473
  - **2026-03-20** — Customer statuses: Active, Inactive, Prospect, plus new "On hold". —
    *vault/ticket:* CONTRADICTS: product/user-story-and-tasks.md:102-107 defines status as
    auto-calculated colour indicators (Active / Inactive 6 months / Inactive 1 year) — no
    Prospect or On hold
  - **2026-03-20** — Credit limit is needed on the customer. — *vault/ticket:*
    product/customer-and-job-sites.md:40 says "Remove credit limit and forecast from show page"
    — *jira:* SCRUM-20, SCRUM-715 (Credit Limit)
  - **2026-03-20** — Comments wanted at the customer level. — *vault/ticket:*
    product/customer.md:37-40 (notes) — *jira:* CONTRADICTS: SCRUM-49 "Remove Comments Section
    from Customer Show Page" (Done);
  - **2026-03-20** — Keep Notes and Tasks on customers (task manager per customer; CRM to be
    built on top). — *vault/ticket:* CONTRADICTS: product/customer-and-job-sites.md:25 "Remove
    tasks from customers"; :26 asks whether TCG uses notes (answered: yes) — *jira:* SCRUM-198
    (job-site tabs incl. notes/tasks during creation), SCRUM-52
  - **2026-03-20** — Employees can be assigned to multiple companies and multiple yards, not a
    single default. — *vault/ticket:* none — *jira:* CONTRADICTS: SCRUM-468 "Yard Field in
    Employee Creation" associates an employee
  - **2026-03-26** — On-site scope of work / "site scope plan" (same paper form as lift plan,
    different heading, handwritten on site, JSA alongside) becomes a digital form in the mobile
    app; operators enter actual measurements; changes mid-lift mus… — *vault/ticket:*
    product/project-module/04-create-and-approve-lift-plans.md "User Story 4: Create a Site
    Plan" (Project Engineer creates in portal with approval — DIFFERENT actor/flow);
    product/field-ops-frd/08-functional-requirements/fr-fop-011-job-safety-analysis-jsa.md (… —
    *jira:* SCRUM-236 Create a Site Plan (portal); SCRUM-862 JSA / Tailboard (mobile) — no m
  - **2026-03-31** — New "Project" entity: an approved quotation gets a "Create Project" button
    (replacing "Convert to Job"); project carries the job-location name, all quotation data,
    KPIs (total/active jobs, unassigned jobs), tabs for quotations,… — *vault/ticket:*
    product/project-module/01-create-and-track-projects.md (Create Project on signed quotation,
    tab bar) — *jira:* SCRUM-231; but SCRUM-312 ("replace resend/void actions with Convert to
    Job CTA")
  - **2026-04-09** — Renewal reminders for asset annual permits should fire ~90 days out. —
    *vault/ticket:* CONTRADICTS: product/project-module/05-create-and-track-permits.md says
    "Permit expiry alerts are triggered 30 days in advance" — *jira:* SCRUM-372 (expiry reminder
    scheduler)
  - **2026-04-21** — Jobs panel has compact chip view and detailed list view (list view also
    shows required crane size); Lisette prefers the "squares" layout. — *vault/ticket:*
    product/daily-allocation-system.md (compact/list toggle) — *jira:* SCRUM-331; note SCRUM-784
    "Remove card . grid view toggles" (Done, from 07-16 pu
  - **2026-05-14** — Who fills the ticket: crane + one truck → the oiler fills ONE ticket
    covering himself and the operator (crane, tractor, trailer, both names); every other
    driver/equipment gets its own ticket; two crew riding in one truck may sh… — *vault/ticket:*
    product/frd-new-format-draft/04-role-responsibility-model.md ("The Oiler owns the main
    ticket… Operator's labor is captured within the shared ticket"); fr-fop-009 (oiler checklist
    covers crane, tractor, trailer, support loads) — *jira:* SCRUM-249 (fetched) creates a
    ticket "against all employees that had allocations
  - **2026-06-17** — Dispatch changes the dispatched asset only in the dispatch (DAS) view; the
    job's requested resources stay as the client-approved record; both are retained —
    *vault/ticket:* CONTRADICTS: product/project-module/02-view-manage-job-details.md says
    "Dispatcher can add new resources, update existing ones, or remove them" on the job
    Resources tab — *jira:* SCRUM-580 (Done)
  - **2026-06-18** — Asset on a permit becomes optional (was default); when a permit carries an
    asset, DAS auto-attaches that asset to the job for that date — *vault/ticket:*
    product/project-module/05-create-and-track-permits.md (asset in permit form; active permits
    auto-link to dispatch); CONTRADICTS: product/job-project-das.md ("auto create travel permit
    request based on assets required – before navigating to next step, add as… — *jira:*
    SCRUM-517 (Done), SCRUM-533 (Done), SCRUM-625 (Done)
  - **2026-06-18** — SOS options: 911, safety officer, crane superintendent, nearest hospital,
    broadcast to office — and add Dispatch — *vault/ticket:*
    product/atom-mobile-app-user-stories/06-safety-and-self-service.md US-21 (911, Safety, Crane
    Super, hospital — no Dispatch, no broadcast) — *jira:* SCRUM-880 (In Review) — AC list 911 /
    Safety / Crane Superintendent / hospital o
  - **2026-08-11** — Schedule fields: sales coordinator, salesperson, job location, status
    Scheduled/Tentative/Hold/Cancelled/Maintenance, scheduled hours; cranes in maintenance must
    not be selectable; double-booking allowed for short jobs — *vault/ticket:* M-0812;
    `product/daily-allocation-system.md` says in-maintenance assets are greyed out but still
    draggable with a warning — Ryan wants non-selectable;
    `product/project-module/03-create-manage-job-schedule.md` (warning on double assignment) —
    *jira:* SCRUM-502 (Asset Availability & Maintenance Status), SCRUM-234
  - **2026-08-12** — Photo of the customer signer must be optional / consent-based — a customer
    may refuse to be photographed; today it is required in the app; CC agrees to make it
    optional ("not a huge change"); TCG will encourage but not fight fo… — *vault/ticket:*
    product/frd-new-format-draft/05-functional-requirements/fr-fop-018-signature-quality-fraud-prevention.md
    (photo capture is a configurable per-deployment toggle); CONTRADICTS:
    product/atom-mobile-app-user-stories/02-ticket-assignment-and-pre-trip.md line 136… —
    *jira:* SCRUM-861 Arrive Job & Customer First Authorization (QA) — flow, not the optiona
- **Disposition, 2026-08-19 (`tcg-scrum` pass).** Each pair was retrieved in full — `INDEX.md`, the
  topic conflict stub where one exists, the cited vault files and their `conflicts_with:`,
  `decisions/`, every named Jira issue, and the plain-text transcript passage. **No pair is resolved
  by a written dated decision from a named human**: `decisions/` holds two notes
  (`decisions/2026-06-30-adp-erp-employee-data-ownership.md`,
  `decisions/2026-08-12-plan-comments-page-scope.md`) and neither touches product. Three findings
  change how the whole list should be read, and they matter more than any individual row:
  - **Three of the 21 are not TCG asks at all.** The `2026-03-06` customer-Comments and
    quotation-PO rows are `ehtesham.anwar` (CodingCops) narrating his own Figma; the `2026-03-12`
    billing-code rename was proposed by `ehtesham.anwar` and seconded by `ans.nisar` — also
    CodingCops — while the TCG voice on that call (Joe Schacatano) was simultaneously describing
    billing code and price list as **two layers**, a price list overriding a billing code's default
    rate. A vendor describing his own mockup is not a contradiction with the vault. The ReadAI
    summary's *"The team agreed to change 'billing codes' terminology to 'price list'"*
    (`2026-03-12 … ReadAI summary`, line 36) asserts an agreement the transcript does not show.
  - **The `2026-03-20` Fireflies transcript carries no speaker labels and no timestamps at all.**
    Five pairs come from it. The attribution caveat above understates that case — those quotes are
    *unattributable*, not merely mis-attributed. Cite them as "unattributed speaker, 2026-03-20 FCC
    field review, transcript line N", never as a name. Separately, in the `2026-03-26` recording the
    "Brian Petros" label demonstrably covers **Ryan Adams** too (Wes Staley: *"That was your
    question, Ryan?"*), so Ryan belongs in the mislabelled set alongside Lisette, Dylan, Liz and Wes.
  - **Not one Jira ticket across all 21 pairs names the TCG human who asked.** Every reporter is
    CodingCops (Umair Khan, Aiman Farooq, Abdul Muazzam, ali riaz), and six shipped or sit **Done /
    To Do with `description: null`** — `SCRUM-149`, `SCRUM-372`, `SCRUM-331`, `SCRUM-518`,
    `SCRUM-80`, `SCRUM-97`. So **no pair qualifies as "resolved by a ticket that records who
    asked"**. Where a pair is dispositioned *resolved by the sequence of events* below, that means
    **evidence of what was built — never adjudication.**
  - A fourth, structural: **the `product/atom-mobile-app-user-stories/` page is de facto
    authoritative for what gets built** — `SCRUM-880` is US-21 verbatim, `SCRUM-862` is US-10
    verbatim, `SCRUM-861` is US-09 verbatim minus one bullet — even though it is the one field-ops
    document with **no document ID and no review status**, while `FR-TCG-FOP-001 v1.1 REVIEWED` is
    not being built from. That is a material fact for §*Field operations mobile app* and was not
    previously recorded there.
- Per-pair disposition (21 rows; two pairs merge, so 19 questions and 17 new entries below):
  - `2026-03-06` customer Comments **+** `2026-03-20` comments at customer level — **one question,
    not two** → §*Customer-level comments — asked for on tape, removed by a QA ticket four weeks later*
  - `2026-03-06` quotation PO number field — open → §*"Customer PO" on the quotation — which of three things does it mean?*
  - `2026-03-06` auto quote→Project **+** `2026-03-31` Project entity vs "Convert to Job" — **one
    mechanism** → §*Quotation → Project → Job — what one click creates, and what the button is called*
  - `2026-03-06` phased rollout (row 184) — open → §*Phased rollout — no vault coverage, and the AI summary contradicts its own transcript*
  - `2026-03-12` rename billing codes → price list — **over-flagged; not a contradiction.** Billing
    code and price list are two entities in the built system (`PriceListing`, `BillingCode`,
    `PriceListingItem`, `BillingCodeCustomType`, `BillingCodeTypeMaster` in
    `apps/api/prisma/schema.prisma`), maintained in parallel across 51 tickets and two live epics
    (`SCRUM-80`, `SCRUM-97`, both To Do, both `description: null`), and `SCRUM-163` (Done) implements
    a **two-tier lookup** — price list first, then billing codes — which is impossible if they are
    one renamed thing. **No ticket ever proposed the rename.** Residual, unrelated to the rename and
    already written at `product/billing-code-and-price-list.md:34`: whether billing codes and price
    lists are yard-specific — `SCRUM-782` and `SCRUM-795` are both **Blocked** on it. No new entry;
    this row should be closed by a human rather than silently dropped.
  - `2026-03-12` POs at quotation / job / standalone level — needs confirmation → §*Purchase orders at three levels — Joe and Ryan on tape, nothing written*
  - `2026-03-20` customer statuses (Prospect, On hold) — open → §*Customer status values — neither side was built*
  - `2026-03-20` credit limit — **over-flagged; the weakest row of the 21.** Credit limit is built
    and continuously maintained (`creditLimit Decimal?` on `model Customer`; `SCRUM-20` Done Apr,
    `SCRUM-715` Done Jul). The vault line that "contradicts" —
    `product/customer-and-job-sites.md:40` *"Remove credit limit and forecaset from show page"* — is
    **display-scoped**, sits under that file's own *"Feedback on new Design"* heading, and never
    asked for the field's removal from the model. `product/customer.md:42` (2026-07-16) then treats
    the field as present. The only honest residual is *"is credit limit shown on the customer show
    page?"*, which is a design question, not a product conflict. See §*Feedback punch lists are not
    scoped to the module they are filed under* — this row is an instance of that pattern.
  - `2026-03-20` keep Notes and Tasks on customers — open → §*Tasks on customers — reversed on tape, then removed with no artefact*
  - `2026-03-20` employees on multiple companies and yards — open → §*Employee ↔ yard and company cardinality — the ask exists in exactly one place*
  - `2026-03-26` on-site scope of work / site scope plan — open → §*On-site scope-of-work form — the recording is the only source, and a Done ticket looks like coverage*
  - `2026-04-09` permit renewal reminders 90 vs 30 days — open → §*Permit expiry reminders — neither 90 nor 30 shipped*
  - `2026-04-21` jobs panel chip vs list view — open → §*Jobs panel views — Lisette's stated preference was removed without her*
  - `2026-05-14` who fills the ticket — open → §*Who fills the ticket — the schema has already picked a side against the only REVIEWED document*
  - `2026-06-17` dispatched asset vs requested resources — needs confirmation → §*Requested vs dispatched resources — Melissa stated it, the vault still says the opposite*
  - `2026-06-18` asset on a permit optional — open → §*Asset on a permit — optional, except where a punch list says compulsory*
  - `2026-06-18` SOS options — needs confirmation → §*SOS — Dispatch was asked for and agreed on the call, and is in neither the docs nor the code*
  - `2026-08-11` schedule fields and maintenance selectability — open → §*Schedule fields — the build already agrees, and the new fields are written nowhere*
  - `2026-08-12` signer photo optional — needs confirmation → §*Signer photo — CodingCops committed on the call and no ticket exists*
- Blocked: nothing yet — each pair blocks the unit that touches it. The build-blocking ones are
  §*Who fills the ticket* (schema change with a data migration), §*Employee ↔ yard and company
  cardinality* (same), and §*On-site scope-of-work form* (no written requirement at all).
- Owner: `tcg-scrum` to put each pair to the named TCG person; the answer goes to `decisions/`.
- Status: **partly disposed** — 2 rows over-flagged and recommended for closure (billing-code
  rename, credit limit), 2 pairs merged into other entries, 17 entries opened below. **0 resolved by
  a decision note; 0 resolved by a ticket naming a requester.**

## Customer-level comments — asked for on tape, removed by a QA ticket four weeks later

- Question: should the Customer show page carry an internal Comments section (visible to
  accounting, dispatch and anyone interacting with the customer) — and is that the same thing as
  the Notes tab that exists today, or a second feature alongside it?
- Candidates:
  - Recording **2026-03-06 "Sales-Quoting Figma demo"**, `ehtesham.anwar` (**CodingCops**) at 4:52,
    transcript line 154: *"Comments is going to be used for internal comments from from accounting,
    from dispatch, from from all of the all of the people who can interact with the customer."*
    **This is the vendor narrating his own Figma, not a TCG ask** — Ryan Adams' only reply (8:54) is
    about security and does not mention Comments.
  - Recording **2026-03-20 "FCC fields/screens review"** — the actual TCG ask, transcript lines
    72–84: *"there's just no comments here. But sometimes we do. Right. On customers."* / *"We want
    comments on the customer level."* / and the driver closing the item at line 84: *"So that's.
    Have comments on the customer level. Okay."* Fireflies summary line 44: *"The team wants to keep
    comments and notification features at the customer level."* **Unattributable — this transcript
    has no speaker labels.** At least three distinct voices participate.
  - `SCRUM-49` *Remove Comments Section from Customer Show Page* — **Done**, reporter Aiman Farooq
    (CodingCops QA), created **2026-04-16**, updated 2026-04-20. Its entire justification is
    *"It is not required as part of the current UI/UX scope."* **No requester, no meeting, no date
    cited.** It post-dates the TCG ask by four weeks.
  - `SCRUM-898` *Implement In-House Comment as Chat Functionality Across the Application* — **To
    Do**, created 2026-08-17, parent `SCRUM-24` (Across App), **not** the Customers epic. A
    cross-app UI-paradigm ticket, not a customer-comments re-add.
  - `product/customer.md:35-40` — the lines the combined entry cites are about **notes**, not
    comments. **The word "comment" does not appear in that file.** No vault file covers customer
    comments at all; the citation in the pair row should be read as a near-miss.
- Note: **the chronology in the pair row is inverted.** TCG asked for customer comments on
  2026-03-20; QA removed the section on 2026-04-16; nobody re-added it. So this is not "the client
  changed its mind" — it is an ask that was overwritten by an internal scope judgement. Two further
  facts sharpen it: the data was never removed (`comments String[] @default([])` survives on
  `model Customer`, orphaned with no UI), and the in-house comments feature was rebuilt from scratch
  in May under a different name (`SCRUM-355`, `SCRUM-360`) on projects and plans, never re-attached
  to customers. **A second requirement rode along in the same passage and is recorded nowhere** —
  transcript lines 75–79 ask for customer-level **pop-up notifications that fire when a job or work
  order is opened** (*"if certain customers require certain things… there's a pop up notification"*),
  explicitly flagged in-meeting as *"a side note for coding cops"*. No vault entry, no ticket.
- Blocked: the Customer show page; whether `Customer.comments` should be wired up or dropped;
  `SCRUM-898`'s scope, which will decide the paradigm for every module.
- Owner: Melissa McNutt (policy/customer). The 03-20 speaker is unrecoverable, so this must be put
  to the customer owner rather than to "whoever said it".
- Status: open

## "Customer PO" on the quotation — which of three things does it mean?

- Question: does `product/quotation.md:26` *"Customer PO"* mean (a) a PO-number field on the
  quotation form, (b) the Customer PO workflow that `SCRUM-575` shipped between Sent-to-Customer and
  Won, or (c) associating customer POs with the customer record — and is a PO number on the
  quotation wanted at all?
- Candidates:
  - Recording **2026-03-06**, `ehtesham.anwar` (**CodingCops**) at 9:13, transcript line 170: *"the
    PO number is going to be available. This functionality is going to be available right there. You
    can create within the quotation as well."* Again the vendor describing his own mockup; the
    2026-03-06 action-items file contains **no** PO item at all.
  - `SCRUM-149` *PO number field — remove it* — **Done**, reporter Aiman Farooq, created 2026-04-22.
    **`description: null`** — no description, no AC, no rationale, no requester. Its only comment
    (Abdul Muazzam) is what establishes the field was on the quotation at all.
  - `SCRUM-575` *Pre-Quote Data Form & Customer PO Form* — **Done**, reporter Umair Khan, created
    2026-06-25, label `Feedback.Sprint.4`. Description in full: *"Add Pre-Quote Data Form and
    Customer PO workflow between Sent to Customer and Won stages."* Its closing comment says it
    shipped under two different names — *"1. new customer packet 2. job and labor compliance
    information request form"*.
  - `product/quotation.md:26` (JZ punch list, 2026-06-23) — the bare bullet *"Customer PO"*, one of
    ~20 unelaborated bullets, **post-dating `SCRUM-149`** by two months.
  - `product/customer-and-job-sites.md:28` — *"Need to associate customer POs with customer -- need
    to ask TCG team to provide customer PO form / data"*. **Phrased as an open question to TCG**,
    never answered.
  - `product/purchase-order.md` — `conflicts_with: []`, and entirely about **vendor and permit** POs
    owned by Liz Lopez and Jeff Stricker. Says nothing about a customer PO on a quotation.
- Note: the built state is unambiguous and is the reason this is answerable in one line —
  `model Quotation` has **no** `poNumber`; `model Project` and `model Job` both do. A vestigial
  `poNumber?: string | null` survives in `apps/web/src/features/quotations/types/quotation-api.ts`
  with no form field and no consumer. So the field was removed and the workflow was built elsewhere
  under other names. What is genuinely unresolved is only what the punch-list bullet is asking for,
  and it was written **after** the removal — which is why it cannot be dismissed as stale.
- Blocked: any spec work citing `product/quotation.md`; whether the vestigial web type should be
  deleted; the pre-quote package scope.
- Owner: Ryan Adams / Joe Schacatano (sales & quotation).
- Status: open

## Quotation → Project → Job — what one click creates, and what the button is called

- Question: on a signed quotation, should the single "Create Project" action also create a Job in
  the same transaction, or should Project and Job be two deliberate steps — and is "Convert to Job"
  a retired label or a permanent second stage?
- Candidates:
  - Recording **2026-03-06**, `ans.nisar` (**CodingCops**) at 35:46: *"after the approval of the
    code [quote], once it goes towards the dispatching… at that point we'll be actually converting
    **automatically** to a project. It will be a **draft mode** or whatever."* The TCG assent on
    record — Melissa McNutt 31:26 *"I like that"*, Ryan Adams 31:30 *"Yes, I think that covers it"* —
    lands **before** that turn and attaches to the *project-entity concept*, not to the automation.
    Nobody responds to the 35:46 turn.
  - `2026-03-06_AI-generated_Meeting-Action-Items.txt` **contradicts itself**: line 58 *"A Project is
    auto-generated when a Quote is approved"*; line 70 *"'Convert to Job' button on an accepted quote
    creates a Project and initial Job."* The manual/automatic ambiguity is inside the meeting's own
    action list.
  - Recording **2026-03-31 "Dispatch-Scheduling-Permits Figma demo"**, `Ehtesham Anwar` at 8:52:
    *"Instead of having convert to a job, we are going to have a new button that is going to say
    create project"* — and immediately after, at line 169, *"Whenever she clicks on the project
    automatically that position getting to also create a a job against that"*. **The vendor stated
    on 2026-03-31 that Create Project also creates a Job.** The only TCG reaction (17:28) is under
    the "Brian Petros" label while Ehtesham had just addressed **Lisette** by name — attribution
    inferred.
  - `product/project-module/01-create-and-track-projects.md` (`status: unverified`) — :20 *"Clicks
    'Create Project' from the Quick Actions panel"*, :29 *"only visible on quotations, when qoutation
    is signed"*, :30 *"instantly creates a project with all key data carried over"*, :35 a project
    can be created without a quotation. **Manual, one click. It does not say a Job is created too.**
  - `product/quotation-flow-process.md:72` — *"Step 27: Approved quotation is converted into a
    Project."* Passive voice; compatible with both readings and therefore settles nothing.
  - `SCRUM-231` *Create and Track Projects* — **Done**, created **2026-05-01**. `SCRUM-312` *"replace
    resend/void actions with Convert to Job CTA"* — **Done**, created **2026-05-06**, a
    **`description: null` subtask** under the DocuSign story `SCRUM-239`. **Project came first, by
    five days; the Convert-to-Job subtask never contested it.**
  - `SCRUM-894` *Prevent Automatic Project and Job Creation Before Conversion* — **To Do**, reporter
    Aiman Farooq, created 2026-08-17. A first-person QA repro (*"I had not yet clicked Convert to Job
    or Create Project button but the Project and Job were automatically created"*), **no AC, no
    requester named**. `gaps.md` §*Feedback punch lists…* records the same item from the
    13-august-QA page as having **no ticket**; `SCRUM-894` appears to be that ticket, filed
    separately. That accounting should be reconciled by a human, not inferred.
- Note: **both labels are live in the build by design, not by accident** —
  `apps/web/src/features/quotations/components/organisms/quotation-sales-actions.tsx:118` reads
  `const convertLabel = hasLinkedProject ? 'Convert to Job' : 'Create Project';`, backed by two
  modals and two endpoints (`POST /projects/from-quotation`, `POST /projects/convert-to-job`). And
  `apps/api/src/usecase/projects/projects.service.ts:467` comments *"Create Project + Job inside a
  single transaction so creation is atomic"* — so one click does create two things, which is
  probably what QA saw. **The two-stage semantics and the label-flip rule are written nowhere** —
  not in the vault, not on any ticket. Also unwritten: the API guards only on `convertedToJob`, so
  the "only when signed" rule from the vault is enforced in the UI alone.
- Blocked: `SCRUM-894` (To Do) cannot be specified without this; any spec citing
  `product/project-module/01-create-and-track-projects.md`; the 13-august-QA behaviour question.
- Owner: Ryan Adams / Joe Schacatano (sales & quotation), with Lisette Anzaldo for the dispatch-side
  consequence of a Job existing early.
- Status: open

## Phased rollout — no vault coverage, and the AI summary contradicts its own transcript

- Question: what is in Phase 1, and does the Project layer belong to Phase 1 or to a later phase?
- Candidates:
  - `2026-03-06_AI-generated_Meeting-Action-Items.txt` **line 184** (the "row 184" of the pair row):
    *"Plan a phased rollout strategy: Phase 1 = mirror existing FCC functionality (customers, quotes,
    jobs) so TCG can begin transitioning away from FCC within ~6 months; subsequent phases = project
    layer, safety, CRM, analytics. — Owner: Ans Nisar + Brian Petros — Priority: High"*
  - The transcript it was generated from says the opposite about the project layer. `ans.nisar`
    (**CodingCops**) at 1:36:22: *"we'll be introducing a concept of project rather than just the
    jobs. So we'll definitely have that. **So the first phase for that**"*. At 1:36:06: *"In my
    opinion, it should be under six months"* — **a vendor estimate**, in answer to Melissa McNutt's
    question at 1:34:39 (*"it'd be kind of nice to know, hey, you know, we're six months out…"*).
  - Wes Staley at 1:37:29 asks about a 12-month full implementation and then defers it commercially
    at 1:38:01: *"So what is 12 months gonna cost us? So we have to talk with Lucim about that."*
    `ans.nisar` at 1:38:39: *"I would recommend not to fast pace this a lot."*
  - The "Brian Petros" label at 1:12:01 (**attribution inferred**) explicitly leaves it undecided:
    *"I think one of the next meetings we're going to have to sort of strategize you know how much to
    build in on the first phase… I'm curious what you guys think."*
  - **Vault: nothing.** A vault-wide search for phasing, roadmap or rollout content returns only this
    gaps entry and unrelated payroll-internal phasing. **Jira: nothing** — no epic or ticket
    describes a phase or a roadmap.
  - `README.md` §*What this vault does not contain, and why* lists eight exclusion categories.
    **Roadmap, phasing and timeline content is not among them** — this absence is not deliberate.
- Note: row 184 is an **AI-generated action item**, and on the one substantive point it is checkable
  against, it is wrong: it puts the project layer in "subsequent phases" while its own transcript
  puts it in the first. Row 184's own text is *"**Plan** a phased rollout strategy"* — an action item
  to *produce* a plan, assigned to Ans Nisar + Brian Petros, with no evidence it was ever completed.
  So there is no phasing to contradict: **no named TCG person committed to one on this recording**,
  and the six-month figure is a vendor opinion that was immediately deferred to a commercial
  conversation. Do not cite row 184 as a plan.
- Blocked: nothing directly, but it is the missing frame for every "is this in scope now?" question,
  and `INDEX.md` forbids citing FCC behaviour as a requirement source — so *"Phase 1 = mirror
  existing FCC functionality"* is unusable as written even if someone wanted to act on it.
- Owner: Brian Petros (cross-cutting; named as co-owner of row 184).
- Status: open

## Purchase orders at three levels — Joe and Ryan on tape, nothing written

- Question: may a PO be created **standalone** — not linked to any job — and should a PO created at
  the **quotation** level be cancelled automatically when the quote is lost?
- Candidates:
  - Recording **2026-03-12 "Sales-Pricing in FCC"** — the strongest attribution in the whole product
    set; this transcript carries reliable speaker labels. **Joe Schacatano at 1:15:04**: *"Freely at
    any point if we wanted to just create a PO in general. So really having it at the quotation…
    Also having the ability to do it within a job again if that was just a scheduled job with no
    quotation."* At **1:15:23**: *"And then third, completely separately if we just need to create a
    PO in general for for the business for a vendor."* At **1:18:47**: *"Yeah, yeah, really. Yeah.
    **Any level** and have the ability to tie it to something… **It's got to have a trail. It's got
    to lead us to a reason of why it's even in there** to begin with, right?"* And at 1:15:x he gives
    the reason: in FCC a PO created before the job *"can get lost in translation because it's not
    tied to anything."*
  - Same recording, **Ryan Adams at 1:16:59**: *"either quote is pending won or lost and **if it's
    lost it closes out the PO**. If it's won it processes the PO to go to the next level… so that way
    we don't get a backlog in our system."* **Joe Schacatano at 1:17:42: *"I agree with that."***
  - `product/sprint-4-additional.md:91` (`conflicts_with: []`, updated **2026-06-22** — three months
    *after* the recording) — *"Every PO must be linked to a job number this is required, not
    optional"*. Note :92 already grants quotation-level POs carrying over, and :102 already grants a
    global PO list, **so the only genuine contradiction is the standalone case.**
  - `SCRUM-518` *PO Implementation on projects and global level* — **Done**, **`description: null`**.
    Its QA comment lists the four creation surfaces actually built — *"1. yards 2. assets 3. projects
    4. main side bar"* — **none of which is the quotation** — and complains at item 16 that the form
    *"is allwoing the creation of empty records"*, i.e. the job link was not enforced.
  - `SCRUM-473` *Add PO to main side navigation* — **Done**. *"PO creation **allows** linking to a
    specific project, job, and vendor"* — permissive, not mandatory. `SCRUM-478`, the parent
    **Purchase Order epic**, is still **To Do** with `description: null`, untouched since 2026-05-25.
  - `product/purchase-order.md` (`conflicts_with: []`) — documents only the **permit-driven** path
    and names **Liz Lopez** and **Jeff Stricker** as the two PO owners. It never mentions the
    quotation level, standalone POs, or the mandatory-job-link rule.
- Note: on the standalone half the vault line is simply **wrong about the built system** —
  `model PurchaseOrder` has `jobId String?` (**nullable**), `poType PoType? @default(GENERAL)`, and
  **no quotation relation at all**. So the recording and the code agree and
  `product/sprint-4-additional.md:91` is the outlier — yet that file carries `conflicts_with: []`,
  so an agent reading it has no signal to doubt it. The rest is state (d): **two named TCG people
  specified three creation levels, a mandatory audit trail, and a quote-lost→PO-closed rule on a
  reliably-labelled transcript, and none of it is written anywhere.** The quotation-level PO and the
  quote-lost rule were **never built and have no ticket** — invisible rather than merely contested.
- Blocked: `SCRUM-478` (epic, To Do, empty); the PO audit-trail requirement; any quotation-level PO
  work; the accounting reconciliation Ryan described.
- Owner: Joe Schacatano (stated the three levels) and Ryan Adams (stated the cancellation rule) —
  sales & quotation. Liz Lopez for how it meets the permit-driven PO path she owns.
- Status: open — needs confirmation

## Customer status values — neither side was built

- Question: what is the customer status value set — `Active / Inactive / Prospect / On hold` as asked
  for on 2026-03-20, or the auto-calculated activity indicator in the vault — and are those even the
  same field?
- Candidates:
  - Recording **2026-03-20 "FCC fields/screens review"**, transcript lines 57–58 (**unattributable —
    no speaker labels in this file**): *"Status or do we need anything other than. I think there's
    three statuses actually in fcc… But there's active, inactive, and prospect. Right."* / *"We
    should put maybe on hold. So. Yeah, active, inactive, prospect, and then on hold."* Fireflies
    summary line 39 confirms the ask.
  - `product/user-story-and-tasks.md:100-108` — *"Customer records display status using colour-coded
    indicators: Green = Active, Yellow = Inactive for 6 months, Red = Inactive for 1 year"*, and
    *"Status is automatically calculated based on latest activity date"*. **This is a personal-space
    draft by Umair Khan (CodingCops)** — see its `provenance_note`; the same person is the Jira
    reporter on `SCRUM-715` and `SCRUM-468`.
  - **Jira: no ticket, ever.** A text search across the project and a full enumeration of the
    Customers epic (`parent = SCRUM-6`, ~90 issues) turn up nothing about the status value set.
- Note: **these are probably not the same field**, and that is the first thing to settle. The vault
  describes an *auto-calculated activity indicator* derived from last-activity date; the recording
  describes a *manually-set lifecycle status* including a commercial state (Prospect) and an
  operational hold. A system can reasonably have both. Two further facts: the built enum is
  `CustomerStatus { DRAFT, ACTIVE, INACTIVE }` — **neither side's proposal**, and its one extra value
  (`DRAFT`) traces to the draft-save punch-list theme, not to this conversation. And the meeting's
  own premise is shaky: the legacy FCC extract (`payroll/legacy-payroll-app-db-extract/data/source-feed.md:170`)
  shows FCC carried `Status` *and separately* `ProspectCode` / `ProspectStatus` — so "prospect" was a
  flag beside the status there, not a status value. **Both sides are unimplemented**, so nothing has
  to be unwound whichever way this goes.
- Blocked: the customer status filter (`SCRUM-191`, Done, ships a filter over the three-value enum);
  any CRM or pipeline work that needs a Prospect state; the unbuilt activity indicator.
- Owner: Melissa McNutt (policy/customer).
- Status: open

## Tasks on customers — reversed on tape, then removed with no artefact

- Question: should the customer record carry Tasks (a per-customer task manager, with CRM built on
  top), or were tasks correctly dropped?
- Candidates:
  - Recording **2026-03-20**, transcript lines 86–94 (**unattributable — no speaker labels**). The
    driver opens by proposing to drop them: *"Notes and tasks there. I think these are not being
    used… Should we not worry about notes and tasks for customers?"* A second voice pushes back:
    *"I mean, it would be nice. **I would keep them.**"* A third: *"because for tasks, like if we
    build it within the system like a **task manager**, if a customer needs certain things."* /
    *"It's like the **CRM will be built on top of this section** then kind of."* The driver closes:
    *"All right, so **we'll keep those**."* A fourth voice notes at line 90 that the mockups *"put the
    tab there, but they didn't actually build anything."*
  - `product/customer-and-job-sites.md:25` — *"Remove tasks from customers"*, in a file updated
    **2026-06-12**, three months *after* the recording said keep them. :26 — *"Notes - do TCG team
    use this feature ?"* — is a **question**, and the recording answers it: yes. Both lines are
    duplicated verbatim into `product/discussion-points-with-tcg-team.md` (see
    `product/customers-INDEX.md` — one document's opinion appearing twice, not two sources agreeing).
  - `SCRUM-198` — **Done**, created 2026-04-27. Its premise is that *"Job Site tabs, Attachments,
    Notes, Certifications, **Tasks** are not available during Customer creation"* and are *"only
    visible and accessible in Edit mode"* — so **a Tasks tab existed on the customer edit screen in
    April**. `SCRUM-52` *Make Notes Section Functional* — **Done**.
  - A search of the whole project for task tickets returns exactly one issue: `SCRUM-198`. **There has
    never been a ticket to build, spec, or remove a customer task manager.**
- Note: notes and tasks diverged and should be answered separately. **Notes survived and were built**
  (`AttachmentFeatureType.CUSTOMER_NOTE`, plus continuous investment through June) — that half is
  settled by the sequence of events and matches the recording. **Tasks did not exist and do not
  exist**: there is no `Task` model anywhere in `apps/api/prisma/schema.prisma` and no task relation
  on `model Customer`. This is the one pair where **not even (b) can be established** — the removal
  left no ticket, no date and no author, so it cannot be attributed or dated at all. It may be that
  nothing was ever removed because nothing was ever built behind the tab, which is exactly what the
  line-90 voice suspected. The "CRM built on top" ambition has no vault or Jira presence of any kind.
- Blocked: any CRM scope discussion; whether the customer detail page should carry a Tasks tab.
- Owner: Melissa McNutt (policy/customer).
- Status: open

## Employee ↔ yard and company cardinality — the ask exists in exactly one place

- Question: may an employee be assigned to **multiple yards and multiple companies** (with a yard
  only selectable within a company the employee belongs to), or is the single default yard correct?
- Candidates:
  - Recording **2026-03-20**, transcript lines 194–197 (**unattributable — no speaker labels**):
    *"We in fcc. We are assigning each employee to like a default company and a default yard. But
    wouldn't we be able to assign them to multiple companies or multiple yards? What do you guys
    think? Like, should this be a drop down with just one?"* → *"I think you should be able to assign
    them to multiple."* → *"Right? Yeah, Multiple yards. Multiple companies. I mean, **obviously a
    yard only if they are for that company**, but multiple. Right. Okay."* **The nesting constraint
    in that last line is dropped by the Fireflies summary** and is part of the requirement.
  - Same recording, lines 157–164, on the Yards screen — the use cases: *"employee count per yard.
    Who's assigned to what yard"*, and a certification consequence attributed in-text to **Melissa**:
    *"if they have a certification that's applicable for California, but if they're also working in
    Arizona, that certification doesn't apply to that yard."* Line 164 attributes the reporting point
    to **Joe**. Both are third-person references (*"like Melissa saying"*, *"that's what Joe was
    saying"*), so they identify who said something earlier, not who is speaking.
  - `SCRUM-468` *Yard Field in Employee Creation* — **Done**, reporter Umair Khan, created
    **2026-05-25** (two months *after* the meeting). Description in full: *"Add a 'Yard' field when
    creating employees. **This will associate employees with a specific yard.**"* Singular. **No AC,
    no requester.**
  - `SCRUM-638` *Employee* (2026-07-08 punch list) item 14 lists **Yard** among single-select
    dropdowns — four months after the meeting, unchallenged.
  - **Vault: nothing.** `product/user-story-and-tasks.md` is the only yard-management source and its
    yard content covers lease documents and a contact list only — employee is not even in its
    `entities:`. `product/yard-operations-jz.md` (`conflicts_with: []`) has one employee line, :19
    *"Employee - unasisgned – weird ghost employees"*, which is a bug report, not cardinality.
- Note: **built: no; ticketed: no; written: nowhere.** `model Employee` carries a single nullable
  `yardId` with no junction table, and — worth stating plainly — **there is no company field on
  `Employee` at all**; the only company-shaped column is `tenantCompanyId`, the multi-tenancy
  discriminator. So "multiple companies" is not merely unbuilt: *single* company assignment was never
  modelled either, and the meeting's premise (FCC assigns a default company **and** a default yard)
  describes a capability the new system **reduced** rather than expanded. Unlike the Tasks pair this
  is not a reversal — it looks like an ask that never reached whoever wrote `SCRUM-468`. It is the
  cleanest contradiction of the 21 and the most expensive to fix later: a junction table plus a data
  migration. Check any answer against
  `decisions/2026-06-30-adp-erp-employee-data-ownership.md`, which assigns the legal employee record
  to ADP but says nothing about yard assignment.
- Blocked: `SCRUM-468` (Done, singular) would need reopening; employee-per-yard reporting; the
  yard-scoped certification validity Melissa raised, which has no ticket at all.
- Owner: Dylan Masterson (yard) with Brian Petros (cross-cutting/IT, for the company dimension);
  Melissa McNutt for the certification-validity consequence.
- Status: open

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
  - `product/project-module/04-create-and-approve-lift-plans.md:47-62` — *"User Story 4: Create a
    Site Plan"*: *"As a **Project Engineer**, I want to create a Site Plan…"*, created from the
    **portal** Plans tab, *"submits the plan for approval"*, *"Plan goes to Pending Approval"*.
    **Different actor, different surface, different timing, and an approval gate Wes explicitly said
    the field form does not need.** (Note the numbering hazard: this "User Story 4" lives in the part
    file numbered `04-`, which is itself "User Story 3" — see `product/project-module/INDEX.md`.)
  - `product/field-ops-frd/08-functional-requirements/fr-fop-011-job-safety-analysis-jsa.md`
    (**FR-TCG-FOP-002 v2.0 DRAFT**) — JSA only. No measurements, no radius, no scope-change logging.
  - **The decisive negative:** a search for *site plan / lift plan / site scope / measurement /
    radius* across **all three** field-ops document sets — `product/field-ops-frd/`,
    `product/frd-new-format-draft/`, `product/atom-mobile-app-user-stories/` — returns **zero hits**.
    A vault-wide search for the phrase returns only this gaps entry and a `purchase-order.md` field
    of the same name.
  - `SCRUM-236` *Create a Site Plan* — **Done**; its description is a verbatim copy of the portal
    user story above. `SCRUM-862` *JSA / Tailboard* — **QA**; a verbatim copy of atom `US-10`. A sweep
    of the entire mobile epic finds **no mobile site-plan or scope-of-work ticket**.
- Note: **this is the most dangerous shape of gap in the set — a name collision where a Done ticket
  looks like coverage.** Anyone grepping "Site Plan" finds `SCRUM-236` and a shipped portal feature
  and concludes the requirement is met. It is a different feature. The mobile form Wes described —
  operator-entered actual measurements, no approval gate, mid-lift change logging, auditable from the
  cab — exists in **no** written source. `product/frd-new-format-draft/08-open-questions.md:19`
  carries the adjacent unanswered question (*"What exact JSA form should be digitized?"*, owner
  Client, Open), which is the JSA, not this. Two named TCG people asked for it three weeks apart and
  nothing was ever written down.
- Blocked: everything about it — there is no requirement to build from. The first move is not a spec
  but Melissa's promised paper forms.
- Owner: Wes Staley (specified it in detail on 2026-03-26) and Melissa McNutt (raised it first, and
  owes the sample forms); Kyle Harlow for the field/ticket consequence.
- Status: open

## Permit expiry reminders — neither 90 nor 30 shipped

- Question: which permit types get an **advance renewal reminder**, and how many days ahead — 90 (as
  asked on 2026-04-09 for annual asset permits) or 30 (as the vault says for job/project permits)?
- Candidates:
  - Recording **2026-04-09 "Dispatch-Scheduling Figma demo"** at 42:19: *"you will get updates saying
    **90 days out**. Hey, this is not going to be good. We need to renew this certificate… that way
    it notifies you for those main ones."* **Attribution unrecoverable** — the surrounding block is a
    room-mic run-on merging the "Brian Petros" label with a second TCG voice; permits are owned by
    Liz Lopez and Lisette Anzaldo, so it is most plausibly one of them.
  - The same recording establishes the **permit population** unambiguously: *"we need to add them to
    assets itself with their expiry dates"* (line 609), *"we'll have to put **all the annual
    permits**… so that it can right away notify us if it's active or not"* (615), *"one is an
    **annual**. Most cranes that are overweight have a permit called a **purple permit, an annual**"*
    (711), *"at the **asset level**… we're gonna put the expiration date"* (875).
  - `product/project-module/05-create-and-track-permits.md:41` — *"Permit expiry alerts are triggered
    30 days in advance"*. Its surrounding flow is **job/project** permits: *"User opens Permits tab
    inside a project"*, *"Views auto-generated Permit Requests from published jobs"*, *"System blocks
    job publishing if permit is missing"*.
  - `SCRUM-372` *Develop Permit Notifications & Expiry Reminder Scheduler* — **Done**, **`description:
    null`**, no AC, no number, no requester. Its parent `SCRUM-237` carries AC 10 byte-identical to
    the vault line. **The only number anywhere in the tree is the parent's 30.**
- Note: **neither number shipped.** The only permit scheduler in the codebase,
  `apps/api/src/usecase/permits/permit-expiry.service.ts`, runs daily and flips permits whose
  `validTill` is already **past** to `INACTIVE` — a deactivation sweep, not a reminder, with no
  advance-days threshold at all. Confirming that:
  `apps/api/src/usecase/notifications/notification-catalog.ts` has **no `permit.*` key**, while it
  does have `cert.expiring_60` and `cert.expiring_30`. So `SCRUM-372` is Done against a null
  description and the feature it names does not exist. **And the two sides may not even be in
  conflict** — annual asset permits and job permits are different populations with different renewal
  economics, so the answer may legitimately be two thresholds. Ask it as two questions.
- Blocked: `SCRUM-372` is Done but the reminder is unbuilt; `SCRUM-790` (permit deactivation cron,
  QA); any permit notification work.
- Owner: Lisette Anzaldo (dispatch/DAS/permits), with Liz Lopez, who owns the permit process in
  `product/purchase-order.md`.
- Status: open

## Jobs panel views — Lisette's stated preference was removed without her

- Question: should the DAS jobs panel keep the **compact chip ("squares") view** alongside the
  detailed list view, or is the list-only view correct?
- Candidates:
  - Recording **2026-04-21 "Dispatch-Scheduling Figma demo"**, `ehtesham.anwar` at 15:24 describing
    both views, then asking at line 522: *"So, **Lisette**, up until then, up until now, what is your
    feedback?"* The reply at 31:13 comes back under the **"Brian Petros"** label — **inferred to be
    Lisette Anzaldo**, a textbook instance of the known mislabelling: *"I like the other view with
    the for the jobs, the one where all the jobs come up **like in squares. I like that layout. I
    feel like it's easier to see everything. I really like the view. I really, really like it.**"*
    And at 32:12, asked what she would change: *"No, I think this is it… still having access on the
    job and being able to **see the crane size, the city** and stuff like that, that totally helps
    me."*
  - `product/daily-allocation-system.md:36` — *"Toggle switches between Compact chip view and
    detailed List view for jobs"*. `conflicts_with: [product/job-project-das.md]`.
  - `product/job-project-das.md:69` — *"Remove card . grid view toggles"*. This is a **cross-module
    punch list** in which DAS is one of nine sections; see §*Feedback punch lists are not scoped to
    the module they are filed under* and `product/daily-allocation-INDEX.md`.
  - `SCRUM-331` *Implement the cards and lists view for jobs* — **Done**, **`description: null`**,
    created 2026-05-07, **last updated 2026-07-17**. `SCRUM-784` *"Remove card . grid view toggles"*
    — **Done**, reporter Umair Khan, created **2026-07-17** (the same day), description *"In DAS, we
    have to remove the grid view for the JOB"*. **Its summary is a verbatim copy of the punch-list
    line, stray period included** — the ticket was minted from the punch list. **No TCG person is
    named on it**; its only comment is CodingCops QA to a CodingCops developer.
- Note: `apps/web/src/features/das/middle-section/jobs/jobs-section.tsx` renders only
  `<JobsListView />` — no view-mode state, no toggle. So the layout Lisette said she *"really,
  really"* liked was removed three months later on the authority of a CodingCops punch list, and
  **nothing records that she was consulted.** This is exactly the reversal-without-attribution the
  2026-08-19 review was opened to find. Note the punch list is attributed in
  `product/customers-INDEX.md` and the DAS stub to "Mohsin feedback" — Mohsin Ali is CodingCops, not
  TCG, so **neither side of this pair carries a TCG decision.** One detail worth preserving whichever
  way it goes: the list view is the one that shows **required crane size** (`ehtesham.anwar` at
  42:17), which is the thing Lisette said helps her.
- Blocked: `SCRUM-784` (Done) may need reverting; the DAS jobs panel layout.
- Owner: Lisette Anzaldo (dispatch/DAS — she stated the preference and is the user of the panel).
- Status: open

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
  - `product/frd-new-format-draft/04-role-responsibility-model.md:17` (**FR-TCG-FOP-001 v1.1
    REVIEWED** — the only reviewed field-ops document) — *"The Oiler owns the main ticket. The
    Operator's labor is captured within the shared ticket but the Operator does not process paperwork
    or collect signatures."* And
    `product/frd-new-format-draft/05-functional-requirements/fr-fop-009-pre-trip-checklist.md`
    (**FR-TCG-FOP-001**, *not* `fr-fop-009` in the other FRD, which is *Leave Yard* — `INDEX.md`
    caveat 3) — *"Oiler completes checklist items for Operator/Oiler setup including crane, tractor,
    trailer, and support loads."* **Both match the recording.**
  - `product/field-ops-frd/05-role-definitions.md` (**FR-TCG-FOP-002 v2.0 DRAFT**) hedges: *"Executing
    assigned tickets"* is listed for **both** roles, and the oiler *"completes the **primary** ticket
    completion workflow"* — "primary" implies a non-primary ticket exists, i.e. the operator has one.
    `product/atom-mobile-app-user-stories/` is **silent** on the question.
  - `product/frd-new-format-draft/08-open-questions.md:27` — open question 11, *"Should Operator have
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
- Status: open

## Requested vs dispatched resources — Melissa stated it, the vault still says the opposite

- Question: is the job's **requested resources** list a frozen client-approved record that dispatch
  cannot edit — with substitutions recorded separately as the **dispatched asset** — or can the
  dispatcher add, update and remove resources on the job itself?
- Candidates:
  - Recording **2026-06-17 "ERP Sprint Review"**. **Melissa McNutt at 59:56** (labelled directly, not
    on the mislabel list, and addressed by name in the preceding turn): *"if we change an asset, **we
    don't re-quote**. So if they call for 90-10 and we send the 275, **we just update the assets in
    the dispatch view and we don't go back and change the quote**."* At **1:00:27**: *"**Lisette
    needs to be able to go in there and change that asset**"* from the dispatch view.
  - Same recording, `ehtesham.anwar` (CodingCops) at 1:00:38 proposing the two-record rule: *"She
    won't be able to change that asset from the jobs resources **because this is the requested
    resources**, and approved by the client. What she can change is once she's dispatching something
    from her own view. And that way **we can retain both of the information**."* **Melissa McNutt at
    1:01:00: *"Okay. Yeah, as long as she can change it on her end, then that's fine."*** — she
    **assented to** the rule; she did not originate it.
  - `product/project-module/02-view-manage-job-details.md:50` (`conflicts_with: []`) — *"Dispatcher
    can add new resources, update existing ones, or remove them"* on the job Resources tab, and :23
    *"Adds, updates, or removes resources as needed"*. **The vault has no requested-vs-dispatched
    concept anywhere.**
  - `SCRUM-580` *Editable Asset in Dispatch View* — **Done**, reporter Umair Khan, created 2026-06-25
    (eight days after the recording). Description: *"Allow Dispatch users to substitute or update the
    assigned asset within the Dispatch View **without modifying the customer-approved requested
    resource on the quotation**… maintain the originally approved requested resource while recording
    the actual dispatched asset."* **It paraphrases Ehtesham's formulation and cites nobody.** Its one
    comment, 2026-07-03: *"moving this to blocked for now **until we have client confirmation on
    this**"* — **and no later comment records that confirmation arriving** before it went Done.
- Note: state (d) compounded by (b). The two-record rule is **built** and **unwritten as product
  intent**: the vault still asserts the opposite at :50 and has never been amended, the ticket names
  no TCG person, and CodingCops' own comment says client confirmation was outstanding. Melissa's
  wording — *"we don't re-quote"* — is the cleanest available statement of the intent and is exactly
  what a one-line confirmation would ratify. Note this is genuinely close to resolved: unlike most of
  the set, a named TCG person did speak to it on a reliably-labelled recording. It needs the
  confirmation, not a re-decision.
- Blocked: `product/project-module/02-view-manage-job-details.md:50` is actively misleading for any
  spec written against it; the job Resources tab; `SCRUM-580` (Done, on unconfirmed intent).
- Owner: Melissa McNutt (stated it), with Lisette Anzaldo (the dispatcher whose edit right it is).
- Status: open — needs confirmation

## Asset on a permit — optional, except where a punch list says compulsory

- Question: is the **asset optional** on a permit — with DAS auto-attaching the asset to that date's
  job when one is present — or is an asset **compulsory** before a travel-permit request can proceed?
- Candidates:
  - Recording **2026-06-18 "Dispatch Permits"**, `ehtesham.anwar` (CodingCops) at 31:13: *"**based on
    our normal conversation, we are going to remove assets by default and then later on have it
    optional.** So, for example, if it is optional, then on the Dispatch and DAS allocation screen,
    **if for a permit we have added an asset, then we will automatically attach this asset to the job
    of that date**… Just wanted to show you this process, **Liz**."* And at 36:49: *"they're
    automatically attached to the job on that particular date. You won't have to attach it again and
    again."*
  - **Critically, there is no recorded answer.** The turns immediately following are the "Brian
    Petros" label saying *"For my system, and."* and *"That's like a remake of the Excel sheet."*
    Ehtesham says *"just wanted to confirm something"* and cites *"our normal conversation"* — an
    off-record prior discussion. **Liz Lopez is addressed by name and is not recorded replying. No
    TCG person assents on tape.**
  - `product/project-module/05-create-and-track-permits.md` — :22 and :34 list **asset** as a permit
    form field with no optionality marker; :38 *"Active permits automatically link to job dispatch"*.
  - **CONTRADICTING** — `product/job-project-das.md:54`: *"auto create travel permit request based on
    assets required – before navigtaing to next step, **add asset is compulsory**"* (typo verbatim).
    This is the same cross-module punch list flagged in §*Feedback punch lists are not scoped to the
    module they are filed under* — Permit is one of its nine sections.
  - `SCRUM-517` (Done, created **2026-06-08**, ten days *before* the recording) put permits on the
    **Asset Detail page's Permits tab**, where the asset is implicit from context rather than a form
    field. `SCRUM-533` (Done) is a carry-over of slipped `SCRUM-517` items and says nothing about
    optionality. `SCRUM-625` *Automatically Attach Permits to Jobs* (Done, 2026-07-01) shipped the
    second half of Ehtesham's statement: *"Permits are automatically attached to the related Job on
    the applicable date entered on the Permit"* — **it does not mention the asset**.
  - `SCRUM-788` — **Done 2026-07-27**, summary a verbatim copy of the punch-list line above (typo
    included), description *"Right now, No travel permit is required, we should generate the request
    for assets"*. **None of the four tickets names a requester.**
- Note: the optional asset **is what shipped** — `model Permit` has `assetId String?` and
  `create-permit.dto.ts` declares `assetId?: string` — and the auto-attach shipped too
  (`JobAssetPermitAssignment`, a full `job-permit-assignments` module, and a `permitLinked` prop on
  the DAS asset card). So (b) covers the recording's claim. **What is unreconciled is `SCRUM-788`**,
  Done a month later and pushing the opposite way. These may be two different objects — a *permit
  record*, which can stand alone as an annual, versus a *permit request generated from a job's
  required assets*, where naming the asset is the whole point — but **nothing written says so**, and
  a one-line ticket description cannot settle it. Answer that distinction first; the optionality
  question probably dissolves once it is named.
- Blocked: `SCRUM-788` (Done) vs the shipped optional `assetId`; the travel-permit request flow in
  DAS; `product/project-module/05-create-and-track-permits.md`, which describes neither behaviour.
- Owner: Lisette Anzaldo (dispatch/DAS/permits), with Liz Lopez — she was the person addressed on the
  recording and never recorded answering.
- Status: open

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
  - `product/atom-mobile-app-user-stories/06-safety-and-self-service.md:34-50` — US-21 lists 911,
    Safety contact, Crane Superintendent contact, nearest-hospital display, call and navigate.
    **No Dispatch, no broadcast.** The file was **re-migrated 2026-08-13 (Confluence v10), nearly two
    months after the meeting** — the omission survived a refresh.
  - `product/frd-new-format-draft/05-functional-requirements/fr-fop-037-emergency-contacts.md`
    (**FR-TCG-FOP-001**) — *"Provide emergency contact list including **Dispatch, Maintenance, Yard,
    and Office**"*. **The exact inverse of US-21**: it has Dispatch and Office and omits 911, Safety
    Officer, Crane Superintendent and hospital.
  - **FR-TCG-FOP-002 v2.0 DRAFT has no SOS or emergency-assistance requirement at all** — a search
    across `product/field-ops-frd/` returns nothing; its `fr-fop-026-escalation-handling.md` is
    deficiency escalation, a different thing.
  - `product/frd-new-format-draft/08-open-questions.md:24` — open question 8, *"What emergency
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
- Status: open — needs confirmation

## Schedule fields — the build already agrees, and the new fields are written nowhere

- Question: are **sales coordinator, salesperson, job location, scheduled hours** and the job statuses
  **Scheduled / Tentative / Hold / Cancelled / Maintenance** required on the schedule — and with
  in-maintenance cranes already non-selectable, should the double-booking warning still fire for
  non-overlapping same-day reuse?
- Candidates:
  - Recording **2026-08-11 "Sales Process"** at 14:01 and 15:04, labelled **Brian Petros**: *"This
    would be the sales coordinator. This would be the salesperson. Job location."* / *"Scheduled,
    saved, tentative, hold, canceled, or maintenance. **So if a crane was in maintenance, we wouldn't
    even be able to pick it.**… This would allow us the **scheduled hours**. So **if it was a short
    job, we may be able to do 2 jobs in one day with the same crane**."* At 15:23: *"So we know we
    could **double book**."* ("saved" is almost certainly a mis-transcription; the 08-12 minute records
    the list without it.)
  - **Attribution conflict, unresolved.** The transcript labels this **Brian Petros**; the pair row in
    the combined entry above says *"Ryan wants non-selectable"*. Ryan Adams is on the mislabelled set.
    **One of the two is wrong and the recording cannot settle it** — worth asking alongside the
    substance.
  - `meetings/2026-08-12-sell-side-workflow-and-scheduling.md:37-40` — a **forward-looking** client
    minute (caveat 5 does not apply), recording both the field list and *"The system should prevent
    selection of cranes under maintenance and support double booking"*. **But its Action items table
    has four rows and none of them is this rule** — it is recorded as a discussion point with **no
    owner and no action item**. The minute's own analysis at :79-82 already says *"Neither source
    covers either rule."*
  - `product/daily-allocation-system.md:47` — *"unavailable ones are greyed out but still drag-gable
    with a system warning"*; :48 — *"Assignment is time-based (shift start/end), so the same asset can
    be assigned to two non-overlapping jobs on the same day"*; :80, :82 — maintenance tag and three
    chip states. `product/project-module/03-create-manage-job-schedule.md:43` — a warning on
    same-time, same-date double assignment.
  - `SCRUM-502` *Asset Availability & Maintenance Status* — **Done**, created **2026-06-03**,
    AC 2: an asset marked maintenance *"stays visible but **cannot be assigned to a job**"*.
    `SCRUM-234` *Create & Manage Job Schedule* — **Done**, AC 10 matching the vault's warning line.
    **Neither names a requester.**
- Note: **the client was ratifying existing behaviour, not requesting a change.** `SCRUM-502` shipped
  the block on 2026-06-15, two months before the 08-11 recording, and the code agrees:
  `apps/web/src/features/das/left-section/components/asset-card.tsx` passes `disabled: isInactive` to
  the drag hook for `UNDER_MAINTENANCE` assets and short-circuits the click handler. So
  `product/daily-allocation-system.md:47` is simply **stale** — a 2026-04-30 statement superseded in
  June — and it carries no marker warning a reader, which matters because
  `product/daily-allocation-INDEX.md` calls that file *"the only DAS specification"*. On
  double-booking the recording and :48 already **agree**. What is genuinely unwritten: **scheduled
  hours, sales coordinator, and the Tentative / Hold / Maintenance job statuses appear in no vault
  spec and no ticket**, and nothing says whether the :43 warning should still fire once maintenance
  is hard-blocked. Also relevant: §*Sell-side scheduling artefacts — no vault coverage*, which
  already names an owner for this area.
- Blocked: the job status enum; the schedule form fields; whether `product/daily-allocation-system.md:47`
  should be corrected (a body edit — not `tcg-scrum`'s to make).
- Owner: Brian Petros (labelled speaker, and already named as owner of the sell-side workflow source
  files), with Ryan Adams to resolve the attribution; Lisette Anzaldo for the DAS consequence.
- Status: open

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
  - `product/frd-new-format-draft/05-functional-requirements/fr-fop-018-signature-quality-fraud-prevention.md`
    (**FR-TCG-FOP-001 v1.1**) — *"Photo capture is now a **configurable deployment toggle**… Photo
    capture can be enabled or disabled per deployment configuration."*
  - `product/field-ops-frd/08-functional-requirements/fr-fop-018-customer-signatures.md`
    (**FR-TCG-FOP-002 v2.0** — same id, different requirement; `INDEX.md` caveat 3) — *"shall support
    **configurable** photo capture during signature workflows"*. **Both FRDs say configurable.**
  - **CONTRADICTING** — `product/atom-mobile-app-user-stories/02-ticket-assignment-and-pre-trip.md:136`:
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
- Status: open — needs confirmation


# Gaps

Open questions raised by the Confluence migration of 2026-08-10 and by everything since.
Each product entry is a conflict the migration deliberately did not resolve. Agents must not
pick a winner from these sets — surface the conflict and cite all candidates.

**Two registers, one format.** Product and process gaps live here. **Payroll and ADP gaps
live in [`payroll/gaps.md`](payroll/gaps.md)** — same entry shape, same rules, split out
because that register is three times this size and belongs to a separate source set. Append a
payroll or ADP question there, not here.

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

## Scope of the Plan Comments page in SCRUM-757

- Question: Which screen is "the Plan Comments page" — the comment surface on the plan
  detail view, the project In-House Comments tab, or a third screen?
- Candidates: none in the vault. `product/project-module/04-create-and-approve-lift-plans.md`
  (3.5 KB, updated 2026-04-30) specifies a Plans tab and an approve / request-changes-with-comments
  workflow but describes no comments page. `product/job-project-das.md` (1.7 KB, 2026-07-16)
  records `Plan — rich text field - UI issue` and `Project — in house comments – design update
  needed` without detail. A vault-wide grep for `comment` returns 40 hits, all field-ops
  ticket-workflow or quotation content. `SCRUM-757` names the page and identifies nothing.
- Note: the repo has two plausible surfaces —
  `apps/web/src/features/plans/components/plan-view-sidebar.tsx` (an Add Comment action, with
  comments rendered in a Recent Activity card) and
  `apps/web/src/features/projects/components/project-detail-comments-tab.tsx` (In-House
  Comments, against which `SCRUM-763` is open and Blocked). Neither is named "Plan Comments",
  and the code cannot say which the reporter was looking at. `SCRUM-757` links a Loom
  recording and a Google Drive file that would settle this immediately; they were not opened
  during elaboration on 2026-08-11.
- Blocked: `SCRUM-757` REQ-01, and through it every other requirement in
  `.ai/aidlc/SCRUM-757/spec.md` — none can be scoped, reproduced or accepted against an
  unidentified screen.
- Owner: product team — in practice Aiman Farooq (reporter of `SCRUM-757`), or anyone who can
  open the ticket's attachments.
- Answer: the **plan detail view** at `/projects/{id}/plans/{id}` — the first of the two
  candidates. Not the project In-House Comments tab, so `SCRUM-763` is a separate concern
  against a different screen. Confirmed against the route
  `apps/web/src/app/(protected)/projects/[id]/plans/[planId]/page.tsx`, which renders
  `PlanViewPageContent` and `AddCommentModal`. Answered by the assignee rather than the
  reporter, and from knowledge of the screen rather than from the attachments — which are
  still unopened and are still the fastest way to settle Q3.
- Status: resolved — see `decisions/2026-08-12-plan-comments-page-scope.md`

## Plan comment performance target

- Question: What is the acceptance threshold for the Plan Comments page being "responsive" —
  a page-load budget, an input-latency budget, or both — and at what comment count and
  comment length must it hold?
- Candidates: none. The only Performance requirement anywhere in the vault is
  `product/frd-new-format-draft/07-non-functional-requirements.md` ("Ticket screens, checklist
  rendering, and signature capture must load within acceptable response times under field
  network conditions") — scoped to the field-ops **mobile** app, stating no number, and inside
  the unresolved field-ops conflict set. `product/customer.md` ("Tooltips are very slow") and
  `product/quotation.md` ("Auto api call on page refresh") are different modules and set no
  target. No `.ai/claude/rules/*.md` file and no `CLAUDE.md` section sets a web performance
  budget.
- Note: `README.md` → *What this vault does not contain* does not list non-functional
  requirements among the deliberate exclusions, so this is an absence, not policy. Without a
  number, "fixed" is whoever last looked at it deciding it feels fine, which is how the ticket
  reopens. A profiling pass that measures current behaviour is not blocked by this question and
  would give the answerer real numbers to set a threshold against.
- Blocked: `SCRUM-757` REQ-03, and the sign-off of REQ-02.
- Owner: product team
- Status: open

## Source of the 400 and 401 responses on the plan page

- Question: Which specific requests return 400 on the page in `SCRUM-757`, which requests did
  the reporter see repeated (with counts, and against which build), and are the observed 401s
  the designed access-token-expiry → refresh → retry cycle or calls that should not be issued?
- Candidates: none. `SCRUM-757` states both symptoms and names no endpoint, no payload and no
  count. No vault file discusses API error responses on any web page. The evidence exists only
  in the ticket's two attachments (Loom, Google Drive), not opened during elaboration.
- Note: `CLAUDE.md` → Auth System documents a 15-minute access token, and
  `apps/web/src/lib/base-api.ts:92` implements a silent-refresh interceptor that turns a 401
  into `POST /auth/refresh` plus one rate-limited retry. That establishes the system produces
  401s **by design**; it does not establish that the ticket's 401s are those. The direction of
  risk matters here — if they are the designed cycle, "fixing" them means weakening the auth
  flow to clean up a console. Separately, the global TanStack Query defaults already set
  `refetchOnWindowFocus: false` with a non-zero `staleTime`
  (`apps/web/src/providers/query-provider.tsx`), and some plan-adjacent hooks take a
  deliberate `refetchInterval`, so which observed repeats are duplicates and which are designed
  is part of the same unknown.
- Blocked: `SCRUM-757` REQ-05 and REQ-06, and the acceptance criterion of REQ-04.
- Owner: product team — the 400/repeat identification sits with Aiman Farooq (reporter); the
  expected-vs-defect call on the 401s sits with whoever owns the auth flow.
- Status: open

## Plan comment volume, length and pagination

- Question: How many comments must a plan's comment page hold while staying responsive, is
  there a maximum length for a single comment, and should the list paginate, virtualize or
  load in full?
- Candidates: none. `product/project-module/04-create-and-approve-lift-plans.md` (3.5 KB,
  2026-04-30) is the closest thing to a plan specification and is silent on all three.
  `SCRUM-757`, `SCRUM-763` and `SCRUM-211` state no limit or list behaviour.
- Note: pagination, virtualization and a length cap are three different features with three
  different data models behind them, so choosing one in code decides the product question
  without asking it — including a max-length validator added "for safety", which would be
  enforced on users who were never told about it. Relevant current state: there is no
  `PlanComment` model; plan comments are appended as **project activity-log entries**
  (`apps/api/src/presentation/plans/plans.controller.ts:137-146`), so a plan's comment list may
  grow with the whole project's activity. Whether that is the intended home for plan comments
  is itself unstated.
- Blocked: `SCRUM-757` REQ-07, the shape of any fix for REQ-02, and the schema/migration
  question in §3 of `.ai/aidlc/SCRUM-757/spec.md`.
- Owner: product team
- Status: open

---

# Gaps from the meeting minutes of 2026-08-05 / 07 / 12

Raised by three sets of client meeting minutes supplied on 2026-08-13. These differ from every
other entry here: they are not conflicts between documents but **named, owed deliverables** and
**modules with no vault coverage at all**. The ADP and payroll items from the same minutes are in
[`payroll/gaps.md`](payroll/gaps.md).

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
- Blocked: nothing yet — each pair blocks the unit that touches it.
- Owner: `tcg-scrum` to put each pair to the named TCG person; the answer goes to `decisions/`.
- Status: open

# Gaps

Open questions raised by the Confluence migration of 2026-08-10. Each entry is a
conflict the migration deliberately did not resolve. Agents must not pick a winner
from these sets — surface the conflict and cite all candidates.

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

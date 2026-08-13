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

---

# Payroll gaps

Raised by the OneDrive payroll migration of 2026-08-13. Unlike the entries above, these are
**not** conflicts between competing documents — the payroll sources agree with each other. They
are questions the source documents themselves mark as unanswered, and in most cases name the
person or function who has to answer them.

## Payroll rule applicability by Payroll Group

- Question: which payroll rules apply to which of the five Payroll Groups?
- Candidates: none — this is unanswered, not contested.
- Note: **this is the single largest open area in payroll, and both independent sources say so.**
  The legacy Payroll App grew from an L12 union baseline, so its current behaviour reflects
  "what was built first", not a decision. `payroll/payroll-app-current-state/08-known-issues-and-next-decisions.md`
  names it "the highest priority next design area"; `payroll/erp-payroll-module-frd/11-security-decisions-and-acceptance.md`
  lists eight of its 24 required decisions under it. Specifically unresolved: which L12 rules
  apply to **mechanics** (the applicability matrix says "Confirm" on eleven separate rows); the
  final **non-union hourly** overtime matrix; whether **non-union salary** rows should be
  payroll-calculated, audit-only, or excluded entirely; whether WTL tokens should be required
  only for L12 union rows; and whether subsistence applicability varies by group.
  **Do not infer the answer from what the legacy system does — that is the thing being questioned.**
- Blocked: any payroll rule implementation that is not L12-Field-only.
- Owner: TCG management, payroll leadership, and labor counsel — named as such in both documents.
- Status: open

## The 24 decisions required before the payroll rule catalog is final

- Question: the ERP requirements document's section 25 list, in full.
- Candidates: none.
- Note: reproduced in `payroll/erp-payroll-module-frd/11-security-decisions-and-acceptance.md`.
  Beyond the payroll-group questions above, they include: the **half-hour rounding method**;
  **source priority** between labor times and job-ticket times; **cross-midnight day-type
  policy**; whether a **Sunday minimum** applies; the exact **reporting-time and
  crane-remains-on-job decision tree**; **long-boom and lattice-boom** source-data requirements;
  the **higher-rate-for-the-entire-day** interpretation; **worked-meal calculation for weekdays
  vs weekends and holidays**; replacing **WTL comment tokens with structured meal records**;
  **subsistence distance calculation** and the employer-election workflow; the **apprentice-hour
  accumulation source**; **fringe-benefit treatment per paid component**; **which errors block
  payroll approval**; **who may reopen a processed period**; and the **record-retention period**.
- Note also: the document is **Draft 0.1** and states it "should not be interpreted as final
  legal advice". The rule matrix carries a per-rule "Confirmation / Open Decision" column that is
  populated for all 68 rules, and leaves all ten implementation-tracking columns blank.
- Blocked: treating any payroll rule as specified.
- Owner: TCG management, payroll team, labor counsel, union representatives.
- Status: open

## ADP export mapping — 9 open decisions, 6 blocking

- Question: which ADP codes, tax treatments and import methods do the new pay components use?
- Candidates: none.
- Note: enumerated as D-001…D-009 in `payroll/adp-bucket-crosswalk.md`, which marks six of them
  **"Blocks CodingCops: Yes"**. The blocking six: a complete live **ADP validation-table export**
  (D-001); codes for **guaranteed hours** ST/OT/DT (D-002); a code for the **rest-period premium**
  (D-003); a code for the **WTL/missed-meal premium** (D-004); a dedicated **Special Saturday**
  code (D-005); confirmation that **HDD means Holiday Double and HOL means Holiday Triple** in the
  live ADP setup (D-006); plus accumulator/hours-flag settings for every new code (D-009).
- Note also: an identifier collision that is not yet a decision but will bite — the current
  paydata workbook uses **ADP Co Code 4RZ** while the validation-table export in the same drop is
  stamped **Company Code 631**. The crosswalk instructs treating them as different identifiers
  until ADP confirms. The 631 export is also **incomplete**: it lacks the lattice premiums, the
  shift differentials and `LBT`, all of which the crosswalk marks CURRENT - implemented.
- Blocked: the ADP export rule (`PR-067` in the rule matrix, `PR-055` in the requirements
  document — see the id warning).
- Owner: payroll manager, ADP administrator, HR/accounting depending on the decision.
- Status: open

## Union agreement — three source PDFs are unreadable scans

- Question: not a product question — a retrieval gap worth recording.
- Note: three of the five full copies of the Local 12 Master Labor Agreement in the source drop
  are **scanned images with no text layer**. `pdftotext` returns zero characters. They are
  `MCOG-O. E. Local 12 Truck Crane Master Labor Agreement 2025-2028.pdf` (3.4 MB),
  `07.01.2025 truck crane MLA (1).pdf` (2.6 MB), and `OE-Local-12-MLA-25-28-Comp.pdf` (2.4 MB).
  The payroll-relevant articles are available via the extract in
  `payroll/mcog-l12-mla-2025-2028/`, so this blocks nothing today — but **any question that
  reaches outside the payroll articles cannot currently be answered from the vault**, and would
  need OCR or the SCCA-hosted copy.
- Note also: the workbook that cites the SCCA copy warns its own text extraction "may [contain]
  some minor (but important) errors when converting".
- Blocked: nothing today.
- Owner: whoever next needs a non-payroll article of the agreement.
- Status: open

## Field-ops lunch capture vs payroll WTL

- Question: the mobile app captures lunch events and the payroll module prices them, but the two
  document sets were written independently and disagree. Which side is right on each point, and
  who owns the reconciliation?
- Candidates: not a choice between documents — a seam between two modules, both specified,
  neither citing the other.
  - Capture side: `product/brs.md` (BRS-LUNCH-001…005, BRS-PAY-003), plus `FR-FOP-013`
    Lunch Monitoring / Lunch Timer and Alerts, `FR-FOP-014` Lunch Recording, `FR-FOP-015` Work
    Through Lunch, `FR-FOP-023` Labor Details. **The `FR-FOP-NNN` ids are themselves ambiguous
    across the two field-ops FRDs** — see *Field operations mobile app* above.
  - Pricing side: `payroll/wtl-charts.md`, `payroll/mcog-l12-mla-2025-2028/01-article-iii-working-rules.md`
    (Meal Periods, Rest Periods), `payroll/payroll-app-current-state/03-payroll-rule-catalog.md`
    (`WTL_MEAL_DEDUCT`, `WTL_DT_FLOOR`, `WTL_APPLICABLE_ADD`, `REST_PERIOD_PREMIUM`).
- **Updated 2026-08-13 after the Confluence drift re-migration.** The Atom user-stories page
  (Confluence v10, updated 2026-08-11) now states lunch thresholds explicitly for the first time,
  which turns a silence into a **numeric contradiction**:

  | Lunch | Atom mobile app (v10) | Payroll WTL charts (rev. 2026-01-23) | |
  | --- | --- | --- | --- |
  | 1 | before **5** hours | marker at **5:01** | consistent |
  | 2 | before **10.5** hours | marker at **10.5:01** | consistent |
  | 3 | before **16.5** hours | marker at **16:01** | **disagree by 0.5 h** |
  | 4 | before **22** hours | marker at **21.5:01** | **disagree by 0.5 h** |

  The payroll charts cite the L12 Master Labor Agreement, page 26 section F, and were revised by
  Danny Bryan and Mike Vlaming. The Atom page is a CodingCops-authored user story with no cited
  source. **A missed third or fourth meal is a double-time penalty, so this is a money
  difference.** An alert fired on the wrong threshold causes the penalty it exists to prevent.
  Neither value should be implemented until reconciled.

- Three further discrepancies:
  1. **How many lunch thresholds exist.** `BRS-LUNCH-002` lists **three** (First, Second, Third)
     and is marked **✓ Confirmed**. The payroll charts define **four**, and the Atom page (v10)
     now also defines **four** (Lunch 1–4). Two independent sources say four; the ✓ Confirmed BRS
     rule says three. **The BRS is now the outlier** and is most likely simply stale.
  2. **Lunch threshold values.** `BRS-LUNCH-005` is marked **📄 Needs Supporting Documentation**.
     The payroll drop supplies exactly that documentation — but it arrived four months later from
     a different source, and a payroll chart is not the same thing as a validated business rule.
     The charts are also hand-built and contain arithmetic that does not always reconcile (noted
     in `payroll/wtl-charts.md`).
  3. **Previous-day rest.** `BRS-PAY-003` is marked **⚠ Needs Client Validation** and mentions
     "eight-hour rest periods, double-time implications". This is contract text in MLA Article III
     and is already implemented (`app.usp_Apply_RestPeriod_Premium`, punitive until 8 hours rest
     is received). The validation the BRS asks for may already exist in a form nobody connected.
- Partially closed 2026-08-13: `BRS-LUNCH-003` (*Lunch Notification Timing*, ⚠ Needs Client
  Validation) now has a candidate answer — the Atom page v10 specifies a notification **1 hour
  before** each lunch is due. Nothing states that this page constitutes the client validation the
  BRS asked for, so the status is not changed here.
- Note: there is also a **silence**, not a disagreement. The payroll module's anchor-date rule —
  a cross-midnight labor entry belongs to its *start* date — is stated only in
  `payroll/payroll-concepts-shift-job-labor-entry.md`. **No field-ops requirement states it.**
  So whether the capture side assigns cross-midnight entries the same way is unspecified, and the
  ERP requirements document separately lists cross-midnight day-type policy among its 24 open
  decisions. Getting this wrong puts hours in the wrong pay period, at the wrong multiplier.
- Note also: this seam is why `payroll/` is not simply a sibling of `product/`. Payroll consumes
  field-ops output. A change to lunch capture is a payroll change.
- Blocked: nothing today — no ticket has reached the WTL/meal rule. It will block the first one
  that does, and it will block any field-ops work that changes lunch capture.
- Owner: product team to reconcile the BRS against the payroll sources; the three-vs-four
  threshold count needs a payroll-team or union answer, not a product decision.
- Status: open

---

# Gaps from the meeting minutes of 2026-08-05 / 07 / 12

Raised by three sets of client meeting minutes supplied on 2026-08-13. These differ from every
other entry here: they are not conflicts between documents but **named, owed deliverables** and
**modules with no vault coverage at all**.

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

## ADP codes — TCG owes an updated export

- Question: what are the ~16 new ADP payroll codes, and which existing codes changed?
- Candidates: none. [payroll/adp-hour-earning-codes.md](payroll/adp-hour-earning-codes.md) is a
  24-code export dated 2026-06-04, already known to be missing the lattice and shift-differential
  codes the crosswalk marks as implemented.
- Note: this is the **same request** as crosswalk decision **D-001**, which is marked
  *Blocks CodingCops: Yes*. The 5 August meeting turned it into a named action item on the TCG
  team. It is one gap, recorded in two places, and closing it closes both.
- Blocked: the ADP export rule and any earning-code mapping work.
- Owner: TCG team (payroll / ADP administrator).
- Status: open

## Payroll calculation logic — Brian owes a revised version

- Question: has the payroll calculation logic changed since the documents in `payroll/`?
- Candidates: the vault holds the 2026-08-05 rule matrix and the 2026-06-23 rule catalog. Brian
  (TCG) undertook on 2026-08-05 to share **revised** calculation logic, plus comprehensive
  documentation of all payroll rules, plus Corrina's Value Engineering / Payroll Workflow
  documentation. **None has arrived.**
- Note: until it does, the migrated payroll documents stand as written. **Do not assume a rule has
  changed because a revision was promised.** When it arrives it may supersede parts of
  [payroll/codingcops-rule-matrix.md](payroll/codingcops-rule-matrix.md) — treat that as a
  re-migration, not an edit.
- Blocked: nothing yet; it will block rule implementation that the revision touches.
- Owner: Brian Petros (TCG); Corrina (TCG) for the Value Engineering workflow.
- Status: open

## Lattice Crane identification

- Question: can Lattice Crane work be identified automatically, or must it be entered manually?
- Candidates: today it is **manual** — the ADP crosswalk drives `LPR/LPO/LPD/LPT` and
  `LOR/LOO/LOD/LOT` from `LATT_OPER` and `LATT_OILER` comment tokens.
- Note: Brian raised on 2026-08-05 that this needs discussion with business stakeholders (Kyle and
  Joe) to determine whether automatic identification is possible. Related but not identical:
  `PR-044` *Lattice-boom premium* in the rule matrix is marked **New ERP requirement**, with
  "Confirm interaction with long boom" outstanding.
- Blocked: `PR-044`, and the lattice earning-code mappings.
- Owner: Kyle and Joe (TCG business stakeholders), via Brian.
- Status: open

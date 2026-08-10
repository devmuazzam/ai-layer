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
- Status: open

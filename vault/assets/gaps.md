---
title: Assets — open questions
status: reference
kind: gaps
updated: 2026-10-06
tags: [module/assets, kind/gaps, open-questions]
---

# Assets — open questions

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

*No entries yet. Pre-2026-08-20 questions remain in the retired registers
([gaps.md](../gaps.md)); disposition into module files is phase 3.*

## One In Use rule or two — the yard panel and the tool detail page disagree

- **Status:** open
- **Asked:** 2026-08-25 — SCRUM-900 close-ticket (platform PR #394). The named follow-up in
  [2026-08-24-tool-in-use-after-completion.md](../decisions/2026-08-24-tool-in-use-after-completion.md)
  Q2:C — *"converge on one server-side utilization computation both surfaces consume (do not
  silently leave permanent duplication)"* — which until now existed only inside that decision's
  prose, so the `gaps.md` sweep could not surface it. **Not a ticket question:** SCRUM-900 is
  closed and Q2:C put the convergence explicitly outside its scope.
- **Question:** two screens now compute a tool's **In Use** from different rules. Which rule is
  the product rule — the yard panel's client-side release (partial mid-day remaining quantity,
  plus release when the schedule date passed and loadout never started), or the detail page's
  server-side closed-day full exclusion with historical past dates? And **which ticket, with
  which owner, does the rewiring** once that is settled — is the shared computation a follow-up
  ticket under the `SCRUM-454` epic, or does it wait for a surface to be rebuilt?
- **Sources checked:** [tool-and-rigging.md](tool-and-rigging.md) (`status: unverified`) Story 5
  *Dylan's Yard Dashboard* — :102 *"Each tool displays live status counters Total, In use and
  available"* and :104 *"At end of day Dylan can mark each piece of equipment as returned to yard
  or still on site"*. **That is the only vault language on In Use, and it defines neither release
  granularity nor partial quantities, and says nothing about the tool detail page at all.**
  [user-story-and-tasks.md](user-story-and-tasks.md) — yard management only, no utilization
  counters. `../decisions/` — the 2026-08-24 note above settles the detail page (Q1:B, Q2:C,
  Q3:B) and its *What this does not settle* section names both the rewiring and the partial-qty
  parity as open; [2026-08-20-job-completed-on-last-day-offload.md](../decisions/2026-08-20-job-completed-on-last-day-offload.md)
  settles day-level completion but not utilization display. Jira: `SCRUM-453` / `SCRUM-457`
  (tool detail + Dylan live In Use, both Done) — no ticket owns convergence.
- **Note:** the divergence is now three rules wide, not one, and all three are in shipped code.
  Yard panel — `apps/web/src/features/dylen-dashboard/utils/resolve-job-tool-in-use-quantity.ts`:
  releases the **remaining not-offloaded quantity** per loadout row (partial mid-day release),
  and `isJobDatePassedWithoutStart` releases a tool entirely when the schedule date has passed and
  loadout was never started. Detail page —
  `apps/api/src/service/asset-management/tools/tools.repository.ts` `findUtilizationByDateRange`
  (SCRUM-900): **full** exclusion of an assignment when its schedule day is closed
  (`closedStages` = COMPLETED / TICKET_SUBMITTED / CANCELLED, or loadout offload / force-complete
  / `phase` COMPLETED), applied **only to today-and-future rows** (`date >= startOfTodayUtc`);
  past-date rows accumulate unconditionally, and there is no partial-quantity math and no
  never-started release. So the same tool on the same day can read a different In Use on the two
  screens, and neither number is wrong against any written source — because no written source
  says which one is In Use. Converging is a product call before it is a refactor: adopting the
  API rule silently drops Dylan's partial release, adopting the client rule changes what the
  detail page's historical dates mean.
- **Blocked:** the convergence itself (no ticket exists); any future ticket that assumes one
  definition of In Use across both surfaces; `spec.md` §12 Q4 on SCRUM-900 (whether replaced tool
  assignments count as in use) bears on the same query and would be cheaper to answer once.
- **Owner:** **needs assignment — no one owns this today.** Fouzan Shakil is the obvious person
  to route it to (he is the SCRUM-900 assignee and wrote the follow-up sentence), but nothing on
  record says he owns the convergence, and the rule question is a product call rather than his to
  make by default.

## Per-Day Utilization on the Tools & Rigging listing — day-vs-range, and the default date

- **Status:** open
- **Asked:** 2026-08-25 — SCRUM-908 close-ticket (platform PR #399). Path C (no spec.md
  folder), so this question has no ticket §12 to live in; it belongs here per
  [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*.
- **Question:** does "Per-Day Utilization" mean one selected day at a time (the date-range
  picker removed, defaulting to today), or should the range picker have stayed with a
  per-day breakdown across it? And is today the intended default date, or should it default
  to the last selected day?
- **Sources checked:** `SCRUM-908` Jira — summary only, verbatim: *"change the listing from
  'Today's Utilization' to 'Per-Day Utilization' to display daily utilization"*; description
  `null`, zero comments, zero linked issues. [tool-and-rigging.md](tool-and-rigging.md)
  (`status: unverified`) Story 5 *Dylan's Yard Dashboard* — the only vault language on
  utilization, and it covers the yard dashboard's live counters, not this listing page or a
  date control. [user-story-and-tasks.md](user-story-and-tasks.md) — no utilization.
  `../decisions/` — [2026-08-24-tool-in-use-after-completion.md](../decisions/2026-08-24-tool-in-use-after-completion.md)
  settles the In Use *rule* (Q1:B, Q3:B), which this listing already inherits because both
  the listing and detail endpoints resolve to the same
  `ToolsRepository.findUtilizationByDateRange` — that part is not in question. It says
  nothing about the date *control's* shape or default.
- **Note:** the shipped default (today) is behaviour-preserving — the prior range control
  also defaulted to today→today — so this is a confirm-after-merge, not something blocking
  what shipped. Reviewed in the PR review for `scrum-908` → main (2026-08-25); `tcg-scrum`
  confirmed unsourced at that time and could not find a decision either.
- **Blocked:** any future claim that single-day-defaulting-to-today is settled product
  behaviour for tool utilization date controls.
- **Owner:** needs assignment — route to Fouzan Shakil (SCRUM-908 assignee) to confirm.

## Customer-owned assets — what they are, and whether the ERP tracks them

- **Status:** open
- **Asked:** 2026-08-27 — Brian Petros, written message to the TCG team, 2026-08-27 ("A couple things that came up in my discussion with CodingCops today, that we'll discuss in future meetings"), following the 2026-08-26 ERP sprint review — logged in [payroll/client-message-findings.md](../payroll/client-message-findings.md#cross-module--2026-08-27-follow-ups-after-the-fcc-migration-first-pass-brian-petros)
- **Question:** Brian lists "ask owners about *customer-owned assets*" as a follow-up. The term
  appears nowhere in the vault. Does TCG operate, maintain or dispatch equipment it does not own
  (customer cranes on customer sites?), and if so is that an asset record with an owner attribute,
  a separate entity, or out of scope? Nothing in `asset-management` models ownership.
- **Candidates:** the annotated migration brief, [meetings/2026-08-26-fcc-migration-client-brief.md](../meetings/2026-08-26-fcc-migration-client-brief.md): FCC `FMS_CUSTOMER_UNITS` holds **12 rows**, extracted but with no TCG module ("Need to scope this functionality"); the FCC table is thinner than the TCG Asset form (meter/engine/trans make-model extras). Otherwise none — vault-wide grep for `customer-owned` returns nothing; `model Asset` has
  no owner/ownership field.
- **Blocked:** asset-master migration from FCC (whether such rows exist there is itself unknown).
- **Owner:** TCG owners, via Brian Petros; CodingCops to check the FCC extract for any ownership
  flag before the meeting.
- **Update 2026-09-04 (Project Repository ingest):** the term now has a referent — it is FCC's
  own entity, and what follows is **legacy-system fact, not a TCG decision**. FCC `Maintain →
  Resources → Customer Owned Units` is a window separate from Units, keyed by **Serial Number/VIN**
  rather than a unit code, with a **Customer** lookup, a read-only customer block, tabs Main ·
  Activities · Comments · Parts · Meter, and its own unit-level file-links dialog
  ([asset-record-requested-additions.md](asset-record-requested-additions.md) → *Customer Owned
  Units (slides 20–24)*; [../field-ops/fcc-nexgen-service-guide.md](../field-ops/fcc-nexgen-service-guide.md)
  → *Customer Owned Units*). What they are for: a work order's `Unit Owner` defaults to Company and
  may be set to Customer, *"in which case `Unit Code` becomes `Serial Number/VIN`"* (service guide
  §2), and a work-order quote carries the same `Unit Owner` dropdown
  ([../quotations/fcc-nexgen-quote-entry.md](../quotations/fcc-nexgen-quote-entry.md) → *Work Order
  Quotes*) — i.e. customer machines TCG's shop repairs, the work the `CR` Customer Repair
  department (created 2025-08-13, one unit in it) exists for
  ([fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §4). Labour rows can point
  at one: `CustUnitCode varchar(30)` on
  [ddl/stg.FMS_LABOR_PAYROLL_Raw.sql](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_LABOR_PAYROLL_Raw.sql):8.
  Row counts disagree by source — **79** in the 2026-07-02 production schema inventory (units page
  §8), **12** in the `NexGenFMS-Test` extract brief. Two things are *not* this:
  `FMS_UNITS.OwnedOrRent` ([ddl](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_UNITS_Raw.sql):141)
  is TCG's own fleet owned-vs-rented, and FCC Storage's *"customer-owned items in the yard"*
  ([../dispatch/fcc-nexgen-dispatch-guide.md](../dispatch/fcc-nexgen-dispatch-guide.md) → *Storage*)
  are stored goods, not units. Brian did not yet know the answer himself on 2026-08-26 — *"I check
  with Joe on the customer owned assets… what that's about"*
  ([transcript](../meetings/transcripts/2026-08-26-erp-sprint-review.md) @ 58:11). Still needs the
  client: whether the ERP carries a customer-unit entity at all (shop work orders are unscoped) and
  whether the 79 rows migrate.

## Unit / asset certifications — registrations, insurance, loan, maintenance, permits

- **Status:** open
- **Asked:** 2026-08-27 — Brian Petros, written message to the TCG team, 2026-08-27 ("A couple things that came up in my discussion with CodingCops today, that we'll discuss in future meetings"), following the 2026-08-26 ERP sprint review — logged in [payroll/client-message-findings.md](../payroll/client-message-findings.md#cross-module--2026-08-27-follow-ups-after-the-fcc-migration-first-pass-brian-petros)
- **Question:** Brian wants "more details regarding requirements for Units/Assets certifications
  (and types: like registrations, insurance, loan, maintenance, and all different types of
  permits)". Which of these are one attribute family with an expiry date and reminder, and which
  are distinct entities (a loan is financial, maintenance is a schedule, a permit may be job-bound —
  see projects-jobs → *Asset on a permit*)? No vault document enumerates an asset-certification
  type list.
- **Candidates:** the annotated migration brief, [meetings/2026-08-26-fcc-migration-client-brief.md](../meetings/2026-08-26-fcc-migration-client-brief.md) — FCC `FMS_UNIT_CHECK_LIST` (15 asset checklist types) and `FMS_UNIT_DOWN_REASON` extracted with no TCG home. [projects-jobs/gaps.md](../projects-jobs/gaps.md#permit-expiry-reminders--neither-90-nor-30-shipped)
  (the only expiry-reminder discussion, permits only); `user-story-and-tasks.md` (unverified,
  personal-space provenance). Employee-side counterpart: payroll → *Employee certifications*.
- **Blocked:** asset detail design; any expiry-reminder feature beyond permits.
- **Owner:** TCG (Dylan Masterson for yard/units, Brian Petros for the list), CodingCops to
  bring the FCC field inventory.
- **Update 2026-09-04 (Project Repository ingest):** FCC's own answer to "which of these are one
  family" is now on record — as legacy fact, not a TCG decision. (a) **Registration, inspection
  and maintenance are one mechanism**: interval-bearing activities on the master activities list,
  with `Activity/Certification` = *Certification* for the compliance ones — `ACA` Annual Crane
  Certification (12 months), `QUAD` Quadrennial Inspection (48), `REG` Registration (DMV) (12),
  `SMG` Smog (24), `TRAILER REGISTR` Trailer Registration (60), `ANNINS` Annual Crane Inspection
  (12) — each with a `Certification Type` and a *Do not Prompt when Certificate is Expired* flag,
  tracked last/next per unit on its Activities tab with next-due computed from last-done plus
  interval ([asset-record-requested-additions.md](asset-record-requested-additions.md) → *Master
  Activities List*, *Activities (slide 6)*; columns `ActivityType`, `CertificationType`,
  `DontPromptExpCert` in
  [ddl/stg.FMS_ACTIVITIES_Raw.sql](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_ACTIVITIES_Raw.sql)).
  (b) **Insurance, licence and loan are unit attributes, not activities**: `Insured bit`,
  `InsuranceValue`, `InsureStartDate`, `InsurancePeriod`, `ResidualInsureAmt`; `License`,
  `StateCode`, `LicenseExpiry`; `MonthlyPayment` — the only loan field, Lender / Interest Rate /
  Maturity / Balloon do not exist — plus `WarrantyExpDate`
  ([ddl/stg.FMS_UNITS_Raw.sql](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_UNITS_Raw.sql);
  the deck's *Buy/Sell Info* tab). (c) **Permits are not on the unit** in FCC — `FAA`, `SP`, `TP`
  are schedule types sold per job (units page §1) and *Travel Permit – 120 Ton and above* is a
  resource type. (d) The employee side already reaches units: `FMS_CERTIFICATES.CertificationType`
  has a `U` = Unit value and a `UnitCertificateType` column
  ([../payroll/fcc-employee-master-reference-data.md](../payroll/fcc-employee-master-reference-data.md)),
  and the service guide states *"A Certification Type is used to constrain an Activity to an
  individual based on their role"*
  ([../field-ops/fcc-nexgen-service-guide.md](../field-ops/fcc-nexgen-service-guide.md) §1).
  (e) The client's list predates Brian's message — Kyle Harlow, 2026-03-24 @ 24:15: *"insurance,
  registration, quad and annual… service manual, operator's manual, load charts… a lot of those
  are on a time basis, so you have to upload them again… customers request the quad, the annual
  and the last 90 day inspection"*
  ([transcript](../meetings/transcripts/2026-03-24-tcg-cc-product-sync-demo.md)); the crane pre-trip
  checkpoints *Crane Annual and Quad Certification Stickers* and *Compliance: Registration / Tags /
  Annual Permits* show the same set verified daily
  ([fcc-checklist-templates.md](../payroll/tcg-rawfms-staging-database/data/fcc-checklist-templates.md)).
  Still needs the client: the ERP's type list, which items carry an attachment with expiry and
  reminder, and whether FCC's activity model is the pattern to keep.

## Schedule types include non-equipment — does a TCG Category?

- **Status:** open
- **Asked:** 2026-08-31 — reading `OneDrive_1_8-31-2026` into the vault
- **Question:** FCC's `FMS_SCHEDULE_TYPES` (25 rows) is the analogue of a TCG Category,
  and roughly half its members are not machines: Lift Plan, FAA Permit, Street Permit,
  Travel Permit, Mobilization, Rigger and Signalman, Outside Trucking Services, Storage,
  Yard, Radio, Material Basket. So in FCC a "unit" is anything schedulable and billable.
  TCG models permits and plans as their own entities instead. Which is right going
  forward — and does the answer change if operator loads and counterweight loads become
  Assets (see `dispatch/gaps.md`), since those are units that are not machines either?
- **Sources checked:** `assets/fcc-units-and-schedule-types.md`,
  `dispatch/crane-configurations.md`, `schema.prisma` (`Category`, `SubCategory`,
  `Permit`, `Plan`).
- **Update 2026-09-04 (Project Repository ingest):** FCC's data already separates the two populations,
  and two TCG statements this week bear on the question. (a) `FMS_SCHEDULE_TYPES.Schedules` is `0`
  on exactly `LP`, `SP`, `TP` — Lift Plan, Street Permit and Travel Permit are billable but never
  scheduled; every other type including `FAA` is `1`; `UnitOrComponent` is `U` on all 25 and the
  import template's domain for it is **U Unit · C Component · T Tool**
  ([fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §4, §7). So FCC's answer to
  "is a permit a unit?" is *a schedule type flagged not-schedulable*, and the non-machine rows
  still sit on the Resource Types Main tab — *Travel Permit – 120 Ton and above* under Travel
  Permit, *Spreader Bar* under `Yard`
  ([asset-record-requested-additions.md](asset-record-requested-additions.md) → *Resource Types
  (slides 25–28)*). Legacy fact, not a decision. (b) The load half of the question is decided:
  [../dispatch/gaps.md](../dispatch/gaps.md) → *Crane configuration — is a support load an Asset*
  was **resolved 2026-09-03 — an Asset** (own unit code, allocatable, counts for utilisation), so
  non-machine Assets already exist by decision. (c) Joe, 2026-09-02, on what should template from a
  resource type: *"the additional items like the riggers, we can add them specific to the job. We
  don't want that to populate"*
  ([2026-09-02 sprint demo](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md)
  item 2) — the module owner saying Rigger and Signalman is per-job, not part of a crane's
  template; not a statement about whether it is a Category. Still needs the client: whether TCG's
  Category set carries the paperwork types (LP / SP / TP / FAA) or `Permit` / `Plan` stay separate
  entities, and whether a schedulable flag on Category is the mechanism.

## Create-form prefill from URL query params — the whole contract is unwritten

- **Status:** open
- **Asked:** 2026-08-31 — PR review of branch `fix/auto-select-issue` (PR #432, commit
  `0d000632`). **Not a ticket question:** the branch carries no `SCRUM-###`, has no
  `.ai/aidlc/SCRUM-###/` folder and no `processed.log` row, so there is no `spec.md` §12 to
  hold it. Filed here per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*; the
  billing-code half is in [quotations/gaps.md](../quotations/gaps.md#billing-code-create-form-prefill--six-query-params-no-producer-no-source).
- **Question:** four things, each answerable in a line.
  1. When a user clicks **Create** from a category or sub-category detail/list page, should
     the new asset's category / sub-category arrive **pre-selected** from that context?
  2. Should the sub-categories list's **Create** button carry the list's **active category
     filter** into the new sub-category form?
  3. Does a prefilled value count as **a user edit** — should prefill mark the form dirty and
     trip the unsaved-changes guard, so Cancel prompts on a form the user never typed in?
  4. If a query param names an ID that does not exist, is archived, or is outside the
     tenant's visibility, should the form **silently ignore it** or **tell the user**?
- **Sources checked:** [INDEX.md](INDEX.md); [categories-and-sub-categories.md](categories-and-sub-categories.md)
  (`status: unverified`, 0.6 KB) — its two category bullets are *"Edit should re-direct to show
  page"* and *"Remove Preview feature"*, i.e. navigation and listing items, **nothing about a
  create form or what it opens with**; [user-story-and-tasks.md](user-story-and-tasks.md)
  (`provenance: personal-space`) — yard/HubSpot/2FA/customer/quotation stories only, no asset
  or category create story at all; [tool-and-rigging.md](tool-and-rigging.md) — yard dashboard
  and utilization only. `../decisions/` — 18 notes, and **only one touches create flows**:
  [2026-08-20-post-save-navigation-convention.md](../decisions/2026-08-20-post-save-navigation-convention.md)
  (`status: reference`), which settles *where a save lands* and says nothing about what a form
  opens with. Grep across the whole `.ai/` overlay for `prefill` / `pre-populat` / `query param`
  / `categoryId` / `subCategoryId` / `auto-select` / `pre-select` returns **no hit on create-form
  prefill**; every populate-shaped hit is quotation *rate* auto-population from billing codes
  (2026-03-17, 2026-05-05 transcripts), a server-side pricing lookup, not a URL contract.
  `.ai/aidlc/processed.log` — no row for this branch. **Jira was not checked: no Jira MCP was
  available in this session**, so a ticket may exist that this review cannot see.
- **Note:** the adjacency worth naming, because it cuts the other way. The post-save
  navigation note's *What this does NOT settle* explicitly lists **"creates that do not start
  from a listing — a create nested inside another record's page … whether these also land on
  the listing, or return to where they were opened from, is undecided."** This branch builds
  exactly that flow (create reached from a category/sub-category detail page) — so the one
  decision in this neighbourhood names this territory as open rather than covering it. Q3 and
  Q4 are **app-wide form conventions**, not assets-specific: they will recur on the next module
  that carries context in a URL, and are cheapest to settle once, the way post-save navigation
  was. `apps/web/AGENTS.md` → *Forms* sets failed-submit behaviour and is silent on both.
- **Blocked:** PR #432's five behaviours are shipping unsourced; any future create form that
  carries context in the URL; any claim that prefill-does-not-dirty (or does) is settled.
- **Owner:** needs assignment. Q1/Q2 are product — route to TCG via Brian Petros. Q3/Q4 are
  internal conventions the team can settle itself if the client has no view; Fouzan Shakil is
  the precedent-holder, having decided the post-save convention the same way.

## The permanent per-crane tool kit — what is on each crane before anything is loaded

- **Status:** open
- **Asked:** 2026-08-31 — processing Dylan's loading list ([loading-list.md](loading-list.md)),
  supplied via Melissa McNutt. Dylan stated the boundary himself and it is not a ticket question:
  no ticket asks for the permanent kit.
- **Question:** Dylan's list is explicitly only the **additional** items a job can request —
  *"there are other items that are permanently assigned to each crane that remain on each crane…
  and those items are not on this list."* So every crane carries a standing kit we have never
  seen. What is on it, does it vary per crane or per crane class, and does the ERP need to model
  it at all — as tool records assigned to a unit, as an attribute of the unit, or not at all
  because it never moves? This decides whether the loading screen shows a crane's full tool
  inventory or only the picked additions, and whether the yard dashboard's Total/In-use/Available
  counters are counting the whole yard or just the pickable pool.
- **Sources checked:** [loading-list.md](loading-list.md) — 26 additional items, Dylan's exclusion
  quoted verbatim. [tool-and-rigging.md](tool-and-rigging.md) (`status: unverified`) — Story 1
  mentions *"System warns if requested tool already exists on assigned crane"*, which **implies a
  per-crane kit exists and is queryable**, but never says what populates it or where it is
  recorded; Story 4 lists the loading screen as showing *"Assets, Tools & rigging, Employees"*
  without saying which population. [fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md)
  — the 156-column FCC unit table has no per-unit tool list. FCC `FMS_TOOLS` is **empty in the
  test catalog** (0 rows, per `apps/api/fcc-seeder/docs/seed-files-index.md`), so the legacy system
  holds no answer either. [dispatch/crane-configurations.md](../dispatch/crane-configurations.md)
  — describes counterweight loads per crane, not tools.
- **Update 2026-09-04 (Project Repository ingest):** two sources bear on it; neither delivers the
  kit. (a) An older transcript this entry had not reached answers the "does the ERP need it" part
  with client statements — 2026-05-07 @ 50:46–53:23
  ([transcript](../meetings/transcripts/2026-05-07-loading-and-project-module-overview.md)). The
  answer on whether the standing kit should display (labelled *Brian Petros* in the transcript;
  Ehtesham addresses it to Dylan): *"basic rigging that's already on there. It doesn't need to
  display here"*, and on tracking it: *"I am not… we know off the top what they have"*. Wes Staley:
  *"We can reach out to Leo and to Rich. They're building out each crane and all the components on
  the 1st and 2nd loads. So we can give that information to Ehtesham"* and *"We have not done a
  good job of making sure we know what's on each crane all the time… we definitely need that"*.
  Ehtesham: *"once you guys have that information, send it over and we are going to create this
  permanent section and then we can create rules"* — the *"already exists on assigned crane"*
  warning in [tool-and-rigging.md](tool-and-rigging.md) Story 1 is this exchange. So the kit was
  **promised as a per-crane inventory built by Leo and Rich, per load (1st / 2nd)**, and no drop
  through 2026-09-04 contains it. (b) FCC has the model and never used it: a Components & Tools
  record carries **Assigned Unit Code** (plus Category `Component` / `Tool`, serial, image, QR, a
  scan log with geofence) — a tool is pinned to a unit as its own record, not as a unit attribute
  ([asset-record-requested-additions.md](asset-record-requested-additions.md) → *Components &
  Tools*); `FMS_UNIT_COMPONENTS` (51 columns) and `FMS_TOOLS` are **empty**
  ([fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §8). Legacy fact, not a
  decision. Still needs the client: the kit list itself (Leo / Rich), per crane or per class, and
  whether "does not need to display" or "we definitely need that" is the product rule.

## Loading list — quantity, sets, and sizes are underspecified for a schema

- **Status:** open
- **Asked:** 2026-08-31 — processing [loading-list.md](loading-list.md).
- **Question:** three modelling questions the list raises and does not answer. (a) **`Boscaro Bar`
  carries quantity `N/A`** where all 25 other rows carry an integer — is it uncountable, bulk,
  consumable, not owned, or simply unknown? A required-integer quantity column cannot store this
  row. (b) **Set-granularity items** — `Container Hooks (Set of 4)`, `Jensen Lifter Sets`,
  `Skookum Sets` — is the set the tracked unit for loading and return, or are the pieces tracked
  individually and merely grouped for display? (c) **Size lives in the item name**, not a field:
  `4x4` / `8x4` / `10x6` / `8x6 Steel Plates`, `Small` / `Large Husky Bar`, `Small` / `Large` /
  `8x8 Material Bin`. Are these separate tool records, or one record with a size attribute? The
  answer sets whether availability is per size or pooled.
- **Sources checked:** [loading-list.md](loading-list.md) — the list itself, all 26 rows.
  [tool-and-rigging.md](tool-and-rigging.md) Story 1 — *"User can add unlimited custom
  attributes"* makes both the separate-record and the size-attribute reading legitimate, and
  says nothing about quantity type or set granularity; Story 5 — *"Each tool displays live status
  counters Total, In use and available"* assumes a countable quantity without defining it.
  No `decisions/` note touches tool quantity.
- **Update 2026-09-04 (Project Repository ingest):** evidence on (a) and (c), none on (b). (a)/(c)
  **The Boscaro bar's capacity depends on how it is assembled** — Kyle Harlow, 2026-04-07 @ 52:56:
  *"the Bosco bars have so many options and the capacity changes on the configuration… the Bosco
  kit bar can be used from 100 tons right to only good for 15. It depends on how you put it
  together"*; Wes @ 52:25: *"we may have 5 spreader bars can lift 10,000 lbs, one that can lift
  20"*; Melissa @ 53:48 proposed *"configurations for rigging… the Bosco bar would have
  configuration one which gives you X capacity"* and Ehtesham said it could be built
  ([transcript](../meetings/transcripts/2026-04-07-dispatch-scheduling-figma-demo.md)). So the `N/A`
  is consistent with a **kit whose pieces assemble into different bars** rather than a bulk or
  consumable item — a client description of the physical thing, not a modelling decision. (c) FCC's
  practice also puts size in the name: its mobile tool list under *Rigging Components* reads
  `14' Spreader Bar · Crosby Shackles - 1" · D Ring 1/2 · D Ring 3/4 · 1"X20' Wire Rope Slings`,
  with a free-text **Size/Comments** and **Qty Out / Qty In** per tool
  ([../quotations/fcc-nexgen-quote-entry.md](../quotations/fcc-nexgen-quote-entry.md) → *Tools on
  mobile*), while its Components & Tools master is **one record per physical piece** with serial
  number and QR ([asset-record-requested-additions.md](asset-record-requested-additions.md) →
  *Components & Tools*) — and `FMS_TOOLS` and `FMS_UNIT_COMPONENTS` are both empty, so FCC never
  exercised either shape. Legacy fact, not a decision. Still needs the client: set-vs-piece
  tracking (b), and whether a Boscaro configuration is a tool record, a size attribute, or a
  capacity table.

## Loading order — is the sequence a per-yard constant or per-job

- **Status:** open
- **Asked:** 2026-08-31 — processing [loading-list.md](loading-list.md).
- **Question:** the artifact is titled **"LOADING LIST (IN ORDER)"** and numbers its rows 1–26 in
  a sequence that is neither alphabetical nor by size nor by type. Is that order a fixed property
  of the catalog (store it as a sort key on the tool record), or does it vary by crane, trailer,
  or job (derive it per loadout)? And is it advisory or binding — does the loading screen let the
  crew mark items complete out of order? Story 4 says *"Crew can tap Start Loading and mark items
  completed individually"*, which reads as unordered.
- **Sources checked:** [loading-list.md](loading-list.md) — the `Order` column and the title.
  [tool-and-rigging.md](tool-and-rigging.md) Story 4 *Loading Process* — specifies what each line
  item displays (reference photo, camera icon, Needs Spotter badge) but **never mentions ordering
  or sequence**; Story 5 likewise. No meeting transcript in `meetings/` states a load order rule —
  checked the six loading-related transcripts (2026-04-14, 2026-05-07, 2026-05-12, 2026-05-14,
  2026-07-01, 2026-04-30).
- **Update 2026-09-04 (Project Repository ingest):** the yard's own written process is now in the
  vault and it carries **no item sequence**: the daily loading list is per job — *job number · unit
  going and how many loads · required rigging · leave time* — written down and sent to two chats,
  with *leave time* as the scheduling key
  ([../dispatch/daily-loading-value-engine.md](../dispatch/daily-loading-value-engine.md) §1).
  Neither that value engine nor FCC's tool screens (Qty Out / Qty In, no order column —
  [../quotations/fcc-nexgen-quote-entry.md](../quotations/fcc-nexgen-quote-entry.md) → *Tools on
  mobile*) says whether Dylan's 1–26 is a catalog constant or per-loadout. Evidence of absence only;
  still needs Dylan.

## Sub-category names — unique per tenant, and does an archived one keep its name reserved?

- **Status:** open
- **Asked:** 2026-09-01 — branch `fix/subcategory-asset-dropdown-surcharge` (no ticket);
  tcg-scrum escalation
- **Question:** two parts. (a) Must a sub-category name be unique **within a tenant**? The branch
  adds `@@unique([tenantCompanyId, name])` to `SubCategory` and translates the collision into a
  409, on the stated grounds that `Category` has carried the same constraint since the baseline.
  That is a shipped code precedent, not a written requirement, and nothing says the two catalog
  levels must behave alike — uniqueness **within the parent category** is the other plausible rule
  and would allow a "Hydraulic" under both Cranes and Trucks. (b) If names are unique, the index is
  deliberately **not partial**, so an **archived** sub-category keeps its name reserved. Under
  [2026-08-20-archive-instead-of-delete-app-wide](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md)
  archiving is the only way to retire a record, so no name is ever released — is a permanent
  reservation intended, or should archiving free the name for reuse?
- **Sources checked:** [categories-and-sub-categories.md](categories-and-sub-categories.md) — the
  only vault file on this topic, 0.3 KB, and its entire sub-category section is *"Need to add
  target hours per month - FCC"*. Nothing anywhere in the vault states a naming rule for either
  level. [../quotations/gaps.md](../quotations/gaps.md) →
  *Sub-category association cycles* — names sub-category **name matching** as a live defect
  (association lookup keys on item name, so an employee type sharing a name inherits a
  sub-category's associations); tenant-unique names would narrow that collision, but that entry
  asks for FK-keyed lookup rather than uniqueness and is itself open. Also checked
  [INDEX.md](INDEX.md), [../STRUCTURE.md](../STRUCTURE.md), `decisions/`, and `.ai/aidlc/`
  (no spec folder; `processed.log` has no sub-category entry). **Jira checked:** `SCRUM-959`
  (To Do, Umair Khan, created 2026-09-01) — *"In Subcategories > Details > Associated Field, while
  adding resources, the subcategory should be unique"* — is the nearest hit and a **different
  requirement**: no duplicate rows inside one sub-category's associated-resource list, not
  tenant-wide name uniqueness. It must not be cited as the source for this change. No other SCRUM
  issue asks for sub-category name uniqueness.
- **Blocked:** nothing — the constraint is on `main` (PR #451). Product questions (a) and (b)
  remain open; run the duplicate-name pre-flight before applying the migration in each environment.
- **Owner:** product team — whoever owns asset-management catalog rules.
- **Update 2026-09-01 (PR review, branch `fix/subcategory-asset-dropdown-surcharge`)** —
  **Deploy blocker:** migration `20260901120000_sub_category_tenant_name_unique` adds
  `UNIQUE (tenant_company_id, name)` with no dedup or backfill step. If any tenant already has
  two sub-categories sharing a name, `migrate deploy` aborts and leaves schema behind code. Run
  this pre-flight on every target environment before merge:
  `SELECT tenant_company_id, name, COUNT(*) FROM sub_categories GROUP BY 1, 2 HAVING COUNT(*) > 1`.
  One local DB returned zero rows at branch time; staging/production are not evidenced.
  **Engineering gap:** no `sub-categories.service.spec.ts`; the new P2002 → 409 path on create
  and update is untested. See also
  [Duplicate sub-category name — inline field error or toast only?](#duplicate-sub-category-name--inline-field-error-or-toast-only).
- **Update 2026-09-01 (post-merge, PR #451 → main)** — merged to `main`. Product questions
  (a) and (b) remain open. **Engineering follow-ups on main:** `schema.dbml` regenerated to
  match schema; `sub-categories.service.spec.ts` added for P2002 → 409 on create/update.
  **Deploy:** run the duplicate-name pre-flight on staging/production before applying the
  migration in each environment.

- **Update 2026-09-02 (staging deploy failed — constraint WITHDRAWN)** — the predicted
  deploy blocker landed. `20260901120000_sub_category_tenant_name_unique` failed against
  `tcg_staging` at 2026-09-01 17:51:48 UTC; its failed `_prisma_migrations` row then blocked
  every later migration with **P3009**, holding back `20260901120100_add_asset_name` and
  `20260901160000_add_craft_modifier_id_to_ticket_labor_entries`. The pre-flight this entry
  prescribed was never run against staging. Duplicates found: `"Operator Load"` x3 and two
  more pairs in tenant `2644892a`, `"90 Ton Hydraulic Truck Crane"` x3 in `64355383`,
  `"Crawler Crane"`/`"Operator Load"`/`"Truck"` in `ec5404f8`.
  **A merge was not available:** `template.sub_category_id` is `@unique` (one-to-one), so
  collapsing each group would destroy one template per duplicate — destructive, on a
  requirement product has still not ratified.
  **Resolution:** the constraint is withdrawn, not deferred —
  `20260902000000_drop_sub_category_tenant_name_unique` drops the index, `@@unique` is off
  the `SubCategory` model, and duplicate names are accepted again as they were before PR #451.
  `throwIfDuplicateName` and its spec are kept but **inert**, so re-adding the rule is a
  schema change alone. Questions (a) and (b) above are still **open and now blocking** —
  answering yes requires a dedup migration *and* a product ruling on which duplicate
  survives and which template is destroyed.
  **Prevention (main repo):** `prisma/scripts/preflight-unique-constraints.mjs` now runs
  before every `migrate deploy` — it reads the pending set from `_prisma_migrations`, scans
  those migrations for `CREATE UNIQUE INDEX` / `ADD CONSTRAINT … UNIQUE`, and refuses the
  deploy while the data still violates them, leaving the database untouched. Partial and
  expression indexes are reported as unchecked rather than silently passed. Also fixed:
  `recover_failed_migrations` in `migrate-deploy.sh` had been gating on `prisma migrate
  status` wording that Prisma 7 no longer emits, so both deploy attempts were byte-identical
  and no recovery was ever attempted.
  **Still true:** no CI job applies migrations against a production-like database, so
  "works locally" remains no evidence for a data-dependent migration.

- **Update 2026-09-02 (constraint RE-INSTATED with dedup — part (a) answered)** — Syed Haris
  ruled the staging duplicates are test data and that sub-category names are unique going
  forward. Recorded as
  [decisions/2026-09-02-sub-category-names-tenant-unique](../decisions/2026-09-02-sub-category-names-tenant-unique.md),
  `status: reference` — he is not the client-side product owner, so TCG can still overrule it.
  **Part (a) is answered; part (b) is not.** The index is still non-partial, so an archived
  sub-category reserves its name permanently. That is shipped behaviour, never ratified.
  **How:** `20260902010000_sub_category_tenant_name_unique_with_dedup` renames collisions
  (oldest keeps the name, later rows take the lowest free `" (n)"`) and then creates the
  index, in one transaction. Nothing is merged and nothing deleted — a merge was rejected
  because `template.sub_category_id` is `@unique`, so it would destroy a template per
  duplicate. Verified against a scratch Postgres: cross-tenant same-names untouched,
  archived rows renamed, a pre-existing `" (2)"` correctly skipped to `" (3)"`.
  **Pre-flight interaction:** a dedup-then-constrain migration would trip the guard added the
  same day, since the guard runs before the rename. Migrations that make their own
  constraints satisfiable now declare `preflight-skip` in a comment; the guard reports them as
  SKIPPED in the deploy log rather than passing them silently, and the opt-out is scoped to
  the declaring migration only — an unmarked violation in the same run still blocks.

- **Update 2026-09-02 (pre-flight's first real run blocked a deploy — SSL)** — the guard
  worked as designed and still cost a deploy. `pg` 8.22 treats `sslmode=require` as
  `verify-full`; Prisma follows libpq semantics, where `require` encrypts without verifying
  the CA. Against RDS the two disagree: `migrate deploy` connected, the pre-flight died with
  `self-signed certificate in certificate chain`, and because it fails closed it refused a
  deploy that had nothing pending to check. Fixed by adding `uselibpqcompat=true` when
  sslmode is `require`/`prefer`/`allow`, honouring `verify-full`/`verify-ca` unchanged.
  **Worth keeping:** passing `ssl: { rejectUnauthorized: false }` alongside a connection
  string does **not** override `sslmode` — the connection-string parser wins and the connect
  still fails. That was the first fix attempted; it was only caught by testing against the
  real RDS certificate rather than a local Postgres. A guard that runs before every deploy
  has to be exercised against the environment it guards.
  **Staging outcome, verified directly:** unique index present, zero remaining duplicate
  groups, 7 rows renamed — `Operator Load (2)/(3)` in `2644892a`,
  `90 Ton Hydraulic Truck Crane (2)/(3)` in `64355383`, and three singles in `ec5404f8`.

- **NEW (2026-09-02): `Plan.craneCategory` stores a sub-category NAME, not an FK**
- **Status:** open
- **Asked:** 2026-09-02 — found while assessing whether renaming duplicates was safe
- **Question:** `Plan.craneCategory` is `VARCHAR(100)` holding the sub-category name, and two
  web call sites resolve it with `.find((sub) => sub.name === craneCategory)`
  (`plan-form-lift-fields.tsx:134`, `plan-form-additional-info-validation.ts:36`). `.find()`
  returns the first match, so while duplicates existed a plan bound to whichever row the list
  endpoint returned first — order-dependent, and that order changed in PR #459 when listing
  moved to capacity sorting. Uniqueness makes the lookup deterministic but leaves it fragile:
  **any future rename silently orphans every plan storing the old name**, with no FK and no
  error. Should `craneCategory` become a `subCategoryId` FK, and what should happen to plans
  whose stored name no longer resolves? `[INFERRED]` from code — not reproduced against a
  database.
- **Blocked:** nothing today; the dedup migration renames rows on staging, where the data is
  test data. It would block any rename of a real tenant's catalog.
- **Owner:** engineering, with product input on the orphaned-plan behaviour.
- **Update 2026-09-04 (Project Repository ingest):** evidence on (a) only, and legacy fact rather
  than a decision. FCC's unit import contract identifies the sub-category level by its name: *Resource
  Type — a `Resource Description` from the Resource Types tab* is a required field, the import
  template's validation resolves it against that tab, and the tab itself carries no ID column —
  *"a resource type is defined by its description, not by an ID — the ID is FCC-generated"*
  ([fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §7 and the validation
  section). The Resource Types tab is one flat list across every schedule type (§6), so the scope
  in which a description has to identify a resource type is the whole catalogue, not the parent
  schedule type. Nothing in the drop shows a retired resource type's name being reused, so (b) is
  untouched.

## Duplicate sub-category name — inline field error or toast only?

- **Status:** open
- **Asked:** 2026-09-01 — PR review of branch `fix/subcategory-asset-dropdown-surcharge` (no
  ticket)
- **Question:** when a user submits a sub-category name that collides with an existing one within
  the tenant, the API returns 409 with *"A sub-category with this name already exists. Please use
  a different name."* The web create path (`use-create-sub-category-actions.ts`) and update path
  (`sub-category-detail-state.ts`) surface this via `toastMutationError` only — there is no
  inline validation on the name field. Is a toast sufficient, or should the name input show a
  field-level error (matching how other form validations behave)?
- **Sources checked:** branch implementation in
  `apps/api/src/usecase/asset-management/sub-categories/sub-categories.service.ts` (409 message),
  web mutation `onError` handlers; no vault or Jira statement on duplicate-name UX for
  sub-categories. Category duplicate handling was not checked for a precedent.
- **Blocked:** nothing — behaviour has shipped on `main` (PR #451).
- **Owner:** product team / web UX — whoever owns form validation patterns for asset catalog.

## Asset name — optional or required, shareable or not, and is it "Unit Name" or "Asset Name"?

- **Status:** open
- **Asked:** 2026-09-01 — branch `fix/subcategory-asset-dropdown-surcharge` (no branch ticket; it
  implements `SCRUM-956`, which has no `.ai/aidlc/` spec folder, so there is no §12 to hold this);
  tcg-scrum escalation
- **Question:** `SCRUM-956` settles that the field exists — *"There should be a Unit Name field
  when creating an asset"* — and settles nothing else. Three things it does not say, all of which
  the branch decided on its own: (a) is the name **optional**? It ships nullable, with an optional
  form field and no backfill, so every existing unit stays unnamed and the new list column renders
  blank for them; (b) may two units **share** a name? It ships deliberately non-unique; (c) the
  ticket and the fleet's own paperwork say **Unit Name**, the UI ships **Asset Name** — which term
  does TCG use?
- **Sources checked:** **Jira `SCRUM-956`** (Task, To Do, unassigned, reporter Umair Khan, created
  2026-09-01) — the full description is the single sentence quoted above; no acceptance criteria,
  no comments. It is one of twelve tickets the same reporter filed in four minutes that afternoon,
  i.e. a review-session punch list rather than a specified requirement.
  [../dispatch/crane-configurations.md](../dispatch/crane-configurations.md) §1 — the
  Lisette-approved asset workbook, the only vault artifact carrying real unit names, and direct
  evidence on (b) and (c): its **Unit code / Unit name** table gives `26502.1`, `26502.2` and
  `26502.3` — three distinct unit codes all named *"265 Ton Support Load"* — so names are already
  non-unique in the fleet TCG runs today, and the column is headed **Unit name**. `status:
  unverified`. [../dispatch/daily-allocation-system.md](../dispatch/daily-allocation-system.md):105
  — *"Hovering over an icon shows asset name, assigned job, and status"*, the only other vault
  mention, and it calls the same thing **asset name**; the two together are where the term
  ambiguity comes from. [../vendors-agencies/vendors.md](../vendors-agencies/vendors.md):44,72 —
  the vendor-asset capture list and table columns, which carry Unit Code and **no name field at
  all**. Also checked [INDEX.md](INDEX.md), [user-story-and-tasks.md](user-story-and-tasks.md),
  [fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md), `decisions/`, `.ai/aidlc/`.
  **The unit-code half of the change needed no answer** — `@@unique([tenantCompanyId, unitCode])`
  and its 409 predate the branch and are untouched by it.
- **Blocked:** nothing. This asks whether the three unstated halves are right before the column
  reaches every asset list and picker.
- **Owner:** product team — the `SCRUM-956` reporter (Umair Khan) can settle (c); (a) and (b) need
  whoever owns the asset catalog.
- **Update 2026-09-01 (PR review, branch `fix/subcategory-asset-dropdown-surcharge`)** —
  **Cleared-name storage:** the sub-category quick-create dialog correctly sends
  `name: formData.name.trim() || undefined`. Main asset create/edit uses
  `normalizeAssetPayloadForSubmit`, which normalizes dates and money but not `name` — clearing
  the field can persist an empty string (`""`) instead of `null` or omitting the field. Should a
  cleared name be stored as `NULL`?
  **Surface coverage:** web ships list column, detail row, both forms, search/sort, and
  `AssetSelect` description (`name ?? description`). Mobile dispatch path does not surface
  `name` in this branch — intentional deferral or an oversight?
  **Engineering gap:** no API or web tests assert create/search/sort on `name`; new
  `data-testid`s `assets-form-name` and `assets-create-dialog-name` are not yet referenced in
  `qa-automation/e2e/`.
- **Update 2026-09-01 (post-merge, PR #451 → main)** — merged to `main`. Product questions
  (a)–(c) remain open. **Engineering fix on main:** `normalizeAssetPayloadForSubmit` now trims
  `name` and stores `null` when cleared (matching date/money normalization), so main create/edit
  no longer persist empty strings. Mobile `name` surfacing and test coverage still open.
- **Update 2026-09-04 (Project Repository ingest):** FCC's record on all three parts, as legacy
  fact. (a) **Required in FCC**: `FMS_UNITS.UnitName varchar(60) NOT NULL`
  ([ddl/stg.FMS_UNITS_Raw.sql](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_UNITS_Raw.sql):4),
  and the import contract lists *Description — up to 60 characters* among the fields **required to
  create a unit** ([fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §7) — so
  every migrated unit has one, and nullable-with-no-backfill is TCG's departure, not FCC's.
  (b) **Non-unique in FCC**: the deck's Unit Location History example is `26503.1` — *"265 Ton
  Support Load"*, the same name the workbook gives `26502.1` / `.2` / `.3`
  ([asset-record-requested-additions.md](asset-record-requested-additions.md) → *The nine lookups*,
  slide 38). (c) **FCC itself uses two words for one field**: the column is `UnitName`, the label
  on the Units Main tab is **Description** (*Unit Code · Description · Company/Owner …*), and the
  import template calls it Description; the client's own workbook heads it *Unit name*
  ([../dispatch/crane-configurations.md](../dispatch/crane-configurations.md) §1) — *Asset Name*
  appears in no client source. **Engineering note:** the FCC seeder already lands `UnitName` in
  `Asset.description`, not `name` (`apps/api/fcc-seeder/src/extract-seed-files.ts:206`), so
  migrated units will show a blank name column until that mapping is decided. Still needs the
  client: whether TCG keeps FCC's required-on-create rule, and the UI word.

## Feet-inches fields save a bare separator when inches are empty

- **Status:** open
- **Asked:** 2026-09-02 — reading back an asset created through the form while building
  regression fixtures.
- **Question:** the asset form's feet-inches control serialises `jib_length` as **`"58|"`** — the
  value, a pipe, and nothing after it — where the sibling fields on the same form save cleanly
  (`vehicle_width: "10 ft 6 in"`, `vehicle_height: "13 ft 2 in"`, `vehicle_length: "54 ft 6 in"`).
  So a feet-only entry keeps the separator. Is the stored format meant to be `feet|inches`, with
  the display layer parsing it, or `"N ft M in"` as the other three suggest? Whichever it is, one
  of the two behaviours is wrong, and they are produced by the same control.
- **Why it matters more than cosmetics:** `jib_length` is free text (`VarChar`), so nothing
  rejects it, and the value round-trips into the field on edit. Anything that later parses jib
  length — a lift-plan calculation, an export, a report — meets a value that is neither a number
  nor the format its neighbours use. `main_boom_length` is unaffected: it is `Decimal` and stored
  `"164.00"`, which is why the boom-pay resolver is not at risk.
- **Sources checked:** the asset row created 2026-09-01 in `CODING-COPS`
  (`unit_code = 10001`) — `jib_length: "58|"` against three correctly formatted dimension fields
  on the same submission. `apps/web/src/features/assets/asset/components/asset-form-sections/`
  `feet-inches-field.tsx` is the shared control. No `decisions/` note and nothing in `meetings/`
  states a storage format for asset dimensions.
- **Note:** worth checking whether the same control is used on any field that *is* parsed
  downstream before deciding the fix — the format may be load-bearing somewhere.
- **Update 2026-09-04 (Project Repository ingest):** the migration source has no serialised format
  to preserve — FCC stores every dimension as **two columns**: `VehicleWidthFt numeric(9,2)` +
  `VehicleWidthIn smallint`, likewise Height, Length and Gage, and `JibLengthFt smallint` +
  `JibLengthIn smallint`, with `BoomLength` alone a single `varchar(14)`
  ([ddl/stg.FMS_UNITS_Raw.sql](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_UNITS_Raw.sql):36–46);
  the import template carries them as separate 3-character feet and inches fields and the Units
  screen shows Ft + In pairs ([fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md)
  §7; [asset-record-requested-additions.md](asset-record-requested-additions.md) → *The Units
  window*). So `feet|inches` vs `"N ft M in"` is TCG's choice alone, and whichever wins the seeder
  composes it from two source columns. Legacy fact, not a decision.

## The cascading resource picker may now show an incomplete tree — is that acceptable?

- **Status:** open
- **Asked:** 2026-09-02 — PR review of branch `feat/move-dropdowns-BE` (no ticket, no
  `.ai/aidlc/` folder, no `processed.log` row); tcg-scrum escalation. Routed here because the
  cascade is Category → Sub-Category and this module owns categories; the largest consumer is
  quotation Resources, which carries a pointer.
- **Question:** The branch adds `GET /resource-catalog/tree` and `GET /resource-catalog/search`
  as the data source for the cascading `MultiOptionDropdownMenu` (employee types, sub-categories,
  custom types). `tree` is a **one-shot read capped per kind**, so with no search term the menu is
  **deliberately incomplete** — a user browsing the cascade without typing may not see every
  sub-category that exists. Three parts, each answerable in a line. (a) Is a **truncated
  browse state acceptable** on a picker users currently treat as the full catalog? (b) If it is,
  **what is the cap and how are the shown rows chosen** — the branch picks a number and an order
  with nothing to check them against. (c) Must the menu **say** it is showing a subset, or is
  silent truncation fine?
- **Sources checked:** **Vault — nothing on resource-catalog picker behaviour.** `INDEX.md`;
  this module's `INDEX.md`; [categories-and-sub-categories.md](categories-and-sub-categories.md)
  (0.3 KB, five bullets — move under Settings, custom codes, schedule-type question,
  active/inactive filter, remove Preview; **nothing on selection or loading**);
  [tool-and-rigging.md](tool-and-rigging.md); [loading-list.md](loading-list.md);
  `../quotations/quotations-INDEX.md` and all four candidates; `../decisions/` (24 notes, none on
  pickers or catalogs). Vault-wide grep for `resource catalog` / `resource-catalog` returns **one
  hit in the whole repo** — `.ai/claude/contexts/web.md`:136, the build convention, added on this
  branch. Code verified: `apps/api/src/presentation/resource-catalog/resource-catalog.controller.ts`
  :28–50, `dto/query-resource-catalog.dto.ts` (`limit` `@Max(500)`, search spans employee-type
  name, sub-category name, parent category name, custom-type title and code).
- **Jira establishes the control, never its data volume.** `SCRUM-491` (Done, 2026-06-02, Abdul
  Muazzam) created the multi-menu — *"so that we can link employee and other types as well with
  the sub-category, and in quotation resources now we are listing all these 3 types of items as
  child items"* — which fixes **what the tree contains**, not how much of it loads. `SCRUM-811`
  (Done) and `SCRUM-638` item 18 propagate the same nested control to other forms. `SCRUM-873`
  (QA) item 2 asks only that it open to the right. **No ticket asks for the cascade to be
  searched, capped or paged**, and none states a maximum.
- **Note:** the counter-signal is in the same family of tickets. `SCRUM-638` item 19 —
  *"There are 76 assets in total, but the dropdown is not displaying all of them"* — was filed
  **as a defect**, and the remedy asked for in item 20 was progressive loading so the user still
  reaches every row. A capped `tree` reintroduces the same visible symptom by design. That does
  not make the branch wrong, but it is the one written data point and it points the other way.
- **Blocked:** sign-off of `feat/move-dropdowns-BE`; any decision on the cap value.
- **Owner:** Mohsin Ali for whether a truncated browse state is acceptable; Melissa McNutt for
  how operators actually pick a sub-category (browse vs. type).

## Saving a sub-category template re-mints every field id, orphaning asset attribute values

- **Status:** open
- **Asked:** 2026-09-02 — tracing the sub-category save path while making the detail page's
  Attribute Sections tab editable in place.
- **Question:** an asset stores its template answers in `asset.attribute_values`, a JSON blob
  **keyed by `CustomField.id`**. Saving a sub-category's attribute sections replaces the whole
  template — `upsertTemplateForSubCategory` does `sections: { deleteMany: {}, create: … }`, and
  `CustomSection.id` / `CustomField.id` are `@default(uuid())` — so every field gets a **new
  UUID** on every save, including a save that changed only a section's name. The old keys in
  `attribute_values` then match no field. Is losing the answers the intended behaviour when a
  template is edited, or should a field keep its identity across edits (and existing answers
  follow it)?
- **Why it matters:** the read path is `attrs[String(field.id)] ?? attrs[field.name]`. After a
  re-mint the id lookup misses, and the name fallback misses too, because the blob was written
  under the *old id*, never under the name. So every asset in the sub-category silently shows
  blank Additional Info, and the next asset save persists the blank over the orphaned data. It
  takes no schema change to trigger — renaming one section is enough.
- **Sources checked:** `apps/api/src/service/asset-management/sub-categories/`
  `sub-categories.repository.ts` (`upsertTemplateForSubCategory`, `mapTemplateSections`,
  `mapTemplateField` — no id is carried through), `apps/api/prisma/schema.prisma`
  (`CustomSection`, `CustomField`), `apps/web/src/features/assets/sub-category/utils/`
  `template-sections-helpers.ts` (`serializeTemplateSectionsForSubmit` drops `id` and forwards
  `legacyKey` only when present, which the sub-category deserializer never sets),
  `apps/web/src/features/assets/asset/components/asset-form-additional-field.tsx`
  (`getDynamicFieldKey` = `String(field.id)`). `assets.service.ts`'s
  `buildAttributeLabelByKey` maps `legacyKey` → name but is used **only for activity-log
  labelling**, not to remap stored values. No `decisions/` note covers template versioning.
- **Note:** pre-existing — the `/edit` page has always saved this way. It is recorded now
  because the detail page's in-place editing makes a template save one click away from any
  viewer, so the failure gets easier to reach. The same `deleteMany`+`create` shape is in
  `categories.repository.ts`, but category templates do not key asset answers.
- **Blocked:** any further work on template editing, on either surface; the migration that
  would be needed to carry existing `attribute_values` across a re-mint. Routing lines added
  2026-09-02 by tcg-scrum on a PR-review pass; the question text above is unchanged.
- **Owner:** product team — Brian Petros for whether a template field keeps its identity
  across edits (this is a data-retention question, not a UI one). Fouzan Shakil to sequence
  the fix once the answer exists.
- **Update 2026-09-28 (TCG-123):** the same re-mint orphans **quotations**, too, not only assets:
  `Quotation.additionalInfo` is `{ [quotationResourceId]: { [customFieldId]: value } }`, so
  every quote line using the sub-category also reads back blank after a template save. Linear
  TCG-123 (UAT remediation, created by syed haris) states the expected behaviour, "Saving a
  template should keep the existing answers on assets and quotations". On branch
  `fix/misc-fixes-2026-09-25` a template save now updates sections and fields in place
  (`service/asset-management/template-sections.reconcile.ts`, used by both the sub-category
  and the category repository), and the web sends each id back. That covers both halves. It
  does **not** restore answers that were already orphaned by earlier saves: nothing records
  the old-id→new-id mapping, so they cannot be recovered. The status stays open until the
  owner confirms that a field keeps its identity across edits. The ticket settles the
  behaviour for UAT, but no decision note records it.

## Editing a record on its detail page — is in-place tab editing the pattern, and what stays on /edit?

- **Status:** open
- **Asked:** 2026-09-02 — PR review of merged PR #470 / commit `8b286d84`, branch
  `feat/asset-tabs-inline-edit`; tcg-scrum escalation. **Not a ticket question:** the branch
  cites no `SCRUM-###` and has no `.ai/aidlc/SCRUM-###/` folder, so there is no `spec.md` §12
  to hold it. It does carry a `processed.log` row (2026-09-02, path C, haris), which records
  the interaction pattern as *"chosen by the user in-session"* — a session choice by the
  implementer, not a product decision, which is why it is asked here.
- **Question:** four parts, each answerable in a line. (a) Is editing tab content **directly
  on the detail page** the intended pattern for Asset Management, or should a detail page stay
  read-only with `/edit` the only editor? (b) If in place is right, **does `/edit` survive** —
  as shipped the same components render on both surfaces (`configuration-tabs.tsx` is reused,
  deliberately, so the two cannot drift), so the same fields are now editable in two places
  and a user can reach either. (c) Is the **split correct** — identity fields (name, category,
  billing code, permit required, target hours) on `/edit` only, tab content on detail? (d) Does
  this **generalise** to other modules' detail pages, or is it assets-only?
- **What shipped, so the question is concrete:** **five** tabs hold live fields with a
  Save/Cancel pair — Category → Attributes; Sub-Category → Attributes, Associated Field
  Assets, Substitution; Asset → Additional Info. The commit message counts **six** and
  includes Sub-Category → Assets List, but that tab renders `AssetsTable` with a create-asset
  dialog and has no dirty-tracked editor (`sub-category-show-view.tsx`:86–95) — a create
  affordance, not in-place editing. `/edit` is untouched and still reachable from each detail
  hero, which is what makes (b) a live question rather than a hypothetical.
- **Sources checked:** **Vault — nothing on where an asset record is edited.** [INDEX.md](../INDEX.md);
  this module's [INDEX.md](INDEX.md); [categories-and-sub-categories.md](categories-and-sub-categories.md)
  (0.3 KB, `status: unverified`) — its nearest bullet is *"Edit should re-direct to show page"*,
  which is about where an edit **lands**, and reads Show and Edit as **two surfaces**;
  [user-story-and-tasks.md](user-story-and-tasks.md) (`provenance: personal-space`) — yard,
  HubSpot, 2FA, customer and quotation stories only, **no asset or category detail-page story
  at all**; [tool-and-rigging.md](tool-and-rigging.md) (yard dashboard, utilization);
  [loading-list.md](loading-list.md); [fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md).
  `../decisions/` — 26 notes, and the only one in this neighbourhood is
  [2026-09-01-post-save-navigation-create-goes-to-detail.md](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md)
  (with its 2026-08-20 predecessor), which is **"post-save success path only"** — it settles
  where a save *lands*, never where editing *happens*. Vault-wide grep for
  `inline edit` / `edit in place` / `editable in place` returns **no hit** outside this
  register. Meetings: 8 files carry `module/assets`; a sweep for in-place / same-page editing
  language finds nothing on it.
- **The nearest written analogue is a different module, and it is unverified.**
  [projects-jobs/project-module/02-view-manage-job-details.md](../projects-jobs/project-module/02-view-manage-job-details.md):40,
  43, 58 says, of a **Job** detail page: *"Work description and notes are visible and
  editable"*, *"Any editable field can be updated and saved without affecting the linked
  quotation"*, and *"Each tab saves independently"*. So a tabbed detail page whose tabs are
  editable **is** written down once, for Jobs, `status: unverified`. Nothing says it
  generalises to assets, categories or sub-categories, and this register does not assume it
  does — that is part (d) of the question, not its answer.
- **Jira points both ways, and neither ticket is about a detail page.** Against:
  `SCRUM-207` (Done 2026-05-05) — *"Asset Management → Categories Tab – Show/Edit View,
  Navigation, and UX Issues"* — treats Show page and Edit mode as **distinct modes** and files
  arriving in Edit mode unasked as a **defect**: *"Clicking Create New Sub-Category / Create
  New incorrectly redirects to Category Edit mode instead of respective create forms"*, and
  *"In Edit mode, 'Last Updated On' is shown unnecessarily"*. `SCRUM-918` (To Do) *"Improve
  Edit Icon Styling in Categories → Sub-Categories"* assumes an edit icon, i.e. a separate
  destination. Loosely for: `SCRUM-823` (Done, Aiman Farooq) *"Add Save Button on All Tabs in
  Asset Creation"* — *"users can save the asset from any tab without navigating to the final
  step"* — the same instinct (commit from where you are) but in the **create wizard**, not the
  detail page. A search of `SCRUM` for asset + tab/edit/attribute/detail surfaces no ticket
  for this feature.
- **Note:** in-place editing makes post-save navigation **vacuous** for these five tabs — the
  user never leaves the detail page, so *edit → detail* is satisfied trivially. That is not the
  same as being authorised by it, and the note itself says it decides the success path only.
  The closest client-voiced *"don't make me leave the screen"* is
  [meetings/2026-06-22-sprint-4-additional.md](../meetings/2026-06-22-sprint-4-additional.md):93
  — a **Create PO** button in DAS that *"generates the PO for that vendor and job without
  leaving the screen"* — a create-in-context ask on a different surface, not a detail-tab
  editor.
- **Blocked:** sign-off of PR #470; whether `/edit` is retired, kept, or reduced to identity
  fields; whether the next module's detail page copies this or stays read-only.
- **Owner:** Fouzan Shakil for (a), (b) and (d) — he is the precedent-holder, having decided
  the post-save navigation convention the same way, and these are internal UI conventions the
  team can settle if the client has no view. (c) is product: route to TCG via Brian Petros if
  anyone disputes that identity fields belong on a form rather than a detail tab.

## Save and Cancel hidden until a section is dirty — intended, or an affordance nobody finds?

- **Status:** open
- **Asked:** 2026-09-02 — PR review of merged PR #470 / commit `8b286d84`, branch
  `feat/asset-tabs-inline-edit`; tcg-scrum escalation. No ticket, so no `spec.md` §12. Filed
  here because that is where the work surfaced; **the question is app-wide, not assets-only.**
- **Question:** two parts. (a) Is a commit affordance that is **absent until the first
  keystroke** acceptable on pages users have learned are read-only — how is a user meant to
  discover a field is editable before touching it? (b) Should undoing an edit **by hand**
  retire Save/Cancel, or should the pair stay until the user explicitly saves or cancels?
- **What shipped:** `apps/web/src/features/assets/shared/inline-edit-actions.tsx`:33 —
  `if (!isDirty) return null`, so the section header shows nothing at all until a change
  exists; once dirty it shows an amber *"Unsaved changes"* marker plus Cancel and Save.
  Dirtiness is **structural**, not a sticky flag: `shared/use-inline-draft.ts`:59–62 deep-compares
  the draft against the live server value, so typing a character and deleting it retires the
  pair exactly as Cancel would. Both behaviours are deliberate and documented in the file's
  own doc comment — the question is not what it does, but who chose it.
- **Sources checked:** **Vault — nothing on dirty state as a UI convention.** `../decisions/`
  (26 notes) has no form-interaction note; the only UI conventions decided so far are post-save
  navigation and archive-instead-of-delete, both app-wide and both Fouzan Shakil's. Vault-wide
  grep for `dirty` returns **three hits and no convention**: two are this register's create-prefill
  entry, one is a pointer to it from `../quotations/gaps.md`:100; the remaining matches are
  *"quick and dirty"* in payroll transcripts. `apps/web/AGENTS.md` → *Forms* sets failed-submit
  behaviour (focus the first invalid field, navigate to the offending step) and is **silent on
  dirty-state affordances** — and a build rule could not settle this anyway.
- **The same family is already open in this register.**
  [Create-form prefill from URL query params](#create-form-prefill-from-url-query-params--the-whole-contract-is-unwritten)
  Q3 asks whether a prefilled value counts as a user edit — *"should prefill mark the form dirty
  and trip the unsaved-changes guard, so Cancel prompts on a form the user never typed in?"*
  That is the same underlying question (what counts as a change, and what the UI owes the user
  once something does) reached from the create side. Both are cheapest to settle **once**, the
  way post-save navigation was, rather than per module.
- **Blocked:** sign-off of PR #470; the next screen that needs an in-place editor, which will
  otherwise copy this from precedent and harden it by repetition.
- **Owner:** Fouzan Shakil — an internal UI convention, same class as post-save navigation.
  Worth one line from Melissa McNutt on (a) if operators are the ones expected to discover it.

## One tab, one PATCH — and what the leave guard's Save means when several tabs are dirty

- **Status:** open
- **Asked:** 2026-09-02 — PR review of merged PR #470 / commit `8b286d84`, branch
  `feat/asset-tabs-inline-edit`; tcg-scrum escalation. No ticket, so no `spec.md` §12.
- **Question:** three parts. (a) Is **per-tab independent save** the intent for a sub-category
  — saving Attributes commits only attributes and leaves pending edits on Substitution still
  pending, unsaved, with their own Save button? (b) When the leave guard's Save flushes several
  dirty tabs and one of them fails validation or the API rejects it, the run **stops there**,
  so the tabs already flushed are committed and the rest are not — **is a partial commit
  acceptable**, and what should the user be told? (c) Does the Job-detail line *"Each tab saves
  independently"* apply beyond Job details, or was it only ever about Jobs?
- **What shipped:** three slices — `template`, `associatedResources`, `substituteSubCategoryIds`
  — each PATCHing `/sub-categories/:id` with only its own key, which the API applies behind
  separate `!== undefined` guards, so a rejected slice leaves the other two untouched
  (`apps/web/src/features/assets/sub-category/hooks/use-sub-category-inline-edit.ts`:66–136,
  212–248). `saveDirty` (:256–263) runs them **sequentially and returns on the first failure**:
  `if (attributes.isDirty && !(await attributes.save())) return false;` and so on. That is the
  partial-commit window in (b).
- **Not the question:** *sequential rather than parallel* is an engineering choice with a
  reason stated in the code and the commit message — all three PATCH the same row the API
  re-reads to build its activity diff, so overlapping writes would race. That needs no product
  call. What needs one is the **user-visible outcome** when the flush stops half-way.
- **Sources checked:** **Vault — nothing on save granularity for assets.** This module's
  [INDEX.md](INDEX.md), [categories-and-sub-categories.md](categories-and-sub-categories.md)
  (nothing on saving), [user-story-and-tasks.md](user-story-and-tasks.md),
  [tool-and-rigging.md](tool-and-rigging.md); `../decisions/` — 26 notes, none on save
  granularity, partial commits or unsaved-changes guards. The **one** written statement of
  per-tab independence anywhere in the vault is
  [projects-jobs/project-module/02-view-manage-job-details.md](../projects-jobs/project-module/02-view-manage-job-details.md):58
  — *"Each tab saves independently — navigating away does not lose unsaved work on another
  tab"* — `status: unverified`, about the **Job** detail page, and it says nothing about what
  happens when a multi-tab save fails part-way. That is (c).
- **Jira:** `SCRUM-823` (Done) *"Add Save Button on All Tabs in Asset Creation"* is the nearest
  ticket — *"users can save the asset from any tab without navigating to the final step"* — but
  it is the **create wizard** committing one record from any step, not three independent PATCHes
  against an existing record. No ticket covers per-slice save or partial-commit behaviour.
- **Blocked:** sign-off of PR #470; any error-handling design for the leave-guard Save; any
  reuse of this three-slice shape on another multi-tab detail page.
- **Owner:** Fouzan Shakil for (a) and (b) as internal conventions; (c) needs whoever owns the
  Job-details document to say whether that line was meant app-wide — route to TCG via Brian
  Petros if it is read as product intent rather than a developer's note.
## Edit-form leave confirmation offers Save — pointer, owned by admin

- **Status:** resolved 2026-09-12 — answer in
  [decisions/2026-09-12-edit-leave-confirmation-offers-save.md](../decisions/2026-09-12-edit-leave-confirmation-offers-save.md);
  owning gap [admin/gaps.md → *Edit-form leave confirmation offers Save…*](../admin/gaps.md#edit-form-leave-confirmation-offers-save-create-stays-leavecancel--app-wide-unwritten).
  Adjacent [*One tab, one PATCH…*](#one-tab-one-patch--and-what-the-leave-guards-save-means-when-several-tabs-are-dirty) (multi-tab leave-Save) remains open.
- **Asked:** 2026-09-12 — same PR-review escalation as the owning entry.
- **Pointer:** [admin/gaps.md → *Edit-form leave confirmation offers Save…*](../admin/gaps.md#edit-form-leave-confirmation-offers-save-create-stays-leavecancel--app-wide-unwritten). Adjacent here: [*One tab, one PATCH…*](#one-tab-one-patch--and-what-the-leave-guards-save-means-when-several-tabs-are-dirty) asks what leave-Save means on multi-tab asset editors; this pointer is the app-wide create/edit modal-button question.

## Job Type as a dimension of a resource type — pointer, owned by quotations

- **Status:** open — **answer owned by quotations**, per [STRUCTURE.md](../STRUCTURE.md) →
  *Where a question goes* (spans modules; the module likeliest to own the answer holds it).
- **Asked:** 2026-09-03 — Brian Petros, Teams message showing FCC's `Maintain → Resources → Resource
  Types` screen, where a resource type's *Unit/People* and *Estimate* configuration is keyed by
  **(job type, yard)**, not by the resource type alone.
- **Why it lands here too:** the asset-side half is real. FCC's resource type is TCG's
  `SubCategory`, and its *Unit/People* tab is `SubCategoryAssociatedResource` — which today has
  **no job-type key**, so if job type ships, associated resources gain a dimension.
- **Concrete already:** `FMS_UNIT_TYPE_EQUIPMENT` (161 rows) and `FMS_UNIT_TYPE_EMPLOYEES` (117)
  are keyed in FCC by `JobTypeYardID` and were seeded onto `SubCategoryAssociatedResource` **with
  that key dropped on every row** (`apps/api/fcc-seeder/docs/field-gaps.md:589,610`) — so a
  migrated tenant cannot show whether two job types differ in *Unit/People*, and rows may have
  merged. Costed in [quotations/gaps.md](../quotations/gaps.md#fcc-estimate-templates-were-already-extracted--and-the-seeder-flattened-them-to-one-fk).
- **Read:** [quotations/gaps.md](../quotations/gaps.md#estimate-defaults-per-resource-type--job-type--yard--fcc-has-them-tcg-has-no-job-type-at-all)
  · source: [quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md)
- **Update 2026-09-04 (Project Repository ingest):** the asset-side half now has rows behind it.
  The 2026-09-02 `03_UnitPeople_Resources` sheet (328 rows) shows the Unit/People requirement
  **does** differ by job type for 3 of the 17 resource types that have more than one configuration —
  190 Ton All Terrain, 350 Ton All Terrain, 550 Ton All Terrain w/Mega Wing, each by one tractor or
  one support load on the mobilisation-bearing configuration — and is identical for the other 14
  ([fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §6 → *Does the requirement
  differ per job type?*). The job-type domain on those configurations is `H` Hourly · `Z` Hourly
  w/ Mob · `B` Bare · `O` OCCIP/CCIP · *(none)* on 29 of 75 (§6 → *The job-type code list*), and
  the 42-row unit-type ↔ job-type allow list is transcribed at
  [fcc-unittype-jobtype-allow-list.md](../payroll/tcg-rawfms-staging-database/data/fcc-unittype-jobtype-allow-list.md).
  So `SubCategoryAssociatedResource` without a job-type key loses real rows for three
  sub-categories, not hypothetical ones. Legacy fact; the decision stays with quotations, per the
  pointer above.

## Nomenclature for the template level — "Resource Type", not "Unit"

- **Status:** open
- **Asked:** 2026-09-03 — Brian Petros, third Teams message of the day, closing his FCC table map:
  *"Physical units such as a particular crane/unit code are elsewhere in `FMS_UNITS` and are
  associated to these Resource Types through the Unit Type configuration… So in the new ERP
  nomenclature I would explicitly call these **Resource Types**, not Units, to avoid confusing the
  template with the individual fleet asset."* It corrects his own earlier framing of the FCC
  *Main* tab as a list of units.
- **Question:** what does the ERP call the level that FCC calls a Resource Type — the thing a
  quotation line and a template attach to, as against a physical crane with a unit code? Brian is
  right about the data; adopting his word is still a decision, because **"resource" is already
  spent in this codebase on something else**: `QuotationResource` and `JobResource` are line items
  on a quote or job, and `SubCategoryAssociatedResource` is what a sub-category drags along.
  Renaming the taxonomy level to *Resource Type* would put three different meanings of "resource"
  in one schema; leaving it as `SubCategory` keeps a name no client uses. A third option is to use
  *Resource Type* in the **UI language only** and leave the model names alone.
- **Sources checked:** [quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md)
  §5; [fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) (schedule type ≈ Category,
  unit type ≈ Sub-Category); built state — the FCC seeder maps all 68 `FMS_UNIT_TYPES` rows onto
  `SubCategory` (`apps/api/fcc-seeder/docs/seed-files-index.md:20`), while the schema *also* carries
  an unused `UnitType`/`UnitCategory`/`ResourceCategory` trio whose only web surface,
  `/asset-management/unit-types`, renders "This module is under development".
- **Note:** whatever is chosen, `UnitType` vs `SubCategory` is a **live duplication** independent of
  the naming question — two models for one FCC table, one of them unpopulated. Worth settling in
  the same pass.
- **Owner:** CodingCops for the model names; TCG (Brian Petros / Dylan Masterson) for the UI word.
- **Update 2026-09-04 (Project Repository ingest):** more usage evidence, still no decision.
  (a) **The module owner uses Brian's word unprompted** — Joe, 2026-09-02: *"share with them the
  pictures of the resource types, which is how the quotes populate currently"*, correcting Brian's
  *schedule types* to **resource types**
  ([2026-09-02 sprint demo](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md)
  item 2). (b) FCC itself is inconsistent: the table is `FMS_UNIT_TYPES`, the Units window's
  header filter says **Unit Type**, the Components & Tools header and the `Maintain → Resources`
  menu say **Resource Type(s)**, and the import template's tab is `5. Resource Types`
  ([asset-record-requested-additions.md](asset-record-requested-additions.md) → *The `Maintain →
  Resources` menu*, *Components & Tools*; [fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md)
  §7); the client's README states the equivalence outright — *"Resource Type = FMS_UNIT_TYPES… a
  configuration/template concept, not an individual physical Unit"*
  ([../quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md)
  §7). (c) One more collision to weigh: FCC's *Resources* menu covers Units, Components & Tools,
  Customer Owned Units and Resource Types alike, so in the client's vocabulary "resource" already
  spans the physical and the template level. Still needs the decision the entry names — model
  rename, UI-only, or leave as is — and the `UnitType` / `SubCategory` duplication.

## Samsara vehicle tracking — what was committed is "vehicle locations in real time", and an 11k-line module shipped around it

- **Status:** open
- **Asked:** 2026-09-04 — raised while sourcing the product intent behind branch
  `Fetaure/samsara-integration` (commit `7515a638`, 2026-09-03), which ports a standalone app
  into the repo as a `vehicle-tracking` module. The branch has no `.ai/aidlc/SCRUM-###/`
  folder and no `processed.log` row; it never ran the loop.
- **Question:** **Beyond live vehicle locations, what is in scope for the Samsara integration
  — and does TCG want vehicle history and route replay in the ERP now?** One line settles it:
  *live map only*, or *live map plus per-vehicle day history and route replay*.
- **Sources checked:** **Half of it is sourced, from the delivery side, and only half.** Abdul
  Rehman committed the scope to the client on the 2026-09-02 call, one day before the commit:
  *"We will do this in this print before 15th of September, plus the payroll module completion
  and the Samsara integration as well, with the limited capabilities where we will see all our
  vehicles locations in real time"*
  ([../meetings/transcripts/2026-09-02-erp-job-tickets-and-payroll.md](../meetings/transcripts/2026-09-02-erp-job-tickets-and-payroll.md)
  57:15, `status: reference`), recorded in the curated minutes as *"Next two weeks: … Samsara
  vehicle locations …"*
  ([../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md)
  → *Client verdict on the demo*). Same speaker, same commitment, three weeks earlier:
  *"right now, this GPS tracking is not real. For this, we will have to integrate the Samsara.
  We'll add it in the next print so that we can have a real-time tracking"*
  ([../meetings/transcripts/2026-08-12-erp-sprint-review.md](../meetings/transcripts/2026-08-12-erp-sprint-review.md)
  24:05). **Client-side asks corroborate the live-location half and nothing beyond it** —
  Melissa McNutt: *"It'd be nice if Samsara could integrate with our dispatch with our system
  so we can verify … instead of having to do it manually"*
  ([../meetings/transcripts/2026-03-06-sales-quoting-figma-demo.md](../meetings/transcripts/2026-03-06-sales-quoting-figma-demo.md));
  Joe Schacatano asks for asset positions *inside a job*, not a fleet-wide page
  ([../meetings/transcripts/2026-02-27-dispatch-scheduling-demo.md](../meetings/transcripts/2026-02-27-dispatch-scheduling-demo.md)).
  **The history/route-replay half is the opposite of sourced.** The only time route replay was
  put to the client it was declined — Ryan Adams proposed sending a Samsara route map; Melissa
  McNutt: *"No. I don't think we need that in the customer packet"*; Wes Staley: *"we want the
  full vision … it's not like needed today. **It's not like a requirement.**"*
  ([../meetings/transcripts/2026-05-12-loading-figma-demo.md](../meetings/transcripts/2026-05-12-loading-figma-demo.md)
  40:04–40:46). That exchange is about a **customer packet**, not an internal page, so it does
  not forbid the feature — it is simply the only thing TCG has ever said about route history,
  and it is *"not a requirement"*. **The umbrella scope question is still formally Open:**
  [../field-ops/frd-new-format-draft/08-open-questions.md](../field-ops/frd-new-format-draft/08-open-questions.md)
  #9 — *"What information from Samsara will be available in V1 and what is the integration
  scope?"*, owner **Mashood**, **Open** (`status: unverified`); also
  `../field-ops/field-ops-frd/11-open-questions-future-considerations.md` #10, `../brs.md`
  **BRS-INT-002** / **OD-010** (both *"Needs Documentation"*), and TCG's RFP, which asks only
  for a *"GPS/telematics pull for vehicle hours and location"*
  ([../admin/tcg-erp-rfp-2026-02-26.md](../admin/tcg-erp-rfp-2026-02-26.md), client-authored,
  `status: unverified`). `decisions/` holds **no Samsara decision** — the only mention is
  [../decisions/2026-09-01-subsistence-not-a-craft-attribute.md](../decisions/2026-09-01-subsistence-not-a-craft-attribute.md)
  → *What it does not settle*, which lists *"whether Samsara supplies it"* as still open, two
  days before the commit. `README.md` → *What this vault does not contain* does not exclude
  Samsara, so the absence is a gap, not policy. **Jira could not be checked** — the MCP search
  returns `403 Tenant is restricted: suspended-payment`.
- **Note:** the branch's own authority is *"Owner, 2026-09-02"* in
  `docs/vehicle-tracking-migration-progress.md` — an unnamed internal owner making engineering
  calls — and the plan it defers to (`Projects/samsara-vehicle-tracker/docs/MIGRATION-TO-CRANEGUYS.md`)
  is outside this repo and unreachable. **No named person with product authority appears
  anywhere in the record for the port.** That same file records its own step 10 as outstanding:
  *"the §9 domain knowledge belongs in `.ai/vault/` as a new page"*. Nothing in `meetings/`
  mentions porting a standalone tracker app into the ERP at all.
- **Blocked:** whether the history and route-replay half of the module ships for the
  15 September walkthrough, or is held. The live-map half is covered by Abdul's commitment and
  is not blocked by this entry.
- **Owner:** product team — Mashood already owns FOP open question #9; Brian Petros or Wes
  Staley for whether route history is wanted internally now.

## One Asset ↔ one Samsara asset — the record says a crane's GPS box is on a *different* asset, and reads only one of its two engines

- **Status:** open
- **Asked:** 2026-09-04 — raised while sourcing branch `Fetaure/samsara-integration`
  (commit `7515a638`).
- **Question:** **How many Samsara links does an Asset carry, and may two Assets share one
  Samsara device?** Three lines settle it: (a) may the crane *and* its support tractor both
  resolve to the tractor's Samsara asset; (b) does a two-cab crane need an upper and a lower
  link, or does the ERP keep upper hours manual as FCC does; (c) is the link Samsara-only, or
  must it name a telematics provider as FCC's does?
- **Sources checked:** The branch adds `Asset.samsaraAssetId` + `Asset.samsaraAssetType` with
  **`@@unique([tenantCompanyId, samsaraAssetId])`**, and a `canTrackAsset()` rule offering
  Track only when the linked Samsara asset's type is `vehicle`
  (migration `20260902130000_add_asset_samsara_link`). **The record contradicts that
  cardinality twice, in the same meeting, from two named TCG people.** Brian Petros, on why
  one device cannot mean one asset: *"there's a couple cranes that the GPS device cannot be put
  on the crane itself … There's a support vehicle for those two cranes that is like assigned to
  the crane … So the GPS device is on that tractor, not on the crane itself, because … it
  messes with the electrical and then the crane starts malfunctioning"*
  ([../meetings/transcripts/2026-08-26-erp-sprint-review.md](../meetings/transcripts/2026-08-26-erp-sprint-review.md)
  18:11–18:49, `status: reference`). Corrina Bustos, on why one link cannot cover one machine:
  *"Samsara only reads off one engine and some cranes have two cabs … the engine that actually
  drives it, but then some have the engine or the cab of where they actually operate the crane
  from and those hours need to be recorded as well. So that's why they do it manually because
  Samsara doesn't pick up on both of those"* (same file, 21:48). A unique index means the
  tractor and the crane it carries cannot both point at the one device that tracks them.
  **The written precedent has a different shape too.** FCC's unit record carries
  **`UpperGPS`, `LowerGPS`, `UpperGPSID`, `LowerGPSID`** — the first pair a *telematics
  provider selector*, the second pair *that provider's asset id*
  ([fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §Identity;
  `status: unverified`); the client's annotated deck shows the meter screen with **`Lower GPS`
  = `Samsara`** and **`Asset Id` = a 15-digit provider id**, no `Hours/Upper` column, and
  states *"Only lower engines are tracked by Samsara. Upper engines are entered manually…
  Samsara is not in upper engines"*
  ([asset-record-requested-additions.md](asset-record-requested-additions.md) §3 and
  §*Meter (slide 9)*, `status: unverified`); provider is a registry, not a constant —
  `Maintain > GPS` lists *Fleet Complete, Fleet Matics, Indus Track, QualComm*
  ([../field-ops/fcc-nexgen-service-guide.md](../field-ops/fcc-nexgen-service-guide.md) →
  *GPS Information*). That same deck marks the area unresolved in the client's own words —
  *"Need to discuss how this information will be managed in relation to Samsara data/tracking"*,
  twice. The dual-engine question is separately recorded as open since March 2026
  ([../admin/responsive-design-and-security-posture.md](../admin/responsive-design-and-security-posture.md)
  Part 3). The only supporting principle found is generic: Abdul Rehman, *"every integration,
  even for the ADP or for the QBooks as well, we will keep every external ID in our database"*
  (same 2026-08-26 review, 12:30) — which justifies **having** a link field, not its cardinality.
  **Nothing anywhere states the one-to-one rule, the per-tenant uniqueness, or the
  `vehicle`-only restriction.** The branch's own `docs/vehicle-tracking-migration-progress.md`
  §Step 11 attributes the tracking rule to *"three things the owner asked for after seeing the
  feature run"*, on technical grounds — trailers and equipment have no position feed — not a
  product one.
- **Update 2026-09-22 (FCC ↔ Samsara reconciliation — the data side of (a) and (b)):** the
  client's own comparison workbook settles two of the three lines *as FCC data*, though not as
  product intent. Measured from `FMS_UNITS` (2026-07-02 extract) in
  [fcc-samsara-reconciliation-2026-09-21.md](fcc-samsara-reconciliation-2026-09-21.md):
  **(b) is corroborated** — `UpperGPS` and `UpperGPSID` are populated on **0 of 358** units
  while `LowerGPS` (`SA` only) and `LowerGPSID` carry 46 and 49, the first data-side
  confirmation of the deck's *"Samsara is not in upper engines"*. **(a) has four live
  counter-examples** — the 49 ids are only **45 distinct**, with `10004`+`AT07`,
  `ST12`+`2202`, `SL03`+`AT03` and `SL04`+`AT05` each sharing one Samsara id. So the source
  system the ERP migrates from **does** let two units point at one device, which
  `@@unique([tenantCompanyId, samsaraAssetId])` forbids. Every collision pairs one active with
  one inactive unit, which reads as a moved gateway never cleared off the old record — if that
  is the explanation, the unique index survives (clear the inactive side) and the workbook's
  top-severity `10004` finding dissolves with it. **That reading is inference; nobody has
  confirmed it**, and it does not answer the Brian Petros case the entry was opened on, where
  the crane and its support tractor are *both* current. **(c) remains untouched** — the
  extract's provider column holds only `SA`, so the registry question is still open on the
  record, not in the data. Also relevant to *Blocked*: the seeder does not map `LowerGPSID`
  into `samsaraAssetId` at all (`apps/api/fcc-seeder/src/extract-seed-files.ts`), so the 45
  links FCC already holds are being dropped on import.
- **Note:** the per-tenant unique index also contradicts the module it serves. The tracking
  controller's own header says *"Nothing here is tenant-scoped, because the Samsara account is
  not per-tenant: every tenant sees the same fleet"* — so one Samsara asset is visible to every
  tenant on the map while the schema lets each tenant claim it once. One of those two is wrong
  whichever way this entry is answered.
- **Blocked:** the `assets` schema (a second link, a provider column or a dropped unique are
  each a migration, not a patch), the Track Asset button and list column, and the Samsara
  picker on the asset form.
- **Owner:** product team — Brian Petros and Corrina Bustos already stated the two constraints
  above; they own the answer.

## The fleet day — "today" is one hardcoded timezone, and no source defines a fleet day

- **Status:** open
- **Asked:** 2026-09-04 — raised while sourcing branch `Fetaure/samsara-integration`
  (commit `7515a638`).
- **Question:** **In whose timezone does a fleet day start?** Options, so one line settles it:
  (a) one company-wide constant, as built; (b) the yard the asset belongs to; (c) the tenant;
  (d) whatever boundary payroll ends up using. Second line: must the fleet day agree with the
  job/payroll day, given both count hours against the same machine and crew?
- **Sources checked:** The branch measures every *"today"*, every day boundary and every
  per-day total (drive time, on-site time, miles) against a single `FLEET_TIMEZONE` environment
  variable defaulting to **`America/Los_Angeles`**
  (`apps/api/src/config/vehicle-tracking.config.ts`,
  `apps/api/src/usecase/vehicle-tracking/fleet-day.ts`). **No vault source defines a fleet day,
  a fleet timezone or a company timezone**, and a full sweep of `meetings/` (65 transcripts,
  17 curated minutes, 8 summaries) found no statement of one — the only `PST` hits there are
  meeting-scheduling chatter. Everything written points the other way. Payroll's week is
  Saturday–Friday (`PAY-001`) but *"**no workday-start concept exists anywhere in the vault**…
  every daily-OT rule in the register presumes a workday boundary nobody has defined"*
  ([../payroll/payroll-rule-dependency-matrix.md](../payroll/payroll-rule-dependency-matrix.md)
  row 14, `status: unverified`). The same ambiguity is already open elsewhere:
  `../quotations/gaps.md` asks *"in whose timezone is that day defined?"* of quote expiry;
  `../admin/gaps.md` → *Time display — military, 12-hour, or per-user* is open. TCG has raised
  the day boundary twice without resolving it — Brian Petros: *"do you apply it to the day that
  it started? … or the day it ran past midnight, if it's a holiday or whatnot"*
  ([../meetings/transcripts/2026-03-03-it-coordination-and-wireframe-demo.md](../meetings/transcripts/2026-03-03-it-coordination-and-wireframe-demo.md)),
  and *"a lot of the jobs go past midnight. So visually, it's really helpful to see that it is
  actually the next day"*
  ([../meetings/transcripts/2026-09-02-erp-job-tickets-and-payroll.md](../meetings/transcripts/2026-09-02-erp-job-tickets-and-payroll.md)).
  The only `America/Los_Angeles` in the whole vault is **ADP's `timeZoneCode` on the worker
  record** ([../payroll/adp-api-responses/workers-meta.md](../payroll/adp-api-responses/workers-meta.md)
  — *"consistent with a California employer"*): an observation about a payroll vendor's data,
  **not a product decision and not a fleet-day definition.**
- **Note:** the default is not inert — `env.validation.ts` supplies it, so a deployment that
  sets nothing still gets Pacific silently, with nothing on screen saying which boundary a
  figure was computed against. And TCG is not single-site: yards are a first-class module in
  the review log's own list ([../erp-review-log.md](../erp-review-log.md)), and the platform is
  multi-tenant, so a single process-wide constant is a stronger assumption than anything
  written supports.
- **Blocked:** the day picker, the day summary and every per-day figure on the tracking pages;
  and any later reconciliation of tracked hours against field-ticket or payroll hours, which
  cannot be compared until both agree what a day is.
- **Owner:** product team — Brian Petros; Corrina Bustos if it must line up with payroll.
- **Update 2026-09-09 (SCRUM-TZ decisions) — the boundary is answered for the *business* day; the
  three-way agreement this entry asks about is not.** Two `status: reference` decisions by Syed
  Haris (developer/owner — **not** Brian Petros or Corrina Bustos, the owners named above, neither
  of whom has spoken to this) answer the first line of the question, for the business day only:
  the zone is a **property of the tenant**
  ([../decisions/2026-09-09-business-timezone-is-a-tenant-property.md](../decisions/2026-09-09-business-timezone-is-a-tenant-property.md)
  — option **(c)** of the four listed above, under a recorded constraint that every tenant today
  operates in exactly one zone), and the day starts at **00:00 in that zone**
  ([../decisions/2026-09-09-business-day-starts-at-midnight-local.md](../decisions/2026-09-09-business-day-starts-at-midnight-local.md)),
  which also closes the `WorkdayStartTime` hole this entry quotes from
  [../payroll/payroll-rule-dependency-matrix.md](../payroll/payroll-rule-dependency-matrix.md)
  row 14. **Why this entry nonetheless stays open:** its second line — *must the fleet day agree
  with the job/payroll day?* — is a three-way alignment question, and nothing decided says the
  **fleet** day adopts the business day at all. **It does not, and this is now shipped rather
  than hypothetical: `Fetaure/samsara-integration` has merged, and `FLEET_TIMEZONE` is live on
  `main`.** Verified on `main` 2026-09-09:
  `apps/api/src/usecase/vehicle-tracking/fleet-day.ts:29` resolves
  `process.env.FLEET_TIMEZONE || DEFAULT_FLEET_TIMEZONE` — `||` rather than `??` deliberately, per
  its own comment, because *"a blank value from a secrets store or an empty Docker ARG is as good
  as absent, and an empty zone string throws inside dayjs"*;
  `apps/api/src/config/env.validation.ts:79` supplies the default
  (`Joi.string().optional().empty('').default(DEFAULT_FLEET_TIMEZONE)`); and
  `packages/shared/src/constants/vehicle-tracking.ts:27` sets `DEFAULT_FLEET_TIMEZONE =
  'America/Los_Angeles'`. **Web carries a second copy of the same setting** —
  `apps/web/src/features/vehicle-tracking/utils/fleet-date.ts:33` reads
  `NEXT_PUBLIC_FLEET_TIMEZONE`, with `apps/web/.env.example:37` instructing that it *"Must match
  the API's FLEET_TIMEZONE"*: two environment variables kept in step by hand, on two surfaces, with
  nothing failing if they drift. So the silent-default defect this entry describes is not only
  untouched, it has shipped and doubled. **And it contradicts the 2026-09-09 grain decision on its
  face** — a process-wide constant promoted to an env var is precisely the shape
  [../decisions/2026-09-09-business-timezone-is-a-tenant-property.md](../decisions/2026-09-09-business-timezone-is-a-tenant-property.md)
  decided against; `cdc34c30` collapsed three competing definitions of *"what day is it"* onto one
  while a **fourth** was merging into `main` in parallel. Note also that the two implementations
  do not share a library: `fleet-day.ts` uses **dayjs** (`dayjs/plugin/timezone`) while
  `packages/shared/src/utils/business-time.ts` uses native **`Intl`** and no dayjs — and only the
  first is on `main`, the second existing so far only on `fix/timezone-business-day`. Closing this
  entry would assert an alignment nobody decided.
- **Update 2026-09-09, later the same session (SCRUM-TZ Q9) — the fleet half is now decided; the
  entry narrows to one surviving question and stays open.**
  [../decisions/2026-09-09-fleet-timezone-retired-onto-tenant-zone.md](../decisions/2026-09-09-fleet-timezone-retired-onto-tenant-zone.md)
  (`status: reference`; Syed Haris, developer/owner — **not** Brian Petros, and not whoever owns
  the Samsara integration, the two owners this question is nominated to) **retires
  `FLEET_TIMEZONE`, `NEXT_PUBLIC_FLEET_TIMEZONE` and `DEFAULT_FLEET_TIMEZONE` in favour of
  `TenantCompany.timezone`**, and converges `fleet-day.ts` and `fleet-date.ts` off dayjs onto
  `packages/shared/src/utils/business-time.ts` (native `Intl`) so there is one implementation of
  *"what day is it"*, not two. **Why that is safe, verified on `main`:** Samsara never receives a
  timezone — `apps/api/src/service/samsara/samsara.repository.ts` passes only `startTime` /
  `endTime` as absolute RFC 3339 at all three call sites (`:242`/`:253`, `:292`/`:309`,
  `:346`/`:359`), and `fleet-day.ts` states it: *"It is the same instant either way; Samsara takes
  RFC 3339 with any offset."* The zone chooses **which instants to ask for**, and tells Samsara
  nothing, so the retirement cannot break the integration's contract.
  **Disposition of this entry's two questions:** *"In whose timezone does a fleet day start?"* is
  **answered** — the tenant's, at 00:00, and the fleet day now has no other source. *"Must the
  fleet day agree with the job/payroll day?"* is **answered for two of the three**: the fleet day
  and the payroll/business day are the same value by construction, one column and one
  implementation. **What survives, and why this stays open:** nothing decided says the **job** day
  is derived through `business-time.ts`. `jobDate` is a `@db.Date` calendar date, which
  `business-time.ts` classifies as a value that *"has no timezone at all"* — a different kind of
  question from the other two, and closing here would assert an alignment nobody stated. The
  *Blocked* line above is otherwise discharged: the day picker, the day summary, every per-day
  tracking figure and the fleet-vs-payroll reconciliation are unblocked.
  **Known consequence, recorded so it is not found mid-implementation:** `business-time.ts` has
  **no RFC 3339-with-offset formatter** — `formatInstant` (line 264) is `Intl.DateTimeFormat` for
  human display. `fleet-day.ts` currently emits dayjs `.format()` (`2026-09-08T00:00:00-07:00`)
  deliberately, so *"a logged window reads as the times the drivers would recognise"*. Samsara
  accepts `Z` equally so nothing breaks functionally; converging loses that log readability until
  a small formatter is added. **Not a blocker.**
  **Stays open**, now needing only: **does the job day share this boundary too?** Narrow enough
  that it deserves re-filing as its own entry — flagged, not done.

## Quick-create a Tool & Rigging item from the quotation picker — who may, and what does its quantity mean?

- **Status:** open
- **Asked:** 2026-09-09 — PR review of `fix/quotation-permits-plans`, commit `2f7b0a1a0` (no ticket, no `processed.log` row, no ticket folder).
- **Question:** the branch adds an *"Add New"* footer to the Tool/Rigging picker **inside a quotation**, opening a slim modal (**name**, **quantity**, **needs spotter**) that creates a real catalog Tool record without leaving the quotation form (`apps/web/src/features/assets/tools-riggings/components/quick-create-tool-modal.tsx`). Three answers needed. **(a)** May a salesperson create a catalog tool at all, or is catalog creation the yard's? **(b)** If yes, is a three-field record acceptable, given the full form's *"mandatory information before saving"*? **(c)** What is the **quantity** the modal collects — total inventory owned, or the quantity wanted on this quote?
- **Sources checked:** [tool-and-rigging.md](tool-and-rigging.md) — the 3.7 KB spec, `status: unverified`, and the file the migration deliberately kept over a 38-character newer stub ([../README.md](../README.md):210-211). **Story 1** makes creation the **yards manager's**: *"As a **yards manager**, I want to create and configure tools and rigging items…"*, *"Tools & Rigging exists as **a separate section under Asset Management**"*, *"**Tool creation requires mandatory information before saving**"*, and it is where **Needs Spotter** is specified — *"Every tool record has a Needs Spotter checkbox that can be turned on or off during creation or editing"*. **Story 3, the quotation story, is selection only** — *"I want to **add** tools and rigging during quotation creation"*, *"Quotation workflow supports tools and rigging **selection**"* — it contains no create affordance. **Story 5 is the one place a creation pop-up is authorised, and it is Dylan's yard dashboard**: *"Dylan can add tools and rigging from this dashboard, a creation pop up will be displayed"*. The three modal fields do match what the catalog is known to carry — ehtesham.anwar @ 45:18, [../meetings/transcripts/2026-05-12-loading-figma-demo.md](../meetings/transcripts/2026-05-12-loading-figma-demo.md):222: *"the information that we have is the tool and rigging name, the tool name itself, and then the quantity that we have in the inventory"* — and Needs Spotter is Brian Petros's own ask, [../meetings/transcripts/2026-05-07-loading-and-project-module-overview.md](../meetings/transcripts/2026-05-07-loading-and-project-module-overview.md):135-136.
- **Note — the nearest precedent went the other way, on permissions.** The one recorded conversation about creating a catalog record inline from a quotation line is the **billing-code** thread: Melissa McNutt asks for a quick-add (*"could it auto-populate as a billing code where we don't have to go back and create a billing code? It'll create it here"*), mohsin.ali proposes an *"add new billing code"* button, and ehtesham.anwar closes it down — *"**the problem with that is we don't know if the person has the right access** and most probably sales people won't have access… let's add this to the approval system instead of creating new functionality"* ([../meetings/transcripts/2026-05-05-tcg-erp-system.md](../meetings/transcripts/2026-05-05-tcg-erp-system.md):460, :486, :487; already summarised at [*Billing-code create form prefill*](../quotations/gaps.md#billing-code-create-form-prefill-six-query-params-no-producer-no-source)). That is a **meeting record, not a commitment**, and a tool is not a rate — but it is the same shape of question and it was answered against. Pulling the other way: FCC puts a **`New` button beside every lookup on the quote Main tab** (Customer, Job Site, Report To, Quoted To) — but **not** on its Tools/Rigging tab, whose Category list is maintained separately under `Maintain → Tools` ([../quotations/fcc-nexgen-quote-entry.md](../quotations/fcc-nexgen-quote-entry.md):202-215). The open twin of this question is [*Can a Report To contact be created inline from the quotation form?*](../quotations/gaps.md#can-a-report-to-contact-be-created-inline-from-the-quotation-form) — same branch-review shape, still unanswered.
- **Note on (c) — the quantity is the field this register already says is undefined.** The modal requires a finite integer ≥ 0. [*Loading list — quantity, sets, and sizes are underspecified for a schema*](#loading-list--quantity-sets-and-sizes-are-underspecified-for-a-schema) records that **`Boscaro Bar` carries quantity `N/A`** where all 25 other real catalog rows carry an integer, and that *"a required-integer quantity column cannot store this row"*; that set-granularity rows (`Container Hooks (Set of 4)`, `Jensen Lifter Sets`) leave the tracked unit undecided; and that **no `decisions/` note touches tool quantity**. A create path that makes an integer quantity mandatory settles that open question by default, in a modal, without anyone deciding it. Note too that the quotation-line quantity is a *request against a finite pool* that Dylan reconciles ([../meetings/transcripts/2026-04-30-dispatch-scheduling-figma-demo.md](../meetings/transcripts/2026-04-30-dispatch-scheduling-figma-demo.md):45), i.e. a **different number** from inventory-owned — so (c) is not cosmetic.
- **Note on the punch list:** [../quotations/quotation.md](../quotations/quotation.md):15-16 carries *"tools and rigging – total inventory"* and *"button should be renamed as **add tool**"* — JZ, 2026-06-23, `status: unverified`, two unelaborated bullets on a **cross-module** punch list. They are the only written words about a button in this picker, they do not say whether "add tool" means *add a row to the quote* or *create a tool in the catalog*, and the branch labels its new control *"Add New"* either way. Not a source; noted so it is not later read as one.
- **Blocked:** nothing functionally. What is at risk is a catalog whose records were created three-fields-at-a-time from a sales form, by people the spec assigns to the yard.
- **Owner:** Dylan Masterson / the yard for who may create a catalog tool (Story 1 and Story 5 are both his), with Brian Petros on the salesperson-permission question the billing-code thread parked.

## Fleet tracking map — how a selected vehicle must be indicated is written nowhere

- **Status:** open
- **Asked:** 2026-09-09 — raised while reviewing branch `scrum-252` ("Implement map view in
  DAS"), which replaces the shipped tracking map's vehicle marker with a truck icon shared with
  the new DAS map. The branch has no `.ai/aidlc/SCRUM-252/` folder and no `processed.log` row;
  it never ran the loop.
- **Question:** **On the fleet tracking map, how must the vehicle the user has open be
  distinguished from the rest of the fleet?** One line settles it: *a size increase and a
  brand-coloured ring* (what shipped), *stacking order alone*, or *something else*.
- **Sources checked:** **Nothing in the vault describes the tracking map's UI at all**, so
  there is no source to weigh. `decisions/` holds no Samsara or tracking decision. `../brs.md`
  **BRS-INT-002** (*Samsara Reconciliation*, "Needs Supporting Documentation") and **OD-010** /
  **OD-012** are scope and GPS-enforcement placeholders, not screen behaviour.
  `../admin/responsive-design-and-security-posture.md` → *Part 3 — Samsara integration* covers
  credentials and usage, not the map. `../dispatch/daily-allocation-system.md` → *USER STORY :
  Live Asset Map View* (`status: unverified`, updated 2026-04-30) specifies click-to-sidebar for
  the **DAS** map and says nothing about a selected-marker treatment on either map. `meetings/`
  yields nothing on marker design. This sits **inside** the larger unsourced area already
  recorded above: [*Samsara vehicle tracking — what was committed is "vehicle locations in real
  time", and an 11k-line module shipped around it*](#samsara-vehicle-tracking--what-was-committed-is-vehicle-locations-in-real-time-and-an-11k-line-module-shipped-around-it),
  which establishes that **no named person with product authority appears anywhere in the record
  for the whole module.** So the affordance being removed was never specified either — the
  question is whether it was nonetheless the right behaviour.
- **Note:** what changes concretely. `isSelected` now affects only z-index; the marker no longer
  grows and no longer gains a ring
  (`apps/web/src/features/vehicle-tracking/components/map/vehicle-marker.tsx`). `ROUTE_TOKENS.selected`
  in `apps/web/src/features/vehicle-tracking/components/map/map-settings.ts:50` — documented in
  place as *"the ring around the marker of whichever vehicle is open"* — is left with **no
  consumer** (`route-polyline.tsx` reads only `ROUTE_TOKENS.line`). Because nothing is written,
  the removal cannot be called a regression **or** an improvement from the record; it is an
  unreviewed change to a shipped screen. Not a licence to restore it on judgement alone.
- **Blocked:** merging `scrum-252`'s change to the **existing** tracking screen — the new DAS map
  is not blocked by this. Also blocks deleting or keeping the now-dead `ROUTE_TOKENS.selected`
  token.
- **Owner:** product team — Brian Petros (named owner on the Samsara scope entry above), with
  whoever owns the Samsara integration.
- **Update 2026-09-10 (SCRUM-252 backfill):** **the code this entry describes has moved on; the
  question has not.** The *Note* above was written against commit `b69d5406`. At `fbaebb9f` the
  selection cue is back as a **size step** — `RESTING_SIZE` 46 → `SELECTED_SIZE` 58 in
  `vehicle-marker.tsx`, animated via `transition-[width,height]` — so `isSelected` no longer
  affects only z-index. The **ring** is still absent, and is now absent *deliberately*, with the
  reasoning stated in place: it *"read as a second element around the body rather than as the
  same object"*. The dead `ROUTE_TOKENS.selected` token and its comment describing a ring that no
  longer exists were **removed** from `map-settings.ts` (nothing referenced it), which discharges
  the second half of the *Blocked* line above.
  **Stays open.** A developer choosing a size step over a ring is still an unreviewed change to a
  shipped screen decided from no written source — which is what this entry exists to say. The
  entry's own warning holds in both directions: nothing written makes the ring right, and nothing
  written makes its removal right either. Ticket record:
  [`../../aidlc/SCRUM-252/spec.md`](../../aidlc/SCRUM-252/spec.md) §14.
## Branch fix/das-fixes — a quote may request more tools than exist, and "available" is now two numbers

- **Status:** open
- **Asked:** 2026-09-11 — PR review of branch `fix/das-fixes` (no ticket, no `.ai/aidlc/` folder); tcg-scrum escalation. Commit `8ecc80e1d`.
- **Question:** four parts, each answerable in a line. **(a)** May a quotation request **more of a tool than the catalog says exists**? The branch turns the blocking error into a hover warning — `getToolQuantityAvailabilityError` became `getToolQuantityAvailabilityWarning`, *"Exceeds available inventory (max N)"* (`apps/web/src/features/quotations/utils/tool-quotation-availability.ts`), and `isToolSelectable` now returns `true` unconditionally, so a tool with **zero** available is still pickable. **(b)** Should the **tool detail page** carry an *overages* section listing the quotations that over-request it (`GET /asset-management/tools/:id/quotation-overages`, `tool-quotation-overages-section.tsx`), and is *"not archived, and status not in `LOST` / `EXPIRED`"* the right definition of live demand — it counts `DRAFT`, `SENT`, `WON`, and everything else in the enum. **(c)** Do `quantity` (owned) and `availableQuantity` (yard-ready) mean **two different things**? On update, when the client omits `availableQuantity` and sends `quantity`, the API now sets `availableQuantity = quantity` (`apps/api/src/usecase/asset-management/tools/tools.service.ts`:353-359) — so every yard edit of the owned total silently resets yard-ready stock. **(d)** Should the quotation picker be shown `Math.max(0, quantity, availableQuantity)` as its `availableQuantity` (`apps/api/src/service/asset-management/tools/tools.repository.ts`:305)? Combined with (c) the two fields can no longer diverge downward through the form, which makes `availableQuantity` unreachable as a *reduced* number.
- **Sources checked:** **no vault file mentions `availableQuantity` at all** (grep of all 628 files). [tool-and-rigging.md](tool-and-rigging.md) (3.7 KB, `status: unverified`, the file the migration kept over a newer stub) is the only spec: **Story 5**, Dylan's yard dashboard, :100 *"Clicking a tool displays: **Jobs** requesting that tool and quantity required per job"* and :102 *"Each tool displays live status counters **Total, In use and available**"*. That is the nearest thing to (b) and it differs on all three axes — it is the **yard dashboard**, not the tool detail page; it lists **jobs**, not quotations; and it lists **all** demand, not only the over-inventory part. Story 3, the quotation story, is **selection only** and states no quantity rule. For (a) the supporting statement is vendor narration, `status: reference`: [../meetings/transcripts/2026-04-30-dispatch-scheduling-figma-demo.md](../meetings/transcripts/2026-04-30-dispatch-scheduling-figma-demo.md):45, Ehtesham Anwar @ 5:56 — sales *"are not like responsible for allocations… **it's just kind of a request from their side towards Dylan**"*, and *"Dylan can go into a particular job and see if he wants to add something, remove something"*. That makes a quote line a **request against a pool Dylan reconciles**, which is consistent with a soft warning but never says the hard limit should go, and it is CodingCops describing its own prototype. `../decisions/` — none of the 41 notes touches tool quantity or availability. Jira not checked (no Jira MCP in this session).
- **Related, already open — do not duplicate:** [*Quick-create a Tool & Rigging item from the quotation picker*](#quick-create-a-tool--rigging-item-from-the-quotation-picker--who-may-and-what-does-its-quantity-mean) **(c)** is the same question as (c) here from the other end — *"what is the quantity the modal collects — total inventory owned, or the quantity wanted on this quote?"* — and this branch answers it by fiat, in the API, by collapsing the two. [*Loading list — quantity, sets, and sizes are underspecified for a schema*](#loading-list--quantity-sets-and-sizes-are-underspecified-for-a-schema) records that `Boscaro Bar` carries quantity `N/A` and that set-granularity rows leave the tracked unit undecided; an over-request warning computed from those numbers inherits that. [../quotations/quotation.md](../quotations/quotation.md):15 — *"tools and rigging – total inventory"*, JZ, 2026-06-23, an unelaborated bullet on a **cross-module punch list**, not a source.
- **Blocked:** nothing hard — (a), (b) and (d) are reversible. **(c) is not**: it is a silent write, so every tool edited after this ships loses any reduced `availableQuantity` it had, and no record of the old value is kept.
- **Owner:** Dylan Masterson / the yard for (a)–(c), since the pool and its reconciliation are his (Story 5); Brian Petros for whether a salesperson should be able to promise stock TCG does not own.

## Settings → Checklists — three asset checklist types with a Pre-Trip/Post-Trip pair each, where FCC has fourteen

- **Status:** open
- **Asked:** 2026-09-15 — tcg-scrum escalation, raised on uncommitted work adding a Settings → Checklists tab (`apps/web/src/app/(protected)/settings/checklists/`, `features/settings/views/checklists-tab.tsx`, plus a `checklistType` filter on `GET /checklists`). No ticket, no `.ai/aidlc/` folder. The `AssetChecklistType` enum it lists was itself added by commit `3d117e158` (*"Mapped checklist to assets + addressed UI issues"*, 2026-08-11, no ticket, no `processed.log` row).
- **Question:** three parts, each answerable in a line. **(a)** Is TCG's asset checklist type set exactly **Crane / Tractor / Trailer**, or is it the equipment families FCC actually carries? **(b)** Does each type mean exactly **one Pre-Trip plus one Post-Trip** template — the screen's stated description for all three rows — or does a type carry a variable set including 30-day/annual cadences, rigging and time-stamp checklists? **(c)** Should Settings expose checklist definitions at all, and if so **view-only** (what shipped) or admin-editable — FCC's equivalent screen is an editable lookup with `Name · Eligible to E-Mail ☑ · Status`, none of which the tab has.
- **Sources checked:** **nothing in the vault or any `SCRUM-*` ticket specifies this screen, this enum, or the Pre-Trip/Post-Trip pairing.** Grep of the whole vault for `AssetChecklistType` / *checklist type* returns four files, none a TCG requirement; grep of `.ai/aidlc/` for *checklist* returns `SCRUM-877` (which step keys an Oiler's ticket carries — `spec.md` REQ-06) and `SCRUM-PROGRESS` (the job Progress Tracking tab), neither about settings reference data. The **only written enumeration of asset checklist types is FCC legacy fact, and it contradicts three**: [asset-record-requested-additions.md](asset-record-requested-additions.md):461-467 (`status: unverified`) records FCC lookup 31 *Unit Checklists* as **14 rows** of `FMS_UNIT_CHECK_LIST` — *AT – Tractors Pre-Trip Inspections · Build Up/Breakdown Time Stamps · Crane 30 Check List · Crane Pre-Trip Inspection · CWT and Flatbed Trailers Pre-Trip Inspection · Post-Trip Inspection · Pre-Trip Inspection (Inactive) · Rigging Inspection · Small Truck 30 Day Checklist · St-Stakebeds and UT Pre-Trip Inspections · Time Stamps · Tractor 30 Day Check List · Trailer 30 Day Check List · Work Through Lunch* — and states the convention as *"one checklist per equipment family (AT, CWT/flatbed, stakebed/UT, tractor, trailer, small truck, crane) crossed with cadence (pre-trip vs 30-day)"*. That is **seven** families, not three, and the cadence axis is not Pre-Trip/Post-Trip. The migration record says the same thing twice over: [../meetings/2026-08-26-fcc-migration-client-brief.md](../meetings/2026-08-26-fcc-migration-client-brief.md):79 lists *"asset checklist types"* among extracts with **no TCG home**, and :67/:100 carry the still-open action item **A12 — *"Checklist definitions — which are still in use"*, owner TCG** (`FMS_CHECK_LIST`/`_DETAILS`, 617 rows, annotated *"Need clarifications from TCG Team"*). Field-ops is the only place inspections are specified and it names no type list: [../field-ops/field-ops-frd/08-functional-requirements/fr-fop-008-pre-trip-checklist.md](../field-ops/field-ops-frd/08-functional-requirements/fr-fop-008-pre-trip-checklist.md) and [fr-fop-021-post-trip-checklist.md](../field-ops/field-ops-frd/08-functional-requirements/fr-fop-021-post-trip-checklist.md) (both `unverified`, FR-TCG-FOP-002) scope inspections **by role and load** — *"Oiler users shall complete crane-related inspections and inspections associated with the Operator Load. Support Load personnel shall complete inspections associated with their assigned support loads and trucks"* — and say only that *"checklist behavior shall be configurable"*, without saying by whom or on which screen. `../decisions/` — none of the notes touches checklists. Jira not checked (no Jira MCP authenticated in this session).
- **Related, already open — do not duplicate:** [*Unit / asset certifications — registrations, insurance, loan, maintenance, permits*](#unit--asset-certifications--registrations-insurance-loan-maintenance-permits) already cites the same `FMS_UNIT_CHECK_LIST` no-TCG-home line as a candidate; that entry is about the **certification/expiry** family, this one about the **checklist type** list and its Settings screen. [../admin/gaps.md → *Settings picklist rules the E2E suite asserts with no written source — PR #488*](../admin/gaps.md#settings-picklist-rules-the-e2e-suite-asserts-with-no-written-source--pr-488) is the same failure mode one module over: Settings reference-data behaviour frozen from the running build rather than from intent.
- **Blocked:** signing the Settings → Checklists tab off as intended behaviour, and treating `AssetChecklistType` (three values, on both `assets` and the checklist table) as a contract — the assets form dropdown consumes the same enum, so widening it later is a data migration, not a UI change. Answering A12 is the prerequisite for (a) and (b).
- **Owner:** TCG — Brian Petros (A12's owner is *"TCG"*; he owns the equivalent list questions in this register), with Dylan Masterson for which equipment families the yard inspects.

## Associated field assets are dispatch resources, not quote lines — pointer, owned by quotations

- **Status:** open — answer in [../quotations/gaps.md](../quotations/gaps.md) → *Quote line items vs dispatch resources — the associated set auto-fills the quote, and the sales owner says dispatch resources must not be quoted*. Principle decided 2026-09-16 ([../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md)); the model is open there.
- **Asked:** 2026-09-15 — Joe Schacatano, ERP live demo 01 ([../meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md](../meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md) §2). The sub-category's associated-field-asset set (crane → oiler + operator load; operator load → operator + truck) is, per Joe, the **dispatch** requirement and must not populate a quotation with charges. Ehtesham proposed a resources tab or flag on the sub-category to separate field assets from quoted items (44:36). Pointer only.

## One asset, one type — but one crane in several configurations: how does an asset stand for more than one resource type?

- **Status:** open
- **Asked:** 2026-09-17 — ingest of the 2026-09-16 "Resource types and billing codes" call ([../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md](../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md) §3). Ehtesham Anwar asked Joe Schacatano twice on that call. No ticket.
- **Question:** Joe said two things that have to be read together.
  - **"Whatever the asset is, it can only have one type… Derated to cover other equipment sizes in the same type, absolutely, but you're never going to change the type"** (4:59). A 90 ton hydraulic truck crane and a 90 ton RT *"can never be the same"* (5:44).
  - Of the 360 ton with and without luffer: **"Same cranes, different configurations"** (27:13). Asked whether that means one asset with two configurations: **"Yes."** (27:33).

  Read together, "type" means the schedule type (Brian's word, 4:41), and one asset can stand for several resource types within it. Three parts, each answerable in a line:
  - **(a)** Is that reading right: one schedule type per asset, and several resource types (smaller sizes by derating; configurations such as *w/Luffer* and *w/Mega Wing*)?
  - **(b)** Where is the many-to-one held? Per asset (FCC's `FMS_UNIT_TYPE_DETAILS`, a primary type plus secondaries), per sub-category pair (`SubCategorySubstitution`, as built), or is a configuration an attribute of the asset rather than its own resource type?
  - **(c)** Is derating always downward within one schedule type? FCC unit `4005` has a *45 Ton* secondary on a *40 Ton* primary (explained by counterweight, [crane-fleet-reference.md](crane-fleet-reference.md) §7). It also has a *22 Ton Boom Truck* secondary, and the vault does not say which schedule type that belongs to.
- **Sources checked:**
  - [fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §5: 565 type rows over 358 units, 48 units with more than one type, and TCG's slide note *"all the types of jobs this asset/vehicle can be Dispatched as"*.
  - The same file, §6: resource types 76 *360 Ton All Terrain w/Luffer*, 83 *550 w/Mega Wing* and 84 *550 w/Luffer*, all new since July. Joe, 26:31: *"after this job, we made separate ones for the different configurations"*.
  - [crane-selection-and-load-chart-model.md](crane-selection-and-load-chart-model.md) §4: Mega Wing as its own configuration.
  - [../dispatch/crane-configuration-rules.md](../dispatch/crane-configuration-rules.md): the 4005/4006 `3300`/`7300`/`full` options, where a configuration is a picked option, not a resource type.
  - Built state: `Asset.subCategoryId` is a single nullable FK (`apps/api/prisma/schema.prisma`, `model Asset`), and `SubCategorySubstitution` pairs one sub-category with another. No vault file states the ERP rule.
- **Related, do not duplicate:**
  - [*Nomenclature for the template level — "Resource Type", not "Unit"*](#nomenclature-for-the-template-level--resource-type-not-unit): what the level is called.
  - [../dispatch/gaps.md → *Requested vs dispatched resources*](../dispatch/gaps.md#requested-vs-dispatched-resources--melissa-stated-it-the-vault-still-says-the-opposite): substitution on a job, not the catalog shape.
- **Blocked:** migrating the `FMS_UNIT_TYPE_DETAILS` secondaries; modelling *w/Luffer*-style resource types against one physical crane; any DAS rule on which assets may fill a slot.
- **Owner:** Joe Schacatano (sales: what a quote may name), with Lisette Anzaldo (dispatch: what may fill it) and Dylan Masterson (fleet).
- **Update 2026-09-17: Brian's FCC deep dive** ([../quotations/fcc-billing-resource-configuration-deep-dive-2026-09-16.md](../quotations/fcc-billing-resource-configuration-deep-dive-2026-09-16.md) §19, §31; a recommendation). FCC evidence: unit **36001** is linked to *360 Ton All Terrain Crane* (PrimaryType = 1) and *360 Ton All Terrain w/Luffer* (PrimaryType = 0). That is the primary/secondary model from `FMS_UNIT_TYPE_DETAILS`, applied to a configuration. The document recommends answering (b) as **one asset record with supported configurations** (Standard, Luffer), with a profile requiring *asset type + configuration* and no duplicate asset. That is its reading of Joe's *"same cranes, different configurations"*; Joe has not confirmed the model.

## Tool and Rigging allocation from the quotation — who supplies it, in what form, and how it reaches the job

- **Status:** open
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register into the module registers. Raised in **UAT 1**; never built, never specified.
- **Question:** the UAT 1 ask is *"**Tool & Rigging allocation** will be done by Listtee and will come from the quotation."* Three things in it are undefined and each needs a line: **(a)** what does she supply — a tool list per job, per resource type, per billing code? **(b)** in what form — a quotation line, a catalog association on the crane, a free list attached to the job? **(c)** how does it reach the job — carried at convert-to-job, or assembled on the job afterwards?
- **Sources checked:**
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → NOT DONE *Tool & Rigging allocation driven by Listtee from the quotation*, [UAT 1]. The register's finding: *"**Not built and never specified.** What Listtee supplies, in what format, and how it reaches the job are all unrecorded. Stated as an intention rather than a requirement… Needs specifying before it can be built."*
  - **⚠️ The name is almost certainly misspelt on the source sheet.** *"Listtee"* appears **four times in the whole vault and all four are this row** — the UAT 1 session sheet and its three occurrences in the register. The person who owns dispatch and tool allocation is **Lisette Anzaldo**, named across [../dispatch/gaps.md](../dispatch/gaps.md), [../dispatch/admin-to-field-communication.md](../dispatch/admin-to-field-communication.md), [../dispatch/confirmations-playbook.md](../dispatch/confirmations-playbook.md), [../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md) and many more. **Read as Lisette Anzaldo — but the sheet has not been corrected, and the register is a migrated snapshot that must not be edited**, so anyone grepping for "Listtee" should land here.
  - **The collision, and it is with the only `verified` quotation decision:** [../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md) (Joe Schacatano, TCG VP of Sales, `status: verified`) — *"At the quoting stage, the estimate is **billing codes only**"* and *"**Resources exist for dispatch.** When the quote becomes a job, the billing codes it carries must bring with them the resources dispatch needs."* Under that model *"come from the quotation"* cannot mean a priced tool line; at best it means the quote's **billing codes** imply the tools. Nobody has said which. Owning entry: [../quotations/gaps.md → *Quote line items vs dispatch resources…*](../quotations/gaps.md#quote-line-items-vs-dispatch-resources--the-associated-set-auto-fills-the-quote-and-the-sales-owner-says-dispatch-resources-must-not-be-quoted).
  - **The vault's existing tool-and-rigging material does not answer any of (a)–(c):** [tool-and-rigging.md](tool-and-rigging.md) (`unverified`) covers the yard dashboard and In Use counters; [user-story-and-tasks.md](user-story-and-tasks.md) is yard management only **and came from an individual's personal Confluence space** — check its `provenance_note` before leaning on it. Neither describes where a job's tool list comes from.
  - Related, already open — do not duplicate: [*One In Use rule or two — the yard panel and the tool detail page disagree*](#one-in-use-rule-or-two--the-yard-panel-and-the-tool-detail-page-disagree) (what In Use means, not where the list comes from) and [*Per-Day Utilization on the Tools & Rigging listing — day-vs-range, and the default date*](#per-day-utilization-on-the-tools--rigging-listing--day-vs-range-and-the-default-date).
- **Note:** a UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md). The register is explicit that this one was *"stated as an intention rather than a requirement"*, which is the correct reading: it names a person and a source, and nothing else.
- **Blocked:** any tool & rigging allocation work; the quotation→job carry-over for tools; the yard loadout list for tools, which has nothing upstream of it today.
- **Owner:** **Lisette Anzaldo** — the UAT row names her as the person who would do it, so she is the one who can define (a)–(c). Joe Schacatano for whether anything about tools belongs on a quotation at all.
- **Pointer:** [../quotations/gaps.md](../quotations/gaps.md) → *Tool and Rigging allocation from the quotation — pointer, owned by assets*.

## Which dispatchable cranes are untracked, and what stands in for them — asked twice, unanswered twice

- **Status:** open
- **Asked:** 2026-09-19 to Brian Petros (Teams), re-asked 2026-09-22 after measuring his
  comparison workbook. Raised by the tracking work, not by a ticket.
- **Question:** four lines, and only the first is partly settled by data. **(a)** which cranes
  that can be dispatched carry no Samsara device — measurement says the owned, travelling set
  is **`6002`, `RT9001`, `27501`, `CC330.01`** (plus two re-rents and `TWC001`, which does not
  travel); does TCG confirm that list? **(b)** which support vehicle travels with each of them?
  **(c)** is it always the same vehicle for that crane, or does it change job to job?
  **(d)** can one support truck carry more than one crane, or is it one crane per truck?
  (b)–(d) decide whether the ERP models the stand-in as a durable per-asset relation, a
  per-allocation one, or not at all.
- **Sources checked:**
  - [fcc-samsara-reconciliation-2026-09-21.md](fcc-samsara-reconciliation-2026-09-21.md) —
    measured coverage against the 34-crane dispatchable list Brian supplied (Teams, 2026-09-21,
    qualified by him as *"very close to 100%"*): **27 of 34 present in Samsara, 7 absent.** His
    working heuristic *"I think only 40 ton and above get the Samsara tracking"* **fails both
    ways** — `2204` (22 T) and `SL01`–`SL03` (30 T) are tracked and under it; `6002` (60 T),
    `RT9001`, `27501` (275 T) and `CC330.01` (330 T) are over it and absent. He closed with
    *"Still trying to verify"*, so this is not his answer either.
  - **The why is on the record; the mapping is not.** Brian Petros: *"there's a couple cranes
    that the GPS device cannot be put on the crane itself … There's a support vehicle for those
    two cranes that is like assigned to the crane … So the GPS device is on that tractor, not on
    the crane itself, because … it messes with the electrical and then the crane starts
    malfunctioning"*
    ([../meetings/transcripts/2026-08-26-erp-sprint-review.md](../meetings/transcripts/2026-08-26-erp-sprint-review.md)
    18:11–18:49, `status: reference`). *"A couple"* and *"like assigned to"* are the whole
    record — no unit codes, and no statement of whether the assignment is fixed.
  - **Nothing structured holds a pairing.** Samsara's `Tags` column is empty on 78 of 79 rows;
    FCC's unit table has no crane→support-vehicle column among its 86; `decisions/` holds none.
    The only trace found anywhere is a **Samsara record named `ST09 (AT for SL03)`** — a pairing
    typed into a display name, which is evidence the pairings are known and kept nowhere
    readable.
  - Related, already open — do not duplicate:
    [*One Asset ↔ one Samsara asset*](#one-asset--one-samsara-asset--the-record-says-a-cranes-gps-box-is-on-a-different-asset-and-reads-only-one-of-its-two-engines)
    is the *cardinality* question (may both units point at one device); this entry is the
    *mapping* (which vehicle, for which crane, under what rule). Answering this one constrains
    that one.
- **Blocked:** any ERP display of a position for an untracked crane; whether a stand-in link is
  a schema relation or a dispatch-time association; and the honest labelling of a crane the map
  cannot locate.
- **Developer answer 2026-09-30 (round 9), bearing on this entry** ([note, F10](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30), `reference`): the payroll Samsara time flag raises **no flag when there is no Samsara data** ([../payroll/gaps.md → *Flagged entries go to payroll…*](../payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives) Q9, Q11(c)). So an untracked crane never raises that flag. **This entry's questions are not answered by it.** How the asset-not-home flag handles untracked assets is still open ([*Asset not returned to its home yard…*](#asset-not-returned-to-its-home-yard-at-end-of-shift--a-requested-flag-with-no-owner-no-yard-geometry-and-no-shift-end) Q7).
- **Owner:** Brian Petros to route — he has said the Fleet Manager owns the underlying data, and
  TCG has offered to wait for that rather than press (2026-09-22). (b)–(d) are dispatch
  knowledge, not master data, so a cleanup will not produce them.
- **Update 2026-10-23 (10-22 walkthrough part 2):** Brian Petros (12:18–13:12) is now checking, with
  **Jeff Stricker** (Fleet Manager), that every asset migrates cleanly (VIN, serial and model numbers) and
  **which assets have trackers**, at syed.haris's request. He repeated that some European cranes carry
  the tracker on the **tractor** because it does not work with the crane's electrical system. Kyle Harlow
  (11:10–11:21): **trailers have no trackers**. abdulrehman (10:26–10:57): the test tenant's assets are
  linked to the Samsara vehicles, and a link can be changed by hand. No list was given. Source: [2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md](../meetings/2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md) §1.

## A Samsara link that has gone silent — three 200-ton-plus cranes have not reported in 8–13 months

- **Status:** open
- **Asked:** 2026-09-22 — measuring the `Last Connected` column of the 2026-09-21 Samsara
  export. Nobody has been asked this yet.
- **Question:** **what should the ERP show for an asset that is linked to Samsara but whose
  feed is months stale?** Three candidates and nobody has chosen: (a) the last known position,
  undated, as a live position — what a naive read of the feed gives; (b) the last known
  position with its age shown; (c) treated as untracked until it reports again. A second line:
  is a silence threshold a product rule (and what is it), or is any last-known position
  acceptable?
- **Sources checked:**
  - [fcc-samsara-reconciliation-2026-09-21.md](fcc-samsara-reconciliation-2026-09-21.md)
    → *Samsara side — presence is not tracking*. **61 of 79** vehicles reported on the day of
    the export; eight had not reported in over 250 days, including **`35001` (411 days),
    `20001` (339)** and **`55001` (249)** — all 200-ton-plus cranes, all `Installed = true`,
    all still linked. Whether each is a dead gateway, an unpowered machine in the yard or a unit
    out of service is unestablished.
  - **The vault has no staleness rule.** No source in `assets/`, `dispatch/` or `field-ops/`
    states a freshness bound on a position, and `decisions/` holds no Samsara decision at all
    (see the *Samsara vehicle tracking* entry above, which records that absence). The one stated
    limit on GPS use is unrelated — *display and accountability, not the pay-time source*
    ([../dispatch/gaps.md](../dispatch/gaps.md), 2026-06-16 field-app demo).
  - **It compounds an existing ask.** Wes, Ehtesham and Kyle agreed a Samsara vicinity check
    could flag the wrong unit leaving the yard (2026-07-07, recorded in
    [../dispatch/gaps.md](../dispatch/gaps.md)); a vicinity check against a 411-day-old position
    would pass silently. That is the concrete failure mode, and it is why this needs a line
    rather than a default.
- **Blocked:** the fleet map's treatment of a linked-but-silent asset; any rule that reads a
  position as corroboration of a time or a location.
- **Developer answer 2026-09-30 (round 9), bearing on this entry** ([note, F10](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30), `reference`): the payroll Samsara time flag raises **no flag when there is no Samsara data** ([../payroll/gaps.md → *Flagged entries go to payroll…*](../payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives) Q9, Q11(c)). It is one of the rules this entry's *Blocked* line names: it reads a position as corroboration of a time. So a linked crane that has gone silent never raises it. **Not stated:** whether a stale last-known position counts as "no data". **This entry's question is not answered by it.**
- **Owner:** product team, with Brian Petros on the operational half — three of the eight are
  main cranes, so whether they are genuinely untracked today is a fleet question before it is a
  display question.

## Archived rows in pickers — never offered except the record's own saved value?

- **Status:** open
- **Asked:** 2026-09-22 — UAT observation *"Archived categories should not be displayed"* on the
  sub-category Category picker; Path C fix (no `.ai/aidlc/` folder). The create form was passing
  `includeArchived` as a like-for-like port from a pre-fetched list (`b6e2c25d62`), not from a
  product decision.
- **Ticket:** Linear **[TCG-43](https://linear.app/the-crane-guys/issue/TCG-43)** — *Archived
  categories appear in the Sub-Category form's Category dropdown*; milestone *UAT remediation*,
  parent TCG-13, raised by syed haris, assignee Areeba Gul, `PR Review and QA`. Recorded
  2026-09-23 at PR review of `fix/archived-category-appear-in-subcategory` (commits `e1732cdb0`,
  `4301f84d7`, Mohsin Akram): this entry and the `processed.log` row both read *no ticket*, which
  was wrong — the work is tracked, in **Linear rather than Jira** (the Jira tenant is suspended
  for payment, so Jira is not a place to look). It matters here because TCG-43 **defers** its own
  edit-form criterion behind its open question 1, which is part **(b)** below — so the working
  assumption below is shipped behaviour, not something the ticket authorised. Related: **TCG-109**
  (yards, same mechanism), whose acceptance criterion 8 names this register as where the general
  rule belongs and says the rule is *"unspecified today; do not infer it from this fix"*.
- **Question:** two lines. **(a)** Is it a **general picker rule** that archived rows never appear
  as new choices, anywhere — with the sole exception that a record's **own saved** archived
  reference stays visible and re-selectable after the field is cleared? **(b)** When a parent
  category is archived after a sub-category was created under it, does that archived FK remain a
  **valid parent** until the user reparents, or must the child be reparented / archived too?
  [decisions/2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md)
  settles archive-as-removal and explicitly leaves *"what an archived record still participates in
  (search, reports, references from live records)"* open.
- **Working assumption shipped 2026-09-22 (UAT, not ratified):** for categories on the sub-category
  create/edit forms — (a) archived categories are excluded from search; the edit form pins only
  the saved archived parent with a `formatArchivedLabel` suffix; (b) that saved archived parent
  remains a valid FK (save-unchanged must succeed). Other pickers (yards, etc.) are **not**
  covered by this assumption until (a) is ratified.
- **Added at PR review 2026-09-23 — three things the working assumption does not account for.**
  **(1) Two shipped conventions now contradict each other on (a).** The branch pins the saved
  archived parent as a **selectable** option (`category-select.tsx`, `pinnedCategory`), while
  `apps/web/src/lib/archived-reference-options.ts` → `buildArchivedReferenceOptions` pins the
  same kind of reference **`disabled: true`** — and is consumed by
  `sub-category/components/create-sub-category.helpers.ts` → `buildCategoryOptions`, i.e. **the
  same edit form**, plus `assets/asset/lib/asset-classification-options.ts`. A third
  shape is in use elsewhere: `includeArchived` left on the picker, so archived rows stay fully
  searchable and selectable — `part-form-sections.tsx:62`, `permit-form-fields.tsx:256`,
  `po-form-fields.tsx:185`, `po-line-item-row.tsx:88`, `quote-info-section.tsx:58`. TCG-43's
  criterion permits *"either pin it as an option or suppress the clear control"* and does not
  choose between them. Whoever answers (a) should name which of the three is the rule, or the
  next picker picks a fourth.
  **(2) (b) has no server-side enforcement in either direction.**
  `usecase/asset-management/sub-categories/sub-categories.service.ts` never checks the parent's
  `archivedAt` on `create()` (:499) or `update()` (:583) — the only such check in the module is
  `unarchive()` (:757), which refuses while the parent is archived. So the FK can be pointed at an
  archived category by any client whatever (b) decides, and honouring the answer will take a guard,
  not only a picker change. Note also that archiving a category **cascade-archives its live
  children** (`categories.repository.ts:240`, `archiveWithActiveSubCategories`), so the state (b)
  asks about is reachable today mainly through legacy rows and the unguarded paths named here.
  **(3) "Excluded from search" is not "unreachable".** `category-details-view.tsx:126` builds
  `/asset-management/sub-categories/create?categoryId=<id>` with no archived guard, and
  `create-sub-category-view.tsx:70` resolves the label from `getCategory(id)` rather than from the
  list — so an archived parent still prefills the create form and still saves, and without the
  `formatArchivedLabel` suffix the rest of the branch adds. Already carried as Q4 of
  [*Create-form prefill from URL query params*](#create-form-prefill-from-url-query-params--the-whole-contract-is-unwritten)
  in this file; named here so (a) is not read as having closed it.
- **Sources checked:** the archive decision above; this register; admin/gaps → *Departments —
  does archive replace delete…* part (c) (same participation question on another entity);
  sub-category name uniqueness part (b) in this file (name reservation — related archive theme,
  do not fold in).
- **Blocked:** treating the UAT line as app-wide product law; signing off that departments,
  yards and every other picker must converge on the same rule.
- **Owner:** Fouzan Shakil — named decider on the app-wide archive convention.
- **Cross-link:** [admin/gaps.md → Departments — does archive replace delete… (c)](../admin/gaps.md#departments--does-archive-replace-delete-outright-and-what-may-an-archived-department-still-be-used-for)

## Pointer — leave-page warning and value rewriting on open (yards)

- **Pointer (2026-09-28):** the leave-page "unsaved changes" warning sticking after a no-op edit, and forms rewriting stored values on open, is filed once in [customers/gaps.md](../customers/gaps.md) → *Leave-page warning — does undoing an edit count as a change, and may opening a record rewrite its stored values?* It covers the yard form (empty address and phone defaults; the discarded `normalizeForDirtyCheck`).

## Asset not returned to its home yard at end of shift — a requested flag with no owner, no yard geometry and no shift end

- **Status:** open — **Q1 and Q2 answered 2026-09-30** by Corrina (recipients; the engine-off trigger). **Q3 ratified 2026-09-30** (departure yard: *"Asset not back at the yard it left from"*, confirmed in Corrina's flag list, [../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md)). **The flag blocks payroll approval** (*"all of these"*); whose week it blocks is open. **Q4 withdrawn.** Still open: which shut-off counts (the last one is our reading), the yard radius (Q5), holdover (Q6), untracked assets (Q7), scope (Q8), and non-holdover multi-day jobs parked at a site. **Round 9, 2026-09-30** (developer, `reference`, [note, section *Round 9*](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30)): developer readings for Q1's remainder (dispatch-permission holders, in-app and email), Q2 (judged once the ticket's end date has passed, **in tension with Corrina's shut-off trigger**), Q3's derivation (from Samsara), Q5 (500 m), Q6 (holdovers skipped) and Q8 (cranes only). All are **pending ratification**. Q7 is not answered for this flag. **Rounds 10–11, 2026-09-30** (developer, `reference`, [note, section *Rounds 10 and 11*](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#rounds-10-and-11--flag-details-for-payroll-flags-u14u21-2026-09-30)): Q2, a multi-day non-holdover job is judged once the job's last ticket date has passed (still date-based, so **still in tension with Corrina's trigger**); Q7, no Samsara data means no asset flag (answered for this flag, as developer direction; who owns Q7 is recorded two ways, see Q7). Q2 is pending ratification. The entry stays open.
- **Asked:** 2026-09-30, by Corrina Bustos (TCG Payroll Manager), Teams, unprompted *"New Ideas"*. Recorded in [../decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md](../decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md) clause 4. Verbatim: *"Flag idea: if an asset is not assigned to a holdover job, and does not return to the home yard (whether Los Alamitos or Ventura yard) at the end of the shift, can it flag. This has happened when an EE has taken the asset home."*
- **Why it is filed here:** it is an asset-location flag, not a payroll-entry flag, and it rests on Samsara tracking, which this module owns (see [../field-ops/gaps.md](../field-ops/gaps.md) → *Samsara integration scope — pointer, owned by assets*). Pointers are in `payroll/gaps.md` (flagged-entries entry) and `dispatch/gaps.md`.
- **Questions:**
  1. **Who receives it?** Payroll, under *"all flags"* ([../decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md](../decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md))? Dispatch (Lisette Anzaldo)? Operations (Kyle Harlow)? **→ Answered 2026-09-30 ([../decisions/2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md](../decisions/2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md)):** *"payroll admin/payroll manager, and dispatch notified."* Open: who in dispatch, and how they are notified.
     - **Developer answer 2026-09-30 (round 9)** ([note, F15](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30), `reference`): holders of the **dispatch permission** are notified, **in-app and by email**. **Still open**, for Lisette Anzaldo to ratify.
  2. **When is "end of the shift", and when does the check run?** At the asset's ticket End Job / Arrived Yard? At a fixed hour? Overnight? **→ Answered as a trigger, 2026-09-30:** *"I dont think it would go off a time. it would trigger if the asset shut off at address other than the los alamitos or Ventura yard addresses."* **Open:** taken literally, an engine-off at a job site mid-shift or at lunch fires it; she presumably means the **last** shut-off of the day (our reading). Also open: assets legitimately left at a job site overnight on a non-holdover multi-day job. The holdover exclusion (Q6) was not restated, so it stands from her first message.
     - **Developer answer 2026-09-30 (round 9)** ([note, F13](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30), `reference`), verbatim: *"after ticket end date pass"*. Once the ticket's end date has passed, the check asks whether the asset is inside its departure yard's geofence. If it is not, the asset is flagged.
       - This **replaces** the developer's earlier "last shut-off of the day" reading.
       - **It is in tension with Corrina's trigger above** (*"I dont think it would go off a time … shut off at address other than …"*). Her trigger is a shut-off event away from the yard. This one is a position check, made once a date has passed. An asset shut off away from the yard, and back inside it when the check runs, flags under hers and not under this one.
       - **Still open**, for Corrina Bustos, with Lisette Anzaldo, to ratify.
       - **Not stated:** which day's departure yard a multi-day ticket is judged against. The case of assets parked at a site on a non-holdover multi-day job is also still open.
     - **Developer answer 2026-09-30 (rounds 10–11)** ([note, H5](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#rounds-10-and-11--flag-details-for-payroll-flags-u14u21-2026-09-30), `reference`): on a **multi-day job that is not a holdover**, the asset is judged only once **the job's last ticket date** has passed. There is no nightly check in the middle of the job.
       - This answers round 9's open case: an asset parked at a site between the days of such a job no longer flags each night.
       - **It is still date-based, so the tension with Corrina's trigger stands** (recorded as F13 in the note). Taken literally, hers fires on any shut-off away from a yard, mid-job included. This one checks nothing until the job has ended.
       - **Consequence:** a crane taken home overnight in the middle of a multi-day job, the case Corrina gave when she asked for the flag, is caught only if it is still away from its departure yard after the job's last ticket date.
       - **Not stated:** which day's departure yard the check uses.
       - **Still open**, for Corrina Bustos, with Lisette Anzaldo, to ratify.
  3. **What is the home yard of an asset?** Is it `Asset.yardId` (exists, nullable), or something else? The requirement names two yards. **→ Developer-decided 2026-09-30, pending ratification ([../decisions/2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md](../decisions/2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md), `reference`):** the comparison yard is **the yard the asset left from that day**, not `Asset.yardId`. No field records the departure yard today (`JobTicket`, `JobResourceAllocation` and `SubJobLoadout` carry no yard), so deriving it is CodingCops design.
     - **Developer answer 2026-09-30 (round 9)** ([note, F12](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30), `reference`): the departure yard is derived **from Samsara**. It is the yard whose 500 m geofence the asset was inside when it **first left that day**. `Asset.yardId` is still not the rule. **Pending ratification** by the TCG assets owner, although the earlier note had called this derivation CodingCops design.
  4. ~~**Where is the Ventura yard?**~~ **Withdrawn 2026-09-30:** yards are tenant-configured, so TCG adds its own yard addresses, including Ventura. Los Alamitos and Ventura were examples of the departure-yard rule (Q3) ([../decisions/2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md](../decisions/2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md)). It is not a client question.
  5. **What counts as "back in the yard"?** `Address` has latitude/longitude, but no radius or geofence exists, and the Samsara integration reads GPS, engine states and trips, not geofence events. What radius, and what signal: last GPS fix, or trip end location? **Still open:** the radius. The signal is developer-read as **the last engine shut-off of the day** (Corrina said *"shut off"*), pending ratification.
     - **Developer answer 2026-09-30 (round 9)** ([note, F11, F13](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30), `reference`): the radius is **500 m** from the yard's address coordinates (`Address` latitude/longitude, migration `20260917000000_address_county_and_coordinates`). The signal is the asset's position against that geofence once the ticket's end date has passed. It is no longer the last engine shut-off. **Still open**, for the TCG assets owner (radius) and Corrina Bustos (signal) to ratify.
  6. **What counts as "assigned to a holdover job"?** Today this is `JobResourceAllocation.isHoldover`, set by Copy Allocations with "Hold over" ticked. The definition is itself open: [../dispatch/gaps.md → *Does copying allocations make a job a holdover?*](../dispatch/gaps.md#does-copying-allocations-make-a-job-a-holdover). **Update 2026-10-01 (tcg branch `feat/schedule-datetime-holdover`, not merged):** holdover is now also a per-line job setting, `JobResource.isHoldover` (Make Holdover), and the line's allocations carry onto the job's days; an item held over is offloaded on the job's last day, others every day ([../decisions/2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md](../decisions/2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md), `reference`). The flag should read the line-level setting. **Update 2026-10-06 (fouzan.shakil, `reference`, not confirmed by TCG):** the yard side of a held asset is now ruled. It is loaded out once and offloaded only on the job's last day, and while on site it blocks other jobs for the whole hold ([../decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md](../decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md)). Whether this flag exempts exactly that on-site window is not decided. **Note 2026-10-06, later the same day:** "loaded out once" is superseded. Every day of a held job runs the normal yard flow: the held asset is ticked and locked in Loadout each day, is not offloaded before the last day (recorded as still on site), and comes back on the last day ([../decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md](../decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md), `reference`). The block on other jobs now starts on the held job's first held day, before the asset goes out ([../decisions/2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md](../decisions/2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md), `reference`). Whether the flag exempts the on-site span is still not decided.
     - **Developer answer 2026-09-30 (round 9)** ([note, F14](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30), `reference`): holdover jobs are **skipped**, which restates her exclusion. The definition of a holdover is still open in dispatch. **Open.**
  7. **Untracked or silent assets:** skip them, or flag them as unknown? See [*Which dispatchable cranes are untracked…*](#which-dispatchable-cranes-are-untracked-and-what-stands-in-for-them--asked-twice-unanswered-twice) and [*A Samsara link that has gone silent*](#a-samsara-link-that-has-gone-silent--three-200-ton-plus-cranes-have-not-reported-in-813-months).
     - **Round 9, 2026-09-30: not answered for this flag.** The developer's *no Samsara data → no flag* ([note, F10](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30)) was given for the payroll Samsara time flag only ([../payroll/gaps.md → *Flagged entries go to payroll…*](../payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives) Q11(c)). **Open.**
     - **Developer answer 2026-09-30 (rounds 10–11)** ([note, H6](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#rounds-10-and-11--flag-details-for-payroll-flags-u14u21-2026-09-30), `reference`), round 11: **skip it.** An untracked or Samsara-silent crane raises **no asset flag**. This is fail-open, the same as the payroll Samsara time flag (F10). **Q7 is answered for this flag, as developer direction.**
       - **Consequence:** an untracked crane, or one whose link has gone silent (see [*A Samsara link that has gone silent*](#a-samsara-link-that-has-gone-silent--three-200-ton-plus-cranes-have-not-reported-in-813-months)), can never raise this flag, even when it is taken home.
       - This entry's *Owner* line gives Q7's handling to CodingCops. The PAYROLL-FLAGS ticket spec (Q41) had named Corrina Bustos, with the TCG assets owner. The note does not choose between them.
       - **Not answered:** which cranes are untracked. That stays open in [*Which dispatchable cranes are untracked…*](#which-dispatchable-cranes-are-untracked-and-what-stands-in-for-them--asked-twice-unanswered-twice).
  8. **Scope:** cranes only, or every tracked asset (tractors, trucks)?
     - **Developer answer 2026-09-30 (round 9)** ([note, F14](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30), `reference`): **cranes only.** This narrows her *"an asset"*. **Still open**, for Corrina Bustos to ratify.
- **Blocked:** building the flag. Nothing exists for it in code.
- **Owner:** Corrina Bustos, who requested it, for Q1 and Q8. Lisette Anzaldo (dispatch) for Q2 and Q6. The TCG assets owner for Q3–Q5. CodingCops for Q7's handling.

## Grouping assets for fleet-maintenance inventory — by department, or something else?

- **Status:** open
- **Asked:** 2026-10-20 — Brian Petros, Teams reply to Syed Haris while answering TCG-237 §12 Q24 (does anyone filter assets by department today). Verbatim, two messages: *"Not that I know of. Just "The Crane Guys" OM (Operated and Maintained). I can't think of any filtering by department today. Would be nice, however, to have some type of filtering of assets because of all the different types of assets (like iPads, cell phones, etc.)"* and *"And, I'm thinking when we get into the inventory of the fleet maintenance, then that may be a reason to filter/categorize by department."*
- **Question:** When fleet-maintenance inventory is built, what should assets (and parts) be grouped by — the org departments, FCC's department codes (`FL` Fleet, `MC` Mechanics, `SH` Shop …), asset categories, or something new? Nothing written specifies fleet-maintenance inventory yet.
- **Sources checked:** `assets/fcc-units-and-schedule-types.md` → *Departments — 10* (FCC unit distribution `FL` 252 · `RG` 56 · `OM` 37 · `MC` 9 · `CR` 1 · `YD` 1); `assets/asset-record-requested-additions.md:338` (FCC work orders numbered `FL-#####`); git history — the ERP asset's department was copied from FCC's unit record (`487790d2c`, 2026-04-07), no requirement behind it; `.ai/aidlc/TCG-237/spec.md` §11b D5 (developer decided to remove department from assets, 2026-10-20). The asset list already filters by category and sub-category (`apps/web/src/features/assets/asset/hooks/use-assets-list-state.ts:12-13`), which covers Brian's device-type example if devices are set up as categories — none are seeded today.
- **Blocked:** nothing today. It bears on how TCG-237 removes asset department (whether the stored FCC values are kept for later) and on any future fleet-maintenance / parts-inventory ticket.
- **Owner:** Brian Petros, with Kyle Harlow (VP Fleet & Field Ops) and Jeff Stricker (Fleet Manager) when fleet maintenance is scoped.
- **Update 2026-10-20 (Brian Petros, third message, same thread), verbatim:** *"The Repair Guys has many assets that will need to be put into the system. Equipment/machines/tools for repair... but that will most likely be its own org/company instead of a separate department."* Reading: The Repair Guys' assets will be separated **by company (tenant)**, not by department — consistent with the vault's existing record of TRG as a second company ([../admin/fcc-nexgen-administration-and-security.md](../admin/fcc-nexgen-administration-and-security.md):293, [../field-ops/safety-compliance/06-safety-data-platform-requirements-spec.md](../field-ops/safety-compliance/06-safety-data-platform-requirements-spec.md):68). It removes one candidate reason for asset departments; the fleet-maintenance question above stays open.
- **Update 2026-10-20 (Brian Petros, fourth message, same thread), verbatim:** *"Sounds good. The Category/Sub Category should work. We will add "Devices" category... good idea. My main focus after tomorrow's demo will be to get the assets inventoried properly. Still needing to do that and get coordination with Jeff Stricker on that. Been difficult to do, but I think it would be best to just fill in the data myself in the ERP after demo and then ask Jeff to review what I entered. How will we add pictures of assets? I recently took pictures of most of the main cranes and tractors... will I be able to upload pictures of them and get like a "profile" picture of the asset that shows in the ERP?"* Recorded: (a) device-type filtering is covered by categories — TCG adds a "Devices" category itself; (b) asset inventory plan — Brian enters the assets in the ERP after the 2026-10-21 demo, Jeff Stricker (Fleet Manager) reviews; (c) a **profile picture per asset** is asked for again. Today an asset takes photos only as attachments (categories General, Product Guide, Owner Manuals, Load Chart, Equipment Drawing — `apps/web/src/features/assets/asset/components/asset-attachment-categories.ts`), and the asset list shows initials, not a picture (`assets-list-view.columns.tsx:63`). The ask matches TCG's own slide note *"Profile Pictures for Asset"* ([asset-record-requested-additions.md](asset-record-requested-additions.md) §`*** Profile Pictures for Asset ***`). No Linear ticket exists for it as of 2026-10-20.
- **Update 2026-10-23 (Brian Petros, fifth message, same thread), verbatim:** *"Hi Haris, I uploaded these asset pictures to the ERP. I put them in this "General" section... I have this one too... this is a real nice one, but not sure if it is the 550 ton or not, so need to check first. And I have other ones of the other vehicles, but they are not in the ERP yet. Need to get the rest of the assets in the ERP. (will be working with others to make sure we get all assets we need in the ERP). But that's a good start! I noticed that there is no easy way to view the pictures once they are in the ERP. We will have a thumbnail or quick view available? And no easy way for me to see how many have pictures. Uploading the pictures was very nice/easy... just drag-drop and they uploaded in a second... very fast and responsive. Works great."* Recorded: (a) Brian has uploaded photos for some assets as attachments in the **General** category; (b) one photo may or may not be the 550-ton crane — Brian is checking, not uploaded against an asset yet; (c) photos exist for other vehicles that are **not in the ERP yet** — Brian is working with others to get every needed asset entered; (d) **two new asks, client-stated:** a thumbnail or quick view of an asset's pictures, and an easy way to see **how many assets have pictures**; (e) feedback: drag-and-drop upload is fast and works well.
- **Reply 2026-10-23 (Syed Haris → Brian, CodingCops), as sent** — paragraphs 1–2 as drafted in the Claude Code session, paragraph 3 verbatim as Haris sent it: *"Thanks for uploading the photos, and I'm glad the drag-and-drop upload worked smoothly. As I mentioned yesterday, we're working on a quick view of each asset's profile picture. You've already uploaded the photos to the "General" section, so all we need to do is link each one to its asset. It will then show up as that asset's profile picture, and nobody will need to upload anything again. I'll show you how this works in our next demo. You also mentioned that some assets aren't in the ERP yet. Could you try creating a few of them yourself and tell us how it goes? If anything in the asset creation form is confusing, that's exactly what we want to hear, so we can fix it before the rest of the assets go in."* **CodingCops' commitment, not a TCG decision:** a profile-picture quick view per asset, populated by linking the General-category photos already uploaded (no re-upload), shown at the next demo. **Asked of TCG:** Brian creates some of the missing assets himself and reports friction in the asset creation form. **Unanswered by the reply:** the "how many assets have pictures" ask (d) — no view or count was promised; it stays open, owner Brian Petros.

## The "storage" loop after accounting — what does it cover?

- **Status:** open
- **Asked:** 2026-10-21 — ERP demo walkthrough part 1. ehtesham.anwar (6:06): after invoicing, *"we are
  going to focus on two bigger loops … we have the storage. And after storage, we have another loop and
  that is for maintenance"* (inventories and the maintenance workflow). Brian Petros named **inventory and
  fleet maintenance** (Jeff Stricker) as the one area the first pass left out (4:18). Source:
  [2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md](../meetings/2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md) §2. Filed 2026-10-22.
- **Question:** is "storage" the storage of **customers' equipment** in TCG's yards (billed to them), of
  **TCG's own** equipment and parts, or both? And is it its own loop, or part of maintenance and inventory?
- **Sources checked:**
  - [storage-and-warehouse-operations.md](storage-and-warehouse-operations.md) (`unverified`, FCC reference)
    — background only; no TCG scope.
  - [../gaps.md](../gaps.md) *Phased rollout — no vault coverage* (frozen register, still open) — the
    phase order was never written.
- **Blocked:** discovery for the next loop.
- **Owner:** Melissa McNutt and Kyle Harlow (yards), Jeff Stricker (fleet); CodingCops for the roadmap.

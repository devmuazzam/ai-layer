---
title: Assets — open questions
status: reference
kind: gaps
updated: 2026-09-01
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

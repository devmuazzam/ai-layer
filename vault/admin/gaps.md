---
title: Admin — open questions
status: reference
kind: gaps
updated: 2026-09-01
tags: [module/admin, kind/gaps, open-questions]
---

# Admin — open questions

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

## Integrations — HubSpot, Microsoft 365, Dialpad, Mapsly

- Question: what do the existing integrations do, and what should move into the ERP?
- Candidates: **none of substance.** HubSpot appears once, in `assets/user-story-and-tasks.md`,
  which was migrated from an individual's personal Confluence space and carries a
  `provenance_note` warning it may be a private draft rather than agreed specification.
  **Dialpad, Mapsly and Microsoft 365 appear nowhere in the vault.**
- Note: the 12 August minutes record that Patrick will demonstrate the working solution at the next
  meeting. Until then there is no written source, and the one HubSpot mention should not be treated
  as one.
- Blocked: the action item to review existing integrations for ERP incorporation.
- Owner: Patrick (demo), then whoever writes it down.
- Status: open
- **From (frozen original):** [gaps.md#integrations-hubspot-microsoft-365-dialpad-mapsly](../gaps.md#integrations-hubspot-microsoft-365-dialpad-mapsly)
- **Update 2026-08-27:** Brian Petros, written message to the TCG team, 2026-08-27 ("A couple things that came up in my discussion with CodingCops today, that we'll discuss in future meetings"), following the 2026-08-26 ERP sprint review — logged in [payroll/client-message-findings.md](../payroll/client-message-findings.md#cross-module--2026-08-27-follow-ups-after-the-fcc-migration-first-pass-brian-petros) — still open; Brian re-lists "have Patrick explain more details
  regarding Customer data synced with HubSpot & Microsoft". The 2026-08-26 sprint review
  (`../meetings/transcripts/2026-08-26-erp-sprint-review.md`, ~18–20 min) adds the shape:
  Microsoft, HubSpot and Dialpad are synced with each other, **FCC is not**, and salespeople may
  update contacts in HubSpot — so the customer/contact migration from FCC may be the stale copy.
  Customer-side pointer: customers/gaps.md. The brief names the contact: **Patrick McKiernan**, and adds "show legacy FCC ID on UI" — the annotated migration brief, [meetings/2026-08-26-fcc-migration-client-brief.md](../meetings/2026-08-26-fcc-migration-client-brief.md) A1.


## Map provider, no-key fallback, and which table owns address coordinates

- **Status:** open
- **Asked:** 2026-08-25 — SCRUM-936 PR review (branch `scrum-936`); tcg-scrum escalation
- **Question:** Three parts, each answerable in a line. (a) Which map provider is TCG's for
  address and job-site display — Google Maps, or the existing **Mapsly** integration that nobody
  has described (see *Integrations* above)? (b) When the Google Maps key is absent or rejected, is
  a **read-only OpenStreetMap embed** an acceptable production fallback, or should the map simply
  be absent until the key works? (c) Do address coordinates belong on each owning entity (today:
  `JobSite.latitude/longitude`) or on the shared `addresses` reference table, so that any address
  in the app can carry a pin?
- **Sources checked:** vault-wide grep for `openstreetmap|OSM|geocod|latitude|longitude|map view|
  api key` — **no vault file names a map provider, a fallback, or a coordinate owner**;
  [STRUCTURE.md](../STRUCTURE.md):42 assigns `geocoding` and address reference data to `admin/`,
  but no content exists behind that facet; `decisions/` (13 notes, none about maps);
  `customers/customers-INDEX.md` and its five candidates. Jira: **every map ticket has
  `description: null`** — `SCRUM-699` and `SCRUM-755` (duplicate, closed as such) *"need to
  integrate map for jobsite"*, `SCRUM-414` *Quotation: Job Site: Map View with FAA Radius and
  Permit Auto-Detection* (Blocked), `SCRUM-252` *Live Asset Map View* (To Do). `SCRUM-936` was
  created 2026-08-25 02:08 by the implementing developer and describes the code as built, so it
  cannot be cited as the requirement for it.
- **Weak signals, not answers:** `payroll/legacy-payroll-app-db-extract/data/source-feed.md`
  shows legacy FCC carrying `Latitude`, `Longitude`, `GeoFenceRadius` **and** `Directions` on the
  customer-location (job-site) row — coordinates owned by the location record. That is a
  migration-source precedent for (c), not a product decision.
  `meetings/transcripts/2026-07-09-adp-and-data-migration.md` — Brian Petros on FCC addresses:
  *"obviously it needs to be verified on entering because we'll need this for a lot of things for
  the mapping functionality"*. A meetings record, not a commitment, and what it asks for is
  **verification on entry** (forward geocoding), which `SCRUM-936` puts out of scope.
- **Blocked:** `SCRUM-936` (In Review) cannot be signed off as product-correct; `SCRUM-699` (In
  Review — QA blocked, Aiman Farooq 2026-08-24: *"unable to test it due to the Map APIs issue"*);
  `SCRUM-414` (Blocked); any move of coordinates onto `addresses`.
- **Owner:** Brian Petros (data and integrations — the only recorded voice on address
  coordinates), with Patrick for the Mapsly half.


## What a newly created tenant must contain — provisioned defaults, or an empty portal

- **Status:** open
- **Asked:** 2026-08-27 — PR #421 review (branch `refactor/explicit-tenant-seeding`, no ticket); tcg-scrum escalation
- **Observed 2026-09-01 — the premise that provisioning happens today does not hold.** A tenant
  created through Super Admin (`CODING-COPS`) came up with **zero departments and zero department
  roles**, while `PLATFORM` and `TCG-DEFAULT` each carry 15 system departments (`DEPT-ACCOUNTS`,
  `DEPT-FLEET`, `DEPT-YARD`, …, all `is_system: true`) and 18 roles. Those exist because
  `seed-data.ts` created them, not because tenant creation did — `AdminTenantsService.create()`
  writes the `TenantCompany` row and nothing else. So option (a) above is not "today's behaviour"
  for admin-created tenants; the empty portal is. The consequence this entry predicts is real and
  observed: with no departments there are no roles, so the first user cannot be given one without
  hand-creating both.
- **Question:** When a tenant is created — by the admin "create tenant" action or by self-signup —
  which reference data must exist on day one? Four sets are in question and each can be answered
  in a line: (a) **system departments and their department roles**, (b) **billing code types**,
  (c) **industries**, (d) the **payroll premium catalog** (see payroll/gaps.md → *Payroll premium
  catalog*). Options for each: **provisioned automatically at tenant creation** (today's
  behaviour, `seedTenantDefaults`), **created by the tenant's own admins through the existing
  settings CRUD** (an empty portal on first sign-in), or **run by an operator as a per-tenant
  onboarding step**. If empty is the answer, does anything gate first use — a new tenant with no
  departments has no roles to assign a user to.
- **Sources checked:** **Vault — nothing.** `INDEX.md`; `admin/INDEX.md` (the module holds one
  content file, `tcg-documents.md`, on attachments); `admin/gaps.md`; `decisions/` (13 notes, none
  on tenant provisioning, departments, roles or reference-data seeding);
  [STRUCTURE.md](../STRUCTURE.md):42 routes the `seed` facet to `admin/` but **no content exists
  behind it**; vault-wide grep outside `meetings/` for `new tenant|tenant creation|create a
  tenant|new company|empty portal|default department|system department|default role|seed` — no
  product statement, only incidental mentions of today's seeded craft codes in
  `decisions/2026-08-21-scrum-877-*` (which explicitly says seed data "is not necessarily what a
  tenant's admins have since configured"). **`meetings/` — nothing** (full sweep of 57
  transcripts, 7 summaries and the curated minutes): `new tenant`, `provision`, `seeding`, `empty
  portal`, `default department`, `master data`, `reference data` return zero hits; every `seeder`
  hit is the FCC migration seeder. The nearest statements are Ehtesham describing departments as
  something *you create* (`meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md`:68,
  :72; `meetings/transcripts/2026-05-05-tcg-erp-system.md`:92) and CodingCops reporting that they
  "added all of the basic cards" for billing code types and industry codes **for TCG**
  (`meetings/transcripts/2026-07-29-erp-review-dispatch-das-update.md`:148) — a description of
  what was loaded into TCG's own tenant, not a rule about new ones.
- **Weak signals and one conflict, not an answer:**
  - **Jira says seed, twice, and both are `Done`.** `SCRUM-467` *Seed Departments & Roles*:
    *"System should include predefined, hardcoded departments and their roles… Sales Department →
    Managers automatically created/assigned, Dispatch Department, Yard Department."* `SCRUM-593`
    *Departments (seeding and templates)*: *"Seed default departments; seed manager default
    permissions as per our best understanding."* **PR #421 removes exactly that behaviour**, so
    the PR's premise and two closed tickets disagree. Neither ticket is superseded by anything
    written.
  - **`SCRUM-871` (In Review, assignee Fouzan Shakil) is the likely origin of the PR's premise
    and does not support its scope.** Its title — *"When you create a new tenant the system
    automatically provisions several default Data from other tenant in Billing code type"* — reads
    as unwanted provisioning, but its only comment (Aiman Farooq, QA, 2026-08-21) reframes it as a
    **leak**: *"One Billing Code is appearing in the new tenant even though it should not. Please
    investigate the tenant data isolation for Billing Codes."* That is `SCRUM-537`'s isolation
    problem (a row belonging to another tenant being visible), not a statement that a new tenant
    must have no departments, roles, industries or premiums. It names **billing codes only**.
  - **`SCRUM-925` (2026-08-24 planning) is a precedent in the opposite direction, for one table
    only:** *"No data migration, no seed. `CraftCode` starts empty; admins create every craft and
    its rates through the API."* Written for craft codes, not generalised.
- **Blocked:** PR #421 (`refactor/explicit-tenant-seeding`) cannot be signed off as
  product-correct — it changes `apps/api/src/usecase/admin/admin-tenants.service.ts` and
  `apps/api/src/usecase/tenant-companies/tenant-companies.service.ts` against no written
  requirement, and against `SCRUM-467`/`SCRUM-593`. `SCRUM-871` cannot be closed until it is known
  whether the ask was "stop seeding" or "stop leaking". Also open by consequence: no script yet
  exists for the `SEED_TENANT_CODE` path the PR leaves as the only way to populate a tenant.
- **Owner:** Fouzan Shakil (assignee of `SCRUM-871` and the named decider on the 2026-08-20/25
  decision notes), with Ehtesham Anwar for what onboarding a second tenant is meant to look like.


## Departments — does archive replace delete outright, and what may an archived department still be used for

- **Status:** open
- **Asked:** 2026-08-31 — PR #422 review (branch `feat/SCRUM-648`, Path B per
  `.ai/aidlc/processed.log`:57, so there is no `SCRUM-648/spec.md` §12 to hold this); tcg-scrum
  escalation
- **Question:** [decisions/2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md)
  settles that archive is the removal action app-wide and that the mechanism is the existing
  `archivedAt` column. It explicitly does **not** settle the three things PR #422 decided for
  departments, each answerable in a line. **(a) Does `DELETE /departments/:code` go away, or stay
  alongside archive?** The PR removes it; the decision says the fate of the `DELETE` endpoints is
  undecided, and every other converted entity kept theirs (see *Weak signals*). **(b) May a
  department be archived while employees or department roles still reference it?** Hard delete
  blocked on both counts; archive has no reference guard, and with `DELETE` gone there is now no
  operation anywhere that enforces one — a department can leave the active list while staff are
  still assigned to it. Is that intended, or should archive warn, block, or require reassignment
  first? **(c) What may an archived department still be selected in?** `GET /departments` now
  defaults to `archivedAt: null`, so archived departments disappear from the employee create form,
  both asset forms and the dashboard as well as from the list. Is disappearing from every picker
  the intended participation rule, and what happens to employees and assets already pointing at a
  department that is later archived?
- **Sources checked:** [INDEX.md](../INDEX.md); [STRUCTURE.md](../STRUCTURE.md) routing;
  `decisions/` (17 notes) — **only two touch archive, and both disclaim this ground.**
  [decisions/2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md)
  → *What this does NOT settle* names "whether the `DELETE` endpoints stay" and "what an archived
  record still participates in (search, reports, references from live records)" as open;
  [decisions/2026-08-20-planning-tracker-archived-filter.md](../decisions/2026-08-20-planning-tracker-archived-filter.md)
  confirms `archivedAt: null` as the correct *default* for one surface and then says in terms that
  the statement "was not made app-wide" and does not tell other listing surfaces what to do. No
  decision note mentions departments at all. `admin/INDEX.md` (one content file,
  `tcg-documents.md`, on attachments); this register; vault-wide grep for `department` — the only
  product-level department content is a four-bullet section in
  [customers/customer.md](../customers/customer.md):84–91 (naming, sorting, description copy,
  role permissions) which **says nothing about deleting or archiving a department**; every other
  hit is ADP's org-unit codelist or a meeting transcript. `payroll/INDEX.md`, which owns the
  `departments` usecase per [STRUCTURE.md](../STRUCTURE.md):40, has **no department content**.
  **Jira was not consulted — no Jira MCP was available in this session**, so `SCRUM-648`'s own
  description and `SCRUM-652` (referenced by `customers/customer.md` item 11) are unread and could
  still carry an answer. Check those before treating this as fully unsourced.
- **Weak signals, not answers:** the app-wide decision's design guidance is *"like other entities
  already have… the answer to 'how should archive behave here?' is 'read one of the 17'"*, which
  makes the existing implementations the nearest thing to a written rule. They point **away** from
  (a) and **toward** (b)'s archive half. Nineteen Prisma models now carry `archivedAt`. Of the
  entities with `archive`/`unarchive` endpoints, **every one except quotations also kept its
  entity-level `DELETE`** — yards, purchase-orders, customers, manufacturers, plans, vendors,
  agencies, categories, sub-categories, tools, assets, price-listings, permits, employee, parts,
  projects, billing-codes. Departments is now the second entity in the app to have archive and no
  delete. Conversely, archive **without** a reference guard is the settled pattern:
  `apps/api/src/usecase/customers/customers.service.ts` keeps the reference counts on `remove()`
  and deliberately omits them from `archive()`, commented *"so referenced records… stay intact"*.
  So (b) is only a departure because (a) removed the guarded path — answer (a) and (b) may follow.
  All of this is **code, which is not a requirement source**; it is cited to show which way the
  convention runs, not to settle anything.
- **Not in question:** the All / Archived quick filters themselves. `customers/customer.md` item 11
  asks for an archived quick filter above the search bar **"(across the app)"**, and the PR uses
  the shared `buildAllArchivedQuickFilters` helper that nine other listings already use. That file
  is an unverified cross-module punch list, so the support is weak, but it is written.
- **Blocked:** PR #422 (`feat/SCRUM-648`) cannot be signed off as product-correct. Also blocked by
  consequence: whether the other 17 entities should now lose their `DELETE` endpoints too, since
  departments is the first to do so and nothing records that as the intended direction.
- **Owner:** Fouzan Shakil for (a) and (b) — he is the named decider on the app-wide archive
  decision, and this is the first case that tests what it meant — with Ehtesham Anwar for (c), as
  the only recorded voice on departments as org structure
  (`meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md`:68, :72).
- **Cross-link:** payroll/gaps.md → *Pointers — departments archive* (STRUCTURE.md:40 routes the
  `departments` usecase to payroll, and (b) turns on employee assignments)
## Which countries, states and cities may an address name?

- **Status:** open
- **Asked:** 2026-09-01 — PR review of branch `feat/us-geo-package-lookup` (no ticket, no
  `.ai/aidlc/` folder, no `processed.log` row); tcg-scrum escalation. Routed here because
  [../STRUCTURE.md](../STRUCTURE.md):42 assigns reference data *(addresses, cities, states,
  countries, industries)* to this module. Form-interaction half in
  [../customers/gaps.md](../customers/gaps.md).
- **Question:** The branch replaces the DB-seeded `Country`/`State`/`City` tables with the
  `@countrystatecity/countries` npm package behind the same endpoints, and narrows what the
  pickers offer. Three parts, each answerable in a line. (a) Is **United States the only
  selectable country**, or is the full list kept with the US merely pre-selected? (b) Does the
  state list stop at the **50 states + DC**, or must **Puerto Rico, Guam, the US Virgin Islands,
  American Samoa, the Northern Marianas** and the **military postal regions (AE/AA/AP)** be
  selectable — TCG bills federal and military work, and an APO address cannot be entered without
  them. (c) Whose **city name vocabulary** is canonical: the package's (`New York City`,
  `Washington D.C.`) or the names already stored (`New York`, `Washington`)?
- **Sources checked:** **Vault — nothing on any of the three.** `INDEX.md`; `admin/INDEX.md`
  (the module's one content file is `tcg-documents.md`, on attachments); `admin/gaps.md`;
  `../customers/customers-INDEX.md` and all five candidates; `../decisions/` (24 notes, none on
  addresses, geography or reference-data vocabulary); vault-wide grep for `countr`, `iso 3166`,
  `puerto rico`, `territor`, `guam`, `military postal` — **no vault file states a country list, a
  state value set, or a city naming rule.** `../STRUCTURE.md`:42 routes the facet here but no
  content sits behind it. `.ai/aidlc/` — no ticket mentions any of these terms.
- **Jira sources the default, not the restriction.** `SCRUM-39` *Country Field Should Be Dropdown
  and Pre-Selected as USA* (Done, 2026-04-16) and `SCRUM-60` (Done, same day, Yards) both ask for
  *"a dropdown with **predefined options**"* with *"**USA pre-selected by default**"*. A default
  inside a list is not a list of one, so (a)'s narrowing is **not** covered by them. `SCRUM-103`
  (Done) fixes the field order *Country → State → City → Zip* and keeps Country on every form.
  Both reporters are **Aiman Farooq, CodingCops QA** — the same internal-QA voice whose scope
  judgement `../customers/gaps.md` → *Customer-level comments* records as having overwritten a
  client ask, so these are not adjudicated product decisions and no decision note was written
  from them.
- **Two written counter-signals to the narrowing:**
  - **`SCRUM-36`** *Missing Dependent Location Fields…* (Done, 2026-04-15) presupposes country is
    changeable: its repro step is *"**Change country/region** or attempt data entry"*, and its
    expected result is that *"Phone Number, Fax, and Zipcode fields should enforce
    **country/region-based validation and formatting rules dynamically**"*. Dynamic per-country
    formatting has no purpose in a one-country picker.
  - **The FCC migration loads 252 countries and 73 states.**
    [../meetings/2026-08-26-fcc-migration-client-brief.md](../meetings/2026-08-26-fcc-migration-client-brief.md):68
    lists *States / countries — 73 / 252* as a **loaded** module. 73 is 22 more than 50 + DC.
    Nothing supersedes that row, and this branch stops loading it (see next entry).
  - **Every Jira ticket names the field "State / Province"**, not "State" — `SCRUM-36`,
    `SCRUM-29`, `SCRUM-28`, `SCRUM-17`, and `SCRUM-962` (To Do, created 2026-09-01 by Umair Khan)
    calls it *"Province"* outright. "Province" is not a US subdivision, so the shipped label and a
    50-states-plus-DC list disagree about what the field is for.
- **Weak signal for US-centricity, not a decision:** the legacy FCC extract
  (`../payroll/legacy-payroll-app-db-extract/data/source-feed.md`:170, :175) shows every sampled
  customer row carrying `Country=USA` and `StateCode=CA`. That is migration data describing a
  California crane business, not a statement about what the picker must offer.
- **`SCRUM-962` is the branch's likely origin and does not authorise any of this.** *"Verify and
  fix the City and Province dropdowns, as they were not displaying correctly. The dropdown data
  should be populated correctly through the relevant API."* — a display defect, To Do,
  unassigned, created the same day as the branch. It asks for the dropdowns to work, not for the
  country list to shrink or the city vocabulary to change.
- **Blocked:** sign-off of `feat/us-geo-package-lookup` as product-correct; `SCRUM-962` closure.
  (c) additionally puts a **shipped, twice-ticketed behaviour at risk** — `SCRUM-789` (Done) and
  `SCRUM-819` (Done) filter the **Permits Agency dropdown by the selected City**, so a change of
  city vocabulary can silently empty that dropdown for agencies attached to the old names. That
  consequence needs checking whichever way (c) is answered.
- **Owner:** Brian Petros (data and migration — the recorded voice on FCC address data), with
  Melissa McNutt for what the forms must offer operationally.

## Do the Country/State/City tables stay, and does the FCC load still ship 73 states / 252 countries?

- **Status:** open
- **Asked:** 2026-09-01 — PR review of branch `feat/us-geo-package-lookup` (no ticket);
  tcg-scrum escalation.
- **Question:** The branch leaves the Prisma `Country`, `State` and `City` models in place but
  removes every writer — verified at `apps/api/src/utility/seed-data.ts`:927–929 (*"Countries,
  states and cities are no longer seeded"*) and `apps/api/fcc-seeder/src/seed-all.ts`:134–135
  (*"States and countries are not imported"*). No drop migration ships. Two parts, each
  answerable in a line. (a) Do the three tables get **dropped**, **kept as a historical record**,
  or **kept because something still needs to write them**? (b) The FCC migration brief advertises
  *States / countries — 73 / 252* as loaded; is **retiring that load** intended, and does TCG need
  telling, given they are reviewing the brief row by row?
- **Sources checked:** **Vault — nothing.** `../decisions/` (24 notes; the nearest,
  [../decisions/2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md),
  governs **entity records**, not schema tables, and settles neither); `admin/INDEX.md`;
  `../STRUCTURE.md`:42; `.ai/aidlc/` (no ticket). Jira: no ticket proposes removing, keeping or
  dropping these tables.
- **The vault treats an orphaned column as a defect, not a pattern.**
  [../customers/gaps.md](../customers/gaps.md) → *Customer-level comments* records
  `comments String[] @default([])` as surviving on `model Customer` *"orphaned with no UI"* — cited
  as part of an open problem needing resolution. So *"left in place with no writers"* has a
  precedent here, and that precedent is a complaint.
- **Related, same class:** *What a newly created tenant must contain* (above) already asks which
  reference data a tenant gets on day one and explicitly lists **industries**; countries, states
  and cities are the same facet in `../STRUCTURE.md`:42 and should be answered with it, not
  separately.
- **Blocked:** nothing ships broken — the endpoints keep serving. This needs an answer before the
  tables are dropped, and before the next FCC migration review with TCG.
- **Owner:** Brian Petros for the migration half; Fouzan Shakil for the schema half.

## Is an ODbL share-alike geo dataset acceptable, and who signs that off?

- **Status:** open — **not a product question.** Recorded here because no register owns it.
- **Asked:** 2026-09-01 — PR review of branch `feat/us-geo-package-lookup`; tcg-scrum escalation.
- **Question:** The branch adds `@countrystatecity/countries`, chosen over the GPL-licensed
  `country-state-city` and over a React UI kit, on the stated grounds that its **ODbL** licence is
  the more permissive of the two. ODbL is a **share-alike database licence carrying an attribution
  obligation**, so two things need a named human, and neither is the product team's: (a) is ODbL
  acceptable for a commercial closed-source ERP, and who at TCG or CodingCops accepts that risk?
  (b) is the **attribution requirement discharged** anywhere a user or auditor can see it — the
  branch adds none.
- **Sources checked:** **no third-party-licence or dependency policy exists anywhere.** `domain/`
  (the six SOP files — the vault's only `verified` content — cover SDLC, sprint planning, standup,
  grooming, sprint close and Jira ticket standards, and none mentions dependencies or licensing);
  `../decisions/` (24 notes; the two grep hits for *licence* use the word idiomatically); no
  `LICENSE` file at repo root; `.ai/aidlc/GUIDE.md` and the ticket folders carry no dependency
  gate. So the choice is not *contradicted* by anything — there is simply no policy to check it
  against, and no reviewer who is designated to.
- **Blocked:** nothing technically. Flagged because a licence obligation adopted with no owner and
  no attribution is the kind of thing found later by someone else.
- **Owner:** **not the product team** — whoever owns legal and IP risk at CodingCops (escalate via
  Ehtesham Anwar), with a standing dependency-licence rule as the durable fix.

## Whose company identity do customer-facing emails carry when a deployment sets no env?

- **Status:** open
- **Asked:** 2026-09-01 — PR review of branch `fix/quotation-das-resources` (no ticket);
  tcg-scrum escalation. Raised on quotation delivery email; routed here because tenancy and
  settings are this module's, per [../STRUCTURE.md](../STRUCTURE.md). Pointer in
  [../quotations/gaps.md](../quotations/gaps.md).
- **Question:** `COMPANY_ADDRESS_LINE`, `COMPANY_EMAIL`, `COMPANY_PHONE` and `COMPANY_WEBSITE`
  defaulted to empty strings, so any deployment that had not set all four sent customers a
  quotation email with the tenant name and a blank footer — while the PDF attached to that same
  email carried TCG's full address block. The branch fixes the blank footer by defaulting the four
  keys to TCG's own details (4820 Harbor Industrial Way, Los Angeles; `billing@thecraneguys.com`;
  (310) 555-0148), matching what the quotation document prints. Two questions, each answerable in
  a line. (a) Is a **hardcoded TCG identity** the right fallback, given that a second tenant which
  forgets the env would then mail *its* customers TCG's address and billing email — a worse
  failure than a blank footer, because it is wrong rather than merely empty? (b) Should company
  identity be **per-tenant data** on the tenant company record and administered in settings,
  rather than per-deployment environment variables at all? The env-var design already assumes one
  tenant per deployment, which nothing in the vault establishes.
- **Sources checked:** **Vault — nothing.** Vault-wide grep for `company address`,
  `COMPANY_ADDRESS`, `email footer`, `branding`, `Harbor Industrial`, `thecraneguys.com` outside
  `meetings/` returns one hit, [../assets/user-story-and-tasks.md](../assets/user-story-and-tasks.md):168
  — *"Branding/logo"* as a required element of the **printed** quotation, not email, and from
  personal-space provenance. `admin/INDEX.md` (the module's one content file is
  `tcg-documents.md`, on attachments); `decisions/` (21 notes, none on company identity, branding
  or tenant profile data); `.ai/aidlc/` (no ticket). The phone number's `555` exchange is a
  reserved-for-fiction range, so at least one of the three defaults is placeholder rather than
  TCG's real detail — which the answer to (a) should confirm either way.
- **Related:** *What a newly created tenant must contain* (above) — same class of question, and
  the same unstated assumption about whether the platform is single- or multi-tenant in practice.
- **Blocked:** nothing is blocked — the branch's behaviour is strictly better than the blank
  footer it replaces. This needs an answer before a second tenant is onboarded, not before merge.
- **Owner:** product team, with Ehtesham Anwar for the second-tenant question.

## A SUPER_ADMIN inside a tenant cannot create tenant-scoped records at all

- **Status:** open
- **Asked:** 2026-09-01 — creating a department in a fresh tenant while signed in as a
  `SUPER_ADMIN` whose `tenantCompanyId` is that tenant. Not a ticket question; found in use.
- **Question:** should a `SUPER_ADMIN` be able to belong to a tenant at all, and if so, what
  tenant do its writes land in? Today the combination is created without objection by the admin
  user form and then **fails on every tenant-scoped create with a 500**, not a permissions
  message: `Argument 'tenantCompany' is missing`.
- **Why it happens:** the tenant-scoping Prisma extension short-circuits on role —
  `apps/api/src/orm/prisma.service.ts:230`, *"Super admins operate across all tenants — skip
  tenant scoping"* — and returns the query untouched. Services that rely on the extension to
  inject `tenantCompanyId` therefore get nothing injected. `DepartmentsService.create()` is one:
  it passes the form data straight to the repository and never sets the tenant itself, so Prisma
  rejects the create. Services that set `tenantCompanyId` explicitly — `craft-codes`,
  `craft-modifiers`, `sub-categories` — are unaffected, so the behaviour is **inconsistent across
  modules** and only shows up on the ones that delegate.
- **The read side is worse than a 500, because it is silent.** The same skip means such a user
  sees every tenant's rows in every list and picker. Observed: 33 departments offered in a tenant
  that owns none. Choosing one would write another tenant's `departmentId` onto a local record,
  with no guard on either the read or the write.
- **Sources checked:** `prisma.service.ts:226-239` — the two skip conditions are `!context` and
  `userRole === SUPER_ADMIN`; **neither checks whether the user belongs to `PLATFORM`**.
  `admin-users.service.ts:91` — `role: (data.role ?? 'USER')`, so the API accepts `SUPER_ADMIN`
  for a user being created inside a specific tenant and nothing rejects it.
  `admin-tenants.service.ts` `create()` — creates the tenant row only, no user, so the
  tenant+SUPER_ADMIN pairing is made by hand rather than by the product.
  `decisions/` — nothing on super-admin tenancy. `meetings/` — nothing.
- **Note:** whichever way it is answered, the two halves are separable. *Should the combination
  exist* is a product question. *Should a create 500 when it does* is a defect either way —
  `DepartmentsService` should set `tenantCompanyId` explicitly like its neighbours rather than
  depending on an extension that is documented as conditional.

## Must an entity picker search the server, or only offer a search box?

- **Status:** open
- **Asked:** 2026-09-02 — PR review of branch `feat/move-dropdowns-BE` (no ticket, no
  `.ai/aidlc/` folder, no `processed.log` row); tcg-scrum escalation. Routed here as the
  app-wide picker standard; per [../STRUCTURE.md](../STRUCTURE.md):60 a cross-module question
  goes to the module most likely to own the answer.
- **Question:** The branch converts entity dropdowns across the app to server-searched,
  paged pickers and adds a pre-push guard that fails a build reintroducing a whole-table read.
  The written asks stop short of that. **Does "searchable dropdown" mean the option set is
  fetched per keystroke from the API, or only that the control has a search box over whatever
  it already holds?** The two differ in a user-visible way: a server-searched picker's
  empty-search state is **deliberately incomplete**, so a user who scrolls without typing no
  longer sees every row. Nobody has said that trade is acceptable, and no page-size, ranking or
  empty-state rule is written anywhere.
- **Sources checked:** **Vault — nothing states a picker data-loading rule.** `INDEX.md`;
  this module's `INDEX.md` (its one content file is `tcg-documents.md`, on attachments);
  `../customers/customers-INDEX.md` and all five candidates; `../quotations/quotations-INDEX.md`;
  `../decisions/` (24 notes — none on pickers, list loading or search); vault-wide grep for
  `dropdown`, `type-ahead`, `autocomplete`, `combobox`, `debounce`, `paginat`, `preload`,
  `infinite scroll`. The only vault hits describe *which* dropdowns exist or how they look
  (`../vendors-agencies/vendors.md`:47 linked Category/Sub-Category, `../quotations/quotation.md`:13
  "should open upwards", `../dispatch/daily-allocation-system.md`:33), never how their options load.
- **Jira sources the intent but not the mechanism, and the clearest line is internal-QA voice:**
  - **`SCRUM-952`** *Searchable dropdown* (**To Do**, 2026-09-01, Umair Khan) — *"Each dropdown
    across the app should have a **search option**."* This is the branch's likely origin and it
    asks for the **affordance**, not for server-side resolution. A client-filtered list satisfies
    it as written.
  - **`SCRUM-638`** *Employee* (Done, 2026-07-08, Aiman Farooq) item 20 — *"Implement **infinite
    scrolling** in dropdowns so paginated data is loaded progressively instead of loading
    everything at once"*, prompted by item 19: *"There are **76 assets** in total, but the
    dropdown is not displaying all of them."* This is the **only** written line that asks a
    dropdown not to load its whole table, and its stated remedy is progressive scroll, not
    type-ahead search. `SCRUM-639` item 32 and `SCRUM-638` item 34 add *"Handle pagination and
    search on the backend instead of the frontend"* — both about **listing tables**, in listing
    context, not pickers.
  - **`SCRUM-703`** *move pagination, filteration searching(debounce) on backend (across the app)*
    (Done, 2026-07-16, Umair Khan, **no description**) — the Jira twin of
    [../customers/customer.md](../customers/customer.md):16 item 4. Verbatim scope, zero detail,
    already **Done**; whether "across the app" was ever meant to reach entity pickers is exactly
    what is unrecorded.
  - Reporter caveat: `SCRUM-638`/`639`/`952` are **CodingCops internal voices** (Aiman Farooq,
    Umair Khan), the same class this register already flags under *Which countries, states and
    cities may an address name?* as not adjudicated product decisions. `customer.md` is a **punch
    list** — a bug list, not a specification — and cross-module, per
    [../gaps.md#feedback-punch-lists-are-not-scoped-to-the-module-they-are-filed-under](../gaps.md).
- **The convention is written, but a rule cannot make a requirement true.**
  `.ai/claude/contexts/web.md`:98–172 states the rule in full and a pre-push guard
  (`scripts/check-dropdown-preloads.sh`) enforces it. That file is the sanctioned home for **how
  we build**; it is not a product source, and it was edited on the same branch as the code it
  describes.
- **Blocked:** sign-off of `feat/move-dropdowns-BE` as product-correct; closure of `SCRUM-952`.
  Nothing ships broken — the API routes are dual-mode, so an unparameterised call still returns
  the bare array.
- **Owner:** Mohsin Ali for the UX standard (the punch lists are his feedback); Fouzan Shakil
  for whether the guard stays a hard gate.

## Is the countries/states/cities preload an intended exemption, or an unreviewed carve-out?

- **Status:** open
- **Asked:** 2026-09-02 — PR review of branch `feat/move-dropdowns-BE` (no ticket);
  tcg-scrum escalation.
- **Question:** Every other entity picker on the branch moves to server search; countries,
  states and cities keep a **preloaded list with a 24-hour client cache**
  (`apps/web/src/features/countries/hooks/use-countries.ts`:14,
  `features/states/hooks/use-states.ts`:14, `features/cities/hooks/use-cities.ts`:24). Two parts,
  each answerable in a line. (a) Is the **24-hour staleness** acceptable for address reference
  data, given a newly added city would not appear for a day? (b) The same data is reached **two
  different ways on purpose** — `components/molecules/address-fields.tsx` preloaded, Permits'
  `CitySelect` server-searched. `web.md`:153–155 calls that inconsistency *"known and intended"*.
  **Intended by whom?** Two controls over one dataset behaving differently is the kind of thing a
  user reports as a bug.
- **Sources checked:** **Vault — nothing on either part.** The two open entries above
  (*Which countries, states and cities may an address name?*, *Do the Country/State/City tables
  stay…*) cover **which values** are offered and **where they are stored**; neither touches how
  the picker loads them or how long it may hold them. `../decisions/` — none on caching,
  staleness or reference-data freshness. Jira: `SCRUM-549` (Done) and `SCRUM-962` (To Do) are
  both **display defects** — the city dropdown not working — and neither states a loading or
  caching strategy.
- **Note:** (b) is the more consequential half. If the answer is that the inconsistency is *not*
  intended, the fix direction matters: `SCRUM-789` and `SCRUM-819` (both Done) filter the Permits
  Agency dropdown by the selected city, so the two controls are not interchangeable today.
- **Blocked:** sign-off of the exemption in `feat/move-dropdowns-BE`. Should be answered together
  with the two geo entries above — same facet, same owner.
- **Owner:** Fouzan Shakil for the caching decision; Melissa McNutt for whether one-day staleness
  is operationally acceptable on an address field.

## The picker's two tuned numbers — a 400 ms delay and a 100-row ceiling — rest on nothing written

- **Status:** open
- **Asked:** 2026-09-02 — PR review of branch `perf/dropdown-search-requests` (no ticket, no
  `.ai/aidlc/` folder); tcg-scrum escalation. Follow-on to `feat/move-dropdowns-BE`, whose picker
  standard is open above (*Must an entity picker search the server, or only offer a search box?*).
  Routed here for the same reason: both numbers sit on **app-wide shared code** —
  `apps/web/src/lib/searchable-list-query.ts` and
  `apps/api/src/presentation/shared/dto/query-picker.dto.ts` — so they set the standard for every
  picker and all 17 picker routes at once.
- **Question:** Two values the branch picks, each answerable in a line. **(a)** Every server-driven
  search in the app now waits **400 ms** after the last keystroke (`SEARCH_DEBOUNCE_MS`); pickers
  previously waited 250 ms. Debouncing itself is asked for (below) — but **nothing written says how
  long a user may wait for search results**, so there is nothing to check 400 against, and nothing
  that would call 250 or 600 wrong. Is a 400 ms floor on perceived search latency acceptable
  app-wide, list tables and pickers alike? **(b)** A picker route now refuses a `limit` above
  **100** (`QueryPickerDto` `@Max(500)` → `@Max(100)`) — a hard ceiling on what any client may ask
  of 17 routes. Is 100 the intended ceiling, and should one number govern every picker family? It
  does not today: `query-resource-catalog.dto.ts` carries **both** `@Max(100)` (:32) and `@Max(500)`
  (:50), and `query-reference-code-list.dto.ts` keeps `@Max(500)` (:22).
- **Sources checked:** **Vault — nothing sets a search-latency or page-ceiling rule.** `INDEX.md`;
  this module's `INDEX.md`; `../decisions/` (25 notes — none on latency, debounce, caching or page
  size); `../customers/customers-INDEX.md` and all five candidates; the picker entries in
  `../assets/gaps.md` and `../quotations/gaps.md`. Vault-wide `rg` for `debounce`, `250ms|400ms`,
  `abort|cancel`, `hasMore`, `page size|pageSize|per page|page limit`, `keystroke|as you type`,
  `latency|responsive|slow`. **No vault file states a millisecond value of any kind.** The only
  page-size statement anywhere is [../assets/user-story-and-tasks.md](../assets/user-story-and-tasks.md):96–97
  — *"Default records per page is 25"*, *"User can select other page sizes (e.g. 25 / 50 / 100)"* —
  which is **customer-listing pagination, not a picker**, and sits in the vault's least
  authoritative file (a personal Confluence space; check its `provenance_note`). The one
  performance NFR that exists,
  [../field-ops/frd-new-format-draft/07-non-functional-requirements.md](../field-ops/frd-new-format-draft/07-non-functional-requirements.md):23,
  asks only for *"acceptable response times under field network conditions"* — mobile, and
  unquantified.
- **Jira asks for debouncing three times and never names a value; nothing asks for a limit ceiling.**
  - **`SCRUM-845`** *Implement Search Debouncing in Permit Tracker and Planning Tracker* (**To Do**,
    2026-08-03, Aiman Farooq) — *"Searching… is triggering **excessive API requests**… Implement
    search debouncing in both modules to **reduce unnecessary API calls** and improve performance."*
    The clearest statement of intent in either source, and it names **two tracker modules**, not the
    app.
  - **`SCRUM-870`** *add debounce to search* (**QA**, 2026-08-10, ali riaz) — body is a **Loom link
    only**, unreadable from here; whatever it shows is not written down anywhere.
  - **`SCRUM-703`** *move pagination, filteration searching(debounce) on backend (across the app)*
    (Done, 2026-07-16, Umair Khan, **no description**) — the only "across the app" phrasing, and
    zero detail. Twin of [../customers/customer.md](../customers/customer.md):16 item 4.
  - **`SCRUM-757`** *Performance Issues and Excessive API Calls…* (To Do, 2026-07-16) — *"opening a
    single page triggers multiple repeated API requests… unnecessary network activity that could
    negatively impact performance and scalability"*. Sources the direction this branch's aborting
    serves, on the Plan Comments page.
  - **Reporter caveat:** all four are **CodingCops internal voices** (Aiman Farooq, Umair Khan,
    ali riaz) — the same class this register already flags under *Which countries, states and
    cities may an address name?* as not adjudicated product decisions.
  - `SCRUM-801` *Vendor: Pagination limit is missing* and `SCRUM-804` (both Done) concern the
    **row-count selector on listing tables**, not a server-side cap, so neither reaches (b).
- **Note — the branch's own ticket does not source either number.** **`SCRUM-963`** *Move the
  search dropdowns to fetch from backend instead of showing cached data* (**QA**, created
  2026-09-02 15:27, Fouzan Shakil, self-assigned, **no description, no comments, no labels**) was
  filed for the predecessor branch after the fact. It records *that* the work happened, and its
  title reaches only the cached-data move — not debouncing, aborting, caps or counting. Worth
  knowing when reading the entry above, which was written when no ticket existed at all.
- **Note — three sibling behaviours were checked and need no product answer, so they are not
  asked here.** **Aborting a superseded request** is the mechanism `SCRUM-845`/`SCRUM-757` ask for,
  and the only thing a user sees is that stale rows stay up while the replacement loads
  (`isAbortError` gates the `catch`) rather than the panel blanking mid-type. **Dropping `total`
  from `findPickerList`** is invisible: `AsyncComboboxPage` only ever carried `items` and `hasMore`,
  no picker UI read a count, and the admin list routes that page with numbered controls still
  return `total`. **Filling the panel immediately on an empty query** changes *when* the first page
  arrives, not which rows it holds. The real product question about that empty state — that it is
  **deliberately incomplete** — is already open above and this branch does not move it.
- **Blocked:** nothing ships broken. (a) is a reversible constant; (b) only narrows what a client
  may request. What is blocked is signing either number off as intended, and settling the
  three-way cap inconsistency in (b) before more routes copy one of them.
- **Owner:** Mohsin Ali for (a) — the search-responsiveness standard, the same owner as the picker
  UX question above; Fouzan Shakil for (b) and for whether one cap governs every picker DTO.

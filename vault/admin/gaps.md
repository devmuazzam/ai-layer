---
title: Admin — open questions
status: reference
kind: gaps
updated: 2026-08-31
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

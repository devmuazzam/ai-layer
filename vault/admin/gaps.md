---
title: Admin — open questions
status: reference
kind: gaps
updated: 2026-09-07
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
- **Status:** open
- **From (frozen original):** [gaps.md#integrations-hubspot-microsoft-365-dialpad-mapsly](../gaps.md#integrations-hubspot-microsoft-365-dialpad-mapsly)
- **Update 2026-08-27:** Brian Petros, written message to the TCG team, 2026-08-27 ("A couple things that came up in my discussion with CodingCops today, that we'll discuss in future meetings"), following the 2026-08-26 ERP sprint review — logged in [payroll/client-message-findings.md](../payroll/client-message-findings.md#cross-module--2026-08-27-follow-ups-after-the-fcc-migration-first-pass-brian-petros) — still open; Brian re-lists "have Patrick explain more details
  regarding Customer data synced with HubSpot & Microsoft". The 2026-08-26 sprint review
  (`../meetings/transcripts/2026-08-26-erp-sprint-review.md`, ~18–20 min) adds the shape:
  Microsoft, HubSpot and Dialpad are synced with each other, **FCC is not**, and salespeople may
  update contacts in HubSpot — so the customer/contact migration from FCC may be the stale copy.
  Customer-side pointer: customers/gaps.md. The brief names the contact: **Patrick McKiernan**, and adds "show legacy FCC ID on UI" — the annotated migration brief, [meetings/2026-08-26-fcc-migration-client-brief.md](../meetings/2026-08-26-fcc-migration-client-brief.md) A1.
- Update 2026-09-04 (Project Repository ingest): the drop answers most of part (a) — *what the
  integrations do* — for HubSpot and Microsoft 365, nothing for Dialpad or Mapsly, and leaves
  part (b) — *what moves into the ERP* — with three client statements that do not line up and no
  decision. **The "Candidates: none of substance" line above is now stale.** (i) HubSpot — Ryan
  Adams' sales governance set (client-authored, dated 2026-08-06) defines it as *"a shared system
  of record for opportunities, customers, contacts, activity, follow-up and forecasting"*, the
  owner of opportunity stage, owner, next action, follow-up, quote status and lost reason, with a
  12-stage lifecycle and a company/contact/jobsite data standard
  ([quotations/hubspot-sales-playbook.md](../quotations/hubspot-sales-playbook.md) §1–3;
  [quotations/sales-operating-system/01-operating-system-architecture.md](../quotations/sales-operating-system/01-operating-system-architecture.md)
  §9). The same set names **six systems of record — HubSpot, FCC, Outlook, company file storage,
  QuickBooks, FAA/external portals — and no integration between them**: the Sales Coordinator
  *"must reconcile differences before handoff"*
  ([03-sales-coordinator-operations-manual.md](../quotations/sales-operating-system/03-sales-coordinator-operations-manual.md)
  §3), and the controlled forms file to *"FCC, HubSpot, Accounting files"* / *"HubSpot/FCC"*
  ([05-forms-and-records-matrix.md](../quotations/sales-operating-system/05-forms-and-records-matrix.md)
  §2). (ii) Microsoft 365 — TCG's own RFP (client-authored, *DRAFT v1.0*, February 2026) lists it
  among the systems in use (*"email, file storage, profiles/Active Directory — OneDrive,
  SharePoint, Teams"*), makes it a **High-priority required integration — "SSO, user directory,
  document storage (SharePoint/OneDrive)"**, *"SSO via Azure AD"*, and adds a Phase 1 *"Microsoft
  365 Optimization"* module
  ([admin/tcg-erp-rfp-2026-02-26.md](tcg-erp-rfp-2026-02-26.md) → *Required integrations*, *Phase
  1*). The Teams rollout deck says TCG is *"moving our day-to-day communication and file sharing
  into Microsoft Teams"* ([project-repository-filing-rules.md](project-repository-filing-rules.md)
  → *The companion Teams rollout deck*). FCC practice, not a decision: NexGen user IDs come *"from
  Active Directory — this is for all users, including field employees"*
  ([fcc-nexgen-administration-and-security.md](fcc-nexgen-administration-and-security.md) §4).
  (iii) Dialpad and Mapsly appear **nowhere in the drop**; the only description of either remains
  Brian Petros' oral account at the 2026-08-11 sales-process meeting
  (`../meetings/transcripts/2026-08-11-sales-process.md`, ~57:57–1:02:31: Dialpad transcribes
  calls and texts into HubSpot and is the number salespeople dial out on; Mapsly shows every
  customer near a job walk and lets management see a salesperson's location in working hours; an
  inbound Outlook email adds a missing contact to HubSpot) — which this entry's *Candidates* line
  predates. (iv) The RFP names **neither HubSpot, Dialpad nor Mapsly** in its systems-in-use or
  integrations lists — consistent with the 2026-03-06 transcript (~1:31), where Ryan Adams was
  still choosing between HubSpot and Salesforce, so the RFP predates the CRM stack and cannot
  speak for it. (v) On part (b) the record holds, without a `decisions/` note: RFP Phase 1
  *"Customer & Quote Management — CRM-style customer records"* (February); Melissa McNutt,
  2026-06-25, *"We want to have our own [CRM] where we could develop it and not have HubSpot"*
  (`../meetings/transcripts/2026-06-25-cc-tcg-erp-system.md`, ~47:04), with CodingCops proposing
  an interim fetch-customers-from-HubSpot button; and Brian Petros, 2026-08-11, that job-box intake
  is *"better in the ERP and have the ERP talk directly to HubSpot"* (~1:04:04). Still needs the
  client: Patrick McKiernan's walkthrough of the actual sync (which way each of Outlook → HubSpot,
  Dialpad → HubSpot and HubSpot ↔ Microsoft contacts runs, and whether Mapsly reads HubSpot); a
  named decision on whether the ERP integrates with HubSpot, replaces it, or both in sequence; and
  whether the RFP's Microsoft 365 SSO / SharePoint integration is in the SOW's scope — the SOW
  page names no third-party integration at all
  ([codingcops-sow-and-engagement-terms.md](codingcops-sow-and-engagement-terms.md)).


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
- **Update 2026-09-04 (Project Repository ingest):** No source in the drop states what a new
  tenant must contain — the drop describes FCC, and the question is the ERP's. What it shows about
  current practice, all legacy-system fact and none of it a TCG decision: **(a)** TCG's ten FCC
  departments are TCG-created rows, not vendor defaults — `ST` Storage by `bpetros` 2025-10-31 and
  `CR` Customer Repair by `jstricker` 2025-08-13
  ([../payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md](../payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md)
  → *Department*; [../assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md)
  → *Departments — 10, all active*) — and FCC's own unit-import template ships its
  `Companies / Yards / Departments / States / Salespeople` sheets **empty**, *"so the template as
  delivered cannot be filled in without the tenant's own code lists"* (same page): FCC's model is
  that the customer supplies its code lists. **(c)** TCG's 33 industries are all `Status = 1`
  ([../customers/fcc-legacy-customer-data-model.md](../customers/fcc-legacy-customer-data-model.md)
  → *`FMS_INDUSTRIES`*). **Settings scope:** NexGen's per-company configuration is one row of
  `FMS_SYSTEM_DEFAULT` with **455 columns**
  ([fcc-nexgen-database-catalogue.md](fcc-nexgen-database-catalogue.md) → *The widest tables*),
  and the company record TCG annotated carries counters, payroll defaults, T&Cs/footers and
  branding ([fcc-nexgen-administration-and-security.md](fcc-nexgen-administration-and-security.md)
  → *Company (slides 2–9)*); a second company, *The Repair Guys*, appears only in GL scope.
  Nothing in the drop touches (b) billing code types or (d) the premium catalog as day-one data.
  The client still has to say which of (a)–(d) a new tenant is provisioned with, and whether
  anything gates first sign-in.
- **Update 2026-09-09 (SCRUM-TZ decision) — a fifth item, and this one is answered:** a new
  tenant must also carry a **business timezone**, and it is required at creation.
  [../decisions/2026-09-09-tenant-timezone-configuration.md](../decisions/2026-09-09-tenant-timezone-configuration.md)
  (`status: reference`; Syed Haris, developer/owner — **not** a TCG product owner) makes
  `TenantCompany.timezone` **NOT NULL with no default**; a Pacific default was explicitly
  rejected because *a silent default is how the current timezone bug arose*. Existing rows are
  backfilled to `America/Los_Angeles`. Accepted values are any valid IANA zone id, validated by a
  runtime `Intl.DateTimeFormat` probe rather than a US-only enum. **Consequence for this entry's
  question:** `CreateAdminTenantDto`
  (`apps/api/src/presentation/admin/dto/create-admin-tenant.dto.ts` — today `name`, `tenantCode`,
  `maxUsers?`, `domain?`) must gain the field or tenant creation breaks, and SUPER_ADMIN is the
  only role that may set it
  (`apps/api/src/presentation/admin/admin-tenants.controller.ts:13`). **This answers one item and
  adds it to the list; it does not touch (a) system departments and roles, (b) billing code types,
  (c) industries or (d) the payroll premium catalog**, which is what this entry was raised for.
  **Stays open.**
- **Update 2026-09-09, later the same session — the fifth item is now the *only* chance to get it
  right, and the line above is corrected.**
  [../decisions/2026-09-09-tenant-timezone-is-set-once-at-creation.md](../decisions/2026-09-09-tenant-timezone-is-set-once-at-creation.md)
  (`status: reference`; same decider, same non-ownership caveat) settles that **the tenant
  timezone is never changed** — set once at creation, with **no product surface to edit it**.
  `PATCH /admin/tenants/:id` is cut, not deferred; `UpdateAdminTenantDto` stays as it is
  (verified — `name?`, `tenantCode?`, `status?`, `maxUsers?`, `domain?`, `plan?`, no zone), and
  web has no edit-tenant surface either (`apps/web/src/features/admin/components/` holds
  `admin-create-tenant-modal.tsx` and no edit equivalent). **Correction to the line above:**
  SUPER_ADMIN may *set* the zone, at creation; **no role changes it afterwards**. **Why this
  matters to this entry:** timezone is the one required item on the list with **no second
  chance** — a tenant onboarded with the wrong zone has no in-product correction path and needs
  a database write. Creation-time enforcement (`NOT NULL`, no default) is therefore the entire
  safeguard, not merely good hygiene, which raises the stakes on the eight tenant-creation
  consumers enumerated in `SCRUM-TZ` §12 Q11 — two `qa-automation` seeds and a hand-mirrored web
  type among them, none of which a gate checks. **The entry still stays open:** (a)–(d) remain
  unanswered, and this decision says nothing about any of them.
- **Update 2026-09-11: item (b) no longer has an object in the current build.** Fouzan Shakil
  (CodingCops, `reference`) dropped the `billing_code_types` table, the `BillingCodeTypeStatus`
  enum and `billing_codes.billing_code_type_id`, in migration `20260911040000_drop_billing_code_types`
  on branch `fix/das-fixes`. See
  [../decisions/2026-09-11-billing-code-type-master-dropped.md](../decisions/2026-09-11-billing-code-type-master-dropped.md).
  The default seeds `seedTenantDefaults` provisioned for it are recorded for re-seeding in
  [../quotations/billing-code-types-dropped-2026-09-11.md](../quotations/billing-code-types-dropped-2026-09-11.md).
  Whether TCG needs the lookup at all is a CodingCops call, not a TCG one, so (b) comes back if
  TCG overrules it. **(a), (c) and (d) are unaffected. The entry stays open.**



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

## System departments and roles are now fully editable — was `isSystem` ever meant to protect anything?

- **Status:** resolved (a)–(c) 2026-09-04 — see
  [decisions/2026-09-04-system-departments-and-roles-carry-no-restrictions.md](../decisions/2026-09-04-system-departments-and-roles-carry-no-restrictions.md).
  **Part (d) is not resolved** and continues as its own entry:
  [Deleting the last admin-capable role can lock a tenant out](#deleting-the-last-admin-capable-role-can-lock-a-tenant-out--is-a-floor-required).
  Everything below is left as written, as the record of what was in question.
- **Asked:** 2026-09-04 — PR review of branch `fix/customer-quotation-3sep` (no ticket, no
  `.ai/aidlc/processed.log` row, no `SCRUM-###/spec.md` to hold this); tcg-scrum escalation
- **Question:** the branch removes **every** protection on seeded reference data in the departments
  module, API and web, and nothing written says whether that protection was intended or accidental.
  Four things, each answerable in a line. **(a) May a tenant edit, rename or archive a system
  department?** `DepartmentsService.update()` and `archive()` both dropped
  `ForbiddenException('System departments cannot be modified' / 'cannot be archived')`, and the web
  card menu, the detail hero actions and the edit-route redirect all stopped checking `isSystem`. All
  15 seeded departments (`DEPT-ACCOUNTS` … `DEPT-SALES`) are now editable and archivable like any
  other. **(b) May a system *role* be deleted?** `deleteRole()` dropped
  `ForbiddenException('System roles cannot be deleted')` and the role card now shows the Delete menu
  on protected roles — including `ROLE-ADMIN-CA` (Company Admin) and the two Sales manager roles.
  **(c) `lockedPermissions` is now inert on the edit screen, and it is a separate rule from
  `isSystem`.** `role-create.tsx` no longer passes `role.lockedPermissions` into
  `ModulePermissionsSection`, so the modules a seeded role may not lose are freely changeable:
  Sales Coordinator and Sales Manager carry `['quotations','customers','jobs']`, Dispatch Manager
  carries `['dispatch','asset-management','asset-main-category','asset-sub-category']`
  (`apps/api/src/utility/seed-data.ts`:266-272, 346, 397, 406). The column and the seeded values
  survive in the database and the API still returns them — only the UI stopped honouring them, so
  the rule is now unenforced rather than withdrawn. Is "a role cannot be stripped of the modules
  core to its job" a real rule, and if so where is it enforced? **(d) Is anything a tenant admin can
  do here recoverable?** Role delete is a hard delete (`departmentRolesRepository.delete`), so
  deleting `ROLE-ADMIN-CA` or archiving `DEPT-ADMIN` is a plausible route to a tenant with nobody
  able to administer it. Whether that needs a floor — a last-admin-role guard, or re-running the
  seed — is unstated either way.
- **Sources checked:** **Vault — nothing on protecting seeded reference data.**
  [admin/INDEX.md](INDEX.md) (the module holds one content file, `tcg-documents.md`, on
  attachments); this register; `../decisions/` (26 notes — **none mentions departments, roles,
  permissions or system/seeded records**; the only app-wide UI/behaviour conventions decided so far
  are archive-instead-of-delete and post-save navigation, both Fouzan Shakil's, and neither
  distinguishes a seeded record from a user-created one); [STRUCTURE.md](../STRUCTURE.md):42 routes
  the `seed` facet here and **no content exists behind it**; vault-wide grep outside `meetings/` for
  `isSystem|system-seeded|system department|system role|seeded (department|role|reference)` — the
  **only** hits in the whole vault are this register's own tenant-provisioning entry. The one
  product-level department passage anywhere,
  [customers/customer.md](../customers/customer.md):84-91, is naming/sorting/description copy and
  role permissions and says nothing about a protected set.
- **Weak signals, and they point in opposite directions:**
  - **The design as demoed has no protected set at all.** In
    `meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md`:70 Ehtesham Anwar walks the
    whole flow as user-created — *"you will be able to create departments… to create a department
    role itself you will have the role name, description of the role and all of the permissions"* —
    and the six named presets (manager, admin, editor, viewer, contributor, guest) are introduced as
    a **"quick start template that is going to prefill everything and preselect everything for you
    guys just for the ease of usage"**. A template is a starting point, which supports (c)'s removal
    and says nothing about (a), (b) or (d). No participant asked for a locked department or a locked
    role in that call or any other.
  - **The seeded set exists only because `seed-data.ts` created it, and whether it should exist at
    all is already an open question here** — see
    [What a newly created tenant must contain](#what-a-newly-created-tenant-must-contain--provisioned-defaults-or-an-empty-portal).
    An admin-created tenant comes up with **zero** departments and roles, so `isSystem: true` is
    true only in `PLATFORM` and `TCG-DEFAULT`. **These two questions have to be answered together:**
    if new tenants are never provisioned, unlocking the flag is close to a no-op and the flag should
    probably go; if provisioning is restored, unlocking it decides what a tenant may do to data it
    did not create. Answering this one alone would prejudge that one.
  - **Two closed Jira tickets say the seeded set is deliberate**, quoted in that entry:
    `SCRUM-467` *Seed Departments & Roles* — *"System should include predefined, hardcoded
    departments and their roles"* — and `SCRUM-593` *"Seed default departments; seed manager default
    permissions as per our best understanding."* Neither says whether *predefined* implies
    *protected*, and neither is superseded by anything written.
  - **Direction of travel in the module is the opposite of protection.** PR #422 already removed
    `DELETE /departments/:code` in favour of archive (see the entry above), so departments have one
    removal path and it is now available on seeded rows too.
- **Jira: not consulted — unavailable this session.** The Atlassian MCP returns
  `403 Tenant is restricted: suspended-payment` for both JQL search and single-issue reads, so
  `SCRUM-467` and `SCRUM-593` could not be re-read and any newer ticket asking for this is unseen.
  The quotes above are taken from this register, not from Jira directly. **Check Jira for a ticket
  asking to unlock system departments before treating this as fully unsourced** — a QA or client ask
  is the most likely origin of the change and would settle (a) and (b) immediately.
- **Blocked:** sign-off of `fix/customer-quotation-3sep` as product-correct. Also blocked by
  consequence: whether the `isSystem` and `lockedPermissions` columns should be dropped, kept and
  enforced, or kept and enforced **only in the API** — the branch leaves them populated and
  unenforced, which is the one state that guarantees the next reader guesses wrong.
- **Owner:** Fouzan Shakil for (a)–(c) — he is the named decider on the app-wide archive and
  post-save conventions and the assignee of `SCRUM-871`, the other tenant-defaults ticket — with
  Ehtesham Anwar for (d) and for what a second tenant's admins are meant to be able to do to
  data they did not create (the only recorded voice on departments as org structure,
  `meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md`:70).
- **Resolved 2026-09-04 — (a), (b) and (c). Seeded rows carry no restrictions.** A tenant admin
  may edit, rename, archive and delete an `isSystem: true` department or role exactly as they may
  one they created themselves; `isSystem` is a display badge and nothing more; `lockedPermissions`
  imposes no restriction on the role edit screen. The branch's behaviour is confirmed correct.
  Decided in PR review of `fix/customer-quotation-3sep` by the developer on the branch
  (CodingCops) acting for the product owner — **not by Fouzan Shakil or Ehtesham Anwar**, the
  owners this entry nominated, and not by any named TCG voice. The note is therefore
  `status: reference`, binding on implementation and open to being overruled by TCG. Full
  reasoning, and the parts deliberately left alone, in
  [decisions/2026-09-04-system-departments-and-roles-carry-no-restrictions.md](../decisions/2026-09-04-system-departments-and-roles-carry-no-restrictions.md).
  **Two things stay open.** (d) is untouched — the lockout floor is not an `isSystem` question and
  carries on in the entry below. The tenant-provisioning entry above is untouched by design: this
  settles what may be done to seeded rows *that exist*, not whether they should be created.
  A third, smaller, follows from it — `lockedPermissions` is now inert in the UI and must not be
  enforced in the API either, so the column should be dropped or consciously kept as inert data.
  Populated-and-unenforced is the state this entry originally warned guarantees a wrong guess.

## Deleting the last admin-capable role can lock a tenant out — is a floor required?

- **Status:** open
- **Asked:** 2026-09-04 — carried forward as part (d) of
  [System departments and roles are now fully editable](#system-departments-and-roles-are-now-fully-editable--was-issystem-ever-meant-to-protect-anything),
  whose (a)–(c) were resolved the same day. Separated because the resolution made this a
  question in its own right rather than a sub-case of `isSystem`.
- **Question:** `deleteRole()` is a **hard delete** (`departmentRolesRepository.delete`), and as of
  2026-09-04 nothing stops a tenant admin deleting the last role that carries admin permissions —
  or archiving the department holding it. The result is a tenant nobody can administer, with no
  in-app route back. **Does the platform owe a floor, and what shape?** Three options, each
  answerable in a line: (a) **a last-admin guard** — refuse the delete or archive when it would
  leave the tenant with no admin-capable role, the way a last-owner guard works elsewhere in the
  industry; (b) **no guard, operator recovery** — lockout is an accepted outcome and an operator
  re-runs the seed or restores a role out of band, which needs that route to actually exist; (c)
  **no guard at all** — the tenant owns the consequence. Related but separable: should role delete
  be **archive** rather than hard delete, per
  [decisions/2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md)?
  Archiving would make the mistake reversible without deciding whether to prevent it.
- **Why `isSystem` does not answer it:** the protection removed on 2026-09-04 was shielding
  `ROLE-ADMIN-CA` **by accident** — it shielded every seeded row, admin-capable or not, and shielded
  nothing in a tenant that created its own admin role. A lockout floor keys on *permissions held*,
  not on *who created the row*, so it is a different rule and survives the resolution above.
- **Sources checked:** everything listed under the parent entry — vault-wide grep, `../decisions/`
  (27 notes; the app-wide archive decision is the nearest and does not reach role delete or a
  lockout floor), [admin/INDEX.md](INDEX.md), [STRUCTURE.md](../STRUCTURE.md). **Nothing anywhere
  discusses tenant lockout, a last-admin guard, or an operator recovery path.** No recorded call
  raises it.
- **Blocked:** nothing today — the branch ships either way, since the risk predates it in every
  tenant that created its own admin role. This is a latent data-loss route, not a merge blocker.
  It does block any claim that the departments module is safe for a self-serve tenant.
- **Owner:** Ehtesham Anwar — carried over from part (d) of the parent entry, as the only recorded
  voice on departments as org structure
  (`meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md`:70) — with Fouzan Shakil for
  the archive-vs-hard-delete half, as decider on the app-wide archive convention.
- **Update 2026-09-04 (Project Repository ingest):** Evidence of FCC practice, not a TCG decision
  on (a)–(c). **Deactivate, never delete:** `FMS_DEPARTMENTS` carries `Status bit NOT NULL`
  ([../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_DEPARTMENTS_Raw.sql](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_DEPARTMENTS_Raw.sql):11)
  and the `Maintain → Company → Departments` grid shows it as a `Status` column
  ([fcc-nexgen-administration-and-security.md](fcc-nexgen-administration-and-security.md) →
  *Departments (slide 18)*); the sibling `FMS_JOB_TYPES` lookup shows how FCC retires a code —
  `Contract`, `Monthly`, `Weekly` set to `Status = 0` in 2020, still present on 2026-06-23, still
  referenced by historical jobs, and still listed with their status on the quote screen's job-type
  list ([../payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md](../payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md)
  → *Job type*; [../quotations/fcc-nexgen-quote-entry.md](../quotations/fcc-nexgen-quote-entry.md)
  → *Job Types and Quote Status codes*). FCC's stated security default is to **disable the
  "Delete Master" button on every screen** — *"most users do not need to delete a master record…
  however, there are exceptions"* (same admin page → *`Admin > Menu Security`*): hard delete exists
  in FCC but is withheld from most profiles. Departments in FCC are also **document-number
  prefixes** (`OM-36540` quotes; `OM-` / `FL-` / `SH-` purchase orders —
  [../vendors-agencies/purchase-orders-fcc/fcc-po-entry-walkthrough.md](../vendors-agencies/purchase-orders-fcc/fcc-po-entry-walkthrough.md)),
  one reason a legacy department is never removed: every historical number carries its code. All
  ten TCG departments are `Status = 1`, so the drop offers no archived-department case to read (c)
  from. Still needed from the client: whether the ERP keeps `DELETE`, whether archive must guard
  live employee/role references, and what an archived department may still be picked in.

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
- **Update 2026-09-04 (Project Repository ingest):** FCC's own shape, as system fact — it states
  no permitted list. **Country is free text in FCC:** `FMS_CUSTOMER_LOCATIONS.Country` is
  `varchar(50)` with a separate `CountryCode varchar(5)`
  ([../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_CUSTOMER_LOCATIONS_Raw.sql](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_CUSTOMER_LOCATIONS_Raw.sql):11,
  :46; `FMS_CUSTOMERS` has the same pair), and TCG's customer import template makes Country
  *optional, up to 30 characters* while **State is exactly 2 characters**
  ([../customers/fcc-customer-import-template.md](../customers/fcc-customer-import-template.md) →
  *Sheet 1*, *The validation formulas, exactly*). **State is a code against a lookup:** `StateCode
  varchar(5)` and an `FMS_STATES` table FK-referenced by 34 columns
  ([fcc-nexgen-database-catalogue.md](fcc-nexgen-database-catalogue.md) → *Keys and
  relationships*); its row count is not in the drop, so the migration brief's *73 states* is
  neither confirmed nor contradicted. **City is free text** (`varchar(50)`), and the job-site
  screen pairs it with a `County` dropdown, a `Country` field and a `ValidateAddress` button
  ([../customers/fcc-maintain-customers-tcg-review.md](../customers/fcc-maintain-customers-tcg-review.md)
  → *The site detail*); FCC's contact screen labels the field **`State/Prov`** (same page). None of
  this answers (a), (b) or (c) — a free-text country column says nothing about what a picker must
  offer, and no page in the drop names a territory or an APO address. Client still needed on all
  three.

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
- **Update 2026-09-04 (Project Repository ingest):** Nothing in the drop speaks to the ERP tables'
  fate or to retiring the load. One source fact bears on (b): in FCC, `FMS_STATES` is a real
  lookup — FK-referenced by **34 columns**, among the dozen most-referenced tables in the database
  ([fcc-nexgen-database-catalogue.md](fcc-nexgen-database-catalogue.md) → *Keys and
  relationships*) — and the migration-profiling scripts in the same drop class `_STATE` /
  `_COUNTRY` tables as *Possible Lookup / Master Reference* (same page → *The classification
  scheme*). So every migrated customer and job-site row carries a `StateCode` that must resolve
  against **something** in the ERP; which table that is, and whether the brief's 73 / 252 row is
  withdrawn, still needs Brian Petros and Fouzan Shakil. Legacy-system fact, not a decision.

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
- **Update 2026-09-04 (Project Repository ingest):** Two facts, neither a decision. **(b) In FCC,
  company identity is per-company data, not deployment config:** `Maintain → Company` holds the
  physical-address block, Email and WebSite, a Mailing Address tab, per-company **T&Cs and
  Footers**, and a **Brand** tab whose on-screen rule is *"If unchecked; e-tickets will display
  the company details from the Mailing Address tab"* — with footer and brand tabs again at yard
  level ([fcc-nexgen-administration-and-security.md](fcc-nexgen-administration-and-security.md) →
  *Company (slides 2–9)*, *Yards (slides 10–17)*). FCC's QuickBooks connector nonetheless assumes
  **one company per NexGen database**
  ([../accounting/nexgen-quickbooks-integration/01-fcc-connector-field-mapping.md](../accounting/nexgen-quickbooks-integration/01-fcc-connector-field-mapping.md)),
  and a second company, *The Repair Guys*, appears in TCG's GL scope — per-company in data,
  single-company in deployment, the same ambiguity this entry names. **(a) The hardcoded address
  may not be TCG's:** TCG's own quoting SOP footer gives **10850 Portal Dr., Los Alamitos, CA
  90720**, two other TCG forms give **14480 Alondra Blvd, La Mirada, CA 90638**, and TCG's Sales
  Operating System flags this itself — *"Confirm current company address… before republishing
  customer-facing material"*
  ([../quotations/tcg-creating-quotes-sop.md](../quotations/tcg-creating-quotes-sop.md) → *Two
  addresses, one company*). Neither is the *4820 Harbor Industrial Way* the branch defaults to.
  Still needed: which address TCG wants on customer mail, and whether identity moves onto the
  tenant record.

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
## Time display — military, 12-hour, or per-user, and does the date ride along?

- **Status:** open
- **Asked:** 2026-09-02 — sprint demo, four people in three positions
  ([meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md) §7;
  transcript 57:01, 59:14–1:00:47).
- **Question:** Corrina Bustos asked whether everything will be **military time**. Melissa McNutt
  wants it because *"there's no people putting AM instead of PM and the computer could calculate
  it better"* — she ties it to boom pay accuracy. Ehtesham: the system can handle both, *"that's
  not going to be a breaking point"*, though he initially said *"we only need to have military
  time."* Joe Schacatano wants it as a **per-user setting**: *"some people fully operate off
  military… a lot of people don't even know how to read military."* Brian Petros adds the
  requirement that outlives the format argument: **show the date**, because *"a lot of the jobs go
  past midnight."* So: is time format a **user preference** (web and mobile), a tenant setting, or
  fixed — and is a cross-midnight timestamp always rendered with its date?
- **Why it is not cosmetic:** the entry side is where AM/PM errors are made, and those errors
  become payroll hours. A per-user *display* preference is safe; a per-user *entry* format needs
  the parse to be unambiguous. Cross-midnight display bears on `payroll/rules/PAY-019`, whose
  policy is still conflicted.
- **Sources checked:** no vault document states a time-format standard; the mobile ticket flow
  and the payroll slice view are the two surfaces that show times today.
- **Owner:** product, with Corrina and Melissa for payroll practice.
- **Update 2026-09-04 (Project Repository ingest):** No source states a time-format standard; the
  drop shows **mixed practice**, all of it legacy fact. **FCC prints 12-hour with AM/PM on every
  customer-facing surface:** the e-ticket's margin times (`Start Time 3:00 AM … End Time 7:30 PM`
  on ticket 44944), the Atom ticket lists (`7:30 AM` / `4:30 PM`) and the quote screen's default
  window (`08:00 AM–04:30 PM`)
  ([../field-ops/e-ticket-worked-example-44944.md](../field-ops/e-ticket-worked-example-44944.md)
  → *Times and the two signature panels*;
  [../field-ops/fcc-e-ticket-and-atom-guides.md](../field-ops/fcc-e-ticket-and-atom-guides.md) →
  *Ticket list screens*; [../quotations/fcc-nexgen-quote-entry.md](../quotations/fcc-nexgen-quote-entry.md)).
  **Brian's date requirement has a precedent in FCC:** the e-ticket report's *"as recorded by the
  workflow"* column stamps every time with its date (`5/12/2026 10:16 PM`) while the customer
  column carries time only — on a ticket that ran 3:00 AM to 7:30 PM, 16.5 hours (same 44944 page,
  the two-column time table). TCG's paper forms write AM/PM (the Field Safety Audit's `Time AM/PM`
  field; the paper ticket's `5:00–7:00 AM` —
  [../field-ops/safety-compliance/03-field-audit-and-safety-value.md](../field-ops/safety-compliance/03-field-audit-and-safety-value.md),
  [../field-ops/field-paper-forms.md](../field-ops/field-paper-forms.md)); TCG's scheduling SOPs
  write 24-hour (`08:00 the day before`, `Thursday 12:00 noon` —
  [../projects-jobs/scheduling/day-prior-confirmation-email.md](../projects-jobs/scheduling/day-prior-confirmation-email.md),
  [../projects-jobs/scheduling/dispatch-scheduling-path.md](../projects-jobs/scheduling/dispatch-scheduling-path.md)).
  Field entry in FCC is **free text** — `9-9:30am` is one string in a Comments field
  ([../field-ops/e-ticket-worked-example.md](../field-ops/e-ticket-worked-example.md)), the error
  class Melissa describes. As system fact only: the nightly FCC copy stamps loads in UTC while
  FCC's own `ModifiedDate` is server-local
  ([../payroll/tcg-rawfms-staging-database/INDEX.md](../payroll/tcg-rawfms-staging-database/INDEX.md)
  → *How the copy is refreshed*). Still needed: whether format is per-user, per-tenant or fixed,
  and whether a cross-midnight timestamp always renders with its date.

## Departments, roles and their capabilities — the authorization layer is unbuilt and the list is unwritten

- **Status:** open
- **Asked:** 2026-09-01 — Abdul Rehman, in the accounting/onboarding call
  ([meetings/2026-09-01-accounting-boundary-and-erp-onboarding.md](../meetings/2026-09-01-accounting-boundary-and-erp-onboarding.md) §3;
  transcript 29:54–30:31, 34:48).
- **Question:** stated plainly by the builder: *"right now we haven't implemented any authorization
  layer based on these department and roles."* What is needed from TCG is **how many departments,
  how many roles, and what each role may do** — a session with Corrina Bustos was proposed and
  Brian said he would start assembling it with her. Two specifics were named: employee **type** in
  the ERP is currently the raw FCC roles import with **no mapping to departments**, and Brian
  expects role definition to sharpen as the 15 September user-journey walkthrough goes module by
  module (*"as we go through the user journeys… we may be able to better identify, okay, this is
  the role that we'll need to do this"*).
- **Sources checked:** `User`, `Employee`, `EmployeeType` and the permissions surface in
  `apps/api/prisma/schema.prisma`; the FCC seeder maps FCC roles onto employee types with no
  department link; no vault document lists TCG's departments or role capabilities.
- **Blocked:** every permission check in the app, and the 15 September test plan, which needs
  users set up per role.
- **Owner:** Corrina Bustos and Brian Petros to supply the list; CodingCops for the model.
- **Update 2026-09-04 (Project Repository ingest):** The list TCG must supply is still unwritten;
  the drop adds four written inputs for the Corrina/Brian session. **(1) TCG's own RFP** requires
  *"role-based access control by department/role (dispatcher, field tech, manager, accounting,
  exec)"* and tabulates **seven user types** — Sales/Estimating, Dispatch/Operations, Field Crew,
  Mechanics, Accounting/Billing, Management/Executives, IT/Admin — each with primary functions and
  access device ([tcg-erp-rfp-2026-02-26.md](tcg-erp-rfp-2026-02-26.md) → *Section 4*, *Section
  5*): client-authored, but a draft that names roles without capabilities. **(2) The current org
  structure** is the 16 June 2026 chart — President with seven direct functions: CFO, HR, VP Sales
  (Sales Manager + Dispatch Manager), VP Fleet & Field Ops (Crane Superintendent, Fleet, Facility,
  Shop), Safety Manager, Data Analytics — and **no IT box**
  ([engagement-directory-and-org-charts.md](engagement-directory-and-org-charts.md) → *The 16 June
  2026 chart*). **(3) One role already has a prose permissions spec:** the Sales Coordinator
  manual's authority-limit table (*may not bypass required review gates… may not promise crane
  availability… may not approve credits outside delegated limits* —
  [../quotations/sales-operating-system/03-sales-coordinator-operations-manual.md](../quotations/sales-operating-system/03-sales-coordinator-operations-manual.md)
  §2), plus the review log's *"Sales can view Dispatch but not edit"* and *"maintain the
  department/role permission structure, configurable"*
  ([../erp-review-log.md](../erp-review-log.md) → *Employees, HR and permissions*). **(4) In FCC,
  "department" is cost coding, not org structure:** the ten FCC departments prefix quote, job and
  PO numbers and four of them own no units at all
  ([../payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md](../payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md);
  [../assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md) →
  *Departments — 10, all active*), while FCC's permission unit is the **profile** — profile → menu
  security → per-field/tab settings → per-user capability flags, plus company/yard scope
  ([fcc-nexgen-administration-and-security.md](fcc-nexgen-administration-and-security.md) → *The
  four layers*). Corrina's own review-log question — *"Department — what is this field used
  for?"* (#12) — is still unanswered there. The engagement documents disagree on the role count
  (SOW acceptance criteria: Admin / Sales Person / Customer; security response: CUSTOMER / HR /
  ADMIN — [codingcops-sow-and-engagement-terms.md](codingcops-sow-and-engagement-terms.md),
  [responsive-design-and-security-posture.md](responsive-design-and-security-posture.md)). All
  of this is background; still needed from TCG: the department list, the role list, and each
  role's capabilities.


## Must a new nav entry be permission-gated, and who may see live vehicle locations?

- **Status:** open
- **Asked:** 2026-09-04 — raised while sourcing branch `Fetaure/samsara-integration`
  (commit `7515a638`, 2026-09-03), which adds a **Tracking** entry to the Asset Management
  sidebar group and a `/asset-management/tracking` page reachable by **any logged-in user**.
- **Question:** Two lines. **(1)** Is a new navigation entry allowed to ship ungated while the
  authorization layer is unbuilt, or must every new module land with its permission from day
  one? **(2)** **Who may see live vehicle locations** — everyone with a login, dispatch and
  management only, or a named role? The second is the one that matters: these routes return
  the live position, plate and VIN of every vehicle on the Samsara account.
- **Sources checked:** **Stated intent points at gated, and TCG has voiced a concern about
  this exact data.** Ehtesham Anwar, on how a feature gets restricted: *"once we have rules and
  permissions integrated into the platform, we will create permissions for this as well. And if
  a user don't have the permission, they are not going to see the [feature]"*
  ([../meetings/transcripts/2026-06-17-erp-sprint-review.md](../meetings/transcripts/2026-06-17-erp-sprint-review.md)
  36:38, `status: reference` — the transcript renders the last word as *"creature"*); and on
  new modules joining the matrix: *"we are going to add to this huge list and not just the
  permissions, also modules"*
  ([../meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md](../meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md)).
  On who may see positions, Brian Petros — about the Samsara map on TCG's own dispatch wall
  screen: *"No, I don't think anybody should see it and we have problems. When the operators
  come in and out, then they get to see. That's too much information for them"*
  ([../meetings/transcripts/2026-04-09-dispatch-scheduling-figma-demo.md](../meetings/transcripts/2026-04-09-dispatch-scheduling-figma-demo.md)).
  And a legal constraint from Corrina Bustos: *"we're not allowed to use, technically allowed
  to use any trackers or anything"*
  ([../meetings/transcripts/2026-08-04-payroll-process.md](../meetings/transcripts/2026-08-04-payroll-process.md)),
  consistent with the one bound already recorded in `../dispatch/gaps.md` → *GPS-verified time
  on a job* — GPS as display and accountability, not the pay-time source. TCG's RFP requires
  *"role-based access control by department/role"* and tabulates seven user types
  ([tcg-erp-rfp-2026-02-26.md](tcg-erp-rfp-2026-02-26.md) §4–5, client-authored,
  `status: unverified`). **But no source says a new nav entry must be gated at merge**, and the
  layer that would gate it does not exist — see *Departments, roles and their capabilities —
  the authorization layer is unbuilt and the list is unwritten* in this file, which this entry
  is a specific instance of.
- **Note:** the state at merge is *authenticated but not authorized*. Login is enforced — the
  HTTP routes sit behind the global `AccessTokenGuard` with no `@Public()`, and the websocket
  gateway verifies the handshake token — but any authenticated user reaches the page. The
  controller says so itself: *"which logged-in roles should see tracking is still undecided …
  Until somebody decides, any authenticated user can reach it"*, citing `brs.md` **OD-012**
  (*"GPS enforcement behavior — Decision Needed"*). In `apps/web` the pattern is mixed rather
  than absent: Payroll and Settings are gated on `can('payroll','view')` /
  `can('settings','view')`, while the whole Asset Management group is not — so Tracking matches
  the group it joined and not the two groups that do gate.
- **Blocked:** nothing today — the page works. What is blocked is knowing whether shipping it
  ungated is a deviation to fix before the 15 September walkthrough, when users are set up per
  role.
- **Owner:** product team — Corrina Bustos and Brian Petros, in the same session that owes the
  department/role/capability list.

## Settings picklist rules the E2E suite asserts with no written source — PR #488

- **Status:** open
- **Asked:** 2026-09-07 — raised reviewing **PR #488** (`qa-automation-employees`). The specs
  (`qa-automation/e2e/specs/settings/picklist.spec.ts`, `sections.spec.ts`, `consumers.spec.ts`)
  assert rules **reverse-engineered from the running build** — their case docs say *"verified against
  the live API on 2026-09-07"*, which verifies them against the code, not against anyone's intent.
  Merging freezes current behaviour as expected behaviour.
- **Question:** three rules, each answerable in a line. **(a)** Is the **public picklist endpoint**
  meant to be **unauthenticated**, and to return **active entries only**? **(b)** Should a picklist
  entry's **code** be uppercased and pattern-checked, and are **code and label each unique**?
  **(c)** Should the default list view be **All** rather than **Active**?
- **Sources checked:** **None of the three is written.** The word *picklist* appears **four times in
  the whole vault**, once meaningfully — [../accounting/gaps.md](../accounting/gaps.md):212-214
  describes `expense_gl_accounts` as *"an empty admin-managed picklist (`code`, `label`,
  `description`, `status`)"*. That is the **only** description of picklist shape anywhere and it says
  nothing about endpoints, auth, casing, patterns, uniqueness or default views. **(a) runs against
  the vault's one written auth posture**, which is the opposite default:
  [responsive-design-and-security-posture.md](responsive-design-and-security-posture.md):80-84
  (`status: unverified`) — *"Every API route is protected by default through global guards
  (`AccessTokenGuard`, `RolesGuard`); public routes must **opt out explicitly** with `@Public()`"* —
  and the only `@Public()` routes the vault records are filed as **defects**, not precedents
  ([../quotations/gaps.md](../quotations/gaps.md):1230 Q-01, :1247 Q-02, :1262 Q-03, all open). So a
  new unauthenticated endpoint needs a stated reason, and there is none. **(b)** every uppercasing
  rule in the vault is ADP/legacy-export (`payroll/adp-bucket-crosswalk.md`,
  `payroll/legacy-payroll-app-code-extract.md`) and must not be transferred; the only uniqueness
  decision is [../decisions/2026-09-02-sub-category-names-tenant-unique.md](../decisions/2026-09-02-sub-category-names-tenant-unique.md),
  which is sub-category **names** and says nothing about codes or labels. **(c)** the one written
  default points the **other** way and is scoped to one surface —
  [../decisions/2026-08-20-planning-tracker-archived-filter.md](../decisions/2026-08-20-planning-tracker-archived-filter.md)
  fixes that *"the tracker's out-of-the-box state continues to hide"* archived rows, names the
  *"**All / Active / Archived** tab set"* only as an **unchosen** UI option under *What this does NOT
  settle*, and states the ruling *"was not made app-wide. It names one surface."*
- **Related, already open — do not duplicate.** The suite's fourth settings assertion — *Settings is
  admin-only while the `/asset-management` taxonomy screens are unguarded* — **is already this
  register's**, and the specs corroborate it from the other side. See [*Must a new nav entry be
  permission-gated, and who may see live vehicle locations?*](#must-a-new-nav-entry-be-permission-gated-and-who-may-see-live-vehicle-locations),
  which records exactly this split: *"Payroll and Settings are gated on `can('payroll','view')` /
  `can('settings','view')`, while the whole Asset Management group is not."* Two qualifications
  before anyone cites that as settled: it records **observed shipped state inside an open question**
  (*"no source says a new nav entry must be gated at merge"*), and the gate named is the
  **front-end** one, which [responsive-design-and-security-posture.md](responsive-design-and-security-posture.md):83-84
  calls *"cosmetic only"* — **nothing says Settings is admin-only server-side**, and
  `picklist.spec.ts` says the reference-code controllers *"carry ZERO `@Roles`"*. Parent entry:
  [*Departments, roles and their capabilities — the authorization layer is unbuilt and the list is
  unwritten*](#departments-roles-and-their-capabilities--the-authorization-layer-is-unbuilt-and-the-list-is-unwritten).
- **Pointer — employee portal invites.** PR #488 also asserts invite mechanics (`User` at
  `PENDING_INVITE` / role `USER`, a 64-character token, rotate on resend, null on revoke). Users and
  invitations are this module's per [../STRUCTURE.md](../STRUCTURE.md), but the question travels with
  the employee record and is filed whole in
  [../payroll/gaps.md#employee-module-rules-the-e2e-suite-asserts-with-no-written-source--pr-488](../payroll/gaps.md#employee-module-rules-the-e2e-suite-asserts-with-no-written-source--pr-488)
  item (c). Answer it there.
- **Blocked:** merging PR #488's settings specs as a behavioural contract. (a) additionally blocks
  sign-off on the public endpoint shipping at all.
- **Owner:** product team — Corrina Bustos and Brian Petros, in the same session that owes the
  department/role/capability list.

## Branch fix/das-fixes — State beside City, Save with no changes, Back in multi-step forms, Leave discards the draft, capped percentages

- **Status:** open
- **(d), added 2026-09-11 — the leave guard's *Leave* now destroys the draft.** Commits `4ee9552ea` and `98ed3ccc4` add an `onDiscard` callback to the unsaved-changes guard and wire it through roughly twenty create flows — asset, category, sub-category, tool, part, manufacturer, agency, billing code, department, role, employee, price list, plan, the customer wizard, and mobile customer **Back** — so leaving clears contacts and nested draft rows that a soft-nav back would previously have revived. **Question:** should *Leave* **discard** what was typed, or should returning to a create form **restore** it? Both are defensible and the branch picks one app-wide. **Sources checked:** nothing written. [../decisions/](../decisions/) — no note on drafts, guards or discard. The two adjacent open entries are both about a different verb: [assets/gaps.md → *Create-form prefill from URL query params*](../assets/gaps.md#create-form-prefill-from-url-query-params--the-whole-contract-is-unwritten) Q3 asks whether a **prefilled** value should trip the guard at all, and [assets/gaps.md → *One tab, one PATCH…*](../assets/gaps.md#one-tab-one-patch--and-what-the-leave-guards-save-means-when-several-tabs-are-dirty) (b) asks what the guard's **Save** means when several tabs are dirty. Neither says what *Leave* should do to the draft. **Blocked:** nothing — reversible. Recorded so it does not become convention by merge.
- **(e), added 2026-09-11 — percentage inputs are hard-capped, and the ceilings rest on nothing written.** Commit `66c649131` adds `apps/web/src/lib/percentage-input.ts`, which **rejects the keystroke** (keeps the previous value) for anything outside `[min, max]`, and matching `@Min(0) @Max(100)` on `CreateQuotationResourceDto.discountPercentage`, `Create/UpdatePurchaseOrderDto.discountPercent` and `CreatePriceListingDto.discountPercentage`, with `@Max(1000)` on `CreatePriceListingDto.priceHikePercentage`. **Question:** two lines. Is **100 %** the right ceiling for a discount, and **1000 %** for a price hike — or is any ceiling a policy call nobody has made? And should an out-of-range percentage be **unable to be typed**, or typed and rejected on submit like every other invalid field? **Sources checked:** [../erp-review-log.md](../erp-review-log.md):250 (`unverified`) asks for *"both line-item and overall discounts (per item, percentage, or fixed-dollar total)"* and names no bound; :245 records that *"the quote cannot [be approved] …"* for discounted quotes — an **approval** control, not a numeric cap. [../decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md](../decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md) and [../decisions/2026-09-02-one-surcharge-per-quote.md](../decisions/2026-09-02-one-surcharge-per-quote.md) settle how the rows behave and state no range. **Blocked:** nothing hard; a 100 % ceiling does block a legitimate 100 %-plus write-off if one exists, which is the question for Ryan Adams / Joe Schacatano.
- **Asked:** 2026-09-11 — PR review of branch `fix/das-fixes` (no ticket, no `.ai/aidlc/` folder); tcg-scrum escalation. Filed here as app-wide form conventions, alongside [*Must an entity picker search the server, or only offer a search box?*](#must-an-entity-picker-search-the-server-or-only-offer-a-search-box). Commits `c8259de19`, `405fac65c`, `e88fc7115`.
- **Question:** three parts, each answerable in a line. **(a)** Should a **State** select sit beside City wherever City stands alone? The branch adds one to the permit create/edit forms (global, project and asset routes) and adds a State filter next to City on the DAS and Dylen-dashboard job lists. It does not change the shared address forms. **(b)** When Save is pressed on an edit form with **nothing changed**, what should happen: close as if saved, stay open with a "no changes" notice, or not be pressable at all? The branch closes the form in the admin edit-user modal, the customer job-site form, and the Settings loss-reasons and reference-code editors. **(c)** Should multi-step forms have a **Back** (previous-step) button? The branch adds one to the quotation wizard, customer wizard, asset create/edit, employee create, vendor form and yard form.
- **Sources checked:** **(a)** [*Which countries, states and cities may an address name?*](#which-countries-states-and-cities-may-an-address-name) and [customers/gaps.md → *Changing State clears City…*](../customers/gaps.md#changing-state-clears-city--and-a-saved-out-of-state-city-is-now-kept-rather-than-cleared) cover the value sets and the State→City dependency on the shared address molecule. Neither covers adding State where City stands alone. The permit form's fields in [../projects-jobs/project-module/05-create-and-track-permits.md](../projects-jobs/project-module/05-create-and-track-permits.md):34 (`unverified`) are *"auto-generated ID, asset, job link, type, agency, fees, and status"*. [../decisions/2026-09-11-quote-to-project-permits-plans-flow.md](../decisions/2026-09-11-quote-to-project-permits-plans-flow.md) point 7 says *"Agency and city/area auto-populate"*. Neither mentions State. FCC screens have City · State · Zip blocks, but that is the legacy system, not a requirement. **(b)** [../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md) (:29, :71) and [../decisions/2026-08-20-post-save-navigation-convention.md](../decisions/2026-08-20-post-save-navigation-convention.md) (:56-58), both `reference` and both by Fouzan Shakil, decide the success path only and leave cancel and the modal/wizard carve-outs undecided. Neither mentions saving with no changes. Adjacent: [assets/gaps.md → *Save and Cancel hidden until a section is dirty…*](../assets/gaps.md#save-and-cancel-hidden-until-a-section-is-dirty--intended-or-an-affordance-nobody-finds) asks whether Save should be visible at all before a change. **(c)** [../erp-review-log.md](../erp-review-log.md):109 (`unverified`; Melissa McNutt, 2026-05-02, Employees item 3): *"There is no back button to return to the previous page"*. That covers Employees only, and "previous page" is not necessarily "previous step". [../customers/customer.md](../customers/customer.md):117, :123 and [../vendors-agencies/vendors.md](../vendors-agencies/vendors.md):38 mention Next and *Save & Next*, never Back. Nothing covers the quotation or customer wizards. Jira not checked (no Jira MCP in this session).
- **Blocked:** nothing hard, since all three are reversible UI changes. Recorded so that merging them does not quietly turn them into convention.
- **Owner:** product team: Fouzan Shakil for (b) and (d), as owner of the post-save convention and as the internal owner of form conventions; Melissa McNutt for (c), since she raised the back button; Lisette Anzaldo for the DAS-filter half of (a); Ryan Adams / Joe Schacatano for the discount and price-hike ceilings in (e).

## Web list tables — Created / Updated columns, format, settings API fields, and scope (`feat/add-table-timestamps-frontend`)

- **Status:** open — **(2) only** (tenant timezone mismatch). Path C accepted shipping (1)(3)(4) and the current date-only formatter for merge; see *Update 2026-09-12* below.
- **Asked:** 2026-09-12 — PR review of `feat/add-table-timestamps-frontend` (Path C; no SCRUM ticket; follow-on to `feat/table-timestamps` / PR 524). tcg-scrum escalation.
- **Question:** four lines. **(1)** Should **primary web entity list tables** show **Created** and **Updated** columns (toggleable via column picker)? **(2)** If yes, how should those dates render — the branch uses browser `toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })` with **no tenant-zone conversion and no zone label**; does that satisfy product display rules? **(3)** Must **Settings admin list APIs** expose `createdAt`/`updatedAt` so Settings reference-code tables can show them, or is that an engineering choice only? **(4)** **Which lists** are in scope — every primary workspace list, Settings reference tables and payroll premiums only, or a named subset (and are admin tenant/user lists, nested asset sub-lists, DAS, mobile, and detail tabs in or out)?
- **Sources checked:** `.ai/aidlc/` — no ticket folder or spec for either timestamp branch; `aidlc/processed.log` rows for `feat/table-timestamps` (2026-09-10) and `feat/add-table-timestamps-frontend` (2026-09-11) describe **what shipped**, not product intent. `../decisions/` — no note on list audit columns. [../quotations/fcc-nexgen-quote-entry.md](../quotations/fcc-nexgen-quote-entry.md) (`unverified`) shows **Created By / Modified By / Created Date / Modified Date** on the quote **detail** tab and attachment grids, not as a stated standard for every primary list grid; [../admin/fcc-nexgen-administration-and-security.md](../admin/fcc-nexgen-administration-and-security.md) explicitly says NexGen behaviour is **not a requirement**. [*Time display — military, 12-hour, or per-user…*](#time-display--military-12-hour-or-per-user-and-does-the-date-ride-along) stays open on **format** (12h/24h, date beside time); it does not authorize list audit columns. [../decisions/2026-09-09-tenant-timezone-configuration.md](../decisions/2026-09-09-tenant-timezone-configuration.md) item 5 (`status: reference`, Syed Haris — **not** adjudicated by Brian Petros) requires timestamps on screen in the **tenant business zone, always labelled**; [../../aidlc/SCRUM-TZ/spec.md](../../aidlc/SCRUM-TZ/spec.md) §5 and `SCRUM-TZ/units.md` defer a **wider** `toLocaleDateString` sweep to later work but do not carve out list audit columns as exempt from item 5.
- **Note:** Parent branch `feat/table-timestamps` adds `createdAt`/`updatedAt` at the database layer app-wide; showing them in UI is a separate product choice. The follow-on branch's shared helper (`apps/web/src/components/templates/workspace-audit-date-column.tsx`) documents an engineering convention only.
- **Update 2026-09-12 (Path C — Fouzan Shakil):** Ship `feat/add-table-timestamps-frontend` with the as-built behaviour — Created/Updated on the branch's primary web lists, Settings admin list payloads, and `formatAuditDate` as browser-local `en-US` date-only (no tenant zone, no zone label). That is **engineering-led Path C acceptance**, not a TCG product adjudication of (1)(3)(4) and **not** a waiver of item 5. **Still open — tenant timezone mismatch (2):** list audit columns render `createdAt`/`updatedAt` (`timestamptz`) via the viewer's browser zone. Near a midnight boundary a tenant in e.g. `America/Los_Angeles` and a viewer in another zone can see **different calendar days** for the same instant, and the cell has **no zone label**, which contradicts [../decisions/2026-09-09-tenant-timezone-configuration.md](../decisions/2026-09-09-tenant-timezone-configuration.md) item 5 (`status: reference`). Web has no tenant timezone on `UserProfile` / `/users/me` yet (SCRUM-TZ). Fix when SCRUM-TZ (or equivalent) lands: pass the tenant IANA zone into `formatAuditDate`, convert with `timeZone`, and show the mandatory label — or get Brian Petros to waive item 5 for date-only list audit columns specifically. Adjacent: [*Time display — military, 12-hour, or per-user…*](#time-display--military-12-hour-or-per-user-and-does-the-date-ride-along) (12h/24h / date-with-time) stays separate and open.
- **Blocked:** nothing for merging this Path C branch once the Path C acceptance above is recorded. Still blocked: treating the browser-zone formatter as compliant with item 5; bringing mobile / DAS / omitted lists into the same convention; closing (1)(3)(4) as product law without Brian.
- **Owner:** product team — Brian Petros for (1)(3)(4) and whether list audit columns may stay date-only without a zone label; SCRUM-TZ / platform for the tenant-zone wire-up that clears (2).

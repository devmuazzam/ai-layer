---
title: Customers — open questions
status: reference
kind: gaps
updated: 2026-09-04
tags: [module/customers, kind/gaps, open-questions]
---

# Customers — open questions

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
  - `customers/customer-and-job-sites.md:25` — *"Remove tasks from customers"*, in a file updated
    **2026-06-12**, three months *after* the recording said keep them. :26 — *"Notes - do TCG team
    use this feature ?"* — is a **question**, and the recording answers it: yes. Both lines are
    duplicated verbatim into `meetings/2026-06-26-discussion-points-with-tcg-team.md` (see
    `customers/customers-INDEX.md` — one document's opinion appearing twice, not two sources agreeing).
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
- **From (frozen original):** [gaps.md#tasks-on-customers-reversed-on-tape-then-removed-with-no-artefact](../gaps.md#tasks-on-customers-reversed-on-tape-then-removed-with-no-artefact)

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
  - `customers/customer.md:35-40` — the lines the combined entry cites are about **notes**, not
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
- **From (frozen original):** [gaps.md](../gaps.md#customer-level-comments-asked-for-on-tape-removed-by-a-qa-ticket-four-weeks-later)

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
  - `assets/user-story-and-tasks.md:100-108` — *"Customer records display status using colour-coded
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
- **From (frozen original):** [gaps.md](../gaps.md#customer-status-values-neither-side-was-built)

## Job-site map — required on the form, and what shows when it is unavailable

- **Status:** open
- **Asked:** 2026-08-25 — SCRUM-936 PR review (branch `scrum-936`); tcg-scrum escalation
- **Question:** On the customer job-site form: (a) is the map **required** — must a job site carry
  a pin before it can be saved, or is it a convenience over manual address entry? (b) when no map
  can be shown, is *"Map view not available."* with manual address entry unchanged the intended
  behaviour, and is that the canonical copy? (c) which other address forms should show a map at
  all — vendor, yard, employee, quotation job site — now that the picker is a shared component?
- **Sources checked:** `customers/customers-INDEX.md` (the five-source conflict stub — **no
  candidate mentions a map**); `customers/customer.md` (Mohsin punch list, the largest customer
  source — **the word "map" does not appear in it**); `customers/customer-and-job-sites.md`, whose
  job-site asks are contacts, certificates and *"Add directions in job sites"* — that last one
  corresponds to the legacy FCC `Directions` **text** column, not a map;
  `assets/user-story-and-tasks.md`; `decisions/`. Jira `SCRUM-699`, `SCRUM-755`, `SCRUM-200` — all
  `description: null`.
- **Note:** the OpenStreetMap fallback on `SCRUM-936` traces to an **environment** problem rather
  than a product ask — `SCRUM-699` comment, Aiman Farooq 2026-08-24: *"unable to test it due to
  the Map APIs issue"*. Graceful degradation is reasonable engineering; what is unsourced is that
  a second map provider and this copy are what TCG wants users to see.
- **Blocked:** `SCRUM-936` sign-off; `SCRUM-699` QA; per-form wire-up of the shared picker.
- **Owner:** Melissa McNutt (policy/customer) for the form and the copy. Provider choice, fallback
  policy and coordinate ownership are the admin half —
  [admin/gaps.md](../admin/gaps.md#map-provider-no-key-fallback-and-which-table-owns-address-coordinates).

## Job-site map on read-only surfaces — the view tab and the create wizard's pending sites

- **Status:** open
- **Asked:** 2026-09-02 — PR review of branch `feat/job-site-view-map` (no ticket, no `.ai/aidlc/`
  folder); tcg-scrum escalation. The **display** half; the **form** half — whether the pin is
  required, and the copy when no map can be shown — is the entry above
  ([#job-site-map](#job-site-map--required-on-the-form-and-what-shows-when-it-is-unavailable)),
  whose part (c) is scoped to *forms* and so does not reach either surface below.
- **Question:** the branch puts the shared `AddressMapPicker` in `readOnly` mode behind a per-row
  *Show map / Hide map* collapsible, rendered only when the site has finite lat/lng. Three parts,
  each answerable in a line. (a) On the customer's **read-only Job Sites tab**, should a saved job
  site offer its pin at all, and if so is a **collapsed-by-default** toggle right, or should the map
  be **always visible**, or reached by opening the site? (b) Should the same map appear on **pending
  sites in the create-customer wizard** — records not yet saved, whose coordinates exist only in
  form state? (c) When a site has **no coordinates** the row shows no map and no explanation. Is
  silent absence intended here, or should it carry the same *"Map view not available."* copy the
  form uses?
- **Sources checked:** `customers/customers-INDEX.md` and all five candidates — **no candidate
  mentions a map on any surface**; `customers/customer.md` (Mohsin punch list, the largest customer
  source) — the word "map" does not appear, and its item 20 *"FINALIZED APPROACH for notes,
  contacts, attachments and jobsite"* enumerates what the job-site **view** page carries (an add
  button, plus edit and delete per record) **without a map**; `customers/customer-and-job-sites.md`
  — job-site asks are contacts, certificates and *"Add directions in job sites"*, which is the
  legacy FCC `Directions` **text** column, not a map (established in the entry above);
  `assets/user-story-and-tasks.md`; `../decisions/` (25 notes, none on maps or on view-page
  composition). Jira: `SCRUM-699` *need to integrate map for jobsite* (In Progress,
  **`description: null`**) — its entire recorded content is form-side, the map↔dropdown two-way
  sync raised by Aiman Farooq 2026-08-25 and 2026-08-27; `SCRUM-936` (QA) extracted the shared
  picker and lists **"Wiring the picker into every address form … per-form wire-up is follow-up"**
  under *Out of scope* — the follow-up it names is **forms**, and it was written by the implementing
  developer describing built code, so it cannot be cited as the requirement either way.
- **Not contradicted, and two same-shaped precedents that do not transfer:** `SCRUM-585` *View
  Ticket Details* (QA) requires *"Ticket displays the job location, map/location information"* — a
  read-only map on a detail view, but the **mobile** field-worker ticket, a different persona and
  entity; `SCRUM-252` *Live Asset Map View* (In Progress) puts a map behind **a toggle** that
  returns to the list when switched off — a toggle precedent, but the DAS asset panel. Neither is a
  source for the customer Job Sites tab.
- **Blocked:** sign-off of `feat/job-site-view-map` as product-correct; the same per-surface
  wire-up decision for vendor, yard, employee and quotation job-site displays.
- **Owner:** Melissa McNutt (policy/customer) — the same owner as the form entry above; answer both
  together. Provider and fallback policy remain the admin half
  ([admin/gaps.md](../admin/gaps.md#map-provider-no-key-fallback-and-which-table-owns-address-coordinates)).

## Changing State clears City — and a saved out-of-state city is now kept rather than cleared

- **Status:** open
- **Asked:** 2026-09-01 — PR review of branch `feat/us-geo-package-lookup` (no ticket, no
  `.ai/aidlc/` folder, no `processed.log` row); tcg-scrum escalation. The form-interaction half;
  the reference-data half (which countries, states and city names exist at all) is
  [admin/gaps.md](../admin/gaps.md#which-countries-states-and-cities-may-an-address-name).
- **Question:** On every address form — the shared `address-fields` molecule, so customers, job
  sites, vendors, yards, employees and quotations at once — the branch changes two things about
  the State→City dependency. Two parts, each answerable in a line. (a) When the user **picks a
  different State**, should the City always be **cleared**, or kept when a city of the same name
  exists in the new state? (b) When a record **already holds a city that does not belong to its
  state** — a bad migration row, or a Google reverse-geocode result — should the form **keep it
  visible** (today's new behaviour: retained as an "orphan" option outside the filtered list), or
  **silently clear it** (the previous behaviour)?
- **Sources checked:** `customers/customers-INDEX.md` and all five candidates — **none describes
  address-field interaction**; `customers/customer.md` (the Mohsin punch list, the largest
  customer source) and `customers/customer-and-job-sites.md`; `../decisions/` (24 notes, none on
  form cascade or dependent dropdowns); `../assets/user-story-and-tasks.md`; `.ai/aidlc/` — no
  ticket.
- **(a) is sourced; (b) is not, and cuts against the ticket that sources (a).** `SCRUM-36`
  *Missing Dependent Location Fields and Inconsistent Validation…* (Done, 2026-04-15) requires
  *"State / Province, County, and City fields should be implemented as **proper dependent
  dropdowns, where each selection filters the next level accordingly**"* — that covers clearing
  the City when the State changes. But the **defect that ticket was filed against** is precisely
  what (b) now reinstates: *"State / Province, County, and City fields are not consistently
  behaving as dependent dropdowns, **leading to incorrect or unrelated selections**."* An orphan
  city retained outside its state is an unrelated selection, deliberately kept.
- **And two Done tickets pull the opposite way on (b).** `SCRUM-547` *Country Field Not Pre-Filled
  on Edit Customer Form* (Done): *"The field should **show the saved value** on edit"*; `SCRUM-549`
  *City Dropdown Issues Across the Application* (Done): the city is *"supposed to be
  **pre-selected** in case of create/edit both"*. Orphan retention is the mechanism that satisfies
  those two — so this is a **genuine conflict between three Done tickets**, not an unsourced
  invention, and it needs one human call rather than a code fix. Worth stating in the answer: the
  two goals can both be met by keeping the value **and** flagging it as out-of-state, which no
  ticket asks for and nothing currently does.
- **Note:** `SCRUM-197` *Implement Infinite Scroll for City and State Dropdowns* (Done) expected
  cities to *"load dynamically as the user scrolls"* because *"performance may degrade with long
  static lists"*. The branch instead fetches cities **per selected state**, which serves the same
  concern by a different route; no ticket blesses the substitution, but nothing is contradicted.
- **Blocked:** sign-off of `feat/us-geo-package-lookup` as product-correct; `SCRUM-962` (To Do,
  *Fix City and Province Dropdowns*) closure.
- **Owner:** Melissa McNutt (policy/customer) for the form behaviour — the same owner as the
  job-site form entry above.

## "Auto-fill from web" on customer create — was it ever wanted, and is removing it right?

- **Status:** open
- **Asked:** 2026-09-04 — PR review of branch `fix/customer-quotation-3sep` (no ticket, no
  `.ai/aidlc/processed.log` row, no `SCRUM-###/spec.md` to hold this); tcg-scrum escalation
- **Question:** three parts, each answerable in a line. **(a) Should the customer create wizard
  offer a "look up this company on the web and pre-fill its address/phone" action at all?** The
  branch deletes it — button, hook and client types — leaving name/address/phone entirely manual.
  **(b) If yes, is a free OpenStreetMap Nominatim query the right source?** What shipped was
  `CustomerEnrichmentService.enrich()` calling `nominatim.openstreetmap.org/search` by company name
  and mapping the first hit's address — a **geocoder used as a company-data provider**, which is
  not what Nominatim is for and not the same thing as the HubSpot / Microsoft / Dialpad sync the
  client actually talks about (see *Integrations* in [admin/gaps.md](../admin/gaps.md#integrations--hubspot-microsoft-365-dialpad-mapsly)).
  **(c) The API side stays.** `GET /api/v1/customers/enrich`
  (`apps/api/src/presentation/customers/customers.controller.ts`:87-93, `QueryEnrichCustomerDto`,
  `CustomerEnrichmentService`, registered in `customers.module.ts`) is untouched and now has no
  caller anywhere in `apps/web`. Should it be removed with the UI, or is it being kept because
  something is expected to use it again? A live route that calls a third party on an
  authenticated endpoint with no consumer is the part that needs an answer even if (a) is "no".
- **Sources checked:** **Vault — nothing, in either direction.** [customers/INDEX.md](INDEX.md) and
  the conflict stub [customers-INDEX.md](customers-INDEX.md) with all five candidates;
  [customer.md](customer.md) and [customer-and-job-sites.md](customer-and-job-sites.md) (the two
  punch lists — neither mentions pre-fill, lookup or enrichment); this register; `../decisions/`
  (26 notes — none touches customer create fields, enrichment or third-party lookup);
  vault-wide grep outside `meetings/` for `auto-?fill|enrich|clearbit|apollo|hubspot.*(lookup|fill)|website.*(scrape|lookup)`
  — every hit is unrelated (project/lift-plan auto-fill of *internal* project data, the DAS
  same-assets-for-shifts toggle, and payroll SQL views named `*_Enriched`). **`meetings/` — nothing
  on a web lookup for customers**; the nearest client statements are about **syncing** contact data
  from HubSpot/Microsoft/Dialpad (2026-08-26 sprint review ~18–20 min; Brian Petros' 2026-08-27
  written follow-up, *"have Patrick explain more details regarding Customer data synced with HubSpot
  & Microsoft"*), which is a different mechanism from an ad-hoc public lookup and is already open in
  admin.
- **Weak signal, and it cuts against the feature having a source:** the control arrived **with no
  ticket and no spec**, inside commit `83c4c19d9` whose message is *"feat(customers): add page-size
  pagination and soft archive (replacing delete)"* — the enrichment service, DTO, controller route,
  web hook and button are all in that one commit, unmentioned. So this is an **unsourced removal of
  an unsourced addition**; nobody is contradicted either way, which is exactly why it needs one line
  from product rather than a reviewer's judgement.
- **Jira: not consulted — unavailable this session.** The Atlassian MCP returns
  `403 Tenant is restricted: suspended-payment` for both JQL search and single-issue reads, so
  `SCRUM-###` descriptions could still carry an answer. Check Jira for *auto-fill*, *enrich* and
  *customer create* before treating this as fully unsourced.
- **Blocked:** sign-off of `fix/customer-quotation-3sep` as product-correct; disposal of the API
  endpoint. Also blocked by consequence: manual test **CUST-CREATE-08** in
  `qa-automation/docs/MANUAL-TESTING-Customers.md` is marked `N/A — REMOVED` by the same branch, so
  the only written description of the behaviour is now retired inside the test pack.
- **Owner:** product team — Brian Petros for (a) and (b), since customer/contact data provenance is
  his ground and the HubSpot/Microsoft question is already his, with Patrick McKiernan for whether
  an existing integration was always meant to fill this role.
- **Cross-link:** [admin/gaps.md → *Map provider, no-key fallback…*](../admin/gaps.md#map-provider-no-key-fallback-and-which-table-owns-address-coordinates)
  (b) — whether a read-only OpenStreetMap fallback is acceptable in production is open there, and
  this endpoint is a second, undeclared OSM dependency; and
  [admin/gaps.md → *Is an ODbL share-alike geo dataset acceptable…*](../admin/gaps.md#is-an-odbl-share-alike-geo-dataset-acceptable-and-who-signs-that-off)
  — Nominatim data is ODbL with an attribution obligation, and nothing in the app attributes it.

## Pointers — 2026-08-27 client follow-ups touching customers

- **Status:** open
- **Asked:** 2026-08-27 — Brian Petros, written message to the TCG team, 2026-08-27 ("A couple things that came up in my discussion with CodingCops today, that we'll discuss in future meetings"), following the 2026-08-26 ERP sprint review — logged in [payroll/client-message-findings.md](../payroll/client-message-findings.md#cross-module--2026-08-27-follow-ups-after-the-fcc-migration-first-pass-brian-petros)
- **Question:** two of Brian's items land on other modules but affect customer data: (a) which
  system holds the current contact record — HubSpot/Microsoft/Dialpad are synced, FCC is not →
  [admin/gaps.md](../admin/gaps.md#integrations--hubspot-microsoft-365-dialpad-mapsly); (b)
  "customer-owned assets" → [assets/gaps.md](../assets/gaps.md#customer-owned-assets--what-they-are-and-whether-the-erp-tracks-them).
  Also for the record: the FCC first-pass migration **redacted customer contact emails and phone
  numbers** and skipped SSNs (2026-08-26 sprint review); un-redaction is planned for production.
- **Owner:** see the two owning entries.

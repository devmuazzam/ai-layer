---
title: Customers — open questions
status: reference
kind: gaps
updated: 2026-09-07
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
- **Status:** open
- **From (frozen original):** [gaps.md#tasks-on-customers-reversed-on-tape-then-removed-with-no-artefact](../gaps.md#tasks-on-customers-reversed-on-tape-then-removed-with-no-artefact)
- Update 2026-09-04 (Project Repository ingest): the drop adds a **third, contradicting ask and
  evidence of where tasks actually live today — no decision.** (a) TCG's own annotation on FCC's
  Maintain Customers screens ([fcc-maintain-customers-tcg-review.md](fcc-maintain-customers-tcg-review.md)
  → *Customer tasks*, slide 6) reads verbatim *"Customer Tasks: Need ability to enter tasks for
  each customer."* — the opposite of `customer-and-job-sites.md:38` *"Remove tasks from customers"*;
  the deck is undated relative to that punch list and neither is adjudicated. (b) The screenshot on
  the same slide shows FCC's customer **Tasks tab** (columns *Complete · Priority · Type · Title ·
  Due · Remind · Assignee · Assigner*) **empty** for TCG's largest utility account, and on FCC's
  quote screen the identical Tasks grid is annotated by TCG *"Not used"*
  ([../quotations/fcc-nexgen-quote-entry.md](../quotations/fcc-nexgen-quote-entry.md) §6, slide 8)
  — so the container exists in FCC and the one customer and one quote the deck shows carry no
  tasks. No `FMS_*TASK*` table is among the 40 tables the nightly staging copy pulls
  ([../payroll/tcg-rawfms-staging-database/INDEX.md](../payroll/tcg-rawfms-staging-database/INDEX.md)),
  so the drop cannot say how many customer tasks FCC holds overall. (c) In the client's written sales
  process, tasks and follow-ups are a **HubSpot** record, not an FCC or ERP one: the operating
  architecture assigns *"next action, follow-up"* to HubSpot/CRM
  ([../quotations/sales-operating-system/01-operating-system-architecture.md](../quotations/sales-operating-system/01-operating-system-architecture.md)
  §9), the coordinator manual's closeout standard is *"CRM has outcome, notes, next opportunity and
  follow-up task"* and its daily cadence reviews *"open tasks"* in HubSpot
  ([../quotations/sales-operating-system/03-sales-coordinator-operations-manual.md](../quotations/sales-operating-system/03-sales-coordinator-operations-manual.md)
  §3, §7, §10), and the HubSpot playbook's ch. 8 is *"task/email/calendar management"*
  ([../quotations/hubspot-sales-playbook.md](../quotations/hubspot-sales-playbook.md) §6). All of
  this is **evidence of practice and of asks, not a TCG decision** about the ERP. Still for the
  client: whether the ERP customer record carries tasks at all, and if so whether they replace,
  mirror or ignore HubSpot's — the CRM-build-vs-buy question is itself unresolved (03-06 action
  items: *"assess what can be built natively into the platform vs. purchased externally"*,
  [../meetings/summaries/2026-03-06-ai-generated-meeting-action-items.md](../meetings/summaries/2026-03-06-ai-generated-meeting-action-items.md)).

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
- **Status:** open
- **From (frozen original):** [gaps.md](../gaps.md#customer-level-comments-asked-for-on-tape-removed-by-a-qa-ticket-four-weeks-later)
- Update 2026-09-04 (Project Repository ingest): the drop answers the *"same thing or a second
  feature?"* half **for FCC** and adds an attributed client ask — **no decision on the ERP.**
  (a) In FCC, comments and notes are **two different things.** `FMS_CUSTOMERS.Comments` is one
  `varchar(max)` column on the customer row (a single free-text **Comments** tab, empty for the
  customer shown), while `FMS_CUSTOMER_NOTES` is a separate table — `Name varchar(30)`,
  `PopUpMessage varchar(max)`, `DisplayMessage varchar(50)` (the multi-valued scope: All /
  Invoices / Jobs / Order Entry / Quotes / Work Orders), `Comments varchar(max)`, plus
  Created/Modified audit columns — shown as a **Notes** grid *Pop-Up Message · Display Message In
  · Comments*
  ([../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_CUSTOMERS_Raw.sql](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_CUSTOMERS_Raw.sql),
  [ddl/stg.FMS_CUSTOMER_NOTES_Raw.sql](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_CUSTOMER_NOTES_Raw.sql),
  [fcc-legacy-customer-data-model.md](fcc-legacy-customer-data-model.md) → *FMS_CUSTOMER_NOTES*,
  [fcc-maintain-customers-tcg-review.md](fcc-maintain-customers-tcg-review.md) → *Comments tab /
  Notes tab*). 119 note rows exist against 6,057 customers in the 2026-06-23 staging copy; the
  quote deck shows the pop-up firing on quote open with two operational instructions for one
  customer ([../quotations/fcc-nexgen-quote-entry.md](../quotations/fcc-nexgen-quote-entry.md) →
  *The customer pop-up*). Legacy fact, not a TCG decision. (b) TCG's own annotation on the FCC
  screens, written beside both tabs (slides 3 and 6): *"Customer Comments/Notes: Need ability to
  enter comments/notes for each customer. Need ability to enable "pop-up" notifications per
  customer… that would (for example) pop-up when user schedules/opens job for that customer, when
  billing interacts with billing screens, etc."* — this is the first written record of the
  pop-up requirement the *Note* above says was recorded nowhere; it is an unadjudicated ask,
  undated relative to `SCRUM-49`. (c) An **attributed** client ask, older than the drop but
  unrecorded here: Melissa McNutt, 2026-06-17 ERP sprint review at 7:31 — *"if a customer is on
  hold, like if they haven't paid us, and so if like sales goes to or dispatch goes to schedule a
  job, something will pop up that Accounting can add in their customer profile that they're on
  payment hold"*; Ehtesham Anwar deferred it to Accounting discovery (7:50–8:30)
  ([../meetings/transcripts/2026-06-17-erp-sprint-review.md](../meetings/transcripts/2026-06-17-erp-sprint-review.md)).
  Melissa's 2026-05-02 review-log entry #8 separately asks to *"Add a note section"*
  ([../erp-review-log.md](../erp-review-log.md)). Still for the client: whether the ERP wants one
  surface or two (free comments vs scoped pop-up notes), which scopes the pop-up fires on, and
  whether the orphaned `Customer.comments String[]` is the home for either.

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
- **Status:** open
- **From (frozen original):** [gaps.md](../gaps.md#customer-status-values-neither-side-was-built)
- Update 2026-09-04 (Project Repository ingest): the drop settles what **FCC** holds and repeats
  the four-value ask in writing — **no decision on the ERP's field.** (a) FCC's status is a
  single `Status char(1) NULL` column with three codes, `A` Active / `T` Inactive / `P` Prospect —
  stated by FCC's own import template, where Status is one of only three unconditionally required
  fields ([fcc-customer-import-template.md](fcc-customer-import-template.md) → Sheet 1 and *The
  validation formulas*), and by the migration extract's `CASE`
  ([fcc-legacy-customer-data-model.md](fcc-legacy-customer-data-model.md) → *Status code list*).
  `ProspectCode varchar(15) NULL` and `ProspectStatus bit NOT NULL` are **separate columns**
  ([../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_CUSTOMERS_Raw.sql](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_CUSTOMERS_Raw.sql)),
  and the legacy payroll app's own reporting view derives `Customer_Type` = Prospect / Customer
  from the bit while decoding `Status` as `'A'` Active / **`'I'`** Inactive / else Unknown
  ([../payroll/tcg-rawfms-staging-database/sql/rpt.v_Base_Customers.VIEW.sql](../payroll/tcg-rawfms-staging-database/sql/rpt.v_Base_Customers.VIEW.sql):39-43)
  — so two legacy artefacts disagree on the inactive code (`T` vs `I`) and the source does not
  say how `Status = P` and `ProspectStatus = 1` interact. Legacy facts, not decisions; there is
  **no On Hold** anywhere in FCC. (b) The four-value ask now exists in writing: TCG's annotation
  on FCC's Maintain Customers slide 2 lists *Active · Inactive · Prospect · On Hold*, beside a
  closed dropdown ([fcc-maintain-customers-tcg-review.md](fcc-maintain-customers-tcg-review.md)
  → *Customer status*). Unadjudicated. (c) What On Hold means has one attributed statement, older
  than the drop and unrecorded here — Melissa McNutt, 2026-06-17 ERP sprint review at 7:31: a
  customer is on hold *"if they haven't paid us"*, Accounting sets it *"in their customer
  profile"*, and it should *"pop up"* when sales or dispatch schedules a job; Ehtesham Anwar
  deferred it to Accounting discovery, noting the RCS pattern of a status changing once accounting
  details are entered (7:50–8:30,
  [../meetings/transcripts/2026-06-17-erp-sprint-review.md](../meetings/transcripts/2026-06-17-erp-sprint-review.md)).
  The AP/AR value engine models the same thing as **`Job On Hold`**, owner Ops/COO, on the unpaid
  branch ([../accounting/ap-ar-value-engine-and-whiteboard-flow.md](../accounting/ap-ar-value-engine-and-whiteboard-flow.md))
  — a job-level, not customer-level, hold. (d) On *Prospect*: the client's sales documents place
  the prospect/opportunity lifecycle in **HubSpot** (12 stages,
  [../quotations/hubspot-sales-playbook.md](../quotations/hubspot-sales-playbook.md) §2) and make
  *"customer status confirmation"* the required output of the New Customer Playbook
  ([../quotations/sales-operating-system/04-value-engine-and-playbook-index.md](../quotations/sales-operating-system/04-value-engine-and-playbook-index.md)
  §4). Still for the client: whether the ERP's `CustomerStatus` gains `PROSPECT` and `ON_HOLD`,
  whether On Hold is a customer status or an accounting flag that blocks scheduling, and whether
  the auto-calculated activity indicator is a separate field — the drop has nothing on the latter.
- Update 2026-09-04, from the record (computed the same day from `stg.FMS_CUSTOMERS_Raw` in the restored 2026-06-23 backup, 6,057 rows): FCC's `Status` column holds **`A` × 6,038, `T` × 15, `P` × 1**, and one stray `8`. So the import template and the migration `CASE` are right — Inactive is **`T`** — and the payroll app's reporting view, which decodes `I`, would show all fifteen inactive customers as *Unknown*; that view is not on the migration path, so nothing is mis-keyed today, but the letter to migrate is `T`. `ProspectCode` is empty on every row and `ProspectStatus` is a bit set on 4,141 of the 6,057 — a flag FCC populates independently of the single `P` status row, meaning nobody at TCG maintains "prospect" through the status field. Which set the ERP carries, and whether On Hold is a status or an accounting flag, still needs the client.

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
- **Update 2026-09-04 (Project Repository ingest):** the legacy system answers none of (a)–(c) as
  a TCG rule, but it shows current practice. **System facts** — FCC's job-site table declares
  `Latitude numeric(20,6) NULL`, `Longitude numeric(20,6) NULL` and `AddressUnknown bit NOT NULL`
  ([`ddl/stg.FMS_CUSTOMER_LOCATIONS_Raw.sql`](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_CUSTOMER_LOCATIONS_Raw.sql),
  26,060 rows), so a site saves with no coordinates at all; the vendor's Avalara guide states the
  inverse escape hatch — *"An Address Unknown checkbox lets the user enter longitude and latitude
  instead; address validation then does not occur"*
  ([accounting/avalara-sales-tax-in-nexgen.md](../accounting/avalara-sales-tax-in-nexgen.md) →
  *Address validation — the gate*) — i.e. in FCC a pin is an **alternative** to an address, never a
  requirement on top of it. FCC never embeds a map in the form: the Customer Job Sites window
  carries a `Map` **toolbar button** ([fcc-maintain-customers-tcg-review.md](fcc-maintain-customers-tcg-review.md)
  → *Customer Job Sites (slides 8–12)*), and *"job sites are geocoded via Google on create/modify;
  the map opens in the user's own browser, provider switchable between Google and Bing per user"*
  ([dispatch/fcc-nexgen-dispatch-guide.md](../dispatch/fcc-nexgen-dispatch-guide.md) §10). For (c),
  the FCC screens recorded today put a map on the **job site**, the **yard** (a map button opening
  *Geofence Settings* — Latitude · Longitude · Radius;
  [admin/fcc-nexgen-administration-and-security.md](../admin/fcc-nexgen-administration-and-security.md)
  → *Yards (slides 10–17)*), the **quote** (`MAP` toolbar;
  [quotations/fcc-nexgen-quote-entry.md](../quotations/fcc-nexgen-quote-entry.md) → *The quote
  form*) and the **scheduled job** (`Map · Directions`; dispatch guide → *Menus and the main
  window*); the customer, vendor and employee screens recorded show none. **Client statements** —
  the 2026-03-20 screen review: *"Map and geolocation features are promising to enhance job site
  management and dispatch efficiency"* and the team *"wants the ability to override yard addresses
  and create geofences"*
  ([meetings/summaries/2026-03-20-fcc-fields-screens-review.md](../meetings/summaries/2026-03-20-fcc-fields-screens-review.md));
  and *"map-based job-site permit intelligence"* in the ERP review log's 2026-05-05 extraction
  ([erp-review-log.md](../erp-review-log.md) → Sheet 2, *Job site and permits* — an AI-generated
  extraction of the meeting, not a hand-written row). None of this says a site must carry a pin to
  be saved, none gives the no-map copy, and the FCC shape is legacy practice, not a TCG decision.
  Still needs the client: (a), (b), and the per-form list in (c).

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
- **Update 2026-09-04 (Project Repository ingest):** legacy practice only, no decision. In FCC the
  map is never rendered inline on a read view — it is an on-demand `Map` **toolbar button** on the
  Customer Job Sites window ([fcc-maintain-customers-tcg-review.md](fcc-maintain-customers-tcg-review.md)
  → *Customer Job Sites (slides 8–12)*) and on Schedule Jobs, and *"the map opens in the user's own
  browser"* ([dispatch/fcc-nexgen-dispatch-guide.md](../dispatch/fcc-nexgen-dispatch-guide.md)
  §10); walking that window on 2026-03-20, TCG's reviewer noted *"There's an option to pull up the
  map"* ([meetings/transcripts/2026-03-20-fcc-fields-screens-review.md](../meetings/transcripts/2026-03-20-fcc-fields-screens-review.md),
  the *Job sites* passage — speaker not attributed in the transcript). That is the closest the
  record comes to (a): a map reached by an explicit action, not always visible — a system fact
  about FCC, not a statement of what the ERP tab should do. Nothing in the drop shows a pending-site
  list (b): FCC has no create-customer wizard, and the vendor's own import template *"has no
  job-site / location tab at all"* ([fcc-customer-import-template.md](fcc-customer-import-template.md)).
  For (c), FCC shows no copy for a site without coordinates; `Latitude`/`Longitude` are nullable
  and `AddressUnknown bit NOT NULL` is the explicit flag
  ([`ddl/stg.FMS_CUSTOMER_LOCATIONS_Raw.sql`](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_CUSTOMER_LOCATIONS_Raw.sql)),
  and the migration exports `AddressUnknown` but drops `GeoFenceRadius` and `ValidationStatus`
  ([fcc-legacy-customer-data-model.md](fcc-legacy-customer-data-model.md) → *`FMS_CUSTOMER_LOCATIONS`
  — FCC's job sites*) — so a *reason* a migrated site has no pin will exist in the data, but nothing
  says whether the tab should surface it. Still needs the client: all three parts.

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
- **Update 2026-09-04 (Project Repository ingest):** the legacy system has **no State→City
  dependency at all**, which bears on (b) as evidence of what migrated rows will contain — not as a
  TCG decision. **System facts** — FCC stores `City varchar(50) NULL` as free text beside
  `StateCode varchar(5) NULL`, `County varchar(50) NULL` and `CountyCode` on every job site
  ([`ddl/stg.FMS_CUSTOMER_LOCATIONS_Raw.sql`](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_CUSTOMER_LOCATIONS_Raw.sql)),
  and the same `City` / `StateCode` pair on the customer row
  ([fcc-legacy-customer-data-model.md](fcc-legacy-customer-data-model.md) → *How this maps onto the
  ERP*, *Addresses*); its schema has an `FMS_STATES` reference table (34 inbound FK columns —
  [admin/fcc-nexgen-database-catalogue.md](../admin/fcc-nexgen-database-catalogue.md) → *the
  most-referenced parent tables*) and **no city table** anywhere in the catalogue; the FCC job-site
  screen shows City as a typed field and only **County** as a dropdown
  ([fcc-maintain-customers-tcg-review.md](fcc-maintain-customers-tcg-review.md) → *Customer Job
  Sites (slides 8–12)*); and the vendor's import template validates City by **length only** (≤ 30)
  and State by **exact length** (2 characters), with no check that the city belongs to the state
  ([fcc-customer-import-template.md](fcc-customer-import-template.md) → *The validation formulas,
  exactly*). So every one of the 26,060 job sites and 5,742 customers arriving from FCC carries a
  free-text city that the ERP's state-filtered list may or may not contain — (b)'s "bad migration
  row" is the ordinary case, not the exception. Nothing in the drop bears on (a): no FCC document
  describes clearing a dependent field. Still needs the client: the one call between `SCRUM-36`
  and `SCRUM-547`/`SCRUM-549` on (b), and (a).

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
- **Update 2026-09-04 (Project Repository ingest):** both owning entries are still open; the drop
  adds evidence to each, recorded here only for the customer-data angle. (a) Ryan Adams' sales
  governance set (client-authored, dated 2026-08-06) names **six systems of record and no
  integration**: HubSpot is *"a shared system of record for opportunities, customers, contacts,
  activity, follow-up and forecasting"*
  ([quotations/hubspot-sales-playbook.md](../quotations/hubspot-sales-playbook.md) §1; the company-
  and contact-record data standard is §3), FCC holds *"Customer/jobsite, quote, job number …"* and
  QuickBooks the *"Customer billing contact"*
  ([quotations/sales-operating-system/01-operating-system-architecture.md](../quotations/sales-operating-system/01-operating-system-architecture.md)
  §9), the New Customer Packet's system of record is *"FCC, HubSpot, Accounting files"*
  ([quotations/sales-operating-system/05-forms-and-records-matrix.md](../quotations/sales-operating-system/05-forms-and-records-matrix.md)
  §2), and the Sales Coordinator *"must reconcile differences before handoff"*
  ([quotations/sales-operating-system/03-sales-coordinator-operations-manual.md](../quotations/sales-operating-system/03-sales-coordinator-operations-manual.md)
  §3). That is a client statement that the contact record lives in HubSpot **and** FCC (and
  QuickBooks for billing), with no single owner named — Patrick's explanation of the sync is still
  what the admin entry waits on. (b) FCC's *Customer Owned Units* screen is now recorded — keyed by
  Serial Number/VIN, with a read-only customer block and a unit-level file-links dialog
  ([assets/asset-record-requested-additions.md](../assets/asset-record-requested-additions.md) →
  *Customer Owned Units (slides 20–24)*;
  [field-ops/fcc-nexgen-service-guide.md](../field-ops/fcc-nexgen-service-guide.md) → *Customer
  Owned Units*) — and its row count is stated two ways: **12** in the 2026-08-26 migration brief vs
  **79** in [assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md) →
  *The 42 unit / equipment / storage tables*. Neither pointed-to question is answered; this pointer
  stays open until both are.

## Retiring Pre-Quote Data — was removal ever asked for, and may the columns be dropped?

- **Status:** open
- **Asked:** 2026-09-07 — review of branch `feat/customer-billing-pre-labor-forms` (craneguys-platform
  PR #490; commits then later rebased — cite the PR, not the pre-rebase SHAs). **Not a ticket
  question:** the branch carries no `SCRUM-###`, no `.ai/aidlc/SCRUM-###/` folder (a
  `processed.log` Path C row was added retroactively at the 2026-09-08 review fix), so there is
  no `spec.md` §12 to hold it.
- **Question:** the branch deletes the customer **Pre-Quote Data** tab and (until the 2026-09-08
  fix) dropped `customers.pre_quote_data` / `pre_quote_data_completed_at` with a bare
  `ALTER TABLE ... DROP COLUMN IF EXISTS` and **no backfill into the new
  `billing_information_data` / `pre_labor_data` columns** — every existing customer's pre-quote
  answers would have been destroyed on `migrate deploy`. Three separable decisions, none written
  down anywhere: (a) was retiring Pre-Quote Data asked for by anyone, or is the new Billing
  Information / Pre Labor pair meant to sit *alongside* it? (b) if it is retired, is the stored
  data expendable, or must it migrate into the replacement shape first? (c) is the retired field
  set (14 fields per the removed `customerPreQuoteComplete` JSDoc) fully covered by the
  replacement?
- **Sources checked:** [INDEX.md](INDEX.md), [customers-INDEX.md](customers-INDEX.md) and all five
  of its candidates; this register. **Nothing anywhere asks for removal.** Every written trace
  points the other way: `SCRUM-575` *Pre-Quote Data Form & Customer PO Form* — **Done**, reporter
  Umair Khan, 2026-06-25 (quoted in
  [../quotations/gaps.md](../quotations/gaps.md#customer-po-on-the-quotation-which-of-three-things-does-it-mean));
  and [customer-and-job-sites.md](customer-and-job-sites.md) L27 — *"Need to ask TCG team to
  provide pre quote form -- we need to assicate this data with customers"*, an **ask that was never
  answered**, duplicated at [../meetings/2026-06-26-discussion-points-with-tcg-team.md](../meetings/2026-06-26-discussion-points-with-tcg-team.md) L15.
  [new-customer-packet.md](new-customer-packet.md) **does exist** on overlay main (since `4e1b3eb`,
  2026-09-04); an earlier draft of this entry incorrectly claimed it never did. Jira could **not**
  be checked: the MCP server returns `403 Tenant is restricted: suspended-payment`, so
  `SCRUM-575`'s current state and any newer ticket are unverifiable from here.
- **Blocked:** Product has still not authorised tab retirement or a column drop. Platform PR #490
  **removed** the destructive `20260907120000_drop_customer_pre_quote_data` migration and restored
  the columns in schema (commit `a718e097`); the UI tab remains retired without a written ask.
  Sign-off on (a)/(b)/(c) still needs a named owner.
- **Owner:** Melissa McNutt (customer packet / onboarding forms), with Ryan Adams on the
  quotation-send side.
- **Update (2026-09-07, corrected 2026-09-08):** an earlier note claimed (a) was answered by
  [decisions/2026-09-07-pre-labor-pdf-and-structured-tabs-complementary.md](../decisions/2026-09-07-pre-labor-pdf-and-structured-tabs-complementary.md).
  **That was wrong** — the complementary note settles PDFs-vs-tabs and never mentions retiring the
  Pre-Quote Data tab or dropping its columns; it explicitly leaves the column drop undecided.
  **(a), (b) and (c) all stay open.** The bare `DROP COLUMN` is no longer on PR #490; the open
  Product questions and the unrun staging/prod occupancy check remain.

## Billing Information and Pre Labor Form tabs — the names are sourced, nothing else is

- **Status:** open
- **Asked:** 2026-09-07 — review of branch `feat/customer-billing-pre-labor-forms` (craneguys-platform
  PR #490 / `dacf6dc1`). No ticket, no spec folder (Path C `processed.log` row added 2026-09-08).
- **Question:** the branch adds two customer detail tabs — **Billing Information** (a composite of
  five sub-forms: Credit Card Authorization, Credit Application, Terms & Conditions, Deposit Form,
  Preliminary Notice) and **Pre Labor Form** — editable from the detail/edit workspace and
  deliberately absent from the create wizard. What is sourced is only that the two paper artifacts
  exist and were to be digitized. Unsourced: which five sub-forms belong in the composite and what
  fields each carries; whether they are one tab or five; whether Pre Labor Form is the same artifact
  as the "job and labor compliance information request form"; whether they belong on the customer
  record at all rather than on the quotation or the project; and whether excluding them from
  customer-create is intended or a gap.
- **Sources checked:** [INDEX.md](INDEX.md), [customers-INDEX.md](customers-INDEX.md) and its five
  candidates; [../accounting/INDEX.md](../accounting/INDEX.md); this register. The nearest sources,
  both `status: reference` and both **CodingCops' own voice describing their own plan**, not a
  client requirement: [../meetings/transcripts/2026-07-29-erp-review-dispatch-das-update.md](../meetings/transcripts/2026-07-29-erp-review-dispatch-das-update.md)
  L70 — *"we have included the customer packet that Melissa and the team sent over to us and the job
  compliance forms, both of these things… we need to also digitize them. And in the upcoming
  sprints, we are going to digitize those as well"* — and `SCRUM-575`'s closing comment, which names
  exactly the two artifacts *"1. new customer packet 2. job and labor compliance information request
  form"* (quoted in [../quotations/gaps.md](../quotations/gaps.md#customer-po-on-the-quotation-which-of-three-things-does-it-mean)).
  Client-side corroboration that the packet is a real business artifact with a defined content:
  [../meetings/transcripts/2026-08-11-sales-process.md](../meetings/transcripts/2026-08-11-sales-process.md)
  L213, Brian Petros — *"we would need to send the new customer packet. **There's a playbook on that
  as well.**"* **That playbook, and Melissa's PDFs, are the missing source** — neither is in the
  vault. Jira unavailable (`403 suspended-payment`).
- **Note:** the field-level shape is recoverable without a product decision if someone supplies the
  two PDFs; only the placement and the create-wizard exclusion need a person.
- **Owner:** Melissa McNutt (owns the packet and the compliance forms).
- **Update (2026-09-07):** two of the five unsourced items are now answered by decision, the rest
  are not.
  [decisions/2026-09-07-pre-labor-pdf-and-structured-tabs-complementary.md](../decisions/2026-09-07-pre-labor-pdf-and-structured-tabs-complementary.md)
  confirms Pre Labor Form **is** the same artifact as the "job and labor compliance information
  request form."
  [decisions/2026-09-07-pre-labor-capture-stays-customer-level.md](../decisions/2026-09-07-pre-labor-capture-stays-customer-level.md)
  confirms both tabs belong on the **customer** record (not the quotation or project) — as a
  phase-scoping choice, not a claim that the job/quote sources this decision cites are wrong; see
  that note. **Still unsourced:** which fields belong in the five-sub-form composite (nobody has
  supplied the two source PDFs), whether it should be one tab or five, and whether excluding both
  from the create wizard is intended.
- **Update (2026-09-12, tcg-scrum re-sweep for the PR review of the same branch):** the *"nobody
  has supplied the two source PDFs"* line above is **out of date — both PDFs were transcribed into
  the vault on 2026-09-04, three days before this entry was written, and the field shape of both
  tabs traces to them almost one-to-one.** This is a retrieval correction, not a decision; both
  sources stay `status: unverified`.
  - **Billing Information** → [new-customer-packet.md](new-customer-packet.md) → *What each form
    collects*. Credit Card Authorization, Credit Application, Deposit Form and Preliminary Notice
    are each transcribed field by field from `New Customer Packet 10-23-2025_1[70].pdf`, and
    `packages/shared/src/types/billing-information-data.ts` matches them (company composition
    enum, union affiliation, principals, bank block, trade references; deposit = customer / date
    of job / quote # / sales rep / job address / prevailing wage / method of payment; preliminary
    notice = customer / job # / P.O. # / prevailing wage plus the four job-information / owner /
    original-contractor / sub-contractor party blocks). The fifth sub-form, **Terms & Conditions**,
    is the credit application's own T&C block in the packet, surfaced as a separate signature-only
    object in code. **So the composite is sourced; only its division into five UI sub-forms is
    not.** Divergences the packet does not account for, and which nobody has signed off:
    `DepositFormData.typeOfAccount` / `accountNumber`, `PreliminaryNoticeData.expirationDate`,
    and the `signatureHtml` e-signature capture on three sub-forms.
  - **Pre Labor Form** → [../payroll/certified-payroll-playbook.md](../payroll/certified-payroll-playbook.md)
    §11, *The fields, which are the data model for a certified-payroll job* — the transcription of
    `Pre-Job_Labor_Compliance_Information_Request_Form_final_polished[48].pdf`. All six sections of
    `packages/shared/src/types/pre-labor-data.ts` map onto it (Customer & Project; certified
    payroll / prevailing wage; DAS 140 and apprenticeship; LA-131 and LAUSD/LACMTA; PLA with LPC
    Tracker / DIR platform style; OCCIP/CCIP with administrator, email and enrolment deadline).
    **`REQUIRED_STRING_FIELDS` is sourced too:** the playbook marks the *Customer & Project* row
    **"(all required)"** and lists exactly the nine fields the constant carries (`projectId` =
    *Customer Job or Quote Number*, `projectValue` = *Total Contract Amount*).
  - **What genuinely remains open in this entry:** one tab or five; the create-wizard exclusion;
    the four unsourced fields listed above. **Placement is settled** by the 2026-09-07
    customer-level decision, and **naming** by the complementary decision. Neither packet source
    says any of this should be built into the ERP — [new-customer-packet.md](new-customer-packet.md)
    says the opposite in its own voice — so these are sources for *field shape*, not authority to
    build the tabs.
  - **The packet is not a source for storing card data.** Its transcription deliberately records
    that card number, expiry and security code *"are collected by the source form — deliberately
    not represented as fields to be stored anywhere"*. The masked-PAN question in the next entry
    is untouched by this correction.

## Storing full credit card numbers and CVVs in `billing_information_data` — no source, and a compliance question

- **Status:** open
- **Asked:** 2026-09-07 — review of branch `feat/customer-billing-pre-labor-forms` (craneguys-platform
  PR #490 / `dacf6dc1`).
- **Question:** `packages/shared/src/types/billing-information-data.ts` defines
  `creditCardNumber` and `securityCode` (*"Full CVV"*, per its own comment) and they are persisted
  **in plaintext** in the `customers.billing_information_data` JSONB column. The file's header
  justifies this as *"stored in-app as full values for this internal tool (same approach as the
  existing PDF workflow). No tokenization in this pass."* **That rationale appears nowhere outside
  the source file** — no person is named as having accepted it. Two questions: (a) is TCG willing
  to hold cardholder data in the ERP at all, versus capturing an authorization without retaining
  the PAN; (b) if yes, at minimum, must the CVV be discarded after use and the PAN encrypted or
  truncated?
- **Sources checked:** the whole vault for `PCI`, `tokeniz*`, `stripe`, `authorize.net`,
  `payment processor`, `encrypt` — **zero hits on card handling** anywhere, including all 57
  transcripts. [../accounting/INDEX.md](../accounting/INDEX.md); [../admin/gaps.md](../admin/gaps.md);
  [../decisions/](../decisions/) (26 notes, none on payments or data protection).
  [../quotations/quote-terms-and-rate-card.md](../quotations/quote-terms-and-rate-card.md) L172 is
  the only payment-terms content in the vault (*"First-time customers COD with 50% deposit, then net
  15 on approval"*) and says nothing about how a card is captured or stored. Jira unavailable
  (`403 suspended-payment`).
- **Note:** this is the one item in this batch that is **not** purely a product-intent question.
  Retaining the CVV/CAV2/CVC2 after authorization is prohibited by PCI-DSS req. 3.2 irrespective of
  what TCG prefers, and a plaintext PAN puts the whole `customers` table in scope. It should not
  merge on an unattributed code comment.
- **Blocked:** merging PR #490 as first written (full PAN + CVV). Softened after the harden commit
  below — (a) remains open.
- **Owner:** Brian Petros (systems/compliance) — needs a named acceptance or a design change, not a
  developer's judgement.
- **Update (2026-09-07, verified against PR #490 harden commit `052559469`):** the specific defect
  described above —
  full PAN and CVV persisted in plaintext — is **fixed**, in a later commit on the same branch
  (`052559469`, *"harden billing card storage and completion"*), not by any decision recorded here.
  `sanitizeBillingInformationDataForStorage` (`packages/shared/src/types/billing-information-data.ts`)
  is called on every create and update (`customers.service.ts`) and **masks the PAN to last-four
  digits** (`maskCreditCardNumberForStorage`) and **nulls `securityCode` unconditionally** before
  the write reaches Prisma; the web tab calls the same sanitizer client-side before submit. So (b)
  is answered in code: CVV is discarded, PAN is truncated. **(a) is still open and this does not
  answer it** — TCG now retains a masked PAN rather than no PAN at all (no tokenization via a
  payment processor), and nobody named has accepted that as sufficient. Narrow this entry to (a)
  rather than treating it as closed.

## What makes Billing Information "Complete"? — an any-field rule, stampable from autofill alone

- **Status:** open
- **Asked:** 2026-09-07 — review of branch `feat/customer-billing-pre-labor-forms` (craneguys-platform
  PR #490 / `dacf6dc1`).
- **Question:** `isBillingInformationDataComplete` (`packages/shared/src/types/billing-information-data.ts`)
  is documented as *"Lenient completion: true when **any** of the five sub-forms has meaningful
  progress"* — a single non-empty field in any one sub-form stamps
  `billing_information_data_completed_at` (`customers.service.ts` L211 on create, L473 on update).
  Compounding it, the form seeds `companyName` and `customerName` from `customer.customerName`
  (`customer-billing-information-tab.tsx` L230/256/283/292 via `toFormValues`), so **opening the tab
  and saving with nothing typed marks the customer Complete**. The retired predecessor used the
  opposite rule — *"all 14 pre-quote data fields"*, per the JSDoc this branch deletes from
  `customerPreQuoteComplete` and `preQuoteDataCompletedAt`. So an all-fields rule is being swapped
  for an any-field rule and **neither rule has a written source**. Needed: (a) what does Complete
  mean per sub-form, and must all five be complete for the customer to be; (b) which fields are
  genuinely required; (c) should an autofilled value count as progress at all; (d) what consumes
  the timestamp, now that the quotation-send gate that read its predecessor has been removed
  (see [../quotations/gaps.md](../quotations/gaps.md)).
- **Sources checked:** [INDEX.md](INDEX.md), [customers-INDEX.md](customers-INDEX.md) and its five
  candidates; this register; [../decisions/](../decisions/). Nothing defines completion for the
  packet, the compliance form, or their retired predecessor — the "14 fields" figure survives only
  in code comments this branch removes, with no product source behind it either. Jira unavailable
  (`403 suspended-payment`).
- **Note:** if the timestamp has no downstream consumer, the cheapest correct move is to stop
  stamping it until the rule is decided, rather than to pick a threshold here.
- **Owner:** Melissa McNutt (what a returned packet must contain), with accounting on approval.
- **Update (2026-09-07, verified against PR #490 harden commit `052559469`):** the specific defect
  described above —
  autofill alone stamping Complete — is **fixed**, in the same later commit `052559469` noted on the
  CVV/PAN entry above, not by any decision recorded here.
  `packages/shared/src/types/billing-information-data.ts` now excludes `companyName`/`customerName`
  (`IDENTITY_AUTOFILL_KEYS`) and `securityCode` (`EPHEMERAL_CARD_KEYS`) from progress-checking, so
  opening the tab and saving with nothing typed no longer stamps `billingInformationDataCompletedAt`.
  **(c) is answered: no, autofill does not count.** **(a), (b) and (d) are still open** — the rule
  is still lenient any-field-in-any-sub-form (per the current docstring: *"True when any sub-form
  has user-entered progress... Does not require every sub-form to be filled"*), which fields are
  "genuinely required" is undefined, and (d)'s downstream-consumer question is untouched by this
  fix. Narrow this entry to (a)/(b)/(d) rather than treating it as closed.
## Pre-Labor / labor-compliance capture — one customer-level blob, or one record per job/quote?

- **Status:** **resolved** — [decisions/2026-09-07-pre-labor-capture-stays-customer-level.md](../decisions/2026-09-07-pre-labor-capture-stays-customer-level.md)
- **Asked:** 2026-09-07 — review of ad-hoc branch `feat/customer-billing-pre-labor-forms`
  (craneguys-platform PR #490 / `dacf6dc1`, no ticket; Path C `processed.log` row added 2026-09-08);
  tcg-scrum escalation
- **Question:** the Pre-Job Labor Compliance & Payroll Information Request is captured where?
  (a) one JSON blob on `Customer`, overwritten on every save — what the branch builds; (b) one
  record per **job/quote**, with an optional customer-level *default flag* ("LAUSD is always
  certified payroll") that pre-populates it; or (c) both, as a customer default plus per-job
  instances. A one-line answer settles it. If (b) or (c), the seven **required** per-project
  fields now on the customer blob — `projectName`, `jobLocation`, `projectId`, `projectValue`,
  `estimatedStartDate`, `estimatedEndDate`, `generalContractor`
  (`packages/shared/src/types/pre-labor-data.ts`, `REQUIRED_STRING_FIELDS`) — belong on the job or
  quote, not the customer, and the column is a data-loss bug rather than a layout choice.
- **Sources checked — and they point away from (a):**
  - [quotations/sales-operating-system/05-forms-and-records-matrix.md](../quotations/sales-operating-system/05-forms-and-records-matrix.md)
    §2 row 2 — *Labor Compliance & Payroll Requirement Form*, system of record **"FCC job record
    and compliance folder"**, output *"completed requirement form and attached agency packet"*.
    The file's own gloss: *"Form 2 says the labor-compliance form's output lands in the FCC job
    record — a compliance flag on the job, not a filed PDF."* §3 adds it is **"sent with every
    quote"** and gates *"no scheduling release before compliance review"*. Client-authored
    (Ryan Adams, 2026-08-06), `status: unverified`.
  - [meetings/transcripts/2026-08-06-certified-payroll-labor-compliance.md](../meetings/transcripts/2026-08-06-certified-payroll-labor-compliance.md)
    — Corrina Bustos 17:59–18:28 asks for a customer-level **option** so jobs auto-mark
    (*"if we can get it at the customer level where it has that option … anytime there's a job
    scheduled with LAUSD … it would just automatically [mark] as certified"*). That is a
    **default**, not a store. The same passage says the marking lives on the job (17:35 *"they
    mark it in the job"*; 17:49 the certified-payroll report keys off the job). Corrina 18:46 and
    Melissa McNutt 18:55 then rule out a single customer-level value outright: **"it's per job
    site … it's not all or nothing"**, *"if they do an AC lift on your house they don't need it,
    but tomorrow they go to the police station, they're going to need it."*
  - Precedent is itself unsourced: `Customer.preQuoteData`, the blob this pattern was copied
    from, is recorded in [new-customer-packet.md](new-customer-packet.md) →
    *Where this connects* as **"The schema comment does not name the fields and this packet is
    not cited as their source — whether they correspond is unverified."** Copying it propagates
    an unsourced shape; the commit message cites *"the Pre-Quote Data pattern and Figma layouts"*.
  - `vault/decisions/` (31 notes on overlay `main`) — **nothing** on labor-compliance scope,
    certified-payroll flags, or customer-vs-job form placement.
  - Jira **not consulted — unavailable**: the Atlassian MCP is not mounted this session, and the
    tenant was returning `403 suspended-payment` as of the 2026-08-25 customers entry above.
    Check `SCRUM-575` and any labor-compliance ticket before treating this as fully unsourced.
- **Note:** the same branch initially added `20260907120000_drop_customer_pre_quote_data`, which
  would have dropped the `pre_quote_data` column that
  [fcc-legacy-customer-data-model.md](fcc-legacy-customer-data-model.md)
  (line ~485) documents as *"the JSON compliance/onboarding blob that corresponds to the paper
  packet"*. That migration was **removed from PR #490** (2026-09-08); whether any tenant holds data
  in the column is still a separate check.
- **Blocked:** sign-off of `feat/customer-billing-pre-labor-forms`; the shape of
  `Customer.preLaborData`; the certified-payroll job flag the payroll report depends on
  (transcript 17:49 — *"if the job is not marked on there, that job won't even pop up on the
  report"*).
- **Owner:** Corrina Bustos (labor compliance — she raised the customer-level ask) with
  Melissa McNutt (per-job-site variability). Ryan Adams owns the forms matrix.
- **Cross-link:** [quotations/gaps.md → *Structured Billing / Pre-Labor tabs vs the static-PDF
  quotation-send flow*](../quotations/gaps.md#structured-billing--pre-labor-tabs-vs-the-static-pdf-quotation-send-flow);
  [payroll/gaps.md → *Labor Compliance module — no vault coverage*](../payroll/gaps.md#labor-compliance-module--no-vault-coverage),
  which is the same greenfield module and is still open.
- **Resolution (2026-09-07):** answer (a) — `Customer.preLaborData` stays a **single JSON
  blob on the Customer record**, one instance per customer, overwritten on each save. Product
  decided this **verbally**, relayed by Jahanzaib Nadeem; no individual Product person is
  named and no meeting is citable, so the attribution is weaker than every other note in
  `decisions/` — see the note's `decided_by:`.
  **This is a phase-scoping decision, not an adjudication of the sources above.** The
  forms-matrix "FCC job record", the 2026-08-06 *"it's per job site … it's not all or
  nothing"* passage and the 2026-03-20 Kyle transcript are **not** contradicted, **not**
  superseded, and stay `status: unverified` — the job-vs-customer scope question is
  **deferred**, and they are still what a per-job design must be built against. Product
  accepted the known limitation (a customer with several jobs retains only the most recently
  saved project's compliance data) for this build.
  **Still open, and not closed by this:** the certified-payroll **job flag** the payroll
  report keys off (→ [payroll/gaps.md](../payroll/gaps.md#labor-compliance-module--no-vault-coverage));
  Corrina's customer-level **auto-mark default**, which a singleton store is not; and whether
  `pre_quote_data` may ever be dropped — **not** put to Product and **not** authorised by this
  decision (the drop migration is no longer on PR #490).

## Branch fix/12-sep-uat — Billing / Pre Labor edit UX (footer Save, blur validation, optional save, new booleans, autofill)

- **Status:** open
- **Asked:** 2026-09-12 — PR review Path C branch `fix/12-sep-uat` (no ticket); tcg-scrum escalation.
- **Question:** five lines. **(a)** Should Billing Information and Pre Labor tabs use a **footer Save that flushes** pending edits (same pattern as customer Job Sites)? **(b)** Is **blur-only** format validation (invalid until field blur, not on every keystroke) the app-wide rule for these forms? **(c)** May Pre Labor be **saved with all fields empty**? **(d)** Should **`das140`** and **`apprenticeUtilizationRequirements`** exist as explicit booleans on Pre Labor (vs prose-only in the paper form)? **(e)** Should **FormField label disguise** and **`EmailField` rendered as `type=text`** apply app-wide to harden browser autofill?
- **Sources checked:** [decisions/2026-09-07-pre-labor-pdf-and-structured-tabs-complementary.md](../decisions/2026-09-07-pre-labor-pdf-and-structured-tabs-complementary.md) (`verified`, weak `decided_by`) — PDF + structured tabs + manual transcription only. [decisions/2026-09-07-pre-labor-capture-stays-customer-level.md](../decisions/2026-09-07-pre-labor-capture-stays-customer-level.md) (`verified`, weak attribution) — customer-level blob only. [decisions/2026-09-12-edit-leave-confirmation-offers-save.md](../decisions/2026-09-12-edit-leave-confirmation-offers-save.md) (`reference`, Fouzan Shakil) — **leave** dialog Save, not footer Save / flush. [*What makes Billing Information "Complete"?*](#what-makes-billing-information-complete--an-any-field-rule-stampable-from-autofill-alone) — completion stamp rules, not blur or empty Pre Labor. [new-customer-packet.md](new-customer-packet.md) / [customers/gaps.md → *Billing Information and Pre Labor Form tabs*](#billing-information-and-pre-labor-form-tabs--the-names-are-sourced-nothing-else-is) — packet field names include prevailing-wage topics (`unverified`); **no boolean field list**. `admin/gaps.md` — no autofill-hardening rule. Jira unavailable.
- **Blocked:** Path C `fix/12-sep-uat` customer billing/pre-labor polish; app-wide FormField/EmailField policy if (e) is yes.
- **Owner:** Melissa McNutt (packet contents), Corrina Bustos (Pre Labor / compliance fields); Fouzan Shakil for cross-form Save/validation convention with Job Sites.

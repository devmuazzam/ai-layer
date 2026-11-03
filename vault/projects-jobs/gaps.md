---
title: Projects Jobs — open questions
status: reference
kind: gaps
updated: 2026-10-08
tags: [module/projects-jobs, kind/gaps, open-questions]
---

# Projects Jobs — open questions

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

## Quotation → Project → Job — what one click creates, and what the button is called

- Question: on a signed quotation, should the single "Create Project" action also create a Job in
  the same transaction, or should Project and Job be two deliberate steps — and is "Convert to Job"
  a retired label or a permanent second stage?
- Candidates:
  - Recording **2026-03-06**, `ans.nisar` (**CodingCops**) at 35:46: *"after the approval of the
    code [quote], once it goes towards the dispatching… at that point we'll be actually converting
    **automatically** to a project. It will be a **draft mode** or whatever."* The TCG assent on
    record — Melissa McNutt 31:26 *"I like that"*, Ryan Adams 31:30 *"Yes, I think that covers it"* —
    lands **before** that turn and attaches to the *project-entity concept*, not to the automation.
    Nobody responds to the 35:46 turn.
  - `2026-03-06_AI-generated_Meeting-Action-Items.txt` **contradicts itself**: line 58 *"A Project is
    auto-generated when a Quote is approved"*; line 70 *"'Convert to Job' button on an accepted quote
    creates a Project and initial Job."* The manual/automatic ambiguity is inside the meeting's own
    action list.
  - Recording **2026-03-31 "Dispatch-Scheduling-Permits Figma demo"**, `Ehtesham Anwar` at 8:52:
    *"Instead of having convert to a job, we are going to have a new button that is going to say
    create project"* — and immediately after, at line 169, *"Whenever she clicks on the project
    automatically that position getting to also create a a job against that"*. **The vendor stated
    on 2026-03-31 that Create Project also creates a Job.** The only TCG reaction (17:28) is under
    the "Brian Petros" label while Ehtesham had just addressed **Lisette** by name — attribution
    inferred.
  - `projects-jobs/project-module/01-create-and-track-projects.md` (`status: unverified`) — :20 *"Clicks
    'Create Project' from the Quick Actions panel"*, :29 *"only visible on quotations, when qoutation
    is signed"*, :30 *"instantly creates a project with all key data carried over"*, :35 a project
    can be created without a quotation. **Manual, one click. It does not say a Job is created too.**
  - `quotations/quotation-flow-process.md:72` — *"Step 27: Approved quotation is converted into a
    Project."* Passive voice; compatible with both readings and therefore settles nothing.
  - `SCRUM-231` *Create and Track Projects* — **Done**, created **2026-05-01**. `SCRUM-312` *"replace
    resend/void actions with Convert to Job CTA"* — **Done**, created **2026-05-06**, a
    **`description: null` subtask** under the DocuSign story `SCRUM-239`. **Project came first, by
    five days; the Convert-to-Job subtask never contested it.**
  - `SCRUM-894` *Prevent Automatic Project and Job Creation Before Conversion* — **To Do**, reporter
    Aiman Farooq, created 2026-08-17. A first-person QA repro (*"I had not yet clicked Convert to Job
    or Create Project button but the Project and Job were automatically created"*), **no AC, no
    requester named**. `gaps.md` §*Feedback punch lists…* records the same item from the
    13-august-QA page as having **no ticket**; `SCRUM-894` appears to be that ticket, filed
    separately. That accounting should be reconciled by a human, not inferred.
- Note: **both labels are live in the build by design, not by accident** —
  `apps/web/src/features/quotations/components/organisms/quotation-sales-actions.tsx:118` reads
  `const convertLabel = hasLinkedProject ? 'Convert to Job' : 'Create Project';`, backed by two
  modals and two endpoints (`POST /projects/from-quotation`, `POST /projects/convert-to-job`). And
  `apps/api/src/usecase/projects/projects.service.ts:467` comments *"Create Project + Job inside a
  single transaction so creation is atomic"* — so one click does create two things, which is
  probably what QA saw. **The two-stage semantics and the label-flip rule are written nowhere** —
  not in the vault, not on any ticket. Also unwritten: the API guards only on `convertedToJob`, so
  the "only when signed" rule from the vault is enforced in the UI alone.
- Blocked: `SCRUM-894` (To Do) cannot be specified without this; any spec citing
  `projects-jobs/project-module/01-create-and-track-projects.md`; the 13-august-QA behaviour question.
- Owner: Ryan Adams / Joe Schacatano (sales & quotation), with Lisette Anzaldo for the dispatch-side
  consequence of a Job existing early.
- **Status:** open
- **From (frozen original):** [gaps.md#quotation-project-job-what-one-click-creates-and-what-the-button-is-called](../gaps.md#quotation-project-job-what-one-click-creates-and-what-the-button-is-called)
- Update 2026-09-04 (Project Repository ingest): two client-side artefacts and one FCC fact; none
  a decision. (a) The client's review log, 2026-05-05 extraction
  ([erp-review-log.md](../erp-review-log.md) → *Quotations, jobs and projects*): *"a signed quote
  should create job/project records while the original quote stays static"*, *"a project may have
  multiple quotations, each convertible into a job under the same project"*, and the DocuSign →
  *"conversion into job/project"* flow *"not yet fully built"*. That is the closest thing on record
  to the atomic Project + Job that `projects.service.ts:467` builds — but it is an unverified AI
  extraction, says "job/project" without stating whether one click makes both, and names no
  button. Its many-quotes-per-project rule is also the first written basis on which the
  `hasLinkedProject` label flip could rest (a second signed quote under an existing project would
  convert to a job, not create a project) — an inference from the rule, not a statement of it.
  (b) The unattributed lifecycle sketch in [quote-to-job-lifecycle.md](quote-to-job-lifecycle.md)
  draws **Convert to job** (*"quotation locked in system"*), no Project entity, quote → job
  1 : 0–1 — so the "Convert to Job" label is alive in a client-folder artefact, but that page
  records the sketch as contradicting the review log and adopts neither. (c) FCC fact, practice
  not decision: NexGen has no project; the quote's **Conv Job** button creates the job directly
  and the quote header keeps a `Converted To Job` field with the job number
  ([quotations/fcc-billing-data-and-price-lists.md](../quotations/fcc-billing-data-and-price-lists.md)
  §4 step 4; [quotations/sales-reporting-workbooks.md](../quotations/sales-reporting-workbooks.md)
  §1). Still needs the client: one click or two, the label(s), and whether a Job may exist before
  dispatch wants it (`SCRUM-894`).

## Permit expiry reminders — neither 90 nor 30 shipped

- Question: which permit types get an **advance renewal reminder**, and how many days ahead — 90 (as
  asked on 2026-04-09 for annual asset permits) or 30 (as the vault says for job/project permits)?
- Candidates:
  - Recording **2026-04-09 "Dispatch-Scheduling Figma demo"** at 42:19: *"you will get updates saying
    **90 days out**. Hey, this is not going to be good. We need to renew this certificate… that way
    it notifies you for those main ones."* **Attribution unrecoverable** — the surrounding block is a
    room-mic run-on merging the "Brian Petros" label with a second TCG voice; permits are owned by
    Liz Lopez and Lisette Anzaldo, so it is most plausibly one of them.
  - The same recording establishes the **permit population** unambiguously: *"we need to add them to
    assets itself with their expiry dates"* (line 609), *"we'll have to put **all the annual
    permits**… so that it can right away notify us if it's active or not"* (615), *"one is an
    **annual**. Most cranes that are overweight have a permit called a **purple permit, an annual**"*
    (711), *"at the **asset level**… we're gonna put the expiration date"* (875).
  - `projects-jobs/project-module/05-create-and-track-permits.md:41` — *"Permit expiry alerts are triggered
    30 days in advance"*. Its surrounding flow is **job/project** permits: *"User opens Permits tab
    inside a project"*, *"Views auto-generated Permit Requests from published jobs"*, *"System blocks
    job publishing if permit is missing"*.
  - `SCRUM-372` *Develop Permit Notifications & Expiry Reminder Scheduler* — **Done**, **`description:
    null`**, no AC, no number, no requester. Its parent `SCRUM-237` carries AC 10 byte-identical to
    the vault line. **The only number anywhere in the tree is the parent's 30.**
- Note: **neither number shipped.** The only permit scheduler in the codebase,
  `apps/api/src/usecase/permits/permit-expiry.service.ts`, runs daily and flips permits whose
  `validTill` is already **past** to `INACTIVE` — a deactivation sweep, not a reminder, with no
  advance-days threshold at all. Confirming that:
  `apps/api/src/usecase/notifications/notification-catalog.ts` has **no `permit.*` key**, while it
  does have `cert.expiring_60` and `cert.expiring_30`. So `SCRUM-372` is Done against a null
  description and the feature it names does not exist. **And the two sides may not even be in
  conflict** — annual asset permits and job permits are different populations with different renewal
  economics, so the answer may legitimately be two thresholds. Ask it as two questions.
- Blocked: `SCRUM-372` is Done but the reminder is unbuilt; `SCRUM-790` (permit deactivation cron,
  QA); any permit notification work.
- Owner: Lisette Anzaldo (dispatch/DAS/permits), with Liz Lopez, who owns the permit process in
  `vendors-agencies/purchase-order.md`.
- **Status:** open
- **From (frozen original):** [gaps.md#permit-expiry-reminders-neither-90-nor-30-shipped](../gaps.md#permit-expiry-reminders-neither-90-nor-30-shipped)
- Update 2026-09-04 (Project Repository ingest): the ingest adds a **third number** and a client
  statement of the population; still no decision. (a) TCG's working system of record for annual
  and blanket permits, `Permit Tracker.xlsx` (two copies, from Ryan's 2026-08-06 and 2026-08-11
  folders — [city-permits/permit-tracker-workbook.md](city-permits/permit-tracker-workbook.md)),
  computes `EXPIRING SOON` when `Valid To ≤ TODAY() + 60` — a **60-day** window, stated only in
  the formula; `CRANE INDEX` / `CITY COVERAGE` count "due ≤60", `RENEWAL QUEUE` bands rows
  `EXPIRED / RENEW NOW / UPCOMING / MONITOR` (band thresholds not stated), and the landing page
  lists *"the next 10 permits to renew"*. It tracks **per crane × agency** — the annual
  asset-permit population the 04-09 recording described — and it is a spreadsheet convention, not
  a requirement. It happens to coincide with the `cert.expiring_60` key already in the
  notification catalog. (b) Client statement, hand-written log #7 (Melissa, 2026-05-02,
  [erp-review-log.md](../erp-review-log.md)): assets need *"a compliance section with expiration
  dates on annual permits and certifications, as attachments with expiry and notifications"* —
  confirms the asset-level population and that notifications are wanted; **no number**. (c) On
  the job-permit side the ingest shows why a 30-day *renewal* reminder may not apply: a single
  city travel permit is valid for the move dates only (the Alhambra sample, valid 1/13–1/14/26,
  [dispatch/travel-permits-playbook.md](../dispatch/travel-permits-playbook.md) → *The approved
  permit*), so it expires with the job rather than renewing; the deadline that matters there is
  the city's lead time ([city-permits/permit-lead-times.md](city-permits/permit-lead-times.md)).
  Still needs the client: the threshold per population — 90 (04-09 recording), 60 (their own
  tracker), 30 (`SCRUM-237` AC 10) — and whether job permits get any reminder at all.
- **Update 2026-09-04, from the record** (read the same day from the `RENEWAL QUEUE` sheet of `Permit Tracker[88].xlsx`, Ryan's 2026-08-06 copy, days-left as computed on its own `TODAY()`): the four bands are **not formula-driven** — the sheet's only formulas are the `EXPIRED / NOT YET ACTIVE / EXPIRING SOON (≤ 60 days) / VALID` status — but the rows sort into clean day ranges: `1 - EXPIRED` -905…-12 days (n=124), `2 - RENEW NOW` -9…49 days (n=36), `3 - UPCOMING` 51…100 days (n=19), `4 - MONITOR` 120…415 days (n=179). Read as cut-offs that is roughly *renew now* inside about 50 days (plus the handful just expired), *upcoming* from 50 to 100 days, *monitor* from four months out — bands that do **not** line up with the sheet's own 60-day *EXPIRING SOON* rule (five *upcoming* rows are already flagged expiring), so they are the tracker author's working convention, not a stated rule, and a third number set beside the 90 and 30 the entry already holds.

## Asset on a permit — optional, except where a punch list says compulsory

- Question: is the **asset optional** on a permit — with DAS auto-attaching the asset to that date's
  job when one is present — or is an asset **compulsory** before a travel-permit request can proceed?
- Candidates:
  - Recording **2026-06-18 "Dispatch Permits"**, `ehtesham.anwar` (CodingCops) at 31:13: *"**based on
    our normal conversation, we are going to remove assets by default and then later on have it
    optional.** So, for example, if it is optional, then on the Dispatch and DAS allocation screen,
    **if for a permit we have added an asset, then we will automatically attach this asset to the job
    of that date**… Just wanted to show you this process, **Liz**."* And at 36:49: *"they're
    automatically attached to the job on that particular date. You won't have to attach it again and
    again."*
  - **Critically, there is no recorded answer.** The turns immediately following are the "Brian
    Petros" label saying *"For my system, and."* and *"That's like a remake of the Excel sheet."*
    Ehtesham says *"just wanted to confirm something"* and cites *"our normal conversation"* — an
    off-record prior discussion. **Liz Lopez is addressed by name and is not recorded replying. No
    TCG person assents on tape.**
  - `projects-jobs/project-module/05-create-and-track-permits.md` — :22 and :34 list **asset** as a permit
    form field with no optionality marker; :38 *"Active permits automatically link to job dispatch"*.
  - **CONTRADICTING** — `projects-jobs/job-project-das.md:54`: *"auto create travel permit request based on
    assets required – before navigtaing to next step, **add asset is compulsory**"* (typo verbatim).
    This is the same cross-module punch list flagged in §*Feedback punch lists are not scoped to the
    module they are filed under* — Permit is one of its nine sections.
  - `SCRUM-517` (Done, created **2026-06-08**, ten days *before* the recording) put permits on the
    **Asset Detail page's Permits tab**, where the asset is implicit from context rather than a form
    field. `SCRUM-533` (Done) is a carry-over of slipped `SCRUM-517` items and says nothing about
    optionality. `SCRUM-625` *Automatically Attach Permits to Jobs* (Done, 2026-07-01) shipped the
    second half of Ehtesham's statement: *"Permits are automatically attached to the related Job on
    the applicable date entered on the Permit"* — **it does not mention the asset**.
  - `SCRUM-788` — **Done 2026-07-27**, summary a verbatim copy of the punch-list line above (typo
    included), description *"Right now, No travel permit is required, we should generate the request
    for assets"*. **None of the four tickets names a requester.**
- Note: the optional asset **is what shipped** — `model Permit` has `assetId String?` and
  `create-permit.dto.ts` declares `assetId?: string` — and the auto-attach shipped too
  (`JobAssetPermitAssignment`, a full `job-permit-assignments` module, and a `permitLinked` prop on
  the DAS asset card). So (b) covers the recording's claim. **What is unreconciled is `SCRUM-788`**,
  Done a month later and pushing the opposite way. These may be two different objects — a *permit
  record*, which can stand alone as an annual, versus a *permit request generated from a job's
  required assets*, where naming the asset is the whole point — but **nothing written says so**, and
  a one-line ticket description cannot settle it. Answer that distinction first; the optionality
  question probably dissolves once it is named.
- Blocked: `SCRUM-788` (Done) vs the shipped optional `assetId`; the travel-permit request flow in
  DAS; `projects-jobs/project-module/05-create-and-track-permits.md`, which describes neither behaviour.
- Owner: Lisette Anzaldo (dispatch/DAS/permits), with Liz Lopez — she was the person addressed on the
  recording and never recorded answering.
- **Status:** open
- **From (frozen original):** [gaps.md#asset-on-a-permit-optional-except-where-a-punch-list-says-compulsory](../gaps.md#asset-on-a-permit-optional-except-where-a-punch-list-says-compulsory)
- **Update 2026-08-27:** Brian Petros, written message to the TCG team, 2026-08-27 ("A couple things that came up in my discussion with CodingCops today, that we'll discuss in future meetings"), following the 2026-08-26 ERP sprint review — logged in [payroll/client-message-findings.md](../payroll/client-message-findings.md#cross-module--2026-08-27-follow-ups-after-the-fcc-migration-first-pass-brian-petros) — Brian: "permits can be specific to the Asset, but can also have
  permits specific to Job". First written client statement that the permit has **two scopes**,
  which reframes this entry: the question is not only whether the asset is optional but whether
  a job-scoped permit has an asset at all. Asset-side permit types are being collected under
  assets → *Unit / asset certifications*.
- Update 2026-09-04 (Project Repository ingest): the ingest corroborates Brian's two-scope
  statement from TCG's own practice, and shows that even the asset-scoped kind is not always tied
  to one asset — evidence, not a decision. (a) Annual/blanket permits: the Permit Tracker's master
  table is one row per **crane × agency** (`Crane #`, `Crane Model`, `License Plate`), but its
  crane list also holds the non-unit scope values `BLANKET`, `90/100 TON FLEET`, `MULTIPLE`,
  `UNASSIGNED`, `WIDE LOAD`; blanket permits are filed under Crane # `BLANKET` *"so they are not
  mistaken for single-crane permits"*, and *"files with a different licence plate or no reliable
  unit identification are not assigned to a specific crane until verified"*
  ([city-permits/permit-tracker-workbook.md](city-permits/permit-tracker-workbook.md)). The Job
  Schedule Master states the rule: *"A valid crane-specific annual permit covers that crane. A
  valid BLANKET permit covers every crane in the fleet for that city"*
  ([scheduling/job-schedule-master-workbook.md](scheduling/job-schedule-master-workbook.md)). So a
  permit record needs an asset **or** a fleet/class scope. (b) Single (job) travel permits: the
  Travel Permits SOP (Liz Lopez, 2026-04-01) applies **per specific crane** — the application
  carries the crane's model, plate, per-axle weights and loaded dimensions; the prefilled forms
  are per crane-size class (`40-Ton.pdf`, `60-Ton.pdf`, `90 & 100-Ton.pdf`); the Daily Permit
  Sheet has both `Crane` (size) and `Unit #` columns; and the receipt check includes *"make sure
  it's the correct crane"* and *"Check Lic plates"*
  ([dispatch/travel-permits-playbook.md](../dispatch/travel-permits-playbook.md) §5 and images 7,
  14–19). A 265-for-90 substitution therefore re-opens the permit
  ([dispatch/confirmations-playbook.md](../dispatch/confirmations-playbook.md) §6). One city is an
  exception — Hermosa Beach needs *"no crane detail — just the route and address"*
  ([city-permits/city-permit-reference-a-l.md](city-permits/city-permit-reference-a-l.md)).
  (c) FCC facts, practice not decision: permits are schedule types (`SP`, `TP`, `FAA`) placed on a
  job as resources; `FMS_JOB_MASTER.FAAPermit` is a job-level bit; `FMS_JOB_UNITS.PermitIn` /
  `PermitOut` are per-unit rate columns. (d) Client statement, review log #7 (Melissa,
  2026-05-02, [erp-review-log.md](../erp-review-log.md)): annual permits belong in an asset
  compliance section. Still needs the client: whether a DAS-generated *travel-permit request*
  must name the unit (as the SOP's application does) or only the size class (as the prefilled
  forms do), and how a blanket/fleet permit is represented when `assetId` is optional —
  `SCRUM-788` versus the shipped `assetId?` stays unreconciled.

## Job-level "Boom Configuration" field — schema ask from payroll (Kyle)

- **Status:** open
- **Asked:** 2026-08-24 — client-message batch; Kyle via Brian
- **Question:** Kyle proposes a job-level **Boom Configuration** field, set by sales/dispatch at
  job creation: lattice-boom configuration is chosen per job, stays fixed for the job's duration
  (jobs ≥ 1 week), and drives the lattice premium
  ([payroll PAY-044](../payroll/rules/PAY-044-lattice-boom-premium.md)) for the **entire job**.
  Where does this field live (job? quotation? both), what are its values, and does the asset
  additionally carry a lattice-*capable* flag?
- **Sources checked:** message 20 (Kyle, Corrina); PAY-044; the assets subcategory alternative
  from message 19 (superseded for the actual-configuration role).
- **Update 2026-09-04 (Project Repository ingest):** the record now holds two competing shapes and
  the legacy systems' own model — no decision. (a) **Derived from the asset, not chosen — Joe and
  Brian, 2026-09-02 sprint demo:** Brian: lattice, military and shift adders *"need[] to be at the
  job level"*; Joe's trigger: **"a crawler on the job populates lattice pay"** — automatic from the
  dispatched asset, *"as opposed to it being a pop up every time you dispatch"*
  ([../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md)
  §3; registered as [../payroll/gaps.md](../payroll/gaps.md) §*Premiums are attached to employees;
  they belong to the job*). That is job-level, as Kyle asks, but **derived** rather than a field
  sales sets — and it sits on an older recorded conflict: Joe, *"It should be what they're
  dispatched to, which is tied to the asset"*, versus Melissa and Brian, the salesperson sets it on
  the crane configuration
  ([../payroll/source-attribution-and-conflicts.md](../payroll/source-attribution-and-conflicts.md)
  C-18, still *Unresolved*). (b) **Legacy — system facts:** `stg.FMS_JOB_MASTER_Raw` has no
  boom-configuration column (its lift fields are `Radius`, `Height`, `HeaviestPick`, `LiftPlan`,
  `HookReady`, `Complexity`); boom data sits on the **unit** (`BoomLength`, `JibLengthFt/In` in
  `stg.FMS_UNITS_Raw`); and `stg.FMS_JOB_UNITS_Raw` carries a per-row `ConfigType` whose values the
  ingest does not define (`../payroll/tcg-rawfms-staging-database/ddl/`). FCC pays premiums as craft
  modifiers per labor line
  ([../payroll/fcc-union-code-configuration.md](../payroll/fcc-union-code-configuration.md)), and the
  ADP workbook pays lattice from `LATT_OPER` / `LATT_OILER` tokens **per labor row**, never per job
  ([../payroll/adp-workbook-power-query-engine.md](../payroll/adp-workbook-power-query-engine.md)
  §3) — so "fixed for the whole job" is Kyle's proposal, not current practice in either system.
  (c) **A second consumer for a boom-type attribute on the asset:** the wind-sail sheet applies a
  *select-factor by crane type* — Telescopic 0.03 / Lattice Boom 0.02
  ([../assets/crane-fleet-reference.md](../assets/crane-fleet-reference.md) §8), and FCC already
  types crawlers as schedule type `CR`
  ([../assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md)). **Still
  needs the client:** chosen field or derived from the dispatched asset (Kyle vs Joe); where it lives
  if chosen; its values; and whether *lattice-capable* is an asset attribute — the wind sheet needs
  one for its own purpose, nobody has said so for pay.
- **Update 2026-09-04, from the record** (computed the same day from `stg.FMS_JOB_UNITS_Raw` in the restored 2026-06-23 backup): `ConfigType` is **empty on all 76,307 job-unit rows** — FCC's per-unit-on-job configuration column was never used, so there is no legacy job-level boom or crane configuration to migrate or to mirror. The nearest legacy precedent stays the per-labor-row craft modifier.
- **Update 2026-09-23 — a second payroll rule now depends on this field, and it is not lattice.** Corrina Bustos, Teams 2026-09-14, relayed by Brian: *"**Luffer Pay-** Oiler gets paid operator rate for base rate AND long boom"*. Brian's covering note proposes this field as the mechanism — *"I think we can determine if employees are eligible for 'luffer pay' based on the crane configuration of the job… Can check with Kyle, Joe, and Corrina"* — **explicitly unconfirmed**, and he ties it to the *crane configurations* resource-type work with Joe ([../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md](../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md); FCC resource type 76 *360 Ton All Terrain w/Luffer*, made *"after this job… separate ones for the different configurations"*). Two consequences for this entry's open question. **(a) The value set is no longer binary.** Kyle's ask was lattice-or-not; luffer pay needs the field to distinguish a **luffer** configuration as well, which the MLA treats as *long boom* (Article IV, *"including combined total mast and Luffing Boom"*), not lattice. **(b) The Kyle-vs-Joe axis — chosen field or derived from the dispatched asset — gets harder, not easier.** FCC's own answer is that a luffer configuration is a **separate resource type on the same unit** (36001 carries both *360 Ton All Terrain Crane* and *360 Ton All Terrain w/Luffer*), i.e. derivable from what was dispatched, which favours Joe. But a crane is reconfigured between jobs, so the resource type dispatched has to be the *actual* one — which is the quotation/dispatch question in [../assets/gaps.md → *One asset, one type — but one crane in several configurations*](../assets/gaps.md#one-asset-one-type--but-one-crane-in-several-configurations-how-does-an-asset-stand-for-more-than-one-resource-type). **Still needs the client**, and the pay side is registered separately: [../payroll/gaps.md → *Luffer pay — the oiler is paid the operator rate for base and long boom*](../payroll/gaps.md#luffer-pay--the-oiler-is-paid-the-operator-rate-for-base-and-long-boom).

## Job Schedule tab — what to show when the date range yields zero days

- **Status:** resolved — see [decisions/2026-08-28-job-schedule-weekend-empty-state.md](../decisions/2026-08-28-job-schedule-weekend-empty-state.md)
- **Asked:** 2026-08-24 — PR #391 (`fix/job-schedule-weekend-empty-hint`); tcg-scrum during review
- **Question:** When Start Date and End Date are set but Include Saturdays / Include Sundays are
  off such that `generateDateRange` produces zero rows (e.g. a Saturday-only range with both
  toggles off), what should the Schedule tab empty state say? Is a toggle-specific hint the
  right product behaviour, or should a designed empty state from Figma apply? What is the
  canonical copy?
- **Sources checked:** vault INDEX; `projects-jobs/INDEX.md`; `projects-jobs/gaps.md`;
  `projects-jobs/project-module/03-create-manage-job-schedule.md` (toggle + generation rules,
  status unverified); vault-wide `saturday|weekend` grep; `decisions/`; `processed.log`.
  SCRUM-234 Figma node `2964-119958` may show a designed empty state — not yet checked against
  this edge case.
- **Owner:** Lisette Anzaldo / Ryan Adams
- **Update 2026-08-28:** re-checked during PR #391 review — still unanswered. `decisions/`,
  `vault/` and Jira (SCRUM-234, last touched 2026-06-01, Done) contain nothing on this empty
  state. One constraint on the answer is now **verified**, though: whatever the copy is, the
  non-edit variant cannot instruct the user to enter edit mode on a `COMPLETED` job — edit is a
  hard block with no unlock path per
  [decisions/2026-08-25-completed-job-view-only.md](../decisions/2026-08-25-completed-job-view-only.md).
  The branch's `resolveWeekendExclusionEmptyMessage` keys only on `isEditing`, which does not
  distinguish "not editing now" from "editing permanently blocked".
- **Resolved 2026-08-28:** Fouzan Shakil (assignee / reviewer) approved the recommended answer during
  PR #391 review — toggle-specific title *"No schedule days in this range"* with a three-mode
  description keyed on `isEditMode` / `isEditing`, the read-only variant carrying no CTA.
  Recorded in [decisions/2026-08-28-job-schedule-weekend-empty-state.md](../decisions/2026-08-28-job-schedule-weekend-empty-state.md).
  **Assignee-level, not client-confirmed** — canonical copy from design or from Lisette Anzaldo /
  Ryan Adams would supersede it.

## Project detail Accounting tab — see accounting/gaps.md

- Cross-module pointer (no status of its own — the sweep counts it once, in `accounting/gaps.md`).
  The project detail Accounting tab's AC lives in this module
  (`project-module/05-create-and-track-permits.md:64`, unverified) and its tab-bar entry in
  `project-module/01-create-and-track-projects.md:33`, but the answer is owned by the accounting
  module — it is gated on that module's scope and ~Oct–Nov 2026 kickoff. Raised by `SCRUM-897`.
  Full entry: [accounting/gaps.md](../accounting/gaps.md#project-detail-accounting-tab--what-it-shows-and-what-it-shows-before-the-module-exists).

## Jobs Status Summary donut — where does an `ON_HOLD` job go?

- **Status:** open
- **Asked:** 2026-08-31 — raised while making the project detail *Jobs Status Summary* donut
  read `job.status` at all. Before this change the panel bucketed jobs purely by `startDate` /
  `endDate`, so `job.status` was never consulted and the `cancel` slice was permanently 0 —
  a `CANCELLED` job sitting inside its own date window rendered as *In Progress*.
- **Question:** `JobStatus` has five values (`ACTIVE`, `COMPLETED`, `INVOICED`, `CANCELLED`,
  `ON_HOLD`) and the donut has four slices (`completed`, `inProgress`, `scheduled`, `cancel`).
  Four of the five map without argument — `CANCELLED` → cancel, `COMPLETED` / `INVOICED` →
  completed, `ACTIVE` → scheduled or inProgress by start date. `ON_HOLD` has no obvious home.
  Should it (a) count as In Progress, (b) count as Scheduled, (c) get a fifth slice of its own,
  or (d) be excluded from the donut entirely? The same answer should govern the *Active Jobs*
  hero tile, which now counts exactly the In Progress population.
- **Interim behaviour:** `ON_HOLD` counts as **In Progress** — open work that is neither
  finished nor cancelled. Chosen because it changes no visible product surface (no new legend
  entry), not because a source says so. `normalizeJobStatusForSummary` in
  `apps/api/src/usecase/projects/projects.service.ts` is the single place to change it.
- **Sources checked:** `projects-jobs/job-project-das.md` (the only vault file naming this panel
  — its one line on it is *"`Quotations Revenue by Status` remove empty bars"*, nothing on the
  donut); `projects-jobs/INDEX.md`; `projects-jobs/project-module/`; `decisions/`; vault-wide
  grep for `ON_HOLD` / `on hold` / `Jobs Status Summary`. Nothing anywhere defines the slices.
- **Update 2026-09-04 (Project Repository ingest):** no source names the donut, but two now say
  what "hold" means to TCG and to the legacy system. (a) **FCC has no hold state** — its job status
  enumeration is exactly Tentative `T`, Confirmed `C`, On Job `O`, Finished `F`, Complete `Z`,
  Canceled `X`, Transfer `R`, the same seven at job, resource and ticket level
  ([../payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md](../payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md);
  [../dispatch/fcc-nexgen-dispatch-guide.md](../dispatch/fcc-nexgen-dispatch-guide.md) §2). System
  fact: `ON_HOLD` has no legacy counterpart to inherit a bucket from. (b) **TCG's own workbooks
  carry a `Hold` status and count it as booked-but-unconfirmed, never as cancelled:** the Job
  Schedule Master treats *"Scheduled, Saved, Tentative, Hold, and Maintenance… as unavailable; blank
  or Canceled is available"* — a held crane-day still blocks the crane
  ([scheduling/job-schedule-master-workbook.md](scheduling/job-schedule-master-workbook.md) §*The
  rules the workbook states about itself*); the Sales Dispatch Sheet's `Metrics` defines *Confirmed
  Scheduled Hours* as *"only status = Scheduled"*, **Pipeline Hours** as *"Saved + tentative + hold
  hours"*, and "booked" as any of `Scheduled · Saved · Tentative · Hold`
  ([../quotations/sales-reporting-workbooks.md](../quotations/sales-reporting-workbooks.md) §3, §6).
  Client artefacts, so evidence of how TCG reads a hold today — nearer option (b) *Scheduled* or a
  fifth slice than (a) *In Progress* — but they are crane-day statuses on sales sheets, not the
  ERP's `JobStatus`, and nobody has mapped one to the other. **Still needs the client:** the donut
  bucket for `ON_HOLD` and whether the *Active Jobs* tile follows it; the interim *In Progress*
  mapping stays unsourced.
- **Owner:** Lisette Anzaldo / Ryan Adams

## Does "Each tab saves independently" apply beyond Job details? — see assets/gaps.md

- Cross-module pointer (no status of its own — the sweep counts it once, in `assets/gaps.md`).
  [project-module/02-view-manage-job-details.md](project-module/02-view-manage-job-details.md):58
  — *"Each tab saves independently — navigating away does not lose unsaved work on another
  tab"* — is the **only** written statement of per-tab save independence in the vault
  (`status: unverified`, about the Job detail page). PR #470 built exactly that shape for
  Asset Management's sub-category detail page, with no source of its own, so the question of
  whether that line was meant app-wide or only for Jobs now blocks another module. It also
  says nothing about what happens when a multi-tab save fails part-way, which is the part
  that matters once a leave guard flushes several tabs at once.
  Full entry: [assets/gaps.md](../assets/gaps.md#one-tab-one-patch--and-what-the-leave-guards-save-means-when-several-tabs-are-dirty).

## Converted-quotation schedule days — checked by default, and what that puts on the DAS board

- **Status:** open
- **Asked:** 2026-09-02 — raised while fixing the Job Schedule tab opening with every checkbox
  clear on a job created by converting a quotation.
- **Question:** `createJobFromQuotationInTx` auto-creates the job schedule and one interval per
  weekday in the quotation's date range. Those intervals were created `isActive: false`, so the
  Schedule tab opened with nothing selected, *Selected Working Days* read 0, and view mode — which
  lists only active rows — showed *"No working days selected."* A job with **no** saved schedule
  opens fully checked, because the web's own `generateDateRange` defaults a generated row to
  active. The two creation paths disagreed and nothing written says which is right. Beyond the
  checkbox, `isActive` is also what puts a day on the dispatch board: `ensureSubJobsForDate`
  creates a sub-job for any active interval that lacks one, and `DasService.getSummary` /
  `getSubJobs` call it on **every** board fetch. So the question underneath the checkbox is
  whether converting a quotation should place every weekday of the job on the DAS board
  immediately, or whether "this is a working day" and "dispatch this day" are meant to be two
  separate acts.
- **Interim behaviour:** intervals are now created **active**, so the tab opens checked and the
  two creation paths agree. Chosen for that consistency, not because a source says so. The single
  place to change it is the `jobScheduleInterval.create` call in `createJobFromQuotationInTx`
  (`apps/api/src/usecase/projects/projects.service.ts`); `projects-schedule-conversion.spec.ts`
  pins the behaviour. Already-converted jobs keep their stored inactive rows — no backfill was
  run, so the two populations differ until someone decides.
- **Sources checked:** `projects-jobs/INDEX.md`; `projects-jobs/job-project-das.md`;
  `projects-jobs/project-module/`; `dispatch/` including `daily-allocation-INDEX.md`;
  `decisions/`; vault-wide grep for `isActive`, `working day`, `Selected Working Days`,
  `schedule interval` and `sub-job`. Nothing states the intended default, and nothing defines the
  relationship between a scheduled day and a DAS sub-job.
- **Candidates (added 2026-09-02, `tcg-scrum`):** the sweep above was vault-only — Jira and
  `meetings/transcripts/` both carry sources, and one of them **does** define the day↔DAS
  relationship, so the last sentence of *Sources checked* is too strong. What is still open is
  only the **default**, not the meaning of the flag.
  - `SCRUM-697` *job schedule footer kpis fix* — **Done** 2026-07-31, reporter Umair Khan
    (CodingCops), filed under the `SCRUM-456` *Yards Operation* epic. Its description **defines
    the KPIs the tab now shows**: *"selected working days(**that are checked and visible in
    DAS**)"* and *"Selected second shifts(**that are checked and visible in DAS**)"*, alongside a
    separate *"job duration days (total no of days)"*. So **checked ≡ on the DAS board is written
    down**, and the footer deliberately contrasts *duration* with *selected* — the design assumes
    selected **can** be fewer than the range. It says nothing about the default. This is the
    source for the *Selected Working Days* KPI itself.
  - `SCRUM-696` *"remove the check box from job=> Schedule tab"* — **Done** 2026-07-30, same
    reporter, same batch (created 2 seconds apart), same epic. **The title is misleading and must
    not be read as retiring the per-day checkbox**: the description scopes it to one named
    control, *"remove the check box '**Also enable a second shift on applied days**'"* — the bulk
    second-shift control, not the per-day selector. Recorded here because a title-only search
    finds it and concludes the opposite.
  - `meetings/transcripts/2026-04-07-dispatch-scheduling-figma-demo.md:118`, `ehtesham.anwar`
    (CodingCops) at 23:26 — the checkbox's **earliest description**, and the only one that speaks
    to direction: *"since there is a check mark available **you can uncheck a date**… There's a
    quick selection up top to **exclude** all of the weekends and if you don't want to use that
    and **exclude particular dates** on larger jobs. You can just **deselect** from here."* Every
    verb is subtractive. Ryan Adams and Melissa McNutt are present; neither responds to this turn
    (Ryan pivots to 24-hour shifts at 24:04), so **no TCG assent attaches to it**. Caveat 5
    applies — a record of a design walkthrough, not a commitment.
  - `meetings/transcripts/2026-06-17-erp-sprint-review.md:399`, `jahanzaib.nadeem` (CodingCops) at
    1:01:21 — the same behaviour demoed **on a converted job**: *"these dates are like fetched from
    the quotation… it's just like a **final confirmation**"*, then *"we do not need to dispatch the
    machines or employees on every single day. So in that case, we need to **select the particular
    days**… **only the check ones will be dispatched** [dis]played in the Daily allocation system
    dashboard, and the one that is not checked, that will be excluded."* Agrees with `SCRUM-697`
    that the checkbox **is** the dispatch selector; *"select the particular days"* is
    directionally ambiguous where 04-07 was not. No TCG turn responds.
  - **Nothing anywhere says convert-to-job creates a schedule at all.** The only written schedule
    spec — `projects-jobs/project-module/03-create-manage-job-schedule.md` and its ticket
    `SCRUM-234` (**Done**, created 2026-05-01, reporter Umair Khan) — describes a wholly **manual**
    path: *"Clicks **Create Schedule**"*, *"Selects start date and end date"*, *"System generates
    schedule rows"*. Its AC never mentions a per-day checkbox, and neither does the vault
    elsewhere. **So `createJobFromQuotationInTx` auto-creating the schedule is itself unsourced**,
    which is the prior question to what the rows default to.
  - **Adjacent, and deliberately not applied here:** `dispatch/gaps.md`
    §*Requested vs dispatched resources* is the same requested-versus-dispatched axis, decided
    **for resources only** and still open — Melissa McNutt assented on the **same 2026-06-17
    recording** that quotation-derived resources are the client-approved *request* and dispatch is
    a separate act. Whether that principle extends from resources to **dates** is an inference
    nobody has made in writing; it is not a source for this question, only a reason to ask both
    together.
  - **Downstream consequence worth naming when asking:** an active day is a `SubJob`, and
    `dispatch/daily-allocation-system.md:90,93,95` puts an incomplete pre-checklist on the card
    plus *"a notification to the assigned salesperson 72 hours before any job with an incomplete
    pre-checklist"* — shipped, `apps/api/src/usecase/notifications/notification-catalog.ts:316`.
    It is keyed on **job**, not day, so activating every weekday does not multiply the email; but
    it does mean converted jobs start nagging on a schedule nobody confirmed.
- **Ask (each answerable in one line):**
  1. When a signed quotation becomes a job, should every weekday in its date range arrive on the
     Schedule tab **already checked** (dispatcher unchecks the days they do not need), or
     **unchecked** (dispatcher checks the days they do)?
  2. `SCRUM-697` makes "checked" mean "visible in DAS". Is that still right — should checking a
     day be the single act that puts it on the dispatch board, or should a converted job's days
     be visible as *planned* without being dispatchable until someone confirms them?
  3. Should converting a quotation create the schedule at all, or should the dispatcher click
     **Create Schedule** as `SCRUM-234` describes?
- **Update 2026-09-04 (Project Repository ingest):** the legacy system answers Ask 2 for FCC and
  the client's register bears on Ask 3; the default (Ask 1) is still nowhere. (a) **In FCC a
  scheduled range and a dispatched day are two acts — system facts:** a job is a date range plus a
  `Work Weekends` flag, and unchecked *"the system ignores weekend days, shows resources as available
  on them, and prevents e-tickets being issued on those days"*; each resource row inherits the range
  as an offset ([../dispatch/fcc-nexgen-dispatch-guide.md](../dispatch/fcc-nexgen-dispatch-guide.md)
  §2 *Parameters*, §3 *Date and time inheritance*). The day-level artefact is the **ticket**, one per
  resource per day, created by a dispatcher action with the date picker limited to the resource's
  range — nothing generates one per day automatically (§5). The job also carries a separate
  `Dispatched` bit — `stg.FMS_JOB_MASTER_Raw.sql:22`, rendered by
  `sql/rpt.v_Base_JobMaster.VIEW.sql:41` as `'Dispatched'` / `'Pending Dispatch'` — so FCC keeps
  *planned* and *dispatched* as distinct states at job level (neither guide says what sets it; §*What
  the guide's screenshots show*). A blank FCC job defaults to `Work Weekends` on and status
  `Confirmed`, with `Tentative` available and carrying *"no disruptive logic"* (§2). (b) **The
  client's register on quote dates:** *"dispatch uses final job timing, not quote timing — quote
  timing is tentative, job timing is the operational source of truth"*
  ([../erp-review-log.md](../erp-review-log.md) §*Dispatch and scheduling*; carried into
  [quote-to-job-lifecycle.md](quote-to-job-lifecycle.md) with the caveat that the log is an
  unverified summary). Read against Ask 3 it is a reason the quotation's range should arrive as an
  input a dispatcher confirms rather than as dispatched days — an inference, not a statement about
  the checkbox. (c) **Not in the ingest:** nothing says FCC's `Conv Job` creates per-day rows
  ([../quotations/fcc-billing-data-and-price-lists.md](../quotations/fcc-billing-data-and-price-lists.md)
  §4 shows the button, not its effect), and no playbook or workbook states a checked/unchecked
  default. **Still needs the client:** Ask 1 (the default), Ask 2 for the ERP (FCC's answer is "two
  acts", `SCRUM-697`'s *checked ≡ on DAS* is the built one), and Ask 3.
- **Owner:** Lisette Anzaldo / Ryan Adams
- **Update 2026-09-04, from the record** (computed the same day from `stg.FMS_JOB_MASTER_Raw` in the restored 2026-06-23 backup): the job-level `Dispatched` bit is **0 on every one of the 8,083 jobs starting 2025 or later**, across all seven statuses (Confirmed 2,624 · Transfer 2,544 · Cancelled 1,175 · On Job 1,138 · Tentative 590 · Finished 7 · Complete 5). TCG never used FCC's "planned vs dispatched" flag; the only state it worked with is `Status`, so the legacy record gives no precedent for a separate dispatchable state on a job or its days.
- **See also (2026-09-12):** [decisions/2026-09-12-job-schedule-weekend-toggles-follow-the-date-range.md](../decisions/2026-09-12-job-schedule-weekend-toggles-follow-the-date-range.md) settles the **weekend-toggle** derivation on pick and on reopen (Ehtesham Anwar, CodingCops, `reference`); it does **not** settle this entry, and its residual (c) — conversion still creates weekday-only intervals — is this entry's weekend twin.

## Permit rules the E2E suite asserts with no written source — PR #488

- **Status:** open
- **Asked:** 2026-09-07 — raised reviewing **PR #488** (`qa-automation-employees`), which adds
  ~200 Playwright specs. The permit specs
  (`qa-automation/e2e/specs/permits/`: `asset-rule.spec.ts`, `status.spec.ts`, `duplicates.spec.ts`,
  `generate-po.spec.ts`, `restrictions.spec.ts`, `lifecycle.spec.ts`, `validation.spec.ts`) assert
  product rules **reverse-engineered from the running build** — their case docs say *"verified
  against the live API on 2026-09-07"*, which verifies the assertion against the code, not against
  anyone's intent. Merging them freezes the current behaviour as the expected behaviour.
- **Question:** seven rules, each needing a one-line answer. **(a)** Is an asset **required only on
  the two travel permit types** and hidden for every other type? **(b)** What is the permit **status
  vocabulary** — the build has `PENDING`/`INACTIVE` plus a separate `trackableStatus`; is that the
  intended model? **(c)** Is expiry a **stored column** moved only by cron or by a write, rather
  than derived on read? **(d)** Is the **duplicate guard** one active *annual* permit per
  (asset, type, city) → 409, applied only when an asset is present? **(e)** Is it **one PO per
  permit**, and does deleting the PO release that guard? **(f)** Do permit **time restrictions**
  validate end-after-start and **replace wholesale** on save? **(g)** Should a repeated
  archive/restore of an already-archived/active permit return 409?
- **Sources checked:** **(b) is the only one with any written source, and it undercuts (c).**
  [city-permits/permit-tracker-workbook.md](city-permits/permit-tracker-workbook.md):59
  (`status: unverified`) gives the tracker's closed list — `VALID` · `EXPIRING SOON` · `EXPIRED` ·
  `NOT YET ACTIVE` · **`MISSING EXPIRATION`** — a **fifth value the specs do not carry**; and :52
  and :172-174 state these are **computed** (*"Status and days remaining update automatically"*,
  `EXPIRING SOON if Valid To ≤ TODAY() + 60`), i.e. **derived on read, the opposite of (c)**. It is
  also a **spreadsheet's validation list, not a product spec**. `PENDING` appears as a status in
  [project-module/05-create-and-track-permits.md](project-module/05-create-and-track-permits.md):24
  (*"Saves permit as Pending"*) and
  [../vendors-agencies/purchase-order.md](../vendors-agencies/purchase-order.md):262-264, both
  `status: unverified`; `INACTIVE` and `trackableStatus` appear in **no product source** — `INACTIVE`
  survives only as this register's description of `permit-expiry.service.ts`. A **third, different**
  vocabulary is narrated by CodingCops about its own build in
  [../meetings/transcripts/2026-03-31-dispatch-scheduling-permits-figma-demo.md](../meetings/transcripts/2026-03-31-dispatch-scheduling-permits-figma-demo.md):335
  (Ehtesham Anwar @ 1:31:03) — *open / submitted / approved / cancelled*.
  **(a), (c), (d), (e), (f) and (g): nothing states them.** Searched all of `projects-jobs/`,
  `assets/`, `vendors-agencies/`, `decisions/` and grep passes over `meetings/` and
  `meetings/transcripts/`. Notable counter-evidence rather than silence on two of them: **(d)** the
  tracker deliberately holds several simultaneous records per city — *"Blanket permits are entered
  as separate fleet-level records under Crane # `BLANKET`"*, *"Current, future and historical
  permits are retained separately"* (permit-tracker-workbook.md:120-124) — so a one-active-per-tuple
  guard is contradicted by TCG's own practice; **(f)** restrictions are **free text** in the tracker
  (:140-160, *"no movement during peak hours 7–9 AM and 4–6 PM"*), not structured rows, and
  [../dispatch/travel-permits-playbook.md](../dispatch/travel-permits-playbook.md):201 files how
  restricted hours reach the schedule under *Open — do not infer*. On **(e)**, every written PO
  cardinality statement is on a different axis — *"One PO per vendor per job"*
  ([../meetings/2026-06-22-sprint-4-additional.md](../meetings/2026-06-22-sprint-4-additional.md):86,
  Melissa McNutt corroborating @ 38:27 on 2026-03-26); permit→PO is written only as a creation flow
  (`purchase-order.md`:250-256), never as a constraint, and PO **deletion** appears in no source.
  On **(g)**, [../decisions/2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md):61-63
  explicitly leaves *"who may unarchive"* and reversal unspecified, and
  [../INDEX.md](../INDEX.md):143 records that the **Permits** tracker is **not** covered by the
  archived-filter decision.
- **Related, already open — do not duplicate:** (a) is the specific case of
  [*Asset on a permit — optional, except where a punch list says compulsory*](#asset-on-a-permit--optional-except-where-a-punch-list-says-compulsory)
  in this file; answer that one first and (a) largely dissolves. (b)/(c) touch
  [*Permit expiry reminders — neither 90 nor 30 shipped*](#permit-expiry-reminders--neither-90-nor-30-shipped),
  which already holds the 90/60/30 threshold conflict.
- **Blocked:** merging PR #488's permit specs as a behavioural contract. Nothing else — the code
  works; what is unknown is whether it is right, and a green suite will stop anyone asking.
- **Owner:** Lisette Anzaldo (dispatch/DAS/permits), with Liz Lopez — the same pair who own the two
  related entries above.
- **Update 2026-11-03 (pointer, TCG-132):** item **(d)** no longer matches the code. On TCG-132, Syed Haris
  (developer) directed that a second **active** Annual permit for the same asset, type and city is
  **allowed**. The API's duplicate 409 (`assertNoActiveDuplicatePermit` / `findActiveDuplicate`) is removed,
  and `qa-automation/e2e/specs/permits/duplicates.spec.ts` now asserts the second annual is accepted
  (commits `de3452a5b`, `919bcc34a`). See
  [../decisions/2026-10-29-all-permits-create-permit-modal.md](../decisions/2026-10-29-all-permits-create-permit-modal.md)
  *Addendum 2026-11-03*, point 16, and `aidlc/TCG-132/spec.md` Q17. This is a developer direction
  (`reference`), not the owners' answer, so (d) and this entry stay **open**.

## Working note — interim open-loop fixes on feat/permits-plans-project-artifacts (2026-09-08)

- **Status:** open — **not a product adjudication.** Recorded so the interim code contract is visible while the entries below stay unanswered.
- **Asked:** 2026-09-08 — branch audit on `feat/permits-plans-project-artifacts` (quote → project → job → permits/plans → DAS → Yard).
- **Note:** Three cascades are being closed in code as an **interim contract**, not as answers to the open questions below: (1) PlanStatus ↔ TrackableStatus sync plus CANCELLED→APPROVED revive via the Upload & approve modal; (2) permit↔PO attach/detach/cancel/archive reverse rules; (3) conversion mints assignment rows and DAS/checklist falls back to non-CANCELLED `jobId`-bound artifacts. The remaining spine loops stay vault-only until owners answer.
- **Owner:** engineering (interim); product owners unchanged on each open entry.

## Artifact trackable vs legacy PlanStatus / PermitStatus drift

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit on permits/plans artifacts.
- **Question:** which vocabulary is source of truth for plans (and permits) — `trackableStatus` (OPEN / APPLICATION_SUBMITTED / APPROVED / CANCELLED) used by project artifacts and trackers, or legacy `PlanStatus` / effective `PermitStatus` used by older plan screens and list filters — and how must they stay in sync on submit / approve / reject / cancel / re-approve?
- **Sources checked:** `apps/api/src/usecase/plans/plans.service.ts` (`updateTrackableStatus` vs `submit` / `transitionStatus`); `apps/api/src/usecase/permits/permits.service.ts` (`updateTrackableStatus`); `packages/shared/src/constants/project-artifacts.ts` (`canAdvanceTrackableStatus`); related open entry [*Permit rules the E2E suite asserts…*](#permit-rules-the-e2e-suite-asserts-with-no-written-source--pr-488) item (b).
- **Note:** Interim code will sync legacy plan approve/submit into trackable and allow CANCELLED→APPROVED revive through approve endpoints; that does **not** settle which vocabulary product intends.
- **Blocked:** tracker vs legacy plan UI divergence; E2E freezing current behaviour.
- **Owner:** Lisette Anzaldo (dispatch/DAS/permits), with Liz Lopez.

## Permit↔PO reverse cascades incomplete

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit (status change and PO attach/link/remove).
- **Question:** when a linked purchase order is cancelled, archived, or detached — or when a permit is cancelled — what must happen to the other side (permit trackable status, `poType`, activity, approval gates)? Is one PO per permit still the rule, and does deleting/cancelling the PO release that guard?
- **Sources checked:** `permits.service.ts` `attachPurchaseOrder` / `syncLinkedPurchaseOrders`; `purchase-orders.service.ts` `archive` / `update`; schema `PurchaseOrder.permitId` only (no `planId`); related [*Permit rules… PR #488*](#permit-rules-the-e2e-suite-asserts-with-no-written-source--pr-488) item (e).
- **Note:** Interim code hard-blocks cancel/archive of a PO linked to an APPROVED PO-required permit; otherwise unlinks and clears `poType`. Detach clears `poType`. Cancelled permit unlinks POs. Not a product decision.
- **Update 2026-09-08 (PR review of `feat/permits-plans-project-artifacts`):** the branch now lets **one PO link several permits on the same job** (commit `88363cdda`), and cites `../decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md` for it. **That decision does not say this** — it settles *annual vs single* and *who the vendor is*, and its only cardinality statement is the opposite direction (*"one PO per permit"* is not in it either). The nearest written cardinality is on a **different axis** and is not cited by the code: *"One PO per vendor per job"* — `../meetings/2026-06-22-sprint-4-additional.md`:86, Melissa McNutt corroborating @ 38:27 on 2026-03-26. Since a single-job city permit takes **the city as the vendor**, "one PO per vendor per job" would allow one PO across several same-job permits **only when they share a city**, which the shipped rule does not check. So the same-job multi-permit PO is an **extrapolation**, and the question above ("is one PO per permit still the rule") is now live in the build rather than hypothetical.
- **Update 2026-09-11 (Fouzan Shakil, CodingCops, `reference`): part of the PO side is now decided.**
  - **Closing a PO is not cancelling it.** A `CLOSED` PO keeps its permit links and its `poType`, and stays on the permit tracker. The PO statuses are now `OPEN | CLOSED` only, so there is no cancel state. **Archive is the path that unlinks permits.** See [../decisions/2026-09-11-po-closed-means-closed-out-not-cancelled.md](../decisions/2026-09-11-po-closed-means-closed-out-not-cancelled.md).
  - **Approval still requires a linked PO**, except `TRAVEL_ANNUAL_PURPLE_PERMIT`. See [../decisions/2026-09-11-permit-approval-requires-linked-po.md](../decisions/2026-09-11-permit-approval-requires-linked-po.md).
  - **Still open:** what archiving (and so unlinking) a PO does to an **approved** permit's status and approval; whether one PO per permit is the rule; and the same-job multi-permit PO.
- **Update 2026-10-30 (pointer, TCG-132):** TCG-132's Create Permit modal widens the extrapolation:
  - one existing PO may be attached to several permits;
  - for a permit with **neither job nor project**, the PO picker lists every tenant PO, and `assertPoShareableWithPermit` checks nothing in that case.

  This is recorded only as an **AI decision awaiting developer review**: `../aidlc/TCG-132/spec.md` §12 Q14 and §11b D25. It is **not** a product answer, and this entry stays open.
- **Blocked:** PO lifecycle vs approved-permit gates; PR #488 (e); the same-job multi-permit PO shipped on `feat/permits-plans-project-artifacts`.
- **Owner:** Liz Lopez (PO process), with Lisette Anzaldo.

## Conversion mints artifacts without DAS assignment rows

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit on Create Project / Convert to Job.
- **Question:** after `generateProjectArtifacts` mints Permit/Plan rows with `jobId`, should the conversion TX also create `JobAssetPermitAssignment` / `JobPlanAssignment` rows so DAS pre-checklist and `permitLinked` light up without a manual link — or is `jobId` on the artifact enough?
- **Sources checked:** `apps/api/src/usecase/projects/generate-project-artifacts.ts`; DAS `build-pre-checklist-items.ts` (assignment tables only); `JobPermitAssignmentsService` / `JobPlanAssignmentsService`; related [*Asset on a permit…*](#asset-on-a-permit--optional-except-where-a-punch-list-says-compulsory) and SCRUM-625 auto-attach history.
- **Note:** Interim code auto-creates assignment rows where uniqueness allows and teaches DAS to fall back to non-CANCELLED `jobId`-bound artifacts.
- **Blocked:** DAS checklist false “unlinked” after convert; see also uniqueness entry below.
- **Owner:** Lisette Anzaldo.

## Assignment uniqueness vs Individual multi-artifact coverage

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit (Individual coverage mode).
- **Question:** when conversion mints N Individual LIFT/SITE (or travel) artifacts for one job, how should DAS bind them given `JobPlanAssignment` is unique on `(jobId, planType)` and job-level permit assignments are unique per `(jobId, permitType)` where `asset_id IS NULL`?
- **Sources checked:** `schema.prisma` `JobPlanAssignment` / `JobAssetPermitAssignment`; `generate-project-artifacts.ts` Individual/Combined modes; `packages/shared/src/constants/project-artifacts.ts`.
- **Note:** Interim: first artifact wins the unique assignment slot; remaining rely on `jobId` fallback for checklist “linked”.
- **Update 2026-09-11, branch `fix/permits-pos` (no ticket), commit `1229006f0`** — the interim now has a **stated precedence**: DAS All Permits prefers the **job-level** `TRAVEL_*` assignment (`assetId === null`) over any asset-scoped travel row, so quote-minted travel stops rendering as *Required* (`build-all-permits-rows.ts`, `job-permit-assignments.repository.ts`). That is a reasonable reading of Individual/Combined, but **no source states it** — this entry and [*Conversion mints artifacts without DAS assignment rows*](#conversion-mints-artifacts-without-das-assignment-rows) are still where the question lives. Recorded so the precedence does not become convention by merge. The same commit maps the modal's **Due Date** from `Permit.dueDate` rather than `validTill`, which **is** sourced — [../decisions/2026-09-08-artifact-due-date-seeded-from-first-job-day.md](../decisions/2026-09-08-artifact-due-date-seeded-from-first-job-day.md) (`reference`, Syed Haris) makes `dueDate` the artifact's own editable work-item date, and `city-permits/permit-tracker-workbook.md`:48 (`unverified`) shows `Valid From` / `Expiration Date` is the separate *validity* vocabulary. No source says the modal must carry a Due Date column at all.
- **Update 2026-09-14, branch `fix/das-permits-quotations` (no ticket), commit `d2cb6421f`** — the same All Permits modal now shows an **`ArtifactStatusPill` beside every linked code** (pending or done). No source says the modal must carry status chips; it joins Due Date and job-level travel precedence as an unsourced column/affordance on this surface. Recorded so the chip does not become convention by merge.
- **Blocked:** Individual mode vs DAS one-slot model.
- **Owner:** Lisette Anzaldo.

## Job-level permit types never auto-sync assignments on save

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit.
- **Question:** should saving an FAA / encroachment / sub-hauler artifact with `jobId` create/update the job-level `JobAssetPermitAssignment` (`assetId: null`) the way travel permits sync when `assetId` is set?
- **Sources checked:** `permits.service.ts` `syncJobAssetAssignment` (explicitly skips `assetId: null`); `JobPermitAssignmentsService.linkType`.
- **Note:** Interim code extends sync to upsert job-level type rows on save.
- **Owner:** Lisette Anzaldo.

## Available-to-link ignores trackable CANCELLED

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit.
- **Question:** should “available permits/plans to link” on a job exclude `trackableStatus === CANCELLED` (and possibly other terminal states), or keep filtering only on legacy `status`?
- **Sources checked:** `job-permit-assignments.service.ts` `availablePermitsForType`; `job-plan-assignments.service.ts` `availablePlans`.
- **Note:** Interim code excludes CANCELLED trackable.
- **Owner:** Lisette Anzaldo.

## Schedule day deactivate orphans SubJob / allocations

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit (DAS).
- **Question:** when a job schedule interval is set `isActive: false` (unchecked day), should the matching SubJob be cancelled and allocations cleared the same way as an explicit SubJob cancel — or is hiding the day from the DAS board (filter on active intervals) enough while SubJob rows linger?
- **Sources checked:** schedule save vs `sub-jobs.service.ts` cancel day; delete interval cascades SubJob; deactivate does not; related [*Converted-quotation schedule days…*](#converted-quotation-schedule-days--checked-by-default-and-what-that-puts-on-the-das-board).
- **Blocked:** orphaned allocations / locks on deactivated days.
- **Owner:** Lisette Anzaldo.
- **See also:** [dispatch/gaps.md](../dispatch/gaps.md) pointer entry.

## Job CANCELLED / ON_HOLD / INVOICED transitions unwired

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit.
- **Question:** who may move a Job to `CANCELLED`, `ON_HOLD`, or `INVOICED`, from which statuses, and what cascades (DAS SubJobs, allocations, tickets, artifacts)?
- **Sources checked:** `JobStatus` enum; list filters; `markCompletedIfAllSubJobsDone` (COMPLETED only from loadout); `job-editable.guard.ts` leaves CANCELLED/ON_HOLD/INVOICED editable “deferred”; related [*Jobs Status Summary donut…*](#jobs-status-summary-donut--where-does-an-on_hold-job-go).
- **Blocked:** status API / UI missing; donut bucket open.
- **Owner:** Lisette Anzaldo / Ryan Adams.

## Job COMPLETED does not close Project / quotation

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit.
- **Question:** when all SubJobs complete and Job becomes COMPLETED, should Project or quotation gain any terminal state, or is Job COMPLETED a dead-end upward?
- **Sources checked:** `das-loadout.service.ts` → `markCompletedIfAllSubJobsDone`; Project has no status enum (only `archivedAt`); quotation stays WON after convert.
- **Owner:** Lisette Anzaldo / sales owners for quotation side.

## Quote / Job yard free-text vs Yard master FK

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit.
- **Question:** should quotation/job `yard` remain free text copied at convert, or become a FK to the Yard master used by assets/employees and Yard Operations (Dylen loadout)?
- **Sources checked:** Job/Quotation `yard` string fields; `apps/api/src/usecase/yards/`; `/projects/yard-operations` → DylenDashboard; convert copies string.
- **Blocked:** rename Yard master does not update jobs/quotes; list `yardId` filter ≠ job.yard string.
- **Owner:** Lisette Anzaldo.
- **See also:** [dispatch/gaps.md](../dispatch/gaps.md) pointer entry.
- **Update 2026-10-30 (10-29 sales quoting) — the yard is a billing input.**
  - **Joe Schacatano (VP of Sales), 21:05–21:27:** with the job-site address the salesperson selects the
    yard the quote comes out of; on conversion the auto-populated asset is the one at that yard, tagged
    *"this is quoted to come out of this yard"*.
  - ehtesham.anwar (23:56): *"quotation always is going to be for one yard, from one yard"*; billing is yard
    to job site, never job to job. **Joe, 24:23: *"Exactly correct."*** Two minutes earlier (22:01) Joe
    allowed a multi-yard **project** quote as *"a possibility"*. Dispatch may still send from any yard or
    job; the DAS should show the yard more clearly (24:24, 25:06).
  - **Kyle Harlow, 18:03–18:49:** pick the yard from the job location — asset availability in the yard
    first, then distance, against a mapped cutoff. Joe (17:47): or from the asset's yard.
  - **Melissa McNutt, 19:07:** employees must be assignable to **both yards**; in FCC re-assigning them
    *"messes up payroll"*. FCC's own reference data allows more than one yard per employee
    (`payroll/fcc-employee-master-reference-data.md`); `Employee.yardId` is a single FK.
  - Each needs a real yard, so this question now blocks them. Still open: **(a)** FK or free text;
    **(b)** may a project quote carry more than one yard; **(c)** may an employee belong to more than one
    yard, and which yard drives payroll (subsistence distance, home yard). Source: [2026-10-29-sales-quoting-crane-set-one-yard-third-party-pos-and-faa-flag.md](../meetings/2026-10-29-sales-quoting-crane-set-one-yard-third-party-pos-and-faa-flag.md), transcript [2026-10-29-sales-quoting.md](../meetings/transcripts/2026-10-29-sales-quoting.md) §4.

## Ready-to-schedule / publish-without-permit gates unenforced

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit.
- **Question:** do Ready-to-Schedule and “block job publish if permit missing” rules from project-module playbooks need hard API/UI gates, or are they process-only?
- **Sources checked:** `projects-jobs/project-module/05-create-and-track-permits.md` (unverified); scheduling playbooks under `projects-jobs/scheduling/`; no matching enforce path found in API/web grep.
- **Related:** [*Converted-quotation schedule days…*](#converted-quotation-schedule-days--checked-by-default-and-what-that-puts-on-the-das-board).
- **Owner:** Lisette Anzaldo.
- **Update 2026-10-30 (10-29 sales quoting) — Ryan states the gate.** Ryan Adams (Sales Manager), 40:34–40:55:
  a quote must go out **without** the on-site contact / *Report To*, the lift plan, FAA permit, site plan,
  encroachment permit and travel permit, *"But I gotta be able to stop it before the scheduling happens
  without that."* Ryan (38:14) and Joe (39:28): an **alert** to the salesperson and the sales coordinator
  listing what is missing. ehtesham.anwar proposed the review at *mark as won* / convert (38:49, 40:59);
  Ryan: *"That is correct"* (41:31). Still open: **(a)** is the stop at conversion or at scheduling — Ryan
  said scheduling; **(b)** hard block or warning; **(c)** which missing items block (abdulrehman asked
  field by field, 39:50; not answered). Source: [2026-10-29-sales-quoting-crane-set-one-yard-third-party-pos-and-faa-flag.md](../meetings/2026-10-29-sales-quoting-crane-set-one-yard-third-party-pos-and-faa-flag.md), transcript [2026-10-29-sales-quoting.md](../meetings/transcripts/2026-10-29-sales-quoting.md) §5.

## Plans have no PO attach path

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit.
- **Question:** should plans ever link to purchase orders the way permits do (`PurchaseOrder.permitId`, ArtifactPoWidget), or is PO attach permit-only by design?
- **Sources checked:** schema `PurchaseOrder.permitId` only; permit attach/generate APIs; plan artifact detail has no PO widget.
- **Owner:** Liz Lopez / Lisette Anzaldo.

## Mob / demob quoted vs actual — no close-loop

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit.
- **Question:** how should quoted mobilization/demobilization on a quotation close against actual yard/loadout or ticket time?
- **Sources checked:** quotation group pricing for mob/demob; Yard Operations = Dylen loadout (separate); `quotations/mobilization-and-demobilization.md` (REQ, no verification loop).
- **Owner:** sales + dispatch. Pointer may live under quotations if that module owns the answer.

## Artifact coverage model — Individual vs Combined, and whether the choice is permanent

- **Status:** **answered in part** 2026-09-11 — see [decisions/2026-09-11-quote-to-project-permits-plans-flow.md](../decisions/2026-09-11-quote-to-project-permits-plans-flow.md). **(a)** resolved: at quotation → project conversion, **Individual** mints one lift-plan artifact per asset; **Combined** mints one shared lift-plan artifact (Ehtesham Loom). **(b) permanence** remains **open** — Loom did not say whether the choice can be edited after conversion.
- **Asked:** 2026-09-08 — PR review of `feat/permits-plans-project-artifacts` (no ticket, never ran the loop).
- **Question:** two answers needed. **(a)** Is the coverage model itself product intent — that at quotation → project/job conversion the user picks, **per document type**, between minting one permit/plan artifact **per crane sub-category** ("Individual", the shipped default) and **one artifact covering all of them** ("Combined")? **(b)** Is that choice **permanent**? The branch stores `CoverageMode` on `Permit`/`Plan` with `PermitCoverageCategory` / `PlanCoverageCategory` join tables and offers **no later edit path**, so a job that needed Combined and got Individual (or the reverse) cannot be corrected without deleting and re-converting.
- **Sources checked:** nothing states the model. `projects-jobs/project-module/05-create-and-track-permits.md` (`unverified`) and `04-create-and-approve-lift-plans.md` (`unverified`) describe permits and plans one at a time and never mention coverage; `04`:44 says the opposite granularity — *"Each Lift Plan must be linked to a specific crane/resource"* — and `:45` *"Multiple Lift Plans can exist for the same job"*, which permits Individual but does not require a mode switch. Nearest real-world analogues, all **practice, not decisions**: `city-permits/permit-acquisition-process.md`:89-97 (`unverified`) distinguishes an **annual** covering *"one named crane (by licence plate / VIN) in one jurisdiction"* from a **blanket** covering *"any fleet vehicle"* — per-unit vs fleet-wide, but for annuals, not for a job artifact — and :193 states flatly *"No note gives a rule for choosing between a single and an annual permit on a given job."* `../dispatch/travel-permits-playbook.md`:253-257 (`unverified`) records that the prefilled city applications are filed **per crane-size class** (`40-Ton.pdf`, `60-Ton.pdf`, `90 & 100-Ton.pdf`). **Two transcript turns that look like a source are not one.** `../meetings/transcripts/2026-06-18-dispatch-permits.md`:214 (Ehtesham Anwar, CodingCops, @ 1:00:00) asks *"all of the cranes of up to sixty-five need individual permits for each job, right?"* — and **Kyle Harlow answers "No."** at :215, correcting him at :220 (1:00:54): *"it's actually 350 and below… the 360 is a single trip machine."* So "individual" there means **single-trip permit vs annual permit**, a per-tonnage eligibility fact about whether an annual already covers the move — not a user-chosen coverage mode. `../meetings/transcripts/2026-06-09-payroll-app-demo-01.md`:438-439 uses "individual permits" in the same sense, against "yearly permits", with Melissa McNutt replying about routes on single-trip permits. **The one genuinely adjacent statement, and it is a client executive's**, is `../meetings/transcripts/2026-03-06-sales-quoting-figma-demo.md`:204 (`reference`), **Melissa McNutt** @ 41:13: *"It's typically **one lift plan per crane**. If there's multiple, if it's a… **tandem lift**, if two cranes are lifting one piece at the same time, then those would be on a **shared lift plan**. Other than that, every crane picks gonna be its own lift plan because the capacities and everything's gonna vary."* That is a per-crane default with a **tandem-lift** exception — the closest thing on record to Individual/Combined, but stated as an **engineering fact about lift plans**, not as a per-document-type selector offered at conversion, and it says nothing about permits. Nothing describes the choice as made **at conversion** — `../meetings/transcripts/2026-06-18-dispatch-permits.md`:218 describes conversion minting *"automatically in the permit tracker, there's a new rule for that job"*, one row, no selector — and nothing describes it as **permanent**; the only "locked at conversion" statement in the neighbourhood is about the *quotation* (`quote-to-job-lifecycle.md`:52). Searched all 628 vault files including transcripts, on `coverage`, `individual`, `combined`, `per crane`, `one artifact`, `immutable`, `permanent`, `once chosen`, `locked`.
- **Note:** shipped default is `INDIVIDUAL` (`packages/shared/src/constants/project-artifacts.ts` `DEFAULT_ARTIFACT_CONFIG_MODE`), offered only for category-scoped docs (lift plan, travel permit, FAA); everything else is minted `SINGLE`. Interim code contract only — not an adjudication.
- **Blocked:** whether the conversion configuration panel is the right place for this choice at all; whether an edit/re-mint path is required; the DAS binding consequence already filed as [*Assignment uniqueness vs Individual multi-artifact coverage*](#assignment-uniqueness-vs-individual-multi-artifact-coverage).
- **Owner:** Lisette Anzaldo (dispatch/DAS/permits), with Ryan Adams for the quotation-side configuration step.

## `OPEN` as the starting trackable status, and the retirement of `APPROVED_BY_OTHERS`

- **Status:** **answered in part** 2026-09-11 — see [decisions/2026-09-11-quote-to-project-permits-plans-flow.md](../decisions/2026-09-11-quote-to-project-permits-plans-flow.md). **(a)** resolved: permits start **Open**, advance to **application submitted** on application upload, then **Approved** on approved-permit upload. **(b)** resolved: plans start **Open** and go to **Approved** via upload approved plan (no separate submitted stage in the walkthrough). **(c)** `APPROVED_BY_OTHERS` history remains **open** / unexplained. After leaving Open, the walkthrough states the artifact **cannot return to Open**.
- **Asked:** 2026-09-08 — PR review of `feat/permits-plans-project-artifacts`.
- **Question:** **(a)** Is the permit lifecycle four states — `OPEN` → `APPLICATION_SUBMITTED` → `APPROVED`, plus `CANCELLED` — with `OPEN` the value a newly minted permit carries? **(b)** Is the plan lifecycle three states — `OPEN` → `APPROVED`, plus `CANCELLED` — i.e. do plans genuinely have no submitted stage? **(c)** What was `APPROVED_BY_OTHERS` for, and did anyone decide to drop it? The branch removes it from `TrackableStatus` outright.
- **Sources checked:** the closest thing to a source is CodingCops narrating **its own design** to Brian Petros on `../meetings/transcripts/2026-03-31-dispatch-scheduling-permits-figma-demo.md`:335-337 (`status: reference`), Ehtesham Anwar @ 1:31:03: *"if they are in cancelled state, if they are in approved. If they're in submitted state, approved by the state… whenever you create a permit, it's it is going to have all of these statuses. **By default, it's going to be open. That means that you haven't submitted the applications.** Once you upload these applications submitted, it's going to get automatically updated to the… Application submitted. Once you upload the approved plan, uh approved permit that you receive from the agency, it's going to go into approved."* Brian's only responses are *"Oh, I see"*, *"Oh, okay. Perfect."* — **vendor-narrated design with assent, not a stated requirement**, and the fifth value in that list (*"approved by the state"*, plausibly the transcription of `APPROVED_BY_OTHERS`) is never explained. `APPROVED_BY_OTHERS` appears in **no vault file, no ticket and no decision**; it entered the schema in commit `91479bd54` *"added and wired trackers screens"* (2026-06-25), which cites nothing. No source distinguishes a plan lifecycle from a permit lifecycle. `project-module/05-create-and-track-permits.md`:24 (`unverified`) says *"Saves permit as Pending"* — a different word again; `../vendors-agencies/purchase-order.md`:262-265 has *"Application submitted"*; `city-permits/permit-tracker-workbook.md`:59 (`unverified`) is a fourth vocabulary (`VALID`/`EXPIRING SOON`/`EXPIRED`/`NOT YET ACTIVE`/`MISSING EXPIRATION`), and it is a spreadsheet validation list.
- **Related, do not duplicate:** [*Artifact trackable vs legacy PlanStatus / PermitStatus drift*](#artifact-trackable-vs-legacy-planstatus--permitstatus-drift) asks which vocabulary is source of truth; this entry asks what the trackable vocabulary's **members** should be. [*Permit rules the E2E suite asserts…*](#permit-rules-the-e2e-suite-asserts-with-no-written-source--pr-488) item (b) is the same question from the QA side.
- **Blocked:** whether dropping `APPROVED_BY_OTHERS` loses a real operational state (e.g. a permit the customer or a sub-hauler holds); PR #488 freezing the current enum.
- **Owner:** Lisette Anzaldo (dispatch/DAS/permits), with Liz Lopez.

## `CANCELLED` is near-terminal — no route back to `OPEN`

- **Status:** open
- **Asked:** 2026-09-08 — PR review of `feat/permits-plans-project-artifacts`.
- **Question:** from `CANCELLED`, the only permitted transition is to `APPROVED`, and that route requires uploading a final permit/plan document (`canAdvanceTrackableStatus`, `packages/shared/src/constants/project-artifacts.ts`:158-161). So a permit or plan **cancelled by mistake cannot be returned to `OPEN`** and cannot be re-submitted — the only way back is to produce an approved document. Is that intended, or must cancellation be reversible (reopen / restore), and if so by whom?
- **Sources checked:** no vault file states any permit or plan cancellation rule at all — searched `projects-jobs/` (all five folders), `dispatch/`, `vendors-agencies/`, `decisions/`. The nearest written statement is `../decisions/2026-08-20-archive-instead-of-delete-app-wide.md`:61 (`status: reference`), which explicitly leaves *"Retention, permissions and reversal — who may archive, who may unarchive"* unsettled; archive and cancel are different axes and it does not speak to cancel.
- **Note:** the `CANCELLED → APPROVED` revive via the Upload & approve modal is recorded as an **interim code contract** in [*Working note — interim open-loop fixes…*](#working-note--interim-open-loop-fixes-on-featpermits-plans-project-artifacts-2026-09-08); it was never a product answer.
- **Blocked:** a mis-cancelled artifact has no recovery path in the UI.
- **Owner:** Lisette Anzaldo.

## Permits can no longer be created outside the artifact flow — and the vault says they can

- **Status:** resolved — see [decisions/2026-10-29-all-permits-create-permit-modal.md](../decisions/2026-10-29-all-permits-create-permit-modal.md). As of 2026-10-29, Syed Haris (developer direction, TCG-132, `reference`, not a TCG sign-off) has Create Permit return on All Permits as a modal. Its types are Travel, Annual Travel, FAA, Encroachment and Sub Hauler, so an ad-hoc job-scoped permit is creatable again. Points 2 and 4 of the 2026-09-11 interim note below are superseded for All Permits. Lisette Anzaldo and Brian Petros have not confirmed it. *Earlier status, kept as the record:* **resolved for the interim** 2026-09-11 — see [decisions/2026-09-11-permit-classes-job-only-until-sept-15.md](../decisions/2026-09-11-permit-classes-job-only-until-sept-15.md). **Hide Create Permit** on the Permits tab through the 15 Sep 2026 deadline; only **job-class** permits minted at quotation → project conversion are live. **General-class handling and asset linking are deferred after 15 Sep.** Longer-term manual create (vault + Ehtesham 2026-06-18 transcript) is **deferred, not cancelled**. The 2026-09-10 answer that restored global create ([decisions/2026-09-10-permit-association-scope-asset-job-vendor.md](../decisions/2026-09-10-permit-association-scope-asset-job-vendor.md) / point 5 of [decisions/2026-09-10-permit-create-types-mockup-document-types.md](../decisions/2026-09-10-permit-create-types-mockup-document-types.md)) is superseded for the create-path claim.
- **Asked:** 2026-09-08 — PR review of `feat/permits-plans-project-artifacts`.
- **Question:** the branch removes the "New Permit" button from All Permits; `/permits/create` survives as a route that nothing links to, and the only remaining creation path is an **asset-scoped annual permit** under Asset Management. So a job that needs a permit type **not ticked on its quotation** has no way to get one. Is *"permits only ever originate from the quotation's document configuration"* the intended rule, or must an ad-hoc job-scoped permit remain creatable?
- **Sources checked:** **the vault says the opposite, and it is the only written statement on the point.** `project-module/05-create-and-track-permits.md`:21 (`status: unverified`) — *"Clicks Create Permit from request **or manually creates a new one**"* — with :20 *"Views auto-generated Permit Requests from published jobs"* and AC :33 *"Permit Requests are auto-generated from **job publishing**"* as the other path. Two creation paths, and the automatic one is triggered by **job publishing, not by the quotation**. Nothing supersedes it. **Two transcripts corroborate the manual path directly**, both `status: reference`: `../meetings/transcripts/2026-06-18-dispatch-permits.md`:131 (Ehtesham Anwar @ 38:47) — *"we are going to **allow them to create permit manually, so by manually, it's going to be just a button click**"* — and :129 (@ 37:02), *"on the job page, you are going to see that you can **create, submit a new permit request, or create a link to the permit that is already present in the asset**"*. A **third** origin is written in `job-project-das.md`:54 — *"auto create travel permit request based on assets required"* — filed as contradicting the others at [gaps.md](#asset-on-a-permit--optional-except-where-a-punch-list-says-compulsory). The quotation trigger, where it is written at all, is explicitly **one detection path among several**: `../meetings/transcripts/2026-06-18-dispatch-permits.md`:212 (@ 59:38), *"we have some of the checks in the asset management… some in the quotation itself… **Otherwise, system is going to identify from the**…"*. Partial support for the quotation-origination half exists but only for **plans**: `04-create-and-approve-lift-plans.md`:43 (`unverified`) — *"A Lift Plan is not required for every job… The Salesperson flags this at the quotation stage"* — and, for permits, vendor narration on `../meetings/transcripts/2026-03-31-dispatch-scheduling-permits-figma-demo.md`:335 (`reference`), *"we are going to identify that we need a permit in. And that identification is within the quotation, right?"* — which establishes the quotation as **an** origin, never as the **only** one. The same walkthrough at :58 puts creation on the project/job (*"she can just click on create permit and then enter all of the details"*) and reserves the quotation-driven generation for **plans** (*"or if within a quotation it was selected that we need a plan"*). Counter-evidence that ad-hoc permits are real: `city-permits/permit-acquisition-process.md`:87-117 (`unverified`) documents stacked jurisdictions, address-specific annuals and per-entry notification permits that no quotation checkbox anticipates; `quote-to-job-lifecycle.md`:54-55 (`unverified`) records the client-folder sketch's *"A permit can be attached at either the quote or the job stage"*; and `../assets/gaps.md`:178 notes FCC sells `FAA`/`SP`/`TP` **per job** as schedule types, not per asset.
- **Blocked:** any job whose permit need is discovered after conversion — a route change, a stacked jurisdiction, a city added late. Also [*Ready-to-schedule / publish-without-permit gates unenforced*](#ready-to-schedule--publish-without-permit-gates-unenforced), since a blocked publish would have no remedy.
- **Owner:** Lisette Anzaldo (dispatch/permits), with Brian Petros as the person who actually files them.

## Lift/site plan approval no longer routes through the salesperson

- **Status:** open
- **Asked:** 2026-09-08 — PR review of `feat/permits-plans-project-artifacts`.
- **Question:** the new **Upload Approved Plan** action sets a plan to `APPROVED` directly, firing no notification and overriding an existing `REJECTED`. The vault requires a review chain. Is the chain retired, or must upload-to-approve still route to the salesperson when the uploader is not the salesperson?
- **Sources checked:** **the vault states the chain in two places on the same page**, `project-module/04-create-and-approve-lift-plans.md` (`status: unverified`) — User Flow :24-26: *"If created by Salesperson linked to quotation, plan is auto-approved · If created by anyone else, **Salesperson receives notification to review** · Salesperson approves or **sends it back with comments for changes**"*; Acceptance Criteria :38-40: *"Salesperson created plans auto-approve without notification · **Other creators trigger approval workflow to Salesperson** · Salesperson can approve or request changes with comments"*. The Site Plan story on the same page repeats it generically at :60-61 and :75-76 (*"status changes to Pending Approval and approver is notified"*). Corroborated as the product model — not superseded — by `lift-plans/lift-plan-request-and-3d-lift-plan.md`:125-126 (`unverified`), which describes *"an approval workflow where a salesperson-created plan auto-approves and anyone else's routes to the salesperson"*, and notes at :135 that the 3D playbook's own review names **more** roles (operations, safety, project management, the crane operator) than the product page's single salesperson — a widening, not a removal. `lift-plans/post-scheduling-lift-plan-completion.md`:125-126 records the plan's status model as *Pending Approval / Approved / Customer Approved*. Nothing anywhere retires the chain.
- **Blocked:** whether the branch must restore the notification + review path, or whether a named human retires it. Also unaddressed: `REJECTED` being silently overwritten, and *"Customer Approved"*, which the shipped three-state plan lifecycle has no room for (`04`:41, *"Customer approval is clearly displayed on plan cards"*).
- **Owner:** Ryan Adams / Joe Schacatano (sales own the salesperson step), with Lisette Anzaldo.

## Artifact due date = the job's first scheduled day, with no permit lead time

- **Status:** **answered in part** 2026-09-08 — see [decisions/2026-09-08-artifact-due-date-seeded-from-first-job-day.md](../decisions/2026-09-08-artifact-due-date-seeded-from-first-job-day.md). The **seed** and **editability** are settled; the **lead-time half is not**, and is now tracked as its own open entry immediately below.
- **Asked:** 2026-09-08 — PR review of `feat/permits-plans-project-artifacts`.
- **Question:** `resolveFirstJobScheduledDate` (`apps/api/src/usecase/projects/generate-project-artifacts.ts`:217) seeds **every** artifact's due date from the earliest active job schedule interval, falling back to the schedule's then the job's `startDate`, with no reference to the jurisdiction's permit lead time. Is *"due by the job's first scheduled day"* the rule — or must a permit's due date be driven **backwards** from that date by the city's lead time and the permit clock, so the artifact is due when the application must be filed rather than when the crane rolls?
- **Sources checked:** **no source names a "due date" field on a permit or plan artifact — but the record does specify a permit deadline, and it is computed backwards from the job date, not equal to it.** `scheduling/job-schedule-master-workbook.md` (`status: unverified`) is the densest source: its computed columns are *"**Permit Lead Time (Days)** · **TCG Planning Lead Time** · **Countable Permit Days Left** · **Latest Permit Submission** · FINAL PATH"* (:34), the shipped worked example puts a **2026-08-16** job date against *"Latest Permit Submission: **2026-08-12 17:00**"* (:37-41), the display rule is *"selecting a city displays the city permit lead time in days and **the latest submission deadline**"* with *"ANNUAL ACTIVE — 0 DAYS"* where an annual or fleet BLANKET already covers the crane on that date (:99-101), and the arithmetic is `NETWORKDAYS.INTL(TODAY(), jobDate − 1, "0000111")` — a Monday–Thursday week, minus one more day after Thursday noon (:167-170), with *"permit validity is tested **against the job date**, not today"* (:150). `scheduling/dispatch-scheduling-path.md` (`unverified`) states the rule: *"First identify the permitting city and its required lead time on the approved Permit Lead-Time Chart. Then calculate **only eligible permit-processing time**. **If the full applicable lead time is unavailable, the job is Red.**"* (:24-26), and *"Thursday at 12:00 noon… through the start of the normal business day on Monday **does not count toward any permit lead time**"* (:30-32); the Green/Yellow/Red timing test is at :75. `../dispatch/dispatch-value-engine-and-playbooks.md`:77 draws the same order — *"Confirm Permit Lead time · Confirm Job Date · Order Permits"*. `quote-to-job-lifecycle.md`:126-130 (`unverified`) confirms the job date is the clock's **input**: *"the job's date is what the permit clock is calculated against"*. One city states the backwards rule in words — `city-permits/city-permit-reference-m-z.md`:71, Santa Paula, *"submit at least 3 business days before the permit start date"*. **What is genuinely unsettled** is which lead-time dataset governs: `city-permits/permit-lead-times.md` is titled *"three datasets that disagree"*, and `city-permits/INDEX.md`:44-47 records that **nobody has said which is the approved Permit Lead-Time Chart** the playbooks require, with 34 cities differing between two of them. **For plans**, the only written statement is that a due date is a **collected** field, not a derived one: `../quotations/sales-operating-system/05-forms-and-records-matrix.md`:100 (`unverified`) lists *"required plan due date"* in the Lift Plan Request minimum data set, and never says how the value is arrived at. Searched all 628 vault files on `due date`, `needed by`, `days before`, `latest permit submission`, `submission deadline`, `submit by`, `apply by`, `target date`, plus a permit/plan-filtered pass over `meetings/transcripts/`.
- **Note:** two sub-questions ride on the answer — whether plans (24-hour standard turnaround, `lift-plans/lift-plan-request-and-3d-lift-plan.md`) and permits should date the same way at all, and whether the permit-waiver path (`city-permits/permit-waiver.md`) changes the date or only the gate.
- **Blocked:** the due tag and any overdue/at-risk signalling on the artifact tracker are meaningless until the date means something; Green/Yellow/Red cannot be computed from a date that ignores lead time.
- **Owner:** Lisette Anzaldo (dispatch/permits), with Ryan Adams (scheduling gate).
- **Answered 2026-09-08 (Syed Haris, `status: reference`):** the artifact `dueDate` is a **seed plus a freely editable field**, not a derived one — *"The due date will be initially set as the first scheduled job, but is editable to any other date of course."* The contradiction with the workbook dissolves because they are **two different fields**: `Latest Permit Submission` is a computed dispatch deadline, `dueDate` is a plain editable date on a work item. So `resolveFirstJobScheduledDate` (`apps/api/src/usecase/projects/generate-project-artifacts.ts`:217, called at :461 for both permits and plans) is **correct as built**, and `scheduling/job-schedule-master-workbook.md` is **not superseded** — it keeps `status: unverified` and its arithmetic stands. **Still unanswered and moved out of this entry:** whether the app should compute or warn on a lead-time deadline at all, and which of the three datasets would govern if it did.

## "Latest Permit Submission" — should the app compute or warn on a lead-time deadline, and from which dataset?

- **Status:** open
- **Asked:** 2026-09-08 — split out of *Artifact due date = the job's first scheduled day, with no permit lead time* (above) when [decisions/2026-09-08-artifact-due-date-seeded-from-first-job-day.md](../decisions/2026-09-08-artifact-due-date-seeded-from-first-job-day.md) answered the seed half only. Kept as its own entry so the open-question sweep still finds it.
- **Question:** the `dueDate` on an artifact is now settled as an editable work-item date that ignores lead time. Separately from it — **does the ERP owe a computed `Latest Permit Submission` deadline at all** (a second field, a badge, or the Green/Yellow/Red scheduling gate)? And if it does, **which lead-time dataset is the "approved Permit Lead-Time Chart"** the playbooks require?
- **Sources checked:** unchanged from the parent entry, which surveyed all 628 vault files. The record clearly *describes* the deadline — `scheduling/job-schedule-master-workbook.md` (`unverified`) computes it as `NETWORKDAYS.INTL(TODAY(), jobDate − 1, "0000111")`, a Monday–Thursday week minus one more day after Thursday noon (:167-170), and displays *"the city permit lead time in days and the latest submission deadline"* with *"ANNUAL ACTIVE — 0 DAYS"* where an annual or fleet BLANKET already covers the crane (:99-101); `scheduling/dispatch-scheduling-path.md`:24-26 makes it a gate — *"If the full applicable lead time is unavailable, the job is Red"* — and excludes Thursday noon → Monday from any lead time (:30-32). **What no source supplies is the input.** `city-permits/permit-lead-times.md` is titled *"three datasets that disagree"*, and `city-permits/INDEX.md`:44-47 records under *What is unsettled* that **nobody has said which is the approved chart**, with **34 cities differing** between two of them. A computed deadline is unbuildable until that is named.
- **Note:** three sub-questions ride on the answer, all carried over from the parent entry. (a) Does the artifact tracker's overdue / at-risk signalling key off the editable `dueDate` or off this computed deadline? An editable date can be moved to silence a warning, which is fine for a work item and not fine for a compliance gate. (b) Should plans and permits date the same way at all — plans carry a 24-hour standard turnaround (`lift-plans/lift-plan-request-and-3d-lift-plan.md`) that the shared seed ignores. (c) Does the permit-waiver path (`city-permits/permit-waiver.md`) change the date or only the gate?
- **Blocked:** Green/Yellow/Red cannot be computed at all, and no at-risk or overdue signal on the artifact tracker can be trusted as a permit-compliance signal, until the deadline has a named dataset behind it. The seed decision unblocks the field; it does not unblock this.
- **Owner:** Lisette Anzaldo (dispatch/permits) to name the approved Permit Lead-Time Chart, with Ryan Adams (scheduling gate) on whether the ERP computes the deadline or dispatch keeps it in the workbook.

## Archived plans are unreachable — the branch removes both surfaces two decisions relied on

- **Status:** open
- **Asked:** 2026-09-08 — PR review of `feat/permits-plans-project-artifacts`.
- **Question:** the branch deletes the project Plans tab (`apps/web/src/features/projects/components/project-detail-plans-tab.tsx` and `use-project-plans-archive.ts`) and its replacement carries **no archived filter and no unarchive action**, so an archived plan is now reachable from nowhere. Two recorded decisions assume otherwise. Is the loss intended — and if archive is to stay the removal action, where does an archived plan live now?
- **Sources checked:** **two decisions, both `status: reference`, both contradicted.** `../decisions/2026-08-20-archive-instead-of-delete-app-wide.md` (Fouzan Shakil, resolves `SCRUM-896` §12 Q1) makes archive the app-wide removal action with `Plan` explicitly in scope (:28-31) and lists as authorised work, at :93, *"Archive / unarchive on plans, and **an archived quick filter on the project Plans tab**"* — the exact surface this branch deletes. `../decisions/2026-08-20-planning-tracker-archived-filter.md` (Fouzan Shakil, resolves `SCRUM-896` §12 Q3) reasons at :48-52 that a permanent tracker exclude would leave an archived plan *"reachable from exactly one surface (**the project Plans tab, Archived filter**) and invisible from the cross-project view"* — it treats that tab as the fallback while the tracker filter stays **deferred to a follow-up ticket that has not shipped**. Its *What this does not settle* leaves open at :78-79 *"whether archived plans can be restored from the tracker, or whether the tracker only views them and **restore stays on the project Plans tab**"*. With the tab gone and the tracker filter unbuilt, both surfaces are absent at once — a state neither decision contemplated.
- **Blocked:** archiving a plan is now effectively a delete with no recovery, which is the outcome `2026-08-20-archive-instead-of-delete-app-wide.md` exists to prevent.
- **Owner:** Fouzan Shakil to confirm intent (he made both calls), escalating to the client-side product owner if archive semantics are changing.

## Customer PO on the job — a new "POs" tab, where every source names Schedule or Main

- **Status:** open
- **Asked:** 2026-09-09 — PR review of `fix/quotation-permits-plans` (63 files, no Jira ticket, no `processed.log` row, no ticket folder).
- **Question:** the branch gives `Job.poNumber` — Brian Petros's Type 1 Customer PO — its only editor on a **new job-detail tab called "POs"** (`apps/web/src/features/projects/jobs/job-details/pos/job-pos-tab.tsx`, registered in `view-job.tsx` between *Additional Info* and *Permits / Plans*). Two named humans and the March 2026 lifecycle SVG name a different tab, and **no source anywhere names a job-level POs tab**. Is the new tab intended, or does the field belong on the existing **Schedule** tab as decided?
- **Sources checked:** [../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md](../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md):59, :111 — *"Log it on the job (schedule tab)"*, and the settles-table row *"Where the customer PO lives | **Job / schedule tab**, and on the final invoice — not the quotation"*. [../vendors-agencies/purchase-orders-fcc/commissioning-email-thread.md](../vendors-agencies/purchase-orders-fcc/commissioning-email-thread.md):69-71 — **Melissa McNutt, 4 December 2025**, nine months earlier and independently: *"Type 1: The PO the customer gives to us. **This goes on the schedule job tab**"*; and :87 — *"The **job tab** is where the **customer's** PO shows on the job screen."* [project-module/02-view-manage-job-details.md](project-module/02-view-manage-job-details.md):24, :57 — the **only** page in the vault that names the job-detail tab set: *"Main, Resources, Schedule, Progress Tracking, Tool/Rigging, Attachments"* — no POs tab, and its Main-tab field list (:39-42) names no PO field. [project-module/03-create-manage-job-schedule.md](project-module/03-create-manage-job-schedule.md) — the Schedule tab's own AC page, which also names no PO field. [../vendors-agencies/purchase-orders-fcc/po-001-pre-job-purchase-orders.md](../vendors-agencies/purchase-orders-fcc/po-001-pre-job-purchase-orders.md):195-207 — in FCC the customer PO number sits on the **job's Main tab** (`Job Number · Company · Yard · Department · Salesperson · Checked By · Taken By · PO Number · Status`), and FCC's job screen has no POs tab either. [../meetings/2026-06-22-sprint-4-additional.md](../meetings/2026-06-22-sprint-4-additional.md):83 — the only *"PO Numbers tab"* in the whole vault, and it is **inside a project**, not a job.
- **Note:** *"schedule job tab"* (Melissa) and *"job / schedule tab"* (the SVG, Brian) are both loose. FCC's module is literally `Schedule → Job`, so both may simply mean *the job screen reached from Schedule* — which in FCC is the job **Main** tab, where the field actually lives. **Neither reading produces a POs tab.** The build also keeps `Project.poNumber` unwritten, so the project half of the decision is still unbuilt.
- **Blocked:** nothing functionally — the field saves. What is at risk is that a placement contradicting a four-day-old named decision ships without the decider seeing it.
- **Owner:** Brian Petros (he made the 2026-09-05 call), with Melissa McNutt (she made the same call in 2025).

## Job Main "Quick Access" — is the FCC Related Information panel the spec, and may unbuilt entries be dropped?

- **Status:** open
- **Asked:** 2026-09-09 — PR review of `fix/quotation-permits-plans`.
- **Question:** the Quick Access card on the job Main tab loses its **POs**, **Tool** and **Storage Item(s)** pills (commit `d30f90eaa`) and gains a **Customer PO** pill. All three removed pills were hardcoded `N/A`, but so are **Invoice History** and **Latest Invoice**, which the branch keeps — so "only show live links" is not the rule actually applied. Two questions: **(a)** is this card meant to be TCG's transcription of FCC's job **Related Information** panel, and if so is the panel's entry list a requirement? **(b)** when a panel entry has no data behind it yet, is the convention to show it as `N/A`, hide it, or drop it permanently?
- **Sources checked:** [../quotations/fcc-billing-data-and-price-lists.md](../quotations/fcc-billing-data-and-price-lists.md):338-341 — the FCC job screen's **Related Information** panel, transcribed from the 2026-09-04 screenshots: *"**Quote `OM-32716`** · PO(s) *none* · Tool(s) *none* · Lift Info *present* · **Price List `SO CAL EDISON`** · Storage Item(s) *none* · Latest Invoice 10/10/2025 · Invoice History 1 · Daily *none*"*. The shipped card is that list minus *Lift Info* and *Daily*, entry for entry and in near-identical order — **the three pills being removed are `PO(s)`, `Tool(s)` and `Storage Item(s)`, and in FCC's own example all three legitimately read *none***, i.e. they are real fields with empty values, not invented placeholders. Same file :214, :218-220 — *"The `Quote` and `PO(s)` fields on the job's Main tab are the third independent confirmation that POs live on the job, not the quote."* [project-module/02-view-manage-job-details.md](project-module/02-view-manage-job-details.md):37-43 — the Main-tab AC, which names no Quick Access card at all. [../accounting/gaps.md](../accounting/gaps.md):132-135 — the sibling question for the other direction, recording that *"Coming Soon"* is *"a build habit with no written product backing"*.
- **Note:** removing the **POs** pill in the same branch that adds a **POs tab** is defensible on its own terms, but it removes the one Related-Information entry that FCC uses to show a job's linked purchase orders — while the new tab does list them. Nothing written says whether the Quick Access card should point at the tab or duplicate it.
- **Blocked:** nothing. Recorded because the card is being trimmed against a source nobody has adjudicated.
- **Owner:** Brian Petros / Lisette Anzaldo — whoever owns the job-detail screen; the FCC panel is TCG's own screen, so TCG owns whether it is the target.

## "Artifact" or "Document" — the user-facing word for permits and plans

- **Status:** open
- **Asked:** 2026-09-09 — PR review of `fix/quotation-permits-plans`, commit `e57187f31`.
- **Question:** the branch renames every user-facing *"artifact"/"artifacts"* to *"document"/"documents"* across the permits/plans tracker, tab, config panel, create-progress modal and empty states; code identifiers, API paths and test IDs are unchanged. Is **Document** the word TCG wants on this surface — and is the surface itself named (Documents? Permits & Plans? two separate trackers)?
- **Sources checked:** **No vault source calls this surface "Artifacts".** "Artifact" appears in the vault only as an engineering word travelling with the branch name `feat/permits-plans-project-artifacts` and the code symbol `packages/shared/src/constants/project-artifacts.ts` — see this register's own 2026-09-08 entries and [../decisions/2026-09-08-artifact-due-date-seeded-from-first-job-day.md](../decisions/2026-09-08-artifact-due-date-seeded-from-first-job-day.md):5-12, which records its own source as a **developer, not the client-side product owner**, and is `status: reference` for exactly that reason. Every user-story source names the surface differently: [project-module/05-create-and-track-permits.md](project-module/05-create-and-track-permits.md):19, :32 (*"Permits tab"*), [project-module/04-create-and-approve-lift-plans.md](project-module/04-create-and-approve-lift-plans.md):19, :54 (*"Plans tab"*), and the client's own voice on tape says *"permit tracker"* ([../meetings/transcripts/2026-07-29-erp-review-dispatch-das-update.md](../meetings/transcripts/2026-07-29-erp-review-dispatch-das-update.md):82). **"Document" does have client-facing usage**, but for the *quotation-side configuration panel*, not the tracker: same transcript :78, ehtesham.anwar @ 12:32 to Brian Petros — *"We have a checklist within the quotation where we can see what are the **documents** that are going to be required, lift plan, site plan, travel plan, FAA permit… we have added that in the **document section**"* — and the client punch list [../quotations/quotations.md](../quotations/quotations.md):34, *"documents checklist"*. **No `decisions/` note and no gaps entry anywhere asks what to call this surface.**
- **Note:** the vault's one worked precedent for a naming question splits ownership explicitly — [../assets/gaps.md](../assets/gaps.md) → *Nomenclature for the template level* — **"Owner: CodingCops for the model names; TCG (Brian Petros / Dylan Masterson) for the UI word."** By that precedent the UI word here is TCG's, not engineering's, however sensible the change reads. Note also that the **one rename TCG actually asked for on this surface is still undone**: [../erp-review-log.md](../erp-review-log.md):136 (item 22, Melissa, 2026-05-02) — *"Rename 'plan' to 'lift plan'."*
- **Blocked:** nothing — the change is label-only and reversible. Recorded so the word is adjudicated once rather than re-litigated per PR.
- **Owner:** TCG for the UI word — Brian Petros, with Melissa McNutt (she owns the outstanding plan → lift plan rename).

## How many files may a permit application, an approved permit, or an approved plan carry?

- **Status:** open
- **Asked:** 2026-09-09 — PR review of `fix/quotation-permits-plans`, commit `7083fb854`.
- **Question:** three permits/plans modals (submit application, upload approved permit, upload approved plan) and the quotation send-modal's plan upload change from **single-file** (picking a new file replaces the previous one) to **multi-file** (add several, remove each individually). Nothing written states a cardinality for any of them. Should each of these three slots hold one file or many — and are the three the same answer?
- **Sources checked:** **No source states a file count for a permit, plan, application or approved document.** [project-module/05-create-and-track-permits.md](project-module/05-create-and-track-permits.md):22, :25, :35 — *"uploads documents"*, *"uploads final permit"*, *"Supports attachments for application, final permit, and receipts"* — plural, three named slots, no count. [project-module/04-create-and-approve-lift-plans.md](project-module/04-create-and-approve-lift-plans.md):22, :37 — *"uploads attachments"*, *"Attachments support drag-and-drop uploads"*; its only cardinality lines (:44-45) are about **records**, not files. [../quotations/gaps.md](../quotations/gaps.md#does-uploading-a-plan-or-document-notify-the-customer-and-do-those-files-ride-the-docusign-envelope) — the adjacent open entry on the same uploads, whose FCC update records that a quote holds a **list of file rows** in *Maintain File Links*, each with its own `Include On Job` flag.
- **Note:** the practice evidence points **different ways for the three slots**, which is why one blanket answer may be wrong. A **submitted application** is plainly several files in practice — [../dispatch/travel-permits-playbook.md](../dispatch/travel-permits-playbook.md):271-273 records a real submission email with **two PDF attachments** (application + COI), and [city-permits/permit-acquisition-process.md](city-permits/permit-acquisition-process.md):47-48, :136-146 lists COI, credit-card authorisation, business licence, licence plate, Caltrans copy, hold-harmless and indemnification forms as per-city extras. The **approved permit that comes back** is described in the singular everywhere — travel-permits-playbook :172 *"Rename the uploaded permit file with the job number"*; ehtesham.anwar @ 33:45, [../meetings/transcripts/2026-06-18-dispatch-permits.md](../meetings/transcripts/2026-06-18-dispatch-permits.md):119 — *"they will have to upload the final permit"*. And a **lift plan** is delivered as **one bound PDF** of sectioned documents — [lift-plans/lift-plan-package-anatomy.md](lift-plans/lift-plan-package-anatomy.md):14-15, :32-33. So multi-file has real support for the application slot and cuts against how the record describes the other two.
- **Blocked:** nothing — the attachment API is already generic (`featureType` / `featureId` / `category`), so this is a UI cap being lifted, not a schema change. What is unanswered is whether an approved permit or plan holding several files should be possible at all, and whether a second upload means *replace* or *add*.
- **Owner:** Lisette Anzaldo (dispatch/permits) with Liz Lopez, who file the applications and receive the approvals.
- **Update 2026-09-14, branch `fix/das-permits-quotations` (no ticket), commits `fead099ca` / `f9ecdda4d`** — same three slots, different axis: **where** upload (and delete / expiry / multi-select) is allowed. Submit/Approve **modals** are now view/download only (`allowUpload={false}` `allowDelete={false}`); artifact **detail** edit keeps download + delete, and upload only while `editing`. No source states which surface may mutate attachments. Append here rather than a new entry — same files, same owners.

## PO exemption swaps the annual-vs-single axis for asset-vs-job — and "annual" stops being expressible

- **Status:** **partial** 2026-09-10 — **(a) fixed on the branch before commit**: `ASSET` was removed from `PO_EXEMPT_PERMIT_TYPES`; only `TRAVEL_ANNUAL_PURPLE_PERMIT` remains exempt (annual-vs-single). **(b) still open.** **Update 2026-09-11: (a) is now recorded as a decision**, not only a branch fix. Fouzan Shakil (CodingCops, `reference`) ruled that permit approval requires a linked PO, except `TRAVEL_ANNUAL_PURPLE_PERMIT`. That keeps the annual-vs-single axis of the 2026-06-18 decision. See [../decisions/2026-09-11-permit-approval-requires-linked-po.md](../decisions/2026-09-11-permit-approval-requires-linked-po.md). Brian Petros's confirmation of the approval gate itself is still wanted (see that note).
- **Asked:** 2026-09-10 — branch review of `fix/quotation-permits-plans` (uncommitted/staged). Raised by a developer against the diff, not by a ticket.
- **Question:** two, each one-line answerable. **(a)** Is a permit exempt from the purchase-order requirement because it is **associated with an asset**, or because it is an **annual** (already paid for the year)? An earlier draft of the branch had added the new generic `ASSET` type to `PO_EXEMPT_PERMIT_TYPES`; that was reverted so only `TRAVEL_ANNUAL_PURPLE_PERMIT` is exempt. `ASSET` remains the **only** type offered on Asset Management → New Permit (`apps/web/src/features/permits/lib/permit-type-options.ts`, `ASSET_PERMIT_TYPE_OPTIONS`), so every asset-scoped permit created through the UI is now PO-exempt regardless of whether it is an annual. A **single-job** city/transportation permit recorded against a crane would silently skip the PO gate at `apps/api/src/usecase/permits/permits.service.ts`:380, :511, :656, `apps/api/src/usecase/purchase-orders/purchase-orders.service.ts`:1136 and three web surfaces. **(b)** With `TRAVEL_ANNUAL_PURPLE_PERMIT` no longer offered on create, **is "annual" still a distinct thing the product must express** — and if so, on what field? There is no `isAnnual` flag on `model Permit` (`apps/api/prisma/schema.prisma` ~:2860-2895: `type`, `city`, `validFrom`/`validTill`, `assetId`/`jobId`/`vendorId` — nothing else); "annual" is carried **solely** by the type value that create no longer offers.
- **Sources checked:** **nothing states the asset-vs-job axis for POs; two named-human records state the annual-vs-single axis, and one of them says so in those words.** [../decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md](../decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md) (`status: reference`; **Brian Petros**, confirmed by **Melissa McNutt**, SCRUM-478) — *"The distinction is **annual vs single**, not travel vs non-travel"* (:71), with the table at :65-69 (annual → no PO, company absorbs; single-job city permit → PO, city as vendor) and the source turns at `../meetings/transcripts/2026-06-18-dispatch-permits.md`:40 (@13:04), :241 (@1:03:29 — *"I wouldn't do a purchase order for that one because I know I have an annual"*) and :249 (Melissa @1:07:08 — *"we don't bill the annuals to customers"*). [../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md](../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md) (`status: reference`, **Brian Petros**, 2026-09-05) re-states it at :160-166 and calls the existing travel exemption **over-broad** on exactly that axis; at :123-124 it records that *which* permit types need a PO **is** answered by the 2026-06-18 decision. The unverified write-up agrees: [../vendors-agencies/purchase-order.md](../vendors-agencies/purchase-order.md):97-109 / :198-216 (`status: unverified`) — PO when *"the job is in a city not covered by an annual permit"* or the crane is over 350 t; no PO *"using existing annual permits… Caltrans, LA City, LA County"*. **The asset-vs-job axis exists in the vault only as a linking decision that disclaims this exact scope**: [../decisions/2026-09-10-permit-association-scope-asset-job-vendor.md](../decisions/2026-09-10-permit-association-scope-asset-job-vendor.md) (`status: reference`; `decided_by` says *"Not a client-side product owner sign-off"*), *What this does not settle* — *"PO creation / Sub Hauler PO rules beyond storing the association."* Swept `meetings/transcripts/` (57 files), `meetings/summaries/`, `meetings/*.md`, `dispatch/travel-permits-playbook.md`, `city-permits/permit-acquisition-process.md` and `../vendors-agencies/purchase-orders-fcc/` on `purchase order` · `P.O.` · `purple` · `annual` · `single trip` · `exempt` · `Caltrans` · `sub hauler`: **no statement anywhere conditions a PO on whether the permit hangs off an asset or a job.** `travel-permits-playbook.md`:97 (`unverified`) says only *"Create a PO# against the job number"* with no annual/single condition, and :202 files *"whether the permit PO is what bills the permit cost to the customer"* under *Open — do not infer*. `purchase-orders-fcc/po-001-pre-job-purchase-orders.md`:35, :60 draws a **third** axis (pre-job timing), already flagged as conflicting in its own frontmatter. Jira was **not** checked — no Jira MCP tool is available in this session.
- **Note:** the annual-vs-single and asset-vs-job axes **correlate but are not the same set**, which is what makes the swap easy to miss. Annuals *are* held per crane — `../meetings/transcripts/2026-04-09` @ line 609/615/875 as quoted in [*Permit expiry reminders*](#permit-expiry-reminders--neither-90-nor-30-shipped) (*"we'll have to put all the annual permits… at the asset level"*) — so most asset-associated permits are annuals. But the converse fails in the case the record calls out explicitly: the **360-ton crane has no annual available** and *"every time we send this crane out, we have to get single… permits"* (`../meetings/transcripts/2026-06-18-dispatch-permits.md`:82; Kyle Harlow at :220 puts the boundary at *"350 and below… the 360 is a single trip machine"*). A per-trip permit for that crane is asset-associated and **must** carry a PO under the 2026-06-18 rule. **Two further observations on the branch itself, offered as facts, not adjudication:** (i) the exemption is **not internally consistent** — `ASSET_LEVEL_CITY_AGENCY_PERMITS` maps to `'ASSET'` in the new `PERMIT_TYPE_ASSOCIATION` (`packages/shared/src/constants/permit-association.ts`) yet is **not** in `PO_EXEMPT_PERMIT_TYPES`, so asset-association already does not imply exemption inside the same commit; (ii) the doc comment directly above `PO_EXEMPT_PERMIT_TYPES` still reads *"The line is **annual vs single-job**, not travel vs non-travel"* and cites the 2026-06-18 decision, while the array beneath it now also exempts `ASSET`. Related to **(b)**: the duplicate guard at `permits.service.ts`:124-145 keys on `(assetId, type, city)` and reports itself as *"An active **annual** permit already exists…"*; collapsing every asset permit to one type value changes what that guard distinguishes. `scheduling/job-schedule-master-workbook.md`:99-101 (`unverified`) also needs annual-ness as an input — *"ANNUAL ACTIVE — 0 DAYS"* where an annual or fleet BLANKET already covers the crane on that date.
- **Related, already open — do not duplicate:** [*Permit↔PO reverse cascades incomplete*](#permitpo-reverse-cascades-incomplete) (PO cardinality and lifecycle) and [*Permit rules the E2E suite asserts with no written source — PR #488*](#permit-rules-the-e2e-suite-asserts-with-no-written-source--pr-488) items (a), (d) and (e). This entry is a **different** question from all of them: not *how many* POs or *when* they cascade, but **what makes a permit exempt at all**. Same pattern as the 2026-09-08 update on the reverse-cascades entry — code citing `2026-06-18-annual-permits-no-po-single-permits-need-po.md` for something that decision does not say.
- **Blocked:** **(b)** only — whether Asset Management → New Permit may offer only `ASSET` without an annual/single distinction, and the already-open correction of `TRAVEL_CITY_STREET_PERMIT`'s wrong exemption.
- **Owner:** **Brian Petros** — he stated the annual-vs-single rule on 2026-06-18, raises the permit POs, and authored the 2026-09-05 PO workflow — with **Liz Lopez** (PO process) and **Lisette Anzaldo** (dispatch/permits) on (b).

- **Update 2026-09-16 (Joe Schacatano, VP of Sales — a second TCG voice besides Brian).**
  - *"there should be a PO for anything or where there's associated costs that are tied to a job"* (20:57), and *"we should be able to do a PO for anything within a job"* (21:10).
  - A permit PO exists to tie the vendor's or the city's invoice to the job (18:24, 18:40).
  - A city paid directly is handled per permit, not as a standing account (20:33). The yearly case is *"if we're getting annual permits"* (20:38).
  - Through a third party, the third party invoices us quoting our PO. Paid directly, the city invoices us (21:38, 22:11).
  - **This fits (a)'s annual-vs-single axis:** a single permit tied to a job needs a PO. Joe did **not** say whether an annual permit, which is not tied to a job, gets one.
  - Ehtesham told him the PO *"becomes required when you upload the final permit"* (21:22), and Joe said *"Perfect"*. But the recorded rule puts the PO requirement at **approval** ([../decisions/2026-09-11-permit-approval-requires-linked-po.md](../decisions/2026-09-11-permit-approval-requires-linked-po.md)), and nobody checked which trigger the build uses.
  - (b) is unchanged.

  Source: [../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md](../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md) §6, §8.

## Branch fix/das-fixes — permit-type remap, job-only Track Permits, projects list as a table

- **Status:** open, for (c) and one residual of (a) only. (a) and (b) were resolved 2026-09-11; see the next bullet. **(b) was superseded 2026-10-29:** Track Permits now lists every permit, and asset- and vendor-linked permits get status actions. See [decisions/2026-10-29-all-permits-create-permit-modal.md](../decisions/2026-10-29-all-permits-create-permit-modal.md) (Syed Haris, TCG-132 Q2, `reference`). The Sub Hauler filter observation is resolved with it.
- **Resolved in part 2026-09-11, by Fouzan Shakil (CodingCops, `reference`, not a TCG sign-off):**
  - **(a).** Settled by [../decisions/2026-09-11-legacy-po-and-permit-type-remap.md](../decisions/2026-09-11-legacy-po-and-permit-type-remap.md). Legacy `ASSET` / `PERMIT` / `VENDOR` rows are remapped by the association each row actually holds, not by the legacy label:
    - asset → `ASSET_LEVEL_CITY_AGENCY_PERMITS`
    - job → `TRAVEL_CITY_STREET_PERMIT`
    - vendor → `SUB_HAULER`

    The migration is edited in place. A legacy annual recorded as `ASSET` therefore becomes `ASSET_LEVEL_CITY_AGENCY_PERMITS`, as decided.
  - **(b), for the interim.** Settled by [../decisions/2026-09-11-track-permits-job-only-until-sept-15.md](../decisions/2026-09-11-track-permits-job-only-until-sept-15.md). Track Permits stays job-only until after 15 Sep 2026. Existing asset- and vendor-linked permits get no status actions until the general-class work lands. This is a known, accepted gap, and the Sub Hauler filter observation falls inside it.
  - **Still open:**
    - (c).
    - Residual of (a): which type a legacy row gets when it holds **no** association, or **more than one**. No precedence was stated. The in-place edit chooses for `ASSET`-labelled rows: asset, then job, then vendor, and `ASSET_LEVEL_CITY_AGENCY_PERMITS` when the row holds none. That is an implementation choice, still to be confirmed.
- **Asked:** 2026-09-11 — PR review of branch `fix/das-fixes` (no ticket, no `.ai/aidlc/` folder); tcg-scrum escalation. Commits `da4551792` (migration `20260910180000_po_permit_type_status_correction`), `21a345f7e` (tracker), `d31c1db8d` (projects list).
- **Question:** three parts, each answerable in a line. **(a) Remapping the retired `ASSET` / `PERMIT` / `VENDOR` permit rows.** The 2026-09-10 decision says those three values are not valid permit types. It does not say what existing rows should become. The migration maps them as follows. `ASSET` with an asset becomes `ASSET_LEVEL_CITY_AGENCY_PERMITS`, never `TRAVEL_ANNUAL_PURPLE_PERMIT`, so an annual recorded this way stops reading as an annual. `ASSET` **without** an asset becomes `TRAVEL_CITY_STREET_PERMIT`: a job-scoped type on a row that had no asset, and possibly no job. `PERMIT` becomes `TRAVEL_CITY_STREET_PERMIT` (why Travel rather than FAA or Encroachment?). `VENDOR` becomes `SUB_HAULER`. Is this mapping right, or must those rows be reviewed by hand? **(b) Track Permits shows only permits that have a `jobId`.** The filter is in `permits.repository.ts` `findAllForTracker`, which also backs the tracker's All Permits tab. Should asset-level permits (the annuals TCG tracks per crane today) and vendor-scoped permits drop out of the tracker until general-class work lands? Note that the tracker's new type filter offers *Sub Hauler*, while the shipped association map scopes `SUB_HAULER` to a vendor (`packages/shared/src/constants/permit-association.ts`). A Sub Hauler permit that follows that map has no `jobId`, so it can never appear under that filter. **(c)** Should the projects list view be a paged table (the branch's `WorkspaceTable`) rather than cards?
- **Sources checked:** **(a)** [../decisions/2026-09-10-permit-create-types-mockup-document-types.md](../decisions/2026-09-10-permit-create-types-mockup-document-types.md) points 3–4 (`reference`) say the association is exactly one of asset/job/vendor and that the three fake values are invalid; it contains no remap. [../decisions/2026-09-10-permit-association-scope-asset-job-vendor.md](../decisions/2026-09-10-permit-association-scope-asset-job-vendor.md) (`superseded`) is where those values came from. Nothing anywhere in the vault covers remapping or backfill. **(b)** [../decisions/2026-09-11-permit-classes-job-only-until-sept-15.md](../decisions/2026-09-11-permit-classes-job-only-until-sept-15.md) points 2–4 (`reference`) limit **creation** to job-class permits and defer general-class handling. They say nothing about hiding existing non-job rows from the tracker. [../decisions/2026-09-11-quote-to-project-permits-plans-flow.md](../decisions/2026-09-11-quote-to-project-permits-plans-flow.md) point 5 says project-minted permits *appear* in the tracker, not that *only* those do. These sources pull the other way: [project-module/05-create-and-track-permits.md](project-module/05-create-and-track-permits.md) (`unverified`) :15 *"create and track permits for each asset"* and :37 *"All Permits table shows full permit tracking details"*; [city-permits/permit-tracker-workbook.md](city-permits/permit-tracker-workbook.md):15-16 (`unverified`), where TCG's current tracker is the system of record for annual and blanket travel permits held per crane; `../meetings/transcripts/2026-06-02-mobile-app-sales-dispatch.md`:405 (`reference`, Ehtesham Anwar), permit requests *"tracked from a permit tracker separately"*. [../decisions/2026-08-20-planning-tracker-archived-filter.md](../decisions/2026-08-20-planning-tracker-archived-filter.md):70-73 explicitly declines to set any rule for the Permits tracker. **(c)** [project-module/01-create-and-track-projects.md](project-module/01-create-and-track-projects.md) (`unverified`) :24 and :32 describe an *All Projects list* with search and status/date filters but no layout. [job-project-das.md](job-project-das.md):69, *"Remove card . grid view toggles"*, sits under the **DAS** heading (:63), not Projects. Jira not checked (no Jira MCP in this session).
- **Related, already open — do not duplicate:** [*PO exemption swaps the annual-vs-single axis…*](#po-exemption-swaps-the-annual-vs-single-axis-for-asset-vs-job--and-annual-stops-being-expressible) (b) asks whether "annual" is still expressible; (a) here is the data consequence. The PO half of the same branch (`CLOSED` treated as cancelled, and a closed PO hidden on the tracker card) is at [vendors-agencies/gaps.md → *Branch fix/das-fixes — one CLOSED status…*](../vendors-agencies/gaps.md#branch-fixdas-fixes--one-closed-status-for-invoiced-and-cancelled-pos-and-the-legacy-remap). This pointer is its only listing in this module.
- **Blocked:** running the permit-type migration on real data, because (a) rewrites rows irreversibly; the tracker scope in (b).
- **Owner:** Lisette Anzaldo (dispatch/permits) and Brian Petros for (a) and (b), with Ehtesham Anwar as author of the 2026-09-11 interim scope; product team for (c).

## Branch fix/das-fixes — the artifact's City becomes read-only and is driven by the Agency, on plans as well as permits

- **Status:** open
- **(c), (d) and (e), added 2026-09-11 — branch `fix/permits-pos` extends the same lock and removes two things around it.** Commit `f93caf721`, whose message reads *"Align permit location with vault"*; the vault says **auto-populate**, and says nothing at all about the other three changes, so that citation does not hold. **(c) State is now locked the same way.** `PermitPrimaryFields` computes `locationFromAgencyOnly = Boolean(form.agencyId) || cityDisabled` and, once an agency is picked, renders **both** State and City as `disabled readOnly` inputs placeholdered *"From agency"*, filled by `locationFromAgency(agency)` (`apps/web/src/features/agencies/lib/agency-location.ts`); the agency picker also stops filtering by city (`city` prop and *"No agencies available for the selected city"* both removed). **(d) The Area field is deleted** from permit create/edit and from the listing and detail columns (`permit-form-fields.tsx`, `permit-table-columns.tsx`, `permit-print-*`). **(e) `CreatePermitDto.city` becomes optional** — `@IsNotEmpty()` → `@IsOptional()`, `city!: string` → `city?: string | null` — and both State and City lose their `required` label marks. **Questions, each answerable in a line:** should **State** be derived-and-locked from the agency as well; is **Area** a field the product ever wanted (no vault file names one — point 7's *"city/area"* is a single phrase, not two fields); and may a permit now be **saved with no city at all**? **Sources checked:** the same two. Point 7 of [../decisions/2026-09-11-quote-to-project-permits-plans-flow.md](../decisions/2026-09-11-quote-to-project-permits-plans-flow.md) (`reference`) mentions neither State nor Area, and [../admin/gaps.md → *Branch fix/das-fixes — State beside City…*](../admin/gaps.md#branch-fixdas-fixes--state-beside-city-save-with-no-changes-back-in-multi-step-forms-leave-discards-the-draft-capped-percentages) (a) already records that **nothing** covers adding State where City stands alone — that entry asked whether State should be *there*; this asks whether it should be *editable*. On (e) the counter-pressure is the same lead-time machinery: `scheduling/dispatch-scheduling-path.md`:24-26 (`unverified`), *"First identify the permitting city and its required lead time"*, and `../dispatch/travel-permits-playbook.md`:107 (`unverified`), *"ALL PERMITS NEED TO HAVE CITY ATTACHMENTS/CONDITIONS TO BE A VALID"* — a permit with no city is a permit the Green/Yellow/Red path cannot score. Jira not checked (no Jira MCP in this session).
- **Asked:** 2026-09-11 — PR review of branch `fix/das-fixes` (no ticket, no `.ai/aidlc/` folder); tcg-scrum escalation. Commit `e42293b29`. **Extended 2026-09-11** by the review of branch `fix/permits-pos` (also no ticket, no `.ai/aidlc/` folder).
- **Question:** two parts. **(a)** On a permit, is *City / area of travel* **derived from the selected agency and not editable**? The branch replaces the free field with a disabled input fed from `agency.city`, sets it on every agency change and **clears it when the agency is cleared** (`apps/web/src/features/permits-plans/components/artifact-detail.tsx`, `handleAgencyChange` / `agencyCityField`). **(b)** Should the same rule apply to a **plan**? The branch applies it to both artifact types.
- **Sources checked:** **(a) is half-sourced.** [../decisions/2026-09-11-quote-to-project-permits-plans-flow.md](../decisions/2026-09-11-quote-to-project-permits-plans-flow.md) point 7 (`status: reference`, Ehtesham Anwar, binding on the CodingCops build through 15 Sep, not a TCG sign-off) says **for permits**: *"**Agency** and **city/area** auto-populate"*. Auto-populate is not the same claim as **derived and locked** — the same note's point 6 auto-populates a plan's due date and then says *"editable"*, and point 7 says *"due date same first-day seed, editable"*, so this note distinguishes the two and does not put City on the locked side. **(b) has no source at all.** Point 6, the plans clause, names only the assigned planner and the due date; no vault file says a plan has a city, still less that an agency supplies it. [project-module/05-create-and-track-permits.md](project-module/05-create-and-track-permits.md):34 (`unverified`) lists the permit form as *"auto-generated ID, asset, job link, type, agency, fees, and status"* — no city. Counter-pressure on locking it: the permitting **city** is the unit the whole lead-time machinery is keyed on ([*Artifact due date = the job's first scheduled day, with no permit lead time*](#artifact-due-date--the-jobs-first-scheduled-day-with-no-permit-lead-time) and `scheduling/dispatch-scheduling-path.md`:24-26, `unverified`, *"First identify the permitting city and its required lead time"*), and `city-permits/permit-acquisition-process.md`:87-117 (`unverified`) documents **stacked jurisdictions** — one move crossing several cities — which a single agency-derived, uneditable string cannot express. Jira not checked (no Jira MCP in this session).
- **Related, already open — do not duplicate:** [../admin/gaps.md → *Branch fix/das-fixes — State beside City…*](../admin/gaps.md#branch-fixdas-fixes--state-beside-city-save-with-no-changes-back-in-multi-step-forms-leave-discards-the-draft-capped-percentages) (a) asks the neighbouring question about the **State** select the same branch adds to these permit forms; if City is derived from the agency, whether State should be too is part of that answer.
- **Blocked:** nothing hard, but an agency whose `city` is blank or wrong now silently produces a blank or wrong permit city with no way to correct it in the form, and any permit whose city differs from its agency's registered city can no longer be recorded.
- **Owner:** Lisette Anzaldo (permits/dispatch) with Ehtesham Anwar, as author of the 2026-09-11 auto-populate lock, for whether *auto-populate* was meant to mean *locked*.

## Branch fix/permits-pos — Plan notes beside crew comments, a Lift Plan Package upload category, OPEN drawn grey, and shared `/permits/{code}` · `/plan/{code}` detail routes

- **Status:** open
- **Asked:** 2026-09-11 — PR review of branch `fix/permits-pos` (no ticket); tcg-scrum escalation. Commits `81c42f245`, `dd184508c`, `6adee0459`. Author: Fouzan Shakil. Loop trail: `aidlc/processed.log` Path C row for `fix/permits-pos`.
- **What changed (code):** (a) `Plan.notes` TEXT column + form Notes (migration `20260911133000_add_plan_notes`), distinct from `crewComments`. (b) `ATTACHMENT_CATEGORY.LIFT_PLAN_PACKAGE` on the lift artifact form. (c) `ArtifactStatusPill` OPEN `warning`→`neutral` (grey) + DAS legend artifact section. (d) Shared detail at `/permits/{code}` and `/plan/{code}`; project nested pages become `router.replace` redirects; DAS/checklist/tracker links use `buildArtifactLinkUrl`. Separately: agency State/City lock + Area UI removal is on the entry above; the DAS **PO#** checklist rewrite (review **do not ship** blocker) is [../dispatch/gaps.md → *Branch fix/permits-pos — PO# row…*](../dispatch/gaps.md#branch-fixpermits-pos--the-das-pre-checklist-po-row-stops-watching-vendor-allocations-and-can-no-longer-flag-anything).
- **Question:** four parts, each answerable in a line. **(a) A plan now has three separate places to write prose.** `81c42f245` adds `Plan.notes` (migration `20260911133000_add_plan_notes`, `schema.prisma`, `UpdatePlanDto`) as the artifact form's **Notes** field, and keeps the existing `crewComments` for the **Upload Approved Plan** modal. With the plan-detail comment thread that [../decisions/2026-08-12-plan-comments-page-scope.md](../decisions/2026-08-12-plan-comments-page-scope.md) already scopes, that is three surfaces. Are *notes*, *crew comments* and *comments* three things a user distinguishes, or one thing entered in three places? **(b)** Is `LIFT_PLAN_PACKAGE` a **distinct attachment category** from the Final Plan, as the lift-plan form's upload now treats it (`packages/shared/src/constants/project-artifacts.ts`)? **(c)** Should trackable **`OPEN` be drawn grey rather than amber**, on `ArtifactStatusPill`, the DAS legend, the minting progress modal, the PO badges and both trackers (`dd184508c`)? **(d)** Should permits and plans open on **shared, code-addressed detail routes** — `/permits/{code}` and `/plan/{code}` — with the project-nested pages reduced to client-side `router.replace` redirects and DAS / checklist / tracker deep links repointed off the job tab's `?code=` (`6adee0459`)?
- **Sources checked:** **(a) nothing distinguishes them.** `project-module/04-create-and-approve-lift-plans.md` (`unverified`) is the only plan-form source and its field list — *"crane details, load information, site conditions, safety details, and uploads attachments"* (:20), acceptance criteria :33-37 — contains no notes field; the word *comments* appears there only as the **approval** verb (*"sends it back with comments for changes"*, :26, :40, :61, :76). `project-module/05-create-and-track-permits.md`:22 does list *"asset, agency, fees, **notes**"* — but for a **permit**, not a plan. [../decisions/2026-08-12-plan-comments-page-scope.md](../decisions/2026-08-12-plan-comments-page-scope.md) (`status: verified`, Syed Haris, SCRUM-757) settles only *which screen* the comment thread is, not what a second or third prose field on it would mean. **(b) the noun is sourced, the field is not.** `lift-plans/lift-plan-package-anatomy.md` and `lift-plans/lift-plan-request-and-3d-lift-plan.md`:42-45 (both `unverified`) establish that a lift plan **is** a bound multi-source package with priced Standard / Premium / P.E.-stamp tiers — so the concept is real. No vault file names an attachment *category* on a plan at all; the only attachment taxonomy written anywhere is on the permit side, `05-create-and-track-permits.md`:35 (`unverified`), *"Supports attachments for application, final permit, and receipts"*. **(c) no vault file states any trackable-status colour.** Grepped every non-transcript file on `colour` · `color` · `grey` · `gray` · `amber` · `legend` · `status pill`. The DAS spec's only colour rule is for the pre-checklist itself — `../dispatch/daily-allocation-system.md`:90 (`unverified`), *"green if complete, red if missing"* — a different surface, and it names no third state. The one app-wide statement about a status pill is `../customers/customer.md`:25 (`unverified`, Mohsin punch list, SCRUM-652): *"In status column Inactive pill color should be red instead of grey **(across the app)**"* — a different status, and it pushes **away** from grey rather than toward it. `../dispatch/crane-configurations.md`:87 gives Grey a meaning in Lisette's dispatch-sheet legend (*"Ticket sent"*), which is a fourth vocabulary on a spreadsheet, not the ERP. **(d) no vault file specifies a URL shape for either artifact — and the one route the vault does name is the one this commit retires.** [../decisions/2026-08-12-plan-comments-page-scope.md](../decisions/2026-08-12-plan-comments-page-scope.md) — the **only `status: verified` note in `decisions/`** — fixes SCRUM-757's *"Plan Comments page"* to *"the plan detail view at the route `/projects/{id}/plans/{id}`"* and scopes every other requirement in that spec to it; that path is now a redirect to `/plan/{planId}`. The decision identified a **screen**, not a URL, so it is not contradicted outright — but its citation is stale and SCRUM-757's scoping now points at a wrapper. [../decisions/2026-09-10-permit-association-scope-asset-job-vendor.md](../decisions/2026-09-10-permit-association-scope-asset-job-vendor.md):40 (`superseded`) is the only other route ever written down (`/permits/create`). The two post-save navigation notes ([2026-09-01](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md), [2026-08-20](../decisions/2026-08-20-post-save-navigation-convention.md), both `reference`, Fouzan Shakil) require that create and edit land on *"the entity's detail page"* — which an artifact having **one** detail page serves well, and is the nearest thing to support this change has. Jira not checked (no Jira MCP in this session).
- **Note, offered as facts and not adjudication.** On (c), `isRequired` and colour are the only signals the DAS legend carries, so a grey `OPEN` reads as *inactive* on a board whose other greys mean unavailable or in-maintenance (`../dispatch/daily-allocation-system.md`:47, :76, :80). On (d), the two new routes disagree with each other — `/permits/{code}` plural, `/plan/{code}` singular — and the redirect is a client-side `useEffect` + `router.replace`, so an external deep link to the old path renders an empty page for a frame before moving. Neither is a product question; both are worth fixing before merge.
- **Related, already open — do not duplicate:** [../dispatch/gaps.md → *Branch fix/das-fixes — pre-checklist plan / permit / PO links open in a new browser tab*](../dispatch/gaps.md#branch-fixdas-fixes--pre-checklist-plan--permit--po-links-open-in-a-new-browser-tab) asks where those same links **land**; (d) changes what they land **on**. [*`OPEN` as the starting trackable status…*](#open-as-the-starting-trackable-status-and-the-retirement-of-approved_by_others) settles the enum's members, not their presentation.
- **Update 2026-09-14, branch `fix/das-permits-quotations` (no ticket)** — two further answers in code to (c) and (d), still unsourced:
  - **(c)** Commit `a72e38be8` **omits the Open status pill** on the create/ready progress modal (minted rows always start Open, so the pill was noise). Commit `f6192f836` **removes `ArtifactTrackableStatusKey`** from Configuration Details and that same minting modal, leaving the status key **only on the DAS legend**. Neither exclusivity nor "hide Open on mint" is written anywhere; both deepen the investment in an OPEN presentation nobody has adjudicated.
  - **(d)** Commits `745390b56` + `permits-plans-tab-url.ts` add `?from=job|project&project=&job=` return context so Back/Close from `/permits/{code}` · `/plan/{code}` returns to the originating Permits / Plans tab. Post-save navigation notes decide Save destinations only; Back/Close is unset. Builds further on the unresolved shared-route shape.

## Branch fix/12-sep-uat — permit/plan detail Cancel/Save above combobox portals

- **Status:** open
- **Asked:** 2026-09-12 — PR review Path C branch `fix/12-sep-uat` (no ticket); tcg-scrum escalation. **Reaffirmed 2026-09-14** on `fix/das-permits-quotations` (`f9ecdda4d`) — same stacking kept; still no product source.
- **Question:** on shared permit/plan **detail** forms, must **Cancel** and **Save** stay **clickable above** Radix/shadcn **combobox dropdown portals** (e.g. elevated `z-index`), while **flow dialogs** (upload/approve, etc.) remain **mounted**? One line: is this the intended stacking rule app-wide for artifact detail?
- **Sources checked:** [../decisions/2026-08-12-plan-comments-page-scope.md](../decisions/2026-08-12-plan-comments-page-scope.md) (`verified`, Syed Haris) — which **screen** hosts plan comments, not z-order. [daily-allocation-system.md](../dispatch/daily-allocation-system.md) pre-checklist (`unverified`) — completeness colours, not form chrome. `vault/decisions/`, permit/plan FRDs — **no z-index or portal rule**. Jira unavailable.
- **Blocked:** nothing hard — CSS-only. Recorded so an arbitrary `z-[600]` footer does not become convention without product ack.
- **Owner:** product team — Ryan Adams / Lisette Anzaldo for permit/plan edit surfaces.
- **Blocked:** nothing hard — all four are reversible. Recorded so that merging them does not turn them into convention, and because (a) puts a new column in the database on no written requirement.
- **Owner:** product team. Ryan Adams / Joe Schacatano for (a) and (b), since sales own the lift-plan request and the package tiers; Lisette Anzaldo for (c), as the DAS user who reads the legend; Fouzan Shakil for (d), as the internal owner of the navigation conventions the two post-save notes set.

## Branch fix/uat4-schedule-copy-allocation — Job Schedule weekend toggles follow the date range, on saved schedules too

- **Status:** open (residual only) — (a) and (b) resolved 2026-09-12, see [decisions/2026-09-12-job-schedule-weekend-toggles-follow-the-date-range.md](../decisions/2026-09-12-job-schedule-weekend-toggles-follow-the-date-range.md). Decided by Ehtesham Anwar (CodingCops), relayed by Syed Haris; `status: reference`, not TCG-confirmed. **(c) stays open** — see the residual line at the end of this entry.
- **Asked:** 2026-09-12 — PR #537 review (branch `fix/uat4-schedule-copy-allocation`, no ticket; `aidlc/processed.log` Path C row dated 2026-09-12, line 92); tcg-scrum escalation. Commits `3879e7727` (*schedule weekend toggles follow the date range; clearable dates reset them*) and `260f679cc` (*saved schedules open with the weekend rows their range implies*). Author: Syed Haris. The rule came from the developer during the UAT-4 session, not from a written source.
- **What changed (code, not product intent):** `resolveWeekendToggles` in `apps/web/src/features/projects/jobs/job-details/schedule/utils/schedule-date-range.ts` used to switch Include Saturdays / Include Sundays on only when the range was **all weekend** (`weekendOnlyRange`) — a rule that lived in a code comment and nowhere in the vault. It now switches each toggle on whenever the range **contains** that day (`weekendDaysInRange`), clears both when either date is cleared, and `use-schedule.ts` applies the same derivation to a **saved** schedule on load (weekend-only additions, never a regeneration). Consequence: a job saved with weekends deliberately off reopens with the weekend rows showing and the toggles on, unsaved until Save Schedule. The API's own conversion path still creates the schedule weekday-only with both flags `false` (`apps/api/src/usecase/projects/projects.service.ts:433-437`), and `qa-automation/e2e/specs/projects/1-lifecycle.spec.ts:410-424` asserts exactly that for a 10-day window spanning a weekend — evidence that someone previously treated weekday-only as the default. That assertion now contradicts the web on load.
- **Question:** three, each answerable in a line. **(a)** When a date range is picked, should Include Saturdays / Include Sundays default **off** (weekday-only; dispatcher opts weekends in), **on whenever the range contains that day** (as the branch now does), or **on always**? **(b)** When a **saved** schedule is reopened, should the toggles show **what was saved**, or be **re-derived from the range** so weekend rows reappear even where a dispatcher switched them off on purpose? **(c)** Should the API's convert-from-quotation default (`includeSaturdays: false`, weekday intervals only) and the web's on-load rule agree, and if so which one wins?
- **Sources checked:** **nothing states a default, and nothing states a reopen rule.** [project-module/03-create-manage-job-schedule.md](project-module/03-create-manage-job-schedule.md):24, :35 (`unverified`, 2026-04-30, the only in-product schedule spec — SCRUM-234): *"Chooses whether to include Saturdays and Sundays"* / *"User can choose to include or exclude Saturdays and Sundays before generating the schedule"* — a choice, no default, no reopen behaviour. [scheduling/ready-to-schedule.md](scheduling/ready-to-schedule.md):147 restates it. [../decisions/2026-08-28-job-schedule-weekend-empty-state.md](../decisions/2026-08-28-job-schedule-weekend-empty-state.md) (assignee-level, Fouzan Shakil) settles only the empty-state copy when the toggles exclude every day; it presupposes a saved range can sit with a toggle off (*"…and Include Saturdays is off"* in read-only mode), which is the state (b) now overrides on load, but it states no default. [*Job Schedule tab — what to show when the date range yields zero days*](#job-schedule-tab--what-to-show-when-the-date-range-yields-zero-days) — resolved, different question. `meetings/transcripts/2026-04-07-dispatch-scheduling-figma-demo.md:118`, `ehtesham.anwar` 23:26 — *"There's a quick selection up top to **exclude** all of the weekends"* — subtractive framing (weekends present unless excluded), **no TCG response**; Ryan Adams at :133 (26:44) names *"include Saturday, include Sunday"* only as an analogy for a 24-hour-shift toggle. Every other dispatch/scheduling transcript (02-27, 03-31, 04-02, 04-09, 05-14, 06-02, 06-17, 06-18, 07-02, 07-07), `meetings/summaries/`, `erp-review-log.md`, `scheduling/job-schedule-master-workbook.md`, `scheduling/dispatch-scheduling-path.md`, `../dispatch/dispatch-value-engine-and-playbooks.md`, `../dispatch/confirmations-playbook.md`: weekend hits are payroll, permit-clock or greeting mentions only. **Legacy precedent, fact not decision:** FCC's job carries a single `Work Weekends` flag, **on by default** on a blank job ([../dispatch/fcc-nexgen-dispatch-guide.md](../dispatch/fcc-nexgen-dispatch-guide.md):149-152, :589), and `payroll/tcg-rawfms-staging-database/sql/rpt.v_Base_JobMaster.VIEW.sql:44` labels it `'Authorized'` / `'Weekdays Only'` — a job-level bit, not a per-day toggle, and neither guide says whether TCG ever changed the default. Jira not checked (no Jira MCP in this session).
- **Related, already open — do not duplicate:** [*Converted-quotation schedule days — checked by default, and what that puts on the DAS board*](#converted-quotation-schedule-days--checked-by-default-and-what-that-puts-on-the-das-board) is the same "what does a converted job's schedule open with" axis for the **per-day checkbox**; (c) above is its weekend-toggle twin and should be asked in the same breath.
- **Blocked:** nothing hard — reversible, display-side until Save. Recorded so merging does not turn a UAT remark into the default, because `1-lifecycle.spec.ts` will assert the opposite of the web once a saved converted job is reopened, and because a saved-off toggle silently re-deriving on is a data-loss shape a dispatcher will report as a bug.
- **Owner:** Lisette Anzaldo (the dispatcher whose schedule it is) / Ryan Adams. Product team.
- **Residual (c), open 2026-09-12:** the API conversion path (`apps/api/src/usecase/projects/projects.service.ts` ~433-437) still creates a converted job's schedule weekday-only with `includeSaturdays: false` / `includeSundays: false`, so a converted job's **saved** state and the web's **on-open** state (per (a)/(b)) disagree until Save Schedule. Not stated as decided. **Owner:** Ehtesham Anwar — to confirm whether conversion should also create weekend intervals, and whether that is his call or the client's. Ask in the same breath as [*Converted-quotation schedule days…*](#converted-quotation-schedule-days--checked-by-default-and-what-that-puts-on-the-das-board).

## Branch fix/uat4-schedule-copy-allocation — job Resources tab hides rows the quotation never priced — see dispatch/gaps.md

- **Status:** open (residual only) — partially resolved 2026-09-12, see [decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md](../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md). Decided by Syed Haris (CodingCops developer); `status: reference`, not TCG-confirmed. Settled: this module's half — the tab mirrors the **quotation's priced lines** — and the *Optional* case of the dispatch entry's (a). Still open, on the dispatch entry's residual line: (a) for an association added to the catalog after the quote was built or at a depth the quotation never persists (both still materialise as Always Included rows), and post-conversion resync.
- **Asked:** 2026-09-12 — PR #537 (`aidlc/processed.log` Path C row, line 92), commit `c6716980d`. Pointer only: the product question is what a DAS slot is and where it comes from, so the full entry is [../dispatch/gaps.md → *Branch fix/uat4-schedule-copy-allocation — a DAS slot the quotation never priced*](../dispatch/gaps.md#branch-fixuat4-schedule-copy-allocation--a-das-slot-the-quotation-never-priced-the-job-resources-tab-now-hides-materialised-0-rows-the-board-still-allocates-against-them).
- **Question (this module's half):** is the job's read-only Resources tab a mirror of the **quotation's priced lines** (as the branch now renders it), or the job's **operational requirement set** including catalog-derived $0 slots (as `materializeAssociatedJobResources` and the shared `ResourcesTab` rendered it before)? [project-module/02-view-manage-job-details.md](project-module/02-view-manage-job-details.md):22, :48-50 (`unverified`) says the tab shows *"equipment and crew pulled from the quotation"* in a parent-child structure and that the dispatcher *"can assign a specific unit to a resource slot"* — it does not say whether a slot the quotation never carried belongs there.
- **Owner:** see the dispatch entry.

## Branch fix/das-permits-quotations — Job Schedule Cancel/Save sticky while scrolling days

- **Status:** open
- **Asked:** 2026-09-14 — PR review of Path C branch `fix/das-permits-quotations` (no ticket); tcg-scrum escalation. Commit `4d0b46fe4` (*keep schedule Cancel/Save sticky while scrolling days*). Author: Fouzan Shakil.
- **What changed (code, not product intent):** `JobScheduleTab` passes `headerClassName="sticky top-0 z-20"` into shared `SectionCard`, and sticky headers get an opaque `backgroundColor` under the tinted gradient so scrolled rows do not show through. Cancel/Save therefore stay on screen while the day list scrolls.
- **Question:** one line — on the job **Schedule** tab, must Cancel/Save stay **sticky** at the top of the card while the day rows scroll, or is a static header enough?
- **Sources checked:** **nothing on sticky / scroll chrome for Schedule.** [project-module/03-create-manage-job-schedule.md](project-module/03-create-manage-job-schedule.md) (`unverified`, SCRUM-234) — row generation and *"Saving the schedule shows a success message"*, no button placement. Grepped `dispatch/`, `projects-jobs/`, `decisions/` on `sticky` · `scroll` — no on-point hit. Sibling chrome question already open: [*Branch fix/12-sep-uat — permit/plan detail Cancel/Save above combobox portals*](#branch-fix12-sep-uat--permitplan-detail-cancelsave-above-combobox-portals) (stacking, not stickiness).
- **Related, already open — do not duplicate:** the 12-sep-uat Cancel/Save entry above is the same chrome class on artifact detail (z-order vs portals), not Schedule stickiness — keep them separate.
- **Blocked:** nothing hard — CSS-only and reversible. Recorded so sticky schedule chrome does not become convention without product ack.
- **Owner:** Lisette Anzaldo (the dispatcher whose schedule it is) / Ryan Adams.

## Permit Cost vs PO Fee — UAT says keep them separate, an untraced row says auto-populate, and approval already overwrites the fee

- **Status:** resolved 2026-10-08 — see [decisions/2026-10-08-po-fee-typed-by-user-approval-leaves-po-alone.md](../decisions/2026-10-08-po-fee-typed-by-user-approval-leaves-po-alone.md). Decided by Syed Haris (CodingCops developer, TCG-89); `status: reference`, not TCG-confirmed — Liz Lopez / Brian Petros can overrule.
- **Update 2026-10-08:** two independent amounts. PO Fee is typed by the user; permit approval no longer writes it (it used to replace it with Σ serviceFee + permitCost over the covered permits), so the approval-time overwrite was a defect and is removed on branch `fix/8-oct`. Nothing copies Permit Cost into PO Fee or back, so the untraced *"Auto-populate permit cost from the linked PO"* row is not built. Consistent with UAT 4 #30 (*"leave it as a separate field"*) and the 2026-03-26 sync ([../meetings/transcripts/2026-03-26-tcg-cc-product-sync-demo.md](../meetings/transcripts/2026-03-26-tcg-cc-product-sync-demo.md):203-204). Goes against [../vendors-agencies/purchase-order.md](../vendors-agencies/purchase-order.md):283-288 (`unverified`, Step 6 *"System automatically updates the PO with the final permit cost"*). Approval also leaves a `CLOSED` PO untouched. Not settled: the create-time PO Fee default (das-fixes part (e) in [../vendors-agencies/gaps.md](../vendors-agencies/gaps.md#branch-fixdas-fixes--one-closed-status-for-invoiced-and-cancelled-pos-and-the-legacy-remap)).
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register into the module registers. Not a ticket question: no SCRUM ticket carries it, and the register's own row records the ask as *"To be discussed"*.
- **Question:** is **Permit Cost** on a permit the same figure as the **PO Fee** on its linked PO — one amount shown in two places — or two independent amounts? If they are coupled, which direction is authoritative: does approving a permit write the PO's fee, or does the linked PO populate the permit's cost?
- **Sources checked:**
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → NOT DONE *Permit Cost should equal the PO Fee*, [UAT 4 #30]. The session sheet's words: *"Permit Cost should be the same as the PO Fee. For now, leave it as a separate field."* The register's comment: *"Decide whether approving a permit should write the PO fee at all before anything more is built here."*
  - **Pulling the other way, same register:** NOT DONE *Auto-populate permit cost from the linked PO* — **no Src.** It is one of the **27 rows the register could not trace to any session**, and the register says nobody should act on one *"until its origin is confirmed"*. Its own comment: *"Both cannot be built — product decision needed."*
  - **And already coupled in one direction, in shipped code:** the register's audit finding, listed under Not Done, that **approving a permit overwrites the linked PO's fee**. So the two are separate fields on the form and joined in the approval path.
  - [../decisions/](../decisions/) — **nothing relates the two figures.** Nearest fragments: [2026-09-11-quote-to-project-permits-plans-flow.md](../decisions/2026-09-11-quote-to-project-permits-plans-flow.md) *Permit status path* item 13 (*"Upload approved permit … permit cost, application number, date received"*) and [2026-09-15-agency-creation-form-final-fields.md](../decisions/2026-09-15-agency-creation-form-final-fields.md) row 17 *Avg Permit Cost*. [2026-09-11-permit-approval-requires-linked-po.md](../decisions/2026-09-11-permit-approval-requires-linked-po.md) makes a linked PO a **precondition** of approval but says nothing about money moving between them.
  - `PO fee` appears **once** in the whole vault, and as unspecified: [../vendors-agencies/gaps.md → *PO and vendor/agency rules the E2E suite asserts with no written source — PR #488*](../vendors-agencies/gaps.md#po-and-vendoragency-rules-the-e2e-suite-asserts-with-no-written-source--pr-488) — *"The `area`, `city`, `PO fee`, `discount %` and `invoice #` fields now built and mocked up. **Still unspecified.**"*
  - [../dispatch/travel-permits-playbook.md](../dispatch/travel-permits-playbook.md):202 files *"Whether the permit PO is what bills the permit cost to the customer"* under its own open-questions list — i.e. the closest written thing to this question is itself recorded as open.
- **Note:** a UAT row is an ask, not product intent — [../uat/INDEX.md](../uat/INDEX.md). Three artefacts point three ways (keep separate / auto-populate / already overwritten on approval) and one of the three has no traceable author, so recency and count both mislead here.
- **Blocked:** any further permit-cost or PO-fee work; whether the approval-time overwrite is a defect or the intended behaviour.
- **Owner:** Liz Lopez (the permit-driven PO process) with Brian Petros. Whoever raised UAT 4 #30 needs to say which of the two rows they meant.
- **Pointer:** [../vendors-agencies/gaps.md](../vendors-agencies/gaps.md) → *Permit Cost vs PO Fee — pointer, owned by projects-jobs*.

## Live update scope and freshness across DAS, Schedule tab and Yard Operations — pointer, owned by dispatch

- **Status:** open — **answer owned by dispatch**, per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*.
- **Asked:** 2026-09-22 — reviewing branch `fix/tcg-91-das-live-update` (TCG-91).
- **Why it lands here too:** the two acceptance criteria that source it are this module's —
  [project-module/02-view-manage-job-details.md](project-module/02-view-manage-job-details.md):63
  (*"reflected in real time across all views (DAS, Schedule tab, Dylan's loadout view)"*) and
  [project-module/03-create-manage-job-schedule.md](project-module/03-create-manage-job-schedule.md):44
  (*"The Schedule tab inside the job always shows the latest real-time view"*). Both `unverified`.
  They name **screens**; whether an already-open allocation panel counts as a "view" is unwritten.
- **Read:** [../dispatch/gaps.md](../dispatch/gaps.md) → *Live update scope and freshness — "real time across all views" names screens, not panels, and sets no bound*

## Job Schedule "Copy to all days" — replaces Apply Times, and which rows it overwrites

- **Status:** open
- **Asked:** 2026-10-01 — PR review of tcg branch `feat/schedule-datetime-holdover` (not merged);
  built at syed.haris's request.
- **Question:** The "Apply times to multiple days" panel is removed. The first row has a **Copy
  to all days** button (shown in edit mode once that day has a time) that copies its Start, On
  Site and Estimated End — and its second shift — onto **every other row that is not cancelled
  or ticket-sent, unticked rows included**, keeping each shift's length (the end the same number
  of days after the row's date). It never removes a second shift a row already has, and it does
  not ask before overwriting. UAT disagrees on the panel: UAT 4 #26 asked for it closed by
  default, UAT 1 asked for the collapse removed ([../uat/register-2026-09-18.md](../uat/register-2026-09-18.md)
  lines 114 and 216; the register says someone should confirm which wins) — this build takes
  UAT 1's side. The old panel could also apply to *selected* days only. Should Copy skip unticked
  rows, offer "selected days only", or confirm first? What an unticked row means is open in
  [*Schedule day deactivate orphans SubJob / allocations*](#schedule-day-deactivate-orphans-subjob--allocations).
- **Built default:** as above.
  - **Note 2026-10-06 (tcg branch `feat/yard-holdover-loadout`, fix pass commit
    `6a254ffbf`, not merged):** "as above" is accurate again on this branch. Copy writes the times and leaves each
    row's tick as it was (`patchShift(..., { tickOnTime: false })` in
    `apps/web/src/features/projects/jobs/job-details/schedule/utils/schedule-shift-patch.ts`, called
    from `job-schedule-tab.tsx` → `handleCopyToAll`). The note in
    [*Schedule tab — what unticks a day…*](#schedule-tab--what-unticks-a-day-and-should-a-day-with-times-always-be-worked)
    that said otherwise no longer applies.
- **Owner:** Lisette Anzaldo (dispatch).

## Schedule tab — what unticks a day, and should a day with times always be worked?

- **Status:** open
- **Asked:** 2026-10-06 — Fouzan Shakil (fouzan.shakil, CodingCops) reported, in a Claude Code
  session, that a converted quotation's schedule days vanished after the dates were changed and
  times were saved. Investigated and fixed on tcg branch `feat/yard-holdover-loadout` (not merged).
  The date-range half of the report was ruled on the same day:
  [decisions/2026-10-06-quotation-dates-are-schedule-placeholders.md](../decisions/2026-10-06-quotation-dates-are-schedule-placeholders.md)
  (`reference`, CodingCops, not TCG-confirmed). This entry is the half nobody ruled on.
- **What the data showed (local dev DB, read-only, 2026-10-06):** JOB-00045 (Oct 22–24),
  JOB-00049 (Dec 8–10) and JOB-00051 (Jan 1–3 2027), created 2026-10-01 (UTC) and then given new
  dates, had **every** schedule day saved **inactive** (unticked).
  - JOB-00049's days were first saved with **no times**. Only an unticked day can be saved that
    way, because a ticked day requires times. They were given times later.
  - JOB-00051 was saved with times and every day unticked, in one save.
  - JOB-00045 had one save with **zero days**.
  - View mode lists only ticked days (`visibleEntries`,
    `apps/web/src/features/projects/jobs/job-details/schedule/components/schedule-table-section.tsx:79`),
    so on all three jobs the days "vanished".
  - JOB-00046, JOB-00047 and JOB-00050 moved their dates and saved ticked days correctly.
  - **The data does not show which control unticked the days.**
- **Question:** four, each answerable in a line.
  1. **Is a day with times always a working day?** Should giving a day a time tick it (as the
     branch now builds), or may a dispatcher keep times on a day that is not worked?
  2. **What unticked the days on JOB-00045/49/51?** The candidates in the tab are the header
     select-all checkbox, the **Clear selection** button and the row checkboxes. A reopened saved
     schedule also adds weekend rows unticked
     ([decisions/2026-09-12-job-schedule-weekend-toggles-follow-the-date-range.md](../decisions/2026-09-12-job-schedule-weekend-toggles-follow-the-date-range.md)
     (b)), but that cannot untick a weekday, and JOB-00049's Dec 8–10 is Tue–Thu. Whoever made those
     saves would have to say.
  3. **Should "Clear selection" and "Remove days" be renamed or reworked?** Both act on the ticked
     days (`schedule-table-section.tsx:161-176`). A ticked day *is* a working day: the same tab
     counts ticked days as *"Selected Working Days"* (:147) and shows *"No working days selected."*
     when there are none (:93). So "Clear selection" un-schedules every working day, and "Remove
     days" deletes every working day. "Selection" and "working day" are the same tick, and the
     button labels do not say so.
  4. **Should view mode show unticked days greyed out instead of hiding them?**
- **Built defaults (tcg branch `feat/yard-holdover-loadout`, committed 2026-10-06, not
  merged):**
  1. **Giving a day a time ticks it.** That covers Start, On Site and End, and **Copy to all
     days**, which goes through the same per-row update (`patchShift` in
     `apps/web/src/features/projects/jobs/job-details/schedule/hooks/use-schedule.ts`). Reason: an
     unticked day with times is saved as not worked and hidden in view mode, so times set on it
     looked saved and then vanished. Cancelled and ticket-sent days are left alone
     (`isEntrySelectable`).
  2. **On a range change, saved days with no DAS work (no allocations, sub-job not past Open)
     drop without the "Remove Schedule Dates?" prompt.** A day whose sub-job has allocations, or
     is past Open, still prompts. An empty Open sub-job, which the DAS board creates just by being
     viewed on that date, does not count as work. If the API sends no allocation count, the day is
     treated as having work and still prompts (`hasDasWork` in
     `apps/web/src/features/projects/jobs/job-details/schedule/utils/schedule-range-shift.ts`,
     used by `hooks/use-range-change-guard.ts`). This comes from the decision's *Interpretation*
     section, not from Fouzan Shakil's words.
- **Built defaults changed 2026-10-06 (fix pass on the same branch, commit `6a254ffbf`, not merged):**
  - **(a) Copy to all days no longer ticks.** It writes the times and leaves each row's tick as it
    was: `patchShift(..., { tickOnTime: false })` in
    `apps/web/src/features/projects/jobs/job-details/schedule/utils/schedule-shift-patch.ts` (moved
    there from `hooks/use-schedule.ts`), called from `job-schedule-tab.tsx` → `handleCopyToAll`.
    Reason: a reopened schedule re-adds weekend rows unticked
    ([decisions/2026-09-12-job-schedule-weekend-toggles-follow-the-date-range.md](../decisions/2026-09-12-job-schedule-weekend-toggles-follow-the-date-range.md)
    (b)), and Copy would otherwise have ticked them and put the weekends on the DAS. Typing a time
    into a single row still ticks it; built default 1 is otherwise unchanged.
  - **(b) Built default 2 now also counts these as work, and still prompts for them:** a day with
    Tool & Rigging assignments (`JobToolAssignment`, deleted with the day by cascade,
    `apps/api/prisma/schema.prisma`), and a day whose sub-job has a yard loadout. See `hasDasWork`
    in `apps/web/src/features/projects/jobs/job-details/schedule/utils/schedule-range-shift.ts` and
    the job detail include in `apps/api/src/service/jobs/jobs.repository.ts`. A code fix restoring
    the prompt for data that would be lost, not a new ruling.
- **Consequence for an open entry:** under built default 1, **Copy to all days now also ticks**
  every editable unticked row it writes to. So a dispatcher who unticks days and then copies times
  re-ticks them. Whether Copy should touch unticked rows at all is already open in
  [*Job Schedule "Copy to all days"…*](#job-schedule-copy-to-all-days--replaces-apply-times-and-which-rows-it-overwrites).
  That entry's "Built default: as above" no longer describes this branch.
  - **No longer applies, 2026-10-06:** see (a) above. Copy leaves the ticks alone, so that entry's
    "Built default: as above" is accurate again on this branch.
- **Sources checked:** **nothing written says what unticks a day, whether a day with times must
  be worked, or what view mode shows for an unticked day.**
  - [project-module/03-create-manage-job-schedule.md](project-module/03-create-manage-job-schedule.md)
    (`unverified`, SCRUM-234) is the only schedule spec. It has times per date (:26) and deleting
    a date (:28, :39). It never mentions a per-day checkbox.
  - What the tick means (checked ≡ on the DAS board, `SCRUM-697`) and the earliest description of
    the checkbox (subtractive, *"you can uncheck a date"*) are already recorded in
    [*Converted-quotation schedule days…*](#converted-quotation-schedule-days--checked-by-default-and-what-that-puts-on-the-das-board).
    Not restated here.
  - [decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md)
    (`verified`) confirms the three schedule time fields. It says nothing about ticking.
  - Vault-wide grep for `clear selection`, `select all`, `unticked`, `greyed`, `grayed` turned up
    only DAS panels, DAS copy-allocation and quotation lines. None of it is about the Schedule tab.
  - Jira not checked: the Atlassian MCP did not connect in this session.
- **Related, already open — do not duplicate:**
  - [*Schedule day deactivate orphans SubJob / allocations*](#schedule-day-deactivate-orphans-subjob--allocations):
    what unticking a day does to its sub-job.
  - [*Converted-quotation schedule days…*](#converted-quotation-schedule-days--checked-by-default-and-what-that-puts-on-the-das-board):
    whether a converted job's days arrive ticked.
  - [*Job Schedule "Copy to all days"…*](#job-schedule-copy-to-all-days--replaces-apply-times-and-which-rows-it-overwrites):
    whether Copy writes to unticked rows.
- **Blocked:** nothing hard. Both defaults are web-side and reversible. Recorded so that merging
  the branch does not make "a time ticks the day" the rule without anyone deciding it.
- **Owner:** Lisette Anzaldo (dispatch) for what a working day is; the developer for the UI wording
  ("Clear selection", "Remove days", greyed vs hidden).

## Lift / site plan required fields — enforced on web and API, never written down

- **Status:** open
- **Asked:** 2026-10-08 — client branch `fix/permits-plans-pos-validation-parity` (TCG-143), which
  copied the plan form's required-field checks onto the API (`apps/api/src/usecase/plans/plan-required-fields.ts`).
- **Question:** the web plan form, and now the API, refuse to save
  - (a) a **Lift** plan without **Crane Category** and **Capacity**;
  - (b) a **Site** plan without **Length** and **Width**;
  - (c) a Lift plan missing any field the crane sub-category's template marks **required**, where a
    required **Boolean** counts as missing unless it is ticked *true*, and a required **Range**
    needs both min and max.

  Are these the right required fields for a plan? And for (c), does "required" on a Boolean template
  field mean "must be answered" or "must be yes"? The code reads it as "must be yes" (copied from
  `validateCraneAdditionalInfo`, `apps/web/src/features/plans/components/plan-form-additional-info-validation.ts`),
  so a crane whose template has a required yes/no question cannot get a lift plan with a "no".
- **Sources checked:**
  - [project-module/04-create-and-approve-lift-plans.md](project-module/04-create-and-approve-lift-plans.md)
    (`unverified`, 2026-04-30). It lists crane details ("category, capacity, beam length, and radius")
    and site dimensions ("length, width, height clearance, and work radius"), but never says which
    are required.
  - `projects-jobs/lift-plans/` (all three files), this register and `decisions/`: nothing makes a
    plan field required.
  - Required / optional template attributes appear only for **assets**, in meeting summaries
    (`meetings/summaries/2026-03-24-tcg-cc-product-sync-demo.md:45` and the 03-26 summary of the same
    walkthrough), never for plans.
  - Jira TCG-143 not read: the Atlassian site returned 403 (suspended payment).
- **Blocked:** nothing hard. The checks match what the web form already enforced; the branch made
  them server-side too. Recorded so the rule is not taken as decided because two layers now agree.
- **Owner:** whoever owns lift-plan content on the TCG side (the plan module's approver) for (a)–(b);
  the same person plus the asset-template owner for (c).

## Several customers in one project — "a requirement from Wes" written nowhere, and a new quote from the project does not default the customer

- **Status:** open
- **Asked:** 2026-10-22 — ERP demo walkthrough part 2. Source: [2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md](../meetings/2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md) §7. Filed 2026-10-23.
  - ehtesham.anwar (41:34–57:13): a new quotation created from a project should default to the project's
    customer and allow a change, *"because this was one of the requirements from Wes that in a project we
    can have multiple customers."* In the demo it did not default: *"I don't see the customer … auto
    selected."*
  - The code agrees with the demo: the create-quotation form receives `linkedProjectId` only to save the
    link (`apps/web/src/features/quotations/views/create-quotation-form-model.ts`, read on main at
    `a90658424`); nothing pre-fills the customer.
- **Question:** **(a)** Can one project hold quotations for **different customers** — what is the case
  (a general contractor and its subs, a customer and its parent)? Wes's requirement is not in any
  recording note or decision. **(b)** If yes, whose is the project — does it keep one "project customer",
  and what do its summary and invoices show? **(c)** Should a new quote from the project default to the
  project's customer? (A default is CodingCops' to build once (a) is confirmed.)
- **Sources checked:**
  - [../erp-review-log.md](../erp-review-log.md) *Quotations, jobs and projects (9)* (`unverified`) —
    *"a project may have multiple quotations"*; nothing on several customers.
  - [../decisions/2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md](../decisions/2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md)
    (`verified`, Joe) — options and phases are separate quotes under one project; one customer implied.
  - [../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md)
    (`reference`) — a quote created with `?projectId=` returns to the project.
- **Blocked:** the customer default on a quote created from a project; any project-level invoice view.
- **Owner:** Wes (named as the source) with Ryan Adams (sales).

---
title: Projects Jobs — open questions
status: reference
kind: gaps
updated: 2026-09-08
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
- **Blocked:** PO lifecycle vs approved-permit gates; PR #488 (e).
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

## Ready-to-schedule / publish-without-permit gates unenforced

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit.
- **Question:** do Ready-to-Schedule and “block job publish if permit missing” rules from project-module playbooks need hard API/UI gates, or are they process-only?
- **Sources checked:** `projects-jobs/project-module/05-create-and-track-permits.md` (unverified); scheduling playbooks under `projects-jobs/scheduling/`; no matching enforce path found in API/web grep.
- **Related:** [*Converted-quotation schedule days…*](#converted-quotation-schedule-days--checked-by-default-and-what-that-puts-on-the-das-board).
- **Owner:** Lisette Anzaldo.

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

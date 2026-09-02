---
title: Projects Jobs — open questions
status: reference
kind: gaps
updated: 2026-09-02
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
- Status: open
- **From (frozen original):** [gaps.md#quotation-project-job-what-one-click-creates-and-what-the-button-is-called](../gaps.md#quotation-project-job-what-one-click-creates-and-what-the-button-is-called)

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
- Status: open
- **From (frozen original):** [gaps.md#permit-expiry-reminders-neither-90-nor-30-shipped](../gaps.md#permit-expiry-reminders-neither-90-nor-30-shipped)

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
- Status: open
- **From (frozen original):** [gaps.md#asset-on-a-permit-optional-except-where-a-punch-list-says-compulsory](../gaps.md#asset-on-a-permit-optional-except-where-a-punch-list-says-compulsory)
- **Update 2026-08-27:** Brian Petros, written message to the TCG team, 2026-08-27 ("A couple things that came up in my discussion with CodingCops today, that we'll discuss in future meetings"), following the 2026-08-26 ERP sprint review — logged in [payroll/client-message-findings.md](../payroll/client-message-findings.md#cross-module--2026-08-27-follow-ups-after-the-fcc-migration-first-pass-brian-petros) — Brian: "permits can be specific to the Asset, but can also have
  permits specific to Job". First written client statement that the permit has **two scopes**,
  which reframes this entry: the question is not only whether the asset is optional but whether
  a job-scoped permit has an asset at all. Asset-side permit types are being collected under
  assets → *Unit / asset certifications*.


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
- **Owner:** Lisette Anzaldo / Ryan Adams

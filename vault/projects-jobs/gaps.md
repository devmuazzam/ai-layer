---
title: Projects Jobs — open questions
status: reference
kind: gaps
updated: 2026-08-24
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

- **Status:** open
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

## Project detail Accounting tab — see accounting/gaps.md

- Cross-module pointer (no status of its own — the sweep counts it once, in `accounting/gaps.md`).
  The project detail Accounting tab's AC lives in this module
  (`project-module/05-create-and-track-permits.md:64`, unverified) and its tab-bar entry in
  `project-module/01-create-and-track-projects.md:33`, but the answer is owned by the accounting
  module — it is gated on that module's scope and ~Oct–Nov 2026 kickoff. Raised by `SCRUM-897`.
  Full entry: [accounting/gaps.md](../accounting/gaps.md#project-detail-accounting-tab--what-it-shows-and-what-it-shows-before-the-module-exists).


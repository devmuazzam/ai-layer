---
title: Dispatch — open questions
status: reference
kind: gaps
updated: 2026-09-11
tags: [module/dispatch, kind/gaps, open-questions]
---

# Dispatch — open questions

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

## Jobs panel views — Lisette's stated preference was removed without her

- Question: should the DAS jobs panel keep the **compact chip ("squares") view** alongside the
  detailed list view, or is the list-only view correct?
- Candidates:
  - Recording **2026-04-21 "Dispatch-Scheduling Figma demo"**, `ehtesham.anwar` at 15:24 describing
    both views, then asking at line 522: *"So, **Lisette**, up until then, up until now, what is your
    feedback?"* The reply at 31:13 comes back under the **"Brian Petros"** label — **inferred to be
    Lisette Anzaldo**, a textbook instance of the known mislabelling: *"I like the other view with
    the for the jobs, the one where all the jobs come up **like in squares. I like that layout. I
    feel like it's easier to see everything. I really like the view. I really, really like it.**"*
    And at 32:12, asked what she would change: *"No, I think this is it… still having access on the
    job and being able to **see the crane size, the city** and stuff like that, that totally helps
    me."*
  - `dispatch/daily-allocation-system.md:36` — *"Toggle switches between Compact chip view and
    detailed List view for jobs"*. `conflicts_with: [projects-jobs/job-project-das.md]`.
  - `projects-jobs/job-project-das.md:69` — *"Remove card . grid view toggles"*. This is a **cross-module
    punch list** in which DAS is one of nine sections; see §*Feedback punch lists are not scoped to
    the module they are filed under* and `dispatch/daily-allocation-INDEX.md`.
  - `SCRUM-331` *Implement the cards and lists view for jobs* — **Done**, **`description: null`**,
    created 2026-05-07, **last updated 2026-07-17**. `SCRUM-784` *"Remove card . grid view toggles"*
    — **Done**, reporter Umair Khan, created **2026-07-17** (the same day), description *"In DAS, we
    have to remove the grid view for the JOB"*. **Its summary is a verbatim copy of the punch-list
    line, stray period included** — the ticket was minted from the punch list. **No TCG person is
    named on it**; its only comment is CodingCops QA to a CodingCops developer.
- Note: `apps/web/src/features/das/middle-section/jobs/jobs-section.tsx` renders only
  `<JobsListView />` — no view-mode state, no toggle. So the layout Lisette said she *"really,
  really"* liked was removed three months later on the authority of a CodingCops punch list, and
  **nothing records that she was consulted.** This is exactly the reversal-without-attribution the
  2026-08-19 review was opened to find. Note the punch list is attributed in
  `customers/customers-INDEX.md` and the DAS stub to "Mohsin feedback" — Mohsin Ali is CodingCops, not
  TCG, so **neither side of this pair carries a TCG decision.** One detail worth preserving whichever
  way it goes: the list view is the one that shows **required crane size** (`ehtesham.anwar` at
  42:17), which is the thing Lisette said helps her.
- Blocked: `SCRUM-784` (Done) may need reverting; the DAS jobs panel layout.
- Owner: Lisette Anzaldo (dispatch/DAS — she stated the preference and is the user of the panel).
- **Status:** open
- **From (frozen original):** [gaps.md#jobs-panel-views-lisettes-stated-preference-was-removed-without-her](../gaps.md#jobs-panel-views-lisettes-stated-preference-was-removed-without-her)

## Requested vs dispatched resources — Melissa stated it, the vault still says the opposite

- Question: is the job's **requested resources** list a frozen client-approved record that dispatch
  cannot edit — with substitutions recorded separately as the **dispatched asset** — or can the
  dispatcher add, update and remove resources on the job itself?
- Candidates:
  - Recording **2026-06-17 "ERP Sprint Review"**. **Melissa McNutt at 59:56** (labelled directly, not
    on the mislabel list, and addressed by name in the preceding turn): *"if we change an asset, **we
    don't re-quote**. So if they call for 90-10 and we send the 275, **we just update the assets in
    the dispatch view and we don't go back and change the quote**."* At **1:00:27**: *"**Lisette
    needs to be able to go in there and change that asset**"* from the dispatch view.
  - Same recording, `ehtesham.anwar` (CodingCops) at 1:00:38 proposing the two-record rule: *"She
    won't be able to change that asset from the jobs resources **because this is the requested
    resources**, and approved by the client. What she can change is once she's dispatching something
    from her own view. And that way **we can retain both of the information**."* **Melissa McNutt at
    1:01:00: *"Okay. Yeah, as long as she can change it on her end, then that's fine."*** — she
    **assented to** the rule; she did not originate it.
  - `projects-jobs/project-module/02-view-manage-job-details.md:50` (`conflicts_with: []`) — *"Dispatcher
    can add new resources, update existing ones, or remove them"* on the job Resources tab, and :23
    *"Adds, updates, or removes resources as needed"*. **The vault has no requested-vs-dispatched
    concept anywhere.**
  - `SCRUM-580` *Editable Asset in Dispatch View* — **Done**, reporter Umair Khan, created 2026-06-25
    (eight days after the recording). Description: *"Allow Dispatch users to substitute or update the
    assigned asset within the Dispatch View **without modifying the customer-approved requested
    resource on the quotation**… maintain the originally approved requested resource while recording
    the actual dispatched asset."* **It paraphrases Ehtesham's formulation and cites nobody.** Its one
    comment, 2026-07-03: *"moving this to blocked for now **until we have client confirmation on
    this**"* — **and no later comment records that confirmation arriving** before it went Done.
- Note: state (d) compounded by (b). The two-record rule is **built** and **unwritten as product
  intent**: the vault still asserts the opposite at :50 and has never been amended, the ticket names
  no TCG person, and CodingCops' own comment says client confirmation was outstanding. Melissa's
  wording — *"we don't re-quote"* — is the cleanest available statement of the intent and is exactly
  what a one-line confirmation would ratify. Note this is genuinely close to resolved: unlike most of
  the set, a named TCG person did speak to it on a reliably-labelled recording. It needs the
  confirmation, not a re-decision.
- Blocked: `projects-jobs/project-module/02-view-manage-job-details.md:50` is actively misleading for any
  spec written against it; the job Resources tab; `SCRUM-580` (Done, on unconfirmed intent).
- Owner: Melissa McNutt (stated it), with Lisette Anzaldo (the dispatcher whose edit right it is).
- **Status:** open — needs confirmation
- **From (frozen original):** [gaps.md#requested-vs-dispatched-resources-melissa-stated-it-the-vault-still-says-the-opposite](../gaps.md#requested-vs-dispatched-resources-melissa-stated-it-the-vault-still-says-the-opposite)
- Update 2026-09-04 (Project Repository ingest): three sources bear on it; none is a decision.
  (a) The client's own review log, 2026-05-05 extraction
  ([erp-review-log.md](../erp-review-log.md) → *Quotations, jobs and projects*): *"the quote must
  remain static after signature — job information may change later without modifying the signed
  quote"*, and the job *"inherits quote data as a starting point, then allows operational updates
  (site contact, PO, entrance instructions, actual units)"*. That is the same intent as Melissa's
  *"we don't re-quote"*, on record three weeks earlier — but it puts the editable record on the
  **job** (its "actual units"), not on a separate dispatch-view record, and it is an unverified
  AI extraction of a meeting the client marked "for reference only". (b) TCG's own playbooks
  treat substitution as routine: sales hands over a *requested crane* plus **two alternate crane
  options** ([projects-jobs/scheduling/ready-to-schedule.md](../projects-jobs/scheduling/ready-to-schedule.md)
  *Crane*; [dispatch-value-engine-and-playbooks.md](dispatch-value-engine-and-playbooks.md) *Get
  Required Info*), and the confirmation procedure's worked example is *"a 90-ton job with a 265-ton
  assigned"* — *"verify the crane size requested against the crane size assigned"*, then the travel
  permit and extra loads ([confirmations-playbook.md](confirmations-playbook.md) §6). So the
  requested/assigned distinction is real in practice, and a substitution re-opens permit and
  configuration. (c) FCC fact — evidence of current practice, not a TCG decision: `FMS_JOB_UNITS`
  carries both `UnitTypeID` (the role, *"the role that resource is taking on the job"*) and
  `UnitCode` (the specific unit) on the same job-unit row
  ([stg.FMS_JOB_UNITS_Raw.sql](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_JOB_UNITS_Raw.sql)
  lines 4–5; [fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md) §3), and FCC's stated
  best practice is to leave the specific Resource blank *"until close to job execution"* — one
  editable job row, no frozen copy; the quote header carries a `Converted To Job` field. Still
  needs the client: whether the frozen record is the **quotation** (review log) or the job's
  Resources tab (as built, and as `02-view-manage-job-details.md:50` contradicts), and Melissa's
  one-line confirmation of the two-record rule.

## Schedule fields — the build already agrees, and the new fields are written nowhere

- Question: are **sales coordinator, salesperson, job location, scheduled hours** and the job statuses
  **Scheduled / Tentative / Hold / Cancelled / Maintenance** required on the schedule — and with
  in-maintenance cranes already non-selectable, should the double-booking warning still fire for
  non-overlapping same-day reuse?
- Candidates:
  - Recording **2026-08-11 "Sales Process"** at 14:01 and 15:04, labelled **Brian Petros**: *"This
    would be the sales coordinator. This would be the salesperson. Job location."* / *"Scheduled,
    saved, tentative, hold, canceled, or maintenance. **So if a crane was in maintenance, we wouldn't
    even be able to pick it.**… This would allow us the **scheduled hours**. So **if it was a short
    job, we may be able to do 2 jobs in one day with the same crane**."* At 15:23: *"So we know we
    could **double book**."* ("saved" is almost certainly a mis-transcription; the 08-12 minute records
    the list without it.)
  - **Attribution conflict, unresolved.** The transcript labels this **Brian Petros**; the pair row in
    the combined entry above says *"Ryan wants non-selectable"*. Ryan Adams is on the mislabelled set.
    **One of the two is wrong and the recording cannot settle it** — worth asking alongside the
    substance.
  - `meetings/2026-08-12-sell-side-workflow-and-scheduling.md:37-40` — a **forward-looking** client
    minute (caveat 5 does not apply), recording both the field list and *"The system should prevent
    selection of cranes under maintenance and support double booking"*. **But its Action items table
    has four rows and none of them is this rule** — it is recorded as a discussion point with **no
    owner and no action item**. The minute's own analysis at :79-82 already says *"Neither source
    covers either rule."*
  - `dispatch/daily-allocation-system.md:47` — *"unavailable ones are greyed out but still drag-gable
    with a system warning"*; :48 — *"Assignment is time-based (shift start/end), so the same asset can
    be assigned to two non-overlapping jobs on the same day"*; :80, :82 — maintenance tag and three
    chip states. `projects-jobs/project-module/03-create-manage-job-schedule.md:43` — a warning on
    same-time, same-date double assignment.
  - `SCRUM-502` *Asset Availability & Maintenance Status* — **Done**, created **2026-06-03**,
    AC 2: an asset marked maintenance *"stays visible but **cannot be assigned to a job**"*.
    `SCRUM-234` *Create & Manage Job Schedule* — **Done**, AC 10 matching the vault's warning line.
    **Neither names a requester.**
- Note: **the client was ratifying existing behaviour, not requesting a change.** `SCRUM-502` shipped
  the block on 2026-06-15, two months before the 08-11 recording, and the code agrees:
  `apps/web/src/features/das/left-section/components/asset-card.tsx` passes `disabled: isInactive` to
  the drag hook for `UNDER_MAINTENANCE` assets and short-circuits the click handler. So
  `dispatch/daily-allocation-system.md:47` is simply **stale** — a 2026-04-30 statement superseded in
  June — and it carries no marker warning a reader, which matters because
  `dispatch/daily-allocation-INDEX.md` calls that file *"the only DAS specification"*. On
  double-booking the recording and :48 already **agree**. What is genuinely unwritten: **scheduled
  hours, sales coordinator, and the Tentative / Hold / Maintenance job statuses appear in no vault
  spec and no ticket**, and nothing says whether the :43 warning should still fire once maintenance
  is hard-blocked. Also relevant: §*Sell-side scheduling artefacts — no vault coverage*, which
  already names an owner for this area.
- Blocked: the job status enum; the schedule form fields; whether `dispatch/daily-allocation-system.md:47`
  should be corrected (a body edit — not `tcg-scrum`'s to make).
- Owner: Brian Petros (labelled speaker, and already named as owner of the sell-side workflow source
  files), with Ryan Adams to resolve the attribution; Lisette Anzaldo for the DAS consequence.
- **Status:** open
- **From (frozen original):** [gaps.md#schedule-fields-the-build-already-agrees-and-the-new-fields-are-written-nowhere](../gaps.md#schedule-fields-the-build-already-agrees-and-the-new-fields-are-written-nowhere)
- Update 2026-09-04 (Project Repository ingest): the artefact the 08-11 recording was describing
  has arrived — `Job Schedule Master.xlsx`, filed as *"from Ryan 2026-08-11"*, live-dated
  2026-08-11 09:20
  ([projects-jobs/scheduling/job-schedule-master-workbook.md](../projects-jobs/scheduling/job-schedule-master-workbook.md)).
  It settles three sub-points as a matter of record and reopens one; it is a spreadsheet's
  convention, not an ERP requirement. (a) The status list is exactly `Scheduled · Saved ·
  Tentative · Hold · Canceled · Maintenance` (`Lists` sheet) — **"saved" is a real status, not a
  mis-transcription**; the parenthetical above is wrong. The same six values, plus `DISPATCHED`,
  drive the Crane Scheduling Board in
  [quotations/sales-reporting-workbooks.md](../quotations/sales-reporting-workbooks.md) §3, whose
  `Metrics` sheet defines `Tentative` and `Hold` as pipeline "placeholder" states. (b) The
  per-crane/day fields are `Status · Customer / Job # · Job Location / Notes · Salesperson ·
  Sales Admin · City · Start Time · Scheduled Hours · Support Trucks` plus the permit columns —
  the recording's list, with a **`Sales Admin`** dropdown where the transcript says "sales
  coordinator" (whether those are one role is not stated). (c) Availability, stated on the
  `HOW TO USE` sheet: *"Scheduled, Saved, Tentative, Hold, and Maintenance are treated as
  unavailable; blank or Canceled is available"* — Maintenance is a **status on the crane/day**,
  not an asset state, and Hold blocks the crane. (d) **Contradiction with the recording:** the
  board's unit of booking is one crane × one calendar day with a single status cell and no
  time-of-day slot, so the model cannot hold two jobs on one crane in one day — the *"2 jobs in
  one day with the same crane"* the speaker wanted is not what the sheet does. On attribution:
  the file's provenance is Ryan's folder, consistent with the pair row's *"Ryan wants…"*; it does
  not settle the speaker label. FCC facts, evidence of practice not decisions: NexGen's job
  status has `T` Tentative but no Hold and no Maintenance
  ([fcc-job-status-type-and-department-codes.md](../payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md));
  maintenance is a separate *Unit Down Time* record shown on the Unit Schedule only;
  `FMS_JOB_MASTER` holds `SpersonCode`, `TakenID`, `CheckID` and no coordinator field; and an
  overlapping booking raises an **advisory, overridable, per-unit-suppressible** violation
  ([fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md) §4, §7). Still needs the client:
  whether the six statuses and Salesperson / Sales Admin / Scheduled Hours are ERP requirements or
  the sheet's own conventions; same-day reuse of a crane (the sheet says no, the speaker said
  yes); and whether the :43 warning still fires once maintenance is hard-blocked — no source says.
- Update 2026-09-07 (2026-09-03 payroll call, [../meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md](../meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md) §3): the **time fields** are now
  confirmed by Dispatch and Operations on the record — Joe Schacatano 49:57: call it *start time*,
  not *leave yard time*; Kyle Harlow 49:36 and Joe 52:28: **start time · on-site time · estimated
  job end time (= leave-job time)** is the right set for dispatch; paid time runs from start time at
  the yard to return to the yard with paperwork done, rounded up ([../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md)). **New ask
  from the same exchange (Joe 53:03):** an **estimated yard-arrival time**, ideally predicted from
  the actual travel time to the job, *"so we have an idea of when their hours are going to end"* and
  how that affects the next day's hours of service. Not in any spec or ticket; owner Joe Schacatano.
## Crane configuration — is a support load an Asset, or a line on the crane?

- **Status:** resolved 2026-09-03 — **an Asset.** See the resolution note below
- **Asked:** 2026-08-29 — reading `3.3.1_MODULE-DISPATCH-JOBS` into the vault
- **Question:** The approved workbook lists `26502 OL`, `26502.1`, `26502.2`, `26502.3`
  as their own unit codes with their own names, crew roles and ticket numbers. Are these
  meant to exist in TCG as **Assets** (own unit code, own row in the fleet), or as a
  **configuration on the parent crane** that expands into ticketed loads at dispatch time?
  The workbook's shape says Asset; the phrase *"it will depend on the crane's
  configuration"* says the second. This decides whether the operator load appears in the
  asset list, whether it can be independently unavailable, and whether utilisation counts
  it. **No Asset-side model exists either way** — nothing in `schema.prisma` represents a
  load as a unit under a parent crane.
- **Corrected 2026-09-01 — the original entry's evidence was wrong.** It claimed
  `counterweight`, `CWT` and `operator load` *"return zero hits across API, web and
  schema."* They do not. All three of the workbook's load kinds are already seeded as
  **billing code types** in `apps/api/src/utility/seed-data.ts`: `CWT` Counter Weight Truck
  (line 76), `OPL` Operator Load (line 86), `SUPP` Support Load (line 99). That points at a
  third answer the entry did not offer — a load is already modelled as **a billable line**,
  which is what a quotation resource hangs off — and it is the only one of the three with
  anything built behind it. `apps/api/src/service/ticket-labor-entries/` also reasons about
  Operator Load explicitly, as *"Operator Load trucks that also allocate as ASSET but have
  no `mainBoomLength`"* (`ticket-labor-entries.repository.ts:327`), so the ticket side
  already treats an OL as allocating like an asset while being priced as its own code.
  Do not answer this question from the "nothing is built" premise.
- **Update 2026-09-11: the `seed-data.ts` evidence above is gone on branch `fix/das-fixes`.**
  Fouzan Shakil (CodingCops, `reference`) dropped the billing code type master, in migration
  `20260911040000_drop_billing_code_types`. The `CWT` / `OPL` / `SUPP` type seeds were removed with
  it (`git grep` on the branch finds none in `seed-data.ts`). See
  [../decisions/2026-09-11-billing-code-type-master-dropped.md](../decisions/2026-09-11-billing-code-type-master-dropped.md).
  Their values are preserved in
  [../quotations/billing-code-types-dropped-2026-09-11.md](../quotations/billing-code-types-dropped-2026-09-11.md).
  The `ticket-labor-entries` evidence is unaffected. The question itself stays open.
- **Sources checked:** `ASSETS_DISPATCH_(Lisette-approved).xlsx`, `Dispatch PDF Blank
  Master.pdf` annotations, `crane-configurations.md`, `schema.prisma`
  (`Asset`, `SubCategoryAssociatedResource`, `SubJobLoadoutItem`, `UnitTypeResource`);
  and on the 2026-09-01 correction, `apps/api/src/utility/seed-data.ts:70-100`,
  `apps/api/src/service/ticket-labor-entries/ticket-labor-entries.repository.ts:327`.
- **Resolved 2026-09-03 — a load is an Asset.** Full rule set and citations in
  [crane-configuration-rules.md](crane-configuration-rules.md) §1.4. **This entry had not reached the
  meeting transcripts** — its Sources-checked list is the workbook and the PDFs only, and three
  meetings answer it directly. Each load trailer has its own unit code, VIN, trailer number and
  plate (`2026-05-19` @ 31:15 *"bin numbers, trailer numbers, plate numbers, everything"*), is
  permanently loaded with its own counterweight and **never migrates to another crane**
  (@ 28:14 *"No, that's permanent"*; @ 28:56 *"that specific like 1901.2, that's not going to go to
  another crane. That's only for that specific crane"*; `2026-04-14` @ 16:28 *"Each counterweight,
  each trailer, that's the way it's supposed to go. It doesn't change… We don't change them"*). It is
  also separately billable (`2026-04-14` @ 12:02) and separately ticketed with its own driver
  (Corrina Bustos, `2026-05-19` @ 35:56). So: **own row in the fleet, allocatable, counts for
  utilisation** — the billing-code reading in the 2026-09-01 correction is the *pricing* of the same
  thing, not a rival answer to what it is.
- **The follow-on that is now the real work.** Nothing in `schema.prisma` nests a load under a
  parent crane, and `SubCategoryAssociatedResource` cannot hold **one tractor per trailer** — the
  tractor is a flat sibling of the crane and the unique constraint permits exactly one tractor row
  per parent, so a 265 T needing four tractors is unrepresentable
  (Melissa McNutt, `2026-04-14` @ 29:04 *"each every trailer will always have a tractor"*).
  See [crane-configuration-rules.md](crane-configuration-rules.md) §8 for the full
  representable/not table.

## Crane configuration — which loads are mandatory, and per what?

- **Status:** resolved 2026-09-03 — keyed to the **sub-category** as a default template; **sales** picks at quotation time; dispatch overrides. See the resolution note below
- **Asked:** 2026-08-29 — reading `3.3.1_MODULE-DISPATCH-JOBS` into the vault
- **Question:** The sheet says the operator load *"is require to go out anytime the crane
  goes out — all the cranes from 9001 and on"*, but *"4005 and 4006 sometimes require this
  in different configurations"*, and the `.1/.2/.3` loads *"are not always required… it
  will depend on the crane's configuration"*. So: is the requirement keyed to the crane, to
  the sub-category, or to the lift being quoted? And who picks the configuration — sales at
  quotation time, or dispatch at allocation time? Without this the system cannot know how
  many tickets a crane generates.
- **Bearing on quotations, noted 2026-09-01.** Until the "who picks it" half is answered,
  **nothing is required of the quotations module** and none should be inferred: a quote
  today prices `OPL` / `CWT` / `SUPP` as ordinary resource lines a salesperson adds by
  hand, with no expansion from the parent crane. Related and separately unanswered: the
  rate card gives Operator Load a **5 h minimum and 8 h maximum**, which `BillingCode` has
  no field for — see `../quotations/gaps.md`.
- **Sources checked:** `crane-configurations.md`, `ASSETS_DISPATCH_(Lisette-approved).xlsx`;
  and on the 2026-09-01 note, `apps/api/src/utility/seed-data.ts:70-100`,
  `apps/api/prisma/schema.prisma:1246-1266` (`BillingCode`).
- **Resolved 2026-09-03.** Full rule set and citations in
  [crane-configuration-rules.md](crane-configuration-rules.md) §5. **This entry had not reached the
  meeting transcripts either.** Both halves are answered:
  - **Per what** — the sub-category, as a *default template that is always overridable*, never a
    hard constraint (`2026-05-19` @ 27:12 *"the quotations will be based on these current
    configurations… It'll just be like a starting point, and then they can modify it"*). The default
    at **190 T and above is the full configuration** (`2026-04-14` @ 17:12 *"it's a full crane,
    unless it's specified by the sales rep that they don't need all the trailers"*), and loads are
    **ordered, taken as a prefix, dropped from the tail** (@ 16:28 *"don't take the last load or
    don't take the last two. They just need the first ones"*; @ 17:12 *"they will specify 190
    operator load, which is the very first one, plus one more"*).
  - **Who picks it** — **sales, at quotation time**; dispatch then decides how to haul it, because
    route and scales decide whether counterweight comes off the crane onto a truck (`2026-04-14`
    @ 5:45 *"the sales guys put on their jobs, they'll put the counterweight that they need. And then
    based on the cities, then that's when I determine whether we're going to go through scales or
    not"*; @ 5:04 *"as soon as you pull a counterweight, it's a separate truck regardless"*).
  - **The 4005/4006 "sometimes"** is not ambiguity to be modelled — the same meeting resolved it into
    **discrete named load options** `3300` / `7300` / `full` that sales picks from a dropdown
    (@ 4:21, @ 12:26), and asked for the same treatment on the 190 T-and-up groups (@ 14:24). That
    retrofit is **requested and undecided** — carried forward in
    [crane-configuration-rules.md](crane-configuration-rules.md) §10.
- **Bearing on quotations, updated 2026-09-03.** The 2026-09-01 note said nothing is required of the
  quotations module until "who picks it" was answered. It is now answered: **sales picks**. What
  follows for quotations is not thereby settled — expansion from the parent crane, the ordering
  constraint, and the per-slot counterweight weight all still need a product call before they are
  built. Do not read this resolution as a spec for that.

## GPS-verified time on a job — what is being verified?

- **Status:** open
- **Asked:** 2026-08-29 — Melissa McNutt, 2026-04-18
- **Question:** The request in full is *"on the job we would like to add a time verified by
  GPS — just a click button or check box."* Unspecified: **which** time (on-site, left
  yard, start work, end work — the ticket already stamps six), **whose** GPS (the crane's
  telematics, the employee's phone, the tractor), what the checkbox **asserts** (a claim by
  the dispatcher, or a system comparison against a real coordinate), and what happens when
  GPS and the stamped time disagree. As a checkbox it is trivial; as verification it needs a
  telematics source. `gps` returns zero hits across API, web and mobile.
- **Sources checked:** `crane-configurations.md`, `schema.prisma` (`JobTicket` timeline
  stamps), grep across `apps/`.
- **Update 2026-09-04 (Project Repository ingest):** four pieces of evidence, no decision.
  (a) **Which times TCG already checks against GPS, on paper:** the printed daily log
  (`HR_PAYROLL - Daily Log and Timesheet.pdf`, read 2026-09-04) closes with a boxed *"BELOW SECTION
  FOR OFFICE USE ONLY"* block carrying **`GPS Tracker Depart for job site time`** and **`GPS Tracker
  Arrive at yard time at the end of the day`**, written by hand beside the employee's own times
  ([../field-ops/field-paper-forms.md](../field-ops/field-paper-forms.md) §3, item 5). A
  client-authored form: today's practice reconciles two device times — leave-yard and
  return-to-yard — and the office, not the employee, does it. That is practice, not a statement of
  which time Melissa's checkbox means. (b) **What FCC records — system facts, not TCG decisions:**
  every ticket stamp exists three ways (local, `…UTC`, `…TZ`) plus an `…Orig` copy of each —
  `YardOut`, `YardIn`, `TimeStart`, `TimeEnd`, `LeftJob`, `ArrivedJob`, `StartWorkTime`,
  `EndWorkTime` — with one free-text `TimeChangeJustification` and a `PostedToGeoTab` bit
  (`../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_JOB_TICKET_Raw.sql:75-134`). FCC preserves
  the original stamp and the reason for an edit; **no column asserts that a stamp was verified
  against a position**, and nothing in the ingest says what `PostedToGeoTab` does. GPS enters FCC
  only as per-unit telemetry rows — `Source = GPS`, `Latitude`/`Longitude` *"can only be populated
  by a GPS interface"*, read-only, auto-associated to a job by date range
  ([fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md) §3 *Telemetry*) — and for the
  cranes with a support vehicle the device sits on the tractor, not the crane (Brian, 2026-08-26
  sprint review 18:49). (c) **The one bound TCG has put on "verified":** in the 2026-06-16 field-app
  demo Corrina asked whether the GPS card should show to the field *"since we're technically not
  supposed to use that for time and pay"*; Wes: *"we can't use it for any sort of… getting him in
  trouble, but we're… showing him that we know the exact time"*; Melissa: *"fine for now… might keep
  him accountable"* (`../meetings/transcripts/2026-06-16-field-ops-mobile-app-demo.md:114-121`).
  GPS as **display and accountability, not the pay-time source** is the only stated limit. Related
  but distinct asks on the record: Corrina wants GPS to auto-verify short/long subsistence
  (2026-06-09 payroll demo 57:41-58:00; Joe: against the **permitted** route, 59:17); Wes, Ehtesham
  and Kyle agreed a Samsara vicinity check could flag the wrong unit leaving the yard (2026-07-07
  36:09-36:57); Melissa wants end-job to *"engage the GPS"* and update the dispatch board live
  (2026-08-12 sprint review 44:57). None of these is the 2026-04-18 checkbox. (d) TCG's Samsara
  facts — used by dispatch, payroll, accounting and safety; FCC pulls mileage via API; accuracy poor
  enough that Maintenance keys mileage by hand
  ([../admin/responsive-design-and-security-posture.md](../admin/responsive-design-and-security-posture.md)
  Part 3). **Still needs the client:** which stamp(s) the checkbox covers, whose device, and whether
  it is a dispatcher's attestation or a system comparison — the paper form points at leave-yard and
  return-to-yard checked by the office, but nobody has said so for the ERP.
- **Update 2026-09-04, from the record** (computed the same day from `stg.FMS_JOB_TICKET_Raw` in the restored 2026-06-23 backup): the `PostedToGeoTab` flag is **0 on all 9,070 tickets dated 2025 or later** — a vendor column TCG never used, so it is not evidence of a second telematics provider and not a place where any GPS verification was ever recorded. FCC holds no GPS-derived time; whatever "verified by GPS" means, it has no legacy precedent in the ticket table.

## Default crew per unit, overridable per job

- **Status:** open
- **Asked:** 2026-08-29 — raised in the margin of `Dispatch PDF Blank Master.pdf`, unanswered
- **Question:** *"Can we add where we can assign crew members to a unit but to where it can
  easily be changed? Let's ask Lisette this would be helpful. I could see an error happening
  if the normally assigned crew members aren't going."* A standing crew per unit that
  pre-fills allocation and can be overridden. `EmployeeAsset` already links employees to
  assets — is that the same concept, or is this a dispatch-time default distinct from
  ownership? The note names Lisette as the person to ask; no record that she was.
- **Sources checked:** `crane-configurations.md`, `schema.prisma` (`EmployeeAsset`,
  `JobResourceAllocation`).
- **A second shape of the same question, 2026-09-02 — the oiler who also rigs.** In the sprint
  demo Wes Staley: *"if I have an operator, a crane going out, an operator load, and a third man,
  but I need the third man to serve as a rigger also — how do we include that so it's not two
  different boxes?"* Joe Schacatano's answer is that it changes **neither dispatch nor pay**, so it
  belongs in the **note / description of work** on the ticket, or possibly a *third man acts as
  rigger* **checkbox at the quoting stage** — and explicitly **not** a combined "oiler/rigger"
  resource, because a combined label tells the employee nothing: *"Am I the oiler or am I the
  rigger? Am I doing both?"* Wes's actual requirement is narrower than the modelling argument —
  the man must be **told** on his ticket. Ehtesham accepted neither as final and asked TCG for
  **more use cases of this shape**, warning that such configurations *"are going to get lost"*.
  So: is a role-on-this-job distinct from the resource slot a person is dispatched into, and if
  the answer is "notes only", what guarantees the note reaches the ticket? Source:
  [meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md) §6
  (transcript 40:45–53:18). Related: the sub-category association chain demoed in the same call —
  100 ton crane → oiler + operator load → tractor → operator/rigger, with optional members
  removable on the quotation — which is the built answer to *what* goes out, not *who does what*.
- **Update 2026-09-04 (Project Repository ingest):** the legacy system has no standing crew per
  unit, and the client keeps one by hand — evidence of practice, not a decision. (a) **FCC — system
  facts:** the unit master `stg.FMS_UNITS_Raw` carries no employee, operator or crew column (all 160
  columns checked; `SpersonCode` is its only person reference). The crew binding lives on the
  **job**: `stg.FMS_JOB_UNITS_Raw` has `EmpID`, `EmpIDOiler` and `JobEmpID` per unit row, and
  `stg.FMS_JOB_EMPLOYEES_Raw` has `UnitCode` + `PrimaryResource` per employee row
  (`../payroll/tcg-rawfms-staging-database/ddl/`). FCC's only default mechanism, *Unit Type
  Defaults*, injects employee **types** (Operator, Oiler…) per unit type, not named people
  ([fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md) §9), and the v2.2 guide's stated
  best practice is to leave the named `Resource` blank *"until close to job execution to reduce the
  number of changes"* (§3). Job `OM55127` shows the result — operator, oiler and two 3rd Men named
  on the job's Resources tab
  ([../quotations/fcc-billing-data-and-price-lists.md](../quotations/fcc-billing-data-and-price-lists.md)
  §4). (b) **Client statements of practice, all older than the ingest:** Lisette, 2026-02-27 demo
  37:25 — *"the operators are also assigned to the cranes"* on her sheet; Melissa, 2026-05-19 42:09
  — operator + oiler are *"their main crew"*, who pre/post-trip *"their crane, their assigned truck,
  and their assigned trailer"*; Ryan, 2026-03-24 27:40 — *"a lot of the operators are operating the
  same cranes"*. The dispatch sheet holds it as an `OPERATOR` cell per crane row, overwritten with
  `Open` (needs cover) or `Down` ([dispatch-sheet-workbook.md](dispatch-sheet-workbook.md) §4), and
  Lisette's *Set Schedule / Assigned Equipment* playbook re-checks *"assigned jobs to operators,
  journeyman and apprentices"* with the superintendent before tickets go out
  ([dispatch-value-engine-and-playbooks.md](dispatch-value-engine-and-playbooks.md) §4) — assignment
  is re-confirmed per day, not read from a master. **Still needs the client:** whether the ERP should
  hold a named default per unit (and whether `EmployeeAsset` is that record or an ownership link),
  who maintains it, and what overriding it on one job does to the default. Lisette has still not
  been asked.


## Schedule day deactivate orphans SubJob / allocations — see projects-jobs

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit.
- **Question:** see [projects-jobs/gaps.md — Schedule day deactivate orphans SubJob / allocations](../projects-jobs/gaps.md#schedule-day-deactivate-orphans-subjob--allocations). Dispatch owns the DAS board behaviour; product answer lives with projects-jobs.
- **Owner:** Lisette Anzaldo.

## Quote / Job yard free-text vs Yard master FK — see projects-jobs

- **Status:** open
- **Asked:** 2026-09-08 — open-loop audit.
- **Question:** see [projects-jobs/gaps.md — Quote / Job yard free-text vs Yard master FK](../projects-jobs/gaps.md#quote--job-yard-free-text-vs-yard-master-fk). Yard Operations / Dylen loadout sits under dispatch UX; identity of `yard` on quote/job is owned by projects-jobs.
- **Owner:** Lisette Anzaldo.

## DAS map job status buckets — nine SubJob stages collapsed to four, and LOADOUT counted as pending

- **Status:** open
- **Asked:** 2026-09-09 — raised while reviewing branch `scrum-252` ("Implement map view in DAS").
  The branch has no `.ai/aidlc/SCRUM-252/` folder and no `processed.log` row; it never ran the
  loop, so nothing about it has been elaborated or sourced.
- **Question:** **Does the DAS map / Yard Operations board collapse the nine `SubJobStage`
  values into exactly these four display statuses — and specifically, does a job in the
  `LOADOUT` stage read as *Pending Loadout* or as *In Progress*?** One line settles it: name
  which stages fall in each bucket, or confirm the four buckets are wrong and give the right set.
  The shipped grouping is OPEN + ALLOCATION_COMPLETED + LOADOUT → `PENDING_LOADOUT`;
  TICKET_SENT + EMPLOYEE_LEFT_YARD + WORK_IN_PROGRESS → `IN_PROGRESS`; COMPLETED +
  TICKET_SUBMITTED → `COMPLETED`; CANCELLED → `CANCELLED`
  (`apps/api/src/usecase/das/das-map.service.ts:21`, mirroring
  `apps/web/src/features/dylen-dashboard/utils/map-das-job-to-dylen-card.ts:5`).
- **Sources checked:** **The nine-stage sequence is written; the four-bucket collapse is not,
  anywhere.** [daily-allocation-system.md:60](daily-allocation-system.md) (`status: unverified`)
  gives the progression *"Open → Allocation Completed → Ticket Sent → Load-out → Employees Left
  Yard → Work in Progress → Completed → Ticket Submitted"* and its *USER STORY : Live Asset Map
  View* says nothing about status buckets on the map. [daily-allocation-INDEX.md](daily-allocation-INDEX.md)
  (the DAS conflict stub) does not raise the question. `../assets/tool-and-rigging.md` → *Story 5:
  Dylan's Yard Dashboard* describes that board without a status taxonomy. `crane-configurations.md:87`
  carries the only status→display mapping in the vault — Lisette's **colour** legend, seven
  colours, not four buckets, and not these stages. The string *"pending loadout"* appears
  **nowhere** in the vault outside meeting transcripts. `decisions/` holds **no** decision on DAS
  job statuses. `README.md` → *What this vault does not contain* does not exclude it, so this is
  a gap, not policy.
- **Note — the only two transcript statements that touch it point the other way, and neither is
  a decision.** Both are CodingCops' own narration, not a TCG ruling:
  [../meetings/transcripts/2026-05-07-loading-and-project-module-overview.md](../meetings/transcripts/2026-05-07-loading-and-project-module-overview.md)
  269 — *"once it is available for loadout, it goes to **pending loadout** state and once… people
  change this tab to pending load out, then they can start loading them out"*; and
  [../meetings/transcripts/2026-05-12-loading-figma-demo.md](../meetings/transcripts/2026-05-12-loading-figma-demo.md)
  106 — *"he able to check all the items and hit on the loadout. So now everything is load out and
  … this job status change into **in progress**"*, with 311 — *"that's why we have pending
  loadout. Once Dylan… says mark available for loadout. Once it is marked, then it is pending
  loadout."* Read together those describe *pending loadout* as the state **before** loading
  begins and *in progress* as the state **after** it finishes, which is not obviously the same
  as bucketing the `LOADOUT` stage itself into `PENDING_LOADOUT`. **Recorded as evidence, not as
  an answer — nobody has ruled, and this register does not rule.** `meetings/` files are
  retrospective records, never commitments.
- **Blocked:** the DAS map's status filter, its marker colours and its KPI counters; the Yard
  Operations / Dylen board's status chip and its per-status action labels ("Mark Available for
  Loadout" / "Start Loadout" vs "Off-load"), which are keyed off the same bucket. A wrong bucket
  puts the wrong button on Dylan's card.
- **Owner:** product team — Lisette Anzaldo (DAS board) with Dylan Masterson (yard/loadout, the
  playbook owner in [daily-loading-value-engine.md](daily-loading-value-engine.md)).


- **Update 2026-09-10 (SCRUM-252 backfill):** **the code cited above is superseded, and the DAS
  half of this question is answered.** The four-bucket collapse described here existed at commit
  `b69d5406`; at `fbaebb9f` the DAS map no longer buckets at all — it renders the sub-job's own
  `dasStage`, all nine values, reusing the DAS jobs board's `JOB_STAGE_LABELS` /
  `JOB_STAGE_BADGE_STYLES`. So `das-map.service.ts:21` is no longer the site of a four-bucket
  map. Decided by the developer and recorded at
  [`../decisions/2026-09-10-das-map-shows-all-nine-job-stages.md`](../decisions/2026-09-10-das-map-shows-all-nine-job-stages.md)
  (`status: reference` — binding on implementation, open to being overruled by Lisette), on the
  ground this entry already records: the four buckets were written **for Dylan**, because he has
  no action to take, and that reasoning does not carry to a Dispatch Manager who does.
  **This entry stays open for the Yard Operations / Dylen half** — which stages fall in which
  bucket there, and whether `LOADOUT` reads as *Pending Loadout* or *In Progress*, is still
  unruled, and that is where the wrong button on Dylan's card comes from.
  **The `CANCELLED` defect under it is fixed (2026-09-10), and the fix adds a fifth bucket.**
  `map-das-job-to-dylen-card.ts` had no `CANCELLED` case and fell through to
  `default: return 'pending-loadout'`, so a cancelled sub-job was badged *Pending Loadout*,
  counted in that filter, and unfilterable. `DylenJobDisplayStatus` and `DylenJobFilter` now
  carry a `cancelled` member. **Worth recording precisely, because the first reading overstated
  it:** the loadout *actions* were never available — `isDasStageLoadoutLocked` has always held
  `CANCELLED`, mirroring the API's `LOCKED_STAGES` — so this was a labelling, counting and
  filtering defect, not one that could send the yard to load a cancelled crane.
  **This does not answer the question above.** Dylan's board now has five display statuses
  rather than four, because leaving `CANCELLED` inside `pending-loadout` is untenable whichever
  way the rest are decided; **which stages fill the other four, and whether `LOADOUT` reads as
  *Pending Loadout* or *In Progress*, is still unruled and still owned by Lisette Anzaldo with
  Dylan Masterson.** Detail at [`../../aidlc/SCRUM-252/spec.md`](../../aidlc/SCRUM-252/spec.md) §12 Q5a.

## DAS map panel is also mounted on the Yard Operations / Dylen dashboard — written for DAS only

- **Status:** resolved 2026-09-10 — **yes, the toggle ships, and it is the same panel.** Developer decision, not a named product owner’s; see the resolution note at the end of this entry
- **Asked:** 2026-09-10 — raised while reviewing branch `scrum-252` ("Implement map view in DAS").
  As with the *DAS map job status buckets* entry above, the branch has no `.ai/aidlc/SCRUM-252/`
  folder and no `processed.log` row; it never ran the loop.
- **Question:** **Does the Yard Operations / Dylen dashboard get a Map View toggle, and if so is
  it the same map as the DAS board's — same assets, same date scope, same detail sidebar — or a
  yard-scoped view of its own?** One line settles it: "same map on both boards", "yard-scoped map
  on Dylen", or "no map on Dylen". The shipped branch takes the first reading — the Dylen view
  imports and renders the identical `DasMapPanel` unchanged
  (`apps/web/src/features/dylen-dashboard/views/dylen-dashboard-view.tsx`:12, :40–42, :116–117,
  commented *"Same toggle as the DAS board, same panel"*).
- **Sources checked:** **The map story is written for DAS only, and the Dylen dashboard story
  has no map in it.** [daily-allocation-system.md](daily-allocation-system.md) → *USER STORY :
  Live Asset Map View* (`status: unverified`) is voiced *"As a Dispatch Manager"* and its first
  acceptance criterion places the toggle *"in the DAS header"*; none of its seven criteria
  mention the yard, Dylan, or a second host surface. [`../assets/tool-and-rigging.md`](../assets/tool-and-rigging.md)
  → *EPIC 2 / Story 5 : Dylan's Yard Dashboard* (`status: unverified`, updated 2026-05-26) is the
  only written specification of that dashboard — nine acceptance criteria, a left jobs panel and
  a right tools/rigging panel, a date picker, live tool counters — and **not one of them mentions
  a map, a location, or an asset position**. [yard-operations-jz.md](yard-operations-jz.md)
  (`status: unverified`) is a loadout punch list with no map item.
  [daily-allocation-INDEX.md](daily-allocation-INDEX.md) (the DAS conflict stub) does not raise
  it. `decisions/` holds nothing on either board's surface set. `../README.md` → *What this vault
  does not contain* does not exclude it, so this is a gap, not policy.
- **Note:** the two stories have different actors and different jobs-to-be-done — a Dispatch
  Manager monitoring field equipment for any date, versus a Yard Manager running a loading
  operation from one screen. That they might want the same map is plausible and is exactly the
  kind of inference this register does not make.
- **Blocked:** whether the Dylen map ships at all, and if it does whether it must be scoped to
  the yard rather than the whole fleet.
- **Owner:** product team — Lisette Anzaldo (DAS board) with Dylan Masterson (yard dashboard).


- **Resolution 2026-09-10 — yes, the toggle ships, and it is the same panel.** See
  [`../decisions/2026-09-10-map-view-ships-on-the-yard-operations-dashboard.md`](../decisions/2026-09-10-map-view-ships-on-the-yard-operations-dashboard.md)
  (`status: reference`). Ground given: the two screens are one workflow — same sub-jobs, same
  day's allocations, same `dasStage` — so a yard-scoped variant would mean maintaining two
  answers to "where is unit 104", the same divergence this ticket already had to fix once in the
  job-stage badge. **Resolved by the developer, not by a named product owner, and decided against
  everything catalogued above** — `../assets/tool-and-rigging.md` → *Story 5* still specifies
  Dylan's dashboard with no map in any of its nine criteria, and the two user stories still have
  different actors. **It is recorded so Dylan Masterson can be shown it and say no**; until he
  has seen it this is a developer's call standing in for his. Reversing it is one import and one
  switch. Ticket record: [`../../aidlc/SCRUM-252/spec.md`](../../aidlc/SCRUM-252/spec.md) §12 Q4.

## Cancelled sub-jobs on the DAS map — drawn with a Cancelled badge, or removed?

- **Status:** open
- **Asked:** 2026-09-10 — raised while reviewing branch `scrum-252`.
- **Question:** **Should a sub-job at `dasStage: CANCELLED` still be drawn on the DAS / Yard
  Operations map?** One line settles it: "cancelled work stays on the map, badged" or "cancelled
  work is removed from the map". The shipped branch takes the first — the map query
  (`getSamsaraLinkedAllocationsByDate`, `apps/api/src/service/das/das.repository.ts`) applies no
  `dasStage` filter, so a cancelled job's units are drawn and badged *Cancelled*.
- **Sources checked:** **Nothing written rules on it.** [daily-allocation-system.md](daily-allocation-system.md)
  → *USER STORY : Live Asset Map View* names no exclusion of any kind — the word *cancel* does
  not appear anywhere in that file, nor in [`../projects-jobs/job-project-das.md`](../projects-jobs/job-project-das.md),
  the other DAS candidate. The *DAS map job status buckets* entry above records that `CANCELLED`
  maps to its own display bucket, but bucketing a status is not a ruling on whether the row is
  drawn, and that entry is itself open. `decisions/2026-08-20-archive-instead-of-delete-app-wide.md`
  (`status: reference`) settles that removal is soft app-wide, which is why the row survives to be
  queried at all — it says nothing about map visibility.
  [`../projects-jobs/gaps.md`](../projects-jobs/gaps.md) → *Job CANCELLED / ON_HOLD / INVOICED
  transitions unwired* (open) asks who may cancel and what cascades, and is unanswered.
- **Blocked:** map contents; the answer also decides whether the `CANCELLED` display bucket in
  the entry above is reachable on the map at all.
- **Owner:** product team — Lisette Anzaldo.

## `isActive` on a job schedule interval — what it means, and what it should hide — see projects-jobs

- **Status:** open
- **Asked:** 2026-09-10 — raised while reviewing branch `scrum-252`. Recorded here because the
  branch adds a **second, divergent** reading of the same flag on the same board.
- **Question:** the product question is
  [projects-jobs/gaps.md — Schedule day deactivate orphans SubJob / allocations](../projects-jobs/gaps.md#schedule-day-deactivate-orphans-subjob--allocations)
  (open, owner Lisette Anzaldo), which already asks whether *"hiding the day from the DAS board
  (filter on active intervals) is enough while SubJob rows linger"*. **What is new:** the two DAS
  surfaces now disagree with each other. The jobs board filters
  `jobScheduleInterval: { isActive: true }` (`apps/api/src/service/das/das.repository.ts`:664);
  the new map query (`getSamsaraLinkedAllocationsByDate`, same file) does not — so a day hidden
  from the jobs board still draws its units on the map. One line settles the practical half:
  "the map applies the same `isActive` filter as the jobs board", or "the map deliberately shows
  deactivated days".
- **Sources checked:** **`isActive` is not defined in the product record at all** — no vault file
  states what deactivating a schedule day means to the user or what it should hide; the flag
  appears in the vault only inside `gaps.md` registers and unrelated integration field maps
  (`../accounting/nexgen-quickbooks-integration/01-fcc-connector-field-mapping.md`,
  `../payroll/fcc-union-code-configuration.md`), never as a DAS rule.
  [daily-allocation-system.md](daily-allocation-system.md) does not mention active or inactive
  days. `decisions/` holds nothing on it. Related:
  [projects-jobs/gaps.md — Converted-quotation schedule days](../projects-jobs/gaps.md#converted-quotation-schedule-days--checked-by-default-and-what-that-puts-on-the-das-board) (open).
- **Blocked:** map contents on deactivated days; consistency between the two DAS surfaces.
- **Owner:** product team — Lisette Anzaldo.

## Overnight DAS shifts — may a shift cross midnight, and what does the board show when it does?

- **Status:** open
- **Asked:** 2026-09-10 — raised while reviewing branch `scrum-252` ("Implement map view in
  DAS"). As with the three entries above, the branch has no `.ai/aidlc/SCRUM-252/` folder and
  no `processed.log` row; it never ran the loop.
- **Question:** **May a DAS shift's end time fall on the calendar day after its start time
  (18:00 → 02:00), and if so what must the board's shift clock show while it is running?**
  One line settles it: "a DAS shift may cross midnight — the board must carry it into the next
  day", or "a DAS shift never crosses midnight; an end time earlier than the start is a data
  error". The shipped branch takes the second reading **implicitly and without saying so** —
  `apps/web/src/features/das/map-section/utils/shift-time.ts` builds both ends of the shift
  from the same `date` (`shiftInstant(date, startTime)` / `shiftInstant(date, endTime)`), so an
  18:00 → 02:00 shift resolves its end to 02:00 **that morning**, `describeRemainingTime`
  finds `end - now <= 0` and the unit reads **`Completed`** for the entire time it is actually
  being worked. `isToday` additionally gates the clock to the start date, so the shift also
  goes dark the moment real midnight passes.
- **Sources checked:** **Nothing written rules on a DAS shift crossing midnight.**
  [daily-allocation-system.md](daily-allocation-system.md) (`status: unverified`) →
  *USER STORY : Live Asset Map View* names no shift clock, no remaining-time display and no
  day boundary; its multi-shift language elsewhere is about *"multiple shifts within a day"*,
  which does not say whether one of them may end on the next. [`../projects-jobs/job-project-das.md`](../projects-jobs/job-project-das.md)
  (the other DAS candidate, a punch list) says nothing. `decisions/` holds no DAS shift
  decision. `../README.md` → *What this vault does not contain* does not exclude it, so this is
  a gap, not policy.
- **Note — the record leans the other way, and the codebase already disagrees with the
  branch.** Cross-midnight work is treated as ordinary everywhere it has been examined:
  [`../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md`](../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md)
  (`status: verified`, Corrina Bustos in writing) adjudicates how a shift that crosses midnight
  is *paid*, which presumes such shifts exist; Brian Petros, twice, asks for the date to be
  visible because *"a lot of the jobs go past midnight"*
  ([`../admin/gaps.md`](../admin/gaps.md) → *Time display*, [`../assets/gaps.md`](../assets/gaps.md)
  → *The fleet day*). Two shipped modules already treat `end < start` as a legitimate overnight
  rather than an error — `apps/web/src/features/projects/jobs/job-details/schedule/utils/schedule-date-utils.ts`
  and `apps/api/src/service/employee/shift-hours.util.ts`. **None of that is a ruling on what
  the DAS board displays**, and this register does not infer one: the pay question and the
  display question are different questions, and the second has never been asked.
- **Blocked:** the map sidebar's shift clock and its `Completed` / `running` / `Not started
  yet` states; the card's `activeShift` selection, which uses the same instants; and any KPI
  counter keyed off whether a unit is currently working.
- **Owner:** product team — Lisette Anzaldo (DAS board), with Corrina Bustos where the answer
  has to agree with the payroll day.

## DAS map detail sidebar — what a unit's "resources" must list is unwritten

- **Status:** open
- **Asked:** 2026-09-10 — raised while reviewing branch `scrum-252`.
- **Question:** **What must the DAS map's detail sidebar show for a unit — which fields, and
  is "every allocation in the same set" the right resource list?** One line settles the second
  half: "the sidebar lists the set's crew and equipment" or "the sidebar lists only <X>".
  **The set-membership rule itself is NOT part of this gap — it is decided**; see *Sources
  checked*. What is open is only what the sidebar renders. The shipped branch groups every
  allocation sharing `(subJobId, shiftNumber, setResourceId)` under the asset and lists them as
  its crew and equipment (`apps/api/src/usecase/das/das-map.service.ts`:19, :94, :112).
- **Sources checked:** **The grouping key is sourced and verified; the sidebar contents are
  not.** [`../decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md`](../decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md)
  (`status: verified`, product owner on Jira `SCRUM-877` comment `23066`) → *Q2 — Set-resolution
  mechanism* states the rule directly: *"A per-day job can contain multiple sets per shift, and
  each shift will have either exactly one crane or no crane, along with an oiler and other
  resources such as operators, loads, and employees"*, and authorises resolution on
  `setResourceId` with no new table. That covers `(subJobId, shiftNumber, setResourceId)`
  including the shift term. **But it is a decision about labor-data linking on tickets, not
  about a map sidebar** — it says what a set *is*, never what a screen shows for one.
  [daily-allocation-system.md](daily-allocation-system.md) (`status: unverified`) →
  *USER STORY : Live Asset Map View* offers only *"Clicking an icon opens a detail sidebar with
  full job and asset information"* — "full information" names no field and does not say crew or
  equipment appear at all. No other vault file describes this sidebar.
- **Blocked:** the sidebar's field list; whether a set with no crane, or an allocation with a
  null `setResourceId`, gets a card of its own.
- **Owner:** product team — Lisette Anzaldo.
## Branch fix/das-fixes — pre-checklist plan / permit / PO links open in a new browser tab

- **Status:** open
- **Asked:** 2026-09-11 — PR review of branch `fix/das-fixes` (no ticket, no `.ai/aidlc/` folder); tcg-scrum escalation. Commit `712921dfb`.
- **Question:** should a plan, permit or PO link on the DAS job card leave the board in place and open in a **new browser tab**? The branch intercepts the left-click and routes it through `window.open(href, '_blank')` (`apps/web/src/features/das/middle-section/jobs/utils/open-checklist-href.ts`), applied to the pre-checklist dropdown row, the slot badge and the All Permits modal. Answerable in a line, and it is the first place in the app where a link is forced off the SPA router.
- **Sources checked:** **nothing written, anywhere.** Grep of all vault files for *"new tab"*, *"window.open"*, *"opens in a new"* returns three hits, none about DAS: two transcript turns about adding a **navigation** tab to the sidebar, and one `fcc-nexgen-quote-entry.md` line about an FCC window. [daily-allocation-system.md](daily-allocation-system.md):84-95 (`unverified`) — the only DAS specification, and the source of the pre-checklist story — says the card *"shows a pre-checklist with items: Assets Assigned, Resources Assigned, Lift Plan, Site Plan, Travel Plan green if complete, red if missing"* and that it *"recalculates in real time"*. It never says the items are links, let alone where a click lands. The conflict stub [daily-allocation-INDEX.md](daily-allocation-INDEX.md) adds nothing on navigation. `../decisions/` — the two post-save navigation notes ([2026-09-01](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md), [2026-08-20](../decisions/2026-08-20-post-save-navigation-convention.md), both `reference`, Fouzan Shakil) decide where **Save** lands and say nothing about link targets or tabs. Jira not checked (no Jira MCP in this session).
- **Note:** the rationale in the commit message — *"leave the DAS board intact"* — is real (the board holds date, filters and drag state that a route change discards), and Lisette is the user who would lose it. That is an argument, not a source, and it applies to every link out of the board, not only these three.
- **Blocked:** nothing — reversible. Recorded so that "DAS links open a new tab" does not become an app-wide convention by merge, and because it is the one behaviour on this branch a user notices immediately.
- **Owner:** Lisette Anzaldo, as the DAS user whose board state this protects.

## Branch fix/permits-pos — the DAS pre-checklist "PO#" row stops watching vendor allocations and can no longer flag anything

- **Status:** open
- **Asked:** 2026-09-11 — PR review of branch `fix/permits-pos` (no ticket, no `.ai/aidlc/` folder); tcg-scrum escalation. Commit `dd184508c` (*align trackable status colors and permit-linked PO checklist count*). Author: Fouzan Shakil.
- **What changed (code, not product intent):** Before this commit, `buildPoSummaryItem` in `apps/web/src/features/das/middle-section/jobs/utils/build-pre-checklist-items.ts` took `allocatedVendorAssetIds` + `linkedVendorAssetIds` from `useJobVendorAssetPoAssignments` and marked the **PO#** row incomplete when allocated vendor assets lacked a PO (`isRequired: totalCount > 0 && assignedCount < totalCount`). The commit **removed those params and that hook call** from `job-pre-checklist-button.tsx`, and rewrote the row to count **distinct non-archived POs linked to checklist permits** (`linkedPoUuid` / `linkedPoId` from `JobPermitAssignmentsService`, via `purchaseOrderPermitLinks`). With that math, `assignedCount === totalCount` always, so the row hard-codes `isRequired: false` — it can display a count but **cannot warn**. Vendor-slot `PoChecklistBadge` is unchanged; only the job-card pre-checklist aggregate is rewritten. The same commit also flips trackable `OPEN` from amber to grey (`ArtifactStatusPill`) — that colour half lives in [../projects-jobs/gaps.md → *Branch fix/permits-pos — Plan notes…*](../projects-jobs/gaps.md#branch-fixpermits-pos--plan-notes-beside-crew-comments-a-lift-plan-package-upload-category-open-drawn-grey-and-shared-permitscode--plancode-detail-routes) (c).
- **Bug / review blocker:** a job with a sub-hauled (vendor) crane and **no** vendor PO used to show PO# red/incomplete; it now shows a permit-linked count (often 0 or only permit POs) with **no incompleteness signal**. The case the review log asked to flag is the case that stops being flagged. PR review verdict: **do not ship** until (a)/(b) are answered.
- **Question:** two, each answerable in a line. **(a)** Should the job card's **PO#** row count **distinct non-archived POs linked to the job's checklist permits** (Travel / FAA / Encroachment / Sub Hauler, via `purchaseOrderPermitLinks`), as the branch now does — or **vendor assets allocated to the job that carry a PO**, as it did before? The two count different things about different entities and only coincide by accident. **(b)** Given the new counting, `assignedCount === totalCount` always, so the row hard-codes `isRequired: false`. **A pre-checklist row that can never be incomplete is a row that can never warn.** Is a PO something dispatch must be *chased* about before the job day, or only something to *see*?
- **Sources checked:** **the DAS specification has no PO row at all, and the one written statement about a PO checklist describes the behaviour this commit removes.** [daily-allocation-system.md](daily-allocation-system.md):84-95 (`unverified`, 2026-04-30 — the only DAS specification) lists the pre-checklist as exactly five items — *"Assets Assigned, Resources Assigned, Lift Plan, Site Plan, Travel Plan green if complete, red if missing"* — with no PO among them; the row is an unsourced addition that predates this branch. The nearest thing to a source is [../erp-review-log.md](../erp-review-log.md):295 (`status: unverified`; AI-extracted from the 2026-05-05 meeting, never adjudicated, and the file's own header warns that nothing in it says whether an item was accepted): *"**a PO requirement/checklist on vendor allocations**, flagging whether a PO is required or already created"* — **vendor allocations**, and **flagging**, which is precisely what (a) drops and (b) makes impossible. The same log at :263-264 asks to *"replace scattered permit checkboxes with an expandable checklist covering travel permits, lift plan, safety, FAA"* — a permit checklist, and it names no PO. `../vendors-agencies/purchase-order.md` and [../projects-jobs/quote-to-job-lifecycle.md](../projects-jobs/quote-to-job-lifecycle.md):35, :62 place the **customer** PO on the job/schedule tab and the **vendor/permit** PO elsewhere, and neither says either belongs on a dispatch pre-checklist. [../decisions/2026-09-11-permit-approval-requires-linked-po.md](../decisions/2026-09-11-permit-approval-requires-linked-po.md) (`reference`) requires a linked PO to **approve a permit** — which is the coupling the new counting leans on, but it is a gate on the permit form, not a statement about what dispatch is shown. Grepped every non-transcript vault file on `pre-checklist` · `PO#` · `checklist`. Jira not checked (no Jira MCP in this session).
- **Related, already open — do not duplicate:** [*Branch fix/das-fixes — pre-checklist plan / permit / PO links open in a new browser tab*](#branch-fixdas-fixes--pre-checklist-plan--permit--po-links-open-in-a-new-browser-tab) is about where that same row's link lands, not what it counts. [../vendors-agencies/gaps.md → *Purchase orders at three levels*](../vendors-agencies/gaps.md#purchase-orders-at-three-levels--joe-and-ryan-on-tape-nothing-written) is the parent question of which PO is which.
- **Blocked:** nothing hard, but the row is a dispatch warning surface that currently warns about nothing, and the 72-hour incomplete-pre-checklist notification ([daily-allocation-system.md](daily-allocation-system.md):93) reads the same completeness model.
- **Owner:** Lisette Anzaldo (DAS), with Liz Lopez (PO process) and Brian Petros for whether a missing vendor PO is a dispatch blocker.

## Branch fix/uat4-schedule-copy-allocation — a DAS slot the quotation never priced: the job Resources tab now hides materialised $0 rows, the board still allocates against them

- **Status:** open
- **Asked:** 2026-09-12 — PR #537 review (branch `fix/uat4-schedule-copy-allocation`, no ticket; `aidlc/processed.log` Path C row dated 2026-09-12, line 91); tcg-scrum escalation. Commit `c6716980d` (*job Resources tab shows only the quotation's priced lines*). Author: Syed Haris. Raised in UAT-4 when a Rigger the quotation never carried appeared on a job's Resources tab at $0.
- **What changed (code, not product intent):** two catalog-derived sources of unpriced rows are now hidden from the job's read-only Resources tab: (a) the $0 `job_resources` rows that `apps/api/src/usecase/projects/materialize-job-resources.ts` creates on conversion for every billable `SubCategoryAssociatedResource` the quotation did not persist (*"operational requirements, not priced line items"*, by its own comment — introduced in commit `7b9d4818f` *made allocation functional on DAS*, no ticket, no vault source), dropped in `mapJobResourcesToFormValues` when `quotationResourceId` is null **and** rate/amounts are $0; and (b) the virtual $0 children the shared quotation `ResourcesTab` synthesises from catalog associations, now behind a `catalogAssociations` prop the job tab passes `false`. **Deliberately unchanged:** the materialised rows still exist and the DAS allocation panel still shows the slot. So the job now has two views of its own resources — the tab shows the quote's priced lines, the board shows the catalog's requirement set — and nothing written says which is the job's resource list.
- **Question:** three, each answerable in a line. **(a)** When a quotation does **not** carry a catalog-associated resource for a crane — because the salesperson removed an *Optional* one, because it sits at a depth the quotation never persisted, or because the association was added to the catalog after the quote was built — should dispatch still see an **allocation slot** for it on the DAS panel? **(b)** If yes, is the job's Resources tab meant to show that slot too (the operational requirement set), or only the quotation's priced lines (as PR #537 renders it)? **(c)** If the salesperson deliberately removed an *Optional* associated child on the quotation, does conversion re-adding it at $0 override that choice?
- **Sources checked:** **the DAS spec says slots flow from the quotation; the built materialisation says they flow from the catalog; no source addresses a slot the quote never priced.** [daily-allocation-system.md](daily-allocation-system.md):46 (`unverified`, 2026-04-30, the only DAS specification): *"a side panel showing all required slots (crane, operator, oiler, support load, etc.) flowing from the quotation"* — the nearest written statement, and it names the **quotation** as the source, not the sub-category catalog. [../projects-jobs/project-module/02-view-manage-job-details.md](../projects-jobs/project-module/02-view-manage-job-details.md):22, :48-50 (`unverified`): resources *"pulled from the quotation"*, parent-child, *"assign a specific unit to a resource slot"* — same direction, silent on unpriced slots. [../projects-jobs/quote-to-job-lifecycle.md](../projects-jobs/quote-to-job-lifecycle.md):113 (`unverified`, from the unadjudicated `erp-review-log.md`): the job *"inherits quote data as a starting point, then allows operational updates"* — a starting point, but it does not say the catalog adds to it. [../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md](../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md) (`reference`, not verified): *Always Included* children cannot be removed from a quotation, *Optional* ones can, and its own *What this does not settle* names **the rule for job dispatchers** as unbuilt and unspecified — Ehtesham's *"same is going to be the functionality later on for job dispatchers"* is a forward statement, not a decision. Read against (c): materialisation re-adds every billable association regardless of inclusion type, so an *Optional* child a salesperson removed comes back as a DAS slot. [../decisions/2026-08-31-quotation-associated-child-merge-semantics.md](../decisions/2026-08-31-quotation-associated-child-merge-semantics.md) (`reference`) is the quotation-side merge only. [../decisions/2026-08-31-quotation-qty-not-das-sets.md](../decisions/2026-08-31-quotation-qty-not-das-sets.md): convert-to-job copies the tree **1:1** — *"one quotation root → one job-resource root → one DAS / Yard Operations set"* — which describes roots and qty, not children the quotation lacks. [daily-allocation-INDEX.md](daily-allocation-INDEX.md) — the conflict stub; the punch list [../projects-jobs/job-project-das.md](../projects-jobs/job-project-das.md) adds nothing on slots. **Legacy precedent, fact not decision:** FCC's *Unit Type Defaults* inject the crew **types** (Operator, Oiler, Tractor, Trailer, Driver) into the job's Resources tab *and* the estimate together when a unit type is chosen, and everything injected *"may be changed or deleted"* ([fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md) §9 :424-446, :614-618) — i.e. in FCC the crew slots and the priced lines are one co-populated set, editable per job, not two views. Jira not checked (no Jira MCP in this session).
- **Related, already open — do not duplicate:** [*Requested vs dispatched resources — Melissa stated it, the vault still says the opposite*](#requested-vs-dispatched-resources--melissa-stated-it-the-vault-still-says-the-opposite) is the parent axis — the job's requested list vs what dispatch actually sends — with Melissa McNutt's assent on the 2026-06-17 recording; this entry is the narrower case of a slot that was never requested at all. [*Default crew per unit, overridable per job*](#default-crew-per-unit-overridable-per-job) is the standing-crew shape of the same "where do slots come from" question. [../projects-jobs/gaps.md → *Branch fix/uat4-schedule-copy-allocation — job Resources tab hides rows the quotation never priced*](../projects-jobs/gaps.md#branch-fixuat4-schedule-copy-allocation--job-resources-tab-hides-rows-the-quotation-never-priced--see-dispatchgapsmd) is this entry's projects-jobs pointer.
- **Blocked:** nothing hard — the change is display-only and reversible. Recorded because the tab and the board now disagree about the job's resource list, and because whichever answer comes back decides whether `materializeAssociatedJobResources` (and the backfill script that shares it) is a requirement or a bug.
- **Owner:** Lisette Anzaldo (whose allocation panel it is) with Melissa McNutt (who owns the *"we don't re-quote"* rule the parent entry records). Product team.

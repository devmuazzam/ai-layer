---
title: Dispatch — open questions
status: reference
kind: gaps
updated: 2026-10-07
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
- **See also (2026-09-12):** [decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md](../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md) — an *Optional* catalog association the quotation never priced is no longer materialised as a job resource or DAS slot (Syed Haris, CodingCops, `reference`). It narrows the child case; it does **not** settle this entry or the two-record rule.
- **See also (2026-09-15/16):** Joe Schacatano separates *quoted line items* from *dispatch resources* altogether — principle decided 2026-09-16 ([../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md)); the model is open in [../quotations/gaps.md](../quotations/gaps.md) → *Quote line items vs dispatch resources…*. The "requested resources" record this entry asks about is therefore no longer the quotation's resource list. Does not settle this entry.
- **See also (2026-09-17):** Brian's FCC deep dive ([../quotations/fcc-billing-resource-configuration-deep-dive-2026-09-16.md](../quotations/fcc-billing-resource-configuration-deep-dive-2026-09-16.md) §12, §17, §32). FCC job OM60788 shows requirement → assignment in practice:
  - type-level placeholders on the quote;
  - real crane and tractors, plus an Operator, an Oiler and four 3rd Men, on the job;
  - `FMS_JOB_RESOURCES` pairing units with employees;
  - a **40 Ton unit (4003) with an operator and no billing line** on the same job.

  The document recommends that Dispatch can add operational-only requirements. A recommendation, not a decision.

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

- **Conflict logged 2026-09-19 — two UAT rows pull opposite ways on double-booking a *person*, and both sit behind a decision neither cites. Do not fold this into the asset-side question above.**
  [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) carries the pair, and says so itself:
  **DONE** *One person cannot be assigned to two jobs*, [UAT 5] — *"Overlaps are refused server-side, backed by window SQL.
  **Read alongside the UAT 4 #31 row under Not done** — the two requests pull in opposite directions."* `das-allocations.service.ts:290-299`.
  **NOT DONE** *People still available under an 11:30 shift*, [UAT 4 #31] — *"**Two readings, opposite answers.**… If the ask was
  '_other_ people stay available when someone is on an 11:30 shift', it is done. If it was '_the same_ person stays available for a
  later non-overlapping shift', it is not — and that reading **directly contradicts UAT 5's 'one person cannot be assigned to two
  jobs'**, which is done. Needs the person who raised it."* The register's own resolution is to carry it as NOT DONE *"so the sheet
  has only two statuses"*, which it states **does not resolve the ambiguity**.
  **Both rows are behind [../decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md](../decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md)
  → *DAS allocation (new)* item 5**, which already draws the line the two rows are arguing over:
  *"**Same non-vendor resource cannot fill two slots in one shift** on the same sub-job. Drop and upsert both block. Shift 1→2
  copies … still allowed. **Cross-job non-overlapping double-book** … **is unchanged.** Vendors are out of this rule."*
  On that reading UAT 5 is satisfied (same shift, same sub-job: blocked) **and** the second reading of UAT 4 #31 is satisfied
  (cross-job, non-overlapping: still allowed) — they only look contradictory because neither row states its scope.
  **This is not an adjudication.** The decision is `status: reference` (Ehtesham Anwar, CodingCops, *"open to being overruled by
  TCG"*), no TCG person has confirmed it, and the register was written three days later without citing it. Whoever raised UAT 4 #31
  still has to say which reading they meant — the register is right about that. A UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md).
  **Scope note:** this is the **employee** case. This entry's own double-booking material (Brian Petros, *"we could double book"*,
  `daily-allocation-system.md`:48) is about the same **crane** on two non-overlapping jobs. Same words, different object.

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

- **Status:** answered 2026-10-01 by syed.haris (CodingCops), **not yet confirmed by TCG** —
  [../decisions/2026-10-01-das-shift-runs-to-estimated-end-and-shows-on-every-day.md](../decisions/2026-10-01-das-shift-runs-to-estimated-end-and-shows-on-every-day.md)
  (`reference`): the clock ends at the Estimated End, and a shift shows on every day it runs,
  greyed on the days after its own. Lisette should confirm. What was built and what is still
  missing: the 2026-10-01 build note below, and *Shifts that run past their own day — what is
  built, what is still missing*.
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

- **Build note (2026-09-29, revised 2026-09-30; branch `feat/schedule-datetime-holdover`, not
  yet merged) — the job Schedule tab now lets an Estimated End fall on any later day.** The
  date+time dropdown lets the dispatcher put the **Estimated End only** on the row's date or any
  later day, so a shift may run past 24 hours (syed.haris, 2026-09-30 — see *Schedule times on a
  later day*); Start and On Site stay on the row's date. The end's day is now **stored**
  (`job_schedule_intervals.estimated_end_date` / `second_shift_estimated_end_date`, migration
  `20260930120000`); rows saved before it keep the derived rule (end at or before On Site ⇒ next
  day), so no backfill. One helper (`@tcg/shared` `shiftEndDate` / `shiftWindow`) gives every
  logic reader the end's day: the allocation window, working hours, the shift-end instant the
  payroll overlay uses. The API refuses a *changed* shift whose end, on its day, is not after On
  Site (`apps/api/src/usecase/jobs/job-schedule-timeline.ts`). **This does not answer the
  question above** — the DAS map clock still resolves an 18:00 → 02:00 end to that morning.
- **Build note (same branch, TCG-186) — the DAS availability lock now treats an overnight shift
  correctly.** It used to wrap 18:00 → 02:00 onto the **same** date (blocking 00:00–02:00 of the
  morning *before*) and never looked at the next day. It now compares real date-time windows and
  checks the day before and after, so the shift blocks the next morning at drop and Copy time.
  The board's resource status stays per date (last night's crew keeps its *Previous Night* tag;
  [daily-allocation-system.md](daily-allocation-system.md) names the tag, not the status).
  A conflict on another date is never cleared by *Reassign*: the save is refused and names the
  other job's date. Otherwise reassigning onto an early shift could delete last night's
  allocation, and its tickets, while that crew is still working it. The **map clock** (question
  above) is unchanged.
- **Build note (2026-10-01, same branch, not merged) — the ruling above, on the DAS only.** A
  shift is *live* on every calendar day its window (Start or On Site → Estimated End) touches
  (`@tcg/shared` `shiftWindowTouchesDay`; API `liveOnDayIntervalsFilter` / `shiftLiveOnDay`).
  - **DAS map:** the feed returns every shift live on the date, with its real window
    (`startAt` / `endAt`), its own date and a `continuing` flag. The clock counts down to the
    Estimated End on its own day, so an 18:00 → 02:00 shift runs to 02:00 and a three-day shift
    to its last day. Continuing units are greyed in the sidebar and details, and a time on another
    day prints its date (`2:00 AM, Sep 9`).
  - **DAS jobs board:** `GET /das/sub-jobs?includeContinuing=true` adds earlier days' sub-jobs
    still running into the date. The board shows them as a greyed, dashed, read-only *Continuing
    from Mon, Oct 5* card below the day's own jobs; *Open Mon, Oct 5* goes to that day with the
    job expanded. They are left out of
    the stage counts. A shift ending on a later day reads `Shift 1(7:00AM - 6:00PM · ends Oct 7)`
    on every card, and the Send Ticket table shows the end's date.
  - **DAS side panels:** a shift still running into the date is listed in the resource's
    bookings (`continuing`, marked in the popup), and the expanded job's availability split
    compares its window, so a crane on day 2 of a multi-day shift is not offered for an
    overlapping shift. Its **status that date is unchanged** — only the date's own bookings set
    Assigned / On Site — because the summary counts, the dispatch packet's available pool and the
    status filter read that status (found in review 2026-10-01; an earlier draft changed it and
    dropped last night's overnight crew from the packet). The *Previous Night* tag is unchanged
    (open: what it means, see *Shifts that run past their own day*).
  - **Leave:** dropping an employee onto a shift that runs over a day they have approved leave
    warns (*On Leave During This Shift*, Assign anyway). A warning, not a lock: the API still has
    no leave check on save.
  - **Not changed:** the yard board (Dylan) — it still lists jobs by row date only; see the
    entry below for everything still missing.

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

- **Status:** open (residual only) — partially resolved 2026-09-12, see [decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md](../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md). Decided by Syed Haris (CodingCops developer, PR #541 `765fffc8c`); `status: reference`, not TCG-confirmed. **Settled:** (a) for the *Optional* case — no slot for an Optional association the salesperson removed; conversion no longer materialises it and a cleanup script removes earlier rows; (b) the Resources tab mirrors the **quotation's priced lines**; (c) moot — conversion no longer re-adds it. **Still open** — see the residual line at the end of this entry.
- **Asked:** 2026-09-12 — PR #537 review (branch `fix/uat4-schedule-copy-allocation`, no ticket; `aidlc/processed.log` Path C row dated 2026-09-12, line 92); tcg-scrum escalation. Commit `c6716980d` (*job Resources tab shows only the quotation's priced lines*). Author: Syed Haris. Raised in UAT-4 when a Rigger the quotation never carried appeared on a job's Resources tab at $0.
- **What changed (code, not product intent):** two catalog-derived sources of unpriced rows are now hidden from the job's read-only Resources tab: (a) the $0 `job_resources` rows that `apps/api/src/usecase/projects/materialize-job-resources.ts` creates on conversion for every billable `SubCategoryAssociatedResource` the quotation did not persist (*"operational requirements, not priced line items"*, by its own comment — introduced in commit `7b9d4818f` *made allocation functional on DAS*, no ticket, no vault source), dropped in `mapJobResourcesToFormValues` when `quotationResourceId` is null **and** rate/amounts are $0; and (b) the virtual $0 children the shared quotation `ResourcesTab` synthesises from catalog associations, now behind a `catalogAssociations` prop the job tab passes `false`. **Deliberately unchanged:** the materialised rows still exist and the DAS allocation panel still shows the slot. So the job now has two views of its own resources — the tab shows the quote's priced lines, the board shows the catalog's requirement set — and nothing written says which is the job's resource list.
- **Question:** three, each answerable in a line. **(a)** When a quotation does **not** carry a catalog-associated resource for a crane — because the salesperson removed an *Optional* one, because it sits at a depth the quotation never persisted, or because the association was added to the catalog after the quote was built — should dispatch still see an **allocation slot** for it on the DAS panel? **(b)** If yes, is the job's Resources tab meant to show that slot too (the operational requirement set), or only the quotation's priced lines (as PR #537 renders it)? **(c)** If the salesperson deliberately removed an *Optional* associated child on the quotation, does conversion re-adding it at $0 override that choice?
- **Sources checked:** **the DAS spec says slots flow from the quotation; the built materialisation says they flow from the catalog; no source addresses a slot the quote never priced.** [daily-allocation-system.md](daily-allocation-system.md):46 (`unverified`, 2026-04-30, the only DAS specification): *"a side panel showing all required slots (crane, operator, oiler, support load, etc.) flowing from the quotation"* — the nearest written statement, and it names the **quotation** as the source, not the sub-category catalog. [../projects-jobs/project-module/02-view-manage-job-details.md](../projects-jobs/project-module/02-view-manage-job-details.md):22, :48-50 (`unverified`): resources *"pulled from the quotation"*, parent-child, *"assign a specific unit to a resource slot"* — same direction, silent on unpriced slots. [../projects-jobs/quote-to-job-lifecycle.md](../projects-jobs/quote-to-job-lifecycle.md):113 (`unverified`, from the unadjudicated `erp-review-log.md`): the job *"inherits quote data as a starting point, then allows operational updates"* — a starting point, but it does not say the catalog adds to it. [../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md](../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md) (`reference`, not verified): *Always Included* children cannot be removed from a quotation, *Optional* ones can, and its own *What this does not settle* names **the rule for job dispatchers** as unbuilt and unspecified — Ehtesham's *"same is going to be the functionality later on for job dispatchers"* is a forward statement, not a decision. Read against (c): materialisation re-adds every billable association regardless of inclusion type, so an *Optional* child a salesperson removed comes back as a DAS slot. [../decisions/2026-08-31-quotation-associated-child-merge-semantics.md](../decisions/2026-08-31-quotation-associated-child-merge-semantics.md) (`reference`) is the quotation-side merge only. [../decisions/2026-08-31-quotation-qty-not-das-sets.md](../decisions/2026-08-31-quotation-qty-not-das-sets.md): convert-to-job copies the tree **1:1** — *"one quotation root → one job-resource root → one DAS / Yard Operations set"* — which describes roots and qty, not children the quotation lacks. [daily-allocation-INDEX.md](daily-allocation-INDEX.md) — the conflict stub; the punch list [../projects-jobs/job-project-das.md](../projects-jobs/job-project-das.md) adds nothing on slots. **Legacy precedent, fact not decision:** FCC's *Unit Type Defaults* inject the crew **types** (Operator, Oiler, Tractor, Trailer, Driver) into the job's Resources tab *and* the estimate together when a unit type is chosen, and everything injected *"may be changed or deleted"* ([fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md) §9 :424-446, :614-618) — i.e. in FCC the crew slots and the priced lines are one co-populated set, editable per job, not two views. Jira not checked (no Jira MCP in this session).
- **Related, already open — do not duplicate:** [*Requested vs dispatched resources — Melissa stated it, the vault still says the opposite*](#requested-vs-dispatched-resources--melissa-stated-it-the-vault-still-says-the-opposite) is the parent axis — the job's requested list vs what dispatch actually sends — with Melissa McNutt's assent on the 2026-06-17 recording; this entry is the narrower case of a slot that was never requested at all. [*Default crew per unit, overridable per job*](#default-crew-per-unit-overridable-per-job) is the standing-crew shape of the same "where do slots come from" question. [../projects-jobs/gaps.md → *Branch fix/uat4-schedule-copy-allocation — job Resources tab hides rows the quotation never priced*](../projects-jobs/gaps.md#branch-fixuat4-schedule-copy-allocation--job-resources-tab-hides-rows-the-quotation-never-priced--see-dispatchgapsmd) is this entry's projects-jobs pointer.
- **Blocked:** nothing hard — the change is display-only and reversible. Recorded because the tab and the board now disagree about the job's resource list, and because whichever answer comes back decides whether `materializeAssociatedJobResources` (and the backfill script that shares it) is a requirement or a bug.
- **Owner:** Lisette Anzaldo (whose allocation panel it is) with Melissa McNutt (who owns the *"we don't re-quote"* rule the parent entry records). Product team.
- **Residual, open 2026-09-12:** **(a)** for an association **added to the catalog after the quote was built**, or **at a depth the quotation never persists** — both still materialise as $0 *Always Included* rows (`materializeAssociatedJobResources` skips only `isRequired = false`), so for those the board shows a slot the tab hides. And **post-conversion resync** between quotation and job — nothing changes an existing job when the quote or catalog changes afterwards; belongs with [*Requested vs dispatched resources*](#requested-vs-dispatched-resources--melissa-stated-it-the-vault-still-says-the-opposite). **Owner:** unchanged — Lisette Anzaldo with Melissa McNutt. Product team.

- **Conflict logged 2026-09-19 — the UAT register's DONE row for this is stale, and it re-opens a question that was settled the next day.**
  [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → **DONE** *Removed rigger no longer shows as $0 on the project*,
  [UAT 3]: *"Unpriced orphan rows are dropped from the view. **Caveat: the fix is display-only — DAS still creates the unpriced
  slot, and whether dispatch should see it is left open in the commit.**"* sha **`c6716980d`**.
  That caveat was true of `c6716980d` alone. `c6716980d` is the **PR #537 display-only half** — the job Resources tab showing
  only the quotation's priced lines — and it was **followed by `765fffc8c` in PR #541**, which stopped conversion materialising
  the row at all (`if (!association.isRequired) continue;`). Both are recorded in
  [../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md](../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md)
  (Syed Haris, `status: reference`), which names this entry under `resolves:`. **So the register's "whether dispatch should see
  it is left open" is answered for the Optional case:** an Optional association the quotation never priced *"is not a job resource
  and not a DAS allocation slot"*. The register cites the earlier commit and not the later one, and never cites the decision.
  **What genuinely remains open is narrower than the register implies** and is already stated in *Residual, open 2026-09-12*
  above: only the **Always Included** cases — an association added to the catalog after the quote was built, or at a depth the
  quotation never persists — still materialise as $0 rows, because `materializeAssociatedJobResources` skips only
  `isRequired = false`. Nothing here is adjudicated and no status on the register is changed; this records that a DONE row's
  caveat is one commit out of date. A UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md).

## Branch fix/12-sep-uat — ticket assignment/reschedule/reminder emails: field set, deep link shape, entity id

- **Status:** open
- **Asked:** 2026-09-12 — PR review Path C branch `fix/12-sep-uat` (no ticket); tcg-scrum escalation.
- **Question:** three lines. **(a)** Must assignment, reschedule, and 1-day reminder emails include **location, report-to, special instructions, dispatcher, role, equipment** (and anything else on Figma `7348:217715`, `7348:217787`, `7353:217909`)? **(b)** Is the ticket CTA deep link an **absolute** URL `/tickets/{ticketId}` with **empty href when no ticket exists yet**? **(c)** For notification `entityId`, should the system prefer **ticket UUID** over **allocation UUID** when both exist?
- **Sources checked:** `.ai/aidlc/SCRUM-817/spec.md` REQ-02–REQ-05 (`unverified` — Jira/Figma cited, §12 empty) — branded emails with *"job site, schedule, equipment"* and Figma nodes; web route **`/tickets/[code]`** (business code), not UUID; **silent** on report-to, special instructions, dispatcher, absolute URL, pre-ticket empty link, entity-id precedence. [daily-allocation-system.md](daily-allocation-system.md) ticket lifecycle (`unverified`) — dispatch tracking, not email payload. `vault/decisions/` — no ticket-email URL note. Jira `SCRUM-817` not reachable (403 suspended-payment).
- **Blocked:** Path C email enrichment on `fix/12-sep-uat`; parity with SCRUM-817 if that ticket is the authority.
- **Owner:** product team — Lisette Anzaldo (dispatch); confirm Figma field list with whoever owns SCRUM-817.

## Branch fix/das-permits-quotations — DAS pre-checklist greens plan/permit rows only on trackable APPROVED

- **Status:** open
- **Asked:** 2026-09-14 — PR review of Path C branch `fix/das-permits-quotations` (no ticket, no `.ai/aidlc/` folder); tcg-scrum escalation. Commit `750facb08` (*gate DAS pre-checklist green on trackable APPROVED*). Author: Fouzan Shakil.
- **What changed (code, not product intent):** `build-pre-checklist-items.ts` now sets a linked Lift/Site plan row's `completedAt` (green / Done) only when `planTrackableStatus === 'APPROVED'`, and counts Travel / FAA / Encroachment / Sub Hauler toward the aggregate Permits `assignedCount` only when each required type is APPROVED. Linked-but-not-approved rows render as Assignment/pending (Clock) via `checklist-row.tsx`. The DAS legend's Done meaning is therefore applied to those rows; presence of a link alone is no longer enough.
- **Question:** two, each answerable in a line. **(a)** Is a plan or permit **complete** on the job-card pre-checklist when it is *linked*, or only when trackable status is **APPROVED** (as the branch now does)? **(b)** The only DAS specification names **two** states (green / red). The build now has **three** — Required (unlinked), Assignment/pending (linked, not approved), Done (APPROVED). Is the third state intended?
- **Sources checked:** **nothing defines "complete" for a plan/permit checklist row.** [daily-allocation-system.md](daily-allocation-system.md):84-95 (`unverified`, 2026-04-30 — the only DAS specification) — *"Lift Plan, Site Plan, Travel Plan green if complete, red if missing"* — two colours, no approval bar. Conflict stub [daily-allocation-INDEX.md](daily-allocation-INDEX.md) and punch list [../projects-jobs/job-project-das.md](../projects-jobs/job-project-das.md) add nothing on checklist completeness. [../decisions/2026-09-11-quote-to-project-permits-plans-flow.md](../decisions/2026-09-11-quote-to-project-permits-plans-flow.md) (`reference`) locks the Open → … → Approved trackable chain but does **not** bind checklist colour to it. [../projects-jobs/project-module/05-create-and-track-permits.md](../projects-jobs/project-module/05-create-and-track-permits.md):26, :38 (`unverified`) — *"valid permits"* for a **publish** gate, not checklist chrome. Grepped non-transcript vault files on `pre-checklist` · `complete` · `APPROVED` · `legend`.
- **Related, already open — do not duplicate:** [*Branch fix/permits-pos — the DAS pre-checklist "PO#" row…*](#branch-fixpermits-pos--the-das-pre-checklist-po-row-stops-watching-vendor-allocations-and-can-no-longer-flag-anything) asks whether a pre-checklist row must *chase* or only *show* — neighbouring rows, same completeness model the 72-hour incomplete notification ([daily-allocation-system.md](daily-allocation-system.md):93) would read. [../projects-jobs/gaps.md → *Branch fix/permits-pos — Plan notes… OPEN drawn grey*](../projects-jobs/gaps.md#branch-fixpermits-pos--plan-notes-beside-crew-comments-a-lift-plan-package-upload-category-open-drawn-grey-and-shared-permitscode--plancode-detail-routes) (c) is the legend/presentation twin.
- **Blocked:** nothing hard — display-side and reversible. Recorded because it changes when a dispatcher is warned before job day, and because the 72-hour incomplete-pre-checklist notification shares the same completeness model.
- **Owner:** Lisette Anzaldo (DAS).

## Yard loadout — client asks recorded on tape, never ticketed: review/QC sign-off, "no equipment required", loader timing, swap alerts, back-in-yard notification, punch-list leftovers

- **Status:** open
- **Asked:** 2026-09-14 — close-out of `SCRUM-LOADOUT-UNASSIGNED` (PRs #571, #573; no Jira issue); tcg-scrum sweep of the loadout transcripts while writing [../decisions/2026-09-14-yard-unassigned-slots-not-loadable.md](../decisions/2026-09-14-yard-unassigned-slots-not-loadable.md). None of these has a ticket, a spec, or a vault statement beyond the transcript line; none is built.
- **Question:** **which of the following does product want, and in what order?** One line per item — *yes / no / later* — settles each. (Speaker note: in these auto-transcripts Dylan's voice is labelled `Brian Petros`; ehtesham.anwar addresses that speaker as Dylan at [../meetings/transcripts/2026-05-12-loading-figma-demo.md](../meetings/transcripts/2026-05-12-loading-figma-demo.md):142 and :162.)
  1. **A review / QC step and a "who loaded it" sign-off.** Dylan: *"When one of my guys finished loading it, will he sign off on it and I'll be able to see… that that person was the one that loaded it"* and *"a review by me to where I go review and I hit the final complete"* — [2026-05-12-loading-figma-demo.md](../meetings/transcripts/2026-05-12-loading-figma-demo.md):239-251; ehtesham.anwar at :249: *"We'll add another status for you and then we'll write rules based on that"*, and at :347-348 a checklist-style *"review system for Dylan"* for offloading. The shipped workflow has no review state and records no loader identity.
  2. **A "no equipment required" flag / skip yard ops for one-day jobs.** Dylan, same file :150-152 (*"no equipment required… so I'm not like clicking through every single one"*); Melissa McNutt, [2026-07-01-erp-sprint-reviews-loading-workflow.md](../meetings/transcripts/2026-07-01-erp-sprint-reviews-loading-workflow.md):161-184 (*"the cranes that are just doing one day jobs coming in and out, Dylan won't need to mark them as like loaded and loaded"*). Overlaps the next entry, *Should the yard board show jobs that have nothing to load*, which asks the board-visibility half; this item is the **flag on the job**.
  3. **Loadout time logging, loader assignment, timer KPI.** Brian Petros, [2026-04-09-dispatch-scheduling-figma-demo.md](../meetings/transcripts/2026-04-09-dispatch-scheduling-figma-demo.md):293 (*"a button that he could log his time… a true KPI per job… even for yard loading"* — ehtesham.anwar: *"we can do that"*); Ryan Adams, [2026-05-12…](../meetings/transcripts/2026-05-12-loading-figma-demo.md):107-118 (tag a returned truck, *"assign any yard person I wanted to"*, timer from tag to done).
  4. **Alerts on a crane swap and on crew-swapped rigging.** Dylan, [2026-05-07-loading-and-project-module-overview.md](../meetings/transcripts/2026-05-07-loading-and-project-module-overview.md):262-264 (*"they put a 265… but that rigging needs to go there… some kind of system to alert me as soon as it happens"*) and :293-297 (crew moves a husky bar between loads without telling the yard).
  5. **"Crane back in yard" notification, and returned trucks sort to the top.** Dylan, [2026-04-30-dispatch-scheduling-figma-demo.md](../meetings/transcripts/2026-04-30-dispatch-scheduling-figma-demo.md):179 (*"a message saying 275's back in the yard… so my guys know, okay, we can go offload this now"*); Ryan Adams, [2026-05-12…](../meetings/transcripts/2026-05-12-loading-figma-demo.md):230-232 (returned trucks *"pop up at top"*, cleared ones drop off).
  6. **Punch-list leftovers** — [yard-operations-jz.md](yard-operations-jz.md):20 *"Offload forcefully – rename"* (what to) and :21 *"Notification and unassign item if the item is not off loaded – if its assigned to another job"*. Neither is built; the second overlaps item 4.
     - **2026-10-20, rename covered:** *"Offload forcefully – rename"* is now covered by [../decisions/2026-10-20-yard-steps-read-dispatch-and-return-to-yard.md](../decisions/2026-10-20-yard-steps-read-dispatch-and-return-to-yard.md) (Fouzan Shakil, CodingCops developer, `reference` — TCG has not confirmed). The step is renamed Return to Yard, and force-complete reads *"Return to Yard force-completed"*. The second half of item 6, notify and unassign an item not returned, is still open.
- **Sources checked:** every `meetings/transcripts/` file tagged `module/dispatch` on *loadout* · *offload* · *yard*; [yard-operations-jz.md](yard-operations-jz.md) (`unverified`, 2026-07-15 — the only yard punch list); [../assets/tool-and-rigging.md](../assets/tool-and-rigging.md) Stories 4–5 (loading checklist, live counters — no review state, no loader identity); [daily-allocation-system.md](daily-allocation-system.md) (`unverified` — DAS, silent on yard sign-off); `.ai/aidlc/SCRUM-903/spec.md`, `SCRUM-LOADOUT-UNASSIGNED/spec.md` — neither scopes any of the six. `../decisions/` — no note on any of them. Jira not checked (no Jira MCP in this session).
- **Related, already open — do not duplicate:** [*DAS map job status buckets — nine SubJob stages collapsed to four, and LOADOUT counted as pending*](#das-map-job-status-buckets--nine-subjob-stages-collapsed-to-four-and-loadout-counted-as-pending) (a review state would be a new bucket — decide the set first); the four entries below from the same close-out.
- **Blocked:** nothing — every item is unbuilt and unticketed. Recorded so that six things the client said on tape stop living only on tape.
- **Owner:** Brian Petros / Lisette Anzaldo for priority; Dylan Masterson for each item's shape. Product team.

## Items assigned but never loaded out vanish silently at offload

- **Status:** open
- **Asked:** 2026-09-14 — close-out of `SCRUM-LOADOUT-UNASSIGNED`; found while writing [../decisions/2026-09-14-yard-unassigned-slots-not-loadable.md](../decisions/2026-09-14-yard-unassigned-slots-not-loadable.md), whose *What this does not settle* points here.
- **What the code does (fact, not intent):** `resolveRemainingOffloadQuantity` in `apps/api/src/service/das-loadout/das-loadout-quantity.util.ts:28-29` returns `0` for any item with no `loadoutAt` — so an **assigned** slot that Dylan's crew skipped at loadout (a trailer that never went) has nothing to offload, the offload completes, and the sub-job closes with **no record that the item never left the yard**. That decision note stops an *unassigned* slot from being loaded; it says nothing about an assigned one that was skipped.
- **Question:** when offload completes for a shift on which an assigned asset/employee slot was **never loaded out**, should the system **(a) block** completion, **(b) complete but flag** the skipped item (on the card, in a notification, or on the job record), or **(c) complete silently**, as now? One letter settles it.
- **Sources checked:** [yard-operations-jz.md](yard-operations-jz.md):13 (*"Different assets can be loaded out at different times"* — partial loadout is expected; silent on items never loaded), :21 (notify/unassign an item **not offloaded** — the opposite edge); [2026-05-12-loading-figma-demo.md](../meetings/transcripts/2026-05-12-loading-figma-demo.md):192, ehtesham.anwar: *"people when they were leaving the yard, they said, okay, we have all of this equipment, but once they came back, they didn't check it. So that also triggers some different notifications for Dylan"* — the nearest statement, about the **return** checklist, not the loadout one; [../assets/tool-and-rigging.md](../assets/tool-and-rigging.md) Story 5 (live In-Use/Available counters — inventory, not a skipped-item rule). `.ai/aidlc/SCRUM-903/spec.md` Q3 covers jobs that never enter yard loadout at all, not a job that entered it and skipped an item. Nothing written names the case.
- **Related, already open — do not duplicate:** the entry above (item 1, review/sign-off — a review step is one way (b) could surface); [*DAS map job status buckets…*](#das-map-job-status-buckets--nine-subjob-stages-collapsed-to-four-and-loadout-counted-as-pending) (REQ-10's *Partial Loadout* label reads an unassigned slot as *not loaded*; a skipped assigned slot reads the same way until offload, then disappears).
- **Blocked:** nothing hard — the sub-job still completes. Recorded because it is the one path where a loadout discrepancy leaves no trace.
- **Owner:** Dylan Masterson. Product team.

## Manual vs automatic offload — Dylan asked for manual, dev said automatic, Dylan also asked for geo auto-offload; built = manual

- **Status:** open
- **Asked:** 2026-09-14 — close-out of `SCRUM-LOADOUT-UNASSIGNED`; tcg-scrum transcript sweep.
- **Question:** **is offload a manual step Dylan's crew performs, an automatic transition from Samsara / ticket data, or automatic with a manual override?** Three stated positions, none reconciled, none written outside the transcripts:
  - **Manual** — Dylan (labelled `Brian Petros`), [2026-04-30-dispatch-scheduling-figma-demo.md](../meetings/transcripts/2026-04-30-dispatch-scheduling-figma-demo.md):161-165: *"I'd like to physically drag it. Like, we offload it, it's back in the yard. I'd like to be the one to let the system know"* — because a crane back late with no yard crew *"might stay available, but it's not because we didn't get a chance to offload it"*.
  - **Automatic, Mark Available the only manual step** — ehtesham.anwar, [2026-05-12-loading-figma-demo.md](../meetings/transcripts/2026-05-12-loading-figma-demo.md):326-330: *"it's not just going to work with the GPS tracker, it's also going to get tied to the tickets as well… The only manual step that is available for Dylan is to make sure that every job is allocated properly"*.
  - **Geo auto-offload** — Dylan, same file :325: *"once the job's done, crane's back in the yard and notifies that the crane's back in the yard and the job's finished, it's going to auto go to the offload?"* — asked as a question, answered *"Yes"*; and :179 of the 2026-04-30 file asks for a back-in-yard message, which is the notification half of the same thing.
  - **Built:** offload is manual (the Yard Ops card's *Off-load* action; nothing auto-triggers it from Samsara or tickets). Whether that is the answer or a placeholder is unwritten.
- **Sources checked:** the three transcript passages above; [yard-operations-jz.md](yard-operations-jz.md):20 (*"Offload forcefully – rename"* — presupposes a manual offload exists, says nothing about an automatic one); [daily-allocation-system.md](daily-allocation-system.md) (`unverified` — the DAS stage progression, no offload trigger); [../assets/tool-and-rigging.md](../assets/tool-and-rigging.md) (checklist, no trigger); `../decisions/` — none. Samsara integration status not checked here. Jira not checked (no Jira MCP in this session).
- **Related, already open — do not duplicate:** items 5 and 6 of the *client asks recorded on tape* entry above (the back-in-yard notification; *"Offload forcefully"* rename); [*Items assigned but never loaded out vanish silently at offload*](#items-assigned-but-never-loaded-out-vanish-silently-at-offload) (what offload completion checks, whichever way it is triggered).
- **Blocked:** nothing — built behaviour works. Recorded because Dylan's own stated reason for manual (late returns, no crew) is exactly the case an automatic trigger would get wrong, and nobody has ruled.
- **Owner:** Dylan Masterson. Product team.

## Should the yard board show jobs that have nothing to load — one-day, no-equipment, trucking-only

- **Status:** open
- **Asked:** 2026-09-14 — close-out of `SCRUM-LOADOUT-UNASSIGNED`; the decision note's Q3/Q8 keep such jobs *markable* and explicitly do not decide whether they are *shown* ([../decisions/2026-09-14-yard-unassigned-slots-not-loadable.md](../decisions/2026-09-14-yard-unassigned-slots-not-loadable.md) → *What this does not settle*).
- **Question:** **does a job with no asset/employee slot to load and no additional tools appear on Dylan's yard board at all?** Three positions on tape: **(a) hide it** — Melissa McNutt, [2026-07-01-erp-sprint-reviews-loading-workflow.md](../meetings/transcripts/2026-07-01-erp-sprint-reviews-loading-workflow.md):161-184 (*"Dylan really only knows, needs to know stuff that's getting loaded… the cranes that are just doing one day jobs coming in and out, Dylan won't need to mark them"*); **(b) show it, because trucking still needs him** — Dylan (labelled `Brian Petros`), [2026-05-12-loading-figma-demo.md](../meetings/transcripts/2026-05-12-loading-figma-demo.md):150-172 (*"I would still need to look at some… if we're going to send a certain trailer out, and I'll need to know that that trailer needs to be emptied"*; wants an *"additional trucking needed"* identification); **(c) two views** — ehtesham.anwar, same file :175: *"we'll only show jobs that require you to do something about them on this yard view and then on the yard view that you have, Dylan, we are going to show all of the jobs that are going out on that particular day"*. Built: every sub-job on the day is shown; Mark Available is disabled when nothing is loadable (REQ-03). A one-line answer — *(a), (b) or (c)* — settles it.
- **Sources checked:** the three passages above; [yard-operations-jz.md](yard-operations-jz.md) (silent); [daily-allocation-system.md](daily-allocation-system.md) (DAS-side, silent on the yard board's job set); `.ai/aidlc/SCRUM-903/spec.md` Q3 (*Jobs that never go through yard loadout/offload* — open; if such jobs are hidden from the board they can never be marked, so they never auto-complete: the two questions answer together); `.ai/aidlc/SCRUM-LOADOUT-UNASSIGNED/spec.md` §13. `../decisions/` — none. Jira not checked.
- **Related, already open — do not duplicate:** item 2 of the *client asks recorded on tape* entry above (the *"no equipment required"* **flag** — this entry is the **board** half); `SCRUM-903` §12 Q3 (ticket-owned, stays there).
- **Blocked:** nothing hard. Recorded because (a) and (b) are opposite instructions from two client stakeholders, and the build currently does neither cleanly.
- **Owner:** Lisette Anzaldo with Dylan Masterson. Product team.

## Attachment delete runs S3 before the DB row — a guard rejection orphans the row (engineering follow-up)

- **Status:** open
- **Asked:** 2026-09-14 — close-out of `SCRUM-LOADOUT-UNASSIGNED` (PR #571 `46ef574f3` fixed the trigger, not the ordering). Engineering follow-up, not a product question — filed here because the broken thumbs surface on Dylan's loadout cards.
- **What the code does:** `apps/api/src/presentation/attachments/attachments.controller.ts:145-146` — `remove()` calls `storageService.deleteObject(attachment.fileName)` **first**, then `attachmentsService.delete(id, userId)`. If the DB delete is rejected after the object is gone (a guard, a tenant-scope miss, a lookup 404), the row survives with no object behind it and renders as a broken thumbnail. Between **2026-08-25 and 2026-09-14** the JOB-feature id lookup 404'd for loadout photos (fixed in PR #571, *resolve JOB feature ids by job code or sub-job id*), so every delete attempted in that window through this path orphaned its row.
- **Question:** two, engineering-owned. **(a)** Reverse the order (DB row inside a transaction, S3 delete after commit, tolerate a missing object) — or soft-delete the row first and reap S3 asynchronously? **(b)** Sweep and remove the rows orphaned in the 2026-08-25 → 2026-09-14 window (rows whose `fileName` no longer resolves in S3)?
- **Sources checked:** the controller above; `.ai/claude/contexts/api.md` (no rule on external-side-effect ordering); [../decisions/2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md) (`reference` — archive as the app-wide removal action; attachments are not in its scope list, so it neither requires nor forbids a hard delete here). No product source is needed for (a); (b) is a data fix.
- **Blocked:** nothing — new deletes work since PR #571. Recorded so the ordering is fixed rather than rediscovered at the next 4xx.
- **Owner:** engineering — Syed Haris. Not a product question.

## DAS substituted-asset Pre-checklist — Required should open create-and-link Travel Permit

- **Status:** open for (b)–(d). **(a) resolved — see [decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md](../decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md)** — 2026-09-15, Ehtesham Anwar: do **not** mint from Required; **link the conversion travel permit onto the allocated asset**. Required opens Permits/Plans when that travel is cancelled or missing. `AssetPermitModal` is gone.
- **Asked:** 2026-09-14 — DAS substituted-asset Pre-checklist; engineer report that Travel Permit shows amber **Required** with no create flow
- **Question:** four related points. **(a)** Confirm the DAS slot Pre-checklist carve-out against [decisions/2026-09-11-permit-classes-job-only-until-sept-15.md](../decisions/2026-09-11-permit-classes-job-only-until-sept-15.md) item 4 (*do not ship working direct-create or permit↔asset linking before 15 Sep 2026*) — the board now opens Create & Link from **Required** on a filled asset slot (job-scoped `TRAVEL_CITY_STREET_PERMIT`, then `POST …/permit-assignments`). Is that allowed as a DAS-only carve-out on/after the deadline, or should the affordance stay hidden until General-class / asset-link work is signed off? **(b)** Which sub-category's `permitRequired` governs badge visibility — requested slot, substituted asset, or either (current build: **either**)? **(c)** Must a missing travel permit **block** allocation on a permit-required slot, or only chase via the checklist (same *chase vs show* question as the PO row below)? **(d)** When an annual / blanket / fleet permit already covers the substituted unit, should **Required** suppress?
- **Sources checked:** this build's `PermitChecklistBadge` / `AssetPermitModal` (mirrors vendor `PoChecklistBadge`); [confirmations-playbook.md](confirmations-playbook.md) §6 and [travel-permits-playbook.md](travel-permits-playbook.md) (substitution re-opens the permit / per-crane application); [../projects-jobs/gaps.md](../projects-jobs/gaps.md) *Asset on a permit…* (265-for-90); [decisions/2026-09-11-permit-classes-job-only-until-sept-15.md](../decisions/2026-09-11-permit-classes-job-only-until-sept-15.md); [decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md](../decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md); adjacent [*Branch fix/permits-pos — the DAS pre-checklist "PO#" row…*](#branch-fixpermits-pos--the-das-pre-checklist-po-row-stops-watching-vendor-allocations-and-can-no-longer-flag-anything).
- **Blocked:** (a) settled. (b)–(d) Brian Petros / Liz Lopez / Lisette Anzaldo — product.
- **Owner:** Lisette Anzaldo (DAS dispatcher); carve-out (a) → Ehtesham Anwar.

## Dispatch resources vs quote lines — pointer, owned by quotations

- **Status:** open — answer in [../quotations/gaps.md](../quotations/gaps.md) → *Quote line items vs dispatch resources — the associated set auto-fills the quote, and the sales owner says dispatch resources must not be quoted*. Principle decided 2026-09-16 ([../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md)).
- **Asked:** 2026-09-15 — Joe Schacatano, ERP live demo 01 ([../meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md](../meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md) §2): oiler, operator and semi are *"the resources to tie to the assets when it's dispatched"* and are never charged. Bears on where DAS slots come from if they stop being quotation rows (today: [../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md](../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md)). Pointer only.

## One asset standing for several resource types (derating, configurations) — pointer, owned by assets

- **Status:** open — **answer owned by assets**, per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*.
- **Asked:** 2026-09-17 — ingest of the 2026-09-16 call.
- **Why it lands here too:** which assets may fill a DAS slot for a quoted resource type depends on the answer. Joe Schacatano (4:59): a crane may be *"derated to cover other equipment sizes in the same type"*. He also said one crane can be dispatched in two configurations (27:33).
- **Read:** [../assets/gaps.md → *One asset, one type…*](../assets/gaps.md#one-asset-one-type--but-one-crane-in-several-configurations-how-does-an-asset-stand-for-more-than-one-resource-type)

## Removing an allocation after its time has passed — UAT 5 asks for a clock guard the delete path does not have

- **Status:** open
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register into the module registers. Not a ticket question: no ticket asks for a time-based delete guard.
- **Question:** may a dispatcher **remove an allocation whose time has already passed**? If not: passed relative to **what** — the shift start, the shift end, the business day, the ticket's own step times — and **who**, if anyone, may override it?
- **Sources checked:**
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → NOT DONE ***Do not allow removal when the time is gone***, [UAT 5]. This is one of the register's **three headline defects**, quoted in its own *Read this first*: *"Allocations can still be removed after the time has passed. The delete check looks at payroll locks and whether tickets were sent — **it never looks at the clock**."* Its row adds: *"There is no date or time comparison anywhere in the method. Past-time blocks exist only for Start Loadout and Mark Available, not for removing an allocation."* `das-allocations.service.ts:487-543`.
  - [../decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md](../decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md) → *DAS allocation (new)* — the most recent and most detailed statement of when an allocation may be removed or stolen, and **it names only two gates plus yard state**: item 3, the yard lock (*"marked available for loadout, or already loaded out… cannot be reassigned"*); item 4, *"the prior row is deleted, including when the **source** sub-job is `TICKET_SENT` or `ticketsLocked`. **Payroll-locked tickets still refuse.**"* **No clause anywhere keys on wall-clock time.** So the UAT ask is not contradicted by the decision — it is simply a condition the decision never contemplated.
  - `grep` across [../decisions/](../decisions/) and every `*/gaps.md` for a time-passed delete rule: nothing. The nearest written time gates are on **different actions** — Start Loadout and Mark Available — which is what makes the absence look like an oversight rather than a choice.
  - Related, already open — do not duplicate: [*Items assigned but never loaded out vanish silently at offload*](#items-assigned-but-never-loaded-out-vanish-silently-at-offload) and [*Manual vs automatic offload…*](#manual-vs-automatic-offload--dylan-asked-for-manual-dev-said-automatic-dylan-also-asked-for-geo-auto-offload-built--manual) are about what happens to a row at end of day, not about who may delete one.
- **Note:** a UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md). Two things are tangled in this one row and should be untangled before anyone builds: **the defect** (the register's finding that no clock check exists, which is a fact about the code) and **the rule** (whether there should be one, and keyed to what — which nobody has decided). The defect can be scheduled; the rule cannot, because a guard with the wrong boundary will block legitimate same-day corrections.
- **Blocked:** any fix for the *Read this first* defect — it cannot be written without the boundary; payroll's reliance on allocation rows surviving the day they describe.
- **Owner:** Lisette Anzaldo (whose board it is) with Brian Petros / Corrina Bustos for the payroll-side consequence of a deletion after the fact.

## Sales Persons in the DAS Employees tab — dispatchability is an employee-type attribute we do not have

- **Status:** open — **answered in substance 2026-10-20 by Corrina Bustos** ([../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md](../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md), `verified`, Q5). Who may go on a job ticket: field crew, HDRs through their can-also-fill list, and the Crane Superintendent. *"NEVER yard techs."* By her "only", Sales is not on that list. **Same-day follow-up:** managers who are Local 12 members may go on a ticket too (Jeff Kelley, Kyle Harlow). Everyone goes on in **the position they fill on that job**; there is no Crane Superintendent slot. **Left to the developer:** where the attribute lives, now that the role is the job (role attribute, can-also-fill list, or both). See the dated line below. *(Was: open, 2026-09-19 – 2026-10-20.)*
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register into the module registers. Raised in **UAT 1**, still not done.
- **Question:** which employees appear in the DAS **Employees** tab? The UAT ask is narrow (*"Sales Persons should not be displayed"*) but the rule behind it is not: is **dispatchability** a property of the employee, of their **employee type**, or of a portal role — and where is it stored?
- **Sources checked:**
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → NOT DONE *DAS Employees must not list Sales Persons*, [UAT 1]. The session sheet: *"In DAS, Sales Persons should not be displayed in the Employees tab."* The register's finding: *"The employee query filters only on terminated and permanent status — **there is no role or employee-type exclusion anywhere in the DAS employees path**, and the panel groups by type without filtering."* `das.repository.ts:773`.
  - **The shape of the answer already exists upstream, in FCC, and the ERP has nowhere to put it:** [../payroll/fcc-employee-master-reference-data.md](../payroll/fcc-employee-master-reference-data.md) §2 — the vendor's own import rule is that *"Each employee type can either be selected to be **dispatched on jobs/quotes, on work orders, on both, or for neither** (for example, office employees)"*, the field being `Dispatchable on: Jobs/Quotes (J), Work Orders (W), Both (B), or None (N)`. That page states the consequence plainly: *"**`Dispatchable on` is an attribute of the employee *type*** — a field the ERP has nowhere."* All 15 FCC rows currently carry `B`.
  - Related, already open — answer these together or the fix will be built twice: [../payroll/gaps.md → *Employee types — FCC holds several per employee; we store one*](../payroll/gaps.md#employee-types--fcc-holds-several-per-employee-we-store-one) (an employee has several types with one primary; we collapse to one) and [../payroll/gaps.md → *Field role vs portal role — one list in FCC, three representations in TCG*](../payroll/gaps.md#field-role-vs-portal-role--one-list-in-fcc-three-representations-in-tcg) (`DepartmentRole` vs `EmployeeType` vs `CraftRoleType`). **A per-employee-type `Dispatchable on` is the natural home for this UAT row, and neither of those entries is settled.**
  - [../decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md](../decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md) *Q2 — employee status vocabulary* gates assignability by **status** (`ON_LEAVE` → *"visible, not assignable"*; `PENDING_ONBOARDING` / `INACTIVE` / `TERMINATED` → not assignable) — a different axis from role, and the only assignability rule the vault holds.
  - [../decisions/](../decisions/) — nothing excludes a role or type from DAS.
- **Note:** a UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md). Hard-coding a *Sales Person* exclusion in `das.repository.ts` would satisfy the row and leave the rule unwritten, and the next non-dispatchable type (office, accounting, safety) repeats it. Say what the attribute is before filtering on it.
- **Blocked:** the UAT 1 row itself; anything that needs to know which employees are dispatchable — DAS employee panel, allocation search, the dispatch packet.
- **Owner:** Lisette Anzaldo (who should see whom on the board) with Brian Petros for where the attribute lives on the employee record.
- **Pointer:** [../payroll/gaps.md](../payroll/gaps.md) → *DAS dispatchability is an employee-type attribute — pointer, owned by dispatch*.
- **Update 2026-10-20 (Corrina Bustos, Teams, in writing — answered in substance):** see
  [../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md](../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md)
  (`verified`). Asked *"Apart from field crew and HDRs, does anyone else ever go on a job ticket?"*
  (examples: yard techs as driver or 3rd man, the crane superintendent, a manager who operates),
  she replied *"only crane superintendent would also qualify to get a job ticket. NEVER yard
  techs."*
  - **Who is ticket-eligible:**
    - field crew;
    - HDR mechanics, through their can-also-fill list (*"can also be called out into the field to
      be a 3rd man or rigger"*);
    - the Crane Superintendent.

    Yard techs are never eligible, and nor, by her "only", are Sales, Accounting, Safety, HR or
    Dispatch staff. That covers this UAT row's *"Sales Persons should not be displayed"*, as a
    rule rather than a one-off exclusion.
  - **The upstream model is now answered:** a person has one main role plus a can-also-fill list
    ([../payroll/gaps.md → *Employee types*](../payroll/gaps.md#employee-types--fcc-holds-several-per-employee-we-store-one)),
    and the role is the job ([../payroll/gaps.md → *Field role vs portal role*](../payroll/gaps.md#field-role-vs-portal-role--one-list-in-fcc-three-representations-in-tcg)).
    Dispatchability is therefore read from the **role**, and from the positions a person may fill.
    It is not read from a separate employee type.
  - **Left to the developer:** where the attribute is stored, and how the DAS query filters on it.
  - **Not settled:**
    - ~~**Managers who operate.**~~ **Closed by the follow-up below.** FCC holds three
      `Management`-type employees who also hold `Operator`. Her "only" read as excluding them,
      but she did not speak to that example directly.
    - **Is the DAS Employees tab exactly the ticket-eligible set?** This entry reads it so.
      Lisette Anzaldo, the owner here, has not confirmed it.
    - **Work-order dispatchability.** FCC's `W` value is not covered: Q5 asked about job tickets
      only.
- **Update 2026-10-20, later (Corrina Bustos's follow-up, Teams, in writing):** recorded in the
  same decision note → *The follow-up, same day*, F3–F4.
  - **F3, the Crane Superintendent's position — answered:** *"Crane super would be assigned in
    what position he was for that particular job."* He goes on the ticket as Operator, Rigger and
    so on, and **"Crane Superintendent" is not a slot type**. He is eligible through the field
    positions on his can-also-fill list.
  - **F4, managers who operate — answered, yes:** *"Jeff Kelley and Kyle Harlow are managers but
    are also in the local 12 union so they are allowed to operate."* The stated basis is **Local
    12 membership**. Like the superintendent, they go on in the position they fill.
  - **What this means for this entry:** eligibility is read from **the positions a person may
    fill**: their main role plus their can-also-fill list. A Sales Person has no field position on
    either, so the UAT row's exclusion follows from the model, not from a hard-coded filter.
  - **Remainders:**
    - **The third manager.** FCC holds three `Management` + `Operator` employees. She named two,
      and the third is not identified in the vault.
    - **Local 12 as a check?** Is union membership a rule the ERP checks, or simply the reason
      `Operator` is on those managers' can-also-fill lists? Not stated. It is a developer decision.
    - **Unchanged:** whether the DAS Employees tab is exactly the ticket-eligible set (Lisette),
      and work-order dispatchability.

## Job ticket code format — UAT 3 asks for the FCC pattern, and no FCC pattern is written anywhere

- **Status:** open
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register into the module registers. Raised in **UAT 3**, still not done.
- **Question:** what should a **job ticket code** look like? The ask names *"the FCC pattern"* and nobody has written down what that pattern is — the prefix, the width, whether it is per tenant, per job, per year, and what it must stay unique against.
- **Sources checked:**
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → NOT DONE *Ticket codes in the FCC pattern*, [UAT 3]. The session sheet: *"Update ticket code to reflect FCC pattern."* The register's finding: *"Still the LEM prefix with a five-digit sequence. **No FCC pattern exists anywhere.**"* `job-tickets.service.ts:53`.
  - [../decisions/](../decisions/) — nothing on ticket code format. [../decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md](../decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md) and [../decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md](../decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md) settle **how many** tickets exist and **who fills them**, never what they are called.
  - The platform's identity convention is written and unambiguous: business codes are minted from `entity_sequences` and are unique **per tenant**, never globally. Whatever pattern is chosen has to live inside that.
  - **The reason this cannot be answered by looking at FCC:** the vault forbids citing FCC behaviour as a requirement source. FCC material in the vault is recorded as *evidence of what the incumbent does*, not as an ERP rule — the same caution [../payroll/gaps.md → *Employee types…*](../payroll/gaps.md#employee-types--fcc-holds-several-per-employee-we-store-one) applies to its own FCC findings (*"evidence of what FCC holds and what TCG asked for; **no TCG decision**"*). So *"reflect the FCC pattern"* is not a specification even if someone finds the pattern; it needs a TCG person to state the pattern they want.
- **Note:** a UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md). Answerable in one line by whoever raised it: *what does an FCC job ticket number look like, and do you want exactly that?* Until then `LEM` + five digits is not wrong, it is just unconfirmed.
- **Blocked:** the UAT 3 row; any migration that has to match legacy ticket numbers; anything printed or emailed that quotes a ticket number to a customer.
- **Owner:** Brian Petros or Corrina Bustos (they read FCC ticket numbers daily); whoever raised the UAT 3 row.

## Changing an employee's craft code in DAS — pointer, owned by payroll

- **Status:** open — **answered provisionally, pending ratification**: [../decisions/2026-09-28-boom-union-follows-the-worked-craft.md](../decisions/2026-09-28-boom-union-follows-the-worked-craft.md) clause 5 (developer decision, TCG-140, 2026-09-28, `status: reference`) — dispatch may set the day's craft in DAS when seating (SECONDARY assignments only); crane superintendent and payroll may correct it. Answer owned by payroll, per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*; Corrina Bustos / Brian Petros to ratify. *(Was: open, 2026-09-19 – 2026-09-28.)*
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register.
- **Why it lands here too:** the DAS half of the pair is a **dispatch affordance** — UAT 6 asks for *"an option to change craft code in DAS"*, i.e. the dispatcher overriding a rate-bearing attribute on the board. The rate rule it collides with is payroll's: [../decisions/2026-08-20-craft-locked-rate-override.md](../decisions/2026-08-20-craft-locked-rate-override.md) (`verified`) gives the day's craft to *"the crane superintendent or payroll — **never the employee**"*, and says nothing about a dispatcher.
- **Read:** [../payroll/gaps.md → *Primary craft code constrained to the employee type, and changing a craft code in DAS*](../payroll/gaps.md#primary-craft-code-constrained-to-the-employee-type-and-changing-a-craft-code-in-das)
- Update 2026-10-16: that entry now carries the slot-type half (may dispatch set a day's craft on a **non-Operator/Oiler** seat?). Built meanwhile: the DAS craft pill shows on every employee slot, editable only on Operator/Oiler seats (developer decision, Jahanzaib Nadeem).

## Support vehicle for an untracked crane — pointer, owned by assets

- **Status:** open — **answer owned by assets**, per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*.
- **Asked:** 2026-09-22 — measuring the client's 2026-09-21 FCC ↔ Samsara comparison.
- **Why it lands here too:** the *mapping* is dispatch knowledge, not master data. Which support
  vehicle travels with `6002`, `RT9001`, `27501` and `CC330.01`, whether it is the same vehicle
  every time or picked per job, and whether one truck can cover more than one crane, are things
  a dispatcher knows and no cleanup of FCC or Samsara will produce. It is registered under
  `assets/` because the schema consequence lands on the Asset ↔ Samsara link.
- **Read:** [../assets/gaps.md → *Which dispatchable cranes are untracked, and what stands in for them*](../assets/gaps.md#which-dispatchable-cranes-are-untracked-and-what-stands-in-for-them--asked-twice-unanswered-twice)

## Does a crew starting a ticket move the sub-job's DAS stage — or is `dasStage` dispatcher/yard-owned with ticket progress shown beside it?

- **Status:** open
- **Asked:** 2026-09-22 — planning **TCG-70** (UAT 4 #48, *"DAS should show In Progress once a ticket starts"*). The safe subset shipped without an answer; the derivation is blocked on one.
- **Question:** **who or what advances `SubJob.dasStage`?** Concretely: may a *field* event — a crew punching in on the mobile app — write it, or is it a dispatcher/yard-owned field with ticket progress shown **alongside** it, the way NexGen's `Show Tickets` grid does ([fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md):612)? And if derived: to `WORK_IN_PROGRESS` or to a new stage; does one crew member move it or all of them; and may a dispatcher hold a value the system would otherwise advance?
- **What the code does (fact, not intent):** every `dasStage` write past `TICKET_SENT` comes from the **yard** — `LOADOUT` from *Mark Available*, `EMPLOYEE_LEFT_YARD` from *Complete Loadout*, `WORK_IN_PROGRESS` and `COMPLETED` from the offload endpoints (`das-loadout.repository.ts`:232, :304, :380, :626, :658). `TICKET_SENT` and `ALLOCATION_COMPLETED`/`OPEN` come from the dispatcher. **Nothing in the ticket lifecycle writes it**, and `TICKET_SUBMITTED` is written by nothing at all outside demo seeding. Two of nine stages are unreachable or inverted in production, and a third is written by the wrong subsystem.
- **And the stage named for it does not mean it:** `WORK_IN_PROGRESS` is written by `completeOffload` — the crane coming **back** and being partly unloaded — then overwritten with `COMPLETED` in the same transaction (`:658`) when nothing remains. It survives only on a **partial** offload. So *"Work In progress"* today means *"partially offloaded after the crew returned."*
- **Sources checked:**
  - [daily-allocation-system.md](daily-allocation-system.md):60 (`unverified`, `conflicts_with: [projects-jobs/job-project-das.md]`) — *"Job statuses progress: Open → Allocation Completed → Ticket Sent → Load-out → Employees Left Yard → Work in Progress → Completed → Ticket Submitted."* **A sequence, never a trigger.** It states the order and is silent on who moves a job between them. The conflicting file's punch list touches no status item, so `:60` is uncontradicted — just unverified.
  - [../decisions/2026-08-20-job-completed-on-last-day-offload.md](../decisions/2026-08-20-job-completed-on-last-day-offload.md) — **`status: verified`, Umair Khan, SCRUM-903.** The only verified ruling that touches the chain, and it leans **away** from field events: *"Field-ticket submission is not the sole (or required) completion trigger"*, and its *What this does not settle* explicitly puts wiring `dasStage → TICKET_SUBMITTED` on submit **out of scope**. About the *submit* end, not the *start* end — but the same direction of travel.
  - [../decisions/2026-09-10-das-map-shows-all-nine-job-stages.md](../decisions/2026-09-10-das-map-shows-all-nine-job-stages.md) (`reference`, Akif Farooq) and the six `2026-09-11-progress-tracking-*` notes (`reference`, Syed Haris) — all settle **which stages display**, none says who writes them. The Progress Tracking notes define a *ticket* status vocabulary and never claim it writes back to `dasStage`; `SCRUM-PROGRESS/intent.md`:158 says the two only *"resemble"* each other.
  - The only recorded claim that ticket data drives a board transition is developer narration, already filed below: *"it's also going to get tied to the tickets as well"* ([2026-05-12-loading-figma-demo.md](../meetings/transcripts/2026-05-12-loading-figma-demo.md):326-330).
  - No `gaps.md` row anywhere had previously asked this.
- **A proposal exists but binds nothing:** [../decisions/2026-09-22-das-stage-is-derived-forward-only-from-the-ticket-lifecycle.md](../decisions/2026-09-22-das-stage-is-derived-forward-only-from-the-ticket-lifecycle.md) (`reference`, Syed Haris) records *derived forward-only, reuse `WORK_IN_PROGRESS`, first crew member to start, audit ships with it*. **It sits against the `verified` Umair Khan note above, and a `reference` note does not overrule a `verified` one.**
- **Related, already open — do not duplicate:** [*Manual vs automatic offload*](#manual-vs-automatic-offload--dylan-asked-for-manual-dev-said-automatic-dylan-also-asked-for-geo-auto-offload-built--manual) — **the identical manual-vs-derived question one stage later, with three unreconciled positions. Answer both together or neither.** [*DAS map job status buckets*](#das-map-job-status-buckets--nine-subjob-stages-collapsed-to-four-and-loadout-counted-as-pending) — a new stage would need a Yard Ops bucket, and `map-das-job-to-dylen-card.ts`'s `default:` returns `'completed'`. [*Removing an allocation after its time has passed*](#removing-an-allocation-after-its-time-has-passed) — the delete gate already keys on whether tickets were sent, so moving the stage changes who may edit what. Cross-module: [../projects-jobs/gaps.md](../projects-jobs/gaps.md) → *Job CANCELLED / ON_HOLD / INVOICED transitions unwired* — the same shape one level up, also unanswered.
- **Note:** a UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md). **TCG-70 is not blocked on this** — it shipped the safe subset ([../decisions/2026-09-22-das-card-shows-ticket-status-beside-the-stage.md](../decisions/2026-09-22-das-card-shows-ticket-status-beside-the-stage.md)), which shows the crew's ticket status beside the stage badge and moves no stage. This row blocks the derivation only.
- **There is also no audit trail to answer it with.** No stage change on any sub-job, by any actor, is recorded today: `DasAllocationAuditLog` has no `subJobId` and no stage columns, `ActivityLogEntityType` has no `SUB_JOB` member, and `SubJob` carries only `updatedAt`. The moment the stage becomes system-written, *"who moved this job, and when"* becomes unanswerable — at exactly the point it starts mattering.
- **Blocked:** **TCG-184** (the derivation follow-up) and its AC1–AC7 / AC9–AC13; whether `TICKET_SUBMITTED` ever becomes reachable; whether `EMPLOYEE_LEFT_YARD` should be written by the crew's own *Left Yard* milestone rather than by a yard action.
- **Owner:** **Lisette Anzaldo** (DAS board owner) with **Dylan Masterson** where it touches the yard, and **Umair Khan**, whose SCRUM-903 ruling the derivation would partly reverse.

## Live update scope and freshness — "real time across all views" names screens, not panels, and sets no bound

- **Status:** open
- **Asked:** 2026-09-22 — reviewing branch `fix/tcg-91-das-live-update` (TCG-91).
- **Question:** two parts, each answerable in a line. **(a)** Does *"reflected in real time across all
  views"* include an **already-open allocation panel** and the **DAS Assets panel**, or only the three
  screens it names (DAS board, Schedule tab, Dylan's loadout view)? **(b)** What is the response-time
  target the *"system is slow"* row has been waiting on since UAT 1 — is a push on every mutation
  required, or is the existing idle-10s refetch enough for anything but the job list?
- **Sources checked:**
  - [../projects-jobs/project-module/02-view-manage-job-details.md](../projects-jobs/project-module/02-view-manage-job-details.md):63 (`unverified`) — *"Any update made to the job is reflected in real time across all views (DAS, Schedule tab, Dylan's loadout view)"*. Enumerates **screens**; says nothing about panels within a screen, and sets no latency.
  - [../projects-jobs/project-module/03-create-manage-job-schedule.md](../projects-jobs/project-module/03-create-manage-job-schedule.md):44 (`unverified`) — *"The Schedule tab inside the job always shows the latest real-time view — any changes made from DAS are also reflected here"*. An acceptance criterion, and the direct source for TCG-91's Job Details work.
  - [daily-allocation-system.md](daily-allocation-system.md):38 (`unverified`) — panes refresh on **date change** only. :92 — pre-checklist recalculates in real time. Neither covers mutation-driven refresh of allocations.
  - [daily-allocation-INDEX.md](daily-allocation-INDEX.md) — the DAS conflict pair does not touch refresh; the punch list has no live-update items.
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md):223 (`unverified`) — *"System is slow … **needs a target (which screens, what response time) before it can be worked or verified**"*, open since [UAT 1](../uat/sessions/uat-session-1-internal.md):36. **This is why (b) cannot be answered against a written budget: there is none, and that absence is itself recorded.**
  - [../admin/gaps.md](../admin/gaps.md):844 (`reference`), after a vault-wide sweep — *"**No vault file states a millisecond value of any kind.**"*
  - [../decisions/](../decisions/) — nothing on sockets, invalidation or freshness. The only adjacent line is [2026-09-15-fix-15-sep-das-and-quotations-as-built.md](../decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md):99 (`reference`, Ehtesham Anwar), which decides loader **chrome** for idle 10s refetches, not volume.
  - [../brs.md](../brs.md) — no non-functional or responsiveness section. The only performance NFR in the vault, [../field-ops/frd-new-format-draft/07-non-functional-requirements.md](../field-ops/frd-new-format-draft/07-non-functional-requirements.md):23, is mobile-scoped and unquantified.
  - [../meetings/2026-06-22-sprint-4-additional.md](../meetings/2026-06-22-sprint-4-additional.md):32 (`unverified`, `kind/meeting-notes`) — *"Lisette sees the updated information on her side automatically — no manual refresh needed."* **Caveat 5 applies: `meetings/` is retrospective, never a commitment.** Corroboration only.
  - [../uat/sessions/uat-session-4.md](../uat/sessions/uat-session-4.md):44 — the origin ask, about a removed shift and the DAS board only. [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md):269 records the allocation-panel staleness as found in audit, on no session sheet — an observation with no requirement behind it.
- **Two engineering facts that bound the answer, established on the branch, not asked of the client:**
  - **The 30 req/min global throttle does not apply here.** `app.module.ts` registers `ThrottlerModule.forRoot([{ ttl: 60_000, limit: 30 }])`, but `guard/throttler.guard.ts:12-15` skips any request carrying `request.user` — *"Authenticated SPA traffic (Yard Operations, DAS, etc.) skips throttling."* A fan-out refetch on an authenticated board cannot trip it. Recorded because the ceiling looks binding and is not.
  - **The refetch is bounded to what is on screen.** TanStack's `invalidateQueries` defaults to `refetchType: 'active'` (`query-core/queryClient.js:159`), so only mounted queries refetch — roughly one per visible job row, not one per cached sub-job.
- **Note:** a UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md). TCG-91 answers (a) *"yes, panels too"* and (b) *"push on every mutation"* by developer inference agreed in session on 2026-09-22. **The screens half is sourced** (02:63, 03:44); the panels half and the freshness bound are not. Four open UAT rows pull opposite ways and nothing reconciles them: toward more invalidation, :236 and :269; away from gratuitous reloading, :235 (*"App refreshes every time"*) and :243 (*"Cache and reload problems across the app"*, which names TCG-91's two symptoms as its only concrete instances).
- **Separately, and deferred by TCG-91 on purpose:** [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md):262 records that the schedule-change event is broadcast **namespace-wide across tenants**, confirmed at [../uat/done-verification-2026-09-19.md](../uat/done-verification-2026-09-19.md):93. TCG-91 adds emits to that same un-scoped channel. The scoping fix is correctly a separate card; the volume on the un-scoped channel rises meanwhile.
- **Blocked:** nothing hard — TCG-91 ships on the sourced half. What is unconfirmed is whether panel-level refresh and push-per-mutation are what the client wants, and whether they survive a load question later.
- **Owner:** Lisette Anzaldo (what must be current on her board without touching anything) with Dylan Masterson for the loadout/yard view; the response-time target has been open since UAT 1 and is blocked on one sentence from TCG, not from engineering.

## Does copying allocations make a job a holdover?

- **Status:** open
- **Asked:** 2026-09-24 — ingesting [../meetings/2026-09-22-erp-live-demo-02-project-schedule-permits-das-allocation-and-vendors.md](../meetings/2026-09-22-erp-live-demo-02-project-schedule-permits-das-allocation-and-vendors.md) §3.
- **Question:** when a dispatcher copies a job's allocations to its later scheduled days, does that **make the job a holdover**, or is holdover a separate thing the dispatcher marks? ehtesham.anwar said on the 2026-09-22 demo (transcript 1:05:52): *"what we finalized was whenever we are going to have copy allocation, it automatically becomes holdover, but… As of right now… we can copy over the allocation and we still might not have it as holdover. So Lisette needs to mark it as holdover."* The same demo showed the opposite direction built. Ticking *mark it holdover* in Copy Allocations copies everything to all remaining days (34:25).
- **Sources checked:** **no written record of the "finalized" rule was found.** The vault's holdover material is about something else: [crane-configuration-rules.md](crane-configuration-rules.md) §10 (*"Holdover configurations. The largest hole"*, Lisette 2026-05-21: a holdover changes which tractor/trailer go out on days 2…n-1) and [../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md) (Kyle: a tower crane job is always a holdover). [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) marks *Holdover functionality* DONE with the caveat that it is *"a manual Copy Allocations action across ticked days, not automatic carry-forward"*.
- **Note:** the two directions are not the same question. Whether **copy implies holdover** is the dev claim. Whether **holdover implies copy** is what shipped. Crane-configuration-rules §10 suggests that a holdover should **not** copy day 1's allocation unchanged, because the tractor and trailer come back after day 1. If that holds, "copy everything to every day" is the wrong default for a real holdover.
- **Blocked:** any change that sets or clears the holdover flag as a side effect of Copy Allocations; the holdover configuration variants.
- **Owner:** Lisette Anzaldo (dispatch). The discovery session that is said to have settled it is unidentified, so ehtesham.anwar should name it if it exists.

- **Build note (2026-09-29, branch `feat/schedule-datetime-holdover`, not yet merged) — holdover
  is now also a per-line job setting, and neither direction of this question was decided.**
  *Make Holdover* (job Schedule tab footer and the DAS allocation panel, one shared modal) saves
  which of the job's asset and employee lines are held: `JobResource.isHoldover`, per line, not
  per job. Copy Allocations with *Hold over* ticked now **also** marks the copied lines held, so
  the two paths share one set. Holding a line **carries its allocation onto the job's other
  days**, earlier empty days included (see the entry below; revised the same day at syed.haris's request). Releasing a line clears the
  day-level `JobResourceAllocation.isHoldover` on days still Open / Allocation Completed and not
  ticket-locked, and keeps the allocations. Built defaults, not answers — see
  [*Make Holdover — does holding an item carry its allocation forward on its own?*](#make-holdover--does-holding-an-item-carry-its-allocation-forward-on-its-own).

## An assist crane needed only on some days of a multi-day job — setup and breakdown

- **Status:** open
- **Asked:** 2026-09-28, from Brian Petros's Teams thread of Thursday 2026-09-24 (early morning PKT), pasted into the session by syed.haris on 2026-09-28. Not otherwise in the vault.
- **Question:** On a multi-day job, a second crane is sometimes needed **only on the first and last
  day**, for example to set up and break down the main crane's counterweights. How is that crane
  quoted, scheduled and dispatched, so it goes out on day 1 and the last day and **not** on the
  days in between?
- **What TCG said:** Brian: *"the 550-ton may need a 90-ton to help it setup/breakdown the crane … the
  90-ton would be there on the first day… and then go back to the yard (while the 550-ton would
  remain on-site)… and then dispatch will need to dispatch a 90-ton again on the last day."* On FCC:
  *"I am unsure exactly how FCC currently handles this… Lisette just knows that the 90-ton has two
  'dispatches'"*. He believes she creates separate job tickets for that asset on those two days
  (*"a separate Job Ticket per day"*). Not confirmed with Lisette.
- **What the build does (checked 2026-09-28):** the job's resource tree is the same on every day.
  `JobResource` has no day or date scoping. A day (sub-job) reaches **allocation completed**, which
  unlocks *Send tickets*, only when **every fillable slot on the job** is filled for it
  (`apps/api/src/service/das-allocations/das-allocations.repository.ts` →
  `getFillableJobResourceIds` / `countFilledSlots`). As built, an assist crane on the job leaves
  every middle day stuck in *open* unless it is allocated there too. The only workarounds are
  splitting it into a separate job or allocating it on days it isn't used, and both are the FCC
  pattern Brian wants to leave.
- **Questions for TCG:** (a) Is the assist crane a line on the same quotation as the main crane, or
  quoted separately? Is it billed per trip or per day? (b) Is the pattern always first and last day,
  or can it be any subset of days? (c) Does its crew follow the same days? (d) Should DAS treat
  those days as "required on these days only", or as a separate dispatch inside the job?
- **Related:** [../quotations/gaps.md → *Several main cranes on one quotation…*](../quotations/gaps.md#several-main-cranes-on-one-quotation--how-are-the-crane-packages-grouped-and-how-does-dispatch-see-them);
  [*Does copying allocations make a job a holdover?*](#does-copying-allocations-make-a-job-a-holdover)
  (copy-to-all-days would also copy the assist crane).
- **Blocked:** DAS completion and *Send tickets* for any multi-day job with a part-time crane.
- **Owner:** Lisette Anzaldo (dispatch), with Ryan Adams / Joe Schacatano for how it is quoted.

## Pointer — asset-not-home flag depends on the holdover definition

- **Pointer (2026-09-30):** Corrina Bustos asked for a flag when an asset **not assigned to a holdover job** does not return to its home yard at end of shift. It is filed once in [../assets/gaps.md → *Asset not returned to its home yard at end of shift*](../assets/gaps.md#asset-not-returned-to-its-home-yard-at-end-of-shift--a-requested-flag-with-no-owner-no-yard-geometry-and-no-shift-end). **Update 2026-09-30:** the Payroll Admin and Payroll Manager receive it and **dispatch is notified**, and the trigger is an engine-off away from the yards, not a time. Developer reading, pending ratification ([../decisions/2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md](../decisions/2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md)): the last shut-off of the day, away from the yard the asset left from that day. Dispatch owns how it is notified and what makes a job a holdover ([*Does copying allocations make a job a holdover?*](#does-copying-allocations-make-a-job-a-holdover)).
- **Developer answer 2026-09-30 (round 9)** ([note, F13–F15](../decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md#round-9--the-flag-definitions-and-designs-2026-09-30), `reference`, pending ratification): holders of the **dispatch permission** are notified, **in-app and by email**. The flag covers **cranes only**, and **skips holdover jobs**, so the holdover definition above still decides which assets are exempt. It is judged once the ticket's end date has passed, against the departure yard's 500 m geofence. That trigger is in tension with Corrina's shut-off trigger; see the assets entry. **Lisette Anzaldo** ratifies the notification and the holdover exclusion.

## Make Holdover — does holding an item carry its allocation forward on its own?

- **Status:** open
- **Asked:** 2026-09-29 — building the Make Holdover design (job Schedule tab + DAS) on branch
  `feat/schedule-datetime-holdover` (tcg), not yet merged. No SCRUM ticket.
- **Question:** When a dispatcher holds an item over (say the crane) that is already allocated on
  today's DAS, **should the same crane be placed on every remaining day of the job
  automatically**, or does the dispatcher still decide which days, as with Copy Allocations?
  One line settles it: "holding an item books it on every remaining scheduled day" or "holding
  an item marks it; the dispatcher carries it forward".
- **Built (revised 2026-09-29, at syed.haris's request):** the **first**. A held line's allocation
  **carries onto the job's other days** and shows **On Hold** there, so it is at the site and not
  offered to other jobs. Mechanics: for each held line and shift, every **empty** day of the job
  takes the occupant from the nearest earlier day, or from the nearest later day when nothing
  earlier has one. Assigning the crane on day 2 therefore also fills day 1; syed.haris expected
  exactly that when testing JOB-00042. A day that already has someone keeps them, and the days
  after it take that person. Only days from today that are still
  Open / Allocation Completed and not ticket-locked are written. Each write goes through Copy
  Allocations with *Hold over*, so its conflict rules apply, and a day where the resource is booked
  elsewhere is skipped and named, with the day and the reason, in a warning after Save
  Allocations or Make Holdover. Seen on JOB-00042 on 2026-09-30: TCG-CR-101 was held, but it is
  booked on JOB-00032 on 1 and 2 Oct at the same hours, so those days were refused. That is
  correct; the missing part was saying so. It runs when the holdover is saved, when an
  allocation is saved on a held line, and when the schedule is saved. Saving Make Holdover with
  an unchanged selection still saves, so it fills any day the items are missing from. The earlier
  "offer Copy Allocations" prompt was removed.
- **Why, from the record (no TCG ruling yet):** Lisette's dispatch sheet lists a holdover's crane
  on **every** day of the job, marked `onsite` — *"already at the job site and … not leaving the
  yard that day"* ([dispatch-sheet-workbook.md](dispatch-sheet-workbook.md) §4). UAT 3 logged as a
  defect that an Oiler allocated on 12 September *"was not shown on the other days"* ([../uat/sessions/uat-session-3.md](../uat/sessions/uat-session-3.md)).
  The design's banner says held items *"will not return to the yard on any day till end of the job."*
  §10's objection (the tractor comes back) is met by holding per item: an item that isn't ticked
  is not carried.
- **Still for Lisette to confirm:** the whole rule. Also: (a) days **added** after items were held
  now pick them up; is that right? (b) a crane **swapped** on one day stays swapped, and the new
  one is carried on; is that right? (c) **releasing** a line keeps the carried allocations (only
  their hold flag clears); should they be removed instead? (d) should an **employee** line be
  carried too, booking that person on every later day (ticketed when each day's tickets go out),
  or only equipment?
- **(c) partly answered 2026-10-06 by fouzan.shakil (CodingCops), not confirmed by TCG** —
  [../decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md](../decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md)
  (`reference`): a held item that has to come back early (breakdown, needed elsewhere) is
  **released by dispatch in Make Holdover**, and that day's Off-load then lists it as a normal
  item. The yard gets no override. Still open in (c): whether the carried allocations on later days
  should be removed on release.
- **Sources checked:** the design prototype (`TCG Platform (standalone) time.html`, `js2HoldModal`
  / `dasAllocationPanel`) shows the modal and chips but saves nothing beyond the list;
  [*Does copying allocations make a job a holdover?*](#does-copying-allocations-make-a-job-a-holdover);
  [crane-configuration-rules.md](crane-configuration-rules.md) §10;
  [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) (*Holdover functionality* row:
  "a manual Copy Allocations action… not automatic carry-forward").
- **Owner:** Lisette Anzaldo (dispatch).

## Which items of a holdover job go back to the yard between working days?

- **Status:** open
- **Asked:** 2026-09-29 — same build. The design's modal says *"The assets and resources we hold
  over for the job will not return to the yard on any day till end of the job."*
- **Question:** On a holdover job, **which items normally stay on site and which return each
  night** — crane, tractor, trailer, counterweight trucks, crew vehicles? Is there a default the
  modal should pre-tick, and does the first/last-day pattern need its own configuration variant?
- **Built default:** nothing pre-ticked; the dispatcher ticks items per job, and the banner was
  reworded to *"Selected assets and resources stay on site between working days and don't return
  to the yard until the job ends"*, so it only claims what the dispatcher chose. — *"nothing
  pre-ticked"* superseded 2026-10-06, see the *Default pre-tick* note below.
- **Sources checked:** [crane-configuration-rules.md](crane-configuration-rules.md) §10
  (reference, Lisette 2026-05-21: *"they bring back the tractor and sometimes the trailer comes
  back or sometimes it stays"*; the crew uses personal vehicles until the last day; holdover
  configuration variants were to be added to the workbook and never were);
  [dispatch-sheet-workbook.md](dispatch-sheet-workbook.md) §4 (`onsite` / `crane-tractor onsite`
  rows); [crane-configurations.md](crane-configurations.md) legend *"Crane is staying on site."*
- **Blocked:** a pre-filled holdover selection; any per-day configuration variant.
- **Partly answered 2026-10-01 by syed.haris (CodingCops), not confirmed by TCG** —
  [../decisions/2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md](../decisions/2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md)
  (`reference`): an item held over (Make Holdover) is offloaded once, on the job's last day; an
  item not held over goes back to the yard every day. Not built — the yard board does not read
  holdover. Still open: whether a single multi-day *shift* without holdover means the crane comes
  back mid-shift each night, and the default pre-ticked items above.
  - **Note 2026-10-07: the holdover half of the multi-day shift is settled in practice, unasked.**
    Holdover now needs two or more working days, counted as active, non-cancelled schedule rows
    ([../decisions/2026-10-07-holdover-not-allowed-on-a-single-day-job.md](../decisions/2026-10-07-holdover-not-allowed-on-a-single-day-job.md),
    `reference`, fouzan.shakil, not confirmed by TCG). A multi-day shift on one row counts as one
    day, so it cannot be held: it is always "without holdover". Nobody asked about this case; it
    follows from how days are counted. Whether the crane comes back each night mid-shift is still
    open.
- **Loadout half ruled 2026-10-06 by fouzan.shakil (CodingCops), not confirmed by TCG** —
  [../decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md](../decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md)
  (`reference`): a held asset is loaded out once, on the first day it actually goes, and offloaded
  only on the job's last day. On the days between, the yard modals show it disabled with a
  *Holdover* pill, not hidden. Being built on tcg branch `feat/yard-holdover-loadout`. The open
  parts above are unchanged.
- **Build note (2026-10-06, tcg branch `feat/yard-holdover-loadout`, not merged).** Built to the
  ruling above; the defaults marked *built default* are the build's, not the ruling's.
  - **One rule, worked out by the API per day** (`apps/api/src/usecase/das-loadout/holdover-loadout.util.ts`),
    sent as `DasSubJobLoadout.holdover` on `GET /das/sub-jobs` and every loadout route:
    - *held* — the Make Holdover tick (`JobResource.isHoldover`) or that day's allocation copied
      with *Hold over*;
    - *on site* — loaded out on an earlier day or shift of the job and not offloaded or moved since;
    - *last day* — the job's last active, non-cancelled schedule row, worked out when read, so
      adding or removing days moves it.
  - **Loadout** is refused for an item on site; **offload** is refused for a held item before the
    last day (400 with the reason). Both are enforced by the API, not only the modals.
    - **Corrected 2026-10-06: the Loadout half is stale.** Under
      [../decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md](../decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md)
      the Loadout refusal was removed. The Loadout lock (held item ticked and locked) is
      **web-only** (`apps/web/src/features/dylen-dashboard/hooks/use-dylen-held-asset-selection.ts`).
      The API does not refuse a Loadout that leaves a held item behind (`completeLoadout`,
      `apps/api/src/usecase/das-loadout/das-loadout.service.ts`). The Off-load half stands. Whether
      the API should enforce the lock is open:
      [*Holdover Loadout lock — should the API refuse a Loadout that leaves a held item behind?*](#holdover-loadout-lock--should-the-api-refuse-a-loadout-that-leaves-a-held-item-behind)
  - **Day 1:** a held item out tonight is not outstanding — the day closes without it, no offload
    reason is asked, and Force complete leaves it out. *Built default:* when only held items are
    out, Off-load still opens (rows disabled) and its button closes the day.
  - **Middle days:** the held item shows disabled in both modals with "On site since …" and the
    pill. *Built default:* a middle day whose only items are held has nothing to load, so Mark
    Available is disabled ("nothing to load"), as for an all-unassigned shift.
  - **Last day:** the held item appears as on site and coming back (`incomingOnSiteItems`, flagged
    `holdover`); Mark Available moves it onto the day (the earlier rows are closed through the
    defer columns; the new row keeps when it went out), and Off-load lists it, tickable, "Comes back
    today".
  - **Early return:** releasing the line in Make Holdover makes it offloadable on that day — an item
    still out from a day that closed with it out is received onto the day, even one already open.
  - **Yard board:** the purple *Holdover* pill (`HoldoverBadge`) on held rows in both modals, a
    *Holdover · n* pill on the job card, and the print sheet marks held rows.
  - **DAS:** a held asset is refused for any other job (`HELD_ON_SITE`, 409; also in Copy
    Allocations and the holdover carry) — no longer silently taken off the held job. *Built default,
    wider than the ruling:* the block spans the held job's first to last held day for that asset,
    **whether or not it has gone out yet** (the ruling says "from its day-1 loadout"). Offloading it
    on a day frees that day; releasing the hold frees the later days.
    - **Ruled 2026-10-06, later the same day, by fouzan.shakil (CodingCops), not confirmed by TCG**
      — [../decisions/2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md](../decisions/2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md)
      (`reference`). No longer a built default: the whole planned hold, before loadout too, is the
      rule. For a held asset it overrides "Reassign anyway?"
      ([../decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md](../decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md)
      item 4). What frees it is as in the later yard note below: the last held day's offload, or
      releasing the hold. Still in tension with [daily-allocation-system.md](daily-allocation-system.md):47-48
      and [../projects-jobs/project-module/03-create-manage-job-schedule.md](../projects-jobs/project-module/03-create-manage-job-schedule.md):43
      (both `unverified`: a clash warns, it does not block).
  - **Not built:** rigging cannot be held; a held *employee* is not blocked elsewhere; the DAS side
    panels still show a held crane as available on a day the job has no row (the drop is refused by
    the API); the yard board still lists jobs by row date (item 1 of *Shifts that run past their own
    day*).
  - **Yard build changed 2026-10-06 (later the same day; tcg branch `feat/yard-holdover-loadout`,
    uncommitted).** After the build above disabled Mark Available on a held-only middle day (local
    JOB-00053, 2027-06-02), fouzan.shakil ruled in four steps that day —
    [../decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md](../decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md)
    (`reference`, not confirmed by TCG). Every day runs the normal flow, and the yard's
    pre-existing button rules are unchanged; holdover changes only what the modals show.
    - **Loadout:** a held item is **ticked and locked**, every day.
    - **Off-load before the last day:** it is **unticked and locked**, with the hover "This item
      is held over and can't be offloaded until <last day>." It stays out, no reason is asked, and
      the day closes without it. The API refuses offloading or deferring it, and Force complete
      leaves it out (`stayOnSiteItemKeys`).
    - **Last day:** an ordinary tickable row ("Comes back today").
    - **Off-load button (ruled, a fourth pick):** when held items are all that is out, Off-load
      stays available until the day's off-load is submitted, and its Continue closes the day.
    - **Earlier days closed (ruled, a fourth pick):** the last day's offload also marks the held
      item returned on each earlier day of the job (`closeEarlierHeldRows`), Force complete included.
    - **Removed from the build above:** the Loadout refusal for an item on site, the last-day carry
      of earlier rows, and the disabled Mark Available.
    - **Unchanged:** `HELD_ON_SITE` for the whole span (only the last held day's offload, or
      releasing the hold, frees it), the job-card pill, the print marker.
    - **Superseded in this note's first version, then restored:** offload only on the last day.
      For a short while the Off-load row was ticked and locked too.
- **Default pre-tick partly answered 2026-10-06 by fouzan.shakil (CodingCops), not confirmed by TCG** —
  [../decisions/2026-10-06-cranes-550-ton-and-up-pre-ticked-for-holdover.md](../decisions/2026-10-06-cranes-550-ton-and-up-pre-ticked-for-holdover.md)
  (`reference`): crane lines of **550 t or more** (tonnage read from the number in the sub-category
  name) are pre-ticked in Make Holdover on the job **Schedule tab only**, and only while nothing on
  the job is held yet. It is a pre-tick only: nothing is held until someone saves. The DAS's Make
  Holdover pre-ticks nothing. Being built on tcg branch `feat/yard-holdover-loadout`. Still open:
  which other items stay on site (tractor, trailer, counterweight trucks, crew vehicles, crew), and
  the first/last-day configuration variant.
  - **Revised 2026-10-06, later the same day, by fouzan.shakil (CodingCops), not confirmed by
    TCG** (same decision note, *Revision*): only 550 t+ crane lines **created on or after
    2026-10-06** are pre-ticked, still only while nothing on the job is held. Older lines are never
    pre-ticked. Known gap, accepted with the pick: a new 550 t+ line on a job that already holds
    something is not pre-ticked. Built as `DEFAULT_HOLDOVER_FROM` (UTC midnight) and a
    `JobResource.createdAt` check in `isDefaultHoldoverLine`
    (`apps/api/src/usecase/jobs/holdover-default.util.ts`).
- **Update 2026-10-07: Melissa McNutt (TCG), provisional, on a 6-day holdover.**
  - What she wrote, in Teams answers posted on or before 2026-10-06
    ([../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md](../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md),
    `reference`):
    - At the end of Day 1 the crane *"typically stays built up in place"*. It is broken down on the
      last day only.
    - The crew *"just reports to the job site"* on days 2+, *"99% of the time"* in a personal car,
      with a company truck *"if the job is far"*.
    - *"The end of the job will be when the equipment returns back to our yard."*
  - This is the first written TCG statement that the **crane** stays. It agrees with the CodingCops
    rulings above and with Lisette Anzaldo 2026-05-21 59:11.
  - It **does not answer** this entry's open part: which other items stay (tractor, trailer,
    counterweight trucks), or the first/last-day configuration variant.
  - The company-truck day is new for dispatch: a crew vehicle leaves the yard on a holdover day.
  - TCG asked to hold the answers until an updated version is sent.
  - Pay on holdover days is filed in
    [../payroll/gaps.md → *Holdover days 2+*](../payroll/gaps.md#holdover-days-2--does-paid-time-start-on-arrival-at-the-job-site-and-where-does-each-day-end).
- **Owner:** Lisette Anzaldo (dispatch).

## Is the DAS holdover the same thing as payroll's subsistence holdover?

- **Status:** open
- **Asked:** 2026-09-29 — same build.
- **Question:** The platform now has **two** things called holdover: payroll's job-level
  *"Crew stays away overnight (holdover)"* (`Job.subsistenceHoldover`, the Subsistence card on
  the job's Main tab, gating PAY-048/049 subsistence) and dispatch's per-item *Make Holdover*
  (`JobResource.isHoldover`). **Should holding an item over set the payroll flag, should the
  payroll flag pre-fill the dispatch holdover, or are they independent?** And is *Kyle's* rule
  (2026-09-03) that a tower-crane job is always a holdover a dispatch default, a payroll
  default, or both?
- **Built default:** independent; nothing links them. The modal says nothing about pay.
- **Why it matters:** PAY-049 (*"every day of the holdover job, worked or not"*) is unbuilt for
  want of "which employee is on holdover, and on which calendar days, independent of any
  ticket" (`packages/payroll-engine/src/subsistence.ts` header). Held employee lines are that
  data, if TCG says they mean the same thing.
- **Sources checked:** [../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md)
  (verified); [../payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md)
  (subsistence rows); [../payroll/2026-08-20-payroll-rules-meeting-notes.md](../payroll/2026-08-20-payroll-rules-meeting-notes.md).
- **Blocked:** any link between the two flags; PAY-049's calendar-day rule.
- **Owner:** Lisette Anzaldo (dispatch) with Corrina Bustos (payroll).
- **Update 2026-10-20: billing now depends on the holdover definition too. Pointer only, the entry
  stays open.** Melissa McNutt wrote: *"We like to bill holdovers weekly … All other jobs are
  billed daily"*
  ([../decisions/2026-10-20-holdovers-billed-weekly-or-monthly-other-jobs-daily-one-job-per-invoice.md](../decisions/2026-10-20-holdovers-billed-weekly-or-monthly-other-jobs-daily-one-job-per-invoice.md),
  `verified`). That makes invoicing a third consumer of "is this job a holdover". She did not say
  which flag she means. That question is filed in
  [../accounting/gaps.md → *Billing cadence*](../accounting/gaps.md#billing-cadence--what-sets-monthly-instead-of-weekly-what-a-billing-week-is-and-what-billed-daily-means),
  item (e).

## Make Holdover — every unit of a line, who may set it, and at what stage?

- **Status:** open
- **Asked:** 2026-09-29 — same build.
- **Question:** Three edges the design does not show. (a) A resource line with **quantity 2**
  (two operators) is held as a whole — should the dispatcher be able to hold one of the two?
  (b) **Who** may set a holdover — any user who can edit the job, or dispatch only? (c) Can it be
  changed once a day's **tickets are sent**, or once the job is **completed**?
- **Built default:** (a) the whole line; (b) anyone who can edit the job (no extra permission,
  matching the job's other routes); (c) editable at any stage except a **Completed** job, and
  releasing only clears holds on days still Open / Allocation Completed and not ticket-locked.
  - **Update 2026-10-07: (c) also stops below two working days.** Ruled by fouzan.shakil
    (CodingCops), not confirmed by TCG —
    [../decisions/2026-10-07-holdover-not-allowed-on-a-single-day-job.md](../decisions/2026-10-07-holdover-not-allowed-on-a-single-day-job.md)
    (`reference`; tcg branch `feat/holdover-single-day-block`, not merged). Make / Edit Holdover is
    disabled on a job with fewer than two active, non-cancelled schedule days, with a hover saying
    why. The API refuses a non-empty set there (400); releasing stays allowed in the API.
    - Not settled: a held job later cut to one day cannot release its holds from the UI, because
      Edit is disabled too. Copy Allocations with *Hold over* (`markHeld`) can still hold a line on
      a one-day job. Neither was asked.
- **Also:** the dev team said on the 2026-09-22 demo that the Schedule tab *"schedules the job
  only; per-day resource scheduling is done in DAS"*. The design puts Make Holdover on the
  Schedule tab anyway; built as designed. See
  [../meetings/2026-09-22-erp-live-demo-02-project-schedule-permits-das-allocation-and-vendors.md](../meetings/2026-09-22-erp-live-demo-02-project-schedule-permits-das-allocation-and-vendors.md) §1.
- **Owner:** Lisette Anzaldo (dispatch).
- **Update 2026-10-23 (10-22 walkthrough part 2) — bears on (b):** ehtesham.anwar (57:13): dispatch
  managers can add a day or make a holdover on the job schedule, which changes the schedule that came from
  the quote; *"If we want to make sure that our quotation schedule is the only schedule that should be
  followed … then we can remove this functionality for them."* Nobody from TCG answered. Source: [2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md](../meetings/2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md) §8.

## Schedule times on a later day — Start and On Site, shifts of 24 hours or more, and the minute step

- **Status:** open
- **Asked:** 2026-09-29 — building the job Schedule tab's date+time dropdown (same branch). See
  the build note under [*Overnight DAS shifts*](#overnight-das-shifts--may-a-shift-cross-midnight-and-what-does-the-board-show-when-it-does).
- **Question:** The design lets **any** of Start, On Site and Estimated End move to any later
  date. The build allows only the **Estimated End**, and only to the **next** day. (a) Can
  **Start** or **On Site** fall on the day after the row's date (a crew that leaves at 23:30 and
  is on site at 00:30)? (b) Does any job run a single shift of **24 hours or more**? (c) The
  design's time arrows step **1 minute**; the app's other date+time picker steps 15. Which does
  dispatch want?
- **Update 2026-09-29:** the second design drop (`TCG Platform (standalone)j.html`) lets you
  click the date in every time field and pick any later date, and syed.haris asked for the same.
  The built picker now opens the calendar on **all three** fields. But Start and On Site can only
  take the row's date (other days greyed out, with the reason shown), and the End can take the
  row's date or the next day. The reason: ~28 readers (tickets, DAS, payroll hours, notifications,
  loadout lock) derive each time's day from the row's date. Letting Start or On Site move, or
  allowing multi-day shifts, needs a stored per-time date and every reader updated. It also needs
  (a) and (b) above answered first. TCG-186 does not need it.
- **(b) answered 2026-09-30 by syed.haris (CodingCops), not yet confirmed by TCG**
  ([../decisions/2026-09-30-schedule-shift-may-run-past-24-hours.md](../decisions/2026-09-30-schedule-shift-may-run-past-24-hours.md),
  `reference`): *"a shift
  (job>schedule tab) can be greater than 24 hours. So there should be no restrictions on the
  calendar date picker for the estimated end time."* Built the same day: the End's calendar
  takes any day from the row's date on, the end's day is stored per shift
  (`estimated_end_date` / `second_shift_estimated_end_date`), and the only rule left is that
  the end, on its day, is after On Site. No maximum length. See the build note under
  *Overnight DAS shifts* for which readers changed.
- **Built default:** (a) no — the row's date is the day the shift starts (the business day
  starts at local midnight, [../decisions/2026-09-09-business-day-starts-at-midnight-local.md](../decisions/2026-09-09-business-day-starts-at-midnight-local.md)),
  so such a shift belongs on the next row; (b) as above; (c) 1 minute, per the design.
- **Still open after (b):** (d) a shift longer than a day covers the next rows' dates. Those
  rows still exist as their own working days, with their own shifts. Should a row inside a
  multi-day shift be switched off, or is a second crew on those days expected? Nothing stops
  it today. (e) Tickets, notifications and ticket progress show an Estimated End as a **time
  only** (`6:00 PM`), so a three-day shift's end reads like a same-day one. Should they show the
  date too? The DAS map clock was worse: it built both ends from the row's date. **Built
  2026-10-01 for the DAS only** (map, job cards, Send Ticket table); emails, the mobile app,
  ticket progress and the yard board still show the time alone.
  (f) **A client statement points the other way.** Kyle Harlow, 2026-06-18 dispatch/permits
  meeting (1:35:04, `meetings/transcripts/2026-06-18-dispatch-permits.md`, reference): *"We're
  putting a limit on allowed work hours and not ever going over 24 hours"*, with a warning to
  dispatch four hours ahead; Wes Staley: *"we'll have to ship people at the 24 hour for sure"*.
  Payroll's confirmed flag list also blocks approval of any entry over 24 hours (see
  [../payroll/gaps.md](../payroll/gaps.md) → *A shift longer than 24 hours*). **Should the ERP
  allow, warn on, or refuse a shift over 24 hours?** Ask Kyle, Lisette and Corrina — the
  2026-09-30 ruling stands for the build until they answer.
- **Evidence on (b), not a ruling:** Ryan Adams, 2026-04-07 Figma demo (transcript 24:04–28:18,
  unverified): *"Sometimes we have a 24 hour shifts too"*. And: *"you put one crew on one shift
  during the day, one crew on shift during the night, but it is the same crane"*, for jobs
  running *"seven days straight"*. ehtesham.anwar answered that this is the **second shift**.
  So round-the-clock work is two shifts on one date, which the model supports.
  Until syed.haris's 2026-09-30 answer above, nobody had asked for a single shift longer than
  24 hours.
- **Owner:** Lisette Anzaldo (dispatch).

## "Start Time" is renamed on the Schedule tab only — where else does "Leave Yard Time" appear?

- **Status:** open
- **Asked:** 2026-09-29 — same build.
- **Question:** The verified decision
  [../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md)
  (*The field is called "start time", not "leave yard time"*) was applied to the **job Schedule
  tab** (column, messages and the time fields' accessible names). Should every
  other screen that shows the same value rename it too — Tool/Rigging, the ticket-progress trip
  step, the DAS, the mobile ticket flow and notification emails? The decision names the field,
  not the screens, so this register does not assume it.
- **Built default:** Schedule tab only. The API and database keep `leaveYardTime` /
  `leave_yard_time`.
- **Owner:** Joe Schacatano / Lisette Anzaldo.

## Allocating by shift time (TCG-186) — which window holds a crane or crew member?

- **Status:** open
- **Asked:** 2026-09-29 — building Linear **TCG-186** *"DAS: Allocate by shift (time), not for
  the whole day"* (Urgent; assigned to Fouzan Shakil) on branch `feat/schedule-datetime-holdover`
  (tcg), not yet merged. No SCRUM folder.
- **What was built:** a resource is held only for its shift's **window**, and may take a
  non-overlapping shift on another job the same day. The API drop check, the Copy Allocations
  check and its web preview, the board's per-resource bookings list and the side panels all use
  one rule (`@tcg/shared` `shiftWindow` / `shiftWindowsOverlap`). Before this, the API compared
  On Site → End on the same date only, while the board, the drop confirm and Copy treated any
  booking that day as a whole-day block.
- **Question:** the window is a CodingCops choice, and eight parts of it need TCG to confirm:
  (a) **Start → Estimated End.** It begins at **Start** (the dispatch start at the yard, per
  [../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md)),
  or On Site when there is no Start. It ends at the **Estimated End**, which that decision says is
  leaving the job, not arriving back at the yard. So the **drive back is not covered**, and a crane
  can be offered to a job starting the minute it leaves the last site. Is a buffer, or an
  estimated yard-arrival time, needed? (Joe asked for yard arrival; see *Schedule fields*.)
  (b) **Untimed shifts** (no On Site or End yet) still block the whole date for the same shift
  number, as before. Is that right?
  (c) **A held-over item** is now carried onto the job's later days, so it blocks other jobs on
  each of them — but only inside each day's shift window. Should a holdover block the resource
  for the whole job, round the clock, regardless of windows? (See
  [*Make Holdover — does holding an item carry its allocation forward on its own?*](#make-holdover--does-holding-an-item-carry-its-allocation-forward-on-its-own).)
  **(c) answered 2026-10-06 by fouzan.shakil, not confirmed by TCG:** a held item on site blocks
  other jobs for the whole hold, any hours — from its day-1 loadout until the last-day offload
  ([../decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md](../decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md),
  `reference`). The ruling starts the block at loadout. It says nothing about a held item that is
  allocated but not yet out. Being built on tcg branch `feat/yard-holdover-loadout`.
  **(c) widened 2026-10-06, later the same day, by fouzan.shakil, not confirmed by TCG:** the
  block starts on the held job's first held day, not at loadout, so a held item allocated but not
  yet out is refused to other jobs too, and is never offered as "Reassign anyway?"
  ([../decisions/2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md](../decisions/2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md),
  `reference`). Still in tension with the `unverified` specs that say a clash warns (see (h)
  and [daily-allocation-system.md](daily-allocation-system.md):47-48).
  (d) **Leave and sick** still block the whole date (`LeaveRequest` is date-only). Should a
  half-day leave be possible?
  (e) **A crane loaded out and not yet offloaded** on a morning job does **not** block a
  non-overlapping afternoon job on another site. The API has always checked loadout state only
  for overlapping windows. The old whole-day board hid this, and now nothing warns. Must a
  loaded-out crane come back (be offloaded) before it can be offered to another job the same day?
  (f) **Asset record "on site".** `Asset.jobCode` on the asset record shows it as on site on
  every date. The side panels now offer such an asset for a non-overlapping shift when it also
  has bookings that day. The field is unused locally (0 of 21 assets) and undocumented in the
  vault. What is it for?
  *2026-10-20, TCG-235 (branch `fix/tcg-235-das-asset-assigned-without-allocation`):* the DAS
  no longer reads `Asset.jobCode`. Asset status and the assigned job come only from that date's
  allocations on active intervals (`daily-allocation-system.md` L51). The column, DTO and form
  are unchanged. The field's purpose is **still open**. It has no input on the asset form, and
  the FCC seeder lists it as "TCG has field — not in FCC".
  (g) **A shift longer than a day** (allowed since 2026-09-30, see *Schedule times on a later
  day*) blocks its crane and crew for its whole window at drop and Copy time: the check now
  also reads earlier rows whose stored end day reaches the target. But the board's side panels
  list bookings **per date**, so on day 2 of a three-day shift the crane shows as available and
  only the drop check stops it. Should the board show it booked on every day its window covers?
  **Built 2026-10-01** per the ruling under *Overnight DAS shifts*: the side panels list a shift
  still running into the date and the expanded job's availability check honours its window; the
  resource's status that date stays per date. Whether the board should also *show* it booked
  that day is still open for TCG.
  (h) **A conflict on another date is never cleared by *Reassign*.** Dropping a resource whose
  overlapping booking is on a different date (last night's shift running into this morning)
  refuses the save and names that job and date, instead of offering Reassign — otherwise the
  reassignment could delete an allocation, and its tickets, while that crew is still working it.
  Built rule, from the code's own risk, never asked. Is that right, or should dispatch be able to
  move a resource off a running shift? ([../projects-jobs/project-module/03-create-manage-job-schedule.md](../projects-jobs/project-module/03-create-manage-job-schedule.md),
  unverified, says a same-time clash shows a *warning*, not a refusal.)
- **Built rule, from the record rather than a ruling:** a job's allocations **never conflict
  with the same job's other days**. The crane on a round-the-clock job is *"the same crane"* for
  the day and night crews (Ryan, above, under *Schedule times on a later day*), and the loadout
  carry-forward already ignored same-job conflicts (`conflict.jobUuid === item.jobId`). Without
  this, the widened window would refuse the next day's crew on their own crane.
- **Sources checked:** the Linear ticket text (problem / done-when only); the code paths above;
  [daily-allocation-system.md](daily-allocation-system.md) (*Previous Night* tag);
  the 2026-04-07 demo transcript (24-hour operations). No vault decision covers the allocation
  window.
- **Owner:** Lisette Anzaldo (dispatch).
- **Update 2026-10-23 (10-22 walkthrough part 2):** ehtesham.anwar confirmed to TCG that no asset or
  employee can be double-booked; allocations are time-based (37:41). Melissa McNutt and Kyle Harlow said
  TCG deliberately books small cranes back to back for billing, never with crew time overlapping. The
  billing question is filed in [../accounting/gaps.md](../accounting/gaps.md) *Back-to-back jobs billed
  portal to portal — billed time overlaps, crew time must not*. Source: [2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md](../meetings/2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md) §5.

## Shifts that run past their own day — what is built, what is still missing

- **Status:** open
- **Asked:** 2026-10-01 — after the rulings that a shift may run past 24 hours
  ([../decisions/2026-09-30-schedule-shift-may-run-past-24-hours.md](../decisions/2026-09-30-schedule-shift-may-run-past-24-hours.md))
  and that it runs to its Estimated End and shows on every day it runs
  ([../decisions/2026-10-01-das-shift-runs-to-estimated-end-and-shows-on-every-day.md](../decisions/2026-10-01-das-shift-runs-to-estimated-end-and-shows-on-every-day.md)),
  both syed.haris, `reference`. Branch `feat/schedule-datetime-holdover` (tcg), not merged.
  Everything below also applies to ordinary overnight shifts (18:00 → 02:00), which were already
  common.
- **Built (DAS only):** see the 2026-10-01 build note under *Overnight DAS shifts* — the map
  clock and feed, continuing cards on the jobs board, side-panel bookings, end dates on DAS cards
  and the Send Ticket table, and a leave warning on drop.
- **Still missing — yard operations (Dylan's board), the biggest gap:**
  1. The yard board lists jobs by row date only (`das.repository.ts` `getSubJobsByDate` without
     `includeContinuing`; `dylen-dashboard/hooks/use-dylen-dashboard-state.ts`). After midnight an
     overnight crane coming back, and on days 2+ a multi-day job, is only reachable on its first
     day. Needs the continuing card plus the offload rule from
     [../decisions/2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md](../decisions/2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md).
     **Update 2026-10-06:** the holdover loadout/offload rule
     ([../decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md](../decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md),
     `reference`) is being built on tcg branch `feat/yard-holdover-loadout`. The yard board still
     lists jobs by row date there, and the continuing card is not part of that branch.
     **Update 2026-10-06 (later):** that rule is partly superseded. Every day of a held job now
     runs the normal yard flow; the held item is ticked and locked in Loadout, and in Off-load is
     locked out until the job's last day
     ([../decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md](../decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md),
     `reference`). This item is unchanged by it: the board still lists jobs by row date.
  2. Mark Available / Start Loadout locks go by the row date (API
     `das-loadout-schedule-lock.util.ts` checks the past date before the end) and the web reads the
     end on the row date (`dylen-dashboard/utils/schedule-time-utils.ts`); the two disagree and
     both are wrong past midnight. They should go by the shift's end, one rule on both sides.
  3. The "Ends in 2h / 4h" filter (`dylen-job-utils.ts`, `map-das-job-to-dylen-card.ts`) puts
     the end on the selected date and ignores shift 2 — use the sub-job's `shiftWindows`.
  4. Offload's "Move to next schedule day" takes the next row by date
     (`das-loadout.repository.ts`), which can be a day inside a multi-day shift that is already
     over; it should be the next row starting after the shift ends.
  5. The loadout code assumes Shift 2 follows Shift 1 (`das-loadout.service.ts`,
     `das-loadout-defer-allocation.util.ts`) — see question (b).
  6. Tool stock counts a tool in use only on its row date (`merge-dylen-tools.ts`,
     `dylen-tool-quantity-utils.ts`, `tools.repository.ts` counts and archive guard), so rigging
     on a multi-day job looks free on days 2+.
  7. Print (`dylen-print-job-block.tsx`) shows times without the end's date. (The yard's
     on-screen schedule line shares the DAS component and already shows it.)
  8. Existing bug: `resolve-job-tool-in-use-quantity.ts` passes `scheduleDate` ("Oct 5") to a
     date check that expects `YYYY-MM-DD`, so it never matches.
- **Still missing — crew tickets and notifications:**
  9. A sent ticket not yet started turns Expired and read-only at midnight of its row date
     (`job-tickets.repository.ts` counts; mobile `isPastFieldTicket`), while the payroll overlay
     waits for the Estimated End. Live bug for overnight shifts already; the mobile ticket payload
     (`field-ticket.mapper.ts`) does not carry the end's date yet.
  10. The mobile Adjust Time calendar stops at the schedule's last row date
      (`AdjustTimeSheet.tsx`), so an end on a later day cannot be picked.
  11. Emails, re-sent ticket notifications, the mobile shift label and ticket progress show the
      end as a time only; a re-send after only the end date moved looks identical.
- **Still missing — DAS follow-ups:** a continuing card on day X is refreshed by its own day's
  socket room, not day X's (30-second stale time); the map's "Start Time" field is On Site, not
  the schedule's Start.
- **Payroll:** see [../payroll/gaps.md](../payroll/gaps.md) → *A shift longer than 24 hours — how
  is it paid?*
- **Open questions** (recommendation in brackets, none confirmed):
  (a) May the rows inside a multi-day shift stay active with their own shifts? Nothing stops it,
  same-job allocations never clash, and holdover carry writes onto them. [Refuse a schedule where
  a shift overlaps the same job's later rows.]
  (b) May a row have a Shift 2 when its Shift 1 runs past the next day? The tab's overlap check
  now forces such a Shift 2 *before* Shift 1. [No.]
  (c) May a running shift's end be extended after the leave-yard cutoff or once tickets are sent
  (`jobs.service.ts` locks the row)? [Yes, end time and end date only.]
  (d) What does *Previous Night* mean — "was on Shift 2 yesterday" (the code) or "worked past
  midnight" (the window)? The tag also skips the window check in the employee panel.
  [The window.] See [daily-allocation-system.md](daily-allocation-system.md).
  (e) Is leave during a shift a warning (built) or a refusal? [daily-allocation-system.md](daily-allocation-system.md)
  (unverified) points both ways: *"On-leave employees are greyed out with a 'Leave' tag; they
  remain visible but non-assignable"* (line 76) against *"unavailable ones are greyed out but
  still drag-gable with a system warning"* (line 47). The API has no leave check on save.
  (f) The offload rule says a non-held item goes back every day — for one multi-day *shift*
  without holdover, does the crane come back mid-shift each night?
  **Note 2026-10-07:** such a shift can no longer be held, because holdover now needs two or more
  working days and one row counts as one
  ([../decisions/2026-10-07-holdover-not-allowed-on-a-single-day-job.md](../decisions/2026-10-07-holdover-not-allowed-on-a-single-day-job.md),
  `reference`, fouzan.shakil, not confirmed by TCG). Nobody asked about this case. The mid-shift
  nightly return is still open.
  (g) Which actions, if any, belong on a continuing card? Built read-only; its button opens its
  own day with the job expanded.
  (h) A crane still loaded out after its Estimated End: keep blocking other jobs?
  (i) Kyle said crews never go over 24 hours — see *Schedule times on a later day* (f).
- **Owner:** Lisette Anzaldo (dispatch); Dylan Masterson (yard, items 1–8 and (f), (h));
  Corrina Bustos (payroll).

## Schedule time order — may Start equal On Site, must the end follow On Site, and are older rows that break it left alone?

- **Status:** open
- **Asked:** 2026-10-01 — PR review of tcg branch `feat/schedule-datetime-holdover` (not merged).
- **Question:** The job Schedule tab and `PUT /jobs/:jobId/schedule` now enforce (a) **Start at
  or before On Site** — equal is allowed — and (b) the **Estimated End, on its day, after On
  Site**. (c) The API only re-checks shifts a save *changes*, so an older row that breaks the
  order never blocks saving the rest of the schedule. Are these the rules? The only written
  source, the punch list [../quotations/quotation.md](../quotations/quotation.md) line 31
  (unverified, in the quotations conflict set), says Start strictly **before** On Site; (b) is
  the build's reading of the 2026-09-30 ruling, not its words.
- **Built default:** (a) at or before; (b) after; (c) changed shifts only.
- **Owner:** Lisette Anzaldo (dispatch), with Joe Schacatano for the Start time.

## Make Holdover — which job lines can be held?

- **Status:** open
- **Asked:** 2026-10-01 — same review.
- **Question:** The Make Holdover picker offers **Assets** (lines with a sub-category and no
  employee type) and **Resources** (lines with an employee type) only. Tools and rigging, vendor
  lines, and billing-only custom lines cannot be held. Should rigging that stays on site be
  holdable — and if so, should it count against yard tool stock on the held days (see *Shifts
  that run past their own day* item 6)?
- **Built default:** assets and employee lines only.
- **Related:** [*Which items of a holdover job go back to the yard between working days?*](#which-items-of-a-holdover-job-go-back-to-the-yard-between-working-days)
- **Owner:** Lisette Anzaldo (dispatch), with Dylan Masterson (yard) for rigging.

## Holdover on the DAS — colour, label, and what the job-card pill counts

- **Status:** open
- **Asked:** 2026-10-01 — same review.
- **Question:** The build shows holdover in **purple**, labelled **"Holdover"** (job-card pill,
  slot chip, Schedule footer badge), and the board's resource cards keep **"On Hold"** for a
  held allocation. Lisette's sheet legend already uses **purple for "Working day and night"**
  ([crane-configurations.md](crane-configurations.md), unverified), and "On Hold" is also a job
  status (`ON_HOLD`). The job-card pill counts distinct job lines that are held plus lines whose
  allocation that day was copied with *Hold over*. Are the colour, the two labels and the count
  right?
- **Built default:** as above (purple chosen because amber already means Allocation Completed on
  the DAS).
- **Owner:** Lisette Anzaldo (dispatch).

## Holdover Loadout lock — should the API refuse a Loadout that leaves a held item behind?

- **Status:** open
- **Asked:** 2026-10-06 — PR review of tcg branch `feat/yard-holdover-loadout` (not merged). Nobody
  was asked.
- **Question:** In Start Loadout a held item (Make Holdover) is **ticked and locked**
  ([../decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md](../decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md),
  `reference`, CodingCops). Should the API also refuse a Loadout that leaves a held item out, as it
  already refuses offloading a held item before the job's last day? Or is the web lock enough?
- **Built default:** web-only. The lock is in
  `apps/web/src/features/dylen-dashboard/hooks/use-dylen-held-asset-selection.ts`.
  `completeLoadout` (`apps/api/src/usecase/das-loadout/das-loadout.service.ts`) has no held-item
  check. The Off-load rule is enforced by the API (400, `isOffloadHeld`).
- **Sources checked:** the decision above, *What this does NOT settle*: *"The API does not refuse a
  loadout that omits a held item. Not asked."* Nothing else written covers it. The earlier
  *"Loadout is refused for an item on site"* build note in
  [*Which items of a holdover job go back to the yard between working days?*](#which-items-of-a-holdover-job-go-back-to-the-yard-between-working-days)
  described a different, removed rule (corrected 2026-10-06).
- **Blocked:** nothing hard. A direct API call, or a client other than the web yard board, can load
  out a day without its held item.
- **Owner:** Lisette Anzaldo (dispatch).
- **Narrowed 2026-10-07:** a held item is now locked in Loadout only once it is out from an
  earlier day
  ([../decisions/2026-10-07-held-item-loadout-unlocked-until-it-first-goes-out.md](../decisions/2026-10-07-held-item-loadout-unlocked-until-it-first-goes-out.md),
  `reference`). The question now covers only those rows.

## Make Holdover — may a held line be removed or replaced on a middle day?

- **Status:** open
- **Asked:** 2026-10-07 — tcg branch `feat/holdover-single-day-block` (not merged). A lock was built
  for this and dropped after review. Nobody was asked.
- **Question:** On a **middle day** of a held job (after its first held day, before its last), may
  dispatch **remove or replace** a held line's allocation on the DAS? And does the answer differ
  for **asset lines** (the held crane) and **crew lines** (a no-show operator, a relief after 16
  hours)? A one-line answer settles it, for example: *"assets locked, crew free"*, *"both free"*
  or *"both locked; release in Make Holdover first"*.
- **What was tried, and why it was dropped:** a middle-day held-slot lock disabled removing or
  replacing a held line. It was dropped from the branch for two reasons:
  - it locked crew lines as well. That contradicts
    [daily-allocation-system.md](daily-allocation-system.md):64 (`unverified`, 9.6 KB, updated
    2026-04-30): *"Dispatcher can remove and replace a non-responding employee directly from the
    chip"*. That file is itself in an open conflict with
    [../projects-jobs/job-project-das.md](../projects-jobs/job-project-das.md)
    ([daily-allocation-INDEX.md](daily-allocation-INDEX.md));
  - a guard-ordering bug.
- **Built default:** no middle-day lock on held lines.
- **Sources checked:** [daily-allocation-system.md](daily-allocation-system.md):64, above.
  [../decisions/2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md](../decisions/2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md)
  rule 1 (a held item stays on site between working days) and
  [../decisions/2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md](../decisions/2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md)
  (other jobs are refused; release in Make Holdover first). Both `reference`, CodingCops. Neither
  says whether the held job itself may swap the line on a middle day.
- **Related:** [../decisions/2026-10-07-holdover-not-allowed-on-a-single-day-job.md](../decisions/2026-10-07-holdover-not-allowed-on-a-single-day-job.md)
  (`reference`), *What is built*.
- **Blocked:** any middle-day lock on held lines.
- **Owner:** Lisette Anzaldo (dispatch).

## Holdover — how does a day close when its only items are held and none is sent?

- **Status:** open
- **Asked:** 2026-10-07 — PR review of tcg branch `feat/holdover-improvements` (not merged). The
  developer (`haris`) chose to merge first and decide later. Nobody else was asked.
- **Question:** A held item can now go out on any day, unticked until sent
  ([../decisions/2026-10-07-held-item-loadout-unlocked-until-it-first-goes-out.md](../decisions/2026-10-07-held-item-loadout-unlocked-until-it-first-goes-out.md),
  `reference`). If a day's only assets are held and the yard sends none of them, nothing goes out.
  How should that day close? Options put to the developer: **Loadout closes it** (submit with only
  held items left behind; the day closes with nothing out), or **require it on that day** (keep
  held items ticked and locked when they are all the day has).
- **Built default:** nothing closes the day. The Loadout modal cannot submit an empty selection,
  the API refuses one (`completeLoadout`, *"Nothing to load out for this shift."*), there is no
  Off-load, and Force complete is reachable only from Off-load. The day's sub-job never reaches
  `COMPLETED`, so the job cannot roll up to Completed (SCRUM-903). Sending the held item that day
  avoids it.
- **Sources checked:** the 2026-10-07 decision above and
  [../decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md](../decisions/2026-10-06-yard-holdover-runs-normal-flow-ticked-and-locked.md)
  (exchange 1 was this blocker, solved then by forcing the held item out). Nothing written covers
  a day where a held item is deliberately not sent.
- **Blocked:** a held-only day where the yard holds the item back.
- **Owner:** Lisette Anzaldo (dispatch); Dylan Masterson (yard) for the yard flow.

## "Same resources" onto shift 2 drops the craft picked on shift 1

- **Status:** open
- **Asked:** 2026-10-16 — review of DAS craft-pill work by Jahanzaib Nadeem (tcg branch
  `fix/14-oct-uat`, no ticket). Pre-existing behaviour.
- **Question:** ticking *Same resources* copies shift 1's people onto shift 2 as drafts
  (`buildShift2Copies`,
  `apps/web/src/features/das/middle-section/jobs/hooks/use-sub-job-allocation-controller.helpers.ts`).
  The copy carries the employee but **not the craft picked for shift 1** (no `craftCodeId`). So
  an Oiler working an Operator seat on a secondary craft lands on shift 2 under their PRIMARY:
  the shift-2 pill shows the PRIMARY, and Save then raises the role-mismatch popup again. Should
  shift 2 inherit shift 1's picked craft?
- **Sources checked:** [../decisions/2026-09-28-boom-union-follows-the-worked-craft.md](../decisions/2026-09-28-boom-union-follows-the-worked-craft.md)
  clause 5 (`reference`, provisional): dispatch sets the day's craft when seating. Silent on a
  second shift.
- **Owner:** Lisette Anzaldo (dispatch).

## Which state locks the DAS board — the web and the API disagree

- **Status:** open
- **Asked:** 2026-10-16 — same review. Pre-existing behaviour.
- **Question:** the API refuses allocation edits when the sub-job is `TICKET_SENT` **or**
  `ticketsLocked` (`das-allocations.service.ts:267` and `:688`), except a slot whose ticket was
  REJECTED. The board only goes read-only when the job is cancelled or tickets are sent
  (`job-list-item-expanded.tsx:81`, `isLocked = isCancelled || isTicketSent`). On a sub-job that
  is `ticketsLocked` but not sent, the board accepts a drop or a craft change that the save then
  refuses. Copy Allocation already treats `ticketsLocked` as locked
  (`copy-allocation.utils.ts:70`). Should the board lock on `ticketsLocked` too?
- **Sources checked:** nothing written defines `ticketsLocked` from the dispatcher's side; the
  code is the only record.
- **Owner:** Lisette Anzaldo (dispatch).

## A craft picked on a draft is assigned to the employee at once — even if the draft is cancelled

- **Status:** open
- **Asked:** 2026-10-16 — same review. Pre-existing in the role-mismatch popup; the craft pill on
  unsaved slots (same branch) reaches it too.
- **Question:** both DAS craft pickers use the shared `CraftCodePickerModal`. Picking a craft the
  employee does not hold **first saves it as their SECONDARY** craft assignment
  (`apps/web/src/features/craft-codes/components/craft-code-picker-modal.tsx`, `handleSave`), and
  only then hands it to the slot. On a saved slot that is one action. On an **unsaved draft**,
  Cancel discards the draft but the employee keeps the new SECONDARY on their master record. Is
  that acceptable, should cancelling undo it, or should a draft only offer crafts the employee
  already holds?
- **Sources checked:** [../decisions/2026-08-20-craft-locked-rate-override.md](../decisions/2026-08-20-craft-locked-rate-override.md)
  (`verified`): the day's craft comes from a secondary assignment; it does not say who may
  create one. [../payroll/gaps.md → *Primary craft code constrained to the employee type, and changing a craft code in DAS*](../payroll/gaps.md#primary-craft-code-constrained-to-the-employee-type-and-changing-a-craft-code-in-das).
- **Owner:** Lisette Anzaldo (dispatch), with Corrina Bustos (craft assignments are payroll's).

## First right of refusal on the next day's crane — last-crew entitlement: Melissa's straight-time rule (2026-04-08) vs Kyle's overtime rule (2026-10-22)

- **Status:** open
- **Asked:** 2026-10-22 — ERP demo walkthrough part 2. Source: [2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md](../meetings/2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md) §9;
  transcript [2026-10-22-erp-demo-walkthrough-part-2.md](../meetings/transcripts/2026-10-22-erp-demo-walkthrough-part-2.md). Filed 2026-10-23;
  rewritten the same day once the earlier sources were found (the first vault check searched *right of
  refusal* and missed the vault's own term, **last-crew entitlement**).
  - **Melissa McNutt's e-mail, 2026-04-08** (sent with the Master Labor Agreement and the Local 12 Truck
    Crane Agreement as *"sample union rules we need incorporated into the system"*), recorded in
    [../erp-review-log.md](../erp-review-log.md) **#4 — Union rules to enforce** (`unverified`):
    *"The last crew on the equipment on straight time is entitled to the overtime work."* Bob and Tom on
    Crane 9001 for a day job 06:00–11:00; a night job comes in for the same crane at 19:00 — they are
    entitled to it. Dispatch must offer it to them first, or *"we could be liable to pay all 4
    employees."* Friday carries entitlement to Saturday; **next shift only** (not Sunday). The ask: the
    system notifies dispatch that an action is required before scheduling.
  - **Dispatch scheduling demo, 2026-04-09** ([transcript](../meetings/transcripts/2026-04-09-dispatch-scheduling-figma-demo.md),
    1:17:12–1:22:40). Kyle Harlow: *"some type of way of knowing who was last on premium time and who
    has the right to that machine next."* ehtesham.anwar restated Melissa's e-mail — for a second shift
    on the same crane, the last crew is entitled first, and if not offered, *"by the union rules … they
    are entitled to get another pay for that shift even though they did not work"* (Kyle: *"Yes"*) — and
    asked *"Do you want to manage that within the system or do you want it to be just manual?"* (1:18:50).
    **Kyle: in the system** — when Lisette is away *"somebody else decides to make a judgment … Those
    charges can be extremely expensive"*; dispatch must know *"I have to call that crew first"* (1:18:56).
    ehtesham.anwar proposed that dispatch **records which entitled people accepted or refused**, as a data
    point *"we can later on show to the relevant authorities"*; Kyle: *"Yep … that would be very
    helpful"* (1:19:46–1:20:45). Kyle doubted that system notifications would reach people at midnight
    (1:21:25).
  - **2026-10-22.** ehtesham.anwar (57:13): the DAS recommendations will change after the last session
    with Lisette — if a person works a job one day, *"we are legally obliged to ask them first"* for the
    next day. **Kyle Harlow, 1:08:22–1:10:01:** *"That's only for premium time, if they ended on a
    premium time … and they're going to start before the next day premium time."* If the crew ended on
    overtime and the crane goes out again before 6 AM, *"that crew has first right of refusal for that
    crane"*; if it leaves *"at 6 or later … We can put anybody in that machine."* Framed as the
    **machine** being paid; *"we'll probably have to like refine that."* Times transcribed *"6 P.m."*
    (1:08:40), *"6 A.m."* (1:08:58), *"4 P.m."* (1:09:17). ehtesham.anwar: *"Adds another check to our
    recommendation engine"* (1:09:45).
- **What the three agree on:** the entitlement is to the **next shift on the same crane**, and only when
  that next work is **overtime** (Melissa: *"entitled to the overtime work"*; Kyle: anyone may take a
  6 AM-or-later start). It is a **union rule** with a **pay consequence** for passing the crew over.
- **Question:** **(a) The trigger conflicts.** Melissa's e-mail: the crew was on **straight time**
  (her example ends at 11:00). Kyle, both in April (*"last on premium time"*) and on 10-22: the crew
  **ended on premium time**. Which is it — or is the trigger only that the next shift is overtime,
  whatever the last one was? **(b)** What counts as the "next shift" overtime: before 06:00, after 17:00,
  a weekend (Melissa's Friday → Saturday), or all of these? **(c)** Who holds the right — the whole crew
  on the crane (Melissa: *"Bob and Tom"*, the operator and oiler) — and does it extend to a driver or
  rigger? **(d)** The pay consequence — *"liable to pay all 4"*, *"another pay for that shift"*: is it a
  full shift at the overtime rate, and is it a payroll rule the ERP must compute? If yes, it needs a row
  in [../payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md) (G4). **(e)** What
  DAS does: rank the entitled crew first, warn on another crew, or block until an offer is recorded.
  Kyle chose "in the system" over manual on 04-09; the form is open. **(f)** Recording offers and
  refusals: agreed in principle on 04-09 (ehtesham.anwar proposed, Kyle *"Yep"*); where and by whom is
  open.
- **Sources checked:**
  - [../erp-review-log.md](../erp-review-log.md) #4 (`unverified`) — the rule as Melissa sent it, above.
  - [dispatch-value-engine-and-playbooks.md](dispatch-value-engine-and-playbooks.md) (`unverified`) —
    *"The playbook says dispatch performs this check; the review log says what the check is. Neither
    says how the system should enforce it, and no decision has been taken."*
  - [../payroll/hr-onboarding-and-employee-forms.md](../payroll/hr-onboarding-and-employee-forms.md) —
    points at the same review-log entry.
  - [daily-allocation-system.md](daily-allocation-system.md) (read through
    [daily-allocation-INDEX.md](daily-allocation-INDEX.md), `unverified`) — a *"Previous Night"* tag on
    employees who worked the previous night shift. Adjacent, not this rule.
  - [*Shifts that run past their own day — what is built, what is still missing*](#shifts-that-run-past-their-own-day--what-is-built-what-is-still-missing)
    item (d), what *Previous Night* means; [*Default crew per unit, overridable per job*](#default-crew-per-unit-overridable-per-job).
  - The payroll 06:00 overtime window: [../payroll/client-message-findings.md](../payroll/client-message-findings.md) (`reference`).
- **Blocked:** the recommendation-engine check; any DAS warning or block on the next day's crew; any
  payroll line for a passed-over crew.
- **Owner:** Kyle Harlow and Melissa McNutt (they stated different triggers); Corrina Bustos for the
  union-agreement clause and the pay consequence; Lisette Anzaldo (dispatch) for how the offer is
  recorded.
- **Update 2026-10-23:** two points of (e) and (f) are decided in principle by [../decisions/2026-04-09-last-crew-entitlement-managed-in-the-system-offers-and-refusals-recorded.md](../decisions/2026-04-09-last-crew-entitlement-managed-in-the-system-offers-and-refusals-recorded.md) (Kyle Harlow, 2026-04-09, recorded call, `verified`, hedged). For (e), the entitlement is managed **in the system, not manually**. For (f), dispatch **records which entitled crew members accepted or refused** the offer. Still open: (a) the trigger (straight time or ended on premium time), (b) what counts as next-shift overtime, (c) who holds the right, (d) the pay owed when the crew is passed over (no pay rule decided; G4), the form of (e) (rank, warn or block), and the detail of (f) (where the record lives and who enters it). The entry stays open.

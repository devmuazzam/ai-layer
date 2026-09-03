---
title: Dispatch — open questions
status: reference
kind: gaps
updated: 2026-09-03
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
- Status: open
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
- Status: open — needs confirmation
- **From (frozen original):** [gaps.md#requested-vs-dispatched-resources-melissa-stated-it-the-vault-still-says-the-opposite](../gaps.md#requested-vs-dispatched-resources-melissa-stated-it-the-vault-still-says-the-opposite)

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
- Status: open
- **From (frozen original):** [gaps.md#schedule-fields-the-build-already-agrees-and-the-new-fields-are-written-nowhere](../gaps.md#schedule-fields-the-build-already-agrees-and-the-new-fields-are-written-nowhere)


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

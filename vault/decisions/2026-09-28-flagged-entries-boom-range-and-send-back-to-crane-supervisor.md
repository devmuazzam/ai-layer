---
title: "Flagged entries: boom bracket vs crane range, and Send Back to a Crane Supervisor — decision"
source: decision/Syed Haris (CodingCops) — payroll flagged entries / send back, 2026-09-28 Claude Code session
decided: 2026-09-28
updated: 2026-09-30
decided_by: >-
  The CodingCops developer building payroll flagged entries and Send Back (git user
  devmohsinakram, in a Syed Haris Claude Code session). The developer answered on 2026-09-28, on
  behalf of the product, in-session, while building the feature on branch
  `feat/payroll-flagged-entries-send-back`. All six clauses come from that developer. This is a
  **developer's decision**, not a client-side product decision. It is `status: reference` for that
  reason, on the same basis as `2026-09-28-boom-union-follows-the-worked-craft.md`: it binds
  implementation now and TCG can overrule it. Ratifiers: **Brian Petros** (Data Analyst, ERP
  Project Coordinator) and **Corrina Bustos** (Payroll Manager) for the payroll side. For the
  field-ops side (who the Crane Supervisor is and what they may edit on a ticket), ratification
  goes to **the owner of field-ops at TCG**. No field-ops owner is named here because none is
  written down for this question.
status: reference
supersedes: []
conflicts_with:
  - decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md
  - decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md
provenance_note: >-
  AMENDED IN PART BY THE CLIENT, 2026-09-29 — see
  decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md
  (status: verified). Corrina Bustos, Payroll Manager and a named ratifier of this note, in writing
  (Teams): "please update all flags to go to the payroll admin and payroll manager. not the crane
  superintendent". Clause 3 (Send Back to one Crane Supervisor via the crane-supervisor role
  permission) and clause 5 (the supervisor is notified) are OVERRULED. Clause 4 (the supervisor
  corrects on web at /payroll-corrections) has lost its actor: who corrects now is open. Clauses 1,
  2 and 6 are not addressed, but clause 6's send-back block depends on Send Back having a target.
  Status stays reference because clauses 1, 2 and 6 stand. Body unchanged.
  SECOND CLIENT AMENDMENT, same day — see
  decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md
  (status: verified). CLAUSE 4 IS OVERRULED in two respects. (a) The Payroll Admin / Payroll Manager
  correct flagged entries, not a Crane Supervisor. (b) A correction applies to the INDIVIDUAL
  employee: a shared Start Work / End Job edit no longer moves the whole crew. Clause 4's "everything
  is editable" agrees with the client ("all times"). Clause 1's boom-range rule is now one of seven
  auto-flag sources. The body banner above predates this second amendment.
  THIRD CLIENT AMENDMENT, 2026-09-30 — decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md (status: verified).
  CLAUSE 6 IS OVERRULED: "A boom-range flag on its own only warns" no longer holds. EVERY flag
  (nine are listed) blocks approval until "adjusted and fixed". The open-send-back block is
  unaffected. Send Back survives, with the WORKER as target and a reminder after 3 hours. Clause 1's
  comparison basis (crane range vs the job configuration set by sales) was asked and NOT answered.
resolves:
  - "payroll/gaps.md#confluence-payroll-user-stories--first-payroll-pages-in-confluence-unmigrated (partial, provisional — send-back target (clause 3) and what makes an entry Flagged (clause 1) only; whether the Confluence pages supersede the vault stays open)"
jira: []
tags: [module/payroll, module/field-ops, module/assets, kind/decision, payroll-review, send-back, boom-length, craft-modifier]
entities: []
---

# Flagged entries: boom bracket vs crane range, and Send Back to a Crane Supervisor

> **Amended in part by the client, 2026-09-29.** Corrina Bustos (Payroll Manager): *"please update
> all flags to go to the payroll admin and payroll manager. not the crane superintendent"* —
> [2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md](2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md).
> **Clauses 3 and 5 below are overruled**; clause 4 has no actor until who corrects a flagged entry
> is answered. Clauses 1, 2 and 6 still stand. The overruled routing is already on `main`
> (PR #690, PR #691). The body below is kept as it was decided.
>
> **Amended 2026-09-29, clause 4 only:** build-up and break-down, live totals, and a pay
> estimate in the preview. Pay in the preview is shown only to users with `payroll:view` (item D,
> an interim direction, still open). See [*Addendum 2026-09-29*](#addendum-2026-09-29--build-up-and-break-down-live-totals-and-a-pay-estimate)
> at the end. The clauses below are unchanged, as written on 2026-09-28.
>
> **Amended again 2026-09-29, clauses 4, 5 and 6:** multi-day tickets.
> - The 23.5-hour cap is lifted.
> - Refusals give times in the payroll time zone, and entries show their date range.
> - A correction may move an entry into another pay week, and both weeks are recalculated.
> - A ticket over 24 h is priced as today and flagged for review.
>
> See [*Addendum 2026-09-29, second*](#addendum-2026-09-29-second--multi-day-tickets) at the end.
>
> **Amended a third time 2026-09-29, clause 4 and the first addendum's items A–C:** the payable
> window on the correction page. By the developer's final definition, the page's *Paid window* is
> Start Ticket → End Ticket (`WORK_TIME`). That is the span payroll prices, so it **agrees** with
> the verified
> [2026-09-03-paid-time-boundaries-yard-to-yard.md](2026-09-03-paid-time-boundaries-yard-to-yard.md).
> An earlier same-day reading, Start Work → End Work, conflicted with that decision and is
> superseded. The payroll engine is unchanged. See
> [*Addendum 2026-09-29, third*](#addendum-2026-09-29-third--payable-window-on-the-correction-page)
> at the end.
>
> **Amended a fourth time 2026-09-29, display only:** on the weekly timesheet, a priced entry over
> more than one date shows as a main row for its Start Ticket date, with each later date nested
> under it, and the rows add up to the entry. No pay rule, API or engine change. The open
> DAILY-premium question stays open. See
> [*Addendum 2026-09-29, fourth*](#addendum-2026-09-29-fourth--multi-day-entries-on-the-weekly-timesheet)
> at the end.
>
> **Amended a fifth time 2026-09-30, display only, superseding the fourth addendum's items A, C
> and D:** a multi-date entry now shows one independent row per date, each with the same ticket
> code, its own panel, and a Send Back that returns the whole ticket. Nothing is nested, and the
> `N days` chip is gone. The money division (fourth addendum, item B) is unchanged. No pay rule,
> API or engine change. See
> [*Addendum 2026-09-30, fifth*](#addendum-2026-09-30-fifth--independent-date-rows-on-the-weekly-timesheet)
> at the end.

**No ticket id is known for this work.** No Jira or Linear ticket was named when the decision
was made. The work lives on branch `feat/payroll-flagged-entries-send-back`, uncommitted as of
2026-09-28. Add the id to `jira:` above if one is found.

**Before this note, nothing written answered this.** Two things came closest:

- The Confluence story `Payroll management` (US-02 / US-03), which was never migrated and is
  unverified. Its conflict copy is
  [sync/.conflict/2026-08-24-bootstrap/payroll-management.md](../sync/.conflict/2026-08-24-bootstrap/payroll-management.md).
  It names the states *Clean*, *Flagged*, *Pending* and *Sent Back*. It says a flagged entry
  shows *"the applicable rule exception/reason"* (US-02 AC 4–6), and that Payroll may **Send
  Back** an entry (US-03 AC 2). It never says which rule flags an entry.
- [payroll/gaps.md → *Confluence payroll user stories*](../payroll/gaps.md#confluence-payroll-user-stories--first-payroll-pages-in-confluence-unmigrated),
  which says to cite those pages *as unverified Confluence*, not as the vault.

**UI reference, design intent only:** the prototype `Weekly Payroll Approval (standalone)4.html`,
specifically its *Approve Timesheet* modal and its unused *Send Back* dialog. Its flags were
hardcoded sample text, not the output of any rule. The prototype supplied the screen shape. It
did not supply the flag rule.

## Question

- What makes a payroll labor entry **Flagged**?
- Where do a crane's minimum and maximum boom lengths live?
- How does Payroll route an entry back to a Crane Supervisor for correction: who receives it,
  what may they change, how are they told, and what does an open send-back block?

## Decision

1. **The flag rule is boom bracket vs crane range.** An entry is flagged `OUT_OF_RANGE` when the
   boom bracket the crew selected on Labor & Unit lies **wholly outside** the set crane's minimum
   to maximum boom length. The bracket is the craft code modifier, in feet.
   - The test is `bracket.minFt > crane max` **or** `bracket.maxFt < crane min`. Any overlap
     counts as in range.
   - **Both sides are in feet, not hours.**
   - **When it is checked:** automatically on submission, meaning every Labor & Unit write
     (including set-wide bracket propagation). It is checked again after a supervisor
     correction.
   - **Where it is stored:** per crew row, in `ticket_employees.boom_range_check`
     (`IN_RANGE` / `OUT_OF_RANGE` / `RANGE_MISSING`), `boom_range_message` and
     `boom_range_checked_at`.
2. **Crane data.** Two new nullable columns, `assets.min_boom_length` and
   `assets.max_boom_length`: feet, `decimal(10,2)`.
   - Both are editable on the asset form, which enforces min ≤ max.
   - **Migration backfill:** `max` = `main_boom_length`. `min` is left empty and read as 0 ft.
   - **A crane with neither value set gives `RANGE_MISSING`.** The entry is listed as "boom range
     missing". It is **not** flagged, and no range is guessed.
3. **Send Back goes to one Crane Supervisor.** A Crane Supervisor is decided by a **department
   role permission**, not the employee `supervisor` checkbox (revised the same day, 2026-09-28,
   by the same developer: *"we will check permission from role"*).
   - **The permission:** a new module `crane-supervisor`, shown in Departments → Roles as
     *"Crane Supervisor — Returned Entries"*. `view` = see the entries sent to you;
     `edit`/`full` = correct and resubmit them. It defaults to `none` for a user with no
     department role, and every role template leaves it `none` — it is granted deliberately.
   - **Who Payroll can send to:** an active Employee with a login (`User.employeeId`) whose
     department role grants `crane-supervisor` at `edit` or `full`.
   - Payroll picks **one** specific supervisor from a server-searched picker.
   - Payroll **must** give a reason.
   - Admins and Super Admins can also see and correct every returned entry.
4. **The supervisor corrects on web.** The new *Returned Entries* page is at
   `/payroll-corrections`, with a sidebar item that shows a count badge.
   - **What they may edit:** everything on the entry, as in the prototype's *Approve Timesheet*
     design:
     - the boom bracket (craft code modifier);
     - the ticket time captures: Left Yard, Arrived On Site, Start Work, Start Boom, End Boom,
       End Work, Left Job Site, Arrived Yard, End Job.
   - **Start Work and End Job** edit the employee's own TCG-25 window when one is set. Otherwise
     they edit the ticket's shared times, which apply to the **whole crew**.
   - A correction note is required.
   - **A correction follows the same ticket-time rules as everything else** (added 2026-09-28 at
     the developer's direction: *"keep in mind all other rules as well like 8 hours rest time,
     2 job times should not overlap"*):
     - **Refused:** a changed milestone out of order, or closer than the configured step interval
       (`TICKET_STEP_INTERVAL_MINUTES`, default 30) to its neighbour — the mobile flow's rule,
       reusing `validate-step-times.ts`; a boom session outside Start Work → End Job; and a work
       window that **overlaps another of the employee's jobs**. Back-to-back (zero gap) is not an
       overlap (PAY-029).
     - The overlap refusal is **stricter than PAY-029**, which only raises an
       `OVERLAPPING_LABOR` review warning after calculation. It applies to a supervisor's
       correction only; mobile capture is unchanged.
     - **Warned, not refused:** under **8 hours' rest** beside another job. PAY-045 is a pay rule
       — the next shift is priced at the overtime floor when the period is recalculated — so the
       correction is accepted and the supervisor is told.
     - **The whole crew is checked.** Shared ticket times move every crew member, so the overlap
       refusal and the rest warning run for each crew member on the ticket (their own TCG-25
       window when set), not only the employee sent back.
     - **Missing captures can be added**, checked by the same rules: a milestone the ticket never
       recorded (e.g. Arrived Yard — PAY-018 cannot price an entry with missing times) and a new
       boom session. A milestone's end cannot be added before its start exists.
     - **Lunches and worked-through lunches** are editable, and each must sit inside the work
       window (a meal break is a half hour *of* the shift, PAY-046/047). Adding or removing a
       lunch is not supported.
     - **Also refused** (developer defaults, 2026-09-28 — no written rule existed):
       - a work window longer than **23.5 hours** (the only written cap, PAY-004's, which applies
         to imported FCC rows; applied here because a longer window is almost always a wrong date);
       - any time **in the future** (one minute of grace for clock skew).
     - **Cross-midnight:** the form edits date *and* time, so a capture can move to the next
       day. (This supersedes the earlier "keeps each capture's calendar date" limitation below.)
     - **Payroll time zone:** times are shown and entered in `PAYROLL_TIMEZONE`
       (America/Los_Angeles), whatever the supervisor's browser zone.
     - **Removals:** a mis-captured boom session or lunch can be removed. Milestones can be moved
       or added, never removed (PAY-018: an entry missing them cannot be priced).
     - **Lunches** can be added, removed, and switched between taken and worked through (WTL
       pays an extra half hour).
     - **Settled crew pay is protected:** a correction that moves shared ticket times is refused
       while another crew member's pay on that ticket is approved, or its period approved or
       exported — Payroll must reopen that week first.
     - **Preview:** before resubmitting, the supervisor can preview the hours before → after
       (labor total, net billable, boom, lunches), the changes, warnings, or the rule it would
       break. Pay is still priced only by recalculating the period.
     - **Audit trail:** each correction stores every changed field, before → after
       (`payroll_send_backs.correction_changes`), shown on the correction and on the payroll
       timesheet (PAY-002).
   - **A corrected entry still holds approval until the period is recalculated.** Approval of
     the week (and period) is refused while a correction's `correctedAt` is after the latest
     completed run — the figures in force would predate the correction. Automatic recalculation
     was not chosen: recalculating is a money operation Payroll triggers.
   - **On resubmission:** the entry is marked `CORRECTED` and the sender is notified in-app.
     Payroll then recalculates the period to price it.
5. **Notification** reaches the supervisor two ways:
   - in-app, as a list plus a count;
   - by email. The email uses the same layout as the internal quotation approval email
     (`buildQuotationEmailLayout`).
6. **What blocks approval.**
   - An entry that was sent back and not yet corrected **blocks** approval of that employee's
     week, and of the whole period.
   - A boom-range flag on its own **only warns**. It does not block.
   - An approved week **cannot** be sent back.

## Why

- **One concrete, checkable rule instead of sample text.** The Confluence story needs a flag to
  carry *"the applicable rule exception/reason"* (US-02 AC 6), but it names no rule, and the
  prototype's flags were decoration. The boom bracket is something the crew picks by hand. The
  crane's physical boom range is known per asset, so the two can be compared without guessing.
  A bracket that cannot overlap the crane's range is almost certainly a data-entry error that
  would change pay.
- **Overlap, not containment.** Brackets are ranges, such as 0–80 ft. A crane's usable boom is
  also a range. Flagging only when there is no overlap avoids false flags on legitimate picks at
  the edges of a range.
- **Missing data is reported as missing, not as a flag.** Only `max` could be backfilled, from
  `main_boom_length`. Treating a crane with no range as out of range would flood the review
  screen. Treating it as in range would hide it. `RANGE_MISSING` says what is true.
- **Warn, don't block, on the flag. Block on the open send-back.** A boom-range flag is a
  heuristic, and Payroll can judge it and approve anyway. An open send-back is Payroll's own
  statement that the entry is wrong until corrected, so approving past it would contradict that.
- **One named supervisor, and web only.** Sending an entry to a specific person gives it an
  owner and a notification target. The correction screen reuses the prototype's *Approve
  Timesheet* layout, which is the only design intent available.

## What this does NOT decide

- **Whether the worker (mobile) can also be a send-back target.** The prototype has a *"Send
  To: Worker"* option, and Confluence `PAY-WP-03` AC 3–4 and US-03 AC 10 say the same. **Not
  built. Open.**
- **The 3-hour automatic reminder** for a returned entry with no response (Confluence US-03 AC
  9). **Not built. Open.**
- **Any audit trail beyond the send-back record's own fields**: `sentAt`, `sentBy`,
  `correctedAt`, `correctedBy` and the note. Nothing records field-level before and after values.
- **Time edits that cross midnight.** The correction form keeps each capture's calendar date and
  edits only the clock time. Moving a capture to another day is not supported and not decided.
- **What else makes an entry Flagged.** This note defines only the boom-range rule. The
  Confluence story's other exception sources are **not** rules here:
  - ticket notes auto-flagged for review (US-03 AC 15);
  - *"Entries with Notes Missing"* (US-01 AC 7).
- **Whether a Crane Supervisor may Approve or Override a flagged entry directly.** Confluence
  US-03 AC 6–7 says they may. Here they correct and resubmit, and Payroll approves. Open.
- **Terminology.** This note says *Crane Supervisor*, meaning an Employee with the `supervisor`
  flag. Confluence and `2026-09-28-boom-union-follows-the-worked-craft.md` clause 5 say *crane
  superintendent*. Whether those are the same role is not settled here.
- **Whether the Confluence `Payroll management` / `Craft codes` pages supersede the vault.**
  That is the main question of the payroll gaps entry, and it stays open.

## Who ratifies on the client side

- **Brian Petros** and **Corrina Bustos** for:
  - clauses 1 and 6: what flags an entry and what blocks approval;
  - clauses 3 and 5: who may be sent an entry and how they are told.
- **The TCG field-ops owner** for:
  - clause 3: whether the `supervisor` flag is the right definition of Crane Supervisor;
  - clause 4: what a supervisor may edit on a ticket after it was submitted, especially that
    shared Start Work and End Job edits move the whole crew.
- **The TCG assets owner** for clause 2: the min/max boom columns and the backfill from
  `main_boom_length`.

## Effect on the vault

Done in the same pass as this note:

- [payroll/gaps.md → *Confluence payroll user stories — first payroll pages in Confluence, unmigrated*](../payroll/gaps.md#confluence-payroll-user-stories--first-payroll-pages-in-confluence-unmigrated)
  — **done**: its `Status` line now says the flag rule (clause 1) and the send-back target
  (clause 3) are answered provisionally and points here. The entry's main question stays open,
  and the rest of it is unchanged.

Not changed:

- No frontmatter was edited. No file is verified or superseded by a developer's reference
  decision.
- The Confluence conflict copy
  [sync/.conflict/2026-08-24-bootstrap/payroll-management.md](../sync/.conflict/2026-08-24-bootstrap/payroll-management.md)
  is untouched.
- **Not done, because index bodies are outside the recording agent's write scope:**
  [payroll/INDEX.md](../payroll/INDEX.md) → *Decisions that bind this module* needs a line for
  this note, and its count needs to go from thirteen to fifteen. It already does not list
  `2026-09-28-boom-union-follows-the-worked-craft.md`.

## Addendum 2026-09-29 — build-up and break-down, live totals, and a pay estimate

**What this amends: clause 4 only, in two places.**

- The editable captures under *What they may edit* (items A and B below).
- The last sentence of the *Preview* bullet, *"Pay is still priced only by recalculating the
  period"* (item C).

Clauses 1–3, 5 and 6 are unchanged. The clause text above is left as written on 2026-09-28. Where
it and this addendum differ, this addendum governs.

**Who decided.** The same developer as the original note: git user `devmohsinakram`, in a Syed
Haris Claude Code session on 2026-09-29. They were directing the rework of the correction page on
branch `fix/payroll-correction-page-ui` of the platform repo. Their words:

- *"Boom sessions there should be buildup, breakdown and boom time separately"*
- *"Milestones it should show all times not only specific also update total time on increase or
  decrease the sub-time"*
- *"preview should also show the all rates total amount"*

The quotes are the decision. The detail in A–C is how that session built them. Like the original
note, this is a **developer's decision** at `status: reference`: it binds implementation now, and
TCG can overrule it. **Nobody on the client side has ratified any of it.** Item D says what must be
confirmed.

**Build status.** Uncommitted on `fix/payroll-correction-page-ui`. The code was still being written
when this addendum was recorded, so the recording agent did **not** verify A–C against finished
code. `packages/shared/src/utils/ticket-time-totals.ts` (untracked) was on disk, holding
`computeLaborHours` and `computeTicketTimeTotals`, and API files under
`apps/api/src/usecase/payroll-send-backs/` were being modified. Check A–C against the merged code
when the branch closes.

### A. Build-up and break-down are editable (amends clause 4, *What they may edit*)

- The Crane Supervisor may also **edit, add (when missing) and remove** the ticket's **Build-up**
  (`BUILDUP_TIME`) and **Break-down** (`BREAKDOWN_TIME`). These are shown and edited separately from
  the boom sessions (`BOOM_TIME`).
- **One of each per ticket.** Adding a second build-up or a second break-down is refused.
- **They must sit inside the work window**: the employee's own TCG-25 window when set, otherwise
  the ticket's `WORK_TIME`. This check runs only on a build-up or break-down that the correction
  **changes or adds**. An existing one the correction leaves alone is not re-checked.
- **Order warns, it does not refuse.** If build-up → boom sessions → break-down are out of order,
  the supervisor gets a warning and the correction is accepted.
- **No auto-mirroring.** Moving a build-up or break-down never moves the edge of the boom session
  next to it, and moving a boom session never moves them. Each capture moves only when the
  supervisor moves it.

### B. Every time, with live totals (amends clause 4, *What they may edit* and *Preview*)

- **The page shows every time capture.**
  - The seven milestones: Left Yard, Arrived On Site, Start Work, End Work, Left Job Site, Arrived
    Yard and End Job (`TIME_FIELDS` in
    `apps/web/src/features/payroll-corrections/components/correction-form.parts.tsx`).
  - When the employee has their own window, the ticket's shared work window is also shown,
    **read-only**.
- **Each window shows its duration.**
- **Totals update live** whenever a time is moved, added or removed:
  - Labor Total and Net Billable;
  - the paid window and the billable window;
  - yard, job site, build-up, boom and break-down;
  - the **boom pay total**;
  - lunches and worked-through lunches (WTL).
- **The boom pay total is the union of build-up, boom sessions and break-down.** A moment covered by
  two of them is counted once.
  - PAY-043's boom pay window runs *"from build-up through breakdown"*
    (`payroll/payroll-rules-provenance.md`, row *Boom pay window*, Confirmed). This is why the three
    are totalled together.
  - The figure is **captured time, not what the engine credits**. The engine also rounds window
    edges to the **half** hour: start down, end up (`packages/payroll-engine/src/slices.ts:46-58`,
    PAY-020). This caveat is from the `boomPayHours` doc comment in `ticket-time-totals.ts`.
    *Corrected 2026-09-29 in the second addendum: this line first said "quarter hour". It copied
    that doc comment, which is wrong on the same point.*
- **One formula for the page and the API.** The page and the API's before → after preview both use
  the shared `computeTicketTimeTotals` (`@tcg/shared`, `packages/shared/src/utils/ticket-time-totals.ts`).
  - `computeLaborHours` moved there from
    `apps/api/src/usecase/ticket-labor-entries/compute-labor-hours.ts`, which now re-exports it.
  - Why one function: two copies of a formula drift, and the page and the preview would then
    disagree.

### C. The preview estimates pay (amends clause 4, *Preview*)

This replaces *"Pay is still priced only by recalculating the period"*.

- The preview now also shows an **ESTIMATE of pay**. It prices the employee's **whole pay week** in
  memory, before and after the correction.
  - It shows every rate line, the week total, this entry's share of it, and the deltas.
  - Why the whole week: rates, OT/DT and premiums depend on the week, not on one entry.
- **Nothing is persisted.** The estimate writes no run, job day or pay line.
- **Recalculating the period is still the only money write, and it sets final pay.** The estimate
  is not final pay.
- Clause 4's approval hold is unchanged. Approval is still refused while a correction is newer than
  the latest completed run.

### D. Pay in the preview only with `payroll:view` (interim direction; open, needs ratification)

- **Interim developer direction, 2026-09-29, later the same day.** The session wrote the options,
  and the developer chose **"Only with payroll view"**. The chosen option's text is the decision
  wording: *"The preview shows hours for everyone. Pay lines and totals only appear if the user also
  has the payroll:view permission. This is safest until Brian and Corrina answer."*
  - **Hours:** every user who may preview sees the hours before → after. That is `crane-supervisor`
    at `edit` or `full`.
  - **Pay:** only a user who also holds `payroll:view` sees the rate lines, the week total, this
    entry's share and the pay before → after.
  - **Not recorded: where the gate sits.** The recording agent was not told whether it is in the API
    response, the page, or both. If only the page hides pay, the API response still carries it to a
    user without `payroll:view`. The gaps entry below has said since it was opened that both need
    the gate.
  - **Build status: not built when this was recorded.** On 2026-09-29, a grep of
    `apps/api/src/presentation/payroll-corrections/`, `apps/api/src/usecase/payroll-send-backs/` and
    `apps/web/src/features/payroll-corrections/` found no `payroll:view` check.
- **Still open, and needs ratification.** **Brian Petros** and **Corrina Bustos** decide whether a
  Crane Supervisor may see pay without `payroll:view`. Until they answer, the interim direction is
  the conservative answer, as the chosen option itself says.
- The open question is at
  [payroll/gaps.md → *Should a Crane Supervisor see an employee's pay in the correction preview without payroll view*](../payroll/gaps.md#should-a-crane-supervisor-see-an-employees-pay-in-the-correction-preview-without-payroll-view).
  No ticket covers Send Back, so the question is in the payroll register and not a `spec.md` §12.
- **Superseded the same day, kept for the record.** This is what C first produced:
  - The preview route, `POST payroll-corrections/:id/preview`, needs only
    `@RequirePermission('crane-supervisor', 'edit')`
    (`apps/api/src/presentation/payroll-corrections/payroll-corrections.controller.ts`). It does not
    need `payroll:view`.
  - So **anyone holding `crane-supervisor` at `edit` or `full` saw the employee's pay rates and pay
    amounts** for the week of an entry sent to them, without `payroll:view`. Before C, the preview
    showed them hours only.
  - The developer directed that, and nobody at TCG ratified it. The interim direction above
    withdraws it.

### Stale lines in the original note

A–D contradict none of the *What this does NOT decide* lines. But some of those lines were already
overtaken by the note's own clauses as revised on 2026-09-28. **Where they differ, the clause
governs.** This is recorded at the developer's direction, 2026-09-29:

- ***"Any audit trail beyond the send-back record's own fields … Nothing records field-level before
  and after values."*** Overtaken by clause 4, *Audit trail*:
  `payroll_send_backs.correction_changes` stores every changed field, before → after.
- ***"Time edits that cross midnight … not supported and not decided."*** Overtaken by clause 4,
  *Cross-midnight*, which already says it supersedes this line.
- ***"Terminology. This note says Crane Supervisor, meaning an Employee with the `supervisor`
  flag."*** Overtaken by clause 3: the `crane-supervisor` department role permission decides who is
  a Crane Supervisor, not the `supervisor` flag.
  - **Only the definition is overtaken.** Whether *Crane Supervisor* and Confluence's *crane
    superintendent* are the same role **stays open**.
  - The same stale definition is in *Who ratifies*, where the field-ops owner confirms *"whether the
    `supervisor` flag is the right definition"*. Read it as the `crane-supervisor` role permission.

Two things were noticed while recording this, and are **not** resolved here:

- **Clause 4 contradicts itself on lunches.** One bullet says *"Adding or removing a lunch is not
  supported"*. A later bullet says *"Lunches can be added, removed, and switched between taken and
  worked through"*. The developer has not said which governs.
- **The payroll gaps entry is stale on the definition.**
  [payroll/gaps.md → *Confluence payroll user stories*](../payroll/gaps.md#confluence-payroll-user-stories--first-payroll-pages-in-confluence-unmigrated)
  still describes the send-back target as an Employee with the `supervisor` flag. Clause 3 replaced
  that with the role permission.

### Who ratifies A–D

This follows the split in *Who ratifies on the client side* above:

- **Brian Petros** and **Corrina Bustos**: D (whether a Crane Supervisor may see pay without
  `payroll:view`; the interim direction is no), and C (a pay estimate shown before the period is
  recalculated).
- **The TCG field-ops owner**: A (a supervisor editing build-up and break-down after submission;
  order only warns; nothing auto-mirrors).

### Effect on the vault (this addendum)

Done in the same pass:

- [payroll/gaps.md](../payroll/gaps.md): **done**. A new entry, *Should a Crane Supervisor see an
  employee's pay in the correction preview without payroll view* (`Status: open`), was appended.
- This file: `updated: 2026-09-29` was added to the frontmatter, and a one-line pointer was added
  under the title. `status` stays `reference`.
- **Revised 2026-09-29, later the same day:** item D now records the interim direction, pay only
  with `payroll:view`. Its first version is kept, marked superseded. The gaps entry has an
  *Update 2026-09-29* line and stays `open`.

Not changed:

- No other file's frontmatter. Nothing is verified or superseded by a developer's reference
  decision.
- [payroll/INDEX.md](../payroll/INDEX.md) still needs the line the section above describes. That is
  still outside the recording agent's write scope.

## Addendum 2026-09-29, second — multi-day tickets

**What this amends: clause 4, and clause 5's email.**

- Clause 4: the 23.5-hour refusal, how far the overlap and short-rest checks look, the wording of
  refusal messages, and how an entry's date is shown (items A–C below).
- Clause 5: the send-back email shows the entry's date range (item C).
- Clause 4 again, added later the same day: a correction may move an entry into another pay week
  (item F). Clause 6's review, also added later: a ticket over 24 h is flagged for review (item G).

Clauses 1–3 and 6 are unchanged, apart from G's added review flag. The clause text and the first 2026-09-29 addendum are left as
written, except for one line in that addendum's item B, corrected in place (see *Correction to the
first 2026-09-29 addendum* below). Where they differ from this addendum, this addendum governs.

**Who decided.** The same developer as the original note: git user `devmohsinakram`, in a Syed
Haris Claude Code session (syedharis14@gmail.com) on 2026-09-29. They were working on branch
`fix/payroll-correction-page-ui` of the platform repo. Their words:

- *"now job can go into multi days so also adjust payroll and return enteries according to it"*
- Asked whether that means an overnight ticket under 24 h, or a single ticket running 24 h or more
  over several days: *"both can be happend"*.
- Asked which day the hours after midnight belong to for payroll: *"read ai dlc for that info"*.

**The last answer points at existing notes. It is not a new ruling.** The two notes it points at:

- [2026-09-04-cross-midnight-day-type-and-holiday-minimum.md](2026-09-04-cross-midnight-day-type-and-holiday-minimum.md),
  **`status: verified`** (Corrina Bustos, in writing). It says:
  - each slice takes its own calendar day's type, and the cumulative bucket is never downgraded;
  - the holiday minimum is grouped per `CalendarDate`;
  - the daily and long-boom minimums are grouped on `ShiftAnchorDate` (:92-102).
- [2026-09-09-business-day-starts-at-midnight-local.md](2026-09-09-business-day-starts-at-midnight-local.md),
  **`status: reference`, not verified**. It is a developer's decision that Corrina has not ratified.
  The business day starts at 00:00 in the tenant's time zone.

Those two notes settle day type and where the day starts. **Neither says what a single entry of
24 h or more does to the pay rules.** Eight questions that raises are registered open (item E).
Per `CLAUDE.md` (the `packages/payroll-engine/` row), no pay rule changes without its source in
[payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md). **So this addendum
changes no pay rule, and the engine is unchanged by it.** Item G, added later, adds a review flag.
A review flag is not a pay rule.

Like the original note, this is a **developer's decision** at `status: reference`. It binds
implementation now, and TCG can overrule it. **Nobody on the client side has ratified any of it.**

**Build status: not built when this was recorded.** The recording agent checked the working tree of
`fix/payroll-correction-page-ui` on 2026-09-29. It still had:

- the cap, as `MAX_CORRECTED_SHIFT_HOURS = 23.5`
  (`apps/api/src/usecase/payroll-send-backs/correction-rules.ts:161-165`);
- the other-jobs search bounded by the send-back's `workDate`
  (`apps/api/src/usecase/payroll-send-backs/payroll-send-backs.service.ts:712-717`);
- refusal messages printing a bare UTC clock through `clock()`, as `HH:MMZ`
  (`correction-rules.ts:33`).

Check A–C against the merged code when the branch closes.

### A. A corrected work window may run 24 hours or longer (amends clause 4, *Also refused*)

- **The 23.5-hour maximum is lifted.** A correction may produce a work window of 24 h or more.
- **Why it can go.** Clause 4 already calls the cap a developer default. It was borrowed from
  PAY-004, and PAY-004 applies it only to imported FCC rows, which the legacy app rebuilds from a
  date and an hour count. ERP-born entries have real timestamps and *"span naturally"*
  ([payroll/rules/PAY-004-labor-entry-import.md](../payroll/rules/PAY-004-labor-entry-import.md):26, :31).
  - Brian Petros, 2026-09-07, on entries over 23.5 h: *"I don't think this will be a problem with
    our new ERP"* (PAY-004 :32-34).
  - Where the number comes from: 24 h minus one half-hour slice
    ([payroll/rules/PAY-020-half-hour-reckoning.md](../payroll/rules/PAY-020-half-hour-reckoning.md):23).
- The refusal of any time **in the future** is unchanged.
- **The overlap and short-rest checks look as far as the corrected window reaches.** Each crew
  member's corrected window sets its own bounds, instead of the send-back's snapshot `workDate`. A
  window over several dates is checked against every other job of that crew member that could
  touch it, on any of those dates.
- **The rules themselves are unchanged:**
  - an overlap is refused, and back-to-back is not an overlap (PAY-029);
  - under 8 hours' rest only warns (PAY-045);
  - the whole crew is checked.

### B. Refusals give the other capture's date and time in the payroll time zone (amends clause 4)

- A refusal names the capture it collides with: its label, date and time in `PAYROLL_TIMEZONE`.
  For example: *"Left Job Site (Sep 22, 12:14 PM PDT)"*.
- This replaces the bare UTC clock (`19:14Z`). That clock does not say which day it means, which
  matters on a window over several dates. It also does not match the times the supervisor typed,
  which clause 4 already shows and takes in `PAYROLL_TIMEZONE`.

### C. An entry over more than one date shows its date range (amends clauses 4 and 5)

- Returned Entries, the correction page and the send-back email show the entry's **date range**
  whenever its work window covers more than one date.
- **`PayrollSendBack.workDate` keeps its meaning.** It stays the anchor (pay) date, the date the
  entry is filed and priced under. The range is display only.

### D. Tension with a verified decision: one ticket per day (flagged, not resolved)

[2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md](2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md)
is **`status: verified`**. Its clause 1 (:31-35) says a job ticket is per asset group per day,
where the day can run past midnight. It quotes the dispatch sheet: *"one ticket per 'day'… where
'day' can extend past midnight"*.

- **An overnight ticket under 24 h fits that decision.**
- **A single ticket of 24 h or more is a new case.** In that decision, a job over several days is
  one ticket per day. The developer directed the 24 h+ case in this session. **Nobody at TCG has
  ratified it.**
- **This addendum does not override that decision.** It lets a correction record what a ticket
  actually captured. Whether field-ops should ever produce one ticket of 24 h+ is for TCG's
  field-ops owner, with the people that decision names: Lisette Anzaldo for dispatch, and Brian
  Petros.
- **Why it matters for pay:** one 24 h+ ticket and the same work as one ticket per day do not always
  price the same. Several of the questions in E (b, d, g) are exactly those differences.

### E. Pay rules this raises, registered open

Each of these is a pay rule, so none is decided here. **Owners: Brian Petros and Corrina Bustos.**
Each entry says what the engine does today and the one-line choice needed. They are in
[payroll/gaps.md](../payroll/gaps.md), because no ticket covers Send Back.

- (a) [Which pay period owns the hours after Saturday 00:00](../payroll/gaps.md#multi-day-entry--which-pay-period-owns-the-hours-after-saturday-0000)
- (b) [Does the 8-hour OT and 12-hour DT ladder ever reset inside one entry](../payroll/gaps.md#multi-day-entry--does-the-8-hour-ot-and-12-hour-dt-ladder-ever-reset-inside-one-entry)
- (c) [Daily and long-boom 4-hour minimums: shift anchor date or each calendar date](../payroll/gaps.md#daily-and-long-boom-4-hour-minimums--grouped-on-the-shift-anchor-date-or-on-each-calendar-date).
  This one is a conflict between written sources, not only a gap.
- (d) [Subsistence on a date reached only by a spill past midnight](../payroll/gaps.md#multi-day-entry--subsistence-on-a-date-reached-only-by-a-spill-past-midnight)
- (e) [Meal and WTL opportunities after 27 hours](../payroll/gaps.md#multi-day-entry--meal-and-wtl-opportunities-after-27-hours)
- (f) [The non-union workday for an entry longer than 24 hours](../payroll/gaps.md#multi-day-entry--the-non-union-workday-for-an-entry-longer-than-24-hours)
- (g) [DAILY catalog premiums: once per ticket or once per calendar date](../payroll/gaps.md#multi-day-entry--daily-catalog-premiums-once-per-ticket-or-once-per-calendar-date)
- (h) [A craft rate change that takes effect inside one entry](../payroll/gaps.md#multi-day-entry--a-craft-rate-change-that-takes-effect-inside-one-entry)

### F. A correction may move an entry into another pay week (amends clause 4; added later on 2026-09-29)

- **Who decided.** The same developer, later the same session. The session wrote the options, and
  the developer chose **"Allow and move the entry"**. The chosen option's text is the decision
  wording: *"The entry moves to the other week: the send-back's week and date update, and both weeks
  need recalculating. More work, and both weeks' approvals are affected."*
- **The case.** A correction moves Start Ticket (`WORK_TIME` start, or the member's own window
  start) across a Saturday 00:00 week line, into a different pay week.
- **What happens:**
  - The correction is allowed.
  - `PayrollSendBack.periodId` and `PayrollSendBack.workDate` follow the corrected Start Ticket.
    Both fields are in `apps/api/prisma/schema.prisma`, `model PayrollSendBack`.
  - **Both periods are flagged for recalculation**: the one the entry left and the one it joined.
  - Both weeks' approvals are affected. Clause 4 already holds approval of a week while a correction
    is newer than its latest completed run; under F, that applies to two weeks.
- **This is the entry's anchor moving, not a split.**
  - Every hour of the entry still goes to the one period its Start Ticket falls in. That is how the
    engine assigns entries today: a completed ticket is loaded into the period containing its
    `WORK_TIME` start (`apps/api/src/service/payroll/payroll.repository.ts:510-516`, working tree).
  - Item C still holds. `workDate` is still the anchor (pay) date; under F the anchor itself moves.
  - Whether the hours after Saturday 00:00 should instead **split** into the next period is still
    open, as gaps entry (a):
    [*Which pay period owns the hours after Saturday 00:00*](../payroll/gaps.md#multi-day-entry--which-pay-period-owns-the-hours-after-saturday-0000).
    F does not answer it.
- **A shared Start Ticket moves the whole crew** (clause 4). The move therefore affects every crew
  member priced from the shared time, not only the employee sent back.
- **Not recorded:**
  - what happens when the week the entry moves into is already approved or exported. Clause 4's
    settled-pay refusal speaks of the ticket's crew and their periods, and nobody said whether it
    also checks the destination week;
  - what "flagged for recalculation" means in the product: the existing approval hold on both
    weeks, or a separate marker.
- **Build status: not built when this was recorded.** On 2026-09-29, a grep of
  `apps/api/src/usecase/payroll-send-backs/payroll-send-backs.service.ts` found no code that changes
  a send-back's `periodId`.

### G. A single ticket over 24 h: price it, flag it for review (amends clause 6; added later on 2026-09-29)

- **Who decided.** The same developer, later the same session. The session wrote the options, and
  the developer chose **"Price it, flag for review"**. The chosen option's text is the decision
  wording: *"Payroll prices it as the engine does today, and the week shows a review flag ('ticket
  over 24 h, check pay rules') so Payroll looks at it before approving."*
- **Pricing is unchanged. No pay rule changes.** A 24 h+ entry is priced exactly as the engine
  prices it today. That leaves three behaviours standing, each of them an open question in E:
  - the 8/12 ladder never resets inside one entry:
    [(b)](../payroll/gaps.md#multi-day-entry--does-the-8-hour-ot-and-12-hour-dt-ladder-ever-reset-inside-one-entry);
  - subsistence is paid on the start date only:
    [(d)](../payroll/gaps.md#multi-day-entry--subsistence-on-a-date-reached-only-by-a-spill-past-midnight);
  - meal and WTL opportunities stop after the fourth:
    [(e)](../payroll/gaps.md#multi-day-entry--meal-and-wtl-opportunities-after-27-hours).
- **The flag.** The week shows a review flag, *"ticket over 24 h, check pay rules"*, so Payroll
  looks at it before approving. **The flag exists because (b), (d) and (e) are unanswered.** It
  answers none of them.
- **Not recorded:**
  - **The exact threshold.** The question was about a ticket of *24 h or more*, but the flag text
    says *over* 24 h. Which applies to a ticket of exactly 24 h was not stated.
  - **Whether the flag blocks approval or only warns.** Clause 6's boom-range flag only warns.
  - **Where the flag is raised** (engine or API), and its issue code.
- **G does not settle D.** Whether field-ops should ever produce one ticket of 24 h or more is still
  the open field-ops question in D. G only says what Payroll does when such a ticket exists.
- **Build status: not built when this was recorded.** On 2026-09-29, a grep of `apps/api/src`,
  `packages/payroll-engine/src` and `packages/shared/src` found no such flag.

### Correction to the first 2026-09-29 addendum

- **What was wrong.** Item B of that addendum said the engine rounds window edges to the **quarter**
  hour.
- **What is right.** It rounds to the **half** hour: start down, end up, 30 minutes.
  - Code: `packages/payroll-engine/src/slices.ts:46-58`, applied to boom windows in
    `packages/payroll-engine/src/calculate.ts:67-75`.
  - Rule: PAY-020, settled by
    [2026-08-24-payroll-time-rounding-method.md](2026-08-24-payroll-time-rounding-method.md)
    (`verified`).
- **Done:** the line is fixed in place, with a short correction note.
- **Not done:** the same wrong wording is in the code comment that line copied,
  `packages/shared/src/utils/ticket-time-totals.ts:180` (the `boomPayHours` doc comment). That file
  is outside the vault, so it is not changed here.

### Who ratifies this addendum

- **Brian Petros** and **Corrina Bustos**: A, because a pay window of 24 h or more now reaches the
  engine; and every question in E.
  - **Also F**: which week pays a moved entry, and two weeks' approvals.
  - **Also G**: pricing a 24 h+ ticket as the engine does today, behind a review flag, until (b),
    (d) and (e) are answered.
- **TCG's field-ops owner**, with the deciders of the 2026-09-14 note: D, whether one ticket may run
  24 h or more at all.
- B and C change only how times and dates are displayed. They need nothing beyond this note's own
  ratification.

### Effect on the vault (this addendum)

Done in the same pass:

- [payroll/gaps.md](../payroll/gaps.md): **done**. Eight entries appended, (a)–(h) above, each
  `Status: open`.
- This file: **done**.
  - A second line was added to the pointer under the title.
  - The quarter-hour line in the first addendum's item B was corrected in place, with a marked note.
  - `updated: 2026-09-29` already stood. `status` stays `reference`.
- **Revised 2026-09-29, later the same day:**
  - Items F and G were added, and the pointer under the title was extended.
  - Gaps entries (a), (b), (d) and (e) each gained a one-line *Related* pointer to F or G. Each
    stays `open`, with its question unchanged.

Not changed:

- **No other file's frontmatter.** Nothing is verified or superseded by a developer's reference
  decision. The 2026-09-14 one-ticket note is untouched and stays `verified`.
- **The field-ops question in D is not registered.** It is stated here only. If it needs tracking,
  it belongs in [field-ops/gaps.md](../field-ops/gaps.md): *"May one job ticket run 24 hours or
  more, or is a job over several days always one ticket per day?"*
- [payroll/INDEX.md](../payroll/INDEX.md) still needs the line described above. That is still
  outside the recording agent's write scope.

## Addendum 2026-09-29, third — payable window on the correction page

> **Read this first. The final definition resolves the conflict with a verified decision.**
>
> **The developer's final definition** (2026-09-29, same session): *"the payable time will be when
> i came from home to start and click on start ticket on clicking on start ticket to till end
> ticket all that time should be payable not let yard to arrived yard time"*.
>
> - **Start Ticket** is the **Start Work** button on mobile's ticket card: the punch-in that opens
>   `WORK_TIME` (`apps/mobile/components/field/ticket-card.tsx:361`, `:506`). Its banner reads
>   *"Start work to begin recording paid hours"*
>   (`apps/mobile/components/field/work-time-banner.tsx:39`).
> - **End Ticket** is **Submit ticket** on the Review step, which closes `WORK_TIME`
>   (`apps/mobile/features/field-ticket/steps/review/ReviewBody.tsx:553-555`, `:635`).
> - So the page's *Paid window* is Start Ticket → End Ticket: `WORK_TIME`, or the member's own
>   TCG-25 window when set. *Labor Total* is that window + 30 min per WTL (item A).
>
> **That is exactly the span payroll prices.** It is also how the engine implements
> [2026-09-03-paid-time-boundaries-yard-to-yard.md](2026-09-03-paid-time-boundaries-yard-to-yard.md)
> (**`status: verified`**: Kyle Harlow and Joe Schacatano decided it, Corrina Bustos concurred):
> *"Paid time starts at the dispatch start time at the yard and ends when the crane is back in
> the yard, fuelled, parked and the paperwork is done."*
>
> - **The conflict is resolved.** The page no longer disagrees with the verified note or with the
>   engine.
> - This resolution rests on the verified note. The developer's final words withdrew a reading
>   that contradicted it; they did not decide pay.
> - The open question is closed:
>   [payroll/gaps.md → *Payable time — Start Work to End Work, or yard to yard*](../payroll/gaps.md#payable-time--start-work-to-end-work-or-yard-to-yard).
>
> **Superseded, kept for the record.** Earlier the same day, this addendum recorded the developer's
> choice of **Start Work → End Work**. By their definition then, that was punch-in → break-down end.
> - It ended paid time on site, when break-down ends. The verified note says the opposite: *"The
>   return leg is paid time, and so is the post-trip work at the yard. Paid span is yard to yard,
>   not yard to job to job-exit."* (:101-102).
> - So the addendum carried a conflict box, `conflicts_with` in this file's frontmatter, and an
>   open gaps entry.
> - The final definition supersedes that reading. The superseded text is kept, marked, under
>   *Who decided* and item A.
>
> **Still open, and not this addendum's to settle:**
> [payroll/gaps.md → *Recording which time source paid a job day (PAY-017, TCG-178)*](../payroll/gaps.md#recording-which-time-source-paid-a-job-day-pay-017-tcg-178),
> questions 2 and 3. Is the punch-in the verified note's dispatch start? Is Review & Complete its
> "back in the yard … paperwork done"?

**What this amends.**

- Clause 4, *What they may edit* and *Preview*.
- The first 2026-09-29 addendum's items A (no auto-mirroring), B (live totals) and C (pay
  estimate).

It amends them **on the correction page only**. Clauses 1–3, 5 and 6 are unchanged. The text
above is left as written. Where it differs from this addendum, this addendum governs.

**Who decided.** The same developer as the original note: git user `devmohsinakram`, in a Syed
Haris Claude Code session (syedharis14@gmail.com) on 2026-09-29. They were working on branch
`fix/payroll-correction-page-ui` of the platform repo. Their words:

- *"we are just doing payable module for now you can just hide these [Net Billable / Billable
  window] entries for now and adjust payable entries"*. The bracketed words are the session's
  gloss, not the developer's.
- *"start work is always first entery when we atsrt ticket and endworking is last entery of job
  then we get back at yard and siging off from yard it should auto udgest when we increase the
  time anything between them"*
- *"like if i increase the boom hours from 3 to 6 it should auto add 3 hours in total work time"*
- *"on mobile app time logging main time is Start Work Time to End Work Time but i think you are
  getting Left Yard Time to End Job Time … you are getting confused because of names but
  functionality is diff fix them"*
- **Then they were asked explicitly. Superseded the same day by the final definition below.** The
  question quoted the verified 2026-09-03 decision and said that in code `WORK_TIME` (punch-in →
  Review & Complete) is what payroll prices. It asked which span is the payable (main) time. They
  chose **"Start Work → End Work"** over **"Punch-in → Review & Complete (recommended)"**.
  - The option they chose was worded: *"Pay only the build-up start → break-down end span. That
    changes what every employee is paid, contradicts the verified 2026-09-03 decision, and needs a
    written ruling from Kyle Harlow and Corrina Bustos plus a payroll-engine change. I would record
    the question and not change pay until they answer."*
  - **The words "build-up start → break-down end" were the session's gloss, not the developer's.**
    The developer picked the label "Start Work → End Work". Their own definition of those two
    words, in the first quote above, governs: Start Work is the ticket's first entry, and End Work
    is the job's last entry, before the crew return to the yard and sign off. Item A records that
    definition as its superseded version 2. The developer was not asked again after choosing; that
    reading rested on their own earlier words. Both readings are superseded by the final definition
    below.
  - **That option itself says pay does not change until Kyle Harlow and Corrina Bustos answer.**
    This addendum followed it, and pay never changed.
- **Final definition, which supersedes the choice above:** *"the payable time will be when i came
  from home to start and click on start ticket on clicking on start ticket to till end ticket all
  that time should be payable not let yard to arrived yard time"*.
  - Start Ticket is the punch-in and End Ticket is Submit ticket. That is `WORK_TIME`, the span the
    engine prices. The mobile cites are in the box at the top of this addendum.
  - *"not let yard to arrived yard time"* rules out Left Yard → Arrived Yard as the payable span.

Items C and E are how the session carries out those words. The recording agent was given no
separate verbatim quote for them. Item D's words are the first two quotes above. Its exact
definition of "later" is the session's implementation, passed to the recording agent on
2026-09-29. It is not a developer quote.

Like the original note, this is a **developer's decision** at `status: reference`. It binds the
page's implementation now, and TCG can overrule it. **Nobody on the client side has ratified any of
it.**

**Build status: not built when this was recorded.** The recording agent checked the working tree
of `fix/payroll-correction-page-ui` on 2026-09-29, after the final definition. It still had:

- *Paid window* hinted `'Start Work → End Job'`, and *Labor Total* hinted
  `'Paid window + 30 min per WTL'`
  (`apps/web/src/features/payroll-corrections/lib/correction-figures.ts:28`, `:42`).
  - Under the final definition that span is already right. The page's Start Work and End Job
    fields are the two ends of `WORK_TIME`. Only the names change (item C).
- *Net Billable* and *Billable window* on the page (same file, `:33-35`, `:47-49`).
- The labels `'Start Work Time'` and `'End Job Time'`
  (`apps/web/src/features/payroll-corrections/components/correction-form.parts.tsx:17`, `:21`).
- The shared formula, *Labor Total = `WORK_TIME` + 30 min per WTL*
  (`packages/shared/src/utils/ticket-time-totals.ts:28-32`, `:122`). This already matches the
  final definition.

Check A–E against the merged code when the branch closes.

### What the names mean

The same words name different instants on mobile and on this page. This is recorded because it is
what the developer said was confusing the build. All code cites were checked on 2026-09-29. Item C
gives the page's new names.

- **Page, "Start Work Time"** (to become *Start Ticket Time*) is `WORK_TIME.startedAt`. That is the
  punch-in: the **Start Work** button on mobile's ticket card. When the member has their own TCG-25
  window, it is that window's `workStartedAt` instead.
  - `apps/api/src/usecase/payroll-send-backs/payroll-send-backs.service.ts:379` (working tree)
  - `apps/api/src/usecase/job-tickets/ticket-step.constants.ts:73`
  - `apps/mobile/components/field/ticket-card.tsx:361`
- **Page, "End Work Time"** is `WORK_AT_JOB_SITE_TIME.endedAt`. On mobile that is the instant the
  **break-down timer** closed. Mobile has no End Work screen.
  - `payroll-send-backs.service.ts:380`
  - `ticket-step.constants.ts:74`
  - `apps/mobile/features/field-ticket/steps/start-work/StartWorkBody.tsx:261-274`
    (`endWorkCapture`, whose comment says *"There is no End Work screen any more"*)
- **Page, "End Job Time"** (to become *End Ticket Time*) is `WORK_TIME.endedAt`. That is **Submit
  ticket** on mobile's Review step, which the API calls Review & Complete.
  - `payroll-send-backs.service.ts:383`
  - `ticket-step.constants.ts:77`
  - `apps/mobile/features/field-ticket/steps/review/ReviewBody.tsx:553-555`
- **Mobile's in-flow `startWork` / `endWork` captures are the boom timer**, build-up start →
  break-down end. They are not `WORK_TIME`. Mobile's Labor Total reads them.
  - `apps/mobile/features/field-ticket/steps/shared/payable-time/labor-hours.ts:74-96`
    (`readBoomWindow`, which falls back to `buildup.start`), `:255-260`
- **Mobile keeps the two apart on purpose.** Labor & Unit no longer sends its `startWork` /
  `endWork` captures. Sending them had stamped End Work onto `WORK_TIME.ended_at`, and *"The
  payable window payroll prices silently became the billable one"*.
  - `apps/mobile/features/field-ticket/steps/labor/LaborBody.tsx:429-440`
- **Labor Total, per SCRUM-877 REQ-01 `[VERIFIED]`:** *"actual boom time plus 30 minutes for each
  WTL"*.
  - [aidlc/SCRUM-877/spec.md](../../aidlc/SCRUM-877/spec.md):145-150
  - Its source is [2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md](2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md)
    (`verified`). At :209-212 that note calls Labor Total *"a field-ops-local figure that may not
    equal whatever payroll's future engine eventually computes"*. **It does not make Labor Total
    the paid span.**
- **What payroll prices:** the member's own window when set, otherwise `WORK_TIME`
  (`payableWindow`).
  - `apps/api/src/usecase/payroll-pricing/payroll-week-pricing.service.ts:467-474` (working tree)
  - `apps/api/src/usecase/payroll/payroll.service.ts:1286-1293` on `main`
  - `apps/api/src/usecase/ticket-time-entries/derive-ticket-times.ts:311`

**Noticed, not resolved:** [aidlc/SCRUM-PROGRESS/spec.md](../../aidlc/SCRUM-PROGRESS/spec.md):201
says End Work *"closes `WORK_AT_JOB_SITE_TIME` when the crew leaves the job site"*. The mobile code
closes it when break-down ends (`StartWorkBody.tsx:261-274`). This addendum records the code.

### A. The page's Paid window and Labor Total are Start Ticket → End Ticket (amends clause 4 *Preview*, first addendum item B)

- **Final, 2026-09-29:** on the correction page, **Paid window** = **Start Ticket → End Ticket**.
  - That is `WORK_TIME`, from the punch-in to Submit ticket (Review & Complete). When the member
    has their own TCG-25 window, it is that window.
  - It is the span payroll prices (*What payroll prices*, above), and the span the verified
    2026-09-03 decision is built as. **No conflict.**
- **Labor Total** = that window + 30 min per WTL.
  - The shared `computeLaborHours` already computes exactly this: Labor Total = the payable
    window (`WORK_TIME`) + 30 min per WTL (`packages/shared/src/utils/ticket-time-totals.ts:28-32`,
    `:122`).
  - The page needs no change to that function. The earlier caution about changing it for this
    page no longer arises. It is also called by other API code.
- **The page's Labor Total is still not mobile's Labor Total.** Mobile's reads the boom timer
  (`labor-hours.ts:74-96`, `:255-260`), which starts at build-up. SCRUM-877 REQ-01 defines that
  figure. The two differ by all time outside build-up → break-down.
- **Superseded the same day, kept for the record.** This item had two earlier versions:
  1. **Start Work → End Work, with the start not settled.** It recorded the developer's choice of
     "Start Work → End Work". The chosen option's gloss read "build-up start → break-down end".
  2. **Punch-in → End Work.** It resolved the start from the developer's words *"start work is
     always first entery when we atsrt ticket and endworking is last entery of job then we get back
     at yard and siging off from yard"*.
     - The start was the punch-in (`ticket-step.constants.ts:7`, `:73`, `:88`;
       `StartWorkBody.tsx:277-278`).
     - The end was End Work, `WORK_AT_JOB_SITE_TIME.endedAt`, which is break-down end.
     - It conflicted with the verified note's end boundary.
  - The final definition supersedes both. The punch-in start from version 2 stands. The end moves
    from End Work to End Ticket.

### B. Net Billable and Billable window are hidden (amends clause 4 *Preview*, first addendum item B)

- Both are hidden on the correction page: in the live totals and in the before → after preview. The
  developer's reason: *"we are just doing payable module for now"*.
- **"For now" has no stated end.**
- **Not decided:** whether the API still computes and returns them. Net Billable elsewhere (mobile
  Labor & Unit, SCRUM-877 REQ-02) is unchanged.

### C. The page's names for the ticket's first and last captures (amends clause 4 *What they may edit*, first addendum item B)

- **"Start Ticket Time"**, which was "Start Work Time". Hint: *"Start Work on the ticket card —
  punch-in"*. It is the same capture: `WORK_TIME.startedAt`, or the member's own window start.
- **"End Ticket Time"**, which was "End Job Time". Hint: *"Submit ticket — Review & Complete"*. It is
  the same capture: `WORK_TIME.endedAt`, or the member's own window end.
- **"End Work Time"** keeps its name. Hint: *"break-down end"*. It is
  `WORK_AT_JOB_SITE_TIME.endedAt`.
- **Nothing else about them changes.** Clause 4 calls these two captures Start Work and End Job.
  They edit the member's own window when one is set. Otherwise they edit the ticket's shared time,
  which moves the whole crew.
- **Superseded the same day:** an earlier version of this item relabelled "End Job Time" to "Review
  & Complete". "Review & Complete" is now the hint on End Ticket Time.

### D. A ripple edit (amends first addendum item A, *No auto-mirroring*)

- When one capture moves, **every later capture moves by the same amount**.
  - The developer's words: *"it should auto udgest when we increase the time anything between
    them"*, and *"like if i increase the boom hours from 3 to 6 it should auto add 3 hours in total
    work time"*.
- **What "later" means.** This is the session's implementation, not a developer quote (see *Who
  decided*).
  - A capture is later if its time is **at or after the moved capture's old time**.
  - **Ties** are broken by capture order: Start Ticket, Left Yard, Arrived On Site, Build-up, Boom
    sessions, Break-down, End Work, Left Job Site, Arrived Yard, End Ticket.
  - An earlier version of this list named the first and last captures Start Work and Review &
    Complete. They are the same captures.
  - **Lunches** are ordered by their time.
  - **Adding a capture that was never recorded moves nothing.**
- **This contradicts the first addendum's item A:** *"Each capture moves only when the supervisor
  moves it."* Where they differ, this addendum governs.
- Nothing here relaxes clause 4's refusals.

### E. The pay estimate and the window it prices (amends first addendum item C)

- The estimate is priced by the engine through `PayrollWeekPricingService`.
  - `payroll-send-backs.service.ts:128`, `:143`
  - `apps/api/src/usecase/payroll-send-backs/correction-pay.ts:7`
- It prices the window the engine pays: the member's own window, otherwise `WORK_TIME`.
- **Since the final definition, that is the same span the page's Paid window shows.**
- **Superseded the same day:** while the End Work reading stood, the estimate priced a different
  span from the Paid window. The page was therefore to label it as priced on punch-in → Review &
  Complete. Whether that label stays was not recorded.
- **The engine is unchanged by this addendum.** Per `CLAUDE.md` (the `packages/payroll-engine/`
  row), no pay rule changes without its source in
  [payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md), same commit. Its
  *Paid time — start and end* row (:61) is **Confirmed** as yard to yard. The final definition
  needs no change to it.

### Who ratifies this addendum

- **A and E: nothing beyond the verified 2026-09-03 note.** The page now shows the span that note is
  built as.
  - Whether the punch-in and Submit ticket are that note's boundaries is a separate question:
    [payroll/gaps.md → TCG-178](../payroll/gaps.md#recording-which-time-source-paid-a-job-day-pay-017-tcg-178)
    questions 2 and 3, open. Owners: **Kyle Harlow / Joe Schacatano**.
  - *Superseded the same day:* while the End Work reading stood, A and E needed a written ruling
    from Kyle Harlow and Corrina Bustos, with Brian Petros.
- **TCG's field-ops owner**: D. It amends the first addendum's item A, which that owner ratifies.
- B and C change only what the page shows and what it calls a capture. They need nothing beyond
  this note's own ratification.

### Effect on the vault (this addendum)

Done in the same pass:

- [payroll/gaps.md](../payroll/gaps.md): **done**.
  - A new entry was appended, *Payable time — Start Work to End Work, or yard to yard*.
  - It was **resolved the same day** by the final definition. It now reads `Status: resolved
    2026-09-29`. Its text is kept as the record of what was in question.
  - A one-line pointer to it was added to the existing entry *Recording which time source paid a
    job day (PAY-017, TCG-178)*, then updated to say the question is resolved. That entry's
    questions 2 and 3 are unchanged and open.
- This file: **done**.
  - A third line was added to the pointer under the title. It was rewritten after the final
    definition.
  - `conflicts_with` in this file's own frontmatter named
    `decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md` while the End Work reading stood.
    It was **set back to `[]`** by the final definition. It had held only that entry.
  - `status` stays `reference`. `updated: 2026-09-29` already stood.
- **Revised twice the same day, 2026-09-29, at the calling session's direction:**
  1. Item A's start was resolved as the punch-in (punch-in → End Work), and item D's "later" was
     defined.
  2. The final definition, Start Ticket → End Ticket. It resolved the conflict, updated the names
     (C) and the ripple order (D), and resolved the gaps entry.

Not changed:

- [2026-09-03-paid-time-boundaries-yard-to-yard.md](2026-09-03-paid-time-boundaries-yard-to-yard.md)
  is untouched and stays **`verified`**. No other file's frontmatter was edited.
- [payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md) is untouched. Its
  *Paid time — start and end* row (:61) still reads yard to yard, **Confirmed**.
- [payroll/INDEX.md](../payroll/INDEX.md) still needs the line described above. That is still
  outside the recording agent's write scope.

## Addendum 2026-09-29, fourth — multi-day entries on the weekly timesheet

> **Superseded in part 2026-09-30.** Items A (a main row with later dates nested under it), C
> (main vs nested panels) and D's `N days` chip are replaced by independent date rows, each with
> the same kind of panel. D's list of when an entry stays one row is restated and extended there.
> **Items B and E stay in force.** See
> [*Addendum 2026-09-30, fifth*](#addendum-2026-09-30-fifth--independent-date-rows-on-the-weekly-timesheet).

**What this amends: no clause.** It adds a display rule for a surface the note did not cover: the
weekly payroll timesheet, `/payroll/:employeeId?weekStart=…`. It sits beside the second addendum's
item C, which shows a multi-date entry's date range on Returned Entries, the correction page and
the send-back email. Clauses 1–6 and the earlier addenda are unchanged.

**Who decided.** The same developer as the original note: git user `devmohsinakram`, on
2026-09-29, reviewing PR #699 (branch `fix/payroll-correction-page-ui`). They were looking at
ticket LEM-00048 (Sep 24–25, 2026) on `/payroll/:employeeId?weekStart=2026-09-19`. Their words:

- *"in provided image it should show 2 rows one for 24 and one for 25; 25 one will be nested to
  24 main row; both row should have one expand view to see overall calculations; make this design
  and handle this division in best way"*

The image was not given to the recording agent. The words settle three things: one row per date,
the later date nested under the first, and an expanded view on each row that shows the overall
calculation. **How the entry is divided between the rows is the session's implementation of
"handle this division in best way"** (items B–D). The recording agent was given no separate
verbatim quote for it.

- **An earlier direction the same day is quoted only in a code comment**, not in the vault:
  *"if a job spread in 2 days it should show 2 entries on weekly payroll against these 2 dates just
  handle it like child in ui"* (`apps/web/src/features/payroll/lib/payroll-date-rows.ts:4-6`).
  Under it, child rows carried hours only, and the module "never splits money" (:8-9). This
  addendum records the later direction, under which each row carries pay.

Like the original note, this is a **developer's decision** at `status: reference`. It binds the
timesheet's implementation now, and TCG can overrule it. **Nobody on the client side has ratified
it.**

**Presentation only. No pay rule, API or engine change, and no money moves.** The entry is still
one priced job day, with one stored total, paid in one week. The rows only divide how that total is
shown. No source in [payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md)
is needed or touched.

**Build status: committed, not merged.** Commit `b3c992f10` on `fix/payroll-correction-page-ui`
(PR #699), pushed 2026-09-29. Paths are under `apps/web/src/features/payroll/`, line numbers as of
that commit:

- `lib/payroll-entry-split.ts` (new): `splitEntryByDate` (:108-142) and its match check,
  `matchesRun` (:82-88).
- `components/payroll-employee-table.row.tsx` (modified): an entry is split by default (:45-72).
- `components/payroll-employee-table.nested.tsx` (new): the nested rows, `EntryDateRows`
  (:156-243).
- `components/payroll-employee-table.split.tsx` (new): the *Ticket by date* table
  (:97-163), the one-row explanation (:170-188), and a nested row's panel, `EntryDateDetail`
  (:232-263).
- The per-date slices are the server's `dateSplits`, read by `lib/payroll-date-rows.ts`, committed
  earlier in `5a5770309`. No API file is in this change.

Check A–E against the merged code when the branch closes.

### A. One row per date, with the Start Ticket date as the main row

- A priced entry whose half-hour slices cover more than one payroll-zone date shows as a **main
  row** for its Start Ticket date, with **one nested row per later date** under it.
- **Why the main row is the Start Ticket date:** it is the date the entry is filed under, and the
  date that decides which pay week pays it.
  - That is what the engine does today. Whether it is right for hours after Saturday 00:00 is the
    second addendum's item E(a), still open.
- A nested date outside the pay week is marked as falling before or after it
  (`payroll-employee-table.nested.tsx:32-54`). It is still paid in the main row's week.

### B. How the entry is divided between the rows

- **A nested row** shows its own date's half hours, from the server's `dateSplits`: worked hours,
  ST/OT/DT/H2x/H3x, and slice pay at base rate × multiplier.
- **The main row** takes the remainder of the entry's stored figures. That is its own date's
  slices, plus everything priced once for the entry:
  - premiums and adders;
  - the daily, long-boom and holiday minimums;
  - the rest premium;
  - meal deductions and WTL adds;
  - subsistence;
  - guarantee top-up hours.
- **So the rows add up exactly to the entry's stored total.** Nothing is re-priced in the browser.
- **Why the entry's own items sit on the main row:** it is the date the entry is paid under. The
  engine prices those items once for the entry, not for a date, and the web does not allocate
  them to one.

### C. Expanded panels

- **The main row's panel** shows the entry's full calculation, plus a *Ticket by date* table. The
  table has one line per date (window, worked, payable, hours by rung, slice pay), an *Entry
  items* line priced once for the ticket, and the ticket's total.
- **Each nested row's panel** shows that date's pay by rung (hours × rate = pay), then the same
  whole-ticket table with its own date picked out.
- So the overall calculation is one click from either row, as the developer asked.

### D. Folding, and when the split is not offered

- **A `2 days` chip** beside the ticket code (`N days` for N dates) folds the entry back to one
  whole row. Split is the default (`payroll-employee-table.tsx:83-85`,
  `payroll-employee-table.dates.tsx:40-42`).
- **The entry stays one row when the per-date explanation does not match the stored run**
  (`payroll-entry-split.ts:82-88`, `:112-113`). That happens:
  - after a correction not yet recalculated, because `dateSplits` is explained from the ticket's
    times as they are now;
  - with a chain carried in from last week;
  - on an API that sends no `dateSplits`. Its clock fallback gives hours only, no pay by date.
- Its panel then says why it is one row (`payroll-employee-table.split.tsx:170-188`).

### E. Not an answer to any open pay question

- **This does not answer**
  [payroll/gaps.md → *Multi-day entry — DAILY catalog premiums once per ticket or once per calendar date*](../payroll/gaps.md#multi-day-entry--daily-catalog-premiums-once-per-ticket-or-once-per-calendar-date),
  the second addendum's item E(g). **It stays open.** A DAILY premium shows on the main row
  because the engine prices it once per entry today, as that entry records. That is not a ruling
  that once per ticket is right.
- Also open and unaffected: E(a), which pay period owns the hours after Saturday 00:00, and E(c),
  daily and long-boom minimums on the shift anchor date or on each calendar date.
- **A display tension, noted, not resolved.** The verified
  [2026-09-04-cross-midnight-day-type-and-holiday-minimum.md](2026-09-04-cross-midnight-day-type-and-holiday-minimum.md)
  groups the holiday minimum on `CalendarDate` (:92-95). When the holiday is a later date of the
  entry, the main row can show a minimum that belongs to a nested date. The total is unchanged;
  only the row it shows on is.
- **If E(g) or E(c) is answered "per calendar date"**, those items would be priced per date, and
  item B's placement of them on the main row must be revisited.

### Who ratifies this addendum

- **A–D: nothing beyond this note's own ratification.** They change only how the weekly timesheet
  shows an entry, like the second addendum's items B and C.
- **The pay questions in E**: Brian Petros and Corrina Bustos, as already registered.

### Effect on the vault (this addendum)

Done in the same pass:

- This file: **done**.
  - A fourth line was added to the pointer under the title.
  - `updated: 2026-09-29` already stood. `status` stays `reference`, and `conflicts_with` stays
    `[]`.

Not changed:

- [payroll/gaps.md](../payroll/gaps.md) is untouched. E(a), E(c) and E(g) stay `open`. This
  direction raises no new pay question.
- **The holiday-minimum display tension in E is not registered.** It is stated here only. If it
  needs tracking, it belongs in [payroll/gaps.md](../payroll/gaps.md): *"On a multi-date entry
  whose holiday falls on a later date, should the timesheet show the holiday minimum on that
  date's row rather than the main row?"*
- **No other file's frontmatter.** Nothing is verified or superseded by a developer's reference
  decision.

## Addendum 2026-09-30, fifth — independent date rows on the weekly timesheet

> **Read with the later 2026-09-30 decisions.** Corrina Bustos's verified decisions of the same
> day change who acts on a Send Back:
> - Send Back now goes to the **worker**, with a 3-hour reminder
>   ([2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md)).
> - Payroll fixes entries itself
>   ([2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md](2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md)).
>
> So "sent back as a whole", below, now means two things:
> - **Every date of the ticket**, as item D says.
> - **Every worker on a shared ticket**, per the developer's crew answer (item C6 of
>   [2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md](2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md)).
>   Sending back the Oiler or the Operator sends the ticket to both and blocks both their weeks.
>   That is **the developer's reading, pending Corrina**, so the multi-crew gap stays open.
>
> **The Crane Supervisor correction page is superseded as the corrector.** That is the
> `/payroll-corrections` form reworked on PR #699. Payroll's own fix and the worker's mobile edit
> replace it (item C3 of the same note). This addendum's timesheet rows are unaffected.

**What this amends: the fourth addendum's items A, C and D.** It changes how the weekly payroll
timesheet, `/payroll/:employeeId?weekStart=…&periodId=…`, shows an entry that runs over more than
one date. The fourth addendum's **item B** (how the money is divided between the rows) and **item
E** (answers no open pay question) **stay in force**. Clauses 1–6 and the first three addenda are
unchanged.

- **Item A**, a main row with later dates nested under it, is replaced by independent top-level
  rows, one per date.
- **Item C**, the main vs nested panels, is replaced by one kind of panel on every date row.
- **Item D**'s `N days` chip, which folded the entry back to one row, is removed. D's list of when
  an entry stays one row is restated and extended in item E below.

**Who decided.** The same developer as the original note: git user `devmohsinakram`, on
2026-09-30, on PR #699 (branch `fix/payroll-correction-page-ui`), about the weekly timesheet. Their
words:

- *"if a job done in 2 days like 27 and 28 in payroll on this page there is no need to add nested
  entery on for 27 and 28; make independent enteries for both days with same ticket id and manage
  everyting in both enteries; when send that ticket back for corrrection like for 27 or 28 it
  should send all ticket back not jut 27 or 28 one entry; do your best to handle it"*

The words settle three things:

- **One independent row per date, with the same ticket id.** No nesting.
- **"Manage everything in both entries."** Every date row has the same panel and the same actions.
- **Sending back from either date sends the whole ticket back**, not one date's share of it.

The rest is the session's implementation of *"do your best to handle it"* (items A–E). The
recording agent was given no separate verbatim quote for it.

- **How "it should send all ticket back" was read.** As every date and every capture of **this
  employee's** entry on that ticket. That is how Send Back already worked (item D). It was **not**
  read as the ticket for every crew member on it, and the developer was not asked. That other
  reading is registered as an open question:
  [payroll/gaps.md → *Send Back of a multi-crew ticket*](../payroll/gaps.md#send-back-of-a-multi-crew-ticket--does-sending-a-ticket-back-also-return-it-for-the-other-crew-members-on-that-ticket).

Like the original note, this is a **developer's decision** at `status: reference`. It binds the
timesheet's implementation now, and TCG can overrule it. **Nobody on the client side has ratified
it.**

**Presentation only. No pay rule, API, engine or schema change, and no money moves.** The entry is
still one priced job day, with one stored total, paid in one week. The rows only divide how that
total is shown. No source in [payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md)
is needed or touched.

**Build status: built, uncommitted.** Web only, on branch `fix/payroll-correction-page-ui` (PR
#699), in the working tree on top of commit `b3c992f10`. No commit hash yet. Paths are under
`apps/web/src/features/payroll/`. Line numbers are not given, because the working tree was still
changing when this was recorded:

- `lib/payroll-entry-split.ts` (modified): `splitEntryByDate` now returns a flat `parts[]`, in date
  order, with `parts[0]` the Start Ticket date carrying the entry's items.
- `lib/payroll-timesheet-rows.ts` (new): `timesheetRows`, which orders the rows.
- `components/payroll-job-day-dates.ts` (modified): `timesheetRowsOf`.
- `components/payroll-employee-table.tsx`, `.row.tsx`, `.cells.tsx`, `.dates.tsx`, `.split.tsx`
  and `.expanded.tsx` (modified).
- `components/payroll-employee-table.nested.tsx`, the fourth addendum's nested rows, is
  **deleted**.
- No `apps/api` file is in this change.

Check A–F against the merged code when the branch closes.

### A. One independent row per date (supersedes the fourth addendum's item A)

- An entry split by date shows **one top-level row per payroll-zone date**. No row is nested under
  another.
- **Each row carries the same ticket code**, plus a `Day k/N` badge. Its hover text says it is one
  ticket, priced as one entry, paid in the week of its Start Ticket date, and sent back as a whole.
- **Rows sort by date, then by the start of that row's part of the shift.** A later date's row sits
  among that date's other entries, not under its first date.
- **A date outside the pay week** is marked *after week* or *before week*. The row stays on the
  anchor week's timesheet, because that week pays it.
  - That is what the engine does today. Which week should own hours after Saturday 00:00 is the
    second addendum's item E(a), still open.
- **A Daily Summary date filter** now shows only that date's rows. An entry that could not be split
  (item E) still shows on every date it touched.

### B. Money per row (the fourth addendum's item B, unchanged)

The division is the fourth addendum's item B. It is restated here for the new row shape.

- **Each later date's row** shows its own `dateSplits` hours, rungs and slice pay.
- **The Start Ticket date's row** takes the remainder. That is its own slices, plus everything
  priced once for the ticket.
- **So the rows add up exactly to the entry's stored total.** Nothing is re-priced in the browser.
- **Long boom, lunch/WTL hours and rule adjustments** are priced once for the ticket. They show only
  on the Start Ticket date's row. A later row shows a dash, with hover text saying why. So no hour
  or dollar is counted twice down the table.
- **Craft, modifier and rules badges** describe the whole ticket, and show on every row.

### C. One kind of panel on every row (supersedes the fourth addendum's item C)

Every date row has its own expand chevron. The panel reads, in order:

1. **The ticket's review state:** flag, and send-back state.
2. **That date's own section:**
   - the date, and day k of N;
   - window, worked, payable, and hours by rung;
   - pay. On the Start Ticket date, the entry-items share is named;
   - *Pay on this date*, by rung.
3. **A *Whole ticket `<code>` · `<date range>`* heading**, over the ticket-level sections:
   - start/end, shift, gap, modifier, time source, boom union;
   - worker comment, meal periods, rule explanation;
   - the *Ticket by date* table, with this row's date picked out.
4. **The actions.**

So the overall calculation is one click from any row, as the fourth addendum's direction asked,
and every row is managed the same way, as this one asks.

### D. Send Back from any date row returns the whole ticket

- **This was already how the system worked. Now every row exposes it.**
  - A send-back is keyed per (period, job ticket, employee)
    (`apps/api/src/usecase/payroll-send-backs/payroll-send-backs.service.ts:246-268` at
    `b3c992f10`).
  - The correction page edits every date and every capture of the ticket.
- **Every row passes the job day's own id.** So both rows show the same send-back state, and the
  button reads *Send back whole ticket*.
- **The Send Back dialog lists one line per ticket**, with *all N dates*.
- **Counts now say tickets, not entries:** the stats line, the ADP dialog, the send-back banners and
  the toast.
- **What this does not settle:** whether sending one employee's entry back should also return, or
  hold, the ticket for the **other crew members** on it. A correction to shared ticket times changes
  their pay, but creates no send-back or approval hold for them. That is open:
  [payroll/gaps.md → *Send Back of a multi-crew ticket*](../payroll/gaps.md#send-back-of-a-multi-crew-ticket--does-sending-a-ticket-back-also-return-it-for-the-other-crew-members-on-that-ticket).

### E. When it stays one row (replaces the fourth addendum's item D)

- **The `N days` chip is removed.** Splitting is no longer a toggle. An entry that can be split is
  always shown split.
- **The entry is not split, and its panel says why, when:**
  - its per-date explanation does not match the stored run: hours per bucket or worked hours
    differ. That happens with a chain carried in from last week, or a correction that moved the
    rungs;
  - its first date is not the stored Start Ticket date;
  - there is no base rate to price slices with, as on an entry paid only at holiday rates;
  - its ticket was corrected while the week still has a correction waiting to be recalculated;
  - the API sent no `dateSplits`.

### F. Still not an answer to any open pay question (the fourth addendum's item E stands)

- **E(a), E(c) and E(g) stay open**, as the fourth addendum's item E says:
  - which pay period owns the hours after Saturday 00:00;
  - daily and long-boom minimums on the shift anchor date or on each calendar date;
  - DAILY catalog premiums once per ticket or once per calendar date.
- A DAILY premium or a minimum shows on the Start Ticket date's row because the engine prices it
  once per entry today. That is not a ruling that once per ticket is right.
- **The holiday-minimum display tension** in the fourth addendum's item E still applies, with *the
  Start Ticket date's row* in place of *the main row*. It is still not registered.

### Who ratifies this addendum

- **A–E: nothing beyond this note's own ratification.** They change only how the weekly timesheet
  shows an entry. Item D exposes Send Back as clause 3 already defines it.
- **The multi-crew Send Back question that item D raises:** Brian Petros and Corrina Bustos, who
  ratify clauses 3 and 6. The TCG field-ops owner ratifies clause 4, which makes shared edits move
  the whole crew. No field-ops owner is named for this question.
- **The pay questions in F**: Brian Petros and Corrina Bustos, as already registered.

### Effect on the vault (this addendum)

Done in the same pass:

- This file: **done**.
  - A fifth line was added to the pointer under the title.
  - A *Superseded in part 2026-09-30* note was added at the top of the fourth addendum.
  - `updated: 2026-09-30`. `status` stays `reference`, and `conflicts_with` stays `[]`.
- [payroll/gaps.md](../payroll/gaps.md): **done**. One new entry was appended, `Status: open`:
  [*Send Back of a multi-crew ticket — does sending a ticket back also return it for the other crew
  members on that ticket?*](../payroll/gaps.md#send-back-of-a-multi-crew-ticket--does-sending-a-ticket-back-also-return-it-for-the-other-crew-members-on-that-ticket)

Not changed:

- E(a), E(c) and E(g) in [payroll/gaps.md](../payroll/gaps.md) stay `open`, and their entries are
  untouched.
- **No other file's frontmatter.** Nothing is verified or superseded by a developer's reference
  decision.
- [payroll/INDEX.md](../payroll/INDEX.md) still needs the line described above. That is still
  outside the recording agent's write scope.

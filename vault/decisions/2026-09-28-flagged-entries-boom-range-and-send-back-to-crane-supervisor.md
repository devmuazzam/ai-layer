---
title: "Flagged entries: boom bracket vs crane range, and Send Back to a Crane Supervisor — decision"
source: decision/Syed Haris (CodingCops) — payroll flagged entries / send back, 2026-09-28 Claude Code session
decided: 2026-09-28
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

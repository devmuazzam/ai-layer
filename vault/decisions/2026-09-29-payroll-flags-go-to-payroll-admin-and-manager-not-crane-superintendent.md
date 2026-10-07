---
title: "Payroll flags go to the payroll admin and payroll manager, not the crane superintendent — decision"
source: decision/Corrina Bustos (TCG Payroll Manager) — Teams reply, 2026-09-29
decided: 2026-09-29
decided_by: >-
  Corrina Bustos (TCG, Payroll Manager — the payroll owner), in writing, in a Microsoft Teams
  reply to Syed Haris (CodingCops) on 2026-09-29. She was answering a message Syed Haris sent
  her the same day. That message described the payroll review design built under
  decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md and asked
  eight questions. She answered **only the routing point**. The other seven are unanswered, and
  are recorded as open in payroll/gaps.md. Syed Haris is sending her a follow-up with them.
  Brian Petros (the other named ratifier of the 2026-09-28 note) has not commented.
status: verified
conflicts_with: []
provenance_note: >-
  FOLLOWED UP THE SAME DAY — Corrina Bustos's second Teams reply (2026-09-29) answers this note's
  open items 1 (payroll corrects), 2 (Payroll Administrator = Micaela Slykhuis today, an assignable
  role; both roles get all flags and either may adjust) and most of 5 (corrections per employee,
  all times editable, rest gap from rounded paid time, six more auto-flag sources). See
  decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md.
  Items 3, 4 and 6 and the reminder stay open. Body unchanged.
  2026-09-30: item 3 answered — Send Back survives, and its target is the WORKER, with a reminder
  after 3 hours — in decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md. Every flag now blocks approval until fixed.
  2026-10-07: PROVISIONAL TENSION, not an overrule. Melissa McNutt (TCG President), in written Teams
  answers posted on or before 2026-10-06, answered "Yes" to whether supervisors or dispatchers may
  complete or correct tickets on a worker's behalf. She also named "manager or payroll" as the
  approver of late and post-submit edits, without saying which manager. TCG then asked CodingCops to
  hold those answers until an updated version is sent. This note's exclusion covers flags, not edit
  approvals; whether it should reach them is open. Recorded in
  decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md
  (status: reference, T2, T3). Open in payroll/gaps.md under "Who may complete or correct a ticket on
  a worker's behalf".
supersedes_partial:
  - decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md (clause 3 send-back target; clause 5 notification recipient. Clause 4's actor is removed; its rules are not ruled on. Clauses 1, 2 and 6 untouched)
resolves:
  - "payroll/gaps.md#confluence-payroll-user-stories--first-payroll-pages-in-confluence-unmigrated (partial: who flags go to only. It replaces the provisional clause-3 answer recorded there on 2026-09-28)"
jira: []
tags: [module/payroll, module/field-ops, kind/decision, payroll-review, send-back]
entities: []
---

# Payroll flags go to the payroll admin and payroll manager, not the crane superintendent

**This is a partial decision.** It settles who flags go to. It does not settle who corrects a
flagged entry, whether Send Back survives, or who "payroll admin" is. Those are open in
[payroll/gaps.md → *Flagged entries go to payroll, not the crane superintendent*](../payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives).

## Decision

Corrina Bustos, Teams, 2026-09-29, verbatim:

> "Hello, please update all flags to go to the payroll admin and payroll manager. not the crane
> superintendent"

What that settles:

1. **Payroll flags are routed to two payroll roles:** the *payroll admin* and the *payroll
   manager*.
2. **They are not routed to the crane superintendent.** She was replying to a description of
   the design in which Payroll sends a flagged entry back to one *Crane Supervisor*, who corrects
   it at `/payroll-corrections`. Her exclusion is aimed at that recipient, whichever of the two
   names is used for the role.

## What it changes in the 2026-09-28 note

[2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md](2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md)
was a CodingCops developer decision (`status: reference`), with Brian Petros and Corrina Bustos
named as ratifiers for clauses 3 and 5. This is Corrina's answer on those clauses, and it
overrules them.

- **Clause 3 (Send Back goes to one Crane Supervisor, via the `crane-supervisor` role
  permission):** overruled. The client does not want flags routed to that role.
- **Clause 5 (the supervisor is notified in-app and by email):** overruled as to who is told.
  The recipients are the payroll admin and the payroll manager. How they are told (in-app,
  email, or both) is not stated.
- **Clause 4 (the supervisor corrects on web at `/payroll-corrections`):** loses its actor. The
  correction rules listed under it (step order, overlap, 8-hour rest warning, whole-crew check,
  and the rest) are not ruled on either way. Whether anyone still uses that screen is open.
- **Clauses 1, 2 and 6** (the boom-range flag rule, the crane min/max columns, what blocks
  approval): **not addressed.** One knock-on to note is that clause 6 blocks approval on an
  uncorrected *send-back*. If Send Back no longer has a target, that block has nothing to hold on
  to. This is not decided here.

## Why

Corrina gave no reasoning in the reply. What the record shows:

- **Flags reaching payroll was already on record before the 2026-09-28 design.**
  - [meetings/transcripts/2026-05-28-mobile-app-payroll.md](../meetings/transcripts/2026-05-28-mobile-app-payroll.md)
    line 276, Melissa McNutt 46:05: the crew marks 200 ft of boom where sales set 120 in the job's
    crane configuration, *"that's when it flags. payroll to confirm with the salesperson, the
    operator, if something changed on site."*
  - [meetings/transcripts/2026-06-23-mobile-app-payroll-adp-and-draft-workflows.md](../meetings/transcripts/2026-06-23-mobile-app-payroll-adp-and-draft-workflows.md)
    line 243, Joe Schacatano 33:15: employee time 9½ h against ticket time 8, *"It flags it for
    her to then dive in"*; line 261, Ehtesham Anwar 35:20: *"Otherwise, it's going to flag for
    Corrina to verify."*
  - [meetings/transcripts/2026-08-04-payroll-process.md](../meetings/transcripts/2026-08-04-payroll-process.md)
    line 116, Corrina Bustos 23:33: *"in a perfect role [sic, likely 'world'], it would be crane
    super, but I'm trying to think of realistically if there can at least be an option where the
    payroll, whoever's processing it, does have that option to override as well."* Ehtesham
    Anwar 23:44 (line 117) agreed to add an edit option for payroll.
- **Routing to the crane superintendent was a CodingCops design proposal.**
  - 2026-08-04 line 77, Ehtesham Anwar 14:56: *"The main flow works on the crane super side … all
    of these flag entities are also showing on his dashboard … He needs to approve them."* Line
    106, 20:52: *"either worker or supervisor is going to adjust. If you want to adjust, we can add
    the adjustment option here, but it's going to be your call."* Line 184, 34:11: the crane
    super sees the same screen and may approve, override, or send back to the worker.
  - [meetings/transcripts/2026-08-13-payroll-process.md](../meetings/transcripts/2026-08-13-payroll-process.md)
    lines 394–396, Ehtesham Anwar 58:51 / 59:28: a changed boom configuration is flagged *"so that
    Corrina can review and maybe Crane Super can review as well … if she needs a review from crane
    super and explicit approval, she send it back … otherwise she can approve and move on."*
  - The unmigrated Confluence `Payroll management` page (US-03 AC 3–7,
    [sync/.conflict/2026-08-24-bootstrap/payroll-management.md](../sync/.conflict/2026-08-24-bootstrap/payroll-management.md)
    lines 112–118) writes the same proposal up as a story: send back to *Crane Superintendent* or
    *Worker*, and the superintendent may *Approve* or *Override*. It is unverified.
- **Reading.** Corrina half-accepted crane-superintendent routing on 2026-08-04 (*"in a perfect
  [world]"*) while asking for payroll to be able to override. She has now rejected it. Two things
  are new: the crane superintendent is excluded outright, and a **"payroll admin"** role is named
  next to the payroll manager.

## What this does NOT decide

Each item is open in the payroll/gaps.md entry linked at the top.

1. **Who corrects a flagged entry now.** Does payroll edit it directly on the payroll screen, or
   does payroll see the flag and contact the crew? Send Back as built has no valid target.
2. **Who "payroll admin" is.** Which person or people, and whether it is a new ERP role or
   permission. The seeded roles include *Payroll Manager* (`ROLE-ACCOUNTS-PM`,
   `apps/api/src/utility/seed-data.ts`) and no *Payroll Admin*. Also open: do both roles receive
   every flag, and can either of them act on one?
3. **Whether Send Back survives, and to whom.** The worker on mobile was also floated
   (Confluence US-03 AC 3, 10; 2026-08-04 20:24 and 34:11).
4. **Whether "all flags" covers more than payroll review flags.** The 09-29 message also
   described ticket progress *Flagged* on incident, deficiency and customer unavailable. Those
   are field-ops ticket states. Whether her "all flags" reaches them is not clear from the reply.
5. **The other questions from the 2026-09-29 message**, all unanswered:
   - the whole-crew effect of edits to shared Start Work / End Job times;
   - which times are editable;
   - rounding and the 8-hour rest gap: are rounded or actual times used (see
     [2026-08-24-payroll-time-rounding-method.md](2026-08-24-payroll-time-rounding-method.md),
     [payroll/rules/PAY-045-rest-period-premium.md](../payroll/rules/PAY-045-rest-period-premium.md));
   - other auto-flag sources, and a manual flag;
   - whether the recipient can approve or override;
   - a reminder. Corrina herself asked for an auto-reminder on 2026-08-04, line 78, 15:50:
     *"Is there a way we can set up like an auto reminder if they haven't replied?"*
6. **What the boom flag compares against.** The 2026-09-28 rule (clause 1) compares the crew's
   bracket with the **crane's physical min–max boom length**. Melissa McNutt (2026-05-28, 46:05)
   described the flag as the crew's boom length against the **job's crane configuration set by
   sales**. These are different comparisons. Not resolved here.

## Build impact

**The overruled routing is already on `main`, not only on a branch.**

- Branch `feat/payroll-flagged-entries-send-back` (developer devmohsinakram) merged as **PR #690**
  (`ab7e5f43e`). Its seed branch `chore/seed-flagged-entries-send-back` merged as **PR #691**
  (`d775a927a`).
- What is live:
  - the `crane-supervisor` role permission;
  - the supervisor picker on Send Back;
  - the *Returned Entries* page (`apps/web/src/app/(protected)/payroll-corrections`);
  - `apps/api/src/usecase/payroll-send-backs/`;
  - the supervisor notification.
- All of it implements clauses 3–5, which this decision overrules. What replaces it waits on
  open items 1–3. This note does not say to remove it.

## Effect on the vault

Done in the same pass as this note:

- **[decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md](2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md)**:
  - **done:** `provenance_note:` added, naming the overruled clauses and pointing here;
  - **done:** `conflicts_with:` set to this note, because clause 4's correction flow is left
    standing without an actor;
  - `status:` left at `reference`, because clauses 1, 2 and 6 still stand. Its body is
    unchanged.
- **[payroll/gaps.md → *Confluence payroll user stories*](../payroll/gaps.md#confluence-payroll-user-stories--first-payroll-pages-in-confluence-unmigrated)**:
  - **done:** its `Status` line now says clause 3's provisional answer is overruled by this note.
  - The entry stays open.
- **[payroll/gaps.md → *Flagged entries go to payroll, not the crane superintendent*](../payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives)**:
  **done**, new entry holding open items 1–6.
- **[field-ops/gaps.md](../field-ops/gaps.md)**: **done**, a one-line pointer to that entry.

Not done:

- **Index bodies are outside the recording agent's write scope.**
  [payroll/INDEX.md](../payroll/INDEX.md) → *Decisions that bind this module* needs a line for
  this note, and for the two 2026-09-28 payroll notes, which are also missing.
- **The 2026-09-28 note's body has no banner.** Precedent for one is
  [2026-08-20-post-save-navigation-convention.md](2026-08-20-post-save-navigation-convention.md).
  A human may add it.

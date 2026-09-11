---
title: Progress Tracking ticket status rules — decision
source: decision/Syed Haris
decided: 2026-09-11
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — developer/owner directing SCRUM-PROGRESS; approved the
  preview below in a working session on 2026-09-11 (verbatim in
  `.ai/aidlc/SCRUM-PROGRESS/intent.md` → Session decisions D3). He is **not** the client-side
  product owner. No owner is declared for projects-jobs; the one the vault names is **Lisette
  Anzaldo** (Dispatch Manager, `admin/engagement-directory-and-org-charts.md`), owner on 29 of 34
  `projects-jobs/gaps.md` entries. **Lisette Anzaldo should ratify it.** `status: reference` for
  that reason. Same basis as the 2026-09-10 SCRUM-PENDING notes.
status: reference
conflicts_with: []
resolves: [SCRUM-PROGRESS/intent.md#d3--status-rules]
jira: []
tags: [module/projects-jobs, module/dispatch, kind/decision, ticket-workflow, time-tracking, scheduling, inspections, safety]
---

# Ticket status rules for Progress Tracking

Answers D3 of `.ai/aidlc/SCRUM-PROGRESS/intent.md` → *Session decisions*.

## Decision

> **Q:** Approve these ticket status rules? The design uses them, but no source defines them.
> **Chosen:** *Approve as proposed (Recommended)* — "All the rules in the preview. Incomplete ships
> last, once the tenant-timezone branch reaches main, because the check has to run in the
> tenant's zone."

The preview shown with it, verbatim:

```
Not opened   PENDING/SENT and nothing captured yet
In progress  something captured, not yet submitted
Completed    Review & Complete submitted (COMPLETE)
Flagged      an incident filed, OR any checklist item
             marked Deficiency, OR customer unavailable
             at the final signature
Rejected     shown with its reason; CANCELLED (superseded
             by a reassignment) is hidden
Incomplete   not COMPLETE once the shift's estimated end
             has passed, in the tenant timezone (shift 2
             uses the second-shift end). No end time on
             the schedule → end of that business day
Progress %   steps done ÷ steps for that role (9 or 14)
Current step the existing 'Currently: … / Completed: …'
             phase rule (2026-09-10 decision)
```

**Not chosen:** *Approve, never Incomplete w/o end* ("a schedule with no estimated end time never
makes the ticket Incomplete") · *Raw status only* ("No derived Flagged or Incomplete…").

## Why

- **No source defines these states.** The design uses them (`ptVis`, `ptTicketStatus`,
  `ptStatusBadge` — intent §10–§11); nothing in the vault or on a ticket does.
- **Current step is reused, not restated:** it is
  `decisions/2026-09-10-current-phase-is-the-latest-open-capture-else-the-last-closed.md`.
- **Incomplete runs in the tenant's zone and ships last.** The zone rule is
  `decisions/2026-09-09-business-timezone-is-a-tenant-property.md` and
  `decisions/2026-09-09-business-day-starts-at-midnight-local.md` (both `reference`). Its code is
  not on `main` as of 2026-09-11 — it is on `origin/fix/timezone-business-day`, 23 commits
  ahead — so *Incomplete* waits for it. The other rules do not.

## What is weak about this attribution

- **The decider of record is Syed Haris**, named and dated; binding on the build. These are the
  states a dispatcher reads. **Lisette Anzaldo should ratify it.**
- **This invents rather than records**, as the question itself said. The vault's one use of the
  word is `brs.md` BRS-TVL-003 *Incomplete Ticket Persistence* ("Tickets remain Draft/Incomplete",
  unverified). There it means *unsubmitted*, with no time condition. Here it means *not COMPLETE
  after the scheduled end*. The two meanings differ.

## What this does NOT settle

- **Precedence** of Flagged against Incomplete and Completed. The design's badge order
  (`ptStatusBadge`, intent §11) was not in the preview and was not approved.
- **A Completed ticket with an incident or a deficiency** — does it still read Flagged?
- **Per-step states** — how done / current / flagged / not reached are derived.
- **The null-end-time clause covers this screen only.** "No end time on the schedule → end of that
  business day" governs *Incomplete* on Progress Tracking. It does **not** answer the null case
  still open for the payroll overlay —
  `decisions/2026-09-10-unstarted-tickets-date-by-schedule-interval-and-go-overdue-at-estimated-end.md`
  → *The half that stays open* (also SCRUM-PENDING `spec.md` §12). That stays with its owner. If it
  is answered differently, the two screens will disagree on the same ticket. That risk is known;
  nothing has decided it.
- **Current step vs. step *n* of *N*.** The phase rule names a time-capture window, not a timeline
  step. Steps with no time capture (signatures, checklists) never read as current. It also carries
  that note's open items: display names, ties, staleness.
- **A shift-2 end past midnight**, combined with the interval's own date. The unstarted note leaves
  the same risk open.

## Effect on the vault

- **No vault body edited, no frontmatter flipped.** No candidate documents existed. The 2026-09-09
  and 2026-09-10 notes are cited, not amended.
- **The two 2026-09-10 notes cited here are on overlay branch
  `feat/payroll-pending-ticket-visibility`** (`5a535fc`), not on overlay `main` or this ticket's
  branch as of 2026-09-11. Their paths resolve once that branch merges.
- The open items above belong in `.ai/aidlc/SCRUM-PROGRESS/spec.md` §12 (intent §12 hands them to
  the elaborator). This pass did not write them.
- **`projects-jobs/INDEX.md` → *Decisions that bind this module* gained a line for this note**, on
  explicit instruction and outside `tcg-scrum`'s normal write scope.

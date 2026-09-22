---
title: The DAS job card shows crew ticket status beside the stage badge, not instead of it — decision
source: decision/Syed Haris
decided: 2026-09-22
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — developer/owner directing the UAT remediation milestone;
  chose this scope in a working session on 2026-09-22 while planning TCG-70, and reaffirmed the
  presentation after being shown that the DAS badge renders the yard/dispatcher stage machine.
  He is **not** the client-side product owner. The vault's named DAS board owner is
  **Lisette Anzaldo** (Dispatch Manager,
  `decisions/2026-09-10-das-map-shows-all-nine-job-stages.md`,
  `admin/engagement-directory-and-org-charts.md`). **Lisette Anzaldo should ratify it.**
  `status: reference` for that reason — same basis as the 2026-09-11 Progress Tracking notes.
status: reference
conflicts_with: []
resolves: []
jira: [TCG-70, TCG-184]
tags: [module/dispatch, module/projects-jobs, kind/decision, das, job-status, ticket-workflow]
---

# Crew ticket status is shown beside the DAS stage badge

## Decision

**The DAS job card shows two indicators side by side: the existing `SubJob.dasStage` badge, and
a new chip carrying the crew's live `JobTicket.status` roll-up.** The stage badge is unchanged
and no code path writes `dasStage` from a ticket event.

```
JOB-0000  [Ticket Sent]  [In Progress 2/3]
          stage badge     crew chip (new)
```

This is TCG-70's own AC8 — the subset its §6 preamble names as satisfying the ask's literal
complaint without touching the stage machine. **AC1–AC7 and AC9–AC13 are deferred**, to
[`2026-09-22-das-stage-is-derived-forward-only-from-the-ticket-lifecycle.md`](2026-09-22-das-stage-is-derived-forward-only-from-the-ticket-lifecycle.md)
and carried by **TCG-184**.

## What asked for it

UAT session 4 (14 Sep 2026) item #48, verbatim:

> Once we have started the ticket, it will be **In Progress**, but in some places the status is
> shown as **Ticket Sent**. This should be changed. Example: **Ticket Sent** near JOB-0000 on the
> DAS page.

Tracked as TCG-70, `uat/register-2026-09-18.md`:246 and the Confluence *UAT Final Doc* row
`id-163`. **A UAT row is an ask, not adjudicated intent** (`register-2026-09-18.md`:22-26) — which
is precisely why the stage machine is not moved on the strength of it.

## Why "in some places" was exact

Two state machines, one bridge:

- **`SubJob.dasStage`** (`schema.prisma`:3693, nine values at `:1704-1714`) is what the card badge
  renders. Every value past `TICKET_SENT` is written by a **yard** action — `LOADOUT` by *Mark
  Available*, `EMPLOYEE_LEFT_YARD` by *Complete Loadout*, `WORK_IN_PROGRESS` and `COMPLETED` by
  the offload endpoints. **No ticket event writes it anywhere.**
- **`JobTicket.status`** (`schema.prisma`:4536) already flips to `IN_PROGRESS` on the crew's first
  milestone (`job-tickets.service.ts` `recordTicketStep`), and the per-slot pill
  (`job-allocation-sections.tsx`) already renders the words "In Progress" — but only after the
  dispatcher expands the row.

So the crew was invisible on the collapsed card by construction, and the fix is to surface the
fact that already existed rather than to invent a new one.

## Why the stage was not advanced

Three regressions, two of them silent, all verified against `origin/main` at `cd90f87bc`:

1. **It unlocks a dispatched job.** `job-list-item-expanded.tsx`:146-148 —
   `isLocked = isCancelled || isTicketSent`. Leaving `TICKET_SENT` makes a job whose crew has
   started editable again.
2. **It deletes the working indicator.** `job-list-item-expanded.tsx`:153 gates
   `useTicketStatuses` on the stage being **exactly** `TICKET_SENT`. Advancing it removes the slot
   pills — including the "In Progress" one the asker wanted.
3. **It hard-locks schedule edits.** `jobs.service.ts`:63-71 — `WORK_IN_PROGRESS` is in
   `HARD_LOCKED_SUB_JOB_STAGES` and `TICKET_SENT` is not, so a crew punching in would strip
   dispatch's time-only edit window.

And the governing point: **nothing in the vault says a field event may write `dasStage`**, while
the one `status: verified` ruling on the subject leans the other way — see the companion note.

## The case against

The card still contains the words "Ticket Sent" while a crew is working, which is literally what
#48 objected to. Two options were considered and declined: replacing the badge with the crew
status while a ticket is live, and doing that on the DAS map badge too. Both were rejected as
hiding a fact the dispatcher uses. **If Lisette reads the two-chip card as not answering the ask,
the replace variant is the next step and needs no backend change** — the roll-up is already on the
`/das/sub-jobs` response.

## What this does not settle

- **Whether `dasStage` is derived or dispatcher-owned.** Untouched here. Companion note, and the
  new open row in [`../dispatch/gaps.md`](../dispatch/gaps.md).
- **The `WORK_IN_PROGRESS` label.** `JOB_STAGE_LABELS` still reads "Work In progress" for a stage
  that means *partially offloaded after the crew returned*. Renaming it while that is its meaning
  would make the board say "In Progress" for a crane coming back. The relabel belongs with the
  derivation.
- **The DAS map badge** still shows the stage alone. It imports the board's own `JOB_STAGE_LABELS`
  (`das-map-job-stage-badge.tsx`:7), so the two agree on the stage; they now differ on whether the
  crew is shown at all. Known, and left to the ratification.
- **Aggregate precedence for a roll-up.** The client helper follows the per-ticket order in
  `2026-09-11-progress-tracking-status-precedence-step-states-and-boom-hours.md` (Q2), but that
  note ruled on one ticket and never addressed N. The added rule — `Completed` requires every
  ticket complete, `Rejected` and `In Progress` need only one — is this note's, not that one's.
- **Eventual consistency.** Mobile punch-in is fire-and-forget (`use-ticket-shift.ts`:38-69 swallows
  the failure and relies on a later resend), so the chip can lag until the phone has signal. Not a
  defect introduced here; worth knowing before someone reports the chip as missing.

---
title: Crew ticket shape — the ticket keys on the primary employee's allocation, per-employee labor lives in `ticket_employees`, COMPLETE pairs stay as two rows, the Operator sees step status only — decision
source: decision/engineering owner (Syed Haris, CodingCops), recorded 2026-09-14
decided: 2026-09-14
decided_by: >-
  Syed Haris (CodingCops, git identity `hariscops`) — requester and engineering owner of
  SCRUM-CREW-TICKET — in-session on 2026-09-14, answering the four questions `tcg-elaborator`
  raised in `SCRUM-CREW-TICKET/spec.md` §12. Q1, Q2 and Q4 are engineering-shape choices the
  product decision (`decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md`)
  explicitly left to engineering; they are his to make. Q3 is a product default he chose
  because no written source says more — the richer Operator view is still a client question
  (see *What this does not settle*).
status: verified
conflicts_with: []
resolves:
  - SCRUM-CREW-TICKET/spec.md#q1--per-employee-time--labor-keying
  - SCRUM-CREW-TICKET/spec.md#q2--complete-linked-pair-migration-treatment
  - SCRUM-CREW-TICKET/spec.md#q3--operator-visibility-of-signatureschecklistscomments-on-the-shared-ticket
  - SCRUM-CREW-TICKET/spec.md#q4--whether-a-das-set-is-exactly-one-asset-group
related_decisions:
  - 2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md
jira: []
tags: [module/field-ops, module/dispatch, module/payroll, kind/decision, ticket-workflow, labor-record, oiler, operator, schema, migration]
---

# Crew ticket shape: primary employee's allocation is the key; `ticket_employees` holds per-employee labor

This note gives the morning's product decision
([`2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md`](2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md)
— one ticket per asset group per day, Oiler primary, Operator on the same ticket with a separate
labor record) its engineering shape. The product decision left the data model to engineering;
this is that model. The four questions are answered in the order they were built on, not the
order the spec numbered them.

## Decision

### Q4 — What identifies a ticket: the primary employee's allocation

1. **`JobTicket.allocationId` stays the ticket's anchor. No asset-group entity is introduced.**
2. **Rule:** within one `(subJobId, setResourceId, shiftNumber)`, if a personnel allocation with
   an **Oiler** seat exists, **that allocation's ticket is the crew ticket**, and the Operator's
   allocation in the same set is **absorbed as a second ticket-employee** on it — **no ticket is
   minted for the Operator's allocation.**
3. **Every other personnel allocation gets its own ticket, exactly as today:** an Operator in a
   set with no Oiler seat, a Third Man, every support/counterweight-load driver.
4. **The partial unique index "at most one non-CANCELLED ticket per allocation"
   (`uq_job_tickets_active_allocation`,
   `apps/api/prisma/migrations/20260729140000_job_ticket_allocation_history/migration.sql`)
   stays.** It is still true: the Operator's allocation simply has no active ticket.

So the elaborator's literal question — *is a DAS set exactly one asset group?* — is answered
**no, and it does not need to be.** The ticket is keyed by the allocation of whoever fills it,
which reproduces the sheet's per-asset-group rule without modelling groups.

### Q1 — Labor model: one labor row per employee on the ticket, `ticket_employees`

1. **New table `ticket_employees`** (Prisma model per the existing `Ticket<Noun>` convention —
   `TicketEmployee` — name to be confirmed by the executor against team convention, as REQ-13
   already notes): UUID PK, `tenantCompanyId`, `jobTicketId`, `employeeId`, `isPrimary`, **plus
   the per-employee Labor & Unit fields that today sit on `JobTicket`**: `craftModifierBracket`,
   `craftModifierId`, `laborComments`, `laborCapturedByUserId`. Those fields move off
   `JobTicket`.
2. **Exactly one `isPrimary = true` per ticket**, enforced by a partial unique index on
   `(jobTicketId) WHERE is_primary`.
3. **Every ticket gets the same shape.** A single-employee ticket (Operator-alone, Third Man,
   load driver) has one `ticket_employees` row with `isPrimary = true`. There is no
   "ticket with employees" versus "ticket without" branch.
4. **`TicketTimeEntry` stays per ticket, unchanged.** Milestones (Leave Yard, Arrive, Left Job
   Site, Arrive Yard, lunch) are crew-wide because the crew travels together — Brian Petros
   2026-05-14 **10:12**: *"since they're on the same piece of equipment, they will arrive at the
   same time. So the same ticket can be used"*
   ([`../meetings/transcripts/2026-05-14-loading-scheduling-pre-ticketing.md`](../meetings/transcripts/2026-05-14-loading-scheduling-pre-ticketing.md):88).
5. **Payroll prices one row per ticket-employee instead of one per ticket.** `PayrollJobDay`'s
   unique key `@@unique([runId, jobTicketId])` (`uq_payroll_job_days_run_ticket`,
   `apps/api/prisma/schema.prisma`:5194) **must widen to include the employee** — flagged for
   `tcg-prisma-guardian`. `payroll.service.ts` `buildJobDay` (reads `ticket.employee`) becomes
   per ticket-employee.
6. **Alternative rejected:** a nullable `employeeId` on `TicketTimeEntry`. It answers "whose
   window" but the Labor & Unit fields would still need a per-employee home, so the new table is
   needed either way; adding both is two models for one fact.
7. **Not decided here: per-employee start/end time overrides** on the shared ticket. Build them
   **only if the existing labor-hours code already supports the concept**; do not introduce
   them for this ticket.

### Q2 — Migration: collapse live pairs only; COMPLETE pairs stay as two rows

1. The data migration collapses **only PENDING / SENT / IN_PROGRESS** linked pairs (an
   Operator ticket with `primaryTicketId` set) into the Oiler's ticket: create the Operator's
   `ticket_employees` row on the Oiler's ticket, **carrying that Operator ticket's own Labor &
   Unit fields**, then **retire the Operator's ticket under the existing cancel semantics**
   (status `CANCELLED`, so the partial unique index is satisfied and history is kept, exactly as
   a reassignment does today). Then drop `primaryTicketId`.
2. **COMPLETE pairs keep both rows.** Each COMPLETE ticket is backfilled with its own single
   `ticket_employees` row (`isPrimary = true`), like every other ticket. **Already-priced
   `PayrollJobDay` runs are untouched** — no row moves, no `(runId, jobTicketId)` collides.
3. This matches the scope of the superseded 2026-09-12 backfill
   (`apps/api/prisma/migrations/20260912120000_add_job_ticket_primary_ticket/migration.sql`,
   `WHERE status IN ('PENDING', 'SENT', 'IN_PROGRESS')`) — now a decision, not a workaround.

### Q3 — Operator's view: step status only, as today (product default)

1. The Operator's mobile Jobs list / Home shows the crew ticket as **"On <Oiler>'s ticket"**
   with the ticket's **progress / step status only** — no signatures, no checklists, no
   comments, no punch-in, no accept.
2. The crew-copy banner + *View ticket* CTA shape from PR #561
   (`apps/mobile/components/field/crew-ticket-banner.tsx`, merged 2026-09-12) is **replaced**
   by this, not kept.
3. **This is a default, not a product answer.** The requester chose it because no written
   source says more (the morning note lists it under *deliberately left open*; FR-TCG-FOP-001
   open question 11 covers the same ground). Whether the Operator should see more stays open
   for the client — recorded as a new, non-blocking §12 entry (see *What this does not
   settle*).

## Why

- **Q4 — allocation, not set, because a DAS set is wider than the sheet's asset group.**
  `JobResourceAllocation.setResourceId` (`apps/api/prisma/schema.prisma`:3789) points at the
  **top-level crane `JobResource`**, whose children include the support loads *and their
  people*. The sheet's "asset group" (morning note, decision point 1: *"the 'main' mobile crane
  (with primary tractor/trailor) or additional tractor/trailer combo"*) is narrower — each
  support load is its own group with its own ticket (decision point 4). Keying a ticket by set
  would therefore put support-load drivers onto the crane ticket, which the sheet forbids.
  Keying by the filler's allocation reproduces the sheet row-for-row: Oiler's allocation → the
  crane ticket (Operator absorbed); each load driver's allocation → that load's ticket. The
  set is still used for one thing — finding the Operator allocation to absorb — which is the
  same `(subJobId, setResourceId, shiftNumber)` + seat-name lookup `linkCrewTickets` already
  does (`apps/api/src/usecase/job-tickets/job-tickets.service.ts`:960, `seatOf` against
  `OILER_TYPE_NAME` / `OPERATOR_TYPE_NAME`).
  **Alternative rejected: a new asset-group key.** To know which tractor/trailer belongs to
  which load, the loadout / DAS model would have to carry grouping it does not carry today —
  a model change with no product requirement behind it.
- **Q1 — a per-employee labor row, because "separate labor record" is a product fact.** The
  morning note's decision point 2 (*"a separate labor record that the Oiler enters"*, Brian
  Petros 2026-05-21 8:59, 9:27) and FCC's legacy shape (`FMS_JOB_TICKET` +
  `FMS_JOB_TICKET_EMP_UNIT` with a `PrimaryEmp` bit) both put the per-employee data in a child
  row of the ticket, not on the ticket. Moving the four Labor & Unit fields there makes the
  Oiler's "which employee is this entry for" selection a row choice instead of a cross-ticket
  write (`resolveTargetTicket`, `ticket-labor-entries.service.ts`:584, currently resolves to a
  *different ticket* — the shape being retired). Milestones stay on the ticket because the
  10:12 statement is the only thing on the record about crew timing, and it says the crew's
  times are shared.
- **Q2 — leave COMPLETE pairs, because payroll has already priced them.** A COMPLETE Operator
  ticket has a `PayrollJobDay` row keyed by its own `jobTicketId`; folding it into the Oiler's
  ticket would either collide with the Oiler's priced row or orphan the Operator's. Historical
  shape is a display concern; priced payroll is a money concern. Live pairs have no priced row,
  so collapsing them is free.
- **Q3 — status only, because that is the only shape any source describes.** Today's copy
  shows step status only (2026-09-12 gap update); the morning note declines to decide more;
  no TCG person has asked for more in so many words. Building richer visibility now would be
  inventing a requirement. The default is the status quo, and the question goes to the client.

## What this does not settle — deliberately left open

- **Whether the Operator should see more than step status** on the shared ticket
  (signatures, checklists, comments, read-only). Owner: Wes Staley + client — the remainder of
  FR-TCG-FOP-001 open question 11
  ([`../field-ops/frd-new-format-draft/08-open-questions.md`](../field-ops/frd-new-format-draft/08-open-questions.md):27).
  Non-blocking: the build ships the status-only default. Recorded as the new open entry
  `SCRUM-CREW-TICKET/spec.md#q5--operator-richer-view-of-the-shared-ticket-signatures--checklists--comments`.
- **Per-employee start/end overrides** on the shared ticket — see Q1 point 7.
- **The final Prisma model name** for `ticket_employees` (`TicketEmployee` is the convention
  suggestion, REQ-13).
- **Sets with more than two personnel seats, or a set with two Oilers** — the rule in Q4 says
  "if an Oiler allocation exists"; how two Oiler allocations in one set would resolve is not
  addressed because no set produces that today. If DAS ever does, it is a new question.
- Everything the morning note left open (3rd-man signatures, dispatcher two-in-a-truck option,
  fill-in crew, vendor crews) stays open.

## Effect on the vault

All edits below were applied in this pass by `tcg-scrum`.

- **`SCRUM-CREW-TICKET/spec.md` §12** — Q1, Q2, Q3, Q4 each flipped from `- **Status:** open`
  to `- **Status:** resolved 2026-09-14 — <one-line answer> — see decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md`.
  The rest of each entry left intact as the record of what was in question. **Done.**
- **`SCRUM-CREW-TICKET/spec.md` §12** — new entry **Q5 — Operator richer view of the shared
  ticket (signatures / checklists / comments)**, `Status: open`, non-blocking, owner Wes Staley
  + client. **Done.**
- **Requirement bodies (REQ-01/02/04/06/09/10/11/13/14/15/16/17) not edited** — not this
  role's to write; `tcg-elaborator` folds this decision into the REQ text next.
- **No vault file frontmatter changed.** This decision names no vault document as winner or
  loser: it resolves ticket-scoped engineering questions, and the one vault document it touches
  in substance (`field-ops/frd-new-format-draft/08-open-questions.md` row 11) already carries a
  `provenance_note:` from the morning note and its row stays *Open* for the residual above.
- **Morning note not edited** — it remains the product decision; this note is the engineering
  shape under it, linked via `related_decisions:`.
- **Jira** — none. `jira: []`; SCRUM-CREW-TICKET is a local ticket folder with no Jira key yet.

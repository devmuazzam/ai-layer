---
title: An Operator whose own ticket already started stays independent of the Oiler; no crew-total Payable figure — decision
source: requester answer, recorded 2026-09-21
decided: 2026-09-21
decided_by: >-
  devmohsinakram (CodingCops) — requester, in-session on 2026-09-21, answering three questions
  `tcg-elaborator` raised in `SCRUM-CREW-TICKET/spec.md` §12 (Q7, Q8, Q9) after `tcg-executor`
  surfaced them while building U1–U5. A requester answer in-session, not a client (TCG) statement
  — recorded here per CLAUDE.md's memory table because a named human decided it; escalate to a
  client-side source if this is later contested.
status: verified
conflicts_with: []
resolves:
  - SCRUM-CREW-TICKET/spec.md#q7--an-operator-already-has-a-started-or-finished-ticket-of-their-own-when-an-oiler-joins-their-set
  - SCRUM-CREW-TICKET/spec.md#q8--can-the-oiler-still-enter-labor--unit-for-an-operator-who-kept-a-ticket-of-their-own-q7
  - SCRUM-CREW-TICKET/spec.md#q9--which-priced-row-is-the-ticket-level-payable-hours-on-progress-tracking-once-a-ticket-has-two
related_decisions:
  - 2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md
jira: [TCG-25]
tags: [module/field-ops, module/dispatch, module/payroll, kind/decision, ticket-workflow, labor-record, oiler, operator]
---

# Not-absorbed Operator stays independent; Progress and payroll are per person, never a crew total

Three follow-on questions the executor hit building SCRUM-CREW-TICKET's U1–U5, on top of the
2026-09-14 shape decision. All three confirm the conservative cut the units had already shipped
— no code changed as a result of this note; it exists so the answer is recorded somewhere other
than `spec.md`.

## Decision

### Q7 — An Operator already IN_PROGRESS/COMPLETE on their own ticket when the Oiler is allocated

An Operator whose own ticket has already started or finished when an Oiler joins the set keeps
managing that ticket independently of the Oiler. It is not folded into the Oiler's ticket, and
stays that Operator's own primary. Only a PENDING/SENT Operator ticket is absorbed.

Matches the shipped cut: `planCrewTickets` / `apps/api/src/usecase/job-tickets/crew-roster.ts`
does not absorb IN_PROGRESS or COMPLETE tickets.

### Q8 — Who enters Labor & Unit for a not-absorbed Operator (Q7)

The Oiler fills the tickets assigned to them; the Operator fills theirs — each on their own
ticket. An Operator who kept their own ticket under Q7 fills their own Labor & Unit; the Oiler
has no cross-ticket write for them.

Matches the shipped cut: U2's `resolveTargetTicket` targets only the caller's own ticket roster;
there is no cross-ticket write path for a not-absorbed Operator.

### Q9 — The ticket-level "Payable" figure once a ticket prices two people

No crew total. Progress and payroll are managed per individual, not per ticket.

Matches the shipped cut: `ProgressTicketEmployee.payableHours` is each person's own payroll
figure, and the web crew list shows it per person. The ticket-level *Payable* field itself keeps
showing the primary's row — this decision did not ask for that field removed, only that no total
be introduced.

## What this does not settle

- Whether an IN_PROGRESS Operator ticket should ever be foldable by a later, explicit dispatcher
  action (as opposed to the automatic fold Q7 covers) — not asked, not answered.
- The ticket-level `Payable` field on Progress Tracking still reads the primary's row rather than
  being replaced by the per-person list outright; nobody asked for that field's removal, so it
  stands as built.

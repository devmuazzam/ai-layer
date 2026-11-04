---
title: "Shared Oiler + Operator ticket: once a crewmate's week is approved, the other entries lose Adjust Entries and Send Back (interim guard); a send-back on the ticket hides Approve Week for the whole crew; a Payroll correction is to change only the corrected person (Corrina's 09-29 clause 3), built in a follow-up: developer direction"
source: decision/Ali Riaz, developer direction in a Claude Code session, 2026-10-28 (two structured questions, the same session; the first answered in his own words)
decided: 2026-10-28
decided_by: >-
  Ali Riaz (CodingCops developer; commits under the shared devmohsinakram git profile, as in the
  2026-10-06 payroll notes). There were two structured questions. On the first he chose none of the
  options and answered in his own words, quoted verbatim below. The four-point reading of those
  words is the recording session's interpretation, so it must be checked against the quote. On the
  second, asked after the recording session flagged a conflict with Corrina's verified 09-29 clause
  3, he chose to follow Corrina. That withdraws point 4. In both questions, the "(Recommended)" tag
  was added by the session that asked. These are developer directions, not TCG product decisions.
  They are therefore `status: reference`, on the same basis as
  2026-10-27-adp-re-export-of-a-sent-week-developer-direction.md. TCG payroll (Corrina Bustos, Brian
  Petros) was not consulted. They bind implementation now, and TCG can overrule them. Recorded by
  tcg-scrum 2026-10-28.
status: reference
supersedes: []
supersedes_partial:
  - "decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md (the 'C6 refined' bullet: 'shared ticket times (yard, site and work) move for both workers when either edits them', as to a Payroll correction only. The same developer now sides with Corrina's verified 09-29 clause 3. A worker's own mobile edit of the shared ticket after Send Back (C3) is not addressed here)"
conflicts_with: []
provenance_note: >-
  First written 2026-10-28 with `conflicts_with` naming the verified
  2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md,
  because point 4 contradicted its clause 3. The conflict was put to Ali Riaz the same day, and he
  chose Corrina's rule. Point 4 is withdrawn, and `conflicts_with` was emptied in the amendment.
  The 09-29 note was not edited and stays `verified`.
related:
  - decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md
  - decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md
  - decisions/2026-10-06-returned-entries-correction-flow-and-send-back.md
  - decisions/2026-10-28-auto-recalc-reprices-pending-weeks-keeps-approved-weeks-frozen-developer-direction.md
  - ../../aidlc/PAYROLL-FLAGS/spec-u14-u21.md
  - ../../aidlc/PAYROLL-FLAGS/units-u14-u21.md
  - ../payroll/gaps.md#a-labor-entry-edit-can-reprice-an-approved-week--and-the-erp-has-no-path-for-it
  - ../payroll/gaps.md#send-back-of-a-multi-crew-ticket--does-sending-a-ticket-back-also-return-it-for-the-other-crew-members-on-that-ticket
tags: [module/payroll, kind/decision, api, web, send-back, approval, payroll-review]
---

## Decision

### First question: an approved crewmate blocks the fix

**The question, verbatim.** Structured question, Claude Code session, 2026-10-28:

> "When an approved oiler week blocks fixing the operator's shared ticket times, the refusal says
> "Ask Payroll to reopen that week first", but there is no way to reopen just one week. The only
> option is a full-period recalculate that reopens every approved week. How should Payroll reopen
> one week?"

**Options offered:**

- "Add 'Reopen week' on one week (Recommended)"
- "Only fix the message"
- "Record as a question for TCG"

**He chose none of them.** His answer, verbatim, typos included:

> "disable adjust entery and send back button and if anything is sended back by anyone then approve
> week will kept hidden
>
> one we approve week of oiler on operator send back and adjust enty button will be removed
> if any of them have sended back enty both of them will have approved button hidden he should not
> be able to approve week if any ticket is sended back and cot completed
>
> also if i send oiler ticket back opratic ticket button of send back will be sended back and on
> oiler ticket adjustment opratover ticket will be auto adjusted on recalculate and same adjustment
> will visible for both oiler and oprator"

**The reading recorded.** This is the recording session's reading of his words, not his own
restatement. It applies to a crew ticket shared by an Oiler and an Operator:

1. **An approved week locks the other entries.** Once any crew member's week on the ticket is
   approved, the other members' entries for that ticket show neither "Adjust Entries" nor "Send
   Back To Payroll Admin". A note naming who is approved replaces them.
2. **A send-back hides Approve Week for the whole crew.** While any entry of the ticket is sent back
   and not resolved, "Approve Week" is hidden for every crew member on it.
3. **A send-back from the Oiler's entry returns the Operator's too.** The Operator's entry shows as
   returned as well.
4. ~~**An Oiler-side fix to the shared times reaches the Operator.** If a correction on the
   Oiler's entry moves the shared ticket times, the Operator is repriced on the next recalculation,
   and the correction shows on the Operator's entry as well.~~ **Withdrawn the same day.** See the
   second question.

**Points 1 to 3 stand.** They are the interim UI behaviour, until the follow-up below ships.

### Second question: which way corrections work

**The question, verbatim.** Structured question, same session:

> "Corrina's verified 2026-09-29 rule says correcting a shared time changes only that employee's
> hours, not the crew's. Today a fix edits the ticket's shared times (moving the oiler and operator
> together), and your point 4 keeps that. Which way should corrections work?"

**Chosen, verbatim:**

> **Follow Corrina: fix one person (Recommended)**: "A correction writes a per-employee override
> for the corrected person only; the shared ticket times and the crewmate's pay stay untouched. An
> approved oiler then never blocks fixing the operator, so the lock and the reopen dead end go away.
> It's a redesign of the correction write (per-member overrides for every capture), so it goes in
> its own follow-up PR. This PR ships with today's lock as the interim guard."

**Rejected:** **Keep whole-crew fixes (your point 4).**

**What it means.**

- **The target behaviour.** A Payroll correction changes only the corrected person's hours. It
  writes that member's override. The shared ticket times and the crewmate's pay are untouched.
- **Point 4 is withdrawn.**
- **The approved-crewmate lock is interim.** Point 1 is a guard, not the target, and it lifts once
  the follow-up ships.

## Interim, as shipped: not the ruling

This was checked in the platform working tree on branch `fix/auto-recalc-preserves-approved-weeks`,
uncommitted, on 2026-10-28. Until the follow-up ships, a Payroll correction still edits the shared
`TicketTimeEntry` rows (`apps/api/src/usecase/payroll-send-backs/plan-correction.ts`):

- Start Work and End Work go to the member's own window only when the member already has one (the
  `own.*` fields). Otherwise they edit the ticket's shared `WORK_TIME`.
- Yard, site, boom and lunch times are always shared.

So a correction can still move a crewmate's pay. The two interim behaviours below reflect what the
code does to pay, not the target rule.

- **The lock (point 1), new.**
  - GET employee-week returns `settledCrew` (names) for each job day (`payroll.service.ts`). It
    comes from `PayrollSendBacksRepository.findSettledCrewPayByTicket`.
  - That is the same rule as the existing correction refusal `findSettledCrewPay`: a crewmate's week
    is `APPROVED` in the run in force, or the period is `APPROVED` / `EXPORTED`.
  - The web replaces Adjust Entries and Send Back with a note: *"<names> has/have an approved week
    on this ticket, so its entries can't be adjusted or sent back."* Its test id is
    `payroll-entry-locked-<ticketCode>`
    (`apps/web/src/features/payroll/components/payroll-expanded-actions.tsx`).
- **A crewmate's shared-time fix shows on every crew row, new.**
  - A `PayrollEntryFix` made on a crewmate's entry shows on this entry's Corrections tab, with only
    its changes outside `own.*`. It is labelled *"Shared ticket times corrected on <Name>'s entry"*
    (`entryFixesForEntry`, `apps/web/src/features/payroll/lib/payroll-entry-fixes-for-entry.ts`).
  - The send-back path already showed the changes on every sibling row.
- **Points 2 and 3 already held.**
  - A send-back creates one row per roster member under one `returnGroupId`, and each row holds
    that member's week (`sendBack`, PAYROLL-FLAGS REQ-25). This is the crew-wide shape in
    [2026-10-06-returned-entries-correction-flow-and-send-back.md](2026-10-06-returned-entries-correction-flow-and-send-back.md).
  - The web hides Approve Week while any hold is open.
  - The API also refuses approval while a recalculation is queued.

## Follow-up: named, not built

The follow-up is to finish **PAYROLL-FLAGS U19 / REQ-49**:

- [aidlc/PAYROLL-FLAGS/spec-u14-u21.md](../../aidlc/PAYROLL-FLAGS/spec-u14-u21.md), REQ-47 to
  REQ-49.
- [aidlc/PAYROLL-FLAGS/units-u14-u21.md](../../aidlc/PAYROLL-FLAGS/units-u14-u21.md), unit U19.

**Already in code since PR #709:**

- the `TicketEmployeeTimeOverride` table (REQ-47);
- pricing that prefers it (REQ-48, `PayrollTimeSource.EMPLOYEE_OVERRIDE`);
- `POST ticket-employees/:id/time-overrides`.

**Not built: REQ-49.** The web fix form (`CorrectionDialog`, Adjust Entries) never writes the
override.

**What the follow-up does.** A Payroll correction on a crew ticket with two or more members goes to
the corrected member's override instead of the shared rows. Once it ships, the settled-crew lock on
Adjust Entries lifts.

## Why

**First question.** He was asked how Payroll reopens one approved week. He answered a different
question: stop the situation arising. On a shared ticket, once a crewmate is approved, the entry
cannot be adjusted or sent back. And no crew member can approve while any entry on the ticket is
sent back.

**Second question.** The option text gives the reason. A per-person correction:

- leaves the crewmate's pay untouched;
- matches Corrina's verified rule;
- removes the cause of both the lock and the reopen dead end.

It is a redesign of the correction write, so it goes in its own PR.

## Conflict: raised and settled the same day

- **The conflict.** As first recorded, point 4 contradicted
  [2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md](2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md)
  (`verified`, Corrina Bustos), clause 3: *"A correction applies to the individual employee.
  Correcting a shared time (Start Work, End Job) changes that one employee's hours, not the whole
  crew's."* This note listed that file under `conflicts_with`.
- **Settled in 09-29's favour.** The conflict was put to Ali Riaz the same day, and he chose
  Corrina's rule. Point 4 is withdrawn, and `conflicts_with` is now empty.
- **The 09-29 note was not edited** and stays `verified`.
- **This also takes back an earlier developer reading.** The 2026-09-30 note's *C6 refined* bullet
  read the opposite way: shared times *"move for both workers when either edits them"*. For
  Payroll's corrections, the developer now sides with Corrina. That is the `supersedes_partial`
  entry above.
- **The verified side is still not fully built.** Until the follow-up ships, the code still edits
  the shared rows (see *Interim*).

## What this does not decide

1. **Whether Send Back keeps its crew-wide approved-member refusal.**
   - Send Back returns the whole ticket to its crew, and is refused while a crewmate is approved.
   - The follow-up lifts the lock on Adjust Entries. Whether the Send Back refusal also lifts, given
     that a send-back still returns every crew member, is open.
   - The crew-wide send-back itself (point 3) is the developer's answer C6, still **pending Corrina
     Bustos**, on the open gap
     [*Send Back of a multi-crew ticket*](../payroll/gaps.md#send-back-of-a-multi-crew-ticket--does-sending-a-ticket-back-also-return-it-for-the-other-crew-members-on-that-ticket).
2. **A worker's own edit of a shared ticket on mobile after Send Back (C3).** The second question
   was about Payroll's corrections only.
3. **The U19 ledger row is out of date.** In `units-u14-u21.md`, U19's status reads "not started",
   although REQ-47 and REQ-48 shipped in PR #709. The row was not edited here.
4. **Reopening a single approved week.** Until the follow-up ships, there is still no way to do it.
   - The API refusal still ends *"Ask Payroll to reopen that week first."*
     (`payroll-send-backs.service.ts`, on the `findSettledCrewPay` check).
   - The only path is a full-period manual Calculate, which clears every approval. See
     [2026-10-28-auto-recalc-reprices-pending-weeks-keeps-approved-weeks-frozen-developer-direction.md](2026-10-28-auto-recalc-reprices-pending-weeks-keeps-approved-weeks-frozen-developer-direction.md).
   - The follow-up removes that need for corrections. The general question stays with the open gap
     [*A labor-entry edit can reprice an approved week — and the ERP has no path for it*](../payroll/gaps.md#a-labor-entry-edit-can-reprice-an-approved-week--and-the-erp-has-no-path-for-it).
5. **The Operator's own-window adjustment on a locked ticket.** In the interim, hiding Adjust
   Entries also removes this adjustment from the timesheet, though the API would still accept it.
   The follow-up lifts the lock.

## Effect on the vault

- **No `status` changed anywhere.** No file is verified or superseded, and no other file's
  frontmatter was edited. That includes the 09-29 and 09-30 notes.
- **Done.** [payroll/INDEX.md](../payroll/INDEX.md) → *Decisions that bind this module*: one line
  for this note, updated for the amendment.
- **Not done in this pass:** `payroll/gaps.md`, where both gaps named above stay open;
  `payroll/payroll-rules-provenance.md`; and the PAYROLL-FLAGS U19 ledger row.

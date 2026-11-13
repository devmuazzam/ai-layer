---
title: "Shared Oiler + Operator ticket: sending back one crew member's entry sends the ticket back to every crew member on it and holds every one of their weeks until the correction is resolved and the period is recalculated (option (c) plus the hold). Ratified by Ali Riaz, standing in for Corrina Bustos, as a team ratification and not a TCG one: decision"
source: decision/Ali Riaz, ratification in a Claude Code session, 2026-11-11 (relayed to tcg-scrum by the coordinating session)
decided: 2026-11-11
decided_by: >-
  Ali Riaz (CodingCops developer; commits under the shared devmohsinakram git profile, as in the
  2026-10-06 and 2026-10-28 payroll notes), 2026-11-11, in a Claude Code session. tcg-scrum did not
  hear it first-hand. The coordinating session relayed it: asked directly whether he had the
  authority to ratify this himself, he answered "I'm the ratifier here, build it." He ratifies the
  developer answer C6 of 2026-09-30, which came from the same git profile. He stands in for
  Corrina Bustos, the ratifier the vault names for this point (the payroll/gaps.md entry's
  "Ratifier" line, and decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md
  decided_by: "Corrina Bustos for every extension of her verified 2026-09-30 decisions"). The vault
  has no record that Corrina Bustos, or anyone else at TCG, gave him that ratification.
  payroll/INDEX.md reserves `verified` for a decision by a named TCG person and records a decision
  by a named team member as `reference`. So this note is `status: reference`, on the same basis as
  the nine earlier Ali Riaz payroll notes. It binds implementation now, and TCG can overrule it.
  Corrina Bustos was not consulted. Recorded by tcg-scrum 2026-11-11.
status: reference
resolves: >-
  payroll/gaps.md#send-back-of-a-multi-crew-ticket--does-sending-a-ticket-back-also-return-it-for-the-other-crew-members-on-that-ticket
  (the main question, for build. The entry stays open on its remainder: a worker's own mobile edit
  of the shared ticket, and whether Corrina Bustos's own sign-off is still wanted)
supersedes: []
conflicts_with: []
related:
  - decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md
  - decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md
  - decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md
  - decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md
  - decisions/2026-10-06-returned-entries-correction-flow-and-send-back.md
  - decisions/2026-10-28-shared-crew-ticket-locked-once-a-crewmate-week-is-approved-developer-direction.md
  - ../payroll/gaps.md#send-back-of-a-multi-crew-ticket--does-sending-a-ticket-back-also-return-it-for-the-other-crew-members-on-that-ticket
tags: [module/payroll, kind/decision, api, web, send-back, approval, payroll-review]
---

## Decision

**The question.** Payroll sends back one crew member's entry, the Oiler's or the Operator's, on a
job ticket the two share. What happens to the other crew member's entry on that ticket?

The shared ticket is the verified shape in
[2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md](2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md),
clause 2. The Oiler is the ticket's primary employee and fills it. The Operator is a second
employee on the same ticket.

**Ratified, 2026-11-11.** Ali Riaz, as relayed, verbatim: *"I'm the ratifier here, build it."*

He ratifies developer answer **C6** of
[2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md](2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md).
That is option **(c)** of the gap, with option **(b)**'s hold:

1. **The send-back reaches the whole crew.** Sending back either crew member's entry on a shared
   ticket sends the ticket back to the other crew member's entry as well.
2. **Every crew member's week is held.** Both employees' weeks are blocked from approval while the
   send-back is open, and stay blocked until the correction is priced by a recalculation of the
   period.

**What was ratified, in the developer's own words** (2026-09-30, round 6, verbatim, typos kept):
*"we have rule if any job have oiler and oprator both then oiler and oprator have one tickt so if we
send oiler or oprator ticket back it should send other employee as well and block both employees
payroll"*.

## What this ratification does not decide

1. **A worker's own mobile edit of the shared ticket. Still open.** After a Send Back, the worker
   edits the ticket on mobile and resubmits (09-30 note, C3 and G2). If the Oiler edits a shared
   ticket time that way, does the Operator's pay move too, or only the Oiler's? Nothing settles it:
   - Corrina's verified clause 3
     ([2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md](2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md))
     is about Payroll's own correction: *"Correcting a shared time (Start Work, End Job) changes
     that one employee's hours, not the whole crew's."*
   - The 09-30 note's *C6 refined* bullet reads the other way, and the 2026-10-28 note withdrew it
     for Payroll corrections only. Its *What this does not decide*, item 2, leaves the mobile edit
     open.
   - This ratification is about who a send-back reaches and whose week it holds. It does not
     answer whose pay a worker's edit moves.
2. **Whether Corrina Bustos's own sign-off is still wanted.** The vault names her as the ratifier
   because C6 extends her verified rule that Send Back goes *"back to the worker"*
   ([2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md))
   from one worker to the whole crew. If TCG has given Ali Riaz that ratification, the record of it
   (who, when, where) is what promotes this note to `verified`.
3. **Whether Send Back keeps its refusal while a crewmate's week is approved.** This is item 1 of
   the 2026-10-28 note's *What this does not decide*, and it stays there.

## Why

- **The developer's reason (2026-09-30, round 6):** an Oiler and an Operator on the same job have
  one ticket. A send-back of either is therefore a send-back of that ticket, and both employees'
  payroll waits on it.
- **The risk it closes, as the gap entry recorded it:** under option (a), a correction to the shared
  times could reprice a crewmate whose week carried no hold. That week could be approved in between
  on figures the correction had made stale.
- **The ratification (2026-11-11):** Ali Riaz gave no further reason beyond the quote above.

## Standing: a team ratification, not a TCG one

- **Why `reference`.** [payroll/INDEX.md](../payroll/INDEX.md) → *Decisions that bind this module*
  reserves `verified` for a decision by a named TCG person. A decision by a named person on the
  team is `reference`, binding implementation until TCG says otherwise. All nine earlier Ali Riaz
  payroll notes are `reference` on that basis.
- **Why not `verified`.** The ratifier is not on TCG's side. The vault has no record that the named
  ratifier, Corrina Bustos, delegated this. And the answer ratified came from the same git profile
  as the ratification.
- **What it binds.** Implementation, now. A developer may build against it, and the build may
  stand. TCG can overrule it.
- **How it becomes `verified`.** Corrina Bustos confirms it, or the record of TCG giving her
  ratification to Ali Riaz is written down. A tcg-scrum pass then records that in a new note, sets
  this one to `verified` with `verified_because:`, and closes item 2 above.

## Build: already in code

Checked by reading the code at HEAD `fcfacb10b`. Not run, and no test was run.

- **The send-back reaches the whole crew.** `sendBack` creates one `PayrollSendBack` row for each
  member of the ticket's roster (`expandTicketToRoster`), all sharing one `returnGroupId`
  (`apps/api/src/usecase/payroll-send-backs/payroll-send-backs.service.ts:244-253`, `:373-410`).
  This is PAYROLL-FLAGS REQ-25, shipped in PR #709 (`a8ee5de9a`).
- **Each member's week is held.** `countBlockingByEmployee` counts each member's own open row, and
  a corrected or resubmitted row until a run that started after the correction
  (`apps/api/src/service/payroll-send-backs/payroll-send-backs.repository.ts:637-670`).
  `assertNoOpenSendBacks` refuses approval and export of every held week
  (`apps/api/src/usecase/payroll/payroll.service.ts:1642-1650`, with `correctionHoldsOf` at
  `:1622`).
- **A resubmit moves the whole crew.** `markResubmitted` moves every open row of the ticket, so
  every crew member's row changes together
  (`payroll-send-backs.repository.ts:540-565`).
- **No API change is outstanding for this question.** The gap's *Build: an API change, not built*
  dates from 2026-09-30, before PR #709.

## Effect on the vault

- **Done. This note.**
- **Done. [payroll/gaps.md](../payroll/gaps.md)**, entry *Send Back of a multi-crew ticket*:
  - The `Status` line now reads `open — remainder only`. It names this note as the ratification of
    the main question, and names the two open remainder items.
  - A dated *Update 2026-11-11* bullet at the end of the entry gives the ratification, marks the
    lines it overtakes, and names the open remainder.
  - The rest of the entry is kept as the record of what was in question.
- **No other file's frontmatter.** A `reference` note verifies and supersedes nothing:
  - the 09-29 and 09-30 Corrina Bustos notes stay `verified`, unedited;
  - the 09-30 developer-answers note stays `reference`, unedited;
  - the 09-14 one-ticket note stays `verified`, unedited.
- **Not touched: `payroll/payroll-rules-provenance.md`.** This is an approval-hold workflow rule,
  not a pay rule, and the file has no Send Back row.
- **Outside this pass's write scope, handed to the main session:** a line in
  [payroll/INDEX.md](../payroll/INDEX.md) → *Decisions that bind this module*. The count sentence
  above that list moves from twenty-five notes, twelve `reference`, to twenty-six, thirteen
  `reference`.

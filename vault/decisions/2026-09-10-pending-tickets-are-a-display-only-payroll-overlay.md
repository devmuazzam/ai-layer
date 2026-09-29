---
title: Pending and in-progress tickets on weekly payroll are a display-only overlay — decision
source: decision/Syed Haris
decided: 2026-09-10
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — developer/owner directing the `SCRUM-PENDING` work;
  chosen directly in a working session on 2026-09-10 from three options put to him
  (display-only overlay; provisional priced rows persisted behind a flag; a separate
  "Tickets not completed" screen). He is **not** the client-side product owner, and the
  owner this question is nominated to has not spoken to it: this is a payroll question, and
  the person who ratifies payroll questions on this record is **Corrina Bustos** (TCG Payroll
  Manager) — the named human on `2026-09-04-cross-midnight-day-type-and-holiday-minimum.md`,
  the only `verified` payroll decision in the vault, and the owner named on
  `../payroll/gaps.md` → *Weekly payroll week statuses*. `status: reference` rather than
  `verified` for that reason: binding on implementation now, open to being overruled by TCG.
  Same basis and same precedent chain as the `SCRUM-TZ` decisions —
  `2026-09-09-business-timezone-is-a-tenant-property.md`,
  `2026-09-09-business-day-starts-at-midnight-local.md`,
  `2026-09-09-fleet-timezone-retired-onto-tenant-zone.md` — and as
  `2026-09-08-artifact-due-date-seeded-from-first-job-day.md` and
  `2026-09-01-subsistence-not-a-craft-attribute.md`. A developer's confirmation is weaker
  than a payroll owner's, and this one decides what a payroll clerk sees on the screen they
  approve a week from — **Corrina Bustos should still ratify it**; see *What is weak about
  this attribution*.
status: reference
conflicts_with: []
provenance_note: >-
  CLAUSE 6 SUPERSEDED BY THE CLIENT, 2026-09-30 — decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md (status: verified). Corrina Bustos
  (Payroll Manager): "all tickets must be completed before the payroll can be processed/approved".
  An incomplete ticket now BLOCKS approval, not just warns. Whether it also blocks Calculate
  ("processed") is open. The display-only, never-priced overlay (the other clauses) is untouched.
  Body unchanged.
resolves: [SCRUM-PENDING/intent.md#11-numbers-thresholds-and-enumerated-values-on-the-ticket]
jira: []
tags: [module/payroll, kind/decision, ticket-workflow, time-tracking, reporting, requirements]
---

# Pending and in-progress tickets are a display-only overlay on weekly payroll

The canonical record of the decision recorded inline at
[`.ai/aidlc/SCRUM-PENDING/intent.md`](../../aidlc/SCRUM-PENDING/intent.md) §11, which cites
this file. It settles **what kind of thing** an unfinished ticket is on the payroll screen.
It does not settle what any of it is called, what its numbers mean, or what it blocks — see
*What this does NOT settle*, which is the longer half of this note.

## Decision

**A pending or in-progress job ticket shown on the weekly payroll screen is a display-only
overlay. It is a completeness signal for the clerk, not a pay record.**

Six clauses, all of them chosen in the same breath:

1. **Computed at read time** from the allocation and the ticket's time captures. Nothing is
   stored to make it appear and nothing has to be recomputed to make it go away.
2. **Never written to `payroll_job_days`.** That table stays the paid record — priced rows
   from completed tickets, exactly as today.
3. **Excluded from the employee-week's money and payable-hour totals.** The week's
   `actualHours`, `payableHours` and `totalAmount` mean what they mean today.
4. **No effect on the ADP export.**
5. **No schema migration.**
6. **A week carrying an open entry should warn before approval.** *Warn* is the strongest
   word this decision authorises — whether it also blocks is explicitly not settled here.

Clause 2 is the load-bearing one and clauses 3, 4 and 5 mostly follow from it mechanically
rather than being independent promises — see *Why* §2.

## Why

### 1. The incumbent system treats an unfinished ticket as a completeness signal, not as pay

[`../payroll/fcc-nexgen-payroll-processing.md`](../payroll/fcc-nexgen-payroll-processing.md)
(`status: unverified`) §4 lists the reports the payroll team uses today. Two of them are
about labor that is *missing* rather than labor that is *owed*:

| Report | Path | What the manual says |
| --- | --- | --- |
| **Employee Payroll Processor Summary** | `Reports → Labor → Employee Payroll Processor Summary` | *"can help identify missing labor by exposing days with no labor entered"* |
| **Tickets Not Completed** | `Reports → Jobs → Tickets Not Completed` | Incomplete tickets — another route to missing labor |

The incumbent surfaces incomplete tickets **as a report the clerk reads**, and nowhere as a
priced entry. Its payroll entries only ever come from the pre-processor, and its lifecycle
locks (§2 of the same file — Approved → Processed → Exported) all attach to a labor row that
already exists. There is no provisional-pay state anywhere in the vendor's model.

**State the limit of this evidence.** It is a 2017 1st-draft vendor manual, `status:
unverified`, describing a product TCG is replacing; and
[`../INDEX.md`](../INDEX.md) is explicit that FCC behaviour is not a requirement source
unless the behaviour is written down in the vault or on a ticket. It shows the shape of the
need is real and that the incumbent answered it *without paying anything*. It does not prove
the requirement, and it certainly does not prove **placement** — see the contradiction
recorded under *Effect on the vault*.

### 2. Clauses 3, 4 and 5 are consequences of clause 2, not extra commitments

Worth spelling out, because it means this decision authorises less new machinery than it
looks like it does.

- The ADP workbook is rebuilt entirely from **persisted run data**:
  `payroll.service.ts:471` and `:496` call `rebuildEngineResult(periodId)`, which reads
  employee weeks and their `jobDays` off the run
  ([`payroll.service.ts:521-575`](../../../apps/api/src/usecase/payroll/payroll.service.ts)).
  A row that is never persisted **cannot** reach the export. Clause 4 is not a rule anyone
  has to enforce; it is a property of the read path.
- The week totals (`actualHours`, `payableHours`, `totalAmount`) are persisted columns on
  the employee week, written once by `persistRun`
  ([`payroll.service.ts:220-232`](../../../apps/api/src/usecase/payroll/payroll.service.ts)).
  Clause 3 holds for the same reason.
- `PayrollJobDay` ([`schema.prisma:5032`](../../../apps/api/prisma/schema.prisma)) carries a
  non-null `runId` and a non-null `totalAmount`, and every hour column is a priced bucket.
  There is no nullable "provisional" shape to write into, which is exactly why the
  persisted-with-a-flag alternative would have needed a migration and this one does not.
- Clause 5 is reachable, and this was checked rather than assumed:
  `JobResourceAllocation.jobScheduleInterval` is a direct FK relation
  ([`schema.prisma:3747`](../../../apps/api/prisma/schema.prisma)), and
  `JobScheduleInterval` carries `date` (`:3550`), `estimatedEndTime` (`:3557`) and
  `secondShiftEstimatedEndTime` (`:3563`). Everything the overlay needs to place an
  unstarted ticket in a week is one relation away. This closes the `?` that
  [`intent.md`](../../aidlc/SCRUM-PENDING/intent.md) §6 left against `apps/api/prisma` on the
  grounds that reachability was unverified.

### 3. A partial shift's priced answer is not a prefix of its finished answer

This is the argument that killed the provisional-priced-rows alternative, and it is a
property of the rules, not of the implementation.

Three L12 rules resolve only at end of shift:

- [`PAY-040`](../payroll/rules/PAY-040-work-provided-minimum.md) — *"Apply minimum four paid
  hours where applicable."* A two-hour shift shows 2.0 h and pays 4.0 h **if it ends there**,
  and shows 2.0 h and pays 2.0 h if it does not.
- [`PAY-043`](../payroll/rules/PAY-043-long-boom-premium.md) — the long-boom qualifying
  minimum, which its own file records as grouping **per `ShiftAnchorDate`** rather than per
  labor row, so it cannot be evaluated against a boom window that is still open.
- [`PAY-045`](../payroll/rules/PAY-045-rest-period-premium.md) — the rest-period premium
  fires on the *previous* chain's OT/DT and the gap before this entry, so what an in-flight
  entry is worth depends on a chain boundary that has not happened yet.

A provisional figure would therefore **fall** as well as rise — a retrospectively logged
lunch reduces it, and a shift that continues past four hours removes the guarantee top-up it
was displaying. A number on a payroll screen that goes down is the worst available failure
mode for the clerk this feature exists to help.

**Say what is weak about this argument too:** all three rules are `status: open` in their own
frontmatter, and PAY-045's file records that its stated ×1.5 OT floor was contradicted by a
2026-09-07 client comparison run pricing rest-forced hours at ×2.0 from the first hour. That
does not weaken the conclusion — a rule set still being adjudicated is *more* reason not to
persist a priced guess against it, not less — but nothing here is being cited as settled law.

### 4. The screen already carries a completeness signal, and it is currently wrong

Not decisive, and recorded because it sharpens what the overlay is for.
`apps/web/src/features/payroll/components/payroll-employee-daily.tsx:77-96` ships a
`PayrollIncompleteBanner`, and the days it names come from `missingDayLabels`
([`payroll-employee.helpers.ts:97-99`](../../../apps/web/src/features/payroll/components/payroll-employee.helpers.ts)),
which is *every day of the period with no priced `jobDay`*. That is exactly the conflation
[`intent.md`](../../aidlc/SCRUM-PENDING/intent.md) §2 describes: a day the employee genuinely
did not work and a day whose ticket nobody finished both render as the same absent row, and
the banner accuses the employee in both cases. A read-time overlay separates them without
touching the paid record. **§2 marks that reading of the business intent as a reading, not a
sourced requirement, and this note does not upgrade it** — it is why the decision was easy to
take, not evidence of what the feature is for.

## What is weak about this attribution

Stated plainly, because the whole value of a decision note is that the next reader can judge
its weight. This is the same weakness the `SCRUM-TZ` notes carry, and it is not smaller here.

- **The decider of record is Syed Haris**, in session, 2026-09-10 — a real, named, datable
  human who directs the work, choosing from three options he was shown. The decision binds
  the build.
- **He is a developer, not TCG's payroll owner, and this is a payroll question.** The one
  `verified` payroll decision in this folder
  ([`2026-09-04-cross-midnight-day-type-and-holiday-minimum.md`](2026-09-04-cross-midnight-day-type-and-holiday-minimum.md))
  is Corrina Bustos's, in writing; `../payroll/gaps.md` names her as the owner of the
  adjacent status question; and she has not spoken to this one. **Corrina should still
  ratify it.** If she does, re-issue or amend this note with her as `decided_by:` and
  reconsider `status:`.
- **What ratification would actually be for.** Clauses 1–5 are largely a build-shape choice a
  developer can reasonably make, and their cost of being wrong is a rewrite. Clause 6 is
  not — *warn before approval* is an operational claim about the payroll clerk's workflow,
  and the person who knows whether a clerk wants to be stopped, warned or left alone is the
  clerk's manager. That is the clause to put in front of Corrina first.
- **Nothing is relayed second-hand.** No TPM approval is claimed and none is implied; this
  note has exactly as much authority behind it as the one person named.
- **Two of the three options were never costed against a user.** The choice was made on
  engineering grounds — what the rules permit and what the schema would need — with the
  incumbent's report as corroboration. No payroll clerk was asked which of the three they
  would rather have.

## What this does NOT settle

All three of these are already recorded as blocking questions on the ticket capture
([`intent.md`](../../aidlc/SCRUM-PENDING/intent.md) §12 Q1, Q2 and Q6) and stay open there.
They are repeated here so this note cannot be read as more complete than it is.

- **Whether an unfinished ticket blocks period approval or ADP submission, or merely warns.**
  The decision says *warn* and stops. `intent.md` §12 **Q6** stays open, and §5 lists the
  question as out of scope-but-adjacent. **This is not a clean slate — the shipped screen
  already asserts an answer**; see the contradiction under *Effect on the vault*.
- **What the entry statuses are called.** Three labels are needed
  (`intent.md` §11 records all three as `NOT ON TICKET`, one of them written by the requester
  as *"or someting like"*), and **none may be invented while the adjacent conflict is open**.
  [`../payroll/gaps.md`](../payroll/gaps.md) →
  [*Weekly payroll week statuses — two CodingCops sources, no TCG statement*](../payroll/gaps.md#weekly-payroll-week-statuses-two-codingcops-sources-no-tcg-statement)
  records an unresolved disagreement between **In Progress / Submitted / Processing /
  Received / Paid** (demoed 2026-08-13) and **In Progress / Needs Processing / Submitted to
  ADP / Closed** (`PAY-WP-04` AC 7), both CodingCops artefacts, neither ratified by TCG.
  **Those are *week* statuses and these are *entry* statuses — they may be a different
  vocabulary entirely.** Do not merge the two sets, do not pick one, and do not invent a
  third. Surface it and ask.
- **What "locked hours" means** — elapsed clock time, or a priced ST/OT/DT split. The
  requester was asked in session and deferred it to the elaboration loop
  (`intent.md` §10, §12 Q1). *Why* §3 above constrains the answer without giving it: whatever
  the figure is, it must be one that cannot fall.

Also not settled by this note, and listed on the ticket rather than here: how "the current
phase" is derived from an enum whose members overlap (§12 Q3), which week an unstarted ticket
belongs to (§12 Q4 — *Why* §2 shows `JobScheduleInterval.date` is *reachable*, which is not
the same as sourced), when "ticket end time" has passed (§12 Q5), and which `JobTicketStatus`
values count as "assigned" (§12 Q7).

## Effect on the vault

- **No vault file body was edited by this note, and no frontmatter was flipped by it.** This
  was never a conflict set: nothing in the vault says anything about unfinished tickets on
  the payroll screen, so there is no winner to mark `verified` and no loser to mark
  `superseded`. The four-step closure in [`../README.md`](../README.md) → *How a gap gets
  closed* does not apply.
  [`../payroll/fcc-nexgen-payroll-processing.md`](../payroll/fcc-nexgen-payroll-processing.md)
  keeps `status: unverified` — it is corroboration, not the source of the requirement — and
  gains no `verified_because:`.
- **[`../payroll/gaps.md`](../payroll/gaps.md) → *Weekly payroll week statuses* stays
  `Status: open`, untouched.** This note narrows nothing there. If anything it adds load: a
  second status vocabulary is now wanted on the same screen while the first is unadjudicated.
- **No new gaps entry was appended.** Every question this note leaves open belongs to
  `SCRUM-PENDING` and is already recorded in [`intent.md`](../../aidlc/SCRUM-PENDING/intent.md)
  §12, which the elaborator carries into `spec.md` §12. Duplicating them into
  `../payroll/gaps.md` would create two registers for one question.
- **Contradiction on placement, recorded because the supporting evidence cuts against the
  chosen option.** The incumbent's *Tickets Not Completed* lives at `Reports → Jobs`, **not**
  under `Reports → Labor` with the payroll reports — the one piece of prior art here answers
  this need on a **separate screen**, which is the third of the three options offered and the
  one not chosen. The evidence supports *display-only, not pay*; it does not support *on the
  weekly payroll screen*. Nobody has been asked whether the clerk wants these rows inline or
  in a report, and this note does not claim FCC as authority for the placement.
- **Contradiction on `main` today, and it lands squarely on the question this note leaves
  open.** `apps/web/src/features/payroll/components/payroll-employee-daily.tsx`:91 ships the
  copy *"This week cannot be fully approved until all daily tickets are completed."* — a
  **blocking** claim, in the user's face, about precisely the semantics
  [`intent.md`](../../aidlc/SCRUM-PENDING/intent.md) §12 Q6 records as unanswered. The API
  enforces nothing of the kind:
  [`approveEmployee` and `approvePeriod`](../../../apps/api/src/usecase/payroll/payroll.service.ts)
  (`:317` and `:324`) apply no completeness gate at all, and a `FLAGGED` week approves without
  objection. Three positions on one question — the UI says blocked, the API allows, this
  decision says warn and declares it unsettled. **Whoever answers Q6 must reconcile the
  shipped copy, not just choose.**
- **Scope tension worth flagging to the elaborator, not a contradiction of this note.**
  `intent.md` §5 puts *"chasing or notifying anyone about an unfinished ticket"* out of scope,
  while `payroll-employee-daily.tsx`:95 already ships a **Send Reminder** button beside that
  banner. The affordance exists; the ticket says not to build one. Confirm which.
- **Consequence for the shipped banner, for the elaborator rather than for this note.**
  `missingDayLabels` counts only priced `jobDays`, so the moment pending rows render, a day
  showing an in-flight ticket will still be named in *"has not submitted a ticket for …"*.
  The overlay does not fix that banner by existing; something has to change with it.
- **Flagged, not done:** [`../payroll/INDEX.md`](../payroll/INDEX.md):140 has a *Decisions
  that bind this module* section; this note carries `module/payroll` and belongs in it.
  `tcg-scrum` has no write access to that body. That list is **already stale** — its prose
  says "Seven `decisions/` notes" while listing eight, and it omits
  [`2026-09-09-business-day-starts-at-midnight-local.md`](2026-09-09-business-day-starts-at-midnight-local.md),
  which flagged the same thing on 2026-09-09. Whoever maintains the index should add both and
  fix the count.
- **Flagged, not done:** [`intent.md`](../../aidlc/SCRUM-PENDING/intent.md) §11 says the
  decision is "recorded separately" without naming the file; it should now cite
  `decisions/2026-09-10-pending-tickets-are-a-display-only-payroll-overlay.md`. `tcg-scrum`
  writes `spec.md` §12, not `intent.md`, so the capture's author should add the link.
- **Not touched, by instruction:** `.ai/aidlc/SCRUM-PENDING/spec.md` does not exist yet and is
  the elaborator's to write.
- **No code change is authorised or implied.** In particular this note does **not** authorise
  a migration on `payroll_job_days`, a provisional or `isPending` flag on any payroll table,
  or any change to `findCompleteTicketsInRange`
  ([`payroll.repository.ts`](../../../apps/api/src/service/payroll/payroll.repository.ts):168),
  whose `status: COMPLETE` filter is the "exactly as today" this decision preserves.

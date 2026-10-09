---
title: "Payroll Calculate runs automatically when ticket or correction data changes, not only when a payroll user presses Calculate — decision (TPM, relayed; written source not yet linked)"
source: decision/AJ (TPM) — relayed by Syed Haris (CodingCops), 2026-10-06 review session
decided: 2026-10-06
decided_by: >-
  AJ, described by the relayer as "our TPM": TPM on the delivery side of the TCG project, not
  the client. Relayed second-hand on 2026-10-06 by Syed Haris (developer, CodingCops) in a review
  session, in these words: "It was decided that we will do automatic recalculation, was decided
  by our TPM AJ." The `decided:` date is the date it was RELAYED. The date of AJ's own decision,
  the channel (Slack, call, meeting), and any link or written record were not given. The original
  written source is NOT YET LINKED. AJ's full name and employer are not recorded in the vault
  either. Do not read the meeting transcripts' "AJ"
  (meetings/transcripts/2026-09-02-erp-job-tickets-and-payroll.md 54:21, whose header says that
  "AJ" addresses Abdul Rehman) as identifying this person. Nobody has confirmed that.
  CLIENT CONSULTATION. Later on 2026-10-06, Syed Haris said, verbatim: "we've not discussed with
  corrina or brian, but it's our decision so no need for their confirmation". So this is a
  delivery-side process decision. TCG's payroll owners, Corrina Bustos (Payroll Manager) and
  Brian Petros (Data Analyst, ERP Project Coordinator), were not consulted on it. Per Syed Haris,
  their confirmation is not required. It is recorded on that basis, and on the same footing as
  decisions/2026-09-24-payroll-failed-recalculation-keeps-last-good-run-and-blocks-approval.md
  ("client sign-off is not needed"). TCG may still overrule it.
status: reference
supersedes: []
supersedes_partial:
  - "decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md (clause 4: 'Automatic recalculation was not chosen: recalculating is a money operation Payroll triggers.', and 'On resubmission: … Payroll then recalculates the period to price it.' On who triggers it: the period is now recalculated automatically. The first 2026-09-29 addendum, item C: 'Recalculating the period is still the only money write, and it sets final pay' still holds as a statement about what the money write is. This note changes only who or what starts it)"
  - "decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md (K5: 'A worker's resubmit waits for the next Calculate'. The wait stands, and the resubmit still does not re-run flags by itself. But the next Calculate is now queued automatically by the resubmit. It is no longer started by a payroll user. Also C3's 'Payroll then recalculates', in the same sense)"
  - "aidlc/PAYROLL-FLAGS/spec-u6-u13.md §12 Q25 (answer: 'a worker's resubmit holds the week until payroll recalculates'. The recalculation is now automatic, and the hold lasts until the queued run completes)"
conflicts_with: []
provenance_note: >-
  Recorded 2026-10-06 by tcg-scrum from a relay by Syed Haris in a review session. Amended the
  same day for his second statement: the client was not consulted, and their confirmation is not
  needed. Title, decided_by and body were updated to match.
  WHY status IS reference, NOT verified. The only thing missing is a written source for AJ's
  decision. It is relayed second-hand, with no date, channel or link, so nobody reading this
  later can check it. Same basis as decisions/2026-09-09-business-timezone-is-a-tenant-property.md,
  except that the TPM is named here. Syed's second statement settles whose decision this is. It
  does not supply AJ's record. When AJ's written source is found (message, ticket or meeting note),
  link it here and reconsider status: verified becomes available, on the 2026-09-24 precedent of
  a CodingCops-side decision recorded as verified. No §12 item tracks this: it is bookkeeping on
  this note, not an open product question.
  conflicts_with WAS EMPTIED in the amendment. It had named
  meetings/transcripts/2026-06-09-payroll-app-demo-01.md. In that transcript, at 19:55, Brian
  Petros describes the LEGACY app's Refresh ("pulls in new information and recalculates it") as
  something the payroll team must "ask the payroll manager to refresh". That is a description of
  the legacy app, never a commitment. The verified 2026-09-24 note already cites it as context
  only. This decision has been placed outside client ratification. So the remark is kept below,
  under Context, and is not an open conflict.
resolves:
  - "aidlc/PAYROLL-FLAGS/spec-u6-u13.md §12 Q26 (no client confirmation required, per Syed Haris 2026-10-06)"
jira: []
tags: [module/payroll, kind/decision, recalculation, payroll-review, approval, send-back]
entities: []
---

# Payroll Calculate runs automatically

## Decision

**As relayed, verbatim.** Syed Haris (CodingCops), 2026-10-06, review session:

> "It was decided that we will do automatic recalculation, was decided by our TPM AJ."

**The original written source has not been linked.** No date for AJ's decision, no channel and
no link was given. None is invented here.

**On the client, verbatim.** Syed Haris, later the same session, 2026-10-06:

> "we've not discussed with corrina or brian, but it's our decision so no need for their confirmation"

So this is a delivery-side process decision. TCG's payroll owners, Corrina Bustos and Brian
Petros, were **not consulted**. Per Syed Haris, their confirmation is **not required**. That is
the same footing as the verified 2026-09-24 failed-recalculation note: *"client sign-off is not
needed"*, and TCG may still overrule it.

**What it decides, as the relayer and the coordinating session scoped it:**

- A pay period's Calculate runs **automatically** when its underlying data changes. Before, it ran
  only when a payroll user pressed Calculate.
- The mechanism is the one already built on the platform repo's `feat/PAYROLL-FLAGS-foundation`
  branch: PR #709, which is open and not merged as of 2026-10-06, and main-repo commit `25c415f2b`
  (*"feat(payroll): auto-calculate queue with Postgres-backed job processing"*, devmohsinakram,
  2026-10-05). What it does, checked against that branch:
  - **A queue table.** Model `PayrollCalculationJob` is mapped to `payroll_calculation_queue`
    (`apps/api/prisma/schema.prisma:5968–5989`). Its comment says it deduplicates by period:
    one PENDING/PROCESSING job per period.
  - **Triggers.** The `PayrollCalcTrigger` enum is `TICKET_COMPLETE · CORRECTION_RETURNED ·
    ENTRY_FIX` (`schema.prisma:5960–5964`). Four places enqueue a run:
    - crew ticket completion (`apps/api/src/usecase/job-tickets/job-tickets.service.ts:1311`);
    - payroll completing a ticket (`apps/api/src/usecase/payroll/payroll.service.ts:1282`);
    - a worker's resubmit after Send Back
      (`apps/api/src/usecase/payroll-send-backs/payroll-send-backs.service.ts:598–601`);
    - a payroll entry fix or time override
      (`apps/api/src/usecase/payroll-entry-fixes/payroll-entry-fixes.service.ts:383–386`).
  - **Polling.** The queue is polled every **10 s** (`POLL_INTERVAL_MS = 10_000`,
    `apps/api/src/usecase/payroll/payroll-calculation-queue.service.ts:8`, `@Interval`).
  - **Skipped periods.** A period that is **APPROVED or EXPORTED** gets no auto-calculation
    (`apps/api/src/usecase/payroll/payroll-calc-enqueue.service.ts`, in `enqueueForDate`).
  - **Manual Calculate is still there.** The branch keeps `POST periods/:id/calculate`
    (`apps/api/src/presentation/payroll/payroll.controller.ts:79`) and a recalculate button
    (`apps/web/src/features/payroll/components/payroll-recalculate-button.tsx`). Automatic runs
    are added; the manual one is not removed.

## Why

**No reasoning was relayed.** The statement gives the verdict only. This note does not supply a
reason on AJ's behalf.

The rationale that this decision overturns was written down. The 2026-09-28 note, clause 4, says:
*"recalculating is a money operation Payroll triggers."* A reader settling a similar question
should know which way that went, and that it is not known why.

## What changes, and what does not

- **Changes: who starts the run.** Before, a payroll user started a run. Now a data change queues
  one.
  - 2026-09-28 clause 4 said *"Payroll then recalculates the period"*, and Q25 / K5 said
    *"until payroll recalculates"*. The period is now recalculated by the queue.
- **Does not change: the holds.** A correction or resubmit newer than the latest **completed** run
  still holds approval, because the 2026-09-28 clause 4 hold is a comparison against the latest
  completed run. A resubmit still does **not** re-run flags by itself.
  - The ticket spec's REQ-30 Acceptance is still literally true. In practice, the hold now lasts
    about one poll interval plus the run time, not until a person acts.
- **Does not change: what the money write is.** Calculate is still the only money write.
  - The correction-page pay estimate (first 2026-09-29 addendum, item C) is still an estimate.
- **Does not change: failure handling.** The verified 2026-09-24 decision still governs what
  happens when a run fails, automatic or not.
  - The failed run is recorded, the last good run stays shown with a warning, and approve/export
    are blocked until a run succeeds or the manager confirms.
  - Commit `25c415f2b` adds failed-calculation endpoints and retry
    (`payroll.controller.ts:130`). This note does not check whether the warning and the block are
    built.
- **Does not touch approved or exported periods.** The queue skips them. The open payroll gap
  [*A labor-entry edit can reprice an approved week*](../payroll/gaps.md#a-labor-entry-edit-can-reprice-an-approved-week--and-the-erp-has-no-path-for-it)
  stays open. That gap asks who may trigger a recalculation that reaches into a closed week, and
  this decision does not answer it.

## Context

- [meetings/transcripts/2026-06-09-payroll-app-demo-01.md](../meetings/transcripts/2026-06-09-payroll-app-demo-01.md)
  19:55. Brian Petros (client) describes the legacy Refresh button. It *"pulls in new
  information and recalculates it"*, and the payroll team must *"ask the payroll manager to
  refresh"*.
  - This describes the **legacy** app. It is context only, not a commitment. The verified
    2026-09-24 note already treats it that way.
  - This note listed it under `conflicts_with` until the 2026-10-06 amendment. It was removed
    from there once Syed Haris stated the decision is not subject to client confirmation (see
    `provenance_note`).

## Not decided — recorded, not resolved

1. **AJ's written source.** The date, channel and link are missing, and so is AJ's full name.
   - This is tracked here, in `provenance_note`, not as a §12 question.
   - Linking it is the one step that would let `status` be reconsidered.
2. **Whether payroll users can see, pause or opt out of automatic runs.** Nothing written says.

*Settled by the 2026-10-06 amendment: whether the client must confirm. Syed Haris says they need
not, and they were not consulted.*
[aidlc/PAYROLL-FLAGS/spec-u6-u13.md §12 Q26](../../aidlc/PAYROLL-FLAGS/spec-u6-u13.md) is
resolved on that basis.

## Effect on the vault

Frontmatter only. No body was changed. All of these edits were done on overlay branch
`feat/PAYROLL-FLAGS-foundation`, in the recording pass and its same-day amendment:

- **Done.** [`decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md`](2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md):
  `provenance_note` now has a paragraph pointing here.
  - It covers clause 4's *"Automatic recalculation was not chosen"* and *"Payroll then
    recalculates"*.
  - It notes that item C of the first addendum still holds as a statement about the money write.
  - `status` stays `reference`, because the other clauses still stand.
- **Done.** [`decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md`](2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md):
  `provenance_note` now has a paragraph pointing here, covering K5 and C3's *"Payroll then
  recalculates"*. `status` stays `reference`.
- **Done.** [`aidlc/PAYROLL-FLAGS/spec-u6-u13.md`](../../aidlc/PAYROLL-FLAGS/spec-u6-u13.md) §12:
  - Q25 has one appended line pointing here. Its answer and status are left intact as the record.
  - **Q26 is resolved**: no client confirmation is required, per Syed Haris, 2026-10-06.
- **Not changed.** [`decisions/2026-09-24-payroll-failed-recalculation-keeps-last-good-run-and-blocks-approval.md`](2026-09-24-payroll-failed-recalculation-keeps-last-good-run-and-blocks-approval.md)
  (verified). It is not superseded: it covers failed runs, whatever starts them. It is cited here
  only for its Context line.
- **Not done, because index and spec bodies are outside the recording agent's write scope:**
  - [payroll/INDEX.md](../payroll/INDEX.md) → *Decisions that bind this module* has no line for
    this note.
  - The Sources lines of REQ-30 in `spec-u6-u13.md` still quote *"Payroll then recalculates"* and
    *"until payroll recalculates"*. Its Acceptance says *"until the next completed run"*, which is
    still accurate. A spec owner may want to add that the run is now queued automatically.
- **Nothing is verified or superseded outright.** No file's `status` changed.

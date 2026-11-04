---
title: "Automatic recalculation of an open period reprices the unapproved weeks and carries approved (and exported) weeks forward frozen, approval kept: developer direction"
source: decision/Ali Riaz, developer direction in a Claude Code session, 2026-10-28 10:38 UTC (platform branch fix/auto-recalc-preserves-approved-weeks)
decided: 2026-10-28
decided_by: >-
  Ali Riaz (CodingCops developer; commits under the shared devmohsinakram git profile, as in the
  2026-10-06 payroll notes). He reported the problem from staging
  (portal.craneguys.com/payroll?weekStart=2026-10-24). At 10:38 UTC he was given two options in a
  structured question and chose "Reprice pending, keep approvals". The "(Recommended)" tag on that
  option was added by the session that asked the question. It does not reflect any TCG preference.
  This is a developer direction, not a TCG product decision. It is therefore `status: reference`,
  on the same basis as 2026-10-27-adp-re-export-of-a-sent-week-developer-direction.md. TCG payroll
  (Corrina Bustos, Brian Petros) was not consulted. It binds implementation now, and TCG can
  overrule it. Recorded by tcg-scrum 2026-10-28.
status: reference
supersedes: []
supersedes_partial: []
conflicts_with: []
related:
  - decisions/2026-10-06-payroll-calculate-runs-automatically.md
  - decisions/2026-09-24-payroll-failed-recalculation-keeps-last-good-run-and-blocks-approval.md
  - decisions/2026-10-27-adp-re-export-of-a-sent-week-developer-direction.md
  - ../payroll/rules/PAY-066-payroll-snapshot.md
  - ../payroll/gaps.md#a-labor-entry-edit-can-reprice-an-approved-week--and-the-erp-has-no-path-for-it
  - ../../aidlc/PAYROLL-WEEK-RECALC-APPROVE/spec.md
tags: [module/payroll, kind/decision, api, web, recalculation, approval]
---

## Decision

**The question, verbatim.** Structured question, Claude Code session, 2026-10-28 10:38 UTC:

> "When a change (completed ticket, override, etc.) triggers an automatic recalc but some employee
> weeks in the period are already approved, what should happen?"

**Chosen, verbatim:**

> **Reprice pending, keep approvals (Recommended)**: "Auto-recalc reprices only the unapproved
> employees and carries approved (and exported) weeks forward frozen+approved — reusing the PAY-066
> freeze. The pending weeks update automatically; the approval is untouched; no manual Recalculate
> needed. Still never clears an approval (honors PR #709). Also fixes the Retry loop and my 2 PR
> defects."

**Rejected, verbatim.** The text was truncated in the relay, and is quoted here as relayed:

> **Keep current, fix only the defects**: "Leave the all-or-nothing design (any approval blocks
> auto-recalc; manual Recalculate clears approvals to pull changes in)…"

What this means in a period that is still open (not `APPROVED` or `EXPORTED`):

- **An automatic run reprices only the unapproved weeks.** Every week that is approved or already
  exported is carried forward verbatim from the figures in force, and keeps its approval.
- **An automatic run never clears an approval.**
- **A manual Calculate is unchanged.** It still reprices every week and clears approvals.

## Context: what it replaces

- **Before this ruling, the automatic run refused outright** if any week in the period was
  approved. The job's reason read *"Not recalculated automatically: 1 employee week is approved…"*.
  This is the prior `approvedWeeksHoldReason` in `apps/api/src/usecase/payroll/payroll.service.ts`,
  which also said *"recalculating clears approvals. Recalculate the period to include this change."*
- **The banner had no button to act on.** It told the user to recalculate the period, but the
  period-level Recalculate had been removed from the worklist on 2026-10-16. That was platform
  commit `3d4a2633f`, *"feat(web): move payroll Recalculate to drifted rows; gate Approve Week on a
  clean week"*.
- **Retry looped.** Each retry ran into the same refusal again.
- **Reported by** Ali Riaz from staging, portal.craneguys.com/payroll?weekStart=2026-10-24.

## How it was built: a developer refinement, not part of the ruling

**This section is not part of the ruling.** After an audit later the same day, the developer
refined how the ruling was built. It is recorded here so it can be reviewed. The code was checked
in the platform working tree on branch `fix/auto-recalc-preserves-approved-weeks`, uncommitted, on
2026-10-28.

1. **An approved week the new figures would change keeps its approval, but the job stays
   outstanding.** This applies to a week that is approved but not yet exported.
   - "Would change" means: the freshly priced figures have a different ticket set from the frozen
     ones, or payable hours or total amount differ by more than half a cent.
   - The week is still carried with its approval. The run's figures are persisted with the pending
     weeks repriced.
   - The automatic job is recorded as not applied (`NOT_APPLIED` → `markNotApplied` in
     `payroll-calculation-queue.service.ts`). Its reason names each such employee
     (`divergedApprovedReason` in `payroll.service.ts`).
   - While that job is outstanding, approve and export stay held.
2. **The queue banner offers "Recalculate period"**
   (`apps/web/src/features/payroll/components/payroll-failed-calculations.tsx`).
   - On a period with approvals, it first asks for confirmation that it reopens N approved weeks.
   - It is a manual Calculate, so it clears approvals, as before.
3. **The automatic run does not reconcile flags on approved weeks.** Their figures did not move, so
   their flags are left as they were.
4. **A period that holds carried weeks goes to `REVIEW`**, not `CALCULATED`
   (`apps/api/src/service/payroll/payroll.repository.ts`).
5. **An approve that races a run is refused under the period row lock.** The message is *"This
   period was recalculated while you were approving. Reload and try again."*
   (`PayrollApprovalSupersededError` in `payroll.repository.ts`, returned as 409).

**A consequence to review.** The check in point 1 covers approved weeks that are not yet exported.
An exported week is carried silently, even if the new data would have priced it differently. That
matches the 2026-10-27 note: a correction cannot reach a sent week.

## Why

The ruling exists because of the dead end described under *Context*:

- an automatic run that any single approval blocked,
- a banner pointing to a control that no longer existed,
- a Retry that only repeated the refusal.

The chosen option gets the change into every pending week without touching an approval. It also
keeps the PR #709 rule that an automatic run never clears one. The code comment cites that rule as
"PR #709 decision 1". No reason beyond the option text was given for preferring it over the
rejected option.

## Relation to existing notes

**Supersedes nothing.** No clause of any note is overturned, in full or in part.

- **[2026-10-06-payroll-calculate-runs-automatically.md](2026-10-06-payroll-calculate-runs-automatically.md)**
  (`reference`): not superseded.
  - Its *Skipped periods* clause covers **periods** that are `APPROVED` or `EXPORTED`. Those are
    still skipped.
  - This ruling covers approved **weeks inside a period that is still open**. The 10-06 note says
    nothing about those.
  - Its "Does not change: the holds" still stands.
  - One descriptive line in it is now out of date: *"a recalculate button
    (`payroll-recalculate-button.tsx`)"*. That button left the worklist on 2026-10-16, and the
    refinement above brings a period-level action back on the queue banner. The line described the
    branch as of 2026-10-06. It is not a clause, so nothing is superseded.
- **[2026-09-24-payroll-failed-recalculation-keeps-last-good-run-and-blocks-approval.md](2026-09-24-payroll-failed-recalculation-keeps-last-good-run-and-blocks-approval.md)**
  (`verified`): not superseded or modified.
  - That note governs a run that **fails**.
  - In the changed-approved-week case here, the run completes and its figures are the ones in
    force. The hold comes from the job left outstanding, not from a failed run.
  - This ruling does not say whether 09-24's manager confirmation ("explicitly confirms proceeding
    with the previous numbers") also releases that outstanding job, and this note did not check.
- **The gap [*A labor-entry edit can reprice an approved week — and the ERP has no path for it*](../payroll/gaps.md#a-labor-entry-edit-can-reprice-an-approved-week--and-the-erp-has-no-path-for-it)**
  stays **open**.
  - The gap asks: when an edit would reprice a processed, approved or closed week, does the ERP
    reopen it, post a delta, or refuse? And who may trigger that, in both the automatic and the
    manual case?
  - This ruling gives a delivery-side answer to the **automatic** case, for approved weeks inside an
    **open** period only. The automatic run never reprices them. If their figures would differ, it
    holds the period and names the employee.
  - The **manual** case is still the existing manual Calculate, which reopens approvals by clearing
    them.
  - Approved and exported periods are still refused or skipped, and there is still no retro-delta
    path. The policy owner is still TCG payroll (Brian Petros, Corrina Bustos for practice).
  - The gap's *Built state* line, *"Recalculation is manual-only and never fires on a ticket
    edit"*, has been out of date since 2026-10-06. It was not edited in this pass.
- **[2026-10-27-adp-re-export-of-a-sent-week-developer-direction.md](2026-10-27-adp-re-export-of-a-sent-week-developer-direction.md)**:
  consistent with it. That note says a re-export reproduces the frozen figures *"unless a later
  recalculation changed what the freeze carried (it does not)"*. This ruling keeps that true for
  automatic runs.
- **[aidlc/PAYROLL-WEEK-RECALC-APPROVE/spec.md](../../aidlc/PAYROLL-WEEK-RECALC-APPROVE/spec.md) §12**
  (provisional ticket):
  - **Q2 is not answered.** Q2 asks what a per-employee recalc endpoint does to an approved week.
  - **Q5 is touched.** Q5 asks about banners that point to a removed Recalculate control. The
    "Recalculate period" action now on the queue banner bears on it. Neither question is marked
    resolved by this note.

## What this does not decide

1. **Whether TCG accepts the ruling.** TCG has not ruled on whether an automatic run should leave
   approved weeks frozen, rather than, for example, reopening them. Corrina Bustos and Brian Petros
   can overrule it.
2. **The correction policy for approved and exported periods**, and for amended sent weeks. This is
   the open gap above, together with PAY-066 / PAY-068.
3. **Whether the 2026-09-24 manager confirmation releases** the outstanding job left by a changed
   approved week.

## Effect on the vault

- **No `status` changed anywhere.** No file is verified or superseded, and no other file's
  frontmatter was edited.
- **Done.** [payroll/INDEX.md](../payroll/INDEX.md) → *Decisions that bind this module*: one line
  added for this note.
- **Not done in this pass:**
  - `payroll/gaps.md`: another writer was active. A pointer to this note under the gap above, and a
    correction to its stale *Built state* line, are left for that file's next edit.
  - `payroll/payroll-rules-provenance.md`: being linked separately.

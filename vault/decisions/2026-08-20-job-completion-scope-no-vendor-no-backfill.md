---
title: Job completion scope — no vendor path and no historical backfill in SCRUM-903 — decision
source: decision/assignee
decided: 2026-08-20
decided_by: Fouzan Shakil (assignee, SCRUM-903) — authorised settling Q3/Q4 in the working session after Umair answered Q1/Q2, so the ticket can ship without inventing a second completion trigger or rewriting history
status: verified
resolves: aidlc/SCRUM-903/spec.md#q3, aidlc/SCRUM-903/spec.md#q4
jira: [SCRUM-903]
tags: [module/dispatch, module/projects-jobs, kind/decision, daily-allocation, yards]
entities: [Job, SubJob, SubJobLoadout]
---

# SCRUM-903 scope limits (vendor / backfill)

Companion to
`decisions/2026-08-20-job-completed-on-last-day-offload.md` (Umair — *when*
Completed). This note settles *what this ticket deliberately does not do*.

## Decision

1. **Q3 — Jobs that never go through yard loadout/offload** (e.g. vendor-covered,
   no yard ops): **OK that they do not auto-complete** under SCRUM-903. No second
   completion path is built here. Any vendor / no-yard completion rule needs its
   own ticket once product specifies the trigger.
2. **Q4 — Historical jobs** already finished in DAS/Yard but still showing Open:
   **fix going forward only.** No one-time backfill script or data rewrite in this
   PR. Stale Open badges on already-finished jobs are accepted debt until a
   follow-up chooses to backfill.

## Why

- SCRUM-903's QA symptom is "completed in DAS and Yard, still Open on Project →
  Jobs." The yard offload rollup answers that. Vendor-only jobs never hit that
  path; inventing a calendar-end or ticket-submit trigger for them would be a new
  product rule, not a fix.
- Backfilling `Job.status` on live tenants without an opt-in script risks marking
  the wrong jobs Completed (partial offloads, cancelled days, ON_HOLD). The same
  caution appears on `decisions/2026-08-20-quantity-based-das-sets.md` (default:
  do not rewrite history). Forward-only keeps this PR reversible and reviewable.

## Effect on the vault

- **No winner/loser flip.** No product file is superseded.
- `aidlc/SCRUM-903/spec.md` §12 Q3 and Q4 → resolved (see this note).

## What this does not settle

- What *should* complete a vendor-only / no-yard job when that work is specified.
- Whether a future backfill runs, its dry-run flags, tenant scope, or who opts in.
- Manual status changes via a Project Jobs UI (none exists today).

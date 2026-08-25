---
title: Completed Project Jobs are hard view-only — decision
source: decision/assignee
decided: 2026-08-25
decided_by: Fouzan Shakil (assignee, SCRUM-903) — Jira comment #23785 on SCRUM-903, settling Q5 raised by review of fix/reopened-qa-aug25
status: verified
resolves: aidlc/SCRUM-903/spec.md#q5
jira: [SCRUM-903]
tags: [module/projects-jobs, module/dispatch, kind/decision]
entities: [Job]
---

# Completed jobs are hard view-only (no unlock)

Companion to
`decisions/2026-08-20-job-completed-on-last-day-offload.md` (Umair — *when*
Completed). This note settles *what happens after* a parent Job reaches
`COMPLETED`.

## Decision

1. Once `Job.status === COMPLETED`, the job is **view-only across all Project →
   Jobs tabs** (Main / permit & plan quick-access, Schedule, Additional Info,
   Attachments, and any other editable job surface). Resources and Tool/Rigging
   were already permanently read-only.
2. Lock type is a **hard block** — UI disables edits; API rejects mutations with
   `BadRequestException` (`Completed jobs cannot be modified`).
3. **No unlock / correction path for now.** A job marked Completed in error
   stays frozen until a future product decision adds an unlock or reopen flow.
4. **`CANCELLED` and `INVOICED` are out of scope for now** — leave current
   editable behaviour; do not extend this lock to those statuses in this change.

## Why

QA (SCRUM-903 comment #23542, Aiman Farooq, 2026-08-24) asked for view-only
access once a job is completed. Review of `fix/reopened-qa-aug25` correctly
refused to treat that comment as product policy on its own (same rule as
`decisions/2026-08-20-archive-instead-of-delete-app-wide.md`). Fouzan settled
Q5 as assignee so the shipped lock is sourced.

`vault/projects-jobs/project-module/02-view-manage-job-details.md` (status:
`unverified`) still describes unconditional editability. This decision
**supersedes that page for Completed jobs only** — other statuses are unchanged.

## Effect on the vault

- **Winner for Completed jobs:** this decision.
- **Loser for Completed jobs:** unconditional editability in
  `02-view-manage-job-details.md` (unverified; not rewritten here).
- `aidlc/SCRUM-903/spec.md` §12 Q5 → resolved (see this note).

## What this does not settle

- Whether `CANCELLED` or `INVOICED` should also become view-only.
- Any future unlock / reopen path if a job is marked Completed in error.
- Manual Project → Jobs status editing (no UI/API added).

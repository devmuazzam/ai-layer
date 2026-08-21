---
title: Project Job becomes Completed on last-day yard offload — decision
source: decision/Umair Khan
decided: 2026-08-20
decided_by: Umair Khan — Jira comment on SCRUM-903 (2026-08-20T20:47 +0500), answering the ticket's open questions
status: verified
resolves: aidlc/SCRUM-903/spec.md#q1, aidlc/SCRUM-903/spec.md#q2
jira: [SCRUM-903]
topics: [projects, jobs, daily-allocation, yard-operations]
entities: [Job, SubJob, SubJobLoadout]
---

# Project Job status → Completed (not Closed)

Decided by **Umair Khan** on SCRUM-903. This file is **not** Confluence; it is a
named-human decision. Status on Project → Jobs is **`COMPLETED` / "Completed"** —
there is no "Closed" job status.

## Decision

1. **When Project → Jobs flips to Completed:** the parent Job becomes **Completed
   when work on its last scheduled day is done and the applicable return/offload
   process for that day is completed**. Field-ticket submission is **not** the sole
   (or required) completion trigger.
2. **Multi-day / multi-schedule jobs:** the parent Job stays **Open / Ongoing until
   the last scheduled day is completed**. It must **not** become Completed after the
   first day alone.

## Implementation reading (SCRUM-903 branch)

"Last scheduled day completed" is implemented as: every **non-cancelled** schedule
day (sub-job) has finished yard offload (`dasStage` COMPLETED / TICKET_SUBMITTED, or
loadout `phase` COMPLETED). The parent then moves `Job.status` ACTIVE → COMPLETED.
Cancelled days are ignored for the rollup.

## Why

QA (13-august-QA → SCRUM-903) reported that after completion in DAS and Yard
Operations, Project → Jobs still showed Open. The ticket clarified Completed vs
Closed; Umair settled *when* on the Jira thread so the rollup is not invented from
neighbouring code.

## Effect on the vault

- **No winner/loser flip.** No product vault file specifies parent Job completion
  after yard offload. Conflict-set closure does not apply.
- `aidlc/SCRUM-903/spec.md` §12 Q1 and Q2 → resolved (see this note).
- Q3 / Q4 → resolved separately in
  `decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md`.

## What this does not settle

- Covered by the scope-limits note: vendor/no-yard path and historical backfill.
- Wiring `dasStage` → `TICKET_SUBMITTED` when field tickets submit (out of scope;
  tickets are not the completion trigger).

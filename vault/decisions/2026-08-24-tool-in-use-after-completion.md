---
title: Tool detail In Use release after schedule-day completion — decision
source: decision/Fouzan Shakil
decided: 2026-08-24
decided_by: Fouzan Shakil (assignee) — accepted recommended answers on SCRUM-900 Jira comment 23302 (2026-08-24), proceeding Q1:B | Q2:C | Q3:B
status: verified
resolves: aidlc/SCRUM-900/spec.md#q1, aidlc/SCRUM-900/spec.md#q2, aidlc/SCRUM-900/spec.md#q3
jira: [SCRUM-900]
topics: [tools-rigging, jobs, yards, assets, dashboard]
entities: [tool-rigging, job, SubJob, SubJobLoadout]
---

# Tool & Rigging detail — In Use after job / day completion

Decided by **Fouzan Shakil** (SCRUM-900 assignee) by accepting the recommended
options posted on the ticket. This file is **not** Confluence; it is a named-human
decision for build.

## Decision

1. **Q1 — Release granularity: B (per schedule day).** Asset Management tool
   utilization must exclude assignments whose **schedule-day sub-job** is closed
   (`dasStage` COMPLETED / TICKET_SUBMITTED / CANCELLED, or loadout offload /
   force-complete / `phase` COMPLETED) — same boundary as Dylan's yard panel and
   as SCRUM-813 archive-block. Do **not** wait for parent `Job.status = COMPLETED`
   alone (that would keep day-1 tools "in use" on multi-day jobs until the whole
   job finishes).
2. **Q2 — Scope: C (detail page this ticket).** Ship the fix for the Tool &
   Rigging **detail** utilization API/UI. Dylan's panel already handles release
   client-side; leave it unchanged here. **Follow-up:** converge on one
   server-side utilization computation both surfaces consume (do not silently
   leave permanent duplication).
3. **Q3 — Past dates: B (historical).** For **past** queried dates, show what was
   assigned / in use that day (audit). For **today and future** dates, apply the
   Q1 live-release filter. Collapsing past dates to 0 after completion would make
   the date picker meaningless for history.

## Why

- Day-level completion is already the verified SCRUM-903 reading
  (`decisions/2026-08-20-job-completed-on-last-day-offload.md`) and matches
  `product/tool-and-rigging.md` Story 5 end-of-day return language (unverified)
  plus existing Dylan / archive-block code paths.
- Ticket text names only the detail page; expanding Dylan now is scope expansion.
- Past-date semantics were unspecified in vault/Jira; historical + live-today is
  the only reading that keeps the date picker useful.

## Effect on the vault

- **No winner/loser flip.** No product vault file previously specified detail-page
  utilization completion filters. Conflict-set closure does not apply.
- `aidlc/SCRUM-900/spec.md` §12 Q1, Q2, Q3 → resolved (see this note).

## What this does not settle

- Rewiring Dylan's panel to call the shared API (named follow-up only).
- Partial-offload quantity on the **detail** utilization endpoint (Dylan releases
  remaining not-offloaded qty; this decision adopts **closed-day exclusion** for
  the detail API — full assignment qty drops when the day is closed, not partial
  mid-day remaining, unless a later ticket asks for parity).
- Vendor / no-yard jobs that never close via offload (same as SCRUM-903 scope).

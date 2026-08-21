# PR review — SCRUM-903 job Completed on last-day yard offload

> Reviewed via `review-pr` skill. Platform PR:
> [craneguys-platform#384](https://github.com/TheCraneGuys/craneguys-platform/pull/384).
> Overlay PR: [tcg-ai-layer#20](https://github.com/devCodingcops/tcg-ai-layer/pull/20).

```
PR review: fix/SCRUM-903-job-completed-status → main   (5 files, ticket SCRUM-903)

LOOP TRAIL — .ai/aidlc/processed.log (local overlay, not yet synced with tcg-ai-layer#20)
  Entry found: 2026-08-20 SCRUM-903 Path B fouzan — "after DAS/yard offload complete, set
  Job.status=COMPLETED (not Closed)". Overlay PR #20 (still open, unmerged as of this review)
  fills in the full trail: aidlc/SCRUM-903/spec.md with §12 Q1–Q4, two named decisions, and an
  INDEX.md entry. Once #20 merges, `.ai/aidlc/SCRUM-903/` will exist on the platform repo's main
  and processed.log will carry the PR number — currently absent because #20 hasn't landed yet.
  Not a gap in this PR; sequencing dependency to flag before merging #384: land #20 first (or
  same day) so the vault entry exists when #384 merges.

PRODUCT — against the vault (via overlay PR #20, not yet merged)
  Sourced: Job.status flips ACTIVE→COMPLETED only on the last scheduled (non-cancelled) day's
    yard offload — decisions/2026-08-20-job-completed-on-last-day-offload.md — status: verified,
    decided by Umair Khan (named human, Jira comment 2026-08-20). Matches jobs.service.ts:141-192
    exactly: filters CANCELLED sub-jobs, requires every remaining one COMPLETED/TICKET_SUBMITTED
    or loadout.phase COMPLETED, only touches JobStatus.ACTIVE.
  Sourced: Vendor/no-yard jobs deliberately do not auto-complete under this ticket; no historical
    backfill — decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md — status:
    verified, decided by Fouzan Shakil (assignee, authorized to settle scope after Umair answered
    the "when" questions). Matches the diff: no vendor path added, `job.status !== ACTIVE` short
    circuits (forward-only), no migration/backfill script present.
  Sourced: "Completed", not "Closed", is the correct label — same decision doc, ¶1. Web change
    (job-stages.const.ts) adds a `COMPLETED` pill labeled "Completed"; consistent.
  No Unsourced/Conflicted/Contradicted items found — this is one of the few tickets in this repo
    where the product question was actually escalated and answered before code shipped, not
    inferred from neighbouring code.

CODE — most consequential first
  [VERIFIED] apps/api/src/usecase/jobs/jobs.service.ts:141 — `markCompletedIfAllSubJobsDone` —
    ran the new spec (`jobs-mark-completed.spec.ts`) against a live worktree build: 4/4 pass,
    covering all-done→COMPLETED, one-open→stays ACTIVE, non-ACTIVE-untouched, and loadout-phase-
    ahead-of-dasStage. `pnpm nx run @tcg/api:build --skip-nx-cache` and both lint targets ran
    clean (0 errors on api and web; only pre-existing unrelated warnings elsewhere).
  [VERIFIED] apps/api/src/orm/prisma.service.ts:123,131 — `job` and `subjob` are both in the
    tenant-scoping client-extension allowlist, so `prisma.job.findFirst`/`prisma.subJob.findMany`
    in the new method are tenant-scoped as long as they run inside `TenantContextService` context
    — confirmed they do, since the call chain originates from DAS loadout endpoints that already
    run under tenant context. No isolation gap.
  [INFERRED] apps/api/prisma/schema.prisma:1561-1579 — `JobStatus.COMPLETED` and
    `SubJobStage.COMPLETED`/`TICKET_SUBMITTED` already existed in the enums before this PR (read
    schema directly); no migration needed for the state values this PR now actually reaches.
  [INFERRED] apps/api/src/usecase/das-loadout/das-loadout.service.ts — four call sites gate the
    rollup on `loadout.phase === 'COMPLETED'` right after the operation that can produce that
    phase (full offload, same-day shift carry, cross-day defer, force-complete). Read each call
    site's surrounding logic; the gating subJobId matches the subJob whose loadout just
    transitioned in every case, so the rollup check is scoped to the day that actually finished,
    not a stale/wrong subJob.
  [INFERRED] apps/api/src/usecase/job-tickets/job-tickets.service.ts:211,270 — only other file
    setting `SubJobStage`, sets `TICKET_SENT` on an unrelated flow; no switch/exhaustiveness
    dependency on the newly-reachable `COMPLETED` dasStage value broke by this change.

Gates: pnpm nx run @tcg/api:build --skip-nx-cache → pass; pnpm nx run @tcg/api:test
  --testPathPatterns=jobs-mark-completed → 4/4 pass; pnpm nx run @tcg/web:typecheck → pass;
  pnpm nx run @tcg/api:lint --skip-nx-cache → 0 errors (2373 pre-existing warnings, none in
  changed files); pnpm nx run @tcg/web:lint --skip-nx-cache → 0 errors (5975 pre-existing
  warnings, none in changed files). (pre-existing failures excluded: 0, since only warnings)

Delegated: none needed — tcg-prisma-guardian not spawned (no schema change, isolation already
  verified directly via the allowlist check above); tcg-contract-tracer not spawned (no DTO/
  response-shape change — only an internal service method and one UI constants file); tcg-scrum
  not spawned (no Unsourced product questions found — SCRUM-903 already routed through Umair and
  the assignee via #20).

Verdict: ship with one follow-up — merge order. Land or merge overlay PR devCodingcops/tcg-ai-
  layer#20 before or alongside #384 so the vault decision docs and processed.log entry exist by
  the time #384 lands; right now the code and its product justification live in two unmerged PRs.

Follow-ups, out of scope for this PR (already explicitly deferred by the ticket's own decisions):
  - Vendor / no-yard-ops jobs never auto-complete — needs its own ticket once product defines
    that trigger (Q3).
  - No historical backfill for already-finished-but-still-Open jobs — forward-only by design (Q4).
  - `TICKET_SUBMITTED` dasStage wiring on field-ticket submit is not built; the rollup already
    treats it as "done" defensively but nothing sets it yet.
```

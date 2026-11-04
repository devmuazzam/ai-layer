# Implementation — APPROVED-TICKET-EDIT-PAYROLL-RECALC

Date: 2026-10-23. AI-DLC Path B. Plan authority: user requested implementing the existing plan from latest main in a new branch.

## Checkout

- Client base: freshly fetched `origin/main`, `a90658424`.
- Overlay base: freshly fetched `origin/main`, `5b68ebf`.
- Matching branches: `codex/fix-approved-ticket-edit-payroll-recalc`.
- Isolated worktree: `/home/codingcops/craneguys-platform/.worktrees/approved-ticket-edit-payroll-recalc`; primary checkout unchanged on main.
- Existing planning artifacts copied into the matching overlay worktree; Path B row appended to its `processed.log`.
- Origin publication authorized by the user on 2026-10-23; this record accompanies the implementation branch. No PR requested. No new tests, dependencies, schema or migrations.

## Delivered

1. `TicketEditRequestsService.completeForWorker` retains the resolved ticket and gates recalculation on COMPLETE + SUBMITTED_EDIT after its existing ownership, requester and live-window checks.
2. Rechecks the existing tenant-scoped payroll settlement lock, returning the existing TICKET_PAYROLL_LOCKED conflict if payroll settled after approval.
3. Awaits `PayrollCalcEnqueueService.enqueueForTicket(..., TICKET_COMPLETE)` before expiring the request. Insertion exceptions prevent intentional closure and reach mobile's existing save-error path.
4. Reuses the current pay-week resolution, period handling, queue coalescing and worker processing. LATE_COMPLETION still queues through normal first submission.
5. Registers the existing enqueue service and repository as bare providers, following JobTicketsModule and avoiding the PayrollModule dependency cycle.
6. Refreshes API/mobile comments and API operation documentation; mobile runtime sequencing and HTTP 204 are unchanged.
7. Adds only the new dependency mock argument to the existing service-spec fixture. No case added or extended.

## Validation commands and results

All Nx tasks ran through repository-pinned pnpm 10.30.2, in the implementation worktree except the explicitly noted primary artifact rebuilds.

| Check | Command | Result |
| --- | --- | --- |
| Existing API regression | `pnpm nx run @tcg/api:test --runInBand --runTestsByPath src/usecase/ticket-edit-requests/ticket-edit-requests.service.spec.ts src/usecase/job-tickets/job-tickets.service.spec.ts src/usecase/payroll/payroll-calc-enqueue.service.spec.ts src/service/payroll/payroll-calculation-queue.repository.spec.ts src/service/ticket-edit-requests/ticket-edit-requests.repository.expiry.spec.ts` | PASS — 5 suites, 141 tests. |
| Existing mobile wiring | `pnpm nx run @tcg/mobile:test --runInBand --testPathPattern=edit-wiring.test.tsx` | PASS — 1 suite, 9 tests. |
| Lint | `NODE_OPTIONS=--max-old-space-size=4096 pnpm nx run-many -t lint -p @tcg/api @tcg/mobile --parallel=1` | PASS — warnings only, no lint errors. |
| Mobile types | `pnpm nx run @tcg/mobile:typecheck` | PASS after linked shared-package output refresh. |
| Formatting | `pnpm exec prettier --check` with the six changed source/spec paths | PASS. |
| Diff whitespace | `git diff --check` | PASS. |
| API build | `NODE_OPTIONS=--max-old-space-size=4096 pnpm nx run @tcg/api:build` | PASS on the final rerun after refreshing linked package output. |
| API startup | `pnpm api:dev` attempted; then bounded `PORT=3107 pnpm nx run @tcg/api:start:prod` | BLOCKED — existing local config validation reports `AWS_REGION` required before DI initialization. |

A read-only local database connectivity check (`SELECT 1`) succeeded. No tenant fixture or user data was modified for that check.

Bootstrap linked package dependencies to the primary checkout. The primary sources for shared/payroll-engine matched current origin/main, but their dist outputs were stale. Primary `pnpm nx run @tcg/shared:build --skip-nx-cache` and `pnpm nx run @tcg/payroll-engine:build --skip-nx-cache` passed and refreshed those ignored outputs. The subsequent mobile typecheck and API build passed; initial missing-export failures were resolved setup failures.

Startup retries using the existing root/API environment files and process-only dummy AWS settings, with and without the Nx daemon, still reported missing AWS_REGION in the child API process. No environment file was changed; no credentials were invented for a persistent configuration. Further environment troubleshooting was kept outside this fix. Startup was bounded and no smoke-check server is left running. DI initialization and live-flow acceptance remain unverified.

## Manual/source checks and limitations

Reviewed the mobile success/error order: pending edits drain, completion is awaited, then caches/saved state update; errors enter the existing catch path. Confirmed approval, incomplete submission, resubmission and scheduler paths do not use the new completed-edit branch. Reused tenant filters and queue worker guards were inspected.

No full live mobile Save changes → queue persistence → recalculated payroll figures workflow was run. Existing automated suites provide sibling coverage but do not directly call the new completion branch; independent analysis therefore records ship with follow-ups. No claim of exactly-once finalization or cross-week correction handling.

## AI decisions and siblings

Plan D1–D6 were implemented without expansion. New scheduling is API-owned and awaited before closure; existing trigger and provider pattern are reused; settlement is rechecked. Cron/lazy expiry never schedules from this fix. First submit, late completion and approved resubmit remain unchanged. Mobile and direct endpoint callers gain the same behavior without a client contract change. No registered P1/P2 CRUD pattern applies.

Reflection/closure/publication remain after merge; no tooling instruction files were changed.

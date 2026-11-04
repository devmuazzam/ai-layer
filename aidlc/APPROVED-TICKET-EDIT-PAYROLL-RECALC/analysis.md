# Analysis — APPROVED-TICKET-EDIT-PAYROLL-RECALC

Date: 2026-10-23. Path B. Working ID only; no external Jira ticket supplied.

Independent reviewer: `approved_edit_analyst`, applying `tcg-analyst` to the worktree diff against the approved `plan.md` and `repro.md`. Reviewer changed no files. This report records that review plus validation results supplied by the executor.

## Verdict

**Ship with follow-ups; runtime release verification remains incomplete.** No must-fix source finding. The direct live mobile Save changes → persisted queue → request closure workflow has not been exercised; existing tests do not directly cover `completeForWorker`. API build passed. API startup was attempted but failed existing configuration validation (`AWS_REGION` required) before dependency initialization could be confirmed.

## Findings and scope

- **[INFERRED]** AC1–AC6 match the implementation: existing actor/request/window checks precede the COMPLETE/SUBMITTED_EDIT branch; settlement is rechecked; enqueue is awaited before expiry; insertion errors propagate.
- **[INFERRED]** Tenant boundaries remain intact: reused lock and enqueue calls pass `tenantCompanyId` explicitly. No schema, model, DTO, response shape or permission change.
- **[INFERRED]** DI follows JobTicketsModule's existing enqueue-only provider pattern. PrismaModule supplies the repository dependency; PayrollModule is not imported.
- **[INFERRED]** First submit, approved resubmit, LATE_COMPLETION, cron and lazy expiry are unchanged. Only completed submitted-edit finalization gains the new trigger.
- **[INFERRED]** Mobile continues to drain edits before the completion request and mark saved only after it succeeds. Its existing error path remains usable on insertion failure.
- **[VERIFIED]** `git diff --check` passed.
- **[VERIFIED]** `git diff --numstat` showed six changed files; the only spec edit adds constructor fixture wiring. No new test files or cases.
- **[VERIFIED]** No new 1,000-line source crossing. The mobile screen remains 1,550 lines; the API service is 427 lines.
- **[VERIFIED]** `rg -n 'completeForWorker|completeEditRequest' apps/api/src --glob '*.spec.ts'` found no direct coverage. Mobile edit-wiring coverage does not invoke the finalization handler. This is the review follow-up; do not add tests without developer authorization.

Scope is complete and contained by inspection. No unsourced structural decision, skipped guardrail, maintainability regression or missing sibling change was identified. Choices trace to plan D1–D6.

## Executor gate evidence

- Existing API suites: 5 passed, 141 tests passed. Ticket-edit-request lifecycle, JobTicketsService submission/resubmission, pay-week enqueue service, queue repository and request-expiry repository.
- Existing mobile edit-wiring suite: 1 passed, 9 tests passed.
- API and mobile lint: passed, warnings only.
- Mobile typecheck: passed after rebuilding stale linked shared-package output.
- Prettier check over all six changed files: passed.
- API build: passed after refreshing linked shared/payroll-engine artifacts. API startup: attempted through Nx, blocked by required local AWS configuration; DI boot is not verified.

The first API build/mobile typecheck encountered missing exports from stale primary-checkout package dist directories used by bootstrap's dependency symlinks. Primary package source matched origin/main; rebuilding shared/payroll-engine refreshed those ignored artifacts without source or dependency changes. The first mobile test invocation hit Nx shell quoting of a parenthesized path; rerunning the existing suite by `--testPathPattern=edit-wiring.test.tsx` passed.

## Known limits

Enqueue and closure remain separate operations; retries can cause another calculation after an earlier job starts. Existing queue coalescing handles pending triggers but is not exactly-once execution. The existing pay-week resolver does not invalidate a previous week when a ticket is moved between weeks. The settlement check at finalization cannot undo edits already saved earlier. These are recorded plan boundaries, not newly introduced findings.

Live customer/employee UI execution and end-to-end payroll figure changes remain unverified. At merge/release validation, use the disposable runtime reproduction, particularly insertion failure retaining the approval window and settlement refusal.

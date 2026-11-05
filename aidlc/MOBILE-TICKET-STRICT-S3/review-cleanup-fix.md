# PR #1049 — post-save cleanup correction

2026-11-06 · Path B · application base `9b8afbf11` · developer requested patch.

## Reproduction and cause

The independent PR review identified a valid P2: signature, lunch and checklist callers
save the replacement before invoking `cleanupReplaced`. Strict stale-key validation in
`deleteOrphaned` throws `BadRequestException`, but cleanup previously suppressed only
`ServiceUnavailableException`. The resulting request could report 400 after persisting a
replacement; checklist processing could stop before later answers and `markSubmitted`.
Earlier emulator replacement checks used structured old keys and missed this case.

## Correction and boundary

The shared `cleanupReplaced` catches the expected bad-request validation error in addition
to the existing storage-unavailable error, logs the stale attachment ID, and continues.
Rejected stale rows and objects remain untouched. Direct reads/deletes still reject invalid
keys before S3 access. Valid structured cleanup still deletes both variants; unexpected
errors still propagate. This applies to all four existing call sites across signature,
lunch and checklist services. Decision: spec.md §11b D7. No schema, dependency, response
shape, legacy signing/deletion fallback or data backfill was added.

## Verification

Executor temporary runtime reproduction: `node /tmp/tcg-stale-cleanup-smoke.cjs before` reproduced
the escaped bad request and stopped continuation before the patch.
`node /tmp/tcg-stale-cleanup-smoke.cjs after` passed after the patch, independently rerun by the
coordinator: continuation succeeds, rejected stale rows/objects are untouched, one warning
is emitted, direct deletion still rejects, structured deletion removes both keys, storage
unavailability remains nonfatal, and unexpected errors propagate.

This smoke runs the actual source guard with the compiled key validator and mocked
repository/storage. It performs no database or S3 mutation and is not an endpoint or
emulator reproduction. No new repository test case/file was added, per the standing rule.
Six selected existing API suites passed with Nx cache disabled: attachment guard, ticket
signatures, lunch breaks, returned-lunch correction, ticket attachments and checklist
assignments. Shared/payroll prerequisite builds passed. Log:
`/tmp/tcg-stale-cleanup-targeted-tests.log`.

Independent Path B analyst: PASS, no actionable defect. The analyst independently reran the
after-patch runtime smoke and checked direct strict deletion, all post-save callers, D7,
unexpected-error propagation and `git diff --check`. The reviewer did not independently
reproduce the pre-patch failure. Earlier emulator evidence remains in
emulator-validation.md; it does not cover this newly reproduced stale-key case.

The default PATH contained pnpm 12.8.1, whose automatic switch to the requested package
manager stalled before Nx. Verification uses the already installed pnpm 10.30.2 and Node
22.22.0 via a command-local PATH, with no dependency/configuration changes.

Fresh full API verification, Nx cache disabled:

- API build and lint passed (`/tmp/tcg-stale-cleanup-gates.log`).
- Full API test suite passed: 328 suites / 3,845 tests, zero failures, serial run with
  temporary local-port access allowed. Logs:
  `/tmp/tcg-stale-cleanup-api-tests-unsandboxed.log` and
  `/tmp/tcg-stale-cleanup-results-unsandboxed.json`.
- Earlier sandboxed full runs failed. The structured report identified 31 failures in six
  HTTP suites, all due to `listen EPERM` when opening local ports; 322 suites / 3,814 tests
  passed there. The successful unsandboxed rerun supersedes these environment failures.
- Application and overlay `git diff --check` passed. Web/mobile source is unchanged in this
  correction; their earlier gate results remain historical, not newly rerun here.

## Publication

The developer requested committing and pushing both repositories on 2026-11-06. Application
commit `1e4e375b52a3d1997f060e740f6c478d25357e87`
(`fix(api): keep rejected stale cleanup from failing replacements`) is published on
`origin/fix/strict-ticket-presigned-attachments`. Normal pre-commit ESLint/Prettier passed
and left the reviewed source patch unchanged. The configured human author and committer
were retained. Both remotes were fetched: the app includes current staging and this overlay
includes current main; neither matching task branch had diverged. Existing stashes were
left untouched.

The matching overlay publication contains D7, the current state and this correction record.
Pushes use the developer's previously authorized `SKIP_GATES=1` while retaining the branch
guard; the fresh validation above is recorded separately. No merge, deployment or closure
is claimed. Historical office/admin manual checks remain as recorded in emulator-validation.md.

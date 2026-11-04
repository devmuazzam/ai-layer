# Publication checks — 2026-11-03

Code commit: 1d439ae58. User requested commit and push. Pre-commit hooks passed and both repository worktrees are clean before publication-status updates.

## Full pre-push results

- Lint: all four affected projects passed (web excluded by the repository gate).
- Typecheck: mobile and web passed.
- Shared/payroll tests passed; the full API target passed all 294 suites / 3,432 tests.
- The full mobile target reported 11 failing suites, 20 failing tests, 3,167 passing tests. These failures occur outside the only modified mobile file (the certification HTTP adapter).
- Baseline checks on unchanged staging reproduced the same background-sync argument assertion (28 passed / 1 failed) and a completed-ticket dispatcher assertion (10 passed / 1 failed). Only these deterministic baseline failures were individually rerun; the other full-suite failures are not all independently reproduced.
- Web tests initially failed because Git's hook-exported GIT_DIR made a package-local git rev-parse resolve apps/web as the worktree root. The guard script itself already changes to git's reported root. Repeating the target with GIT_WORK_TREE explicitly set to the actual checkout fixed this environment issue without source changes: all 1,020 web tests passed.
- The hook stopped at test failure, so its final build stage did not run. The implementation's final API build had already passed separately.

## Approved publication

The initial code push was rejected by the pre-push hook and published no branch. After the gate results and unchanged-staging reproductions were reported, the requester explicitly replied “yes” to the one-time SKIP_GATES=1 exception on 2026-11-03.

The approved retry used SKIP_GATES=1 and an explicit GIT_WORK_TREE. It successfully published code commit 1d439ae58cfb2b7cccc203c563e4e42e7fe9376d to origin/codex/attachment-metadata-consistency. The hook reported that lint, typecheck, test and build were skipped for that retry; the earlier results above remain the verification evidence. No tests were changed to bypass these failures.

The matching AI-DLC overlay branch carries this approval and verification record. Both remote branch hashes are checked at handoff. No PR, merge or deployment was requested.

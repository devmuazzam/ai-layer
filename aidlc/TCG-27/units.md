# TCG-27 — execution units

## Squashed delivery and ticket update — 2026-10-13

Requester explicitly authorized editing the last TCG-27 comment and squashing the five commits on `fix/TCG-27-sms-reset-recovery` into one. The branch was soft-reset to its existing base `6f6f1a8c9`, consolidated as `90bf999e0`, and pushed using an explicit force-with-lease against verified prior remote head `2914386af`. Exactly one commit remains above the base. Pre- and post-squash tree IDs match (`398af29be11317524751e4bbb1e2641e4c0ebdde`); no source behavior changed during the squash. Pre-commit ESLint/Prettier and diff checks passed. The previous history is preserved locally in `/tmp/tcg27-before-squash.bundle`.

Existing Linear comment `2e1b4912-ff39-43b5-860f-57482e4a0e99` was edited in place to record SMS recovery only, automatic sign-in, deferred session invalidation pending future client feedback, the consolidated branch/commit, and pending validation. The original email-link acceptance remains deferred. No new comment, issue-description change or status change was made. Tests, builds, typechecking, device/SMS QA and deployment remain unrun. These separate AI DLC records remain local.

The single commit above supersedes earlier commit hashes below for current delivery; previous entries are historical.

## Single delivery branch — 2026-10-13

Requester asked for a single branch with the remaining work. Consolidated application branch: `fix/TCG-27-sms-reset-recovery`, pushed to origin at `2914386af`. Existing U1 commit `663035119` remains; the latest commit removes U2 and notification session-version follow-ups. The net behavior change versus origin/main is the mobile SMS reset recovery work and its authored tests; required commit hooks also formatted imports/test layout in four restored API files. No sessionVersion field, migration or token validation remains in the current source.

Pre-commit ESLint/Prettier passed; branch diff check passed and the source checkout is clean after push. Builds, tests, typechecking and device/SMS QA remain unrun. These AI DLC scope records remain local in the separate `.ai` repository and were not published as a second branch. Earlier local/uncommitted statements below are historical.

## Current scope — requester deferral, 2026-10-13

The requester stated: “so we do not need to invaludate the sessions on reset passwords. we ill implement this on clinet feedback in future”. This supersedes the October 12 selection of immediate previous-session invalidation and sessionVersion. Session invalidation is deferred pending future client feedback; it is not part of current TCG-27 acceptance. This is requester direction, not client-meeting confirmation.

Current delivery is U1 only: actionable SMS reset errors, a restart that clears abandoned recovery state, existing retry/resend, and automatic sign-in after successful reset. Email/combined recovery and app links remain deferred to separate work. Existing account-status checks and baseline credential handling are retained.

The current source checkout `fix/TCG-27-sms-reset-recovery` originally included U1 plus U2 and notification session-version follow-ups. Those session-version changes have been removed locally, including the schema field/migration, JWT version claim, access/refresh checks, guarded version writes, notification version checks and their focused tests. U1 source and its authored regression cases remain. This does not remove baseline refresh-token handling or guarantee that existing sessions survive every reset.

Remaining: review/commit the scope-removal diff, update the PR/ticket scope when authorized, run U1 regression/type checks when permitted, perform real-device/SMS QA (happy path, incorrect/expired/used code or capability, retry/resend/cooldown, restart cleanup and activation regression), then merge/deploy through the normal workflow. No sessionVersion migration is needed for this revised change. Builds, tests, typechecking, database changes, commits, pushes and external edits were not performed during this scope revision.

Historical decisions, implementation and reviews below describe the previous scope and do not reinstate U2.

Scope selected in session on 2026-10-12: phone/SMS recovery only, automatic sign-in preserved, clearer failure recovery, immediate rejection of previous sessions using sessionVersion. Revoked-account safeguards and email/combined identity work are excluded. U1/U2 source implementation and an additive U2 migration are authored in isolated worktrees; no migration has been run. See implementation.md for results.

| Unit | Outcome | Scope | Dependencies | Proposed branch |
| --- | --- | --- | --- | --- |
| U1 | Expired/invalid SMS recovery shows a useful server message and offers a restart | Existing verify-code/set-password screens, existing session error and auth flow store, focused regression cases | Requester-authorized failure recovery outcome | fix/TCG-27-u1-reset-errors |
| U2 | Successful SMS reset immediately rejects old access/refresh credentials while the resetting device stays signed in | User.sessionVersion plus migration, shared token claim, existing token issuance/access/refresh validation and atomic reset write, focused regression cases | Requester-selected sessionVersion; contract tracer and Prisma guardian review before code | fix/TCG-27-u2-reset-session-logout |

## U1

Reuse existing components/hooks/services; no new exported helper, endpoint or dependency. Maintain automatic sign-in and current temporary-password activation. Distinguish restart-worthy failures from retryable network errors using existing server error information; clear abandoned reset-flow state before restarting. Check missing/expired/used capability and failed OTP behavior. Do not run tests/builds/typechecking under the existing user constraint.

## U2

Selected structure: non-null User.sessionVersion integer default 0, mapped session_version. Carry account version in newly issued access/refresh tokens; legacy tokens lacking a version count as version 0. Atomically increment with the SMS password reset, revoke old refresh credentials, then issue the resetting device's new session. Reject mismatched versions on protected API access and token refresh. Ordinary sign-in must not increment the version.

Review all existing shared token minting callers, including web/SSO, so a new session after an SMS reset gets the current version. Existing email recovery behavior is otherwise unchanged. Review concurrent reset/sign-in/refresh so an operation authenticated before reset cannot acquire the new version or overwrite the fresh session's refresh hash. Contract tracer and Prisma guardian report before implementation; no database execution/deployment authorization is implied.

Migration must ship with code; do not run it against a DB in this task. Reuse/extend existing exports under the selected design. Any further new exported helper, schema field or dependency requires a separate developer structure choice.

## Delivery and validation

Independent units, each one branch/PR below ~400 changed source lines / 25 source files. No need to stack U2 on U1 unless execution uncovers a real dependency. Log each branch at creation, not during this plan-only record update. Obtain independent analyst review; document skipped runtime gates honestly. No claim of client-meeting approval, deployment or completed validation. Named requester attribution remains unprovided.

## Execution locations

- U1: `/tmp/tcg27-u1`; matching overlay `/tmp/tcg27-ai-u1`. Source/test commit `68409a35c`; commit lint/format hooks passed.
- U2: `/tmp/tcg27-u2`; matching overlay `/tmp/tcg27-ai-u2`. Source/test/migration commit `68f76c970`; commit lint/format hooks passed.
- Static source budgets U1 46 lines / 2 files; U2 166 lines / 10 files after commit-hook import formatting. No combined implementation branch or PR created.

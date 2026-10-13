# TCG-27 — phone/SMS AI DLC plan

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

Path A. Inception scope updated by requester on 2026-10-12: phone/SMS only, automatic sign-in preserved. Email and combined identity flows belong to another developer’s unmerged branch. Requester authorized work on reset errors and other-device logout, and selected immediate invalidation. The requester subsequently selected the concrete sessionVersion approach. Contract/schema review remains required before implementation.

## Remaining work

1. Preserve existing phone → code → set-password → signed-in flow, per requester. Do not add email routes, deep-link claims, company selectors, success-to-login navigation, or modify temporary-password activation.
2. Revoked-account safeguards are explicitly excluded by the requester. Preserve existing account access checks; do not implement the earlier proposed status/atomicity slice.
3. Candidate U1: actionable invalid/used/expired SMS recovery state using existing screens/error codes, with a start-over action; preserve successful automatic sign-in. Reuse existing screen primitives, server failure messages and recovery routing; check shared activation behavior during implementation. Branch separately if independent; enforce ~400 changed source lines/25 files per unit.
4. Session revocation: SMS already clears old refresh credentials and issues a new current session. Requester requires immediate rejection of previous access tokens too, while the resetting device stays signed in. Candidate U2 must implement that distinction. Use the requester-selected User.sessionVersion integer default 0 and version claim, with an atomic reset increment, version checks on access/refresh and legacy version-0 treatment. Contract tracer/Prisma guardian review the migration, all minting paths and reset/refresh races before implementation.
5. Record coordination boundary: ACTIVE email reset's retained refresh hash, duplicate-email fallback lookup, email throttling and app-link requirements remain review findings for the other work. No assumption they are fixed on the uninspected branch. Existing non-+1 fallback remains unchanged unless separately decided.
6. Once decisions are recorded, create matching client/overlay branches from origin/main for the approved unit and append processed.log. Execute only that unit, obtain independent analyst review, and record actual checks. Source implementation is now complete in isolated U1/U2 worktrees; committed as U1 `68409a35c` and U2 `68f76c970`; publication authorized for both matching client/overlay branches.
7. When validation is authorized, demonstrate the SMS happy path, incorrect/exhausted/expired codes, replayed password-set token, account ambiguity, resend/cooldown, old refresh/access behavior and shared activation regressions. Verify real SMS delivery; do not declare readiness from static review.

## Resolved versus pending

Resolved: SMS-only scope; automatic sign-in. Resolved: immediate previous-session logout; revoked-account safeguards excluded. Resolved: sessionVersion approach. Pending: contract/schema review, named attribution and actual delivery/runtime validation. Email identity and app-link work are deferred, not blockers for a bounded approved SMS unit.

Planning snapshot above preceded execution. U1 and U2 source changes are now implemented in isolated worktrees; no Linear description/comment changes, builds, tests, typechecking or DB writes performed. Source commits and commit lint/format hooks are complete; publication is authorized for both matching client/overlay branches. See implementation.md for the actual handoff.

## Implementation readiness

The user has authorized the two remaining outcomes: clearer reset failure recovery and immediate logout of previous sessions. Revoked-account safeguards are excluded. The requester selected the concrete User.sessionVersion/token-claim proposal on 2026-10-12. units.md records the two execution slices. Next, review contracts/schema and implement each on isolated matching branches. Existing-email work remains deferred.

## Execution handoff — 2026-10-12

U1 implemented at `/tmp/tcg27-u1` on `fix/TCG-27-u1-reset-errors`; U2 implemented at `/tmp/tcg27-u2` on `fix/TCG-27-u2-reset-session-logout`. Both branch from current origin/main c3eba1030 and have matching isolated overlay worktrees. Schema guardian, contract tracer and independent analyst found no remaining static blocker after restart-routing and stale-logout fixes. Source budgets: U1 46 lines / 2 files; U2 166 lines / 10 files after commit-hook import formatting, excluding tests/migration. Application changes committed: U1 `68409a35c`; U2 `68f76c970`. Both commit lint/format hooks passed. Validation/demo remain pending; no ready-to-deploy or shipped claim.

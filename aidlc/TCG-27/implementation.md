# TCG-27 implementation handoff — 2026-10-12

## Documentation publication snapshot — 2026-10-13

Requester authorized a new branch in the separate `.ai` repository and committing/pushing its changes. Publication branch: `docs/TCG-27-pr-771-review`, based on overlay `origin/main`. It packages the current TCG-27 records and historical reviews together with the static review of application PR [#771](https://github.com/TheCraneGuys/craneguys-platform/pull/771), application head `90bf999e0`. The processed ledger links that application PR and records U1-only SMS recovery; U2 session invalidation and email/app-link recovery remain deferred. Historical PR #764 reviews are snapshots of earlier code, not verdicts against #771.

The PR #771 static verdict is ship with follow-ups: focused routing/activation message coverage and publication of the updated scope record. This documentation publication addresses the record-publication follow-up once pushed; it does not implement or run the missing regression assertions. No tests, builds, typechecking, application changes, merge or deployment are part of this publication. Earlier statements about unpublished/local records below describe their state at those checkpoints.

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

Implementation base: origin/main c3eba1030. Requester authorized committing and pushing both unit branches and matching AI DLC records on 2026-10-12. Source commits: U1 `68409a35c`; U2 `68f76c970`. Matching client/overlay branches are included in the authorized push handoff; no PR or deployment requested/performed. The main application checkout is untouched. Isolated source worktrees: `/tmp/tcg27-u1` (`fix/TCG-27-u1-reset-errors`) and `/tmp/tcg27-u2` (`fix/TCG-27-u2-reset-session-logout`). Matching overlay worktrees: `/tmp/tcg27-ai-u1`, `/tmp/tcg27-ai-u2`.

## Delivered

U1 extends existing verify-code/set-password screens. Failed password setting displays the existing session/API error message rather than always generic copy. Reset errors expose a restart action that clears abandoned flow tokens and routes to phone recovery. Missing reset capability routes to recovery; temporary-password activation keeps its login fallback. An explicit restart guard prevents clearing the flow from triggering a competing redirect to login. Success still establishes the session automatically. Existing retry and resend controls remain usable for recoverable errors; no new failure threshold or export.

U2 adds User.sessionVersion Int default 0 with additive migration and an optional shared JWT claim. Existing issuance paths carry the authenticated account snapshot; access and refresh validation reject malformed/old versions. Missing legacy claim is version 0. Both refresh controllers forward token version. Field password setting atomically matches the verified credential/version snapshot, writes the password, increments version and clears old credentials; it then issues the resetting device's new-version session. Conditional refresh-hash writes reject stale sign-in/refresh operations. Version-guarded logout treats a stale session as already logged out, preventing it from deleting the resetting device's fresh refresh hash. No ordinary login increments the version.

The same field password/set path handles activation, so it receives the same snapshot/replay protection and session boundary without changing visible activation behavior. The optional repository credential snapshot leaves deferred email completion behavior unchanged. Existing revoked-account checks are unchanged; no new revoked-account safeguard, email route, app-link claim, OTP threshold or dependency was added.

## Evidence and independent analysis

- VERIFIED: `git diff --check` passed in both source worktrees. All changed/new TypeScript files formatted with the repository Prettier binary.
- VERIFIED: source diff budget U1 46 lines / 2 files; U2 166 lines / 10 files after commit-hook import formatting, excluding tests and migration. No source file crossed 1,000 lines.
- INFERRED: contract tracer found no remaining additive-token consumer blocker after the guarded logout correction. Web synthetic JwtPayload remains compatible because sessionVersion is optional; token response envelopes are unchanged.
- INFERRED: schema guardian found no remaining static schema/isolation blocker. Existing User tenant allowlist and resolved UUID writes are preserved; conditional updates establish the reset boundary.
- INFERRED: independent analyst found no remaining static blocker after the restart-routing fix. Both maintainability rubrics applied. Real database races/runtime demonstration remain unverified.
- Regression cases authored for server errors/restart cleanup/final navigation, legacy zero/current/stale access and refresh tokens, malformed versions, guarded hash write failure, reset capability race rejection, and stale logout. Tests have NOT been run.
- VERIFIED: required pre-commit ESLint and Prettier hooks passed for both units; post-commit diff checks passed. Hook changes are local import/format adjustments in touched files.
- NOT RUN: builds, tests, typechecking, Prisma generation or database migration. The user's validation constraint is preserved. No passing runtime/gate claim.

## Deployment and validation limits

The additive migration must be applied before version-aware API code, and Prisma client/shared package artifacts regenerated/built by the normal deployment workflow. These steps were not executed. All API instances must perform version validation; a mixed fleet with old validators cannot guarantee immediate logout. Rejected old sessions apply to subsequent authenticated server requests; an offline device's local display and already-running requests cannot be canceled retroactively.

After runtime checks are authorized, demonstrate actual password reset → old-token rejection → fresh-device acceptance, replay/concurrent reset, delayed sign-in/refresh/logout, real SMS delivery, and activation regressions. Current regression cases simulate CAS failures; they do not prove concurrent PostgreSQL behavior. Existing same-version concurrent refresh behavior remains outside this unit.

## Disposition

Source implementation and static independent analysis complete. Tests/demo, database deployment and ticket closure pending. No Linear changes. This is requester authorization, not fabricated client-meeting approval or named human attribution.

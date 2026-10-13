# TCG-27 — intent snapshot

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

Captured 2026-10-12 from Linear issue TCG-27 and its technical comment. Status: In Progress. Assignee: abdulmuazzam@codingcops.org. Parent: TCG-5. Related: TCG-82 (Done). Sources are ticket intent, not a verified production diagnosis.

Ticket: https://linear.app/the-crane-guys/issue/TCG-27/mobile-app-password-reset-cannot-be-finished-in-the-app

## Business intent

Field workers should recover their password on the phone without depending on knowledge of a work email address or leaving the app. The ticket explicitly requires app completion through an emailed link and browser fallback. Recovery identifier/company/shared-device policy is explicitly unresolved.

## Definition of done — ticket description verbatim

- Tapping the reset link on a phone opens the app's reset screen.
- A new password can be set and used to log in.

## Required behavior — ticket description

- The reset link opens an in-app Reset Password screen.
- Valid, invalid/used, expired and success states; success returns to login.
- Without the app, or on a computer, the same link opens the web page.
- Reset logs out all old sessions.

The technical comment additionally requires tenant-aware case-insensitive email lookup, per-identifier request throttling/cooldown, genuine iOS/Android link verification, and mobile recovery using its sign-in identifier. Those criteria are retained unless explicitly revised by the requester.

## Existing-code discrepancy

The original report says mobile collects email and has no completion screen. Current main already collects phone and implements SMS verification plus set-password. This observation does not ratify that flow or remove the email-link acceptance criteria. See review.md for evidence.

## AI DLC entry

Path A: new in-app email-link behavior and unresolved recovery identity, success behavior, company selection and session-revocation meaning. Review/inception only; no application edits, commits, push or ticket changes requested here. No builds/tests/typechecking run.

## Scope boundaries

Do not reopen TCG-82's resolved pending-invite behavior: the 2026-09-25 reference decision allows a completed reset to activate a pending invitation. Do not treat that CodingCops ruling as TCG sign-off on field identity policy. Password character reveal belongs to TCG-34. No credential/database writes or deployment configuration changes during review.

## Scope update — requester answers, 2026-10-12

The requester chose to stick with phone/SMS recovery for now. Another developer is implementing combined email and phone/SMS login/signup/password recovery on an unmerged branch. That branch and developer were not identified or inspected; this is the requester’s coordination context, not a verified inventory of its changes.

The requester also chose to keep existing completion behavior: automatic sign-in after SMS reset. The original email-link and success-to-login criteria above remain a historical ticket snapshot, not the current implementation scope. No Linear description change or comment is authorized by these answers.

Current scope: assess and plan reliability/security of the existing phone/SMS reset. Email routes, email lookup/rate-limit changes, browser fallback, app-link claims and signing provisioning are deferred to the other work. Existing non-+1 phone email fallback remains a known boundary; do not remove or change it without a separate decision. These answers do not approve structural changes or immediate access-token revocation semantics.

## Requester scope and session decision — 2026-10-12

The requester excluded revoked-account safeguards from TCG-27 and authorized work on reset failure recovery and other-device logout. Previous sessions must lose access immediately after successful phone/SMS reset; the resetting device keeps its new session. This does not remove existing revoked-account checks or globally adjudicate the historical finding. New schema/token contract choices remain subject to developer structural approval.

## Session invalidation design selection — 2026-10-12

Requester selected sessionVersion after comparing it with a reset timestamp. Record this as requester authorization, not client-meeting approval. It covers the proposed integer default 0 and token version checks/increment; no named human attribution is fabricated.

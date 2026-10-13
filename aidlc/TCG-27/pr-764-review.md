# PR #764 — AI DLC review

Reviewed 2026-10-12. **Verdict: do not ship — prior sessions retain notification WebSocket access after SMS reset.**

PR: https://github.com/TheCraneGuys/craneguys-platform/pull/764
Branch: `fix/TCG-27-sms-reset-recovery`; checked out detached at `3c7b3af323b51f0dbc0726c147d56d00502f6754`.
Base: `c3eba103084d5fc1b78de50c4007568817d42390`, established from the fetched PR merge ref's first parent; equals local `origin/main`.
19 changed files; ticket TCG-27; units U1 and U2.

Static review only. No tests, builds, typechecking, Prisma generation, database access, or application edits. Existing review.md is preserved. The GitHub CLI is absent and unauthenticated GitHub metadata was unavailable, so the PR description/labels were not inspected. Matching remote AI overlay records were inspected with `git -C .ai show origin/fix/TCG-27-sms-reset-recovery:...`.

## CODE — consequential findings

1. **[P1] [INFERRED] Apply reset-session invalidation to notification sockets.**

   Changed lines `apps/api/src/strategy/access-token.strategy.ts:39–41` reject old versions only through the HTTP Passport strategy. The independent validator in `apps/api/src/usecase/notifications/notifications-ws-auth.service.ts:29–37` checks the JWT signature/expiry and account status, but never its session version. After a successful SMS reset moves an account from version 0 to 1, a still-unexpired version-0 access token can reconnect to `/notifications`. `apps/api/src/presentation/notifications/notifications.gateway.ts:38–49` accepts that result and joins the user's room; lines 80–88 send full notification payloads to it. Already-connected sockets also lack version revalidation or reset-triggered disconnection.

   This leaves spec REQ-04 and U2's immediate previous-session invalidation incomplete. Apply the same legacy-zero/current-version rule to socket authentication and revoke or revalidate existing sockets at the reset boundary, while preserving the new session. Add regression cases for both stale reconnect and a socket connected before reset.

   **Refutation:** the gateway invokes the separate validator directly, so the changed HTTP strategy cannot protect it. The web socket factory sends auth cookies (`apps/web/src/lib/socket/create-socket.ts:40–43`); frontend disconnect on eventual HTTP auth failure does not prevent direct stale-token reconnection. This is incomplete delivery of the new reset requirement, rather than a claim that this PR introduced the separate validator. No exploit or runtime reproduction was executed.

## SIZE / LOOP TRAIL / TOOLING

- **[VERIFIED]** 212 changed source lines in 12 source files, excluding tests and migration: within the 400-line/25-file budget. Established with `git diff --numstat origin/pr-764-merge^1...HEAD` and the review skill's exclusion filter.
- **[VERIFIED]** The matching remote overlay's `aidlc/processed.log` has Path A records for TCG-27, including the combined branch. The local overlay main log lacks those rows; the records are on the matching branch. GitHub merge status was unavailable, so a missed close-ticket step is not established. Consolidate overlay records when closing the ticket.
- **[VERIFIED]** The matching remote units.md explicitly records requester authorization to combine U1/U2 as two commits on 2026-10-12. Do not flag the earlier separate-unit delivery plan as an unresolved split requirement.
- Tooling paths are untouched by the application diff.

## DECISIONS / PATTERN / SIBLINGS

- Selected structure: non-null integer User.sessionVersion, default zero, atomic field password increment, optional JWT claim with legacy-zero interpretation, guarded snapshot writes. Source: TCG-27 spec.md, “Decision recorded,” and REQ-04; requester authorization, not fabricated client approval. Human-name attribution remains unprovided in the record.
- Existing mobile screens, flow store, session error state, repository/service, and token envelopes are reused. No new endpoint, dependency, exported helper, or component.
- API/mobile/Prisma conventions were read; P1/P2 CRUD registry entries do not govern this auth change. No applicable pattern deviation identified.
- Email recovery is explicitly deferred. Shared temporary-password activation is acknowledged in the unit and implementation records. Notification socket validation is the missed sibling/consumer and belongs in this PR's required behavior, not an unrelated cleanup.

## PRODUCT

- **Sourced:** actionable SMS failures/restart, automatic sign-in, immediate old-session rejection, and legacy compatibility trace to TCG-27 spec REQ-02/04/05/09 and the recorded requester selection.
- **Reference:** vault/decisions/2026-09-25-password-reset-accepts-a-pending-invitation.md records the pending-invite behavior; status `reference`, CodingCops decision rather than client sign-off.
- **Unverified:** vault/admin/responsive-design-and-security-posture.md describes existing authentication/security posture; it does not approve this session counter.
- **Conflicted background:** field-ops/field-ops-mobile-INDEX.md names all three candidates: field-ops-frd/INDEX.md, frd-new-format-draft/INDEX.md, and atom-mobile-app-user-stories/INDEX.md. All remain unverified; none is chosen as authority over the explicit ticket scope.
- No new unsourced product decision found within the reviewed scope. Existing email and revoked-account findings remain excluded/deferred as recorded; they are not repeated as new PR defects.

## RIPPLE / COVERAGE

Consumer enumeration used `rg -n 'JwtPayload|issueTokensForUser|updateHashedRefreshToken|completePasswordSet|refreshTokens\(' apps/api/src apps/web/src apps/mobile packages/shared/src`, plus `rg -n 'jwt\.verify|jwtService\.verify|verifyAsync|authenticateHandshake|handleConnection|@WebSocketGateway' apps/api/src` and route/response-field searches by the contract tracer.

- **[INFERRED]** Signup, email/phone password sign-in, field completion, Microsoft callback, invitation acceptance, and both refresh endpoints carry the current authenticated snapshot. Logout and refresh-hash writes preserve the reset version boundary. These consumers are intended by spec's “Ripple to review before execution.”
- **[INFERRED]** Web auth decoding/provider and mobile HTTP/store/token storage remain compatible with unchanged token envelopes and the additive optional claim.
- **[VERIFIED]** Auth/session-version.spec.ts, strategy/access-token.strategy.spec.ts, service/users/users.session-version.spec.ts, field-credentials.service.spec.ts, and the mobile screen tests contain focused cases for version validation, mocked races, reset completion, and restart. None was executed.
- **[INFERRED]** Coverage is partial: no socket version/reset regression case was found, and signup/SSO/invitation producer coverage does not assert the new claim end to end. Mocked conditional-write failures do not establish PostgreSQL concurrency behavior. These coverage gaps require later validation; socket behavior is already the blocker above.

## MAINTAINABILITY / SPECIALIST VERDICTS

- **[VERIFIED]** No source file crosses from at most 1,000 lines to above 1,000. Established by comparing `git show origin/pr-764-merge^1:<file> | wc -l` with current file lengths for changed source files.
- Thermo-nuclear: no additional structural regression found in the new code. The HTTP/socket policy divergence is captured in finding 1.
- Ponytail: finding 1 is the must-fix safety/correctness issue. No separate concrete delete/reuse/stdlib/yagni finding survives review. Existing concurrency/storage design outside the changed reset boundary is not expanded into this PR.
- Prisma guardian: no new static schema/isolation defect found. Committed additive migration matches the selected field; User remains tenant-allowlisted. Conditional reset writes match UUID, version, and credential hashes and update password/version/hash atomically. Runtime behavior remains unverified.
- Contract tracer: token producers and response consumers are compatible; notification socket validation misses the reset boundary.

## GATES / HANDOFF

`git diff --check origin/pr-764-merge^1...HEAD` passed. Tests, builds and typechecking were deliberately not run. No lint or database migration was run in this review. Application worktree is unchanged.

Fix finding 1 before merge. Later authorized validation should exercise real SMS delivery, PostgreSQL races, and fresh/stale HTTP and socket sessions. Deployment must apply the additive migration before the version-aware API and update all API instances; this review performs no deployment.

Least confident about: device navigation and real database interleavings, because this was source review only.

If this breaks in three months, most likely because another token validator or producer omits the optional version claim. [INFERRED]

## Feedback implementation — 2026-10-13

Requester authorized addressing this review and committing the fix. Path B against the recorded REQ-04 deviation, on the existing PR branch. Extended the existing socket authenticator with legacy-zero/current-version validation. Connection and subscription authenticate against current account state; created/read/unread delivery enumerates sockets in the user room and revalidates each handshake before sending. Stale sockets disconnect; current resetting-device sockets remain eligible. Idle sockets are disconnected on their next subscription or delivery, rather than by a new reset broadcast mechanism. A reset concurrent with a validation already in flight has the same boundary as an in-flight HTTP request.

All three NotificationService emission call sites await the existing gateway methods' now-asynchronous completion. Socket enumeration failures are logged and do not fall back to an unchecked room broadcast; persisted notifications remain retrievable over HTTP. No schema, dependency, endpoint, or new public helper is added. One private gateway helper consolidates the three delivery channels. Regression cases authored for stale reconnect, legacy/current/malformed claims, open-socket reset delivery on all three channels, subscription, and enumeration failure. Tests, builds and typechecking remain unrun at requester direction.

Static caller search and installed Socket.IO declarations confirm fetchSockets provides handshake/rooms/emit/disconnect. Independent agent re-review was attempted but failed because its model was unavailable; no independent passing verdict is claimed for this fix. Source review and diff checks are the available evidence. This addresses finding 1 in source; runtime validation remains outstanding.

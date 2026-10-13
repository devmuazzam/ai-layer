# PR #764 — AI DLC static review

**Verdict: do not ship — invitation acceptance can cross the SMS reset boundary and obtain the new session version.**

Reviewed 2026-10-13, Asia/Karachi. PR: https://github.com/TheCraneGuys/craneguys-platform/pull/764

PR review: `fix/TCG-27-sms-reset-recovery` → `main` (24 changed files, TCG-27, U1/U2).

- Fetched head: `3e02260726cfe27e27f699e017472ea52e114a61`.
- Actual base: `6f6f1a8c9ed207bd700d5c6f748434bcf95c8f41`, established from GitHub merge ref `9b4f6e1fe72712ffe23f9cd4e9792633beb643e5` and its parents.
- Isolated detached review checkout: `/tmp/pr-764-review-20261013`.
- Review procedures: `.ai/claude/skills/review-pr/SKILL.md`, `.ai/aidlc/agents/construction/tcg-analyst.md`, both vendored maintainability rubrics, contract tracer and Prisma guardian.
- Contract: matching overlay branch fetched as `refs/review/pr-764-overlay-20261013`, plus TCG-27 spec and units. Previous review conclusions were independently checked against this head.

What this change does: It makes SMS recovery failures actionable on the existing mobile screens. It adds an account session version so SMS password setting invalidates prior access/refresh credentials, propagates that version through token producers, and checks notification sockets before further delivery.

## CODE — most consequential first

### 1. [P1] [INFERRED] Bind invitation acceptance to its original authorization snapshot

Changed location: `apps/api/src/usecase/invitations/invitations.service.ts:531`.

`accept()` reads and validates a pending invitation at lines 519–520, awaits password hashing, and then calls `acceptInvite()`. The repository updates solely by user ID (`apps/api/src/service/users/users.repository.ts:375–390`) and returns the updated row. The new line 531 copies that row's session version into the issued tokens.

A concrete interleaving:

1. A pending account has an emailed invitation, a linked employee with a unique US work cell, and version 0. Invitation acceptance validates its token and begins hashing.
2. SMS password setting completes for that account, sets the reset password, increments the version to 1, clears the invitation, and establishes the reset device's session.
3. The already-running invitation acceptance resumes. Its unconditional update overwrites the reset password and returns the current version 1.
4. Invitation acceptance issues version-1 access/refresh tokens. Refresh-hash persistence also uses version 1, so it succeeds instead of rejecting the stale operation.

This allows a capability authorized before reset to acquire the reset's new version, overwrite the new password, and write refresh credentials in the new generation. It violates U2's explicit requirement that operations authenticated before reset cannot acquire a newer version or overwrite the fresh session's refresh hash.

**Reachability:** `resolveInviteChannel()` chooses email for non-field employees even with a valid US work cell (`invitations.service.ts:82–95`); email invitation creation links the pending user to the employee (`:333–343`). Phone lookup includes pending accounts without checking invitation channel (`users.repository.ts:80–86`), and SMS recovery accepts any resolved US account (`field-credentials.service.ts:39–76`). Both completion endpoints are public capability-bearing routes. No shared lock, conditional invitation write, or transaction prevents the interleaving.

**Refutation attempted:** Clearing the invitation during reset does not invalidate a validation that has already completed. The guarded refresh write does not help: it compares the version returned by the later invitation update, which already equals the reset's version. The unconditional password-write race existed in base; the changed version propagation permits that stale operation to bypass this PR's new reset boundary. Deferring new email recovery does not exclude this existing invitation token producer: the spec explicitly includes invitation minting in the ripple review.

**Smallest corrective direction:** Make invitation acceptance conditional on the originally validated invitation and session-version snapshot, so it fails without changing the password when SMS reset wins. Merely issuing version-0 tokens after the unconditional write would still allow the password overwrite. Add a regression case that pauses invitation acceptance after validation, completes SMS reset, then resumes acceptance and asserts rejection and preservation of the reset password/session. This review changes no application code and executes no test.

## SIZE

**[VERIFIED]** 349 changed source lines, 15 source files, within the approximately 400-line/25-file budget. Established with `git diff --numstat 6f6f1a8c9ed207bd700d5c6f748434bcf95c8f41...HEAD` and the review skill's test/migration/lockfile/snapshot exclusions. Total diff: 24 files, 684 insertions, 84 deletions.

## LOOP TRAIL

**[VERIFIED]** Local overlay main has a TCG-27 folder but no processed-log row. The freshly fetched matching overlay branch records Path A and the combined branch. Commands: `rg -n 'TCG-27' .ai/aidlc/processed.log`; `git -C .ai show refs/review/pr-764-overlay-20261013:aidlc/processed.log`.

**[VERIFIED]** That branch's `units.md`, “Combined delivery — requester instruction, 2026-10-12,” explicitly supersedes the initial separate-branch plan. This review does not invent a split blocker against that recorded requester instruction. Overlay consolidation remains a close-ticket follow-up; GitHub PR state was not available through the web/API tools, so no missed-close claim is made.

## TOOLING / DECISIONS / PATTERN / SIBLINGS

- **TOOLING [VERIFIED]:** Application diff leaves the AI tooling paths untouched, established by changed-file enumeration.
- **DECISIONS:** The concrete sessionVersion design, integer/default 0, atomic reset increment, legacy-zero compatibility and automatic sign-in trace to the recorded requester selection in TCG-27 spec. A human name is not supplied; attribution and client approval are not fabricated. Existing services, repository methods and screens are extended; no new endpoint, dependency or exported component is added.
- **PATTERN:** P1/P2 cover CRUD/reference lists and do not govern this auth path. API, Prisma and mobile contexts were read. No independent pattern deviation established.
- **SIBLINGS:** Temporary-password activation shares the field completion endpoint and is acknowledged by the spec. Web/SSO/invitation issuance is deliberately included by the spec's ripple section; email recovery implementation and revoked-account changes are expressly deferred/excluded. The invitation race is a required-consumer correctness issue, not an unrelated cleanup. No additional concrete not-asked sibling finding is asserted.

## PRODUCT — index-first vault pass

- **Sourced:** Honest SMS errors/restart, immediate rejection of old credentials, phone recovery and automatic sign-in trace to TCG-27 REQ-02/04/05/09 and requester choices. U2 specifically requires reset/sign-in/refresh race protection.
- **Reference:** `vault/decisions/2026-09-25-password-reset-accepts-a-pending-invitation.md`, status `reference`, records Syed Haris's CodingCops ruling that reset can activate a pending account and retires invitation credentials. It is not TCG client sign-off.
- **Unverified background:** `vault/admin/responsive-design-and-security-posture.md`, status `unverified`, describes historical auth posture; its token lifetimes and architecture are not treated as current deployment facts.
- **Conflicted background:** `vault/field-ops/field-ops-mobile-INDEX.md`, status `unverified`, names `field-ops/field-ops-frd/INDEX.md`, `field-ops/frd-new-format-draft/INDEX.md`, and `field-ops/atom-mobile-app-user-stories/INDEX.md`. No candidate is adjudicated against the explicit ticket scope.
- Retrieval followed root index → admin module index / field-ops conflict stub → specific source. No new unsourced product rule was established; no tcg-scrum escalation or new spec question was needed. Finding 1 is failure against an existing requirement.

## RIPPLE — consumers and regression coverage

**[VERIFIED]** Command enumeration in the isolated PR checkout included all four contract passes:

```sh
rg -l '/auth/|field/password/set|field/otp/verify|/notifications|notifications:subscribe' apps/web/src apps/mobile --glob '!*.test.*' --glob '!*.spec.*'
rg -l 'sessionVersion|passwordSetToken|challengeToken|FLOW_TOKEN_EXPIRED' apps/web/src apps/mobile --glob '!*.test.*' --glob '!*.spec.*'
rg -n 'JwtPayload' apps/web/src apps/mobile --glob '!*.test.*' --glob '!*.spec.*'
rg -l 'useSessionActions|useAuthFlowStore|authService\.|useNotificationSocket|createSocketNamespace|invitationsService\.accept' apps/web/src apps/mobile --glob '!*.test.*' --glob '!*.spec.*'
rg -n 'emitNotificationCreated|emitNotificationRead|emitNotificationUnread|issueTokensForUser|completePasswordSet|updateHashedRefreshToken' apps/api/src --glob '!*.spec.ts'
rg -n '@WebSocketGateway|authenticateHandshake|jwt\.verify|sessionVersion|verifyAsync' apps/api/src --glob '!*.spec.ts'
```

| Target | Intended reach / compatibility by inspection | Regression coverage from source reads |
| --- | --- | --- |
| Signup, password login, refresh, SSO, field completion, invitation acceptance | Explicit spec ripple. All propagate a version; invitation acceptance has finding 1. Other current token envelopes are compatible. | Version unit cases exist; no invitation/reset race case, full SSO/signup issuance case or real database interleaving established. |
| HTTP access and both refresh endpoints | Explicit U2. Legacy omission is version 0; stale versions rejected. Guarded persistence protects old snapshot writes. | Access strategy and auth session-version specs authored; not executed. |
| Shared JwtPayload | Additive optional claim; two web source files reference it, no mobile source reference found. Frontend transport treats tokens as opaque strings. | Source compatibility checked; no compilation performed. |
| Notifications | One production caller per created/read/unread emitter, all awaited in NotificationService. One notification gateway authenticator consumer. Event envelopes unchanged. | Socket auth/gateway specs cover versions, expired admission, established expiry handling, signature rejection and enumeration failure; mocks are not end-to-end adapter evidence. |
| Mobile reset/activation | Existing store, services and AuthGate traced. Failure message surfaced; restart clears abandoned state; success still establishes a session. | Both screen tests add restart cases. Device/storage/navigation flow not demonstrated. |

**[INFERRED]** The notification correction closes the previously reviewed version gap without rejecting a healthy established transport merely because HTTP refreshed its cookie. New socket admission still requires an unexpired signed token; established delivery still checks signature, account status, identity and version. The earlier socket bypass/expiry findings do not survive against this head.

**Existing boundary [INFERRED], not a new PR defect:** `/jobs` and `/das` gateways have no authentication and continue broadcasting independently of reset. Their web consumers were enumerated. They limit any global socket-access guarantee and warrant separate auth/tenancy work; this PR did not introduce those public surfaces.

Existing consumer coverage gaps would cap an otherwise clean verdict at ship with follow-ups. Finding 1 is already a blocker.

## MAINTAINABILITY — both rubrics applied

- **[VERIFIED] 1,000-line crossings: none.** Changed source lengths were compared using `git show <base>:<file>` and `git show HEAD:<file>`. The already-large Prisma schema is not a new crossing.
- **Thermo-nuclear:** No separate high-confidence structural regression established. The invitation write's authorization snapshot is the boundary defect in CODE. Broad authentication consolidation and existing-file decomposition would be separate developer-approved changes.
- **Ponytail:** Finding 1 is the must-fix security/data-integrity issue. Missing consumer regression coverage is listed above. No independent delete/reuse/stdlib/yagni proposal or speculative line-saving estimate is asserted.
- **Load assumption:** Existing multi-user API/web deployment with potentially concurrent authentication operations. Notification validation adds a lookup per connected recipient socket; no concrete failure at documented load was established, so no speculative performance blocker is reported.

## GATES / SPECIALIST VERDICTS / SCOPE

- **[VERIFIED]** Fetch of PR head and merge refs succeeded. Detached worktree contains the requested head and no source edits.
- **[VERIFIED]** `git diff --check 6f6f1a8c9ed207bd700d5c6f748434bcf95c8f41...HEAD` passed.
- **Tests, builds and typechecking were not run, as requested.** No lint, application execution, database execution or migration was run either. Pre-existing runtime failures were not assessed.
- **tcg-contract-tracer:** Four passes completed; no direct web/mobile response-shape break; independently found invitation/reset snapshot upgrade.
- **tcg-prisma-guardian:** User remains tenant-allowlisted; additive migration/default is consistent; conditional field reset and old refresh/logout writes are sound by inspection. Independently confirmed finding 1 after inspecting invitation acceptance. No database safety proof is claimed.
- **tcg-scrum:** None needed; no new unsourced requirement established.
- **Complete:** U1 appears complete by source inspection; U2 is incomplete at invitation token issuance. **Contained:** Yes under recorded combined delivery. **Demo:** Not run.
- New spec questions: none. No source fixes, commits, push, GitHub review submission or external messages performed.

Follow-ups outside this review execution: record requester human attribution and consolidate overlay artifacts when closing; later authorized SMS/device and PostgreSQL concurrency validation; extend signup/SSO token-producer coverage; separately address the pre-existing unauthenticated jobs/DAS gateways. Migration execution and deployment remain undone.

Least confident about: real device navigation and database/adapter timing, because behavior conclusions are source-based.

If this breaks in three months, most likely because a token producer obtains a fresh account row after authorization and silently upgrades its generation, or a separate validator omits the reset boundary. **[INFERRED]**

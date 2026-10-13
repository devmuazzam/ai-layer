# TCG-27 — phone/SMS recovery draft spec (Path A)

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

Status: scope and success behavior resolved by requester answers on 2026-10-12; immediate previous-session logout and sessionVersion structure selected by requester; implementation review pending. Work on the two remaining outcomes is authorized by the requester; schema/contract checks and bounded unit execution remain next. Requirements come from TCG-27 and explicit requester scope answers; code observations are in review.md.

## Requirements ledger

| ID | Requirement | Acceptance | Source / disposition |
| --- | --- | --- | --- |
| REQ-01 | Email-link reset in app | Original link AC retained as historical intent | Deferred by requester; another developer's unmerged branch |
| REQ-02 | Honest reset failure states | Invalid/used/expired SMS recovery capability cannot appear successful; user can start recovery again | Original technical token-state AC narrowed to requester’s SMS scope; presentation proposal below |
| REQ-03 | Browser fallback | Original web/no-app behavior | Deferred with email-link work |
| REQ-04 | Revoke old sessions | Immediately after successful SMS reset, old access and refresh credentials are rejected; the resetting device receives a new session | Original description, narrowed to phone/SMS scope |
| REQ-05 | Phone/SMS identity | Existing phone → code → password flow remains the mobile recovery path | Explicit requester answer, 2026-10-12 |
| REQ-06 | Email/company lookup | Original tenant-aware case-insensitive email criterion | Deferred; resolved-phone email fallback risk remains recorded |
| REQ-07 | Recovery abuse controls | Existing SMS cooldown/attempt/rate safeguards preserved; no new thresholds chosen | Original per-identifier technical AC within current SMS scope; email changes deferred |
| REQ-08 | App-link verification | Original real iOS/Android claims/provisioning criteria | Deferred with email-link work |
| REQ-09 | Preserve completion behavior | Successful SMS reset establishes a session and lets AuthGate navigate; no new success-to-login stage | Explicit requester answer to keep existing behavior, 2026-10-12 |
| REQ-10 | Revoked-account recovery safeguards | Excluded from this ticket’s implementation; existing access checks unchanged | Explicit requester direction, 2026-10-12 |

## Existing decisions and coordination

TCG-82 is Done. vault/decisions/2026-09-25-password-reset-accepts-a-pending-invitation.md is a reference ruling by Syed Haris: completed reset accepts pending invitation, revoked accounts are refused. Preserve it unless overruled by an authorized person. Pending-invite activation remains; don't alter onboarding or temporary-password activation as incidental reset work.

Requester states another developer has unmerged combined email and phone/SMS login/signup/reset work. No branch or developer identity supplied; no inspection or claim that it addresses particular findings. Email implementation is excluded here to avoid duplicate work. The original email-specific acceptance criteria are deferred, not fulfilled.

admin/gaps.md#sign-in-identity--microsoft-365-entra-credentials-or-phone-number-and-sms-code-and-for-whom stays open. Keeping today's phone flow does not resolve TCG-wide SSO/field identity policy. Field-ops source conflicts remain unadjudicated.

## Developer structure — selected approach and implementation review

- Revoked-account recovery safeguards are excluded by the requester. Do not add or remove revoked-account checks, change account activation policy, or implement the earlier proposed status/atomicity slice.
- Reuse set-password.tsx, verify-code.tsx, session store error and existing ServiceError codes for actionable expired/invalid failure. Propose showing the actual server message and an existing recovery-route action; preserve automatic sign-in on success. Exact presentation requires approval before execution.
- Existing completePasswordSet already clears old refresh hashes; issueTokensForUser then creates the new current session. Immediate old access-token invalidation may require a generation/reset-time representation. Requester selected immediate invalidation in Q3. Requester approved the sessionVersion representation below; review the migration and token compatibility before implementation. Contract tracer/Prisma guardian required if contracts/schema change.
- Siblings: SMS reset and temporary-password activation share password/set; preserve activation behavior and account-state safeguards. Web/email recovery is explicitly deferred. No global authentication sweep.
- Existing non-+1 phone fallback still delegates to email recovery. Its duplicate-email tenant risk is not fixed by this scope decision; keep it visible for coordination with the other branch. Do not silently remove fallback or change supported phone regions.

## 12. Questions and disposition

Q1 — Resolved: requester chose phone/SMS only for now; email/combined flows are assigned to another developer’s unmerged branch. No in-app email route or app-link implementation here.
Q2 — Resolved: keep automatic sign-in after successful SMS reset. No success-to-login change.
Q3 — Resolved by requester: invalidate all prior sessions immediately after successful SMS reset; keep the resetting device signed in. Old access tokens must be rejected as well as old refresh tokens.
Q4 — Deferred: pre-auth email tenant identity and shared-device email accessibility belong to deferred email work. Existing ambiguous-phone resolution fails closed; no company selector or changed ambiguity policy proposed.
Q5 — Deferred for email thresholds. Existing SMS thresholds remain; no replacement values proposed. SMS expiry/error presentation requires developer confirmation.
Q6 — Email/app-link provisioning deferred. SMS production delivery/device validation remain unverified and must be demonstrated before claiming readiness.
Q7 — Structure resolved: requester selected the previously presented sessionVersion approach. Reuse existing reset screens, session error state and recovery routing for the authorized error improvements. Named human attribution remains unprovided; the AI does not fill a human decider name or represent this as client-meeting approval. Contract/schema reviews remain required before execution.
Q8 — Resolved scope: requester explicitly excluded revoked-account safeguards. Review finding 6 remains recorded; no implementation or global policy change is authorized by this exclusion.

## Next gate

Execute the two bounded units in units.md after contract/schema review of the approved sessionVersion approach. Email findings and revoked-account safeguards remain outside the current scope. No builds, tests or typechecking run; execution remains separate from this draft.

## Concrete immediate-logout structure — requester selected sessionVersion

Existing candidates inspected: User.hashedRt, UsersRepository.completePasswordSet, AuthService.generateTokens/refreshTokens, AccessTokenStrategy.validate and shared JwtPayload. hashedRt protects refresh only; User.updatedAt changes for unrelated writes and is not a reset boundary. No session-version/reset-time field was found.

Selected D1 (requester session answer, 2026-10-12): User.sessionVersion integer, non-null, default 0, mapped to session_version. SMS reset increments it atomically with the password update; newly issued access/refresh tokens carry the resulting version. Validation compares token version with the current account version. Legacy tokens without the claim are treated as version 0, so the first reset rejects them while unreset users can continue until normal renewal. The reset device receives new tokens and remains signed in. The requester selected this concrete approach after the sessionVersion/timestamp comparison. It is session authorization, not recorded client-meeting sign-off. Unselected alternative: a dedicated reset timestamp with token issuance comparison; exact timestamp precision/legacy treatment would need its own decision.

Ripple to review before execution: all token minting and refresh paths must carry/check the approved representation, including web/SSO using the shared AuthService. This is necessary for immediate SMS-reset logout across all old sessions; it does not authorize adding email recovery or changing account-status rules. Contract tracer and Prisma guardian must check the chosen design, migration, compatibility and reset/refresh races. Do not stamp every login with a new version or accidentally turn ordinary sign-in into all-device logout.

Existing-screen proposal: keep set-password and verify-code screens, surface existing API failure messages, and offer a way to restart phone recovery for invalid/expired capabilities. Reuse existing session error state, auth flow store and routing; no new exported component or service method proposed. Existing successful automatic sign-in stays unchanged.

## Client-meeting evidence check — 2026-10-12

Requester asked whether vault client meetings approve the proposed sessionVersion structure. Search of meeting summaries/transcripts and decision notes found no explicit client approval of a session counter/token version, or immediate rejection of all prior access tokens after password reset. This is absence of a recorded approval in the searched material, not proof the client rejected it.

Related sources: admin/responsive-design-and-security-posture.md is an unverified CodingCops technical response dated 2026-03-09, describes nulling the refresh hash on logout, and does not authorize reset-version schema. decisions/2026-09-25-password-reset-accepts-a-pending-invitation.md describes clearing hashedRt, but explicitly identifies itself as a CodingCops-side reference ruling rather than TCG client sign-off. TCG-27 states reset logs out old sessions; requester separately selected immediate invalidation. Neither establishes named client-meeting approval of the specific sessionVersion implementation.

At the time of this evidence check, D1 was still proposed: the requester had asked for evidence rather than selecting the structure. Subsequently the requester explicitly selected sessionVersion on 2026-10-12. The selection authorizes the approach; it does not turn absent meeting evidence into client approval.

## Decision recorded — 2026-10-12

Requester: “lets go with this `sessionVersion`”. The previously described non-null integer default 0, versioned tokens, atomic reset increment, legacy version-0 handling and new reset-device session are the selected approach. Actual requester human-name attribution was not supplied and is not invented. Phone/SMS only; automatic sign-in; revoked-account safeguards excluded; no email/deep-link implementation.

# TCG-27 — current implementation review

Reviewed current main at c3eba1030 on 2026-10-12. Static source review only; no runtime reproduction, builds, tests, typechecking or lint. VERIFIED below means repository inspection, not demonstrated behavior.

## Ticket against current source

| Ticket asks | Current source | Disposition |
| --- | --- | --- |
| Recover using mobile identity | forgot-password.tsx accepts phone, calls /auth/field/password/forgot | Implemented in source; policy not ratified |
| Finish in app | verify-code.tsx → set-password.tsx → field/password/set | SMS flow implemented in source |
| Email reset link opens app | No mobile reset-password route; Android and AASA claim projects/tickets/app only | Missing |
| Browser fallback | Web reset-password page and emailed frontend URL exist | Existing; not runtime verified |
| Valid/used/expired/success link states | No mobile email-token consumer; set-password handles flow token through generic failure | Missing for email; SMS actionable expiry also incomplete |
| Success returns to login | session/store.ts setPassword establishes a session; AuthGate redirects | Different behavior: automatic sign-in |
| All old sessions logged out | SMS completePasswordSet clears hashedRt; ACTIVE email resetPassword does not | Incomplete; access-token invalidation also absent |
| Tenant-aware email lookup | findByEmail uses findFirst with exact email and no tenant predicate | Missing; SMS email fallback inherits this lookup |
| Identifier limits/cooldown | SMS sendSmsChallenge has per-tenant/phone/purpose limits and cooldown | Partially implemented; email endpoint has no dedicated rule |
| Pending-invite prerequisite | TCG-82 Done; reset activates pending user via completePasswordSet | Resolved in source under the existing reference decision |

## Findings — INFERRED from source

1. **High: ACTIVE email resets retain old refresh sessions.** AuthService.resetPassword invokes UsersRepository.resetPassword for ACTIVE accounts. The repository updates passwordHash/resetToken/resetTokenExpiry only, leaving hashedRt intact. refreshTokens compares against that retained hash. Pending-user and SMS writes use completePasswordSet and do clear it. Files: apps/api/src/usecase/auth/auth.service.ts:356; apps/api/src/service/users/users.repository.ts:124.
2. **High: old access tokens survive reset until expiry.** AccessTokenStrategy.validate checks existence and REVOKED status only, not password/session generation or reset time. Clearing hashedRt stops old refresh tokens, not already-issued access tokens. The ticket's “all old sessions” criterion needs an explicit immediate-vs-expiry decision. File: apps/api/src/strategy/access-token.strategy.ts:31.
3. **High: phone → email fallback can target another tenant.** FieldCredentialsService first resolves a particular user by phone, then for non-+1 numbers calls AuthService.forgotPassword(user.email), which resolves again using cross-tenant findFirst. An identical email in another tenant can receive/reset the wrong account. Files: field-credentials.service.ts:61; service/users/users.repository.ts:44. Phone ambiguity itself fails closed; email fallback loses that resolved identity.
4. **Missing ticket outcome: emailed links cannot complete inside mobile.** Route/service method and reset-password path claims are absent. AASA depends on APPLE_TEAM_ID; Android association has a placeholder default fingerprint. No production verification/environment claim is made. Files: apps/mobile/app.json; apps/web/src/app/.well-known/apple-app-site-association/route.ts; assetlinks.json/route.ts.
5. **Medium: reset/activation completion and error behavior are conflated.** Both use field/password/set and auto-authenticate. set-password.tsx displays a generic retry error even when the session store has the server's expired-token error; there is no explicit start-over state. This differs from the ticket's success-to-login and expired/used link criteria. Files: apps/mobile/app/(auth)/set-password.tsx:30; apps/mobile/session/store.ts:308.
6. **High follow-up: revocation during SMS recovery is not rechecked before activation.** A passwordSetToken fingerprints passwordHash/tempPasswordHash, not status. FieldCredentialsService.setPassword does not reject a newly REVOKED user before completePasswordSet unconditionally writes ACTIVE. For an already-active account without a temporary hash, revokeUser clears tokens but need not change the credential fingerprint. A previously issued recovery capability can therefore survive revocation. Files: field-credentials.service.ts:126; field-flow-token.service.ts; users.repository.ts:337,380. Static inference, not a reproduced exploit; require a targeted regression before shipping.

## Existing safeguards — VERIFIED by inspection

- Phone resolution returns ambiguous for multiple matches; forgot flow gives a synthetic OTP response instead of guessing.
- OTP challenges have expiry, resend cooldown, per-phone limits and failed-attempt handling.
- Password-set tokens have purpose/expiry checking and credential fingerprinting.
- TCG-82 state handling matches the 2026-09-25 reference decision; REVOKED email reset is refused.
- Test files exist for forgot/verify/set screens, HTTP adapters, field credentials, flow tokens, phone resolution, OTP and reset account status. None executed; existence is not evidence they pass or cover the full flow.

## Uncertainty

SMS delivery/SNS production readiness, company/shared-phone policy, deployed association files and real signing identity remain unverified. Review did not read secret values or access the DB. Current local HEAD may differ from deployed code. No ticket comment/description or application source was changed.

## Scope disposition after requester answers — 2026-10-12

Keep phone/SMS recovery and automatic sign-in. Another developer owns unmerged combined email/phone work; no branch was identified or inspected. Findings 1 (ACTIVE email refresh hash), 3 (email fallback account lookup) and 4 (email route/claims) remain accurate source observations but are deferred from this SMS plan. Finding 5 no longer proposes changing successful completion; its actionable expired/invalid SMS error aspect remains a candidate. Findings 2 (old access tokens) and 6 (revocation during SMS recovery) remain relevant. Scope reduction does not establish that original email-link AC are complete or that any separate branch has fixed these issues.

## Requester scope and session decision — 2026-10-12

The requester excluded revoked-account safeguards from TCG-27 and authorized work on reset failure recovery and other-device logout. Previous sessions must lose access immediately after successful phone/SMS reset; the resetting device keeps its new session. This does not remove existing revoked-account checks or globally adjudicate the historical finding. New schema/token contract choices remain subject to developer structural approval.

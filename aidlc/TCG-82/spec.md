# Spec — TCG-82 Password reset must not strand a pending-invite user

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-82` |
| Intent | `.ai/aidlc/TCG-82/intent.md`, captured `2026-09-22` |
| Elaborated on | `2026-09-22` |
| Vault state at elaboration | *710 `.md` files; `domain/` is the only verified folder (11 files, of which `jira-sop.md` is cited here); 329 entries open across the ten module `gaps.md` registers, 22 of them in `admin/`* |
| Open questions raised by this spec | *1, in §12 — Q1. It blocks REQ-08 only* |
| Already-shipped behaviour reached | *9 consumers in §11a; 0 with no source for what happens to them* |
| Rules consulted | `CLAUDE.md`, `.ai/claude/contexts/api.md`, `.ai/claude/contexts/web.md` (*Test IDs*), `.ai/claude/contexts/prisma.md` |
| Code read at | `fix/tcg-82-password-reset-pending-invite` @ `cd90f87bc` (= `origin/main`). Every `file:line` below was read directly at that commit |

**A note on what kind of ticket this is.** TCG-82 is a *bug* whose corrective behaviour was
ruled on by product on 2026-09-22 (§12 Q2, resolved). So unusually for this repo, most
requirements here are `[UNVERIFIED]`-sourced-from-code **plus** a verified product ruling —
the code establishes what happens today, the ruling establishes what should happen instead.
Neither alone would be enough: per the template's own rule, a `code` source can never be the
only source for a behaviour change.

## 0a. What of this spec ships

This spec elaborated the full remedy the ticket asked for — ten requirements across the
API, the web app and a data script. **What ships is the authentication change: four
requirements, one production file plus two supporting ones.** The rest is specified here
and not built, and the table says which is which so nobody reads the spec's length as the
change's size.

| Req | Shipped? |
| --- | --- |
| REQ-01 | **yes, re-aimed by Q1** — `forgot-password` mints nothing for a `REVOKED` account. A `PENDING_INVITE` account **is** sent the link, because completing it activates them |
| REQ-02 | **no, and not wanted** — it re-sent the invite in place of the reset. Q1's answer makes the reset itself sufficient, so there is nothing to divert to |
| REQ-03 | **yes, more simply than specified** — no new branch throws, so the response cannot vary by account state at all |
| REQ-04 | **yes, re-aimed by Q1** — `reset-password` refuses `REVOKED`. A `PENDING_INVITE` reset is not refused; it activates the account |
| REQ-05 | **yes, by reuse** — `completePasswordSet` clears `inviteToken`/`inviteTokenExpiry`, and also `tempPasswordHash`/`tempPasswordExpiresAt` and `hashedRt`, which REQ-05 never contemplated. Load-bearing, not belt-and-braces: without it the untouched invite token would overwrite the password just set |
| REQ-06 | **in substance, not as specified** — no web component. The sign-in rejection itself now names both routes, so the advice reaches the user through copy she already sees |
| REQ-07 | **no** — copy on an admin conflict response, no behaviour |
| REQ-08 | **no, and no longer needed** — a stranded row holds a working password, so the next sign-in activates it. Self-healing; nothing to schedule |
| REQ-09 | **no** — the census script exists only to count REQ-08's population, which no longer has to be counted before it is fixed |
| REQ-10 | **partly** — 16 unit cases across two new specs, and the live E2E suite updated. No new Playwright file |

**One requirement this spec did not foresee.** Sign-in reads a pending account holding a
password as one whose owner set it through the reset flow. That is only sound while
`PENDING_INVITE` implies no password, which every invite branch maintains and
`AdminUsersService.update` did not — see §11a.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | `forgot-password` sends no reset mail to a non-`ACTIVE` user | api | `[UNVERIFIED]` | `TCG-82` AC1; code `auth.service.ts:209`; ruling Q2 | no |
| REQ-02 | `forgot-password` sends the portal invite to a `PENDING_INVITE` user instead | api | `[UNVERIFIED]` | `TCG-82` AC1; ruling Q2 | no |
| REQ-03 | The response of `POST /auth/forgot-password` is byte-identical in every case | api | `[UNVERIFIED]` | `TCG-82` AC1; code `auth.controller.ts:154-161`, `auth.service.ts:211` | no |
| REQ-04 | `reset-password` refuses a token belonging to a non-`ACTIVE` user, before hashing | api | `[UNVERIFIED]` | `TCG-82` AC2; ruling Q2 | no |
| REQ-05 | `resetPassword` also clears `inviteToken` / `inviteTokenExpiry` | api | `[UNVERIFIED]` | `TCG-82` AC3 | no |
| REQ-06 | Web login offers an actionable affordance beside the pending-invite rejection | web | `[UNVERIFIED]` | `TCG-82` AC6; ruling Q3 | no |
| REQ-07 | The `ACTIVE`-branch invite copy cannot be generalised to a pending user | api | `[UNVERIFIED]` | `TCG-82` AC7; code `invitations.service.ts:89-92` | no |
| REQ-08 | Rows already stranded are remediated | api (data) | `[OPEN]` | none — see Q1 | **yes, for the write only** |
| REQ-09 | The remediation script logs per tenant before writing and is idempotent | api (data) | `[UNVERIFIED]` | `TCG-82` AC9 | no |
| REQ-10 | Tests: unit + E2E for every branch above | api, qa-automation | `[UNVERIFIED]` | `TCG-82` AC4, AC5 | no |

Counts: **10** total — 0 verified, 9 unverified, 0 conflicted, **1 open**.

`TCG-82` is tagged `[UNVERIFIED]` per the template's rule that a ticket records what someone
decided to build, not what product agreed. The 2026-09-22 ruling (§12 Q2/Q3) is the verified
part, and it covers direction only — not the ten ACs line by line.

## 2. Requirements

### REQ-01 — `forgot-password` sends no reset mail to a non-`ACTIVE` user `[UNVERIFIED]`

- **Statement:** A password-reset request for a user who is not `ACTIVE` never mints a reset
  token and never sends a reset email.
- **Surface:** api
- **Sources:**
  - `TCG-82` — `[UNVERIFIED]` — kind: jira — AC1: *"`forgot-password` **does not send a reset
    mail to a non-**`ACTIVE` **user**"*.
  - `apps/api/src/usecase/auth/auth.service.ts:209-226` — `[UNVERIFIED]` — kind: code —
    today `forgotPassword` returns early **only** when the user does not exist. There is no
    status check, so a `PENDING_INVITE` *or* `REVOKED` user mints a reset token and receives
    a reset mail.
  - §12 Q2 — `[VERIFIED]` — kind: decision — product ruled 2026-09-22 that a password reset
    must not be an activation path.
- **Conflict:** none
- **Open question:** none
- **Ripple:** `REVOKED` users are reached as well as `PENDING_INVITE` ones, and the ticket's
  AC1 says *non-`ACTIVE`*, which covers both. Today a revoked user can mint reset tokens
  indefinitely; after this they cannot. No source describes a revoked user resetting a
  password as intended behaviour, and the login guard at `auth.service.ts:107-112` already
  refuses them, so the change removes a path that could never succeed. Enumerated by
  `grep -rn "status === 'REVOKED'" apps/api/src`. Full table in §11a.
- **Acceptance:** with a seeded `PENDING_INVITE` user, `POST /auth/forgot-password` leaves
  `users.reset_token` NULL. Same for `REVOKED`. For `ACTIVE`, a token is still written.
- **Notes for the executor:** the early-return placement matters — see REQ-03. Keep the
  existing `// Always return success to prevent email enumeration` comment's intent: every
  new branch is a `return`, never a `throw`.

### REQ-02 — `forgot-password` sends the portal invite to a `PENDING_INVITE` user instead `[UNVERIFIED]`

- **Statement:** When a `PENDING_INVITE` user asks for a password reset, the system sends
  that user their portal invitation email, so the request produces the mail that lets them in.
- **Surface:** api
- **Sources:**
  - `TCG-82` — `[UNVERIFIED]` — kind: jira — AC1: *"**Instead, for a** `PENDING_INVITE`
    **user, re-send the invite email** with a rotated token, so the request the user made
    produces the mail that actually helps them."*
  - `apps/api/src/usecase/invitations/invitations.service.ts:118-141, 213-233` —
    `[UNVERIFIED]` — kind: code — the existing shape of issuing an invite: a 32-byte hex
    token, `INVITE_TOKEN_TTL_MS` = 72 h, `inviteLink` = `${frontendUrl}/accept-invite?token=`,
    `ssoLink` = `${apiUrl}/auth/microsoft`, `notify({ type: 'invitations.portal_invite', … })`.
  - §12 Q2 — `[VERIFIED]` — kind: decision.
- **Conflict:** none
- **Open question:** none
- **Deviation from AC1, deliberate — the token is reused when it is still live, not always
  rotated.** AC1 says *"with a rotated token"*. Both endpoints are `@Public()`
  (`auth.controller.ts:155`) and the only rate limit is the global
  `ThrottlerModule.forRoot([{ ttl: 60_000, limit: 30 }])` (`app.module.ts:156`). Always
  rotating therefore lets an anonymous caller who knows a pending user's address invalidate
  that user's legitimate in-flight invite link 30 times a minute. So:
  **reuse the existing token when `inviteToken` is non-null and `inviteTokenExpiry > now`;
  mint and persist a new one only when it is absent or expired.** "Live" must mean unexpired,
  not merely present — reusing on non-null alone would re-send a long-dead link forever.
  Reuse does **not** push `inviteTokenExpiry` forward: extending it on an unauthenticated
  request would let a caller keep one token alive indefinitely and weaken the 72 h bound, so
  a user asking at t+71 h correctly gets a link with one hour left.
  *This narrows AC1's mechanism, not its outcome — the user still receives a working invite.*
- **Ripple:** the invite mail is built from the `User` row (`user.name`, `user.tenantCompanyId`)
  and the tenant, with **no `Employee` lookup**. Consequence worth stating: TCG-82 §2 records
  that a pending user with no linked employee cannot be helped by admin *Resend Invite*,
  because that path resolves through `Employee` and 404s
  (`invitations.service.ts:171-193`). After this requirement, that population self-recovers.
  Full table in §11a.
- **Acceptance:** `PENDING_INVITE` user with a live invite token → `POST /auth/forgot-password`
  sends `invitations.portal_invite` carrying the **same** `inviteToken`, and
  `users.invite_token` is unchanged. With an expired or NULL token → a new token is persisted
  and mailed. In both cases `users.reset_token` stays NULL.
- **Notes for the executor:** the invite-issuing logic currently lives in
  `InvitationsService`, and `InvitationsModule` already imports `AuthModule`
  (`invitations.module.ts:9`) because `InvitationsService.accept()` needs
  `AuthService.issueTokensForUser`. Injecting `InvitationsService` into `AuthService` is a
  module cycle. Extract instead — see `units.md` U1. Do **not** duplicate the block: it
  encodes four contracts with things outside the file (the `/accept-invite?token=` route, the
  `${apiUrl}/auth/microsoft` route, the 72 h TTL that `assertInviteValid` enforces, and the
  four-key context shape `renderPortalInvite` consumes at `notification-catalog.ts:58`), and
  a drifted copy fails only as a broken link inside a delivered email — no test, type or 500
  catches it.

### REQ-03 — The response of `POST /auth/forgot-password` is byte-identical in every case `[UNVERIFIED]`

- **Statement:** Whatever the caller's email resolves to — no user, `ACTIVE`,
  `PENDING_INVITE`, `REVOKED`, or a mail-delivery failure — the endpoint answers `200` with
  the same body.
- **Surface:** api
- **Sources:**
  - `TCG-82` — `[UNVERIFIED]` — kind: jira — AC1: *"and still returns 200 with no body
    change, because `auth.service.ts:210-211` guarantees no email enumeration"*.
  - `apps/api/src/presentation/auth/auth.controller.ts:154-161` — `[UNVERIFIED]` — kind: code
    — `@Public()`, `@HttpCode(HttpStatus.OK)`, and a constant body:
    `{ message: 'If an account with that email exists, a reset link has been sent.' }`.
  - `apps/api/src/usecase/auth/auth.service.ts:211` — `[UNVERIFIED]` — kind: code — the
    standing comment *"Always return success to prevent email enumeration"*.
- **Conflict:** none
- **Open question:** none
- **Two mechanisms this constrains, both non-obvious:**
  1. **The invite mail must be sent with `requireDelivery: false`.** `NotificationService`
     throws `ServiceUnavailableException` when `requireDelivery` is set and either no
     recipient resolves (`notification.service.ts:58-62`) or the EMAIL channel fails
     (`:147-149`). A throw on the pending branch would turn a `200` into a `503` **only for
     pending users**, which is exactly the enumeration oracle this endpoint exists to deny.
     The admin invite/resend paths keep `requireDelivery: true` — they are authenticated and
     *want* to fail loudly.
  2. **Order within the pending branch: persist, then send.** The `ACTIVE` branch already
     writes before it mails (`setResetToken` at `:217`, `notify` at `:220`). With
     `requireDelivery: false` the send cannot throw, so the DB write is the only throw left;
     keeping it in the same position leaves both branches with an identical failure surface.
     Sending first would also risk mailing a link whose token was never stored.
- **Ripple:** `@AUTH-006` and `@AUTH-043` in `qa-automation/e2e/specs/auth/forgot-password.spec.ts`
  assert the confirmation view's copy for an `ACTIVE` user and must keep passing unchanged.
  Mobile shows its own check-your-email view off the same 200
  (`apps/mobile/app/(auth)/forgot-password.tsx:57-58`). Full table in §11a.
- **Acceptance:** capture the raw HTTP status and body for all four resolutions of the email
  and diff them — identical. Additionally: with the mail transport made to fail, a pending
  user's request still answers 200.
- **Notes for the executor:** this requirement is why REQ-01's branches are `return`, not
  `throw`, and why REQ-02 cannot reuse the admin path's `requireDelivery: true`.

### REQ-04 — `reset-password` refuses a token belonging to a non-`ACTIVE` user, before hashing `[UNVERIFIED]`

- **Statement:** Completing a password reset is impossible for a user who is not `ACTIVE`,
  and the refusal is indistinguishable from an unknown token.
- **Surface:** api
- **Sources:**
  - `TCG-82` — `[UNVERIFIED]` — kind: jira — AC2: *"`reset-password` **rejects a token
    belonging to a non-**`ACTIVE` **user** before hashing. The message must not distinguish
    'pending' from 'invalid' to an unauthenticated caller."*
  - `apps/api/src/usecase/auth/auth.service.ts:232-245` — `[UNVERIFIED]` — kind: code — today
    the only checks are token-exists and token-not-expired; then it hashes and writes.
  - `apps/api/src/usecase/auth/auth.service.ts:113-116` — `[UNVERIFIED]` — kind: code — the
    login guard that then refuses the user, shared by web sign-in and mobile field sign-in.
  - §12 Q2 — `[VERIFIED]` — kind: decision.
- **Conflict:** none
- **Open question:** none
- **Ripple:** this is the branch that closes the contradiction. It makes a pre-seeded reset
  token on a pending row unusable, which is why REQ-10's E2E has to seed the token directly
  — after REQ-01 there is no longer any way to *obtain* one for a pending user. Full table
  in §11a.
- **Acceptance:** with `reset_token` seeded on a `PENDING_INVITE` row, `POST /auth/reset-password`
  answers `400` with **exactly** `Invalid or expired reset link`, and `users.password_hash`
  is byte-identical before and after. The check runs before `bcrypt.hash` — assert by
  observing that the stored hash is unchanged, not by timing.
- **Notes for the executor:** place the check after the existing expiry check and before
  `bcrypt.hash`. Reuse the exact string already at `:236`; do not write a new one.
  **Noted, not fixed:** `:240` still answers `Reset link has expired`, so a caller who
  already *holds* a token can distinguish expired from unknown, and `assertInviteValid`
  (`invitations.service.ts:335-344`) splits the same way. Both require possessing a token;
  the channel that matters here — the unauthenticated email probe at `forgot-password` — is
  closed by REQ-03. Out of scope, and these two strings must not be quietly changed.

### REQ-05 — `resetPassword` also clears `inviteToken` / `inviteTokenExpiry` `[UNVERIFIED]`

- **Statement:** A completed password reset leaves no live invitation on the same row.
- **Surface:** api
- **Sources:**
  - `TCG-82` — `[UNVERIFIED]` — kind: jira — AC3: *"**Belt and braces:** `resetPassword`
    additionally clears `inviteToken` / `inviteTokenExpiry`, so a reset and an invite can
    never both be live on one row. Update its JSDoc."*
  - `apps/api/src/service/users/users.repository.ts:122-127` — `[UNVERIFIED]` — kind: code —
    writes `{ passwordHash, resetToken: null, resetTokenExpiry: null }`; `status` and both
    invite columns untouched. This is the line the UAT register cites.
- **Conflict:** none
- **Open question:** none
- **Ripple:** defence-in-depth, and after REQ-04 a **no-op in practice** — the only rows that
  can now reach `resetPassword` are `ACTIVE`, and `ACTIVE` rows never hold an invite token
  (`acceptInvite` at `users.repository.ts:296-307` and `activateViaSso` at `:266-275` both
  null it; `revokeUser` at `:309-318` nulls it too). Keep it anyway: it is the invariant that
  makes REQ-04's guarantee independent of how a row became `ACTIVE`. Full table in §11a.
- **Acceptance:** the Prisma `data` object contains all four nulls; the JSDoc says what it
  now does. An `ACTIVE` user's reset still succeeds end to end.
- **Notes for the executor:** repository layer only — `service/users/users.repository.ts`.
  Do not add a status write here; activation is not this method's job (§12 Q2).

### REQ-06 — Web login offers an actionable affordance beside the pending-invite rejection `[UNVERIFIED]`

- **Statement:** A user refused at login for a pending invitation is shown, on that screen,
  how to get a working invite.
- **Surface:** web
- **Sources:**
  - `TCG-82` — `[UNVERIFIED]` — kind: jira — AC6: *"The login rejection stays, but **web
    login surfaces an actionable affordance next to it** (request a resend, or 'contact your
    administrator')."*
  - §12 Q3 — `[VERIFIED]` — kind: decision — 2026-09-22: the affordance is a standalone hint
    inside `LoginForm`; the dead shared banner is not repaired as part of this ticket.
  - `.ai/claude/contexts/web.md` → *Test IDs* — `[UNVERIFIED]` — kind: rule — new copy ships
    with a `data-testid`, because `qa-automation/` addresses the UI through it and nothing
    lints or runs that suite.
- **Conflict:** none
- **Open question:** none — the *wording* of the hint is `NOT SPECIFIED` by any source; see
  §13. The executor writes the shortest sentence that carries AC6's two options and nothing
  more.
- **Ripple:** **the API rejection string does not change.** `@AUTH-020` asserts it verbatim
  (`login-account-status.spec.ts:60-63`), and AC6 itself carries the warning. Leaving it
  alone means no `qa-automation` edit for REQ-06. The affordance points at
  `/forgot-password`, which after REQ-02 *is* the invite resend for a pending user — so the
  hint is only truthful once REQ-02 has shipped; they must not be split across PRs. Full
  table in §11a.
- **Acceptance:** signing in as a pending user renders an element carrying the new
  `data-testid`, linking to `/forgot-password`. Signing in with merely wrong credentials
  does **not** render it. `@AUTH-019`–`@AUTH-022` and `sso.spec.ts` still pass untouched.
- **Notes for the executor:** `apps/web/src/features/auth/components/organisms/login-page-content.tsx`.
  Gate on the pending-invite message inside `signIn.error`. **Do not** touch the
  `data-testid="auth-login-error"` banner at `:148` or the `useSignIn()` wiring — that banner
  is unreachable for credential errors by design-accident (`LoginPageContent` and `LoginForm`
  each call `useSignIn()`, so the banner reads a different mutation instance from the one the
  form mutates), it is asserted for the `?error=` SSO path by `sso.spec.ts:9-21`, and
  repairing it is explicitly out of scope. Use existing primitives from `@/components/ui`;
  colours from theme variables, never literals.

### REQ-07 — The `ACTIVE`-branch invite copy cannot be generalised to a pending user `[UNVERIFIED]`

- **Statement:** The conflict raised when an already-active employee is re-invited no longer
  reads as blanket advice that a password reset fixes portal-access trouble.
- **Surface:** api
- **Sources:**
  - `TCG-82` — `[UNVERIFIED]` — kind: jira — AC7, including its suggested wording, and its
    note *"Additive, no behaviour change."*
  - `apps/api/src/usecase/invitations/invitations.service.ts:89-92` — `[UNVERIFIED]` — kind:
    code — `Employee "X" already has portal access. Send a password reset instead.` The very
    next branch (`:93-97`) already says the right thing for a pending user: *"already has a
    pending invite. Use resend or revoke first."*
- **Conflict:** none
- **Open question:** none
- **Ripple:** a `ConflictException` message on an authenticated admin endpoint.
  `grep -rn 'Send a password reset instead' apps qa-automation` finds the definition only —
  no test asserts it, and `grep -rn 'already has portal access' apps/web/src` finds nothing,
  so no web copy mirrors it. Safe to amend. Full table in §11a.
- **Acceptance:** the string names *Resend Invite* as the pending-user remedy. HTTP status
  unchanged (`409`), branch order unchanged, no new branch.
- **Notes for the executor:** text only. Keep it one sentence longer at most; this message is
  read in a toast.

### REQ-08 — Rows already stranded are remediated `[UNVERIFIED]` — **dissolved by Q1**

- **Resolution:** Q1's answer removes this requirement rather than settling it. A stranded row holds a password its owner set through the emailed reset flow, so the next sign-in activates it (`authenticateAndIssueTokens`). There is no population left to repair on a schedule, and no write for anyone to run. The original framing, and the search that established nothing settled it, are kept below as the record.
- **Statement:** `OPEN as elaborated — TCG-82 AC8 asks for every row at `status = 'PENDING_INVITE' AND
  password_hash IS NOT NULL` to be repaired, but names two incompatible repairs — (a) set
  `status = 'ACTIVE'`, honouring the password the user already set, or (b) null
  `password_hash` and resend the invite — and states that choosing between them is a product
  call. No source chooses.`
- **Surface:** api (data)
- **Sources:** none.
  Searched: `.ai/vault/decisions/` — 84 notes, swept by
  `grep -rln -iE 'invite|activat|password|reset-password|sign-?in' .ai/vault/decisions/`,
  which returns 4; reading those 4, **none bears on this.** The two that touch invites at all
  are `2026-09-22-browser-autofill-suppression-scope-and-mechanism.md:44` (accept-invite named
  only as a password field a manager cannot save) and
  `2026-09-15-employee-profile-compensation-type-and-statuses.md:52` (a table of which
  *employee* statuses may be invited — it governs who gets an invite, never what completing
  one means);
  `.ai/vault/admin/gaps.md` (22 open entries, `grep -in "password reset" → no match`);
  `.ai/vault/payroll/gaps.md` *Employee-module rules … PR #488* item (c), which asks the
  invite-lifecycle question and is itself open; `.ai/vault/uat/register-2026-09-18.md:256`
  and `uat/sessions/uat-session-5.md:30`, which record the ask and no intent. **Nothing
  written settles it.** The search record is Q1.
- **Conflict:** n/a
- **Open question:** Q1, below. Also appended to `.ai/vault/admin/gaps.md` as a product-wide
  question belonging to no ticket, per `CLAUDE.md`'s routing table.
- **Ripple:** `OPEN — cannot be stated until Q1 is answered.` The radius *is* knowable and
  was enumerated: the affected set is exactly the rows the preflight query returns, split by
  `employee_id IS NULL` (needs `SUPER_ADMIN` or SQL today) versus not (admin *Resend Invite*
  reaches it). Which of the two repairs each row gets, and whether a user's chosen password
  survives, is the question. Under (b) real users receive mail — that is a product-visible
  side effect, not an implementation detail.
- **Acceptance:** `OPEN — cannot be stated until Q1 is answered.`
- **Notes for the executor:** the workaround that does not depend on the answer, and is what
  U5 builds: ship the **preflight SQL** (read-only) and a script that *refuses to run*
  without an explicit `--policy=activate|reinvite` **and** `--apply`. Defaults to a dry run
  that prints the per-tenant counts. Do not pick a default policy — a default is the answer.

### REQ-09 — The remediation script logs per tenant before writing and is idempotent `[UNVERIFIED]`

- **Statement:** The remediation reports what it is about to change before changing anything,
  and running it twice has the same effect as running it once.
- **Surface:** api (data)
- **Sources:**
  - `TCG-82` — `[UNVERIFIED]` — kind: jira — AC9: *"The script **logs affected rows per
    tenant before writing**, and re-running it is a no-op."*
  - `apps/api/prisma/scripts/` — `[UNVERIFIED]` — kind: code — the established precedent for
    one-off data work: `preflight-*.sql` for the read-only census (four of them),
    `backfill-job-associated-resources.ts` / `remove-optional-materialized-job-resources.ts`
    for the write, registered in `apps/api/package.json` as
    `ts-node --transpile-only prisma/scripts/<name>.ts`.
- **Conflict:** none
- **Open question:** none — this requirement is buildable while REQ-08 is open, because
  logging and idempotence are the same under either policy.
- **Ripple:** a new script file and one new `package.json` script. Touches no running code.
  Both queries in TCG-82 §4 were checked against `schema.prisma` — `status`,
  `password_hash`, `invite_token`, `invite_token_expiry`, `tenant_company_id`, `employee_id`,
  `updated_at` all exist on `users`. Full table in §11a.
- **Acceptance:** run with no flags → prints per-tenant counts, writes nothing, exits 0. Run
  twice with a policy and `--apply` → the second run reports 0 rows and writes nothing.
  Idempotence follows from the predicate: each policy's write removes its own rows from
  `status = 'PENDING_INVITE' AND password_hash IS NOT NULL`.
- **Notes for the executor:** the census predicate is trustworthy because the signature is
  exact — `invite()` writes `passwordHash: null` on **both** branches
  (`invitations.service.ts:143-168`), and no other path sets a password without also setting
  `ACTIVE`. So `PENDING_INVITE` + a non-null hash can only have been produced by this bug.
  **Do not run the script in this ticket.**

### REQ-10 — Tests: unit + E2E for every branch above `[UNVERIFIED]`

- **Statement:** Each new branch is pinned by a test that fails if the branch is removed.
- **Surface:** api, qa-automation
- **Sources:**
  - `TCG-82` — `[UNVERIFIED]` — kind: jira — AC4 (unit) and AC5 (E2E beside
    `login-account-status.spec.ts`, using the disposable-user seed helper).
  - `apps/api/src/usecase/invitations/invitations.service.spec.ts` — `[UNVERIFIED]` — kind:
    code — the house style for an API unit test here: a `buildHarness` factory, positional
    constructor injection with `as never` mocks, no Nest testing module.
  - `qa-automation/e2e/support/seed/disposable-user.ts:37-49, 60-98, 190` — `[UNVERIFIED]` —
    kind: code — `createDisposableUser` already accepts `status`, `inviteToken`, `resetToken`,
    `withoutPassword`; `readResetToken` reads the column back. No new seed work needed.
- **Conflict:** none
- **Open question:** none
- **Ripple:** **`apps/api` has no test for `AuthService` today** — `find apps/api/src -name
  '*.spec.ts'` returns **133** files, none of them under `usecase/auth/`
  (`ls apps/api/src/usecase/auth/*.spec.ts` → no match). The nearest neighbours are
  `invitations.service.spec.ts` and the ten `notifications/` specs. This ticket writes the
  first test of the sign-in, forgot-password and reset-password paths. Separately, U1's extraction
  changes `InvitationsService`'s constructor arity, which breaks
  `invitations.service.spec.ts` at compile time — deliberately; see §11a and `units.md` U1.
  Full table in §11a.
- **Acceptance:** `pnpm nx run @tcg/api:test` green, including the new
  `auth.service.spec.ts` and `portal-invite-issuer.service.spec.ts`. The new
  `qa-automation/e2e/specs/auth/pending-invite-password-reset.spec.ts` passes against a live
  API, and the four pre-existing `login-account-status.spec.ts` cases still pass unmodified.
- **Notes for the executor:** one coverage trap. `requireDelivery: true` is asserted **only**
  in `invitations.service.spec.ts` today. Once the notify call moves behind the extracted
  issuer, that file can no longer see it — so the new
  `portal-invite-issuer.service.spec.ts` must assert it, or the guarantee silently loses its
  only test.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** **no**
- **Migration required:** **no** — no DDL. The remediation is a data script under
  `apps/api/prisma/scripts/`, deliberately not a migration: it is a one-off repair whose
  policy is undecided (Q1), and a migration would run it automatically on deploy.
- **Data backfill required:** **yes, but gated** — see REQ-08/REQ-09 and Q1.

No new or changed models. Columns read and written, all pre-existing on `users`:

| Column | Read | Written | By |
| --- | --- | --- | --- |
| `status` (`UserStatus`: `ACTIVE`, `PENDING_INVITE`, `REVOKED`) | yes | no *(not by the forward fix — see Q2)* | REQ-01, 02, 04 |
| `password_hash` | no | yes *(unchanged code path, `ACTIVE` only after REQ-04)* | REQ-05 |
| `reset_token`, `reset_token_expiry` | yes | yes | REQ-01, 04, 05 |
| `invite_token`, `invite_token_expiry` | yes | yes | REQ-02, 05 |

- **New prefix introduced:** no — `User` carries no business code. Identity is the uuid PK
  plus `@@unique([tenantCompanyId, email])`; per `CLAUDE.md`'s Identity Convention this is
  the correct shape for an entity with no user-facing code, and nothing here changes it.
- **Child relations:** unchanged. No FK is added or retargeted.
- **Fields whose type/precision no source states:** `N/A` — no new fields.

## 4. API surface — `apps/api`

Layering is `presentation → usecase → service → orm`, never upward.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/api/v1/auth/forgot-password` | `auth.controller.ts:154-161` *(unchanged)* | `auth.service.ts` `forgotPassword` | `users.repository.ts` `setResetToken`, `setInviteToken` | REQ-01, 02, 03 |
| `POST` | `/api/v1/auth/reset-password` | `auth.controller.ts:163-170` *(unchanged)* | `auth.service.ts` `resetPassword` | `users.repository.ts` `resetPassword` | REQ-04, 05 |
| `POST` | `/api/v1/invitations/:employeeCode/invite` *(and `/resend`)* | unchanged | `invitations.service.ts` — **refactored, behaviour preserved** | unchanged | REQ-02 (U1), REQ-07 |

**No route is added, removed or renamed. No DTO changes. No response shape changes.**

Per endpoint:

- **Request DTO:** `forgot-password.dto.ts`, `reset-password.dto.ts` — **unchanged**.
- **Response shape:** unchanged, and REQ-03 makes that a hard requirement for
  `forgot-password`. `reset-password` keeps `{ message: string }` on success and `400` with
  `{ message: 'Invalid or expired reset link' }` on the new refusal.
- **Guards / roles:** both endpoints stay `@Public()`. No `@Roles`.
- **Route param identity:** `N/A` — neither endpoint takes a path param; both are addressed
  by an emailed opaque token in the body.
- **Errors:**

  | Case | Status | Message |
  | --- | --- | --- |
  | `forgot-password`, any resolution of the email | `200` | `If an account with that email exists, a reset link has been sent.` *(REQ-03)* |
  | `reset-password`, token unknown | `400` | `Invalid or expired reset link` *(existing)* |
  | `reset-password`, token expired | `400` | `Reset link has expired` *(existing, untouched — see REQ-04 notes)* |
  | `reset-password`, user not `ACTIVE` | `400` | `Invalid or expired reset link` — **deliberately identical to the unknown-token case** *(REQ-04)* |

- **Module registration:** one new module, `usecase/portal-invite/` — `PortalInviteModule`,
  importing only `UsersModule`, `NotificationsModule`, `TenantCompaniesModule` (all verified
  free of any path back to `AuthModule`). Imported by `AuthModule` and `InvitationsModule`.
  Barrel `index.ts` in the new folder. Registered transitively, so no `app.module.ts` change
  is required; confirm at boot rather than assuming.

## 5. Web surface — `apps/web`

- **Routes:** none added. `/login` gains a conditional element; `/forgot-password` and
  `/reset-password` are unchanged.
- **Existing components to reuse** *(checked before proposing anything new — mandatory)*:
  the login form already composes `Button`, `Input`, `Checkbox`, `CheckboxFieldLabel`,
  `FormField` from `@/components/ui`, and `next/link` for the existing
  `auth-login-forgot-link`. The affordance is a short block of text plus a `Link` — the
  existing `auth-login-forgot-link` at `login-page-content.tsx:203-209` is the pattern to
  copy for the link itself.
- **New components proposed:** **none.** Inline markup inside `LoginForm`.
- **Table (if any):** `N/A`
- **Forms:** unchanged — no new field, no schema change to `signInSchema`.
- **Server state:** unchanged. The hint reads `signIn.error` from the `useSignIn()` instance
  **already held by `LoginForm`** (`login-page-content.tsx:113`). No new query or mutation.
- **Colors / spacing:** theme variables only, matching the surrounding form.
- **Responsive:** mobile-first; the login form already ships `sm:` breakpoint pairs
  throughout — match them. 44 px touch target for the link.
- **Copy:** `NOT SPECIFIED` — no source gives the wording. AC6 names the two options
  ("request a resend, or 'contact your administrator'"), and REQ-02 makes the first one real,
  so the hint points at `/forgot-password`. See §13.
- **Test IDs:** one new — `auth-login-pending-invite-hint`. Per `contexts/web.md` → *Test
  IDs*, and because `qa-automation/` is outside the pnpm workspace and not an Nx project, so
  no hook or CI job would report a break.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** **none changed.** `app/(auth)/forgot-password.tsx` already posts to
  the same endpoint (`:57`) and renders its own check-your-email view off the 200. After
  REQ-02 a pending user receives an invite mail instead of a reset mail; the screen's
  behaviour and copy are correct for both.
- **Components:** `N/A` — no change.
- **Offline / sync behavior:** `N/A` — no change. `NOT SPECIFIED` by any source for this flow.
- **Touch targets:** `N/A` — no change.
- **Push / notifications involvement:** `N/A` — both mails are EMAIL-only
  (`notification-catalog.ts:51-67`, `defaultChannels: ['EMAIL']` on both entries).
- **Known limitation, not fixed here:** the invite link in the mail points at the web app,
  and there is no reset or accept screen in the app. That is `TCG-27`. This ticket removes
  the *trap* reachable from mobile; it does not give mobile an on-device exit.

## 7. Shared package — `packages/shared`

- **Types added / changed:** **none.**
- **Type that already exists and is deliberately not used here:**
  `packages/shared/src/types/employee.types.ts:16` exports
  `UserPortalStatus = 'ACTIVE' | 'PENDING_INVITE' | 'REVOKED'`, consumed as
  `employee.user.status` by four web call sites
  (`employee-list-cells.tsx:188-203`, `employee-detail-header.tsx:82-127`, which is what
  gates the admin *Resend Invite* button). REQ-06's hint **does not** use it: at the login
  screen there is no authenticated user and no employee record, so the only signal available
  is the error **message** on the failed sign-in. That is a deliberate choice, not an
  oversight — keying the hint off a status the client cannot know would require the login
  endpoint to disclose account state, which REQ-03 exists to prevent.
- **Nothing to add:** the enum already covers all three `UserStatus` values, verified
  identical to `schema.prisma:24-28`. Enumerated by
  `grep -rn "UserPortalStatus\|portalStatus" apps packages --include=*.ts --include=*.tsx`.

## 8. Permissions and tenancy

- **Roles permitted:** unauthenticated, for both endpoints (`@Public()`). Unchanged.
- **Roles denied:** `N/A` — no role gate exists or is added.
- **Tenant isolation:** **deliberately not applied, and this is the sanctioned exception.**
  `findByEmail`, `findByResetToken` and `findByInviteToken` are pre-auth lookups that bypass
  tenant scoping — the repository JSDoc says so at `users.repository.ts:118` and `:277`, and
  `contexts/prisma.md` covers when the `$extends` client extension does not apply. There is
  no tenant context on an unauthenticated request, so there is nothing to scope by.
  `tenantCompanyId` is read **off the found row** solely to address the notification.
- **Cross-tenant reads:** none. A token or email resolves to exactly one `User` row
  (`reset_token` and `invite_token` are `@unique`; email is unique per tenant), and only that
  row's own tenant is touched.
- **New exposure introduced:** none. REQ-01 and REQ-04 both *remove* reachable behaviour;
  REQ-02 sends mail only to the address already on the row.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| `forgot-password` body `email` | unchanged — existing `ForgotPasswordDto` | code `forgot-password.dto.ts` | `[UNVERIFIED]` |
| `reset-password` body `token`, `newPassword` | unchanged — existing `ResetPasswordDto` | code `reset-password.dto.ts` | `[UNVERIFIED]` |
| `user.status` on `forgot-password` | must be `ACTIVE` to mint a reset token; `PENDING_INVITE` diverts to invite; `REVOKED` silently returns | `TCG-82` AC1 | `[UNVERIFIED]` |
| `user.status` on `reset-password` | must be `ACTIVE` | `TCG-82` AC2 | `[UNVERIFIED]` |
| invite-token reuse threshold | `inviteTokenExpiry > now` — reuse; otherwise mint | derived in REQ-02 from `code` (`app.module.ts:156` throttle) + AC1's intent | `[UNVERIFIED]` |
| password strength / history on reset | `NOT SPECIFIED` — no source states a rule, and this ticket adds none | — | — |
| rate limit specific to these endpoints | `NOT SPECIFIED` — only the global 30/min applies. No source asks for a tighter one; REQ-02's token reuse is the mitigation actually chosen | — | — |
| `PENDING_INVITE` row lifetime / expiry | `NOT SPECIFIED` — nothing expires these rows; they accumulate indefinitely. Named in TCG-82 §4 as a fact, not a requirement | — | — |

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit — `auth.service.spec.ts` *(new)* | `forgot-password` mints no reset token for `PENDING_INVITE` or `REVOKED`; diverts to the invite for `PENDING_INVITE`; reuses a live token and mints on an expired one; is unchanged for `ACTIVE` | REQ-01, 02 |
| Unit — `auth.service.spec.ts` *(new)* | `reset-password` throws on a non-`ACTIVE` row with the unknown-token message and never calls the repository write | REQ-04 |
| Unit — `portal-invite-issuer.service.spec.ts` *(new)* | the admin path keeps `requireDelivery: true`; the forgot-password path uses `requireDelivery: false`; `type` and both link strings are exact; a live token is reused with no persist, an expired one mints and persists | REQ-02, 03 |
| Unit — `invitations.service.spec.ts` *(amended)* | the extraction preserved behaviour, including that the issuer's returned token is what gets persisted, and that a required-delivery failure still leaves the `User` row untouched | REQ-02 (U1) |
| E2E — `pending-invite-password-reset.spec.ts` *(new)* | end to end against a live API: pending user's reset request still answers 200 and writes no reset token; a seeded reset token on a pending row is refused and `password_hash` is unchanged; an `ACTIVE` user's reset still works; the login rejection still carries `@AUTH-020`'s copy and now shows the hint | REQ-01, 03, 04, 06, 10 |
| Manual / script | preflight SQL returns a per-tenant census; the remediation script dry-runs and refuses without a policy flag | REQ-09 |

- Requirements with no testable acceptance criterion: **REQ-08** — its acceptance is `OPEN`
  pending Q1. REQ-07 is testable but gets no automated test: it is a `ConflictException`
  string on an authenticated admin endpoint that nothing currently asserts, and adding a
  test that pins admin copy would create the same trap AC6 warns about for `@AUTH-020`.
- **AC10 is not fully achievable in this ticket, deliberately.** It asks for
  `SELECT count(*) … = 0`. REQ-01/04 make new rows impossible, so it is satisfied *going
  forward* by construction; the existing population cannot be cleared until Q1 is answered
  and the script is run. Recorded here rather than ticked.

## 11. Non-functional

- **Performance:** unaffected. The pending branch adds one tenant lookup on a path that
  already does a user lookup and an email send. `NOT SPECIFIED` for any budget.
- **Concurrency:** two concurrent `forgot-password` calls for the same pending user could
  both read "no live token" and both mint, the second overwriting the first — so the first
  mail's link dies. Same shape as the pre-existing `ACTIVE` reset path, where the second
  `setResetToken` invalidates the first mail. Not newly introduced, and the reuse rule in
  REQ-02 makes it rarer than always-rotating would. No locking added.
- **Audit / activity log:** `N/A` — `ActivityLog` is not written by any auth path today, and
  no source asks for it here. Worth naming as a gap, not filling it: a silently-diverted
  password-reset request leaves no audit trail.
- **Migration/rollout order:** API first and alone is safe — REQ-01/02/04/05 are entirely
  server-side and the web and mobile clients need no change to keep working. REQ-06's hint
  is only truthful once REQ-02 ships, so it must not precede it; shipping both in one PR
  makes the ordering moot.

## 11a. Ripple — already-shipped behaviour these requirements reach

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| `qa-automation/.../auth/forgot-password.spec.ts` `@AUTH-006`, `@AUTH-043`, `@AUTH-045` | `POST /auth/forgot-password` response + confirmation copy | REQ-01, 03 | **unchanged** — they use the shared `ACTIVE` login user from `run-context`, and REQ-03 fixes the response byte-for-byte | code `forgot-password.spec.ts:1-60` | `grep -rn "forgot-password" qa-automation/e2e/specs` |
| `qa-automation/.../auth/login-account-status.spec.ts` `@AUTH-019`–`@AUTH-022` | the four login rejection strings, via `expectErrorToast` | REQ-06 | **unchanged** — the API strings are not touched, and the new hint is additive | code `login-account-status.spec.ts:39-110` | `grep -rn "AUTH-020" qa-automation` |
| `qa-automation/.../auth/sso.spec.ts` `@AUTH-072`, `@AUTH-073` | `data-testid="auth-login-error"` text for `?error=` | REQ-06 | **unchanged** — the banner and its `ssoError` path are deliberately untouched | code `sso.spec.ts:9-21` | `grep -rn "auth-login-error" qa-automation apps/web/src` |
| `qa-automation/.../auth/reset-password.spec.ts`, `reset-password-lifecycle.spec.ts` | `POST /auth/reset-password` | REQ-04, 05 | **unchanged** — they exercise `ACTIVE` users, the only status that can still complete a reset | code, file list | `ls qa-automation/e2e/specs/auth` |
| `qa-automation/.../auth/accept-invite.spec.ts`, `accept-invite-lifecycle.spec.ts` | `assertInviteValid`, invite tokens | REQ-02, 05 | **unchanged** — REQ-02 reuses or mints a token the same way `resend()` does; REQ-05 only nulls invite columns on an `ACTIVE` row, which never has them | code, file list | `ls qa-automation/e2e/specs/auth` |
| `apps/api/.../invitations/invitations.service.spec.ts` | `InvitationsService` constructor, positional `as never` mocks | REQ-02 (U1) | **changes deliberately** — arity drops 6 → 5 and the `notify` assertions retarget to the issuer. `tsc` fails loudly rather than mis-binding mocks | code `invitations.service.spec.ts:116-123` | `find apps/api/src -name '*.spec.ts'` |
| `apps/mobile/app/(auth)/forgot-password.tsx` | `POST /auth/forgot-password` | REQ-01, 02, 03 | **unchanged** — same generic 200; a pending user now receives an invite mail instead of a reset mail, which its copy already covers | code `forgot-password.tsx:55-58` | `grep -rn "forgotPassword" apps/mobile` |
| `MicrosoftAuthService` | `activateViaSso`, and its own `PENDING_INVITE` / `REVOKED` guards | REQ-05 | **unchanged** — sets no password; already nulls the invite token on activation | code `microsoft-auth.service.ts:78-99`, `users.repository.ts:266-275` | `grep -rn "PENDING_INVITE" apps/api/src` |
| Admin *Resend Invite* (`invitations.service.ts` `resend`) | `findPendingInviteByEmployeeId`, gated on `portalStatus === 'PENDING_INVITE'` | REQ-02 | **unchanged**, and no longer the only recovery route — REQ-02 gives the `employee_id IS NULL` population a self-serve path it did not have | code `invitations.service.ts:171-247`, `users.repository.ts:133-140` | `grep -rn "findPendingInviteByEmployeeId" apps/api/src` |

| `AdminUsersService.update` (`@Roles(SUPER_ADMIN)`) | wrote `{ role, status }` straight through, never touching `passwordHash` | REQ-04 | **changed deliberately** — moving an account into `PENDING_INVITE` now clears `passwordHash` and `hashedRt`. Sign-in reads a pending row holding a password as one whose owner set it through the reset flow, which is only sound while `PENDING_INVITE` implies no password; every invite branch maintained that invariant and this endpoint did not, so an administrator using the status as a lock would have got one that silently did not hold | `admin-users.status-invariant.spec.ts` | `grep -rn "status: 'PENDING_INVITE'" apps/api/src` |

- **Surfaces with no existing behaviour in this area:** `apps/api` has 133 spec files but
  **none for `AuthService`** — `ls apps/api/src/usecase/auth/*.spec.ts` → no match — so
  `auth.service.spec.ts` is new ground.
  **Baseline to be aware of:** 5 of those 133 suites (9 tests) already fail on
  `origin/main @ cd90f87bc` — `tenant-companies`, `admin-tenants`, `job-tickets`,
  `ticket-labor-entries`, `das-dispatch-packet` — with harness errors of the form
  *"this.tenantCompaniesRepository.findById is not a function"*, i.e. constructor-arity drift
  in their own mocks. None references invitations, portal-invite or auth. **Not this
  ticket's, and not to be "fixed" while passing through.**
  `apps/mobile` has a forgot-password screen but **no** reset or accept screen — established
  by `find apps/mobile/app -ipath '*reset*' -o -ipath '*invite*'`, no match (this is TCG-27).
  `packages/shared` is **not** such a surface: it already exports `UserPortalStatus`, which
  this ticket leaves alone — see §7.
- **Consumers with no source for what happens to them:** **none.** Every row above resolves
  to unchanged or deliberately-changed, with its source.

## 12. Open questions — the stop-and-ask list

### Q1 — Does a completed password reset satisfy the invitation? — **resolved**

- **Question:** When a `PENDING_INVITE` user has completed a password reset, does accepting
  that password and activating them satisfy the invitation — they did prove control of the
  mailbox via the emailed, single-use, 24-hour reset token — or must they still go through
  accept-invite?
- **Why it could not be answered from what is written:** the invite/activation lifecycle has
  never been ratified. `PENDING_INVITE` appears once in the whole vault, and about quotation
  approvers, so no document says what an invitation is *for*, which is what the question
  turns on. The two adjacent open gaps do not answer it:
  `payroll/gaps.md` → *Employee-module rules … PR #488* item (c) asks whether the lifecycle
  itself is right (open, 2026-09-07), and `admin/gaps.md` → *Sign-in identity* asks whether
  field employees sign in by email at all (open, 2026-09-15).
- **Blocked:** the shape of REQ-01 and REQ-04, and all of REQ-08.
- **Owner:** product — Corrina Bustos / Brian Petros were the named owners on the register.
- **Status:** **resolved 2026-09-25 — see
  `decisions/2026-09-25-password-reset-accepts-a-pending-invitation.md`.** A completed reset
  accepts the invitation and activates the account, because the reset token proves control of
  the same mailbox the invite link would. Signing in with a password that already works
  accepts it too. That also dissolves REQ-08: a stranded row repairs itself on next sign-in.
- **Also filed at:** `.ai/vault/admin/gaps.md`, likewise resolved.

## 13. What this spec deliberately does not specify

- **Which repair the already-stranded rows get** — no source; see Q1 and REQ-08.
- **The wording of the login hint** — no source gives copy. AC6 names two options and REQ-02
  makes the first real, so the executor writes the shortest truthful sentence. Not elevated
  to an open question: it is copy for an affordance product asked for, not an undecided
  behaviour.
- **Whether `PENDING_INVITE` rows should expire.** Nothing expires them; they accumulate
  indefinitely, which is why the exposed population grows without bound. Named in TCG-82 §4.
  No source asks for a TTL and this spec does not invent one.
- **Whether the invite lifecycle is right at all** — 64-character token, rotate on resend,
  null on revoke, re-invitable after. All shipped, all `status: unverified`, asserted by the
  E2E suite with no written source. `payroll/gaps.md` item (c), open. **This fix hardens that
  unratified lifecycle further**, which is a cost worth naming: `forgot-password` becomes a
  fourth caller of invite semantics nobody has approved.
- **Whether email is the right sign-in identity for field employees at all** —
  `admin/gaps.md:1170`, open. If field staff move to phone + SMS, this pair of endpoints is
  not their onboarding path. The fix is still correct for the office population and today's
  shipped mobile sign-in; it must not be read as settling field onboarding.
- **A tighter rate limit on either endpoint** — only the global 30/min applies. REQ-02's
  token reuse is the mitigation chosen instead. No source asks for more.
- **An audit trail for a diverted reset request** — see §11.
- **Uniform messaging for a caller who already holds a token** — `Reset link has expired`
  and `Invitation link has expired` still distinguish expired from unknown. Pre-existing,
  narrower channel, out of scope; see REQ-04 notes.

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person —
      **REQ-08's blocking question is Q1, answered 2026-09-25.** The answer dissolves the
      requirement rather than deciding it: a stranded row repairs itself on next sign-in.
- [x] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` — none.
- [x] Answers written back into `spec.md` with their new sources and flags — §0a maps every
      requirement to whether it ships, and REQ-01/04's re-aiming cites Q1.
- [x] Every §12 question updated to `Status: resolved — see decisions/…` — Q1 points at
      `decisions/2026-09-25-password-reset-accepts-a-pending-invitation.md`.
- [x] Every §11a ripple row has a source for what happens to that consumer, or a §12 question.
- [x] Decomposed — `units.md`. One unit; the spec's other requirements are not built.

Answered by: Syed Haris — Q1, 2026-09-25, recorded in
`decisions/2026-09-25-password-reset-accepts-a-pending-invitation.md`.

# Units — TCG-82 An invited user can set their own password

> From `spec.md` beside this file.
>
> **One unit.** The spec elaborated the full remedy the ticket asked for, but Q1's answer —
> that completing a password reset accepts the invitation — collapsed most of it. There is
> no invite to re-send in place of the reset, no repair script for the stranded rows, and no
> new web component, because the API change alone gives the user a working route in and
> heals the existing population. `spec.md` §0a maps every requirement to whether it ships.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | An invited user who never accepted can set their own password and get in by doing so — through *Forgot password*, or by signing in with a password they already hold | REQ-01, 03, 04, 05, REQ-06 in substance, part of REQ-10 | api, tests | — | S | **built** |

- **Requirements not covered:** REQ-02, REQ-07, REQ-09 — specified, not built, reasons in
  `spec.md` §0a. REQ-08 is dissolved rather than skipped: the rows it addressed repair
  themselves.
- **Units blocked on an open question:** none. Q1 is answered.

---

## U1 — An invited user can set their own password

- **Outcome:** Someone invited to the portal who never opened the invite email can get in
  under their own steam: *Forgot password* sends them a reset, completing it activates them,
  and if they already hold a working password, simply signing in activates them. The
  "Password reset successful" screen can no longer be followed by a refusal at sign-in.
- **Kind:** vertical — api-only, but end to end for the behaviour. Nothing in web or mobile
  has to change for a person to do this.
- **Requirements covered:** REQ-01, REQ-03, REQ-04, REQ-05 fully; REQ-06 in substance;
  REQ-10's unit half plus the live-suite update.
- **Depends on:** —

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | none | `N/A` — no DDL, no migration |
| API — `usecase/auth/auth.service.ts` | `forgotPassword`: `if (user.status === 'REVOKED') return;` | A revoked account is refused at sign-in before its password is compared, so a reset link leads nowhere. Pending accounts **are** allowed through. A `return`, never a `throw` — the endpoint's constant 200 is what prevents email enumeration |
| API — same file | `resetPassword`: refuse `REVOKED`, with the message the unknown-token case uses | Placed after the expiry check and **before** `bcrypt.hash`, so a refused request never touches the stored password |
| API — same file | `resetPassword`: `PENDING_INVITE` → `completePasswordSet(...)` instead of `resetPassword(...)` | Sets the password, sets `ACTIVE`, and retires every other invite credential. Same write the mobile field flow activates with — nothing new was added for it |
| API — same file | `authenticateAndIssueTokens`: pending guard narrowed to `PENDING_INVITE && !user.passwordHash`, copy naming both routes | A pending account holding a working password is activated by using it, not refused. The copy change is REQ-06 in substance |
| API — same file | `authenticateAndIssueTokens`: after a successful compare, `PENDING_INVITE` → `acceptInviteByPasswordSignIn(user.id)` | Signing in settles the invitation — and heals the rows stranded before a reset began activating |
| API — `service/users/users.repository.ts` | new `acceptInviteByPasswordSignIn` | Sets `ACTIVE`, clears `inviteToken`/`inviteTokenExpiry`/`tempPasswordHash`/`tempPasswordExpiresAt`, preserves `inviteAcceptedAt`. Leaves `passwordHash` (already correct) and `hashedRt` (the caller is about to store one). Not a reuse of `activateViaSso`, which does **not** clear the SMS temp password |
| API — `usecase/admin/admin-users.service.ts` | moving an account into `PENDING_INVITE` clears `passwordHash` and `hashedRt` | Found reviewing this unit for security regressions. Sign-in's new reading of a pending row is only sound while `PENDING_INVITE` implies no password; every invite branch kept that invariant and this endpoint did not |
| Web (`apps/web`) | none | `N/A` — REQ-06 is met by the API copy |
| Mobile (`apps/mobile`) | none | `N/A` — same endpoint, same generic 200. A field worker who set a real password is now activated by using it, the same rule applied consistently |
| Shared (`packages/shared`) | none | `N/A` — `UserPortalStatus` already exists and is untouched |
| Tests | new `usecase/auth/password-reset-account-status.spec.ts` — 13 cases | Both reset guards, the reset activation, the sign-in activation, the pending-with-no-password refusal, and the `ACTIVE` and `REVOKED` paths they must not disturb |
| Tests | new `usecase/admin/admin-users.status-invariant.spec.ts` — 3 cases | The clear on `PENDING_INVITE`, no clear on `REVOKED`, no clear on a role-only change |
| Tests | `qa-automation/.../auth/login-account-status.spec.ts` amended | `@AUTH-020` changed meaning, not just copy — see *Ripple* |

### Reviewable as

- **Demo:** invite an employee and do not open the invite email. *Forgot password* with their
  address → reset mail arrives; complete it → *"Password reset successful"*; sign in → in,
  and the row is `ACTIVE` with `invite_token` cleared. Separately, seed a pending row that
  holds a password and sign in with it → in, and the row heals the same way. Then confirm an
  `ACTIVE` user's reset still works, and that a revoked account is refused on both endpoints.
- **Acceptance:** `spec.md` REQ-01, 03, 04, 05 acceptance lines, plus REQ-06 read as the
  rejection copy naming both routes.
- **Reviewer can verify without:** a real tenant, a real mailbox (the reset token is readable
  from the row), or any web change.

### Risk

- **Weakest source:** `[UNVERIFIED]` — jira plus the code that establishes today's behaviour,
  with Q1's answer as the product direction.
- **Migration reversible:** `N/A` — no migration. The code is a plain revert.
- **Behind a flag:** no. A flag on an enumeration-sensitive branch would mean two response
  shapes to keep byte-identical instead of one.
- **Touches existing data:** **only as a side effect of a user signing in.** No script, no
  backfill, no scheduled write. A stranded row changes when its owner next authenticates.
- **Blast radius:** the guards sit on the path *every* password reset and *every* sign-in
  takes, so the regression to watch is an `ACTIVE` user breaking — the population that could
  already do both. That is why the `ACTIVE` and `REVOKED` cases are named tests rather than
  assumed. Second: this loosens an authentication guard, so the invariant it rests on
  (`PENDING_INVITE` ⇒ no password) is load-bearing; the admin-path fix and its spec exist to
  keep it true.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `POST /auth/forgot-password`, `ACTIVE` user | `forgotPassword` | `password-reset-account-status.spec.ts` — token minted, mail sent | `spec.md` REQ-01 |
| `POST /auth/reset-password`, `ACTIVE` user | `resetPassword` | same spec — completes through `resetPassword`, not the activation path | `spec.md` REQ-04 |
| Web sign-in, `ACTIVE` user | `authenticateAndIssueTokens` | same spec — signs in, nothing accepted | `spec.md` REQ-04 |
| `qa-automation` `@AUTH-020` | the pending rejection copy **and its fixture** | **amended in this unit.** Its fixture held a password, which now signs in, so it gains `withoutPassword: true` — load-bearing, noted in the file header — and a new case covers the pending account that does hold one, asserting the dashboard and an `ACTIVE` row with the invite token cleared | ticket AC6's own warning |
| `qa-automation` `@AUTH-019`, `@AUTH-021`, `@AUTH-022` | the other three rejection strings | untouched; the full `e2e/specs/auth/` run is the proof | `spec.md` §11a |
| `qa-automation` `@AUTH-006`, `@AUTH-043`, `@AUTH-045` | the endpoint's constant 200 body | **not proven here** — needs a live API. Unchanged by construction: every new branch returns rather than throws | `spec.md` REQ-03 |
| Mobile phone sign-in (`signInWithPhone`) | falls through to `authenticateAndIssueTokens` after its own temp-password branch | `sign-in-with-phone.spec.ts`, unchanged — its cases use `tempPasswordHash`, a different field and a different branch which throws on mismatch before the fallthrough | `spec.md` §11a |
| Mobile field activation (`/auth/field/password/set`) | the same `completePasswordSet` write | `field-credentials.service.spec.ts`, unchanged — this unit adds a second caller, it does not alter the method | `spec.md` REQ-05 |
| `AdminUsersService.update` | `{ role, status }` written straight through | `admin-users.status-invariant.spec.ts` | `spec.md` §11a |
| `apps/mobile/app/(auth)/forgot-password.tsx` | the same endpoint | none — no mobile suite covers it; protected by the response staying byte-identical | `spec.md` §6 |

### Deliberately not in this unit

- A web login affordance. REQ-06 is met by the API copy instead; a component would duplicate
  advice the user already sees.
- Re-sending the invite from `forgot-password` (REQ-02) — unnecessary once the reset admits
  the user.
- A census or repair script (REQ-08, REQ-09) — the rows heal on next sign-in.
- The admin invite conflict copy (REQ-07) — text on an authenticated admin response, no
  behaviour, and nothing asserts it.
- Expiring stale `PENDING_INVITE` rows, and the `accept-invite` "expired vs unknown"
  distinction — `spec.md` §13.
- Anything mobile — `TCG-27`.

## Sequencing

One unit. Four commits in order: the reset guards; the reset activation; the sign-in
acceptance with the copy fix; the admin invariant that the security review of the third one
turned up.

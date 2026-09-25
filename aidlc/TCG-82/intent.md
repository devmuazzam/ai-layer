# Intent — TCG-82

> First ticket folder named for a **Linear** id. Every earlier folder is `SCRUM-###`, from
> the Jira era; the tracker moved to Linear (`the-crane-guys` workspace) and the UAT
> remediation cards are numbered `TCG-##`. Same layout, same templates.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `TCG-82` |
| Title | Password reset succeeds for a pending-invite user, then login refuses them — the one path that sets a password without activating |
| Type | Bug |
| Status | Todo (moved from Backlog 2026-09-21) |
| Epic | `TCG-15` — parent; milestone *UAT remediation*, project *TCG Platform* |
| Sprint | cycle `59bc567d-5a93-4e8b-b556-5815b5dd5443` |
| Reporter | syed haris |
| Assignee | Fouzan Shakil |
| Captured on | `2026-09-22` |
| Captured by | Claude Opus 5, session for Syed Haris |

Labels: `backend`, `admin`, `Bug`. Priority High. Related: `TCG-27` (password reset cannot
be completed on the mobile app — no reset screen). No Linear comments, no attachments.

## 2. Business intent

A crane company's office staff and field employees reach the portal through an emailed
invite. When someone on an unaccepted invite tries the *Forgot password* flow instead — the
remedy staff generalise from the platform's own advice — the reset **completes**, tells them
"Password reset successful", and then login refuses them. They cannot get in, and the
password they chose is silently discarded by whichever recovery route is eventually used.
The business outcome is an employee who cannot be onboarded onto the platform without an
admin correctly diagnosing a state the UI never names.

- Intent: make the *Forgot password* request produce the mail that actually lets the person
  in, and make it impossible for a password reset to leave the success screen and the login
  screen contradicting each other.
- Who benefits (role): any invited portal user — office staff and field crew — plus the
  admin who would otherwise have to diagnose it. The DAS temp population is named in the
  originating UAT session.
- What is worse today without it: an invited user who uses *Forgot password* is stranded
  behind a contradiction, and staff have no signal that a reset is a no-op for them.

## 3. Definition of done, as the ticket states it

Quoted from the Linear description, §6 *Acceptance criteria*, verbatim:

```
**Forward fix**

1. `forgot-password` **does not send a reset mail to a non-**`ACTIVE` **user** — and still
returns 200 with no body change, because `auth.service.ts:210-211` guarantees no email
enumeration. **Instead, for a** `PENDING_INVITE` **user, re-send the invite email** with a
rotated token, so the request the user made produces the mail that actually helps them.
2. `reset-password` **rejects a token belonging to a non-**`ACTIVE` **user** before hashing.
The message must not distinguish "pending" from "invalid" to an unauthenticated caller.
3. **Belt and braces:** `resetPassword` additionally clears `inviteToken` /
`inviteTokenExpiry`, so a reset and an invite can never both be live on one row. Update its
JSDoc.
4. **API unit tests:** forgot-password on a `PENDING_INVITE` user does not mint a reset
token; reset-password with such a token throws and leaves `password_hash` unchanged.
5. **E2E beside the existing** `login-account-status.spec.ts`, using the disposable-user seed
helper: request a reset on a pending user → assert the designed outcome (login succeeds, or
the reset is refused and the user is pointed at the invite). Ship `data-testid`s for any new
copy.

**Copy and discoverability**
6. The login rejection stays, but **web login surfaces an actionable affordance next to it**
(request a resend, or "contact your administrator"). ⚠️ `@AUTH-020` **asserts that exact
string — update** `login-account-status.spec.ts` **in the same commit if it changes.**
7. **Amend the** `ACTIVE`**-branch copy so it cannot be generalised** — e.g. "…already has
portal access. If they cannot sign in, have them use Forgot password. (A password reset does
not work for a pending invite — use Resend Invite.)" Additive, no behaviour change.

**Remediation of users already stranded — ships with the fix, not after**
8. **An idempotent one-off script** for every row matching the first query above: **either
(a)** set `status = 'ACTIVE'`, honouring the password the user already set — the least
surprising outcome, since they were told it worked — **or (b)** null `password_hash` and
resend the invite. **(a) vs (b) is a product call, not an engineering one — see below.**
9. The script **logs affected rows per tenant before writing**, and re-running it is a no-op.
10. **Post-remediation:** `SELECT count(*) … = 0`**, and it stays 0 after the E2E suite runs.**
```

- Acceptance criteria present on the ticket: **yes** — ten, numbered, with the ripple
  warnings inline.

The originating UAT ask, quoted in full (`uat/sessions/uat-session-5.md:30`, under `### DAS`):

```
* **Password Reset:** An issue occurs when resetting the password: "Invitation link not
accepted or invalid."
```

## 4. In scope

- [ ] `forgot-password` stops minting a reset token for a non-`ACTIVE` user, and sends the
      portal invite instead for a `PENDING_INVITE` user (AC1)
- [ ] `reset-password` refuses a token belonging to a non-`ACTIVE` user, before hashing,
      with a message indistinguishable from an invalid token (AC2)
- [ ] `UsersRepository.resetPassword` also clears `inviteToken` / `inviteTokenExpiry` (AC3)
- [ ] API unit tests for both paths (AC4)
- [ ] E2E beside `login-account-status.spec.ts` (AC5)
- [ ] An actionable affordance next to the pending-invite login rejection on web (AC6)
- [ ] The `ACTIVE`-branch invite copy amended so it cannot be generalised (AC7)
- [ ] An idempotent, logging, flag-gated remediation script plus its preflight SQL (AC8, AC9)

## 5. Out of scope

- [ ] A password-reset screen on mobile. That is `TCG-27`; these two compound but ship apart.
- [ ] Repairing the dead inline login error banner
      (`login-page-content.tsx:148` — `LoginPageContent` and `LoginForm` hold separate
      `useSignIn()` instances, so its `isError` never flips for a credential failure). A
      reader would reasonably assume AC6's affordance lands there; the ticket does not say so.
- [ ] Expiring stale `PENDING_INVITE` rows. Nothing expires them today; they accumulate.
- [ ] Uniforming the remaining "expired vs unknown" distinction on `reset-password` and
      `accept-invite` for a caller who already holds a token. Pre-existing, narrower channel.
- [ ] The `SUPER_ADMIN` create-user DTO accepting `PENDING_INVITE`, which is how a pending
      user with no linked `Employee` becomes creatable.

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | yes | `AuthService.forgotPassword` + `.resetPassword` gain status branches; `UsersRepository.resetPassword` clears the invite token; invite-mail issuing extracted to a new `usecase/portal-invite/` module so `AuthService` can send an invite without a module cycle; one `ConflictException` string amended |
| `apps/api/prisma` (schema + migration) | no | No schema change. The remediation script is a data script under `prisma/scripts/`, not a migration |
| `apps/web` (Next.js) | yes | One conditional hint beside the login form, with a `data-testid` |
| `apps/mobile` (Expo Router) | no | Calls the same endpoint and gets the same generic 200; the mail it now receives is the invite. No code change |
| `packages/shared` (types shared across apps) | no | No shared type moves |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `User` | `N/A` — no business code; identified by `id` (uuid) and per-tenant unique `email` | reads `status`, `passwordHash`, `resetToken`, `resetTokenExpiry`, `inviteToken`, `inviteTokenExpiry`; writes the latter four |
| `Employee` | `employeeCode` / `EMP-#####` | `N/A` for the new path — the forgot-password branch resolves nothing through `Employee`. Read only by the pre-existing admin invite/resend flows this ticket refactors |
| `TenantCompany` | `N/A` | reads `name` for the invite email's `tenantName` |

- New entity introduced by this ticket: no
- New code prefix introduced: no
- Existing rows affected (backfill / migration of data, not just schema): **yes** — rows at
  `status = 'PENDING_INVITE' AND password_hash IS NOT NULL`. Count unknown; no DB access in
  this pass. Remediated by a flag-gated script, not by a migration, and not in this pass.

## 8. Roles and permissions

- Roles that can perform this: **unauthenticated**. Both `POST /auth/forgot-password` and
  `POST /auth/reset-password` are `@Public()`. That is the point of the enumeration
  guarantee and the reason every new branch must return an identical response.
- Roles explicitly excluded: `N/A` — no role gate on either endpoint.
- Tenant scope: **not tenant-scoped, deliberately.** These are pre-auth lookups; the
  repository methods `findByResetToken` / `findByInviteToken` / `findByMicrosoftId` carry
  `bypasses tenant middleware (pre-auth operation)` in their JSDoc. `tenantCompanyId` is
  read *off the found user* to address the notification, never used to scope the lookup.

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | `NOT ON TICKET` — no visual design. AC6's affordance has no mockup |
| Jira attachments | `N/A` — Linear ticket, no attachments |
| Related tickets | `TCG-27` — mobile has no reset screen, so this trap is reachable from the phone with no on-device exit; the two compound. `TCG-15` — parent |
| Existing repo docs | `.ai/claude/contexts/api.md`, `.ai/claude/contexts/web.md` (*Test IDs*), `.ai/claude/contexts/prisma.md` |
| Vault area the reader thinks is relevant | `admin/` — users and invitations are that module's per `vault/STRUCTURE.md`. The ticket also points at `payroll/gaps.md` item (c), where the invite-lifecycle question is filed whole |

## 10. Terms used that may not be defined

- `das` — used on the ticket only as the UAT session's heading (`### DAS`), which is where
  the ask was recorded; the defect is not DAS-specific. One of the nine known-undefined
  terms.
- `PENDING_INVITE` — a `UserStatus` enum value. Used throughout the ticket as though its
  lifecycle were specified. It is not: the ticket itself records that `PENDING_INVITE`
  *"appears once in the whole vault, about quotation approvers"*, and that the entire
  invite/activation lifecycle is `status: unverified` shipped behaviour.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| 72 hours — invite token TTL | `code` — `INVITE_TOKEN_TTL_MS` at `invitations.service.ts:24`. The ticket cites it as shipped behaviour, not as a requirement |
| 24 hours — reset token TTL | `code` — `auth.service.ts:215`. Not restated as a requirement; unchanged by this ticket |
| 64 characters — invite token length | `NOT ON TICKET — no origin cited` for the requirement. `code` shows `crypto.randomBytes(32).toString('hex')` = 64 hex chars. `payroll/gaps.md` item (c) records the number as **asserted by the E2E suite with no written source** |
| `ACTIVE` / `PENDING_INVITE` / `REVOKED` — the `UserStatus` values the branches switch on | `code` — `schema.prisma` enum, and the guard at `auth.service.ts:107-116`. The ticket enumerates them from the code, and says so |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: **2** — §9 design handoff (AC6's affordance has no
  mockup); §11 the 64-character token requirement's origin.
- Fields left as `OPEN`: **0** in this file. The ticket's own §7 open question is carried
  into `spec.md` §12 as Q1 rather than restated here.
- Is this ticket, as written, buildable without a product answer? **Partly.** The shape of
  the forward fix depends on the ticket's own §7 question — whether completing a reset
  satisfies the invitation — because that decides whether a reset may activate a user at
  all. **AC8 is not buildable without it either**: (a)-activate vs (b)-reinvite is the same
  question applied to the rows already stranded. **AC10 presumes AC8**, since it asserts a
  post-remediation count of zero.
- If no, the blocking questions are: the ticket's §7 — *when a pending-invite user has
  completed a password reset, does accepting that password and activating them satisfy the
  invitation, or must they still go through accept-invite?* Carried into `spec.md` §12 Q1
  and appended to `.ai/vault/admin/gaps.md`. Owner: product — Corrina Bustos / Brian Petros.

---

**Next step:** `spec.md` beside this file.

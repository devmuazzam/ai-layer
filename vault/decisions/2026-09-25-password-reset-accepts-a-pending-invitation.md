---
title: A completed password reset accepts a pending invitation (Syed Haris, 2026-09-25) — decision
source: decision/Syed Haris — answering admin/gaps.md *What does accepting a portal invitation attest…* and `.ai/aidlc/TCG-82/spec.md` §12 Q1
decided: 2026-09-25
decided_by: >-
  Syed Haris, in session while reviewing TCG-82. The register entry named
  Corrina Bustos and Brian Petros as owners, so this is a CodingCops-side
  ruling on shipped behaviour rather than a TCG client sign-off — hence
  `status: reference`. It is open to being overruled by TCG, and the part
  most worth their attention is named under *What this does not settle*.
status: reference
conflicts_with: []
resolves:
  - admin/gaps.md#what-does-accepting-a-portal-invitation-attest-and-may-a-password-reset-ever-substitute-for-it
tags: [module/admin, kind/decision, auth, invitations]
entities: [User]
---

# A completed password reset accepts a pending invitation

## The decision

**A user who has been invited but never accepted may use *Forgot password*, set a password,
and become `ACTIVE` — exactly as though they had accepted the invitation.**

**And signing in with a password that already works accepts the invitation too.** A pending
account cannot hold a working password unless it set one through the emailed reset flow or an
administrator set one for it, so presenting that password settles the invitation on its own.

The reasoning is what the reset token already proves. It is emailed to the address on the
invitation, it is single-use, and it expires in 24 hours. Accepting an invite proves control
of that same mailbox with a token that is emailed, single-use and expires in 72 hours.
There is no additional fact the invite link establishes, so requiring it as well is
ceremony, and the cost of the ceremony was a user locked out of the platform.

## What the platform does

| Account state | *Forgot password* | Completing the reset |
| --- | --- | --- |
| `ACTIVE` | reset link emailed | password set; unchanged from before |
| `PENDING_INVITE` | **reset link emailed** | **password set and the account activated** |
| `REVOKED` | **nothing sent**, response unchanged | **refused**, message identical to an unknown token |

At sign-in:

| Account state | Signing in |
| --- | --- |
| `PENDING_INVITE`, **no** password on the row | refused — *"You have a pending invitation. Accept the invite email to set your password, or use Forgot password to set one now."* Both routes named, because a reset now works and the invite email may well have lapsed |
| `PENDING_INVITE`, password matches | **signed in, and the invitation is accepted** |
| `PENDING_INVITE`, password does not match | `Invalid credentials`, nothing accepted |
| `REVOKED` | refused, before the password is compared |

The pending guard is therefore **conditional** on the account having no password, and the
acceptance happens *after* the password compare — never on a failed attempt. This is why
`withoutPassword: true` is load-bearing on the `@AUTH-020` fixture: without it that test now
signs in rather than seeing a message.

Activation goes through `UsersRepository.completePasswordSet`, the same write the mobile
field flow activates with. That matters for a reason beyond reuse: it retires **every** other
invite credential on the row —

- the **invite token**, which would otherwise still be live and, when the original email was
  eventually clicked, would overwrite the password the user had just set;
- the **SMS temporary password** (`tempPasswordHash`), which would otherwise remain usable
  beside the new real password for anyone still holding the text;
- `hashedRt`, so other sessions are signed out;

and it stamps `inviteAcceptedAt`, so the account's history reads the same as one that came
in through the invite link.

`REVOKED` is refused with the *same* message as an unknown token, deliberately: to an
unauthenticated caller holding a token, "revoked" and "no such token" must not be
distinguishable. `forgotPassword` returns rather than throws on every branch, because the
endpoint answers a constant `200` specifically to prevent email enumeration — a branch that
threw would turn that into an error for one account state alone.

## The invariant this rests on

Sign-in reads a pending account that holds a password as one whose owner is entitled to it.
That is only true while **`PENDING_INVITE` implies no password**, which every invite branch
in `InvitationsService` maintains — all four write `passwordHash: null` beside the status.
`AdminUsersService.update` was the one place that could write the status without going
through an invite, and did not clear the hash; it now does, so an administrator cannot
create a pending row carrying someone's old password. `REVOKED` is the way to withdraw
access from an account that keeps its password, and is refused at sign-in before the
password is compared.

Anything added later that sets `PENDING_INVITE` must clear `passwordHash` with it.

## What this does not settle

- **Whether the invite link remains necessary at all.** It is still the primary path and
  nothing here changes it. If a reset is a sufficient acceptance, *accept-invite* is
  arguably a convenience rather than a gate — that framing is not adopted here and should
  be put to TCG if it matters for audit.
- **The users already stranded** by the original defect — rows at `PENDING_INVITE` with a
  password hash, written before any of this. Their count has never been measured, and it no
  longer needs to be: **they repair themselves the next time they sign in**, because the
  password they were told was set does work and now activates them. That is the sign-in half
  of this decision doing the job the repair script TCG-82 contemplated, without a DB write
  anyone has to schedule.
- **Whether email is the right onboarding identity for field crew at all** —
  [admin/gaps.md](../admin/gaps.md) *Sign-in identity*, still open. If field staff move to
  phone and SMS, this pair of endpoints is not their path. This decision is correct for the
  office population and for today's shipped behaviour, and must not be read as settling
  field onboarding.

---
title: The tenant timezone is set once at creation and never edited — decision
source: decision/Syed Haris
decided: 2026-09-09
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — developer/owner directing the `SCRUM-TZ` /
  `fix/timezone-business-day` work; stated directly in a working session on 2026-09-09, as the
  fifth and last of the day's timezone decisions, closing the question the fourth one opened.
  He is **not** the client-side product owner, and the owners this question is nominated to have
  not spoken to it: `SCRUM-TZ/spec.md` §12 Q10 names **Corrina Bustos** (payroll) *"with the
  product team on whether the edit is refused"*, and `../assets/gaps.md` → *The fleet day* names
  **Brian Petros**, *"Corrina Bustos if it must line up with payroll."* `status: reference`
  rather than `verified` for that reason — binding on implementation now, open to being
  overruled by TCG. Identical basis and the same precedent chain as
  `2026-09-09-business-timezone-is-a-tenant-property.md`,
  `2026-09-09-business-day-starts-at-midnight-local.md`,
  `2026-09-09-tenant-timezone-configuration.md`,
  `2026-09-09-fleet-timezone-retired-onto-tenant-zone.md`,
  `2026-09-08-artifact-due-date-seeded-from-first-job-day.md` and
  `2026-09-01-subsistence-not-a-craft-attribute.md`.
status: reference
conflicts_with: []
resolves: [SCRUM-TZ/spec.md#q10--what-happens-to-an-open-payroll-period-when-a-tenants-timezone-changes]
jira: []
tags: [module/admin, module/payroll, module/all, kind/decision, time-tracking, reference-data, architecture, requirements]
---

# The tenant timezone is set once, at creation, and never edited

> *"tenant timezone will not be changed."* — Syed Haris, in session, 2026-09-09

The fifth and last of the day's timezone decisions, and the only one that **removes** a
capability the previous four assumed. The chain reads:
[the zone is a tenant property](2026-09-09-business-timezone-is-a-tenant-property.md) (grain) →
[the day starts at 00:00 local](2026-09-09-business-day-starts-at-midnight-local.md) (boundary) →
[how that zone is configured and displayed](2026-09-09-tenant-timezone-configuration.md)
(mechanics) →
[`FLEET_TIMEZONE` is retired onto it](2026-09-09-fleet-timezone-retired-onto-tenant-zone.md)
(convergence) → **this note** (the zone is immutable).

It answers `SCRUM-TZ` §12 **Q10**, and it **partially supersedes item 4 of the mechanics
note** — see *What this supersedes* below, which is the section to read if the two notes look
like they disagree.

## Decision

### 1. The zone is chosen once, at tenant creation, and there is no product surface to change it

`TenantCompany.timezone` is written by the creation path and by nothing else. No endpoint, no
screen, no admin action edits it afterwards. This is a **product constraint**, not an
unbuilt feature waiting on a later ticket.

### 2. `PATCH /admin/tenants/:id` never accepts `timezone` — cut, not deferred

[`UpdateAdminTenantDto`](../../../apps/api/src/presentation/admin/dto/update-admin-tenant.dto.ts)
**stays exactly as it is** — `name?`, `tenantCode?`, `status?`, `maxUsers?`, `domain?`,
`plan?`, and no zone. Verified 2026-09-09 by reading the file: the six fields above are its
entire contents.

The enforcement is already in place and needs no new code, which is worth recording because it
means *doing nothing* is the correct implementation rather than a gap:

- [`admin-tenants.controller.ts`](../../../apps/api/src/presentation/admin/admin-tenants.controller.ts):60
  binds `@Patch(':id')` to `UpdateAdminTenantDto`, under the class-level
  `@Roles(Role.SUPER_ADMIN)` at :13.
- [`main.ts`](../../../apps/api/src/main.ts):68–70 configures the global `ValidationPipe` with
  `whitelist: true` **and `forbidNonWhitelisted: true`**. A `timezone` key in a PATCH body is
  therefore a **400, not a silent strip** — the caller is told the field is not accepted rather
  than believing the change landed. That distinction is the whole safety of item 1: a silently
  discarded zone change is indistinguishable, from the admin's side, from a successful one.
- Web has no edit surface to remove either.
  [`apps/web/src/features/admin/types/index.ts`](../../../apps/web/src/features/admin/types/index.ts):86
  `UpdateTenantPayload` carries no `timezone` (while `CreateTenantPayload` at :73 requires it),
  and `apps/web/src/features/admin/components/` contains
  `admin-create-tenant-modal.tsx` with **no** `admin-edit-tenant-modal.tsx` — verified by
  listing the directory. The creation modal is the only tenant-zone UI that exists.

So this decision authorises **no code change at all**. It converts a deliberate omission into a
recorded intent, which is the difference between a constraint and an oversight.

### 3. Q10 is **moot**, not answered — and the distinction is load-bearing

`SCRUM-TZ` §12 Q10 asked what happens to an **open payroll period** when a tenant's zone
changes: is the period **re-dated** under the new zone, **frozen** under the old one, or is the
change **refused**? None of the three is chosen here. The situation the question describes
**cannot arise**, so there is nothing to choose between.

State it that way rather than writing "resolved: refused", because the two are not the same
record:

- *Answered* would mean someone weighed re-dating against freezing against refusal and picked
  one. **Nobody did.** The analysis in Q10 — that moving the zone under an open period moves
  shifts between payroll weeks, which changes the straight-time ceiling they consume, and
  therefore money — is still entirely un-adjudicated.
- *Moot* means the premise was removed. If the constraint in item 1 is ever lifted — a tenant
  relocates, an onboarding error has to be fixed in product rather than in the database, or a
  second zone is ever admitted against the grain decision's recorded single-zone constraint —
  **Q10 comes back exactly as it was written, unanswered, and blocks the edit path again.**
  Whoever lifts the constraint inherits the original question, not a precedent.

The spec's own interim workaround for Q10 (*"refuse the change while any period is open, and
say so in the error"*) is likewise **not** what was decided. It was the safe fallback for a
world where the edit path exists. There is no edit path, so there is nothing to refuse and no
error to word.

## Why

**The question disappears rather than being answered.** Q10 is genuinely hard — it is money,
it is retroactive, and its named owner (Corrina Bustos) has not spoken to it. Every available
answer has a real cost: re-dating silently restates already-computed pay; freezing leaves a
period computing in a zone the tenant no longer claims; refusing makes a SUPER_ADMIN action
fail for reasons that are invisible from the admin screen. Removing the capability removes all
three costs at once, and it is the only option that does not require a payroll ruling nobody
has given.

**A tenant's zone is not a preference.** It is where the business physically operates — where
the crane was. The grain decision already recorded that business-day decisions *"follow the
**work location**, never the viewer."* A company does not change the state it operates in;
if it genuinely does, that is a new operating reality large enough to deserve an operator
touching the database deliberately, not a dropdown someone can nudge on a Tuesday.

**Immutability is the cheap side of an asymmetry.** Adding an edit path later is a
straightforward change: a DTO field, a validator that already exists (the runtime
`Intl.DateTimeFormat` probe from the mechanics note item 1), and an answer to Q10. Removing one
after tenants have used it is not — by then there are periods computed under old zones and no
record of when each changed. Ship the reversible direction.

## The consequence, stated here rather than discovered later

**A tenant onboarded with the wrong zone has no in-product correction path and needs a database
fix.** Not a support action, not a SUPER_ADMIN action — a hand-written `UPDATE` against
`tenant_companies`, by someone with production database access, outside every audit trail the
application keeps.

That is **the price of this decision, not an argument against it**, and it is recorded because
it is the thing a support conversation six months from now will run into with no context. Two
properties of that fix are worth knowing in advance:

- It is **not** a safe operation in general. Everything Q10 warned about applies to the manual
  `UPDATE` exactly as it applied to the `PATCH` — shifts near a week boundary move between
  payroll weeks, and the straight-time ceiling moves with them. The database route does not
  make the problem go away; it makes it invisible. **Q10's analysis is the risk assessment for
  the manual fix**, which is a second reason to leave that question standing in the spec rather
  than deleting it as answered.
- It is only sane **immediately after onboarding**, before any field ticket, quotation or
  payroll period has been computed under the wrong value. That window is short, and nothing in
  the product measures it.

### What this does to REQ-08's `NOT NULL, no default`

It raises the stakes on it considerably, and the note that made that choice did not know it.

[REQ-08](../../aidlc/SCRUM-TZ/spec.md) and item 2 of the
[mechanics note](2026-09-09-tenant-timezone-configuration.md) made `TenantCompany.timezone`
**NOT NULL with no default**, and explicitly rejected keeping `America/Los_Angeles` as the
column default, for **one reason**: *a silent default is how the current bug arose.* That
reason stands on its own and is unaffected by this decision.

But under item 1, **creation is now the only moment the zone is ever chosen.** So forcing it to
be stated at creation stops being merely good hygiene and becomes **the entire safeguard** —
there is no second chance, no correction screen, and nothing downstream that catches a wrong
value. A default that let one tenant through silently would now be permanent silence, fixable
only in the database.

The practical effect is on **review, not on code**: the requirement does not change, but the
eight tenant-creation consumers enumerated in `SCRUM-TZ` §12 **Q11** — including the two
`qa-automation` seeds and the hand-mirrored web type, *"which no gate will check for you"* —
are now the only line of defence there is. `SCRUM-TZ` §14 already gates merge on Q11 being
closed; this decision is the reason that gate should not be waived.

## What this supersedes in `2026-09-09-tenant-timezone-configuration.md`

**Half of item 4, and only that half.** Read both notes together as follows.

| Mechanics note item 4 said | Standing after this decision |
| --- | --- |
| Editing is **`SUPER_ADMIN` only**, through the existing `admin/tenants` surface | **Superseded.** There is no editing. The surface is creation-only, still `SUPER_ADMIN`-scoped by the same class-level guard |
| The zone is delivered on the **`/me` / session response, NOT in the JWT** | **Stands** — see below |
| *Because* a stale token would keep making business-day decisions in the old zone until it expires | **Obsolete as a reason.** A value that never changes cannot go stale |

**The `/me` carrier decision itself is not disturbed.** It stands on its own merits, and it is
already shipped:

- It **is** the shipped contract, not a plan. Commit `dab03099` (*"carry the tenant timezone to
  the browser and label what it shows"*, U5) added `timezone: string` to the `/me` response —
  [`usecase/users/users.service.ts`](../../../apps/api/src/usecase/users/users.service.ts):59,
  populated at :235 — and **both clients consume it**: web at
  [`features/auth/services/auth.service.ts`](../../../apps/web/src/features/auth/services/auth.service.ts):48,
  mobile at
  [`data/contracts/identity.contract.ts`](../../../apps/mobile/data/contracts/identity.contract.ts):37
  (`timezone: z.string().nullish()`), landed by `9f7f2697` (U6). Reversing the carrier now would
  be a breaking change to two shipped surfaces to gain nothing.
- The independent merits hold regardless of mutability. `JwtPayload`
  ([`packages/shared/src/types/index.ts`](../../../packages/shared/src/types/index.ts):4) stays
  `{ sub, email, role, tenantCompanyId, remember? }` — a **stable, minimal token claim set**;
  the zone is tenant *reference data*, not an authorisation claim, and putting reference data in
  a bearer token is wrong on its own terms. REQ-06's acceptance test — *"`JwtPayload` gains no
  field"* — is unchanged and still checkable.
- The staleness argument was **one of several**, and it was the one that made the choice feel
  forced. With it gone the choice is merely correct rather than compelled. That is the whole of
  the amendment.

**Why the mechanics note is amended and not marked `superseded`.** It carries five items; four
are untouched and still binding, and even item 4 half-survives. Flipping its `status:` would
retire four live decisions to correct one clause. An amendment block has been appended to that
note's item 4 pointing here, in the same shape the fleet-timezone note used when it superseded
passages in the grain and boundary notes. Its `status:` stays `reference` and it gains no
`superseded_by:`.

## What is weak about this attribution

- **The decider of record is Syed Haris**, in session, 2026-09-09 — a named, datable human
  directing the work, which is the basis on which this note is written.
- **He is not the client-side product owner, and this note's question is the one where that
  matters most of the five.** Q10 nominates **Corrina Bustos** — payroll — precisely because the
  failure mode is money. Items 1–3 do not decide *how* a zone change re-prices a period; they
  decide that it never happens. That is arguably a cleaner thing for a developer to decide than
  the re-pricing rule would have been. It is still a product capability being removed by
  someone who cannot ratify it, and **neither Corrina nor Brian Petros has seen it.**
- **`status: reference`, not `verified`.** Binding on implementation now, open to being
  overruled by a named TCG product owner. No TPM approval is claimed.
- **The most likely way this gets overturned is operational, not principled.** Nobody objects to
  "the timezone doesn't change" in the abstract. The objection arrives the first time a tenant
  is onboarded with the wrong zone and support is told the fix is a database write. If that
  happens, the reopened question is the edit path **and Q10 with it**, not this note alone.
- **A cheap mitigation exists and was not decided here**, deliberately, because nobody asked
  for it: a **confirmation step on tenant creation** that echoes the chosen zone and its current
  local time back to the SUPER_ADMIN before the row is written. It costs nothing, it is the only
  moment the value is ever falsifiable, and it needs no product ruling. Recorded as an option,
  **not** as a requirement — `SCRUM-TZ` does not carry it and this note does not add it.

## What this does NOT settle

- **What happens to payroll already computed under a wrong zone**, when the database fix
  described above is applied. Out of scope for `SCRUM-TZ` per §11 and §13 (*"re-pricing of
  historical payroll under a changed zone"*), and this note does not reach it. Removing the
  `PATCH` path removes the *product* trigger, not the arithmetic.
- **Whether a tenant may span timezones.** Still answered by constraint, in the grain decision,
  not by analysis. This note makes that constraint **harder to escape**, not softer — a tenant
  that grows into a second zone now has no in-product move at all. `SCRUM-TZ` §13 already
  records that the grain must be revisited before any multi-zone tenant is onboarded; that
  warning gets sharper here.
- **What zone a self-service signup tenant gets** — `SCRUM-TZ` §12 **Q12** (`POST /auth/signup`
  as a ninth creation path) and **Q15** (whether public signup should create a tenant at all),
  both still open. This decision makes them **more** urgent, not less: whatever value that path
  writes is permanent.
- **Q11's eight creation consumers** — still open, still gating merge, and now the only
  safeguard on the value. See above.
- **The traveling-user residual on Q7**, and **time *format*** (`../admin/gaps.md` → *Time
  display*). Neither is touched by mutability. Both stay open.
- **The four reference-data sets** in [`../admin/gaps.md`](../admin/gaps.md) → *what a newly
  created tenant must contain*. See below.

## Effect on the vault

- **No vault file body was edited by this note, and no frontmatter `status:` was flipped by
  it.** As with the four companion notes, this was never a conflict set between vault
  documents — the vault contains no statement about tenant timezone mutability at all, so there
  is no winner to mark `verified` and no loser to mark `superseded`, and the four-step closure
  in `README.md` → *How a gap gets closed* does not apply.
- **[`2026-09-09-tenant-timezone-configuration.md`](2026-09-09-tenant-timezone-configuration.md)
  — amended, done in this pass.** An amendment block was appended to its **item 4** recording
  that the SUPER_ADMIN-editable half is superseded here and that the `/me` carrier stands on
  other grounds. **Its `status:` stays `reference` and it gains no `superseded_by:`** — four of
  its five items and half of the fifth are still binding; see *What this supersedes* above for
  why a whole-file supersession would have been wrong.
- **[`../admin/gaps.md`](../admin/gaps.md) → *what a newly created tenant must contain*: the
  2026-09-09 update line was extended; the entry stays `Status: open`.** The mechanics note had
  already added timezone as a **fifth** required item and answered it. This decision
  **strengthens** that: creation is now the only moment the zone is ever chosen, so "required at
  creation" is the only control that exists. The same update line's claim that *"SUPER_ADMIN is
  the only role that may set or change it"* was corrected — no role changes it. **The entry
  stays open** because the four reference-data sets it was raised for — (a) system departments
  and roles, (b) billing code types, (c) industries, (d) the payroll premium catalog — remain
  unanswered, which is the question it was raised for.
- **[`../admin/gaps.md`](../admin/gaps.md) → *Time display* stays `Status: open`, untouched.**
- **[`../assets/gaps.md`](../assets/gaps.md) → *The fleet day* stays `Status: open`, untouched
  by this note.** Under the fleet-timezone note the fleet day now reads the same tenant column,
  so it inherits this immutability — but the open half of that entry is whether the fleet, job
  and payroll days must share one boundary, which mutability does not touch.
- **Not done here, by instruction:** [`.ai/aidlc/SCRUM-TZ/spec.md`](../../aidlc/SCRUM-TZ/spec.md)
  — §12 **Q10** → `Status: resolved — see
  decisions/2026-09-09-tenant-timezone-is-set-once-at-creation.md`, and §4's
  `PATCH /admin/tenants/:id` row. Syed Haris applied both himself in the same session; verified
  present at §12 Q10 and §4 before this note was written.
- **Flagged, not done — [`.ai/aidlc/SCRUM-TZ/units.md`](../../aidlc/SCRUM-TZ/units.md) is now
  stale in four places, and `tcg-scrum` has no write access to it.** It still routes the edit
  path to U5 as blocked-pending-Q10 rather than cut: `:159` (U2's *deliberately not* column,
  *"the edit path … is Q10's territory and lands in U5"*), `:191` (*"deliberately (via `PATCH
  /admin/tenants/:id` once U5 opens that path)"*), `:236`, and `:515`–`:524` (U5's *Deliberately
  not in this unit* — *"cut out, **blocked on Q10**"*, with the refuse-while-open workaround
  described as *"Q10's interim answer to build if and when the edit path is"*). None is wrong
  about what to build — the instruction is still "do not build it" — but the **reason** is now
  permanent rather than pending, and a reader picking up U5 would otherwise expect the path to
  arrive in a later unit. `:191`'s aside about `DROP COLUMN` should be read the same way.
- **[`../admin/INDEX.md`](../admin/INDEX.md):47 — still flagged, still not done.** Its
  `## Decisions` table lists one note; the five 2026-09-09 timezone notes carry `module/admin`
  and belong in it. `tcg-scrum` has no write access to that body.
- **No code change is authorised by this note.** Item 2 is satisfied by the code as it stands —
  the DTO, the validation pipe and the absent web surface already implement it. Nothing is to be
  added or removed for it.

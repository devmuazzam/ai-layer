---
title: FLEET_TIMEZONE is retired in favour of the per-tenant zone, and the two day implementations converge — decision
source: decision/Syed Haris
decided: 2026-09-09
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — developer/owner directing the `SCRUM-TZ` /
  `fix/timezone-business-day` work; stated directly in a working session on 2026-09-09, as the
  third and last of the day's timezone decisions. He is **not** the client-side product owner,
  and the owners this question is nominated to have not spoken to it: `SCRUM-TZ/spec.md` §12 Q9
  names **Brian Petros**, *"with whoever owns the Samsara integration"*, and
  `../assets/gaps.md` → *The fleet day* names Brian, with **Corrina Bustos** where it touches
  payroll. `status: reference` rather than `verified` for that reason — binding on
  implementation now, open to being overruled by TCG. Same basis and same precedent chain as
  `2026-09-09-business-timezone-is-a-tenant-property.md`,
  `2026-09-09-business-day-starts-at-midnight-local.md`,
  `2026-09-09-tenant-timezone-configuration.md`,
  `2026-09-08-artifact-due-date-seeded-from-first-job-day.md` and
  `2026-09-01-subsistence-not-a-craft-attribute.md`.
status: reference
conflicts_with: []
resolves: [SCRUM-TZ/spec.md#q9--is-fleet_timezone-retired-in-favour-of-the-per-tenant-zone-before-this-branch-merges]
jira: []
tags: [module/assets, module/admin, module/all, kind/decision, time-tracking, architecture, integrations, geolocation, requirements]
---

# `FLEET_TIMEZONE` is retired; the fleet day and the business day become one answer

Removes the second timezone. The three decisions of 2026-09-09 are read together:
[the zone is a tenant property](2026-09-09-business-timezone-is-a-tenant-property.md) (grain) →
[the day starts at 00:00 local](2026-09-09-business-day-starts-at-midnight-local.md) (boundary) →
[how that zone is configured and displayed](2026-09-09-tenant-timezone-configuration.md)
(mechanics) → **this note** (removing the competing mechanism that survived all three).

It is the answer to `SCRUM-TZ` §12 **Q9**, and it is the one decision of the four that
authorises **deleting shipped code on `main`** rather than adding to a branch.

## Decision

### 1. `FLEET_TIMEZONE` is retired in favour of `TenantCompany.timezone`

The fleet day and the business day become **one answer, sourced from the tenant row**. Three
things are deleted:

| Deleted | Where, on `main` |
| --- | --- |
| `FLEET_TIMEZONE` (API env var) | `apps/api/src/config/env.validation.ts`:79 |
| `NEXT_PUBLIC_FLEET_TIMEZONE` (web build-time ARG) | `apps/web/.env.example`:37–38, `apps/web/Dockerfile`:65, :84 |
| `DEFAULT_FLEET_TIMEZONE` (the constant both fall back to) | `packages/shared/src/constants/vehicle-tracking.ts`:27 |

### 2. The implementations converge onto one

`apps/api/src/usecase/vehicle-tracking/fleet-day.ts` and
`apps/web/src/features/vehicle-tracking/utils/fleet-date.ts` move off **dayjs** +
`dayjs/plugin/timezone` and onto `@tcg/shared`'s
[`business-time.ts`](../../../packages/shared/src/utils/business-time.ts), which uses native
**`Intl`**. One implementation of *"what day is it"*, not two.

This half is not cosmetic. Retiring the env var alone would leave two code paths computing the
same boundary through two libraries with different DST and parsing behaviour, agreeing only by
luck and by both being handed the same string.

## Why

### 1. It removes a contradiction that was live in production, not a hypothetical one

`Fetaure/samsara-integration` merged into `main` while this branch was being written — `main`
is 83 commits ahead — so the platform currently ships a **process-wide, env-var-configured
business timezone** that no tenant can vary and no admin can see. That is precisely the shape
[`2026-09-09-business-timezone-is-a-tenant-property.md`](2026-09-09-business-timezone-is-a-tenant-property.md)
decided against. `cdc34c30`'s stated premise was that three competing definitions of *"what day
is it"* — Pacific in the pricing engine, UTC in period ranges and expiry sweeps, server-local
in the crons — were being collapsed onto one; a **fourth** was merging in parallel.

The two mechanisms do not meet in the middle, which is why this is a retirement and not a
rewiring:

- **The API copy** is an env var read per call
  (`fleet-day.ts`:29, `process.env.FLEET_TIMEZONE || DEFAULT_FLEET_TIMEZONE`).
- **The web copy is baked into the bundle at build time.** `fleet-date.ts`:33 captures it into
  a module-level `const`, and Next inlines every `NEXT_PUBLIC_*` at build, passed in as a
  Docker `ARG`. **Today the web fleet zone cannot change without a rebuild** — so "make it
  per-tenant" was never going to be a configuration change on that surface. It has to be
  removed.
- **Nothing keeps the pair in step but a comment.** `apps/web/.env.example`:37 reads *"Fleet
  day boundaries on the tracking screens. Must match the API's FLEET_TIMEZONE."* Two variables,
  two surfaces, hand-synced, and nothing fails if they drift.

Both copies use `||` rather than `??` deliberately, and both say why — the API because *"a
blank value from a secrets store or an empty Docker ARG is as good as absent, and an empty zone
string throws inside dayjs"* (`fleet-day.ts`:27–28), the web because *"Next inlines any
NEXT_PUBLIC_ var that is merely defined, so an empty Docker ARG bakes `''` into the bundle"*
(`fleet-date.ts`:30–32). Careful code, defending a mechanism that should not exist.

### 2. Samsara never receives a timezone, so the integration's contract cannot break

**This is the load-bearing fact for why the retirement is safe**, and it is the reason this
decision is cheap rather than risky.

`apps/api/src/service/samsara/samsara.repository.ts` passes only `startTime` and `endTime` —
absolute RFC 3339 instants — at all three call sites (`:242`/`:253`, `:292`/`:309`,
`:346`/`:359`). No zone, no offset parameter, nothing derived from `FLEET_TIMEZONE` crosses the
wire. `fleet-day.ts` says so itself:

> It is the same instant either way; Samsara takes RFC 3339 with any offset.

So the zone is used **only to choose which instants to ask for**, never to tell Samsara
anything. Changing where that choice comes from — env var to tenant row — changes the window
requested and nothing about the request's shape. **The retirement requires nothing from Samsara
and cannot break the integration's contract.**

### 3. The alternative was a divergence nothing would report

`SCRUM-TZ` §12 Q9 puts it plainly: leaving it alone *"is only coherent while both answers
agree, which today they do because both default to `America/Los_Angeles`. The moment one tenant
is set to anything else, the tracking screens and the payroll engine report different days for
the same fleet, and **nothing anywhere reports the divergence**."* The first non-Pacific tenant
is what turns a dormant inconsistency into two different answers to *"how many hours did this
crane run on Tuesday"*, silently.

## What this costs — the formatter gap, a known consequence and not a blocker

Record this so it is not discovered mid-implementation.
[`business-time.ts`](../../../packages/shared/src/utils/business-time.ts) covers everything
`fleet-day.ts` computes — `businessDateOf`, `startOfBusinessDay` and
`endOfBusinessDayExclusive` return the right instants — **but it has no RFC 3339-with-offset
formatter.** `formatInstant` (line 264) is `Intl.DateTimeFormat` with `timeZoneName: 'short'`:
human display, not machine format.

`fleet-day.ts` currently emits dayjs `.format()`, i.e. `2026-09-08T00:00:00-07:00`, and does it
deliberately — the window is *"written in the fleet's own offset like startTime is, so a logged
window reads as the times the drivers would recognise"* (`fleet-day.ts`:48–51).

Samsara accepts `Z` equally, so **nothing breaks functionally**. What is lost is log
readability: a window logged as `2026-09-08T07:00:00Z` no longer reads as the drivers' own
clock. The fix is a small offset formatter added to `business-time.ts`. **A known consequence
to be handled during the convergence, not a reason to defer it.**

## What motivated this, and does not evidence it

A team member reported *"we don't see vehicle moving"* when times mismatch. It prompted the
investigation that produced this decision. **It is recorded here as context only — the cause
has not been diagnosed, and this note does not assert one.**

Two candidates, undistinguished:

- **(a) The two env vars drifted.** Nothing enforces the `.env.example` instruction, so this is
  possible by construction.
- **(b) Correct behaviour, misread.** The UI deliberately shows **fleet** today, not device
  today — `todayInFleet()` (`fleet-date.ts`:54), whose module docblock states the intent: *"A
  'day' here is a day in Los Angeles, not in the browser's timezone. Someone looking at this
  from New York at 1am is still looking at the shift that is running now, not at tomorrow."* A
  viewer in Pakistan therefore sees a Pacific day roughly 12 hours behind their own, which for a
  California crane fleet is **genuinely idle**. Nothing is wrong in that case except what the
  screen fails to say.

The failure signature is the same either way, which is exactly why it cannot be attributed
without diagnosis. The DTO validator records it: a bad date makes Samsara *"answer with an empty
day rather than an error — so the caller sees a vehicle that apparently sat still, with nothing
to say otherwise"* (`apps/api/src/presentation/vehicle-tracking/dto/vehicle-history.dto.ts`:14–17).

Note that **(b) is not fixed by this decision.** Unifying the zone does not make a Pacific day
legible to a reader in Karachi — that is the labelling requirement in
[`2026-09-09-tenant-timezone-configuration.md`](2026-09-09-tenant-timezone-configuration.md)
item 5, and the traveling-user residual still open under it. If (b) was the cause, this decision
does not resolve the report.

## What is weak about this attribution

- **The decider of record is Syed Haris**, in session, 2026-09-09 — named, datable, directing
  the work.
- **He is not the client-side product owner, and this one reaches further than the other two.**
  It authorises **deleting shipped code on `main`** and touches an integration Q9 says has its
  own owner (*"Brian Petros, with whoever owns the Samsara integration"*). Neither has spoken to
  it. A developer deciding to retire a merged feature's configuration surface is the weakest
  authority-to-blast-radius ratio of the four decisions taken today.
- **`status: reference`.** Binding on implementation now, open to being overruled. No TPM
  approval was claimed for this one.
- **In its favour:** the *engineering* case is checkable and was checked — Samsara receives no
  zone (verified at all three call sites), so the reversible part of the risk is small. What is
  not checkable is the *product* question of whether the fleet day was ever meant to be
  configurable separately, and nobody asked.

## What this does NOT settle

- **Whether the job day shares this boundary.** See *Effect on the vault* — this is the reason
  the fleet-day gap entry stays open.
- **The RFC 3339 formatter.** Named above as a consequence; no decision says what its signature
  or output format should be.
- **The "vehicle not moving" report.** Undiagnosed; see above. Do not close it against this note.
- **What a viewer in another zone sees on the tracking screens.** Governed by
  [`2026-09-09-tenant-timezone-configuration.md`](2026-09-09-tenant-timezone-configuration.md)
  item 5 (label everything) and its open traveling-user residual, not by this note.
- **Sequencing against the merge.** This note says the retirement happens; it does not say
  whether it lands inside `fix/timezone-business-day` or as a follow-up. `SCRUM-TZ` §12 Q9
  records that it blocks *"the merge conversation, not the build"*, and the spec's REQ-10 is the
  coordinator's to write.

## Effect on the vault

- **No vault file body was edited by this note, and no frontmatter was flipped by it.** As with
  the other three, this was never a conflict set between vault documents — the contradiction was
  between the vault's decisions and shipped code, which is not what `superseded_by:` records.
  [`../assets/gaps.md`](../assets/gaps.md) keeps its existing `status:`.
- **[`../assets/gaps.md`](../assets/gaps.md) → *The fleet day*: an update line was appended; the
  entry **stays `Status: open`**, narrowed to one surviving question.** The judgement, since it
  is now a close call in the other direction:
  - *"In whose timezone does a fleet day start?"* — **answered.** Option (c), the tenant, at
    00:00, and as of this note the fleet day is not merely *allowed* to use that value, it has
    no other source.
  - *"Must the fleet day agree with the job/payroll day?"* — **answered for two of the three.**
    The fleet day and the payroll/business day are now the same value **by construction**, not
    by convention — one column, one implementation.
  - **What survives: the job day.** Nothing decided today says the **job** day is derived
    through `business-time.ts`. `jobDate` is a `@db.Date` calendar date, which
    `business-time.ts` classifies as a value that *"has no timezone at all"* — so "does the job
    day agree" is a genuinely different question from the other two, and closing the entry would
    assert an alignment nobody has stated. The entry's own *Blocked* line is otherwise
    discharged: the day picker, the day summary and the fleet-vs-payroll reconciliation are all
    unblocked by this note.
  - It is now narrow enough to deserve its own entry rather than the remains of this one.
    **Flagged as a suggestion, not done** — re-scoping someone's register entry is not a
    `tcg-scrum` edit.
- **Not done here, by instruction:** [`.ai/aidlc/SCRUM-TZ/spec.md`](../../aidlc/SCRUM-TZ/spec.md)
  — §12 **Q9** → `Status: resolved — see decisions/2026-09-09-fleet-timezone-retired-onto-tenant-zone.md`,
  and the new **REQ-10** covering the retirement and convergence. The coordinator is writing
  both, along with the §11a ripple. `units.md` likewise untouched.
- **Flagged, not done:** [`../assets/INDEX.md`](../assets/INDEX.md) has a *Decisions that bind
  this module* section; this note carries `module/assets` and belongs in it.
  [`../admin/INDEX.md`](../admin/INDEX.md):47 has a `## Decisions` table that should list all
  four of today's notes. `tcg-scrum` has no write access to either body.
- **Code changes authorised, and their boundary.** This note authorises the three deletions and
  the dayjs → `business-time.ts` convergence in the two named files. It does **not** authorise
  removing dayjs from the web app generally — `fleet-date.ts` also uses
  `dayjs/plugin/customParseFormat` for strict `YYYY-MM-DD` parsing (`:16`, guarding against
  `2026-02-30` parsing as 2 March) and dayjs day-of-week arithmetic for the calendar grid, none
  of which `business-time.ts` replaces.

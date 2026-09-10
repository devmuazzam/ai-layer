---
title: How the tenant timezone is validated, backfilled, swept, edited and displayed — decision
source: decision/Syed Haris
decided: 2026-09-09
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — developer/owner directing the `SCRUM-TZ` /
  `fix/timezone-business-day` work; stated directly in a working session on 2026-09-09, as
  the follow-on to `2026-09-09-business-timezone-is-a-tenant-property.md`. He is **not** the
  client-side product owner: `../assets/gaps.md` → *The fleet day* names **Brian Petros** as
  owner, with **Corrina Bustos** where it touches payroll, and `../admin/gaps.md` →
  *Time display* names Brian as the voice already on record about what a user sees. **Neither
  has spoken to any of this.** `status: reference` rather than `verified` for that reason —
  binding on implementation now, open to being overruled by TCG. Same basis and same
  precedent chain as `2026-09-09-business-timezone-is-a-tenant-property.md`,
  `2026-09-08-artifact-due-date-seeded-from-first-job-day.md` and
  `2026-09-01-subsistence-not-a-craft-attribute.md`.
status: reference
conflicts_with: []
resolves: [SCRUM-TZ/spec.md#q2--is-the-timezone-free-form-iana-or-a-restricted-set, SCRUM-TZ/spec.md#q4--what-should-the-eight-nightly-sweeps-do-when-tenants-are-in-different-zones, SCRUM-TZ/spec.md#q5--what-zone-do-existing-tenants-get-and-may-the-column-be-null, SCRUM-TZ/spec.md#q6--who-sets-a-tenants-timezone-and-how-does-a-change-propagate, SCRUM-TZ/spec.md#q7--what-does-the-end-user-actually-see--an-instant-in-whose-zone-and-is-it-labelled]
jira: []
tags: [module/admin, module/all, kind/decision, time-tracking, reference-data, architecture, notifications, requirements]
---

# Tenant timezone: accepted values, backfill, sweeps, ownership, display

Five answers taken together in one session, on the mechanics that hang off
[`2026-09-09-business-timezone-is-a-tenant-property.md`](2026-09-09-business-timezone-is-a-tenant-property.md).
That note settled the **grain** (the zone is a tenant property, under a recorded single-zone
constraint); this one settles what the column accepts, what existing rows get, how the
scheduled sweeps behave, who may change it, and what the end user sees. **When the day
starts** is the sixth answer from the same session and has its own note:
[`2026-09-09-business-day-starts-at-midnight-local.md`](2026-09-09-business-day-starts-at-midnight-local.md).

Answers `SCRUM-TZ` §12 **Q2, Q4, Q5, Q6, Q7** and unblocks REQ-01's validation and migration,
REQ-02, REQ-03, REQ-05, REQ-06, REQ-07 and REQ-08. One residual on Q7 stays open — see *The
residual that stays open* below.

## Decision

### 1. Accepted values — any valid IANA zone id, probed at runtime

A tenant's timezone may be **any valid IANA zone id**, validated by a **runtime
`Intl.DateTimeFormat` probe** — construct a formatter with the candidate zone and reject what
throws. **Explicitly rejected: a fixed US-only enum** (the six US zones, or any hardcoded
list).

Three reasons, in Syed's framing:

- **Nothing written supports a narrower list.** `SCRUM-TZ` §12 Q2 records that the vault
  specifies no tenant locale, region or address field at all — [`../admin/gaps.md`](../admin/gaps.md)
  → *company identity* is itself open on whether the company address should even move onto
  the `TenantCompany` row. A US-only enum would be a product constraint invented to make a
  validator easier.
- **The asymmetry runs one way.** Strictly narrowing an accepted set later is a safe change;
  widening a stored enum is a migration. Choose the reversible option.
- **The tz database changes.** Zones are added, renamed and merged. A hardcoded list is stale
  from the day it ships; a runtime probe tracks whatever the platform's ICU data knows.

### 2. Backfill and nullability — Pacific once, then required forever

- **Backfill:** every existing `tenant_companies` row is set to **`America/Los_Angeles`**.
  This is correct rather than merely convenient — every tenant today is Local 12 / California,
  which is the recorded single-zone constraint of the grain decision and the documented reason
  `BUSINESS_TIMEZONE` was a constant.
- **Nullability:** the column is **NOT NULL with no default**. Creating a tenant must state a
  zone.
- **Explicitly rejected: keeping `America/Los_Angeles` as the column default.** Syed's reason
  is the decisive one — *a silent default is how the current bug arose.* A default makes the
  backfill free and makes the next silently-Pacific tenant free too; the entire cost of this
  ticket is the first kind of silence.

**Consequence, recorded because it is not free:**
[`CreateAdminTenantDto`](../../../apps/api/src/presentation/admin/dto/create-admin-tenant.dto.ts)
must gain the field or **tenant creation breaks**. Today it carries `name`, `tenantCode`,
`maxUsers?` and `domain?` and nothing else; a NOT-NULL column with no default fails the insert
the moment the DTO omits it. This is the accepted cost of the answer, not an oversight in it.

### 3. Scheduled sweeps — each tenant's own quiet window

Each tenant's expiry/reminder sweep fires at **that tenant's local** quiet window. **Not** one
global run computing each tenant's target date, and **not** one run per distinct zone
registered at boot.

**Implementation consequence, recorded because the obvious reading of this is impossible.**
`@Cron`'s `timeZone` is a **decorator argument, fixed at class-definition time**, and cannot
vary per tenant. So "each tenant's local quiet window" cannot be expressed as eight
schedules. It becomes:

> **Run hourly; select the tenants whose local time has just crossed the trigger.**

The schedule is the ticking mechanism, the tenant's zone is the filter. There is already a
precedent in the same file:
[`notification-scheduled-jobs.service.ts`](../../../apps/api/src/usecase/notifications/notification-scheduled-jobs.service.ts):211
runs `CronExpression.EVERY_HOUR` for ticket reminders — the hourly shape is not novel here.
The other seven are daily
([`permit-expiry.service.ts`](../../../apps/api/src/usecase/permits/permit-expiry.service.ts):59,
[`quotation-expiry.service.ts`](../../../apps/api/src/usecase/quotations/quotation-expiry.service.ts):54,
`notification-scheduled-jobs.service.ts`:91, :103, :155,
[`price-listing-adjustment-expiry.service.ts`](../../../apps/api/src/usecase/price-listings/price-listing-adjustment-expiry.service.ts):48,
:66) and all eight currently declare `timeZone: BUSINESS_TIMEZONE`.

**Why the shape matters rather than being an implementation taste:** the reminder keys embed
the computed date, so the wrong day is not a delay, it is a permanent suppression. The
cert-expiry body says so in its own comment — the code was already burned by this once:

> `expiryDate` is `@db.Date`, matched by exact equality, so the target has to be the right
> calendar day to within zero tolerance. Counting forward from the UTC day made the lead
> 61/31 days whenever the cron fired after 16:00 Pacific — and **because the reminder key
> below embeds this same date, firing on the wrong day permanently suppressed the right one.**

The key is literally `` `${type}:${cert.id}:${target.toISOString().slice(0, 10)}` `` guarded
by `reminderLog.tryRecord(...)`. A wrong date mints a different key, the log records it, and
the correct reminder is never sent. The hourly-plus-filter shape is what keeps one tenant's
day boundary from deciding another tenant's key.

### 4. Who edits it, and how a change propagates

- **Editing: `SUPER_ADMIN` only**, through the existing `admin/tenants` surface.
  [`admin-tenants.controller.ts`](../../../apps/api/src/presentation/admin/admin-tenants.controller.ts):13
  already carries `@Roles(Role.SUPER_ADMIN)` at the class level, so the zone rides an
  authorisation boundary that exists rather than creating one. **Not tenant self-serve under
  `/settings`.** This matches how every other `TenantCompany` field is administered today.
- **Propagation: the zone is delivered on the `/me` / session response, NOT in the JWT.**

The JWT half is the load-bearing half. `JwtPayload` is today
`{ sub, email, role, tenantCompanyId, remember? }`
([`packages/shared/src/types/index.ts`](../../../packages/shared/src/types/index.ts):4) —
no zone, and no zone is to be added. A token is **not re-issued when the tenant's zone
changes**, so a stale token would keep making business-day decisions in the old zone until it
expires: the payroll week, the day type and the rate in force would all be computed against a
value a SUPER_ADMIN already corrected. Putting the zone on the session response
([`users.controller.ts`](../../../apps/api/src/presentation/users/users.controller.ts):36,
`GET /api/v1/users/me`) has no such property — the next fetch has the new value.

This is the one item where the cheap option and the correct option differ and the correct one
was chosen deliberately.

> **AMENDED 2026-09-09, after this note was written — item 4 is half superseded.**
> [`2026-09-09-tenant-timezone-is-set-once-at-creation.md`](2026-09-09-tenant-timezone-is-set-once-at-creation.md)
> (`status: reference`, same session, same decider) settles that **the tenant timezone is never
> changed** — it is set once at tenant creation and there is no product surface to edit it.
> `PATCH /admin/tenants/:id` accepting `timezone` is **cut, not deferred**, and
> `UpdateAdminTenantDto` stays as it is.
>
> - **Superseded:** the *"editing: `SUPER_ADMIN` only, through the existing `admin/tenants`
>   surface"* half above. There is no editing. `SUPER_ADMIN` remains the role that **sets** the
>   zone, at creation, under the same class-level guard.
> - **Stands:** the zone rides the **`/me` / session response and not the `JwtPayload`**. That
>   half is unchanged and is already shipped (`dab03099`, U5; consumed by web at
>   `apps/web/src/features/auth/services/auth.service.ts`:48 and by mobile at
>   `apps/mobile/data/contracts/identity.contract.ts`:37, `9f7f2697`, U6).
> - **Obsolete as a *reason*:** the stale-token argument that made the JWT half "load-bearing"
>   above. A value that never changes cannot go stale in a token. The carrier decision now rests
>   on its independent merits — the zone is tenant reference data, not an authorisation claim,
>   and `JwtPayload` stays minimal — not on staleness. REQ-06's acceptance test (*`JwtPayload`
>   gains no field*) is unchanged.
> - **`SCRUM-TZ` §12 Q10 is moot, not answered.** The re-date / freeze / refuse question about
>   an open payroll period cannot arise, so nothing was chosen between the three. It returns
>   unanswered if the immutability constraint is ever lifted.
>
> **This note keeps `status: reference` and gains no `superseded_by:`** — items 1, 2, 3 and 5
> are untouched and still binding, and half of item 4 survives. See the amending note's *What
> this supersedes* for the reasoning.

### 5. What the end user sees — the tenant's business zone, always labelled

- A timestamp on screen is rendered in the **tenant's business zone**. **Not** the viewer's
  device zone.
- It is **always labelled with the zone name**. The label is not optional and not a
  nice-to-have: it is what makes the rendered number falsifiable by the person reading it.

Both surfaces move toward this. Web's payroll panel already renders engine-emitted
business-zone `HH:mm` so *"the panel can no longer disagree with the money it exists to
explain"* (`c5c7f6a9`). Mobile currently labels in the **device** zone and deliberately does
not convert (`45934840`) — under this decision mobile converts to the business zone and keeps
labelling, and the Hermes `Intl` caveat that commit records (*"pinning `Intl` to an IANA zone
is not something to rely on across every Hermes build without testing it on device, and a
wrong clock is worse than an unlabelled one"*) is a **real constraint on delivery that this
decision does not dissolve**. Verify on device before promising it; if `Intl` cannot be relied
on there, that is an escalation, not a licence to fall back to the device zone silently.

## The residual that stays open — the traveling user

Syed raised this himself and said he needs to check it: **what happens when a person is
normally in the US but travels to, say, Pakistan?** It is recorded here as **still open**, on
`SCRUM-TZ` §12 **Q7** as a residual. What follows is the analysis he was given in session —
**analysis, not decision**, and marked as such because nobody has ruled on it.

**Business-day decisions do not move when a person travels.** The payroll week, the day type
and the rate in force follow the **work location**, which is where the crane was, not where
the phone is. A California shift is worth what it was worth regardless of where the person
later opens the app. `business-time.ts`'s own docblock states this as the module's premise:
business-day decisions *"follow the **work location**, never the viewer. California daily
overtime, California meal periods and Local 12's 06:00–17:00 window are all defined where the
crane was, not where the person reading the screen is sitting."* So travel is not a
computation problem. Item 5 above already fixes the computation answer.

**Travel bites on display.** An unlabelled `06:00` shown in the tenant zone to someone whose
phone reads `19:00` is **unfalsifiable** — the reader has no way to tell whether the app is
wrong, their memory is wrong, or the number is simply in another zone. That is precisely the
argument **for** the labelling requirement in item 5. It is not a separate feature and should
not be scoped as one.

**What already exists for it, wired to nothing.**
[`apps/mobile/features/field-ticket/timers/zone-label.ts`](../../../apps/mobile/features/field-ticket/timers/zone-label.ts)
exports `isDeviceOnBusinessZone()` (line 71) and `hoursFromBusinessZone()` (line 110) — built
for exactly this mismatch warning, the second documented as *"How far this device's clock-face
is from the business zone, in whole hours. `0` when they agree. **Used to word the warning
concretely.**"* A repo-wide sweep of `apps/` and `packages/` for both symbols returns **no
call site outside their own file**: the warning they were built to word does not exist in any
UI. Both were verified present at those lines.

**Undecided:** whether a traveling user gets a **warning**, a **dual display** (business zone
plus device zone), or **nothing at all** beyond the mandatory label. Owner: product team —
Brian Petros, already the named voice in `admin/gaps.md` → *Time display*. Until it is
answered, the label from item 5 is the floor and is sufficient to ship.

## What is weak about this attribution

- **The decider of record is Syed Haris**, in session, 2026-09-09 — a real, named, datable
  human directing the work, and the basis on which this note is written.
- **He is not the client-side product owner.** `assets/gaps.md` → *The fleet day* names
  **Brian Petros**, with **Corrina Bustos** on payroll; `admin/gaps.md` → *Time display* names
  Brian. **Neither has spoken to any of the five items above.** Item 5 in particular decides
  something Brian is already on record caring about (he asked for the date to be shown because
  *"a lot of the jobs go past midnight"*) without asking him.
- **`status: reference`, not `verified`.** Binding on implementation now, open to being
  overruled by a named TCG product owner. Unlike the grain decision, **no TPM approval was
  claimed for any of these five** — they were answered directly, which is cleaner provenance
  and no more authority.
- The five items are **not equally weighty**. Items 1–4 are engineering-shaped answers to
  engineering-shaped questions and a product owner is unlikely to overturn them. **Item 5 is a
  genuine product choice** — which zone a person sees is a UX decision with two defensible
  answers, and it is the one most likely to be revisited.

## What this does NOT settle

- **The traveling-user treatment** — see above; open as a residual on `SCRUM-TZ` §12 Q7.
- **Time *format*.** [`../admin/gaps.md`](../admin/gaps.md) → *Time display — military,
  12-hour, or per-user* is about 12h/24h and whether the date rides along with the time. **This
  note settles the zone and nothing about the format**, and that entry stays `Status: open`.
- **The end-of-day boundary for `validUntil`.** [`../quotations/gaps.md`](../quotations/gaps.md)
  → *Does "Valid until &lt;date&gt;" mean end of that day, or the instant of midnight?* asked
  two things; only the second half is answered here.
- **Whether a tenant may span timezones.** Answered by constraint on 2026-09-09, not by
  analysis; see the grain decision. Every item above is correct only while that constraint
  holds — item 3 in particular assumes one zone per tenant is enough to select a sweep window.
- **The fleet day's alignment with the job and payroll day** —
  [`../assets/gaps.md`](../assets/gaps.md) → *The fleet day* stays open, **and it is a live
  contradiction of this note's premise, not a loose end.** `main` already ships a *second*
  business timezone with a completely different configuration mechanism: `FLEET_TIMEZONE`, an
  environment variable read at
  `apps/api/src/usecase/vehicle-tracking/fleet-day.ts`:29 as
  `process.env.FLEET_TIMEZONE || DEFAULT_FLEET_TIMEZONE` (`||` by design — *"a blank value from a
  secrets store or an empty Docker ARG is as good as absent, and an empty zone string throws
  inside dayjs"*), defaulted at `apps/api/src/config/env.validation.ts`:79 and duplicated on web
  as `NEXT_PUBLIC_FLEET_TIMEZONE`
  (`apps/web/src/features/vehicle-tracking/utils/fleet-date.ts`:33, with `apps/web/.env.example`:37
  instructing that it *"Must match the API's FLEET_TIMEZONE"*). **Every item above is about a
  per-tenant database column set by a SUPER_ADMIN; that one is a process-wide env var no tenant
  can vary and no admin can see.** They are not reconcilable by wiring — one of them has to go.
  It also uses **dayjs** where
  [`business-time.ts`](../../../packages/shared/src/utils/business-time.ts) uses native **`Intl`**,
  so they can disagree on DST edges even when configured identically. Sequencing note, because it
  decides who has to act: `fleet-day.ts` is **on `main` today**; `business-time.ts` is **not**,
  existing only on `fix/timezone-business-day`. This note does not decide the fleet day's fate —
  but a third decision taken later the same session does:
  [`2026-09-09-fleet-timezone-retired-onto-tenant-zone.md`](2026-09-09-fleet-timezone-retired-onto-tenant-zone.md)
  (`status: reference`) **retires `FLEET_TIMEZONE`** — the env var, its web twin
  `NEXT_PUBLIC_FLEET_TIMEZONE` and the shared `DEFAULT_FLEET_TIMEZONE` constant — in favour of
  `TenantCompany.timezone`, and converges both implementations off dayjs onto `business-time.ts`.
  So the answer to "one of them has to go" is that the env var goes, and every item decided in
  this note becomes the fleet day's configuration mechanism too. Read that note before touching
  vehicle tracking.
- **Historical re-pricing under a changed zone.** Out of scope per `SCRUM-TZ` §11: item 4
  authorises a SUPER_ADMIN to change the zone and says nothing about what happens to payroll
  already calculated under the old one. **Amended 2026-09-09** — item 4's authorisation was
  withdrawn later the same session by
  [`2026-09-09-tenant-timezone-is-set-once-at-creation.md`](2026-09-09-tenant-timezone-is-set-once-at-creation.md),
  so there is no in-product path that reaches this. It stays unsettled rather than becoming
  irrelevant: a tenant onboarded with the wrong zone is corrected by a **database write**, and
  the re-pricing question applies to that write exactly as it applied to the `PATCH`.

## Effect on the vault

- **No vault file body was edited by this note, and no frontmatter was flipped by it.** As
  with the grain decision this was never a conflict set between vault documents — the vault
  contained no business timezone at all, so there is no winner to mark `verified` and no loser
  to mark `superseded`, and the four-step closure in `README.md` → *How a gap gets closed*
  does not apply. [`../admin/gaps.md`](../admin/gaps.md),
  [`../assets/gaps.md`](../assets/gaps.md) and [`../quotations/gaps.md`](../quotations/gaps.md)
  keep their existing `status:` and gain no `superseded_by:`.
- **[`../admin/gaps.md`](../admin/gaps.md) → *what a newly created tenant must contain*: an
  update line was appended; the entry stays `Status: open`.** Item 2 adds a **fifth** required
  item to that entry's list and answers it — timezone is required at creation, with no default
  — but the entry's four reference-data sets (system departments and roles, billing code types,
  industries, the payroll premium catalog) are all still unanswered, which is the question it
  was raised for. Partly answered, not closed.
- **[`../admin/gaps.md`](../admin/gaps.md) → *Time display* stays `Status: open`, untouched.**
  Said plainly because it is the entry a reader will assume item 5 closed: it is about
  **format** (military vs 12-hour vs per-user, and whether the date renders alongside the
  time), and this note decides **zone**. Neither half of that entry is answered here.
- **[`../quotations/gaps.md`](../quotations/gaps.md) → *Does "Valid until &lt;date&gt;" mean
  end of that day…*: an update line was appended; the entry stays `Status: open`.** That entry
  asks two things. *"In whose timezone is that day defined?"* is now answered — the tenant's
  business zone, which also removes the defect it flags of a quote's lifetime varying by the
  salesperson's browser zone. *"Should validity be inclusive of the named calendar day"* — end
  of day versus the instant of midnight — is **not** answered and is the half the customer
  actually loses a day to. Partly answered, not closed.
- **[`../assets/gaps.md`](../assets/gaps.md) → *The fleet day* stays `Status: open`**, with the
  update line appended by the companion note
  [`2026-09-09-business-day-starts-at-midnight-local.md`](2026-09-09-business-day-starts-at-midnight-local.md)
  — see its *Effect on the vault* for the reasoning on why the three-way agreement question
  keeps it open.
- **Not done here, by instruction:** [`.ai/aidlc/SCRUM-TZ/spec.md`](../../aidlc/SCRUM-TZ/spec.md)
  — §12 **Q2, Q4, Q5, Q6** → `Status: resolved — see
  decisions/2026-09-09-tenant-timezone-configuration.md`; **Q7** → resolved against this note
  **with a `Residual:` line for the traveling user**, in the shape Q1 already uses; and REQ-01,
  REQ-02, REQ-03, REQ-05, REQ-06, REQ-07, REQ-08 unblocked. Syed Haris was editing that file
  and `units.md` in the same session and is applying those edits himself. **Q8 is the companion
  note's**, not this one's.
- **Flagged, not done:** [`../admin/INDEX.md`](../admin/INDEX.md):47 has a `## Decisions`
  table listing one note; this note and the two companions carry `module/admin` and belong in
  it. `tcg-scrum` has no write access to that body. *(Correction to
  `2026-09-09-business-timezone-is-a-tenant-property.md`, which recorded that `admin/INDEX.md`
  has no such section — the section exists, under the heading `## Decisions` rather than
  `## Decisions that bind this module`.)*
- **No code change is authorised beyond `SCRUM-TZ`'s own requirements.** In particular item 2
  authorises the NOT-NULL column and the DTO field it forces; it does not authorise deleting
  `BUSINESS_TIMEZONE`, which stays as the migration's backfill value and as the default
  argument on every `business-time.ts` function until REQ-03 wires `TenantContext` through all
  43 call sites.

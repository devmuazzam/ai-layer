# Spec — SCRUM-TZ Lock the business timezone per tenant

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-TZ` — synthetic id, no Jira issue exists and none will be created |
| Intent | `.ai/aidlc/SCRUM-TZ/intent.md`, captured `2026-09-09` |
| Elaborated on | `2026-09-09` |
| Vault state at elaboration | 635 `.md` files; 11 `domain/` files verified; **219** entries open across `vault/*/gaps.md`; 12 open across `SCRUM-*/spec.md` |
| Open questions raised by this spec | **23 raised, 14 still open** — Q10–Q23 came from building, not from elaborating, which is the loop working. None blocks a unit from starting; several block merging. All in §12 |
| Already-shipped behaviour reached | **46 consumers in §11a; 5 with no source for what happens to them** |
| Rules consulted | `CLAUDE.md`, `.ai/claude/contexts/prisma.md`, `.ai/claude/contexts/api.md`, `.ai/claude/contexts/web.md`, `.ai/claude/contexts/mobile.md` |

> **Read §12 before §2.** All ten requirements below are `[UNVERIFIED]`; none is `[OPEN]`.
>
> **Resolved 2026-09-09** (Q1, Q3 — see `decisions/2026-09-09-business-timezone-is-a-tenant-property.md`):
> the business timezone is a property of the **tenant**, under the explicitly recorded
> constraint that **every tenant today operates in exactly one zone**. That decision is
> `status: reference`, not `verified` — it was given by Syed Haris relaying a TPM approval
> whose name and date were not captured, so it is binding on implementation and open to
> being overruled by TCG.
>
> Still true and still worth reading before §2: before that decision the vault contained
> **no statement of a business timezone** for the company, a tenant, a yard, or the
> product, and the `America/Los_Angeles` in the code has zero written backing.

---

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | The tenant carries an IANA timezone | schema | `[UNVERIFIED]` | `decisions/2026-09-09-business-timezone-is-a-tenant-property.md` (`status: reference`) | no |
| REQ-02 | Storage convention is unchanged by this ticket | schema | `[UNVERIFIED]` | code, rule | no |
| REQ-03 | API business-day decisions resolve the tenant's zone | api | `[UNVERIFIED]` | `decisions/2026-09-09-business-timezone-is-a-tenant-property.md`, code | **no product answer needed; build blocked on REQ-01's column — Q5** |
| REQ-04 | The payroll engine takes the zone as an input | shared | `[UNVERIFIED]` | code | no |
| REQ-05 | Cron sweeps stop deciding one day for all tenants | api | `[UNVERIFIED]` | `decisions/2026-09-09-tenant-timezone-configuration.md` | no |
| REQ-06 | Web obtains the tenant zone and labels what it shows | web, shared | `[UNVERIFIED]` | `decisions/2026-09-09-tenant-timezone-configuration.md` | no |
| REQ-07 | Mobile labels field times against the tenant zone | mobile | `[UNVERIFIED]` | `decisions/2026-09-09-tenant-timezone-configuration.md` | no |
| REQ-08 | Existing tenant rows are backfilled | schema | `[UNVERIFIED]` | `decisions/2026-09-09-tenant-timezone-configuration.md` | no |
| REQ-10 | `FLEET_TIMEZONE` is retired onto the tenant zone | api, web, shared | `[UNVERIFIED]` | `decisions/2026-09-09-fleet-timezone-retired-onto-tenant-zone.md` | no |
| REQ-09 | The business day starts at a stated wall-clock time | shared | `[UNVERIFIED]` | `decisions/2026-09-09-business-day-starts-at-midnight-local.md` | **n/a — out of scope, answer is midnight (already implemented)** |

Counts: **9** total — 0 verified, **4 unverified**, 0 conflicted, **5 open**.

Updated 2026-09-09: REQ-01 and REQ-03 unblocked *on product intent* by
`decisions/2026-09-09-business-timezone-is-a-tenant-property.md`.

**All ten requirements are `[UNVERIFIED]`; none is `[OPEN]`.** Q2, Q4, Q5, Q6, Q7 and
Q8 were answered 2026-09-09 (`decisions/2026-09-09-tenant-timezone-configuration.md`, `decisions/2026-09-09-business-day-starts-at-midnight-local.md`), and REQ-09 is out of scope because the answer
— midnight local — is what the code already implements.

Two things this does **not** mean. First, a requirement can be un-open and still unbuildable:
REQ-03 needs `TenantCompany.timezone` to exist before its 43 call sites have anything to
resolve, so it sequences behind REQ-01's migration. Sequencing lives in `units.md`, not here.
Second, `[UNVERIFIED]` is the honest flag and not a formality — every source above is a
`status: reference` decision from a developer/owner, not a `verified` adjudication by the
client-side product owners `assets/gaps.md` names (Brian Petros, with Corrina Bustos on
payroll). Neither has spoken to any of it.

---

## 2. Requirements

### REQ-01 — The tenant carries an IANA timezone `[UNVERIFIED]`

- **Statement:** `TenantCompany` carries the IANA identifier of the timezone in which that
  tenant's business days are decided. Every tenant today operates in exactly one zone, and
  that constraint is recorded rather than assumed.
- **Surface:** schema
- **Sources:**
  - `decisions/2026-09-09-business-timezone-is-a-tenant-property.md` — kind: decision — `status: reference`
    (**not** `verified`). Syed Haris, 2026-09-09, relaying a TPM approval whose name and
    date were not captured. Binding on implementation; open to being overruled by TCG.
  - `.ai/vault/assets/gaps.md` → *The fleet day* — `[UNVERIFIED]` — kind: vault — **stays
    open.** This decision settles the tenant grain; it does not define a fleet day, and it
    does not state that the fleet day, the job day and the payroll day share one boundary.
  - `packages/shared/src/utils/business-time.ts:44` — `[UNVERIFIED]` — kind: code — the
    constant this replaces as the source of truth.
- **Conflict:** none. The decision is **narrower** than the code comment that preceded it:
  `business-time.ts`'s docblock claims business-day decisions "follow the **work
  location**, never the viewer", and a work location is a site, not a company. The
  single-zone constraint is what reconciles the two, and it is the reason that constraint
  must be written down rather than assumed.
- **Open question:** none — Q1 and Q3 resolved 2026-09-09. Note that Q3's underlying
  tension is deferred, not eliminated: if a tenant ever operates in two zones, the grain
  must be revisited before that tenant is onboarded.
- **Ripple:** the 46 consumers in §11a. The zone resolution point is one lookup per
  request, not per row — see REQ-03.
- **Acceptance:** `tenant_companies` has a timezone column holding an IANA identifier;
  `TenantCompany` in `schema.prisma` declares it with `@map`/`@db.VarChar`; a committed
  migration exists under `apps/api/prisma/migrations/`; `tcg-prisma-guardian` has passed.
- **Notes for the executor:** nullability and default are still **Q5** and still block the
  migration. The column shape is settled; what an existing or new row contains is not.

### REQ-02 — Storage convention is unchanged by this ticket `[UNVERIFIED]`

- **Statement:** Instants continue to be stored `timestamptz` and transported as ISO
  strings carrying a zone; calendar dates continue to be stored `@db.Date` and transported
  as `YYYY-MM-DD`; the tenant zone is stored as an IANA zone **identifier**, never as an
  offset. No timestamp is stored in tenant-local wall-clock time.
- **Surface:** schema
- **Sources:**
  - `apps/api/prisma/schema.prisma` — `[UNVERIFIED]` — kind: code — every timestamp column
    is now explicitly `@db.Timestamptz()`; commit `047f9f4a` converted the last two naive
    `TIMESTAMP(3)` columns (`categories`, `sub_categories`) and states *"no bare `DateTime`
    remains."*
  - `packages/shared/src/utils/business-time.ts` docblock — `[UNVERIFIED]` — kind: code —
    the three-kinds taxonomy: instant, calendar date, business-day decision. *"Everything
    here serves (2) and (3). Nothing here should be used to render an instant to a user."*
  - `.ai/claude/contexts/prisma.md` — kind: rule — binding on how, never on what.
- **Conflict:** none
- **Open question:** none
- **Ripple:** none — this requirement is a statement that the ripple is zero. Established
  by `grep -c '@db.Timestamptz' apps/api/prisma/schema.prisma` and the absence of bare
  `DateTime` (`grep -n 'DateTime' apps/api/prisma/schema.prisma | grep -v '@db\.'`).
- **Acceptance:** After this ticket, `grep -n 'DateTime' apps/api/prisma/schema.prisma |
  grep -v '@db\.'` still returns nothing, and no migration in this ticket alters the type
  of any existing timestamp column.
- **Notes for the executor:** An offset (`-08:00`) is **not** an acceptable stored value.
  An offset cannot express DST, and the whole point of the zone is to answer questions on
  both sides of a transition — `business-time.spec.ts` already covers both transitions and
  the 23h/25h days.

### REQ-03 — API business-day decisions resolve the tenant's zone `[UNVERIFIED]`

- **Statement:** Business-day decisions in `apps/api` resolve the acting tenant's timezone
  rather than falling back to the process constant.
- **Surface:** api
- **Sources:**
  - `decisions/2026-09-09-business-timezone-is-a-tenant-property.md` — kind: decision — `status: reference` — the
    tenant is the grain.
  - 43 call sites across 14 files — `[UNVERIFIED]` — kind: code — enumerated in §11a.
  - `packages/shared/src/utils/business-time.ts` docblock — `[UNVERIFIED]` — kind: code —
    asserts business-day decisions "follow the **work location**, never the viewer". Under
    the single-zone constraint the tenant's zone *is* the work location; that equivalence
    is the constraint doing the work, not a coincidence.
- **Conflict:** none
- **Open question:** none for the API's own decisions. Two build dependencies remain, and
  neither is a product question about *this* requirement:
  - **Q5 blocks the start of this work** — `TenantContext` cannot carry a resolved zone
    until `TenantCompany.timezone` exists, which is REQ-01's migration. See `units.md` U3.
  - **Q4 still blocks the 8 cron sweeps** (REQ-05), which are not request-scoped and
    therefore cannot use the mechanism below at all. Those 4 files are sliced into U4, not
    U3.
- **Ripple:** the 14 API files in §11a. Every row marked "changes deliberately" is
  unblocked by this requirement. The four cron rows were the exception until Q4 was answered
  2026-09-09; they are now U4's scope rather than U3's, because a `@Cron` schedule cannot be
  per-tenant and they need the hourly-select shape instead of the request-scoped mechanism.
- **Acceptance:** No business-day call in `apps/api` relies on the default parameter — that
  is, every call passes a zone explicitly. Checkable: each of the 43 sites in the §11a grep
  passes an argument, and a test proves two tenants in different zones get different
  business days from the same instant.
- **A condition `tcg-prisma-guardian` placed on this requirement (2026-09-09), and the only
  one it raised:** `TenantCompany` is **not** in the tenant-scoping allowlist
  (`tenantModels`, `apps/api/src/orm/prisma.service.ts:96-217` — verified absent) and cannot
  be: it *is* the root, with no `tenantCompanyId` to scope by. Today every non-admin read is
  safe **by convention, not by structure** — every call site sources the id from
  `TenantContextService` or the JWT, and `TenantCompaniesRepository.findById` says so in a
  comment (*"Bypasses tenant middleware intentionally"*). The cross-tenant reads that exist
  are `@Roles(Role.SUPER_ADMIN)`-gated.

  **So U3 must resolve the zone through `TenantContextService.getTenantCompanyId()`, or
  through an id taken from an already-tenant-scoped parent record — never from a bare request
  param.** Nothing enforces this; the first call site that ignores it breaks tenant isolation
  silently, and the extension will not catch it because this model is not in its allowlist.
- **Notes for the executor:** `TenantContextService`
  (`apps/api/src/context/tenant-context.ts`) is an `AsyncLocalStorage` already populated on
  every authenticated request by `TenantContextInterceptor` with `tenantCompanyId`,
  `userId`, `userRole`. Adding a resolved `timeZone` to `TenantContext` is the carrier:
  it resolves once per request (§11 non-functional), needs no signature change at 43 sites,
  and fails loudly outside a request rather than silently returning Pacific. **Do not**
  give the getter a Pacific fallback — a fallback is precisely the bug this ticket exists
  to remove.

### REQ-04 — The payroll engine takes the zone as an input `[UNVERIFIED]`

- **Statement:** `packages/payroll-engine` receives the timezone as part of its input
  rather than importing `BUSINESS_TIMEZONE`, so the engine has no opinion about where the
  work happened.
- **Surface:** shared (the `packages/payroll-engine` workspace)
- **Sources:**
  - `packages/payroll-engine/src/slices.ts:1,13` — `[UNVERIFIED]` — kind: code —
    `toPacific(date)` calls `wallClockIn(date, BUSINESS_TIMEZONE)`; the name itself encodes
    the assumption.
  - `packages/payroll-engine/src/types.ts:93` — `[UNVERIFIED]` — kind: code —
    `CalculatePayPeriodInput` has `periodStart`, `employees`, `jobDays`, `premiums`,
    `contextJobDays` and **no zone field**.
  - `packages/payroll-engine/src/explain.ts:12,37,70` — `[UNVERIFIED]` — kind: code — three
    further `toPacific` calls.
  - `packages/shared/src/utils/business-time.ts` docblock — `[UNVERIFIED]` — kind: code —
    *"All functions take an explicit `timeZone` … so the tenant-configurable zone this
    platform will eventually need is a parameter that already exists rather than a
    refactor."*
- **Conflict:** none
- **Open question:** none — this requirement is purely mechanical. It does not decide
  *which* zone; it only stops the engine deciding for itself. It is the one requirement
  here that is safe to build ahead of the product answers, and it is the natural U1.
- **Ripple:** `toPacific` is exported from the engine barrel
  (`packages/payroll-engine/src/index.ts:12`). Enumerated by
  `grep -rn 'toPacific' packages/*/src apps/*/src` — 6 hits, all inside the engine, none
  outside it. Renaming or re-signing it therefore reaches no other workspace.
- **Acceptance:** `grep -rn 'BUSINESS_TIMEZONE' packages/payroll-engine/src` returns
  nothing. `calculatePayPeriod` given the same job days and two different zones produces
  two different day-type/week assignments across a boundary, proven by a test.
- **A hole `tcg-analyst` found, and what was done about it (2026-09-09):** the engine's own
  spec files are **excluded from `tsc`** (`packages/payroll-engine/tsconfig.json` →
  `exclude: ["…", "src/**/*.spec.ts"]`) and run under `node --experimental-strip-types`,
  which does not type-check. So the compiler's "required field" guarantee **never reached the
  34 pre-existing tests**: 21 zone-taking calls across `calculate.spec.ts`, `explain.spec.ts`
  and `guarantee.spec.ts` passed no zone and were rescued silently by `@tcg/shared`'s
  `timeZone: string = BUSINESS_TIMEZONE` default, three calls away in another package.

  That is a live trap for REQ-03, which contemplates removing those defaults. Verified on
  2026-09-09: `Intl.DateTimeFormat(locale, { timeZone: undefined })` falls back to the
  **machine's** zone — and the machine this was developed on is `Asia/Karachi`, where the
  suite's own fixture instant reads as a different calendar day than in Pacific. Removing the
  default would have turned 34 payroll tests machine-dependent, passing in CI and failing on a
  developer's laptop, or worse the reverse.

  **Fixed in U1's working tree:** all 22 zone-taking calls across the four spec files now pass
  an explicit `BUSINESS_TIMEZONE`. Proven by temporarily deleting all 8 default parameters
  from `business-time.ts`, rebuilding, and re-running: **37/37 with no defaults present.**
  (That experiment also caught an `explainSlices` call the first pass had missed — the fix was
  incomplete until it ran.) Defaults were then restored; `business-time.ts` is unmodified.

  This is deliberately **beyond U1's slice contents**. It is test-only, in the package U1
  already owns, and it makes REQ-04's stated guarantee real rather than borrowed. Recorded
  here rather than done silently.
- **Notes for the executor:** Make the zone **required** on `CalculatePayPeriodInput`, not
  optional with a Pacific default. An optional zone reintroduces the exact silent-Pacific
  failure this ticket exists to remove, and the compiler is the only thing that will catch
  a missed call site.

### REQ-05 — Cron sweeps stop deciding one day for all tenants `[UNVERIFIED]`

- **Statement:** Each tenant's expiry and reminder sweeps run against that tenant's own local
  quiet window, rather than one global run computing a single business day and applying it to
  every tenant's rows.
- **Surface:** api
- **Sources:**
  - `decisions/2026-09-09-tenant-timezone-configuration.md` — kind: decision — `status: reference` — "each tenant's local", explicitly in
    preference to one global run.
  - 8 `@Cron` declarations pinned to `BUSINESS_TIMEZONE` — `[UNVERIFIED]` — kind: code —
    `permit-expiry.service.ts:59`, `quotation-expiry.service.ts:54`,
    `notification-scheduled-jobs.service.ts:91,103,155,211`,
    `price-listing-adjustment-expiry.service.ts:48,66`.
- **Conflict:** none
- **Open question:** none
- **The shape is forced, not chosen.** A `@Cron` decorator argument is evaluated at
  class-definition time and cannot vary per tenant, so "each tenant's local 01:00" cannot be
  expressed as a schedule. It becomes *run hourly, select the tenants whose local time has
  just crossed the trigger*. Precedent in the same file:
  `notification-scheduled-jobs.service.ts:211` already runs `EVERY_HOUR`.
- **Ripple:** all 8 jobs, plus `ReminderLog` keys — which **embed the computed date**, so they
  are not idempotent across a change of day. Not theoretical: that file's own comment records
  that a wrong-day computation *"permanently suppressed the right one."*
- **Acceptance:** No `@Cron` in `apps/api` passes `timeZone: BUSINESS_TIMEZONE`. Two tenants in
  different zones each get their sweep once per local day, proven by a test. A test covers
  `ReminderLog` idempotency when a tenant's day boundary moves.
- **Notes for the executor:** design the reminder key before the schedule. It currently embeds
  a globally-computed date; under per-tenant days it must embed the tenant's date, or one
  tenant's sweep can suppress another's.

### REQ-06 — Web obtains the tenant zone and labels what it shows `[UNVERIFIED]`

- **Statement:** Web receives the tenant's timezone on the session response and renders
  business-relevant times in that zone, always labelled with the zone name — never silently in
  the browser's zone.
- **Surface:** web, shared
- **Sources:**
  - `decisions/2026-09-09-tenant-timezone-configuration.md` — kind: decision — `status: reference` — tenant zone, always labelled; delivered on
    `/me`, explicitly **not** in the JWT.
  - `packages/shared/src/types/index.ts:4` — `[UNVERIFIED]` — kind: code — `JwtPayload` carries
    no zone; the browser has no other way to learn it today.
  - `apps/web/src/features/payroll/lib/payroll-week.ts:76`,
    `apps/web/src/features/craft-codes/components/craft-code-format.ts:27` — `[UNVERIFIED]` —
    kind: code — the two zone-less `businessToday()` calls.
- **Conflict:** none. The decision is **consistent with `c5c7f6a9`** (web's payroll panel already
  renders engine-emitted business-zone times) and **overrides mobile's device-zone choice** in
  `45934840` — see REQ-07.
- **Open question:** none for the display rule. **Q10 blocks the edit path only**
  (`PATCH /admin/tenants/:id`), not the read path.
- **Ripple:** the two `businessToday()` calls, plus every `toLocaleDateString` /
  `toLocaleTimeString` in web that renders a business-relevant time. That second set is **still
  not enumerated** — the enumeration only became meaningful once the display rule was settled,
  and it is U5's first task, not this spec's.
- **Acceptance:** The tenant zone reaches the browser on the session response and **not** in the
  JWT (checkable: `JwtPayload` gains no field). No business-relevant timestamp renders without a
  zone label. Both `businessToday()` calls pass an explicit zone.
- **Notes for the executor:** enumerate the `toLocale*` set first — this unit's scope is unknown
  until you do, and the two known call sites are not the whole of it.

### REQ-07 — Mobile labels field times against the tenant zone `[UNVERIFIED]`

- **Statement:** Mobile renders field times in the tenant's business zone, labelled — rather than
  in the device's zone, which is what it deliberately does today.
- **Surface:** mobile
- **Sources:**
  - `decisions/2026-09-09-tenant-timezone-configuration.md` — kind: decision — `status: reference` — tenant zone, always labelled.
  - Commit `45934840` — `[UNVERIFIED]` — kind: code — the deliberate device-zone choice this
    **overrides**, and its reason: *"pinning `Intl` to an IANA zone is not something to rely on
    across every Hermes build without testing it on device, and a wrong clock is worse than an
    unlabelled one."*
  - `apps/mobile/features/field-ticket/timers/zone-label.ts` — `[UNVERIFIED]` — kind: code —
    exports `isDeviceOnBusinessZone()` (:71) and `hoursFromBusinessZone()` (:110), built for a
    mismatch warning and **wired to no UI anywhere** (verified: no call site in `apps/` or
    `packages/`).
- **Conflict:** none, but this **reverses a deliberate prior decision**, and the constraint
  behind that decision has not gone away.
- **Open question:** none for the rule. **Residual open — §12 Q7:** what a *traveling* user
  sees. Raised by Syed Haris, who said he needs to check it.
- **The Hermes constraint is a real risk, not a footnote.** `45934840` declined to pin `Intl` to
  an IANA zone precisely because it was unverified across Hermes builds. This requirement asks
  for exactly that. **Device verification is part of this requirement's definition of done, not
  a follow-up** — and if it fails, the fallback is the existing labelled device-zone display
  plus a mismatch warning from the two helpers above.
- **Ripple:** the step summaries, the resume-step line, and the validation messages that express
  a constraint as a clock time — the times that become records and are read back later by
  someone who was not there.
- **Acceptance:** Field times render in the tenant zone with a visible label, **verified on a
  physical device**, not only a simulator. `isDeviceOnBusinessZone()` has a call site.
- **Notes for the executor:** mobile already calls the same `/users/me` endpoint U5 extends, so
  the carrier is shared — sequence after U5.

### REQ-08 — Existing tenant rows are backfilled `[UNVERIFIED]`

- **Statement:** Every existing `tenant_companies` row is backfilled to `America/Los_Angeles`,
  and the column is **NOT NULL with no default** — so every path that creates a tenant must
  state a zone.
- **Surface:** schema
- **Sources:**
  - `decisions/2026-09-09-tenant-timezone-configuration.md` — kind: decision — `status: reference` — backfill Pacific; NOT NULL, no default. A
    Pacific default was **explicitly rejected**, on the grounds that a silent default is how the
    current bug arose.
  - `.ai/vault/admin/gaps.md` → *what a newly created tenant must contain* — `[UNVERIFIED]` —
    kind: vault — **still open**; timezone is now a fifth required item, and the four
    reference-data sets it was raised for remain unanswered.
- **Conflict:** none
- **Open question:** none for the value. **Q11 is a scope question this requirement creates:**
  NOT NULL with no default means all eight tenant-creation consumers must supply a zone, and
  three of them — two `qa-automation` seeds and one hand-mirrored web type — are invisible to
  the compiler. See §12 Q11.
- **Ripple:** every row in `tenant_companies`; the eight creation consumers in Q11;
  `admin-tenants.service.spec.ts` (:35, :43–44, :62), which asserts on `tenantCompany.create`
  arguments.
- **Acceptance:** No `tenant_companies` row has a null timezone. Creating a tenant without a zone
  is rejected. All eight consumers in Q11 supply one — including the two `qa-automation` seeds,
  which no gate will check for you.
- **Notes for the executor:** write the backfill and the `SET NOT NULL` in the **same** migration
  — a nullable window between them is a window in which a row can be created without a zone.
  `tcg-prisma-guardian` is mandatory before this merges.

### REQ-09 — The business day starts at a stated wall-clock time `[UNVERIFIED]` — **out of scope**

- **Statement:** The business day starts at **00:00 local** — midnight in the tenant's own zone,
  not a global instant.
- **Out of scope for this ticket, by its own condition.** This spec said REQ-09 was "out of scope
  if the answer is midnight." The answer is midnight, and `business-time.ts` already implements
  exactly that, unconditionally. **No code changes, and no unit.**
- **Surface:** shared
- **Sources:**
  - `decisions/2026-09-09-business-day-starts-at-midnight-local.md` — kind: decision — `status: reference` — Syed Haris, 2026-09-09: *"at 00:00 local,
    12 am pakistan is different then 12 am us"*.
  - `payroll/payroll-rule-dependency-matrix.md` §4, row 14 — `[UNVERIFIED]` — kind: vault — the
    hole this closes: *"No workday-start concept exists anywhere in the vault… every daily-OT
    rule in the register presumes a workday boundary nobody has defined."*
  - `payroll/rules/PAY-001-saturday-friday-payroll-week.md` — `[UNVERIFIED]` — kind: vault —
    `status: settled`. With this decision the platform finally has a written answer to **when
    Saturday begins**, which PAY-001 alone never gave.
  - `decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md` — `[VERIFIED]` — kind:
    decision — Corrina Bustos put cross-midnight day-type change at 00:00 by calendar day.
    Consistent.
- **Conflict:** none
- **Open question:** none. **A caveat that belongs in the record:** this is a developer confirming
  a California labor-law boundary. The dependency matrix raises `WorkdayStartTime` as a *legal*
  requirement — CA requires a consistently recurring 24-hour workday. **Corrina Bustos should
  still ratify it**, and until she does this stays `status: reference`, not `verified`.
- **Ripple:** none — the code already does this.
- **Acceptance:** n/a. The acceptance is that the decision note exists and the vault hole is
  closed.
- **Notes for the executor:** nothing to do. Do not "implement" this; it is already true.

### REQ-10 — `FLEET_TIMEZONE` is retired onto the tenant zone `[UNVERIFIED]`

- **Statement:** The Samsara vehicle-tracking fleet day is decided by `TenantCompany.timezone`,
  the same value as every other business-day decision. The environment variables that
  currently decide it are deleted, and the two implementations converge onto
  `@tcg/shared`'s `business-time.ts`.
- **Surface:** api, web, shared
- **Sources:**
  - `decisions/2026-09-09-fleet-timezone-retired-onto-tenant-zone.md` — kind: decision — `status: reference`,
    Syed Haris 2026-09-09.
  - `decisions/2026-09-09-business-timezone-is-a-tenant-property.md` — kind: decision — the
    tenant grain this adopts.
  - `.ai/vault/assets/gaps.md` → *The fleet day* — kind: vault — the register that raised it.
- **Conflict:** none now. Until this requirement lands, `main` and this branch hold two
  contradictory answers — see §11a.
- **Open question:** none. Q9 resolved 2026-09-09.
- **What gets deleted:** `FLEET_TIMEZONE` (`apps/api/src/config/env.validation.ts:79`),
  `NEXT_PUBLIC_FLEET_TIMEZONE` (`apps/web/.env.example:38`, `apps/web/Dockerfile:65,84`),
  `DEFAULT_FLEET_TIMEZONE` (`packages/shared/src/constants/vehicle-tracking.ts:27`).
- **What gets rewired:** `apps/api/src/usecase/vehicle-tracking/fleet-day.ts` (reads the
  tenant zone via `TenantContext`, as REQ-03 establishes),
  `apps/api/src/presentation/vehicle-tracking/dto/vehicle-history.dto.ts` (its `IsFleetDate`
  constraint calls `fleetDayWindow`, and **class-validator constraints are not built through
  Nest DI** — the existing code already works around this by reading `process.env` directly,
  so how a tenant zone reaches a validator is a real design point, not a rename),
  `apps/web/src/features/vehicle-tracking/utils/fleet-date.ts` (reads the zone from `/me`,
  the mechanism Q6 settled).
- **Why this is safe with respect to Samsara:** the integration **never sends a timezone**.
  `apps/api/src/service/samsara/samsara.repository.ts` passes only `startTime`/`endTime` as
  absolute RFC 3339 instants, at all three call sites. `fleet-day.ts` states it plainly:
  *"It is the same instant either way; Samsara takes RFC 3339 with any offset."* Verified
  2026-09-09. Nothing about Samsara's contract changes.
- **A consequence to build for, not discover:** `business-time.ts` computes everything
  `fleet-day.ts` needs (`businessDateOf`, `startOfBusinessDay`, `endOfBusinessDayExclusive`)
  but has **no RFC 3339-with-offset formatter** — `formatInstant` (line 264) is
  `Intl.DateTimeFormat` for human display. `fleet-day.ts` currently emits
  `2026-09-08T00:00:00-07:00` deliberately, so *"a logged window reads as the times the
  drivers would recognise."* Samsara accepts `Z` equally, so nothing breaks functionally —
  but that log readability is lost unless a small formatter is added to `business-time.ts`.
  Add it; do not silently drop the behaviour.
- **Ripple:** the API and web fleet surfaces enumerated in §11a. Also `apps/api/.env.example`,
  `apps/web/.env.example`, `apps/web/Dockerfile` and any deployment config that sets either
  variable — **a deleted env var that is still set in a deploy pipeline fails silently**, so
  the deployment side is part of this requirement, not an afterthought.
- **Acceptance:** `git grep -n 'FLEET_TIMEZONE\|DEFAULT_FLEET_TIMEZONE'` returns nothing
  outside migration history; `grep -rn 'dayjs' apps/api/src/usecase/vehicle-tracking
  apps/web/src/features/vehicle-tracking` returns nothing; two tenants in different zones
  get different fleet days from the same instant, proven by a test.
- **Notes for the executor:** sequence **after** REQ-03/U3 — the tenant zone must already be
  reachable from a request before the fleet day can read it. The `IsFleetDate` validator is
  the awkward part and should be designed first, not last.

## 3. Data model — `apps/api/prisma/schema.prisma`

Settled 2026-09-09 by `decisions/2026-09-09-tenant-timezone-configuration.md` and
`decisions/2026-09-09-business-timezone-is-a-tenant-property.md`.

| Model | Field | Type | Notes |
| --- | --- | --- | --- |
| `TenantCompany` | `timezone` | `String @map("timezone") @db.VarChar(64)` — **NOT NULL, no default** | IANA zone id, e.g. `America/Los_Angeles`. Existing rows backfilled to Pacific in the same migration. |

- Migration: mandatory, under `apps/api/prisma/migrations/`.
- `TenantCompany` is the tenant root and carries no per-tenant business code, so the
  Identity Convention's `@@unique([tenantCompanyId, <code>])` does not apply.
- **`settings Json?` is not the place for this.** It is unused today, cannot be validated
  by Prisma, and a zone that is read on every business-day decision should not require a
  JSON path traversal.
- **`tcg-prisma-guardian` must run before this migration merges** — `CLAUDE.md` and
  `GUIDE.md` §2 both require it whenever schema moves.

## 4. API surface — `apps/api`

No new endpoint. Three changed shapes, all `SUPER_ADMIN`-scoped except the session read:

| Endpoint | Change | Status | Unit |
| --- | --- | --- | --- |
| `POST /admin/tenants` | **requires** `timezone` (NOT NULL, no default) | settled | U2 |
| `GET /users/me` | returns the tenant zone — **not** the JWT | settled | U5 |
| `PATCH /admin/tenants/:id` | accepts `timezone` | **blocked — Q10**: nobody has said what happens to an open payroll period when the zone under it moves | U5 |

The internal carrier — `TenantContext` gaining a `timeZone` — is not an API surface change
and is described in REQ-03.

## 5. Web surface — `apps/web`

**The rule is settled; the surface is not enumerated.** Business-relevant times render in the
**tenant's zone, always labelled**. The zone arrives on the session response, not the JWT.

No screen, component or copy is named here, and that is still deliberate — but the reason has
changed. It is no longer "nothing is written"; it is that **the set of affected call sites is
not yet known**. §11a lists the two `businessToday()` calls, but every
`toLocaleDateString`/`toLocaleTimeString` in web renders in the browser's zone today and has
never been enumerated — the enumeration only became meaningful once the display rule was
settled. **Enumerating it is U5's first task**, and U5's size is unknown until it is done.

## 6. Mobile surface — `apps/mobile`

**The rule is settled: tenant zone, labelled** — which reverses the deliberate device-zone
choice in `45934840`. The constraint behind that choice has not gone away: pinning `Intl` to an
IANA zone was never verified across Hermes builds, and **device verification is part of REQ-07's
definition of done, not a follow-up**. If it fails, the fallback is the existing labelled
device-zone display plus a mismatch warning from `isDeviceOnBusinessZone()` /
`hoursFromBusinessZone()`, which already exist and are wired to nothing.

**Residual open — §12 Q7:** what a traveling user sees.

## 7. Shared package — `packages/shared`

- `BUSINESS_TIMEZONE` changes role from "the answer" to "the fallback". Its docblock must
  stop saying *"every tenant is Local 12 / California"* once that is no longer the design.
- No function signature in `business-time.ts` needs to change — all 11 already take
  `timeZone`. This is the reason the ticket is wiring rather than a rewrite.
- Whether `JwtPayload` gains a field is **Q6**, and REQ-06 argues against it.

## 8. Permissions and tenancy

- Who may edit a tenant's timezone: **Q6**. Today `TenantCompany` is writable only via
  `@Roles(Role.SUPER_ADMIN)` on `admin-tenants.controller.ts:13`.
- **The tenant-scoping client extension does not help here.** Reading `TenantCompany` to
  resolve a zone is a read of the tenant root, and the 8 cron sweeps run entirely outside
  tenant context. `contexts/prisma.md` documents the allowlist and the three skip
  conditions; `tcg-prisma-guardian` must confirm the resolution read is safe rather than
  this spec asserting it.

## 9. Validation rules

- The stored value must be a valid IANA zone identifier. The only honest validation is a
  runtime probe — `Intl.DateTimeFormat(undefined, { timeZone: v })` throws on an invalid
  zone — because the tz database changes and a hardcoded enum goes stale.
- An offset string is invalid input (REQ-02).
- **Any** valid IANA zone is acceptable — a fixed US-only list was considered and rejected
  (Q2, 2026-09-09). Narrowing later is a safe change; widening a stored enum is not.
- The column is **NOT NULL with no default**, so absence is a validation failure at every
  tenant-creation path, not a silent fallback. See §12 Q11 for the three paths the compiler
  cannot enforce that on.

## 10. Tests

- `business-time.spec.ts` already covers both DST transitions, 23h/25h days, the
  Friday-evening boundary and the `effectiveTo` edge. Extend rather than replace.
- REQ-04 needs a test proving `calculatePayPeriod` gives different answers for two zones
  across a boundary — that test is the whole point of the requirement.
- The `PayrollService.calculate` selection-window tests added in `047f9f4a` (Pacific bounds
  at 07:00Z) become zone-parameterised.
- REQ-05 needs a `ReminderLog` idempotency test across a day-boundary change — the file's own
  comment records that a wrong-day computation "permanently suppressed the right one."
- REQ-07's acceptance requires **on-device** verification, not a simulator run.
- REQ-08 needs the two `qa-automation` seeds to actually run — they are the only check on the
  three creation paths no compiler sees (§12 Q11).
- Not yet specifiable: the web `toLocale*` test set, because the call sites are not enumerated
  (§5). That is U5's first task, not an open question.

## 11. Non-functional

- The zone must be resolved **once per request**, not per call site. 43 call sites doing
  their own lookup is 43 queries; `TenantContext` is the existing mechanism that avoids it.
- Changing a tenant's zone re-dates in-flight business decisions. Whether that is allowed at
  all, and what happens to an open payroll period when it happens, **is not answered.** It was
  written here as "part of Q5", but Q5 asked only about the *initial* value — backfill and
  nullability — and its 2026-09-09 answer settles only that. Nobody has said what happens to
  a period already open when the zone under it moves. Raised properly as **Q10**.

## 11a. Ripple — already-shipped behaviour these requirements reach

Enumerated by:
`grep -rn -E 'businessDayRange|startOfBusinessDay|endOfBusinessDayExclusive|businessToday|businessDateOf|calendarDateToUtc|addBusinessDays|wallClockIn|minutesFromBusinessMidnight|formatDateColumn|weekdayOf' apps/api/src | grep -v '\.spec\.'`
and `grep -rln 'BUSINESS_TIMEZONE' apps packages` (excluding `dist/` and `.next/`).

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| `usecase/notifications/notification-scheduled-jobs.service.ts` (8 sites, 4 crons) | shared export + `@Cron` | REQ-03, REQ-05 | changes deliberately — hourly-select per tenant (U4) | `decisions/2026-09-09-tenant-timezone-configuration.md` | grep above |
| `usecase/quotations/quotations.service.ts` (7 sites) | shared export | REQ-03 | changes deliberately | `quotations/gaps.md` → *Valid until* is **open** and asks the same question | grep above |
| `usecase/payroll/payroll.service.ts` (7 sites) | shared export | REQ-03, REQ-04 | changes deliberately | `payroll/rules/PAY-001…` | grep above |
| `usecase/projects/project-list.helpers.ts` (3) | shared export | REQ-03 | changes deliberately | — | grep above |
| `usecase/price-listings/price-listing-adjustment-expiry.service.ts` (3 sites, 2 crons) | shared export + `@Cron` | REQ-03, REQ-05 | changes deliberately — hourly-select per tenant (U4) | `decisions/2026-09-09-tenant-timezone-configuration.md` | grep above |
| `utility/date-boundary.util.ts` (2) | shared export | REQ-03 | changes deliberately | its own docblock | grep above |
| `usecase/quotations/quotation-expiry.service.ts` (2, 1 cron) | shared export + `@Cron` | REQ-05 | changes deliberately — hourly-select per tenant (U4) | `decisions/2026-09-09-tenant-timezone-configuration.md` | grep above |
| `usecase/me/me.service.ts` (2) | shared export | REQ-03 | changes deliberately | — | grep above |
| `usecase/docusign/quotation-pdf.service.ts` (2) | shared export | REQ-03, REQ-06 | changes deliberately — renders the tenant zone, labelled. A PDF has no viewer, so the device-zone option never applied to it (U5) | `decisions/2026-09-09-tenant-timezone-configuration.md` | grep above |
| `usecase/das/das.service.ts` (2) | shared export | REQ-03 | changes deliberately | commit `35d84071` | grep above |
| `usecase/das-allocations/das-allocations.service.ts` (2) | shared export | REQ-03 | changes deliberately | — | grep above |
| `usecase/asset-management/tools/tools.service.ts` (2) | shared export | REQ-03 | changes deliberately | commit `35d84071` | grep above |
| `service/craft-rate-resolver/craft-rate-resolver.service.ts` (2) | shared export | REQ-03 | changes deliberately | commit `cdc34c30` | grep above |
| `usecase/permits/permit-expiry.service.ts` (1, 1 cron) | shared export + `@Cron` | REQ-05 | changes deliberately — hourly-select per tenant (U4) | `decisions/2026-09-09-tenant-timezone-configuration.md` | grep above |
| `web/features/payroll/lib/payroll-week.ts:76` | `businessToday()` | REQ-06 | changes deliberately — tenant zone, labelled (U5) | `decisions/2026-09-09-tenant-timezone-configuration.md` | grep above |
| `web/features/craft-codes/components/craft-code-format.ts:27` | `businessToday()` | REQ-06 | changes deliberately — tenant zone, labelled (U5) | `decisions/2026-09-09-tenant-timezone-configuration.md` | grep above |
| `payroll-engine/src/slices.ts`, `explain.ts`, `index.ts` | `BUSINESS_TIMEZONE` import | REQ-04 | changes deliberately | — | `grep -rn 'toPacific' packages/*/src` |
| `mobile/features/field-ticket/timers/zone-label.ts` | `BUSINESS_TIMEZONE` import | REQ-07 | changes deliberately — tenant zone, labelled (U6). **Traveling-user display is the one residual** — see §12 Q7 | `decisions/2026-09-09-tenant-timezone-configuration.md` | grep above |

| `apps/api/prisma/scripts/seed-payroll-demo.ts:917` `calculatePayPeriod` | direct call into `@tcg/payroll-engine` | REQ-04 | **unchanged — and unchecked.** Found during U1, 2026-09-09 | see note below | `grep -rn 'calculatePayPeriod' apps/api` |

**A fourth definition of "what day is it" is live on `main` today.** Found 2026-09-09 while
verifying a decision note, and **not present in the enumeration above** because the grep that
produced §11a was run against this branch.

`Fetaure/samsara-integration` has **already merged**, and `main` is **83 commits ahead** of
`fix/timezone-business-day`. It brings a second, process-wide, env-var-configured timezone:

| On `main` | What |
| --- | --- |
| `packages/shared/src/constants/vehicle-tracking.ts:27` | `DEFAULT_FLEET_TIMEZONE = 'America/Los_Angeles'` |
| `apps/api/src/usecase/vehicle-tracking/fleet-day.ts:29` | `return process.env.FLEET_TIMEZONE \|\| DEFAULT_FLEET_TIMEZONE;` |
| `apps/api/src/config/env.validation.ts:79` | `FLEET_TIMEZONE` Joi-validated with that default |
| consumers | `vehicle-history.service.ts`, `presentation/vehicle-tracking/dto/vehicle-history.dto.ts`, `usecase/vehicle-tracking/index.ts` |
| `apps/web/src/features/vehicle-tracking/utils/fleet-date.ts:33` | **a second copy on the web side** — `const FLEET_TIMEZONE = process.env.NEXT_PUBLIC_FLEET_TIMEZONE \|\| DEFAULT_FLEET_TIMEZONE` |
| `apps/web/.env.example:38` | `NEXT_PUBLIC_FLEET_TIMEZONE=America/Los_Angeles`, commented *"Must match the API's FLEET_TIMEZONE"* — kept in step **by hand**, with nothing failing if they drift |
| `apps/web/Dockerfile:65,84` | `ARG` + `ENV` — so the web value is **baked into the bundle at build time** |

Verified by `git ls-tree -r main --name-only | grep fleet-day` and
`git grep -n 'FLEET_TIMEZONE' main -- apps/api/src`.

This matters for three reasons and none of them are cosmetic:

1. **It contradicts the per-tenant decision on its face.** `decisions/2026-09-09-business-timezone-is-a-tenant-property.md`
   settled that the business timezone is tenant data. `FLEET_TIMEZONE` is an environment
   variable — one value for the whole process, every tenant. It is the same class of
   assumption this ticket exists to remove, one layer over.
2. **It falsifies `cdc34c30`'s premise.** That commit's message says three competing
   definitions of "what day is it" were collapsed onto one shared implementation. A fourth
   was merging into `main` in parallel and is there now. The count was right on this branch
   and wrong about the repo.
3. **It uses a different library.** `fleet-day.ts` uses `dayjs` + `dayjs/plugin/timezone`;
   `business-time.ts` uses native `Intl`. Two implementations of the same question is the
   precise condition `slices.ts`'s own docblock warns produced the original engine/resolver
   disagreement.
4. **On web it is a build-time constant, not a runtime setting.** `fleet-date.ts:33` captures
   `NEXT_PUBLIC_FLEET_TIMEZONE` into a module-level `const`, and Next inlines
   `NEXT_PUBLIC_*` at build time — confirmed by `apps/web/Dockerfile:65,84` passing it as an
   `ARG`. The web fleet zone is therefore **baked into the image** and cannot be changed
   without a rebuild, let alone varied per tenant. Making the fleet day per-tenant is not a
   wiring change on web; it is removal of the env var.

**The direction of this is the opposite of how it first reads, and it is our problem, not
theirs.** `fleet-day.ts` is on `main`; **`business-time.ts` is not** — it exists only on
`fix/timezone-business-day`, along with `cdc34c30`. So the *shipped* state of the platform is
the env-var fleet zone, and **this branch is the one introducing a second answer.** That makes
reconciliation a pre-merge obligation of this ticket rather than a follow-up someone else
owns.

`.ai/vault/assets/gaps.md` → *The fleet day* remains **open** and is the register for
whether the fleet day adopts the business day at all. Not folded into a unit here: adopting
or retiring `FLEET_TIMEZONE` is product scope this ticket was never granted. **It does block
the merge conversation**, though — see §12 Q9.

**A third engine call site that no gate can see.** `apps/api/tsconfig.json` sets
`rootDir: ./src` and `include: ["src/**/*"]`, so `apps/api/prisma/scripts/` is outside
`@tcg/api:build`, outside `tsconfig.spec.json`, and `@tcg/api` has **no `typecheck`
target** at all — the script runs via `ts-node --transpile-only`. Verified 2026-09-09.
Consequence: when U1 made `timeZone` a required field, the compiler enforced it at the two
`src/` call sites and **could not see the third**. It passes `undefined` today and falls
through to `wallClockIn`'s own default, so the demo seed still emits identical Pacific
output — no regression, but it is now the one place in the repo where the business zone is
decided implicitly, and the mechanism that hid it will hide the next one too.

This is the same class of hole `CLAUDE.md` already documents for `qa-automation/` — code
that no hook and no CI job typechecks. Not a product question, so it is not a §12 entry;
it needs either U3 picking up the seed script when it does the real tenant lookup, or
`prisma/scripts` added to a typecheck target. Recorded here so the next executor sees it.

- **Surfaces with no existing behaviour in this area:** `qa-automation/` — established by
  `grep -rln 'BUSINESS_TIMEZONE\|businessToday' qa-automation` returning nothing. Note that
  this suite is outside the workspace and is linted by nothing, so an absent grep is the
  only signal available.
- **Consumers with no source for what happens to them: none, as of 2026-09-09.** Every row
  above now cites a decision. The four categories that had none — the 8 cron jobs, the two
  web call sites, the DocuSign PDF and mobile's `zone-label.ts` — were resolved by Q4 and Q7
  and their decision notes. The single surviving unknown is **what a traveling user sees**
  (§12 Q7 residual), which is a display question inside an answered requirement, not an
  unsourced consumer.

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Nothing below is built until these are answered.

Sweep: `grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md`

### Q1 — Who approved "per tenant", and on what date? — **RESOLVED**

- **Question:** Name the TPM who approved locking the timezone per tenant, and the date.
- **Answer (2026-09-09):** Recorded under **Syed Haris**, in session, 2026-09-09. He
  relayed a TPM approval, but **the TPM's name and the approval date were not captured**,
  so the decision note carries `status: reference` rather than `verified` — binding on
  implementation, open to being overruled by TCG. This is the same basis as
  `2026-09-08-artifact-due-date-seeded-from-first-job-day.md`.
- **Residual:** the TPM attribution is still uncaptured. If that name and date surface,
  add them to the decision note's `decided_by`; it does not change the decision, only how
  much weight it carries against `assets/gaps.md`'s named owners (Brian Petros, with
  Corrina Bustos on payroll), who have not spoken to this.
- **Blocked:** was REQ-01 — now unblocked
- **Owner:** Syed Haris
- **Status:** resolved — see decisions/2026-09-09-business-timezone-is-a-tenant-property.md

### Q2 — Is the timezone free-form IANA, or a restricted set?

- **Question:** May a tenant be set to any IANA zone, or only a fixed list (e.g. the six US
  zones)?
- **Why it cannot be answered from what is written:** nothing specifies a tenant locale,
  region or address field at all — `admin/gaps.md` → *company identity* records that even
  the company address currently lives in env vars and whether it should move onto the
  `TenantCompany` row is itself open.
- **Blocked:** REQ-01 validation, §9
- **Candidates:** `.ai/vault/admin/gaps.md` → *company identity* (open); `admin/fcc-nexgen-administration-and-security.md`
  (`unverified`, legacy: records only *Payroll Week Ending = Friday*).
- **Owner:** product team
- **Workaround:** validate as any valid IANA zone via a runtime `Intl` probe. Strictly
  narrowing later is a safe change; widening a stored enum is not.
- **Answer (2026-09-09):** Any valid IANA zone, validated by a runtime `Intl.DateTimeFormat` probe. A fixed US-only list was rejected: nothing written supports it, narrowing later is safe, widening a stored enum is not.
- **Status:** resolved — see decisions/2026-09-09-tenant-timezone-configuration.md

### Q3 — Is the business timezone a property of the tenant, the yard, or the job site? — **RESOLVED**

- **Question:** When a tenant has work in more than one zone, whose zone decides the
  payroll day — the tenant's, the yard's, or the job site's?
- **Answer (2026-09-09):** The **tenant's**, under the explicitly recorded constraint that
  **every tenant today operates in exactly one zone**. The constraint is not decoration: it
  is what makes the tenant's zone equal to the work location, which is what
  `business-time.ts` already claims business-day decisions must follow.
- **Deferred, not eliminated:** the question the record actually raises — Ryan Adams on
  "Arizona and Nevada and Texas", Ehtesham's "a yard is a tenant", Brian Petros confirming
  each yard has exactly one address, Melissa McNutt on state-specific certifications — is
  postponed by the constraint, not answered by it. **If a tenant is ever onboarded that
  operates in two zones, the grain must be revisited before that onboarding**, because at
  that point every resolution point moves from one lookup per request to one per row.
- **Blocked:** was REQ-01, REQ-03 — both now unblocked
- **Owner:** Brian Petros, with Corrina Bustos on payroll — *neither has spoken to this*;
  the decision stands on Syed Haris's authority alone
- **Status:** resolved — see decisions/2026-09-09-business-timezone-is-a-tenant-property.md

### Q4 — What should the eight nightly sweeps do when tenants are in different zones?

- **Question:** Should each tenant's expiry/reminder sweep fire at that tenant's local
  01:00–05:00, or should one global run compute each tenant's target date separately?
- **Why it cannot be answered from what is written:** nothing specifies the sweeps' timing
  intent beyond a "quiet window", and `@Cron`'s `timeZone` is a decorator argument that
  cannot vary per tenant. The reminder keys embed the computed date, so the two options are
  not interchangeable: they differ in idempotency and in what a zone change does to a
  reminder already sent.
- **Blocked:** REQ-05
- **Candidates:** none: nothing written. Searched `admin/`, `field-ops/`, `dispatch/`.
  `dispatch/confirmations-playbook.md` (`unverified`) has clock cutoffs — *"all jobs must
  be confirmed the business day before"*, a **12:00 PM** dispatch-email cutoff, a
  Thursday-noon threshold — **all stated with no timezone attached**, which is the same
  defect one layer up.
- **Owner:** product team
- **Workaround:** if Q3 answers "one zone per tenant, all tenants currently Pacific", the
  sweeps can keep one schedule and compute per-tenant dates in the body — correct for
  today and correct for a second zone later. Label it as the interim it is.
- **Answer (2026-09-09):** Each tenant's **local** quiet window, not one global run.
- **Consequence, recorded because it is not free:** `@Cron`'s `timeZone` is a decorator argument fixed at class-definition time, so this cannot be a schedule. U4 becomes *run hourly, select the tenants whose local time has just crossed the trigger* — the more expensive of the two shapes. Precedent exists: `notification-scheduled-jobs.service.ts:211` already runs `EVERY_HOUR`.
- **Status:** resolved — see decisions/2026-09-09-tenant-timezone-configuration.md

### Q5 — What zone do existing tenants get, and may the column be null?

- **Question:** Backfill every existing `tenant_companies` row to `America/Los_Angeles` and
  keep that as the column default, or make the column required with no default so tenant
  creation must state a zone?
- **Why it cannot be answered from what is written:** `admin/gaps.md` → *what a newly
  created tenant must contain* is **open** and lists four reference-data sets; **timezone
  is not among them**. A default is the safe migration and the unsafe product answer — it
  is precisely how the current silent Pacific assumption got in.
- **Blocked:** REQ-08, REQ-01's migration
- **Candidates:** `.ai/vault/admin/gaps.md` → *what a newly created tenant must contain*
  (open).
- **Owner:** product team
- **Workaround:** none that is honest. Both options are one line; they differ in what
  happens to the *next* tenant, which is the whole question.
- **Answer (2026-09-09):** Backfill every existing row to `America/Los_Angeles` — correct, since every tenant today is Local 12 / California — and make the column **NOT NULL with no default**, so creating a tenant must state a zone. A Pacific default was explicitly rejected: a silent default is how the current bug arose.
- **Consequence:** `CreateAdminTenantDto` must gain the field in the same unit, or tenant creation breaks.
- **Status:** resolved — see decisions/2026-09-09-tenant-timezone-configuration.md

### Q6 — Who sets a tenant's timezone, and how does a change propagate?

- **Question:** Is the timezone SUPER_ADMIN-only (`admin/tenants`), or self-serve for a
  tenant admin under `/settings`? And when it changes, must existing sessions pick it up
  immediately?
- **Why it cannot be answered from what is written:** nothing states it. The mechanism
  matters: if the zone rides in the JWT, a stale token keeps pricing against the old zone
  until it expires; if it rides on `/me`, it does not.
- **Blocked:** REQ-06, §4, §8
- **Candidates:** none: nothing written. `apps/api/src/presentation/admin/admin-tenants.controller.ts:13`
  establishes only the current mechanism, not the intent.
- **Owner:** product team
- **Workaround:** SUPER_ADMIN-only via the existing admin surface is the smaller change and
  matches every other `TenantCompany` field today.
- **Answer (2026-09-09):** **SUPER_ADMIN only**, via the existing `admin/tenants` surface. Not tenant self-serve. The zone is delivered on the **`/me` / session response, not in the JWT** — a token is not reissued when the zone changes, so a stale token would keep making business-day decisions in the old zone until expiry.
- **Status:** resolved — see decisions/2026-09-09-tenant-timezone-configuration.md

### Q7 — What does the end user actually see — an instant in whose zone, and is it labelled?

- **Question:** For a timestamp on screen (payroll review, dispatch board, ticket summary,
  the signed quotation PDF), does the user see the tenant's business zone, their own device
  zone, or both — and is the zone named next to the number?
- **Why it cannot be answered from what is written:** the vault's only writing about time
  display is `admin/gaps.md` → *Time display*, which is **open** and about 12h/24h format,
  not zone. Meanwhile the two surfaces already disagree in shipped code: mobile
  deliberately labels in the **device** zone (`45934840`), while web's payroll panel was
  changed to render engine-emitted **business-zone** `HH:mm` precisely so *"the panel can no
  longer disagree with the money it exists to explain"* (`c5c7f6a9`). Both are defensible;
  nobody has chosen. A PDF has no viewer at all, so it cannot use the device answer.
- **Blocked:** REQ-06, REQ-07, §5, §6
- **Candidates:** `.ai/vault/admin/gaps.md` → *Time display — military, 12-hour, or
  per-user* (open); `.ai/vault/quotations/gaps.md` → *Valid until* (open, asks *"in whose
  timezone is that day defined?"*).
- **Owner:** product team — Brian Petros (already the named voice in the *Time display* gap)
- **Workaround:** label everything that becomes a record with its zone and convert nothing.
  That is what mobile already does, it is strictly better than today, and it does not
  foreclose the answer.
- **Answer (2026-09-09):** The **tenant's business zone**, and **always labelled** with the zone name. Not the viewer's device zone.
- **Residual — still open.** Raised by Syed Haris, who said he needs to check it: what a user sees when they are normally in the US but travel to, say, Pakistan. The analysis he was given, recorded as analysis and not as decision: business-day decisions follow the **work location** and do not move when a person travels — a California shift is worth what it was worth. The traveler case bites on **display**, where an unlabelled tenant-zone `06:00` shown to someone whose phone reads `19:00` is unfalsifiable. That is the argument *for* the labelling above, not a separate feature. `apps/mobile/features/field-ticket/timers/zone-label.ts` already exports `isDeviceOnBusinessZone()` (line 71) and `hoursFromBusinessZone()` (line 110), built for exactly this mismatch warning and **wired to no UI anywhere** (verified: no call site in `apps/` or `packages/`). Whether a traveling user gets a warning, a dual display, or nothing is undecided.
- **Status:** resolved on the main question — see decisions/2026-09-09-tenant-timezone-configuration.md. **Residual open:** the traveling-user display.

### Q8 — When does the business day start?

- **Question:** Does the business day start at 00:00 local, or at a stated
  `WorkdayStartTime`?
- **Why it cannot be answered from what is written:** the vault names this as a known hole
  in its own dependency matrix — *"no workday-start concept exists anywhere in the vault…
  every daily-OT rule in the register presumes a workday boundary nobody has defined"* —
  and warns *"do not assume that a shift start, payroll date, or midnight automatically
  defines the legal workday."* PAY-001 settles Saturday–Friday but not when Saturday
  begins. The code implements midnight, unconditionally.
- **Blocked:** REQ-09. Does **not** block REQ-04.
- **Candidates:** `payroll/payroll-rule-dependency-matrix.md` §4 + row 14 (`unverified`);
  `payroll/rules/PAY-001-saturday-friday-payroll-week.md` (`settled` — week only);
  `decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md` (`verified` — day
  type only).
- **Owner:** Corrina Bustos (payroll), the named human on the 2026-09-04 decision
- **Workaround:** confirming "midnight" takes this out of scope entirely and costs one
  line. Leaving it unasked ships a system that looks configured and is not.
- **Answer (2026-09-09):** **00:00 local** — midnight in the tenant's own zone, not a global instant. Syed Haris: *"at 00:00 local, 12 am pakistan is different then 12 am us"*.
- **Effect:** REQ-09 is **out of scope**. This ratifies what `business-time.ts` already implements, so it costs no code — but it closes a hole the vault named itself (`payroll/payroll-rule-dependency-matrix.md` row 14), and combined with PAY-001 it finally defines when Saturday *begins*.
- **Caveat:** a developer confirming a California labor-law boundary is weaker than the payroll owner doing so. **Corrina Bustos should still ratify.**
- **Status:** resolved — see decisions/2026-09-09-business-day-starts-at-midnight-local.md

### Q9 — Is `FLEET_TIMEZONE` retired in favour of the per-tenant zone before this branch merges?

- **Question:** `main` now carries a second, process-wide, env-var timezone
  (`FLEET_TIMEZONE`, defaulting to `America/Los_Angeles`) used by the Samsara vehicle-tracking
  code. Does the fleet day adopt `TenantCompany.timezone`, or does it stay an env var?
- **Why it cannot be answered from what is written:** `.ai/vault/assets/gaps.md` → *The fleet
  day* is **open** and asks precisely this, and asks a second question nothing has answered —
  whether the fleet day, the job day and the payroll day must share one boundary at all.
- **Why it is new:** raised 2026-09-09, after the rest of §12 was answered. `Fetaure/samsara-integration`
  merged into `main` while this branch was being written; `main` is **83 commits ahead**. The
  §11a enumeration was run against this branch and could not see it.
- **Blocked:** nothing in `units.md`. It blocks the **merge conversation**, not the build —
  see §11a.
- **Candidates:** `.ai/vault/assets/gaps.md` → *The fleet day* (open); on `main`,
  `apps/api/src/usecase/vehicle-tracking/fleet-day.ts:29`,
  `apps/api/src/config/env.validation.ts:79`,
  `packages/shared/src/constants/vehicle-tracking.ts:27`,
  `apps/web/src/features/vehicle-tracking/utils/fleet-date.ts:33`,
  `apps/web/.env.example:38`, `apps/web/Dockerfile:65,84`.
- **The contradiction is structural, not a wiring gap.** Every item the tenant-timezone
  decision settles is a per-tenant DB column set by a SUPER_ADMIN and read per request.
  `FLEET_TIMEZONE` is a process-wide env var that no tenant can vary, no admin can see, and
  on web is baked into the bundle at build time. These do not meet in the middle — one of
  them has to go.
- **Owner:** Brian Petros, with whoever owns the Samsara integration
- **Workaround:** none needed to ship U1–U6 — the two systems touch no common file, so
  nothing in `units.md` is blocked. But "leave it alone" is only coherent while both answers
  agree, which today they do because both default to `America/Los_Angeles`. The moment one
  tenant is set to anything else, the tracking screens and the payroll engine report
  different days for the same fleet, and **nothing anywhere reports the divergence** — the
  API and web copies are already kept in step by a comment in `.env.example`.
- **Answer (2026-09-09):** **Retired.** The fleet day reads `TenantCompany.timezone`, and
  `fleet-day.ts` / `fleet-date.ts` converge onto `business-time.ts` (native `Intl`), dropping
  `dayjs` from both surfaces. Now REQ-10.
- **Why it is safe:** Samsara never receives a timezone — only absolute RFC 3339 instants.
  Verified across all three `samsara.repository.ts` call sites. The retirement asks nothing
  of Samsara.
- **Status:** resolved — see decisions/2026-09-09-fleet-timezone-retired-onto-tenant-zone.md

### Q10 — What happens to an open payroll period when a tenant's timezone changes?

- **Question:** May a tenant's timezone be changed while a payroll period is open — and if
  so, is the open period re-dated under the new zone, frozen under the old one, or refused?
- **Why it cannot be answered from what is written:** nothing addresses it. This spec
  previously deferred it to Q5, which was the wrong home: Q5 asked what value a tenant
  *starts* with, and its answer says nothing about a later change. The deferral hid the
  question rather than answering it — caught 2026-09-09 while sweeping for gaps.
- **Why it is not academic:** the zone decides which payroll week a shift falls in
  (PAY-001, Saturday–Friday). Move the zone under an open period and shifts near the
  boundary change weeks — which changes the straight-time ceiling they consume, and
  therefore money. `decisions/2026-09-09-tenant-timezone-configuration.md` makes the zone
  SUPER_ADMIN-editable at any time, so this is reachable today, not hypothetical.
- **Blocked:** nothing in `units.md` — U2 can add the column without answering it. It blocks
  the *edit* path, which lands in U5 (§4, `PATCH /admin/tenants/:id`).
- **Candidates:** none: nothing written. Searched `payroll/rules/`, `payroll/gaps.md`,
  `admin/gaps.md`, `decisions/`.
- **Owner:** Corrina Bustos (payroll), with the product team on whether the edit is refused
- **Workaround:** refuse the change while any period is open, and say so in the error. It is
  the only option that cannot silently restate money, and it is trivially reversible once a
  real answer exists.
- **Status:** open

### Q11 — Do the two `qa-automation` tenant seeds get a zone, and who notices if they do not?

- **Question:** Q5's answer makes `timezone` NOT NULL with no default, so **every** tenant
  creation path must supply one. Seven exist. Two are in `qa-automation/`, which nothing
  lints, typechecks or runs in CI — do they get updated in U2, and what stops the next one
  from being missed?
- **Why it cannot be answered from what is written:** it is not a product question; it is a
  scope question U2 must answer explicitly, because the compiler will not answer it.
  Enumerated 2026-09-09 by
  `grep -rn 'tenantCompany\.create\|tenantCompany\.upsert' apps qa-automation`:

  | Site | Caught by the compiler? |
  | --- | --- |
  | `apps/api/src/service/tenant-companies/tenant-companies.repository.ts:22` | yes |
  | `apps/api/src/usecase/admin/admin-tenants.service.ts:87` | yes |
  | `apps/api/src/utility/seed-data.ts:800`, `:1042` | yes |
  | `apps/api/fcc-seeder/src/seed-all.ts:102` | yes — `apps/api/package.json:8` runs `tsc -p fcc-seeder/tsconfig.build.json` inside `@tcg/api:build`. Checked 2026-09-09; the earlier "separate tsconfig" flag is discharged. |
  | `qa-automation/e2e/support/seed/tenant.ts:62` | **no — outside the workspace** |
  | `qa-automation/e2e/support/seed/disposable-user.ts:112` | **no — outside the workspace** |

  **An eighth consumer, found 2026-09-09 by `tcg-decomposer` and not in the grep above** —
  because it is not a Prisma call at all. `apps/web/src/features/admin/types/index.ts:63`
  declares `CreateTenantPayload` as `{ name, tenantCode, maxUsers?, domain? }`, a **hand-written
  mirror of `CreateAdminTenantDto` with no `@tcg/shared` link**, consumed by
  `admin.service.ts:40` and `admin-create-tenant-modal.tsx`. The moment the API DTO requires
  `timezone`, the admin UI's create-tenant form posts a payload without it and **400s** — and
  because the type is declared in the web feature rather than imported from `@tcg/shared`,
  **the compiler has nothing to check it against.** This is precisely the case
  `tcg-contract-tracer` exists for, and precisely the failure mode commit `c5c7f6a9` already
  hit once on this branch (`PayrollJobDay.jobTicket` declaring fields the API had stopped
  returning, every read silently `undefined`).

- **Why it matters:** `CLAUDE.md` already records that `qa-automation/` is *"outside the
  pnpm workspace and not yet an Nx project — so no hook and no CI job lints, typechecks or
  runs it."* A NOT NULL column with no default turns that into a **runtime** failure in the
  E2E suite, discovered by whoever next runs it. This is the same blind spot as the
  `seed-payroll-demo.ts` finding in §11a, reached from the opposite direction.
- **Blocked:** nothing — but U2 is incomplete without it.
- **Owner:** whoever builds U2 — this is a scope decision, not a product one
- **Workaround:** none needed; just do not miss them. Registering `qa-automation` as an Nx
  project is the standing fix and is already an accepted PR #386 follow-up. Running
  `tcg-contract-tracer` on U2 would catch the web mirror; the two `qa-automation` seeds it
  would not, because nothing compiles them either.
- **Status:** open

### Q12 — What zone does a self-service signup tenant get? `POST /auth/signup` is a ninth creation path

- **Question:** `POST /auth/signup` (`@Public()`, `auth.controller.ts:40`) creates a
  `TenantCompany` — `AuthService.signUp` → `TenantCompaniesService.create` →
  `TenantCompaniesRepository.create` → `prisma.tenantCompany.create`. Nobody has said what
  zone a tenant created that way is in. Is self-service signup still a supported path at all,
  and if so, who states the zone — the person signing up, or is signup refused until an
  admin creates the tenant instead?
- **Why Q11's enumeration missed it:** Q11 grepped `tenantCompany\.create|tenantCompany\.upsert`,
  which finds the *repository line* (`tenant-companies.repository.ts:22`) but not the
  repository's own callers. `TenantCompaniesService.create(name, tenantCode)` is two hops
  above that grep hit, so the signup path never appeared in the eight-consumer table. Found
  2026-09-09 while building U2, by the compiler, not by the grep.
- **Why it is not academic:** the endpoint is `@Public()` and live. It also mints tenant codes
  as `TENANT-${Date.now()}`, which follows none of the platform's tenant-code conventions —
  so it may be legacy scaffolding rather than a supported path. Nothing in the repo calls it:
  `grep` over `apps/web`, `apps/mobile` and `qa-automation/e2e` returns no caller. But it
  answers on the deployed API regardless, and an external caller cannot be ruled out from here.
- **What U2 did, pending an answer:** `SignUpDto` gained a **required** `timezone`, validated
  with the same `IsIanaTimeZone` probe as `CreateAdminTenantDto`, threaded through
  `signUp(email, password, timezone, …)` and `TenantCompaniesService.create(name, tenantCode,
  timezone)`. This is the treatment the unit's own Outcome authorises — *"each either supplies
  a zone or fails loudly at the call site"* — and it is the only option that neither invents a
  Pacific default (rejected by Q5) nor kills a live endpoint outright. **It is still a fourth
  changed API shape that §4 does not list**, and a caller that omits the field now gets a 400.
  If the right answer is that signup should be refused entirely, or should inherit a zone from
  somewhere, this is a one-line change.
- **Blocked:** nothing — U2 shipped with the loud-failure treatment above.
- **Owner:** product, on whether self-service signup is a supported path at all
- **Status:** open

### Q13 — Are legacy abbreviation zone ids (`PST`, `EST`) acceptable input?

- **Question:** `spec.md` §9 says any valid IANA zone is acceptable and an offset is not. It
  does not say which side of that line the legacy compatibility identifiers fall on.
- **Why it surfaced:** the `Intl` probe §9 prescribes **does not reject an offset.** ECMA-402
  accepts offset time zones, so `new Intl.DateTimeFormat(undefined, { timeZone: '-08:00' })`
  does not throw — it resolves to `-08:00` and formats happily (verified on Node 22.14;
  `+08:00` and `-0800` too). The prescribed mechanism therefore does not enforce the rule it
  was given. U2's validator implements the **rule** — probe, then reject any value whose
  resolved zone matches `±HH:MM` — because REQ-02 states independently that the zone is
  "never an offset". That part needed no product answer. What it exposed is the adjacent
  case nobody has ruled on.
- **Why it is not academic:** `PST` and `EST` pass the probe. `PST` resolves to
  `America/Los_Angeles`, which is harmless. **`EST` resolves to `America/Panama`, which does
  not observe DST** — so someone typing `EST` meaning US Eastern gets a tenant whose business
  days are an hour off for eight months of the year, and the tenant looks correctly configured
  the whole time. That is this ticket's exact failure mode, reintroduced through the
  validation layer. Neither identifier appears in `Intl.supportedValuesOf('timeZone')`.
- **What U2 did, pending an answer:** accepted them. They are valid IANA identifiers and the
  written rule is "any valid IANA zone"; narrowing on an executor's judgement would be exactly
  the invented decision this loop is meant to prevent. Pinned by a named test block
  (`is-iana-time-zone.validator.spec.ts` → *legacy abbreviation identifiers — accepted, pending
  Q13*) so the decision is visible and one edit away.
- **Candidates:** narrow to `Intl.supportedValuesOf('timeZone')` — the runtime's own canonical
  list, which excludes both, still refreshes with the tz database, and is not a hardcoded enum.
  Cost: it also excludes valid *alias* identifiers (`Asia/Calcutta`, `US/Pacific`).
- **Blocked:** nothing — U2 shipped accepting them.
- **Owner:** whoever owns the tenant-timezone decision (Syed Haris relaying, per Q1)
- **Status:** open

### Q14 — Should bare-abbreviation zones like `EST` be rejected?

- **Question:** `Intl` accepts `EST`, `MST`, `HST` and `PST` as valid zone ids. `EST` resolves
  to `America/Panama`, **which observes no DST**. Should the validator require an
  `Area/Location` identifier and reject the abbreviations?
- **Why this is not pedantry — verified 2026-09-09:**

  ```
  EST  → ACCEPTED, resolves to America/Panama
  2026-07-15T20:00:00Z reads  America/New_York 16:00  ·  EST 15:00
  ```

  A tenant set to `EST` is an hour wrong for half the year, on every payroll-week boundary,
  every rate-in-force lookup and every cron trigger. **That is this ticket's original bug,
  arriving through the validation built to prevent it.**
- **Also found, and already fixed in U2:** §9 of this spec prescribed
  `Intl.DateTimeFormat(undefined, {{ timeZone: v }})` as the check, and asserted separately
  (REQ-02) that an offset is invalid. **The prescribed probe does not enforce that rule** —
  `-08:00`, `+08:00` and `-0800` all pass it. The executor implemented the rule rather than
  the mechanism and rejects offsets explicitly. The spec was wrong; the code is right.
- **Blocked:** nothing. U2 accepts the abbreviations today and pins the choice in a named
  test block, so reversing it is one edit.
- **Owner:** product team
- **Workaround:** in place — the current behaviour is the documented "any valid IANA zone".
- **Status:** open

### Q15 — Should public signup create a tenant at all?

- **Question:** `POST /auth/signup` is `@Public()` and creates a `TenantCompany`
  (`AuthService.signUp` → `TenantCompaniesService.create` → `tenantCompany.create`). It mints
  tenant codes as `TENANT-${{Date.now()}}`, matching no platform convention. Is this a live
  product surface, or legacy scaffolding that should be removed?
- **Why it surfaced:** Q11 enumerated eight creation paths by grepping
  `tenantCompany.create|upsert`. That grep finds the **repository line** but not the
  repository's *callers* — signup sits two hops above it. **The compiler found the ninth path,
  the enumeration did not.** Verified 2026-09-09: `auth.controller.ts:43-44` is `@Public()`
  `@Post('signup')`.
- **What U2 did:** required a `timezone` on `SignUpDto` rather than defaulting one — the
  treatment U2's Outcome authorises ("supplies a zone or fails loudly"). **This is a fourth
  changed API shape that §4 does not list**, and it 400s any caller that omits the field.
  Nothing in `apps/web`, `apps/mobile` or `qa-automation/e2e` calls it.
- **Blocked:** nothing built. It blocks §4 being an accurate list.
- **Owner:** product team
- **Workaround:** in place. If signup should be refused outright, that is a one-line change.
- **Status:** open

### Q16 — Do the two engine call sites in `payroll.service.ts` resolve the tenant zone in U3, or do they stay a literal?

- **Question:** `payroll.service.ts:231` (`calculatePayPeriod`) and `:329`
  (`attachPricingSlices` → `explainEmployeeJobDays`) pass `BUSINESS_TIMEZONE`, the
  process-wide constant. Does U3 replace those two with
  `TenantContextService.getTimeZone()`, or does some later unit own it?
- **Why it surfaced:** the two documents disagree, and so does the code.
  `units.md` U1 → *Deliberately not in this unit* says: *"Resolving the zone from the acting
  tenant (reading `TenantContext.timeZone` instead of a literal at the two `apps/api` call
  sites) — that is REQ-03, lands in **U3**."* `units.md` U3 → *Deliberately not in this unit*
  says the opposite: *"The engine-call sites inside `payroll.service.ts` — those are U1's,
  already shipped independently of this unit."* U1's own in-code comments name U3 by name
  (*"Reading `TenantCompany.timezone` here is REQ-03 (SCRUM-TZ/U3)"*, *"Same literal, same
  reason as the calculate path above — REQ-03 replaces it"*). REQ-03's **statement** — "rather
  than falling back to the process constant" — covers them; REQ-03's **acceptance** — "every
  call passes a zone explicitly" — does not, because they already do.
- **What U3 did:** left them as `BUSINESS_TIMEZONE`, following the executor's brief and U3's
  own exclusion list rather than U1's. **So today a payroll period's *selection window* is the
  tenant's business week (U3) while the *engine run over those tickets* is still California.**
  For the single Pacific tenant that is one consistent answer; for any second tenant it is two
  definitions of the week inside one calculation — the precise defect class REQ-03 exists to
  end, and it is now half-removed.
- **Blocked:** nothing is blocked from building; U3 shipped without it. What is blocked is
  REQ-03 being *finished*, and any second-tenant onboarding.
- **Owner:** whoever sequences U4–U7 (no product input needed — this is a scoping call
  between two units, not a question about intent)
- **Workaround:** in place while exactly one tenant exists and it is Pacific.
- **Status:** open

### Q17 — Is "every call passes a zone" the right acceptance test, given four business-time functions take no zone?

- **Question:** REQ-03's acceptance says *"each of the 43 sites in the §11a grep passes an
  argument."* Four of the functions in that grep cannot: `calendarDateToUtc`,
  `addBusinessDays`, `weekdayOf` and `formatDateColumn`/`formatCalendarDate` take **no
  `timeZone` parameter at all**, deliberately — they operate on `YYYY-MM-DD` strings and never
  construct a zoned instant. Should the acceptance read "every site whose function accepts a
  zone passes one"?
- **Why it surfaced:** §7 asserts *"No function signature in `business-time.ts` needs to change
  — all 11 already take `timeZone`."* That is inherited from the module's own docblock (*"All
  functions take an explicit `timeZone` defaulting to `BUSINESS_TIMEZONE`"*), and both are
  wrong. Verified 2026-09-09 by reading `packages/shared/src/utils/business-time.ts`: eight
  exports take a zone, four do not. The consequence is that a reviewer checking REQ-03's
  acceptance literally will read five of U3's owned "call sites" as missed — `me.service.ts`'s
  only site, `das-allocations.service.ts`'s only site, and two of `quotations.service.ts`'s
  seven — when nothing was missed and nothing should change there. §11a's per-file counts
  ("(2)", "(7)") are counts of *grep hits*, not of sites needing a zone.
- **What U3 did:** threaded a zone at every site whose function accepts one, and left an
  in-code note at the zone-free sites so the absence reads as deliberate rather than skipped.
  `tenant-business-day.spec.ts` asserts the `jobDate` calendar-date filter is *identical* for
  two tenants in different zones, for the same reason.
- **Blocked:** nothing built. It blocks REQ-03 being signed off against a checkable statement,
  and it makes §7 and the shared module's docblock wrong for the next reader.
- **Owner:** whoever signs off REQ-03 (a documentation correction, not a product answer)
- **Workaround:** n/a.
- **Status:** open

### Q18 — Should a request whose JWT names a tenant that no longer exists now fail?

- **Question:** `TenantContextInterceptor` must read `TenantCompany` to resolve the zone, and
  `TenantCompaniesService.findById` throws `NotFoundException` when the row is absent. Every
  authenticated request therefore now 404s if its tenant row is gone, where previously it
  proceeded with a `tenantCompanyId` on the context and no lookup. Is failing correct, or
  should the request continue and let only the business-day call sites throw?
- **Why it surfaced:** REQ-03 forbids a fallback zone, so there is no third option — the
  interceptor either has the row or the request has no zone. Nothing in the spec says which
  failure is wanted, and the two differ in *where* the error surfaces: an auth-shaped 404 for
  the whole request, versus a 500 from whichever handler first asks what day it is.
- **What U3 did:** took the first (fail at the interceptor). It is the loud option, and the
  state is close to unreachable — `AccessTokenStrategy` already rejects a JWT whose *user* is
  gone, and the user→tenant FK means a live user implies a live tenant. Recorded because it is
  a change to an auth-adjacent failure mode that no test in this repo covers.
- **Blocked:** nothing.
- **Owner:** whoever owns the auth surface
- **Workaround:** n/a — no observed occurrence.
- **Status:** open

### Q19 — Should the ticket-reminder sweep gain a local trigger hour of its own?

- **Question:** Seven of the eight sweeps had a daily trigger hour (01:00–05:15) that U4
  turned into a per-tenant local target. `runTicketReminders` had none — it already ran
  `EVERY_HOUR`. Should it now acquire a stated local hour like the others, so a crew is
  reminded once at (say) 06:00 local, or does it keep firing every hour?
- **Why it surfaced:** the unit's slice-contents row says each body gates on "that sweep's
  original trigger hour", and this sweep's original trigger hour is *every* hour. There is no
  hour to preserve, and REQ-05's acceptance ("each get their sweep once per local day") reads
  as though there should be one. Inventing a number would change how often crews are
  reminded, which is a dispatch decision, not a timezone one.
- **What U4 did:** kept the hourly cadence exactly as it was and gave the sweep the
  per-tenant *day* instead — "tomorrow" is now read on each tenant's own clock rather than
  computed once from the process zone. The `ReminderLog` key for this sweep
  (`ticket_reminder_1d:<allocationId>`) carries no date, so however many hourly runs see a
  row, the crew is reminded exactly once. The behaviour change is confined to *which* day is
  called tomorrow, which is what REQ-05 asks for.
- **Blocked:** nothing — U4 shipped without it.
- **Owner:** dispatch / product
- **Workaround:** n/a — current behaviour is unchanged in cadence.
- **Status:** open

### Q20 — Two cron jobs share advisory-lock key 4815162349. Should one change?

- **Question:** `price-listing-price-hike-expiry`
  (`price-listing-adjustment-expiry.service.ts`) and `ticket-reminders`
  (`notification-scheduled-jobs.service.ts`) both call
  `pg_try_advisory_xact_lock(4815162349)`. Two unrelated sweeps therefore exclude each other.
  Should one of them be given a distinct key?
- **Why it surfaced:** found while moving all eight sweeps to hourly schedules. It has never
  bitten because the two ran at different times (05:15 daily versus hourly on the hour), and
  U4 preserved that separation deliberately — the price-hike sweep fires on `15 * * * *`
  rather than `EVERY_HOUR`, which keeps it off `ticket-reminders`' minute. Had both moved to
  the hour, one would have been spuriously logged `SKIPPED` every hour with nothing
  indicating why.
- **What U4 did:** nothing. Changing a lock key is not traceable to any row of U4's
  slice-contents table or to REQ-05, and the collision stays as latent as it was. Recorded
  rather than fixed.
- **Blocked:** nothing.
- **Owner:** whoever owns the cron surface
- **Workaround:** the `15 * * * *` schedule keeps the two off the same minute, as the daily
  schedules did.
- **Status:** open

### Q21 — `TICKET_REMINDER_TIMEZONE` is now unconsumed. Retire it?

- **Question:** the env var `TICKET_REMINDER_TIMEZONE` (`notifications.ticketReminderTimezone`,
  defaulted to `America/Los_Angeles` in both `notifications.config.ts` and
  `env.validation.ts`) was read at exactly one call site: the attachment-expiry sweep, where
  it decided the calendar day for every tenant at once. U4 replaced it with each tenant's own
  `TenantCompany.timezone`. Should the variable and its config entry now be deleted?
- **Why it surfaced:** the variable is misnamed for what it did — it drove the *attachment*
  sweep, not the ticket one — and it is a second process-wide zone of the same class as
  `FLEET_TIMEZONE` (REQ-10 / U7), which this ticket is retiring. It is now dead config.
- **What U4 did:** stopped reading it, and left the variable and both config entries in
  place. Deleting an env var is a deployment change, and no source in this ticket asked for
  one; REQ-10's scope names `FLEET_TIMEZONE`, not this.
- **Blocked:** nothing.
- **Owner:** whoever owns deployment configuration
- **Workaround:** harmless as dead config — nothing reads it.
- **Status:** open

### Q22 — Which zone does a quotation PDF carry when it is rendered with no acting tenant?

- **Question:** Two `@Public()` routes generate a quotation PDF outside any authenticated
  request, so `TenantContextInterceptor` never runs and there is no acting tenant whose
  `timezone` the document could be rendered in. Q7 answered "the tenant's business zone,
  always labelled" for a document *with* a tenant. What does a document with none carry —
  the quotation's own tenant's zone, a stated default, or should these routes stop being
  public?
- **Why it cannot be answered from what is written:** Q7 settled the display rule for a
  session. Neither Q7 nor REQ-06 addresses a render path with no session, and U5's slice
  row says "reusing U3's mechanism **where the PDF-generation path runs inside a request**"
  — which names the condition without saying what happens when it does not hold.
- **Why it is not academic:** one of the two routes is customer-facing.
  `GET /quotation-signatures/:quoteNo/signed-document`
  (`presentation/quotation-signatures/quotation-signatures.controller.ts:261`) is public
  *"so the link can be opened directly from a browser tab"* — it is how a customer opens
  their own signed quotation. That document now states a zone, and for any tenant not in
  `BUSINESS_TIMEZONE` it states the wrong one. The other,
  `GET /quotations/:quoteNo/pdf` (`presentation/quotations/quotation-pdf.controller.ts:18`),
  is labelled "local testing" but is registered unconditionally in `quotations.module.ts`
  and is live and unauthenticated in every environment.
- **Why the obvious fix was not taken:** the quotation row carries `tenantCompanyId`, so
  the zone *could* be read from it. But on these routes the quotation is fetched by a
  path parameter, which makes that tenant id transitively attacker-supplied — exactly what
  `TenantContextInterceptor`'s docblock forbids (*"Any future zone resolution must come
  from here (or from `TenantContextService`), never from a path param, query string or body
  field"*), and `TenantCompany` is not in the Prisma extension's `tenantModels` allowlist,
  so nothing structurally prevents the cross-tenant read. Resolving this properly is a
  tenancy decision, not a formatting one.
- **Blocked:** nothing in `units.md`. U5 shipped both routes on the interim below.
- **Candidates:** none: nothing written. `spec.md` §7 states only that `BUSINESS_TIMEZONE`
  changes role from "the answer" to "the fallback".
- **Owner:** product team, with whoever owns tenancy on the public-route question
- **Interim shipped in U5:** `TenantContextService.get()?.timeZone ?? BUSINESS_TIMEZONE` at
  both call sites, with the resulting zone **named on the document**. That is deliberately
  the visible option rather than the quiet one: a reader of a mis-zoned PDF can now see
  that it says `(PDT)` and say it is wrong, which an unlabelled date did not allow.
- **Status:** open

### Q23 — Does REQ-07 reach the mobile big clock and the work-segment lines, or only the record strings?

- **Question:** U6 renders every string produced by `formatClockTimeWithZone` in the tenant's
  zone, labelled. Three other mobile renders of a field time were left device-local and
  unlabelled because no slice row names them. Are they in REQ-07 or out?
  1. The **big clock** itself — `BoomBigClock` and `TimeRecordBody` render `displayAt`
     through `formatTimeParts` (`steps/time-clock.tsx`), device-local, no label. This is the
     number the operator taps `+`/`−` on and the number they read as "the time I started".
  2. **`steps/EndWorkBody.tsx`** — the work-segment lines (`:110`, `:111`) and boom-session
     lines (`:150`, `:151`, `:312`) render `start → end` through `formatClockTime`,
     device-local, no label. These are summaries of persisted times.
  3. `resume-step.ts` and `StartWorkBody.tsx` — restored to the labelled form by U6, see below.
- **Why it cannot be answered from what is written:** REQ-07 says "mobile renders field times
  in the tenant's business zone, labelled", and its **Ripple** narrows that to "the step
  summaries, the resume-step line, and the validation messages". U6's slice table narrows it
  again, to `formatClockTimeWithZone` and its call sites. A live, adjustable clock is neither
  clearly a "field time that becomes a record" nor clearly excluded, and nothing addresses it.
- **Why it is new, and why it is not academic:** U6's slice table was written against this
  branch before `origin/main` was merged into it (86 commits, 60 conflicts). The merge
  rewrote the field-ticket step files, and the call-site map in the slice table no longer
  described the tree: it named four `formatClockTimeWithZone` call sites and only two
  survived. The merge resolved `resume-step.ts` and `StartWorkBody.tsx` to `main`'s side,
  which **silently dropped the zone label** commit `45934840` had added there — U6 restored
  both. The same merge introduced the `EndWorkBody` segment lines, which never had a label
  and which no requirement has looked at.
  The question bites because U6 **creates a disagreement that did not exist before it**. For
  a tenant in a zone the device is not in, the crew now see the big clock read `7:00 AM`
  while the step summary two taps later reads `5:00 PM Asia/Karachi` — for the same instant.
  Before U6 both were device-local and agreed; after it they agree only for a device already
  on the tenant's zone. Whichever way this is answered, one of the two renders is wrong
  today, and the wrong one is being read by a crew member recording paid time.
- **Blocked:** nothing already in `units.md` — U6 shipped what its slice table names. Any
  follow-up unit that touches the mobile big clock is blocked on this.
- **Candidates:** none: nothing written. Q7 settled *which zone*, never *which renders*. The
  `admin/gaps.md` → *Time display* gap is about 12h/24h format, not zone or scope.
- **Owner:** product team — the same voice that answered Q7, since this is the boundary of
  that answer rather than a separate rule.
- **Workaround, and what U6 actually shipped:** the record strings are zoned and labelled;
  the live clock and the `EndWorkBody` segment lines are untouched and remain device-local.
  That is the smaller change and the reversible one, but it is explicitly *not* a claim that
  the split is right — it is the split the slice table authorised, reported rather than
  decided.
- **Status:** open


## 13. What this spec deliberately does not specify

Rewritten 2026-09-09. Most of what was here was unspecified because nobody had answered it;
those answers now exist and moved into §2. What remains is genuinely, deliberately out.

**Still not specified, and that is correct:**

- **Which web call sites render a business-relevant time.** The *rule* is settled (tenant
  zone, labelled); the *set* is not enumerated. Every `toLocale*` in web renders in the
  browser's zone today and nobody has listed them. This is U5's first task, not a question
  for anyone to answer — see §5.
- **What a traveling user sees** — §12 Q7 residual. Raised by Syed Haris, who said he needs
  to check it. The two helpers it would use already exist and are wired to nothing.
- **What happens to an open payroll period when a tenant's zone changes** — §12 Q10. This
  was previously buried in §11 as "part of Q5", which was wrong: Q5 only ever covered the
  *initial* value. Blocks the edit path, not the column.
- **Re-pricing of historical payroll under a changed zone** — out of scope per the intent,
  and distinct from Q10, which is about periods still open.
- **Whether the fleet day, the job day and the payroll day must share one boundary.** REQ-10
  makes the fleet and payroll days the same value *by construction*, but nobody adjudicated
  the policy — and nothing says the **job** day is derived through `business-time.ts` at all
  (`jobDate` is a `@db.Date` calendar date, which that module classifies as having no
  timezone). `.ai/vault/assets/gaps.md` → *The fleet day* stays open on exactly that.
- **The four reference-data sets a new tenant needs** — `.ai/vault/admin/gaps.md` → *what a
  newly created tenant must contain* remains open. Timezone is now a fifth required item;
  the original four are untouched by this ticket.
- **12-hour vs 24-hour time format** — `.ai/vault/admin/gaps.md` → *Time display* is about
  **format**, which none of this settles. Answering "which zone" does not answer "which
  clock", and it would be easy to read this spec as having closed it. It has not.

**Resolved since first written, and therefore no longer in this list:** a default timezone
value (Q5), which zone the end user sees (Q7), the cron scheduling shape (Q4), the workday
start time (Q8), whether a tenant may span timezones (Q3, resolved by constraint rather than
analysis — the grain must be revisited before any multi-zone tenant is onboarded).

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered — **done 2026-09-09**, all 10 are `[UNVERIFIED]`
- [ ] **Q10 and Q11 closed** — neither blocks a unit from starting; both block U2/U5 from merging
- [ ] Corrina Bustos ratifies the midnight decision (REQ-09) — a developer confirmed a CA
      labor-law boundary; until she does, it stays `status: reference`
- [ ] Every `[CONFLICT]` requirement has a decision note — **n/a, no conflicts**
- [ ] Answers written back into `spec.md` with their new sources and flags
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [ ] Every §11a ripple row has a source for what happens to that consumer, or a §12 question
- [ ] `tcg-prisma-guardian` has passed on the migration (mandatory — schema moves)
- [ ] Decomposed into vertical units — `units.md`

Answered by: ______________  Date: ______________

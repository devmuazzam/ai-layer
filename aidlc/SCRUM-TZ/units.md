# Units — SCRUM-TZ Lock the business timezone per tenant

> Written to `.ai/aidlc/SCRUM-TZ/units.md` from the approved `.ai/aidlc/SCRUM-TZ/spec.md`
> beside it, per `.ai/aidlc/templates/units.md`. Consumed by `tcg-executor`, one unit at a
> time.

## Headline finding

**Superseded 2026-09-09 — kept, because what it said was true when written and the change
is the point.**

> *As first sliced:* of 9 requirements, only **REQ-04** slices into a unit buildable today.
> Every other requirement is either `[OPEN]` outright, or resting on a migration this
> decomposer will not shape without an answer to Q5.

All 9 of those §12 questions were answered the same day, and REQ-10 was added after. **The
current position: 10 requirements, 7 units, none blocked on a product question.** U1 is
built; U2 is next; U7 additionally waits on reconciling this branch with `main`'s 83-commit
lead.

Two things survive from the original finding and are still live:

- **A requirement can be un-open and still unbuildable.** REQ-03 sequences behind REQ-01's
  migration no matter what §12 says. See *Anything wrong or unsliceable*.
- **Two new questions replaced the old ones**, raised 2026-09-09 after the sweep that
  produced this correction: **Q10** (what happens to an open payroll period when a tenant's
  zone changes — wrongly deferred to Q5, which only ever covered the initial value) and
  **Q11** (the tenant-creation sites `qa-automation` and a hand-mirrored web type hide from
  the compiler). Neither blocks U2 from starting; both must be closed before it merges.

---

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | Payroll engine stops importing Pacific; a test proves two zones give two different pay-week assignments | REQ-04 | shared (`packages/payroll-engine`), api (2 call sites) | — | S | **built 2026-09-09** — 37/37 engine, API build clean, API tests 678/2 identical to baseline. Uncommitted on `fix/timezone-business-day` |
| U2 | `TenantCompany` carries an IANA zone column, backfilled, and every one of the 7 tenant-creation paths (4 compiler-caught, 1 fcc-seeder build-caught, 2 `qa-automation`, uncaught) supplies a value | REQ-01, REQ-02, REQ-08 | schema, api (7 creation sites + 1 web form) | — | M — resized from S: Q5's no-default answer means the migration alone is not shippable; the 7 creation-site updates plus the web admin create-tenant form (see Slice contents/Ripple) are real, if mechanical, surface | **unblocked 2026-09-09** — Q5 answered: backfill Pacific, NOT NULL, no default. Q11 (raised same day) enumerated the 7 creation sites now folded into this unit's scope |
| U3 | apps/api business-day decisions (the non-cron, non-PDF ones) resolve the acting tenant's zone instead of the process default | REQ-03 (partial — see notes) | api | U2 | M | **unblocked 2026-09-09** — needs U2 first |
| U4 | The 8 cron sweeps stop computing one day for every tenant | REQ-05, REQ-03 (the 4 cron files' rows) | api | U2 | M | **unblocked 2026-09-09** — Q4 answered: each tenant's local window (hourly-select) |
| U5 | Web shows a labelled time in a chosen zone instead of a silent Pacific guess | REQ-06, REQ-03 (`quotation-pdf.service.ts` rows) | web, api, shared | U2 | M | **unblocked 2026-09-09** — Q6 + Q7 answered |
| U6 | Mobile's field-time labelling is a stated per-tenant answer instead of a deliberate device-zone default | REQ-07 | mobile | U2 | S | **unblocked 2026-09-09** — Q7 answered; traveler sub-question still open |
| U7 | Samsara fleet-tracking days converge onto `TenantCompany.timezone`; the two env-var-driven implementations (`apps/api` dayjs, `apps/web` build-time constant) are deleted | REQ-10 | api, web, shared | U3, U5 | M | **not started — additionally gated on reconciling `fix/timezone-business-day` with `main`'s 83-commit lead (see Sequencing); Q9 answered 2026-09-09** |

- **Requirements not covered by any unit:** REQ-09 — **resolved 2026-09-09, and confirmed
  out of scope.** Q8 answered "00:00 local", which is what `business-time.ts` already
  implements, so the spec's own condition ("out of scope for this ticket if the answer is
  midnight") is met. The decision ratifies existing behaviour and closes a hole the vault
  named in `payroll/payroll-rule-dependency-matrix.md` row 14; it produces no code change
  here. Correctly never sliced.
- **Units blocked on an open question: none.** All six §12 questions were answered
  2026-09-09. U1 is built; U2 is the next to ship and everything else sequences behind its
  migration.

### What each answer changed, 2026-09-09

| Q | Answer | Effect on units |
| --- | --- | --- |
| Q2 | Any valid IANA zone, runtime `Intl` probe | U2's validation is now specified |
| Q4 | Each tenant's **local** quiet window | U4 unblocked, and its **shape is now determined**: `@Cron`'s `timeZone` is fixed at class-definition time, so this must be *run hourly, select tenants whose local time just crossed the trigger*. Not the cheaper global-run option. |
| Q5 | Backfill `America/Los_Angeles`; **NOT NULL, no default** | U2 unblocked. Adds a required-field change to `CreateAdminTenantDto`, or tenant creation breaks — that belongs in U2, not a later unit. |
| Q6 | SUPER_ADMIN only; zone delivered on **`/me`, not the JWT** | U5 unblocked. The JWT is explicitly rejected: a stale token would keep pricing in the old zone until expiry. |
| Q7 | Tenant business zone, **always labelled** | U5 and U6 unblocked. **Residual still open:** what a traveling user sees. `zone-label.ts` already exports `isDeviceOnBusinessZone()` and `hoursFromBusinessZone()` for this, wired to no UI. |
| Q8 | 00:00 local | REQ-09 out of scope; no unit needed |
| Q9 | **Retired.** The fleet day reads `TenantCompany.timezone`; `fleet-day.ts` / `fleet-date.ts` converge onto `business-time.ts`, dropping `dayjs` from both surfaces | New requirement (REQ-10) and new unit (U7). Gated on U3 (tenant zone reachable from a request) and U5 (web's `/me` carrier), and additionally on reconciling this branch with `main`'s 83-commit lead — see U7 and *Sequencing*. Nothing in U1–U6 is affected; their files are disjoint from the vehicle-tracking surface. |

---

## U1 — Payroll engine takes the zone as a required input

- **Outcome:** A developer can run the payroll-engine test suite and see that the same job
  days, calculated in two different timezones across the fixture boundary
  (`2026-06-06T06:00:00Z` = Friday 23:00 in `America/Los_Angeles` but Saturday 02:00 in
  `America/New_York`), now produce two different week/day-type assignments — proving the
  engine no longer has an opinion about where the work happened. Every existing Pacific-only
  call continues to produce byte-identical output, proving the wiring is safe today.
- **Kind:** vertical. It is not a layer split: it changes the engine's public input type,
  both of its real callers, and the tests for all of it, in one slice — there is no
  "backend half" left for a later unit to finish. It is also not a foundation unit: it does
  real behavioural work, it is not merely shared types staged for others to consume.
- **Requirements covered:** REQ-04, fully.
- **Depends on:** —

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | no schema involvement |
| API (`apps/api`) | `apps/api/src/usecase/payroll/payroll.service.ts:225` (`calculatePayPeriod`) and `apps/api/src/usecase/payroll/payroll-explain.ts:52` (`explainEmployeeJobDays`, reached via `attachPricingSlices` at `payroll.service.ts:319`) both start passing `timeZone` explicitly at the call site, imported as `BUSINESS_TIMEZONE` from `@tcg/shared` — a literal for now, not a tenant lookup. That lookup is REQ-03/U3's job. |
| Web (`apps/web`) | N/A | not touched — see *Anything wrong or unsliceable*, `payroll-week.test.mjs` note below |
| Mobile (`apps/mobile`) | N/A | not touched |
| Shared (`packages/payroll-engine`) | `types.ts:93` — `CalculatePayPeriodInput` gains a **required** `timeZone: string` field (and the analogous input type(s) in `explain.ts`, whatever they are named — the executor confirms by reading the file, since the spec does not enumerate them). `slices.ts:1,13` — `toPacific(date)` stops importing `BUSINESS_TIMEZONE`; the zone flows in from the caller. `explain.ts:12,37,70` — same, at its three `toPacific` call sites. `index.ts:12` — the exported `toPacific` is re-signed to require a zone (or dropped from the barrel if nothing outside the engine needs it — see Ripple). | `grep -rn 'BUSINESS_TIMEZONE' packages/payroll-engine/src` must return nothing on completion (REQ-04 acceptance). |
| Tests | `packages/payroll-engine` test suite (currently 34/34, `node --experimental-strip-types --test src/*.spec.ts`) extended with a test asserting two different `timeZone` inputs produce two different week/day-type assignments across the fixture instant above; the existing 34 tests re-run and must still pass unchanged (they exercise Pacific-only behaviour, which is unchanged by this unit). | Run via `pnpm nx run @tcg/payroll-engine:test`. |

### Reviewable as

- **Demo:** `pnpm nx run @tcg/payroll-engine:test` — the new two-zone test passes; `grep -rn 'BUSINESS_TIMEZONE' packages/payroll-engine/src` returns nothing; `pnpm nx run @tcg/api:build` compiles clean with both call sites passing the zone explicitly (a missed call site is a compile error, by design).
- **Acceptance:** REQ-04's acceptance lines in `spec.md` §2 — the grep, and the two-zone test.
- **Reviewer can verify without:** without any schema change, without a real tenant, without `TenantContext`, without U2–U6. The zone at the two `apps/api` call sites is still a literal (`BUSINESS_TIMEZONE`) — this unit proves the plumbing, not the per-tenant value.

### Risk

- **Weakest source:** `[UNVERIFIED]` — every REQ-04 source is code (`slices.ts`, `types.ts`, `explain.ts`, the `business-time.ts` docblock). No source is `[OPEN]`, so this is the routine case, not the flagged combination.
- **Migration reversible:** N/A — no migration in this unit.
- **Behind a flag:** no — a required-field type change cannot be partially rolled out; it is enforced by the compiler at both call sites simultaneously.
- **Touches existing data:** no.
- **Blast radius:** if a call site were missed, `apps/api` fails to build — the required-field design makes the failure mode "the build breaks," not "a tenant silently gets the wrong week." Required gates: standard build/lint/typecheck + the engine's own test target. `tcg-prisma-guardian` — not required, no schema touched. `tcg-contract-tracer` — not required: `packages/payroll-engine` is **not** a workspace dependency of `apps/web` or `apps/mobile` (`grep -rn 'payroll-engine' apps/web/package.json apps/mobile/package.json` — no hits); `CalculatePayPeriodInput` is not part of `@tcg/shared` and is not an API response DTO, so no response shape moves across a compiled boundary.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `apps/api/src/usecase/payroll/payroll.service.ts:225` `calculatePayPeriod` | direct call into `@tcg/payroll-engine` | the existing 34 engine tests pass unchanged, and `payroll.service.spec.ts`'s existing *PayrollService.calculate — period window* block exercises this call path end-to-end as part of the unchanged 678-passing API baseline. **Corrected 2026-09-09 (`tcg-analyst`):** an earlier draft of this row claimed a *new* `apps/api` assertion was added for this call site. None was, and REQ-04's acceptance never asked for one — the claim was wrong, not the build | `spec.md` REQ-04, §11a row "`usecase/payroll/payroll.service.ts` (7 sites) … REQ-03, REQ-04 … changes deliberately … `PAY-001`" |
| `apps/api/src/usecase/payroll/payroll-explain.ts:52` `explainEmployeeJobDays` (via `attachPricingSlices`, `payroll.service.ts:319`) | direct call into `@tcg/payroll-engine` | same mechanism as above, exercised through the explain path's own fixtures | `spec.md` REQ-04 |
| `packages/payroll-engine/src/index.ts:12` exported `toPacific` | shared export | `grep -rn 'toPacific' packages/*/src apps/*/src` → 6 hits, **all inside the engine**, none outside — there is no external consumer to regress; re-signing or dropping this export reaches nothing else | `spec.md` REQ-04, "Enumerated by `grep -rn 'toPacific' packages/*/src apps/*/src`" |
| `apps/web/src/features/payroll/lib/payroll-week.test.mjs:7` — imports `fridayOfWeek`/`saturdayOfWeek` directly from `packages/payroll-engine/src/period.ts` by relative path (not a package dependency; `@tcg/payroll-engine` is not in `apps/web/package.json`) to cross-check web's own week-boundary reimplementation against the engine | direct relative-path import, test-only | **none needed** — verified this unit does not reach it: `grep -n 'toPacific\|BUSINESS_TIMEZONE\|timeZone\|timezone' packages/payroll-engine/src/period.ts` returns nothing; `period.ts` operates only on `YYYY-MM-DD` strings with UTC-midnight arithmetic and has no timezone dependency at all. This unit touches `types.ts`, `slices.ts`, `explain.ts`, `index.ts` — not `period.ts`. | grep above, run for this unit |

### Deliberately not in this unit

- Resolving the zone from the acting tenant (reading `TenantContext.timeZone` instead of a
  literal at the two `apps/api` call sites) — that is REQ-03, lands in U3, which is blocked
  (see ledger). This unit passes `BUSINESS_TIMEZONE` explicitly; it does not yet read a real
  per-tenant value.
- `apps/web` and `apps/mobile` — REQ-04 does not touch either surface; confirmed above that
  the one relative-path test import is unaffected.

---

## U2 — `TenantCompany` carries a timezone column, backfilled

- **Outcome:** Every row in `tenant_companies` — existing and new — has a validated IANA
  zone identifier. A developer can create a tenant through every one of the seven paths
  that construct one (`POST /admin/tenants`, two internal seed scripts, the FCC seeder, and
  both `qa-automation` seeds) and each either supplies a zone or fails loudly at the call
  site — none falls through to a silent Pacific default, because Q5 explicitly rejected a
  default. `grep -n 'DateTime' apps/api/prisma/schema.prisma | grep -v '@db\.'` still
  returns nothing (REQ-02 untouched).
- **Kind:** foundation, schema-plus-callers. Justification unchanged for the migration
  itself: at least three later units depend on this one column against `tenant_companies`
  — U3 (`TenantContext` resolves it), U4 (the cron sweeps read it per tenant), U5 and U6
  (both need the value to reach a surface). Splitting the column add per-unit would mean
  four migrations against the same table. What changed with Q5's answer is the *shape* of
  the foundation: `NOT NULL` with **no default** means the migration is not usable on its
  own — every existing writer of `tenantCompany.create`/`upsert` must supply a value or the
  build (four sites), the FCC seeder (one, via its own `tsc -p fcc-seeder/tsconfig.build.json`
  step inside `@tcg/api:build` — see Risk) or the E2E run (two, uncompiled) breaks. That is
  not scope creep; it is what "no default" costs, and the alternative — a Pacific default —
  is the thing Q5 was explicitly asked to avoid.
- **Requirements covered:** REQ-01 (fully — nullability and default are now settled: NOT
  NULL, no default), REQ-02 (as an acceptance constraint this migration must not violate),
  REQ-08 (the backfill: every existing row set to `America/Los_Angeles`, settled by Q5).
- **Depends on:** —

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `TenantCompany.timezone String @map("timezone") @db.VarChar(64)`, **`NOT NULL`, no default** (`spec.md` §3, Q5). The migration backfills every existing row to `America/Los_Angeles` in the same migration that adds the `NOT NULL` constraint — a two-step `ADD COLUMN` (nullable) → `UPDATE` → `ALTER COLUMN SET NOT NULL`, since Postgres cannot add a `NOT NULL` column with no default to a populated table in one step. | Migration name: something naming both halves, e.g. `add_tenant_company_timezone` — the backfill is not a separate migration; it is this one. |
| API (`apps/api`) | `CreateAdminTenantDto` (`apps/api/src/presentation/admin/dto/create-admin-tenant.dto.ts`) gains a **required** `timezone: string` field, validated with the runtime `Intl.DateTimeFormat(undefined, { timeZone: v })` probe from `spec.md` §9 (Q2: any valid IANA zone, no restricted list). `AdminTenantsService.create()` (`admin-tenants.service.ts:87`) and `TenantCompaniesRepository.create()` (`tenant-companies.repository.ts:22`) pass the value through — both already take a `data` object, so this is a field addition, not a signature redesign. `apps/api/src/utility/seed-data.ts:800` (`prisma.tenantCompany.upsert`, the default dev-seed tenant) and `:1042` (`prisma.tenantCompany.create`, the platform SUPER_ADMIN tenant) both gain an explicit `timezone: 'America/Los_Angeles'` literal — compiler-caught, so a miss here is a build failure, not a runtime one. `apps/api/fcc-seeder/src/seed-all.ts:102` (`prisma.tenantCompany.upsert`) gains the same literal — **this site is compiler-caught too**: `apps/api/package.json`'s `build` script runs `tsc -p fcc-seeder/tsconfig.build.json` as part of `@tcg/api:build`, so a missed field here fails the build the same as the two `src/` sites, not silently at runtime (Q11's flagged uncertainty — "check the tsconfig" — resolves to **caught**, verified 2026-09-09 by reading `apps/api/package.json:8`). | `UpdateAdminTenantDto` is **not** touched here — the edit path (`PATCH /admin/tenants/:id` accepting a `timezone` change) is Q10's territory and lands in U5, not this unit. This unit only ever writes the zone once, at creation. |
| Web (`apps/web`) | `apps/web/src/features/admin/types/index.ts` (`CreateTenantPayload`) and `apps/web/src/features/admin/components/admin-create-tenant-modal.tsx` gain a `timezone` field/input. **Not one of the seven `tenantCompany.create`/`upsert` grep hits** — it is an HTTP caller of `POST /admin/tenants`, not a Prisma call — but it is a genuine existing consumer of the endpoint this unit makes stricter: `CreateTenantPayload` is a hand-duplicated type (`grep -rn 'CreateAdminTenantDto' apps/web/src` → no hits; it is not carried through `@tcg/shared`), so nothing compile-checks it against the API DTO. Without this change, every tenant created from the admin UI gets a 400 the moment this unit merges. Named here rather than left as *Deliberately not in this unit*, per the ripple rule that an existing consumer this unit breaks is not deferred scope. | Small: one form field, one payload type. Does not change this unit's `Kind` — it is the same "keep the NOT NULL column from breaking an existing caller" work as the seven Prisma sites, just reached over HTTP instead of compiled Prisma types. |
| Mobile (`apps/mobile`) | N/A — no tenant-creation path on mobile. | |
| Shared (`packages/shared`) | N/A | |
| Tests | `apps/api/src/usecase/admin/admin-tenants.service.spec.ts:35` (the `service.create({ name, tenantCode })` call) and `:43–44` (the `toHaveBeenCalledWith` assertion on the `data` object passed to `prisma.tenantCompany.create`) both need a `timezone` value added — confirmed by reading the file: neither currently includes it, and both will fail once `create()`'s input type requires it. A migration test that `grep -n 'DateTime' apps/api/prisma/schema.prisma \| grep -v '@db\.'` still returns nothing (REQ-02). A round-trip test that the column holds a valid IANA string. `qa-automation/e2e/support/seed/tenant.ts:62` and `qa-automation/e2e/support/seed/disposable-user.ts:112` both gain an explicit `timezone` field in their `prisma.tenantCompany.create` call — **not compiler-caught** (`qa-automation/` is outside the pnpm workspace, per `CLAUDE.md`), so this is verified by actually running the E2E suite once, not by `pnpm build`. | The `admin-tenants.service.spec.ts` update and the two `qa-automation` seed updates are both required for this unit to be complete — the first because the existing test would otherwise fail against the new required field, the second because nothing else will ever say so (Q11). |

### Reviewable as

- **Demo:** `POST /admin/tenants` without a `timezone` field is rejected by validation;
  with a valid IANA zone it succeeds; with `"not/a/zone"` it is rejected by the `Intl`
  probe. `SELECT DISTINCT timezone FROM tenant_companies` after the migration shows every
  existing row as `America/Los_Angeles`. The admin "create tenant" screen has a zone field
  and creating a tenant through it succeeds. `qa-automation`'s `seedBaseTenant` and
  `createDisposableTenant` still work when run once locally.
- **Acceptance:** REQ-01's and REQ-08's acceptance lines in `spec.md` §2, both now stateable:
  the column exists, is `NOT NULL` with no default, every existing row is backfilled to
  `America/Los_Angeles`, `tcg-prisma-guardian` has passed, and all seven creation sites
  compile or (for the two `qa-automation` sites) run successfully.
- **Reviewer can verify without:** without U3–U6 — nothing yet *reads* the column for a
  business-day decision; this unit only establishes that it exists and is always populated.

### Risk

- **Weakest source:** `[UNVERIFIED]` — REQ-01, REQ-02 and REQ-08 all carry this tag, not
  `[OPEN]`; Q5 resolved the open question this unit was blocked on. Worth being honest about
  what `[UNVERIFIED]` means here rather than treating the flag as satisfied: every source is
  a `status: reference` decision note from a developer/owner (Syed Haris), not a `verified`
  adjudication — `assets/gaps.md`'s named product owners, Brian Petros and Corrina Bustos on
  payroll, have seen none of it. The decision is binding on implementation and open to being
  overruled by TCG; it is not the same weight as a client sign-off.
- **Migration reversible:** **one-way**, not contingent any more — Q5 chose "required, no
  default." Once this merges, every real tenant row carries a value someone will soon set
  deliberately (via `PATCH /admin/tenants/:id` once U5 opens that path), and `DROP COLUMN`
  at that point loses real data. This is the `[UNVERIFIED]` + expensive-to-undo combination
  the decomposer's brief calls out: routine `[UNVERIFIED]` alone would not warrant a note,
  but paired with a one-way backfill it does — which is exactly why `tcg-prisma-guardian` is
  mandatory below, not a formality.
- **Behind a flag:** no — schema changes are not flaggable.
- **Touches existing data:** yes — every row in `tenant_companies` is backfilled in this
  migration (REQ-08).
- **Blast radius:** every downstream business-day decision (U3, U4, U5, U6) reads this
  column once it exists, and every tenant-creation path (seven sites, enumerated above) must
  keep supplying it forever after. Required gate: **`tcg-prisma-guardian` must pass before
  this migration merges** — non-negotiable per `CLAUDE.md` and `contexts/prisma.md`, and
  doubly so here because §8 of the spec notes the tenant-scoping client extension does not
  protect a read of the tenant root itself, and because this migration is the one-way step
  above.
- **`tcg-contract-tracer`:** **not required.** `CreateAdminTenantDto` is a request DTO, not
  a response shape, and it is not carried through `@tcg/shared` — web's `CreateTenantPayload`
  is a hand-duplicated type with no compiled link to the API's DTO (confirmed by grep, see
  Slice contents). The tracer's charter is response shapes/DTOs that cross the
  only-`@tcg/shared`-is-compile-checked boundary; a required-field addition to a request DTO
  on an admin-only, `SUPER_ADMIN`-gated endpoint fails loudly (400) rather than silently,
  which is the different failure mode the tracer exists to catch. The web-side ripple is
  real (see Slice contents, Web row) but it is a known, named, loud failure — not the silent
  kind — so it is handled directly in this unit's slice contents instead of by the tracer.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| every row in `tenant_companies` | direct column addition + backfill | migration test: every row reads `America/Los_Angeles` post-migration | `spec.md` REQ-08, Q5 answer |
| `apps/api/src/service/tenant-companies/tenant-companies.repository.ts:22` `create()` | `prisma.tenantCompany.create` | compiler-caught (required field on the `Prisma.TenantCompanyCreateInput` the method already takes) | Q11 enumeration, `spec.md` §12 |
| `apps/api/src/usecase/admin/admin-tenants.service.ts:87` `create()` | `prisma.tenantCompany.create` | compiler-caught + updated `admin-tenants.service.spec.ts:35,43–44` | Q11 enumeration |
| `apps/api/src/utility/seed-data.ts:800` (dev-seed tenant), `:1042` (platform tenant) | `upsert` / `create` | compiler-caught | Q11 enumeration |
| `apps/api/fcc-seeder/src/seed-all.ts:102` | `prisma.tenantCompany.upsert` | compiler-caught via `tsc -p fcc-seeder/tsconfig.build.json` inside `@tcg/api:build` — verified 2026-09-09 by reading `apps/api/package.json:8` | Q11 enumeration, resolving the "check the tsconfig" flag |
| `qa-automation/e2e/support/seed/tenant.ts:62` `seedBaseTenant` | `prisma.tenantCompany.create` | **not compiler-caught** — `qa-automation/` is outside the pnpm workspace (`CLAUDE.md`); verified only by running the E2E suite once after this unit lands | Q11 enumeration |
| `qa-automation/e2e/support/seed/disposable-user.ts:112` `createDisposableTenant` | `prisma.tenantCompany.create` | same — not compiler-caught, verified by running the suite | Q11 enumeration |
| `apps/web/src/features/admin/types/index.ts` `CreateTenantPayload`, `apps/web/src/features/admin/components/admin-create-tenant-modal.tsx` | HTTP call to `POST /admin/tenants` | manual: creating a tenant through the admin UI succeeds post-merge | found while tracing Q11's enumeration outward from Prisma calls to the endpoint's own callers |

### Deliberately not in this unit

- Whether the accepted zone value is free-form IANA or a restricted set (Q2) — already
  answered (any valid IANA zone, runtime `Intl` probe) and is this unit's validation rule,
  not a deferral.
- Who may **change** a tenant's zone after creation, and what happens to an open payroll
  period when they do (Q6, Q10) — Q6 is answered (SUPER_ADMIN only, via `/me` not the JWT)
  but the **edit path** (`PATCH /admin/tenants/:id` accepting `timezone`) is U5's unit, not
  this one, because Q10 — what happens to an open payroll period under a zone change — is
  still open and blocks specifically the edit path, not tenant creation. This unit only
  ever writes the zone once, at creation, where Q10 does not apply.

---

## U3 — `apps/api` business-day decisions resolve the tenant's zone

- **Outcome:** A developer can seed two synthetic tenants in different IANA zones, hit any
  of the ~29 non-cron, non-PDF call sites this unit owns with the same instant, and see two
  different business-day answers — proving the API no longer decides one day for every
  tenant. Every existing Pacific-only caller (today's only real tenant, per the single-zone
  constraint) gets the same answer it gets today, because the resolved value for a Pacific
  tenant is unchanged.
- **Kind:** vertical (api-only, but not a layer split — it is the complete, testable
  realization of REQ-03 for the call sites it owns, terminating in a passing multi-zone
  test rather than a UI, in the same spirit as U1).
- **Requirements covered:** REQ-03, **partially** — all business-day call sites **except**:
  the 4 files whose rows in `spec.md` §11a were tagged `OPEN — Q4` (`notification-scheduled-jobs.service.ts`,
  `price-listing-adjustment-expiry.service.ts`, `quotation-expiry.service.ts`,
  `permit-expiry.service.ts` — Q4 is answered, but these still move to U4, since cron bodies
  run outside `TenantContext` and need U4's hourly-select mechanism, not this unit's), and
  `usecase/docusign/quotation-pdf.service.ts`'s 2 sites, whose row was tagged `OPEN — Q7`
  even though it also carries REQ-03 (a PDF has no viewer zone to resolve against — see
  *Deliberately not in this unit*). That leaves: `quotations.service.ts` (7),
  `payroll.service.ts` (the non-engine sites only — the engine call itself is U1's),
  `project-list.helpers.ts` (3), `date-boundary.util.ts` (2), `me.service.ts` (2),
  `das.service.ts` (2), `das-allocations.service.ts` (2), `tools.service.ts` (2),
  `craft-rate-resolver.service.ts` (2).
- **Depends on:** U2. No open question blocks this unit any more (Q5 is answered), but it
  is still sequenced after U2 as a build dependency: `TenantContext` cannot resolve a column
  that does not exist, and Prisma Client's generated types come from the committed schema —
  this unit cannot compile until U2's migration merges.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | already done by U2 |
| API (`apps/api`) | `apps/api/src/context/tenant-context.ts` — `TenantContext` gains a `timeZone` field, resolved once per request by `TenantContextInterceptor` from `TenantCompany.timezone` (needs U2's column). The ~29 call sites listed above stop relying on the business-time functions' default parameter and pass `TenantContext`'s resolved zone explicitly. **No function signature in `business-time.ts` changes** — all 11 already take `timeZone` (spec §7). | Per REQ-03's executor note: **no Pacific fallback** on the getter — it must fail loudly outside a request, not silently return Pacific. |
| Web (`apps/web`) | N/A | |
| Mobile (`apps/mobile`) | N/A | |
| Shared (`packages/shared`) | N/A — no signature changes needed here | |
| Tests | A test with two tenants seeded in different zones proving the same instant resolves to two different business days across the 43-call-site mechanism, for at least one call site per owned file; existing single-tenant (Pacific) behaviour unchanged, proven against current tests for `quotations.service.ts`, `date-boundary.util.ts`, etc. | |

### Reviewable as

- **Demo:** a request from a non-Pacific synthetic tenant hits one of the owned call sites
  and gets that tenant's business day, not California's; a request from a Pacific tenant
  gets the same answer it gets on `main` today.
- **Acceptance:** REQ-03's acceptance line in `spec.md` §2 (every one of the owned sites
  passes an argument; two-tenant test).
- **Reviewer can verify without:** without U4 (cron), without U5/U6 (display) — this unit
  is the resolution mechanism, not what a person sees.

### Risk

- **Weakest source:** `[UNVERIFIED]` — REQ-03's own sources are the decision note (`status:
  reference`) and code, same weight as every other requirement in this ticket. No `[OPEN]`
  question blocks it any longer; Q5 (the thing that made this unstartable) is answered. The
  only thing this unit still waits on is U2 physically merging, which is a build order, not
  a product unknown.
- **Migration reversible:** N/A — no migration of its own; inherits U2's.
- **Behind a flag:** no.
- **Touches existing data:** no — read-only resolution.
- **Blast radius:** every one of the ~29 owned call sites depends on this getter behaving
  correctly for every authenticated request; a bug here is silent and wide (the exact
  failure mode this ticket exists to remove). `tcg-prisma-guardian` — not required by this
  unit itself (no schema change here), but the guardian's sign-off on U2 is a prerequisite.
  `tcg-contract-tracer` — not required: this unit changes an internal resolution mechanism
  (`TenantContext`, never serialized to a response), not a response shape or a `@tcg/shared`
  export.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `usecase/quotations/quotations.service.ts` (7 sites) | shared export from `business-time.ts` | two-tenant test at ≥1 site; existing quotation tests re-run unchanged for a Pacific-only tenant | `spec.md` §11a row, "changes deliberately" |
| `usecase/payroll/payroll.service.ts` (non-engine sites) | shared export | same mechanism; the engine-call sites are U1's, not this unit's | `spec.md` §11a row, `PAY-001` |
| `usecase/projects/project-list.helpers.ts` (3) | shared export | two-tenant test | `spec.md` §11a row |
| `utility/date-boundary.util.ts` (2) | shared export | two-tenant test | its own docblock, per `spec.md` §11a |
| `usecase/me/me.service.ts` (2) | shared export | two-tenant test | `spec.md` §11a row |
| `usecase/das/das.service.ts` (2) | shared export | two-tenant test | commit `35d84071`, per `spec.md` §11a |
| `usecase/das-allocations/das-allocations.service.ts` (2) | shared export | two-tenant test | `spec.md` §11a row |
| `usecase/asset-management/tools/tools.service.ts` (2) | shared export | two-tenant test | commit `35d84071`, per `spec.md` §11a |
| `service/craft-rate-resolver/craft-rate-resolver.service.ts` (2) | shared export | two-tenant test | commit `cdc34c30`, per `spec.md` §11a |

### Deliberately not in this unit

- The 4 cron-file rows (`notification-scheduled-jobs.service.ts`,
  `price-listing-adjustment-expiry.service.ts`, `quotation-expiry.service.ts`,
  `permit-expiry.service.ts`) — excluded because cron bodies run outside
  `TenantContext`'s `AsyncLocalStorage` and cannot use this unit's mechanism at all, Q4's
  answer notwithstanding. They belong to U4, which owns the hourly-select mechanism Q4's
  answer requires.
- `usecase/docusign/quotation-pdf.service.ts`'s 2 REQ-03-tagged sites — excluded because a
  PDF has no viewer zone to resolve against; that row is display scope (REQ-06/REQ-07), not
  a business-day mechanism problem, and lands in U5 alongside Q7's "tenant zone, always
  labelled" answer, not duplicated into this business-day-only unit.
- The engine-call sites inside `payroll.service.ts` — those are U1's, already shipped
  independently of this unit.

---

## U4 — The 8 cron sweeps stop deciding one day for every tenant

- **Outcome:** Each of the 8 cron sites fires hourly and, within the run, acts only on the
  tenants whose **local** wall-clock has just crossed that sweep's trigger hour — a tenant
  in a non-Pacific zone gets its expiry/reminder emails at its own local quiet-window hour,
  not Pacific's. A test proves two tenants in different zones are picked up by two different
  hourly runs for the same logical trigger, and that `ReminderLog` does not double-send or
  gap a reminder across the change.
- **Kind:** vertical — one shape, applied uniformly to all 8 `@Cron` sites across 4 files,
  because the decorator-argument constraint (`@Cron`'s `timeZone` is fixed at
  class-definition time) applies to all of them identically; there is no smaller shippable
  slice than "the sweep mechanism changes shape."
- **Requirements covered:** REQ-05, fully; and REQ-03's 4 cron-file rows (see U3's
  *Deliberately not in this unit*).
- **Depends on:** U2 — the per-tenant local-time selection needs `TenantCompany.timezone` to
  exist. No open question blocks this unit; Q4 answered "each tenant's local quiet window,"
  which is what forces the shape below.

### Slice contents

Q4's answer forces the shape: `@Cron`'s `timeZone` argument cannot vary per tenant, so a
per-tenant-local trigger cannot be a schedule — it must be **run hourly, then select inside
the body the tenants whose local time has just crossed the trigger hour**. This is not the
cheaper of the two options the spec named (a single global run with no schedule change would
have been cheaper); Q4's answer picked the more expensive one deliberately. Precedent for the
hourly shape already exists in this codebase: `notification-scheduled-jobs.service.ts:211`
(`runTicketReminders`) already runs `@Cron(CronExpression.EVERY_HOUR, ...)` — it is not yet
per-tenant-zone-aware (it still resolves one target day per run, from `BUSINESS_TIMEZONE`),
but it establishes that firing hourly and gating inside the body is an established, working
pattern here, not a novel one this unit invents.

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | inherits U2 |
| API (`apps/api`) | All 8 `@Cron` declarations move to `CronExpression.EVERY_HOUR` (dropping the fixed `timeZone: BUSINESS_TIMEZONE` argument — it no longer means anything once the trigger is per-tenant): `permit-expiry.service.ts:59`, `quotation-expiry.service.ts:54`, `notification-scheduled-jobs.service.ts:91` (`runQuotationReminders`, was `EVERY_DAY_AT_2AM`), `:103` (`runCertExpiryReminders`, was `EVERY_DAY_AT_3AM`), `:155` (`runAttachmentExpiryReminders`, was `EVERY_DAY_AT_4AM`), `:211` (`runTicketReminders`, already `EVERY_HOUR` — gains the per-tenant gate it does not have today), `price-listing-adjustment-expiry.service.ts:48,66`. Each body gains a per-tenant local-hour check before doing its existing work: for the set of distinct timezones actually in use (today: one, `America/Los_Angeles`; the mechanism must not assume that), compute the tenant-local wall-clock hour at the moment the run fires and only process tenants whose local hour matches that sweep's original trigger hour (2am, 3am, etc., preserved as each sweep's own local target — not collapsed to one shared hour). `notification-scheduled-jobs.service.ts:107–130` (the cert-expiry body) additionally needs its `businessToday()`/`calendarDateToUtc(addBusinessDays(...))` call resolved per tenant rather than once per run — it currently computes one target date, then does an untenanted `findMany`, which is the exact defect REQ-05 exists to fix. | This body-level per-tenant gate, not the cron schedule itself, is where REQ-05's actual fix lives — the schedule change alone (daily → hourly) does nothing without it. |
| Web (`apps/web`) | N/A | |
| Mobile (`apps/mobile`) | N/A | |
| Shared (`packages/shared`) | N/A | |
| Tests | Two synthetic tenants in different zones, same sweep: each is picked up in the hourly run matching its own local trigger hour, not the other's. `ReminderLog` idempotency test, named explicitly by Q4's answer note: a reminder already sent under the old single-instant schedule must not be re-sent, and a boundary tenant must not be skipped, when the sweep starts evaluating per-tenant local time instead of one global instant — the spec's own note that a wrong-day computation "permanently suppressed" a reminder is not theoretical, and this is the case that produces it. | |

### Reviewable as

- **Demo:** two synthetic tenants seeded in different zones; the cert-expiry sweep (or any
  one of the 8) is invoked at an hour matching one tenant's local trigger and not the
  other's; only the matching tenant's rows are processed.
- **Acceptance:** REQ-05's call sites all fire hourly and gate on tenant-local time; a
  two-tenant, two-zone test at ≥1 of the 8 sites; a `ReminderLog` idempotency test.
- **Reviewer can verify without:** without U3, U5, U6 — the cron mechanism is independent
  of the request-scoped `TenantContext` resolution U3 builds (crons have no request) and of
  what any surface displays.

### Risk

- **Weakest source:** `[UNVERIFIED]` — REQ-05's source for the *answer* is
  `decisions/2026-09-09-tenant-timezone-configuration.md`, `status: reference`, same weight
  as every other decision note in this ticket. No source is `[OPEN]` any longer.
- **Migration reversible:** N/A — no migration of its own; inherits U2's.
- **Behind a flag:** no — the schedule change is uniform across all 8 sites and cannot be
  partially rolled out; a mixed state (some sites hourly-per-tenant, some still
  daily-global) would itself produce the inconsistency REQ-05 exists to remove.
- **Touches existing data:** yes — `ReminderLog` keys embed the computed date, and changing
  when/how that date is computed can make an already-sent reminder's key collide or gap
  across the cutover. Unlike U2's backfill this is not schema-irreversible (the rows are
  ordinary mutable data, not a dropped column), but it is the kind of change that is cheap
  to write and expensive to get subtly wrong in a way nothing but the idempotency test
  above would catch — hence that test being named explicitly rather than left implicit.
- **Blast radius:** all 8 crons, cross-tenant, silent by construction today (a `findMany`
  with no tenant filter reading `tenantCompanyId` per row) — the widest blast radius in this
  ticket. `tcg-prisma-guardian` — not required (no schema change here). `tcg-contract-tracer`
  — not required (no response shape or `@tcg/shared` export changes; this is internal
  scheduling and query logic).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `notification-scheduled-jobs.service.ts` (8 sites, 4 `@Cron`) | shared export + `@Cron` | two-tenant idempotency test at ≥1 site; existing single-tenant (Pacific) cron tests re-run and produce the same output | `spec.md` §11a, REQ-05, Q4 answer |
| `price-listing-adjustment-expiry.service.ts` (3 sites, 2 `@Cron`) | shared export + `@Cron` | same mechanism | `spec.md` §11a, REQ-05 |
| `quotation-expiry.service.ts` (2 sites, 1 `@Cron`) | shared export + `@Cron` | same mechanism | `spec.md` §11a, REQ-05 |
| `permit-expiry.service.ts` (1 site, 1 `@Cron`) | shared export + `@Cron` | same mechanism | `spec.md` §11a, REQ-05 |

### Deliberately not in this unit

- Whether the fleet-tracking crons (none exist today — Samsara polling is not on this
  list) or any future per-tenant sweep should follow this same hourly-select pattern — out
  of scope; this unit fixes the 8 sites REQ-05 names, not a general scheduling policy.
- Reducing the 8 sites to fewer, shared cron jobs — REQ-05 asks that each stop deciding one
  day for every tenant, not that they be consolidated; consolidation is not requested by any
  source and would be scope this decomposer was not given.

---

## U5 — Web obtains the tenant zone and labels what it shows

- **Outcome:** `GET /api/v1/users/me` returns the tenant's business zone as a field on the
  session response, not in the JWT. Web's two known zone-less `businessToday()` calls
  (`payroll-week.ts:76`, `craft-code-format.ts:27`) resolve against that zone instead of the
  server's default, and both are labelled with the zone name on screen — matching mobile's
  existing "label, don't silently convert" pattern rather than the web payroll panel's
  previous unlabelled business-zone rendering. The signed quotation PDF (which has no
  viewer to resolve a zone for at all) renders in the tenant's business zone and states the
  zone name in the document, the same rule applied to a surface with no session.
- **Kind:** vertical. It is not a layer split: the `/me` response-shape change, the web
  call-site fix, and the label are one slice — a carrier with nothing reading it, or a
  display fix reading a carrier that does not exist, are each half a feature on their own.
- **Requirements covered:** REQ-06, fully, **except** the tenant-timezone-*edit* path
  (`PATCH /admin/tenants/:id` accepting `timezone`), which is cut out of this unit — see
  *Deliberately not in this unit*, Q10. Also `usecase/docusign/quotation-pdf.service.ts`'s
  REQ-03-tagged rows, folded in here (as in the prior draft) because both are display
  questions Q7 settles, not the business-day mechanism U3 owns.
- **Depends on:** U2. Q6 and Q7 are both answered, so no open question blocks the scope
  above; the edit-path cut described below is the one place an open question (Q10) still
  binds, and it is excluded rather than worked around.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | inherits U2 |
| API (`apps/api`) | `GET /api/v1/users/me` (`UsersController.getProfile`, `users.controller.ts:36`) — its response (`UserProfileResponse`, `usecase/users/users.service.ts:31`) gains a `timezone: string` field sourced from the acting user's `TenantCompany.timezone`. This is Q6's settled carrier: **not** `JwtPayload` (`spec.md` §7 argues explicitly against it — a stale token would keep pricing against the old zone until it expires) — the field lives only on the `/me` response, which is refetched on demand. `usecase/docusign/quotation-pdf.service.ts` (2 sites) resolves the tenant's zone (via `TenantContextService`, reusing U3's mechanism where the PDF-generation path runs inside a request) and renders every timestamp on the document labelled with the zone name — Q7's "always labelled" answer applies exactly as much to a document with no viewer as to a screen with one. | `PATCH /admin/tenants/:id` accepting `timezone` (the edit path, §4) is **not** built here — see *Deliberately not in this unit*, Q10. |
| Web (`apps/web`) | `apps/web/src/features/auth/services/auth.service.ts`'s `UserProfile` interface gains the `timezone` field returned by `/users/me` (already fetched by `authService.getProfile`, `:56`) — no new request, an existing one gains a field. `apps/web/src/features/payroll/lib/payroll-week.ts:76` and `apps/web/src/features/craft-codes/components/craft-code-format.ts:27` stop calling zone-less `businessToday()` and pass the session's tenant zone instead. Both surfaces that render the resulting date/time gain a zone label next to it (Q7: "always labelled"), matching the pattern mobile's `zone-label.ts` already established rather than inventing a new one. | Every other `toLocaleDateString`/`toLocaleTimeString` in web renders in the browser's zone today and stays that way — `spec.md` §11a is explicit that only these two call sites are currently known to be wrong (zone-less `businessToday()`), and Q7's answer does not retroactively enumerate the rest; a wider sweep of `apps/web` for zone-sensitive display is not something this spec asked for. |
| Mobile (`apps/mobile`) | N/A — see U6 | |
| Shared (`packages/shared`) | No change. `JwtPayload` (`packages/shared/src/types/index.ts:4`) is deliberately **not** touched — Q6's answer is the carrier REQ-06 already argued for. | |
| Tests | A test that `/users/me` returns the tenant's zone for two differently-zoned synthetic tenants. A web test that `payroll-week.ts`/`craft-code-format.ts` resolve against the session zone rather than the server default, and that the label renders. A `quotation-pdf.service.ts` test that two tenants in different zones get differently-timed, differently-labelled PDFs for the same instant. | |

### Reviewable as

- **Demo:** log in as two synthetic tenants in different zones; `/users/me`'s response
  shows each one's zone; the payroll-week and craft-code screens show that tenant's date,
  labelled with the zone name; a generated quotation PDF for each shows times in that
  tenant's zone, labelled.
- **Acceptance:** REQ-06's acceptance is now stateable: `/me` carries the zone, the two known
  web call sites resolve against it, and every rendered value is labelled. `quotation-pdf.service.ts`'s
  REQ-03 rows pass the same acceptance REQ-06 does (labelled, tenant-zone), not REQ-03's
  business-day-mechanism acceptance.
- **Reviewer can verify without:** without U3 for the two known web call sites (they read
  the zone straight off the session, not through `TenantContext`) — **but** the PDF path
  does reuse `TenantContextService`, so that one row needs U3's mechanism already built to
  be more than a literal. Without U4, U6 — disjoint surfaces.

### Risk

- **Weakest source:** `[UNVERIFIED]` — REQ-06's source is
  `decisions/2026-09-09-tenant-timezone-configuration.md`, `status: reference`, same weight
  as the rest of this ticket. No `[OPEN]` question blocks the scope this unit now covers;
  Q6 and Q7 are both answered.
- **Migration reversible:** N/A — no migration of its own; inherits U2's.
- **Behind a flag:** no — a response field either exists or does not; there is no partial
  state worth flagging separately from the deploy itself.
- **Touches existing data:** no.
- **Blast radius:** every session on web reads the new `/me` field going forward, and the
  two known display call sites plus the quotation PDF change what a user sees. **`tcg-contract-tracer`
  almost certainly applies** and should be run: `UserProfileResponse` is a response shape
  consumed by `apps/web`'s `UserProfile` (a hand-typed, not `@tcg/shared`-carried,
  duplicate — the same "only files importing `@tcg/shared` are compile-checked" gap U2's
  `CreateTenantPayload` sits in), so a field addition here will not be caught by any
  compiler if a second, undiscovered web consumer expects a narrower shape; the tracer's
  four independent search passes are exactly the tool for finding one this decomposer's own
  grep-based enumeration might miss. `tcg-prisma-guardian` — not required (no schema change
  in this unit).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `apps/web/src/features/payroll/lib/payroll-week.ts:76` | `businessToday()`, zone-less | test: resolves against session zone; labelled | `spec.md` §11a row, Q7 answer |
| `apps/web/src/features/craft-codes/components/craft-code-format.ts:27` | `businessToday()`, zone-less | test: resolves against session zone; labelled | `spec.md` §11a row, Q7 answer |
| `apps/web/src/features/auth/services/auth.service.ts` `UserProfile`, `authService.getProfile` (`:56`) | `GET /users/me` | existing auth/profile tests re-run unchanged for a Pacific tenant; new field is additive | web-side carrier for Q6's `/me` answer, traced 2026-09-09 from `auth.service.ts:56` |
| `usecase/docusign/quotation-pdf.service.ts` (2 sites) | direct call + `TenantContextService` | two-tenant, two-zone PDF test | `spec.md` §11a row, Q7 answer ("tenant zone, always labelled" applies to a document too) |
| every other `toLocaleDateString`/`toLocaleTimeString` in `apps/web` | browser-zone rendering | none needed — explicitly not this unit's scope; `spec.md` §11a's enumeration names only the two known call sites | `spec.md` §11a |
| `packages/shared/src/types/index.ts:4` `JwtPayload` | shared export | none needed — verified unchanged: Q6 settled the carrier as `/me`, not the token | `spec.md` §7, Q6 answer |

### Deliberately not in this unit

- **`PATCH /admin/tenants/:id` accepting a `timezone` change (the edit path) — cut out,
  blocked on Q10.** Q6 settles *who* may set the zone (SUPER_ADMIN, via the existing
  `admin/tenants` surface) but not what happens to an open payroll period when an existing
  tenant's zone changes — genuinely unanswered, and not something Q5 ever covered (Q5 was
  the *initial* value only). The zone decides which payroll week a shift falls in
  (PAY-001), so moving it under an open period changes money near the week boundary; Q6's
  answer already makes the field SUPER_ADMIN-writable at any time, which makes this
  reachable today, not hypothetical. The spec names a workaround — refuse the change while
  any period is open, and say so in the error — as "the only option that cannot silently
  restate money," but that is Q10's interim answer to build *if and when* the edit path is
  built, not licence to build it here without a product decision. This unit ships `/me` and
  the display fixes; the edit endpoint stays exactly as it is today (it does not yet accept
  `timezone` at all, since `UpdateAdminTenantDto` was not touched by U2 either).
- The 12h/24h time-format preference (`admin/gaps.md` → *Time display*) — a separate open
  question, out of scope per `intent.md` §5, not folded into this unit even though it sits
  under the same display surface.
- The traveling-user display question (Q7's residual) — raised against mobile's
  `zone-label.ts`, not a web surface; carried by U6, not duplicated here.

---

## U6 — Mobile labels field times against the tenant zone

- **Outcome:** Every persisted-time string in the field-ticket flow — step summaries, the
  resume-step line, validation messages, all currently rendered via
  `formatClockTimeWithZone` — shows the **tenant's business-zone** wall-clock time, labelled
  with the business zone's name, instead of today's device-local time labelled with the
  device's zone. `isDeviceOnBusinessZone()`/`hoursFromBusinessZone()` compare the device
  against the **tenant's** zone rather than the hardcoded `BUSINESS_TIMEZONE` constant, so
  the mismatch warning they were built for (and never wired to any UI) becomes correct for
  a non-Pacific tenant too, if and when something calls them.
- **Kind:** vertical. Not a layer split: the zone-comparison helpers, the formatting
  function, and every one of their call sites move together, because a helper re-signed
  without its call sites updated is worse than not touching it — the numbers would silently
  disagree with the label.
- **Requirements covered:** REQ-07, fully, except the traveling-user residual (see
  *Deliberately not in this unit*).
- **Depends on:** U2, and in practice on **U5's carrier landing on the same endpoint** —
  not merely "likely to share" as previously written: mobile already calls
  `GET /users/me` for its own identity resolution
  (`apps/mobile/data/services/identity/identity.http.ts:31`), the exact endpoint U5 adds
  `timezone` to. No new endpoint or mechanism is needed; mobile is already fetching the
  response U5 extends.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | inherits U2 |
| API (`apps/api`) | N/A | the carrier (`GET /users/me` gaining `timezone`) is U5's change; this unit only consumes it |
| Web (`apps/web`) | N/A | |
| Mobile (`apps/mobile`) | `apps/mobile/data/contracts/identity.contract.ts` — `IdentityProfileSchema` (zod) gains a `timezone: z.string()` field; without it the new response field is silently stripped, since zod drops unlisted keys by default. `apps/mobile/features/field-ticket/timers/zone-label.ts` — `isDeviceOnBusinessZone()` and `hoursFromBusinessZone()` stop importing `BUSINESS_TIMEZONE` and take the tenant's zone as a parameter (sourced from the identity profile) instead. `apps/mobile/features/field-ticket/steps/time-clock.tsx:74` `formatClockTimeWithZone(ms)` — currently formats the **device's** local wall-clock time via `formatTimeParts` (native `Date.getHours()`/`getMinutes()`, always device-local) and labels it with `deviceZoneLabel()` (also device-local, `Intl.DateTimeFormat` with no `timeZone` option). Both need to resolve against the **tenant's** zone: the wall-clock parts via an `Intl.DateTimeFormat(..., { timeZone: tenantZone })` read (matching `@tcg/shared`'s `business-time.ts` approach, not a new one), and the label via the same options with `timeZoneName: 'short'` pinned to `tenantZone` instead of the device default. Every call site of `formatClockTimeWithZone` (`resume-step.ts:127`, `step-time-bounds.ts:147,157`, `StartWorkBody.tsx:744`) is unaffected in signature — the function's contract (`ms: number` in, labelled string out) does not change, only what it resolves against — but each is where the on-device correctness of this change is actually visible, so each needs re-verifying against a real render, not just a passing unit test. | **Verify on device before shipping** — REQ-07's own executor note. Pinning `Intl.DateTimeFormat` to an arbitrary IANA `timeZone` option (not just reading the device's own) is exactly the case commit `45934840` said it would not rely on across every Hermes build without testing first. This is an engineering risk, not a product unknown — it does not block starting the unit, but it does mean "device-verified" is part of this unit's definition of done, not a follow-up. |
| Shared (`packages/shared`) | No change. `BUSINESS_TIMEZONE` stops being imported by `zone-label.ts`; no signature in `business-time.ts` changes (all already take `timeZone`, per spec §7). | |
| Tests | Existing `zone-label` unit tests (device-zone comparison logic) re-parameterised to take an explicit tenant zone instead of the constant. A new test that `formatClockTimeWithZone` renders the same instant differently for two different tenant zones and labels each correctly. Manual, on-device verification (per the Hermes caveat) on at least one non-Pacific-zone build before merge. | |

### Reviewable as

- **Demo:** on a device set to a zone different from a synthetic tenant's business zone, a
  field-ticket step summary shows the tenant's business-zone time, labelled with the
  business zone's name — not the device's.
- **Acceptance:** REQ-07's acceptance is now stateable: no call site renders a persisted
  time labelled in the device zone; every one resolves against and labels the tenant's
  zone; on-device verification has been done for at least one non-Pacific case.
- **Reviewer can verify without:** without U3, U4 — disjoint surfaces. **Cannot** be
  verified without U5's `/me` carrier already landed (this unit reads the same field U5
  adds) or without on-device testing (a simulator's `Intl` behaviour is not a substitute,
  per the Hermes caveat).

### Risk

- **Weakest source:** `[UNVERIFIED]` — REQ-07's source for the answer is
  `decisions/2026-09-09-tenant-timezone-configuration.md`, `status: reference`, same weight
  as the rest of this ticket. No source is `[OPEN]`; the residual (traveling user) is
  explicitly carried forward rather than blocking this unit.
- **Migration reversible:** N/A.
- **Behind a flag:** no — recommend one anyway given the Hermes risk below, even though the
  spec does not require it: a bad on-device `Intl` result would be a wrong clock shown to a
  crew member recording paid time, which is the exact failure the current device-zone
  default was chosen to avoid. This is a recommendation, not a requirement stated anywhere
  — noted as such rather than silently built in.
- **Touches existing data:** no — display only; no captured timestamp changes.
- **Blast radius:** every field-ticket time shown to a crew member. The Hermes `Intl`
  pinning risk (see Slice contents) is this unit's most likely source of a size overrun —
  if on-device testing surfaces a build where a pinned `timeZone` option misbehaves, the
  fix is a Hermes/Expo SDK question, not a scope question, and would need its own
  investigation before this unit could close. `tcg-prisma-guardian`, `tcg-contract-tracer`
  — not required (no schema change; the `/me` field itself is U5's contract-tracer
  concern, and this unit only consumes an already-added field via the mobile identity
  contract, which is not a compiled `@tcg/shared` boundary).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `apps/mobile/features/field-ticket/timers/zone-label.ts` (`isDeviceOnBusinessZone`, `hoursFromBusinessZone`) | `BUSINESS_TIMEZONE` import, re-signed to take a tenant zone | re-parameterised unit tests | `spec.md` §11a row, Q7 answer |
| `apps/mobile/features/field-ticket/steps/time-clock.tsx:74` `formatClockTimeWithZone` | device-local `Date` methods + `deviceZoneLabel()` | new two-zone test + on-device verification | `spec.md` REQ-07, Q7 answer |
| `resume-step.ts:127`, `step-time-bounds.ts:147,157`, `StartWorkBody.tsx:744` | call `formatClockTimeWithZone` | unaffected signature; covered by the function-level test above, plus a manual on-device check of at least one of these renders | `spec.md` REQ-07 |
| `apps/mobile/data/contracts/identity.contract.ts` `IdentityProfileSchema` | zod validation of `GET /users/me` | schema test asserting `timezone` round-trips instead of being silently stripped | traced 2026-09-09 from `identity.http.ts:31` to the same `/users/me` endpoint U5 extends |

### Deliberately not in this unit

- **The traveling-user display — Q7's residual, explicitly still open.** Whether someone
  normally in one zone who travels sees a warning, a dual display, or nothing at all is
  undecided; Syed Haris flagged he needs to check it. `isDeviceOnBusinessZone()` and
  `hoursFromBusinessZone()` are re-pointed at the tenant zone by this unit (so the
  comparison itself is correct for a non-Pacific tenant), but **remain wired to no UI
  anywhere** — this unit does not add the warning, the dual display, or any other
  surfacing of the mismatch they compute. Building that without a product answer would be
  exactly the "pick a plausible answer" move the decomposer's brief forbids.
- Any change to what instant is captured or sent to the API — REQ-07 and this unit are
  display-only; `zone-label.ts`'s own docblock is explicit that nothing here changes a
  captured instant.

---

## U7 — Fleet-tracking days converge onto the tenant zone; `FLEET_TIMEZONE` is deleted

- **Outcome:** A tenant set to a non-Pacific zone gets the same fleet-tracking day as their
  payroll and quotation day — both computed from `TenantCompany.timezone` — instead of a
  hardcoded, env-var-driven Pacific default that no admin can see or change. The two
  duplicate implementations (`apps/api`'s `dayjs`-based `fleet-day.ts`, `apps/web`'s
  build-time `NEXT_PUBLIC_FLEET_TIMEZONE` constant) are gone, along with the three env vars
  that drove them.
- **Kind:** vertical. Not a layer split: REQ-10 requires deleting the same env-var mechanism
  from `apps/api` and `apps/web` at the same time. `apps/web/.env.example:38` already admits
  the two copies are today kept in step only "by hand" — a comment, with nothing failing if
  they drift — and REQ-10's own ripple note is explicit that a deleted env var still set in a
  deploy pipeline fails silently. Splitting api and web into separate units would recreate
  exactly that failure mode for the length of the gap between them: the API would resolve a
  per-tenant fleet day while the web bundle still baked in a build-time Pacific constant,
  which is the cross-surface-disagreement case §7 of the decomposer's brief calls out by
  name. The `packages/shared` half (the constant deletion and the new RFC 3339-with-offset
  formatter) is small enough to travel with the retirement rather than justify its own
  foundation unit — nothing else consumes it yet.
- **Requirements covered:** REQ-10, fully.
- **Depends on:** U3 (REQ-10's own executor note: sequence after REQ-03/U3 — `fleet-day.ts`
  cannot read a tenant zone from `TenantContext` until U3 has built the resolution
  mechanism) and U5 (the web half reads the zone via whatever `/me` carrier U5's Q6/Q7
  answers settle — `fleet-date.ts` should use the same mechanism web's other consumers do,
  not invent a second one). **Neither dependency is an open question** — Q5/Q6/Q7 are all
  answered, so U3 and U5 are themselves unblocked, just not yet built. U7 is additionally
  gated on a repo-state precondition that is not modeled as a unit dependency because it is
  not one: see *Sequencing* below — this branch and `main` currently hold disjoint halves of
  what U7 needs, and neither branch alone can build it.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | `TenantCompany.timezone` already exists once U2 lands; REQ-10 adds no column of its own. |
| API (`apps/api`) | `apps/api/src/config/env.validation.ts:79` — delete the `FLEET_TIMEZONE` Joi validator and its default. `apps/api/src/usecase/vehicle-tracking/fleet-day.ts` — `fleetTimezone()` (:29) stops reading `process.env.FLEET_TIMEZONE \|\| DEFAULT_FLEET_TIMEZONE` and resolves the acting tenant's zone via `TenantContext` (U3's mechanism); `fleetDayWindow()` (:39) and its callers drop `dayjs` + `dayjs/plugin/timezone` for `@tcg/shared`'s `business-time.ts` (`businessDateOf`, `startOfBusinessDay`, `endOfBusinessDayExclusive`). `apps/api/src/presentation/vehicle-tracking/dto/vehicle-history.dto.ts` — the `IsFleetDate` `class-validator` constraint needs a designed answer for reaching a per-tenant zone from inside a constraint Nest does not build through DI (the existing code's `process.env` read is precisely the workaround this design point replaces — there is no drop-in substitute). `apps/api/src/usecase/vehicle-tracking/vehicle-history.service.ts` and `apps/api/src/usecase/vehicle-tracking/index.ts` — update to the rewired imports. `apps/api/.env.example` — delete the `FLEET_TIMEZONE` line. | **Design the `IsFleetDate` fix first, not last** — REQ-10's own executor note. Until a shape is chosen (resolve from the same `AsyncLocalStorage` `TenantContext` uses, statically; or move the fleet-date bound check out of the decorator into the usecase layer) the rest of this row cannot be estimated with confidence — see *Risk*. |
| Web (`apps/web`) | `apps/web/src/features/vehicle-tracking/utils/fleet-date.ts:33` — stop capturing `NEXT_PUBLIC_FLEET_TIMEZONE \|\| DEFAULT_FLEET_TIMEZONE` as a module-level build-time constant; read the tenant zone from `/me` (U5's Q6-settled carrier) at request time instead. `apps/web/.env.example:38` — delete `NEXT_PUBLIC_FLEET_TIMEZONE`. `apps/web/Dockerfile:65,84` — delete the matching `ARG`/`ENV` pair. | The `Dockerfile` rows are part of this unit, not a deploy follow-up — a deleted env var still declared in the image build fails silently, per REQ-10. |
| Mobile (`apps/mobile`) | N/A | REQ-10's surface list is api/web/shared only; `FLEET_TIMEZONE` has exactly two copies (api, web) per `spec.md` §11a's "On `main`" table — mobile never had one. |
| Shared (`packages/shared`) | `packages/shared/src/constants/vehicle-tracking.ts:27` — delete `DEFAULT_FLEET_TIMEZONE`. `packages/shared/src/utils/business-time.ts` — add a small RFC 3339-with-offset formatter (`formatInstant`, :264, is `Intl.DateTimeFormat` for human display and has no equivalent today); without it, the log-readability behaviour `fleet-day.ts` deliberately built — an emitted window reading in the driver's own offset (`2026-09-08T00:00:00-07:00`) rather than `Z` — is silently lost. REQ-10 calls this out by name: *"Add it; do not silently drop the behaviour."* | Samsara accepts either offset form equally (see Ripple, Samsara row) — this addition is about log/debug readability, not correctness. |
| Tests | `fleet-day.spec.ts` (exists on `main`) extended: two tenants seeded in different zones get different fleet days from the same instant. `vehicle-history.dto.spec.ts` (exists on `main`) extended for whatever `IsFleetDate` design is chosen. A web-side equivalent proving `fleet-date.ts` derives the same fleet date the API now would for a non-Pacific tenant. The two acceptance greps from `spec.md` REQ-10 (`FLEET_TIMEZONE`/`DEFAULT_FLEET_TIMEZONE` absent outside migration history; `dayjs` absent from both vehicle-tracking trees). | |

### Reviewable as

- **Demo:** two synthetic tenants in different IANA zones hit the same vehicle-tracking
  endpoint at the same instant and get different fleet days, on both the API response and
  the web screen that renders it — matching the day either tenant's payroll/quotation surface
  would report for the same instant.
- **Acceptance:** REQ-10's acceptance line in `spec.md` §2 — both greps, plus the two-tenant
  test.
- **Reviewer can verify without:** without U4 (crons) and U6 (mobile) — disjoint files, per
  REQ-10's surface list. **Cannot** be verified without U3 already built (there is no real
  per-tenant zone for `fleet-day.ts` to read otherwise) and without U5's `/me` carrier
  decision already landed on web — this is not a "helpful but skippable" dependency, it is
  the thing that makes "retire the env var" a reviewable outcome at all rather than a rename.
  A version of this unit built against a literal zone instead of U3/U5's real resolution
  would look identical in a demo and prove nothing about the retirement.

### Risk

- **Weakest source:** `[UNVERIFIED]` — REQ-10's sources are `status: reference` decision
  notes from Syed Haris, not a `verified` adjudication by a client-side product owner. Same
  tag as every other requirement in this ticket; routine on its own.
- **Migration reversible:** N/A — no migration in this unit; the schema half is U2's.
- **Behind a flag:** no — this is a one-shot cutover, not a gradual rollout. The env vars
  and the code that reads them are deleted together; there is no partial state where half of
  `fleet-day.ts` reads the tenant column and half still falls back to `FLEET_TIMEZONE` that
  would be worth shipping behind a flag.
- **Touches existing data:** no — code and deploy-config only, no backfill.
- **Blast radius:** every fleet-tracking query and screen, for every tenant, plus any deploy
  pipeline that still sets `FLEET_TIMEZONE` / `NEXT_PUBLIC_FLEET_TIMEZONE` after this merges
  (silent failure, not an error — REQ-10 names this explicitly). The `IsFleetDate` design
  point is the item most likely to push this unit's size past `M`: it is a real DI-vs-`class-validator`
  problem, not a rename, and REQ-10 is explicit that it should be designed before the rest
  of the row is touched, not discovered mid-build. Required gates: standard
  build/lint/typecheck + the two extended spec files above. **`tcg-contract-tracer` is
  required** — `vehicle-history.dto.ts` is a response-shape file and `fleet-date.ts` on web
  consumes `@tcg/shared`, so a shape change here is exactly the kind only the importing files
  are compile-checked for. **`tcg-prisma-guardian` is not required** — no schema change in
  this unit.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `apps/api/src/usecase/vehicle-tracking/fleet-day.ts` `fleetTimezone()`:29, `fleetDayWindow()`:39 | direct `process.env` read + `dayjs`/`dayjs-timezone` | extended `fleet-day.spec.ts` (exists on `main`): two-tenant, two-zone test | `spec.md` REQ-10, §11a "On `main`" table |
| `apps/api/src/presentation/vehicle-tracking/dto/vehicle-history.dto.ts` `IsFleetDate` | `class-validator` constraint reading `process.env` directly (the existing DI workaround) | extended `vehicle-history.dto.spec.ts` (exists on `main`), scoped to whichever design is chosen | `spec.md` REQ-10 — "how a tenant zone reaches a validator is a real design point, not a rename" |
| `apps/api/src/usecase/vehicle-tracking/vehicle-history.service.ts`, `usecase/vehicle-tracking/index.ts` | import of the rewired `fleet-day.ts` exports | covered by the same `fleet-day.spec.ts` extension (both are thin pass-throughs; no independent logic to regress) | `spec.md` §11a "On `main`" table, "consumers" row |
| `apps/web/src/features/vehicle-tracking/utils/fleet-date.ts:33` | build-time `NEXT_PUBLIC_FLEET_TIMEZONE` constant | new web-side test asserting the same fleet date as the API for a non-Pacific tenant | `spec.md` REQ-10, §11a "On `main`" table |
| `apps/api/.env.example`, `apps/web/.env.example`, `apps/web/Dockerfile:65,84` | deploy-time config, not code | none needed as a "test" — the acceptance grep (`git grep -n 'FLEET_TIMEZONE\|DEFAULT_FLEET_TIMEZONE'` returns nothing outside migration history) is the proof; no runtime regression path exists for a deleted config value that was never read by anything else | `spec.md` REQ-10 — "a deleted env var still set in a deploy pipeline fails silently" |
| `apps/api/src/service/samsara/samsara.repository.ts` (3 call sites) | none — this unit does not reach it | **none needed — verified this unit does not reach it.** Samsara receives only absolute RFC 3339 `startTime`/`endTime`, never a timezone, at all three call sites; REQ-10 states this and it was verified 2026-09-09. This unit's formatter addition to `business-time.ts` changes what offset a *logged* window reads as, not what Samsara is sent. | `spec.md` REQ-10, "Why this is safe with respect to Samsara" |

### Deliberately not in this unit

- **Whether the fleet day, job day and payroll day must conceptually share one boundary** —
  `.ai/vault/assets/gaps.md` → *The fleet day* raised this as a second question beyond the
  env-var mechanism; REQ-10's decision retires the mechanism (env var → tenant column,
  `dayjs` → `business-time.ts`) and, as a side effect of both now using the same
  `startOfBusinessDay`/midnight-local boundary REQ-09 already settled, the boundaries do
  converge — but no one adjudicated that as its own policy question, and the vault register
  is left open in case a client-side owner disagrees later.
- **Mobile fleet-time display** — REQ-10's surface list does not include mobile, and no
  `FLEET_TIMEZONE` copy exists there to retire (confirmed above).
- **The untypechecked third payroll-engine call site** (`apps/api/prisma/scripts/seed-payroll-demo.ts:917`,
  §11a) — a real hole, but it is REQ-04/U1's surface, not REQ-10's; unrelated to fleet
  tracking.

---

## Sequencing

```
U1 (buildable now, standalone)

U2 ──▶ U3 ──▶ U7
  ├──▶ U4
  ├──▶ U5 ┄┄▶ U7   (web half of U7 needs U5's /me carrier)
  └──▶ U6

All of U2–U7 blocked — Q5 (U2 itself), and transitively for U3/U4/U5/U6/U7.
U4 additionally blocked on Q4. U5 additionally blocked on Q6, Q7. U6 additionally blocked on Q7.
U7 additionally gated — ahead of, and separately from, U3/U5 — on the branch-reconciliation
precondition below.
```

- **Parallelisable:** U1 has no dependency and can proceed today, alongside nothing else
  (everything else is blocked). Once U2 lands: U3 (`apps/api` business-day files), U4
  (the 4 cron files), U5 (`apps/web` + its own `GET /me` change), and U6
  (`apps/mobile/features/field-ticket/timers/zone-label.ts`) touch disjoint file sets — none
  of the four owns a file another does — so once each is individually unblocked by its own
  question (Q4 for U4; Q6+Q7 for U5; Q7 for U6), they can run concurrently. The one file
  both U3 and U4 might be tempted to touch is ruled out explicitly: U3's *Deliberately not
  in this unit* excludes the 4 cron files by name, and U4 owns them exclusively. U7's files
  (`usecase/vehicle-tracking/*`, `presentation/vehicle-tracking/dto/vehicle-history.dto.ts`,
  `apps/web/src/features/vehicle-tracking/*`) are disjoint from all of U3–U6's, so U7 does
  not contend with U4 or U6 for anything — but it cannot start until U3 and U5 have,
  respectively, built the resolution mechanism and settled the `/me` carrier it reads.
- **Merge order constraint:** U2's migration must merge, and `tcg-prisma-guardian` must
  pass on it, before U3, U4, U5, U6 or U7 can even compile against `TenantCompany.timezone` —
  Prisma Client's generated types come from the committed schema. If U5's carrier decision
  (Q6) turns out to require a `GET /me` shape that U6 also consumes, that single API change
  should land once and be shared, not built twice — flagged here rather than forced, since
  it is not certain until Q6/Q7 resolve. U7 then merges after both U3 and U5.
- **Branch-reconciliation precondition — gates U7 only, but it is a ticket-wide constraint,
  not a unit-level one:** `main` is **83 commits ahead** of `fix/timezone-business-day`.
  Every file U7 touches — `apps/api/src/usecase/vehicle-tracking/fleet-day.ts`,
  `apps/api/src/config/env.validation.ts`, `packages/shared/src/constants/vehicle-tracking.ts`,
  `apps/api/src/presentation/vehicle-tracking/dto/vehicle-history.dto.ts`,
  `apps/web/src/features/vehicle-tracking/utils/fleet-date.ts`, both `.env.example` files,
  `apps/web/Dockerfile` — exists **only on `main`**. `packages/shared/src/utils/business-time.ts`,
  the file U7 converges onto, exists **only on `fix/timezone-business-day`**. No single
  commit today contains both halves of what U7 needs, so U7 cannot be attempted — not
  "blocked on a question," but literally unbuildable against either branch as it stands —
  until this branch and `main` are reconciled (either direction: rebase/merge `main` in, or
  land this branch and pick the reconciliation up on `main`). This affects **no other unit**
  in this ledger: U1–U6 all touch files that already exist on `fix/timezone-business-day`
  and none of them import anything from the 83 commits `main` is ahead by. The
  reconciliation is therefore scoped to this one merge-ordering fact, not a reason to delay
  U1–U6.
- **First unit to ship:** U1. It proves the "explicit zone at the boundary, no engine
  opinion" pattern end-to-end for the one piece of this ticket with no open question behind
  it, using the same two-zone fixture (`2026-06-06T06:00:00Z`) that every later unit's
  multi-zone test should reuse. It does **not** prove the harder part of this plan — Q5's
  migration-shape question, which every other unit sits behind — and that is a finding
  about the plan, not a defect in U1: the ticket's genuine risk is concentrated in six
  unanswered product questions, not in engineering difficulty.

---

## Anything wrong or unsliceable in the spec

- **REQ-03 reads as buildable (`[UNVERIFIED]`, "Open question: none for the API's own
  decisions") and is not, once you try to slice it.** Its own acceptance line requires
  every one of 43 call sites to pass an explicit zone via `TenantContext`, and
  `TenantContext` cannot resolve a real value without `TenantCompany.timezone` existing —
  which is REQ-01's migration. **Updated 2026-09-09:** Q5 is answered, so REQ-01's migration
  is no longer *blocked* — but the sequencing point stands unchanged, because it was never
  about the question. REQ-03 waits on the column existing, not on anyone's answer. The
  spec's "Open question: none" for REQ-03 is true only for *whether the API should do this*;
  it is not true for *whether the API can do this yet*. This is worth flagging back rather than quietly
  working around: a requirement can be un-open and still be unbuildable, when it depends on
  a different requirement's still-open shape. `spec.md` does not currently say this in one
  place — REQ-03's "Notes for the executor" describes the mechanism but does not flag that
  the mechanism needs REQ-01's column to exist first.
- **REQ-02 is not really a unit-shaped requirement.** It is a statement that a ripple is
  zero and an invariant the migration must not break — there is no independent work to do
  for it outside U2's migration. Folding it into U2 (rather than inventing a unit or
  leaving it "not covered") is a judgment call worth surfacing rather than making silently.
- **REQ-09's scope is itself undetermined**, not merely blocked. The spec's own executor
  note says it may be entirely out of scope for this ticket ("if the answer is midnight").
  Rather than pre-slicing a unit that might not belong to this ticket at all, it is left
  uncovered with that reasoning stated — inventing a unit here would be inventing scope.
- **Everything downstream of U1 is blocked**, which makes this decomposition light on
  buildable units and heavy on shaped-but-blocked ones. That is a property of the spec at
  this state (6 of 8 §12 questions still open), not a slicing failure — cutting units down
  further would mean inventing defaults (Q5), a cron shape (Q4), a display rule (Q6/Q7), or
  a workday boundary (Q8), each of which this decomposer is explicitly forbidden from
  doing.

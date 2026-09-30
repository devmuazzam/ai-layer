# Units — PAYROLL-FLAGS Flagged-entries rework, units U1–U5

> Written to `.ai/aidlc/PAYROLL-FLAGS/units.md` from the approved `spec.md` beside it.
> Consumed by the decomposer and then by an executor, one unit at a time.
>
> **Nothing here has been implemented.** The decomposer produced this file and stopped.

**Spec revision this `units.md` was cut from:** the version signed off in `spec.md` §14 —
**14 requirements (REQ-01–REQ-14), 0 verified, 14 unverified, 0 conflicted, 0 open.** All
seven §12 questions (Q1–Q7) are `Status: resolved`, folded into their REQs. Nothing below
diverges from that text; there is nothing to reconcile.

**File paths and line numbers below were verified directly against the codebase on
`feat/PAYROLL-FLAGS-foundation`, which at the time of this decomposition sits exactly at
`origin/main` `ff7674801` (`git merge-base HEAD origin/main` == `HEAD`).** Every citation the
spec made — controller routes, service methods, schema lines, mobile contracts, web
components — was re-grepped, not trusted from the spec's own text. All of it checked out
against the line numbers the spec cites, with one behavioral nuance and two naming/pattern
findings recorded below that the spec did not carry (§ *Findings from path verification*).

## Git layout — one branch, one PR, five commits, developer's explicit choice

Per the developer's instruction for this decomposition (not itself a `spec.md` §12 item —
`spec.md` §0's *Scope note* already records the same choice as a process decision, sourced
to `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` round 8,
reference-status): **all five units ship on the single existing branch
`feat/PAYROLL-FLAGS-foundation`, as one PR, one commit per unit**, in dependency order —
**U1, U2, U3, U4, U5**. This overrides this project's usual one-unit-per-branch convention
(`.ai/aidlc/agents/` executor default) for this ticket only.

**Each unit's commit must still stand alone**: build, typecheck and pass its own new tests
on top of whatever the previous commits in the branch already added. Checking out the branch
at the tip of unit *N*'s commit must be a green, shippable state for units 1..*N* — the
single-branch choice changes where the commits live, not the requirement that each one is a
complete, working slice.

Dependency order, as given by the developer and confirmed against the requirements below:
**U1 first** (nothing depends on anything). **U2 depends on nothing** and may commit second
— it touches no file U1 touches and shares no table. **U3 depends on U1** (the
`payroll-admin` permission gate on the void endpoint). **U4 depends on U3** (the incomplete-
ticket gate's "escape path" is voiding, REQ-06; Remind's guard is also `payroll-admin`).
**U5 depends on U1** (every new route is `payroll-admin`-gated; REQ-13 routes flag
notifications through REQ-02's recipient resolver).

## What a unit is

A unit is a **vertical shippable slice**: schema → API → web and/or mobile → tests, for one
piece of behavior. It is reviewable on its own and it demonstrates something a person can
see working.

A unit is **not** a layer. "Add the Prisma model", "write the endpoints", "build the UI"
are three-eighths of a feature each, and none of them can be reviewed against the spec —
the reviewer has nothing to check the schema against until the UI exists, by which point
all three are in flight. Layer splits also hide integration failures until the last merge,
which is exactly when they cost the most.

**The test:** if the unit ships alone, what can someone do that they could not do before?
If the answer is "nothing, it's the backend half", it is not a unit. Merge it into the
slice it serves.

Legitimate exceptions, and they are narrow:

- A **schema-only foundation unit** when three or more later units all depend on one
  migration and splitting it per-unit would mean three migrations against the same table.
  Mark it `kind: foundation` and say which units consume it.
- A **shared-types unit** in `packages/shared` under the same condition.

Everything else is vertical.

**No foundation unit was created here either, and the developer's own U1–U5 grouping already
forecloses it**: REQ-06's schema (`JobTicket` columns) and REQ-09's schema (`PayrollFlag`/
`PayrollFlagEvent`) are two different migrations against two different tables, each owned by
the one unit that uses it (U3, U5). Nothing here is shared by three or more units. U1 has no
schema change at all — see *Findings from path verification* below, the deployment-gap
question in `spec.md` §3 is resolved by reading the code, not by a migration.

## Fill rules

Every field is required per unit. **Never delete a field.** Unfilled fields take
`NOT SPECIFIED`, `N/A — <reason>`, or `OPEN — <question>`, as in `spec.md`.

A unit may not depend on an `[OPEN]` requirement. If it does, either the question gets
answered first or the unit is cut down to the part that does not depend on it — and the
cut is recorded in *Deliberately not in this unit*.

An `[UNVERIFIED]` requirement is different and much weaker: it **does not** block a unit.
Almost every requirement carries it. It constrains *how* the unit is built, not whether —
see **Risk** below.

**Every one of the 14 requirements is `[UNVERIFIED]`, and none is `[OPEN]`.** No unit below
is blocked on a question. Two things about that worth carrying into every unit's Risk block
rather than restating five times: (1) REQ-04's cumulative-missed-meal extension and REQ-02's
Q2 answer are pay-rule content sourced only to developer direction, **pending Corrina
Bustos / Brian Petros ratification**, per `spec.md`'s own framing — that is U2's problem
specifically, not the other four units'; (2) six of the seven §12 answers (all but Q3) are
**not yet written into `.ai/vault/`** — `spec.md` §0 recommends `tcg-scrum` record them
alongside this ticket's close, which is a `close-ticket` step, not something any unit here
does.

## Findings from path verification

Three things the file-by-file check surfaced that `spec.md` did not carry, because they are
code-reading findings (current-state facts), not product questions — consistent with
`tcg-elaborator.md` §2's rule that the repository is read directly for ripple and mechanism,
never for intent. None of these changes a requirement; they change how confidently a unit
can be built and what its Risk/Ripple rows say.

1. **REQ-01 needs no schema-level backfill — this is now confirmed, not `NOT SPECIFIED`.**
   `spec.md` §3 flagged as unverified "whether the permission-check code already treats an
   absent key the same as `'none'`." It does, on both surfaces that matter, read directly:
   `packages/shared/src/constants/permissions.ts:57` — `PermissionMap` is `Partial<Record<...>>`,
   documented *"Missing modules are treated as 'none'"* — and `resolveEffectiveLevel`
   (`:121-134`) does `ctx.permissions[module] ?? 'none'`. `apps/api/src/guard/permissions.guard.ts:41-45`
   calls the *same* shared `can()` against the *same* map — server and client share one
   function, so there is no second code path to separately confirm. U1 needs **no migration
   and no backfill of any kind** — see U1's Slice contents, Schema row.
2. **A same-day voided ticket may not actually drop off the mobile active list — REQ-06's
   ripple claim (`spec.md` §11a row 5) needs a test, not just trust.** The cited function,
   `partitionDashboardTickets` (`apps/mobile/data/hooks/use-tickets.ts:45-81`), does **not**
   itself filter `CANCELLED`/`REJECTED` — read in full. It excludes only `COMPLETE` tickets
   up front, then partitions the rest by `isPastFieldTicket`/`isFutureFieldTicket`
   (`apps/mobile/data/contracts/ticket.contract.ts:161-189`), neither of which checks
   `status` against `CANCELLED` or `REJECTED` at all. For a ticket whose `scheduleDate` is
   strictly in the past, `isPastFieldTicket` returns `true` regardless of status and the
   ticket is dropped — which is very likely true of anything payroll is voiding, since
   payroll runs after the work week closes. But for a ticket scheduled **today** (a real
   possibility if a payroll admin voids same-day, or in any test/demo seeded with a
   current-date ticket), `isPastFieldTicket` and `isFutureFieldTicket` both return `false`,
   and the ticket lands in `activeTickets` — **it would still show.** Separately,
   `apps/api/src/service/job-tickets/job-tickets.repository.ts:418-421`'s `baseWhere` for
   the mobile ticket list (`status: { not: JobTicketStatus.PENDING }`) does not exclude
   `CANCELLED` either, so a same-day voided ticket does reach the mobile client in the first
   place. This is U3's problem, not a reason to change REQ-06 — see U3's Ripple row.
3. **"Flags" is already an overloaded word in this feature area — a naming collision risk for
   U5, not U3/U4.** `apps/web/src/features/payroll/components/job-payroll-flags-card.tsx`
   (`JobPayrollFlagsCard`, `PayrollJobFlags`, `useJobPayrollFlags`) is a **live, unrelated**
   feature — a checklist of job-level pay premiums (e.g. hazard pay), nothing to do with
   REQ-09's `PayrollFlag` review-flag entity. `PayrollEmployeeWeekStatus.FLAGGED`
   (`packages/shared/src/enums/index.ts:152`) is a *third* meaning, already the subject of
   REQ-09's own relabel note. U5 is where all three collide in the same feature area at
   once; see U5's Risk block.

---

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | A tenant admin can grant `payroll-admin` to any department role via Departments; once granted, only that role can Approve or Export payroll (narrowed from today's `payroll:edit`, which every seeded manager role holds); and notifications can be routed to whoever holds it | REQ-01, REQ-02, REQ-03 | shared, api, web | — | M | not started |
| U2 | Payroll prices the 8-hour rest premium from the rounded, paid end of the prior work chain, extended 30 minutes per missed-meal WTL penalty from the 2nd on, cumulatively — and the rest-audit screen shows the moved start, not just the raw entry end | REQ-04, REQ-05 | engine, api, web | — | M | not started |
| U3 | A Payroll Admin/Manager can void a job ticket that was never completed (not `REJECTED`), with a required note; it leaves payroll only, no billing effect, and the crew sees it drop off their mobile list with an in-app/email notice | REQ-06 | schema, api, web, mobile | U1 | M | not started |
| U4 | Approve is refused while any `PENDING`/`SENT`/`IN_PROGRESS` ticket in the employee's start-ticket week is still open (Calculate stays allowed); payroll can send that ticket's primary worker a real reminder | REQ-07, REQ-08 | api, web | U3 | M | not started |
| U5 | Calculate writes durable, per-period flags — starting with `OVERLAPPING_JOBS` — that block approval unconditionally until fixed or reviewed with a required note; Payroll Admin/Manager holders are notified in-app and by email, and see every open flag, act on it, and read the audit trail, from the payroll web app | REQ-09, REQ-10, REQ-11, REQ-12, REQ-13, REQ-14 | schema, api, shared, web | U1 | L | not started |

- **Requirements not covered by any unit:** none. **14 requirements in `spec.md` §1 — 14
  covered.** 3 + 2 + 1 + 2 + 6 = 14. Nothing is covered "partly" in the sense that matters —
  no requirement is split across two units the way some are in other tickets' decompositions;
  each REQ lands whole in exactly one unit, because the developer's own U1–U5 grouping already
  drew the boundaries requirement-by-requirement, not layer-by-layer.
- **Units blocked on an open question:** none. `spec.md` carries zero `[OPEN]` requirements
  and zero unresolved §12 questions at this revision.

---

## U1 — `payroll-admin` permission, recipient resolver, Approve/Export narrowed

- **Outcome:** A tenant admin can grant the new `payroll-admin` module (view/edit/full, like
  every other module) to any department role from the existing Departments role editor — no
  role has it by default, not even Payroll Manager's own seeded role. Once granted at `edit`
  or above, that role's holders can Approve and Export payroll, narrowed from today's
  `payroll:edit` (which every seeded manager role currently holds, so this removes access
  from all of them until the grant happens). The notification recipient resolver can now
  resolve "everyone holding `payroll-admin` at or above a level" as a target, ready for U5's
  flag notifications and U3/U4's void/remind actions to route through.
- **Kind:** vertical
- **Requirements covered:** REQ-01, REQ-02, REQ-03 — fully.
- **Depends on:** —

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | **None.** `N/A — no migration.` | Per *Findings from path verification* #1: a missing `payroll-admin` key in any existing role's stored `permissions` JSON already resolves to `'none'`, confirmed by reading `packages/shared/src/constants/permissions.ts:57,121-134` and the guard that calls the same function (`apps/api/src/guard/permissions.guard.ts:41-45`). `spec.md` §3 flagged this as unverified; it is now settled by the code, not by a migration. |
| Shared (`packages/shared`) | `packages/shared/src/constants/permissions.ts`: add `'payroll-admin'` to `PERMISSION_MODULES` (~line 23-54, alongside `'crane-supervisor'` at line 52) and to `USER_RESTRICTED_MODULES` (~line 88-96). | `PermissionModule` is a `readonly` array type — every consumer that switches on it exhaustively (if any) needs a look, but §11a row 1 confirms the known consumers already iterate it generically. |
| API (`apps/api`) | `apps/api/src/utility/seed-data.ts`: extend the `FULL_PERMISSIONS` reduce (lines 236-237) so `'payroll-admin'` is forced to `'none'` for every role exactly like `'crane-supervisor'` is today — one extra `\|\|` clause, not a new mechanism. `apps/api/src/usecase/notifications/recipient-resolver.service.ts`: add a `{ permission: { module: PermissionModule; minLevel: ModulePermissionLevel } }` member to the `RecipientSpec` union (lines 22-29) and a resolution branch reusing the JSON-path-on-permissions query pattern already at `apps/api/src/service/payroll-send-backs/payroll-send-backs.repository.ts:45-51` (`CRANE_SUPERVISOR_ROLE`), generalized to any `(module, minLevel)` pair via `LEVEL_RANK` (`packages/shared/src/constants/permissions.ts:61`). `apps/api/src/presentation/payroll/payroll.controller.ts`: change `@RequirePermission('payroll', 'edit')` to `@RequirePermission('payroll-admin', 'edit')` on the five routes confirmed at lines 139, 159, 193, 200, 218 (`exportEmployee`, `approveEmployee`, `approvePeriod`, `exportPeriod`, `exportCsv`). | **Do not touch** `sendBack` (line 170) or `searchSupervisors` (line 185) on the same controller — both stay `@RequirePermission('payroll', 'edit'/'view')`, untouched by this ticket. REQ-02's Notes for the executor: a portal `ADMIN`/`SUPER_ADMIN` bypass must not itself make someone a recipient — the new branch resolves only real `payroll-admin` grants, never the guard's bypass path. |
| Web (`apps/web`) | `apps/web/src/features/departments/constants/role-permissions.ts`: add `{ id: 'payroll-admin', title: '<NOT SPECIFIED — pick a label consistent with "Crane Supervisor — Returned Entries" at line 99>', icon: <pick a shield/dollar icon already imported> }` to `MODULE_PERMISSIONS` (lines 71-100), and add `'payroll-admin': 'none'` to **every** template's `overrides` in `TEMPLATE_PERMISSION_CONFIG` (lines 111-180+ — `manager`, `admin`, `editor`, `viewer`, `contributor`, and whatever templates follow `contributor` in the file) exactly the way `'crane-supervisor': 'none'` already appears in each. | `NOT SPECIFIED` whether the Approve/Export buttons themselves gain a client-side `usePermission().can('payroll-admin', 'edit')` guard — confirmed by grep that **no such guard exists today** for these two actions (`use-bulk-approve.ts`, `payroll-employee-daily.tsx`, the worklist action cells all call neither `usePermission` nor `can(`); the only two `can('payroll', ...)` call sites in the whole feature are unrelated job-detail cards). Building one would be new UI behavior with no source requiring it; leaving it out means the only feedback a narrowed-out user gets is the existing generic 403 toast. Flag this for the executor rather than deciding it — it is exactly the kind of screen-by-screen copy/layout decision `spec.md` §13 already says this spec does not make. |
| Mobile (`apps/mobile`) | None. | `N/A` — no source touches mobile for REQ-01–03. |
| Tests | **Unit (shared):** `payroll-admin` respects `LEVEL_RANK` ordering; a role with no `payroll-admin` key in its `permissions` JSON resolves to `'none'` via `resolveEffectiveLevel`. **Integration (API):** the five narrowed routes refuse (403) a role holding `payroll: 'edit'` but not `payroll-admin` — **including a `ROLE-ACCOUNTS-PM` (Payroll Manager) test employee before any grant is made**, per `spec.md` §10's own row; the same five succeed for a role explicitly granted `payroll-admin: 'edit'`/`'full'` via Departments; `sendBack`/`searchSupervisors` are unaffected (still gated on `payroll`). `recipient-resolver.service.spec.ts` (new): `resolve(tenantId, {permission:{module:'payroll-admin',minLevel:'view'}})` returns one entry per active user whose employee's `DepartmentRole.permissions` grants `payroll-admin` at `view` or above, and *not* a user whose grant is below `view`; the other six `RecipientSpec` branches are unaffected (regression — read the whole file, no existing test file for it exists to run, this is greenfield coverage of that service). | No existing automated test covers the Departments role editor's generic module iteration (§11a row 1) — none exists to point to; the regression proof there is manual (render the editor, confirm `payroll-admin` appears with no special-casing needed), noted honestly rather than invented. |

### Reviewable as

- **Demo:** `POST /api/v1/payroll/periods/:id/employees/:employeeId/approve` as a user holding
  only `payroll: 'edit'` (e.g. today's seeded Fleet Manager) → 403. Grant that role
  `payroll-admin: 'edit'` via `PATCH` on the Departments role editor → the same call → 200 (or
  whatever the underlying approve logic returns once permitted). `resolve(tenantId,
  {permission:{module:'payroll-admin',minLevel:'view'}})` called directly against the new
  branch → the granted role's users, and no one else.
- **Acceptance:** REQ-01, REQ-02, REQ-03 acceptance lines in `spec.md` §2.
- **Reviewer can verify without:** U2, U3, U4, U5; without any `PayrollFlag`, void, or
  incomplete-ticket data existing — this unit is pure permission plumbing plus a resolver
  variant.

### Risk

- **Weakest source:** `[UNVERIFIED]` across all three requirements — REQ-03's narrowing is
  sourced only to developer direction (build-plan item E1, now vaulted but not
  client-confirmed); REQ-01's mechanism is Q3's answer, same standing.
- **Migration reversible:** `N/A` — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no — additive constants only, confirmed no backfill needed (see
  *Findings* #1).
- **Blast radius:** **operational, immediate, and confirmed intended, not a defect.** The
  moment this unit ships to an existing tenant, **every seeded department role — including
  Payroll Manager's own — loses the ability to Approve, Export, void (U3), remind (U4), or
  review a flag (U5)** until a tenant admin grants `payroll-admin` by hand via Departments.
  The developer confirmed this directly (*"No, grant by hand"*, `spec.md` REQ-01 Sources).
  Portal `ADMIN`/`SUPER_ADMIN` users bypass the check entirely and are unaffected — one of
  them can perform the grant, or the gated actions themselves, immediately after deploy. This
  is not this unit's bug to fix; it is the rollout's job to carry as a release-notes /
  onboarding-checklist step (`spec.md` §11).

**`[UNVERIFIED]` + no migration is the routine case — no pre-build raise needed for the code
itself.** One thing still wants a name before this reaches a real tenant, carried from
`spec.md` rather than found here: **who performs the by-hand grant on each existing tenant,
and when** — `spec.md` §11 says explicitly nothing names this; it is a rollout-plan item, not
a blocker on U1's build.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Role editor / permission-map builders (`apps/api/src/utility/seed-data.ts`, `apps/api/src/usecase/permissions/permissions.service.ts`, `apps/web/src/features/departments/constants/role-permissions.ts`) | `PERMISSION_MODULES` array, iterated generically | **none — unbuilt, and honestly so.** No existing automated test exercises the Departments editor's generic module render; the check is manual (open the editor, confirm the new module renders without special-casing). | `spec.md` §11a row 1; `grep -rln "PERMISSION_MODULES" apps/api/src apps/web/src packages/shared/src` |
| Every seeded manager role's implicit access to `payroll` | `FULL_PERMISSIONS` default | covered by this unit's own integration test (every previously-`payroll:edit` role refused on the five routes) | `spec.md` §11a row 2 (resolved, Q3/E2) |
| Every seeded manager role's current Approve/Export access, **including Payroll Manager's own** | `payroll: 'edit'` via `FULL_PERMISSIONS`, on the five routes now re-gated | covered by this unit's own integration test — see Slice contents, Tests row | `spec.md` §11a row 3; `grep -n "managerRole(" apps/api/src/utility/seed-data.ts` (11 department manager roles) |

### Deliberately not in this unit

- **A client-side permission guard on the Approve/Export buttons** — `NOT SPECIFIED`; no
  source requires one and none exists today for these two specific actions. Flagged in Slice
  contents rather than built or deferred to a named unit, since it is a UI-copy/layout
  decision `spec.md` §13 leaves open, not a functional gap this ticket creates.
- **Who performs the by-hand grant on each existing tenant, and when** — a rollout-plan item
  (`spec.md` §11), not a unit.

---

## U2 — PAY-045 rest-gap engine change and the rest-audit UI

- **Outcome:** Payroll's 8-hour rest premium now starts counting from the rounded, paid end
  of the prior work chain — not the raw entry end — extended by 30 minutes for each
  worked-through-lunch penalty from the 2nd missed meal on that chain, **cumulatively** (2nd
  +30, 3rd +60, 4th +90…). A first missed meal does not move it at all. The payroll
  rest-audit screen displays that computed start, not just the raw end time it showed before.
- **Kind:** vertical
- **Requirements covered:** REQ-04, REQ-05 — fully.
- **Depends on:** — (developable and mergeable independently of every other unit; touches no
  file any other unit touches)

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | None. | `N/A` — pricing-only change, no new persisted field is required by any source (REQ-05's Notes: whether a `PayrollJobDay.rest_started_at` column is persisted vs. documented as "measured from" is `NOT SPECIFIED` — build without one; nothing downstream needs it stored). |
| Engine (`packages/payroll-engine`) | `packages/payroll-engine/src/rest-period.ts`: `applyRestPeriodPremium` (`:125`) gains a pre-pass, before pricing a chain's gap, that counts that chain's worked-through-meal penalties (2nd on) and extends the gap start by `30 × (count − 1) minutes` when count ≥ 1 (i.e. 2nd meal alone → +30; 2nd and 3rd → +60). `RestEntry` (`:42`) — confirm whether the meal-penalty count needs to be added to its shape or can be derived from what it already carries; check the type before assuming a new field. `toWorkChains` (`:98`) and `REST_STITCH_MINUTES` (`:6,29`) are **unchanged** — this touches only where an already-formed chain's gap starts. `packages/payroll-engine/src/explain.ts` — mirror the change so the explain output for a chain with a WTL-moved gap start reflects it; existing convention per the codebase (no source names a specific line, since `explain.ts` does not currently mention "rest" at all by string search — read the file before assuming where the hook point is, rather than guessing at a location this note did not verify). | `calculate.ts:745` calls `applyRestPeriodPremium(restEntries)` — rest (step 3) is priced **before** meals (step 6) in the six-step pipeline (Brian Petros's order-of-operations note, per `spec.md`), so the pre-pass must count meal penalties **without** reordering those steps; it needs to look ahead at meal data the meals step has not priced yet, not re-run pricing. |
| API (`apps/api`) | Whatever the engine returns for the moved gap start needs to reach the API's payroll response for the rest-audit view — `NOT SPECIFIED` beyond "the new gap start is visible somewhere payroll already looks at rest" (REQ-05 Acceptance). Locate wherever the engine's `RestEntryOutcome` (`rest-period.ts:55`) currently flows into the API response for `apps/web/src/features/payroll/components/payroll-rest-audit.tsx` and thread the new value through the same path — no new endpoint. | REQ-05's surface line lists `api` explicitly ("whatever REQ-04 persists or returns for display"); confirm the exact response shape by tracing that existing path rather than inventing a new field name. |
| Web (`apps/web`) | `apps/web/src/features/payroll/components/payroll-rest-audit.tsx` (confirmed to exist): display the new gap-start value. `NOT SPECIFIED` — exact copy, layout, and whether the WTL extension shows as its own line item vs. folded into one timestamp (REQ-05 Acceptance). | `grep -rn "restGapHours\|gapHours" apps/web/src apps/api/src --include=*.ts --include=*.tsx` returns only the engine and this one component today — confirmed, no other consumer to reconcile. |
| Mobile (`apps/mobile`) | None. | `N/A` — not in REQ-04/05's surface list. |
| Tests | **Unit (engine, `rest-period.spec.ts`, existing file, add cases):** worked to 11:00 PM + 2nd-meal WTL penalty → gap starts 11:30 PM (the decision's own worked example); a first missed meal only → gap start unchanged; 2nd **and** 3rd missed meals on the same chain → gap start moves a cumulative 60 minutes (30 + 30), not 30. **Do not reorder or touch `toWorkChains`/`REST_STITCH_MINUTES` tests already in this file** — this unit's cases are additive. **Integration (API):** the rest-audit response carries the moved gap start for a chain with a 2nd-meal WTL penalty, and the unmoved raw end for a chain without one. | `spec.md` §10 row 1 (unit), and REQ-05's own testability note: "REQ-05 has no testable acceptance criterion beyond the above — copy/layout `NOT SPECIFIED`." |

### Reviewable as

- **Demo:** run `pnpm --filter @tcg/payroll-engine exec node --experimental-strip-types
  --test src/rest-period.spec.ts` against the three new cases above. Separately, view the
  rest-audit screen for a period containing a chain with a 2nd-meal WTL penalty and confirm
  the displayed gap start is the moved value, not the raw entry end.
- **Acceptance:** REQ-04, REQ-05 acceptance lines in `spec.md` §2 — REQ-04's is exact
  (11:00 PM → 11:30 PM given the decision's own worked example; cumulative 60 minutes given
  a 2nd + 3rd missed meal).
- **Reviewer can verify without:** U1, U3, U4, U5; without any `payroll-admin` grant, any
  voided ticket, or any flag existing — this unit is pure pricing-and-display, independent of
  everything else in the ticket.

### Risk

- **Weakest source:** `[UNVERIFIED]`, and unusually specific about *which part*: the base
  rule (2nd missed meal moves the gap start; 1st does not) rests on Corrina Bustos's own
  words, three separate times, verified — but a requirement's flag takes the *worst* of its
  sources, and the **cumulative 3rd+ extension is sourced only to developer direction**,
  reasoned by analogy to PAY-047, explicitly **pending Corrina Bustos / Brian Petros
  ratification because it changes pay** (`spec.md` REQ-04's own banner and Conflict field).
  Brian Petros has also never confirmed the base rule's WTL-affects-rest-start premise
  itself, and the 2026-09-25 union business-agent meeting Corrina cites is not in the vault.
- **Migration reversible:** `N/A` — no migration.
- **Behind a flag:** no.
- **Touches existing data:** **no rows are written**, but this changes the *priced output*
  for every existing pay run that gets recalculated with a chain carrying a 2nd+ missed-meal
  WTL penalty — a behavior change to a live pricing path, not a data migration.
- **Blast radius:** every future Calculate run on any period with a qualifying chain prices
  differently than it did before this unit. `spec.md` §11a row 4 is explicit this is
  deliberate, not incidental.

**`[UNVERIFIED]` + a pay-pricing change on a live path — this is the one place in the whole
ticket the ratification gap is worth restating plainly, per `.ai/claude/contexts/payroll-engine.md`'s own rule ("no pay-rule change without its source in
`payroll-rules-provenance.md`, same commit").** The base rule is well-corroborated (three
verified statements) and safe to build now. **The cumulative 3rd+ extension is not** — it is
one developer's reading of a question Corrina Bustos was never asked, and `spec.md`
explicitly requires the `payroll-rules-provenance.md` row to say so, distinctly from the base
rule's "Confirmed" status, **in the same commit as the engine change** (REQ-04 Notes for the
executor). This is a build instruction, not a reason to hold the unit — but skipping the
provenance-row distinction would let the cumulative rule read as equally confirmed when it
is not, which is exactly the kind of drift `payroll-rules-provenance.md` exists to prevent.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `packages/payroll-engine` rest-premium pricing for every existing pay run | `applyRestPeriodPremium` / `RestEntry` (`rest-period.ts`) | this unit's own new unit tests in `rest-period.spec.ts`, run alongside the file's existing cases (not reordered, not removed) — the existing chain-stitching tests are the regression proof that `toWorkChains`/`REST_STITCH_MINUTES` are untouched | `spec.md` §11a row 4; `grep -n "applyRestPeriodPremium\|interface RestEntry" packages/payroll-engine/src/rest-period.ts` |
| `apps/web/src/features/payroll/components/payroll-rest-audit.tsx` | direct component reuse | new display of the moved value — no automated web test exists for this component today (none found under `apps/web/src/features/payroll` matching `rest-audit`); manual verification per REQ-05's own `NOT SPECIFIED` copy/layout | `spec.md` §11a implies via REQ-05; `grep -rn "restGapHours\|gapHours" apps/web/src apps/api/src` (no other consumer) |

### Deliberately not in this unit

- **Persisting a `rest_started_at` column** — `NOT SPECIFIED` whether needed at all (REQ-05
  Notes); build without one unless the API-layer trace in Slice contents finds a reason it is
  required to thread the value through.
- **Reordering the six-step pricing pipeline** — explicitly not this unit's job; rest is
  priced before meals today and that order does not change (REQ-04 Ripple).
- **Ratifying the cumulative 3rd+ rule with Corrina Bustos / Brian Petros** — not this unit's
  or this decomposition's job; `close-ticket`/`tcg-scrum` territory. The unit ships with the
  provenance row correctly distinguishing "confirmed" from "developer direction, pending
  ratification," which is the build-time obligation, not the ratification itself.

---

## U3 — Void a never-completed ticket

- **Outcome:** A Payroll Admin or Payroll Manager can void a job ticket that never completed
  and is still `PENDING`, `SENT` or `IN_PROGRESS` (never a `REJECTED` one), with a required
  note. The ticket becomes `CANCELLED`, recording who/when/why; it has no billing effect and
  is removed from payroll only; and — with this unit's own new test proving it, not just
  trusted from existing behavior — a voided ticket drops off the crew's active mobile list
  with an in-app and email notice.
- **Kind:** vertical
- **Requirements covered:** REQ-06 — fully.
- **Depends on:** U1 (the void endpoint is `@RequirePermission('payroll-admin', 'edit')`,
  which does not resolve to anyone until U1 ships).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `JobTicket` (model at `apps/api/prisma/schema.prisma:4641`) gains `payrollClosedAction PayrollTicketClosure?`, `payrollClosedAt DateTime? @db.Timestamptz()`, `payrollClosedByUserId String? @db.Uuid`, `payrollCloseNote String? @db.Text`. New enum `PayrollTicketClosure { VOIDED COMPLETED }` — **this unit builds and uses `VOIDED` only**; `COMPLETED` is pre-included per `spec.md` §3 so a later ticket (U10, out of scope here) needs no enum migration, but nothing in this unit ever sets it. Migration `apps/api/prisma/migrations/<YYYYMMDDHHMMSS>_payroll_ticket_void/migration.sql` (timestamp format confirmed against the branch's existing migrations, e.g. `20260928190000_...`) — purely additive, four nullable columns plus a new enum, no backfill, no data touched. | `PayrollTicketClosure` is a genuinely one-way commitment in the sense that other code will start depending on the `VOIDED` member the moment this ships — routine for an additive enum, not a reason to hold the unit. |
| API (`apps/api`) | `apps/api/src/presentation/payroll/dto/void-ticket.dto.ts` (new, alongside the existing `send-back.dto.ts` in the same folder): `{ note: string }`, `@IsNotEmpty()`. `apps/api/src/presentation/payroll/payroll.controller.ts`: new `POST periods/:id/tickets/:ticketId/void`, `@RequirePermission('payroll-admin', 'edit')`. `apps/api/src/usecase/payroll/payroll.service.ts`: new `voidTicket(periodId, ticketId, note, userId)` — refuse (409 or 400, `NOT SPECIFIED` which; pick one and be consistent with the review/incomplete-ticket errors U4/U5 add) any ticket whose status is not one of `{PENDING, SENT, IN_PROGRESS}` — **do not reuse `WEEK_OVERLAY_TICKET_STATUSES` (`apps/api/src/service/payroll/payroll.repository.ts:259-263`) verbatim**, since that constant includes `REJECTED` for *display* purposes and this action must refuse a `REJECTED` ticket (per Q6). Define a distinct, narrower constant. Use a conditional status-update guard matching `submitTicket`'s own pattern (`apps/api/src/usecase/job-tickets/job-tickets.service.ts:1028-1032`, which already refuses `CANCELLED`/`REJECTED` before allowing a transition) rather than inventing a new check style. On success: set `status: CANCELLED`, the four new columns, and write the audit trail via the **existing** convention — `JobTicketActivityLogger.logStatusChange(tenantCompanyId, ticket.id, { status: { before, after: 'CANCELLED' } }, userId, { note })` (`apps/api/src/usecase/activity-logs/entity-activity-logger.ts:59-75`, injected per-entity-type as `JobTicketActivityLogger` in `apps/api/src/usecase/activity-logs/domain-activity-loggers.ts`) — `JOB_TICKET`/`STATUS_CHANGED` are **existing** `ActivityLogEntityType`/`ActivityLogAction` members (`schema.prisma:104-130`), so **no enum migration is needed for the audit trail** — this is the "existing convention" REQ-06's own Notes for the executor point at, now identified precisely rather than left as a pointer. Dispatch `payroll.ticket_voided` (new `NotificationType`, `IN_APP` + `EMAIL`, per Q4/Q5) to the ticket's roster via `NotificationService.notify` (`apps/api/src/usecase/notifications/notification.service.ts:50`), following the exact call shape already used for `payroll.entry_sent_back` in `apps/api/src/usecase/payroll-send-backs/payroll-send-backs.service.ts:643-665`. | **The void action has no billing/invoicing side effect and must not gain one** (Q5) — do not add a call into any billing/invoicing service. |
| Shared (`packages/shared`) | `packages/shared/src/types/notification.types.ts`: add `'payroll.ticket_voided'` to `NOTIFICATION_TYPES` (after `'payroll.entry_corrected'`, line ~44). `apps/api/src/usecase/notifications/notification-catalog.ts`: new catalog entry, `defaultChannels: ['IN_APP', 'EMAIL']`, a `render` function following the `'payroll.entry_sent_back'` entry's shape (`:414-426`) — new template function alongside `renderPayrollEntrySentBack` (`apps/api/src/usecase/notifications/templates/notification-templates.ts`, with a dedicated layout file if the existing `payroll-send-back-email-layout.ts` pattern is followed). | Register the catalog entry **and** the shared `NotificationType` string in the same commit — the guard mechanism (`getCatalogEntry`) throws on an unregistered type. |
| Web (`apps/web`) | A Void action (button + note dialog) on the incomplete-ticket surface — the plan's proposed location is wherever `PayrollIncompleteBanner` (`apps/web/src/features/payroll/components/payroll-employee-daily.tsx:97`) renders, since U4's blocking-banner work is the natural place a Void affordance belongs; **`NOT SPECIFIED`** whether U3 alone should surface it before U4's blocking banner exists, or whether it is reasonable for U3 to expose Void from a narrower surface (e.g. directly on the ticket row) until U4 lands. Build to whatever is reachable today without waiting on U4's banner rework — a modal/dialog reachable from the existing ticket list is enough to satisfy REQ-06 standing alone, and it is superseded, not duplicated, once U4's banner ships. react-hook-form + Zod for the note field, per convention; new `data-testid`s for the Void button and the note dialog's confirm/cancel controls, per `.ai/claude/contexts/web.md` → *Test IDs*. | This is the one place in U3 where the developer's five-units-one-branch ordering (U3 before U4) creates a real sequencing question for the *web* surface specifically — flagged here rather than assumed either way. |
| Mobile (`apps/mobile`) | No new screen (§6, confirmed). `apps/mobile/data/hooks/use-tickets.ts` `partitionDashboardTickets` — **per *Findings from path verification* #2, this function does not itself filter `CANCELLED`/`REJECTED`.** No source asks this unit to change it, and REQ-06's own text treats the drop-off as already-true existing behavior — so this unit does **not** change `partitionDashboardTickets`. What it *does* need is the regression test below, because "already true" turned out to be conditional (true for a past-scheduled ticket, not proven for a same-day one) and REQ-06's acceptance depends on it being true. | If the new test in the Tests row below fails for a same-day voided ticket, that is a finding for `spec.md` §12 or a follow-up unit — **not** something to silently patch inside U3 by editing `partitionDashboardTickets`, since no source in this spec asks for that function to change and doing so would be adding a requirement the spec never made. |
| Tests | **Integration (API):** void refuses a `COMPLETE` ticket and, per Q6, a `REJECTED` one; succeeds on each of `PENDING`/`SENT`/`IN_PROGRESS`; on success the ticket is `CANCELLED`, the four columns are set, a `JobTicketActivityLogger` `STATUS_CHANGED` entry exists naming the note; `payroll.ticket_voided` is dispatched `IN_APP` + `EMAIL` to the ticket's roster; no billing/invoicing call occurs (assert the mock/service is never invoked). **Regression (mobile, new — this is the row *Findings* #2 requires):** given a `CANCELLED` ticket with `scheduleDate` in the past, `partitionDashboardTickets` excludes it from all three partitions (existing behavior, now asserted rather than assumed); given a `CANCELLED` ticket with `scheduleDate === today`, assert what `partitionDashboardTickets` **actually** returns — if it lands in `activeTickets` as the code reading above predicts, that is not this unit's bug to silently fix; it is the finding to hand to whoever owns the next spec revision. **Web:** Void dialog refuses submission without a note; a successful void removes/updates the ticket's row in whatever list is showing it. | New API spec file, e.g. `apps/api/src/usecase/payroll/payroll-void-ticket.spec.ts` or appended to `payroll.service.spec.ts` (existing file). New mobile test file/case in or beside `apps/mobile/data/hooks/use-tickets.ts`'s existing test coverage — confirm whether one already exists before adding a new file (none was found by this decomposition's search; verify before assuming). |

### Reviewable as

- **Demo:** `POST /api/v1/payroll/periods/:id/tickets/:ticketId/void {note}` on a `PENDING`
  ticket as a `payroll-admin: edit` holder → 200, ticket now `CANCELLED`. The same call on a
  `REJECTED` ticket → refused. `GET` the ticket's activity log → a `STATUS_CHANGED` entry
  naming the note. The ticket's roster receives an in-app notification and an email.
- **Acceptance:** REQ-06 acceptance lines in `spec.md` §2, including the Q6 exclusion of
  `REJECTED`.
- **Reviewer can verify without:** U2, U4, U5; **not** without U1 — the endpoint has no
  permission holder until U1's `payroll-admin` module exists and something is granted it.

### Risk

- **Weakest source:** `[UNVERIFIED]` — the *existence* of an escape path is verified as a
  problem statement (Corrina's own words identify the gap), but *who may void it* and the
  no-billing-effect answer are both developer direction, `[UNVERIFIED]`, explicitly **never
  asked of billing, dispatch, or anyone who owns either** (`spec.md` REQ-06 Sources, item C8's
  own text: *"Nobody has asked either of them."*).
- **Migration reversible:** yes — four new nullable columns, one new additive enum, no drops,
  no backfill.
- **Behind a flag:** no.
- **Touches existing data:** no — the migration writes nothing; the *action* writes to
  existing `JobTicket` rows only when a Payroll Admin/Manager explicitly chooses to void one.
- **Blast radius:** a wrongly-voided ticket is silent to billing/dispatch by design (Q5) —
  which is the risk, not a bug: **nobody there has been told this action exists.**

**`[UNVERIFIED]` + reversible migration — the migration itself needs no pre-build raise.**
Two things do, both already named in `spec.md` and neither blocking this unit:

1. **Billing/dispatch have never been asked whether a voided ticket matters to them** — the
   underlying decision note says so in its own words. This is a `tcg-scrum` follow-up, not a
   reason to hold U3.
2. **The mobile drop-off claim needed verification, not trust** (*Findings* #2) — now covered
   by this unit's own new regression test rather than left as an assumed-true ripple row.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `apps/mobile` active ticket dashboard partition | `partitionDashboardTickets` (`use-tickets.ts:45-81`) | **new test, both branches** — past-scheduled `CANCELLED` (expected: dropped, existing behavior) and same-day `CANCELLED` (expected: unverified by `spec.md`, asserted here to find out) | `spec.md` §11a row 5, corrected by *Findings from path verification* #2 above — the spec's claim that this "already" drops the ticket is not fully supported by reading the function; this unit closes that gap with a test rather than repeating the untested claim |
| `apps/api` job-tickets activity log | `JobTicketActivityLogger.logStatusChange`, existing `JOB_TICKET`/`STATUS_CHANGED` enum members | this unit's own integration test asserts the log entry | `apps/api/src/usecase/activity-logs/entity-activity-logger.ts:59-75`; `schema.prisma:104-130` (code, read directly — not cited by `spec.md`, which left this as a pointer to "existing convention") |

### Deliberately not in this unit

- **Any billing/invoicing integration** — explicitly none, per Q5, and not this unit's call to
  add even defensively.
- **Changing `partitionDashboardTickets` to explicitly filter `CANCELLED`/`REJECTED`** — no
  source asks for this. If this unit's new same-day test fails, that is a finding to raise
  (`spec.md` §12 or a follow-up), not a fix to make unasked inside U3.
- **The `COMPLETED` half of `PayrollTicketClosure`** — U10, out of scope (`spec.md` §13). The
  enum member exists on the branch after this unit merges; nothing sets it.

---

## U4 — Incomplete-ticket approval gate and Remind

- **Outcome:** Approve (per employee or per period) is refused while any ticket in the
  employee's **start-ticket week** (Pacific) is still `PENDING`, `SENT` or `IN_PROGRESS` —
  never a `REJECTED` one. Calculate is unaffected. Payroll can send that ticket's primary
  worker a real reminder (in-app, push, email), replacing today's disabled stub.
- **Kind:** vertical
- **Requirements covered:** REQ-07, REQ-08 — fully.
- **Depends on:** U3 (voiding, U3's own action, is the escape path REQ-07's gate needs —
  without it, an incomplete ticket the crew cannot fix has no way out of blocking Approve;
  REQ-08's Remind is gated `payroll-admin`, same as U3's void).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | None. | `N/A` — both requirements are query/notification logic over existing tables. |
| API (`apps/api`) | `apps/api/src/usecase/payroll/payroll.service.ts`: new `assertNoIncompleteTickets(period, employeeIds \| null)`, built on `findWeekOverlayTickets` (`apps/api/src/service/payroll/payroll.repository.ts:530`) + `buildWeekEntry` (`apps/api/src/usecase/payroll/payroll-week-overlay.ts:108`), mirroring `assertNoOpenSendBacks`'s existing signature (`payroll.service.ts:821`) and called from both `approveEmployee` (`:855`) and `approvePeriod` (`:892`), all-or-nothing for the period. **Filter out `REJECTED` rows** from whatever `findWeekOverlayTickets` returns before treating the remainder as incomplete — per Q6, that constant's set is broader (display-purpose) than what blocks Approve. **No change to `findWeekOverlayTickets`'s date-range resolution** — Q7 confirms the existing start-ticket-week/Pacific logic is already the right rule, reused as-is. New `void-ticket.dto.ts`-adjacent `remind-ticket.dto.ts`? — **not needed**, Remind takes no body. `apps/api/src/presentation/payroll/payroll.controller.ts`: new `POST periods/:id/tickets/:ticketId/remind`, `@RequirePermission('payroll-admin', 'edit')`, pushing to the ticket's primary employee via `TicketEmployee.isPrimary` (confirmed at `schema.prisma:4714`) — single on-demand send, no repeat. `apps/api/src/usecase/payroll/payroll-approval-gate.ts`: extend the `PAYROLL_APPROVAL_BLOCKED_CODE` (`:19`) error body with an `incompleteTickets[]` case alongside whatever `blockingIssuesForWeek` (`:58`) already returns for send-backs. | `assertNoIncompleteTickets` must run **after** `assertNoOpenSendBacks` in whatever order the executor finds cleanest — `NOT SPECIFIED` by any source, per REQ-11's note this composes with U5's flag gate too, eventually, in unspecified order. |
| Shared (`packages/shared`) | `NOTIFICATION_TYPES` gains `'payroll.ticket_incomplete_reminder'`, delivered `IN_APP` + `PUSH` + `EMAIL` to the worker (distinct channel set from U3's void notice, which is `IN_APP` + `EMAIL` only — do not conflate the two). New `notification-catalog.ts` entry, `defaultChannels: ['IN_APP', 'PUSH', 'EMAIL']`, following the `'das.job_ticket_completed'` entry's shape (`notification-catalog.ts:406-413`), which already uses that exact three-channel set. | |
| Web (`apps/web`) | `apps/web/src/features/payroll/components/payroll-employee-daily.tsx`: `PayrollIncompleteBanner` (`:97`, confirmed) changes from "warns, never blocks" to a blocking banner that disables Approve and offers **Void** (U3's action, surfaced here per U3's Slice contents note) and **Remind**. `apps/web/src/features/payroll/hooks/use-payroll-employee.ts:300`: wire the existing disabled `remind: () => toast.info(...)` stub to the new endpoint. `apps/web/src/features/payroll/approval-blocked-error.ts` and `apps/web/src/features/payroll/hooks/use-bulk-approve.ts`: extend the `PAYROLL_APPROVAL_BLOCKED` body parsing to handle the new `incompleteTickets[]` case, alongside the existing send-back case. New `data-testid`s on the Remind control and the blocking banner's Void/Remind affordances. | This is where U3's Void action, if it was built against a narrower surface in U3 (per U3's own Slice contents note), gets its permanent home inside the blocking banner — confirm at build time whether U3's dialog can be reused here directly or needs relocating. |
| Mobile (`apps/mobile`) | None beyond receiving the new notification through existing channels — no new screen. | `N/A — wires an existing disabled stub to a new endpoint and delivers through existing notification infrastructure` (`spec.md` REQ-08 Ripple). |
| Tests | **Integration (API):** `approveEmployee`/`approvePeriod` refuse on an incomplete ticket (`PENDING`/`SENT`/`IN_PROGRESS`) in the employee's start-ticket week; a `REJECTED` ticket in the same week does **not** trigger the refusal; a voided (`CANCELLED`, via U3) ticket does not either; Calculate succeeds regardless and returns the overlay unchanged. Remind sends `IN_APP` + `PUSH` + `EMAIL` to the ticket's primary worker (`TicketEmployee.isPrimary`), a single send with no repeat. **Web:** the blocking banner disables Approve when an incomplete ticket exists and offers Void/Remind; `approval-blocked-error.ts` correctly surfaces `incompleteTickets[]` alongside an existing send-back block, both present at once. | `spec.md` §10 rows for REQ-07, REQ-11 (the "refuse on incomplete, an open flag, both, or neither" row is shared with U5 — U4 only builds the incomplete-ticket half; the "both" case is not testable until U5 exists) and REQ-08. |

### Reviewable as

- **Demo:** an employee-week with a `SENT` ticket → `approveEmployee` refused,
  `incompleteTickets[]` names it. The same week's `calculate` → succeeds, shows the ticket as
  it does today. Void it (U3) → the same `approveEmployee` call now succeeds (nothing else in
  the week blocking). `POST .../remind` on an incomplete ticket → the primary worker's
  in-app/push/email all fire.
- **Acceptance:** REQ-07, REQ-08 acceptance lines in `spec.md` §2.
- **Reviewer can verify without:** U2, U5; **not** without U3 — Void is the gate's only
  escape path this ticket builds, and the demo above needs it to show the gate lifting.

### Risk

- **Weakest source:** `[UNVERIFIED]` — REQ-07's blocking-vs-warning distinction is Corrina
  Bustos's own verified words ("all tickets must be completed"), but *which action* it blocks
  (Approve only, not Calculate) is the developer's reading of that word ("processed"),
  `[UNVERIFIED]`, not her own statement. REQ-08 rests entirely on the plan's stated goal plus
  a blanket "work on all U1 to U5" approval — thin, but nothing contradicts it.
- **Migration reversible:** `N/A` — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no — a query-time gate and a notification send, nothing written
  beyond the existing notification/activity infrastructure.
- **Blast radius:** every existing tenant's Approve flow now refuses on tickets it silently
  allowed through before (the banner "warned, never blocked"). This is deliberate (§11a row 6)
  and is the reason U3's Void action has to exist first — without it, this unit would ship a
  gate with no way through for a ticket nobody can complete anymore (e.g. the crew has moved
  on, the job is gone).

**`[UNVERIFIED]` + a behavior change with no migration — routine, no pre-build raise.** One
thing worth naming for whoever ships this to a real tenant: **on day one, every currently
open `PENDING`/`SENT`/`IN_PROGRESS` ticket across every tenant becomes a live Approve
blocker** the moment this unit ships — there is no grace period or backfill window in any
source. That is a rollout-communication item, not a build defect.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `PayrollIncompleteBanner` (`payroll-employee-daily.tsx:97`) | direct component reuse | this unit's own web test — banner now blocks and offers Void/Remind, asserted directly | `spec.md` §11a row 6 |
| `use-bulk-approve.ts` / `approval-blocked-error.ts` parsing of `PAYROLL_APPROVAL_BLOCKED` | shared error-body shape | this unit's own web test — `incompleteTickets[]` parsed alongside an existing send-back block in the same response | `spec.md` §11a row 7 |

### Deliberately not in this unit

- **The `openFlags[]` composition with U5's flag gate** — U5 has not shipped yet in build
  order; `PAYROLL_APPROVAL_BLOCKED`'s body is extended again in U5, additively, not built here
  in anticipation.
- **Repeating the reminder automatically (3-hour cadence)** — that is the separate Send Back
  flow's U12 mechanic, explicitly not this action, per REQ-08's own correction banner in
  `spec.md`.
- **Backfilling or grace-period logic for tickets already incomplete before this ships** — no
  source describes one; the gate applies immediately to whatever is open.

---

## U5 — Durable payroll flags: schema, `OVERLAPPING_JOBS`, unconditional gate, review, routing, web

- **Outcome:** Calculate now writes durable, per-period flags to their own table rather than
  computing them at read time — starting with one detector, `OVERLAPPING_JOBS` (two of an
  employee's tickets whose raw Start Ticket→End Ticket windows overlap). Any `OPEN` flag
  refuses approval unconditionally, with no per-tenant override. A Payroll Admin/Manager can
  mark a flag "reviewed, no change" with a required, audited note, which holds until the
  underlying values change. Every new or reopened flag notifies Payroll Admin/Manager holders
  in-app and by email. The payroll web app surfaces all of it: a flags panel, timesheet
  chips, a worklist KPI/filter, the review dialog, the audit log, and a sidebar count.
- **Kind:** vertical
- **Requirements covered:** REQ-09, REQ-10, REQ-11, REQ-12, REQ-13, REQ-14 — fully.
- **Depends on:** U1 (every new route is `payroll-admin`-gated; REQ-13 routes through U1's
  recipient-resolver `{permission:...}` variant).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | New `PayrollFlag` and `PayrollFlagEvent` models plus `PayrollFlagStatus` (`OPEN`/`FIXED`/`REVIEWED_NO_CHANGE`) and `PayrollFlagEventAction` (`RAISED`/`REOPENED`/`FIXED`/`REVIEWED_NO_CHANGE`) enums, exactly as specified in `spec.md` §3's Prisma block. **No business code, no per-tenant prefix** — follows the `PayrollSendBack` precedent (`schema.prisma:5337`, confirmed: UUID `id` only, no `@@unique([tenantCompanyId, <code>])`), explicitly flagged by `spec.md` as a deliberate deviation from the Identity Convention's default, not an oversight. `apps/api/src/orm/prisma.service.ts`: add `payrollflag`/`payrollflagevent` to the `$extends` tenant-scoping allowlist (same block already holding `payrollsendback` at line 130 and `payrollissue` at line 164) — **do this in the same commit as the migration**, `tcg-prisma-guardian`'s own standing concern on every new tenant-scoped model. Migration `apps/api/prisma/migrations/<YYYYMMDDHHMMSS>_payroll_flags/migration.sql` — purely additive, two new tables, two new enums, no backfill. | **No `ActivityLogEntityType` member is added for flags** — `PayrollFlagEvent` is this feature's own audit trail (REQ-09's own Notes), following `PayrollSendBack`'s self-contained-JSON precedent rather than the tenant-wide `ActivityLog` U3 uses for void. Two different audit mechanisms in the same ticket, for two different requirements — do not unify them without a source asking for it. |
| API (`apps/api`) | New `apps/api/src/presentation/payroll-flags/payroll-flags.controller.ts` (+ `dto/review-flag.dto.ts {note: string}`, `@IsNotEmpty()`) — **`@Controller({ path: 'payroll', version: '1' })`, the same path prefix as `PayrollController`, not a separate `payroll-flags` prefix** (confirmed: NestJS allows two controller classes sharing one path prefix; the spec's own routes — `GET periods/:id/flags`, `GET flags/:flagId`, `POST flags/:flagId/review` — only resolve under `/v1/payroll/...`, not under a `/v1/payroll-flags/...` prefix a naive read of the file name might suggest). New `apps/api/src/usecase/payroll-flags/` — `payroll-flags.module.ts`, `payroll-flag-detection.service.ts` (the `OVERLAPPING_JOBS` detector, mirroring `flagOverlappingLabor`'s raw-window basis and back-to-back exclusion exactly, `packages/payroll-engine` is **not** touched — this detector is API-side, over persisted job-ticket data, not the engine's in-memory labor check), `payroll-flags.service.ts` (list/detail/review, fingerprint-based reconciliation). New `apps/api/src/service/payroll-flags/payroll-flags.repository.ts`. Hook the detection pass onto the end of `executeRun` (`apps/api/src/usecase/payroll/payroll.service.ts:377`, confirmed) — after the run's figures are committed, matching where REQ-04's rest pricing already runs inside the same method; reconcile by `(tenantCompanyId, periodId, code, employeeId, subjectKey)` fingerprint per REQ-09's Acceptance (same-condition reruns do not duplicate; a disappeared condition auto-`FIXED`s; a changed fingerprint on a `REVIEWED_NO_CHANGE` flag reopens it). `apps/api/src/usecase/payroll/payroll-approval-gate.ts`: extend `blockingIssuesForWeek` (`:58`)/the `PAYROLL_APPROVAL_BLOCKED` body with an `openFlags[]` case — **do not** add flag codes to `PayrollIssue`/`payroll_approval_blocking_issues` (`schema.prisma:5570`), a deliberately separate, per-tenant-editable mechanism this requirement does not extend (REQ-11's own Notes). Register `PayrollFlagsModule` in `app.module.ts`. | `PayrollFlag.detail`/`.message` shape is `NOT SPECIFIED` beyond "human-readable text plus structured detail" — build the minimum `OVERLAPPING_JOBS` needs (both ticket ids), not a speculative general shape for flags this ticket does not build (U6+). |
| Shared (`packages/shared`) | `NOTIFICATION_TYPES` gains `'payroll.flags_raised'`, `IN_APP` + `EMAIL` (Q4). New `PAYROLL_FLAG_CATALOG` constant (`packages/shared/src/constants/payroll-flags.ts`) — per-code title/subject lookup, built for `OVERLAPPING_JOBS` only; shape `NOT SPECIFIED` beyond "some shared lookup by code" (spec's own framing) — do not pre-build entries for U6+ flags that do not exist yet. `apps/api/src/usecase/notifications/notification-catalog.ts`: new `'payroll.flags_raised'` entry, `defaultChannels: ['IN_APP', 'EMAIL']`, counts of new/reopened flags in its context, once per Calculate run — routed via U1's `{permission:{module:'payroll-admin',minLevel:'view'}}` recipient spec, not a hardcoded role. | |
| Web (`apps/web`) | New `apps/web/src/features/payroll-flags/` feature folder (separate from `apps/web/src/features/payroll/`, per the plan's own proposed layout) — a flags panel on the employee payroll page, flag chips in the timesheet, a review dialog (REQ-12's required-note form), an audit-events list. `apps/web/src/features/payroll/components/payroll-employee-table.cells.tsx`, `payroll-worklist-kpis.tsx`, `payroll-worklist-filters.tsx`: an "Open flags" KPI and filter facet alongside the existing `EmployeeStatusChip` union (`NEEDS_REVIEW`/`FLAGGED`/`APPROVED`/`SENT_BACK`, confirmed a **web-local** type at `payroll-worklist-filters.tsx:13`, distinct from the shared `PayrollEmployeeWeekStatus` enum). Reuse `PageHero`, `SectionCard`, `WorkspaceTable` per standing convention. Relabel `PayrollEmployeeWeekStatus.FLAGGED`'s **display copy only** to "Rate issue" wherever it renders (`payroll-worklist-filters.tsx`, `payroll-employee-table.tsx`, `payroll-format.ts` — the enum value itself is unchanged, per REQ-09's ripple note). New `data-testid`s throughout, per `.ai/claude/contexts/web.md` → *Test IDs*. | **Naming collision risk, confirmed by reading the code (*Findings* #3): `apps/web/src/features/payroll/components/job-payroll-flags-card.tsx` (`JobPayrollFlagsCard`) is a live, unrelated feature — job-level pay premiums, nothing to do with this unit's `PayrollFlag` review entity.** Keep this unit's naming precise — `PayrollFlag`/`PayrollFlagEvent`/the `payroll-flags` route prefix/the new feature folder — and do not let UI copy or a variable name collapse the two "flags" concepts into one. The sidebar count (per Payroll Admin/Manager holder) is new navigation chrome — confirm where nav badge counts already live in the app (e.g. an existing unread-notifications count pattern) before inventing a new mechanism. |
| Mobile (`apps/mobile`) | None. | `N/A` — REQ-14's surface is `web` only. |
| Tests | **Unit (API):** flag reconciliation — same fingerprint across two runs does not duplicate the flag or its history; a disappeared condition auto-`FIXED`s; a `REVIEWED_NO_CHANGE` flag with an unchanged fingerprint stays cleared across a recalculation; a changed fingerprint reopens it. `OVERLAPPING_JOBS` detector — back-to-back tickets (zero-minute gap) do not flag, matching `flagOverlappingLabor`'s own exclusion; overlapping raw windows do, naming both ticket ids. **Integration (API):** `approveEmployee`/`approvePeriod` refuse on an `OPEN` flag; refuse on an incomplete ticket **and** an open flag together (the case U4 alone could not test — build it here, now that both exist); succeed on neither. A tenant cannot configure a flag code as non-blocking (no such API/UI exists — assert `PayrollIssue` is untouched). Review refuses without a note, refuses below `payroll-admin: edit`, refuses on an `APPROVED` week; on success, clears every flag sharing the target's `groupKey` in one action; writes a `PayrollFlagEvent`. `payroll.flags_raised` dispatched `IN_APP` + `EMAIL`, once per run, with correct new/reopened counts, to every `payroll-admin` holder resolved via U1's recipient-spec variant — **not** to a portal `ADMIN`/`SUPER_ADMIN` who holds no explicit grant (per REQ-02's Notes, the bypass must not itself create a recipient). **Web:** the flags panel lists open flags for a period; the worklist "Open flags" filter/KPI reflects them; the review dialog enforces a required note; the audit log shows a resolved flag's history; the sidebar count matches the open-flag total for a `payroll-admin` holder and is absent/zero for anyone else. | `spec.md` §10 rows for REQ-09, REQ-10, REQ-07/REQ-11 (the combined case), REQ-12, REQ-13. New spec files: `apps/api/src/usecase/payroll-flags/payroll-flag-detection.service.spec.ts`, `payroll-flags.service.spec.ts`. New web `.test.mjs` files must be **added to the explicit whitelist array in `apps/web/package.json`'s `test` script** — confirmed that script enumerates every test file by path rather than globbing; a new file not added there will silently never run under `pnpm nx run @tcg/web:test` / `pnpm affected -t test`. |

### Reviewable as

- **Demo:** create two tickets for one employee with overlapping raw Start Ticket→End Ticket
  windows → run Calculate → `GET periods/:id/flags` shows one `OPEN` `OVERLAPPING_JOBS` flag
  naming both tickets → `approveEmployee` refused, `openFlags[]` names it → `POST
  flags/:flagId/review {note}` as a `payroll-admin: edit` holder → flag `REVIEWED_NO_CHANGE`
  → `approveEmployee` now succeeds. Re-run Calculate with the same overlap still present → the
  flag stays `REVIEWED_NO_CHANGE`, not reopened (unchanged fingerprint). Change one ticket's
  window so it no longer overlaps → re-run Calculate → the flag auto-`FIXED`s.
- **Acceptance:** REQ-09 through REQ-14 acceptance lines in `spec.md` §2.
- **Reviewer can verify without:** U2, U3, U4; **not** without U1 — every new route is
  `payroll-admin`-gated and REQ-13's routing depends on U1's resolver variant.

### Risk

- **Weakest source:** `[UNVERIFIED]` across all six requirements. REQ-09's storage mechanism
  (a durable table, unconditional blocking, not added to `PayrollIssue`) is explicitly a
  CodingCops design inference the plan itself names as such, not a product statement — flagged
  in `spec.md`, not settled by any decision. REQ-10's raw-window basis is confirmed (Q1), the
  best-grounded of the six. REQ-14 has no product source at all screen-by-screen — it is "the
  smallest web surface that makes REQ-09–13 usable," per the plan.
- **Migration reversible:** yes — two new tables, two new enums, no drops, no backfill.
- **Behind a flag:** no.
- **Touches existing data:** no rows written by the migration; Calculate begins writing new
  rows to the new tables from the first run after this ships.
- **Blast radius:** the largest in the ticket. Every existing tenant's next Calculate run
  starts raising `OVERLAPPING_JOBS` flags wherever the condition already exists in their live
  data, and **every one of them blocks approval unconditionally, immediately** — there is no
  grace period, no per-tenant opt-out, and (per REQ-11's design) no way to configure one. A
  tenant with a backlog of genuinely overlapping tickets could find an entire period newly
  unapprovable the moment this ships.

**`[UNVERIFIED]` + a schema change that starts blocking real approvals on day one — worth
raising before this specific unit reaches a real tenant, even though the migration itself is
reversible.** Three things:

1. **The unconditional-blocking design is CodingCops's own inference**, not a client
   statement — reasoned from "all flags block" plus "there is no API/UI for
   `payroll_approval_blocking_issues` today" (`payroll/gaps.md` PAY-065). It is a defensible
   reading, and `spec.md` is honest that it is a reading — but it is the single decision in
   this unit with the largest immediate operational consequence for any tenant with existing
   overlap conditions, and no source has confirmed a tenant should have zero say in it.
2. **REQ-14 has no product source for any of its screen-by-screen content.** Build the
   functional minimum the other five requirements need to be usable (per the plan's own
   framing), and treat every copy/layout choice as exactly that — a choice, not a specified
   requirement — consistent with `spec.md` §13.
3. **The "flags" naming collision** (*Findings* #3) is a build-time discipline item, not a
   product risk, but it is the kind of thing that produces a confusing PR review if the
   reviewer does not know `job-payroll-flags-card.tsx` already exists and means something
   else entirely.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `PayrollEmployeeWeekStatus.FLAGGED` display label | shared enum, consumed by `payroll-worklist-filters.tsx`, `payroll-employee-table.tsx`, `payroll-format.ts` | this unit's own web test — the enum value is unchanged (assert no `FLAGGED` consumer breaks), only its rendered label moves to "Rate issue" | `spec.md` §11a row 8; `packages/shared/src/enums/index.ts:152` |
| Engine's `OVERLAPPING_LABOR` warning (`calculate.ts:533-571`) | separate, unrelated code path | **none needed** — confirmed unchanged: `grep -rln "OVERLAPPING_LABOR" packages/payroll-engine/src apps/api/src apps/web/src` shows no web consumer exists to collide with this unit's new, separate `PayrollFlag` row | `spec.md` §11a row 9 |
| `PayrollIssue` / `payroll_approval_blocking_issues` | separate table, same approval flow | **none needed** — this unit's own integration test asserts `PayrollIssue` is untouched | `spec.md` §11a row 10 |
| Crane Supervisor Send Back flow (`PayrollSendBack`, `crane-supervisor` permission) | coexists, unretired | `N/A — out of scope by design (U9, not built here)`; not this unit's ripple to close | `spec.md` §11a row 11 — **ticket-wide, not unit-specific**: no unit in U1–U5 retires this flow. Recorded here because U5 is where a reviewer is most likely to notice two parallel "something needs payroll's attention" mechanisms (Send Back and Flags) coexisting, and mistake it for this unit's bug rather than a named, out-of-scope follow-up. |

### Deliberately not in this unit

- **Any detector beyond `OVERLAPPING_JOBS`** — U6+, out of scope (`spec.md` §0 Scope note).
  The schema (`code: String`) is generic enough to hold future codes without a migration; no
  future detector's logic is stubbed or half-built here.
- **Retiring the Crane Supervisor Send Back flow** — U9, out of scope. Both mechanisms coexist
  after this unit ships; `spec.md` §11a row 11 names this explicitly as a known gap in the
  ticket as a whole, not something this unit was ever going to close.
- **A per-tenant setting to make a flag non-blocking** — REQ-11's own text: "a tenant cannot
  configure a flag code as non-blocking." Not a follow-up; a deliberate absence.
- **Adding flag codes to `PayrollIssue`** — REQ-11's Notes are explicit this stays untouched.

---

## Sequencing

```
U1 ──┬──▶ U3 ──▶ U4
     └──▶ U5

U2 (independent — no edges in or out)
```

- **Parallelisable:** **U1 and U2 in development**, merged in either order without collision —
  they share no file and no table (U1: `packages/shared/src/constants/permissions.ts`,
  `apps/api/src/utility/seed-data.ts`, `recipient-resolver.service.ts`,
  `payroll.controller.ts`'s five guard decorators, `role-permissions.ts`; U2:
  `packages/payroll-engine/src/rest-period.ts`, `explain.ts`, `payroll-rest-audit.tsx`). The
  developer's stated order is U1 then U2, but nothing breaks if U2's commit lands first — record
  the actual order used in the PR description since this ledger states U1 first as the
  convention, not a hard requirement. **U3 and U5 both depend on U1 and touch different files
  from each other** (U3: `JobTicket` columns, void endpoint, mobile partition test; U5:
  `PayrollFlag`/`PayrollFlagEvent`, detection service, flags web feature) — they could in
  principle be developed in parallel once U1 is on the branch, but the developer's stated
  commit order is U3 → U4 → U5 (via U1 → U3), so this ledger follows that order; U4 forces U3
  before it regardless.
- **Merge order constraint:** **U1 → U2 → U3 → U4 → U5**, matching the developer's explicit
  instruction, on the one branch. Migrations land in unit order — U3's `payroll_ticket_void`
  migration and U5's `payroll_flags` migration are independent (different tables) but each
  must be the branch tip's *only* pending migration for its own unit's commit, per
  `.ai/claude/contexts/prisma.md`'s migration-per-commit discipline. Since both are additive
  and touch disjoint tables, either could technically land in the other's slot without a
  schema conflict — the developer's stated order (U3 before U5, via U1 → U3 → U4 and U1 → U5)
  is what this ledger builds to, not a technical necessity beyond "U1 before both."
- **First unit to ship: U1.** Nothing blocks it (no schema change at all, confirmed — see
  *Findings* #1), and it proves the thing every other unit depends on: that `payroll-admin`
  actually gates the five narrowed routes and that the recipient resolver can find its
  holders. U3, U4 and U5 are all unreachable — their new endpoints have no permission holder —
  until U1 is on the branch. **U2 is the safe unit to lead with instead if U1 stalls**: it
  touches no permission code, no new table, and is independently reviewable purely against
  the engine's existing test file.

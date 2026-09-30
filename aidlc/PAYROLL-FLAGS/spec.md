# Spec — PAYROLL-FLAGS Flagged-entries rework, units U1–U5

> Written to `.ai/aidlc/PAYROLL-FLAGS/spec.md` by the elaborator
> (`.ai/aidlc/agents/inception/tcg-elaborator.md`).
>
> **No `intent.md` exists for this ticket.** PAYROLL-FLAGS is not a Jira ticket; it is a
> developer-scoped build (branch `feat/PAYROLL-FLAGS-foundation`, cut from `origin/main`
> `ff7674801`) covering units U1–U5 of a larger flagged-entries rework, assembled directly
> from vault decisions and a developer-answer log. This spec is built from those sources —
> see §0 for the exact list — in place of an `intent.md`.
>
> This is the document an executor builds from. **Every requirement in it carries its
> sources, and every source carries its status.** A requirement with no source is not a
> requirement — it is an open question, and it stays marked as one.

## Source status used in this spec

Per the task that produced it, every source below is tagged with which of three things it
is, not the vault's usual binary:

- **verified** — a named TCG person (here, always Corrina Bustos, TCG Payroll Manager, in
  writing) adjudicated it. Rendered `[VERIFIED]`.
- **reference** — a CodingCops developer's direction (git user `devmohsinakram`), filling in
  mechanics a verified decision left open, or extending one. It is `status: reference` in
  the vault, or — for round 8 — recorded only in a session scratchpad, not yet in the vault
  at all. Rendered `[UNVERIFIED]` per the spec template's binary flag, with "reference" and
  its ratifier stated in the source line.
- **unsourced** — nothing written settles it. Rendered `[OPEN]`.

A requirement's heading flag is the worst of its sources under the template's own rule:
`[VERIFIED]` only when every source is verified; `[UNVERIFIED]` if any source is
reference-status or otherwise unverified; `[OPEN]` if no source supports it at all.

---

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `PAYROLL-FLAGS` (developer-scoped, no Jira/intent.md) |
| Intent | none — see banner above; sourced directly from the files listed below |
| Elaborated on | 2026-09-30 |
| Vault state at elaboration | 734 content files; 11 in `domain/` (none of which cover payroll); `payroll/gaps.md` carries 106 entries marked `Status: open`. The overlay `.ai/` working tree carries uncommitted changes today: `payroll/gaps.md`, `payroll/INDEX.md`, `payroll/payroll-rules-provenance.md`, `field-ops/gaps.md`, the 2026-09-28 decision note, and one untracked file, `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` — all read as they stand on disk for this spec. |
| Open questions raised by this spec | 7, all in §12 — **all 7 answered by the developer on 2026-09-30** (Q3 recorded in the vault; Q1, Q2, Q4–Q7 relayed in session, not yet vaulted) — see §12 |
| Already-shipped behaviour reached | 9 consumers enumerated in §11a; 1 of those (row 11, the coexisting Crane Supervisor flow) has no product source for what happens to it and is scoped to a follow-up unit instead of raised as a question; row 2 was open pending Q3 and is now resolved |
| Rules consulted | `CLAUDE.md` (Identity Convention, Architecture invariants); `.ai/claude/contexts/api.md` (layering, guards, `@RequirePermission`); `.ai/claude/contexts/prisma.md` (identity convention, migration requirement); `.ai/claude/contexts/web.md` (feature-first, Test IDs); `.ai/claude/contexts/payroll-engine.md` (a pay-rule change needs its provenance row in the same commit) |

### Sources read for this spec

- `.ai/vault/decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md` (`verified`)
- `.ai/vault/decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md` (`verified`; `conflicts_with: payroll/rules/PAY-045-rest-period-premium.md`)
- `.ai/vault/decisions/2026-09-29-invalid-entry-flags-samsara-30-minutes-and-wtl-penalty-moves-rest-start.md` (`verified`)
- `.ai/vault/decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md` (`verified`)
- `.ai/vault/decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` (`verified`)
- `.ai/vault/decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md` (`verified`)
- `.ai/vault/decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` (`reference` — devmohsinakram, pending Brian Petros / Corrina Bustos ratification on every pay-rule item). **Re-read after first publish**: it now carries a closing section, "Later the same day — the build plan" (items E1–E4), given while planning this very ticket. E1 (Approve/Export narrowing) and E2 (no fixed Payroll Admin permission bundle) are cited below in place of the scratchpad; E3 (rest-flag trigger, any gap under 8 h) concerns the U6 rest flag, out of scope here; E4 records PR #699's closure, already reflected in this spec's §0.
- `.ai/vault/decisions/2026-09-10-pending-tickets-are-a-display-only-payroll-overlay.md` (`reference`, Syed Haris; clause 6 now partly superseded)
- `.ai/vault/decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md` (`reference`; superseded on routing/correction, standing on the rest — read by grep only, 90 KB)
- `.ai/vault/payroll/rules/PAY-045-rest-period-premium.md` (`status: open`)
- `.ai/vault/payroll/payroll-rules-provenance.md` §4 *Rest and meals* (`status:` varies per row)
- `.ai/vault/payroll/gaps.md` → *Which payroll issues block approval (PAY-065)* and *Flagged entries go to payroll, not the crane superintendent…* (both `Status: open`, partly answered)
- `/tmp/.../scratchpad/answers.md` — the developer's own running log of seven rounds of chat
  answers plus a round 8, dated 2026-09-30. **Round 8 is not yet in the vault at all** — it is
  cited here directly, at the task's instruction, as the source for the branching decision and
  for "Approve/Export narrow to Payroll Admin/Manager" and is flagged accordingly wherever used.
- `/tmp/.../scratchpad/plan-u1-u5.md` — a planner's origin/main file:line mapping. Used only for
  codebase facts, each verified against the repository directly before being relied on below (one
  correction found: `RecipientSpec` does not live where the planner said — see REQ-02).
- **Developer direction, devmohsinakram, 2026-09-30, relayed directly in the coordinating
  session** — answers to this spec's own §12 Q1, Q2, Q4, Q5, Q6 and Q7, given after this spec's
  first publish. Same standing as the scratchpad round-8 answers above: `reference`, pending
  Corrina Bustos / Brian Petros ratification wherever a pay rule is touched (Q2), **not yet
  written into `.ai/vault/`** at all — unlike Q3, which the same day's chat separately recorded
  in the vault as build-plan item E2 (see above). Recommend `tcg-scrum` record Q1, Q2, Q4–Q7 the
  same way once this spec's fold-in is reviewed.
- The repository, read directly and cited as `code` wherever used — current-state description and
  ripple only, never as a source of intent, per `tcg-elaborator.md` §2.

### Scope note — this ticket is U1–U5 only; U6+ are follow-ups, not built here

The developer chose to build units U1–U5 as **one PR on `feat/PAYROLL-FLAGS-foundation`, one
commit per unit**, rather than the project's usual one-unit-per-branch convention (source:
scratchpad `answers.md` round 8, reference-status, not yet in the vault). That choice is
recorded here for the decomposer and the executor; it is a process decision, not a product
requirement, and carries no REQ number.

U6 and later (the rest flag — now confirmed to fire on any gap under 8 h, not only when the
PAY-045 OT/DT trigger holds, per build-plan item E3 — invalid-time and long-boom checks,
payroll fixing an entry itself, retiring the Crane Supervisor routing, payroll completing a
ticket, Send Back rebuilt for the worker, and nine further units gated on undecided items —
boom basis, missing-notes definition, AM/PM detection, crew-ticket grouping, Samsara event
mapping, the departure-yard record) are **out of scope for this spec** and are not decomposed
here. They are listed for continuity in §13.

---

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | `payroll-admin` permission module, assignable via Department Roles, no fixed bundle | shared, api, schema (seed), web | `[UNVERIFIED]` | decisions 2026-09-29 (×2), 2026-09-30 flag-list; build-plan E2; `payroll/gaps.md`; code | no |
| REQ-02 | Recipient resolver gains a permission-based spec | api | `[UNVERIFIED]` | decisions 2026-09-29, 2026-09-30 flag-list; code | no |
| REQ-03 | Approve and Export narrowed to Payroll Admin / Payroll Manager | api, web | `[UNVERIFIED]` | build-plan E1 (vault, reference); code | no |
| REQ-04 | PAY-045: rest gap starts at rounded paid end + WTL penalty, cumulative from the 2nd missed meal on | engine, api | `[UNVERIFIED]` | decisions 2026-09-29 (×2), 2026-09-30 crew-mismatch (verified, base rule); developer direction 2026-09-30 (reference, cumulative part); PAY-045; provenance | no |
| REQ-05 | Rest audit UI shows the new gap start | web | `[UNVERIFIED]` | plan (code); REQ-04's sources | no |
| REQ-06 | Payroll Admin/Manager voids a never-completed ticket (not `REJECTED`) | schema, api, web, mobile | `[UNVERIFIED]` | decision 2026-09-30 incomplete-tickets; developer-answers C8; developer direction 2026-09-30 (Q5, Q6); code | no |
| REQ-07 | Approve refused while any `PENDING`/`SENT`/`IN_PROGRESS` ticket in the week's start-ticket week is incomplete; Calculate stays allowed | api, web | `[UNVERIFIED]` | decision 2026-09-30 incomplete-tickets; developer-answers C7; decision 2026-09-10; developer direction 2026-09-30 (Q6, Q7); code | no |
| REQ-08 | A "Remind" action for an incomplete ticket's primary worker | api, web | `[UNVERIFIED]` | plan-u1-u5.md (U4 goal); developer direction 2026-09-30 (U1–U5 approved; channel: in-app/push/email) | no |
| REQ-09 | Durable `PayrollFlag` / `PayrollFlagEvent` schema, reconciled per period at Calculate | schema, api | `[UNVERIFIED]` | decision 2026-09-30 flag-list (behavior); plan (mechanism, a CodingCops design choice); code | no |
| REQ-10 | `OVERLAPPING_JOBS` flag detector — raw Start Ticket→End Ticket window overlap | api | `[UNVERIFIED]` | decision 2026-09-29 (Corrina's own words); developer direction 2026-09-30 (Q1, basis confirmed); code | no |
| REQ-11 | Approval gate refuses while any flag is `OPEN`, unconditionally | api | `[UNVERIFIED]` | decision 2026-09-30 flag-list (blocking); plan (unconditional design, CodingCops) | no |
| REQ-12 | "Reviewed, no change" clears a flag — required note, audited, Payroll Admin/Manager only | api, web | `[UNVERIFIED]` | decision 2026-09-30 incomplete-tickets; developer-answers C2 | no |
| REQ-13 | Flag routing/notification to Payroll Admin and Payroll Manager, in-app and email | api, shared | `[UNVERIFIED]` | decisions 2026-09-29, 2026-09-30 flag-list; developer direction 2026-09-30 (Q4, channel confirmed) | no |
| REQ-14 | Web: flags panel, timesheet chips, worklist KPI/filter, review dialog, audit log, sidebar count | web | `[UNVERIFIED]` | plan (code), built on REQ-09–REQ-13 | no |

Counts: **14 total** — 0 verified, 14 unverified, 0 conflicted, 0 open. (REQ-04's flag moved from
`[VERIFIED]` to `[UNVERIFIED]` in this update: its base rule — 2nd missed meal only,
non-cumulative — is still verified by Corrina Bustos, but the cumulative 3rd+ extension folded in
below is reference-status only, and a requirement's heading takes the worst of its sources. A
fifteenth candidate item, "reviewed-no-change basis for asset flag 9", is out of scope because
flag 9 itself is a U6+ detector, not built in U5 here.)

**All seven §12 questions were answered by the developer on 2026-09-30 and are folded in
below** — Q3 is now vault-recorded (build-plan item E2); Q1, Q2, Q4, Q5, Q6 and Q7 were relayed
directly in this session and are not yet written into `.ai/vault/`. **A correction to an earlier
fold-in: REQ-08 (U4's Remind action) was briefly marked out of scope on a misreading of Q4's
answer; the coordinator clarified that answer meant Send Back's U12 reminder mechanics, not U4's
own Remind button, and REQ-08 is restored, built, in this version.** None of the 14 requirements
is individually build-blocking. REQ-01's answer (Q3) carries one confirmed operational
consequence: because no role is pre-granted `payroll-admin`, **no seeded role — including Payroll
Manager — can Approve, Export, void or review a flag immediately after this ships**, until a
tenant admin explicitly grants the permission via Departments (developer-confirmed: *"No, grant
by hand"*) — portal `ADMIN`/`SUPER_ADMIN` users bypass the permission check entirely
(`apps/api/src/guard/permissions.guard.ts:37`) and can perform that grant, or the gated actions
themselves, in the interim. See REQ-01 and REQ-03's Notes for the executor, and §11's rollout
note.

---

## 2. Requirements

### REQ-01 — `payroll-admin` permission module, assignable via Department Roles, no fixed bundle `[UNVERIFIED]`

- **Statement:** The system gains a `payroll-admin` permission module (view / edit / full,
  matching every other module) in `PERMISSION_MODULES`. **No permission bundle is pre-seeded for
  it.** It defaults to `'none'` on every existing and newly-seeded role — including
  `ROLE-ACCOUNTS-PM` (Payroll Manager) — the same way `crane-supervisor` already does today. No
  new system role is created. A tenant admin grants `payroll-admin`, via the existing Departments
  role editor, to whichever department role(s) they choose. Whoever holds it at `edit` or above
  then acts as Payroll Admin/Manager for flag routing (REQ-02/REQ-13) and for the payroll-admin
  actions in this spec (REQ-03, REQ-06, REQ-12); what else that role can do is whatever else it
  is separately granted — **there is no fixed "Payroll Admin" permission bundle.**
- **Surface:** shared, api, seed data (constants only — see §3 on whether a migration is even
  needed), web
- **Sources:**
  - `decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md`
    clause 2 — `[VERIFIED]` — kind: decision — Corrina Bustos, verbatim: *"Right now the Payroll
    Administrator is Micaela Slykhuis. That needs to be able to be adjusted in the future in
    the event there are any changes."* Settles that it must be an assignable role, not a name.
    Does not say the mechanism — that was open, and is now answered below.
  - `decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md`
    — `[VERIFIED]` — kind: decision — routes flags to "the payroll admin and payroll manager,"
    explicitly excluding the crane superintendent. Its own *What this does NOT decide* §2 says
    "who 'payroll admin' is… whether it is a new ERP role or permission" is open.
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` — `[VERIFIED]`
    — kind: decision — "All flags go to the Payroll Admin (Micaela) and the Payroll Manager
    (Corrina)."
  - **`decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` → "Later the
    same day — the build plan", item E2** — `[UNVERIFIED]` — kind: decision (`status: reference`,
    developer direction, devmohsinakram) — *"Who is 'Payroll Admin' is a Department Roles
    setting. No fixed permission bundle is seeded for the role: whoever a tenant's department
    roles grant the payroll-admin permission to acts as Payroll Admin/Manager, and what else they
    can do is whatever their role grants."* Given, in the developer's own words relayed the same
    day: *"that should be handle in deparment roles and its depends on that whick permissions are
    provided or not."* **This answers Q3 and replaces this requirement's earlier
    "seed `ROLE-ACCOUNTS-PA`, grant `ROLE-ACCOUNTS-PM` `payroll-admin: full`" design** — that
    design is superseded by this note, not built.
  - `payroll/gaps.md` → *Flagged entries go to payroll…*, closing line — `[UNVERIFIED]` — kind:
    vault — "Owner: Corrina Bustos (payroll)… **CodingCops for Q2's role design** and C4." Still
    accurate context: the mechanism was CodingCops's call, and E2 above is that call, now written
    down.
  - `packages/shared/src/constants/permissions.ts` (`PERMISSION_MODULES`, `USER_RESTRICTED_MODULES`)
    and `apps/api/src/utility/seed-data.ts` (`FULL_PERMISSIONS` forcing `crane-supervisor` to
    `'none'`) — kind: code — the existing pattern this now explicitly follows in full: exclude
    `payroll-admin` from `FULL_PERMISSIONS` for every role, with zero exceptions, per E2.
  - **Developer direction, devmohsinakram, 2026-09-30, relayed in this session** — `[UNVERIFIED]`
    — kind: reference, not yet in `.ai/vault/` — asked directly whether `ROLE-ACCOUNTS-PM` should
    get `payroll-admin` by default given the deployment gap this otherwise creates, the developer
    answered: *"No, grant by hand"* — a tenant admin grants it in Departments right after deploy.
    **This settles the deployment-gap question as an answer, not an open risk this spec is merely
    flagging.**
  - `apps/api/src/guard/permissions.guard.ts:37` — kind: code — `if (user.role === Role.ADMIN ||
    user.role === Role.SUPER_ADMIN) return true;` — confirms a portal `ADMIN`/`SUPER_ADMIN` user
    bypasses the `PermissionsGuard` check entirely, independent of any department role's
    `payroll-admin` grant, and so can perform the initial by-hand grant (or the gated actions
    themselves) in the gap between deploy and that grant.
- **Conflict:** none
- **Open question:** none — **resolved, Q3** (see Sources, item E2).
- **Ripple:** see §11a rows 1–2. New module addition; existing consumers are the code that
  enumerates every `PermissionModule` (role editor UI, permission-map builders) and must
  render/accept the new module without special-casing it. **Row 2 of §11a (every manager role's
  implicit grant) is now resolved, not open**: per E2, `payroll-admin` is excluded from
  `FULL_PERMISSIONS` for every role, with no exception for Payroll Manager either — so no role
  gets it silently, by design, not by an assumption this spec had to flag.
- **Acceptance:** `payroll-admin` appears in `PERMISSION_MODULES` and `USER_RESTRICTED_MODULES`;
  every seeded role — Payroll Manager included — holds it at `'none'` out of the box; no new
  system role is created; the Departments permission editor shows and labels the module so a
  tenant admin can grant it to any role they choose.
- **Notes for the executor:** Reuse the `crane-supervisor` exclusion pattern end to end (the
  `FULL_PERMISSIONS` override, `role-permissions.ts` labeling and per-template override to
  `'none'`). **Deployment gap, confirmed by the developer, not an open risk**: because nothing is
  pre-granted, immediately after this ships **no seeded department role in any existing tenant can
  approve, export, void, or review a flag** (REQ-03, REQ-06, REQ-12) until a tenant admin
  explicitly grants `payroll-admin` to at least one role via Departments — asked directly, the
  developer confirmed this is intended (*"No, grant by hand"*), not a defect to design around.
  Portal `ADMIN`/`SUPER_ADMIN` users are unaffected in the interim — their role bypasses the
  permission check entirely (see Sources) — so that grant, or the gated actions themselves, can
  be performed by a portal admin before any department role is updated. See §11 for the rollout
  note. `apps/api/src/utility/demo-data/data/organisation.ts`
  adding a Payroll Admin demo employee is still a reasonable code-quality nicety for the demo
  tenant specifically (which is not bound by "seed nothing" the same way a real tenant's
  onboarding is) — `NOT SPECIFIED` beyond that.

### REQ-02 — Recipient resolver gains a permission-based spec `[UNVERIFIED]`

- **Statement:** The notification recipient resolver can resolve "every user whose employee
  holds `payroll-admin` at or above a given level" as a recipient spec, so flag and
  incomplete-ticket notifications can be routed to Payroll Admin and Payroll Manager holders by
  permission rather than by a fixed role code.
- **Surface:** api
- **Sources:**
  - Same three decisions as REQ-01 (all flags go to Payroll Admin and Payroll Manager,
    `[VERIFIED]`, kind: decision) — establish *who* must be reachable, not *how*.
  - `apps/api/src/usecase/notifications/recipient-resolver.service.ts` — kind: code — **correction
    to the planner's file mapping**: `plan-u1-u5.md` states `RecipientSpec` lives in
    `packages/shared/src/types/notification.types.ts`. That file exists (81 lines) but holds only
    `NOTIFICATION_TYPES`, `NotificationChannel` and `NotificationDto` — no `RecipientSpec`. The
    type actually lives, and is exported from,
    `apps/api/src/usecase/notifications/recipient-resolver.service.ts` as a union of
    `{userId}` / `{userIds}` / `{email}` / `{phoneE164}` / `{departmentCode}` / `{salespersonId}`
    / `{employeeId}`. This requirement adds a `{permission: {module, minLevel}}` member there.
  - `apps/api/src/service/payroll-send-backs/payroll-send-backs.repository.ts:45-51`
    (`CRANE_SUPERVISOR_ROLE`, a `Prisma.EmployeeWhereInput` matching
    `role.permissions.path:['crane-supervisor'], equals:'edit'|'full'`) — kind: code — the
    existing JSON-path-on-permissions query pattern this requirement's resolution logic would
    reuse for `payroll-admin`.
- **Conflict:** none
- **Open question:** none beyond REQ-01's.
- **Ripple:** `none — new recipient-spec variant, additive to an existing discriminated union
  (established by: reading recipient-resolver.service.ts in full — the union's other six
  branches are unchanged by adding a seventh)`.
- **Acceptance:** `resolve(tenantId, {permission: {module: 'payroll-admin', minLevel: 'view'}})`
  returns one entry per active user whose employee's `DepartmentRole.permissions` grants
  `payroll-admin` at `minLevel` or above (`edit` or `full` satisfy `minLevel: 'view'`, etc.).
- **Notes for the executor:** Portal `ADMIN` bypass must not make someone a recipient by itself
  — stated as a design constraint in the plan, not contradicted by any source; treat as
  `NOT SPECIFIED` whether an exception should exist, i.e. do not add one.

### REQ-03 — Approve and Export narrowed to Payroll Admin / Payroll Manager `[UNVERIFIED]`

- **Statement:** The Approve action (per employee and per period) and the payroll Export
  actions (per employee and per period, including the CSV export) are refused to a user who
  does not hold `payroll-admin` at `edit` or above, narrowing from today's `payroll:edit`,
  which every seeded manager role across every department currently holds.
- **Surface:** api, web
- **Sources:**
  - **`decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` → "Later the
    same day — the build plan", item E1** — `[UNVERIFIED]` — kind: decision (`status: reference`,
    developer direction, devmohsinakram) — *"Today any `payroll:edit` holder (every seeded
    manager/admin role) may approve and export. From this rework, only holders of the Payroll
    Admin / Payroll Manager access may. Other managers keep view and Calculate."* **This is now a
    vault source, replacing this requirement's earlier scratchpad citation** (the scratchpad line
    was the same statement, recorded before it was written to the vault). No verified TCG
    statement addresses Approve/Export permissions specifically — this remains reference-status,
    not client-confirmed.
  - `apps/api/src/presentation/payroll/payroll.controller.ts` lines 158–159 (`POST
    .../employees/:employeeId/approve`), 192–193 (`POST .../periods/:id/approve`), 138–139
    (`GET .../employees/:employeeId/export`), 199–200 (`GET .../periods/:id/export`), 217–218
    (`GET .../periods/:id/export.csv`), all currently `@RequirePermission('payroll', 'edit')`
    — kind: code — the exact endpoints and their current guard.
  - `apps/api/src/utility/seed-data.ts` `managerRole()` / `FULL_PERMISSIONS` — kind: code —
    every department's manager role (`ROLE-DISPATCH-MGR`, `ROLE-FLEET-MGR`, `ROLE-HR-MGR`,
    `ROLE-SALES-MGR`, `ROLE-TRUCKING-MGR`, etc.) plus `ROLE-ADMIN-CA` currently holds
    `payroll: 'full'`, because `FULL_PERMISSIONS` excludes only `crane-supervisor`, not
    `payroll`. So today, e.g., the Fleet Manager can approve and export payroll.
- **Conflict:** none
- **Open question:** none — this requirement's citation is now the vault (E1), not the scratchpad;
  §13's earlier recommendation to have `tcg-scrum` record it is satisfied for E1/E2 specifically
  (Q1, Q2, Q4, Q5, Q6, Q7 remain unvaulted, see §0).
- **Ripple:** see §11a row 3. **Every seeded manager role loses Approve and Export access it
  holds today — including Payroll Manager, since REQ-01/Q3 now confirms nothing is pre-granted
  `payroll-admin`.** Enumerated by: `grep -n "managerRole(" apps/api/src/utility/seed-data.ts`
  (11 department manager roles) plus `ROLE-ADMIN-CA` (Company Admin, also
  `fullPermissions: true`), plus `ROLE-ACCOUNTS-PM` itself. E1's own words — *"other managers keep
  view and Calculate"* — confirm this is deliberate for the *other* managers; Payroll Manager's
  own gap immediately post-deploy is confirmed too, directly, by the developer's separate answer
  cited in REQ-01 (*"No, grant by hand"*) — see REQ-01's Notes for the executor and §11's rollout
  note.
- **Acceptance:** the five endpoints above are refused (403) to a user whose employee's
  effective `payroll-admin` level is below `edit`, even if they hold `payroll:edit`; a role
  explicitly granted `payroll-admin: edit`/`full` via Departments can perform all five — which,
  immediately after deploy and before any tenant admin acts, is nobody (see REQ-01).
- **Notes for the executor:** Whether this narrowing uses a second `@RequirePermission`
  decorator, a combined check, or replaces the `payroll` permission on these five routes outright
  is `NOT SPECIFIED` — no source describes the mechanism, only the outcome ("narrow to Payroll
  Admin and Payroll Manager only").

### REQ-04 — PAY-045: rest gap starts at the rounded paid end, plus the WTL penalty, cumulative from the 2nd missed meal on `[UNVERIFIED]`

> **Flag changed from `[VERIFIED]` to `[UNVERIFIED]` in this update.** The base rule (2nd missed
> meal moves the gap start, 1st does not) is still verified — Corrina Bustos's own words, three
> separate times. The **cumulative** extension this update adds (3rd, 4th… each add a further 30
> minutes) is sourced only to developer direction, reference-status, pending ratification because
> it is a pay rule. A requirement's heading takes the worst of its sources, so the whole
> requirement is `[UNVERIFIED]` now — see *Conflict* below for exactly which part is which.

- **Statement:** The 8-hour rest premium's gap is measured from the PAY-020 rounded, paid end of
  the prior work chain, extended by 30 minutes for **each** worked-through-lunch penalty from the
  **second** missed meal onward, **cumulatively**: the 2nd missed meal adds 30 minutes, the 3rd
  adds a further 30 (60 total), the 4th a further 30 again (90 total), and so on. A first missed
  meal's absorbed half-hour (PAY-047) does not move the gap start at all.
- **Surface:** engine (`packages/payroll-engine`), api (explain/audit), web (display only, see
  REQ-05)
- **Sources:**
  - `decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md`
    clause 5 — `[VERIFIED]` — kind: decision — Corrina Bustos, verbatim: *"the 8 hour gap should
    be computed from the time rounded time because that is the time the EE is paid… if the ee
    worked until 11pm but the WTL penalty adds another 30 minute penalty per the rule, their 8
    hour gap would really start at 1130."*
  - `decisions/2026-09-29-invalid-entry-flags-samsara-30-minutes-and-wtl-penalty-moves-rest-start.md`
    clause 3 — `[VERIFIED]` — kind: decision — *"yes, the WTL penalty effect the rest starts.
    this was confirmed last friday in our meeting with the union business agent."*
  - `decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md`
    clause 2 — `[VERIFIED]` — kind: decision — *"no, only the 2nd and onward"* [move the rest
    start]. Narrows the two notes above: a first missed meal's penalty does not move the gap
    start; this agrees with PAY-047's own first-meal absorption.
  - `payroll/rules/PAY-045-rest-period-premium.md` frontmatter `provenance_note` — `[UNVERIFIED]`
    — kind: vault (`status: open` on the file as a whole) — records the same sequence and adds:
    *"Still open: Brian's concurrence; the 2026-09-25 union BA meeting is not in the vault. Engine
    not changed."*
  - `payroll-rules-provenance.md` §4 row *8-hour rest — gap start (PAY-045)* — `[UNVERIFIED]` —
    kind: vault — status **"Confirmed"**, citing the same three decisions; *"Still open"* column
    lists only Brian's concurrence and the missing meeting record, not the rule itself.
  - **Developer direction, devmohsinakram, 2026-09-30, relayed in this session** — `[UNVERIFIED]`
    — kind: reference, **pay rule, pending Corrina Bustos / Brian Petros ratification**, **not
    yet written into `.ai/vault/`** — verbatim: *"YES, cumulative, 30 min per missed meal from the
    2nd on (2nd +30, 3rd +60, 4th +90)."* This is the sole source for the cumulative part of this
    requirement's Statement above; it answers Q2 but carries none of the base rule's verified
    standing.
- **Conflict:** **Disclosed, not blocking.** The 2026-09-29 note's own `conflicts_with:` field
  names `payroll/rules/PAY-045-rest-period-premium.md`, because Brian Petros stated on
  2026-08-24 that *"Added hours must not affect the 8-hour rest rule"* (recorded in
  `client-message-findings.md` and in PAY-045's own Open list), and the PAY-029 invariant treats
  added hours as ledger components, never time windows. Corrina's third 2026-09-29 reply was
  asked with Brian's statement read back to her by name, and she reaffirmed the WTL rule anyway,
  citing a union business-agent meeting. The vault's own synthesis (`payroll-rules-provenance.md`)
  already treats this as **Confirmed**, not as an open two-document disagreement — this is TCG's
  own payroll owner overruling a CodingCops-relayed prior statement on the record, not
  CodingCops choosing between two undecided sources. It is recorded here rather than flagged
  `[CONFLICT]` for that reason, but two things remain genuinely unresolved and are worth the
  executor's awareness: **Brian Petros has never confirmed it**, and **the 2026-09-25 union
  business-agent meeting Corrina cites is not itself in the vault**. Neither blocks this
  requirement; both are why PAY-045's file-level `status:` is still `open`. **Additionally, and
  separately: the cumulative (3rd+) extension above is not part of Corrina's verified statements
  at all** — she was only ever asked "first, or second onward," never asked about a third. It is
  a developer's answer to a question she was never put, reasoned by analogy to PAY-047's own
  "each further missed meal adds a half-hour" rule. Per this update's instruction, the
  `payroll-rules-provenance.md` row for this rule must say **"developer direction, pending
  Corrina Bustos / Brian Petros"** for the cumulative part specifically, distinct from the base
  rule's "Confirmed" status.
- **Open question:** none — **resolved, Q2** (see Sources; cumulative, reference-status, pending
  ratification since it is a pay rule).
- **Ripple:** see §11a row 4. `packages/payroll-engine/src/calculate.ts` prices rest (step 3)
  before meals (step 6) today (per Brian Petros's 2026-09-13 order-of-operations note, quoted in
  `PAY-045-rest-period-premium.md`), so this requirement needs a pre-pass that counts a chain's
  worked-through meals before rest is priced — the plan's proposed approach — without reordering
  the six-step sequence. `applyRestPeriodPremium` (`rest-period.ts:125`) and its `RestEntry`
  input (`rest-period.ts:42`) are the only current callers/shape; `explain.ts` must mirror the
  change in the same commit (existing convention, not new).
- **Acceptance:** given the decision's own worked example (worked to 11:00 PM, WTL penalty from
  the 2nd missed meal), the priced rest gap starts at 11:30 PM, not 11:00 PM; given a first
  missed meal only, the gap start is unchanged by it; given penalties from the 2nd **and** 3rd
  missed meals on the same chain, the gap start moves a cumulative 60 minutes (30 + 30) per the
  developer's Q2 answer.
- **Notes for the executor:** Per `.ai/claude/contexts/payroll-engine.md` and `CLAUDE.md`, this
  pay-rule change requires its `payroll-rules-provenance.md` row updated **in the same commit** as
  the engine change — not a follow-up — and that row must distinguish the two standings: the base
  rule ("engine not changed" → naming the engine commit, status stays "Confirmed", citing
  Corrina's three 2026-09-29/30 statements) and the cumulative 3rd+ part ("developer direction,
  pending Corrina Bustos / Brian Petros", citing this session's Q2 exchange, not yet a vault
  decision file). `REST_STITCH_MINUTES` and the chain-forming logic (`toWorkChains`) are
  unchanged; this requirement touches only where the gap for an already-formed chain starts.

### REQ-05 — Rest audit UI shows the new gap start `[UNVERIFIED]`

- **Statement:** The payroll rest-audit view displays the effective rest-gap start computed by
  REQ-04 (rounded paid end plus any WTL extension), not just the raw entry end time.
- **Surface:** web, api (whatever REQ-04 persists or returns for display)
- **Sources:**
  - REQ-04's sources establish that the gap-start value itself changes; no source separately
    states the UI must show it.
  - `apps/web/src/features/payroll/components/payroll-rest-audit.tsx` — kind: code — confirmed to
    exist; the natural place for this, per the plan's proposal. Evidence of current surface, not
    of a requirement to change it.
- **Conflict:** none
- **Open question:** none directly.
- **Ripple:** `none — new field on an existing display component (established by: reading
  payroll-rest-audit.tsx)`. No other consumer of the rest-gap value was found:
  `grep -rn "restGapHours\|gapHours" apps/web/src apps/api/src --include=*.ts --include=*.tsx`
  returns only the engine and this one component.
- **Acceptance:** `NOT SPECIFIED` beyond "the new gap start is visible somewhere payroll already
  looks at rest" — no source specifies exact copy, layout, or whether the WTL extension is shown
  as a separate line item versus folded into one timestamp.
- **Notes for the executor:** Whether a new `PayrollJobDay.rest_started_at` column is persisted,
  versus `restGapHours` being documented as "measured from" the new start without a stored
  timestamp, is `NOT SPECIFIED` — both were floated in the plan and no source picks between them.

### REQ-06 — Payroll Admin/Manager voids a never-completed ticket (not `REJECTED`) `[UNVERIFIED]`

- **Statement:** A Payroll Admin or Payroll Manager can void a job ticket that was never
  completed and is still `PENDING`, `SENT` or `IN_PROGRESS`, with a required note. **A `REJECTED`
  ticket is out of scope for this action** — per Q6, it is never incomplete and needs no void (see
  REQ-07). Voiding sets the ticket `CANCELLED` and records who voided it, when, and why, so it
  stops blocking the week under REQ-07. Voiding has **no billing or invoicing effect** — it
  removes the ticket from payroll only. On mobile, a voided ticket drops off the crew's active
  list the same way a cancelled ticket already does today, and the crew receives an in-app and
  email notice.
- **Surface:** schema, api, web, mobile
- **Sources:**
  - `decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md`
    *Not decided* item 2 — `[VERIFIED]` (as to the problem, not the mechanism) — kind: decision —
    *"An escape path for a ticket that never completes… Who may complete or void it on the crew's
    behalf (payroll? dispatch?)"* is explicitly left open by Corrina's own reply — she was not
    asked this, and did not answer it.
  - `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` item C8 —
    `[UNVERIFIED]` — kind: decision (`status: reference`, developer direction, **pending
    Corrina**) — *"the Payroll Admin or Payroll Manager may: complete it, entering the missing
    times; or void it. Either way a note is required, and the action is audited."* The note
    itself says: *"Voiding a ticket is new, and reaches beyond payroll. A voided ticket may
    matter to dispatch and to billing. Nobody has asked either of them."*
  - `apps/api/prisma/schema.prisma` `enum JobTicketStatus { PENDING SENT IN_PROGRESS COMPLETE
    REJECTED CANCELLED }` (lines 189–196) — kind: code — confirms `CANCELLED` is an existing
    terminal status, so voiding reuses it rather than needing a new enum member.
  - `apps/mobile/data/contracts/ticket.contract.ts:14-21`, `FieldTicketStatusSchema`, a strict
    `z.enum` of exactly those six values — kind: code — confirms the mobile app would fail closed
    on an unrecognized seventh status, which is why this requirement must not add one.
  - `apps/api/src/service/payroll/payroll.repository.ts:259-263`, `WEEK_OVERLAY_TICKET_STATUSES =
    [PENDING, SENT, IN_PROGRESS, REJECTED]`, with the comment *"`CANCELLED` is excluded — the work
    was called off, so there is no gap to chase"* — kind: code — this is the **display**-overlay
    set (unchanged); this requirement's **voidable** set is narrower — see below, it excludes
    `REJECTED` too, which `WEEK_OVERLAY_TICKET_STATUSES` does not.
  - **Developer direction, devmohsinakram, 2026-09-30, relayed in this session** — `[UNVERIFIED]`
    — kind: reference, not yet in `.ai/vault/` — answering Q6: *"NOT incomplete. A `REJECTED`
    ticket never blocks Approve and needs no void."* Answering Q5: *"NO BILLING EFFECT. The void
    takes the ticket out of payroll only. On mobile it drops off the crew's list like a cancelled
    ticket, plus the in-app/email notice."*
- **Conflict:** none
- **Open question:** none — **resolved, Q5 and Q6** (see Sources).
- **Ripple:** see §11a row 5. `apps/mobile/data/hooks/use-tickets.ts:58-71`
  (`partitionDashboardTickets`) already drops `CANCELLED` and `REJECTED` tickets from the active
  dashboard partition today — established by reading the function — so a voided ticket
  disappearing from the crew's active list is **existing behavior, unchanged** by this
  requirement, now confirmed as the intended outcome by Q5 rather than assumed. The in-app/email
  notice is new (Q5, Q4). No billing/invoicing system is touched — confirmed by Q5, though this
  is the developer's build answer, not a confirmation from anyone who owns billing or dispatch
  (nobody there was asked, per the underlying decision note).
- **Acceptance:** `POST /v1/payroll/periods/:id/tickets/:ticketId/void {note}` refuses a ticket
  not in `{PENDING, SENT, IN_PROGRESS}` — **a narrower set than `WEEK_OVERLAY_TICKET_STATUSES`,
  deliberately excluding `REJECTED` per Q6**; on success the ticket is `CANCELLED`, a note is
  stored, no billing/invoicing record is touched, and it no longer counts as incomplete under
  REQ-07 (which it already didn't, being voidable only because it wasn't `REJECTED` to begin
  with).
- **Notes for the executor:** `@RequirePermission('payroll-admin', 'edit')` per REQ-01/REQ-02.
  **Do not reuse `WEEK_OVERLAY_TICKET_STATUSES` verbatim for the voidable-status check** — define
  a distinct, narrower constant (`PENDING`, `SENT`, `IN_PROGRESS`) so a `REJECTED` ticket is
  correctly refused by this endpoint per Q6. Use a conditional status update (matching
  `submitTicket`'s pattern) and write a status-history / activity entry, per existing convention.
  The roster-wide notification (`payroll.ticket_voided`) is **in-app and email**, per Q4 —
  confirmed, no longer open.

### REQ-07 — Approve refused while any `PENDING`/`SENT`/`IN_PROGRESS` ticket in the week is incomplete; Calculate stays allowed `[UNVERIFIED]`

- **Statement:** Approve (per employee and per period) is refused while any ticket belonging to
  that employee-week is `PENDING`, `SENT` or `IN_PROGRESS` (i.e. neither `COMPLETE` nor voided,
  REQ-06). **A `REJECTED` ticket never blocks Approve** — per Q6, it does not count as incomplete
  for this rule at all. Calculate is unaffected and continues to compute and display the week
  with its pending tickets shown, as it does today. **A ticket belongs to the week of its Start
  Ticket date, in Pacific time** (per Q7) — an unstarted ticket, which has no Start Ticket
  capture yet, belongs to its scheduled date's week, matching how the existing pending-ticket
  overlay already resolves a work date today.
- **Surface:** api, web
- **Sources:**
  - `decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md`
    — `[VERIFIED]` — kind: decision — Corrina Bustos, verbatim: *"no, all tickets must be
    completed before the payroll can be processed/approved."* The decision's own body: *"An
    incomplete ticket blocks the week."*
  - Same decision, *Not decided* item 1 — `[VERIFIED]` (as to leaving it open) — kind: decision —
    *"Does an incomplete ticket also block Calculate (processing), or only approval?"* is
    explicitly unresolved by Corrina's own reply.
  - `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` item C7 —
    `[UNVERIFIED]` — kind: decision (`status: reference`, **pending Corrina**) — *"it blocks
    Approve only. Calculate stays allowed."* This is the developer's reading of her word
    "processed", not her own statement.
  - `decisions/2026-09-10-pending-tickets-are-a-display-only-payroll-overlay.md` clause 6 —
    `[UNVERIFIED]` — kind: decision (`reference`) — *"A week carrying an open entry should warn
    before approval… whether it also blocks is explicitly not settled here."* Superseded on the
    blocking question by the verified 2026-09-30 note above; its other five clauses (computed at
    read time, never written to `payroll_job_days`, etc.) are untouched and still govern how the
    overlay itself works.
  - `payroll/gaps.md` → *Which payroll issues block approval (PAY-065)* — `[UNVERIFIED]` — kind:
    vault — records the same sequence and that sub-question 1 ("processed/approved") stays open.
  - `apps/api/src/usecase/payroll/payroll.service.ts:855` (`approveEmployee`), `:892`
    (`approvePeriod`), `:821` (`assertNoOpenSendBacks`, the existing precedent for a
    period-or-employee-list guard called from both entry points) — kind: code — the exact
    pattern this requirement's `assertNoIncompleteTickets` is to follow.
  - `apps/api/src/usecase/payroll/payroll-approval-gate.ts:19` (`PAYROLL_APPROVAL_BLOCKED_CODE`),
    `:58` (`blockingIssuesForWeek`) — kind: code — the existing 400-error shape this requirement's
    new blocker should extend, per the plan.
  - **Developer direction, devmohsinakram, 2026-09-30, relayed in this session** — `[UNVERIFIED]`
    — kind: reference, not yet in `.ai/vault/` — answering Q6: *"NOT incomplete. A `REJECTED`
    ticket never blocks Approve and needs no void."* Answering Q7: *"the START TICKET WEEK
    (Pacific). A ticket not started yet belongs to its scheduled date's week, the same as the
    pending-ticket overlay today."*
- **Conflict:** none
- **Open question:** none — **resolved, Q6 and Q7** (see Sources).
- **Ripple:** see §11a rows 6–7. `apps/web/src/features/payroll/components/payroll-employee-daily.tsx:77-97`,
  `PayrollIncompleteBanner` — kind: code — today reads, per the plan's description confirmed by
  file existence, "Warns; never blocks." This is named directly by source as needing to become a
  blocking banner that offers Void (REQ-06) and disables Approve. `use-bulk-approve.ts` and
  `approval-blocked-error.ts` (`apps/web/src/features/payroll/`) already parse
  `PAYROLL_APPROVAL_BLOCKED`'s `openFlags`-shaped body for the existing send-back gate — kind:
  code — the same parsing needs to grow an `incompleteTickets[]` case.
- **Acceptance:** an employee-week with any `PENDING`/`SENT`/`IN_PROGRESS` ticket **whose Start
  Ticket date (Pacific), or scheduled date if unstarted, falls in that week** is refused on
  `approveEmployee`/`approvePeriod` with `PAYROLL_APPROVAL_BLOCKED` and an `incompleteTickets[]`
  list; a `REJECTED` ticket in the same week does not trigger this refusal; the same week's
  `calculate` call succeeds and returns the overlay as it does today.
- **Notes for the executor:** `assertNoIncompleteTickets(period, employeeIds | null)` built on
  `findWeekOverlayTickets` + `buildWeekEntry`, called from both `approveEmployee` and
  `approvePeriod` (all-or-nothing for the period), mirroring `assertNoOpenSendBacks`'s existing
  signature. **Filter out `REJECTED` rows from whatever this returns before treating the
  remainder as "incomplete"** — per Q6, `findWeekOverlayTickets`'s own status set includes
  `REJECTED` for *display* purposes, which is broader than what should block Approve. **The
  cross-week ownership question (Q7) is now resolved as "reuse the existing date-range/work-date
  logic as-is"** — what this spec's first pass called a workaround is now the confirmed answer,
  not a placeholder; no change to `findWeekOverlayTickets`'s date resolution is needed for this
  requirement specifically.

### REQ-08 — A "Remind" action for an incomplete ticket's primary worker `[UNVERIFIED]`

> **Restored to scope.** A prior fold-in of this spec misread the coordinator's Q4 answer
> ("Worker reminders are out of scope for U1–U5") as covering this requirement, and marked it
> `[OUT OF SCOPE]`. The coordinator has since clarified that sentence meant the **Send Back**
> flow's 3-hour-repeating reminder (U12, still out of scope, unaffected by this correction) —
> never U4's own Remind button, which the developer confirmed is part of U4 as planned. This
> block is rewritten back to a built requirement; the corrected sourcing is below.

- **Statement:** Payroll can trigger a reminder notification to an incomplete ticket's primary
  worker, replacing today's disabled stub. The worker receives it through their existing
  notification channels — in-app, push (mobile), and email.
- **Surface:** api, web (the action is triggered from the payroll web UI; delivery to the worker
  reaches mobile through the existing shared notification infrastructure — no new mobile screen
  or code is implied by this requirement)
- **Sources:**
  - `/tmp/.../scratchpad/plan-u1-u5.md`, **U4's own stated Goal** — `[UNVERIFIED]` — kind:
    reference — *"Approve, for one employee or the whole period, is refused while any ticket in
    the week is neither completed nor voided. Calculate still runs and shows those tickets, **and
    payroll can send the worker a real reminder**."* This action was part of U4's scope in the
    plan from the start; the original fold-in undercited it as merely "the plan's proposal."
  - Developer direction, devmohsinakram, 2026-09-30 — `[UNVERIFIED]` — kind: reference, not yet in
    `.ai/vault/` — blanket approval to *"work on all u1 to u5"*, confirming U4 (including its
    Remind action) is built as the plan scoped it, and the later clarification narrowing
    "worker reminders … out of scope" to mean Send Back's U12 mechanics specifically, not this
    action.
  - `apps/web/src/features/payroll/hooks/use-payroll-employee.ts:300` — kind: code — `remind: ()
    => toast.info('Reminders are not wired to the payroll API yet')` — confirms the stub exists
    and is currently a no-op.
  - Developer direction, devmohsinakram, 2026-09-30 — `[UNVERIFIED]` — kind: reference — the
    channel: *"the crew's reminder goes to the crew through their existing notification
    channels (in-app/push on mobile, plus email)."* Distinct from Q4's channel answer for
    payroll-side notices (REQ-06, REQ-13), which is in-app + email without push — this is the
    worker-facing equivalent, and push is added because the crew's primary surface is mobile.
  - Corrina's own reminder request (2026-08-04, *"Is there a way we can set up like an auto
    reminder if they haven't replied?"*) is about the **Send Back** flow (U11/U12, still out of
    scope, and already answered there as "every 3 hours, to the worker") — not about this
    incomplete-ticket action. The two remain separate flows answering separate questions; only
    U4's own goal text sources this one.
- **Conflict:** none
- **Open question:** none.
- **Ripple:** `none — wires an existing disabled stub to a new endpoint (established by: reading
  use-payroll-employee.ts:300)`.
- **Acceptance:** delivered in-app, push (mobile) and email to the ticket's primary worker.
  `NOT SPECIFIED` beyond that — no source states the notification's exact copy, or whether it
  repeats. Build it as a single on-demand send (one click, one notification); nothing supports
  the 3-hour repeat used by the separate Send Back flow, and conflating the two remains
  unsourced.
- **Notes for the executor:** Wire to `POST /v1/payroll/periods/:id/tickets/:ticketId/remind`,
  `@RequirePermission('payroll-admin', 'edit')` per REQ-01/REQ-02, pushing to the ticket's primary
  employee (existing `TicketEmployee.isPrimary` concept, per schema) via the shared
  notification dispatch (`IN_APP` + `PUSH` + `EMAIL`). Do not reuse the Send Back 3-hour repeat
  mechanism for this without a source — they are different flows answering different questions.

### REQ-09 — Durable `PayrollFlag` / `PayrollFlagEvent` schema, reconciled per period at Calculate `[UNVERIFIED]`

- **Statement:** Calculate (`executeRun`) writes durable, per-period flags to a new store rather
  than computing them only at read time. A flag is opened the first time its condition is found,
  stays open across recalculations while the condition persists, is closed automatically
  (`FIXED`) when the condition disappears, and is closed by a human via REQ-12
  ("reviewed, no change"). Every state change is recorded as an event.
- **Surface:** schema, api
- **Sources:**
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` — `[VERIFIED]`
    — kind: decision — establishes flags exist, block approval, and are cleared by fixing or by
    review — but says **nothing about storage mechanism**: durable table vs. computed at read
    time is not discussed anywhere in any decision.
  - `plan-u1-u5.md` overview — `[UNVERIFIED]` — kind: reference (the planner's own words,
    explicitly self-identified) — *"One design choice departs from the wording of the 2026-09-30
    decision: flags live in their own table, and every open flag blocks approval
    unconditionally… The verified rule is that all flags block, so nothing should be able to
    switch a flag off per tenant."* This is a CodingCops design choice reached because the
    verified decision requires flags to be unconditional and per-tenant-configurable blocking
    (the existing `payroll_approval_blocking_issues` mechanism, see REQ-11) is the wrong shape
    for that — not something any source asked for by name.
  - `apps/api/prisma/schema.prisma` `model PayrollSendBack` (line 5337) — kind: code — the
    closest existing analog: a workflow/audit record with a UUID `id` and **no per-tenant
    business code** (`@@unique([tenantCompanyId, <code>])` is absent from it). Cited as precedent
    for `PayrollFlag` also carrying no business code — see §3.
  - `apps/api/src/usecase/payroll/payroll.service.ts:377` (`executeRun`) — kind: code — the
    existing method this requirement's detection pass hooks onto the end of.
- **Conflict:** none
- **Open question:** none directly (the storage-mechanism choice is design, not a product fact
  in dispute), but it is called out above rather than stated as settled, per elaborator rules on
  unsourced detail.
- **Ripple:** see §11a row 8. `apps/web/src/features/payroll/components/*` already has a `FLAGGED`
  `EmployeeStatusChip`/`PayrollEmployeeWeekStatus` value (`packages/shared/src/enums/index.ts:152`,
  consumed in `payroll-worklist-filters.tsx`, `payroll-employee-table.tsx`,
  `payroll-format.ts`) that today is set by `RATE_*` issues, per the plan's description — a name
  collision with this requirement's new flags. The plan proposes relabeling the existing status
  "Rate issue" in the UI to end the collision; no source objects, and no source asked for the
  relabel either — it is a consequence of adding this requirement, not a separate product ask.
- **Acceptance:** re-running Calculate on a period with an unchanged flagged condition does not
  duplicate the flag or its history; a condition that disappears between runs marks the flag
  `FIXED` automatically; a `REVIEWED_NO_CHANGE` flag whose underlying values are unchanged
  (same fingerprint) stays cleared across a recalculation; a changed fingerprint reopens it.
- **Notes for the executor:** `PayrollIssue` (the existing `payroll_approval_blocking_issues`
  table) is unchanged by this requirement — it is a parallel, older mechanism for a different set
  of codes (`NO_ADP_FILE`, `RATE_*`), see REQ-11's note on why the nine flags are not added to it.

### REQ-10 — `OVERLAPPING_JOBS` flag detector — raw Start Ticket→End Ticket window overlap `[UNVERIFIED]`

- **Statement:** Calculate raises an `OVERLAPPING_JOBS` flag (REQ-09's framework) when an
  employee's two tickets' raw windows — Start Ticket through End Ticket — overlap in time. This
  is the same raw-window basis the engine's existing `flagOverlappingLabor` check already uses,
  per Q1.
- **Surface:** api
- **Sources:**
  - `decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md`
    clause 6 — `[VERIFIED]` — kind: decision — Corrina's own words list *"overlapping jobs"* as
    an auto-flag source.
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` item 2 —
    `[VERIFIED]` — kind: decision — *"Overlapping jobs… Her words, 2026-09-29"* — confirmed again
    as flag #2 of nine, and that it blocks.
  - `packages/payroll-engine/src/calculate.ts:533` (`flagOverlappingLabor`), `:560`
    (`code: 'OVERLAPPING_LABOR'`), called at `:1023` — kind: code — the existing engine-level
    overlap check this detector is specified (by the plan) to mirror, keeping both ticket ids
    this time.
  - **Developer direction, devmohsinakram, 2026-09-30, relayed in this session** — `[UNVERIFIED]`
    — kind: reference, not yet in `.ai/vault/` — answering Q1: *"RAW WINDOWS. They overlap when
    one entry's Start Ticket→End Ticket window overlaps another's, matching the engine's existing
    check."* This settles the basis and confirms it matches `flagOverlappingLabor`'s own raw-window
    approach, rather than the legacy "rounded end" rule that was the other candidate.
- **Conflict:** none
- **Open question:** none — **resolved, Q1** (see Sources).
- **Ripple:** see §11a row 9. **The engine's existing `OVERLAPPING_LABOR` warning is unchanged
  by this requirement** — confirmed by the plan explicitly and consistent with nothing in any
  source asking to remove or alter it: `grep -rln "OVERLAPPING_LABOR"
  packages/payroll-engine/src apps/api/src apps/web/src` shows it consumed only in
  `calculate.ts` and two spec files today; no web surface renders it, so there is nothing for
  this new, separate `PayrollFlag` row to visually collide with.
- **Acceptance:** two tickets whose raw Start Ticket→End Ticket windows for the same employee
  overlap produce one `OPEN` `PayrollFlag` with `code: 'OVERLAPPING_JOBS'` naming both ticket
  ids; back-to-back tickets with a zero-minute gap do not flag (per PAY-029, matching the
  existing engine check's own back-to-back exclusion).
- **Notes for the executor:** Build against the raw-window basis — this is now the confirmed
  answer (Q1), not a proposed default. Mirror `flagOverlappingLabor`'s own back-to-back exclusion
  exactly, since Q1 explicitly ties this detector's basis to "the engine's existing check."

### REQ-11 — Approval gate refuses while any flag is `OPEN`, unconditionally `[UNVERIFIED]`

- **Statement:** `approveEmployee` and `approvePeriod` refuse (after the existing send-back and
  incomplete-ticket holds) while any `PayrollFlag` for that employee-week is `OPEN`. This
  blocking is unconditional — it is not a per-tenant setting, and open flags are not added to
  the existing `payroll_approval_blocking_issues` table.
- **Surface:** api
- **Sources:**
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` — `[VERIFIED]`
    — kind: decision — *"yes all of these will need to be adjusted and fixed before the payroll
    can be approved"* — every one of the nine flags blocks. Only two of the nine (`OVERLAPPING_JOBS`
    via REQ-10) are built in this ticket; the requirement's blocking mechanism is written to
    cover whichever flags exist.
  - `plan-u1-u5.md` — `[UNVERIFIED]` — kind: reference — the "not added to
    `payroll_approval_blocking_issues`" design choice, reasoned from the verified decision that
    blocking is unconditional against the fact that `payroll_approval_blocking_issues` is a
    per-tenant, editable list (see `payroll/gaps.md` → PAY-065, sub-question 1: *"there is no API
    or UI for `payroll_approval_blocking_issues` today; it takes a direct DB update"*, and the
    table exists precisely so a tenant's blocking list can differ). No source states this
    conclusion explicitly; it is this spec's (and the plan's) inference from combining two
    verified/vault facts, flagged as such rather than asserted as settled.
  - `apps/api/src/usecase/payroll/payroll-approval-gate.ts:58` (`blockingIssuesForWeek`),
    `apps/api/prisma/schema.prisma` `model PayrollIssue` (line 5570), `@@map("payroll_approval_blocking_issues")`
    — kind: code — the existing, separate mechanism this requirement deliberately does not
    extend.
- **Conflict:** none
- **Open question:** none directly — the "unconditional, separate mechanism" design is called
  out as an inference above rather than asked as a question, because no plausible one-line
  question would resolve it; it is architecture, not an unanswered fact.
- **Ripple:** see §11a row 10. Reuses the same `PAYROLL_APPROVAL_BLOCKED_CODE` error shape as
  REQ-07's incomplete-ticket gate and the existing send-back gate — three holds compose on the
  same two entry points (`payroll.service.ts:855`, `:892`), in whatever order the executor finds
  cleanest; no source orders them, `NOT SPECIFIED`.
- **Acceptance:** an employee-week with any `OPEN` `PayrollFlag` cannot be approved; the response
  names the open flags (`openFlags[]`); a tenant cannot configure a flag code as non-blocking.
- **Notes for the executor:** `PayrollIssue` and its seed constants
  (`DEFAULT_PAYROLL_APPROVAL_BLOCKING_ISSUES` in `packages/shared/src/constants/payroll-issue-severity.ts`)
  are untouched by this ticket.

### REQ-12 — "Reviewed, no change" clears a flag — required note, audited, Payroll Admin/Manager only `[UNVERIFIED]`

- **Statement:** A Payroll Admin or Payroll Manager can mark an `OPEN` `PayrollFlag` (any flag
  type, including one from a future detector) `REVIEWED_NO_CHANGE` with a required note. The
  action is recorded as an audit event. The week can then be approved despite that flag, unless
  its fingerprint (the underlying values) changes on a later recalculation, which reopens it.
- **Surface:** api, web
- **Sources:**
  - `decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md`
    — `[VERIFIED]` — kind: decision — Corrina Bustos, answering *"Should you be able to mark it
    'reviewed, no change' so the week can still be approved?"*: *"yes that would be a good
    option."* This settles the action exists and that the week can then be approved. It does not
    say whether a note is required, who may do it beyond "you" (unclear if that means Corrina
    personally or payroll generally), or the audit trail — its own *Not decided* item 4 lists
    exactly those three as open.
  - `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` item C2 —
    `[UNVERIFIED]` — kind: decision (`status: reference`, developer mechanics filling the gap
    above, not independently ratified) — *"a note is required… the action is audited… only the
    Payroll Admin / Payroll Manager may do it… it is available for every flag type."* The note's
    own standing line calls this "settled" because it fills mechanics a verified decision left
    open and goes no further than Corrina's own words — but the note-required/audited/roles
    specifics are still the developer's choices, not quotes from Corrina.
- **Conflict:** none
- **Open question:** none directly.
- **Ripple:** `none — new action on a new entity (REQ-09), no prior consumer`.
- **Acceptance:** `POST /v1/payroll/flags/:flagId/review {note}` refused without `note`; refused
  to anyone below `payroll-admin: edit`; refused on an `APPROVED` week (per the plan; no source
  contradicts it and it is consistent with "review clears the way to approve," not "review
  reopens an approved week"); clears every flag sharing the target flag's `groupKey` (a condition
  affecting several people at once) in one action, per the plan's proposed schema — `NOT
  SPECIFIED` by any source whether group-clearing is required or merely convenient; build it as
  proposed since nothing contradicts it.
- **Notes for the executor:** `PayrollFlagEvent` (REQ-09) records `action:
  REVIEWED_NO_CHANGE`, `note`, `actorUserId`, `at`.

### REQ-13 — Flag routing/notification to Payroll Admin and Payroll Manager, in-app and email `[UNVERIFIED]`

- **Statement:** When Calculate raises a new or reopened flag, every Payroll Admin and Payroll
  Manager holder (REQ-02) is notified **in-app and by email**, once per run, with counts of new
  and reopened flags.
- **Surface:** api, shared (a new `NotificationType`)
- **Sources:**
  - `decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md`
    and `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` —
    `[VERIFIED]` — kind: decision — both settle *who*: Payroll Admin and Payroll Manager, not the
    crane superintendent.
  - `decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md`
    *What this changes* — `[VERIFIED]` (as to leaving it open) — kind: decision — *"Clause 5 (the
    supervisor is notified in-app and by email): overruled as to who is told. The recipients are
    the payroll admin and the payroll manager. How they are told (in-app, email, or both) is not
    stated."*
  - `packages/shared/src/types/notification.types.ts` `NOTIFICATION_TYPES` (lines 5-45) — kind:
    code — confirms only `payroll.entry_sent_back` and `payroll.entry_corrected` exist today for
    payroll; `payroll.flags_raised` would be a new addition, following the existing
    dot-namespaced convention.
  - **Developer direction, devmohsinakram, 2026-09-30, relayed in this session** — `[UNVERIFIED]`
    — kind: reference, not yet in `.ai/vault/` — answering Q4: *"IN-APP AND EMAIL, for new flags
    to Payroll Admin/Manager and for void notices. Worker reminders are out of scope for U1–U5."*
    The second sentence is why REQ-08 is removed (see that REQ) — worker-facing notifications are
    a different question from this one, about Payroll Admin/Manager's own notifications.
- **Conflict:** none
- **Open question:** none — **resolved, Q4** (see Sources).
- **Ripple:** `none — new NotificationType, additive to an existing const array (established by:
  reading notification.types.ts in full, 81 lines)`.
- **Acceptance:** every Payroll Admin/Manager holder receives **both** an in-app notification and
  an email once per Calculate run that raises or reopens a flag, with counts of new and reopened
  flags.
- **Notes for the executor:** Build both `IN_APP` and `EMAIL` channels — no longer a
  smallest-slice default, Q4 confirms both are wanted from the start.

### REQ-14 — Web: flags panel, timesheet chips, worklist KPI/filter, review dialog, audit log, sidebar count `[UNVERIFIED]`

- **Statement:** The payroll web app surfaces REQ-09–REQ-13's flags: a flags panel on the
  employee payroll page, flag indicators in the timesheet, an "Open flags" KPI and filter on the
  worklist, the "reviewed, no change" dialog (REQ-12), flag events in the payroll audit log, and
  a count for Payroll Admin/Manager holders in navigation.
- **Surface:** web
- **Sources:**
  - No source specifies this screen-by-screen; it is the necessary web surface for REQ-09–REQ-13
    to be usable, per the plan's proposed layout (`apps/web/src/features/payroll-flags/`,
    `payroll-employee-table.cells.tsx`, `payroll-worklist-kpis.tsx`,
    `payroll-worklist-filters.tsx`, `payroll-audit-log.tsx`) — kind: reference (design, not
    product fact).
  - `.ai/claude/contexts/web.md` → *Test IDs* — kind: rule — every new control ships with a
    `data-testid`, per the standing convention (binding on how, not on what).
- **Conflict:** none
- **Open question:** none directly; inherits REQ-09–REQ-13's open items.
- **Ripple:** see §11a row 11. This is new UI, but it changes two existing surfaces: the
  `PayrollEmployeeWeekStatus.FLAGGED` relabel from REQ-09's ripple note, and the worklist filter
  set (`payroll-worklist-filters.tsx`'s existing `EmployeeStatusChip` union) gaining a new "Open
  flags" facet alongside the existing `NEEDS_REVIEW`/`FLAGGED`/`APPROVED`/`SENT_BACK` chips.
- **Acceptance:** `NOT SPECIFIED` for exact copy and layout; functionally, a Payroll Admin/Manager
  can see every open flag for a period, act on one (fix elsewhere in the app, or REQ-12's
  review), and see the audit trail of what happened to a resolved one.
- **Notes for the executor:** Reuse `PageHero`, `SectionCard`, `WorkspaceTable` per the standing
  web conventions; search all nine `components/` directories before adding anything new, per
  `.ai/claude/contexts/web.md`.

---

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** yes — for REQ-06 (`JobTicket` columns, `PayrollTicketClosure`) and
  REQ-09 (`PayrollFlag`, `PayrollFlagEvent`) only.
- **Migration required:** yes for REQ-06 and REQ-09 — `pnpm db:migrate`, committed under
  `apps/api/prisma/migrations/`, per `.ai/claude/contexts/prisma.md`.
  **REQ-01 no longer needs a data migration, per Q3's answer.** The earlier version of this
  section called for a tenant backfill granting `ROLE-ACCOUNTS-PM` `payroll-admin: 'full'` and
  inserting a new `ROLE-ACCOUNTS-PA` role — that design is superseded (see REQ-01). REQ-01 is now
  a constants/seed-code change only: adding `'payroll-admin'` to `PERMISSION_MODULES` and
  `USER_RESTRICTED_MODULES`. `NOT SPECIFIED` whether a schema-level backfill is still needed to
  add an explicit `payroll-admin: 'none'` key to every existing role's `permissions` JSON —
  depends on whether the permission-check code already treats an absent key the same as `'none'`
  (the ordinary case whenever a new module is added to a live system with existing tenants); this
  spec did not verify that code path and flags it for the executor to confirm before assuming
  either way.
- **Data backfill required:** yes for REQ-06/REQ-09's new columns/tables (none needed, just
  created empty). `NOT SPECIFIED` for REQ-01, per above.

```prisma
// JobTicket gains (REQ-06):
model JobTicket {
  // ...existing fields unchanged...
  payrollClosedAction PayrollTicketClosure? @map("payroll_closed_action")
  payrollClosedAt     DateTime?             @map("payroll_closed_at") @db.Timestamptz()
  payrollClosedByUserId String?             @map("payroll_closed_by_user_id") @db.Uuid
  payrollCloseNote    String?               @map("payroll_close_note") @db.Text
}

enum PayrollTicketClosure {
  VOIDED
  // COMPLETED is the U10 "payroll completes a ticket" action — out of scope for
  // this ticket (REQ-06 builds VOIDED only). Included in the enum now, per the
  // plan, so a later ticket does not need an enum migration; no source requires
  // this pre-inclusion, it is NOT SPECIFIED whether to build it now vs. defer the
  // whole enum to U10.
  COMPLETED
}

// New tables (REQ-09):
model PayrollFlag {
  id               String            @id @default(uuid()) @db.Uuid
  tenantCompanyId  String            @map("tenant_company_id") @db.Uuid
  periodId         String            @map("period_id") @db.Uuid
  employeeId       String            @map("employee_id") @db.Uuid
  jobTicketId      String?           @map("job_ticket_id") @db.Uuid
  assetId          String?           @map("asset_id") @db.Uuid   // future flags (U6+), unused by REQ-10
  workDate         DateTime?         @map("work_date") @db.Date
  code             String            @db.VarChar(50)             // e.g. 'OVERLAPPING_JOBS'
  subjectKey       String            @map("subject_key")
  groupKey         String?           @map("group_key")
  fingerprint      String
  status           PayrollFlagStatus @default(OPEN)
  message          String            @db.Text
  detail           Json?             @db.JsonB
  firstRaisedRunId String            @map("first_raised_run_id") @db.Uuid
  lastSeenRunId    String            @map("last_seen_run_id") @db.Uuid
  resolvedAt       DateTime?         @map("resolved_at") @db.Timestamptz()
  resolvedByUserId String?           @map("resolved_by_user_id") @db.Uuid
  resolutionNote   String?           @map("resolution_note") @db.Text

  @@unique([tenantCompanyId, periodId, code, employeeId, subjectKey], name: "uq_payroll_flags_tenant_period_code_employee_subject")
  @@map("payroll_flags")
}

enum PayrollFlagStatus {
  OPEN
  FIXED
  REVIEWED_NO_CHANGE
}

model PayrollFlagEvent {
  id        String   @id @default(uuid()) @db.Uuid
  flagId    String   @map("flag_id") @db.Uuid
  action     PayrollFlagEventAction
  note       String?  @db.Text
  actorUserId String? @map("actor_user_id") @db.Uuid
  runId      String?  @map("run_id") @db.Uuid
  snapshot   Json?    @db.JsonB
  at         DateTime @default(now()) @db.Timestamptz()

  @@map("payroll_flag_events")
}

enum PayrollFlagEventAction {
  RAISED
  REOPENED
  FIXED
  REVIEWED_NO_CHANGE
}
```

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| `PayrollFlag` | none proposed | n/a | n/a | REQ-09 — see below |
| `PayrollFlagEvent` | none proposed | n/a | n/a | REQ-09 — see below |
| `JobTicket` (existing) | `ticketCode` | (unchanged by this ticket) | (unchanged) | — |

- **New prefix introduced:** no. **`NOT SPECIFIED` whether `PayrollFlag` needs a per-tenant
  business code at all** under the Identity Convention ("every business entity carries… a
  prefixed business code"). No source states one is needed. The closest existing precedent,
  `PayrollSendBack` (`apps/api/prisma/schema.prisma:5337`) — a similarly system-generated,
  workflow-audit table built recently for an adjacent feature — has **no** business code, only a
  UUID `id`. This spec proposes following that precedent (no code) rather than inventing a
  prefix, but flags it explicitly since the Identity Convention is a rule that would otherwise
  apply by default.
- **Child relations:** `PayrollFlag.jobTicketId`/`assetId`/`employeeId` reference parent UUIDs,
  never codes, per convention. `PayrollFlagEvent.flagId` likewise.
- **Fields whose type/precision no source states:** `PayrollFlag.message` and `.detail` shape —
  `NOT SPECIFIED` beyond "human-readable text plus structured detail," per the plan's proposal.
  `JobTicket.payrollCloseNote` length — `NOT SPECIFIED`, no source gives a limit; treat as
  unbounded `Text` per the pattern `PayrollSendBack.correctionNote` already uses.

## 4. API surface — `apps/api`

Layering is `presentation → usecase → service → orm`, never upward, per `CLAUDE.md` and
`.ai/claude/contexts/api.md`.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/v1/payroll/periods/:id/tickets/:ticketId/void` | `payroll.controller.ts` | `payroll.service.ts` | `payroll.repository.ts` | REQ-06 |
| `POST` | `/v1/payroll/periods/:id/tickets/:ticketId/remind` | `payroll.controller.ts` | `payroll.service.ts` | `payroll.repository.ts` | REQ-08 |
| `GET` | `/v1/payroll/periods/:id/flags?employeeId&status` | `payroll-flags.controller.ts` (new) | `payroll-flag-detection.service.ts` (new) | (new) | REQ-09, REQ-14 |
| `GET` | `/v1/payroll/flags/:flagId` | `payroll-flags.controller.ts` | (new) | (new) | REQ-09, REQ-14 |
| `POST` | `/v1/payroll/flags/:flagId/review` | `payroll-flags.controller.ts` | (new) | (new) | REQ-12 |
| (existing, guard changed only) | `.../employees/:employeeId/approve`, `.../periods/:id/approve`, `.../employees/:employeeId/export`, `.../periods/:id/export`, `.../periods/:id/export.csv` | `payroll.controller.ts` | `payroll.service.ts` | — | REQ-03 |

Per endpoint:

- **Request DTOs:** `void-ticket.dto.ts {note: string}` (REQ-06), `review-flag.dto.ts {note:
  string}` (REQ-12) — both `note` required by `class-validator` `@IsNotEmpty()`, per the
  respective decisions' required-note requirement. No source states a max length —
  `NOT SPECIFIED`.
- **Response shape:** flags list/detail responses — `NOT SPECIFIED` exact JSON shape beyond what
  the schema in §3 implies; build to match the existing `PayrollSendBack` response conventions
  in the same controller file, per code convention, not a sourced contract.
- **Guards / roles:** `AccessTokenGuard` (global) + `@RequirePermission('payroll-admin', 'edit')`
  on void, remind and review; `@RequirePermission('payroll-admin', 'view')` on the two `GET`
  flag routes; the five narrowed routes (REQ-03) — mechanism `NOT SPECIFIED`, see REQ-03's notes.
- **Route param identity:** period and ticket ids are already UUIDs on the boundary in the
  existing controller (not business codes) — unchanged pattern, continue it.
- **Errors:** void refused (409 or 400, `NOT SPECIFIED` which) on a ticket not in
  `{PENDING, SENT, IN_PROGRESS}` — `REJECTED` and `COMPLETE` both refused, per Q6; review refused
  (400) without a note or on an `APPROVED` week; approve/export refused (403) without
  `payroll-admin`.
- **Module registration:** new `payroll-flags` module registered in `app.module.ts`; barrel
  `index.ts` in every new folder, per `CLAUDE.md`.

## 5. Web surface — `apps/web`

**Feature-first, not atomic design**, per `.ai/claude/contexts/web.md`.

- **Routes:** no new top-level route; new UI lands inside the existing `/payroll` and
  `/payroll/[employeeId]` feature area (REQ-14), plus the existing `/departments` role editor
  gaining the `payroll-admin` module label (REQ-01).
- **Existing components to reuse** *(checked before proposing anything new)*: `PageHero`,
  `SectionCard`, `WorkspaceTable`, `useWorkspaceTableControls` — per the plan's proposed file
  list and the standing convention; not independently re-verified file-by-file beyond what §2's
  Ripple entries already confirm exist (`payroll-worklist-filters.tsx`,
  `payroll-employee-table.tsx`, `payroll-rest-audit.tsx`, `payroll-employee-daily.tsx`, all
  confirmed present).
- **New components proposed:** a flags panel, flag chips, a review dialog, an "Open flags"
  KPI/filter — REQ-14. No source specifies these individually; they are the smallest UI needed
  to make REQ-09–REQ-13 usable, per the plan.
- **Table (if any):** the existing payroll worklist table gains an "Open flags" filter facet
  alongside its current `EmployeeStatusChip` set (`NEEDS_REVIEW`/`FLAGGED`/`APPROVED`/`SENT_BACK`)
  — exact `searchPlaceholder` wording `NOT SPECIFIED`.
- **Forms:** the void and review note fields are react-hook-form + Zod v4 per convention;
  `NOT SPECIFIED` field-level validation beyond "required, non-empty."
- **Server state:** TanStack Query v5; query keys/invalidation `NOT SPECIFIED` — follow existing
  payroll feature patterns (e.g. how send-back mutations invalidate the worklist today).
- **Colors / spacing:** theme variables only, no hardcoded colors, per convention.
- **Responsive:** mobile-first web; 44px touch targets, per convention.
- **Copy:** `NOT SPECIFIED` throughout — no source supplies exact UI strings for any new control
  in this spec; do not invent product copy beyond functional labels already used elsewhere in
  the codebase (e.g. "Void", "Reviewed, no change").

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** no new screen. REQ-06 touches the existing ticket dashboard partition
  logic and, per the plan, the ticket-flow store / background-sync draft-discard path when a
  server ticket is voided.
- **Components:** a notice that a ticket was voided by payroll is now confirmed to exist (Q5: "an
  in-app/email notice"), but its exact on-screen wording is still `NOT SPECIFIED` — Q5 confirms
  *that* the crew is told, not the copy.
- **Offline / sync behavior:** `apps/mobile/data/hooks/use-tickets.ts:58-71`
  (`partitionDashboardTickets`) already excludes `CANCELLED` tickets from the active partition —
  existing behavior, confirmed by reading the function, unchanged by this ticket. Whether
  `ticket-flow.store`/background-sync need to actively discard an in-flight draft against a
  ticket that becomes `CANCELLED` mid-session (rather than simply not re-surfacing it) is
  `NOT SPECIFIED` — the plan proposes it; no source confirms the current sync behavior handles
  this case today one way or the other, and this spec did not independently trace the
  background-sync code to verify the plan's specific claim about "queued step ops stop retrying
  against the terminal guard."
- **Touch targets:** 48px, per convention, if any new control is added.
- **Push / notifications involvement:** `payroll.ticket_voided` (REQ-06) — catalog entry per
  REQ-13's notification-type pattern; channel is **in-app and email** (Q4, resolved), not a native
  mobile push specifically. `NOT SPECIFIED` whether the app's existing `IN_APP` notification
  mechanism additionally triggers an OS-level push on mobile per today's implementation — that is
  an existing-mechanism detail, not a product question this spec re-opens.

## 7. Shared package — `packages/shared`

- **Types added / changed:**
  - `PERMISSION_MODULES` gains `'payroll-admin'` (REQ-01), consumed by web, api and mobile
    wherever the permission-module list is enumerated.
  - `NOTIFICATION_TYPES` gains `payroll.ticket_voided` (REQ-06) and `payroll.flags_raised`
    (REQ-13), both delivered `IN_APP` and `EMAIL` (Q4, to Payroll Admin/Manager and the crew
    respectively), and `payroll.ticket_incomplete_reminder` (REQ-08), delivered `IN_APP`,
    `PUSH` and `EMAIL` to the worker — consumed by web and mobile's notification-rendering code,
    wherever it switches on `NotificationType`. `NOT SPECIFIED` whether that switch has a
    default/fallback case today; not independently checked.
  - `PAYROLL_FLAG_CATALOG` (new constant, `packages/shared/src/constants/payroll-flags.ts`) —
    per-code title/number/subject for the flags this and future units build — proposed by the
    plan; no source requires this exact shape, `NOT SPECIFIED` beyond "some shared lookup by
    code, since both api and web need the same flag metadata."
  - `PayrollEmployeeWeekStatus.FLAGGED` (`packages/shared/src/enums/index.ts:152`) — unchanged
    enum member, relabeled only in web display copy (see REQ-09's ripple note); not a shared-type
    change.

## 8. Permissions and tenancy

- **Roles permitted:**
  - REQ-06 (void), REQ-08 (remind), REQ-12 (review): `payroll-admin` at `edit` or `full`.
  - REQ-03 (approve/export): `payroll-admin` at `edit` or `full`, narrowed from `payroll:edit`.
  - Flag read endpoints (REQ-09/14): `payroll-admin` at `view` or above.
- **Roles denied:** every role not holding `payroll-admin` — **which, per Q3, is every role in a
  fresh tenant, including Payroll Manager, until a tenant admin deliberately grants it** via
  Departments. This is the significant behavior change, not an incidental detail — see REQ-01 and
  REQ-03's Notes for the executor.
- **Tenant isolation:** standard — every new query scoped by `tenantCompanyId` via the existing
  Prisma client-extension convention (`.ai/claude/contexts/prisma.md`); no exception identified
  or sourced for any new table here.
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| `void-ticket.dto.ts note` | required, non-empty | `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` item C8 | `[UNVERIFIED]` |
| `review-flag.dto.ts note` | required, non-empty | `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` item C2; `decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md` | `[UNVERIFIED]` |
| `note` max length (either) | `NOT SPECIFIED` — no source states a limit | — | — |
| `payroll-admin` permission levels | `view` / `edit` / `full`, matching every other module | `packages/shared/src/constants/permissions.ts` (code, existing pattern) | `[UNVERIFIED]` |

Invented validation is still invention. A max length nobody wrote down is `NOT SPECIFIED`.

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | `applyRestPeriodPremium` gap-start math (11:00 PM + 2nd-meal WTL → 11:30 PM; 1st meal → unchanged; 2nd+3rd meals → cumulative 60 min) | REQ-04 |
| Unit | Flag reconciliation: same fingerprint stays cleared; changed fingerprint reopens; disappeared condition auto-`FIXED` | REQ-09 |
| Unit | `OVERLAPPING_JOBS` detector against back-to-back (no flag) and raw Start Ticket→End Ticket overlapping (flag) windows | REQ-10 |
| Integration (API) | `approveEmployee`/`approvePeriod` refuse on an incomplete ticket, an open flag, both, or neither; a `REJECTED` ticket does not trigger the incomplete-ticket refusal | REQ-07, REQ-11 |
| Integration (API) | Void refuses a `COMPLETE` ticket **and a `REJECTED` ticket** (Q6); succeeds on `PENDING`/`SENT`/`IN_PROGRESS` | REQ-06 |
| Integration (API) | The five approve/export routes refuse a non-`payroll-admin` role that previously held `payroll:edit`, **including Payroll Manager's own role before `payroll-admin` is granted to it** | REQ-03 |
| Integration (API) | Review refuses without a note, refuses below `edit`, refuses on an `APPROVED` week | REQ-12 |
| Integration (API) | Flag-raised and void notifications are sent both `IN_APP` and `EMAIL` | REQ-13, REQ-06 |
| Integration (API) | Remind sends `IN_APP`, `PUSH` and `EMAIL` to the ticket's primary worker | REQ-08 |
| E2E / manual script | A Payroll Admin sees a raised flag, reviews it as no-change, and approves the week | REQ-09–REQ-14 |

- Requirements with no testable acceptance criterion: REQ-05 (copy/layout `NOT SPECIFIED`),
  REQ-08 (exact copy and repeat cadence `NOT SPECIFIED`), REQ-14 (copy/layout `NOT SPECIFIED`).

## 11. Non-functional

- **Performance:** `NOT SPECIFIED`. Flag detection runs inside `executeRun`; no source states a
  time budget. Worth the executor's attention given `executeRun` already prices a full period.
- **Concurrency:** `NOT SPECIFIED` beyond the existing per-period run serialization implied by
  `PayrollRun.status: STARTED` (code, existing pattern) — not independently re-verified here.
- **Audit / activity log:** `PayrollFlagEvent` (REQ-09) is this feature's own audit trail;
  whether void/review actions also write to the existing tenant-wide `ActivityLog`
  (`apps/api/prisma/schema.prisma:4500`) is `NOT SPECIFIED` — no source requires it, and
  `PayrollSendBack`'s own correction trail (`correctionChanges` JSON on the row itself) is the
  closer precedent, which this ticket's `PayrollFlagEvent` already follows.
- **Migration/rollout order:** schema (REQ-06, REQ-09) → api (REQ-01, REQ-02, REQ-03, REQ-04,
  REQ-06, REQ-07, REQ-08, REQ-09 through REQ-13) → web (REQ-05, REQ-14) → mobile (REQ-06's
  partition/notice). One PR, one commit per unit (U1 → U2 → U3 → U4 → U5), per the developer's
  stated branching choice (§0), which does not itself specify commit-internal ordering across
  REQs within a unit — `NOT SPECIFIED` beyond the unit grouping already given by the ticket.
- **Deployment gap from Q3 (REQ-01), confirmed, not an open risk:** because `payroll-admin` is
  pre-granted to nobody — not even Payroll Manager — the moment U1 ships to an existing tenant,
  **no seeded department role there can Approve, Export, void a ticket, or review a flag** until a
  tenant admin grants `payroll-admin` to at least one role via Departments. Asked directly, the
  developer confirmed this is intended: *"No, grant by hand."* Portal `ADMIN`/`SUPER_ADMIN` users
  bypass the permission check entirely (`apps/api/src/guard/permissions.guard.ts:37`) and are
  unaffected — one of them can perform the grant, or the gated actions themselves, immediately
  after deploy. Nothing in any source names who performs that grant on each existing tenant or
  exactly when, so it is still worth the rollout plan (not this spec) carrying it as an explicit
  step — e.g. release notes or an onboarding checklist item — but it is no longer an unanswered
  design question.

## 11a. Ripple — already-shipped behaviour these requirements reach

| # | Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Role editor / permission-map builders across web, api | `PERMISSION_MODULES` array | REQ-01 | unchanged — additive; every consumer already iterates the array generically | `apps/api/src/utility/seed-data.ts`, `apps/api/src/usecase/permissions/permissions.service.ts`, `packages/shared/src/constants/permissions.ts`, `apps/api/src/utility/demo-data/seed-reference-data.ts` (code) | `grep -rln "PERMISSION_MODULES" apps/api/src apps/web/src packages/shared/src` |
| 2 | Every seeded manager role's implicit `payroll-admin` grant | `FULL_PERMISSIONS` applying to every manager role by default | REQ-01 | **resolved — excluded, deliberately, for every role with no exception.** `payroll-admin` is excluded from `FULL_PERMISSIONS` for every role, including Payroll Manager; nothing is granted silently. | developer direction 2026-09-30 (Q3 / build-plan item E2, reference) | `apps/api/src/utility/seed-data.ts:236-237` (code) |
| 3 | Every seeded manager role's current Approve/Export access | `payroll: 'edit'` via `FULL_PERMISSIONS` | REQ-03 | **changes deliberately — and more sweepingly than first written.** Access is removed from every currently-seeded role, **including Payroll Manager**, until a tenant admin explicitly grants `payroll-admin` (per Q3/REQ-01's resolution); there is no automatically-exempted role anymore. | `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` → build-plan item E1 (vault, reference) | `grep -n "managerRole(" apps/api/src/utility/seed-data.ts` |
| 4 | `packages/payroll-engine` rest-premium pricing for every existing pay run | `applyRestPeriodPremium` / `RestEntry` | REQ-04 | **changes deliberately** — gap-start math changes for chains with a 2nd+ missed-meal WTL penalty; unchanged for chains without one | `decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md` clause 5 et al. (verified) | `grep -n "applyRestPeriodPremium\|interface RestEntry" packages/payroll-engine/src/rest-period.ts` |
| 5 | `apps/mobile` active ticket dashboard partition | `partitionDashboardTickets` already dropping `CANCELLED` | REQ-06 | **unchanged** — a voided ticket (which becomes `CANCELLED`) already disappears from the active list today | `apps/mobile/data/hooks/use-tickets.ts:58-71` (code) | read directly |
| 6 | `PayrollIncompleteBanner` on the employee payroll day view | direct component reuse | REQ-07 | **changes deliberately** — from "warns, never blocks" to a blocking banner offering Void | `apps/web/src/features/payroll/components/payroll-employee-daily.tsx:77-97` (code, per plan's description, file existence confirmed) | `grep -n "PayrollIncompleteBanner" -r apps/web/src` |
| 7 | `use-bulk-approve.ts` / `approval-blocked-error.ts` parsing of `PAYROLL_APPROVAL_BLOCKED` | shared error-body shape | REQ-07, REQ-11 | **changes deliberately** — the parsed body gains `incompleteTickets[]` and `openFlags[]` alongside whatever it already carries for send-backs | `apps/web/src/features/payroll/approval-blocked-error.ts`, `apps/api/src/usecase/payroll/payroll-approval-gate.ts:19` (code) | `grep -rln "PAYROLL_APPROVAL_BLOCKED" apps/api/src apps/web/src` |
| 8 | `PayrollEmployeeWeekStatus.FLAGGED` display label | shared enum, consumed by `payroll-worklist-filters.tsx`, `payroll-employee-table.tsx`, `payroll-format.ts` | REQ-09 | **changes deliberately** — relabeled "Rate issue" in the UI only; the enum value itself is unchanged | plan (reference); enum confirmed at `packages/shared/src/enums/index.ts:152` | `grep -rln "PayrollEmployeeWeekStatus" apps/web/src apps/api/src packages/shared/src` |
| 9 | Engine's `OVERLAPPING_LABOR` warning (`calculate.ts:533-571`) | separate, unrelated code path | REQ-10 | **unchanged** — this ticket's `OVERLAPPING_JOBS` `PayrollFlag` is a new, parallel record; nothing reads or writes the existing warning differently | plan, explicit; confirmed no web consumer exists | `grep -rln "OVERLAPPING_LABOR" packages/payroll-engine/src apps/api/src apps/web/src` |
| 10 | `PayrollIssue` / `payroll_approval_blocking_issues` (PAY-065's existing mechanism) | separate table, same approval flow | REQ-11 | **unchanged** — deliberately not extended to carry the nine flags (see REQ-11's Notes) | `payroll/gaps.md` PAY-065 sub-question 1 (vault, unverified); plan (reference) | `grep -n "blockingIssuesForWeek\|PAYROLL_APPROVAL_BLOCKED" apps/api/src/usecase/payroll/payroll-approval-gate.ts` |
| 11 | Crane Supervisor Send Back flow (`payroll-corrections` screen, `crane-supervisor` permission, `PayrollSendBack`) | shipped in PR #690/#691, explicitly overruled on routing/correction by the 2026-09-29 decisions but **not retired** by this ticket | REQ-01–REQ-14 (all of them, collectively) | **OPEN — no unit in this ticket retires it.** It will coexist with the new payroll-admin flag framework until U9 ("retire the Crane Supervisor routing," out of scope here) ships. Not a §12 question — it is a known, named follow-up (§13) — but flagged here so the executor does not mistake U1–U5 for a full cutover. | `decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md` *Build impact*; `plan-u1-u5.md` overview (U9) | `grep -rln "crane-supervisor\|PayrollSendBack" apps/api/src apps/web/src apps/mobile` (20 files) |

- **Surfaces with no existing behaviour in this area:** the `payroll-admin` permission module,
  the `PayrollFlag`/`PayrollFlagEvent` tables, and the void/review/remind actions are all new —
  established by `grep -rn "payroll-admin\|PayrollFlag" apps/api/src apps/web/src
  packages/shared/src` returning no hits before this spec.
- **Consumers with no source for what happens to them:** row 11 only, now (the coexisting Crane
  Supervisor flow) — a scoping fact, not a gap needing a question, since it is answered by "U9
  handles it, not this ticket." Row 2 was open pending Q3 and is now resolved.

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Nothing below is built until these are answered — except where a
requirement above already states a smallest-safe-default and proceeds with it flagged.

```bash
grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/PAYROLL-FLAGS/spec.md
```

### Q1 — Overlap-flag basis: raw windows, or the legacy rounded-end rule?

- **Question:** Should `OVERLAPPING_JOBS` (REQ-10) use the same raw-entry-window basis the
  engine's existing `flagOverlappingLabor` check uses today, or the legacy rule ("this entry's
  start is before the *previous entry's rounded end*")?
- **Why it cannot be answered from what is written:** Corrina's own words name "overlapping
  jobs" as a flag source twice (2026-09-29, 2026-09-30) but never describe the comparison basis.
  No decision, rule file or gaps entry states one either way.
- **Blocked:** REQ-10 — the detector's exact trigger condition.
- **Candidates:** `packages/payroll-engine/src/calculate.ts:533-571` (raw windows, current
  engine behavior, code only); `plan-u1-u5.md` open-questions section (names the legacy rule as
  the alternative, without a source for it either).
- **Owner:** product team (Corrina Bustos, as the flag list's confirming voice) or Brian Petros
  (engine rules).
- **Workaround, if any:** REQ-10's Notes-for-executor proposes building against the raw-window
  basis as the default, since it matches the already-shipped engine check and is the smaller
  change — explicitly labeled a workaround, not a decision.
- **Answer (2026-09-30, developer direction, devmohsinakram, relayed in this session):** *"RAW
  WINDOWS. They overlap when one entry's Start Ticket→End Ticket window overlaps another's,
  matching the engine's existing check."* Folded into REQ-10.
- **Status:** resolved — developer direction, devmohsinakram, 2026-09-30, `reference`; not yet
  written into `.ai/vault/decisions/` (recommend `tcg-scrum` record it alongside Q2, Q4–Q7 below).

### Q2 — Does each missed meal from the 3rd onward move the rest start by a further 30 minutes?

- **Question:** Corrina confirmed the 2nd missed meal's WTL penalty moves the rest-gap start
  (REQ-04). Does a 3rd, 4th, etc. missed meal each move it a further 30 minutes, cumulatively?
- **Why it cannot be answered from what is written:** she was only ever asked "the first, or the
  second onward" — never asked about a third. PAY-047's own rule ("each further missed meal adds
  a half-hour at DT") supports a cumulative reading by analogy, but analogy is not a source.
  `decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md`
  explicitly frames its own answer as "2nd **and onward**" without elaborating on 3rd+.
- **Blocked:** REQ-04's exact engine math beyond a single 2nd-meal penalty; low-frequency in
  practice (shifts with 3+ missed meals) but not zero, per the engine's own "meals after 27
  hours" work already anticipating long shifts.
- **Candidates:** `payroll/rules/PAY-045-rest-period-premium.md` (open); `PAY-047-worked-through-lunch-adjustment.md`
  (confirmed, but about a different rule — the penalty amount, not the rest-gap start);
  `payroll-rules-provenance.md` §4 (no row addresses 3rd+ meals for rest-start purposes).
- **Owner:** Corrina Bustos, with Brian Petros for the engine-consistency argument.
- **Workaround, if any:** build cumulatively (each 2nd+ meal's 30 minutes stacks), matching the
  "the paid end moves only when hours are actually added" reading the 2026-09-30 decision itself
  states as "the consistent reading" — labeled a proposed default, not a confirmed rule.
- **Answer (2026-09-30, developer direction, devmohsinakram, relayed in this session):** *"YES,
  cumulative, 30 min per missed meal from the 2nd on (2nd +30, 3rd +60, 4th +90)."* This is a pay
  rule, so it is folded into REQ-04 with its provenance row explicitly reading "developer
  direction, pending Corrina Bustos / Brian Petros" for the cumulative part, separate from the
  base rule's own "Confirmed" status.
- **Status:** resolved — developer direction, devmohsinakram, 2026-09-30, `reference`, **pending
  Corrina Bustos / Brian Petros ratification** (it changes pay); not yet written into
  `.ai/vault/decisions/`.

### Q3 — What other permissions does a seeded Payroll Admin carry?

- **Question:** Beyond `payroll-admin` and `payroll` themselves, does the new `ROLE-ACCOUNTS-PA`
  role (REQ-01) get any other module access by default — or none, matching the minimal pattern
  `crane-supervisor` already uses?
- **Why it cannot be answered from what is written:** Corrina's words describe only that "the
  Payroll Administrator" needs to be an assignable role and needs to see/adjust flags; no source
  discusses any other ERP module for that role.
- **Blocked:** REQ-01's exact permission map for `ROLE-ACCOUNTS-PA`.
- **Candidates:** none — nothing written addresses this beyond the flags themselves.
- **Owner:** CodingCops (per `payroll/gaps.md`'s own statement that "Q2's role design" is
  CodingCops's call, not the client's) — but the specific module grants are still worth
  confirming with Corrina before shipping to a real tenant.
- **Workaround, if any:** grant only `payroll-admin: full` and `payroll: full`, nothing else —
  proposed default, labeled as such in REQ-01.
- **Answer (2026-09-30, developer direction, devmohsinakram):** the premise of the question was
  wrong — there is no `ROLE-ACCOUNTS-PA` and no fixed bundle at all. Verbatim: *"that should be
  handle in deparment roles and its depends on that whick permissions are provided or not."*
  Recorded in the vault: *"Who is 'Payroll Admin' is a Department Roles setting. No fixed
  permission bundle is seeded for the role: whoever a tenant's department roles grant the
  payroll-admin permission to acts as Payroll Admin/Manager, and what else they can do is
  whatever their role grants."* REQ-01 is rewritten accordingly: seed nothing beyond making the
  module exist and be assignable; do not bundle `payroll` onto it; manager roles (including
  Payroll Manager) do not get it silently.
- **Status:** resolved — see `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md`
  → "Later the same day — the build plan", item E2.

### Q4 — Are flag/incomplete-ticket recipients notified in-app, by email, or both?

- **Question:** For REQ-08 (remind), REQ-13 (flags raised) and REQ-06 (ticket voided), is the
  notification in-app only, email only, or both?
- **Why it cannot be answered from what is written:**
  `decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md`
  explicitly says the prior design's in-app+email answer for the crane-superintendent recipient
  is overruled as to *who*, and states plainly: *"How they are told (in-app, email, or both) is
  not stated."* Nothing later answers it.
- **Blocked:** REQ-08, REQ-13, REQ-06's notification channel; REQ-13's Acceptance is explicitly
  `NOT SPECIFIED` pending this.
- **Candidates:** the same decision note (states the gap, does not fill it); no gaps.md entry
  found addressing channel specifically beyond restating the same open point.
- **Owner:** Corrina Bustos.
- **Workaround, if any:** build `IN_APP` only for this ticket (REQ-13's Notes for the executor)
  — the smallest slice not depending on the answer, explicitly labeled a workaround.
- **Answer (2026-09-30, developer direction, devmohsinakram, relayed in this session):** *"IN-APP
  AND EMAIL, for new flags to Payroll Admin/Manager and for void notices. Worker reminders are out
  of scope for U1–U5."* Folded into REQ-13 (flags) and REQ-06 (void notice).
  **Correction:** the second sentence was first read as excluding REQ-08 (U4's Remind action) and
  that requirement was marked `[OUT OF SCOPE]` on that basis. The coordinator has since clarified
  the sentence meant the **Send Back** flow's 3-hour-repeating reminder (U12), not U4's Remind
  button, which the developer separately confirmed is built as planned. REQ-08 is restored, with
  its own channel answer — in-app, push (mobile) and email to the worker — recorded in its own
  block rather than here, since it is a distinct question from this one (payroll-side notice
  channels).
- **Status:** resolved — developer direction, devmohsinakram, 2026-09-30, `reference`; not yet
  written into `.ai/vault/decisions/`.

### Q5 — Does voiding a ticket touch billing or invoicing, and what does the crew see on mobile?

- **Question:** When a Payroll Admin/Manager voids a never-completed ticket (REQ-06), does that
  action need to notify or update billing/invoicing, and what — if anything — does the crew see
  on their mobile app beyond the ticket disappearing from their active list?
- **Why it cannot be answered from what is written:**
  `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` item C8 says so
  itself: *"Voiding a ticket is new, and reaches beyond payroll. A voided ticket may matter to
  dispatch and to billing. Nobody has asked either of them."* No mobile-specific copy is sourced
  anywhere.
- **Blocked:** REQ-06's full Ripple/Acceptance for billing/invoicing and mobile notice copy;
  §6's mobile section explicitly marks this `OPEN`.
- **Candidates:** none for billing/invoicing. For mobile: `plan-u1-u5.md` proposes "show a
  'Voided by payroll' notice," unsourced beyond that proposal.
- **Owner:** Corrina Bustos (payroll), plus dispatch/billing owners not yet named in the vault
  for this specific question.
- **Workaround, if any:** ship REQ-06 with no billing/invoicing side effect and no special
  mobile notice beyond the existing `CANCELLED`-drops-from-dashboard behavior (already true
  today per §11a row 5) — smallest change, explicitly a workaround.
- **Answer (2026-09-30, developer direction, devmohsinakram, relayed in this session):** *"NO
  BILLING EFFECT. The void takes the ticket out of payroll only. On mobile it drops off the
  crew's list like a cancelled ticket, plus the in-app/email notice."* Folded into REQ-06. This is
  the build answer, not a confirmation from anyone who owns billing, invoicing or dispatch —
  nobody there has been asked, which the underlying decision note (C8) says explicitly. Treat as
  settled for this ticket's build; flag for `tcg-scrum` to confirm with those owners before the
  demo or a real tenant depends on it.
- **Status:** resolved — developer direction, devmohsinakram, 2026-09-30, `reference`; not yet
  written into `.ai/vault/decisions/`.

### Q6 — Does a `REJECTED` ticket count as "incomplete" for the approval gate and for voiding?

- **Question:** REQ-07's incomplete-ticket approval gate and REQ-06's void action both need to
  decide whether a `REJECTED` ticket (an existing, distinct `JobTicketStatus`) is treated the
  same as `PENDING`/`SENT`/`IN_PROGRESS` — i.e., something that must be completed or voided
  before the week can be approved.
- **Why it cannot be answered from what is written:** no decision or gaps entry mentions
  `REJECTED` by name in the incomplete-tickets discussion. The only evidence is architectural:
  `WEEK_OVERLAY_TICKET_STATUSES` (`apps/api/src/service/payroll/payroll.repository.ts:259-263`)
  already includes `REJECTED` in the *display* overlay today, alongside the comment that
  `CANCELLED` is excluded "because the work was called off, so there is no gap to chase" — which
  implies `REJECTED` is *not* considered "called off" by the existing code's own logic, but that
  is a description of what the overlay currently displays, not a decision about what should
  block approval.
- **Blocked:** REQ-07's exact incompleteness definition; REQ-06's exact voidable-status set (the
  plan's own scope line already assumes `REJECTED` is voidable, without a cited source for that
  choice beyond reusing `findWeekOverlayTickets`).
- **Candidates:** `apps/api/src/service/payroll/payroll.repository.ts:259-263` (code, describes
  today's overlay set, not a product answer); no vault or decision source found.
- **Owner:** Corrina Bustos.
- **Workaround, if any:** treat `REJECTED` the same as `PENDING`/`SENT`/`IN_PROGRESS` — i.e.,
  incomplete, and voidable — since that is what reusing the existing
  `WEEK_OVERLAY_TICKET_STATUSES` set already does architecturally, and nothing contradicts it.
  Labeled a workaround, not a confirmed rule.
- **Answer (2026-09-30, developer direction, devmohsinakram, relayed in this session):** *"NOT
  incomplete. A `REJECTED` ticket never blocks Approve and needs no void."* This is the opposite
  of this spec's proposed workaround above — the workaround is now superseded, not confirmed.
  Folded into REQ-06 (voidable set narrowed to `{PENDING, SENT, IN_PROGRESS}`, `REJECTED`
  excluded) and REQ-07 (incomplete-ticket gate excludes `REJECTED`). Note this diverges from
  `WEEK_OVERLAY_TICKET_STATUSES`, which still includes `REJECTED` for the *display* overlay —
  that constant is unchanged and must not be reused verbatim for either REQ-06 or REQ-07 now.
- **Status:** resolved — developer direction, devmohsinakram, 2026-09-30, `reference`; not yet
  written into `.ai/vault/decisions/`.

### Q7 — Which week owns a cross-week ticket for the incomplete-ticket gate?

- **Question:** For REQ-07's per-week incomplete-ticket check, which week does a ticket that
  spans a week boundary (e.g. starts 8/28, work continues into 8/29) belong to — the ticket's
  scheduled/start date, or something else?
- **Why it cannot be answered from what is written:**
  `decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md`
  *Not decided* item 3 states this explicitly and leaves it open: *"Confirm which week a ticket
  belongs to for this rule: the work date, or the start."* The plan notes the overlay today uses
  `WORK_TIME` start or the schedule date, and that "the unpushed PAY-001 row says Start Ticket,
  Pacific" — neither is confirmed as the rule for *this* gate specifically.
- **Blocked:** REQ-07's exact query — `findWeekOverlayTickets(from, toExclusive)` already takes
  a date range, so this determines what range is passed for a given period.
- **Candidates:** `decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md`
  (states the gap, verified as an open item); the overlay's existing `resolveWorkDate` logic
  (`apps/api/src/usecase/payroll/payroll-week-overlay.ts`, code, describes current display
  behavior only).
- **Owner:** Corrina Bustos / Brian Petros (per the decision's own framing).
- **Workaround, if any:** reuse `findWeekOverlayTickets`'s existing date-range logic unchanged
  (which REQ-07 already proposes doing, per its Notes for the executor) — this defers the
  question rather than answering it, since the existing overlay's own date resolution is itself
  unratified for this exact purpose. Labeled a workaround.
- **Answer (2026-09-30, developer direction, devmohsinakram, relayed in this session):** *"the
  START TICKET WEEK (Pacific). A ticket not started yet belongs to its scheduled date's week, the
  same as the pending-ticket overlay today."* This confirms the proposed workaround was in fact
  correct — reusing the existing overlay date-resolution logic unchanged is now the settled
  answer, not a placeholder. Folded into REQ-07.
- **Status:** resolved — developer direction, devmohsinakram, 2026-09-30, `reference`; not yet
  written into `.ai/vault/decisions/`.

### Q8 — REQ-05: persist the effective rest-gap start, or show `restGapHours` as "measured from" it?

- **Question:** To show the effective rest-gap start (rounded paid end + WTL extension) on the
  rest-audit panel, may U2 add a nullable `PayrollJobDay` timestamp column (e.g.
  `rest_gap_started_at`, written by Calculate beside `rest_gap_hours`)? Or is the panel's
  existing *Rest before entry* hours figure, now measured from that start, with a line saying
  so, enough for REQ-05? One line: **"persist"** or **"measured-from is enough"**.
- **Why it cannot be answered from what is written:** REQ-05's own Notes say the choice is
  `NOT SPECIFIED`: *"both were floated in the plan and no source picks between them"*. Raised by
  the U2 executor, 2026-09-30. Tracing the path settles only the mechanics.
  `payroll-rest-audit.tsx` reads nothing but the persisted run: `PayrollJobDay.rest_gap_hours`
  (schema l. 5524), written by `PayrollRepository.persistRun` from the engine's `restGapHours`.
  No transient path carries an engine value to it. So a start *time* reaches the panel only
  through a new column, or a read-time re-derivation that would contradict the panel's own
  "nothing is re-derived here" rule. A new column conflicts with §3, which allows schema changes
  for REQ-06 and REQ-09 only, and with U2's Schema row (`None`). U2's *Deliberately not* permits
  one only "unless the API-layer trace … finds a reason it is required", which this trace does,
  but only for the timestamp reading of REQ-05.
- **Blocked:** U2's Web row (REQ-05 display) and any API threading of a gap-start value.
  REQ-04 is built: the engine returns the start (`RestEntryOutcome.gapStartedAt`). The persisted
  `restGapHours` already reflects the moved start and reaches the panel unchanged.
- **Candidates:** REQ-05 Statement and Notes; `units.md` U2 Slice contents (Schema `None`) and
  *Deliberately not in this unit*; §3.
- **Owner:** devmohsinakram (developer; a display/storage choice, not a pay rule).
- **Workaround, if any:** none built. Until this is answered, the panel shows *Rest before
  entry* hours measured from the moved start, with no timestamp and no wording change.
- **Status:** resolved
- **Answer (developer, devmohsinakram, 2026-09-30):** *"Hours, measured-from note"* — **no schema change.** The rest-audit panel keeps showing the saved `restGapHours`, labelled as measured from the rounded (PAY-020) paid end plus any WTL penalty from the 2nd missed meal on; where the start is derivable from the data the panel already has, it names it (e.g. "7.5 h rest, from 11:30 PM incl. 30-min WTL penalty"). U2 stays schema-free. Source: developer direction, `reference`.

### Q9 — REQ-04: is the "2nd missed meal" counted per rest chain or per gapless meal group?

- **Question:** REQ-04 moves the rest-gap start 30 minutes per worked-through meal from the 2nd
  on. When the prior work chain holds two tickets 1–30 minutes apart, each with one meal worked
  through, does the second of those move the start? One line: **"per rest chain"** (yes, +30) or
  **"per meal group"** (no — each ticket's meal is its own group's first missed meal).
- **Why it cannot be answered from what is written:** the two groupings differ exactly there.
  `units.md` U2 counts "that chain's worked-through-meal penalties" — the rest work chain
  `toWorkChains` forms, which stitches entries up to `REST_STITCH_MINUTES` (30) apart. PAY-046/047
  resolve and number meals per gapless group (`StitchGapMinutes = 0`), and
  `decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md`
  clause 2 reads "the paid end moves only when hours are actually added" — under PAY-047's
  absorbed-first-meal model each group's first missed meal adds none. Back-to-back tickets (one
  gapless group) come out the same either way; only a 1–30 minute gap between tickets separates
  the readings. Raised by the U2 executor, 2026-09-30.
- **Blocked:** nothing — built per `units.md`, per rest chain: `restGapStartMs`
  (`packages/payroll-engine/src/rest-period.ts`) sums the chain's worked-through meals and moves
  the start 30 minutes for each after the first. "Per meal group" changes that sum and
  `countWorkedThroughMeals` (`calculate.ts`), nothing else.
- **Candidates:** `units.md` U2 Engine row; REQ-04 Statement; the 2026-09-30 decision above;
  `payroll/rules/PAY-047-worked-through-lunch-adjustment.md`; `payroll-rules-provenance.md` rows
  *Meal grouping* and *Rest chain stitching* — the latter's pending A7 change (stitch at 0 on the
  PAY-020 rounded window) would narrow the difference to tickets that touch only once rounded.
- **Owner:** Corrina Bustos (it changes pay), with Brian Petros.
- **Workaround, if any:** per rest chain, as built — `units.md`'s wording, not a client ruling.
- **Status:** resolved
- **Answer (developer, devmohsinakram, 2026-09-30):** *"Per rest chain (as built)"* — the rest chain (stitched up to `REST_STITCH_MINUTES`) is the unit; the second ticket's worked-through meal is the chain's 2nd and moves the start +30 min. Developer direction, `reference`; where it changes pay, pending Corrina Bustos / Brian Petros ratification.

### Q10 — REQ-04: should the rest gap be measured across a `chainJobDays` (OT/DT reset) boundary, not just within one?

- **Question:** REQ-04's own worked example (worked to 11:00 PM, 2nd-meal WTL penalty, next
  shift some hours later) is written as if the two shifts are already "the same chain." But the
  engine also groups entries into `chainJobDays` chains on a *separate* rule (PAY-023 cumulative
  OT/DT semantics, `CHAIN_GAP_HOURS = 8`) — numerically the same threshold as
  `REST_REQUIRED_HOURS = 8`, but a different rule with a different purpose. Before this unit, a
  raw gap of 8 h or more between two `chainJobDays` chains was never even evaluated for rest
  (the engine's rest pass reset cleanly at every such boundary, by construction). The U2 build
  removed that reset and now evaluates rest across every `chainJobDays` boundary an employee has,
  specifically so a raw gap that is *nominally* 8 h or more, but effectively short once measured
  from the rounded PAY-020 end plus any WTL extension, is caught. Is reaching across that
  boundary the intended scope of PAY-045's gap-start rule, or should the rest premium remain
  scoped to within one `chainJobDays` chain, leaving an 8-hour-or-more raw gap exempt from rest
  scrutiny the way it always has been? One line: **"across chains"** (as built) or **"within one
  chain only"**.
- **Why it cannot be answered from what is written:** none of REQ-04's three verified Corrina
  Bustos statements, nor the 2026-09-30 developer-direction statement on the cumulative
  extension, was ever asked about (or answers) whether the rule should reach across what the
  engine treats as a fresh OT/DT chain. `units.md` U2's own Slice contents/Ripple text says this
  requirement "touches only where the gap for an **already-formed chain**'s gap starts" and lists
  `toWorkChains`/`REST_STITCH_MINUTES` as the only things confirmed unchanged — it does not
  discuss `chainJobDays` or `CHAIN_GAP_HOURS` at all, and was written before the executor found
  that reaching across that boundary is what makes Corrina's own worked example actually change
  pay (raised by the U2 executor's own notes: "One change `units.md` didn't anticipate"). Every
  one of the five new `rest-period.spec.ts` cases, and both new `payroll.service.spec.ts`
  integration cases, is deliberately built at exactly this boundary (next shift starting exactly
  8 h after the raw end) — so the only cases actually under test are the boundary-crossing ones,
  not a same-chain-only alternative.
- **Blocked:** nothing — built per the executor's reading: `applyRestPeriodRules` now reads every
  `chainJobDays` chain an employee has in one pass (`calculate.ts:1242`), and `restGapStartMs`
  (`rest-period.ts:125`) is the anchor. A "within one chain only" answer would mean reverting to
  a per-`chainJobDays`-chain call (as before this unit) while keeping `restGapStartMs`'s rounded
  + WTL anchor for gaps that stay inside one chain.
- **Candidates:** REQ-04 Statement and Acceptance (silent on `chainJobDays`); `units.md` U2 Slice
  contents / Ripple ("touches only where an already-formed chain's gap starts"); `version.ts`
  2.0.0 history note ("measured across `chainJobDays` boundaries"); `payroll-rules-provenance.md`
  → *8-hour rest — gap start* "Still open" column, which records the mechanic as built but does
  not itself flag it as pending confirmation the way the cumulative 3rd+ extension is flagged.
- **Owner:** Corrina Bustos / Brian Petros — it changes which pay runs get the rest premium at
  all, not just how much.
- **Workaround, if any:** across chains, as built (PAYROLL-FLAGS U2, `restGapStartMs` /
  `applyRestPeriodRules`) — an engineering reading of Corrina's general principle ("measured from
  the time the EE is paid"), not a client ruling on this specific point.
- **Status:** resolved
- **Answer (developer, devmohsinakram, 2026-09-30):** *"Across chains (as built)"* — every gap is measured from the rounded paid end plus the WTL extension, including across a `chainJobDays` (OT/DT reset) boundary. Developer direction, `reference`; where it changes pay, pending Corrina Bustos / Brian Petros ratification.

### Q11 — REQ-05: must the rest-audit panel state the WTL minutes that actually moved the gap start?

- **Question:** Q8's answer gives an example that names the WTL extension actually applied
  ("7.5 h rest, from 11:30 PM incl. 30-min WTL penalty"). The built panel names the clock time
  where derivable, but for the WTL part it only states the rule ("plus any WTL penalty from the
  2nd missed meal on"), never the minutes applied to this gap. Is the rule text enough, or must
  the panel state the minutes? One line: **"rule text is enough"** or **"show the minutes"**
  (and if so, how: persist them beside `rest_gap_hours`, or let the panel read the prior chain's
  days).
- **Why it cannot be answered from what is written:** Q8 also says the panel names the start
  "where the start is derivable from the data the panel already has", and the minutes are not
  derivable from that data. The panel gets one `PayrollJobDay`, whose `mealEvents` are its own
  entry's, while the extension comes from the *prior* chain's worked-through meals. The saved run
  keeps only `restGapHours`, with no start and no extension (Q8: no schema change). So the
  minutes reach the panel only through a new persisted field, which Q8 ruled out, or through
  reading other days and re-deriving the rule, which breaks the panel's "nothing is re-derived
  here" rule. REQ-05's acceptance does not decide it: copy and layout are `NOT SPECIFIED`.
  Raised by the U2 review, 2026-09-30; routed here by the U2 fix pass.
- **Blocked:** nothing ships blocked. Only a "show the minutes" answer, which would need either
  a `PayrollJobDay` field (a U2 schema change) or a multi-day read in the panel.
- **Candidates:** Q8's answer and example; REQ-05 Statement, Notes and Acceptance; `units.md` U2
  Web row and *Deliberately not in this unit* (no `rest_started_at` column);
  `apps/web/src/features/payroll/components/payroll-rest-audit.helpers.ts` → `restGapStartedAt`.
- **Owner:** devmohsinakram (developer; a display/storage choice, like Q8, not a pay rule).
- **Workaround, if any:** rule text as built. The panel shows *Rest before entry* (never below
  zero), a "Measured from …" line naming the rounded paid end plus the WTL rule, and the clock
  time only where the saved run pins it down.
- **Status:** resolved
- **Answer (developer, devmohsinakram, 2026-09-30):** *"No, rule text is enough"* — the panel keeps the rule text as built; no minutes, no new column. Developer direction, `reference`; where it changes pay, pending Corrina Bustos / Brian Petros ratification.

### Q12 — REQ-06: a voided ticket stays on the crew's active mobile list when it is same-day or had started work — filter it, or accept it?

- **Question:** REQ-06 says a voided (`CANCELLED`) ticket "drops off the crew's active list the
  same way a cancelled ticket already does today". U3's regression test shows it does only for a
  past-scheduled ticket that never started. Should `partitionDashboardTickets` drop every
  `CANCELLED` ticket (and `REJECTED`?) from `activeTickets`, or is today's behavior accepted? One
  line: **"drop CANCELLED from the dashboard"** (say whether `REJECTED` too) or **"accept as is"**.
- **Why it cannot be answered from what is written:** `partitionDashboardTickets`
  (`apps/mobile/data/hooks/use-tickets.ts:45-81`) has no status filter; a ticket leaves the
  dashboard only as `COMPLETE` or via `isPastFieldTicket`, which is false for today's date and
  for any ticket with `timeTracking.startedWorkAt` (`ticket.contract.ts:161-175`). The mobile
  list route (`job-tickets.repository.ts:418-421`, `status: { not: PENDING }`) does return
  `CANCELLED` tickets. So a ticket voided the same day, or voided from `IN_PROGRESS` after Start
  Work (which REQ-06 allows), stays in `activeTickets`. Asserted in
  `apps/mobile/data/hooks/use-tickets.test.tsx` (the two `FINDING:` cases). REQ-06 treats the
  drop-off as existing behavior; `units.md` U3 forbids changing the function inside U3 without a
  source. Related: the void notice carries entity `JOB_TICKET` (the precedent set by
  `das.job_ticket_rejected_self`), so tapping it in the mobile alert list opens the cancelled
  ticket in the ticket flow (`use-notification-ticket-navigation.ts`), as the rejected-self notice
  already does for a rejected ticket. Raised by the U3 executor, 2026-09-30.
- **Blocked:** nothing in U3. The drop-off for these two cases is not delivered until answered.
- **Candidates:** REQ-06 Statement and Ripple; §11a row 5; `units.md` *Findings from path
  verification* #2 and U3 Mobile row; `spec.md` §6 *Offline / sync behavior* (draft discard,
  `NOT SPECIFIED`).
- **Owner:** devmohsinakram (developer), mobile field-ops behavior.
- **Workaround, if any:** none built. The server refuses any step or submit on a `CANCELLED`
  ticket (`job-tickets.service.ts` terminal-status guards), so a crew member cannot act on it.
- **Status:** open

### Q13 — REQ-06: must the void refuse a ticket that is not in period `:id`'s week?

- **Question:** `POST /v1/payroll/periods/:id/tickets/:ticketId/void` names a period, but REQ-06
  says nothing about the ticket belonging to it. Should the void refuse a ticket outside that
  period's week (Q7's rule: Start Ticket week, Pacific, or the scheduled date's week if
  unstarted), and with what status? One line: **"refuse, 400"** / **"refuse, 404"** or **"any
  ticket in the tenant"**.
- **Why it cannot be answered from what is written:** REQ-06's Acceptance refuses only on status;
  §4 lists the route and its errors without a membership rule. The precedent next door,
  Send Back, refuses entries "not in this employee's week" with 400, but that is a different
  action's rule. Raised by the U3 executor, 2026-09-30.
- **Blocked:** nothing. U3 checks that the period exists (404 otherwise) and then voids by ticket
  id, tenant-scoped, refusing on status only.
- **Candidates:** REQ-06; §4 *Errors*; Q7; `payroll-send-backs.service.ts` `sendBack`
  ("One or more entries are not in this employee's week").
- **Owner:** devmohsinakram (developer).
- **Workaround, if any:** as built: no membership check. The web offers Void only on the rows of
  the period's own unfinished-tickets list.
- **Status:** open

## 13. What this spec deliberately does not specify

- **Exact UI copy and layout** for every new web/mobile surface (REQ-05, REQ-06's mobile notice,
  REQ-14) — no source supplies it; see each REQ's `NOT SPECIFIED` markers. (REQ-08 is out of
  scope, not merely uncopied.)
- **Whether "all flags" includes field-ops ticket-progress `Flagged`** (incident, deficiency,
  customer unavailable) — an open item in `payroll/gaps.md` (Q4 of that entry, not renumbered
  here to avoid confusion with this spec's own Q4) that does not block U1–U5, since the flag
  framework built here (REQ-09) only concerns payroll-review flags, not field-ops ticket states.
  Left for whichever future unit builds a detector that would need to know.
- **Follow-up units U6–U21**, explicitly out of scope, listed for continuity from
  `plan-u1-u5.md`'s overview: U6 (rest flag), U7 (invalid-time/long-boom checks), U8 (payroll
  fixes an entry itself, per-employee), U9 (retire the Crane Supervisor routing — see §11a row
  11), U10 (payroll completes a never-completed ticket, the `COMPLETED` half of REQ-06's enum),
  U11–U13 (Send Back rebuilt for the worker, the 3-hour reminder, worker edit-and-resubmit),
  U14–U21 (each gated on one of: the boom basis, the missing-notes definition, AM/PM detection
  and labor-vs-ticket tolerance, crew-ticket grouping for the crew-mismatch flag, Samsara event
  mapping, and the asset-departure-yard record). None of these is decomposed or built by this
  spec.
- **The boom-basis question** (payroll/gaps.md Q6, asked of Corrina twice on 2026-09-30 and
  unanswered both times) — not raised as this spec's own Q-item because it blocks only U6+
  flags, not any REQ here.
- **Whether this ticket's REQ-03 (Approve/Export narrowing) breaks an existing practice** where
  a non-payroll manager role currently approves or exports payroll — see §11a row 3; flagged as
  a ripple, not elevated to a numbered §12 question, because no source suggests such a practice
  exists, only that the access exists technically.
- **REQ-08's exact reminder copy and whether it repeats** — no source states either; built as a
  single on-demand send per REQ-08's Acceptance. (REQ-08 itself is in scope and built — an earlier
  fold-in briefly marked it out of scope on a misreading of Q4's answer, since corrected; see the
  banner at the top of REQ-08.)
- **Whether the remaining unvaulted developer answers (Q1, Q2, Q4, Q5, Q6, Q7) need to be written
  into `.ai/vault/` before this ticket is treated as fully sourced** — recommended throughout this
  spec wherever they are cited; recording them is `tcg-scrum`'s job, not this spec's, and not a
  blocking question for the executor either way since the coordinator explicitly directed this
  fold-in. Q3 (and REQ-03's own source) are the exception: both are now recorded in
  `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` as build-plan
  items E1 and E2, so those two no longer carry this caveat.
- **Whether Q2's cumulative rest-start rule and Q6's `REJECTED`-exclusion rule need independent
  billing/dispatch/union sign-off beyond Corrina and Brian** — not asked of anyone else, and this
  spec does not extend the question further than the developer's own answers did.

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person — *(no
      REQ was ever `[OPEN]`; all seven §12 questions are now `Status: resolved` and folded into
      the affected REQs. Q2 and the cumulative part of REQ-04 remain `reference`, pending Corrina
      Bustos / Brian Petros ratification because they change pay — not blocking, but flagged for
      that ratification before REQ-04's cumulative behavior ships to a real tenant.)*
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` — *(none
      flagged `[CONFLICT]`; REQ-04's disclosed-but-not-blocking tension is not a `[CONFLICT]`,
      see its Conflict field for why)*
- [x] Answers written back into `spec.md` with their new sources and flags — *(REQ-01 rewritten;
      REQ-03/04/06/07/10/13 sources and fields updated; REQ-04's heading flag moved `[VERIFIED]` →
      `[UNVERIFIED]`; REQ-08 was briefly marked `[OUT OF SCOPE]` on a misreading of Q4 and has
      since been restored, `[UNVERIFIED]`, built)*
- [x] Every §12 question updated to `Status: resolved — …` — *(Q3 points at
      `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` build-plan item
      E2; Q1, Q2, Q4, Q5, Q6, Q7 point at "developer direction, 2026-09-30, relayed in this
      session, reference, not yet in `.ai/vault/`" — recommend `tcg-scrum` write those six into the
      vault next, matching Q3/E1/E2's treatment)*
- [x] Every §11a ripple row has a source for what happens to that consumer, or a §12 question —
      *(row 2 is now resolved via Q3/E2; row 11 remains without one, scoped to a named follow-up
      unit (U9) instead, per §13 — the one deliberate exception)*
- [ ] Decomposed into vertical units — `units.md` (five units, U1–U5, per the developer's
      already-stated slicing; the decomposer should confirm this spec's 14 REQs — all built — map
      cleanly onto that slicing before writing `units.md`)

Answered by: ______________  Date: ______________

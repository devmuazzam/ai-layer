# Spec — PAYROLL-WEEK-RECALC-APPROVE (provisional name — a real ticket id is owed)

> Written by the elaborator from a direct request by Ali Riaz on 2026-10-16. **No Jira/Linear
> ticket exists and there is no `intent.md`.** Before decomposition, a real ticket id must be
> created and this folder renamed to it (`.ai/aidlc/SCRUM-###/`); every cross-reference to
> `PAYROLL-WEEK-RECALC-APPROVE` then changes with it.
>
> Source kind used below: `dev-direction` — the five decisions Ali Riaz made on 2026-10-16 and
> relayed in the elaboration prompt. They are **not** in `.ai/vault/decisions/` yet and are not a
> ticket, so they are `[UNVERIFIED]`: they record what a developer decided to build, not what
> payroll (Corrina Bustos / Brian Petros) agreed. `tcg-scrum` should record them as a decision
> note if they are to bind later work.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | none — provisional `PAYROLL-WEEK-RECALC-APPROVE`; **real id owed** |
| Intent | none — request relayed in-session by Ali Riaz, 2026-10-16 |
| Elaborated on | 2026-10-16 |
| Vault state at elaboration | not re-counted; six `domain/` files verified; payroll decisions cited below read by section only |
| Open questions raised by this spec | 6, all in §12 |
| Already-shipped behaviour reached | 9 consumers in §11a; 5 with no source for what happens to them |
| Rules consulted | `CLAUDE.md`; `.ai/claude/contexts/api.md`, `prisma.md`, `web.md` (Test IDs), `payroll-engine.md` (provenance rule), `patterns.md` (no payroll entry — pattern: none) |

Working tree note: at elaboration `git status` shows an uncommitted migration
`apps/api/prisma/migrations/20261016140000_payroll_employee_week_export_tracking/` and edits to
`payroll.repository.ts` / `usecase/payroll/index.ts` (ADP-PAYDATA-EXPORT). It touches the same
`PayrollEmployeeWeek` rows REQ-06/07 would rewrite — see §11a and Q2.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Driven by | Blocks build? |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-01 | Remove Recalculate from the employee-week header | web | `[UNVERIFIED]` | dev-direction D1; code | Decision 1 | no (Ripple Q5 open) |
| REQ-02 | Approve Week shows in the header only when the week is clean | web | `[UNVERIFIED]` | dev-direction D1, D2; PAYROLL-FLAGS REQ-07, REQ-11; code | Decisions 1, 2 | partly — Q4 |
| REQ-03 | Per-row Recalculate button in the Daily Summary status column, only on rows needing it | web | `[UNVERIFIED]` | dev-direction D3 | Decision 3 | no |
| REQ-04 | A row "needs recalc" when rate drift matches its craft + work date | api, web, shared | `[UNVERIFIED]` | dev-direction D3; TCG-138 clause 4 (code) | Decision 3 | no |
| REQ-05 | A row "needs recalc" when its calculation failed | — | `[OPEN]` | none | Decision 3 | **yes** — Q1 |
| REQ-06 | New endpoint recalculates one employee's whole week | api | `[UNVERIFIED]` | dev-direction D4; code | Decision 4 | partly — Q2, Q6 |
| REQ-07 | Engine entry point scoped to one employee-week | engine | `[UNVERIFIED]` | dev-direction D4; `payroll-rules-provenance.md` | Decision 4 | no |
| REQ-08 | Send-back corrections auto-recalculate on respond/resubmit | api | `[OPEN]` | none for the delta | Decision 5 | **yes** — Q3 |
| REQ-09 | New controls and cells ship with `data-testid`s | web | `[UNVERIFIED]` | rule `web.md` → Test IDs | rule (not a decision) | no — names are D10 |

Counts: 9 total — 0 verified, 7 unverified, 0 conflicted, 2 open.

**Existing behaviour vs. the five decisions.** Existing and unchanged: the approve gate inputs
(REQ-02), the period-level `POST periods/:id/calculate`, the auto-recalc queue
(`PayrollCalculationJob`), the failed-recalculation hold, `GET failed-calculations`. Driven by
the decisions: everything marked in the "Driven by" column above.

## 2. Requirements

### REQ-01 — Remove Recalculate from the employee-week header `[UNVERIFIED]`

- **Statement:** The employee-week hero no longer renders the period-level Recalculate button.
- **Surface:** web
- **Sources:**
  - dev-direction, Ali Riaz 2026-10-16, Decision 1 — `[UNVERIFIED]` — kind: dev-direction —
    remove both header buttons.
  - `apps/web/src/features/payroll/components/payroll-employee-hero.tsx:110-115` —
    `[UNVERIFIED]` — kind: code — current behaviour only: renders `PayrollRecalculateButton`
    (period-level, `testId="payroll-employee-recalculate"`).
- **Conflict:** none
- **Open question:** none for the removal. What the employee screen offers *instead* for a
  period-level recalculation is Q5.
- **Ripple:** `OPEN — see Q5` (banners that tell the user to "Recalculate" on this screen).
  Enumerated in §11a. `data-testid="payroll-employee-recalculate"` has no reference in
  `qa-automation/` (`grep -rn payroll-employee-recalculate qa-automation` → none).
- **Acceptance:** On `/payroll/:employeeId`, no element with `payroll-employee-recalculate` is in
  the hero for any week state or role; the worklist Recalculate (`payroll-worklist-recalculate`)
  is unaffected.
- **Notes for the executor:** `PayrollRecalculateButton` keeps one consumer
  (`payroll-worklist-list.tsx:164`); do not delete it. Its `placement="hero"` branch becomes dead
  once this lands — whether to remove it is a sibling decision (§11c), not an executor's call.

### REQ-02 — Approve Week renders in the header only when the week is clean `[UNVERIFIED]`

- **Statement:** The hero renders Approve Week only when the week is clean — the existing approve
  gate passes and no row needs recalculation — and renders nothing (not a disabled button)
  otherwise.
- **Surface:** web
- **Sources:**
  - dev-direction, Ali Riaz 2026-10-16, Decisions 1 and 2 — `[UNVERIFIED]` — kind:
    dev-direction — "clean" = existing gate (no open send-back/correction holds, no incomplete
    tickets, no open review flags) AND no row needs recalc.
  - `aidlc/PAYROLL-FLAGS/spec.md` REQ-07 (incomplete tickets block Approve) and REQ-11 (any
    `OPEN` flag blocks Approve) — `[UNVERIFIED]` — kind: jira-equivalent spec — the gate's own
    sources; unchanged.
  - `apps/web/src/features/payroll/lib/payroll-incomplete-tickets.ts:82-100`
    (`isApproveWeekDisabled`) — `[UNVERIFIED]` — kind: code — current gate: no `periodId`, week
    already `APPROVED`, `isApproving`, `sendBackHolds`, `incompleteTickets`, `openFlags`.
- **Conflict:** none
- **Open question:** Q4 — whether "clean" also includes the period-level `recalculationHold` and
  `pendingRecalculation`, which the **server** already enforces on approve but the client gate
  above does not read, and what an already-`APPROVED` week shows.
- **Ripple:** `isApproveWeekDisabled` has a unit test (`payroll-incomplete-tickets.test.mjs`) and
  one call site (`payroll-employee-timesheet.tsx:132`). The server refusals in
  `PayrollService.approveEmployee` (~1107) are unchanged. See §11a.
- **Acceptance:** For a week with each of {open send-back, awaiting-recalc correction or entry
  fix, incomplete ticket, open flag, a row needing recalc}: no `payroll-employee-approve-week`
  element exists in the DOM. For a week with none of them: it exists and approves.
- **Notes for the executor:** The existing `adminActions.showActions` (payroll-admin edit) and
  `PayrollAdminRequiredNote` behaviour is not changed by any decision; keep it. How "no row needs
  recalc" reaches the hero is D7.

### REQ-03 — Per-row Recalculate button in the Daily Summary status column `[UNVERIFIED]`

- **Statement:** A Recalculate button appears in the Daily Summary per-row status column, on
  rows that need recalculation only; clicking it invokes REQ-06 for that row's employee-week.
- **Surface:** web
- **Sources:**
  - dev-direction, Ali Riaz 2026-10-16, Decisions 3 and 4 — `[UNVERIFIED]` — kind:
    dev-direction.
  - `apps/web/src/features/payroll/components/payroll-status-chip.tsx:68-89`
    (`PayrollStatusCell`), `payroll-employee-table.row.tsx` (~134 `renderStatus`),
    `payroll-employee-table.columns.ts:69` — `[UNVERIFIED]` — kind: code — where the cell lives
    today; it shows Sent Back / Flagged / Clean only.
- **Conflict:** none
- **Open question:** none for placement. Settled-week visibility is Q2.
- **Ripple:** the status cell is also rendered for flagged and sent-back rows; the button must
  not displace those chips (how it sits beside them is not specified — see §13). `PayrollEntryTable`
  has one call site (`payroll-employee-timesheet.tsx`).
- **Acceptance:** A row with no recalc need renders no button; a row with a need renders one;
  clicking it issues one request for the whole employee-week (not the day) and, on success, the
  week query refetches and a row whose need is gone loses the button.
- **Notes for the executor:** Send-back / correction staleness is **not** a trigger for this
  button (Decision 3); `isStale` / `staleTicketIds` (`use-payroll-employee.ts:140-155`) must not
  feed it.

### REQ-04 — A row needs recalc when rate drift matches its craft code and work date `[UNVERIFIED]`

- **Statement:** A Daily Summary row needs recalculation when a `PayrollCraftRateDrift` entry has
  the row's `craftCode` and the row's `workDate` in its `workDates`.
- **Surface:** web (mapping), api and shared (if the field is server-supplied — D7)
- **Sources:**
  - dev-direction, Ali Riaz 2026-10-16, Decision 3 — `[UNVERIFIED]` — kind: dev-direction.
  - `apps/api/src/usecase/payroll/payroll.service.ts` `craftRateDriftFor` (~690-735) and
    `apps/web/.../services/payroll-week-entries.service.ts:92,109-116` — `[UNVERIFIED]` — kind:
    code — drift is computed **per period**, from the run in force's `configurationSnapshot`,
    only while the period is `CALCULATED` or `REVIEW`, and carries no employee or ticket id.
- **Conflict:** none
- **Open question:** none. (Whether the drift entry clears for this employee after REQ-06 is a
  structural dependency — D8.)
- **Ripple:** `PayrollCraftRateDrift` is rendered today as one banner
  (`payroll-rate-change-banner.tsx`, helpers `payroll-rate-change.helpers.ts`); keeping, changing
  or removing it is not decided by anything — Q5.
- **Acceptance:** Fixture: drift `{craftCode: 'X', workDates: ['2026-10-12']}` → exactly the
  rows with craft `X` on that date show the button; same craft, other date → no; other craft,
  same date → no.
- **Notes for the executor:** `PayrollJobDay.craftCode` and `workDate` exist
  (`services/payroll.service.ts:74-138`). Date comparison format must match `workDates`
  (`string[]`); the midnight-split display decision
  (`decisions/2026-10-06-midnight-split-display-in-weekly-payroll-view.md`) governs which date a
  split row carries — not read in full; confirm before mapping.

### REQ-05 — A row needs recalc when its calculation failed `[OPEN]`

- **Statement:** `OPEN — Decision 3 says a failed calculation for a row makes it need recalc; no
  source says which stored fact means "failed for this row".`
- **Surface:** —
- **Sources:** none. Searched: `PayrollCalculationJob` (`schema.prisma:6145`) — keyed by
  `periodId`, no employee column; `triggerEntityId` is a ticket id, send-back id or entry-fix id
  by trigger; `GET periods/:id/failed-calculations` returns period jobs. `PayrollRun.status
  FAILED` / `recalculationHold` — period-level. `PayrollIssue` (`schema.prisma:5850`) has
  `employeeWeekId` and the engine raises `RATE_*` when a rate cannot be resolved (priced at $0,
  `calculate.ts:418`), but no job-day id. Vault: `decisions/2026-09-24-payroll-failed-recalculation-keeps-last-good-run-and-blocks-approval.md`
  (`[VERIFIED]`) defines the failure as a period/run hold, not a row state.
- **Conflict:** n/a
- **Open question:** Q1.
- **Ripple:** `OPEN — cannot be stated until Q1 is answered.`
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked. Workaround, labelled as one: ship REQ-03/04 with drift
  as the only trigger; do not invent a failed-state mapping.

### REQ-06 — New endpoint recalculates one employee's whole week `[UNVERIFIED]`

- **Statement:** The API exposes an operation that recalculates one employee's entire week — not
  one day, not the whole period.
- **Surface:** api
- **Sources:**
  - dev-direction, Ali Riaz 2026-10-16, Decision 4 — `[UNVERIFIED]` — kind: dev-direction;
    rationale given: weekly OT/rest/guarantee rules span the week.
  - `apps/api/src/usecase/payroll/payroll.service.ts` `calculate` (373), `calculateQueued` (409),
    `runCalculation` (452), `executeRun` — `[UNVERIFIED]` — kind: code — today a calculation is
    one period-wide run; `persistRun` writes every week of the period; `PayrollEmployeeWeek` is
    unique on `(runId, employeeId)` (`schema.prisma:5719`); `calculate` refuses an
    `APPROVED`/`EXPORTED` period and clears approvals (`preserveApprovals: false`).
  - `packages/payroll-engine`/PAY-066 as cited in the `calculate` JSDoc — an approved week's
    snapshot never moves again.
- **Conflict:** none
- **Open question:** Q2 (settled weeks), Q4 (interaction with period-level holds/queue), Q6 (audit
  record). Persistence mechanism is D8; route/shape is D6.
- **Ripple:** consumers of "figures in force" = `period.runs[0]`: `recalculationHoldFor`,
  `pendingRecalculationOf`, `correctionHoldsOf` (compare against `runs[0].createdAt`),
  `craftRateDriftFor` (`runs[0].configurationSnapshot`), `findLatestSettledRun`, the run audit
  page, ADP export. What each should do when only one employee is re-priced: `OPEN — see Q4, Q6`.
- **Acceptance:** Calling it for employee E recomputes E's every job-day for the week and leaves
  every other employee's week figures, statuses and approvals byte-identical; unknown employee or
  period → 404; cross-tenant → 404.
- **Notes for the executor:** reuse `PayWeekAssembler.assembleWeek` (called in `executeRun`) —
  it is week-wide, so the employee filter point is a D9 decision. Controller sibling: `POST
  periods/:id/employees/:employeeId/approve` (`payroll.controller.ts:167`), guard
  `@RequirePermission('payroll','edit')` as on `calculate` (79). New endpoint = contract change →
  `tcg-contract-tracer`; any schema change → `tcg-prisma-guardian`.

### REQ-07 — Engine entry point scoped to one employee-week `[UNVERIFIED]`

- **Statement:** The payroll engine can price one employee's week using the same rules as a full
  period.
- **Surface:** engine (`packages/payroll-engine`)
- **Sources:**
  - dev-direction, Ali Riaz 2026-10-16, Decision 4 — `[UNVERIFIED]` — kind: dev-direction.
  - `packages/payroll-engine/src/calculate.ts:1102` `calculatePayPeriod(input)` — `[UNVERIFIED]` —
    kind: code — already takes `employees`/`jobDays`/`contextJobDays`, and returns per-employee
    weeks; whether a filtered input prices an employee identically to a full run is **not
    verified** (e.g. cross-employee `flagOverlappingLabor`, `flagPayrollSetup` at 1151-1152).
  - `.ai/claude/contexts/payroll-engine.md` — rule — kind: rule — no pay-rule change without its
    source in `vault/payroll/payroll-rules-provenance.md` in the same commit.
- **Conflict:** none
- **Open question:** none new; a rule change is not requested. If the executor finds a filtered
  call prices differently from the full run, that is a new question, not an executor's call.
- **Ripple:** `PAYROLL_ENGINE_VERSION` (`version.ts`) — whether a new entry point bumps it:
  `NOT SPECIFIED`. Other callers of `calculatePayPeriod`: `git grep -n calculatePayPeriod -- apps packages`.
- **Acceptance:** For a fixture period with N employees, the employee-week result for E deep-equals
  E's entry in `calculatePayPeriod` over the full input (a test in `calculate.spec.ts`).
- **Notes for the executor:** this is exactly the equivalence check above; no pay rule may move.

### REQ-08 — Send-back corrections auto-recalculate on respond/resubmit `[OPEN]`

- **Statement:** `OPEN — Decision 5 says a correction auto-recalculates "instead of leaving an
  admin awaiting-recalc hold"; the platform already enqueues a period recalculation on a
  resubmit/correction and still holds until it completes. What is meant to differ is not
  specified.`
- **Surface:** —
- **Sources:** none for the delta. Searched and found (descriptive only): `payroll-send-backs.service.ts:704,929`
  enqueue `PayrollCalcTrigger.CORRECTION_RETURNED` on correction and on resubmit-queue;
  `decisions/2026-10-06-payroll-calculate-runs-automatically.md` (`status: reference`, relayed
  second-hand, client not consulted) records the auto-recalc and that the hold lasts "until the
  queued run completes"; `payroll-send-backs.repository.ts:618-660` `countBlockingByEmployee`
  produces `awaitingRecalc`; `RESPONDED` writes nothing to the ticket (service ~366-402).
  `aidlc/PAYROLL-FLAGS/spec-u6-u13.md` §12 Q25 (hold until recalculation) is superseded in part by that note.
- **Conflict:** n/a
- **Open question:** Q3.
- **Ripple:** `OPEN — cannot be stated until Q3 is answered.` Known reach: `sendBackHold.awaitingRecalc`,
  `entryFixHold`, `isApproveWeekDisabled.sendBackHolds`, `payroll-send-back-banners.tsx`,
  `payroll-entry-fix-hold-banner.tsx`.
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked. No workaround: changing or removing `awaitingRecalc`
  without the answer moves the approval gate.

### REQ-09 — New controls and cells ship with `data-testid`s `[UNVERIFIED]`

- **Statement:** The per-row Recalculate button, the Daily Summary rows and status cells, and the
  conditional Approve Week carry `data-testid`s.
- **Surface:** web
- **Sources:**
  - `.ai/claude/contexts/web.md` → Test IDs — `[UNVERIFIED]` — kind: rule — new screens/controls
    ship with IDs; scheme `<module>-<flow>-<element>[-<modifier>]`; a shared component takes the
    ID from its call site. (A rule binds how, not what: that IDs exist is the rule; the names are D10.)
  - `payroll-employee-hero.tsx:121` — kind: code — `payroll-employee-approve-week` exists today.
- **Conflict:** none
- **Open question:** none (names: D10).
- **Ripple:** rows/status cells have no IDs today (`git grep -n data-testid -- apps/web/src/features/payroll/components/payroll-employee-table*` to confirm); `grep -rn payroll-employee-approve-week qa-automation` → none.
- **Acceptance:** every element named in REQ-02/03 is addressable by a unique ID per row.
- **Notes for the executor:** per-row IDs must be unique per row (row key in the ID, D10).

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** `NOT SPECIFIED` — depends on D8 and Q6. No decision requires one.
- **Migration required:** no, unless D8/Q6 choose a new column (then `pnpm db:migrate`, committed).
- **Data backfill required:** `NOT SPECIFIED`
- **Existing models considered:** `PayrollCalculationJob` (`schema.prisma:6145`, queue; period-keyed,
  no employee column — an employee-week job would need a column, or run synchronously);
  `PayrollRun` (period-keyed audit row; `startRun`/`failRun`/`persistRun`); `PayrollEmployeeWeek`
  (`:5682`, unique `(runId, employeeId)`); `PayrollIssue` (`:5850`, `employeeWeekId`, no job-day
  link). Whether any of these holds an employee-week recalc is D8.
- **New prefix introduced:** no
- **Child relations / Fields not specified:** none proposed.

## 4. API surface — `apps/api`

- **Pattern:** none — `patterns.md` has no payroll entry.
- **Existing functions/services to reuse:** `PayrollService.getPeriod`, `pricedWeekOrThrow`,
  `executeRun`/`persistRun`/`startRun`/`failRun`, `PayWeekAssembler.assembleWeek`,
  `recalculationHoldFor`, `pendingRecalculationOf`, `calculationRunningFor`, `PayrollCalcEnqueueService`.
- **New exported functions/services proposed:** (all are §11b rows, none chosen) an employee-week
  calculate method on `PayrollService`; an engine `calculateEmployeeWeek`; a repository method to
  write one employee's week.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `POST` | `NOT SPECIFIED` (D6) | `payroll.controller.ts` | `payroll.service.ts` | `payroll.repository.ts` | REQ-06 |

- **Request DTO / Response shape / Errors:** `NOT SPECIFIED` (D6).
- **Guards / roles:** the sibling `calculate` uses `@RequirePermission('payroll','edit')`; whether
  the new route matches is part of D6. Route identity: period id + employee id as on `/approve`.
- **Module registration:** existing `PayrollModule`; no new module proposed.

## 5. Web surface — `apps/web`

- **Routes:** existing `/payroll/[employeeId]` only.
- **Existing components to reuse:** `PayrollStatusCell`, `PayrollEntryTable`, `Chip`,
  `PayrollRecalculateButton` (period-level; `SecondaryButton` branch), `SecondaryButton`, `PageHeroButton`.
- **New components proposed:** none decided; a row-level recalc control is a D-row if
  `PayrollRecalculateButton` cannot be extended.
- **Table:** existing columns; the status column gains the button (REQ-03). Search placeholder /
  filters unchanged.
- **Server state:** TanStack Query — new mutation hook beside `useCalculatePeriod`
  (`hooks/use-payroll.ts:158`); invalidation of the employee-week query (key names: `NOT
  SPECIFIED`, executor reads `use-payroll.ts`). Do not extend `useRunCalculate(periodId)` silently (D11).
- **Colors / spacing / responsive:** `web.md`; no hardcoded colours.
- **Copy:** `NOT SPECIFIED` (button label, success/failure toast, tooltip).

## 6. Mobile surface — `apps/mobile`

N/A — payroll admin is web-only in the files read; nothing in this spec touches `apps/mobile`
(`git grep -n 'payroll' -- apps/mobile` not run — treat as unchecked).

## 7. Shared package — `packages/shared`

- `NOT SPECIFIED`. `PayrollJobDay` is declared in the **web** service file
  (`services/payroll.service.ts:74`), not in `@tcg/shared`, so a field added there is not
  compile-checked against the API. Whether a needs-recalc field exists at all is D7.

## 8. Permissions and tenancy

- **Roles permitted:** per-row Recalculate — `payroll:edit` is the period button's gate
  (`payroll-recalculate-button.tsx`, `useCan('payroll','edit')`); for the new route `NOT SPECIFIED` (D6).
- **Roles denied / Cross-tenant reads:** none stated; 404 across tenants as on sibling routes.
- **Tenant isolation:** standard client extension; confirm with `tcg-prisma-guardian` if D8 adds a model.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| employee-week target | `NOT SPECIFIED` — behaviour on settled/approved week is Q2 | — | — |

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit (engine) | employee-week result equals the employee's slice of a full-period run | REQ-07 |
| Unit (web, `node --test`) | clean predicate (all five hold types + row-needs-recalc); drift→row mapping | REQ-02, 04 |
| Integration (API) | other employees' weeks unchanged; tenant 404; refusal cases once Q2/Q4 answered | REQ-06 |
| E2E / manual | header has no Recalculate; Approve absent unless clean; row button recalcs whole week | REQ-01-03 |

Requirements with no testable acceptance criterion: REQ-05, REQ-08.

## 11. Non-functional

- **Performance:** `NOT SPECIFIED`
- **Concurrency:** period `calculate` returns 409 when a run is in flight (`calculationRunningFor`);
  whether the employee-week route shares that lock is Q4.
- **Audit / activity log:** Q6.
- **Rollout order:** `NOT SPECIFIED`; natural order engine → api → web.

## 11a. Ripple — already-shipped behaviour these requirements reach

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| `payroll-employee-hero.tsx` header buttons | removed/conditional | REQ-01, 02 | changes deliberately | dev-direction D1 | `git grep -n 'PayrollRecalculateButton' -- apps/web/src` |
| `payroll-worklist-list.tsx:164` worklist Recalculate | same component | REQ-01 | unchanged (period-level) | not contradicted by D1 — assumption, Q5 | same |
| `payroll-send-back-banners.tsx:32`, `payroll-entry-fix-hold-banner.tsx:16` tell the user to "Recalculate" | removed button | REQ-01 | **OPEN — Q5** | none | `grep -rn -i recalculate apps/web/src/features/payroll/components/*banner*` |
| `payroll-recalculation-hold-banner.tsx`, `payroll-pending-recalculation-banner.tsx`, `payroll-failed-calculations.tsx` (retry/confirm) | period-level hold UI | REQ-01, 06 | **OPEN — Q4/Q5** | none | same |
| `payroll-rate-change-banner.tsx` + `payroll-rate-change.helpers.ts` (+ `.test.mjs`) | `PayrollCraftRateDrift` | REQ-04 | **OPEN — Q5** (keep alongside row buttons, or replace) | none | `git grep -n 'rateChanges\|PayrollCraftRateDrift' -- apps/web/src` |
| `isApproveWeekDisabled` + `payroll-incomplete-tickets.test.mjs`; `use-payroll-employee.ts:197-210` `runApprove` | gate | REQ-02 | changed (a "row needs recalc" input) | dev-direction D2 | `git grep -n isApproveWeekDisabled -- apps/web/src` |
| `use-bulk-approve.ts` (worklist bulk approve → `useApproveEmployee`, `useApprovePeriod`) | same approve API | REQ-02 | **OPEN — Q4** whether bulk approve must also respect "row needs recalc" (server gate is unchanged) | none | `git grep -n 'useApproveEmployee\|useApprovePeriod' -- apps/web/src` |
| Figures-in-force readers `period.runs[0]` (hold, pending, correction holds, drift, audit log, ADP export incl. the in-flight `payroll_employee_week_export_tracking` migration) | REQ-06 persistence | REQ-06 | **OPEN — Q2, Q4, Q6** | none | `git grep -n 'runs\[0\]' -- apps/api/src` |
| `sendBackHold.awaitingRecalc` / `entryFixHold` / `CORRECTION_RETURNED` queue path | REQ-08 | REQ-08 | **OPEN — Q3** | none | `git grep -n 'awaitingRecalc\|CORRECTION_RETURNED' -- apps` |

- **Surfaces with no existing behaviour:** the per-row button and the employee-week route (new).
  `grep -rn 'payroll-employee-recalculate\|payroll-employee-approve-week' qa-automation` → no match.
- **Consumers with no source for what happens to them:** the banners, bulk approve, figures-in-force
  readers, and the awaiting-recalc hold — Q2-Q5.

## 11b. Developer decisions

| ID | Decision | Options (with existing code found) | AI note | Chosen | Decided by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | Remove Recalculate and Approve Week buttons from the employee-week header (`PayrollEmployeeHero`) | — | — | Remove both from the header | Ali Riaz | 2026-10-16 |
| D2 | Approve Week renders only when clean (existing gate AND no row needs recalc); absent, not disabled | — | — | As stated | Ali Riaz | 2026-10-16 |
| D3 | Per-row Recalculate in the Daily Summary status column, only on rows that need it; needs-recalc = rate drift (craft + date match) OR failed calc for that row; send-back staleness is not a manual button | — | — | As stated | Ali Riaz | 2026-10-16 |
| D4 | Per-row button calls a NEW endpoint recalculating that employee's WHOLE WEEK via a new engine entry point scoped to one employee-week; not a day, not the period | — | — | As stated | Ali Riaz | 2026-10-16 |
| D5 | Send-back corrections auto-recalculate on respond/resubmit instead of an admin "awaiting recalc" hold; included in this ticket | — | — | As stated (scope of the delta: Q3) | Ali Riaz | 2026-10-16 |
| D6 | Endpoint route, verb, request/response shape, sync vs queued, guard | (a) `POST payroll/periods/:id/employees/:employeeId/calculate`, beside `/approve` (`payroll.controller.ts:167`), synchronous like `calculate`; (b) same route that enqueues a job (needs a per-employee queue column on `PayrollCalculationJob`) | (a) is the smaller change; (b) matches the auto path but needs schema. Response: reuse `getEmployeeWeek` return as `approveEmployee` does. | | NEEDS A DECIDER | |
| D7 | Where per-row "needs recalc" is derived and carried | (a) server field on each `PayrollJobDay` (web type `services/payroll.service.ts:74`, API response); (b) client join in `timesheetRowsOf`/`tableJobDaysFromRows` using `rateChanges` already on the response; (c) server returns a separate `recalcRows` list | Drift (period-level, no employee) is cheap client-side; a failed-state (Q1) likely needs the server. (a) keeps one derivation for hero gate and rows, but `PayrollJobDay` is not compile-checked against the API. | | NEEDS A DECIDER | |
| D8 | How an employee-week recalc is persisted | (a) new run copying all other weeks forward, re-priced weeks replaced; (b) replace E's `PayrollEmployeeWeek` (+ children) in the run in force; (c) a run holding only E's week. Context: unique `(runId, employeeId)`; `runs[0]` is "figures in force" for hold, pending, drift, correction-hold readers | (c) breaks "figures in force"; (b) rewrites history the audit log (PAY-064) says is recorded; (a) is heaviest. Drift is read from `runs[0].configurationSnapshot`, so whichever is chosen must update it for E or the row button never clears. | | NEEDS A DECIDER | |
| D9 | Engine entry shape and filter point | (a) new exported `calculateEmployeeWeek` in `calculate.ts` wrapping `calculatePayPeriod`; (b) no engine change — caller passes a one-employee `CalculatePayPeriodInput`, filtering after `assembleWeek` | Either must pass the REQ-07 equivalence test. (b) adds no export. A rule change needs `payroll-rules-provenance.md` in the same commit. | | NEEDS A DECIDER | |
| D10 | `data-testid` names (scheme `<module>-<flow>-<element>`) | e.g. row `payroll-employee-entry-row-<rowKey>`, cell `payroll-employee-entry-status-<rowKey>`, button `payroll-employee-entry-recalculate-<rowKey>`; keep `payroll-employee-approve-week` unchanged | Keeping the Approve ID avoids any churn (no qa reference found today). Rename = contract change. | | NEEDS A DECIDER | |
| D11 | Client hook / component for the per-row button | (a) new mutation hook beside `useCalculatePeriod` (`hooks/use-payroll.ts:158`) + small row component; (b) generalise `useRunCalculate`/`PayrollRecalculateButton` with a scope prop | (a) leaves the period button untouched. | | NEEDS A DECIDER | |
| D12 | Whether `PayrollRecalculateButton`'s `placement="hero"` branch is removed after REQ-01 | remove / keep | Consistency debt either way; it is a sibling (§11c). | | NEEDS A DECIDER | |

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Decided by | Enumerated by |
| --- | --- | --- | --- | --- |
| Worklist period Recalculate (`payroll-worklist-list.tsx:164`) and the worklist's other hero / Export actions | none | `NEEDS A DECIDER` — Decisions 1-5 name only the employee-week header | | `git grep -n 'PayrollRecalculateButton\|payroll-worklist-' -- apps/web/src` |
| Period-level rate-change banner | none | `NEEDS A DECIDER` (Q5) | | `git grep -n 'payroll-rate-change-banner' -- apps/web/src` |
| `POST periods/:id/calculate`, `acknowledge-failure`, `failed-calculations/:jobId/retry` — other recalc entry points | none | `NEEDS A DECIDER` — unchanged by default | | `grep -n "@Post" apps/api/src/presentation/payroll/payroll.controller.ts` |
| Bulk approve (`use-bulk-approve.ts`, `POST periods/:id/approve`) | none | `NEEDS A DECIDER` (Q4) | | `git grep -n useApprovePeriod -- apps/web/src` |
| Other auto-recalc triggers (`TICKET_COMPLETE`, `ENTRY_FIX`) | none | `NEEDS A DECIDER` — Decision 5 names send-back corrections only | | `git grep -n 'PayrollCalcTrigger' -- apps/api/src` |

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Nothing below is built until these are answered.

### Q1 — What is a "failed calculation" for one row?

- **Question:** For REQ-05, which stored fact marks a row as failed: (a) its ticket is the `triggerEntityId` of an outstanding `FAILED` `PayrollCalculationJob` (ticket complete / send-back / entry fix → ticket), (b) its employee week carries a `RATE_*` issue (priced at $0), (c) the period's latest run is `FAILED`/abandoned so every row qualifies, or (d) something else?
- **Why it cannot be answered from what is written:** the queue and the run hold are period-level; the job has no employee column and its trigger id is a different entity per trigger; `PayrollIssue` is employee-week-level with no job-day link. No vault source defines a per-row failure. `decisions/2026-09-24-...failed-recalculation...` (`[VERIFIED]`) defines it as a period hold.
- **Blocked:** REQ-05; part of REQ-02 ("clean"), REQ-03.
- **Candidates:** `schema.prisma:6145`, `:5850`; `payroll-calculation-queue.repository.ts:25-45,308`; `payroll-recalculation-hold.ts`; `calculate.ts:418`; the 09-24 decision (3.5 KB).
- **Owner:** Ali Riaz (shipping developer); product team if (b) is chosen, since it changes what "failed" means to payroll.
- **Workaround, if any:** ship drift-only (REQ-04); labelled a workaround.
- **Status:** open

### Q2 — Settled and approved weeks: is the per-row button shown, and what does the endpoint do?

- **Question:** When the period is `APPROVED`/`EXPORTED`, the employee's week is `APPROVED`, or the week is already in an ADP export, should a row that matches drift show the button, and should the endpoint refuse (PAY-066), or clear that employee's approval as period `calculate` does (`preserveApprovals: false`)?
- **Why it cannot be answered from what is written:** `calculate` refuses settled periods and clears approvals otherwise; `calculateQueued` never clears them; drift is only computed while the period is `CALCULATED`/`REVIEW`, so an approved week in such a period can still show drift. Nothing says which rule an employee-week recalc follows. The in-flight `payroll_employee_week_export_tracking` migration (uncommitted) is not yet a source.
- **Blocked:** REQ-03, REQ-06.
- **Candidates:** `payroll.service.ts:373-440`; PAY-066 per the `calculate` JSDoc; `payroll.repository.ts` `persistRun`/`PayrollRunSupersededError` (472-495).
- **Owner:** product team (Corrina Bustos / Brian Petros own payroll rules; a developer may rule on the UI part).
- **Workaround, if any:** refuse on any `APPROVED`/`EXPORTED` state and hide the button there — labelled a workaround, the conservative reading of PAY-066.
- **Status:** open

### Q3 — What does Decision 5 change, given auto-recalc on a correction already exists?

- **Question:** Today a correction/resubmit already enqueues a period recalculation (`CORRECTION_RETURNED`) and the week stays held (`awaitingRecalc`) until that run completes. Do you want (a) the hold removed entirely, (b) the hold kept but cleared sooner, e.g. by an employee-week recalc rather than a period run, (c) auto-recalc extended to `RESPONDED` (which writes nothing today), and in every case should any hold, banner or notification remain while the recalculation is queued or if it fails?
- **Why it cannot be answered from what is written:** `decisions/2026-10-06-payroll-calculate-runs-automatically.md` says the hold lasts until the queued run completes and flags are not re-run before then (PAYROLL-FLAGS Q25, K5); it does not say the hold should disappear. D5 says "instead of leaving an admin awaiting-recalc hold" with no failure-path or notification behaviour. The 10-06 note is `reference`, relayed second-hand.
- **Blocked:** REQ-08; gate semantics in REQ-02.
- **Candidates:** the 10-06 decision (13 KB); `payroll-send-backs.service.ts:366-444,704,929`; `payroll-send-backs.repository.ts:618-660`; PAYROLL-FLAGS `spec-u6-u13.md` §12 Q25 (read via grep only).
- **Owner:** Ali Riaz.
- **Workaround, if any:** none — changing the hold moves the approval gate.
- **Status:** open

### Q4 — Does "clean" include the period-level holds, and how does an employee-week recalc interact with them?

- **Question:** (a) Must Approve Week also be hidden while `recalculationHold` (failed run, unconfirmed) or `pendingRecalculation` (run in flight/queued/failed jobs owed) is set — the server already refuses then — and when the week is already `APPROVED`? (b) Is the employee-week recalc blocked while a period run is in flight (409, as `calculate`), and does it satisfy or clear `recalculationHold`/`pendingRecalculation` for that employee or not at all? (c) Does worklist bulk approve also hide/refuse on "row needs recalc"?
- **Why it cannot be answered from what is written:** D2 lists three gate inputs and "no row needs recalc"; the client gate also reads `periodId`/`APPROVED`/`isApproving`; the server additionally reads the two period-level holds. Those holds are keyed on `runs[0]` and period queue jobs, which D4's employee-scoped operation does not obviously touch.
- **Blocked:** REQ-02, REQ-06.
- **Candidates:** `payroll.service.ts:746-830,1107-1128`; `payroll-incomplete-tickets.ts:82-100`; `payroll-employee-timesheet.tsx:118-147`.
- **Owner:** Ali Riaz.
- **Workaround, if any:** treat both holds as part of "clean" (matches the server) — labelled a workaround.
- **Status:** open

### Q5 — With the header Recalculate gone, how does a user recalculate the whole period from the employee screen, and what do the "Recalculate" banners now say?

- **Question:** `payroll-send-back-banners.tsx` ("Recalculate the period before approving"), `payroll-entry-fix-hold-banner.tsx` ("Recalculate to apply"), the failed-recalculation hold banner and the rate-change banner all assume a Recalculate control on this screen. Should they (a) point to the worklist, (b) link/act via the new per-row or an employee-week action, (c) be removed/reworded, and does the rate-change banner stay alongside the row buttons?
- **Why it cannot be answered from what is written:** D1/D3 remove and move the controls; none of the five decisions mentions those banners.
- **Blocked:** Ripple of REQ-01, REQ-04 (not their core behaviour).
- **Candidates:** the five component files listed in §11a (read by grep).
- **Owner:** Ali Riaz.
- **Workaround, if any:** leave banner copy unchanged — labelled a workaround; it will instruct users to use a control that no longer exists.
- **Status:** open

### Q6 — Must a single-employee recalculation be recorded in the run audit log, and does it need a schema change?

- **Question:** PAY-064 records every calculation as a `PayrollRun` with what it priced from. Should an employee-week recalc appear as its own audit entry (author, scope = one employee), and is a new column on `PayrollRun` or `PayrollCalculationJob` acceptable, or must it fit existing columns?
- **Why it cannot be answered from what is written:** `PayrollRun` is period-keyed with `employeeCount`/`laborEntryCount`; the 2026-09-24 run-record decision predates a partial run. The schema question is a developer one (D8) but it depends on this product answer.
- **Blocked:** REQ-06 (shape of D8).
- **Candidates:** `decisions/2026-09-24-payroll-run-records-configuration-and-source-data-used.md` (not read in full); `payroll-audit-log.tsx`.
- **Owner:** product team (audit) / Ali Riaz (schema).
- **Workaround, if any:** none that avoids the choice.
- **Status:** open

## 13. What this spec deliberately does not specify

- Failed-calculation per-row signal — Q1.
- Behaviour on approved/exported weeks — Q2.
- Anything about the awaiting-recalc hold beyond what exists today — Q3.
- Button label, toast and tooltip copy; the visual arrangement of the button beside Sent Back / Flagged chips; role gate of the new route beyond the period button's `payroll:edit`.
- Whether `PAYROLL_ENGINE_VERSION` changes; response/DTO shape; query-key names.
- Mobile: not checked.

## 14. Sign-off before build

- [ ] A real ticket id exists and this folder is renamed
- [ ] Every `[OPEN]` requirement (REQ-05, REQ-08) is answered, or explicitly deferred by a named person
- [ ] Answers written back into `spec.md` with their new sources and flags; the five decisions recorded as a `tcg-scrum` decision note
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [ ] Every §11a ripple row has a source or a §12 question
- [ ] Every §11b `NEEDS A DECIDER` row (D6-D12) has _Chosen_ and _Decided by_ filled by a developer
- [ ] Every §11c sibling has a developer's yes / no / follow-up
- [ ] Decomposed into vertical units — `units.md` (likely over the 400-line PR budget as one unit: engine, api, web split)

Answered by: ______________  Date: ______________

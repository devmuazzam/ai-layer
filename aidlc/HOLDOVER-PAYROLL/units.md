# Units — HOLDOVER-PAYROLL Payroll honours holdover: window math, review batch, correction editor

> Written to `.ai/aidlc/HOLDOVER-PAYROLL/units.md` from the approved `spec.md` beside it,
> 2026-10-26, by `tcg-decomposer` (Opus tier — pay-rule ticket). Consumed by an executor,
> one unit at a time. Field list per `.ai/aidlc/templates/units.md`.

## How to read this plan

- **Input status.** `spec.md` §12 has **0 open questions** — Q1–Q3 answered by the owner
  2026-10-26, Q4–Q11 are decisions the plan already made. Every REQ in §2 carries
  `[UNVERIFIED]` (owner direction / plan, no decision note yet). Per §2b `[UNVERIFIED]` does
  **not** block a unit; it sets each unit's *Weakest source* line and, for the pay rule,
  a pre-merge gate (G4 below).
- **No new questions raised by this decomposition.** Nothing was guessed; every open design
  choice is already an `ASSUMED` item in `spec.md` §14 awaiting sign-off, not a blocker.
- **Three independent vertical units, one per §13 group.** They mirror the spec's proposed
  split exactly: U1 = the pay rule (REQ-01/02/03/04/05/07), U2 = the display batch (REQ-06),
  U3 = the correction editor (REQ-08/09). **U2 and U3 do not depend on U1** (spec §13). None
  stacks on another; see *Sequencing* for the one shared-file caveat.
- **No schema, no migration, no `foundation` unit.** `spec.md` §3: holdover is derived, never
  stored; `dayStartFrom`/`dayStartAt` already exist. G3 does not apply — `TENANT_SCOPED_MODELS`
  untouched, `tcg-prisma-guardian` not required on any unit. (Confirmed, not invented.)
- **Three response-shape changes, each in the unit that owns it** (G5 → `tcg-contract-tracer`,
  callers fixed in the same unit): `PayrollJobDayInput` (engine) in **U1**; the employee-week +
  roster web payload in **U2**; the `PayrollCorrection` response boolean in **U3**.
- **One pay-rule gate (G4), U1 only.** The window-close chain (Q1-B/Q2/Q7) overrides the
  verified yard-to-yard rule; `tcg-scrum` must write the decision note(s) and the provenance
  rows go in `payroll/payroll-rules-provenance.md` in the **same commit** as the code. This is
  a gate, not a code step — recorded in U1.
- **No new tests** (`spec.md` §10, Q11, root `CLAUDE.md`). Every *Tests* row reads
  `not requested`; existing specs are run, not extended.
- **Per-unit size** is rough changed source lines / source files (no budget since 2026-10-21) —
  information for the reviewer.

## Gate baseline

**Gate baseline:** *NOT RUN by the decomposer.* Running `pnpm lint` / `typecheck` / `build` /
`test` on `origin/main` is withheld per the operator's standing instruction (no unprompted
builds/lint/Nx or test runs — they are slow and can stomp a live dev server). This line
records only what is cheaply known on `origin/main` at **`d266176fc`** (2026-10-26):

- lint: root `CLAUDE.md` states **0 errors on every project as of 2026-10-21** — a lint error
  is the executor's; not verified by this run.
- typecheck / build: **not run** — on an 8 GB machine `@tcg/api` lint and build need
  `NODE_OPTIONS=--max-old-space-size=4096` (root `CLAUDE.md`); `@tcg/api:build` has been seen
  to OOM on the default heap in this environment.
- test: **not run** — `@tcg/api` carries ~50 jest failures that are usually pre-existing
  (timeouts under load + spec/tz drift), per the operator's memory note; a red there may be
  inherited.

**Executor: capture a real baseline before U1** — `git fetch origin main`, then a real
`lint`/`typecheck`/`build` run (API with the heap flag) with the developer's go-ahead — and
report each unit's gates against that. Do not treat the bullets above as the baseline; they
are a placeholder because the measured run was not authorised at decomposition time.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | Holdover tickets price on the Start Work → (break-down\|boom\|build-up end) window on every holdover day; explain mirrors it; flags do not mis-fire | REQ-01, REQ-02, REQ-03, REQ-04, REQ-05, REQ-07 | api, payroll-engine, vault | — | ~260 lines / ~12 files | not started |
| U2 | A payroll admin sees the week's holdover tickets grouped by run with a Clean/Flagged display chip on the timesheet page, and a count badge on the worklist row | REQ-06 | api, web | — | ~300 lines / ~16 files | not started |
| U3 | Correcting a Home-start holdover day hides the yard fields, makes Start Work / End Work the pay boundary, and the server refuses to create a yard leg | REQ-08, REQ-09 | api, web | — | ~280 lines / ~16 files | not started |

- **Status** takes exactly one of: `not started` · `in progress — <branch>` · `built — <branch>`
  · `merged — PR #<n>` · `cut — <reason>`. Never a commit SHA. `tcg-executor` writes this cell
  for its own unit; `close-ticket` §1 flips `built` → `merged — PR #<n>`.
- **Requirements covered:** REQ-01..REQ-09 of the 9 in `spec.md` §2, counted 2026-10-26 —
  **9 in the spec, 9 covered, 0 uncovered.** U1: REQ-01/02/03/04/05/07; U2: REQ-06; U3:
  REQ-08/09. Partly-covered note: REQ-05 is covered as the **deferral it specifies** (worked-day
  `subsistenceHoldover` unchanged + a `payroll/gaps.md` note); PAY-049 "every calendar day" is
  explicitly deferred by the spec (Q6), not cut here.
- **Units blocked on an open question:** **none** — `spec.md` §12 has 0 open questions.
- **Raised before build, per §2b (`[UNVERIFIED]` source + a change that is costly to correct):**
  - **U1** is a **pay rule on `[UNVERIFIED]` sources that overrides a `[VERIFIED]` rule**
    (Q1-B/Q2 vs DEC-YARD / DEC-HOME; owner direction relayed 2026-10-26, no decision note yet).
    It is reversible in code (no migration), but it changes the priced figures of every existing
    holdover week on its next recalculation. Settle by: **`tcg-scrum` writes the decision note(s)
    for Q1-B, Q2 and Q7 and the G4 provenance rows land in the same commit as the code** (U1
    gate). Recalculation of already-approved/exported weeks is `NOT SPECIFIED` (spec §13) and
    follows the existing recalculation-hold rules — not decided here.
  - **U2, U3** add only optional response fields and display/validation; both reversible, no
    data touched. No §2b escalation beyond their G5 tracer runs.

---

## U1 — Holdover pay window: derivation, engine field, explain, flags

> **Pre-merge gate (G4, pay rule).** The window-close chain (break-down end → boom end →
> build-up end) is a pay rule whose only sources are the owner's relayed Q1-B/Q2 answers and
> the plan's Q7, with no decision note and overriding the `[VERIFIED]` 2026-09-03 yard-to-yard
> rule. Before this unit merges: `tcg-scrum` writes the decision note(s) for Q1-B, Q2 (partly
> supersedes the verified 2026-10-16 note) and Q7; the provenance rows for REQ-02/03/04 go into
> `payroll/payroll-rules-provenance.md` **in the same commit as the code** (status `Pending`
> until the note exists). This is a gate, not a code step.

- **Outcome:** On a holdover ticket, payable hours price on the window **Start Work → End Work**
  with End Work resolved by break-down end, else boom end, else build-up end — on every holdover
  day (Day 1, middle days, last day; Home-start has no yard leg) — and the payroll explain screen
  shows the same window it priced on. A non-holdover ticket prices byte-identically to today.
- **Kind:** vertical
- **Requirements covered:** REQ-01, REQ-02, REQ-03, REQ-04 — fully; REQ-05 — fully (as the
  deferral it specifies: no code change + a `payroll/gaps.md` deferral note); REQ-07 — fully
  (window-math fix + `withPricedRest` carry + the build-time flag-confirmation sweep recorded as
  findings; **no detector is pre-changed** unless the sweep finds a false positive).
- **Depends on:** —
- **Branch / PR base:** `feat/HOLDOVER-PAYROLL-u1-holdover-pay-window` from `origin/main`.
- **Size estimate:** ~260 source lines, ~12 source files. **This is the largest slice — see the
  size note at the end of the unit.**

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — no schema change, no migration (spec §3). | Confirmed, not invented. |
| API (`apps/api`) | New pure fn `deriveHoldoverPayableWindow(entries, { homeStart, holdover })` beside `deriveTicketTimes` (`usecase/ticket-time-entries/`, D1); call it from `PayWeekAssembler.buildJobDay` (`usecase/payroll-pricing/pay-week-assembly.ts:509-510`) and from `payroll-explain.ts` (`memberPayableWindow`, lines 80, 159) so explain mirrors pricing (D1, §11a row 6); set the engine field on both the priced days and the `contextJobDays` path; resolve holdover per ticket by reusing `resolveHoldoverForRows` (D2); carry `holdoverMidDay` through `withPricedRest` (`payroll-flags/payroll-flag-rest-gap.ts`, REQ-07 — a no-op today, see Ripple); DI/build-time check that the assembler's 2nd caller (`payroll-week-pricing.service.ts`) receives the repository/closure (`grep -rn 'new PayWeekAssembler' apps/api/src`). | The chain/start logic is server-derived from stored `TicketTimeEntry` rows; the engine is handed the resulting window, not the rule (D1). Leave `holdoverMidDayTicketIds` as is (D2 follow-up). **Build-time flag-confirmation sweep** (REQ-07, F1): check every reader of a yard/window row for a false positive on a holdover ticket; only `INVALID_TIME_24H_OR_MORE` reads the priced window; `LONG_BOOM`/`MISSING_START_OR_END`/`am-pm`/`LABOR_TICKET_MISMATCH` read the raw `WORK_TIME`/`timeEntries` and are unchanged by the window move — if any still mis-fires, one flag, one change, one recorded finding. Do **not** edit the detectors otherwise. |
| Web (`apps/web`) | N/A — no web change in this unit. | The web `PayrollJobDay` display payload is U2; this unit changes only the priced figures on the existing payload (new optional engine field is type-only). |
| Mobile (`apps/mobile`) | N/A — mobile unchanged; optional engine field does not affect it (§11a row 3). | |
| Shared (`packages/shared`) | N/A — `FieldTicketHoldover` reused unchanged. | The engine field lives in `packages/payroll-engine`, a different package. |
| `packages/payroll-engine` | Add **optional** field `holdover?: { dayNumber: number; isLastDay: boolean; dayStartFrom?: 'YARD' \| 'HOME' }` to `PayrollJobDayInput` (`src/types.ts:87`), re-exported from `src/index.ts:76` (D3). **G5 — `tcg-contract-tracer`** on this shape; callers fixed in this unit. | Optional ⇒ breaks no constructor. The two literal producers (`seed-payroll-demo.ts`, `payroll-flag-detection.service.spec.ts`) keep compiling (D3, §11a row 2). The engine carries the field for explain/audit only — it does not interpret it (REQ-01 Notes). |
| Vault | Append a dated PAY-049 deferral note under the existing entries in `payroll/gaps.md` (REQ-05); add the G4 provenance rows in `payroll/payroll-rules-provenance.md` for REQ-02/03/04 (same commit). | The gaps append is any agent's write path; the provenance rows follow `tcg-scrum`'s decision note. `Job.subsistenceHoldover` is **not** merged with `JobResource.isHoldover`. |
| Tests | `not requested` (spec §10, Q11). Existing specs must still pass and keep compiling: `pay-week-assembly.spec.ts`, `payroll-flag-invalid-times.spec.ts`, `derive-ticket-times.spec.ts`, and any constructing `PayrollJobDayInput` (field optional). | Run, do not extend. |

### Reviewable as

- **Demo:** run payroll on a holdover fixture — a middle day with a recorded break-down ends on
  the break-down end; a day with boom but no break-down ends on the latest closed boom end; a
  build-up-only day ends on its build-up end; a Home-start day prices Start Work → chain End Work
  with no yard leg. The payroll explain screen shows the same window. A non-holdover ticket is
  unchanged.
- **Acceptance:** `spec.md` REQ-02 (window end by chain, middle day as last day), REQ-03
  (Home-start start/end), REQ-04 (reach across all holdover days), REQ-07 (24h does not mis-fire
  under 24 h; `withPricedRest` carries `holdoverMidDay`; no new `PayrollFlagCode`), REQ-01
  (field set from the server source, absent on non-held).
- **Reviewer can verify without:** U2, U3; without any UI (API + explain only).

### Risk

- **Weakest source:** `[UNVERIFIED]` — owner direction (Q1-B/Q2, relayed, no decision note) and
  the plan (Q7); overrides the `[VERIFIED]` DEC-YARD and partly supersedes the `[VERIFIED]`
  DEC-HOME. **This is the §2b pay-rule case — gated above (G4).**
- **Migration reversible:** N/A — no migration. Code revert is clean.
- **Behind a flag:** no.
- **Touches existing data:** no row is rewritten; but the new window **re-prices every existing
  holdover week on its next calculation**. Approved/exported weeks follow the existing
  `preserveApprovals` / recalculation-hold mechanics; whether settled periods are recalculated is
  `NOT SPECIFIED` (spec §13) — a developer decision at rollout, not built here.
- **Blast radius:** the engine's ST/OT/DT split, rest-gap chain, meals, guarantees,
  `PayrollJobDay`, ADP export — all on **holdover days only**. A wrong window = wrong pay. The
  `ASSUMED` fallbacks (D8: no closed break-down/boom/build-up → raw `WORK_TIME` end; multiple
  boom sessions → latest closed end; member own-window still wins) are pay amounts with no
  source — confirm at sign-off (spec §14).
- **Guardian / tracer:** `tcg-prisma-guardian` **not required** (no schema). `tcg-contract-tracer`
  **required** on `PayrollJobDayInput` (D3, G5).

### Ripple — what already works that this unit reaches

From `spec.md` §11a rows 1–10, narrowed to what this slice touches.

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| `PayWeekAssembler.buildJobDay` + both callers (`PayrollService.executeRun`, `PayrollWeekPricingService` / `week-pricing-override.ts`) | `PayrollJobDayInput` + priced window | existing `pay-week-assembly.spec.ts` must pass; non-holdover run prices byte-identically (manual fixture) | spec REQ-01/02/03; §11a row 1 |
| `seed-payroll-demo.ts`, `payroll-flag-detection.service.spec.ts` (literal `PayrollJobDayInput`) | engine type | build-time compile check — field is optional (D3) | §11a row 2 |
| web `features/payroll/lib/payroll-week.ts`, mobile `features/field-ticket/**` | `payroll-engine` package | build-time compile check — type-only optional field | §11a row 3 |
| `payroll-explain.ts` (`memberPayableWindow`) | raw `payableWindow` | **changed in this unit** to call the same derivation (D1) so explain == priced; verify a holdover explain screen shows the chain window | spec REQ-02; §11a row 6 — build-time confirm |
| `entry-fix-plan.ts`, `ticket-worked-hours.ts`, `ticket-labor-entries.service.ts`, `ticket-time-entries.service.ts`, `derive-ticket-progress-view.ts` | raw `payableWindow` / `deriveTicketTimes` | **not touched** — they keep the raw window (owner Q3-A); confirm by not editing `deriveTicketTimes.payableWindow` itself (D1) | owner Q3-A; §11a rows 7–8 |
| Flags: `INVALID_TIME_24H_OR_MORE`, `REST_UNDER_8H`, `LABOR_TICKET_MISMATCH`, `LONG_BOOM`, `MISSING_START_OR_END`, `am-pm`, Samsara, crew-yard-mismatch, `MISSING_NOTES` | `shiftStartedAt/EndedAt` / raw rows / `holdoverMidDay` | the REQ-07 build-time confirmation sweep on a holdover fixture is the check; three REQ-15 exemptions still don't fire on a middle day; `24H` doesn't fire under 24 h; a finding is recorded if any mis-fires | spec REQ-07 F1; §11a rows 9–10 |
| `PayrollJobDay` rows, ADP paydata export | persisted figures | change on the next calculation only; past runs/exports unchanged (§13) | `NOT SPECIFIED` for settled weeks → §13 |

**Pre-existing-consumer note (SCRUM-900 SD-1):** `payroll-explain.ts` is an existing consumer of
the raw window; moving pricing without moving explain would leave explain describing a different
window than was priced — hence explain is **changed in this unit**, not deferred. The flag
detectors are existing consumers checked by the REQ-07 sweep, not by the new call site alone.

### Deliberately not in this unit

- The display batch and worklist badge — **U2** (independent; does not depend on this unit).
- The correction editor Home-start behaviour — **U3** (independent).
- PAY-049 "every calendar day" subsistence — deferred by the spec (Q6); only the gaps note lands.
- Refactoring `PayrollService.holdoverMidDayTicketIds` onto `resolveHoldoverForRows` — a §11c
  follow-up, not required (D2).
- Any engine-side rule using the carried `holdover` field — `NOT SPECIFIED`; would be a new
  requirement (REQ-01 Notes).

**Size note.** U1 is the largest slice (engine type + pure derivation + two call-site wirings +
`withPricedRest` carry + the flag sweep + DI check + two vault files). I considered splitting it
into U1a (engine field + derivation + assembler + explain) and U1b (REQ-07 flag sweep + carry)
and **recommend against it**: U1a alone would ship a re-priced holdover window whose effect on
the flag detectors is unverified until U1b, which is exactly the kind of deferred integration the
sweep exists to catch — and the `withPricedRest` carry is a no-op today, so U1b would be a
near-empty PR. REQ-01's engine field is likewise not a separable `foundation` unit: it ships
nothing observable alone ("carried not interpreted", D3) and only this unit consumes the value.
Keep as one unit; the gate (G4) is the real sequencing constraint, not size.

---

## U2 — Holdover review batch (display only) + worklist count badge

- **Outcome:** On the employee timesheet page a payroll admin sees the week's holdover tickets
  grouped by run, each as "Day d of D" with a derived **Clean / Flagged** display status and a
  summary chip; the worklist row shows a small holdover-count badge. It never writes a
  `PayrollFlag` and never blocks approval or export.
- **Kind:** vertical
- **Requirements covered:** REQ-06 — fully.
- **Depends on:** — (independent of U1; uses the existing holdover resolution and existing
  payloads, and derives Clean/Flagged from `holdoverNeedsDayStart`, not from pricing).
- **Branch / PR base:** `feat/HOLDOVER-PAYROLL-u2-holdover-batch` from `origin/main`.
- **Size estimate:** ~300 source lines, ~16 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A. | |
| API (`apps/api`) | Extend `getEmployeeWeek` (`payroll.service.ts:1050-1105`) so each `jobDays[]` item gains `holdover?: { dayNumber, totalDays, isLastDay, dayStartFrom?, dayStartAt? }` + a run key (`parentJobId` + `jobResourceId`) via the existing `.map((day) => ({ ...day, ...x }))` seam (D6); extend the roster build (`payroll.service.ts:~985-1030`) with `holdoverCountsByEmployeeId` beside `sendBackCountsByEmployeeId` (§11c "counts by employee id"); resolve via `resolveHoldoverForRows` (D2). **G5 — `tcg-contract-tracer`** on both response shapes; web types fixed in this unit. | Response = **new optional fields only**, none removed. Approval/export gates (`isApproveWeekDisabled`, `payroll-export-blockers.ts`, `payroll-approval-gate.ts`) are **not touched** (Q4). Overlay-only / not-yet-priced holdover tickets are `ASSUMED` excluded from the batch (spec §14 — confirm at sign-off). |
| Web (`apps/web`) | Update the `PayrollJobDay` type + roster type (same unit, G5); new pure `holdoverDisplayOf(holdover)` in `features/payroll/lib/` using `holdoverNeedsDayStart` from `@tcg/shared` (D5 — Flagged = Day-2+ with no day-start, Clean otherwise); new `PayrollHoldoverBatch` feature component under `features/payroll/components/`, composed in `payroll-employee-timesheet.tsx`; reuse `SectionCard` + the `Chip` tone map from `payroll-status-chip.tsx` (export/extract it — D5), the "n of N" chip pattern of `components/organisms/entity-photos/photo-batch.ts`; a count badge beside the existing `sendBackCounts` render in `payroll-worklist-list.tsx`. | Feature-first; nothing new in `components/`. Test IDs `payroll-holdover-*` (`grep -rn 'payroll-holdover' qa-automation/e2e` — none expected). Copy limited to "Day d of D", "Clean", "Flagged" + numerals; chip/footnote text `NOT SPECIFIED`, left to sign-off (spec §5, §13). The batch's "Flagged" is a **display label only** — never a `PayrollFlag` (spec §11c). |
| Mobile (`apps/mobile`) | N/A — not changed. | |
| Shared (`packages/shared`) | N/A — `holdoverNeedsDayStart` reused; the display type lives in `features/payroll`, not shared (D6). | |
| Tests | `not requested`. Existing web `jobDays` readers and roster readers must still pass. | Run, do not extend. |

### Reviewable as

- **Demo:** open `/payroll/[employeeId]` for a week with a Day 2 of 3 holdover ticket with
  `dayStartFrom` null → batch shows "Day 2 of 3 — Flagged"; set `dayStartFrom` → "Clean"; Day 1 →
  always Clean. Worklist row shows a count only when ≥ 1. Approve/export availability is identical
  with and without holdover tickets present; no `PayrollFlag` row is written.
- **Acceptance:** `spec.md` REQ-06 acceptance lines (Flagged/Clean derivation, Day 1 clean,
  `canApprove`/export unchanged, badge only when ≥ 1, no `PayrollFlag`).
- **Reviewer can verify without:** U1, U3; without the pay-math change (display derives from
  `dayStartFrom`, not the priced window).

### Risk

- **Weakest source:** `[UNVERIFIED]` — PLAN + TF-SPEC REQ-07/09; display-only, informational.
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no — read-side only, optional response fields.
- **Blast radius:** the employee timesheet page composition and the worklist row. If the
  Clean/Flagged predicate is wrong it mislabels a chip; it cannot block approval/export (those
  gates are untouched) and writes no flag.
- **Guardian / tracer:** `tcg-prisma-guardian` **not required**; `tcg-contract-tracer`
  **required** on the `getEmployeeWeek` job-day shape and the roster map.

### Ripple — what already works that this unit reaches

From `spec.md` §11a rows 11–13.

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| web `PayrollJobDay` readers (`payroll-employee-table*`, `payroll-employee-daily.tsx`, `payroll-expanded-*`) | `getEmployeeWeek` payload | new **optional** fields only; existing web payroll tests must pass; load the timesheet page by hand | spec REQ-06; §11a row 11 |
| roster consumers (`payroll-worklist*.tsx`, `payroll-week-entries.service.ts:94`, `payroll-worklist.helpers.ts:96`) | `GET …/employees` | new optional map; load the worklist by hand | spec REQ-06; §11a row 12 |
| approve / export gates (`isApproveWeekDisabled`, `payroll-export-blockers.ts`, `payroll-approval-gate.ts`) | approval / export | **not touched** — confirm `grep` shows no edit; approve a week with holdover tickets present and see it behave as today | Q4; §11a row 13 |

**Pre-existing-consumer note:** every current `jobDays`/roster reader is checked by loading the
two pages by hand (no new test per `CLAUDE.md`), because the only change is additive optional
fields; the approval/export gate is checked by confirming it is not edited and exercising an
approval with holdover tickets present.

### Deliberately not in this unit

- The pay-math window change — **U1** (independent; this unit's display does not depend on it).
- The correction editor — **U3**.
- Batch/chip/footnote copy beyond "Day d of D"/"Clean"/"Flagged"; whether overlay tickets appear
  in the batch — `NOT SPECIFIED`, sign-off decides (spec §13).

---

## U3 — Correction editor: Home-start holdover day (hide yard, server refuses a yard leg)

- **Outcome:** Opening the correction dialog for a Home-start holdover day hides Left Yard /
  Arrived Yard, presents Start Work / End Work as the load-bearing pay-boundary fields, and the
  server never creates a `YARD_TIME` leg nor enforces the yard chain for that day — every other
  day is unchanged.
- **Kind:** vertical
- **Requirements covered:** REQ-08, REQ-09 — fully.
- **Depends on:** — (independent of U1 and U2).
- **Branch / PR base:** `feat/HOLDOVER-PAYROLL-u3-correction-home-start` from `origin/main`.
- **Size estimate:** ~280 source lines, ~16 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A. | |
| API (`apps/api`) | `PayrollSendBacksService.buildCorrectionView` (`payroll-send-backs.service.ts:826-880`) returns a server-derived read-only `isHomeStartHoldover?: boolean` (beside `usesOwnWindow`) on `GET …/payroll-corrections/:id` and the entry route — derived from the stored ticket (`dayStartFrom = HOME` && `dayNumber ≥ 2`) on **every** read and submit (D4); `plan-correction.ts` `setWindow(YARD_TIME, …)` must **not** create/move a yard leg on that day (400 on a submitted yard edge — ASSUMED); `correction-rules.ts` `findCorrectionOrderViolation` must not enforce the yard edges on that day; DI: `PayrollSendBacksModule` registers `TicketHoldoverRepository` as a bare provider (D7); resolve via `resolveHoldoverForRows` (D2). **G5 — `tcg-contract-tracer`** on the `PayrollCorrection` response; web type fixed in this unit. | **Do not add a flag to the request** (`SubmitCorrectionDto`/`CorrectionTimesDto` unchanged) — a client-sent flag is a trust-boundary hole; the server derives it (D4, deviates from the plan's "through `SubmitCorrectionPayload`" wording — developer reviews). `findCorrectionOrderViolation` already skips a missing entry, so the change only bites when a yard row exists or an edit would add one. |
| Web (`apps/web`) | Add `isHomeStartHoldover?` to the web `PayrollCorrection` read type (same unit, G5); in `CorrectionDialog` / `correction-times-section.tsx`, filter `TIME_FIELDS` to hide Left Yard / Arrived Yard on a Home-start holdover day, keep the "Must be after <previous>" lookup on the **visible** list (not a hidden field), present Start Work / End Work as the load-bearing pay fields, add a holdover variant of the window footnote; reuse `SectionCard`, `TimeField`, theme variables only. | Supersedes the plan's "arrivedOnSiteAt/leftJobSiteAt load-bearing" (owner Q2 → Start Work/End Work). What "load-bearing" looks like + footnote copy `NOT SPECIFIED` (spec §5/§13). `ASSUMED`: show yard fields when a `YARD_TIME` row exists on a Home-start day (no silent data hiding) — confirm at sign-off. Send-back popup and `payroll-entry-fixes` **not touched** (§13/§11c follow-up). |
| Mobile (`apps/mobile`) | N/A. | |
| Shared (`packages/shared`) | N/A — do **not** add a boolean to `CorrectionTimes` (breaks `keyof CorrectionTimes`, D4). | |
| Tests | `not requested`. Existing `plan-correction`/`correction-rules.spec.ts` and correction web tests must still pass. | Run, do not extend. |

### Reviewable as

- **Demo:** open Adjust Entries (and the returned-entry dialog) for a Home-start holdover day →
  no Left Yard / Arrived Yard inputs, the other six time fields shown, Start Work / End Work
  presented as the pay boundary; `PATCH` carrying `leftYardAt`/`arrivedYardAt` for that day →
  400, no `YARD_TIME` row created; `PATCH` of only `arrivedOnSiteAt`/`leftJobSiteAt` → passes the
  order check with no yard step. Any other day shows all eight fields and behaves as today.
- **Acceptance:** `spec.md` REQ-08 (hidden fields, other days unchanged, payload omits yard keys)
  and REQ-09 (`GET` returns the indicator; yard edge refused; non-holdover unchanged).
- **Reviewer can verify without:** U1, U2; the correction read/submit is self-contained once the
  DI provider is wired.

### Risk

- **Weakest source:** `[UNVERIFIED]` — PLAN + DEC-HOME (verified, for the surviving "no yard
  step" part) + owner Q2 for the Start Work/End Work boundary. D4 deviates from the plan's
  wording deliberately — developer reviews.
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no — read indicator + validation path; no row rewritten.
- **Blast radius:** the one shared `CorrectionDialog` (both direct and send-back modes) and the
  correction plan/rules path. A wrong Home-start derivation would hide yard fields on the wrong
  day, or refuse a valid yard edge — both bounded to the correction flow; `payroll-entry-fixes`
  is a separate, untouched path.
- **Guardian / tracer:** `tcg-prisma-guardian` **not required**; `tcg-contract-tracer`
  **required** on the `PayrollCorrection` response boolean.

### Ripple — what already works that this unit reaches

From `spec.md` §11a row 14.

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| `CorrectionDialog` + sections, `correction-times-section.tsx` ("Must be after <previous>") | `TIME_FIELDS` | on a non-Home-start day all eight fields render and validate as today (open the dialog by hand); the previous-field lookup runs on the visible list | spec REQ-08; §11a row 14 |
| `build-correction-payload.ts` (`TIME_KEYS`), `correction-flag-resolution.ts:15` (`YARD_TIME → arrivedYardAt`) | `keyof CorrectionTimes` | **not changed** — no boolean added to `CorrectionTimes` (D4); build-time compile check | D4; §11a row 14 |
| `PayrollSendBacksService` view / preview / submit (`buildCorrectionView`, `prepareCorrection` → `planCorrection`, `buildCorrectionPreview`, `checkCorrectionRules`) | `planCorrection`, `findCorrectionOrderViolation` | a non-holdover correction submit/preview behaves exactly as today (existing `plan-correction`/`correction-rules.spec.ts` pass + a manual non-holdover submit) | spec REQ-09; §11a row 14 |
| `PayrollSendBacksModule` DI | new `TicketHoldoverRepository` provider | the module boots and existing correction routes still resolve (D7) | D7 |

**Pre-existing-consumer note:** the correction dialog and the `planCorrection`/order-check path
have pre-existing callers on every day type; this unit changes behaviour **only** on a Home-start
holdover day, so the regression check is a non-holdover correction exercised by hand plus the
existing correction specs — the new Home-start path does not cover the old one.

### Deliberately not in this unit

- The pay-math window change — **U1**.
- The display batch / worklist badge — **U2**.
- `payroll-entry-fixes` (Payroll's own entry correction, a second path using `deriveTicketTimes`)
  and the send-back popup — the plan excludes them; §11c follow-up, recorded so they are not
  forgotten.

---

## Sequencing

```
U1  (pay-math)          ── independent ──▶ merge
U2  (display batch)     ── independent ──▶ merge
U3  (correction editor) ── independent ──▶ merge
```

- **Parallelisable:** all three are developable in parallel — **no unit depends on another**
  (spec §13; U2/U3 derive from existing holdover resolution and `dayStartFrom`, not from U1's
  priced window). The **one collision caveat:** U1 and U2 both edit
  `apps/api/src/usecase/payroll/payroll.service.ts` — U1 at the assembler construction (`:356`)
  and the `withPricedRest` call (`~:702`), U2 at `getEmployeeWeek` (`~:1050-1105`) and the roster
  build (`~:985-1030`). Different regions, but the **same file**, so they are not merge-free: the
  second of U1/U2 to land rebases onto the first. U3 touches only `payroll-send-backs/*` and
  `payroll-corrections` web — no overlap with U1 or U2, so U3 is cleanly parallel to both.
  All three reuse `resolveHoldoverForRows` read-only (no edit), so that is not a collision.
- **Merge order constraint:** none hard. If U1 and U2 are built concurrently, pick a merge order
  for `payroll.service.ts` and rebase the second. No migrations exist, so there is no migration
  ordering.
- **First unit to ship:** **U1** — it tests the riskiest assumption in the whole plan (the
  window-close chain overriding the `[VERIFIED]` yard-to-yard rule, on `[UNVERIFIED]` owner
  direction), and it is the pay rule the ticket exists for; shipping it first surfaces a wrong
  window before any display or editor is built on top of the holdover concept. **But U1 is gated
  on G4** (decision note + provenance). If the developer wants to keep moving while `tcg-scrum`
  writes that note, **U2 or U3 can start immediately** — both are unblocked, lower-risk, and
  independent of U1. Recommended practical order: start U1's G4 gate (tcg-scrum) now; build U2
  and/or U3 in parallel; land U1 once the decision note exists.

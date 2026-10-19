# Units — TICKET-FLOW-SLOTS-HOLDOVER Slot-driven steps, floating checklists, holdover flow, late and incomplete tickets

> Written to `.ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/units.md` from the approved `spec.md` beside it (decomposed 2026-10-16).
> Starting point: the unit table in `/home/codingcops/.claude/plans/right-now-we-display-whimsical-squirrel.md`. That file is outside the repo and the overlay, so it is not durable; everything an executor needs from it is restated below.
> Consumed by an executor, one unit at a time. Nothing has been implemented.
> Spec was read by section (`spec.md` is 80 KB): §1, §2 (all REQs), §3–§14.

## Read first — what this decomposition changed, and what it could not settle

### Changes from the plan's unit table (ids and branch chain are kept)

| # | Change | Why |
| --- | --- | --- |
| C1 | **H2 absorbs `FieldTicket.holdover`; H3 is the `PATCH day-start` only.** Plan H2 was repository + util + service + migration with no caller, H3 added the field. | The plan's H2 is dead code until H3. A reader can now see "Day 2 of 3" on `GET /field/tickets` after H2. |
| C2 | **M3 = End Work step (record the End Work time); M4 = End Work summary card.** Plan had M3 = summary, M4 = body. | Plan M3 (a pure summary function) renders nothing on its own. The restored files are `EndWorkBody.tsx` 436 lines + `end-work-summary.ts` 87 lines at `30f0e4b0f^`, about 523 source lines together, **over the 400-line budget**. The split follows the body's own seam (`EndWorkSummaryCard`, lines 71–177 of the old file). **Unverified:** I did not check that the card separates cleanly. If it does not, the executor stops and a developer sets a per-PR `size-exception`; the units do not get merged. |
| C3 | `resolve-step-kind` `endWork: 'timer'` moves from H1 to **M1**. | It is a mobile file. H1 stays shared-types only, the only thing the foundation exception allows. |
| C4 | **All six `ActivityLogAction` members are added in LT2**, not LT9. LT9 keeps only the snapshot-diff interceptor. | LT5 writes `TICKET_LATE_COMPLETED`, LT6 writes requested / approved / denied, LT8 writes expired. All run before plan LT9. One migration instead of a second against the same enum. |
| C5 | **LT15 = Home "Incomplete" section (view); LT16 = request flow (hooks, sheet, state changes).** Plan LT15 was "contract, editability helper, request hooks" with no screen. | Plan LT15 is a data layer with nothing to look at, and it has two consumers, not three. |
| C6 | **LT2 ships without the `completedAt` backfill.** | The no-matching-row rule is `NOT SPECIFIED`. Question Q9 (added to `spec.md` §12). |
| C7 | **LT4 ships without the audit row for an accepted late-captured op.** | No `ActivityLogAction` member fits. Question Q10. |

### Blocked or constrained on open questions

- **Q1–Q4 are open. No unit builds REQ-30, 31, 32 or 33.** Where a unit's "worker" could mean an Operator folded onto an Oiler's ticket, that case is listed under *Deliberately not in this unit* (Q1). The executor builds nothing for it.
- **Q9** (new, `spec.md` §12): blocks the LT2 backfill and the NULL-`completedAt` branch of the late flag in LT11. Both cut out.
- **Q10** (new): blocks the audit row in LT4.
- **Q11** (new): LT4 enforces the window on merge, with no way to request approval until LT6 and LT16 exist. Until answered, treat the constraint "LT4 does not merge before LT6" as binding.
- Q5, Q6, Q7, Q8 are resolved in `spec.md` §12 (Haris, 2026-10-16) and are used as resolved. The text of REQ-02, 09, 15, 22 in §2 still says "OPEN / blocked on Q5, Q6, Q8" — the write-back in `spec.md` §14 is not done. I followed §12. Someone should update §2 so the next reader does not see a contradiction.

### Gates the executor must check before any unit (not decided here)

- **`spec.md` §11b D1–D10 and §11c have no *Chosen* or *Decided by* entries.** Each unit below that adds a table, column, enum member, endpoint, exported service or dependency names the §11b row it needs. Per root `CLAUDE.md`, an AI never fills *Decided by*. The executor stops on a unit until the named row has a developer's name on it.
- **Pay-rule provenance.** Q5 is a pay-rule change (Home-start day: paid time = Arrive Job Site to Left Job Site). `contexts/payroll-engine.md` requires its source in `vault/payroll/payroll-rules-provenance.md` in the same commit as the rule. M2 (the unit where a Home start first exists) must check whether any engine file changes; if one does, the provenance entry ships in that PR. U3 (STANDARD meals on the engine's fallback schedule) has the same check. I did not open the engine.
- **`[UNVERIFIED]` + hard to undo, raise before building:** (1) LT2 adds six `ActivityLogAction` enum members. Postgres enum values cannot be dropped, and Q10 may want a seventh. Settle Q10 first, or accept two migrations. (2) H2 adds an enum type and a CHECK; both are droppable, so routine.

---

## What a unit is

A unit is a vertical shippable slice, reviewable alone. Three kinds appear here:

- **Foundation (exception granted, three named consumers each):** H1, LT1, LT2.
- **Vertical, user-visible on its own surface:** U1–U6, M1–M6, LT3, LT13–LT17, H6 (web).
- **API behaviour slices (H2–H5, LT4–LT12):** each delivers one server-side behaviour that is checkable by an HTTP call or an existing client against the spec's acceptance line, and each is the only place that behaviour is built. They are **not** a backend half of a screen that only appears in a later unit's PR. The mobile or web consumer of each is a separate surface (`contexts/mobile.md`: "web and mobile is usually two units"). Where that consumer needs the API in production, *Sequencing* states the runtime dependency.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | Crews get the Start Work time adjustment controls in every EAS build | REQ-06 | mobile (config, test) | — | S | not started |
| U2 | Roster and ticket seat follow the DAS slot; `GET /field/tickets` returns `stepFlow` per caller | REQ-01, REQ-05 (crew grouping) | shared, api | — | M | not started |
| U3 | A 3rd man's Left Job ends their on-site time; labor writes, submit evidence and web job-progress use the slot | REQ-02 (API), REQ-04 (evidence), REQ-05 (guard, labor, progress) | api | U2 | M | not started |
| U4 | A Rigger in an Oiler slot sees 14 steps, an Oiler in a STANDARD slot sees 8 | REQ-01, REQ-02, REQ-05 (mobile) | mobile | U3 | M | not started |
| U5 | Pre-Trip, Post-Trip and JSA no longer block the next step; Submit lists what is missing | REQ-03, REQ-04 (mobile), REQ-05 (web progress) | mobile, web | U4 | M | not started |
| U6 | The API refuses a submit with required steps missing | REQ-04 (API) | deploy config | U3, U5, H4, M6 + build on phones | S | not started |
| H1 | Shared holdover step lists and types exist for every consumer | REQ-08 (shared), REQ-09 and REQ-10 (types) | shared | U5 | M | not started |
| H2 | `GET /field/tickets` says "Day 2 of 3" and what state the crane was left in | REQ-07 (API), REQ-10, REQ-09 (columns) | schema, api | H1 | M | not started |
| H3 | A worker's Yard / Home day start is stored and idempotent | REQ-09 (endpoint) | api | H2 | S | not started |
| H4 | End Work closes the boom on holdover tickets; the submit guard knows holdover lists | REQ-11 (API), REQ-14 (API), REQ-04 (holdover), REQ-17 | api | H3 | M | not started |
| H5 | Open yard time on a middle day raises no payroll flag | REQ-15 | api | H2 | S | not started |
| H6 | Web job-progress shows each holdover day's real steps | REQ-16 | api, web | H2 | M | not started |
| M1 | Mobile shows the Holdover badge and the right step list per day | REQ-07 (mobile), REQ-08 (mobile), REQ-11 (kind, fixtures, drain), REQ-17 | mobile | H1 | M | not started |
| M2 | A worker picks Yard or Home on Day 2+, offline too | REQ-09 (mobile) | mobile | M1 (+ H3 deployed) | M | not started |
| M3 | A worker records End Work on a holdover ticket | REQ-11 (record step, bounds) | mobile | M2 (+ H4 deployed) | M | not started |
| M4 | End Work shows the day summary: work time, boom sessions, lunch, other | REQ-11 (summary) | mobile | M3 | M | not started |
| M5 | Start Work on a held day starts the boom; unknown crane state offers Start or Skip Build Up | REQ-12, REQ-14 (boom start) | mobile | M4 | M | not started |
| M6 | End Work asks Leave set up or Start Breakdown; last day requires break-down | REQ-13, REQ-14 (`closeBillableWindow` guards) | mobile | M5 | M | not started |
| LT1 | Shared window helper and constants exist | REQ-18 (helper) | shared | — | S | not started |
| LT2 | Edit-request table, `completedAt`, six audit actions exist | REQ-18 (column), REQ-21 (model), REQ-24 (members) | schema, api | LT1 | S | not started |
| LT3 | Payroll Manager can use `payroll-admin:edit` routes | REQ-22 | api (seed, data migration) | — | S | not started |
| LT4 | Writes after the window return 409, comments pass; offline ops use capture time | REQ-19 (window, comments, reject), REQ-27 (API), REQ-28 (server rule) | api | LT2 | M | not started |
| LT5 | Submit stamps `completedAt`, locks the ticket, logs late completion | REQ-18 (stamp), REQ-20 (API), REQ-24 (late row) | api | LT4, rebase after U5 | M | not started |
| LT6 | A worker can request approval; payroll can approve or deny; approved week is never touched | REQ-21 (API), REQ-19 (lock, actors), REQ-24 (request rows) | api | LT5 | M | not started |
| LT7 | Payroll admins and workers get the request notices | REQ-23 (notices) | api | LT6 | M | not started |
| LT8 | Requests expire on schedule; +12h and +20h reminders go out | REQ-23 (reminders), REQ-21 (expiry), REQ-24 (expired row) | api | LT7 | M | not started |
| LT9 | Every edit made under approval writes a field-level audit row | REQ-24 (edited-under-approval) | api | LT6 | S | not started |
| LT10 | `GET /field/tickets` carries the `incomplete` bucket, window, request and server time | REQ-26 (API), REQ-18 (read), REQ-21 (read) | api | LT6, after H3 | M | not started |
| LT11 | Payroll can list late tickets; job-day payload carries `completedAt` / `completedLate` | REQ-25 (API), REQ-18 (late flag, not the NULL branch) | api | LT6 | M | not started |
| LT12 | Payroll week overlay uses business-time scheduled end | REQ-29 | api | LT1 | S | not started |
| LT13 | Payroll admin opens `/payroll/late-tickets` and sees three tabs | REQ-25 (page) | web | LT11 | M | not started |
| LT14 | Payroll admin approves or denies from the page; Late badge, sidebar, notification link | REQ-25 (badge), REQ-21 (web), REQ-23 (web nav) | web | LT13 (+ LT6, LT7 deployed) | M | not started |
| LT15 | Mobile Home shows an "Incomplete" section with countdowns | REQ-26 (view) | mobile | LT10 | M | not started |
| LT16 | A worker requests approval from the card and sees the state | REQ-21 (mobile), REQ-26 (states) | mobile | LT15 (+ LT6 deployed) | M | not started |
| LT17 | Mobile edits an approved or in-window ticket; offline ops carry capture time; 409 shows a call to action | REQ-20, 27, 28, 19 (mobile), REQ-23 (tap) | mobile | LT16, after U5 / M6 (+ LT4, LT5 deployed) | M | not started |

**Counts.** 35 units: 3 foundation (H1, LT1, LT2), 32 vertical or behaviour slices. By prefix: U 6, H 6, M 6, LT 17 = 35.

- **Requirements not covered by any unit:**
  - REQ-30 — `[OPEN]`, Q1. No unit builds a path for an Operator folded onto an Oiler's ticket.
  - REQ-31 — `[OPEN]`, Q2. No departed-employee path.
  - REQ-32 — `[OPEN]`, Q3. No gate beyond the existing `isFutureFieldTicket` date-order guard.
  - REQ-33 — `[OPEN]`, Q4. Behaviour stays as today; spec says add no code.
- **Requirements covered in part:**
  - REQ-18: LT1 + LT2 + LT5 + LT10 + LT11, **not** the legacy `completedAt` backfill or the NULL late-flag branch (Q9).
  - REQ-28: LT4 + LT17, **not** the audit row (Q10).
  - REQ-17 is a rollout constraint, not code: H2/H3/H4 add no flag and M1–M6 add none; see *Sequencing*.
- **Count check:** 33 REQs in spec; 29 appear in a unit (REQ-01..29); 4 uncovered (REQ-30..33). 29 + 4 = 33.
- **Units blocked on an open question:** none is wholly blocked. Cut down: LT2 (Q9, Q10 pending), LT4 (Q10, Q11 merge timing), LT11 (Q9), and every unit touching a "worker" notion (LT4, LT6, LT10, LT15, LT16, LT17) leaves the folded-Operator case out (Q1).
- **Units whose ripple rows still lack a test or a source:** none after the required rows below are written. Several rows say **none — unbuilt**: that means the unit must write that regression test, not skip it. Rows with no source for what happens to the consumer: none left (spec rows 13, 15, 17, 19 are answered by Q5, Q8, Q8, Q6).

---

## U1 — Time-adjustment flag in every EAS build

- **Outcome:** a crew member on any installed build sees `WorkTimeStopControl` and the Start Work plus/minus stepper.
- **Kind:** vertical
- **Requirements covered:** REQ-06, fully.
- **Depends on:** —
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-u1-eas-time-adjust` from `origin/main`.
- **Size estimate:** ~5 source lines, 1 source file (`eas.json`); the guard test is excluded from the count.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A — none | |
| API | N/A — none | |
| Web | N/A — none | |
| Mobile | `apps/mobile/eas.json` `base` env adds `"EXPO_PUBLIC_ENABLE_SEGMENT_TIME_ADJUST": "true"` | reverses commit `85f293978` (TCG-8) |
| Shared | N/A — none | |
| Tests | `apps/mobile/data/eas-build-env.guard.test.ts`: allow this one key in `base`, still fail any other `EXPO_PUBLIC_ENABLE_*` key in `base`, `preview`, `production` | the test keeps `FORBIDDEN_KEY_PATTERN = /^EXPO_PUBLIC_ENABLE_/` and gains one named allow-list entry |

### Reviewable as

- **Demo:** run the guard test; build a preview profile and open Start Work: the stepper is present.
- **Acceptance:** REQ-06 — guard test passes with the flag in `base`, fails for any other `EXPO_PUBLIC_ENABLE_*` key.
- **Reviewer can verify without:** any other unit.

### Risk

- **Weakest source:** `[UNVERIFIED]` (DN-1 D8, a `reference` note).
- **Migration reversible:** N/A — no migration. Reversible by removing the line; already-installed builds keep the flag.
- **Behind a flag:** this unit is the flag.
- **Touches existing data:** no.
- **Blast radius:** every crew member on the next build sees two controls that production hid since TCG-8.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `StartWorkBody.tsx`, `segment-time-adjust*`, `eas-build-env.guard.test.ts` | `EXPO_PUBLIC_ENABLE_SEGMENT_TIME_ADJUST` (spec §11a row 10; `git grep -ln 'EXPO_PUBLIC_ENABLE_SEGMENT_TIME_ADJUST' -- .`) | the guard test's negative case for other keys | `spec.md` REQ-06 |

### Deliberately not in this unit

- Nothing deferred.

---

## U2 — Seat and `stepFlow` follow the DAS slot (API)

- **Outcome:** crew grouping seats a worker by their DAS slot, and `GET /field/tickets` returns `stepFlow` for the caller's own slot.
- **Kind:** vertical (shared resolver + API; the resolver's callers are U2, U3, U4, H1, H4 so it is not a standalone foundation)
- **Requirements covered:** REQ-01 (resolver, `FieldTicket.stepFlow`), REQ-05 (crew grouping part only).
- **Depends on:** —
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-u2-slot-step-flow` from `origin/main`.
- **Size estimate:** ~260 source lines, 9 source files (resolver ~50, `ticket-step-flow.ts` ~70, select fragment ~15, mapper ~10, `toPlanAllocation` ~40, shared `FieldTicket` field + barrels ~20, repository select ~30).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A — none | |
| API | `usecase/job-tickets/ticket-step-flow.ts` (new): finds the caller's slot, and an Operator folded onto the Oiler's ticket through the anchor's set and shift. Select fragment reads `subJob.resourceAllocations` (EMPLOYEE only). `field-ticket.mapper.ts` returns `stepFlow`. In `toPlanAllocation` the seat comes from the slot type first. | Structural: new exported function, §11b D6 |
| Web | N/A — none | |
| Mobile | N/A — none (mobile reads the field in U4) | |
| Shared | `resolveTicketStepFlow({ slotTypeName, setSlotTypeNames, employeeTypeName })` in `packages/shared/src/constants/`; `FieldTicket.stepFlow?: 'FULL' \| 'STANDARD'` optional | no slot present falls back to the employee-type rule (plan detail, not DN-1) |
| Tests | resolver matrix (Oiler slot filled by a Rigger; Operator with an Oiler in the set; Operator, no Oiler; any other slot; no slot); mapper returns `stepFlow`; crew-grouping seat test for an Oiler-type employee in a non-Oiler slot | |

### Reviewable as

- **Demo:** `GET /field/tickets` as a Rigger placed in an Oiler slot returns `stepFlow: "FULL"`; as an Oiler placed in a non-Oiler slot returns `"STANDARD"`.
- **Acceptance:** REQ-01 acceptance (four slot cases + fallback).
- **Reviewer can verify without:** U3, U4, a mobile build.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** reads allocations; crew grouping **re-plans PENDING and SENT tickets** (Q8 resolved: safe, they hold no steps or time entries).
- **Blast radius:** a slot/type mismatch re-seats a worker on the roster. Plan risk: before deploy, count active allocations whose employee type differs from their slot type; the PR description carries that count.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Crew grouping / roster (`toPlanAllocation`, `employeeTypeName` readers; `git grep -ln 'employeeTypeName' -- apps/api/src`) | seat derivation | **none — unbuilt:** test for a worker whose type equals their slot type keeps the same seat | DN-1 D5; `spec.md` REQ-05 |
| `FieldTicket` shape: 56 files across shared / mobile / web (`git grep -ln 'FieldTicket\b' -- packages/shared apps/mobile apps/web/src`) | additive optional `stepFlow` | typecheck of `@tcg/mobile` and `@tcg/web` after `@tcg/shared` rebuild; `tcg-contract-tracer` run recorded in the PR | DN-1 D4; spec §11a row 9 |
| `apps/mobile` + `apps/web` | built `dist/` of `@tcg/shared` | `pnpm nx run @tcg/shared:build` then `pnpm typecheck` | additive; no consumer breaks |

### Deliberately not in this unit

- Submit guard, labor writes, job-progress by slot — **U3**.
- Mobile reading `stepFlow` — **U4**.
- Operator on an Oiler's ticket beyond "found through the anchor's set and shift" for the resolver input — who completes their labor is **Q1 / REQ-30**.
- Two Operator slots and no Oiler — both stay FULL as today (**Q4 / REQ-33**), no code.

---

## U3 — API siblings of the slot rule

- **Outcome:** a 3rd man's Left Job closes their on-site time; labor writes and web job-progress follow the slot.
- **Kind:** vertical
- **Requirements covered:** REQ-02 (API: STANDARD `leftJob` closes `WORK_AT_JOB_SITE_TIME`), REQ-04 (submit evidence carries `stepFlow`; the guard stays off), REQ-05 (submit guard, labor writes, job-progress).
- **Depends on:** U2
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-u3-slot-siblings` stacked on U2's branch while U2's PR is open.
- **Size estimate:** ~230 source lines, 8 source files (`submit-step-guard.ts` ~30, `ticket-labor-entries.repository.ts` + `.service.ts` ~60, `derive-ticket-progress-view.ts` ~40, `recordTicketStep` `leftJob` branch ~30, repository selects ~40, barrels ~10).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A — none | |
| API | `submit-step-guard.ts` evidence carries `stepFlow` and requires the flow's step keys (still behind `TICKET_SUBMIT_STEP_GUARD`, default false); labor writes (`ticket-labor-entries.*`) pick by slot type; `derive-ticket-progress-view.ts` takes order from the slot flow; for STANDARD, `recordTicketStep(leftJob)` sets `WORK_AT_JOB_SITE_TIME.endedAt` | `demo-flows.service.ts:871` is **not** changed (plan "Not changed") |
| Web | N/A — web job-progress is fed by the API derive file above; floating rule lands in U5 | |
| Mobile | N/A — none | |
| Shared | N/A — consumes U2's resolver | |
| Tests | STANDARD `leftJob` closes the interval; submit-evidence for FULL and STANDARD (guard flag on in test, 8 vs 14 keys); labor write for Rigger in an Oiler slot; job-progress ordering for a STANDARD ticket | |

### Reviewable as

- **Demo:** call `leftJob` on a STANDARD ticket and read `WORK_AT_JOB_SITE_TIME.endedAt`; open web job-progress for a job with a Rigger in an Oiler slot and see 14 steps.
- **Acceptance:** REQ-02 (`leftJob` sets `endedAt`), REQ-05 (no listed API surface reads `EmployeeType.name` to pick a flow).
- **Reviewer can verify without:** U4, mobile.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** the evidence change is behind `TICKET_SUBMIT_STEP_GUARD` (existing, default false). The `leftJob` and labor changes are not.
- **Touches existing data:** writes `WORK_AT_JOB_SITE_TIME.endedAt` on STANDARD tickets at Left Job. Payroll for STANDARD meals uses the engine's fallback schedule (`meal-periods.ts:23-34`, not opened here): check `contexts/payroll-engine.md` provenance rule before merging.
- **Blast radius:** every 3rd man and Rigger loses lunch / WTL capture in the API's expectations. Q5 resolved: ships without payroll sign-off.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `submit-step-guard.ts` (`git grep -ln 'TICKET_SUBMIT_STEP_GUARD' -- .`) | evidence shape | guard-off submit unchanged: test that a submit with missing steps still succeeds when the flag is false | DN-1 D7; spec §11a row 7 |
| `ticket-labor-entries.repository.ts` / `.service.ts` (`git grep -ln 'EmployeeType.name\|employeeTypeName' -- apps packages`) | employee type to slot type | existing-type-equals-slot-type labor write unchanged | DN-1 D5; spec §11a row 3 |
| Web job-progress (`derive-ticket-progress-view.ts`, `features/ticket-progress/components/ticket-banners.tsx`) | step order | **none — unbuilt:** progress for a non-STANDARD ticket unchanged | DN-1 D5, D9; spec §11a row 6 |
| Payroll meal periods for STANDARD (`meal-periods.ts`) | no lunch capture | **none — unbuilt:** test that a STANDARD ticket with no lunch row computes meals from the fallback | DN-1 D10; Q5 resolved |
| `demo-flows.service.ts:871`, `LaborBody.tsx:175` pay adder | employee type | not touched (plan "Not changed") | PLAN "Not changed" |

### Deliberately not in this unit

- Mobile still picks steps by employee type until **U4**. **Window between U3 deploy and U4 build:** for a worker whose employee type differs from their slot type, the API treats them as one flow and the old mobile shows the other. Nothing breaks while the guard is off; the effect is labor/progress reading the slot flow while the phone shows the type flow.
- Operator labor on an Oiler's ticket — **Q1**.

---

## U4 — Mobile follows `stepFlow`

- **Outcome:** a Rigger in an Oiler slot gets the 14-step flow and an Oiler in a non-Oiler slot gets 8; checklists load for the flow shown.
- **Kind:** vertical
- **Requirements covered:** REQ-01 (mobile), REQ-02 (8-step list, no Start Work), REQ-05 (checklist fetch, prefetch, verify).
- **Depends on:** U3
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-u4-mobile-step-flow` stacked on U3.
- **Size estimate:** ~300 source lines, 10 source files (`ticket.contract.ts`, `ticket-flow.store.ts`, `ticket-step-screen.tsx`, `compose-ticket-detail.ts`, `ticket-total.ts`, checklist fetch / prefetch / verify, `app/(field)/ticket/index.tsx`, `StepBodyShell.tsx`, barrel).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A — none | |
| API | N/A — none | |
| Web | N/A — none | |
| Mobile | contract gains optional `stepFlow`; `getVisibleSteps(flow)` replaces `visibleFlowStepKeys(employeeTypeName)` at call sites (the old function stays as a wrapper until U5); checklist fetch, prefetch and verify use the flow; `TICKET_TOTAL` fix; draft rebuild keeps `active` keyed by step when the flow flips mid-ticket | `contexts/mobile.md`: `StyleSheet.create`, tokens only |
| Shared | N/A — consumes U2 | |
| Tests | store / step-list tests per flow; `TICKET_TOTAL` value for STANDARD = 8; draft with a recorded Start Work then flow flips to STANDARD | |

### Reviewable as

- **Demo:** sign in as a seeded Rigger placed in an Oiler slot: overview shows the full list; as an Oiler in a STANDARD slot: 8 steps, no Start Work.
- **Acceptance:** REQ-01 and REQ-02 acceptance on the device.
- **Reviewer can verify without:** U5, H1.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no. Flow can flip mid-ticket; the draft rebuilds from step summaries.
- **Blast radius:** every STANDARD ticket on the new build loses Start Work, build-up, lunches and WTL capture.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `ticket-flow.store.ts`, `ticket-step-screen.tsx`, `compose-ticket-detail.ts`, `sync/drain.ts`, `ticket-total.ts`, `app/(field)/ticket/index.tsx`, `StepBodyShell.tsx` (`git grep -ln 'visibleFlowStepKeys\|TICKET_FLOW_STEP_KEYS\|TICKET_TOTAL' -- apps packages`) | step list | **none — unbuilt:** one test per file that changes: Oiler-type in Oiler slot still gets 14; `drain` ranks steps for both flows | DN-1 D4, D5; spec §11a row 1 |
| Old mobile builds | contract is additive | n/a — old builds keep the type rule and still show Start Work (harmless, plan) | DN-1 S5; spec §11a row 5 |

### Deliberately not in this unit

- Floating steps, Review missing list — **U5**.
- Holdover lists — **H1 / M1**.

---

## U5 — Floating steps and the Submit block

- **Outcome:** a worker can reach Left Yard without finishing Pre-Trip, and Review lists the missing Pre-Trip, Post-Trip or JSA and blocks Submit.
- **Kind:** vertical
- **Requirements covered:** REQ-03 (mobile and web progress), REQ-04 (mobile, online and offline), REQ-05 (web progress by slot rule, D9).
- **Depends on:** U4
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-u5-floating-steps` stacked on U4.
- **Size estimate:** ~380 source lines, 12 source files — **at the edge**. If the executor measures over 400, split along the surface: U5a mobile frontier (`step-status.ts` `advanceFrontier`, store `nextActive`, `UNLOCKABLE_KEYS`, `resume-step`), U5b Review list + Submit disable + web progress. Stop and say so; do not ask for `size-exception` first.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A — none | |
| API | `derive-ticket-progress-view.ts` never infers a floating step as done | the file is API-side, consumed by web |
| Web | `features/ticket-progress/components/ticket-banners.tsx` shows floating steps as not done until recorded | reuse existing banner; no new component |
| Mobile | `FLOATING_FLOW_STEP_KEYS = pretrip, jsa, posttrip` used by `step-status.ts` `advanceFrontier`; store `nextActive`; `UNLOCKABLE_KEYS` includes them; `resume-step` treats them as out-of-order; Review shows `review-missing-steps` and disables Submit online and offline; `visibleFlowStepKeys(employeeTypeName)` wrapper removed | new `data-testid`: `review-missing-steps` (`grep -rn` in `qa-automation/e2e` shows none today per plan; plan says no field-ticket specs exist — unverified) |
| Shared | `FLOATING_FLOW_STEP_KEYS` constant | `sig1`, `sig2`, `compliance` stay sequential |
| Tests | frontier passes floating steps; Review disabled with a missing floating step, enabled after; offline submit blocked; progress never shows a floating step done | |

### Reviewable as

- **Demo:** start a ticket, skip Pre-Trip, complete Left Yard; Review shows "Pre-Trip" missing and Submit disabled.
- **Acceptance:** REQ-03 acceptance; REQ-04 mobile line.
- **Reviewer can verify without:** U6, H-series.

### Risk

- **Weakest source:** `[UNVERIFIED]`; REQ-03 is `[CONFLICT]` (stub `field-ops/field-ops-mobile-INDEX.md` unadjudicated; DN-1 directs the deviation and verifies nothing).
- **Migration reversible:** N/A.
- **Behind a flag:** no for mobile; the API guard is U6.
- **Touches existing data:** no.
- **Blast radius:** a ticket with floating steps skipped can no longer be submitted from the new build.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `step-status.ts`, store `nextActive`, `resume-step`, `UNLOCKABLE_KEYS` | frontier rule (spec §11a row 2) | **none — unbuilt:** sequential steps (`sig1`, `sig2`, `compliance`) still block the next step | DN-1 D6 |
| Mobile Review / Submit (`isReadOnlyTicket`, `computeOverviewSteps`; `git grep -ln 'isReadOnlyTicket\|computeOverviewSteps' -- apps/mobile`) | submit disable | **none — unbuilt:** a fully complete ticket still submits | DN-1 D7; spec §11a row 8 |
| Web job-progress banners | floating rule | **none — unbuilt:** a non-floating step still derives as done | DN-1 D9 |

### Deliberately not in this unit

- API refusal of an incomplete submit — **U6**.
- Inspection rules inside / after the window — **LT4 / LT17**.

---

## U6 — API submit guard switched on

- **Outcome:** an API submit with required steps missing returns 400 `TICKET_STEPS_MISSING`.
- **Kind:** vertical (config; the guard code ships in U3 and H4)
- **Requirements covered:** REQ-04 (API), fully.
- **Depends on:** U3, U5, H4, M6 merged, **and** the new mobile build installed on crews' phones.
- **Branch / PR base:** `chore/TICKET-FLOW-SLOTS-HOLDOVER-u6-submit-guard-on` from `origin/main` when the gate above is met.
- **Size estimate:** ~1 source line, 1 file.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A — none | |
| API | `deploy/task-definitions/api.json` `environment` (lines 24–27) gains `{ "name": "TICKET_SUBMIT_STEP_GUARD", "value": "true" }` | I opened the file: lines 24–27 are the `environment` array and the flag is not there today. The task definition family is `tcg-api` with `NODE_ENV: staging`. **Which environments this file reaches is not established**; the executor states it in the PR |
| Web / Mobile / Shared | N/A — none | |
| Tests | e2e or manual: submit missing a required step returns 400 `TICKET_STEPS_MISSING` | the flag is read in `apps/api/src/config/env.validation.ts` (default false) |

### Reviewable as

- **Demo:** submit a ticket with Pre-Trip missing against the deployed API: 400.
- **Acceptance:** REQ-04 acceptance.
- **Reviewer can verify without:** other units; the merge gate is a human check.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A. Reversible by removing the line.
- **Behind a flag:** this unit is the flag.
- **Touches existing data:** no.
- **Blast radius:** any build older than U5 / M6 cannot submit a ticket with a floating step skipped. **Merge only on the explicit go-ahead of a developer who has confirmed build adoption.**

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Every submit path from old mobile builds | `TICKET_SUBMIT_STEP_GUARD` | manual script in the PR: old-build submit with all steps recorded still succeeds | DN-1 D7, S5; spec §11a row 7 |

### Deliberately not in this unit

- Nothing deferred.

---

## H1 — Shared holdover types and step lists

- **Outcome:** none a person sees; web, mobile and API import one set of holdover step lists and types.
- **Kind:** foundation (shared types, `packages/shared`). Consumers: **H2** (repository / `FieldTicket.holdover`), **H4** (guard lists), **H6** (web order), **M1** (mobile lists), M2–M6 (types). Five or more, so the exception holds.
- **Requirements covered:** REQ-08 (the arrays and `flowStepKeys`, `requiredFlowStepKeys`), REQ-09 (`TICKET_DAY_STARTS`, `holdoverNeedsDayStart()`), REQ-10 (`PREVIOUS_DAY_CRANE_STATES`).
- **Depends on:** U5
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-h1-shared-holdover` stacked on U5.
- **Size estimate:** ~220 source lines, 4 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API | N/A | |
| Web | N/A | |
| Mobile | N/A — `resolve-step-kind` moved to M1 (C3) | |
| Shared | `ticket-holdover.ts` (`TICKET_DAY_STARTS`, `PREVIOUS_DAY_CRANE_STATES`, `TicketHoldoverContext { dayNumber, isLastDay, dayStartFrom }`, `FieldTicketHoldover`, `holdoverNeedsDayStart()`); `ticket-flow-steps.ts` (`ALL_TICKET_FLOW_STEP_KEYS` 15 keys with `endWork` after `startWork`; explicit arrays for middle and last day, each from Yard and Home, FULL and STANDARD; `flowStepKeys(flow, holdover?)`; `requiredFlowStepKeys`) | Day 1 always uses the Yard list; Day 2+ with no choice uses the Yard list |
| Tests | counts: FULL 14 non-holdover, 13 / 11 middle (Yard / Home), 15 / 13 last day; STANDARD 8, 7 / 5, 8 / 6; `endWork` after `startWork`; Day 1 = Yard list | |

### Reviewable as

- **Demo:** the shared unit tests; a one-line script printing each variant's array.
- **Acceptance:** REQ-08 counts. **Last-day order is described, not listed, in DN-1** (`spec.md` REQ-08 note): the executor writes it from the sentence and the counts; if they disagree, stop and ask.
- **Reviewer can verify without:** any other unit.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** a wrong last-day list breaks the submit guard (H4) and mobile lists (M1) together. Exported shapes are additive.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Everything importing `TICKET_FLOW_STEP_KEYS` / `visibleFlowStepKeys` (`git grep -ln 'visibleFlowStepKeys\|TICKET_FLOW_STEP_KEYS\|TICKET_TOTAL' -- apps packages`) | the non-holdover list stays 14 for FULL / 8 for STANDARD | tests asserting non-holdover output is byte-identical to before | DN-1 D4; spec §11a row 1 |
| `apps/mobile`, `apps/web` | built `dist/` | `@tcg/shared:build`, then `pnpm typecheck` | additive |

### Deliberately not in this unit

- Anything that reads these lists — H2, H4, H6, M1.

---

## H2 — Holdover context on the ticket

- **Outcome:** `GET /field/tickets` returns `holdover` with day number, total days, last-day flag, day start and previous-day crane state.
- **Kind:** vertical (schema + API). Not a foundation: it has a readable result.
- **Requirements covered:** REQ-07 (API: trigger, day index, one ticket per day), REQ-10 (derivation), REQ-09 (columns only; the endpoint is H3).
- **Depends on:** H1
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-h2-holdover-context` stacked on H1.
- **Size estimate:** ~340 source lines, 10 source files — **near the edge**. Parts: repository ~120 (`findHeldJobIds`, `findOpenDays`, `findPreviousDayTickets`, `findTicketAnchor`), `holdover-days.util.ts` ~25, pure `matchPreviousTicket` + `derivePreviousDayCrane` ~60, `TicketHoldoverService` ~70, mapper ~25, schema ~12, module + barrels ~20. `hasRecordedStep` and `setDayStart` belong to H3.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `enum TicketDayStart { YARD HOME }`; `JobTicket.dayStartFrom TicketDayStart?`, `dayStartAt DateTime? @db.Timestamptz`; `CHECK` both null or both set. Migration `add_ticket_day_start` | `jobticket` is already tenant-scoped (plan). **Needs §11b D1.** Droppable columns, so reversible |
| API | `service/job-holdover/ticket-holdover.repository.ts`; `holdover-days.util.ts` (`dayIndexOf`; a missing day counts as the last day); `usecase/job-tickets/ticket-holdover.ts` (pure); `TicketHoldoverService.resolveForRows/resolveForTicket`; `FieldTicket.holdover` in `listMine` and `getMine` | **Needs §11b D3 and D6.** Trigger reads `JobResource.isHoldover` / `JobResourceAllocation.isHoldover`, unchanged. Previous ticket matched on `jobResourceId` and shift first, then set |
| Web / Mobile | N/A — none | |
| Shared | consumes H1 | |
| Tests | `derivePreviousDayCrane`: no ticket, break-down, End Work only, Day 1; `matchPreviousTicket`; day index with a missing day; held employee, no held crane still returns holdover; Day N opened before Day N−1 syncs gives UNKNOWN | |

### Reviewable as

- **Demo:** seed a 3-day holdover job; `GET /field/tickets` for Day 2 returns `holdover.dayNumber: 2`, `totalDays: 3`, `previousDayCrane`.
- **Acceptance:** REQ-07 (one held employee, no held crane gives the full flow), REQ-10 cases.
- **Reviewer can verify without:** H3, mobile.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** yes — additive nullable columns and one enum; dropping loses any day start written afterwards (none exists before H3).
- **Behind a flag:** no (REQ-17: no kill switch).
- **Touches existing data:** no backfill; existing tickets read NULL day start.
- **Blast radius:** a wrong day index mislabels every holdover ticket. The tenant filter on `findOpenDays` must be explicit: run `tcg-prisma-guardian`.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Readers of `isHoldover`: das-allocations, das-loadout, `job-holdover.repository.ts`, `payroll-flag-context.selects.ts`, web DAS allocation UI (`git grep -ln 'isHoldover' -- apps packages`) | read-only; unchanged | **none — unbuilt:** existing `job-holdover` payload test unchanged (executor runs that suite) | DN-1 H1; spec §11a row 11 |
| `listMine` / `getMine` response (56 `FieldTicket` files) | optional `holdover` field | mapper test: tickets on non-holdover jobs return `holdover` undefined | DN-1 H2; spec §11a row 9 |
| `isFutureFieldTicket` date-order guard | unchanged | none needed — not touched; the executor greps to confirm the file is not in the diff | DN-1 H2 |

### Deliberately not in this unit

- `PATCH day-start` — **H3**.
- Mobile rendering — **M1**.

---

## H3 — Day-start endpoint

- **Outcome:** a primary employee's Yard / Home choice for Day 2+ is stored, repeatable, and locked once a step exists.
- **Kind:** vertical (API)
- **Requirements covered:** REQ-09 (endpoint and rules).
- **Depends on:** H2
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-h3-day-start-endpoint` stacked on H2.
- **Size estimate:** ~150 source lines, 5 source files (DTO, controller route, usecase method, `hasRecordedStep` / `setDayStart` in the repository, barrels).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A — columns from H2 | |
| API | `PATCH /field/tickets/:id/day-start` body `{ from: 'YARD'\|'HOME', at }`; rules: primary only (write access), non-terminal, holdover Day 2+, same value idempotent, changed after any step recorded gives 409 `DAY_START_LOCKED`; 400 otherwise | **Needs §11b D2 (shape) and the new endpoint.** Route `:id` follows the existing controller |
| Web / Mobile / Shared | N/A | |
| Tests | PATCH matrix: 400 (Day 1, non-holdover, terminal ticket, non-primary), idempotent re-send, 409 after a step, two devices with different values give 409 | |

### Reviewable as

- **Demo:** `curl` the PATCH on a Day 2 ticket, repeat it, then record a step and change the value: 409.
- **Acceptance:** REQ-09 PATCH matrix.
- **Reviewer can verify without:** M2.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** writes the H2 columns.
- **Blast radius:** a wrong 409 rule locks a worker out of choosing; Q5 resolved: Home-start paid time runs Arrive Job Site to Left Job Site.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| none — new surface only | `git grep -ln 'day-start\|dayStart' -- apps packages` returned nothing when the spec was written; the executor re-runs it | — | `spec.md` REQ-09 |

### Deliberately not in this unit

- Mobile card, sheet and offline op — **M2**.
- Pay-rule provenance entry for Home — **M2** (where the Home flow first exists); H3 stores only.

---

## H4 — Holdover time edges and guard

- **Outcome:** End Work on a holdover ticket closes the open boom; a break-down no longer closes on-site time on holdover tickets; the guard knows holdover lists.
- **Kind:** vertical (API)
- **Requirements covered:** REQ-11 (API), REQ-14 (API), REQ-04 (holdover-aware guard), REQ-17.
- **Depends on:** H3
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-h4-holdover-time-edges` stacked on H3.
- **Size estimate:** ~180 source lines, 5 source files (`recordTicketStep` ~60, `ticket-breakdowns.service.ts` ~25, boom `recordStart` ~25, `submit-step-guard.ts` ~50, constants ~10).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API | `recordTicketStep(endWork)` on a holdover ticket with no break-down closes the open `BOOM_TIME` at End Work (bump 1 second if start ≥ end); `mirrorBreakdownEndOntoWorkAtJobSite` skipped on holdover (`ticket-breakdowns.service.ts` ~221, 248, 282 per plan, unverified); boom `recordStart` idempotent on same `startedAt`; `submit-step-guard.ts` requires `requiredFlowStepKeys(flow, holdover)`, `endWork` maps to `WORK_AT_JOB_SITE_TIME.endedAt`, missing `dayStart` counts as a missing step; `WORK_TIME` is **not** stopped at End Work | the mirror-skip and idempotence rules come from the plan only, in neither decision note (`spec.md` REQ-14) |
| Web / Mobile / Shared | N/A | |
| Tests | boom closes at End Work; 1-second bump; mirror skipped on holdover but still runs on non-holdover; duplicate boom start no-ops; guard with holdover lists (flag on in test) | |

### Reviewable as

- **Demo:** record Start Build Up (boom open), then End Work on a holdover ticket: boom `endedAt` equals End Work time; `WORK_TIME` still open.
- **Acceptance:** REQ-14 acceptance; REQ-11 API line.
- **Reviewer can verify without:** M3.

### Risk

- **Weakest source:** `[UNVERIFIED]`; part of REQ-14 is plan-only.
- **Migration reversible:** N/A.
- **Behind a flag:** guard behind `TICKET_SUBMIT_STEP_GUARD`; time edges are not.
- **Touches existing data:** writes time entries on holdover tickets only.
- **Blast radius:** wrong skip on non-holdover tickets would stop break-down ending on-site time for every ordinary job.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `ticket-breakdowns.service.ts` `mirrorBreakdownEndOntoWorkAtJobSite` (`git grep -ln 'mirrorBreakdownEndOntoWorkAtJobSite\|closeBillableWindow' -- apps`) | holdover guard | **none — unbuilt:** non-holdover break-down still mirrors | DN-1 H3; plan; spec §11a row 14 |
| `recordTicketStep` for non-holdover `endWork`-less tickets | new branch | **none — unbuilt:** non-holdover submit unchanged | spec §11a row 14 |
| `RETURNED_CORRECTION_STEPS` (`ticket-step.constants.ts:93`) | `endWork` not included | test documents crew cannot correct End Work on a returned ticket | plan risk only; spec §11a row 12 — **source is the plan, not a decision note** |
| Boom `recordStart` callers | idempotence | **none — unbuilt:** a differing `startedAt` still creates a new session | plan |

### Deliberately not in this unit

- Mobile End Work UI — **M3 / M4**.
- Mobile `closeBillableWindow` guards — **M6**.

---

## H5 — Middle-day payroll flag exemption

- **Outcome:** a holdover middle day with an open `YARD_TIME` raises no invalid-times, crew-yard-mismatch or Samsara flag.
- **Kind:** vertical (API)
- **Requirements covered:** REQ-15, fully (Q5, Q8 resolved: three flags only, other readers untouched).
- **Depends on:** H2
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-h5-middle-day-flags` stacked on H2.
- **Size estimate:** ~90 source lines, 4 source files (`payroll-flag-invalid-times.ts` ~566, `crew-yard-mismatch` ~171, `samsara-mismatch` ~49, `FlagDetectionJobDay.holdoverMidDay` + select).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API | `FlagDetectionJobDay.holdoverMidDay`; the three flags skip an open `YARD_TIME` when set (crew-yard-mismatch compares the start only) | line numbers are the plan's, unverified |
| Web / Mobile / Shared | N/A | |
| Tests | each flag does not fire on a middle day; still fires on a last day and on a non-holdover job; **reader audit:** the executor walks the other `YARD_TIME` readers (`git grep -ln "YARD_TIME" -- apps/api/src \| grep -v spec`, 20 files) and records in the PR that none false-positives (Q8) | any false positive found becomes a finding, not a fix in this PR |

### Reviewable as

- **Demo:** run flag detection over a seeded 3-day job; middle day clean.
- **Acceptance:** REQ-15 acceptance with Q8 as resolved.
- **Reviewer can verify without:** H3, mobile.

### Risk

- **Weakest source:** `[UNVERIFIED]`; pay-adjacent. Verified note `2026-09-03-paid-time-boundaries-yard-to-yard` is not overridden (DN-1; payroll `gaps.md:5767` stays partly open).
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** missing a real yard-time error on a middle day.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| The three flag detectors on non-holdover and last-day jobs | `holdoverMidDay` | **none — unbuilt:** each flag still fires on an open `YARD_TIME` outside middle days | DN-1 S3; Q8 resolved |
| 17 other `YARD_TIME` readers (send-backs, entry-fix plan, `member-time-entries.ts`, `ticket-time-entries.repository.ts`, `correction-rules.ts`, `payroll-ticket-complete.ts`, `complete-ticket.dto.ts`, …) | untouched | the reader audit above | Q8 resolved: left untouched |
| `payroll-flag-context.selects.ts` | `isHoldover` select | select test | spec §11a row 11 |

### Deliberately not in this unit

- Any change to the other 17 readers — Q8 resolved: none.

---

## H6 — Web progress, per-day holdover steps

- **Outcome:** web job-progress shows each holdover ticket's own step set for a multi-day job.
- **Kind:** vertical (API derive + web)
- **Requirements covered:** REQ-16, fully.
- **Depends on:** H2
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-h6-web-holdover-progress` stacked on H2.
- **Size estimate:** ~140 source lines, 4 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API | `derive-ticket-progress-view.ts` takes order from `flowStepKeys(flow, holdover)` | `holdover` comes from H2 |
| Web | `features/ticket-progress/` renders per-day step sets; no new shared component | run `find-component` only if a new one is proposed |
| Mobile / Shared | N/A | |
| Tests | 3-day job shows three different step sets; floating steps still never inferred done | |

### Reviewable as

- **Demo:** open web job-progress on the seeded 3-day job.
- **Acceptance:** REQ-16.
- **Reviewer can verify without:** M-series.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** progress bars for holdover jobs.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `derive-ticket-progress-view.ts` and its web consumers (`git grep -ln 'derive-ticket-progress' -- apps/web apps/api/src`) | flow arg | **none — unbuilt:** non-holdover job renders as in U5 | DN-1 S4, D9; spec §11a row 6 |

### Deliberately not in this unit

- Nothing deferred. `tcg-contract-tracer` runs if the progress response shape changes.

---

## M1 — Mobile holdover badge and step lists

- **Outcome:** a worker sees "Holdover · Day d of D" and the crane line on the ticket, and the step list for that day.
- **Kind:** vertical (mobile)
- **Requirements covered:** REQ-07 (mobile badge, crane line), REQ-08 (mobile lists), REQ-11 (`endWork` kind, fixtures, drain ranking), REQ-17.
- **Depends on:** H1 (branch). Real data needs **H2 deployed**; until then the unit is demonstrable on fixtures.
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-m1-mobile-holdover-lists` stacked on H1.
- **Size estimate:** ~300 source lines, 12 source files (contract ~30, `getVisibleSteps(flow, holdover)` ~40, fixtures restored from `30f0e4b0f^` with an `endWork` entry ~50, `resolve-step-kind.ts` ~5, `sync/drain.ts` ranking and timer kind ~50, `ticket-details.tsx:84-90` ~40, `ticket-card.tsx:163` ~30, "Start Work" title ~10, barrels).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema / API / Web | N/A | |
| Mobile | contract adds optional `holdover`; `getVisibleSteps(flow, holdover)`; `resolve-step-kind.ts` `endWork: 'timer'`; `drain.ts` ranks by `ALL_TICKET_FLOW_STEP_KEYS` and handles the timer kind for derived ops; `ticket-details.tsx` shows "Holdover · Day d of D" and the crane-state line; `ticket-card.tsx` shows the badge; startWork title "Start Work" on holdover | `data-testid`: `ticket-card-holdover-badge`. Tokens, `StyleSheet.create` |
| Shared | N/A — consumes H1 | |
| Tests | list per variant matches H1 counts; badge shows on holdover only; `drain` ranks `endWork` after `startWork` | |

### Reviewable as

- **Demo:** open a Day 2 holdover ticket on the fixture build: badge, crane line, 13-step list.
- **Acceptance:** REQ-07 (badge), REQ-08 (lists).
- **Reviewer can verify without:** M2.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no (S5).
- **Touches existing data:** no.
- **Blast radius:** wrong lists on the new build. Old builds on holdover jobs cannot submit once U6 is on (accepted, DN-1 S5).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `sync/drain.ts` ranking and timer kind | `ALL_TICKET_FLOW_STEP_KEYS` | **none — unbuilt:** a queue of non-holdover ops drains in the same order as before | spec §11a row 24 (drain), DN-1 |
| `ticket-details.tsx`, `ticket-card.tsx`, `ticket.contract.ts` | additive fields | snapshot / render test for a non-holdover ticket | DN-1 H2 |
| Existing mobile fixtures | `endWork` entry added | fixture-consuming tests still pass | plan |

### Deliberately not in this unit

- Day-start UI — **M2**; End Work screen — **M3**.

---

## M2 — Day-start card, sheet and offline op

- **Outcome:** on Day 2+ a worker answers "Where are you starting from?" before any step; the answer works offline.
- **Kind:** vertical (mobile)
- **Requirements covered:** REQ-09 (mobile).
- **Depends on:** M1 (branch). **H3 must be merged and deployed first** (runtime).
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-m2-day-start-card` stacked on M1.
- **Size estimate:** ~330 source lines, 9 source files (`use-day-start.ts` ~60, `holdover-day-start-card.tsx` ~90 + BottomSheet ~60, `dayStart` op in the outbox ranked before `shiftStart` ~50, step-row lock ~40, 409 adopt-server-value ~30).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema / API / Web / Shared | N/A | |
| Mobile | `use-day-start.ts`; `components/field/holdover-day-start-card.tsx` in the overview top panel (`index.tsx:701-715`) opening a BottomSheet with Yard and Home; new `dayStart` outbox op ranked before `shiftStart`; step rows locked until a choice exists; a 409 adopts the server's value; Home removes Left Yard and Driving, Arrive Job first, then Pre-Trip; On Home days the Arrive Job minimum time is the shift start | `data-testid`: `holdover-day-start-card`. Check for a reusable BottomSheet via `find-component` |
| Tests | card shows Day 2+ only; steps locked until chosen; offline queue then drain; 409 adopts server value; Home list has 11 (FULL middle) steps | |

### Reviewable as

- **Demo:** Day 2 ticket: card appears, steps greyed; choose Home; list drops Left Yard and Driving.
- **Acceptance:** REQ-09 acceptance (steps stay locked until a choice; 409 adopt).
- **Reviewer can verify without:** M3.

### Risk

- **Weakest source:** `[UNVERIFIED]`; Q5 resolved. **Pay rule:** `WORK_TIME` on Home-start days starts at `arriveJob`. If the executor changes any `packages/payroll-engine` file, the same commit adds the provenance entry (`contexts/payroll-engine.md`).
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** writes day start through H3.
- **Blast radius:** a worker stuck at the lock if the card fails to render; Day N before Day N−1 syncs reads crane UNKNOWN (intended).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Outbox ranking (`sync/drain.ts`) | new op rank | **none — unbuilt:** existing ops keep their order with `dayStart` queued first | plan |
| `app/(field)/ticket/index.tsx` overview top panel | card insertion | non-holdover ticket overview renders the same | DN-1 H7 |
| Pay start on Home days | day start | the provenance check above | Q5 resolved (Haris, 2026-10-16) |

### Deliberately not in this unit

- Start Work modes — **M5**.

---

## M3 — End Work step

- **Outcome:** a worker records End Work on a FULL holdover ticket and sees the live clock confirmation.
- **Kind:** vertical (mobile)
- **Requirements covered:** REQ-11 (record step, step-time bounds).
- **Depends on:** M2 (branch). **H4 deployed first** (boom close).
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-m3-end-work-step` stacked on M2.
- **Size estimate:** ~300 source lines, 6 source files. Basis: `EndWorkBody.tsx` is 436 lines at `30f0e4b0f^` (`git show 30f0e4b0f^:apps/mobile/features/field-ticket/steps/EndWorkBody.tsx`); minus the summary card (lines 71–177, about 107) is about 330, less trimming, plus registration ~30. **Over 400 if the card does not separate; see C2.**

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema / API / Web / Shared | N/A | |
| Mobile | restore `EndWorkBody.tsx` (clock phase) under `features/field-ticket/steps/`; register it as the `endWork` step body; End Work no earlier than the later of break-down end and boom start | the old file ports `steps2.jsx StepEndWork`; read it against current code, it may not compile as-is |
| Tests | restored `EndWorkBody.test.tsx` (170 lines, excluded from count) adapted; bound test | |

### Reviewable as

- **Demo:** holdover ticket, Start Work done: End Work shows the clock; tapping records `WORK_AT_JOB_SITE_TIME.endedAt`.
- **Acceptance:** REQ-11: boom closes at End Work, `WORK_TIME` stays open.
- **Reviewer can verify without:** M4.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** records time entries.
- **Blast radius:** a bad bound blocks End Work; the step sits before Final Signature, so it blocks submit.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Step registry / `StepBodyShell.tsx` | new body registered | **none — unbuilt:** a non-holdover ticket never shows End Work | DN-1 H3 |
| `RETURNED_CORRECTION_STEPS` | `endWork` not in it | none new; documented in H4 | plan risk only |

### Deliberately not in this unit

- The summary card — **M4**; boom start on a held day — **M5**.

---

## M4 — End Work summary

- **Outcome:** after End Work the worker sees the day's work time, boom total with sessions, lunch/pause and non-boom time.
- **Kind:** vertical (mobile)
- **Requirements covered:** REQ-11 (summary).
- **Depends on:** M3
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-m4-end-work-summary` stacked on M3.
- **Size estimate:** ~250 source lines, 5 source files: `end-work-summary.ts` 87 + `EndWorkSummaryCard` ~107 + the new work-time row ~30 + wiring.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema / API / Web / Shared | N/A | |
| Mobile | restore `end-work-summary.ts` and `EndWorkSummaryCard` / `SegmentSummaryLines`; **add a work-time row starting at `arriveJob`** (the old card deliberately had none) | the old comment says a header timer already shows work time; the new row is the plan's change (PLAN M3), restated here as the plan's, not a decision note |
| Tests | summary values for: one boom session, none, lunch inside window | |

### Reviewable as

- **Demo:** End Work recorded: summary lists each row.
- **Acceptance:** REQ-11 summary lines.
- **Reviewer can verify without:** M5.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** display only.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| none — new surface only | `git grep -ln 'end-work-summary\|EndWorkSummary' -- apps` to be re-run; the files were deleted in `30f0e4b0f` | — | DN-1 H3 |

### Deliberately not in this unit

- Nothing deferred.

---

## M5 — Start Work modes on holdover tickets

- **Outcome:** on a held day the Start Work card starts the boom; an unknown crane state offers Start Build Up or Skip Build Up.
- **Kind:** vertical (mobile)
- **Requirements covered:** REQ-12, fully; REQ-14 (boom-start client use).
- **Depends on:** M4. **H4 deployed** (idempotent boom start).
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-m5-start-work-modes` stacked on M4.
- **Size estimate:** ~280 source lines, 5 source files (`holdover-start-mode.ts` ~30, `holdover-start-card.tsx` ~120, `StartWorkBody.tsx` edits ~100, barrels). `StartWorkBody.tsx` is large; confirm edit size.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema / API / Web / Shared | N/A | |
| Mobile | pure `holdover-start-mode.ts` (LEFT_SET_UP gives START_WORK, UNKNOWN gives CHOOSE, else BUILD_UP); `holdover-start-card.tsx` (Start Work tap posts a boom-session start; CHOOSE shows Start Build Up / Skip Build Up); build-up only Day 1 or after a break-down day | `data-testid`: `holdover-start-card` |
| Tests | mode per crane state; card taps; build-up absent on a LEFT_SET_UP day | |

### Reviewable as

- **Demo:** Day 2 after Day 1 left the crane set up: Start Work card, one tap opens a boom session.
- **Acceptance:** REQ-12 (each crane state shows its mode).
- **Reviewer can verify without:** M6.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** writes boom sessions.
- **Blast radius:** crane time on holdover days.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `StartWorkBody.tsx` build-up card on non-holdover tickets | mode switch | **none — unbuilt:** non-holdover Start Work renders the build-up card as before | DN-1 H4; spec §11a row 14 |

### Deliberately not in this unit

- Break-down and `closeBillableWindow` guards — **M6**.

---

## M6 — End-of-day crane sheet

- **Outcome:** End Work opens "Leave crane set up / Start Breakdown" on every day but the last; the last day requires break-down; holdover tickets never close the billable window.
- **Kind:** vertical (mobile)
- **Requirements covered:** REQ-13, fully; REQ-14 (`closeBillableWindow` guarded).
- **Depends on:** M5. H4 deployed.
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-m6-end-of-day-sheet` stacked on M5.
- **Size estimate:** ~250 source lines, 6 source files (`end-work-holdover-sheet.tsx` ~100, `StartWorkBody.tsx` five guarded callers ~50, `buildStartWorkOps` ~30, last-day requirement ~40, barrels).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema / API / Web / Shared | N/A | |
| Mobile | `end-work-holdover-sheet.tsx`; days 1..N−1 only; last day: no prompt, break-down required before submit; guard all five `closeBillableWindow` callers (`StartWorkBody.tsx` ~1054, 1070, 1256, 1369, 1395 per plan); `buildStartWorkOps` drops its break-down fallback | `data-testid`: `end-work-holdover-sheet` |
| Tests | sheet shown on Day 1 and 2 of 3 only; last day requires break-down; no `closeBillableWindow` on any holdover path; non-holdover callers still call it | |

### Reviewable as

- **Demo:** 3-day job: Day 1 End Work shows the sheet; Day 3 does not, and Submit is blocked until break-down is recorded.
- **Acceptance:** REQ-13 acceptance.
- **Reviewer can verify without:** U6.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** time entries.
- **Blast radius:** a missed caller closes the billable window on a holdover day. All five are named; the executor re-greps (`git grep -n closeBillableWindow -- apps/mobile`).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `StartWorkBody.tsx` (5 `closeBillableWindow` sites) and `buildStartWorkOps` on non-holdover tickets | holdover guard | **none — unbuilt:** one test per caller showing non-holdover behaviour unchanged | DN-1 H3, H5; spec §11a row 14 |

### Deliberately not in this unit

- The U6 flag — **U6**.

---

## LT1 — Shared window helper

- **Outcome:** none a person sees; one tested helper decides "scheduled end", "window", "approval open" and "late".
- **Kind:** foundation (shared types). Consumers: **LT4, LT5, LT10, LT11, LT12, LT15**. Six, so the exception holds.
- **Requirements covered:** REQ-18 (helper part).
- **Depends on:** —
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt1-window-helper` from `origin/main`.
- **Size estimate:** ~150 source lines, 3 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema / API / Web / Mobile | N/A | |
| Shared | `utils/ticket-completion-window.ts`: constants 24h / 4h / reminders [12, 20]; request kinds `LATE_COMPLETION`, `SUBMITTED_EDIT` (Q7); statuses PENDING / APPROVED / DENIED / EXPIRED; codes `TICKET_WINDOW_CLOSED`, `TICKET_PAYROLL_LOCKED`; `ticketScheduledEnd(interval, shift, tz = BUSINESS_TIMEZONE)` (shift-2 fields for shift 2; `UNSCHEDULED` if absent, defensive); `ticketCompletionWindow`, `approvalWindowEndsAt`, `isApprovalOpen`, `isLateCompletion` | mobile never converts zones itself; SCRUM-TZ swaps `tz` later |
| Tests | window open / closed / approved; shift 2; DST; `UNSCHEDULED` | |

### Reviewable as

- **Demo:** helper unit tests.
- **Acceptance:** REQ-18 helper tests.
- **Reviewer can verify without:** any other unit.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** every later LT unit reads this helper.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| none — new surface only | `git grep -ln 'TICKET_WINDOW_CLOSED\|ticketScheduledEnd\|ticketCompletionWindow' -- apps packages` returned nothing (run 2026-10-16) | — | DN-2 L2 |

### Deliberately not in this unit

- Using the helper anywhere — LT4 onward.

---

## LT2 — Edit-request model, `completedAt`, audit actions

- **Outcome:** none a person sees; the tables and enum members the later units write to exist.
- **Kind:** foundation (schema). Consumers: **LT4** (reads requests), **LT5** (`completedAt`, `TICKET_LATE_COMPLETED`), **LT6**, **LT8**, **LT9**, **LT10**, **LT11**. Seven, so the exception holds.
- **Requirements covered:** REQ-18 (`completedAt` column, **not** the backfill — Q9), REQ-21 (model), REQ-24 (six members, per C4).
- **Depends on:** LT1
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt2-edit-request-schema` stacked on LT1.
- **Size estimate:** ~80 source lines, 4 source files (`schema.prisma` ~50, `TENANT_SCOPED_MODELS` 1, `activity-log.helpers.ts` / `activity-logs.service.ts` label maps ~25). The migration is excluded from the count.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | model `TicketEditRequest` (kind, status, reason, requestedBy, decidedBy, decidedAt, windowEndsAt, submittedAt; UUID PK, no business code per Q7); enums; partial unique index: one open request per ticket; `JobTicket.completedAt DateTime? @db.Timestamptz`; six `ActivityLogAction` members; migration. **No backfill (Q9).** | **Needs §11b D4, D5-as-answered-by-Q7, D8 filled by a developer.** FK to `JobTicket` by UUID; requester / decider relation targets `NOT SPECIFIED` in spec §3 — the executor proposes, the developer decides. `reason` length `NOT SPECIFIED` |
| API | add `ticketeditrequest` to `TENANT_SCOPED_MODELS`; `ActivityLogAction` label maps handle the six members | run `tcg-prisma-guardian`; the cron (LT8) runs outside request context where scoping is skipped |
| Web / Mobile | N/A | |
| Shared | N/A — enums come from LT1 constants | |
| Tests | Prisma test: second open request for one ticket fails; both label maps return a label for each new member | |

### Reviewable as

- **Demo:** `pnpm db:migrate` applies; the partial-unique violation test.
- **Acceptance:** REQ-21 index; REQ-24 members exist.
- **Reviewer can verify without:** any other unit.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** **no, for the six enum members** (Postgres cannot drop enum values); yes for the table and column. **`[UNVERIFIED]` + not reversible: raise before building.** Q10 may add a seventh member; settle Q10 first, or accept a second migration.
- **Behind a flag:** no.
- **Touches existing data:** no backfill in this unit (Q9).
- **Blast radius:** a wrong index or tenant allowlist leaks requests across tenants.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `activity-log.helpers.ts`, `activity-logs.service.ts`, `projects.service.ts`, `quotation-signature-activity-log.util.ts` (`git grep -ln 'ActivityLogAction' -- apps/api/src`, run 2026-10-16: 4 non-spec files) | new enum members | **none — unbuilt:** label / switch test over every `ActivityLogAction` member; existing members unchanged | DN-2 L10; spec §11a row 21 |
| `TicketEditRequest` model | n/a | none — new surface only (`git grep -ln 'TicketEditRequest' -- apps packages` empty, 2026-10-16) | DN-2 L11 |

### Deliberately not in this unit

- `completedAt` backfill — **blocked on Q9**. Until answered, legacy rows read NULL.
- Anything that writes these tables — LT4 onward.

---

## LT3 — Payroll Manager gains `payroll-admin:edit`

- **Outcome:** a Payroll Manager can open every `payroll-admin` edit route.
- **Kind:** vertical (API seed + data migration)
- **Requirements covered:** REQ-22, fully (Q6 resolved: all 18 routes, intended).
- **Depends on:** —
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt3-pm-payroll-admin-edit` from `origin/main`.
- **Size estimate:** ~60 source lines, 3 source files (seed ~20, role mapping ~20, barrel); the SQL data migration is excluded.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | data migration only (SQL: insert the role-permission row for each existing tenant's Payroll Manager role) | not a schema change |
| API | seed grants `payroll-admin: edit` to Payroll Manager | re-seeding rewrites role permissions, so the seed itself must grant it (plan risk) |
| Web / Mobile / Shared | N/A | |
| Tests | seed produces the permission; migration is idempotent; a Payroll Manager token passes one `payroll-admin` edit route; a Payroll Admin token is unchanged | |

### Reviewable as

- **Demo:** log in as Payroll Manager; call a send-back close route: 200.
- **Acceptance:** REQ-22 grant.
- **Reviewer can verify without:** LT6.

### Risk

- **Weakest source:** `[UNVERIFIED]`; reverses E2 of `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` (I did not read E2) and sits against the 2026-10-13 PM/PA split note. Q6 resolved by Haris.
- **Migration reversible:** yes — delete the inserted rows (they are distinguishable by name only if the migration records them; the migration should log the ids it inserts).
- **Behind a flag:** no.
- **Touches existing data:** yes — inserts one row per tenant.
- **Blast radius:** Payroll Manager can approve, export, close send-backs and edit flags (18 routes).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| 18 `@RequirePermission('payroll-admin', …)` routes (`git grep -n "RequirePermission('payroll-admin'" -- apps/api/src`, 18 hits 2026-10-16: payroll ×8 edit, send-backs ×4, flags ×4, corrections ×1, time overrides ×1) | role permission | **none — unbuilt:** guard test for two routes: Payroll Manager allowed, a role without the permission still 403 | Q6 resolved (Haris, 2026-10-16) |

### Deliberately not in this unit

- A narrower permission — rejected by Q6.

---

## LT4 — Window guard and capture-time rule

- **Outcome:** a write to a ticket after its window closes returns 409 `TICKET_WINDOW_CLOSED`; comments still work; a queued offline op captured in time is still accepted within 72h.
- **Kind:** vertical (API)
- **Requirements covered:** REQ-19 (window 409, comments exempt, reject refused after window), REQ-27 (API: inspections), REQ-28 (server acceptance rule, **not** the audit row — Q10).
- **Depends on:** LT2
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt4-window-guard` stacked on LT2. **Do not merge before LT6 (Q11).**
- **Size estimate:** ~300 source lines, 8 source files (`ticket-write-window.util.ts` ~120, `getTicketForEmployeeAction` hook ~40, `X-Captured-At` parse ~40, checklist / attachment callers ~40, error mapping ~30, barrels).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API | `usecase/job-tickets/ticket-write-window.util.ts` `resolveTicketWriteGrant` with modes OPEN, LATE_WINDOW, APPROVED_EDIT, RETURNED_CORRECTION, COMPLETE_LOCKED; wired in `getTicketForEmployeeAction(…,'write')` (~:1372); access modes `submit`, `request`, `comment`; 409 `TICKET_WINDOW_CLOSED` (never 403); a returned correction is checked before the window; capture time from `X-Captured-At`: accept when captured before the window ended and received within 72h, otherwise judge by server clock | **Needs §11b D6** (new util vs extending `returned-ticket-correction.ts`). COMPLETE_LOCKED mode ships in LT5 |
| Web / Mobile / Shared | N/A — consumes LT1 | |
| Tests | write at scheduled end + 25h with no approval: 409; comment succeeds; reject after window refused; inspection write inside window ok, after window 409; capture inside window and arrival at +30h accepted; arrival after 72h: 409; returned-correction ticket unaffected | |

### Reviewable as

- **Demo:** `PATCH` a step on a seeded ticket past its window: 409 with the code.
- **Acceptance:** REQ-19 first and second acceptance clauses; REQ-28 PLAN scenario 13 (without the audit row).
- **Reviewer can verify without:** LT6 (an approved row can be seeded by hand).

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no. **On merge every ticket past its window is locked with no request path (Q11).**
- **Touches existing data:** no.
- **Blast radius:** every write path through `getTicketForEmployeeAction`. Old builds get 409s after the window; the step is marked failed and its local data is kept (plan).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `getTicketForEmployeeAction` callers: `job-tickets.service.ts`, `field-tickets.service.ts`, `checklist-assignments.service.ts`, `job-progress.service.ts`, `returned-ticket-correction.ts` (`git grep -ln 'RETURNED_CORRECTION_STEPS\|getTicketForEmployeeAction' -- apps/api/src`) | the write check | **none — unbuilt:** one test per caller: in-window write unchanged; past-window write 409 | DN-2 L13; spec §11a row 16 |
| Returned-correction / send-back path | order of checks | returned correction on a past-window ticket still succeeds | PLAN risk only; spec §11a row 18 — **source is the plan** |
| Mobile outbox (old builds) | 409 | n/a — covered in LT17 for the new build | DN-2 L13 |

### Deliberately not in this unit

- Audit row for an accepted late-captured op — **Q10**.
- The COMPLETE lock and submit stamping — **LT5**.
- Payroll week lock (`TICKET_PAYROLL_LOCKED`) and who-may-act beyond worker / payroll admin — **LT6**.
- An Operator folded onto an Oiler's ticket — **Q1**.
- Sending `X-Captured-At` from the app — **LT17**.

---

## LT5 — Submit semantics

- **Outcome:** submitting stamps `completedAt`, locks the ticket at once, logs a late completion; resubmitting after an approved edit re-queues payroll.
- **Kind:** vertical (API)
- **Requirements covered:** REQ-18 (stamp: client time capped at the server's clock), REQ-20 (API), REQ-24 (`TICKET_LATE_COMPLETED`).
- **Depends on:** LT4, **rebased after U5** (both touch the submit path).
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt5-submit-semantics` stacked on LT4; rebase onto `main` once U5 merges.
- **Size estimate:** ~220 source lines, 5 source files (`completeTicketIfOpen` ~:675 ~80, COMPLETE_LOCKED mode ~40, resubmit requeue ~50, activity log call ~20, barrels).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A — column from LT2 | |
| API | `completeTicketIfOpen` stamps `completedAt`; a completion after the scheduled end writes `TICKET_LATE_COMPLETED`; status stays COMPLETE and a locked ticket refuses writes (COMPLETE_LOCKED) — checklist and attachment ops replayed after submit now fail with 409; a resubmit under an approved `SUBMITTED_EDIT` re-queues payroll | the repo's **current** post-submit editability is not established in the spec (REQ-20 note): the executor states it in the PR before changing it |
| Web / Mobile / Shared | N/A | |
| Tests | submit then edit: 409; late completion row; resubmit re-queues payroll; replayed checklist op after submit: 409 (**test drain order**) | |

### Reviewable as

- **Demo:** submit a ticket, then PATCH a step: 409; the `ActivityLog` row for a late submit.
- **Acceptance:** REQ-20 (scenario up to "locked"); REQ-18 late flag.
- **Reviewer can verify without:** LT6 (resubmit path needs an approved request; seed it).

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** new submits only.
- **Blast radius:** tighter lock on every submitted ticket; notification volume: every completion after the scheduled end counts as late (plan).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `completeTicketIfOpen` and payroll queueing (`payroll-ticket-complete.ts`, `complete-ticket.dto.ts`) | completion | **none — unbuilt:** first submit still queues payroll exactly once | DN-2 L4 |
| Checklist / attachment ops from the drain after submit | COMPLETE_LOCKED | drain-order test above | plan; spec REQ-19 note |
| Payroll corrections (`PayrollCorrection`) writing to COMPLETE tickets | write grant | **none — unbuilt:** returned correction on a COMPLETE ticket still works | spec §11a row 18 |

### Deliberately not in this unit

- The request flow itself — **LT6**.
- Mobile edit UI — **LT17**.

---

## LT6 — Request lifecycle and the payroll lock

- **Outcome:** a worker raises one request with one reason; a `payroll-admin:edit` holder approves or denies it; a ticket in an APPROVED or EXPORTED week is never updated.
- **Kind:** vertical (API)
- **Requirements covered:** REQ-21 (API), REQ-19 (payroll lock, actors, send-back coexistence), REQ-24 (requested / approved / denied rows, lazy expiry row).
- **Depends on:** LT5
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt6-edit-request-lifecycle` stacked on LT5.
- **Size estimate:** ~380 source lines, 12 source files — **at the edge**. If it measures over 400, split into LT6a (worker `POST /field/tickets/:id/edit-requests` + states) and LT6b (payroll approve / deny + `findTicketPayrollLock`); stop and say so.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A — tables from LT2 | |
| API | `POST /field/tickets/:id/edit-requests` (worker, one reason); `GET /payroll/ticket-edit-requests`; `POST /payroll/ticket-edit-requests/:id/approve` and `/deny`; approval is a conditional update then `findTicketPayrollLock`; approval opens 4h from the approver's click; expired requests flip lazily; a new request is refused while a send-back is open; payroll's own write paths refused for a locked week with 409 `TICKET_PAYROLL_LOCKED`; `ActivityLog` rows for requested, approved, denied, expired | **Needs §11b D4, D6** and the new endpoints (spec §4 table: use-case, repository and presentation names are `NOT SPECIFIED`). `/payroll/*` guarded by `payroll-admin:edit`; `GET` view vs edit `NOT SPECIFIED` — developer decides |
| Web / Mobile / Shared | N/A | |
| Tests | one open request per ticket; approve opens 4h then re-locks; deny; APPROVED / EXPORTED week refuses approval; send-back open refuses a request; non-worker / dispatcher cannot act (L7); lazy expiry | |

### Reviewable as

- **Demo:** curl the request, then approve as Payroll Admin, then write inside the 4h window.
- **Acceptance:** REQ-21 and REQ-19 third acceptance clause.
- **Reviewer can verify without:** any UI.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** writes requests; locks reads of APPROVED / EXPORTED weeks.
- **Blast radius:** payroll's own corrections can now return 409 `TICKET_PAYROLL_LOCKED`.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `payroll-approval-gate.ts` / week status readers | lock reader | **none — unbuilt:** a DRAFT-week ticket stays writable | DN-2 L8; spec §11a row 17 |
| Returned correction / send-back path | order | returned correction still wins | spec §11a row 18 (plan) |
| `@RequirePermission('payroll-admin', 'edit')` routes | new routes use it | covered by LT3's guard test | Q6 |

### Deliberately not in this unit

- Notifications — **LT7**; expiry cron — **LT8**; the edit audit interceptor — **LT9**.
- Employee who left — **Q2**; folded Operator — **Q1**.

---

## LT7 — Request notifications

- **Outcome:** payroll admins get in-app and push notice of a new request, in-app notice of a late completion or approved edit; the worker gets a push on approval or denial.
- **Kind:** vertical (API)
- **Requirements covered:** REQ-23 (notices).
- **Depends on:** LT6
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt7-request-notices` stacked on LT6.
- **Size estimate:** ~200 source lines, 6 source files (catalog entries ~40, `templates/ticket-edit-request-notices.ts` ~80, call sites in LT5 / LT6 paths ~50).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API | catalog entries + `ticket-edit-request-notices.ts`; call sites at request create, approve, deny, late completion; a `TICKET_EDIT_REQUEST` navigation target in the payload | call sites `NOT SPECIFIED` in spec §6; the executor lists them in the PR |
| Web / Mobile / Shared | N/A | |
| Tests | each event sends the right channels to the right audience; no push to payroll for late completion | |

### Reviewable as

- **Demo:** raise and approve a request; see the in-app items and the push log.
- **Acceptance:** REQ-23 first clause.
- **Reviewer can verify without:** LT8.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** notification volume.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Notification catalog and templates (additive) | new entries | existing catalog snapshot test unchanged | DN-2 L14; spec §11a row 20 |

### Deliberately not in this unit

- The web link target handling — **LT14**; mobile tap to open — **LT17**. **Window:** until LT14, a payroll admin's in-app notice for a request has a navigation target the web does not yet handle.

---

## LT8 — Expiry and reminder cron

- **Outcome:** an approved request ends after 4h without a click; a worker with an incomplete ticket is pushed at scheduled end +12h and +20h.
- **Kind:** vertical (API)
- **Requirements covered:** REQ-23 (reminders), REQ-21 (expiry), REQ-24 (`TICKET_EDIT_EXPIRED` row).
- **Depends on:** LT7
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt8-ticket-window-cron` stacked on LT7.
- **Size estimate:** ~200 source lines, 5 source files (`CRON_JOBS.ticketWindow` every 15 min ~40, expiry ~50, reminders ~70, `NotificationReminderLog` use ~20, module).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A — `NotificationReminderLog` exists | |
| API | cron in the notification scheduler area; expires approved requests past `windowEndsAt`; sends reminders deduped by `NotificationReminderLog`; stops once the ticket is complete | **Needs §11b D6** (new cron vs extending `notification-scheduled-jobs.service.ts`). **Runs outside request context: tenant scoping is skipped, the cron must scope by tenant explicitly** (`prisma.md` case 1); run `tcg-prisma-guardian` |
| Web / Mobile / Shared | N/A | |
| Tests | reminder at +12h and +20h once each; none after completion; expiry flips status and writes the row; per-tenant scoping | |

### Reviewable as

- **Demo:** run the cron against seeded tickets at fake times.
- **Acceptance:** REQ-23 reminders; REQ-21 expiry by cron.
- **Reviewer can verify without:** mobile.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** writes reminder-log rows and flips request status.
- **Blast radius:** push volume to workers; a missing tenant filter would act across tenants.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Notification scheduler and `NotificationReminderLog` (`git grep -ln 'NotificationReminderLog\|CRON_JOBS' -- apps/api/src`) | registration | **none — unbuilt:** existing reminders still dedupe | DN-2 L6; spec §11a row 20 |

### Deliberately not in this unit

- Nothing deferred.

---

## LT9 — Edits-under-approval audit

- **Outcome:** each field changed on a ticket under an approved request leaves a row with field, from, to, actor and time.
- **Kind:** vertical (API)
- **Requirements covered:** REQ-24 (`TICKET_EDITED_UNDER_APPROVAL`).
- **Depends on:** LT6
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt9-edit-audit` stacked on LT6.
- **Size estimate:** ~160 source lines, 4 source files (snapshot-diff interceptor ~100, registration ~20, barrels).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A — members are in LT2 (C4) | |
| API | snapshot-diff interceptor on `FieldTicketsController`; writes one `ActivityLog` row per changed field for writes made under APPROVED_EDIT | **Needs §11b D6** |
| Web / Mobile / Shared | N/A | |
| Tests | an edit under approval writes a diff row per changed field; an edit inside the window writes none | |

### Reviewable as

- **Demo:** approve a request, change two fields, read the log.
- **Acceptance:** REQ-24 last clause.
- **Reviewer can verify without:** any UI.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** adds log rows.
- **Blast radius:** an interceptor on the controller sees every field-ticket request; must be a no-op outside approval.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `FieldTicketsController` routes | interceptor | **none — unbuilt:** an ordinary in-window write passes through unchanged with no log row | DN-2 L10 |

### Deliberately not in this unit

- Audit row for an accepted late-captured op — **Q10**.

---

## LT10 — Field list: `incomplete` bucket and window fields

- **Outcome:** `GET /field/tickets` returns an `incomplete` bucket and each ticket's window, request and server time.
- **Kind:** vertical (API)
- **Requirements covered:** REQ-26 (API), REQ-18 (read), REQ-21 (read).
- **Depends on:** LT6, **after H3** (both change `field-ticket.mapper.ts` and `listMine`).
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt10-field-list-buckets` stacked on LT6; rebase after H3 merges.
- **Size estimate:** ~250 source lines, 7 source files (`listMine` buckets ~80, `expiredWhere` redefinition ~40, mapper fields ~40, shared `FieldTicket` fields ~20, selects ~40, barrels).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API | new `incomplete` bucket: scheduled end within the last 14 days, payroll-locked hidden; `expiredWhere` now means "window closed, never started"; `FieldTicket` gains `completionWindow`, `editRequest`, `serverNow` | changed response shape: run `tcg-contract-tracer` (four passes), only `@tcg/shared` importers are compile-checked |
| Web / Mobile | N/A — Home reads it in LT15 | |
| Shared | optional `FieldTicket` fields | additive |
| Tests | a ticket 2h past scheduled end appears in `incomplete`; one past 14 days does not; a payroll-locked ticket is hidden; `expiredWhere` result differs from before only as stated | |

### Reviewable as

- **Demo:** `GET /field/tickets` for a seeded worker with a late-started ticket.
- **Acceptance:** REQ-26 acceptance (API half).
- **Reviewer can verify without:** LT15.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** redefining `expiredWhere` changes what existing mobile builds see in their lists.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Mobile Home buckets: `active-tickets-section.tsx`, `jobs.tsx`, `use-tickets.ts`, `tickets.mock.ts`, `ticket.contract.ts` (`git grep -ln 'isFutureFieldTicket\|isPastFieldTicket' -- apps`) | `expiredWhere`, new bucket | **none — unbuilt:** buckets for upcoming / active tickets unchanged; old builds ignore an unknown `incomplete` key | DN-2 L15; spec §11a row 23 |
| `FieldTicket` consumers (56 files) | optional fields | typecheck after shared rebuild + `tcg-contract-tracer` recorded | spec §11a row 9 |

### Deliberately not in this unit

- Home UI — **LT15**. Whose list an Operator folded onto an Oiler's ticket sees — **Q1**.

---

## LT11 — Payroll late-tickets list and late flag

- **Outcome:** `GET /payroll/late-tickets` lists tickets by Overdue / Requests / Locked; the payroll job-day payload carries `completedAt` and `completedLate`.
- **Kind:** vertical (API)
- **Requirements covered:** REQ-25 (API), REQ-18 (late flag where `completedAt` is set).
- **Depends on:** LT6
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt11-late-tickets-api` stacked on LT6.
- **Size estimate:** ~220 source lines, 6 source files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema | N/A | |
| API | `GET /payroll/late-tickets`, guarded `payroll-admin`; `completedAt` and `completedLate` on the payroll job-day payload | **Needs the new endpoint decision** (spec §4). `completedLate` is computed only when `completedAt` is non-null; **the NULL case is Q9** — the executor does not pick a value |
| Web / Mobile / Shared | N/A | |
| Tests | each tab's membership; late flag; non-`payroll-admin` is refused | |

### Reviewable as

- **Demo:** curl the list as Payroll Admin.
- **Acceptance:** REQ-25 API half.
- **Reviewer can verify without:** LT13.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** payroll job-day payload gains two fields.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Payroll job-day payload consumers (web payroll week entries) | additive fields | **none — unbuilt:** existing payload test passes with the extra fields | DN-2 L11; spec §11a row 22 (consumers not enumerated — executor greps) |

### Deliberately not in this unit

- NULL `completedAt` reading — **Q9**.

---

## LT12 — Payroll overlay on business-time scheduled end

- **Outcome:** the payroll week overlay decides "scheduled end" in business time, not UTC.
- **Kind:** vertical (API)
- **Requirements covered:** REQ-29, fully.
- **Depends on:** LT1
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt12-overlay-business-time` stacked on LT1.
- **Size estimate:** ~50 source lines, 2 source files (`payroll-week-overlay.ts` ~:131).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema / Web / Mobile / Shared | N/A | |
| API | `payroll-week-overlay.ts` calls the shared `ticketScheduledEnd` | |
| Tests | overlay result equals the helper for the same interval; a ticket ending near the UTC / business-time date boundary resolves to the business-time date | |

### Reviewable as

- **Demo:** run the overlay over a ticket near midnight.
- **Acceptance:** REQ-29: overlay matches the helper.
- **Reviewer can verify without:** other LT units.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** reads only; results for boundary-time tickets can change.
- **Blast radius:** payroll week assignment of tickets ending near midnight.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `payroll.service.ts`, `payroll.repository.ts`, `apps/web/.../payroll-week-entries.service.ts` (`git grep -ln 'completeTicketIfOpen\|ticketScheduledEnd\|scheduledEnd' -- apps packages`) | overlay output | **none — unbuilt:** one test per caller with a mid-day ticket: unchanged result | Q8 resolved: only the overlay changes, others untouched |
| `payroll-week-overlay.ts` | direct | the boundary test above | DN-2 L18 |

### Deliberately not in this unit

- Any change to the three other readers — Q8 resolved.

---

## LT13 — Late-tickets page (read-only)

- **Outcome:** a `payroll-admin` holder opens `/payroll/late-tickets` and sees tabs Overdue, Requests and Locked.
- **Kind:** vertical (web)
- **Requirements covered:** REQ-25 (page).
- **Depends on:** LT11
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt13-late-tickets-page` stacked on LT11.
- **Size estimate:** ~330 source lines, 9 source files (feature folder ~200, route ~20, query hooks ~60, barrels).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema / API / Mobile / Shared | N/A | |
| Web | `features/payroll-late-tickets/` modelled on `features/payroll-returned-entries` `returned-entries-list.tsx`; reuse `WorkspaceTable`, `useWorkspaceTableControls`, `SectionTabs`, `StatusBadge`, `PageHero`; route `/payroll/late-tickets`; TanStack Query v5; `theme.css` variables only | **Needs §11b D9.** Run `find-component` across the nine `components/` directories before creating anything. `searchPlaceholder` must list every searchable field and `emptyFilterStateMessage` are `NOT SPECIFIED` in spec §5: the executor proposes, a developer decides. Test IDs `payroll-late-tickets-*`; autofill rules apply to any control (`useBrowserAutofillDomAttrs()`) |
| Tests | route renders each tab; hidden without `payroll-admin`; `browser-autofill-coverage.test.mjs` passes | |

### Reviewable as

- **Demo:** open the page as Payroll Admin on seeded data.
- **Acceptance:** REQ-25: visible only with `payroll-admin`.
- **Reviewer can verify without:** LT14.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** new route only.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| none — new surface only | `git grep -rn 'late-tickets' -- apps/web/src qa-automation/e2e` to be run; plan says no such route exists | — | DN-2 L12 |

### Deliberately not in this unit

- Approve / Deny, sidebar, badge, notification link — **LT14**.

---

## LT14 — Approve / Deny, Late badge, sidebar, notification link

- **Outcome:** a payroll admin approves or denies a request in one tap, sees a Late badge on payroll entries, and a notice opens the page.
- **Kind:** vertical (web)
- **Requirements covered:** REQ-25 (badge), REQ-21 (web actions), REQ-23 (web navigation).
- **Depends on:** LT13. **LT6 and LT7 deployed** (endpoints and notices).
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt14-late-tickets-actions` stacked on LT13.
- **Size estimate:** ~260 source lines, 8 source files (actions ~80, badge ~40, sidebar + summary badge ~50, `notification-navigation` `TICKET_EDIT_REQUEST` target ~30, mutation hooks ~40).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema / API / Mobile / Shared | N/A | |
| Web | Approve and Deny buttons (one tap, no form); Late badge on payroll entries (`payroll-entry-late-badge`) — extend `StatusBadge` if it fits; sidebar entry + summary badge; `notification-navigation` target | before renaming any existing test ID: `grep -rn '<id>' qa-automation/e2e` |
| Tests | Approve / Deny round trip; badge shows when `completedLate`; navigation resolves the target | |

### Reviewable as

- **Demo:** approve a seeded request; click the in-app notice.
- **Acceptance:** REQ-25 Approve / Deny round trip.
- **Reviewer can verify without:** mobile.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** approvals through LT6.
- **Blast radius:** payroll entry rows gain a badge.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `notification-navigation`, sidebar, payroll entry components | additions | **none — unbuilt:** an existing notification type still navigates; existing sidebar items unchanged | DN-2 L12; spec §5 |

### Deliberately not in this unit

- Nothing deferred.

---

## LT15 — Mobile Home "Incomplete" section

- **Outcome:** a worker sees an "Incomplete" section on Home with a countdown for each ticket still open past its scheduled end.
- **Kind:** vertical (mobile)
- **Requirements covered:** REQ-26 (view: section, card, countdown).
- **Depends on:** LT10
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt15-incomplete-section` stacked on LT10.
- **Size estimate:** ~300 source lines, 9 source files (contract fields ~30, `ticketEditability()` ~60 with `isPastFieldTicket` fallback, `incomplete-tickets-section.tsx` ~90, `incomplete-ticket-card.tsx` ~90 with skew-corrected countdown via `serverNow`, Home wiring ~30).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema / API / Web / Shared | N/A | |
| Mobile | contract fields; `ticketEditability()`; section on Home (`app/(field)/field.tsx`, `active-tickets-section.tsx` area); card shows the countdown; payroll-locked tickets absent | check `find-component`-equivalent in `contexts/mobile.md` before a new card; 48px touch targets |
| Tests | unstarted ticket 2h past scheduled end appears with a countdown; clock skew corrected; locked tickets hidden | |

### Reviewable as

- **Demo:** Home on a seeded worker with a late ticket.
- **Acceptance:** REQ-26 acceptance (PLAN scenario 9).
- **Reviewer can verify without:** LT16.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** Home layout.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Home buckets and `use-tickets.ts` | new bucket | **none — unbuilt:** Home with no incomplete tickets renders as before | DN-2 L15; spec §11a row 23 |
| `isPastFieldTicket` | fallback in `ticketEditability()` | helper test | plan |

### Deliberately not in this unit

- Request action and states after "countdown" — **LT16**. Operator folded under an Oiler — **Q1**.

---

## LT16 — Request approval from Home

- **Outcome:** after the window a worker taps Request approval with one reason; the card then reads Waiting for approval, then shows the 4h countdown once approved.
- **Kind:** vertical (mobile)
- **Requirements covered:** REQ-21 (mobile), REQ-26 (states).
- **Depends on:** LT15. **LT6 deployed.**
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt16-request-approval` stacked on LT15.
- **Size estimate:** ~300 source lines, 7 source files (request hooks ~80, `edit-request-sheet.tsx` ~120, card state machine ~70, barrels).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema / API / Web / Shared | N/A | |
| Mobile | request hooks; `edit-request-sheet.tsx` (one reason; length rule `NOT SPECIFIED`, so none enforced beyond non-empty is a developer call); card states countdown, Request approval, Waiting, 4h countdown | |
| Tests | each state renders; submit sends the reason; second request while one is open is blocked | |

### Reviewable as

- **Demo:** request from a late ticket; approve on web; the card flips to the 4h countdown.
- **Acceptance:** REQ-26 states; REQ-21 worker half.
- **Reviewer can verify without:** LT17.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** creates requests through LT6.
- **Blast radius:** Home.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| none — new surface only | `git grep -ln 'edit-request' -- apps/mobile` to be run; plan names the files as new | — | DN-2 L3 |

### Deliberately not in this unit

- Editing the ticket once approved — **LT17**.

---

## LT17 — Mobile edit wiring, capture time, 409 handling

- **Outcome:** a worker edits a ticket in-window or under an approved request; offline edits carry capture time; a 409 shows a call to action; a push tap opens the ticket ready to edit.
- **Kind:** vertical (mobile)
- **Requirements covered:** REQ-20 (mobile), REQ-27 (mobile), REQ-28 (mobile), REQ-19 (409 handling), REQ-23 (push tap).
- **Depends on:** LT16, **after U5 and M6** (same screens). **LT4 and LT5 deployed.**
- **Branch / PR base:** `feat/TICKET-FLOW-SLOTS-HOLDOVER-lt17-mobile-edit-wiring` stacked on LT16; rebase onto `main` after U5 and M6.
- **Size estimate:** ~320 source lines, 9 source files (`isReadOnlyTicket` / `computeOverviewSteps` read editability ~80, `StepSyncOp.capturedAt` + `X-Captured-At` in `sync/drain.ts` for every op type ~80, 409 call to action instead of retry ~60, push tap ~40, inspection path ~40). **If over 400, split capture-time (REQ-28) from edit wiring + 409.**

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema / API / Web / Shared | N/A | |
| Mobile | editability drives read-only; every queued op carries `capturedAt` sent as `X-Captured-At`; a 409 stops retrying, marks the step failed, keeps local data and shows a call to action (the outbox swallows 403, hence 409); push tap opens the ticket; inspections go through the request after the window | |
| Tests | capture offline inside the window and sync at +30h accepted; sync after 72h shows the call to action; drain order after submit (checklist replay 409) | |

### Reviewable as

- **Demo:** PLAN scenarios 11 and 13 on the device.
- **Acceptance:** REQ-20, REQ-28 acceptance (without the audit row), REQ-27.
- **Reviewer can verify without:** other units, with LT4 / LT5 deployed.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** op headers only.
- **Blast radius:** every queued op type in the outbox.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `sync/drain.ts` op types | `capturedAt` | **none — unbuilt:** one test that every op type in the ranking carries the header; untagged ops still drain | DN-2 L17; spec §11a row 24 |
| `isReadOnlyTicket`, `computeOverviewSteps` | editability | **none — unbuilt:** a COMPLETE ticket is read-only; an in-window ticket stays editable | spec §11a row 8 |

### Deliberately not in this unit

- Audit row for late-captured acceptance — **Q10**.

---

## Sequencing

```
Part 1:  U1 (independent)
         U2 ──▶ U3 ──▶ U4 ──▶ U5 ──▶ H1 ──▶ H2 ──▶ H3 ──▶ H4
                                        │      ├──▶ H5
                                        │      └──▶ H6
                                        └──▶ M1 ──▶ M2 ──▶ M3 ──▶ M4 ──▶ M5 ──▶ M6 ──▶ U6 (gate)
Part 3:  LT1 ──▶ LT2 ──▶ LT4 ──▶ LT5 ──▶ LT6 ──▶ LT7 ──▶ LT8
              │                            ├──▶ LT9
              │                            ├──▶ LT10 ──▶ LT15 ──▶ LT16 ──▶ LT17
              │                            └──▶ LT11 ──▶ LT13 ──▶ LT14
              └──▶ LT12
         LT3 (independent)
```

- **Parallelisable.**
  - **U1** shares no file with U2: it touches `apps/mobile/eas.json` and the guard test, U2 touches `packages/shared`, `apps/api`.
  - **LT1, LT3** can run beside the U-chain. LT1 adds a new file under `packages/shared/src/utils/` and a barrel line; U2 and H1 add to `packages/shared/src/constants/` and the same `index.ts` barrel. A one-line barrel conflict is possible; it is not a logic conflict. LT3 touches the seed and a data migration only.
  - **H5 and H6** after H2: H5 touches the three payroll-flag files and `FlagDetectionJobDay`; H6 touches `derive-ticket-progress-view.ts` and `features/ticket-progress/`. U5 already changed `derive-ticket-progress-view.ts`, so H6 branches after U5 merges or rebases. H5 and H6 share no file.
  - **M1** can start once H1 merges, beside H2–H4: M1 touches `apps/mobile` only; H2–H4 touch `apps/api`. Shared file: none beyond `packages/shared` consumed read-only.
  - **LT12** after LT1: one API file (`payroll-week-overlay.ts`); no other unit touches it.
  - **LT11 and LT10, LT9** after LT6: LT10 edits `field-ticket.mapper.ts` and `listMine`; LT11 edits payroll files; LT9 edits a new interceptor and the controller decorators. LT9 and LT10 both touch `FieldTicketsController`'s module file: sequence LT9 before LT10 or rebase.
- **Not parallel.**
  - **H2 and LT2 both edit `apps/api/prisma/schema.prisma`** and each adds a migration. Whichever merges second regenerates its migration timestamp on rebase. Migrations land in merge order.
  - **U2 / H2 / LT10** all edit `field-ticket.mapper.ts` and the `FieldTicket` type in `packages/shared`. The U → H → LT order above serialises them; LT10 is rebased after H3.
  - **LT4 / LT5 and U3 / H4** all edit `job-tickets.service.ts` (1,484 lines). LT5 is rebased after U5 (plan); LT4 should be rebased after H4 merges if H4 is still open.
- **Merge order constraints.**
  - Migrations: H2 and LT2 in whichever order they reach `main`; LT3's data migration after the roles exist (any time).
  - **LT4 does not merge before LT6 (Q11, open).** LT4 enforces the window on merge and nothing exists to request approval until LT6 + LT16.
  - **U6 (guard on) only after** U3, U5, H4, M6 are merged, a build containing them is on phones, and a developer says so.
  - **H2, H3, H4 and M1–M6 are deployed together (REQ-17, S5):** no flag exists. Old builds on holdover jobs cannot submit once U6 is on.
- **Cross-surface windows (shared export or response shape consumed by a surface that updates in a later unit).**
  - U2 → U4: `FieldTicket.stepFlow` is additive; old mobile ignores it.
  - U3 → U4: API follows the slot while mobile still follows employee type. Mismatch only for workers whose type differs from their slot type; guard is off, so nothing blocks.
  - H2 → M1: `holdover` is additive; M1 reads it. Until M1 is on phones, holdover tickets look like ordinary ones.
  - H3 → M2, H4 → M3 / M5 / M6: M units call endpoints that must already be deployed. Merge each API unit before its mobile unit.
  - LT7 → LT14: notices carry a `TICKET_EDIT_REQUEST` target the web handles only after LT14.
  - LT10 → LT15, LT6 → LT16, LT4 / LT5 → LT17: same rule, API first.
- **First unit to ship.**
  - **U2.** It tests the riskiest assumption in Part 1: that the DAS slot is readable from allocations the way DN-1 D2 says, and how many active allocations have a type that differs from their slot type. If that count is large, Part 1's re-rostering effect needs a developer before U3. **U1 is independent and can ship any time**; it proves nothing about the plan.
  - **Part 2:** H1 then H2 — H2 proves the previous-day matching works on real data before any mobile unit depends on it.
  - **Part 3:** LT1 + LT2 are foundation; **LT4 is the unit that tests the riskiest assumption** (all write paths go through one check). Do not merge it first (Q11).

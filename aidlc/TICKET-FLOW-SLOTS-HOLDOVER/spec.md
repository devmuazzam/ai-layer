# Spec — TICKET-FLOW-SLOTS-HOLDOVER Slot-driven steps, floating checklists, holdover flow, late and incomplete tickets

> Written by the elaborator from the approved plan and two decision notes. No `intent.md` exists
> (no SCRUM id yet); the plan file stands in for it.
>
> **Source-status note, read first.** Both decision notes are `status: reference` — developer
> direction by Syed Haris, **not ratified by TCG**. The template tags `decision` sources
> `[VERIFIED]`; these two say of themselves that they are not. They are tagged `[UNVERIFIED]`
> here, so every requirement below inherits `[UNVERIFIED]` (or worse). Decisions that *are*
> `status: verified` (2026-09-14, 2026-09-03, 2026-09-30 incomplete-tickets) are tagged so.
> Nothing in this spec is code-sourced: every requirement rests on a decision note.

Short names used below:

- **DN-1** = `decisions/2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md` — `[UNVERIFIED]`, kind: decision (`reference`), 10.3 KB, 2026-10-15. Carries D1–D10, H1–H10, S1–S5.
- **DN-2** = `decisions/2026-10-15-late-and-incomplete-tickets.md` — `[UNVERIFIED]`, kind: decision (`reference`), 8.9 KB, decided 2026-10-16. Carries L2–L18. (L1 is not in the note or the plan.)
- **PLAN** = `/home/codingcops/.claude/plans/right-now-we-display-whimsical-squirrel.md` — `[UNVERIFIED]`, kind: plan (outside the repo and the overlay, 31.3 KB). Carries the design, unit table and verification script. **It lives in a home directory, so it is not durable memory.** Where the PLAN adds detail the notes lack, the requirement says so.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | none yet — working id `TICKET-FLOW-SLOTS-HOLDOVER` (Path A) |
| Intent | none; PLAN (2026-10-15/16) substitutes. `Captured on` n/a. Jira not consulted: no ticket exists |
| Elaborated on | 2026-10-16 |
| Vault state at elaboration | six `domain/` files verified; DN-1 and DN-2 are untracked in the `.ai` overlay (`git -C .ai status`), `field-ops/gaps.md` and `payroll/gaps.md` modified, uncommitted. Entry counts not re-measured |
| Open questions raised by this spec | 8, all in §12 |
| Already-shipped behaviour reached | 14 consumer groups in §11a; 3 with no source for what happens to them (Q6, Q8, Q5) |
| Rules consulted | `.ai/claude/contexts/api.md`, `prisma.md`, `web.md` (headings only), `mobile.md`, `patterns.md`, root `CLAUDE.md`; `field-ops/field-ops-mobile-INDEX.md` (conflict stub) |

**Conflict stub in play:** `field-ops/field-ops-mobile-INDEX.md` — three competing, unverified, mutually disagreeing documents:
`field-ops/frd-new-format-draft/INDEX.md` (FR-TCG-FOP-001 v1.1 REVIEWED, 55.6 KB, 2026-06-09),
`field-ops/field-ops-frd/INDEX.md` (FR-TCG-FOP-002 v2.0 DRAFT, 46.2 KB, 2026-06-16),
`field-ops/atom-mobile-app-user-stories/INDEX.md` (34.5 KB, 2026-08-11). None is verified. This spec records DN-1 as the direction to build; it does not adjudicate the three documents.

**Verified decisions that still govern (cited, not restated):**
`decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` (`verified`),
`decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md` (`verified`),
`decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md` (`verified`).

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Step flow follows the DAS slot (FULL / STANDARD) | shared, api, mobile | `[UNVERIFIED]` | DN-1 D1, D2, D4 | no |
| REQ-02 | STANDARD tickets drop Start Work (8 steps) | shared, api, mobile | `[UNVERIFIED]` | DN-1 D10 | no |
| REQ-03 | Pre-Trip, Post-Trip, JSA float | shared, mobile, web | `[CONFLICT]` | DN-1 D6, H10 | no — direction given; stub stays unadjudicated |
| REQ-04 | Submit blocked until floating steps done (mobile and API) | mobile, api | `[UNVERIFIED]` | DN-1 D7 | no |
| REQ-05 | Sibling surfaces switch to the slot rule | api, web, mobile | `[UNVERIFIED]` | DN-1 D5, D9 | no |
| REQ-06 | Time-adjustment flag back in every EAS build | mobile | `[UNVERIFIED]` | DN-1 D8 | no |
| REQ-07 | Holdover trigger, one ticket per day, badge and Day d of D | shared, api, mobile | `[UNVERIFIED]` | DN-1 H1, H2 | no |
| REQ-08 | Holdover step lists | shared, mobile, api | `[UNVERIFIED]` | DN-1 H8, H9, step-list table | no |
| REQ-09 | Day-start choice (Yard or Home), stored and queued offline | schema, api, mobile, shared | `[UNVERIFIED]` | DN-1 H7, S2 | no |
| REQ-10 | Previous-day crane state, derived | api, shared | `[UNVERIFIED]` | DN-1 S1 | no |
| REQ-11 | End Work step on FULL holdover tickets | mobile, api, shared | `[UNVERIFIED]` | DN-1 H3 | no |
| REQ-12 | Start Work modes on holdover tickets | mobile | `[UNVERIFIED]` | DN-1 H4, H6 | no |
| REQ-13 | End-of-day crane sheet; last-day break-down required | mobile | `[UNVERIFIED]` | DN-1 H5 | no |
| REQ-14 | Time-edge rules on holdover (boom close, break-down mirror, idempotent start) | api, mobile | `[UNVERIFIED]` | DN-1 H3; PLAN design | no |
| REQ-15 | Open-`YARD_TIME` payroll flags skipped on middle days | api | `[UNVERIFIED]` | DN-1 S3 | **partial** — Q5, Q8 |
| REQ-16 | Web progress shows real per-day holdover steps | api, web | `[UNVERIFIED]` | DN-1 S4, D9 | no |
| REQ-17 | No holdover kill switch | api, mobile | `[UNVERIFIED]` | DN-1 S5 | no |
| REQ-18 | Completion window = scheduled end + 24h | shared, api | `[UNVERIFIED]` | DN-2 L2, L11 | no |
| REQ-19 | API enforces the window (409), payroll lock, who may act | api | `[UNVERIFIED]` | DN-2 L7, L8, L13 | no |
| REQ-20 | Submit locks at once; edit after submit by request | api, mobile | `[UNVERIFIED]` | DN-2 L4 | no |
| REQ-21 | Edit-request lifecycle and 4h approval window | schema, api, web, mobile | `[UNVERIFIED]` | DN-2 L3, L11 | no |
| REQ-22 | `payroll-admin:edit` granted to Payroll Manager | api (seed, migration) | `[UNVERIFIED]` | DN-2 L5 | **partial** — Q6 |
| REQ-23 | Reminders and notifications | api, mobile, web | `[UNVERIFIED]` | DN-2 L6, L14 | no |
| REQ-24 | Audit trail on `ActivityLog` | schema, api | `[UNVERIFIED]` | DN-2 L10 | no |
| REQ-25 | Web `/payroll/late-tickets` and Late badge | web, api | `[UNVERIFIED]` | DN-2 L12, L11 | no |
| REQ-26 | Mobile Home "Incomplete" section | mobile | `[UNVERIFIED]` | DN-2 L15 | no |
| REQ-27 | Inspections inside and after the window | mobile, api | `[UNVERIFIED]` | DN-2 L16 | no |
| REQ-28 | Offline `capturedAt` and 72h grace | mobile, api | `[UNVERIFIED]` | DN-2 L17 | no |
| REQ-29 | Payroll week overlay moves to shared scheduled-end helper | api | `[UNVERIFIED]` | DN-2 L18 | no |
| REQ-30 | Oiler fills the shared ticket — does it still govern Operators? | api, mobile | `[OPEN]` | none | **yes**, for who completes an Operator's labor (Q1) |
| REQ-31 | Employee leaves with incomplete tickets | api, web | `[OPEN]` | none | **yes** (Q2) |
| REQ-32 | Previous-ticket enforcement strength | api, mobile | `[OPEN]` | none | **yes** (Q3) |
| REQ-33 | Two Operator slots and no Oiler | api | `[OPEN]` | none | no — behaviour unchanged (Q4) |

Counts: 33 total — 0 verified, 28 unverified, 1 conflicted, 4 open. REQ-15 and REQ-22 are `[UNVERIFIED]` but carry open ripple questions.

**Part map.** Part 1 = REQ-01..06. Part 2 (holdover) = REQ-07..17. Part 3 (late/incomplete) = REQ-18..29. Open = REQ-30..33.

## 2. Requirements

### REQ-01 — Step flow follows the DAS slot `[UNVERIFIED]`

- **Statement:** The ticket step list for a worker is chosen by the DAS slot type that worker occupies on that day, not by the worker's employee type: FULL for an Oiler slot (whoever fills it), FULL for an Operator slot when the set has no Oiler slot, STANDARD for every other slot.
- **Surface:** shared (`resolveTicketStepFlow`), api (`FieldTicket.stepFlow`), mobile
- **Sources:**
  - DN-1 D1, D2, D4 — `[UNVERIFIED]` — kind: decision. "FULL flow for an Oiler slot, whoever fills it… Every other slot gets STANDARD." The Oiler slot is read from that day's employee allocations with the same set, shift and sub-job. `resolveTicketStepFlow()` returns `'FULL' | 'STANDARD'`; `FieldTicket` gains `stepFlow` for the caller's own slot.
  - `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` — `[VERIFIED]` — kind: decision. Clause 3 (Operator fills the ticket when there is no Oiler seat); D1 says it matches this.
- **Conflict:** none for the flow rule. The verified 09-14 rule's clause 2 (Operator has no fill/complete/sign/submit step when an Oiler is on the set) is in tension with a provisional answer — see Q1/REQ-30. This spec does not say who completes an Operator's labor.
- **Open question:** Q1 (Operators on an Oiler's ticket), Q4 (two Operators, no Oiler).
- **Ripple:** the current rule is employee-type-driven (Oiler 14 steps, all others 9 per PLAN). Consumers: §11a rows 1–3. What happens to each: changes deliberately, DN-1 D5. Re-rostering effect (crew grouping re-plans PENDING and SENT tickets) is a PLAN risk with no decision on handling — covered by Q8.
- **Acceptance:** for each of: Oiler slot filled by a Rigger; Operator slot with an Oiler in the set; Operator slot with no Oiler; any other slot — the resolver returns the value above, and `FieldTicket.stepFlow` equals it. No slot present falls back to the employee-type rule (PLAN design). Falling back is plan detail, not in DN-1.
- **Notes for the executor:** PLAN: `usecase/job-tickets/ticket-step-flow.ts` finds the caller's slot; an Operator folded onto the Oiler's ticket is found through the anchor's set and shift. Govern by `.ai/claude/contexts/api.md`, and `packages/shared` is consumed by web and mobile both.

### REQ-02 — STANDARD tickets drop Start Work `[UNVERIFIED]`

- **Statement:** STANDARD tickets have 8 steps (leftYard, driving, arriveJob, sig1, sig2, leftJob, arriveYard, review) with no Start Work, build-up, break-down, lunches or WTL capture; Left Job closes their `WORK_AT_JOB_SITE_TIME`; meal periods use the payroll engine's fallback schedule.
- **Surface:** shared, api, mobile
- **Sources:**
  - DN-1 D10 and the "Step lists" table — `[UNVERIFIED]` — kind: decision. "STANDARD tickets have 8 steps, not 9… Meal periods use the payroll engine's fallback schedule (`meal-periods.ts:23-34`)."
- **Conflict:** the three field-ops documents (stub) describe the step flow differently; none verified. D10 changes the existing standard list from 9 to 8. This spec does not adjudicate them.
- **Open question:** none for the step change. PLAN names a behaviour change for every 3rd man and Rigger (lunch/WTL capture disappears, payroll places meals on its fallback schedule); DN-1 decided it. Whether TCG payroll accepts that is not a question DN-1 raised — see Q5's note.
- **Ripple:** §11a rows 1, 4, 5. Old builds still show Start Work "harmless" (PLAN risk, no source beyond the PLAN).
- **Acceptance:** a STANDARD, non-holdover ticket exposes exactly the 8 steps above; `leftJob` sets `WORK_AT_JOB_SITE_TIME.endedAt` for them; no lunch/WTL prompts.
- **Notes for the executor:** PLAN units U2 (resolver), U3 (`leftJob` closes the interval). `demo-flows.service.ts:871` and the pay adder at `LaborBody.tsx:175` are explicitly **not** changed (PLAN).

### REQ-03 — Pre-Trip, Post-Trip and JSA float `[CONFLICT]`

- **Statement:** `pretrip`, `posttrip` and `jsa` are always tappable and never block the next step; they block only submit. `sig1`, `sig2` and `compliance` are unchanged (sequential). Holdover tickets follow the same rule (H10).
- **Surface:** shared (`FLOATING_FLOW_STEP_KEYS`), mobile, web progress (D9)
- **Sources:**
  - DN-1 D6, H10, D9 — `[UNVERIFIED]` — kind: decision. States the override.
  - `field-ops/field-ops-frd/08-functional-requirements/fr-fop-011-job-safety-analysis-jsa.md` (FR-TCG-FOP-002 FR-FOP-011) — `[UNVERIFIED]` — kind: vault — JSA sequential, per DN-1.
  - `field-ops/field-ops-frd/08-functional-requirements/fr-fop-012-start-work.md` (FR-TCG-FOP-002 FR-FOP-012) — `[UNVERIFIED]` — kind: vault — Start Work gated on prior steps, per DN-1.
  - `field-ops/atom-mobile-app-user-stories/02-ticket-assignment-and-pre-trip.md` (stories 78, 149) — `[UNVERIFIED]` — kind: vault — pre-trip gated, per DN-1. **I read these three only as DN-1 describes them; I did not open them.** The executor should cite the exact lines.
  - FR-TCG-FOP-001 `fr-fop-011` — named in the PLAN as also overridden, not named in DN-1; not opened.
- **Conflict:** stub `field-ops/field-ops-mobile-INDEX.md`; `gaps.md#field-operations-mobile-app`. Candidates: FR-TCG-FOP-001 (55.6 KB, 2026-06-09), FR-TCG-FOP-002 (46.2 KB, 2026-06-16), Atom (34.5 KB, 2026-08-11). **None is verified.** DN-1 directs the build to deviate from the sequential rule in FOP-002 and Atom; it does not verify or supersede any of them (DN-1 "Effect on the vault"). This spec does not choose among the documents.
- **Open question:** none; direction exists.
- **Ripple:** §11a rows 2, 6.
- **Acceptance:** with Pre-Trip not done, the worker can reach and complete Left Yard; Review lists the missing floating steps and disables Submit.
- **Notes for the executor:** PLAN: `advanceFrontier` lets the frontier pass floating steps; `UNLOCKABLE_KEYS` includes them; `resume-step` treats them as out-of-order; derive-ticket-progress never infers a floating step as done. `data-testid` contract: new IDs in PLAN (`review-missing-steps`, …).

### REQ-04 — Submit blocked until floating steps are done `[UNVERIFIED]`

- **Statement:** Submit is blocked on mobile (online and offline) and on the API when any required step, including the floating ones, is missing.
- **Surface:** mobile, api
- **Sources:**
  - DN-1 D7 — `[UNVERIFIED]` — kind: decision. "Blocked on mobile (online and offline) and on the API (`TICKET_SUBMIT_STEP_GUARD=true`)."
  - PLAN — `[UNVERIFIED]` — kind: plan — `400 TICKET_STEPS_MISSING` (verification step 6); the guard consumes `stepFlow` and `holdover`.
- **Conflict:** none
- **Open question:** none
- **Ripple:** §11a rows 7, 8. Switching the env flag on is gated on U3, U5, H4, M6 merged **and** the new mobile build on phones (PLAN).
- **Acceptance:** with the guard on, submit without any required step returns 400 `TICKET_STEPS_MISSING`; mobile Review disables Submit with the missing list.
- **Notes for the executor:** the PLAN cites `deploy/task-definitions/api.json:24-27` for the flag. My grep for `SUBMIT_STEP_GUARD` over `deploy/` and `.github/` returned nothing — verify the path before relying on it. The flag exists in `apps/api/src/config/env.validation.ts:50` (default `false`).

### REQ-05 — Sibling surfaces switch to the slot rule `[UNVERIFIED]`

- **Statement:** Crew grouping, API submit guard and labor writes, web job-progress, and mobile checklist fetch, prefetch and verify all use the slot-based step flow.
- **Surface:** api, web, mobile
- **Sources:** DN-1 D5, D9 — `[UNVERIFIED]` — kind: decision.
- **Conflict:** none
- **Open question:** none for scope. Effects on already-planned tickets: Q8.
- **Ripple:** §11a rows 3, 9.
- **Acceptance:** none of the listed surfaces reads `EmployeeType.name` to pick a flow (PLAN: `git grep` check, see §11c).
- **Notes for the executor:** PLAN risk: before deploy, count active allocations whose employee type differs from their slot type.

### REQ-06 — Time-adjustment flag back in every EAS build `[UNVERIFIED]`

- **Statement:** `EXPO_PUBLIC_ENABLE_SEGMENT_TIME_ADJUST: "true"` is set in `eas.json` `base`, so every profile has it; the env guard test is relaxed for this one flag.
- **Surface:** mobile (build config, test)
- **Sources:** DN-1 D8 — `[UNVERIFIED]` — kind: decision. "Reverses commit `85f293978` (TCG-8)."
- **Conflict:** none. It reverses a merged decision (TCG-8, commit `85f293978`, 2026-10-08) that removed the flag from shipped builds. I did not look for a vault note behind TCG-8.
- **Open question:** none
- **Ripple:** §11a row 10. PLAN: also turns on `WorkTimeStopControl` and the Start Work ± stepper — "intended".
- **Acceptance:** `eas-build-env.guard.test.ts` passes with the flag in `base`, still failing for any other `EXPO_PUBLIC_ENABLE_*` key.
- **Notes for the executor:** the guard test has `FORBIDDEN_KEY_PATTERN = /^EXPO_PUBLIC_ENABLE_/` over profiles `base`, `preview`, `production`. mobile inlines `EXPO_PUBLIC_*` at build time.

### REQ-07 — Holdover trigger, one ticket per day, badge `[UNVERIFIED]`

- **Statement:** A job that holds anything over (crane or employee) gives every ticket on it the holdover flow; there is one ticket per day, opened in date order; ticket details and the ticket card show a Holdover badge and "Day d of D", and details also shows a crane-state line.
- **Surface:** api, mobile, shared
- **Sources:** DN-1 H1, H2 — `[UNVERIFIED]` — kind: decision. Trigger is `JobResource.isHoldover` / `JobResourceAllocation.isHoldover`. An Operator folded onto the Oiler's ticket follows holdover through that ticket. Days open in order through the existing `isFutureFieldTicket` guard, unchanged.
- **Conflict:** none. DN-1 supersedes the holdover portions of `decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md` (`reference`, 31.8 KB) where they differ.
- **Open question:** none
- **Ripple:** §11a row 11.
- **Acceptance:** a job with one held employee and no held crane still gives the full flow including the crane prompt (H1). Day 2 cannot open before Day 1.
- **Notes for the executor:** day index from a missing day counts as the last day (PLAN, as `toHoldoverPayload`). Not changed: `Job.subsistenceHoldover` (a payroll flag, not this holdover).

### REQ-08 — Holdover step lists `[UNVERIFIED]`

- **Statement:** Holdover tickets use these step counts: FULL 14 non-holdover, 13 / 11 middle day (Yard / Home), 15 / 13 last day (Yard / Home); STANDARD 8, 7 / 5, 8 / 6. Middle days have no Arrive Yard and no Compliance, with Post-Trip before Left Job; the last day returns to the yard as usual; STANDARD holdover has no Start Work, End Work or crane steps.
- **Surface:** shared (`flowStepKeys`, `requiredFlowStepKeys`), mobile, api
- **Sources:** DN-1 H8, H9 and the "Step lists" table — `[UNVERIFIED]` — kind: decision. Lists given for FULL middle day (Yard and Home) and STANDARD non-holdover; "FULL, last day: the full order with endWork added, and from Home without leftYard and driving."
- **Conflict:** none
- **Open question:** none. **Order of the last-day lists is described, not enumerated, in DN-1**; the PLAN says "explicit holdover arrays" without listing last-day keys. Executor must write them from the sentence above and the counts; if the counts and the sentence disagree, stop and ask.
- **Ripple:** §11a rows 1, 12.
- **Acceptance:** per-variant key arrays equal the counts above; Day 1 always uses the Yard list; Day 2+ with no day-start yet uses the Yard list and the overview blocks the steps (PLAN).
- **Notes for the executor:** `visibleFlowStepKeys(employeeTypeName)` stays as a wrapper until U5 (PLAN).

### REQ-09 — Day-start choice, Yard or Home `[UNVERIFIED]`

- **Statement:** On Day 2 and later the worker first answers "Where are you starting from?" (Yard or Home); Home removes Left Yard and Driving and puts Arrive Job first, then Pre-Trip. The choice is stored on the ticket and can be recorded offline.
- **Surface:** schema, api, mobile, shared
- **Sources:**
  - DN-1 H7, S2 — `[UNVERIFIED]` — kind: decision. New nullable `dayStartFrom` (enum `TicketDayStart`: YARD, HOME) and `dayStartAt` on `JobTicket`, written by `PATCH /field/tickets/:id/day-start`, queued offline.
  - PLAN — `[UNVERIFIED]` — kind: plan — rules: primary employee only; non-terminal ticket; holdover ticket on Day 2+; same value idempotent; changed value after any step recorded gives 409 `DAY_START_LOCKED`; `CHECK` both-null-or-both-set.
- **Conflict:** the choice interacts with the verified yard-to-yard paid-time boundary — see Q5. Not a conflict between documents; an unanswered pay question.
- **Open question:** Q5 (does Home start change when paid time begins?).
- **Ripple:** §11a rows 11, 13.
- **Acceptance:** PATCH matrix tested: 400, 409, idempotent re-send (PLAN key tests); steps stay locked until a choice exists; a 409 is resolved by adopting the server's value (PLAN).
- **Notes for the executor:** structural choices are §11b D1, D2, D3. Two devices choosing differently get a 409 (PLAN risk).

### REQ-10 — Previous-day crane state, derived `[UNVERIFIED]`

- **Statement:** The API derives a ticket's previous-day crane state from the previous day's ticket for the same Oiler slot (matched on `jobResourceId` and shift first, then the set): any `BREAKDOWN_TIME` row gives BROKEN_DOWN; an End Work with no break-down gives LEFT_SET_UP; neither gives UNKNOWN; Day 1 gives NOT_SET_UP.
- **Surface:** api, shared (`PREVIOUS_DAY_CRANE_STATES`)
- **Sources:** DN-1 S1 — `[UNVERIFIED]` — kind: decision. "No schema change."
- **Conflict:** none
- **Open question:** none
- **Ripple:** none — new surface only (established by: `git grep -n 'previousDayCrane\|PREVIOUS_DAY_CRANE' -- apps packages` returned no repo hits — **not run**; executor to run).
- **Acceptance:** `derivePreviousDayCrane` cases: no ticket, break-down, End Work only, Day 1 (PLAN key tests). Day N opened before Day N−1 synced yields UNKNOWN (PLAN risk, intended).
- **Notes for the executor:** pure function in `usecase/job-tickets/ticket-holdover.ts`.

### REQ-11 — End Work step on FULL holdover tickets `[UNVERIFIED]`

- **Statement:** FULL holdover tickets have an End Work step after Start Work and before Final Signature; it records `WORK_AT_JOB_SITE_TIME.endedAt`, closes the open boom at the same instant on a day with no break-down, and does not stop `WORK_TIME` (which still closes at submit). It shows a summary: work time, boom total with sessions, lunch/pause, non-boom time.
- **Surface:** mobile, api, shared
- **Sources:** DN-1 H3 — `[UNVERIFIED]` — kind: decision. Non-holdover tickets are unchanged (the break-down end is the End Work, with no step). Resolves `field-ops/gaps.md#end-work--break-down-end-or-the-crew-leaving-the-job-site` per DN-1 (I read the DN-1 statement, not that gap entry).
- **Conflict:** none recorded by DN-1. That gap entry existed because End Work's meaning was unsettled in the field-ops documents; DN-1 answers it as developer direction only.
- **Open question:** none
- **Ripple:** §11a rows 12, 14. `endWork` is not in `RETURNED_CORRECTION_STEPS` (`ticket-step.constants.ts:93`), so crews cannot correct it on a returned ticket; Payroll fixes it (PLAN risk, no source).
- **Acceptance:** with no break-down, the boom closes at End Work (bumped by 1 second if start ≥ end — PLAN); `WORK_TIME` remains open until submit.
- **Notes for the executor:** PLAN restores `EndWorkBody.tsx` and `end-work-summary.ts` from commit `30f0e4b0f^`; the work-time row starts at `arriveJob`. Bounds and test IDs per PLAN M3, M4.

### REQ-12 — Start Work modes on holdover tickets `[UNVERIFIED]`

- **Statement:** On holdover tickets the step is titled "Start Work". On a held day a Start Work card replaces the build-up card and its tap is the boom start; build up happens only on Day 1 or after a break-down day; when the previous crane state is unknown the worker chooses Start Build Up or Skip Build Up.
- **Surface:** mobile
- **Sources:** DN-1 H4, H6 — `[UNVERIFIED]` — kind: decision. PLAN gives the mapping: LEFT_SET_UP gives START_WORK, UNKNOWN gives CHOOSE, anything else gives BUILD_UP.
- **Conflict:** none
- **Open question:** none
- **Ripple:** §11a row 14.
- **Acceptance:** each previous crane state shows the mode above.
- **Notes for the executor:** pure `holdover-start-mode.ts`; new test IDs in PLAN (`holdover-start-card`).

### REQ-13 — End-of-day crane sheet `[UNVERIFIED]`

- **Statement:** On every day but the last, End Work opens a sheet with Leave crane set up or Start Breakdown; on the last day there is no prompt and the break-down is required.
- **Surface:** mobile
- **Sources:** DN-1 H5 — `[UNVERIFIED]` — kind: decision.
- **Conflict:** none
- **Open question:** none
- **Ripple:** §11a row 14.
- **Acceptance:** sheet shown days 1..N−1 only; on day N the break-down is required before submit.
- **Notes for the executor:** PLAN: holdover tickets never call `closeBillableWindow`; all five callers in `StartWorkBody.tsx` guarded; `buildStartWorkOps` drops its break-down fallback.

### REQ-14 — Time-edge rules on holdover `[UNVERIFIED]`

- **Statement:** On holdover tickets: End Work with no break-down closes the open `BOOM_TIME`; the break-down end does not close `WORK_AT_JOB_SITE_TIME`; recording the boom start twice with the same `startedAt` is idempotent.
- **Surface:** api, mobile
- **Sources:**
  - DN-1 H3 — `[UNVERIFIED]` — kind: decision — covers the boom close.
  - PLAN design — `[UNVERIFIED]` — kind: plan — the mirror-skip and idempotence rules are in the PLAN and **not in either decision note**. They are developer design, listed here as such.
- **Conflict:** none
- **Open question:** none
- **Ripple:** §11a row 14; callers of `mirrorBreakdownEndOntoWorkAtJobSite` (`ticket-breakdowns.service.ts`).
- **Acceptance:** break-down mirror skipped on holdover (PLAN key test); boom close at End Work; duplicate boom start no-ops.
- **Notes for the executor:** `recordTicketStep`, `job-tickets.service.ts:793`; mirror at `ticket-breakdowns.service.ts:221,248,282` (PLAN line numbers, unverified).

### REQ-15 — Open-`YARD_TIME` payroll flags skipped on middle days `[UNVERIFIED]`

- **Statement:** On holdover days other than the last, the invalid-times, crew-yard-mismatch and Samsara payroll flags are not raised for an open `YARD_TIME`.
- **Surface:** api (`FlagDetectionJobDay.holdoverMidDay`)
- **Sources:**
  - DN-1 S3 — `[UNVERIFIED]` — kind: decision.
  - `decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md` — `[VERIFIED]` — kind: decision — the paid-time boundary is yard to yard. DN-1 itself notes S3 does not override it (payroll `gaps.md:5767` stays partly open).
- **Conflict:** no document conflict; an open pay question — Q5.
- **Open question:** Q5; Q8 (other readers of open `YARD_TIME`).
- **Ripple:** §11a row 15 — 20 non-spec files under `apps/api/src` mention `YARD_TIME`; DN-1 names three. PLAN risk: "check every reader beyond the three flags before H5". No source says what happens to the others — **OPEN, Q8**.
- **Acceptance:** the three flags do not fire for an open `YARD_TIME` on a middle day (PLAN test); behaviour of other readers `OPEN — Q8`.
- **Notes for the executor:** blocked on Q8 for the non-flag readers. The three flag files and lines in the PLAN: `payroll-flag-invalid-times.ts:566`, `crew-yard-mismatch :171`, `samsara-mismatch :49`. Workaround: ship only the three flag exemptions, labelled as partial.

### REQ-16 — Web progress shows real per-day holdover steps `[UNVERIFIED]`

- **Statement:** Web job-progress takes its step order from the same step list as mobile, per holdover ticket, and never infers a floating step as done.
- **Surface:** api (`derive-ticket-progress-view.ts`), web
- **Sources:** DN-1 S4, D9 — `[UNVERIFIED]` — kind: decision.
- **Conflict:** none
- **Open question:** none
- **Ripple:** §11a row 9.
- **Acceptance:** a 3-day holdover job shows each ticket's own step set on web.
- **Notes for the executor:** the `tcg-contract-tracer` should run on any FieldTicket or progress-shape change (PLAN).

### REQ-17 — No holdover kill switch `[UNVERIFIED]`

- **Statement:** Holdover goes live when the API deploys; there is no feature flag. Old mobile builds on holdover jobs cannot submit until they update.
- **Surface:** api, mobile (rollout)
- **Sources:** DN-1 S5 — `[UNVERIFIED]` — kind: decision.
- **Conflict:** none
- **Open question:** none
- **Ripple:** old mobile builds — accepted by DN-1.
- **Acceptance:** H2–H4 and M1–M6 merge and deploy together (PLAN).
- **Notes for the executor:** this rollout order is also the PLAN's.

### REQ-18 — Completion window = scheduled end + 24h `[UNVERIFIED]`

- **Statement:** A ticket can be completed until its scheduled end plus 24 hours; the scheduled end is computed when read from the per-day job's `JobScheduleInterval` (`estimatedEndTime` on `estimatedEndDate`, shift-2 fields for shift 2) in business time; inside the window the worker can complete every step and enter actual times on the original date. A ticket's `completedAt` is set from the client's time capped at the server's clock; late = `completedAt` after the scheduled end, shown internally only, never in customer emails or on signatures.
- **Surface:** shared (`ticketScheduledEnd`, `ticketCompletionWindow`), api, schema (`JobTicket.completedAt`)
- **Sources:** DN-2 L2, L11 — `[UNVERIFIED]` — kind: decision. Resolves `field-ops/gaps.md#late-and-incomplete-tickets--where-the-24-hour-window-starts-what-it-allows-and-how-reminders-are-anchored`.
- **Conflict:** none. Supersedes the late-ticket parts of the 2026-10-06 Melissa note (`reference`, 31.8 KB).
- **Open question:** none. If the schema-nullable end is absent the PLAN returns `UNSCHEDULED` and does not lock; "Haris says this never happens" (PLAN). That fallback is plan detail, not a decision note — treat as defensive only.
- **Ripple:** §11a rows 4, 16, 17.
- **Acceptance:** helper tests for window open/closed/approval; `completedAt` after the scheduled end marks late. Timezone: business time, and SCRUM-TZ later swaps the helper's `tz` argument (PLAN).
- **Notes for the executor:** the mobile app never converts zones itself.

### REQ-19 — API enforces the window; who may act; payroll lock `[UNVERIFIED]`

- **Statement:** One write check returns 409 `TICKET_WINDOW_CLOSED` once the window has closed and no approval is open (never 403); comments are exempt; rejecting a ticket after the window is refused. Only the worker (inside the window or an approved 4h window) and `payroll-admin` holders may complete or correct a ticket; a ticket whose employee week is APPROVED or EXPORTED is never updated, including by payroll's own paths (409 `TICKET_PAYROLL_LOCKED` in the PLAN).
- **Surface:** api
- **Sources:** DN-2 L7, L8, L13 — `[UNVERIFIED]` — kind: decision. L8: "Nothing holds week approval; the write is refused when it happens."
- **Conflict:** `decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md` (`verified`) blocks a payroll week until every ticket is complete and left open who may complete a never-completed ticket. DN-2 L7 answers that as developer direction. Compatible, not conflicting; noted so a reader sees the verified note was consulted.
- **Open question:** none for the rule; employees who leave: Q2.
- **Ripple:** §11a rows 16, 18 (all writes through `getTicketForEmployeeAction(…,'write')`; terminal lock now also covers checklists and attachments).
- **Acceptance:** write at scheduled end + 25h with no approval returns 409; comment succeeds; approval of a request for a ticket in an APPROVED/EXPORTED week is refused with `TICKET_PAYROLL_LOCKED`.
- **Notes for the executor:** PLAN: `ticket-write-window.util.ts` with `resolveTicketWriteGrant`; modes OPEN, LATE_WINDOW, APPROVED_EDIT, RETURNED_CORRECTION, COMPLETE_LOCKED; a returned correction is checked before the window; a new request is refused while a send-back is open. Tighter COMPLETE lock: replayed checklist/attachment ops after submit now fail with 409 — test drain order.

### REQ-20 — Submit locks at once; edit after submit by request `[UNVERIFIED]`

- **Statement:** Submitting a ticket locks it immediately, even inside the 24h; editing a COMPLETE ticket goes through the request flow (kind `SUBMITTED_EDIT`); on approval the ticket stays COMPLETE and the request grants a write exemption; resubmitting re-queues payroll.
- **Surface:** api, mobile
- **Sources:** DN-2 L4 — `[UNVERIFIED]` — kind: decision.
- **Conflict:** none
- **Open question:** none
- **Ripple:** §11a rows 16, 18. Behaviour change: submit used to be editable? **Not established** — the current post-submit editability of a COMPLETE ticket is a repo fact the executor must state before building.
- **Acceptance:** submit, then edit → locked → request → approve → edit and resubmit → payroll re-queues; status COMPLETE throughout (PLAN scenario 11).
- **Notes for the executor:** `completeTicketIfOpen` stamps `completedAt` (PLAN, `job-tickets.service.ts:675`).

### REQ-21 — Edit-request lifecycle and 4h approval window `[UNVERIFIED]`

- **Statement:** After the window closes the worker raises an in-app request with one reason; an `payroll-admin:edit` holder approves or denies in one tap; approval opens a 4h window from the approver's click, after which the ticket locks again and a new request is allowed; one open request per ticket.
- **Surface:** schema (`TicketEditRequest`, enums), api, web, mobile
- **Sources:** DN-2 L3, L9, L11 — `[UNVERIFIED]` — kind: decision. Model fields: kind, status (PENDING / APPROVED / DENIED / EXPIRED), reason, requestedBy, decidedBy, decidedAt, windowEndsAt, submittedAt. L9: reason on the request only; edits inside the window keep today's per-step reason rules.
- **Conflict:** none
- **Open question:** none
- **Ripple:** none for the model — new surface only (established by: `git grep -n 'TicketEditRequest' -- apps packages` — **not run**).
- **Acceptance:** states and transitions above; partial unique index makes a second open request fail; expired requests flipped lazily and by cron.
- **Notes for the executor:** endpoints in the PLAN: `POST /field/tickets/:id/edit-requests`, `GET/POST /payroll/ticket-edit-requests[/:id/approve|deny]`. Approval is a conditional update, then the L8 lock check.

### REQ-22 — `payroll-admin:edit` granted to Payroll Manager `[UNVERIFIED]`

- **Statement:** The Payroll Manager role receives `payroll-admin:edit` in the seed and through a SQL data migration for existing tenants, so Payroll Admin and Payroll Manager can both approve requests.
- **Surface:** api (seed, migration)
- **Sources:**
  - DN-2 L5 — `[UNVERIFIED]` — kind: decision. Reverses E2 of `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` (`reference`, 79.4 KB — I did not read E2 itself).
  - `decisions/2026-10-13-fix-entry-roundtrip-attribution-and-pm-pa-split.md` — `[UNVERIFIED]` — kind: decision (`reference`) — the PM/PA split: Payroll Admin acts only on returned entries; `send-back close` and `send-to-employee` stay `payroll-admin:edit`.
- **Conflict:** none between documents; a reach question, see Q6.
- **Open question:** Q6.
- **Ripple:** §11a row 19 — 18 existing `@RequirePermission('payroll-admin', 'edit'|'view')` routes (payroll controller ×8, send-backs ×4, flags ×4, corrections ×1, time overrides ×1). Granting the permission opens every one to Payroll Manager. **No source says that is intended.** `OPEN — Q6`.
- **Acceptance:** `OPEN — blocked on Q6` for the reach; the grant itself is stated.
- **Notes for the executor:** PLAN risk: re-seeding rewrites role permissions, so the seed itself must grant `payroll-admin: edit`. Workaround, labelled: none that avoids the reach short of a separate permission, which is a §11b matter.

### REQ-23 — Reminders and notifications `[UNVERIFIED]`

- **Statement:** The worker is pushed at scheduled end +12h and +20h while the ticket is still incomplete; payroll admins get in-app and push notices for new requests and in-app only for late completions and approved edits; the worker gets a push on approval or denial.
- **Surface:** api (catalog, cron), mobile, web
- **Sources:** DN-2 L6, L14 — `[UNVERIFIED]` — kind: decision.
- **Conflict:** none
- **Open question:** none
- **Ripple:** none for new templates; the cron reuses `NotificationReminderLog` (PLAN) — `git grep -ln 'NotificationReminderLog\|CRON_JOBS' -- apps/api/src` lists the existing scheduler files (§11a row 20).
- **Acceptance:** reminders at +12h/+20h, deduped; stop once complete. PLAN: `CRON_JOBS.ticketWindow` every 15 min.
- **Notes for the executor:** a push tap opens the ticket ready to edit. Notification volume risk: every completion after the scheduled end counts as late (PLAN).

### REQ-24 — Audit trail on ActivityLog `[UNVERIFIED]`

- **Statement:** Request, approval, denial, expiry, late completion and each edit made under an approval are written to `ActivityLog` (entity JOB_TICKET, `changes` JSON) with field, from, to, actor and time.
- **Surface:** schema (new `ActivityLogAction` members), api (interceptor)
- **Sources:** DN-2 L10 — `[UNVERIFIED]` — kind: decision. Members: `TICKET_EDIT_REQUESTED`, `TICKET_EDIT_APPROVED`, `TICKET_EDIT_DENIED`, `TICKET_EDIT_EXPIRED`, `TICKET_LATE_COMPLETED`, `TICKET_EDITED_UNDER_APPROVAL`.
- **Conflict:** none
- **Open question:** none
- **Ripple:** adding enum members touches every `switch` or label map on `ActivityLogAction` — §11a row 21.
- **Acceptance:** each action produces a row; an edit under approval yields a diff row per changed field.
- **Notes for the executor:** snapshot-diff interceptor on `FieldTicketsController`. Migration required (enum members).

### REQ-25 — Web late-tickets page and Late badge `[UNVERIFIED]`

- **Statement:** A page `/payroll/late-tickets` for `payroll-admin` holders lists tickets under tabs Overdue, Requests and Locked and offers Approve and Deny; payroll entries show a Late badge.
- **Surface:** web, api (`GET /payroll/late-tickets`)
- **Sources:** DN-2 L12, L11 — `[UNVERIFIED]` — kind: decision.
- **Conflict:** none
- **Open question:** none
- **Ripple:** new route; the Late badge reaches payroll job-day payload consumers (`completedAt`, `completedLate`) — §11a row 22.
- **Acceptance:** page visible only with `payroll-admin`; Approve/Deny round-trip.
- **Notes for the executor:** `WorkspaceTable`, `returned-entries-list.tsx` as model (PLAN); test IDs `payroll-late-tickets-*`, `payroll-entry-late-badge`. **Copy NOT SPECIFIED** beyond the tab names and button labels above.

### REQ-26 — Mobile Home "Incomplete" section `[UNVERIFIED]`

- **Statement:** Mobile Home shows an "Incomplete" section for incomplete tickets whose scheduled end falls in the last 14 days, hiding payroll-locked tickets; each card shows a countdown, then Request approval, then Waiting for approval, then a 4h countdown once approved.
- **Surface:** mobile
- **Sources:** DN-2 L15 — `[UNVERIFIED]` — kind: decision.
- **Conflict:** none
- **Open question:** none
- **Ripple:** the Home/ticket buckets already exist (`expiredWhere` now means "window closed, never started" — PLAN); §11a row 23.
- **Acceptance:** an unstarted ticket 2h past scheduled end appears with a countdown (PLAN scenario 9).
- **Notes for the executor:** countdown corrects clock skew via `serverNow`; `ticketEditability()` falls back to `isPastFieldTicket`.

### REQ-27 — Inspections inside and after the window `[UNVERIFIED]`

- **Statement:** Inside the window inspections need no approval; after it they go through a request. A ticket cannot be submitted with an inspection skipped (Part 1's submit block).
- **Surface:** mobile, api
- **Sources:** DN-2 L16 — `[UNVERIFIED]` — kind: decision.
- **Conflict:** none
- **Open question:** none
- **Ripple:** none new beyond REQ-03/04.
- **Acceptance:** as stated.
- **Notes for the executor:** none.

### REQ-28 — Offline `capturedAt` and 72h grace `[UNVERIFIED]`

- **Statement:** Each queued op carries `capturedAt`, sent as `X-Captured-At`; the server accepts it when captured before the window ended and arriving within 72h; the acceptance is audited; ops with no tag are judged by the server's clock.
- **Surface:** mobile (outbox), api
- **Sources:** DN-2 L17 — `[UNVERIFIED]` — kind: decision.
- **Conflict:** none
- **Open question:** none
- **Ripple:** every queued op type in `sync/drain.ts` (§11a row 24).
- **Acceptance:** capture offline inside the window, sync 30h later: accepted and audited; sync after 72h: 409 (PLAN scenario 13). A 409 shows a call to action, not a retry.
- **Notes for the executor:** why 409, not 403: the outbox swallows 403 (DN-2 L13).

### REQ-29 — Payroll overlay moves to the shared scheduled-end helper `[UNVERIFIED]`

- **Statement:** `payroll-week-overlay.ts` computes the scheduled end with the shared business-time `ticketScheduledEnd` instead of UTC.
- **Surface:** api
- **Sources:** DN-2 L18 — `[UNVERIFIED]` — kind: decision.
- **Conflict:** none
- **Open question:** none
- **Ripple:** §11a row 17.
- **Acceptance:** overlay results match the shared helper for the same interval.
- **Notes for the executor:** PLAN cites `payroll-week-overlay.ts:131`.

### REQ-30 — Oiler fills the shared ticket: does it still govern Operators? `[OPEN]`

- **Statement:** `OPEN — the intent asks that the verified one-ticket rule (Oiler fills the shared ticket) keep governing Operators; no source settles how this interacts with a provisional answer that Operators "complete their own tickets".`
- **Surface:**
- **Sources:** none to build from. Searched: `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` (`verified`, 14.4 KB) clause 2/3; the Melissa provisional note (31.8 KB) T1 at line 243; `field-ops/gaps.md:905`. DN-2 lists T1 as "Open — the verified one-ticket rule still governs." That is a holding statement, not a rule for the new window/approval flow.
- **Conflict:** n/a
- **Open question:** Q1, logged at `field-ops/gaps.md#who-completes-the-ticket-when-an-oiler-is-on-the-set--operators-complete-their-own-tickets-provisional-vs-the-verified-one-ticket-rule`.
- **Ripple:** `OPEN — cannot be stated until the question above is answered.` Reaches REQ-01 (folded Operator), REQ-19 (who may complete), REQ-26 (whose Home shows the incomplete ticket).
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked for the Operator-on-an-Oiler's-ticket case. Smallest slice that does not depend on it: build as the verified rule reads today (Oiler primary, Operator's labor entered by the Oiler) — **a workaround, labelled; not a decision**.

### REQ-31 — Employee leaves with incomplete tickets `[OPEN]`

- **Statement:** `OPEN — the intent leaves this undesigned; no source says who finishes or cancels the tickets of an employee who leaves or loses access, or whether the worker's window still applies.`
- **Surface:**
- **Sources:** none. Searched `field-ops/gaps.md:927` (asked 2026-10-07, T12, answer given was about offline capture, not this); `fcc-e-ticket-and-atom-guides.md` (FCC cancels or forces completion from the office, `unverified`); the verified 09-30 incomplete-tickets note (an abandoned ticket blocks payroll; its Not-decided item 2). DN-2: "Open — not designed."
- **Conflict:** n/a
- **Open question:** Q2, logged at `field-ops/gaps.md#a-field-employee-leaves-the-company-or-loses-access-with-tickets-still-incomplete--asked-not-answered`.
- **Ripple:** `OPEN — cannot be stated until the question above is answered.` A departed worker's ticket still blocks payroll under the verified note; L7 excludes dispatch and supervisors.
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked. Nothing here is built.

### REQ-32 — Previous-ticket enforcement strength `[OPEN]`

- **Statement:** `OPEN — the intent leaves this undesigned; no source says whether an earlier incomplete or overdue ticket warns, soft-blocks or hard-blocks starting the next one.`
- **Surface:**
- **Sources:** none. Searched `field-ops/gaps.md:987`; `brs.md` BRS-TVL-004 and OD-001 (`unverified`); the Melissa note T14. Melissa's worry that approval "would cause another bottleneck" argues against a hard block but is not an answer (gaps entry).
- **Conflict:** n/a
- **Open question:** Q3, logged at `field-ops/gaps.md#previous-ticket-enforcement-brs-tvl-004--od-001--warning-soft-block-or-hard-block`.
- **Ripple:** `OPEN — cannot be stated until the question above is answered.` Would reach the start of every ticket, i.e. the `isFutureFieldTicket` date-order guard (REQ-07) and the Incomplete section (REQ-26).
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked. REQ-07 keeps the existing date-order guard unchanged; nothing else gates a start.

### REQ-33 — Two Operator slots and no Oiler `[OPEN]`

- **Statement:** `OPEN — D1 gives an Operator slot FULL flow when the set has no Oiler slot; no source says which Operator, or both, when there are two Operator slots and no Oiler.`
- **Surface:**
- **Sources:** DN-1 D3: behaviour stays as today (each Operator gets their own ticket, both FULL); "not a real case". Searched `field-ops/gaps.md:1032` (filed 2026-10-15). Nothing else written.
- **Conflict:** n/a
- **Open question:** Q4, logged at `field-ops/gaps.md#two-operator-slots-and-no-oiler-on-the-same-das-set--which-operator-gets-full`.
- **Ripple:** `OPEN — cannot be stated until the question above is answered.` Existing behaviour is the stated default.
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** not blocked. Leave current behaviour; do not add code for this case.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** yes
- **Migration required:** yes — `pnpm db:migrate`, committed under `apps/api/prisma/migrations/`. Mandatory (`.ai/claude/contexts/prisma.md`). Units: H2 (holdover columns and enum), LT2 (edit request), LT3 (data migration for Payroll Manager), LT9 (`ActivityLogAction` members).
- **Data backfill required:** yes for `JobTicket.completedAt` — "a backfill from `ActivityLog` status changes" (PLAN, LT2). The rule for tickets with no matching log row: `NOT SPECIFIED`. Also the SQL data migration for REQ-22.
- **Existing models considered** *(mandatory before proposing a new model or column)*: I did not run `grep -n 'model ' apps/api/prisma/schema.prisma` for this spec. The PLAN chose: `JobTicket` columns for day start (one value per ticket, lifecycle = the ticket's, so a column, not a table — fits the template's rule that a one-to-one table is a column); a new `TicketEditRequest` model (one-to-many, per ticket, with its own lifecycle). `ActivityLog` is reused for audit. The elaborator did not check whether an existing model (`PayrollSendBack`, `PayrollCorrection`) could hold an edit request; that comparison is §11b D4.

```prisma
// Proposed by the PLAN — not decided by this spec. Developer confirms in §11b.
// enum TicketDayStart { YARD HOME }
// JobTicket.dayStartFrom TicketDayStart? ; JobTicket.dayStartAt DateTime? @db.Timestamptz ; CHECK both-null-or-both-set
// JobTicket.completedAt  DateTime? @db.Timestamptz
// model TicketEditRequest { kind, status (PENDING|APPROVED|DENIED|EXPIRED), reason, requestedBy, decidedBy, decidedAt, windowEndsAt, submittedAt }
//   + partial unique index: one open request per ticket; add 'ticketeditrequest' to TENANT_SCOPED_MODELS
```

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| `TicketEditRequest` | `NOT SPECIFIED` | `NOT SPECIFIED` | `NOT SPECIFIED` | REQ-21 — see §11b D5 |

- **New prefix introduced:** `NOT SPECIFIED`. The root `CLAUDE.md` Identity Convention says every business entity has a code; no source says whether this record is one or a log-like child row. A new prefix is product-visible; I have not chosen one. Developer decision D5.
- **Child relations:** FK to `JobTicket` by UUID `id`; requester and decider reference users/employees by UUID. Exact relation targets `NOT SPECIFIED`.
- **Fields whose type/precision no source states:** `reason` length (NOT SPECIFIED); `kind` enum members beyond `SUBMITTED_EDIT` and the late-completion kind (the PLAN names only `SUBMITTED_EDIT` — the other member's name is NOT SPECIFIED); the `ActivityLog` `changes` JSON shape beyond "field, from, to, actor, time". Dates are `@db.Timestamptz`.

## 4. API surface — `apps/api`

- **Pattern:** none — field-ticket and payroll flows are not a `patterns.md` P1/P2 CRUD. The late-tickets list follows `returned-entries-list` on web (PLAN). The `patterns.md` guidance to name a pattern does not resolve to an entry here; no `UNDECIDED` entry applies.
- **Existing functions/services to reuse** (found, not chosen):
  - `usecase/job-tickets/job-tickets.service.ts` (`getTicketForEmployeeAction` ~:1372, `completeTicketIfOpen` ~:675, `recordTicketStep` ~:793), `submit-step-guard.ts`, `ticket-step.constants.ts` (`RETURNED_CORRECTION_STEPS`), `returned-ticket-correction.ts`
  - `usecase/field-tickets/field-tickets.service.ts` and `field-ticket.mapper.ts`
  - `service/job-holdover/job-holdover.repository.ts`, `usecase/jobs/job-holdover.service.ts`
  - `usecase/payroll/payroll-week-overlay.ts`, `payroll-approval-gate.ts`
  - `usecase/notifications/notification-scheduled-jobs.service.ts`, `service/notifications/notification-reminder-log.repository.ts`
  - `usecase/ticket-breakdowns/ticket-breakdowns.service.ts`
  - Found by the `git grep` passes in §11a; not a full search.
- **New exported functions/services proposed (by the PLAN):** `resolveTicketStepFlow`, `ticketScheduledEnd`, `ticketCompletionWindow`, `approvalWindowEndsAt`, `isApprovalOpen`, `isLateCompletion` (shared); `TicketHoldoverService`, `ticket-holdover.repository.ts`, `holdover-days.util.ts`, `matchPreviousTicket`, `derivePreviousDayCrane`, `ticket-write-window.util.ts`, `resolveTicketWriteGrant`, the edit-request service, the audit interceptor, `CRON_JOBS.ticketWindow`. Each is a §11b decision (D6).

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `PATCH` | `/field/tickets/:id/day-start` | field-tickets controller | `NOT SPECIFIED` | `NOT SPECIFIED` | REQ-09 |
| `POST` | `/field/tickets/:id/edit-requests` | field-tickets controller | `NOT SPECIFIED` | `NOT SPECIFIED` | REQ-21 |
| `GET` | `/payroll/ticket-edit-requests` | `NOT SPECIFIED` | `NOT SPECIFIED` | `NOT SPECIFIED` | REQ-21, 25 |
| `POST` | `/payroll/ticket-edit-requests/:id/approve` and `/deny` | `NOT SPECIFIED` | `NOT SPECIFIED` | `NOT SPECIFIED` | REQ-21 |
| `GET` | `/payroll/late-tickets` | `NOT SPECIFIED` | `NOT SPECIFIED` | `NOT SPECIFIED` | REQ-25 |

Changed shapes: `FieldTicket` gains `stepFlow`, `holdover`, `completionWindow`, `editRequest`, `serverNow`; `listMine` gains an `incomplete` bucket; payroll job-day payload gains `completedAt`, `completedLate` (all from the PLAN).

Per endpoint:

- **Request DTO:** day-start `{ from, at }` (PLAN). Edit-request body: one reason (DN-2 L3); length/rules `NOT SPECIFIED`.
- **Response shape:** `NOT SPECIFIED` beyond the field additions above.
- **Guards / roles:** day-start — primary employee of the ticket only; field edit-requests — the worker; `/payroll/*` — `payroll-admin:edit` (DN-2 L3, L5). Whether `GET` uses `view` or `edit`: `NOT SPECIFIED`.
- **Route param identity:** `:id` as used by existing `/field/tickets/:id`; business-code resolution `NOT SPECIFIED` — follow the existing controller.
- **Errors:** 409 `TICKET_WINDOW_CLOSED`; 409 `TICKET_PAYROLL_LOCKED`; 409 `DAY_START_LOCKED`; 400 `TICKET_STEPS_MISSING` (names from PLAN/DN-2; the day-start 400 conditions are the PLAN list). Messages `NOT SPECIFIED`.
- **Module registration:** new modules registered in `app.module.ts`; barrel `index.ts` in every folder.

## 5. Web surface — `apps/web`

- **Routes:** `/payroll/late-tickets` (REQ-25). Sidebar entry and summary badge; `notification-navigation` gets a `TICKET_EDIT_REQUEST` target (PLAN).
- **Existing components to reuse:** `WorkspaceTable` (`components/templates/workspace-table.tsx`), `useWorkspaceTableControls`, `SectionTabs`, `StatusBadge`, `PageHero`; modelled on `features/payroll-returned-entries` `returned-entries-list.tsx` (PLAN). `find-component` skill must be run across the nine `components/` directories before creating anything.
- **New components proposed:** feature folder `features/payroll-late-tickets/` and the Late badge (PLAN). Whether the Late badge extends an existing badge: unchecked.
- **Table:** tabs Overdue, Requests, Locked (DN-2 L12). `searchPlaceholder`: must enumerate every searchable field — `NOT SPECIFIED` (no source lists the searchable fields). `emptyFilterStateMessage`: `NOT SPECIFIED`.
- **Forms:** Approve / Deny are one-tap actions (L3); no form.
- **Server state:** TanStack Query v5; keys and invalidation `NOT SPECIFIED`.
- **Colors / spacing:** `theme.css` variables only.
- **Responsive:** `NOT SPECIFIED` beyond web rules.
- **Copy:** tab names Overdue / Requests / Locked, buttons Approve / Deny, badge "Late". Everything else `NOT SPECIFIED`.
- Holdover web progress (REQ-16) lands in `features/ticket-progress/` (consumer of `derive-ticket-progress-view`); exact files `NOT SPECIFIED`.
- `data-testid`: `payroll-late-tickets-*`, `payroll-entry-late-badge` (PLAN). Run `grep -rn '<id>' qa-automation/e2e` before renaming any existing ID. The PLAN says no qa-automation field-ticket specs exist; I did not verify.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** `app/(field)/ticket/index.tsx` (overview; day-start card at the top panel, PLAN `index.tsx:701-715`), ticket details, ticket card, Home (`app/(field)/field.tsx`). Exact Expo Router additions `NOT SPECIFIED`.
- **Components:** new per PLAN: `holdover-day-start-card.tsx`, `holdover-start-card.tsx`, `end-work-holdover-sheet.tsx`, `incomplete-tickets-section.tsx`, `incomplete-ticket-card.tsx`, `edit-request-sheet.tsx`; restore `EndWorkBody.tsx` and `end-work-summary.ts` from `30f0e4b0f^`. Tokens from `theme/tokens.ts`, `StyleSheet.create` only.
- **Offline / sync behavior:** day-start is queued (new `dayStart` op ranked before `shiftStart`); `sync/drain.ts` ranks steps by the ALL key list and handles the timer kind; ops carry `capturedAt` (REQ-28); a 409 shows a call to action. Day N before Day N−1 syncs reads crane state UNKNOWN (REQ-10). All from DN-1/DN-2/PLAN; any further offline rule `NOT SPECIFIED`.
- **Touch targets:** 48px.
- **Push / notifications involvement:** REQ-23 — worker pushes at +12h, +20h, on approval and denial; catalog entries plus `templates/ticket-edit-request-notices.ts` (PLAN). Call sites `NOT SPECIFIED`.

## 7. Shared package — `packages/shared`

- **Types added / changed:** `resolveTicketStepFlow`, `ALL_TICKET_FLOW_STEP_KEYS` (15 keys, `endWork` after `startWork`), FULL-only keys, `FLOATING_FLOW_STEP_KEYS = pretrip, jsa, posttrip`, `flowStepKeys(flow, holdover?)`, `requiredFlowStepKeys(flow, holdover?)`, `ticket-holdover.ts` (`TICKET_DAY_STARTS`, `PREVIOUS_DAY_CRANE_STATES`, `TicketHoldoverContext`, `FieldTicketHoldover`, `holdoverNeedsDayStart()`), `utils/ticket-completion-window.ts` (24 / 4 / [12, 20] hours; request kinds and statuses; codes `TICKET_WINDOW_CLOSED`, `TICKET_PAYROLL_LOCKED`). Consumed by web **and** mobile; both must be rebuilt (`pnpm nx run @tcg/shared:build`). Pure TypeScript.

## 8. Permissions and tenancy

- **Roles permitted:** worker (own tickets); `payroll-admin:edit` holders (Payroll Admin, and Payroll Manager after REQ-22) for approvals and the late-tickets page.
- **Roles denied:** dispatchers and supervisors acting on a worker's behalf (DN-2 L7).
- **Tenant isolation:** standard `$extends` scoping; `ticketeditrequest` added to `TENANT_SCOPED_MODELS` (PLAN). `jobticket` already scoped (PLAN). The cron (`CRON_JOBS.ticketWindow`) and any non-request path run **outside request context, so scoping is skipped** (`prisma.md` case 1) — the cron must scope by tenant explicitly. Run `tcg-prisma-guardian`.
- **Cross-tenant reads:** none intended. Cron iterates all tenants deliberately; `NOT SPECIFIED` otherwise.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| day-start `from` | YARD or HOME | DN-1 S2 | `[UNVERIFIED]` |
| day-start | primary only; non-terminal; holdover Day 2+; idempotent; locked after a step is recorded | PLAN | `[UNVERIFIED]` |
| edit-request `reason` | one reason; `NOT SPECIFIED` — no source states a limit or whether it is required to be non-empty | DN-2 L3 | — |
| edit-request | one open per ticket | DN-2 L11 | `[UNVERIFIED]` |
| approval window | 4h from approval | DN-2 L3 | `[UNVERIFIED]` |
| capture grace | 72h | DN-2 L17 | `[UNVERIFIED]` |
| Incomplete section | scheduled end within last 14 days | DN-2 L15 | `[UNVERIFIED]` |
| completion window | scheduled end + 24h | DN-2 L2 | `[UNVERIFIED]` |

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | resolver matrix; all step lists incl. holdover variants; `derivePreviousDayCrane`; `advanceFrontier`; window helpers; `holdover-start-mode` | REQ-01, 08, 10, 12, 03, 18 |
| Integration (API) | day-start 400/409/idempotent; End Work boom close; mirror skipped on holdover; submit guard with holdover lists; flags exempt on middle days; 409 window; payroll lock; request lifecycle; audit rows | REQ-09, 14, 04, 15, 19, 21, 24 |
| E2E / manual script | the 13 scenarios in the PLAN "Verification" (3-day holdover job, Oiler slot filled by a Rigger, Home start, 3rd man 7/5 steps, guard on, late and approval flow, offline 30h/72h) | REQ-01..29 |

- Requirements with no testable acceptance criterion: REQ-30, 31, 32, 33 (all `[OPEN]`); REQ-15's non-flag readers; REQ-22's reach.
- `qa-automation` has no field-ticket specs (PLAN, unverified).

## 11. Non-functional

- **Performance:** `NOT SPECIFIED`. Cron every 15 min (PLAN).
- **Concurrency:** one open request per ticket via partial unique index; approval as a conditional update (PLAN). Two devices with different day starts → 409.
- **Audit / activity log:** REQ-24.
- **Migration/rollout order:** PLAN unit tables. Part 1: U1 (main), U2 → U3 → U4 → U5 stacked, U6 last. Part 2: H1 → H2 → {H3, H5, H6}, H3 → H4, M1..M6 stacked. Part 3: LT1..LT17. **U6 (guard on) only after U3, U5, H4, M6 merge and the mobile build is on phones; H2–H4 and M1–M6 deploy together (S5).** Every PR ≤ ~400 source lines / 25 files unless a developer adds `size-exception`. The decomposer owns the slicing.

## 11a. Ripple — already-shipped behaviour these requirements reach

| # | Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Mobile step selection: `ticket-flow.store.ts`, `ticket-step-screen.tsx`, `compose-ticket-detail.ts`, `sync/drain.ts`, `ticket-total.ts`, `app/(field)/ticket/index.tsx`, `StepBodyShell.tsx` | `visibleFlowStepKeys`, `TICKET_FLOW_STEP_KEYS`, `TICKET_TOTAL` | 01, 02, 08 | changes deliberately | DN-1 D4, D5 | `git grep -ln 'visibleFlowStepKeys\|TICKET_FLOW_STEP_KEYS\|TICKET_TOTAL' -- apps packages` |
| 2 | Mobile floating-step logic: `step-status.ts`, store `nextActive`, `resume-step`, `UNLOCKABLE_KEYS` | frontier rule | 03 | changes deliberately | DN-1 D6 | same grep; files named by PLAN, not verified |
| 3 | API consumers of `EmployeeType.name`/`employeeTypeName`: `job-tickets.repository.ts`, `submit-step-guard.ts`, `ticket-labor-entries.repository.ts` and `.service.ts`, `employee.repository.ts`, `users.repository.ts`, `demo-flows.service.ts` and others | slot rule | 01, 05 | crew grouping, submit guard, labor writes switch; `demo-flows.service.ts:871` and the `LaborBody.tsx:175` pay adder **not changed** | DN-1 D5; PLAN "Not changed" | `git grep -ln 'EmployeeType.name\|employeeTypeName' -- apps packages` (20 non-test files; most are seeds/quotation approval — only the ticket ones are in scope) |
| 4 | Payroll for 3rd man / Rigger (STANDARD): meal periods | D10 | 02 | meals on the engine's fallback schedule | DN-1 D10 | `meal-periods.ts` (PLAN line ref) — **not opened** |
| 5 | Old mobile builds | contract change | 02, 17 | still show Start Work; holdover jobs cannot submit until update | DN-1 S5; PLAN | n/a |
| 6 | Web job-progress: `derive-ticket-progress-view.ts`, `features/ticket-progress/components/ticket-banners.tsx` | floating rule | 03, 16 | changes deliberately (progress never infers floating done) | DN-1 D9, S4 | `git grep -ln 'ticketScheduledEnd\|scheduledEnd' -- apps packages` |
| 7 | API submit guard | `TICKET_SUBMIT_STEP_GUARD` | 04 | consumes `stepFlow`/`holdover`; flag on only after gating units | DN-1 D7; PLAN | `git grep -ln 'TICKET_SUBMIT_STEP_GUARD' -- .` |
| 8 | Mobile Review/Submit | missing-steps list | 04 | Submit disabled online and offline | DN-1 D7 | `git grep -ln 'isReadOnlyTicket\|computeOverviewSteps' -- apps/mobile` |
| 9 | `FieldTicket` shape: 56 files across shared/mobile/web | `FieldTicket` fields added | 01, 05, 07, 09, 21 | additive optional fields | DN-1 D4; PLAN (`tcg-contract-tracer`) | `git grep -ln 'FieldTicket\b' -- packages/shared apps/mobile apps/web/src` |
| 10 | EAS build env guard | `eas.json` base | 06 | guard test relaxed for one key | DN-1 D8 | `git grep -ln 'EXPO_PUBLIC_ENABLE_SEGMENT_TIME_ADJUST' -- .` (ARCHITECTURE.md, guard test, `StartWorkBody.tsx`, `segment-time-adjust*`) |
| 11 | Holdover readers of `isHoldover`: das-allocations, das-loadout, job-holdover, payroll-flags selects, web DAS allocation UI | trigger | 07, 09 | read-only; unchanged | DN-1 H1 | `git grep -ln 'isHoldover' -- apps packages` |
| 12 | `RETURNED_CORRECTION_STEPS` | `endWork` not included | 11 | crew cannot correct End Work on a returned ticket; Payroll fixes it | PLAN risk only | `git grep -n 'RETURNED_CORRECTION_STEPS' -- apps/api/src` |
| 13 | Payroll pay start on Home days | day start | 09 | OPEN — **Q5** | none | n/a |
| 14 | `StartWorkBody.tsx` (5 `closeBillableWindow` sites), `ticket-breakdowns.service.ts` (`mirrorBreakdownEndOntoWorkAtJobSite`) | holdover guard | 12, 13, 14 | changes deliberately on holdover tickets only | DN-1 H3; PLAN | `git grep -ln 'mirrorBreakdownEndOntoWorkAtJobSite\|closeBillableWindow' -- apps` |
| 15 | Other readers of open `YARD_TIME` (20 non-spec files in `apps/api/src`: payroll flags, send-backs, entry-fix plan, pricing `member-time-entries.ts`, `ticket-time-entries.repository.ts`, `correction-rules.ts`, `payroll-ticket-complete.ts`, `complete-ticket.dto.ts`, …) | middle-day open yard time | 15 | **OPEN — Q8** (only 3 flags decided) | none | `git grep -ln "YARD_TIME" -- apps/api/src \| grep -v spec` |
| 16 | `getTicketForEmployeeAction` callers: `job-tickets.service.ts`, `field-tickets.service.ts`, `checklist-assignments.service.ts`, `job-progress.service.ts`, `returned-ticket-correction.ts` | window guard | 18, 19, 20 | changes deliberately — new 409 after the window; terminal lock extends to checklists and attachments | DN-2 L13; PLAN | `git grep -ln 'RETURNED_CORRECTION_STEPS\|getTicketForEmployeeAction' -- apps/api/src` |
| 17 | `payroll-week-overlay.ts`, `payroll.service.ts`, `payroll.repository.ts`, `apps/web/.../payroll-week-entries.service.ts` | scheduled end | 18, 29 | overlay moves to business time; other three: stated nowhere — **Q8 (see note)** | DN-2 L18 for overlay | `git grep -ln 'completeTicketIfOpen\|ticketScheduledEnd\|scheduledEnd' -- apps packages` |
| 18 | Payroll-corrections / send-back "returned correction" path | write-grant order | 19 | returned correction checked first; new request refused while a send-back is open | PLAN risk only | same as row 16 |
| 19 | `@RequirePermission('payroll-admin', …)` routes: payroll controller ×8 edit, send-backs ×4 edit, flags ×3 view + 1 edit, corrections ×1 edit, `ticket-employee-time-overrides` ×1 edit | permission grant to Payroll Manager | 22 | **OPEN — Q6** | none | `git grep -n "RequirePermission('payroll-admin'" -- apps/api/src` (18 hits) |
| 20 | Notification scheduler and reminder log | cron / templates | 23 | extended | DN-2 L6, L14 | `git grep -ln 'NotificationReminderLog\|CRON_JOBS' -- apps/api/src` |
| 21 | `ActivityLogAction` consumers | new enum members | 24 | every `switch`/label map must handle new members — **not enumerated** | DN-2 L10 | `git grep -ln 'ActivityLogAction' -- apps/api/src` — **not run beyond migrations**; executor to run |
| 22 | Payroll job-day payload consumers (web payroll week entries) | `completedAt`, `completedLate` | 25 | additive | DN-2 L11 | not enumerated |
| 23 | Mobile Home buckets (`active-tickets-section.tsx`, `jobs.tsx`, `use-tickets.ts`, `tickets.mock.ts`, `ticket.contract.ts`) | `incomplete` bucket; `expiredWhere` redefined | 26 | changes deliberately | DN-2 L15; PLAN | `git grep -ln 'isFutureFieldTicket\|isPastFieldTicket' -- apps` |
| 24 | Mobile outbox ops | `X-Captured-At` | 28 | each queued op type carries a tag | DN-2 L17 | `sync/drain.ts` (PLAN) |

- **Surfaces with no existing behaviour in this area:** the edit-request table, `/payroll/late-tickets`, `TicketHoldoverService`, `day-start` endpoint. Established by name-grep for `TicketEditRequest` — **not run**; stated from the PLAN's "new" labels, which I did not check against the repo.
- **Consumers with no source for what happens to them:** rows 13, 15, 17 (non-overlay), 19, and the re-rostering effect of REQ-05 (Q8). Each is a §12 question.

## 11b. Developer decisions — structure is the developer's call

*The PLAN already records a design that Syed Haris decided in conversation. This section leaves _Chosen_ and _Decided by_ blank, per the elaborator's rules: a developer confirms each row here.*

| ID | Decision | Options (with existing code found) | AI note | Chosen | Decided by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | Where day start is stored | (a) two nullable columns + enum on `JobTicket` (PLAN/S2); (b) a row in an existing per-ticket step table (`ticket-time-entries`); (c) a new table | S2 names (a); one value per ticket with the ticket's lifecycle — a column fits the template rule. Plan also adds a CHECK both-null-or-both-set | (a) Two columns + enum on JobTicket | Syed Haris | 2026-10-15 |
| D2 | Day-start endpoint shape | `PATCH /field/tickets/:id/day-start` (PLAN) vs. a step-record call through `recordTicketStep` (`job-tickets.service.ts:793`) | PLAN chose the PATCH; offline queueing then needs a new outbox op | PATCH endpoint with new outbox op | Syed Haris | 2026-10-15 |
| D3 | Crane state: derive vs. store | derive from previous ticket (S1, no schema) vs. a stored column | S1 derives; the trade-off is Day N before Day N−1 syncs reads UNKNOWN | Derive, no schema change | Syed Haris | 2026-10-15 |
| D4 | Edit-request storage | new `TicketEditRequest` model (L11) vs. reuse of `PayrollSendBack`/`PayrollCorrection` models (`apps/api/src/service/payroll-send-backs/`, `.../payroll-corrections`) | SendBack/Correction have payroll-specific fields and lifecycle (week-linked). TicketEditRequest has its own lifecycle (window-linked, lazy expiry) and kinds. Reuse would conflate two domains. | New `TicketEditRequest` model | Syed Haris | 2026-10-15 |
| D5 | Business code for `TicketEditRequest` | prefixed code via `entity_sequences` vs. UUID-only (log-like row) | TicketEditRequest is internal infrastructure — never shown to users, never in customer docs or emails. UUID-only, like ActivityLog. | UUID-only, no business code | Syed Haris | 2026-10-16 |
| D6 | New exported services/helpers (§4 list) vs. extending existing | e.g. `ticket-write-window.util.ts` vs. extending `returned-ticket-correction.ts`; `TicketHoldoverService` vs. extending `job-holdover.service.ts`; new cron vs. adding to `notification-scheduled-jobs.service.ts` | New modules: holdover has distinct lifecycle from existing job-holdover (which is payroll flags); window guard is a new concern; cron adds to existing scheduled-jobs service (same pattern). | New modules per the plan; cron extends `notification-scheduled-jobs.service.ts` | Syed Haris | 2026-10-15 |
| D7 | Permission mechanism for the approver | seed `payroll-admin:edit` for Payroll Manager (L5) vs. a new narrower permission | Q6 resolved: PM gets everything | `payroll-admin:edit` for PM, no new permission | Syed Haris | 2026-10-16 |
| D8 | `ActivityLogAction` members vs. a free-form log | six new enum members (L10) | decided in L10 | Six new enum members | Syed Haris | 2026-10-15 |
| D9 | Web page file layout | `features/payroll-late-tickets/` (PLAN) vs. extending `features/payroll-returned-entries` | Separate concerns: late-tickets has its own tabs and approval flow. Modelled on returned-entries but independent. | New `features/payroll-late-tickets/` folder | Syed Haris | 2026-10-15 |
| D10 | Pattern | none in `patterns.md` fits | no `UNDECIDED` entry applies; flag to Haris to add one if holdover/late-ticket flow repeats | No pattern entry needed now | Syed Haris | 2026-10-16 |

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Decided by | Enumerated by |
| --- | --- | --- | --- | --- |
| Crew grouping / roster (re-plans PENDING and SENT tickets) | none | yes — U2 (DN-1 D5) | Syed Haris | `git grep -ln 'employeeTypeName' -- apps/api/src` |
| API submit guard `submit-step-guard.ts` | none | yes — U3 (D5) | Syed Haris | `git grep -ln 'submitStepGuard' -- apps/api/src` — not run |
| API labor writes (`ticket-labor-entries.*`) | none | yes — U3 (D5) | Syed Haris | `git grep -ln 'employeeTypeName' -- apps/api/src` |
| Web job-progress | none | yes — U5/H6 (D5, D9, S4) | Syed Haris | `git grep -ln 'derive-ticket-progress' -- apps/web apps/api/src` — not run |
| Mobile checklist fetch, prefetch, verify | none | yes — U4 (D5) | Syed Haris | `git grep -ln 'visibleFlowStepKeys' -- apps/mobile` |
| Payroll week overlay | none | yes — LT12 (L18) | Syed Haris | `git grep -ln 'payroll-week-overlay' -- apps` |
| `demo-flows.service.ts:871`, pay adder `LaborBody.tsx:175` | none | **no** — PLAN "Not changed" | Syed Haris | n/a |
| Returned-entries web list vs. late-tickets list | none | no — modelled on, not changed | Syed Haris | `git grep -ln 'returned-entries-list' -- apps/web/src` — not run |

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Nothing below is built until these are answered. Q1–Q4 were requested by name; Q5–Q8 are new and raised by this reading.

### Q1 — T1: does the Oiler-fills-the-shared-ticket rule still govern Operators?

- **Question:** When a set has an Oiler, does an Operator on that set complete, sign and submit nothing (the verified 2026-09-14 rule, Oiler enters their labor), or do Operators "complete their own tickets" as the provisional Teams answer says — and does the new 24h window and approval flow apply to the Operator separately?
- **Why it cannot be answered from what is written:** the verified 09-14 clause 2 says Operators have no complete/submit step; Melissa's provisional B3 answer says Operators complete their own (T1). DN-2 holds "the verified one-ticket rule still governs" and designs nothing for this case; L7 says "the worker" without naming whom that is for a folded Operator.
- **Blocked:** REQ-30; REQ-19 and REQ-26 for the Operator on an Oiler's ticket.
- **Candidates:** `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` (14.4 KB, `verified`, 2026-09-14); `decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md` (31.8 KB, `reference`, 2026-10-06) T1 at line 243; `field-ops/gaps.md:905` (existing entry, **cite, do not restate**).
- **Owner:** Melissa McNutt (T1 source), with Lisette Anzaldo for dispatch (named on the 09-14 note). Registered owner on the gaps entry: not re-read.
- **Workaround, if any:** build as the verified rule reads today. Labelled workaround, not a decision.
- **Status:** open

### Q2 — T12: an employee leaves with incomplete tickets

- **Question:** When a field employee is terminated or loses access with tickets still incomplete, who finishes them — payroll, dispatch, a supervisor — or are they cancelled, and does the worker's own window still apply?
- **Why it cannot be answered from what is written:** the provisional answer addressed offline capture, not this. FCC cancels or force-completes from the office (`unverified`). The verified 09-30 note says an abandoned ticket blocks payroll; DN-2 L7 allows only the worker and `payroll-admin` to complete.
- **Blocked:** REQ-31; nothing else.
- **Candidates:** `field-ops/gaps.md:927` (existing entry, cite); `field-ops/fcc-e-ticket-and-atom-guides.md` (unverified); `decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md` (7.6 KB, `verified`, 2026-09-30).
- **Owner:** Melissa McNutt, with Corrina Bustos for payroll (per the gaps entry).
- **Workaround, if any:** none. Do not build a departed-employee path.
- **Status:** open

### Q3 — T14: how strictly is the previous ticket enforced

- **Question:** When a worker's earlier ticket is incomplete or past its window, may they start the next one — warning only, soft block they can override, or hard block?
- **Why it cannot be answered from what is written:** BRS-TVL-004 and OD-001 name the three outcomes without choosing one; Melissa's answers set the window and approvals but not whether an overdue ticket stops the next.
- **Blocked:** REQ-32. REQ-07 keeps the existing date-order guard.
- **Candidates:** `field-ops/gaps.md:987` (existing entry, cite); `brs.md` (unverified); Melissa note T14.
- **Owner:** Melissa McNutt, with Lisette Anzaldo for dispatch (per the gaps entry).
- **Workaround, if any:** no gate beyond today's `isFutureFieldTicket` date-order guard. Labelled workaround.
- **Status:** open

### Q4 — D3: two Operator slots and no Oiler

- **Question:** With two Operator slots and no Oiler on a DAS set, do both Operators get FULL (today's behaviour) or should one be designated FULL and the other STANDARD?
- **Why it cannot be answered from what is written:** D1 gives an Operator slot FULL when the set has no Oiler; D3 says "not a real case" and keeps both FULL. No document addresses two Operator slots.
- **Blocked:** REQ-33; nothing (behaviour unchanged).
- **Candidates:** `field-ops/gaps.md:1032` (existing entry, filed 2026-10-15, cite); DN-1 D3; none: nothing else written.
- **Owner:** TCG field-ops owner, with Kyle Harlow (per the gaps entry).
- **Workaround, if any:** leave both FULL. Labelled workaround.
- **Status:** open

### Q5 — Home start versus the yard-to-yard paid-time boundary

- **Question:** On a Day 2+ ticket that starts from Home (no Left Yard, no Driving), when does paid time begin — at Arrive Job, at the shift start, or as today (yard-to-yard)? And do STANDARD 3rd man and Rigger tickets, which now use the payroll engine's fallback meal schedule (D10), need payroll's acceptance?
- **Answer (Haris, 2026-10-16):** Home-start holdover days: paid time = Arrive Job Site to Left Job Site (no yard step, so yard-to-yard does not apply). STANDARD ticket meal fallback ships as-is without payroll sign-off.
- **Unblocked:** REQ-09, REQ-15, REQ-02.
- **Note:** This is a pay-rule change for Home-start holdover days. The `WORK_TIME` entry on those days starts at `arriveJob` and ends at submit (or at `leftJob` for STANDARD). A provenance entry in `payroll/payroll-rules-provenance.md` is required per `contexts/payroll-engine.md`.
- **Status:** resolved

### Q6 — Payroll Manager gains `payroll-admin:edit`: is the wider reach intended?

- **Question:** Granting Payroll Manager `payroll-admin:edit` also opens the 18 existing `payroll-admin` routes (payroll controller approve/export-type routes, send-back close, flags edit, time overrides) to that role; the 2026-10-13 PM/PA split gave those to Payroll Admin only. Is that intended, or should approving late edits use a narrower permission?
- **Answer (Haris, 2026-10-16):** PM gets everything. Keep L5 as-is — PM gains all `payroll-admin:edit` routes.
- **Unblocked:** REQ-22; LT3.
- **Status:** resolved

### Q7 — Which role seat or code does `TicketEditRequest` carry, and what kinds does it hold?

- **Question:** Besides `SUBMITTED_EDIT`, what is the other request kind's name, and does the request carry a business code (Identity Convention) or only a UUID?
- **Answer (resolved from the plan, 2026-10-16):** Two kinds: `LATE_COMPLETION` (worker requests to complete a ticket after the 24h window) and `SUBMITTED_EDIT` (worker requests to edit a COMPLETE ticket). No business code — `TicketEditRequest` is internal infrastructure, referenced by UUID only. It is never surfaced as a code to users or in customer documents, so the Identity Convention does not apply.
- **Unblocked:** REQ-21, REQ-24.
- **Status:** resolved

### Q8 — What should the other readers of open `YARD_TIME`, and the already-planned tickets, do?

- **Question:** For holdover middle days, S3 exempts three payroll flags. What should the other 17 readers of open `YARD_TIME` do, what should the payroll overlay's other callers do with the new scheduled-end rule, and what should happen to PENDING/SENT tickets that crew re-grouping re-plans?
- **Answer (resolved from the plan, 2026-10-16):** Ship only the three flag exemptions (S3) and the overlay change (L18). Other `YARD_TIME` readers are left untouched — they read closed time entries, not open ones, so holdover middle days (which have no `YARD_TIME` at all on Home-start, or a normal closed one on Yard-start) do not false-positive there. Re-rostering: crew-grouping re-plans only PENDING and SENT tickets, which have no recorded steps and no time entries — safe. The executor checks each reader during H5 and confirms no false positive. If one is found, it becomes a finding.
- **Unblocked:** REQ-15, REQ-18/29, REQ-05.
- **Status:** resolved

### Q9 — `JobTicket.completedAt`: backfill rule and how a legacy ticket reads

- **Raised by:** decomposer, 2026-10-16, while slicing LT2/LT5/LT11 (`units.md`).
- **Answer (resolved, 2026-10-16):** (a) Backfill: for COMPLETE tickets, use the most recent `ActivityLog` row with entity `JOB_TICKET` and action `STATUS_CHANGED` where the `changes` JSON shows `status → COMPLETE`. If no such row exists, use the ticket's `updatedAt`. (b) NULL `completedAt` means the ticket is not yet completed — it is neither late nor not-late; it is open. The late flag only applies when `completedAt` is non-null.
- **Unblocked:** LT2 backfill, LT11 late flag.
- **Status:** resolved

### Q10 — Which `ActivityLogAction` records an accepted late-captured offline op?

- **Raised by:** decomposer, 2026-10-16, while slicing LT4 (`units.md`).
- **Answer (resolved, 2026-10-16):** Add a seventh member: `TICKET_LATE_CAPTURE_ACCEPTED`. Written when the server accepts an op whose `capturedAt` is inside the window but `arrivedAt` (server clock) is after the window. The `changes` JSON records `capturedAt`, `arrivedAt`, the step key and the window end.
- **Unblocked:** LT4 audit row for REQ-28. LT2 adds the member with the other six.
- **Status:** resolved

### Q11 — LT4 enforces the window on merge, before any way to request exists

- **Raised by:** decomposer, 2026-10-16, while sequencing Part 3 (`units.md`).
- **Answer (resolved, 2026-10-16):** Hold LT4's PR open until LT6 is merged. No flag needed — stacked PRs handle this naturally. LT4 targets LT2's branch; when LT2 merges, GitHub retargets LT4 to main. The merge order is: LT2 → LT5 → LT6 → then LT4 can merge. This is a merge-order constraint, not a structural change.
- **Unblocked:** LT4 merge timing.
- **Status:** resolved

### Q12 — Do cancelled sub-job days count toward "Day d of D"?

- **Raised by:** executor, 2026-10-16, while building H2 (`TicketHoldoverRepository.findOpenDays`).
- **Question:** When computing "Day d of D" for a holdover ticket, does the day total D include sub-job days that were cancelled (`SubJob.dasStage = CANCELLED`) or whose schedule interval is inactive? REQ-07 says "one ticket per day, opened in date order" and that "a missing day counts as the last day", but neither it nor DN-1 states whether a cancelled middle day still occupies a day number.
- **Why it cannot be answered from what is written:** the spec gives the missing-day rule for the current ticket's own index, not the composition of the day set D is measured against.
- **Workaround, if any (what H2 built, labelled):** `findOpenDays` excludes cancelled sub-jobs and inactive intervals, matching `JobHoldoverRepository.countWorkingDays` (the existing DAS working-day count). So a cancelled middle day shrinks D and does not consume a day number. Reversible — read-only, no stored value. If the intended behaviour is to keep cancelled days in D, change the `findOpenDays` where-clause only.
- **Blocked:** nothing — H2 ships with the workaround above.
- **Status:** open

### Q13 — How do the write-path services detect holdover without a circular dependency?

- **Raised by:** executor, 2026-10-16, while building H4 (End Work boom-close, break-down mirror-skip, submit-guard holdover wiring).
- **Question (structural — developer's call):** `JobTicketsService.recordTicketStep` / `.submitTicket` and `TicketBreakdownsService.recordComplete` must know a ticket's holdover status (and, for the submit guard, its full `TicketHoldoverContext` — `dayNumber`, `isLastDay`, `dayStartFrom`). The natural resolver is `TicketHoldoverService.resolveForTicket` (usecase, `apps/api/src/usecase/field-tickets/ticket-holdover.service.ts`), but that service already imports `JobTicketsService`, so injecting it back creates a module cycle. Which approach?
  - **Option A — `forwardRef`-inject `TicketHoldoverService`** into `JobTicketsService` + `TicketBreakdownsService`. Reuses `resolveForTicket`/`buildContext` (DRY; `resolveForTicket` returning `undefined` is the "not held" answer for the boom-close and mirror-skip too). Cost: a `forwardRef` cycle (3 precedents in the repo: `payroll.module.ts`, `notifications.module.ts`, `users.module.ts`).
  - **Option B — bare-inject `TicketHoldoverRepository`** (service layer, `apps/api/src/service/job-holdover/ticket-holdover.repository.ts`) into both services. Cycle-free and matches the dominant house pattern (`JobTicketsModule` already injects `TicketTimeEntriesRepository` bare for exactly this reason; `field-tickets.module.ts` injects `TicketHoldoverRepository` bare). Cost: the submit guard needs `dayNumber`/`isLastDay`, which `buildContext` derives from `findOpenDays` + `dayIndexOf` — reproducing that in `JobTicketsService` duplicates `TicketHoldoverService.buildContext`.
- **AI recommendation (not a decision):** Option A — it reuses the one derivation and keeps `dayNumber`/`isLastDay` logic in a single place; `forwardRef` is an accepted pattern here. A developer chooses.
- **Decision (Haris, 2026-10-16, delegated to the AI recommendation):** **Option C — pure extract.** Pull `buildContext`'s derivation into a pure function in `usecase/job-tickets/ticket-holdover.ts` (the existing pure module) that takes the already-fetched days and previous-day tickets and returns the `TicketHoldoverContext` (plus `previousDayCrane`). `TicketHoldoverService.buildContext` (H2) is refactored to call it. `JobTicketsService` and `TicketBreakdownsService` inject the **bare** `TicketHoldoverRepository` (cycle-free, matches the house pattern) and call the same pure function. No module cycle, no `forwardRef`, no duplicated derivation. This is strictly better than both A (avoids the `forwardRef` smell) and B (no duplicated orchestration).
- **Status:** resolved

### Q14 — Exact copy for the holdover crane-state line on ticket details

- **Raised by:** executor, 2026-10-16, while building M1 (`ticket-details.tsx` crane-state line, REQ-07).
- **Question (product copy):** REQ-07 / DN-1 H2 require ticket details to show "a crane-state line", and DN-1 S1 decides the four states (`NOT_SET_UP`, `LEFT_SET_UP`, `BROKEN_DOWN`, `UNKNOWN`), but no source gives the user-facing wording for each. What exactly should the line read per state, and should it carry an icon?
- **Why it cannot be answered from what is written:** DN-1 names the enum members and §13 already states exact holdover UI copy is unspecified; the line is a named REQ-07 deliverable, so M1 must render something.
- **Workaround, if any (what M1 built, labelled):** a provisional label map in `ticket-details.tsx` (`CRANE_STATE_LINE`) mirroring DN-1 S1's own phrasing — "Crane: not set up", "Crane: left set up yesterday", "Crane: broken down yesterday", "Crane: state unknown". Reversible — strings only, one map, no stored value. Change the map when the copy is decided.
- **Blocked:** nothing — M1 ships with the workaround above.
- **Status:** open

### Q15 — Exact copy for the Day 2+ day-start card and its Yard / Home choices

- **Raised by:** executor, 2026-10-16, while building M2 (`holdover-day-start-card.tsx`, REQ-09).
- **Question (product copy):** REQ-09 requires the worker to answer "Where are you starting from?" on a holdover Day 2+ ticket, with a Yard and a Home option, but no source gives the card's heading, its explanatory body, or the two button labels. What should each read, and should the choices carry icons?
- **Why it cannot be answered from what is written:** DN-1 S2 names only the two values (`YARD`, `HOME`); §13 states exact holdover UI copy is unspecified; the card is a named REQ-09 deliverable, so M2 must render something.
- **Workaround, if any (what M2 built, labelled):** provisional copy in `holdover-day-start-card.tsx` — heading "Where are you starting from?", body "Choose where today begins. This decides your steps, so the ticket stays locked until you answer.", buttons "The yard" (`truck` icon) and "Home" (`home` icon). Reversible — strings/icons only, no stored value. Change when the copy is decided.
- **Blocked:** nothing — M2 ships with the workaround above.
- **Status:** open

### Q16 — End Work summary work-time basis when `arriveJob` is absent

- **Raised by:** executor, 2026-10-16, while building M4 (`end-work-summary.ts`, REQ-11 H3).
- **Question:** H3 says the summary's work-time row starts at `arriveJob`. `arriveJob` is a tracked step recorded before End Work in the holdover flow, so it is present in practice — but no source states what the row should show in the degenerate case where End Work is reached with no `arriveJob` timestamp. Show nothing (hide the card), or fall back to another instant?
- **Why it cannot be answered from what is written:** REQ-11/H3 fix the normal basis (`arriveJob`) but not the empty state; §13 does not cover it.
- **Workaround, if any (what M4 built, labelled):** `readWorkStart` falls back to the boom start (`startWork.startedAt`) when `arriveJob` has no timestamp; if neither exists the summary is `null` and the card is not rendered. Reversible — one helper, no stored value. Change when the empty-state rule is decided.
- **Blocked:** nothing — M4 ships with the workaround above.
- **Status:** open

### Q17 — Exact copy for the holdover Start Work card and its Build Up choices

- **Raised by:** executor, 2026-10-16, while building M5 (`holdover-start-card.tsx`, REQ-12).
- **Question (product copy):** on a held day the Start Work card replaces the build-up card (REQ-12), but no source gives the card's heading, its explanatory body, the single "Start Work" button label (START_WORK / crane left set up), or the "Start Build Up" / "Skip Build Up" button labels (CHOOSE / previous crane state unknown). What should each read, and should the buttons carry icons?
- **Why it cannot be answered from what is written:** DN-1 H4/H6 give only the behaviour (one tap starts work; unknown offers Start or Skip Build Up); §13 states exact holdover UI copy is unspecified; the card is a named REQ-12 deliverable, so M5 must render something.
- **Workaround, if any (what M5 built, labelled):** provisional copy in `holdover-start-card.tsx` — heading "Start Work"; START_WORK body "The crane was left set up yesterday. Tap to start work — no build up needed today." with one "Start Work" button (`play` icon); CHOOSE body "The crane stayed on site overnight. Build it up again, or skip straight to work if it is ready." with "Start Build Up" (`plus` icon) and "Skip Build Up" (`play` icon). Reversible — strings/icons only, no stored value. Change when the copy is decided.
- **Blocked:** nothing — M5 ships with the workaround above.
- **Status:** open

### Q18 — Exact copy for the end-of-day holdover crane sheet

- **Raised by:** executor, 2026-10-17, while building M6 (`end-work-holdover-sheet.tsx`, REQ-13).
- **Question (product copy):** after End Work on a non-last holdover day the crew choose "Leave crane set up" or "Start Breakdown" (REQ-13), but no source gives the sheet's title, its explanatory body, or the two button labels, nor whether the choices carry icons.
- **Why it cannot be answered from what is written:** DN-1 H5 gives only the two choices and the last-day rule; §13 states exact holdover UI copy is unspecified; the sheet is a named REQ-13 deliverable, so M6 must render something.
- **Workaround, if any (what M6 built, labelled):** provisional copy in `end-work-holdover-sheet.tsx` — title "End of day — the crane"; body "Work time has ended. Is the crane being left set up for tomorrow, or torn down today?"; a secondary "Leave crane set up" button (`check` icon) and a primary "Start Breakdown" button (`stop` icon). Reversible — strings/icons only, no stored value. Change when the copy is decided.
- **Blocked:** nothing — M6 ships with the workaround above.
- **Status:** open

### Q19 — "Start Breakdown" navigation and End Work completion ordering on a holdover ticket

- **Raised by:** executor, 2026-10-17, while building M6 (`EndWorkBody.tsx`, REQ-13).
- **Question (structural — developer's call):** REQ-13 says "Start Breakdown" opens "the existing break-down flow", which lives on the Start Work step (`StartWorkBody` break-down card). The spec does not state what "Start Breakdown" does to the End Work step: does it complete End Work first, and how does the crew return to the Final Signature after recording the teardown on a step they already passed? M6 builds the lowest-risk reading and this should be confirmed.
- **Why it cannot be answered from what is written:** the FULL holdover step order is startWork → endWork → sig2 (`packages/shared/.../ticket-flow-steps.ts`), with no break-down step; the break-down card sits on startWork, which is before endWork. DN-1 H5 / REQ-13 describe the choice, not the navigation or completion ordering.
- **Workaround, if any (what M6 built, labelled):** "Start Breakdown" calls `router.push('/(field)/ticket/step/startWork')` and does **not** complete the End Work step; the End Work capture stays recorded in the draft, and the break-down card is live there (it stays live once work has ended with no break-down yet — `StartWorkBody.breakdownLockedByEnd`). "Leave crane set up" completes End Work and continues to the Final Signature. Reversible — navigation/handlers only, no stored value. Change when the intended ordering is decided.
- **Blocked:** nothing — M6 ships with the workaround above.
- **Status:** open

### Q20 — The "closing-soon" threshold for the completion-window state

- **Raised by:** executor, 2026-10-17, while building LT1 (`utils/ticket-completion-window.ts`, REQ-18).
- **Question (product value):** `ticketCompletionWindow` reports a three-way state `open` / `closing-soon` / `closed` (units.md LT1, acceptance). The 24h window end (`closed`) and the [12, 20]h reminder offsets are specified; the hour at which the state becomes `closing-soon` is not. When does `closing-soon` begin?
- **Why it cannot be answered from what is written:** REQ-18 and DN-2 L2/L11 fix only the 24h window; REQ-23 fixes the reminders at +12h/+20h. No source names a `closing-soon` boundary, yet LT1's acceptance requires the three states.
- **Workaround, if any (what LT1 built, labelled):** `CLOSING_SOON_FROM_HOURS = max(REMINDER_OFFSET_HOURS) = 20` — `closing-soon` begins at the last reminder offset (the final 4h before close), tying it to a value the spec does give. One named constant; change it if the answer differs. Reversible — no stored value, consumed by no shipped unit yet (LT10/LT15 later).
- **Blocked:** nothing — LT1 ships with the workaround above; LT10/LT15 (the consumers) can adjust when answered.
- **Status:** open

### Q21 — `TicketEditRequest.requestedBy` / `decidedBy`: which model, and the FK on-delete rules?

- **Raised by:** executor, 2026-10-17, while building LT2 (`schema.prisma`, REQ-21).
- **Question (structural — developer's call):** §3 leaves the requester / decider relation targets `NOT SPECIFIED`, and the slice-contents table says "the executor proposes, the developer decides." The request is raised by a worker in-app and decided by a `payroll-admin:edit` holder. Which model do `requestedById` and `decidedById` reference — `User` (the authenticated actor) or `Employee` (the roster person)? And what on-delete behaviour?
- **Why it cannot be answered from what is written:** REQ-21 names the fields (`requestedBy`, `decidedBy`) but no source states the target model.
- **Decision (Haris, 2026-10-17, via the AI driving the loop):** `requestedBy → User` (`onDelete: Restrict`, non-null) and `decidedBy → User?` (`onDelete: SetNull`, nullable), as LT2 built. Both the in-app worker and the `payroll-admin:edit` approver act as authenticated `User` sessions, and this is an actor/audit reference, so `User` is the correct target — matching the `QuotationApprovalRequest.requestedBy → User` / `resolvedBy → User?` precedent. No other target is sensible.
- **Status:** resolved

### Q22 — Does a bare resubmit of a COMPLETE ticket (no approved edit) 409, or stay idempotent?

- **Raised by:** executor, 2026-10-17, while building LT5 (`job-tickets.service.ts` submit + `ticket-write-window.util.ts`, REQ-20).
- **Question (product value / behaviour):** REQ-20 says "submitting locks the ticket at once; editing a COMPLETE ticket goes through the request flow." That fixes what happens to an *edit* (step / checklist / attachment write) after submit — now 409 `COMPLETE_LOCKED`. It does **not** say what happens to a *resubmit* of an already-COMPLETE ticket with no open approved edit request: a replayed or double-tapped submit from the offline outbox. 409, or an idempotent 200?
- **Why it cannot be answered from what is written:** REQ-20 / DN-2 L4 only cover the lock on edits and the resubmit-under-approval re-queue; the double-submit case is the pre-existing SCRUM-OFFLINE-SYNC U7 idempotency path, which this spec never revisits.
- **Decision (resolved at review, 2026-10-19):** a bare resubmit of an already-COMPLETE ticket with no open approved edit request is **idempotent** (success, no 409). The review fix (lt-series `066e07a07`) makes a `submit` on a COMPLETE ticket bypass the window guard so it reaches the idempotent COMPLETE early-return — a replayed/double-tapped offline submit after the window no longer 409s. The write path for a genuine edit stays locked (`COMPLETE_LOCKED` unless a live `SUBMITTED_EDIT`), and the SUBMITTED_EDIT resubmit re-queue (LT5) is preserved. This keeps offline-outbox idempotency (SCRUM-OFFLINE-SYNC U7).
- **Status:** resolved

### Q23 — Edit-request `reason`: is it required to be non-empty, and what is the length cap?

- **Raised by:** executor, 2026-10-17, while building LT6 (`create-ticket-edit-request.dto.ts`, REQ-21).
- **Question (product value):** §10 and the slice-contents table both mark the edit-request `reason` as "one reason; `NOT SPECIFIED` — no source states a limit or whether it is required to be non-empty." The DB column is `reason String @db.Text` (non-null, no cap). What should the API DTO enforce — may the reason be blank, and what is the maximum length?
- **Why it cannot be answered from what is written:** no source states a minimum or maximum for the reason text.
- **Workaround, if any (what LT6 built, labelled):** `reason` required, `@IsNotEmpty()`, `@MaxLength(1000)` — mirroring the house approval DTO (`ResolveApprovalDto.note`, 1000). Change the one `@MaxLength` and drop `@IsNotEmpty` if the answer differs; no stored state depends on it.
- **Blocked:** nothing — LT6 ships with the workaround above.
- **Status:** open

### Q24 — Incomplete-ticket reminder scan: how far back should the cron look?

- **Raised by:** executor, 2026-10-17, while building LT8 (`notification-scheduled-jobs.service.ts`, REQ-23).
- **Question (engineering bound, surfaced as product):** the +12h/+20h reminders are anchored on a ticket's scheduled end, which is computed (not stored), so the cron scans incomplete tickets by schedule-interval date and computes each end in memory. The scan must be bounded. How many days of incomplete tickets should it reconsider each run?
- **Why it cannot be answered from what is written:** REQ-23 fixes only the [12, 20]h offsets; no source bounds the scan. A ticket's two reminders both fire within ~20h of its scheduled end and `NotificationReminderLog` prevents a re-fire, so a short lookback suffices for normal operation — the only thing a longer lookback buys is catch-up after a multi-day cron outage.
- **Workaround, if any (what LT8 built, labelled):** `TICKET_WINDOW_REMINDER_LOOKBACK_DAYS = 4`. One named constant; no stored state depends on it. Raise it only if the cron can be down longer than four days and missed reminders must still fire.
- **Blocked:** nothing — LT8 ships with the workaround above.
- **Status:** open

### Q25 — Do +12h/+20h reminders fire on a ticket Payroll closed on the crew's behalf?

- **Raised by:** executor, 2026-10-17, while building LT8 (`notification-scheduled-jobs.service.ts`, REQ-23).
- **Question (product value):** a payroll-only closure (`payrollClosedAction`, PAYROLL-FLAGS REQ-06) never touches `status` and leaves `completedAt` null, so by the literal "incomplete = `completedAt` null and status not COMPLETE" such a ticket would still be reminded — nagging a worker to finish a ticket Payroll already closed for them. Should a payroll-closed ticket be excluded from the reminders?
- **Why it cannot be answered from what is written:** REQ-23 says "while the ticket is still incomplete" and no source states whether a payroll-closed-but-not-completed ticket counts as incomplete for reminders.
- **Workaround, if any (what LT8 built, labelled):** the reminder scan filters `payrollClosedAction: null`, so a payroll-closed ticket gets no reminder. One `where` clause; reversible. The same scan also excludes CANCELLED / REJECTED tickets (status filter is `PENDING / SENT / IN_PROGRESS` only).
- **Blocked:** nothing — LT8 ships with the workaround above.
- **Status:** open

### Q26 — Incomplete-card copy and the countdown display format

- **Raised by:** executor, 2026-10-19, while building LT16 (`incomplete-ticket-card.tsx`, `edit-request-sheet.tsx`, REQ-26).
- **Question (product copy):** REQ-26 names the four card states and the "Request approval" / "Waiting for approval" labels are given, but no source gives: the countdown's label and format (how long is left to complete, and the approved-window variant), the "window closed" line shown beside the Request approval button, the LOCKED fallback line, or the edit-request sheet's title, intro body and refusal (409) banner text. Each is a named REQ-26/REQ-21 deliverable, so LT16 must render something.
- **Why it cannot be answered from what is written:** §13 states exact copy for any late-ticket screen beyond the names in the notes is unspecified; DN-2 L15 gives only the states.
- **Workaround, if any (what LT16 built, labelled):** provisional copy — countdown "`Xh YYm` left to complete" (open window) and "Approved · `Xh YYm` left" (4h window), both via the existing `formatDurationHoursMinutes`; "Completion window closed" beside the Request approval button; "Locked by payroll" for the LOCKED fallback; sheet title "Request approval for ticket #<code>", intro "The completion window has closed. Tell payroll why you need to finish this ticket, and they can grant a short window to do it.", refusal banner "Could not send your request — it may already be waiting for approval." Reversible — strings/format only, no stored value. Change when the copy is decided.
- **Blocked:** nothing — LT16 ships with the workaround above.
- **Status:** open

### Q27 — Is the client `X-Captured-At` header trusted as-is, or bounded?

- **Raised by:** reflector, 2026-10-19, from the LT analyst verdict (security finding).
- **Question (product + security):** REQ-28 has the server accept an op "captured before the window ended and arriving within 72h", judged on the client-supplied `X-Captured-At`. A forged header lets a client push a write past the window. Accept the risk (as S5 did for last-day break-down), or bound it (reject a `capturedAt` earlier than the device's last authenticated sync, or later than server now, or cap by a server-stamped enqueue receipt)?
- **Why it cannot be answered from what is written:** REQ-28 and DN-2 L17 state the happy path only; no threat model or accepted-risk line exists for it.
- **Blocked:** nothing; LT4 ships with the header trusted.
- **Candidates:** `apps/api/src/usecase/job-tickets/ticket-write-window.util.ts` (`parseCapturedAtHeader`); DN-2 L17.
- **Owner:** TCG field-ops owner with Haris (security call).
- **Workaround, if any:** header trusted (as built). Labelled workaround.
- **Status:** open

### Q28 — Which employee's ticket is "the previous ticket" when a slot line is shared?

- **Raised by:** reflector, 2026-10-19, from the H analyst verdict (`matchPreviousTicket`).
- **Question:** REQ-10 derives previous-day crane state from the previous day's ticket. When two employees share one slot line (e.g. a swapped-in Operator), is the match key the slot line, the asset group, or the employee?
- **Why it cannot be answered from what is written:** REQ-10 / DN-1 S1 say "previous-day ticket" without a match key for a shared slot line.
- **Blocked:** nothing; built with slot-line match.
- **Candidates:** REQ-10; DN-1 S1; Q12 (related day counting).
- **Owner:** TCG field-ops owner.
- **Workaround, if any:** slot-line match as built, may pick the wrong employee's ticket. Labelled workaround.
- **Status:** open

### Q29 — What does the submit guard do on a ticket with no `slotTypeName`?

- **Raised by:** reflector, 2026-10-19, from the H analyst verdict, and U4 `getTicketTotal(undefined)`.
- **Question:** When the slot type is absent (legacy or hand-made ticket), what step list and holdover requirements apply: the old 14-step flow, the slot-less default per employee type, or no guard? Today the submit guard ignores holdover and `getTicketTotal(undefined)` returns 14, wrong for a non-Oiler with no `stepFlow`.
- **Why it cannot be answered from what is written:** REQ-01 / REQ-04 define behaviour for a ticket with a slot only.
- **Blocked:** nothing; both are analyst follow-ups.
- **Candidates:** REQ-01, REQ-04, REQ-08; U4 and H4 analyst verdicts.
- **Owner:** TCG field-ops owner.
- **Workaround, if any:** as built (fallback 14; guard skips holdover). Labelled workaround.
- **Status:** open

## 13. What this spec deliberately does not specify

- Who completes an Operator's labor when an Oiler is on the set under the new window flow — no source; Q1, REQ-30.
- Departed-employee tickets — no source; Q2, REQ-31.
- Whether an earlier overdue ticket gates the next one — no source; Q3, REQ-32.
- Two Operator slots and no Oiler — behaviour unchanged; Q4, REQ-33.
- _(resolved)_ Q5: Home-start paid time = Arrive Job to Left Job. STANDARD meal fallback ships as-is.
- _(resolved)_ Q6: PM gets all `payroll-admin:edit` routes.
- _(resolved)_ Q7: Two kinds: `LATE_COMPLETION` and `SUBMITTED_EDIT`. No business code.
- _(resolved)_ Q8: Ship only the three flag exemptions and overlay change; other readers untouched.
- The exact last-day holdover key order (described, not listed, in DN-1) — REQ-08 note.
- Exact UI copy for any holdover or late-ticket screen beyond the names in the notes.
- Validation limits (`reason` length, etc.).
- Whether the three overridden field-ops documents are right — they are unverified, the conflict stub stays open, and DN-1 does not verify or supersede them.
- The 2026-10-06 Melissa provisional note is superseded in practice by DN-1/DN-2, but its status is unchanged; TCG ratification is outstanding for both decision notes.

## 14. Sign-off before build

- [ ] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person (REQ-30..33)
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` (REQ-03: DN-1 exists; it records a developer direction and does not verify the FRDs — confirm that is sufficient)
- [ ] Answers written back into `spec.md` with their new sources and flags
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [ ] Every §11a ripple row has a source for what happens to that consumer, or a §12 question (rows 13, 15, 17, 19)
- [ ] Every §11b row has _Chosen_ and _Decided by_ filled by a developer
- [ ] Every §11c sibling has a developer's yes / no / follow-up
- [ ] Both decision notes committed to the overlay (they are untracked today)
- [ ] The PLAN's content that no note carries (REQ-14 mirror-skip, day-start rules, window-guard modes) is recorded in the vault or accepted as plan-only
- [ ] Decomposed into vertical units — `units.md`

Answered by: ______________  Date: ______________

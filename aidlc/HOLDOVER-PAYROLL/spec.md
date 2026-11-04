# Spec — HOLDOVER-PAYROLL Payroll honours holdover: window math, review batch, correction editor

> Written by the elaborator (`.ai/aidlc/agents/inception/tcg-elaborator.md`) from `intent.md`
> beside it. No Jira/Linear ticket exists (internal change); the intent is the developer's plan.
>
> **Update 2026-10-26:** the owner answered Q1–Q3 (option B; payable = Start Work → End Work; option A). REQ-02/03/04 are rewritten below and §12 has no open question. The "Read first" caveats still apply.
>
> **Read first — source status.** This is a pay-rule change and the elaborator ran at Sonnet tier.
> Escalate to Opus before decomposing (elaborator → *Model tier*: payroll ticket). Three things to
> spot-check against their cited source: REQ-02's only source is the developer's plan (no vault or
> decision note says the precedence); REQ-03 rests on a verified decision whose own body names two
> different paid-window ends (see Q2); REQ-09's claim that "the window-math fix stops" three flags
> is true of one of them only (see REQ-07 Finding F1).
>
> **Size.** 9 requirements, over the ~8 / ~6-unit guideline. The four Parts are separable and
> stack cleanly; a split is proposed in §13. The caller asked for one folder, so one spec is written.

Short names used below:

- **PLAN** = `.ai/aidlc/HOLDOVER-PAYROLL/intent.md` §3 — `[UNVERIFIED]`, kind: plan (developer
  direction, 2026-10-26; no decision note yet). Nothing in it is `[VERIFIED]`.
- **TF-SPEC** = `.ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/spec.md` — `[UNVERIFIED]`, kind: ticket spec
  (107 KB). **Provisional**: it records developer decisions, none ratified by TCG. Cited by REQ and Q id.
- **DN-1** = `decisions/2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md` —
  `[UNVERIFIED]` (`status: reference`), 10.2 KB, 2026-10-15.
- **DEC-HOME** = `decisions/2026-10-16-home-start-holdover-paid-time-boundary.md` — `[VERIFIED]`
  (`status: verified`), 2.5 KB, 2026-10-16, Syed Haris.
- **DEC-YARD** = `decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md` — `[VERIFIED]`,
  12.2 KB, 2026-09-03, Kyle Harlow / Joe Schacatano. Has no holdover exception.
- **GAP-HO2** = `payroll/gaps.md` → *Holdover days 2+ — does paid time start on arrival at the job
  site, and where does each day end?* (read by section, `grep -n '^## '`; the file is 605 KB) —
  status "partially resolved".

## Fill rules

(Unchanged from `.ai/aidlc/templates/spec.md`: `NOT SPECIFIED`, `N/A — <reason>`,
`OPEN — <question>`; no section or field is deleted.)

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `HOLDOVER-PAYROLL` (named folder) — Trello #108 (`p2FpbQZw`), "Payroll: update the Payroll module for the holdover changes", list In Progress, assignee Ali. The card is a one-liner with no comments or attachments; scope comes from the related cards in §11 |
| Intent | `.ai/aidlc/HOLDOVER-PAYROLL/intent.md`, captured 2026-10-26 |
| Elaborated on | 2026-10-26 |
| Vault state at elaboration | not counted (no full-vault read); six `domain/` files verified; `decisions/` notes with `status: verified` also treated as verified; `payroll/gaps.md` is 605 KB — only the holdover, subsistence and 24-hour sections were read |
| Open questions raised by this spec | 0 blocking; 2 non-blocking dependency notes (Q12, Q13) — Q1–Q3 answered by the owner 2026-10-26; Q4–Q11 recorded from the plan; all in §12 |
| Already-shipped behaviour reached | 14 consumers in §11a; none without a source (Q3-A answered); the rest are decided in the plan or are build-time confirmations |
| Rules consulted | `.ai/claude/contexts/api.md`, `prisma.md` (no schema change — read for the no-migration conclusion), `web.md`, `payroll-engine.md`, `patterns.md`, root `CLAUDE.md` |

Repo facts verified by reading on 2026-10-26 (not taken from the plan): `FieldTicketHoldover` shape
(`packages/shared/src/constants/ticket-holdover.ts`); `PayrollJobDayInput` has no holdover field
(`packages/payroll-engine/src/types.ts:87`); `buildJobDay` prices the window
`member.workStartedAt ?? times.payableWindow.start` / `…End`, where `payableWindow` is the raw
`WORK_TIME` row (`pay-week-assembly.ts:509-510`, `derive-ticket-times.ts:311`); `WORK_TIME` runs
Start Work → Review & Complete (`ticket-step.constants.ts:41,73,77`); REQ-15's three exemptions are
already shipped (`holdoverMidDay`, `payroll.service.ts:376-411,678-715`); `plan-correction.ts` defines `setWindow` at line 129 and calls
`setWindow(YARD_TIME, leftYard, arrivedYard)` at line 170 (it adds a row when none exists and a start is given, and throws when only an end is given; the plan's "133-143" range sits inside `setWindow`); `PayWeekAssembler` is constructed in `payroll.service.ts:356` and
`payroll-week-pricing.service.ts:50`.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Engine input carries holdover, sourced from the ticket's server-side holdover | api, engine | `[UNVERIFIED]` | PLAN; TF-SPEC REQ-07; DN-1 H1 | no |
| REQ-02 | Holdover paid-window END: break-down end → boom end → build-up end, any holdover day | api | `[UNVERIFIED]` (resolved by owner, Q1-B) | PLAN; owner answers 2026-10-26 | no |
| REQ-03 | Home-start days: no yard leg; payable Start Work → End Work (End Work per REQ-02) | api | `[UNVERIFIED]` (owner Q2 supersedes part of DEC-HOME) | owner answer Q2; DEC-HOME (partly superseded) | no |
| REQ-04 | Reach of the chain: every non-Home-start holdover day; recorded break-down end on any day | api | `[UNVERIFIED]` (resolved by owner, Q1-B) | owner answer Q1; GAP-HO2 | no |
| REQ-05 | PAY-049 per-day subsistence deferred; worked-day `subsistenceHoldover` unchanged | api, vault | `[UNVERIFIED]` | PLAN; `payroll/gaps.md`; PAY-049 | no |
| REQ-06 | Holdover batch (display only) on the employee timesheet; count badge on the worklist | api, web | `[UNVERIFIED]` | PLAN; TF-SPEC REQ-07/REQ-09 | no |
| REQ-07 | Payroll flags on holdover: window math plus build-time confirmation, no new detector | api | `[UNVERIFIED]` | PLAN; TF-SPEC Q8, REQ-15 | no |
| REQ-08 | Correction editor hides yard fields on a Home-start holdover day | web | `[UNVERIFIED]` | PLAN; DEC-HOME; 2026-10-22 note | no |
| REQ-09 | Correction API never creates a yard leg, does not enforce the yard chain, derives Home-start itself | api, web | `[UNVERIFIED]` | PLAN; DEC-HOME | no |

Counts: 9 total — 0 verified, 9 unverified, 0 conflicted, 0 open. REQ-03 was `[VERIFIED]` on DEC-HOME alone; the owner's Q2 answer (relayed, no decision note yet) now sets its payable boundary, so it carries the worse tag until `tcg-scrum` records a note. No requirement blocks on a question; remaining gates are the decision note + G4 provenance and D3 (G5).

## 2. Requirements

### REQ-01 — Engine input carries holdover, sourced from the ticket's server-side holdover `[UNVERIFIED]`

- **Statement:** The payroll engine input for a job day carries whether the ticket is on a holdover
  day, and the week assembler sets it from the same server-side source the field ticket's `holdover`
  comes from (`JobResource.isHoldover` / `JobResourceAllocation.isHoldover`, resolved per ticket),
  never from anything the client submits.
- **Surface:** api, `packages/payroll-engine`
- **Sources:**
  - PLAN — `[UNVERIFIED]` — kind: plan — "Add a holdover field to the engine input `PayrollJobDayInput`,
    sourced in … `PayWeekAssembler`." "Mobile never submits a holdover flag — payroll must derive
    holdover from the same server source."
  - TF-SPEC REQ-07 — `[UNVERIFIED]` — kind: ticket spec — trigger is `JobResource.isHoldover` /
    `JobResourceAllocation.isHoldover`; DN-1 H1, H2.
  - `packages/shared/src/constants/ticket-holdover.ts` — kind: code (descriptive) —
    `FieldTicketHoldover { dayNumber, isLastDay, dayStartFrom?, totalDays, previousDayCrane, dayStartAt?, nextDayDate? }`.
- **Conflict:** none
- **Open question:** none for the field's existence. What the engine *does* with it beyond carrying
  it is `NOT SPECIFIED` — see Notes.
- **Ripple:** `PayrollJobDayInput` is built in `pay-week-assembly.ts`; also constructed in
  `apps/api/prisma/scripts/seed-payroll-demo.ts` and `payroll-flag-detection.service.spec.ts`;
  re-exported from `packages/payroll-engine/src/index.ts:76`; read in `explain.ts`. The engine
  package is imported by api, web (`features/payroll/lib/payroll-week.ts`) and mobile
  (`features/field-ticket/...`). Adding an **optional** field breaks no constructor. A required field
  breaks the two producers named above. Decided in D3. Enumerated by §11a rows 1-3.
  What the downstream consumers of the *value* do is REQ-02/03.
- **Acceptance:** with a job whose held flag is set, `buildJobDay` produces a job-day whose holdover
  field is set from the server source; a non-held job produces it absent/false; payroll runs on a
  non-holdover ticket produce byte-identical `PayrollJobDayInput`s.
- **Edges:**
  - **Reached by:** every `PayWeekAssembler.buildWeek` caller — `PayrollService.executeRun`,
    `PayrollWeekPricingService`, and anything using `week-pricing-override.ts` (§11a row 2). The
    field must be set on the context (`contextJobDays`) days as well, since they pass through the same
    `buildJobDay`.
  - **Does not apply when:** the job is not held (no field); a ticket with no allocation anchor
    (`findTicketAnchor` returns none) — treated as non-holdover.
  - **When an input is absent:** no tenant context (`TenantContextService.get()` empty) — resolution is a
    no-op, same as `holdoverMidDayTicketIds` (`payroll.service.ts:391`). ASSUMED — nearest existing behaviour.
  - **Trust boundary:** N/A — server-derived. Mobile/web supply nothing.
  - **Read time:** `live` at assembly time — the day index follows the schedule as it stands on the run
    (a dropped middle day counts as the last day, `holdover-days.util.ts:dayIndexOf`). A week recalculated
    after the schedule changes may re-index. ASSUMED — inherited from TF-SPEC REQ-07.
- **Notes for the executor:** reuse `resolveHoldoverForRows(repo, ticketIds, tenantCompanyId)`
  (`usecase/job-tickets/resolve-holdover.ts`) — it already batches once per job and returns the full
  `FieldTicketHoldover`. `PayrollService.holdoverMidDayTicketIds` re-implements a thinner version of the same
  resolution; leave it (D2). **What the engine itself computes from the field is `NOT SPECIFIED`** — the
  window is derived before the engine sees it (REQ-02, D1), so the engine carries the flag for explain/audit
  only. If the developer wants an engine-side rule, that is a new requirement.
  G5: `tcg-contract-tracer` on the shape; callers fixed in the same unit.

### REQ-02 — Holdover paid-window END: break-down end → boom end → build-up end `[UNVERIFIED]`

- **Statement:** On a holdover ticket the End Work instant the paid window closes on is the recorded break-down end **on any day one exists** (middle days can break down too, not only the last day); only when no break-down is recorded is it the end of the boom session; otherwise the build-up end. Applies to every holdover day (Q1-B for non-Home-start days; Q2 for Home-start days).
- **Surface:** api
- **Sources:**
  - PLAN — `[UNVERIFIED]` — kind: plan — "holdover window END = break-down end if a break-down is recorded; ELSE boom end if a boom session is recorded (build-up + boom, no break-down); ELSE build-up end (no boom, no break-down)."
  - Owner answer Q1 = B, 2026-10-26 (relayed by the coordinator; no decision note yet) — `[UNVERIFIED]` — kind: owner direction — the chain governs every non-Home-start holdover day including Day 1 and the last day; it resolves to the break-down end whenever one is recorded; "in holdover jobs a break-down CAN occur on middle (non-last) days too".
  - Owner answer Q2, 2026-10-26 — the chain resolves the End Work instant for Home-start days as well (REQ-03).
  - TF-SPEC REQ-11 / REQ-13 — `[UNVERIFIED]` — kind: ticket spec — context only: a middle day may leave the crane set up (no break-down) and `WORK_TIME` closes at submit.
- **Conflict:** DEC-YARD (verified) has "no holdover exception" and GAP-HO2 sub-questions 3–5 (Day 1 / Days 2+ / last-day end) were open with TCG; the owner's Q1-B answer now settles them for this ticket. This spec does not claim TCG ratified it, and `payroll/gaps.md` is not edited by this run. Candidates: DEC-YARD (12.2 KB, 2026-09-03); DEC-HOME (2.5 KB, 2026-10-16); the Melissa McNutt provisional note (`reference`, 31.8 KB, held by TCG). **`tcg-scrum` to record a decision note for Q1-B (a pay rule overriding the verified yard-to-yard rule on holdover days) and the G4 provenance row.**
- **Open question:** none — Q1, Q2 answered; Q7 recorded.
- **Ripple:** the derived End Work feeds `PayrollJobDayInput.shiftEndedAt`, therefore the engine's ST/OT/DT split, rest-gap chain, meals, guarantees, `PayrollJobDay`, ADP export, and the flags that read the priced window (REQ-07). Non-payroll readers of the raw `payableWindow` are **unchanged** (owner decision Q3-A, §11a rows 6–8).
- **Acceptance:** with { `BUILDUP_TIME`, `BOOM_TIME`, `BREAKDOWN_TIME` } the window end is `BREAKDOWN_TIME.endedAt` — on a middle day as on the last; with { `BUILDUP_TIME`, `BOOM_TIME` } the latest closed `BOOM_TIME.endedAt`; with `BUILDUP_TIME` only, its `endedAt`. Window start is Start Work (REQ-03). A non-holdover ticket's window is unchanged.
- **Edges:**
  - **Reached by:** `buildJobDay` (every `PayWeekAssembler` caller, REQ-01) and `payroll-explain.ts` (`memberPayableWindow`, lines 80, 159). Nothing else (Q3-A).
  - **Does not apply when:** a non-holdover ticket. A member with their own window (TCG-25): ASSUMED — own window still wins, as today (`pay-week-assembly.ts:509-510`).
  - **When an input is absent:** none of the three entries closed (or open `endedAt`): ASSUMED — fall back to the existing `WORK_TIME` end (D8); a pay amount, confirm at sign-off. Multiple boom sessions: ASSUMED — latest closed `endedAt`.
  - **Trust boundary:** N/A — server-derived from stored `TicketTimeEntry` rows.
  - **Read time:** `live`.
- **Notes for the executor:** G4 provenance row in `payroll/payroll-rules-provenance.md`, same commit; status `Pending` until the decision note exists. Pure function beside `deriveTicketTimes` (D1), called by assembler and explain only.

### REQ-03 — Home-start days: no yard leg; payable Start Work → End Work `[UNVERIFIED]`

- **Statement:** On a Day-2+ holdover ticket whose `dayStartFrom` is HOME there is no Left Yard or travel segment, and payable hours are measured Start Work → End Work (the employee's `WORK_TIME` own-window), where the End Work instant is the one the REQ-02 chain resolves.
- **Surface:** api
- **Sources:**
  - Owner answer Q2, 2026-10-26 (relayed by the coordinator; no decision note yet) — `[UNVERIFIED]` — kind: owner direction — settles the self-contradiction in DEC-HOME: payable is Start Work → End Work; this supersedes both DEC-HOME's "Arrive Job Site to Left Job Site" headline and its "closes at submit" body **as the payable boundary**.
  - DEC-HOME — `[VERIFIED]` — kind: decision — **partly superseded by the owner answer above.** Still stands: no yard step on a Home-start day, the yard-to-yard boundary does not apply, the STANDARD meal fallback ships as-is.
  - TF-SPEC §12 Q5, PLAN — `[UNVERIFIED]`.
- **Conflict:** the note's internal contradiction (Left Job Site vs submit) is resolved by Q2. Resolution cites the owner, 2026-10-26. A verified note is now partly superseded: **`tcg-scrum` to write a decision note and update the provenance row (G4)**; until then this spec cites DEC-HOME for the surviving parts only.
- **Open question:** none.
- **Ripple:** same radius as REQ-02 (§11a rows 4–9). Home-start days have no `YARD_TIME` row, so the three yard flags have nothing to read there (REQ-07). The paid window starts at Start Work, **not** Arrive On Site, so the rest-gap chain and 24h check start there.
- **Acceptance:** a Home-start holdover ticket's `shiftStartedAt` is the Start Work instant (member own window start where present) and `shiftEndedAt` is the REQ-02 chain End Work; no yard leg is created or read for that day.
- **Edges:**
  - **Reached by:** `buildJobDay`; explain.
  - **Does not apply when:** Day 1; Day 2+ with `dayStartFrom = YARD` or null — with Q1-B/Q2 the payable window is the same Start Work → chain End Work either way, so the earlier "null day-start prices as non-Home-start" assumption is settled and dropped; the day-start only decides whether a yard leg exists.
  - **When an input is absent:** no Start Work captured → existing `MISSING_PAYABLE_WINDOW` path (nearest existing behaviour, ASSUMED). End: REQ-02.
  - **Trust boundary:** N/A — `dayStartFrom` is stored server-side; payroll reads it, never a request flag.
  - **Read time:** `live`.
- **Notes for the executor:** G4 provenance row, same commit — status `Pending` / partly superseding DEC-HOME until the new decision note exists. STANDARD tickets (no Start Work/End Work) keep their own handling; not extended here. Arrive On Site / Left Job Site remain the job-site (`JOB_SITE_TIME`) fields and are **not** the payable boundary.

### REQ-04 — Reach of the REQ-02 chain: every non-Home-start holdover day `[UNVERIFIED]`

- **Statement:** The window-close chain governs the End Work of every non-Home-start holdover day — Day 1, middle days and the last day — using the recorded break-down end whenever one exists on that day; "break-down skipped" is a possibility on any non-last day, never a rule that middle days have none.
- **Surface:** api
- **Sources:**
  - Owner answer Q1 = B, 2026-10-26 (relayed by the coordinator; no decision note yet) — `[UNVERIFIED]` — kind: owner direction.
  - GAP-HO2 (`payroll/gaps.md`) — `[UNVERIFIED]` — kind: vault — sub-questions 3, 4, 5 (Day 1 end, Days 2+ end, last-day end), previously open with TCG (owner Kyle Harlow and Joe Schacatano, with Corrina Bustos). Answered for this ticket by the owner above; not edited here.
- **Conflict:** DEC-YARD (verified) has no holdover exception; see REQ-02. Not merged, not chosen by this spec — the owner chose.
- **Open question:** none.
- **Ripple:** as REQ-02, including Day 1 and the last day, whose paid end today is the `WORK_TIME` end (yard return). §11a rows 4–5, 9. Their changed end was decided by Q1-B.
- **Acceptance:** Day-1, middle-day and last-day tickets each end on their recorded break-down end when present; Yard-start Day-2+ days no longer rely on a yard return.
- **Edges:**
  - **Reached by:** as REQ-02. **Does not apply when:** non-holdover tickets. **When an input is absent:** REQ-02. **Trust boundary:** N/A. **Read time:** `live`.
- **Notes for the executor:** one derivation for all holdover days (D1); no per-day branching beyond the start rule in REQ-03.

### REQ-05 — PAY-049 per-day subsistence deferred; worked-day `subsistenceHoldover` unchanged `[UNVERIFIED]`

- **Statement:** The worked-day subsistence behaviour (`PayrollJobDayInput.subsistenceHoldover`, from `Job.subsistenceHoldover`) is left unchanged; PAY-049's
  "every day of the holdover, worked or not" is deferred, with the deferral and its reason recorded in `payroll/gaps.md`.
- **Surface:** api (none changed), vault (a gaps entry — written by the owner of the vault, not by this spec's run)
- **Sources:**
  - PLAN — `[UNVERIFIED]` — kind: plan — "Subsistence PAY-049 'every calendar day' DEFERRED … no data source for which employee is held which day."
  - `payroll/gaps.md` → *DAS holdover vs subsistence holdover — pointer, owned by dispatch* — `[UNVERIFIED]` — kind: vault — status open: "Dispatch now marks held items per job line
    (`JobResource.isHoldover`); payroll's `Job.subsistenceHoldover` is unchanged and unlinked. Whether they are one fact decides whether PAY-049's … can be fed from dispatch."
    Owner Lisette Anzaldo with Corrina Bustos.
  - `payroll/rules/PAY-049-weekend-subsistence.md` — `[UNVERIFIED]` — kind: vault, 1.5 KB — status `open`.
  - `packages/payroll-engine/src/subsistence.ts` header — kind: code (descriptive) — "Not yet built: PAY-049's 'every day of the holdover job, worked or not'."
- **Conflict:** none
- **Open question:** none for this ticket (deferred). The upstream question (are the two holdovers one fact?) is a vault gap and stays there.
- **Ripple:** none — behaviour unchanged. Consumers of `subsistenceHoldover` (`calculate.ts:1068`, `payroll.service.ts:1736`, `payroll.repository.ts:240,2022`,
  `job-subsistence-card.tsx`) are untouched. Established by: `grep -n -i holdover` over the payroll usecase/service files.
- **Acceptance:** after the change a ticket's `subsistenceHoldover` input and the $85/$200 outputs for a fixed fixture are identical to before; `payroll/gaps.md` carries a
  dated deferral note under the existing PAY-049 entries.
- **Edges:** **Reached by:** `buildJobDay` line 604 (unchanged). **Does not apply when:** N/A — no behaviour added. **When an input is absent:** N/A. **Trust boundary:** N/A — server-derived. **Read time:** N/A.
- **Notes for the executor:** the elaborator may not write vault files. The gaps entry is a unit step for whoever has that write path (`tcg-scrum` records decisions; a gaps
  append is any agent's). Do **not** merge `Job.subsistenceHoldover` with `JobResource.isHoldover`; REQ-01 reads the latter for the new field only.

### REQ-06 — Holdover batch (display only) on the employee timesheet; count badge on the worklist `[UNVERIFIED]`

- **Statement:** The employee timesheet page shows the week's holdover tickets grouped by run, each as "Day d of D" with a Clean or Flagged status derived for display —
  Flagged when it is a Day-2+ ticket with no day-start recorded, Clean otherwise — plus a summary chip; the worklist row shows only a small holdover-count badge. It never
  blocks approval or export and creates no `PayrollFlag`.
- **Surface:** api (payload), web
- **Sources:**
  - PLAN — `[UNVERIFIED]` — kind: plan — "Holdover batch (DISPLAY ONLY) … INFORMATIONAL ONLY — no new PayrollFlag/detector, must NOT block approval/export. Summary chip mirrors
    components/organisms/entity-photos/photo-batch.ts; worklist row gets only a small holdover count badge."
  - TF-SPEC REQ-07 / REQ-09 — `[UNVERIFIED]` — kind: ticket spec — "Day d of D" and the Day-2+ day-start choice (`dayStartFrom` absent until answered).
  - `apps/web/src/features/payroll/components/payroll-status-chip.tsx` — kind: code (descriptive) — `resolveEntryStatus` derives `clean | flagged | sent-back` for display from sendBack + flags.
  - `apps/web/src/components/organisms/entity-photos/photo-batch.ts` — kind: code (descriptive) — `photoBatchSummary` / `photoBatchChipText`: counts → chip text.
- **Conflict:** none
- **Open question:** none blocking. Not specified by any source: the exact label/copy, whether overlay (unpriced/incomplete) holdover tickets are in the batch, and ordering inside a group
  — see Edges and §13.
- **Ripple:** **Existing shapes extended, none removed.** (a) `GET /api/v1/payroll/periods/:id/employees/:employeeId` (`getEmployeeWeek`, `payroll.service.ts:1050-1105`) — each `jobDays[]`
  item gains holdover fields (G5: response shape; web `PayrollJobDay` type must be updated in the same unit; only `@tcg/shared` importers are compile-checked). (b) `GET …/employees`
  (roster, `payroll.service.ts:~985-1030`) gains `holdoverCountsByEmployeeId` beside `sendBackCountsByEmployeeId` (web `payroll-week-entries.service.ts:94`, `payroll-worklist.helpers.ts:96`).
  (c) the timesheet page composition (`payroll-employee-timesheet.tsx`). Approval/export gates (`isApproveWeekDisabled`, `payroll-export-blockers.ts`) are **not** touched — decided (Q4).
- **Acceptance:** an employee-week with a Day 2 of 3 holdover ticket with `dayStartFrom` null shows it under its run as "Day 2 of 3 — Flagged"; with `dayStartFrom` set shows "Clean"; Day 1 is
  always Clean; `canApprove` and export availability are identical with and without holdover tickets present; the worklist row shows a count only when ≥ 1; no `PayrollFlag` row is written
  for any of it.
- **Edges:**
  - **Reached by:** page load of `/payroll/[employeeId]` (hook `usePayrollEmployee`); worklist load. Every path that can reach the page (week nav, employee select) reaches the same payload.
  - **Does not apply when:** an employee-week with no holdover ticket (no batch rendered, no badge); a ticket whose job holds nothing over (absent from the map, `resolveHoldoverForRows`).
  - **When an input is absent:** no `dayStartFrom` on a Day-2+ ticket is the Flagged case itself; `totalDays`/`dayNumber` always present once held. Day 1 with no `dayStartFrom` → Clean (Day 1 is always the yard,
    `ticket-holdover.ts` `holdoverNeedsDayStart`). Overlay-only (not-yet-priced) tickets: **ASSUMED — not in the batch** (it lists priced job days the page already renders); flagged in §13.
  - **Trust boundary:** N/A — server-derived. The web derives Clean/Flagged from server fields; it never sends a status.
  - **Read time:** `live` — the batch reflects today's schedule and today's `dayStartFrom`, not what was true when the week was priced. ASSUMED — consistent with REQ-01.
- **Notes for the executor:** Flagged = `holdoverNeedsDayStart(ctx)` from `@tcg/shared` — **reuse it**; do not re-implement the predicate (D5). Put the derive-for-display function next to
  `resolveEntryStatus` or in `features/payroll/lib/` as a pure function — D5. Group key = the held run — **not specified** which key (job + slot?); use `parentJobId` + `jobResourceId` from the anchor
  (`TicketAnchor`) — ASSUMED, D6. Reuse `SectionCard`, the `Chip` styling pattern of `payroll-status-chip.tsx`, theme CSS variables only; test IDs `payroll-holdover-*` (check `grep -rn 'payroll-holdover' qa-automation/e2e`
  — none expected). Worklist badge: a count beside the existing `sendBackCounts` render in `payroll-worklist-list.tsx`.
  The word "Flagged" in the batch is a **display label only**; it must not be confused with `PayrollFlag` status `OPEN` (§11c).

### REQ-07 — Payroll flags on holdover: window math plus build-time confirmation, no new detector `[UNVERIFIED]`

- **Statement:** Beyond the three open-`YARD_TIME` detectors REQ-15 already exempts, no payroll flag detector gains holdover special-casing; the window math (REQ-02/03) is relied on to stop
  `INVALID_TIME_24H_OR_MORE` mis-firing; at build every reader of a yard/window row is checked for false positives on holdover tickets and any that still mis-fires is changed and recorded as a finding;
  `MISSING_NOTES` is unchanged; and `holdoverMidDay` is carried through `withPricedRest`.
- **Surface:** api
- **Sources:**
  - PLAN — `[UNVERIFIED]` — kind: plan — Part 3 as quoted in `intent.md` §3.
  - TF-SPEC §12 Q8 — `[UNVERIFIED]` — kind: ticket spec — "Ship only the three flag exemptions (S3) and the overlay change (L18). Other `YARD_TIME` readers are left untouched … The executor checks
    each reader during H5 and confirms no false positive. If one is found, it becomes a finding." (resolved from the plan, 2026-10-16; **no decision note**)
  - TF-SPEC REQ-15 — `[UNVERIFIED]` — kind: ticket spec; DN-1 S3 — the three exemptions (invalid-times, crew-yard-mismatch, Samsara). Already shipped (code descriptive: `payroll-flag-invalid-times.ts:572`,
    `payroll-flag-crew-yard-mismatch.ts:173,206`, `payroll-flag-samsara-mismatch.ts:143`).
- **Conflict:** none
- **Open question:** none (Q8 of TF-SPEC already resolved; restated here as Q10).
- **Ripple:** the detectors listed in §11a row 10. `withPricedRest` has exactly one caller (`payroll.service.ts:702`; `grep -rn withPricedRest apps/api/src`) and `holdoverMidDay` is applied **after** it on that line, so carrying
  it through `withPricedRest` is a no-op today; it only matters for a future caller or for `detectRestUnder8h` reading the field from the map's input. Unchanged behaviour is the intent.
- **Acceptance:** for a fixed holdover fixture the three REQ-15 flags still do not fire on a middle day; `INVALID_TIME_24H_OR_MORE` does not fire on a holdover day whose derived window is under 24 h; `withPricedRest`'s
  output objects carry `holdoverMidDay` when the input does; no new `PayrollFlagCode` appears in `schema.prisma`.
- **Edges:**
  - **Reached by:** `PayrollFlagDetectionService.detect` via `payroll.service.ts:700-715` (priced days and dropped days).
  - **Does not apply when:** a non-holdover day; the last holdover day (`holdoverMidDay` false by design, `payroll-flag-detection.service.ts:76-81`).
  - **When an input is absent:** `holdoverMidDay` undefined = false.
  - **Trust boundary:** N/A — server-derived.
  - **Read time:** `live`.
- **Finding F1 (for the developer, not a question — the plan's decision stands):** the plan says Part 1's window math "stops INVALID_TIME_24H_OR_MORE, INVALID_LONG_BOOM_TIME and
  INVALID_TIME_MISSING_START_OR_END (non-yard rows)". Reading the detectors: **only `INVALID_TIME_24H_OR_MORE` reads the priced window** (`pricedWindowOf` = `shiftStartedAt/EndedAt`,
  `payroll-flag-invalid-times.ts:69,609`). `INVALID_LONG_BOOM_TIME` compares each boom session with the **raw `WORK_TIME` row** (`rowOf(day, WORK_TIME)`, line 670) and
  `INVALID_TIME_MISSING_START_OR_END` reads **raw `timeEntries`** (`rowOf`, line 567). Changing the assembler's window changes neither. Per Q9/Q10 no detector is pre-changed; the build-time
  confirmation is therefore the only thing that covers those two, and if either mis-fires on a holdover ticket the finding record is where it goes. (A second reader of the raw `WORK_TIME` row:
  `payroll-flag-am-pm-mismatch.ts:102`.)
- **Notes for the executor:** unit scope = window derivation (REQ-02/03) + the `withPricedRest` carry + the confirmation sweep recorded in the PR's findings. Do not edit `payroll-flag-invalid-times.ts`
  unless the sweep finds a false positive (then: one flag, one change, one recorded finding).

### REQ-08 — Correction editor hides yard fields on a Home-start holdover day `[UNVERIFIED]`

- **Statement:** In the shared correction dialog (Adjust Entries, and the same dialog for a returned entry), on a Home-start holdover day the Left Yard Time and Arrived Yard Time fields are hidden, **Start Work Time and End Work Time (the employee's own window) are presented as the load-bearing pay-boundary fields** (owner answer Q2), Arrived On Site / Left Job Site stay as ordinary job-site (`WORK_AT_JOB_SITE_TIME`/`JOB_SITE_TIME`) fields and are not the payable boundary, Job Start / End Job / boom / lunch fields stay, and the window footnote has a holdover variant; every other day is unchanged. This supersedes the plan's "arrivedOnSiteAt/leftJobSiteAt load-bearing".
- **Surface:** web
- **Sources:**
  - PLAN — `[UNVERIFIED]` — kind: plan — Part 4, as quoted.
  - DEC-HOME — `[VERIFIED]` — kind: decision — no yard step on these days (its "Arrive Job Site → Left Job Site" paid-time boundary is superseded by the owner's Q2 answer).
  - `decisions/2026-10-22-unify-adjust-entries-on-corrections-dialog.md` — `[UNVERIFIED]` (`status: reference`), 4.1 KB, 2026-10-22 — Adjust Entries is the one `CorrectionDialog` for returned and never-returned entries.
- **Conflict:** none
- **Open question:** none for hiding. **Not specified by any source:** what "load-bearing" means visually (a badge? a heading? required?), and the footnote's exact copy — `NOT SPECIFIED`. See §13; copy is not invented here.
- **Ripple:** consumers of `TIME_FIELDS` (`correction-form.parts.tsx`) = `correction-times-section.tsx` (renders the grid and computes each field's "Must be after <previous>" error from the **previous array entry**, line ~217);
  consumers of `TIME_KEYS` (`build-correction-payload.ts`) and `correction-flag-resolution.ts:15` (`YARD_TIME → arrivedYardAt`). Hiding by filtering `TIME_FIELDS` must keep the "previous field" lookup on the *visible* list, or the
  first field after the gap compares against a hidden one. Everything is `CorrectionDialog` → both modes (send-back id and direct entry). Established by: `grep -n 'TIME_FIELDS\|usesOwnWindow\|leftYardAt\|arrivedYardAt' apps/web/src/features/payroll-corrections/**`.
  `payroll-entry-fixes` is a separate path and unchanged (out of scope).
- **Acceptance:** opening the dialog for a Home-start holdover day shows no Left Yard / Arrived Yard inputs and the other six time inputs; opening it for any other day shows all eight as today; the payload built from a
  Home-start day contains no `leftYardAt` / `arrivedYardAt` keys even if the stored row had values (REQ-09 enforces server-side).
- **Edges:**
  - **Reached by:** Weekly Payroll → Adjust Entries (direct mode), Returned Entries (send-back mode), the timesheet page's Fix entry — all via `CorrectionDialog`.
  - **Does not apply when:** a Yard-start Day-2+ day, a Day-1 holdover day, a non-holdover day, a Home-start day that nonetheless *has* a `YARD_TIME` row (e.g. Home chosen after a Left Yard punch): `NOT SPECIFIED` — **ASSUMED: show the yard fields when a yard row exists**,
    because hiding a stored value the pay may depend on would be silent data hiding. Confirm at sign-off.
  - **When an input is absent:** the holdover flag absent (older payload / cache) = not Home-start = current behaviour.
  - **Trust boundary:** the flag comes from the server's correction read (REQ-09); the web only reads it.
  - **Read time:** `live`.
- **Notes for the executor:** put the flag on `PayrollCorrection` (the read shape, beside `usesOwnWindow`), **not** inside `CorrectionTimes` — see D4 for why the plan's "through CorrectionTimes" would corrupt `keyof CorrectionTimes`
  (used by `TIME_FIELDS` and `TIME_KEYS`). Reuse `SectionCard`, `TimeField`; theme variables only. The send-back popup (`payroll-send-back-dialog.tsx`, `send-back-ticket.dto.ts`) is time-agnostic and **not touched** (§13).

### REQ-09 — Correction API never creates a yard leg, does not enforce the yard chain, derives Home-start itself `[UNVERIFIED]`

- **Statement:** On a Home-start holdover day the correction read returns a holdover/Home-start indicator derived by the server, `planCorrection` never creates or moves a `YARD_TIME` row for that day (a submitted yard edge is
  ignored or refused), and `findCorrectionOrderViolation` does not enforce the yard edges on that day.
- **Surface:** api, web (type)
- **Sources:**
  - PLAN — `[UNVERIFIED]` — kind: plan — "plan-correction.ts setWindow(YARD_TIME,…) must NOT create a yard leg; correction-rules.ts CORRECTION_ORDER must not enforce the yard chain for that day. Plumb a holdover+Home-start flag
    through CorrectionTimes/SubmitCorrectionPayload."
  - DEC-HOME — `[VERIFIED]` — kind: decision — no yard step on these days.
- **Conflict:** none
- **Open question:** none blocking. What a **submitted** yard edge on such a day does — silently ignored vs 400 — is `NOT SPECIFIED`; ASSUMED **400 with a plain message**, the nearest existing behaviour for an invalid edge
  (`plan-correction.ts` already throws `BadRequestException` for invalid times). Confirm at sign-off.
- **Ripple:** (a) `GET /api/v1/payroll-corrections/:id` and `GET …/entry/periods/:periodId/tickets/:ticketId/employees/:employeeId` (`buildCorrectionView`, `payroll-send-backs.service.ts:826-880`) — response gains the flag (G5, web `PayrollCorrection` updated same unit);
  (b) `PATCH` submit paths, both through `prepareCorrection` (line 1325) → `planCorrection` (line 1337, the only non-spec caller: `grep -rn 'planCorrection(' apps/api/src`); (c) `correction-preview` (`buildCorrectionPreview`, line 1069) — preview reads the same plan;
  (d) `findCorrectionOrderViolation` callers (`checkCorrectionRules`, line 1356). Note: `findCorrectionOrderViolation` already **skips an entry that does not exist** (`resolve` returns null → `continue`), so on a day with no `YARD_TIME` row the yard chain is already not enforced;
  the change only matters when a yard row exists or an edit would add one. (e) DI: `PayrollSendBacksModule` must provide `TicketHoldoverRepository` (currently absent) — D7.
- **Acceptance:** `GET` on a Home-start holdover ticket returns the indicator true; on any other ticket false/absent; a `PATCH` carrying `leftYardAt` or `arrivedYardAt` for a Home-start holdover day does not create/modify a `YARD_TIME` row (and returns 400 per the assumption);
  a `PATCH` changing only `arrivedOnSiteAt`/`leftJobSiteAt` on that day passes the order check with no yard step; the same payload on a non-holdover day behaves exactly as today.
- **Edges:**
  - **Reached by:** `getCorrection`, `getCorrectionForEntry`, `submitCorrection`, `submitCorrectionForEntry`, `previewCorrection` and the entry preview route. All resolve the ticket's holdover through the same helper (D2).
  - **Does not apply when:** Yard-start, Day 1, non-holdover days; a member's own-window edits (`startWorkAt`/`endWorkAt` — unchanged).
  - **When an input is absent:** ticket not resolvable as held → current behaviour. A flag sent by the client in `SubmitCorrectionDto` is **ignored** (see Trust boundary).
  - **Trust boundary:** the server derives Home-start (`dayStartFrom = HOME` and `dayNumber ≥ 2`) from the stored ticket on **every** request. **A holdover/Home-start flag in `SubmitCorrectionPayload` would be client-supplied and must not be believed.** The plan says to
    plumb the flag through `SubmitCorrectionPayload`; this spec deviates deliberately — D4 — and the developer reviews it.
  - **Read time:** `live`.
- **Notes for the executor:** `CorrectionTimes` (web, `payroll-send-backs.service.ts:126`) is a record of ISO instants keyed by field and is used as `keyof CorrectionTimes`; **do not add a boolean to it** (D4). API DTO: `CorrectionTimesDto`
  (`presentation/payroll-corrections/dto/payroll-correction.dto.ts:25`) unchanged. No test files (root `CLAUDE.md`).

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** no
- **Migration required:** no — holdover is derived, never stored (`ticket-holdover.ts` header: "Never stored — always derived"); `dayStartFrom`/`dayStartAt` already exist from TICKET-FLOW.
- **Data backfill required:** no. A **recalculation** of existing holdover weeks re-prices them under the new window rule; nothing is rewritten without a run, and approved weeks follow the existing `preserveApprovals` / recalculation-hold mechanics
  (`payroll.service.ts:~686`). Whether to recalculate settled periods is **NOT SPECIFIED** (§11 rollout).
- **Existing models considered:** `JobTicket` (already carries `dayStartFrom`/`dayStartAt`), `JobResource` and `JobResourceAllocation` (the `isHoldover` trigger), `PayrollJobDay` (priced output — a stored `isHoldover` column was **not** added: payroll can re-derive it, and a
  column would go stale on a schedule change; no source asks for historical immutability), `PayrollFlag` (a new flag code **rejected** — decided, Q4).
- G3: no tenant-scoped model added or changed → `TENANT_SCOPED_MODELS` untouched, `tcg-prisma-guardian` not required. The new reads go through `TicketHoldoverRepository`, which filters by `tenantCompanyId` explicitly.

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| none | — | — | — | — |

- **New prefix introduced:** no
- **Child relations:** N/A
- **Fields whose type/precision no source states:** none.

## 4. API surface — `apps/api`

- **Pattern:** none — a read-side enrichment of two existing payroll payloads and a change to the pricing and correction paths; neither `P1` nor `P2`.
- **Existing functions/services to reuse:**
  - `resolveHoldoverForRows` (`usecase/job-tickets/resolve-holdover.ts`) — batch, cycle-free, returns `FieldTicketHoldover` per held ticket.
  - `TicketHoldoverRepository` (`service/job-holdover/ticket-holdover.repository.ts`) — `findTicketAnchor`, `findHeldJobIds`, `findOpenDays`, `findPreviousDayTickets`.
  - `dayIndexOf` (`service/job-holdover/holdover-days.util.ts`); `holdoverNeedsDayStart` (`@tcg/shared`).
  - `deriveTicketTimes` (`usecase/ticket-time-entries/derive-ticket-times.ts`) — the new window derivation sits beside it.
  - `ticketCompletedLate` job-day enrichment pattern in `getEmployeeWeek` (`payroll.service.ts:1085-1099`) — the same `.map((day) => ({ ...day, ...x }))` seam carries the holdover fields.
- **New exported functions/services proposed:** (each a §11b decision)
  - `deriveHoldoverPayableWindow(entries, { homeStart, holdover })` — usecase, `ticket-time-entries/` — pure; nothing existing computes a chain-based end (D1).
  - `holdoverDisplayOf(holdover)` — **web**, not api (D5).
  - No new endpoint, controller or module.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/api/v1/payroll/periods/:id/employees/:employeeId` (existing) | `payroll.controller.ts:158` | `PayrollService.getEmployeeWeek` | `PayrollRepository.findEmployeeWeek` + `TicketHoldoverRepository` | REQ-06 |
| `GET` | `/api/v1/payroll/periods/:id/employees` (existing roster) | `payroll.controller.ts:145` | `PayrollService` (roster build, ~985-1030) | same | REQ-06 |
| `GET` | `/api/v1/payroll-corrections/:id` and `…/entry/periods/:periodId/tickets/:ticketId/employees/:employeeId` (existing) | `payroll-corrections.controller.ts:47,80` | `PayrollSendBacksService.buildCorrectionView` | `TicketHoldoverRepository` | REQ-09 |
| `PATCH` / `POST …/preview` (existing) | same controller | `PayrollSendBacksService.prepareCorrection` → `planCorrection` | — | REQ-09 |

Per endpoint:

- **Request DTO:** unchanged (`SubmitCorrectionDto`, `CorrectionTimesDto`). **No holdover flag added to a request** (D4).
- **Response shape:** *new optional fields only*. Job-day: `holdover?: FieldTicketHoldover` (reuse the shared type) — the exact subset sent is a §11b decision (D6). Roster: `holdoverCountsByEmployeeId?: Record<string, number>`.
  Correction: one boolean, `isHomeStartHoldover?: boolean` — name `NOT SPECIFIED` by any source (D4).
- **Guards / roles:** unchanged (`AccessTokenGuard` + existing `@Roles`/permissions on the routes above).
- **Route param identity:** unchanged (business codes on the boundary; this change adds no new route).
- **Errors:** `400` on a yard edge for a Home-start holdover day — ASSUMED (REQ-09 Edges); message text `NOT SPECIFIED` beyond "plain".
- **Pagination:** N/A — no list endpoint added.
- **Module registration:** `PayrollSendBacksModule` (`payroll-send-backs.module.ts`) gains `TicketHoldoverRepository` as a provider (a bare provider, like `PayrollFlagsRepository` there); `PayrollModule` already injects it
  (`payroll.service.ts:372`) and `PayrollPricingModule`/the assembler's callers must receive the repository or a function closing over it — the assembler is a plain class constructed by `PayrollService` and `PayrollWeekPricingService`; **the DI graph for the second
  caller is a build-time check (`grep -rn 'new PayWeekAssembler' apps/api/src`)**. Barrel exports kept.

## 5. Web surface — `apps/web`

- **Routes:** existing `/payroll/[employeeId]` and `/payroll` (worklist). No new route.
- **Existing components to reuse:** `SectionCard` (`@/components/patterns`), `EmptyState`, the `Chip` styling in `payroll-status-chip.tsx` (it is a file-local component — export it or copy its tone map; a §11b decision, D5), `TimeField` in the correction
  grid, `photoBatchChipText`'s pattern for a "n of N" chip (`components/organisms/entity-photos/photo-batch.ts` — read as a pattern; `components/` must not import from `features/`, and this is already in `components/`, so the **reverse** import (a payroll feature reading it) is allowed, but its helpers are photo-specific — nothing to import).
- **New components proposed:** `PayrollHoldoverBatch` (feature component under `features/payroll/components/`, composed in `payroll-employee-timesheet.tsx`); a pure `holdoverDisplayOf` helper in `features/payroll/lib/`. A small worklist badge may reuse an existing count-chip render
  — search `payroll-worklist-list.tsx` first. Nothing in `components/`.
- **Table (if any):** N/A — the batch is a grouped card list, not a `WorkspaceTable`. The worklist's table is unchanged apart from the badge.
- **Forms:** N/A — the correction form's existing validation applies; hidden fields are not validated (and not sent).
- **Server state:** TanStack Query — no new query: the holdover fields ride on the existing `usePayrollEmployeeWeek` payload; roster count on the existing worklist query. Invalidation unchanged.
- **Colors / spacing:** CSS variables only (`--color-utility-*`, `--color-ws-*`), as `payroll-status-chip.tsx`.
- **Responsive:** inherits the page; 44px touch targets on any new control (the batch has none — display only).
- **Copy:** `NOT SPECIFIED` — the plan gives "Day d of D", "Clean", "Flagged" as words only. No other string is written here; the executor uses exactly these three plus numerals and leaves the chip and footnote text to the sign-off review (§13).

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** N/A — mobile is not changed. It never submits a holdover flag (PLAN).
- **Components / Offline / Push:** N/A.
- **Touch targets:** N/A.
- `packages/payroll-engine` is imported by `apps/mobile` (`features/field-ticket/...`): an **optional** new field on `PayrollJobDayInput` does not affect it (§11a row 3).

## 7. Shared package — `packages/shared`

- **Types added / changed:** none required: `FieldTicketHoldover` and `holdoverNeedsDayStart` already exist and are reused unchanged (REQ-06, D5). If the web needs a payroll-specific display type it lives in `features/payroll`, not shared (D6).
  `packages/payroll-engine` (a different package) gains `PayrollJobDayInput.<holdover field>`; its name and shape are a §11b decision (D3).
- **Nothing shared:** N/A.

## 8. Permissions and tenancy

- **Roles permitted:** existing gates only — timesheet read (`payroll-admin` view / `payroll` view as today), the correction dialog (`payroll:edit` Payroll Manager, `payroll-admin:edit` Payroll Admin, per the 2026-10-22 note). The batch and badge add no action.
- **Roles denied:** unchanged.
- **Tenant isolation:** standard middleware; holdover reads use explicit `tenantCompanyId` (`TicketHoldoverRepository`). A run executes inside a tenant context; with none, resolution is a no-op (`payroll.service.ts:391`).
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| `leftYardAt`, `arrivedYardAt` on a Home-start holdover day | not accepted | PLAN; DEC-HOME | `[UNVERIFIED]` |
| Window end derivation inputs | closed `endedAt` only | `NOT SPECIFIED` for open rows (REQ-02 ASSUMED) | — |
| Holdover display copy / chip text | `NOT SPECIFIED` | — | — |

## 10. Tests

`not requested` (decision 2026-10-21 `decisions/2026-10-21-no-new-tests-unless-asked.md`, root `CLAUDE.md`; recorded as resolved Q11). Existing specs are run, not extended — in particular
`pay-week-assembly.spec.ts`, `payroll-flag-invalid-times.spec.ts`, `plan-correction`/`correction-rules.spec.ts`, `derive-ticket-times.spec.ts` should still pass; any that construct `PayrollJobDayInput` must keep compiling (the field is optional, D3).

- Requirements with no testable acceptance criterion: the "load-bearing" presentation in REQ-08 (visual treatment unsourced).

## 11. Non-functional

- **Performance:** one extra `resolveHoldoverForRows` per run and per employee-week/correction read (O(held jobs), `findOpenDays` once per job). `NOT SPECIFIED` target.
- **Concurrency:** N/A — read-side.
- **Audit / activity log:** none added. Corrections already write `PayrollEntryFix` / the send-back record (2026-10-22 note).
- **Migration/rollout order:** engine type → assembler + derivation → payroll payloads (api) → web types → batch/badge → correction read flag → correction plan guard → web correction form. Nothing is behind a flag. **Recalculation:** the new window changes the figures of
  every existing holdover week on its next run; whether to recalculate approved/exported weeks is `NOT SPECIFIED` — see §13. ADP exports already sent are not rewritten by this change.

### Scope boundary — related cards (recorded 2026-10-26 from the Trello reconciliation; no requirement status changed)

- **TCG-162** (Jobs: subsistence distance + holdover; QA/UAT; Ali) **owns worked-day subsistence paying**: $85/day for 45–77.5 mi, $200/day beyond 77.5 mi, **worked days only** — paying every calendar day is deliberately excluded (Corrina Bustos / TCG payroll). This confirms the Q6 deferral (REQ-05). HOLDOVER-PAYROLL must **not** re-touch worked-day subsistence (`subsistenceHoldover` and its consumers stay as they are).
- **TCG-221** (quote Holdover flag + days) and **TCG-222** (one-day job becomes holdover) are **upstream**: they define what *makes* something a holdover. HOLDOVER-PAYROLL treats holdover as already set server-side via `JobResource.isHoldover` / `JobResourceAllocation.isHoldover` and does not decide the trigger. Out of scope.
- Source for these three bullets: the coordinator's Trello summary, 2026-10-26 — `[UNVERIFIED]`, not read from the cards by this run.
- Client dependencies Q12 and Q13 (§12) belong to other cards and **do not block U1–U3**; client Lisette/Joe out until 2026-11-03, holdover demo 2026-10-27.

## 11a. Ripple — already-shipped behaviour these requirements reach

| # | Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `PayWeekAssembler.buildJobDay` and its two callers (`PayrollService.executeRun`, `PayrollWeekPricingService` + `week-pricing-override.ts`) | `PayrollJobDayInput` | REQ-01/02/03 | changes deliberately (window + field) | PLAN | `grep -rn 'PayWeekAssembler' apps/api/src --include=*.ts` |
| 2 | `seed-payroll-demo.ts`, `payroll-flag-detection.service.spec.ts` | `PayrollJobDayInput` literal | REQ-01 | unchanged (field optional, D3) | `NOT SPECIFIED` by any source; build-time compile check | `grep -rln 'PayrollJobDayInput' packages apps` |
| 3 | web `features/payroll/lib/payroll-week.ts`, mobile `features/field-ticket/**` | `packages/payroll-engine` package | REQ-01 | unchanged (type-only optional field; mobile imports unrelated helpers) | build-time check | `grep -rln 'payroll-engine' apps packages --include=*.ts --include=*.tsx` |
| 4 | Engine pricing: ST/OT/DT split, rest-gap chain, meals, guarantees | `shiftStartedAt/EndedAt` | REQ-02/03 | changes deliberately on holdover days only | PLAN, DEC-HOME | `grep -n 'shiftStartedAt' packages/payroll-engine/src/*.ts` (build-time) |
| 5 | `PayrollJobDay` rows, ADP paydata export (`adp-paydata-csv.ts`, `adp-paydata-validation.ts`), `payroll-run-record.ts` | persisted figures | REQ-02/03 | changes on the next calculation; past runs unchanged | `NOT SPECIFIED` for already-approved/exported weeks → §13 | `grep -rln 'payroll-engine' apps/api/src/usecase/payroll` |
| 6 | `payroll-explain.ts` (`memberPayableWindow`, lines 80, 159) | raw `payableWindow` | REQ-02 | must follow the new window or it explains a different window than priced — **D1** | PLAN (implied: explain mirrors pricing) — build-time confirm | `grep -n payableWindow -r apps/api/src/usecase` |
| 7 | `entry-fix-plan.ts` (Payroll's own entry fixes) | `deriveTicketTimes` | REQ-02 | unchanged — reads raw window (owner decision Q3-A) | owner answer Q3, 2026-10-26 | same |
| 8 | `ticket-worked-hours.ts`, `ticket-labor-entries.service.ts:116,157`, `ticket-time-entries.service.ts:232`, `derive-ticket-progress-view.ts:435` (crew-facing hours, labor-entry shift edges, web progress) | raw `payableWindow` | REQ-02 | unchanged — reads raw window (owner decision Q3-A) | owner answer Q3, 2026-10-26 | same |
| 9 | Flags reading the priced window or the labour entry shift: `INVALID_TIME_24H_OR_MORE`, `REST_UNDER_8H`, `LABOR_TICKET_MISMATCH` (`ticketWorkStartedAt/EndedAt`, `payroll.service.ts:172-191`) | `shiftStartedAt/EndedAt` / raw `WORK_TIME` | REQ-02/07 | `24H`, `REST` follow the new window (intended, Q9); `LABOR_TICKET_MISMATCH` compares the raw ticket `WORK_TIME` with the labour entry — **build-time confirm no false positive** (Q10) | TF-SPEC Q8 | `grep -rn 'ticketWorkStartedAt' apps/api/src` |
| 10 | `payroll-flag-invalid-times.ts` (`LONG_BOOM`, `MISSING_START_OR_END`, `24H`), `payroll-flag-am-pm-mismatch.ts`, `payroll-flag-crew-yard-mismatch.ts`, `payroll-flag-samsara-mismatch.ts`, `payroll-flag-missing-notes.ts` | `holdoverMidDay` / raw rows | REQ-07 | unchanged unless the build sweep finds a false positive (Q10); `MISSING_NOTES` unchanged (Q9) | TF-SPEC Q8; PLAN | `ls apps/api/src/usecase/payroll-flags/` |
| 11 | `PayrollJobDay` web type + every web reader of `jobDays` (`payroll-employee-table*`, `payroll-employee-daily.tsx`, `payroll-expanded-*`) | `getEmployeeWeek` payload | REQ-06 | unchanged (new optional fields) | PLAN | `grep -rln 'PayrollJobDay' apps/web/src` |
| 12 | Roster read consumers (`payroll-worklist*.tsx`, `payroll-week-entries.service.ts`) | `GET …/employees` | REQ-06 | unchanged (new optional map) | PLAN | `grep -rln 'sendBackCountsByEmployeeId' apps/web/src` |
| 13 | Approve / export gates (`isApproveWeekDisabled`, `payroll-export-blockers.ts`, API approval gate `payroll-approval-gate.ts`) | approval/export | REQ-06 | **unchanged** — the batch never blocks | Q4 (PLAN decision 1) | `grep -rln 'isApproveWeekDisabled' apps/web/src` |
| 14 | `CorrectionDialog` + sections, `build-correction-payload.ts`, `correction-flag-resolution.ts`, `PayrollSendBacksService` view/preview/submit | `TIME_FIELDS`, `PayrollCorrection`, `planCorrection`, `findCorrectionOrderViolation` | REQ-08/09 | changes on Home-start holdover days only; others unchanged | PLAN | `grep -rn 'TIME_FIELDS\|planCorrection(\|findCorrectionOrderViolation' apps` |

- **Surfaces with no existing behaviour in this area:** web payroll has no holdover rendering (`grep -rn 'holdover' -i apps/web/src/features/payroll apps/web/src/features/payroll-corrections apps/web/src/features/payroll-flags` — only `job-subsistence-card.tsx`, the unrelated flag); `PayrollSendBacksModule` has no holdover dependency.
- **Consumers with no source for what happens to them:** none — rows 7, 8 settled by Q3-A. Row 5's already-approved weeks are noted in §13, not asked, because recalculation of settled periods follows the existing recalculation-hold rules and no new behaviour is added here.

## 11b. AI decisions — reviewed by a developer

| ID | Decision | Chosen | Why / alternatives (with existing code found) | Needs developer | Reviewed by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | Where the window-close precedence lives | A pure function next to `deriveTicketTimes` (`usecase/ticket-time-entries/derive-ticket-times.ts` or a sibling file) returning the paid window; `PayWeekAssembler.buildJobDay` and `payroll-explain.ts` both call it; the engine receives only the resulting `shiftStartedAt/EndedAt` | Rejected: putting it inside `packages/payroll-engine` (the engine is agnostic about ticket entries — it is handed windows, per its `PayrollJobDayInput` comments and `contexts/payroll-engine.md`); rejected: changing `deriveTicketTimes.payableWindow` itself (would change every non-payroll reader — Q3) | no | | |
| D2 | How payroll resolves holdover per ticket | Reuse `resolveHoldoverForRows(repo, ticketIds, tenant)` from `usecase/job-tickets/resolve-holdover.ts` (already batch + cycle-free). Leave `PayrollService.holdoverMidDayTicketIds` as is (works, shipped) | Alternative: depend on `TicketHoldoverService` — rejected, it imports `JobTicketsService` (module cycle, `ticket-holdover.service.ts` header); alternative: refactor `holdoverMidDayTicketIds` onto the helper — **follow-up**, a sibling cleanup, not required | no | | |
| D3 | The engine field | One **optional** field on `PayrollJobDayInput`: `holdover?: { dayNumber: number; isLastDay: boolean; dayStartFrom?: 'YARD' \| 'HOME' }` (the minimal subset of `FieldTicketHoldover` the derivation needs), carried not interpreted | Alternative: required boolean — rejected, breaks `seed-payroll-demo.ts` and a spec (§11a row 2); alternative: the full `FieldTicketHoldover` — rejected, the engine package must not import from `@tcg/shared` ticket vocabulary it does not use. G5 — `tcg-contract-tracer` | needs developer — **G5** | | |
| D4 | Plumbing the Home-start flag | A read-only boolean on the **`PayrollCorrection` response** (`isHomeStartHoldover?`), derived by the server on every read **and** every submit; **not** added to `SubmitCorrectionPayload` or `CorrectionTimes` | The plan says "through `CorrectionTimes`/`SubmitCorrectionPayload`". Adding a boolean to `CorrectionTimes` breaks `keyof CorrectionTimes` (`TIME_FIELDS`, `TIME_KEYS` in `build-correction-payload.ts` and `Partial<Record<keyof CorrectionTimes, string>>` in `SubmitCorrectionPayload.times`). A client-sent flag is a trust-boundary hole. Deviation from the plan's wording, same intent | no (reviewer should confirm the deviation) | | |
| D5 | Display derive and chip | `holdoverDisplayOf(holdover)` pure in `features/payroll/lib/`, using `holdoverNeedsDayStart` from `@tcg/shared`; chip uses the `payroll-status-chip.tsx` tone map (export `Chip` or extract it — a sibling extract) | Alternative: compute Clean/Flagged on the API — rejected (plan: "derived for display"); alternative: write a `PayrollFlag` — rejected, decided (Q4) | no | | |
| D6 | Payload subset and grouping key | Job-day carries `holdover?: { dayNumber, totalDays, isLastDay, dayStartFrom?, dayStartAt? }` (the `FieldTicketHoldover` fields without `previousDayCrane`/`nextDayDate`, which payroll has no use for) plus a run key (`parentJobId` + `jobResourceId`) for grouping | `FieldTicketHoldover` whole — rejected, carries mobile-only fields; web type kept in `features/payroll`, not `packages/shared` | no | | |
| D7 | Correction-side DI | `PayrollSendBacksModule` registers `TicketHoldoverRepository` as a bare provider and `PayrollSendBacksService` calls `resolveHoldoverForRows` | Importing the field-tickets module — rejected (cycle risk; `JobTicketsModule` pattern in its own comments uses bare providers) | no | | |
| D8 | Missing end entries | Fall back to the existing `WORK_TIME` end when none of break-down/boom/build-up is closed | A pay amount with no source — ASSUMED nearest existing behaviour; developer to confirm | no (ASSUMED, flagged in §14) | | |

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Reviewed by | Enumerated by |
| --- | --- | --- | --- | --- |
| `payroll-entry-fixes` (Payroll's own entry correction; `entry-fix-plan.ts`) | none — second correction path using `deriveTicketTimes` | **follow-up** — the plan excludes it; a Home-start holdover day can still be edited there with yard fields. Recorded so it is not forgotten | | `ls apps/api/src/usecase/payroll-entry-fixes/` |
| `PayrollService.holdoverMidDayTicketIds` | none | follow-up — move onto `resolveHoldoverForRows` (D2) | | `grep -rn 'findOpenDays' apps/api/src --include=*.ts` |
| `payroll-status-chip.tsx` `Chip`; other chip/badge surfaces in payroll (`payroll-issue-pills.tsx`, send-back chips) | none | no — only the tone map is reused | | `ls apps/web/src/features/payroll/components \| grep -i chip` |
| Worklist per-employee counts (`sendBackCountsByEmployeeId`, `overlayCountsByEmployeeId`) | same "counts by employee id" shape | yes — `holdoverCountsByEmployeeId` is a third of the same shape (applied, REQ-06) | | `grep -rn 'CountsByEmployeeId' apps` |
| Mobile review-timeline / `derive-ticket-progress-view.ts` showing paid time | none | no — Q3 | | `grep -rn payableWindow apps` |

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** No question is open: Q1–Q3 were answered by the owner on 2026-10-26; Q4–Q11 are decisions the plan already made. Q12–Q13 are out-of-scope dependencies owned by other cards (TCG-222, TCG-234) and block nothing here. Each is recorded so nobody re-asks it.

### Q1 — Which holdover days does the window-close chain reach?

- **Question:** The chain "break-down end → boom end → build-up end" closes the paid window on which holdover days?
- **Options:**
  - A. Yard-start Day-2+ middle days only
  - B. Every non-Home-start holdover day, including Day 1 and the last day
  - C. Every non-Home-start day except the last
  - X. Other — say what
- **Answer:** **B** — the chain governs every non-Home-start holdover day, Day 1 and the last day included, and resolves to the break-down end whenever one is recorded. Owner note: a break-down CAN occur on middle (non-last) days in holdover jobs, so the chain uses the recorded break-down end on ANY day it exists; "break-down skipped" is a possibility on any non-last day, not a rule that middle days have none. (Owner, 2026-10-26.)
- **Why it cannot be answered from what is written:** The plan gave the chain with no day scope; GAP-HO2 sub-questions 3–5 were open with TCG and the verified yard-to-yard note has no holdover exception. The owner decided.
- **Blocked:** none now — REQ-02, REQ-04 resolved
- **Candidates:** see the question as originally raised: DEC-YARD (12.2 KB, 2026-09-03); DEC-HOME (2.5 KB, 2026-10-16); `payroll/gaps.md` → *Holdover days 2+* (section read); the 2026-10-06 provisional Melissa note (`reference`, 31.8 KB); the files named in §11a rows 6–8.
- **Owner:** the owner (answered 2026-10-26; relayed by the coordinator)
- **Workaround, if any:** none needed
- **Status:** resolved — see decisions/2026-10-26-holdover-payable-window-close-reach.md (owner answer 2026-10-26; a pay rule overriding the verified 2026-09-03 yard-to-yard rule on holdover days; G4 provenance row added)

### Q2 — Home-start day end: resolving the contradiction in the 2026-10-16 note

- **Question:** What is the payable boundary on a Home-start holdover day, given the note's headline (Left Job Site) and body (closes at submit) disagree?
- **Options:**
  - A. Always Left Job Site; chain only for other days
  - B. The chain governs every holdover day including Home-start
  - C. Submit instant
  - X. Other — say what
- **Answer:** **X** — payable hours are measured **Start Work → End Work** (the employee's `WORK_TIME` own-window), where the End Work instant is the one the Q1 chain resolves. This supersedes both the note's "Left Job Site" headline and its "closes at submit" body as the payable boundary. Arrive On Site / Left Job Site remain job-site fields, not the payable boundary. (Owner, 2026-10-26.) Yard legs stay absent on Home-start days.
- **Why it cannot be answered from what is written:** `decisions/2026-10-16-home-start-holdover-paid-time-boundary.md` states two different ends; the plan used the headline. The owner settled it.
- **Blocked:** none now — REQ-03, REQ-08 resolved
- **Candidates:** see the question as originally raised: DEC-YARD (12.2 KB, 2026-09-03); DEC-HOME (2.5 KB, 2026-10-16); `payroll/gaps.md` → *Holdover days 2+* (section read); the 2026-10-06 provisional Melissa note (`reference`, 31.8 KB); the files named in §11a rows 6–8.
- **Owner:** the owner (answered 2026-10-26; relayed by the coordinator)
- **Workaround, if any:** none needed
- **Status:** resolved — see decisions/2026-10-26-home-start-holdover-payable-start-work-to-end-work.md (owner answer 2026-10-26). It partly supersedes the verified note `decisions/2026-10-16-home-start-holdover-paid-time-boundary.md` (payable boundary only); G4 provenance row updated

### Q3 — Do the other readers of the ticket's paid window follow the holdover window?

- **Question:** Should the crew-facing and labour-entry readers of the raw paid window show the holdover window too?
- **Options:**
  - A. Payroll pricing and the payroll explain screen only; every other reader keeps `WORK_TIME`
  - B. Pricing, explain and entry-fix plan
  - C. Every reader
  - X. Other — say what
- **Answer:** **A** — only payroll pricing and explain follow the holdover window. `ticket-worked-hours`, `ticket-labor-entries`, `ticket-time-entries.service`, `derive-ticket-progress-view` and `entry-fix-plan` keep reading the raw `payableWindow` unchanged. (Owner, 2026-10-26.)
- **Why it cannot be answered from what is written:** The plan scoped Part 1 to the engine input and assembler only; nothing said what happens to the other readers.
- **Blocked:** none now — §11a rows 6–8 settled
- **Candidates:** see the question as originally raised: DEC-YARD (12.2 KB, 2026-09-03); DEC-HOME (2.5 KB, 2026-10-16); `payroll/gaps.md` → *Holdover days 2+* (section read); the 2026-10-06 provisional Melissa note (`reference`, 31.8 KB); the files named in §11a rows 6–8.
- **Owner:** the owner (answered 2026-10-26; relayed by the coordinator)
- **Workaround, if any:** none needed
- **Status:** resolved — owner answer 2026-10-26, relayed by the coordinator (no decision note; low-stakes scoping, `tcg-scrum` may fold it into the Q1 note)

### Q4 — Holdover batch is display only and never blocks approval or export

- **Question:** Is the holdover batch informational only, with no new `PayrollFlag` detector and no block on approval or export?
- **Options:** n/a — decided
- **Answer:** Yes. Developer plan decision 1, 2026-10-26 (relayed in the request that created this folder).
- **Why it cannot be answered from what is written:** n/a — already decided by the plan author; recorded here so it is not re-asked. Source is the plan only; no decision note yet.
- **Blocked:** none (REQ-06 proceeds)
- **Candidates:** PLAN (`intent.md` §3)
- **Owner:** Syed Haris
- **Workaround, if any:** n/a
- **Status:** resolved — developer direction in `.ai/aidlc/HOLDOVER-PAYROLL/intent.md` §3 (decision note not yet written; `tcg-scrum` to record)

### Q5 — Batch lives on the employee timesheet page only; the worklist gets a count badge

- **Question:** Where does the holdover batch live?
- **Options:** n/a — decided
- **Answer:** The employee timesheet page only (`PayrollEmployeeTimesheet`); the worklist row gets a count badge and nothing else. Plan decision 2.
- **Why it cannot be answered from what is written:** n/a — decided.
- **Blocked:** none
- **Candidates:** PLAN
- **Owner:** Syed Haris
- **Workaround, if any:** n/a
- **Status:** resolved — developer direction in `intent.md` §3

### Q6 — PAY-049 per-non-worked-day subsistence is deferred

- **Question:** Is PAY-049 "every calendar day of the holdover, worked or not" built here?
- **Options:** n/a — decided
- **Answer:** No — deferred; no data source says which employee is held which day. Worked-day `subsistenceHoldover` is unchanged and the deferral is recorded in `payroll/gaps.md`. Plan decision 3.
- **Why it cannot be answered from what is written:** n/a — decided; consistent with the open vault gap *DAS holdover vs subsistence holdover — pointer* (owner Lisette Anzaldo with Corrina Bustos).
- **Blocked:** none (REQ-05)
- **Candidates:** PLAN; `payroll/gaps.md#das-holdover-vs-subsistence-holdover--pointer-owned-by-dispatch`; `payroll/rules/PAY-049-weekend-subsistence.md` (1.5 KB)
- **Owner:** Syed Haris
- **Workaround, if any:** n/a
- **Status:** resolved — developer direction in `intent.md` §3

### Q7 — Window-close precedence is break-down end → boom end → build-up end

- **Question:** What is the order of what closes the holdover window?
- **Options:** n/a — decided
- **Answer:** Break-down end, else boom end, else build-up end. Plan decision 4 (PAY RULE, G4). **Its reach by day is not decided — Q1; its composition with Home-start is not decided — Q2.**
- **Why it cannot be answered from what is written:** n/a — decided. Only source is the plan; no vault or decision note carries it, so the provenance row (G4) will read `Pending` until a decision note exists.
- **Blocked:** none for the chain itself (REQ-02)
- **Candidates:** PLAN
- **Owner:** Syed Haris
- **Workaround, if any:** n/a
- **Status:** resolved — see decisions/2026-10-26-holdover-window-close-precedence-breakdown-boom-buildup.md (pay rule; owner/plan decision 4; G4 provenance row added as `Confirmed`)

### Q8 — The no-yard / Arrive → Left treatment applies only to Home-start days

- **Question:** Does the Home-start (no yard leg) treatment reach Yard-start Day-2+ days?
- **Options:** n/a — decided
- **Answer:** No — only Home-start. Yard-start Day-2+ keeps the normal flow. Plan decision 5; consistent with DEC-HOME. Note: "normal flow" now means the yard leg still exists on Yard-start days; the paid-window END follows the REQ-02 chain on every holdover day (Q1-B).
- **Why it cannot be answered from what is written:** n/a — decided and verified for the Home-start part.
- **Blocked:** none (REQ-03)
- **Candidates:** `decisions/2026-10-16-home-start-holdover-paid-time-boundary.md` (verified); PLAN
- **Owner:** Syed Haris
- **Workaround, if any:** n/a
- **Status:** resolved — see decisions/2026-10-16-home-start-holdover-paid-time-boundary.md

### Q9 — 24h / long-boom / missing-notes: fix the window math, do not pre-change detectors

- **Question:** Are `INVALID_TIME_24H_OR_MORE`, `INVALID_LONG_BOOM_TIME`, `MISSING_NOTES` changed for holdover?
- **Options:** n/a — decided
- **Answer:** No pre-change. The window math is the fix; `MISSING_NOTES` is unchanged. Plan decision 6. (See REQ-07 Finding F1: only `24H` reads the priced window.)
- **Why it cannot be answered from what is written:** n/a — decided.
- **Blocked:** none (REQ-07)
- **Candidates:** PLAN; TF-SPEC Q8
- **Owner:** Syed Haris
- **Workaround, if any:** n/a
- **Status:** resolved — developer direction in `intent.md` §3

### Q10 — TICKET-FLOW Q8 stays resolved: three flag exemptions plus overlay; other readers confirmed at build

- **Question:** Do the other `YARD_TIME` readers get holdover special-casing?
- **Options:** n/a — decided
- **Answer:** No. Ship only the three REQ-15 exemptions and the overlay; confirm every other reader at build; a reader that still mis-fires is changed and recorded as a finding. TF-SPEC §12 Q8, resolved 2026-10-16 (plan decision 7).
- **Why it cannot be answered from what is written:** n/a — decided. Source is TF-SPEC, which is `[UNVERIFIED]` and states the answer was "resolved from the plan"; no decision note.
- **Blocked:** none
- **Candidates:** `.ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/spec.md` §12 Q8 (section read)
- **Owner:** Syed Haris
- **Workaround, if any:** n/a
- **Status:** resolved — see `.ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/spec.md` §12 Q8 (no decision note)

### Q11 — No new tests unless the developer asks

- **Question:** Are new tests written?
- **Options:** n/a — decided
- **Answer:** No. Run the existing ones.
- **Why it cannot be answered from what is written:** n/a — decided.
- **Blocked:** none
- **Candidates:** `decisions/2026-10-21-no-new-tests-unless-asked.md`; root `CLAUDE.md`
- **Owner:** Haris
- **Workaround, if any:** n/a
- **Status:** resolved — see decisions/2026-10-21-no-new-tests-unless-asked.md

### Q12 (dep) — Is a one-day job that runs past midnight a holdover?

- **Question:** Is a one-day job that runs past midnight a holdover?
- **Options:**
  - A. Yes — it becomes a holdover
  - B. No — it stays a single-day job
  - X. Other — say what
- **Answer:**
- **Why it cannot be answered from what is written:** **OPEN — out-of-scope client dependency, does NOT block HOLDOVER-PAYROLL U1–U3.** Owned by TCG-222, waiting on Lisette/Joe (out until 2026-11-03; holdover demo 2026-10-27). It intersects the overnight midnight split from PR #709 and the window-close chain (REQ-02): U1 prices whatever is flagged holdover server-side; it does not decide this. Source: coordinator's Trello summary, not read from the card.
- **Blocked:** nothing in this ticket
- **Candidates:** none read by this run (card TCG-222)
- **Owner:** Lisette / Joe (client), via TCG-222
- **Workaround, if any:** none needed
- **Status:** open — out-of-scope client dependency (TCG-222); does not block

### Q13 (dep) — Timezone correctness of the holdover day index

- **Question:** Is the holdover day index correct across timezones (TCG-234 reports a US-evening timezone bug in the DAS holdover badge)?
- **Options:** free answer — a fix or confirmation from TCG-234
- **Answer:**
- **Why it cannot be answered from what is written:** **OPEN — out-of-scope dependency, does NOT block HOLDOVER-PAYROLL U1–U3.** **RISK** for REQ-01/02: payroll reuses `dayIndexOf` (`service/job-holdover/holdover-days.util.ts`, which keys days by `toISOString().slice(0,10)`, i.e. UTC) via `resolveHoldoverForRows`; a wrong day index would mislabel Day d of D and, through `isLastDay`, mis-scope the chain. It is TCG-234's bug to fix, not U1's; U1 does not change the day-index logic. Source: coordinator's Trello summary; the code line is read, the bug itself was not reproduced.
- **Blocked:** nothing in this ticket
- **Candidates:** TCG-234 (not read by this run)
- **Owner:** TCG-234 owner
- **Workaround, if any:** none; re-check the batch (REQ-06) after TCG-234 lands
- **Status:** open — out-of-scope dependency (TCG-234); does not block

## 13. What this spec deliberately does not specify

- *(Settled 2026-10-26, no longer unspecified: chain reach by day — Q1-B; Home-start end — Q2; non-payroll readers — Q3-A.)*
- **What the engine does with the holdover field** beyond carrying it — no source asks for an engine-side rule.
- **Fallback when none of break-down / boom / build-up is closed** — ASSUMED existing `WORK_TIME` end (D8); a pay amount, to be confirmed at sign-off.
- **Whether already-approved or exported weeks are recalculated** after the rule ships — no source; existing recalculation-hold rules govern.
- **Batch/chip/badge/footnote copy** other than "Day d of D", "Clean", "Flagged"; **what "load-bearing" looks like**; **whether not-yet-priced (overlay) holdover tickets appear in the batch** — no source (REQ-06/08).
- **A submitted yard edge on a Home-start day** — ASSUMED 400 (REQ-09).
- **Correction behaviour when a Home-start day still carries a yard row** — ASSUMED yard fields stay visible (REQ-08).
- **Send-back popup** (`payroll-send-back-dialog.tsx`, `send-back-ticket.dto.ts`) and **`payroll-entry-fixes`** — deliberately unchanged per the plan (§11c follow-up).
- **Subsistence per non-worked day (PAY-049)** — deferred, Q6.
- **Proposed split of this change** (the spec is 9 REQs): (1) REQ-01/02/03/04/05/07 — payroll time math and flags (the pay rules; Q1–Q3 now answered, decision notes pending); (2) REQ-06 — the holdover batch and badge; (3) REQ-08/09 — the correction editor. Units 2 and 3 do not depend on the pay-rule unit.

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered (REQ-04 — Q1-B; REQ-02/REQ-03 — Q2; owner, 2026-10-26)
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` (none tagged)
- [ ] Answers written back into `spec.md` with their new sources and flags
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md` (Q1–Q3 answered by the owner 2026-10-26 but cite no decision note yet; Q4–Q7, Q9, Q10 cite the plan. **`tcg-scrum` to record decision notes for Q1-B, Q2 (partly supersedes the verified 2026-10-16 note) and Q7 — they are pay rules**)
- [ ] Every requirement's **Edges** fields are filled (`ASSUMED` allowed) or point at a §12 question — ASSUMED items to confirm: REQ-02 (open/absent entries → WORK_TIME end, multiple boom sessions → latest, own window wins), REQ-03 (no Start Work → MISSING_PAYABLE_WINDOW), REQ-08 (yard row present), REQ-09 (400 on yard edit), REQ-06 (overlay tickets excluded)
- [ ] Every §11a ripple row has a source for what happens to that consumer, or a §12 question (rows 7-8 settled by Q3-A; row 5 → §13)
- [ ] A developer has reviewed §11b and §11c (_Reviewed by_), and answered every `needs developer` row (D3 — G5 contract-tracer)
- [ ] G4: provenance rows added to `payroll/payroll-rules-provenance.md` for REQ-02/03/04 in the same commit as the code, after `tcg-scrum` writes the decision note(s)
- [ ] Decomposed into vertical units — `units.md`

Answered by: ______________  Date: ______________

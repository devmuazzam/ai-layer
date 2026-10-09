# Units — PAYROLL-FLAGS Flagged-entries rework, units U14–U21

> Written to `.ai/aidlc/PAYROLL-FLAGS/units-u14-u21.md` from the approved
> `spec-u14-u21.md` beside it (REQ-40–REQ-54). Follows the layout of `units.md`
> (U1–U5) in this same folder. Consumed by an executor, one unit at a time.
>
> **Nothing here has been implemented.** This file was produced by decomposition and
> then stopped on.

**Spec revision this file was cut from:** `spec-u14-u21.md` §14 sign-off — **15 requirements
(REQ-40–REQ-54), 0 verified, 14 unverified, 1 conflicted (REQ-53), 0 open.** Both §12 questions
(Q40, Q41) are `Status: resolved`, folded into REQ-44 and REQ-53 respectively. REQ-53's
`[CONFLICT]` is **not** resolved by the spec — F13/Round 10 (date-triggered, reference, what is
built) vs. `decisions/2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md`
clause 3 (`[VERIFIED]`, Corrina Bustos's own words, event-triggered) — and this file keeps that
conflict exactly as stated in U21, per the spec's explicit instruction not to pick a winner.

**Provenance of the units this file depends on, since three of the eight are not yet code:**

- **U1–U5** are `units.md` in this folder. U1, U2 are committed (`2f8fcf5c5`, `32da2afb3`). U3–U5
  are in progress on this branch (schema/routes for U3's void action and U5's `PayrollFlag`
  framework are not yet on disk as of this decomposition — confirmed by `grep -n "model
  PayrollFlag" apps/api/prisma/schema.prisma` returning nothing). Every citation below to
  `payroll-flag-detection.service.ts`, `PAYROLL_FLAG_CATALOG`, the flags web panel/chip, or the
  `{permission}` `RecipientSpec` variant is marked **introduced by U5** or **introduced by U1**
  and was not independently re-verified on disk — it is cited from `units.md`'s own U1/U5 slice
  contents, read in full for this decomposition.
- **U6–U13** are `spec-u6-u13.md` in this folder; `units-u6-u13.md` does not exist yet (being
  written concurrently, per this task's own instruction — not read as a finished decomposition,
  only the spec was read). Citations to U7 (`INVALID_TIME_OUT_OF_ORDER`, REQ-16), U8
  (`payroll-pricing` salvage + entry-fix form, REQ-19–21) and U13 (returned-ticket terminal-guard
  exemption, REQ-30) are marked **introduced by U7/U8/U13** and sourced to `spec-u6-u13.md`'s own
  requirement text, not to a units file that does not exist yet.
- **File paths and line numbers below were re-verified directly against the codebase on
  `feat/PAYROLL-FLAGS-foundation`** (current tip: `32da2afb3`, with U3's void migration and files
  present as uncommitted work — `apps/api/prisma/migrations/20260930190000_payroll_ticket_void/`
  is the newest migration on disk). `TicketWorkSegmentsService`/`TicketLunchBreaksService`'s
  `assertTicketNotTerminal` call sites, `job-tickets.service.ts`'s inline terminal array and
  `requiresReason` set, `checkBoomRange`, `TicketTimeAdjustment`'s schema, `PayrollSendBack`'s
  schema, `TicketTimeEntryType`, `PayrollTimeSource`, `Asset`/`SubCategory`/`Category`,
  `JobResourceAllocation.isHoldover`, `Address.latitude`/`.longitude`, `Yard`,
  `samsara.repository.ts`'s class doc and method set, `recipient-resolver.service.ts`'s
  `{permission}` variant (confirmed **already live**, built by committed U1), `payroll-admin`/
  `dispatch` in `PERMISSION_MODULES`, `notification-catalog.ts`'s channel-set precedents, and
  `apps/web/package.json`'s explicit test-file whitelist were all re-grepped for this
  decomposition, not trusted from the spec's own text. All of it checked out. `PayrollFlag`,
  `PayrollFlagEvent`, `PAYROLL_FLAG_CATALOG`, `payroll-flag-detection.service.ts`,
  `TicketEmployeeTimeOverride` and `SamsaraAssetDayEvent` do **not** exist on disk yet — expected,
  since U5/U19/U20 build them.

## Git layout — same branch, same PR, one commit per unit, after U13

Per this task's instruction (consistent with `units.md`'s own standing choice for U1–U5, and not
itself a new process decision): **all eight units ship on the single existing branch
`feat/PAYROLL-FLAGS-foundation`, as part of the same PR, one commit per unit**, landing **after**
U13's commit (whichever commit that ends up being — U6–U13 are not yet decomposed into their own
units file at the time of this write-up). Within U14–U21, this ledger commits them in **numeric
order — U14, U15, U16, U17, U18, U19, U20, U21** — which is a valid dependency-respecting order
(see *Sequencing*) and is the developer's own convention elsewhere in this ticket (`units.md`
built U1–U5 in numeric order too).

**Each unit's commit must still stand alone**: build, typecheck and pass its own new tests on top
of whatever every earlier commit on the branch already added, including all of U1–U13. Checking
out the branch at the tip of unit *N*'s commit must be a green, shippable state.

Dependency list, as given for this decomposition and matched against each requirement's own
Sources below:

- **U14 needs U13** — REQ-40/41's mobile self-edit reuses U13's (`spec-u6-u13.md` REQ-30) primary-
  only terminal-guard exemption mechanism; that mechanism does not exist before U13 ships.
- **U15, U16, U17 and U18 need U5** (U16 also needs U7) — all four extend
  `payroll-flag-detection.service.ts` and `PAYROLL_FLAG_CATALOG`, both introduced by U5; U16's
  `INVALID_TIME_AM_PM` additionally has to suppress U7's (`spec-u6-u13.md` REQ-16)
  `INVALID_TIME_OUT_OF_ORDER` for the same pair.
- **U19 needs U8** — REQ-48's `payroll-pricing`/`assembleWeek` read-path and REQ-49's web form both
  extend code U8 (`spec-u6-u13.md` REQ-19–21) introduces; neither exists before U8 ships.
- **U20 needs U5** — REQ-51's `SAMSARA_TIME_MISMATCH` writes to U5's `PayrollFlag` framework.
- **U21 needs U5 and U20** — REQ-53 writes to U5's framework and reads U20's
  `SamsaraAssetDayEvent` table; REQ-52 extends U20's own cron in place.

## What a unit is / Fill rules

Unchanged from `units.md`'s own statement — not repeated in full here. A unit is a vertical
shippable slice; a unit may not depend on an `[OPEN]` requirement (none here are `[OPEN]`);
`[UNVERIFIED]` constrains *how* a unit is built, never *whether*; `REQ-53 [CONFLICT]` is carried
into U21 exactly as the spec states it, not resolved by this decomposition.

## No foundation unit here either

Every schema change in this file (`TicketEmployeeTimeOverride`, U19; `SamsaraAssetDayEvent`,
U20) is consumed by exactly one later unit in this file (U19 itself; U20 and U21 respectively) —
neither crosses the "three or more later units" bar `units.md`'s own foundation-unit exception
requires. Both stay inside the vertical unit that needs them, same pattern U3/U5 already set.

---

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U14 | On a returned ticket, the primary employee can, from mobile, correct build-up/boom/break-down segment times and add/remove/switch lunch↔WTL slots (with WTL evidence), each with a mandatory reason and an audit trail — extending U13's exemption to two more services | REQ-40, REQ-41 | mobile, api | U13 | M | not started |
| U15 | Calculate raises a blocking `BOOM_OUT_OF_RANGE`/`RANGE_MISSING` flag from the already-computed boom-range check; the web replaces its old non-blocking badge with the shared flag chip | REQ-42 | api, web | U5 | S | not started |
| U16 | Calculate raises `INVALID_TIME_AM_PM` for a fixable-by-±12h out-of-order pair (suppressing U7's generic out-of-order flag for that pair) and `LABOR_TICKET_MISMATCH` when a member's own window differs from the ticket's by more than 30 minutes on the **total** of both edges (Q40) | REQ-43, REQ-44 | api | U5, U7 | M | not started |
| U17 | Calculate raises `MISSING_NOTES` when any of 5 trigger conditions holds and none of 5 note fields has content | REQ-45 | api | U5 | M | not started |
| U18 | Calculate groups a job's tickets by (job, date) and raises `CREW_YARD_TIME_MISMATCH` only for the crew on whichever ticket's Left Yard/Arrived at Yard disagrees with the rest | REQ-46 | api | U5 | M | not started |
| U19 | A Payroll Admin/Manager can, via U8's fix form, correct one crew member's yard/site/boom/lunch/segment time without moving the shared ticket row or any other member's pay; pricing reads the correction where one exists | REQ-47, REQ-48, REQ-49 | schema, api, web | U8 | L | not started |
| U20 | A guarded daily cron persists each tracked asset's first yard-exit, last yard-return and last engine-off instant from Samsara; Calculate raises `SAMSARA_TIME_MISMATCH` when a ticket's yard times disagree with it by more than 30 minutes — silent for untracked/silent assets | REQ-50, REQ-51 | schema, api | U5 | L | not started |
| U21 | Once a non-holdover job's last day has passed, a tracked crane not back in its derived departure yard raises a blocking flag for its crew and notifies every `dispatch`-permission holder — built to the date-triggered reading; the conflict with Corrina Bustos's verified event-triggered words is named, not resolved | REQ-52, REQ-53, REQ-54 | schema, api, shared, web | U5, U20 | L | not started |

- **Requirements not covered by any unit:** none. **15 requirements in `spec-u14-u21.md` §1 — 15
  covered.** 2 + 1 + 2 + 1 + 1 + 3 + 2 + 3 = 15. Each REQ lands whole in exactly one unit — the
  planner's own U14–U21 numbering, confirmed against every requirement's own Sources citations
  (`grep -n 'U1[4-9]\|U2[01]' spec-u14-u21.md`), already drew these boundaries requirement-by-
  requirement; this decomposition did not re-slice them.
- **Units blocked on an open question:** none. `spec-u14-u21.md` carries zero `[OPEN]`
  requirements at this revision — Q40 and Q41 are both `Status: resolved`. **REQ-53 (U21) carries
  `[CONFLICT]`, not `[OPEN]`** — a conflict does not block a unit the way an open question does;
  U21 is built, with the conflict named in its own Risk block, per the spec's explicit
  instruction.

---

## U14 — Worker self-edit on a returned ticket: segment timers, lunch and WTL

- **Outcome:** On a `COMPLETE` ticket with an open `PayrollSendBack` (`SENT_BACK`) for the
  ticket's primary employee, the primary can, from the mobile app, adjust any
  `BUILDUP_TIME`/`BOOM_TIME`/`BREAKDOWN_TIME` entry, and add, remove or switch a lunch between
  `LUNCH` (taken) and `WTL` (worked-through) — a switch to worked-through capturing the same
  customer-consent evidence (signer, signature, identity photo, GPS) the original mobile WTL
  flow requires. Every edit carries a mandatory reason and an audit trail, extending U13's
  primary-only terminal-guard exemption from the milestone path to two more services.
- **Kind:** vertical
- **Requirements covered:** REQ-40, REQ-41 — fully.
- **Depends on:** U13 (`spec-u6-u13.md` REQ-30, unbuilt — introduces the exemption this unit
  reuses: `TicketTimeAdjustment.requiresReason`'s extension and the terminal-guard carve-out for
  `COMPLETE` + open `SENT_BACK` + primary employee).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | **None.** `N/A — no migration.` | `TicketTimeAdjustment.stepKey` is a plain `VarChar(50)` (`schema.prisma:5061`, confirmed directly), not an enum — accepting segment/lunch-identifying values needs a validation-layer change only. |
| API (`apps/api`) | `apps/api/src/usecase/job-tickets/ticket-terminal-status.util.ts`: extend (or wrap) `assertTicketNotTerminal` with the same exemption predicate U13 builds (`COMPLETE` + open `SENT_BACK` + calling employee is the ticket's primary) — reuse U13's own mechanism, do not build a second one; confirm U13's exact exemption shape once it lands (unbuilt at time of this decomposition, only specced). `apps/api/src/usecase/ticket-work-segments/ticket-work-segments.service.ts`: the three `assertTicketNotTerminal(ticket.status)` call sites (`:95,142,232`, confirmed) each gain the exemption; refuse (403) a non-primary caller, refuse (409) with no open `SENT_BACK` row; each accepted edit requires a non-empty reason and writes a `TicketTimeAdjustment` row (`stepKey` proposed: `buildUp`/`boom:<sequence>`/`breakdown` — REQ-40's own proposed-not-sourced mechanism, option (a) over a second audit table). `apps/api/src/usecase/ticket-lunch-breaks/ticket-lunch-breaks.service.ts`: the `assertTicketNotTerminal(ticket.status)` call at `:177` (confirmed) gains the same exemption; add/remove/switch (existing operations, `MAX_LUNCH_BREAK_INDEX = 3` at `:45`, confirmed, unchanged) gain mandatory reason + the same `TicketTimeAdjustment` audit row; switch-to-`WTL` refuses without the evidence capture, written to `TicketSignature` at `wtl:<slotIndex>` (existing key, reused, not a new write path). `job-tickets.service.ts`'s own `requiresReason` set (`:813-814`, `{leftYard, arriveJob, leftJob, arriveYard}`) is **not** touched by this unit — that set governs `recordTicketStep`'s milestone steps only; segment/lunch edits are separate services with their own new reason requirement, flagged so the executor does not conflate the two. | Both service files' three+one guard call sites need the *same* exemption predicate applied consistently — a partial application (e.g. segments exempted, lunches not) would silently reintroduce the terminal refusal on whichever path REQ-41 actually needs, the same risk `spec-u6-u13.md` REQ-30's own Sources flag for its own two duplicated guards. |
| Shared (`packages/shared`) | None. | `N/A` — no new notification type; REQ-40/41 have no notification of their own (the resubmit endpoint and its notification belong to U13, not this unit). |
| Web (`apps/web`) | None. | `N/A` — REQ-40/41's surface is `mobile, api` only. |
| Mobile (`apps/mobile`) | `apps/mobile/features/field-ticket/timers/segment-time-adjust.ts:32` (`SEGMENT_TIME_ADJUST_ENABLED`, confirmed gated on `EXPO_PUBLIC_ENABLE_SEGMENT_TIME_ADJUST`): remove the dev-only env-flag gate for the returned-ticket condition specifically — `SegmentAdjuster` (`apps/mobile/features/field-ticket/steps/start-work/work-segments.tsx:161-222`, confirmed) becomes reachable whenever `segment.end !== null && onAdjust` (existing condition, `:325-332`) **and** the ticket is `COMPLETE` with an open `SENT_BACK` for the signed-in primary. Lunch-break UI gains add/remove/switch controls on the same condition, reusing the existing WTL evidence-capture screen/flow — `NOT SPECIFIED` whether this is the exact same component re-entered or a new entry point into it (REQ-41's own Notes); build the smallest reading (reuse) unless the existing flow assumes an unreturnable, in-progress ticket in a way that blocks reuse. Offline/background-sync behavior for a queued segment/lunch edit is `NOT SPECIFIED` — flag for the executor per `.ai/claude/contexts/mobile.md`'s standing caution. | Do not delete `EXPO_PUBLIC_ENABLE_SEGMENT_TIME_ADJUST`/the env var from build config in this unit — only the gate's effect for the returned-ticket condition changes; the dev-only path for a non-returned ticket, if anything still reads the flag elsewhere, is out of this unit's scope to remove (`grep -rn "SEGMENT_TIME_ADJUST_ENABLED\|ENABLE_SEGMENT_TIME_ADJUST" apps/mobile` before assuming there is only the one reader — the spec's own facts-agent finding, not independently re-run here). |
| Tests | **Integration (API):** segment edit endpoints refuse a non-primary employee (403) and refuse with no open `SENT_BACK` row (409); succeed for the primary with a reason on a returned ticket, writing a `TicketTimeAdjustment` row naming the initial/adjusted time and reason. Same three assertions for lunch add/remove/switch; switch-to-`WTL` additionally refuses without the evidence capture. **Regression:** a non-returned, non-`COMPLETE` ticket's segment/lunch edits behave exactly as before (still allowed, no reason required) — the exemption must not widen beyond the returned-ticket case. **Mobile:** `SegmentAdjuster` unreachable without the env flag for a non-returned ticket (existing behavior, now asserted); reachable without the flag for a returned ticket. | New API spec files under `apps/api/src/usecase/ticket-work-segments/` and `apps/api/src/usecase/ticket-lunch-breaks/` (existing test files for these services were not found by this decomposition's search — confirm before assuming greenfield vs. append). |

### Reviewable as

- **Demo:** send a `COMPLETE` ticket back (`PayrollSendBack`, `SENT_BACK`) for its primary
  employee → from mobile, as that primary, adjust a boom-session time with a reason → the ticket's
  `TicketTimeAdjustment` list shows the edit. Switch a lunch to worked-through → refused until the
  WTL evidence is captured, then accepted. The same calls as a non-primary crew member, or once
  the send-back is resolved → refused.
- **Acceptance:** REQ-40, REQ-41 acceptance lines in `spec-u14-u21.md` §2.
- **Reviewer can verify without:** U15–U21; **not** without U13 — the returned-ticket condition
  and the exemption mechanism this unit extends do not exist before it.

### Risk

- **Weakest source:** `[UNVERIFIED]` — Round 9 item G2 (*"the worker may edit the ticket times,
  the segment timers … and lunches / WTL"*) is `reference`, **settled CodingCops design, not
  pending** (product authorization, not a mechanism spec); REQ-41's WTL-evidence requirement is
  additionally grounded in `decisions/2026-09-29-…-rest-from-rounded-paid-time.md`'s verified
  *"individual"* framing plus C11's `reference`-tier pay-effect language, C11 itself scoped to the
  payroll correction page, not the mobile path — G2 is what extends it here.
- **Migration reversible:** `N/A` — no migration.
- **Behind a flag:** no — this unit **removes** an existing dev-only flag's effect for one
  condition; it does not add a new one.
- **Touches existing data:** no — a query/write-time exemption and a new audit-row shape reusing
  an existing table; no backfill.
- **Blast radius:** every `SENT_BACK`-open ticket's primary employee gains a new mobile capability
  the moment this ships — no grace period, no opt-in. Confined to tickets already in the
  send-back state (a Payroll Manager/Admin action, U8/U9's own gated surface), not every ticket.

**`[UNVERIFIED]` + no migration is routine.** One thing worth naming: this unit's entire mechanism
is built by extending U13's exemption, which does not exist yet at the time of this decomposition
— if U13 ships with a materially different exemption shape than `spec-u6-u13.md` REQ-30 currently
describes (e.g. a different guard consolidation, a different audit-row home), this unit's Slice
contents may need rework at build time. This is a sequencing risk carried from the dependency,
not a defect in this unit's own design.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `EXPO_PUBLIC_ENABLE_SEGMENT_TIME_ADJUST` dev gate and `SegmentAdjuster`'s existing dev-only reachability | direct removal, one condition only | this unit's own mobile test — the gate stays in force for a non-returned ticket; only the returned-ticket condition bypasses it | `spec-u14-u21.md` §11a row 1; `apps/mobile/features/field-ticket/timers/segment-time-adjust.ts:32` (code, verified directly) |
| `TicketLunchBreaksService`'s existing add/remove/switch operations (already the payroll correction page's own mechanism, per C11) | shared service, new caller added | this unit's own integration test — the worker's calls exercise the same operations without changing their existing behavior for the correction page's own calls (regression: any existing test file for this service, if one exists, is not reordered or removed) | `spec-u14-u21.md` §11a row 2; `decisions/2026-09-30-…-flagged-entry-gaps.md` §C11 (reference) |
| `ticket-work-segments.service.ts` / `ticket-lunch-breaks.service.ts`'s existing `assertTicketNotTerminal` call sites | terminal-guard exemption inserted at the same sites | this unit's own regression test — a ticket **not** matching the exemption condition (not `COMPLETE`, no open `SENT_BACK`, or a non-primary caller) is refused/allowed exactly as before | `apps/api/src/usecase/ticket-work-segments/ticket-work-segments.service.ts:95,142,232`; `apps/api/src/usecase/ticket-lunch-breaks/ticket-lunch-breaks.service.ts:177` (code, verified directly) |

### Deliberately not in this unit

- **Whether correcting `BREAKDOWN_TIME`'s end also moves `WORK_AT_JOB_SITE_TIME` (End Work)** —
  an existing open product question (C10), not blocking this unit per REQ-40's own Ripple field;
  not resolved here.
- **The exact `stepKey`/audit-row naming for segment and lunch edits** — a proposed mechanism
  (option (a), REQ-40 Notes), not a sourced one; flagged, not invented as settled.
- **Mobile offline/background-sync behavior for a queued edit** — `NOT SPECIFIED`, flagged for the
  executor, not built or assumed here.

---

## U15 — `BOOM_OUT_OF_RANGE` / `RANGE_MISSING` become a blocking flag

- **Outcome:** Calculate now raises a blocking, `OPEN` `PayrollFlag` — `BOOM_OUT_OF_RANGE` or
  `RANGE_MISSING` — for every crew member whose already-computed `TicketEmployee.boomRangeCheck`
  is `OUT_OF_RANGE` or `RANGE_MISSING`, replacing today's non-blocking web warning badge with the
  same flag chip every other detector in U5's framework uses.
- **Kind:** vertical
- **Requirements covered:** REQ-42 — fully.
- **Depends on:** U5 (`PayrollFlag` schema, `payroll-flag-detection.service.ts`, the detection
  pass hooked onto `executeRun`, and the flags panel/chip web components — none of this exists
  without it).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | None. | `N/A` — pure read of `TicketEmployee.boomRangeCheck`/`.boomRangeMessage`/`.boomRangeCheckedAt` (`schema.prisma:4756-4759`, confirmed already persisted, computed at Labor & Unit submission and re-checked after a correction). No migration. |
| API (`apps/api`) | `apps/api/src/usecase/payroll-flags/payroll-flag-detection.service.ts` (**introduced by U5**, `units.md` U5 Slice contents): add a `detectBoomRange` pass — `boomRangeCheck === 'OUT_OF_RANGE'` → raise/reconcile `PayrollFlag{code:'BOOM_OUT_OF_RANGE'}`; `=== 'RANGE_MISSING'` → `{code:'RANGE_MISSING'}`; `null`/`'IN_RANGE'` → nothing. Reuse U5's own fingerprint-reconciliation mechanism (`(tenantCompanyId, periodId, code, employeeId, subjectKey)`; `subjectKey` = the `TicketEmployee` id, since `boomRangeCheckedAt` changing is exactly what should reopen a `REVIEWED_NO_CHANGE` flag). **Do not modify `checkBoomRange`** (`apps/api/src/usecase/ticket-labor-entries/boom-range-check.ts`, confirmed unchanged, read-only consumer). Per REQ-42's own Notes, verify `payroll-send-backs.repository.ts`'s `countBlockingByEmployee` has no boom-range-specific carve-out before relying on `assertNoOpenSendBacks` being fully unrelated — confirmed unrelated by reading `payroll.service.ts:828-854` directly: the *"a boom-range flag alone does not [block]"* comment sits on the **separate**, soon-to-be-retired Crane-Supervisor send-back gate, not this mechanism. | No new computation anywhere in this unit — a straightforward read over an already-persisted field. |
| Shared (`packages/shared`) | `PAYROLL_FLAG_CATALOG` (`packages/shared/src/constants/payroll-flags.ts`, **introduced by U5**) gains `BOOM_OUT_OF_RANGE`, `RANGE_MISSING` entries — per-code title/subject, matching the catalog's established shape. | |
| Web (`apps/web`) | `apps/web/src/features/payroll/**/payroll-employee-table.cells.tsx:157-184` (`TicketCell` flag icon, confirmed) and `payroll-employee-table.expanded.tsx:121-139` (`EntryReviewState` banner, confirmed): remove the boom-range-specific non-blocking badge/banner; the two new codes render automatically through U5's shared flag chip (**introduced by U5**, catalog-driven) — no new component needed. | |
| Mobile (`apps/mobile`) | None. | `N/A` — REQ-42's surface is `api, web` only. |
| Tests | **Unit (API):** `checkBoomRange` output → correct flag code or none (`OUT_OF_RANGE`→flag, `RANGE_MISSING`→flag, `IN_RANGE`/`null`→nothing) — `spec-u14-u21.md` §10's own row. Reconciliation: a member whose `boomRangeCheck` flips from `OUT_OF_RANGE` to `IN_RANGE` across two Calculate runs auto-`FIXED`s the flag (reuses U5's own reconciliation mechanism — do not re-test U5's general mechanism, only this detector's code mapping into it). **Integration:** `approveEmployee` refused on an `OUT_OF_RANGE`/`RANGE_MISSING` member. **Web:** the old boom-range-specific badge/marker is gone; the shared chip renders the new codes — grep for the old badge's copy/testid to confirm removal, not just addition. | |

### Reviewable as

- **Demo:** a ticket with a boom bracket selected outside the crane's min/max range → existing
  Labor & Unit submission already sets `boomRangeCheck = 'OUT_OF_RANGE'` → run Calculate → `GET
  periods/:id/flags` shows one `OPEN` `BOOM_OUT_OF_RANGE` → `approveEmployee` refused.
- **Acceptance:** REQ-42 acceptance lines in `spec-u14-u21.md` §2.
- **Reviewer can verify without:** U16–U21; **not** without U5, and not meaningfully without a
  ticket whose `boomRangeCheck` is already computed (existing, unrelated mechanism).

### Risk

- **Weakest source:** `[UNVERIFIED]` — the basis question (crane's own min/max range vs. a
  job/sales-configured range) is Round 9 item F1, `reference`, **explicitly not Corrina's own
  direct either/or answer** — she was asked twice and her assent (the verified flag-list note)
  confirms "these are correct" and "all will need fixing," not which basis. F1 is the developer's
  chosen basis to build against, matching what `checkBoomRange` already computes today.
- **Migration reversible:** `N/A` — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no rows written by a migration; Calculate begins raising this flag
  against already-existing `OUT_OF_RANGE`/`RANGE_MISSING` conditions in live data from the first
  run after this ships.
- **Blast radius:** every tenant's next Calculate run raises this flag wherever the condition
  already exists today, blocking those weeks **unconditionally** per U5's REQ-11 (no per-tenant
  override) — the same shape as U5's own `OVERLAPPING_JOBS`, compounding it.

**`[UNVERIFIED]` + no migration is routine — no pre-build raise for the schema.** One thing worth
naming: the basis question (F1) stays open in `payroll/gaps.md` Q6 regardless of this unit
shipping — this unit builds the reading `checkBoomRange` already computes today, so it is correct
under the status quo; if Corrina answers the basis question the other way later, `checkBoomRange`
itself (not this unit) would need to change, and this detector would inherit that change
automatically since it only reads the result — a standing risk the underlying check already
carries, not new here.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Boom-range web badge (`payroll-employee-table.cells.tsx:157-184`, `.expanded.tsx:121-139`) | direct component reuse | this unit's own web test — the old badge/banner is gone, replaced by the shared chip | `spec-u14-u21.md` §11a row 3 |
| `assertNoOpenSendBacks` / `countBlockingByEmployee` (`payroll.service.ts:828-854`) | adjacent gate, same approval flow | this unit's own integration test asserts this function is **unmodified and unrelated** — confirmed by reading it directly, per REQ-42's own instruction to verify | `payroll.service.ts:828` (code, verified directly) |

### Deliberately not in this unit

- **Changing the basis of `checkBoomRange`** (crane min/max vs. job/sales range) — F1's basis
  question is unresolved (`payroll/gaps.md` Q6); this unit reads the existing computed value
  as-is.
- **Any change to `assertNoOpenSendBacks`/the Crane-Supervisor send-back gate** — a separate,
  soon-to-be-retired mechanism (`spec-u6-u13.md` U9, out of scope here).

---

## U16 — `INVALID_TIME_AM_PM` and `LABOR_TICKET_MISMATCH` detectors

- **Outcome:** Calculate raises `INVALID_TIME_AM_PM` for a captured time pair that is out of
  order but would be put back in order by a ±12-hour shift on one instant, suppressing U7's
  generic `INVALID_TIME_OUT_OF_ORDER` for that same pair. Calculate also raises
  `LABOR_TICKET_MISMATCH` for a crew member whose own labor window differs from the ticket's
  Start Ticket→End Ticket window by more than 30 minutes on the **total** of both edges combined
  (Q40, resolved — not per edge).
- **Kind:** vertical
- **Requirements covered:** REQ-43, REQ-44 — fully.
- **Depends on:** U5; **U7** (`spec-u6-u13.md` REQ-16, unbuilt — introduces
  `INVALID_TIME_OUT_OF_ORDER`, the detector this unit's AM/PM check must suppress for the same
  pair, and the existing step-order check both key off).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | None. | `N/A` — both detectors read existing captured/persisted fields. |
| API (`apps/api`) | `payroll-flag-detection.service.ts` (**introduced by U5**) gains two detectors. **`detectInvalidTimeAmPm`:** for each captured pair U7's out-of-order check examines (a milestone window, a `WORK_TIME`/member-window edge, or a `BOOM_TIME` session — reuse the same pair enumeration **introduced by U7**, keyed off the existing `findWindowOrderViolation` (`apps/api/src/usecase/ticket-time-entries/validate-step-times.ts:253-283`, confirmed present) that both detectors build on), test whether shifting either instant ±12h restores order (test both directions on both instants per REQ-43's own Notes — a false negative here just falls through to the generic flag anyway); if so, raise `INVALID_TIME_AM_PM` and suppress `INVALID_TIME_OUT_OF_ORDER` for that pair. **`detectLaborTicketMismatch`:** for each `TicketEmployee` with `workStartedAt`/`workEndedAt` set, compute `\|own start − Start Ticket\| + \|own end − End Ticket\|`; sum `> 30 min` → raise `LABOR_TICKET_MISMATCH` naming both windows and the total gap — **the total-difference rule (Q40/Round 11), not per-edge**, the case a 20-min start offset plus a 20-min end offset (40 min total, neither edge alone over 30) must flag. A member with no own window set raises nothing (confirmed: `buildJobDay`'s existing fallback, `payroll.service.ts:1257-1430`/`derive-ticket-times.ts:285,311`, already reads the ticket's `WORK_TIME` as that member's own window in that case — nothing to diff). | The AM/PM-suppression coordination with U7 is **cross-file** — `spec-u14-u21.md` cannot edit `spec-u6-u13.md`'s file. This unit builds **both halves** of the suppression on its own side (compute the AM/PM case, and mark/suppress the pair for U7's detector to skip) rather than assuming U7's detector will itself check for this — see Risk. |
| Shared (`packages/shared`) | `PAYROLL_FLAG_CATALOG` (**introduced by U5**) gains `INVALID_TIME_AM_PM`, `LABOR_TICKET_MISMATCH`. | |
| Web (`apps/web`) | None beyond generic flag-chip rendering (**introduced by U5**) picking up the two new codes automatically via the catalog. | No new component. |
| Mobile (`apps/mobile`) | None. | `N/A` — REQ-43/44's surface is `api` only. |
| Tests | **Unit:** an AM/PM-fixable out-of-order pair raises `INVALID_TIME_AM_PM` and **not** `INVALID_TIME_OUT_OF_ORDER` for the same pair; a non-fixable out-of-order pair raises only the latter — **this half of the test needs U7's real detector present to prove the "and not" side meaningfully; if U7 has not shipped when this unit is built, assert against this unit's own suppression marker and flag it for re-verification once U7 lands** (see Risk). `LABOR_TICKET_MISMATCH` fires at a 31-minute total, not at 30 or below; **fires** for a 20-min + 20-min split (40 min total) — the explicit regression against the per-edge default this spec originally proposed. **Integration:** `approveEmployee` refused on either flag. | |

### Reviewable as

- **Demo:** a `WORK_TIME` pair entered with swapped AM/PM (out of order, fixable by ±12h) →
  Calculate → `GET flags` shows `OPEN` `INVALID_TIME_AM_PM`, no `INVALID_TIME_OUT_OF_ORDER` for
  the same pair. A member with an own window 20 minutes early and 20 minutes late vs. the ticket
  → Calculate → `OPEN` `LABOR_TICKET_MISMATCH`.
- **Acceptance:** REQ-43, REQ-44 acceptance lines in `spec-u14-u21.md` §2, including Q40's
  resolved total-difference test case.
- **Reviewer can verify without:** U15, U17–U21; **not** without U5, and **not fully** without
  U7 — REQ-43's "does not additionally raise" half of its acceptance needs U7's own detector to
  exist to prove against (see Risk).

### Risk

- **Weakest source:** `[UNVERIFIED]` both. REQ-43's AM/PM mechanism is Round 9 item F2,
  `reference`, pending Corrina Bustos — her own verified words confirm "wrong AM/PM" as a named
  check but not the ±12h detection rule. REQ-44's total-difference rule is Round 11 (Q40's
  resolution), `reference`, pending Corrina Bustos, and explicitly **reverses** this spec's own
  originally-proposed per-edge default.
- **Migration reversible:** `N/A` — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no rows written by a migration; Calculate raises these flags against
  existing live data from the first run after this ships.
- **Blast radius:** every tenant's next Calculate run raises `INVALID_TIME_AM_PM`/
  `LABOR_TICKET_MISMATCH` wherever the condition already exists, blocking those weeks
  unconditionally — same shape as U15.

**`[UNVERIFIED]` + no migration is routine.** One thing worth raising explicitly: REQ-43's
suppression of U7's flag is a genuine cross-file coordination point neither spec file can close
alone (`spec-u14-u21.md` §11a row 4's own words). **If U7 ships first without building its own
half of the suppression, this unit's commit must implement both sides** (compute the AM/PM case
and suppress the other flag itself — e.g. run before U7's detector in the same pass and mark the
pair) since this file cannot edit `spec-u6-u13.md`/U7's code after the fact without a named
follow-up unit. Flag for the executor to check `units-u6-u13.md`'s actual REQ-16 build (once it
exists) before assuming which side owns the suppression.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `spec-u6-u13.md` REQ-16's `INVALID_TIME_OUT_OF_ORDER` detector (**introduced by U7**, unbuilt at time of this decomposition) | shared "which flag wins for this pair" logic | this unit's own unit test asserts the pair is not double-flagged **on this unit's own side**; full regression against U7's real detector requires U7 to exist — re-verify once it lands, per Risk | `spec-u14-u21.md` §11a row 4; `spec-u6-u13.md` REQ-16 |
| `buildJobDay`'s existing own-window fallback (`payroll.service.ts:1257-1430`, `derive-ticket-times.ts:285,311`) | read-only, unaffected | none needed — this unit only reads `workStartedAt`/`workEndedAt`, writes nothing | `payroll.service.ts` (code, verified directly) |

### Deliberately not in this unit

- **Editing `spec-u6-u13.md`/U7's own code directly** — out of this file's write scope; the
  suppression is built on this unit's own side, flagged for cross-file confirmation once U7 ships
  (see Risk).
- **The per-edge `LABOR_TICKET_MISMATCH` reading** — explicitly superseded by Q40's answer; not a
  fallback, not configurable, not a follow-up.

---

## U17 — `MISSING_NOTES` detector

- **Outcome:** Calculate raises `MISSING_NOTES` for a crew member's entry whenever any of five
  trigger conditions holds (a captured time was adjusted; a lunch was worked through; any other
  flag is `OPEN` on the entry; the ticket's `WORK_TIME` span exceeds 12 hours; the worker marked a
  checklist issue) and none of five note fields anywhere on the ticket for that member has
  content.
- **Kind:** vertical
- **Requirements covered:** REQ-45 — fully.
- **Depends on:** U5.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | None. | `N/A`. |
| API (`apps/api`) | `payroll-flag-detection.service.ts` (**introduced by U5**) gains `detectMissingNotes`, run **last** in the per-employee detection pass for a given Calculate run — it must read every other detector's just-written `PayrollFlag` rows for trigger (c). Checks: (a) a `TicketTimeAdjustment`/segment-audit row exists for this member (REQ-40/41, **introduced by U14**, plus the existing milestone path) (b) a `WTL` `TicketTimeEntry` row exists for this member (c) any `PayrollFlag` **other than `MISSING_NOTES` itself** is `OPEN` on this member's entry — self-reference explicitly excluded, per REQ-45's own Notes, to avoid the circular case where clearing the note un-triggers the very flag that required it (d) the ticket's `WORK_TIME` span is `> 12h` (e) `ChecklistItemAnswer.result != 'PASS'` (`schema.prisma:5254-5273`, confirmed) on this ticket. "A note" = any non-empty of `TicketEmployee.laborComments` (`:4740`), `JobTicket.leftYardComment` (`:4667`), a `TicketComment` row (`:4790-4806`), `TicketSignature.comments` (`:4830`), `TicketTimeAdjustment.reason` (`:5064`, `NOT NULL` already) — all five confirmed present. | **Detector-ordering requirement, new information this unit surfaces, not sourced:** trigger (c) needs every other flag-writing detector's output for the *same* Calculate pass already committed before this one runs. At this unit's own build time (after U5, U15, U16, U18 — see Sequencing), trigger (c) is only complete against the detectors that exist then; U19's override table writes no flag (not relevant), but U20/U21's detectors (built later) also feed trigger (c) once they ship — flagged in Risk, not fixed here. |
| Shared (`packages/shared`) | `PAYROLL_FLAG_CATALOG` (**introduced by U5**) gains `MISSING_NOTES`. | |
| Web (`apps/web`) | None beyond the generic flag chip (**introduced by U5**), naming which trigger(s) fired in the flag's `detail`/`message` — build the minimum shape U5's `PayrollFlag.detail` already supports (`NOT SPECIFIED` beyond "human-readable text plus structured detail", per `units.md` U5's own Notes). | |
| Mobile (`apps/mobile`) | None. | `N/A` — capture-time validation is explicitly `NOT SPECIFIED`/out of scope per REQ-45's own Notes; this unit builds the Calculate-time flag only. |
| Tests | **Unit:** each of the 5 triggers fires independently when all 5 note fields are empty; cleared by any one non-empty field, regardless of which trigger fired or which field was filled; trigger (c)'s self-reference exclusion verified explicitly (a member whose only `OPEN` flag is `MISSING_NOTES` itself does not re-trigger itself). **Integration:** `approveEmployee` refused on an `OPEN` `MISSING_NOTES`. | `spec-u14-u21.md` §10's own row for this REQ. |

### Reviewable as

- **Demo:** a ticket with a `WORK_TIME` span over 12 hours and every note field empty for a
  member → Calculate → `OPEN` `MISSING_NOTES` naming trigger (d). Add any one note field → Calculate
  → cleared.
- **Acceptance:** REQ-45 acceptance lines in `spec-u14-u21.md` §2.
- **Reviewer can verify without:** U15, U16, U18–U21; **not** without U5. Trigger (a)'s full
  coverage of segment/lunch adjustments (as opposed to only the existing milestone path) needs
  U14 to exist for that half to be exercisable — this unit does not *depend* on U14 (it is
  additive either way: zero segment-adjustment rows simply means trigger (a) never fires from that
  source yet), but a reviewer testing trigger (a) specifically against a segment edit needs U14
  on the branch.

### Risk

- **Weakest source:** `[UNVERIFIED]` — Round 9 item F5, developer verbatim, pending Corrina
  Bustos; the source note itself states plainly: *"No register entry asks this. The flag's only
  other written source is the unverified Confluence KPI 'Entries with Notes Missing.'"* The
  weakest-grounded detector in this file by the note's own admission.
- **Migration reversible:** `N/A` — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** every tenant's next Calculate run raises `MISSING_NOTES` wherever any trigger
  already holds with no note recorded, blocking those weeks unconditionally.

**`[UNVERIFIED]` + no migration is routine.** The detector-ordering note above is the load-bearing
risk for this unit specifically, not a migration/reversibility issue: **trigger (c) is only as
complete as the set of flag-writing detectors that exist at the time a given Calculate run
executes.** This unit's own tests can only exercise trigger (c) against the detectors on the
branch at its own commit (U5's `OVERLAPPING_JOBS`, U15's boom-range codes, U16's AM/PM and
labor-mismatch codes, U18's crew-yard-mismatch). **U20's `SAMSARA_TIME_MISMATCH` and U21's
`ASSET_NOT_RETURNED_TO_DEPARTURE_YARD` do not exist yet at this unit's build time** — trigger (c)
is silently incomplete against them until those units ship, and no later unit in this file
re-tests trigger (c) against them either (flagged again under U20/U21's own Deliberately-not
sections). This is not a defect in this unit's build — it is a known, honestly-stated gap in test
coverage that closes itself automatically once U20/U21 ship (the detector reads `PayrollFlag`
generically, not by an enumerated code list), but nothing re-proves it with a test.

### Ripple — what already works that this unit reaches

`none — new detector, additive` (established by: `grep -rn "MISSING_NOTES" apps/api/src
apps/web/src apps/mobile packages/shared/src` returning no hits before this spec, per
`spec-u14-u21.md`'s own finding, not independently re-run here).

### Deliberately not in this unit

- **Mobile capture-time note enforcement** — explicitly `NOT SPECIFIED`/out of scope per REQ-45's
  own Notes; this unit builds the Calculate-time flag only.
- **Re-testing trigger (c) against U20/U21's detectors** — those units do not exist at this
  unit's build time; a known gap in this unit's own test coverage, to close once U19–U21 ship (see
  Risk). Not deferred to a named follow-up unit because the mechanism itself needs no further
  code change — only a test that could not be written yet.

---

## U18 — `CREW_YARD_TIME_MISMATCH` detector

- **Outcome:** Calculate groups a job's tickets by `(jobId, date)` and compares each ticket's
  Left Yard/Arrived at Yard time against the group's consensus value — any difference flags, no
  tolerance — holding only the crew on whichever ticket(s) disagree, not the whole group.
- **Kind:** vertical
- **Requirements covered:** REQ-46 — fully.
- **Depends on:** U5.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | None. | `N/A`. |
| API (`apps/api`) | `payroll-flag-detection.service.ts` (**introduced by U5**) gains `detectCrewYardTimeMismatch`: a **new** query grouping `JobTicket` rows by `(jobId, date)` via each ticket's `SubJob → JobScheduleInterval.date` (`schema.prisma:3772-3832`, confirmed) — no existing "one job, one day, every ticket" query was found (`DasRepository.getSubJobsByDate`, `apps/api/src/service/das/das.repository.ts:717-753`, confirmed the closest precedent, not exact); build new. Compare `YARD_TIME.startedAt`/`.endedAt` (`TicketTimeEntry`, confirmed single-instance per ticket, **no `employeeId`** — `schema.prisma:5003-5035`, so a mismatch is always between tickets in the group, never within one) across the group. Consensus = the most common exact instant among the group's tickets (**proposed, not sourced** — REQ-46 Notes); on an exact tie, flag every ticket in the group (**proposed default**, the safer reading for a blocking review flag). Raise one `PayrollFlag` per `TicketEmployee` on each differing ticket, all sharing one `groupKey` (e.g. `crew-yard:<jobId>:<date>`) — matches `PayrollFlag.employeeId`'s **not-nullable** shape (**introduced by U5**, `spec.md` §3), which is exactly why Round 10's "only the mismatching workers" answer fits this schema and F7's original "one ticket-level flag, blocks everyone" draft would not have. | `YARD_TIME` is captured to the instant — "any difference" means exact inequality, not a rounded/bucketed comparison, per REQ-46's own Notes. |
| Shared (`packages/shared`) | `PAYROLL_FLAG_CATALOG` (**introduced by U5**) gains `CREW_YARD_TIME_MISMATCH`. | |
| Web (`apps/web`) | None beyond the generic flag chip (**introduced by U5**). | |
| Mobile (`apps/mobile`) | None. | `N/A`. |
| Tests | **Unit:** groups tickets correctly by `(jobId, date)`; flags only the minority ticket(s)' crew, not the whole group; an even split (e.g. two tickets, two different times) flags every ticket in the group (the tie case). **Integration:** `approveEmployee` refused for the differing ticket's crew, not for the matching ticket(s)' crew. **E2E/manual:** a crew ticket's Left Yard mismatch flags only the differing ticket's crew; the rest approve normally — `spec-u14-u21.md` §10's own row. | |

### Reviewable as

- **Demo:** three tickets on one job/date, two share a Left Yard instant, one differs → Calculate
  → `OPEN` `CREW_YARD_TIME_MISMATCH` for the differing ticket's crew only; the other two tickets'
  crews approve normally.
- **Acceptance:** REQ-46 acceptance lines in `spec-u14-u21.md` §2.
- **Reviewer can verify without:** U15–U17, U19–U21; **not** without U5.

### Risk

- **Weakest source:** `[UNVERIFIED]` overall, though two of its three underlying facts are
  `[VERIFIED]`: item 8 of the flag list (*"Crew times not matching"* exists as a flag) and
  *"any difference [flags]"* (no tolerance, Corrina's own words, asked explicitly about a
  legitimate-seeming difference and still confirmed) are both `[VERIFIED]`. The grouping rule
  (F6, same job + same date) and the per-worker-not-per-ticket narrowing (Round 10, superseding
  F7's own "to confirm" hedge) are both `reference`, pending Corrina Bustos. **The consensus/tie-
  break algorithm is this decomposition's own unsourced proposal**, carried from REQ-46's Notes,
  not a client or developer statement at all.
- **Migration reversible:** `N/A` — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** every tenant's next Calculate run raises this flag wherever a job/date group
  already disagrees on Left Yard/Arrived at Yard, blocking the differing tickets' crews
  unconditionally.

**`[UNVERIFIED]` + no migration is routine.** The consensus/tie-break rule is the one genuinely
unsourced design choice in this unit — build the proposed default, name it plainly in code
comments as a proposal, and treat any future correction to the algorithm itself as a behavior
change worth flagging, not a bug fix to slip in quietly.

### Ripple — what already works that this unit reaches

`none — new read-only detector over existing `YARD_TIME` data, writes nothing to
`TicketTimeEntry`` (established by: `TicketTimeEntry` schema read directly, confirmed unaffected
— `spec-u14-u21.md` §11a row 5).

### Deliberately not in this unit

- **A tolerance window** — REQ-46's own text and Corrina's own verified words: *"any difference
  [flags]"*, no tolerance, confirmed even when asked about a legitimate-seeming reason for a
  difference (e.g. an oiler staying to break down).

---

## U19 — Per-employee time override: schema, pricing read, fix-form fields

- **Outcome:** On a crew ticket (2+ roster members), a Payroll Admin/Manager can, via U8's fix
  form, correct one employee's yard, site, boom, lunch or segment time without moving the shared
  ticket row or changing any other crew member's pay. Pricing — `buildJobDay` now, and the
  salvaged `payroll-pricing` assembly once U8 lands — reads that correction in preference to the
  shared value wherever one exists.
- **Kind:** vertical
- **Requirements covered:** REQ-47, REQ-48, REQ-49 — fully.
- **Depends on:** U8 (`spec-u6-u13.md` REQ-19/20/21, unbuilt — introduces the fix form this
  unit's web half extends, and the `payroll-pricing`/`assembleWeek` salvage REQ-48's second
  read-path needs; neither exists before U8 ships. `plan.json`'s `dependsOn: ["U8"]` for this
  unit is confirmed, per `spec-u14-u21.md`'s own finding, stronger than an informal "related to"
  framing).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | New `TicketEmployeeTimeOverride` model, exactly per `spec-u14-u21.md` §3/REQ-47's Notes: `id`, `tenantCompanyId`, `ticketEmployeeId`, `type TicketTimeEntryType` (reuses the existing enum as-is, confirmed all 8 needed kinds already have a member — `schema.prisma:4983-5000`), `sequence Int?`, `startedAt DateTime?`, `endedAt DateTime?`, `reason String @db.Text` (`NOT NULL`, matching `TicketTimeAdjustment.reason`'s own pattern), `createdByUserId`, `createdAt`; `@@unique([ticketEmployeeId, type, sequence])`. `PayrollTimeSource` (`schema.prisma:232-237`, confirmed currently `EMPLOYEE_WORK_WINDOW \| TICKET_WORK_TIME`) gains a third member, `EMPLOYEE_OVERRIDE`, same migration. No business code, no `@@unique([tenantCompanyId, …])` — a system-generated, workflow row, same no-code precedent `PayrollFlag`/`PayrollSendBack` already set. Migration `apps/api/prisma/migrations/20260930200000_ticket_employee_time_overrides/migration.sql` (timestamp later than the branch's newest on-disk migration, `20260930190000_payroll_ticket_void`) — purely additive, one new table, one new enum member, no backfill. `apps/api/src/orm/prisma.service.ts`: add `ticketemployeetimeoverride` to the `$extends` tenant-scoping allowlist, same commit — confirmed the allowlist block already holds `payrollsendback` (`:130`) and `ticketemployee` (`:156`), the same pattern to follow. | **Migration name is a placeholder, not sourced** — pick a real timestamp later than every migration on the branch at build time, not necessarily this exact one. |
| API (`apps/api`) | New `POST .../ticket-employees/:id/time-overrides` — new controller/use-case/repository (`NOT SPECIFIED` exact folder; propose a dedicated `apps/api/src/{presentation,usecase,service}/ticket-employee-time-overrides/` module family, matching the codebase's one-feature-per-folder convention), `create-ticket-employee-time-override.dto.ts { type: TicketTimeEntryType, sequence?: number, startedAt?: string, endedAt?: string, reason: string }`, `reason` required via `@IsNotEmpty()` (Round 9 G1), gated `@RequirePermission('payroll-admin', 'edit')` (matching REQ-01/U1's established role). Refuse (400) without a reason. Refuse (**409, proposed**) creating a second *active* override for the same `(ticketEmployeeId, type, sequence)` — this spec's own proposed default is a new row each time, not an update-in-place (REQ-47 Notes); `NOT SPECIFIED` which, flag for confirmation, but pick one and be consistent. `apps/api/src/usecase/payroll/payroll.service.ts buildJobDay` (`:1349-1430`, confirmed present and already branching per-member) gains a read: for each captured type the member has, look up an active `TicketEmployeeTimeOverride` by `(ticketEmployeeId, type, sequence)` and use it in preference to the shared `TicketTimeEntry`/`workStartedAt`/`workEndedAt` value; sets `timeSource = EMPLOYEE_OVERRIDE` when used. **Once U8's `payroll-pricing`/`assembleWeek` module exists on the branch** (**introduced by U8**, confirmed not present today — `grep -rn "assembleWeek" apps/api/src` per the spec's own facts-agent finding, not independently re-run here since this unit is sequenced after U8), extend its per-person read path identically — this half cannot be built or tested before U8 lands, which this unit's own dependency guarantees by the time its commit is written. Enforce the disjointness boundary REQ-48's Notes name (**proposed, not sourced**): refuse creating an override on a one-employee-roster ticket, directing that case to U8's own direct-edit path instead — flag for confirmation. | The refusal-code choices (409 for a duplicate active override, 400 for a missing reason) are this unit's own proposal, consistent with U3/U4's own pattern of "pick one and be consistent with the review/incomplete-ticket errors" (`units.md` U3's own Notes). |
| Shared (`packages/shared`) | None new — `TicketTimeEntryType` is reused as-is; no new notification type. | |
| Web (`apps/web`) | Extend U8's fix form (**introduced by U8**, `apps/web/src/features/payroll/entry-fix/` or wherever U8's actual build lands it — `spec-u6-u13.md` REQ-21, unbuilt at time of this decomposition) with a per-crew-member selector, shown only on a crew ticket (2+ `TicketEmployee` rows); selecting a member exposes yard/site/boom/lunch/segment time fields that `POST` to this unit's new override endpoint for that member, instead of U8's one-person direct-edit path. react-hook-form + Zod, per convention. `NOT SPECIFIED`: exact layout/copy, and whether all five time categories appear in one unified per-person section or five separate ones (REQ-49's own Notes) — build the smallest reading, reusing U8's component structure per `.ai/claude/contexts/web.md` (search before creating). | This is the one layer in this unit that **cannot be finalized independently of U8's own, currently-unbuilt, form design** — `spec-u14-u21.md` itself marks REQ-49's Ripple field `OPEN — cannot be fully stated until U8 is built`, not a stated default, distinct from every other `NOT SPECIFIED` item in this file. |
| Mobile (`apps/mobile`) | None. | `N/A`. |
| Tests | **Unit (API):** an override for `(ticketEmployeeId, type, sequence)` is read by `buildJobDay` in preference to the shared value; absence falls back correctly; **a different employee's pricing on the same ticket is unaffected** — the core "individual, not crew-wide" proof REQ-48's Sources require. **Integration (API):** override creation refuses without a reason; refuses on a one-employee-roster ticket (proposed boundary); refuses below `payroll-admin: edit`; a created override is read back correctly by the next Calculate. **Web:** the fix-form's per-crew-member selector appears only on a crew ticket; a per-person save writes to the override endpoint, not the shared ticket row (assert the shared `TicketTimeEntry`/`WORK_TIME` row is byte-for-byte unchanged after a per-person save) — **this test cannot be written meaningfully until U8's actual fix-form component exists; build it against U8's real component, not a stub, since this unit's own dependency guarantees U8 is already on the branch.** | `spec-u14-u21.md` §10 marks REQ-49 as having "no testable acceptance criterion beyond" the selector's presence/absence — honestly carried here, not invented. |

### Reviewable as

- **Demo:** on a 2-person crew ticket, via the fix form, correct one member's Start Work time →
  save → that member's next-Calculate pricing reflects the correction; the other crew member's
  pricing, and the ticket's shared `WORK_TIME` row, are byte-for-byte unchanged.
- **Acceptance:** REQ-47, REQ-48 acceptance lines in full; REQ-49's acceptance line, noted honestly
  as not independently testable beyond "the selector appears on a crew ticket, not a one-person
  one," per `spec-u14-u21.md` §10's own framing.
- **Reviewer can verify without:** U15–U18, U20, U21; **not** without U8 — the web half has no
  host form to extend and the `payroll-pricing` read half has no module to extend until U8 ships.

### Risk

- **Weakest source:** `[UNVERIFIED]` across all three. REQ-47/48's override-table design is Round
  9 item G1, **"settled CodingCops design, not pending"** — an implementation choice the client
  does not own, standing on the `[VERIFIED]` *"individual"* correction principle
  (`decisions/2026-09-29-…-rest-from-rounded-paid-time.md` clause 3), not itself a client
  statement about the schema shape. **REQ-49 is the weakest-standing requirement in this unit**:
  no source describes its UI beyond "unlocks these fields on crew tickets," and it is explicitly
  provisional on U8's own, currently unbuilt, form design.
- **Migration reversible:** yes — one new table, one new enum member on an existing enum
  (`PayrollTimeSource`), no drops, no backfill.
- **Behind a flag:** no.
- **Touches existing data:** no rows written by the migration; `buildJobDay` begins **reading**
  (never writing) the new table from the first Calculate after this ships — no existing
  `PayrollJobDay` row is retroactively altered, since Calculate always recomputes from source.
- **Blast radius:** the **narrowest of any unit in this file** — an override only ever affects the
  one employee/ticket/type/sequence combination it targets; every other ticket, and every crew
  member without an override, prices exactly as before.

**`[UNVERIFIED]` + reversible migration is routine — no pre-build raise for the schema.** One
thing worth naming plainly: **this unit's entire commit is gated on U8 landing first, on the same
branch, in the same PR.** If U8's actual fix-form component structure differs materially from
what `spec-u6-u13.md` REQ-21 currently describes (unbuilt at the time of this decomposition),
REQ-49's "extend the existing form" plan may need rework at build time. This is a sequencing risk
inherent to the dependency, not a defect in this unit's own design — and it is exactly why
REQ-49's own Ripple field is `OPEN`, not a stated default, unlike every other requirement in this
file.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `buildJobDay`'s existing per-member pricing branches | new conditional read added to an existing assembly function | this unit's own unit test — a ticket **without** an override prices identically to before (regression); a ticket **with** one prices only that member differently | `spec-u14-u21.md` §11a row 6; `payroll.service.ts:1257-1430` (code, verified directly) |
| U8's fix form (**introduced by U8**, `spec-u6-u13.md` REQ-19/21, unbuilt at time of this decomposition) | direct component extension | none possible until U8 ships — `OPEN`, per REQ-49's own Ripple field, not a stated default | `spec-u14-u21.md` REQ-49 Ripple: `OPEN — cannot be fully stated until spec-u6-u13.md's U8 is built` |
| One-employee-roster tickets' existing correction path (U8's direct-edit, REQ-19) | disjoint-by-design boundary this unit proposes to enforce | this unit's own integration test — override creation refused on a one-person ticket | REQ-48 Notes (proposed boundary, not sourced — flagged) |

### Deliberately not in this unit

- **The `payroll-pricing`/`assembleWeek` module itself** — U8's own deliverable
  (`spec-u6-u13.md` REQ-20); this unit only extends it once it exists.
- **Finalizing REQ-49's exact UI layout/copy** — genuinely blocked on U8's own, currently
  unbuilt, form design; not a decision this decomposition can make. Build the smallest reading
  once U8's real component exists, exactly as `spec-u14-u21.md` §13 already flags.

---

## U20 — `SamsaraAssetDayEvent`: schema + cron, `SAMSARA_TIME_MISMATCH` detector

- **Outcome:** A guarded daily cron persists, per tracked asset per calendar day, the first
  yard-exit instant, the last yard-re-entry instant, and the last engine-off instant/location,
  derived from Samsara trip/engine-state data. Calculate raises `SAMSARA_TIME_MISMATCH` when a
  ticket's Left Yard/Arrived at Yard time differs from the matching persisted instant by more
  than 30 minutes — silent (no flag) when no Samsara data exists for that asset/date.
- **Kind:** vertical
- **Requirements covered:** REQ-50, REQ-51 — fully.
- **Depends on:** U5.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | New `SamsaraAssetDayEvent` model exactly per `spec-u14-u21.md` §3/REQ-50's Notes: `id`, `tenantCompanyId`, `assetId`, `workDate DateTime @db.Date`, `leftYardAt DateTime?`, `arrivedYardAt DateTime?`, `lastEngineOffAt DateTime?`, `lastEngineOffLat/Lng Decimal? @db.Decimal(9,6)` (matching `Address.latitude`/`.longitude`'s own precision, `schema.prisma:1677-1678`, confirmed), `departureYardId String?` (**nullable — this unit's own cron leaves it `null`; U21 populates it**), `computedAt`; `@@unique([tenantCompanyId, assetId, workDate])`. No business code, same no-code precedent as U19's table. Migration `apps/api/prisma/migrations/20260930210000_samsara_asset_day_events/migration.sql` (placeholder timestamp, later than U19's `20260930200000_ticket_employee_time_overrides` and the branch's `20260930190000_payroll_ticket_void` — confirm the real latest migration at build time) — additive, one new table, no backfill. `prisma.service.ts`'s `$extends` allowlist gains `samsaraassetdayevent`, same commit. | An asset with no Samsara data that day produces **no row**, not a row with all-null fields — per REQ-50's own Acceptance, matching F10's "no data → no flag" rule for the detector that reads it. |
| API (`apps/api`) | New `apps/api/src/usecase/samsara-day-events/samsara-day-events.service.ts`, a `@Cron` job following the existing pattern (`apps/api/src/usecase/notifications/notification-scheduled-jobs.service.ts:100-157` `@Cron(CronExpression…)`; `runWithCronGuard` at `:351`, confirmed present at the cited lines — cited by reference to `spec-u6-u13.md` REQ-29's own confirmed finding of this pattern, not independently re-verified beyond spot-checking the two decorators exist). Per tracked asset per day: read `apps/api/src/service/samsara/samsara.repository.ts` (existing, confirmed **read-only live-GET client, no persistence today** — class doc `:112-115`— `fetchTrips`, `fetchVehicleStats`'s `'engineStates'` filter, `fetchHistory`'s `SUMMARY_STAT_TYPES`, all confirmed present) for the day's start-and-end points only (F9); derive `leftYardAt` (first yard-exit) and `arrivedYardAt` (last yard-re-entry) against every candidate yard's every `Address` (`Yard.addresses Address[]`, confirmed one-to-many) within 500m (F11); derive `lastEngineOffAt`/lat/lng from the day's last engine-off event. Upsert one row per `(tenant, asset, date)`; no data that day → no row (not written). `SAMSARA_TIME_MISMATCH` added to `payroll-flag-detection.service.ts` (**introduced by U5**): compare a ticket's `YARD_TIME.startedAt`/`.endedAt` against the matching `SamsaraAssetDayEvent.leftYardAt`/`.arrivedYardAt` for the ticket's asset+date; `> 30 min` on either edge → **one flag per edge** (**proposed, not sourced** — REQ-51 Notes, matching how the other per-instant detectors in this file are scoped); no `SamsaraAssetDayEvent` row for that asset/date → nothing — **fail-open, F10, confirmed scoped to this detector specifically**, not a general rule this file applies everywhere (contrast REQ-53/U21, where the same fail-open answer had to be separately confirmed by Round 11/Q41). | The geofence radius (500m, F11) and "any of a yard's several addresses" (proposed default, REQ-50 Notes) are both unsourced-beyond-reference defaults directly deciding whether real trips get mis-timed — see Risk. |
| Shared (`packages/shared`) | `PAYROLL_FLAG_CATALOG` (**introduced by U5**) gains `SAMSARA_TIME_MISMATCH`. | |
| Web (`apps/web`) | None beyond the generic flag chip (**introduced by U5**). | |
| Mobile (`apps/mobile`) | None. | `N/A`. |
| Tests | **Unit:** the cron computes `leftYardAt`/`arrivedYardAt`/`lastEngineOffAt` correctly from a fixture trip/engine-state payload; an asset with no data that day writes no row. `SAMSARA_TIME_MISMATCH` fires at 31 minutes, not at 30; no `SamsaraAssetDayEvent` row → no flag. **Integration:** the cron is idempotent — re-running for the same asset/date upserts rather than duplicating the row; `approveEmployee` refused on a mismatched ticket. | The cron's real Samsara-dependent behavior likely needs a fixture/mock in most dev environments — no source states a test-tenant Samsara account is available; flag for the executor. |

### Reviewable as

- **Demo:** seed a `SamsaraAssetDayEvent` row with `leftYardAt` 45 minutes off a ticket's Left
  Yard → Calculate → `OPEN` `SAMSARA_TIME_MISMATCH`. Delete the row → Calculate → no flag.
- **Acceptance:** REQ-50, REQ-51 acceptance lines in `spec-u14-u21.md` §2.
- **Reviewer can verify without:** U15–U19, U21; **not** without U5.

### Risk

- **Weakest source:** `[UNVERIFIED]` for the schema/cron mechanics — F8/F9/F11 are all
  `reference`, pending Corrina Bustos (F8/F9) and the TCG assets owner (F11), and F8/F9's own text
  states plainly: *"This needs yard geofences, and none exist today."* **REQ-51's 30-minute
  tolerance itself is `[VERIFIED]`** (Corrina's own words, `decisions/2026-09-29-…-samsara…md`
  clause 2) — the single strongest-sourced fact in this unit, though the schema/cron mechanics
  feeding it are not.
- **Migration reversible:** yes — one new table, no drops, no backfill.
- **Behind a flag:** no.
- **Touches existing data:** no rows written by the migration; the cron begins writing new rows on
  its own schedule from the first run after this ships — no existing table is altered, and the
  cron does not itself trigger a Calculate or touch pricing.
- **Blast radius:** every tracked asset's next Calculate run, once the cron has populated at least
  one day's data, can raise `SAMSARA_TIME_MISMATCH` wherever a `>30min` gap already exists,
  blocking those weeks unconditionally; an untracked/silent asset raises nothing (fail-open) — a
  known, accepted gap (F10), not a defect.

**`[UNVERIFIED]` + a reversible migration, but a cron that starts writing rows tenant-wide on its
own schedule (not developer-triggered) is worth naming even though it is reversible:** **the
geofence radius (500m, F11) and which of a yard's several `Address` rows define it (proposed:
any) are both unsourced/reference-tier defaults that directly decide whether real trips get
misclassified as "left the yard."** A wrong radius would silently mis-time `leftYardAt`/
`arrivedYardAt` for every asset at that yard, which then feeds straight into a blocking flag. This
is a pre-real-tenant-rollout confirmation item, not a build blocker (the migration and the cron's
upsert are both reversible/idempotent) — but it should reach the TCG assets owner before this cron
runs against a real tenant's data, per F11's own `reference`, pending standing.

### Ripple — what already works that this unit reaches

`none — new table and cron, additive; the existing live-read Samsara consumers
(day-times.ts and any web vehicle-tracking display) are unchanged — this adds a parallel
derived/persisted read path, not a replacement` (`spec-u14-u21.md` REQ-50 Ripple; **not
independently re-verified for every web consumer of live Samsara data by this decomposition
either — the same caveat the spec itself carries; flag for the executor to confirm no page
assumes "the only source of truth is live" in a way this new table would contradict**).

### Deliberately not in this unit

- **`departureYardId` population (REQ-52's derivation logic)** — lands in U21, which extends this
  unit's own cron in place; the column exists (nullable) from this unit's migration but stays
  `null` until U21 ships.
- **`ASSET_NOT_RETURNED_TO_DEPARTURE_YARD` (REQ-53) and its dispatch notification (REQ-54)** —
  U21, out of scope here; this unit builds only the two-instant persistence and the time-mismatch
  detector.
- **Re-testing U17's `MISSING_NOTES` trigger (c) against this unit's new detector** — no
  requirement of this unit asks for it; `MISSING_NOTES` reads `PayrollFlag` generically and needs
  no code change here, only a test nobody has written yet (flagged under U17, not fixed here).

---

## U21 — Departure-yard derivation, asset-not-returned detector, dispatch notification

- **Outcome:** Once a non-holdover job's last ticket's end date has passed, every crane asset
  used on that job that has Samsara data for that date is checked against its derived departure
  yard; one still away raises a blocking flag for its ticket's crew and notifies every
  `dispatch`-permission holder. Built against the date-triggered reading (F13/Round 10); the
  conflict with Corrina Bustos's own verified event-triggered words is named, not resolved.
- **Kind:** vertical
- **Requirements covered:** REQ-52, REQ-53, REQ-54 — fully. **REQ-53 carries `[CONFLICT]`** —
  see Risk; this decomposition does not resolve it, per the spec's explicit instruction.
- **Depends on:** U5; U20 (`SamsaraAssetDayEvent` table + cron, **introduced by U20** — this
  unit extends both in place and cannot exist without them).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | **None new** — `departureYardId` already exists on `SamsaraAssetDayEvent`, nullable, from U20's migration. No new migration in this unit. | |
| API (`apps/api`) | `apps/api/src/usecase/samsara-day-events/samsara-day-events.service.ts` (**introduced by U20**, extended here, same file): the cron gains departure-yard derivation (REQ-52) — for an asset/date with a `leftYardAt` instant, set `departureYardId` to whichever tenant yard's geofence (same 500m/any-address rule as U20's own arrival/departure checks) contained the asset's location immediately before `leftYardAt`; no match (asset started the day already off-site, or yard coordinates unset — `Address.latitude`/`.longitude` nullable, confirmed) → stays `null`. `Asset.yardId` (confirmed exists, a standing "home yard" field) is **explicitly not** the rule, per both F12 and its predecessor note. `payroll-flag-detection.service.ts` (**introduced by U5**) gains `detectAssetNotReturnedToDepartureYard`: once a job's last ticket's end date (across every ticket on the job) has passed, for every **crane** asset (match `Category`/`SubCategory.name` — `schema.prisma:591-681`, confirmed **no typed category exists**, free-text only — case-insensitively against a "crane" term; `NOT SPECIFIED` the exact string, flag for confirmation) used on the job whose `JobResourceAllocation.isHoldover` (`schema.prisma:3965`, confirmed) is `false`, **and for which a `SamsaraAssetDayEvent` row exists for the job's last work date**: check whether `lastEngineOffAt`/location falls inside `departureYardId`'s geofence; if not, raise one `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD` flag per `TicketEmployee` on that asset's ticket for that day, sharing one `groupKey`. **No `SamsaraAssetDayEvent` row for that asset/date → raise nothing — fail-open (Round 11/Q41), not the fail-safe default this spec originally proposed before Q41 was answered.** `apps/api/src/usecase/notifications/notification-catalog.ts` gains `dispatch.asset_not_returned`, `defaultChannels: ['IN_APP', 'EMAIL']`, following `payroll.entry_sent_back`'s render-function shape (confirmed present in this file today, re-verify exact line numbers at build time since U3/U5's own additions have grown this file since it was last read in full for this decomposition); dispatched via `RecipientResolverService`'s **already-live** `{ permission: { module: 'dispatch', minLevel: 'view' } }` spec (**introduced by U1**, `recipient-resolver.service.ts:26-44` `RecipientSpec` union, `resolvePermissionHolders` at `:212-241` — confirmed directly, re-read for this decomposition, present and built with no caller yet outside payroll) — this unit is its first caller outside payroll, per the spec's own note. `'dispatch'` is confirmed present in `PERMISSION_MODULES` (`packages/shared/src/constants/permissions.ts:27`, re-verified directly). **No portal `ADMIN`/`SUPER_ADMIN` exception** — per REQ-02/U1's own documented constraint (the guard bypass never makes anyone a recipient by itself); do not add one here either. | `RecipientResolverService`'s `{permission}` variant needing **no new resolver logic** (only a new catalog entry and call site) is the one place in this unit where the underlying mechanism is already fully built and merged — the strongest-grounded piece of this unit's own build. |
| Shared (`packages/shared`) | `NOTIFICATION_TYPES` gains `dispatch.asset_not_returned`. `PAYROLL_FLAG_CATALOG` (**introduced by U5**) gains `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD`. | |
| Web (`apps/web`) | The generic flag chip (**introduced by U5**) picks up the new code — no new component. `NOT SPECIFIED` notification copy — build functional copy naming the asset, the job, and the departure yard, per REQ-54's own Notes. | |
| Mobile (`apps/mobile`) | None. | `N/A`. |
| Tests | **Unit:** departure-yard derivation picks the correct yard when the asset's pre-departure location is inside more than one yard's geofence overlap, or none (`spec-u14-u21.md` §10's own row). `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD` does **not** fire until the job's last ticket's end date has passed, even when an earlier day's engine-off was away from the yard — the multi-day, non-holdover, Round 10 "judge at the job's last day" case that closes the false-positive risk the vault's own notes had flagged as unresolved. Raises **nothing** for a crane with no `SamsaraAssetDayEvent` row for the job's last work date, even past that date — **fail-open, Round 11**, the explicit regression against the fail-safe default this spec originally proposed before Q41 was answered. **Integration:** `dispatch.asset_not_returned` sent `IN_APP` + `EMAIL` to every `dispatch: view+` holder and **no one else** — including asserting a portal `ADMIN`/`SUPER_ADMIN` with no explicit `dispatch` grant does **not** receive it. | |

### Reviewable as

- **Demo:** a non-holdover job's crane, last ticket's end date passed, `SamsaraAssetDayEvent`
  shows `lastEngineOffAt` outside `departureYardId`'s geofence → Calculate → `OPEN`
  `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD` for that ticket's crew, and every `dispatch: view+`
  holder notified `IN_APP` + `EMAIL`. The same asset with no `SamsaraAssetDayEvent` row for that
  date → Calculate → nothing.
- **Acceptance:** REQ-52, REQ-53 (built against the date-triggered reading — the conflict is named,
  not resolved), REQ-54 acceptance lines in `spec-u14-u21.md` §2.
- **Reviewer can verify without:** U15–U19; **not** without U5 and U20 — the flag framework, the
  table and the cron this unit extends all belong to those units.

### Risk

- **Weakest source:** **`[CONFLICT]` for REQ-53 — the one requirement in the entire U14–U21 file
  carrying that flag, and it is carried forward here exactly as the spec states it, unresolved.**
  F13/Round 10 (`reference`, date-triggered — *"after ticket end date pass"*, judged once, at the
  job's last day) is what this unit builds, **against** `decisions/2026-09-30-crew-time-flag-job-
  start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md` clause 3 (**`[VERIFIED]`**,
  Corrina Bustos's own words: *"it would trigger if the asset shut off at address other than the
  los alamitos or Ventura yard addresses"* — an **event** trigger, not a **position check made
  once a date has passed**). The two readings can disagree: an asset shut off away from the yard
  and back inside it by the time the check runs flags under Corrina's own words and not under
  what this unit builds. **Neither reading is more authoritative by default** — Corrina's is
  verified but predates the developer's buildable design; the developer's is what this unit
  actually builds, because an event trigger with no batch/cron model has no design the vault
  supplies. **This unit does not choose between them — do not silently pick a winner while
  building it.** REQ-52 is F12, `reference`, pending the TCG assets owner. REQ-54's mechanism
  (permission-based, in-app + email) is F15, `reference`, pending Lisette Anzaldo, though the
  underlying *requirement* for a dispatch notification is independently corroborated by a second,
  `[VERIFIED]` source (Corrina's own *"payroll admin/payroll manager, and dispatch notified"*).
- **Migration reversible:** `N/A` — no new migration in this unit (the schema landed in U20).
- **Behind a flag:** no.
- **Touches existing data:** no rows written directly by this unit's code beyond the cron
  (extended, not new) populating `departureYardId` on existing and new `SamsaraAssetDayEvent`
  rows; Calculate begins raising `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD` against jobs whose last
  ticket's end date has **already passed at the time this ships** — see Blast radius.
- **Blast radius:** **the three 200-ton-plus cranes named silent for 8–13 months in
  `assets/gaps.md` will never raise this flag while their Samsara link stays silent** (Round 11's
  fail-open — a known, accepted gap per that answer, not an oversight; do not add a compensating
  alert without a source asking for one). For tracked cranes, every non-holdover job whose last
  ticket's end date has already passed at the time this ships, where the crane is not back in its
  departure yard's geofence, raises this flag on the very next Calculate — a genuinely new,
  unconditional block with no grace period, layered on top of an already-conflicted product
  answer.

**`[CONFLICT]` + a schema-adjacent behavior change with no per-tenant override (U5's REQ-11) is
the highest-standing raise-before-a-real-tenant item in the whole U14–U21 file.** REQ-53's
conflict must reach Corrina Bustos and Lisette Anzaldo before this unit's flag runs against a real
tenant's data — exactly as `spec-u14-u21.md` §13 and its own sign-off checklist state (the
`[CONFLICT]` checklist box is left unchecked at spec sign-off, deliberately, naming this exact
gap). **This unit is built correctly to what the spec specifies** — the date-triggered reading —
**and this is not a reason to hold the unit's own build.** It is a reason to hold **rollout to a
real tenant** pending that reconciliation: a `tcg-scrum`/`close-ticket` item, not a code change,
and not something this decomposition or the executor building this unit can close.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| U20's cron (`samsara-day-events.service.ts`) | same file, extended in place | this unit's own unit test for departure-yard derivation, run alongside U20's own cron tests (not reordered or removed) | `spec-u14-u21.md` REQ-52 Ripple |
| U1's `{permission}` `RecipientSpec` / `RecipientResolverService` | existing, already-merged mechanism, new caller outside payroll | this unit's own integration test — every `dispatch: view+` holder notified, and no one else, including the portal-bypass exclusion | `recipient-resolver.service.ts:26-44,212-241` (code, verified directly); `spec-u14-u21.md` REQ-54 Ripple |
| `buildJobDay`'s existing per-member pricing | unaffected — this unit writes a flag, not a priced figure | none needed — this unit writes no `PayrollJobDay`/pricing field | `spec-u14-u21.md` §11a row 6 (REQ-53 listed there alongside REQ-48; REQ-53's own half is "a new, independent detector," confirmed unchanged) |

### Deliberately not in this unit

- **Resolving REQ-53's `[CONFLICT]`** — not this decomposition's, or this unit's, call. Corrina
  Bustos's and Lisette Anzaldo's, named explicitly in `spec-u14-u21.md`, not built around by
  picking a side.
- **A compensating alert for untracked/Samsara-silent cranes** — Round 11 explicitly says skip;
  do not add one without a source asking for it.
- **The holdover definition itself** (`dispatch/gaps.md` → *Does copying allocations make a job a
  holdover?*) — this unit reads the existing `isHoldover` flag as-is; the definition question is a
  separate, already-open vault item, not this unit's to resolve.

---

## Sequencing

```
U13 ──▶ U14

U5 ──┬──▶ U15
     ├──▶ U16 (also needs U7)
     ├──▶ U17
     ├──▶ U18
     └──▶ U20 ──▶ U21 (also needs U5)

U8 ──▶ U19
```

- **Parallelisable:** **none of U14–U21 are developed as separate branches** — same single-branch,
  one-commit-per-unit model `units.md` already established for U1–U5, extended here. Stated for
  completeness, per that file's own convention of naming shared files even when the git layout
  makes the question moot: **U15, U16, U17, U18, U20 and U21 all touch the same two files** —
  `payroll-flag-detection.service.ts` and `PAYROLL_FLAG_CATALOG` (`packages/shared/src/constants/
  payroll-flags.ts`), both **introduced by U5**. Six units sharing two files would collide as
  independent branches; the single-branch, sequential-commit model sidesteps that by construction
  (each commit's diff lands on top of the previous one's), but these six are **not** parallelizable
  in the sense `units.md` U1/U2 were (no shared file at all). **U14** shares no file with U15–U21
  (mobile + `ticket-work-segments.service.ts`/`ticket-lunch-breaks.service.ts` only). **U19**
  shares no file with U15–U18/U20–U21 (its own new module + `buildJobDay`, which none of the
  detector units touch).
- **Merge order constraint:** migrations land in unit order. U19's
  `20260930200000_ticket_employee_time_overrides` and U20's
  `20260930210000_samsara_asset_day_events` are the only two migrations in this file (REQ-47 and
  REQ-50/52); each must be the branch tip's *only* pending migration for its own unit's commit,
  per `.ai/claude/contexts/prisma.md`'s migration-per-commit discipline. U19 landing before U20 in
  this ledger's numeric order is not a technical necessity — the two touch disjoint tables — it is
  what this ledger builds to, consistent with numeric-order convention elsewhere in this file.
  **U21 must commit after U20 — this one is a hard technical dependency, not a convention:** U21
  extends U20's cron file in place and reads a schema column (`departureYardId`) that only exists
  because U20's migration created it.
- **First unit to ship: U14.** It proves the riskiest assumption in this file — that U13's
  returned-ticket terminal-guard exemption, built for the milestone path, actually generalizes
  cleanly to two more services (`TicketWorkSegmentsService`, `TicketLunchBreaksService`) rather
  than needing per-service rework. Every other unit in this file (U15–U21) is comparatively
  low-risk, additive detector/schema work once U5's framework and (for U19/U20/U21) their own
  named prerequisites exist. **If U14 stalls on U13's own build,** U15 is the safe unit to lead
  with instead: it needs only U5, touches no mobile code, and is independently reviewable via a
  single API round-trip against an already-computed field.

---

## Blocking — unsettled items carried into this file, not resolved by it

- **REQ-53 `[CONFLICT]` (U21)** — F13/Round 10 (date-triggered, built here) vs. Corrina Bustos's
  own `[VERIFIED]` event-triggered words. Named in U21's own Risk block, not resolved. Needs
  Corrina Bustos and Lisette Anzaldo before U21 ships to a real tenant — not before it is built.
- **REQ-49's exact interaction with U8's fix form (U19)** — `spec-u14-u21.md` marks this `OPEN`,
  not a stated default, distinct from every other `NOT SPECIFIED` item in this file; genuinely
  cannot be settled before U8's own, currently unbuilt, form exists.
- **U16's AM/PM-vs-out-of-order suppression, cross-file with `spec-u6-u13.md`'s U7** — this unit
  builds both sides of the suppression on its own file, but needs re-verification against U7's
  real detector once `units-u6-u13.md` exists and U7 is actually built.
- **U17's `MISSING_NOTES` trigger (c) test coverage** — only as complete as the flag-writing
  detectors that exist at U17's own build time (U5, U15, U16, U18); U20's and U21's detectors feed
  the same trigger once they ship, but nothing re-tests it then. No code change needed, only a
  test nobody has written yet.
- **U20's geofence defaults** (500m radius, F11; "any of a yard's addresses," proposed) — unsourced
  or reference-tier, feeding directly into a blocking flag (`SAMSARA_TIME_MISMATCH`, and
  indirectly `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD` in U21). Should reach the TCG assets owner
  before either cron runs against real tenant data.
- **U21's "cranes only" category-name match** — `NOT SPECIFIED` exact matching string; proposed
  case-insensitive match against a "crane" term in `Category`/`SubCategory.name`, flagged for
  confirmation before relying on it in a tenant whose category naming differs from TCG's own.
- **Migration timestamps** (`20260930200000_…`, `20260930210000_…`, U19/U20) are placeholders per
  this task's own instruction — confirm the real latest migration on the branch at build time and
  pick timestamps later than it.

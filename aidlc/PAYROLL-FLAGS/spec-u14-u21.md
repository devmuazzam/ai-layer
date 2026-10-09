# Spec — PAYROLL-FLAGS Flagged-entries rework, units U14–U21

> Written to `.ai/aidlc/PAYROLL-FLAGS/spec-u14-u21.md` by the elaborator
> (`.ai/aidlc/agents/inception/tcg-elaborator.md`).
>
> **No `intent.md` exists for this ticket.** PAYROLL-FLAGS is a developer-scoped build (branch
> `feat/PAYROLL-FLAGS-foundation`), not a Jira ticket. U1–U5 are `spec.md` (U1, U2 committed:
> `2f8fcf5c5`, `32da2afb3`). U6–U13 are `spec-u6-u13.md`, written concurrently by another agent —
> **not read or edited by this file**, beyond confirming its REQ/Q numbering (REQ-15–REQ-32,
> Q11–Q16) does not collide with this file's REQ-40+/Q40+, as instructed.
>
> U14–U21 were blocked on undecided design points. The developer answered all of them on
> 2026-09-30, in three rounds: "Round 9" (`F1`–`F15`, client-owned rules the developer read so the
> units could be built, pending TCG ratification; `G1`–`G2`, CodingCops's own settled design
> calls), a same-day follow-up "Round 10" (four residual gaps this file's own predecessor draft
> had flagged), and a second same-day follow-up "Round 11" (this file's own first-published §12
> questions, Q40 and Q41 — both answered against this spec's stated defaults; see REQ-44, REQ-53).
> Round 9 is recorded in
> `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md`, `status:
> reference` throughout — **none of this is a TCG ruling**; every `F`-item stays open in its
> vault register until its named ratifier confirms it, and this spec's requirements carry that
> status honestly. Rounds 10 and 11 are `reference` too, relayed in a coordinating session on
> 2026-09-30 and not yet written into the vault at the time of this draft — flagged per source,
> below.
>
> This is the document an executor builds from. **Every requirement in it carries its sources,
> and every source carries its status.** A requirement with no source is not a requirement — it
> is an open question, and it stays marked as one.

## Source status used in this spec

Same three-tier scheme as `spec.md` and `spec-u6-u13.md`, not the vault's usual binary:

- **verified** — a named TCG person adjudicated it in writing. Rendered `[VERIFIED]`.
- **reference** — a CodingCops developer's direction (git user `devmohsinakram`), filling in
  mechanics a verified decision left open, or extending one, pending the named ratifier.
  Rendered `[UNVERIFIED]` per the template's binary flag, with "reference" and the ratifier
  stated in the source line. Round 9's `F`-items and Round 10 are both this tier.
- **CodingCops design** — an implementation choice the client does not own (Round 9's `G1`–`G2`:
  where corrected times live, and that the worker may self-edit on a returned ticket). These are
  **settled**, not pending — rendered `[UNVERIFIED]` still, per the template's binary, but their
  source line says "settled, CodingCops design" rather than "pending."
- **unsourced** — nothing written settles it. Rendered `[OPEN]`, or, where a REQ is otherwise
  buildable with a stated default, an `Open question:` field pointing at §12.

A requirement's heading flag is the worst of its sources: `[VERIFIED]` only if every source is
verified (none here qualify — every REQ below rests on at least one `reference`-tier source);
`[UNVERIFIED]` if every source is verified or reference; `[CONFLICT]` if a source's
`conflicts_with` is non-empty; `[OPEN]` if no source supports it at all.

---

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `PAYROLL-FLAGS` (developer-scoped, no Jira/`intent.md`) |
| Intent | none — sourced directly from vault decisions and three developer-answer rounds; see banner above |
| Elaborated on | 2026-09-30; folded Round 11 the same day |
| Vault state at elaboration | 734 content files; 11 in `domain/` (none cover payroll); `payroll/gaps.md` carries 106 entries marked `Status: open`. `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` (790 lines) carries Round 9 (`F1`–`F15`, `G1`–`G2`) at its tail, `status: reference` throughout, `conflicts_with` naming four sources including the verified 2026-09-30 crew/asset-flag note (see REQ-53). Rounds 10 and 11 are not yet in the vault — cited directly from the coordinating session's scratchpad, per the task's instruction, flagged wherever used. |
| Open questions raised by this spec | 2 raised, both in §12 (Q40, Q41) — **both now resolved** by Round 11, each against this spec's own stated default (see REQ-44, REQ-53) |
| Already-shipped behaviour reached | see §11a — 6 rows; the boom-range web warning (REQ-42) and the existing `TicketTimeAdjustment`/segment-endpoint terminal guard (REQ-40/41) are the two with the most existing-behaviour weight |
| Rules consulted | `CLAUDE.md` (Identity Convention, Architecture invariants); `.ai/claude/contexts/api.md`; `.ai/claude/contexts/prisma.md`; `.ai/claude/contexts/web.md`; `.ai/claude/contexts/mobile.md` |

### Sources read for this spec

- `.ai/vault/decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` — the
  primary source for every requirement below. `status: reference`. Read in full (790 lines);
  "Round 9 — the flag definitions and designs" (from line 561) and its `F1`–`F15`/`G1`–`G2` table
  supply nearly every design decision this file builds against.
- `.ai/vault/decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` —
  `[VERIFIED]`, Corrina Bustos — the nine-flag list itself, and "every flag blocks."
- `.ai/vault/decisions/2026-09-29-invalid-entry-flags-samsara-30-minutes-and-wtl-penalty-moves-rest-start.md`
  — `[VERIFIED]` — her own words on AM/PM, same-start-end, out-of-order, and the 30-minute
  Samsara tolerance.
- `.ai/vault/decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md`
  — `[VERIFIED]`, `conflicts_with: payroll/rules/PAY-045-rest-period-premium.md` — "individual"
  correction, "all times" editable, auto-flag sources.
- `.ai/vault/decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md`
  — `[VERIFIED]` — first crew-time-mismatch wording, the two "New Ideas" (Samsara start-of-ticket,
  asset-not-home).
- `.ai/vault/decisions/2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md`
  — `[VERIFIED]` — replaces "Start Work/End Work" with "Start time/End time"; asset flag trigger
  is "shut off at an address other than the yards," **not time-based** — this is F13's conflict
  partner, see REQ-53.
- `.ai/vault/decisions/2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md`
  — `status: reference` (developer reading, Syed Haris) — Left Yard/Arrived at Yard identified as
  "very start of job"/"back at yard"; departure-yard rule for the asset flag.
  `provenance_note:` records this note is superseded in part by F12/F13.
- `.ai/vault/decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` —
  `[VERIFIED]` — Q1 points 4, 6, 7: `TicketTimeEntry` stays per ticket and crew-wide; a nullable
  `employeeId` on it was rejected; per-employee overrides were left undecided **for that ticket's
  own scope**. Round 9's `G1` is the decision that fills point 7 in, for PAYROLL-FLAGS.
  `.ai/vault/payroll/gaps.md` → *Flagged entries go to payroll…* (the ~4780–4960 entry) and
  `.ai/vault/assets/gaps.md` → *Asset not returned to its home yard…* (~1524) — the live
  registers Round 9's `F`-items answer against; `Status:` lines there confirm the entries stay
  **open**, pending ratification.
- `.ai/vault/dispatch/gaps.md` → *Pointer — asset-not-home flag depends on the holdover
  definition* (~1010–1025) — the dispatch-side pointer for F14/F15.
- `/tmp/.../scratchpad/plan.json` — the planner's unit definitions (scope, `dependsOn`,
  `blockedBy`) for U14–U21. Used only for scope framing; every code claim in it was independently
  re-verified below, with three corrections noted where it was wrong (see REQ-40, REQ-42, REQ-48).
- `/tmp/.../scratchpad/answers.md` → "## Round 10 — U14–U21 spec gaps (2026-09-30)" — `reference`,
  relayed in the coordinating session, not yet in the vault at the time of this draft.
- `/tmp/.../scratchpad/answers.md` → "## Round 11 (spec-u14-u21 Q40/Q41, 2026-09-30)" —
  `reference`, relayed in the coordinating session after this spec's first publish, answering
  this file's own Q40 and Q41 — both against the default each requirement had proposed. Not yet
  in the vault at the time of this fold-in.
- `/tmp/.../scratchpad/u14-u21-facts.md` — a code-verification subagent's report, itself spot-checked
  against the repository directly for three of its heaviest-relied-on claims (`checkBoomRange`,
  `TicketTimeAdjustment`'s schema, and the `payroll.service.ts:828` "boom-range flag alone does
  not" comment — all confirmed accurate) and cited below as `code`.
- The repository, read directly wherever cited as `code` — current-state description and ripple
  only, never a source of intent, per `tcg-elaborator.md` §2.

### Corrections to the planner's assumptions, found while sourcing this file

- **No `RETURNED` `JobTicketStatus` exists.** "Returned" is `PayrollSendBack.status = SENT_BACK`
  on a ticket that is otherwise `COMPLETE`. `TicketWorkSegmentsService` and
  `TicketLunchBreaksService` do not check `PayrollSendBack` at all today — they block on
  `assertTicketNotTerminal` (any `COMPLETE`/`CANCELLED`/`REJECTED` ticket), full stop, with no
  send-back-aware exemption. See REQ-40.
- **`payroll-pricing`/`assembleWeek` is not on this branch.** It lived on the closed PR #699
  branch (`fix/payroll-correction-page-ui`); `spec-u6-u13.md`'s U8 (REQ-20) salvages it. **U19
  therefore depends on U8**, not only on U5/U8 informally — see REQ-48.
- **Assets carry no typed category.** "Cranes only" (F14) has to match on
  `Asset.subCategoryId → SubCategory.categoryId → Category.name`, a free-text field, not an enum
  — see REQ-53.

---

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-40 | Segment-timer edits (build-up, boom, break-down) unlocked on a returned ticket | mobile, api | `[UNVERIFIED]` | Round 9 G2; decision 2026-09-30 flag-list; code | no |
| REQ-41 | Lunch add/remove/switch, with WTL evidence, on a returned ticket | mobile, api | `[UNVERIFIED]` | Round 9 G2; decision 2026-09-30 developer-answers C11; code | no |
| REQ-42 | `BOOM_OUT_OF_RANGE` / `RANGE_MISSING` become a blocking flag | api, web | `[UNVERIFIED]` | decision 2026-09-30 flag-list; Round 9 F1; code | no |
| REQ-43 | `INVALID_TIME_AM_PM` detector — a 12-hour shift would fix the order | api | `[UNVERIFIED]` | decision 2026-09-29 invalid-entry; Round 9 F2; Round 10 | no |
| REQ-44 | `LABOR_TICKET_MISMATCH` detector — own window vs. Start/End Ticket, >30 min total | api | `[UNVERIFIED]` | decision 2026-09-30 flag-list; Round 9 F3; Round 11; code | no |
| REQ-45 | `MISSING_NOTES` detector — 5 triggers, any of 5 note fields | api, web, mobile | `[UNVERIFIED]` | Round 9 F5; Round 10; code | no |
| REQ-46 | `CREW_YARD_TIME_MISMATCH` detector — job+date grouping, mismatching workers only | api | `[UNVERIFIED]` | decision 2026-09-30 flag-list item 8; Round 9 F6/F7; Round 10; code | no |
| REQ-47 | Schema: `TicketEmployeeTimeOverride`, the per-employee correction store | schema, api | `[UNVERIFIED]` | Round 9 G1; decision 2026-09-14 crew-ticket-shape; code | no |
| REQ-48 | Pricing reads an employee's override where one exists | api | `[UNVERIFIED]` | Round 9 G1; decision 2026-09-14 clauses 4/6/7; code | no |
| REQ-49 | Web: per-person override fields on a crew ticket's fix form | web | `[UNVERIFIED]` | Round 9 G1; plan.json (reference) | no |
| REQ-50 | Schema + cron: `SamsaraAssetDayEvent` — persisted yard-departure/return instants | schema, api | `[UNVERIFIED]` | Round 9 F8/F9/F11; code | no |
| REQ-51 | `SAMSARA_TIME_MISMATCH` detector | api | `[UNVERIFIED]` | decision 2026-09-30 flag-list item 7; Round 9 F8/F9/F10/F11 | no |
| REQ-52 | Departure-yard derivation on `SamsaraAssetDayEvent` | schema, api | `[UNVERIFIED]` | Round 9 F12; decision 2026-09-30 crew-flag (reference) | no |
| REQ-53 | `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD` detector — fail-open on no Samsara data | api, web | `[CONFLICT]` | Round 9 F13/F14; Round 10; Round 11; decision 2026-09-30 crew-time-flag (verified, conflicting) | no |
| REQ-54 | `dispatch.asset_not_returned` notification | api, shared | `[UNVERIFIED]` | Round 9 F15; code (recipient-resolver precedent) | no |

Counts: **15 total** — 0 verified, 14 unverified, 1 conflicted, 0 open.

---

## 2. Requirements

### REQ-40 — Segment-timer edits (build-up, boom, break-down) unlocked on a returned ticket `[UNVERIFIED]`

- **Statement:** On a `COMPLETE` ticket with an open `PayrollSendBack` (`status: SENT_BACK`) for
  the ticket's primary employee, the primary may correct `BUILDUP_TIME`, `BOOM_TIME` and
  `BREAKDOWN_TIME` entries from the mobile app, each edit carrying a mandatory reason and writing
  an audit row, mirroring the milestone-edit mechanism U13 (`spec-u6-u13.md` REQ-30) already
  builds for `TicketTimeAdjustment`'s 7 milestone step keys.
- **Surface:** mobile, api
- **Sources:**
  - **Round 9, item G2** (`decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md`
    §Round 9) — `[UNVERIFIED]` — kind: decision, `status: reference`, **settled CodingCops
    design, not pending** — *"The worker may edit the ticket times, the segment timers
    (build-up, boom, break-down), and lunches / WTL. Every edit carries a reason."* This is the
    product authorization for the capability; the mechanism below is this spec's own design.
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` §B —
    `[VERIFIED]` — kind: decision — Corrina: *"Send Back survives, and its target is the
    worker."* Establishes the worker is the one who edits, not only a Crane Supervisor.
  - `spec-u6-u13.md` REQ-30 (`[UNVERIFIED]`, this ticket's own U13 spec, unbuilt) — kind:
    reference — the exact exemption this requirement extends: *"A `COMPLETE` ticket with an
    open send-back becomes writable, for the primary employee only, for time steps sent with
    `isAdjustment` and a `reason` … extending the existing `TicketTimeAdjustment` audit
    mechanism's `requiresReason` set … and carving an exemption into `recordTicketStep`'s
    terminal guard."* U14 depends on U13 (`plan.json` `dependsOn: ["U13"]`, confirmed) precisely
    because this exemption plumbing does not exist until U13 ships it.
  - `apps/mobile/features/field-ticket/steps/start-work/work-segments.tsx:161-222` (`SegmentAdjuster`)
    and `apps/mobile/features/field-ticket/timers/segment-time-adjust.ts:32`
    (`SEGMENT_TIME_ADJUST_ENABLED`, gated on `EXPO_PUBLIC_ENABLE_SEGMENT_TIME_ADJUST` `'true'`/`'1'`,
    documented in-code as *"A development affordance, not a crew feature"*) — kind: code —
    confirms the dev-only gate this requirement removes, and that `SegmentAdjuster` is reachable
    today whenever `segment.end !== null && onAdjust` (`work-segments.tsx:325-332`), with **no
    ticket-status or send-back check of its own** — the gating is the env flag alone.
  - `apps/api/prisma/schema.prisma:5040-5060` (`TicketTimeAdjustment`) — kind: code — confirmed
    directly: `stepKey String @map("step_key") @db.VarChar(50)` — **a plain string, not an
    enum**, so accepting new segment-identifying values needs no schema migration, only a
    validation-layer change.
  - `apps/api/src/usecase/job-tickets/job-tickets.service.ts:891-905` (`recordTicketStep`) and
    `:813-816` (the `requiresReason` set, today `{leftYard, arriveJob, leftJob, arriveYard}`) —
    kind: code — the only current writer of `TicketTimeAdjustment`. Segment corrections
    (`TicketWorkSegmentsService`) write `TicketTimeEntry` rows directly today and **never** write
    `TicketTimeAdjustment` — confirmed by the facts agent and consistent with the schema comment
    at `schema.prisma:4960-4979` (four distinct row shapes, segments among them, with no mention
    of an adjustment-audit path).
  - `apps/api/src/usecase/ticket-work-segments/ticket-work-segments.service.ts` — kind: code —
    guards at lines 95, 142, 232 with `assertTicketNotTerminal`
    (`apps/api/src/usecase/job-tickets/ticket-terminal-status.util.ts:14-18`, blocking any
    `COMPLETE`/`CANCELLED`/`REJECTED` ticket outright, with no exception today).
  - `apps/api/prisma/schema.prisma:5335-5368` (`PayrollSendBack`) and `PayrollSendBackStatus`
    (`SENT_BACK`, `CORRECTED`) — kind: code — **this is what "returned" means in the codebase.**
    `JobTicketStatus` (`schema.prisma:189-196`) has no `RETURNED`/`SENT_BACK` value — confirming
    the planner's `plan.json` scope line ("accept adjustments on a returned ticket") described a
    status that does not exist; the real condition is an open `PayrollSendBack` row on an
    otherwise-`COMPLETE` ticket, exactly as REQ-30 already models it.
  - `apps/api/src/service/payroll-send-backs/payroll-send-backs.repository.ts:49-57`
    (`CORRECTABLE_TIME_TYPES` = `YARD_TIME, JOB_SITE_TIME, WORK_AT_JOB_SITE_TIME, WORK_TIME,
    BOOM_TIME, LUNCH, WTL`) — kind: code — confirms `BUILDUP_TIME`/`BREAKDOWN_TIME` are **absent**
    from the existing (Crane-Supervisor-era, `payroll:edit`-adjacent) correction path, so this is
    genuinely new capability, not a permission change on an existing one.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** see §11a row 1. The removed `EXPO_PUBLIC_ENABLE_SEGMENT_TIME_ADJUST` gate has no
  other reader — established by `grep -rn "SEGMENT_TIME_ADJUST_ENABLED\|ENABLE_SEGMENT_TIME_ADJUST"
  apps/mobile` returning only the one definition and the one gate site (not independently
  re-verified beyond the facts agent's report; flagged for the executor to confirm before
  deleting the env var from build config). Whether correcting `BREAKDOWN_TIME`'s end also moves
  `WORK_AT_JOB_SITE_TIME` (End Work) is an **existing** open product question
  (`decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` §C10 — End Work
  currently closes at break-down completion in code, but whether it *should* mean "crew leaves
  the job site" instead is pending the TCG field-ops owner) — cited here as an existing vault
  anchor, not duplicated as a new question; this requirement does not need C10 resolved to ship,
  since it only extends the segment editor, not `WORK_AT_JOB_SITE_TIME` itself.
- **Acceptance:** on a `COMPLETE` ticket with an open `SENT_BACK` row for the primary employee,
  the primary can, from the mobile app, adjust any `BUILDUP_TIME`/`BOOM_TIME`/`BREAKDOWN_TIME`
  entry's `startedAt`/`endedAt`, supplying a non-empty reason; the edit is refused without a
  reason, refused for a non-primary crew member, and refused once the ticket has no open
  `SENT_BACK` row; each accepted edit is captured in an audit trail carrying the initial time,
  the adjusted time, the reason and who made it, in the same shape `TicketTimeAdjustment` already
  provides for the 7 milestone keys.
- **Notes for the executor:** the exact `stepKey`/audit-row mechanism for segment edits is
  `NOT SPECIFIED` — no source gives naming. Two options with no source preferring either:
  (a) extend `TicketTimeAdjustment.stepKey`'s accepted values (still a bare `VarChar`) to also
  cover `buildUp`/`boom:<sequence>`/`breakdown`, and have `TicketWorkSegmentsService` write a
  `TicketTimeAdjustment` row alongside its `TicketTimeEntry` write, matching `recordTicketStep`'s
  existing pattern; (b) a segment-specific audit table. This spec proposes (a), since it reuses
  the mechanism REQ-30 is already building rather than inventing a second audit trail — flagged
  as a proposal, not a sourced requirement. Scope this strictly to the returned-ticket case (per
  G2's own framing, "on a returned ticket"); no source authorizes the segment editor for
  in-progress, non-returned tickets, so do not widen it.

### REQ-41 — Lunch add, remove and switch (taken ↔ worked-through), with WTL evidence, on a returned ticket `[UNVERIFIED]`

- **Statement:** On the same `COMPLETE`-with-open-`SENT_BACK` condition as REQ-40, the primary
  employee may add a lunch, remove one, or switch a lunch slot between `LUNCH` (taken) and `WTL`
  (worked-through), each with a mandatory reason. A switch **to** worked-through must capture the
  same customer-consent evidence (signer, signature, identity photo, GPS) the original mobile WTL
  capture requires, recorded on `TicketSignature` at `wtl:<slotIndex>`, exactly as the initial
  capture does — this is not a paperwork-free correction, because it changes pay (PAY-047).
- **Surface:** mobile, api
- **Sources:**
  - **Round 9, item G2** — same citation as REQ-40 — *"the worker may edit the ticket times, the
    segment timers … and lunches / WTL. Every edit carries a reason."*
  - `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` §C11 —
    `[UNVERIFIED]` — kind: decision, `reference` — *"Lunches can be added, removed and switched
    on the correction page … switching taken ↔ worked-through changes pay, because WTL adds a
    paid half-hour (PAY-047). Each such edit is a pay-changing correction, audited like any
    other."* **C11 is scoped to the payroll correction page (the Payroll Admin's own fix,
    `spec-u6-u13.md` U8), not the worker's mobile edit** — its `Scope` note says so explicitly:
    *"Whether payroll's own fix, and the worker's mobile edit (C3), allow the same lunch edits
    was not stated."* Round 9's G2 is what extends the same three operations to the worker.
    Cited here for the pay-effect language, not as direct authorization of the mobile path.
  - `apps/api/prisma/schema.prisma:4960-4998` (`TicketTimeEntryType` doc comment and enum) —
    kind: code — confirms `LUNCH`/`WTL` are independent, repeatable entry types (not a single
    paired enum with numbered variants as an earlier doc comment in the same file's history
    suggested — the live enum is a flat `LUNCH`/`WTL` pair, disambiguated by `sequence Int?` on
    `TicketTimeEntry`), and that *"the customer-consent capture for a WTL (signer, signature,
    identity photo, GPS) does **not** live on this row — it lives on `TicketSignature` at the
    synthetic key `wtl:<slotIndex>`."*
  - `apps/api/src/usecase/ticket-lunch-breaks/ticket-lunch-breaks.service.ts:22-25`
    (`TicketLunchBreakKind` = `TAKEN | WORKED_THROUGH`, not itself persisted — derived from
    which of `LUNCH`/`WTL` was written) and `:43` (`MAX_LUNCH_BREAK_INDEX = 3`) — kind: code —
    confirms the existing service and its 4-slot ceiling (indices 0–3), which this requirement's
    add/remove must respect.
  - `TicketLunchBreaksService` — kind: code — per the facts agent, guarded the same way as
    `TicketWorkSegmentsService` (`assertTicketNotTerminal`, no send-back-aware exemption today);
    not independently re-verified line-by-line here — flag for the executor to confirm the exact
    guard sites before extending them.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** see §11a row 2. `MAX_LUNCH_BREAK_INDEX = 3` and the lunch-break service's existing
  numbering are unchanged by this requirement — it adds a new *caller* (the worker, on a returned
  ticket) to the existing add/remove/switch operations, per the same mechanism REQ-40 uses for
  segments. Whether the *payroll correction page's* own lunch editing (C11, out of scope here,
  presumably part of `spec-u6-u13.md`'s U8) shares this same service or a separate write path is
  `NOT SPECIFIED` — flagged for cross-checking against that spec once both are built.
- **Acceptance:** on a returned ticket, the primary can add a lunch (up to the existing 4-slot
  ceiling), remove one, or switch an existing slot's kind, with a reason required on every
  operation; switching a slot to worked-through is refused without the WTL evidence capture
  (signer, signature, identity photo, GPS) the original mobile flow requires; each accepted
  change is audited (who, when, before/after, reason).
- **Notes for the executor:** whether "remove a lunch" means deleting the `TicketTimeEntry` row
  outright or soft-marking it removed (for audit-trail completeness) is `NOT SPECIFIED` — no
  source addresses deletion semantics for this table; given the table's own doc comment says
  "nothing derived is stored… computed from these rows at read time," a hard delete is consistent
  with the existing design, but the audit row (see REQ-40's Notes) must still capture what was
  removed and why. Exact `stepKey`/audit-row naming for lunch edits is `NOT SPECIFIED`, same
  caveat as REQ-40.

### REQ-42 — `BOOM_OUT_OF_RANGE` / `RANGE_MISSING` become a blocking flag `[UNVERIFIED]`

- **Statement:** Calculate (via U5's `PayrollFlagDetectionService`) raises a blocking
  `BOOM_OUT_OF_RANGE` flag for every `TicketEmployee` whose already-computed
  `boomRangeCheck = 'OUT_OF_RANGE'`, and a blocking `RANGE_MISSING` flag for every
  `boomRangeCheck = 'RANGE_MISSING'`. The comparison basis stays the crane's own physical
  minimum-to-maximum boom range — unchanged. The web replaces its existing non-blocking warning
  badge with the same blocking flag chip every other detector in this framework uses.
- **Surface:** api, web
- **Sources:**
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` items A(1) and
    C — `[VERIFIED]` — kind: decision — Corrina: *"yes all of those are correct… yes all of these
    will need to be adjusted and fixed before the payroll can be approved."* This **overrules**
    the 2026-09-28 note's clause 6 ("a boom-range flag on its own only warns"), by name, in the
    verified note itself.
  - **Round 9, item F1** — `[UNVERIFIED]` — kind: decision, `reference`, pending Corrina Bustos —
    *"Boom basis = the crane's min–max boom range… This is what is built. It is also what clause
    1 of the 2026-09-28 note said. It matches the wording Corrina assented to… Her assent did not
    choose between the two bases, and she was asked twice… A crane with no range recorded gives
    `RANGE_MISSING`. That result is a flag like any other, and it blocks."* This is the basis
    question (`payroll/gaps.md` Q6) the developer chose to build against; it is **not** Corrina's
    own direct answer to the either/or, and stays open in the gaps register pending her, Brian
    Petros, or a demo answer.
  - `apps/api/src/usecase/ticket-labor-entries/boom-range-check.ts:37-65` (`checkBoomRange`) —
    kind: code — **verified directly**: `bracket === null` → `null` (no bracket picked, nothing
    to check); `crane === null || (min === null && max === null)` → `RANGE_MISSING`; else
    `bracket.minFt > max` or `bracket.maxFt < min` → `OUT_OF_RANGE`; else `IN_RANGE`. Confirms the
    basis is already the crane's own `minBoomLength`/`maxBoomLength`, not a job/sales
    configuration — matching F1.
  - `apps/api/prisma/schema.prisma:4737-4742` (`TicketEmployee.boomRangeCheck`,
    `.boomRangeMessage`, `.boomRangeCheckedAt`) — kind: code — confirms the result is already
    persisted per crew member, computed at submission and re-checked after a correction (per the
    2026-09-28 note's clause 1), so this requirement is a **read**, not a new computation.
  - `apps/api/src/usecase/payroll/payroll.service.ts:828` — kind: code — **verified directly**:
    the comment *"A boom-range flag alone does not [block]"* sits on `assertNoOpenSendBacks`
    (`:831-854`), the **existing, separate Crane-Supervisor send-back gate** — it counts open
    `PayrollSendBack` rows generically and does not reference boom-range in the method body read.
    **Correction to `plan.json`'s scope line** ("Remove the 'A boom-range flag alone does not'
    non-blocking path (payroll.service.ts:816-820)"): this method does not need to change for
    this requirement's acceptance criteria — it governs a different, older mechanism
    (`spec-u6-u13.md`'s U9, REQ-22/23, retires the Crane-Supervisor routing this method belongs
    to). This requirement blocks approval independently, through U5's unconditional `PayrollFlag`
    gate (`spec.md` REQ-11). The executor should still re-check
    `payroll-send-backs.repository.ts`'s `countBlockingByEmployee` for any boom-range-specific
    carve-out before closing this requirement, since that repository file was not read for this
    spec.
  - `apps/web/src/features/payroll/**/payroll-employee-table.cells.tsx:157-184` (the `TicketCell`
    flag icon) and `payroll-employee-table.expanded.tsx:121-139` (`EntryReviewState` banner) —
    kind: code — the existing non-blocking boom-range UI this requirement replaces with the flags
    panel/chip U5 (`spec.md` REQ-14) already builds for every other detector.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** see §11a row 3.
- **Acceptance:** a crew member whose `boomRangeCheck` is `OUT_OF_RANGE` or `RANGE_MISSING` at
  Calculate time raises one `OPEN` `PayrollFlag` of the matching code, blocking their week per
  REQ-11's unconditional gate; the web's boom-range badge is replaced by the shared flag chip; a
  crew member whose `boomRangeCheck` is `IN_RANGE` or `null` (no bracket picked) raises nothing.
- **Notes for the executor:** this detector is a straightforward read over an already-persisted
  field — no new computation, no schema change. Confirm `payroll-send-backs.repository.ts`'s
  `countBlockingByEmployee` has no boom-range-specific exclusion before assuming
  `assertNoOpenSendBacks` is fully unrelated (see Sources).

### REQ-43 — `INVALID_TIME_AM_PM` detector: a 12-hour shift would fix the order `[UNVERIFIED]`

- **Statement:** Calculate raises `INVALID_TIME_AM_PM` on a captured time pair (a milestone
  window, a `WORK_TIME`/member window edge, or a `BOOM_TIME` session) that is out of order, where
  adding or subtracting 12 hours from one of the two instants would put them back in order. Where
  this condition holds, `INVALID_TIME_AM_PM` fires **in place of**, not alongside,
  `spec-u6-u13.md`'s generic `INVALID_TIME_OUT_OF_ORDER` (U7, REQ-16) for that same pair — per
  Round 10.
- **Surface:** api
- **Sources:**
  - `decisions/2026-09-29-invalid-entry-flags-samsara-30-minutes-and-wtl-penalty-moves-rest-start.md`
    clause 1 — `[VERIFIED]` — kind: decision — Corrina, verbatim: *"incorrect use of AM/PM…
    times out of order, etc."* Confirms wrong AM/PM as its own named check, distinct from generic
    ordering, in her own words — but does not define *how* AM/PM error is detected.
  - **Round 9, item F2** — `[UNVERIFIED]` — kind: decision, `reference`, pending Corrina Bustos —
    *"Wrong AM/PM (payroll Q7). Flag an out-of-order time that adding or removing 12 hours would
    put in order."* This is the developer's reading, not Corrina's own words — `payroll/gaps.md`
    Q7 stays open for the rest of "etc" and for this detection rule specifically.
  - `/tmp/.../scratchpad/answers.md` → "## Round 10" — `[UNVERIFIED]` — kind: reference, relayed
    2026-09-30, not yet in the vault — *"U16 AM/PM vs out-of-order: ONLY THE AM/PM FLAG — the
    specific flag replaces U7's generic out-of-order flag for that pair."* Settles the
    double-flagging question this detector would otherwise raise against `spec-u6-u13.md` REQ-16.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** see §11a row 4. `spec-u6-u13.md` REQ-16's `INVALID_TIME_OUT_OF_ORDER` detector
  (U7, unbuilt at the time of this draft) is the one existing/parallel consumer this reaches:
  per Round 10, this detector's own logic must run **before** (or instead of) REQ-16's generic
  check for the same pair, suppressing it — the same "for that pair it replaces the [other] flag"
  pattern REQ-16 itself already uses for its own duplicate/overlap suppression (see
  `spec-u6-u13.md` REQ-16's Open question field). Cross-reference this against `spec-u6-u13.md`
  once both are built, since the suppression has to be implemented on one side or the other (or
  both, consistently) and this spec does not control REQ-16's file.
- **Acceptance:** a captured pair out of order, where swapping AM/PM on one instant (±12h) would
  restore correct order, raises exactly one `OPEN` `INVALID_TIME_AM_PM` flag and does **not**
  additionally raise `INVALID_TIME_OUT_OF_ORDER` for the same pair; a pair out of order for any
  other reason (not fixable by a 12h shift) still raises `INVALID_TIME_OUT_OF_ORDER` alone, per
  REQ-16.
- **Notes for the executor:** "one of the two instants" — which one gets the ±12h test where
  either could work — is `NOT SPECIFIED`; build the straightforward reading (test both
  directions on both instants; if any of the four candidate shifts restores order, it's an AM/PM
  case) since nothing suggests a narrower rule and a false negative here just falls through to
  the generic out-of-order flag anyway (still caught, just under the other code).

### REQ-44 — `LABOR_TICKET_MISMATCH` detector: own window vs. Start/End Ticket, >30 min total `[UNVERIFIED]`

- **Statement:** Calculate raises `LABOR_TICKET_MISMATCH` for a crew member whose own labor
  window (`TicketEmployee.workStartedAt`/`.workEndedAt` when set, i.e. `PayrollTimeSource.
  EMPLOYEE_WORK_WINDOW`) differs from the ticket's own `WORK_TIME` (Start Ticket → End Ticket) by
  more than 30 minutes **on the total difference**: `|own start − Start Ticket| + |own end − End
  Ticket| > 30 min`. Each edge is tested by absolute difference and the two are summed before
  comparing to the 30-minute threshold — not tested independently per edge.
- **Surface:** api
- **Sources:**
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` item 5 —
    `[VERIFIED]` — kind: decision — "labor not matching the ticket" confirmed by assent as one of
    the nine flags' item-5 sub-checks.
  - **Round 9, item F3** — `[UNVERIFIED]` — kind: decision, `reference`, pending Corrina Bustos —
    *"The check compares the worker's own work window with the ticket's Start Ticket → End
    Ticket. It flags when they differ by more than 30 minutes… The 30 minutes is new here.
    Corrina's 30 minutes (2026-09-29) is the Samsara tolerance, and this answer reuses the
    figure… Joe Schacatano's 2026-06-23 example (employee 9½ h vs ticket 8 h) would flag."*
  - **Round 11** (`/tmp/.../scratchpad/answers.md` → "## Round 11 (spec-u14-u21 Q40/Q41,
    2026-09-30)") — `[UNVERIFIED]` — kind: reference, devmohsinakram, relayed 2026-09-30, not yet
    in the vault — *"Q40 U16 labor-vs-ticket 30 min: TOTAL DIFFERENCE — flag when |own start −
    Start Ticket| + |own end − End Ticket| > 30 min (not per edge)."* **Resolves Q40**, against
    this spec's own earlier default (per-edge) — see §12 Q40.
  - `apps/api/prisma/schema.prisma` `TicketEmployee.workStartedAt`/`.workEndedAt` — kind: code —
    a DB `CHECK` enforces both-or-neither and `end > start`.
  - `apps/api/prisma/schema.prisma:224-229` (`PayrollTimeSource` enum:
    `EMPLOYEE_WORK_WINDOW | TICKET_WORK_TIME`) and `PayrollJobDay.timeSource` (nullable) — kind:
    code — confirms the two candidate sources this detector compares already have a named
    distinction in the schema.
  - `apps/api/src/usecase/payroll/payroll.service.ts:1286-1293` (`buildJobDay`) and
    `derive-ticket-times.ts:285,311` — kind: code — `shiftStartedAt = member.workStartedAt ??
    times.payableWindow?.start`; `payableWindow` is derived from the ticket's `WORK_TIME` row.
    Confirms: when a member has no own window set, this detector has nothing to compare (their
    own window *is* the ticket's `WORK_TIME`, by fallback) and correctly raises nothing.
  - `payroll/gaps.md` → *Recording which time source paid a job day (PAY-017, TCG-178)* — kind:
    vault, `status: open` — confirms `ticket_employees.work_started_at/work_ended_at` is set
    "when the Oiler entered one," otherwise the ticket's shared `WORK_TIME` is used — the same
    mechanism `buildJobDay` implements, cited above.
- **Conflict:** none.
- **Open question:** none — **resolved, Q40** (see Sources, Round 11).
- **Ripple:** `none — new detector, additive; reads existing fields, writes no existing ones
  (established by: reading buildJobDay and derive-ticket-times.ts directly, per above — neither
  is modified by this requirement)`.
- **Acceptance:** for a member whose `workStartedAt`/`workEndedAt` is set, compute
  `|own start − Start Ticket| + |own end − End Ticket|`; if that sum exceeds 30 minutes, raise
  one `OPEN` `LABOR_TICKET_MISMATCH` flag naming the two windows and the total gap. A member
  whose start is 20 minutes off and whose end is 20 minutes off (40 minutes total, neither edge
  alone over 30) **flags** — this is the case Q40 turned on. A member with no own window set, or
  whose total combined difference is 30 minutes or less, raises nothing.
- **Notes for the executor:** build the total-difference rule (Round 11) — **not** the per-edge
  default this spec originally proposed before Q40 was answered. The two readings disagree
  exactly at cases like the 20-min/20-min example above (per-edge: no flag; total: flags), so the
  distinction is not academic — test that case explicitly (see §10).

### REQ-45 — `MISSING_NOTES` detector: 5 triggers, any of 5 note fields `[UNVERIFIED]`

- **Statement:** Calculate raises `MISSING_NOTES` for a crew member's entry whenever one of five
  conditions holds and no note exists anywhere on the ticket for that member: (a) a captured time
  was adjusted (`TicketTimeAdjustment`/segment-audit exists for this member — REQ-40/41, or the
  existing milestone path); (b) a lunch was worked through (a `WTL` row exists for this member);
  (c) any `PayrollFlag` is `OPEN` on this member's entry (including `MISSING_NOTES` itself would
  self-reference — see Notes); (d) the ticket's `WORK_TIME` span is over 12 hours; (e) the worker
  marked any checklist issue (`ChecklistItemAnswer.result != 'PASS'` on this ticket). "A note"
  means **any** of: `TicketEmployee.laborComments`, `JobTicket.leftYardComment`, a `TicketComment`
  row, `TicketSignature.comments`, or a `TicketTimeAdjustment.reason` — non-empty on any one of
  the five satisfies the requirement; none of the five need be specific to which trigger fired.
- **Surface:** api, web, mobile (mobile only if capture-time validation is added — see Notes)
- **Sources:**
  - **Round 9, item F5** — `[UNVERIFIED]` — kind: decision, `reference`, pending Corrina Bustos —
    developer, verbatim: *"for all and also include if he mark any issue on checklist."* Full
    text: *"A note is required when: (a) a captured time was adjusted; (b) a lunch was worked
    through (WTL); (c) any flag is on the entry; (d) the ticket is over 12 hours; (e) the worker
    marks any issue on a checklist."* The note states plainly: *"No register entry asks this. The
    flag's only other written source is the unverified Confluence KPI 'Entries with Notes
    Missing.'"*
  - `/tmp/.../scratchpad/answers.md` → "## Round 10" — `[UNVERIFIED]` — kind: reference, relayed
    2026-09-30, not yet vaulted — *"U17 which field counts as a note: ANY NOTE ON THE TICKET —
    labor comment, left-yard comment, a ticket comment, the signature comment, or a
    time-adjustment reason."* This is the answer that resolves `plan.json`'s own blocker
    ("Detector MISSING_NOTES over whichever note is required" — unresolved as of the planner's
    draft).
  - `apps/api/prisma/schema.prisma:4723` (`TicketEmployee.laborComments`), `:4667`
    (`JobTicket.leftYardComment`), `:4790-4806` (`TicketComment` — `id, tenantCompanyId,
    jobTicketId, authorUserId, text, …`), `:4830` (`TicketSignature.comments`), `:5047`
    (`TicketTimeAdjustment.reason`, `NOT NULL`) — kind: code — confirms all five candidate fields
    exist as named.
  - `apps/api/prisma/schema.prisma:5254-5273` (`ChecklistItemAnswer`: `result`
    `ChecklistAnswerResult` `PASS|DEFICIENCY|NA`, `reason Text?`, `priority`
    `ChecklistDeficiencyPriority`, `photoAttachmentId`), scoped to `ChecklistAssignment`
    (`:4681-4699`, `JobTicket` + optional `assetId`) — kind: code — confirms the checklist-issue
    concept trigger (e) reads.
  - `decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md`
    (Why section) — `[VERIFIED]` — kind: decision — names *"Missing notes"* as one of six
    auto-flag sources in Corrina's own words (2026-09-29), establishing the flag exists; not the
    trigger definition, which F5/Round 10 supply.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `none — new detector, additive (established by: grep -rn "MISSING_NOTES"
  apps/api/src apps/web/src apps/mobile packages/shared/src returning no hits before this spec)`.
- **Acceptance:** an entry meeting any of the five trigger conditions, with all five note fields
  empty for that member/ticket, raises one `OPEN` `MISSING_NOTES` flag naming which trigger(s)
  fired; the same entry with any one note field non-empty raises nothing, regardless of which
  trigger fired or which field was filled.
- **Notes for the executor:** trigger (c), "any flag is on the entry," self-referencing
  `MISSING_NOTES` is a real edge case no source addresses — `NOT SPECIFIED` whether
  `MISSING_NOTES` counts itself as "a flag on the entry" (which would make it self-triggering
  once any note exists to clear it, an odd loop) or only counts *other* flag codes; build the
  latter (exclude `MISSING_NOTES` from its own trigger-(c) check) since the former is
  logically circular and nothing suggests it was intended. Whether mobile capture-time
  validation should require a note up front (rather than only flagging its absence later at
  Calculate) is `NOT SPECIFIED` — `plan.json`'s own scope line frames it as conditional ("If the
  note becomes required at capture…"); no source makes that call, so this spec builds the
  Calculate-time flag only, and leaves mobile capture-time enforcement `NOT SPECIFIED`/out of
  scope unless a later ticket asks for it.

### REQ-46 — `CREW_YARD_TIME_MISMATCH` detector: job+date grouping, mismatching workers only `[UNVERIFIED]`

- **Statement:** Calculate groups a job's `JobTicket` rows by `(jobId, date)` (via each ticket's
  `SubJob` → `JobScheduleInterval.date`) and compares `YARD_TIME.startedAt` (Left Yard) and
  `.endedAt` (Arrived at Yard) across every ticket in the group. Any difference flags — no
  tolerance. Only the crew members on a ticket whose Left Yard or Arrived at Yard differs from
  the group's consensus value are held; a ticket that matches the rest of the group raises
  nothing for its crew.
- **Surface:** api
- **Sources:**
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` item 8 —
    `[VERIFIED]` — kind: decision — *"Crew times not matching: Left Yard or Arrived at Yard
    different for anyone on the job"* — confirmed by assent as flag #8 of nine, and explicitly
    **ratifies** the developer's Left-Yard/Arrived-at-Yard reading over the earlier "Start
    Work/End Work" wording.
  - `decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md`
    clause 1 — `[VERIFIED]` — kind: decision — Corrina, verbatim: *"any difference [flags]"* — no
    tolerance, confirmed directly in her own words (asked explicitly about a legitimate
    difference, e.g. "the oiler stays to break down," and she still said any difference flags).
  - **Round 9, items F6 and F7** — `[UNVERIFIED]` — kind: decision, `reference`, pending Corrina
    Bustos — *"F6. Crew grouping: same job + same date. The DAS allocation is not the
    grouping."* *"F7. Crew flag owner: the ticket only. It is one ticket-level flag, not a
    per-employee payroll flag. Session reading, to confirm: it blocks the weeks of everyone on
    that ticket, as flag 9 does."*
  - `/tmp/.../scratchpad/answers.md` → "## Round 10" — `[UNVERIFIED]` — kind: reference, relayed
    2026-09-30, not yet vaulted — *"U18 crew mismatch blocks: ONLY THE MISMATCHING WORKERS (whose
    Left Yard / Arrived at Yard differs from the rest of the crew) are held."* This **narrows
    F7's own "to confirm" hedge** — the earlier "blocks everyone on the ticket" reading is
    superseded by this later, more specific answer, and this requirement is built against Round
    10, not F7's broader draft.
  - `apps/api/prisma/schema.prisma:5003-5035` (`TicketTimeEntry`, no `employeeId`) — kind: code —
    confirms `YARD_TIME` is a single-instance milestone per ticket
    (`apps/api/src/usecase/ticket-time-entries/ticket-time-entries.repository.ts:51-58`), never
    per employee — so a mismatch is always **between tickets** of the group, never within one.
  - `apps/api/src/service/das/das.repository.ts:717-753` (`DasRepository.getSubJobsByDate`) and
    `apps/api/prisma/schema.prisma:3797-3832` (`SubJob` 1:1 `JobScheduleInterval`, `JobTicket.
    subJobId → SubJob(jobId, jobScheduleInterval.date)`) — kind: code — the closest existing
    precedent for a job+date grouping query; **no existing "one job, one day, every ticket"
    query was found** — this detector needs a new one, built on the same `(jobId, date)` chain.
  - `apps/api/prisma/schema.prisma` `PayrollFlag.employeeId` (`String`, **not nullable**,
    `spec.md` §3) — kind: reference (this ticket's own U5 schema, unbuilt) — confirms every
    `PayrollFlag` row needs an employee; Round 10's "only the mismatching workers" answer fits
    this schema directly (one row per mismatching `TicketEmployee`, sharing a `groupKey`), where
    F7's original "one ticket-level flag, blocks everyone" reading would have needed either a
    nullable `employeeId` or N duplicate rows for non-mismatching crew too — Round 10 avoids
    both.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** see §11a row 5.
- **Acceptance:** for a job+date group of 2+ tickets whose `YARD_TIME` start or end values are not
  all identical, every ticket whose value differs from the group's consensus (the value shared by
  the largest subset of the group; see Notes for the tie case) raises one `OPEN`
  `CREW_YARD_TIME_MISMATCH` flag per `TicketEmployee` on that ticket, all sharing one `groupKey`
  (e.g. `crew-yard:<jobId>:<date>`); a ticket matching the consensus raises nothing for its crew;
  a group where every ticket agrees raises nothing at all.
- **Notes for the executor:** "the group's consensus value" and its tie-break are `NOT SPECIFIED`
  — no source gives the exact algorithm for more than two tickets. Propose (not sourced): the
  most common exact instant among the group's tickets is the consensus; on an exact tie (e.g.
  two tickets, two different times, or an even split among three+), flag every ticket in the
  group, since none uniquely "matches the rest" — the safer default for a blocking review flag.
  `YARD_TIME` is captured to the instant, so "any difference" means exact inequality, not a
  rounded or bucketed comparison.

### REQ-47 — Schema: `TicketEmployeeTimeOverride`, the per-employee correction store `[UNVERIFIED]`

- **Statement:** A new table records a per-employee correction to a crew ticket's yard, site,
  boom, lunch or segment time, without altering `TicketTimeEntry` (which stays shared/per-ticket,
  unchanged) and without adding `employeeId` to it.
- **Surface:** schema, api
- **Sources:**
  - **Round 9, item G1** — `[UNVERIFIED]` — kind: decision, `reference`, **settled CodingCops
    design, not pending** — *"Per-person corrections: an override table (payroll C4). Payroll's
    correction for one person is stored as a per-employee override: ticket, employee, step,
    corrected time, reason, and who made it and when. The shared ticket times stay as captured.
    Pricing and payroll read an employee's override where one exists… This is the per-employee
    home for corrected times that clause 7 of the verified 2026-09-14 crew-ticket-shape decision
    left undecided."*
  - `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` §Q1,
    points 4, 6, 7 — `[VERIFIED]` — kind: decision — point 4: *"`TicketTimeEntry` stays per
    ticket, unchanged."* Point 6: *"Alternative rejected: a nullable `employeeId` on
    `TicketTimeEntry`."* Point 7: *"Not decided here: per-employee start/end time overrides on
    the shared ticket. Build them only if the existing labor-hours code already supports the
    concept; do not introduce them for this ticket."* Point 7's "do not introduce" was scoped to
    **that ticket's own build** (SCRUM-CREW-TICKET) — G1 is the later decision that authorizes
    building them here, for PAYROLL-FLAGS, without reopening or contradicting the earlier
    ticket's own scope.
  - `decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md`
    clause 3 — `[VERIFIED]` — kind: decision — Corrina: *"individual"* — a correction changes one
    employee's hours, not the whole crew's. The product fact G1's schema serves.
  - `apps/api/prisma/schema.prisma:5003-5035` (`TicketTimeEntry`, confirmed no `employeeId`) —
    kind: code — verified directly, matches the 2026-09-14 decision's point 6.
  - `plan.json` U19 scope line — kind: reference (planner) — proposes the table keyed on
    `(ticketEmployeeId, TicketTimeEntryType, sequence)`; this spec adopts that shape, reusing the
    existing `TicketTimeEntryType` enum rather than inventing a parallel one, since every time
    kind the override needs to cover (`YARD_TIME`, `JOB_SITE_TIME`, `WORK_TIME`, `BOOM_TIME`,
    `LUNCH`, `WTL`, `BUILDUP_TIME`, `BREAKDOWN_TIME`) already has an enum member there.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `none — new table, additive (established by: grep -rn "TicketEmployeeTimeOverride"
  apps/api/src packages/shared/src returning no hits before this spec)`. What *reads* it is
  REQ-48/49 and REQ-46's detector, covered in their own Ripple fields.
- **Acceptance:** a `TicketEmployeeTimeOverride` row can be created for a `(ticketEmployeeId,
  type, sequence)` combination, carrying a corrected `startedAt`/`endedAt`, a mandatory reason,
  and who/when; `TicketTimeEntry` is never written by this mechanism; the same combination cannot
  hold two active overrides at once.
- **Notes for the executor:**

```prisma
// New table (REQ-47):
model TicketEmployeeTimeOverride {
  id               String              @id @default(uuid()) @db.Uuid
  tenantCompanyId  String              @map("tenant_company_id") @db.Uuid
  ticketEmployeeId String              @map("ticket_employee_id") @db.Uuid
  type             TicketTimeEntryType
  sequence         Int?                @map("sequence")
  startedAt        DateTime?           @map("started_at") @db.Timestamptz()
  endedAt          DateTime?           @map("ended_at") @db.Timestamptz()
  reason           String              @db.Text
  createdByUserId  String              @map("created_by_user_id") @db.Uuid
  createdAt        DateTime            @default(now()) @map("created_at") @db.Timestamptz()

  @@unique([ticketEmployeeId, type, sequence], name: "uq_ticket_employee_time_overrides_member_type_seq")
  @@map("ticket_employee_time_overrides")
}
```

  This is this spec's own proposed shape, not sourced field-for-field — `NOT SPECIFIED` whether
  `reason` should be nullable for a non-pay-changing edit (proposed `NOT NULL`, matching
  `TicketTimeAdjustment`'s own pattern, since G1 says every correction carries "reason"). Whether
  an override can be superseded (a second correction to the same field) by a new row or by
  updating the existing one in place is `NOT SPECIFIED` — propose a new row each time, since G1's
  "who made it and when" reads as an append-only audit fact, not a mutable field; flag for
  confirmation. **Migration required** (`pnpm db:migrate`), per `.ai/claude/contexts/prisma.md`.

### REQ-48 — Pricing reads an employee's override where one exists `[UNVERIFIED]`

- **Statement:** `buildJobDay` (and, once U8 lands, the salvaged `payroll-pricing` assembly path)
  reads a `TicketEmployeeTimeOverride` row for a given `(ticketEmployeeId, type, sequence)` in
  preference to the shared `TicketTimeEntry`/`TicketEmployee.workStartedAt`/`.workEndedAt` value,
  falling back to the shared value where no override exists. `PayrollJobDay.timeSource` gains a
  third value, `EMPLOYEE_OVERRIDE`, so which source priced a given job day stays recorded,
  matching the existing `EMPLOYEE_WORK_WINDOW`/`TICKET_WORK_TIME` distinction (REQ-44's Sources).
- **Surface:** api — **not** `packages/payroll-engine`. `buildJobDay` is API-layer code
  (`apps/api/src/usecase/payroll/payroll.service.ts`) that assembles the engine's input; it is
  not inside the engine itself. `plan.json`'s "engine ingest" framing is corrected here.
- **Sources:**
  - **Round 9, item G1** — same citation as REQ-47 — *"Pricing and payroll read an employee's
    override where one exists."* This is the read-path half of G1.
  - `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` §Q1,
    points 4, 6 — `[VERIFIED]` — kind: decision — the shared-time invariant this read-path must
    respect: overriding a value for one employee must not alter `TicketTimeEntry`, so every
    *other* crew member on the same ticket continues pricing from the unchanged shared row.
  - `apps/api/src/usecase/payroll/payroll.service.ts:1257-1430` (`buildJobDay`) — kind: code —
    confirmed to mix ticket-level shared fields (times, `boomWindows` for
    `BUILDUP`/`BOOM`/`BREAKDOWN`, allocation craft, `setResourceId → boomBySet`, `parentJob.
    payrollFlags`, `wtlCount`, `lunchesTakenCount`, `mealEvents`) with per-person fields
    (`member.workStartedAt/EndedAt`, `member.craftModifierId`) already — this requirement adds
    one more per-person read (the override table) into an assembly function that already
    branches per-member, not a new architectural pattern.
  - **`plan.json` correction, confirmed by the facts agent and independently not found**: no
    `payroll-pricing` module or `assembleWeek` function exists on `feat/PAYROLL-FLAGS-foundation`
    today (`grep -rn "assembleWeek" apps/api/src` — not run independently here, relying on the
    facts agent's report, itself spot-checked on three unrelated claims and found accurate). It
    lived on the closed PR #699 branch; `spec-u6-u13.md`'s U8 (REQ-20) salvages it into this
    branch. **This requirement's `payroll-pricing` half cannot be built before U8 lands** —
    `plan.json`'s `dependsOn: ["U8"]` for U19 is confirmed correct by this finding, stronger than
    the informal "U19 depends on U8" framing in the task notes.
  - `apps/api/src/usecase/payroll/payroll-explain.ts:124-135` (`attachPricingSlices`, called from
    `payroll.service.ts:799`) — kind: code — the closest existing pricing-assembly code on this
    branch today, offered as a second read site to check once the override table exists, since
    it also touches per-entry pricing detail.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** see §11a row 6.
- **Acceptance:** a `TicketEmployeeTimeOverride` row for `(ticketEmployeeId, type, sequence)`
  changes only that employee's priced hours for that job day; every other crew member on the same
  ticket, and the ticket's own shared captures, are unaffected; `PayrollJobDay.timeSource` records
  `EMPLOYEE_OVERRIDE` when an override was used for that day's shift bounds.
- **Notes for the executor:** this requirement is **blocked in practice, not in specification**,
  on U8 shipping the `payroll-pricing` salvage — build the `buildJobDay` half (which exists on
  this branch today) first, and gate the `payroll-pricing`/`assembleWeek` half on U8's landing.
  Exact precedence when both an override exists **and** the U8 one-person-ticket "fix" mechanism
  has separately touched the same ticket is `NOT SPECIFIED` — the two are meant to be disjoint by
  ticket-employee-count (U8 edits the shared row directly only when the ticket has exactly one
  roster member, since there is no crew ambiguity; U19's override table exists specifically for
  crew tickets with 2+ members) — flag this boundary for the executor to enforce explicitly
  (e.g. refuse creating an override on a single-employee ticket, direct that case to U8's path
  instead), since nothing sourced states it outright but the two units' own scoping implies it.

### REQ-49 — Web: per-person override fields on a crew ticket's fix form `[UNVERIFIED]`

- **Statement:** On a crew ticket (2+ `TicketEmployee` rows), the fix form U8 builds (`spec-u6-u13.md`
  REQ-19/REQ-21) gains per-person fields for yard, site, boom, lunch and segment times, selectable
  per crew member; saving one writes a `TicketEmployeeTimeOverride` row (REQ-47) for that member
  only, rather than editing the shared ticket row U8 uses on a one-person ticket.
- **Surface:** web
- **Sources:**
  - **Round 9, item G1** — same citation as REQ-47/48 — establishes the override table is the
    per-person home; this requirement is the UI that writes to it.
  - `plan.json` U19 scope line — kind: reference (planner) — *"The U8 form unlocks these fields
    on crew tickets."* Not independently re-verified against U8's actual built UI, since U8 is
    unbuilt at the time of this draft (`spec-u6-u13.md` REQ-19/21) — this requirement's exact
    integration point is therefore provisional on that unit's own design.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `OPEN — cannot be fully stated until spec-u6-u13.md's U8 (REQ-19/REQ-21) is built;
  see Notes`.
- **Acceptance:** on a crew ticket, the fix form shows a per-crew-member selector before exposing
  time fields; on a one-person ticket, it behaves exactly as U8 specifies (no selector, direct
  edit).
- **Notes for the executor:** this requirement's UI cannot be finalized independently of U8's own
  form design, since it extends that form rather than building a new one. `NOT SPECIFIED`: exact
  layout, copy, and whether all five time categories (yard, site, boom, lunch, segment) appear in
  one unified per-person section or five separate ones — no source gives UI detail. Build after
  U8 ships, reusing its component structure per `.ai/claude/contexts/web.md` (search existing
  components before adding new ones).

### REQ-50 — Schema + cron: `SamsaraAssetDayEvent` — persisted yard-departure/return instants `[UNVERIFIED]`

- **Statement:** A new, tenant-and-asset-and-date-scoped table persists, per asset per calendar
  day: the instant the asset first leaves its departure yard's geofence, the instant it last
  re-enters a yard's geofence, and its last engine-off instant and location — derived from
  Samsara trip/engine-state data via a guarded cron, since the Samsara integration today only
  supports live reads with no persistence.
- **Surface:** schema, api
- **Sources:**
  - **Round 9, items F8, F9, F11** — `[UNVERIFIED]` — kind: decision, `reference`, pending
    Corrina Bustos (F8, F9) and the TCG assets owner with Corrina Bustos (F11) — *"F8. Samsara
    signal: the yard's location. Left Yard is compared with the moment the asset leaves the
    yard's location. Arrived at Yard is compared with the moment it re-enters it… This needs
    yard geofences, and none exist today."* *"F9. Samsara points: the start and end of the day
    only."* *"F11. Yard radius: 500 m from a yard's address coordinates. `Address` carries
    latitude and longitude since migration `20260917000000_address_county_and_coordinates`."*
  - `apps/api/src/service/samsara/samsara.repository.ts` (class doc, lines ~112-115) — kind:
    code — **read-only live GETs, no persistence** — confirmed directly by the facts agent and
    consistent with the crew-time-mismatch decision's own code read (*"There are no geofence
    events"*). `fetchTrips(vehicleId, start, end)` (`:346-382`); engine-state events via
    `fetchVehicleStats`'s `'engineStates'` filter (`:172-181`, `FEED_STAT_TYPES` including `gps`,
    `engineStates`, `fuelPercents`) and `fetchHistory` (`:290-339`, `SUMMARY_STAT_TYPES` including
    `gpsDistanceMeters`/`engineStates → toEngineEvents`).
  - `apps/api/prisma/schema.prisma` `Address.latitude`/`.longitude` (`Decimal(9,6)?`, nullable)
    and `.county`, migration `20260917000000_address_county_and_coordinates` — kind: code —
    confirms the coordinate source F11's radius is measured against; **nullable**, so a yard
    without coordinates recorded cannot be geofenced (see REQ-51's Acceptance).
  - `apps/api/prisma/schema.prisma` `Yard.addresses Address[]` (one-to-many, `Address.isPrimary`)
    — kind: code — a yard can have **multiple** addresses; `NOT SPECIFIED` which one (or all)
    define the geofence — see Notes.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `none — new table and cron, additive; the existing live-read Samsara consumers
  (day-times.ts and any web vehicle-tracking display) are unchanged by this requirement, which
  adds a parallel derived/persisted read path rather than replacing the live one (established by:
  reading samsara.repository.ts's class doc directly, confirming no existing persistence to
  migrate away from — not independently re-verified for every web consumer of live Samsara data;
  flag for the executor to confirm no page assumes "the only source of truth is live" in a way
  this new derived table would contradict)`.
- **Acceptance:** for a tracked asset with Samsara trip/engine-state data on a given date, one row
  is computed and stored per (asset, date) carrying the first yard-exit instant, the last
  yard-re-entry instant, and the last engine-off instant/location; an asset with no Samsara data
  that day produces no row (not a row with all-null fields) — consistent with F10's "no data → no
  flag" (REQ-51).
- **Notes for the executor:**

```prisma
// New table (REQ-50, extended by REQ-52):
model SamsaraAssetDayEvent {
  id               String    @id @default(uuid()) @db.Uuid
  tenantCompanyId  String    @map("tenant_company_id") @db.Uuid
  assetId          String    @map("asset_id") @db.Uuid
  workDate         DateTime  @map("work_date") @db.Date
  leftYardAt       DateTime? @map("left_yard_at") @db.Timestamptz()
  arrivedYardAt    DateTime? @map("arrived_yard_at") @db.Timestamptz()
  lastEngineOffAt  DateTime? @map("last_engine_off_at") @db.Timestamptz()
  lastEngineOffLat Decimal?  @db.Decimal(9, 6)
  lastEngineOffLng Decimal?  @db.Decimal(9, 6)
  departureYardId  String?   @map("departure_yard_id") @db.Uuid  // REQ-52
  computedAt       DateTime  @default(now()) @map("computed_at") @db.Timestamptz()

  @@unique([tenantCompanyId, assetId, workDate], name: "uq_samsara_asset_day_events_tenant_asset_date")
  @@map("samsara_asset_day_events")
}
```

  This is this spec's own proposed shape, `NOT SPECIFIED` field-for-field by any source — built
  to serve exactly REQ-51 and REQ-53's stated needs, nothing more. `NOT SPECIFIED` which of a
  yard's several `Address` rows defines its geofence when more than one exists — propose using
  every address of the asset's candidate yards, matching if the instant falls within 500m of
  *any* of them, since no source says to prefer one; flag for confirmation. Cron cadence,
  idempotency and manual-trigger registration should follow the existing `@Cron`/
  `runWithCronGuard` pattern `spec-u6-u13.md` REQ-29 cites
  (`notification-scheduled-jobs.service.ts:208,213,351`) — not re-verified independently here,
  cited by reference to that spec's own confirmed finding. **Migration required.**

### REQ-51 — `SAMSARA_TIME_MISMATCH` detector `[UNVERIFIED]`

- **Statement:** Calculate raises `SAMSARA_TIME_MISMATCH` when a ticket's Left Yard or Arrived at
  Yard time (`YARD_TIME` start/end) differs from the matching `SamsaraAssetDayEvent` instant
  (`leftYardAt`/`arrivedYardAt`) by more than 30 minutes. No flag is raised when no
  `SamsaraAssetDayEvent` row exists for that asset/date (untracked, silent, or simply no data
  that day).
- **Surface:** api
- **Sources:**
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` item 7 —
    `[VERIFIED]` — kind: decision — *"Ticket time more than 30 minutes off Samsara, at the start
    or end of the day"* — confirmed as flag #7 of nine.
  - `decisions/2026-09-29-invalid-entry-flags-samsara-30-minutes-and-wtl-penalty-moves-rest-start.md`
    clause 2 — `[VERIFIED]` — kind: decision — Corrina: *"flagged when its further than 30
    minutes outside of geotag time."* The 30-minute figure, her own words.
  - **Round 9, items F8, F9, F10** — `[UNVERIFIED]` — kind: decision, `reference`, pending
    Corrina Bustos — F8/F9 as cited in REQ-50; **F10**: *"No Samsara data (payroll Q11(c)): no
    flag. This was answered for the Samsara time flag (U20) only. For the asset flag (F13), the
    handling of untracked or silent assets was not stated. assets Q7 stays open."* — this
    explicitly scopes "no data → no flag" to **this** detector; whether it also applies to
    REQ-53 was, at F10's own writing, unstated for that requirement — Round 11 has since settled
    it does (§12 Q41, resolved; see REQ-53).
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** see §11a row 3 of `spec-u6-u13.md`'s own U6/U7 ripple table is not applicable here
  (different file); `none — new detector, additive` for this spec's own scope.
- **Acceptance:** a ticket whose Left Yard is more than 30 minutes from the asset's
  `leftYardAt` for that date, or whose Arrived at Yard is more than 30 minutes from
  `arrivedYardAt`, raises one `OPEN` `SAMSARA_TIME_MISMATCH` flag per affected edge; a ticket
  whose asset has no `SamsaraAssetDayEvent` row for that date raises nothing; a ticket within 30
  minutes at both edges raises nothing.
- **Notes for the executor:** depends on REQ-50's table being populated; cannot be tested
  meaningfully without it. Whether one flag covers both edges or two separate flags (one for
  Left Yard, one for Arrived at Yard) fire independently is `NOT SPECIFIED` — propose two
  independent flags (matching how the other per-instant detectors in this file are scoped),
  flagged as a proposal.

### REQ-52 — Departure-yard derivation on `SamsaraAssetDayEvent` `[UNVERIFIED]`

- **Statement:** `SamsaraAssetDayEvent.departureYardId` (REQ-50's schema) is populated by the same
  cron: the yard whose geofence (any of its addresses, within 500m — REQ-50's Notes) the asset was
  inside when it **first left** that day, i.e. the yard nearest the moment immediately preceding
  `leftYardAt`.
- **Surface:** schema, api
- **Sources:**
  - **Round 9, item F12** — `[UNVERIFIED]` — kind: decision, `reference`, pending the TCG assets
    owner — *"Departure yard: from the Samsara location. The departure yard is the yard whose
    geofence the asset was inside when it first left that day. This replaces the example
    derivation in [the earlier crew-flag note] ('the Samsara location at the first engine-on or
    trip start'). `Asset.yardId` is still not the rule."*
  - `decisions/2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md`
    clause 2 — `status: reference` (developer reading, superseded in part by F12 for the
    derivation mechanism, per its own `provenance_note:`) — kind: decision — *"The flag uses the
    departure yard, not `Asset.yardId`… Nothing in the schema records which yard an asset left
    from on a given day."*
  - `apps/api/prisma/schema.prisma` `Asset.yardId → Yard`, `Yard.addresses Address[]` — kind:
    code — confirms `Asset.yardId` exists as a standing "home yard" field but is explicitly
    **not** the rule, per both sources above.
- **Conflict:** none.
- **Open question:** none — F12 supersedes its own predecessor's example wording; both agree on
  the underlying rule (the yard the asset actually left from, not its standing `Asset.yardId`).
- **Ripple:** `none — new field on a new table (REQ-50), additive`.
- **Acceptance:** for an asset/date with a `leftYardAt` instant, `departureYardId` is set to
  whichever tenant yard's geofence contained the asset's location immediately before that
  instant; if no yard's geofence matches (e.g. the asset started the day already off-site, or
  yard coordinates are unset — `Address.latitude`/`.longitude` are nullable), `departureYardId`
  stays null.
- **Notes for the executor:** which day's departure yard a **multi-day, non-holdover** job is
  judged against is resolved implicitly by REQ-53's own "judge at the job's last day" rule
  (Round 10) — the departure yard is derived once, from the day the asset actually left (normally
  the job's first day), and the return check runs once, after the job's last ticket's end date;
  see REQ-53.

### REQ-53 — `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD` detector `[CONFLICT]`

> **This requirement is built against the developer's reference-status reading (F13/Round 10),
> which conflicts with Corrina Bustos's own verified words on the same flag. The conflict is
> named below and is not resolved by this spec** — the coordinator's explicit instruction for
> this draft. Do not silently pick a winner; both readings are stated.

- **Statement:** Once a job's last ticket's end date (across every ticket on that job) has
  passed, for every **crane** asset used on that job whose `JobResourceAllocation.isHoldover` is
  `false` **and for which a `SamsaraAssetDayEvent` row exists for the job's last work date**,
  check whether that asset's last-known position that day (its `SamsaraAssetDayEvent.
  lastEngineOffAt`/location) falls inside its `departureYardId` geofence (REQ-52). If not, raise
  one blocking `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD` flag per `TicketEmployee` on that asset's
  ticket for that day, blocking that crew's weeks. **An asset with no `SamsaraAssetDayEvent` row
  for that date — untracked, or a Samsara link gone silent — raises nothing**: this is fail-open,
  matching REQ-51/U20's "no data, no flag" rule exactly, per Round 11.
- **Surface:** api, web
- **Sources:**
  - **Round 9, item F13** — `[UNVERIFIED]` — kind: decision, `reference`, pending Corrina Bustos
    and Lisette Anzaldo — developer, verbatim: *"after ticket end date pass."* Full text: *"When
    the asset is judged: after the ticket's end date. Once the ticket's end date has passed, the
    check asks whether the asset is inside its departure yard's geofence. If it is not, the asset
    is flagged."*
  - `decisions/2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md`
    clause 3 — **`[VERIFIED]`** — kind: decision — Corrina, verbatim: *"I dont think it would go
    off a time. it would trigger if the asset shut off at address other than the los alamitos or
    Ventura yard addresses."* **This is an event trigger (a shut-off away from the yard), not a
    date-based position check.**
  - **The conflict, stated plainly, per F13's own text in the vault:** *"Her trigger is an event:
    a shut-off away from the yard. This one is a position check, made once a date has passed. The
    two can give different answers. For example, an asset shut off away from the yard, and back
    inside it by the time the check runs, flags under hers and not under this one."* Neither
    reading is more authoritative by default: Corrina's is verified but was given before the
    developer chose a buildable check; the developer's is what is actually specified here for
    building, precisely because "an event trigger" alone (with no batch/cron model) is harder to
    implement without a design the vault does not supply. **This spec does not choose between
    them.** `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md`'s own
    `conflicts_with:` frontmatter names this same decision note, confirming the tension is
    already recorded at the vault level, not invented here.
  - **Round 10** — `[UNVERIFIED]` — kind: reference, relayed 2026-09-30, not yet vaulted —
    *"U21 multi-day non-holdover job: JUDGE AT THE JOB'S LAST DAY — only check once the job's
    last ticket date has passed (no nightly flags mid-job). Still date-based: in tension with
    Corrina's verified 'trigger if the asset shut off at address other than …' (recorded conflict
    F13)."* This directly resolves the false-positive risk the vault's own decision notes had
    flagged as unresolved (*"assets legitimately parked at a job site overnight on a multi-day
    job that is not a holdover would also trigger it"*) — an asset that stays on-site between a
    multi-day job's shift days no longer flags nightly; only its position after the **job's**
    last day matters.
  - **Round 9, item F14** — `[UNVERIFIED]` — kind: decision, `reference`, pending Corrina Bustos
    (scope) and Lisette Anzaldo (holdover) — *"Scope: cranes only, and holdover jobs are
    skipped. 'Cranes only' narrows Corrina's 'an asset.' The holdover exclusion is her own. What
    makes a job a holdover is still open in dispatch/gaps.md."*
  - `apps/api/prisma/schema.prisma` `Asset.subCategoryId → SubCategory.categoryId → Category.name`
    (free text, `:591-618`, `:656-681`) — kind: code — confirms Assets carry **no typed
    category/enum**; "cranes only" must match on `Category`/`SubCategory` name, not a type flag —
    correcting an unstated assumption in the planner's framing.
  - `apps/api/prisma/schema.prisma` `JobResourceAllocation.isHoldover` (`Boolean @default(false)`)
    — kind: code — confirmed directly, written by Copy Allocations' "Hold over" toggle.
  - `dispatch/gaps.md` → *Does copying allocations make a job a holdover?* — kind: vault,
    `status: open` — confirms the holdover definition itself is unresolved, independent of this
    detector's own logic; this requirement simply reads the existing `isHoldover` flag as-is.
  - **Round 11** (`/tmp/.../scratchpad/answers.md` → "## Round 11 (spec-u14-u21 Q40/Q41,
    2026-09-30)") — `[UNVERIFIED]` — kind: reference, devmohsinakram, relayed 2026-09-30, not yet
    in the vault — *"Q41 U21 untracked/silent crane: SKIP IT — no Samsara data, no asset flag
    (fail-open, same as U20)."* **Resolves Q41**, against this spec's own earlier default
    (fail-safe) — see §12 Q41. This is a scope/trigger-data answer, independent of the F13
    date-vs-event conflict below — it does not touch, and does not resolve, that conflict.
- **Conflict:** `decisions/2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md`
  clause 3 (`[VERIFIED]`, event-triggered) vs. Round 9 item F13 / Round 10 (`reference`,
  date-triggered, built here). Both are named above with their standing stated plainly. This
  requirement is built against the date-triggered reading because it is the one the vault records
  as buildable and because it resolves the multi-day false-positive risk explicitly (Round 10);
  Corrina's own trigger remains the verified statement of intent and should be put to her, and to
  Lisette Anzaldo, for reconciliation before this ships to a real tenant. **Not resolved by this
  spec, per instruction.**
- **Open question:** none — **resolved, Q41** (see Sources, Round 11). The date-vs-event trigger
  question (F13) is a separate, still-open matter — see *Conflict* above, not resolved here.
- **Ripple:** see §11a row 6.
- **Acceptance:** for a non-holdover job whose crane asset **has a `SamsaraAssetDayEvent` row for
  the job's last work date** and whose last-known position that date is outside its
  `departureYardId` geofence, once that date has passed, one `OPEN`
  `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD` flag is raised per `TicketEmployee` on that asset's
  ticket for that date, all sharing one `groupKey`; a holdover job, a non-crane asset, or an asset
  back inside its departure yard by the time the check runs, raises nothing (per the
  date-triggered reading — see Conflict); **an asset with no `SamsaraAssetDayEvent` row for that
  date raises nothing either** — untracked and Samsara-silent cranes are indistinguishable from
  "returned fine" to this detector, by design (Round 11).
- **Notes for the executor:** build fail-open (Round 11) — **not** the fail-safe default this
  spec originally proposed before Q41 was answered. This means the three 200-ton-plus cranes
  named silent for 8–13 months in `assets/gaps.md` → *Which dispatchable cranes are untracked…*
  will never raise this flag while their Samsara link stays silent, however they are actually
  used — a known, accepted gap per this answer, not an oversight; do not add a compensating
  alert elsewhere without a source asking for one. "Cranes only" — match
  `Category.name`/`SubCategory.name` case-insensitively against a configured or hardcoded "crane"
  term; `NOT SPECIFIED` which, since no source gives an exact matching rule; flag for
  confirmation before relying on it in a tenant whose category naming differs from TCG's own.

### REQ-54 — `dispatch.asset_not_returned` notification `[UNVERIFIED]`

- **Statement:** When REQ-53 raises `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD`, every active user
  whose employee's department role grants the `dispatch` permission module at `view` or above is
  notified, in-app and by email, via a new `dispatch.asset_not_returned` notification type.
- **Surface:** api, shared
- **Sources:**
  - **Round 9, item F15** — `[UNVERIFIED]` — kind: decision, `reference`, pending Lisette
    Anzaldo — *"Dispatch notification: holders of the dispatch permission are notified, in-app
    and by email. Corrina's words were only 'dispatch notified.' Who is notified, and how,
    belongs to dispatch."*
  - `decisions/2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md`
    clause 3 — `[VERIFIED]` — kind: decision — Corrina: *"payroll admin/payroll manager, and
    dispatch notified"* — confirms dispatch notification is her own stated requirement, not only
    the developer's addition; F15 supplies the mechanism (permission-based, in-app + email).
  - `apps/api/src/usecase/notifications/notification-catalog.ts:415-433`
    (`payroll.entry_sent_back`, `defaultChannels: ['IN_APP', 'EMAIL']`; `payroll.entry_corrected`,
    `['IN_APP']`) — kind: code — **the precedent this notification follows** (per the
    coordinator's correction: `payroll.ticket_voided`/`payroll.flags_raised`, cited in `spec.md`,
    do not exist yet either — `entry_sent_back`/`entry_corrected` are the two live examples of
    this catalog's shape today).
  - `apps/api/src/usecase/notifications/recipient-resolver.service.ts:26-44` (`RecipientSpec`
    union, including `{ permission: PermissionRecipientSpec }`, added by U1's REQ-02) — kind:
    code — **verified directly**: the permission-based recipient spec already exists on this
    branch (comment: *"e.g. Payroll Admin/Manager: payroll-admin, PAYROLL-FLAGS REQ-02"*), with
    `resolvePermissionHolders` (`:212-241`) and `permissionGrantWhere` (`:58-67`) implementing it
    — **built, with no caller yet**. This requirement is that spec's first real caller outside
    payroll.
  - `packages/shared/src/constants/permissions.ts:27` (`'dispatch'` in `PERMISSION_MODULES`) —
    kind: code — verified directly; confirms `dispatch` is an existing, real permission module,
    so `{ permission: { module: 'dispatch', minLevel: 'view' } }` is a valid, already-supported
    recipient spec today — no new resolver logic needed, only a new catalog entry and call site.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `none — new notification type and its one call site, additive (established by:
  grep -rn "asset_not_returned" apps/api/src packages/shared/src returning no hits before this
  spec)`. The `{ permission }` `RecipientSpec` variant itself is reached for the first time
  outside its own U1 unit — not a behavior change to that variant, a new consumer of it.
- **Acceptance:** raising `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD` (REQ-53) triggers
  `dispatch.asset_not_returned`, delivered `IN_APP` and `EMAIL` to every active user whose
  employee holds `dispatch` at `view` or above.
- **Notes for the executor:** exact notification copy is `NOT SPECIFIED` — no source supplies it;
  build functional copy naming the asset, the job, and the departure yard, following
  `payroll.entry_sent_back`'s render-function pattern. Whether portal `ADMIN`/`SUPER_ADMIN` users
  should also receive it is `NOT SPECIFIED` — per REQ-02's own documented constraint (*"the
  portal ADMIN/SUPER_ADMIN guard bypass never makes anyone a recipient by itself"*), they do
  **not**, by the existing mechanism's own design; do not add an exception.

---

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** yes — for REQ-47 (`TicketEmployeeTimeOverride`) and REQ-50/52
  (`SamsaraAssetDayEvent`, including `departureYardId`) only. REQ-40–46, REQ-48/49, REQ-51,
  REQ-53/54 need no schema change (REQ-40/41 reuse `TicketTimeAdjustment`'s existing `VarChar`
  `stepKey`; REQ-42–46, REQ-51/53 write to `PayrollFlag`, this ticket's own U5 schema, unbuilt at
  the time of this draft but not modified further by this file; REQ-54 writes to the existing
  notification catalog).
- **Migration required:** yes, one migration covering both new tables, committed under
  `apps/api/prisma/migrations/`, per `.ai/claude/contexts/prisma.md`.
- **Data backfill required:** no — both new tables start empty.

```prisma
// See REQ-47's Notes for TicketEmployeeTimeOverride, and REQ-50/52's Notes for
// SamsaraAssetDayEvent (including departureYardId). Reproduced together here per the template.

model TicketEmployeeTimeOverride {
  id               String              @id @default(uuid()) @db.Uuid
  tenantCompanyId  String              @map("tenant_company_id") @db.Uuid
  ticketEmployeeId String              @map("ticket_employee_id") @db.Uuid
  type             TicketTimeEntryType
  sequence         Int?                @map("sequence")
  startedAt        DateTime?           @map("started_at") @db.Timestamptz()
  endedAt          DateTime?           @map("ended_at") @db.Timestamptz()
  reason           String              @db.Text
  createdByUserId  String              @map("created_by_user_id") @db.Uuid
  createdAt        DateTime            @default(now()) @map("created_at") @db.Timestamptz()

  @@unique([ticketEmployeeId, type, sequence], name: "uq_ticket_employee_time_overrides_member_type_seq")
  @@map("ticket_employee_time_overrides")
}

model SamsaraAssetDayEvent {
  id               String    @id @default(uuid()) @db.Uuid
  tenantCompanyId  String    @map("tenant_company_id") @db.Uuid
  assetId          String    @map("asset_id") @db.Uuid
  workDate         DateTime  @map("work_date") @db.Date
  leftYardAt       DateTime? @map("left_yard_at") @db.Timestamptz()
  arrivedYardAt    DateTime? @map("arrived_yard_at") @db.Timestamptz()
  lastEngineOffAt  DateTime? @map("last_engine_off_at") @db.Timestamptz()
  lastEngineOffLat Decimal?  @db.Decimal(9, 6)
  lastEngineOffLng Decimal?  @db.Decimal(9, 6)
  departureYardId  String?   @map("departure_yard_id") @db.Uuid
  computedAt       DateTime  @default(now()) @map("computed_at") @db.Timestamptz()

  @@unique([tenantCompanyId, assetId, workDate], name: "uq_samsara_asset_day_events_tenant_asset_date")
  @@map("samsara_asset_day_events")
}
```

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| `TicketEmployeeTimeOverride` | none proposed | n/a | n/a | REQ-47 — see below |
| `SamsaraAssetDayEvent` | none proposed | n/a | n/a | REQ-50 — see below |

- **New prefix introduced:** no. Neither table carries a business code — both are
  system-generated, workflow/derived-data rows, following the same precedent `spec.md` REQ-09
  used for `PayrollFlag` (citing `PayrollSendBack` as the standing no-code precedent). `NOT
  SPECIFIED` field-for-field beyond what REQ-47/50 state is needed; flagged, not invented.
- **Child relations:** `TicketEmployeeTimeOverride.ticketEmployeeId` and
  `SamsaraAssetDayEvent.assetId`/`.departureYardId` reference parent UUIDs, never codes, per
  convention.
- **Fields whose type/precision no source states:** `TicketEmployeeTimeOverride.reason`'s max
  length — `NOT SPECIFIED`, treated as unbounded `Text` per `TicketTimeAdjustment.reason`'s own
  pattern. `SamsaraAssetDayEvent`'s coordinate precision follows `Address.latitude`/`.longitude`'s
  existing `Decimal(9,6)`, matched exactly rather than invented.

## 4. API surface — `apps/api`

Layering is `presentation → usecase → service → orm`, never upward, per `CLAUDE.md` and
`.ai/claude/contexts/api.md`.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `PATCH` | `.../tickets/:id/segments/:segmentId` (extended guard) | `field-tickets.controller.ts` (existing) | `ticket-work-segments.service.ts` (existing, exemption extended) | — | REQ-40 |
| `PATCH`/`POST`/`DELETE` | `.../tickets/:id/lunch-breaks/...` (extended guard) | existing lunch-breaks controller | `ticket-lunch-breaks.service.ts` (existing, exemption extended) | — | REQ-41 |
| — (no new route) | — | — | `payroll-flag-detection.service.ts` (U5, extended) | — | REQ-42, REQ-43, REQ-44, REQ-45, REQ-46, REQ-51, REQ-53 |
| `POST` | `.../ticket-employees/:id/time-overrides` (new) | new controller | new use-case | new repository | REQ-47 |
| — (read path, no new route) | — | — | `payroll.service.ts buildJobDay` (extended) | — | REQ-48 |
| (cron, no HTTP route) | — | — | new `samsara-day-events.service.ts` | `samsara.repository.ts` (existing, read) | REQ-50, REQ-52 |
| — (notification only) | — | — | `payroll-flag-detection.service.ts` calls `notify()` | — | REQ-54 |

Per endpoint (new ones only — the extended existing endpoints keep their current shapes, gaining
only the exemption/validation described in REQ-40/41):

- **Request DTO:** `create-ticket-employee-time-override.dto.ts { type: TicketTimeEntryType,
  sequence?: number, startedAt?: string, endedAt?: string, reason: string }`, `reason` required
  by `@IsNotEmpty()`, per G1.
- **Response shape:** `NOT SPECIFIED` exact JSON — build to match the existing
  `PayrollSendBack`/`TicketTimeAdjustment` response conventions in the same module family, per
  code convention, not a sourced contract.
- **Guards / roles:** `AccessTokenGuard` (global) + `payroll-admin` at `edit` or above for the
  override-creation endpoint (REQ-47), matching REQ-01's established role; mobile segment/lunch
  edits (REQ-40/41) are gated by the primary-employee-plus-open-send-back condition, not a
  permission module.
- **Route param identity:** `ticketEmployeeId` is a UUID on the boundary, not a business code —
  consistent with existing patterns; no new code type is introduced by this file.
- **Errors:** override creation refused (400) without a reason or for a `type`/`sequence`
  combination that already has an active override until superseded (see REQ-47's Notes,
  `NOT SPECIFIED` whether "superseded" means update-in-place or a new row — proposed new row);
  segment/lunch edits refused (403) for a non-primary employee, refused (409) with no open
  `SENT_BACK` row.
- **Module registration:** new modules registered in `app.module.ts`; barrel `index.ts` in every
  new folder, per `CLAUDE.md`.

## 5. Web surface — `apps/web`

**Feature-first, not atomic design**, per `.ai/claude/contexts/web.md`.

- **Routes:** no new top-level route. REQ-42's flag display lands inside U5's existing flags
  panel (`spec.md` REQ-14). REQ-49's per-person override fields extend U8's fix form
  (`spec-u6-u13.md` REQ-19/21), not a new page.
- **Existing components to reuse** *(checked before proposing anything new)*: the same flags
  panel, chips and review dialog `spec.md` REQ-14 and `spec-u6-u13.md` REQ-17 already establish
  for every other detector in this framework — REQ-42/43/44/45/46/51/53 add codes to
  `PAYROLL_FLAG_CATALOG` (`packages/shared`, not yet on disk — `grep -rn "PAYROLL_FLAG_CATALOG"
  packages/shared/src` returning no hits, consistent with `spec-u6-u13.md`'s own finding), not
  new UI surfaces of their own.
- **New components proposed:** the per-crew-member selector on U8's fix form (REQ-49) — no source
  specifies its shape beyond "unlocks these fields on crew tickets"; smallest UI needed, built
  after U8 ships.
- **Table (if any):** the existing payroll worklist/flags table is unaffected beyond gaining more
  flag codes to the same generic chip rendering REQ-14 already builds.
- **Forms:** REQ-49's override fields follow react-hook-form + Zod v4, per convention;
  `NOT SPECIFIED` field-level validation beyond "reason required, non-empty" (REQ-47).
- **Server state:** TanStack Query v5; query keys/invalidation `NOT SPECIFIED` — follow existing
  payroll feature patterns.
- **Colors / spacing:** theme variables only, no hardcoded colors, per convention.
- **Responsive:** mobile-first web; 44px touch targets, per convention.
- **Copy:** `NOT SPECIFIED` throughout — no source supplies exact UI strings for any new flag
  label or the override form; do not invent product copy beyond functional labels already used
  elsewhere in the codebase.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** no new screen. REQ-40/41 extend the existing field-ticket flow's returned-
  ticket edit mode (`spec-u6-u13.md` U13's resubmit UI, REQ-32) to cover segment and lunch
  fields, removing the `EXPO_PUBLIC_ENABLE_SEGMENT_TIME_ADJUST` dev gate for that context.
- **Components:** `SegmentAdjuster` (`apps/mobile/features/field-ticket/steps/start-work/
  work-segments.tsx:161-222`) becomes reachable without the env flag, scoped to the returned-
  ticket condition (REQ-40); the existing lunch-break UI gains switch-to-worked-through's WTL
  evidence capture reused from the original mobile WTL flow (signer, signature, identity photo,
  GPS) — `NOT SPECIFIED` whether this is the exact same screen/component or a re-entry into it;
  no source gives UI detail.
- **Offline / sync behavior:** `NOT SPECIFIED` — this spec does not independently verify how a
  queued segment/lunch edit behaves against `apps/mobile`'s background-sync layer while offline;
  flag for the executor, per `.ai/claude/contexts/mobile.md`'s standing caution that offline
  behavior is a frequent silent gap.
- **Touch targets:** 48px, per convention.
- **Push / notifications involvement:** N/A for REQ-40/41 directly (no new notification type);
  REQ-54's `dispatch.asset_not_returned` is web/email-facing, not mobile.

## 7. Shared package — `packages/shared`

- **Types added / changed:**
  - `PAYROLL_FLAG_CATALOG` (this ticket's own U5, `packages/shared/src/constants/payroll-flags.ts`,
    not yet on disk) gains: `BOOM_OUT_OF_RANGE`, `RANGE_MISSING` (REQ-42); `INVALID_TIME_AM_PM`
    (REQ-43); `LABOR_TICKET_MISMATCH` (REQ-44); `MISSING_NOTES` (REQ-45);
    `CREW_YARD_TIME_MISMATCH` (REQ-46); `SAMSARA_TIME_MISMATCH` (REQ-51);
    `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD` (REQ-53) — 8 new codes, each with a per-code
    title/subject entry, per the catalog's own established shape (not independently re-verified
    here; cited by reference to `spec-u6-u13.md`'s own confirmed finding of the catalog's
    intended shape).
  - `NOTIFICATION_TYPES` gains `dispatch.asset_not_returned` (REQ-54), delivered `IN_APP` and
    `EMAIL`.
  - `PayrollTimeSource` (`apps/api/prisma/schema.prisma:224-229` — actually a Prisma enum, not a
    `packages/shared` type; noted here only because REQ-48 proposes extending it with
    `EMPLOYEE_OVERRIDE`) is **not** in `packages/shared` — correcting a possible assumption; it
    lives in the Prisma schema and generated client only. If web/mobile need to render
    `timeSource`, a corresponding shared type would need adding — `NOT SPECIFIED` whether any UI
    surface reads it today; not independently checked.

## 8. Permissions and tenancy

- **Roles permitted:**
  - REQ-40/41 (mobile segment/lunch edits): the ticket's primary employee only, via the same
    condition REQ-30 (U13) establishes — no new permission module.
  - REQ-47 (override creation): `payroll-admin` at `edit` or above, matching REQ-01.
  - REQ-42–46, REQ-51, REQ-53 (detectors): no direct caller-facing permission — these run inside
    Calculate; their *output* (the flag) is visible to `payroll-admin` at `view` or above, per
    U5's existing flag-read guard.
  - REQ-54 (notification): every active user whose employee holds `dispatch` at `view` or above,
    per F15 and the existing `{ permission }` `RecipientSpec` mechanism.
- **Roles denied:** every other role, for every action above — no exceptions sourced.
- **Tenant isolation:** standard — every new table (`TicketEmployeeTimeOverride`,
  `SamsaraAssetDayEvent`) carries `tenantCompanyId`, scoped by the existing Prisma client
  extension convention (`.ai/claude/contexts/prisma.md`); no exception identified or sourced.
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| `TicketTimeAdjustment.stepKey` (segment/lunch values, REQ-40/41) | non-empty, matches an accepted segment/lunch identifier | this spec's own proposal (REQ-40 Notes) | — |
| `create-ticket-employee-time-override.dto.ts reason` | required, non-empty | Round 9 G1 | `[UNVERIFIED]` |
| `reason` max length (any of the above) | `NOT SPECIFIED` — no source states a limit | — | — |
| `LABOR_TICKET_MISMATCH` tolerance | 30 minutes, on the **total** of both edges' absolute differences (Q40, resolved) | Round 9 F3; Round 11 | `[UNVERIFIED]` |
| `SAMSARA_TIME_MISMATCH` tolerance | 30 minutes | decision 2026-09-29 invalid-entry clause 2 | `[VERIFIED]` |
| Yard geofence radius | 500 m | Round 9 F11 | `[UNVERIFIED]` |

Invented validation is still invention. A max length nobody wrote down is `NOT SPECIFIED`.

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | `checkBoomRange` output (`OUT_OF_RANGE`/`RANGE_MISSING`/`IN_RANGE`/`null`) maps to the correct flag code or no flag | REQ-42 |
| Unit | AM/PM-fixable out-of-order pairs raise `INVALID_TIME_AM_PM` and suppress `INVALID_TIME_OUT_OF_ORDER` for the same pair; a non-fixable pair raises only the latter | REQ-43 |
| Unit | `LABOR_TICKET_MISMATCH` fires at a 31-minute total (both edges summed), not at 30 or below; and **fires** for a 20-minute start offset plus a 20-minute end offset (40 min total, neither edge alone over 30) — the case that distinguishes the total-difference rule from the per-edge reading this spec originally proposed | REQ-44 |
| Unit | `MISSING_NOTES` fires for each of the 5 triggers independently when all 5 note fields are empty, and is cleared by any one non-empty field | REQ-45 |
| Unit | `CREW_YARD_TIME_MISMATCH` groups tickets by `(jobId, date)` correctly, flags only the minority ticket(s)' crew, and flags every ticket on an even split | REQ-46 |
| Unit | An override for `(ticketEmployeeId, type, sequence)` is read in preference to the shared value; absence falls back correctly; a different employee's pricing is unaffected | REQ-48 |
| Unit | Departure-yard derivation picks the correct yard when the asset's pre-departure location is inside more than one yard's geofence's overlap (edge case) or none | REQ-52 |
| Unit | `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD` does not fire until the job's last ticket's end date has passed, even when an earlier day's engine-off was away from the yard | REQ-53 |
| Unit | `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD` raises nothing for a crane with no `SamsaraAssetDayEvent` row for the job's last work date (untracked or Samsara-silent), even past the job's last ticket's end date — fail-open, per Round 11 | REQ-53 |
| Integration (API) | Segment/lunch edit endpoints refuse a non-primary employee and refuse without an open `SENT_BACK` row; succeed for the primary with a reason on a returned ticket | REQ-40, REQ-41 |
| Integration (API) | Override creation refuses without a reason; a created override is read back correctly by `buildJobDay` | REQ-47, REQ-48 |
| Integration (API) | `dispatch.asset_not_returned` is sent `IN_APP` and `EMAIL` to every `dispatch`-permission holder, and to no one else | REQ-54 |
| E2E / manual script | A crew ticket's Left Yard mismatch flags only the differing ticket's crew; the rest approve normally | REQ-46 |

- Requirements with no testable acceptance criterion: REQ-49 (UI layout/copy `NOT SPECIFIED`,
  and blocked in practice on U8's own form).

## 11. Non-functional

- **Performance:** `NOT SPECIFIED`. REQ-46's job+date grouping query and REQ-50's cron both scale
  with the tenant's daily ticket/asset volume; no source states a time budget. The Samsara cron
  (REQ-50) in particular should be checked against the live API's own rate limits, since
  `samsara.repository.ts` is a live-GET client with no cache today — flag for the executor.
- **Concurrency:** `NOT SPECIFIED` beyond the existing per-period run serialization (`spec.md`
  §11); not independently re-verified for the new tables' own write paths.
- **Audit / activity log:** `TicketTimeAdjustment` (REQ-40) and `TicketEmployeeTimeOverride`
  (REQ-47) are each their own audit trail by design (initial/adjusted value, reason, who/when);
  whether either also writes to the tenant-wide `ActivityLog` is `NOT SPECIFIED`, same standing
  as `spec.md`'s own treatment of `PayrollFlagEvent`.
- **Migration/rollout order:** schema (REQ-47, REQ-50/52) → api (everything else, in roughly
  REQ-40 → REQ-54 order, respecting REQ-48's dependency on U8 and REQ-51's dependency on REQ-50)
  → web (REQ-42's flag display, REQ-49) → mobile (REQ-40/41). REQ-48's `payroll-pricing` half and
  REQ-49 cannot land before `spec-u6-u13.md`'s U8 ships — this is a **cross-file build-order
  dependency**, not only a spec dependency, and should be called out explicitly when these units
  are sequenced.

## 11a. Ripple — already-shipped behaviour these requirements reach

| # | Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `EXPO_PUBLIC_ENABLE_SEGMENT_TIME_ADJUST` dev gate and its one call site | direct removal | REQ-40 | **changes deliberately** — removed for the returned-ticket case; no other reader found | `apps/mobile/features/field-ticket/timers/segment-time-adjust.ts:32` (code) | `grep -rn "SEGMENT_TIME_ADJUST_ENABLED\|ENABLE_SEGMENT_TIME_ADJUST" apps/mobile` (facts agent, not independently re-run) |
| 2 | `TicketLunchBreaksService`'s existing add/remove/switch operations (already used by the payroll correction page per C11) | shared service, new caller | REQ-41 | **unchanged in mechanism, new caller added** — the worker's mobile path calls the same operations C11 already authorizes for the payroll correction page | `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` §C11 (reference) | read directly |
| 3 | The boom-range web warning (`payroll-employee-table.cells.tsx:157-184`, `.expanded.tsx:121-139`) and `assertNoOpenSendBacks`'s send-back-count logic (`payroll.service.ts:828-854`) | direct component reuse / adjacent gate | REQ-42 | **the web badge changes deliberately** (replaced by the shared flag chip); **`assertNoOpenSendBacks` is unchanged by this requirement** — it governs the separate, soon-to-be-retired Crane-Supervisor send-back mechanism (U9), not this new flag | `payroll.service.ts:828` (code, verified directly) | read directly |
| 4 | `spec-u6-u13.md` REQ-16's `INVALID_TIME_OUT_OF_ORDER` detector (unbuilt) | shared "which flag wins for this pair" logic | REQ-43 | **changes deliberately** — REQ-16 must not also flag a pair this detector claims as AM/PM; cross-file coordination needed since this spec cannot edit `spec-u6-u13.md` | Round 10 (reference) | see REQ-43's Ripple field |
| 5 | Every crew ticket's `YARD_TIME` capture (existing, unaffected) | new read-only detector | REQ-46 | **unchanged** — this is a new read over existing data, writes nothing to `TicketTimeEntry` | `TicketTimeEntry` schema (code) | read directly |
| 6 | `buildJobDay`'s existing per-member pricing branches, and every existing crew ticket's priced `PayrollJobDay` rows | new read added to an existing assembly function | REQ-48, REQ-53 | **changes deliberately for tickets with an override or an asset flag; unchanged for every ticket without one** — REQ-48 adds one more conditional read to a function that already branches per-member; REQ-53 is a new, independent detector | `payroll.service.ts:1257-1430` (code) | read directly |

- **Surfaces with no existing behaviour in this area:** `TicketEmployeeTimeOverride`,
  `SamsaraAssetDayEvent`, the 8 new flag codes, and `dispatch.asset_not_returned` are all new —
  established by the per-requirement `grep` commands cited in each REQ's own Ripple field
  returning no hits before this spec.
- **Consumers with no source for what happens to them:** none beyond row 4, which has a stated
  (if cross-file) resolution rather than an open question.

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Nothing below is built until these are answered — except where a
requirement above already states a smallest-safe-default and proceeds with it flagged, which is
true of both questions here.

```bash
grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/PAYROLL-FLAGS/spec-u14-u21.md
```

### Q40 — REQ-44: is the 30-minute labor-vs-ticket tolerance measured per edge or on the total difference?

- **Question:** For `LABOR_TICKET_MISMATCH`, does "differ by more than 30 minutes" mean the start
  difference and end difference are each tested independently against 30 minutes, or that the
  *total* elapsed-time difference between the two windows must exceed 30 minutes?
- **Why it cannot be answered from what is written:** Round 9's F3 gives the figure and its
  origin (reused from the Samsara tolerance) but not which of the two readings it intends; the
  vault's own "Not settled by round 9" section lists this explicitly: *"For F3, whether 'more
  than 30 minutes' is measured at each end or on the total."*
- **Blocked:** REQ-44's exact trigger condition at the margin (a case with a 20-minute start
  offset and a 20-minute end offset, same direction, would flag under a total-difference reading
  at 40 minutes combined, but not under a per-edge reading).
- **Candidates:** `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md`
  §Round 9, F3 (reference, does not disambiguate); `payroll/gaps.md` → *Flagged entries go to
  payroll…* Q7 (open, same gap).
- **Owner:** Corrina Bustos.
- **Workaround, if any:** this spec originally proposed per-edge as the smallest-safe default —
  **superseded by the answer below.**
- **Answer (2026-09-30, developer direction, devmohsinakram, relayed in the coordinating
  session, "Round 11"):** *"TOTAL DIFFERENCE — flag when |own start − Start Ticket| + |own end −
  End Ticket| > 30 min (not per edge)."* This goes **against** this spec's own stated default.
  Folded into REQ-44: the Statement, Acceptance, Notes and §10's test list are all updated to the
  total-difference rule, including a test case (20 min + 20 min = 40 min total, neither edge
  alone over 30) that would pass silently under the old per-edge default.
- **Status:** resolved — developer direction, devmohsinakram, 2026-09-30, `reference`; not yet
  written into `.ai/vault/decisions/` (recommend `tcg-scrum` record it, same standing as Round 9
  and Round 10).

### Q41 — REQ-53: does the asset-not-home flag fail-safe or fail-open for an untracked/silent asset?

- **Question:** For `ASSET_NOT_RETURNED_TO_DEPARTURE_YARD`, when the asset has no
  `SamsaraAssetDayEvent` row for the job's last work date (untracked, or a linked Samsara asset
  that has gone silent), does the detector flag it (cannot confirm return, so treat as unresolved)
  or skip it (no data, no flag — consistent with REQ-51/F10's rule for the Samsara *time*
  flag)?
- **Why it cannot be answered from what is written:** Round 9's F10 explicitly scopes its
  "no data → no flag" answer to the Samsara time flag (REQ-51) only, and states plainly: *"For
  the asset flag (F13), the handling of untracked or silent assets was not stated. assets Q7
  stays open."*
- **Blocked:** REQ-53's behavior for any crane the tenant has not linked to Samsara, or whose
  link has gone silent (`assets/gaps.md` → *Which dispatchable cranes are untracked…* names three
  200-ton-plus cranes silent for 8–13 months at TCG itself — not a hypothetical edge case).
- **Candidates:** `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md`
  §Round 9, F10 (reference, explicitly leaves this open); `assets/gaps.md` → *Asset not returned
  to its home yard…* Q7 (open); `assets/gaps.md` → *Which dispatchable cranes are untracked…*
  (open, names the specific affected assets).
- **Owner:** Corrina Bustos, with the TCG assets owner for the untracked-fleet question underneath
  it.
- **Workaround, if any:** this spec originally proposed fail-safe (flag it) as the smallest-safe
  default — **superseded by the answer below.**
- **Answer (2026-09-30, developer direction, devmohsinakram, relayed in the coordinating
  session, "Round 11"):** *"SKIP IT — no Samsara data, no asset flag (fail-open, same as U20)."*
  This goes **against** this spec's own stated default. Folded into REQ-53: the Statement,
  Acceptance, Notes and §10's test list are all updated to fail-open — an untracked or
  Samsara-silent crane raises nothing, indistinguishable from "returned fine" to this detector.
  This is a scope/trigger-data answer only; it does not touch, and does not resolve, REQ-53's
  separate `[CONFLICT]` (F13's date-triggered reading vs. Corrina's own verified event-triggered
  words) — that conflict is unchanged by this answer and remains open, per the coordinator's
  instruction.
- **Status:** resolved — developer direction, devmohsinakram, 2026-09-30, `reference`; not yet
  written into `.ai/vault/decisions/` (recommend `tcg-scrum` record it, same standing as Round 9
  and Round 10).

## 13. What this spec deliberately does not specify

- **Exact UI copy and layout** for every new web/mobile surface (REQ-42's flag chip labels,
  REQ-49's override form, REQ-54's notification copy) — no source supplies it; see each REQ's
  `NOT SPECIFIED` markers.
- **F13's conflict itself (REQ-53)** — named plainly, not resolved, per the coordinator's explicit
  instruction. The date-triggered reading is what is built; Corrina's own event-triggered words
  remain the verified statement of intent and are not overruled by this spec.
- **C10 (End Work = break-down end vs. crew leaving the job site)** — an existing open vault item
  (`decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` §C10), pending
  the TCG field-ops owner. Noted in REQ-40's Ripple field as not blocking that requirement, and
  not duplicated as a new question here.
- **Which of a yard's several `Address` rows defines its geofence** when more than one exists
  (REQ-50) — proposed default (match against any), not sourced.
- **Exact `TicketTimeAdjustment`/audit-row naming for segment and lunch edits** (REQ-40/41) — a
  proposed mechanism, not a sourced one; flagged in each requirement's Notes.
- **Whether an override can be superseded by an update-in-place or must always be a new row**
  (REQ-47) — proposed default (new row), not sourced.
- **U19's exact interaction with U8's fix form** (REQ-49) — genuinely cannot be finalized before
  `spec-u6-u13.md`'s U8 ships; flagged as `OPEN — cannot be fully stated` in that requirement's
  own Ripple field, which is not the same as a blocking §12 question, since U8's own spec is the
  place that resolves it.
- **Whether Round 9 (`F1`–`F15`, `G1`–`G2`), Round 10 and Round 11 need to be written into the
  vault's live registers** (`payroll/gaps.md`, `assets/gaps.md`, `dispatch/gaps.md`) beyond what
  `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` already records —
  Round 9 is recorded there already (per its own "Effect on the vault (round 9)" section); Rounds
  10 and 11 are not yet, as of this draft — recording them, including Q40/Q41's resolution, is
  `tcg-scrum`'s job, not this spec's, and not a blocking question for the executor either way,
  since the coordinator explicitly relayed both for this fold-in.

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person — *(no
      REQ in this file is `[OPEN]`; Q40 and Q41 are now both resolved — see below)*
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` — *(REQ-53's
      conflict is already recorded in the vault, in both directions —
      `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md`'s
      `conflicts_with:` and the crew-time-flag note's own text — but it is not **resolved** by a
      decision note; that is Corrina Bustos's and Lisette Anzaldo's call, named in REQ-53, not
      this spec's or `tcg-scrum`'s to make. Round 11's fail-open answer is a separate,
      scope/trigger-data question and does not touch this conflict — it stays exactly as open as
      it was at first publish.)*
- [x] Answers written back into `spec-u14-u21.md` with their new sources and flags — *(REQ-44's
      Statement/Acceptance/Notes rewritten to the total-difference rule; REQ-53's
      Statement/Acceptance/Notes rewritten to fail-open on missing Samsara data; §1's ledger,
      §9's validation table and §10's test list all updated to match; both against this spec's
      own originally-stated defaults)*
- [x] Every §12 question updated to `Status: resolved — …` — *(Q40 and Q41 both point at Round
      11, developer direction, devmohsinakram, 2026-09-30, `reference`, not yet in
      `.ai/vault/decisions/` — recommend `tcg-scrum` write it in next, matching Round 9/10's own
      treatment)*
- [x] Every §11a ripple row has a source for what happens to that consumer, or a §12 question —
      *(all 6 rows state what happens, with a source; row 4's cross-file coordination is noted,
      not left silent)*
- [ ] Decomposed into vertical units — `units.md` (currently covers U1–U5 only; U14–U21 need their
      own decomposition pass once this spec, `spec.md`, and `spec-u6-u13.md` are all reviewed
      together, since several of this file's requirements — REQ-48/49 on U8, REQ-43 on
      `spec-u6-u13.md`'s REQ-16 — depend on units defined in the other two files)

Answered by: ______________  Date: ______________

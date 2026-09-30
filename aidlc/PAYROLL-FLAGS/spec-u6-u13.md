# Spec — PAYROLL-FLAGS Flagged-entries rework, units U6–U13

> Written to `.ai/aidlc/PAYROLL-FLAGS/spec-u6-u13.md` by the elaborator
> (`.ai/aidlc/agents/inception/tcg-elaborator.md`), as a **separate file from
> `spec.md`**, because U1–U5's build agents are reading and appending to `spec.md` and
> `units.md` while this was written. **This file does not edit `spec.md` or `units.md`.**
> Requirement numbers continue `spec.md`'s sequence from REQ-15. Question numbers were
> first published as Q11–Q16, then **renumbered to Q20–Q25** on 2026-09-30 after `spec.md`'s
> own U2 review folded in its own, unrelated Q11 — see §0, *A numbering note*, for both
> collisions.
>
> Like `spec.md`, **no `intent.md` exists for this ticket.** PAYROLL-FLAGS is a
> developer-scoped build on branch `feat/PAYROLL-FLAGS-foundation`, assembled from vault
> decisions and a developer-answer log, not from a Jira ticket. This spec covers units
> **U6–U13** of the larger flagged-entries rework: the rest flag, the invalid-time and
> invalid-long-boom-time flags, payroll fixing an entry for one person, retiring the Crane
> Supervisor routing, payroll completing a never-completed ticket, and Send Back rebuilt for
> the worker (crew-wide return, the 3-hour reminder, and the worker's own edit-and-resubmit).
> U14–U21 stay out of scope — each is gated on an item nobody has answered yet (the boom
> basis, the missing-notes definition, AM/PM detection, crew-ticket grouping, Samsara event
> mapping, the departure-yard record) — and are not decomposed here.
>
> **Every requirement in it carries its sources, and every source carries its status.** A
> requirement with no source is not a requirement — it is an open question, and it stays
> marked as one.

## Source status used in this spec

Same three-tier scheme `spec.md` uses, because this ticket has no `intent.md` and most of
its sourcing is the same kind of material:

- **verified** — a named TCG person (here, always Corrina Bustos, TCG Payroll Manager, in
  writing) adjudicated it. Rendered `[VERIFIED]`.
- **reference** — a CodingCops developer's direction (git user `devmohsinakram`), filling in
  mechanics a verified decision left open, or extending one. Most of it is recorded in
  `.ai/vault/decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md`
  (`status: reference`); the U6–U13 planning round (round 8) and the U14–U21 follow-up
  (round 9) live only in the session scratchpad `answers.md`, **not yet in the vault at
  all**. Rendered `[UNVERIFIED]` per the template's binary flag, with "reference" and its
  standing stated in the source line.
- **unsourced** — nothing written settles it. Rendered `[OPEN]`, or `[CONFLICT]` where two
  sourced answers disagree.

A requirement's heading flag is the worst of its sources: `[VERIFIED]` only when every
source is verified (none of REQ-15–REQ-33 qualifies — U6–U13 is reference-and-code
territory throughout); `[UNVERIFIED]` if any source is reference-status; `[CONFLICT]` if
sourced answers disagree and neither is picked; `[OPEN]` if nothing supports it at all.

---

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `PAYROLL-FLAGS` (developer-scoped, no Jira/`intent.md`) — this file covers U6–U13 only |
| Intent | none — sourced directly from the files listed below, per `spec.md`'s own banner |
| Elaborated on | 2026-09-30 |
| Branch state at elaboration | `feat/PAYROLL-FLAGS-foundation`. U1 committed (`2f8fcf5c5`, confirmed: `payroll-admin` in `PERMISSION_MODULES`/`USER_RESTRICTED_MODULES`, seed-data.ts:236-240 forces it to `'none'` on every role, the five routes gated). **U2 is uncommitted, in progress** (`git status`: `packages/payroll-engine/src/{rest-period.ts,calculate.ts,types.ts,version.ts}`, `payroll.service.spec.ts`, `payroll-rest-audit.tsx` modified; a new `payroll-rest-audit.helpers.ts`/`.test.mjs` untracked). **U3, U4 and U5 are not started** — confirmed by `grep -n "model PayrollFlag\|model PayrollSendBack\|payrollClosedAction\|PayrollTicketClosure" apps/api/prisma/schema.prisma`: only `model PayrollSendBack` (the pre-existing Crane Supervisor one) exists; `PayrollFlag`, `PayrollFlagEvent`, `PayrollTicketClosure` and `payrollClosedAction` are **not on disk anywhere** — they exist only as `spec.md` §3's proposed schema and `units.md`'s U3/U5 slice contents. **This spec cites `spec.md`/`units.md` as the source for anything U3/U5 would add, not code**, per the elaborator's own rule that a requirement's design can be cited from a sibling spec once approved, and per U2's own precedent of citing `units.md` (see `spec.md` Q9). |
| Open questions raised by this spec | 6 — Q20–Q25, all in §12. **Updated 2026-09-30, second pass:** the developer (devmohsinakram) answered all six the same day. Q20, Q21, Q22 and Q25 are folded in as settled mechanics; Q23 and Q24 are folded in as the developer's own reading, explicitly **pending Corrina Bustos** — neither is a blocking `Status: open` any more, but neither is `[VERIFIED]` either. REQ-31 (previously stated with no Statement, `[CONFLICT]`) now has one, built to the developer's answer, **[CONFLICT] tag kept** — see REQ-31 and Q24. A new requirement, REQ-33, was added for Q21's answer (`/me/labor` reads the own-window override). See §12 for each question's resolution and §2 for the requirements it changed. |
| Already-shipped behaviour reached | 22 consumers enumerated in §11a (21 at first publish, row 22 added for REQ-33 in this pass) |
| Rules consulted | `CLAUDE.md` (Identity Convention, Architecture invariants); `.ai/claude/contexts/api.md`; `.ai/claude/contexts/prisma.md`; `.ai/claude/contexts/web.md`; `.ai/claude/contexts/mobile.md`; `.ai/claude/contexts/payroll-engine.md` |

### A numbering note

**Two collisions, two renumberings.** The task that produced this file said to number
requirements from REQ-15 and questions from Q9. By the time research finished, `spec.md`
(read live, not from a stale copy) had grown from 1475 to 1521 lines: its U2 executor had
folded in a ninth open question (Q9, on the rest chain's 2nd-missed-meal grouping) **and a
tenth** (Q10, on whether the rest gap should be measured across a `chainJobDays` boundary)
— both raised by the U2 build itself, 2026-09-30, confirmed by `grep -n '^### Q' spec.md`
immediately before this file was first published. REQ-15 was still correct (`spec.md`'s
last requirement was REQ-14); this file's questions were published starting at **Q11**
instead, one past `spec.md`'s live tail.

That numbering held for less than a day. `spec.md`'s own U2 review then folded in **its
own** Q11 (on whether the rest-audit panel must state the WTL minutes that moved the gap
start — `spec.md:1456`, nothing to do with this file), colliding with this file's Q11–Q16.
On the coordinator's instruction, this file's questions are **renumbered to Q20–Q25**,
same order, with headroom above `spec.md`'s own sequence and above whatever range a
U14–U21 spec (if one exists) might be using. Every in-file cross-reference was updated in
the same pass. **REQ-15–REQ-32 keep their numbers** — only questions were renumbered; a new
requirement raised while answering these questions is appended as REQ-33, not slotted into
numeric order (see §2).

Re-run the grep below before merging any of these files, in case another concurrent
executor has moved the tail again.

```bash
grep -n '^### REQ-\|^### Q[0-9]' .ai/aidlc/PAYROLL-FLAGS/spec.md | tail -5
```

### Sources read for this spec

- `.ai/vault/decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md`
  (`verified` — Corrina Bustos, Teams, 2026-09-30) — the nine-flag list, routing, and "all
  flags block."
- `.ai/vault/decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md`
  (`verified`) — incomplete tickets block; "reviewed, no change" exists; *Not decided* item 2
  is the never-completed-ticket escape path U10 builds.
- `.ai/vault/decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md`
  (`verified`) — routing away from the Crane Supervisor (U9's mandate); *Build impact* names
  exactly what PR #690/#691 built that must come out.
- `.ai/vault/decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md`
  (`verified`; `conflicts_with: payroll/rules/PAY-045-rest-period-premium.md`) — read in full
  this time, not by citation: clause 3, Corrina's own word **"individual"**, answering *"is
  that OK, or should a fix apply to one person only?"* asked about **payroll's own**
  correction. *Conflicts* item 4 (her own note) already flags that `TicketTimeEntry` has no
  per-employee home for this rule to attach to — the fact this spec's REQ-31 turns on.
- `.ai/vault/decisions/2026-09-29-invalid-entry-flags-samsara-30-minutes-and-wtl-penalty-moves-rest-start.md`
  (`verified`) — the invalid-time list's own words (wrong AM/PM, same start/end, out of
  order, "etc"), the Samsara 30-minute tolerance (out of scope, U20), and the WTL-moves-rest
  rule U6 depends on via U2.
- `.ai/vault/decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md`
  (`verified`) — `ticket_employees.workStartedAt`/`workEndedAt` (TCG-25 own window) as the
  only per-employee home that exists; `TicketTimeEntry` stays per-ticket, crew-wide.
- `.ai/vault/decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md`
  (`reference`; superseded on routing/correction, standing on the rest; 1379 lines, read by
  grep for clause 4, and addenda D/F/G of the second 2026-09-29 addendum, and D of the fifth
  2026-09-30 addendum) — the 24-hour flag's origin (item G), the week-move rule's origin
  (item F), and the multi-crew Send Back question's origin (fifth addendum, item D).
- `.ai/vault/decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md`
  (`verified`) — not itself a U6–U13 source (it is the crew-mismatch/Samsara/asset flags,
  U18/U20/U21, out of scope), cited only for the E3 rest-flag trigger it does not change.
- `.ai/vault/decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md`
  (`reference`, devmohsinakram, pending Brian Petros / Corrina Bustos wherever a pay rule is
  touched) — items C1–C11 (behaviour and workflow) and the closing *build plan* (E1–E4) are
  this spec's single largest source. Read in full (547 lines, under the 40 KB grep
  threshold).
- `.ai/vault/payroll/gaps.md` (546,653 bytes — **never read whole**; sections read by line
  range): *Which payroll issues block approval (PAY-065)* (4665–4723); *Flagged entries go to
  payroll…* (4856–4967); *Payable time* (5337–5467, resolved, kept for the punch-in/End
  Ticket definition U8/U10 both depend on); *Send Back of a multi-crew ticket* (5467–5574).
- `.ai/vault/payroll/payroll-rules-provenance.md` (38,868 bytes, read whole — under
  threshold) — §4 *Rest and meals*, cited by `spec.md` REQ-04/Q9/Q10; not independently
  re-read here beyond confirming no U6–U13 item touches it.
- `/tmp/.../scratchpad/answers.md` — the developer's eight-round (plus a ninth, added to the
  file **while this spec was being written** — see *A live-file note* below) running log,
  same standing as `developer-answers-multi-day-and-flagged-entry-gaps.md`'s own rounds 1–8:
  round 8 (U1–U5 build plan, E1–E4) already folded into `spec.md`; round 9 (U14–U21 answers —
  boom basis, AM/PM, labor-vs-ticket, U7's boom-outside-work-window, missing notes, crew-yard
  grouping, U14's full worker-edit scope, **U19's per-person override table**, Samsara signal
  choice, the yard-geofence radius, and the asset-departure-yard rule) is cited where a U6–U13
  item touches it — REQ-17 (the one U7 item round 9 answers) and REQ-31 (round 9's U19 answer,
  cited as the future path off this file's own `[CONFLICT]`).
- **Coordinator relay, 2026-09-30, second pass** — the developer's direct answers to this
  file's own Q11–Q16 (now Q20–Q25), given after first publish, in the same coordinating
  session. Same standing as every other `answers.md`/`developer-answers` item: `reference`,
  git user `devmohsinakram`, **not yet written into `.ai/vault/` at all** — recommend
  `tcg-scrum` record Q23 and Q24 in particular, since both are pending Corrina Bustos and
  carry real build consequence. Q20, Q21, Q22 and Q25 are lower-stakes mechanics and can wait.
- `/tmp/.../scratchpad/plan.json` — the planner's U6–U13 entries (`goal`, `scope`,
  `dependsOn`, `sources`) — used for scope, **every code claim in it independently verified
  against the repository below**, not trusted as written (per the elaborator's own
  instruction, and per `spec.md`'s own precedent of finding one planner error in U1–U5).
- The repository, read directly (and via three parallel research passes whose citations are
  folded in below) — current-state description and ripple only, never as a source of intent.
  Two corrections the research surfaced that the plan's prose did not anticipate:
  - **The U5 flag framework the plan assumes (`PayrollFlag`, `PayrollFlagDetectionService`)
    does not exist in code yet** — confirmed absent by `grep -rn "PayrollFlagDetectionService
    \|FlagDetector\|PayrollFlagEvent\|PayrollFlag\b" apps/api/src apps/api/prisma
    packages/shared/src` (no hits; the only "PayrollFlag"-named thing on disk is the
    pre-existing, unrelated `JobPayrollFlag` model, `schema.prisma:5662`, a per-job tenant
    premium checkbox set — see REQ-15's Ripple).
  - **A correction-editing mechanism already exists on `main`, not only in the closed PR
    #699.** `apps/api/src/usecase/payroll-send-backs/{plan-correction,correction-rules,
    correction-preview}.ts` (353/173/52 lines) are live, Crane-Supervisor-gated code, not
    something U8 builds from nothing. PR #699 (closed, unmerged, `fix/payroll-correction-page-ui`)
    only **extends** that live code (+3,550/−265 lines across 22 files, confirmed by
    `git diff origin/main...fix/payroll-correction-page-ui --stat`). U8's Sources below cite
    which parts are today's `main` and which are PR #699's unmerged extension.

### A live-file note

While this spec was in progress, `answers.md` gained a **round 9** (asked of the developer
2026-09-30, after the U6–U13 planning round, about the U14–U21 blockers) — and, after first
publish, this file's own Q11–Q16 (now Q20–Q25) were answered directly in the coordinating
session (see *Sources read*, above). Round 9 answers U15's boom basis, U16's AM/PM and
labor-vs-ticket questions, U17's missing-notes definition, U18's crew-yard grouping, U14's
full worker-edit scope, **U19's per-person override table** (cited in REQ-31), and U20/U21's
Samsara and yard-geofence mechanics. Of these, only **one U7 item** is used here: whether a
boom session outside Start Work → End Job is invalid (yes — see REQ-17), and **one U19 item**
(cited in REQ-31 as the future path off this file's `[CONFLICT]`). The rest of round 9
concerns U14–U21, out of scope here, and is not otherwise used. Same standing as every other
`answers.md` round: `reference`, not yet in `.ai/vault/`.

### Scope note — this file is U6–U13 only; U1–U5 sourced by reference, U14–U21 still out of scope

Every U6–U13 requirement below that depends on the flag framework (`PayrollFlag`,
`PayrollFlagEvent`, the reconciliation pass, the unconditional gate, "reviewed, no change")
cites `spec.md` REQ-09–REQ-13 and `units.md`'s U5 section as its mechanism source, **not**
code, because none of it is built yet (see *Sources read*, above). Where U5 ships with a
different shape than specified, every REQ below that depends on it needs re-checking before
its own unit is built — flagged again in §11.

U14–U21 (boom-range blocking, wrong AM/PM, labor-vs-ticket, missing notes, crew-time
mismatch, Samsara comparisons, the asset-not-home flag, per-person corrections on crew
tickets) are **not decomposed here**, per the same scope line `spec.md` §0 already drew. They
are listed for continuity in §13.

---

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-15 | `REST_UNDER_8H` flag detector — fires on any gap under 8 h | api, web | `[UNVERIFIED]` | decision 2026-09-30 flag-list (verified, item 3); build-plan E3 (reference); `spec.md` REQ-09 (U5 mechanism, not yet code); code | no |
| REQ-16 | Invalid-time detectors — same start/end, out of order, duplicate, missing start/end, 24 h+ | api | `[UNVERIFIED]` | decisions 2026-09-29 invalid-entry (verified, partial), 2026-09-30 flag-list (verified, assent); developer A7 (reference, `>=`24 h); code | no |
| REQ-17 | `INVALID_LONG_BOOM_TIME` detector + web flag labels for both U7 codes | api, web | `[UNVERIFIED]` | same as REQ-16; round-9 developer answer (reference, boom outside Start Work→End Job); code | no |
| REQ-18 | `PayrollEntryFix` schema + recalculation-hold generalisation | schema, api | `[UNVERIFIED]` | decision 2026-09-29 (verified, "payroll may fix any time"); plan (reference, mechanism); code (`countBlockingByEmployee`, `assertNoRecalculationHold`) | no |
| REQ-19 | Per-person fix API — own-window creation, not shared-`WORK_TIME` moves, on every ticket regardless of roster size | api | `[UNVERIFIED]` | decision 2026-09-29 clause 3 (verified, "individual"); C4 conflict named in that same note; developer answer to Q20 (reference, resolved — own window always, no billing touch); code (`plan-correction.ts`) | no |
| REQ-20 | Salvage — pricing before/after preview, ripple/time-rows/work-dates reuse, `computeTicketTimeTotals` into `@tcg/shared`, `week-move.ts` at current-open-week | api, shared, web | `[UNVERIFIED]` | PR #699 code (closed, unmerged, salvaged per E4); developer C9 (reference, "current open week"); code (`LONG_WORK_WINDOW_HOURS=24`) | no |
| REQ-21 | Web — entry-fix route/feature, "Fix entry" action, recalculation-hold banner | web | `[UNVERIFIED]` | plan (reference, design); REQ-18–20's sources | no |
| REQ-22 | Retire the Crane Supervisor routing — schema, data, api, shared, seed | schema, api, shared, seed | `[UNVERIFIED]` | decisions 2026-09-29 routing, 2026-09-30 flag-list *Build impact* (both verified); code | no |
| REQ-23 | Retire the Crane Supervisor routing — web, qa-automation | web | `[UNVERIFIED]` | same as REQ-22; code | no |
| REQ-24 | Payroll completes a never-completed ticket | schema, api, web, mobile | `[UNVERIFIED]` | decision incomplete-tickets *Not decided* item 2 (verified, escape path needed); developer C8 (reference, mechanics); developer answer to Q22 (reference, resolved — payroll-only, no billing/dispatch touch); `spec.md` REQ-06 (`PayrollTicketClosure.COMPLETED` pre-included); code | no |
| REQ-25 | Schema + API core — crew-wide Send Back, per-member hold, close/withdraw | schema, api | `[UNVERIFIED]` | developer C6 (reference, resolved — option (c), build it; pending Corrina's ratification, not blocking — see Q23); decision flag-list items 5/C5 (verified, per-worker target + reminder); code (`PayrollSendBack`, `sendBack()`) | no |
| REQ-26 | Field API + notifications — returned-ticket visibility, respond endpoint | api, shared | `[UNVERIFIED]` | decision flag-list *Not decided* item 5 (verified, Send Back survives); developer C3 (reference, mobile edit+resubmit); code (`field-tickets.controller.ts`, `ticket.contract.ts`) | no |
| REQ-27 | Mobile — returned-ticket banner, filter, Home section, respond sheet | mobile | `[UNVERIFIED]` | same as REQ-26; code | no |
| REQ-28 | Web — Send Back dialog (crew list), chips, reply display | web | `[UNVERIFIED]` | developer C6 (reference); code | no |
| REQ-29 | 3-hour reminder cron + mobile push-token re-registration | schema, api, mobile | `[UNVERIFIED]` | decision flag-list (verified, "3 hours", worker target); developer C4 (reference, repeats until respond); code (`notification-scheduled-jobs.service.ts` pattern, `NotificationReminderLog`, `use-register-push-token.ts`) | no |
| REQ-30 | API — terminal-guard exemption for the primary, adjust-with-reason on `WORK_TIME`, resubmit endpoint | api | `[UNVERIFIED]` | developer C3 (reference, worker edits + resubmits); developer answer to Q25 (reference, resolved — holds until the next Calculate, matching REQ-18); code (`recordTicketStep`, `TicketTimeAdjustment`, `ticket-terminal-status.util.ts`) | no |
| REQ-31 | Whose pay a worker's shared-ticket edit reaches, on a returned crew ticket | api | `[CONFLICT]` | decision 2026-09-29 clause 3 (verified, "individual") vs. developer C6-refined/Q24 (reference, **built to this answer**: shared milestones move for both workers, personal times individual); schema fact (`TicketTimeEntry` has no `employeeId`); `[CONFLICT]` kept — Corrina has not ratified the developer's reading | no — built to the developer's answer, flagged pending Corrina |
| REQ-32 | Mobile — editable returned ticket, reopen action, resubmit UI, non-primary copy | mobile | `[UNVERIFIED]` | developer C3 (reference); code (`isStepReadOnly`, `isReadOnlyTicket`, `background-sync.ts`) | no |
| REQ-33 | `/me/labor`/`/me/performance` read the TCG-25 own-window override once one exists | api | `[UNVERIFIED]` | developer answer to Q21 (reference, resolved — "show corrected hours"); code (`me.service.ts`, `me.repository.ts`) | no |

Counts: **19 total** — 0 verified, 18 unverified, 1 conflicted, 0 open. Every requirement
here depends, directly or through its unit, on U5's flag framework or U1's `payroll-admin`
permission, neither of which is fully built on this branch yet (U1 is; U5 is not — see §0).
None of the 19 is individually build-blocking in the sense `spec.md`'s sign-off checklist
uses (REQ-31 now has a stated default too, per the developer's answer to Q24);
**REQ-31 is still the one requirement in this file worth re-reading before building past
it**, because its statement is a developer's reading against a verified rule, not a
verified rule itself, and the `[CONFLICT]` tag is kept for exactly that reason — see REQ-31
and Q24.

---

## 2. Requirements

### REQ-15 — `REST_UNDER_8H` flag detector: fires on any gap under 8 h `[UNVERIFIED]`

- **Statement:** Calculate (via U5's `PayrollFlagDetectionService`) raises a `REST_UNDER_8H`
  flag on the first job day of each rest chain whose gap from the employee's previous paid
  work is under 8 hours — regardless of whether that gap triggered PAY-045's OT/DT rest-floor
  premium. The flag's `detail` names the previous ticket, the gap in hours, and whether
  `restForcedHours`/`restFloorMult` (U2) were non-null for that entry (i.e. whether a premium
  was actually paid).
- **Surface:** api, web
- **Sources:**
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` item 3 —
    `[VERIFIED]` — kind: decision — *"Under 8 hours' rest"* is flag #3 of nine, Corrina's own
    words from 2026-09-29, reconfirmed 2026-09-30 as blocking.
  - `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md`, *"Later the
    same day"* item E3 — `[UNVERIFIED]` — kind: reference, devmohsinakram — *"the under-8-hours
    rest flag fires on any gap under 8 h, not only when the PAY-045 OT/DT trigger holds (so it
    also flags a short gap that earns no rest premium)."* This is the one design fact this
    requirement turns on: a short gap between two tickets that never crosses into overtime (so
    PAY-045 prices no premium at all) still flags. Also present, same standing, in
    `answers.md` round 8.
  - `spec.md` §2 REQ-09, REQ-10, REQ-11 (`[UNVERIFIED]`, this ticket's own U5 spec) — kind:
    reference — the detection-pass mechanism (`PayrollFlagDetectionService`, per-period
    reconciliation, the unconditional gate) this detector plugs into. **Not code** — U5 is
    unbuilt (§0).
  - `apps/api/prisma/schema.prisma` `model PayrollJobDay` — kind: code — **already carries**
    `restGapHours Decimal? @map("rest_gap_hours")`, plus `restForcedHours`, `restChainHours`
    (`rest_chain_hours_before`) and `restFloorMult` — all under a comment reading "PAY-045
    audit trail." No schema change is needed to read the gap; this detector is a read, not a
    write, against a run's already-priced `PayrollJobDay` rows.
  - `apps/api/src/usecase/payroll/payroll.service.ts:388-397` — kind: code — `executeRun`
    already loads `findCompleteTicketsInRange(previousUtcDay(weekStart), utcDate(weekStart))`
    as **context tickets**, exactly one day back, "for PAY-045 rest-gap judging" (comment,
    confirmed); context job-days are built (`:462-472`) but never priced or exported. This is
    the "previous-week context" the plan's scope line for U6 refers to, confirmed to exist
    and do what the plan says.
  - `packages/payroll-engine/src/rest-period.ts` — kind: code — `RestEntry` (lines 44-61) has
    **no ticket-id field at all**; chain order is tracked by array position, not by an
    identifier. `applyRestPeriodPremium` (172-245) returns `RestEntryOutcome[]` per entry,
    each carrying `gapHours: number | null` and `gapStartedAt`. **This is a gap for this
    spec's detector to close, not a blocker**: the detector runs at the API layer over
    `PayrollJobDay` rows (which do have `jobTicketId`), not inside the engine — see Notes.
- **Conflict:** none.
- **Open question:** none directly for the trigger condition (E3 settles it). **What "the
  employee's previous paid work" means when that previous ticket was itself `VOIDED` (U9) or
  `CANCELLED`** is not stated anywhere and is not raised as a numbered §12 question — it is a
  smaller edge case than Q20–Q25 below, and the smallest default (a voided/cancelled ticket
  contributes no paid work, so the chain looks straight through it to whatever precedes it) is
  what the engine's existing chain-stitching already does for any ticket the loader excludes;
  build to that, `NOT SPECIFIED` beyond it.
- **Ripple:** see §11a row 1.
- **Acceptance:** a job day whose `PayrollJobDay.restGapHours` is non-null and `< 8` raises one
  `OPEN` `REST_UNDER_8H` flag on the first entry of its chain, naming the previous ticket and
  the gap, whether or not `restForcedHours`/`restFloorMult` are set on that entry; a gap of
  exactly 8 h or a null gap (first entry of the period, no prior context ticket) does not flag.
- **Notes for the executor:** Because `RestEntry` (the engine's internal working type) carries
  no ticket id, this detector cannot be written by reading engine output directly — build it
  against the **persisted** `PayrollJobDay` rows the run already writes (which do carry
  `jobTicketId` per `@@unique([runId, jobTicketId])`... **actually widened to
  `(runId, jobTicketId, employeeId)`** per the crew-ticket-shape decision
  (`decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` Q1
  point 5) — confirm the current unique key before writing the query, since it may have moved
  under U6 without a dedicated decision note). "The first entry of each chain" needs the same
  chain-boundary logic U2's `toWorkChains`/`REST_STITCH_MINUTES` uses; if U2 does not expose a
  chain id on the persisted row, this detector needs its own grouping pass over consecutive
  `PayrollJobDay` rows ordered by start time, re-deriving the same `REST_STITCH_MINUTES`
  boundary — flag this dependency to U2's executor explicitly, since building it twice, once in
  the engine and once here, is how the two drift.

### REQ-16 — Invalid-time detectors: same start/end, out of order, duplicate, missing start/end, 24 h+ `[UNVERIFIED]`

- **Statement:** Calculate raises one blocking flag per condition, per roster member, over a
  completed ticket's `TicketTimeEntry` rows and the member's own window
  (`ticket_employees.workStartedAt`/`workEndedAt`): `INVALID_TIME_SAME_START_END` (a `WORK_TIME`
  row, the member's own window, or a `BOOM_TIME` session whose start equals its end);
  `INVALID_TIME_OUT_OF_ORDER` (a captured row that violates step order); `INVALID_TIME_DUPLICATE`
  (the same employee has two tickets whose PAY-020-rounded `WORK_TIME` start and end are
  identical); `INVALID_TIME_MISSING_START_OR_END` (a milestone type present with no closing
  row, or an open `BOOM_TIME` segment); `INVALID_TIME_24H_OR_MORE` (a `WORK_TIME` span of 24
  hours or more).
- **Surface:** api
- **Sources:**
  - `decisions/2026-09-29-invalid-entry-flags-samsara-30-minutes-and-wtl-penalty-moves-rest-start.md`
    clause 1 — `[VERIFIED]` — kind: decision — Corrina's own words: *"incorrect use of AM/PM.
    boom time same time (ex: start work 1am, end work 1am. we see that often), times out of
    order, etc."* This confirms same-start/end and out-of-order in her own voice; wrong AM/PM
    is U16, not built here.
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` item 5 —
    `[VERIFIED]` — kind: decision — the eight-check item-5 list, confirmed by assent (not her
    own words for the four new sub-checks): *"duplicate entries; a missing start or end;
    shifts over 24 hours; labor not matching the ticket."* Also states *where the duplicate and
    overlap checks come from*: the legacy engine's `Warn_DuplicateWindow` and `Warn_Overlap`
    (both warnings in the legacy system; both block now).
  - `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` item A7 —
    `[UNVERIFIED]` — kind: reference — the threshold is **24 h or more** (`>=`), not the
    23.5 h cap PAY-004 applies to imported FCC rows only. *"Pending her OK on that one
    boundary"* — the number 24 is Corrina's; the `>=` inclusivity is the developer's, and
    differs from her *"over 24 hours"* only at exactly 24.0 h. Not raised as a separate §12
    question here — `spec.md` Q6/Q7 already cover the adjacent 24 h/23.5 h and `REJECTED`
    questions for U3/U4's void/approval gate, and this detector's own 24 h boundary is a
    smaller, narrower fact than those; build `>=`24 h per the developer's direction, flagged.
  - `apps/api/src/usecase/ticket-time-entries/validate-step-times.ts:253-283` — kind: code —
    `findWindowOrderViolation(type, edge, candidate, existingEntries)`, the existing step-order
    check `INVALID_TIME_OUT_OF_ORDER` reuses; `findStepGapViolation` at line 172, same file.
  - `apps/api/src/usecase/payroll/payroll.service.ts:221-236` (`buildMissingWindowIssue`) and
    `apps/api/src/service/payroll/payroll.repository.ts:668` — kind: code — confirms the plan's
    claim: `TICKET_MISSING_PAYABLE_WINDOW` is written with `employeeWeekId: null` today
    (run-level, not week-level), so it never reaches the approval gate's per-employee-week
    check. This requirement's `INVALID_TIME_MISSING_START_OR_END` flag is the per-employee
    counterpart that does reach it, via U5's framework — the existing issue is unchanged (see
    Ripple).
  - `apps/api/src/usecase/ticket-work-segments/ticket-work-segments.service.ts:145-150,170-173`
    — kind: code — **confirmed**: a `BOOM_TIME` session whose corrected or existing start
    equals its end is silently bumped `+1` second at write time (`finalEnd = new Date(...+
    1000)`), never refused. This is why `INVALID_TIME_SAME_START_END` must check `BOOM_TIME`
    rows explicitly rather than relying on capture-time refusal — a same-instant boom session
    reaches storage today.
  - `grep -rn "DuplicateWindow" apps/api/src packages apps/web/src apps/mobile` and
    `grep -rln --include=*.md "DuplicateWindow" .ai/vault` — kind: code (absence) — **no
    duplicate-entry detection exists anywhere in this codebase today**, in the engine, the API,
    or even the vault's own prose beyond the one decision note's citation of the legacy
    system's `Warn_DuplicateWindow`. This detector is new in full, not a port of anything
    live.
  - `apps/api/prisma/schema.prisma` `model TicketTimeEntry` (5003-5035) and `model
    TicketEmployee` (4709-4757) — kind: code — confirms the exact fields available: `type:
    TicketTimeEntryType`, `startedAt`, `endedAt?`, no `employeeId` on `TicketTimeEntry`
    (crew-wide, per-ticket); `workStartedAt`/`workEndedAt` on `TicketEmployee` (per-employee,
    TCG-25).
- **Conflict:** none.
- **Open question:** none blocking. One minor, non-blocking design choice, flagged rather
  than raised as a §12 item: *"for that pair it replaces the overlap flag"* — when
  `INVALID_TIME_DUPLICATE` fires for two tickets, the plan proposes suppressing
  `OVERLAPPING_JOBS` for the same pair, to avoid two flags on what is really one data-entry
  error. No source asks for or against this; `NOT SPECIFIED`, build it as proposed since
  nothing contradicts it and it costs nothing to change later (it is a detector-ordering
  choice, not a schema commitment).
- **Ripple:** see §11a row 2. `TICKET_MISSING_PAYABLE_WINDOW` (the existing, run-level,
  never-week-scoped issue) is **unchanged** — this requirement adds a parallel, per-employee
  `PayrollFlag` for the same underlying condition; nothing about the existing issue's storage
  or consumers changes.
- **Acceptance:** each of the five conditions above, present on a completed ticket's captured
  rows or a member's own window, raises exactly one `OPEN` flag of the matching code, naming
  the offending rows; a `WORK_TIME` span of exactly 24.0 h flags (`>=`); a 23.9 h span does not.
- **Notes for the executor:** `INVALID_TIME_DUPLICATE`'s "identical rounded start and end"
  must use the same PAY-020 rounding (start down, end up, to the half hour) the engine already
  applies — do not compare raw captured instants, which would under-match. This detector,
  like REQ-15, runs over persisted `PayrollJobDay`/`TicketTimeEntry` rows at the API layer, not
  inside `packages/payroll-engine`.

### REQ-17 — `INVALID_LONG_BOOM_TIME` detector, and web flag labels for U7's two codes `[UNVERIFIED]`

- **Statement:** Calculate raises `INVALID_LONG_BOOM_TIME` on a `BOOM_TIME` session whose start
  equals its end (already caught structurally by REQ-16's same-start/end check, but flagged
  under its own code per Corrina's item-6 naming), whose end precedes its start, **or** whose
  start is before the ticket's `WORK_TIME` start or whose end is after `WORK_TIME`'s end (a
  boom session outside Start Work → End Job). Web renders labels for both U7 codes
  (`INVALID_TIME_*` from REQ-16 and `INVALID_LONG_BOOM_TIME` here) in the flags panel/timesheet
  chips U5 builds, with a link to the U8 fix screen once REQ-21 ships.
- **Surface:** api, web
- **Sources:**
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` item 6 —
    `[VERIFIED]` — kind: decision — *"Invalid long boom time"* is flag #6 of nine, a distinct
    item from item 5's "invalid times," confirmed by her own 2026-09-29 words in part
    (*"boom time same time… we see that often"*) and by assent for the rest.
  - `payroll/gaps.md:4913` (question 8, *"What is an 'invalid long boom time entry'?"*) —
    `[UNVERIFIED]` — kind: vault gap — *"Partly answered (third reply): boom start equal to
    boom end, out of order, wrong AM/PM. **Open:** is a boom session outside Start Work → End
    Job invalid? She was offered that example and did not repeat it."*
  - `answers.md` round 9 (2026-09-30, asked while planning U14–U21) — `[UNVERIFIED]` — kind:
    reference, devmohsinakram, **not yet in the vault** — *"U7 invalid long boom (gaps Q8):
    YES — a boom session starting before Start Work or ending after End Job is invalid (in
    addition to same start/end, out of order, wrong AM/PM)."* This closes the one open item
    gaps.md Q8 names for this flag, though only as a developer reading, not Corrina's own
    words — she was offered this exact example on 2026-09-29 and did not repeat it back, so
    the developer's "yes" fills a silence, not a confirmation.
  - `apps/api/prisma/schema.prisma` `enum TicketTimeEntryType` (4966-4983) — kind: code —
    confirms `BOOM_TIME` and `WORK_TIME` are distinct, comparable row types.
- **Conflict:** none.
- **Open question:** none raised as a numbered §12 item. The gap between "she was offered the
  example and didn't repeat it" and "the developer says yes" is real but narrower than Q20–Q25
  below and carries little product risk (a boom session outside the paid window is very
  plausibly a capture error either way) — build per the developer's round-9 answer, flagged
  `reference` in the requirement heading; if Corrina disagrees later, this is a one-line
  detector removal, not a schema change.
- **Ripple:** see §11a row 3. The web relabel work `spec.md` REQ-09 already scoped
  (`PayrollEmployeeWeekStatus.FLAGGED` → "Rate issue") is untouched by this requirement; this
  requirement only adds two more entries to `PAYROLL_FLAG_CATALOG` (built in U5 — **not yet on
  disk**, confirmed by `grep -rn "PAYROLL_FLAG_CATALOG" packages/shared/src`, no hits).
- **Acceptance:** a `BOOM_TIME` session with `startedAt >= endedAt`, or one that starts before
  or ends after the ticket's `WORK_TIME` window, raises one `OPEN` `INVALID_LONG_BOOM_TIME`
  flag naming the session and the ticket's `WORK_TIME` bounds.
- **Notes for the executor:** the "same start/end" half of this detector is **structurally
  identical** to REQ-16's `INVALID_TIME_SAME_START_END` boom-session case — do not build the
  same check twice under two different codes for the exact same condition on the exact same
  row; either fold same-start/end-on-boom entirely into this code (matching Corrina's item-6
  naming, since her own example was given under "boom time") and drop it from REQ-16's boom
  case, or keep REQ-16's boom case and have this detector only cover out-of-order-on-boom and
  outside-work-window. `NOT SPECIFIED` which; the plan's own scope text does not resolve it
  either (it lists same-start/end once, under both). Pick one, document the choice in the
  detector's own comment, and do not raise two flags for one boom session.

### REQ-18 — `PayrollEntryFix` schema + recalculation-hold generalisation `[UNVERIFIED]`

- **Statement:** A new `PayrollEntryFix` table records every payroll-initiated, single-employee
  correction to a ticket: the changed fields (same `{field, label, before, after}` shape as
  `PayrollSendBack.correctionChanges`), a required note, who made it and when. A fix newer
  than the employee-week's latest completed run holds that employee's week from approval,
  generalising the existing `countBlockingByEmployee`/`assertNoRecalculationHold` mechanism
  (today scoped to `PayrollSendBack`) to also count open `PayrollEntryFix` rows.
- **Surface:** schema, api
- **Sources:**
  - `decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md`
    clause 1 — `[VERIFIED]` — kind: decision — *"Payroll Admin/Manager adjusts"* — payroll
    corrects flagged entries itself, not only sees and hands them back.
  - `plan.json` U8 scope — `[UNVERIFIED]` — kind: reference (CodingCops design) — the exact
    schema shape (`payroll_entry_fixes`, indexed `(tenant, period, employee)`) and the
    generalisation instruction ("generalise `countBlockingByEmployee` and
    `assertNoRecalculationHold`"). No source states this table's shape; it is the smallest
    home for the audit trail clause 1 requires, modelled directly on `PayrollSendBack`'s own
    `correctionChanges` shape (precedent, not invention).
  - `apps/api/src/usecase/payroll/payroll.service.ts:627-634,857,896,1050,1081` — kind: code —
    `assertNoRecalculationHold(period)`, called at exactly these four call sites (both approve
    routes, both export-adjacent paths); confirms the function exists today, is `private`, and
    is the one hold-check every approval/export path already funnels through.
  - `apps/api/src/usecase/payroll-send-backs/payroll-send-backs.service.ts:135-136` and its
    repository — kind: code — `countBlockingByEmployee(periodId, latestRunCompletedAt)`,
    confirmed live today, `PayrollSendBack`-scoped only.
- **Conflict:** none.
- **Open question:** whether a fix on a **one-person-roster** ticket is itself consistent with
  "a fix changes only that one person" and whether such a fix reaches billing or invoicing —
  **raised as Q20, see §12.** This requirement (the schema/hold mechanism) is not itself
  blocked by Q20; only REQ-19's write path is.
- **Ripple:** see §11a row 4.
- **Acceptance:** a `PayrollEntryFix` row cannot be created without a non-empty `note`; a week
  with an open (unfixed-by-recalculation) `PayrollEntryFix` newer than the latest completed
  run refuses approval and export, alongside the existing send-back and (once U5 ships) flag
  holds; the next completed Calculate for that period clears the hold (the fix's figures are
  now in force).
- **Notes for the executor:** `assertNoRecalculationHold`'s current signature and its four call
  sites are the exact seam to extend — read a `PayrollEntryFix` the same way it already reads
  open `PayrollSendBack` rows, rather than adding a parallel hold-check function. This mirrors
  how `spec.md` REQ-11 composes the flag hold onto the same gate.

### REQ-19 — Per-person fix API: own-window creation, not shared-`WORK_TIME` moves `[UNVERIFIED]`

- **Statement:** `POST /v1/payroll/periods/:id/employees/:employeeId/tickets/:ticketId/fix
  {changes, note}` (plus a `GET .../fix` read and a `POST .../fix/preview`), gated
  `@RequirePermission('payroll-admin', 'edit')`, lets a Payroll Admin/Manager correct one
  employee's Start Work and End Job times on a ticket. **The fix always writes to that
  employee's TCG-25 own window — creating one if none exists yet — on every ticket,
  regardless of roster size**, resolved by Q20 (see below): even on a one-person-roster
  ticket, the fix does not touch the ticket's shared `WORK_TIME` `TicketTimeEntry` row
  directly. The ticket's shared times, and anything read from them for customer billing
  (`WORK_AT_JOB_SITE_TIME`), stay untouched by this requirement. For the **other six**
  captured types (yard, site, boom sessions, lunches, build-up, break-down), which have no
  per-employee home at all: on a **one-person-roster** ticket they are editable directly,
  because the ticket's one shared row already belongs to that person alone; on a **crew**
  ticket they stay read-only, each labelled "needs a per-person home — use Send Back or
  Reviewed, no change" (U19, out of scope — see §13, which now names the schema U19 would
  add).
- **Surface:** api
- **Sources:**
  - `decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md`
    clause 3 — `[VERIFIED]` — kind: decision — Corrina's own word, verbatim: **"individual"**,
    answering *"Editing a shared time like Start Work or End Job changes hours for everyone on
    the ticket. Is that OK, or should a fix apply to one person only?"* — *"A correction applies
    to the individual employee... changes that one employee's hours, not the whole crew's."*
    This is the requirement's core mandate.
  - The same note's *Conflicts* item 4 — `[VERIFIED]` (the note itself is verified; this is
    Corrina's own decision-recorder naming an unresolved design question, not a second client
    statement) — *"Clause 3 against the crew-ticket shape... `TicketTimeEntry` stays per
    ticket, and milestones are crew-wide... An individual correction needs a per-employee home
    for corrected times. This is not a flat contradiction, because payroll may override without
    changing the capture. The design is open."* This is exactly what the own-window mechanism
    (TCG-25) resolves for Start Work/End Job specifically — see the code sources below.
  - `apps/api/src/usecase/payroll-send-backs/plan-correction.ts:266-296` (current, live on
    `main`, not PR #699-only) — kind: code — **confirmed defect this requirement fixes**: the
    `if (params.member.workStartedAt && params.member.workEndedAt)` branch already edits the
    own window when one exists; the `else` branch at line 296 is exactly
    `setWindow(TicketTimeEntryType.WORK_TIME, startWork, endJob)` — and `setWindow` (219-230)
    **moves the existing shared `WORK_TIME` row** when a member has no own window yet, which
    is every ticket's starting state. This is the shared-capture problem clause 3 flags: today,
    correcting a crew member's Start Work/End Job before they have an own window changes every
    crew member's pay, exactly what Corrina said should not happen.
  - `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` clause 2 (`verified`,
    cited via `crew-ticket-shape` above) — kind: decision — the Oiler is the ticket's primary
    employee; the Operator is a second `ticket_employees` row on the same ticket. Confirms the
    shape this requirement's "one-person vs crew ticket" branch reads from
    (`ticket_employees` row count per `jobTicketId`) for the six field types the own-window
    mechanism does not cover.
  - **Developer direction, devmohsinakram, 2026-09-30, answering this spec's own Q20** —
    `[UNVERIFIED]` — kind: reference, not yet in `.ai/vault/` — *"Own window, no billing": a
    payroll fix always writes to that person's own window, even on a one-person ticket. The
    ticket's shared times, and so customer billing, stay untouched.* This settles the
    Start Work/End Job branch: no roster-size distinction for those two fields — always the
    own window — and confirms this requirement does not reach billing.
- **Conflict:** none directly on this requirement's own text (the *Conflicts* item 4 quoted
  above is itself unresolved-but-workable: the own-window mechanism satisfies "individual" for
  the two fields it covers, and this requirement does not claim to satisfy it for the rest,
  which it deliberately leaves read-only).
- **Open question:** none — **resolved, Q20** (see Sources).
- **Ripple:** see §11a rows 5–6.
- **Acceptance:** correcting Start Work or End Job for **any** employee, on any ticket,
  creates an own window if none exists yet (`ticket_employees.workStartedAt`/`workEndedAt`
  set) and edits it thereafter, leaving the ticket's shared `WORK_TIME` `TicketTimeEntry` row
  untouched on every ticket, one-person or crew; a fix to a crew field other than Start
  Work/End Job on a multi-person ticket is refused with the "needs a per-person home" message;
  the same fields on a one-person-roster ticket are editable directly (no own-window
  mechanism exists for them); nothing this requirement writes changes what
  `WORK_AT_JOB_SITE_TIME`-derived billing figures show.
- **Notes for the executor:** the refusals `plan-correction.ts`/`correction-rules.ts` already
  enforce (future time, out-of-order, boom outside the work window, overlap with the
  employee's other jobs) should be **kept** for per-person edits; the **crew-wide**
  `findSettledCrewPay`/whole-crew overlap-and-rest checks (`correction-rules.ts`, confirmed
  present at `apps/api/src/usecase/payroll-send-backs/payroll-send-backs.repository.ts:678`,
  `findSettledCrewPay`) should be **dropped** for this per-person path — they existed because
  shared times moved everyone; an own-window edit does not. Warn (not refuse) over 24 h and on
  short rest, matching the existing correction form's own warn-vs-refuse split. This mirrors
  what `decisions/2026-09-29-flagged-entries-…` itself says: *"The whole-crew overlap and rest
  check existed because shared times moved everyone. A per-employee correction removes that
  reason. Whether the check stays is not decided"* — build it removed, per that note's own
  reasoning, flagged as this spec's inference from a verified note, not a separate client
  statement.

### REQ-20 — Salvage: pricing preview, ripple/time-rows/work-dates reuse, `computeTicketTimeTotals` into shared, `week-move.ts` at the current open week `[UNVERIFIED]`

- **Statement:** REQ-19's fix preview reuses the closed PR #699's pricing-before/after
  machinery, its web-side live-total helpers, and its shared time-totals utility, moved into
  `packages/shared` where both the fix feature and the (already-live) correction feature can
  use it; a fix that moves an entry's `WORK_TIME` start across a pay-week boundary is priced in
  the **current open week**, not the week the corrected Start Ticket falls in.
- **Surface:** api, shared, web
- **Sources:**
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` item B —
    `[VERIFIED]` — kind: decision — *"Payroll may fix any time, for one person"* — the
    before/after pay preview this requirement builds is what lets payroll see the effect of
    that fix before committing it.
  - `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` item C9 —
    `[UNVERIFIED]` — kind: reference, pending Brian Petros/Corrina Bustos — *"process that in
    current open week"*, answering the 2026-09-28 note's open item F (*"what happens when the
    week the entry moves into is already approved or exported"*). This is a pay-process rule,
    not mechanics-only, and is explicitly **pending** — not folded in as settled the way C1–C5
    are. Not independently raised as a new §12 question here, since `spec.md` already carries
    the adjacent REQ-04/Q9/Q10 pattern for pay-rule items awaiting the same two ratifiers, and
    this spec's own Q20–Q25 are reserved for genuinely unaddressed U6–U13 items — this one has
    an answer, only an unconfirmed one, which the heading's `[UNVERIFIED]` tag and this
    source's `reference` status already carry forward.
  - `apps/api/src/usecase/payroll-pricing/payroll-week-pricing.service.ts:170,221` (PR #699,
    unmerged) — kind: code — `PayrollWeekPricingService`, `priceEmployeeWeekBeforeAfter(params:
    {weekStart, employeeId, override}): Promise<EmployeeWeekBeforeAfter>` — prices a week once
    with an override applied, in memory, sharing ticket reads and rate lookups with the
    unmodified read. Confirmed to exist and to do what the plan claims, on the closed branch.
  - `apps/api/prisma/schema.dbml`/`pay-week-bounds.ts:61,74` (PR #699) — kind: code —
    `payrollDateOf(instant)`, `payWeekBounds(weekStart): PayWeekBounds` — the payroll-timezone
    week math this requirement's before/after preview needs.
  - `packages/shared/src/utils/ticket-time-totals.ts:109,291` (PR #699, **not yet in
    `packages/shared` on this branch** — confirmed by the same grep that found no
    `PAYROLL_FLAG_CATALOG`) — kind: code — `computeLaborHours`, `computeTicketTimeTotals(rows,
    ownWindow?)`: paid window is the own window when given, else the ticket's `WORK_TIME`;
    billable is `WORK_AT_JOB_SITE_TIME`; also yard/site/build-up/boom/break-down hours and the
    union `boomPayHours`. This is the one shared formula both the fix preview and (already-live)
    correction preview must use, so the two never disagree — per the 2026-09-29 addendum's own
    stated reason for building it that way in the first place.
  - `apps/web/src/features/payroll-corrections/lib/{correction-ripple,correction-time-rows,
    correction-work-dates}.ts` (PR #699) — kind: code — confirmed **none of the three
    references `crane-supervisor`**; the only permission check in that whole feature tree is
    `correction-form.tsx:55`, `can('crane-supervisor', 'edit')`. The three lib files are already
    decoupled from the routing this ticket retires and are reusable as-is for REQ-21's web
    surface.
  - `apps/api/src/usecase/payroll-send-backs/week-move.ts` (PR #699) — kind: code —
    `payWeekOf`, `findWeekMove`, `weekMoveWarning`, `weekMoveRefusal`, `interface WeekMove
    {fromWeekStart, toWeekStart, workDate}`. Confirmed to exist, and confirmed to **not**
    itself reference `TICKET_PRICED_IN_OTHER_PERIOD` or `latestRunId` — those live in
    `payroll-ingest.ts:147`, `payroll-week-pricing.service.ts:89`, `payroll.service.ts:139`,
    `payroll-issue-severity.ts:87`, and `payroll-send-backs.repository.ts:618` respectively —
    so wiring `week-move.ts` into the settled-week refusal means touching those files too, not
    just this one.
  - `apps/api/src/usecase/payroll-send-backs/correction-rules.ts:222` (PR #699) — kind: code —
    `LONG_WORK_WINDOW_HOURS = 24` (a **warning**, `findLongWorkWindow`, line 230) — confirmed
    the value is 24, not 23.5, and confirmed **no trace of a `TICKET_OVER_24H` code or a 23.5 h
    refusal landed anywhere in `apps/api/src` or `packages/payroll-engine/src` on this branch**
    — PR #699 never merged, so nothing needs "replacing" here as `spec.md`'s own §13 briefly
    worried; there is simply nothing yet, and this requirement's `LONG_WORK_WINDOW_HOURS`
    constant is the first copy on `main`, sourced from the closed PR, not a port of a shipped
    one.
- **Conflict:** none on the salvage mechanics; C9 (current-open-week) is `pending`, not
  `[CONFLICT]` — no second source disagrees with it, it simply is not yet ratified.
- **Open question:** none beyond C9's own pending status, already carried by this
  requirement's `[UNVERIFIED]`/`reference` tags.
- **Ripple:** see §11a row 7. `LONG_WORK_WINDOW_HOURS`'s existing use in the **live**
  correction feature (`correction-rules.ts:222`, already on `main`) is unchanged by moving the
  constant's *value* into U7's `INVALID_TIME_24H_OR_MORE` flag catalog entry — the two are the
  same threshold (24 h) for two different purposes (a warning on a supervisor-style correction
  vs. a blocking flag at Calculate); keep them as one named constant if REQ-16/17's executor
  and this requirement's executor coordinate, or as two constants with the same value if they
  do not — `NOT SPECIFIED` which, flagged so the two units' executors do not silently drift.
- **Acceptance:** the fix preview shows every rate line, the week total, this entry's share,
  and the before/after delta for the employee's whole pay week, computed in memory, persisting
  nothing; a fix that moves `WORK_TIME` start across a Saturday 00:00 boundary is priced in the
  period open at the time of the fix, not the period containing the corrected start; `@tcg/shared`
  gains `computeTicketTimeTotals`/`computeLaborHours`, and `apps/api/src/usecase/
  ticket-labor-entries/compute-labor-hours.ts` re-exports from there rather than holding its own
  copy (matching the PR #699 shape, salvaged).
- **Notes for the executor:** `correction-form.tsx:55`'s single `can('crane-supervisor',
  'edit')` call, plus whatever server-side guard mirrors it, are the only two places PR #699's
  reusable library code touches the permission this ticket retires — repoint both to
  `payroll-admin`, do not repoint the three `lib/` files themselves (they hold no permission
  checks to repoint).

### REQ-21 — Web: entry-fix route/feature, "Fix entry" action, recalculation-hold banner `[UNVERIFIED]`

- **Statement:** A new route `/payroll/[employeeId]/entries/[ticketId]` (feature folder
  `apps/web/src/features/payroll/entry-fix/`, built from the existing
  `features/payroll-corrections` components — `correction-form`, `correction-times-section`,
  `build-correction-payload` — repointed at REQ-19's endpoints) lets a Payroll Admin/Manager
  open, edit and preview a fix. A "Fix entry" action appears in the expanded timesheet row
  (`payroll-employee-table.expanded.tsx`) and on each U5 flag row. Fixes appear in
  `/payroll/audit`. A "Recalculate to apply" banner
  (`payroll-recalculation-hold-banner.tsx`) shows while a fix is newer than the latest
  completed run.
- **Surface:** web
- **Sources:**
  - `plan.json` U8 scope — `[UNVERIFIED]` — kind: reference (design) — the route, feature-folder
    layout and component list; no source specifies this screen-by-screen, same as `spec.md`
    REQ-14's own standing for U5's web surface.
  - `.ai/claude/contexts/web.md` → *Test IDs* — kind: rule — every new control ships a
    `data-testid`.
  - REQ-18/19/20's own sources, inherited for what the screen must let a user do.
- **Conflict:** none.
- **Open question:** none — Q20 (REQ-19) is resolved; nothing left to inherit.
- **Ripple:** see §11a row 8.
- **Acceptance:** `NOT SPECIFIED` for exact copy/layout; functionally, a Payroll Admin/Manager
  can open any employee-ticket pair, see the current captures, edit Start Work/End Job (and,
  on a one-person ticket, every other captured time), preview before/after pay, and submit
  with a required note; the week then shows the recalculation-hold banner until the next
  Calculate.
- **Notes for the executor:** reuse `PageHero`, `SectionCard`, `WorkspaceTable` per the
  standing web conventions; search all nine `components/` directories before adding anything
  new, per `.ai/claude/contexts/web.md`.

### REQ-22 — Retire the Crane Supervisor routing: schema, data, api, shared, seed `[UNVERIFIED]`

- **Statement:** The `crane-supervisor` permission, its seeded `OPS-CS` role, its API surface
  (`GET /v1/payroll/supervisors`, `PayrollCorrectionsController`, `findSupervisor`/
  `searchSupervisors`), and every open `SENT_BACK` row are retired. `PayrollSendBack.
  sentToEmployeeId` becomes nullable (U11 reuses the table with a different shape);
  `PayrollSendBackStatus` gains `WITHDRAWN`; every currently-`SENT_BACK` row is migrated to
  `WITHDRAWN` with the note "Crane Supervisor routing retired, decision 2026-09-29."
- **Surface:** schema, api, shared, seed
- **Sources:**
  - `decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md`
    — `[VERIFIED]` — kind: decision — *"please update all flags to go to the payroll admin and
    payroll manager. not the crane superintendent"* — the routing overrule this requirement
    executes on.
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` → *Build
    impact* — `[VERIFIED]` — kind: decision — *"Send Back goes to a Crane Supervisor. It should
    go to the worker. There is no reminder. One is required after 3 hours. Only the boom-range
    flag exists. Flags 2–9 are not built."* Names exactly what PR #690/#691 (merged to `main`)
    built that contradicts the client, without itself saying "remove the code" — that
    instruction is this ticket's own inference from "it should go to X," carried by `spec.md`'s
    own §11a row 11 as a named, deferred follow-up (U9), now this requirement.
  - `apps/api/src/utility/seed-data.ts:232-240` (comment block), `:1119-1131` (`OPS-CS` role,
    `roleCode: 'OPS-CS'`, `permissions: {'crane-supervisor':'edit', jobs:'view',
    dispatch:'view'}`) — kind: code — confirmed live and exactly what must be removed.
  - `packages/shared/src/constants/permissions.ts:52,100` (`crane-supervisor` in
    `PERMISSION_MODULES` and `USER_RESTRICTED_MODULES`) — kind: code — confirmed live.
  - `apps/api/src/presentation/payroll-corrections/{index.ts,payroll-corrections.controller.ts,
    dto/}` — kind: code — confirmed still present, not yet removed (expected: U9 has not
    shipped).
  - `apps/api/prisma/schema.prisma:5328-5372` (`PayrollSendBack`, `PayrollSendBackStatus`) —
    kind: code — confirmed the live shape: `sentToEmployeeId` non-null today, `status` enum has
    only `SENT_BACK`/`CORRECTED`. Confirms the migration this requirement needs.
  - `apps/api/src/usecase/notifications/notification-catalog.ts:414-425,428-436`
    (`payroll.entry_sent_back`, `payroll.entry_corrected`) — kind: code — confirmed the two
    supervisor-facing notification templates to retire.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** see §11a rows 9–11.
- **Acceptance:** after migration, no seeded role holds `crane-supervisor`; `GET
  /v1/payroll/supervisors` and `POST /v1/payroll-corrections/...` return 404 (route removed,
  not merely guarded); every `SENT_BACK` row's status is `WITHDRAWN` with the retirement note;
  `payroll.entry_sent_back`/`payroll.entry_corrected` no longer fire.
- **Notes for the executor:** this requirement's migration and U11's schema migration (REQ-25)
  both touch `PayrollSendBack`/`PayrollSendBackStatus` — sequence U9 before U11 (per
  `units.md`'s own dependency convention and this file's own dependency table in §0), one
  migration each, and confirm the `WITHDRAWN` value this requirement adds is still present
  after REQ-25's own migration runs.

### REQ-23 — Retire the Crane Supervisor routing: web, qa-automation `[UNVERIFIED]`

- **Statement:** `app/(protected)/payroll-corrections` (both `page.tsx` and `[id]/`) is
  deleted, redirecting to `/payroll`; `features/payroll-corrections/` (`hooks/
  use-payroll-corrections.ts`, `lib/build-correction-payload.ts`, `lib/correction-times.ts`,
  `components/returned-entries-list.tsx`, `components/correction-times-section.tsx`,
  `components/correction-times-fields.tsx`, `components/correction-form.tsx`,
  `components/correction-form.parts.tsx`, `components/correction-review-panels.tsx`) and
  `hooks/use-payroll-corrections-summary.ts` are removed **except** the pieces REQ-20/21 salvage
  into the U8 fix feature; the "Returned Entries" sidebar item
  (`sidebar-nav-items.tsx:91,227-235`) is removed; `notification-navigation` routes any
  still-pending `PAYROLL_SEND_BACK` notification to `/payroll/[employeeId]` instead of the
  removed route.
- **Surface:** web
- **Sources:** same decisions as REQ-22.
  - `apps/web/src/components/sidebar/sidebar-nav-items.tsx:91` (`usePayrollCorrectionsSummary()`
    call), `:227-235` (the "Returned Entries" `SidebarItem`, gated on `corrections?.isSupervisor`,
    badge `openCount`) — kind: code — confirmed live, exact lines to remove.
  - `apps/web/src/app/(protected)/payroll-corrections/{page.tsx,[id]/}` — kind: code —
    confirmed live.
  - `apps/web/src/features/payroll-corrections/hooks/use-payroll-corrections-summary.ts` —
    kind: code — confirmed the summary hook lives at `hooks/`, not under
    `features/payroll-corrections/`, correcting the plan's assumed path.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** see §11a row 10.
- **Acceptance:** the sidebar shows no "Returned Entries" item for any role; navigating to
  `/payroll-corrections` redirects to `/payroll`; no console error from a removed-but-still-
  imported component.
- **Notes for the executor:** `grep -rn '<removed-testid>' qa-automation/e2e` for every
  `data-testid` this requirement removes, and update or delete those specs — the same
  discipline `CLAUDE.md` requires for any renamed test id, doubled here because whole screens
  disappear. `qa-automation/` is outside the pnpm workspace and not Nx-linted (`CLAUDE.md`), so
  this grep is the only signal that exists.

### REQ-24 — Payroll completes a never-completed ticket `[UNVERIFIED]`

- **Statement:** `POST /v1/payroll/periods/:id/tickets/:ticketId/complete {times, note}`,
  gated `@RequirePermission('payroll-admin', 'edit')`, lets a Payroll Admin/Manager enter a
  never-completed ticket's missing `WORK_TIME` start and end (yard and site optional) and mark
  it `COMPLETE` with `payrollClosedAction = COMPLETED` (the enum member `spec.md` §3 already
  pre-included in `PayrollTicketClosure` for exactly this requirement, not yet built). The
  action bypasses the `TICKET_STEPS_MISSING` check (signatures, checklists) and records that it
  did so; it writes a status-log entry and notifies the ticket's crew. On mobile, the ticket's
  `openTicket` no longer invents "Signed by `<name>`" placeholders for a payroll-completed
  ticket's `sig1`/`sig2`/compliance fields, and shows a "Completed by payroll" notice instead.
- **Surface:** schema, api, web, mobile
- **Sources:**
  - `decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md`
    → *Not decided* item 2 — `[VERIFIED]` (as to the gap existing; not as to its answer) — kind:
    decision — *"An escape path for a ticket that never completes... Who may complete or void it
    on the crew's behalf (payroll? dispatch?)"* — recorded as unresolved by the same note that
    made incomplete tickets block approval, i.e. the client-side owner knows this gap exists.
  - `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` item C8 —
    `[UNVERIFIED]` — kind: reference, pending Corrina — *"the Payroll Admin or Payroll Manager
    may: complete it, entering the missing times; or void it. Either way a note is required, and
    the action is audited... Completing sits inside what she already decided: payroll may fix
    any time (verified)... Voiding a ticket is new, and reaches beyond payroll. Nobody has asked
    either of them."* The note itself flags that **voiding** (already built, U3/`spec.md`
    REQ-06) reaches billing/dispatch unasked; the same reasoning applies to **completing**, which
    this requirement builds — see Q22.
  - `spec.md` §3 (`PayrollTicketClosure` enum, `[UNVERIFIED]`, this ticket's own U3 spec) —
    kind: reference — *"`COMPLETED` is the U10 'payroll completes a ticket' action — out of
    scope for this ticket (REQ-06 builds `VOIDED` only). Included in the enum now, per the plan,
    so a later ticket does not need an enum migration."* Confirms the enum member is already
    planned, though **not yet built** — confirmed absent from `schema.prisma` today (§0).
  - `apps/mobile/features/field-ticket/ticket-flow.store.ts:468-476` (`openTicket`, confirmed
    at line 525 for the interface, 111 for its type) — kind: code — the exact invention this
    requirement's mobile half must not run for a payroll-completed ticket: `if (!summaries.sig1)
    summaries.sig1 = \`Signed by ${customerName}\`;` (line 472), similarly for `sig2` (line
    ~474) and `compliance` (line 476, `\`Signed by ${empName}\``).
  - **Developer direction, devmohsinakram, 2026-09-30, answering this spec's own Q22** —
    `[UNVERIFIED]` — kind: reference, not yet in `.ai/vault/` — *"Payroll only": completing a
    never-completed ticket makes it priceable for payroll only. Billing, invoicing and
    dispatch are untouched, the same as void.* Settles this requirement carries no
    billing/dispatch side-effect, and confirms `spec.md` REQ-06's void action (already built)
    is the same: payroll-only.
- **Conflict:** none.
- **Open question:** none — **resolved, Q22** (see Sources). This matches, word for word in
  substance, `spec.md`'s own Q5 (*"Does voiding a ticket touch billing or invoicing…"*),
  already resolved there the same day with the same answer — *"NO BILLING EFFECT. The void
  takes the ticket out of payroll only."* Cited here as independent confirmation, not a
  second question; this spec does not edit `spec.md`.
- **Ripple:** see §11a rows 12–13.
- **Acceptance:** a ticket in `PENDING`/`SENT`/`IN_PROGRESS` (matching `spec.md` REQ-06's Q6
  resolution that void refuses `REJECTED` and `COMPLETE` — a completing action should carry the
  same status-scope restriction, since a `REJECTED` ticket is not "never completed," it is
  explicitly rejected, and `spec.md`'s own resolution treats that as a different case requiring
  void, not completion) with a required `note` and `WORK_TIME` start/end becomes `COMPLETE`,
  `payrollClosedAction: COMPLETED`; the mobile ticket view for that ticket shows "Completed by
  payroll," not fabricated signature summaries.
- **Notes for the executor:** the "note is required, audited" mechanics match REQ-18's
  `PayrollEntryFix` shape closely enough that the executor should consider whether a completed
  ticket's missing-time entry is itself best modelled as a `PayrollEntryFix` row (a fix from
  nothing, rather than a separate audit path) — `NOT SPECIFIED` by any source; build whichever
  keeps one audit trail rather than two, and document the choice.

### REQ-25 — Schema + API core: crew-wide Send Back, per-member hold, close/withdraw `[UNVERIFIED]`

- **Statement:** `PayrollSendBack` gains `returnGroupId`, a `RESPONDED` status value,
  `responseNote`, `respondedAt` and `respondedByUserId`; `sentToEmployeeId` is left null
  (REQ-22 already made it nullable), because the target is each row's own `employeeId`.
  `sendBack(periodId, ticketId, input, userId)`, gated `@RequirePermission('payroll-admin',
  'edit')`, expands a ticket to every `ticket_employees` roster member and creates one
  `PayrollSendBack` row per member, sharing one `returnGroupId`; it is refused if **any**
  member's week is `APPROVED`. `countBlockingByEmployee` (already generalised once by REQ-18)
  now also counts open rows by `returnGroupId` membership, holding every member's week until
  the group is resolved. `POST /v1/payroll/send-backs/:id/close` (after a REQ-19 fix, or after
  accepting a worker's reply) and `POST .../withdraw` release the hold for the whole group.
- **Surface:** schema, api
- **Sources:**
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` item B —
    `[VERIFIED]` — kind: decision — *"Send Back survives, and its target is the worker. A
    reminder goes out after 3 hours."* Settles the target is the worker, not the retired Crane
    Supervisor.
  - `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` item C6 —
    `[UNVERIFIED]` — kind: reference, **pending Corrina Bustos** — round 3: *"return it for
    everyone"*; round 6, verbatim: *"we have rule if any job have oiler and oprator both then
    oiler and oprator have one tickt so if we send oiler or oprator ticket back it should send
    other employee as well and block both employees payroll."* This is the requirement's central
    design and it is explicitly **not yet ratified** — it extends Corrina's verified
    worker-target rule from one worker to every worker sharing the ticket, and the note's own
    text says *"it needs her OK."* **Resolved as this spec's own Q23** — the coordinator
    confirmed 2026-09-30 that this is the answer to build to; it was already on record here
    (round 6) and in `answers.md` round 6, not a new answer — see §12.
  - `payroll/gaps.md:5467` (*Send Back of a multi-crew ticket*) — `[UNVERIFIED]` — kind: vault
    gap — the same C6 answer, with the code-level consequence spelled out: *"an API change,
    not built (`sendBack`, `countBlockingByEmployee`)"* — confirms today's `sendBack` is
    single-employee only.
  - `apps/api/prisma/schema.prisma:5328-5372` — kind: code — confirmed today's shape: one
    `sentToEmployeeId`, `status` enum with only `SENT_BACK`/`CORRECTED`, no group concept.
  - `apps/api/src/usecase/payroll-send-backs/payroll-send-backs.service.ts:143` (`sendBack`,
    single-employee signature, runs to ~line 261) and `:135-136`
    (`countBlockingByEmployee`) — kind: code — confirmed today's method signature and its
    per-employee-only counting.
- **Conflict:** C6 is a developer reading extending a verified rule, not two sourced answers
  disagreeing — not `[CONFLICT]` by the elaborator's own definition (that requires two sources
  in tension, not one source going further than a client has confirmed). Flagged `reference`,
  pending, per above.
- **Open question:** none blocking — **resolved, Q23: build option (c)** (return and hold
  every worker on the ticket). Corrina's own ratification of this extension to her verified
  worker-target rule is still outstanding — not a blocking gap for this requirement's build,
  but worth `tcg-scrum` recording explicitly, since it is the one design choice in this
  requirement with the largest blast radius (every multi-person ticket's send-back behaviour).
- **Ripple:** see §11a row 14.
- **Acceptance:** sending back one member's entry on a two-person ticket creates two
  `PayrollSendBack` rows, one `returnGroupId`; both members' weeks are held; approving either
  member's week alone is refused; closing or withdrawing the group releases both holds in one
  action; sending back a ticket where any member's week is already `APPROVED` is refused
  outright (not partially).
- **Notes for the executor:** build to the developer's reading (whole-crew return, per Q23's
  resolution) — it is settled as this ticket's design, not a proposed default any more, though
  it remains `reference`-status pending Corrina. Keep the crew-expansion logic isolated (one
  function, `expandTicketToRoster` or similar) rather than inlined through `sendBack`, so a
  later "no, only the targeted worker" answer from her is a small revert, not a rewrite.

### REQ-26 — Field API + notifications: returned-ticket visibility, respond endpoint `[UNVERIFIED]`

- **Statement:** `GET /v1/field/tickets` gains an additive, optional `sendBack: {id, reason,
  sentAt, sentByName, status} | null` per ticket, with no new `JobTicketStatus` value; a new
  `GET /v1/field/tickets/:id` (a returned ticket may not be on the list's first page); a
  `'returned'` list filter; `POST /v1/field/tickets/:id/send-back/respond {note}`, open to any
  returned member (a reply writes nothing to the ticket itself). Payroll Admin/Manager holders
  are notified `payroll.send_back_responded` on a reply. Every affected member's user receives
  `payroll.ticket_returned` (`IN_APP` + `PUSH`), `entityType: JOB_TICKET`, `entityId`,
  `data.ticketId`.
- **Surface:** api, shared
- **Sources:**
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` → *Not
    decided* item 5 — `[VERIFIED]` (as to the gap existing) — kind: decision — *"Send Back
    mechanics: the worker's mobile screen and edit rights... who receives the 3-hour reminder...
    and whether it repeats"* — named as unresolved by the same verified note.
  - `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` item C3 —
    `[UNVERIFIED]` — kind: reference — *"the worker edits the ticket times on mobile, then
    resubmits. Payroll then recalculates."* — item C4, same standing — *"to the worker, every 3
    hours, until they respond."* This requirement builds the visibility half; the reminder is
    REQ-29, the edit-and-resubmit is REQ-30/32.
  - `apps/api/src/presentation/field-tickets/field-tickets.controller.ts:77,95-100` — kind:
    code — confirmed `@Controller('field/tickets')`, a `GET` list route, **no `GET :id` route**
    today (`:id/time-entries`, `:id/submit` etc. exist; a bare `:id` does not) — confirms the
    gap this requirement fills.
  - `apps/mobile/data/contracts/ticket.contract.ts:120-149` (`FieldTicketSchema`) — kind: code
    — confirmed today's fields (`id, ticketCode, status, sentAt, respondedAt, rejectReason,
    scheduleDate, shiftNumber, shiftStartTime, shiftEndTime, stage, employee, job,
    timeTracking?, completedStepKeys?, ...`); **no `sendBack` field today**
    (`grep -n "sendBack|SendBack"` on this file: no hits).
  - `packages/shared/src/types/notification.types.ts:43-44,49` — kind: code — confirms
    `payroll.entry_sent_back`/`payroll.entry_corrected` exist (retired by REQ-22) and
    `NotificationChannel = 'IN_APP' | 'PUSH' | 'EMAIL' | 'SMS'` — `PUSH` is an available
    channel today, confirming this requirement's `payroll.ticket_returned` can use it.
- **Conflict:** none.
- **Open question:** none directly; the reminder cadence is REQ-29 (settled, C4).
- **Ripple:** see §11a row 15.
- **Acceptance:** a returned ticket's `GET /v1/field/tickets` list entry carries `sendBack` with
  the current reason and sender; `GET /v1/field/tickets/:id` returns the same ticket regardless
  of list pagination; every returned member's device receives a push and in-app notification;
  `POST .../respond {note}` succeeds for any of the ticket's returned members and notifies
  payroll-admin holders, without itself changing any ticket time.
- **Notes for the executor:** route `payroll.ticket_returned` and `payroll.send_back_responded`
  through U1's `{permission: {module, minLevel}}` recipient-spec variant
  (`recipient-resolver.service.ts:26-41`, confirmed live) for the payroll-admin side, and
  through the existing per-user notification path for the worker side — do not hardcode a role
  name for either.

### REQ-27 — Mobile: returned-ticket banner, filter, Home section, respond sheet `[UNVERIFIED]`

- **Statement:** `ticket.contract.ts` gains the optional `sendBack` field (REQ-26). A returned
  ticket shows a banner (reason, sender) on its card and overview; a "Returned" `StatusPill` and
  filter chip (`ticket-status-filter.ts`); a Home "Needs your attention" section lists returned
  tickets; a respond sheet, modelled on `ticket-comments-sheet`, lets the worker send a reply
  note. The ticket itself stays read-only in this unit — editing is REQ-32.
- **Surface:** mobile
- **Sources:** same as REQ-26.
  - `apps/mobile/features/field-ticket/flow/ticket-step-screen.tsx:191-196` (`isStepReadOnly`)
    and `apps/mobile/app/(field)/ticket/index.tsx:170-175` (`isReadOnlyTicket`) — kind: code —
    the existing read-only logic this requirement's banner sits alongside without yet changing
    (REQ-32 changes it).
- **Conflict:** none.
- **Open question:** none directly.
- **Ripple:** see §11a row 16.
- **Acceptance:** every crew member on a returned ticket sees the banner and can open the
  respond sheet; the Home section lists every ticket returned to the signed-in worker that has
  not yet been responded to or resubmitted.
- **Notes for the executor:** 48px touch targets, `theme/tokens.ts`, `StyleSheet.create`, per
  `.ai/claude/contexts/mobile.md`.

### REQ-28 — Web: Send Back dialog (crew list), chips, reply display `[UNVERIFIED]`

- **Statement:** The Send Back dialog lists every crew member the send-back will return and
  hold (REQ-25's expansion), not only the one entry Payroll opened it from; worklist and banner
  chips read "Returned to crew" / "Worker responded"; a member's reply is shown on the entry.
- **Surface:** web
- **Sources:** REQ-25's sources.
- **Conflict:** none.
- **Open question:** none blocking — Q23 is resolved (build the crew-list framing); if
  Corrina later answers "no, only the targeted worker" (her ratification is still
  outstanding, per REQ-25), this dialog's crew-list framing would change to a single-name
  framing.
- **Ripple:** see §11a row 17.
- **Acceptance:** opening Send Back on a two-person ticket's entry shows both members' names as
  who will be returned and held, before Payroll confirms.
- **Notes for the executor:** reuse the existing (still-live, Crane-Supervisor-era) Send Back
  dialog's structure where it does not depend on the retired permission; do not build a second
  dialog component from scratch.

### REQ-29 — 3-hour reminder cron + mobile push-token re-registration `[UNVERIFIED]`

- **Statement:** `PayrollSendBack` gains `next_reminder_at`, `reminder_count`,
  `last_reminded_at`. A `@Cron`-decorated job (every 15 minutes, `runWithCronGuard`, recorded in
  `cron_run_logs`) selects `SENT_BACK` rows with `next_reminder_at <= now`, sends a push
  reminder to that row's employee, and reschedules `next_reminder_at` 3 hours out — stopping
  once the row is `RESPONDED`, closed, or `WITHDRAWN`. Idempotency key:
  `payroll-send-back:<returnGroupId>:<n>` via `NotificationReminderLog`. Mobile's
  `use-register-push-token.ts` gains re-registration on a changed Expo push token, so reminders
  keep arriving after a token rotates.
- **Surface:** schema, api, mobile
- **Sources:**
  - `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md` item B —
    `[VERIFIED]` — kind: decision — *"A reminder goes out after 3 hours. That matches her own
    2026-08-04 ask... and the unverified Confluence US-03 AC 9 (3 hours)."*
  - `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` item C4 —
    `[UNVERIFIED]` — kind: reference — *"to the worker, every 3 hours, until they respond."*
    Settles the recipient and the repeat cadence, which the verified note left open.
  - `apps/api/src/usecase/notifications/notification-scheduled-jobs.service.ts:208,213,351`
    — kind: code — the exact `@Cron`/`runWithCronGuard` pattern this job follows, confirmed
    live (`ticketReminders` job as the closest precedent, same file, lines 100-111 for two more
    examples).
  - `apps/api/prisma/schema.prisma:5079-5091` (`NotificationReminderLog`, unique on
    `[tenantCompanyId, reminderKey]`) — kind: code — confirmed the idempotency mechanism this
    job reuses already exists.
  - `apps/api/src/usecase/notifications/notification-scheduled-jobs.service.ts:46-53`
    (`MANUAL_CRON_TRIGGER_JOBS`) — kind: code — confirmed the manual-trigger registry this job
    should be added to, for `/dev/cron/:jobName`.
  - `apps/mobile/hooks/use-register-push-token.ts` (123 lines, `useRegisterPushToken(enabled)`
    at line 61) — kind: code — confirmed it registers once per `enabled` toggle and has **no**
    `addPushTokenListener`/token-refresh listener today — the gap this requirement's mobile
    half fills.
- **Conflict:** none.
- **Open question:** none directly.
- **Ripple:** see §11a row 18.
- **Acceptance:** a `SENT_BACK` row with no response gets a push reminder 3 hours after
  send-back and every 3 hours after, capped at nothing (per C4's "until they respond," not a
  fixed count) until `RESPONDED`/closed/`WITHDRAWN`; a rotated Expo push token still receives
  the next scheduled reminder.
- **Notes for the executor:** since a returned ticket now holds every crew member (REQ-25), a
  reminder fires per **row**, i.e. per member, not once per ticket — confirm this matches what
  REQ-26's `payroll.ticket_returned` notification already sends per member, so a member does not
  receive a duplicate reminder inside the same 3-hour window their original notification landed
  in; `NOT SPECIFIED` whether the very first reminder is skipped if the member already responded
  within the first 3 hours — build the straightforward reading (stop the moment `RESPONDED` is
  set, whenever that happens) since nothing suggests otherwise.

### REQ-30 — API: terminal-guard exemption for the primary, adjust-with-reason on `WORK_TIME`, resubmit endpoint `[UNVERIFIED]`

- **Statement:** A `COMPLETE` ticket with an open send-back becomes writable, **for the primary
  employee only**, for time steps sent with `isAdjustment` and a `reason` — extending the
  existing `TicketTimeAdjustment` audit mechanism's `requiresReason` set
  (`job-tickets.service.ts:813`, today `{'leftYard','arriveJob','leftJob','arriveYard'}`) to
  also cover `startWork` and `review` (the `WORK_TIME` punch-in and its close), and carving an
  exemption into `recordTicketStep`'s terminal guard (`:764-772`) and
  `ticket-terminal-status.util.ts`'s `assertTicketNotTerminal` for exactly this case; step-order
  validation still runs. `POST /v1/field/tickets/:id/resubmit` (primary only): the ticket's
  rows become a new status, `RESUBMITTED`, while the ticket itself stays `COMPLETE`;
  payroll-admin holders are notified; a resubmit newer than the latest completed run holds the
  affected weeks until recalculation (reusing REQ-18's generalised hold).
- **Surface:** api
- **Sources:**
  - `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` item C3 —
    `[UNVERIFIED]` — kind: reference — *"the worker edits the ticket times on mobile, then
    resubmits. Payroll then recalculates."* — and its own admission: *"Not stated: whether the
    resubmitted times re-run the flags, or whether Payroll must still clear the flag after
    recalculating."*
  - **Developer direction, devmohsinakram, 2026-09-30, answering this spec's own Q25** —
    `[UNVERIFIED]` — kind: reference, not yet in `.ai/vault/` — *"Next Calculate": a worker's
    resubmit holds the week until payroll recalculates, and flags and pay update then.* This
    closes C3's own admitted gap: no lightweight re-evaluation on resubmit, matching REQ-18's
    fix-hold pattern exactly, as this spec's proposed default already anticipated.
  - `decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md`
    → Confluence US-03 AC 4 (unverified, cited within a verified note as corroborating context,
    not as its own source) — kind: vault, unverified — *"the Worker may edit the specified
    ticket"* — the only pre-existing written trace of a worker-edit design, low weight (personal
    Confluence space, per `.ai/vault/README.md`'s standing caveat on that source), cited only
    because it is consistent with C3, not as independent support.
  - `apps/api/src/usecase/job-tickets/job-tickets.service.ts:764-772` (terminal guard, `const
    terminal: JobTicketStatus[] = [COMPLETE, CANCELLED, REJECTED]`), `:813-814`
    (`requiresReason`, `isAdjustment`), `:891` (writes a `TicketTimeAdjustment` row when both
    hold) — kind: code — confirmed live, and confirmed **duplicated** (not shared via the util)
    in `recordStepProgress` at lines 986-994 — both guards need the same exemption, or the
    executor should first consolidate them onto `assertTicketNotTerminal` as part of this
    change, since leaving one exempted and one not would silently reintroduce the terminal
    refusal on whichever path the mobile edit actually calls.
  - `apps/api/prisma/schema.prisma:5040-5059` (`model TicketTimeAdjustment`) — kind: code —
    confirmed fields: `stepKey varchar(50)`, `initialTime`, `adjustedTime`, `reason: String`
    (already required, not optional, at the schema level), `adjustedByUserId`. This is an
    **existing, shipped mechanism** (merged as part of "feat/ticket-time-adjustments-and-
    floor-ceiling," confirmed via `git log`), not new for this ticket — this requirement only
    widens which `stepKey`s may use it and punches the one terminal-status exemption through.
  - `apps/api/src/usecase/job-tickets/ticket-terminal-status.util.ts` (full file, 17 lines) —
    kind: code — confirmed `TERMINAL_JOB_TICKET_STATUSES` and `assertTicketNotTerminal`, and
    confirmed `recordTicketStep`/`recordStepProgress` **do not call it today** — they duplicate
    the same array inline. Consolidating onto the util is the natural seam for this
    requirement's exemption (one function to add a parameter to, instead of two).
- **Conflict:** the specific question of **whose pay** a shared-field edit under this mechanism
  reaches is a separate requirement, REQ-31, marked `[CONFLICT]` there. This requirement (the
  terminal-guard exemption and the resubmit endpoint's existence) is not itself in conflict —
  only the write semantics for crew-shared fields are.
- **Open question:** none — **resolved, Q25**: resubmit does not re-run the flags immediately;
  it holds the affected week(s) exactly as REQ-18's fix-hold does, and the flags (and pay)
  update only at the next completed Calculate.
- **Ripple:** see §11a row 19.
- **Acceptance:** the ticket's primary, and only the primary, can adjust `startWork`/`review`
  (and, per REQ-31, whichever other steps that requirement's resolution covers) on a `COMPLETE`
  ticket with an open send-back, each with a required reason, recorded as a
  `TicketTimeAdjustment`; a non-primary crew member's attempt is refused; `POST .../resubmit`
  moves the ticket's rows to `RESUBMITTED` without changing `JobTicket.status`, notifies
  payroll-admin holders, holds the affected week(s) until the next completed run, and does
  **not** itself re-evaluate any open flag — a flag raised on the old data stays `OPEN` until
  Calculate runs again and reconciles it.
- **Notes for the executor:** `RESUBMITTED` is described here as a new status on "the ticket's
  rows," not on `JobTicket.status` itself — `NOT SPECIFIED` by any source exactly which model
  carries it (a new column on `PayrollSendBack`, reusing REQ-25's group, is the most direct
  reading, since resubmission is what closes a return group's need for a response); build it
  there unless the executor finds a stronger existing home, and document the choice.

### REQ-31 — Whose pay a worker's shared-ticket edit reaches, on a returned crew ticket `[CONFLICT]`

- **Statement:** On a returned crew ticket, a worker's own correction (REQ-30) writes to
  **that employee's TCG-25 own window** for Start Work/End Job — individual, per employee,
  same mechanism REQ-19 uses for payroll's own fix. For the other six captured types (Left
  Yard, Arrived Site, Left Site, Arrived Yard, lunches, boom sessions, build-up, break-down),
  which have no per-employee home, the worker's edit writes the ticket's **one shared**
  `TicketTimeEntry` row, reaching every crew member on the ticket, and holds every one of
  their weeks (consistent with REQ-25's crew-wide hold). This is **built to the developer's
  answer to this spec's own Q24** (see Sources) — **not** to Corrina Bustos's verified
  "individual" rule, which was never asked about a worker's own edit and which this
  requirement's own schema fact (below) shows cannot be built as a general rule today without
  U19.
- **Surface:** api
- **Sources — this Statement is built on Candidate B; Candidate A remains verified and
  unreconciled, which is why `[CONFLICT]` stays on this requirement's heading:**
  - **Candidate A — "individual," verified, not built here.**
    `decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md`
    clause 3 — `[VERIFIED]` — kind: decision — Corrina's own word, verbatim: **"individual"**,
    answering *"Editing a shared time like Start Work or End Job changes hours for everyone on
    the ticket. Is that OK, or should a fix apply to one person only?"* — *"A correction applies
    to the individual employee... changes that one employee's hours, not the whole crew's."*
    **This was asked and answered about payroll's own correction (U8), not about a worker's own
    mobile edit (U13).** Nothing in this note, or anywhere else, states whether she meant the
    principle to extend to who is making the edit, or only to what payroll itself does — and
    her ratification of Candidate B (below) has not been sought.
  - **Candidate B — "shared for milestones, individual for personal time" — the answer this
    requirement is built on.**
    `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` → *Follow-up
    answers, same day* — `[UNVERIFIED]` — kind: reference, devmohsinakram, **explicitly
    recorded by the vault's own recording agent as a conflict, not a settled answer**: *"on a
    shared operator + oiler ticket, shared ticket times (yard, site and work) move for both
    workers when either edits them; each worker fixes only their own personal times. This is the
    developer's reading against Corrina's verified 'a fix changes only that one person'
    (2026-09-29) — recorded as a conflict for her to settle, not as settled."*
  - **Developer direction, devmohsinakram, 2026-09-30, answering this spec's own Q24
    directly** — `[UNVERIFIED]` — kind: reference, not yet in `.ai/vault/` — *"Shared times
    move both"*: confirms Candidate B, verbatim, as the answer to build to. Given as a build
    instruction, in the same coordinating session, on top of the C6-refined answer above — it
    does not itself constitute Corrina's ratification, and is not presented as such.
  - **Architecture fact, not a product source, cited only to explain why Candidate A cannot be
    built as a general rule today:** `apps/api/prisma/schema.prisma` `model TicketTimeEntry`
    (5003-5035) — kind: code — carries no `employeeId`. Left Yard, Arrived On Site, Left Job
    Site, Arrived Yard, lunches, boom sessions, build-up and break-down are stored **once per
    ticket**, shared by every roster member; only Start Work/End Job have a per-employee home
    (`ticket_employees.workStartedAt`/`workEndedAt`, TCG-25, per
    `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md`). The
    per-employee home the same verified 2026-09-29 note's own *Conflicts* item 4 says an
    "individual" reading would need for the other six field types **does not exist** today.
  - **U19's per-person override table — the future path to fully individual edits, not built
    here.** `answers.md` round 9 — `[UNVERIFIED]` — kind: reference, devmohsinakram, not yet
    in `.ai/vault/` — *"U19 per-person corrections (C4, CodingCops design): OVERRIDE TABLE —
    per-employee overrides (ticket, employee, step, corrected time, reason, who/when); shared
    ticket times stay; pricing/payroll read an employee's override where one exists."* Once
    U19 ships, Candidate A becomes buildable as a general rule (an override row instead of a
    shared-row write), which would supersede this requirement's shared-write default for the
    six field types — flagged here so U19's executor knows this requirement is the thing it
    would replace, not just a new, independent capability.
- **Conflict:** **Named plainly, and now built on one side of it — not silently.** This
  requirement is built to Candidate B (the developer's direction), against Candidate A
  (Corrina's verified rule), which was never asked about this exact case and which the
  schema cannot support generally without U19. The `[CONFLICT]` tag is **kept**, not cleared,
  because building to an answer is not the same as reconciling it with a verified rule that
  still stands unqualified in the vault. **Point at:** `payroll/gaps.md:4856` *Conflicts* item
  C4 (the per-employee-home gap), and the `developer-answers` note's own *Follow-up answers*
  section (the "recorded as a conflict" line quoted above) — neither has been updated to
  reflect that a build decision was made on top of the unresolved conflict; `tcg-scrum`
  should record both this Statement and the still-open ratification.
- **Open question:** none blocking this requirement's build — **resolved, Q24: build
  Candidate B** (see Sources). Corrina Bustos's ratification of Candidate B **against her own
  verified "individual" rule** is still outstanding, and is the more consequential half of
  this item: every existing reader of `TicketTimeEntry` (§11a row 20) sees whichever crew
  member's edit landed last, for six of eight editable field types, until either she confirms
  this is acceptable or U19 ships and replaces the mechanism.
- **Ripple:** see §11a row 20.
- **Acceptance:** a worker's edit to Start Work or End Job on a returned crew ticket writes
  only that employee's own window; a worker's edit to any of the other six field types writes
  the ticket's shared row and holds every crew member's week for recalculation; nothing in
  this requirement builds a per-employee override for those six types (that is U19).
- **Notes for the executor:** this is the one requirement in this file to flag prominently in
  code review as "built on an unratified answer, not a settled design" — the `[CONFLICT]` tag
  is there so a reviewer does not mistake a resolved §12 question for a resolved product
  question. If Corrina later says no, or U19 ships, this requirement's shared-write path for
  the six field types is what changes, not REQ-30's mechanics (terminal-guard exemption,
  `TicketTimeAdjustment` widening) or REQ-19's own-window mechanism, both of which hold
  either way.

### REQ-32 — Mobile: editable returned ticket, reopen action, resubmit UI, non-primary copy `[UNVERIFIED]`

- **Statement:** On mobile, `isStepReadOnly` (`ticket-step-screen.tsx:191-196`),
  `isReadOnlyTicket` and `computeOverviewSteps` (`app/(field)/ticket/index.tsx:170-175,308`)
  treat a returned ticket as editable for its primary, exactly per REQ-31's now-settled field
  list: Start Work/End Job always editable (own window); Left Yard, Arrived Site, Left Site,
  Arrived Yard, lunches, boom sessions, build-up and break-down editable too, writing the
  shared ticket row and holding every crew member's week (REQ-31's Candidate B). `ticket-flow.
  store` gains a reopen action (reset `submitState`/`active`; re-read photos from the server).
  `background-sync.ts` (its `finalizeSubmittedTicket` pass, `:201-250`) must not auto-resubmit
  an `OFFLINE` draft once the server reports the ticket returned. `ReviewBody` gains "Resubmit
  to payroll" with a confirm sheet. Non-primary members see "Returned; `<Oiler>` is correcting
  it."
- **Surface:** mobile
- **Sources:**
  - `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` item C3 —
    `[UNVERIFIED]` — kind: reference — as REQ-30.
  - `apps/mobile/features/field-ticket/flow/ticket-step-screen.tsx:191-196`,
    `apps/mobile/app/(field)/ticket/index.tsx:170-175,308` — kind: code — confirmed the exact
    read-only logic to extend, with a primary-and-returned exemption.
  - `apps/mobile/features/field-ticket/sync/background-sync.ts:~201-250`
    (`finalizeSubmittedTicket`) — kind: code — confirmed this is where a submitted ticket's
    offline draft is reconciled against the server; the "must not auto-resubmit" requirement
    is this spec's own inference from what the function already does (short-circuits if the
    server ticket is already `COMPLETE`) — a returned-but-still-`COMPLETE` ticket would hit
    that same short-circuit today, which is the right behaviour by accident; confirm it holds
    once `RESUBMITTED` (REQ-30) exists as a status the draft-reconciliation logic must also
    recognise, or the accident stops holding.
- **Conflict:** inherits REQ-31's `[CONFLICT]` — this requirement's UI enables every field
  REQ-31 now names as editable, on REQ-31's answer, not a hardcoded guess. If Corrina later
  disagrees with REQ-31's Candidate B, or U19 ships, this requirement's field list is what
  would need revisiting, not this requirement's own mechanics (reopen action, sync guard,
  resubmit UI).
- **Open question:** none blocking — Q24 (via REQ-31) and Q25 (via REQ-30) are both resolved;
  see those requirements for what remains outstanding (Corrina's ratification of Q24).
- **Ripple:** see §11a row 21.
- **Acceptance:** the primary on a returned ticket can open and edit every field REQ-31 names
  (Start Work/End Job, Left Yard, Arrived Site, Left Site, Arrived Yard, lunches, boom
  sessions, build-up, break-down), each with a required reason, and resubmit; a non-primary
  crew member sees the "Returned; `<name>` is correcting it" notice and cannot edit; an
  offline draft in flight when the ticket is returned does not silently overwrite the returned
  state on reconnect; resubmitting does not itself clear any flag (Q25) — the banner should not
  claim a flag is resolved until the next Calculate confirms it.
- **Notes for the executor:** REQ-31's `[CONFLICT]` tag is a reason to keep this screen's field
  list in one place (ideally reading REQ-31's own field-editability logic rather than
  duplicating it), so a later change to REQ-31 does not require hunting down a second,
  independent list here.

### REQ-33 — `/me/labor`/`/me/performance` read the TCG-25 own-window override once one exists `[UNVERIFIED]`

> **Added in this spec's second pass, 2026-09-30**, answering Q21 (formerly Q12). Not part of
> the original publish; numbered REQ-33, out of physical order with REQ-15–REQ-32, per this
> file's own numbering discipline (§0, *A numbering note*) — only §12 questions were
> renumbered, and a requirement raised while answering one is appended, not inserted.
> Conceptually this belongs to **U8** (it is what makes REQ-19's fix visible to the worker it
> corrects) and, secondarily, to **U13** (a worker's own resubmit, REQ-30/32, writes the same
> own window and should be visible the same way).

- **Statement:** `apps/api/src/usecase/me/me.service.ts`'s `sumLaborHours` (and, through it,
  `ApiPerformanceResponse.hrsWeek` and `ApiMyLaborResponse.hrsWeek`/`.shifts`) stop ignoring
  the TCG-25 own-window override once REQ-19 (or REQ-30) has set one for the signed-in
  employee on a given ticket. `MeRepository`'s ticket-time-entries query additionally reads
  `ticket_employees.workStartedAt`/`workEndedAt` for that employee, and `sumLaborHours` prefers
  that window over the ticket's shared `WORK_TIME` row when present — the same `ownWindow`
  precedence `computeTicketTimeTotals(rows, ownWindow?)` (REQ-20, `@tcg/shared`) already
  implements, reused here rather than re-derived.
- **Surface:** api
- **Sources:**
  - **Coordinator relay of developer direction, devmohsinakram, 2026-09-30, answering this
    spec's own Q21** — `[UNVERIFIED]` — kind: reference, not yet in `.ai/vault/` — *"Show
    corrected hours": `/me/labor` reads the person's own window/override, so workers see
    payroll's corrected hours. This is now IN scope.* Settles that this gap (raised by
    `spec.md` §13 originally, carried forward as this spec's own Q21) is to be closed, not
    left as a known limitation.
  - `apps/api/src/usecase/me/me.service.ts:67-72` (doc comment on `sumLaborHours`) — kind:
    code — confirmed, verbatim: *"A live estimate: ignores the rare per-employee TCG-25
    window override, and is not the payroll-approved number `PayrollEmployeeWeek` will
    eventually carry once this week's period closes and runs."* This is the exact bypass this
    requirement removes — for the own-window half of that sentence; the "not the
    payroll-approved number" half is unaffected (this is still a live estimate of the current,
    still-open week, not a claim to show approved figures early).
  - `apps/api/src/usecase/me/me.service.ts:74-88` (`sumLaborHours`), `:240,276` (its two call
    sites) — kind: code — confirmed `sumLaborHours(ticketEntries: readonly
    MeTicketTimeEntryRow[][])` takes only crew-wide `TicketTimeEntry` rows today, via
    `deriveTicketTimes` (`apps/api/src/usecase/ticket-time-entries/derive-ticket-times.ts:278-290`),
    which reads `WORK_TIME` directly with no concept of an own-window override at all — confirms
    the doc comment's claim in the code, not just in prose.
  - `apps/api/src/service/me/me.repository.ts:7,38,158,188` (`MeTicketTimeEntryRow`,
    `MeShiftTicketRow`) — kind: code — confirmed neither row type carries
    `ticket_employees.workStartedAt`/`workEndedAt` today; the repository query needs
    extending, not just the service-layer formula.
  - `apps/mobile/app/(field)/menu/labor.tsx`, `apps/mobile/data/contracts/my-labor.contract.ts`,
    `apps/mobile/data/services/{labor,performance}/*.http.ts` — kind: code — the mobile
    consumers of these two endpoints, confirmed by `grep -rln "me/labor|me/performance|
    ApiMyLaborResponse|ApiPerformanceResponse" apps/mobile apps/web` (no web consumer found).
- **Conflict:** none.
- **Open question:** none — **resolved, Q21** (see Sources).
- **Ripple:** see §11a row 22 (appended at the end of that table, out of REQ-number order,
  matching REQ-33's own placement in §2).
- **Acceptance:** an employee with a REQ-19 fix or a REQ-30 resubmitted own-window on a
  ticket this week sees `hrsWeek`/the ticket's `shifts` row reflect that own window, not the
  ticket's shared `WORK_TIME`; an employee with no own window on any ticket this week sees
  the same figures as today, unchanged.
- **Notes for the executor:** reuse `computeTicketTimeTotals`'s `ownWindow` parameter (REQ-20)
  rather than writing a second own-window-precedence formula in `me.service.ts` — the two
  should not be able to drift, for the same reason REQ-20 itself gives for sharing the
  formula between the fix preview and the (already-live) correction preview. `NOT SPECIFIED`
  whether `ApiLaborShiftRow.hours` (the per-ticket row in `ApiMyLaborResponse.shifts`) also
  needs the same override applied, or only the `hrsWeek` total — the developer's answer says
  "the person's own window/override," not which of the two response shapes; build both, since
  showing a corrected total next to an uncorrected per-ticket row would be a visible
  inconsistency on the same screen.

---

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** yes — REQ-18 (`PayrollEntryFix`), REQ-22/REQ-25 (`PayrollSendBack`
  columns and status values, in two separate migrations — see REQ-22's Notes), REQ-29
  (`PayrollSendBack` reminder columns), REQ-24 (relies on `spec.md`'s already-specified, not-yet-
  built `PayrollTicketClosure`/`payrollClosedAction` — **U3's migration must land before REQ-24's
  own work begins**, or REQ-24 needs to bring that enum member itself if U3 ships without it;
  flag this dependency to whichever unit actually lands first). REQ-30 needs no schema change
  (`TicketTimeAdjustment` already exists).
- **Migration required:** yes, per `.ai/claude/contexts/prisma.md` — one migration per unit's
  commit, per the branch's own established discipline (`units.md` *Sequencing*).

```prisma
// New table (REQ-18):
model PayrollEntryFix {
  id              String   @id @default(uuid()) @db.Uuid
  tenantCompanyId String   @map("tenant_company_id") @db.Uuid
  periodId        String   @map("period_id") @db.Uuid
  jobTicketId     String   @map("job_ticket_id") @db.Uuid
  employeeId      String   @map("employee_id") @db.Uuid
  changes         Json     @db.JsonB   // [{ field, label, before, after }], matches PayrollSendBack.correctionChanges
  note            String   @db.Text
  fixedByUserId   String   @map("fixed_by_user_id") @db.Uuid
  fixedAt         DateTime @default(now()) @map("fixed_at") @db.Timestamptz()

  @@index([tenantCompanyId, periodId, employeeId], name: "idx_payroll_entry_fixes_tenant_period_employee")
  @@map("payroll_entry_fixes")
}

// PayrollSendBack changes (REQ-22, REQ-25, REQ-29 — three separate migrations, one per unit):
// REQ-22: sentToEmployeeId String? (was non-null); PayrollSendBackStatus gains WITHDRAWN
// REQ-25: + returnGroupId String? @db.Uuid; PayrollSendBackStatus gains RESPONDED;
//         + responseNote String? @db.Text; + respondedAt DateTime? @db.Timestamptz();
//         + respondedByUserId String? @db.Uuid
// REQ-29: + nextReminderAt DateTime? @map("next_reminder_at") @db.Timestamptz();
//         + reminderCount Int @default(0) @map("reminder_count");
//         + lastRemindedAt DateTime? @map("last_reminded_at") @db.Timestamptz()

// REQ-24 depends on, but does not itself add (see note above):
// enum PayrollTicketClosure { VOIDED, COMPLETED }  -- from spec.md §3 / units.md U3, not yet built
```

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| `PayrollEntryFix` | none proposed | n/a | n/a | REQ-18 — same precedent as `spec.md` REQ-09's `PayrollFlag`: `PayrollSendBack` (`schema.prisma:5337`) has no business code, only a UUID `id`; this table follows the same precedent, flagged for the same Identity Convention reason `spec.md` §3 already names |
| `PayrollSendBack` (existing) | none | n/a | n/a | unchanged by this ticket's use of the Identity Convention — see `spec.md` §3's own note |

- **New prefix introduced:** no.
- **Child relations:** `PayrollEntryFix.jobTicketId`/`employeeId`/`periodId` reference parent
  UUIDs, never codes, per convention.
- **Fields whose type/precision no source states:** `PayrollEntryFix.note` and
  `PayrollSendBack.responseNote` lengths — `NOT SPECIFIED`, treat as unbounded `Text` per the
  `PayrollSendBack.correctionNote` pattern already in the schema.
- **Tenant-scoping allowlist:** `apps/api/src/orm/prisma.service.ts`'s `$extends` block already
  lists `payrollsendback`/`payrollissue` (confirmed present at lines 130/164 per `units.md`
  U5's own note) — add `payrollentryfix` in REQ-18's same commit, per `tcg-prisma-guardian`'s
  standing concern on every new tenant-scoped model.

## 4. API surface — `apps/api`

Layering is `presentation → usecase → service → orm`, never upward.

| Method | Route | Req |
| --- | --- | --- |
| `GET` | `/v1/payroll/periods/:id/employees/:employeeId/tickets/:ticketId/fix` | REQ-19 |
| `POST` | `/v1/payroll/periods/:id/employees/:employeeId/tickets/:ticketId/fix/preview` | REQ-19, REQ-20 |
| `PATCH` | `/v1/payroll/periods/:id/employees/:employeeId/tickets/:ticketId/fix` | REQ-19 |
| `POST` | `/v1/payroll/periods/:id/tickets/:ticketId/complete` | REQ-24 |
| `POST` | `/v1/payroll/send-backs/:id/close` | REQ-25 |
| `POST` | `/v1/payroll/send-backs/:id/withdraw` | REQ-25 |
| (existing, expanded) | `POST /v1/payroll/periods/:id/tickets/:ticketId/send-back` (REQ-25's crew expansion) | REQ-25 |
| `GET` | `/v1/field/tickets/:id` | REQ-26 |
| `POST` | `/v1/field/tickets/:id/send-back/respond` | REQ-26 |
| `POST` | `/v1/field/tickets/:id/resubmit` | REQ-30 |
| (removed) | `GET /v1/payroll/supervisors`, `POST /v1/payroll-corrections/*` | REQ-22 |

Per endpoint:

- **Request DTOs:** `.../fix {changes, note}`, `.../complete {times, note}`,
  `.../respond {note}` — all `note` required, `@IsNotEmpty()`, matching REQ-18/24's decisions.
  `NOT SPECIFIED` max length on any of them.
- **Guards / roles:** `@RequirePermission('payroll-admin', 'edit')` on every payroll-side route
  in this file (fix, complete, close, withdraw, the expanded send-back); the field-ticket
  routes (`GET :id`, respond, resubmit) are open to the ticket's own crew via the existing
  field-ticket auth, `NOT SPECIFIED` beyond "the same guard the rest of `field-tickets.controller.ts`
  already uses," not independently re-verified here.
- **Module registration:** `payroll-entry-fixes` module (REQ-18/19/20) registered in
  `app.module.ts`; barrel `index.ts` in every new folder.

## 5. Web surface — `apps/web`

**Feature-first, not atomic design.**

- **Routes:** new `/payroll/[employeeId]/entries/[ticketId]` (REQ-21); `/payroll-corrections`
  and its `[id]` removed, redirecting to `/payroll` (REQ-23).
- **Existing components to reuse:** `PageHero`, `SectionCard`, `WorkspaceTable`; the existing
  `features/payroll-corrections` form components (`correction-form`, `correction-times-section`,
  `build-correction-payload`) as the base for REQ-21's fix feature; the existing Send Back
  dialog's structure for REQ-28.
- **New components proposed:** the fix feature's entry form (REQ-21); the crew-list Send Back
  dialog extension (REQ-28).
- **Copy:** `NOT SPECIFIED` throughout, as `spec.md` REQ-14 already notes for its own web
  surface — same standing here.

## 6. Mobile surface — `apps/mobile`

- **Screens/routes:** no new top-level route. A returned-ticket banner, filter chip, Home
  section and respond sheet on the existing ticket screens (REQ-27); editability changes to the
  existing ticket-flow screens for the primary on a returned ticket (REQ-32); a "Completed by
  payroll" notice (REQ-24).
- **Push/notifications:** `payroll.ticket_returned` (`IN_APP`+`PUSH`, REQ-26); the 3-hour
  reminder (REQ-29) reuses the same channel.
- **Offline/sync:** `background-sync.ts`'s `finalizeSubmittedTicket` must recognise
  `RESUBMITTED` (REQ-30) as a non-terminal-for-sync-purposes state — `NOT SPECIFIED` in detail,
  flagged in REQ-32's Notes.
- **Touch targets:** 48px, per convention.

## 7. Shared package — `packages/shared`

- **Types added/changed:**
  - `NOTIFICATION_TYPES` gains `payroll.ticket_returned` (`IN_APP`+`PUSH`, REQ-26),
    `payroll.send_back_responded` (`IN_APP`, REQ-26), `payroll.ticket_reminder` (`PUSH`, REQ-29)
    — retiring `payroll.entry_sent_back`/`payroll.entry_corrected` (REQ-22).
  - `PAYROLL_FLAG_CATALOG` (built in U5, not yet on disk) gains `REST_UNDER_8H` (REQ-15),
    `INVALID_TIME_SAME_START_END`/`OUT_OF_ORDER`/`DUPLICATE`/`MISSING_START_OR_END`/`24H_OR_MORE`
    (REQ-16), `INVALID_LONG_BOOM_TIME` (REQ-17) — seven more entries, none of which can be built
    until U5's catalog itself exists.
  - `computeTicketTimeTotals`/`computeLaborHours` move into `packages/shared/src/utils/
    ticket-time-totals.ts` (REQ-20), and `apps/api/src/usecase/ticket-labor-entries/
    compute-labor-hours.ts` re-exports from there.
  - `FieldTicketSchema` (mobile contract) gains `sendBack` (REQ-26).
  - `PERMISSION_MODULES`/`USER_RESTRICTED_MODULES` lose `crane-supervisor` (REQ-22).

## 8. Permissions and tenancy

- **Roles permitted:** every payroll-side route in this file (fix, complete, close, withdraw,
  the expanded send-back, review) — `payroll-admin` at `edit` or `full`, continuing the
  standing established by U1/`spec.md` REQ-01–REQ-03. Field-ticket routes — the ticket's own
  crew, via existing field-ticket auth.
- **Roles denied:** every role not holding `payroll-admin`, same as `spec.md`'s own
  REQ-01/REQ-03 — no seeded role gets it silently, including after this file's units ship.
- **Tenant isolation:** standard, per `.ai/claude/contexts/prisma.md`; `PayrollEntryFix` added
  to the `$extends` allowlist per §3.
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| `.../fix {note}` | required, non-empty | decision 2026-09-29 clause 1 (payroll corrects; mechanics: reference) | `[UNVERIFIED]` |
| `.../complete {note}` | required, non-empty | developer C8 | `[UNVERIFIED]` |
| `.../respond {note}` | required, non-empty | inferred from every other "note required" pattern in this ticket — `NOT SPECIFIED` explicitly for this one field by any source; build required, since an empty reply is not a response | `[OPEN]` (design inference, flagged) |
| `PayrollEntryFix.changes` shape | `{field, label, before, after}[]`, matching `PayrollSendBack.correctionChanges` | plan (reference, precedent) | `[UNVERIFIED]` |
| note max length (any) | `NOT SPECIFIED` | — | — |

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | `REST_UNDER_8H` fires on a sub-8h gap with no PAY-045 premium applied, and on one with a premium applied | REQ-15 |
| Unit | Each of the five `INVALID_TIME_*` detectors, against a matching and a non-matching row | REQ-16 |
| Unit | `INVALID_LONG_BOOM_TIME` against same-start/end, out-of-order, and outside-work-window boom sessions | REQ-17 |
| Integration (API) | A fix on a crew member with no own window creates one and leaves the shared `WORK_TIME` row and co-crew pay unchanged | REQ-19 |
| Integration (API) | A fix's before/after preview matches a full recalculation's resulting figures | REQ-20 |
| Integration (API) | Void/complete refuse a `REJECTED` ticket, matching `spec.md` REQ-06's Q6 resolution | REQ-24 |
| Integration (API) | Sending back one member of a two-person ticket creates two rows, one group, and holds both weeks | REQ-25 |
| Integration (API) | Closing/withdrawing a return group releases every member's hold | REQ-25 |
| Integration (API) | A non-primary's resubmit/adjust attempt is refused; the primary's succeeds with a reason | REQ-30 |
| E2E/manual | A crew ticket is returned, the worker edits and resubmits on mobile, payroll recalculates, the flag clears or stays per Q25's eventual answer | REQ-25–REQ-32 |

- Requirements with no testable acceptance criterion: REQ-31 (deliberately unstated pending
  Q24), REQ-21/REQ-23/REQ-27/REQ-28 (copy/layout `NOT SPECIFIED`).

## 11. Non-functional

- **Sequencing within this file:** REQ-15 depends on U2 (rest-gap engine, in progress) and U5
  (flag framework, not started); REQ-16/17 depend on U5 only; REQ-18–21 (U8) depend on U1
  (built); REQ-22/23 (U9) depend on U8 shipping first, per the plan's own `dependsOn`; REQ-24
  (U10) depends on U3 (not started) and U8; REQ-25–29 (U11/U12) depend on U1 and U9; REQ-30–32
  (U13) depend on U11. **None of REQ-15–32's prerequisite units (U2–U5) is finished on this
  branch today** (§0) — this file is specified ahead of its own dependencies, same as `spec.md`
  was written before any of U1–U5 existed; re-verify every code citation above once U2–U5 land,
  since U5 in particular may ship with a different shape than `spec.md` currently proposes.
- **Migration/rollout order:** schema → api → web → mobile, within each unit, matching
  `spec.md`'s own §11 pattern.
- **Audit:** `PayrollEntryFix` (REQ-18) and the widened `TicketTimeAdjustment` (REQ-30) are this
  file's audit trails, following the same self-contained-JSON/row precedent `spec.md` REQ-09
  already established for `PayrollFlagEvent` — three different audit mechanisms across the
  whole ticket now (`PayrollFlagEvent`, `PayrollEntryFix`, `TicketTimeAdjustment`), each for a
  different actor (the flag framework, payroll's own fix, a worker's own adjustment). `NOT
  SPECIFIED` whether these should ever be unified into one activity feed for `/payroll/audit`
  to read from — flagged for REQ-21's executor, since that screen is where all three would
  otherwise need three separate queries.

## 11a. Ripple — already-shipped behaviour these requirements reach

| # | Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `packages/payroll-engine` rest-chain output, `PayrollJobDay.restGapHours` | new API-layer read, no engine change | REQ-15 | **unchanged** — this detector reads the already-persisted column; nothing about how the engine computes or writes it changes | `apps/api/prisma/schema.prisma:5521-5526` (code); `rest-period.ts:44-79` (code) | `grep -n "restGapHours" apps/api/prisma/schema.prisma packages/payroll-engine/src apps/api/src` |
| 2 | `TICKET_MISSING_PAYABLE_WINDOW` (existing, run-level `PayrollIssue`) | separate, parallel mechanism | REQ-16 | **unchanged** — a new, per-employee `PayrollFlag` is added alongside it; the existing issue's storage/consumers do not change | `payroll.service.ts:221-236`, `payroll.repository.ts:668` (code) | read directly |
| 3 | `PayrollEmployeeWeekStatus.FLAGGED` relabel (`spec.md` REQ-09) | shared enum, web display copy only | REQ-17 | **unaffected** — this requirement adds catalog entries, not a second relabel | `spec.md` §2 REQ-09's Ripple (reference) | read directly |
| 4 | `assertNoRecalculationHold` / `countBlockingByEmployee` (existing, `PayrollSendBack`-scoped) | generalised to also count `PayrollEntryFix` | REQ-18 | **changes deliberately** — the same functions now read a second table; every existing call site (`payroll.service.ts:857,896,1050,1081`) is unaffected in behaviour when no fix exists, and newly holds when one does | `payroll.service.ts:627-634` (code) | `grep -n "assertNoRecalculationHold\|countBlockingByEmployee" apps/api/src/usecase/payroll` |
| 5 | `apps/api/src/usecase/payroll-send-backs/plan-correction.ts`'s shared-`WORK_TIME`-move path | replaced for the payroll-fix caller only | REQ-19 | **changes deliberately, for this new caller** — the existing correction feature (crane-supervisor-gated, still live until REQ-22 removes the permission) keeps its own call path into `planCorrection` untouched unless the executor chooses to share the function; if shared, every existing caller's behaviour for a member with no own window changes too — **flagged, not decided, see Notes on REQ-19** | `plan-correction.ts:266-296` (code) | read directly |
| 6 | Existing (live) `correction-rules.ts` crew-wide checks (`findSettledCrewPay`, whole-crew overlap/rest) | REQ-19's per-person path drops them; the existing correction feature keeps them until REQ-22/23 retire it | REQ-19 | **unchanged for the existing caller, dropped for the new one** — two call paths, two rule sets, until REQ-22 removes the old one | `payroll-send-backs.repository.ts:678` (`findSettledCrewPay`, code) | read directly |
| 7 | `apps/api/src/usecase/ticket-labor-entries/compute-labor-hours.ts` (existing, live) | re-exports from the relocated shared util | REQ-20 | **changes deliberately, output unchanged** — every existing caller keeps the same function name and result; only the implementation's location moves | PR #699 code, confirmed the shape re-exports cleanly | `grep -rln "compute-labor-hours" apps/api/src` |
| 8 | `features/payroll-corrections` form components (existing, live) | reused, not modified, as REQ-21's base | REQ-21 | **unchanged for their existing caller** — the existing correction screen keeps using them exactly as today until REQ-23 removes that screen | code, confirmed no `crane-supervisor` reference in the three lib files | read directly |
| 9 | `crane-supervisor` permission, `OPS-CS` role, every role's implicit denial of it | removed entirely | REQ-22 | **removed** — no role can hold it after migration; any tenant that had deliberately granted it to a custom role loses that grant with no replacement offered by this ticket | decisions (verified); `seed-data.ts:1119-1131` (code) | `grep -rln "crane-supervisor" apps/api/src apps/web/src packages/shared/src` |
| 10 | `apps/web/src/app/(protected)/payroll-corrections` and its sidebar entry | removed | REQ-23 | **removed** — any bookmarked link 404s via the redirect; any in-flight `PAYROLL_SEND_BACK` notification re-routes to `/payroll/[employeeId]` | `sidebar-nav-items.tsx:91,227-235` (code) | `grep -rln "payroll-corrections" apps/web/src` |
| 11 | `payroll.entry_sent_back`/`payroll.entry_corrected` notification templates | retired | REQ-22 | **removed** — replaced by REQ-26's `payroll.ticket_returned`/`payroll.send_back_responded` | `notification-catalog.ts:414-436` (code) | `grep -n "entry_sent_back\|entry_corrected" apps/api/src/usecase/notifications/notification-catalog.ts` |
| 12 | Mobile `openTicket`'s "Signed by `<name>`" invention (`ticket-flow.store.ts:468-476`) | exempted for a payroll-completed ticket only | REQ-24 | **changes deliberately, scoped** — every other ticket's invention logic is unchanged; only a ticket with `payrollClosedAction: COMPLETED` skips it | `ticket-flow.store.ts:468-476` (code) | read directly |
| 13 | `spec.md` REQ-06's void action and its own §11a rows | `PayrollTicketClosure` enum shared with this ticket's `COMPLETED` value | REQ-24 | **unchanged, extended** — REQ-24 is the enum's second half, already anticipated by `spec.md` §3's own comment | `spec.md` §3 (reference) | read directly |
| 14 | `apps/api/src/usecase/payroll-send-backs/payroll-send-backs.service.ts`'s single-employee `sendBack` | rewritten to expand to the roster | REQ-25 | **changes deliberately, and is a breaking change to the method's own contract** — every existing caller (today: the live, crane-supervisor-gated correction screen; after REQ-22/23, only this ticket's own) must pass a ticket, not an employee, or the method needs a second entry point | `payroll-send-backs.service.ts:143` (code) | read directly |
| 15 | `packages/shared/src/types/notification.types.ts`'s `NOTIFICATION_TYPES` array | additive | REQ-26 | **unchanged for existing entries** — three new entries added, none removed here (the two REQ-22 removes are removed there, not here) | `notification.types.ts:43-49` (code) | read directly |
| 16 | Existing (live, still-crane-supervisor-era) Send Back dialog | reused, extended | REQ-27, REQ-28 | **changes deliberately** — the dialog's single-recipient framing becomes crew-list framing (REQ-28), per Q23's resolution; if Corrina's still-outstanding ratification comes back "no," this reverts | code, plan (reference) | read directly |
| 17 | `use-register-push-token.ts` (existing, live) | gains a listener | REQ-29 | **changes deliberately, additive** — existing single-registration-on-mount behaviour is unchanged; a token-rotation path is added alongside it | `use-register-push-token.ts` (code, confirmed no listener exists today) | read directly |
| 18 | `notification-scheduled-jobs.service.ts`'s existing `@Cron` jobs and `MANUAL_CRON_TRIGGER_JOBS` registry | one more job added | REQ-29 | **unchanged for existing jobs** — additive registration only | `notification-scheduled-jobs.service.ts:46-53,208-213` (code) | read directly |
| 19 | `recordTicketStep`/`recordStepProgress`'s terminal guard (existing, live, used by every mobile ticket-step write) | exempted for one specific case | REQ-30 | **changes deliberately, narrowly scoped** — every other terminal-ticket write attempt (any status, any non-primary, any non-adjustment) is refused exactly as today; only a primary's reasoned adjustment on a returned `COMPLETE` ticket passes | `job-tickets.service.ts:764-772,986-994` (code) | read directly |
| 20 | `TicketTimeEntry`'s crew-wide storage (existing, live, read by every payroll pricing pass, every mobile ticket view, every existing correction) | written by REQ-30/31/32's mechanism | REQ-31 | **changes deliberately, on an unratified basis.** REQ-31 is now built (Candidate B: six field types write the shared row and reach every crew member's pay); every existing reader of `TicketTimeEntry` (the engine, the web timesheet, the mobile ticket view for every crew member) sees that write. The `[CONFLICT]` tag stays because this is the developer's answer, not Corrina's — see Q24 | REQ-31's own Statement and Sources | `grep -rln "TicketTimeEntry" apps/api/src apps/web/src apps/mobile` (not run in full here — flagged as a wide surface the executor should re-check before building) |
| 21 | `isStepReadOnly`/`isReadOnlyTicket` (existing, live, gates every mobile ticket-step screen) | extended with a returned-and-primary exemption | REQ-32 | **changes deliberately, narrowly scoped** — every ticket that is not both returned and viewed by its primary keeps today's read-only logic exactly | `ticket-step-screen.tsx:191-196`, `app/(field)/ticket/index.tsx:170-175` (code) | read directly |
| 22 | `me.service.ts`'s `sumLaborHours` / `/me/labor` / `/me/performance` (existing, live, read by mobile's `menu/labor.tsx` and the in-flow labor/review steps) | own-window precedence added | REQ-33 | **changes deliberately** — every employee with no own window on a ticket this week sees the same figures as today; an employee with a REQ-19 fix or REQ-30 resubmit sees the corrected own-window figure instead of the shared-ticket one | `me.service.ts:67-88` (code); developer answer to Q21 (reference) | `grep -rln "me/labor\|me/performance\|ApiMyLaborResponse\|ApiPerformanceResponse" apps/mobile apps/web` |

- **Consumers with no source for what happens to them:** none any more — row 20 (REQ-31) now
  has a stated source (its own Statement, built on Candidate B), even though that source is a
  developer's reading against a verified rule, not the rule itself, which is exactly what the
  `[CONFLICT]` tag on REQ-31's heading continues to signal.

---

## 12. Open questions — the stop-and-ask list

**Updated 2026-09-30, second pass: all six questions below are now `Status: resolved`.** The
developer (devmohsinakram) answered Q20–Q25 the same day, relayed by the coordinator. Q20,
Q21, Q22 and Q25 are settled mechanics, folded into their requirements without qualification.
**Q23 and Q24 are resolved as "which design to build," not as client ratification** — both
remain explicitly pending Corrina Bustos, and REQ-31 (Q24) keeps its `[CONFLICT]` tag for
exactly that reason. The grep below should now return nothing; kept for whoever reopens this
file next, and to catch anything a concurrent pass adds.

```bash
grep -n '^- \*\*Status:\*\* open' .ai/aidlc/PAYROLL-FLAGS/spec-u6-u13.md
grep -n '^### REQ-\|^### Q[0-9]' .ai/aidlc/PAYROLL-FLAGS/spec.md   # re-check before merging either file
```

### Q20 — REQ-19: does a fix on a one-person-roster ticket satisfy "individual," and does any fix reach billing or invoicing?

- **Question:** Two parts. (1) On a ticket with exactly one `ticket_employees` row, is editing
  that ticket's own captures directly (creating an own window, per REQ-19) the right reading of
  "a fix changes only that one person" — since there, the ticket's shared capture and that one
  person's capture are the same row by construction — or should payroll's fix always create an
  own window even there, for consistency with the crew case? (2) Does any payroll fix — on one
  person or a crew — reach billing or invoicing, given the API bills from
  `WORK_AT_JOB_SITE_TIME`, a window this fix does not touch, but a fix to `WORK_TIME` still
  changes what a customer-facing report of hours worked would show if one ever reads from the
  same ticket?
- **Why it cannot be answered from what is written:** Corrina's "individual" answer
  (2026-09-29 clause 3) was given about a shared time on a **crew** ticket; nobody asked about
  the one-person case, because at the time of that exchange nobody had proposed creating an
  own window as the mechanism. Billing was never asked about any payroll correction, on either
  ticket shape — `payroll/gaps.md` item C8 raises the exact same gap for voiding/completing
  (Q22, below), and no source anywhere distinguishes "payroll changed a number" from "a
  customer's invoice changed."
- **Blocked:** REQ-19's exact write path for a one-person ticket (a real behavioural choice,
  not cosmetic — it determines whether `PayrollEntryFix.changes` ever needs to represent an
  own-window creation that had no crew to protect against in the first place).
- **Candidates:** `decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md`
  clause 3 (verified, but silent on this exact case); `payroll/gaps.md → Payable time` (5337,
  resolved, but about what is *paid*, not what is *billed*); no candidate addresses billing at
  all.
- **Owner:** Corrina Bustos (the correction rule) and Brian Petros or TCG's billing owner
  (unnamed anywhere in the vault) for the billing half.
- **Workaround, if any:** create an own window on every ticket regardless of roster size, for
  consistency and so `PayrollEntryFix` rows always have the same shape — labelled a proposed
  default in REQ-19, not a decision. For billing: build no billing side-effect in this unit;
  `NOT SPECIFIED` and flagged, since nobody has asked.
- **Answer (2026-09-30, developer direction, devmohsinakram, relayed in the coordinating
  session):** *"Own window, no billing": a payroll fix always writes to that person's own
  window, even on a one-person ticket. The ticket's shared times, and so customer billing,
  stay untouched.* Both parts of the question are answered: the proposed default (always
  create an own window) is confirmed as the actual design, not merely the smallest-risk
  choice; and no billing side-effect exists. Folded into REQ-19.
- **Status:** resolved — developer direction, devmohsinakram, 2026-09-30, `reference`; not yet
  written into `.ai/vault/decisions/` (recommend `tcg-scrum` record it alongside Q21, Q22 and
  Q25 below — lower urgency than Q23/Q24, which are pending Corrina Bustos).

### Q21 — REQ-19/REQ-32, answered by REQ-33: does `/me/labor` (the worker's own hours view) reflect a payroll fix or a worker's own resubmitted edit?

- **Question:** `apps/api/src/usecase/me/me.service.ts:67-72` (per `payroll/gaps.md`'s own
  citation, not independently re-verified in this pass) reportedly ignores the TCG-25 own
  window today. If that is still true once REQ-19 starts writing own windows, does the affected
  worker ever see the corrected hours on their own mobile "my hours" view, or only payroll?
  Same question for a worker's own resubmitted edit under REQ-32.
- **Why it cannot be answered from what is written:** no source discusses `/me/labor` in the
  context of this ticket at all; the citation is `spec.md`'s own §13, listed there as a
  question raised by U1–U5's research but not built into any U1–U5 requirement, and not
  resolved since.
- **Blocked:** REQ-19's and REQ-32's completeness as "the worker can see their own corrected
  time" — neither requirement currently promises this, and if a worker cannot see a fix or
  their own resubmission reflected, the "resubmit" workflow (REQ-30) may show the worker a
  number that quietly changes again once payroll recalculates, with no visible trace.
- **Candidates:** `spec.md` §13 (its own open item, not resolved by U1–U5); no other source.
- **Owner:** TCG field-ops/payroll owner — unnamed for this specific screen.
- **Workaround, if any:** ship without touching `/me/labor` in this unit, flagged as a known
  gap rather than silently assumed fine — a worker's own mobile ticket view (not `/me/labor`)
  already shows the ticket's captured times directly, so the more urgent half of this question
  is whether *that* view reflects a fix made after the worker last saw it, which REQ-32's own
  ticket refresh (reopening, re-reading from the server) already covers for the resubmit case.
- **Answer (2026-09-30, developer direction, devmohsinakram, relayed in the coordinating
  session):** *"Show corrected hours": `/me/labor` reads the person's own window/override, so
  workers see payroll's corrected hours. This is now IN scope.* The workaround above (ship
  without touching it) is **not** taken — a new requirement, **REQ-33**, is added to close this
  gap instead, covering both REQ-19's fix and REQ-30's worker resubmit. See REQ-33.
- **Status:** resolved — developer direction, devmohsinakram, 2026-09-30, `reference`; not yet
  written into `.ai/vault/decisions/`. Built as REQ-33, appended at the end of §2 (this file's
  numbering keeps REQ-15–REQ-32 in their original places — see §0, *A numbering note*).

### Q22 — REQ-24: does completing or voiding a never-completed ticket reach billing, invoicing or dispatch?

- **Question:** Payroll can now void (`spec.md` REQ-06, U3) or complete (REQ-24, this file) a
  ticket the crew never finished. Does either action need to notify or update billing,
  invoicing or dispatch — for example, does a voided ticket need its allocation released, or a
  completed one need billing to know its times were payroll-entered rather than crew-captured?
- **Why it cannot be answered from what is written:** the incomplete-tickets decision's own
  *Not decided* item 2 names the escape path as needed but does not say what it touches beyond
  payroll; the developer's C8 answer states the mechanics (complete or void, note required,
  audited) and explicitly flags the same gap back: *"Voiding a ticket is new, and reaches
  beyond payroll. Nobody has asked either of them [dispatch or billing]."*
- **Blocked:** REQ-24's completeness, and retroactively, `spec.md` REQ-06's — neither
  requirement currently notifies dispatch or billing of anything.
- **Candidates:** `decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md`
  *Not decided* item 2; `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md`
  item C8 (both name the gap, neither closes it).
- **Owner:** Corrina Bustos, with TCG's dispatch owner (Lisette Anzaldo, named elsewhere in the
  vault for a different but adjacent question) and TCG's billing owner (unnamed).
- **Workaround, if any:** build both actions as payroll-only, with no dispatch/billing
  side-effect, exactly as `spec.md` REQ-06 already shipped (or will ship) — labelled a known
  gap, not a decision, in both requirements' Notes.
- **Answer (2026-09-30, developer direction, devmohsinakram, relayed in the coordinating
  session):** *"Payroll only": completing a never-completed ticket makes it priceable for
  payroll only. Billing, invoicing and dispatch are untouched, the same as void.* Confirms the
  workaround above as the actual design for both actions, and matches `spec.md`'s own Q5
  answer for voiding, word for word in substance. Folded into REQ-24.
- **Status:** resolved — developer direction, devmohsinakram, 2026-09-30, `reference`; not yet
  written into `.ai/vault/decisions/`.

### Q23 — REQ-25/REQ-26/REQ-28: does sending back one worker on a shared ticket return and hold every worker on it?

- **Question:** One line: *"When one worker's entry on a shared operator+oiler ticket is sent
  back, should the send-back cover every worker on that ticket (and hold every one of their
  weeks), or only the worker payroll targeted?"*
- **Why it cannot be answered from what is written:** Corrina's verified rule (2026-09-30) says
  Send Back's target is *"the worker"* — singular, and never asked about a ticket with more
  than one worker on it. The developer's C6 answer extends it to the whole ticket, verbatim:
  *"if any job have oiler and oprator both then oiler and oprator have one tickt so if we send
  oiler or oprator ticket back it should send other employee as well and block both employees
  payroll."* The vault's own gaps entry (`payroll/gaps.md:5467`) records this explicitly as
  *"pending Corrina Bustos"* and *"it needs her OK."*
- **Blocked:** REQ-25's core design (one send-back row per roster member vs. one row for the
  targeted employee only), REQ-26's per-member notification fan-out, and REQ-28's dialog
  framing (crew list vs. single name).
- **Candidates:** `decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md`
  (verified, silent on multi-worker tickets); `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md`
  item C6 (reference, the only candidate that actually answers the multi-worker case);
  `payroll/gaps.md:5467` (the full record of the question, with options (a) left alone, (b)
  held, (c) returned too — the developer chose (c) plus a hold).
- **Owner:** Corrina Bustos.
- **Workaround, if any:** build option (c) (return and hold every worker), as the developer
  directed and as this file's REQ-25 already specifies — the only fully-specified design on
  record. Isolate the crew-expansion step (per REQ-25's own Notes) so a different answer is a
  small revert.
- **Answer:** already on record before this question was raised — `answers.md` round 6 and
  `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` item C6, both
  cited above. The coordinator confirmed 2026-09-30 that this is the answer to build to, not a
  new one: **build option (c)**. Corrina Bustos's own ratification of the extension remains
  outstanding — that half of the question is **not** resolved, only which design to build is.
- **Status:** resolved — build option (c), developer direction (C6), `reference`; **pending
  Corrina Bustos's ratification**, not blocking this requirement's build. Not yet written into
  `.ai/vault/decisions/` as a build decision, though the underlying C6 answer is (see Sources).

### Q24 — REQ-31 `[CONFLICT]`: whose pay does a worker's shared-ticket correction reach?

- **Question:** *"On a shared ticket, when a worker corrects a returned entry on mobile, should
  the crew-wide captures (Left Yard, Arrived Site, Left Site, Arrived Yard, lunches, boom
  sessions, build-up, break-down) move for the whole crew — the only mechanism the schema
  supports today, since `TicketTimeEntry` has no per-employee column — or should the worker's
  edit reach only their own pay, which would require building a per-employee override for
  those fields first (currently scoped as its own unit, U19, blocked on the same open question,
  C4)? A third option: restrict the worker's own mobile edit to Start Work/End Job only (which
  already has a per-employee home), and require every other correction to go through Payroll."*
- **Why it cannot be answered from what is written:** see REQ-31's own Conflict field in full —
  the verified "individual" rule was asked about payroll's own correction, never about a
  worker's; the developer's contrary reading is explicitly recorded by the vault as *"a
  conflict for her to settle, not as settled."*
- **Blocked:** REQ-30 (which fields the terminal-guard exemption covers), REQ-31 (had no
  statement to build from until this was answered), REQ-32 (which fields the mobile UI
  enables).
- **Candidates:** `decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md`
  clause 3 and its own *Conflicts* item 4 (verified, but scoped to payroll's own fix, and
  self-admittedly missing a per-employee home for six field types);
  `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` → *Follow-up
  answers* (reference, the only candidate that addresses the worker-edit case directly, and the
  only one the vault itself flags as unresolved).
- **Owner:** Corrina Bustos.
- **Workaround, if any:** the smallest-buildable default, stated plainly as a mechanism, not a
  chosen side: Start Work/End Job through the TCG-25 own window (individual — both candidates
  agree here); the six other field types, if editable in this unit at all, write the shared
  row and hold every crew member's week (the only mechanism available without U19). See REQ-31's
  own Notes for the alternative of not building worker-editable shared fields at all in this
  unit.
- **Answer (2026-09-30, developer direction, devmohsinakram, relayed in the coordinating
  session):** *"Shared times move both"* — the same C6-refined answer already on record
  (`developer-answers` note, *Follow-up answers*), now confirmed as the design to build:
  shared ticket times (yard, site, work) move for both workers when either edits them; each
  worker fixes only their own personal times. This is exactly the proposed workaround above,
  now built as REQ-31's actual Statement, not a default awaiting confirmation. **This does not
  ratify the answer against Corrina's verified "individual" rule** — the coordinator's own
  instruction was explicit: keep the `[CONFLICT]` tag, state this is built on the developer's
  reading, against her verified rule, pending her. Note also (round 9, `answers.md`, not yet
  in the vault): **U19's per-person override table is the future path to fully individual
  edits** — once built, it would let Candidate A (individual) become buildable as a general
  rule, superseding this requirement's shared-write default for the six field types. See
  REQ-31's own Sources for the exact round-9 quote.
- **Status:** resolved — build Candidate B, developer direction, `reference`; **`[CONFLICT]`
  kept — pending Corrina Bustos's ratification against her own verified "individual" rule.**
  Not yet written into `.ai/vault/decisions/`; recommend `tcg-scrum` record this as a live
  conflict needing her decision, not as a settled answer, precisely because a build choice was
  made on top of it.

### Q25 — REQ-30: does a worker's resubmit re-run the flags immediately, or must payroll recalculate first?

- **Question:** After a worker resubmits a corrected ticket (REQ-30), does the system
  immediately re-evaluate whether the conditions that caused a flag (e.g. an invalid-time flag
  from U7) still hold — auto-clearing it the way a full Calculate run would per `spec.md`
  REQ-09's Acceptance — or does the flag stay `OPEN` (and the week stays held) until Payroll
  explicitly runs a recalculation, exactly as REQ-18's fix-hold already works?
- **Why it cannot be answered from what is written:** the developer's C3 answer states the
  mechanics of the edit-and-resubmit itself (*"Payroll then recalculates"*) but the same note's
  own closing section lists this exact question under *"What this note does not decide"*: *"Not
  stated: whether the resubmitted times re-run the flags, or whether Payroll must still clear
  the flag after recalculating."*
- **Blocked:** REQ-30's resubmit endpoint's exact side-effects, and whether REQ-27's mobile
  banner can honestly tell the worker their fix is "done" or only "sent."
- **Candidates:** `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md`
  item C3 and its own *What this note does not decide* section — the one place this question is
  written down, unanswered.
- **Owner:** Corrina Bustos, or CodingCops as an engineering-consistency call (this reads more
  like REQ-18's own design than a product fact — REQ-18 already establishes that a fix holds
  until the *next completed Calculate*, not immediately; the consistent reading is that
  resubmit behaves the same way).
- **Workaround, if any:** match REQ-18's own pattern — resubmit holds the week, per REQ-30's
  Acceptance, until the next full Calculate run reconciles the flags, rather than building a
  second, lighter-weight reconciliation path solely for resubmit. Proposed default, not a
  decision.
- **Answer (2026-09-30, developer direction, devmohsinakram, relayed in the coordinating
  session):** *"Next Calculate": a worker's resubmit holds the week until payroll
  recalculates, and flags and pay update then.* Confirms the proposed workaround (match
  REQ-18's pattern) as the actual design, not merely the safest guess. Folded into REQ-30.
- **Status:** resolved — developer direction, devmohsinakram, 2026-09-30, `reference`; not yet
  written into `.ai/vault/decisions/`.

---

## 13. What this spec deliberately does not specify

- **Exact UI copy and layout** for every new web/mobile surface in this file — no source
  supplies it; see each REQ's `NOT SPECIFIED` markers.
- **U14–U21**, out of scope, per `spec.md` §0's own scope line, continued here: U14 (worker
  edits build-up/boom/lunches on a returned ticket — round 9 now answers its scope too,
  *"YES, ALL"*, but U14 itself is not built here; REQ-31/32 already build the same field list
  for the six shared-capture types, so U14 may now be largely subsumed by this file rather
  than a genuine follow-up — worth `tcg-scrum`/the decomposer checking before U14 is separately
  planned); U15 (boom-range flag — the boom basis question is now answered, per `answers.md`
  round 9: *"the crane's min–max range, as built"* — but U15 itself is not built here); U16
  (wrong AM/PM — now answered by round 9: *"a 12-hour shift fixes order"* — and labor-vs-ticket
  — *"more than 30 min different"* — neither built here); U17 (missing notes — now answered by
  round 9: required when a captured time is adjusted, a lunch is worked through, any flag is
  on the entry, the ticket is over 12 h, or the worker marks a checklist issue — not built
  here); U18 (crew Left Yard/Arrived Yard mismatch — grouping now answered by round 9, *"same
  job + same date"*, flag owner *"the ticket only"* — not built here); **U19 (per-person
  corrections on crew tickets — now has a design, per round 9: an override table keyed
  (ticket, employee, step), read by pricing/payroll where one exists, shared ticket times
  otherwise unchanged — see REQ-31's own Sources).** REQ-31 is built to a shared-write default
  for exactly the fields U19's override table would cover; **once U19 ships, it supersedes
  REQ-31's default**, and the decomposer should treat U19 as REQ-31's named successor, not an
  independent unit, when U19 is eventually planned. U20 (Samsara event mapping — round 9
  answers the signal choice and geofence radius, not built here); U21 (asset-not-home flag —
  round 9 answers scope and timing, not built here).
- **Whether U5 ships with the exact schema `spec.md` §3 proposes.** Every REQ in this file that
  depends on `PayrollFlag`/`PayrollFlagEvent` cites `spec.md`, not code, because U5 is not built
  (§0). If U5's executor changes the shape while building it, REQ-15/16/17 need re-checking
  before their own units are built — flagged again in §11, not re-raised as a numbered question
  here since it is a build-sequencing fact, not a product one.
- **Whether `PayrollTicketClosure.COMPLETED` (REQ-24's dependency) survives U3's build
  unchanged.** Same caveat as above, for U3 instead of U5.
- **REQ-19/REQ-30's shared function question** (whether `plan-correction.ts` is genuinely
  shared between the still-live correction feature and this ticket's new fix/resubmit paths, or
  forked) — flagged in §11a rows 5–6 as a ripple risk, not elevated to a numbered question,
  because either answer is buildable and the choice is an engineering one, not a product one.
- **Whether this file's `PayrollEntryFix`, `TicketTimeAdjustment` and `PayrollFlagEvent` (three
  separate audit mechanisms across the whole PAYROLL-FLAGS ticket) should ever be unified** —
  flagged in §11, not asked as a question, since no source asks for a single audit feed and
  three separate, correctly-scoped trails is a defensible design on its own.
- **`ApiLaborShiftRow.hours`'s exact own-window behaviour (REQ-33)** — the developer's Q21
  answer says "the person's own window/override" without distinguishing the week total from
  the per-ticket shift row; REQ-33 builds both, flagged as an inference, not independently
  confirmed.

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person —
      *(no REQ in this file was ever `[OPEN]`; REQ-31 is `[CONFLICT]`, not `[OPEN]` — it now
      has a Statement built on two named sources in tension, not zero sources. All six §12
      questions — Q20–Q25 — are `Status: resolved` as of this second pass.)*
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` — *(REQ-31
      does not yet; Q24 is the question that decision note would answer — and, unusually, a
      build decision (Candidate B) was made on top of the unresolved conflict, which is exactly
      why `tcg-scrum` should record it: not as a settled answer, but as "here is what was
      built, and here is the client ratification it still needs.")*
- [x] Answers written back into this file with their new sources and flags — *(REQ-19 rewritten
      to remove the roster-size branch for Start Work/End Job; REQ-24's billing/dispatch
      question closed; REQ-25/REQ-28 marked resolved-but-pending-Corrina; REQ-30's flag-timing
      question closed; REQ-31 given a Statement, `[CONFLICT]` tag kept; REQ-33 added for Q21's
      answer. Q20–Q25 renumbered in the same pass from their original Q11–Q16 to avoid a second
      collision with `spec.md`'s own, unrelated Q11 — see §0.)*
- [x] Every §12 question updated to `Status: resolved — …` — *(Q20, Q21, Q22, Q25 resolved
      without qualification; Q23, Q24 resolved as "which design to build," explicitly still
      pending Corrina Bustos's ratification, which is not the same thing and is stated as such
      in both places.)*
- [x] Every §11a ripple row has a source for what happens to that consumer, or a §12 question —
      *(row 20 (REQ-31) now has a source — its own Statement — even though that source is a
      developer's reading against a verified rule; a row 22 was added for REQ-33.)*
- [ ] Decomposed into vertical units — not yet; `units.md` covers U1–U5 only, and per the task
      that produced this file, this spec is not to edit it. A follow-up decomposition pass
      (`tcg-decomposer`) should slice REQ-15–REQ-33 into U6–U13 now that Q20–Q25 are resolved
      (Q23/Q24 with their ratification caveat carried forward), matching the unit boundaries
      this file's own REQ groupings already imply. The decomposer should also decide where
      REQ-33 lands (U8, per this file's own note at REQ-33) and flag REQ-31/U13 for extra
      review given its `[CONFLICT]` tag.

Answered by: ______________  Date: ______________

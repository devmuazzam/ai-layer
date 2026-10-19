---
title: "Slot-driven ticket steps, floating checklists, time adjustment, and holdover flow — decision"
source: decision/Syed Haris (CodingCops) — developer direction in Claude Code session, 2026-10-15
decided: 2026-10-15
decided_by: >-
  Syed Haris (CodingCops, syed.haris@codingcops.com). Decided D1–D10 (slot-driven step flow,
  floating checklists, time adjustment) and H1–H10, S1–S5 (holdover flow) in a Claude Code planning
  session on 2026-10-15. These are developer decisions answering open gaps; where they differ from
  Melissa McNutt's provisional answers
  (decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md,
  status: reference), Haris's answer stands until TCG ratifies or supersedes it.
status: reference
conflicts_with: []
resolves:
  - field-ops/gaps.md#holdover-days-2--on-site-daily-pre-trip-and-is-there-a-post-trip-on-the-days-in-between
  - field-ops/gaps.md#end-work--break-down-end-or-the-crew-leaving-the-job-site
  - field-ops/gaps.md#may-one-job-ticket-run-24-hours-or-more-or-is-a-multi-day-job-always-one-ticket-per-day
  - payroll/gaps.md#holdover-days-2--does-paid-time-start-on-arrival-at-the-job-site-and-where-does-each-day-end
related_decisions:
  - 2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md
  - 2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md
  - 2026-09-03-paid-time-boundaries-yard-to-yard.md
  - 2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md
jira: []
tags: [module/field-ops, module/payroll, module/dispatch, kind/decision, ticket-workflow, inspections, time-tracking, safety]
---

# Slot-driven ticket steps, floating checklists, time adjustment, and holdover flow

Developer direction from Haris (CodingCops), answering open gaps and overriding unverified
sources. This is `status: reference` because it is a developer direction, not a TCG product
decision. Where a verified decision exists (e.g. the one-ticket rule from 2026-09-14), it
still governs.

## Part 1 — Step flow by DAS slot, floating checklists, time adjustment (D1–D10)

### D1 — Step flow follows the slot, not the employee type

FULL flow for an Oiler slot, whoever fills it. FULL for an Operator slot when the set has
**no Oiler slot**; other slots in the set are allowed (matches
decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md clause 3). Every other
slot gets STANDARD.

### D2 — "The set has an Oiler slot" is read from allocations

Read from that day's **employee allocations** with the same set, shift and sub-job.

### D3 — Two Operator slots and no Oiler

Not a real case; behaviour stays as today (each Operator gets their own ticket, both FULL).
**Filed as an open question** in field-ops/gaps.md.

### D4 — Shared resolver

`resolveTicketStepFlow()` returns `'FULL' | 'STANDARD'`. `FieldTicket` gains `stepFlow`,
computed for the caller's own slot.

### D5 — Siblings switched to the slot rule

Crew grouping, API submit guard and labor writes, web job-progress, mobile checklist fetch,
prefetch and verify all switch to the slot-based step flow.

### D6 — Pre-trip, post-trip and JSA float, block only submit

`pretrip`, `posttrip` and `jsa` are always tappable and never block the next step. Submit is
blocked until they are done. `sig1`, `sig2` and `compliance` are unchanged (sequential).

**Overrides (all unverified, under the field-ops-mobile conflict stub):**
- FR-TCG-FOP-002 `field-ops/field-ops-frd/08-functional-requirements/fr-fop-011-job-safety-analysis-jsa.md` — JSA was sequential
- FR-TCG-FOP-002 `field-ops/field-ops-frd/08-functional-requirements/fr-fop-012-start-work.md` — Start Work gated on prior steps
- Atom `field-ops/atom-mobile-app-user-stories/02-ticket-assignment-and-pre-trip.md` (stories 78, 149) — pre-trip was gated

### D7 — Submit blocked on mobile and API

Submit is blocked on mobile (online and offline) **and** on the API
(`TICKET_SUBMIT_STEP_GUARD=true`).

### D8 — Time adjustment back in every build

`EXPO_PUBLIC_ENABLE_SEGMENT_TIME_ADJUST: "true"` goes in `eas.json` `base`, so every profile
gets it. Reverses commit `85f293978` (TCG-8). The guard test is relaxed for this one flag.

### D9 — Web progress gets floating rule

Web progress shows the floating rule: floating steps are never inferred as done.

### D10 — STANDARD tickets drop Start Work

STANDARD tickets have 8 steps, not 9: no Start Work, no build-up, break-down, lunches or WTL.
Left Job closes their `WORK_AT_JOB_SITE_TIME`. Meal periods use the payroll engine's fallback
schedule (`meal-periods.ts:23-34`).

## Part 2 — Holdover flow (H1–H10, S1–S5)

### H1 — Trigger

The **job** holds anything, crane or employee (`JobResource.isHoldover`,
`JobResourceAllocation.isHoldover`). Every ticket on the job follows the holdover flow; an
Operator folded onto the Oiler's ticket follows it through that ticket. A job that holds only
an employee still gets the full flow, crane prompt included.

### H2 — One ticket per day

Days open in date order through the existing `isFutureFieldTicket` guard (unchanged). Ticket
details and the ticket card show a Holdover badge and "Day d of D"; details also shows a
crane-state line.

### H3 — End Work step

New **End Work** step on FULL holdover tickets, after Start Work and before Final Signature.
Records `WORK_AT_JOB_SITE_TIME.endedAt`. On a day with no break-down, the open boom closes at
the same instant. **`WORK_TIME` is not stopped there**; it still closes at submit. The screen
restores the deleted `EndWorkBody` and shows a summary: work time, boom total with sessions,
lunch/pause, non-boom time. Non-holdover tickets are unchanged: the break-down end is the End
Work, with no step.

### H4 — Start Work on holdover tickets

Titled **Start Work**. On a held day, a Start Work card replaces the build-up card, and its
tap is the boom start. Build up happens only on Day 1 or after a break-down day.

### H5 — End-of-day crane choice

Every day but the last, End Work opens a sheet: **Leave crane set up** or **Start Breakdown**.
On the last day there is no prompt and the break-down is required.

### H6 — Unknown crane state

When the previous day's crane state is unknown, Day N offers **Start Build Up** or **Skip
Build Up**.

### H7 — Day 2+ start location

"Where are you starting from?" — Yard or Home, before any step. **Home**: no Left Yard and
no Driving; Arrive Job comes first, then Pre-Trip.

### H8 — Middle-day step list

Days 1 to N−1 have no Arrive Yard and no Compliance, and Post-Trip moves before Left Job. The
last day returns to the yard as usual.

### H9 — STANDARD holdover

STANDARD holdover tickets get H2, H7 and H8 only. Per D10 they have no Start Work, End Work
or crane steps.

### H10 — Holdover checklists float

Per D6.

### S1 — Crane state is derived, no schema change

The API reads the previous day's ticket for the same **Oiler slot** (match on `jobResourceId`
and shift first, then on the set). Any `BREAKDOWN_TIME` row gives BROKEN_DOWN. An End Work
with no break-down gives LEFT_SET_UP. Neither gives UNKNOWN. Day 1 gives NOT_SET_UP.

### S2 — Day start stored on JobTicket

Two new nullable columns: `dayStartFrom` (new enum `TicketDayStart`: YARD, HOME) and
`dayStartAt`. Written by `PATCH /field/tickets/:id/day-start`. Queued offline.

### S3 — Payroll flag exemptions on middle days

On holdover days other than the last, the open-`YARD_TIME` payroll flags are skipped:
invalid-times, crew-yard-mismatch and Samsara.

### S4 — Web progress shows holdover steps

Each holdover ticket's real per-day steps.

### S5 — No kill switch

Holdover goes live when the API deploys. Old builds on holdover jobs cannot submit until they
update.

## Step lists

| Flow | Non-holdover | Middle day, Yard | Middle day, Home | Last day, Yard | Last day, Home |
|---|---|---|---|---|---|
| FULL | 14 | 13 | 11 | 15 | 13 |
| STANDARD | 8 | 7 | 5 | 8 | 6 |

**FULL, middle day, Yard:** pretrip, leftYard, driving, arriveJob, sig1, jsa, startWork,
endWork, sig2, posttrip, leftJob, labor, review.

**FULL, middle day, Home:** arriveJob, pretrip, sig1, jsa, startWork, endWork, sig2, posttrip,
leftJob, labor, review.

**FULL, last day:** the full order with endWork added, and from Home without leftYard and
driving.

**STANDARD, non-holdover:** leftYard, driving, arriveJob, sig1, sig2, leftJob, arriveYard,
review.

## Supersedes

This note supersedes the holdover portions of
decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md
(`status: reference`). That note records Melissa McNutt's provisional answers, which TCG asked
to hold. Where Haris's decisions differ, his stand. The Melissa note stays as the record of
what was first said; its status remains `reference`.

## Effect on the vault

**Gaps resolved (done):**
- field-ops/gaps.md line 955: "Holdover days 2+ — on-site daily pre-trip" — answered by D6, H8, H10
- field-ops/gaps.md line 837: "End Work — break-down end, or the crew leaving the job site?" — answered by H3
- field-ops/gaps.md line 822: "May one job ticket run 24 hours or more" — answered by H2 (one ticket per day)
- payroll/gaps.md line 5767: "Holdover days 2+ — does paid time start on arrival" — answered by H7, S3 and Q5 (2026-10-16): Home-start holdover days paid time = Arrive Job Site to Left Job Site. Yard-to-yard does not apply when there is no yard step. STANDARD ticket meal fallback ships as-is.

**New open question filed:**
- field-ops/gaps.md: "Two Operator slots and no Oiler — which gets FULL?" (D3)

**No frontmatter changes.** The overridden FRD files (fr-fop-011, fr-fop-012) and Atom stories
are all `status: unverified` under the existing conflict stub. This developer direction does
not verify or supersede them — it directs the build to deviate from them. A TCG product
decision would change their status; a developer direction records what to build.

The provisional Melissa note (2026-10-06) stays `status: reference` with its existing
`conflicts_with`. Its holdover answers are now superseded in practice by this note, but its
status does not change because it was never `verified` — it was `reference` and remains so.

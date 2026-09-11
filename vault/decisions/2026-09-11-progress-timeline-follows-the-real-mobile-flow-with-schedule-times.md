---
title: The progress timeline follows the real mobile flow, with the schedule's times shown beside the actuals — decision
source: decision/Syed Haris
decided: 2026-09-11
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — developer/owner directing SCRUM-PROGRESS; picked this
  option in a working session on 2026-09-11 (verbatim in `.ai/aidlc/SCRUM-PROGRESS/intent.md` →
  Session decisions D2). He is **not** the client-side product owner. No owner is declared for
  projects-jobs; the one the vault names is **Lisette Anzaldo** (Dispatch Manager,
  `admin/engagement-directory-and-org-charts.md`), owner on 29 of 34 `projects-jobs/gaps.md`
  entries. **Lisette Anzaldo should ratify it.** `status: reference` for that reason. Same basis
  as the 2026-09-10 SCRUM-PENDING notes.
status: reference
conflicts_with: []
resolves: [SCRUM-PROGRESS/intent.md#d2--timeline-shape]
jira: []
tags: [module/projects-jobs, module/field-ops, module/dispatch, kind/decision, ticket-workflow, time-tracking, scheduling, geolocation]
---

# The timeline is the app's flow, not the design's

Answers D2 of `.ai/aidlc/SCRUM-PROGRESS/intent.md` → *Session decisions*.

## Decision

> **Q:** The field app captures less than the design shows. How should the timeline handle that?
> **Chosen:** *Real flow + schedule times (Recommended)* — "Role-based steps (14 for an Oiler, 9
> for everyone else). End Work comes from its captured time, incidents appear where they were
> filed, and scheduled on-site and end times are shown next to the actuals, display only. Data
> the app never captures is left out: odometer, ETA/distance, geofence, per-step GPS, live map."

**Not chosen:** *Real flow only* (the same, without the schedule times) · *Design's fixed 15
steps* ("All 15 design steps for every ticket. Oiler-only steps show 'N/A' for other roles, and
fields with no data show '—'.")

In short:

- **The design showed a fixed 15-step flow. The view follows the real one:** 14 steps for an
  Oiler, 9 for every other role.
- **The schedule's on-site and estimated-end times are display only**, shown beside the actuals.
  No late-arrival or overrun flag, no variance colouring.
- **Left out because nothing captures it:** odometer, ETA/distance, geofence, per-step GPS, live map.

## Why

- **The real flow is what the captures describe.** `RAW_STEPS` in
  `apps/mobile/data/mock/fixtures.ts` holds 14 step keys, and `getVisibleSteps` in
  `apps/mobile/data/compose-ticket-detail.ts` removes five Oiler-only ones (`pretrip`, `jsa`,
  `posttrip`, `compliance`, `labor`) for everyone else — checked 2026-09-11 at `25185b04f`. The
  15-step alternative would show steps a role never has and fields nothing records.
- **The design's 15 steps match the 2026-06 prototype**, which hard-codes a 15-step `STEPS` array
  (`field-ops/field-app-demo-2026-06.md` §1 — unverified) and records itself as contradicting the
  written sources (§9 of the same file). The shipped app follows neither.
- GPS exists only on `TicketSignature` rows (intent Appendix B), so per-step GPS has nothing to read.

## What is weak about this attribution

- **The decider of record is Syed Haris**, named and dated; binding on the build. Developer/owner,
  not TCG's dispatch owner. **Lisette Anzaldo should ratify it.**
- **This decides the view, not the field flow.** The field-ops specs are an open three-way conflict
  (`field-ops/field-ops-mobile-INDEX.md`, none verified), and one candidate asks for what this view
  leaves out: *"Applicable ETA information is available to Dispatch"* and *"supports the configured
  job-site geofence for arrival detection"*
  (`field-ops/atom-mobile-app-user-stories/02-ticket-assignment-and-pre-trip.md`:110, :112).
- **The step order is read from a mock fixture** — the only ordered list there is (intent
  Appendix A).

## What this does NOT settle

- Whether odometer, ETA/distance, geofence, per-step GPS or a live map should ever be captured —
  a field-ops question. ETA and transit are separately deferred for the DAS map
  (`decisions/2026-09-10-das-map-transit-path-and-eta-deferred.md` — "Brian's call").
- Whether late arrival or overrun should ever be flagged against the schedule.
- Which schedule times a shift-2 ticket shows. D3 uses the second-shift end for *Incomplete*; D2
  does not say.
- Which `startWork` the timeline shows. The key means both the card punch-in before Left Yard and
  the Start Build Up screen (intent Appendix A).
- How each step's state is derived — see
  `decisions/2026-09-11-progress-tracking-ticket-status-rules.md`.

## Effect on the vault

- **No vault body edited, no frontmatter flipped.** The field-ops conflict is **not** resolved:
  this note picks no winner among FR-TCG-FOP-001, FR-TCG-FOP-002 and the ATOM stories.
- **`projects-jobs/INDEX.md` → *Decisions that bind this module* gained a line for this note**, on
  explicit instruction and outside `tcg-scrum`'s normal write scope.

---
title: DAS Map View replaces the full three-panel board, not the centre panel alone — decision
source: decision/Akif Farooq
decided: 2026-09-10
decided_by: >-
  Akif Farooq (m.akif.farooq@gmail.com) — developer on `scrum-252`, deciding after the
  2026-09-09 code review of that branch found the shipped behaviour contradicts the only
  written acceptance criterion. He is not the client-side product owner, and the question
  this answers nominates Lisette Anzaldo (Dispatch Manager, the actual user of the board).
  Recorded `status: reference` rather than `verified` for that reason — binding on
  implementation now, open to being overruled by TCG. Same basis as
  `2026-09-01-subsistence-not-a-craft-attribute.md` and
  `2026-09-08-artifact-due-date-seeded-from-first-job-day.md`.
status: reference
conflicts_with: []
resolves: aidlc/SCRUM-252/spec.md#q1--does-map-view-replace-the-centre-panel-or-the-whole-board
jira: [SCRUM-252]
tags: [module/dispatch, kind/decision, das, map-view, vehicle-tracking]
---

# DAS Map View replaces the full board

Settles **where the map is drawn** on the DAS screen, and nothing else about it.

## Decision

1. **Turning Map View on replaces all three DAS panels** — Assets (left), Jobs (centre),
   Employees (right) — with one full-width map plus its detail sidebar. Turning it off
   restores the three-panel board unchanged.
2. **It stays a header toggle on the existing DAS route.** It does not become a separate
   page, a separate URL, or a kiosk/wall-display mode.

This is a **deliberate overrule** of acceptance criterion 1 of
[`../dispatch/daily-allocation-system.md`](../dispatch/daily-allocation-system.md) →
*USER STORY : Live Asset Map View* (`status: unverified`, updated 2026-04-30), which reads:

> A Map View toggle in the DAS header switches the **centre panel** from job list to an
> interactive map

The toggle-in-the-header half of that criterion is honoured. The centre-panel half is not.

## Why

**The centre panel is too narrow for a map to do its job.** The DAS board is specified at
3440 × 1440 ([daily-allocation-system.md](../dispatch/daily-allocation-system.md) →
*USER STORY : Three-Panel Daily Allocation Screen \[ 3440 x 1440\]*), so the centre panel is
roughly a third of the width, and it must also hold the detail sidebar the same user story
demands (*"Clicking an icon opens a detail sidebar"*). A map with a sidebar inside one third
of the board leaves a map pane too small to show two job sites and the units travelling
between them at a useful zoom — which is the one question the screen exists to answer
(*"visually monitor equipment ... without making calls"*).

**The demo the criterion was written from reads as a full-screen swap.** The 2026-04-02
Figma walkthrough is the origin of this user story;
[`../meetings/transcripts/2026-04-02-dispatch-scheduling-figma-demo.md`](../meetings/transcripts/2026-04-02-dispatch-scheduling-figma-demo.md):79,
`ehtesham.anwar` demonstrating to Lisette Anzaldo:

> We have added a map view switcher. What this is going to do is it's going to **open up a
> map view** where uh dispatch manager is going to see all of the assets that are in the
> field and their locations and their details. For any particular date. ... And all you have
> to do to look at at jobs itself, you have to just **turn this map view off and you will be
> back in your jobs view**.

"Open up a map view" and "back in your jobs view" describe a mode swap, not a panel swap.
The transcript is **evidence, not a commitment** — it is CodingCops narrating a prototype —
but it is the same session the written criterion was drawn from, and it does not support the
narrower reading the criterion ended up with.

### The case against

The acceptance criterion is unambiguous and it is the **only** written specification of this
feature. Overruling the sole source on a usability argument is exactly the move that
`CLAUDE.md` warns about — *a rule can never make a requirement true* — and the same
transcript that supports a full-screen swap also says *"Rest rest of the allocation is for
now in the table"*, which is at least compatible with the panels surviving.

Two things make the overrule the better call anyway. The criterion is `unverified` and four
months old. And the same user story carries a second criterion — *"KPI counters remain
visible at the top in map view"* — which DAS does not render at all today (`DasSummary` is
accepted as a prop and used nowhere), so the story already describes a screen that was never
built as written. Treating it as a faithful record of a commitment would fail on that
criterion first.

**This decision is reversible in one file.** `showMap` is read in
`apps/web/src/features/das/views/das-view.tsx`; narrowing it back to the centre panel is a
JSX change, not an architectural one. If Lisette wants the panels back, it is cheap.

## What this does not settle

- **Whether a wall-display / big-screen variant should exist.** Brian Petros described the
  dispatch room's wall screen on 2026-04-09
  ([`../meetings/transcripts/2026-04-09-dispatch-scheduling-figma-demo.md`](../meetings/transcripts/2026-04-09-dispatch-scheduling-figma-demo.md):79)
  — and notably said the wall already carries **Samsara's own map** (*"they have Samsara map
  up on the on the screen on the wall"*), that the DAS board itself is *"too much
  information"* for a wall the operators walk past, and at :83 that *"you'd have this on your
  monitor ... on the screen I only have the tracker. It's a separate tracker."* So the wall
  display is, in his description, **already a separate product**. **Decided for this ticket:
  no wall-display route** —
  [`2026-09-10-no-wall-display-variant-in-scrum-252.md`](2026-09-10-no-wall-display-variant-in-scrum-252.md),
  on the ground that a wall display is a visibility-policy question, not a layout one.
  Whether TCG wants one at all is still open, as a new ticket.
- **Whether the map belongs on the Yard Operations / Dylen dashboard**, which mounts the same
  panel. **Decided: yes, same panel** —
  [`2026-09-10-map-view-ships-on-the-yard-operations-dashboard.md`](2026-09-10-map-view-ships-on-the-yard-operations-dashboard.md),
  which records that it is decided **against** the written record and needs Dylan's sign-off.
- **What the detail sidebar must contain.** Still open —
  [`../dispatch/gaps.md`](../dispatch/gaps.md) → *DAS map detail sidebar — what a unit's
  "resources" must list is unwritten*.
- **Whether clicking a marker should open the sidebar directly.** AC 4 says click opens the
  sidebar; the branch opens a hover card with a *View Details* link into the sidebar.
  **Decided: the hover card stays** —
  [`2026-09-10-das-map-marker-click-opens-the-hover-card.md`](2026-09-10-das-map-marker-click-opens-the-hover-card.md).

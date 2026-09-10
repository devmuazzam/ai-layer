---
title: Map View ships on the Yard Operations / Dylen dashboard, same panel as DAS — decision
source: decision/Akif Farooq
decided: 2026-09-10
decided_by: >-
  Akif Farooq (m.akif.farooq@gmail.com) — developer on `scrum-252`, deciding after the
  2026-09-09 review flagged the Yard Operations mount as shipping with no requirement behind
  it. The question this answers nominates Dylan Masterson (yard dashboard) with Brian Petros.
  Neither was consulted. Recorded `status: reference` for that reason — binding on
  implementation now, and **specifically expected to be checked with Dylan**. Same basis as
  `2026-09-08-artifact-due-date-seeded-from-first-job-day.md`.
status: reference
conflicts_with: []
resolves: dispatch/gaps.md#das-map-panel-is-also-mounted-on-the-yard-operations--dylen-dashboard--written-for-das-only
jira: [SCRUM-252]
tags: [module/dispatch, module/assets, kind/decision, das, yard-operations, map-view]
---

# The Yard Operations dashboard gets the Map View toggle

## Decision

**Yes — the Yard Operations / Dylen dashboard keeps the Map View toggle, and it is the same
map as the DAS board's**: the identical `DasMapPanel`, same assets, same date scope, same
detail sidebar. Not a yard-scoped variant.

## Why

The stated ground is **that the two screens are one workflow**: the Yard Operations board is
driven by the same sub-jobs, the same day's allocations and the same `dasStage` values as the
DAS board, so a map of where those units are is the same map either way. Splitting it into a
yard-scoped variant would mean maintaining two answers to "where is unit 104", which is the
divergence this ticket has already had to fix once in the job-stage badge.

The cost side is small and reversible. The mount is one import and one switch
(`dylen-dashboard-header-slot.tsx`, `dylen-dashboard-view.tsx`); the panel is shared, not
copied, so it cannot drift from the DAS one; and if Dylan does not want it, removing the
toggle is a minutes-long change that touches no shared code.

### The case against — and it is not weak

**Nothing written asks for this, and the one document that specifies Dylan's dashboard
excludes it by omission.** [`../assets/tool-and-rigging.md`](../assets/tool-and-rigging.md) →
*EPIC 2 / Story 5 : Dylan's Yard Dashboard* (`status: unverified`, updated 2026-05-26) is the
only written specification of that screen — nine acceptance criteria, a left jobs panel, a
right tools/rigging panel, a date picker, live tool counters — and **not one mentions a map, a
location, or an asset position**. [`../dispatch/yard-operations-jz.md`](../dispatch/yard-operations-jz.md)
is a loadout punch list with no map item. The Live Asset Map View story is voiced *"As a
Dispatch Manager"* and puts the toggle *"in the DAS header"*.

The two stories have **different actors and different jobs to be done**: a Dispatch Manager
monitoring field equipment across any date, versus a Yard Manager running a loading operation
from one screen. Dylan's work happens before a crane leaves and after it returns; a map of
trucks already out on the road is arguably not his problem at all. The only supporting record
is a 2026-05-12 Figma exchange where Brian asked what a map on Dylan's board would do and was
told it would be *"the same view that we are going to show Dispatch"* — CodingCops answering
its own demo question, not a TCG commitment.

**So this decision is made on a workflow argument, not on the written record, and the written
record leans the other way.** It is recorded here rather than left silent precisely so that
Dylan can be shown it and say no. A toggle he ignores costs him nothing; a toggle nobody ever
told him about is how a screen quietly grows features its owner never wanted.

## What this does not settle

- **Whether the map should be scoped to the yard** rather than showing the whole day's
  allocated fleet, if Dylan keeps it. Not decided; nobody has stated a scope for his view.
- **Whether Dylan's board needs its own KPI or counter row in map view.** Same gap as DAS —
  AC 6 of the map story asks for counters neither board renders today.
- **The Yard Operations status bucket set**, which stays open —
  [`../dispatch/gaps.md`](../dispatch/gaps.md) → *DAS map job status buckets*.

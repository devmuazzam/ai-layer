---
title: DAS map ships one generic asset marker; crane-specific icons are deferred — decision
source: decision/Akif Farooq
decided: 2026-09-10
decided_by: >-
  Akif Farooq (m.akif.farooq@gmail.com) — developer on `scrum-252`, deciding after the
  2026-09-09 review flagged acceptance criterion 2 as unmet. The reviewer marked this
  question answerable by "either" side, since the written record already calls the current
  icon a placeholder. Recorded `status: reference`: binding on implementation now, open to
  being overruled by TCG.
status: reference
conflicts_with: []
resolves: aidlc/SCRUM-252/spec.md#q2--are-crane-specific-icons-required-for-this-ticket
jira: [SCRUM-252]
tags: [module/dispatch, module/assets, kind/decision, das, map-view, vehicle-tracking]
---

# One generic marker now; crane-specific icons are a later ticket

## Decision

**SCRUM-252 ships a single generic truck marker for every asset on the DAS map.**
Crane-specific icons are **deferred to their own ticket**, not dropped.

Acceptance criterion 2 of
[`../dispatch/daily-allocation-system.md`](../dispatch/daily-allocation-system.md) →
*USER STORY : Live Asset Map View* — *"Assets are shown as crane-specific icons"* — is
therefore **knowingly unmet in this ticket**, recorded here so the next reader does not file
it as a defect.

## Why

**The written record already calls the current icon a placeholder, in the same breath as the
requirement.** The user story's phrasing comes from the 2026-04-02 Figma walkthrough,
[`../meetings/transcripts/2026-04-02-dispatch-scheduling-figma-demo.md`](../meetings/transcripts/2026-04-02-dispatch-scheduling-figma-demo.md):79:

> For the map view itself. This is going to be our map view. **We are going to have icons
> according to the crane. So for cranes we are going to change the icon into a crane icon.
> For now we have just added the track icons** [truck icons] and on hover of any of these
> icon you can see. The details of that asset itself, what is the job?

So the placeholder was demonstrated *as* a placeholder and the criterion was written from the
promise beside it. Shipping the placeholder is the state the demo was in; it is not a
regression from anything.

**Two inputs the icon work needs do not exist.**

1. **No artwork.** No crane icon set exists in `apps/web` — the marker is
   `TruckMarker` in `apps/web/src/features/vehicle-tracking/components/map/`, and there is no
   icon family to draw from. This is a design task nobody has been given.
2. **No mapping.** Nothing anywhere says *which* asset maps to *which* icon. The map's
   `assetType` is `asset.subCategory.name`, a free-text tenant-owned value, so the mapping
   would have to be from sub-category → icon and the sub-category set is per-tenant and
   grows. That is a product question (what icon families exist: truck crane / crawler /
   boom truck / support truck / …?) with no written answer.

Blocking a working live map on missing artwork and an unwritten mapping trades a shipped
capability for a cosmetic one.

### The case against

The criterion is explicit and it is one of only seven. A dispatcher scanning a map of
fifteen identical truck icons cannot tell a 22-ton from a 360-ton at a glance, which is
plausibly part of *"visually monitor equipment"* — and Lisette's stated interest in seeing
crane size is on the record elsewhere: the 2026-04-21 demo has her saying the job layout that
shows **required crane size** is the one that helps her
([`../dispatch/gaps.md`](../dispatch/gaps.md) → *Jobs panel views*). So icon-by-crane-type is
not decoration to her.

Two mitigations make deferral acceptable rather than merely convenient: **the asset's unit
code is rendered on the marker itself** (`use-das-map-vehicles.ts` names each vehicle after
`assetCode`, not Samsara's own label), and the hover card and sidebar both carry `assetType`
in text. So crane identity is available on the screen today — it is one hover away instead of
zero.

## What this does not settle

- **Which icon families exist, and what maps to each.** Unwritten. Needs a design set and a
  sub-category → icon mapping before the follow-up ticket can be specified at all.
- **Whether the marker should encode anything else** — crane capacity, job stage, shift.
  Nothing written. The stage is currently a badge in the sidebar and hover card, not on the
  marker.
- **The selected-marker treatment on the shipped fleet-tracking map**, which this branch
  changed as a side effect. Separate and still open —
  [`../assets/gaps.md`](../assets/gaps.md) → *Fleet tracking map — how a selected vehicle
  must be indicated is written nowhere*.

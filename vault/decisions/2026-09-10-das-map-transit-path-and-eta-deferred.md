---
title: Transit path and ETA are deferred out of SCRUM-252 — decision
source: decision/Akif Farooq
decided: 2026-09-10
decided_by: >-
  Akif Farooq (m.akif.farooq@gmail.com) — developer on `scrum-252`. The question this answers
  nominates Brian Petros, who owns the Samsara scope question it hangs off; he was not
  consulted. Recorded `status: reference` — it defers the work out of this ticket and binds
  nothing beyond it. **Whether TCG wants transit paths and ETAs at all remains Brian's call.**
status: reference
conflicts_with: []
resolves: aidlc/SCRUM-252/spec.md#q3--does-transit-path--eta-ship-in-scrum-252-or-is-it-deferred
jira: [SCRUM-252]
tags: [module/dispatch, module/assets, kind/decision, das, map-view, samsara]
---

# Transit path and ETA: out of SCRUM-252, not off the roadmap

## Decision

**SCRUM-252 ships without transit paths and without estimated arrival times.** Acceptance
criterion 5 of [`../dispatch/daily-allocation-system.md`](../dispatch/daily-allocation-system.md)
→ *USER STORY : Live Asset Map View* — *"If an asset is in transit, its path and estimated
arrival time are displayed"* — is **knowingly unmet**, recorded here so it is not filed as a
defect.

This defers the work. It does **not** decide that TCG should never have it.

## Why

**The criterion states an outcome and names no mechanism, and the mechanism does not exist.**

An ETA needs three things. Samsara supplies one of them:

1. **Where the vehicle is** — Samsara gives this, and it is what the map already draws.
2. **Where it is going** — *missing*. The map payload carries `jobSite` as a **name string**
   (`asset.jobSite.name`), not coordinates. There is no lat/lng for a job site anywhere in
   this feed, so there is no destination to route toward.
3. **A route between them** — *missing*. This means a routing provider (Google Directions or
   equivalent): a new external dependency, a new API key, a new per-request cost, and a new
   failure mode on a screen that currently degrades gracefully because it only ever reads
   positions.

None of those three is named in any source. Building them would mean choosing a provider and
committing spend on the strength of one `unverified` acceptance criterion.

**And the cheap version is worse than nothing.** Straight-line distance divided by an assumed
speed produces a number that looks authoritative and is wrong on every route with traffic, a
grade, or a permit-restricted detour — which for a crane is most of them. A dispatcher would
act on it. An absent ETA makes her phone the operator, which is what she does today; a wrong
ETA makes her not phone him.

### The case against

The criterion is explicit, it is one of only seven, and *"visually monitor equipment ...
**without making calls**"* is the user story's own stated purpose — which an ETA serves more
directly than anything else on the screen. Deferring it means the ticket delivers the
monitoring half of that promise and not the anticipation half.

Two things make the deferral defensible rather than merely convenient. The map ships useful
without it: live position, job, customer, site, shift times, crew and stage are all on screen,
and none of them depended on routing. And the missing pieces are **additive** — job-site
coordinates and a routing call can be added to this exact payload and this exact panel later,
with no rework of what shipped.

## What this does not settle — and what a follow-up ticket needs first

- **Whether TCG buys routing at all.** Brian Petros's call. This is the DAS half of
  [`../assets/gaps.md`](../assets/gaps.md) → *Samsara vehicle tracking — what was committed is
  "vehicle locations in real time"*, which records that **no named person with product
  authority appears anywhere in the record for the whole Samsara module.**
- **Where job-site coordinates come from.** Nothing geocodes a job site today. That is a
  schema and data question, and it blocks the ETA work before the routing question is even
  reached.
- **Whether "in transit" is even a state the system knows.** The map has the vehicle's status
  (`MOVING` / `IDLE` / `OFF`) and the job's stage separately; *"in transit to this job"* is
  neither of them and is not defined anywhere.

---
title: No wall-display variant of the DAS map in SCRUM-252 — decision
source: decision/Akif Farooq
decided: 2026-09-10
decided_by: >-
  Akif Farooq (m.akif.farooq@gmail.com) — developer on `scrum-252`. The question nominates
  Lisette Anzaldo with Brian Petros; neither was consulted. Recorded `status: reference` —
  it scopes this ticket and commits nothing about whether a wall display should ever exist.
status: reference
conflicts_with: []
resolves: aidlc/SCRUM-252/spec.md#q1a--should-a-wall-display--big-screen-variant-exist-as-its-own-route
jira: [SCRUM-252]
tags: [module/dispatch, kind/decision, das, map-view]
---

# No wall-display route in this ticket

## Decision

**SCRUM-252 ships the map as a header toggle on the existing DAS route and nothing else.**
No kiosk mode, no separate URL, no auto-refreshing big-screen variant.

If TCG wants a wall display later it is a **new ticket**, because it is a different product
with different requirements — not a size variant of this screen.

## Why

**Brian Petros's own description says the wall already has one, and that it is not this
screen.** [`../meetings/transcripts/2026-04-09-dispatch-scheduling-figma-demo.md`](../meetings/transcripts/2026-04-09-dispatch-scheduling-figma-demo.md):79,
in the dispatch room:

> They had Sam's. I went in there today looking for Lisette and **they have Samsara map up on
> the on the screen on the wall.** I just thought I'd throw that out there.

and at :83:

> I don't know if you have this on the big screen. **You'd have this on your monitor, right?**
> And then on the screen, I'm not sure what you on the screen. **I only have the tracker. It's
> a separate tracker that tracks every piece of equipment on the wall.** Yeah, but then this
> would be on your monitor.

So in his account the wall display is **already solved, by Samsara's own app**, and the thing
being designed goes on the dispatcher's monitor. Building a second wall map would be
replacing a working tool, which is a decision nobody has asked for.

**He also gives a reason the DAS board specifically should not go on that wall** — same line,
:79, on who walks past it:

> No, I don't think anybody should see it and we have problems. **When the operators come in
> and out, then they get to see. That's too much information for them.**

A wall display is therefore not a layout exercise. It is a **visibility question** — what may
be shown to whoever is in the room — and it lands on the same unowned ground as
`brs.md` **OD-012** *GPS enforcement behavior* (`❓ Decision Needed`) and the unresolved
question of who may see the Tracking menu at all. Shipping a kiosk route without answering
that would put crew locations on a wall that operators walk past, decided by nobody.

### The case against

A full-screen map with no chrome is close to what this ticket already built, so a kiosk route
would be cheap — and `ehtesham.anwar` at :82 was already sketching a filtered version
(*"on the big screen we can define what what is the information we want to show ... we just
show the assignments"*), which shows the idea had traction in the room.

The answer is that the cheap part is the layout and the expensive part is the policy. Until
somebody says who may see what on that wall, the route should not exist.

## What this does not settle

- **Whether TCG wants a wall display at all**, and whether it would replace the Samsara app
  currently on that screen. Open; owner Lisette Anzaldo with Brian Petros. A new ticket.
- **Who may see live vehicle locations, on any screen.** Unowned and untouched by this ticket
  — `brs.md` OD-012, and `CLAUDE.md` → *Vehicle tracking* on the missing permission layer.
- **The full-board-vs-centre-panel question**, decided separately in
  [`2026-09-10-das-map-replaces-the-full-das-board.md`](2026-09-10-das-map-replaces-the-full-das-board.md).

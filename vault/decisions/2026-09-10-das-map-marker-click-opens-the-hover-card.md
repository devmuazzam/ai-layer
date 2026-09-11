---
title: Clicking a DAS map marker opens the hover card; the sidebar is one link further — decision
source: decision/Akif Farooq
decided: 2026-09-10
decided_by: >-
  Akif Farooq (m.akif.farooq@gmail.com) — developer on `scrum-252`. The question nominates
  Lisette Anzaldo, the dispatcher who uses the board; she was not consulted. Recorded
  `status: reference` — binding on implementation now, and cheap to reverse if she wants the
  sidebar on the first click.
status: reference
conflicts_with: []
resolves: aidlc/SCRUM-252/spec.md#q1b--must-clicking-a-marker-open-the-detail-sidebar-directly
jira: [SCRUM-252]
tags: [module/dispatch, kind/decision, das, map-view]
---

# Click opens the card, not the sidebar

## Decision

**Clicking a truck on the DAS map opens its hover card** — asset code, status, job, customer,
site, shift — **with a *View Details* link that opens the full detail sidebar.** The sidebar
is not opened by the click itself.

Acceptance criterion 4 — *"Clicking an icon opens a detail sidebar with full job and asset
information"* — is therefore satisfied in two steps rather than one, deliberately.

## Why

**The two actions answer two different questions, and the common one should be cheaper.**
Most of what a dispatcher does on this screen is identification: *which unit is that, and what
is it on?* That is the hover card, and it resolves in place without the map reflowing. The
sidebar answers the rarer question — the full crew and equipment set, every shift, the times —
and it costs map width to open.

Binding the expensive answer to the cheap gesture inverts that: every idle click on a marker
would collapse the map to make room for a panel the reader did not ask for, on a screen whose
entire point is seeing where things are relative to each other.

**The hover card is not a lesser view.** It already carries asset code, live status badge, job
stage badge, customer, job site and shift time — which is precisely what AC 3 asks the *hover*
to show, and more.

### The case against

The criterion says *click → sidebar*, plainly, and a two-step path to it is a divergence
dressed as a refinement. There is a real argument that a dispatcher who clicks a truck has
already decided she wants the detail — hover was the identification gesture, and click should
commit. On a touch screen the argument is stronger still, because hover does not exist there
and the card and the click collapse into the same interaction.

That last point is the one that could overturn this. It is untested: nothing records whether
this board is used on a touch device.

## What this does not settle

- **What the detail sidebar must actually contain.** Still unwritten and still open —
  [`../dispatch/gaps.md`](../dispatch/gaps.md) → *DAS map detail sidebar — what a unit's
  "resources" must list is unwritten*. This decision is about the gesture, not the contents.
- **Touch behaviour.** Whether the board is used on a touch screen, and what click should do
  there, is unknown and untested.
- **Selected-marker treatment.** How the open unit is marked on the map is a separate open
  question — [`../assets/gaps.md`](../assets/gaps.md) → *Fleet tracking map*.

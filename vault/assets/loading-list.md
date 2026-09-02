---
title: Dylan's loading list — the loadable tool and rigging catalog, in load order
source: client-message/Dylan via Melissa McNutt — image supplied 2026-08-31
migrated: 2026-08-31
updated: 2026-08-31
status: unverified
conflicts_with: []
jira: []
tags: [module/assets, module/dispatch, module/field-ops, kind/reference, tools-rigging, loading, yards]
entities: [tool-rigging, asset, unit, job, yard, employee]
---

# Dylan's loading list

Image: [assets/2026-08-31_dylan-loading-list.png](assets/2026-08-31_dylan-loading-list.png).

The first named catalog we hold of what the yard actually loads onto a crane.
[tool-and-rigging.md](tool-and-rigging.md) describes the *feature* — the loading screen,
the Needs Spotter badge, Dylan's yard dashboard — but never says which items exist. This
does.

**Two constraints came with it, both from Dylan, and both change the model.**

> *"Here are other items that are permanently assigned to each crane that remain on each
> crane… and those items are not on this list. This list just contains additional items
> that can be loaded."*

So tools split into **two populations**: a permanent per-crane kit that travels with the
unit and is never picked, and this pick-list of additions chosen per job. **We hold only
the second.** The permanent kit per crane is unknown and unasked — see
[gaps.md](gaps.md).

And the title is not decoration: **"LOADING LIST (IN ORDER)"**. The `Order` column is the
sequence the yard loads in, 1 → 26. It is not alphabetical, not grouped by type, and not
by size — heavy bars first, bins and the hopper last. Any loading screen that sorts this
list by name or by category is showing the yard crew the wrong thing.

---

## The list

| # | Qty | Item | | # | Qty | Item |
| ---: | ---: | --- | --- | ---: | ---: | --- |
| 1 | 3 | 10K Bar | | 14 | 2 | Jensen Lifter Sets |
| 2 | 1 | 20K Bar | | 15 | 2 | Container Hooks (Set of 4) |
| 3 | 1 | 25K Bar | | 16 | 16 | Triangle Shackles |
| 4 | 2 | Small Husky Bar | | 17 | 8 | 3T Crosby Hooks |
| 5 | 3 | Large Husky Bar | | 18 | 2 | 5T Crosby Hooks |
| 6 | **N/A** | Boscaro Bar | | 19 | 1 | Skookum Sets |
| 7 | 2 | Cribbing Racks | | 20 | 2 | Chain Falls |
| 8 | 3 | Wedge Mats | | 21 | 1 | Small Material Bin |
| 9 | 2 | Plywood Stacks | | 22 | 1 | Large Material Bin |
| 10 | 12 | 4x4 Steel Plates | | 23 | 2 | 8x8 Material Bin |
| 11 | 4 | 8x4 Steel Plates | | 24 | 1 | Pallet Lifter |
| 12 | 4 | 10x6 Steel Plates | | 25 | 1 | Hopper |
| 13 | 2 | 8x6 Steel Plates | | 26 | 2 | Mandrill |

26 line items, 78 physical pieces where a quantity is given.

---

## What the list tells us about the data model

**1. Quantity is per-item and finite.** Every row but one carries a count, and the counts
are small and specific — 16 triangle shackles, 12 4x4 plates, 8 3T Crosby hooks. This is
the inventory the yard dashboard's *"Total / In use / Available"* counters in
[tool-and-rigging.md](tool-and-rigging.md) count against. It is a real constraint: two
jobs on the same day cannot both take all 16 shackles.

**2. `Boscaro Bar` has quantity `N/A`, not a number.** Every other row is countable. Why
this one is not — bulk, consumable, not tracked, or not owned — is unstated. A schema
that types quantity as a required integer cannot represent this row.

**3. Some rows are sets, and the set is the unit.** `Container Hooks (Set of 4)`,
`Jensen Lifter Sets`, `Skookum Sets` — qty 2 means two sets, not two hooks. Loading and
returning happen at set granularity.

**4. Sizes are in the name, not in a field.** `4x4` / `8x4` / `10x6` / `8x6 Steel Plates`
are four separate rows, as are `Small` / `Large Husky Bar` and `Small` / `Large` / `8x8
Material Bin`. Either each is its own tool record, or there is one record with a size
attribute — the list does not say which, and the epic's *"unlimited custom attributes"*
makes both readable.

**5. Some of these items are separately billable at $300/day.** The quote terms name
*"Man Baskets, Material Bins, Hopper, and Pallet Lifters"* as **Special Equipment — $300.00 Per Day
Per Item**, plus trucking. That is rows #21–25 of this list (Small / Large / 8x8 Material Bin,
Pallet Lifter, Hopper). So a pick on the loading screen has a revenue consequence, and the tools &
rigging epic never says so — see
[quotations/quote-terms-and-rate-card.md](../quotations/quote-terms-and-rate-card.md) §3. Which
rows are billable and which are included in the crane rate is not stated by either document.

**6. It cross-checks the Needs Spotter flag.** The epic states *"Light tools such as
Jensen Lifters and chain falls are not checked by default"* — both are on this list at
#14 and #20. So the flag is set per row of this catalog, and the two named exceptions are
the only ones we know the answer for.

---

## Where this sits

- The catalog these items belong in: [tool-and-rigging.md](tool-and-rigging.md) →
  *Story 1, Create and Configure Tool or Rigging Item*
- The screen that consumes it in order: same file → *Story 4, Loading Process*
- The dashboard that counts it: same file → *Story 5, Dylan's Yard Dashboard*
- Loaded against a crane whose own configuration is itself several units:
  [dispatch/crane-configurations.md](../dispatch/crane-configurations.md)
- Yard side: [dispatch/yard-operations-jz.md](../dispatch/yard-operations-jz.md)

Nothing here is adjudicated. The list is a client artifact, not a specification — it says
what exists today, not what the ERP must store.

---
title: Assets — module index
status: reference
kind: index
updated: 2026-08-31
tags: [module/assets, kind/reference]
---

# Assets

Assets, yards-as-records, tools & rigging, categories. Backend usecases: `asset-management, parts, manufacturers, yards, categories`. Organized per [STRUCTURE.md](../STRUCTURE.md).

## Files

| File | Answers | KB |
| --- | --- | --- |
| [user-story-and-tasks.md](user-story-and-tasks.md) | **Only** source for yard management, HubSpot sync, email 2FA. From a personal space — check `provenance_note` | 4.3 |
| [tool-and-rigging.md](tool-and-rigging.md) | Tools & rigging management, incl. the yard dashboard | 3.7 |
| [loading-list.md](loading-list.md) | **Dylan's loadable tool catalog** — 26 items with quantities, in load order; and the permanent per-crane kit it excludes | 4.0 |
| [fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) | **FCC unit data** — 25 schedule types, 71 unit types, the 156-column unit table, and the full 692-object FCC schema inventory | 3.8 |
| [categories-and-sub-categories.md](categories-and-sub-categories.md) | Category/sub-category questions (2 tags — thin) | 0.3 |

## Decisions that bind this module

- [2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md) — Archive replaces delete, app-wide — decision
- [2026-09-01-post-save-navigation-create-goes-to-detail.md](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md) — Create **and** edit both land on the entity's detail page, app-wide; supersedes the create half of 2026-08-20

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

7 meeting files carry `module/assets` — list them:

```
grep -rl 'module/assets' vault/meetings/
```

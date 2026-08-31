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
| [fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) | **FCC unit data** — 25 schedule types, 71 unit types, the 156-column unit table, and the full 692-object FCC schema inventory | 3.8 |
| [categories-and-sub-categories.md](categories-and-sub-categories.md) | Category/sub-category questions (2 tags — thin) | 0.3 |

## Decisions that bind this module

- [2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md) — Archive replaces delete, app-wide — decision

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Meetings

7 meeting files carry `module/assets` — list them:

```
grep -rl 'module/assets' vault/meetings/
```

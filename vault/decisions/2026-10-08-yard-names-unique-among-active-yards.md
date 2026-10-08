---
title: Yard names are unique among active yards; an archived yard's name stays reusable — decision
source: decision/Syed Haris
decided: 2026-10-08
decided_by: Syed Haris (developer on TCG), approved when Akif took TCG-86 to him. This is a CodingCops ruling, not a TCG client confirmation. `status: reference` — binding on the build now, open to being overruled by TCG.
status: reference
conflicts_with: []
resolves: TCG-86 open question "Are yard names supposed to be unique at all?"
jira: []
tags: [module/assets, kind/decision, yards, naming, archive]
entities: [yard, tenant-company]
---

## Decision

**Two active yards in a tenant may not share a name.**

- **Create / edit:** refused when an active yard already has the name — "A yard with this
  name already exists."
- **Restore:** refused when an active yard already has the archived yard's name.
- **Archived names stay reusable.** Creating a yard with the name of an archived one is
  allowed. The yard form has no "restore instead?" popup, unlike the screens on the shared
  archived-name-conflict modal.

The match ignores upper/lower case: `north yard` and `North Yard` are the same name.

Enforced in the service (`ArchivedNameConflictService`), not by a database constraint.
Shipped in TCG-86.

## Why

Yards are picked by name in the asset, loadout and dispatch dropdowns, and quotations look a
yard up by its name (`countQuotationsByYardName`). Two active yards with one name cannot be
told apart there.

## Scope — what this does not decide

- **Other entities' case handling.** Ignoring case here is for yards only; the app-wide
  question is TCG-87.
- **Existing duplicates** are not renamed or merged. They stay until someone renames one.

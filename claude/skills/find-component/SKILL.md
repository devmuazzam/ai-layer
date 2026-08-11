---
name: find-component
description: Search every shared component source in apps/web before creating a new one. Use when adding a button, input, modal, table, card, badge or any UI component, or when asked whether something already exists.
---

The most common defect in this web app is a component that already existed. It happens for
a structural reason: there are **nine directories** under `src/components/` and **three
libraries doing the same job**, so the obvious search misses the biggest one.

## Why the obvious search fails

Older docs say "check `atoms/`, `molecules/`, `organisms/`". Measured against the codebase:

| Directory | Files | Importers | What it is |
| --- | --- | --- | --- |
| `ui/` | 50 | **308** | shadcn — **the most-used source in the app** |
| `molecules/` | 32 | 237 | composites |
| `atoms/` | 29 | 176 | hand-rolled primitives, in subfolders |
| `patterns/` | 7 | 130 | workspace page furniture |
| `templates/` | 27 | 114 | layouts, table shells |
| `base/` | 38 | 55 | **Untitled UI kit** primitives |
| `organisms/` | 13 | 55 | larger sections |
| `foundations/` | 59 | 7 | Untitled UI icons/assets |
| `application/` | 7 | **0** | Untitled UI — dead |

Searching only the atomic tiers misses `ui/`, which has more importers than any of them.

## Search, in this order

```bash
cd apps/web/src

# 1. by name, across every source
grep -ril "<thing>" components/ | sort

# 2. by what it renders — catches different naming
grep -rl "role=\"dialog\"\|<table\|type=\"checkbox\"" components/ | sort

# 3. what already exists at each level
ls components/ui components/base components/atoms/* components/molecules components/patterns

# 4. is a feature already local-hosting one? often the real answer
grep -ril "<thing>" features/*/components/ | head
```

Pass 4 matters: a component built inside a feature is often the one to promote, rather than
writing a tenth variant in `components/`.

## Deciding

- **Exists and fits** → use it.
- **~70% right** → extend it with a variant. `cva` + `cn()` for anything reusable.
- **Genuinely new** → put it where its neighbours already are. **Do not correct the taxonomy
  in passing** — which of the three libraries is canonical is unresolved, and settling it
  inside a feature PR makes the diff unreviewable. Match the module you are in.

## Report what you searched

Say which directories you covered and what you found, so the next person does not repeat it:

```
Searched: ui, base, atoms/*, molecules, organisms, patterns, templates, features/*
Found:    components/ui/badge.tsx — status pill, variant-driven
Decision: extending with a `severity` variant rather than adding a new one
```

If nothing exists, say that explicitly — "searched all nine, nothing" is a useful finding
and it is what stops the next person searching three of them again.

## One thing that is not this skill's job

`application/` has zero importers and is dead. Removing it, and resolving `ui` vs `base` vs
`atoms`, belong to the module-by-module revamp — not to whatever feature you are building.

# Web context — `apps/web/`

Next.js 16 (App Router) + Tailwind v4.

## How this app is actually organised

**Feature-first.** `src/features/` holds ~656 `.tsx` — more than twice everything in
`src/components/` combined. A feature owns its own slice:

```
src/features/<feature>/
  components/  hooks/  services/  schemas/  views/  workspace/  constants/
```

New work almost always belongs in a feature folder. `src/components/` is the shared
library that features draw from.

**This is not atomic design.** Older documentation described an
atoms → molecules → organisms → templates → pages hierarchy. The codebase has moved on and
that description will mislead you. There are `atoms/`, `molecules/` and `organisms/`
directories, they are real and in use, but they are three of *nine* directories under
`components/` and they are not the primary source of primitives.

## The shared library — five systems, overlapping

| Directory | Files | Imported by | What it is |
| --- | --- | --- | --- |
| `ui/` | 50 | **308** | shadcn primitives. **The most-used base layer in the app** |
| `molecules/` | 32 | 237 | composites — form fields, cards, address blocks |
| `atoms/` | 29 | 176 | hand-rolled primitives, in subfolders (`buttons/`, `inputs/`, `selections/`, …) |
| `patterns/` | 7 | 130 | workspace page furniture — `PageHero`, `SectionCard`, `EntityCard`, `DetailHeader` |
| `templates/` | 27 | 114 | page layouts and table shells (`WorkspaceTable`, `CommonTable`) |
| `base/` | 38 | 55 | **Untitled UI kit** primitives — avatars, badges, buttons, inputs |
| `organisms/` | 13 | 55 | larger composed sections |
| `foundations/` | 59 | 7 | Untitled UI icons and assets |
| `application/` | 7 | **0** | Untitled UI. **Dead — nothing imports it** |

Plus `forms/`, `sidebar/`, and loose guards at the root of `components/`.

**Three libraries do the same job.** A button primitive can plausibly come from `ui/`,
`base/` or `atoms/buttons/`. That is unresolved, not a rule — and it is the single biggest
reason duplicate components keep appearing.

## Before you create a component

Search **all** of `ui/`, `base/`, `atoms/`, `molecules/` and `patterns/`. Searching only
the atomic tiers misses `ui/`, which is where the most-used primitives live.

If something is ~70% right, extend it with a variant rather than forking it. When you do
add a shared component, put it where its neighbours already are — match the module you are
working in rather than trying to correct the taxonomy in passing.

## The layering rule that is actually real

Features may import from anything in `components/`. **Shared components should not import
from `features/`** — that inverts the dependency and couples the library to a feature.

Currently violated in 13 files (11 in `organisms/`, 2 in `molecules/`). Nothing enforces
it: `eslint.config.mjs` has no `import/no-restricted-paths` or `boundaries/*` rule. Existing
violations are not permission.

## Tables — unresolved, flagged not settled

`WorkspaceTable` (~73 files) and `CommonTable` (~13) both exist in `templates/` and are
separate components sharing only leaf helpers. Which one new work should use is **not
settled**. Match the module you are in and raise the question rather than deciding it
silently in a PR.

Either way: enumerate every searchable field in `searchPlaceholder`, and when select
filters can yield zero rows, set an empty-state message that names the filter.

## Colour and theme

Colours come from CSS variables in `src/styles/theme.css`; `src/lib/theme.ts` exposes them
to TypeScript. **No hardcoded colour values** — though several hundred hardcoded hex
utilities exist across the app and lint catches none of them. Existing code is not evidence
of the convention.

## Forms

`react-hook-form` + Zod. Server state is TanStack Query v5; auth state is React context.

On failed submit: scroll to and focus the first invalid field, and on multi-step or tabbed
forms navigate to the offending step first. Validation clears as soon as a field becomes
valid — no second submit.

Whether a top-of-form error summary should render is **contradicted between the older rule
documents** and unresolved. `FormErrorSummary` exists in `organisms/` with zero consumers.
Follow the surrounding module; do not introduce a new pattern either way.

## Misc

Mobile-first Tailwind breakpoints. Touch targets ≥ 44px. Routes are URL-driven: `/create`,
`/<id>`, `/<id>/edit`.

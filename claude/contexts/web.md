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

> **`ATOMIC_DESIGN_SYSTEM.md` at the repo root contradicts this file. Ignore it.** It is a
> ~19 KB guide in the client repo describing the hierarchy above as the app's architecture.
> It is stale, it is not part of this layer, and it is not ours to delete. If you find
> yourself citing it, you are citing an intention rather than the codebase — the counts in
> the table below were measured, and `components/ui` alone has more importers than any
> atomic tier.

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

## Test IDs — `apps/web` is under E2E test

`qa-automation/` is a Playwright suite driving the real app, API and Postgres. It addresses
the UI through `data-testid`, which makes **a test ID a contract, not a debugging aid**.
Rename or delete one and a test breaks — silently: the suite is not yet an Nx project, so no
gate in `.husky/` or `affected.yml` runs it, and nothing will tell you. (Registering it is an
accepted PR #386 follow-up; the grep below is the interim signal, and stays useful after.)

**A new screen or form ships with test IDs on its controls**, whether or not a spec covers
it yet. Retrofitting them later means touching production files a second time, which is how
this convention arrived — as a 45-attribute diff bolted onto eleven existing files.

### Naming — `<module>-<flow>-<element>[-<modifier>]`

Kebab-case throughout, lowercase, no abbreviations the reader has to decode.

| Segment | What it is | Examples |
| --- | --- | --- |
| module | the vault module the screen belongs to | `auth`, `customers` |
| flow | the screen or interaction, not the file | `login`, `forgot`, `reset`, `invite`, `sso`, `change-password`, `user-menu` |
| element | the thing being addressed | `email`, `password`, `submit`, `error`, `success`, `otp` |
| modifier | a second element of the same kind | `-toggle`, `-error`, `-back-to-login` |

So: `auth-login-submit`, `auth-change-password-otp-error`, `auth-reset-password-toggle`.

**What earns one:** every interactive control, and every region a test must assert the
existence of — inputs, submit buttons, links that navigate away, the error banner, the
success banner, invalid/empty states. Not layout wrappers, not decoration.

### A shared component never hardcodes a test ID

It takes the ID from its call site, or two instances on one form collide. `data-testid`
reaches the inner input by spreading; a *second* addressable element needs its own named
prop:

```tsx
export function PasswordInput({ toggleTestId, ...inputProps }: { toggleTestId?: string } & Props) {
  return (
    <div className="relative">
      <Input {...inputProps} />                       {/* data-testid arrives here */}
      <button type="button" data-testid={toggleTestId} … />
    </div>
  );
}
```

`PasswordInput` (`features/auth/components/molecules/`) and `PasswordField`
(`features/settings/views/password-tab-fields.tsx`) are the worked examples — `toggleTestId`,
`errorTestId`.

### Before you rename or remove one

```bash
grep -rn '<the-id>' qa-automation/e2e
```

Updating the spec in the same commit is part of the change, not a follow-up. A screen you
are rewriting keeps its IDs unless the element itself is gone.

## Misc

Mobile-first Tailwind breakpoints. Touch targets ≥ 44px. Routes are URL-driven: `/create`,
`/<id>`, `/<id>/edit`.

## Scope guard

If `.ai/aidlc/SCRUM-###/spec.md` §5 and §6 both read `N/A — backend only` for the ticket a
branch is named for, and the diff touches `apps/web/` or `apps/mobile/`, the push must fail
with an explicit override required (`SCOPE_OVERRIDE=1`), not just a warning. SCRUM-926
shipped ~2,100 lines of web UI against a spec that said backend-only in four separate places
and nothing caught it before merge (`.ai/aidlc/SCRUM-926/reflection.md` ED-5).

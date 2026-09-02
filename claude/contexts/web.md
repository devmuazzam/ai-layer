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

## Dropdowns — a server entity list is never preloaded

**If the options come from an entity table, the picker searches the API. It does not fetch a
list and filter it in the browser.** The old shape —
`<NativeSelect options={hookData.map(...)} />` over a cached React Query list — is what this
rule exists to stop, and it is easy to reintroduce by accident because **`NativeSelect` is
not a native `<select>`**: given `options` and no `htmlSelect`, it renders `SearchableSelect`,
and `Select` from `@/components/atoms` is an alias for it.

Build a `features/<entity>/components/<entity>-select.tsx` on the shape of
`features/vendors/components/vendor-select.tsx`: an `AsyncCombobox` whose `fetchPage` calls
the feature's API service directly, keeping a `Map` of fetched rows so `onChange` can hand
the whole record upstream. It bypasses React Query on purpose — the debounce, the
stale-response guard and the abort all live in `useAsyncComboboxData`. Page size is
`PICKER_PAGE_SIZE` from `lib/searchable-list-query.ts`; do not hardcode one.

### One debounce, and it has to clear a keystroke

`SEARCH_DEBOUNCE_MS` in `lib/searchable-list-query.ts` is **400 ms and is the only one** —
list tables, `SearchBar` and every picker read that constant. Do not declare a local delay.

400 is not arbitrary and is not a comfort margin. A debounce shorter than the gap between
two keystrokes buys nothing at all: at 40 WPM a character lands roughly every 300 ms, so
the pickers' original 250 ms let **every letter through as its own request** — a five-letter
word was five round trips, which is the defect this number exists to prevent. If you are
tempted to lower it, that is the bar it has to clear.

The empty query a panel opens on is not typing, so `useAsyncComboboxData` skips the timer
for it and the panel fills at once.

### A superseded request is aborted, not just ignored

A request-id ref only stops a late response overwriting a newer one — the request itself
still runs to completion and the server still pays for it. So `fetchPage` receives a
`signal` (`AsyncComboboxFetchPageParams`), and the picker service must forward it:

```ts
listPage: async ({ signal, ...params }: PickerPageQuery) =>
  api.get(path, { params, signal });
```

**Destructure the signal off before the rest reaches axios `params`** — spreading it in
serialises it into the query string. `PickerPageQuery` and `Abortable<T>` in
`lib/searchable-list-query.ts` exist so that shape is written once.

An abort is not a failure. `isAbortError` gates the `catch`, because blanking the panel
mid-type is worse than leaving the previous rows up.

Variants that already exist, so you do not need a new component:

- **Settings picklists** — `ReferenceCodeSelect` takes any of the nine reference-code
  services. Pass `valueField="code"` where the record stores the business code.
- **Free-text with history** — `CreatableCombobox` takes an optional `fetchPage`.
- **Cascading resource trees** — `MultiOptionDropdownMenu` takes an optional `fetchSearch`.
- **Rows that must stay visible but unpickable** — `AsyncComboboxOption.disabled`, rather
  than filtering them out of the page. `SubCategorySelect` takes a `disabledIds` map and
  `EmployeeSelect` a `disabledCodes` map, each keyed to the reason shown as the row's
  description; `WorkspaceFilterGroup.render` lets a table filter host a picker instead of a
  `<select>`. This is what replaces a hand-rolled roster list that greyed out its own rows —
  the craft-code assign dialog was one, over a `limit: 200` read.

**Do not re-filter or re-sort a page after it arrives.** Both look harmless and both are
wrong: dropping rows shrinks the page below the `limit` the server sized `hasMore` against,
and sorting only reorders the rows in hand, so a "recommended" row on page 2 still ranks
below a plain one on page 1. Push the filter into the query (`includeArchived`, `status`)
and the order into `orderBy`. `craft-code-select.tsx` carries the worked reasoning.

### `hasMore` comes from the server, except where it cannot

Picker routes (`findPickerList`) answer `hasMore` directly and **no longer return `total`**
— counting the matches on every keystroke doubled the query for a number nothing renders.
Read `result.hasMore`.

Some pickers sit on **admin list routes** instead (`getAssetsList`, `customersService.list`,
`vendorsApi.findAll`, and about a dozen more). Those carry `total` and no `hasMore`, because
their tables page with numbered controls. Those correctly compute
`result.page * result.limit < result.total`. **Check which kind of route you are on before
copying either line** — reading `hasMore` off a response that has none is falsy, and the
list silently stops at page one.

**Known gap:** `loadMore` guards on `isLoading` read from a closure, so a fast scroll can
fire several duplicate page requests before the re-render lands. A ref guard fixes it; it
is not fixed yet.

Any list hook that survives spreads `SEARCHABLE_LIST_QUERY` (`staleTime: 0, gcTime: 0`).
A hook feeding a picker must not set its own `staleTime`.

**A cascading tree is browsed, not scrolled, so it does not paginate.** Give it a
server-capped one-shot read plus an authoritative `fetchSearch`, and let the empty-search
state be deliberately incomplete — `GET /resource-catalog/tree` and `/search` are the
worked pair. Never load the whole table just to render the cascade.

### Multi-select — there is no multi-select picker

`AsyncCombobox` is single-select (`value: string`), and nothing in the app extends it.
`MultiOptionDropdownMenu` is **not** a multi-select despite the name: `selectedId` is one
id, picking closes the menu, and there is no deselect. "Multi-option" describes the tree.

**To pick several of something, repeat a row** — N rows, each an independent
`<entity>-select.tsx`. Vendor associated assets, price-list items, PO line items, quotation
tools and employee secondary crafts all work this way, and it is the sanctioned pattern.
A checkbox list over an entity table (the approval-request approvers) still has to search
and page the server; `approver-list.tsx` is that shape.

**The exemption is countries, states and cities.** They are effectively immutable, every
address field needs them, and they keep their 24 h cache — so `components/molecules/address-fields.tsx`
stays on the preloaded pattern deliberately. Permits use a server-searched `CitySelect`
against the same data; that inconsistency is known and intended, not a migration someone
forgot.

On the API side a picker route is **dual-mode**: with no `search`/`page`/`limit` it returns
the bare array it always did, and with any of them a `{ data, total, page, limit, hasMore }`
page. `utility/picker-list.helpers.ts` implements it. Every such route carries
`@SkipThrottle()` — type-ahead bursts otherwise exhaust the global throttler budget.

`scripts/check-dropdown-preloads.sh` runs on pre-push and makes two checks over `apps/web`:
a list read with a hardcoded `limit:` of 100+, and a call to a reader that takes **no limit
at all** and so returns the whole table (`getAssets(`, `getTools(`, `getCategories(`,
`getSubCategories(`, `useGetEmployeeTypes(`, `useBillingCodeCustomTypesList(`,
`getEligibleApprovers(`). The second check exists because the first cannot see the more
common shape — nine preloaded pickers shipped under a green guard, every one of them
calling an unparameterised reader.

**Every `READERS` pattern stops at the opening paren, never `()`.** An options-bag overload
returns the same whole table as the bare call, and `getAssets\(\)` did not match
`getAssets({ includeArchived: true })` — a tenth preloaded picker sat under the green guard
for exactly that reason. Stopping at `(` still leaves the paged `getCategoriesList(` alone.

It also **warns on allow-list entries that no longer match anything**. A line left behind
after its picker is migrated is a standing exemption for whatever lands at that path next,
which is the same silent-green failure in slower motion. The warning does not fail the push
— a stale line is not a defect in the change being pushed — so clear it when you see it.

If yours is genuinely not a dropdown (a card section, a validation set, a print payload, a
name→id lookup), say so in a comment at the call site and add the path to the matching
allow-list in that script. Adding a new whole-table reader means adding it to `READERS`.

**Not everything that looks preloaded is.** A pool the screen already owns — one vendor's
allocation resources on the DAS board, with their live per-day statuses — is board state,
not a read of an entity table, and there is nothing there to page. Say so at the call site
(`vendor-resource-select.tsx`) so the next reviewer does not re-open it.

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

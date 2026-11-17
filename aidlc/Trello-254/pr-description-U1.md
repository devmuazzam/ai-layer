# feat(mobile): required-field asterisks render red; yard select is searchable (Trello-254, U1)

Base: `staging`. Branch: `feat/trello-254-u1-red-asterisks-yard-search`. Mobile only: no schema, API, shared or web change.

## What changed

- REQ-02. Every sales-surface required label had a literal `*` inside its string, so the mark took the label colour. All 25 sites now pass `Field`'s existing `required` prop, which draws the red `RequiredMark` as a sibling of an unchanged label. Sites: `email/compose` (2), `customers/create` (10), `projects/create` (1), `create-billing-code-sheet` (1), `quote-create-add-custom-type-sheet` (1), `quote-create-add-job-site-sheet` (6), `quote-create-main-info` (3), and `quote-create-additional-info` (`DynamicField`: `<Field label={field.name} required={field.isRequired}>`, the template-literal label is gone).
- REQ-01. The Yard `Select` (`testID="qc-yard"`) on Main Info passes `searchable`, so the search box shows with fewer than 8 yards. The "Search..." box, the "No matches" empty state and the selection handler (`form.yard`, `form.yardUuid`) already exist in `Select` and are unchanged.
- One existing assertion updated: `app/(sales)/quotes/create.resources.test.tsx:485` `getByText('Max Radius (ft) *')` becomes `getByText('Max Radius (ft)')`. No new tests (not requested).

## AI decisions

| # | Decision | Chosen | Source / alternative |
| --- | --- | --- | --- |
| 1 | Asterisk mechanism | `Field required` (sibling `RequiredMark`) | spec D3; `field.tsx` doc comment forbids nesting. Rejected: a coloured `*` inside the label string (breaks `getByText`) |
| 2 | Which fields get a mark | Recolour only; no field gains or loses a mark | spec D3. Web divergences (customer-create address marks, job-site City/Zip unmarked) left as follow-up |
| 3 | Yard search mechanism | `searchable` on the existing `Select`, client-side, name-only | spec D2. Rejected: `AsyncSearchSelect` (a new request path for a list already in memory) |
| 4 | `DynamicField` label | Dropped the local `label` const and passed `field.name` and `field.isRequired` at all five branches | simplest; the const only existed to build the `*` string |
| 5 | Siblings | All 25 sites in one PR. Field-ticket screens already use `required` and are untouched (`git diff --stat` shows nothing under `features/field-ticket`). Other `Select`s keep the 8+ default (REQ-01 ripple) | spec 11c |

Assumed (no source, simplest option): none.

## Pre-commit hook noise

lint-staged runs `eslint --fix` on staged files. It inserted 4 blank lines in the import blocks of `quote-create-add-custom-type-sheet.tsx` (2) and `quote-create-add-job-site-sheet.tsx` (2), and prettier re-wrapped a few `Field` lines. These are not logic. Say if you want them reverted.

## What was checked, and how

Clean worktree at `origin/staging` 774ba9bc6 for the baseline, then the same commands after the change. All with `--skip-nx-cache` and `NODE_OPTIONS=--max-old-space-size=4096`.

| Command | Baseline | After |
| --- | --- | --- |
| `pnpm nx run @tcg/mobile:typecheck` (also builds `@tcg/shared`) | pass | pass |
| `pnpm nx run @tcg/mobile:lint` | 0 errors, 403 warnings | 0 errors, 403 warnings (no new warnings) |
| `pnpm nx run @tcg/mobile:test` (full suite, so every screen test and every `qc-yard` caller ran) | 333 suites, 3350 tests pass | 333 suites, 3350 tests pass |

- `grep -rn 'label="[^"]*\*"' apps/mobile/{app,components,features,design-system}` returns nothing. The `[A-Za-z)] \*['"`<{]` grep returns nothing in source files.
- `grep -rn 'qc-yard' apps/mobile` lists only `quote-create-main-info.tsx` and `features/sales/quote-create.test-helpers.tsx`. Both are covered by the full jest run.
- Rule sources checked: `grep` for the asterisk label patterns over all of `apps/mobile` and the existing `RequiredMark` / `Select searchable` code in `design-system/primitives`; no pricing, date or pay rule is involved.

## Not run

- **Emulator demo not run.** `adb devices` listed no device, and nothing was listening on :3000 (API) or :8081 (Metro), so the app could not be started from this worktree without bringing up a stack that holds real integration credentials. No Send Quote, DocuSign or email action was triggered at any point. Reviewer demo (spec U1): Sales, New Quote, Main Info shows red `*` on Select Customer, Job Site and Yard with plain label text; tapping Yard shows a "Search..." box (type to narrow, clear to restore, nonsense shows "No matches", pick sets `qc-yard`); step 4 with a template that has a required field shows a red mark on it only; New Customer, New Project, Email compose, Create Billing Code, Add Custom Type and Add Job Site sheets show red marks. Do not press Send on the compose screen.
- Not checked visually: that the red is `colors.errFg` as drawn by `RequiredMark` on a real device (it is the existing field-ticket mark).
- `@tcg/web` and `@tcg/api` not run (untouched).
- The edit-mode fallback for a saved yard no longer active (`selectedYardId` falls back to the saved name) is unchanged code, not exercised on a device.

## Least confident about

Visual placement of the mark on the two-column rows (`customers/create` State and City use `style={styles.flex1}`): `RequiredMark` has `alignSelf: 'flex-start'` inside the label row, so the layout should hold, but only the device shows it.

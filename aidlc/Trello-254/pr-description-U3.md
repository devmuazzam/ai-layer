# feat(mobile): quote builder and New Customer scroll to the first invalid field (Trello-254, U3)

Base: `feat/trello-254-u2-zip-validation` (U2's PR is open; retarget to `staging` when the stack merges). Branch: `feat/trello-254-u3-scroll-to-first-error`. Mobile only: no schema, API, shared or web change. 6 files, +149 -38 ignoring whitespace (+403 -292 raw: wrapping the `customers/create.tsx` step bodies in the content `View` re-indents them; review with `git diff -w`), one commit. Commit `f0102809e` (amended 2026-11-17 for Q3; was `ef7cd0bfc`).

## What changed

- REQ-06. A blocked Next or Save on the quote builder (`app/(sales)/quotes/create.tsx`) scrolls to the first error message. The ScrollView content sits in a ref'd `View` inside a `FieldErrorScrollProvider`; `useScrollToFieldError` (from `@/design-system`) scrolls to the topmost registered message. A local counter is bumped in every blocked branch of `next()` and `save()`, in the same handler as `markAttempted` (and the `setStep` that moves `save()` back to an earlier step), so the nodes exist when the effect measures. It is a counter, so a second press with unchanged errors scrolls again. Over-limit blocks stay toast-only and do not bump it.
- The six plain `<Text style={styles.errorText}>` lines (`quote-create-resources.tsx`: item x2, quantity, rate; `quote-create-tools.tsx`: tool, quantity) now render `FieldError`, same text. The unused `errorText` style was removed from both files. Main Info already registers through `Field error`.
- Step 4 (Additional Info): `AdditionalInfoStep` takes `showErrors`; after a blocked Next or Save on that step each unmet required field shows an inline `Required` (and the input's `invalid` border). The set of unmet fields comes from the existing `validateAdditionalInfo` (the same rule that gates Next/Save), keyed by its `fieldKey`; the message clears as soon as the field is filled. The existing toast is kept.
- New Job Site sheet: a local counter bumped on a failed submit is passed to `BottomSheet`'s existing `scrollToErrorSignal`.
- New Customer (`app/(sales)/customers/create.tsx`), Q3 = A (Syed Haris, 2026-11-17): same wiring as the quote builder. A local counter is bumped when Next is blocked by the billing zip (step 1) or the job-site zip (step 2), and in `save()` when it sends the user back to step 1 or 2, in the same handler as the `...ZipAttempted` flags and `setStep`. The two zip errors already render through `Field error`, so they register with no further change. The ScrollView content is wrapped in a ref'd `View` (`scrollBody`, which takes over the `gap: 10` the content container had) inside a `FieldErrorScrollProvider`. A repeat press scrolls again. Blank zips never block, so nothing scrolls.
- `useStepValidation` / `StepBodyShell` from `features/field-ticket` are not imported (D16). `Field`, `field-error-scroll.tsx` and `bottom-sheet.tsx` are untouched. No test added; no existing assertion needed changing.

## AI decisions

| # | Decision | Chosen | Source / alternative |
| --- | --- | --- | --- |
| 1 | Where `gap: 10` lives | Moved from the ScrollView's `contentContainerStyle` to the new content `View` (`styles.scrollBody`) | The container now has one child, so its gap would apply to nothing; this keeps the steps' vertical spacing identical. Simplest |
| 2 | Step 4 error copy | `Required` | spec REQ-06 (ASSUMED, nearest mobile behaviour, `quote-create-add-job-site-sheet.tsx`); developer review in PR |
| 3 | How step 4 finds its unmet fields | Reuse `validateAdditionalInfo(...).fieldKey`, threaded down as a `missingKeys` set; `DynamicField` gets `error` | Avoids a second copy of the required rule (`isFieldMissing` is private to the helpers file; not exported, helpers untouched). Alternative, rejected: export `isFieldMissing` |
| 4 | Step 4 attempted flag | `attemptedSteps` gains member `4`, same as steps 1-3; `showErrors` defaults to `false` on `AdditionalInfoStep` | Mirrors steps 1-3 per spec |
| 5 | `saveDraft()` (header Save Draft) | Its Main Info block also bumps the counter | Assumed. Spec lists `next()` and `save()` only, but it is a blocked Save that already calls `markAttempted(1)` and shows the same Step 1 messages; a block with a visible message and no scroll would be the gap this ticket removes. Its over-limit branches are toast-only: no bump |
| 6 | Step 4 `invalid` border on inputs | Added `invalid={Boolean(error)}` to the step's Input/DateTimePicker (range: both inputs) | Matches Main Info's pattern (`Field error` + `invalid`). Boolean toggle has no `invalid` prop, message only |
| 7 | Over-limit blocks | No bump | spec REQ-06 edges |
| 8 | Sheet counter | Local `useState` in the sheet (not reset on close) | `BottomSheet` effect fires on change and ignores 0; simplest |
| 9 | `FieldError` call sites | `<FieldError error={errors?.x} />` (renders nothing when empty) instead of `errors?.x ? <FieldError .../> : null` | `FieldError` already returns null on no message, as `Field` uses it |
| 10 | `warnText` comment in resources | Reworded "`errorText`'s red" to "the field-error red" because the style it named is removed | Only the dangling reference changed |

Siblings (spec §11c, D17), checked with `grep -rln 'FieldError\|error=' apps/mobile/{app,components}`, `grep -rn 'FieldErrorScroll\|useScrollToFieldError\|scrollToErrorSignal'`:
- Quote builder and New Job Site sheet: applied.
- `projects/create.tsx`: no inline errors (grep: none), no change. `email/compose.tsx`: one inline `Field error` (Cc, line ~240) on a ScrollView screen; the send is gated by a disabled button, so there is no failed-submit press to hang a scroll on. No change.
- Billing Code, Custom Type, Request Changes, Mark Signed, Mark Lost sheets: single-field `BottomSheet`s with a `Field error`; the field is always on screen. No change (D17 names only the first two; the other three are the same shape, found by the grep).
- **`customers/create.tsx`: applied.** D17's premise ("no validation at all") went stale when U2 added inline zip errors that block Next and Save on a ScrollView screen. The owner answered Q3 = A on 2026-11-17, so the scroll is added in this unit (spec D17 and §11c row 6 corrected).
- Other screens on `FieldErrorScrollProvider`: only field-ticket (`StepBodyShell`) and `BottomSheet`, unchanged.

Assumed (no source): decisions 1, 5, 6, 8.

## TCG-219 overlap

`feat/TCG-219-mobile-mob-demob-parity` rewrites `quote-create-resources.tsx` (spec D19; High for U3 only on these lines). U3's change there is four one-line `FieldError` swaps, the import, and removal of the `errorText` style. Whichever merges second rebases; if TCG-219 merges first, re-apply the four swaps (`grep -n 'errorText' apps/mobile/components/sales/quote-create-resources.tsx` must be empty) and re-run demo step 2. TCG-219's owner should be told. `create.tsx` and `quote-create-main-info.tsx` are not touched by TCG-219.

## What was checked, and how

Baseline reused from U2's tip `202cee74c` (stated in `units.md`): mobile typecheck pass (via override), lint 0 errors / 399 warnings, jest 333 suites / 3350 tests.

**Environment caveat (same as U2).** This worktree's `node_modules` are symlinks into the main checkout, so stock `pnpm nx run @tcg/mobile:typecheck` fails with TS2305 on the `@tcg/shared` zip exports. I ran `pnpm nx build @tcg/shared`, then the same compilers/jest with throwaway configs (outside the repo) that map `@tcg/shared` to this worktree's built dist ("override" below). Reviewer: run the stock commands once on a normal clone.

| Command | Result |
| --- | --- |
| `pnpm nx build @tcg/shared` | pass |
| `tsc -p <override>` for `apps/mobile` | pass, 0 errors |
| `pnpm nx run @tcg/mobile:lint --skip-nx-cache` (stock) | pass: 0 errors, 399 warnings (same as U2's tip; none of the 3 warnings in `create.tsx` are new, checked by eslint on the touched files before and after) |
| `jest -c <override>` full `apps/mobile` suite | 333 suites / 3350 tests pass (same counts as baseline). No test changed: the converted messages are asserted nowhere, as spec §11a row 9 said |
| `prettier --check` on the 5 original files; lint-staged on commit | clean |
| Temporary jest probe, written, run and deleted, **not committed** (mocked `View.measureLayout` and `ScrollView.scrollTo`, mock services) | Step 1: blocked Next with nothing filled calls `scrollTo` once (y = topmost node - 80), a second press calls it again. Step 2: blank item row shows "Item is required" and scrolls; press again scrolls again. Step 3: blank tool row shows "Tool is required" and scrolls. Step 4 (Telescopic Boom Lift, required "Max Radius (ft)"): no "Required" before any press; blocked Next shows it and scrolls; again scrolls again; filling the field clears the message and Next passes. Save on step 5 with that field cleared goes back to step 4, shows "Required" and scrolls. New Job Site sheet: submit empty scrolls, again scrolls again |

Rule sources checked: `grep -rn 'FieldErrorScroll\|useScrollToFieldError\|scrollToErrorSignal' apps/mobile/{app,components,features,design-system}` (field-ticket and `bottom-sheet` only, before this unit); `grep -n 'errorText' apps/mobile/components/sales/quote-create-*.tsx` (none left); `grep -rn 'is required' apps/mobile/app/(sales)/quotes --include=*.test.tsx` (Main Info only). No pricing, date or pay rule involved.

## Not run

- **Emulator demo not run.** No device was connected before and nothing listened on :3000 or :8081; the API stack holds real integration credentials and was not started. Reviewer demo (units.md U3 -> Demo 1-6): (1) New quote, Next with Yard/Customer/Job Site empty from a scrolled-down position, scrolls to the topmost message; again scrolls again. (2) Resources: add a row, leave Item blank, Next: "Item is required" in view; Tools: "Tool is required". (3) Additional Info with a long template, required field empty, scroll away, Next or Save: inline "Required" under each unmet field and the first in view. (4) From step 5 break a required step-4 field in the store, Save: lands on step 4 scrolled. (5) "+ Add New" job site, submit empty: scrolls to its first message. (6) Over-limit toasts still just toasts (code review only: those branches have no bump).
- The real `measureLayout`/`scrollTo` on a device (the probe mocked both); the 80 px margin and landing position under the pinned stepper/total bar are unseen.
- Step 2 over a quote with 100 rows, and a nested customer/job-site picker opened from a failed state (it keeps its own `BottomSheet` registry by construction; no probe).
- Stock `nx typecheck` / `jest` on a normal clone (see caveat). `@tcg/web`, `@tcg/api`, `@tcg/shared` tests: untouched, not run.

## Least confident about

The content wrapper `View` (decision 1): moving `gap` off the contentContainer should leave step spacing identical, but only a device shows it. Second: `measureLayout(content, ...)` against the new wrapper on a real device for a deep row (the existing primitives were built for exactly this pairing, but this screen is their first use inside a tall list-style step).

## Q3 follow-up check (customers/create, 2026-11-17)

Re-run after the amend, then on U4's tip after the rebase: `pnpm nx build @tcg/shared --skip-nx-cache` pass; override `tsc` 0 errors; stock `pnpm nx run @tcg/mobile:lint --skip-nx-cache` 0 errors / 399 warnings (same as before); eslint on `customers/create.tsx` clean; full mobile jest (override config) 333 suites / 3350 tests pass on both tips, no test added or changed. Temporary jest probe (deleted, not committed; mocked `View.measureLayout` and `ScrollView.scrollTo`): billing zip `123` + Next scrolls once, a second Next scrolls again, a valid zip advances without scrolling; job-site zip `12` + Next on step 2 scrolls, repeat scrolls again; `save()` with an invalid job-site zip returns to step 2 and scrolls, with an invalid billing zip returns to step 1 and scrolls. The same probe against the pre-change file fails all 3 cases. Emulator not run; real `measureLayout` not exercised.

# feat(mobile): zip codes are validated like web on address forms (Trello-254, U2)

Base: `feat/trello-254-u1-red-asterisks-yard-search` (U1's PR is open; retarget to `staging` when U1 merges). Branch: `feat/trello-254-u2-zip-validation`. No schema, API or migration. Touches mobile, one new `packages/shared` file, and one web file reduced to a re-export.

## What changed

- REQ-07. The New Job Site sheet (`qc-add-site-zip`) and both zip inputs on New Customer (billing `cc-zip`, job site `cc-site-zip`) now run `sanitizeZipCodeInput` as you type (digits only, hyphen after the 5th, `maxLength` 10, `number-pad` kept). A non-empty value that is not `12345` or `12345-6789` shows `US_ZIP_ERROR` under the field through `Field`'s `error` prop and blocks. Required-ness is unchanged (D5): the sheet's blank zip still shows "Required"; blank passes on New Customer.
- Sheet: format checked on submit (`touched`); the error clears as soon as the value is valid (derived from state, not stored).
- New Customer: billing zip blocks Next on step 1, job-site zip blocks Next on step 2, both block Save. Error shows after the first blocked press, per field, and clears as soon as the value is valid.
- D4: `isValidUsZipCode`, `sanitizeZipCodeInput`, `US_ZIP_ERROR` moved verbatim to `packages/shared/src/utils/zipcode.ts` (exported from `utils/index.ts`, no zod). `apps/web/src/lib/zipcode.ts` re-exports them under the same names and keeps `optionalZipCodeSchema` / `requiredZipCodeSchema`. `lib/zipcode-input.ts` and the 7 other web importers are untouched. No web behaviour change.
- No test added or edited (not requested). No existing assertion needed changing.

## AI decisions

| # | Decision | Chosen | Source / alternative |
| --- | --- | --- | --- |
| 1 | Helper location | Shared file + web re-export | spec D4 (carried: developer review). Fallback if rejected: mobile-local `apps/mobile/lib/zipcode.ts`, drop the shared and web edits |
| 2 | Where sanitising sits on New Customer | In the screen's `onChangeText` (`patch({ zip: sanitizeZipCodeInput(v) })`), store unchanged | simplest; `customer-create.store.ts` has no validation today and spec estimated it as possible, not required. A restored draft value is not rewritten, it is validated at the next Next/Save (spec §11a row 11) |
| 3 | Error timing, New Customer | Per-field "attempted" flag set when Next/Save is blocked; error shown while flag set and value invalid | spec D6. Per-field so step 2's zip does not show an error before Next is pressed on step 2 |
| 4 | Save with a bad zip on step 3 | Save sets both flags and jumps back to step 1 (billing) or step 2 (job site) to show the message | Assumed. Reachable only from a restored draft (Next on steps 1-2 is already gated), but a block with nothing visible would be worse. Spec says Save is blocked, not what the user sees |
| 5 | Sheet: `keyboardType` | Added `number-pad` (the sheet had none) | spec REQ-07 notes ("keep number-pad ... sanitiser inserts the hyphen"). The sheet's zip had the default keyboard |
| 6 | Sheet: error precedence | `Required` wins for blank; `US_ZIP_ERROR` for non-blank invalid; `invalid` border follows either | spec D5, REQ-07 edges |
| 7 | New `testID`s | `cc-zip`, `cc-site-zip` on the two customer-create zips (neighbours `cc-name`, `cc-email` already use `cc-*`) | simplest; none existed. Nothing in `qa-automation` refers to mobile ids |
| 8 | Places overlap (D19) | Nothing added for `feat/MOBILE-ADDRESS-PLACES`; whoever merges second must route the Places zip through `sanitizeZipCodeInput` (sheet `setZipCode`, customer-create `patch`/`patchJobSite`) | spec D19 / REQ-07 edges; that branch's `onZipCodeChange` setter does not exist here |

Siblings (spec §11c): the three mobile zip inputs are the only ones (`grep -rniE 'zip|postal'` over `apps/mobile/{app,components,features,design-system,lib,data}` returns only these three inputs plus read-only displays and mock/contract data). All three applied. Web zip consumers unchanged by re-export.

Assumed (no source): decisions 4, 5, 7.

## What was checked, and how

Baseline: mobile reused from U1's tip (typecheck pass; 333 suites / 3350 tests; lint 0 errors). Web baseline taken on U1's tip before the first edit: `@tcg/web` typecheck pass, test 1051/1051.

**Environment caveat.** This worktree's `node_modules` (root, `apps/*`) are symlinks to the main checkout, so `@tcg/shared` resolves to the main checkout's `packages/shared/dist`, which does not have the new export. `pnpm nx run @tcg/mobile:typecheck` and `@tcg/web:typecheck` therefore fail here with `TS2305 ... no exported member 'isValidUsZipCode'` even after `pnpm nx build @tcg/shared` (that builds this worktree's dist). I did not touch the main checkout. Instead I ran the same compilers with temp configs outside the repo that map `@tcg/shared` to this worktree's built `dist` (marked "override" below). In a normal checkout or CI the stock commands resolve it correctly; reviewer, please run them once on a normal clone.

| Command | Result |
| --- | --- |
| `pnpm nx build @tcg/shared --skip-nx-cache` | pass; `dist/utils/zipcode.{js,d.ts}` present and exported from `dist/utils/index` |
| `tsc -p <override>` for `apps/mobile` (same tsconfig, paths and `include`, plus `@tcg/shared` -> worktree dist) | pass, 0 errors |
| `tsc -p <override>` for `apps/web` (same) | pass, 0 errors |
| `pnpm nx run @tcg/mobile:typecheck` / `@tcg/web:typecheck` (stock, `--skip-nx-cache`) | **fail in this worktree only**, 6 and 5 TS2305 errors, all `@tcg/shared` missing the new export (stale main-checkout dist), nothing else |
| `jest -c <override mapping @tcg/shared to worktree dist>` full `apps/mobile` suite | 333 suites / 3350 tests pass (same counts as U1's baseline; includes `customers/create.test.tsx` blank Next/Save and `create.main-info.test.tsx:202` typing `90802`) |
| `pnpm nx run @tcg/mobile:lint --skip-nx-cache` | 0 errors, 399 warnings (U1 baseline 403) |
| `pnpm nx run @tcg/web:lint --skip-nx-cache` | 0 errors, 380 warnings |
| `pnpm nx run @tcg/shared:lint` / `:test` | 0 errors (1 existing warning in another file; my two files clean) / 249 of 249 pass |
| web `node --test` (project's list of 137 files) with `@tcg/shared` redirected to worktree dist | 1051 of 1051 pass. No web test file references `zipcode` (`grep -rln zipcode apps/web/src --include=*.mjs` is empty), so this proves no regression elsewhere, not the helpers |
| Behaviour smoke of web re-export (node, redirect) | `sanitizeZipCodeInput('abc123456789')` = `12345-6789`; `12345-` kept; `12345-67`, `11111-` invalid; `90802` valid; `optionalZipCodeSchema` accepts `''`, rejects `12-`; `requiredZipCodeSchema()` rejects `''`, accepts `12345-6789` |
| Temporary jest probes (written, run, deleted; **not committed**) | New Job Site sheet: `abc123456789` shows `12345-6789`, `maxLength` 10; `12345-67` submit shows the web message and the sheet stays; `11111-` shows it; blank shows "Required"; `90802` clears both and creates the site. New Customer: billing `12345-67` + Next shows the message and stays on step 1; clear it and Next passes; job-site `12345-` + Next blocks on step 2; `90802` passes. Restored draft with billing zip `12-` at step 3: Save jumps back and shows the message, no `router.back()` |
| `prettier --check` / `eslint` on the 5 touched files | clean (lint-staged also ran on commit) |

Rule sources checked: `grep -rniE 'zip|postal'` over mobile (three inputs only); `grep -rln "zipcode" apps/web/src` (8 importers, all still compile via override typecheck); no pricing, date or pay rule involved.

## Not run

- **Emulator demo not run.** `adb devices` listed no device and nothing listened on :3000 or :8081; the API stack holds real integration credentials and was not started. Reviewer demo: Sales, New Quote, pick a customer, "+ Add New" job site: type `abc123456789` (shows `12345-6789`); with `12345-67` press Create Job Site (message under Zip, sheet stays); blank shows "Required"; `90802` creates. New Customer: Zip `12345-67` then "Next: Work Order" (message, stays); clear it, Next passes; job-site Zip the same on step 2; Save with both blank still shows "Customer created". Web: open the quick-create customer modal and type `123456789` (shows `12345-6789`).
- Restored-draft path on a device (save a draft with zip `12-`, reopen, press Next) covered only by the temp jest probe.
- Stock `nx typecheck` for web and mobile, and stock `jest`/`node --test` resolving `@tcg/shared` natively, not run to green in this worktree (see caveat above).
- Visual placement of the error text under the two-column Zip fields (customer-create job-site row, sheet City/Zip row): the error sits inside `Field` like every other error, but only a device shows the wrap on a narrow phone.
- `@tcg/api` untouched, not run.

## Least confident about

Decision 4 (Save jumping back to the offending step). It is not in the spec, but it is only reachable from a restored draft. The other likely miss is the stock typecheck in a normal clone: the code compiles against the built dist here, and the shared export is additive, so I expect it to pass.

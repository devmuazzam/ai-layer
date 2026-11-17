# Analysis — Trello-254 U2 (US zip validation on mobile address forms)

Unit reviewed: U2 — US zip validation on mobile address forms (Trello-254), REQ-07
Commit 202cee74c on feat/trello-254-u2-zip-validation, stacked on U1 a5195ec5d. Analysed 2026-11-17, read-only (tcg-analyst).

## Verdict: ship (no must-fix; follow-ups below). One condition: run the stock typecheck once on a normal clone.

## Gates I ran
- `git show 202cee74c^:apps/web/src/lib/zipcode.ts` vs `packages/shared/src/utils/zipcode.ts`, comment-stripped diff of the helper code -> identical (only difference is an extraction artifact of my sed). Plus a differential run of old vs new `sanitizeZipCodeInput` / `isValidUsZipCode` over 1,948,724 strings (all strings up to length 6 over 11 symbols incl. `-`, space, newline, Arabic digits, plus 7 hand cases): 0 mismatches; `US_ZIP_ERROR` strings equal.
- `pnpm nx build @tcg/shared --skip-nx-cache` -> pass (not cached). `dist/utils/index.d.ts` exports zipcode; `dist/utils/zipcode.{js,d.ts}` present.
- `pnpm exec tsc -p <scratchpad>/tsconfig.mobile.json` (apps/mobile, same tsconfig, `@tcg/shared` mapped to this worktree's dist) -> exit 0, 0 errors.
- `pnpm exec tsc -p <scratchpad>/tsconfig.web.json` (apps/web, same override) -> exit 0, 0 errors. All 8 web importers compile.
- `pnpm nx run @tcg/mobile:typecheck --skip-nx-cache` (STOCK) -> fails with exactly 6 TS2305 errors, all "`@tcg/shared` has no exported member isValidUsZipCode / sanitizeZipCodeInput / US_ZIP_ERROR" in the two mobile files. Nothing else fails. Cause below.
- `pnpm exec jest -c <scratchpad>/jest.mobile.json "app/\(sales\)/(customers/create|quotes/create\.main-info)"` -> 2 suites, 12 tests pass.
- Same config, `"app/\(sales\)/quotes/create" components/sales` -> 8 suites, 96 tests pass.
- `pnpm exec eslint` on the 2 mobile files (apps/mobile), `src/lib/zipcode.ts` (apps/web), the 2 shared files (packages/shared) -> exit 0 each, no output. `pnpm exec prettier --check` on all 5 touched files -> clean. `git diff --check 774ba9bc6 HEAD` -> clean.
- Web zod behaviour (node, `@tcg/shared` redirected to worktree dist, importing the real `apps/web/src/lib/zipcode.ts`): `optionalZipCodeSchema` accepts `''`, `undefined`, ` 90802 `, rejects `12345-67` with the web message; `requiredZipCodeSchema('Zip')` rejects `''` ("Please enter zip to proceed."), rejects `11111-`, accepts `12345-6789`.
- Pre-existing failures excluded: none seen. Full mobile (333 suites) and full web (1051) suites NOT re-run by me; executor's numbers for those are INFERRED-from-report.
- Housekeeping note: while smoke-testing I wrote one scratch file into `apps/web/src/lib/` and deleted it immediately; `git status --short` is empty afterwards (VERIFIED). No source, commit or branch was changed.

## Findings (most consequential first)

[VERIFIED] (7) The stock-typecheck failure is a worktree artifact, not a defect of the commit. `ls -la apps/mobile/node_modules` -> symlink to `/home/codingcops/craneguys-platform/apps/mobile/node_modules`; `apps/mobile/node_modules/@tcg/shared -> ../../../../packages/shared`, and `readlink -f` on it resolves to the MAIN checkout's `packages/shared`. `ls /home/codingcops/craneguys-platform/packages/shared/dist/utils/zipcode*` -> no such file (main checkout's dist is stale), while the worktree's dist has it after my build. A normal clone's `pnpm install` makes `@tcg/shared` link to its own `packages/shared`, and `nx typecheck` builds shared first (U1's analysis ran that dependency task). `@tcg/shared` is `workspace:*` in both app package.json files and `main/types` point at `dist`. Nothing in the commit touches package.json, lockfile, tsconfig or paths (`git diff-tree` -> 5 files, none of them config). So I expect stock typecheck to pass on a clone, but I did not run it there (see Not checked).

[VERIFIED] (1) Behaviour parity of the shared helpers: same regex `/^\d{5}(?:-\d{4})?$/u`, same trim in `isValidUsZipCode`, same `sanitizeZipCodeInput` body, same message `Please enter a valid US zip code (e.g. 12345 or 12345-6789)`; established by the comment-stripped diff and the 1.9M-case differential above. Only change is a JSDoc line on `isValidUsZipCode` and the header comment.

[VERIFIED] (2) Web re-export. `git grep -ln "zipcode'" -- apps/web/src` -> 8 files (input.tsx, quick-create-customer-modal.tsx, customer.schema.ts, job-site.schema.ts, create-employee-form.ts, vendor.schema.ts, yard.schema.ts, zipcode-input.ts), none in the diff; web tsc override passes. The zod schemas: `git diff 202cee74c^ 202cee74c -- apps/web/src/lib/zipcode.ts | grep -E '^[-+].*(Schema|z\.|refine|min\()'` -> no lines, i.e. `optionalZipCodeSchema` / `requiredZipCodeSchema` are byte-unchanged; smoke above shows optional/required behaviour as before.

[VERIFIED] (3) Coverage of mobile zip inputs. `grep -rniEl 'zip|postal|postcode' apps/mobile` (excl. node_modules, .expo, ios, android, tests) -> 17 files: 7 contract/mock/service files in `data/`, `nginx.conf` ("gzip"), and the rest in app/components/features: `customers/create.tsx` and the job-site sheet (the 3 inputs, both changed), `customers/[id].tsx:148,181` and `quote-create-main-info.tsx:387,460` (read-only displays), `customer-create.store.ts`, `quotation-address.ts`, `quotation-edit-mapper.ts` (state/mapping, no input). Extra grep `label="(Address|City|State|Street)..."` finds no other address form. No missed input. `grep -rln 'qc-add-site-zip\|cc-zip\|cc-site-zip' qa-automation apps` -> only the touched files, the mobile test and an unrelated web id (`customers-billing-cc-zip`); nothing in `qa-automation` binds the new ids.

[VERIFIED] (4a) Required-ness per D5. Sheet: `zipError = missing.zipCode ? 'Required' : zipFormatInvalid ? US_ZIP_ERROR : undefined`, `isValid` gains `&& !zipFormatInvalid`; blank still "Required", submit payload still `zipCode.trim()`. Customer create: `billingZipInvalid = form.zip.trim() !== '' && !isValidUsZipCode(form.zip)` (same for job site), so blank passes; the existing `customers/create.test.tsx` (blank Next/Save) and `create.main-info.test.tsx:202` pass (jest above). Error is passed via `Field error=` in all three places; sanitise runs in `onChangeText` in all three; `maxLength={10}`; `keyboardType="number-pad"` kept on customer-create and ADDED on the sheet (see unsourced).

[INFERRED] (4b) Save-jump for a bad restored draft is sensible. Read `create.tsx` and `customer-create.store.ts`: `hydrate()` restores `{step, form}` from kv, so a draft can sit on step 3 with a bad zip, and `Save Draft` persists whatever is typed (no gate), so this state is reachable. Steps change only through `next`/`prev` (grep `setStep` -> lines 58, 86, 88, 96 only; no tappable stepper), so Next on steps 1-2 is the only other path and it is gated. Jumping to step 1 (billing) else 2 (job site), with the attempted flags set, shows the message on the field; blocking Save with nothing visible would be worse, as the executor says. This screen has no other invalid-step handling to match (it enforces nothing else, spec REQ-07 notes), so there is no precedent to be inconsistent with. Weak points: no toast says why the step changed (the red message is the only cue); if both zips are bad it goes to step 1 first and the job-site error is already showing when the user reaches step 2. Both are acceptable, neither blocks. Reasoned from reading; not exercised by me on a device (executor's temp jest probe covers it, not re-run by me).

[VERIFIED] (5) API does not validate zip format. `grep -rn zipCode apps/api/src --include=*.dto.ts` -> `job-site.dto.ts:50` and `create-address.dto.ts:38` (and employee/yard optional); spec records `@IsString() @IsNotEmpty() @MaxLength(20)`. Mobile is now stricter than API, as web already is; any valid US zip (<=10 chars) fits `MaxLength(20)`. No API file in the diff.

[VERIFIED] (6) G5 additive only. `git diff 202cee74c^ 202cee74c -- packages/shared/src/utils/index.ts` -> one added `export { isValidUsZipCode, sanitizeZipCodeInput, US_ZIP_ERROR } from './zipcode';`. No removal or rename in shared, no package.json/lockfile change (`git diff --name-only 774ba9bc6..202cee74c -- '*.json' pnpm-lock.yaml` -> empty). No response shape touched, so no contract tracer needed.

[VERIFIED] (8) No new tests and no AI attribution. `git show 202cee74c --stat --format= | grep -ci test` -> 0; `git log -1 --format='%an <%ae>%n%B' 202cee74c | grep -iE 'co-authored|claude|anthropic|generated'` -> no match; author haris <syed.haris@codingcops.com>. Working tree clean.

[VERIFIED] Containment. `git diff-tree --no-commit-id --name-only -r 202cee74c` -> 5 files (2 mobile, 1 web, 2 shared); `git diff --stat a5195ec5d..202cee74c` -> 103 insertions, 48 deletions. units.md estimated 8 files incl. `customer-create.store.ts`; the store is untouched, so the unit is smaller than planned, not larger.

[INFERRED] Hazard list: no tenant model, no migration, no timestamps, no enums, no role/permission surface, no response shape, no web UI markup or test id change (web edit is import-only). Nothing triggered. Reasoned from the diff.

[VERIFIED] No 1k-line crossing: `wc -l` gives customers/create.tsx 664 (623 before) and the sheet 301.

## Unsourced decisions (section 3)
All three are recorded by the executor as Assumed, so nobody is surprised; none traces to a REQ line:
- Save jumps to step 1/2 when a restored draft has a bad zip (`create.tsx:91-97`). Behaviour the user sees; not in spec (spec: "Save is blocked"). Closest to G1 but only reachable from a restored draft; developer reviews in PR.
- `keyboardType="number-pad"` added on the sheet zip (`quote-create-add-job-site-sheet.tsx`). Spec says "keep number-pad", but the sheet had none; it is added, not kept. Reasonable (sanitiser inserts the hyphen) but it is a changed input mode on a field a user could type a non-US value into. Recorded as decision 5.
- New testIDs `cc-zip`, `cc-site-zip` (`create.tsx`). Naming follows `cc-name`, `cc-email`; no consumer. Recorded as decision 7.
Sourced: `maxLength` 10 (REQ-07 notes), error text and format (REQ-07 acceptance), blank handling (D5), error timing (D6), re-export (D4, carried).

## Scope
Complete: yes. Contained: yes. Demo works: not verified (no device, no API, by design). Jest and tsc pass; the demo is what the PR reviewer runs.

## Siblings
Three mobile inputs, all applied. Web consumers unchanged by re-export. The web credit-card zip in `billing-form-sections.tsx` and other web zip inputs do not use `@/lib/zipcode` through this change and are out of scope.

## MOBILE-ADDRESS-PLACES overlap (D19)
[VERIFIED] `git diff 774ba9bc6...feat/MOBILE-ADDRESS-PLACES -- apps/mobile | grep -iE '^[+-].*zip'` shows it: (a) sets zip from a Places pick via `...(picked.zipCode ? { zip: picked.zipCode } : {})` patches (two hits in the diff; file names not confirmed by me; these bypass `onChangeText`, so a picked zip is NOT sanitised), (b) replaces the sheet's `onChangeText={setZipCode}` with `onChangeText={onZipCodeChange}` and `if (patch.zipCode) setZipCode(patch.zipCode)`, (c) edits the job-site zip `onChangeText` to `patchJobSite({ zip: v, ...NO_JOB_SITE_PIN })`. All three lines collide textually with U2's `onChangeText`. Validation (`isValidUsZipCode` on the stored value) is derived from state in U2, so a Places zip is still format-checked at Next/Save/submit; only the sanitising of a picked value would be missing. The PR description (decision 8) already tells the second merger to route those through `sanitizeZipCodeInput`. Conflict is guaranteed; resolution is mechanical. Not this PR's job.

## Maintainability
- 1k-line crossings: none (`wc -l`: customers/create.tsx 664, sheet 301).
- Thermo-nuclear / ponytail: nothing. Two `useState` flags plus two derived booleans in a screen that had no validation is the smallest shape that gives per-step error timing. Note the screen-local logic is ~25 lines; if the Places branch or later work adds more customer-create gates, extract a small `useCustomerZipGate` hook then, not now.

## Follow-ups (out of scope)
- Customer-create is still a design-reference wizard that persists nothing; requiring zip there is D5/§13.
- Optional UX: a short toast when Save sends the user back a step ("Fix the zip code"). Product call, not a defect.
- `units.md` size line (~8 files, includes the store) and U2 ledger text could be corrected to 5 files / +103 -48 (cosmetic; I cannot edit it).
- Sanitise a Places-picked zip (see overlap). Whoever merges second.

## Open questions written to spec.md 12
none

## Not checked
- Emulator/device demo: not run (no device, API not started, no send triggered). Error placement under the two-column zip fields, keyboard behaviour (iOS number pad has no hyphen; ZIP+4 is reached by typing 9 digits and the sanitiser inserts it) and the restored-draft path on a device are unseen.
- STOCK `pnpm nx run @tcg/web:typecheck` and a stock typecheck/jest on a normal clone: not run. I reproduced the mobile stock failure (6 TS2305) and traced it to the symlinked `node_modules`; I did not run web stock typecheck (executor reports 5 TS2305 of the same kind).
- Full mobile jest (333 suites) and full web `node --test` (1051): not re-run; I ran 10 related suites and a smoke of the web re-export. Project-wide `nx lint` for mobile/web/shared not re-run; eslint on touched files only. Web test suite contains no zipcode test (`grep -rln zipcode apps/web/src --include=*.mjs` empty per executor, INFERRED).
- `@tcg/api` untouched, not run.

## Least confident about
That nothing else on a clean clone breaks the stock typecheck. I traced the failure to the symlink and the stale main-checkout dist, and the override compile passes, but the stock command passing is the one thing I could not observe. Second: the Save-jump UX on a device.

## If this breaks in 3 months [INFERRED]
Most likely because a second mobile address form is added (or MOBILE-ADDRESS-PLACES merges) and its zip bypasses `sanitizeZipCodeInput`; nothing in lint or tests enforces it. Mitigation: the Places merger follows PR decision 8.

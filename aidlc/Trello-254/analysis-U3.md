# Analysis — Trello-254 U3 (scroll to the first invalid field on the quote builder)

Unit reviewed: U3 — Scroll to the first invalid field on the quote builder (Trello-254), REQ-06
Commit 59007350e on feat/trello-254-u3-scroll-to-first-error, stacked on U2 202cee74c. Analysed 2026-11-17, read-only (tcg-analyst).

## Verdict: ship with follow-ups. No must-fix. Two conditions: run the stock typecheck once on a normal clone (worktree artifact, as U2); demo on a device (the real `measureLayout` and the landing position are unseen by anyone).

## Gates I ran
- `pnpm exec tsc -p <scratchpad>/tsconfig.mobile.json` (apps/mobile, `@tcg/shared` mapped to this worktree's dist, which already had the U2 zip exports) -> exit 0, 0 errors. Stock `@tcg/mobile:typecheck` not re-run: it fails with TS2305 in this worktree only (symlinked node_modules, see analysis-U2 finding 7).
- `pnpm exec eslint` on the 5 touched files (apps/mobile) -> exit 0, 0 errors, 3 warnings, all `@eslint-react/set-state-in-effect` at `create.tsx:133,143,144`. The diff's first hunk starts at line 193, so none is this unit's.
- `pnpm exec prettier --check` on the 5 files -> clean. `git diff --check 202cee74c 59007350e` -> clean.
- `pnpm exec jest -c <scratchpad>/jest.mobile.json` full apps/mobile -> 333 suites / 3350 tests pass (same counts as baseline). Targeted run first: `"app/\(sales\)/quotes" components/sales design-system/primitives/bottom-sheet design-system/primitives/field` -> 12 suites / 171 tests pass.
- My own temporary jest probe (`app/(sales)/quotes/zz-probe-u3.test.tsx`, mocked `View.prototype.measureLayout` and `ScrollView.prototype.scrollTo`, real screen, real validators, mock services), **deleted afterwards; `git status --short` empty (VERIFIED)**. Results in findings 1, 3 below.
- `git show 59007350e --stat --format= | grep -ci test` -> 0 (no test file touched). `git log -1 --format='%an <%ae>%n%B' 59007350e | grep -iE 'co-authored|claude|anthropic|generated'` -> no match; author haris.
- `git diff-tree --no-commit-id --name-only -r 59007350e | grep -E "field-error-scroll|bottom-sheet|field.tsx|field-ticket"` -> no output. `grep -n "field-ticket"` on create.tsx and the 4 sales components -> no output.
- Pre-existing failures excluded: none seen. Not run: stock nx typecheck/lint/test (cache or symlink caveat), `@tcg/web`, `@tcg/api`, `@tcg/shared` (untouched by this commit).

## Findings (most consequential first)

[VERIFIED] (1) Wiring is right: the measure target is the content `View`, not the ScrollView, and no stale nodes survive a step change. Established by the probe: on step 1 a blocked Next called `measureLayout` 3 times (Customer/Job Site/Yard), all with the same `relativeTo` argument, which is not the ScrollView instance (the instance `scrollTo` was called on) and not one of the measured nodes, so it is the `contentRef` View. Pressing again scrolled again (2 scrolls). After filling Main Info, moving to step 2, adding a blank row and pressing Next, `measureLayout` ran 2 times (that step's messages only; step 1's 3 stale nodes were not measured), and "Customer is required" is gone from the tree. That matches the code: `FieldError` registers through a ref callback that runs its cleanup on unmount (`design-system/primitives/field.tsx` `FieldError`, `field-error-scroll.tsx` `useFieldErrorNode`), so an unmounted step's nodes leave the Set. Coordinates are consistent by reading: the `ScrollView` `contentContainerStyle` (`styles.scroll`, `create.tsx:~801`) has `paddingHorizontal` and `paddingBottom` only, no top padding, so a y measured against the content View equals the ScrollView offset. This is the same pairing `StepBodyShell` uses (`StepBodyShell.tsx:173-210`: ScrollView ref + content View ref + provider inside the View). The 80 px margin and the real landing position under the pinned stepper/total bar were not seen on a device.

[VERIFIED] (2) Counter placement. `grep -n "scrollToFirstError()" "apps/mobile/app/(sales)/quotes/create.tsx"` shows 9 call sites (lines 249,255,271,284,346,353,368,383,421), read against the file: `next()` steps 1, 2, 3, 4; `save()` steps 1, 2, 3, 4; `saveDraft()` step 1. Each sits beside `markAttempted(n)` (and before `setStep(n)` in `save()`/`saveDraft()`), so one batch commits the revealed nodes, the new step and the signal before the effect measures. The four over-limit branches in `next()` and `save()`, the two in `saveDraft()` and the `!online` toast have no bump, as the spec edge says. The probe confirmed the Save-from-step-5 path: after clearing the required step-4 field in the store, Save landed on step 4, rendered "Required" and called `scrollTo` once.

[VERIFIED] (3) Step 4 key match. `additional-info.helpers.ts:215` builds `fieldKey: \`${rws.resource.id}-${section.id}-${field.id}\``; the UI builds `${resourceId}-${section.id}-${field.id}` from `resource.id` of the same `rws` (`ResourceBlock` -> `SectionBlock`), over the same `buildResourceGroups(form.resources, subCategories, ...)` input, so parents and children both match. Probe with the real Telescopic Boom Lift template (required "Max Radius (ft)"): 0 "Required" before any press; blocked Next -> 1 "Required", 1 `measureLayout`, 1 `scrollTo`; typing a value -> 0 "Required"; Next then reaches Attachments. Gate unchanged: `git show 59007350e` shows the only edits in `next()`/`save()` step-4 branches are the two added lines (`markAttempted(4)`, `scrollToFirstError()`); `isAdditionalInfoValid` still `validateAdditionalInfo(...).length === 0`. Drift risk stays: the key shape is a string convention in two files, with only a comment pointing to it (`quote-create-additional-info.tsx:~189`). Not a defect now.

[VERIFIED] (4) No plain error `Text` left that a blocked press can reveal. `grep -rn "errFg\|errorText" components/sales/quote-create-*.tsx "app/(sales)/quotes"` -> only `quote-create-attachments.tsx:61,124` (the rejected-file banner; step 5 has no gate, a blocked press never reveals it), `quote-create-resources.tsx:1078` (`breakdownValueNegative`, a negative number, not an error message). `errorText` no longer appears in the sales folder. The set of messages that block comes from `validateMainInfo` (`Field error`), `validateResources` (item/quantity/rate -> 4 `FieldError` sites) and `validateTools` (toolId/quantity, incl. the catalog-loading and availability messages, which live in `quantity`), and all of those keys have a `FieldError`. `warnText` (amber, non-blocking) is correctly left alone.

[VERIFIED] (5) Layout of the `gap: 10` move. Read: before, the contentContainer held the single step element, with `gap` applying only when a step returns a Fragment with several children (MainInfoStep returns a Fragment of cards, `quote-create-main-info.tsx:126`); after, the new `scrollBody` View holds the same children with the same `gap: 10`. Same direction, width (stretch) and spacing. Provider renders no host node. Only a device shows it exactly (executor says the same).

[VERIFIED] (6) Job-site sheet and other BottomSheet users. `bottom-sheet.tsx`, `field.tsx`, `field-error-scroll.tsx` are not in the diff (command above). `scrollToErrorSignal` is an existing optional prop; `AddJobSiteSheet` passes a local counter bumped in the same handler as `setTouched(true)`, only on `!isValid`. The sheet's state is local and the sheet is mounted by `MainInfoStep`, so a remount starts at 0 and the effect (which ignores 0) does not scroll on open. Every other `BottomSheet` caller passes `undefined`, which the effect ignores. The sheet's nested Country/State row renders inside the sheet's children, so its errors register on the sheet's own registry. Probe did not exercise the sheet; the executor's did, and I did not re-run it (see Not checked).

[VERIFIED] (7) Containment and rules. 5 files (units.md estimated 6), +117 -37. No field-ticket import, no change to `Field`/`field-error-scroll`/`bottom-sheet`, no test file in the commit, no existing test changed, no AI attribution (commands above). `quote-create-resources.tsx` is 1083 -> 1079 lines (`git show 202cee74c:... | wc -l`, `wc -l`): already over 1,000 and shrinking, so no 1k-line crossing. `create.tsx` 844 -> 883.

[INFERRED] (8) Sibling `customers/create.tsx` — D17's premise is stale, and the siblings rule applies. `apps/mobile/app/(sales)/customers/create.tsx:69-91` (read; U2) now has inline zip errors that block Next (steps 1 and 2) and Save (jumps back to step 1/2) on a `ScrollView` screen, with no scroll. D17 and §11c ("no validation at all ... nothing to scroll to") predate U2 and are now wrong for this screen. The executor listed it as a follow-up, which `CLAUDE.md` accepts; I agree it should not grow U3. My judgment: the zip row is a mid-form field on a two-step-per-form screen, so on a small phone the message can sit below the pinned Next button's fold, and Save's jump-back lands on the step top, so the gap is real but small. Recommendation: apply it as a small follow-up (same ~15 lines: counter, two refs, provider, `useScrollToFieldError`, bump in the two blocked branches of `next()` and `save()`), either on U3's PR or its own, and correct §11c row 6 when the owner answers. Raised as Q3 in spec §12 because it is client-facing behaviour nobody specified (G1), non-blocking. Not exercised by me.

[INFERRED] (9) Other siblings. `projects/create`, `email/compose` and the single-field sheets: I did not re-grep; I accept the executor's grep list (`grep -rln 'FieldError\|error=' apps/mobile/{app,components}`) as a lead, not a result. The one I read for the earlier finding is `email/compose` (disabled send button, no failed-press): consistent with the executor's note.

[INFERRED] (10) Attempted flag persists on step 4. `attemptedSteps` gains member 4 and is never cleared, same as steps 1-3. So after one blocked Next, going back to step 2, adding a resource that has a template, and returning to step 4 shows "Required" on its fresh required fields at once, with no press. Same behaviour steps 2/3 already have for a freshly added blank row; consistent, only stated because the owner has not seen it. Reasoned from reading `markAttempted` and `showErrors={attemptedSteps.has(4)}`.

[INFERRED] (11) Weak point if a rule is added later. When `save()` jumps back (`setStep(n)`), the ScrollView offset from the old step persists until the effect scrolls it. If a future blocking rule shows its message without `FieldError`, no node registers, nothing scrolls and the user stays at the old offset. No such case exists today (finding 4, including the tool-catalog loading message, which renders through `quantity`). Reasoned from `useScrollToFieldError` (`nodes.length === 0` returns early).

## Hazard list (section 3b)
Isolation, impersonation, timezone, enum exhaustiveness, migration, contract, test IDs: not triggered. No schema, API, shared, web or response-shape change; the 5 files are all `apps/mobile`. `qa-automation` is web-only and binds no mobile id (no existing id renamed: `git show 59007350e | grep -E "^[-+].*testID"` shows only the DateTimePicker `testID={testID}` line re-wrapped, none removed). Permission gate / roles / registry: no route, no module, no name branch. Business time: no date logic. Unconfirmed x permanent: nothing permanent; presentation only.

## Unsourced decisions (section 3)
All recorded by the executor as Assumed, so nobody is surprised; none traces to a REQ acceptance line:
- `saveDraft()` bumps the scroll signal (decision 5, `create.tsx` Main Info block in `saveDraft`). Spec lists `next()`/`save()` only. Sensible: that branch already shows the Step 1 messages. Developer reviews in PR.
- Step 4 `invalid` red border on inputs (decision 6). Matches Main Info; spec says message only.
- Local sheet counter not reset on close (decision 8): harmless, see finding 6.
- `gap: 10` on the wrapper View (decision 1): see finding 5.
Sourced: step-4 `Required` copy is ASSUMED by REQ-06 itself (carried to PR review); the counter, content View and no-field-ticket rule are D16.

## Scope
Complete: yes (every slice row delivered: create.tsx wiring, six `FieldError` swaps, step 4 `showErrors`, sheet signal). Contained: yes (5 files, nothing from U4, no opportunistic refactor; `scrollToFirstError` repetition is advisory, not a finding). Demo works: not verified by anyone on a device; jest probes pass for steps 1-4, Save-jump-back and repeat press.

## Maintainability (review-pr section 4d, advisory)
1k-line crossings: none (`wc -l`: create.tsx 883, resources 1079 and shrinking, additional-info 379).
Ponytail: 9 call sites of `scrollToFirstError()` next to 9 of `markAttempted(n)` is a repeated pair. A `blockStep(n)` helper would fold them, but it changes untouched lines and the executor's choice is the smaller diff. Follow-up at most.

## Follow-ups, out of scope for this unit
- Scroll on `customers/create` (finding 8, Q3). Update §11c row 6 and D17's wording when answered.
- TCG-219 rebase: whoever merges second re-applies the four `FieldError` swaps and the removed `errorText` style in `quote-create-resources.tsx`; check `grep -n errorText apps/mobile/components/sales/quote-create-resources.tsx` is empty after.
- Move the step-4 key rule to one exported helper (`isFieldMissing` or a `fieldKey()` builder) in `additional-info.helpers.ts` so the UI stops rebuilding the string; helpers file was off limits for U3.
- Real device pass: first `measureLayout` use inside a tall list-style step, and the landing under the pinned header.

## Open questions written to spec.md section 12
Q3 (scroll on `customers/create`), non-blocking. I also reworded the one sentence at the top of section 12 that said "No question is open", because it became false.

## Not checked
Emulator/device (no demo steps 1-6 run); real `measureLayout`/`scrollTo` behaviour and the 80 px margin; keyboard-open case; the New Job Site sheet scroll (read, not probed by me); a 100-row Resources step; nested customer/job-site picker from a failed state; stock `nx typecheck`/`lint`/`test` on a normal clone; `@tcg/web`, `@tcg/api`, `@tcg/shared` suites; `projects/create`, Billing Code, Custom Type, Request Changes, Mark Signed, Mark Lost sibling claims (executor's grep accepted as a lead).

## Least confident about
Finding 5 and the device landing: gap/layout equality and the scroll position are reasoned and mock-tested; only a device confirms both. Also finding 8's "small gap" weight is a judgment on the screen's layout I did not render.

## If this breaks in 3 months, most likely because [INFERRED]
A new validation rule on a quote step that shows its message without `FieldError` (plain `Text` again), or TCG-219's rebase on `quote-create-resources.tsx` reintroduces `errorText` lines; both leave a blocked press with no node to scroll to and nothing says so. Second: the step-4 key string drifting from `validateAdditionalInfo`'s `fieldKey`, which would silently show no "Required" while Next still blocks.

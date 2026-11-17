# Analysis — Trello-254 U1 (red asterisks + searchable Yard)

Unit reviewed: U1 — Red asterisks and searchable Yard (Trello-254), REQ-02 and REQ-01
Commit a5195ec5d on feat/trello-254-u1-red-asterisks-yard-search, base origin/staging 774ba9bc6. Analysed 2026-11-17, read-only.

## Verdict: ship (one optional follow-up, no must-fix)

## Gates I ran
- `NODE_OPTIONS=--max-old-space-size=4096 pnpm nx run @tcg/mobile:typecheck --skip-nx-cache` -> pass (not cached; also ran @tcg/shared dependency task).
- `pnpm exec jest "app/\(sales\)/(quotes/create|customers/create|email/compose|projects/create)" components/sales` (apps/mobile) -> 11 suites, 114 tests pass. Covers every touched screen/sheet test and both `qc-yard` callers.
- `pnpm exec eslint <the 9 touched files>` -> no output (0 errors, 0 warnings on those files). `pnpm exec prettier --check` same files -> clean. `git diff --check 774ba9bc6 HEAD` -> clean.
- Pre-existing failures excluded: none seen. Full mobile suite (333 suites / 3350) NOT re-run by me; I rely on the executor's number for that, tagged INFERRED.

## Findings

[VERIFIED] No `*` left in any label. `grep -rn 'label="[^"]*\*"' app components features design-system` (apps/mobile) -> 0 hits. `grep -rnE "[A-Za-z)] \*['\"\`<{]"` over app components features design-system lib data -> only a doc comment in `design-system/primitives/field.tsx:27`. Extra greps for `label={...*`, `title|header|placeholder="... *"`, `>text *<`, `{' *'}`, `' *'` -> 0 hits.

[VERIFIED] 25 sites, none gained or lost. `git grep` on baseline 774ba9bc6: 24 `label="... *"` sites plus 1 template literal (`quote-create-additional-info.tsx:193`) = 25. Per-site diff (`git show a5195ec5d -- apps/mobile`): every one of the 24 literal sites became `label="X" required` with `style`/`error` props kept; counts per file match the unit table (customers/create 10, email/compose 2, projects/create 1, billing sheet 1, custom-type 1, job-site sheet 6, main-info 3).

[VERIFIED] DynamicField mark parity. Baseline `const label = field.isRequired ? \`${field.name} *\` : field.name` (git show 774ba9bc6:...additional-info.tsx:193). After: all five branches (grep at lines 198, 207, 228, 255, 270) are `<Field label={field.name} required={field.isRequired}>`. `Field` draws the mark on `required &&`, same truthiness test as the old ternary. `isRequired` is `z.boolean()` / `.default(false)` (`data/contracts/sub-category.contract.ts:15,33`). No mark gained or lost.

[VERIFIED] Mark is a sibling, red, label text exact. `design-system/primitives/field.tsx` Field renders `{label}` in its own Text and `{required && <RequiredMark />}` beside it; RequiredMark colour `colors.errFg`. Existing mechanism, file untouched by the commit.

[VERIFIED] Yard search. `quote-create-main-info.tsx` Yard Select gets `searchable`; `design-system/primitives/select.tsx:48` `showSearch = searchable ?? options.length >= 8` -> box shows with 2 yards. Filter is lowercase `includes` on the label (yardName), "No matches" at line 127. `onChange` unchanged (`patch({ yard: yard?.yardName ?? v, yardUuid: yard?.id ?? '' })`), `selectedYardId` fallback unchanged, option testIDs `qc-yard-option-<yardId>` unchanged. `select.tsx` not in the diff. `grep -rn 'qc-yard' apps/mobile` -> only main-info and `features/sales/quote-create.test-helpers.tsx`; jest above passes.

[VERIFIED] Tests. Only one test line changed: `create.resources.test.tsx:485` `'Max Radius (ft) *'` -> `'Max Radius (ft)'`. `grep -rnE "(get|query|find)(All)?By(Text|LabelText|DisplayValue)\([^)]* \*['\"]" app components features` -> 0 hits, so no other assertion depended on the old text. No new test files (matches "no new tests unless asked").

[VERIFIED] Containment. `git diff --name-only 774ba9bc6 HEAD` -> 9 files, all under `apps/mobile`; `| grep -c field-ticket` -> 0. No schema, API, shared, web, package.json or lockfile change (G3, G5 not reached). Working tree clean.

[VERIFIED] Attribution. `git log -1 --format='%an <%ae>%n%B' | grep -iE 'co-authored|claude|anthropic|generated'` -> no match. Author haris <syed.haris@codingcops.com>.

[INFERRED] G1-G6. No tenant model, no pay rule, no dependency, no response shape, no new route, no date logic (read the diff; presentation-only). No new guardrail triggered. Reasoned from the diff, not a tool.

[INFERRED] Layout of the mark in the two-column rows (customers/create State/City; job-site City/Zip, Country/State) is unchecked. `Field` puts label and mark in a row inside the same View that carries `style`, and RequiredMark has `alignSelf: 'flex-start'`, so it should hold. Only a device shows it.

## Unsourced decisions (section 3)
- None that change behaviour. All details trace to REQ-01/REQ-02 acceptance and spec D2, D3.
- Formatting only: the commit adds 4 blank lines in import blocks of `quote-create-add-custom-type-sheet.tsx` (2) and `quote-create-add-job-site-sheet.tsx` (2). Declared in the PR description as lint-staged output; not a requirement. Harmless; the developer may revert if they want a minimal diff.

## Scope
Complete: yes. Contained: yes (apart from the 4 formatting blank lines, declared). Demo works: not verified by me and not by the executor (no device, no API/Metro); see "Not checked".

## Siblings
- All 25 sales sites in this PR. Field-ticket already on `required`, untouched (0 files). Other `Select`s keep the 8+ default (spec 11c). Web divergences (customer-create address marks, job-site City/Zip unmarked) are left as recorded follow-ups in the PR (AI decisions row 2).

## Maintainability
- 1k-line crossings: none. All changes are net-neutral line edits; `git diff --stat` shows +39/-31 over 9 files, no file grew by more than a few lines.
- Thermo-nuclear / ponytail: nothing. The removed `label` const in DynamicField reduces code.

## Follow-ups (out of scope)
- Web/mobile required-ness divergences in customer-create (D3, D5), already recorded.
- Housekeeping: `units.md` size line says "11 files"; actual is 9 files (+39/-31). Cosmetic. I cannot edit units.md.

## Open questions written to spec.md 12
none

## Not checked
- Emulator/device demo (no device; did not start any stack; no Send/DocuSign/email action triggered).
- Red rendering and placement on a real screen.
- Full mobile jest suite (333 suites) and mobile lint over the whole project: not re-run; I ran only the 11 touched/related suites and eslint on the 9 touched files.
- @tcg/web and @tcg/api: untouched, not run.
- Edit-mode fallback for a saved yard no longer active: unchanged code, not exercised.

## Least confident about
That the two-column rows look right on device. Second: that no sales-surface asterisk exists in a form my greps cannot match (e.g. built from a variable). I grepped bare `'*'`, `{' *'}` and JSX text forms in app/components/features/design-system and found none.

## If this breaks in 3 months
Most likely because someone adds a new `Field label="X *"` by habit, and nothing (lint included) blocks it. [INFERRED] Follow-up: a lint rule or a one-line grep in review. Also feat/MOBILE-ADDRESS-PLACES edits the same label lines in customers/create and the job-site sheet; whichever merges second rebases (known, spec D19).

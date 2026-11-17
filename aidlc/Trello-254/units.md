# Units — Trello-254 Mobile tweaks [quotation module]

> Written to `.ai/aidlc/Trello-254/units.md` from the signed `spec.md` beside it (owner sign-off,
> Syed Haris, in chat, 2026-11-16: Q1 = A, Q2 = A, D10 accepted, D13 confirmed; every other §11b row
> **carried: developer review in PR**).
> Consumed by an executor, one unit at a time. Written by `tcg-decomposer`, 2026-11-16. Nothing is built.
> The field list is the template's contract (`.ai/aidlc/templates/units.md`); nothing deleted.

**Delivery (owner decision):** 4 units, each its own PR off `staging`; dependent units stack. All work is
`apps/mobile`, plus one `packages/shared` file and one web re-export in U2. No schema, no migration, no
API change (`spec.md` §3, §4).

## Gate baseline

**Gate baseline:** *`2026-11-17`, `origin/staging` at `774ba9bc6`, clean worktree `.worktrees/trello-254`, run by U1's executor before its first edit (`--skip-nx-cache`, `NODE_OPTIONS=--max-old-space-size=4096`) — **`@tcg/mobile` typecheck: pass** (`pnpm nx run @tcg/mobile:typecheck`, also builds `@tcg/shared`, pass); **lint: pass, 0 errors, 403 warnings** (`pnpm nx run @tcg/mobile:lint`); **test: pass, 333 suites / 3350 tests** (`pnpm nx run @tcg/mobile:test`); **build:** mobile has no build target, `@tcg/shared` build passed as the typecheck dependency. `@tcg/web` and `@tcg/api` **not run** (U1 touches neither; web is touched only in U2 — U2's executor records the web baseline).* **U2 web baseline** *(`2026-11-17`, U1's tip `a5195ec5d` (pre-rebase; now `ef825e5c1`), before U2's first edit, `--skip-nx-cache`, `NODE_OPTIONS=--max-old-space-size=4096`): `@tcg/web` typecheck pass, test 1051/1051 pass; web lint run after the change only (0 errors, 380 warnings). Mobile baseline reused from the line above (U1 tip typechecks per its ledger).* **U3 baseline** *(`2026-11-17`): reused from U2's tip `202cee74c` (pre-rebase; now `26937d2c0`) (U2's post-change run: mobile typecheck pass via override, lint 0 errors / 399 warnings, jest 333 suites / 3350 tests); not re-run before U3's first edit. Web and API untouched by U3.* **U4 baseline** *(`2026-11-17`): reused from the rebased stack tip U3 `ef7cd0bfc` on `origin/staging` `de82fe9f5` (override tsc 0 errors; mobile jest 333 suites / 3350 tests; run by the orchestrator; lint 0 errors / 399 warnings as at U3). U4's post-change run: override tsc 0 errors, stock `pnpm nx run @tcg/mobile:lint --skip-nx-cache` 0 errors / 399 warnings, full mobile jest 333 suites / 3350 tests. Web and API untouched.* Later units report vs this line.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | Required-field asterisks render red on every mobile sales screen, and the quote builder's Yard picker has a search box | REQ-01, REQ-02 | mobile | — | ~70 lines / 11 files (+1 test assertion) | built — feat/trello-254-u1-red-asterisks-yard-search |
| U2 | Mobile address forms block an invalid US zip and format it as you type (same rule as web, one shared helper) | REQ-07 | mobile, shared, web (re-export only) | U1 (shared files, see Sequencing) | ~120 lines / 8 files | built — feat/trello-254-u2-zip-validation |
| U3 | A blocked Next or Save scrolls the quote builder to the first invalid field; step 4 shows inline "Required" | REQ-06 | mobile | U2 (shared files) | ~170 lines / 6 files | built — feat/trello-254-u3-scroll-to-first-error |
| U4 | Price List picker on Resources; the quote saves list and source; rates resolve from the list; a switch re-prices draft lines | REQ-03, REQ-04, REQ-05 | mobile | TCG-219 (external, **hard**); U3 (textual, order only) | ~450 lines / ~13 files (+3 test fixtures) | built — feat/trello-254-u4-price-list |

- **Status** takes exactly one of: `not started` · `in progress — <branch>` · `built — <branch>` · `merged — PR #<n>` · `cut — <reason>`. Never a commit SHA.
- **Requirements covered: REQ-01..REQ-07, counted against `spec.md` §2 on 2026-11-16.** 7 in spec, 7 placed
  (REQ-01 U1 · REQ-02 U1 · REQ-03 U4 · REQ-04 U4 · REQ-05 U4 · REQ-06 U3 · REQ-07 U2), 0 split, 0 uncovered.
  Recount whenever §2 gains a REQ.
- **Not covered:** none. Deferred behaviour, not requirements (`spec.md` §13): web's Discount / Until / Surcharge chips (D14), re-price on open of a saved draft, customer-create required-ness beyond zip format, the web "Suggested yard" chip, non-US zip formats.
- **Units blocked on an open question:** none. Q1 and Q2 were answered A on 2026-11-16 and no `[OPEN]` requirement exists. **U4 has one external hard dependency that is not a question: TCG-219 must exist as a base** (see U4 → Branch).
- **Findings for the spec, not units (no REQ added):** (1) the spec's overlap table says "5 shown" commits for each unmerged branch; `git log origin/staging..<branch>` on 2026-11-16 shows **8** commits on `feat/TCG-219-mobile-mob-demob-parity` and **9** on `feat/MOBILE-ADDRESS-PLACES`. The listed overlap files are unchanged by this. (2) §11a row 7 lists no `quote-create-resources.tsx` / `quote-create-tools.tsx` asterisk site, while D20 says U3 follows U1 for "the same `Field` lines in resources/tools". The sites that U1 and U3 truly share are `quote-create-add-job-site-sheet.tsx`, `quote-create-additional-info.tsx` and `quote-create-main-info.tsx`; U3 follows U1 on those. (3) Q2 = A knowingly lets one quote carry two surcharge percentages, which `decisions/2026-09-02-one-surcharge-per-quote.md` says should not happen; recorded in `spec.md` §12 Q2 Status for the decision note.

**Ripple summary:** all 4 units touch already-shipped behaviour; all 4 carry a regression row with a named check. A row's check is an existing test path or a named by-hand run; none is a new test.

---

## U1 — Red asterisks and searchable Yard

- **Outcome:** On every mobile sales screen the required-field asterisk is red, and on the quote builder's Main Info step a user can type in the Yard picker to filter yards (even with only 2 yards).
- **Kind:** vertical
- **Requirements covered:** REQ-01 fully; REQ-02 fully (all 25 sites).
- **Depends on:** — (but see overlap with `feat/MOBILE-ADDRESS-PLACES`, Sequencing)
- **Branch / PR base:** `feat/trello-254-u1-red-asterisks-yard-search`, from `origin/staging`; PR targets `staging`.
- **Size estimate:** ~70 source lines (mostly one-line label edits), 11 files, 1 existing test assertion.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | no schema change |
| API (`apps/api`) | N/A | no API change |
| Web (`apps/web`) | N/A | web is the reference; untouched |
| Mobile (`apps/mobile`) | REQ-02: `label="X *"` → `label="X" required` at all 25 sites (`spec.md` §11a row 7): `app/(sales)/email/compose.tsx` 231, 268; `app/(sales)/customers/create.tsx` 111, 119, 139, 146, 155, 164, 172, 226, 233, 303; `app/(sales)/projects/create.tsx` 93; `components/sales/create-billing-code-sheet.tsx` 138; `components/sales/quote-create-add-custom-type-sheet.tsx` 54; `components/sales/quote-create-add-job-site-sheet.tsx` 105, 114, 134, 146, 218, 234; `components/sales/quote-create-main-info.tsx` 361, 421, 506; `components/sales/quote-create-additional-info.tsx` 193 (`DynamicField`: `<Field label={field.name} required={field.isRequired}>`, no `*` in the label). REQ-01: `searchable` on the Yard `<Select>` (`testID="qc-yard"`, ~l.507) in `quote-create-main-info.tsx`. | Reuse `Field`'s `required` prop (sibling `RequiredMark`) and the existing `Select searchable`; no new component (`spec.md` D2, D3). Line numbers are the spec's; re-grep on the branch: `grep -rn 'label="[^"]*\*"' apps/mobile/{app,components,features,design-system}` and `grep -rnE '[A-Za-z)] \*['"'"'"`<{]' apps/mobile/...`. Change only label props on `Field`s that also pass `style`/`error`. No field gains or loses a mark (D3). |
| Shared (`packages/shared`) | N/A | |
| Tests | `not requested`. **Existing assertion that changes:** `app/(sales)/quotes/create.resources.test.tsx:485` `getByText('Max Radius (ft) *')` → `'Max Radius (ft)'` | Updating a broken existing assertion is part of the unit, not a new test (`spec.md` §10). |

### Reviewable as

- **Demo:** Expo Go on emulator `emulator-5554` (Moto G85), local API `:3000`, Postgres `tcg_db`. (1) Sales → New Quote: Main Info — Yard, Customer Name, Job Site (and the other marked fields) show a red `*` beside the label, label text without it; step 4 (Additional Info) with a template that has a required field: red mark, none on optional fields. (2) Tap Yard: the sheet opens with a "Search…" box; type a fragment — list narrows; clear — all return; a nonsense string shows "No matches"; pick a yard — `qc-yard` shows its name. (3) Open each of New Customer, New Project, Email compose, Create Billing Code sheet, Add Custom Type sheet, Add Job Site sheet: every `*` is red. (4) Field-ticket screens unchanged. Web as reference for "required mark" only.
- **Acceptance:** `spec.md` REQ-02 acceptance (25 sites, label reads exactly "Yard", "Customer Name", "Max Radius (ft)", no field gains/loses a mark, field-ticket untouched) and REQ-01 acceptance (search with 2 yards, narrow/clear/pick sets `form.yard` and `form.yardUuid`, "No matches").
- **Reviewer can verify without:** U2 to U4, TCG-219, a price-list customer, seed beyond 2 yards and one required Additional Info field.

### Risk

- **Weakest source:** `[UNVERIFIED]` (REQ-01, REQ-02: card + owner answer). Normal case, not a blocker.
- **Migration reversible:** yes — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** presentation only. Worst case: an asterisk dropped from one of the 25 sites (a required field looks optional) or a `Field` that loses its `error` styling. Neither changes who is blocked.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| 25 asterisk labels on 8 files (`spec.md` §11a row 7) | `Field label` → `Field required` | `grep -rn 'label="[^"]*\*"' apps/mobile/{app,components,features,design-system}` returns nothing and the template-literal grep returns nothing; existing jest for the touched screens (`pnpm nx test @tcg/mobile`, files under `app/(sales)` and `components/sales`) run; the one assertion at `create.resources.test.tsx:485` updated; each of the six screens/sheets seen on the emulator | `spec.md` REQ-02, D3 |
| Yard `Select` and tests that press `qc-yard-option-*` (`test-helpers`, `create.main-info.test.tsx`, `create.edit.test.tsx`) | `Select searchable` | `grep -rn 'qc-yard' apps/mobile` lists the callers; run those jest files; on the emulator pick a yard, and edit a saved quote whose yard is no longer active (existing fallback) | `spec.md` REQ-01, D2, §11a row 8 |
| Field-ticket required marks | `Field required` / `RequiredLabel` | `git diff --stat` shows no file under `features/field-ticket`; sibling grep from `spec.md` §11c | `spec.md` §11c row 2 |

### Deliberately not in this unit

- Web's "Suggested: <yard> — Use" chip — web-only, not on the card (`spec.md` §13).
- Painting marks to match web's customer-create required-ness, and customer-create validation — follow-up (D3, D5).
- Server-side yard search / address search — D2 (name-only client filter); one-line change if the owner wants more.

---

## U2 — US zip validation on mobile address forms

- **Outcome:** On the quote builder's New Job Site sheet and both zip inputs on New Customer, a user typing a zip sees it formatted (`12345`, `12345-6789`), and an invalid value shows the web message and blocks Next/submit.
- **Kind:** vertical (the `packages/shared` file and web re-export exist only to serve this behaviour; no later unit consumes them, so no foundation split).
- **Requirements covered:** REQ-07 fully (three mobile inputs).
- **Depends on:** U1 — **textual only**: both edit `quote-create-add-job-site-sheet.tsx` and `customers/create.tsx` on adjacent lines (U1 label at the zip `Field`, U2 the zip input and error beside it). It does not need U1's behaviour.
- **Branch / PR base:** `feat/trello-254-u2-zip-validation`, stacked on `feat/trello-254-u1-red-asterisks-yard-search`; PR targets U1's branch while U1's PR is open, retargeted to `staging` when U1 merges.
- **Size estimate:** ~120 source lines, 8 files (shared +45, web `lib/zipcode.ts` −30, mobile ~100 across the sheet, `customers/create.tsx`, `customer-create.store.ts`).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | |
| API (`apps/api`) | N/A | API accepts any ≤20-char zip and still does (`spec.md` REQ-07 Ripple). |
| Web (`apps/web`) | `apps/web/src/lib/zipcode.ts`: `isValidUsZipCode`, `sanitizeZipCodeInput`, `US_ZIP_ERROR` re-exported from `@tcg/shared`; zod schemas `optionalZipCodeSchema` / `requiredZipCodeSchema` stay. `lib/zipcode-input.ts` unchanged (already re-exports `sanitizeZipCodeInput` from `./zipcode`). | Import-only; the 7 other web importers do not change (§11a row 10). Same names, no behaviour change. D4 is **carried: developer review in PR** — the fallback if the reviewer rejects it is a mobile-local copy `apps/mobile/lib/zipcode.ts` and dropping the shared and web edits. |
| Mobile (`apps/mobile`) | (1) New-Job-Site sheet `qc-add-site-zip` (`components/sales/quote-create-add-job-site-sheet.tsx`, state at l.28, `missing.zipCode` l.71, field l.148-152): sanitise on change, `maxLength` 10, keep `number-pad`; blank stays "Required"; non-empty invalid shows `US_ZIP_ERROR` under the field on `touched` submit and blocks; clears once valid. (2) Customer create billing zip (`app/(sales)/customers/create.tsx` l.172-175, `form.zip`) and job-site zip (l.248-251, `form.jobSite.zip`): sanitise on change; a non-empty invalid value blocks Next (steps 1 and 2) and Save; blank passes. | Do not expand the customer-create gate beyond zip (REQ-07 notes, D5). Where `feat/MOBILE-ADDRESS-PLACES` is merged, its `onZipCodeChange` setter on the sheet and the store setters must route through the same sanitise/validate (a Places pick fills zip through that setter, D19). Error timing D6. |
| Shared (`packages/shared`) | New `src/utils/zipcode.ts` (the three pure functions copied from web's `lib/zipcode.ts`, no zod), exported from `src/utils/index.ts` (precedent `./city-match`). | `@tcg/shared` is consumed as built `dist/`: run `pnpm nx build @tcg/shared` before mobile or web typecheck. No new shared test (`not requested`). |
| Tests | `not requested` | Existing tests run, none edited expected: `customers/create.test.tsx` (presses Next/Save on a blank form — blanks must pass) and `create.main-info.test.tsx:202` (types valid `90802`). |

### Reviewable as

- **Demo:** Emulator + `:3000` + `tcg_db`. (1) Quote builder → customer → New Job Site sheet: type `abc123456789` → shows `12345-6789`; submit `12345-67` → "Please enter a valid US zip code (e.g. 12345 or 12345-6789)" under the field, sheet stays; `11111-` also rejected; blank → "Required"; `90802` submits. (2) New Customer: billing Zip and job-site Zip — type `12345-67`, press Next → message and blocked; clear it → Next passes; Save with both blank still shows "Customer created". (3) Web as reference: open a web form that takes a zip (e.g. quick-create customer modal) — same strings and formatting; and confirm it still behaves as before the re-export.
- **Acceptance:** `spec.md` REQ-07 acceptance table rows 1-3 and the two invalid examples.
- **Reviewer can verify without:** U3, U4, TCG-219, a price-list customer, Google Places (`MOBILE-ADDRESS-PLACES`).

### Risk

- **Weakest source:** `[UNVERIFIED]` (REQ-07: card + owner "like web").
- **Migration reversible:** yes — no migration; a shared additive export, revert-by-commit.
- **Behind a flag:** no.
- **Touches existing data:** no. Existing malformed zips are not re-validated; a restored customer-create draft (`CUSTOMER_DRAFT_KEY`) with an old malformed zip is validated at the next Next/Save (§11a row 11).
- **Blast radius:** mobile now rejects zips the API still accepts (stricter, as web already is) — a legitimate non-US zip can no longer be entered (out of scope, intent §5). A mistake in the shared re-export breaks web's 8 zip importers at compile time (caught by web typecheck).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| Web zip consumers: `lib/zipcode.ts` and `customer.schema.ts`, `job-site.schema.ts`, `quick-create-customer-modal.tsx`, `vendor.schema.ts`, `yard.schema.ts`, `create-employee-form.ts`, `components/ui/input.tsx`, plus `lib/zipcode-input.ts` (§11a row 10) | `@/lib/zipcode` re-export of `@tcg/shared` | `pnpm nx build @tcg/shared`, then `pnpm nx typecheck @tcg/web`, `pnpm nx lint @tcg/web`, `pnpm nx test @tcg/web` (not covered by pre-push, run by hand); by hand, type `123456789` in a web zip input and see `12345-6789` | `spec.md` REQ-07 Ripple, D4 |
| `customers/create.test.tsx` blank Next/Save; `create.main-info.test.tsx:202` | the zip gate | run both jest files (`pnpm nx test @tcg/mobile`) | `spec.md` REQ-07 notes, §10 |
| Customer-create draft restored from `kv` | `customer-create.store.ts` | on the emulator: save an in-progress draft with zip `12-` then reopen and press Next — message shows | `spec.md` §11a row 11 |
| Read-only zip displays (`quote-create-main-info.tsx:387,460`, `customers/[id].tsx:148,181`) | none (unchanged) | `git diff --stat` shows them untouched | `spec.md` REQ-07 Edges |
| `@tcg/shared` consumers on mobile (104 files import it) | new export on built `dist/` | `pnpm nx typecheck @tcg/mobile` after the shared build | `spec.md` §7 |

### Deliberately not in this unit

- Making zip required on customer-create, or any other customer-create validation — follow-up (D5, §13).
- Non-US zip formats — intent §5.
- The web zod schemas move — they stay in web (shared must not depend on `zod/v4`).

---

## U3 — Scroll to the first invalid field on the quote builder

- **Outcome:** When Next or Save is blocked by validation on the quote builder, the screen scrolls to the first message, and step 4 shows an inline "Required" under each unmet required field; the Add New Job Site sheet scrolls the same way.
- **Kind:** vertical
- **Requirements covered:** REQ-06 fully (acceptance 1-6).
- **Depends on:** U2 — **textual only** (U3 edits the job-site sheet that U2 and U1 edit, and `quote-create-additional-info.tsx` / `quote-create-main-info.tsx` that U1 edits).
- **Branch / PR base:** `feat/trello-254-u3-scroll-to-first-error`, stacked on `feat/trello-254-u2-zip-validation`; PR targets U2's branch while U2's PR is open, retargeted to `staging` as the stack merges.
- **Size estimate:** ~170 source lines, 6 files.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | |
| API (`apps/api`) | N/A | |
| Web (`apps/web`) | N/A | web unchanged |
| Mobile (`apps/mobile`) | `app/(sales)/quotes/create.tsx`: wrap the `ScrollView` content (~l.486) in a content `View` ref + `FieldErrorScrollProvider`; local `useState` counter bumped in every blocked branch of `next()` (l.226) and `save()` (l.318), in the same handler that calls `markAttempted`; `useScrollToFieldError`. `components/sales/quote-create-resources.tsx` l.388, 491, 690, 691 and `quote-create-tools.tsx` l.178, 207: plain `<Text style={styles.errorText}>` → `FieldError` (same text). `components/sales/quote-create-additional-info.tsx` + `DynamicField`: new `showErrors` prop mirroring steps 1-3, inline `Required` under each unmet required field. `components/sales/quote-create-add-job-site-sheet.tsx`: pass the existing `BottomSheet` `scrollToErrorSignal` on a failed submit. | Primitives exist: `design-system/primitives/field-error-scroll.tsx`, exported from `@/design-system`. **Do not import `useStepValidation`/`StepBodyShell` from `features/field-ticket`** (D16). The over-limit toasts stay toast-only. Error copy `Required` is ASSUMED (REQ-06); developer review in PR. Leave the existing step-4 toast. No change to `Field`, `field-error-scroll.tsx` or `bottom-sheet.tsx`. |
| Shared (`packages/shared`) | N/A | |
| Tests | `not requested` | Existing jest files for the builder run; `spec.md` §11a row 9 found none asserting the six converted messages. |

### Reviewable as

- **Demo:** Emulator + `:3000` + `tcg_db`. New quote: (1) Main Info, tap Next with Yard, Customer and Job Site empty (and, once scrolled away, with an End Date before Start) → screen scrolls to the topmost message; scroll away and press Next again → scrolls again. (2) Resources step: add a row, leave Item blank, press Next → scrolls to "Item is required"; likewise "Quantity must be 0 or more" / "Rate must be greater than 0"; Tools step "Tool is required". (3) Additional Info with a required field empty and a long template (scroll away first): Save → inline "Required" appears under each unmet field and the screen scrolls to the first. (4) Make `save()` send you to an earlier step → it scrolls to that step's first message. (5) New Job Site sheet: submit empty → scrolls to its first message. (6) Over-limit toasts still just toasts.
- **Acceptance:** `spec.md` REQ-06 acceptance 1-6.
- **Reviewer can verify without:** U1 asterisk look (the `Field` lines are the same, so a reviewer can use either), U4, TCG-219, a price-list customer.

### Risk

- **Weakest source:** `[UNVERIFIED]` (REQ-06: card + owner + `contexts/web.md` rule).
- **Migration reversible:** yes — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** presentation. A bad measure must never crash — "no registered node or measure fails → no scroll" is an acceptance line. Rendering the new `FieldError` rows adds an alert-icon line where plain text sat, a small layout shift on steps 2 and 3.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| Six plain-`Text` error sites (resources 388, 491, 690, 691; tools 178, 207) and any test reading their messages (§11a row 9) | `styles.errorText` → `FieldError` | `grep -n 'errorText' apps/mobile/components/sales/quote-create-*.tsx` shows none left on those lines; `grep -rn 'is required' apps/mobile/app/(sales)/quotes --include=*.test.tsx` still returns only the Main Info assertions; run `create.*.test.tsx` (`pnpm nx test @tcg/mobile`); the six messages seen on screen with identical text | `spec.md` REQ-06, D16 |
| Steps 1 messages already via `Field error` and the nested customer/job-site pickers' own scroll registry | `FieldErrorScrollProvider` | on the emulator, open a nested picker from a failed state — it still scrolls inside its own sheet; Main Info messages unchanged | `spec.md` REQ-06 Edges |
| Step 4 (`AdditionalInfoStep`/`DynamicField`) renders no inline errors today; its Save toast | new `showErrors` prop | Save with all required fields filled — no inline error, quote saves; with one empty — error + toast as before | `spec.md` REQ-06 acceptance 3 |
| `quote-create-resources.tsx` is rewritten by the unmerged TCG-219 | file overlap | see Sequencing: whichever of U3/TCG-219 merges second rebases; after the rebase re-run the Resources-step demo (2) | `spec.md` D19, overlap table |

### Notes added 2026-11-17 (Q3 follow-up)

- **Q3 = A (Syed Haris, 2026-11-17):** `app/(sales)/customers/create.tsx` also scrolls to its two U2 zip errors on a blocked Next (step 1 billing zip, step 2 job-site zip) and on a `save()` that sends the user back to the step holding the invalid zip; a repeat press scrolls again. Same wiring as the quote builder (one counter, `useScrollToFieldError`, `FieldErrorScrollProvider`, content `View` ref; `gap` moved from the ScrollView content container to the new `scrollBody`). Errors register through the existing `Field error`. Amended into U3's single commit; U3 is now 6 files.
- **SHAs after the amend and the U4 rebase (UNPUSHED stack, all on `origin/staging` `de82fe9f5`):** U1 `ef825e5c1`, U2 `26937d2c0`, **U3 `f0102809e`** (was `ef7cd0bfc`), **U4 `f1759d174`** (was `2848fa45a`, `f8c384459`; amended 2026-11-17 for Q4 = A: a customer change on Main Info re-prices draft lines, same re-price as the picker; touches `quote-create-main-info.tsx`, `create.tsx` and a doc line in `use-reprice-draft-resources.ts`).

### Deliberately not in this unit

- Scroll on `projects/create`, `email/compose`, Billing Code and Custom Type sheets — no inline errors to scroll to (D17, §11c). (`customers/create` was in this list; it is now **in** U3 — Q3 answered A by Syed Haris 2026-11-17, see the note below.)
- Moving to a shared step-validation hook — D16.
- Price List picker and its validation — U4.

---

## U4 — Price List picker, rates resolved from the list, re-price on switch

- **Outcome:** On a mobile quote's Resources step a user can choose the quote's saved list, the customer's current list or Master; the quote saves that choice; new lines for a list customer price from the list; and changing the list on a draft re-prices its un-overridden catalog lines.
- **Kind:** vertical
- **Requirements covered:** REQ-03, REQ-04, REQ-05 fully (acceptance 1-9 of REQ-05; Q1 = A and Q2 = A built as answered).
- **Depends on:** **TCG-219 (`feat/TCG-219-mobile-mob-demob-parity`, external, hard)** because U4 reuses and extends its `apps/mobile/features/sales/use-apply-resolved-rates.ts` (the per-line resolve-and-apply that REQ-05 needs; do not write a second copy) and its re-resolve callers (`use-quotation-type-switch.ts`). **U3 — textual only** (`create.tsx`, `quote-create-resources.tsx`).
- **Branch / PR base (updated 2026-11-17 by the orchestrator's instruction):** **TCG-219 is now merged into `origin/staging` (PR #1074)**, so case 4 below applied: `feat/trello-254-u4-price-list` was cut from U3's branch (`feat/trello-254-u3-scroll-to-first-error`, tip `ef7cd0bfc`), and the stack U1 (`ef825e5c1`) -> U2 (`26937d2c0`) -> U3 (`ef7cd0bfc`) had been rebased onto `origin/staging` `de82fe9f5` first, so `use-apply-resolved-rates.ts` is in the base. **U4's PR targets `feat/trello-254-u3-scroll-to-first-error`** (retarget to `staging` as the stack merges). Cases 1-3 and 5 below are historical. Original text: `feat/trello-254-u4-price-list`. **How it is built:**
  1. **TCG-219 not merged to `staging` (today's state: 8 unmerged commits, no PR):** cut U4's branch from `origin/feat/TCG-219-mobile-mob-demob-parity`, and the PR **targets `feat/TCG-219-mobile-mob-demob-parity`** (stacked, one unit one PR). U4 does **not** need U1-U3 in its base: they change no function U4 calls. Build the picker and re-price on `use-apply-resolved-rates.ts` as it stands on that branch.
  2. **Re-sync when TCG-219 moves:** TCG-219's tip was rebased on 2026-11-13 and can be again. After every change to its branch, `git fetch` and `git rebase --onto origin/feat/TCG-219-mobile-mob-demob-parity <old-tip> feat/trello-254-u4-price-list`.
  3. **TCG-219 merges (merge or squash) before U4 merges:** `git rebase --onto origin/staging <last TCG-219 tip U4 sat on> feat/trello-254-u4-price-list`, then retarget the PR to `staging`, or to U3's branch if U3's PR is still open.
  4. **TCG-219 already merged when U4 starts:** cut from the tip of the stack (U3's branch if its PR is open, else `origin/staging`), after `git merge origin/staging`/rebase so TCG-219 is in; PR targets that branch.
  5. **TCG-219 is closed, abandoned or deferred indefinitely:** stop. Do not copy `use-apply-resolved-rates.ts` into a second hook. Tell the developer; U4 is blocked on an external decision, which is a ledger change (`cut` or re-plan), not an `[OPEN]` requirement.
  6. **U1-U3 merge order vs U4:** whichever of U3 and U4 merges second rebases and resolves `create.tsx` and `quote-create-resources.tsx` — the second unit's author owns the conflict, and re-runs its own demo.
- **Size estimate:** ~450 source lines, ~13 files (two new hooks, ~10 edited, 3 fixtures).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | `Quotation.priceList` and `priceListSource` already exist (`schema.prisma:1725`, `@default("customer")`). |
| API (`apps/api`) | N/A | `resolve-rate` already takes `priceListName`; DTOs already carry both fields. No G5. |
| Web (`apps/web`) | N/A | reference only |
| Mobile (`apps/mobile`) | **REQ-03:** `features/sales/quote-create.store.ts`: `priceListSource: 'customer' \| 'master'` on `QuoteDraft` (default `'customer'`); `selectCustomer` sets `priceList = customer.priceList ?? ''` and source `'customer'` if non-empty else `'master'`. `components/sales/quote-create-resources.tsx` (`ResourcesStep`): Price List `Select` above the lines (saved list for the same customer, customer's current list, "Master List"; "(Quoted)"/"(Current)" only when the names differ case-insensitively; disabled "No Customer Price List" when none); Master keeps `priceList`. `features/sales/quote-create.helpers.ts` ~l.436-454: replace the derived `priceListSource` with the stored one; `priceList: trimmed || null`. `features/sales/quotation-edit-mapper.ts`: load `priceListSource` (`'master'` stays, else `'customer'`), "quoted" option = saved list. `data/contracts/quotation.contract.ts`: add nullish `priceListSource` to `QuotationSchema`. `app/(sales)/quotes/create.tsx` ~l.421: running-total subtitle shows "Master List" when source is `master`; pass `originalStatus === 'DRAFT'`/new to `ResourcesStep`. **REQ-04:** `data/hooks/query-keys.ts:67` add the list name to `resourceCatalogResolveRate`; `data/hooks/use-resource-catalog.ts:80` `useResolveRate` passes `priceListName`; `features/sales/use-resource-item-selection.ts` (~l.104-124) and `quote-create-resources.tsx` `handleBillingCodeCreated` (~l.614-629) resolve with the effective list (none for Master); `features/sales/use-apply-resolved-rates.ts` (TCG-219) resolves with the effective list, which it should read from the store so `use-quotation-type-switch.ts` needs no signature change — if a parameter is added instead, update that caller in this unit. **REQ-05:** new `features/sales/use-reprice-draft-resources.ts` (draft-only gate, eligibility `pricingSource ∈ {price_list_item, billing_code}` + catalog FK + known `referenceRate` + `|rate − referenceRate| ≤ 0.005`, child lines included; writes the field set already written by `use-apply-resolved-rates.ts` / D8; `none` → rate 0 / source `none`; fetch error → line untouched (D10, accepted); discard a stale response when the list/source changed (D11); typed-over line untouched whole (Q2 = A)) and new `features/sales/use-hydrate-reference-rates.ts` (D12: after edit hydration, resolve each priced line once with the saved list to set only `referenceRate`; edit-loaded lines start `referenceRate: null` at `quotation-edit-mapper.ts:165`). | Reuse, don't copy: build the re-price on `useApplyResolvedRates` and `useResolveRate`. Hydration must run before the first switch on an edited draft or the switch is silently inert. Amount recompute through `quotation-pricing.ts`. Nothing saves on a switch. Web is the reference (`use-reprice-draft-resources.ts`, `use-hydrate-reference-rates.ts`, `resources-pricing-chips.tsx`). D12, D11, D15, D9 are **carried: developer review in PR**; D10 and D13 are owner-confirmed. |
| Shared (`packages/shared`) | N/A | |
| Tests | `not requested`. **Existing assertions/fixtures that change because the code under them changes** (`spec.md` §10): `features/sales/quote-create.helpers.test.ts` ~l.246-284 (payload `priceListSource`, and "marks priceListSource as master when the user overrides the customer default" — the source is stored, not derived); `features/sales/quotation-edit-mapper.test.ts` (~l.24-48, 179) and `data/contracts/quotation.contract.test.ts` (~l.21-55) get the new field; on TCG-219's branch also its tests that mock `useResolveRate` / query keys (re-grep). | Confirm these when the code is written (`spec.md` §10 says "to confirm"). No new test files. |

### Reviewable as

- **Demo:** Emulator `emulator-5554` + local API `:3000` + `tcg_db`. Find a customer with a price list and a catalog item that is on it (Prisma Studio `pnpm db:studio`, or web's customer screen — web is the reference). **Before/after on `:3000`:** (1) New quote, that customer, Resources step: Price List shows "<List>" and "Master List" above the lines. (2) Pick an item on the list: the request is `GET /price-listings/resolve-rate?…&priceListName=<List>` (API log or network inspector) and the line takes the list's rate, discount and surcharge; pick the same item under Master → request has no `priceListName` and the line takes the billing-code rate. (3) Switch List → Master → List: eligible lines re-price at each step; type a different rate on one line, switch → that line keeps its rate and surcharge; a manual line is untouched. (4) Turn off the API (or airplane mode) and switch → lines unchanged, no zero. (5) Save, then check `tcg_db`: `price_list` and `price_list_source` are what the picker showed (`master` stays `master`, name kept). (6) Reopen a saved draft: picker shows the saved list as "(Quoted)", customer's current list as "(Current)" when names differ; switch → lines re-price (hydration worked). Reopen a quote that is not DRAFT (e.g. SENT, if editable): switch changes list/source but lines do not re-price. (7) Open the same quote on web (`:3001`): same list and source shown. (8) Repeat (2) with TCG-219's Quotation Type switch.
- **Acceptance:** `spec.md` REQ-03 acceptance 1-6, REQ-04 acceptance, REQ-05 acceptance 1-9 (Q1 = A, Q2 = A).
- **Reviewer can verify without:** U1-U3 (U4's base on TCG-219's branch does not contain them), a non-draft quote (step 6 second half optional), the Discount/Until/Surcharge chips.

### Risk

- **Weakest source:** `[UNVERIFIED]` (REQ-03/04/05: card + owner "mirror web"); REQ-04/05 also cite a `[VERIFIED]` decision, but a requirement takes its worst source.
- **Migration reversible:** yes — no migration; the stored `priceListSource` column is an existing one.
- **Behind a flag:** no.
- **Touches existing data:** **new data only.** No backfill, no rewrite of saved quotes (G2 not triggered). Existing mobile-saved quotes whose derived `priceListSource` was `master` because the quote's list differed from the customer's current list load as `master` and the picker shows Master selected while the held name is kept — a pre-existing mis-store surfaced for the first time; noted, not repaired.
- **Blast radius:** **money.** (a) D13, owner-confirmed 2026-11-16: new mobile lines for customers on a price list now price from the list, not the billing code. (b) A switch rewrites rate, discount, hike and surcharge on draft lines. (c) The server approval check (`quotation-approvals.service.ts:250-258`) compares rates with the list's rates; mobile list-customer quotes now line up, but a quote saved with Master selected still compares against the held list name (web quirk mirrored). (d) The query key changes; old cached entries just miss. (e) Q2 = A can leave one quote carrying two surcharge percentages against `one-surcharge-per-quote` — owner chose it, decision note pending.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| Item-pick re-resolve (`use-resource-item-selection.ts:104`) and billing-code-created re-resolve (`quote-create-resources.tsx:614-629`) — **change deliberately** (now with the effective list) | `useResolveRate` | existing `create.resources.test.tsx` run; on the emulator for a customer with **no** list and for Master: request has no `priceListName` and the line prices as today; for a list customer: list rate (demo 2) | `spec.md` REQ-04, D13 (owner-confirmed) |
| `queryKeys.resourceCatalogResolveRate` (sole consumer `use-resource-catalog.ts:85`) and TCG-219's `use-apply-resolved-rates.ts` / `use-quotation-type-switch.ts` | query key shape | `grep -rn 'resourceCatalogResolveRate' apps/mobile` shows every caller carries the list; the Quotation Type switch re-resolve on TCG-219's branch run by hand (demo 8) and its existing tests | `spec.md` §11a row 3 |
| Save payload `priceListSource` and its stored-value readers: API clone `quotations.service.ts:2016`, web `customer-draft-price-list-notice.tsx:42` (skips `master`), web `edit-quotation.mapper.ts:165` | `QuotationDto.priceListSource` | save from mobile then clone the quote and open it on web (`:3001`); `grep -rn 'priceListSource' apps/api/src apps/web/src apps/mobile` listing read before the change | `spec.md` §11a row 4 |
| Mobile `Quotation` response schema (`QuotationSchema`) parsed in `quotations.http.ts` l.63/79/87/95 and the mock; narrower list-screen projections (~l.298, ~l.393) | zod schema | additive nullish field; existing contract and mapper jest run; open the quotes list and a detail screen on the emulator | `spec.md` §11a row 5 |
| Resources rows, running total, Additional Info grouping | `updateResource` (13 non-test refs) | re-run `quote-create.store.test.ts`, `quotation-pricing.test.ts`, `create.*.test.tsx`; running total and a priced Additional Info grouping checked on the emulator after a switch | `spec.md` §11a row 6 |
| Main Info read-only Price List (`quote-create-main-info.tsx:394`), running-total subtitle (`create.tsx:421`) | `form.priceList` | on the emulator: Main Info still shows the list; subtitle shows "Master List" under Master | `spec.md` §11a row 1, D15 |
| Server below-rate approval check `quotation-approvals.service.ts:250-258` | saved `priceList` + line rates | no API change, so no API test; by hand: save a mobile quote for a list customer and compare its line rates to the list in `tcg_db`; if the quote reaches an approval step, confirm the below-rate flag is not raised for rates the list itself gives | `spec.md` §11a row 12 |
| Reference-rate hints on rows (`quote-create-resources.tsx` ~l.556-560 below-rate warning, ~l.593 "Reference rate") | `referenceRate` | open an old mobile draft for a list customer: hints appear after hydration (new) and such lines read as typed-over and are not re-priced — recorded in the PR | `spec.md` §11a row 13, D12 |

**Every row has a check and a source; none is left without one.**

### Deliberately not in this unit

- Web's Discount / Until / Surcharge chips — D14; follow-up (and the Until date would pull in the tenant-zone rule).
- Re-pricing a draft on open — not built; web does it, mobile does not (`spec.md` §13).
- Repairing already-stored mis-derived `priceListSource` values — not asked; no backfill (G2).
- The guard that updates `quotations/gaps.md` and the decision notes for Q1/Q2 — `tcg-scrum`, not code.

### Notes added 2026-11-17 (Q4 follow-up)

- **Q4 = A (Syed Haris, 2026-11-17):** a customer pick on Main Info that changes the effective list re-prices a draft's eligible lines with the same `useRepriceDraftResources` the picker uses (new quote or edit loaded as DRAFT only; typed-over lines skipped; D10/D11 unchanged; re-picking a customer whose list is already in force does nothing). `MainInfoStep` gains an `isDraft` prop from `create.tsx`. Files added to U4's slice: `components/sales/quote-create-main-info.tsx`, `app/(sales)/quotes/create.tsx` (both were already in it), plus a doc comment in `features/sales/use-reprice-draft-resources.ts`. Amended into U4: `f1759d174`.

---

## Sequencing

```
U1 ──▶ U2 ──▶ U3 ──▶ (U4 reviewed after U3, based on TCG-219)
                         ▲
TCG-219 branch ──────────┘  (U4 base; external)
MOBILE-ADDRESS-PLACES: not a base for any unit; rebase target for U1/U2 when it merges
```

- **Parallelisable:** U1, U2 and U3 are **not** parallel — they share, by line, `components/sales/quote-create-add-job-site-sheet.tsx` (U1 labels, U2 zip, U3 scroll signal), `app/(sales)/customers/create.tsx` (U1 labels, U2 zip gate), `components/sales/quote-create-additional-info.tsx` and `quote-create-main-info.tsx` (U1 labels/yard, U3 errors), `packages/shared/src/utils/index.ts` (U2; also MOBILE-ADDRESS-PLACES). **U4 can be built in parallel with U1-U3** *as a separate stack on TCG-219's branch*: it shares with U3 only `app/(sales)/quotes/create.tsx` and `components/sales/quote-create-resources.tsx`, in different regions (U3: ScrollView wrapper and four error lines; U4: subtitle at ~l.421, a new prop, the picker above the rows, `handleBillingCodeCreated`). It is not a clean parallel: the second of U3/U4 to merge resolves the conflicts and re-runs its demo. A reviewer who wants no conflict reviews U3 first.
- **Merge order constraint:** U1 → U2 → U3 (stack, each PR targets the previous branch until it merges). U4 after TCG-219 (hard) and, preferably, after U3. No migrations. For U2: build `@tcg/shared` before mobile or web typecheck; in the merge, shared and the web re-export ship together in U2's PR (no window where web imports a missing export).
- **Cross-surface window (U2):** `packages/shared` gains an export that web's `lib/zipcode.ts` re-exports in the **same** PR; mobile uses it in the same PR. No window where web and mobile disagree.
- **Overlap with unmerged branches (checked 2026-11-16, `git log origin/staging..<branch>`):**
  - `feat/MOBILE-ADDRESS-PLACES` (9 commits; touches `customers/create.tsx`, `customers/create.test.tsx`, `quote-create-add-job-site-sheet.tsx` incl. new `onZipCodeChange`, `customer-create.store.ts`, `design-system/primitives/input.tsx`, `packages/shared`): **High for U1 and U2.** It is another ticket's work: U1/U2 do not stack on it. Whichever merges second rebases and resolves. If it merges before U1 starts, branch U1 from the fresh `staging`; if after, `git rebase origin/staging` the U1-U2-U3 stack at that point (rebase U1, then `git rebase --onto` each next branch) and rerun U2's demo with a Places pick, which must pass through the same zip check (D19).
  - `feat/TCG-219-mobile-mob-demob-parity` (8 commits, no PR; rewrites `quote-create-resources.tsx`, `quote-create.store.ts`, `quote-create.helpers.ts`, `use-resource-item-selection.ts`, `quotation-edit-mapper.ts`, `quotation.contract.ts`, adds `use-apply-resolved-rates.ts` / `use-quotation-type-switch.ts`; does not touch `create.tsx` or `quote-create-main-info.tsx`): **High for U4, medium for U3** (only `quote-create-resources.tsx`, the four error lines). U3 can merge before TCG-219; TCG-219's owner rebases over the six-line conversion and should be told. U4's build is in U4 → Branch.
- **Shared providers:** none named in two units. U2 adds one shared function file; no NestJS provider or module is added by any unit (`git grep -ln` check not applicable — no API change).
- **First unit to ship:** **U1**. It proves the `Field required` mechanism and `Select searchable` against the real screens and clears the `Field` lines every later unit edits; it does not test the riskiest assumption. The riskiest assumption is U4 (money, and a hard external dependency), which is why U4's TCG-219 question is raised now rather than at the end: confirm TCG-219's merge plan while U1-U3 are in review.

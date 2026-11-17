# feat(mobile): Price List picker on Resources; rates follow the quote's price list (Trello-254, U4)

Base: `feat/trello-254-u3-scroll-to-first-error` (U3's PR; retarget to `staging` as the stack merges). Branch: `feat/trello-254-u4-price-list`, one commit. TCG-219 is merged to `staging` (PR #1074); the U1-U3 stack was rebased onto `origin/staging` `de82fe9f5` before this branch was cut (U1 `ef825e5c1`, U2 `26937d2c0`, U3 `f0102809e` after the Q3 amend, was `ef7cd0bfc`; this branch rebased onto it, was `f8c384459`, then `2848fa45a`, now `f1759d174` after the Q4 amend). Mobile only: no schema, API, shared or web change (G3, G5 not triggered). 15 files, +481 -48.

**Money warning for the reviewer (D13, owner-confirmed 2026-11-16).** New mobile lines for a customer on a price list now price from the list, not the billing code. A quote saved with Master selected still saves the held list name (web quirk mirrored).

## What changed

- **REQ-03 picker.** `ResourcesStep` has a "Price List" `Select` (`qc-price-list`) under Quotation Type: the quote's saved list (edit mode, same customer), the customer's current list, then "Master List". "(Quoted)" / "(Current)" suffixes appear only when both exist and differ by name. With no list: a "No Customer Price List" row plus Master. Choosing a named list sets `priceList` + source `customer`; Master sets source `master` and keeps `priceList`.
- **Stored source.** `QuoteDraft.priceListSource` (default `customer`); the save payload sends it as stored (the derived `isCustomerDefaultPriceList` is gone); `priceList: trimmed || null`. Selecting a customer sets list and source (`customer` if the customer has a list, else `master`). `QuotationSchema.priceListSource` (nullish string) and the edit mapper load it (`master` stays `master`, anything else `customer`). The running-total subtitle shows "Master List" under Master.
- **REQ-04.** `queryKeys.resourceCatalogResolveRate` takes `priceListName`; `useResolveRate` passes it through; every resolve passes the effective list (none under Master).
- **REQ-05.** A switch on a new quote or an edit loaded as `DRAFT` re-prices eligible lines (`price_list_item`/`billing_code`, catalog FK, known `referenceRate`, `|rate - reference| <= 0.005`, children included). Built on `useApplyResolvedRates` (extended with a `reprice` option, not copied). `useHydrateReferenceRates` (web's hook) sets `referenceRate` on edit-loaded lines once the saved quote is in the store.
- Mock quotations service echoes `priceListSource` so a mock-mode reopen reads back what was saved.
- Not built: Discount / Until / Surcharge chips (D14). Nothing is saved by a switch.

## Every resolve-rate caller on mobile (grep `resolveRate|useResolveRate|ResolveRateParams|resourceCatalogResolveRate|useApplyResolvedRates`)

| Caller | Before | Now |
| --- | --- | --- |
| `use-resource-item-selection.ts` (item pick), via `useApplyResolvedRates` | list-less | effective list read from the store at call time; no signature change |
| `use-quotation-type-switch.ts` (type switch, created lines), via `useApplyResolvedRates` | list-less | same, no change to the file |
| `quote-create-resources.tsx` `handleBillingCodeCreated` (direct `useResolveRate`) | list-less | passes the effective list |
| `use-reprice-draft-resources.ts` (new), via `useApplyResolvedRates(ids, reprice)` | n/a | passes the list switched to (pinned) |
| `use-hydrate-reference-rates.ts` (new), direct `useResolveRate` | n/a | effective list at resolve time |
| `use-resource-catalog.ts` `useResolveRate` (the only user of the key) | key without list | key carries `priceListName` |
| `use-resource-catalog.ts` `useCreateBillingCode` invalidation prefix `['resourceCatalog','resolveRate']` | prefix | still a prefix of the longer key, unchanged |
| `resource-catalog.http.ts` / `.mock.ts` `resolveRate(params)` | forwards params | unchanged; the mock ignores `priceListName`, so mock mode shows no list pricing |

## AI decisions

| # | Decision | Chosen | Source / alternative |
| --- | --- | --- | --- |
| 1 | Where the pure rules live | New `features/sales/price-list.ts` (option builder, effective list, customer-selection rule, labels) | Web's `buildPriceListOptions` / `handlePriceListUpdate` are private to `apps/web`, so this is a second copy across apps; moving them to `packages/shared` is a follow-up (not done: shared is outside the unit's table) |
| 2 | Extra `QuoteDraft.savedPriceList` `{customerCode, priceList, priceListSource}` (not named in units.md) | Set by the edit mapper, null on a new quote, kv-persisted with the draft, never sent | Needed for the "(Quoted)" option and for Q1 = A when the same customer is re-picked (web `handlePriceListUpdate`, cited in REQ-03 notes). That restore is a step beyond REQ-03 acceptance 4's plain rule |
| 3 | "No Customer Price List" row | Shown as an ordinary row whose press is ignored; **not visually disabled** | `Select` has no per-option disabled and spec section 6 says primitives are unchanged. Alternative (rejected here): add `disabled` to `SelectOption` in the design system |
| 4 | Re-price trigger | Event-driven: the picker handler patches the store then calls the re-price; skipped when the effective list did not change (re-picking the selected list) | Web uses an effect keyed on the list. Spec: "Reached by: the picker only" |
| 5 | **Customer change re-prices (Q4 = A, applied)** | Picking another customer on Main Info calls the same `useRepriceDraftResources` as the picker, when the effective list changed as a result (`MainInfoStep.selectCustomer`; `create.tsx` passes `isDraft`) | Owner answer Q4 = A, Syed Haris 2026-11-17 (was: no re-price, per REQ-05 "picker only"; analyst finding 1 of `analysis-U4.md`). Draft only, same eligibility, same D10/D11 rules, typed-over lines skipped. The effective list is read from the store before and after the patch, not from the `form` prop. Re-picking a customer whose list is already in force fires nothing. If the user had chosen Master by hand and then re-picks the same customer, the list reverts to the customer's own, so that counts as a change and re-prices |
| 6 | Late answers (D11) | Compared by the effective list key (`priceListKey`) when each answer lands | A -> Master -> A quickly: the first A answer is still valid for A and applies |
| 7 | Also dropped | An answer for a line the user has typed over (or removed) while the request was in flight | Cheap re-check with `isRepriceEligible` after the await; protects Q2 = A and typed input; not in web |
| 8 | `none` result | Resets the line (rate 0, discount/hike null, surcharge off, source `none`, reference null) | REQ-05 acceptance 5, web `resolveAndApplyRate` |
| 9 | Fetch error | Line untouched, no zero | D10 (owner-accepted; differs from web) |
| 10 | Hydration trigger and scope | Hook runs in `create.tsx`, enabled once an edit is loaded (any status), so reference hints also appear on non-draft edits | Web runs it when not read-only. Starting at load, not at Resources mount, closes the race with an early switch |
| 11 | Hydration write | New store action `setReferenceRate(id, ref)` that writes only that field, not `updateResource` | `updateResource` recomputes amounts; saved amounts must not move on open. Hydration only fills a reference that is still missing |
| 12 | Hydration of lines priced at a different list | A line saved at the billing-code rate for a list customer (old mobile quotes) reads as typed-over and is not re-priced | Spec section 11a row 13; noted, not repaired (no backfill, G2 not triggered) |
| 13 | Price-list name compare | Case-insensitive, trimmed, for option de-dup; the resolve key uses the name as held | Web `sameName` |
| 14 | Query key gets `priceListName` last | `['resourceCatalog','resolveRate', sub, role, custom, list]` | Keeps the invalidation prefix valid |
| 15 | `reprice` shape | `RepriceOptions { priceList, shouldApply(line) }` as the 2nd argument of the one apply function | No second copy of resolve-and-apply. Item pick and type switch call it as before |
| 16 | Existing test | `quote-create.helpers.test.ts`: "marks priceListSource as master when the user overrides..." rewritten to "sends the stored priceListSource" (customer and master cases, Master keeps the name) | Spec section 10: the source is stored, not derived. `quotation-edit-mapper.test.ts` and `quotation.contract.test.ts` were checked: no change needed (the new field is nullish and the draft default comes from `blank()`). No new test files |
| 17 | Asterisk / error conventions (U1, U3) | Price List is optional: `Field label="Price List"`, no required mark, no error line | Nothing to validate |

Siblings (`patterns.md`/spec 11c, grep above): every resolve caller listed in the table is covered. Quote detail, customer screens and field-ticket read no list (`grep -rn 'priceList' apps/mobile/{app,components,features}` before and after: only Main Info read-only field, subtitle, customer-create and detail rows, unchanged). Web chips: follow-up (D14). `packages/shared` move of the pure rules: follow-up.

Rule sources checked: `grep -rn 'RATE_OVERRIDE_EPSILON\|buildPriceListOptions\|priceListSource\|Master List' packages/shared/src .ai/vault/decisions/` -> none. `grep -rli 'price.list\|re-price\|reference.rate' .ai/vault/decisions/` -> unrelated notes plus `2026-09-02-one-surcharge-per-quote.md` (Q2, owner-resolved). Web reference read: `resources-pricing-chips.tsx`, `use-reprice-draft-resources.ts`, `use-hydrate-reference-rates.ts`, `use-resource-pricing.ts`, `resources-tab.helpers.ts` `applyResolvedPricing`, `create-quotation-form-model.ts` `handlePriceListUpdate`, `create-quotation-form-utils.ts`. Mobile TCG-219 hook `use-apply-resolved-rates.ts` read before editing.

## What was checked, and how

Baseline reused (units.md, U4 line): override tsc 0 errors; mobile jest 333 suites / 3350 tests.

**Environment caveat (as U2/U3).** This worktree's `node_modules` are symlinks into the main checkout, so stock `pnpm nx run @tcg/mobile:typecheck` fails with TS2305 on `@tcg/shared` exports added by U2. I ran `pnpm nx build @tcg/shared --skip-nx-cache`, then `tsc` and `jest` with throwaway configs mapping `@tcg/shared` to this worktree's dist ("override"). Reviewer: run the stock commands once on a normal clone.

| Command | Result |
| --- | --- |
| `pnpm nx build @tcg/shared --skip-nx-cache` | pass |
| `tsc -p <override>` (apps/mobile) | pass, 0 errors |
| `pnpm nx run @tcg/mobile:lint --skip-nx-cache` (stock) | 0 errors, 399 warnings (same as U3; the 3 in `create.tsx` are pre-existing `set-state-in-effect`) |
| `jest -c <override>` full apps/mobile suite | 333 suites / 3350 tests pass (`email/compose.test.tsx` failed once in a first full run under load, passed alone and in the final full run) |
| prettier, lint-staged on commit | clean, no rewrite |
| Q4 probe (temporary jest, written, run, deleted, **not committed**; real `create.tsx`, real customer picker, `resolveRate` spied) | 4 cases pass: (a) new draft, line A at 80 / reference 80 and a typed-over line T at 95 / reference 80: pick CUST-00002 (list Premium) -> 1 resolve call with `priceListName: 'Premium'`, A re-priced to 120 with reference 120, T untouched; re-pick CUST-00002 -> 0 calls; pick CUST-00003 (no list) -> 1 call without `priceListName`, source `master`, A at 100 `billing_code`; resolve rejecting then pick CUST-00001 -> 1 call with `'Standard'`, A byte-identical; (b) the analyst's scenario: Main Info -> Resources -> back to Main Info, other customer -> re-priced (Resources unmounted, so the re-price does not depend on that step being mounted); (c) SENT_TO_CUSTOMER edit, customer change -> 0 calls, rate kept; (d) DRAFT edit, customer change -> 1 call |
| Temporary jest probes (written, run, deleted, **not committed**; services mocked at `services.resourceCatalog.resolveRate`) | 15 cases pass: (1) switch customer list -> Master re-prices an eligible root and a child line, skips a typed-over line (rate and 8% surcharge kept, Q2) and a manual line, requests carry no `priceListName` under Master; back to the list re-prices again with `priceListName: 'Standard'` (round trip); (2) a rejecting resolve leaves the line byte-identical; (3) a `none` answer resets the line; (4) a Master answer arriving after a switch back is dropped; (5) a rate typed during the request survives; (6) `isDraft={false}` changes the source but fires no request; (7) re-picking the selected list fires nothing; (8) picker options: no list -> "No Customer Price List" + Master, quoted/current labels; (9) item-pick path sends `priceListName: 'Standard'`, none under Master, and the same item under two lists is two requests, a repeat within 5 min is cached; (10) hydration sets only `referenceRate` (rate and manual lines untouched) and a switch then re-prices; (11) save payload carries `priceList: 'Standard'` with `priceListSource` `master` then `customer`; (12) `priceListForCustomer` cases and `QuotationSchema` + `mapQuotationToDraft` keep `master`; through the real `create.tsx`: (13) DRAFT edit hydrates the reference with `priceListName: 'Standard'` then a switch re-prices, (14) SENT_TO_CUSTOMER edit switches source but fires no request and keeps the rate, (15) new quote with no customer shows the two options |

## Not run

- **Emulator demo not run.** No device connected (`adb devices` empty), nothing on :3000 / :8081; the API stack holds real integration credentials and was not started. Reviewer demo (units.md U4 -> Demo 1-8): customer on a list, confirm `GET /price-listings/resolve-rate?...&priceListName=<List>`; switch List / Master / List and watch eligible lines move, typed-over and manual lines not; airplane mode then switch leaves lines alone; save and check `price_list` / `price_list_source` in `tcg_db`; reopen a draft and a SENT quote; open the same quote on web; repeat with the Quotation Type switch. **Mock mode will not show list pricing** (the mock `resolveRate` ignores `priceListName`).
- The server below-rate approval check (spec 11a row 12) and the API clone / web notice readers of `priceListSource`: no API change, not exercised.
- Stock `nx typecheck` / `nx test` on a normal clone (see caveat). `@tcg/web`, `@tcg/api`, `@tcg/shared` tests: untouched, not run.
- Real timing of the in-flight guards on a slow network (probes use deferred promises, not a device).

## Least confident about

1. **"No Customer Price List" is not visually disabled** (decision 3): a tap closes the sheet and changes nothing. Product may want a greyed row, which needs a `Select` change.
2. **Customer change re-prices lines** (decision 5, Q4 = A applied). It changes money on a step REQ-05 did not name, on the owner's answer. Not run on a device; the probe below drives the real `create.tsx` and Main Info pickers on mock services.
3. The `savedPriceList` restore on re-picking the same customer (decision 2) is web behaviour but a step past REQ-03 acceptance 4's wording.
4. Existing mobile quotes for list customers hold billing-code rates; after hydration they read as typed-over (decision 12), so a switch will not move them. Expected, but visible to testers.

# Analysis — Trello-254 U4 (Price List picker, rates resolved from the list, re-price on switch)

Unit reviewed: U4 — Price List picker, rates resolved from the list, re-price on switch (Trello-254), REQ-03 / REQ-04 / REQ-05
Commit f8c384459 on feat/trello-254-u4-price-list, stacked on U3 ef7cd0bfc (stack on origin/staging de82fe9f5, TCG-219 merged). Analysed 2026-11-17, read-only (tcg-analyst). Web is the reference.

> **Superseded 2026-11-17 by the section "Re-analysis after Q4" at the end of this file (verdict: ship with follow-ups, commit f1759d174). The text below is the first analysis of f8c384459, kept as history.**

## Verdict: do not ship until the owner answers Q4 (spec section 12); ship with follow-ups once Q4 is answered either way and, for answer A, applied. Everything else is ship-with-follow-ups quality. Gates are green.

Single reason for the hold: a spec gap that U4 turns into money, not an executor defect. The executor followed REQ-05 "Reached by: the picker only" exactly and flagged the consequence (PR decision 5). Before U4 no mobile resolve sent a list, so a line's rate did not depend on the customer. After D13 (owner-confirmed) lines carry a specific customer's list rates, so changing the customer on Main Info leaves the previous customer's rates on the quote and saves them under the new customer's list. Web does not do that. The owner has not seen this case: spec section 13 and 11b are silent on it. Written as Q4.

## Gates I ran
- `pnpm nx build @tcg/shared --skip-nx-cache` -> pass.
- `pnpm exec tsc -p <scratchpad>/tsconfig.mobile.json` (apps/mobile, override, `@tcg/shared` mapped to this worktree's dist) -> 0 errors. Stock `@tcg/mobile:typecheck` not run: it fails here only because node_modules symlinks into the main checkout (same as U2/U3).
- `pnpm exec eslint <the 15 touched files>` (apps/mobile) -> exit 0, 0 errors, 3 warnings, all `set-state-in-effect` at `create.tsx:135,145,146` (pre-existing, not in the diff's hunks).
- `pnpm exec prettier --check <15 files>` -> clean. `git diff --check ef7cd0bfc f8c384459` -> clean.
- `pnpm exec jest -c <scratchpad>/jest.mobile.json` full apps/mobile -> 333 suites / 3350 tests pass (same as baseline). No cache involved (direct jest).
- My own temporary probe `apps/mobile/features/sales/zz-probe-u4a.test.tsx` (real `ResourcesStep`, real store, real hooks, `services.resourceCatalog.resolveRate` spied), run once, **deleted; `git status --short` empty after (VERIFIED)**. Results in findings 1, 3, 4.
- `git show f8c384459 --stat --format= | grep -i test` -> only `quote-create.helpers.test.ts`. `git show f8c384459 --name-status --format= | grep -E "^A"` -> 3 added files, all non-test (`price-list.ts`, `use-hydrate-reference-rates.ts`, `use-reprice-draft-resources.ts`). `git log -1 --format=... f8c384459 | grep -iE 'co-authored|claude|anthropic|generated'` -> no match (exit 1); author haris.
- `git diff --stat origin/staging f8c384459 -- apps/api apps/web packages` shows only U1-U3's `packages/shared/src/utils/zipcode.ts` and web re-export; `git diff ef7cd0bfc f8c384459 --name-only | grep -v '^apps/mobile'` -> empty and `git diff ef7cd0bfc f8c384459 -- apps/mobile/package.json package.json pnpm-lock.yaml | wc -l` -> 0. So U4 touches mobile only, no dependency.
- Worktree clean, VERIFIED: probe file removed, then `git -C /home/codingcops/craneguys-platform/.worktrees/trello-254 status --short` -> empty. Separately `git -C .ai status --short` shows `aidlc/Trello-254/` untracked in the overlay repo; that predates this analysis and I did not commit it.
- Pre-existing failures excluded: none seen.

## Findings, most consequential first

(1) HOLD, OWNER DECISION (Q4). Customer change does not re-price existing lines; web re-prices them.

[VERIFIED] (1a) Mobile. Probe B: with line A at Standard rate 80 (price_list_item, reference 80, eligible), patching the store as `selectCustomer` does (`customer` = CUST-2, `priceListForCustomer` -> list "Other", source customer), then waiting 30 ms: 0 `resolveRate` calls, list "Other", line rate 80, reference 80. The line keeps the previous customer's rate under the new customer's list. Reachable on a real screen: Main Info is step 1, `<- Back` from Resources (`create.tsx:558`) returns to it and the customer picker stays editable (`quote-create-main-info.tsx` `selectCustomer`, no lock); `selectCustomer` patches `customer` and the list only (read, diff).

[INFERRED] (1b) Web, reasoned from reading only, not run. Web has no customer-change handler. `ResourcesTab` mounts only while its tab is active (`create-quotation-tab-content.tsx:171` `case 'Resources':` returns it alone), and on every mount `useRepriceDraftResources` (`resources-tab.tsx:109-113`, `enabled: !readOnly && isDraft`) starts with a fresh ref, so the list key differs, the attempt set is empty and every eligible row is re-resolved against the current list (`hooks/use-reprice-draft-resources.ts`). That is web's "re-price on open", which spec section 13 excludes on mobile; a customer change is just one case it catches. So the proposed fix below is narrower than web and stays inside section 13.

- Money consequence (INFERRED): a salesperson who starts a quote for customer A (list "Preferred", 80), goes back and picks customer B (list "Standard", 100), saves: lines at 80 under list "Standard". Under-charge if B's list is higher, or approval-check noise if lower (`quotation-approvals.service.ts:250-258` compares line rates to the saved `priceList`). Silent: no warning, and the picker shows B's list as selected.
- Not covered by an owner answer: D10, D13, Q1, Q2 were confirmed; "customer change does not re-price" appears only in `pr-description-U4.md` decision 5. G1 (client-facing money behaviour nobody specified), so it belongs to the owner: Q4, recommended A.
- Not covered by this fix (non-blocking): the two stale-rate races in finding 4 stay open after Q4 = A; they are separate follow-ups.
- [INFERRED] Money consequence as above.
- Proposed (developer's call, I did not change source): after the `patch` in `MainInfoStep.selectCustomer`, when `isDraft` and `priceListKey(effectivePriceList(form))` changed, call the same re-price (`useRepriceDraftResources(isDraft)` needs `isDraft` passed to `MainInfoStep`, ~4 lines). Or the owner records "customer change keeps lines" as accepted, with the consequence above in the PR text.
- Refutation attempted: "maybe lines are cleared on customer change" -> `selectCustomer` clears job site and contacts only (read). "Maybe web does not re-price either because the tab stays mounted" -> `switch` returns one component (read). Survives.

[INFERRED] (2) Eligibility gate matches web, line by line. Reasoned from reading both files (not run). Read `use-reprice-draft-resources.ts` (mobile) against web `hooks/use-reprice-draft-resources.ts`: pricingSource `price_list_item`/`billing_code`; FK = subCategoryId||roleId||customTypeId; reference a finite number; `|rate - reference| <= 0.005` (web: override when `> 0.005`, eligible when not; same); children included (`collectRepriceIds` recurses); draft only (`enabled` = new quote or `originalStatus === 'DRAFT'`, `create.tsx` `isDraft`); web also excludes `readOnly`, mobile has no read-only editor state for this screen. The executor reports a probe where typed-over and manual lines are skipped (executor-reported, I did not re-run it). My only VERIFIED point here is that line A, eligible and carrying a discount/hike, was re-priced (finding 3).

[VERIFIED] (3) Field set written on a re-price equals web's `applyResolvedPricing` (+ `resolveAndApplyRate` null rules). Probe A: line (qty 2, rate 80, discount 10, until 2027-01-01, hike 5, surcharge 3) switched List -> Master; result rate 100, unit "Hour", discount null, until null, hike null, surcharge enabled 8, source `billing_code`, `referenceRate` 100, amount 216 (= 100 x 2 x 1.08; was 0 before because the seed carried no recompute, so this shows the recompute ran). Matches web: discount/until/hike only from `price_list_item`, else null; `referenceRate := rate`; amount via `syncResourceAmount` (store `updateResource` -> `syncResourceAmount`, read). Small difference, INFERRED from reading both: web maps the unit through `toResourceUnitMeasure(...)` and sets `unitUnresolved`; mobile writes `resolved.unitMeas` raw. That is TCG-219's pre-existing shape in `use-apply-resolved-rates.ts`, not introduced by U4; not a U4 finding. `priceHikeValidUntil` is dropped by both.

[VERIFIED] (4) Two stale-rate races leave a line at the OLD list's rate under the NEW list, silently. Web self-heals both because its effect re-runs on every `resources` change and a newly priced row becomes a candidate; mobile's re-price is a one-shot at the switch.
- C (pick in flight): line with `pricingSource: null` (just picked, resolve pending), list switched to Master, then the pick's answer lands: final state list `master`, rate 80, source `price_list_item`, only one request ever made (`['Standard']`). The pick read the list when it started. The switched list never re-prices it because it was ineligible at the switch.
- D (hydration in flight): reopened draft, hydration request for "Standard" pending, user switches to Master before it answers (line has no reference, skipped), then the answer lands: list `master`, rate 80, reference 80, requests `['Standard']`. The line now looks priced and not typed over, but at Standard's rate under Master, and nothing re-prices it.
- Weight: window is seconds on a slow network (D needs the user to reach Resources and switch before hydration finishes; hydration starts at load, so usually done). Not a blocker; it is the same class as finding 1 (money under the wrong list), so I would fix them together: after a hydration or pick answer lands, if the effective list at that moment differs from the list the request used, drop the write (for a pick, re-run for that id). Follow-up unless the owner wants zero tolerance.

[INFERRED] (5) Deliberate deviations behave as recorded. Executor-reported probes, read not re-run: fetch error leaves the line byte-identical (D10), `none` resets (rate 0, discount/hike null, surcharge off, source `none`, reference null; matches web's `none` branch), late answer for a superseded list dropped via `priceListKey` compare (D11), attempt set absent so A -> Master -> A re-prices each step (REQ-05 AC 7; web clears its set on list change; the same net effect). Decision 7's extra drop of a line typed over in flight is conservative and not in web; I agree with it (it protects Q2 = A). Reasoned from reading `use-apply-resolved-rates.ts`: the stale check runs only when `reprice` is passed, so item pick and type switch are unchanged by it.

[VERIFIED] (6) REQ-04: every mobile resolve caller passes the effective list. Command: `grep -rn "resolveRate\|useResolveRate\|ResolveRateParams\|resourceCatalogResolveRate\|useApplyResolvedRates\|resolve-rate" --include=*.ts --include=*.tsx apps/mobile` (non-test). Production callers: `use-apply-resolved-rates.ts:92` (list from store, or the pinned list on re-price), `use-hydrate-reference-rates.ts:50` (list from store at resolve time), `quote-create-resources.tsx:894` (`handleBillingCodeCreated`, list from store), and the service layer `resource-catalog.http.ts:72` which forwards `params` untouched. Callers of `useApplyResolvedRates`: `use-resource-item-selection.ts`, `use-quotation-type-switch.ts` (both unchanged files, list read inside). No caller in `data/` or other `features/` omitted. Key: `query-keys.ts:69-75` adds `priceListName` last; `useResolveRate` passes `params.priceListName` (`use-resource-catalog.ts:86-91`). Invalidation `['resourceCatalog','resolveRate']` (`use-resource-catalog.ts:72`) is still a prefix of the longer key. The cache-key behaviour (same item, two lists = two requests, repeat within 5 min cached) is executor-reported, not re-run by me. Mock `resolveRate` ignores `priceListName` (executor says so; `resource-catalog.mock.ts:200`), so mock mode cannot show list pricing; that is a demo caveat, not a defect.

[VERIFIED] (7a) Save payload wiring and API acceptance, by `grep -n "buildEditableFields\|priceListSource" quote-create.helpers.ts` and reading the DTOs. `quote-create.helpers.ts:462-464`: `priceList: trimmedPriceList || null`, `priceListSource: form.priceListSource`; both `buildCreatePayload` (l.485) and the update path (l.494) go through `buildEditableFields`. API accepts both fields: `create-quotation.dto.ts:463-469` (`priceList` max 100, `priceListSource` `@IsIn(['customer','master'])`), `UpdateQuotationDto = PartialType(OmitType(CreateQuotationDto,...))`; `resolve-price.dto.ts:37` `priceListName` max 255 (read). `QuotationSchema.priceListSource` is `z.string().nullish()` (additive: the schema accepted before, with zod object parsing; no consumer made it required). 

[INFERRED] (7b) Load, reasoned from reading plus executor-reported probes (not re-run by me): Master keeps `priceList: 'Standard'` with source `master`, then `customer`. Edit mapper: `toPriceListSource` -> only `'master'` stays master, null/other -> customer; `savedPriceList` set from the quote's customer (`quotation-edit-mapper.ts:196-205`), Q1 = A behaviour via `priceListForCustomer` (probe: same customer restores saved list and source, other customer takes its own, no list -> master). Old values: a legacy quote saved `master` by the derived rule loads Master and stays Master on resave (the old code would also have re-derived master); a web quote with source `customer` whose list differs from the customer's current list is now preserved, where the old derivation would have rewritten it to `master` on a mobile resave. Improvement, reasoned from the removed derivation.

[INFERRED] (8) Picker options and labels match web's `buildPriceListOptions` in order and rule. Reasoned from reading both: names [quoted, customer current, selected], de-dup by trimmed lower-case name, "(Quoted)"/"(Current)" only when both exist and differ, then Master; no named list -> "No Customer Price List" then Master. Difference: web marks that row `disabled: true`; mobile cannot (no per-option disabled in `Select`), decision 3. Visual affordance gap only; owner call, follow-up.

[VERIFIED] (8b) Probe E (mine): pressing the `__none__` row with a customer that has no list -> 0 resolve calls and the store's form JSON identical before and after. Harmless.

[INFERRED] (9a) Hydration writes only `referenceRate`: `setReferenceRate` (`quote-create.store.ts`) spreads the line and sets that one field and does not call `syncResourceAmount` (read). Executor probe 10 says rate and manual lines are untouched (executor-reported, not re-run).

[VERIFIED] (9b) No dirty flag exists on mobile: `grep -n -i "dirty\|unsaved" create.tsx quote-create.store.ts` shows only comments about discarding a new-quote draft, so nothing flips and nothing saves. Like every store action it writes the kv draft (`persist`). Race: finding 4D. Hydration runs for any status at load (decision 10; web only when not read-only); effect is limited to showing the below-rate hint on non-draft edits.

[VERIFIED] (10) Scope (commands in Gates). 15 files (+453 -45), all `apps/mobile`; no API, schema, shared, web, or dependency change (commands above). Tests: one existing test updated, no new test file, no AI attribution. No Discount/Until/Surcharge chips (D14). `savedPriceList` and `setReferenceRate` are extra draft/store surface recorded as decisions 2 and 11. One unrelated hunk: `quote-create-resources.tsx` `GroupResourceCard` `FieldError ... visits-error` collapsed from 4 lines to 1 (lint-staged/prettier on U3's lines); harmless, 3 lines of noise (diff read).

[VERIFIED] (11) Quotation Type switch unchanged, at the file level: `git diff ef7cd0bfc f8c384459 --name-only` does not list `use-quotation-type-switch.ts` or `use-resource-item-selection.ts`. [INFERRED] from the diff read: `applyResolvedRates(createdIds)` is still called with one argument; the non-reprice branch of `useApplyResolvedRates` writes the same fields as TCG-219's version (`buildPricingPatch` moved out unchanged for the non-reprice case, `rate` still omitted on `none`). The one intended change is the list in the request. [VERIFIED] full jest (333/3350, command in Gates) includes the existing type-switch and item-pick suites and passes.

## Hazard list (section 3b)
Isolation, impersonation, timezone, enum exhaustiveness, migration: not triggered (no schema, API, shared change; no date logic). Contract: mobile `QuotationSchema` gains one nullish field; response shape of the API is unchanged, so `tcg-contract-tracer` not needed. Test IDs: `qc-price-list` and `qc-price-list-option-*` are new mobile ids; `qa-automation` is web-only. Permission, roles, registry: no route or module. Unconfirmed x permanent: nothing permanent (no migration, no backfill; saved quotes only carry what the user chose). Unrecorded structure: all new files and fields trace to PR decisions 1, 2, 10, 11, 15.

## Unsourced decisions (section 3)
All recorded by the executor; none hidden:
- Customer change does not re-price (decision 5): traces to no requirement and to no owner answer; that is finding 1.
- `savedPriceList` restore when the same customer is re-picked (decision 2): sourced by Q1 = A and web's `handlePriceListUpdate`.
- Hydration for any status (decision 10): web enables it when not read-only; mobile has no read-only flag, so "any status" is a reading.
- Extra stale-drop for a typed-over line (decision 7).
- Epsilon 0.005: sourced (web `RATE_OVERRIDE_EPSILON`).

## Scope
Complete: yes for REQ-03 AC 1-6, REQ-04, REQ-05 AC 1-9 as the spec words them; the web-parity gap in finding 1 is outside the spec's wording but inside the owner's "mirror web". Contained: yes. Demo works: not run by anyone on a device or API (executor and I both did not).

## Maintainability (review-pr section 4d, advisory)
1k-line crossings: none. `quote-create-resources.tsx` was already over 1,000 (1285 -> 1339, `git show ef7cd0bfc:... | wc -l`, `wc -l`), grows by 54; `create.tsx` 883 -> 897 (below). Not a crossing. Ponytail: web's pure picker rules now exist twice (web and `price-list.ts`); the executor already lists the move to `packages/shared` as a follow-up. Agreed.

## Follow-ups, out of scope for this unit
- Move `buildPriceListOptions` / effective-list / customer-selection rules to `packages/shared` and make web consume them (G5 touches web; its own task).
- Web's Discount / Until / Surcharge chips (D14).
- Disabled look for the "No Customer Price List" row (needs `Select` change).
- Fix the two silent stale-rate races (finding 4) with the "list at answer time vs list at request time" check.
- Mock `resolveRate` honouring `priceListName`, so mock mode can show list pricing.
- Re-pricing on open (web does; spec §13 excludes).
- Legacy mobile quotes for list customers that hold billing-code rates will read as typed-over after hydration and not re-price on a switch (decision 12, as web would). Visible to testers.

## Open questions written to spec.md section 12
**Q4** (customer changed after lines exist: re-price to the new customer's list?), recommended A, blocks U4's merge, owner Syed Haris. I also reworded the one sentence at the top of section 12 to name it.

## Not checked
Executor probes are accepted as leads only, apart from my probes A-E. Emulator or device; the real API (`GET /price-listings/resolve-rate?...priceListName=` and the saved `price_list`/`price_list_source` in `tcg_db`); mock mode shows no list pricing. Server below-rate approval flow (`quotation-approvals.service.ts`) not exercised. Web re-price run: I read it, did not run it. Stock `nx typecheck`/`test` on a normal clone. A switch with many lines on a slow network (timing of the in-flight guards uses deferred promises). Sent/non-draft edits on a real status list. The executor's other 15 probe results are accepted from the PR text and the `.bak` probe file, apart from the cases I re-ran.

## Least confident about
Finding 1's web side: it rests on my reading that web's Resources tab unmounts and re-mounts and that a fresh attempt set re-resolves all eligible rows. If the web app keeps the tab mounted (e.g. via a layout I did not open), web would still re-price because the effect keys on the list name; both paths agree, but only a run on `:3001` shows it. Second, finding 4's weight: a seconds-wide window I measured with deferred promises, not on a network.

## If this breaks in 3 months, most likely because [INFERRED]
The pure picker/option rules in `price-list.ts` drift from web's private copy (two copies, no shared home), or a new caller of `resolveRate` is added that forgets the list (the key makes a missing list a cache hit for the wrong list, not an error). Both would silently show a rate from the wrong list.

---

## Re-analysis after Q4 (2026-11-17, tcg-analyst, read-only)

Unit: U4, Trello-254. Commit f1759d174 on feat/trello-254-u4-price-list, base U3 f0102809e, base origin/staging de82fe9f5 (first analysed f8c384459, then 2848fa45a). Q4 answered A by Syed Haris 2026-11-17.

### Verdict: ship with follow-ups. No must-fix.
Finding 1 (customer change does not re-price) is closed on mobile. Gates green. The remaining follow-ups include the stale-rate races of finding 4, one of which is now more reachable (see R2); none is a must-fix in my judgement (section Q4-5).

### What changed since 2848fa45a
`git diff --stat 2848fa45a f1759d174` -> 3 files, +31 -6: `app/(sales)/quotes/create.tsx` (passes `isDraft={edit.isDraft}` to `MainInfoStep`), `components/sales/quote-create-main-info.tsx` (`isDraft` prop, `useRepriceDraftResources(isDraft)`, `selectCustomer` reads the effective list from the store before and after `patch`, re-prices only when the key changed), `features/sales/use-reprice-draft-resources.ts` (doc comment only). No test file, no non-mobile file.

### Gates I ran
- `pnpm nx build @tcg/shared --skip-nx-cache` -> pass (not a cache hit).
- `pnpm exec tsc -p <scratchpad>/tsconfig.mobile.json` (apps/mobile override) -> exit 0, 0 errors. Stock `@tcg/mobile:typecheck` not run (worktree symlink artifact, as before).
- `pnpm exec eslint` on the 15 U4-touched files (apps/mobile) -> exit 0, 0 errors, 3 warnings (`set-state-in-effect`, `create.tsx:135,145,146`, pre-existing, not in the Q4 hunks).
- `pnpm exec prettier --check` on the 3 Q4 files -> clean. `git diff --check f0102809e f1759d174` -> exit 0.
- `pnpm exec jest -c <scratchpad>/jest.mobile.json` full apps/mobile -> 333 suites / 3350 tests pass, same as before the Q4 change. Direct jest, no cache.
- `git diff --name-status f0102809e f1759d174 | grep '^A'` -> only `price-list.ts`, `use-hydrate-reference-rates.ts`, `use-reprice-draft-resources.ts` (no test file); `git diff --name-only f0102809e f1759d174 | grep -v '^apps/mobile' | wc -l` -> 0; `git log -1 --format='%an <%ae>%n%B' f1759d174 | grep -iE 'co-authored|claude|anthropic|generated'` -> no match (exit 1). The existing `quote-create.helpers.test.ts` was edited in U4's first commit, not in the Q4 amend.
- My own temporary probe `apps/mobile/features/sales/zz-probe-q4r.test.tsx` (real `create.tsx`, real customer picker, real Resources step, real store and hooks, `services.resourceCatalog.resolveRate` spied, mock customers CUST-00001 Standard / 00002 Premium / 00003 no list), 7 tests, all pass, **file deleted, `git status --short` empty afterwards (VERIFIED)**. Copy of its header taken from the executor's probe `.bak` in the scratchpad; the test bodies are mine.

### Q4-1: does the fix close finding 1 / probe B? Yes. [VERIFIED by my probe, run against f1759d174]
- Probe B re-run: line A at rate 80 / reference 80 (Standard, `price_list_item`) and typed-over line T at 95 / reference 80; go to step 2 (Resources mounted, price-list picker visible), back to step 1, pick CUST-00002 (Premium): `resolveRate` called once, `priceListName: 'Premium'`; A is now 120 with reference 120; T stays 95; store list `Premium`. (Before: 0 calls, A stayed 80.)
- Same customer re-picked: 0 calls. Customer with no list (CUST-00003): 1 call with `priceListName` undefined, source `master`, A 100 `billing_code`. `resolveRate` rejecting, then pick CUST-00001: 1 call with `Standard`, A byte-identical (JSON compare), list `Standard`.
- Non-draft: SENT edit (QUOT-00135), customer change -> 0 calls. DRAFT edit (QUOT-00142), customer change -> 1 call. Both through `create.tsx`'s real `isDraft`.

### Q4-2: manual Master, then re-pick the same customer -> reverts to the customer's list and re-prices. Correct, and the same as web.
- [VERIFIED, probe] New quote, line A at Standard 80; picker -> Master (A 100, 1 call); Back to Main Info; re-pick CUST-00001: store `priceListSource` `customer`, list `Standard`, 1 call with `Standard`, A back at 80.
- [VERIFIED by reading, not run] Web `applyCustomerSelection` (`apps/web/src/features/quotations/views/create-quotation-form-utils.ts:69-95`) sets `customerPriceList` and `priceListSource: customerPriceList ? 'customer' : 'master'` unconditionally on every customer select, with no memory of a manual Master choice. Mobile does the same for a new quote. For a reopened quote, the same customer restores the saved list and source (Q1 = A, `priceListForCustomer`; unchanged and not touched by Q4). The reverted state is consistent with what the customer field then says; no surprise relative to web.

### Q4-3: regressions
- R1, race between a customer-change re-price and another re-price. [VERIFIED, probe] (a) Customer change to Premium left pending (deferred promise), then customer back to Standard (resolves at once), then the Premium answer lands: store list `Standard`, A 80/ref 80, requests `['Premium','Standard']`. Late answer dropped; D11 holds. (b) Premium pending, then Resources picker -> Master, then the Premium answer lands: A 100, source `master`, requests `['Premium','MASTER']`, exactly 2. (c) Premium pending, user leaves Main Info (step 2, `MainInfoStep` unmounted), answer lands: A 120. The write goes through `useQuoteCreateStore`, not through component state, so unmount does not lose or break it.
- R2, hydration still in flight when the customer changes. [VERIFIED, probe] Reopened DRAFT, line with `referenceRate: null` (hydration for `Standard` deferred), customer changed on Main Info before the answer, then the hydration answer lands: list `Premium`, A rate 80, reference 80, requests `['Standard']` only. The line is ineligible at the change (no reference), so it is skipped, then hydration writes the OLD list's rate as its reference, so it looks priced and un-typed-over, but sits at Standard's rate under Premium and nothing re-prices it. This is finding 4D, now reachable from Main Info too. A reopened quote opens on Main Info, which makes this the first screen where a user can change the customer while hydration (fired at load) is still pending, so it is likelier than the picker version (seconds on a slow network, nothing on a normal one). Not new code from Q4; Q4 did not make it worse, it exposed one more entry. Follow-up, see Q4-5.
- R3, stale closure on the key. [VERIFIED, probe, behaviour] `selectCustomer` reads the list key from `useQuoteCreateStore.getState()` before and after `patch`; the probe shows `patch` is synchronous (the after-read sees the new list, re-price pinned to it). No prop-captured `form` is used for the key. One prop read remains, `form.savedPriceList` passed into `priceListForCustomer` (Main Info line 134); [INFERRED] that is safe because `savedPriceList` is written only by edit load, before the user can tap, so it cannot be stale at tap time.
- R4, `isDraft` wiring. [VERIFIED, probe] New quote: re-prices (`isDraft` = `editQuoteNo === null`, `create.tsx:158`). DRAFT edit: re-prices. SENT edit: 0 calls. [VERIFIED, grep] `grep -rn "MainInfoStep" apps/mobile --include=*.ts --include=*.tsx` -> only the component and `create.tsx`; no other call site missing the required prop (tsc also exit 0).
- R5, two mounts of the hook, double fire. [VERIFIED, grep and probe] `grep -n "useRepriceDraftResources" -r apps/mobile/{app,components,features}` -> mounted in `quote-create-resources.tsx:104` and `quote-create-main-info.tsx:116`. `create.tsx:540-548` renders `step === 1` and `step === 2` exclusively, so only one is mounted. Each mount builds its own `useApplyResolvedRates` and `useResolveRate`, but the re-price is invoked from one handler per user action. Probe: one eligible line, one customer change -> exactly 1 resolve call; picker -> 1 call. No duplicate request. A customer change followed by a picker switch is two separate list changes and legitimately 2 requests (R1b).
- R6, other side effects of the customer change. [INFERRED, reading] job site and contacts are cleared as before; `priceListForCustomer` unchanged. A customer swap to another customer with the same list name leaves the key equal and re-prices nothing, which is correct (rates already from that list). Re-price overwrites the line's surcharge percent with the new list's (existing re-price behaviour, Q2 = A covers only typed-over lines).

### Q4-4: original gates re-confirmed
See the gates block above. Tsc 0 errors, eslint 0 errors, jest 333 / 3350 pass, prettier and diff-check clean.

### Q4-5: remaining follow-ups, is any a money-moving must-fix? No. Plainly:
- Stale-rate race C (pick in flight) and D (hydration in flight), now with the Main Info entry (R2): a line can end up at the old list's rate under the new list, silently. Window is the length of one network request; D needs the customer or list to be changed while the edit-load hydration is still pending. [INFERRED] The Main Info version of C (pick, then customer change before the answer) is the same shape as the picker version I verified earlier; I did not run it again. Not a must-fix in my judgement because it needs a request in flight and a second action inside that window, a save is not blocked, and a salesperson sees the rate on the Resources step before saving; but it is the one most worth fixing next, in one change: drop a hydration or pick write whose list differs from the list now in force, and re-run for that line. If the owner wants zero tolerance for wrong-list rates, it is a must-fix by that standard. Owner call.
- Non-disabled "No Customer Price List" row: pressing it does nothing (probe E, earlier: 0 calls, form unchanged). Visual only.
- Legacy mobile quotes: lines saved with billing-code rates under a list customer read as typed-over after hydration, so neither a customer change nor a picker switch re-prices them. Same as web. Visible to testers, not a defect.
- Mock `resolveRate` ignores `priceListName`: mock-mode demo cannot show list pricing.
- Web chips (D14), shared-package home for the picker rules, re-price on open (spec section 13).
None of these writes a wrong rate on the happy path.

### Q4-6: scope and hygiene
No new test file (VERIFIED, commands above), no AI attribution in the commit (VERIFIED), mobile-only (VERIFIED: 0 non-mobile files, no dependency change). Spec section 12 Q4 and `pr-description-U4.md` decision 5 describe the applied behaviour, including the "manual Master then same customer re-pick re-prices" consequence. No `.ai/claude` or template file touched.

### Hazard list, Q4 delta
Isolation, impersonation, timezone, enum, migration, contract, permissions: not triggered (3 mobile files, no API/schema/shared). Test IDs: none added or renamed (probe used existing `qc-customer*`, `qc-price-list*`). Unconfirmed x permanent: nothing permanent. Unsourced decisions: the 'draft only' guard and 'key changed' condition trace to Q4 = A ("the same re-price the Price List picker uses"); `isDraft` for Main Info is decision 5.

### Not checked
Emulator or device; real API and real latency (races use deferred promises); web run (web customer-select read, not run); stock `@tcg/mobile:typecheck` and stock `nx test` on a normal clone; Main Info version of race C (pick in flight, then customer change), not run; a draft with many lines on a slow network; the server below-rate approval flow.

### Least confident about
Q4-5's call that R2 is not a must-fix. It rests on the window being short and the salesperson seeing rates on the next step; on a bad connection hydration can stay pending for longer than people stay on Main Info, and the failure is silent. If the owner reads "never a wrong-list rate" strictly, R2 and race C should be fixed before ship. Second: Q4-2 treats web as the reference for "revert to the customer's list"; I read it, did not run it.

### If this breaks in 3 months, most likely because [INFERRED]
A third trigger (for example a quote-level "customer's list changed" refresh, or re-price on open) is added that calls the re-price without the same list-key guard, or the one-shot design (no re-run when a pick or hydration answer lands) keeps leaking stale rates as more entry points to a list change appear. A guard in the answer path, rather than at each trigger, would stop that.

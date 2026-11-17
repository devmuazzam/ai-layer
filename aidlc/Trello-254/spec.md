# Spec — Trello-254 Mobile tweaks [quotation module]

> Written to `.ai/aidlc/Trello-254/spec.md` by the elaborator
> (`.ai/aidlc/agents/inception/tcg-elaborator.md`) from `intent.md` beside it.
>
> **The reference is web.** The owner (Syed Haris, 2026-11-16, in `intent.md` §4) designated
> web as the specification for all five card lines ("just like we have in web"). So Sources
> below lead with the card and the owner's answer; web files appear under *Notes for the
> executor* and in §11b as the **reference implementation, described not cited as intent**.
> Where web and a vault document disagree, that is a §12 question (Q1, Q2); everything else
> that web settles is a §11b decision, not a question.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `Trello-254` (Trello card #254, https://trello.com/c/4gh3HypZ) — "Mobile tweaks [quotation module]" |
| Intent | `.ai/aidlc/Trello-254/intent.md`, captured `2026-11-16` (card has no acceptance criteria, no comments; owner answers of the same date are in §4 of the intent) |
| Elaborated on | `2026-11-16` |
| Vault state at elaboration | 891 `.md` files under `.ai/vault/`; six `domain/` SOP files verified, none touches this ticket; the vault says nothing about yard search, required marks, scroll-to-error or zip format. It has one open entry on price-list-on-edit (`quotations/gaps.md` → *Should editing a quotation adopt the customer's current price list?*) and one VERIFIED decision on the surcharge (`decisions/2026-09-02-one-surcharge-per-quote.md`). |
| Open questions raised by this spec | 2, both in §12, **both answered A by the owner, 2026-11-16** (were non-blocking) |
| Already-shipped behaviour reached | 13 consumers in §11a; 0 with no source for what happens to them (owner's "mirror web" is the source; the two web-vs-vault tensions are Q1, Q2) |
| Live ticket re-read | **Not done** — no Trello/Jira tool in this session; the intent was captured the same day (2026-11-16) and the card was not re-diffed live. Re-check the five card lines before sign-off. |
| Conflict stub | `quotations/quotations-INDEX.md` (2.7 KB) read: its four candidates (flow, user stories, two punch lists) say nothing about price lists, yard search, required marks, scroll or zip, so none is a source and no REQ here is `[CONFLICT]` on its account. |
| Rules consulted | `.ai/claude/contexts/mobile.md`, `.ai/claude/contexts/web.md` (Forms), `.claude/CLAUDE.md` (Departments and roles, Business time, Siblings, No new tests); `contexts/api.md` and `prisma.md` not needed — no API or schema change |

**Delivery (already decided by the owner, not re-asked):** one ticket folder, four units, each its own PR off
`staging`, dependent units stack. §11b D20 suggests a slicing; the decomposer decides.

**Size check (`tcg-elaborator.md` §1):** 7 REQs and 4 units are inside the epic ceiling (~8 / ~6); the file is ~64 KB, over the ~40 KB guide, because §11a/§11b carry the web price-list description and the per-site ripple. No split proposed: the owner fixed one ticket / four units, and the units are independent.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Yard dropdown on the quote builder is searchable | mobile | `[UNVERIFIED]` | `Trello-254`, intent §4 owner | no |
| REQ-02 | Every required-field asterisk on mobile sales screens renders red | mobile | `[UNVERIFIED]` | `Trello-254`, intent §4 owner | no |
| REQ-03 | Price List picker on the Resources step; the quote saves the chosen list and source | mobile | `[UNVERIFIED]` | `Trello-254`, intent §4 owner; `quotations/gaps.md` (related, open) | no (Q1 answered A) |
| REQ-04 | Rate resolution uses the quote's effective price list | mobile | `[UNVERIFIED]` | `Trello-254`, intent §4 owner; `decisions/2026-09-02-one-surcharge-per-quote.md` `[VERIFIED]` | no |
| REQ-05 | Switching the list re-prices a draft's priced, un-overridden lines | mobile | `[UNVERIFIED]` | `Trello-254`, intent §4 owner; `decisions/2026-09-02-one-surcharge-per-quote.md` `[VERIFIED]` | no (Q2 answered A) |
| REQ-06 | A failed Next/Save scrolls the quote builder to the first invalid field | mobile | `[UNVERIFIED]` | `Trello-254`, intent §4 owner; `.ai/claude/contexts/web.md` → Forms (rule) | no |
| REQ-07 | Mobile address forms validate the US zip code with the web rule | mobile, shared | `[UNVERIFIED]` | `Trello-254`, intent §4 owner | no |

Counts: `7` total — `0` verified, `7` unverified, `0` conflicted, `0` open. (REQ-04 and REQ-05 cite a `[VERIFIED]`
decision, but a requirement takes its worst source.)

**None of the 7 is `[OPEN]` and none is `[CONFLICT]` in the stub sense.** Q1 and Q2 mark two places where web's behaviour
sits against what the vault says; each REQ is buildable on web's behaviour now and re-openable by one line.

## 2. Requirements

### REQ-01 — Yard dropdown on the quote builder is searchable `[UNVERIFIED]`

- **Statement:** The Yard field on the mobile quote builder's Main Info step lets the user type to filter the yard list, whatever the number of yards.
- **Surface:** mobile
- **Sources:**
  - `Trello-254` — `[UNVERIFIED]` — kind: jira (Trello card) — "Add searching for yard lookup."
  - `Trello-254` intent §4 owner answer — `[UNVERIFIED]` — kind: jira — web is the reference.
- **Conflict:** none
- **Open question:** none
- **Ripple:** Only the Yard instance of `Select` changes. Enumerated by `grep -n 'Select\b' apps/mobile/components/sales/quote-create-main-info.tsx` and `grep -rn '<Select' apps/mobile --include=*.tsx`: the other pickers on the screen are `AsyncSearchSelect` (customer, job site, contacts, salesperson, coordinator, taken-by — already searchable) or plain `Select` with <8 options (billing type, industry — unchanged). The shared `Select` primitive is untouched. Source: owner "mirror web".
- **Acceptance:** On the Main Info step, tapping Yard opens the sheet with a "Search…" box even when only 2 yards exist; typing a fragment of a yard name narrows the list; clearing it restores all; picking a result still sets `form.yard` (name) and `form.yardUuid` (uuid) exactly as today; an empty result shows "No matches".
- **Edges:**
  - **Reached by:** the Yard `Select` (`testID="qc-yard"`) in `QuoteInfoCard`; edit mode shows a saved yard that is no longer active via the existing fallback (`selectedYardId` falls back to the saved name).
  - **Does not apply when:** other `Select`s on the screen (keep the 8+ default); the web "Suggested: <yard> — Use" chip (web-only, `useYardSuggestion` — not in this ticket, §13).
  - **When an input is absent:** no yards loaded → sheet shows "No matches" as today.
  - **Trust boundary:** N/A — server-derived list (`GET /yards`, already fetched).
  - **Read time:** N/A — a picker, not catalogue data shown on a record.
- **Notes for the executor:** one prop — `searchable` on the Yard `Select` in `apps/mobile/components/sales/quote-create-main-info.tsx` (`QuoteInfoCard`, yard `<Select>` ~l.507). The list is already fully loaded (`useYards` → `GET /yards`, `take: 500`, active filter), so filtering client-side is enough (§11b D2). Web reference (descriptive): `apps/web/src/features/quotations/components/molecules/quote-yard-select.tsx` uses `YardSelect`, a server-searched combobox, placeholder "Search yard".

### REQ-02 — Every required-field asterisk on mobile sales screens renders red `[UNVERIFIED]`

- **Statement:** Wherever a mobile sales screen marks a field required with an asterisk, the asterisk is drawn red, as a mark beside the label rather than as part of the label text.
- **Surface:** mobile
- **Sources:**
  - `Trello-254` — `[UNVERIFIED]` — kind: jira — "Mark all asterisk as red in quotation module and other modules."
  - `Trello-254` intent §4 owner answer — `[UNVERIFIED]` — kind: jira — scope is the whole sales surface: quotes, customers, projects, email compose, billing-code and custom-type sheets.
- **Conflict:** none
- **Open question:** none
- **Ripple:** 25 hard-coded sites in 8 files (list in §11a row 7, enumerated by `grep -rn 'label="[^"]*\*"' apps/mobile/{app,components,features,design-system}` = 24 sites in 7 files, plus `grep -rnE '[A-Za-z)] \*[\x27"`<{]'` which adds the template literal `` `${field.name} *` `` at `components/sales/quote-create-additional-info.tsx:193`). No asterisk exists outside the sales surface (same greps over all of `apps/mobile`). One existing test asserts the old text: `app/(sales)/quotes/create.resources.test.tsx:485` `getByText('Max Radius (ft) *')` — its assertion becomes `'Max Radius (ft)'` (recorded; no new tests). Every other test greps clean for ` *`.
- **Acceptance:** On each of the 25 sites the label text no longer contains `*` and a red `RequiredMark` follows it; the label reads exactly "Yard", "Customer Name", "Max Radius (ft)" etc.; no field gains or loses a mark (§11b D3); field-ticket screens are untouched.
- **Edges:**
  - **Reached by:** every sales `Field` listed in §11a row 7; the dynamic Additional Info fields (`DynamicField`, all five type branches build `<Field label={label}>`).
  - **Does not apply when:** field-ticket screens, which already use `required` (`RequiredMark`, `RequiredLabel`); fields with no asterisk today (not marked, not added).
  - **When an input is absent:** `Field` with no label renders no mark (unchanged).
  - **Trust boundary:** N/A — UI only. For Additional Info the required flag is `field.isRequired` from the template, as today.
  - **Read time:** N/A.
- **Notes for the executor:** use `Field`'s `required` prop (`apps/mobile/design-system/primitives/field.tsx`), which renders `RequiredMark` as a **sibling** of the label `<Text>` — its own doc comment says never nest it, so `getByText('<label>')` stays exact. Change `label="X *"` → `label="X" required` at each site, and `<Field label={field.name} required={field.isRequired}>` in `DynamicField`. Mind the `Field` instances that pass `style` / `error` — only the label props change.

### REQ-03 — Price List picker on the Resources step; the quote saves the chosen list and source `[UNVERIFIED]`

- **Statement:** The Resources step shows a Price List dropdown above the lines offering the quote's saved list, the customer's current list and Master List; the choice is what the quote saves as `priceList` and `priceListSource`.
- **Surface:** mobile
- **Sources:**
  - `Trello-254` — `[UNVERIFIED]` — kind: jira — "Add price list lookup in quotation resources."
  - `Trello-254` intent §4 owner answer — `[UNVERIFIED]` — kind: jira — "mirror web's Price List dropdown above the resources: quote's list / customer's current list / Master, re-pricing lines."
  - `quotations/gaps.md` → *Should editing a quotation adopt the customer's current price list?* — `[UNVERIFIED]` — kind: vault — **related, open**; it asks whether a reopened quote keeps its saved list; it does not define the picker. Cited as search record, not as support.
- **Conflict:** none (the related open entry is Q1; it does not stop REQ-03). `quotations/billing-code-and-price-list.md` carries a non-empty `conflicts_with` and says nothing about switching a quote's list, so it is **not** a source here.
- **Open question:** Q1 — answered A, 2026-11-16: a reopened quote keeps its saved list.
- **Ripple:** the `form.priceList` readers and the payload (§11a rows 1–4). The save payload's `priceListSource` today is **derived** (`'customer'` iff `form.priceList === form.customer.priceList`, else `'master'`); it becomes an explicit stored field. Source for the change: owner "mirror web" (web sends the stored mode).
- **Acceptance:**
  1. On the Resources step a "Price List" control sits above the lines. Options, top to bottom: the quote's saved list (edit mode, same customer only), the customer's current list, then "Master List". When saved and current differ in name (case-insensitive) they read "<name> (Quoted)" and "<name> (Current)"; otherwise plain names. A customer with no list and a new quote shows a disabled "No Customer Price List" plus "Master List".
  2. Choosing a named list sets `priceList = <name>`, `priceListSource = 'customer'`. Choosing Master sets `priceListSource = 'master'` and **keeps** `priceList` as the name already held (web does not clear it).
  3. Save sends `priceList: <trimmed name> || null` and `priceListSource` as stored (`'customer'` or `'master'`); never derived.
  4. Selecting a customer sets `priceList = customer.priceList ?? ''` and `priceListSource = 'customer'` if that is non-empty, else `'master'` (matches web `applyCustomerSelection`); existing job-site/contact reset unchanged.
  5. Edit mode loads `priceList` and `priceListSource` from the saved quote (`'master'` stays `'master'`, anything else `'customer'`), and the picker's "quoted" option is that saved list.
  6. The read-only Price List field on Main Info keeps showing `form.priceList`; the running-total subtitle shows "Master List" when source is `master`, else the list name (§11b D15).
- **Edges:**
  - **Reached by:** the new picker; customer selection (`selectCustomer`); edit-mode hydration (`mapQuotationToDraft`); the save payload builders (`buildCreatePayload`, `buildUpdatePayload` via `buildEditableFields`).
  - **Does not apply when:** a quote locked WON/LOST (cannot be edited on mobile — `EDIT_LOCKED_STATUSES`); the web Discount, Until and Surcharge chips (excluded, §11b D14).
  - **When an input is absent:** no customer selected → ASSUMED: picker shown with the disabled "No Customer Price List" row plus Master List (the Resources step is reachable only after Main Info validates a customer, so this is a safety case); a customer with no list → `priceListSource = 'master'`.
  - **Trust boundary:** both fields are client-supplied; the API validates `priceList` ≤100 chars and `priceListSource ∈ {customer, master}` (`apps/api/src/presentation/quotations/dto/create-quotation.dto.ts:463-469`). The server does not check the name against the customer — unchanged from today.
  - **Read time:** `live` while a draft is being built; the picker's list name and source are **frozen at save**; the rates are frozen on each line once saved (a sent quote does not re-price — REQ-05).
- **Notes for the executor:** add `priceListSource: 'customer' | 'master'` to `QuoteDraft` (`quote-create.store.ts`, default `'customer'`); add `priceListSource` (nullish string) to the `Quotation` schema in `data/contracts/quotation.contract.ts` (mobile zod; the API already returns the column `priceListSource`, `schema.prisma:1725`) and map it in `quotation-edit-mapper.ts`; replace the derivation at `quote-create.helpers.ts` ~l.436-454. The picker lives in `quote-create-resources.tsx` (`ResourcesStep`), using the existing `Select` (3 options needs no search). Web reference (descriptive): `apps/web/src/features/quotations/components/organisms/resources-pricing-chips.tsx` (`buildPriceListOptions`, `handlePriceListSelect`), `views/create-quotation-form-model.ts` (`handlePriceListUpdate` — same customer restores saved list and source), `views/create-quotation-form-utils.ts:86-89`, `views/create-quotation.helpers.ts:533-534`.

### REQ-04 — Rate resolution uses the quote's effective price list `[UNVERIFIED]`

- **Statement:** Whenever the mobile builder resolves a line's rate (item pick, billing-code created, re-price), it asks for the quote's effective list — the chosen list, or none when Master is chosen — so a line is priced from that list rather than always from the billing code.
- **Surface:** mobile
- **Sources:**
  - `Trello-254` intent §4 owner answer — `[UNVERIFIED]` — kind: jira — mirror web, which resolves with the effective list.
  - `decisions/2026-09-02-one-surcharge-per-quote.md` — `[VERIFIED]` — kind: decision — "A price list replaces the rate; it never adds a second surcharge"; the rate is per quote, membership per line.
  - `decisions/2026-10-15-existing-associations-hidden-sub-items-auto-fill-at-zero-one-pair-per-crane.md` row 4 — `[UNVERIFIED]` (`status: reference`, not verified) — kind: decision — a new line is priced "the customer's price list, else the billing code".
- **Conflict:** none
- **Open question:** none
- **Ripple:** **This changes what mobile prices today.** No mobile resolve call passes `priceListName`, so every mobile line for a customer on a price list resolves from the billing code, even though the quote saves `priceListSource: 'customer'`. After this REQ those lines resolve from the list. Consumers: `use-resource-item-selection.ts` (item pick), `quote-create-resources.tsx` (`handleBillingCodeCreated`), the re-price in REQ-05, and TCG-219's unmerged `use-apply-resolved-rates.ts` (§11a rows 2–3). Source: owner "mirror web".
- **Acceptance:** With a customer on list "Preferred", picking an item sends `GET /price-listings/resolve-rate?…&priceListName=Preferred` and the line takes the list's rate, discount and surcharge when the list has the item (`source: 'price_list_item'`), else the billing code (`'billing_code'`); with Master chosen the request carries no `priceListName`. The same item resolved under two different lists within 5 minutes returns two different results (the cache key includes the list).
- **Edges:**
  - **Reached by:** item pick; "create billing code" from a row; REQ-05's re-price; (TCG-219) quotation-type switch.
  - **Does not apply when:** Master chosen (no `priceListName`); lines with no FK (manual lines).
  - **When an input is absent:** no list → no `priceListName`, as today.
  - **Trust boundary:** list name is client-supplied; `resolve-rate` accepts `priceListName` (`apps/api/src/presentation/price-listings/dto/resolve-price.dto.ts:37`, max 255) and falls back to the billing code when the list lacks the item.
  - **Read time:** frozen at resolve; stored on the line.
- **Notes for the executor:** `ResolveRateParams` already has `priceListName?` and the HTTP service forwards `params` untouched (`resource-catalog.http.ts:72`). The **only** blocker is the query key: `queryKeys.resourceCatalogResolveRate(sub, role, custom)` (`data/hooks/query-keys.ts:67`) omits the list, so a 5-minute cached result for one list would be served for the other. Add the list name to the key and have `useResolveRate` (`data/hooks/use-resource-catalog.ts:80`) pass it through. **No API change** (§4).

### REQ-05 — Switching the list re-prices a draft's priced, un-overridden lines `[UNVERIFIED]`

- **Statement:** When the user changes the Price List on a new or draft quote, every line that was priced from the catalog and whose rate the user has not typed over is re-resolved against the new list; other lines are left alone.
- **Surface:** mobile
- **Sources:**
  - `Trello-254` intent §4 owner answer — `[UNVERIFIED]` — kind: jira — "re-pricing lines", web is the reference.
  - `decisions/2026-09-02-one-surcharge-per-quote.md` — `[VERIFIED]` — kind: decision — one surcharge rate per quote; the price list replaces it. **This is the document web's override rule sits against — see Q2.**
  - `quotations/gaps.md` → *Should editing a quotation adopt the customer's current price list?* — `[UNVERIFIED]` — kind: vault — its 2026-09-17 note: Brian's FCC recommendation to freeze a saved line's resolved rate "supports keeping a saved quotation's rates. It does not say what an edit should do to the quotation's price-list **selection**. Not a ruling." Consistent with draft-only re-pricing; not a source for it.
- **Conflict:** none declared; the tension with the VERIFIED decision is Q2.
- **Open question:** Q2 — answered A, 2026-11-16: a typed-over line keeps its old surcharge percentage after a switch.
- **Ripple:** every priced line of the draft being edited (store rows `updateResource`), the running total and the Additional Info grouping reading line amounts (`quotation-pricing.ts` `syncResourceAmount`-equivalent recompute). Sent/approved quotes are untouched (§11b D9). No other consumer.
- **Acceptance (exactly what web does — §11b D8; mobile mirrors each point):**
  1. **Gate:** re-pricing runs only for a **draft** — a new quote, or an edit whose status at load was `DRAFT`. Never for any other status.
  2. **Eligible line:** `pricingSource` is `price_list_item` or `billing_code`; it has a catalog FK (sub-category, role or custom type); its `referenceRate` is known; `|rate − referenceRate| ≤ 0.005` (not typed over). Child lines are included. A line with `pricingSource` `none`/null (manual) is never touched.
  3. **Re-resolve:** each eligible line is resolved with `priceListName` = the new list, or none for Master. A result with `source ≠ none` replaces `rate`, `unitMeas`, `discountPercentage`, `discountValidUntil`, `priceHikePercentage` (discount and hike fields only when `source === 'price_list_item'`, else set to null), `surchargeEnabled`, `surchargePercentage`, `pricingSource`, and `referenceRate := rate`; the line amount is recomputed.
  4. **Typed-over lines survive:** a line whose rate differs from its reference keeps its rate **and everything else on it**, including the surcharge percentage (this is Q2).
  5. **`none` result:** the line resets to rate 0, discount/hike null, surcharge off, `pricingSource: 'none'` (the existing "billing code missing" hint and validation then apply).
  6. **Fetch error:** the line is left exactly as it was (**differs from web**, which zeroes it — §11b D10).
  7. **Round trip:** list A → Master → A re-prices at each step (no "already tried" memory).
  8. **Order safety:** a response that arrives after the user has switched again is discarded (§11b D11).
  9. Nothing is saved by the switch itself; the new list/source and the new rates persist only on Save.
- **Edges:**
  - **Reached by:** the Price List picker only. Item pick resolves the new line with the then-current list (REQ-04). Edit-hydration does **not** re-price (§13).
  - **Does not apply when:** a non-draft status at load; lines with `none`/null source; lines with no FK; the TCG-219 Mob/Demob "price adjustment" custom type that is hand-priced (that branch merges later; the `pricingSource` gate already excludes manual lines).
  - **When an input is absent:** a line with `referenceRate === null` is **not** re-priced until its reference is known — edit-loaded lines start with `referenceRate: null` (`quotation-edit-mapper.ts:165`), so the executor must hydrate it first (§11b D12); without that the switch would silently do nothing on an edited draft.
  - **Trust boundary:** rates, surcharge and discounts are server-resolved; the client only sends the list name.
  - **Read time:** frozen once saved; a sent quote is "the customer's document" and never re-prices (web's own comment; owner mirrors web).
  - **Matrix:** N/A — no twin/mirror semantics in this ticket (the TCG-219 Mob/Demob pairs re-price through the same per-line path once that merges).
- **Notes for the executor:** reuse `useResolveRate` and the field set already written by `use-resource-item-selection.ts` ~l.104-124 (and, on TCG-219, `use-apply-resolved-rates.ts`, which does the same update for a list of ids — see the overlap in §11b D19; build U4 on top of it once merged rather than writing a second copy). Web reference (descriptive): `apps/web/src/features/quotations/hooks/use-reprice-draft-resources.ts` (eligibility, 0.005 epsilon, attempt reset on list change), `hooks/use-resource-pricing.ts` (`resolveAndApplyRate`, query key includes the list), `components/organisms/resources-tab.helpers.ts` `applyResolvedPricing` (fields written), `hooks/use-hydrate-reference-rates.ts`; gate `isDraft = mainValues.status === 'DRAFT'` at `resources-tab.tsx:106-112`.

### REQ-06 — A failed Next/Save scrolls the quote builder to the first invalid field `[UNVERIFIED]`

- **Statement:** When Next or Save is blocked by validation on the quote builder, the screen scrolls so the first invalid field's message is in view.
- **Surface:** mobile
- **Sources:**
  - `Trello-254` — `[UNVERIFIED]` — kind: jira — "Auto scroll to the erroneous fields."
  - `Trello-254` intent §4 owner answer — `[UNVERIFIED]` — kind: jira — "On a failed step (Next / Save), the quote builder scrolls to the first invalid field."
  - `.ai/claude/contexts/web.md` → *Forms* — `[UNVERIFIED]` — kind: rule — "On failed submit: scroll to and focus the first invalid field, and on multi-step or tabbed forms navigate to the offending step first." (Binding on how, not what.)
- **Conflict:** none
- **Open question:** none
- **Ripple:** the quote-builder screen and its six plain-`Text` error sites (§11a row 9); web unchanged.
- **Acceptance:**
  1. Step 1 (Main Info): a blocked Next/Save with Yard, Customer or Job Site missing, or End Date before Start, scrolls to the topmost message. These already render through `Field error`, so they register.
  2. Steps 2 and 3: a blocked press scrolls to the first row error. The six error lines at `quote-create-resources.tsx:388, 491, 690, 691` and `quote-create-tools.tsx:178, 207` are plain `<Text style={styles.errorText}>` and do **not** register today; they become `FieldError` (same message text).
  3. Step 4 (Additional Info): a blocked press shows an inline "Required" message under each unmet required field, and scrolls to the first one. Today step 4 renders no inline errors at all, only a toast.
  4. Pressing again with the errors unchanged scrolls again (the trigger is a counter bumped on every blocked press, not a boolean).
  5. When `save()` sends the user back to an earlier step, the scroll targets that step's first message.
  6. The Add New Job Site sheet (also a failed-submit form) scrolls to its first message through its existing `BottomSheet` `scrollToErrorSignal` prop.
- **Edges:**
  - **Reached by:** `next()` (all four blocked branches, plus the Additional Info one) and `save()` (all blocked branches) in `app/(sales)/quotes/create.tsx`; `AddJobSiteSheet` submit.
  - **Does not apply when:** a block that has no inline message — the over-limit toasts (`resourcesExceedLimit`, `toolsExceedLimit`) — nothing to scroll to, toast only (unchanged). Nested bottom sheets (customer/job-site pickers) keep their own registry.
  - **When an input is absent:** no registered error node (or node measure fails) → no scroll, no crash.
  - **Trust boundary:** N/A — client UI.
  - **Read time:** N/A.
- **Notes for the executor:** the primitives already exist in `apps/mobile/design-system/primitives/field-error-scroll.tsx` and are exported from `@/design-system` (`useScrollToFieldError`, `FieldErrorScrollProvider`). In `create.tsx` wrap the content of the `ScrollView` (~l.486) in a content `View` ref + `FieldErrorScrollProvider`, hold a `useState` counter, and bump it in every blocked branch, in the same handler that calls `markAttempted` so the nodes render before the effect measures. **Do not import `useStepValidation`/`StepBodyShell` from `features/field-ticket`** — a cross-feature dependency for a counter (§11b D16). For step 4 add a `showErrors` prop to `AdditionalInfoStep`/`DynamicField` mirroring steps 1–3, error copy `Required` (ASSUMED — the nearest existing mobile behaviour, `quote-create-add-job-site-sheet.tsx`). The 25-site `Field` conversion of REQ-02 touches the same lines; do U1 first or rebase.

### REQ-07 — Mobile address forms validate the US zip code with the web rule `[UNVERIFIED]`

- **Statement:** On every mobile form that takes a zip code, a non-empty value must be a US ZIP (`12345` or `12345-6789`), typed values are auto-formatted, and an invalid value blocks the form's Next/submit with the web message.
- **Surface:** mobile, shared (helper location is §11b D4)
- **Sources:**
  - `Trello-254` — `[UNVERIFIED]` — kind: jira — "There is no validation for zip code for addresses in mobile just like we have in web."
  - `Trello-254` intent §4 owner answer — `[UNVERIFIED]` — kind: jira — all mobile address forms: quote add-job-site sheet, customer create (billing zip and job-site zip), any other mobile address form found. Non-US formats are out of scope (intent §5).
- **Conflict:** none
- **Open question:** none
- **Ripple:** the three mobile zip inputs below; the shared package (if the helper moves, web and mobile both compile against it). The API does **not** validate the format today (`job-site.dto.ts:50`, `create-address.dto.ts:38` are `@IsString() @IsNotEmpty() @MaxLength(20)`) — mobile and API therefore agree only on "non-empty, ≤20", and mobile becomes stricter, as web already is. Existing values: customers and job sites already in the database with a non-US or malformed zip are **not** re-validated (display-only screens `customers/[id].tsx` unchanged).
- **Acceptance:** All three inputs below sanitise as the user types (digits only, max 9, hyphen after the 5th); on submit/Next an invalid non-empty value shows `Please enter a valid US zip code (e.g. 12345 or 12345-6789)` under the field and blocks; a valid or empty (where the form allows empty) value passes. `11111-` and `12345-67` are invalid.

  | # | Mobile form | Web today | Mobile today | After this ticket |
  | --- | --- | --- | --- | --- |
  | 1 | Quote builder → New Job Site sheet, `qc-add-site-zip` (`quote-create-add-job-site-sheet.tsx`) | zip required **and** US format (`jobSiteSchema`: `requiredZipCodeSchema()`; its comment says it matches the quotation modal) | required (blank → "Required"); no format check | required (unchanged) **and** format-checked |
  | 2 | Customer create → billing "Zip Code *" (`customers/create.tsx:172`, `form.zip`) | optional; format-checked when entered; required only if any other address field is filled (`customerSchema` all-or-none) | labelled `*`; nothing enforced anywhere on the screen | blank still passes (no required-ness is enforced on this screen today); non-empty is format-checked |
  | 3 | Customer create → job-site "Zip" (`customers/create.tsx:248`, `form.jobSite.zip`) | required **and** format-checked | optional, unmarked; nothing enforced | stays optional (see §11b D5); non-empty is format-checked |

  No other mobile form takes a zip: `grep -rniE 'zip|postal' apps/mobile/{app,components,features,design-system,lib,data}` returns only these three inputs plus read-only displays (`quote-create-main-info.tsx:387,460`, `customers/[id].tsx:148,181`) and mock/contract data.
- **Edges:**
  - **Reached by:** sheet submit (`touched` path); customer-create `Next` on step 1 and step 2 and `Save`.
  - **Does not apply when:** read-only displays; the zip a Places pick fills in on `feat/MOBILE-ADDRESS-PLACES` (it goes through the same state setter and so through the same check — §11b D19); non-US countries — web applies the US rule whatever the country (the job-site form defaults country `US`), so mobile does too (out-of-scope formats stay unsupported).
  - **When an input is absent:** empty is valid where the form already allows it (rows 2 and 3); empty on row 1 is "Required" as today.
  - **Trust boundary:** client-side only; the server accepts any ≤20-char string (above).
  - **Read time:** N/A.
- **Notes for the executor:** helper decision is D4 (recommended: pure functions into `packages/shared`, web's `lib/zipcode.ts` re-exports). Keep `keyboardType="number-pad"` — the sanitiser inserts the hyphen, so the iOS number pad that has no "-" key is enough; set `maxLength` 10. **`customers/create.tsx` saves nothing** — `save()` only shows a "Customer created" toast, `US_STATES` and the lists are hard-coded, there is no API call and no validation of any kind, and the existing `create.test.tsx` presses Next and Save on a blank form (so the zip gate must pass blanks). Adding a zip check there is adding the screen's first validation gate. Do not expand it.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** no
- **Migration required:** no
- **Data backfill required:** no
- **Existing models considered:** `Quotation.priceList` (`@db.VarChar`, ≤100 via DTO) and `Quotation.priceListSource` (`schema.prisma:1725`, `@default("customer")`, `VarChar(20)`) already hold everything REQ-03 saves; `JobSite`/`Address` already hold zip. No new column or table.

N/A — no new models, no new prefix, no child relations, no fields of unstated type.

## 4. API surface — `apps/api`

- **Pattern:** none — no API change.
- **Existing functions/services to reuse:** `GET /price-listings/resolve-rate` (`PriceListingsController.resolveRate`, DTO `resolve-price.dto.ts` already takes `priceListName?`); `POST/PATCH /quotations` already take `priceList` (`@MaxLength(100)`) and `priceListSource` (`@IsIn(['customer','master'])`); `POST` job-site and address DTOs unchanged.
- **New exported functions/services proposed:** none.
- **API change needed: no.** Stated exactly: the rate-resolve endpoint **can** take a price list (`priceListName`, optional string ≤255), it falls back to the billing code when the list has no entry, and the quotation DTOs **can** carry the list and source. The gap is entirely on the mobile client: it never sends `priceListName`, its query key omits it, and its `Quotation` response schema drops `priceListSource` (zod strips unknown keys). Therefore **no G5 contract change**; the mobile response-schema addition is additive and mobile-internal.

## 5. Web surface — `apps/web`

N/A — web is the reference; no web behaviour changes. **One possible exception:** if D4 is taken as recommended, `apps/web/src/lib/zipcode.ts` re-exports the three pure helpers from `@tcg/shared` (same names, no behaviour change; the eight web files that import it do not change). That is an import-only edit, affected-project checks for `@tcg/web` apply.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** `app/(sales)/quotes/create.tsx` (shell, ScrollView ~l.486, `next` l.226, `save` l.318); `app/(sales)/customers/create.tsx`; `app/(sales)/projects/create.tsx`; `app/(sales)/email/compose.tsx`.
- **Components:** `components/sales/quote-create-main-info.tsx`, `quote-create-resources.tsx`, `quote-create-tools.tsx`, `quote-create-additional-info.tsx`, `quote-create-add-job-site-sheet.tsx`, `quote-create-add-custom-type-sheet.tsx`, `create-billing-code-sheet.tsx`; primitives `design-system/primitives/{field,field-error-scroll,select,bottom-sheet}.tsx` reused, none changed.
- **Features/data:** `features/sales/{quote-create.store,quote-create.helpers,quotation-edit-mapper,use-resource-item-selection,customer-create.store}.ts`; `data/contracts/quotation.contract.ts`; `data/hooks/{query-keys,use-resource-catalog}.ts`.
- **Offline / sync behavior:** `NOT SPECIFIED` — and not inferred. Re-pricing needs the network; offline, `fetchQuery` fails and REQ-05 acceptance 6 leaves lines untouched. The save path already refuses offline (`create.tsx` `performSave`).
- **Touch targets:** 48px (existing controls reused).
- **Push / notifications involvement:** N/A.

## 7. Shared package — `packages/shared`

- **Types added / changed:** none.
- **Functions added (recommended, D4):** `isValidUsZipCode`, `sanitizeZipCodeInput`, `US_ZIP_ERROR` in a new `packages/shared/src/utils/zipcode.ts`, exported from `utils/index.ts` (precedent: `city-match.ts`, shared between web and mobile on `staging`). The zod schemas (`optionalZipCodeSchema`, `requiredZipCodeSchema`) stay in web — they pull in `zod/v4` and `@/lib/validation-messages`, which shared must not depend on. `@tcg/shared` is consumed as its built `dist/`: rebuild before mobile/web typecheck.
- **Nothing shared if D4 is taken the other way:** then `apps/mobile/lib/zipcode.ts` holds a copy.

## 8. Permissions and tenancy

- **Roles permitted:** whoever can already create or edit a quotation on mobile (the existing `quotations` module gate on `POST/PATCH /quotations`; mobile quote create/edit already gated). No gate changes.
- **Roles denied:** unchanged.
- **Tenant isolation:** standard middleware; no new tenant model, no new query. `GET /price-listings/resolve-rate` is the endpoint mobile already calls on item pick.
- **Cross-tenant reads:** none.
- **Role/department rules (`.claude/CLAUDE.md`):** no branching on a role or department name anywhere in this ticket; no `isDispatchable`/`quoteApproval`-style flag is consulted or added.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| Zip (3 mobile inputs) | empty OR `^\d{5}(-\d{4})?$` (trimmed); message `Please enter a valid US zip code (e.g. 12345 or 12345-6789)`; input sanitised to digits, hyphen after 5th, max 9 digits | `Trello-254` + owner "like web" (web helper described in REQ-07 notes) | `[UNVERIFIED]` |
| `priceListSource` | `customer` or `master` | API DTO (`create-quotation.dto.ts:466-469`) | `[UNVERIFIED]` |
| `priceList` | ≤100 characters, trimmed, `null` when empty | API DTO (`:463`) | `[UNVERIFIED]` |
| Re-price override tolerance | `0.005` | web rule, owner "mirror web" | `[UNVERIFIED]` |
| Additional Info required-error copy | `NOT SPECIFIED` in any source for mobile — `Required` is `ASSUMED` (REQ-06) | — | — |
| Max zip length on screen | 10 characters (5 + hyphen + 4) — derived from the format, not invented | web `zip-code-input.tsx` | `[UNVERIFIED]` |

## 10. Tests

`not requested` (root `CLAUDE.md`, Haris 2026-10-21). Existing tests are run, not extended. **Assertions that change because the code under them changes** (recorded here; updating them is part of the unit, not a new test):

| Unit | Existing test | Why |
| --- | --- | --- |
| U1 (REQ-02) | `app/(sales)/quotes/create.resources.test.tsx:485` `getByText('Max Radius (ft) *')` → `'Max Radius (ft)'` | the only test asserting a `*` label (grepped across `app`, `components`, `features`, `design-system`) |
| U4 (REQ-03) | `features/sales/quote-create.helpers.test.ts` ~l.246-284 (payload `priceListSource: 'customer'` and *"marks priceListSource as master when the user overrides the customer default"*) | the source is stored, not derived; fixtures need the field |
| U4 (REQ-03) | `features/sales/quotation-edit-mapper.test.ts` (~l.24-48, 179) and `data/contracts/quotation.contract.test.ts` (~l.21-55) | new `priceListSource` field on the draft and the contract fixture; to confirm when the code is written |

Unaffected, checked by grep: `create.main-info.test.tsx:202` types a valid zip (`90802`); `customers/create.test.tsx` presses Next/Save on a blank form (zip empty); `test-helpers` yard flow presses `qc-yard-option-YARD-00001` (option test IDs unchanged by `searchable`).

- Requirements with no testable acceptance criterion: none.

## 11. Non-functional

- **Performance:** a switch fires one `resolve-rate` request per eligible line (web behaves the same, de-duplicated by the 5-minute query cache keyed by list). `NOT SPECIFIED` otherwise.
- **Concurrency:** a switch while a previous re-price is in flight — the stale response is discarded (D11).
- **Audit / activity log:** N/A.
- **Migration/rollout order:** mobile only; if D4 is taken as recommended, shared first (build `@tcg/shared`), then web re-export, then mobile. No backend step; no mobile-release-vs-API ordering problem.

## 11a. Ripple — already-shipped behaviour these requirements reach

| # | Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Main Info read-only "Price List" (`quote-create-main-info.tsx:394`); running-total subtitle (`create.tsx:421`) | `form.priceList` | REQ-03 | unchanged value path; subtitle shows "Master List" when source is `master` (D15) | owner "mirror web" | `grep -rn 'priceList' apps/mobile/{app,components,features} --include=*.ts --include=*.tsx` (non-test) |
| 2 | Item pick re-resolve (`use-resource-item-selection.ts:104`); billing-code-created re-resolve (`quote-create-resources.tsx:614-629`) | `useResolveRate` | REQ-04 | **changes deliberately** — now resolve with the effective list (was always list-less → billing code) | owner "mirror web" | `grep -rn 'useResolveRate\|resolveRate(' apps/mobile --include=*.ts --include=*.tsx` |
| 3 | `queryKeys.resourceCatalogResolveRate` (sole consumer `use-resource-catalog.ts:85`); TCG-219's unmerged `use-apply-resolved-rates.ts` and `use-quotation-type-switch.ts` | query key shape | REQ-04/05 | key gains the list; old-shape cached entries just miss and age out; TCG-219 callers must pass the list when it merges (rebase item) | owner "mirror web" | `grep -rn 'resourceCatalogResolveRate' apps/mobile`; `git diff --stat origin/staging...origin/feat/TCG-219-mobile-mob-demob-parity -- apps/mobile` |
| 4 | Save payload `priceListSource` (`quote-create.helpers.ts` ~l.436-454); readers of the stored value: API clone `quotations.service.ts:2016`, web `customer-draft-price-list-notice.tsx:42` (skips `master` quotes), web `edit-quotation.mapper.ts:165` | `QuotationDto.priceListSource` | REQ-03 | **changes deliberately** — stored explicit value replaces the derived one, which wrote `master` whenever the quote's list differed from the customer's *current* list; web notice and clone now see the user's real choice | owner "mirror web" | `grep -rn 'priceListSource' apps/api/src apps/web/src apps/mobile` |
| 5 | Mobile `Quotation` response schema (`quotation.contract.ts:238` `QuotationSchema`; the `priceList` field at l.244) — parsed by `quotations.http.ts` l.63, 79, 87, 95 (get-by-number, create/update/duplicate responses) and the mock; the list screens use a separate, narrower projection (`quotation.contract.ts` ~l.298, ~l.393) | zod schema | REQ-03 | additive nullish field; only the edit mapper reads it | owner "mirror web" | `grep -rn 'QuotationSchema' apps/mobile --include=*.ts --include=*.tsx` (run) |
| 6 | Resources rows, running total, Additional Info grouping | `updateResource` (13 non-test references under `features/` and `components/`) | REQ-05 | changes deliberately — a switch rewrites rate/discount/surcharge/unit/source/reference of eligible lines of the open draft | owner "re-pricing lines" | `grep -rn 'updateResource' apps/mobile/features apps/mobile/components --include=*.ts --include=*.tsx` (run) |
| 7 | 25 asterisk labels: `email/compose.tsx` 231, 268; `customers/create.tsx` 111, 119, 139, 146, 155, 164, 172, 226, 233, 303; `projects/create.tsx` 93; `create-billing-code-sheet.tsx` 138; `quote-create-add-custom-type-sheet.tsx` 54; `quote-create-add-job-site-sheet.tsx` 105, 114, 134, 146, 218, 234; `quote-create-main-info.tsx` 361, 421, 506; `quote-create-additional-info.tsx` 193 | `Field label` | REQ-02 | changes deliberately — red mark, plain label text | owner "whole sales surface" | `grep -rn 'label="[^"]*\*"' apps/mobile/{app,components,features,design-system}`; `grep -rnE '[A-Za-z)] \*[\x27"`<{]' …` |
| 8 | Yard `Select` and its callers' tests (`test-helpers` press `qc-yard-option-*`) | `Select searchable` | REQ-01 | unchanged except a search box appears | owner "mirror web" | `grep -rn 'qc-yard' apps/mobile` |
| 9 | Six plain-`Text` error sites (resources 388, 491, 690, 691; tools 178, 207) and any test reading those messages | `styles.errorText` → `FieldError` | REQ-06 | changes deliberately — same text, now an alert-icon row registered for scroll | owner "scroll to the erroneous fields" | `grep -n 'errorText' apps/mobile/components/sales/quote-create-*.tsx`; tests: `grep -rn 'is required' apps/mobile/app/(sales)/quotes --include=*.test.tsx` returns only the Main Info messages (`create.main-info.test.tsx:107-115`, already `Field error`, text unchanged); none of the six converted messages (`Item is required`, `Quantity must be 0 or more`, `Rate must be greater than 0`, `Tool is required`) is asserted |
| 10 | Web zip consumers if D4 moves the helper: `lib/zipcode.ts` and the 7 files importing it (`customer.schema.ts`, `job-site.schema.ts`, `quick-create-customer-modal.tsx`, `vendor.schema.ts`, `yard.schema.ts`, `create-employee-form.ts`, `components/ui/input.tsx`) plus `lib/zipcode-input.ts`, which re-exports `sanitizeZipCodeInput` | `@/lib/zipcode` | REQ-07 | unchanged (re-export, same names) | owner "like web" | `grep -rln "zipcode'" apps/web/src` |
| 11 | Customer-create draft persisted in `kv` (`CUSTOMER_DRAFT_KEY`); a draft restored with an old malformed zip | `customer-create.store.ts` | REQ-07 | the restored value is simply validated on the next Next/Save | owner "like web" | `grep -n 'zip' apps/mobile/features/sales/customer-create.store.ts` |
| 12 | Server below-rate approval check `quotation-approvals.service.ts:250-258` (and its rate comparison below): picks the list from `quotation.priceList`, else the customer's list; **never reads `priceListSource`**; looks the list up by name and compares each root line's rate to that list's rate | saved `priceList` + line rates | REQ-03/04 | changes deliberately — mobile list-customer quotes were saved with billing-code rates against a list-rate reference; they now carry list rates, so the comparison lines up. Quirk mirrored from web: under Master the held list name is still saved, so the check still compares against that list's rates | owner "mirror web" | `sed -n 235,300p apps/api/src/usecase/quotation-approvals/quotation-approvals.service.ts`; `grep -rn 'priceListName' apps/api/src` |
| 13 | Reference-rate hints on resource rows (`quote-create-resources.tsx` ~l.556-560 below-rate warning, ~l.593 "Reference rate" line) | `referenceRate` | REQ-05 (D12) | changes deliberately — hydration (D12) sets `referenceRate` on edit-loaded lines, so the hints appear on edits for the first time. Old mobile drafts for list customers hold billing-code rates: after hydration under the saved list, reference ≠ rate, each such line reads as typed-over, shows the hint and is not re-priced by a switch (same as web would treat it) | owner "mirror web" | `grep -n 'referenceRate' apps/mobile/components/sales/quote-create-resources.tsx` |

- **Surfaces with no existing behaviour in this area:** mobile has **no** price-list picker, **no** re-price, **no** `priceListSource` in the draft, **no** zip validation and **no** scroll on the sales screens (`grep -rn 'FieldErrorScroll\|scrollTo\|useScrollToFieldError' apps/mobile/{app,components}` outside `field-ticket`/`bottom-sheet`: none). Established by those greps.
- **Consumers with no source for what happens to them:** none — each row's source is the owner's "mirror web". Q1 and Q2 are web-vs-vault tensions, not unsourced consumers.

## 11b. AI decisions — reviewed by a developer

**Review status (2026-11-16):** D10 accepted and D13 confirmed by the owner (Syed Haris, in chat) — see the rows. **Carried: developer review in PR** — D1 to D9, D11, D12, D14 to D20 (including D4 zip helper to `packages/shared` with a web re-export, D12 hydration port and D19 ordering) stay as written; the PR's reviewer signs them in the _Reviewed by_ column.

Roles/permissions/zone record (`.claude/CLAUDE.md`), as the first rows:

| ID | Decision | Chosen | Why / alternatives (with existing code found) | Needs developer | Reviewed by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | Permission gate, module registry, surface, names | **No change.** Gate: mobile quote create/edit already gated by the `quotations` module on `POST/PATCH /quotations` and the already-used `resolve-rate` read; no route is added or changed. Module registry: no new module (`packages/shared/src/constants/permissions.ts`, web role-access screen untouched). Surface: mobile sales screens only. No branch on a role or department name or code anywhere; no role flag consulted. | The ticket adds no endpoint and no module. Roles/departments are tenant data (G3) — not read or written. | no | | |
| D1b | Business time | **Not date-related.** No "today", expiry or business-day decision is added. The discount-valid-until and price-hike-until values on a line come back from the server's resolve (the server decides which are in force); mobile adds no date logic. This holds because the web Until chip (a device-zone `toLocaleDateString`) is excluded (D14). | If the chips were included, the Until date would need `getTenantZone()`/`zoneLabelFor`. | no | | |
| D2 | Yard search mechanism | `searchable` prop on the existing `Select` (client-side filter on the already-loaded list). Search matches the yard **name** only (the label). | `useYards` already pulls `GET /yards` with `take: 500`; an `AsyncSearchSelect` (server search, like customer/job site — `design-system/primitives/async-search-select`) would add a request path and a hook for a list already in memory. Web's yard combobox searches server-side on fields not verified here (name, id, maybe address): ASSUMED name-only is enough on a ≤500-row list; one-line change if the owner wants address search. | no | | |
| D3 | Asterisk: which fields get one | **Recolour only.** No field gains or loses a mark; mechanism `Field required` (sibling `RequiredMark`). Known web divergences are left as they are and listed as follow-up: customer-create marks Street/Country/State/City/Zip required where web's customer address is all-or-none optional; customer-create job-site City and Zip are unmarked where web requires them. | `field.tsx` documents that a nested coloured `Text` would change `getByText` and screen-reader text — `RequiredMark` exists for this. Alternative rejected: render a coloured `*` inside the label string (breaks exact-text queries, the one test at `create.resources.test.tsx:485` is that case). Painting marks to match web would silently change who is blocked. | no | | |
| D4 | Zip helper location | **`packages/shared/src/utils/zipcode.ts`** (`isValidUsZipCode`, `sanitizeZipCodeInput`, `US_ZIP_ERROR`), exported from `utils/index.ts`; web `lib/zipcode.ts` re-exports them and keeps the zod schemas. Alternative: copy the three functions to `apps/mobile/lib/zipcode.ts` (simplest, zero web/shared change). | Web's `zipcode.ts` header calls itself the "single source of truth across the app"; a second copy is how the rule drifts (the ticket exists because two surfaces diverged). Mobile already imports `@tcg/shared` in 104 files and `city-match.ts` is a precedent for sharing an address-form rule. The move is mechanical: one new shared file, one web file reduced to re-exports, eight web files untouched. Cost: `@tcg/shared` dist rebuild and `@tcg/web` affected checks. Take the copy if the developer wants U2 to stay mobile-only. | no | | |
| D5 | Zip required-ness per form | Unchanged: sheet zip stays required; customer-create billing and job-site zips stay allowed-blank, format-checked when non-empty. | Required-ness is not "validation of the zip". Customer-create enforces **nothing** today (existing test presses Next/Save on a blank form) and the job-site there has no state or country fields that web requires beside zip; requiring one field of a form that requires none would be inconsistent. Web requires job-site zip; recorded as a divergence, follow-up with the rest of the customer-create validation. | no | | |
| D6 | When a zip error shows | On Next (steps 1–2) and Save for customer-create; on submit (`touched`) for the sheet; cleared as soon as the value is valid. | Matches how the quote builder and sheets already reveal errors (`markAttempted`, `touched`) and web's focused-submit rule (`contexts/web.md` → Forms). Not on every keystroke: the sanitiser already prevents bad characters. | no | | |
| D7 | Zip rule and country | The US rule applies whatever country is selected. | Web's job-site schema does the same (default country `US`); non-US formats are out of scope (intent §5). | no | | |
| D8 | What a price-list switch does (web, exactly) | See REQ-05 acceptance 1–9. Web: handler only sets mode/list state (`handlePriceListSelect`, `resources-pricing-chips.tsx`); `useRepriceDraftResources` (`resources-tab.tsx`) re-resolves on any change of the effective list, **drafts only**, every row with source `price_list_item`/`billing_code`, an FK target, a known reference rate and no typed-over rate (`|rate−reference| ≤ 0.005`); writes rate, unit, discount %, discount-until, price-hike %, surcharge enabled/%, source, reference; hike/discount only from a `price_list_item` result, else null. Typed-over rows are skipped whole (surcharge stays stale, by design comment). Saves `priceList` = held name (non-empty even in Master) and `priceListSource` = `customer`/`master`. Surcharge **chip** (`useQuoteSurcharge(effectiveList)`) shows the list's surcharge, `Inactive` otherwise. | Parity is the owner's instruction. Surcharge-chip and per-row surcharge differ on typed-over rows — Q2. | no | | |
| D9 | Draft-only gate on mobile | Re-price when the quote is new, or `edit.originalStatus === 'DRAFT'` (`create.tsx` `useEditQuoteHydration`); never otherwise. The status is passed down to `ResourcesStep`. | Web gates on `mainValues.status === 'DRAFT'`; mobile's draft has no status field, but `originalStatus` is captured once at load. Quirk inherited from web: on a non-draft edit the picker still changes the saved list/source while lines are not re-priced; it is mirrored, not fixed. | no | | |
| D10 | `none` result and fetch error | `none` result: reset the line as web does (rate 0, source `none`). **Fetch error: leave the line untouched** — web zeroes it. | A network blip silently zeroing a priced line destroys the quote total; mobile's existing pick path already leaves the row on failure (`use-resource-item-selection.ts`, "row stays manually priced"). Marked as a deliberate difference from web for review. | no | Syed Haris (owner), accepted in chat | 2026-11-16 |
| D11 | Late responses | Each re-price remembers the list it was started for and drops its result if `form.priceList`/`priceListSource` has since changed. | Web has no guard (its query key carries the list, ordering is luck). Cheap on mobile where a user can tap through three options quickly. ASSUMED. | no | | |
| D12 | Typed-over detection on edit-loaded lines | Port web's `useHydrateReferenceRates`: after edit hydration, resolve each priced line once with the current list to set only `referenceRate`. | Edit-loaded lines have `referenceRate: null` (`quotation-edit-mapper.ts:165`); web waits for hydration before treating a line as eligible, and without it a switch on an edited draft does nothing. Alternative: skip lines with null reference (switch silently inert on edits). Not chosen. | no | | |
| D13 | Item pick resolves with the effective list | Yes (REQ-04). **A visible change for customers on a price list: new mobile lines price from the list, not the billing code.** | Web does this; a picker that did not affect pick would be cosmetic. Flagged for the owner at sign-off because it moves money on mobile quotes. | no (owner may confirm at sign-off) | Syed Haris (owner), confirmed in chat; new mobile quotes for list customers change rate | 2026-11-16 |
| D14 | Web's Discount / Until / Surcharge chips | **Not built.** Dropdown only. The line's own discount/surcharge values already update through the resolve. Follow-up. | The owner's answer names the dropdown. The chips need two more endpoints mobile does not call (`GET /price-listings` list, resolve-surcharge) whose permission gates would need checking, and the Until chip is a date that would pull the zone rule in. | no | | |
| D15 | Option labels and the "Master" label | As web: names, `(Quoted)`/`(Current)` only when they differ, "Master List", disabled "No Customer Price List". Running-total subtitle shows "Master List" when `master`. | Web's labels are the only written copy. The subtitle (mobile-only `runningLines`) would otherwise show the held customer-list name under Master, which reads wrong; ASSUMED. | no | | |
| D16 | Scroll wiring | `useScrollToFieldError` + `FieldErrorScrollProvider` (`@/design-system`) directly in `create.tsx` with a local counter; not `useStepValidation`/`StepBodyShell`. Resource/tool error lines become `FieldError`. Step 4 gains inline errors. | The primitives are already shared and exported; `useStepValidation` lives under `features/field-ticket/` and importing it would make sales depend on ticket code. Registering the six `errorText` lines is the smallest change that makes them findable; scrolling by `measureLayout` on a `ref` instead would duplicate the registry. | no | | |
| D17 | Which other screens get scroll in this ticket | Quote builder (5 steps), the New Job Site sheet and, after Q3 = A (Syed Haris, 2026-11-17), `customers/create` (the zip errors U2 added): **in**. Others: **no change** — `projects/create` and `email/compose` block with a disabled button / toast and render no inline error, Billing Code and Custom Type sheets are one field. | Nothing to scroll to. (Original premise that `customers/create` has "no validation at all" went stale when U2 added inline zip errors; corrected 2026-11-17.) Recorded in §11c; no follow-up is needed until those screens grow inline errors. | no | | |
| D18 | No API change; no G5 | See §4. | `resolve-rate` takes `priceListName`; DTOs carry both fields. | no | | |
| D19 | Overlap and order with unmerged branches | See "Overlap" below; **land U4 after TCG-219; land U1/U2 after `MOBILE-ADDRESS-PLACES` or rebase.** | `git diff --stat origin/staging...<branch> -- apps/mobile`: TCG-219 rewrites `quote-create-resources.tsx` (385 lines), `quote-create.store.ts` (265), `quote-create.helpers.ts`, `use-resource-item-selection.ts`, `quotation-edit-mapper.ts`, and adds `use-apply-resolved-rates.ts` (the same per-line resolve-and-apply that REQ-05 needs); it does **not** touch `create.tsx` or `quote-create-main-info.tsx`. MOBILE-ADDRESS-PLACES touches `customers/create.tsx`, `quote-create-add-job-site-sheet.tsx` (including a new `onZipCodeChange` setter), `customer-create.store.ts` and `design-system/primitives/input.tsx`. | no | | |
| D20 | Suggested slicing | **U1** red asterisks (REQ-02) **+ yard search (REQ-01)** — both UI-only; **U2** zip (REQ-07); **U3** scroll-to-error (REQ-06); **U4** Price List picker, resolve with list, re-price (REQ-03/04/05). Order: U1, U2 independent of each other except shared files with MOBILE-ADDRESS-PLACES; U3 after U1 (same `Field` lines in resources/tools); U4 after TCG-219 and after U1/U3 (stacks on both). | Yard search is one prop with no TCG-219 overlap, so it belongs in the cheap unit, not the unit that must wait for TCG-219. Four units as the owner decided. | no | | |

**Overlap — rebase risk (checked 2026-11-16):**

| Branch | Unmerged commits | Files overlapping this ticket | Risk |
| --- | --- | --- | --- |
| `feat/TCG-219-mobile-mob-demob-parity` (base `31fa8cc8a`) | 5 shown from `git log origin/staging..` | `quote-create-resources.tsx`, `quote-create.store.ts`, `quote-create.helpers.ts`, `quotation-edit-mapper.ts`, `use-resource-item-selection.ts`, `quotation.contract.ts`, tests `create.resources.test.tsx`, `quote-create.helpers.test.ts` | **High for U3 (the six error-line conversions) and U4 (price list).** U4 should be written on top of `use-apply-resolved-rates.ts`, not beside it. |
| `feat/MOBILE-ADDRESS-PLACES` (base `f0676b6b3`) | 5 shown | `customers/create.tsx`, `customers/create.test.tsx`, `quote-create-add-job-site-sheet.tsx`, `customer-create.store.ts`, `design-system/primitives/input.tsx` | **High for U1 and U2** (label lines and the zip `onChangeText` are edited by both). |

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Reviewed by | Enumerated by |
| --- | --- | --- | --- | --- |
| Other mobile screens with a required asterisk | `Field label` | yes — U1 covers all 25; no sites exist outside sales | | `grep -rn 'label="[^"]*\*"' apps/mobile/{app,components,features,design-system}` |
| Field-ticket required marks | `Field required` / `RequiredLabel` | already done — untouched | | `grep -rln 'RequiredMark\|RequiredLabel\|required' apps/mobile/features/field-ticket` |
| Other mobile pickers on the quote builder | `Select` / `AsyncSearchSelect` | no — only Yard lacked search; others already searchable or <8 fixed options | | `grep -n 'Select' apps/mobile/components/sales/quote-create-main-info.tsx` |
| Other mobile zip/postal inputs | `Input` | yes — the three in REQ-07 are the only inputs | | `grep -rniE 'zip\|postal' apps/mobile/{app,components,features,lib,data}` |
| Other web zip schemas (yard, vendor, employee) | zod `optionalZipCodeSchema` | N/A — no mobile form; web untouched | | `grep -rln "zipcode'" apps/web/src` |
| Other mobile screens with failed-submit errors | `FieldError`/`Field error` | quote builder + New Job Site sheet + `customers/create` (U2's zip errors; Q3 = A, Syed Haris 2026-11-17) in U3; `projects/create`, `email/compose`, Billing Code and Custom Type sheets — no change (no inline errors / one field) | | `grep -rln 'FieldError\|error=' apps/mobile/{app,components}` |
| Price list on other mobile surfaces | — | follow-up (not requested): the Discount/Until/Surcharge chips; re-price on open of a saved draft (web does it, mobile will not); quote detail's Resources tab | | `grep -rn 'priceList' apps/mobile/components/sales/quote-detail-*.tsx` (none) |
| Web "Suggested yard — Use" chip on the quote yard picker | — | follow-up (not requested) | | `grep -n 'suggestion' apps/web/src/features/quotations/components/molecules/quote-yard-select.tsx` |

## 12. Open questions — the stop-and-ask list

**Q1 and Q2 were answered by the owner on 2026-11-16** (Q1 = A, Q2 = A; both match the web-mirroring builds already in REQ-03 acceptance 5 and REQ-05 acceptance 4). **Q3 (added 2026-11-17 by the analyst) was answered A by Syed Haris on 2026-11-17 and applied in U3.** **Q4 (added 2026-11-17 by the analyst, U4) was answered A by Syed Haris on 2026-11-17 and applied in U4.** No question blocks any unit.

### Q1 — Reopened quote: keep its saved price list, or adopt the customer's current one?

- **Question:** When a saved quotation is reopened for editing on mobile, should it keep the price list it was written against, or switch to the customer's current list?
- **Options:**
  - A. Keep the saved list (the customer's current list is offered in the picker as a separate, deliberate choice)
  - B. Adopt the customer's current list on open
  - X. Other — say what
- **Answer:** **A** — a reopened quote keeps its saved price list (web today). Syed Haris (owner), in chat, 2026-11-16.
- **Why it cannot be answered from what is written:** `quotations/gaps.md` → *Should editing a quotation adopt the customer's current price list?* is open (asked 2026-09-01) and still describes an older web behaviour (overwrite with the customer's list). Web's current code keeps the saved list for the same customer and offers the customer's current list as a choice (`create-quotation-form-model.ts` `handlePriceListUpdate`), so the vault entry and web disagree. The FCC notes in the same entry say legacy practice fixes the list at creation but give no ruling. Mobile today also keeps the saved list; REQ-03 makes this a visible choice for the first time.
- **Blocked:** nothing. REQ-03 acceptance 5 builds A — now the answer, not a workaround.
- **Candidates:** `quotations/gaps.md` (305 KB, read by section `## Should editing a quotation adopt the customer's current price list?`, status open, asked 2026-09-01; anchor cited, not restated); `quotations/fcc-billing-resource-configuration-deep-dive-2026-09-16.md` §7–§9 (cited from that entry, not re-read in full); `quotations/billing-code-and-price-list.md` (4.1 KB, 2026-09-04 — silent on this).
- **Owner:** product team (the vault entry names no person)
- **Workaround, if any:** none needed — answered A.
- **Status:** answered 2026-11-16 (Syed Haris, in chat); decision note in `.ai/vault/decisions/` and the `quotations/gaps.md` entry pending (`tcg-scrum`)

### Q2 — A typed-over line after a list switch: old surcharge percentage, or the new list's?

- **Question:** When a quote's price list changes and a line's rate was typed over by hand (so the rate is kept), should that line's surcharge percentage also stay as it was, or follow the new list?
- **Options:**
  - A. Rate and surcharge percentage both stay (web today)
  - B. Rate stays; surcharge percentage follows the new list
  - X. Other — say what
- **Answer:** **A** — a typed-over line keeps its old rate and surcharge percentage after a switch (web today). Syed Haris (owner), in chat, 2026-11-16.
- **Why it cannot be answered from what is written:** `decisions/2026-09-02-one-surcharge-per-quote.md` (`[VERIFIED]`, Melissa McNutt, 2026-05-05) says a quote carries exactly one surcharge rate, resolved at quote level, and a price list replaces that rate; per line only membership (`applySurcharge`) varies. Web's re-price skips a typed-over line whole and its own code comment accepts the surcharge going stale as "the lesser of two harms" (`use-reprice-draft-resources.ts`). That can leave one quote carrying two surcharge percentages, which the decision says should not happen. Nothing written says which wins.
- **Blocked:** nothing. REQ-05 acceptance 4 builds A (web's behaviour) — now the answer, not a workaround.
- **Candidates:** `decisions/2026-09-02-one-surcharge-per-quote.md` (6.3 KB, decided 2026-05-05, verified); `quotations/gaps.md` (surcharge entries — not re-read, only the decision it resolves was read).
- **Owner:** product team (the decision's source on the client side is Melissa McNutt)
- **Workaround, if any:** none needed — answered A.
- **Status:** answered 2026-11-16 (Syed Haris, in chat); decision note pending (`tcg-scrum`). Note for the note: A knowingly lets one quote carry two surcharge percentages, which `decisions/2026-09-02-one-surcharge-per-quote.md` says should not happen; the owner chose web's behaviour over that decision's wording.

### Q3 — Should New Customer (`customers/create`) scroll to its zip error on a blocked Next/Save? (raised by `tcg-analyst`, U3, 2026-11-17)

- **Question:** U2 gave `customers/create` inline zip errors that block Next and Save on a ScrollView screen, so D17's premise ("no validation at all, nothing to scroll to") no longer holds. Should a blocked press there scroll to the message like the quote builder does (REQ-06)?
- **Options:**
  - A. Yes — same wiring as the quote builder (one counter, `useScrollToFieldError`, `FieldErrorScrollProvider`), in a small follow-up unit or on U3's PR
  - B. No — the zip row sits near the top of step 1/2 and the message is visible without scrolling; leave as is
  - X. Other — say what
- **Answer:** A — answered by Syed Haris, 2026-11-17. Applied by amending U3 (`customers/create.tsx` now scrolls to its two zip errors, same wiring as the quote builder).
- **Why it could not be answered from what is written:** REQ-06 names the quote builder; the card says "scroll to the erroneous fields" without naming screens. Whether a short two-field-per-step form needs it is a product call (G1: client-facing behaviour nobody specified).
- **Blocked:** nothing. (Closed: applied in U3, so the siblings rule is met.)
- **Candidates:** none in the vault.
- **Owner:** Syed Haris (owner of Trello-254)
- **Workaround, if any:** none needed.
- **Status:** answered A by Syed Haris 2026-11-17; applied in U3.

### Q4 — Customer changed after lines exist: re-price the draft's catalog lines to the new customer's list? (raised by `tcg-analyst`, U4, 2026-11-17)

- **Question:** On a new or draft quote with priced lines, the user goes back to Main Info and picks a different customer. The quote's list changes to the new customer's list (REQ-03 AC 4), but U4 re-prices only from the Price List picker (REQ-05 "Reached by: the picker only"), so the lines keep the previous customer's rates and are saved under the new customer's list. Should a customer change that changes the effective list re-price the eligible lines, exactly as a picker switch does?
- **Options:**
  - A. Yes: call the same re-price from the customer selection when the effective list changes (draft only, same eligibility, same D10/D11 rules). About 4 lines in `MainInfoStep.selectCustomer`.
  - B. No: lines keep their rates until the user touches the picker; record the consequence in the PR.
  - X. Other, say what
- **Answer:** A, by Syed Haris, 2026-11-17: re-price on a customer change, the same re-price the Price List picker uses.
- **Why it cannot be answered from what is written:** REQ-05 names the picker as the trigger; §13 excludes re-pricing on open. Web has no customer-change handler: its `useRepriceDraftResources` runs on every mount of the Resources tab of a draft, so a customer change is caught as one case of "re-price on open", which §13 does not build on mobile. After D13 (owner-confirmed) a line's rate depends on a specific customer's list, so a customer change can now leave the wrong customer's rates on a quote; before U4 no mobile line carried list rates. This is money behaviour nobody specified (G1).
- **Blocked:** nothing now (was U4's merge).
- **Candidates:** none in the vault.
- **Owner:** Syed Haris (owner of Trello-254)
- **Workaround, if any:** none needed.
- **Status:** answered A by Syed Haris 2026-11-17; applied in U4 (`MainInfoStep.selectCustomer` calls the same `useRepriceDraftResources` as the picker; `create.tsx` passes `isDraft` to `MainInfoStep`). REQ-05's "Reached by: the picker only" and the Q4 text above are left as written; this answer extends the trigger to a customer pick that changes the effective list.

## 13. What this spec deliberately does not specify

- Web's Discount / Until / Surcharge chips on the Resources step — not asked (D14); follow-up.
- Re-pricing a draft when it is **opened** (web does it on mount and on catalog change) — the card asks for the picker; not built (§11c follow-up).
- Customer-create required-ness and validation beyond zip format; web's all-or-none address rule on mobile — D3, D5, follow-up.
- The yard suggestion chip ("Suggested: <yard> — Use") — web-only, not on the card.
- Non-US zip formats (intent §5).
- Error copy for Additional Info "Required" — `ASSUMED` (REQ-06), not sourced.
- Whether a saved quote should keep or adopt the customer's list — Q1; whether a typed-over line's surcharge follows the list — Q2.
- Whether `customers/create` should ever persist a customer — out of this ticket; it is a design-reference wizard today (REQ-07 notes).

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person — *none are open*
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` — *none*
- [x] Answers written back into `spec.md` with their new sources and flags — Q1 = A, Q2 = A (Syed Haris, 2026-11-16); decision notes pending (`tcg-scrum`)
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md` — Q1, Q2 answered; decision notes pending, carried
- [ ] Every requirement's **Edges** fields are filled (`ASSUMED` allowed) or point at a §12 question
- [ ] Every §11a ripple row has a source for what happens to that consumer, or a §12 question
- [ ] A developer has reviewed §11b and §11c (_Reviewed by_) — D10 and D13 done by the owner 2026-11-16; D4, D12, D19 and all other rows **carried: developer review in PR**
- [x] Decomposed into vertical units — `units.md` (4 units, 2026-11-16)

Answered by: Syed Haris (owner, in chat)  Date: 2026-11-16 — open items carried: §11b developer review (all rows except D10, D13) in the PR; decision notes for Q1/Q2; live Trello re-diff of the five card lines; Q2's tension with `one-surcharge-per-quote`

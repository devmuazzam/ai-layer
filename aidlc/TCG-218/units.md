# Units — TCG-218 Quotation: per-association quote visibility and Quotation Type (Hourly / Hourly w/ Mob)

> Written to `.ai/aidlc/TCG-218/units.md` from `spec.md` beside it (decomposer run 2026-10-15).
> Structure is fixed by `spec.md` §11b D1–D13 (incl. D1b, D5b) and §11c, signed by Syed Haris 2026-10-15 — this file
> implements them and re-decides none. Q12–Q16 and Q18 are the ticket owner's assumptions pending Lisette Anzaldo's demo review;
> they are built as written. Mobile is out of scope (Q9, sibling 6) — no unit edits `apps/mobile`; every unit that moves a
> `@tcg/shared` export or a DTO runs the mobile typecheck and jest as a regression gate.
>
> **Sizes are estimates, not measurements.** No unit was built. Each is estimated from the files named in its slice-contents rows and
> must be re-measured with the repo's `git diff --numstat` command before push; a unit over ~400 source lines / 25 files stops
> the executor (the named split line in each *At risk* note is where to cut).

## What a unit is

A unit is a **vertical shippable slice** (schema → API → web → tests, for one behaviour), one branch, one PR, stacked on the unit
it depends on. This ticket has **no** `kind: foundation` unit: every schema change ships with the behaviour that reads it.

---

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size (src lines / files) | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | An admin sets Hourly Show, Mob/Demob Show and Main/Sub per association on both sub-category forms; every existing association starts hidden | REQ-01, 02, 03 | schema, api, web | — | ~310 / 15 | not started |
| U2 | An admin sets the same three settings for a crane's "also brings along" rows, per parent, disabled while the parent is hidden | REQ-04 | schema, api, web | U1 | ~370 / 16 — at risk | not started |
| U3 | A salesperson picks Hourly or Hourly w/ Mob on a quote (saved, duplicated) and an Hourly quote lists exactly the Hourly-shown rows | REQ-05 (type, chip, persist, duplicate), REQ-06 | schema, api, web | U1, U2 | ~340 / 17 | not started |
| U4 | On an Hourly w/ Mob quote each main crane gets a crane-named Mobilization/Demobilization pair at the bottom, auto-filled from its Sub items (Demob at 0, new Mob lines at 0) | REQ-07, 08, 09 (Resources tab), 11 (auto-fill part), 21 (groups last), 22 | schema, api, web | U3 | ~380 / 17 — at risk | not started |
| U5 | Mob/Demob groups are header rows, collapsed by default with lines nested; switching Quotation Type asks first | REQ-21 (header, collapse, nested, read-only visits), REQ-05 (switch confirmation) | web | U4 | ~230 / 9 | not started |
| U6 | Lines in a group take 0 and 2-dp quantities, mirror into the twin at 0, rename/delete follow the twin; Price Adjustment is the one hand-priced line | REQ-11 (remainder), 12, 13 | web, api | U4 | ~300 / 13 | not started |
| U7 | A salesperson sets visits on a group; amount = visits x sum of ticked lines, one total on every server surface and web; saved groups reset to 1 | REQ-10, REQ-21 (editable visits) | shared, api, web | U5, U6 | ~340 / 16 — at risk | not started |
| U8 | Quote PDF, browser print, email and signing flow show Mob/Demob lines only (visits x rate = amount), never the lines inside | REQ-14, REQ-09 (PDF and print) | shared, api, web | U7 | ~340 / 14 — at risk | not started |
| U9 | Converting a quote to a job copies every line, marks dispatch `REQUIRED`/`OPTIONAL`/`NONE`, and the board shows one slot per configured machine and none for price lines | REQ-15, 16 | schema, api | U7 | ~330 / 14 — at risk | not started |
| U10 | An `OPTIONAL` slot (Mob-only or unconfigured equipment) is allocatable on any day and never blocks allocation-completed / Send Tickets | REQ-17, 18, 19, 20 | api, web (DAS) | U9 | ~170 / 8 | not started |

- **Requirements not covered by any unit:** none. 22 in spec, 22 in the ledger above (REQ-05, 09, 11, 21 are split across units, each part named).
- **Units blocked on an open question:** none by an `[OPEN]` requirement. One non-blocking §12 question: **Q20** (allowed values for group visits) blocks only the visits-validation row of **U7**; the executor stops at that row.
- **`[UNVERIFIED]` + not reversible — raise before building** (§2b): **U7** (Q2 data reset of stored group quantities is a one-way overwrite on ticket-owner answer Q2, decision note still pending; settle by `tcg-scrum` writing the Q2 decision note, and by the developer choosing whether the migration records the old quantities). **U9/U10** rest on assumptions Q12–Q16/Q18 and add enum members (`OPTIONAL`, `NONE`) other code will read; they are sequenced last so Lisette's demo review can land first; the column drop is reversible but data written after release is not (settle by that review).
- **Ripple rows without a source:** none left unsourced; the rows that lean on a ticket-owner answer say so. **Executor stop-and-ask items** (structural or unspecified, not for the decomposer to pick): group-kind detection for crane-named labels (U4, U7, U8 — `isGroupResourceLabel` matches only exact "Mobilization"/"Demobilization"/"Crane Time", so "90 Ton Crane – Mobilization" does not match it; D13's link is the stated tie, how Mob/Demob is told from Crane Time is the developer's call); what counts as a switch that "will change rows" (U5, §13).
  - **Resolved 2026-10-15 (Syed Haris):** group-kind detection → spec §11b **D14**: the stored name stays "Mobilization"/"Demobilization", the crane name is a display prefix from the D13 link, so `isGroupResourceLabel` and Crane Time detection are unchanged. Type-switch confirmation (U5) → ask whenever the quote already has resource lines (switching rebuilds the layout); an empty quote switches without asking ("agree"). Q20 → visits are whole numbers ≥ 1; lines inside a group keep two-decimal quantities. Rollout note (U1/U3) acknowledged ("agree"): a release note tells admins to tick Show per sub-category before users quote; the demo tenant is covered by the seed (sibling 5).

---

## U1 — Association quote settings (direct associations)

- **Outcome:** On the sub-category create form and the detail inline edit, an admin ticks Hourly Show and Mob/Demob Show per association and, while Mob/Demob Show is on, picks Main item or Sub item; the values persist, reload, and every association that existed before is hidden.
- **Kind:** vertical
- **Requirements covered:** REQ-01, REQ-02, REQ-03 — fully. (Employee-type rows start hidden because the column default is hidden; quotes still do not read the flags until U3.)
- **Depends on:** —
- **Branch / PR base:** `feat/TCG-218-u1-association-quote-settings` from `origin/main`.
- **Size estimate:** ~310 source lines, 15 source files (schema/DTO/repo/service ~110, two web forms + one settings control ~160, mapper/types ~25, seed ~15). Within 400 / 25.
- **Developer decisions implemented:** D1 (three columns on `SubCategoryAssociatedResource`), D10 (extend `SubCategoryAssociatedResourceDto` and the sub-category response in place), D12, sibling 1 (both forms), sibling 5 (demo seed shows Operator Load as a Sub item on the demo crane).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `SubCategoryAssociatedResource` gains Hourly Show (bool), Mob/Demob Show (bool), Main/Sub (bool sub-item; false = Main), all default hidden/false | Migration `add_association_quote_settings`; adding NOT NULL DEFAULT false hides every existing row, which is the REQ-02/03 backfill. `tcg-prisma-guardian` reviews |
| API (`apps/api`) | `SubCategoryAssociatedResourceDto` + create/update DTO accept the three fields; `sub-categories.service.ts` / `sub-categories.repository.ts` persist and return them; reject Sub item when Mob/Demob Show is off is **not** added (Errors `NOT SPECIFIED`, §4) | Presentation → usecase → service layering unchanged; no new endpoint |
| Web (`apps/web`) | One settings control in `associated-assets-tab-content.tsx` (reuse existing row UI; `find-component` first) wired into `use-create-sub-category-actions.ts` and `use-sub-category-inline-edit.ts`; `mapSubCategoryRaw` maps the fields; `data-testid`s on the new controls | Field Setting control untouched. Sibling 1: both writers in this unit |
| Mobile (`apps/mobile`) | none — additive response fields; `sub-category.contract.ts` ignores them | Mobile typecheck + jest run as gate |
| Shared (`packages/shared`) | N/A — no shared type changes | |
| Tests | API integration: settings persist/reload, new employee-type association defaults hidden; migration check that pre-existing rows read hidden; web: control disabled/enabled logic for Main/Sub; seed test | |

### Reviewable as

- **Demo:** Sub-category detail → Associated Field Assets → tick Hourly Show on an association and Mob/Demob Show + Sub item on another, save, reload; open any pre-existing sub-category and see every row hidden.
- **Acceptance:** REQ-01, 02, 03 acceptance lines (settings persist and reload; Show settings independent; Field Setting unchanged; new and existing employee and non-employee rows both Show settings off).
- **Reviewer can verify without:** U2–U10, a quote, a job. Nothing reads the flags yet.

### Risk

- **Weakest source:** `[UNVERIFIED]` (ticket-owner answer Q1 for existing rows; decision note pending).
- **Migration reversible:** yes — new columns with defaults; dropping them loses only values entered after release.
- **Behind a flag:** no.
- **Touches existing data:** yes — every existing association row gains the three columns at hidden. No value is rewritten.
- **Blast radius:** wrong defaults hide associations on every new quote from U3 on; this unit changes no quote.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Sub-category create/detail forms (R6): `create-sub-category-layout*.tsx`, `use-create-sub-category-actions.ts`, `use-sub-category-inline-edit.ts`, `associated-asset-tree-preview.tsx` | new per-row controls | web test: a save without touching the new controls round-trips Field Setting unchanged (`apps/web/src/features/assets/sub-category/` test) | `spec.md` REQ-01 |
| Sub-category GET consumers: web `lib/api/asset-management*` (`mapSubCategoryRaw`); mobile `sub-category.contract.ts`, `resource-catalog.helpers.ts` (R4) | response gains three fields | mobile typecheck + existing jest unchanged; API test asserts existing fields unchanged | `spec.md` REQ-01; R4 (mobile unchanged until TCG-219, ticket-owner log Q1) |
| Seeds/demo creating associations (R5): `catalogue-seed.service.ts`, `staircase-billing.ts`, `demo-flows.service.ts`, `fcc-seeder`, `remove-optional-materialized-job-resources.ts` | default hidden | seed test; only the demo tenant sets Operator Load Sub item (sibling 5) | `spec.md` §11c sibling 5; other seeds hidden by REQ-03 |
| DAS readers of `isRequired` (`das.repository.ts`, `missing-required-components.util.ts`) | same association rows | none — `isRequired` is not touched; `git grep -l isRequired -- apps/api/src/usecase/das` named in the executor's checklist | `spec.md` REQ-01 (Field Setting unchanged) |

### Deliberately not in this unit

- Nested "also brings along" settings — U2.
- Any quote reading the flags — U3.

---

## U2 — Nested ("also brings along") settings per parent

> **Split 2026-10-16 (Syed Haris, ticket owner):** built at 517 source lines (over ~400), so it ships as two stacked PRs — **U2a** schema + API (branch `feat/TCG-218-u2a-nested-association-settings-api`, from `origin/main`; safe alone: forms that send no `nestedSettings` keep what is stored) and **U2b** both web editors (branch `feat/TCG-218-u2b-nested-association-settings-web`, stacked on U2a). Window: until U2b merges, nested settings can be set only through the API. Measured at push: U2a 328 lines / 5 files vs main; U2b 473 / 6 vs U2a — over only because ~110 lines of U1's settings control moved to `association-quote-settings.tsx` (the tab file hit the 300-line lint limit); ~290 new. Ticket owner chose the `size-exception` label for U2b over a separate move PR (2026-10-16).

- **Outcome:** Under a crane's association (e.g. Operator Load), an admin sets Hourly Show, Mob/Demob Show and Main/Sub for each of that association's own associations, separately per parent; the controls are disabled and cleared while the parent is hidden on that quote type.
- **Kind:** vertical
- **Requirements covered:** REQ-04 — fully (storage, editor, disabled-while-parent-hidden). The quote consuming it is U3.
- **Depends on:** U1
- **Branch / PR base:** `feat/TCG-218-u2-nested-association-settings`, stacked on U1's branch.
- **Size estimate:** ~370 source lines, 16 source files. **At risk** — new table, repository, DTO nesting, and an editor row inside both forms. Split line if measured over: the create-form editor becomes U2b (window: a sub-category created fresh cannot set nested rows until U2b; the detail inline edit works), or the developer adds `size-exception`.
- **Developer decisions implemented:** D2 (new table, one row per (crane's association, nested item) with the three settings and FKs), D1b (`tenantCompanyId` on the new table, added to `TENANT_SCOPED_MODELS`), D10, D12, sibling 1.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | New table keyed (parent `SubCategoryAssociatedResource` id, nested association reference), columns Hourly Show, Mob/Demob Show, Main/Sub, `tenantCompanyId`, UUID FKs | Migration `add_nested_association_settings`. Exact column types and the nested-item reference are not stated by D2 beyond "with foreign keys" — executor proposes, developer states. `tcg-prisma-guardian` mandatory (new tenant-owned table; also checks the allowlist entry) |
| API (`apps/api`) | `prisma.service.ts` `TENANT_SCOPED_MODELS` entry; DTO carries nested settings on the existing sub-category save and read; repository writes/reads; clearing nested flags when the parent is hidden | D10: no new endpoint |
| Web (`apps/web`) | Nested row editor under each association in `associated-assets-tab-content.tsx` / `associated-asset-tree-preview.tsx`, both forms' hooks, disabled-while-parent-hidden | Reuse the U1 settings control |
| Mobile (`apps/mobile`) | none | typecheck/jest gate |
| Shared (`packages/shared`) | N/A | |
| Tests | API integration: same child shown under crane A and hidden under crane B persists independently; another tenant cannot read the row (tenant isolation); parent hidden clears nested; web disabled state | |

### Reviewable as

- **Demo:** In the 100 Ton crane's configuration, expand Operator Load, show Operator and hide Tractor-Semi; open another crane that also lists Operator and see it still hidden.
- **Acceptance:** REQ-04 acceptance (per-parent independence; nested controls read hidden when parent hidden; new nested rows default hidden).
- **Reviewer can verify without:** U3 and later (no quote reads it yet).

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** yes — a new table; drop it and the allowlist entry.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** a missing allowlist entry is a silent cross-tenant read (`prisma.md`, nothing enforces it) — the guardian's first check.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Sub-category save/read path (R4) and both forms (R6) | nested settings travel with the existing save | API test: a save with no nested payload leaves earlier nested rows intact; U1 round-trip test still passes | `spec.md` REQ-04, D10 |
| Materialization of deeper levels at conversion, `materialize-job-resources.ts` (R5, R8) | reads the same associations | `materialize-job-resources.spec.ts` unchanged and green — nested settings are quote-only | `spec.md` REQ-15 (show/hide is for the quote only) |
| Mobile `sub-category.contract.ts` | response shape | mobile typecheck + jest | R4 |

### Deliberately not in this unit

- A quote showing the nested rows — U3 (Hourly) and U4 (Hourly w/ Mob).

---

## U3 — Quotation Type and the Hourly layout

- **Outcome:** A salesperson chooses Hourly or Hourly w/ Mob with a chip beside Price List; the choice saves, carries onto a duplicate, and an Hourly quote's new picks list exactly the associations (and nested rows) whose Hourly Show is ticked; a quote saved before this opens as Hourly with its lines unchanged.
- **Kind:** vertical
- **Requirements covered:** REQ-05 (type, chip, persistence, duplicate, default — switch confirmation is U5), REQ-06 — fully.
- **Depends on:** U1, U2
- **Branch / PR base:** `feat/TCG-218-u3-quotation-type-hourly-layout`, stacked on U2's branch.
- **Size estimate:** ~340 source lines, 17 source files (column + DTO + create/update/duplicate/read ~90, chip + form wiring + mapper ~120, association filtering in catalog helpers/child tree ~100, types ~30). Within 400 / 25.
- **Developer decisions implemented:** D3 (short string, `NOT NULL DEFAULT 'hourly'`, API validates `hourly` | `hourly_w_mob`), D10, D11 (web builds rows), D12, sibling 2 (create/edit/detail views).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `Quotation` gains the type column | Migration `add_quotation_type`; no backfill — default covers existing quotes (REQ-05) |
| API (`apps/api`) | Create/update DTO validate the two values; `quotations.service.ts` persists, returns and carries it on duplicate | Whether `QuotationRevision.snapshot` carries the type is unspecified (§13) — not added |
| Web (`apps/web`) | Chip beside Price List in create/edit views; type in `create-quotation.helpers.ts`, `edit-quotation.mapper.ts`, detail view; `buildChildTreeNodes` / catalog helpers filter new picks by Hourly Show (association and nested), only for rows being created | `resources-tab.child-tree.ts` has no imports by design (test runner) — pass the flags in via `AssociatedAsset` |
| Mobile (`apps/mobile`) | none | additive DTO field; typecheck/jest gate |
| Shared (`packages/shared`) | quote-type constant/type only if the developer chooses shared over web+API-local (D3 does not say) — executor asks | Both front-ends are in radius if so |
| Tests | API: type persists, duplicate carries it, pre-existing quote reads `hourly`; web: `resources-tab.child-tree.test.mjs` extended — hidden rows not created, shown rows created, nested follows parent; saved-quote reopen test | |

### Reviewable as

- **Demo:** New quote on the 100 Ton crane (crane, Operator Load, travel permit shown; tractor-semi and operator hidden): the Hourly quote lists exactly those. Duplicate it; type is kept. Reopen a quote created before the migration: Hourly, same lines.
- **Acceptance:** REQ-05 (new quote Hourly; chip switches type; pre-existing opens Hourly; duplicate carries it) and REQ-06 acceptance.
- **Reviewer can verify without:** U4–U10. Choosing Hourly w/ Mob saves the type but the layout equals Hourly until U4 (see Sequencing, window W1).

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** yes — one column.
- **Behind a flag:** no. **Rollout note for the developer:** after U1's backfill every association is hidden, so from this unit on a new quote on a tenant whose admins have not ticked Show lists no association rows. That is REQ-03 working as written; say it in the release note.
- **Touches existing data:** no.
- **Blast radius:** new quotes lose association rows tenant-wide until settings are ticked; saved quotes must not.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Every reader of the quotation shape (R1; 14 non-test files from `git grep -l priceListSource`; mobile `quotations.service.ts`, `quote-create.helpers.ts`) | new field | `tcg-contract-tracer` pass; mobile typecheck + jest | `spec.md` REQ-05 (additive; older quotes Hourly) |
| Saved quotes reopened: virtual (unmaterialized) association children merged in the editor by `resources-tab.child-tree.ts` | catalog expansion now filtered by Show | `resources-tab.child-tree.test.mjs` case: a saved quote reopens with the same rows; the Show filter applies to rows being created, not to a re-merge | `spec.md` REQ-02 / R5 ("saved quotes unchanged"); if the merge cannot tell new from saved the executor stops |
| Quotation duplicate (R7) | type copied | API test | `spec.md` REQ-05 |
| Create/edit/detail views and `edit-quotation.mapper.ts` (R3) | type field | `edit-quotation.mapper` round-trip test | sibling 2 |

### Deliberately not in this unit

- Hourly w/ Mob layout — U4. Switch confirmation — U5.
- Revision snapshot carrying the type — §13, not specified.

---

## U4 — Hourly w/ Mob layout: crane-named, auto-filled Mobilization/Demobilization pairs

> **Split 2026-10-16 (Syed Haris, ticket owner):** built at 510 source lines, so U4 ships as three stacked PRs — **U4a** schema + API + web types/payload/mapper + duplicate carries the link (safe alone: the web never sets the link), **U4b** building the pair in the web (stacked on U4a), **U4c** crane-named labels + multi-crane ordering (stacked on U4b). Merge each only after the next PR's base shows `main`. No deploy between U4 and U6 (Q32 window).

- **Outcome:** On an Hourly w/ Mob quote the crane appears alone, its Main items follow, and each main crane gets its own crane-named Mobilization/Demobilization pair at the bottom, filled automatically with its Sub items (Demob twin at 0, new Mob lines at 0).
- **Kind:** vertical
- **Requirements covered:** REQ-07, REQ-08, REQ-09 (Resources tab; PDF/print in U8), REQ-11 (Demob lines at 0 on auto-fill; manual rules in U6), REQ-21 (groups last, in crane order — header/collapse in U5), REQ-22 — as named.
- **Depends on:** U3
- **Branch / PR base:** `feat/TCG-218-u4-hourly-mob-layout`, stacked on U3's branch.
- **Size estimate:** ~380 source lines, 17 source files. **At risk.** Split line: multi-crane ordering/labelling (REQ-09 second crane, Q17) moves to a U4b after U4 (window: with two cranes both cranes' Sub items fill a single pair until U4b). The single-crane path stays in U4.
- **Developer decisions implemented:** D13 (nullable column on the quotation line linking a group to its crane line), D11, D5b (twin paired by name — used by the auto-mirror), D10 (quotation resource DTO gains the link), D12, sibling 2.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `QuotationResource` gains one nullable link to the crane line | Migration `add_quotation_resource_crane_link`; `quotation_resources` has no `tenantCompanyId` (known, D1b says leave it). `tcg-prisma-guardian` reviews |
| API (`apps/api`) | Create/update DTO and `quotations.service.ts` `syncResources` persist and return the link; no total change (groups still roll up x1) | `createJobFromQuotationInTx` untouched here |
| Web (`apps/web`) | `resources-tab.catalog.helpers.ts`, `resources-tab.tree.ts`, `resources-tab.state.helpers.ts`: on a pick, route Sub-item associations into the crane's Mobilization and a twin at 0 in its Demobilization; Main items as own lines; groups sorted last, crane order; new Mob line qty 0, rate from price list else billing code; label "<crane> – Mobilization" | Group detection for a crane-named label: **executor asks the developer** (`isGroupResourceLabel` is exact-match) |
| Mobile (`apps/mobile`) | none | typecheck/jest gate; mobile detects groups by exact name, so a crane-named group saved on web is not a group to mobile's `isGroupResourceLabel` re-detection — the executor checks mobile's edit mapper keeps the server `isGroup` and records the finding; mobile stays out of scope (Q9) |
| Shared (`packages/shared`) | only if the label helper moves there (developer's call) | |
| Tests | web unit: crane with Main A and Sub B lists crane, A, Mobilization, Demobilization; B only in the groups; Demob twin 0.00; two cranes order 90 Ton Mob, 90 Ton Demob, 250 Ton Mob, 250 Ton Demob; API: link persists | |

### Reviewable as

- **Demo:** New Hourly w/ Mob quote, pick the 100 Ton crane whose Operator Load is a Sub item: crane, Main items, then "100 Ton Crane – Mobilization" with Operator Load at 0 and its Demobilization twin at 0. Add a 250 Ton crane: two pairs, crane order.
- **Acceptance:** REQ-07, 08, 09 (tab), 22 acceptance lines and the Demob-at-0 part of REQ-11.
- **Reviewer can verify without:** U5–U10 (groups render as today's group rows until U5; totals x1 until U7).

### Risk

- **Weakest source:** `[UNVERIFIED]` (ticket-owner answers Q3, Q4, Q5, Q17; the meeting says mob/demob-at-bottom was "still to do" at the demo).
- **Migration reversible:** yes — one nullable column.
- **Behind a flag:** no.
- **Touches existing data:** no; the link is null for every existing line.
- **Blast radius:** quote builder row construction for Hourly w/ Mob quotes only; Hourly and saved quotes must not change.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Web Resources tab (R3): `resources-tab*`, `resources-rows-list.tsx`, `create-quotation.helpers.ts`, `edit-quotation.mapper.ts`, `detail-resources-tab.tsx` | row building by type; link field | `resources-tab.child-tree.test.mjs` Hourly case unchanged; edit-mapper round-trip with and without the link | `spec.md` REQ-07, 08 |
| Quotation resource DTO consumers incl. mobile `quotation-edit-mapper.ts` (R1) | new nullable field | `tcg-contract-tracer`; mobile typecheck + jest | `spec.md` REQ-09; D10 |
| Existing group detection by name (`isGroupResourceLabel`; web `applyUpdateResource`, mobile store, shared `GROUP_RESOURCE_LABELS`) | crane-named labels | test: a crane-named group is a group on web; "Crane Time" still a group and not a Mob/Demob group | D13 (stored link); detection rule = developer's call |
| `syncResources` / `applyGroupRollups` in `quotations.service.ts` (R2) | persists the link | `quotation-resource-totals.spec.ts` unchanged | `spec.md` REQ-10 (math is U7) |

### Deliberately not in this unit

- Header rows, collapse — U5. Manual add/rename/delete/PA rules — U6. Visits — U7. PDF and print for the pairs — U8.

---

## U5 — Group header rows and the type-switch confirmation

> **Split 2026-10-16 (Syed Haris, ticket owner; Q35):** ~610 lines, so U5 ships as **U5a** — header rows, collapse, groups-last (`feat/TCG-218-u5-group-header-rows`, 362 lines) — and **U5b** — type-switch confirmation + re-layout (stacked on U5a). Until U5b lands the chip switches without asking.

- **Outcome:** On an Hourly w/ Mob quote each Mobilization/Demobilization group is a header row showing its total, collapsed by default, with its lines nested underneath to expand and edit; switching Quotation Type asks for confirmation first.
- **Kind:** vertical
- **Requirements covered:** REQ-21 (header, total, collapse, nesting; visits shown read-only at 1 — editable in U7), REQ-05 (switch confirmation).
- **Depends on:** U4
- **Branch / PR base:** `feat/TCG-218-u5-group-header-rows`, stacked on U4's branch.
- **Size estimate:** ~230 source lines, 9 source files. Within 400 / 25.
- **Developer decisions implemented:** D11, D12, sibling 2 (create/edit/detail all render it).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — no schema change | |
| API (`apps/api`) | N/A — no API change | |
| Web (`apps/web`) | Group header row in `resources-rows-list.tsx` / `resource-row*`; collapsed by default (`use-default-expand-all.ts` honoured for groups only on this type); confirmation dialog in the chip; `data-testid`s | Reuse the existing confirm-dialog component (`find-component` first). Copy for the popup is `NOT SPECIFIED` (§5) — executor proposes. **What counts as a switch that "will change rows" and what is discarded is §13 / unspecified — the executor stops and asks the developer** |
| Mobile (`apps/mobile`) | none | |
| Shared (`packages/shared`) | N/A | |
| Tests | web: collapsed on open, expands, header shows group total; switch with manual edits prompts, cancel keeps rows | |

### Reviewable as

- **Demo:** Open an Hourly w/ Mob quote: groups at the bottom, collapsed, header total visible; expand to edit lines; switch the chip and see the prompt.
- **Acceptance:** REQ-21 acceptance (collapsed by default, header total, expand shows lines) and the REQ-05 "prompts first" clause.
- **Reviewer can verify without:** U6–U10.

### Risk

- **Weakest source:** `[UNVERIFIED]` (Joe 1:01:56–1:02:14 plus a ticket-owner choice).
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** quote builder UI; `data-testid`s are a contract with `qa-automation/`.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| Row expand/collapse and drag/reorder: `use-default-expand-all.ts`, `resources-tab.reorder.helpers.ts` | group rendering | `resources-tab.reorder` / child-tree tests unchanged; Hourly quotes still expand-all | `spec.md` REQ-21 |
| `qa-automation/e2e` selectors on resource rows | `data-testid`s | `grep -rn` of renamed IDs over `qa-automation/e2e` (no rename allowed) | `.claude/CLAUDE.md` data-testid contract |

### Deliberately not in this unit

- Editable visits — U7 (blocked only on Q20 for its validation row).

---

## U6 — Line rules inside a group: quantities, twin, Price Adjustment

- **Outcome:** A salesperson can enter 0 and two-decimal quantities in group lines, add a line to Mobilization and see it appear in Demobilization at 0, rename or delete a line and have its twin follow, and add a Price Adjustment line with a hand-entered rate that carries cents.
- **Kind:** vertical
- **Requirements covered:** REQ-11 (remainder: 0 and 2-dp acceptance, manual add mirrors at 0, a 0 line stays out), REQ-12 (basic rule only, Q8), REQ-13 — fully.
- **Depends on:** U4
- **Branch / PR base:** `feat/TCG-218-u6-group-line-rules`, stacked on U4's branch (parallel to U5; both touch web quote builder files, so merge in order U5 then U6).
- **Size estimate:** ~300 source lines, 13 source files. Within 400 / 25.
- **Developer decisions implemented:** D5b (twin matched by name; on rename the previous name finds the twin), D9 (Price Adjustment = custom type with per-tenant code `PA`), D12, sibling 2.

> **Added 2026-10-16 (Q30, Syed Haris):** U6 also removes the "In total" checkbox (`resource-row.group-include.tsx`) and the detail view's "Excluded" label from the web; new group lines are always counted; `isIncluded` column and totals maths unchanged; mobile untouched.

> **Added 2026-10-16 (U1–U4 end-to-end test, Q34):** existing quotes already hold saved Mob/Demob lines at 0 (QUOT-00022/23 locally) and cannot be saved from the web today — U6's "0 allowed in groups" must accept saved lines too, not only new ones.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — D5b and D9 need no schema | |
| API (`apps/api`) | Quotation DTO/validation: quantity inside a group allows 0 and 2 dp; code-less custom line needs a billing code except the `PA` line, whose rate allows cents; `quotations.service.ts` | Whole-dollar rule stays for ordinary rates |
| Web (`apps/web`) | `resources-tab.callbacks.ts` / `resources-tab.state.helpers.ts`: mirror, rename and delete follow the twin; `resource-row.rate-column.tsx`, `use-billing-code-fanout.ts`: "Billing Code missing." exception for `PA` | Siblings: create/edit/detail |
| Mobile (`apps/mobile`) | none (R9 — TCG-219) | |
| Shared (`packages/shared`) | N/A | |
| Tests | web unit for mirror/rename/delete (deleting the only Mob line X deletes Demob X; Mob X to Y renames Demob X); API: 0.5 and 1.25 accepted, third decimal rejected, PA 25.50 saves, other code-less custom line rejected | |

### Reviewable as

- **Demo:** In Mobilization add "Support load" 0.5: Demobilization gets it at 0.00; rename it, twin renames; delete it, twin goes; add Price Adjustment at 25.50 with no "Billing Code missing."; add another code-less custom line and see it flagged.
- **Acceptance:** REQ-11, 12, 13 acceptance lines.
- **Reviewer can verify without:** U5, U7–U10.

### Risk

- **Weakest source:** `[UNVERIFIED]` (Q8 build reading not adopted; ticket-owner PA note).
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** a name-matched twin can mis-pair on duplicate names — accepted by Q8 ("only the basic rule").

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| "Billing Code missing." handling (R9): web `resource-row.rate-column.tsx`, `resources-tab.callbacks.ts`, `use-billing-code-fanout.ts` | `PA` exception | web test: code-less custom line outside a group and inside a group still flagged; ordinary rate still whole-dollar | `spec.md` REQ-13 |
| Quotation DTO validation of `quantity` (every quote save) | 0 / 2-dp rule scoped to group lines | API test: non-group line validation unchanged | `spec.md` §9 |
| Mobile `quote-create-resources.tsx` (R9) | unchanged | mobile jest unchanged | R9 → TCG-219 |

### Deliberately not in this unit

- Visits multiplication — U7. Duplicate-name or quantity rules for the twin — not specified (Q8).

---

## U7 — Visits: group amount = visits x sum of ticked lines

- **Outcome:** A salesperson edits a group's visits in its header; the group amount is visits x the sum of its ticked lines (0 lines contribute 0, Crane Time stays x1); the quote subtotal, total, customer metrics, project revenue, approval margin, and emails agree; quotes saved before this keep their totals.
- **Kind:** vertical
- **Requirements covered:** REQ-10 — fully, except the visits validation row (blocked on Q20); REQ-21 (editable visits).
- **Depends on:** U5, U6
- **Branch / PR base:** `feat/TCG-218-u7-group-visits`, stacked on U6's branch (U6 stacked on U4; U5 must be merged or in the stack below it — executor rebases onto whichever of U5/U6 is later).
- **Size estimate:** ~340 source lines, 16 source files. **At risk** — 11 API and 5 web consumers of group totals are named in R2, but most read persisted `finalAmount` and need only a check. Split line: approval margin (`quotation-resource-margins.ts`, approvals) becomes U7b after U7 (window: margin on approval shows x1 for a quote with visits > 1; named so reviewers know); API and web totals stay together (§11).
- **Developer decisions implemented:** D4 (visits = group row `qty`, saved groups reset to 1 — Q2), D5 (edit shared `getGroupTotal` and the API's own `applyGroupRollups`/`computeQuotationTotals` copy in place), D12, sibling 6 for email context (math only; layout is U8).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | Data migration only, no schema change: reset `qty` to 1 on existing Mobilization/Demobilization group rows whose stored qty is not 1 (Q2) | Migration `reset_group_visits_to_one`. **One-way** (overwrites stored qty; `[UNVERIFIED]` source). Developer chooses whether it records the old values. Crane Time groups untouched. `tcg-prisma-guardian` reviews |
| API (`apps/api`) | `quotation-resource-totals.ts` (`applyGroupRollups` x visits), `quotation-resource-margins.ts` (revenue and cost x visits), call sites in `quotations.service.ts`, `projects.service.ts` (~1810), `docusign/quotation-pdf.service.ts` totals, and a verify-only pass over `customer-quotation-metrics.ts`, `project-quotation-revenue.ts`, `quotation-email-context.util.ts`, `quotation-approvals.service.ts`, `quotation-signatures.service.ts`, `projects.repository.ts` | Discount, surcharge, price hike on lines scale x visits. Visits validation: **stop at Q20** |
| Web (`apps/web`) | Editable visits input in the group header (U5); `resource-row.tsx`, `resources-tab.helpers.ts`, `resources-table-money.ts`, `create-quotation.helpers.ts`, `detail-format.ts` use the shared function | |
| Mobile (`apps/mobile`) | none edited | Mobile creates group rows with quantity 1 (`createResourceDraft`), so x visits = x1 and totals do not change; mobile typecheck + `quotation-pricing.test.ts` + `quotations.mock.test.ts` run unchanged as the proof |
| Shared (`packages/shared`) | `getGroupTotal` multiplies by the group's own quantity for Mob/Demob only; `getResourceFinalAmount`, `sumResourceAmounts` follow | `packages/shared` is consumed as built `dist/` — rebuild before web/mobile checks. Group-kind detection: **developer's call** (see ledger) |
| Tests | shared `quotation-pricing.test.mjs`: visits 3, lines 3 hr + 3 hr, unticked excluded, qty 1 equals today's result, Crane Time x1; API `quotation-resource-totals.spec.ts`, margins spec, `quotation-pdf.service.spec.ts`; web `detail-format.test.mjs`; migration check | |

### Reviewable as

- **Demo:** Set Mobilization to 3 visits: header total and quote total show 3 x sum; edit a line quantity, visits unchanged; open a quote saved before the migration with a stored qty of 2 and see it at 1 visit with the same total; compare quote detail, customer metrics and approval email totals.
- **Acceptance:** REQ-10 acceptance (3 x sum; line quantities unaffected by visits; unticked excluded; Crane Time x1; all surfaces agree).
- **Reviewer can verify without:** U8–U10.

### Risk

- **Weakest source:** `[UNVERIFIED]` (Joe 2026-10-08 for rules 1–3; ticket-owner Q2, Q9 pending decision notes).
- **Migration reversible:** **no** — the data reset overwrites stored group quantities. `[UNVERIFIED]` + irreversible: raised in the ledger; settle with the Q2 decision note from `tcg-scrum` and the developer's choice to snapshot old values.
- **Behind a flag:** no.
- **Touches existing data:** yes — the Q2 reset, scoped to Mob/Demob group rows with qty != 1.
- **Blast radius:** every money surface at once; this is why API and web ship in one unit. Mobile-saved quotes stay x1 (Q9).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| API group-total readers (R2): `projects.repository.ts`, `customers/customer-quotation-metrics.ts`, `projects/project-quotation-revenue.ts`, `notifications/templates/quotation-email-context.util.ts`, `quotation-approvals.service.ts`, `quotation-signatures.service.ts`, `projects.service.ts` | persisted rolled-up amount / shared rollup | `quotation-resource-totals.spec.ts`, `quotation-pdf.service.spec.ts`, plus a visits = 3 case through metrics and revenue helpers; **any reader without a test gets one in this unit** | `spec.md` REQ-10 (one total everywhere) |
| Approval margin: `quotation-resource-margins.ts` | revenue and cost x visits | margins spec case at visits 3 | `spec.md` REQ-10; visits note rules 6–8 (`reference`) |
| Web totals: `resource-row.tsx`, `resources-tab.helpers.ts`, `resources-table-money.ts`, `detail-format.ts`, `create-quotation.helpers.ts` | shared `getGroupTotal` | `detail-format.test.mjs` plus a visits case | REQ-10 |
| Mobile totals: `quotation-pricing.ts`, `quote-create.store.ts`, `quotation-financials.ts`, `quotations.mock.ts` | shared `getGroupTotal`, new qty multiplier | mobile jest unchanged and green (group qty 1) | `spec.md` Q9 (mobile x1 until TCG-219), D5 |
| Existing saved quotes with a group qty other than 1 | stored qty now meaningful | migration test: totals before = after | `spec.md` Q2 (`[UNVERIFIED]`, decision note pending) |

### Deliberately not in this unit

- Visits validation (min, max, integer-only) — blocked on §12 **Q20**.
- Customer documents showing visits x rate — U8.
- Merging the two rollup copies — possible follow-up (D5).

---

## U4d — The item itself is the first line of its Mobilization/Demobilization pair

- **Outcome:** On an Hourly w/ Mob quote, picking an item that gets a pair (Q32b: it has a Sub item) also puts that item as the first line of its Mobilization group at quantity 0, priced like any new group line, with its Demobilization twin at 0; the item stays as its own line on top.
- **Kind:** vertical (web only)
- **Requirements covered:** REQ-07 as amended by §12 **Q42**; REQ-08, REQ-11, REQ-22 for that line.
- **Depends on:** U4 (merged), U6 (merged — twin rules). Independent of U7.
- **Branch / PR base:** `feat/TCG-218-u4d-crane-in-mob` from `origin/main`.
- **Size estimate:** ~60–120 source lines, 2–4 files (`resources-tab.mob-layout.ts` builder; type-switch re-layout if it builds groups separately).
- **Reviewable as:** pick the 100 Ton crane on an Hourly w/ Mob quote → crane, Travel Permit under it, then Mobilization [100 Ton crane 0, Operator Load 0], Demobilization [100 Ton crane 0, Operator Load 0]; re-pick refills (Q33b); removing the crane removes the pair (Q31); Hourly → Hourly w/ Mob switch (U5b) builds the same; an item with no Sub items gets no pair (Q32b).
- **Deliberately not in this unit:** FCC block comments; mobile (TCG-219); customer documents (U8).

---

## U8 — Customer documents: Mob/Demob lines only

- **Outcome:** The quote PDF, browser print, quotation email and signing flow show the main items and the Mobilization/Demobilization group lines (visits as Qty, per-visit rate, amount) and never the lines inside; discount, price-hike and surcharge foot lines still include the children's amounts; the in-app detail view still shows the lines.
- **Kind:** vertical
- **Requirements covered:** REQ-14, REQ-09 (PDF and print: four group lines for two cranes) — fully.
- **Depends on:** U7
- **Branch / PR base:** `feat/TCG-218-u8-customer-documents`, stacked on U7's branch.
- **Size estimate:** ~340 source lines, 14 source files. **At risk** — shared helper plus three consumers. Split line: email context and signing flow (sibling 6) become U8b (window: PDF and print are fixed while the email's line list still prints children).
- **Developer decisions implemented:** D6 (one shared "customer line items" helper in `@tcg/shared`, used by server PDF and browser print), D12, sibling 2 (print/PDF pair), sibling 6 (email and signing).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | |
| API (`apps/api`) | `docusign/quotation-pdf.service.ts` (`getVisibleResources`, `getAdjustmentResources`) use the helper and print visits / rate / amount; `quotation-email-context.util.ts`, `quotation-signatures.service.ts` use it | PDF already hides children today (code observation); its qty printing changes |
| Web (`apps/web`) | `print-quotation.helpers.ts` (`buildPrintLineItems`), `print-quotation.model.ts` use the helper; stops indenting children | Print leaks children today; this fixes it |
| Mobile (`apps/mobile`) | none | New additive shared export; mobile typecheck gate |
| Shared (`packages/shared`) | New customer-line-items helper in `src/utils/` + test | Both front-ends are in radius; additive export only |
| Tests | shared helper unit (children omitted, foot lines include children x visits, two cranes yield four group lines); `quotation-pdf.service.spec.ts`; web print helper test; email context test | |

### Reviewable as

- **Demo:** Quote with Mob (3 lines) and Demob (3 lines) at 3 visits: PDF and print show "Mobilization 3 visit $1,995 $5,985" and no inner lines; the detail view still lists them; foot-line totals equal the sum over all included children.
- **Acceptance:** REQ-14 and REQ-09 (PDF and print) acceptance lines; Q7.
- **Reviewer can verify without:** U9, U10.

### Risk

- **Weakest source:** `[UNVERIFIED]` (Q7 ticket-owner answer; 10-01 note point 3 from Joe).
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** documents customers receive; a wrong total is customer-visible.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| `quotation-pdf.service.ts` group rows and foot lines (R2, R3) | shared helper | `quotation-pdf.service.spec.ts` updated; a Crane Time group case and a no-group quote unchanged | `spec.md` REQ-14 |
| Browser print (`print-quotation*.ts(x)`, R3) | shared helper | new print helper test; `print-quotation` snapshot or model test for a quote with no groups unchanged | REQ-14 |
| Quotation email and signing flow (sibling 6) | shared helper | `quotation-email-context` test | `spec.md` §11c sibling 6 |
| Mobile consumers of `@tcg/shared` | additive export | mobile typecheck + jest | `spec.md` §7 |

### Deliberately not in this unit

- Invoices — no invoice model exists (§11a).

---

## U9 — Conversion: dispatch column and one slot per configured machine

- **Outcome:** Converting a quote to a job (all three entry points) copies every quote line as today, marks each job line `REQUIRED`, `OPTIONAL` or `NONE` for dispatch, and the dispatch board shows one slot per configured machine and none for the price lines inside Mobilization/Demobilization.
- **Kind:** vertical
- **Requirements covered:** REQ-15, REQ-16 — fully. (`OPTIONAL` slots behave as `REQUIRED` until U10.)
- **Depends on:** U7
- **Branch / PR base:** `feat/TCG-218-u9-conversion-dispatch-column`, stacked on U7's branch (may run parallel with U8).
- **Size estimate:** ~330 source lines, 14 source files. **At risk** — ~50 files read `JobResource`. Split line: the board reading `dispatch` (DAS readers) stays in U9; the REQ-15 materialization test-only proof is the first thing to trim if over.
- **Developer decisions implemented:** D7 (one `JobResource.dispatch` column: `REQUIRED` default / `OPTIONAL` / `NONE`; lines inside Mob/Demob `NONE`; equipment in a group not in the crane's configuration `OPTIONAL`; everything else `REQUIRED`), D8 (same column), D12, sibling 3 (all three entry points via `createJobFromQuotationInTx`).

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `JobResource` gains `dispatch`, default `REQUIRED` | Migration `add_job_resource_dispatch`; `jobresource` is already in `TENANT_SCOPED_MODELS`. Enum vs string is not stated by D7 — executor proposes, developer states. `tcg-prisma-guardian` reviews |
| API (`apps/api`) | `projects.service.ts` `createJobFromQuotationInTx` (loop ~373) sets the value from the crane link (U4) and the asset configuration; `materialize-job-resources.ts` keeps materializing Always Included associations hidden on the quote and skipping Optional; `usecase/das/` (`das.repository.ts`, `sub-job.mapper.ts`, `missing-required-components.util.ts`) read `dispatch` to leave `NONE` rows off the board | Copy of every line is unchanged, so job financial/payroll readers (R8) see the same rows |
| Web (`apps/web`) | N/A — the board consumes API output | |
| Mobile (`apps/mobile`) | none | |
| Shared (`packages/shared`) | N/A — unless the contract tracer finds a shared job type | |
| Tests | conversion unit: one slot per machine, none for price lines, unconfigured added machine `OPTIONAL`; Operator Load's hidden tractor and operator become job rows; an Optional association not on the quote does not; `materialize-job-resources.spec.ts`; all three entry points covered | |

### Reviewable as

- **Demo:** Convert the 100 Ton Hourly w/ Mob quote (support load inside Mobilization, not in the configuration): job opens with the configured machines as slots, the support load as an extra slot, no slot for Mobilization, Demobilization or Price Adjustment lines.
- **Acceptance:** REQ-15, REQ-16 acceptance lines.
- **Reviewer can verify without:** U8, U10.

### Risk

- **Weakest source:** `[UNVERIFIED]` — Q12 reverses the ticket owner's own earlier ruling; Q10 and Q18 are assumptions pending Lisette's review.
- **Migration reversible:** yes — one defaulted column; but jobs converted after release carry `NONE`/`OPTIONAL` values, so a rollback leaves those rows behaving as `REQUIRED`.
- **Behind a flag:** no.
- **Touches existing data:** no — default `REQUIRED` equals today's behaviour for every existing job.
- **Blast radius:** the dispatch board and every conversion; if wrong, a machine silently has no slot.

> **U4d ripple (Q43, 2026-10-16):** a Mobilization group now starts with the crane itself (same `subCategoryId` as the crane line). Key "lines inside Mob/Demob -> `NONE`" on the parent group, never on the sub-category, so that line is not read as extra equipment or a second crane slot; cover it in this unit's checks.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| The three conversion entry points (`createFromQuotation`, `convertQuotationToJob`, `attachQuotationToProject`) | shared `createJobFromQuotationInTx` | a conversion test per entry point | `spec.md` §11c sibling 3 |
| `materialize-job-resources.ts` | Optional skip and nested levels | `materialize-job-resources.spec.ts` unchanged and green | `spec.md` REQ-15 (matches current code; observation, not a source) |
| DAS readers: `das.repository.ts`, `sub-job.mapper.ts`, `missing-required-components.util.ts`, `das-dispatch-packet.service.ts` | `dispatch` filter | `sub-job.mapper.spec.ts`, `das-dispatch-packet.service.spec.ts` unchanged for `REQUIRED` rows; new `NONE` case | `spec.md` REQ-16, Q10 |
| ~50 `JobResource` readers: payroll, tickets, holdover, progress, `das-loadout` (R8) | rows still copied | `git grep -l -i jobResource -- apps/api/src` list reviewed; no reader changes; one financials/payroll reader test that sees group rows | Q10 (job financials unchanged), D7 |

### Deliberately not in this unit

- `OPTIONAL` slots not blocking completion, any-day allocation — U10.

---

## U10 — Optional slots: any day, never block completion

- **Outcome:** A dispatcher can allocate an `OPTIONAL` slot (equipment quoted only inside Mob/Demob, or added outside the configuration) on any day, and leaving it empty does not block "allocation completed" or Send Tickets; holdover items still go to all days as today.
- **Kind:** vertical
- **Requirements covered:** REQ-17, REQ-18, REQ-19, REQ-20 — fully. (REQ-18 and REQ-19 describe the absence of a day restriction; the proof is a test that none exists and that visits create no required days.)
- **Depends on:** U9
- **Branch / PR base:** `feat/TCG-218-u10-optional-dispatch-slots`, stacked on U9's branch.
- **Size estimate:** ~170 source lines, 8 source files. Within 400 / 25.
- **Developer decisions implemented:** D8 (the `OPTIONAL` value of the D7 column; no required-days storage), D12.

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — column from U9 | |
| API (`apps/api`) | `usecase/das/` completion and Send Tickets checks (`missing-required-components.util.ts`, `das.service.ts`) skip `OPTIONAL` slots; allocation accepts any day; holdover path unchanged | |
| Web (`apps/web`) | DAS board: do not mark an empty `OPTIONAL` slot as missing/blocking; allocation affordance on any day | Presentation of an optional slot is not specified — executor asks (reuse existing DAS components) |
| Mobile (`apps/mobile`) | none | |
| Shared (`packages/shared`) | N/A | |
| Tests | API: all `REQUIRED` slots filled and an `OPTIONAL` slot empty means allocation completes and tickets send; holdover item occupies all days; a one-day job is one trip; raising visits creates no required days | |

### Reviewable as

- **Demo:** On the converted job, leave the Mob-only support load unallocated, fill the rest, mark allocation completed and send tickets; both succeed. Allocate the support load on a middle day. Mark a held item holdover: it appears on all days.
- **Acceptance:** REQ-17, 18, 19, 20 acceptance lines.
- **Reviewer can verify without:** U8.

### Risk

- **Weakest source:** `[UNVERIFIED]` — Q13–Q16 are working assumptions, Lisette not asked.
- **Migration reversible:** N/A — no migration.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** completion gate on the dispatch board; if `REQUIRED` rows were mis-marked `OPTIONAL` a real gap would not block. U9's tests pin the mapping.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | Regression proof in this unit | Source for what happens to it |
| --- | --- | --- | --- |
| "Allocation completed" and Send Tickets checks (`missing-required-components.util.ts`, `das.service.ts`) | skip `OPTIONAL` | existing spec cases with every `REQUIRED` slot unchanged; new optional case | `spec.md` REQ-17, Q16(2) |
| Holdover behaviour (`JobResource.isHoldover`, job holdover) | none changed | holdover all-days test unchanged | `spec.md` REQ-20, Q16(1) |
| Build-only item crews, Copy Allocations | unchanged | none — `none — unchanged`: not read or written by this unit; `dispatch/gaps.md:1038`, `:1059` record them as unwritten in the vault | `spec.md` REQ-20 |

### Deliberately not in this unit

- Build-only item crews and Copy Allocations behaviour — unwritten in the vault, unchanged (REQ-20).

---

## Sequencing

```
U1 ──▶ U2 ──▶ U3 ──▶ U4 ──┬──▶ U5 ──┐
                          └──▶ U6 ──┴──▶ U7 ──┬──▶ U8
                                              └──▶ U9 ──▶ U10
```

Quote side lands first (U1–U8), dispatch side last (U9–U10).

- **Parallelisable:** **U5 and U6** after U4 — U5 edits group header rendering (`resources-rows-list.tsx`, `resource-row*`, the chip); U6 edits mirror/rename/delete logic and billing-code handling (`resources-tab.callbacks.ts`, `resources-tab.state.helpers.ts`, `resource-row.rate-column.tsx`, DTO validation); they share no file in the plan, but both are in `resources-tab*`, so rebase the later onto the earlier. **U8 and U9** after U7 — U8 touches `packages/shared` (new helper), `quotation-pdf.service.ts`, print, email context; U9 touches `projects.service.ts`, `materialize-job-resources.ts`, `usecase/das/`, `schema.prisma` (the only schema change in either); no shared file. Everything else is strictly sequential: U1–U4 are a chain of schema changes, and any two units that touch `apps/api/prisma/schema.prisma` are not parallel.
- **Merge order constraint:** migrations land in unit order — `add_association_quote_settings` (U1), `add_nested_association_settings` (U2), `add_quotation_type` (U3), `add_quotation_resource_crane_link` (U4), `reset_group_visits_to_one` (U7, data only), `add_job_resource_dispatch` (U9). Dependent units ship as stacked PRs (each branches from its dependency and targets its branch). No "same branch, one PR" layout; a developer who wants one PR sets `size-exception` per PR themselves.
- **Cross-unit windows (stated, not hidden):**
  - **W1 (U3 to U4):** Hourly w/ Mob can be chosen and is saved, but renders the Hourly layout. Merge U4 right after U3.
  - **W2 (U4 to U5/U6):** groups render as today's rows and totals are x1 until U7.
  - **W3 (U4 to U7):** group-total maths still ignores visits; visits are not editable until U7.
  - **W4 (U7 to U8):** customer documents show the old group presentation (PDF hides children, print leaks them) while totals already multiply by visits. Merge U8 right after U7, before release to customers.
  - **W5 (U9 to U10):** `OPTIONAL` slots block completion like `REQUIRED` ones.
  - Mobile: `@tcg/shared` changes in U7 and U8 reach mobile; mobile group rows carry quantity 1, so mobile totals are unchanged, and mobile has no Quotation Type or settings until TCG-219 (Q9). Each such unit runs the mobile typecheck and jest.
- **First unit to ship:** **U1.** It proves the plan's riskiest shared assumptions at the smallest size: a migration with a backfill over existing rows, an in-place DTO extension (D10) that reaches web and mobile contracts, both association writers (sibling 1) agreeing, and the contract-tracer and guardian reviews working on this ticket. Every later unit reads these flags.

**Totals (estimates):** ~3,110 source lines across ~139 source files in 10 PRs (tests, migrations excluded). Five units flagged at risk of the 400-line budget (U2, U4, U7, U8, U9), each with a named split line above.

---

## U11 — Freeze the asset configuration with the quote (Q51)

- **Outcome:** A quote stores the crane's asset configuration when it is saved; quote -> job conversion (materialization, U9 dispatch) and the dispatch board's missing-required-components check use that stored copy, so changing an asset configuration only affects quotes saved afterwards.
- **Kind:** vertical
- **Requirements covered:** §12 Q51.
- **Depends on:** U9 (dispatch classification reads the configuration), U10.
- **Branch / PR base:** `feat/TCG-218-u11-config-snapshot` from `origin/main`.
- **Size estimate:** not estimated — shape open (Q51).
- **Developer decisions needed before build:** snapshot shape, contents, refresh moment, job copy, legacy quotes/jobs (Q51 "Open for U11"). Schema change -> `tcg-prisma-guardian`; contract -> `tcg-contract-tracer`.


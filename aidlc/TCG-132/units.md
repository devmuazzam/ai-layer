# Units — TCG-132 Create Permit modal on All Permits

> Written 2026-10-29 by `tcg-decomposer` from the approved `spec.md` beside it (8 REQs, 0 open).
> Nothing is built. Field list per `.ai/aidlc/templates/units.md`.

## Gate baseline

**Gate baseline:** *`2026-10-29`, `origin/main` at `446a647d3` (clean checkout, real run with
`NODE_OPTIONS=--max-old-space-size=4096`) — lint: **0 errors** on every project (warnings only: 678 / 404 /
336 across the three lint runs, mostly `no-explicit-any`); typecheck: **pass**; build: **pass**; test:
**fail, inherited** — `@tcg/api` 293 suites / 3419 tests pass; `@tcg/shared` pass; `@tcg/web:test` fails
**before any test runs** at the `scripts/check-dropdown-preloads.sh` guard
(`apps/web/src/features/customers/components/molecules/customer-draft-price-list-notice.tsx:30`, `limit: 100`);
`@tcg/mobile:test` 10 suites / 19 tests fail (`signer-capture`, `quotes/[id]`, `step-dispatch`, `field`,
`alerts`, `returned-correction-dispatch`, `notifications-sheet`, `start-work-returned-correction`,
`needs-attention-section`, `use-ticket-progress`).* None of these are in permit or purchase-order code.
Consequence for every web unit: the web test target is red on `main`, so web units cannot show a green
`pnpm test`; they report "same single dropdown-guard failure, nothing new" and **must not add a preloading
picker** (`limit` 100+) of their own — that same guard would fail on their code too.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | A permit can be created through `POST /permits` with every field (route, valid-from, travel dates, planner, FAA block, dates), no Valid till, Annual Travel in the create catalog, and new permits start at Open | REQ-03, REQ-04, REQ-05 (schema + API part) | schema, api, shared | — | ~450 lines / 12 files | not started |
| U2 | PO date and Bill to customer can be set and seen on Purchase Orders (create, edit, detail pages and API) | REQ-06 (schema, API, standalone PO pages, `GeneratePoModal` optional fields; **not** the Create Permit nested variant) | schema, api, web | U1 (migration order, `schema.prisma`) | ~350 lines / 14 files | not started |
| U3 | Track Permits lists every permit, shows asset/vendor identity on job-less cards, and status actions + PO attach work for asset- and vendor-linked permits | REQ-08 | api, web | U1 | ~200 lines / 6 files | not started |
| U4 | "+ Create Permit" on All Permits opens a modal that creates Encroachment, Sub Hauler and Annual Travel permits (with existing-PO attach), leave prompt, validation | REQ-01, REQ-02 (Top row, Assignment, Location, Schedule, Cost, PO for Encroachment / Sub Hauler / Annual), REQ-03 (web part: modal type list + labels), REQ-06 (PO required rule, existing-PO attach, acceptance 1, 2-attach, 6) | web | U1 | ~700 lines / 8 files | not started |
| U5 | The modal also creates Travel permits (Origin yard / Destination job site, travel dates) and FAA permits (airport, flight details, FAA filing) | REQ-02 (Travel, FAA sections), REQ-05 (web part) | web | U4 | ~450 lines / 5 files | not started |
| U6 | Files can be added to "Submitted Application" and "Final Permit" in the modal, with expiry, and are saved with the permit | REQ-07 | web | U4 | ~200 lines / 3 files | not started |
| U7 | The modal's Purchase Order field has "Create new": nested Create PO with PO date, Bill to customer, PO fee prefilled, linked to the permit being created | REQ-06 (nested Create PO, acceptance 2-create, 3, 4) | web | U4, U2 | ~350 lines / 5 files | not started |

- **Status** values per the template; `tcg-executor` writes its own row, `close-ticket` flips `built` to `merged`.
- Requirements covered: REQ-01..REQ-08, counted against `spec.md` §2 on **2026-10-29** — 8 in spec, 8 covered,
  0 uncovered. Partly-covered REQs and where the rest lives: REQ-02 = U4 + U5; REQ-03 = U1 (shared + API) + U4
  (modal type list); REQ-05 = U1 (columns, API) + U5 (pickers); REQ-06 = U2 + U4 + U7. **Recount whenever §2
  gains a REQ.**
- Not covered: none.
- Units blocked on an open question: **none** (`spec.md` §12: no question open; Q1-Q5 answered 2026-10-29).
- **Closing step C1 (not a client-repo unit, no PR in the code repo):** `tcg-scrum` writes
  `decisions/2026-10-29-all-permits-create-permit-modal.md` and the vault edits listed in `spec.md` §13a (items
  1-9), flips §12 statuses to `resolved`. It should run **before U1 is built** (state.md Resume lists it as the
  next step), because the sources of REQ-03/04/08 stay `[UNVERIFIED]` until it exists.
- **Not ready for an executor until settled (flagged, see "Findings for the developer" in the closing report
  and U1 Risk):** U1 — the existing E2E specs assert the old start status (`APPLICATION_SUBMITTED`); the spec's
  ripple row 15 says none do.

---

## U1 — Permit create API: every field, Annual Travel in the catalog, start at Open

- **Outcome:** An API client (and, visibly, the three existing create pages) can create a permit with Valid from,
  Travel from/to, Origin yard, Destination job site, planner, due date, submitted/received dates and the FAA
  block, with no Valid till; Annual Travel appears in the Type dropdown of the existing create pages; every new
  permit starts at Open.
- **Kind:** vertical. Not a layer split: the migration, shared catalog change and `PermitsService.create` change
  are one behaviour, and the user-visible parts (Annual in dropdown, Open start status in Track Permits) work
  with no new UI.
- **Requirements covered:** REQ-03 (shared catalog, optional secondary link, API association rules — fully on
  the API side), REQ-04 (fully), REQ-05 (columns, DTO, resolvers, response labels — the pickers are U5)
- **Depends on:** —
- **Branch / PR base:** `feat/tcg-132-u1-permit-create-fields` from `origin/main`
- **Size estimate:** ~450 source lines, 12 files

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `Permit` + `valid_from` (Timestamptz), `travel_from`, `travel_to` (Date), `origin_yard_id`, `destination_job_site_id` (Uuid FK, `onDelete: SetNull`), back-relations on `Yard` and `JobSite`, `@@index` on both FKs | One additive migration, all nullable, no backfill. **Review: `tcg-prisma-guardian` on the migration before PR.** Latest migration at spec time `20261028120000_add_base_rate_override_calc_trigger`; U1 lands first so U2's migration sorts after it |
| API (`apps/api`) | `create-permit.dto.ts` (new optional fields; `validTill` optional keeping `IsNotBeforeToday`); `permits.service.ts` `create` (association via the D3 helper, `resolveYardId` / `resolveJobSiteId`, planner resolve, `validFrom <= validTill` and `travelFrom <= travelTo` 400s, `trackableStatus: 'OPEN'`, Travel job+asset reuse `assertJobAssetSlotFree` / `syncJobAssetAssignment`); `permits.repository.ts` (findOne includes yard / job-site labels); `PERMIT_TRACKED_KEYS` gains the five new keys; `permits.module.ts` provider if yard/job-site repositories are not yet there | **Review: `tcg-contract-tracer`** on the permit response shape (additive; G5) — result recorded in the PR's AI-decisions table |
| Web (`apps/web`) | none edited. Visible side effect only: `PermitForm` Type dropdown on the three untouched pages gains Annual Travel via the shared constant | Pages stay untouched; the old pages' web validators still send `validTill` |
| Mobile (`apps/mobile`) | N/A — additive response fields only; contracts strip unknown keys | Confirmed by contract-tracer, not by edit |
| Shared (`packages/shared`) | `PERMIT_CREATE_TYPE_VALUES` + `TRAVEL_ANNUAL_PURPLE_PERMIT`, order Travel, Annual, FAA, Encroachment, Sub Hauler; optional-secondary-link helper next to `PERMIT_TYPE_ASSOCIATION` (Travel -> asset, Annual -> job) | Rebuild `dist/` (`pnpm nx build @tcg/shared`) before web typecheck |
| Tests | not requested | Existing suites only. See Ripple for the one existing e2e that this unit contradicts |

### Reviewable as

- **Demo:** (1) `POST /api/v1/permits` as Travel with job + asset + origin yard + destination job site +
  `validFrom` + `travelFrom/To` and no `validTill`; `GET /permits/:permitId` returns every value with yard and
  job-site labels. (2) Open `/permits/create`: Type dropdown lists Annual Travel. (3) Create a permit on any old
  page; `trackableStatus` is `OPEN` and it shows in the Open column of Track Permits when it has a job.
- **Acceptance:** REQ-03 acceptance (combinations accepted / 400), REQ-04 acceptance (all lines except the
  "shows in Open column" clause for asset/vendor-only permits, which U3 delivers), REQ-05 acceptance on the API
  half (GET returns chosen yard and job site).
- **Reviewer can verify without:** U2-U7, any new UI, seed data beyond an existing yard and job site.

### Risk

- **Weakest source:** `[UNVERIFIED]` (every REQ; ticket + Haris 2026-10-29 answers, decision note pending C1).
- **Migration reversible:** yes — five nullable columns and two FKs; dropping them loses only data written after
  deploy. The start-status change is code, reversible by revert; permits already created at Open stay Open.
- **Behind a flag:** no.
- **Touches existing data:** no (nullable columns, no backfill; no G2).
- **Blast radius:** every caller of `POST /permits` — the start status moves for the three untouched create
  pages and any API client (D11, spec §11a row 15); `qa-automation` create/status specs (below); Annual Travel
  appears on three pages the ticket says stay untouched (accepted by Haris).
- **`[UNVERIFIED]` + hard to undo:** the Open start status is code-only and reversible; permits created
  between deploy and any revert would be at Open, which is a valid state. Not the raised combination. Settle the
  sources with C1.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| `/permits/create`, project and asset create pages | `PERMIT_CREATE_TYPE_OPTIONS` / `PERMIT_CREATE_TYPE_VALUES` | Run the three pages by hand: Type lists Annual Travel; creating a Sub Hauler or Travel permit with the old payload (still sends `validTill`, no new fields) returns 201 | `spec.md` REQ-03 Accepted by Haris; §11a row 3 |
| Those pages' validators / payload builder (`associationForPermitType`, `exclusivePermitAssociation`) | shared association helpers | By hand: create an Annual Travel permit from the asset page (asset required, ASSET association) and an existing type; web typecheck against rebuilt `dist/` | §11a row 4 (ASSUMED, nearest behaviour) |
| `PermitsService.create` association check | `assertAssociationMatchesType` | Existing `permits.service.spec.ts` via `pnpm nx test @tcg/api`; hand request: FAA with an asset still 400s | §11a row 5; REQ-03 |
| `PermitsService.update` | association not asserted on update | Hand `PATCH` of an existing permit unchanged | §11a row 6 |
| Expiry sweep, `computePermitEffectiveStatus` | `validTill` null | Existing `permit-status.util.spec.ts`; hand create without `validTill` yields `status` PENDING | §11a row 7 |
| `assertNoActiveDuplicatePermit` | asset-linked create; now `OPEN` passed | Hand: second Annual permit for same asset/type/city is refused as before (both statuses resolve to PENDING) | §11a row 8 |
| Mobile `permit.contract.ts`, `job-artifacts.contract.ts` | permit response | `tcg-contract-tracer` run recorded; `grep -rln validTill apps/mobile` | §11a row 10 |
| `routeInformation` readers (`artifact-detail.tsx`, `field-tickets.service.ts`, mobile `job-artifacts-section.tsx`) | free-text route column | Not touched; `git diff --stat` shows none of them | §11a row 11 (D4) |
| **`qa-automation/e2e/specs/permits/create.spec.ts:97` and `status.spec.ts:20, 61`** | assert `trackableStatus: 'APPLICATION_SUBMITTED'` right after `permitApi.create` | **They will fail once create starts at Open.** The spec (§11a row 15) says none assert a start status; that is wrong. Either the developer approves updating those three expectations (an edit of existing tests, not a new test) in this unit, or D11 is narrowed. **Needs a developer decision before U1 is built.** | `spec.md` §11a row 15 / D11 — and the contradiction above |

### Deliberately not in this unit

- The modal and any picker (Origin / Destination, planner, PO) — U4, U5
- PO columns — U2
- Tracker filter / vendor label — U3
- New fields on the old create / edit pages, table, detail, print — follow-up (`spec.md` §11c, §13)

---

## U2 — Purchase order: PO date and Bill to customer

- **Outcome:** A user can enter and see PO date and Bill to customer on the standalone PO create, edit and
  detail pages and via `GeneratePoModal`; legacy POs read "Not set" and are not rewritten by opening and saving.
- **Kind:** vertical (schema + DTO + responses + the PO screens that show the fields).
- **Requirements covered:** REQ-06 — the two columns, DTOs, responses, standalone PO screens (D13), acceptance
  line 5, and `GeneratePoModal`'s two optional fields. **Not** the Create Permit nested variant (U7).
- **Depends on:** U1 — migration order and `schema.prisma` (both edit it). No code dependency.
- **Branch / PR base:** `feat/tcg-132-u2-po-date-bill-to` stacked on `feat/tcg-132-u1-permit-create-fields`
  while U1's PR is open.
- **Size estimate:** ~350 source lines, 14 files

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | `PurchaseOrder` + `po_date` (`DateTime? @db.Date`), `bill_to_customer` (`Boolean?`, no DB default) | One additive migration after U1's. **Review: `tcg-prisma-guardian`** (D12: nullable, no default of `true`). No `TENANT_SCOPED_MODELS` change (model already scoped) |
| API (`apps/api`) | `create-purchase-order.dto.ts`, `update-purchase-order.dto.ts` (`poDate?`, `billToCustomer?`; `GeneratePoDto` inherits via `OmitType`), `PO_TRACKED_KEYS`, confirm `enrichPurchaseOrders` spreads the scalars | **Review: `tcg-contract-tracer`** on PO list/detail response shape (additive, G5) |
| Web (`apps/web`) | `po-form-fields.tsx`, `po-form.tsx`, `po-edit-form-card.tsx`, `po-detail-view.tsx`, `map-po-form-state.ts`, `po-form-payload.ts`, `po-form.types.ts`; `GeneratePoModal` / `PoFormCard` gain the two optional fields | Edit sends the fields only when changed. PO list table: no new column. Bill to customer toggle defaults on for **new** POs only |
| Mobile (`apps/mobile`) | N/A — `purchase-order.contract.ts` zod strips unknown keys | tracer confirms |
| Shared (`packages/shared`) | N/A | |
| Tests | not requested | |

### Reviewable as

- **Demo:** PO create page: set PO date and Bill to customer, save; PO detail shows both; open a pre-existing
  PO's detail ("Not set"), open edit and save with no change, re-open: still "Not set".
- **Acceptance:** REQ-06 acceptance 4 (API half) and 5.
- **Reviewer can verify without:** U3-U7, any permit.

### Risk

- **Weakest source:** `[UNVERIFIED]` (Haris Q1 answer + prototype; decision note pending C1).
- **Migration reversible:** yes — two nullable columns.
- **Behind a flag:** no.
- **Touches existing data:** no (null on every existing row, deliberately no default).
- **Blast radius:** every PO screen and caller of `GeneratePoModal`; a PO response shape gains two keys.
- **`[UNVERIFIED]` + hard to undo:** low — nullable, additive. What Bill to customer *does* downstream is
  `NOT SPECIFIED` (`spec.md` §13); this unit stores and shows only. **Do not let any invoice, quote or report
  read the flag in this ticket**; raise first.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| `PurchaseOrder` DTOs, `enrichPurchaseOrders`, PO list/detail responses | two new nullable columns | Existing API tests via `pnpm nx test @tcg/api`; hand `GET /purchase-orders` and `/:poId` | `spec.md` §11a row 12; Haris Q1 |
| PO create / edit / detail pages | `PoFormState`, `buildPoPayload` | By hand: create a PO with neither field, edit a legacy PO untouched, confirm payload omits both (network tab) | §11a row 16; D13 |
| `GeneratePoModal` callers (`ArtifactPoWidget`, permit detail) | `PoFormCard` | By hand: generate a PO from a permit detail page and from the artifact widget with Agency and items intact | §11a row 17; D13 |
| Mobile `purchase-order.contract.ts` + mock; `qa-automation` PO page objects | PO response / `data-testid` | contract-tracer; `grep -rln "purchase-order" apps/mobile/data qa-automation/e2e/specs/purchase-orders`; no `data-testid` renamed | §11a row 20 (ASSUMED additive) |
| PO activity log | `PO_TRACKED_KEYS` | By hand: edit a PO's PO date, log line appears | REQ-06 Notes |

### Deliberately not in this unit

- Create Permit modal's PO variant (no Agency, no items, PO date required, fee prefill) — U7
- Any downstream use of Bill to customer — unspecified (`spec.md` §13)
- PO "Notes" field — omitted by spec decision, awaiting Haris only if he wants a third column

---

## U3 — Track Permits lists every permit

- **Outcome:** Annual Travel (asset-only) and Sub Hauler (vendor-only) permits, old and new, appear on Track
  Permits and its All Permits tab with an asset code or vendor name on the card, and Submit / Approve / Cancel
  and PO attach work on them.
- **Kind:** vertical.
- **Requirements covered:** REQ-08 (fully)
- **Depends on:** U1 (permits created at Open; shared `PermitTrackerResponse` / repository file region)
- **Branch / PR base:** `feat/tcg-132-u3-track-all-permits` stacked on U1's branch while open.
- **Size estimate:** ~200 source lines, 6 files

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A — no schema change | |
| API (`apps/api`) | `permits.repository.ts` `findAllForTracker` (drop `jobId: { not: null }`, select vendor relation); `PermitTrackerResponse` + mapper gain vendor label; verify `purchase-order-permit-share.util.ts` for no-job / no-project | **Review: `tcg-contract-tracer`** (tracker response gains a field, G5). Confirm the tracker's Sub Hauler type filter and search do not depend on job |
| Web (`apps/web`) | `artifact-tracker.mappers.ts`, `ArtifactCard` (asset unit code / vendor name when no job), `PurchaseOrderSelect` scope for job-less permits | **PO-picker scope for a permit with neither job nor project has no source: executor picks the narrowest scope that the API will accept and records it as an AI decision (D14).** No `limit` 100+ preload |
| Mobile (`apps/mobile`) | N/A | |
| Shared (`packages/shared`) | N/A | |
| Tests | not requested | |

### Reviewable as

- **Demo:** Track Permits shows an existing asset-linked permit and a vendor-linked permit in their columns;
  cards show unit code / vendor name; on each, Mark Application Submitted (after an application upload),
  Upload Approved Permit (needs PO unless Annual Travel), and Cancel succeed.
- **Acceptance:** REQ-08 acceptance 1-4. Item 1's "created from the modal" half is re-checked after U4.
- **Reviewer can verify without:** the modal (U4+); use existing asset/vendor permits or create via old pages.

### Risk

- **Weakest source:** `[UNVERIFIED]` (Haris Q2; supersedes a `[VERIFIED]` reference decision, note pending C1).
- **Migration reversible:** N/A (no migration).
- **Behind a flag:** no.
- **Touches existing data:** no (a list returns more rows).
- **Blast radius:** Track Permits kanban and tab get more rows (and any asset/vendor permit created before this
  ticket); Plans tracker unaffected. Counts shown on the page change on deploy.
- **`[UNVERIFIED]` + hard to undo:** no (read-path only).

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| Track Permits kanban + tab (`findAllForTracker`) | `jobId: { not: null }` | By hand on `/permits/track-permits`: job-linked permits still in the same columns; search and sort with null jobs do not error | `spec.md` §11a row 13; Haris Q2 |
| Tracker response, web mappers, `ArtifactCard` | `PermitTrackerResponse` | `grep -rn "PermitTrackerResponse" apps`; web typecheck; contract-tracer; hand: job card still shows job line | §11a row 18; D14 |
| PO picker scope for job-less permits | `PurchaseOrderSelect`, `assertPoShareableWithPermit` | By hand: attach a PO to an asset-only permit; picker offers only POs the API accepts; Plans tracker picker unchanged | §11a row 19; D14 (executor decision, recorded) |
| Plans tracker (`permits-plans`) | shares card / mappers | By hand: Plans tracker unchanged | REQ-08 "Does not apply when" |

### Deliberately not in this unit

- Anything on the Create Permit modal — U4+
- Showing the new route / valid-from fields on cards — out of the card's scope (`spec.md` §13)

---

## U4 — Create Permit modal: shell + Encroachment, Sub Hauler, Annual Travel

- **Outcome:** A user on All Permits clicks "+ Create Permit", picks Encroachment, Sub Hauler or Annual Travel,
  fills the form (planner picker, due date, agency / state / city, dates, cost), attaches an existing PO and
  creates the permit; leaving with data prompts to save.
- **Kind:** vertical.
- **Requirements covered:** REQ-01 (fully); REQ-02 — Top row, Assignment, Location, Schedule & Validity, Cost &
  Application, PO row for Encroachment, Sub Hauler, Annual (Travel and FAA sections: U5); REQ-03 web part
  (modal type list in order with modal-only labels, D8; the Type list shows all five names, but Travel and FAA
  bodies are U5); REQ-06 — required rule, existing-PO attach, acceptance 1, 2 (attach), 6 (the PO-failure
  message; "Create new" is U7).
- **Depends on:** U1 (API fields, catalog, Open). Demo of "appears on Track Permits" also needs U3.
- **Branch / PR base:** `feat/tcg-132-u4-create-permit-modal` stacked on U1's branch while open.
- **Size estimate:** ~700 source lines, 8 files

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | |
| API (`apps/api`) | N/A — consumes U1 and existing `PATCH /permits/:id/purchase-order` | |
| Web (`apps/web`) | `CreatePermitModal` in `src/features/permits/components/` (config-driven per-type sections, D9; modal-local label map, D8); "+ Create Permit" button on `/permits/all-permits` (`showCreateButton` path, header comment updated); validation per `web.md` Forms; leave prompt (reuse existing unsaved-changes dialog / `unsaved-changes-guard` if present); `EmployeeSelect` for planner; existing agency / city / asset / vendor / job pickers; `PurchaseOrderSelect`; `useCreatePermit` then attach PO (D5) | Type is the only field until chosen; changing Type clears everything. `PermitForm` and `PERMIT_TYPE_LABELS` untouched. Reuse before create: `find-component` first. **No preloading picker** (baseline dropdown guard). Footer in the PO field omits "Create new" until U7. New `data-testid`s `<module>-<flow>-<element>` |
| Mobile (`apps/mobile`) | N/A | |
| Shared (`packages/shared`) | N/A | |
| Tests | not requested | |

### Reviewable as

- **Demo:** `/permits/all-permits` -> "+ Create Permit" -> pick Sub Hauler: Vendor and PO required; submit
  empty shows "Vendor is required" / "Purchase order is required", first empty dropdown opens; fill, create;
  permit detail shows the PO linked. Repeat for Encroachment and Annual (no PO). Close with data entered: the
  three-button prompt.
- **Acceptance:** REQ-01 acceptance (all); REQ-02 table rows for the three types; REQ-06 acceptance 1, 2 (existing
  PO), 6 (simulate a failed PO attach: message names the new permit code).
- **Reviewer can verify without:** U2, U5, U6, U7.

### Risk

- **Weakest source:** `[UNVERIFIED]` (prototype capture + Haris answers). Supersedes a `[VERIFIED]` hide-create
  decision by Haris's explicit decision.
- **Migration reversible:** N/A.
- **Behind a flag:** no — consider the button itself the switch; the spec names no flag.
- **Touches existing data:** no.
- **Blast radius:** All Permits hero; a permit created without a PO stays a valid state (D5, D6).
- **`[UNVERIFIED]` + hard to undo:** no.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| `/permits/all-permits/page.tsx` | `showCreateButton={false}` + comment | By hand: button shows; hero otherwise unchanged | `spec.md` §11a row 1; Haris 2026-10-29 |
| Other `PermitsListing` users (asset detail Permits tab, Track Permits) | `showCreateButton` prop | By hand: no button on `/permits/track-permits` or the asset Permits tab | §11a row 2 |
| `/permits/create`, project / asset create pages | shared `PermitForm`, options | By hand: all three still load and create (no edit to `PermitForm`; `git diff --stat`) | §11a row 3 |
| Permit-type labels (list, filters, tracker, print, DAS pre-checklist) | `PERMIT_TYPE_LABELS`, `formatPermitType` | `git diff` shows neither touched; list page labels unchanged by hand | §11a row 14; D8 (Haris Q5) |
| Permits list / stats queries | TanStack invalidation after create | By hand: new permit appears in All Permits without reload | `spec.md` §5 Server state |

### Deliberately not in this unit

- Travel and FAA bodies (Route, Travel date(s), Airport, Flight, FAA filing) — U5
- Attachments cards — U6
- "Create new" PO — U7

---

## U5 — Create Permit modal: Travel and FAA

- **Outcome:** The modal also creates Travel permits (Origin yard, Destination job site, travel dates, valid
  from / to) and FAA permits (airport, flight details, FAA filing).
- **Kind:** vertical.
- **Requirements covered:** REQ-02 (Travel and FAA columns), REQ-05 (web part: pickers; API half in U1)
- **Depends on:** U4
- **Branch / PR base:** `feat/tcg-132-u5-modal-travel-faa` stacked on U4's branch while open.
- **Size estimate:** ~450 source lines, 5 files

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | |
| API (`apps/api`) | N/A — consumes U1 | |
| Web (`apps/web`) | Extend the section config with Route (Origin yard picker, Destination job-site picker), Travel date(s) (single or range), Airport, Flight details (two checkboxes), FAA filing; Travel's Job / Project* and optional Asset; required marks for Travel (Type, Job, PO) and FAA (Type, Job, PO); Notes 0/400 via `RichTextArea` | Origin = active yards by name, Destination = job sites; no prefill from the Job (REQ-05 ASSUMED). Server-searched pickers (check `features/yards` and the job-site API first) |
| Mobile (`apps/mobile`) | N/A | |
| Shared (`packages/shared`) | N/A | |
| Tests | not requested | |

### Reviewable as

- **Demo:** Create a Travel permit with job, asset, origin yard, destination job site, travel date range, valid
  from/to, PO; open it: values returned. Create an FAA permit with flight details and FAA filing.
- **Acceptance:** REQ-02 rows for Travel and FAA incl. the "not listed means not rendered" rule; REQ-05
  acceptance (picker lists, saved values).
- **Reviewer can verify without:** U6, U7, U2.

### Risk

- **Weakest source:** `[UNVERIFIED]`; Origin = yard conflicts with the travel-permits playbook SOP (origin is the
  freeway exit) — accepted by Haris Q3, not reconciled.
- **Migration reversible:** N/A.
- **Behind a flag:** no.
- **Touches existing data:** no.
- **Blast radius:** modal only.
- **`[UNVERIFIED]` + hard to undo:** the stored origin/destination semantics (yard FK = origin) are already in
  U1's schema; if Haris later redefines Origin, U1's columns are the cost, not this unit.

### Ripple — what already works that this unit reaches

none — new surface only (`grep -rn "originYard\|destinationJobSite" apps/web/src` shows no existing consumer
before this unit; `routeInformation` readers are untouched, `spec.md` §11a row 11).

### Deliberately not in this unit

- Showing route / valid-from on permit table, detail, print, edit — follow-up (`spec.md` §11c, §13)
- Destination default from the chosen Job — `NOT SPECIFIED`

---

## U6 — Create Permit modal: attachments

- **Outcome:** A user adds files to "Submitted Application" and "Final Permit" cards with an optional expiry;
  they are uploaded after the permit exists and appear under the right category on the permit detail.
- **Kind:** vertical.
- **Requirements covered:** REQ-07 (fully)
- **Depends on:** U4
- **Branch / PR base:** `feat/tcg-132-u6-modal-attachments` stacked on U4's branch while open (U5 and U6 touch
  the same modal component file; see Sequencing).
- **Size estimate:** ~200 source lines, 3 files

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | |
| API (`apps/api`) | N/A — shared attachments service as shipped | |
| Web (`apps/web`) | Two-category config passed to `CategorizedAttachmentsSection` / `PendingAttachmentsSection`; upload after `POST /permits` succeeds; upload-failure handling as U4's PO-failure (permit kept, user told) | Category names must be the ones the artifact flow uses (`SUBMITTED_APPLICATION_CATEGORIES`, "Final Permit") because the submit/approve gates count them. `PERMIT_ATTACHMENT_CATEGORY_CONFIG` not edited |
| Mobile (`apps/mobile`) | N/A | |
| Shared (`packages/shared`) | N/A | |
| Tests | not requested | |

### Reviewable as

- **Demo:** Add a file with an expiry to each card, create; permit detail lists them under the right cards,
  expiry stored; then Mark Application Submitted on Track Permits passes the application-upload gate.
- **Acceptance:** REQ-07 acceptance.
- **Reviewer can verify without:** U5, U7.

### Risk

- **Weakest source:** `[UNVERIFIED]`.
- **Migration reversible:** N/A. **Behind a flag:** no. **Touches existing data:** no.
- **Blast radius:** modal only; a wrong category name silently defeats the submit / approve gates.
- **`[UNVERIFIED]` + hard to undo:** no. Files stored under a wrong category name are a data-quality cost, so
  check the category strings against the artifact flow before building.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| Old create forms' attachments (`PermitCategoryAttachments`, `PERMIT_ATTACHMENT_CATEGORY_CONFIG`) | shared config | By hand: `/permits/create` attachments section unchanged; `git diff` shows config not edited | `spec.md` REQ-07 Ripple |
| Submit / approve attachment gates | category names | By hand: Mark Application Submitted accepts a modal-uploaded application | REQ-07 Ripple |

### Deliberately not in this unit

- Max files per card — `NOT SPECIFIED`, open question lives in `projects-jobs/gaps.md`
- The shipped form's third "Receipt" category — not in the prototype

---

## U7 — Create Permit modal: "Create new" PO

- **Outcome:** From the modal's Purchase Order field a user clicks "Create new", completes the nested Create
  PO (PO date, PO fee prefilled from the permit's service fee, Bill to customer on by default), and the new PO
  is linked to the permit on Create Permit.
- **Kind:** vertical.
- **Requirements covered:** REQ-06 — nested Create PO (acceptance 2 create path, 3, 4)
- **Depends on:** U4 (modal), U2 (PO columns and `GeneratePoModal` fields)
- **Branch / PR base:** `feat/tcg-132-u7-modal-create-po` stacked on U4's branch; U2 must be merged to `main` (or
  already in the base) before this unit is built, because a branch cannot stack on two open branches.
- **Size estimate:** ~350 source lines, 5 files

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | |
| API (`apps/api`) | N/A — `POST /permits/:id/generate-po` already takes the fields after U2 | |
| Web (`apps/web`) | `GeneratePoModal` / `PoFormCard` Create-Permit variant (no Agency, no PO items, PO date required and prefilled with today in tenant timezone, PO fee required and prefilled from service fee, Job preselected or none, Linked permit "This permit (being created)", Invoice upload, Bill to customer toggle on); modal flow: `POST /permits` then `generate-po` (D5) | No Notes field (spec decision, `spec.md` §13). Other callers keep Agency and items |
| Mobile (`apps/mobile`) | N/A | |
| Shared (`packages/shared`) | N/A | |
| Tests | not requested | |

### Reviewable as

- **Demo:** Travel permit: Purchase Order -> Create new -> fields exactly as REQ-06 acceptance 3 -> Create PO ->
  Create Permit; PO appears linked on permit detail and in the PO list with PO date and Bill to customer; the
  existing PO flows still show Agency and items.
- **Acceptance:** REQ-06 acceptance 2 (create path), 3, 4.
- **Reviewer can verify without:** U5, U6, U3.

### Risk

- **Weakest source:** `[UNVERIFIED]` (Haris Q1; prototype). Supersedes a `[VERIFIED]` locked PO modal field set.
- **Migration reversible:** N/A. **Behind a flag:** no. **Touches existing data:** no.
- **Blast radius:** `GeneratePoModal` is shared with the artifact widget and permit detail; a variant switch
  that leaks into them changes existing PO flows.
- **`[UNVERIFIED]` + hard to undo:** no.

### Ripple — what already works that this unit reaches

| Existing consumer | Reached via | How we know it still works | Source for what happens to it |
| --- | --- | --- | --- |
| `GeneratePoModal` callers (`ArtifactPoWidget`, permit detail) | `PoFormCard`, `PoFormValidationOptions` | By hand: open both without the new variant: Agency and items present, PO date optional | `spec.md` §11a row 17; D13 |
| `generatePurchaseOrder` agency inheritance (`dto.agencyId ?? permit.agencyId`) | omitted Agency in the nested modal | By hand: the PO created from the modal has the permit's agency | REQ-06 Conflict note |
| PO list / `PurchaseOrderSelect` option labels | new PO appears | By hand: option reads `PO-nnnnn · counterparty` | REQ-06 acceptance 2 |

### Deliberately not in this unit

- PO Notes field — omitted by spec decision; Haris can reverse in one line (`spec.md` §13)
- Any invoice or quote effect of Bill to customer — unspecified

---

## Sequencing

```
U1 ──▶ U2 ───────────────────────┐
  ├──▶ U3                         ▼
  └──▶ U4 ──▶ U5               U7 (needs U4 and U2)
        └──▶ U6 ───────────────────┘ (sibling of U5, same base)
C1 (tcg-scrum vault/decision note) before U1
```

- **Parallelisable:** U2 and U3 (after U1 is open or merged): U2 edits `schema.prisma`, a new migration, PO
  DTOs and PO web files; U3 edits `permits.repository.ts` `findAllForTracker`, tracker mappers and the
  PO picker, with no PO form file or schema in common. U2/U3 vs U4: no shared files except
  `PurchaseOrderSelect` (U3 scope tweak, U4 consumer) — U4 only reads it. **U5 and U6 are not parallel with
  each other**: both extend the modal component and its section config. U4 is not parallel with U5/U6/U7.
- **Merge order constraint:** migrations land in unit order: U1 (Permit columns) before U2 (PurchaseOrder
  columns), since both edit `schema.prisma`. U7 merges after U2 and U4. The API deploys U1/U3 behavior (Open
  start, tracker filter) before the web ships; permits created in between are valid (`spec.md` §11).
- **Window in which units disagree (cross-surface):** after U1 merges and before any web change, Annual Travel
  shows in the three old create pages' Type dropdown (accepted by Haris); the old pages' web validators still
  require Valid till, so Annual from them is created exactly as today. After U1 and before U3, permits created
  at Open with only an asset or vendor link are valid but do not appear on Track Permits.
- **First unit to ship:** U1 — it carries the riskiest assumptions: the second migration-bearing change to the
  permit table, the association relaxation (D3), and the start status change for every caller (D11), which is
  the one place an unseen consumer (`qa-automation`) already contradicts the spec.

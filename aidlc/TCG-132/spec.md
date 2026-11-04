# Spec — TCG-132 Create Permit modal on All Permits

> Written to `.ai/aidlc/TCG-132/spec.md` by the elaborator from `intent.md` beside it.
> Every requirement carries its sources and their status. Nothing here is implemented.

## Fill rules

`NOT SPECIFIED` = no source says. `N/A — <reason>` = does not apply. `OPEN — <question>` = blocked on a
human and also in §12. `ASSUMED — <what, from where>` = a non-client-facing detail filled from the nearest
existing behaviour.

**Source kinds used here.** `ticket` = the Trello card TCG-132 and the prototype capture reproduced in
`intent.md` Appendix A, confirmed by Syed Haris on 2026-10-29 as the approved spec (`[UNVERIFIED]`:
confirmed by the requester, not adjudicated against the vault). `decision` = `.ai/vault/decisions/` notes,
tagged `[VERIFIED]` per the template, but every one cited here is `status: reference`, decided by
CodingCops people and **not** a TCG client sign-off — read each with that caveat. `vault` = unverified
migrated content. `code` = descriptive only, never behind a requirement.

Because Haris confirmed the prototype, requirements resting on it are **not** also sent as a
"still how it should work?" batch. Open questions in §12 are the points the prototype and Haris's decisions
do not settle.

---

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-132` (Trello #132; Jira unavailable — card text is the ticket) |
| Intent | `.ai/aidlc/TCG-132/intent.md`, captured `2026-10-29` |
| Elaborated on | `2026-10-29`; answers to Q1–Q5 folded in `2026-10-29` (see §12) |
| Answers source | Syed Haris (developer), 2026-10-29, relayed by the coordinator. Recorded as `ticket`-kind sources, `[UNVERIFIED]` until `tcg-scrum` writes the decision notes listed in §13a. |
| Vault state at elaboration | Six `domain/` files verified; ~145 content files unverified; permit topic has **no** conflict stub. Two permit decisions conflict in-tree (`2026-09-10-permit-create-types-mockup-document-types.md` lists `conflicts_with: 2026-09-10-permit-association-scope-asset-job-vendor.md`) — read in REQ-03. `projects-jobs/gaps.md` read by section only. |
| Open questions raised by this spec | 18 raised, **0 open**. Q1–Q7, Q9, Q13 and Q15–Q18 are resolved by Syed Haris (developer direction, `decisions/2026-10-29-all-permits-create-permit-modal.md` incl. Addenda 2026-10-30 and 2026-11-03). Q8, Q10, Q11, Q12 and Q14 have no human answer. They are recorded as AI decisions D20–D25 (`needs developer: yes`) and are **awaiting developer review**. Q14's product question stays open at `projects-jobs/gaps.md#permitpo-reverse-cascades-incomplete`. The prototype re-exploration's other decisions and the U11–U16 build choices are AI decisions D34–D48 (no §12 entry) |
| Already-shipped behaviour reached | 20 consumers in §11a, each with a stated outcome and source |
| Rules consulted | `CLAUDE.md`; `.ai/claude/contexts/api.md`, `prisma.md`, `web.md`, `patterns.md` |
| Sizing | 8 REQs; the spec is well over the ~40 KB guide (tables, not scope). No split proposed. The answers added a second schema change (PurchaseOrder) and a tracker change, both inside REQ-06 / REQ-08. |

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Create Permit modal on All Permits; supersedes hide-create | web | `[UNVERIFIED]` | ticket; decisions | no |
| REQ-02 | Per-type forms and required-ness | web | `[UNVERIFIED]` | ticket | no |
| REQ-03 | Create catalog (Annual Travel) and per-type association | shared, api | `[UNVERIFIED]` | ticket; decisions; vault | no |
| REQ-04 | Create API carries every field; starts at Open | schema, api | `[UNVERIFIED]` | ticket; Haris answer Q4 | no |
| REQ-05 | Route: Origin = yard, Destination = job site | schema, api, web | `[UNVERIFIED]` | ticket; Haris answer Q3 | no |
| REQ-06 | Purchase order on create; PO date and Bill to customer | schema, api, web | `[UNVERIFIED]` | ticket; decisions; Haris answer Q1 | no |
| REQ-07 | Attachments on create | web | `[UNVERIFIED]` | ticket | no |
| REQ-08 | Track Permits lists every permit; status actions for asset- and vendor-linked permits | api, web | `[UNVERIFIED]` | Haris answer Q2; decisions | no |

Counts: 8 total — 0 verified, 8 unverified, 0 conflicted, 0 open. Every REQ rests on the requester-confirmed
prototype and/or Haris's 2026-10-29 answers; none rests on code.

## 2. Requirements

### REQ-01 — Create Permit modal on All Permits; supersedes hide-create `[UNVERIFIED]`

- **Statement:** All Permits shows a "+ Create Permit" button in the hero; it opens a modal titled
  "Create Permit" / "Add a new permit to the system" that replaces the page flow for creating a permit from
  All Permits.
- **Surface:** web
- **Sources:**
  - `.ai/aidlc/TCG-132/intent.md` Appendix A "Entry" — `[UNVERIFIED]` — kind: ticket — button, title,
    subtitle, "Select type" placeholder, hint "Select a permit type to see its form.", footer Cancel /
    Create Permit, type reset on change, leave prompt copy, empty-submit behaviour.
  - Syed Haris, 2026-10-29 (in the requester's note, Appendix A "Decisions") — `[UNVERIFIED]` — kind: ticket
    — prototype is the approved spec and reverses the 2026-09-11 hidden-create decision; modal replaces the
    page flow on All Permits; `/permits/create` and project/asset create pages are left alone.
  - `decisions/2026-09-11-permit-classes-job-only-until-sept-15.md` — `[VERIFIED]` (status: reference;
    Ehtesham Anwar, CodingCops PM) — kind: decision — point 2 "Hide Create Permit … for now"; point 4
    "General-class handling … after 15 September 2026". **Superseded for All Permits by this ticket.**
    The note itself says it is "open to being overruled by TCG" and "defers … does not cancel" manual create.
- **Supersession record (for `tcg-scrum` to write; the elaborator has no write path):**
  Haris's 2026-10-29 decision reverses points 2 and 4 of the note above for All Permits. The note's
  deadline (15 Sep 2026) has also passed (today 2026-10-29). Vault files that need updating — see §13a.
- **Conflict:** none on this requirement beyond the supersession above. `gaps.md` entry
  `projects-jobs/gaps.md#permits-can-no-longer-be-created-outside-the-artifact-flow--and-the-vault-says-they-can`
  (marked "resolved for the interim") is reopened/closed by the new decision note — not by this spec.
- **Open question:** none
- **Ripple:** the All Permits page and `PermitsListing` already carry a `showCreateButton` prop and a
  `handleCreate` that routes to `${basePath}/create`. Other users of `PermitsListing` keep
  `showCreateButton={false}`. See §11a rows 1–2. Established by `grep -rn showCreateButton apps/web/src/features`.
- **Acceptance:** On `/permits/all-permits` a "+ Create Permit" button is visible; clicking it opens the
  modal with only Type and the hint; choosing a type shows that type's form (REQ-02); changing type clears
  all fields including Job and PO; closing with entered data shows "Are you sure you want to leave?" /
  "Do you want to save your changes before leaving?" with Cancel, Leave, Save; submitting empty highlights
  each missing required field with a red border and a message ("Vendor is required", "Purchase order is
  required"), opening the first missing dropdown. The button is **not** added to `/permits/track-permits`
  nor the asset detail Permits tab. `/permits/create`, project and asset create pages still load unchanged.
- **Edges:**
  - **Reached by:** the hero button only. The existing `PermitListingActions` path (route push to
    `/permits/create`) is **not** reached from All Permits any more; it remains reachable by URL.
  - **Does not apply when:** Track Permits, asset detail Permits tab, project permits tab (all
    `showCreateButton={false}` or their own flow).
  - **When an input is absent:** no type selected -> Create Permit submits nothing and shows "Type is required"
    (existing copy `Type is required`).
  - **Trust boundary:** N/A — the server derives tenant, `permitId`, status; the client supplies field values.
  - **Read time:** N/A — no catalogue data frozen into a customer-visible record.
  - **Matrix:** N/A.
- **Notes for the executor:** Reuse `PermitsListing` / `PermitListingActions`, `Dialog` +
  `SCROLLABLE_DIALOG_CONTENT`, `GeneratePoModal` as the shape of a modal that owns a form. No new component
  unless nothing fits (`.ai/claude/contexts/web.md` → Before you create a component). Leave-prompt: reuse the
  existing unsaved-changes dialog if one exists (search `components/` before building).

### REQ-02 — Per-type forms and required-ness `[UNVERIFIED]`

- **Statement:** Each of the five types shows exactly the sections and fields below, with required marks as
  shown, using the prototype's labels.
- **Surface:** web (field values feed REQ-04)
- **Sources:**
  - `.ai/aidlc/TCG-132/intent.md` Appendix A, sections per type — `[UNVERIFIED]` — kind: ticket — the
    catalogue below is a transcription of it.
  - Haris 2026-10-29 — `[UNVERIFIED]` — kind: ticket — Assigned Planner is an employee picker, not free text.
  - `decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md` — `[VERIFIED]` (reference; Brian
    Petros, confirmed by Melissa McNutt) — kind: decision — annual permits get no PO; single permits do. It
    matches the prototype's "Annual: Purchase Order optional / others required".
- **Conflict:** none. (Association vs the existing "exactly one of asset/job/vendor" rule is REQ-03.)
- **Open question:** none for the catalogue. The nested PO modal is REQ-06 (Q1 resolved).
- **Ripple:** none — new surface only for the modal. Established by: the modal is new; the shared
  `PermitForm` (used by the three untouched create pages) is **not** modified — see §11a row 3 and D2.
- **Acceptance:** each row of the catalogue is present with the label shown and the required mark shown; a
  field not listed for a type is not rendered for it.

| Section | Travel Permit | Annual Travel Permit | FAA Permit | Encroachment Permit | Sub Hauler Permit |
| --- | --- | --- | --- | --- | --- |
| Top row | Type\*, Asset (optional) | Type\*, Asset\* | Type\*, Job\* | Type\*, Job\* | Type\*, Vendor\* |
| Job & Location | Job / Project\*, City / Authority, Agency | Job / Project, City / Authority, Agency (all optional) | — | — | — |
| Assignment | — | — | Assigned Planner, Due Date | Assigned Planner, Due Date | same as Encroachment |
| Location | — | — | Agency, State, City | Agency, State, City | same |
| Route | Origin, Destination | — | — | — | — |
| Airport | — | — | Nearest airport, Distance from airport | — | — |
| Schedule & Validity | Travel date(s) (date or range), Application submitted date, Permit received date, Valid from, Valid to | Application submitted date, Permit received date, Valid from, Valid to | — | — | — |
| Purchase Order | required\* | optional | required\* | required\* | required\* |
| Flight details | — | — | Latitude, Longitude, AGL, MSL, Lift window start, Lift window end, "Flight path confirmed with airport authority", "Crane will be lighted and flagged" | — | — |
| FAA filing | — | — | NOTAM number, FAA 7460-1 submission case, Response / tracking | — | — |
| Cost & Application | Service fee, Permit cost, Application number | Service fee, Permit cost, Application number | Application number, Permit cost, Notes (rich text, 0/400) | Application number, Permit cost, Notes (0/400) | same |
| Attachments | Submitted Application, Final Permit | same | same | same | same |

  Required marks per type: Travel = Type, Job, PO. Annual = Type, Asset. FAA = Type, Job, PO.
  Encroachment = Type, Job, PO. Sub Hauler = Type, Vendor, PO.

- **Edges:**
  - **Reached by:** Create Permit modal only.
  - **Does not apply when:** Sub Hauler never shows Job; Annual and Sub Hauler never show Route; only Travel
    shows Travel date(s); only FAA shows Airport / Flight / FAA filing.
  - **When an input is absent:** optional fields are sent as absent/null. A required field left empty shows
    "<Label> is required" and blocks submit. State on FAA/Encroachment/Sub Hauler is UI-only scoping for the
    City picker, as in the shipped form (not persisted).
  - **Trust boundary:** all values are client-supplied; the API re-validates (REQ-04).
  - **Read time:** N/A.
  - **Matrix:** N/A.
  - Field lengths, number formats, lat/long ranges: `NOT SPECIFIED` by any source. ASSUMED — reuse the shipped
    column types (FAA block are free-text strings today) and the shipped form input components; no new limits.
- **Notes for the executor:** Assigned Planner reuses `EmployeeSelect`
  (`apps/web/src/features/employees/components/employee-select.tsx`), already used for the same field in
  `artifact-detail.tsx`; store the employee UUID in `assignedPlannerId`. Agency / City / State / Asset / Job /
  Vendor use the shipped pickers (`PermitAssetAgencyFields`, `CitySelect`, etc.).

### REQ-03 — Create catalog and per-type association `[UNVERIFIED]`

- **Statement:** The create catalog is Travel, Annual Travel, FAA, Encroachment, Sub Hauler (in that order);
  each type's required link (Job, Asset or Vendor) is as REQ-02 shows, and Travel may also carry an Asset
  and Annual Travel may also carry a Job.
- **Surface:** shared, api
- **Sources:**
  - `intent.md` Appendix A (type order, Asset on Travel, Job on Annual) and the Trello card "Annual Travel
    Permit added to the create catalog" — `[UNVERIFIED]` — kind: ticket.
  - `decisions/2026-09-10-permit-create-types-mockup-document-types.md` — `[VERIFIED]` (reference) — kind:
    decision — point 3 "Association stays type-derived (exactly one of assetId / jobId / vendorId)";
    `TRAVEL_ANNUAL_PURPLE_PERMIT` was "read/edit existing rows only — not offered on create". **Superseded
    in part** by the ticket: Annual is now offered on create; Travel/Annual may carry a second link.
  - `decisions/2026-09-11-permit-approval-requires-linked-po.md` — `[VERIFIED]` (reference; Fouzan Shakil) —
    kind: decision — approval requires a PO except `TRAVEL_ANNUAL_PURPLE_PERMIT`.
  - `dispatch/travel-permits-playbook.md` §1 — `[UNVERIFIED]` — kind: vault — "annual" at TCG means the
    Caltrans statewide annual permit held per crane; held at asset level (also `projects-jobs/gaps.md`
    "PO exemption swaps the annual-vs-single axis…" cites "put all the annual permits… at the asset level").
- **Conflict:** the two 2026-09-10 decisions are an in-tree pair (`conflicts_with` on the mockup note vs the
  association-scope note; the mockup note "supersedes" the other). Neither is a verified human adjudication.
  This spec does not choose between them: it follows the mockup note's catalogue and type-derived primary
  link (the newer, and the one the shipped code implements), and the ticket for the two additions. The
  exactly-one rule being relaxed is the ticket's instruction, not the elaborator's choice.
- **Open question:** none. Mapping settled by D1, D3 (§11b). Label wording: Q5, resolved — modal-only labels
  (D8). Whether Annual permits are tracked: Q2, resolved — REQ-08.
- **Accepted by Haris (2026-10-29):** Annual Travel in the shared create catalog, so it appears in the Type
  dropdown of `/permits/create`, the project create page and the asset create page (§11a row 3, §11c).
- **Ripple:** `PERMIT_CREATE_TYPE_VALUES` / `PERMIT_CREATE_TYPE_OPTIONS` also feed `/permits/create`, the
  project create page and the asset create page (§11a rows 3–4) — Annual Travel will appear in their Type
  dropdown too, although those pages are "untouched". `PERMIT_TYPE_ASSOCIATION` / `exclusivePermitAssociation`
  are used by `PermitsService.create` and `permit-form-payload.ts` (§11a rows 5–6).
- **Acceptance:** the modal's Type list is, in order, Travel Permit, Annual Travel Permit, FAA Permit,
  Encroachment Permit, Sub Hauler Permit; Annual Travel stores `TRAVEL_ANNUAL_PURPLE_PERMIT`, Travel stores
  `TRAVEL_CITY_STREET_PERMIT`. The API accepts Travel with job (required) + optional asset, Annual with asset
  (required) + optional job, FAA/Encroachment with job only, Sub Hauler with vendor only, and rejects any
  other combination with a 400 naming the missing/extra link.
- **Edges:**
  - **Reached by:** `POST /api/v1/permits`; also the three untouched create pages (via the shared constant).
  - **Does not apply when:** existing rows are not rewritten; update path keeps its current association rules.
  - **When an input is absent:** missing required link -> 400 (existing messages "Job is required for a
    job-associated permit." etc.).
  - **Trust boundary:** server re-derives the required scope from `type`; ignores a client-sent scope.
  - **Read time:** N/A.
  - **Matrix:** N/A.
  - Travel with Job + Asset: reuse `assertJobAssetSlotFree` and `syncJobAssetAssignment` (already used for
    Travel in the artifact/update flow) so DAS and the pre-checklist see the link. ASSUMED — nearest existing
    behaviour (`permits.service.ts` `syncJobAssetAssignment` doc: "Travel (asset-scoped): unique on (job, asset)").
- **Notes for the executor:** `TRAVEL_ANNUAL_PURPLE_PERMIT` already carries the two behaviours the prototype
  shows for Annual: asset required (`ASSET_REQUIRED_PERMIT_TYPES`) and PO exempt (`PO_EXEMPT_PERMIT_TYPES`).
  See D1.

### REQ-04 — Create API carries every field `[UNVERIFIED]`

- **Statement:** `POST /permits` accepts and stores every field the modal sends, with Valid till optional and
  Valid from, Travel from, Travel to added; a permit created this way starts at the Open trackable status.
- **Surface:** schema, api
- **Sources:**
  - Syed Haris, 2026-10-29 (answer Q4) — `[UNVERIFIED]` — kind: ticket — "a modal-created permit starts at
    Open. Submitted and received dates are stored as typed but never drive the status."
  - Trello card TCG-132 — `[UNVERIFIED]` — kind: ticket — "Add all missing create-API fields … Add Valid
    from (and Travel from/to) … Assigned Planner … plus Due Date … Valid till no longer required."
  - `intent.md` Appendix A — `[UNVERIFIED]` — kind: ticket — the field list per type (REQ-02).
- **Conflict:** none
- **Open question:** none. Q4 resolved: a modal-created permit starts at **Open**; the submitted and received
  dates are stored as typed and never drive the status (Haris, 2026-10-29).
- **Ripple:** `validTill` becoming optional on create reaches every reader of the column (§11a rows 7–9).
  New columns are additive to the permit response (§11a row 10). **The start status moves from Application
  Submitted to Open for every caller of `POST /permits`, including the three untouched create pages** (§11a
  row 15; D11).
- **Acceptance:** a Travel permit created with every Travel field populated returns those values on
  `GET /permits/:permitId`; an Annual permit created with no Valid to succeeds; a payload with `validTill`
  in the past is rejected as today (ASSUMED, below); `validFrom` after `validTill` is rejected with a 400.
  A permit created through the modal has trackable status `OPEN` regardless of the submitted or received
  dates entered, and shows in the Open column of Track Permits (REQ-08). The fields accepted on create are, by type: route (REQ-05), `travelFrom`, `travelTo`, `validFrom`,
  `validTill`, `submittedAt`, `receivedDate`, `applicationNumber`, `serviceFee`, `permitCost`,
  `assignedPlannerId`, `dueDate`, `nearestAirport`, `airportDistance`, `latitude`, `longitude`, `agl`, `msl`,
  `liftWindowStart`, `liftWindowEnd`, `flightPathConfirmed`, `craneLightedAndFlagged`, `notamNumber`,
  `faaSubmissionCase`, `faaResponseTracking`, `notes`, `agencyId`, `city`. All except the new three columns
  and route already exist as columns on `Permit`. The FAA block, planner, due date and application number
  are already fields on `UpdatePermitDto`; `receivedDate` is accepted today only by the approve DTO, and
  `submittedAt` is set by the server in `submitApplication` (no DTO accepts a client-supplied value), so a
  user-entered "Application submitted date" on create is new behaviour (ASSUMED stored as given; the
  server-side stamp at submit is unchanged).
- **Edges:**
  - **Reached by:** `POST /api/v1/permits` only (also called by the three untouched web create pages and any
    API client; they must keep working with their current payloads — they send no new fields and still send
    `validTill`).
  - **Does not apply when:** update (`PATCH`), submit-application and approve endpoints are not changed by
    this ticket except that new columns are readable.
  - **When an input is absent:** every new field is optional at the API (the per-type required marks are
    enforced in the modal; the API enforces only the association links, REQ-03). `validTill` absent -> stored
    null; effective status computed by the existing function (null `validTill` is already handled).
  - **Trust boundary:** all client-supplied; planner and route ids resolved by `(tenant, code|id)` in the
    service, never trusted as UUIDs for another tenant.
  - **Read time:** N/A — stored values.
  - **Matrix:** N/A.
  - ASSUMED — `validTill`, when supplied, keeps `IsNotBeforeToday` (nearest existing behaviour; the card says
    only "no longer required"). ASSUMED — `validFrom <= validTill` when both are supplied, `travelFrom <=
    travelTo` when both are supplied (a range cannot end before it starts). ASSUMED — `validFrom` has no
    effect on the computed status (see D7). Unspecified lengths/ranges: `NOT SPECIFIED`.
- **Notes for the executor:** the DTO is shared by create pages (§11a); keep the create DTO backward
  compatible. Do not add a status field to the create DTO (`permit-status.util.ts` says clients must not set
  `Permit.status`).

### REQ-05 — Route: Origin = yard, Destination = job site `[UNVERIFIED]`

- **Statement:** On a Travel permit, Origin is a yard and Destination is a job site, both chosen in the
  modal and stored on the permit.
- **Surface:** schema, api, web
- **Sources:**
  - Trello card TCG-132 — `[UNVERIFIED]` — kind: ticket — "Origin = the yard, Destination = the job site."
  - Haris 2026-10-29 (Appendix A "Decisions") — `[UNVERIFIED]` — kind: ticket — same, as an explicit decision.
  - `intent.md` Appendix A — `[UNVERIFIED]` — kind: ticket — the prototype shows two fields labelled
    "Origin (Origin address)" and "Destination (Destination address)", Travel only.
- **Conflict:** `dispatch/travel-permits-playbook.md` §1 (`[UNVERIFIED]`, 24.9 KB, `updated: 2026-04-01`
  SOP by Liz Lopez) says the application's **origin is not the yard** for 40–350 t cranes: it is "the closest
  exit off the FWY to destination", the yard being only the Google Maps start. Its Destination matches the
  user's rule ("make sure it matches with jobsite", §receipt checks). This is not a vault-vs-vault conflict
  (the playbook is one voice); it is a vault-vs-decision difference. This spec follows Haris's explicit
  decision and does not merge the two. **Q3 accepted by Haris, 2026-10-29: Origin is the yard, Destination
  is the job site.** The SOP difference is acknowledged, not reconciled.
- **Open question:** none (Q3 resolved).
- **Ripple:** `Permit.routeInformation` (free text, "Route information") is read/written by
  `artifact-detail.tsx`, the field-ticket job-artifacts response and mobile `job-artifacts-section.tsx`
  (§11a row 11). The new origin/destination are **separate** from it and are not shown there unless a source
  says so — `NOT SPECIFIED`.
- **Acceptance:** Origin lists active yards (by name) and Destination lists job sites; picking each saves and
  `GET /permits/:permitId` returns the chosen yard and job site (code + name). When a Job is chosen, whether
  Destination defaults to that job's job site is `NOT SPECIFIED` (see Edges).
- **Edges:**
  - **Reached by:** Create Permit modal -> `POST /permits`.
  - **Does not apply when:** type is not Travel (Annual, FAA, Encroachment, Sub Hauler have no Route).
  - **When an input is absent:** both optional (the prototype shows no `*`).
  - **Trust boundary:** ids resolved by `(tenant, code|id)`; a yard or job site of another tenant is not found.
  - **Read time:** `live` — a yard or job site renamed later shows its new name on the permit. ASSUMED —
    nearest existing behaviour (every other permit link is a live FK). Not a customer-visible document, so
    not a §12 question. Whether a printed permit should freeze the address is `NOT SPECIFIED`.
  - **Matrix:** N/A.
  - Defaulting Destination from the chosen Job's job site: ASSUMED — the picker prefills nothing; the user
    chooses. (The Job already has `jobSiteId`; a default is a client-facing convenience nobody specified.)
- **Notes for the executor:** the prototype's "address" placeholders show a text box; Haris's decision
  makes them pickers. Picker label shows the entity name (and address if the `Address` row is cheap to
  fetch). See D4. Existing `yards` and `customers`/job-site features are the picker sources; check
  `apps/web/src/features/yards/` and the job-site API before writing a new fetcher.

### REQ-06 — Purchase order on create; PO date and Bill to customer `[UNVERIFIED]`

- **Statement:** The modal's Purchase Order field lets the user search POs by number or vendor and attach one,
  or "Create new" inline; it is required for Travel, FAA, Encroachment and Sub Hauler and optional for Annual
  Travel. The inline Create PO matches the prototype and carries **PO date** and **Bill to customer**, which
  become new stored fields on every Purchase Order.
- **Surface:** schema, api, web
- **Sources:**
  - Syed Haris, 2026-10-29 (answer Q1) — `[UNVERIFIED]` — kind: ticket — "match the prototype and add
    columns … PurchaseOrder gets two new nullable or defaulted columns, `po_date` and `bill_to_customer`."
  - Trello card — `[UNVERIFIED]` — kind: ticket — "PO link on create (inline 'Create new' PO)."
  - `intent.md` Appendix A "Inline Create new PO" — `[UNVERIFIED]` — kind: ticket — nested "Create PO" modal:
    PO type\* (Permit), PO number (auto, read-only), PO date\*, Status chip OPEN ("Closes when an invoice is
    attached"), Job (preselected from permit), PO fee\*, Description / purpose, Linked permit\* ("This permit
    (being created)"), Invoice (upload), Notes, toggle "Bill to customer" (on by default); hint "The PO fee
    prefills from the permit's service fee".
  - `decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md` — `[VERIFIED]` (reference) — kind:
    decision — annual: no PO; single: PO.
  - `decisions/2026-09-11-permit-approval-requires-linked-po.md` — `[VERIFIED]` (reference) — kind: decision
    — approval requires a linked PO (not creation). Different from the prototype's "required on create"; both
    hold (create-time in the modal, approval-time in the API).
  - `decisions/2026-09-11-outbound-po-subtypes-and-modal-fields.md` — `[VERIFIED]` (reference; Syed Haris,
    Umer Islam) — kind: decision — locked PO modal set: PO type, PO number, PO items, Agency, Invoice
    attachment; statuses OPEN | CLOSED. **Superseded for the permit-create modal by Haris's Q1 answer**
    ("match the prototype"); still stands for the other PO screens (see Conflict).
  - `decisions/2026-10-08-po-fee-typed-by-user-approval-leaves-po-alone.md` — `[VERIFIED]` (reference; Syed
    Haris, TCG-89) — kind: decision — "PO Fee is typed by the user … Create-time fee default not settled."
    The prototype's prefill from the permit's service fee settles the default; the user can still edit it.
- **Conflict:** resolved by Haris (Q1): the prototype's nested-modal field set wins for the Create Permit
  modal over the 2026-09-11 locked set. This spec records both and does not merge them: the nested modal
  omits Agency and PO items (the PO's agency is inherited from the permit by the existing
  `generatePurchaseOrder`: `dto.agencyId ?? permit.agencyId`); the other PO screens keep Agency and items.
  Vault update: §13a item 5.
- **Open question:** none (Q1 resolved).
- **Already exists in some form?** Checked so nothing is duplicated:
  - **PO date — no.** `PurchaseOrder` has no date column. Nearest: `createdAt` (system timestamp, not
    user-set), `validTill` (an expiry, different meaning), `invoiceNumber` (a number). None is reused.
    Command: `grep -n -i 'poDate\|po_date\|orderDate' apps/api/prisma/schema.prisma` (no match) and
    `grep -rn -i 'poDate' apps/api/src apps/web/src apps/mobile` (no match).
  - **Bill to customer — no.** No billable/bill-to flag on `PurchaseOrder`, `Quotation` or `Job` (grep for
    `billTo|billable|chargeToCustomer|passThrough|rebill` finds only unrelated payroll comments and
    `BillingCode*` models, which classify quote line types). The vault (`vendors-agencies/purchase-order.md`,
    `decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md`, the 2026-09-16 meeting note) has no
    "bill to customer" flag. **What the flag does downstream is `NOT SPECIFIED`** (see §13): this requirement
    stores and shows it; it changes no invoice, quote or customer document.
- **Ripple:** `PurchaseOrder` and every reader of its shape: the PO DTOs, `enrichPurchaseOrders` (spreads scalar
  columns into list and detail responses), PO create/edit/detail pages, `GeneratePoModal` and its callers,
  mobile `purchase-order.contract.ts` (zod `z.object`, additive — unknown keys are stripped), PO activity log
  keys, qa-automation PO page objects. See §11a rows 12, 16–20.
- **Acceptance:**
  1. For Travel/FAA/Encroachment/Sub Hauler, submitting without a PO shows "Purchase order is required"; for
     Annual it submits.
  2. Picking an existing PO, or completing "Create new" and then Create Permit, yields a permit with that PO
     linked (visible on the permit detail and in the PO list). Options read `PO-00521 · City of Long Beach`
     (PO number · counterparty).
  3. The nested Create PO shows exactly: PO type (Permit, fixed), PO number (read-only, server-minted), PO
     date (required), Status chip OPEN with "Closes when an invoice is attached", Job (preselected from the
     permit, none for Sub Hauler or Annual without a job), PO fee (required, prefilled from the permit's
     service fee, editable), Description / purpose, Linked permit ("This permit (being created)"), Invoice
     upload, and a "Bill to customer" toggle on by default. It omits Agency and PO items.
  4. A PO saved from the nested modal stores `poDate` and `billToCustomer`; `GET` of that PO returns both.
  5. The standalone PO create and edit pages and the PO detail page show PO date and Bill to customer (D13);
     a PO that has neither stored reads "Not set", and opening and saving a legacy PO on the edit page
     without touching them does not write either field.
  6. If the PO step fails after the permit was created, the user sees an error naming the new permit code and
     that it has no PO; the permit stays (D5).
- **Edges:**
  - **Reached by:** Create Permit modal; `POST /purchase-orders`, `PATCH /purchase-orders/:id`, `POST /permits/:id/generate-po`
    (all gain the two optional fields); existing PO flows otherwise unchanged.
  - **Does not apply when:** Annual Travel (PO optional). PO type forced to Permit. PO date is required **only**
    in the Create Permit modal's variant (D13); everywhere else it is optional.
  - **When an input is absent:** API: `poDate` absent -> stored null; `billToCustomer` absent -> stored null
    (D12). Create new with PO fee empty -> blocked "PO fee is required" (prototype `\*`).
  - **Trust boundary:** the server validates PO existence, tenant, not archived and "permit has at most one
    PO" via the existing attach/generate methods; the PO number is minted server-side; `poDate` and
    `billToCustomer` are client values stored as sent.
  - **Read time:** `live` — stored on the PO, shown from the row. N/A for catalogue data.
  - **Matrix:** N/A.
  - ASSUMED — the modal prefills PO date with today (tenant timezone, per
    `decisions/2026-09-09-business-timezone-is-a-tenant-property.md`), editable; the prototype shows the
    field as required but not its initial value.
  - ASSUMED — the prototype's **Notes** ("Internal notes…") has no `PurchaseOrder` column, and Haris named
    only two new columns, so the nested modal does not render Notes. This is a deliberate departure from
    "match the prototype", surfaced in §13 for Haris to reverse in one line. Description / purpose maps to
    the existing `description`.
- **Notes for the executor:** reuse `PurchaseOrderSelect`, `GeneratePoModal` / `PoFormCard` and their
  validation options (`PoFormValidationOptions`, like `jobLocked`), `permitTypeRequiresPurchaseOrder`. Add a
  `variant`/options switch for the Create Permit use so Agency, PO items and PO-date-required differ only
  there. The PO is linked after the permit exists (D5). Add the new keys to `PO_TRACKED_KEYS`.

### REQ-07 — Attachments on create `[UNVERIFIED]`

- **Statement:** The modal offers two attachment cards, "Submitted Application" and "Final Permit", each with
  "Upload file" and "Set an expiry as you add it", saved with the permit.
- **Surface:** web
- **Sources:**
  - `intent.md` Appendix A — `[UNVERIFIED]` — kind: ticket — two cards, 0 files each, upload + expiry.
- **Conflict:** none. (Shipped permit form has three categories — Application, Final Permit, Receipt; the
  prototype shows two. `Differs from` the shipped form because the prototype is the approved spec.)
- **Open question:** none. Max files per card: `NOT SPECIFIED` (open vault question
  `projects-jobs/gaps.md` "How many files may a permit application, an approved permit, or an approved plan
  carry?" — not asked again).
- **Ripple:** `PermitCategoryAttachments` / `PERMIT_ATTACHMENT_CATEGORY_CONFIG` stay as is for the old forms;
  the modal passes its own two-category config. Uploaded files are filed under the category names the artifact
  flow already uses ("Submitted Application" via `SUBMITTED_APPLICATION_CATEGORIES`, "Final Permit"); the
  submit/approve gates count those names.
- **Acceptance:** files added before Create Permit are uploaded after the permit exists and appear under the
  right card on the permit detail; an expiry set on a file is stored as the attachment's `expiresAt`.
- **Edges:**
  - **Reached by:** Create Permit modal.
  - **Does not apply when:** none by type (all five show both cards).
  - **When an input is absent:** zero files is valid.
  - **Trust boundary:** upload goes through the shared attachments service; server-side limits as shipped.
  - **Read time:** N/A.
  - **Matrix:** N/A.
  - If the upload step fails after the permit exists: same handling as REQ-06 (permit kept, user told).
    ASSUMED — nearest existing behaviour of the shipped create pages.
- **Notes for the executor:** reuse `CategorizedAttachmentsSection` / `PendingAttachmentsSection` and the
  `expiresAt` support in `apps/web/src/features/attachments/`.

### REQ-08 — Track Permits lists every permit; status actions for asset- and vendor-linked permits `[UNVERIFIED]`

- **Statement:** Track Permits (the kanban and its All Permits tab) lists every non-archived permit
  regardless of whether it has a job, and the status actions — Mark Application Submitted, Upload Approved
  Permit / approve, Cancel — work on asset-linked and vendor-linked permits as they do on job-linked ones.
- **Surface:** api, web
- **Sources:**
  - Syed Haris, 2026-10-29 (answer Q2) — `[UNVERIFIED]` — kind: ticket — "show all permits on Track Permits.
    Drop the `jobId: { not: null }` filter in `findAllForTracker`, and make the status actions work for
    asset-linked and vendor-linked permits. Supersede 2026-09-11-track-permits-job-only-until-sept-15.md
    for this."
  - `decisions/2026-09-11-track-permits-job-only-until-sept-15.md` — `[VERIFIED]` (reference; Fouzan Shakil)
    — kind: decision — the job-only tracker and "no status actions" for asset-/vendor-linked permits, a known
    accepted gap deferred "until the post-15-Sep general-class work". **Superseded by Haris's answer.**
  - `decisions/2026-09-11-permit-classes-job-only-until-sept-15.md` — `[VERIFIED]` (reference) — kind: decision
    — point 4 defers general-class handling; superseded for this by the same decision.
  - `projects-jobs/city-permits/permit-tracker-workbook.md` — `[UNVERIFIED]` — kind: vault — TCG tracks its
    annual and blanket permits per crane today in a workbook; this change brings them into the ERP tracker.
- **Conflict:** none. The accepted-gap note is superseded, not contradicted.
- **Open question:** none (Q2 resolved).
- **Ripple:** `PermitsRepository.findAllForTracker` (the only place the job filter lives) feeds the Track
  Permits kanban and its All Permits tab. Reaches the tracker response (`PermitTrackerResponse`), the web
  mappers and cards, the PO picker scoped by job, and the status endpoints (§11a rows 13, 18–19). The
  tracker's search and sort include job columns; they keep working with null jobs.
- **Acceptance:**
  1. An Annual Travel permit (asset only) and a Sub Hauler permit (vendor only) created from the modal appear
     on Track Permits in the Open column, and on its All Permits tab; existing asset- and vendor-linked
     permits appear too.
  2. For such permits the card identifies the permit without a job: it shows the asset unit code for
     asset-linked and the vendor name for vendor-linked permits (the response gains the vendor label; D14).
  3. Mark Application Submitted, Upload Approved Permit / approve, and Cancel succeed on an asset-linked and
     on a vendor-linked permit, with the existing gates: submit requires the application upload; approving
     requires a linked PO unless the type is `TRAVEL_ANNUAL_PURPLE_PERMIT`, and cost or Final Permit document.
  4. Attaching or creating a PO for a job-less permit works and the PO picker offers only POs the API will
     accept (see Edges). The Plans tracker is unaffected.
- **Edges:**
  - **Reached by:** `GET /permits/tracker`; `PATCH /permits/:id/trackable-status`; `POST
    /permits/:id/submit-application`; `POST /permits/:id/approve`; `POST /permits/:id/generate-po`; `PATCH
    /permits/:id/purchase-order`.
  - **Does not apply when:** Plans (a separate tracker, job-scoped; unchanged); archived permits (still
    excluded: `archivedAt: null`).
  - **When an input is absent:** a permit with no job and no project: `jobId`/`jobCode` null in the response
    and the card hides the job line (already conditional). PO scope: `assertPoShareableWithPermit` matches on
    job when both have one, otherwise on project; with neither, scope is `NOT SPECIFIED` — see Notes.
  - **Trust boundary:** server-derived; tenant scoped.
  - **Read time:** `live`.
  - **Matrix:** N/A.
  - ASSUMED — the card shows asset unit code or vendor name in the place of the job line (otherwise cards for
    these permits carry no identifier but the permit code and type). Nearest existing behaviour: the card
    already shows the job code when present.
- **Notes for the executor:** the status endpoints in `PermitsService` (`updateTrackableStatus`,
  `submitApplication`, `approvePermit`) contain no job requirement (read 2026-10-29); the work is the
  repository filter, the response (vendor label), the card, and the job-scoped PO picker
  (`artifact-tracker.mappers.ts` comment: without a job the picker "falls back to the whole project"). For a
  permit with neither job nor project the picker must not offer POs the API will refuse — verify
  `purchase-order-permit-share.util.ts` for the no-job, no-project case and decide the picker scope there
  (`PurchaseOrderSelect`); record it as an AI decision. The tracker's type-filter for Sub Hauler: check it
  does not depend on the job (the 2026-09-11 note flagged it).

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** yes
- **Migration required:** yes — `pnpm db:migrate`, committed under `apps/api/prisma/migrations/`
  (`.ai/claude/contexts/prisma.md` → Migrations). Latest migration at elaboration:
  `20261028120000_add_base_rate_override_calc_trigger`.
- **Data backfill required:** no (all new columns nullable; existing rows read null). Stated by the elaborator.
  Deliberately **no** default of `true` on `bill_to_customer`: it would assert a billing fact on every
  existing PO (D12).
- **Second schema change (from Q1): `PurchaseOrder` gains `po_date` and `bill_to_customer`** — see below.
  Needs `tcg-prisma-guardian` (migration review) and `tcg-contract-tracer` (PO response / DTO shape).
  Two migrations or one is the executor's call; both are additive.
- **Existing models considered:**
  - `Permit.routeInformation` (Text) — holds the "authorized route" text; rejected for Origin/Destination
    because it has no structure and is the field the artifact flow and mobile already use for something else.
  - `Job.yard` (VarChar, a name, not an FK) and `Job.jobSiteId` — the job already knows its yard name and job
    site, but a permit can be created for a different origin and `Job.yard` is not a key; used only as a
    possible picker default (not specified).
  - `JobAssetPermitAssignment` — the existing job/asset/permit link table; unrelated to route; unchanged.
  - A new `PermitRoute` table — rejected: one-to-one, no history, no independent lifecycle -> columns
    (`.ai/claude/contexts/patterns.md`, `prisma.md` Conventions).
  - Valid-from/travel dates: no existing columns (`validTill` only; `submittedAt`, `receivedDate`,
    `dueDate`, `expectedReturnDate` exist and are reused for their own meanings).

```prisma
// Additions to model Permit (all nullable; no new model, no new code field)
validFrom           DateTime? @map("valid_from") @db.Timestamptz()   // pairs with validTill
travelFrom          DateTime? @map("travel_from") @db.Date
travelTo            DateTime? @map("travel_to") @db.Date
originYardId        String?   @map("origin_yard_id") @db.Uuid
destinationJobSiteId String?  @map("destination_job_site_id") @db.Uuid

originYard          Yard?     @relation(fields: [originYardId], references: [id], onDelete: SetNull)
destinationJobSite  JobSite?  @relation(fields: [destinationJobSiteId], references: [id], onDelete: SetNull)
// plus back-relations on Yard and JobSite and @@index on both FK columns
```

```prisma
// Additions to model PurchaseOrder (both nullable; no new model, no new code field)
poDate         DateTime? @map("po_date") @db.Date
billToCustomer Boolean?  @map("bill_to_customer")   // null = not recorded (every existing row)
```

`PurchaseOrder` is already a tenant-scoped model (`uq_purchase_orders_tenant_po_id`), so there is no
`TENANT_SCOPED_MODELS` change. `po_date` is `@db.Date` like `dueDate` / `receivedDate`: a calendar day, no
time of day (D12).

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| `Permit` (unchanged) | `permitId` | existing `PERMIT_SEQUENCE_PREFIX` | `entity_sequences` | n/a — no new code |

- **New prefix introduced:** no
- **Child relations:** FKs reference the parent UUID `id`. `onDelete: SetNull` for both new FKs — D4 (matches
  `jobId`/`vendorId` on `Permit`). Yards are archived, not deleted (`archivedAt`), so the live case is moot.
- **Fields whose type/precision no source states:** `po_date` and `bill_to_customer` types (D12); `validFrom` type (chosen to mirror `validTill`, D4);
  `travelFrom/To` type (Date, D4); string lengths for FAA fields (existing columns, unchanged).
- **Tenancy:** `Permit` is already a tenant-scoped model; adding columns needs no change to
  `TENANT_SCOPED_MODELS` (G3 not triggered — no new tenant model). The `tcg-prisma-guardian` check on the
  migration is still the executor's step.

## 4. API surface — `apps/api`

- **Pattern:** P1 (business-entity CRUD, coded, archivable) — `patterns.md` → P1 (extending the existing
  `permits` feature, not adding one).
- **Existing functions/services to reuse:** `PermitsService.create`, `assertAssociationMatchesType`,
  `exclusivePermitAssociation` (`packages/shared/src/constants/permit-association.ts`), `resolveEmployeeId`,
  `resolveJobUuid`, `resolveAssetId`, `resolveVendorId` (`permits.service.ts`), `assertJobAssetSlotFree`,
  `syncJobAssetAssignment`, `generatePurchaseOrder`, `attachPurchaseOrder`, `SequenceRepository.getNextValue`,
  `PermitActivityLogger.logCreation`, `toPrismaDate`. For yard/job-site lookups: the `yards` and job-site
  repositories (find by code or id within tenant).
- **New exported functions/services proposed:** none beyond two small private resolvers in
  `PermitsService` (`resolveYardId`, `resolveJobSiteId`, mirroring `resolveVendorId`) — D4. One new shared
  helper for "optional secondary links per type" — D3.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/api/v1/permits` | `permits.controller.ts` | `permits.service.ts` `create` | `permits.repository.ts` | REQ-03, 04, 05 |
| `GET` | `/api/v1/permits/:permitId` | existing | `findOne` | existing | REQ-04, 05 (returns new columns + yard / job-site labels) |
| `POST` | `/api/v1/permits/:id/generate-po` | existing | `generatePurchaseOrder` | existing | REQ-06 (no change) |
| `PATCH` | `/api/v1/permits/:id/purchase-order` | existing | `attachPurchaseOrder` | existing | REQ-06 (no change) |
| `POST` / `PATCH` | `/api/v1/purchase-orders`, `/api/v1/purchase-orders/:poId` (existing PO routes) | `purchase-orders` controller | `purchase-orders.service.ts` | `purchase-orders.repository.ts` | REQ-06 (two optional fields) |
| `GET` | `/api/v1/purchase-orders`, `/api/v1/purchase-orders/:poId` | existing | `findAll` / `findOne` via `enrichPurchaseOrders` | existing | REQ-06 (response gains `poDate`, `billToCustomer`) |
| `GET` | `/api/v1/permits/tracker` | `permits.controller.ts` | `findAllForTracker` | `permits.repository.ts` `findAllForTracker` | REQ-08 (job filter dropped; vendor label added) |

- **Request DTO:** `create-permit.dto.ts` — add optional: `validFrom` (`IsDateString`), `travelFrom`,
  `travelTo` (`IsDateString`), `submittedAt` (`IsDateString`), `receivedDate` (`IsDateString`),
  `applicationNumber` (`IsString`, `MaxLength(100)` — same as the update DTO), `assignedPlannerId` (`IsString`
  — id or employee code, resolved like the other links), `dueDate` (`IsDateString`), `originYardId`,
  `destinationJobSiteId` (`IsString`, id or code), the FAA fields exactly as in `update-permit.dto.ts`
  (strings, dates, booleans), and relax `validTill` to `@IsOptional() @IsDateString() @IsNotBeforeToday()`.
  Lengths beyond those already in the update DTO: `NOT SPECIFIED`.
- **PO DTOs (REQ-06):** `create-purchase-order.dto.ts` and `update-purchase-order.dto.ts` gain
  `poDate?` (`@IsOptional() @IsDateString()`) and `billToCustomer?` (`@IsOptional() @IsBoolean()`);
  `GeneratePoDto` inherits both (it is `OmitType(CreatePurchaseOrderDto, …)`). Add both to `PO_TRACKED_KEYS`.
  Responses need no mapper change if `enrichPurchaseOrders` keeps spreading scalar columns (it does today;
  executor confirms). Absent -> stored null.
- **Tracker (REQ-08):** `findAllForTracker` drops `jobId: { not: null }`; `PermitTrackerResponse` gains a
  vendor label (vendor name) next to `assetUnitCode`; the `select` adds the vendor relation.
- **Create status (REQ-04):** `PermitsService.create` sets `trackableStatus: 'OPEN'` (was
  `APPLICATION_SUBMITTED`) and computes `status` from it; the duplicate-asset check passes `OPEN` (both
  resolve to `PENDING`, so its result is unchanged).
- **Response shape:** the permit record plus the new columns; resolved labels for yard and job site as for
  other links (`findOne` shape). Additive only — `tcg-contract-tracer` run in the unit that changes it (G5).
- **Guards / roles:** unchanged (`AccessTokenGuard` global). Roles that may create: `NOT SPECIFIED` (see §8).
- **Route param identity:** unchanged — business code on the boundary; `(tenant, code) -> id` once.
- **Errors:** 400 for association violations (existing messages), for `validFrom > validTill`, `travelFrom >
  travelTo`; 404 for an unresolved yard, job site, planner (as the sibling resolvers). Exact copy for new
  messages: `NOT SPECIFIED` — executor follows the sibling resolvers' wording.
- **Pagination:** N/A — no list endpoint added.
- **Module registration:** no new module. If the yard/job-site repositories are not already provided in
  `permits.module.ts`, add the provider there (DI check for the executor).

## 5. Web surface — `apps/web`

- **Routes:** no new route. `/permits/all-permits` gains the modal. `/permits/create`,
  `/projects/[id]/permits/create`, `/asset-management/assets/[id]/permits/create` untouched.
- **Existing components to reuse:** `PageHero` (button), `PermitsListing` / `PermitListingActions`
  (`showCreateButton`), `Dialog` / `SCROLLABLE_DIALOG_CONTENT`, `Field`/`FeatureFieldLabel`,
  `FeatureFormSection`, `RichTextArea`, `EmployeeSelect`, `PermitAssetAgencyFields`, `CitySelect`,
  `PurchaseOrderSelect`, `GeneratePoModal` / `PoFormCard`, `CategorizedAttachmentsSection`,
  `PendingAttachmentsSection`, `validatePermit*` helpers (`permit-form-validation.ts`), `useCreatePermit`
  (`use-permits.ts`).
- **New components proposed:** a `CreatePermitModal` in `src/features/permits/components/` (the modal shell
  and per-type section composition). Nothing in `components/` fits as a multi-section type-driven modal;
  the shipped `PermitForm` is a page form with a page-action bar and is not reusable as-is (D2).
- **PO screens (REQ-06):** `po-form-fields.tsx`, `po-form.tsx`, `po-edit-form-card.tsx`,
  `po-detail-view.tsx`, `map-po-form-state.ts`, `po-form-payload.ts`, `po-form.types.ts` gain PO date and
  Bill to customer; standalone PO create/edit pages show them (D13); edit sends them only when changed.
  `GeneratePoModal` gets a Create-Permit variant (no Agency, no PO items, PO date required, PO fee prefilled
  from the permit's service fee). The PO list table gets **no** new column.
- **Track Permits (REQ-08):** card shows asset unit code / vendor name when there is no job; the type filter
  and search keep working with null jobs.
- **Table:** unchanged. `permit-table-columns.tsx` keeps its columns (see §11a row 9).
- **Forms:** react-hook-form + Zod v4 or the shipped imperative validators — follow
  `.ai/claude/contexts/web.md` → Forms: no top-of-form summary; focus the first invalid input; clear an error
  the moment the input becomes valid. The prototype's "first missing dropdown opens" is consistent.
- **Server state:** TanStack Query; on success invalidate the permits list and stats keys used by
  `use-permits.ts` / `use-permits-stats.ts`, `purchase-orders`, and the attachments for the new permit.
- **Colors / spacing:** theme variables only.
- **Responsive:** `NOT SPECIFIED` by the prototype beyond desktop; use the shipped dialog behaviour.
- **Copy:** exact strings from `intent.md` Appendix A. Other copy: `NOT SPECIFIED` — reuse the shipped
  messages (`Type is required`, `Asset is required`, `Job is required`).
- **Test IDs:** new `data-testid`s follow `<module>-<flow>-<element>` (`web.md` → Test IDs); none renamed.
  No new tests (`CLAUDE.md`). One exception to "existing specs are not edited": U1 changes the three start-status expectations named in §11a row 15 from `APPLICATION_SUBMITTED` to `OPEN` (Q6).

## 6. Mobile surface — `apps/mobile`

N/A — no mobile create flow is asked for. Mobile reads permits through `permit.contract.ts` and
`job-artifacts.contract.ts` and POs through `purchase-order.contract.ts` (zod `z.object`, unknown keys
stripped); new columns are additive and the contracts do not need to change. Offline /
sync: `NOT SPECIFIED` (not touched).

## 7. Shared package — `packages/shared`

- `PERMIT_CREATE_TYPE_VALUES` gains `TRAVEL_ANNUAL_PURPLE_PERMIT`, reordered to Travel, Annual, FAA,
  Encroachment, Sub Hauler (D1). Consumed by web (and indirectly mobile builds) — rebuild `dist/` per
  `CLAUDE.md`.
- A helper for the optional secondary link per type (Travel may carry an asset; Annual may carry a job) next
  to `PERMIT_TYPE_ASSOCIATION` (D3).
- `PERMIT_TYPE_LABELS` changes are **not** made here (Q5 resolved: modal-only labels, D8).

## 8. Permissions and tenancy

- **Roles permitted / denied:** `NOT SPECIFIED` — the ticket names none; the shipped create endpoint's
  access is unchanged. (Elaborator note: if the shipped endpoint is un-roled beyond the global guard, the new
  button is visible to every signed-in user; confirm at sign-off.)
- **Tenant isolation:** standard middleware; each new FK (yard, job site, planner) resolved inside the tenant.
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| Type | required, one of the five create values | `intent.md` App. A | `[UNVERIFIED]` |
| Per-type required fields | as REQ-02 table (modal); API enforces only the association link | `intent.md` App. A | `[UNVERIFIED]` |
| Valid till (Valid to) | optional; if present not before today | ticket + ASSUMED | `[UNVERIFIED]` |
| Valid from <= Valid till; Travel from <= Travel to | when both present | ASSUMED — a range cannot end before it starts | — |
| Notes | rich text, 400 visible characters | `intent.md` App. A "0/400"; API already `PERMIT_NOTES_CHAR_LIMIT` | `[UNVERIFIED]` |
| PO fee (nested PO) | required | `intent.md` App. A | `[UNVERIFIED]` |
| PO date (nested PO in Create Permit modal) | required there; optional at the API and on other PO screens | `intent.md` App. A + D13 | `[UNVERIFIED]` |
| Bill to customer | boolean, on by default in the UI; null when never set | Haris Q1 + `intent.md` App. A | `[UNVERIFIED]` |
| Lat/long/AGL/MSL ranges, application number format | `NOT SPECIFIED` — no source states a limit | — | — |

## 10. Tests

`not requested` ("No new tests" on the ticket; `CLAUDE.md`). The executor runs the existing suites only
(`pnpm test`, `pnpm lint`, `pnpm typecheck`, `pnpm build`). Requirements without a testable acceptance line:
REQ-08.

## 11. Non-functional

- **Performance:** `NOT SPECIFIED`. Pickers follow `web.md` → Dropdowns (server list, debounced; never
  preloaded).
- **Concurrency:** permit code minted from `entity_sequences` as today; two simultaneous Annual creates for
  the same asset/type/city are guarded by `assertNoActiveDuplicatePermit` (unchanged).
- **Audit / activity log:** `permitActivityLogger.logCreation` already snapshots `PERMIT_TRACKED_KEYS`; whether
  to add the new columns to that list is ASSUMED — yes for `validFrom`, `travelFrom`, `travelTo`, `originYard`,
  `destinationJobSite`, so the creation log is complete (nearest existing behaviour: every tracked field is
  listed). The PO attach is already logged by `attachPurchaseOrder` ("Attached purchase order").
- **Migration / rollout order:** schema + migrations (`Permit`, `PurchaseOrder`) -> shared -> API -> web.
  Both migrations are additive and non-destructive (no G2). The start-status change (REQ-04) and the tracker
  filter (REQ-08) take effect on deploy of the API, before the web ships; the Open permits created in between
  are valid.

## 11a. Ripple — already-shipped behaviour these requirements reach

| # | Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `apps/web/src/app/(protected)/permits/all-permits/page.tsx` | `showCreateButton={false}` + header comment citing the hide-create decision | REQ-01 | changes deliberately (button on, comment updated) | Haris 2026-10-29 | `grep -rn showCreateButton apps/web/src/features apps/web/src/app` |
| 2 | `PermitsListing` consumers: asset detail Permits tab (`showCreateButton={false}`), Track Permits | `showCreateButton` prop | REQ-01 | unchanged | ticket ("modal on All Permits") | same grep |
| 3 | `/permits/create`, project and asset create pages | `PermitForm`, `buildPermitTypeOptions`, `PERMIT_CREATE_TYPE_OPTIONS` | REQ-02, 03 | page code unchanged; **Type dropdown gains Annual Travel** | **Accepted by Haris, 2026-10-29** | `grep -rln "PERMIT_CREATE_TYPE_OPTIONS\|PERMIT_CREATE_TYPE_VALUES" apps packages/shared/src` -> `permit-type-options.ts`, `permit-form-fields.tsx`, `permit-types.ts` |
| 4 | Those pages' validators and payload builder (`associationForPermitType`, `exclusivePermitAssociation`) | shared association helpers | REQ-03 | unchanged for existing types; Annual (ASSET) already handled | ASSUMED — nearest existing behaviour; helpers already map the type | `grep -rn "associationForPermitType\|exclusivePermitAssociation" apps/web/src` |
| 5 | `PermitsService.create` | `assertAssociationMatchesType` + `exclusivePermitAssociation` | REQ-03 | changes deliberately (secondary link allowed for Travel/Annual) | ticket / Appendix A | `grep -rn "assertAssociationMatchesType\|exclusivePermitAssociation" apps/api/src` -> `permits.service.ts` only |
| 6 | `PermitsService.update` | association is not asserted on update (grep shows no call) | REQ-03 | unchanged | n/a | same grep |
| 7 | Expiry sweep `permit-expiry.service.ts` and `computePermitEffectiveStatus` | `validTill` null | REQ-04 | unchanged — null `validTill` is already read as "never expires" (quotation-minted rows have none) | code, descriptive | `grep -rln validTill apps/api/src/usecase/permits` |
| 8 | `assertNoActiveDuplicatePermit` (asset, type, city) | asset-linked create | REQ-03, 04 | unchanged; applies to Travel when an asset is chosen and to Annual. An Annual permit with no Valid to is "never expired", so a second one for the same asset/type/city is refused | code, descriptive; product intent `NOT SPECIFIED` | `sed -n 128,150p apps/api/src/usecase/permits/permits.service.ts` |
| 9 | All Permits table and print model: `permit-table-columns.tsx`, `permit-print-model.ts`, `permit-print-sections.tsx`, `permit-detail-view.tsx`, `asset-permit-detail-content.tsx` | `validTill` column / field | REQ-04 | a modal-created permit with no Valid to renders the existing empty-value dash; new fields are **not** added to table, detail or print — `NOT SPECIFIED` (card asks for create only) | ticket scope | `grep -rln validTill apps/web/src \| grep -i permit` |
| 10 | Mobile `permit.contract.ts`, `job-artifacts.contract.ts`, field-tickets job-artifacts response | permit response shape | REQ-04 | unchanged — additive columns only | ASSUMED — additive; `tcg-contract-tracer` confirms | `grep -rln validTill apps/mobile`; `grep -rln routeInformation apps/api/src apps/mobile` |
| 11 | `routeInformation` readers/writers: `artifact-detail.tsx`, `field-tickets.service.ts`, mobile `job-artifacts-section.tsx` | free-text route | REQ-05 | unchanged — Origin/Destination are new, separate columns | D4 | `grep -rln routeInformation apps/web/src apps/api/src apps/mobile` |
| 12 | `PurchaseOrder` model, PO DTOs, `enrichPurchaseOrders`, PO list/detail responses | two new nullable columns | REQ-06 | changes deliberately (additive; null on every existing row) | Haris answer Q1 | `grep -n "poDate\|billToCustomer" apps/api/prisma/schema.prisma` (no match today) |
| 13 | `PermitsRepository.findAllForTracker` -> Track Permits kanban + its All Permits tab | `jobId: { not: null }` | REQ-08 | changes deliberately (filter dropped; all permits listed) | Haris answer Q2 (supersedes `decisions/2026-09-11-track-permits-job-only-until-sept-15.md`) | `sed -n 62,90p apps/api/src/service/permits/permits.repository.ts` |
| 14 | UI labels for permit types in list, filters, tracker, print, DAS pre-checklist (`formatPermitType`, `PERMIT_TYPE_LABELS`, `build-pre-checklist-items.ts`, `build-all-permits-rows.ts`) | type label | REQ-02, 03 | unchanged — the modal uses its own label map | **Haris answer Q5 (accepted)** | `grep -rn "PERMIT_TYPE_LABELS\|formatPermitType" apps packages/shared/src` |
| 15 | Start status of permits created by `POST /permits`: the three untouched create pages and any API caller; `qa-automation` specs that create permits | `PermitsService.create` sets `APPLICATION_SUBMITTED` | REQ-04 | changes deliberately — **starts at Open for every caller** (D11, **confirmed by Haris, Q6**) | Haris answer Q4 says "a modal-created permit"; extending it to the old pages is the elaborator's reading of "siblings get the same change" (`CLAUDE.md`) — D11 | `grep -rn "APPLICATION_SUBMITTED" apps/api/src/usecase/permits/permits.service.ts`; `grep -rln -i "permit" qa-automation/e2e` `qa-automation/e2e/specs/permits/create.spec.ts:97` and `status.spec.ts:20, 61` assert `APPLICATION_SUBMITTED` after create; U1 updates all three to `OPEN` (Q6, Haris 2026-10-29) |
| 16 | PO create / edit / detail pages: `po-form-fields.tsx`, `po-form.tsx`, `po-edit-form-card.tsx`, `po-detail-view.tsx`, `map-po-form-state.ts`, `po-form-payload.ts` | `PoFormState`, `buildPoPayload` | REQ-06 | changes deliberately — show PO date and Bill to customer (D13) | Haris answer Q1 ("whether the existing PO create and edit pages show them" delegated to the elaborator) — D13 | `ls apps/web/src/features/purchase-orders/components`; `grep -rn "poFee" apps/web/src/features/purchase-orders` |
| 17 | `GeneratePoModal` callers: `ArtifactPoWidget`, permit detail | `PoFormCard` | REQ-06 | the modal gains the two optional fields; Agency and items stay there; Create-Permit variant differs only where opened from the new modal | D13 | `grep -rn "GeneratePoModal" apps/web/src` |
| 18 | Tracker response + web mappers + `ArtifactCard` | `PermitTrackerResponse`, `artifact-tracker.mappers.ts` | REQ-08 | changes deliberately — vendor label added; job line stays conditional | D14 | `grep -rn "PermitTrackerResponse" apps` |
| 19 | PO picker scope for job-less permits | `PurchaseOrderSelect`, `purchase-order-permit-share.util.ts` | REQ-08 | scope for a permit with no job and no project is **decided by the executor and recorded** (see REQ-08 Notes) — not specified by any source | D14 | `sed -n 1,30p apps/api/src/usecase/permits/purchase-order-permit-share.util.ts` |
| 20 | Mobile `purchase-order.contract.ts` + mock; qa-automation PO page objects/fixtures | PO response shape / `data-testid` | REQ-06 | unchanged — additive; no `data-testid` renamed | ASSUMED — additive; `tcg-contract-tracer` confirms | `grep -rln "purchase-order" apps/mobile/data qa-automation/e2e/specs/purchase-orders` |

- **Surfaces with no existing behaviour in this area:** the modal itself (no `CreatePermitModal` exists —
  `find apps/web/src/features/permits -name '*create*'` returns only page forms); the new columns.
- **Consumers with no source for what happens to them:** none open. Rows 15 and 19 rest on recorded AI
  decisions (D11, D14), not on a product source; both are flagged for the §11b review.

## 11b. AI decisions — reviewed by a developer

| ID | Decision | Chosen | Why / alternatives (with existing code found) | Needs developer | Reviewed by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | Which value Annual Travel stores | existing `TRAVEL_ANNUAL_PURPLE_PERMIT`; add it to `PERMIT_CREATE_TYPE_VALUES` | The prototype's Annual behaviour (asset required, PO optional) is exactly what `ASSET_REQUIRED_PERMIT_TYPES` and `PO_EXEMPT_PERMIT_TYPES` already encode for this value, and `2026-09-11-permit-approval-requires-linked-po.md` exempts exactly this value. A new enum value would need new entries in the exemption lists, the association map, the label map, the tracker search and the legacy remap (`20260910180000`). Alternative: new `TRAVEL_ANNUAL` value — rejected: duplicates a type, splits existing annual rows in two. The wording "Purple Permit" vs "Annual Travel" was Q5, resolved: modal-only labels (D8). | no | | |
| D2 | Modal vs reuse of `PermitForm` | new `CreatePermitModal`, composing the shipped field components; `PermitForm` untouched | `PermitForm` is a page form (action bar, three untouched create pages depend on it); changing it risks the pages the ticket says stay untouched. Alternative: put a modal wrapper around `PermitForm` — rejected: it renders one layout for all types, the prototype has five. | no | | |
| D3 | How Travel/Annual carry two links | keep `PERMIT_TYPE_ASSOCIATION` as the **required** link; add a shared "optional secondary link per type" map (Travel -> asset, Annual -> job); the API checks the required link is present and any extra link is only an allowed secondary one | The prototype contradicts the exclusive rule in `permit-association.ts` (`exclusivePermitAssociation`), but the artifact flow already holds Travel with job + asset (`syncJobAssetAssignment`). Alternative: drop the exclusive rule entirely — rejected: FAA/Encroachment/Sub Hauler rows would then accept stray links the prototype does not show. | no | | |
| D4 | Where Origin / Destination live | two nullable FK columns on `Permit`: `originYardId -> Yard`, `destinationJobSiteId -> JobSite`, `onDelete: SetNull`; plus `validFrom` (Timestamptz, like `validTill`), `travelFrom`/`travelTo` (`@db.Date`, like `dueDate`/`receivedDate`); routeInformation untouched | Haris: "Origin = the yard, Destination = the job site". `Yard` and `JobSite` are existing models with UUID PKs and address rows (`Address.yardId`, `Address.jobSiteId`), so FKs keep one source of truth. Alternative: write both into `routeInformation` text — rejected: unstructured, collides with its current meaning, loses the link to the yard/job-site records. Alternative: free-text origin/destination address columns (as the prototype's "address" placeholders) — rejected: contradicts Haris's decision. | no | | |
| D5 | PO-on-create sequencing | the modal calls `POST /permits` first, then `PATCH /permits/:id/purchase-order` (existing PO) or `POST /permits/:id/generate-po` (new PO), then uploads attachments; no PO fields added to the create DTO | Both existing endpoints take a permit id, and the nested modal says "Linked permit: This permit (being created)". Creating the PO first would leave an orphan OPEN PO when the permit fails; one atomic request would need a new transactional path that `PermitsService.create` does not have (it already runs several non-transactional writes). Failure mode is the same state a legacy permit is already in (a permit without a PO — approval requires one, and `ArtifactPoWidget` can attach one later). Alternative: add `purchaseOrderId` / `newPurchaseOrder` to the create DTO — rejected for the reason above; this is the most contestable row, change freely. | no | | |
| D6 | Where "PO required" is enforced | modal only, plus the existing API rule at approval; the create DTO keeps PO optional | The shared create DTO serves three untouched pages that send no PO; requiring it at the API would break them. `2026-09-11-permit-approval-requires-linked-po.md` already enforces the rule at approval. | no | | |
| D7 | Effect of Valid from | stored and shown; no effect on the computed status | `computePermitEffectiveStatus` reads only `validTill` + trackable status; the only mention of "not yet active" is the unverified `permit-tracker-workbook.md` (Excel formula). Not specified for the ERP -> not invented. | no | | |
| D8 | Label scope | modal uses the prototype labels from a **modal-local** label map; `PERMIT_TYPE_LABELS` unchanged | Changing the shared map reaches ~15 render sites (§11a row 14). Alternative: rename globally. **Accepted by Haris (Q5), 2026-10-29.** **Amended 2026-10-30 (Q13, Haris):** the Annual label is renamed app-wide to "Annual Travel Permit"; the other labels stay modal-only. | no |  |  |
| D9 | Type-driven fields | per-type section config table in the modal (data, not 5 components) | Avoids five near-duplicate forms; matches the table in REQ-02. | no | | |
| D10 | Guardrails | **Permit:** no G2 (additive nullable columns), no G3 model, no G5 dependency. **PurchaseOrder (from Q1):** additive nullable columns on an existing tenant model — no G2, no G3 model change, but a second schema change needing `tcg-prisma-guardian`; PO response/DTO shape changes additively, so `tcg-contract-tracer` in the PO unit (G5). **Tracker (Q2):** filter removal widens what a list returns — no data change. | | no | | |
| D11 | Where the start-at-Open change lands | change `PermitsService.create` to `trackableStatus: 'OPEN'` for **all** callers, not only the modal | Haris: "a modal-created permit starts at Open." `create` has no way to tell the modal from the three untouched pages (the DTO deliberately never sets status), and `CLAUDE.md` says a change to one instance of a shape goes to its siblings. Effect: permits from the old pages also start at Open (§11a row 15). Alternative: a create-DTO flag that selects the start status — rejected: lets a client choose a workflow state the code comment says clients must not set. `canAdvanceTrackableStatus` handles Open -> Application Submitted -> Approved as the quotation-minted artifacts already do. | no | | |
| D12 | PO date and Bill to customer: column types and defaults | `po_date DateTime? @db.Date`; `bill_to_customer Boolean?` (nullable, **no DB default**); API absent -> null; UI defaults the toggle on for new POs | Neither exists in any form (REQ-06 search). A calendar day needs no time (`dueDate`, `receivedDate` are `@db.Date`). A DB default of `true` would make every existing PO read "billed to customer" — a billing claim about history (vendor and annual-permit costs the company absorbs: `decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md`). Null = not recorded, shown "Not set"; the edit page sends the fields only when changed so opening a legacy PO never writes them. Alternative: `Boolean @default(true)` — simpler, rejected for that reason; one-line change if the developer prefers. Date alternative: reuse `createdAt` — rejected, not user-set. | no (flag for `tcg-prisma-guardian`) | | |
| D13 | Do the existing PO pages show the new fields; where is PO date required | yes — PO create, edit and detail pages and the other `GeneratePoModal` callers show both (optional); PO date is **required only** in the Create Permit modal's PO variant | The model and DTO are shared; a field settable only from one modal would be a hidden value elsewhere. Making PO date required on the shipped screens would change their validation and the PO flows that exist today; the prototype requires it only inside the nested modal. Alternative: nested modal only — rejected (hidden stored data). Alternative: required everywhere — rejected (breaks existing flows, `qa-automation` PO specs). Nested modal omits Agency and PO items (prototype) — Agency inherited from the permit server-side. | no | | |
| D14 | Tracker for job-less permits | drop the filter; add vendor label to `PermitTrackerResponse`; card shows asset unit code or vendor name when no job; PO-picker scope for a permit with neither job nor project is chosen by the executor and recorded | `updateTrackableStatus`, `submitApplication`, `approvePermit` have no job requirement (read), so "status actions work" is mostly the list, the card identity and the PO picker (`artifact-tracker.mappers.ts` falls back to the whole project when no job). Alternative: leave the card unlabelled — rejected: a vendor-linked Sub Hauler card would show only a code and a type. | no | | |
| D15 | Q3 / Q5 / Annual-on-old-pages | accepted as recorded: Origin = yard, Destination = job site (D4); modal-only labels (D8); Annual Travel visible on `/permits/create`, project and asset create pages (§11c) | Haris, 2026-10-29. | no | | |
| D16 | U1: slot check and assignment sync on create | the (job, asset) slot pre-check runs only for Travel; the job-level assignment sync is skipped for asset-scoped types (Annual and the legacy asset-level type) on create. FAA, Encroachment and Sub Hauler keep their existing job-level sync | REQ-03 and D3 name only Travel for slot reuse; Annual is held per crane across jobs while the slot is unique per (job, asset), so an Annual permit carrying a job and an asset stores both links but takes no slot and cannot 409 Source: the executor, TCG-132 U1; analyst finding 1. | needs developer: no |  |  |
| D17 | U1: column-width limits on the create DTO | `MaxLength` on the FAA string fields equals the `@db.VarChar` widths (100/100/50/50/50/50/100/100/200) | An overlong value would otherwise be a 500. `UpdatePermitDto` has no such caps — a follow-up, not part of U1 Source: the executor, TCG-132 U1; analyst finding 4. | needs developer: no |  |  |
| D18 | U1: error wording and status codes | extra-link error reads `A job-associated permit requires a job only; permit type "X" cannot also be associated with an asset.`; yard, job-site and planner lookups throw 400 like their sibling resolvers; UUIDs are tenant-checked on lookup | The existing service spec matches `/requires a job/` and existing specs may not be edited; spec §4 says to follow the siblings Source: the executor, TCG-132 U1. | needs developer: no |  |  |
| D19 | U1: labels for the new fields in the detail read | `findOne` fetches the yard and job-site labels with two `findUnique` calls in the service, not the repository | Vendor and job labels are fetched the same way in this service Source: the executor, TCG-132 U1. | needs developer: no |  |  |
| D20 | Q8: Annual Travel with job + asset and the (job, asset) slot | an Annual permit takes **no** job-asset slot on create **and** update; one shared predicate `takesJobAssetSlot` (`apps/api/src/usecase/permits/permits.service.ts`) gates both the pre-check and the assignment sync | Extends D16 to update so create and update cannot disagree. Annual is held per crane across jobs (`dispatch/travel-permits-playbook.md` §1, unverified); the slot is unique per (job, asset). Alternative: Annual takes the slot like Travel. **Client-facing**: it decides whether DAS shows the crane permitted on that job. Source: tcg-scrum Q8; executor U10. | needs developer: yes | | |
| D21 | Q10: clearing Valid to on edit | once Valid to is set, the edit page can change it but not clear it | Clearing stores null, which reads as "never expires" (§11a row 7). Silently turning a dated permit into a non-expiring one was judged riskier than requiring a date. Alternative: allow clearing. Source: tcg-scrum Q10; executor U10. | needs developer: yes | | |
| D22 | Q11: PO field on the edit page | hidden on edit; the PO is managed from the permit detail (`ArtifactPoWidget`) | One place for attach/detach/generate avoids two PO flows with different side effects (linked-PO sync, approval gate). Alternative: show it as in the modal. Source: tcg-scrum Q11; executor U10. | needs developer: yes | | |
| D23 | Q9/Q11: scoped project/asset edit routes for the five modal types | render `PermitConfigEdit` **in place** via `PermitEditRouteGate`; no redirect to `/permits/:id/edit` | Keeps the user's project/asset breadcrumb and back navigation. Supersedes the redirect in commit `d628f4427`. Alternative: redirect. Source: executor U10. | needs developer: yes | | |
| D24 | Q12: is a Type alone "unsaved data" | no; a Type alone closes the modal without the leave prompt | A Type with nothing else costs nothing to re-pick. Alternative: any choice prompts. Source: tcg-scrum Q12; executor U9/U10. | needs developer: yes | | |
| D25 | Q14: PO cardinality and the picker scope for job-less permits | an existing PO may be attached to more than one permit; for a permit with neither job nor project the picker lists **all tenant POs** (`assertPoShareableWithPermit` checks nothing then) | D14 delegated only the picker scope. **Conflicts with the open vault gap** `projects-jobs/gaps.md#permitpo-reverse-cascades-incomplete` ("is one PO per permit still the rule"). That gap stays open with a 2026-10-30 pointer. A developer review does not settle the product question (owner Liz Lopez). Alternative: one PO per permit, or same-job only. Source: tcg-scrum Q14. | needs developer: yes | | |
| D26 | U10: Valid till at the API | optional for **every** type at the API | The approved prototype's FAA, Encroachment and Sub Hauler layouts have no Valid till field. **Flag for product review:** a non-Annual permit can therefore have no end date and never expire. Source: executor U10. | needs developer: yes | | |
| D27 | U10: duplicate-annual rule scope | runs only for asset-scoped types; several Travel permits per crane are allowed | Travel is per job (slot-unique per (job, asset)); the duplicate rule was meant for annual coverage per crane. Commit `118732b41`. Source: executor U10. **Superseded 2026-11-03 (Q17, Haris):** the duplicate-annual 409 is removed for every type; a second active Annual for the same asset, type and city is allowed (commits de3452a5b, 919bcc34a). | no — superseded by Q17 |  |  |
| D28 | U10: Travel-only route fields | `travelFrom`, `travelTo`, `originYardId`, `destinationJobSiteId` are accepted only for Travel, plus existing rows that already carry them | The prototype shows them only on Travel. Rejecting them elsewhere stops stray data, and the grandfather clause avoids failing a PATCH of an old row. Source: executor U10. | needs developer: yes | | |
| D29 | U10: tenant-checked references | planner, yard and job-site references are tenant-checked on create **and** update; an archived yard or inactive job site is refused for a **new** selection, and an unchanged existing value is kept | Same as the sibling resolvers (D18). Without the "new selection" rule, an unrelated edit of an old permit would fail. Source: executor U10. | needs developer: yes | | |
| D30 | U10: date-only guard | `@IsDateOnly()` (`apps/api/src/utility/is-date-only.decorator.ts`) on the permit DTO fields stored as `@db.Date` (`travelFrom`, `travelTo`, `receivedDate`, `dueDate`, lift-window fields); `poDate` keeps its own `YYYY-MM-DD` `@Matches` | A full timestamp on a calendar-day column shifts the day across time zones. Commit `118732b41`. Source: executor U10. | needs developer: yes | | |
| D31 | U10: PO date default | the modal pre-fills PO date with the **`BUSINESS_TIMEZONE`** business date (`isoToBusinessDateInput`, `@tcg/shared`) | **Flag:** REQ-06 says tenant timezone (`decisions/2026-09-09-business-timezone-is-a-tenant-property.md`), but the web app has no per-tenant timezone hook, so this uses the single business zone. Per-tenant timezone for the web is in the follow-ups. Source: executor U10. | needs developer: yes | | |
| D32 | U10: the modal's pending (not yet created) PO follows the permit's job | when the user changes the permit's job in the Create Permit modal, the pending nested-PO form's job is rewritten to the new job, and dropped if the job is cleared | Stops the PO from being created against a job the permit no longer carries ("stale PO job", commit `ec7d34b7b`). Source: executor U10. | needs developer: yes | | |
| D33 | U10: E2E and QA doc edits | edited the existing `qa-automation` page object `permits.page.ts` and specs `create.spec.ts`, `validation.spec.ts`, plus the QA docs (permits validation spec and test cases) to follow the edit-page ids, no Area field, optional City / Valid till, and OPEN on create | These are edits of existing tests that follow changed behaviour, not new tests (`decisions/2026-10-21-no-new-tests-unless-asked.md`). Commits `9553d766f`, `33ae511fb`. Source: executor U10. | needs developer: yes | | |
| D34 | Gap D-2: Create Permit type switch | the modal keeps typed values when the Type changes; it clears only Asset, Job and Vendor when the type's scope (association) changes, and clears the PO when the Job clears | The prototype keeps values on a type switch. The payload builder sends only the fields shown for the chosen type, so a kept hidden value cannot reach the API. Alternative: reset everything (`intent.md` Appendix A line 152 "resets, Job/PO cleared"). Alternative: keep every hidden value as the prototype does. Source: gap analysis D-2 (recommended C); executor U12, commit `da80fdf49`. | needs developer: yes | | |
| D35 | Gap D-5: "Gross weight" in the Asset ⓘ popover | shown from the legacy `dvr` column **as stored** (free text, "GVW" in practice); width, height and length are the stored VarChar(30) strings; "-" when empty | No weight column exists. Alternative: numeric weight/unit columns (schema change and backfill) — rejected for this ticket. Source: gap analysis D-5 (recommended A); executor U13. | needs developer: yes | | |
| D36 | Gap D-6: City / Authority vs Agency | **Travel / Annual:** choosing an Agency fills City only while City is empty, and City stays editable. This applies in the modal and on the edit page only; detail inline edit is unchanged. **FAA / Encroachment / Sub Hauler:** the Agency fills State and City, read-only; changing State clears a City that does not match it | Follows the prototype for Travel/Annual. The built app always overwrote City and locked it. **Client-facing.** Alternative: "City follows Agency, read-only" everywhere. Source: gap analysis D-6 (recommended A for modal and edit); executor U12. | needs developer: yes | | |
| D37 | Gap D-7: City without a State (FAA / Encroachment / Sub Hauler) | a City can be picked before, or without, a State (`CitySelect` lists every city) | The prototype allows it and does not auto-fill State. **Client-facing**, low impact. Alternative: City disabled until State is chosen (as built before). Source: gap analysis D-7 (recommended A); executor U12. | needs developer: yes | | |
| D38 | Gap D-8: Track Permits type filter | adds an **"Annual Travel Permit"** option; **"Travel"** matches `TRAVEL_CITY_STREET_PERMIT` only; legacy asset-level types appear only under "All permit types". The filter runs on the server | The prototype has no Annual option. The built app's Travel option took in Annual through a shared docKey. Annual cards are now on the board without a job (Q2/U3), so they need their own option. **Client-facing.** Alternative: copy the prototype (no Annual option). Source: gap analysis D-8 (recommended B); executor U11/U14, commit `1829e658d`. | needs developer: yes | | |
| D39 | Gap D-9: PO picker scope and status | the Create Permit PO picker stays **scoped to the permit's job** and lists **OPEN POs only** (opt-in status filter on `PurchaseOrderSelect`, commit `31280e9dd`). A nested "Create new" PO is created with the permit, after it (D5), not at once | The prototype lists all OPEN POs across jobs, but the API refuses a cross-job attach (`assertPoShareableWithPermit`). D25 (the job-less, project-less picker scope) is unchanged. Alternative: drop the job scope — rejected, because the attach would fail. Source: gap analysis D-9 (recommended A); executor U12. | needs developer: yes | | |
| D40 | Gap D-11: nested Create PO "Notes" | omitted; no column is added | `PurchaseOrder` has no `notes` column, and Description already exists. Matches §13 and the decision note ("Not stored; Haris named two columns only"). Alternative: nullable `notes` column (schema change, `tcg-prisma-guardian`). Source: gap analysis D-11 (recommended A). | needs developer: yes | | |
| D41 | Annual lookup under Asset | reuses `GET /permits?assetId=…&type=…`; **no new endpoint**; the banner shows the City only | Permits store a city but no state, so the banner cannot name a state (state in the banner is a §13b follow-up). Alternative: a dedicated "active annual for asset" endpoint. Source: executor U11/U13. | needs developer: yes | | |
| D42 | Asset ⓘ popover behaviour | opens and closes on click and **stays open until toggled**. Esc closes it only while focus is on the ⓘ button. It does **not** close on an outside click or on Esc elsewhere | An owner instruction relayed with the build. It is not recorded as a decision, so it is listed here. The prototype analysis suggested closing on an outside click or Esc. That was **not followed**, apart from Esc from the button. **Client-facing.** Source: executor U13, commit `c85f91359`. | needs developer: yes | | |
| D43 | DAS "Link annual permit" | the step is **inside the DAS All Permits dialog**, only on **asset-level Travel** rows. It links per (job, asset) through `POST /jobs/:jobId/permit-assignments` and lists annuals filtered by the unit. A **job-level** Travel assignment is not changed, so both rows legitimately exist, and the dialog copy says so. A toast confirms the link and the checklist refreshes | The prototype links one annual per job. The DAS assignment model is per (job, asset), so the link follows that model. **Client-facing.** **Check against D20:** D20 says an Annual's own `jobId` takes no (job, asset) slot. This explicit DAS link does create a (job, asset) assignment for an Annual. Those are two separate paths, and a reviewer should confirm that is intended. The checklist counts the link only when the Annual is APPROVED (Q18). Source: executor U15, commit `13b6cabf6`. | needs developer: yes | | |
| D44 | API validation of a DAS annual link | the link is refused for an **archived** or **cancelled** permit, and for a permit **tied to another asset** | Stops a link that could never cover the crane. Error copy follows the sibling assignment errors. Alternative: allow it and show a warning. Source: executor U15/U16, commits `c014dd100`, `346a6efc5`. | needs developer: yes | | |
| D45 | Received date not before submitted date | on create, update **and approve**, the permit-received date may not be earlier than the application-submitted date. The two are compared as **business-timezone days** | Received before submitted is not a possible real sequence. Comparing calendar days stops a time-zone shift from rejecting a same-day pair. **Client-facing validation that no source states.** Alternative: no rule (store as typed, as Q4 says for status). Source: executor U11/U16, commits `de3452a5b`, `c014dd100`. | needs developer: yes | | |
| D46 | Which "today" each date rule uses | the Valid to banners and the annual banners use the **`BUSINESS_TIMEZONE`** business day. The past-date block (web min date) stays on the **browser-local** day, which matches the API's `IsNotBeforeToday` | Keeps the block identical on web and API, so the web never offers a day the API refuses. The banners describe the business calendar. Same per-tenant-timezone caveat as D31. Alternative: one zone for both, which would need an API change. Source: executor U13/U16. | needs developer: yes | | |
| D47 | Track Permits KPIs | the KPI tiles follow the type filter | The tiles counted every type while the list showed one, so the numbers disagreed with the cards on screen. Alternative: tiles always count every type. Source: executor U14/U16. | needs developer: yes | | |
| D48 | Permit detail: asset and expired annuals | the detail page puts the asset in the title and in Resource (vendor when there is no asset). The sub-category annual table on a Travel detail labels an expired annual **"Expired"** | Without the asset, an asset-level permit's title named only a type and a city. An expired annual is not coverage, so the table should not look as if it were. **Client-facing.** Source: executor U13/U14/U16, commits `3d061b080`, `346a6efc5`. | needs developer: yes | | |
| D49 | Annual Travel is tied to one city | City / Authority is **required** on create and edit (web) and on create/update (API, 400; an update of a legacy annual with no city is refused only when it touches city or turns another permit into an annual). DAS link (`POST /jobs/:jobId/permit-assignments`) is refused with a 400 when the annual's city differs from the job site's city (primary address, else first with a city; names compared trimmed, case-insensitive). The link list keeps other-city rows visible but disabled ("Valid for X, this job is in Y"). A legacy annual with no city, or a job whose site has no city, stays linkable (shown "No city set"). The Asset banner counts only the chosen city's annual, so duplicates are per (asset, city). No schema change: `Permit.city` (the city name) is reused | Reuses `Permit.city`, `countActiveAnnualPermitsByCity`'s case-insensitive name compare, and the permit detail's `jobSiteCity` pick. Alternative: city UUID FK (migration, G3). `assertNoActiveDuplicatePermit` named in section 11a no longer exists in `apps/api/src`, so there is no hard duplicate refusal to re-key; the duplicate rule is the advisory banner only. Source: executor, owner request 2026-11-04. **Resolved by** `decisions/2026-11-04-permit-vendor-required-annual-city-agency-filter.md` (a): Annual is tied to one city (owner direction, `reference`); the exact-name compare here is replaced by D50 | needs developer: yes | | |
| D50 | Annual city match is robust | the Annual's city is compared with the job site's city by **normalised name** (`normalizeCityName` / `isSameCity`, `packages/shared/src/utils/city-match.ts`: diacritics, case, punctuation, "City of" / "… City", St / Ft / Mt expanded), and the link is also allowed when the Annual's **agency covers** the job's city (`agencyCoversCity`: same city, or a County / State / Federal / Special District / Other agency in the same state, or an agency with no city and no jurisdiction). **Editing an Annual's city** re-runs the check against the jobs it is linked to. One rule in `@tcg/shared`, used by the API and the web | Owner direction (a) of `decisions/2026-11-04-permit-vendor-required-annual-city-agency-filter.md`: one city, matched robustly, no brittle exact string. Supersedes D49's trimmed case-insensitive compare. Alternative: city UUID FK (migration, G3), not needed to meet the direction. Stacked jurisdictions (`projects-jobs/city-permits/permit-acquisition-process.md`:64-85) stay one agency per permit. Source: executor, owner request 2026-11-04 | needs developer: yes | | |
| D51 | Vendor on every permit type | Vendor is **required** on Travel, Annual Travel, FAA, Encroachment and Sub Hauler, on create (web and API). A **legacy row without a vendor stays editable**: an update is refused for a missing vendor only when it touches the vendor or the type | Owner direction (b) of `decisions/2026-11-04-permit-vendor-required-annual-city-agency-filter.md` (*"vendors are required for POs since permits come from vendors against POs"*); supersedes D3 for vendors and point 3 of `decisions/2026-09-10-permit-create-types-mockup-document-types.md`. The legacy carve-out follows D49's legacy-annual pattern, so existing rows are not locked until someone edits the field in question. Alternative: refuse any update of a vendor-less row (blocks unrelated edits) or backfill (G2). Source: executor, owner request 2026-11-04 | needs developer: yes | | |
| D52 | Agency picker city filter | when a city is selected, the picker lists agencies that **cover** it (`agencyCoversCity`): same city (normalised), **or** a broader jurisdiction (County / State / Federal / Special District / Other) in the same state (blank state counts as the same), **or** unknown (no city and no jurisdiction). Agencies of another specific city are hidden | AI decision (c) of `decisions/2026-11-04-permit-vendor-required-annual-city-agency-filter.md`, asked for by the owner but **not decided by a person**. Reasons: `projects-jobs/city-permits/permit-acquisition-process.md`:56-62 / :64-85 (counties and Caltrans issue for cities; stacked permits) and `dispatch/travel-permits-playbook.md`:40-46 (statewide Caltrans annual per crane), both `unverified`; the filter's earlier removal is recorded in `projects-jobs/gaps.md#branch-fixdas-fixes--the-artifacts-city-becomes-read-only-and-is-driven-by-the-agency-on-plans-as-well-as-permits` (open). Alternatives: same-city only (hides counties and Caltrans) or no filter (the removed state). Source: executor, owner request 2026-11-04 | needs developer: yes | | |

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Reviewed by | Enumerated by |
| --- | --- | --- | --- | --- |
| `/permits/create` page | P1 | page untouched; **Annual Travel appears in its Type dropdown — accepted by Haris (2026-10-29)**; permits it creates now start at Open (D11); new fields there are a follow-up | | `ls apps/web/src/app/\(protected\)/permits` |
| Project permit create page | P1 | page untouched; **Annual Travel appears in its Type dropdown — accepted by Haris (2026-10-29)**; starts at Open (D11); new fields: follow-up | | `ls "apps/web/src/app/(protected)/projects/[id]/permits"` |
| Asset permit create page + asset detail Permits tab (`showCreateButton={false}`) | P1 | page untouched; **Annual Travel appears in its Type dropdown — accepted by Haris (2026-10-29)**; starts at Open (D11); new fields: follow-up | | `grep -rn showCreateButton apps/web/src/features` |
| Permit edit pages (three) | P1 | yes, in TCG-132 (Q9, Haris 2026-10-30): /permits/:id/edit edits the new fields for the five modal types; the project and asset edit routes render it in place via PermitEditRouteGate (D23) | | `grep -rln "permits/\[permitId\]/edit" apps/web/src/app` |
| Artifact detail (`artifact-detail.tsx`), Plans tracker | none | follow-up (Plans tracker is untouched by REQ-08): the new fields are not editable there either | | `grep -n routeInformation apps/web/src/features/permits-plans/components/artifact-detail.tsx` |
| Purchase Orders create / edit / detail | P1 | yes — PO date and Bill to customer shown (D13), unit in the PO work | | `grep -rn showCreateButton apps/web/src/features/purchase-orders` |

## 12. Open questions — the stop-and-ask list

**Q7–Q14 were raised by `tcg-scrum` at the PR review of the U9 live-test fixes (2026-10-29).** Q7, Q9 and Q13 are
resolved by Syed Haris's developer instructions of 2026-10-29/30, recorded in the same decision note's *Addendum
2026-10-30*. Q8, Q10, Q11, Q12 and Q14 have **no human answer**: each is recorded as an AI decision in §11b
(D20–D24, `needs developer: yes`) and stays **awaiting developer review**. Their status line does not read
`open`, so the sweep below does not find them. Find them with
`grep -n 'awaiting developer review' .ai/aidlc/TCG-132/spec.md`. Q1–Q6 were answered by Syed Haris (developer) on 2026-10-29, relayed by the
coordinator, and recorded by `tcg-scrum` on 2026-10-29 in `decisions/2026-10-29-all-permits-create-permit-modal.md` (`status: reference`: a developer
direction, not a TCG sign-off). Each line below reads `resolved — see` that note. Sweep:
`grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/[A-Z]*/spec.md`.

**Q15–Q18 came from the prototype re-exploration (2026-10-30).** They are decisions D-1, D-3, D-4 and D-10 of the
88-row gap analysis between the approved prototype and the built app. Syed Haris answered all four in the
Claude Code session of 2026-10-30 to 2026-11-03, relayed by the coordinator. They are recorded in the same
decision note's *Addendum 2026-11-03* as developer directions (`reference`), not as a TCG sign-off. The other
gap-analysis decisions (D-2, D-5 to D-9, D-11) and the build choices of U11–U16 have no human answer. They are
AI decisions D34 onward in §11b (`needs developer: yes`) and have no §12 entry.

### Q1 — Which fields does the inline "Create new" PO carry?

- **Question:** The prototype's nested "Create PO" shows PO date, PO fee, Description, Invoice, Notes and a "Bill to customer" toggle and omits Agency and PO items; the locked 2026-09-11 PO modal set is the opposite, and the PO table has no PO-date or bill-to-customer field. Which set does the permit modal's Create PO use?
- **Options:**
  - A. The shipped PO modal unchanged
  - B. The prototype's set — add PO date and bill-to-customer columns, drop Agency / items from this modal
  - C. The shipped set plus the prototype extras that already have a column
  - X. Other — say what
- **Answer:** B — match the prototype and add the columns: `PurchaseOrder.po_date` and `PurchaseOrder.bill_to_customer` (nullable or defaulted). Syed Haris, 2026-10-29. Defaults, DTO/response reach and whether the existing PO pages show them delegated to the elaborator: D12, D13.
- **Why it cannot be answered from what is written:** `decisions/2026-09-11-outbound-po-subtypes-and-modal-fields.md` locks the first set; no vault file mentions a PO date or a bill-to-customer flag; `grep -n "billTo\|poDate" schema.prisma` has no match.
- **Blocked:** REQ-06 (nested modal fields) — now unblocked.
- **Candidates:** `decisions/2026-09-11-outbound-po-subtypes-and-modal-fields.md` (4.4 KB, 2026-09-11); `decisions/2026-10-08-po-fee-typed-by-user-approval-leaves-po-alone.md` (2026-10-08); `vendors-agencies/purchase-order.md`; `decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md`.
- **Owner:** Syed Haris
- **Workaround, if any:** none needed.
- **Status:** resolved — see decisions/2026-10-29-all-permits-create-permit-modal.md

### Q2 — Should Annual Travel and Sub Hauler permits created from the modal appear on Track Permits?

- **Question:** Track Permits lists job-linked permits only (accepted gap, 2026-09-11). Do job-less modal-created permits stay off it, or must the tracker show them?
- **Options:**
  - A. Stay off Track Permits
  - B. Track Permits lists every permit regardless of job
  - C. Job-linked permits plus Annual Travel (asset-linked) only
  - X. Other — say what
- **Answer:** B — show all permits on Track Permits; drop the `jobId: { not: null }` filter in `findAllForTracker`; make the status actions work for asset-linked and vendor-linked permits; supersede `decisions/2026-09-11-track-permits-job-only-until-sept-15.md` for this. Syed Haris, 2026-10-29.
- **Why it cannot be answered from what is written:** `decisions/2026-09-11-track-permits-job-only-until-sept-15.md` deferred it to "post-15-Sep general-class work" and left it unsettled; the date has passed.
- **Blocked:** REQ-08 — now unblocked.
- **Candidates:** `decisions/2026-09-11-track-permits-job-only-until-sept-15.md` (3.6 KB); `decisions/2026-09-11-permit-classes-job-only-until-sept-15.md`; `projects-jobs/city-permits/permit-tracker-workbook.md` (13.7 KB); `projects-jobs/gaps.md#branch-fixdas-fixes--permit-type-remap-job-only-track-permits-projects-list-as-a-table`.
- **Owner:** Fouzan Shakil / Syed Haris
- **Workaround, if any:** none needed.
- **Status:** resolved — see decisions/2026-10-29-all-permits-create-permit-modal.md

### Q3 — Is the Travel permit's Origin the yard, or the application's freeway-exit origin?

- **Question:** Haris's rule is Origin = the yard; the dispatch SOP says the application origin is the nearest freeway exit. Is the yard the intended Origin?
- **Options:**
  - A. Yes — Origin is the yard
  - B. Yard by default but editable
  - C. Application origin, not necessarily a yard
  - X. Other — say what
- **Answer:** A — accepted. Origin is the yard and Destination is the job site, as decided by Haris. Syed Haris, 2026-10-29.
- **Why it cannot be answered from what is written:** only `dispatch/travel-permits-playbook.md` §1 (unverified, one author) addresses it, against an explicit decision.
- **Blocked:** none.
- **Candidates:** `dispatch/travel-permits-playbook.md`; `projects-jobs/city-permits/permit-acquisition-process.md`.
- **Owner:** Syed Haris (Brian Petros / Liz Lopez own the SOP)
- **Workaround, if any:** none needed.
- **Status:** resolved — see decisions/2026-10-29-all-permits-create-permit-modal.md

### Q4 — What status does a modal-created permit start at?

- **Question:** Should the start status depend on the entered Application submitted and Permit received dates?
- **Options:**
  - A. Always Application Submitted, as today
  - B. Open / Application Submitted / Approved by the dates entered
  - X. Other — say what
- **Answer:** X — a modal-created permit starts at **Open**. Submitted and received dates are stored as typed but never drive the status. Syed Haris, 2026-10-29.
- **Why it cannot be answered from what is written:** the status was a code-level choice (`permits.service.ts` `create`), not a decision; the prototype and the card are silent.
- **Blocked:** REQ-04 (starting status) — now unblocked.
- **Candidates:** `decisions/2026-09-11-permit-approval-requires-linked-po.md`; `decisions/2026-09-11-quote-to-project-permits-plans-flow.md` (6.7 KB); `projects-jobs/project-module/05-create-and-track-permits.md`.
- **Owner:** Syed Haris
- **Workaround, if any:** none needed.
- **Status:** resolved — see decisions/2026-10-29-all-permits-create-permit-modal.md. The answer named the modal. Extending it to every caller of `POST /permits` (D11) was the elaborator's reading, and Haris confirmed it in Q6.

### Q5 — Are the prototype's type names the new names app-wide?

- **Question:** Should lists, filters, tracker, print and DAS use the prototype names too?
- **Options:**
  - A. Modal only; elsewhere unchanged
  - B. Rename everywhere
  - X. Other — say what
- **Answer:** A — accepted. Modal-only labels; `PERMIT_TYPE_LABELS` unchanged. Syed Haris, 2026-10-29.
- **Why it cannot be answered from what is written:** the card and prototype name the modal's options only.
- **Blocked:** §11a row 14 only — now unblocked.
- **Candidates:** none: nothing written.
- **Owner:** Syed Haris
- **Workaround, if any:** none needed.
- **Status:** resolved — see decisions/2026-10-29-all-permits-create-permit-modal.md

### Q6 — Existing E2E specs assert the old start status (raised by `tcg-decomposer`, 2026-10-29)

- **Question:** D11 makes `POST /permits` start at Open for every caller. `qa-automation/e2e/specs/permits/create.spec.ts:97` and `status.spec.ts:20, 61` assert `trackableStatus: 'APPLICATION_SUBMITTED'` right after create, so they will fail. §11a row 15 says none do. May the developer update those three expectations in U1 (an edit of existing tests, not a new test), or should D11 be narrowed to the modal?
- **Options:**
  - A. Update the three expectations to `OPEN` in the U1 PR
  - B. Narrow D11 (modal-only start status; needs a way to tell the caller apart)
  - X. Other — say what
- **Answer:** A. Every create caller starts at Open, and U1 updates the three assertions in
  `qa-automation/e2e/specs/permits/create.spec.ts:97` and `status.spec.ts:20` and `:61` from
  `APPLICATION_SUBMITTED` to `OPEN`. This is an edit of existing tests, not a new test. D11 is
  **confirmed by the developer**. Syed Haris, 2026-10-29.
- **Why it cannot be answered from what is written:** §5 says "the existing E2E specs are not edited"; D11 says every caller moves.
- **Blocked:** U1 build only (`units.md`), now unblocked.
- **Owner:** Syed Haris
- **Workaround, if any:** none needed.
- **Note:** this answer makes two lines elsewhere in this spec wrong. §11a row 15 says no spec asserts a
  permit start status, but three do. §5 says "the existing E2E specs are not edited", but these three are.
  `tcg-scrum` writes only §12, so it did not change either line. The corrected text is in its 2026-10-29
  handoff to the coordinator.
- **Status:** resolved — see decisions/2026-10-29-all-permits-create-permit-modal.md

### Q7 — Does a directly created permit count as "filled in" (no "Not filled in yet" banner)? (raised by `tcg-scrum`, PR review, 2026-10-29)

- **Question:** `PermitsService.create` now sets `savedAt` on every `POST /permits` (modal and the three old create pages), so those permits never show the artifact detail's "Not filled in yet" banner, while quotation-minted permits still start with it. Is that the intended rule?
- **Options:** A. Yes — every direct create counts as filled in · B. Only the Create Permit modal counts; the old pages keep the banner until first save · C. No — every new permit shows the banner until its first save · X. Other — say what
- **Answer:** A — `savedAt` is set on every direct `POST /permits`, so no directly created permit shows the
  "Not filled in yet" banner. Quotation-minted permits still start with `savedAt` null and show it until their
  first save. Syed Haris (developer), 2026-10-29/30. He asked after the live test that the banner not show on
  **modal-created** permits. Extending that to every direct create (the three old create pages too) follows
  the same one-rule-for-every-caller reasoning as Q6/D11, and it is his instruction as relayed by the coordinator.
- **Candidates:** none: nothing written. `apps/api/prisma/schema.prisma` `Permit.savedAt` comment is code, not a source; no vault file or decision mentions the banner or `saved_at`.
- **Blocked:** nothing now.
- **Owner:** Syed Haris (permits owners on the TCG side: Lisette Anzaldo, Brian Petros)
- **Status:** resolved — see decisions/2026-10-29-all-permits-create-permit-modal.md (Addendum 2026-10-30, point 13). This is a developer direction (`reference`), not a TCG sign-off.

### Q8 — Does an Annual Travel permit that also carries a job count as that job's permit for the asset? (raised by `tcg-scrum`, PR review, 2026-10-29)

- **Question:** An Annual Travel permit created with an asset and a job stores both links but takes no (job, asset) assignment slot (AI decision D16), whereas Travel does. Should an Annual permit's optional job make it count as that crane's permit on that job (assignment slot / DAS pre-checklist), or is the job reference-only?
- **Options:** A. Reference-only — no slot, as built (D16) · B. Takes the (job, asset) slot like Travel · X. Other — say what
- **Answer:** none from a person. As built: A, reference-only. The rule now applies on create **and** update
  through one shared predicate (`takesJobAssetSlot`, `apps/api/src/usecase/permits/permits.service.ts`). This is
  AI decision **D20** in §11b.
- **Candidates:** spec REQ-03 *Edges* and D3 name only Travel for slot reuse; D16 (executor AI decision, unreviewed); `decisions/2026-10-29-all-permits-create-permit-modal.md` point 4 (association only, encoding delegated); `dispatch/travel-permits-playbook.md` §1 (unverified: annual held per crane). Related open vault entry: `projects-jobs/gaps.md#conversion-mints-artifacts-without-das-assignment-rows`.
- **Note:** D16 is a reasonable reading, but it decides whether DAS shows the crane as permitted on that job, which is client-facing. "Fix all the issues" does not answer it.
- **Blocked:** nothing in the build. The rule ships as D20 unless the developer reverses it.
- **Owner:** Syed Haris (DAS/permits owner on the TCG side: Lisette Anzaldo)
- **Status:** recorded as AI decision D20, awaiting developer review — not resolved

### Q9 — Is the permit edit page (and PATCH of the new fields) in TCG-132's scope? (raised by `tcg-scrum`, PR review, 2026-10-29)

- **Question:** Commits `20ce93661` and `d628f4427` add editing of validity, travel dates, route and application dates on `PATCH /permits`, an edit page built on the modal's sections, and redirect the project/asset edit routes to `/permits/{id}/edit` for the five modal types. This spec places all of that out of scope (REQ-04 *Edges*: PATCH "not changed by this ticket"; §11c and §13: edit pages are a follow-up). Keep it in TCG-132, or move it to a follow-up ticket?
- **Options:** A. Keep in TCG-132 — this answer amends REQ-04 / §11c / §13 · B. Move to a follow-up ticket; revert from this branch · X. Other — say what
- **Answer:** A — keep it in TCG-132. Kept:
  - the edit page (`/permits/:id/edit`) for the five modal types;
  - `PATCH /permits` accepting the new fields (`validFrom`, `travelFrom`/`travelTo`, `originYardId`,
    `destinationJobSiteId`, and the application-submitted and permit-received dates);
  - the scoped project and asset edit routes rendered through `PermitEditRouteGate`.

  This **amends** REQ-04 *Edges* ("PATCH not changed by this ticket"), the §11c row "Permit edit pages (three)"
  and §13. Syed Haris (developer), 2026-10-29/30: after the live test he asked for the permit detail and edit
  pages to show and edit the new fields. His answer does not cover how the scoped routes render (in place, no
  redirect). That is AI decision D23 in §11b, awaiting developer review.
- **Candidates:** this spec REQ-04 *Edges*, §11c row "Permit edit pages (three)", §13; `units.md` U1 *Deliberately not in this unit*.
- **Blocked:** nothing now.
- **Owner:** Syed Haris
- **Status:** resolved — see decisions/2026-10-29-all-permits-create-permit-modal.md (Addendum 2026-10-30, point 11). This is a developer direction (`reference`), not a TCG sign-off.

### Q10 — On the permit edit page, may Valid to be cleared once set? (raised by `tcg-scrum`, PR review, 2026-10-29; moot if Q9 = B)

- **Question:** The edit page cannot clear Valid to once it has a value, although create makes it optional. Should the user be able to clear it?
- **Options:** A. No — once set it can only be changed · B. Yes — clearing stores null ("never expires") · X. Other — say what
- **Answer:** none from a person. As built: A. Once Valid to has a value, the edit page can change it but not
  clear it. This is AI decision **D21** in §11b. Q9 = A (edit page kept), so this question is not moot.
- **Candidates:** none: nothing written. Create-side rule: decision point 5 ("Valid till is no longer required"); §11a row 7 (null `validTill` reads as never expiring).
- **Blocked:** nothing in the build. The rule ships as D21 unless the developer reverses it.
- **Owner:** Syed Haris
- **Status:** recorded as AI decision D21, awaiting developer review — not resolved

### Q11 — Does the permit edit page show the Purchase Order field? (raised by `tcg-scrum`, PR review, 2026-10-29; moot if Q9 = B)

- **Question:** The edit page hides the PO field (PO is managed on the permit detail / `ArtifactPoWidget`). Is that intended, or should edit show and change the PO as the modal does?
- **Options:** A. Hidden on edit; PO managed from the permit detail · B. Shown and editable as in the modal · X. Other — say what
- **Answer:** none from a person. As built: A. The PO field is hidden on the edit page, and the PO is managed
  from the permit detail (`ArtifactPoWidget`). This is AI decision **D22** in §11b. Related AI decision **D23**:
  the scoped project and asset edit routes render `PermitConfigEdit` in place through `PermitEditRouteGate`
  instead of redirecting to `/permits/:id/edit`.
- **Candidates:** none: nothing written. The prototype capture (`intent.md` Appendix A) shows only "Permit detail page: Edit" as context, with no field list.
- **Blocked:** nothing in the build. The rule ships as D22/D23 unless the developer reverses it.
- **Owner:** Syed Haris
- **Status:** recorded as AI decisions D22 and D23, awaiting developer review — not resolved

### Q12 — Does choosing only a Type count as unsaved data for the leave prompt? (raised by `tcg-scrum`, PR review, 2026-10-29)

- **Question:** The modal skips the "Are you sure you want to leave?" prompt when the user has chosen a Type but entered nothing else. Is a Type alone "data"?
- **Options:** A. No — Type alone closes without the prompt, as built · B. Yes — any choice, including Type, prompts · X. Other — say what
- **Answer:** none from a person. As built: A. Choosing only a Type is not unsaved data, so the modal closes
  without the prompt. This is AI decision **D24** in §11b.
- **Candidates:** `intent.md` Appendix A *Entry* ("Leaving with data shows a prompt") — does not define "data"; REQ-01 *Acceptance* ("closing with entered data").
- **Blocked:** nothing material; the built rule ships unless reversed.
- **Owner:** Syed Haris
- **Status:** recorded as AI decision D24, awaiting developer review — not resolved

### Q13 — The app-wide `PERMIT_TYPE_LABELS` rename contradicts Q5 — revert, or reverse Q5? (raised by `tcg-scrum`, PR review, 2026-10-29)

- **Question:** Commit `1d05bb069` changes `PERMIT_TYPE_LABELS.TRAVEL_ANNUAL_PURPLE_PERMIT` from `Travel permits — Annual "Purple Permit"` to `Annual Travel Permit` in `packages/shared`, which renames it in every list, filter, tracker, print and DAS label. Q5 (answer A) and D8 say modal-only labels and `PERMIT_TYPE_LABELS` unchanged. Revert the shared change, or reverse Q5 for this one label?
- **Options:** A. Revert — modal-only label, per Q5 · B. Keep — rename Annual app-wide (supersedes Q5 for this label only) · X. Other — say what
- **Answer:** B — keep it. `PERMIT_TYPE_LABELS.TRAVEL_ANNUAL_PURPLE_PERMIT` reads **"Annual Travel Permit"**
  app-wide. This reverses Q5 / D8 **for this one label only**. Every other type keeps its shared label, and its
  prototype label stays modal-only. Syed Haris (developer), 2026-10-29/30: after the live test he asked for the
  Annual type label to read "Annual Travel Permit".
- **Candidates:** this spec Q5 and D8; `decisions/2026-10-29-all-permits-create-permit-modal.md` point 9.
- **Blocked:** nothing now.
- **Owner:** Syed Haris
- **Status:** resolved — see decisions/2026-10-29-all-permits-create-permit-modal.md (Addendum 2026-10-30, point 12). This is a developer direction (`reference`), not a TCG sign-off.

### Q14 — May one PO link several permits, and may a job-less permit take any tenant PO? (raised by `tcg-scrum`, PR review, 2026-10-29)

- **Question:** The modal lets one existing PO be attached to two permits, and for a permit with neither job nor project the picker lists every tenant PO (the API's `assertPoShareableWithPermit` checks nothing in that case). Is a PO shared across permits allowed — and if so, only within the same job/vendor, or across any permits?
- **Options:** A. One PO per permit · B. Several permits on the same job only (job-less permits get a PO of their own) · C. Several permits on the same job and same vendor/city · D. Any permits, as built · X. Other — say what
- **Answer:**
- **Candidates:** existing open vault entry `projects-jobs/gaps.md#permitpo-reverse-cascades-incomplete` (asks "is one PO per permit still the rule"; notes the same-job multi-permit PO is an extrapolation and the nearest written rule is "one PO per vendor per job", `meetings/2026-06-22-sprint-4-additional.md`:86 — a record, not a commitment); D14 (picker scope delegated to the executor by `decisions/2026-10-29-all-permits-create-permit-modal.md` *What this does not settle*).
- **Answer:** none from a person. As built: D. An existing PO may be attached to more than one permit, and for
  a permit with neither job nor project the picker lists every tenant PO. This is AI decision **D25** in §11b.
  **It conflicts with the open vault gap** `projects-jobs/gaps.md#permitpo-reverse-cascades-incomplete`. That
  gap stays **open**, and it now carries an *Update 2026-10-30* pointer to this question.
- **Note:** D14 delegated only the picker *scope*; it did not settle PO cardinality, which stays open in the vault entry. Listing all tenant POs for job-less permits widens the unsettled extrapolation.
- **Blocked:** nothing in the build. It ships as D25 unless reversed. PO cardinality is a product question for Liz Lopez, which a developer review alone does not settle.
- **Owner:** Liz Lopez (PO process, per the vault entry), with Lisette Anzaldo; Syed Haris for the ticket
- **Status:** recorded as AI decision D25, awaiting developer review — not resolved; product question stays open at projects-jobs/gaps.md#permitpo-reverse-cascades-incomplete

### Q15 — May Valid to be in the past when a permit is created? (gap analysis D-1, prototype re-exploration, 2026-10-30)

- **Question:** The prototype saves a permit with Valid to in the past and shows a red "This permit expired {date}." banner. The built app blocks it on the web (min date) and at the API (`IsNotBeforeToday` on the create and update DTOs, which three other create pages share). Allow a past Valid to on create, or keep the block?
- **Options:** A. Allow a past Valid to (modal only; the permit saves as expired) · B. Keep the block; add the amber and green Valid to banners; show the red "expired" note only on detail and edit for a permit that has already expired · X. Other — say what
- **Answer:** B. Valid to in the past stays **blocked** on create (web min date, API `IsNotBeforeToday`). Under Valid to the app shows an amber "Expires in N days" banner and a green "Valid until {date}" banner. Detail and edit show a red "expired" note for a permit that has already expired. Syed Haris (developer), 2026-10-30/11-03. The 30-day line between amber and green is the prototype's (`Expires in` for 0–30 days, `Valid until` beyond).
- **Candidates:** the prototype (captured in the 2026-10-30 re-exploration notes: past Valid to saves with a red banner); `apps/api` `create-permit.dto.ts` / `update-permit.dto.ts` `IsNotBeforeToday`; no vault file mentions past-dated permits.
- **Blocked:** nothing now (U12, U13).
- **Owner:** Syed Haris (permits owners on the TCG side: Lisette Anzaldo, Brian Petros)
- **Status:** resolved — see decisions/2026-10-29-all-permits-create-permit-modal.md (Addendum 2026-11-03, point 14). This is a developer direction (`reference`), not a TCG sign-off.

### Q16 — What happens after Create Permit succeeds? (gap analysis D-3, prototype re-exploration, 2026-10-30)

- **Question:** The prototype closes the modal and opens the new permit's detail page with no toast. The built app stayed on All Permits and showed a success toast. Which one?
- **Options:** A. Stay on the list with a success toast · B. Go to the new permit's detail page with no success toast; keep the failure toasts for the PO and attachment steps · C. Go to the detail page and keep the success toast · X. Other — say what
- **Answer:** B. After a successful create the modal closes and the app goes to the new permit's detail page. There is **no** success toast. The failure toasts for the PO and attachment steps stay. Syed Haris (developer), 2026-10-30/11-03.
- **Candidates:** the prototype (re-exploration notes); `intent.md` Appendix A does not say what follows a create.
- **Blocked:** nothing now (U12).
- **Owner:** Syed Haris
- **Status:** resolved — see decisions/2026-10-29-all-permits-create-permit-modal.md (Addendum 2026-11-03, point 15). This is a developer direction (`reference`), not a TCG sign-off.

### Q17 — May an asset have a second active Annual permit for the same type and city? (gap analysis D-4, prototype re-exploration, 2026-10-30)

- **Question:** In the prototype, the green "Annual permit found" note under Asset is advisory and the create still goes through. The API returned 409 for a second active Annual permit with the same asset, type and city (`assertNoActiveDuplicatePermit` / `findActiveDuplicate`; scoped to asset types by AI decision D27). Keep the 409, or allow the duplicate?
- **Options:** A. Keep the API 409; the banner explains the conflict · B. Remove the 409; the banner is advisory only · X. Other — say what
- **Answer:** B. A second **active** Annual permit for the same asset, type and city is **allowed**. The API's duplicate-annual 409 is removed (`assertNoActiveDuplicatePermit` / `findActiveDuplicate`), and the green banner under Asset is advisory. This supersedes AI decision **D27** and the earlier one-active-annual rule. Syed Haris (developer), 2026-10-30/11-03. It goes against the gap analysis's recommendation (A).
- **Candidates:** AI decision D27 (§11b); `projects-jobs/gaps.md#permit-rules-the-e2e-suite-asserts-with-no-written-source--pr-488` item (d). That entry asks whether the guard is one active annual per (asset, type, city). It notes that `projects-jobs/city-permits/permit-tracker-workbook.md`:120-124 (`unverified`) keeps several records per city side by side, which goes against such a guard. No decision note ever set the rule.
- **Note:** the code change and the edit of the existing E2E spec `qa-automation/e2e/specs/permits/duplicates.spec.ts` (now asserts the second annual is accepted) are in commits `de3452a5b` and `919bcc34a`. The vault entry above stays **open**. A developer direction is not the product answer its owners (Lisette Anzaldo, Liz Lopez) were asked for. It now carries an *Update 2026-11-03* pointer to this question.
- **Blocked:** nothing now (U11).
- **Owner:** Syed Haris for the ticket; Lisette Anzaldo and Liz Lopez for the vault entry
- **Status:** resolved — see decisions/2026-10-29-all-permits-create-permit-modal.md (Addendum 2026-11-03, point 16). This is a developer direction (`reference`), not a TCG sign-off.

### Q18 — Does a linked Annual permit satisfy the DAS pre-checklist Permits row before it is approved? (gap analysis D-10, prototype re-exploration, 2026-10-30)

- **Question:** In the prototype, linking an annual on DAS turns the Permits row green at once (its seed annuals are already Approved). The built checklist counts a linked permit only when it is APPROVED, and a modal-created Annual starts at Open. Must the linked Annual be approved?
- **Options:** A. Only when APPROVED (existing checklist logic) · B. Satisfied when linked and Valid to has not passed, approved or not · X. Other — say what
- **Answer:** A. A linked Annual counts toward the DAS pre-checklist Permits row **only when it is APPROVED**. The existing checklist logic is kept. Syed Haris (developer), 2026-10-30/11-03.
- **Candidates:** the prototype (re-exploration notes); existing DAS pre-checklist code (descriptive only). Related open vault entry: `projects-jobs/gaps.md#conversion-mints-artifacts-without-das-assignment-rows`.
- **Blocked:** nothing now (U15).
- **Owner:** Syed Haris (DAS/permits owner on the TCG side: Lisette Anzaldo)
- **Status:** resolved — see decisions/2026-10-29-all-permits-create-permit-modal.md (Addendum 2026-11-03, point 17). This is a developer direction (`reference`), not a TCG sign-off.

### Q19 — Does allocating an asset auto-link the job's Travel permit, and does Unlink stop it re-linking? (raised by `tcg-scrum`, code-review follow-up, 2026-11-04)

- **Question:** A travel permit is applied for per crane. When an asset is allocated to a job that already has a job-level Travel permit, should the app link that permit to the asset automatically, and if a user then Unlinks it, does the app stop re-linking it on the next allocation or sync?
- **Options:** A. Auto-link on allocation; Unlink is remembered and the app never re-links that (job, asset, permit) · B. Auto-link on allocation; Unlink is not remembered, the next allocation or sync re-links · C. Never auto-link; the dispatcher links each crane by hand · X. Other — say what
- **Answer:**
- **Candidates:** `dispatch/travel-permits-playbook.md`:18-19 (`unverified`), *"All cranes 40 ton or bigger required travel permit"*, and :40-46 (the Caltrans annual is held per crane). Neither says whether a job's city travel permit covers each allocated crane or is applied for per crane. AI decision D3 (§11b) notes the artifact flow already holds a Travel permit with job + asset (`syncJobAssetAssignment`). The unlink endpoint distinguishes asset-scoped and job-level assignments (`apps/api/src/presentation/job-permit-assignments/job-permit-assignments.controller.ts`:72). No decision note covers auto-linking.
- **Note:** raised in the same 2026-11-04 review as `decisions/2026-11-04-permit-vendor-required-annual-city-agency-filter.md`; not answered there.
- **Blocked:** the DAS permit link/unlink behaviour for allocated assets (TCG-132 follow-up units).
- **Owner:** Lisette Anzaldo (TCG-side permit owner)
- **Status:** open

### Q20 — Does linking another permit to a (job, asset) replace the existing link, and does the job-level permit count as coverage after Unlink? (raised by `tcg-scrum`, code-review follow-up, 2026-11-04)

- **Question:** Two parts, each answerable in a line. (a) When a (job, asset) already has a permit linked and the user links a different permit to the same (job, asset), does the new link **replace** the old one, or do both stay linked? (b) After the asset-level link is Unlinked, does the job's job-level permit still count as that asset's permit coverage (DAS pre-checklist Permits row, Track Permits)?
- **Options:** (a) A. Replace · B. Both stay linked · X. Other — say what. (b) A. Yes, the job-level permit still covers the asset · B. No, the asset is uncovered until a permit is linked to it again · X. Other — say what
- **Answer:**
- **Candidates:** AI decision D20 (§11b; Q8, awaiting developer review): an Annual permit with a job and an asset takes no (job, asset) slot. Q18 (resolved): a linked Annual counts toward the Permits row only when APPROVED. Neither says whether a link replaces another or what covers an asset after Unlink. No vault file covers it.
- **Note:** raised in the same 2026-11-04 review as Q19; not answered by `decisions/2026-11-04-permit-vendor-required-annual-city-agency-filter.md`.
- **Blocked:** the DAS link flow's replace/append behaviour and the Permits-row coverage after Unlink (TCG-132 follow-up units).
- **Owner:** Lisette Anzaldo (TCG-side permit owner)
- **Status:** open

## 13. What this spec deliberately does not specify

- **What "Bill to customer" does downstream** — whether it adds the PO fee to a customer invoice, quote or
  statement, or filters any report. No source says; this spec stores and shows the flag only. Money-adjacent:
  raise before anything reads it.
- **The prototype's PO "Notes" field** — no `PurchaseOrder` column and Haris named only two new columns, so
  the nested modal omits it (ASSUMED, REQ-06). One-line reversal if Haris wants a third column.
- **PO-picker scope for a permit with neither job nor project** — no source; executor decision recorded (D14).
- Whether Destination defaults from the chosen Job, field lengths/ranges, new error copy, roles, responsive
  layout — `NOT SPECIFIED`.
- Showing the new Permit fields on the permit table, print or artifact detail is outside the card. Detail and edit **are** in scope (Q9, amended 2026-10-30).
- Any change to `/permits/create`, project/asset create pages beyond the accepted Annual Travel side-effect
  and the Open start status (D11).

### 13a. Vault files that need updating once Haris's decisions are recorded (written by `tcg-scrum`, not by the elaborator)

1. New note `decisions/2026-10-29-all-permits-create-permit-modal.md` (Syed Haris): reversal of hide-create on
   All Permits; D1/D3 association; Q3, Q4, Q5 answers; Annual Travel on the old create pages. Mark Q1–Q5
   `resolved` in this spec's §12.
2. `decisions/2026-09-11-permit-classes-job-only-until-sept-15.md` — points 2 and 4 superseded for All
   Permits; the 15 Sep deadline has passed; back-pointer.
3. `decisions/2026-09-10-permit-create-types-mockup-document-types.md` — catalog now five incl. Annual (point
   1); association: Travel may carry an asset, Annual may carry a job, Annual offered on create (point 3).
4. `decisions/2026-09-10-permit-association-scope-asset-job-vendor.md` — "exactly one" relaxed for Travel/Annual.
5. `decisions/2026-09-11-track-permits-job-only-until-sept-15.md` — **superseded** (Q2): tracker lists all
   permits; asset-/vendor-linked permits get status actions.
6. `decisions/2026-09-11-outbound-po-subtypes-and-modal-fields.md` — locked set superseded for the permit-create
   modal (prototype set: PO date, Bill to customer; no Agency / items); stands for other PO screens, which
   gain PO date and Bill to customer. Add a note on the new `po_date` / `bill_to_customer` columns.
7. `decisions/2026-10-08-po-fee-typed-by-user-approval-leaves-po-alone.md` — "create-time fee default not
   settled" is now settled for the permit modal (prefill from service fee, editable).
8. `projects-jobs/gaps.md#permits-can-no-longer-be-created-outside-the-artifact-flow--and-the-vault-says-they-can`
   and `…#branch-fixdas-fixes--permit-type-remap-job-only-track-permits-projects-list-as-a-table` — status lines
   point at the new note.
9. `INDEX.md` — decisions rows for the permit notes (lines ~161–171, ~179) and a row for the new note.

### 13b. Known follow-ups (listed, not decided)

- **Cross-tenant FK checks for `assetId`, `jobId`, `vendorId`, `agencyId`, `projectId`** on permit create
  and update. This predates TCG-132. The tenant extension scopes where-clauses, not FK values. The existing
  service specs mock these lookups, so a fix needs those specs updated.
- **Split permit logic out of** `ArtifactDetail.tsx` and `PermitsService`.
- **A field-definition registry** for the create-permit layout.
- **A transaction around permit create** (create, PO attach/generate, attachments; see D5).
- **A Cancel/Escape confirm on the nested PO modal.**
- **A PO number preview** in the nested Create PO.
- **A PO Notes column.** The prototype shows Notes, but `PurchaseOrder` has no column for it. Still
  unbuilt, awaiting Haris (§13, first bullet).
- **A per-tenant timezone for the web** (see D31).
- **Require the asset to be allocated to the job before linking** an annual from DAS (D43). Today the link
  checks only the permit, not the job's allocation.
- **An asset allocation check on `linkType`** for permit assignments.
- **Nested PO number preview and selects** in the nested Create PO (extends the existing "PO number preview" bullet).
- **State in the annual banner** under Asset. Permits store no state today (D41).
- **The raw `QUOT_RESOURCE_ADDED` activity-log wording**, which shows the event code instead of a readable line.
- **A DAS annual whose validity ends before the job date.** Today it can be linked and, once approved, counts on the checklist.
- **Unbounded sub-category and vendor list lookups** on the permit list and Track Permits filters.
- **Migration order against staging.** `20261029120000_add_permit_route_and_validity_dates` and
  `20261029130000_add_purchase_order_po_date_bill_to_customer` sort **before** staging's
  `20261102120000_yard_loadout_completed_shifts_at`. A developer should confirm that ordering is fine on the
  target database (Prisma applies the unapplied ones but reports them out of order).

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered — none remain (REQ-08 answered by Q2)
- [x] Every `[CONFLICT]` requirement has a decision note — none flagged `[CONFLICT]`; the in-tree decision pair is noted in REQ-03
- [x] Answers written back into `spec.md` with their new sources and flags (2026-10-29)
- [x] Every §12 question has a status line. Q1–Q7, Q9, Q13 and Q15–Q18 are resolved (decision note + Addenda 2026-10-30 and 2026-11-03). Q8, Q10–Q12 and Q14 are recorded as AI decisions D20–D25, awaiting developer review (tcg-scrum 2026-10-30, 2026-11-03)
- [x] Every requirement's **Edges** fields are filled (`ASSUMED` allowed) or point at a §12 question
- [x] Every §11a ripple row has a source, or an AI decision (rows 15, 19: D11, D14)
- [ ] A developer has reviewed §11b and §11c (_Reviewed by_ cells are blank); `needs developer` rows: D20–D26, D28–D48 (D27 superseded by Q17). Items most worth a look: D20 with D43, D25, D26, D31, D36, D42, D45, then D5, D11–D14
- [x] Decomposed into vertical units — units.md (tcg-decomposer 2026-10-29, U1–U7; U8–U10 added during build; U11–U16 added after the prototype re-exploration, 2026-10-30 to 2026-11-03)

Answered by: Syed Haris (relayed by coordinator)  Date: 2026-10-29

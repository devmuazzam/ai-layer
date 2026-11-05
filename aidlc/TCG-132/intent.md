# Intent — TCG-132

> Captured from the Trello card (Jira/Atlassian unavailable) and the approved-prototype capture
> supplied by the requester. One intent per ticket. Nothing here is sourced from the vault yet —
> that happens in `spec.md`.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `TCG-132` (Trello card #132, https://trello.com/c/KgpBeU6P) |
| Title | Create Permit modal on All Permits, per type, with full create API |
| Type | `NOT ON TICKET` |
| Status | `NOT ON TICKET` |
| Epic | `NOT ON TICKET` |
| Sprint | `NOT ON TICKET` |
| Reporter | `NOT ON TICKET` |
| Assignee | Fouzan Shakil |
| Captured on | 2026-10-29 |
| Captured by | tcg-elaborator, from the Trello card text pasted by the requester (Syed Haris) |

Ticket state moves. Everything below is a snapshot of the ticket on *Captured on*. The card was
**not** re-read from Trello by the elaborator (no tool access); the text below is the pasted copy.

## 2. Business intent

- Intent: `NOT ON TICKET` as a business reason. The ticket asks for a UI and API change: bring
  Create Permit back on All Permits as a modal that follows the approved prototype ("TCG Whole App.html").
- Who benefits (role): `NOT ON TICKET` (the vault names the dispatcher / permit filer — Brian Petros
  files permits — see `spec.md`).
- What is worse today without it: `NOT ON TICKET`. Known from the repo (descriptive): All Permits has no
  create button (`showCreateButton={false}`), and the create API cannot carry most of the fields a permit
  has.

## 3. Definition of done, as the ticket states it

```
Bring back Create Permit on All Permits as a modal following the prototype. Types: Travel, Annual
Travel, FAA, Encroachment, Sub Hauler. Add all missing create-API fields. Origin = the yard,
Destination = the job site. Add Valid from (and Travel from/to). Assigned Planner is an employee
picker, not free text, plus Due Date. PO link on create (inline "Create new" PO). Valid till no
longer required. Annual Travel Permit added to the create catalog. Modal replaces the page flow on
All Permits; /permits/create and project/asset create pages stay untouched. No new tests.
```

- Acceptance criteria present on the ticket: **no** (the card is a description, not a checklist).
- `OPEN — ticket has no acceptance criteria; per domain/jira-sop.md it does not meet Definition of
  Ready.` Mitigation: the prototype capture (Appendix A) is the requester-approved field catalogue and
  `spec.md` takes its acceptance from it.

## 4. In scope

- [ ] "+ Create Permit" button on the All Permits hero opening a modal.
- [ ] Types in the modal: Travel, Annual Travel, FAA, Encroachment, Sub Hauler — per-type forms (Appendix A).
- [ ] Create API accepts every field the modal sends (route, travel dates, valid from, submitted/received dates, application number, FAA block, planner, due date, PO link).
- [ ] Origin = a yard; Destination = a job site.
- [ ] Valid from and Travel from/to added; Valid till no longer required.
- [ ] Assigned Planner = employee picker; Due Date.
- [ ] Inline "Create new" PO from the modal's Purchase Order field.
- [ ] Annual Travel Permit added to the create catalog.
- [ ] Record that this reverses the hide-create decision for All Permits; list vault files to update.

## 5. Out of scope

- [ ] `/permits/create`, project permit create and asset permit create pages ("stay untouched").
- [ ] New tests ("No new tests").
- [ ] Permit detail page, Mark Application Submitted / Upload Approved Permit dialogs, activity log, Track Permits kanban, Daily Allocation pre-checklist — shown in the prototype as context only (Appendix A "Related flows").
- [ ] `NOT ON TICKET` otherwise; the adjacent assumption "Track Permits also lists the new permits" is **not** stated (see `spec.md` REQ-08).

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | yes | Create DTO + `PermitsService.create` accept the missing fields; association rules; PO link on create |
| `apps/api/prisma` (schema + migration) | yes | New nullable `Permit` columns (valid from, travel from/to, origin yard, destination job site) — committed migration mandatory |
| `apps/web` (Next.js — atoms → pages) | yes | Create Permit modal on All Permits; per-type forms; planner picker; inline PO create |
| `apps/mobile` (Expo Router) | ? | Not named on the ticket; mobile reads the permit contract (additive fields only) |
| `packages/shared` (types shared across apps) | yes | Create catalog gains Annual Travel; association helpers |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `Permit` | `permitId` / minted from `entity_sequences` (`PERMIT_SEQUENCE_PREFIX`) | creates (new columns) |
| `PurchaseOrder` | `poId` | creates inline / attaches |
| `Yard` | `yardId` | reads (origin) |
| `JobSite` | `jobSiteCode` | reads (destination) |
| `Employee` | `employeeCode` | reads (assigned planner) |
| `Job`, `Asset`, `Vendor`, `Agency` | existing codes | reads |

- New entity introduced by this ticket: no
- New code prefix introduced: no
- Existing rows affected (backfill / migration of data, not just schema): no (new columns nullable) — stated by the elaborator, not the ticket; confirm at sign-off.

## 8. Roles and permissions

- Roles that can perform this: `NOT ON TICKET`
- Roles explicitly excluded: `NOT ON TICKET`
- Tenant scope: standard per-tenant isolation (assumed; `Permit` is already tenant-scoped)

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | Prototype "TCG Whole App.html", walked in Chrome 2026-10-28 by the requester; capture reproduced in Appendix A |
| Jira attachments | `NOT ON TICKET` (Jira unavailable) |
| Related tickets | `NOT ON TICKET` |
| Existing repo docs | `apps/web/src/features/permits/`, `apps/web/src/features/permits-plans/`, `apps/web/src/features/purchase-orders/`, `apps/api/src/presentation/permits/dto/`, `apps/api/src/usecase/permits/permits.service.ts` |
| Vault area the reader thinks is relevant | `decisions/2026-09-11-permit-classes-job-only-until-sept-15.md`, `decisions/2026-09-11-track-permits-job-only-until-sept-15.md`, `projects-jobs/` |

## 10. Terms used that may not be defined

- Origin / Destination — used as: "Origin = the yard, Destination = the job site."
- Valid from — "Add Valid from (and Travel from/to)." (Travel from/to vs "Travel date(s)" in the prototype)
- Annual Travel Permit — "Annual Travel Permit added to the create catalog."
- Encroachment, Sub Hauler — used without definition (defined in the vault's permit notes)
- `das` — appears in the prototype context only (Daily Allocation System).

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| Types: Travel, Annual Travel, FAA, Encroachment, Sub Hauler | The prototype ("TCG Whole App.html") |
| Notes limit 0/400 | Prototype shows "0/400"; origin `NOT ON TICKET` (the API already caps at 400: `PERMIT_NOTES_CHAR_LIMIT`) |
| Per-type required fields | The prototype's `*` marks (Appendix A) |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: Type, Status, Epic, Sprint, Reporter, business reason, roles, role exclusions, Jira attachments, related tickets (10)
- Fields left as `OPEN`: acceptance criteria (1)
- Is this ticket, as written, buildable without a product answer? **no** — a few client-facing points are
  unsourced (see `spec.md` §12).
- The blocking questions are carried into `spec.md` §12 (Q1–Q5).

---

## Appendix A — Prototype capture (verbatim from the requester's file)

Source file: the requester's walkthrough note of "TCG Whole App.html" (Chrome, 2026-10-28), with the
user's decisions of 2026-10-29. Reproduced here because the original lives in a session scratchpad.

```
# Prototype: All Permits → Create Permit (from "TCG Whole App.html", walked in Chrome 2026-10-28)

Spec source for TCG-132 (Trello #132). Labels below are the exact on-screen text.

## Entry
All Permits hero has a "+ Create Permit" button (white, top right). Opens modal
"Create Permit" / sub "Add a new permit to the system". Initially only **Type *** (select, placeholder
"Select type") and the hint "Select a permit type to see its form.". Footer: Cancel, Create Permit (blue).
Type options in order: Travel Permit, Annual Travel Permit, FAA Permit, Encroachment Permit, Sub Hauler Permit.
Changing Type resets the form (Job, PO cleared). Leaving with data shows a prompt:
"Are you sure you want to leave?" / "Do you want to save your changes before leaving?" [Cancel] [Leave] [Save].
Empty submit: required fields get a red border + message ("Vendor is required", "Purchase order is required"),
first missing dropdown opens.

## Travel Permit
Top row: Type *, Asset (search asset; optional)
JOB & LOCATION: Job / Project * (search job or project; options "JOB-00013 · Pier 400 Expansion"),
  City / Authority (search city or authority), Agency (search agency)
ROUTE: Origin (Origin address), Destination (Destination address)
SCHEDULE & VALIDITY: Travel date(s) (Select date or range), Application submitted date, Permit received date,
  Valid from, Valid to   (mm/dd/yyyy)
Purchase Order * (Search by PO number or vendor; options "PO-00521 · City of Long Beach"; footer "Create new")
COST & APPLICATION: Service fee ($ 0.00), Permit cost ($ 0.00), Application number
ATTACHMENTS: two cards "Submitted Application" (0 files) and "Final Permit" (0 files), each with
  "Upload file / Set an expiry as you add it"

## Annual Travel Permit
Top row: Type *, Asset *   (Asset required)
JOB & LOCATION: Job / Project, City / Authority, Agency   (all optional)
SCHEDULE & VALIDITY: Application submitted date, Permit received date, Valid from, Valid to   (no Route, no Travel date(s))
Purchase Order (optional)
COST & APPLICATION: Service fee, Permit cost, Application number
ATTACHMENTS: same two cards

## FAA Permit
Top row: Type *, Job *
ASSIGNMENT: Assigned Planner (placeholder "Enter planner" — user says: must be an employee picker, NOT free text), Due Date
LOCATION: Agency (Search agency), State (Select state), City (Search city)
AIRPORT: Nearest airport, Distance from airport
Purchase Order *
FLIGHT DETAILS: Latitude, Longitude, AGL, MSL, Lift window start, Lift window end,
  checkbox "Flight path confirmed with airport authority", checkbox "Crane will be lighted and flagged"
FAA FILING: NOTAM number, FAA 7460-1 submission case, Response / tracking
APPLICATION & COST: Application number, Permit cost ($ 0.00), Notes (rich text, 0/400)
ATTACHMENTS: same two cards

## Encroachment Permit
Top row: Type *, Job *
ASSIGNMENT: Assigned Planner, Due Date
LOCATION: Agency, State, City
Purchase Order *
APPLICATION & COST: Application number, Permit cost, Notes (0/400)
ATTACHMENTS: same two cards

## Sub Hauler Permit
Top row: Type *, Vendor * (options "VEN-0042 / Permit Pros", "VEN-0031 / Escort Services LA",
  "VEN-0027 / Pacific Rigging Supply", "VEN-0019 / West Coast Crane Parts")
Everything else identical to Encroachment (no Job field).

## Inline "Create new" PO (nested modal "Create PO" / "Enter PO details to authorize and track purchasing.")
PO type * (Permit), PO INFORMATION: PO number (auto-generated, read-only e.g. PO-00531), PO date *, Status chip OPEN
("Closes when an invoice is attached"), Job (preselected from permit), PO fee *, Description / purpose
PERMIT: Linked permit * ("This permit (being created)") hint "The PO fee prefills from the permit's service fee"
ATTACHMENTS & NOTES: Invoice (0 files, upload), Notes (Internal notes...)
Footer: toggle "Bill to customer" (on by default), Cancel, Create PO

## Related flows already in the prototype (context, not part of this ticket)
- Permit detail page: Edit, "Mark Application Submitted" (dialog), "Upload Approved Permit" (dialog), activity log.
- Track Permits kanban: Open → Application Submitted → Approved / Cancelled.
- Daily Allocation System job pre-checklist lists required permits per job.

## Decisions from the user (Haris, 2026-10-29)
- Prototype is the approved spec; reverses the 2026-09-11 hidden-create decision.
- Modal replaces the page flow on All Permits; /permits/create and project/asset create pages are left alone.
- Add ALL missing create-API fields. Origin = the yard, Destination = the job site. Add Valid from.
- Assigned Planner is an employee picker, not free text.
- Use the vault and best judgement for the rest; record decisions in spec §11b.
```

---

**Next step:** `spec.md` beside this file (written by the elaborator). It stops at its questions.

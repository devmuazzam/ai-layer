---
title: SCRUM-877 Labor & Unit Details — Oiler crew linking, Q1-Q9 answers
source: decision/product-owner
decided: 2026-08-21
decided_by: tcgproject12 (comments 22923, 23025, 23064, 23066) and Umair Khan, reporter of SCRUM-877 (comment 23062) — all posted directly on the SCRUM-877 Jira ticket, 2026-08-20 through 2026-08-21
status: verified
resolves: gaps.md#scrum-877-labor-and-unit-details-oiler-crew-linking
topics: [labor-payroll, field-ops-mobile, ticket-workflow, time-tracking, lunch-breaks, requirements-spec]
entities: [field-ticket, labor-record, employee, craft-code, boom-time, asset]
---

## Decision

All nine open questions logged against `SCRUM-877` ("Labor & Unit Details") in
`.ai/vault/gaps.md#scrum-877-labor-and-unit-details-oiler-crew-linking` are answered directly
on the Jira ticket, across five comments. This note records the answers verbatim, with
comment id, timestamp, and author for each, and states plainly which parts remain genuinely
unresolved after this pass.

**Provenance chain, in chronological order** (all fetched live via Atlassian MCP,
`cloudId the-crane-guys.atlassian.net`, issue `SCRUM-877`, 2026-08-21 — not taken from any
summary):

| Comment | Timestamp | Author | Content |
| --- | --- | --- | --- |
| `22923` | 2026-08-20 19:13:31 +0500 | tcgproject12 | Original clarifying comment — labor hours formula, Oiler card, tickets/labor-entry model. Already the primary source in `spec.md`. |
| `23025` | 2026-08-21 14:46:13 +0500 (edited 15:01:36) | tcgproject12 | Raises: net billable = boom + 30min/WTL; yard/travel excluded from billable but asks whether to *display* them; asks if a non-Oiler can ever see their own labor data; states craft modifiers will come from a **client-supplied reference**, not the design mockup ("limited and is incorrect"); narrows the Oiler's entry scope to "oiler and operator type employees only who work on boom"; links the reference artifact. |
| `23062` | 2026-08-21 16:42:46 +0500 | Umair Khan | Answers 23025's two questions: yes, show yard/travel in Auto-Calculated Hours; yes, non-Oilers see their own labor data, read-only. |
| `23064` | 2026-08-21 17:26:05 +0500 (edited 17:26:54) | tcgproject12 | Confirms: yard/travel time is displayed but **not** part of the net billable calculation. |
| `23066` | 2026-08-21 17:38:25 +0500 | tcgproject12 | Consolidated Q1–Q9 answer block against the elaborator's question table, plus an instruction to skip the two logged conflicts (overtime model, payroll retention). |

### Net billable hours and display of yard/travel time (comments 23025, 23062, 23064)

- Net billable hours = total boom time, plus 30 minutes for each WTL taken. (`23025`)
- Yard time and travel time are **excluded from net billable hours**. (`23025`, reconfirmed `23064`)
- Yard time and travel time **are still shown** in the Auto-Calculated Hours section of the
  Labor & Unit step, even though excluded from the net-billable figure. (`23062`, Umair Khan:
  "Should this show in the Auto-Calculated Hours section?: Yes"; `23064` confirms the display
  is cosmetic only and does not feed the calculation.)

This updates REQ-01/REQ-02 in `spec.md`: Labor Total Hours / Auto-Calculated Hours must
present boom, yard, and travel time as line items, while Net Billable Hours is computed from
boom + WTL only, never yard or travel.

### Craft modifier source — client reference, not the design mockup (comment 23025, 23066 Q5)

- `23025` (tcgproject12): "I will be using craft modifiers options supplied by client not from
  the design which is limited and is incorrect."
- `23066` Q5 names the reference explicitly: **`FMS_UNION_CRAFT_MODIFIER` (33 codes in use)** —
  boom-length brackets, not tonnage brackets. Boom-length ranges run **080–100 ft up to
  421–440 ft**. Below 80 ft, clamp to the minimum bracket's rate (keyed by employee type,
  oiler vs operator); above 440 ft, clamp to the maximum bracket's rate. The bracket/rate
  pattern is described as symmetrical. The boom rate differs for oiler vs operator.
- This **supersedes REQ-05's framing in `spec.md`**, which asked whether the axis was tonnage
  or boom length and cited the design's `BOOM_BRACKETS` table as the only precedent. The
  product owner's answer: neither the design mockup's bracket list nor a tonnage axis — the
  axis is **boom length**, and the source of truth is the client-supplied
  `FMS_UNION_CRAFT_MODIFIER` reference, linked at
  `https://claude.ai/code/artifact/74b7f0dc-34b4-4415-9839-0281ea3d7878`.
- **The actual table (all 33 codes, bracket boundaries, and rates) is not captured by this
  decision.** See *What remains unresolved* below — the artifact link does not resolve for
  this agent, twice attempted.

### Oiler's entry scope narrowed (comment 23025)

- `23025`: "oiler will be responsible for filling the labour data for oiler and operator type
  employees only who work on boom. For rest of the employee type we do not record this step
  as they do not work on the boom."
- `23066` Q5 repeats this: "The oiler is responsible for entering labor data for
  operator-type employees only."
- This **narrows** REQ-07/REQ-10's scope in `spec.md`, which described the Oiler entering data
  for "every employee in the same set." The product owner's clarification: the set may
  contain employee types (e.g. Laborer, Supervisor, agency crew) who do not work on the boom
  and for whom this step is never recorded at all. The Oiler's cards are for Oiler + Operator
  type employees in the set who work on boom — not the full set membership.

### Q1 — Overtime `[ANSWERED — scope reduced]`

`23066`: "We do not need to account for extra hours at this stage, as those will be handled
through payroll, which will be implemented in the future. For the ticket, we only need to
calculate billable hours based on boom time and lunch breaks/WLTs."

REQ-03 (overtime = work-end-time beyond shift-end-time, added to Net Billable Hours) is
**dropped from this ticket's scope**, not resolved on its merits. Net Billable Hours for
`SCRUM-877` = boom time − (30min × lunches taken) + (30min × WTLs taken). No overtime term.
Overtime/payroll pricing is explicitly deferred to the future payroll module.

### Q2 — Set-resolution mechanism `[ANSWERED]`

`23066`: "I believe the current information is sufficient... A per-day job can contain
multiple sets per shift, and each shift will have either exactly one crane or no crane, along
with an oiler and other resources such as operators, loads, and employees. We create tickets
for the employees assigned to each group. Within each set/group, the oiler-type employee's
ticket is responsible for entering the labor data for the other employees. Therefore, oiler
tickets need to be linked to the corresponding employee tickets. Once the oiler enters the
labor data, the backend should persist that data in the respective employee tickets."

**Reading this precisely, against the elaborator's own Q2 framing:** the elaborator's
question was whether `setResourceId`-based resolution (`JobTicket → JobResourceAllocation.
setResourceId → sibling allocations → sibling tickets`) is *sufficient*, or whether a new
junction/link table is required. The product owner's answer confirms the **subJob →
set/group → tickets** structure the elaborator already found ("the current information is
sufficient"), and does not ask for a new schema table. The phrase "oiler tickets need to be
linked to the corresponding employee tickets" describes the **outcome the setResourceId join
must produce** (the Oiler's write reaching each teammate's own ticket record), not a request
for a new link/junction entity. No new table is authorized by this answer. Build the
set-resolution query on `setResourceId` as the existing spec's REQ-07 notes propose.

### Q3 — "Craft Code" on the Oiler card `[ANSWERED]`

`23066`: "The **Craft** field in the Employee module maps to the **Oiler** value shown in the
mock design card."

This confirms `Employee.craftCodeId` (the "Craft" field in the Employee module,
`apps/api/prisma/schema.prisma:3516`) is the field to display, and that an Oiler-mapped craft
code value is expected to exist there. It does **not** by itself add the missing seed value —
today's seeded craft codes are `OPERATOR`/`LABORER`/`MECHANIC`/`SUPERVISOR` per
`apps/api/prisma/migrations/20260703100000_employee_craft_and_work_comp_codes/migration.sql:
82-87`; no `OILER` row exists. Whether adding that seed row is in scope for this ticket or a
separate smaller change is not stated — flagged, not decided, under *What remains
unresolved*.

### Q4 — Where the hours arithmetic runs `[ANSWERED]`

`23066`: "The billable-hours calculation should be handled on the backend. We should create a
reusable function for this logic so it can also be used later in the payroll module."

Server-side, authoritative. Must be built as a reusable function/service anticipating reuse
by the future payroll module — not a client-side display convenience, and not a one-off
inlined into this ticket's endpoint.

### Q5 — Craft Modifier / Boom Pay ranges and rates `[PARTIALLY ANSWERED]`

Mechanism and axis answered (see *Craft modifier source* above: boom-length brackets,
080–100 ft to 421–440 ft, oiler vs operator rates differ, symmetrical pattern, clamp beyond
range to nearest bracket). **The literal 33-code rate table is not captured here** — the
referenced artifact does not resolve for this agent. See *What remains unresolved*.

### Q6 — `Asset.capacity` numeric `[ANSWERED]`

`23066`: "The **Asset Capacity** field, which stores the tonnage value, should be numeric and
should accept decimal values."

`Asset.capacity` (`apps/api/prisma/schema.prisma:707`, currently `String? @db.VarChar(50)`)
is confirmed to become a numeric/decimal type. This is a tonnage field, not a boom-length
field — boom length (the actual craft-modifier axis per Q5) is a separate, still-unlocated
concept; converting `capacity` to numeric does not by itself supply a boom-length field for
bracket matching. Flagged under *What remains unresolved*.

### Q7 — The two unreadable attachment images `[STILL UNRESOLVED FOR THIS AGENT]`

`23066`: "I have attached the relevant images." The images referenced are almost certainly
attachments `12450` and `12449` (`image-20260820-131819.png`, `image-20260820-132954.png`),
already logged as inaccessible in `spec.md` (HTTP 403 on direct attachment fetch). This
decision-writing pass has no image-viewing tool available and did not attempt the fetch again
— the product owner confirming "I have attached the relevant images" does not make them
readable to an agent without image access. **Still open** — see *What remains unresolved*.

### Q8 — Labor Classification list completeness `[EXPLICITLY DEFERRED, NOT ANSWERED]`

`23066`: "Skip this point."

This is a deferral, not an answer. REQ-11 in `spec.md` remains `NOT SPECIFIED` for exactly
the reason already stated there (the four named values are undocumented anywhere else) — this
decision does not newly specify them or assert they are exhaustive. Treat Q8 as still open for
build purposes; the product owner has only declined to resolve it now.

### Q9 — Can a non-Oiler see their own labor data, read-only? `[ANSWERED — YES, no contradiction found]`

The task that produced this note was briefed with a premise that comment `23066`'s Q9 answer
("Not required for now") contradicts the later comment `23062` ("Yes"), and asked this note to
resolve that contradiction by timestamp. **On direct verification against the live ticket,
that premise is incorrect and the contradiction does not exist:**

- `23025` (tcgproject12, 2026-08-21 14:46) asks: "Can a non-Oiler ever see their own labor
  data, even read-only?"
- `23062` (Umair Khan, 2026-08-21 16:42): "Can a non-Oiler see their own labor data read-only?:
  They should see for read only" — **Yes.**
- `23066` (tcgproject12, 2026-08-21 17:38), in the consolidated Q1–Q9 block: **"Q9: Yes"** —
  not "Not required for now." The verbatim text of `23066` as fetched from the live ticket
  reads "Q9: Yes," immediately followed by "Please also skip the conflict-related point."

Both comments agree: a non-Oiler employee can see their own Labor/Unit data, read-only, even
though their ticket carries no Labor/Unit *entry* step (which remains Oiler-only per REQ-06).
This resolves Q9 cleanly with **no self-correction, no stale copy-paste, and no timestamp
ordering issue to adjudicate** — the apparent contradiction existed only in how this task was
briefed, not in the ticket. Anyone relying on a summary of this thread rather than the live
comments should be corrected on this point.

### Conflicts REQ-03 and REQ-14 — explicitly skipped, not resolved (comment 23066, final line)

`23066`, final line: "Please also skip the conflict-related point. Payroll has not been
implemented yet, so any payroll-related requirements will be addressed as part of the payroll
module in the future."

This applies to both logged conflicts:

- **REQ-03 / gaps.md sub-question 1 (overtime model)** — moot per Q1 above: no overtime
  calculation is in scope for this ticket at all, so the field-ops-vs-payroll overtime-model
  conflict has nothing to adjudicate right now. It is **deferred**, not decided in either
  direction — when the payroll module is built, the question of which system owns overtime
  pricing will need to be asked again on its own terms.
- **REQ-14 / the pre-existing `payroll/gaps.md#field-ops-lunch-capture-vs-payroll-wtl` conflict
  (payroll retention / WTL threshold mismatch)** — also deferred. The product owner's
  instruction is to not resolve the field-ops-vs-payroll lunch/WTL threshold disagreement as
  part of this ticket. **This decision does not close
  `payroll/gaps.md#field-ops-lunch-capture-vs-payroll-wtl`** — that gap is independently
  logged, is a payroll-domain gap (this agent's write access there is via
  `.ai/vault/payroll/gaps.md`, not touched by this note), and remains open on its own record.
  SCRUM-877 simply proceeds without resolving it: Labor Total Hours / Net Billable Hours are
  computed per this ticket's own stated formula (boom + WTL×30min; boom − lunch×30min +
  WTL×30min), understood as a field-ops-local figure that may not equal whatever payroll's
  future engine eventually computes from the same raw data. That mismatch risk is accepted,
  not eliminated, by deferring rather than resolving.

## Why

The product owner answered fast and directly on the ticket rather than through a formal
adjudication process, which is exactly the channel `.ai/vault/gaps.md` questions are meant to
route back to. Two things made this pass necessary rather than a simple copy-paste into
`spec.md`:

1. **Verifying against the live thread caught a wrong premise.** The task was framed around a
   Q9 self-contradiction that turned out not to exist once the actual comment text was read.
   Had this note trusted the framing instead of the live ticket, it would have manufactured a
   contradiction and "resolved" it by fiat — itself a fabrication, just a smaller one. This is
   the same failure mode this role exists to prevent: an authoritative-sounding resolution of
   a disagreement that was never actually there.
2. **Not every answer is a clean yes/no.** Q1 and Q8 are explicit deferrals ("we don't need
   this now," "skip this point"), not resolutions of the underlying question — they narrow
   *this ticket's* scope without asserting an answer to the general product question (does
   field-ops or payroll own overtime pricing? is the four-item classification list complete?).
   Recording them as "answered" would let a future ticket treat these as settled when they are
   not; recording them precisely as "scope reduced" or "deferred" preserves the distinction.
3. **The rate table and the attachment images are still not actually in hand.** The product
   owner named a specific source (`FMS_UNION_CRAFT_MODIFIER`, 33 codes) and pointed at it
   twice, but the link this agent was given does not resolve for this agent's tooling (public
   non-member reader, confirmed on two attempts, 2026-08-21). Writing down "boom-length
   brackets, 080–100 ft to 421–440 ft, symmetrical, oiler/operator differ" is everything
   verifiable from the ticket text; inventing the 33 rate values to fill the gap would be
   exactly the fabrication this role must not commit, even though the shape of the answer is
   now known.

## Effect on the vault

- **No vault document `status:`/`conflicts_with:`/`superseded_by:` frontmatter changes.** This
  decision does not resolve a conflict *between two vault documents* — it resolves open
  questions raised while elaborating a ticket, and a product-owner instruction to defer two
  previously-logged conflicts. No vault file names another vault file as superseded by this
  decision. This mirrors `decisions/2026-08-12-plan-comments-page-scope.md`'s precedent: "no
  winner/loser flip applies" when the gap did not originate as a conflict set between vault
  files. Checked and confirmed: no vault file's `conflicts_with:` field points at
  `gaps.md#scrum-877-labor-and-unit-details-oiler-crew-linking` (only `gaps.md` itself does).
- **`product/frd-new-format-draft/08-open-questions.md` item 10** ("Should boom pay modifier be
  system-selected, user-selected, or system-suggested with user override? — Owner: Corrina +
  Brian — Status: Open") is now answered in substance by this decision (system-suggested by
  boom length, with employee override, per `23025`/`23066` Q5) — **but this is a body edit to
  a vault file (a table row inside a numbered FRD section), which this role has no write
  access to.** The file's own owners (Corrina, Brian) or a human with body-edit rights should
  update that row; this decision note is the citable source for doing so. Not edited here.
- **`gaps.md#scrum-877-labor-and-unit-details-oiler-crew-linking`** → to be marked
  `Status: resolved — see decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md`
  by whoever next touches that file. **Per this agent's task brief, `gaps.md` is explicitly
  reserved for the elaborator's next pass, not edited by this note** — this is a deliberate
  departure from the standard four-step closure (which would have this agent update `gaps.md`
  directly) because the requesting agent asked for the elaborator to make that edit alongside
  the corresponding `spec.md` rewrite, in one pass, so the two files change together. Recorded
  here so the next agent does not need to re-derive it: **the gaps.md entry is not yet marked
  resolved as of this note.**

## What remains unresolved after this decision

State this plainly rather than treating the ticket as fully unblocked:

1. **The actual `FMS_UNION_CRAFT_MODIFIER` table — all 33 codes, bracket boundaries, and
   oiler/operator rates — is not captured anywhere in the vault or this note.** The reference
   artifact (`https://claude.ai/code/artifact/74b7f0dc-34b4-4415-9839-0281ea3d7878`) failed on
   two fetch attempts by this agent, both returning: "this artifact is served to you as a
   public (non-member) reader, and reading public artifacts that way is not enabled yet."
   Someone with member-level access to that artifact (likely tcgproject12, who linked it) needs
   to either paste the table into the ticket as text, re-share it with broader access, or
   attach it to the ticket directly. REQ-05/REQ-08 in `spec.md` remain schema/data-blocking
   until this table is actually in hand — the *mechanism* is now known, the *values* are not.
2. **The two Jira attachment images (`12450`, `12449`) are still not viewable by this agent.**
   The product owner's "I have attached the relevant images" confirms they exist and are
   attached, but does not make them readable through Atlassian MCP (still 403 on direct
   attachment content access, per `spec.md`'s prior finding — not re-attempted in this pass
   since no new tool became available). Whoever can open the ticket in a browser should
   describe or re-post their content as text.
3. **Whether adding an `OILER` seed value to `EmployeeCraftCode` is in scope for this ticket**
   is not stated by Q3's answer — it confirms which field to read, not whether the missing seed
   row should be added now or separately.
4. **The general product questions behind Q1 and Q8 are not answered, only deferred for this
   ticket.** Do not cite this decision as settling "who owns overtime pricing, field-ops or
   payroll" or "is the Labor Classification list exhaustive" for any other ticket.
5. **`payroll/gaps.md#field-ops-lunch-capture-vs-payroll-wtl` remains independently open.** This
   decision defers around it for `SCRUM-877`; it does not close it.

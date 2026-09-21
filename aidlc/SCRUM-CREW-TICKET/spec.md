# Spec — SCRUM-CREW-TICKET One ticket per asset group — Oiler primary, Operator on the same ticket

> Written to `.ai/aidlc/SCRUM-CREW-TICKET/spec.md` by the elaborator
> (`.ai/aidlc/agents/inception/tcg-elaborator.md`) from `intent.md` beside it.
>
> This is the document an executor builds from. **Every requirement in it carries its
> sources, and every source carries its status.** A requirement with no source is not a
> requirement — it is an open question, and it stays marked as one.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-CREW-TICKET` — no Jira issue; folder name only (`grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md` is the device that still finds it) |
| Intent | `.ai/aidlc/SCRUM-CREW-TICKET/intent.md`, captured `2026-09-14` |
| Elaborated on | `2026-09-14` |
| Vault state at elaboration | `field-ops/gaps.md` (68,718 bytes; read lines 216–340 only, per the assignment) shows *Who fills the ticket* as `resolved 2026-09-14`. Two `[VERIFIED]` decision notes now back this spec: `vault/decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` (the product rule) and `vault/decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` (the engineering shape under it, folded in this pass), alongside the six `domain/` files (not consulted — out of this ticket's area). Everything else cited below is `[UNVERIFIED]`. |
| Open questions raised by this spec | 5 raised — Q1–Q4 resolved 2026-09-14 (folded into REQ text below); Q5 (non-blocking residual on Q3) remains `open`, owner Wes Staley + client |
| Already-shipped behaviour reached | 10 existing consumers in §11a — all now have a source for what happens to them; the 3 that depended on Q1 are resolved by `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` |
| Rules consulted | `.ai/claude/contexts/api.md`, `.ai/claude/contexts/prisma.md`, `.ai/claude/contexts/mobile.md`, `.ai/claude/contexts/web.md`, `.ai/claude/contexts/payroll-engine.md` (grepped for `ticket`/`labor` — one hit, unrelated to this rule set: audit item A7 rest-forcing) |

No Jira ticket exists to re-diff against (`intent.md` §1: "no Jira issue; folder name only"). The
verbatim requester quote in `intent.md` §3 is this session's own capture, not a snapshot of a
ticket that could have moved since — nothing to re-diff there either.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | One `JobTicket` per asset group per day, not per employee — keyed by the primary's allocation | schema / api | `[VERIFIED]` | `decisions/2026-09-14-…oiler-fills-it.md`, `decisions/2026-09-14-crew-ticket-shape-….md` | no |
| REQ-02 | Ticket carries its employees with exactly one primary, by seat | schema / api | `[VERIFIED]` | `decisions/2026-09-14-…oiler-fills-it.md`, `decisions/2026-09-14-crew-ticket-shape-….md` | no |
| REQ-03 | Secondary employee (Operator) has no ticket actions of their own | api / mobile | `[VERIFIED]` | `decisions/2026-09-14-…oiler-fills-it.md` | no |
| REQ-04 | Operator's labor is a separate labor record on the same ticket, entered by the Oiler | api | `[VERIFIED]` | `decisions/2026-09-14-…oiler-fills-it.md`, `decisions/2026-09-14-crew-ticket-shape-….md` | no |
| REQ-05 | Mobile: Oiler's ticket shows both crew members; Oiler enters time/Labor & Unit for each | mobile | `[UNVERIFIED]` | `SCRUM-CREW-TICKET/intent.md` §4 | no |
| REQ-06 | Mobile: Operator's Jobs/Home shows "On <Oiler>'s ticket" with status/progress only; PR #561 banner replaced | mobile | `[VERIFIED]` | `decisions/2026-09-14-crew-ticket-shape-….md` (Q3) | no |
| REQ-07 | Web Progress Tracking: one row per ticket, employees listed, primary marked | web / shared | `[UNVERIFIED]` | `SCRUM-CREW-TICKET/intent.md` §4 | no |
| REQ-08 | DAS/dispatch ticket-listing views: one row per ticket; employees listed where people are listed | web | `[UNVERIFIED]` | `SCRUM-CREW-TICKET/intent.md` §4 | no |
| REQ-09 | Retire `JobTicket.primaryTicketId` and `linkCrewTickets` | schema / api | `[VERIFIED]` | `decisions/2026-09-14-…oiler-fills-it.md`, `decisions/2026-09-14-crew-ticket-shape-….md` | no |
| REQ-10 | Migrate live (PENDING/SENT/IN_PROGRESS) linked pairs into one ticket + `ticket_employees` | schema | `[VERIFIED]` | `decisions/2026-09-14-crew-ticket-shape-….md` (Q2) | no |
| REQ-11 | Payroll prices one row per ticket-employee; `PayrollJobDay` key widens to include the employee | api | `[VERIFIED]` | `decisions/2026-09-14-crew-ticket-shape-….md` (Q1) | no |
| REQ-12 | Support / counterweight loads: unaffected — each its own asset group and ticket | schema / api | `[VERIFIED]` | `decisions/2026-09-14-…oiler-fills-it.md`, `decisions/2026-09-14-crew-ticket-shape-….md` | no |
| REQ-13 | New `ticket_employees` join entity — roster, primary flag, and the four Labor & Unit fields moved off `JobTicket` | schema | `[VERIFIED]` | `decisions/2026-09-14-crew-ticket-shape-….md` (Q1) | no |
| REQ-14 | Per-employee time & labor keying: `ticket_employees` holds labor; `TicketTimeEntry` stays shared/per-ticket | schema | `[VERIFIED]` | `decisions/2026-09-14-crew-ticket-shape-….md` (Q1) | no |
| REQ-15 | COMPLETE linked-pair migration treatment: keep as two rows, each backfilled `isPrimary=true` | schema | `[VERIFIED]` | `decisions/2026-09-14-crew-ticket-shape-….md` (Q2) | no |
| REQ-16 | Operator visibility on the shared ticket: step status only (default); richer view is residual Q5 | mobile / api | `[VERIFIED]` | `decisions/2026-09-14-crew-ticket-shape-….md` (Q3) | no |
| REQ-17 | Ticket keyed by the primary employee's allocation — no asset-group entity needed | schema / api | `[VERIFIED]` | `decisions/2026-09-14-crew-ticket-shape-….md` (Q4) | no |

Counts: `17` total — `14` verified, `3` unverified, `0` conflicted, `0` open. One non-blocking
residual remains in §12 (Q5, `Status: open`, owner Wes Staley + client) — it raises no `[OPEN]`
requirement of its own; REQ-16 already ships its default.

## 2. Requirements

### REQ-01 — One `JobTicket` per asset group per day, keyed by the primary's allocation `[VERIFIED]`

- **Statement:** A `JobTicket` is minted once per asset group per scheduled day, not once per
  allocated person. The ticket is keyed by `allocationId`, unchanged — but within one
  `(subJobId, setResourceId, shiftNumber)`, if a personnel allocation with an Oiler seat exists,
  that allocation's ticket **is** the asset group's ticket, and the Operator's allocation in the
  same set gets no ticket of its own (it is absorbed as a `ticket_employees` row — REQ-13). Every
  other personnel allocation — an Operator with no Oiler seat, a Third Man, every
  support/counterweight-load driver — still gets its own ticket, exactly as today. This
  reproduces the sheet's "one ticket per asset group" outcome without introducing an
  asset-group entity (REQ-17).
- **Surface:** schema, api
- **Sources:**
  - `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` — `[VERIFIED]` —
    kind: decision — Decision point 1, quoting the approved sheet verbatim: *"Asset
    'grouping' is either the 'main' mobile crane (with primary tractor/trailor) or additional
    tractor/trailer combo (one ticket per 'day'… where 'day' can extend past midnight)."*
  - `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` —
    `[VERIFIED]` — kind: decision — Q4: *"`JobTicket.allocationId` stays the ticket's anchor. No
    asset-group entity is introduced… if a personnel allocation with an Oiler seat exists, that
    allocation's ticket is the crew ticket, and the Operator's allocation in the same set is
    absorbed as a second ticket-employee on it — no ticket is minted for the Operator's
    allocation."*
- **Conflict:** none
- **Open question:** none — Q4 (REQ-17) is resolved: the DAS-`set`-to-asset-group mapping the
  elaborator originally asked about turned out not to need answering, since the ticket is keyed
  by the filler's own allocation, not by the set.
- **Ripple:** see §11a rows 1–3, 6, 8 — every path that mints or lists tickets assumes one
  ticket per allocated person today (`apps/api/src/usecase/job-tickets/job-tickets.service.ts`
  `ensureTickets`, `sendTickets`, `reassignTicket` — each loops
  `subJob.resourceAllocations`/allocations and creates one ticket per row). Under the settled
  shape, these loops still iterate allocations, but must skip minting for an Operator allocation
  once an Oiler allocation is found in the same `(subJobId, setResourceId, shiftNumber)`.
- **Acceptance:** For a sub-job with an Oiler + Operator crane set and two support loads,
  exactly 3 `JobTicket` rows exist (crane set, load 1, load 2), never 4; the crane set's
  `allocationId` is the Oiler's own allocation.
- **Notes for the executor:** `ensureTickets`/`sendTickets`/`reassignTicket` all currently key
  ticket creation off `alloc.id` (one allocation = one ticket) — that stays true, with the added
  rule that an Operator allocation in an Oiler-seated set is looked up (via `linkCrewTickets`'s
  existing `(subJobId, setResourceId, shiftNumber)` + `seatOf` pattern) and absorbed instead of
  minted. The partial unique index "at most one non-CANCELLED ticket per allocation"
  (`uq_job_tickets_active_allocation`) is unchanged and stays true under this rule.

### REQ-02 — Ticket carries its employees, exactly one primary `[VERIFIED]`

- **Statement:** A ticket carries one or more employees. Exactly one is primary, determined by
  the seat on the allocation, not by crane tonnage: an Oiler seat on the set makes the Oiler
  primary and the Operator secondary on the same ticket; a set with no Oiler seat makes the
  Operator primary, alone; a support/counterweight load's driver (3rd man / rigger) is primary,
  alone, on that load's own ticket.
- **Surface:** schema, api
- **Sources:**
  - `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` — `[VERIFIED]` —
    kind: decision — Decision points 2, 3, 4, each citing the approved sheet's per-row
    *Fills In-Completes Ticket* column.
  - `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` —
    `[VERIFIED]` — kind: decision — Q1 point 2: *"Exactly one `isPrimary = true` per ticket,
    enforced by a partial unique index on `(jobTicketId) WHERE is_primary`."*
- **Conflict:** none
- **Open question:** none — the determination rule itself is settled, and the schema field that
  records "primary" is now settled too (REQ-13: `ticket_employees.isPrimary`, partial unique
  index). The reassignment/change-of-Oiler-mid-day re-derivation logic is `NOT SPECIFIED` beyond
  "re-links the same way it does today" (`linkCrewTickets`'s existing idempotent re-grouping,
  cited descriptively as `code`).
- **Ripple:** §11a rows 1, 2 — `linkCrewTickets`'s existing seat-detection logic
  (`seatOf`, comparing `OILER_TYPE_NAME`/`OPERATOR_TYPE_NAME`) is the direct precedent for the
  new primary-determination code path; it already re-runs after every ticket-creating action
  (ensure, send, reassignment) for exactly this reason.
- **Acceptance:** Given an allocation set with Oiler + Operator seats filled, the ticket's
  primary employee is the Oiler; given the same set with only the Operator seat filled, the
  ticket's primary is the Operator.
- **Notes for the executor:** `OILER_TYPE_NAME` / `OPERATOR_TYPE_NAME` from
  `packages/shared/src/constants/employee-types.ts` are the existing seat-name constants;
  reuse them rather than re-deriving.

### REQ-03 — Secondary employee has no ticket actions of their own `[VERIFIED]`

- **Statement:** A secondary employee (the Operator on a crew ticket) has no accept, start,
  step, signature or submit action of their own. The primary's WTL authorization covers the
  crew. The secondary can read their own crew ticket's status.
- **Surface:** api, mobile
- **Sources:**
  - `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` — `[VERIFIED]` —
    kind: decision — Decision point 2 ("no fill, complete, sign or submit step of their own")
    and point 5, answering FR-TCG-FOP-001 open question 11 as "no active Operator step,"
    sourced to Melissa McNutt 2026-06-04 15:55.
- **Conflict:** none
- **Open question:** none for the write/no-write rule. What the secondary *can read* beyond
  status (signatures, checklists, comments) is Q3 (REQ-16).
- **Ripple:** §11a row 2 — `getTicketForEmployeeAction`
  (`apps/api/src/usecase/job-tickets/job-tickets.service.ts:925`) already implements exactly
  this shape today for the crew-copy: `access === 'write' && ticket.primaryTicketId` throws
  `ForbiddenException('This is a crew ticket — the Oiler completes it; your copy is
  read-only')`. The authorization rule carries forward unchanged in substance; only the check
  itself moves from "does this ticket have a `primaryTicketId`" to "is this employee the
  ticket's primary, per the new join."
- **Acceptance:** An Operator's session cannot call any write-classified `field/tickets/:id/*`
  action against the crew ticket; a read of the ticket succeeds and shows status only (pending
  Q3 for anything beyond status).
- **Notes for the executor:** Reuse `getTicketForEmployeeAction`'s `access: 'read' | 'write'`
  parameter shape — it is already the sanctioned authorization chokepoint other modules
  (checklist assignments) call through, per its own docblock.

### REQ-04 — Operator's labor is a separate labor record on the same ticket `[VERIFIED]`

- **Statement:** The Operator's labor is captured as a labor record distinct from the Oiler's,
  on the same ticket. The Oiler enters it, selecting which employee an entry is for.
- **Surface:** api
- **Sources:**
  - `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` — `[VERIFIED]` —
    kind: decision — Decision point 2: *"a **separate labor record** that the Oiler enters
    (the Oiler selects which employee an entry is for)"*, citing Brian Petros 2026-05-21 8:59,
    9:27 ("there's a separate field").
  - `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` —
    `[VERIFIED]` — kind: decision — Q1 point 1: the four Labor & Unit fields
    (`craftModifierBracket`, `craftModifierId`, `laborComments`, `laborCapturedByUserId`) move
    off `JobTicket` onto the new `ticket_employees` row, one per employee.
- **Conflict:** none
- **Open question:** none — Q1 (REQ-14) is resolved: the "separate labor record" is a
  `ticket_employees` row per employee, carrying those four fields.
- **Ripple:** §11a rows 4, 5, 9 — `RecordTicketLaborEntryDto.targetEmployeeId` already models
  "the Oiler passes a boom-working teammate's employeeId" (`record-ticket-labor-entry.dto.ts`);
  `resolveTargetTicket`
  (`apps/api/src/usecase/ticket-labor-entries/ticket-labor-entries.service.ts:584`) resolves
  that today to the **teammate's own separate ticket** — the shape this ticket retires. Per the
  decision, the mechanism (Oiler picks the target employee, server authorizes via
  `setResourceId`) is reused unchanged; only its target changes, from "a different ticket" to
  "the target employee's own `ticket_employees` row on this ticket."
- **Acceptance:** The Oiler can submit a Labor & Unit entry with `targetEmployeeId` set to the
  Operator's employee id, and it is stored and readable as the Operator's own entry, not the
  Oiler's.
- **Notes for the executor:** `getCrewForTicket`'s crew-card-list shape (Oiler's own card plus
  every boom-working teammate, `ticket-labor-entries.service.ts:254`) is very close to the
  target read shape for REQ-05 already — it is currently built by querying across separate
  ticket rows and needs to become a query across ticket-employees on the one ticket.

### REQ-05 — Mobile: Oiler's ticket shows both crew members; enters time/labor for each `[UNVERIFIED]`

- **Statement:** On the mobile field app, the Oiler's ticket screen shows both crew members
  and lets the Oiler enter time and Labor & Unit data for each.
- **Surface:** mobile
- **Sources:**
  - `SCRUM-CREW-TICKET/intent.md` §4 — `[UNVERIFIED]` — kind: jira (session capture, no Jira
    issue) — *"Mobile (`apps/mobile` field persona): the Oiler's ticket shows both crew
    members and lets the Oiler enter time / Labor & Unit for each."*
  - Supported in substance (not UI specifics) by
    `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` — `[VERIFIED]` —
    kind: decision — point 2.
- **Conflict:** none
- **Open question:** none blocking — the crew-card list UI already exists in substance
  (`getCrewForTicket`); the exact screen layout is `NOT SPECIFIED` beyond "both members visible,
  entry per member."
- **Ripple:** §11a row 5 — `apps/mobile/app/(field)/ticket/step/[key].tsx` already renders
  `crew={laborCrewQuery.data ?? []}` from `getCrewForTicket`'s response shape; the data source
  changes (same-ticket join instead of cross-ticket lookup) but the rendering contract may not
  need to.
- **Acceptance:** The Oiler's Labor step shows two crew cards (Oiler + Operator) when both are
  on the ticket, one when only the Operator seat is filled (Operator primary, no Oiler).
- **Notes for the executor:** `apps/mobile/data/compose-ticket-detail.ts`'s `getVisibleSteps`
  gates which of the 14 steps show for the Oiler flow vs the 9-step flow for everyone else —
  unchanged by this ticket (intent §5, out of scope: "Any change to the 14-step / 9-step step
  set itself").

### REQ-06 — Mobile: Operator's Jobs/Home shows "On \<Oiler\>'s ticket" with status only `[VERIFIED]`

- **Statement:** The Operator's Jobs list and Home screen show the crew ticket as **"On
  \<Oiler name\>'s ticket"**, with the ticket's progress/step status only — not as a ticket
  assigned to them with its own accept/view-ticket flow, and not with signatures, checklists,
  comments, punch-in or accept. The crew-copy banner and *View ticket* CTA shape from PR #561
  (`apps/mobile/components/field/crew-ticket-banner.tsx`, merged 2026-09-12) is replaced by
  this, not kept.
- **Surface:** mobile
- **Sources:**
  - `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` —
    `[VERIFIED]` — kind: decision — Q3: *"The Operator's mobile Jobs list / Home shows the crew
    ticket as 'On \<Oiler\>'s ticket' with the ticket's progress / step status only — no
    signatures, no checklists, no comments, no punch-in, no accept… The crew-copy banner + View
    ticket CTA shape from PR #561 … is replaced by this, not kept."* Flagged there as a
    requester **default** (no written source says more), not a client answer — see REQ-16 / Q5.
  - `SCRUM-CREW-TICKET/intent.md` §4 — `[UNVERIFIED]` — kind: jira — original framing this
    decision confirms and makes concrete.
  - `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` — `[VERIFIED]` —
    kind: decision — points 2, 5 (no active Operator step).
- **Conflict:** none
- **Open question:** none blocking. The richer-view residual is Q5 (REQ-16), non-blocking — the
  default above is what ships.
- **Ripple:** §11a rows 2, 8 — `apps/mobile/components/field/crew-ticket-banner.tsx` (retired
  per the decision above), `apps/mobile/app/(field)/ticket/index.tsx`'s `crewCopy` /
  `isReadOnlyTicket` logic (reads `crewTicket?.role === 'SECONDARY'`), and `useTickets()` /
  `listMyTickets` (`job-tickets.service.ts:449`) which today returns one ticket row per
  employee (including the Operator's own SECONDARY copy) — the Operator's mobile session needs
  to resolve "the ticket I'm on" from a `ticket_employees` membership, not from "a ticket whose
  `employeeId` is mine."
- **Acceptance:** An Operator on a crew ticket sees exactly one ticket in their Jobs list for
  that day, labeled "On \<Oiler name\>'s ticket," showing progress/status only — no "View
  ticket" hand-off UI, no signatures/checklists/comments, no accept.
- **Notes for the executor:** `FieldTicketCrew` (`field-ticket.mapper.ts`)'s
  `{ role: 'PRIMARY' | 'SECONDARY' }` discriminated shape is the direct precedent to retire and
  replace with an `employees: [{ employeeId, name, isPrimary }]` shape (mirrors the pattern
  `JobResourceAllocation`'s `assigneeType` + typed-FK discrimination already uses elsewhere in
  this schema).

### REQ-07 — Web Progress Tracking: one row per ticket, employees listed, primary marked `[UNVERIFIED]`

- **Statement:** Web Job/Progress Tracking shows one row per ticket per asset group, listing
  that ticket's employees with the primary marked, and the 14-step Oiler flow on the crew
  ticket. No "copy" rows.
- **Surface:** web, shared
- **Sources:**
  - `SCRUM-CREW-TICKET/intent.md` §4 — `[UNVERIFIED]` — kind: jira — *"Web Job Tracking /
    Progress Tracking (…): one row per ticket per asset group, listing its employees, primary
    marked; the 14-step Oiler flow on the crew ticket; no 'copy' rows."*
- **Conflict:** none
- **Open question:** none blocking — Q4 resolved (REQ-17: the ticket is keyed by the primary's
  allocation, so "one asset group" needs no separate grouping construct for display purposes;
  render each ticket's `ticket_employees` roster). Q5 (REQ-16's residual) bears on what a
  non-primary employee's card shows beyond status within the row, non-blocking.
- **Ripple:** §11a rows 7, 10 — `apps/web/src/features/ticket-progress/` currently renders
  `ticket.person` (singular) per ticket
  (`components/crew-identity.tsx`, `components/action-buttons.tsx`,
  `components/ticket-banners.tsx`), and `job-progress.service.ts`'s `summaryCaptures` /
  `detailCaptures` (`ticket.primaryTicket ?? ticket`) is exactly the mechanism this replaces —
  today the Operator's copy ticket reads the Oiler's captures because it is a *separate* ticket
  row pointed at the primary; once there is one physical ticket, this indirection disappears
  and `ProgressTicketSummary.person` (singular, `packages/shared/src/types/job-progress.types.ts:139`)
  needs to become a plural `employees[]`.
- **Acceptance:** A crew's Progress Tracking board shows one card for the crane-set ticket
  (with Oiler marked primary and Operator listed), not two cards.
- **Notes for the executor:** `ProgressTicketSummary.role` (singular, line 141) has the same
  problem — it currently reads one role off one person per ticket.

### REQ-08 — DAS/dispatch ticket-listing views: one row per asset group `[UNVERIFIED]`

- **Statement:** DAS / dispatch views that list tickets show one row per asset group; where
  they list people, they list the ticket's employees.
- **Surface:** web
- **Sources:**
  - `SCRUM-CREW-TICKET/intent.md` §4 — `[UNVERIFIED]` — kind: jira — *"DAS / dispatch views
    that list tickets: one ticket per asset group; where they list people, list the ticket's
    employees."*
- **Conflict:** none
- **Open question:** none blocking — Q4 resolved (REQ-17), same as REQ-07.
- **Ripple:** §11a row 6 — `apps/web/src/features/das/middle-section/jobs/tickets/components/send-ticket-modal.tsx`
  builds `tableRows` one per `t.allocationId`/`t.employeeName` from `EnsuredTicketRow[]`
  (`job-tickets.service.ts` `ensureTickets`'s return shape); `use-ensure-tickets.ts` and
  `das-allocations.service.ts` (the web service, not the API usecase) consume the same shape.
- **Acceptance:** The "Confirm & Send Tickets" DAS modal shows one row for a crane set with an
  Oiler and Operator seated, not two.
- **Notes for the executor:** `EnsuredTicketRow` (`job-tickets.service.ts`) is the response
  type to change; it currently has one `employeeName: string` field per row.

### REQ-09 — Retire `JobTicket.primaryTicketId` and `linkCrewTickets` `[VERIFIED]`

- **Statement:** The `primaryTicketId` self-FK on `JobTicket` and the `linkCrewTickets`
  read-only-copy mirroring mechanism are retired.
- **Surface:** schema, api
- **Sources:**
  - `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` — `[VERIFIED]` —
    kind: decision — *"What this supersedes in the code"*: names `JobTicket.primaryTicketId`
    (`apps/api/prisma/schema.prisma:4514`) and `linkCrewTickets`
    (`job-tickets.service.ts:960`) explicitly as "the parts to retire."
  - `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` —
    `[VERIFIED]` — kind: decision — Q2 point 1: the Operator's ticket is retired under existing
    cancel semantics, then `primaryTicketId` is dropped.
- **Conflict:** none
- **Open question:** none — the retirement itself and the migration mechanics for existing rows
  are both now settled: REQ-10 (live pairs) and REQ-15 (COMPLETE pairs).
- **Ripple:** §11a row 2 (full list of `primaryTicketId`/`linkCrewTickets` consumers, from
  `grep -rln "primaryTicketId\|linkCrewTickets" apps/api/src apps/web/src apps/mobile
  packages/shared/src qa-automation`): `ticket-time-entries.repository.ts`,
  `job-progress.repository.ts`, `job-tickets.repository.ts`, `job-progress.service.ts`,
  `job-tickets.service.spec.ts`, `job-tickets.service.ts`, `field-ticket.mapper.spec.ts`,
  `field-ticket.mapper.ts`, `apps/mobile/components/field/ticket-card.test.tsx`,
  `apps/mobile/data/contracts/ticket.contract.ts` (Zod schema field
  `primaryTicketId: z.string()`). `qa-automation/e2e` has **no matches** — established by the
  same grep returning nothing under that path — so no E2E test needs rewriting for this
  specifically, though new E2E coverage for the new shape is a §10 gap.
- **Acceptance:** `git grep -n "primaryTicketId\|linkCrewTickets"` under `apps/` returns
  nothing outside historical migration files after this ships.
- **Notes for the executor:** The migration `20260912120000_add_job_ticket_primary_ticket`
  stays in history (never edit a merged migration); the new migration adds the retiring
  `DROP COLUMN`/`DROP CONSTRAINT` alongside whatever REQ-13/REQ-14 introduce.

### REQ-10 — Migrate live (PENDING/SENT/IN_PROGRESS) linked pairs into one ticket + `ticket_employees` `[VERIFIED]`

- **Statement:** A data migration collapses only PENDING/SENT/IN_PROGRESS linked pairs
  (an Operator ticket with `primaryTicketId` set) into the Oiler's ticket: create the Operator's
  `ticket_employees` row on the Oiler's ticket, carrying that Operator ticket's own Labor &
  Unit fields (`craftModifierBracket`, `craftModifierId`, `laborComments`,
  `laborCapturedByUserId`); retire the Operator's ticket under the **existing cancel
  semantics** (status `CANCELLED`, same as a reassignment does today, so the partial unique
  index is satisfied and history is kept); then drop `primaryTicketId`. COMPLETE pairs are out
  of scope for this migration — see REQ-15.
- **Surface:** schema
- **Sources:**
  - `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` —
    `[VERIFIED]` — kind: decision — Q2 point 1, verbatim as summarized in the Statement above.
  - `SCRUM-CREW-TICKET/intent.md` §4, §7 — `[UNVERIFIED]` — kind: jira — original framing this
    decision makes concrete.
- **Conflict:** none
- **Open question:** none. The grouping key matches the existing (superseded) migration's own
  `(sub_job_id, set_resource_id, shift_number)` + `DISTINCT ON` pattern, restricted to
  `status IN ('PENDING', 'SENT', 'IN_PROGRESS')` — cited by the decision as matching that
  precedent "now a decision, not a workaround."
- **Ripple:** §11a row 3 — the existing migration's own backfill SQL
  (`apps/api/prisma/migrations/20260912120000_add_job_ticket_primary_ticket/migration.sql`) is
  the direct precedent the new migration's grouping key follows.
- **Acceptance:** After migration, no PENDING/SENT/IN_PROGRESS ticket pair remains linked by a
  retired `primaryTicketId`; each such pair exists as one ticket (the Oiler's, unchanged
  `allocationId`) with a `ticket_employees` row for the Operator carrying the Operator ticket's
  former Labor & Unit fields, and the Operator's original ticket is `CANCELLED`.
- **Notes for the executor:** `TicketStepCompletion`/`TicketSignature`/`TicketTimeEntry` rows on
  the Operator's now-cancelled ticket are `NOT SPECIFIED` beyond "the ticket itself is
  cancelled, not deleted" (matching reassignment's existing cancel semantics) — none are
  expected in practice since the copy was read-only (writes refused per REQ-03), but this is
  not decided as impossible by any source.

### REQ-11 — Payroll prices one row per ticket-employee; `PayrollJobDay` key widens `[VERIFIED]`

- **Statement:** Payroll export and weekly payroll continue to price and report one labor line
  per employee, regardless of how many employees share a physical ticket. `payroll.service.ts`'s
  `buildJobDay` becomes per ticket-employee instead of per ticket, and `PayrollJobDay`'s unique
  key `@@unique([runId, jobTicketId])` widens to include the employee — `(runId, jobTicketId,
  employeeId)` or equivalent.
- **Surface:** api, schema
- **Sources:**
  - `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` —
    `[VERIFIED]` — kind: decision — Q1 point 5: *"Payroll prices one row per ticket-employee
    instead of one per ticket. `PayrollJobDay`'s unique key `@@unique([runId, jobTicketId])`
    … must widen to include the employee — flagged for `tcg-prisma-guardian`. `payroll.service.ts`
    `buildJobDay` (reads `ticket.employee`) becomes per ticket-employee."*
  - `SCRUM-CREW-TICKET/intent.md` §4 — `[UNVERIFIED]` — kind: jira — original framing.
- **Conflict:** none
- **Open question:** none. This closes the highest-impact ripple this elaboration found in
  code (§11a row 4) — `PayrollJobDay`'s uniqueness and `buildJobDay`'s per-ticket assumption are
  now explicitly scoped for change, not left implicit.
- **Ripple:** §11a row 4 — `PayrollJobDay` (`apps/api/prisma/schema.prisma:5142`, doc-commented
  *"One completed ticket priced as one job-day"*) and `payroll.service.ts`'s `buildJobDay(ticket,
  …)` (line 779, reads `const employee = ticket.employee;`) both move from per-ticket to
  per-(ticket, employee). **Flag this migration for `tcg-prisma-guardian`** per the decision —
  widening a `@@unique` on a priced, financial table is exactly the kind of change that agent
  should check before it ships.
- **Acceptance:** A payroll run against a crew ticket with two employees produces two
  `PayrollJobDay` rows (one per `ticket_employees` row), each keyed `(runId, jobTicketId,
  employeeId)` and priced from that employee's own time/labor data.
- **Notes for the executor:** REQ-13's `ticket_employees` join supplies the roster and the
  per-employee Labor & Unit fields; `buildJobDay` must iterate `ticket.ticketEmployees` (or
  equivalent) rather than treating `ticket.employee` as singular. Existing `PayrollJobDay` rows
  for already-priced tickets are addressed by REQ-15, not this requirement.

### REQ-12 — Support / counterweight loads unaffected `[VERIFIED]`

- **Statement:** Every support / counterweight load remains its own asset group with its own
  ticket, filled and completed by the 3rd man or rigger who drives it, with their own labor
  hours. This ticket changes nothing about that shape.
- **Surface:** schema, api
- **Sources:**
  - `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` — `[VERIFIED]` —
    kind: decision — Decision point 4.
  - `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` —
    `[VERIFIED]` — kind: decision — Q4 point 3: *"Every other personnel allocation gets its own
    ticket, exactly as today: an Operator in a set with no Oiler seat, a Third Man, every
    support/counterweight-load driver."*
- **Conflict:** none
- **Open question:** none — this requirement is "no behavior change," and the existing
  per-allocation ticket-minting shape already matches it (a support load has exactly one
  personnel allocation today, so `ensureTickets`'s current one-ticket-per-allocation minting
  already produces the right cardinality for these; only the Oiler+Operator case changes).
- **Ripple:** none — new behavior does not reach this case differently than today's does.
  `NOT SPECIFIED` whether `THIRD_MAN_TYPE_NAME` (`packages/shared/src/constants/
  employee-types.ts`) is the only employee-type name that counts as a support-load driver —
  `intent.md` §10 flags this as its own open item ("the code has no such employee type name"),
  but that claim does not hold: `THIRD_MAN_TYPE_NAME = 'Third Man'` exists and maps to
  `CraftRoleType.THIRD_MAN`. Noted here as a correction to the intent's capture, not escalated
  to §12 — it does not block this requirement, since support-load ticketing is unchanged.
- **Acceptance:** A support load's ticket cardinality and fill/complete behavior after this
  ships is identical to before it.
- **Notes for the executor:** No code change is anticipated here beyond whatever REQ-13's
  schema shape requires uniformly (e.g., if every ticket gains a ticket-employees join, a
  support load's ticket still gets exactly one row in it, always primary).

### REQ-13 — New `ticket_employees` join entity: roster, primary flag, Labor & Unit fields `[VERIFIED]`

- **Statement:** A new `ticket_employees` table records, per ticket, which employees are on it
  (`employeeId`), which one is primary (`isPrimary`, exactly one `true` per ticket, partial
  unique index), and carries the four per-employee Labor & Unit fields moved off `JobTicket`:
  `craftModifierBracket`, `craftModifierId`, `laborComments`, `laborCapturedByUserId`. Every
  ticket gets the same shape — a single-employee ticket (Operator-alone, Third Man, load driver)
  has exactly one `ticket_employees` row with `isPrimary = true`; there is no "ticket with
  employees" vs. "ticket without" branch.
- **Surface:** schema
- **Sources:**
  - `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` —
    `[VERIFIED]` — kind: decision — Q1 points 1–3, verbatim as summarized in the Statement
    above.
  - `.ai/claude/contexts/prisma.md` — `[UNVERIFIED]` — kind: rule — Identity Convention (UUID
    PK, tenant-scoped) the decision's field list follows.
- **Conflict:** none
- **Open question:** none for the join's existence, field list and primary-flag enforcement.
  The final Prisma model name (`TicketEmployee` suggested, per the existing `Ticket<Noun>`
  convention) is explicitly left to the executor to confirm against team convention — the
  decision names this itself as not settled.
- **Ripple:** §11a rows 1, 2 — every reader of `JobTicket.employeeId`/`vendorEmployeeId` and the
  ticket-level Labor & Unit fields as single scalars needs to move to reading through this join
  instead. Full list is REQ-13's schema section (§3) and §11a row 1's command.
- **Acceptance:** A `ticket_employees` table exists with the field list above; a query for a
  given ticket's `ticket_employees` rows returns exactly the employees REQ-02 says belong on
  it, with exactly one `isPrimary = true`.
- **Notes for the executor:** The decision's field list does **not** include `vendorEmployeeId`
  or a per-row `allocationId` — vendor-employee crews are out of scope for this ticket (intent
  §5), and the ticket's own anchor allocation stays on `JobTicket` (REQ-17), so a
  `ticket_employees` row does not need its own allocation FK unless a later need (e.g.
  craft-code resolution per employee) surfaces one; that employee's own `JobResourceAllocation`
  row remains findable via `(subJobId, setResourceId, shiftNumber, employeeId)` if needed. Do
  not add fields the decision did not list. The per-employee start/stop window was later
  **BUILT** under TCG-25 (see REQ-14 and §13): two nullable columns on `ticket_employees`
  (`work_started_at`, `work_ended_at`); the shared `TicketTimeEntry` is untouched.

### REQ-14 — Per-employee time & labor keying: `ticket_employees` holds labor; `TicketTimeEntry` stays shared `[VERIFIED]`

- **Statement:** `TicketTimeEntry` stays per ticket, unchanged — its milestones (Leave Yard,
  Arrive at Job, Left Job Site, Arrived Back at Yard, lunch) are crew-wide because the crew
  travels together on the same piece of equipment. Per-employee Labor & Unit data
  (`craftModifierBracket`, `craftModifierId`, `laborComments`, `laborCapturedByUserId`) moves to
  the new `ticket_employees` table (REQ-13), one row per employee. The alternative — a nullable
  `employeeId` on `TicketTimeEntry` — was considered and rejected.
- **Surface:** schema, api
- **Sources:**
  - `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` —
    `[VERIFIED]` — kind: decision — Q1 points 4 and 6: *"`TicketTimeEntry` stays per ticket,
    unchanged. Milestones … are crew-wide because the crew travels together — Brian Petros
    2026-05-14 10:12: 'since they're on the same piece of equipment, they will arrive at the
    same time. So the same ticket can be used.'"* and *"Alternative rejected: a nullable
    `employeeId` on `TicketTimeEntry`. It answers 'whose window' but the Labor & Unit fields
    would still need a per-employee home, so the new table is needed either way; adding both is
    two models for one fact."*
- **Conflict:** n/a
- **Open question:** none. Q1 is resolved.
- **Ripple:** §11a rows 1, 4, 9 (`ticket-time-entries.service.ts`, `ticket-labor-entries.service.ts`'s
  `composeEntry`/`getTicketWorkTimes`/`resolveTargetTicket`, `field-ticket.mapper.ts`'s
  `toTimeTracking`) and row 4's `PayrollJobDay` finding (REQ-11) — all now have a settled
  target shape to build against instead of an open question.
- **Acceptance:** `TicketTimeEntry` rows carry no `employeeId` column and are read the same way
  for every employee on a ticket; a `ticket_employees` row's Labor & Unit fields are independently
  readable/writable per employee on the same ticket.
- **Per-employee work window — BUILT (TCG-25).** Source: TCG-25 (Brian Petros, transcript 2026-03-03 32:51: ticket-level times shared, the labor entry's start/stop and craft code modifier unique per employee; Corrina Bustos: "one time card for the job ticket, but each have their own line"; transcript 2026-05-21 9:27: the Oiler picks which employee he enters for; transcript 2026-05-19 34:03). Ticket-level times stay
  shared on `TicketTimeEntry` (unchanged, no `employeeId`); the one per-employee time is the
  start/stop of the employee's own labor entry. It is an optional override on the employee's
  `ticket_employees` row — `work_started_at`/`work_ended_at`, both null (follows the ticket) or
  both set with end > start (CHECK, migration `20260921020000_ticket_employees_work_window`). An
  explicit entry (by the Oiler for a teammate, or by the employee for themselves) is written to
  that row and never to the shared `ticket_time_entries`; it replaces the payable window
  (Start Work → Review & Complete) for that employee only, in labor reads and in payroll ingest.
  Lunch/WTL/leave-yard and the boom segments stay shared. This supersedes decision Q1 point 7's
  "build only if supported"; it is client-sourced by TCG-25, not inferred from existing code.

### REQ-15 — COMPLETE linked-pair migration treatment: keep both rows, backfill `isPrimary=true` `[VERIFIED]`

- **Statement:** COMPLETE tickets that are today linked via `primaryTicketId` are **not**
  migrated into one physical ticket. Both rows stay; each is backfilled with its own single
  `ticket_employees` row (`isPrimary = true`), like every other ticket, so old data reads under
  the new shape. Already-priced `PayrollJobDay` runs are untouched — no row moves, no
  `(runId, jobTicketId)` (or its widened successor, REQ-11) collides.
- **Surface:** schema
- **Sources:**
  - `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` —
    `[VERIFIED]` — kind: decision — Q2 point 2: *"COMPLETE pairs keep both rows. Each COMPLETE
    ticket is backfilled with its own single `ticket_employees` row (`isPrimary = true`), like
    every other ticket. Already-priced `PayrollJobDay` runs are untouched — no row moves, no
    `(runId, jobTicketId)` collides."* — and the "Why" section: *"leave COMPLETE pairs, because
    payroll has already priced them… Historical shape is a display concern; priced payroll is a
    money concern."*
- **Conflict:** n/a
- **Open question:** none. Q2 is resolved.
- **Ripple:** any `PayrollJobDay` row whose `jobTicketId` points at a COMPLETE ticket that was
  part of a linked pair is explicitly untouched by this migration — no collision, no orphan.
- **Acceptance:** After migration, every COMPLETE ticket (whether it was part of a linked pair
  or not) has exactly one `ticket_employees` row with `isPrimary = true`; no COMPLETE ticket
  pair is collapsed; no `PayrollJobDay` row for a COMPLETE ticket changes.
- **Notes for the executor:** This scope matches the superseded 2026-09-12 backfill's own
  `WHERE status IN ('PENDING', 'SENT', 'IN_PROGRESS')` restriction — per the decision, "now a
  decision, not a workaround."

### REQ-16 — Operator visibility on the shared ticket: step status only (default) `[VERIFIED]`

- **Statement:** The Operator (secondary employee) sees the shared ticket's progress/step
  status only — no signatures, checklists or comments, matching today's read-only copy. This is
  a **requester default**, chosen because no written source says more, not a product answer
  from the client. Whether the Operator should eventually see more stays open as **Q5**,
  non-blocking — the build ships this default regardless of how Q5 is later answered.
- **Surface:** mobile, api
- **Sources:**
  - `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` —
    `[VERIFIED]` — kind: decision — Q3: *"The Operator's view: step status only, as today
    (product default)… This is a default, not a product answer. The requester chose it because
    no written source says more… Whether the Operator should see more stays open for the
    client — recorded as a new, non-blocking §12 entry."*
- **Conflict:** n/a
- **Open question:** Q5 (non-blocking) — *"Beyond step status, should the Operator be able to
  read the shared ticket's signatures, checklists and comments, read-only?"* — owner Wes Staley
  + client, the remainder of FR-TCG-FOP-001 open question 11. Does not block this ticket's
  build; REQ-16's status-only default ships regardless.
- **Ripple:** §11a row 2 — the mobile screen the Operator lands on for "the ticket they're on"
  (REQ-06) renders status/progress only; a later "yes" on Q5 is an additive read-access change,
  not a rework of the ticket shape.
- **Acceptance:** The Operator's crew-ticket view shows progress/step status and nothing else —
  no signature images, no checklist results, no comment thread, no punch-in/accept control.
- **Notes for the executor:** If Q5 is later answered "yes," it is additive (grant a
  non-primary `ticket_employees` row read access to signatures/checklists/comments) — do not
  build toward it now; build exactly the status-only default above.

### REQ-17 — Ticket keyed by the primary employee's allocation — no asset-group entity needed `[VERIFIED]`

- **Statement:** The elaborator's original question — is a DAS `set` exactly one "asset
  group"? — is answered **no, and it does not need to be.** `JobTicket.allocationId` stays the
  ticket's anchor; no asset-group entity is introduced. The ticket is keyed by the allocation of
  whoever fills it, which reproduces the sheet's per-asset-group rule without modelling groups:
  the crane set's Oiler allocation anchors the crane ticket (with the Operator absorbed), and
  each support/counterweight load's own driver allocation anchors that load's own ticket. A DAS
  `set` is still used for exactly one thing — finding the Operator allocation to absorb, via the
  same `(subJobId, setResourceId, shiftNumber)` + seat-name lookup `linkCrewTickets` already
  does today.
- **Surface:** schema, api
- **Sources:**
  - `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` —
    `[VERIFIED]` — kind: decision — Q4, and its "Why" section: *"a DAS set is wider than the
    sheet's asset group. `JobResourceAllocation.setResourceId` points at the top-level crane
    `JobResource`, whose children include the support loads and their people. The sheet's
    'asset group' … is narrower — each support load is its own group with its own ticket …
    Keying a ticket by set would therefore put support-load drivers onto the crane ticket,
    which the sheet forbids."* Alternative rejected: a new asset-group key, since "the loadout
    / DAS model would have to carry grouping it does not carry today — a model change with no
    product requirement behind it."
- **Conflict:** n/a
- **Open question:** none. Q4 is resolved — and resolved by dissolving the question rather than
  answering it as originally posed, which the decision states explicitly.
- **Ripple:** none new beyond REQ-01/REQ-10 (which already describe the settled anchor
  mechanism). REQ-07/REQ-08's web/DAS row-grouping no longer needs a set-based grouping
  construct — render each ticket's own `ticket_employees` roster.
- **Acceptance:** No `AssetGroup`-equivalent entity exists in the schema; `JobTicket.allocationId`
  is non-null and points at the primary employee's own `JobResourceAllocation` for every ticket.
- **Notes for the executor:** The one edge case the decision explicitly does not address: a set
  with more than two personnel seats, or two Oiler allocations in the same set — "how two Oiler
  allocations in one set would resolve is not addressed because no set produces that today. If
  DAS ever does, it is a new question" (decision, *What this does not settle*). Not built for;
  not blocking.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** yes
- **Migration required:** yes — `pnpm db:migrate`, committed under
  `apps/api/prisma/migrations/`. Mandatory per `.ai/claude/contexts/prisma.md`.
- **Data backfill required:** yes — REQ-10 (collapse live PENDING/SENT/IN_PROGRESS pairs into
  one ticket + `ticket_employees`) and REQ-15 (backfill every ticket, including COMPLETE ones,
  with its own `isPrimary=true` `ticket_employees` row — no COMPLETE pair is collapsed).

Settled by `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md`
(Q1, Q4):

```prisma
// Settled shape (REQ-13, REQ-14) — decision Q1's exact field list. Do not add fields the
// decision did not name (no vendorEmployeeId — vendor crews are out of scope per intent §5;
// no per-row allocationId — see REQ-13's notes).
model TicketEmployee {           // name is a suggestion — see REQ-13 notes
  id                    String   @id @default(uuid()) @db.Uuid
  tenantCompanyId       String   @map("tenant_company_id") @db.Uuid
  jobTicketId           String   @map("job_ticket_id") @db.Uuid
  employeeId            String   @map("employee_id") @db.Uuid
  isPrimary             Boolean  @map("is_primary")
  // The four Labor & Unit fields moved off JobTicket (decision Q1 point 1) — one set per
  // employee instead of one set per ticket.
  craftModifierBracket  String?  @map("craft_modifier_bracket") @db.VarChar(20)
  craftModifierId       String?  @map("craft_modifier_id") @db.Uuid
  laborComments         String?  @map("labor_comments") @db.Text
  laborCapturedByUserId String?  @map("labor_captured_by_user_id") @db.Uuid

  createdAt DateTime @default(now()) @map("created_at") @db.Timestamptz()
  updatedAt DateTime @updatedAt @map("updated_at") @db.Timestamptz()

  // relations to TenantCompany / JobTicket / Employee / CraftModifier / User (laborCapturedByUserId)
  // omitted — NOT SPECIFIED beyond the FK list above; exact onDelete behavior per FK is
  // NOT SPECIFIED (JobTicket's own precedent for the equivalent fields today is a useful
  // reference: onDelete: Restrict for employee, onDelete: SetNull for craftModifier/
  // laborCapturedByUser).

  @@unique([jobTicketId, employeeId], name: "uq_ticket_employees_ticket_employee")
  // Exactly one isPrimary per ticket (decision Q1 point 2).
  @@unique([jobTicketId], name: "uq_ticket_employees_one_primary_per_ticket", map: "uq_ticket_employees_one_primary_per_ticket")
  // ^ Prisma cannot express a partial unique index (WHERE is_primary) directly — the migration's
  // raw SQL must add `CREATE UNIQUE INDEX … ON ticket_employees (job_ticket_id) WHERE is_primary`,
  // matching how JobTicket's own "one non-cancelled ticket per allocation" partial index is
  // handled today (schema comment + migration SQL, not a Prisma-level constraint).
  @@index([tenantCompanyId, jobTicketId], name: "idx_ticket_employees_tenant_ticket")
  @@map("ticket_employees")
}

// JobTicket changes: drop `employeeId` (move to TicketEmployee — every ticket's employees are
// now read through the join, including single-employee tickets, per REQ-13); drop
// `craftModifierBracket`/`craftModifierId`/`laborComments`/`laborCapturedByUserId` (moved to
// TicketEmployee); drop `primaryTicketId` (REQ-09). `vendorEmployeeId` and `allocationId` are
// UNCHANGED — `allocationId` stays the ticket's anchor per REQ-17/Q4 ("JobTicket.allocationId
// stays the ticket's anchor. No asset-group entity is introduced"), and vendor-employee tickets
// (out of scope, intent §5) keep their existing single-row shape untouched by this ticket.
```

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| `JobTicket` | `ticketCode` | `LEM` | `entity_sequences` via `SequenceRepository.getNextValue('LEM')` | REQ-01 — unchanged, kind: code |
| `TicketEmployee` (name suggested) | none | n/a | n/a — no business code, a pure join | REQ-13 |

- **New prefix introduced:** no
- **Child relations:** `TicketEmployee.employeeId` references `Employee.id`, never a code, per
  convention. `JobTicket.allocationId` (unchanged) continues to reference
  `JobResourceAllocation.id`.
- **Per-employee start/end window:** now BUILT under TCG-25 (REQ-14) as `workStartedAt`/
  `workEndedAt` (nullable `timestamptz`) on `TicketEmployee` — an addition to the model above.

## 4. API surface — `apps/api`

Layering is `presentation → usecase → service → orm`, never upward.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| (internal) | `ensureTickets`/`sendTickets` call sites (DAS) | `das-allocations.controller.ts` or equivalent (not verified this session) | `job-tickets.service.ts` `ensureTickets`, `sendTickets` | `job-tickets.repository.ts` | REQ-01, REQ-02 |
| `GET` | `/api/v1/field/tickets` | `field-tickets.controller.ts:98` (`list`) | `job-tickets.service.ts` `listMyTickets` | `job-tickets.repository.ts` `findForEmployee` | REQ-06 |
| `GET` | `/api/v1/field/tickets/:id` (route not directly verified this session; ticket detail is read via `list`/mobile contract) | `field-tickets.controller.ts` | `job-tickets.service.ts` `getTicketForEmployeeAction` | `job-tickets.repository.ts` `findById` | REQ-03, REQ-06 |
| `POST` | `field/tickets/:id/labor-entries` (path not directly verified; DTO confirmed) | `field-tickets.controller.ts` | `ticket-labor-entries.service.ts` `recordEntry` | `TicketLaborEntriesRepository` | REQ-04, REQ-05 |
| `GET` | job-progress endpoints (`job-progress.service.ts` `getJobProgress`, `getTicketDetail`) | not read this session | `job-progress.service.ts` | `job-progress.repository.ts` | REQ-07 |

Exact route paths beyond what is cited above are `NOT SPECIFIED` — this session read the
services and DTOs the assignment named, not every controller route table; the executor should
confirm exact paths against `field-tickets.controller.ts` (782 lines, only partially read) and
whatever DAS controller calls `ensureTickets`/`sendTickets` before building against this table.

Per endpoint:

- **Request/response shapes:** `NOT SPECIFIED` beyond what REQ-13/REQ-14 settle: a ticket's
  response gains an `employees`/`ticketEmployees`-shaped list (roster, `isPrimary`, and each
  member's Labor & Unit fields), replacing single `employeeId`/Labor-field scalars.
  `RecordTicketLaborEntryDto` already has the `targetEmployeeId` field this needs (REQ-04's
  notes) — its resolution target changes (to a same-ticket `ticket_employees` row), not its
  shape.
- **Guards / roles:** `AccessTokenGuard` (global). No new role is implied by this ticket —
  authorization stays "primary writes, secondary reads own ticket" (REQ-03), enforced the same
  way `getTicketForEmployeeAction` enforces it today.
- **Route param identity:** ticket code on the boundary, resolved to the UUID `id` — unchanged
  convention (`.ai/claude/contexts/prisma.md`).
- **Errors:** `NOT SPECIFIED` beyond REQ-03's existing precedent (`ForbiddenException` message
  naming who completes the ticket).
- **Module registration:** no new module — `TicketEmployee` is additive to the existing
  `job-tickets` usecase area; `app.module.ts` registration unaffected.

## 5. Web surface — `apps/web`

**Feature-first, not atomic design** (`.ai/claude/contexts/web.md`).

- **Routes:** existing Progress Tracking and DAS routes — no new routes implied by this ticket.
- **Existing components to reuse:** `apps/web/src/features/ticket-progress/components/crew-identity.tsx`
  (currently singular-`person`, becomes the per-employee row renderer — reused, not replaced),
  `ticket-banners.tsx`, `action-buttons.tsx`. `apps/web/src/features/das/middle-section/jobs/tickets/components/send-ticket-modal.tsx`
  and `use-ensure-tickets.ts`.
- **New components proposed:** `NOT SPECIFIED` — the shape of "employees listed, primary
  marked" within one row (REQ-07, REQ-08) is not specified concretely enough by any source to
  say whether it needs a new small component (e.g. a crew-member chip list) or a straightforward
  extension of `crew-identity.tsx`. This is a genuine gap but does not block build — it is a
  UI-detail choice the executor can make within the requirement, not a product fact.
- **Table (if any):** `NOT SPECIFIED` — whether DAS's ticket listing is a `WorkspaceTable`/
  `CommonTable` instance or the bespoke `send-ticket-modal.tsx` table shape was not confirmed
  against `.ai/claude/contexts/web.md`'s unresolved Tables note; match whichever the module
  already uses (per that rule).
- **Forms:** n/a — no new form implied.
- **Server state:** existing `ticket-progress.service.ts` / job-progress query hooks
  (`use-ticket-progress.ts`) — query key/invalidation shape `NOT SPECIFIED` beyond "must
  reflect the new employees[] response shape."
- **Colors / spacing:** no new UI beyond what's described — theme variables apply as everywhere
  else.
- **Copy:** `NOT SPECIFIED` — no source states exact banner/label text for "primary" vs
  "secondary" display.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** `app/(field)/jobs.tsx`, `app/(field)/field.tsx`,
  `app/(field)/ticket/index.tsx`, `app/(field)/ticket/step/[key].tsx` — all read this session.
- **Components:** `components/field/crew-ticket-banner.tsx` (retired/replaced per REQ-06),
  `components/field/ticket-card.tsx` (reused, response shape changes).
- **Offline / sync behavior:** `NOT SPECIFIED` — no source addresses this, and per template
  guidance this must not be inferred from web.
- **Touch targets:** 48px (`.ai/claude/contexts/mobile.md`) — unchanged, no new controls
  implied beyond what REQ-05's crew-card list already renders today.
- **Push / notifications involvement:** `NOT SPECIFIED` — `job-tickets.service.ts`'s employee
  ticket notification path (`ticketNotificationService.sendEmployeeTicketNotification`) is
  called once per allocation today; whether the Operator still gets a distinct notification
  when they are never primary is `NOT SPECIFIED` and not raised as its own open question here
  since it does not block build (existing behavior can continue unless told otherwise) — flagged
  for the executor's attention, not escalated to §12.

## 7. Shared package — `packages/shared`

- **Types added / changed:**
  - `FieldTicket.crewTicket` (`field-ticket.mapper.ts`, exported via whatever barrel re-exports
    it to mobile) — the `{ role: 'PRIMARY' | 'SECONDARY' }` discriminated shape is retired per
    REQ-06/REQ-09; replaced by an `employees: [{ employeeId, name, isPrimary }]` list per
    REQ-06's notes. Whether per-employee Labor & Unit data rides along on this same type or a
    separate labor-entry response is `NOT SPECIFIED` beyond REQ-13/REQ-14's settled
    `ticket_employees` shape — an exact DTO shape is an executor-level design choice within
    that settled data model, not a product fact.
  - `ProgressTicketSummary.person` / `.role` (`packages/shared/src/types/job-progress.types.ts:139,141`)
    — singular, becomes plural per REQ-07.
  - `apps/mobile/data/contracts/ticket.contract.ts`'s Zod schema field
    `primaryTicketId: z.string()` — retired per REQ-09.
- **Nothing shared:** n/a — this ticket touches shared types directly (`tcg-contract-tracer`
  is named in `intent.md` §6 as required to run once the shape is settled — not run in this
  elaboration, since the shape is not yet settled).

## 8. Permissions and tenancy

- **Roles permitted:** the ticket's primary employee writes (REQ-03); a secondary employee
  reads their own crew ticket — source: FR-TCG-FOP-001 §4.1 (`field-ops/frd-new-format-draft/
  04-role-responsibility-model.md`, cited by `intent.md` §8 and the decision note), `[UNVERIFIED]`
  status on the FRD itself even though the decision that confirms its §4.1 reading is
  `[VERIFIED]`.
- **Roles denied:** secondary employee cannot write to the ticket (REQ-03).
- **Tenant isolation:** standard — `TicketEmployee` should be added to the Prisma client
  extension's tenant-scoping allowlist unless a reason like `TicketTimeEntry`'s (cross-employee
  write path) applies; the Oiler's cross-employee write to a teammate's `ticket_employees` row
  (REQ-04) is exactly that kind of authorized cross-employee write. **Flag both this and
  `PayrollJobDay`'s widened unique key (REQ-11) for `tcg-prisma-guardian`**, as `intent.md` §6
  already requires that agent to run, and the decision note explicitly calls out the
  `PayrollJobDay` change for it.
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| `TicketEmployee.isPrimary` | exactly one `true` per `jobTicketId`, enforced by a partial unique index `(jobTicketId) WHERE is_primary` | `decisions/2026-09-14-crew-ticket-shape-….md` (Q1 point 2) | `[VERIFIED]` |
| everything else | `NOT SPECIFIED` — no source states a limit | — | — |

Invented validation is still invention — nothing else is added here beyond what the sources
above state.

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | `linkCrewTickets`-equivalent seat/primary derivation | REQ-02 |
| Unit | `getTicketForEmployeeAction`-equivalent write-refusal for secondary | REQ-03 |
| Unit | `resolveTargetTicket`-equivalent same-ticket labor targeting | REQ-04 |
| Integration (API) | one ticket minted for an Oiler+Operator set, two for a set with two support loads | REQ-01 |
| Integration (API) | payroll run against a two-employee ticket yields two priced `PayrollJobDay` lines, keyed `(runId, jobTicketId, employeeId)` | REQ-11 |
| E2E / manual script | mobile Oiler sees both crew members and can enter each one's time | REQ-05 |
| E2E / manual script | mobile Operator sees "On \<Oiler\>'s ticket" with status only, no accept/signatures/checklists | REQ-06, REQ-16 |
| Migration test | live PENDING/SENT/IN_PROGRESS pairs collapse into one ticket + `ticket_employees`, Operator ticket CANCELLED; COMPLETE pairs untouched, each backfilled its own `isPrimary=true` row | REQ-10, REQ-15 |

- Requirements with no testable acceptance criterion: none — REQ-14–17 (the four requirements
  that were `[OPEN]`) now have acceptance criteria per their rewritten §2 blocks. REQ-05,
  REQ-07 and REQ-08 remain `[UNVERIFIED]` (sourced from `intent.md` only) but are not blocked —
  their acceptance criteria stand as written.

## 11. Non-functional

- **Performance:** `NOT SPECIFIED`.
- **Concurrency:** `ensureTickets`'s existing idempotency guarantee ("calling this twice with
  the same subJobId is safe") must carry forward under the new group-keyed minting — cited as
  `code`, descriptive, an existing invariant to preserve, not a new requirement.
- **Audit / activity log:** `JobTicketActivityLogger` already logs ticket creation and status
  changes (`job-tickets.service.ts`) — `NOT SPECIFIED` whether adding/removing a
  `TicketEmployee` row gets its own activity-log entries; no source addresses it.
- **Migration/rollout order:** schema → API → web → mobile, per `intent.md` §6's surface table
  (all four marked `yes`) — no feature flag is named by any source; whether this ships behind
  one is `NOT SPECIFIED`.

## 11a. Ripple — already-shipped behaviour these requirements reach

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| `job-tickets.service.ts` (`ensureTickets`, `sendTickets`, `reassignTicket`, `listMyTickets`, `getTicketForEmployeeAction`, `toTicketDto`) | one-ticket-per-allocation minting/reading | REQ-01, REQ-02, REQ-06 | changes deliberately | `decisions/2026-09-14-…oiler-fills-it.md` | direct read, this session |
| `primaryTicketId`/`linkCrewTickets` consumers: `ticket-time-entries.repository.ts`, `job-progress.repository.ts`, `job-tickets.repository.ts`, `job-progress.service.ts`, `job-tickets.service.spec.ts`, `field-ticket.mapper.spec.ts`, `field-ticket.mapper.ts`, `ticket-card.test.tsx`, `ticket.contract.ts` | shared self-FK + mirroring mechanism | REQ-03, REQ-06, REQ-09 | changes deliberately (retired) | `decisions/2026-09-14-…oiler-fills-it.md` | `grep -rln "primaryTicketId\|linkCrewTickets" apps/api/src apps/web/src apps/mobile packages/shared/src qa-automation` |
| `apps/api/prisma/migrations/20260912120000_add_job_ticket_primary_ticket/migration.sql` backfill | grouping key precedent for live-pair collapse | REQ-10 | migrated (superseded by the new migration) | `code`, descriptive | direct read, this session |
| `PayrollJobDay` (`@@unique([runId, jobTicketId])`) + `payroll.service.ts` `buildJobDay`/`calculatePayPeriod` caller | one-ticket-per-employee pricing assumption | REQ-11 | changes deliberately — widens to `(runId, jobTicketId, employeeId)`; `buildJobDay` iterates ticket-employees; flagged for `tcg-prisma-guardian` | `decisions/2026-09-14-crew-ticket-shape-….md` (Q1) | `grep -n "jobTicketId" apps/api/prisma/schema.prisma`; `grep -n "buildJobDay\|ticket.employee\b" apps/api/src/usecase/payroll/payroll.service.ts` |
| `ticket-time-entries.service.ts`, `ticket-labor-entries.service.ts` (`composeEntry`, `getTicketWorkTimes`, `resolveTargetTicket`, `getCrewForTicket`), `field-ticket.mapper.ts` (`toTimeTracking`) | `TicketTimeEntry` (no `employeeId`) + `JobTicket`-level Labor & Unit fields | REQ-04, REQ-05 | changes deliberately — `TicketTimeEntry` stays untouched/shared; Labor & Unit fields move to `ticket_employees` | `decisions/2026-09-14-crew-ticket-shape-….md` (Q1) | direct read, this session |
| `apps/web/src/features/das/middle-section/jobs/tickets/components/send-ticket-modal.tsx`, `use-ensure-tickets.ts`, `das-allocations.service.ts` (web) | `EnsuredTicketRow[]` — one row per allocation | REQ-08 | changes deliberately | `SCRUM-CREW-TICKET/intent.md` §4 | `grep -rln "ensureTickets\|EnsuredTicketRow" apps/web/src/features/das` |
| `apps/web/src/features/ticket-progress/` (`crew-identity.tsx`, `action-buttons.tsx`, `ticket-banners.tsx`), `job-progress.types.ts` (`ProgressTicketSummary.person`/`.role`) | singular `person` per ticket row | REQ-07 | changes deliberately | `SCRUM-CREW-TICKET/intent.md` §4 | direct read, this session |
| `apps/mobile/app/(field)/jobs.tsx`, `field.tsx`, `components/field/crew-ticket-banner.tsx`, `ticket/index.tsx` (`crewCopy`/`isReadOnlyTicket`) | `crewTicket.role` PRIMARY/SECONDARY shape | REQ-06 | changes deliberately — replaced by "On \<Oiler\>'s ticket" status-only view | `decisions/2026-09-14-crew-ticket-shape-….md` (Q3) | direct read, this session |
| `RecordTicketLaborEntryDto.targetEmployeeId` / `resolveTargetTicket`'s cross-**ticket** resolution | Oiler-enters-for-teammate mechanism | REQ-04 | changes deliberately — resolves to the target employee's `ticket_employees` row on the same ticket instead of a separate ticket | `decisions/2026-09-14-crew-ticket-shape-….md` (Q1) | direct read, this session |
| `qa-automation/e2e` | — | — | **no existing behaviour found** | — | `grep -rn "primaryTicketId\|linkCrewTickets" qa-automation/e2e` returned nothing |

- **Surfaces with no existing behaviour in this area:** `qa-automation/e2e` — established by an
  empty grep, not an unrun one (see table row 10). New E2E coverage for the target shape is a
  gap this spec does not fill (§10).
- **Consumers with no source for what happens to them:** none remaining — rows 4, 5 and 8 (the
  three that depended on Q1) are now sourced by
  `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md`.

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Nothing below is built until these are answered.

```bash
grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md
```

### Q1 — Per-employee time & labor keying

- **Question:** Does `TicketTimeEntry` gain a nullable `employeeId` (null = shared crew-wide
  milestone; set = a per-employee window like `WORK_TIME`/boom time), or does per-employee
  Labor & Unit data (today's `JobTicket`-level `craftModifierBracket`/`craftModifierId`/
  `laborComments`/`laborCapturedByUserId` fields) move to a new table keyed
  `(jobTicketId, employeeId)`, leaving `TicketTimeEntry` itself untouched?
- **Why it cannot be answered from what is written:** `intent.md` §7 flags `TicketTimeEntry`
  as `OPEN` itself. `TicketTimeEntry`'s schema comment explains `capturedByUserId` is about
  *authorship*, not *whose window* a row is. The decision note is a product decision about who
  fills the ticket, not a data-model decision about how two employees' time coexists on one
  ticket. No source states which of the two shapes (or a third) is intended.
- **Blocked:** REQ-04 (schema representation of the separate labor record), REQ-11 (payroll
  pricing), REQ-14 itself; also the `targetEmployeeId` cross-ticket write path's replacement
  (§11a row 8).
- **Candidates:** `SCRUM-CREW-TICKET/intent.md` (14,556 bytes, 2026-09-14) — raises but does
  not answer; `apps/api/prisma/schema.prisma` `TicketTimeEntry` model (code, descriptive only);
  `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` (13,781 bytes,
  2026-09-14) — does not address it.
- **Owner:** product team — `intent.md` §12 names Kyle Harlow (field/tickets) as the owner of
  the underlying gap entry this decision resolved; the schema-shape half of the question likely
  sits with whoever owns the `apps/api/prisma` surface.
- **Workaround, if any:** none safe to build ahead of the answer — see REQ-14's notes.
- **Status:** resolved 2026-09-14 — per-employee labor row: new `ticket_employees` (UUID PK, tenantCompanyId, jobTicketId, employeeId, isPrimary + the four Labor & Unit fields moved off `JobTicket`), exactly one isPrimary per ticket; `TicketTimeEntry` stays per ticket; payroll prices one row per ticket-employee and `PayrollJobDay`'s `(runId, jobTicketId)` key widens to include the employee — see decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md

### Q2 — COMPLETE linked-pair migration treatment

- **Question:** Should COMPLETE tickets already linked via `primaryTicketId` be migrated into
  the new one-ticket shape, or left permanently as two historical rows (the Operator's already
  priced by `PayrollJobDay`)?
- **Why it cannot be answered from what is written:** `intent.md` §7 and §12 both raise this
  and leave it explicitly unanswered ("migrate or leave as two rows?"). The decision note does
  not mention COMPLETE tickets. The 2026-09-12 gap-entry update describes only the *existing*
  (superseded) migration's own choice to leave COMPLETE tickets untouched — a fact about what
  was built provisionally, not a decision for this ticket.
- **Blocked:** REQ-10's migration scope, REQ-15 itself.
- **Candidates:** `SCRUM-CREW-TICKET/intent.md` §7, §12 (14,556 bytes, 2026-09-14); `field-ops/gaps.md`
  lines 216–340 (68,718 bytes total file, this range only, 2026-09-12 update) — describes, does
  not decide; `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` — silent
  on this.
- **Owner:** product team.
- **Workaround, if any:** scope REQ-10's live-pair collapse strictly to non-COMPLETE,
  non-CANCELLED tickets (matching the existing, superseded migration's own
  `WHERE status IN ('PENDING', 'SENT', 'IN_PROGRESS')`), leaving every COMPLETE pair exactly as
  it is today until this is answered — explicitly a workaround, not a decision.
- **Status:** resolved 2026-09-14 — collapse PENDING/SENT/IN_PROGRESS pairs only (Operator's row → `ticket_employees` on the Oiler's ticket carrying its labor fields, Operator ticket retired under existing cancel semantics, then drop `primaryTicketId`); COMPLETE pairs keep both rows, each backfilled with its own isPrimary=true row, so priced `PayrollJobDay` runs are untouched — see decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md

### Q3 — Operator visibility of signatures/checklists/comments on the shared ticket

- **Question:** Can the Operator (secondary employee) read the shared ticket's signatures,
  checklists and comments, or only its step/status — as today's read-only crew copy does?
- **Why it cannot be answered from what is written:** the decision note itself lists this
  among items *"deliberately left open"* — it is not a gap in this elaboration, it is a gap the
  decision explicitly declines to close. The 2026-09-12 gap-entry update names the same open
  item in the superseded build. `intent.md` §12 blocking question 2 carries it forward.
- **Blocked:** REQ-16 itself; REQ-06's mobile Operator-view detail beyond "shows the crew
  ticket, not an assignable copy."
- **Candidates:** `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` →
  *"What this does not settle"* (13,781 bytes, 2026-09-14); `field-ops/gaps.md` lines 216–340,
  2026-09-12 update (this range only); `SCRUM-CREW-TICKET/intent.md` §12 blocking question 2.
- **Owner:** product team — no named person on this specific item in any source.
- **Workaround, if any:** match today's copy exactly (step/status only, nothing else) until
  answered — explicitly a workaround.
- **Status:** resolved 2026-09-14 — step status only, as today ("On <Oiler>'s ticket" + progress; no signatures/checklists/comments/punch-in/accept; PR #561 banner + View-ticket CTA replaced) — a requester default, not a client answer; the richer view is the new non-blocking Q5 below — see decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md

### Q4 — Whether a DAS `set` is exactly one "asset group"

- **Question:** Does `(subJobId, setResourceId, shiftNumber)` — the grouping key the existing,
  superseded `linkCrewTickets` code already uses — correctly and completely identify one "asset
  group" for every set configuration DAS can produce (more than 2 personnel seats, an
  asset-only set with no personnel, a set spanning more than one shift), or are there
  configurations this ticket has not accounted for?
- **Why it cannot be answered from what is written:** `intent.md` §10 raises this itself
  ("OPEN — confirm a set is exactly one asset group"). The only evidence available is that the
  current (superseded, provisional) code already assumes this mapping — which, per this
  elaborator's own operating rules, code agreeing with itself is not a source for a product
  question. No vault document or decision states the DB-level equivalence explicitly.
- **Blocked:** REQ-01's precise grouping boundary, REQ-07/REQ-08's row-grouping logic, REQ-10's
  migration key.
- **Candidates:** `SCRUM-CREW-TICKET/intent.md` §10 (14,556 bytes, 2026-09-14) — raises but does
  not answer; `apps/api/prisma/schema.prisma` `JobResourceAllocation` model, `job-tickets.service.ts`
  `linkCrewTickets` (code, descriptive only — not a source for the product question);
  `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` — describes the
  business rule, not the DB equivalence.
- **Owner:** product team — Lisette Anzaldo is named throughout the decision note as the
  dispatch-practice source and sheet approver; she is the most likely person to confirm this.
- **Workaround, if any:** build against `(subJobId, setResourceId, shiftNumber)`, inherited from
  the existing code's own assumption — explicitly a workaround, not a confirmed answer.
- **Status:** resolved 2026-09-14 — no: keyed by the primary employee's allocation, not by set. `JobTicket.allocationId` stays the anchor, no asset-group entity; within one (subJobId, setResourceId, shiftNumber) an Oiler allocation's ticket is the crew ticket and the Operator's allocation is absorbed as a second ticket-employee (no ticket minted for it); every other personnel allocation gets its own ticket as today; the partial unique index stays — see decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md

### Q5 — Operator richer view of the shared ticket (signatures / checklists / comments)

- **Question:** Beyond step status, should the Operator (secondary employee) be able to read
  the shared ticket's signatures, checklists and comments — read-only — on their own device?
- **Why it cannot be answered from what is written:** Q3 was closed on 2026-09-14 with a
  requester default (status only, as today) because no written source says more. The
  product-side half — what TCG actually wants the Operator to see — is the remainder of
  FR-TCG-FOP-001 open question 11
  (`field-ops/frd-new-format-draft/08-open-questions.md`:27, row owner Wes + Client), which the
  morning decision answered only as to *actions* (none), not *visibility*.
- **Blocked:** nothing — the build ships the status-only default from Q3. A later "yes" is an
  additive mobile/API change (read access to signatures/checklists/comments for a non-primary
  ticket-employee), not a rework of the ticket shape.
- **Candidates:** `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md`
  → Q3 (default, not answer); `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md`
  → *"What this does not settle"* (13,781 bytes, 2026-09-14); `field-ops/gaps.md` lines
  216–340, 2026-09-12 update (this range only) — "only step status is today".
- **Owner:** Wes Staley + client (per the FR-TCG-FOP-001 open-question row).
- **Workaround, if any:** not needed — the default is already what ships.
- **Status:** open

### Q6 — Tickets with neither `employeeId` nor `vendorEmployeeId`: what does the backfill do with them?

- **Question:** The local dev database holds 18 COMPLETE `job_tickets` rows (all `T-JOB-00001-*`,
  created 2026-09-02, each with a `craft_modifier_bracket` of `OP-BP-06` and no
  `payroll_job_days`) that carry **neither** `employee_id` nor `vendor_employee_id`, although
  their allocation is an EMPLOYEE allocation with an employee on it. REQ-15 backfills "from its
  former `employeeId`", so these rows get **no** `ticket_employees` row and their Labor & Unit
  fields are dropped with the columns. Should the migration instead backfill such a row from
  its allocation's employee (`job_resource_allocations.employee_id`), or is "no roster row" the
  right outcome — and does production carry any such rows at all?
- **Why it cannot be answered from what is written:** REQ-15 presumes every employee ticket has an
  `employeeId`; the previous schema's own invariant ("exactly one of the two personnel FKs is
  set") says so too, and these rows breach it. No source says whether a ticket's person may be
  recovered from its allocation, and REQ-17 makes the allocation the *anchor*, not the person
  (a REJECTED-then-reassigned allocation names a different person than the cancelled ticket did).
- **Blocked:** nothing — U1's migration ships with the faithful reading (no row), reports the
  count with `RAISE NOTICE`, and the preflight script
  (`apps/api/prisma/scripts/preflight-ticket-employees.sql` §A2) lists every such row so the
  answer can be checked against a production snapshot before `migrate deploy`. Before U1, those
  rows were already invisible to every employee (`findForEmployee` filtered on the null
  `employee_id`), so behaviour on the mobile and field paths does not change; what is lost is
  their bracket value.
- **Candidates:** `SCRUM-CREW-TICKET/spec.md` REQ-15 (this file); the previous `JobTicket`
  schema comment (`apps/api/prisma/schema.prisma` before U1, "Exactly one of the two personnel
  FKs is set"); `apps/api/prisma/scripts/reset-ticket.ts` / the 2026-09-02 seed that produced
  the `T-JOB-*` rows (not read — origin of the rows is unconfirmed).
- **Owner:** engineering (Syed Haris) — data-repair question, not a product one; the
  production count decides whether it matters.
- **Workaround, if any:** the migration's current behaviour (no row, NOTICE, preflight
  listing). If production has such rows and the bracket must survive, a one-off
  `INSERT INTO ticket_employees … FROM job_resource_allocations` before the drop is the fix,
  and belongs in this migration, not a later one.
- **Status:** deferred 2026-09-21 — requester (in-session answer): leave the faithful reading as it is for now (no roster row, NOTICE, preflight §A2 listing); revisit once the production count from the preflight is known. Stays open as a data-repair item.

### Q7 — An Operator already has a started or finished ticket of their own when an Oiler joins their set

- **Question:** REQ-01 says an Operator in an Oiler-seated set gets no ticket of their own. When
  the Oiler is allocated *after* the Operator's ticket exists, U1's `ensureTickets`/`sendTickets`
  folds the Operator into the Oiler's ticket and cancels their own ticket **only while it is
  PENDING/SENT**. A ticket that is already IN_PROGRESS or COMPLETE is left as the Operator's own
  ticket (they are not absorbed, and stay their own primary). Is that the right cut, or should an
  IN_PROGRESS ticket also be folded (moving its time entries), or the allocation change refused?
- **Why it cannot be answered from what is written:** REQ-01/REQ-10 settle the shape for tickets
  minted together and for the one-time live-pair migration. No source says what happens to a
  ticket that has started when the crew composition changes afterwards; REQ-10 only covers the
  migration, and `sendTickets` locks the sub-job once sent, so the case is rare but reachable.
- **Blocked:** nothing — U1 ships the conservative cut above (`planCrewTickets`,
  `apps/api/src/usecase/job-tickets/crew-roster.ts`).
- **Candidates:** `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md`
  (Q2 point 1, Q4); REQ-10's cancel semantics.
- **Owner:** product (dispatch) — a dispatch-workflow question.
- **Workaround, if any:** the conservative cut in U1.
- **Status:** resolved 2026-09-21 — requester answer: an Operator whose own ticket has already started or finished when an Oiler joins keeps managing that ticket independently of the Oiler. Matches the shipped cut (`planCrewTickets`: IN_PROGRESS/COMPLETE not absorbed). A requester answer in-session, not a client statement; no decision note yet.

### Q8 — Can the Oiler still enter Labor & Unit for an Operator who kept a ticket of their own (Q7)?

- **Question:** REQ-04 retargets `resolveTargetTicket` to the target's `ticket_employees` row on
  **the caller's ticket**. An Operator left on their own IN_PROGRESS/COMPLETE ticket (Q7's
  not-absorbed cut) is not on the Oiler's roster, so U2's Oiler write for them now answers 403
  ("not a boom-working member of this ticket"); before, it crossed to that ticket via the set's
  allocations. Should the Oiler keep that cross-ticket write for such an Operator, or is "their
  own ticket, their own entry" the intended end state?
- **Why it cannot be answered from what is written:** REQ-04 / decision Q1 point 1 speak only of
  the shared ticket; Q7 leaves the not-absorbed case open and nothing says who enters that
  Operator's Labor & Unit.
- **Blocked:** nothing — U2 ships same-ticket-only targeting (the non-absorbed Operator, as their
  own ticket's primary, can still write their own entry).
- **Candidates:** Q7; `decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md` (Q1 point 1).
- **Owner:** product (dispatch)
- **Workaround, if any:** the same-ticket-only cut in U2.
- **Status:** resolved 2026-09-21 — requester answer: the Oiler must fill the tickets assigned to them, as the Operator fills theirs — each on their own ticket. An Operator who kept their own ticket (Q7) fills their own Labor & Unit; the Oiler has no cross-ticket write for them. Matches the shipped same-ticket-only targeting. Requester answer, not a client statement; no decision note yet.

### Q9 — Which priced row is the ticket-level "Payable" hours on Progress Tracking once a ticket has two?

- **Question:** `job-progress` shows one *Payable* figure per ticket, read from the ticket's latest
  payroll job-day. REQ-11 now prices one job-day per roster employee, so a crew ticket has two
  per run. U2 shows the **primary's** row (what the figure meant while only the primary was
  priced). Should it instead show the primary's, the sum across the crew, or one figure per
  employee (U4's employee list)?
- **Why it cannot be answered from what is written:** REQ-07 specifies the row/employee layout,
  not which payroll row feeds the ticket-level figure; REQ-11 does not address display readers.
- **Blocked:** nothing — U2 ships the primary's row; U4 (web Progress) is where a per-employee
  figure would land.
- **Candidates:** REQ-07, REQ-11.
- **Owner:** product
- **Workaround, if any:** primary's row.
- **Status:** resolved 2026-09-21 — requester answer: no crew total; progress and payroll are managed per individual. Built: `ProgressTicketEmployee.payableHours` is each person's own payroll figure and the web crew list shows it per person; the ticket-level Payable stays the primary's. Requester answer, not a client statement; no decision note yet.

### Q10 — Per-employee work window (TCG-25): three edges the ticket text does not settle

- **Question:** With the per-employee start/stop built (REQ-14), (a) should lunch/WTL windows also
  be per employee, or stay shared (built: shared)? (b) should the boom segments (Build Up / boom /
  Break-down, which earn the long-boom adder) be clipped to an employee's own window when it is
  narrower than the ticket's (built: not clipped)? (c) what ceiling should an Oiler-entered
  window be held to — the ticket's shared boom time (built), or the employee's current own window?
- **Why it cannot be answered from what is written:** TCG-25 and the cited transcripts settle
  that the start/stop and craft code modifier are per employee, and that ticket-level times are
  shared; they say nothing on meals, boom segments or the entry ceiling.
- **Blocked:** nothing — built with the defaults in parentheses; each is a one-line change.
- **Candidates:** REQ-14, REQ-11.
- **Owner:** product
- **Workaround, if any:** the defaults above.
- **Status:** open

## 13. What this spec deliberately does not specify

- **Removing customer-signature steps from 3rd-man / support-load tickets** — out of scope per
  `intent.md` §5, requester's own words: "leave this as-is." No REQ touches it.
- **Dispatcher option for two people on one truck, and a separate ticket when one reports to
  site on their own** — out of scope per `intent.md` §5; discussed on the record but not
  decided (2026-05-14 10:12, 12:17, 14:47).
- **Oiler adding a fill-in / temp employee to their ticket** — out of scope per `intent.md` §5;
  discussed (2026-06-04 1:00:53, 1:02:28) but not decided.
- **Vendor-employee crews** — out of scope per `intent.md` §5; no source says how a vendor
  Oiler/Operator pair tickets.
- **Any change to the 14-step / 9-step step set, lunch rules, or craft-modifier brackets** —
  out of scope per `intent.md` §5; only *whose* ticket it is changes.
- **Legacy FCC ticket import** — out of scope per `intent.md` §5.
- **Operator visibility beyond step status** (signatures, checklists, comments) on the shared
  ticket — deliberately deferred to the client as the non-blocking residual **Q5**; REQ-16
  ships the status-only default regardless of how Q5 is later answered.
- ~~Per-employee start/end time overrides~~ — **no longer deferred: BUILT under TCG-25** (REQ-14;
  source TCG-25 (Brian Petros, transcript 2026-03-03 32:51: ticket-level times shared, the labor entry's start/stop and craft code modifier unique per employee; Corrina Bustos: "one time card for the job ticket, but each have their own line"; transcript 2026-05-21 9:27: the Oiler picks which employee he enters for; transcript 2026-05-19 34:03)). Still not specified: whether lunch/meal windows should also be per employee
  (kept shared), and whether boom segments should be clipped to an employee's own window (they
  are not).
- **The final Prisma model name for `ticket_employees`** — `TicketEmployee` is the convention
  suggestion (REQ-13); confirming it against team naming convention is left to the executor.
- **Sets with more than two personnel seats, or a set with two Oiler allocations** — the Q4
  resolution's rule ("if an Oiler allocation exists…") does not say how two Oiler allocations in
  one set would resolve, because no set produces that configuration today; the decision names
  this as a new question if DAS ever does.
- **Which `EmployeeType` names other than `Third Man` count as support-load drivers** — raised
  by `intent.md` §10 as its own open item, but does not block this ticket (REQ-12: support-load
  ticketing is unchanged), so not escalated to §12.
- Everything the morning product decision left open (3rd-man customer signatures, the
  dispatcher two-in-a-truck option, fill-in/temp crew, vendor crews) stays open — unaffected by
  this pass.

## 14. Sign-off before build

- [ ] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` — n/a, no
      `[CONFLICT]` requirements in this spec
- [ ] Answers written back into `spec.md` with their new sources and flags
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [ ] Every §11a ripple row has a source for what happens to that consumer, or a §12 question
- [ ] Decomposed into vertical units — `units.md`

Answered by: ______________  Date: ______________

# Intent — SCRUM-CREW-TICKET

One job ticket per asset group per day. When a crane set carries an Oiler and an Operator,
the Oiler's ticket is the only ticket — the Operator is a second employee on it with a
separate labor record — instead of today's two rows (the Operator's a read-only copy linked
by `primaryTicketId`).

No Jira ticket exists yet; the Atlassian connector is not authorised in this session. The
folder is named `SCRUM-CREW-TICKET` so the `SCRUM-*` open-question sweep
(`grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md`) still finds it — the same
device as `SCRUM-PENDING` and `SCRUM-TZ`. Rename the folder when a Jira key is minted.

---

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-CREW-TICKET` — no Jira issue; folder name only |
| Title | One ticket per asset group — Oiler primary with the Operator on the same ticket; Operator primary when no Oiler |
| Type | Story |
| Status | Not tracked in Jira |
| Epic | `NOT ON TICKET` |
| Sprint | `NOT ON TICKET` |
| Reporter | Syed Haris (`irtazafayaz@gmail.com` session) — stated directly in a working session |
| Assignee | `NOT ON TICKET` |
| Captured on | `2026-09-14` |
| Captured by | Claude (Opus), from the session request and the sources the requester named |

Requested in-session, not through Jira. Everything below is a snapshot of that request.

## 2. Business intent

- Intent: Match the ticket model to how TCG dispatches and pays crews. A crane set that goes
  out with an Oiler and an Operator is **one crew on one ticket** — the Oiler drives the
  crane, does the paperwork, collects the customer's signatures and enters both employees'
  time; the Operator drives the operator load and does no paperwork. Cranes that go out
  with an Operator only (the 22 T – 60 T units on the approved sheet) have the Operator
  fill the ticket. Each support / counterweight load is its own asset group with its own
  ticket. Today the platform mints one ticket **per allocated person** and then links the
  Operator's row to the Oiler's as a read-only mirror (PR #561, 2026-09-12) — a shape built
  provisionally "to get the verdict". The verdict is in: the sources below say one ticket.
- Who benefits (role): field crew (Oiler enters one ticket, Operator has nothing to fill),
  dispatcher (one ticket per asset group, as on the approved sheet), payroll / accounting
  (labor still priced per employee, one ticket to verify per crane per day).
- What is worse today without it: two ticket rows per crew where the record says one;
  mirrored time entries and step completions kept in sync by code; an Operator who is sent a
  ticket they cannot act on; Progress Tracking that has to explain the copy; and a schema
  that cannot hold FCC's `EmpID` + `OilerEmpID` on one ticket when legacy tickets are
  imported.

## 3. Definition of done, as the ticket states it

Requested verbally in-session; the requester's own words, verbatim:

```
there should be only 1 ticket, not two ticket
And rule you can verify from this sheet ASSETS_DISPATCH_(Lisette-approved).xlsx in download
in some ticket only oiler with operator so he's primary and when only operator so he will
be fillling the ticket
[…] write units for this change, the view should be updated on the mobile app and job
trackign as well
for now No customer signature steps on those tickets (Melissa 05-19 42:09, 06-04 15:22).
leave this as-is
```

The requirement as verified this session (recording 2026-05-14 lines 82–114, the approved
sheet's *Job Ticket / Employee Type / Fills In-Completes Ticket / Has Separate Labor Hours*
columns, and the 05-19, 05-21, 06-04 calls) is recorded in the decision note
`vault/decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` written by `tcg-scrum` this session. The
elaborator cites that note, not this file.

- Acceptance criteria present on the ticket: no — verbal request
- If no: `OPEN — no Jira ticket; the decision note is the acceptance source until one exists`

## 4. In scope

- [ ] A `JobTicket` is minted per **asset group** per scheduled day: the crane set (crane +
      operator-load trailer + tractor) is one group; every support / counterweight load is
      its own group. Never one per employee.
- [ ] A ticket carries **its employees** (one or more) with exactly one **primary**. Crane
      set with an Oiler seat → Oiler primary, Operator secondary. Crane set with no Oiler
      → Operator primary, alone. Support load → its driver (3rd man / rigger) primary, alone.
      Determined by the **seat on the allocation**, not by crane tonnage.
- [ ] The secondary employee (Operator) has **no ticket of their own**: no accept / start /
      step / signature / submit. The Oiler's WTL authorisation covers the crew.
- [ ] The Operator's labor is a **separate labor record on the same ticket**, entered by the
      Oiler — the Oiler picks which employee a time / labor entry is for ("there's a separate
      field", 2026-05-21 9:27). Payroll prices per employee labor record, not per ticket.
- [ ] Mobile (`apps/mobile` field persona): the Oiler's ticket shows both crew members and
      lets the Oiler enter time / Labor & Unit for each; the Operator's Jobs list and Home
      show the crew ticket as **the Oiler's ticket they are on**, not a ticket assigned to
      them (the current "crew copy" banner / *View ticket* shape is replaced, not kept).
- [ ] Web Job Tracking / Progress Tracking (`apps/web/src/features/ticket-progress`,
      job-progress API): one row per ticket per asset group, listing its employees, primary
      marked; the 14-step Oiler flow on the crew ticket; no "copy" rows.
- [ ] DAS / dispatch views that list tickets: one ticket per asset group; where they list
      people, list the ticket's employees.
- [ ] Retire `JobTicket.primaryTicketId` and the `linkCrewTickets` mirroring
      (`apps/api/src/usecase/job-tickets/job-tickets.service.ts`), with a migration that
      collapses existing linked pairs into one ticket + two employees for live tickets.
- [ ] Payroll export / weekly payroll continue to yield one labor line per employee.

## 5. Out of scope

- [ ] **Removing customer-signature steps from 3rd-man / support-load tickets** (Melissa
      2026-05-19 42:09, 2026-06-04 15:22). Requester: "for now … leave this as-is".
- [ ] Dispatcher option to seat two people on one truck, and the "separate ticket when one
      reports to site on their own" case (2026-05-14 10:12, 12:17, 14:47). Dispatch-side
      allocation change; not decided.
- [ ] Oiler adding a fill-in / temp employee to their ticket (2026-06-04 1:00:53, 1:02:28).
      Discussed, not decided.
- [ ] Vendor-employee crews (`vendorEmployeeId`) — no source says how a vendor Oiler /
      Operator pair tickets.
- [ ] Any change to the 14-step / 9-step step set itself, lunch rules, or craft-modifier
      brackets. Only *whose* ticket it is changes.
- [ ] Legacy FCC ticket import.

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | yes | ticket minting per asset group; ticket-employees; per-employee labor / time capture; field-tickets and job-progress DTOs; DAS ticket listing; payroll export |
| `apps/api/prisma` (schema + migration) | yes | `JobTicket` no longer one-per-allocation; new ticket-employees relation with primary flag; time / labor entries keyed by employee; drop `primaryTicketId`; data migration for live linked pairs |
| `apps/web` (Next.js — atoms → pages) | yes | Progress / Job Tracking rows and detail; DAS ticket views; any place that renders `primaryTicketId` / crew copy |
| `apps/mobile` (Expo Router) | yes | field persona Jobs / Home / ticket detail / labor step: crew members on one ticket, Operator has no own ticket |
| `packages/shared` (types shared across apps) | yes | ticket / progress / labor DTO types |

Notes for the elaborator:

- A `yes` on `apps/api/prisma` means a committed migration under
  `apps/api/prisma/migrations/` is mandatory (`.ai/claude/contexts/prisma.md`), and
  `tcg-prisma-guardian` must run — this change touches tenancy-scoped tables.
- `packages/shared` moves → run `tcg-contract-tracer`; web and mobile are both downstream.

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `JobTicket` | `ticketCode` / `LEM` sequence (see `getNextValue('LEM')` in `job-tickets.service.spec.ts`) | changes cardinality: one per asset group per day; reads code as today |
| `JobTicket.primaryTicketId` (self-FK, migration `20260912120000_add_job_ticket_primary_ticket`) | — | retires |
| *new* ticket-employees join (name `OPEN`) | none | creates — employee, primary flag, per-ticket |
| `TicketTimeEntry` | none | `OPEN — today keyed by ticket only; needs the employee it is for` |
| `TicketStepCompletion`, `TicketSignature` | none | stay per ticket (the primary completes them) |
| `DasAllocation` (`allocationId` on the ticket) | — | `OPEN — a ticket now spans several allocations (Oiler seat + Operator seat); which becomes the ticket's anchor, or is it the set?` |
| `Employee` / `EmployeeType` (`Oiler`, `Operator` — `OILER_TYPE_NAME`, `OPERATOR_TYPE_NAME` in `@tcg/shared`) | — | reads to pick the primary |

- New entity introduced by this ticket: yes — the ticket-employees relation
- New code prefix introduced: no
- Existing rows affected (backfill / migration of data, not just schema): yes — live linked
  pairs (PENDING / SENT / IN_PROGRESS) collapse into one ticket; COMPLETE tickets:
  `OPEN — migrate or leave as two rows?`

## 8. Roles and permissions

- Roles that can perform this: the ticket's **primary employee** writes; a secondary
  employee reads their own crew ticket (source: FR-TCG-FOP-001 §4.1 — Operator "access app
  and view job information" ✓). Dispatch / admin read as today.
- Roles explicitly excluded: the secondary employee cannot write to the ticket.
- Tenant scope: standard per-tenant isolation.

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | `NOT ON TICKET` — no new screens; existing mobile ticket / labor step and web Progress Tracking change content |
| Jira attachments | `N/A — no Jira issue` |
| Related tickets | `SCRUM-249` — DAS per-day ticket creation, Done; its AC 2 "against all employees that had allocations" is what this supersedes · `SCRUM-877` — Labor & Unit fields on the ticket (U3/U5) · PR #561 / #568 — the read-only-copy build being replaced |
| Existing repo docs | `apps/api/src/usecase/job-tickets/job-tickets.service.ts` → `linkCrewTickets`, `getTicketForEmployeeAction`; `apps/mobile/data/compose-ticket-detail.ts` → `getVisibleSteps`; `apps/api/src/usecase/job-progress/derive-ticket-progress-view.ts` |
| Vault area the reader thinks is relevant | `decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md` (the decision) · `field-ops/gaps.md` → *Who fills the ticket* (closed by it) · `field-ops/frd-new-format-draft/04-role-responsibility-model.md` · `field-ops/e-ticket-worked-example-44944.md` (one FCC ticket, two labor entries) · `dispatch/fcc-nexgen-dispatch-guide.md` §5 (Primary Employee, secondary copy) · `payroll/tcg-rawfms-staging-database/ddl/stg.FMS_JOB_TICKET_EMP_UNIT_Raw.sql` (the legacy shape) · spreadsheet `ASSETS_DISPATCH_(Lisette-approved).xlsx`, sheet `ASSETS_DISPATCH_May21`, not in the vault |

## 10. Terms used that may not be defined

- **asset group** — used as: *"one ticket per asset group"*; the sheet's header defines it:
  "either the main mobile crane (with primary tractor/trailer) or additional tractor/trailer
  combo". Maps to a DAS **set** (`setResourceId`) — `OPEN — confirm a set is exactly one asset group`.
- **primary** — used as: *"only oiler with operator so he's primary"*; FCC's `Primary
  Employee` checkbox / `PrimaryEmp` bit.
- **crew ticket / crew copy** — the shape PR #561 built; retired by this ticket.
- **3rd man / rigger** — the sheet's employee type for support-load drivers; the code has
  `THIRD_MAN_TYPE_NAME = 'Third Man'` (`packages/shared/src/constants/employee-types.ts`).
  Support-load ticketing is unchanged by this ticket, so no question.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| One ticket per asset group per **day**, where a day may extend past midnight | sheet header note, `ASSETS_DISPATCH_May21` R3C27 |
| Operator-only cranes on the sheet: 2204, SL01–04, 4001–4004, 4005, 6002; Oiler cranes: RT9001, 9001, 10001, 11001, 14001, 19001, 20001, 26502, 27501, 35001, 36001, 55001 | sheet rows — **examples of current assets, not a tonnage rule**; the rule is the seat on the allocation |
| Oiler ticket: 14 steps; everyone else: 9 | decision `2026-09-11-progress-timeline-follows-the-real-mobile-flow-with-schedule-times.md` — unchanged by this ticket |
| Tickets sent at end of day once the job is confirmed; ticket starts at lead time | recording 2026-05-14 11:06, 11:30 — already how `send` works; not changed here |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: 4 — Epic, Sprint, Assignee, Design handoff
- Fields left as `OPEN`: 6 — acceptance-criteria source; ticket-employees model name;
  `TicketTimeEntry` per-employee keying; which allocation anchors a multi-seat ticket;
  COMPLETE-ticket migration; set = asset group; support-driver employee-type names
- Is this ticket, as written, buildable without a product answer? **Partly.** The *who is
  primary / one ticket* rule is decided and sourced. The data-model questions above are
  engineering decisions the elaborator can settle from the code and `contexts/prisma.md`,
  except:
- If no, the blocking questions are:
  1. Does a secondary (Operator) need to **accept** the crew ticket, or is acceptance the
     Oiler's alone? The decision records "no active Operator step"; the send / accept flow
     today is per ticket per employee. Assume Oiler-only unless the elaborator finds a source.
  2. Should the Operator see the crew ticket's signatures / checklists, or only step status
     (today: status only)? No source. Carry to spec §12.
  3. COMPLETE linked pairs: migrate into one ticket or freeze as history? Payroll has
     already priced them.

---

**Next step:** run the elaborator (`.ai/aidlc/agents/inception/tcg-elaborator.md`) against this file.
It produces `spec.md` beside it and then stops to ask its questions. It will not implement.

# Intent — HOLDOVER-PAYROLL

> Captured from the developer's finalized plan (no Jira/Linear ticket — internal change, path A).
> This file captures **what was asked for**. It is not a spec and not a design. Nothing here is
> sourced from the vault yet — that happens in `spec.md`. Repo facts below were checked against the
> files on 2026-10-26 and are marked *(checked)*; the brief's own claims are marked *(brief)*.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `HOLDOVER-PAYROLL` (named folder) — Trello #108 (`p2FpbQZw`), "Payroll: update the Payroll module for the holdover changes", In Progress, assignee Ali (card is a one-liner; no comments/attachments) |
| Title | Make payroll honour "holdover" and add a holdover review batch |
| Type | Task (path A: new payroll behaviour plus a pay-rule change) |
| Status | NOT ON TICKET — no ticket exists |
| Epic | NOT ON TICKET. Follow-on to `TICKET-FLOW-SLOTS-HOLDOVER` (`.ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/`), which shipped the holdover ticket flow and the three REQ-15 flag exemptions |
| Sprint | NOT ON TICKET |
| Reporter | Developer plan relayed by the calling agent (requester: user of this session) |
| Assignee | NOT ON TICKET |
| Captured on | 2026-10-26 |
| Captured by | tcg-elaborator, from the finalized plan in the invoking prompt |

## 2. Business intent

- Intent: *(brief)* A holdover is a multi-day run where a crane/crew stays on site overnight, one
  field ticket per day, linked by an Oiler slot. Payroll does not know about it: the paid window,
  the review screen and the correction editor all treat a holdover day like a normal yard-to-yard
  day. Make payroll price, show and correct holdover days correctly, and give payroll staff one
  place to see a week's holdover tickets.
- Who benefits (role): accounting / payroll (Payroll Manager, Payroll Admin).
- What is worse today without it: *(brief)* a Home-start Day-2+ ticket has no Left Yard and no
  Arrive Yard, so the paid window and the 24-hour check are judged on a yard leg that does not
  exist; the correction editor shows yard fields that are meaningless on those days; payroll cannot
  see which tickets are holdover days or whether a Day-2+ day-start was ever recorded.
  *(checked)* `apps/web/src/features/payroll`, `payroll-corrections` and `payroll-flags` contain no
  holdover read at all (`grep -rn 'holdover' -i` returned only the unrelated job subsistence card).

## 3. Definition of done, as the ticket states it

No ticket. The plan states these outcomes verbatim (quoted from the invoking prompt):

```
PART 1 — Payroll time math:
- Add a holdover field to the engine input PayrollJobDayInput (packages/payroll-engine/src/types.ts),
  sourced in the week assembler PayWeekAssembler (apps/api/src/usecase/payroll-pricing/pay-week-assembly.ts).
  Response-shape change (G5) → contract-tracer, callers fixed same unit.
- Window-close precedence when break-down is skipped (PAY RULE, G4): holdover window END =
  break-down end if a break-down is recorded; ELSE boom end if a boom session is recorded
  (build-up + boom, no break-down); ELSE build-up end (no boom, no break-down).
- Home-start days ONLY: no Left-Yard/travel segment; paid window = Arrive On Site → Left Job Site
  (verified decision .ai/vault/decisions/2026-10-16-home-start-holdover-paid-time-boundary.md).
  Yard-start Day-2+ holdover days keep the normal yard-to-yard boundary.
- Subsistence PAY-049 "every calendar day" DEFERRED — leave worked-day subsistenceHoldover
  unchanged; record the deferral in .ai/vault/payroll/gaps.md.

PART 2 — Holdover batch (DISPLAY ONLY) on the employee timesheet page
(apps/web/src/app/(protected)/payroll/[employeeId]/page.tsx → PayrollEmployeeTimesheet; hook
use-payroll-employee.ts). Group the week's holdover tickets (Day d of D); each shows Clean or
Flagged DERIVED FOR DISPLAY (like payroll-status-chip.tsx resolveEntryStatus). Flagged = Day-2+
holdover ticket with no dayStartFrom; else Clean. INFORMATIONAL ONLY — no new PayrollFlag/detector,
must NOT block approval/export. Summary chip mirrors components/organisms/entity-photos/photo-batch.ts;
worklist row gets only a small holdover count badge.

PART 3 — Flags on holdover (per resolved spec Q8): do NOT add holdover special-casing beyond the
three detectors REQ-15 already covers. Part 1's window-math fix is what stops INVALID_TIME_24H_OR_MORE,
INVALID_LONG_BOOM_TIME and INVALID_TIME_MISSING_START_OR_END (non-yard rows) mis-firing. During build,
confirm no YARD_TIME/window reader false-positives on holdover tickets; change one only if it still
mis-fires, and record it as a finding. MISSING_NOTES: no change. One cleanup: carry holdoverMidDay
through withPricedRest (payroll-flag-rest-gap.ts:50-65).

PART 4 — Correction editor ("Adjust Entries" = shared CorrectionDialog in payroll-corrections; NOT
payroll-entry-fixes; same dialog corrects a returned entry). Send-back popup (payroll-send-back-dialog.tsx,
send-back-ticket.dto.ts) is time-agnostic — DO NOT change. On a HOME-START holdover day ONLY: HIDE
leftYardAt + arrivedYardAt in correction-form.parts.tsx (TIME_FIELDS) / correction-times-section.tsx;
make arrivedOnSiteAt/leftJobSiteAt the load-bearing pay-boundary fields; keep jobStart/endJob/boom/lunch;
holdover variant of the usesOwnWindow footnote. API: plan-correction.ts setWindow(YARD_TIME,…) must NOT
create a yard leg (lines 133-143,170); correction-rules.ts CORRECTION_ORDER must not enforce the yard chain
for that day. Plumb a holdover+Home-start flag through CorrectionTimes/SubmitCorrectionPayload
(apps/web/src/features/payroll/services/payroll-send-backs.service.ts).
```

- Acceptance criteria present on the ticket: **no** — there is no ticket.
- `OPEN — no ticket exists; per domain/jira-sop.md it does not meet Definition of Ready.` Treated
  as accepted for an internal change: the outcomes above stand in for acceptance criteria, and
  `spec.md` §2 turns each into a testable line.

## 4. In scope

- [ ] `PayrollJobDayInput` gains a holdover field, sourced in `PayWeekAssembler` from the same
      server source the field ticket uses (Part 1).
- [ ] Holdover paid-window END precedence: break-down end → boom end → build-up end (Part 1, PAY RULE).
- [ ] Home-start holdover days: paid window Arrive On Site → Left Job Site, no yard leg (Part 1).
- [ ] PAY-049 per-calendar-day subsistence deferral recorded in `payroll/gaps.md` (Part 1).
- [ ] Holdover batch on the employee timesheet page: grouped "Day d of D", Clean/Flagged derived
      for display, summary chip, plus a holdover count badge on the worklist row (Part 2).
- [ ] Part 3 flag work: window math only, build-time confirmation of YARD_TIME/window readers,
      `holdoverMidDay` carried through `withPricedRest`.
- [ ] Correction editor on Home-start holdover days: yard fields hidden, API never creates a yard
      leg, order chain does not enforce the yard (Part 4).
- [ ] Provenance rows in `payroll/payroll-rules-provenance.md` for the two pay rules (G4).

## 5. Out of scope

- [ ] Any new `PayrollFlag` code or detector; anything that blocks approval or export on holdover.
- [ ] PAY-049 "every calendar day of the holdover, worked or not" subsistence (deferred).
- [ ] Changing the send-back popup (`payroll-send-back-dialog.tsx`, `send-back-ticket.dto.ts`).
- [ ] `payroll-entry-fixes` (a separate correction path from the shared CorrectionDialog).
- [ ] `MISSING_NOTES` behaviour on holdover.
- [ ] Mobile: it never submits a holdover flag and is not changed.
- [ ] New tests (root `CLAUDE.md`: none unless the developer asks).
- [ ] Worked-day subsistence paying ($85 / $200, worked days only) — owned by TCG-162. What makes something a holdover (quote flag, one-day job becoming holdover) — upstream TCG-221 / TCG-222. (Added 2026-10-26 from the Trello reconciliation; see spec §11.)
- [ ] Yard-start Day-2+ days: keep the normal yard-to-yard boundary *(brief)* — see spec Q1 for where
      the window-close precedence does and does not reach.

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | yes | Week assembler window + holdover source; employee-week/roster payload gains holdover fields; correction read/plan/rules; module DI |
| `apps/api/prisma` (schema + migration) | no *(brief; to be confirmed in spec §3)* | Holdover is derived, never stored (`packages/shared/src/constants/ticket-holdover.ts`) |
| `apps/web` (Next.js — atoms → pages) | yes | Timesheet page batch, worklist badge, correction form |
| `apps/mobile` (Expo Router) | no | Mobile never submits a holdover flag |
| `packages/shared` (types shared across apps) | ? | `FieldTicketHoldover` already exported; a payroll display type may be added or reused — a §11b decision |
| `packages/payroll-engine` | yes | `PayrollJobDayInput` gains a field (G5) |

Notes for the elaborator: `packages/payroll-engine` is consumed by api, web and mobile
*(checked: `grep -rln 'payroll-engine' apps packages`)*.

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `JobTicket` | `ticketCode` | reads (`dayStartFrom`, `dayStartAt`) |
| `JobResource` / `JobResourceAllocation` | — | reads `isHoldover` (the trigger) |
| `TicketTimeEntry` | — | reads (`YARD_TIME`, `JOB_SITE_TIME`, `WORK_TIME`, `BUILDUP_TIME`, `BOOM_TIME`, `BREAKDOWN_TIME`) |
| `PayrollJobDay` | — | reads |

- New entity introduced by this ticket: no
- New code prefix introduced: no
- Existing rows affected (backfill / migration of data, not just schema): no — a recalculation
  re-prices existing weeks when the window rule changes; that is a rollout question in spec §11.

## 8. Roles and permissions

- Roles that can perform this: NOT ON TICKET. Existing gates apply — Payroll Manager
  (`payroll:edit`) and Payroll Admin (`payroll-admin:edit`) reach the correction dialog
  (`vault/decisions/2026-10-22-unify-adjust-entries-on-corrections-dialog.md`).
- Roles explicitly excluded: NOT ON TICKET.
- Tenant scope: standard per-tenant isolation.

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | NOT ON TICKET |
| Jira attachments | N/A — no ticket |
| Related tickets | `TICKET-FLOW-SLOTS-HOLDOVER` — shipped the holdover flow; its spec is `[UNVERIFIED]`, cite as provisional |
| Existing repo docs | `.ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/spec.md` (REQ-07, REQ-09, REQ-15, §12 Q5, Q8) |
| Vault area the reader thinks is relevant | `payroll/gaps.md` → *Holdover days 2+*; `decisions/2026-10-16-home-start-holdover-paid-time-boundary.md`; `decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md`; `payroll/payroll-rules-provenance.md` |

## 10. Terms used that may not be defined

- **Holdover** — "a multi-day run where a crane/crew stays on site overnight; one field ticket per
  day, linked by an Oiler slot". Not the same fact as payroll's `Job.subsistenceHoldover`
  (`payroll/gaps.md` → *DAS holdover vs subsistence holdover — pointer*).
- **Home-start** — "A day is 'Home-start' when dayStartFrom = HOME."
- **Yard-start** — "Yard-start Day-2+ holdover days keep the normal yard-to-yard boundary."
- **Load-bearing pay-boundary fields** — "make arrivedOnSiteAt/leftJobSiteAt the load-bearing
  pay-boundary fields". Meaning in the UI is not defined (see spec REQ-08).
- Known-undefined terms the plan touches: `build-up`, `boom-time`, `comp-code`.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| Window END precedence: break-down end → boom end → build-up end | *(brief)* "PAY RULE, G4" — **no vault or decision source cited**; the invoking plan is the only origin |
| Home-start paid time = Arrive On Site → Left Job Site | `.ai/vault/decisions/2026-10-16-home-start-holdover-paid-time-boundary.md` (verified) |
| Flagged = Day-2+ holdover ticket with no `dayStartFrom` | *(brief)* — no cited origin; display rule |
| 24h threshold (`INVALID_TIME_24H_OR_MORE`) | not restated by the plan; lives in `payroll-flag-invalid-times.ts` (`LONG_WORK_WINDOW_HOURS`) |
| Statuses `Clean` / `Flagged` | *(brief)* mirrors `payroll-status-chip.tsx`; no cited origin for the labels on this batch |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: 11 — Status, Epic (partly), Sprint, Assignee, Design handoff,
  roles permitted, roles excluded, plus the origin of the precedence rule, of the Flagged
  definition, of the batch labels, of "load-bearing".
- Fields left as `OPEN`: 1 — acceptance criteria (no ticket).
- Is this ticket, as written, buildable without a product answer? **no** — see below.
- The blocking questions the elaborator carried into `spec.md` §12 are Q1, Q2 and Q3 (the
  precedence rule's reach per holdover day, how it composes with the Home-start boundary, and
  whether non-payroll readers of the ticket's paid window follow). Q4–Q11 record decisions the
  plan already made; they are resolved, not open.

---

**Next step:** `spec.md` beside this file is the elaborator's output. It stops at §12 Q1–Q3.

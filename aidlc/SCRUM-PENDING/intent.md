# Intent — SCRUM-PENDING

Weekly payroll shows only completed tickets. This ticket asks it to show assigned tickets
that are not finished — not started, in flight, or scheduled and never started.

No Jira ticket exists and none is expected. The folder is named `SCRUM-PENDING` so the
`SCRUM-*` open-question sweep
(`grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md`) still finds it — the same
device as `SCRUM-TZ`.

---

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-PENDING` — no Jira issue; folder name only |
| Title | Show pending and in-progress tickets in weekly payroll |
| Type | Story |
| Status | Not tracked in Jira |
| Epic | `NOT ON TICKET` |
| Sprint | `NOT ON TICKET` |
| Reporter | Syed Haris (`syedharis14@gmail.com`) — stated directly in a working session |
| Assignee | `NOT ON TICKET` |
| Captured on | `2026-09-10` |
| Captured by | Mohsin Akram, from the session request |

Requested in-session, not through Jira. Everything below is a snapshot of that request.

## 2. Business intent

`NOT ON TICKET` as stated in business terms. The request describes a screen change without
saying what it is for.

The most likely reading — **and it is a reading, not a sourced requirement, so the elaborator
must confirm or discard it** — is missing-labor detection before a period is processed: a
payroll clerk cannot currently tell the difference between "this employee had no work that
day" and "this employee has a ticket nobody finished", because both render as an absent row.
The incumbent system has a report for exactly this shape
(`vault/payroll/fcc-nexgen-payroll-processing.md` §4, *Tickets Not Completed* —
"Incomplete tickets — another route to missing labor"), which is evidence that the need is
real but is **not** evidence of what this ticket wants.

- Intent: `OPEN — what is this for? Chasing unfinished tickets before processing a period, live dispatch visibility, or something else? The answer changes whether this belongs on the timesheet at all.`
- Who benefits (role): `OPEN — payroll clerk, dispatcher, or both?`
- What is worse today without it: `NOT ON TICKET`

## 3. Definition of done, as the ticket states it

Verbatim, including the typos and the trailing incomplete sentence:

```
payroll currently showing aly that payrools who are completed it should show allincluding
pending payrolls as well like

if ticet is not started bust assigned it should show entery in weekly payroll with status
ticket is not started yet

if ticket is started it should and currently is at any phase of

  YARD_TIME
  JOB_SITE_TIME
  WORK_AT_JOB_SITE_TIME
  WORK_TIME
  LUNCH
  WTL
  BREAKDOWN_TIME
  BUILDUP_TIME
  BOOM_TIME

it will show currently locked hours with status of inpreogress with exect phase where is
currrently now like currently started buildup or completetd job and left job site etc with
locked all previous hours

if ticket is not started and ticket end time passes it will show ticket time passed or
someting like ticket
```

The enum list was supplied as an IDE selection from
`apps/api/prisma/schema.prisma:4654-4669` (`TicketTimeEntryType`), so the phases named are
the real enum members, not an invented set.

- Acceptance criteria present on the ticket: **no** — the text above is a description, not
  criteria. Nothing states how any of it is verified.
- `OPEN — no acceptance criteria; per domain/jira-sop.md this does not meet Definition of Ready`

## 4. In scope

- [ ] Weekly payroll shows an entry for an assigned ticket that has not been started
- [ ] That entry carries a status meaning "not started yet"
- [ ] Weekly payroll shows an entry for a ticket in flight, with hours accrued so far
- [ ] That entry names the phase the ticket is currently at, drawn from `TicketTimeEntryType`
- [ ] A ticket never started whose end time has passed carries a distinct status
- [ ] Pending entries are display-only — see §11 and the decision cited there

## 5. Out of scope

- [ ] Any change to what is **paid**. Pending entries do not price, do not persist to
      `payroll_job_days`, and do not enter the ADP export — decided, see §11
- [ ] Mobile. The request is about the payroll screen; nothing asks the field app to change
- [ ] Chasing or notifying anyone about an unfinished ticket. Showing it is not reminding
      about it, and the ticket asks only to show it
- [ ] `OPEN — does an unfinished ticket block period approval or ADP submission? Adjacent, load-bearing, and the ticket does not say`

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | yes | A read path that finds assigned-but-unpriced tickets for a period, derives state/phase/elapsed hours, and returns them on the payroll payload |
| `apps/api/prisma` (schema + migration) | no | None. Display-only persists nothing, and the reachability doubt this row carried is closed: `JobResourceAllocation.jobScheduleInterval` is a direct FK (`schema.prisma:3747`) with `date` at `:3550`, so an unstarted ticket can be dated into a week through the existing relations — checked by `tcg-scrum`, 2026-09-10 |
| `apps/web` (Next.js) | yes | The employee timesheet renders these rows; the existing "incomplete" banner likely changes |
| `apps/mobile` (Expo Router) | no | Out of scope, §5 |
| `packages/shared` (types shared across apps) | ? | Only if a status enum is shared rather than API-local |

Notes for the elaborator:

- This adds fields to a payroll API response. `GUIDE.md` §2 makes that an escalation
  trigger on its own — **`tcg-contract-tracer` is mandatory**, whatever the path.
- If `apps/api/prisma` turns out to be `yes`, `tcg-prisma-guardian` is mandatory too.

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `JobTicket` | `ticketCode` / `T-JOB-#####` | reads |
| `TicketTimeEntry` | `N/A` | reads |
| `JobResourceAllocation` | `N/A` | reads — carries `shiftNumber` and the link to the schedule |
| `JobScheduleInterval` | `N/A` | reads — `date`, `estimatedEndTime`, `secondShiftEstimatedEndTime` |
| `PayrollJobDay` | `N/A` | reads only; explicitly **not** written, per §11 |
| `Employee` | `employeeCode` / `EMP-#####` | reads |

- New entity introduced by this ticket: no
- New code prefix introduced: no
- Existing rows affected (backfill / migration of data, not just schema): no

## 8. Roles and permissions

- Roles that can perform this: `NOT ON TICKET` — presumed the same roles that already read
  weekly payroll, since it is the same screen, but the ticket does not say
- Roles explicitly excluded: `NOT ON TICKET`
- Tenant scope: standard per-tenant isolation

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | `NOT ON TICKET` |
| Jira attachments | `N/A — no Jira issue` |
| Related tickets | `SCRUM-926` — built the payroll review screen this changes |
| Existing repo docs | `apps/api/src/usecase/ticket-time-entries/derive-ticket-times.ts` — the one shared derivation of ticket windows and phases |
| Vault area the reader thinks is relevant | `vault/payroll/gaps.md` (week statuses, **open conflict**); `vault/payroll/fcc-nexgen-payroll-processing.md` §4 (*Tickets Not Completed*); `vault/payroll/payable-vs-billable-hours.md` |

## 10. Terms used that may not be defined

- **"locked hours"** — used as: *"it will show currently locked hours"* and *"with locked
  all previous hours"*. Not a term in the vault or the codebase. Read in-session as elapsed
  time already captured, but **the requester was asked to confirm what the figure means and
  redirected to run this loop instead, so it is unconfirmed.**
- **"ticket time passed"** — used as: *"it will show ticket time passed or someting like
  ticket"*. The requester's own phrasing marks this as a placeholder, not a chosen label.
- **"phase"** — used as: *"exect phase where is currrently now"*. `TicketTimeEntryType` is a
  set of captures, not a state machine; several overlap (a `LUNCH` sits inside `WORK_TIME`)
  and `BOOM_TIME` is repeatable. "The phase it is at" is therefore not directly readable
  from the enum. See §12.
- **`build-up`**, **`boom-time`** — both on the known-undefined list in `CLAUDE.md`, and both
  load-bearing here.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| The 9 `TicketTimeEntryType` members | Supplied as an IDE selection from `schema.prisma:4654-4669` — real, and the only sourced value in the request |
| Status label "ticket is not started yet" | `NOT ON TICKET — no origin cited`; phrased as description, not a chosen string |
| Status label "inpreogress" | `NOT ON TICKET — no origin cited` |
| Status label "ticket time passed" | `NOT ON TICKET — no origin cited`; requester wrote "or someting like" |

**Conflict the elaborator must surface rather than settle:** `vault/payroll/gaps.md` (the
*week statuses on the weekly payroll screen* entry) records an unresolved disagreement
between two candidate status sets — *In Progress / Submitted / Processing / Received / Paid*
and *In Progress / Needs Processing / Submitted to ADP / Closed*. Those are **week** statuses
and these are **entry** statuses, so they may not be the same vocabulary at all — but a third
invented set landing on the same screen while that is open is exactly what `GUIDE.md` §3
forbids.

**One decision already exists**, taken in-session on 2026-09-10 and recorded at
[`vault/decisions/2026-09-10-pending-tickets-are-a-display-only-payroll-overlay.md`](../../vault/decisions/2026-09-10-pending-tickets-are-a-display-only-payroll-overlay.md):
pending entries are a **display-only overlay** — computed at read time, never written to
`payroll_job_days`, excluded from the week's money totals, no ADP impact. Same requester and
therefore the same attribution weakness as the `SCRUM-TZ` decisions: a developer/owner
answer, not the TCG payroll owner's.

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: **9** — business intent, beneficiary, what is worse today,
  epic, sprint, assignee, roles (×2), design handoff, and 3 of the 4 status labels
- Fields left as `OPEN`: **4** — what the feature is for, who benefits, whether it blocks
  approval/ADP, and the missing acceptance criteria
- Is this ticket, as written, buildable without a product answer? **no**
- The blocking questions:
  1. **What is "locked hours"?** Elapsed clock time, or a priced ST/OT/DT split? The
     requester was asked and deferred to this loop. Note the technical constraint the
     elaborator should carry into the spec: PAY-040, PAY-043 and PAY-045 only resolve at
     end of shift, so a partial shift's priced answer is **not** a prefix of its finished
     answer — a two-hour shift shows 2.0h but pays 4.0h if it ends there, and a
     retrospectively logged lunch makes the figure fall.
  2. **What are the entry statuses called?** Blocked behind the open week-status conflict
     above. Three labels are needed and none is sourced.
  3. **How is "the current phase" derived** when `TicketTimeEntryType` members overlap and
     `BOOM_TIME` repeats? Latest-started open capture, or something else?
  4. **Which week does an unstarted ticket belong to?** It has no time captures, so the
     existing rule (the `WORK_TIME` capture dates the ticket) cannot apply.
     `JobScheduleInterval.date` is the obvious candidate and is unsourced.
  5. **When has "ticket end time" passed?** `JobScheduleInterval.estimatedEndTime` /
     `secondShiftEstimatedEndTime` are `VarChar(8)` clock strings needing a date and a zone
     to become an instant; which zone is settled by
     `vault/decisions/2026-09-09-business-timezone-is-a-tenant-property.md`, but that the
     *estimated* end is the right edge to test is not.
  6. **Does an unfinished ticket block period approval or ADP submission?** Three positions
     on this already exist in the codebase and must be reconciled, not merely chosen between
     — found by `tcg-scrum`, 2026-09-10:
     - the **shipped UI** asserts it is blocked: *"This week cannot be fully approved until
       all daily tickets are completed"* (`payroll-employee-daily.tsx:91`)
     - the **API enforces nothing** — `approveEmployee` (`payroll.service.ts:317`) and
       `approvePeriod` (`:324`) apply no completeness gate, and a `FLAGGED` week approves
     - the **2026-09-10 decision** says warn, and leaves it open
  7. **Does the existing incomplete banner change?** `missingDayLabels`
     (`payroll-employee.helpers.ts:97`) counts only priced `jobDays`, so a day showing an
     in-flight ticket will still be named in *"has not submitted a ticket for …"*. The
     overlay does not fix that banner by existing. Related: §5 puts chasing out of scope
     while a **Send Reminder** button already ships beside that banner
     (`payroll-employee-daily.tsx:95`).
  8. **Which ticket statuses count as "assigned"?** `JobTicketStatus` has `PENDING`, `SENT`,
     `IN_PROGRESS`, `COMPLETE`, `REJECTED`, `CANCELLED`. A `REJECTED` ticket is presumably
     not owed payroll visibility; the ticket does not say.

---

**Next step:** run the elaborator (`.ai/aidlc/agents/inception/tcg-elaborator.md`) against
this file. It produces `spec.md` beside it and then stops to ask. It will not implement.

---
title: "Crew Start/End Work mismatch flag (any difference); only the 2nd+ missed-lunch penalty moves the rest start; Samsara start-of-ticket and asset-not-home flag ideas — decision"
source: decision/Corrina Bustos (TCG Payroll Manager) — Teams messages, 2026-09-30
decided: 2026-09-30
decided_by: >-
  Corrina Bustos (TCG, Payroll Manager — the payroll owner), in writing, in two Microsoft Teams
  messages to Syed Haris (CodingCops) on 2026-09-30.
  Message A was unprompted, sent *"after discussing with Micaela"* (Micaela, the Payroll
  Administrator per decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md
  clause 2).
  Message B answers three questions Syed Haris sent in reply, and then offers two "New Ideas".
  Clauses 1 and 2 are answers. Clauses 3 and 4 are her proposals ("Could we get…", "can it flag"),
  recorded as requested behaviour. They are payroll-owner requests, but clause 4 falls in dispatch's
  and assets' territory, so its owners there have not spoken.
status: verified
conflicts_with: []
provenance_note: >-
  AMENDED THE SAME DAY by Corrina Bustos's next reply — decisions/2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md.
  Clause 1's compared times are REPLACED: "Start time (very start of job) and End time (back at
  yard)", not "Start work and End Work". The comparison is across ALL members of the job, over their
  separate tickets. Clause 4 gains recipients (Payroll Admin and Payroll Manager, with dispatch
  notified) and a trigger: not time-based; it fires when the asset shuts off at an address other
  than the Los Alamitos or Ventura yard. The holdover exclusion was not restated. Clauses 2 and 3
  are unchanged. Body unchanged; the End Work vs End Job discussion below is superseded by the new
  note's open points.
resolves:
  - "payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives (C2)"
jira: []
tags: [module/payroll, module/assets, module/dispatch, module/field-ops, kind/decision, payroll-review, rest-period, wtl, samsara, yards]
entities: []
---

# Crew time mismatch flag; the first missed lunch does not move the rest start; two new flag ideas

**Why a fourth note, not an extension of the third.** Decision notes are dated the day the decision
was made, and these messages are from 2026-09-30. They are separate written statements. Two of them
propose new flags that reach outside payroll (dispatch and assets). The 2026-09-29 notes stay as the
record of what was settled that day. Where their questions are answered here, their frontmatter
points here.

## The exchange

Corrina Bustos, message A, verbatim:

> "Hi, im discussing with Micaela, for a flag, can we have the system flag the ticket if the start
> and/ or end times for the entire crew do not match"

Syed Haris replied *yes*, and asked:

> "1. Which times should match across the crew: Start Work and End Job, or also Left Yard / Arrived
> Yard?
> 2. Should any difference flag, or only over a margin (e.g. more than 15 minutes)? Some differences
> are normal (e.g. the oiler stays to break down); should those still flag so you can check them?
> 3. On the 8-hour rest: does the first missed lunch penalty also move the rest start, or only the
> second one onward?"

Corrina Bustos, message B, verbatim:

> "Start work and End Work
> any difference.
> no, only the 2nd and onward
> New Ideas:
> Could we get a flag set for the example: leave time on ticket is 630am but samsara does not show
> engine on until 730am.
> so basically the same rules as the end of the ticket for the start of the ticket.
> Flag idea: if an asset is not assigned to a holdover job, and does not return to the home yard
> (whether Los Alamitos or Ventura yard) at the end of the shift, can it flag. This has happened when
> an EE has taken the asset home."

## Decision

1. **Crew time mismatch flag.**
   - A ticket is flagged when crew members' **Start Work** and/or **End Work** times do not match.
   - **Any difference flags. There is no tolerance.** Legitimate differences flag too; she was asked
     about the oiler staying to break down and answered *"any difference"*. Payroll reviews them.
   - Left Yard and Arrived Yard were offered and **not** included.
2. **8-hour rest: only the second and later missed-lunch penalties move the rest start.** The first
   missed lunch's penalty does not. This narrows clause 3 of
   [2026-09-29-invalid-entry-flags-samsara-30-minutes-and-wtl-penalty-moves-rest-start.md](2026-09-29-invalid-entry-flags-samsara-30-minutes-and-wtl-penalty-moves-rest-start.md)
   and closes C2.
   - **It agrees with PAY-047:** the first missed meal's half-hour is *absorbed* (repriced, no hours
     added), and each further missed meal adds a half-hour
     ([../payroll/rules/PAY-047-worked-through-lunch-adjustment.md](../payroll/rules/PAY-047-worked-through-lunch-adjustment.md);
     [../payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md) row
     *Worked-through meal — penalty*).
   - **The consistent reading:** the paid end moves only when hours are actually added.
3. **Requested: a Samsara flag at the start of the ticket, as well as the end.**
   - **Her example:** the ticket's leave time is 6:30 AM, but Samsara shows no engine-on until
     7:30 AM, so flag it.
   - **Her rule:** *"the same rules as the end of the ticket for the start of the ticket."*
4. **Requested: an asset-not-home flag.** Flag when an asset that is **not assigned to a holdover
   job** does not return to its **home yard** (*"Los Alamitos or Ventura yard"*) at the end of the
   shift. Her reason: *"This has happened when an EE has taken the asset home."*

## Our reading, not hers

- **Clause 3 — which rule.** *"The same rules as the end of the ticket"* most plausibly means the
  third 09-29 reply's Samsara rule: flag when a ticket time is more than 30 minutes from the Samsara
  geotag time. Applied to the start, that would compare **Left Yard** with the vehicle's
  **engine-on / first trip start**, with a 30-minute tolerance. **This is CodingCops's inference.**
  She did not name the rule. Her example is 60 minutes off, so it flags under either reading. Open.
- **Clause 1 — End Work vs End Job, a terminology point.**
  - **In code, "End Work" and "End Job" are different captures**
    (`apps/api/prisma/schema.prisma`, `enum TicketTimeEntryType`):
    - *End Work* closes `WORK_AT_JOB_SITE_TIME` (*"Arrived at the job site → End Work. What the
      customer is billed for."*). It is captured when break-down completes
      (`packages/shared/src/types/job-progress.types.ts`, l. 38–39). It is **per ticket**.
    - *End Job* / Review & Complete closes `WORK_TIME` (*"Start Work → Review & Complete. What the
      employee is paid for."*).
  - **Only Start Work and End Job are per employee.** They are held in
    `ticket_employees.work_started_at` / `work_ended_at` (TCG-25; schema comment *"payable window
    (Start Work -> Review & Complete) for THIS employee only"*).
  - **So, as the data stands:**
    - **within one crew ticket,** *End Work* cannot differ between crew members, because it is one
      shared row. Only Start Work and **End Job** can differ.
    - **across tickets,** End Work can differ. That applies where a crew spans separate tickets, such
      as a support load, which is its own ticket per
      [2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md](2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md).
  - **The open question:** does she mean the billable End Work, the paid End Job, or does she not
    distinguish them? The correction form on `main` labels both (*End Work Time*, *End Job Time*), and
    the 09-28 note uses *End Job* for the per-employee end. Not resolved.

## What the code has for clauses 3 and 4 (read 2026-09-30; nothing changed)

- **Samsara.**
  - `apps/api/src/service/samsara/samsara.repository.ts` fetches:
    - vehicle stats (`gps`, `engineStates`, `fuelPercents`);
    - history with `engineStates` events (`fetchHistory`);
    - route points;
    - Samsara's own trip windows (`fetchTrips`).
  - `apps/api/src/usecase/vehicle-tracking/day-times.ts` derives `engineSeconds`, `travelSeconds`
    and `lastHeardAt`.
  - **There are no geofence events.** "Geotag time" and "returned to the home yard" would have to be
    derived from GPS or trip end locations against yard coordinates.
  - **Engine-on instants exist in the event history.** A "first engine-on of the day" is not
    currently exposed as a value.
- **Home yard.**
  - `Asset.yardId` → `Yard` exists.
  - `Yard` has `addresses`, and `Address` has `latitude` / `longitude`.
  - There is no geofence radius.
- **Holdover.** `JobResourceAllocation.isHoldover` is set by Copy Allocations with "Hold over" ticked.
  Whether copying makes a job a holdover is itself open in
  [../dispatch/gaps.md → *Does copying allocations make a job a holdover?*](../dispatch/gaps.md#does-copying-allocations-make-a-job-a-holdover).
- **Ventura.**
  - The vault has **no record of a Ventura yard**. Los Alamitos is recorded as 10850 Portal Dr.
    ([2026-09-15-fix-15-sep-das-and-quotations-as-built.md](2026-09-15-fix-15-sep-das-and-quotations-as-built.md)).
  - The ADP company code `4RY` / *"Crane Guys, LLC - Ventura"*
    ([../payroll/gaps.md](../payroll/gaps.md) → *Ventura — a second ADP company…*) is a payroll
    entity. It is **not** the physical yard, so don't conflate the two.

## What this does NOT decide

- **Clause 1:**
  - End Work vs End Job (above).
  - Whether the flag compares crew members on one ticket only, or across a crew's several tickets.
  - Whether it is a ticket flag, a per-employee payroll flag, or both.
- **Clause 3:**
  - Which "end of ticket" rule applies, and so the tolerance (30 minutes is our inference).
  - Which Samsara signal stands for "leave": first engine-on, trip start, or leaving the yard's
    coordinates.
  - What happens when an asset is untracked or silent.
- **Clause 4:**
  - Who receives the flag: payroll under "all flags", dispatch (Lisette Anzaldo), or operations
    (Kyle Harlow).
  - What "end of the shift" is and when the check runs.
  - How the home yard is defined per asset (`Asset.yardId`?).
  - Where the Ventura yard is.
  - Yard coordinates and radius.
  - What counts as "assigned to a holdover job".
  - Untracked assets.
  - Filed once in [../assets/gaps.md → *Asset not returned to its home yard at end of shift*](../assets/gaps.md#asset-not-returned-to-its-home-yard-at-end-of-shift--a-requested-flag-with-no-owner-no-yard-geometry-and-no-shift-end).

## Build impact

**None of the four clauses is in PR #690 / #691 on `main`.**

- **Clause 1.** A mismatch check can read `ticket_employees.work_started_at` / `work_ended_at`
  directly, for the per-employee Start Work and End Job.
- **Clause 2.** It narrows the not-yet-built PAY-045 gap-start change: only an added WTL half-hour
  (2nd meal onward) extends the paid end.
- **Clauses 3 and 4.** Both need Samsara-derived instants and yard geometry that the tracking module
  does not yet produce.

## Effect on the vault

Done in the same pass:

- **Third 2026-09-29 note:** `provenance_note:` added, saying C2 is answered here: the first missed
  lunch does not move the rest start. **Done.**
- **[PAY-045](../payroll/rules/PAY-045-rest-period-premium.md):** `provenance_note:` extended with
  the same, and the first-meal question marked closed. **Done.**
- **payroll/gaps.md → [*Flagged entries go to payroll…*](../payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives):**
  - C2 closed;
  - new sub-questions Q10 (crew mismatch) and Q11 (Samsara start of ticket);
  - a pointer to the asset-not-home entry.
  
  **Done.**
- **[assets/gaps.md](../assets/gaps.md):** new entry for clause 4. **Done.**
- **[dispatch/gaps.md](../dispatch/gaps.md):** one-line pointer to it. **Done.**

Not done, because file bodies are outside the recording agent's write scope:

- the `payroll/payroll-rules-provenance.md` row *8-hour rest — gap start*;
- the `payroll/INDEX.md` line for this note and its count.

The exact text was handed to the main session.

---
title: "Crew-time flag compares every member's job start and yard return, across tickets; asset-not-home flag fires on engine-off away from the yards — decision"
source: decision/Corrina Bustos (TCG Payroll Manager) — Teams reply, 2026-09-30
decided: 2026-09-30
decided_by: >-
  Corrina Bustos (TCG, Payroll Manager — the payroll owner), in writing, in a Microsoft Teams reply to
  Syed Haris (CodingCops) on 2026-09-30. It answers three follow-ups to her earlier 2026-09-30
  messages (decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md).
  The asset flag (clause 3) touches dispatch and assets. Dispatch's owner (Lisette Anzaldo) and the
  assets owner have not spoken; this is the payroll owner's request.
status: verified
conflicts_with: []
provenance_note: >-
  DEVELOPER READING, same day — decisions/2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md
  (status: reference; Syed Haris, CodingCops; Corrina to ratify at the demo). "Very start of job" =
  Left Yard and "back at yard" = Arrived at Yard, compared across all crew members' tickets. The
  asset flag's rule is "back to the yard it left from that day" (tenant-configured yards; Los
  Alamitos/Ventura were examples; not Asset.yardId), triggered by the last engine shut-off away from
  it. These are NOT Corrina's words. Body unchanged.
supersedes_partial:
  - "decisions/2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md (clause 1: which times are compared — 'Start work and End Work' is replaced; clause 4: recipients and trigger added)"
resolves:
  - "payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives (Q10 (a)(b) in part)"
  - "assets/gaps.md#asset-not-returned-to-its-home-yard-at-end-of-shift--a-requested-flag-with-no-owner-no-yard-geometry-and-no-shift-end (Q1, Q2 in part)"
jira: []
tags: [module/payroll, module/assets, module/dispatch, module/field-ops, kind/decision, payroll-review, samsara, yards]
entities: []
---

# Crew-time flag: job start to yard return, all members; asset flag: engine-off away from the yards

**Why a new note rather than an edit of the earlier 09-30 note.** This reply **replaces** part of
what she said earlier the same day. Her first answer, *"Start work and End Work"*, is changed to
*"Start time (very start of job) and End time (back at yard)"*. A separate note keeps both
statements on record in order. The earlier note's frontmatter points here.

## The exchange

Syed Haris asked (1) and (2), then sent (3):

> (1) "For the crew-time flag, crew members on the same ticket always share one End Work time. Should
> we compare everyone on the job across their separate tickets (e.g. the operator's ticket against a
> support-truck driver's)?"
>
> (2) "For the asset flag, who should receive it (you and Micaela, or Dispatch), and by what time
> should the asset be back before it flags (e.g. midnight)?"
>
> (3) "One more detail on the crew-time flag, so we check the right times. Here's how the app records
> them: • Start Work: safety paperwork done, work on site begins. • Complete Break-down: crane
> teardown finished. This is saved as End Work (end of work on site). • Review & Complete: after the
> crew is back at the yard. This is when the ticket ends. Should the flag compare Start Work and End
> Work (on site), or Start Work and the ticket end (back at the yard)? Only Start Work and the ticket
> end can differ per person on the same ticket; End Work is shared by the crew."

Corrina Bustos, Teams, 2026-09-30, verbatim:

> "yes, all members.
> 2. I would say payroll admin/payroll manager, and dispatch notified. I dont think it would go off a
> time. it would trigger if the asset shut off at address other than the los alamitos or Ventura yard
> addresses.
>
> The flag should compare Start time (very start of job) and End time (back at yard)"

## Decision

1. **The crew-time flag compares all members of the job, across their separate tickets.** It is not
   limited to one ticket. For example, the operator's ticket is compared with a support-truck
   driver's.
2. **The compared times are "Start time (very start of job)" and "End time (back at yard)".**
   - This **replaces** her earlier *"Start work and End Work"* (clause 1 of the earlier 09-30 note).
   - Any difference still flags. That part of the earlier answer was not revisited.
   - She did not pick either option offered in (3) word for word. What she named is below.
3. **Asset-not-home flag.**
   - **Recipients:** the Payroll Admin and Payroll Manager receive it, and **dispatch is notified**.
   - **Trigger:** it is **not time-based**. It fires *"if the asset shut off at address other than
     the los alamitos or Ventura yard addresses"*.
   - **Unchanged:** her earlier exclusion, *"not assigned to a holdover job"*, was not restated here.
     It stands from the earlier note.

## Open — recorded, not resolved

- **What "very start of job" is.** Three candidate captures, none per person except the third:
  - **Left Yard.** This is the literal start of the day's job and fits "very start". It is stored
    **per ticket**.
  - **The Start Work card tap**, the shift clock (`apps/mobile/features/field-ticket/shift-clock.ts`).
    It is display-only and *"deliberately NOT the `startWork` step capture"*, and is synced from
    `timeTracking.startedWorkAt`.
  - **The Start Work step.** It is captured on site after safety paperwork and opens `WORK_TIME`,
    the paid window. This is the only one stored per person: `ticket_employees.work_started_at`,
    TCG-25.
  
  Syed's message (3) described Start Work as on site. She answered *"very start of job"*, which reads
  closer to Left Yard, but she did not say so.
- **What "back at yard" is.** Two candidates:
  - **Arrived Yard**, the end of `YARD_TIME`, per ticket.
  - **Review & Complete**, the end of `WORK_TIME`, per person in `ticket_employees.work_ended_at`.
  
  Syed's message (3) described Review & Complete as *"after the crew is back at the yard"*.
- **Why the across-tickets scope matters here.** Left Yard and Arrived Yard are shared within one
  ticket, but can differ **across** a job's separate tickets. So the yard captures are still
  comparable under "all members".
- **What "all members of the job" is.** Is it the same job on the same day, and every ticket the job
  generated (crane set, support loads)? How is the set of tickets grouped: by job and date, or by the
  DAS allocation?
- **A related open payroll question.** This bears on
  [../payroll/gaps.md → *Recording which time source paid a job day (PAY-017, TCG-178)*](../payroll/gaps.md#recording-which-time-source-paid-a-job-day-pay-017-tcg-178),
  items 2 and 3: whether paid time starts at dispatch or yard, or at the punch, and whether it ends
  at "back in the yard" or at Review & Complete. The flag's times and the paid window may or may not
  be the same captures.
- **Asset flag: "shut off" taken literally.**
  - An engine-off at the job site mid-shift, or at lunch, would trigger it. She presumably means the
    **last shut-off of the day**. That is our reading, and she did not say it.
  - Assets legitimately parked at a job site overnight on a multi-day job that is **not** flagged
    holdover would also trigger it.
- **Asset flag: the signal.**
  - The integration has Samsara `engineStates` events and GPS (`samsara.repository.ts`
    `fetchHistory`, `fetchVehicleStats`), so an engine-off instant can be paired with a location.
  - It has no geofences, so "at an address" needs yard coordinates plus a radius.
  - The Ventura yard's address is **not in the vault**. Los Alamitos is 10850 Portal Dr.
  - Untracked or silent assets remain unanswered.
- **Asset flag: "dispatch notified".** Who in dispatch, and how: in-app or email? Is it a flag
  dispatch can act on, or a notice only?

## Build impact

**Neither flag exists on `main`.**

- **Crew-time flag.** It needs a cross-ticket grouping of a job's crew. Which captures it reads waits
  on the open points above. Per-person values exist only for the Start Work step and Review &
  Complete.
- **Asset flag.** It needs:
  - engine-off events with location;
  - yard coordinates and a radius, including a Ventura yard record;
  - the holdover exclusion (`JobResourceAllocation.isHoldover`);
  - two recipients, plus a notification to dispatch.

## Effect on the vault

Done in the same pass:

- **Earlier 09-30 note:** `provenance_note:` added. It says clause 1's times are replaced here and
  clause 4's recipients and trigger are added. **Done.**
- **payroll/gaps.md → *Flagged entries go to payroll…*:** Q10 updated. **Done.**
- **assets/gaps.md → *Asset not returned to its home yard…*:** Q1 answered, Q2 answered as a
  trigger, the rest kept open. **Done.**
- **dispatch/gaps.md pointer:** "dispatch notified" added. **Done.**

Not done, because file bodies are outside the recording agent's write scope: `payroll/INDEX.md`
needs a line for this note and its count. The exact text was handed to the main session.

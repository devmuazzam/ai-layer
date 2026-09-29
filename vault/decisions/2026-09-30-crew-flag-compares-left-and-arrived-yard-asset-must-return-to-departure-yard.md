---
title: "Crew-time flag compares Left Yard and Arrived at Yard; an asset must return to the yard it left from — decision (developer reading of Corrina's 2026-09-30 reply)"
source: decision/Syed Haris (CodingCops) — interpretation of Corrina Bustos's 2026-09-30 Teams reply
decided: 2026-09-30
decided_by: >-
  Syed Haris (CodingCops developer), 2026-09-30. He stated these two readings of Corrina Bustos's
  Teams reply of the same day, relayed through the coordinating session. This is a **developer's
  decision**, not a client-side product decision. It is `status: reference` for that reason, the
  same basis as decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md:
  it binds implementation now, and TCG can overrule it. Ratifier: **Corrina Bustos** (Payroll
  Manager), at the demo. Clause 2 also touches dispatch (Lisette Anzaldo) and the TCG assets owner,
  who have not spoken.
status: reference
conflicts_with: []
provenance_note: >-
  RATIFIED IN PART by Corrina Bustos, Teams, 2026-09-30 — decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md. She confirmed the flag list
  that states clause 1 ("Left Yard or Arrived at Yard different for anyone on the job") and clause 2's
  rule ("Asset not back at the yard it left from"). NOT ratified: "last engine shut-off of the day",
  which was not in the message. Status left at reference because that reading sits inside clause 2,
  and flipping the whole note to verified would claim more than she confirmed. Body unchanged.
resolves:
  - "payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives (Q10 (a)(b) — developer-decided, pending ratification)"
  - "assets/gaps.md#asset-not-returned-to-its-home-yard-at-end-of-shift--a-requested-flag-with-no-owner-no-yard-geometry-and-no-shift-end (Q3, Q4 — developer-decided, pending ratification)"
jira: []
tags: [module/payroll, module/assets, module/dispatch, kind/decision, payroll-review, samsara, yards]
entities: []
---

# Crew-time flag: Left Yard vs Arrived at Yard. Asset flag: back to the yard it left from.

**What is Corrina's and what is ours.** Corrina's words are recorded in
[2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md](2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md)
(`verified`). Nothing below is her wording. It is Syed Haris's reading of it, to build against
until she ratifies it or overrules it.

Her words, for reference:

> "The flag should compare Start time (very start of job) and End time (back at yard)"
>
> "it would trigger if the asset shut off at address other than the los alamitos or Ventura yard
> addresses."

## Decision (developer, `reference`)

1. **Crew-time flag.**
   - *"Very start of job"* = **Left Yard**.
   - *"Back at yard"* = **Arrived at Yard**.
   - The flag compares **Left Yard** and **Arrived at Yard** across **all crew members' tickets on
     the job**. Any difference flags, per Corrina.
   - **Rejected readings:**
     - the Start Work card tap / shift clock;
     - the Start Work step (`WORK_TIME` start, per person);
     - Review & Complete (`WORK_TIME` end, per person).
   - **Code consequence:** Left Yard and Arrived Yard are **per ticket** (`YARD_TIME`). Within one
     ticket they cannot differ, so the flag only fires **across** a job's separate tickets. That
     matches Corrina's *"all members"*. The per-person `ticket_employees.work_started_at` /
     `work_ended_at` are not used by this flag.
2. **Asset-not-home flag: the rule is the departure yard.**
   - *"Whatever yard the asset left from, it must come back to that yard."* Los Alamitos and Ventura
     in Corrina's message were **examples**.
   - **Yards are tenant-configurable.** A tenant adds its own yards and addresses, including a
     Ventura yard. So the Ventura address not being in the vault is **not** an open question.
   - **Trigger:** the asset's **last engine shut-off** of the day is at a location other than **the
     yard it left from that day**. Corrina's wording is *"shut off"*; *last* is part of this reading.
   - **Excluded:** assets assigned to a holdover job (Corrina's first 09-30 message).
   - **Recipients, per Corrina:** the Payroll Admin and Payroll Manager, with dispatch notified.
   - **The flag uses the departure yard, not `Asset.yardId`.** `Asset.yardId` (→ `Yard`) exists as
     a standing home yard, but it is **not** the rule. An asset that left from a yard other than its
     `Asset.yardId` is judged against the yard it left from.
   - **Code fact, not a client question.** Nothing in the schema records **which yard an asset left
     from on a given day**. `JobTicket` has `left_yard_comment` but no yard, and neither
     `JobResourceAllocation` nor `SubJobLoadout` carries a yard. Establishing the departure yard, for
     example from the Samsara location at the first engine-on or trip start against the tenant's yard
     coordinates, is implementation design for CodingCops.

## Why

- **Clause 1.** Syed Haris's message (3) described Start Work as *"work on site begins"*. Corrina
  did not choose it, and wrote *"very start of job"* instead. The yard departure is the earliest
  capture on a ticket. *"Back at yard"* is the Arrived at Yard capture by name.
- **Clause 2.** Corrina named two yards because TCG has two. Hardcoding two addresses would break for
  any other tenant or any new yard. The departure yard states her intent, which is that the asset did
  not come back, without depending on a fixed list.

## Still open (not decided here)

**Crew-time flag:**

- how a job's tickets are grouped (job + date, or DAS allocation);
- whether it is a ticket flag, a per-employee payroll flag, or both.

**Asset-not-home flag:**

- **Which engine-off counts.** "Last shut-off of the day" is this reading. It needs Corrina's
  ratification.
- **Yard radius:** how far from a yard's coordinates still counts as "at the yard". No geofences
  exist; `Address` has latitude and longitude only.
- **Untracked or silent assets.**
- **Assets legitimately parked at a job site** overnight on a multi-day job that is **not** a holdover.
- **Who in dispatch is notified, and how.**

**Paid time:** the paid-time boundaries in
[../payroll/gaps.md → *Recording which time source paid a job day*](../payroll/gaps.md#recording-which-time-source-paid-a-job-day-pay-017-tcg-178)
are **not** settled by clause 1. The flag's captures and the paid window are separate questions.

## Who ratifies

- **Corrina Bustos, at the demo:** both clauses.
- **Lisette Anzaldo (dispatch):** the holdover exclusion and the dispatch notification.
- **The TCG assets owner:** clause 2's departure-yard rule and the yard radius.

## Effect on the vault

Done in the same pass:

- **Corrina's 2026-09-30 reply note:** `provenance_note:` added, pointing here for the developer's
  reading. **Done.**
- **payroll/gaps.md → *Flagged entries go to payroll…*:** Q10 (a) and (b) marked developer-decided,
  pending ratification. **Done.**
- **assets/gaps.md → *Asset not returned to its home yard…*:** Q3 and Q4 marked developer-decided,
  and the Ventura-address point withdrawn. **Done.**

No `status:` was changed on any file. A developer's `reference` decision verifies nothing.

Not done, because file bodies are outside the recording agent's write scope: a `payroll/INDEX.md`
line for this note and its count. The exact text was handed to the main session.

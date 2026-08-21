---
title: Secondary craft code pay rate can never be lower than the employee's primary rate
source: meeting transcript "TCG ERP System" 2026-08-13, craft-code configuration walkthrough
decided: 2026-08-13
decided_by: Brian Petros (TCG) proposed the rule; Corrina Bustos confirmed with a concrete example; Kyle Harlow agreed ("that would make good sense"); Ehtesham Anwar (Codingcops) accepted it for the build ("that's easy, we can do that, break that into the ERP").
status: verified
resolves: []
topics: [payroll, craft-code, dispatch, rate-resolution]
entities: [craft-code, employee, payroll-group, dispatch]
---

# Decision

**An employee dispatched to fill a role other than their primary craft is paid at the higher of
their primary rate and the secondary role's rate — never lower.** A secondary craft code
assignment is only valid if its rate is greater than or equal to the employee's primary rate.

## The rule, as stated in the meeting

Corrina Bustos, explaining current practice (`.ai/vault/meetings/transcripts/2026-08-13-payroll-process.md`, ~23:48):

> "So there everybody is allocated at one base rate. So say he gets paid 70 bucks an hour as an
> operator and he's dispatched to us at that rate. Even if he goes out on a job as a rigger, he
> still has to be paid as... The $70.00."

Kyle Harlow, confirming this is not configurable per-job (~23:52):

> "That's not gonna work — whatever their dispatch has, they had to stay at that rate. Even if
> they fill a different position, we have to keep it at that rate."

Brian Petros then proposed the general rule the ERP should encode (~24:32):

> "I think the rule would be that this any secondary must be a higher rate than the primary,
> because I think that's the only time that they are paid out at a different rate is when it's a
> higher, they're working at a higher capacity, right, Corrina?"

Kyle: "Yes, yes. Correct. That would make good sense." Ehtesham: "Okay, that's easy. We can do
that, break that into the ERP."

## What this means for the build

- An employee's craft-code profile carries one **primary** craft code and zero or more
  **secondary** craft codes (`.ai/vault/meetings/transcripts/2026-08-13-payroll-process.md`,
  ~22:50: "we'll be able to add primary, we'll be able to add multiple secondary craft codes").
- When an employee is allocated to a job under a secondary craft code, the ERP must resolve pay
  as `MAX(primary_rate, secondary_role_rate)` — dropping below the primary rate is not a valid
  outcome.
- This is distinct from the **craft-code modifier** (boom pay) mechanism, which is job-specific
  and unrelated to which craft code was used for base pay — see
  [2026-08-13-boom-craft-modifier-configuration-and-override.md](2026-08-13-boom-craft-modifier-configuration-and-override.md).
- The legacy payroll app does not implement this rule at all — `v_Base_LaborPayroll` resolves
  base rate purely from whatever craft code is on the labor row
  (`.ai/vault/payroll/legacy-payroll-app-db-extract/calculations.md`, §B3.6: "**Labor wins**: the
  pricing engine ... resolve `CraftPayRate` ... from the **labor row's** `CraftCode`"), with no
  floor comparison against the employee's primary rate. This is a new ERP rule, not a port of
  existing behavior.

## Open detail not settled in this meeting

How the "over-scale" adder (a per-employee negotiated bump on top of their group rate,
`.ai/vault/meetings/transcripts/2026-08-13-payroll-process.md`, ~25:54–29:17) interacts with this
floor — i.e. whether the floor compares raw group rates or group-rate-plus-overscale — was
identified as needing a solution ("I think I have a solution for that. In the next iteration,
we'll add that") but not finalized in this meeting.

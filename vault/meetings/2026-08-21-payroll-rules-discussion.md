---
title: TCG – Meeting Minutes (21 August 2026)
source: user-supplied/meeting-minutes
migrated: 2026-08-21
updated: 2026-08-21
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/meeting-notes, rest-period, wtl, craft-code, subsistence, adp]
entities: [rest-period-premium, work-through-lunch, base-rate-override, craft-code, boom-hours, short-subsistence, long-subsistence, holdover-job, adp-pay-code]
meeting_date: 2026-08-21
---

# TCG – Meeting Minutes, 21 August 2026

**Union payroll process and rules.** Discussion of how the current manual union payroll process
works, and the payroll rules the future ERP needs to apply automatically.

> **This is forward-looking, unlike the sprint plans in this folder.** See the note in
> [2026-08-05-payroll-module-design-review.md](2026-08-05-payroll-module-design-review.md) — the
> `meetings/` retrospective caveat does not apply to these client minutes.

## Discussion points

- The current union payroll process is largely handled **manually**, including adjustments to
  hours, times, and payroll amounts based on applicable rules.
- The future ERP should **automatically apply payroll rules** and calculate the appropriate
  payroll results from the actual input data.
- **Rest Period Premium** was discussed as a payroll rule that needs to be incorporated into the
  system's payroll calculation.
- **Work Through Lunch (WTL)** and **Rest Period** payments were discussed in relation to payroll
  rules/pay codes. Currently, **WTL is paid as Double Time**.
- **Base Rate Override** allows specific hours to be paid at a rate different from the employee's
  standard base rate; **Boom hours are not affected** by the override.
- The system should determine the applicable **Craft Code (Primary/Secondary)** based on the
  employee's work/job, and apply the corresponding pay rate.
- **Base Rate Override** should be controlled by the **Payroll/Crane Supervisor**.
- The team clarified the **Short and Long Subsistence** rules based on the distance between the
  yard and job site, and whether the employee is actively working or on a holdover job.
- **Temporary and permanent employees** are both processed and paid through **ADP**, using the
  same payroll process.
- The team discussed the possibility of creating a **separate ADP pay code for Work Through
  Lunch (WTL)**.

## Action items

*None recorded as named owner/action pairs in the source.*

## How this lands against the vault

Read with [payroll/INDEX.md](../payroll/INDEX.md) and the prior payroll minutes in this folder
([2026-08-05](2026-08-05-payroll-module-design-review.md),
[2026-08-07](2026-08-07-labor-compliance-certified-payroll.md)).

- **Rest Period Premium** already has vault coverage (contract text, PR-034, and a legacy
  `REST_PERIOD_PREMIUM` proc) — this discussion corroborates rather than introduces it.
- **"WTL is paid as Double Time"** sits in tension with
  [payroll/wtl-charts.md](../payroll/wtl-charts.md), which lands WTL penalties against
  Reg/OT/DT by lookup rather than a flat double-time rate. Not reconciled here.
- **Base Rate Override** and **Craft Code (Primary/Secondary)** appear to be new terms — no
  prior hits found in the vault for either. The legacy engine has a single `CraftCode` plus a
  separate `CraftModifierCode` for boom brackets, not an explicit primary/secondary pair; this
  note does not assert they map onto each other.
- **Short/Long Subsistence by yard-to-job distance and holdover status** is new detail against
  an already-open gap: `payroll/gaps.md` — *Subsistence — the recording and the engine
  disagree* — which currently has PR-037 using an employee home-base input rather than
  yard-to-job distance. No mileage threshold or dollar amounts were given here, and "holdover
  job" as a subsistence criterion is not defined anywhere else in the vault.
- **Separate ADP pay code for WTL** is an open question, not a decision. It already has an
  owning entry — **D-004** in
  [payroll/gaps.md#adp-export-mapping--9-open-decisions-6-blocking](../payroll/gaps.md) — no
  new gap entry was added here.
- No attendee names were given for this session; do not attribute any of the above to a specific
  person.

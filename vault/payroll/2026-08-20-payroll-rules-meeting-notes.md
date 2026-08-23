---
title: Payroll rules Q&A — meeting notes, 2026-08-20
source: "downloads/2026-08-20_Payroll Rules - transcript.docx"
migrated: 2026-08-21
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, wtl, rest-period, subsistence, craft-code, adp, certified-payroll]
entities: [payroll-rule, work-through-lunch, rest-period-premium, subsistence-allowance, base-rate-override, craft-code, adp-export]
part_of: payroll/INDEX.md
---

# Payroll rules Q&A — meeting notes, 2026-08-20

**Source:** Zoom recording "CC TCG ERP System", 2026-08-20, 40 minutes. Auto-generated
transcript cleaned of filler words, false starts and cross-talk; content and attribution are
otherwise unchanged from what was said. Not a verbatim transcript.

**Attendees:** Brian Petros and Corrina Bustos (TCG payroll), Micaela Dipane (TCG payroll),
Abdulrehman (CodingCops, ERP backend). Ehtesham was absent.

**Status:** these are answers a payroll SME gave verbally on a call — not yet promoted into
[codingcops-rule-matrix.md](codingcops-rule-matrix.md) or the
[ERP requirements document](erp-payroll-module-frd/INDEX.md). Treat as `unverified` until
someone reconciles it against those documents and any open decision it touches.

## Why this call happened

The payroll rule matrix Abdulrehman was reviewing had no column for work-through-lunch or rest
period, so he raised it as an open question. Brian Petros framed the broader context first: the
current process evaluates union payroll rules **manually**, then types the result into the
weekly ADP workbook. An internal database (~90% complete, already shared with CodingCops) now
calculates a recommended value alongside the manual one, so discrepancies are visible — but the
manual entry is still what ships. The target state for the ERP is the reverse: capture raw
inputs (times, hours) as accurately as possible and let the system derive the result; correcting
an output means correcting the original input, not the total.

## Work-through-lunch (WTL)

- There is **no separate ADP pay code for WTL today**. It is folded into the existing
  standard/overtime/double-time buckets — the worked half-hour is bumped to double time (or
  stays at triple time if the entry was already triple time), with no distinct line item on
  the paycheck.
- **Only the first missed lunch is absorbed into the hours already being paid.** Every
  additional missed lunch in the same entry adds a new half-hour of double time on top of the
  actual worked total. Example given: Travis Garrett, 18th — worked 13.5 hours through both
  lunches, paid 14.0 hours (the second missed lunch added 0.5h DT that was not part of the
  13.5h actually worked). Contrast: Jonathan Aldridge, one missed lunch — paid at double time
  within the hours already worked, not added on top, even though total hours were under 12.
- Abdulrehman proposed a dedicated ADP pay code (e.g. `WTL`) so the rule's cost is separately
  reportable and easier to read back out of the export. Brian Petros's concern: a new code
  shows as an extra line on the employee's paycheck and could read as confusing, since the
  first missed lunch doesn't get its own line today. Corrina Bustos's counter: keep it as a
  **line item on the same primary ADP row** (next to the DT amount) rather than a separate
  paycheck line, which still enables cost reporting per rule without changing what the
  employee sees. No final decision was recorded on the call — Brian Petros agreed the idea has
  value ("it would be nice to see cost per rule") but did not commit to the mechanism.
- Related: the payroll app under development is already building a per-rule ledger — every
  time a rule fires, it records the rule and the hours/amount it produced. This is the same
  principle as [payroll/INDEX.md](INDEX.md)'s "every calculated dollar must be a separate,
  explainable pay component."

## Rest period premium

- Fires when an employee does not get **at least 8 hours of rest between two jobs**.
- Result: pay continues **as if the previous job never stopped** — i.e. it extends the prior
  job's overtime/double-time progression into the new one. This only changes how many hours
  land in standard/OT/DT buckets; like WTL, there is **no separate ADP code** for it today.

## Rate overrides and craft codes

- The current weekly ADP workbook has a **"base rate override" column**: when an employee
  works a shift at other than their base rate (e.g. a different craft that day), the override
  dollar amount goes in that column for just those hours. Boom-time premiums are unaffected —
  they add on top of whichever rate applies, override or not.
- On export, all hours **without** an override are grouped onto the employee's primary ADP
  row at their base rate; hours **with** an override become a separate row carrying that
  temporary rate. ADP needs one row per distinct rate.
- Today, the employee's base rate always matches between the internal system and ADP — Corrina
  Bustos confirmed ADP is never given a different rate except via this temporary-rate
  override.
- For the ERP: employees carry a **craft code at the employee level**, which sets their default
  base rate. Abdulrehman's proposal — when an employee works under a different craft on a given
  day (e.g. oiler one day, operator the next), use a **secondary craft code for that day** to
  drive the rate for that day's entry, rather than a free-text override.
- Who can change the craft code/rate for a given day: **the crane superintendent or whoever
  manages payroll, not the employee.** Corrina Bustos: employee self-selection would create
  extra double-checking. Both agreed on this.
- Whether the override should be an arbitrary dollar amount or locked to one of the defined
  craft-code rates: **decided on the call — locked to a craft-code amount** (Corrina Bustos,
  confirmed by Brian Petros: "that makes it easier"). No free-text specialty-rate override.
- Abdulrehman noted ADP itself has both static/managed pay codes and custom ones, and that
  CodingCops can override values against any pay code once given API staging access — still
  pending as of this call (see below).

## Subsistence allowance

Clarifying [erp-payroll-module-frd] language that Abdulrehman found confusing:

- **Short subsistence — $85/day**: paid when the job site is **45 to 77.5 miles** from the
  yard, and **only on days actually worked** at that site.
- **Long subsistence — $200/day**: paid when the job site is **over 77.5 miles** from the
  yard, and paid for **every day of the holdover job, worked or not** (a multi-day job the
  employee stays out for, rather than commuting daily).
- The distinction the union agreement's wording obscures: short subsistence tracks worked
  days; long subsistence tracks calendar days of the holdover assignment.

## Temporary / fill-in employees

- ADP processes **all employees the same way, full-time or temporary** — Corrina Bustos: a
  new sheet is generated per temporary employee, but pay processing does not differ by
  employment type.

## Certified payroll / prevailing wage

- TCG's union pay rates are **already higher than certified-payroll/prevailing-wage rates**,
  so the certified-vs-standard rate distinction Abdulrehman asked about does not currently
  create a conflict.
- The one rate distinction that does exist operationally: **military base premium** — already
  tracked and generated as extra income when a job is on a military base. (See also
  [foreman-and-military-premiums.md](foreman-and-military-premiums.md).)

## Open / unresolved as of this call

- **WTL ADP pay code mechanism** — whether to add a distinct line-item column in the ADP
  export (folded into the primary row's total hours, not a separate paycheck line) is a real
  proposal on the table but not confirmed as a decision.
- **ADP staging environment access** — Abdulrehman named this as his current blocker; the team
  cannot test what the ADP API actually permits (custom pay codes, overriding values per pay
  code) until it is granted. Relevant to
  [adp-integration-capabilities.md](adp-integration-capabilities.md) and
  [adp-read-write-boundary-2026-08-18.md](adp-read-write-boundary-2026-08-18.md).
- Ehtesham (backend architecture owner on the CodingCops side) was not on this call; per
  Abdulrehman, the payroll module design is finalized on the design side and backend
  architecture work is in progress in parallel.

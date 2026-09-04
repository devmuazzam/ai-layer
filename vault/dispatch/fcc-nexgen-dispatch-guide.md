---
title: How dispatch works in FCC NexGen — the vendor's own user guides
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/ — NexGen_WPF_Dispatch_User_Guide_v5.0.pdf, OneDrive_2025-10-29/DispatchingGuide.v2.2.docx (text + its 43 embedded screenshots, read 2026-09-04), OneDrive_2025-10-29/Dispatch High Level Best Practices.docx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/dispatch, module/assets, module/field-ops, module/payroll, kind/reference, scheduling, ticket-workflow, time-tracking, certifications, reporting, geolocation, legacy-payroll-app]
entities: []
---

# How dispatch works in FCC NexGen — the vendor's own user guides

**What this is.** Three documents written by **Fleet Cost & Care** (Detroit, MI) — the vendor of
**NexGen FMS**, the desktop system TCG dispatches from today. Two are formal end-user manuals for
the Schedule → Job screen, one is a short operational checklist FCC gave TCG's dispatchers. They
arrived in the 2026-09-04 Project Repository drop under `1.0.2_FCC-RESOURCES-GUIDES`. Until now
the vault held **no description of how the legacy dispatch screen actually behaves** — only
[domain/fcc-nexgen-fms.md](../domain/fcc-nexgen-fms.md), which resolves the term and explicitly
declines to describe behaviour, plus the two data-side pages
[assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md) and
[quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md).

> **This is the legacy system's behaviour, not a TCG requirement.** Nothing here has been asked
> for, adjudicated or accepted for the ERP. `domain/fcc-nexgen-fms.md` states the rule directly:
> *"No spec may cite 'FCC/NexGen does X' as the basis for a requirement unless that behaviour is
> written down in the vault or a ticket."* This page makes the behaviour **readable**, so that a
> claim about "how it works today" can be checked instead of guessed. It does not make any of it
> a requirement. It is also **vendor-generic**: FCC ships the same manual to every customer, and
> both guides say repeatedly that features may be switched on or off per organisation, so nothing
> here is evidence that TCG has a given feature enabled.

| Source | Version / date | Covers |
| --- | --- | --- |
| `NexGen_WPF_Dispatch_User_Guide_v5.0.pdf` | **v5.0, January 2023** — the WPF (rewritten) screen | 110 pages: field-by-field walkthrough, scheduling, estimates, resources, validations, e-tickets, storage, POs, invoicing, tools, lift info, maps, keyboard |
| `DispatchingGuide.v2.2.docx` | **v2.2, 2018-03-28** — the WinForms (legacy) screen | 53 pages: the older tabbed screen, **plus trucking jobs, loads and axle groups, ticket generation, ticket review, labor review, unit down time** — none of which the v5.0 guide covers |
| `Dispatch High Level Best Practices.docx` | undated; delivered in a `OneDrive_2025-10-29` folder | one page: the four daily checks a dispatcher runs, and the order dispatch/billing/payroll must work in |

**The two manuals describe two different generations of the same screen** and the newer one is not
a superset: the WPF guide covers `NOT ... Trucking jobs` by its own statement, while the v2.2 guide
is the only source here for trucking, load/axle entry, unit down time and the labor pre-processor.
Read them together; where they disagree, v5.0 is the newer screen.

---

## 1. The four daily checks — FCC's own best-practice list

Source: `Dispatch High Level Best Practices.docx`, quoted closely. FCC calls these *"the big 4
points for them to follow and check on their schedules"*:

1. **Check for duplicates** on the unit and employee schedules. A unit or employee scheduled twice
   on two different jobs at the same time is *"definitely a double booking or the schedule needs
   to be cleaned up."*
2. **Check for "none"** on the unit and employee schedules — this means *"a crane type or employee
   type is schedule to a job, but no specific employee or unit has been scheduled."* (i.e. the
   Type is filled but the Resource is not.)
3. **On the Unit Schedule**, set bar text to *employee assigned* — if nothing populates, *"you
   likely forgot to link the employee to the unit."*
4. **On the Employee Schedule**, set bar text to *unit assigned* — if nothing populates, *"you
   likely forgot to link the unit to the employee."*
5. **Have LEM tickets gone to all employees?** *"Check for pink bars on the employee schedule to
   make sure."*

### The ordering rule between dispatch, billing and payroll

Also from the best-practices sheet, and stated as binding on three departments at once. Before
dispatch approves labor entries, billing approves or attaches e-tickets, or payroll processes:

- **Check the E-Ticket Status Report — have all tickets been completed?** *"Dispatch
  responsibility, but everybody can check this before moving forward with their work."*
- Before **attaching tickets to and creating an invoice**: all labor and e-tickets for billing must
  be approved, because *"once an invoice has been created with e-tickets attached, you can not add
  any more e-tickets to that invoice."*
- Before **processing payroll for an employee**: same, because *"missed hours when processing can
  lead to OT calculation errors."*

This is the closest thing in the drop to a stated cross-module sequencing constraint. It is FCC's
recommendation about FCC's system; **it is not stated anywhere as a TCG rule for the ERP.**

---

## 2. The job record

Source: v5.0 guide, *Data Entry Field Walkthrough* and *Scheduling a Job*; v2.2 guide,
*How to Create a Job*.

**Minimum to save a job: a customer and a date.** Everything else that appears required is
configured by the system administrator per organisation. Required-but-empty fields render with a
yellow background and an asterisk.

Main-tab fields: `Job Number` (auto-increment; type `Auto` to reset it), `Company`, `Yard`,
`Department`, `Salesperson`, `Checked By` (who physically evaluated the site), `Taken By` (who
recorded the job), `PO Number`, `Status`, `Customer`, `Bill To`, `Job Site`, `Report To` (the site
contact), `Ordered By` (who placed the order), `Description of Work`, `Comments`,
`Equipment Required`, `Job Date` and `To`, and the `Date Flexible` / `Time Flexible` /
`Work Weekends` flags.

Three of these carry stated downstream behaviour:

- **`Description of Work`** *"carries over to the Billing Description for the invoice"* and passes
  to e-tickets and printed tickets.
- **`Equipment Required`** *"carries over to the e-ticket and acts as a synopsis to field
  employees"*, and the v5.0 guide says explicitly it *"should not be used to capture units that
  may be added to the Resources tab, instead, display those resources that are not considered
  units like rigging, specific jibs, or other exceptional equipment."*
- **`PO Number`**, when the customer record marks it required, *"will not prevent you from creating
  a job … but it will prevent an invoice from being generated."* The label warns at job time so the
  PO can be chased early.

**Date Flexible / Time Flexible changed meaning between the two guides.** In the legacy screen
they let a job be saved with no date or time. In WPF they do not: *"a job date and time are always
required. This is to ensure that a job does not exist that does not display on a schedule."* The
flags now only raise an indicator on the schedules.

### The seven statuses, and which ones have teeth

NexGen carries the **same seven-state status enumeration at four levels** — job, unit / job-level
employee, unit-level employee, and ticket — plus the same seven on storage items. Codes are from
the v5.0 guide's own table:

| State | Code | Behaviour stated |
| --- | --- | --- |
| Tentative | `T` | not finalised; **no disruptive logic** |
| Confirmed | `C` | confirmed; **no disruptive logic** |
| On Job | `O` | resource is on-site — *"helps when scheduling day/night work and resource is staying on site"*; **no disruptive logic** |
| Finished | `F` | scope complete, may be ready to bill; **no disruptive logic** |
| Complete | `Z` | **locks the record for archiving.** Undoable only with permission. *"Once set, no details of the job may be modified. All tickets must be finalized, and the job must be in the past to set this state."* |
| Canceled | `X` | implies no costs were incurred. **Blocked if any ticket is in a state other than canceled, or if a PO exists for the job.** |
| Transfer | `R` | optional — *"jobs that are intended to incur cost without revenue (e.g., transferring a resource from one yard to another)"* |

**Only `Z` and `X` constrain anything.** The other five are display-and-convention. Employee
statuses *"follow the status of the unit and job so long as they are not modified intentionally"*;
once touched manually they stop tracking — **except that a canceled resource stays canceled**
regardless of the unit or job status until someone changes it by hand.

### Parameters — the flags that change how the job behaves

`Job Type` (user-defined; **`Bare` requires insurance information**, and every other job type
affects the job *only* through the configured Unit Type Defaults), `Industry`,
`Terms & Conditions` (**required before any e-ticket can be generated**), `Lease Terms &
Conditions`, `Billing Type`, `Retainage %`, `Signed Contract`, `Certified Pay/Prevailing Wage`
(gates the Certified Payroll report, and the employee must *also* be flagged eligible on their own
record), `OCIP/CCIP` (gates workers-comp calculation and the OCIP report), `Work Weekends`, `MSHA`,
the property/lien block, `Project Number` (a free-text key that groups jobs across a project),
`Union` (multi-select), and `Checklist` (job-based checklists that each **primary** e-ticket must
complete).

**`Work Weekends` is a scheduling constraint, not a display flag.** Unchecked, the system ignores
weekend days, shows resources as available on them, and **prevents e-tickets being issued on those
days**. "Weekend" is itself configurable in `Admin > Set Weekends` and is not limited to Saturday
and Sunday.

`Billing Type` determines the whole shape of the Estimate tab: `Rental` (billing codes — the common
case), `Percent` and `AIA` (progress billing on line items, AIA using G702/G703), `T&M` (**the
Estimate tab disappears entirely** — *"providing an estimate for this model contradicts the
principle of the model"*), and `Parts`.

---

## 3. Resources — how a crane and its crew are attached to a job

Source: v5.0 guide, *Resources Tab* and *Managing Resources*.

The Resources tab is a grid with **two top-level record types — Unit and Employee** — and a
**nested grid under each unit** carrying *Employees*, *Specifications* and *Telemetry*. A
job-level employee has no nested grid.

The three columns that identify a resource are a strict cascade:

1. **`Schedule Type`** — units only; the high-level category, from `Maintain > Units > Unit
   Schedule Types`. Employee records get the schedule type `Employee` automatically.
2. **`Type`** (formerly *Unit Type*) — *"the role that resource is taking on the job"*, filtered to
   the chosen Schedule Type. For employees it is the full Employee Type list.
3. **`Resource`** — the specific unit or employee, filtered by the two above.

That cascade is the same two-level shape already recorded as Category → Sub-Category in
[assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md) §1 — and this
guide confirms it from the dispatch side: **the pair identifies a role, and the third field picks
the instance.** The v2.2 guide adds a working practice on the third: *"It is a best-practice to
leave these fields blank until close to job execution to reduce the number of changes that need to
be made."*

A **unit** row also carries `Status`, `Start`, `End`, `Comments` (these pass to that resource's
e-ticket), `Picked up`, `Returned to yard?`, optional unit-level insurance columns, and
`Termination Code` — a generated up-to-5-digit number given to the customer as proof a unit came
off rent early.

### Date and time inheritance — an offset model, not a copy

Stated precisely, and worth reading twice because it is the subtlest rule in either guide:

- The **first** job-level unit inherits the job's date/time range. **Each subsequent unit inherits
  the previous unit's** values, not the job's.
- The first job-level **employee** inherits the job's range *unless* it is added after a unit whose
  range already differs.
- **All unit-level employees inherit their unit's range.** If an employee is then moved off that
  range, the **offset is preserved** when the unit next moves: *"if a unit is scheduled for 7:00 AM
  when an employee is added, the employee will display 7:00 AM. If you adjust the employee to 6:00
  AM, and subsequently change the unit to 9:00 AM, then the employee will update to 8:00 AM."*
- Changing the **job's** dates after resources exist raises a prompt asking whether to propagate,
  case by case, with an extra warning when resources hold several distinct ranges.
- `Telemetry` meter dates are deliberately **unconstrained** by the job range, to cover a unit that
  goes off-rent on one date but is not retrieved until later.

### Finding a resource, and reaching outside the yard

Three ways to add one: pick Schedule Type → Type → Resource manually; use the **availability**
window (a filtered search that then populates the row, *"always an option (even after a unit was
previously selected)"*); or widen the resource dropdown by switching the filter at the bottom-left
of the tab between **Units/Employees for This Yard**, **for My Yards**, and **for All Yards**.

### Telemetry

Per-unit hours and mileage, replacing the legacy *Hours & Miles* grid. Columns: `Source`
(`NexGen`, `Atom`, or `GPS`), `Meter Date` (required), `Odometer`, `Hours (Upper)` (superstructure),
`Hours (Lower)` (chassis — *"in single-engine units, this should be the only column used"*),
`Location/Comments`, `Latitude`, `Longitude`. **At least one of Odometer / Hours (Upper) / Hours
(Lower) must be filled.** Entries are validated against the unit's current meter values and a
per-system *Permissible Change to* limit; a value lower than the unit's own recorded value raises
a separate confirmation because the unit record drives the preventative-maintenance cycle.

**GPS-sourced rows are read-only and self-associating:** *"the system is going to compare the date
that the information was recorded in GPS with the date range the job is scheduled for, if the GPS
entry falls within the date range, NexGen will automatically associate the two. You cannot modify
records that come from GPS."* `Latitude` and `Longitude` *"can only be populated by a GPS
interface"*, and `Location` is their reverse-geocode.

> **Bearing on the open GPS ask.** Melissa's *"time verified by GPS — just a click button or check
> box"* ([crane-configurations.md](crane-configurations.md) §3, and entry **#5** of
> [erp-review-log.md](../erp-review-log.md)) has never been specified. These guides show that FCC
> already carries per-unit GPS date, latitude, longitude and a `GPS` provenance value on telemetry
> rows, and `assets/fcc-units-and-schedule-types.md` §2 shows `UpperGPS`/`LowerGPS` identifiers on
> the unit master. **That is context, not an answer** — nothing here says which time Melissa means,
> whose GPS, or what "verified" would assert.

---

## 4. Validation — hard versus soft, and the override

Source: v5.0 guide, *Soft Data Validations*.

NexGen splits validation in two. **Hard validations** block the save (a missing Schedule Type or
other required field). **Soft validations** never block: they run on every modified resource at
save, or on demand via a *validate resources* icon, and raise a non-clickable Alert icon whose
hover text enumerates every violation on that row.

Three stated validation messages:

1. *"Ending Date/Time is before/after the job is scheduled to start/end."*
2. *"Schedule overlaps for [Unit Code] with job(s) [Job Number array] from [date] to [date]"*
3. *"Certificate ([certificate description]) for [Employee Name] expires before the job is
   scheduled to complete"*

**Schedule conflicts.** Any resource booked on two jobs at overlapping times raises one violation
per clash, each naming the other job number. The check can be **switched off per unit** in
`Maintain > Units` — *"common when using a Unit Code for an item that is abundant in your fleet or
yard."*

**Certification conflicts.** Requirements are defined **on the customer or on the job site**, not
on the job: add the certificate with type `Customer/Location`, attach it to the customer (or job
site), and record it against each employee who holds it with valid dates. Every employee on a job
for that customer is then validated. The same mechanism exists for unit-based certifications.

**Timing flags** compare each unit's and employee's start and end against the job's.

**Every soft violation can be overridden.** *"For all conflicts, the system will allow a user to
override and send an employee anyway. The feature is not intended to be a roadblock in your
workflow. However … overriding it means that you acknowledge that the violation exists."* There is
no record in either guide of the override being logged, attributed or reported.

> This is the direct legacy antecedent of the DAS's *"unavailable ones are greyed out but still
> drag-gable with a system warning"* in [daily-allocation-system.md](daily-allocation-system.md) —
> and of the client's ask (2026-08-12 minutes) that the ERP **prevent** selection of cranes under
> maintenance while **supporting** deliberate double booking. FCC solves that tension by making
> every conflict advisory and per-unit-suppressible. **The two sources are describing the same
> problem; neither says what the ERP should do.**

---

## 5. Tickets — LEM versus Job, and the one-per-resource-per-day rule

Source: v5.0 guide, *Managing E-Tickets*, *Generating a LEM Ticket*, *Generating a Job Ticket*;
v2.2 guide, *How to Generate a Ticket*.

**The cardinality rule, quoted in full because it is the load-bearing one:**

> *"The system is designed to allow one Job Ticket or LEM (Labor, Equipment, Materials) Ticket for
> one resource per day. This is intended to limit the risk of duplicate or conflicting tickets
> being issued. To handle shift work, you will need to create multiple instances of the unit within
> the Resources tab. Then, you can adjust the start and end times to reflect the shift details and
> issue separate tickets. Behind the scenes, NexGen uses a JobUnitID that is unique to each instance
> of a unit on the Resources tab; this allows for multiple instances of the same unit on the same
> job/same day scenario."*

So **day/night work on one crane is modelled as two unit rows on the same job**, not as a shift
attribute — and the identity that makes tickets distinct is the *row*, not the unit.

**The two ticket kinds:**

| | Job Ticket | LEM Ticket |
| --- | --- | --- |
| Scope | **unit-based — one unit only**, and therefore **at most two employees** | many units and many employees |
| Signature | the unit's crew | one declared **LEM Primary Employee** *"will represent the collective group and collect signatures from the customer"* |
| Other employees | — | receive a **secondary copy** for reference and may enter their own labor, or the Primary may enter labor on their behalf |
| Requires | the unit's **`Primary Employee` checkbox must be set**, else generation fails with a hard error | a Primary Employee selected in the Generate LEM window |

Every e-ticket has three components: **1. Ticket, 2. Checklists (if used), 3. Labor & Unit
Details** — assembled from the unit's checklists, the job's checklists, and the field-employee
permissions.

**Generation rules that constrain the dispatcher:**

- Generating a Job Ticket first forces a save if the job is dirty, then runs the schedule-overlap
  and certification checks; **soft violations warn and may be overridden, hard violations block.**
- The date picker offers **only dates inside the resource's scheduled range**; a date that already
  has a ticket shows in red; typing an out-of-range date raises an error.
- On a LEM, **selecting a unit automatically selects its unit-level employees**, and *"you cannot
  assign a unit-level employee without the unit."*
- *"You cannot generate a LEM for a resource that has already been dispatched for the same
  date/time."*
- LEM generation can be filtered by a **Show Start Times Between** range — FCC's stated way of
  handling shift work at ticketing time.
- **Copy LEM Ticket** re-issues a previous day's exact resource set for the same job.
- Tickets can also be generated **from the Display Schedules**, not only from the job.

**Completing or cancelling** an e-ticket **auto-generates a PDF snapshot** of the ticket as it
stood on the device — preserving timestamps, comments, layout and the customer's signature — filed
under Attachments with `View By = E-Tickets`; cancelled ones carry a diagonal *Canceled* watermark.
If labor is already attached to a ticket being cancelled, a window lists the entries and
*"Delete and Continue"* **erases them irrecoverably**.

**Modular E-Tickets** (an optional feature) move lift information onto a per-unit `Specifications`
tab with `Start`/`End` dates, `Comments`, `Description of Work` and `Equipment Required` **overrides
scoped to a date range**, editable dimensional columns (`Back`, `Up`, `In`, …, 10 characters each),
and a **`Hook Ready`** time that prints as a bold red banner at the top of the e-ticket. Once a
ticket is issued against a Specifications record, **the record is frozen** — to change it you must
cancel the ticket, edit, and re-issue.

**Notification is not solved.** The v2.2 guide is blunt: e-tickets raise a badge on the Atom Jobs
icon *"but will not send push notifications to the device owner"*, and one workaround is to email
the employee from NexGen. That is exactly the hole review-log entry **#1** asks the ERP to close —
*"text crew directly with a link they can confirm their work on"*
([erp-review-log.md](../erp-review-log.md)) — and the same hole
[dispatcher-needs.md](dispatcher-needs.md) records as *"reduce dependency on manual texting"* and
acknowledgement tracking *"currently handled via Excel"*.

---

## 6. Reviewing tickets and labor

Source: v2.2 guide, *How to review Tickets* and *How to review labor* — **the v5.0 guide covers
neither**, so this is the only description held.

**Ticket review** happens in `Enter > Invoices > E-Tickets Not Approved or Invoiced`, which lists
completed-but-uninvoiced jobs with a **user-definable `View By`** (default `All` / `Not Approved` /
`Approved`). The reviewer opens the e-ticket, validates timestamps, reviews *"the labor, meals,
travel, loadouts"*, summarises in a **`Billing Comment`** field, and sets the **`Status`**
dropdown to `Approved` — or to something narrower if the job is waiting on a PO or costing detail.
The status list itself is *"a matter of policy within the organization."*

**Labor review** happens in `Enter > Labor > Labor for Payroll Pre-Processor`, per employee. Fields
listed: `Work Date` (pre-populated from the employee's Atom device, *"but should be verified by the
Dispatcher"*), `Union`, **`Craft Code`**, **`Boom Length`** (*"only applies with specific unit
configurations and may be set by the employee"*), `ST Hours`, `Shift`, `Work Comp`, `Burden`,
**`Class`** (*"selected by the employee to determine the role … Classes define whether an entry is
productive or non-productive"*), `Job` **xor** `Work Order` (each greys out the other), `Unit Code`,
`Activity`, `Approved` (stamping name and datetime), and `Comments`. **`ST Hours`, `OT Hours`,
`DB Hours` and `Total Hours` are always read-only**, *"auto-populated based on rules applied by a
system administrator."*

> **Craft code, boom length, shift, work-comp and burden are the payroll module's own vocabulary**
> — see [payroll/rules/](../payroll/rules/INDEX.md). This guide establishes only that **dispatch is
> the department that reviews and approves labor before payroll runs**, and that the hour splits
> were computed upstream of that review. It says nothing about how they were computed.

---

## 7. Unit down time

Source: v2.2 guide, *How to Add Unit Down-time*. `Schedule > Unit Down Time`. Down time marks a unit
unavailable for *"preventative maintenance scheduling, mechanical failure, inspections, or anything
that should prevent the unit from being committed to a job."*

Per record: `Unit Code` (filterable by Schedule Type, Unit Type and All Yards / My Default Yard),
a **`Reason`** from a defined list, `Down Date` + `Down Time`, `Up Date` + `Up Time`, `Comments`.

**Down time appears as pink blocks on the Unit Schedule only** — *"will not appear on the Job
Schedule or Employee Schedule."* Compare the DAS's *"Mark Maintenance"* with greyed chips and a
maintenance-team approval step in [daily-allocation-system.md](daily-allocation-system.md); FCC has
no approval step and no cross-schedule visibility.

---

## 8. Trucking jobs, loads and axle groups

Source: v2.2 guide only. `Schedule > Trucking` is **a separate job screen** with its own shape: in
place of a single `Job Site` it carries **`Cust From` / `Loc From`** (origin) and **`Loc To`**
(destination, *"the Ship To location"*), and in place of `Equipment Required` it carries
**`Items to Ship`** and **`Instructions`**.

A trucking job adds a **Loads tab** with four nested tabs:

- **Load Main** — `Load No` (arbitrary, unique within the job), `Commodity`, `Customer From`,
  `Ship From`, `Customer To`, `Ship To`, `Load Date`/`Time`, `Delivery` date/time.
- **Load Detail** — `Permits`, `Comments`, `Directions`, `Routing`, and **two separate dimension
  sets: commodity weight/width/length/height and *loaded* weight/width/length/height.**
- **Load Unit/People** — associates the load with a schedule type and unit type.
- **Load Axle Groups** — `Steering Weight`, `Drive Weight`, then one row per **`Trailer Group`**
  with its `Axle Weight`.

That axle-group model is the legacy system's answer to scale weights, and it is the same concern
Melissa raised about tractor substitution — *"the 5th wheel axle and the tractor needs to be
adjusted so we make the scale weight"*
([crane-configuration-rules.md](crane-configuration-rules.md) §6.2). **The ERP has no equivalent
structure, and nothing in the drop asks for one.**

FCC also prints a warning worth carrying: *"No mapping software currently exists that accounts for
all route restrictions, including height restrictions… The mapping capability is intended for
reference and not for specific routing details associated with the movement of oversize loads."*

---

## 9. Unit Type Defaults — the legacy name for associated resources

Both guides describe the same feature under the v2.2 name. In the Unit/People tab, **tabbing out of
the `Type` column injects that unit type's configured defaults** — its related unit types, employee
types and billing codes — into the Resources tab *and* the Estimate tab at once. Everything injected
*"may be changed or deleted and new unit types, employee types, and billing codes may be added as
necessary."*

The v5.0 guide records a regression: *"Due to the transition from WinForms to WPF, the Unit Type
Defaults feature does not support nesting currently. Because of this, when estimate line items are
added via Unit Type Defaults, those lines will not appear as nested items."*

This is the dispatch-side face of the templates mapped in
[quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md),
and it corroborates that page's central finding from a second, independent document: **the same
configuration populates crew and estimate together.** Note the difference in keying, though — the
estimate-templates page shows FCC scoping those defaults by **(resource type, job type, yard)**,
while these dispatch guides describe the injection keyed on `Type` alone and say only that job type
*"affect[s] the job through configured Unit Type Defaults"*. **Neither guide states how the job type
and yard select which default set is injected.**

---

## 10. Estimates, in-house comments, storage, POs, tools

Compressed, because these are mostly other modules' surface. Recorded so no one re-reads 160 pages
to find out whether the guides cover them.

- **Estimate (Rental)** — one row per billing code with `Quantity`, `UM`, `Rate`, derived `Amount`,
  a `Billed` running total across invoices, `Comments` (which print on estimates and invoices),
  optional `Start`/`End`, `Unit Code` (which unit is credited the revenue) and `Line Item`.
  **Sub-items invert between generations:** in WPF you start from a summary line and nest under it.
  A summary line may only carry quantity **1, 0 or −1**, its UM is forced to **Each**, percentage-
  based codes may not be nested, and **only top-level lines are ever shown to the customer** —
  export and generated estimates drop the nested detail. Inactive billing codes render in red.
- **In-House Comments** — internal-only, audit-stamped, with a `For Invoice` flag that pushes the
  comment to the invoice screen and a `Resolved` flag set there, recording invoice number, resolver
  and date. **A user may edit another user's comment but may never delete it**, and a comment tied
  to an invoice can be neither edited nor deleted. The WPF change is that only comments explicitly
  flagged carry to the invoice — *"In Legacy, all comments that were not previously resolved would
  be included on the next invoice regardless of your intent."*
- **Storage** — customer-owned items in the yard. `Ticket Number` (unique within the job, ≤10
  chars), description, status, location, weight in pounds, height/length/width in feet and inches,
  `Date Received` (*"implies the start of the billing cycle"*) and `Date Shipped` (the end),
  unloaded/reloaded by, carrier in/out, and calculated unload / reload / monthly rates and amounts
  charged by **weight (÷2000 for tons), square feet or cubic feet** per `Admin > Set System
  Defaults`.
- **Purchase orders and invoices** are **read-only inside the job** — a Related Information count
  and a hyperlink to a modal. POs are created in `Enter > PO Requisition`.
- **Tools** — non-serialised accountable items (*"most rigging does not have serial numbers, but
  must be accounted for"*): `Category`, `Tool`, `Qty Out`/`Out Date`, `Qty In`/`In Date`,
  `Size/Comments`. **Explicitly stated: *"This information does not currently pass to e-tickets;
  this is used for internal tracking only."*** Compare [assets/tool-and-rigging.md](../assets/tool-and-rigging.md).
- **Lift Info** — up to 15 **administrator-renamable** fields (`Maintain > Field Names`), 10
  characters each; the first 10 print on job tickets, e-tickets and e-LEMs, the last 5 only on
  trucking tickets. Commonly `Back`, `Up`, `In`, `Radius`.
- **Daily exceptions** — per-date overrides of `Description of Work`, `Comments`,
  `Equipment Required` and every Lift Info value, which **replace** the job-level text on that
  day's ticket. *"The times in this pane will not pass to the e-ticket."*
- **Copy Job** — copies a past job with per-section checkboxes for what to carry and new start/end
  dates.
- **Job-related certifications** — a window comparing certificates required by the customer and job
  site against those held by the scheduled employees and units, with an email-to-customer action.
- **Maps** — job sites are geocoded via Google on create/modify; the map opens in the user's own
  browser, provider switchable between Google and Bing per user.

---

## 11. What this does and does not settle

**Corroborates, from a second independent source:**

- Category → Sub-Category is the shape FCC dispatches by (§3) — confirms
  `assets/fcc-units-and-schedule-types.md` §1.
- One configuration populates crew *and* estimate together (§9) — confirms
  `quotations/fcc-estimate-templates-by-job-type.md`.
- FCC carries per-unit GPS position and provenance already (§3).
- Crew notification is genuinely unsolved in the legacy system (§5) — corroborates
  `dispatcher-needs.md` and review-log entry #1.

**States plainly, for the first time in the vault:**

- The seven-state status enumeration, its four levels, and the fact that only Complete and Canceled
  constrain anything (§2).
- The one-ticket-per-resource-per-day rule and the multiple-unit-rows workaround for shifts (§5).
- Job Ticket = one unit, two employees; LEM = many, with one signing Primary (§5).
- Soft validations are advisory, universally overridable, and suppressible per unit (§4).
- The resource date/time **offset** inheritance model (§3).
- Dispatch reviews and approves labor before payroll runs (§6).
- Trucking is a separate job type with loads and axle groups (§8).

**Does not settle — do not infer:**

- Nothing here is a TCG requirement. Every behaviour is FCC's, and per-organisation configuration
  determines whether TCG even has it switched on.
- Neither guide says which of these behaviours TCG relies on, has customised, or wants changed.
- The guides never state how job type and yard select an injected default set (§9).
- The override on soft validations is not described as logged or reported anywhere (§4).
- Nothing says whether the ERP should adopt the one-ticket-per-day rule, and the DAS spec's
  *"Same Assets for Different Shifts"* toggle
  ([daily-allocation-system.md](daily-allocation-system.md)) points at a different model.

## What the guide's screenshots show — read 2026-09-04

*Source for this section: the 43 screenshots extracted from `DispatchingGuide.v2.2.docx`
(`media/image8`–`image92`; the cover logo, toolbar icons and nine images that duplicate the Quotes
and Service guides' screenshots were deduplicated or not extracted). Viewed 2026-09-04. This is
the **WinForms (2018) screen only** — the v5.0 PDF's screenshots were not part of this pass.
Everything below is read off the images.*

### What is *not* in the screenshots

Set expectations first, because the guide's title suggests more than its pictures deliver:

- **No dispatch board.** Not one screenshot shows the Unit, Employee or Job *Display Schedule* —
  the bar-chart views the best-practice sheet (§1) tells dispatchers to check. Columns, bar
  colours and the "pink bars" for unticketed employees or down time are **not visible anywhere in
  this guide's images**.
- **No right-click menus, no colour legend, no availability window.** The only colouring in any
  screenshot is the standard highlight on a selected dropdown value (`Confirmed`, in blue) and the
  blue-filled `Status` cells in a ticket grid; neither is a status colour scheme.
- **No filter dialogs** beyond the `View` dropdown on the Unit/People tab and the four header
  filters on the e-ticket review window.
- **No unit down-time screen of its own** — the two images under *How to Add Unit Down-time* are
  the Service guide's (see [../field-ops/fcc-nexgen-service-guide.md](../field-ops/fcc-nexgen-service-guide.md)),
  and there the grid is empty, so the `Reason` list is never shown.

### Menus and the main window

`Schedule` menu: **Jobs · Trucking · Unit Down Time · Employee Vacation/Leave** (`image20`,
`image49`). The Schedule Jobs toolbar reads `New Job · Add Est · Ins Est · Move Line · Del Job ·
Del Est · First · Previous · Next · Last · Copy Job · Map · Directions · Refresh · Save Layout ·
Save · Print · Close` (`image21`). Top-level menus: `File Edit Favorites Admin Maintain Enter
Display Schedule Reports Utilities Export/Import Window Help`.

`Enter` menu (`image72`) — recorded in full because it is the only place the drop lists NexGen's
transaction screens: **Labor ▸ · Materials ▸ · Inventory Stock Adjustments · Quotes ▸ · Order Entry ·
Order Pick Ticket Shipment · Work Orders · Work Order From Deficiencies · Deficiencies Reported As
No Repair Needed · Work Orders From Due PM's · PO's from Job/WO Estimates · Job Line Items · Job
Change Order · Equipment Allocation · Equipment Allocation From Excel · Current Hrs/Miles ·
Preventative Maintenance · PO Requisition · Purchase Orders · Receivers · Vouchers ▸ · Invoices ▸.**
`Enter > Labor` has four entries: *Labor, Labor by Job, Labor by Work Order, Labor for Payroll
Pre-Processor* (`image78`). `Enter > Invoices` has eleven: *Invoices, Service Invoices, Parts
Invoices, Invoices from Orders, AIA/Percent Complete Invoices, T&M Invoices, Recurring Invoices, Job
Storage Invoices, Auto Billing, E-Tickets Not Approved or Invoiced, E-Tickets Not Invoiced.*

### The Schedule Jobs window, tab by tab

Tabs, left to right: **Main · Unit/People · Est Billing · Act Billing · Lift Info · In House ·
Tool List · Daily · Storage · Owner Info · PO · Line Item** (`image14`, `image41`, `image48`). One
FAQ screenshot (`image92`) shows **Additional Info** in the place of *Owner Info* — a different
build or configuration; the guide does not say which. A lightning-bolt (attachments) button sits
top-right on every tab.

**Main** (`image14`, `image21`, `image24`). Left column: `Job No` (`AUTO`), `Yard`, `Company`,
`Dept` (sample `Cranes, Operated`), `Customer` (`New` button + search), `Bill To` (`Corporate
Address`), `Job site` (`New`), `Report To` and `Ordered By` — each with `New`, a dropdown, and
**`WP` / `CP` phone pairs plus `E-Mail`**; a read-only **Bill To Information** block (Address,
Phone, Fax, **`Price List`**) and **Job Site Information** block (Address, Phone, Fax,
`Directions`). Right column: `Job Date` / `To` each with a `Flexible` checkbox, `Job Time` / `To`
each with `Flexible`, **`Work Weekends`** ☑ and **`Dispatched`** ☐, `Job Type` (sample `Hourly`),
`Checked By`, `Sales Person`, `Taken By`, `Status` (`Confirmed`), `PO No`, `Equipment Required`,
`Comments`, `Description Of Work`, `Terms & Conditions` (sample `Terms - GA`), **`Insurance` ☐ +
`Expires`**, `Signed Contract` ☐, **`Contract No`**, `Billing Type` (`Rental`), `Certified Pay` ☐,
`Retainage %`, `Check List`, and a `Created By / Created Date / Modified By / Modified Date` audit
block. Defaults visible on a blank job: time `07:30 AM`–`04:30 PM`, `Work Weekends` on, status
`Confirmed`.

> Compared with §2 above (written from the v5.0 guide): the WinForms Main tab **has** a `Dispatched`
> checkbox, `Insurance`/`Expires`, `Contract No` and `Check List`, and **does not have** `Industry`,
> `Union`, `MSHA` or `Project Number` — `Project No` and `OCIP` sit on the *Owner Info* tab
> instead. Neither guide says what `Dispatched` does.

**Unit/People** (`image17`, `image18`, `image28`, `image29`, `image64`). Header: `View` dropdown
(`Units/Employees For All Yards`), buttons **`Show Hours/Miles`** and **`Show Tickets`**. The grid
has a three-row header:

| Row | Columns |
| --- | --- |
| 1 | `Unit/Emp` · `Type` · *(Avail button)* · `Unit/Employee` · `Operator` · `Date Start` · `Date End` · `Time Start` · `Time End` |
| 2 | `Unit Status` · `P/U` · `Ret To Yard` · `Oiler` · `Talked To` |
| 3 | `Comments` |

`Unit/Emp` holds the schedule type (`Crane - N…`, `Truck`, `Trailer`, `Employee`); `Type` the unit
or employee type; `Avail` opens availability; `Unit/Employee` the specific resource. A unit row
carries `Operator` and `Oiler` dropdowns directly, and **employee rows nest under the unit** with
their own dates/times and an unlabelled checkbox in the `Talked To` position. `Show Tickets` opens
a grid under the resources: **`Ticket · Date · Type · Start · End Time · In Yard Time · Comments ·
Status`**, with statuses `Not Started` and `Left Yard` visible (`image69`, `image71`).

*Unit Type Defaults in action* (`image18`, `image19`): choosing type `500 Ton Taxi Crane` on one
unit row injected **Employee/Operator 1st class, Employee/Oiler, Truck/Tractor, Trailer/Trailer,
Employee/Driver** rows, and on Est Billing the lines *500 Ton Crane 8 Hours @ $650 ("8 Hr Minimum
per Day")*, *Labor Overtime @ $30/Hour*, *500 Ton Crane 1 Hour @ $650 (line item Mobilization
In & Out)*, *Trucking – Legal 5 Each @ $500*, *Trucking – Permit…*. This is the crew-and-estimate
co-population §9 describes, seen once.

**Est Billing** (`image19`, `image30`, `image32`, `image33`). `Show Invoices` button; three-row
header: `Billing Code · Date Start · Date End · Next Bill · Est Qty · Unit Meas · Est Rate · Est
Amount · Sub-Item ☐` (labelled `Item` on the blank-grid screenshot) / `Act Qty · Act Rate · Act
Amount · Recurring No · Est Qty 2 · Unit Meas 2 · Est Rate 2 · Est Amount 2` / `Unit Code ·
Comments · Line Item · Est Qty 3 · Unit Meas 3 · Est Rate 3 · Est Amount 3`. So **each billing
line can carry up to three quantity/UM/rate tiers**, a `Next Bill` date and a recurring number, a
credited `Unit Code` and a `Line Item` — none of which the text describes. Footer: `Est. Qty`,
`Act. Qty`, `Est. Total`, `Act. Total`.

**Lift Info** (`image34`). Two groups: *Lift Info* — `Lift Radius, Height, Crane Capacity, Pieces,
Total Weight, CWT Config., Boom Length, Set Back Fr. Bldg., Radius, test height` (10 fields; the
last is obviously a renamed test field) — and *Trucking Info* — `Length, Width, Height, Pieces,
Total Weight` (5). Confirms the 10 + 5 split in §10.

**In House** (`image35`, `image37`): `Comments · Created By · Created Date · Modified By · Modified
Date` only — **no `For Invoice` or `Resolved` flags in this generation**; those are WPF (§10).

**Tool List** (`image38`, `image40`): `Category · Tool · Qty Out · Out Date · Qty In · In Date` /
`Size/Comments`. Sample: `Rigging Components` / `Spreader, Set - 3/4" x 20'` / comment *Adjustable
length (14'-20')*.

**Daily** (`image41`, `image43`): `Date · Time Start · Time End · Comments · Work Description ·
Equip Required` on row one, then **all fifteen Lift Info fields** as three further header rows —
the per-day override grid §10 describes. Sample row: *Deliver 2nd load to jobsite / Offload on N
side of building / 2 chillers*, radius 40, boom 8.5, 8 pieces, 40,000 total weight.

**Storage** (`image44`, `image45`): `Ticket No · Item Description · Location · Weight · Height
(Ft) (In) · Length (Ft) (In) · Width (Ft) (In)` / `Date Received · Date Shipped · Next Bill Date ·
Unload Charge · Reload Charge · Monthly Charge · Act Monthly Amt` / `UnLoadedBy · ReloadedBy ·
Delivered By · Trucking Company · Status · Comments`; footer `Net Monthly Amount`.

**Owner Info** (`image46`): `Owner Same as Customer Address` ☑, `Owner Name`, `Address`, `City`,
`State`, `Zip`, `Country`, `Phone`, `Legal Description`, `Pre-Lien Date`, `Pre-Lien Amount`, `Lien
Date`, `Lien Amount`; on the right `Project No` and `OCIP` ☐.

**PO** (`image47`): read-only `PO # · Vendor · Part # · Description · Qty Ordered · Qty Open · Cost`
with a `Total`. **Line Item** (`image48`, `image92`): `Line # · Line Item · Amnt Quoted · Est
Expenses · Est Hours` / `Exp/Rev/Both · Invoiced To Date · Act Expenses`; sample line items *Daily
Work*, *On-Site Operation*, *Mobilization In & Out*, each flagged `Both`.

**File links** (`image8`, *Maintain File Links – Job*): `File Name / Comments · Envelope Status /
Available On Tickets ☐ · Created By / Created Date · Modified By / Modified Date`. The `Available
On Tickets` checkbox is the job-side equivalent of the work order's `Include On Unit`.

### Trucking jobs

*Schedule Trucking Jobs* (`image50`, `image51`) reuses the job window with these differences on
Main: `Dept` sample `Bare Rental`; **`Loc To`, `Cust From`, `Loc From`** in place of a single job
site; **`Items to Ship`** and **`Instructions`** above `Description Of Work`; `Signed Contract` and
`Certified Pay` present but **no `Insurance`, `Contract No`, `Billing Type` or `Retainage %`**; and
two address blocks, *Job Site From Information* and *Job Site To Information*.

Its Unit/People tab (`image53`, `image54`) adds two columns — **`Bill of Lading`** and **`Load
No`** — and swaps the buttons to `Show Hours/Miles · Hide Tickets · Generate Ticket · Delete
Ticket`; with an employee row selected the last pair reads **`Generate LEM · Delete LEM`**. The
ticket grid beneath is the same `Ticket No · Date · Type · Start Time · End Time · In Yard Time ·
Comments · Status`.

### Ticket review — the *E-Tickets Not Approved or Invoiced* window

(`image73`, `image74`, `image77`.) Header filters **`Company · Yard · Department · View By`** (sample
`All`) and a `View` button; row buttons **`View Job`** and **`View Ticket`**; a legend line
`WTL - Worked Through Lunch`. Two-row column header:

| Row | Columns |
| --- | --- |
| 1 | `Ticket No · Type · Date · Job · Job Start · Job End · Actual Time · Unit · Employee · WTL ☐ · ST · OT · DT · Status · Billing Comments` |
| 2 | `Left Yard · Arrived Job · Left Job · Arrived Yard · Customer · Job Site · Ticket Comments` |

Ticket `Type` values seen: **`LEM`, `Operator`, `Load`**. `Status` values seen: `Approved`,
`Not Approved`. `Actual Time` prints in hours (`00.05 Hrs`). The four timestamp columns are the
e-ticket's yard/job clock punches. This is the screen §6 describes; the text did not give its
columns.

### The printed e-ticket

Two pages of ticket 914 (`image75`, `image76`) show what a signed NexGen e-ticket contains:

- **Page 1** — yard address header; `Date`, `Job No`, `Ticket No`; `PO #`, `Terms`, `Sales
  Person`, `Customer` + address/phone, `Job Site` + address/phone, `Directions`, `Alt Phone`,
  `Report To` and `Ordered By` (each with CP, WP, E-Mail), `Work Description`, `Comments`,
  **`Equipment`** (printed as schedule type / unit type / unit code — `Crane - Ne… 110 Ton Hyd Trk
  110MH03`), **`Employees`** (type – name), `Equip Required`; a box **"Have Signed At Start of
  Job"**; `Accepted Terms and Conditions` ☑, `Signer's Name`, `Date` + time, `By / Authorized
  Signature` (a drawn signature).
- **Page 2** — `Time Left Yard`, `Time Left Job`, `Time Arrived Job`, `Time Arrived Yard`; a
  `Signer's Name` box beside *"The above hours are verified to be correct"*; **`Worked Through
  Lunch` ☐**; signer, date, signature; `Ticket Comments`; then the **Terms & Conditions** text,
  headed by a state (`MICHIGAN` in the sample) — indemnification and insurance clauses.

So the legacy ticket collects **two customer signatures — one at start of job for the T&Cs, one at
end for the hours** — and the WTL flag is captured on the signed hours page. Compare the
e-ticket description in [../field-ops/fcc-e-ticket-and-atom-guides.md](../field-ops/fcc-e-ticket-and-atom-guides.md).

### Labor review — the *Labor for Payroll Pre-Processor* window

(`image79`, `image80`.) Header: `Yard` (sample `All Yards`), `Employee` (search) with a
**`Name` / `ID`** radio toggle. Summary grid: `Work Date · Craft Code · Job · WO · Unit Code ·
Quantity`. Detail pane for the selected row: `Work Date` (with the weekday spelled out beside it
and, in the sample, a label reading **`50% Union Apprentice`** — the guide does not say where this
label comes from), `Union` (code + name, sample `OP03 Operators Local 381`), `Craft Code` (sample
`FORE-A ForeMan-Regular Earnings`), `Boom Lgnth`, `ST Hours`, `Shift` (`N/A`), `Work Comp` (code +
description), `Burden` (code + description), `Class` (sample `Labors`), `Job` (search),
**`Job Line Item`**, `Work Order` (search), `Unit Code` (search), `Activity`, **`Approved` ☐ with
two read-only fields beside it** (name, timestamp), `Comments`. Footer: employee name, **`For
Payroll Date: <from> - <to>`**, and `ST Hours · OT Hours · DB Hours · Total Hours`. Confirms §6 and
adds `Job Line Item`, the Name/ID toggle and the payroll-period footer.

### Bearing on §9 — how defaults are keyed

The Service guide's *Unit Types* maintenance window (`Service Guide v.2.0.docx`, `media/image15`)
has tabs **`Main · Job Type · Yard · Unit/People · Estimate`**. The `Unit/People` and `Estimate`
tabs are where the injected crew and billing lines are defined; **`Job Type` and `Yard` tabs sit
beside them**, which is consistent with the (resource type, job type, yard) keying in
[../quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md).
The screenshot shows only the tab strip; **it does not show what those two tabs contain, so the
question in §9 and §11 stays open.**

## Source

`shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/`

- `NexGen_WPF_Dispatch_User_Guide_v5.0.pdf` — 110-page PDF, v5.0 dated January 2023; converted with
  `pdftotext -layout`. Screenshots carry much of the guide's meaning and are lost in conversion;
  every table above was reconstructed from surrounding prose, and the status tables in particular
  lost their state-name column, so the seven names are taken from the guide's own definitions text
  and the code letters from the Main-tab table.
- `OneDrive_2025-10-29/DispatchingGuide.v2.2.docx` — 53 pages, v2.2 published 2018-03-28 by David
  Thornton (version-control table gives v1.0 2017-05-18 → v2.2 2018-03-28); converted with pandoc
  to GFM. Heavily illustrated; the 43 extractable screenshots were read on 2026-09-04 — see
  *What the guide's screenshots show*.
- `OneDrive_2025-10-29/Dispatch High Level Best Practices.docx` — one page, undated, no author
  named; converted with pandoc. Quoted almost in full in §1.

## Related — added 2026-09-04

- The 53-row table FCC uses to decode a ticket's displayed status from its type, letter code and flags — the rule behind the lifecycle this guide narrates: [../payroll/tcg-rawfms-staging-database/data/fcc-ticket-status-matrix.md](../payroll/tcg-rawfms-staging-database/data/fcc-ticket-status-matrix.md). Job status / job type / department codes: [../payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md](../payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md).

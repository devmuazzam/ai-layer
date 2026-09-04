---
title: The dispatch sheet as it is actually run — Lisette's daily workbook
source: shared-folder/Project-Repository-2026-09-04/3.3.1_MODULE-DISPATCH-JOBS/DISPATCH Technical Specs/Dispatch 2026- .xlsx
migrated: 2026-09-04
updated: 2026-04-14
status: unverified
conflicts_with: []
jira: []
tags: [module/dispatch, module/assets, module/payroll, kind/source, scheduling, daily-allocation, permits, certifications, overtime, reference-data]
entities: []
---

# The dispatch sheet as it is actually run — Lisette's daily workbook

**What this is.** `Dispatch 2026- .xlsx` — the **live Excel workbook TCG dispatches from**,
delivered in the 2026-09-04 drop inside `3.3.1_MODULE-DISPATCH-JOBS/DISPATCH Technical Specs/`.
It is the artefact behind every "replace Excel" statement in this module. Melissa attached it to
her 2026-04-03 email asking that the ERP's dispatching section *"look more like her current
dispatch sheet so it's easy to see where everything is at in a quick glance"*
([crane-configurations.md](crane-configurations.md) §2).

**Why it matters beyond what the vault already holds.** The two annotated PDFs already migrated in
[crane-configurations.md](crane-configurations.md) are *one page* of this workbook with callouts
drawn on it. The workbook itself gives three things those PDFs cannot: the **blank master
template** (so the grid is separable from any one day's data), **98 consecutive filled days** (so
the conventions can be seen to be conventions rather than one-offs), and **two sheets that are not
the dispatch sheet at all** — a crane-size operator qualification matrix and two review copies.

> **Bulk data not copied.** Per the drop's ingestion rules, the row data — 98 days of job
> assignments, crew names, customer names and equipment allocations — is **not** reproduced here.
> What follows is the workbook's *structure*, its *conventions*, and single illustrative cell
> values. The crew rosters and the name-level qualification matrix are deliberately not
> transcribed. Read the workbook itself when a specific day matters.

---

## 1. What is in the workbook

**105 sheets.** Seven are named; 98 are dated.

| Sheet | What it is |
| --- | --- |
| `MASTER` and `MASTER-2` | **The blank template.** Full grid, every unit code printed, every crew and equipment list present, no job assignments. `MASTER-2` is the wider of the two (`A1:U67`). |
| `Lisette` | A second blank master carrying an **expanded legend** (§3) — the only sheet where the legend distinguishes *Downed equipment* from *Double Time* and adds two codes. |
| `Master Review` and `Master Review kyle` | Two **filled review copies** of the same day, side by side — one apparently Kyle's. Narrower (`A1:S49`). These are the only sheets showing the tractor column used heavily, and the only ones where *"crane-tractor onsite"* appears as a `TRCTR` value. |
| `Empolyee Qualification` *(sic)* | **Not a dispatch sheet** — an operator × crane-size qualification matrix and a separate oiler roster (§5). |
| `Sheet2` | Empty (`A1:A1`). |
| 98 dated sheets | One sheet per dispatch day, named `M.D` or `M.D.YY` — `9.12` through `4.14`, i.e. roughly **2025-09-12 to 2026-04-14**. Each is a copy of the master with that day's assignments typed in. |

**One sheet per day, copied from a master, kept forever in one file.** That is the working method
the ERP is being asked to replace, and it is worth stating plainly: there is no per-job record —
the job exists only as text in a cell on the day it happens, and history is 98 near-identical
spreadsheet tabs.

---

## 2. The grid

From `MASTER-2`, the widest blank template. The sheet is one screen, laid out as **three crane
columns across the left and centre, a truck column, and a legend column at the right**, with
availability and trucking blocks below.

**Each of the three crane columns repeats the same header:**

`CRANE | OPERATOR | TRCTR | CUSTOMER | P/LP/RL/SS`

— except the **left-hand column omits `TRCTR`**, because the units in it (22-ton boom truck, the
40-ton family, the rough terrains, the self loaders) go out without a tractor. That is exactly the
below-90-ton rule already derived in
[crane-configuration-rules.md](crane-configuration-rules.md) §3.2, **here confirmed by the sheet's
own layout rather than by inference from the workbook column.**

Under each crane row sit its counterweight rows, blank-labelled `CWT`, `CWT.1`, `CWT.2`, `CWT.3`,
`CWT.4` — the `.1/.2/.3` support-load convention of
[crane-configurations.md](crane-configurations.md) §1, printed as fixed rows in the template. The
number of `CWT` rows is **pre-printed per crane** and varies: `10001` has one, the 265-ton and
275-ton have three, the 350-ton and 360-ton have four. The blank master PDF's annotation says the
same thing in words — *"This crane only has 1 load of counterweight so there is only 1- cwt under
the crane's unit #"*.

**Unit codes carry qualifiers in the cell text itself**, not in a separate column:

- `4001 No MB- Yes Jib`, `4002- No MB - Yes Jib`, `4003- Yes MB + Jib`, `4004  Yes MB- No Jib` —
  material basket and jib fitment written into the unit label.
- `14001-LB` and `14002-SB` — two 140-ton cranes distinguished by **LB / SB** in the code.
- `RT`, `RT - 65-Ton`, `RT-Mon- Sat`, `RT- Mon- Fri` — rough terrains, sometimes with their
  **rental window written into the unit cell**.
- On the 200-ton, the `CWT.3` row carries `Make sure cheek weights are loaded` — a standing
  instruction parked in a trailer cell.

**Other blocks on the sheet:**

| Block | Columns / content |
| --- | --- |
| `Trucks` | one row per tractor — `AT08`, `AT10`–`AT31` — each with its assigned driver, or `Open` |
| `TRUCKING` | `Driver` · `Trailer/Equip` · `Truck` · `JOB` · `Permit` — the separate trucking dispatch |
| `Equipment` | trailer and truck inventory: `TRSD01`, `TRLB01- 21'6"`, `TRDD01-T9'10'B-37'9`, `TRFB02-45'`, `TRFB03-03'40"`, `TRFB04-40'`, `TRFB05-48'`, `FBT 1.12`, `UT-1`, `ST01`, `PT01`… |
| rented tractors | `AT10` → `Rental 306119`, `AT11` → `Rental 326318`, … — rentals tracked against the AT slot they fill |
| crew availability | an unlabelled block of available crane members, laid out five names wide |
| `Customer` / `RIGGING` / `CRANE` | the rigging-job block, on the left under the small cranes |
| `OFF` | employees off that day |
| `Job #` / `Pick Up` / `Drop Off` | a small self-loader block |

Printed across the middle of the sheet, in the master and every daily copy:
***"Emergency & Add-On Jobs: MUST be Operator & Oiler"*** — already recorded as
[crane-configuration-rules.md](crane-configuration-rules.md) §3.5, and confirmed here as a standing
line of the template rather than a one-day note.

---

## 3. The legend — and the fuller version on the `Lisette` sheet

Colour carries state. The legend printed on every sheet (already in
[crane-configurations.md](crane-configurations.md) §2) reads:

`Double Time or Down Equipment` · `Ticket Sent` · `Confirmed Work` · `All Confirmed` ·
`Needs to be covered` · `Subbed out / Outside Trucking` · `working dy and night`

**The `Lisette` sheet carries a longer one**, and this is new material — it is the only place in the
drop where these are written down:

| Added on the `Lisette` sheet | Note |
| --- | --- |
| `Downed equipment` as an entry **separate from** `Double Time or Down Equipment` | the standard legend collapses two meanings into one colour; this sheet splits them |
| `X - Not being used` | the `xxxxx` marking on CWT rows, which the filled PDF glosses as *"the additional loads of counter weight are not needed for this job"* |
| `SS - Screen shot / Job layout` | expands `SS`, which the standard legend leaves as *"screen shot"* |

**The colours themselves are not recoverable from the converted text** — the conversion is a cell
dump and carries no fill. The mapping colour → meaning in
[crane-configurations.md](crane-configurations.md) §2 came from the annotated PDFs and stands; this
workbook confirms the *label set* but cannot confirm the colours.

The `NOTES` block, present on every sheet:

- *"If guys work the night before the crew will be red with the previous work date"*
- `SS- screen shot` · `LP- Lift Plan` · `TP- Travel permit` · `RCSP- RCS permit` ·
  `RL- Restriction list`

which is the `P/LP/RL/SS` column decode already recorded — **permit, lift plan, restriction list,
screen shot** — here with `TP` and `RCSP` as permit sub-kinds.

---

## 4. Conventions visible only across the filled days

Read off the dated sheets and the two review copies. Each is a **convention in use**, not a stated
rule — the workbook nowhere defines any of them.

- **`Down` in the OPERATOR cell** marks a unit out of service (`20001` → `Down`, `14002-SB` → `DOWN`).
  There is no separate down-time record; the crane's own operator cell is overwritten.
- **`Open` in an OPERATOR or truck cell** means unassigned and needing cover. `Chris T/Open` — one
  name and a fallback in the same cell.
- **`onsite` in a CWT operator cell** and **`crane-tractor onsite` in the `TRCTR` cell** mark
  holdover state — the load or tractor is already at the job site and is not leaving the yard that
  day. Alongside them the customer cell reads `Holdover`, `Edison- Duarte- HOLDOVER`,
  `LADWP-Holdover 6 am onsite`, `Matrix- Holdover`, `2nd Matrix - Holdover`.
- **`Report to jobsite`** appears in the `TRCTR` column where the crew drives their own vehicle to
  site — the personal-vehicle leg Lisette described for holdover jobs
  ([crane-configuration-rules.md](crane-configuration-rules.md) §10).
- **A tractor code in the `TRCTR` cell** (`AT13`, `AT18`, `AT19`) binds that tractor to that
  counterweight load for the day; a **rental number** (`306093- Rental`, `396067- Rental`) does the
  same when the tractor is hired in. This is the instance-level binding
  `crane-configuration-rules.md` §6.1 says the type-level model cannot express — **and here it is,
  being maintained by hand, per load, per day.**
- **The customer cell doubles as the job description**: `Edison- Mountain View Holdover`,
  `Edison Rowland-140`, `culver city- 175 NIGHT`, `hotline 90 Wcovina`, `265 W lowboy`,
  `edison- menifee 3 days`. Customer, city, crane size, shift and duration are one free-text field.
- **`NIGHT` and a `Day Shift` block** carry shift; there is no shift column.
- **Trucking rows use `""` for repeat**: three flatbeds on the same holdover show
  `Patrick M` against `Flatbed#1 xtralease`, then `""` against `Flatbed#2` and `Flatbed#3`
  — one driver, three trailers, expressed by ditto marks.
- **`rigger with SL01` / `Rigger with SL02`** in the trucking `Trailer/Equip` column pairs a rigger
  to a self loader — riggers are dispatched through the trucking block, not the crane block.

> **These are the conventions any migration has to decode.** Every one is free text in a cell that
> means something specific to the person typing it. The drop contains no key for them beyond the
> legend in §3; the readings above are what the cells plainly say, and where a reading is an
> inference it is marked as such. **Do not treat any of them as a specification.**

---

## 5. The operator qualification matrix

Sheet `Empolyee Qualification` (spelled that way in the file). Two independent blocks:

**Left — operators × crane sizes.** Rows are operators (surname, forename). Columns are the crane
capacities an operator may be qualified on, marked `x`:

`22 Ton` · `40 Ton` · `45 Ton` · `90 Ton/100 Ton` · `110 Ton` · `140 Ton` · `200 Ton` ·
`265 Ton` · `300L` · `360`

**Right — oilers.** A plain roster of oilers by name, under a header row carrying the same capacity
columns (`90 Ton/100 Ton`, `110 Ton`, `140 Ton`, `200 Ton`, `265 Ton`, `300L`, `360`) — **but no
`x` marks are recorded against any oiler**. Whether oilers are simply not size-qualified, or the
matrix was never filled in, the sheet does not say.

**Names and their individual qualification marks are deliberately not copied here.** Twenty-four
operators and twenty-seven oilers are listed; only a handful of operator rows carry any `x` at all,
so **the matrix is largely empty in this copy** and must not be read as the qualification record.

What matters for the ERP is the *shape*: **dispatch keeps a per-operator, per-crane-capacity
qualification list, maintained separately from the schedule, and consults it when assigning.** The
Set Schedule / Assigned Equipment playbook states the same duty in words — *"Confirm if any
certifications are required for a job and that the employee is qualified"* and *"Confirm operators
are qualified for specific projects"*
([dispatch-value-engine-and-playbooks.md](dispatch-value-engine-and-playbooks.md) §4).

Note the capacity list is **not** the sub-category list: it groups 90 and 100 ton into one column,
and names `300L` and `360` in a form that appears nowhere in the asset workbooks. Reconciling it
against `SubCategory` is unresolved.

---

## 6. What this bears on

- **The DAS three-panel screen** ([daily-allocation-system.md](daily-allocation-system.md)) is a
  direct replacement for this grid. Its asset panel, employee panel, availability counters, colour
  legend and status chips each have a named antecedent here. The workbook does **not** confirm or
  contradict any DAS acceptance criterion — it shows what the criteria are trying to displace.
- **The conflict stub** [daily-allocation-INDEX.md](daily-allocation-INDEX.md) records that the two
  DAS sources are complementary rather than rival. **This workbook does not bear on that conflict**
  — it is a third artefact of a different kind (the current manual practice), not a third
  specification. It neither resolves the stub nor adds to it.
- **Review-log entry #14** ([erp-review-log.md](../erp-review-log.md)) asks the ERP to notify
  dispatch when an employee is scheduled more than 10–12 hours and of the gap between scheduled
  jobs. The sheet's `Double Time` colouring and the note *"If guys work the night before the crew
  will be red with the previous work date"* are the manual version of exactly that check.
- **Review-log entry #4's dispatch tier order and last-crew entitlement rules** are not visible in
  the sheet at all. The sheet records *who is assigned*; it records nothing about *who was offered
  the work first*, which is what the union rule turns on.

---

## 7. Open, and not to be inferred

- **The colour → meaning mapping cannot be verified from this file.** It rests on the annotated
  PDFs alone.
- **No key exists for the free-text conventions in §4.** `onsite`, `crane-tractor onsite`,
  `Report to jobsite`, `Open`, `Down`, `""` and the customer-cell composite are read off usage.
- **The qualification matrix is nearly empty** and its capacity buckets do not line up with the
  sub-category list. Nobody has said which is authoritative.
- **`Master Review` and `Master Review kyle` are two versions of the same day** with different
  assignments. Nothing says which is the operative one, or what "review" means here — whether it is
  a proposal, a check, or a second dispatcher's draft.
- The workbook covers **2025-09-12 to 2026-04-14 only**; it is not stated whether earlier and later
  days live in other files.

## Source

`shared-folder/Project-Repository-2026-09-04/3.3.1_MODULE-DISPATCH-JOBS/DISPATCH Technical Specs/Dispatch 2026- .xlsx`
— 105 sheets, converted by per-sheet row dump (cells joined by ` | `). **Cell formatting, and
therefore every colour the legend depends on, is lost in conversion.** Row data not copied; see the
note under *What this is*.

Companion files in the same two folders, already covered elsewhere:
`Dispatch PDF Blank Master.pdf` and `Dispatch PDF filled out.pdf` are the annotated one-page
extracts of this workbook, migrated as [crane-configurations.md](crane-configurations.md);
`ASSETS_DISPATCH_(Lisette-approved).xlsx` is migrated as that file and
[crane-configuration-rules.md](crane-configuration-rules.md);
`_from Melissa 2026-04-03 (DISPATCH Technical Specs).txt` is the covering email, quoted in
`crane-configurations.md` §2.

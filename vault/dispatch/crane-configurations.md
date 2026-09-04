---
title: Crane configurations and the dispatch sheet
source: shared-folder/3.3.1_MODULE-DISPATCH-JOBS + shared-folder/Project-Repository-2026-09-04/3.3.1_MODULE-DISPATCH-JOBS (the same folder redelivered, plus DISPATCH Technical Specs/Dispatch 2026- .xlsx)
migrated: 2026-08-29
updated: 2026-05-05
status: unverified
conflicts_with: []
jira: []
tags: [module/dispatch, module/assets, kind/reference, scheduling, crane-configuration, counterweight, gps]
entities: [asset, unit, job, job-ticket, employee, schedule, trailer, tractor]
---

# Crane configurations and the dispatch sheet

Source: `3.3.1_MODULE-DISPATCH-JOBS/` — two annotated dispatch-sheet PDFs, the
Lisette-approved asset workbook, and two emails from **Melissa McNutt** (President).
The `Dispatcher Needs` PDF in the same folder is already migrated as
[dispatcher-needs.md](dispatcher-needs.md) — same content, no need to read it twice.

**Why this matters:** it is the first source that says *what a crane configuration
actually is*. Everything before it described dispatch as jobs against cranes and crews;
this says a crane is not one dispatchable thing.

> **The rules are in a separate file.** This one describes the artefacts. For what is
> *binding* — cardinality, load ordering, crew pairing, ticketing, what `isRequired`
> means and who picks a configuration — read
> [crane-configuration-rules.md](crane-configuration-rules.md), which sources every rule
> to the 2026-04-14, 2026-05-19 and 2026-05-21 meetings this file did not reach.

> **Re-confirmed and extended by the 2026-09-04 drop.** That drop redelivered this whole folder
> unchanged — the two PDFs, the approved workbook and both Melissa emails are byte-equivalent to
> what this page was written from, so **nothing below is corrected**. It also delivered, for the
> first time, the **live workbook these two PDFs are a page of**:
> [dispatch-sheet-workbook.md](dispatch-sheet-workbook.md). Read that for the blank master grid,
> 98 filled days, the fuller legend on its `Lisette` sheet, and the operator qualification matrix.
> Where it bears on a section here, it is cited inline below.

---

## 1. A crane goes out as several units, each with its own ticket

From `ASSETS_DISPATCH_(Lisette-approved).xlsx`, the "Standard Dispatching Configuration
Examples" column. Worked example, the 265-ton:

| Unit code | Unit name | Crew role | Ticket |
| --- | --- | --- | --- |
| `26502` | 265 Ton All Terrain Crane | Operator | #1 |
| `26502 OL` | 26502 Operator Load | Operator | rides with the crane |
| `26502.1` | 265 Ton Support Load | 3rd man or rigger | #2 |
| `26502.2` | 265 Ton Support Load | 3rd man or rigger | #3 |
| `26502.3` | 265 Ton Support Load | 3rd man or rigger | #4 |

The rules, quoted from the blank master's own annotations:

- **Unit code = capacity + fleet sequence.** *"Crane Number = Crane size + the order we
  added it into the fleet — So this is a 100 ton crane and the first one we bought"*
  (`10001`).
- **`OL` = operator load, mandatory.** *"Matching crane number right under the crane is
  the first load of counter weight that we call the operator load — this load is require
  to go out anytime the crane goes out — all the cranes from 9001 and on require this.
  4005 and 4006 sometimes require this in different configurations."*
- **`.1` / `.2` / `.3` = optional support loads.** *"The items labeled .1, .2, .3 and so
  on are additional counterweight loads. These loads are not always required when the
  crane goes out. It will depend on the crane's configuration."*
- **One load is not always one counterweight.** The 190-ton uses `19001BD — Cwt Trailer`;
  the 350-ton runs up to four extra loads (tickets #2–#5).
- **Each support load carries its own crew member**, typed in the workbook as
  *"3rd man or rigger"* — which is where the client's separate asks for a **Third Man**
  role and an **Operator / Rigger** classification come from.
- **`xxxxx` against a `CWT` row on the filled sheet** means *"the additional loads of
  counter weight are not needed for this job"* — i.e. the configuration is chosen per job,
  not fixed per crane.

Sizes present in the approved workbook: 22, 30 (self loader), 40, 45, 60, 90, 100, 110,
140, 190, 200, 265, 275, 350, 360, 550 ton, plus rough-terrain and re-rents.

---

## 2. The dispatch sheet's own legend

Lisette's sheet encodes state in colour. Melissa's 2026-04-03 email asks the DAS view to
*"look more like her current dispatch sheet so it's easy to see where everything is at in
a quick glance… This could be more like a dashboard with drag and drop functionality."*

| Colour | Means |
| --- | --- |
| Grey | Ticket sent |
| Red | Double time **or** down equipment |
| Pink | Confirmed work |
| Green | All confirmed |
| Yellow | Needs to be covered |
| Blue | Subbed out / outside trucking |
| Purple | Working day **and** night |

Annotated on the filled sheet:

- Red on a crane row — *"the crane is not going out but the crew assigned to it is on
  double time. If the crew is working but they are on doubletime their names will be here
  but in red."*
- Red on a name block — *"Indicates the crew is available but they would be on double time."*
- *"If guys work the night before the crew will be red with the previous work data."*
- `onsite` on the CWT rows plus **Holdover** — *"Crane is staying on site."*

**Column `P/LP/RL/SS`** on every crane block decodes from the sheet's own notes:
**P**ermit · **L**ift **P**lan · **R**estriction **L**ist · **S**creen **S**hot, with
`TP` = travel permit and `RCSP` = RCS permit. Its purpose is stated: *"Permit is obtained
for this job — this is important for a quick view in case we need to change the schedule
after hours."*

**The `Lisette` sheet of the live workbook carries a longer legend** than the one printed on the
daily sheets, and it splits one of the entries above: `Downed equipment` is listed *separately* from
`Double Time or Down Equipment`, and two codes are spelled out that the daily legend leaves
implicit — `X - Not being used` (the `xxxxx` marking) and `SS - Screen shot / Job layout`. See
[dispatch-sheet-workbook.md](dispatch-sheet-workbook.md) §3. **The colours themselves are not
recoverable from the workbook** — its conversion is a cell dump and carries no fill — so the
colour → meaning table above still rests on these annotated PDFs alone.

Other blocks on the sheet: assigned **TRCTR** (tractor) and assigned trailer per crane;
a trucking section (Driver / Trailer-Equip / Truck / Job / Permit); available crane
members; available tractors and semi trucks; an **OFF** list; rentals. And a standing
rule printed across the middle: ***"Emergency & Add-On Jobs: MUST be Operator & Oiler."***

---

## 3. GPS-verified time

Melissa, 2026-04-18, in full: *"Note on the job we would like to add a time verified by
GPS — just a click button or check box."*

That is the entire requirement as stated. See [gaps.md](gaps.md) — it does not say which
time, whose GPS, or what "verified" asserts.

**The same ask is logged independently** as entry **#5** of
[erp-review-log.md](../erp-review-log.md) (Melissa, Dispatch, 2026-04-18) — *a "time verified by
GPS" click-button / checkbox on the job*. That is the client's own register recording the same
sentence from the same email on the same date; it is **corroboration of the ask, not an answer to
it**, and the review log's own status caution applies. For what the legacy system already carries
in this area — per-unit GPS latitude, longitude, date and a `GPS` provenance value on telemetry
rows — see [fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md) §3. That is context; it
still does not say which time Melissa means.

---

## 4. One open ask carried from the sheet's margin

*"Who the tractors are assigned to — side note for dispatch. Can we add where we can
assign crew members to a unit but to where it can easily be changed? Let's ask Lisette
this would be helpful. I could see an error happening if the normally assigned crew
members aren't going."*

A default crew per unit, overridable per job. Raised on the source document itself and
never answered.

The live workbook shows this being maintained **by hand, per load, per day**: a tractor code
(`AT13`, `AT18`) or a rental number typed into the `TRCTR` cell of each counterweight row
([dispatch-sheet-workbook.md](dispatch-sheet-workbook.md) §4). That is evidence the binding is real
and is worked with daily — it is **not** an answer to Melissa's question, which asks for a default
that can be changed easily. Nothing has answered it.

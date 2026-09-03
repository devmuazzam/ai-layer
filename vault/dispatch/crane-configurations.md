---
title: Crane configurations and the dispatch sheet
source: shared-folder/3.3.1_MODULE-DISPATCH-JOBS
migrated: 2026-08-29
updated: 2026-04-18
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

---

## 4. One open ask carried from the sheet's margin

*"Who the tractors are assigned to — side note for dispatch. Can we add where we can
assign crew members to a unit but to where it can easily be changed? Let's ask Lisette
this would be helpful. I could see an error happening if the normally assigned crew
members aren't going."*

A default crew per unit, overridable per job. Raised on the source document itself and
never answered.

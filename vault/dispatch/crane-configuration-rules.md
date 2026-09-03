---
title: Crane configuration — the rules, and where each one comes from
source: user-supplied/ASSETS_DISPATCH_(Lisette-approved).xlsx + meeting transcripts 2026-04-14, 2026-05-19, 2026-05-21
migrated: 2026-09-03
updated: 2026-09-03
status: reference
conflicts_with: []
jira: []
tags: [module/dispatch, module/assets, module/quotations, kind/reference, crane-configuration, counterweight, association, job-ticket]
entities: [asset, unit, sub-category, SubCategoryAssociatedResource, job-ticket, trailer, tractor, employee-type]
---

# Crane configuration — the rules, and where each one comes from

[crane-configurations.md](crane-configurations.md) says **what a crane configuration is**, read
off the approved workbook and the annotated dispatch PDFs. This file says **what the rules are**,
because three meetings settled most of them and the earlier read never reached those transcripts.

Sources, in the order they matter:

| Source | What it is |
| --- | --- |
| `ASSETS_DISPATCH_(Lisette-approved).xlsx`, sheet `ASSETS_DISPATCH_May21` | The approved workbook. Left block = the fleet, one row per unit. Right block (`R:AD`) = **one dispatch example per sub-category**, plus who drives each asset and how tickets are issued. 17 crane groups, 22 T → 550 T. |
| [meetings/transcripts/2026-04-14-dispatch-warehouse-loading.md](../meetings/transcripts/2026-04-14-dispatch-warehouse-loading.md) | The densest source on counterweight loads — how many, who decides, what is billable. |
| [meetings/transcripts/2026-05-19-crane-configurations-job-tickets.md](../meetings/transcripts/2026-05-19-crane-configurations-job-tickets.md) | Walkthrough of the workbook's `from_May19` sheet. Crew roles and ticketing. |
| [meetings/transcripts/2026-05-21-crane-configurations-job-tickets.md](../meetings/transcripts/2026-05-21-crane-configurations-job-tickets.md) | Walkthrough of the `May21` sheet, where columns `X:AD` (who drives / ticketing) were added. Boom dolly and holdover. |

**Reading the citations.** `[STATED]` means a named human said it in one of those sources and the
quote is given. `[DERIVED]` means it follows from the workbook's own structure across all 17 groups
with nothing contradicting it — it is not a quote, and a human has not confirmed the generalisation.
Nothing here is `[STATED]` on the strength of a transcript line whose speaker label is doubtful:
the 2026-05-19 file mislabels several speakers (the `Brian Petros` label carries other people's
answers), so quotes from it are attributed by name only where the labelling is coherent, and
otherwise cited as "the TCG side".

---

## 1. Shape of a configuration

**1.1 A crane goes out as N vehicle groups.** Group 1 is the crane plus its operator-load trailer
plus a tractor. Each further load is a trailer plus a tractor. `[STATED]` — 2026-05-19 @ 17:19:
*"if you go to the 90 ton… you see that the crane comes, it's the crane and then the operator load
and then the tractor. So it's three assets and then it will need the two employees to go with it."*

**1.2 Every trailer always has a tractor.** `[STATED]` — **Melissa McNutt**, 2026-04-14 @ 29:04:
*"So they always have tracks. So both in each every trailer will always have a tractor."*

**1.3 The tractor belongs to the trailer, not to the crane.** One trailer carries one specific
counterweight and is hauled by one tractor. `[STATED]` — 2026-04-14 @ 15:19: *"It's one trailer with
that specific count. It's load one, support load one, support load two, and then it's that one
trailer, and then it will go with the tractor."*

**1.4 A load slot is a real asset, not a line on the crane.** Each trailer has its own unit code,
VIN, trailer number and plate, is permanently loaded with its counterweight, and never migrates to
another crane. `[STATED]` — 2026-05-19 @ 28:14: *"No, that's permanent. That always is always going
to be the same"*; @ 31:15: *"bin numbers, trailer numbers, plate numbers, everything"*; @ 28:56:
*"that specific like 1901.2, that's not going to go to another crane. That's only for that specific
crane."* And 2026-04-14 @ 16:28: *"Each counterweight, each trailer, that's the way it's supposed to
go. It doesn't change. Those are always going to stay that way. We don't change them."*

**1.5 Boom dolly — in no version of the workbook.** Cranes **140 T and up** all have one; it is one
specific dolly per crane; it is a trailer with its own VIN and unit number; it travels attached to
the crane and is detached on site; it is **not billed separately**; and it must be modelled as a
sub-category that **does not enter the daily allocation system**. `[STATED]` — **Wes Staley**,
2026-05-21 @ 1:21:14 *"So, 140 tons and up… currently, for us, all have dollies"*, @ 1:21:29
*"singular dolly to singular crane. Everyone has a specific setup for that crane. Just like we have
a specific operator load for the crane, a specific dolly for the crane"*, @ 1:21:05 *"Is it billed
separately? No, it is not billed separately. It is 1 unit with the crane."* The modelling half is
Brian Petros @ 1:24:32: *"the boom dolly would be a different type of subcategory that wouldn't
trigger the da[ily] allocation system. But in the system itself, it's got to be a separate like
record because it's got its own unique identification"* — with **Lisette Anzaldo** agreeing @
1:24:51: *"I wouldn't have to see that on my assets section… because it's always going to be with
the crane."*

---

## 2. Cardinality and ordering

**2.1 One trailer : one tractor : one driver.** Never a quantity. Reinforced by
[2026-08-31-quotation-qty-not-das-sets.md](../decisions/2026-08-31-quotation-qty-not-das-sets.md) —
quantity is a billing scalar and must not explode into sets — so three support loads are **three
distinct sub-categories**, not `qty = 3` on one. `[DERIVED]` from 1.2/1.3 plus that decision.

**2.2 Loads are ordered, and a job takes a prefix of them.** Operator load first, then `.1`, `.2`,
`.3`. Reductions come off the tail. `[STATED]` — 2026-04-14 @ 16:28: *"there might be a chance that
they might say, don't take the last load or don't take the last two. They just need the first
ones"*; @ 17:12: *"if they don't need all the trailers, they will specify 190 operator load, which is
the very first one, plus one more."* Consequence to enforce: **load N cannot be selected without
loads 1…N−1.**

**2.3 Default at 190 T and above is the full configuration.** `[STATED]` — 2026-04-14 @ 17:12:
*"the 190 and bigger cranes, their schedule… it's a full crane, unless it's specified by the sales
rep that they don't need all the trailers"*; @ 17:55: *"for the most part, those big cranes always
go with all the counterweight and that really doesn't happen."*

**2.4 One driver per tractor, plus a rigger in the passenger seat when a rigger was sold.** That is
the only second person. `[STATED]` — 2026-05-19 @ 31:58 *"For the tractor, it's only one person"*;
@ 32:07: *"There can be a case… if a rigger was sold with the job. So now we need three people on
the job, then so that he doesn't have to take another vehicle. The tractor does have a passenger
seat so he can ride with him."*

**2.5 Trailer count worked through.** A 265 T sent "all the way to .3" is **four trailers and four
tractors and four drivers** — the second `26502` row is the operator load, itself a truck-and-trailer.
`[STATED]` — 2026-04-14 @ 27:20.

---

## 3. Crew

**3.1 At 90 T and above (and on the RT), the oiler drives the crane and the operator drives the
operator-load tractor-and-trailer.** `[STATED]` — 2026-05-19 @ 21:47: *"The oiler drives the crane
and then the operator will take the operator load and the tractor because you attach that operator
load to the tractor."* This matches the workbook's `Who Drives Asset to/from Job Site` column
exactly (`Oiler` on the crane row, `Operator` on the OL row).

**3.2 Below 90 T — 22 T boom truck, 30 T self loader, 40 T, 45 T, 60 T — the operator goes alone.**
No trailer, no tractor, one ticket. `[DERIVED]` from the workbook: all five groups show `Operator`
on the crane row and carry no trailer or tractor rows at all.

**3.3 Oiler and operator are one inseparable pair.** `[STATED]` — **Lisette Anzaldo**, 2026-05-21
@ 9:28: *"when there's oiler and operator, they're always going to be together. They can never work
one without the other for that specific asset. And their times are always going to be the same"*;
@ 10:06 on breaks: *"the other one wouldn't be able to take the break if the other one is not. They
have to, they work as a team"*; @ 11:36: *"they're always going to start together… those two
machines, oiler and operator, have to be together."* Enforce as a **pair**, not as two independent
required rows. See also
[2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md](../decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md).

**3.4 Each additional load carries exactly one driver, typed *third man* or rigger.** `[STATED]` —
2026-05-19 @ 22:19: *"after the operator and any additional load after that, which as you start
getting to bigger cranes, the additional loads are called third man and it's a driver"*; and the
workbook types every `Load N` / `Support Load N` row as *"3rd man or rigger"*.

**3.5 Emergency and add-on jobs must be operator + oiler.** `[STATED]` — printed across the middle
of the dispatch sheet master, via [crane-configurations.md](crane-configurations.md) §2.

---

## 4. Ticketing and labor

**4.1 One ticket per vehicle group; group 1 is a single ticket held by the oiler.** Every additional
load driver gets their own. `[STATED]` — **Corrina Bustos**, 2026-05-19 @ 35:56: *"the only one that
gets sent together is the operator and oiler, and then everyone else gets their own separate. So
third man support loads, they all get their own that they have to do, but the only ones that are
together are the operator and oiler."* Ticket count: 2026-05-19 @ 25:39 — *"if there's five people,
there's going to be like 4 tickets… because the first two are combined."*

**4.2 The oiler fills the ticket and enters the operator's hours, but labor is a separate entry per
person.** One time card per job ticket, one line per employee. `[STATED]` — **Corrina Bustos**,
2026-05-19 @ 34:03: *"they have to record their own labor hours, but they have the same time card
with their names. So they have one time card for the job ticket, but they each have their own line
for the individual person on that time card"*; **Lisette Anzaldo**, 2026-05-21 @ 9:28: *"just for
payroll purposes so that they can be separate and there's record of each individual timesheet."*
This is precisely what the workbook encodes as `Fills In/Completes Ticket` **blank** and `Has
Separate Labor Hours` **✅** on the operator-load row.

**4.3 The oiler does the DOT pre/post-trip for the crane, the assigned tractor and the assigned
trailer; every other driver does their own.** Checklists differ by asset type — one for the mobile
crane, one covering tractor-and-trailer. `[STATED]` — **Melissa McNutt**, 2026-05-19 @ 41:06 and
@ 42:09: *"the oiler does the paperwork for the operator, their time ticket. That's why everything's
sent together. They do the pre and post trip for their crane, their assigned truck, and their
assigned trailer. Anybody else that goes to the job site, besides those two crew members, they do
their own individual labor and their inspections."*

**4.4 Additional-load tickets should not be customer-signable.** A **recommendation on the record,
not a decision** — nothing has ratified it. **Melissa McNutt**, 2026-05-19 @ 42:09: *"Since the
oiler is the only one responsible for getting the customer signature, we should make it where those
additional trucks do not have a job ticket to get signed by the customer."*

**4.5 A rigger riding with a driver may share that driver's ticket, provided labor hours stay per
person.** `[STATED]` — **Corrina Bustos**, 2026-05-19 @ 33:14: *"it's okay to have them on the same
ticket as long as their labor hours are recorded separately… each under their own individual name."*

---

## 5. Required vs optional — what `isRequired` actually means

**5.1 The operator load is required whenever the crane goes out, from 9001 up.** `[STATED]` —
workbook annotation: *"this load is require to go out anytime the crane goes out — all the cranes
from 9001 and on require this."*

**5.2 The 45 T is not a "sometimes" exception to be modelled as ambiguity.** The workbook's
*"4005 and 4006 sometimes require this in different configurations"* was resolved in the 2026-04-14
meeting into **discrete named load options**: `3300`, `7300`, `full` — four counting empty — which
sales picks from a dropdown. `[STATED]` — 2026-04-14 @ 4:21: *"I would like it to be 3,300, 7,300
and full. And then a side note of whether or not it's going through scales or not. So it should be
4"*; @ 12:26: *"if we have that option for support load for 3300, 7300, and then the full counter
weight, then the sales rep can drop down that item and then we'll know that's exactly what he
needs."* The same treatment was **asked for on the big cranes** — @ 14:24: *"If we did something to
these larger ones, just like we're going to do for the 45… I think that would be great because a lot
of these are being used with less counterweight but then there's still charging for that crane size
specifically."* The workbook's trailer `Capacity` column is that number, half-entered: 190 T reads
44000 / 88000 / 119000, ascending; the 350 T, 360 T and 550 T groups have the column blank.

**5.3 Pulling counterweight off a crane always creates a separate truck.** `[STATED]` — 2026-04-14
@ 5:04: *"as soon as you pull a counterweight, it's a separate truck regardless"*; @ 5:08: *"7300 is
that sweet spot… 7300, no scales, doesn't need a truck. 7300 scales goes on the truck."*

**5.4 Sales picks the configuration at quotation time; dispatch then decides how to haul it.**
`[STATED]` — 2026-04-14 @ 5:45: *"the sales guys put on their jobs, they'll put the counterweight
that they need. And then based on the cities, then that's when I determine whether we're going to go
through scales or not"*; @ 6:07: *"the sales guy just puts in how much counterweight he needs, and
then me and Lisette talk about… how much counterweight we're going to haul."*

**5.5 An association is a default template, always overridable — never a hard constraint.**
`[STATED]` — 2026-05-19 @ 27:12: *"the quotations will be based on these current configurations as
well… It'll just be like a starting point, and then they can modify it to something different"*;
2026-05-21 @ 1:02:50: *"The purpose of having these examples here is just sort of to give us a
starting point… but then there's gonna be a lot of different variations to this."*

---

## 6. Instance binding — the distinction the current model does not carry

**6.1 The operator-load trailer *and its tractor* are permanently bound to that specific crane.
Support-load trailers are bound to the crane too, but their tractors come from an interchangeable
pool.** `[STATED]` — **Melissa McNutt**, 2026-04-14 @ 29:04: *"The operator load is assigned to that
specific tractor. So like say tractor one always goes with trailer one, but trailer two, three and
four may go with tractor 7, 10, one, three. Like so the trucks and trailers aren't assigned together
except for that first load. So the first load with every crane is assigned to that crane and that
crew."* And @ 28:45, on who hauls the numbered loads: *"No, they're the third man, so they're
random."*

So there are **two different bindings** in play — a type-level association (this sub-category drags
along these kinds) and an instance-level default (this crane's own OL trailer, its tractor, its
crew). `SubCategoryAssociatedResource` expresses only the first. The instance-level half overlaps
the still-open *Default crew per unit, overridable per job* question in [gaps.md](gaps.md).

**6.2 Tractor substitution is not free.** `[STATED]` — **Melissa McNutt**, 2026-04-14 @ 19:35:
*"sometimes if a tractor's down, Lisette will get a call to switch out tractors. So with the
trailer, some of them are different weights. So with different trailer configurations, the 5th wheel
axle and the tractor needs to be adjusted so we make the scale weight."*

---

## 7. Billing

**7.1 Every additional load is billable** — an extra vehicle and an extra driver. `[STATED]` —
2026-04-14 @ 12:02: *"If it needs an additional load, yes, we do bill for it"*; @ 15:53: *"for sure
it's going to be an additional cost because there's an additional cost for an employee who's
operating it and driving a separate vehicle."*

**7.2 The boom dolly is not billable separately** — see 1.5.

**7.3 The three load kinds already exist as billing codes**: `OPL` Operator Load, `CWT` Counter
Weight Truck, `SUPP` Support Load — `apps/api/src/utility/seed-data.ts:76,86,99`. *"Support load"*
and *"counterweight"* are the same thing in TCG's speech: 2026-04-14 @ 16:28, asked whether they are
interchangeable — *"They are."*

---

## 8. Where each rule can be enforced today

`SubCategoryAssociatedResource` (`apps/api/prisma/schema.prisma:630`) carries
`parentSubCategoryId`, exactly one of three associated-\* FKs, and `isRequired`. Nothing else.

**Enforceable against the model as it stands:** the three child kinds (1.1); no duplicate rows in
one parent's list (`SCRUM-959`); self-association and cross-tenant already rejected
(`sub-categories.service.ts:334-345`); multi-hop association cycles rejected **server-side** —
today the guard lives only in the web `mergeChildTree`, per
[2026-08-31-quotation-associated-child-merge-semantics.md](../decisions/2026-08-31-quotation-associated-child-merge-semantics.md);
oiler + operator as a required **pair** (3.3); one distinct sub-category per load slot rather than a
quantity (2.1).

**Not representable without a schema change:**

| Rule | What is missing |
| --- | --- |
| 1.2 / 1.3 — a tractor per trailer | The tractor is a flat sibling of the crane, and the unique constraint permits exactly **one** tractor row per parent. A 265 T needing four tractors cannot be expressed. |
| 2.2 — prefix ordering | No sequence on an association row. |
| 5.2 — counterweight per slot | No weight field; the workbook's `Capacity` column has nowhere to land. |
| 1.5 — boom dolly | No *travels-with / not-allocated / not-billed* flag. |
| 4.1 / 4.2 — ticket grouping | No ticket-group key, and no `fillsTicket` / `hasSeparateLaborHours` booleans, though the workbook carries both columns. |
| 6.1 — instance-level default | No per-unit default binding for trailer, tractor and crew. |

---

## 9. Two traps in the workbook itself

- **`Capacity` changes unit mid-column** — tons on crane rows (`265`), pounds on trailer rows
  (`44000`, `163100`). Never compare the two in one field. The trailer figures ascend within a
  group, consistent with a cumulative counterweight total, but nothing in the sheet or the
  transcripts labels them, so do not treat "cumulative" as established.
- **Row 88 of `ASSETS_DISPATCH_May21` is wrong at source** — the 200 T `20001` example is labelled
  sub-category *"190 Ton All Terrain Crane"*. Do not seed from it verbatim.
- The `from_May19` sheet carried a `Rigger | Identification of Vehicle` row on the 190 T that the
  approved `May21` sheet **dropped**. Treat it as withdrawn, not as a requirement.

---

## 10. Still open — do not infer

- **Holdover configurations.** The largest hole. A crane on a multi-day job leaves the yard on day 1
  with crane + trailer + tractor, breaks down the counterweight on site, and *"they bring back the
  tractor and sometimes the trailer comes back or sometimes it stays"*; the crew then reports in
  personal vehicles until the last day, when the tractor and trailer must go back out
  (**Lisette Anzaldo**, 2026-05-21 @ 59:11). Both sides agreed this needs its **own configuration
  variants** — @ 1:01:48: *"there would be a different crane configuration for a holdover job where
  they started on site and they ended on site, and then another one for they started on site and
  then they came back."* Lisette undertook to add those scenarios to the sheet (@ 1:04:16). **The
  approved May21 workbook contains none of them**, so there is no rule for what stays and what
  returns. Owner: Lisette Anzaldo.
- Whether 5.2's weight options are retrofitted to the 190 T-and-up groups. Requested on the record,
  never decided.
- Operator Load's **5 h minimum / 8 h maximum** from the rate card, which `BillingCode` has no field
  for — see [../quotations/gaps.md](../quotations/gaps.md).
- *Default crew per unit, overridable per job* — [gaps.md](gaps.md), and 6.1 above.
- GPS-verified time — [gaps.md](gaps.md).
- **Job type as a dimension** of an associated-resource set — [../assets/gaps.md](../assets/gaps.md).
  FCC keys this same configuration by `(job type, yard)` and the seeder dropped that key. Freezing
  one configuration per sub-category now bakes in a merge that may have to be undone.
- Whether 4.4 (no customer signature on additional-load tickets) is adopted.

---
title: FCC estimate templates — Resource Type × Job Type × Yard
source: teams-messages/client — 2026-09-03, Brian Petros to ehtesham.anwar (CodingCops); three same-day messages — the 9-screenshot walkthrough, the parent/child follow-up, and the FCC table map (3 screenshots)
migrated: 2026-09-03
updated: 2026-09-03
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/assets, kind/source, fcc, mob-demob, pricing, requirements, migration]
entities: [quotation, estimate, billing-code, unit-type, sub-category, yard, mob-demob]
---

# FCC estimate templates — Resource Type × Job Type × Yard

**What this is.** A Teams message from **Brian Petros** of **2026-09-03**, sent to
ehtesham.anwar after that day's meeting in which **Joe** raised that quotation estimates are per
crane *and* differ per **Job Type**. The message shows where those defaults live in FCC (NexGen
FMS), walks the **100 Ton Hydraulic Truck Crane** through both of its job types, and states that
a full export of every estimate configuration in FCC is being prepared and will follow.

> Sender confirmed 2026-09-03 (attribution was pending in this file's first revision). *Joe* is
> Joe Schacatano (sales & quotation owner in this module's register).

> **Forward-looking, not adjudicated.** This is a description of the legacy system plus an
> implicit ask; nothing in it has been decided for the ERP. The open question it raises is
> [gaps.md → Estimate defaults per resource type × job type](gaps.md#estimate-defaults-per-resource-type--job-type--yard--fcc-has-them-tcg-has-no-job-type-at-all).

## 1. Where it lives in FCC

`Main menu → Maintain → Resources → Resource Types`
([screenshot](assets/2026-09-03_fcc-resource-types-02-menu-path.png)). The sibling entries under
*Resources* are Units, Components & Tools, Ad-hoc Checklists, Customer Owned Units, Resource
Types, Schedule Types, Down Reasons.

The screen has four tabs and a master/detail shape — pick a row on **Main**, and the other three
tabs re-scope to it ([screenshot](assets/2026-09-03_fcc-resource-types-03-main-tab.png)):

| Tab | Holds |
| --- | --- |
| **Main** | the resource-type list — `Description`, `Additional Info`, `Target Hours/Month`, `Schedule Type`, `Category`, `Status`. Rows sampled: 75/90/100 Ton Hydraulic Truck Crane, 90 Ton RT, 110 Ton All Terrain Crane, 130 Ton RT — all `Target Hours/Month` 160, `Category` **Unit** |
| **Job Type/Yard** | the **job types this resource type is configured for**, each with a Yard and Comments |
| **Unit/People** | what the resource type drags along — one row per `Unit/People` + `Type` |
| **Estimate** | the **default estimate lines** — `Billing Code`, `Quantity`, `Unit of Measure`, `Comments`, `Sub-Item` |

**The load-bearing structure:** *Unit/People* and *Estimate* are **not properties of the resource
type**. They are properties of the **(resource type, job type, yard)** triple — both tabs carry
the selected `Job Type` and `Yard` in their header, and both re-populate when a different Job
Type/Yard row is selected. One crane therefore owns as many estimate templates as it has job
types.

`Description` = *100 Ton Hydraulic Truck Crane*, `Yard` = **All Yards** on every row sampled —
so the yard slot is a real dimension and "All Yards" is its wildcard. Yard-specific templates do
exist but are rare: the FCC test extract holds **4** `FMS_UNITTYPE_YARDS` rows against 69
job-type/yard configurations (§6).

## 2. The 100 Ton Hydraulic Truck Crane, both job types

Its **Job Type/Yard** tab has exactly two rows
([Hourly selected](assets/2026-09-03_fcc-resource-types-04-job-type-yard-hourly.png) ·
[Hourly w/ Mob selected](assets/2026-09-03_fcc-resource-types-07-job-type-yard-hourly-w-mob.png)):

| Job Type | Yard | Comments |
| --- | --- | --- |
| `Hourly w/ Mob` | All Yards | — |
| `Hourly` | All Yards | — |

*Mob = mobilization; `Hourly` is the no-mobilization variant.*

### Unit/People — identical across both job types

Both [Hourly](assets/2026-09-03_fcc-resource-types-05-unit-people-hourly.png) and
[Hourly w/ Mob](assets/2026-09-03_fcc-resource-types-08-unit-people-hourly-w-mob.png) show:

| Unit/People | Type |
| --- | --- |
| Tractor | Tractor - Semi |
| Trailer | Operator Load |

The message's own framing is *"potentially different Unit/People configuration"* — for this
crane they happen to match. Do not read that as a rule.

### Estimate — `Hourly`

[Screenshot](assets/2026-09-03_fcc-resource-types-06-estimate-hourly.png). Four lines, **no
`Sub-Item` ticked**, so all four print on the customer's estimate:

| Billing Code | Qty | UoM | Comments | Sub-Item |
| --- | --- | --- | --- | --- |
| 100 Ton Crane | 4.00 | Hours | | ☐ |
| Operator Load | 1.00 | Each | | ☐ |
| Travel Permit - 75 Ton and abo… | 1.00 | Each | *"Subject to change pending …"* (truncated) | ☐ |
| Fuel & Insurance Surcharge | 1.00 | Each | | ☐ |

The **4.00 default hours** is the four-hour minimum, priced here as a default quantity rather
than a rule — cross-check [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) minimums.

### Estimate — `Hourly w/ Mob`

[Screenshot](assets/2026-09-03_fcc-resource-types-09-estimate-hourly-w-mob.png). **Twenty** lines
in this order — two ticked blocks, each closed by an unticked roll-up row:

| # | Billing Code | Qty | UoM | Comments | Sub-Item |
| --- | --- | --- | --- | --- | --- |
| 1 | 100 Ton Crane | 0.00 | Hours | Travel in and Build up | ☑ |
| 2 | Operator Load | 0.00 | Each | Operator Load | ☑ |
| 3 | Travel Permit - 75 Ton and abo… | 0.00 | Each | Travel Permit | ☑ |
| 4 | Crew Time | 0.00 | Hours | Curfew Stand By Time | ☑ |
| 5 | Price Adjustment | 0.00 | Each | Price Adjustment | ☑ |
| 6 | Crew Overtime | 0.00 | Hours | Overtime Rate | ☑ |
| 7 | Crew Double Time | 0.00 | Hours | Double Time Rate | ☑ |
| 8 | Crew Time | 0.00 | Hours | | ☑ |
| **9** | **Mobilization** | **1.00** | **Each** | | **☐** |
| 10 | 100 Ton Crane | 0.00 | Hours | 4 Hour Minimum Portal to Portal | ☑ |
| 11 | Operator Load | 0.00 | Each | Operator Load | ☑ |
| 12 | Travel Permit - 75 Ton and abo… | 0.00 | Each | Travel Permit | ☑ |
| 13 | Crew Time | 0.00 | Hours | Curfew Stand by Time | ☑ |
| 14 | Price Adjustment | 0.00 | Each | Price Adjustments | ☑ |
| 15 | Crew Overtime | 0.00 | Hours | Overtime Rate | ☑ |
| 16 | Crew Double Time | 0.00 | Hours | Double Time Rate | ☑ |
| 17 | Crew Time | 0.00 | Hours | | ☑ |
| **18** | **De-Mobilization** | **1.00** | **Each** | | **☐** |
| 19 | 100 Ton Crane | 0.00 | Hours | | ☐ |
| 20 | Fuel & Insurance Surcharge | 1.00 | Each | | ☐ |

So the customer sees four lines here too — **Mobilization**, **De-Mobilization**, the crane's
own hours (19) and the surcharge (20) — and the sixteen ticked lines are the internal build-up
behind the two bundles.

## 3. What `Sub-Item` means

The message states it directly: *"the 'Sub-Item' boxes that are checked means that those line
items do not show on the estimate for the customer"*, and, of the `Hourly` template, *"all
'Sub-Item' are not checked… so all of these display on the estimate."*

**Two mechanisms, not one — corrected by Brian's same-day follow-up.** The grid shows the flag
and nothing else, and Brian reads it the same way: *"the user screen in FCC doesn't display the
'line item' and 'sub-item' relationship very well… I can't tell which child belongs to which
parent."* But *"in the database this appears to me more clear, with parent/child
relationship."*

So **FCC stores an explicit parent link, and `Sub-Item` is a separate per-line visibility
flag** — `FMS_UNIT_TYPE_ESTIMATE.ParentEstimateID` and `.Item` respectively, named in his table
map the same day (§5). Reading membership off row order — a ticked run belonging to the unticked roll-up that
closes it — is a **UI artifact of this screen, not the model**. It is how the tables above were
transcribed and it is almost certainly right for this crane, but it is an inference: do not
carry row order into a spec, and treat the grouping in §2 as provisional until the extract
lands. What the two blocks *are* is not in doubt; which row is whose child is, on the screen
alone.

That leaves the real divergence from TCG sharper, not softer (§4): FCC has **both** a stored
parent and an independent visibility flag; TCG has only the parent and derives visibility from
it.

Three details worth carrying:

- **The bundle is a mini-estimate, not just travel and setup.** Alongside crane hours, operator
  load and the travel permit sit **Crew Time (curfew standby)**, **Price Adjustment**, **Crew
  Overtime** and **Crew Double Time** — premium and adjustment placeholders, pre-seeded at 0.00
  so the estimator fills in what applies.
- **The mob and demob blocks are near-mirrors** (8 lines each) and differ only in the comment on
  the crane line: *Travel in and Build up* vs *4 Hour Minimum Portal to Portal*.
- **Quantities are the template's own defaults** — 0.00 on every sub-item, 1.00 Each on the
  roll-ups and the surcharge, 4.00 Hours on the `Hourly` crane line. Rates are not on this
  screen; they come from the price list.

## 4. Against what TCG has built — verified

| FCC concept | TCG today | Verdict |
| --- | --- | --- |
| Resource type (`100 Ton Hydraulic Truck Crane`) = `FMS_UNIT_TYPES` | `SubCategory` — that is where the seeder puts all 68 rows (`fcc-seeder/docs/seed-files-index.md:20`). A separate `UnitType` model exists (`schema.prisma:1006`) but has no product surface: `/asset-management/unit-types` renders "This module is under development" | ✅ exists, under a different name — see [assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md) and the naming ask in §5 |
| *Unit/People* rows | `SubCategoryAssociatedResource` (`schema.prisma:630`) — asset sub-category / employee type / custom type, with `isRequired` | ✅ close equivalent, **but keyed only by parent sub-category — no job type** |
| *Estimate* default lines | **nothing** | 🆕 **no such model.** `Template`/`CustomSection`/`CustomField` (`schema.prisma:695`) is the custom-**field** designer for categories, not a line template |
| `Job Type` (`Hourly`, `Hourly w/ Mob`) | **nothing.** `Quotation.billingType` is the closest name and is unrelated — a hardcoded two-value select, `Rental` / `Parts` (`apps/web/src/features/quotations/components/molecules/other-info-section.tsx:60`), display-only on the detail and print views | 🆕 **the dimension does not exist**, anywhere in schema, shared types or web |
| `Yard` on the template key | `Quotation.yard` is a free `VarChar(100)` on the quote; nothing keys defaults by it | 🆕 |
| Parent/child on estimate lines — **stored in the FCC DB**, not shown on the screen | `QuotationResource.parentId` + `isGroup` (`schema.prisma:1840`) | ✅ equivalent exists |
| `Sub-Item` (hidden from customer) — an **independent per-line flag** beside that parent link | **no counterpart.** The PDF hides **every child of a group parent** (`apps/api/src/usecase/docusign/quotation-pdf.service.ts:562-566`); `isIncluded` controls only whether a child counts toward the parent total, never whether it prints | ⚠️ **same outcome by a different mechanism** — TCG derives visibility from parenthood, FCC stores it per line. A line that is a child *and* visible to the customer is expressible in FCC, not in TCG |
| Mob/demob roll-up rows | `isGroup` parents summing checked children (`apps/api/src/usecase/quotations/quotation-resource-totals.ts:4`) | ✅ agrees with [mobilization-and-demobilization.md](mobilization-and-demobilization.md) FR-1/FR-2/FR-6 |
| The template *itself* — defaults arriving on a new quote | **nothing.** Adding a resource to a quotation pulls no associated resources and no default lines; grouping is generic and hand-built per quote (no `Mobilization` preset anywhere in `apps/web/src/features/quotations`) | 🆕 **this is the gap** |

**It sharpens one existing vault claim.** `mobilization-and-demobilization.md` **FR-8** says the
bundling pattern is *"a special case — no other billing categories currently require this
pattern."* The templates agree in effect (only the mob/demob job type uses sub-items) but show
*why*: sub-item is a **generic per-line flag on every estimate template**, and the `Hourly`
template simply ticks none of them. Build the flag as general; the special case is the data.

**It does not contradict anything in the vault.** It adds the layer above mob/demob that no
document covered: mob/demob is not a thing an estimator assembles per quote in FCC — it is a
**job type on the crane** whose template already contains it.

## 5. The FCC tables behind the screen

Brian's third message of the day — *"here are the related tables with relationships in FCC"* —
supplies the schema, which retires most of the guessing above.
[Table map](assets/2026-09-03_fcc-resource-types-10-table-map.png) ·
[relationship tree](assets/2026-09-03_fcc-resource-types-12-relationship-tree.png).

| Screen area | FCC table(s) | Relationship |
| --- | --- | --- |
| **Main** | `FMS_UNIT_TYPES` | one Resource Type |
| Schedule Type | `FMS_SCHEDULE_TYPES` | `FMS_UNIT_TYPES.UnitSchedType` |
| **Job Type/Yard** | `FMS_UNIT_TYPE_JOBTYPE_YARD` | configuration underneath the Resource Type; its `JobTypeYardID` is **the key everything else hangs from** |
| Job Type | `FMS_UNITTYPE_JOBTYPES` + `FMS_JOB_TYPES` | child of `JobTypeYardID` |
| Yard | `FMS_UNITTYPE_YARDS` + `FMS_YARD_MASTER` | child of `JobTypeYardID`; **no row = apparently All Yards** |
| **Unit/People** — unit / equipment | `FMS_UNIT_TYPE_EQUIPMENT` | child of `JobTypeYardID` |
| ↳ *Unit/People* column | `FMS_SCHEDULE_TYPES` | via `FMS_UNIT_TYPE_EQUIPMENT.UnitSchedCode` |
| ↳ *Type* column | `FMS_UNIT_TYPES` | via `FMS_UNIT_TYPE_EQUIPMENT.UnitTypeID` |
| **Unit/People** — employee | `FMS_UNIT_TYPE_EMPLOYEES` | child of `JobTypeYardID` |
| **Estimate** | `FMS_UNIT_TYPE_ESTIMATE` | child of `JobTypeYardID` |
| ↳ Billing Code | `FMS_BILLING_CODES` | `BillingCodeID` |
| ↳ Unit of Measure | `FMS_MEASURES` | `MeasureCode` |
| ↳ Sub-Item checkbox | `FMS_UNIT_TYPE_ESTIMATE.Item` | `1` = checked → hidden as a separate customer estimate line |
| ↳ Sub-item owner | `FMS_UNIT_TYPE_ESTIMATE.ParentEstimateID` | references the parent's `UnitTypeEstimateID` |

Four things this settles that the screenshots could not:

1. **`JobTypeYardID` is the real spine.** Job type and yard are *both* children of one
   configuration row, and *Unit/People (equipment)*, *Unit/People (employees)* and *Estimate*
   are three sibling children of that same row. The template key is not "(resource type, job
   type, yard)" as three columns — it is one configuration id that resolves to those.
2. **Yard absence is the wildcard.** *All Yards* is not a stored value; it is **no
   `FMS_UNITTYPE_YARDS` row**. Brian marks this "apparently" — treat as strong but unconfirmed.
3. **Sub-item and parenthood are two columns**, exactly as his earlier follow-up said: `Item`
   for visibility, `ParentEstimateID` for structure.
4. **The *Unit/People* grid is a (schedule type, unit type) pair** — the left column is a
   schedule type (`Tractor`, `Trailer` are schedule types `TR` and `R`), the right column a unit
   type (`Tractor - Semi`, `Operator Load`). That is the same Category → Sub-Category shape
   already recorded in [assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md),
   and it maps onto `SubCategoryAssociatedResource` — which is how TCG models it.

### Resource Types are not Units — a naming ask

The *Main* tab is **not** a list of fleet assets. Brian:

> *"Physical units such as a particular crane/unit code are elsewhere in `FMS_UNITS` and are
> associated to these Resource Types through the Unit Type configuration… So in the new ERP
> nomenclature I would explicitly call these **Resource Types**, not Units, to avoid confusing
> the template with the individual fleet asset."*

He is right about the data and it corrects his own earlier framing
([screenshot](assets/2026-09-03_fcc-resource-types-11-resource-types-not-units.png)) — but
**adopting the word is a decision, not a given**: TCG already spends "resource" on quotation and
job line items (`QuotationResource`, `JobResource`, `SubCategoryAssociatedResource`), and this
level is `SubCategory` today. Logged in [assets/gaps.md](../assets/gaps.md#nomenclature-for-the-template-level--resource-type-not-unit).

## 6. We already hold this data — and the seeder flattened it

The FCC test extract (`NexGenFMS-Test`) **already covers every table in Brian's map**, and the
seeder's own docs say what happened to them. This changes the ask: the missing thing is not
mainly the data, it is the fidelity.

| FCC table | Rows in the test extract | Where it went |
| --- | ---: | --- |
| `FMS_UNIT_TYPES` | 68 | → `SubCategory` (`fcc-seeder/docs/seed-files-index.md:20`) |
| `FMS_UNIT_TYPE_JOBTYPE_YARD` | **69** | **nowhere** — `docs/fcc-unmapped-entities.md:34` |
| `FMS_UNITTYPE_JOBTYPES` | 43 | **nowhere** — `:35` |
| `FMS_UNITTYPE_YARDS` | **4** | **nowhere** — no TCG sub-category–yard join (`seed-files-index.md:49`) |
| `FMS_UNIT_TYPE_EQUIPMENT` | 161 | → `SubCategoryAssociatedResource`, **`JobTypeYardID` and `UnitSchedCode` dropped on all 161** (`docs/field-gaps.md:589`) |
| `FMS_UNIT_TYPE_EMPLOYEES` | 117 | → `SubCategoryAssociatedResource`, **`JobTypeYardID` dropped on all 117** (`docs/field-gaps.md:610`) |
| `FMS_UNIT_TYPE_ESTIMATE` | **564** | **not inserted at all.** Seed applies `BillingCodeID` → `BillingCode.subCategoryId` so associated resources come out billable (`docs/linked-tables-mapping.md:32`, `src/lib/link-billing-codes.ts:225-241`) |

**What the estimate flattening costs, precisely.** `linked-seed-files.ts:385-400` reads each row's
`Quantity`, `MeasureCode`, `Rate`, `Amount`, `PrimaryEst` and `Status` and **does not read**
`JobTypeYardID`, `Item`, `ParentEstimateID`, `LineNumb` or `Comments`. Then `link-billing-codes.ts`
uses even the fields it kept only to *order* candidates — primary estimates first — and writes a
single `subCategoryId` onto each billing code, first-wins, skipping codes already linked and any
`EMPLOYEES`-type code. 564 template lines become at most one FK per billing code.

`docs/field-gaps.md:630-650` confirms the columns are populated upstream and therefore
recoverable from a re-extract: `Item` **564/564**, `JobTypeYardID` **564/564**, `LineNumb`
**564/564**, `ParentEstimateID` **322/564** — so **57% of estimate lines are children**, which is
what the two ticked blocks in §2 look like at fleet scale. `Comments` 201/564. It also lists
`Quantity2/3`, `Rate2/3`, `Amount2/3` populated on all 564 — **three quantity/rate/amount slots
per line, unexplained**; ask before designing anything that assumes one.

Two consequences worth stating plainly:

- **The 69 `FMS_UNIT_TYPE_JOBTYPE_YARD` rows are the evidence for how big this is.** 68 resource
  types, 69 job-type/yard configurations, 43 job-type rows, 4 yard rows — so most resource types
  carry one configuration, a minority carry more, and yard-specific templates are rare but real.
  Confirm against the full extract; the test extract is not production.
- **A migrated tenant's associated resources are already job-type-blind.** 161 equipment and 117
  employee rows were collapsed onto the parent sub-category with `JobTypeYardID` discarded. If two
  job types on one crane ever differ in *Unit/People*, that difference is gone in TCG today, and
  the rows may have merged or collided. Nobody has checked which.

## 7. Incoming — the full extract

Brian: *"Looks like I'll be able to generate the full extract for you of all these configurations
in FCC."* Not arrived as of 2026-09-03. File it under [assets/](assets/) when it lands.

**Ask for it as production rows of the six tables in §5, complete.** §6 shows the test extract
already carried them and the seeder discarded the parts that matter, so the request is narrow and
should be explicit about the columns, not the screen:

1. `FMS_UNIT_TYPE_JOBTYPE_YARD` in full, with `JobTypeYardID` — the spine, and the count that
   says how many templates exist fleet-wide;
2. `FMS_UNIT_TYPE_ESTIMATE` with **`Item`, `ParentEstimateID`, `LineNumb`, `Comments` and
   `JobTypeYardID`** — the five columns `linked-seed-files.ts` does not read today;
3. `FMS_UNITTYPE_JOBTYPES` + `FMS_JOB_TYPES` — the **full job-type list**, which is still
   unknown beyond `Hourly` and `Hourly w/ Mob`;
4. `FMS_UNITTYPE_YARDS` — the yard exceptions, to confirm that absence really means *All Yards*;
5. `FMS_UNIT_TYPE_EQUIPMENT` and `FMS_UNIT_TYPE_EMPLOYEES` with `JobTypeYardID` — to answer
   whether *Unit/People* ever differs between two job types on one resource type;
6. an explanation of **`Quantity2/3`, `Rate2/3`, `Amount2/3`**, populated on all 564 rows and
   matching nothing on the screen.

It answers, or fails to answer, sub-questions (a) (c) and (b) in
[gaps.md](gaps.md#estimate-defaults-per-resource-type--job-type--yard--fcc-has-them-tcg-has-no-job-type-at-all) —
which is the point of asking for these columns rather than a screen-shaped report.

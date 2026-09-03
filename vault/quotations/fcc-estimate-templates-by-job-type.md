---
title: FCC estimate templates — Resource Type × Job Type × Yard
source: teams-messages/client — Brian Petros to ehtesham.anwar (CodingCops); three messages 2026-09-03 (walkthrough, parent/child follow-up, FCC table map) plus the 2026-09-04 delivery of FCC_UNITS-ASSETS-ResourceTypes_20260902.xlsx (its README sheet read in full; data sheets not yet opened). Screens, diagrams and sheets transcribed here; no images kept
migrated: 2026-09-03
updated: 2026-09-04
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

`Main menu → Maintain → Resources → Resource Types`. Under *Maintain*, the groups are Resources,
Parts, Employees, Customers, E-Tickets, Sales Assistant and Codes; **Resources** opens onto Units,
Components & Tools, Ad-hoc Checklists, Customer Owned Units, **Resource Types**, Schedule Types
and Down Reasons — so the templates sit one menu away from the fleet units they are not (§5).

The screen has four tabs and a master/detail shape — pick a row on **Main**, and the other three
tabs re-scope to it. The window's own filters are `View: All` and `Status: Active`:

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
— selecting either re-scopes the *Unit/People* and *Estimate* tabs, which then carry that job
type and yard in their headers:

| Job Type | Yard | Comments |
| --- | --- | --- |
| `Hourly w/ Mob` | All Yards | — |
| `Hourly` | All Yards | — |

*Mob = mobilization; `Hourly` is the no-mobilization variant.*

### Unit/People — identical across both job types

Both job types show the same two rows (columns: `Unit/People`, `Type`, `Comments` — comments
empty on both):

| Unit/People | Type |
| --- | --- |
| Tractor | Tractor - Semi |
| Trailer | Operator Load |

The message's own framing is *"potentially different Unit/People configuration"* — for this
crane they happen to match. Do not read that as a rule.

### Estimate — `Hourly`

Four lines, **no
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

**Twenty** lines
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
He sent it as a table map and as a relationship tree; both are transcribed below.

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
(the *Main* tab rows he listed — 75 Ton Hydraulic Truck Crane, 90 Ton Hydraulic Truck Crane,
100 Ton RT, 100 Ton Hydraulic Truck Crane, …) — but
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
**564/564**, `ParentEstimateID` **322/564** — 57% of estimate lines children, against **62% in
production** (§7). `Comments` 201/564. It also lists `Quantity2/3`, `Rate2/3`, `Amount2/3`
populated on all 564 — but "populated" there means non-null, and the production README says the
neighbouring `PrimaryEst`, `Multiplier` and `MeasureCode2/3` *"are not used"*, so read these as
probably zero-filled and ask rather than alarm (§7).

Four consequences, three of them defects rather than omissions:

- **Scale, from the production README (§7):** 76 resource types, 75 configurations, 46 job-type
  mappings, 4 yard mappings, 328 equipment rows, 4 employee rows, 701 estimate lines. The test
  extract's 68/69/43/4/161/117/564 was the same shape, one release earlier.
- **A migrated tenant's associated resources are already job-type-blind.** Equipment and employee
  rows were collapsed onto the parent sub-category with `JobTypeYardID` discarded. If two job
  types on one resource type differ in *Unit/People*, that difference is gone in TCG today.
- **Schedule-type-only requirements are silently dropped.** `seed-all.ts:1433` skips any row whose
  `associatedSubCategoryFccId` is empty — and `linked-seed-files.ts:337` fills that field from
  `EquipUnitTypeID` alone. The README names the case this destroys: **Bare Rental**, *"Unit/People
  = Mobile Crane and Type is blank (UnitTypeID NULL)"*. A requirement expressed as a category with
  no type never arrives.
- **Job-type variants collide on insert.** `assocSeen` keys on `(parentSubCategoryId,
  associatedSubCategoryId)` and skips repeats (`seed-all.ts:1439`), so the same companion required
  by two job-type configurations of one resource type becomes **one row, first-wins**, taking
  whichever `isRequired` arrived first. With 328 equipment rows folding onto at most 76
  sub-categories, this is not hypothetical — but nobody has counted the collisions.

Two smaller readings, recorded so they are not re-chased:

- `isRequired` is set from **`OptFlag === 'M'`** (`linked-seed-files.ts:342`). Brian's README
  preserves `OptionFlag_Raw`, notes every current row is `M`, and says explicitly that *"its
  business meaning was not assumed in this package"*. **We assumed it.** Harmless while every row
  is `M`; unverified all the same.
- `Status_Raw = 0` on all current child rows is **not** a problem: `mapChildLinkStatus` maps a
  numeric status to `ACTIVE` (`linked-seed-files.ts:36-42`), matching the README's instruction not
  to interpret it. Checked, benign.

## 7. The extract, delivered — `FCC_UNITS-ASSETS-ResourceTypes_20260902.xlsx`

Prepared 2026-09-02, delivered 2026-09-04, in the TCG SharePoint at **Project Repository →
2.1.1_DATA-MIGRATION → NexGenFMS_for_ERP** — beside `FCC_CUSTOMERS_20260705.xlsx`,
`FCC_EMPLOYEES_20260705.xlsx`, `FCC_UNITS-ASSETS_20260706.xlsx`,
`__NexGenFMS_Inventory_20260702_0246.xlsx` and the `__VS_CODE_DataMigration` folder. Scope:
**active resource types**, production NexGen FMS.

**What is recorded here is the workbook's `README` sheet, read in full. The five data sheets have
not been opened** — the counts and behaviours below are the README's, and anything needing a row
is marked as such.

### Counts — the size of the thing

| | Rows |
| --- | ---: |
| Active resource types | **76** |
| Job Type / Yard configurations | **75** |
| Job-type mappings | 46 |
| Specific yard mappings | **4** |
| Unit/People — resource rows | 328 |
| Unit/People — employee rows | **4** |
| Estimate rows | **701** |
| — of which sub-items | 432 |
| — of which main lines | 269 |

Sheets: `01_Main` (76) · `02_JobType_Yard` (75) · `03_UnitPeople_Resources` (328) ·
`04_UnitPeople_Employees` (4) · `05_Estimate` (701).

Two proportions worth carrying: **62% of estimate lines are sub-items** (432/701), and **21 of
the 76 active resource types have no Job Type/Yard configuration at all** — so a resource type
with no template is normal, not an error state.

### What the README settles

Brian's *Confirmed FCC Behaviors*, with what each one closes:

| Confirmed | Closes |
| --- | --- |
| Resource Type = `FMS_UNIT_TYPES`, *"a configuration/template concept, not an individual physical Unit from `FMS_UNITS`"* | the naming ask in §5, from the data side |
| A resource type has **zero or more** configurations; 21 of 76 have none | the template is optional per resource type |
| Each `JobTypeYardID` has **at most one** job-type mapping and **at most one** yard mapping (current active data) | the key is effectively (resource type, job type?, yard?) after all — but by data, not by constraint |
| No `FMS_UNITTYPE_YARDS` child row ⇒ FCC displays **All Yards**; **four** configurations are specifically **Main Yard** | §5's "apparently" — now confirmed, with the exceptions counted. Sub-question (c) |
| *"No Job Type child row is retained as NULL / No Job Type Stored; **do not automatically convert it to All Job Types**"* | sub-question (h) — and it forbids the obvious wrong answer. 75 configurations, 46 job-type mappings ⇒ **29 carry no job type** |
| Unit/People resource rows use `UnitSchedCode` for the **category**, and *optionally* `UnitTypeID` for a specific resource type | §5's reading of the two columns — the right-hand *Type* column is **optional** |
| **Bare Rental** is the confirmed schedule-type-only requirement: *Unit/People = Mobile Crane, Type blank* | that a requirement can name a category with no type — see §6, our seeder drops exactly these rows |
| No current active Unit/People row uses a specific physical `EquipUnitCode` | `FMS_UNITS` is in that table's lookup list, so pinning a **physical unit** is possible in FCC and **unused** |
| Employee requirements are stored **by employee type**; all four active rows have `EmpID` NULL | the §7 inference from the anomaly sheet: `FMS_EMPLOYEES` is a lookup, so naming a **person** is possible and unused |
| `Item = 1` ⇒ sub-item, and sub-items do not appear as separate customer estimate lines | §3, restated by the client in writing |
| **`ParentEstimateID` is the authoritative** sub-item → main-line relationship | §3's correction, now the client's own word: authoritative |
| `Status_Raw` preserved and **not** interpreted as Active/Inactive; current Unit/People and Estimate rows are `Status_Raw = 0` | see §6 — our seeder reads a numeric status as ACTIVE, so this is benign; do not re-chase it |
| `OptionFlag_Raw` preserved; current Unit/People rows are **`M`**; *"its business meaning was not assumed in this package"* | **we did assume it.** `linked-seed-files.ts:342` sets `isRequired = OptFlag === 'M'` |
| *"Current active Estimate data does not use `PrimaryEst`, `Multiplier`, `MeasureCode2`, or `MeasureCode3`"* — retained for completeness | tempers §6's `Quantity2/3` alarm: those columns are populated in the test extract but carry nothing. **Ask only about `Quantity2/3` / `Rate2/3` / `Amount2/3`**, which the README does not mention |

Relationship summary, in the client's own words — matching §5 exactly:

```
ResourceTypeID  -> 0..many JobTypeYardID configurations
JobTypeYardID   -> optional Job Type mapping + optional Yard mapping
JobTypeYardID   -> 0..many Unit/People resource requirements
JobTypeYardID   -> 0..many Unit/People employee requirements
JobTypeYardID   -> 0..many Estimate lines
EstimateLineID  <- ParentEstimateID   (sub-item hierarchy)
```

Its source-table map adds two lookups §5 did not have: **`FMS_UNITS`** on the resource
requirement, and **`FMS_EMPLOYEE_TYPES` + `FMS_EMPLOYEES`** on the employee requirement.

### Still open in the data sheets

Not answered by the README; needs the rows:

1. **The job-type list** — 46 mappings, but the distinct values are in `02_JobType_Yard`. Known
   so far: `Hourly`, `Hourly w/ Mob` (code `Z`).
2. **Whether *Unit/People* ever differs between two job types on one resource type** —
   sub-question (b), the one a migrated tenant cannot answer (§6). `03_UnitPeople_Resources`
   carries `JobTypeYardID`, so it is a group-and-compare away.
3. **What `Quantity2/3`, `Rate2/3`, `Amount2/3` hold** on the 701 rows.
4. **Whether the four anomalies are the only ones** — Brian flagged them from the same data;
   sub-question (g), for Joe.

### The Main tab, more fully

The delivery message shows a longer slice of `01_Main` than §1 did — and it is not
a fleet list. In order: Service Truck, Yard Truck, **Spreader Bar**, 22 Ton Boom Truck, 30 Ton
Self Loader, 40 Ton, 45 Ton All Terrain Crane, 60 / 75 / 90 Ton Hydraulic Truck Crane, 90 Ton RT,
100 Ton Hydraulic Truck Crane, 110 Ton All Terrain Crane, 130 Ton RT, 140 Ton Hydraulic Truck
Crane, 150 Ton RT, 165 Ton Crane. `Schedule Type` varies with the row — Truck, Yard, Mobile
Crane, Self Loader, Rough Terrain Crane — `Category` is **Unit** (greyed) throughout, and
`Target Hours/Month` is 160 on most, **200** on the 30 Ton Self Loader, and **blank** on Service
Truck, Spreader Bar, 130 Ton RT, 150 Ton RT and 165 Ton Crane.

The anomaly sheet below adds two more resource types that are not machines at all — **Lift Plan**
and **Qualified Rigger and Signalman** — which is the same observation
[assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md) already makes
about schedule types: in FCC, a *resource type* is anything schedulable and billable.

### The anomaly sheet — the whole of `04_UnitPeople_Employees`

*"There is an extra sheet with these… a few anomalies that stand out, with slightly different
configurations. We can ask Joe and others if we need to continue to do anything special with
these."*

Columns: `ResourceTypeID`, `ResourceType`, `JobTypeYardID`, `JobTypeCode`, `JobType`, `YardCode`,
`Yard`, `UnitPeopleEmployeeLineID`, `LineNumber`, `EmpTypeID`, `EmployeeType`, `EmpID`,
`EmployeeName`, `EmployeeRequirementScope`.

| ResourceTypeID | ResourceType | JobTypeYardID | JobTypeCode | JobType | Yard | LineID | Line# | EmpTypeID | EmployeeType | EmpID / Name | Scope |
| ---: | --- | ---: | --- | --- | --- | ---: | ---: | ---: | --- | --- | --- |
| 63 | 110 Ton All Terrain Crane | 63 | `Z` | Hourly w/ Mob | All Yards | 50 | 3 | 1 | Operator | — | Employee Type Only |
| 63 | 110 Ton All Terrain Crane | 63 | `Z` | Hourly w/ Mob | All Yards | 51 | 4 | 2 | Oiler | — | Employee Type Only |
| 27 | Lift Plan | 17 | *(blank)* | *(blank)* | All Yards | 24 | 1 | 9 | Sales Admin | — | Employee Type Only |
| 26 | Qualified Rigger and Signalman | 19 | *(blank)* | *(blank)* | All Yards | 25 | 2 | 5 | Rigger | — | Employee Type Only |

Four things this sheet establishes, before anyone opens the workbook:

1. **A configuration can have no job type at all** — rows 3 and 4 carry a `JobTypeYardID`
   (17, 19) with `JobTypeCode` and `JobType` empty. **Confirmed by the README, which also
   forbids the tempting shortcut:** *"No Job Type child row is retained as NULL / No Job Type
   Stored; do not automatically convert it to All Job Types."* 29 of the 75 configurations are
   in this state. Both slots are nullable in the ERP model, and NULL is its own value.
2. **`JobType` has a code.** `Hourly w/ Mob` is `Z` — so job types are a coded reference list,
   and the code is not derivable from the label. The full list comes from `FMS_JOB_TYPES`.
3. **The employee requirement can name a person — and never does.** `EmpID` and `EmployeeName`
   sit beside `EmpTypeID`, and `EmployeeRequirementScope` reads *"Employee Type Only"* on all
   four rows. The README settles it: the table's lookups are `FMS_EMPLOYEE_TYPES` **and**
   `FMS_EMPLOYEES`, and *"the four current active rows have EmpID NULL"*. So pinning a specific
   employee is expressible in FCC and unused — the same shape as the physical-unit case in the
   resource table. `SubCategoryAssociatedResource` cannot express either; neither needs building
   unless someone asks for it.
4. **Line numbers are stored, and appear to span the whole Unit/People grid.** The 110 Ton's two
   employee rows are `LineNumber` **3** and **4** — not 1 and 2 — while the two single-employee
   resource types use 1 and 2. **Still an inference:** ordering may be one sequence across the
   equipment and employee children of a configuration, putting the crane's equipment at lines
   1–2. `FMS_UNIT_TYPE_EQUIPMENT.LineNumb` exists and the seeder already reads it
   (`linked-seed-files.ts:345`), so `03_UnitPeople_Resources` settles this in one look.

The anomalies themselves — a crane requiring **Operator + Oiler**, a *Lift Plan* requiring a
**Sales Admin**, a *Qualified Rigger and Signalman* requiring a **Rigger** — are product
questions for Joe Schacatano. Note the README's count: these four rows **are** the entire
`04_UnitPeople_Employees` sheet, so every employee requirement in active FCC data is one of
Brian's anomalies. Logged in
[gaps.md](gaps.md#estimate-defaults-per-resource-type--job-type--yard--fcc-has-them-tcg-has-no-job-type-at-all)
as sub-question (g).

---
title: FCC units report — schedule types, unit types, and the raw unit table
source: shared-folder/OneDrive_1_8-31-2026; extended 2026-09-04 from shared-folder/Project-Repository-2026-09-04 — 2.1.1_DATA-MIGRATION/NexGenFMS_for_ERP/{FCC_UNITS-ASSETS_20260706.xlsx, FCC_UNITS-ASSETS-ResourceTypes_20260902.xlsx, __NexGenFMS_Inventory_20260702_0246.xlsx, __VS_CODE_DataMigration/SQL_FCC_CORE_TABLES/UNITS-ASSETS/*.sql}, 1.0.2_FCC-RESOURCES-GUIDES/FCC-IMPORT-Templates/Unit Data v.6.25_TEMPLATE.xlsx, 1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_MAINTAIN_RESOURCES-UNITS-ASSETS (partially reviewed by TCG).pptx
migrated: 2026-08-31
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/assets, module/dispatch, module/quotations, kind/reference, fcc, migration, categories, sub-categories, gps, data-migration, reference-data, architecture, provenance]
entities: [asset, unit, category, sub-category, yard, department]
---

# FCC units report

> **See also (added 2026-09-03):** what FCC hangs *off* a unit type — the Job Type/Yard
> configuration and its estimate templates — is mapped table by table in
> [quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md).
> It confirms this file's reading from the other side: the FCC *Unit/People* grid pairs a
> **schedule type** with a **unit type**, i.e. Category → Sub-Category.

Client-supplied export of every unit in NexGen FMS, delivered 2026-08-31.

| Workbook | Sheets | What it holds |
| --- | --- | --- |
| `2026-05-29_FCC_UNITS_REPORT.xlsx` | `UNITS_raw`, `FMS_UNIT_TYPES`, `FMS_SCHEDULE_TYPES`, `UNITS_w_ScheduleType` | **The authoritative one.** 354 units × 156 columns, plus both lookup tables |
| `2026-05-05_FCC_UNITS_REPORT_w_slicers.xlsx` | two dated snapshots (2026-03-16, 2026-05-05) + slicer sheets | The pivot view the client described; same data, earlier |
| `FCC-NexGen SCHEMA/FCC-NexGen_TABLES_VIEWS.xlsx` | 4 sheets | **692 FCC objects** with row and column counts; 13,037 rows of column-level detail (name, data type) |

**Added 2026-09-04** from the Project Repository drop — four newer sources that supersede or
extend the three above. Sections 3–9 are entirely from them:

| Workbook / file | What it holds | Section |
| --- | --- | --- |
| `FCC_UNITS-ASSETS_20260706.xlsx` | the **2026-07-02 production export**: 358 units × 86 exported columns, plus `UNIT_TYPE_DETAILS` (565), `DEPARTMENTS` (10), `SCHEDULE_TYPES` (25), `UNIT_TYPES` (71), `UNIT_MEASURES` (4) | §3, §4, §5 |
| `__VS_CODE_DataMigration/.../FCC_UNITS-ASSETS.sql` + 5 sibling scripts | the **export contract** — which of `FMS_UNITS`' 156 columns TCG chose to carry | §3 |
| `FCC_UNITS-ASSETS-ResourceTypes_20260902.xlsx` | 76 **active** resource types as at 2026-09-02, their job-type/yard configurations, and their required resources | §6 |
| `Unit Data v.6.25_TEMPLATE.xlsx` | FCC's **unit import contract** — required/optional, max lengths, code domains | §7 |
| `__NexGenFMS_Inventory_20260702_0246.xlsx` | 444 tables with **exact row counts and a suggested migration disposition each** | §8 |

The schema workbook is the first complete FCC inventory we hold — it supersedes
guessing from `fcc-seeder/docs/fcc-unmapped-entities.md`, which was generated when
only the customers module was in scope.

---

## 1. Schedule type ≈ TCG Category, unit type ≈ TCG Sub-Category

`FMS_UNIT_TYPES` (71 rows) carries `UnitTypeID`, `Description`, **`TargetMonthHrs`**
and `UnitSchedType` — a foreign key to `FMS_SCHEDULE_TYPES`. That is the same two-level
shape as TCG's `Category → SubCategory`, and `TargetMonthHrs` maps directly onto
`SubCategory.targetHoursPerMonth`.

**All 25 schedule types** (23 active; `C` and `F` are status 0, superseded by `MC` and `FAA`):

| Code | Description | | Code | Description |
| --- | --- | --- | --- | --- |
| `MC` | Mobile Crane | | `MO` | Mobilization |
| `CR` | Crawler Crane | | `LP` | Lift Plan |
| `RT` | Rough Terrain Crane | | `FAA` | FAA Permit |
| `TC` | Tower Crane | | `SP` | Street Permit |
| `SL` | Self Loader | | `TP` | Travel Permit |
| `TR` | Tractor | | `QR` | Rigger and Signalman |
| `R` | Trailer | | `OTS` | Outside Trucking Services |
| `T` | Truck | | `MB` | Material Basket |
| `M` | Mechanics | | `RA` | Radio |
| `B` | Bare Rental | | `ST` | Storage |
| `Y` | Yard | | `O` | Misc |
| `N` | None | | ~~`C`~~, ~~`F`~~ | retired |

**The load-bearing observation:** roughly half of these are not equipment.
Lift Plan, FAA Permit, Street Permit, Travel Permit, Mobilization, Rigger and Signalman
and Outside Trucking Services are all schedule types — so in FCC a *unit* is anything
schedulable and billable, not just a machine. That is the same modelling instinct behind
[dispatch/crane-configurations.md](../dispatch/crane-configurations.md), where an operator
load and each counterweight load are units in their own right, and behind SCRUM-914's
proposal to make Operator/Oiler/Support Load sub-categories.

---

## 2. The raw unit table

`UNITS_raw` — 354 units, 156 columns. Beyond the obvious identity and dimension fields,
worth knowing about:

- **`UpperGPS`, `LowerGPS`, `UpperGPSID`, `LowerGPSID`** — FCC already carries GPS
  identifiers per unit, upper and lower separately. Directly relevant to Melissa's
  "time verified by GPS" request; see [dispatch/gaps.md](../dispatch/gaps.md).
- `Category1`, `Category2`, `Category3` — three free classification slots beyond the
  schedule/unit type pair
- `AdditionalInfo1`–`AdditionalInfo11`, `Field1`–`Field5` — 16 untyped extension columns
- `TransportClass`, `MeasureCode`, `SpersonCode`, `OwnedOrRent`
- Five GL accounts per unit: `GlAcctTm`, `GLAcctBare`, `GLAcctOper`, `GLAcctDelPickup`,
  `GLAcctPermit`
- Full depreciation and insurance blocks (`DepreciationValue`, `DepStartDate`,
  `InsureStartDate`, `ResidualInsureAmt`, …) with no TCG equivalent

---

# Added 2026-09-04 — the Project Repository drop

Everything from here down comes from the 2026-09-04 drop. Where it corrects the sections above,
it says so.

## 3. The export contract — which 78 of 156 columns TCG is carrying

Source: `__VS_CODE_DataMigration/SQL_FCC_CORE_TABLES/UNITS-ASSETS/FCC_UNITS-ASSETS.sql`.

This is not a dump. It is a script that declares all **156** `FMS_UNITS` columns in a table
variable with an `IncludeInReport` flag, validates that every included column still exists (and
`RAISERROR`s with the missing names if not), validates the four lookup tables it joins, then builds
the `SELECT` dynamically. **78 columns are flagged in, 78 are flagged out** — an even split, and a
deliberate one.

**What was excluded**, verbatim from the script, grouped:

| Group | Columns dropped |
| --- | --- |
| **Five GL accounts** | `GlAcctTm`, `GLAcctBare`, `GLAcctOper`, `GLAcctDelPickup`, `GLAcctPermit` |
| **Depreciation & insurance** | `DepreciationValue`, `DepStartDate`, `DepNextDate`, `NoOfMonths`, `ResidualValue`, `InsureStartDate`, `InsurancePeriod`, `ResidualInsureAmt`, `RedectionAmt`, `Insured` |
| **Tax** | `YtdSalesTax`, `SalesTaxLife`, `ApplySMMTax`, `AcceleratedTaxPaid`, `TerpEligible`, `HeavyMachinery` |
| **Revenue & cost** | `RevenueAsOfDate`, `Revenue`, `LaborExpenses`, `PartsExpenses`, `PercentAmount`, `SplitPercentage`, `SplitAmount` |
| **16 untyped extension slots** | `AdditionalInfo1`–`11`, `Field1`–`5` |
| **Three free classification slots** | `Category1`, `Category2`, `Category3` |
| **Forklift-specific** | `MastHeight`, `LiftHeight`, `FreeLift`, `ForkLength`, `Carriage`, `Tires`, `ExtCapacity`, `Accessories`, `Attachment`, `RentalRequirement` |
| **Identity** | **`VIN`**, `Chassis`, `ManufacturerID`, `EquipmentID`, `EquipmentIDUpper`, `SkytelID` |
| **Other** | `Gvm`, `VehicleGageFt/In`, `SpersonCode`, `WarrantyExpDate`, `TransportClass`, `HireDate`, `HoursAdjLower/Upper`, `CurrencyCode`, `FuelPerc`, `SplInvComments`, `Date1`, `Date2`, `trgFMS_UNITS` |

**Three of these deserve a second look before the migration is signed off:**

- **`VIN` and `ManufacturerID` are dropped, but `SerialNumber` is kept** — and FCC's own import
  template labels that field *"Serial Number/VIN"* (§7). So VIN may already be inside
  `SerialNumber` for some units and lost for others. The script does not say.
- **`Category1/2/3` are dropped** while the vault's §2 above flags them as *"three free
  classification slots beyond the schedule/unit type pair"*. Whether they hold anything was not
  checked before excluding them.
- **`TransportClass` is dropped**, yet transport class is exactly the sort of attribute the
  permit-and-trucking side of the business runs on.

**The script also enriches.** Four `LEFT JOIN`s add a readable label immediately after each code —
`DepartmentName` after `DeptCode`, `ScheduleType` after `UnitSchedType`, `UnitType` after
`UnitTypeID`, `UnitMeasure` after `MeasureCode` — which is why the exported sheet has 86 columns
for 78 source columns (78 + 4 labels + 4 that appear under both a raw and a joined name in the
sheet layout).

**`NewUsed` is decoded in the script**, and its full domain is documented in the header comment:

| Code | Meaning |
| --- | --- |
| `N` | New |
| `U` | Used |
| `T` | Trade |
| `F` | Financed |
| `R` | RPO (Rent-to-Purchase Option) |
| `L` | Lease |

Anything else exports as `Review: <value>`. In the 358-row export the distribution is
310 blank · 27 Used · 18 New · 2 Lease · 1 RPO — **87% of units have no acquisition type at all**.

Every text column is scrubbed for Excel: CRLF, CR and LF become ` | `, tab becomes a space.
**That means a genuine `|` in exported free text is indistinguishable from an embedded newline** —
worth knowing before parsing `Comments` or `SoldInfo`.

**The five sibling scripts are stubs.** `lkup_ SCHEDULE_TYPES.sql`, `lkup_ UNIT_MEASURES.sql`,
`lkup_ UNIT_TYPES.sql` and `lkup_DEPARTMENTS.sql` each contain **one line and nothing else** — a
comment naming their source table (`-- FROM [NexGenFMS].[dbo].[FMS_SCHEDULE_TYPES]` and so on).
No query was ever written; the lookup sheets in the workbook were produced some other way. Only
`UnitTypeDetails.sql` is a real script (§5).

## 4. The lookups, in full

Source: `FCC_UNITS-ASSETS_20260706.xlsx`, ran 2026-07-02. Each sheet carries the client's own
column-level annotation row — `keep` / `lookup` / `n/a` / `system` — above the header.

### Departments — 10, all active

| Code | Name | | Code | Name |
| --- | --- | --- | --- | --- |
| `CR` | Customer Repair | | `RG` | RIGGING |
| `FL` | FLEET | | `SH` | SHOP |
| `ID` | INTERNAL DAMAGE | | `ST` | STORAGE |
| `MC` | MECHANICS | | `TR` | TRUCKING |
| `OM` | OPERATED & MAINTAINED | | `YD` | YARD |

Distribution across the 358 units: `FL` 252 · `RG` 56 · `OM` 37 · `MC` 9 · `CR` 1 · `YD` 1 ·
blank 2. `ST` (Storage), `ID`, `SH` and `TR` have **no units at all** — they exist for cost
coding, not for equipment. `ExpAcct` is 1 on every department except `CR` and `ST`.

`ST` STORAGE was created by `bpetros` on 2025-10-31 and `CR` Customer Repair by `jstricker` on
2025-08-13 — the two newest, both within the last year of the export.

### Unit measures — 4 rows, and a gap

`C` CFM · `F` Feet · `N` None · `P` Pound. **That is the whole table.** But 25 units in the same
workbook carry `UnitMeasure = "Ton"` — a value with no row in the lookup. Either the extract of
`FMS_UNIT_MEASURES` is incomplete or the join is resolving something not in this sheet. **Do not
build a capacity-unit enum from this table without asking.**

The import template's `8. Capacity Units of Measure` tab is a *separate* code list from
`7. General Units of Measure` (which additionally carries a **`Conversion to Hours Factor`**), so
FCC distinguishes a unit's *capacity* measure from its *billing* measure. Both tabs shipped empty.

### Schedule types — three columns §1 above does not mention

The 2026-07-02 `SCHEDULE_TYPES` sheet confirms all 25 codes in §1 and adds:

- **`Schedules` (0/1)** — whether the type appears on the schedule at all. **`LP` Lift Plan,
  `SP` Street Permit and `TP` Travel Permit are `0`; every other type is `1`.** So FCC already
  distinguishes *schedulable* from *merely billable* among its schedule types, and the three
  exceptions are exactly the paperwork ones. `FAA` Permit, by contrast, **is** schedulable.
- **`UnitOrComponent`** — `U` on all 25 rows.
- **`SageEquipType`** — blank on all 25 rows; an integration slot to Sage that is unused.
- `TiedTo` — blank on all 25 rows.

The retired pair from §1 is confirmed with dates: `C` Crane (status 0, last touched by `tharmeyer`
2020-05-07) and `F` FAA Permit (status 0, superseded by `FAA` on 2023-05-25 by `joes`).

### Unit types — 71 rows, with `SortNumb` as the tonnage

`FMS_UNIT_TYPES` carries `SortNumb`, and for every crane row **it is the tonnage** — 22, 25, 30,
35, 40, 45, 60, 75, 90, 100, 110, 118, 120, 130, 140, 150, 165, 175, 190, 200, 265, 275, 330, 350,
360, 450, 500, 550, 900. Non-crane types are `SortNumb = 0`. So the tonnage class is a real,
sortable number in the data, not only a substring of the description.

`TargetMonthHrs` is **160** on every crane class that has one, **200** on the 30 Ton Self Loader,
**80** on the retired 118' Crane, and blank on 45 of the 71 rows. `TrackUnit` is 1 on all 71.
`PeakHours`, `NonPeakHours`, `AdditionalInfo` and `TransportClass` are blank on all 71.

## 5. `FMS_UNIT_TYPE_DETAILS` — one unit, many types

**This is the table behind sub-category substitution, and the vault has not held it before.**
The backend already has a `sub-category-substitutions` usecase folder; this is where its data
comes from.

Source: `UnitTypeDetails.sql` (a real script — it joins `FMS_UNIT_TYPE_DETAILS` to `FMS_UNITS`,
`FMS_UNIT_TYPES` and `FMS_SCHEDULE_TYPES`, ordering by `UnitCode`, `PrimaryType DESC`,
`UnitTypeID`, `UnitTypeDtlID`) and the resulting `UNIT_TYPE_DETAILS` sheet.

**Shape:** `UnitTypeDtlID · UnitCode · UnitName · UnitTypeID · UnitType · UnitSchedCode ·
ScheduleType · PrimaryType · Status · CreatedBy · CreatedDate · ModifiedBy · ModifiedDate`.

**565 rows over 358 units.** Exactly **358 rows carry `PrimaryType = 1`** — one per unit, no
exceptions — and 207 are secondary. **48 units carry more than one type; 310 carry exactly one.**

**What a secondary row means, in TCG's own words.** Slide 5 of
`FCC_MAINTAIN_RESOURCES-UNITS-ASSETS (partially reviewed by TCG).pptx` annotates the Unit Types
grid with one sentence:

> *"Unit Types: These are all the types of jobs this asset/vehicle can be Dispatched as."*

So the primary type is what the machine **is**; the secondaries are what it may be **dispatched
and sold as**. That is the same rule the sales side writes down in prose in
[crane-fleet-reference.md](crane-fleet-reference.md) §7 (*Equipment Rating/De-Rating*), and the
data agrees with the prose:

| Unit | Primary | Also dispatchable as |
| --- | --- | --- |
| `10001` Link-Belt HTC-86100 | 100 Ton Hydraulic Truck Crane | 90, 75, 60, 40 Ton |
| `4005` Liebherr LTM 1040 2.1 | 40 Ton | **45 Ton All Terrain Crane**, 60 Ton Hydraulic Truck Crane, 22 Ton Boom Truck |
| `20001` Link-Belt ATC-3200 | **200 Ton All Terrain Crane** | 175, 140, 120, 90, 75 Ton |
| `26502` Liebherr LTM 1220-5.2 | 265 Ton All Terrain Crane | 200, 175, 140, 120, 90, 75 Ton, and 265 again |

**Three cautions the data itself raises:**

1. **`20001` contradicts `FMS_UNITS`.** Its primary detail row is *200 Ton All Terrain Crane*;
   `FMS_UNITS.UnitTypeID` for the same unit resolves to *140 Ton Hydralic Truck Crane*. Two FCC
   tables disagree about the same unit's class. Which one FCC's screens use is not documented in
   this drop.
2. **Duplicate rows exist.** `26502` carries *90 Ton Hydraulic Truck Crane* twice, *140 Ton* twice,
   *200 Ton* twice, *175 Ton* twice, *120 Ton* twice, *75 Ton* twice, and *265 Ton* as both its
   primary and a secondary. The table has no uniqueness constraint on (unit, type). A migration
   that maps this straight to a substitution table will import duplicates.
3. **`SE` ("Sub Jobs") carries 15 types** — the most of any unit — and is an inactive placeholder,
   not a machine.

The de-rating direction is consistently downward — a bigger machine may be sold as a smaller one —
with the single exception of `4005`, where a **40 Ton** primary carries a **45 Ton** secondary.
That exception is the one the rating document explains: the Liebherr is a 45-ton machine when it
carries more counterweight.

## 6. Resource types as at 2026-09-02 — 76 active, and what changed since July

Source: `FCC_UNITS-ASSETS-ResourceTypes_20260902.xlsx`, prepared by the client for CodingCops on
2026-09-02. **Its `README` sheet is already transcribed in full** in
[quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md)
§7 — the estimate-template side of the same workbook. **What follows is the assets-side reading of
its data sheets, which that page records as not yet opened.**

FCC's *Resource Type* is `FMS_UNIT_TYPES` under a different name — the README says so outright:
*"Resource Type = FMS_UNIT_TYPES. This is a configuration/template concept, not an individual
physical Unit from FMS_UNITS."*

### The catalog grew by ten in eight weeks

The 2026-07-02 export holds **71 unit types** (active and inactive). The 2026-09-02 export holds
**76 active**. IDs 76–85 do not exist in the July file at all:

| New ID | Resource type | Schedule type |
| ---: | --- | --- |
| 76 | 360 Ton All Terrain w/Luffer | Mobile Crane |
| 77–82 | **Support Load 5, 6, 7, 8, 9, 10** | Trailer |
| 83 | **550 Ton All Terrain Crane w/Mega Wing** | Mobile Crane |
| 84 | **550 Ton All Terrain Crane w/Luffer** | Mobile Crane |
| 85 | **770 Ton All Terrain Crane** | Mobile Crane |

Two things follow. **First, an attachment configuration is its own resource type** — *w/Luffer* and
*w/Mega Wing* are separate rows from the base 360 and 550 ton classes, which is the same conclusion
the sales workbook reaches independently
([crane-selection-and-load-chart-model.md](crane-selection-and-load-chart-model.md) §4:
*"MegaWingLift must be a separate config because it changes mob/setup and capacity"*). **Second,
the support-load ladder is open-ended** — it ran to 4 in July and to 10 in September, growing with
the machines that need them.

ID 35 was also **renamed** between the exports, from *550 Ton Crane* to *550 Ton All Terrain Crane*.
And `770 Ton All Terrain Crane` (ID 85) has **no unit** in the July fleet — a class configured
ahead of the machine.

The arithmetic closes exactly. **Five** of the 71 July types are absent from the 76 active list,
and all five are the ones July already marked `Status = 0`: `1` 118' Crane, `19` 25 Ton Boom Truck,
`20` 35 Ton Boom Truck, `21` 120 Ton Hydraulic Truck Crane, `50` Crawler Crane. 71 − 5 active in
July, + 10 new = 76. **No type was retired between the two dates**, and ID 35's rename is the only
change to an existing row.

### `Category` is a third axis, and it is not what §1 calls a category

Every one of the 76 rows carries `CategoryCode = U`, `Category = Unit`. The import template
(§7) gives the domain: **`U` Unit · `C` Component · `T` Tool**. So FCC's own "Category" is
*Unit / Component / Tool*, **not** the Category → SubCategory pair that §1 above maps onto schedule
type → unit type. Three vocabularies use the word:

| Word | In FCC | Mapped in this vault to |
| --- | --- | --- |
| Schedule Type | `FMS_SCHEDULE_TYPES`, 25 codes | TCG **Category** (§1) |
| Unit Type / Resource Type | `FMS_UNIT_TYPES`, 76 active | TCG **Sub-Category** (§1) |
| **Category** | `U`/`C`/`T` on the schedule type | *(nothing — TCG has no equivalent)* |

The `U`/`C`/`T` axis is why the FCC menu reads *Units, **Components & Tools***. Everything TCG has
migrated so far is `U`. Tools & rigging — [tool-and-rigging.md](tool-and-rigging.md),
[loading-list.md](loading-list.md) — would be `T` in FCC's model, and **no `T` or `C` row exists in
any extract in this drop.**

### What a resource type drags along — `03_UnitPeople_Resources`, 328 rows

Each row is a required resource on a (resource type, job type, yard) configuration:
`UnitPeopleCode`/`UnitPeople` names the **category** (a schedule type), and
`RequiredResourceTypeID`/`RequiredResourceType` optionally names a **specific** resource type.

**Requirement categories, all 328 rows:** Tractor 154 · Trailer 152 · Truck 8 · Mobile Crane 8 ·
Rough Terrain Crane 2 · Crawler Crane 2 · Misc 1 · Tower Crane 1.

**What is required, by resource type:**

Tractor - Semi 154 · Operator Load 38 · Support Load 1 (23), 2 (21), 3 (17), 4 (13), 5 (8), 6 (8),
7 (6), 8 (4), 9 (4), 10 (3) · 90 Ton Hydraulic Truck Crane 4 · Yard Truck 3 · Flat Bed Truck 3 ·
Stretch Deck 2 · 45 Ton All Terrain Crane 2 · and one each of 130 Ton RT, 150 Ton RT, 200 Ton
Crawler Crane, 330 Ton Crawler Crane, 770 Ton All Terrain Crane, Counterweight Trailer, Drop Deck
Trailer, Flat Bed Trailer, Lowboy Trailer, Parts Truck, RCS, Service Truck, Support Load, Tower
Crane.

**Half the requirement rows are tractors.** A big crane's configuration is mostly *"another
Tractor - Semi"* repeated — the 550 Ton w/Mega Wing configuration carries **12 tractor rows, two
Operator Loads and Support Loads 1 through 10**, plus a 90 Ton Hydraulic Truck Crane as an
assist crane. That physical fleet is catalogued as trailers in
[crane-fleet-reference.md](crane-fleet-reference.md) §4.

`ResourceRequirementScope` reads *Specific Resource Type* on **327 of 328** rows and
*Schedule Type Only* on exactly one — the Bare Rental row the README calls out.
`OptionFlag_Raw` is `M` on all 328, and the README is explicit that *"its business meaning was not
assumed in this package."* `SpecificUnitCode` and `SpecificUnitName` are **empty on every row** —
FCC can pin a requirement to a physical unit and never does.

### Does the requirement differ per job type? Yes — for three resource types

The README leaves this open and the rows answer it. **17 resource types have more than one
Job Type/Yard configuration. In 14 of them the Unit/People requirement set is identical across
configurations. In three it is not**, and in all three the difference is *one extra tractor* or
*one extra support load* on the mobilisation-bearing configuration:

| Resource type | Config A | Config B |
| --- | --- | --- |
| 190 Ton All Terrain Crane | **4** tractors + Operator Load + Support Loads 1–2 | **3** tractors + Operator Load + Support Loads 1–2 |
| 350 Ton All Terrain Crane | **5** tractors + Operator Load + Support Loads 1–4 | **6** tractors + Operator Load + Support Loads 1–4 |
| 550 Ton All Terrain Crane w/Mega Wing | **13** tractors, 2 Operator Loads, Support Loads 1–10 | **12** tractors, 2 Operator Loads, Support Loads 1–9 |

So the requirement genuinely belongs to the (resource type, job type, yard) triple, not to the
resource type — but **82% of the time it does not vary**, which is why it is easy to model wrongly.

### The job-type code list

From `02_JobType_Yard`, 75 configurations. The distinct job types across all of them:

| Code | Job type | Configurations |
| --- | --- | ---: |
| *(none)* | **No Job Type Stored** | **29** |
| `H` | Hourly | 24 |
| `Z` | Hourly w/ Mob | 20 |
| `B` | Bare | 1 |
| `O` | **OCCIP / CCIP** | 1 |

Yard: **All Yards** on 71, **Main Yard** on 4 — matching the README's count exactly. `OCCIP/CCIP`
(owner- and contractor-controlled insurance programmes) as a *job type* is new information; it
appears in no other source in this drop.

## 7. FCC's unit import contract

Source: `Unit Data v.6.25_TEMPLATE.xlsx` — **14 sheets, all blank**. 1,000 empty rows of validation
formulas, no data. Its value is the field-level contract in its instruction row.

**Required to create a unit in FCC** (the template's word, verbatim):

| Field | Rule |
| --- | --- |
| Unit Code | up to **15 characters**, including spaces |
| Description | up to **60 characters** |
| Company/Owner | a `Company Code` from the *Companies in NexGen* tab |
| Department | a `Dept` from *Departments in NexGen* |
| Yard | a `Yard Code` from *Yards in NexGen* |
| Schedule Type | a `Schedule Code` — *(the note says "under 'Yards in NexGen' tab", which is a typo for the Schedule Types tab)* |
| Resource Type | a `Resource Description` from the *Resource Types* tab |
| **Capacity Unit of Measure** | a `Code` from *Capacity Units of Measure* |
| Status | **`A` Active or `T` Inactive** |

**Everything else on the unit is optional** — including Model Year (4 chars), Capacity (5 chars),
make, model, all three engine make/model/serial triples, insurance value, meters, licence, serial
number/VIN, dimensions, purchase and sale data, rates and targets.

Notable constraints:

- **Status is `A` / `T`**, not `A` / `I`. The same `A`/`T` pair governs schedule types and resource
  types on their own tabs.
- **Meters are three independent booleans with their own readings**: `Has Upper Meter?` +
  `Hours/Upper` + `Hours/Upper as of Date`; the same for Lower; and `Has Odometer?` + `Miles/KM` +
  `Miles/KM as of Date`. This is the structure the Samsara constraint in
  [asset-record-requested-additions.md](asset-record-requested-additions.md) §3 acts on — only
  lower engines are telemetered.
- **Dimensions are feet **and** inches as separate 3-character fields** — width, height, length,
  gage, jib — while `Main Boom Length` is a single 14-character field. Any ERP model that stores a
  single decimal will lose the shape of the source data.
- `Purchase Type` takes the same `N/U/T/F/R/L` domain as `NewUsed` (§3).
- **`AdditionalInfo1`–`11` are renameable per tenant**: *"field can be renamed under
  Maintain->Field Names->Unit Tab."* So FCC ships a user-defined-field mechanism, and TCG's
  migration drops all of them (§3).

**Two sibling tabs define code lists this vault has not recorded:**

- `3. Schedule Types` — `Schedule Code` (5 chars) · `Schedule Type` (30 chars) ·
  **`Include on Schedule?` (Y/N)** · **`Category` — Unit (U), Component (C) or Tool (T)** ·
  Status (A/T). This is the import-side name for the `Schedules` and `UnitOrComponent` columns
  in §4.
- `5. Resource Types` — `Resource Description` (40 chars) · `Additional Info` ·
  `Target Hours/Month` (10 chars) · `Schedule Type` · Status (A/T). **A resource type is defined by
  its description, not by an ID** — the ID is FCC-generated.

`9. Fuel Types` is a free list (15 chars); `10.–14.` (Companies, Yards, Departments, States,
Salespeople in NexGen) shipped **empty**, so the template as delivered cannot be filled in without
the tenant's own code lists.

## 8. The FCC unit table family — 42 tables, and what the client says to do with each

Source: `__NexGenFMS_Inventory_20260702_0246.xlsx`, 14 sheets. This is a **complete schema
inventory of NexGen FMS with exact row counts**, and it is a different artefact from the
`FCC-NexGen_TABLES_VIEWS.xlsx` named at the top of this page: 444 tables (not 692 objects),
8,849 column rows, 421 primary keys, 1,523 foreign keys, 54,691 inferred-lookup rows, and — the
part that matters — a **`TableClassification` sheet that assigns every table a role, a data
sensitivity and a suggested migration disposition.**

**Whole-database totals:** 9,249,302 rows across 444 tables; **227 tables have any rows at all**,
217 are empty.

**Suggested migration disposition, across all 444 tables:**

| Disposition | Tables |
| --- | ---: |
| Do Not Extract Now / Keep in Inventory *(empty tables)* | 217 |
| Business Review Needed | 95 |
| Likely Migrate / Business Review | 53 |
| Reference / Config Mapping *(lookup/code)* | 36 |
| Archive or Migrate Separately *(attachments/signatures/documents)* | 22 |
| Review Carefully / Usually Do Not Migrate Directly *(security/user/profile)* | 17 |
| Archive / Reference Only *(historical reporting)* | 4 |

**Table role:** Empty/Dormant 217 · Possible Lookup / Master Reference 70 · Lookup / Config 38 ·
Attachment / Binary / Document 26 · Transaction / Operational 22 · Master Data 19 · Unknown /
Needs Review 18 · Bridge / Mapping / Detail 17 · Security / Admin 13 · Audit / Log / History 4.

**Data sensitivity:** General Business 152 · Financial 127 · Payroll/Labor 92 · PII 32 ·
PII + Payroll 21 · Security/Access 12 · Documents/Binary 8.

### The 42 unit / equipment / storage tables

| Table | Rows | Cols | Suggested disposition |
| --- | ---: | ---: | --- |
| `FMS_JOB_UNIT_CHECK_LIST` | **4,148,349** | 33 | Likely Migrate / Business Review |
| `FMS_JOB_TICKET_EMP_UNIT` | 131,039 | 34 | Likely Migrate / Business Review |
| `FMS_JOB_UNITS` | 76,832 | 61 | Likely Migrate / Business Review |
| `FMS_QUOTE_UNITS` | 65,030 | 12 | Likely Migrate / Business Review |
| `FMS_UNIT_MILEAGE` | 5,686 | 38 | Likely Migrate / Business Review |
| `FMS_UNIT_ACT_ACTION_LIST` | 3,537 | 14 | Likely Migrate / Business Review |
| `FMS_UNIT_ACTIVITIES` | 3,222 | 30 | Likely Migrate / Business Review |
| `FMS_UNIT_TYPE_DETAILS` | 565 | 11 | Reference / Config Mapping |
| `FMS_UNIT_TYPE_ESTIMATE` | 548 | 30 | Reference / Config Mapping |
| **`FMS_UNITS`** | **358** | **156** | **Archive or Migrate Separately** |
| `FMS_JOB_STORAGE` | 252 | 30 | Likely Migrate / Business Review |
| `FMS_UNIT_TYPE_EQUIPMENT` | 172 | 15 | Reference / Config Mapping |
| `FMS_CUSTOMER_UNITS` | 79 | 42 | Archive or Migrate Separately |
| `FMS_UNIT_TYPE_JOBTYPE_YARD` | 74 | 7 | Reference / Config Mapping |
| `FMS_UNIT_TYPES` | 71 | 15 | Reference / Config Mapping |
| `FMS_UNITTYPE_JOBTYPES` | 42 | 7 | Likely Migrate / Business Review |
| `FMS_UNIT_CHECK_LIST` | 14 | 8 | Likely Migrate / Business Review |
| `FMS_UNIT_TYPE_EMPLOYEES` | 7 | 14 | Reference / Config Mapping |
| `FMS_UNIT_DOWN_REASON` | 5 | 8 | Likely Migrate / Business Review |
| `FMS_UNIT_MEASURES` | 5 | 8 | Likely Migrate / Business Review |
| `FMS_UNITTYPE_YARDS` | 4 | 7 | Likely Migrate / Business Review |
| `FMS_STORAGE_LOCATION` | 3 | 7 | Business Review Needed |

Plus **20 empty tables** all dispositioned *Do Not Extract Now / Keep in Inventory*:
`FMS_COMPONENT_UNITS`, `FMS_DVIR_UNITS`, `FMS_EQUIP_COST_CODES`, `FMS_GRID_SETTING_UE_UNIT_TYPES`,
`FMS_GRID_SETTING_UNIT_TYPES`, `FMS_LABOR_PAYROLL_SECONDARY_UNITS`, `FMS_LABOR_SECONDARY_UNITS`,
`FMS_PEOPLE_UNIT_ASSOCIATIONS`, `FMS_PROFILE_UNITTYPES`, `FMS_UNIT_ALLOC_VALUES`,
`FMS_UNIT_COMPONENTS` (51 cols), `FMS_UNIT_MILEAGE_LOCATION`, `FMS_UNIT_MISC_INFO` (**93 cols**),
`FMS_UNIT_PRICE_LIST`, `FMS_UNIT_QUOTES`, `FMS_UNIT_SALES_INFO` (57 cols),
`FMS_UNIT_SALES_INHOUSE_COMMENTS`, `FMS_UNIT_SALES_QUOTE_PRICE`, `FMS_UNIT_WARRANTY`,
`FMS_UNIT_YARD`.

**Five things this table says that nothing else in the vault does:**

1. **`FMS_JOB_UNIT_CHECK_LIST` holds 4.1 million rows** — 45% of the entire database. A per-job,
   per-unit checklist is by far the largest thing FCC has ever recorded, and it is flagged *Likely
   Migrate*. Nobody has scoped that.
2. **`FMS_UNITS` itself is dispositioned *"Archive or Migrate Separately"***, not *Likely Migrate* —
   the category the workbook's own legend glosses as *attachments/signatures/documents*. Whether
   that is deliberate or a mis-classification of a 156-column master table is worth asking, because
   it is the single most important table in this module.
3. **`FMS_UNIT_COMPONENTS` (51 columns) and `FMS_UNIT_MISC_INFO` (93 columns) are empty.** FCC has a
   whole component model and a 93-field misc block that TCG has never used — which is consistent
   with every schedule type being `Category = U` (§6).
4. **`FMS_UNIT_PRICE_LIST` is empty**, so unit-level pricing in FCC is unused; rates live on the
   unit row (`HourlyRate`, `HourlyCost`) and in billing codes.
5. **`FMS_DVIR_UNITS` is empty.** DVIR — the driver vehicle inspection report — is the natural home
   for something like [trailer-inspection-form.md](trailer-inspection-form.md), and FCC has the
   table and no data in it. Inspections are on paper.

## 9. What the two earlier units reports add

`2026-05-29_FCC_UNITS_REPORT.xlsx` and `2026-05-05_FCC_UNITS_REPORT_w_slicers.xlsx` are also in this
drop, at `2.0.1_DATABASE-SCHEMA/`. **They are the same two files already described at the top of
this page** — `UNITS_raw` (354 units), `FMS_UNIT_TYPES` (71), `FMS_SCHEDULE_TYPES` (25),
`UNITS_w_ScheduleType`, and the 2026-03-16 / 2026-05-05 slicer snapshots. Nothing in them
contradicts §1 or §2.

**The only new fact is the count over time:** 354 units at 2026-05-29 → **358** at 2026-07-02.
Four units were added in five weeks. The schedule-type and unit-type lookups are unchanged between
the two dates.

---

## FCC's unit import template — the validation rules (read 2026-09-04)

`Unit Data v.6.25_TEMPLATE.xlsx` (65,949 formulas, 26 patterns on `1. Unit Information`): unit
code ≤ 15 · description ≤ 60 · **company, department and yard must exist in `10. Companies` /
`12. Departments` / `11. Yards`** · **schedule type must exist in `3. Schedule Types`** ·
**resource type must exist in `5. Resource Types`** · two short codes (≤ 4 and ≤ 5 chars) ·
**capacity unit of measure from `8. Capacity Units of Measure` rows 15–89** · a `Y/N` flag · a
25-char and a 50-char text field. The hidden `Unit Profile Blank Example` sheet is a worked
blank. `Storage Data v.9.25_TEMPLATE.xlsx` is the same pattern with four length rules (unit ≤ 15,
description ≤ 100, two short fields) and a hidden `Drop Down Lists` sheet.

## Source (2026-09-04 additions)

- `2.1.1_DATA-MIGRATION/NexGenFMS_for_ERP/FCC_UNITS-ASSETS_20260706.xlsx` — 8 sheets, ran
  2026-07-02: `Units_SQL`, `UNITS` (358 × 86), `UnitTypeDetails_SQL`, `UNIT_TYPE_DETAILS` (565),
  `DEPARTMENTS` (10), `SCHEDULE_TYPES` (25), `UNIT_TYPES` (71), `UNIT_MEASURES` (4). Unit row data
  not copied except the crane subset in [crane-fleet-reference.md](crane-fleet-reference.md) §1
- `…/__VS_CODE_DataMigration/SQL_FCC_CORE_TABLES/UNITS-ASSETS/FCC_UNITS-ASSETS.sql` (14.7 KB) and
  `UnitTypeDetails.sql` (3.1 KB); `lkup_ SCHEDULE_TYPES.sql`, `lkup_ UNIT_MEASURES.sql`,
  `lkup_ UNIT_TYPES.sql`, `lkup_DEPARTMENTS.sql` are **one-line comment stubs** (42–46 bytes each)
- `2.1.1_DATA-MIGRATION/NexGenFMS_for_ERP/FCC_UNITS-ASSETS-ResourceTypes_20260902.xlsx` — 7 sheets;
  the `README` is transcribed in
  [quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md)
  §7, the `05_Estimate` sheet (701 rows) belongs there; `01_Main`, `02_JobType_Yard` and
  `03_UnitPeople_Resources` are summarised above with row data not copied
- `2.1.1_DATA-MIGRATION/NexGenFMS_for_ERP/__NexGenFMS_Inventory_20260702_0246.xlsx` — 14 sheets;
  only counts, roles, dispositions and the unit-table family recorded. The `InferredLookup` sheet
  (54,691 rows) and `AllColumns` (8,849) are **bulk data, not copied**
- `1.0.2_FCC-RESOURCES-GUIDES/FCC-IMPORT-Templates/Unit Data v.6.25_TEMPLATE.xlsx` — 14 sheets,
  **no data rows**; field contract only
- `1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_MAINTAIN_RESOURCES-UNITS-ASSETS (partially
  reviewed by TCG).pptx` — slide 5 only; the rest is in
  [asset-record-requested-additions.md](asset-record-requested-additions.md)
- `2.0.1_DATABASE-SCHEMA/2026-05-29_FCC_UNITS_REPORT.xlsx` and
  `2.0.1_DATABASE-SCHEMA/2026-05-05_FCC_UNITS_REPORT_w_slicers.xlsx` — **confirm §1 and §2, nothing
  new** beyond the 354 → 358 unit count

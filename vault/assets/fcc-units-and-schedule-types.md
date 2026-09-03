---
title: FCC units report — schedule types, unit types, and the raw unit table
source: shared-folder/OneDrive_1_8-31-2026
migrated: 2026-08-31
updated: 2026-09-03
status: unverified
conflicts_with: []
jira: []
tags: [module/assets, module/dispatch, kind/reference, fcc, migration, categories, sub-categories, gps]
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

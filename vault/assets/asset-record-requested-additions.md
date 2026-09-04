---
title: Asset record — the fields and features TCG has asked for
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_MAINTAIN_RESOURCES-UNITS-ASSETS (partially reviewed by TCG).pptx — slide text and notes, plus all 63 embedded screenshots read 2026-09-04
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/assets, kind/source, requirements, integrations, reporting, compliance, reference-data]
entities: []
---

# Asset record — the fields and features TCG has asked for

**What this is.** A 38-slide deck of **FCC screenshots that TCG annotated with what the ERP should
add**. Its filename says how far it got: *"FCC_MAINTAIN_RESOURCES-UNITS-ASSETS (partially reviewed
by TCG)"*. Five slides carry annotations; the other 33 are screenshots with no text of their own.
Undated — its folder is `1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/`, a set of decks that walk
the FCC menus screen by screen.

**Why it matters.** This is the client marking up the legacy asset screen and saying *"add these"*.
It is the second of two independent asset wish-lists in this drop — the other is Melissa's entry
**#7** in [erp-review-log.md](../erp-review-log.md) (2026-05-02). They overlap in one place and
diverge everywhere else, and neither has been adjudicated.

> **The slides are images.** Only the annotation text boxes converted, so §1–§5 attribute nothing to
> a specific FCC field unless the annotation names one. **The screenshots themselves were read on
> 2026-09-04** — the final section pairs each annotation with the screen it sits on.

---

## 1. Fields TCG marked `*** added fields ***`

**On the unit/vehicle detail slide:**

| Field | Type given | Example given |
| --- | --- | --- |
| Engine Family | Text | `JCEXL11.9AAR` |
| Emissions Tier | **Dropdown** | `Tier 4 Final` |
| Engine Model Year | Number (YYYY) | `2012` |
| **GVWR** (Gross Vehicle Weight Rating) | — | defined at length, see below |

The deck defines GVWR itself, which is unusual enough to quote:

> *"represents the total weight of the crane as it travels down the road. This includes the truck
> chassis, the upper crane assembly, the engines, all fluids (a full tank of diesel, hydraulic
> fluid, etc.), and the driver."*

Two of these are emissions-compliance fields (Engine Family, Emissions Tier) — the vocabulary of
CARB/EPA reporting. The review log's *"Boxes for **PERP, DOORS**, Trucks, etc."* (entry #7 item 12)
is the same territory: PERP is California's Portable Equipment Registration Program and DOORS its
off-road diesel reporting system. **Neither source says what the ERP is supposed to do with them** —
store, report, or alert.

**On the financial slide, also `*** added fields ***`:**

Loan details — **Lender · Interest Rate · Maturity Date · Balloon · Depreciation**.

FCC already carries a depreciation and insurance block on `FMS_UNITS`
([fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md)), all of it flagged
`IncludeInReport = 0` in the migration export. So the client is asking for finance data the legacy
system half-holds and the migration is not carrying.

---

## 2. Features TCG marked as new sections

### `*** BATCH FUNCTIONALITY ***`

> *"Ability to create groups/batches of assets (vehicles) and equipment needed for types of Jobs.
> That would allow us to run a report for Dispatch to check to make sure that everything in that
> group/batch is good/current for dispatching to Job."*

Two things in one ask: a **named reusable group of assets per job type**, and a **readiness report
over that group**. The first is close to what FCC already does structurally — a resource type's
required *Unit/People* rows per job type (see
[fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §5 and
[quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md)).
The second — *"good/current"*, i.e. every asset in the batch passing its compliance and expiry
checks before dispatch — has no counterpart anywhere in the vault. It pairs with the review log's
request for a **compliance section with expiry dates on annual permits and certifications, as
attachments with expiry and notifications** (#7 item 11).

The deck does not say whether the batch is per job type, per crane class, or ad-hoc.

### `*** Profile Pictures for Asset ***`

One line, no detail. Matches the review log's *"Pictures of the cranes in their profiles"*
(#7 item 14) — **the one point the two wish-lists agree on**.

### `*** NEW SECTION/FUNCTIONALITY ***` — fuel

> *"App to be used at the fueling station when filling up assets with fuel, to track fuel usage.
> Would be good to track upper and lower separately."*

A mobile capture point at the pump, per asset, split upper and lower engine.

### Asset documents

> *"Asset Documents: Contracts/documents uploaded to each Asset"*

Attachments on the asset record. The review log adds what kind: *"Attachments for manuals and load
charts"* (#7 item 15) — which is the destination for the load-chart library catalogued in
[crane-fleet-reference.md](crane-fleet-reference.md) §6.

---

## 3. Samsara — the meter question, twice

Two slides carry *"Need to discuss how this information will be managed in relation to Samsara
data/tracking"* — once against the unit detail fields, once against the meters slide, where the
deck adds:

> *"Live updates from Samsara. **Only lower engines are tracked by Samsara. Upper engines are
> entered manually… Samsara is not in upper engines.**"*

This is a hard constraint on any hour-meter feature, and it explains why `FMS_UNITS` carries
`HasMeterHrsUp`, `HasMeterHrsLo` and `HasOdometerMiles` as separate flags with separate
`HourUpper` / `HourLower` / `DateHrUpper` / `DateHrLower` readings. **Upper-engine hours are a
manual entry and always will be**, unless something other than Samsara supplies them.

FCC also carries `UpperGPS`, `LowerGPS`, `UpperGPSID`, `LowerGPSID` per unit and a `SkytelID`
column — see [fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md). The deck does not
say whether Samsara replaces those, feeds them, or is a third system.

**Unresolved, and marked so by the client itself:** *"Need to discuss"* is not a requirement. The
deck raises Samsara integration and does not settle it.

---

## 4. The dashboards asked for on the financial slide

Listed under `*** FINANCIAL reporting/dashboards ***`, verbatim and in order:

Invoicing · **Utilization Dashboard** · **Profitability Dashboard** · Sales & Quoting Dashboard ·
**Storage Sensor Dashboard** · Open Invoices by Sales Rep · Open Invoices · Customer Collection
Notes · **Storage Dashboard** · **Usage & Availability** · **Current Storage** · **Check-In** ·
**Check-Out**.

Five of the thirteen are storage-side, and *Check-In* / *Check-Out* / *Current Storage* are the
warehouse workflow in [storage-and-warehouse-operations.md](storage-and-warehouse-operations.md)
asked for as screens. **"Storage Sensor Dashboard" appears nowhere else in the drop** — no sensor,
device or telemetry is named in any storage source. What it means is unknown.

*Utilization* and *Usage & Availability* have a data hook already: FCC's unit types carry
`TargetMonthHrs` (160 on most cranes, 200 on the 30 Ton Self Loader) and units carry
`MonthlyTarget`, `HourUpper`/`HourLower` and `Revenue` / `LaborExpenses` / `PartsExpenses`
columns — all of the last three flagged `IncludeInReport = 0` in the migration.

---

## 5. Against the review log

[erp-review-log.md](../erp-review-log.md) entry **#7 — Assets (Melissa, 2026-05-02)** is the other
asset wish-list in this drop. Side by side:

| Asked for | Deck | Review log #7 |
| --- | :-: | :-: |
| Profile pictures / crane photos | ✓ | ✓ (item 14) |
| Attachments on the asset | ✓ *(contracts/documents)* | ✓ (item 15, *manuals and load charts*) |
| Compliance / expiry / notifications | implied by *"good/current"* batch report | ✓ (item 11, explicit) |
| PERP, DOORS, trucks | — | ✓ (item 12) |
| Emissions fields (Engine Family, Tier, Engine Model Year) | ✓ | — |
| GVWR | ✓ | — |
| Loan / finance block | ✓ | — |
| Batch/group of assets per job type + dispatch readiness report | ✓ | — |
| Fuel-station app, upper/lower split | ✓ | — |
| Samsara meter integration | raised, unresolved | — |
| Financial and storage dashboards (13) | ✓ | — |
| Crane attributes: main boom length, jib length, luffer, counterweight count, offset jib, main and aux winch, man-basket attachment, load line size, axle count / weight per axle / tyre size | — | ✓ (item 13) |
| Categories = Mobile Crane / All Terrain Crane; Sub Categories = All Terrain / Tonnage | — | ✓ (item 10) |

**The two lists are almost disjoint.** Only photos and attachments appear on both. Anyone treating
either as "the asset requirements" will be missing most of them.

The review log's item 13 crane attributes are also the fields the load charts and TCG spec sheets
carry as engineering data ([crane-fleet-reference.md](crane-fleet-reference.md)) and that
`FMS_UNITS` half-carries already — `BoomLength`, `JibLengthFt`/`JibLengthIn`, `AxleType`,
`TiresType`, `VehicleWidth/Height/Length` in feet and inches. Counterweight count, luffer, offset
jib, main and aux winch, man-basket attachment and load line size have **no FCC column** and are
per-configuration facts, not per-unit facts — which is the same problem
[crane-selection-and-load-chart-model.md](crane-selection-and-load-chart-model.md) §2 solves by
making the configuration, not the crane, the thing that carries them. Neither source says how TCG
wants that resolved.

---

## Source

`1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_MAINTAIN_RESOURCES-UNITS-ASSETS (partially
reviewed by TCG).pptx` — 38 slides, converted to per-slide text. **Slides 2, 3, 5, 7, 9 carry
annotation text; the remaining 33 are screenshots that converted to nothing.** Slide 5's whole
content is one line, quoted in
[fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §5.
Cross-referenced against `.ai/vault/erp-review-log.md` §#7 (from `THE CRANE GUYS - ERP REVIEW
LOG.xlsx`, same drop).

---

## What the deck's screenshots show — read 2026-09-04

All 63 images embedded in `FCC_MAINTAIN_RESOURCES-UNITS-ASSETS (partially reviewed by TCG).pptx`
were extracted and viewed on 2026-09-04. The note at the top of this page — *"what each
annotation points at is not recoverable from the text"* — no longer holds; this section pairs each
annotation with the screen it sits on. Only what the annotations did not already give is recorded:
tab names, field labels, dropdown domains, checkbox options, defaults, and the example records
that reveal a convention. Generic toolbar chrome is skipped. The example unit on every Units slide
is **`10001` — "100 Ton Hydro Truck Linkbelt"** (the crane whose de-rating ladder is quoted in
[fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §5).

### The `Maintain → Resources` menu, and how the deck walks it

Thirteen entries, in FCC's order: **Units · Components & Tools · Ad-hoc Checklists · Customer Owned
Units · Resource Types · Schedule Types · Down Reasons · Unit Checklists · Master Activities List ·
Accountability Levels · Unit Fuel Types · Unit Capacity U/M · Unit Location History.** The deck
opens every one of them (slides 1–13 Units, 14–17 Components & Tools, 18–19 Ad-hoc Checklists,
20–24 Customer Owned Units, 25–28 Resource Types, 29–38 one lookup each). Only slides 2, 3, 5, 7
and 9 carry a TCG annotation; the "partially reviewed" of the filename is literal.

### The Units window — eleven tabs (slides 2–13)

Header filters: **Sched Type · Unit Type · Units** (code lookup) **· View** (`All Yards`) **·
Status** (`Active`). Tabs, in order: **Main · Buy/Sell Info · Addtl Info · Unit Types · Axles ·
Activities · Parts · Meter · Checklist · Checklist History · Components.**

**Main (slide 2 — the `*** added fields ***` and `BATCH` / `Profile Pictures` slide).** Left
column: Unit Code · Description · Company/Owner · Dept · Yard/Location · **Schedule Type and Unit
Type, both greyed out** · Model Year · Capacity + a unit-of-measure dropdown (`Ton`) · **Needs
PickUp** ☐ · **Check Schedule Overlap** ☑ · Vehicle Make · Vehicle Model · Upper Engine
Make / Model / Serial Number · Lower Engine Make / Model / Serial Number · Transmission Make /
Model / Serial Number. Right column: **Status in Fleet** (`Active`) · *Current Hours*: Has Upper
Meter ☐ + Hours/Upper + As of; Has Lower Meter ☑ + Hours/Lower + As of · *Current Miles/KM*: Has
Odometer ☑ + Miles/KM + a `Miles` unit dropdown + As of · License + State + Exp · **Serial
Number/VIN** · Tires Type · Drive/Axle type · Fuel Type (`DIESEL`) · **GVW** · Vehicle Width /
Height / Length / Gage as **Ft + In pairs** · Jib Length (Ft + In) · Main Boom Length · Bar Code.

What the example record shows that the annotations do not say:

- **Schedule Type and Unit Type are read-only on Main.** They are set on the *Unit Types* tab by
  whichever row carries `Primary` (below). The screen does not say so; the greying and the
  Primary flag together imply it.
- **`Serial Number/VIN` holds two values on `10001`, separated by ` / `** — a 17-character VIN
  followed by a manufacturer serial. This is the direct evidence for the concern in
  [fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §3 that VIN may already
  live inside `SerialNumber` for some units while the migration drops the `VIN` column.
- **A `GVW` box already exists on Main** (blank on `10001`) — the `Gvm` column the export
  excludes. TCG's slide-2 annotation nevertheless lists **GVWR** under *added fields* and defines
  it. Whether the ask is to populate/rename the existing field or to add a distinct GVWR is not
  stated; the deck shows a field with the same meaning sitting empty.
- The annotation's Engine Family example `JCEXL11.9AAR` is the CARB family of the **lower**
  engine on the same screen (Cummins `ISX11.9`). The upper-engine triple is blank on this truck
  crane — a single-engine machine — so the three added fields are per-engine facts that FCC's
  Main tab has no slot for.
- Meter readings are dated: `Hours/Lower` and `Miles/KM` each carry an *As of* date, and
  `Has Upper Meter` is unticked on `10001` — the three-boolean structure of the import template
  ([fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §7) as it looks on screen.
- Licence plate carries **State** and an **Exp** date — an expiry FCC already tracks on the unit.

**Buy/Sell Info (slide 3 — the `Loan details` and `FINANCIAL reporting/dashboards` slide).**
*Purchase Info*: Purchase Date · Purchase Price · Start Hr/Miles · **Purchase Type** (dropdown;
`Used` on the example — the `N/U/T/F/R/L` domain of §3 in the units page). *Sale Info*: Date Sold ·
Sale Price · Date Priced · Sold Salesperson. Then Current Value · Insurance Value · *Sold To/
Inactive Information* (memo). Four checkboxes: **Apply SMM Tax · Accelerated Tax Paid · Heavy
Machinery · Texas TERP Eligible** (all unticked on `10001`; these are the `ApplySMMTax`,
`AcceleratedTaxPaid`, `HeavyMachinery`, `TerpEligible` columns the export drops). *Rates*:
**Allocated & Rental Invoicing Hourly Cost · T&M Invoicing Hourly Rate · Monthly Target ·
Monthly Payment Amount.** *Expenses*: As Of Date · Revenue · Labor Expense · Parts Expense.

- **`Monthly Target` on this tab is a currency amount**, not hours — on `10001` it is a
  five-figure dollar target. §4 of this page treats the `MonthlyTarget` column as a utilisation
  hook alongside `TargetMonthHrs`; the screen says the unit-level one is a *revenue* target and
  only the unit-type one is hours.
- **No depreciation field appears on any tab in the deck**, although `FMS_UNITS` carries a
  depreciation block. The annotation's *Depreciation* ask is for something the screen never
  surfaces. Of the five *Loan details* asked for, only **Monthly Payment Amount** exists; Lender,
  Interest Rate, Maturity Date and Balloon do not.
- The two rate fields are populated on the example (an hourly *cost* and a much larger hourly
  T&M *rate*) — unit-level pricing is in use here even though `FMS_UNIT_PRICE_LIST` is empty (§8
  of the units page).

**Addtl Info (slide 4, no annotation).** Left: Yard Equipment Loca[tion] · Mast Height · Lift
Height · Free Lift · Fork Length · Carriage · Tires · Extended Capacity · Accessories ·
*Attachements* (sic) · Rental Requirements — the forklift block, all empty. Right: **`Manbasket #`**
followed by AdditionalInfo2 … AdditionalInfo11. Then Comments and the audit stamps.

- **`AdditionalInfo1` has been renamed `Manbasket #`.** TCG used FCC's *Maintain → Field Names*
  mechanism exactly once, for the man-basket attachment that review-log #7 item 13 asks for (§5
  above). The migration drops all eleven `AdditionalInfo` columns, so this one field of real
  meaning goes with them. Blank on `10001`.

**Unit Types and Axles (slide 5 — annotation *"all the types of jobs this asset/vehicle can be
Dispatched as"*).** Unit Types grid: **Schedule Type · Unit Type · Primary ☑ · Status.** `10001`
carries *Mobile Crane / 100 Ton Hydraulic Truck Crane* as Primary plus 40 Ton, 60 Ton, 75 Ton and
90 Ton Hydraulic Truck Crane as secondaries — exactly the §5 row in the units page. The Axles grid
on the same slide: **Axle No · Tire Manufacturer · Model · Axle Weight (lbs) · Tire Size · Tires
Per Axle · Inches On Ground · Axle Space (Ft) · Axle Space (In)** — empty for `10001`.

- **FCC already has the per-axle table** that review-log #7 item 13 asks for (*axle count /
  weight per axle / tyre size*). The §5 comparison table above lists that ask as absent from the
  deck; the screen shows the structure exists and is unfilled on this unit.

**Activities (slide 6).** Buttons *Hide Action List · Add Task · Del Task*. A two-row header:
**Activity · Prev Maint ☑ · Maint Every · Maint Period · Last Date · Last Miles/KM · Last Hrs/Up ·
Last Hrs/Low · Price · Status**, and beneath each: **Comments · Maint Every · Maint Period · Next
Date · Next Miles/KM · Next Hrs/Up · Next Hrs/Low · Standard Time · File Links.** Every activity
can carry **two intervals joined by "or"** — `1000 Hour Service` is *1,000 Hours/Lo* **or** *6
Months*. Maint Period values seen: `Hours/Lo`, `Months`, `Days`. On `10001`: 1000 Hour Service ·
30 Day Inspection (30 Days) · 500 Hour Service (500 Hours/Lo, with a last lower-hours reading and
a next-due reading 500 higher) · 90 Day DOT Inspection (90 Days; last 01/30/2026 → next
04/30/2026) · A2B / LMI Repair · Air Conditioner / Heater… · Air System Repair (the last three
with no interval and Prev Maint unticked). A *Task* sub-grid sits below.

- So FCC computes next-due from last-done plus interval, in lower-engine hours, miles or calendar
  time, per unit. That is the expiry engine review-log #7 item 11 asks for — it exists; what the
  deck shows missing is attachment-with-expiry and notification (below).

**Slide 7 — annotation *"Asset Documents: Contracts/documents uploaded to each Asset"*.** The
screenshot is **`Maintain File Links – Unit Activity`**, headed *Activity Code-2004*, columns
**File Name · Comments · Created By · Modified By · Status · Created Date · Modified Date**, empty.
**The annotation describes an asset-level document store; the screen it annotates is
activity-level** — files hang off one maintenance row, not the unit. The deck shows a unit-level
`Maintain File Links` dialog for *Customer Owned Units* (slide 24) and the Employees deck shows one
per employee, but **no slide shows one for a Unit**. Whether FCC has one is not answered by this
deck.

**Parts (slide 8).** **Activity · Part No · Description · Quantity · Unit Measure** (`Each`
throughout). Parts are filed under repair-category activities: *500 Hour Service / Lower · Air
Conditioner / Heater / Ventalation Repair · Brake System Repair / Replace · Cab (Internal) Repair /
Replace · Drivetrain Repair / Replace · Electrical System Repair / Replace · Engine Repair /
Replace · Glass / Window Repair / Replace · Micellaneous Repairs · Outrigger / Jacking System
Repair / Replace · Steering System Repair / Replace · Suspension Repair / Replace.* `10001` has
roughly thirty rows with manufacturer part numbers — a per-unit parts list. Row data not copied.

**Meter (slide 9 — the Samsara annotation and the fuel-app ask).** Header: **Lower GPS**
dropdown = `Samsara`, **Asset Id** = a 15-digit provider id. Grid (two-row header): **Date ·
Hours/Lower · Miles/KM · Source · Source Details · User ID** / **Job No · E-Ticket · Work Order ·
Location(GPS)/Comments.** *Source* values seen: `NexGen` (details `Work Orders`, `Maintain
Units`) and `Atom` (details `Work Order`). Work orders are referenced as `FL-#####` (`FL` is the
FLEET department code). Every visible row carries a User ID and a NexGen/Atom source; **no row is
sourced from Samsara** even though the unit is linked to it. There is **no Hours/Upper column** on
this tab.

- This is what *"Only lower engines are tracked by Samsara"* looks like in the data: the link
  is `Lower GPS` only, and the `UpperGPS` / `LowerGPS` columns of the raw table are **telematics
  provider selectors**, with `LowerGPSID` the provider's asset id. (`Telematics Provider` is a
  Maintain-menu lookup — visible on slide 34 of the Employees deck.)
- *"Live updates from Samsara"* is the annotation; the history shows manual and e-ticket entries
  only. The deck does not show a Samsara-sourced reading.

**Checklist (slide 10).** **Name · Section · Signature Required ☑ · Status**, with a task
sub-grid **Task · Deficiency Priority · Require Comments ☑ · Status**. *Section* is one of four
e-ticket phases: **Before Leaving Yard/Before Starting · After Arriving Job Site/After Starting ·
Before Leaving Job Site/Before Stop Time · After Arrived Yard/After Stop Time.** `10001` has nine
checklist rows — *Build Up/Breakdown Time Stamps · Crane 30 Check List · Crane Pre-Trip Inspection
· Post-Trip Inspection · Rigging Inspection · Time Stamps* (in two sections) *· Work Through
Lunch* (in two sections) — of which **only two are Active: Crane Pre-Trip Inspection (Before
Leaving Yard, signature required) and Work Through Lunch (Before Leaving Job Site, signature
required).** Example tasks: *Hook Time (Start Time and End Time …)*, *Break Down Time*.

**Checklist History (slides 11–12).** **Name · Ticket · Signature Required · Completed By ·
Completed Date · Status · File Links**, filtered by View / Display All. *Status* values: **Completed
· In Process · Completed With Deficiency.** Selecting a row shows its **Checkpoints · Completed ·
Deficiency · Deficiency Priority · N/A** grid. The Crane Pre-Trip Inspection has **17 checkpoints**:
Load Line/Hook/Sheaves · Straps/Shackles/Tag Line/Air Port Flag/Safety Chains/Rope · Spill and
Clean Kits/Cones/Wheel Chalks/Fire Extinguisher · Crane Annual and Quad Certification Stickers ·
Head Lights/Running Lights/Auxiliary Lights · Warning Labels · Coolant Level · Engine Oil · Belts
and Pulleys · Seat Belts · Tire and Lugnuts · Mud Flats · Windows and Mirrors · Brake Operation ·
Compliance: Registration/Tags/Annual Permits/Operating Manual/Load [charts — cut off] · Annual
Permits · Additional Comments. (The 17 agrees with
[field-ops/e-ticket-worked-example.md](../field-ops/e-ticket-worked-example.md).) Slide 12's
`Maintain File Links – Unit Adhoc Checklist` dialog (File Name · Created By · Modified By · Created
Date · Modified Date) attaches files to one completed checklist.

- This tab is the **4.1-million-row `FMS_JOB_UNIT_CHECK_LIST`** of the units page §8 made
  visible: one row per checkpoint per ticket per unit, with a deficiency flag each.

**Components (slide 13).** **Component Code · Description · Category · Company/Owner · Make ·
Model** — empty, consistent with `FMS_UNIT_COMPONENTS` having no rows.

### Components & Tools (slides 14–17)

Header: **Sched Type · Resource Type · Resources · View · Status.** Tabs: **Main · Buy/Sell Info ·
Addtl Info · Scan Log · Checklist History.** Shown as a blank form. Main: Resource Code ·
**Category** (dropdown, `Component`) · Accountability Type · Accountability Level · Description ·
Company/Owner · Dept (**defaults `OPERATED & MAINTAINED`**) · Yard/Location (`Main Yard`) · Schedule
Type · Resource Type · Assigned Unit Code · Unit Description · Unit Manufacturer · Storage Location ·
Alias · Make/Manufacturer · Model · In-Service Date; right: Status in Fleet · Company Tag · Bar Code
· Comments · **Image/QR** — an image slot (*"Max file size: 2 MB"*, View / Add) beside a QR panel
with a **Generate** button · Maintenance Required ☐ · Serial Number. Buy/Sell adds
**Purchased-with Unit** and a *Historical Info* block (As Of Date · Revenue · Labor Expense ·
Parts Expense). **Scan Log**: Time Stamp · Source · Source Details · Location · **Geofence** ·
Scanned By. Checklist History has the Units shape plus a *Ticket ID* column.

- **The component record has a picture and a QR code; the unit record has neither.** The
  `*** Profile Pictures for Asset ***` ask on slide 2 is for parity with what Components & Tools
  already has. The 2 MB limit is FCC's, not a requirement.
- `Accountability Type` / `Accountability Level` are dropdowns whose lookup (slide 35) is empty —
  the mechanism is unused.

### Ad-hoc Checklists (slides 18–19)

A newer, web-styled screen (breadcrumb *Maintain > Resources > Ad-hoc Checklists*). Left tree:
**Components · E-ticket insert – Job Checklist → *Work Through Lunch Authorization* · E-ticket
insert – Unit Checklist.** Fields: Name · **Checklist Type** (dropdown, `E-ticket insert - Job
Checklist`) · Status · **Signature Required** ☑ · **Eligible to Email** ☑ · a *Checkpoints* grid.
The single configured checkpoint is the authorisation sentence itself: *"By signing this the
customer is authorizing the crew to work through their required lunch and approving the charges
stated below."* — the same checklist
[field-ops/e-ticket-worked-example.md](../field-ops/e-ticket-worked-example.md) sees on a ticket.

### Customer Owned Units (slides 20–24)

Keyed by **Serial Number/VIN**, not a unit code; header *View*. Tabs: **Main · Activities ·
Comments · Parts · Meter.** Main: Serial Number/VIN · Description · **Customer** (lookup) · Yard ·
Model Year · Capacity + U/M · Vehicle Make / Model · Upper and Lower Engine Make / Model; right:
Status · Transmission Make / Model · Fuel Type · Attachments · Accessories · Tires Type · **Tire
Size Front · Tire Size Back** · Drive/Axle Type; the same *Current Hours* / *Current Miles/KM*
booleans as Units; a read-only *Customer Information* block (name, code, address, phone) and a
**NEW CUSTOMER** button. Meter: **Date · Hours/Lower · Hours/Upper · Miles/KM · Job No · Work Order
· Location/Comments.** Slide 24's `Maintain File Links – Customer Owned Unit` (File Name · Comments
· Created By · Modified By · Created / Modified Date) is a **unit-level** attachment dialog — the
shape slide 7's annotation asks for on TCG's own units. The example is a customer-owned Link-Belt
truck crane; the customer code shown is in a `AAA000` style (three letters, three digits). This is
`FMS_CUSTOMER_UNITS` (79 rows).

### Resource Types (slides 25–28)

Header **View · Status**; tabs **Main · Job Type/Yard · Unit/People · Estimate.** Main grid:
**Description · Additional Info · Target Hours/Month · Schedule Type · Category (`Unit`) · Status.**
Visible rows: the trailer set (*Flat Bed Trailer · Lowboy Trailer · Op Load · Operator Load ·
Stretch Deck · Support Load · Support Load 1–4*), *Travel Permit* and **Travel Permit – 120 Ton and
above** (schedule type Travel Permit), the truck set (*Flat Bed Truck · Parts Truck · Personal Car ·
Pilot Truck · Sales Truck · Service Truck · Yard Truck* — only Yard Truck carries a 160 target),
**Spreader Bar under schedule type `Yard`**, then the crane ladder from *22 Ton Boom Truck* upward
at 160 (200 on the 30 Ton Self Loader). **Support Load stops at 4** — the screenshot predates the
September 2026 additions of 5–10 recorded in
[fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §6.

For *120 Ton Hydraulic Truck Crane*: **Job Type/Yard** = `Hourly w/ Mob` / All Yards and `Hourly` /
All Yards; **Unit/People** (Hourly w/ Mob) = Unit/People `Tractor` → Type `Tractor - Semi`, `Trailer`
→ `Operator Load`, plus Comments. **Estimate** (Hourly w/ Mob, All Yards): **Billing Code · Quantity
· Unit of Measure · Comments · Sub-Item ☑.** The shape: three top-level lines with Quantity `1.00
Each` and Sub-Item unticked — **Mobilization · De-Mobilization · Fuel & Insurance Surcharge** — and
everything else at Quantity `0.00` as sub-items beneath them: *120 Ton Crane* (Hours; comment
"Travel In and Build up" under Mob, "Travel out and Break Down" under De-Mob) · *Operator Load*
(Hours) · *Travel Permit – 75 Ton and above* (Each) · *Travel Permit with Runner Required* (Each) ·
*Crew Time* (Hours; "Stand by Time" / "Curfew Stand By Time") · *Short Subsistence* (**Days**) ·
*Price Adjustment* (Each) · *Crew Overtime* (Hours) · *Crew Double Time* (Hours); under the
surcharge, *120 Ton Crane* (Hours) and *Operator Load* (Hours, "5 hour minimum with 8 hour…"). The
estimate content belongs to
[quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md);
recorded here only as the screen's shape.

### The nine lookups (slides 29–38)

- **Schedule Types** (29): **Code · Schedule Type · Schedule ☑ · Category (`Unit`) · Status.** 23
  active rows; **LP, SP and TP are the three with Schedule unticked** — confirms the units page §4
  exactly.
- **Unit Down Reasons** (30): **`D` Down · `MJR` Major Repair · `MR` Minor Repair · `PM`
  Preventative Maintenance · `S` Safety** — the five rows of `FMS_UNIT_DOWN_REASON`.
- **Unit Checklists** (31): **Name · Eligible to E-Mail ☑ · Status**, 14 rows = `FMS_UNIT_CHECK_LIST`:
  *AT – Tractors Pre-Trip Inspections · Build Up/Breakdown Time Stamps · Crane 30 Check List · Crane
  Pre-Trip Inspection · CWT and Flatbed Trailers Pre-Trip Inspection · Post-Trip Inspection* (not
  e-mail eligible) *· Pre-Trip Inspection* (**Inactive**) *· Rigging Inspection · Small Truck 30 Day
  Checklist · St-Stakebeds and UT Pre-Trip Inspections · Time Stamps · Tractor 30 Day Check List ·
  Trailer 30 Day Check List · Work Through Lunch.* The convention: one checklist per equipment
  family (AT, CWT/flatbed, stakebed/UT, tractor, trailer, small truck, crane) crossed with cadence
  (pre-trip vs 30-day).
- **Master Activities List** (32–34): tabs **Main · Yard Restrictions**. Columns: **Activity Code ·
  Description · Prev Maint ☑ · Maintenance Every · Maintenance Period** (with an *or* second
  interval) **· Activity/Certification** (dropdown: `Activity` | `Certification`) **· Certification
  Type** (`General`) **· Status**, and on the second row **Do not Prompt when Certificate is
  Expired ☐ · Standard Time · Price · Item Tax Code.** Two code styles coexist: **four-digit numeric
  for repair/labour activities** (`4056` Travel Time · `4057` Undercarriage Repair / Replace · `4058`
  Weld Shop Repairs · `4059` Wire Rope Cable Repair / Replace · `4060` Emissions) and **mnemonic
  for recurring compliance**: `ACA` Annual Crane Certification (12 Months, type
  **Certification**) · `ANNINS` Annual Crane Inspection (12 Months) · `BOOM` Boom Grease (6 Months)
  · `DECK` Deck Repair · `QUAD` Quadrennial Inspection (48 Months) · `REG` Registration (DMV) (12
  Months) · `RG` Rigging · `SHOP` Regular Shop Tasks · `SMG` Smog (24 Months) · `TRAILER REGISTR`
  Trailer Registration (60 Months) · `TRK SRV` 500 Hr Tractor Service (500 Hours/Lo). *Yard
  Restrictions*: **"Any Yard Listed will not Apply to this Yard"** — Yard · Applies to this Yard(s)
  · Comments. **So FCC models unit compliance (annual certification, quadrennial, DMV registration,
  smog) as interval-bearing activities of type Certification**, tracked last/next on each unit's
  Activities tab; a certificate can be flagged not to prompt when expired.
- **Accountability Levels** (35): **Accountability Level · Status** — empty.
- **Fuel Types** (36): **DEF · DIESEL · GASOLINE**, all Active.
- **Unit Capacity U/M** (37): **`C` CFM · `F` Feet · `N` None · `P` Pound · `T` Ton** — **five
  rows.** ⚠️ This contradicts [fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §4,
  which records the July `UNIT_MEASURES` sheet as four rows with *"Ton"* having no lookup row and
  warns against building an enum from it. The screen shows `T = Ton` exists, and the inventory's
  5-row count for `FMS_UNIT_MEASURES` (§8 there) agrees. **The July extract is one row short; the
  domain is C/F/N/P/T.**
- **Unit Location History** (38): a Unit Code lookup with *View*; a header row **Unit Code ·
  Description · Vehicle Make · Model · Serial Number · Yard · Purchase Date · Date Sold**, and a
  history grid **Yard · Start Date · End Date · Comments** under the instruction *"Enter Transfer
  Date in End Date"*. Empty for the example — yard transfers are not being recorded here. The
  example unit is **`26503.1` — "265 Ton Support Load"**, Vehicle Make `CHASS`.

**Unit-code convention the examples suggest, not stated anywhere in the deck:** crane codes read as
tonnage followed by a two-digit sequence — `10001` (100 t, #01), `26502`/`26503` (265 t, #02/#03),
`20001` (200 t, #01), `4005` (40 t, #05) — and **a crane's support load is the crane's code with a
`.1` suffix** (`26503.1`). Three examples support it; nothing confirms it as a rule, and the import
template allows any 15-character code.

### Where a screenshot contradicts an annotation or this page

| Slide | Annotation says | Screen shows |
| --- | --- | --- |
| 2 | *GVWR* is an **added** field | A `GVW` box already exists on Main, empty |
| 3 | add *Depreciation* under loan details | No depreciation field on any tab shown, though `FMS_UNITS` has the columns |
| 7 | *"documents uploaded to each Asset"* | The dialog is per **unit activity**; no unit-level file-links dialog appears for Units (one does for Customer Owned Units) |
| 9 | *"Live updates from Samsara"* | Lower GPS is linked to Samsara, but every meter row is sourced `NexGen` or `Atom` with a user id |
| §5 table above | axle count / weight per axle / tyre size absent from the deck | The **Axles** tab has exactly those columns, empty on `10001` |
| §5 table above | man-basket attachment has *"no FCC column"* | `AdditionalInfo1` is renamed **`Manbasket #`** — a column, dropped by the migration |
| units page §4 | `Ton` has no row in `FMS_UNIT_MEASURES` | Lookup screen shows `T = Ton` as the fifth row |

Nothing was unreadable; two screenshots are cropped (the Meter and Activities grids scroll) and one
checkpoint label is cut off mid-word.

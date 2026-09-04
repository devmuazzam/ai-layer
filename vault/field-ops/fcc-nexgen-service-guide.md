---
title: Where a field deficiency goes — the FCC NexGen Service guide
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/Service Guide v.2.0.docx (text + its 31 embedded screenshots, read 2026-09-04)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/assets, module/field-ops, module/vendors-agencies, kind/reference, inspections, certifications, scheduling, yards, purchase-orders, pricing]
entities: []
---

# Where a field deficiency goes — the FCC NexGen Service guide

**What this is.** Fleet Cost & Care's own **NexGen Service User Guide**, v2.0 "2nd Draft",
delivered to TCG in a `OneDrive_2025-10-29` folder. 35 pages on the maintenance side of NexGen:
maintaining units, activities and action lists, parts, work orders, and unit down-time.

**Why it is filed under field-ops.** It is the **other end of the deficiency**. The e-ticket guide
says a deficiency ticked on a unit checklist *"will be passed to NexGen and can be managed in the
`Enter > Work Orders from Deficiencies` screen"* — this guide is what that screen leads into. It
also defines **unit down-time**, which is what `FR-FOP-024 Downtime Management` (FOP-002) is about,
and **certifications as unit activities**, which is what the crane pre-trip's
*"Crane Annual and Quad Certification Stickers"* row is checking in the field.

> **Legacy behaviour, vendor-generic, not a requirement.** Same caveat as
> [fcc-e-ticket-and-atom-guides.md](fcc-e-ticket-and-atom-guides.md). This is also a **draft**: five
> of its sections — *How to Complete a Work Order in NexGen*, *Work Order Reports*, *How to Manage
> Open Work Orders*, the *Potential Warranty* FAQ — are literally the placeholder `TBP`. FCC never
> finished it.
>
> **This page is mostly `module/assets` material and is filed here only because field-ops owned the
> source in the 2026-09-04 ingest.** If `assets/` grows an FCC service page, this belongs there.

---

## 1. Activities — the model behind unit certifications and PM

> *"Activities are used to track specific maintenance and repair related functions. These activities
> usually coincide with manufacturer recommendations or regulatory guidance. The information entered
> on this tab is used on work orders, quotes for work orders, **unit certifications**, and others."*

**Two types**, and the distinction matters for the ERP's certification model:

| Type | Definition in the guide |
| --- | --- |
| **Certification** | *"a periodic evaluation of a unit"* |
| **Activity** | *"a service, usually with a set service interval"* |

Both hang off the unit. An activity carries an **Activity Code** (*"arbitrary, but should follow a
company approved convention"*), a **Description** used on the work order, a **Prev Maint** flag, a
**Standard Time**, an optional fixed billable **Price**, and a **Status**.

Two mechanisms worth naming:

- **Dual maintenance intervals.** *"In some cases, an activity may be based on hours or miles, or,
  miles or months; these can be entered in the Maintenance Every and Maintenance Period as well
  using the lower two fields to capture the alternate constraint."* So a PM interval is a pair of
  constraints, whichever comes first — not a single period.
- **Certification Type constrains who may do the work.** *"A Certification Type is used to constrain
  an Activity to an individual based on their role, or to a job, location, or general category. The
  **General** category is for internal reference only and does not apply restrictions on units if a
  service interval is passed."* This is a link from *unit* certification to *employee*
  qualification, in the legacy system, that nothing else in the vault describes.

**Action Lists** are the instruction set under an activity — an ordered list of free-text tasks
added with `Add Task`. They can be preset on the unit and auto-populate onto a work order, and extra
items may be added on the work order regardless.

## 2. Work orders

`Enter > Work Orders`. Tabs: **Main**, **Activities**, **Customer**, **Estimate**, **Parts**,
**Labor**, **Employees**, **PO**, **Act Billing** — *"any of the tabs may or may not be disabled"*,
controlled by **Profile Screen Settings** permissions.

- **Main** — Company and Status (`Open`) auto-populate; `Unit Owner` defaults to Company and may be
  set to Customer, in which case **`Unit Code` becomes `Serial Number/VIN`**. New units cannot be
  created from this window.
- **Activities** — *"Only activities that have been assigned to this unit will appear as selectable
  options."* Several activities per work order; each may carry an Action List.
- **Customer** — used for billable work orders; populated from the job number if one is on Main.
- **Estimate** — an estimate that can be turned into a **quote document** (via the File Links
  "lightning bolt" → `New Doc`) and emailed as PDF/CSV/XLS/HTML from the report viewer.

**Work Orders From Due PMs** (`Enter > Work Orders From Due PM's`) is a bulk generator: filter on
`Unit Owner`, `Company`, `Yard`, `Sched Type`, `Unit Type`, `Show PM's With`, and a **`Due In`**
parameter in **Days, Miles/KM and Hours — any or all at once**; the result lists every unit and
activity that matches and `OK` creates one work order per due service, optionally printing them.

## 3. Unit down-time — what `FR-FOP-024` is about in the current system

`Schedule > Unit Down Time`.

> *"Unit down time is used to identify when a unit is **not available for dispatching**. This could
> be due to preventative maintenance scheduling, mechanical failure, inspections, or anything that
> should prevent the unit from being committed to a job."*

A down-time record is: **Unit Code** (filterable by Schedule Type, Unit Type and yard), a
**Reason** — *"user-definable by a manager"* — a **Down Date/Time**, **Comments**, and an
**anticipated Up Date/Time**.

Note what this is *not*: it is a **unit availability block owned by the office**, keyed to
dispatchability. The FRD's `FR-FOP-024 Downtime Management` and `FR-FOP-030 Downtime and Delay
Capture` (FOP-001) are about a **field employee recording delay during a job**. The two use the same
word for different things, and no source in the vault reconciles them.

## 4. Attachments, and the Atom link

The **lightning bolt** icon is attachments, present on any window that allows them, in three states
(unavailable / available-empty / has-content). Two field-relevant facts:

- *"Attaching files to work orders can also come from an Atom device."*
- *"If a file should be viewable by an Atom user, check the **'Include On Unit'** checkbox. This will
  show the file link within a similar interface in Atom."*

So whether a field crew can see a document on their device is a per-file checkbox on the NexGen
side — the same mechanism the operator guide describes for site plans and permits under
**File Links**.

## 5. What else the guide covers, in outline

Not expanded here because it is squarely `assets/` and `vendors-agencies/` material, and the vault
already holds the unit data model from the FCC extracts
([assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md)):

`Maintaining Units` (Main / Buy-Sell Info / Addtl Info tabs) · `Unit Types` and `Schedule Types` ·
`Axles` · `Parts` and `Meter` on the unit · `Maintaining GPS` · `Warranty` ·
`Maintaining Parts` with Company, Price Points, Yard/Location, Price List, Alternate Vendor, Units,
Yard · `Parts Locations`, `Parts Manufacturers`, `Parts Kits`, `Parts Types`, `Parts Grouping` ·
`How to Create a Customer Owned Unit`.

## What the guide's screenshots show — read 2026-09-04

*Source for this section: the 31 screenshots extracted from `Service Guide v.2.0.docx`
(`media/image8`–`image56`; the cover logo and toolbar icons were deduplicated or not extracted,
and `image57`–`image64` — the quote-generation FAQ — duplicate the Quotes guide's images).
Viewed 2026-09-04. Everything below is read off the images.*

**Where the pictures came from.** Two environments are visible. The maintenance screens (Units,
Activities, Parts, PM generator) are FCC's demo database (*Fleet Cost & Care*, *Atlanta Yard*).
The **Work Orders** screens were captured through a TeamViewer session titled *"TNT - Live
Server"* / *"TNT - Test Server"* with the company field reading *TNT/Southway Crane & Rigging* —
i.e. on another FCC customer's system in May 2017, not on TCG's. The full-screen capture of the
main window (`image32`) also shows a **Favorites side-bar** — *Job Schedule, Customers, Quotes for
Jobs, Invoice Register, Invoices, Print Invoices - Plain Paper, Jobs Unbilled Report, Schedule
Jobs, Invoice History, Recurring Invoices, Recurring Billings, Profit/Revenue Summary Report, Job
Labor Detail, Work Orders, Labor for Payroll Pre-Processor* — which is one user's shortcut list,
not a feature inventory.

### Maintenance menus

`Maintain` (`image51`): **Units ▸** (*Units, Activities, Customer Owned Units, Unit Types, Unit
Schedule Types, Unit Fuel Types, Unit Capacity U/M, Location History, Warranty Category, Down
Reason*), **Parts ▸, Employees ▸, Customers ▸, Codes ▸, Sales Tax ▸, Footers ▸, Terms & Conditions ▸,
Tools ▸, Company ▸**, then *Chk\Taken By, Job Types, Line Items, Quote Status, Classifications,
Class IDs, States, WO Reason, WO Priorities, Units of Measure, Terms, Documents, Vendors,
Salespeople, Field Names, Recurring Billings, Job Check List, Completed E-Ticket Status, Export
Status, Deficiency Degree/Priority*. So `Down Reason`, `WO Reason`, `WO Priorities` and
`Deficiency Degree/Priority` are each **user-maintained code lists** — the "user-definable by a
manager" reason list in §3 is `Maintain > Units > Down Reason`.

`Enter` (`image32`, `image45`): the same list recorded in
[../dispatch/fcc-nexgen-dispatch-guide.md](../dispatch/fcc-nexgen-dispatch-guide.md) → *Menus*.
Two builds are visible: the 2017 one carries **`Work Order From Deficiencies`** and
**`Deficiencies Reported As No Repair Needed`**; an older capture (`image45`) lacks both and has
`Job Parts Shipment` instead. **Neither deficiency screen itself is pictured anywhere in the
guide** — only the menu entries.

### Units window (`Maintain > Units > Units`)

Header filters: `Sched Type` (`All Sched Types`), `Unit Type` (`All Unit Types`), `Units`
(search), `View` (`All Yards`), `Status` (`Active`). Tabs: **Main · Buy/Sell Info · Addtl Info ·
Unit Types · Axles · Activities · Parts · Meter · Warranty** (`image12`).

**Main** fields (`image12`): `Unit Code`, `Description`, `Company/Owner`, `Dept`, `Yard/Location`,
`Schedule Type`, `Unit Type`, `Model Year`, `Capacity`, `Needs PickUp` ☐, **`Check Schedule
Overlap` ☑** (the per-unit conflict-check switch the dispatch page §4 mentions), `Vehicle Make`,
`Vehicle Model`; **Upper Engine**, **Lower Engine** and **Transmission** each with Make / Model /
Serial Number; `Status in Fleet` (`Active`); **Current Hours** — `Has Upper Meter` ☑, `Hours/Upper`
+ `As of`, `Has Lower Meter` ☑, `Hours/Lower` + `As of`; **Current Miles/KM** — `Has Odometer` ☑,
`Miles/KM` (unit `Miles`) + `As of`; `License` / `State` / `Exp`; `Serial Number/VIN`; `Tires
Type`; `Drive/Axle type`; `Fuel Type`; `GVW`; `Vehicle Width / Height / Length / Gage` in Ft + In;
`Jib Length` (Ft/In); `Main Boom Length`; `Bar Code`.

**Buy/Sell Info** (`image14`): *Purchase Info* — `Purchase Date`, `Purchase Price`, `Start
Hr/Miles`, `Purchase Type`; *Sale Info* — `Date Sold`, `Sale Price`, `Date Priced`, `Sold
Salesperson`; `Current Value`, `Insurance Value`, `Sold To/Inactive Information`; **Rates** —
`Allocated & Rental Invoicing Hourly Cost`, `T&M Invoicing Hourly Rate`, **`Monthly Target`**,
`Monthly Payment Amount`; **Expenses** — `As Of Date`, `Revenue`, `Labor Expense`, `Parts Expense`.
The `Monthly Target` is what the *Equipment Utilization* report's `% of Target` is measured
against ([../admin/fcc-nexgen-reporting-catalogue.md](../admin/fcc-nexgen-reporting-catalogue.md)).

**Activities tab** (`image20`): buttons `Hide Action List · Add Task · Del Task`; grid header row
1 `Activity · Prev Maint ☐ · Maint Every · Maint Period · Last Date · Last Miles/KM · Last Hrs/Up ·
Last Hrs/Low · Price · Status`, row 2 `Comments · Maint Every · Maint Period · Next Date · Next
Miles/KM · Next Hrs/Up · Next Hrs/Low · Standard Time`. Sample: *250 Hour Service* every `250
Hours/Lo` **or** `3 Months`, last at 350.0 h on 06/23/2017 → next 600.0 h / 09/23/2017 — the dual
interval of §1, with the second constraint on the second row. The action-list **Task** grid below
has up/down reorder arrows; a task opens in a **Comment Entry** rich-text editor (font, size,
bold/italic/underline, indent; `OK · Cancel · Print`) (`image23`), so an action item can be a
multi-line checklist (*"( ) Check Brake Lining thickness (must be greater than 3mm)"*).

**Parts tab** (`image24`): `Activity · Part No (search) · Description · Quantity · Unit Measure` —
parts pre-assigned per activity (sample: filters for *250 Hour Service / Lower*).

**Meter tab** (`image25`): `Upper GPS` and `Lower GPS` dropdowns above a history grid `Date ·
Hours/Lower · Miles/KM · Job No · Work Order · Location/Comments` (this unit shows no
`Hours/Upper` column). Rows reference either a job number or a work order, so **meter readings
come from both jobs and work orders**.

**GPS Information** (`Maintain > GPS`, `image26`): `Interface Name · User Name · Password ·
Primary ☐ · File Name · Status`; interface names listed — *Fleet Complete, Fleet Matics, Indus
Track, QualComm*. `[credential fields present in the screenshot — passwords are masked; user names
deliberately not copied]`

### Unit Types and Schedule Types

*Unit Types* (`image15`): tabs **`Main · Job Type · Yard · Unit/People · Estimate`**; Main grid
`Description · Addtional Info · Target Hours/Month · Schedule Type · Status`, with **176** as the
typical `Target Hours/Month` (one row 173, one 160). `Unit/People` and `Estimate` are the Unit Type
Defaults; the `Job Type` and `Yard` tabs are not opened in any screenshot — see the note in the
dispatch page §9.

*Unit Schedule Types* (`image16`): `Code · Schedule Type · Schedule ☐ · Sage Equipment Type ·
Status`. Demo codes: `O` Accessories, `A` Aerial, `ATT` Attachment, `CM` Crane - Mobile,
Hydraulic, `C` Crane - New descr, `CU` Customer, `F` ForkLift, `G` Garbage Truck (Test 5648), `M`
Misc, `K` Mobilization Kits, `N` None, `RC` Regulatory Compliances, `L` Trailer, `T` Truck — with
`Schedule` unticked only for `None` and `Regulatory Compliances`. The `Sage Equipment Type`
column is empty throughout; it names a Sage mapping the guide never discusses.

*Activities master* (`Maintain > Units > Activities`, `image18`): `Activity Code · Description ·
Prev Maint ☐ · Maintenance Every · Maintenance Period · Type · Certification Type · Status`, with a
second row `or Maintenance Every · Maintenance Period · Standard Time · Price`. Sample: `0000
Annual Crane Inspection`, every 365 Days, `Type = Certification`, `Certification Type = WO
Employ…`, 8.00 Hrs, $500.00. Confirms §1's field list and shows `Type` and `Certification Type`
as dropdown columns.

### Parts

*Parts* window tabs: **Main · Company · Price Points · Yard/Location · Price List · Alternate
Vendor · Units · Yard** (`image27`). Main: `Part No`, `Description`, `Manufacturer` (`New`),
`Comments`, `UOM`, `Kit` ☐, `Part Type`, `Previous Part No`, `Obsoleted By`, `Price By Weight` ☐.
**Company** tab (`image29`): grid `Company · Primary Vendor · Vendor Part · Retail Price · On
Hand`; fields `Vendor`, `Vendor Part`, `Barcode`, `Grouping`, `Status`, `Discountable` ☑, `Taxable`
☑, `Track Quantity` ☑, `Serialized` ☐, `Track Warranty` ☐, `Purch Disc %`; **GL Accounts** —
`Sales`, `COGS`, `Inventory`; a **New / Used** pair of columns for `Retail Price`, `Avg Cost`,
`Standard Cost`, `On Order`, `On Hand`; **Last Purchased** — `Vendor`, `Quantity`, `Cost`; audit
fields. *Parts Locations* (`image30`) is a `Location · Status` list of bin codes (`1-A-1`, `A-1-3`
…); *Parts Manufacturers* (`image31`) is `Manufacturer · Status` (Active/Inactive).

### Work Orders (`Enter > Work Orders`)

Header: `Work Order` (search) and a **`View`** filter (`Open`). Tabs as in §2. Toolbar changes per
tab: `New WO · Add Activity · Del WO · Del Activity · Copy WO · Refresh · Save Layout · Save · Print
· Close` on Activities; `Add Est · Del Est · Convert To PO Req` on Estimate; `Add Emp · Del Emp` on
Employees.

**Main** (`image33`): `Work Order` (`AUTO`), `Company`, `Unit Owner` (`Company`), `Unit Code`,
`Make`, `Model`, `Serial Number/VIN`, `Date Issued` (defaults to today), `Status` (`Open`), `Work
Finished`, `Date Closed`; `Yard`, `Dept` (`Crane`), `Job` (search), **`Priority`**, **`Reason`**,
`Terms & Conditions`, `Unit Hrs/Up`, `Unit Hrs/Lo`, `Unit Mi/KM` each with `As of`; `Description
Of Work`, `Repair Comments`; totals **`Labor Hours · Labor Amount · Parts Amount · Contract Labor
· WO Total`**.

**Activities** (`image35`, `image36`): `Show/Hide Action List`, `Add Action Item`, `Del Action
Item`; grid `Activity · Potential Warranty ☐ · Comments · Work Finished · Standard Time · Actual
Time`. Beneath it the **Action List** grid: **`Action List · Completed ☐ · N/A ☐ · Deficiency ☐ ·
Deficiency Priority · By · Date` / `Comments`**. This is the only place a deficiency is visible in
the guide's images: **an action item on a work order can be ticked as a deficiency and given a
priority** (from `Maintain > Deficiency Degree/Priority`). Whether this is the same record a
field checklist deficiency creates via *Work Order From Deficiencies* is not shown.

**Customer** (`image37`): *Bill To Information* — `Customer` (`New` + search), `Bill To`
(`Corporate Address`), `PO No`, address/phone/fax, `Report To` and `Ordered By` with WP/CP/E-Mail;
a markup selector reading **`%Above Cost`** with an amount; `Sales Person`; `Footer`. *Jobsite
Information* — `Job site` (`New`), address, phone, `Directions`. Audit fields.

**Estimate** (`image41`): grid `Est. Date · Part No · Description · Qty · Price · Total`; detail
**`Parts/Labor`** selector (`Parts`), `Est. Date`, `Part No` (`New` + search), `Description`, `Qty`,
`Unit Meas` (`Each`), `Price`, `Total`, `Comments`; `Unit Code` shown; `Est. Total`. The toolbar's
**`Convert To PO Req`** turns an estimate line into a PO requisition — the text mentions only the
quote document.

**Employees** (`image44`): buttons `Show Hours · Show Tickets · Show Status`; grid `Employee Type
· Employee · Date Start · Date End · Time Start · Time End` / `Priority · Activity (All Activities)
· Comments`. Dates default to today. The **Parts, Labor, PO and Act Billing tabs are not pictured.**

**File links – Work Order** (`image8`): `File Name / Comments · Include On Unit ☐ · Created By /
Created Date · Modified By / Modified Date` — the checkbox §4 describes.

### Work Orders From Due PM's (`image46`, `image48`)

Filters: `Unit Owner` (`Company Owned Units`), `Company`, `Yard`, `Sched Type`, `Unit Type`,
**`Show PM's With`** (`No Open WO's` / `All`), **`Due In Next [ ] Days or [ ] Miles/KM or [ ]
Hours`**, `View`. Result grid: `Unit Code · Activity · Past Due · Coming Due In · Open Work Order`,
with a second `or` row per activity for the alternate constraint (sample: *100 hr. serv. upper* —
coming due in `100 Hours` **or** past due `45 Days`). Buttons `OK · Close · Select All · Deselect
All`. The `Open Work Order` column shows an existing WO number, which is what `Show PM's With = No
Open WO's` filters out.

### Customer Owned Units (`image52`–`image54`)

Keyed by **`Serial Number/VIN`** (search) with a `View` filter (`All` / `Active`). Tabs **Main ·
Activities · Comments**. Main: `Serial Number/VIN`, `Description`, `Customer` (search), `Model
Year`, `Capacity` + unit, `Vehicle Make/Model`; a read-only *Customer Information* block; `Status`,
Upper/Lower Engine Make and Model, Transmission Make/Model, `Fuel Type`, `Attachments`,
`Accesories`, `Tires Type`, `Tire Size Front/Back`, `Drive/Axle Type`, `Hours/Upper`,
`Hours/Lower`, `Miles/KM` each with `As of`. The Activities tab is the same grid as a company
unit's. This is the screen behind §2's *"`Unit Code` becomes `Serial Number/VIN`"*.

### Schedule Unit Down Time (`image55`, `image56`)

`Schedule > Unit Down Time` opens a window with filters `Schedule Type · Unit Type · Unit Code
(search) · View (All Yards)` and a read-only header `Unit Code · Capacity · Description · Unit Type
· Yard`. **The grid beneath is empty in the only screenshot**, so the `Reason`, down/up date-time
and `Comments` columns listed in §3 are not visible in any image.

### Where the images differ from the text above

- §2 says the Estimate tab feeds a quote document; the screenshot adds a **`Parts/Labor`** line
  type and **`Convert To PO Req`**.
- §2's totals: the Main tab carries a **`Contract Labor`** total alongside labor and parts.
- The action-list grid's **`Deficiency` / `Deficiency Priority` / `By` / `Date`** columns are not
  in the text at all — they are the closest the guide comes to showing where a deficiency lives.
- Nothing in the images contradicts the text; the gaps are the five `TBP` sections, the two
  deficiency screens, and the Parts/Labor/PO/Act Billing tabs, none of which are pictured.

## Source

`1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/Service Guide v.2.0.docx` — 2.6 MB,
pandoc gfm. ~60 screenshots dropped in conversion, of which 31 were extracted and read on
2026-09-04 (see *What the guide's screenshots show*); several procedures are screenshot-led and
only their numbered steps survive in the text. Five sections are unwritten placeholders (`TBP`) in the source itself.

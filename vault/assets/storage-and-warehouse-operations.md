---
title: Storage and warehouse operations — FCC storage tickets and TCG's own SOPs
source: shared-folder/Project-Repository-2026-09-04 — 1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/Storage User Guide.pdf, 1.0.2_FCC-RESOURCES-GUIDES/FCC-IMPORT-Templates/Storage Data v.9.25_TEMPLATE.xlsx, 1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/TCG_VE_{Receiving,Inventory_Audit,Shipping}_2025-10-09.xlsx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/assets, module/accounting, module/projects-jobs, module/field-ops, kind/sop, yards, invoicing, pricing, inspections, reporting, safety]
entities: []
---

# Storage and warehouse operations

**What this is.** TCG stores customers' equipment in its warehouse and yard, bills them monthly
for it, and runs three written SOPs around it. **The vault held nothing on this before.** Four
sources in the 2026-09-04 drop cover it from two directions: how the legacy system (FCC / NexGen
FMS) models and invoices storage, and how TCG's own warehouse staff actually do the work today.

Storage is not a side note. In FCC it is a **schedule type** (`ST` Storage) and a **department**
(`ST` STORAGE), it has its own resource type (`Handling-Loading & Off Loading`), its own job tab,
its own invoicing run and its own report — see
[fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md).

> Nothing here has been adjudicated for the ERP. The FCC guide describes a product TCG is leaving;
> the SOPs describe manual work built around spreadsheets, and say so.

---

## 1. How FCC models storage

*Source: `Storage User Guide.pdf`, 12 pages, FCC/NexGen vendor documentation. Screens are
screenshots; only the text is transcribed.*

**A storage ticket hangs off a job.** *"Storage tickets are entered against a job and can be added
to an existing job, or a job can be created specifically to keep track of storage."* The tab is
hidden until an admin turns it on (`Admin → Set System Defaults → Job tab → Storage Visible`),
and every user must log out and back in for it to appear.

### Ticket fields

| Field | Notes from the guide |
| --- | --- |
| Ticket Number | alphanumeric, **max 10 characters**, **not auto-generated** — typed by hand per ticket |
| Item Description | free text; **appears on the invoice** |
| Status | dropdown |
| Location | from `Maintain → Company → Storage Location` |
| Unloaded By / Reloaded By | name(s) of the person or people |
| Date Received / Date Shipped | dates |
| Carrier In / Carrier Out | carrier used on arrival / departure |
| Unload Rate / Reload Rate / Monthly Rate | default from system settings; **overridable per ticket** |
| Length / Width / Height, each in ft **and** in | dimensions |
| Weight (lbs) | defaults from a system default weight; overridable |
| Comments | free text |
| Previous Bill Date | date of the most recent storage invoice; editable |

The import template's dropdown gives the **status vocabulary**: `Tentative` · `Confirmed` ·
`On Job` · `Finished` · `Complete` · `Canceled` · `Transfer` (§3).

### How the money is calculated

`Admin → Set System Defaults → Storage tab` holds the defaults, and **one** calculation method
applies system-wide:

| Setting | Meaning |
| --- | --- |
| **Calculate Amount By** | `Weight` = weight in tons · `Flat charge` = fixed rate added to each item · `Square feet` = length × width · `Cubic feet` = length × width × height |
| Rate | a dollar rate per the selected unit |
| Unload | charged when the shipment is received and unloaded |
| Reload | charged when the shipment is loaded and shipped out |
| Monthly | charged for each month the items are in storage |
| Default Weight | auto-populates the ticket's weight; overridable or clearable |
| **Free Days** | number of free days before storage billing begins |

Price = *(the chosen measure)* × *(the rate)*, per the guide's repeated phrasing. Three billing
codes must exist under `Maintain → Codes → Billing Codes`: **Storage Monthly Charge**, **Storage
Unload Charge**, **Storage Reload Charge**.

### Invoicing

`Enter → Invoices → Job Storage Invoices`: pick a yard and a date range; tickets whose
`Previous Bill Date` falls up to the end date appear; select some or all; **Generate Invoice**
produces **one invoice per job**, with all that job's tickets on it. `Previous Bill Date` is then
advanced automatically to **30 days from generation** and can be edited. The invoices are then
reviewed under `Enter → Invoices → Rental Invoices`, where the description defaults from the job's
*Description Of Work*.

### Three operational rules the guide states outright

1. **One charge per load, not per ticket.** *"If only one unload charge or reload charge should
   apply to a load and there are multiple tickets generated for one load, keep the unload or reload
   rate on one ticket and delete the unload or reload rates on the other tickets in that load."*
   Otherwise every ticket's charge lands on the invoice separately.
2. **Job dates must cover the storage duration.** If the job's end date precedes a storage invoice
   date, FCC pops a warning per affected ticket that must be acknowledged each time.
3. **Jobs are tied together by Project Number**, entered identically on
   `Schedule → Jobs → Parameters` — alphanumeric, max 20 characters, best copy-pasted. This is
   how a storage-only job is linked to the operational job it belongs to, and it drives
   consolidated and per-job P&L reporting.

Also: `Utilities → Transfer Job Storage Items` moves selected tickets from one job to another
wholesale. And `Reports → Jobs → Job Storage → Job Storage` runs by date range, filtered by
**all tickets / customer / job / job site / salesperson / yard**.

Copy/paste of a ticket is a documented workflow (Ctrl+A add, Ctrl+D delete, Ctrl+C copy,
Ctrl+V paste) — the copy duplicates everything including the ticket number, which must then be
changed by hand.

---

## 2. What the FCC data holds

From `__NexGenFMS_Inventory_20260702_0246.xlsx` (see
[fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §7):

| Table | Rows | Columns | Suggested disposition |
| --- | ---: | ---: | --- |
| `FMS_JOB_STORAGE` | 252 | 30 | Likely Migrate / Business Review |
| `FMS_STORAGE_LOCATION` | **3** | 7 | Business Review Needed |

Three storage locations exist in production. The FCC guide's `Location` dropdown is therefore a
three-value list, not a warehouse map — which does not match the granularity the SOPs work at
(§4, where units are tracked to "Inside Warehouse" against a geographic site).

---

## 3. The storage import template

*Source: `Storage Data v.9.25_TEMPLATE.xlsx` — 2 sheets, **blank**: 1,200 empty rows of validation
formulas plus a dropdown list. No data was supplied.*

Column contract for `Storage Information`, with the template's own required/optional notes:

| Column | Requirement |
| --- | --- |
| Customer's Job Number | **Required** — job number in NexGen |
| Customer Name | **Required** — customer name in NexGen |
| Ticket Number | **Required** — up to 15 characters *(note: the user guide says 10 — see below)* |
| Item Description | **Required** — up to 100 characters |
| Status | **Required** — from the dropdown |
| Location | Optional — a location from `Maintain > Company > Storage Location` |
| Unloaded By / Carrier In | Optional — up to 20 characters each |
| Date Received | **Required** — MM/DD/YYYY |
| Unload Rate | Optional — *"Enter if different than default rate"* |
| Reloaded By / Carrier Out | Optional — up to 20 characters each |
| Date Shipped | Optional — MM/DD/YYYY |
| Reload Rate | Optional — enter if different from default |
| Length (ft) / (in), Width (ft) / (in), Height (ft) / (in) | Optional, up to 7 digits — **length and width are *"required if monthly charge is calculated using square feet"*** |
| Weight (lbs) | Optional, up to 7 digits |
| Monthly Rate | Optional — enter if different from default |
| Comments | Optional |
| **Next Bill Date** | Optional — *"Enter next bill date or leave blank if not to be billed"* |

**Two things worth carrying:**

- **A ticket-number length conflict inside FCC's own documentation.** The user guide says *"up to a
  maximum of 10 characters, including spaces"*; the import template says *"up to 15 characters,
  including spaces"*. The drop does not say which is right.
- **Conditional requirement by pricing method.** Length and width become mandatory when the tenant
  bills by square feet. So the required-field set depends on a system setting — the only such
  dependency in any import template in this drop.

Dropdown list, verbatim and complete: `Tentative` · `Confirmed` · `On Job` · `Finished` ·
`Complete` · `Canceled` · `Transfer`.

---

## 4. What TCG actually does — three SOPs

*Source: `TCG_VE_Receiving_2025-10-09.xlsx`, `TCG_VE_Inventory_Audit_2025-10-09.xlsx`,
`TCG_VE_Shipping_2025-10-09.xlsx`. Each workbook has the same shape: a `GET_SCALABLE_NOTES` sheet
explaining the "Value Engine" method, a `SYMBOLS` legend, a `TCG_SOP_*` sheet with the written
procedure, and a `TCG_VE_*` sheet that is the process diagram — **the diagram is shapes, so only
its SOP-step callouts survived conversion**. All three are scoped "TCG or Loading Customers".*
The three files appear **twice** in the drop, at
`1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/` and
`TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/zzzOTHER/`. The copies are **not**
byte-identical (different MD5, and Inventory Audit differs by one byte in size) but their
**extracted text is identical line for line**, so the difference is workbook metadata, not
content. The `1.0.1_` copies are cited throughout.

> **The method itself** (`GET_SCALABLE_NOTES`, identical in all three): a Value Engine is a visual
> map of how the company creates and captures value, split into **Growth Engines** (acquiring
> customers), **Fulfillment Engines** — including *internal* ones for Accounting, HR and
> Production — and **Innovation Engines**. Mapping runs: identify the engines → define triggering
> and ending events → brainstorm the tasks between → stakeholder review → publish. This is the
> same framework behind every other `TCG_VE_*` and `*_Playbook` file in the drop.

### Receiving

**Roles:** Warehouse Manager (schedules, confirms equipment and crew, owns safety compliance) ·
Forklift/Crane Operators (inspect equipment, offload, follow rigging standards) · Spotters / Yard
Technician (assist, stage and label) · Warehouse Manager + Billing Team (record details, update
billing, communicate).

1. **Collect receiving information.** *"There are two types of customers"* — **Direct Customers**
   deal with the Storage Manager; **Salesperson Customers** are handled through the Salesperson.
   Either way an **appointment sheet** must be filled out before any delivery: customer and project
   name, size/dimensions/weight of units, **lifting method required (crane or forklift) and
   necessary rigging**, storage preference **inside or outside**, estimated storage duration, and
   special handling instructions.
2. **Schedule appointment.** Forklift offload: verify a working forklift, a certified operator and
   a spotter. Crane offload: verify correct crane size, certified operator and proper rigging.
   *"Ensure sufficient time is scheduled between offloads to prevent overlap or delays."*
3. **Forklift offload.** Pre-use forklift inspection (*"– Create Pre trip Form"*, a note added to
   the SOP) · inspect the unit and note pre-existing damage · **photos *and* videos of all sides** ·
   if damage is observed, **contact the customer for approval before proceeding** · offload and
   stage · more photos and videos once staged · record measurements, apply labels, enter into the
   billing spreadsheet · notify the customer with photos of the unit staged.
4. **Crane offload.** All of the above, plus: **review the lift plan** first, confirm rigging is
   available and inspected, and *"Get 2nd opinion on Rigging from Crane Super if Lift plan isn't
   available."*
5. **Documentation and billing entry** — *"Contact customer if lift plan is changed"*. Fill the
   receiving log (customer, project, date, dimensions, storage type, duration) · store photos and
   videos · complete the forklift or crane inspection checklist · add the units to the billing
   system via the Excel storage spreadsheet, per its `Legend` tab.
6. **Communication flow.** Text or email to confirm appointments and arrival times, routed either
   *Customer → Storage Manager* or *Customer → Salesperson → Storage Manager*.

### Inventory audit

**Purpose:** *"To verify accuracy of warehouse inventory records, identify discrepancies, and
ensure customers are properly billed and informed of their stored units."*

1. **Preparation.** Print the Excel inventory sheet **per customer**; confirm it matches the
   billing system (the workbook's `Legend` tab explains the colour coding).
2. **Manual audit.** Walk the yard/warehouse with the printout and tick each unit off. **Highlighter
   colours are the status vocabulary: yellow = located, no issues · pink = damaged · green = on the
   sheet but not found.** Anything found in the warehouse but *not* on the sheet is noted and goes
   under investigation to identify ownership. Photos and videos of all units.
3. **Discrepancy resolution.** *Missing units* — investigate, inform the customer, resolve.
   *Damaged units* — determine whether the damage was in-house or pre-existing; if in-house,
   question co-workers and **check cameras**; **notify ownership first**, who direct the customer
   conversation. *Units not on the checklist* — investigate ownership and contact the customer.
4. **Clean inventory report.** A **monthly customer storage sheet** sent to the customer: units
   currently in storage, changes (missing / damaged / added), and a billing summary.
5. **Documentation.** Signed and dated printed inventory sheets, audit notes, investigation
   reports, the monthly customer storage sheet, updated billing records.

**Handwritten notes on the SOP, carried over verbatim — these are the client's own open items:**
*"Come up with how"* (against missing units, and again against units not in the checklist) ·
*"Add to Shipping and Receiving"* (against damaged units) · *"Make this ASAP"* (against the clean
inventory report, whose section is marked *"still in progress and will be presented for approval
once finalized"*).

**Attachment #1** to this SOP is a sample inventory list with columns
`TCG # | Geo Location | CUSTOMER | PROJECT NAME | Yard Location | SQ FT` — a per-unit TCG number, a
geographic site (Signal Hill, Fresno, Trans HWY Canada), the customer, their project, "Inside
Warehouse", and square footage per unit. **The rows are live customer inventory and are not copied
here**; what matters structurally is that TCG already assigns its own **TCG #** to a customer's
stored unit and tracks **square feet per unit**, which is the measure FCC bills on.

### Shipping

**Scope:** everyone involved — warehouse staff, operators, spotters, admin — *"whether we're using
an outside carrier or handling it in-house with our own cranes and trucks."* Two paths:

**A. Customer storage only / outside trucking.** Confirm the right machinery and rigging ·
inspect equipment and rigging before use · check each unit for damage before loading, with photos
and/or videos · load safely · **photos before *and* after the driver secures the load** · if the
customer provided a **Bill of Lading, the driver signs it** · file records and remove the unit from
the billing system via the Excel storage sheet.

**B. Customer storage / in-house trucking and crane work.** Everything in A, plus: confirm
load-securing requirements (straps, chains) with the customer before final tie-down · **do not
remove the unit from the billing system until the job is confirmed complete** · **no BOL is
required for in-house trucking**.

**Documentation:** before/after photos or videos per unit, equipment inspection checklist, BOL if
applicable, billing system updates.

---

## 5. What these four sources say about each other

- **The billing system is a spreadsheet, not FCC.** All three SOPs route adding and removing units
  through *"the Excel storage spreadsheet"* and its `Legend` tab, with the Billing Team as
  gatekeeper for access. The FCC Storage tab exists and is documented; the SOPs never mention it.
  Whether TCG runs both, or the SOPs predate the FCC storage tab being switched on, is unstated.
- **Photos and videos live in OneDrive**, not in either system — *"All photos and videos are stored
  under the OneDrive system. If you do not have access, contact Billing or HR."* Repeated in
  Receiving and Inventory Audit.
- **Damage has an approval gate on the way in and an ownership gate on the way through.** The
  customer approves before an already-damaged unit is offloaded; ownership is told before the
  customer is told about in-house damage.
- **A stored unit is measured three ways** — dimensions (for square/cubic feet), weight (for the
  weight method), and square feet per unit on TCG's own sheet. Which one governs is a system
  default, set once for the whole tenant.
- Storage crosses four modules as the vault divides them: the ticket sits on a **job**, the rates
  and invoices are **accounting**, the yard and warehouse are **assets**, and the receiving and
  audit work is **field-ops**. It has no home of its own.

---

## 6. The flowcharts themselves — shape text read 2026-09-04

The three value-engine workbooks draw their process as **shapes**, not cells, so the cell dump
used above never saw the flow. The drawing XML was read on 2026-09-04. Each workbook has a
`SYMBOLS` legend sheet (start/end, task, data input/output, decision) and one flow sheet:

**`TCG_VE_Receiving`** (14 shapes): *Get Receiving Information* → *Make Appointment* → **Forklift
or Crane?** → *Forklift* → *Inspect Unit Before Unload* · or *Crane* → *Rigging / Crane Plan* →
*Check Availability* → **Inspect: pictures, video, documentation** → **Damaged?** → *Inform
Customer of Damage* → *Customer Approves Offload* → *Offload & Stage* → **MLP: measure, label,
put in system**.

**`TCG_VE_Shipping`** (11 shapes), two lanes: *Customer Storage Only* → *Receive Shipping
Information* → *Prepare to Load Out* → *Inspect: pictures, video* → *Load Unit* → **Wait 1 day,
Update Paperwork**; and *Customer Storage w/ Crane or Trucking* → *Prepare to Load Out* →
*Inspect* → *Load Unit* → *Update Paperwork*. The one-day wait applies only to storage-only
shipments.

**`TCG_VE_Inventory_Audit`** (14 shapes): *Manual Audit* against the *Excel Inventory List* →
three outcomes, *Damaged* / *Clean* / *Missing*, plus *Unit NOT in Inventory* → *Research &
Inspect* (damaged, missing) → *Internal Investigation* (missing) → *Inform Customer* →
*Collaborate w/ Customer on Solution* (each branch) → *Documentation Update*.

The blank `_TEMPLATE - TCG_NameOfProcess_VALUE_ENGINE.xlsx` still contains the **Receiving**
flow verbatim — it was made by copying that workbook, so "template" here means "start from
Receiving and rename". `__TCG_VE_SYMBOLS.xlsx` holds only the legend.

## Source

- `1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/Storage User Guide.pdf` — 12 pp, `pdftotext -layout`;
  screenshots not transcribed
- `1.0.2_FCC-RESOURCES-GUIDES/FCC-IMPORT-Templates/Storage Data v.9.25_TEMPLATE.xlsx` — 2 sheets,
  **no data rows**; column contract and dropdown only
- `1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/TCG_VE_Receiving_2025-10-09.xlsx` — 8 sheets (4 of them empty)
- `1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/TCG_VE_Inventory_Audit_2025-10-09.xlsx` —
  6 sheets; sample inventory rows deliberately not copied
- `1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/TCG_VE_Shipping_2025-10-09.xlsx` — 6 sheets
- The three VE workbooks are duplicated at
  `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/zzzOTHER/` — different MD5, identical
  extracted text
- Process-diagram sheets (`TCG_VE_*`) are drawing canvases; only their SOP-step callouts survived
  text conversion, so the flow arrows and decision gateways are **not** recorded here

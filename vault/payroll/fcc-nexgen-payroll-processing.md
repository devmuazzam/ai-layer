---
title: FCC NexGen Payroll Guide — the incumbent payroll pipeline and its lifecycle locks
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/Payroll Guide v.1.0.docx (text and its 14 embedded screenshots, read 2026-09-04)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, legacy-payroll-app, time-tracking, reporting, architecture]
entities: []
---

# FCC NexGen Payroll Guide v1.0

**What this is.** Fleet Cost & Care's own end-user manual for payroll in **NexGen**, the desktop
application TCG runs today. Version **1.0, "1st Draft"**, authored by **David Thornton**, dated
**7/20/17** in its own version-change-control table. It is vendor documentation, not TCG's — it
describes what the product does, and explicitly says it "does not detail any information regarding
integrated payroll systems or other third party products", so it stops at the export file and
never mentions ADP.

**Why it matters.** Every other payroll document in this folder describes either the *legacy TCG
Payroll App* (the SQL Server side-system) or the *ERP target*. This is the third thing: the
**incumbent system of record**, whose approve/process/export locks are the reason TCG's payroll
process looks the way it does. In particular it is the written vendor answer to the question the
[dependency matrix](payroll-rule-dependency-matrix.md) and
[PAY-068](rules/PAY-068-retroactive-correction.md) are both circling — *what happens when labor
changes after processing?*

## 1. The pipeline, as the vendor describes it

Atom (mobile) → **API** → the `NexGenFMS` database → NexGen desktop → Labor for Payroll
Pre-Processor → Payroll Pre-Processor → Labor window → Export Payroll.

The manual's own procedural model, verbatim in substance:

1. Review entries in the **Labor for Payroll Pre-Processor** and check **Approved**. This "appends
   a datetime stamp to the approval and allows the entry to be readable by the processor" — and
   the name of whoever approved it.
2. Review the **Payroll Pre-Processor Status Report** to confirm every entry is accounted for. The
   most common misses are "labor entries that are not assigned to a job, work order, or
   classification."
3. **Preferably weekly**, review all entries in the **Payroll Pre-Processor**, highlight and click
   **Process**. This "locks the entry in the Labor for Payroll Pre-Processor and **prevents an
   employee from adjusting labor**."
4. Review reports before processing.
5. What happens after export "depends on the integrated payroll application" — out of scope for
   this manual.

Two facts about the pre-processor worth carrying into any ERP design:

- **Everything in the pre-processor is straight time.** *"All entries in this view, by default, are
  Straight Time (ST) hours. The processor will modify the times according to specified payroll
  defaults."* ST/OT/DT classification is a *processing* output, not a capture input.
- **Processing creates new rows.** In the post-processing **Labor** window (`Enter → Labor →
  Labor`), *"a labor entry… may have additional entries in the Labor window to account for OT, DT,
  or other special pay rates."* One pre-processor entry becomes several priced entries.

## 2. The lifecycle locks — the part that bears on PAY-066 and PAY-068

The manual states three separate locks, at three stages, and answers the change question at each.
Quoted from its FAQ and its process notes.

| Stage | What locks | The vendor's stated answer to "can I change it?" |
| --- | --- | --- |
| **Approved** (pre-processor) | The entry becomes readable by the processor; an employee can no longer edit their time in Atom | *"An employee can modify their time in Atom up to the time when labor is approved in the pre-processor. If a change needs to be made after this point, the employee will need to contact payroll representative."* |
| **Processed** | The entry is locked in the Labor for Payroll Pre-Processor | *"Once an entry has been processed, it is not possible to delete the entry and have it processed again. The changes will need to be made in the Labor window and **business rules will need to be applied manually**."* |
| **Exported** | *"Once exported, a labor entry cannot be modified in any way."* | *"Yes and No. As a general user, the details of this processor are not disclosed to ensure data integrity. However, a user may consult with management and address the changes. Management shall have access to and understand the procedure for post-export labor modifications."* |

Two guard dialogs are documented at the Process step:

- If the selected range is **longer or shorter than 7 days**, a second dialog warns the payroll
  representative — "just to make sure that the representative is aware of the anomaly." The weekly
  period is a soft convention enforced by a warning, not a constraint.
- *"If payroll has previously been exported and a new entry is entered, a dialog box will appear
  **preventing the user from processing the entry**."* A late entry against an exported period is
  refused outright.

**Read this against the ERP and the dependency matrix.** The incumbent system's answer to a
post-processing correction is *fix it by hand in the Labor window and re-apply the business rules
yourself* — a manual step with no engine behind it. That is precisely the cost the
[dependency matrix](payroll-rule-dependency-matrix.md) §13 proposes to remove with a recalculate-
and-post-a-delta mechanism, and it is the same hole the ERP has today (`calculate()` refuses on
`APPROVED`/`EXPORTED`, no reopen, no delta). **Three systems, three different non-answers.**
Nothing here settles [PAY-068](rules/PAY-068-retroactive-correction.md) — it shows what TCG lives
with now.

## 3. The e-ticket, as the payroll source document

The manual describes the e-ticket as **two or three tabs**, depending on settings:

1. **Ticket tab** — the customer-facing, signature-enabled field ticket: timestamps, customer and
   job-site information, terms & conditions.
2. **Checklist tab** — optional, can be turned on or off; the checklists the employee completed.
3. **Hours & Miles tab** — labor and unit information entered by the employee.

One operational note: *"Some e-tickets, like the LEM, may not show the unit related entries. This
is because the LEM can be used without a unit and when used with multiple employees, only one
employee will need to enter the unit miles/hours."* The document does not expand "LEM".

## 4. The payroll reports the incumbent system provides

Named here because they are the reports the payroll team is used to, and any ERP replacement will
be measured against them.

| Report | Path | What it gives |
| --- | --- | --- |
| **Payroll Pre-Processor Status** | (pre-processor) | Filterable by **company, yard, employee type, and status**; dates, employees, job/work-order/classification, labor, approval and processing status. Double-click a row to open that entry |
| **Employee Payroll Processor Summary** | `Reports → Labor → Employee Payroll Processor Summary` | By-day breakdown; *"can help identify missing labor by exposing days with no labor entered"* |
| **Tickets Not Completed** | `Reports → Jobs → Tickets Not Completed` | Incomplete tickets — another route to missing labor |
| **Labor Processor Summary** | `Reports → Labor → Employee Payroll Processor Summary` | Day-to-day and weekly aggregate totals. Its last column, *"though not used in calculations, shows the number of hours applied to a **Misc-** classification code"* — segregating special considerations from traditional labor |
| **Labor Processor Detail** | `Reports → Labor → Labor Processor Detail Report` | Itemised post-processing entries; double-click opens the pre-processor |
| **Employee Hours Audit** | `Reports → Labor → Employee Hours Audit Report (By EmpName)` | Post-processor breakdown showing **meals, per diem, ST, OT and DT**; available in three formats |

The **Misc-** classification column and the Employee Hours Audit report's *meals* and *per diem*
lines are the incumbent system's own handles on the concepts this vault tracks as WTL
([PAY-046](rules/PAY-046-meal-opportunity.md), [PAY-047](rules/PAY-047-worked-through-lunch-adjustment.md))
and subsistence ([PAY-048](rules/PAY-048-standard-subsistence.md)). The manual does not say how
either is calculated.

## 5. What this document does not say

- **No ADP.** It says so explicitly. The export is "routed to the folder/file name specified at the
  bottom of the window"; what consumes it is out of scope.
- **No calculation rules.** "Payroll defaults" is named repeatedly as the thing the processor runs
  entries against, but the defaults themselves are documented in the
  [Union Codes User Guide](fcc-union-code-configuration.md), not here.
- **No union, craft, guarantee, rest or WTL logic** of any kind.
- It is a **1st Draft from 2017** with a single row in its change-control table. Nothing indicates
  it was ever revised, and the product has plainly moved on — the
  [Union Codes User Guide](fcc-union-code-configuration.md) documents screens this manual does not
  mention.

## 6. The vendor's payroll-processor training video

The drop also contains `1.0.2_FCC-RESOURCES-GUIDES/FCC_YouTube/Training_Payroll_Processor_Best_Practices.url`
— a 4 KB Windows internet shortcut, whose entire content is a link:

**"Training — Payroll Processor Best Practices"** → `https://youtu.be/2kqPAGisyKA`

An FCC training video on payroll-processor best practice, collected by TCG alongside these guides.
**Not viewed, not transcribed** — it is a link, and video is outside what this ingestion can read.
Recorded here so the reference is not lost. If the guides above leave a processing question open,
this is the vendor's own answer to it and someone should watch it.

## Source

`1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/Payroll Guide v.1.0.docx` — 648 KB
`.docx`, converted by pandoc to GitHub-flavoured Markdown (~19 KB of text). Heavily illustrated:
23 screenshots, none of which survive text conversion; §1–§6 are from the prose alone, and the 14
distinct screenshots were extracted and viewed on 2026-09-04 — see *What the screenshots show*. Vendor: Fleet Cost & Care, 865 S. Fort St., Detroit, MI 48217.

## What the screenshots show — read 2026-09-04

Fourteen images embedded in `Payroll Guide v.1.0.docx` were extracted and viewed on
2026-09-04 (the cover logo and one duplicated screenshot were not extracted separately; two
icon strips the text references, `image15` and `image18`, were not present in the extraction).
Every screen is the vendor's demo database — company "Fleet Cost & Care", yard "Atlanta
Yard", test employees and test jobs — so example values are FCC test data, not TCG's. Employee
names, IDs and rates shown on the screens are deliberately not copied. Recorded below is only
what the prose above did not already give.

### The flow diagram (§1) as drawn

Two rows of chevrons: **Atom → API → NexGenFMS database → NexGen**, then **Pre-Processor →
Payroll Processor → Export → Integrated Payroll Application**. Nothing on the diagram names
the integrated application.

### Labor for Payroll Pre-Processor — the screen

Header: **Yard** dropdown; **Employee** search + dropdown with a **Name / ID** radio pair.
Grid columns: **Work Date · Craft Code · Job · WO · Unit Code · Quantity · Rate · Amount**,
with a `Record n of m` counter. The entry pane:

| Field | As shown |
| --- | --- |
| **Work Date** | date dropdown, echoed as a long date (`Friday, May 19, 2017`) beside it |
| **Union** | dropdown, blank in the demo |
| **Craft Code** | dropdown + read-only description. Demo craft codes: `MECHA` = *Mechanic-Regular Earnings*, `FORE-A` = *ForeMan-Regular Earnings*, plus `DFLTA`, `1101A`, `CERTPY`, `OPERA`, `DRIVERA` — mixed alphabetic and numeric-with-suffix codes |
| **Hours · Rate · Amount** | the pre-processor labels the quantity simply **Hours**; the post-processing Labor window labels the same field **ST Hours** |
| **Job** + description · **Job Line Item** · **Work Order** (search) + description · **Unit Code** + description · **Activity** dropdown (demo `100 hr. serv. upper` — activities are named service intervals) | |
| **Work Comp** · **Burden** · **Class** | three dropdowns each with a read-only description (demo: `BRD5` = *Burden Code 5*; Class `Mechanic Labor`) |
| **Approved** | checkbox with a greyed approver-name field and a greyed datetime field — the stamp the text describes |
| **Comments** | free text |

Footer: the employee's name, **`For Payroll Date: <from> – <to>`**, and five totals —
**ST Hours · OT Hours · DB Hours · Total Hours · Labor Total**. The screen therefore shows a
running ST/OT/DB split for the period even in the pre-processor, where the text says all
entries are straight time.

### The e-ticket print (§3) — what the tabs actually contain

**Ticket tab**, printed as `Page 1 of 4` / `Page 2 of 4`. Page 1: yard name and address
block; **Date · Job No · Ticket No**; **PO #**; **Salesperson**; **Customer** (the demo shows
a customer code and name in one field); **Address**; **Terms** (demo `100% Net Now`); two
**Phone** lines; **City, State Zip**; a **Job Site** block (Job Site, Address, Phone, City
State Zip, **Directions**, **Alt Phone**); **Report To** and **Ordered By**, each with **CP**
(cell phone), **WP** (work phone) and **E-Mail**; **Work Description**; **Comments**;
**Equipment** printed as `<type> - <description> <unit number>` (demo `Crane - Mo 100 Ton
Mobile 00204`); **Employees** printed as `<role> - <name>` (demo role `Driver`); **Equip
Required**; a boxed **"Have Signed At Start of Job"**; the sentence *"The following terms and
conditions governing this rental are understood and agreed to:"*, a ticked **Accepted Terms
and Conditions** checkbox, **Signer's Name**, **Date** with time, and **By / Authorized
Signature** with the captured signature.

Page 2: **Time Left Yard · Time Arrived Job · Time Left Job · Time Arrived Yard**; a boxed
**Signer's Name**; *"The above hours are verified to be correct"*; a **Worked Through Lunch**
checkbox; second Signer's Name, Date/time and signature; **Ticket Comments**; then **Terms &
Conditions** headed by a **state name** (demo `Georgia` — the T&C text is selected per
state), opening *"THE INDIVIDUAL SIGNING HAS BEEN GIVEN AUTHORITY TO EXECUTE THIS AGREEMENT"*,
a red-type line that riggers and signal persons shall be qualified prior to start of
operations, then numbered **1. INDEMNIFICATION** and **2. INSURANCE** clauses (the insurance
clause lists worker's comp, primary CGL, excess/umbrella, inland marine and additional-insured
requirements with dollar limits — vendor sample text, not TCG's terms).

**The `Worked Through Lunch` checkbox sits on the customer-signed hours page, next to the
verified times.** In this generation of the e-ticket, WTL is a single yes/no the customer
signs against — consistent with the Atom operator guide's description, and with nothing more
(no times, no count).

**Checklist tab**: header **Job · Ticket No · Date · Employee**; columns **Check List ·
Checked By · N/A**, each item a checkbox with an optional free-text answer beneath. The demo
checklist is a **power-line checklist**: *Voltage of Power Lines (kV)* (answer `26kV`);
*Voltage Determined By*; *Utility Owner / Operator Contact Number(s)*; *Line was de-energized -
Confirmed By*; *Establish and identify boundaries 20' from power lines*; *Identify the work
zone as the area 360 degrees around the crane, up to "maximum working radius"*. Items can be
marked **N/A** instead of checked.

**Hours & Miles tab**: **Job No · Ticket No · Date · Equipment** (`<type> <description>
<unit code>`); a unit row **Date · Unit Hrs/Lo · Unit Hrs/Up · Unit Mi/KM ·
Location/Comments** — unit hours are captured **separately for lower (carrier) and upper
(superstructure)**; then a labor row **Operator / Oiler · Operator · Craft Code · Hours ·
Comments**, i.e. the role column is either `Operator` or `Oiler`.

### The reports (§4) — layouts and column sets

- **Employee Payroll Processor Summary**: columns **Employee · Wed · Thu · Fri · Sat · Sun ·
  Mon · Tue · Total Hours · Total Misc Pay Type**, with a company total line. The day columns
  in the demo run **Wednesday to Tuesday**; the screenshot does not say whether that is a
  configured week start or the vendor demo's. The same screenshot is used for the text's
  "Labor Processor Summary Report" heading — the two names refer to one report.
- **Payroll Pre-Processor Status Report**: header yard and date range; columns **Work Date ·
  Employee Name · Job · Unit Code / Work Order** (stacked) · **Customer / JobSite** (stacked) ·
  **Classification · Labor Hours · Approved · Processed** — the last two printed as
  checkboxes. Classification values seen: `Operator Labor` and `50:Training` (a
  number-prefixed classification). Work-order references seen: `C-980`, and unit codes such
  as `T5`, `9904`, `110MH03` printed above a five-digit WO number.
- **Employee Payroll Processor Detail Report** (the text's "Labor Processor Detail"): one
  employee per report, headed `<Emp ID> <name>`. Stacked columns **Work Date · Job / Unit
  Code / Work Order · Job Line Item / Activity / Classification · Craft / Union / Boom Lgnth
  · GL Account / Shift Info · Quantity / Comments · Rate · Amount**. Quantity prints as e.g.
  `19.00 ST Hours`. **`Boom Lgnth` and `Shift Info` are per-entry attributes** — the report
  has a column for boom length on a labor line, which no prose in this guide mentions. One
  demo row carries the system comment *"Automatic entry upon ticket complete."* with 0.00
  hours — completing an e-ticket creates a labor row even when no hours were entered.
- **Hours Audit Report** (the text's "Employee Hours Audit Report (By EmpName)"): header yard,
  date range, and a boxed `<Emp ID> | <name>`. Stacked columns **Job / Unit Code / Work Order
  · Job Line Item / Activity / Classification · Craft / Boom Lgnth / GL Account · Shift ·
  State Tax / City Tax · Union / Burden / WC · Union Amt / Burden Amt / WC Amt · Quantity /
  Comments · Rate · Amount**. Rows group by day with a `Total For <weekday> <date>` line
  giving ST / OT / DB hours and amount; the employee total block gives **Burden · Union · WC ·
  Overhead** dollar totals, hours by **ST / OT / DB**, and dollars by **ST / OT / DB / Misc /
  Salary**. Burden and WC amounts are computed per line (demo: `Burden Code 4`, `wc4`). The
  demo page shows **no meals or per diem line** — the text says the report shows them; the
  sample simply has none, so this is not a contradiction, but the columns for them are not
  visible either.

### Payroll Pre-Processor and Export Payroll — the two batch screens

**Payroll Pre-Processor**: **Company · Yard · Employee** (default `All Employees`, Name/ID
radio); **From / To** dates; **View** button; caption *"Highlight the Employee(s) to Process"*
and *"Process Payroll"*. Grid: **Emp ID · Employee · Work Date · Craft Code · Quantity · Rate
· Amount · Processed** (checkbox). Buttons **Process · Close · Select All · Deselect All**.
Demo employee IDs are mixed-format — six-digit zero-padded, four-digit, and short alphabetic
mnemonics — so the field is free-form text, not a fixed-width number.

**Labor** window (post-processing): same header and grid as the pre-processor, plus **GL
Account** dropdown + description (demo `02-300` *Sales*), **Ticket No** (read-only — the
e-ticket the entry came from), and a **Left Yard · Arrived Yard · Elapsed Time** trio of
read-only times with elapsed hours. The employee footer shows `<name> - <Emp ID>` and the
same ST/OT/DB/Total/Labor Total block.

**Export Payroll**: **Company · Yard · View**; captions *"Highlight the Employee(s) to
Export"* and *"Generate Payroll Export"*; **From / To**. Grid: **Emp ID · Employee ·
Standard · Overtime · Double · Total · Amount · Selected** (the four hour columns grouped
under a **Hours** caption). Two totals rows — **Total Available for Export** and **Total
Selected for Export** — each giving the four hour figures, the amount and an employee count.
**Export File Name** defaults to **`C:\TEMP\LABOR.TXT`** with a **Browse** button; buttons
**OK · Close · Select All · Deselect All**. The export is a single flat text file written to
a local path; the screenshot does not show its layout. Demo hours are in quarter-hour steps
(`8.25`, `7.50`).

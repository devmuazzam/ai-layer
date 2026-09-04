---
title: FCC NexGen reporting catalogue and training resources
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/Reporting Guide v.1.3.docx (text + its 52 embedded screenshots, read 2026-09-04) + 1.0.2_FCC-RESOURCES-GUIDES/FCC_YouTube/*.url
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/admin, module/all, kind/reference, reporting, certifications, invoicing, pricing, time-tracking]
entities: []
---

# FCC NexGen reporting catalogue and training resources

**What this is.** Two things TCG filed together as FCC reference material: the **NexGen Reporting
Guide v1.3** — FCC's own catalogue of the ~50 reports the legacy system ships, organised by
module — and five **`.url` shortcuts to FCC training videos on YouTube**.

**Why it matters.** The RFP asks for "Reporting & Analytics — dashboards for operations, finance,
and executive KPIs" and says nothing about what reports exist today. This is that list: the
reporting surface TCG is used to, and therefore the set a replacement will be measured against.
It is an **inventory, not a requirement** — no source says the new platform must reproduce any of
these.

> **Age warning.** The Reporting Guide is **v1.3 from 21 July 2017**, and its own version-control
> table records no revision since. It describes a NexGen eight years older than the 2025.1.1.0
> build TCG runs. Report names may have changed; some entries are marked unfinished in the guide
> itself. Do not treat it as a current inventory without checking against the live system.

---

## What the guide contains

Each report entry gives the report's purpose, its **menu path**, its filters, and a screenshot.
The screenshots are images and carry no extractable text, so the text conversion gives only the
report's name, path and stated purpose. **The screenshots themselves were read on 2026-09-04 and
the columns of every pictured report are tabulated in the last section of this page.**

Shared reporting controls documented up front: **Record Select** (First/Last/Previous/Next),
**Dates** (a dashboard-level date range that persists until changed), **GoTo Page**, **Zoom**,
**Find Text**, **Customize**, **Save As** and **Print**.

**Customize is worth noting for the replacement:** it exports a report to **Crystal Reports** for
modification and re-imports the customised version. The guide restricts this to users "familiar
with business reporting and Crystal Reports". Report customisation in NexGen is therefore an
external-tool activity, not an in-app one.

## The report catalogue, by module

### Quotes (2)
Quotes By Report (grouped by a View By option — the guide's example is Status/Pending over a job-date
range) · **Quote Status Report** — outstanding quotes with a **Status** column and a **Lost Code**
column, double-clickable through to the quote to update either.

### Jobs (7)
**Job Estimates Unbilled** — the guide says it "should be ran on the 15th and 30th of each month",
filtered by date range, yard, department and view-by · Job Estimate Variance Report · Jobs By
Report · Recurring Billing · Jobs Unbilled · Labor/Equip/Material Summary Report · Down Rent
Summary Report.

### Labor (10)
Employee Labor Detail Report · Employee Summary Report *(two distinct reports share this name in
the contents)* · Chargeable vs. Non-Chargeable Summary Report · Chargeable vs. Non-Chargeable Detail
Report · Company Labor Summary · **Classification Summary** — a cost breakdown by classification,
including labor, material or both · Terminated Employees · Employee Vacation/Leave Report · New
Employees.

### Certifications (4)
Employee Certificates · Unit/Employee Certifications · **Coming Due Certifications** ·
Customer/Location Certifications.

### Units (6)
Unit Current Value Report · Unit List · Down Equipment · **Equipment Utilization By Date Range —
Yard Report** · Equipment Revenue Report · Labor/Material Detail Report.

### Work orders, parts and preventative maintenance (7)
Work Order Status Report · Stock on Hand · Re-order Report · Parts G/L Account Report ·
**Coming Due Preventative Maintenance** — in three variants, *For All Units*, *For 1 Unit* and
*For 1 Activity*, each parameterised as "due in the next [N] days" or "due in the next [N]
miles/km" and returning days past due where applicable · PM History for All Units · Past Due All
Units Report.

> The *Coming Due For 1 Activity* variant is filtered by a specific **activity**, so that a
> supervisor can find all units needing a given level of work — the guide's stated use is matching
> available work to a qualified employee's skill set. The activity codes it filters on are in
> [fcc-activity-code-master-list.md](fcc-activity-code-master-list.md).

### Purchasing (3)
PO Status Report · Voucher Items Exceeding Variance Report · Receivers Not Invoiced.

### Invoicing (7)
Invoice Register · **Not Exported** · Batch Audit Report · Sales Tax Report · Billing History
Within Date Range · Billing History Before Date Range · Billing Forecast Report.

### Expense / revenue / profit (6)
Revenue Summary Report in three cuts — **All Jobs**, **All Yards**, **All Salespeople** · Revenue
Detail Report *(listed twice)* · Summary Report By Work Date Report · **Re-Class Report (SQL
Report)** — marked in the guide as **"[This report is under construction]"**.

---

## FCC training videos

Five Windows `.url` shortcuts, each pointing at public YouTube content. No further description
accompanies them.

| Shortcut | Target |
| --- | --- |
| FCC_YouTube | `https://www.youtube.com/@fleetcostcare` — FCC's channel |
| Training_Invoicing_101 | `https://youtu.be/5d0XKIgw1aI` |
| Training_Payroll_Processor_Best_Practices | `https://youtu.be/2kqPAGisyKA` |
| Training_Sales_and_Quote_Management_101 | `https://youtu.be/Uu2RNul0cnM` |
| Training_Scheduling_And_Atom_101 | `https://youtu.be/sLYLXfqCilk` |

The topics TCG chose to bookmark — invoicing, payroll processing, sales/quote management,
scheduling and Atom — line up with the four areas the FCC health check identified as needing
training ([fcc-nexgen-health-check-2025-12-16.md](fcc-nexgen-health-check-2025-12-16.md)).
**Nothing in the drop says whether the videos were watched, or by whom.** The video contents are
not in the drop and have not been summarised here.

---

## What the guide's screenshots show — read 2026-09-04

*Source for this section: the 52 screenshots embedded in `Reporting Guide v.1.3.docx`
(`media/image10`–`image64`; `image1`/`image2` are the FCC logo, `image3`–`image9` and `image12`
are toolbar icons and were not extracted). Viewed 2026-09-04. Everything below is read off the
images; where a column label was cut off in the screenshot it is marked `…`.*

**This corrects the statement above that "the columns each report returns are not recoverable
from this source."** They are — every screenshot in the guide is the **rendered report output**,
not a parameter dialog. The guide contains **no parameter/filter dialog screenshots at all**; what a
report is filtered by can only be read from its printed header (yard, date range, department,
view-by). Two screenshots are not reports but grids: *Work Order Status* and *Not Exported*.

Every printed report carries the company name as its title line (the demo company is *Fleet Cost &
Care*), a print timestamp, `Page n of m`, and — on some — a record count in the header (`No of
Quote's 67`, `No of Jobs 2,711`, `Total Parts: 55`, `Total PO's 110`). Print timestamps run from
**4/21/2016 to 7/24/2017**, consistent with the guide's 2017 date. One screenshot (Job Estimate
Variance) is headed *Southway Crane & Rigging — Yard: Atlanta* rather than Fleet Cost & Care, so at
least one image came from another FCC customer's data, not the demo database.

### Report → printed title → columns

**The printed title often differs from the menu name**, which matters when matching this list
against the live system. Where they differ, the printed title is given in *italics*.

| Menu name (guide) | Printed header / grouping | Columns shown |
| --- | --- | --- |
| Quotes By Report | *Job Date* (the View By value becomes the title) · yard · `All Dates` · quote count | Quote No, Cust Code, Customer Name, Job Site, Est Start, Est End, Quote Min, Quote Max, Equipment Required (free text under the amounts), Unit Type, Employee Type |
| Quote Status Report | *Job Date* · yard · `All Dates` | Quote No, Job No, Cust Code / Customer Name, Job Site, Est Start, Est End, Salesperson, Status (`Pending`, `Received Bi…`), Lost Code |
| Job Estimates Unbilled | *Job Estimates Unbilled Report* · `Jobs Ending From <date> - <date>` · one block per job | Job header: Customer, Date, Job Site, PO No. Lines: Billing Code/Part No, Date From, Date To, Quoted Qty / Est Qty, Unit Meas, Quoted Rate / Est Rate, Extension, Qty Billed, Open Qty, Unbilled Amount; `Total For Job` |
| Job Estimate Variance Report | company · `Yard: <yard>` · `As of <date>` | Job No, Customer / Job Site, Billing Address, Description of Work, Start Date / End Date, Quoted / Invoiced; then per billing code three column groups — **Job Billing Estimate** (Qty, UOM, Rate, Amount), **Actual Billing** (Qty, UOM, Rate, Amount), **Variance** (Qty, Amount; negatives in red parentheses); job total row |
| Jobs By Report | grouped by the View By value (sample: salesperson) · `All Dates` · job count | Job No, Customer Name, Job Site, Job Start (date + time), Job End (date + time), Created |
| Jobs Unbilled | *Jobs Unbilled Report* · `Jobs Ending From … - …` | Job No, Customer Name, Date (single or range), Job Site, PO No, Status |
| Labor/Equip/Material Summary Report | *Job, Labor, Equipment and Materials Summary Report* · one job · `All Dates` | Equipment section: Unit Code, Hours, Amount, `Total Equipment for Job`; a Totals box with Equipment, Materials (and, by layout, a Labor line — empty in the sample) |
| Employee Labor Detail Report | *Labor Detail Report* · `From … To …` · one employee | Work Date; Job / Unit Code / Work Order; Job Line Item / Activity / Classification; Craft / Union / Boom Lgnth; JC Code / GL Account / Shift Info; Quantity (e.g. `15.00 ST Hours`, `10.00 OT Hours`) / Comments; totals **ST / OT / DB** |
| Employee Summary Report (Labor section, 1st) | *Employee Labor Summary* · `All Yards` · one week | Employee, seven weekday columns (the sample week runs **Wed → Tue**), Straight, OverTime, Double Time, Total Hours, Total Misc Pay Type; company total |
| Chargeable vs. Non-Chargeable Summary Report | *Chargeable Vs Non-Chargeable Labor Summary Report* · date range | **Chargeable Labor** split into *Classification – Job* and *Classification – Work Order* (Hours, Amount, subtotals), then **Non-Chargeable Labor** by Classification; closing line `Chargeable Labor Vs Non-Chargeable Labor $x – $y` |
| Chargeable vs. Non-Chargeable Detail Report | grouped Job → employee (`<emp id> <name>`) | Work Date, Job, Unit Code, Work Order, Activity / Classification, Craft, Qty, Rate, Amount; per-employee total |
| Company Labor Summary | yard · date range | Company, Hours: Straight, Overtime, Double, Total; Amount; grand total |
| Classification Summary | date range · yard | Classification Code, Classification Desc, Parts, Labor, Total. The demo code list printed: `20` Transportation, `30` Maintenance, `30.1` tires, `30.2` wire rope, `31` maint labor, `32` Crane service test, `40` Repair/Welding, `50` Training, `60` Non-Revenue, `70` Fueling, and alphabetic codes `FLUID FREIGHT FUEL LABORME LABOROL LABOROP LB LUB LUBRIC M MSHA MSHA-NMA NMAPC NMAPC-SUB NON OFFICE OILRSHP OPERSHP OUTREP PARTS RIGGER SF SP THIRD TOOLS` — FCC demo data, not TCG's classifications |
| Terminated Employees | — | *screenshot not extracted (`image25`)* |
| Employee Vacation/Leave Report | yard · date range | Employee, Reason (`Vacation`, `Off`), Leave Date / Time, Return Date / Time, Comments |
| New Employees | *New Employees Report* · date range | Name, Address, City/State Zip Code, **Social Security**, Hire Date — *the report prints SSNs; the demo value is not copied* |
| Employee Summary Report (Labor section, 2nd) | *Employee Report* · yard | Emp Id, Name, Address, City/State Zip Code, Phone, Personal Cell Phone, Work Cell Phone, Status — an **employee directory**, not a labor report. *Demo addresses and phone numbers not copied.* |
| Employee Certificates | *Employee Certification Report As of <date>* | a **matrix**: one row per employee, one column per certification type (sample columns: Certified payroll, Drug Test, job site test, NCCCO Certified Operator, NCCER Advanced Rigger, TAPPI Safety Orientation), cell = expiry date |
| Unit/Employee Certifications | — | *screenshot not extracted (`image30`)* |
| Coming Due Certifications | *Coming Due Certification Report* · `Coming Due In N days, N mi/km or N hours` · grouped by Unit Code + Unit Description | Certification Code, Certification Name, Last Maintenance, Next Maintenance, Past Due (`247 Days`), Coming Due In |
| Customer/Location Certifications | *List of Certifications by Customer* | Cust Code, Customer Name, Location; **Employee Certifications**: Certification Code, Certification Name |
| Unit Current Value Report | company | Unit Code, Description, Serial Number, Yard Name, Model Year, Purchase Date, Purchase Price, Insurance Value, Current Value |
| Unit List | *Master Unit List* | Unit Code, Description, Model Year, Unit Type, Sched Type, Capacity (`110 Ton`, `20 Lbs`), Serial Number, Bar Code |
| Down Equipment | — | no screenshot in the guide |
| Equipment Utilization By Date Range – Yard Report | *<Yard> — Equipment Utilization — From <month> To <month>* | Unit #, Make, Model, Current Location, Date Purchased, Date Sold, Mos. in Yard, Usage Hrs, Usage %, Avg Monthly Income, Total Income, % of Target, Monthly Target — i.e. **utilisation is measured against a per-unit monthly revenue target** |
| Equipment Revenue Report | yard · `All Departments` · date range · **one column per unit** | Rows: **Revenue** (Bare, N/A, Operated), Total Revenue; **Labor** by classification, Total Labor; **Material** by classification, Total Material; **OverHead** (Labor Burden, Material Burden, Union, Workers Comp), Total OverHead; **Profit/(Loss)**. Costs in red parentheses |
| Labor/Material Detail Report | *Unit Labor and Materials Report* · `All Units` · yard · date range · **Materials** section per unit | Date / Voucher / PO No; Job / WorkOrder / Unit; Job Line Item / Classification / Activity; Part No / Part Description / Vendor; Qty, Unit Meas; Price; Amount; Comments (16 pages in the sample) |
| Down Rent Summary Report | *Down Rent Summary* · `All Units` · date range · grouped (sample group `No Unit`) | Unit Type, # of Line Items, % Used, Hours, Total Billed |
| Work Order Status Report | **a sortable grid, not a printed report** | Work Order / Date Issued / Customer Code / Name; Unit Code / Make / Model / Serial No; Status / Priority / Reason (`Open`, `IN PROGRESS`, `Preventative Maintenance`); Labor Hours / Labor Exp / Parts Exp / Total Exp; Employees; Description of work; Repair Comments |
| Stock on Hand | *Stock On Hand* · yard · location (`None`) · `Total Parts` | Part No, Description / Bin Location, Yard / Location, New Quantity (negative quantities appear in parentheses), Unit Measure, Cost, New Extension |
| Re-order Report | — | *screenshot not extracted (`image41`)* |
| Parts G/L Account Report | company (388 pages in the sample) | Part No, Description, Sales GL Account, Cogs GL Account, Inventory GL Account |
| Coming Due PM — For All Units | *<Yard> — Coming Due Preventative Maintenance Report* · `Coming Due In 90 days, 0 mi/km or 0 hours` · `All Unit Types` · per unit | Activity, then **two column pairs**: Past Due / Coming Due In for the meter constraint (`300 Hours`) and Past Due / Coming Due In for the calendar constraint (`71 Days`) — the dual interval printed side by side |
| Coming Due PM — For 1 Activity | same, header adds `Activity: <name>` | same columns |
| PM History for All Units | *Preventative Maintenance Report* · one unit type · date range · boxed Unit Code, boxed activity name | Work Date, Miles/KM, Upper Hours, Lower Hours, Labor Done By, Work Order |
| Past Due All Units Report | *Past Due Preventative Maintenance Report* · per unit | Activity, Past Due (hours), Past Due (days) |
| PO Status Report | *Purchase Order Status Report* · yard · `All Departments` · status `All` · `Total PO's` | PO No, Order Date, Vendor Name, Yard, Department (`Service`, `Parts`, `Equipment`, `Cranes, Operated`), Total, Printed (Yes/No); `Vend Order #` sub-line |
| Voucher Items Exceeding Variance Report | `All Yards` · `All Departments` · date range | Voucher No / Status (`Pending`, `Approved`), Req No / PO No, Vendor Name, Original Cost, Voucher Cost, Variance %, Comments; `Approved By: <user> <date> <time>` sub-line |
| Receivers Not Invoiced | yard · `All Departments` · `All Dates` · grouped by GL Account / WO / Unit | PO No / Buyer, Vendor Name / Receiver / Description, Date Rcvd / PO Date, Quantity, U/M, Cost, Tax, Amount |
| Not Exported | **a window, not a report** — Company, Yard, Department filters, `View` button, `Click Headings To Sort By Columns` | Invoice, Date, Job/WO, Cust Code, Customer Name, Total W/Tax, Type (`RENTAL`, `WORK ORDER`), Printed ☐, Export Status (`Export OK`, `Export No…`), Export Done ☐ |
| Invoice Register | yard · date range | Invoice#, Invoice Date, Invoice Type (`RENTAL`, `ORDERS`, `JOB PARTS`, `WORKORDER`), Cust Code, Customer Name, Invoice Total (credits negative) |
| Batch Audit Report | *Invoice Batch Audit Report* · `All Invoices` · `Using Invoice Date` · date range — two pages shown | Detail: Inv Code, Customer, Inv Date / Dis Date / Due Date, Inv Amount / Dis Amount, **Distribution** (GL Account, Description, Amount) per invoice. Summary: GL Account, Description, Debit Amount, Credit Amount, balanced totals |
| Sales Tax Report | date range · grouped by State (`No State`) and sales-tax code | Invoice, Date, Customer Name, Invoice Before Tax, Exempt Amount, Taxable Amount, Tax Amount; code and state subtotals |
| Billing History Within Date Range | date range | Invoice, Job, Customer Name, Billing Code, Date, Qty, Unit Meas (`Hours`, `Each`, `%`, `Months`, `Total`), Rate, Amount — one row per invoiced billing line |
| Billing History Before Date Range | date range | same columns, company total |
| Billing Forecast Report | date range · grouped by Customer Name | Bill/Inv Date, Billing No, Invoice No, Billing Description, Quantity, Rate, Amount — recurring billings projected **one row per future day** |
| Revenue Summary (All Jobs) | *Job Revenue Summary* · date range | Job No, Customer Name, Job Site, Job Start, Job End, Total Revenue, % (of company total) |
| Revenue Summary (All Yards) | *Yard Revenue Summary* | Yard, Total Revenue, %; company total |
| Revenue Summary (All Salespeople) | *Salesperson Revenue Summary* | Salesperson (incl. `No Salesperson` and region rows such as `REGION, GEORGIA`), Total Revenue, % |
| Revenue Detail Report (1st) | *Salesperson Profit/Loss* · date range · grouped by salesperson | Job No, Customer Name, Total Revenue, Labor Hours, Labor Expenses, Equipment Expenses, Material Expenses, Overhead Expenses, Total Expenses, Total Profit/Loss, Profit% |
| Revenue Detail Report (2nd) | *Job Profit/Loss Detail* · one job | Header: Job No, Customer Name, Total Revenue, Labor Hours, Labor Expenses, Union Expenses, WorkComp Expenses, Burden Expenses, Equipment Expenses, Material Expenses, Total Expenses, Total Profit/Loss, Profit%. Sections: **Invoices per Job** (Invoice No, Date, PO No, Total Billed); **Equipment** (Unit Code, Start Date, End Date, Hours, Rate, Amount, Invoice); **Labor** grouped by day (Employee, Job Line Item / Classification / Comments, Craft / Union, Quantity / GL Account, Rate, Amount; ST / OT / DB totals) |
| Revenue Detail Report (3rd) | *Invoice Per Salesperson* · grouped by salesperson | Invoice No, Job/WO, Date, Customer Name, PO No, Total Billed |
| Summary Report By Work Date Report | *Job Revenue Summary by Work Date* · date range | Job No, Customer Name, Job Site, Job Start, Job End, Total Revenue |
| Re-Class Report (SQL Report) | — | no screenshot (under construction in the guide) |

### What this resolves and what it adds

- **The two "Employee Summary Report" entries are two different reports**: a weekly *Employee
  Labor Summary* and an *Employee Report* directory. The guide's contents page reused one name.
- **"Revenue Detail Report (listed twice)" is three outputs** — Salesperson Profit/Loss, Job
  Profit/Loss Detail and Invoice Per Salesperson — under one heading.
- The Coming Due PM reports print the **hours-or-miles and calendar constraints as two column
  pairs**, confirming from the report side the dual-interval model described in
  [../field-ops/fcc-nexgen-service-guide.md](../field-ops/fcc-nexgen-service-guide.md) §1.
- Two reports print personal data: *New Employees* has a Social Security column and *Employee
  Report* prints home addresses and personal cell numbers. A replacement report set should decide
  deliberately whether either belongs on a report. **The guide says nothing about access control
  on either.**
- Equipment Utilization is measured against a **Monthly Target** per unit (the Unit Types
  maintenance grid in the Service guide carries a `Target Hours/Month` column — see that page).
- Labor-side reports carry `Craft`, `Union`, `Boom Lgnth`, `Shift Info`, `JC Code`, `GL Account`
  and the ST/OT/DB split on every line — the same vocabulary as
  [../payroll/rules/INDEX.md](../payroll/rules/INDEX.md).

Three screenshots referenced by the text (`image25`, `image30`, `image41`) were not in the
extraction, so *Terminated Employees*, *Unit/Employee Certifications* and *Re-order Report*
remain name-only; *Down Equipment* has no screenshot in the guide at all. No screenshot in the
guide is unreadable; two are truncated at the right edge (Quote Status, Employee Certification
matrix).

## Source

- `1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/Reporting Guide v.1.3.docx` —
  43.9 KB as converted text, pandoc GFM, ~60 pages. Version control: v0.1 Lisa Leavell 2017-06-01
  (initial module creation), v1.0 David Thornton 2017-06-04 (DRAFT), **v1.3 David Thornton
  2017-07-21 (DRAFT)** — the current version, still marked draft. Fleet Cost & Care, 865 S. Fort
  St., Detroit, MI 48217.
- `1.0.2_FCC-RESOURCES-GUIDES/FCC_YouTube/*.url` — five Windows internet-shortcut files, 128–138
  bytes each, copied as-is.

---
title: Sales reporting workbooks — the KPI tracker, the win-back list, the dispatch board and the training schedule
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/ — RYAN_ADAMS_KPI_TRACKER_BACKEND_CONNECTED.xlsx, Follow Up Customers - With Addresses (1).xlsx, Sales Dispatch Sheet.xlsx, Sales Admin 60 day training.xlsx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/dispatch, module/customers, kind/source, reporting, reference-data, provenance, scheduling, permits, safety]
entities: []
---

# Sales reporting workbooks — structure, not data

**What this is.** Four large spreadsheets Ryan Adams delivered with the sales-process set. They
are **operational tooling built on top of FCC exports**, not specifications. Their value to the
vault is threefold: they show **what FCC actually exports** (which is the closest thing to a quote
schema in the drop), what metrics the business tracks, and which manual workbooks an ERP would
replace.

> **Rule of this page: structure only.** These files hold tens of thousands of rows of live
> quotes, invoices, customer contact details and per-employee performance figures. **No row data,
> no customer contact details and no per-salesperson performance numbers have been copied into the
> vault.** Column layouts, sheet inventories, code lists, metric definitions and stated logic are.

---

## 1. What the four are

| Workbook | Size | Sheets | What it does |
| --- | ---: | ---: | --- |
| `RYAN_ADAMS_KPI_TRACKER_BACKEND_CONNECTED.xlsx` | 7.6 MB text | 29 | An executive dashboard over four FCC/QuickBooks exports — revenue, rep scorecards, customer intelligence, geography, crane-size analysis, lost jobs, safety audits — with a declared backend/reconciliation layer |
| `Follow Up Customers - With Addresses (1).xlsx` | 467 KB text | 8 | A **customer win-back** command centre: inactive customers ranked by historical quoted dollars, assigned to salespeople, with outreach status and follow-up dates |
| `Sales Dispatch Sheet.xlsx` | 152 KB text | 42 | A **36-month crane-by-day dispatch board** (Jun 2026 → Jun 2029) with a utilisation metrics sheet |
| `Sales Admin 60 day training.xlsx` | 866 KB text | 11 | A 60-day onboarding schedule for a sales admin, with a task library, certifications and resource links |

## 2. The KPI tracker — and what FCC exports

### 2.1 The four source exports

`SOURCE_Index` names them, and this is the useful part of the whole workbook:

| Source tab | Purpose | Original file | Feeds |
| --- | --- | --- | --- |
| `SOURCE_Quotes` | *"Raw quote opportunities and statuses"* | `Quoted jobs for the year(4).xlsx` | Rep Scorecard, Reactive vs Proactive, Large Lost Jobs, Crane Metrics |
| `SOURCE_Invoices` | *"Raw billed revenue and dispatch data"* | `Year invoice(5).xlsx` | Executive Summary, Customer Intelligence, Geographic Heat Map |
| `SOURCE_Field_Audits` | *"Raw safety audit observations"* | `Field Audits 2026(1).xlsx` | Field Safety Audits, Safety Crew Metrics, Safety Advanced Metrics |
| `SOURCE_Quote_Status` | *"Quote status export used to trace QuoteNumb and Jobcode into invoiced jobs"* | `Quote Status.xlsx` | Quote to Invoice Flow, Quote Invoice Detail |

### 2.2 The FCC quote export schema

**`SOURCE_Quote_Status` is the richest FCC quote extract in the drop — 42 columns.** Read as a
field list it is effectively FCC's quote header:

`QuoteNumb` · `Customer` · `Custlocation` · `JobSdate` · `JobEdate` · `Jobcode` · `StateCode` ·
`CheckedBy` · `CompanyCode` · `CustCode` · `DeptCode` · `SpersonCode` · `SalesPerson_Name` ·
`QuoteStatusCode` · `Description` · `TakenBy` · `YardCode` · `LostQuoteCode` · `GroupNumb` ·
`Name` · `YardName` · **`QuoteMin`** · **`QuoteMax`** · `EquipReq` · `CheckedByName` ·
`TakenByName` · `DeptName` · `StateName` · `WorkDesc` · `QuotedTo` · `SubmitDate` · `FinalDate` ·
`LostComments` · `LocAdd1` · `LocAdd2` · `Cust_Location_State_City_Zip` · **`UnitTypeID`** ·
`SortNumb` · `LostQuoteDesc` · `AwardDate` · `CreatedDate` · `ModifiedDate`

The shorter `SOURCE_Quotes` export is a 24-column subset of the same, dropping the codes and
keeping the display names.

**Five observations that bear on the ERP:**

- **`QuoteMin` and `QuoteMax` are both real, populated columns**, and every dashboard in this
  workbook sums **`QuoteMax`** as "quote dollars". So whatever they mean, `QuoteMax` is the
  business's working value of a quote. TCG asked twice what they are for and concluded they might
  be unnecessary ([erp-review-log.md](../erp-review-log.md) → *#9*, *#13*, and *Quotations, jobs
  and projects*), and the FCC manual does not define `Quote Min` either
  ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §2). **Removing them would remove the
  field these reports run on.**
- **`Jobcode` on the quote is what joins to the invoice.** `BACKEND_Control` states the join:
  *"Quote Status `Jobcode` matched to Invoice `JobCode`"*. So the quote carries the job number
  once converted, matching the FCC manual's `Converted To Job` field.
- **A quote is scoped by `CompanyCode`, `DeptCode` and `YardCode`** — the three fields the FCC
  quote screen asks the user to verify first.
- **`UnitTypeID` is on the quote header** — a single primary unit type per quote, which is
  consistent with estimate templates keying off *"the primary crane/vehicle selected"*.
- **`LostQuoteCode` + `LostQuoteDesc` + `LostComments`** are three separate fields. Observed
  descriptions in the data: **`Lost - Customer Not Awarded`** and **`Lost - Price too High`**.
  Observed `QuoteStatusCode` values: **`WON`**, **`PEND`**, **`LOST`** (with `Description` `Won` /
  `Pending` / `Lost`). Observed `DeptName`: **`OPERATED & MAINTAINED`**.

**The invoice export is much thinner — 8 columns:** `InvoiceCode` · `JobCode` · `InvDate` ·
`Name1` · **`PoNumb`** · `InvoiceBeforeTax` · `SalesPersonName` · `CustCode`. Note `PoNumb` on the
invoice, which is where the customer PO surfaces
([quote-lifecycle-permits-and-purchase-orders.md](quote-lifecycle-permits-and-purchase-orders.md)
§2, *"Reference it on our invoice"*), and that an invoice code observed in the data is prefixed
`MYOM-` against a job code prefixed `OM`.

### 2.3 The dashboards

Twenty visible sheets. What each measures, without the numbers:

| Sheet | Measures |
| --- | --- |
| `Executive Summary` | Total billed revenue · total invoiced jobs · total quotes · total quote dollars · **reactive revenue ≤ $30k vs proactive revenue > $30k** and proactive % · 90-day customer trend windows · count of large lost quotes > $30k · per-salesperson revenue/quote dollars/win rate · monthly revenue and job counts · a safety intelligence block |
| `Quote to Invoice Flow` | Quote-status rows · quotes with a jobcode · **matched to invoice** · not found in invoice file · matched invoice revenue · **match rate**, overall and per salesperson |
| `Quote Invoice Detail` | Per quote: match status, quote status, quote job start, **first and last invoice date, days to first invoice, invoice count**, matched revenue, the invoice codes |
| `Rep Scorecard` / `Rep Snapshot` | Per salesperson: total quotes, quote dollars, wins, losses, **quote win rate**, average quote size, total jobs, billed revenue, reactive/proactive split, and a coaching label |
| `Reactive vs Proactive` / `Proactive Billed Jobs` | The $30k split, and the list of proactive jobs |
| `Customer Intelligence` | Customer-level invoice revenue, % of revenue, trend windows |
| `Geographic Heat Map` | **City-level grouping** of quote/invoice location |
| `Crane Size Metrics` / `Crane Size Training` | Revenue and activity by crane size; training implications |
| `Large Lost Jobs` | Lost quotes > $30k — *"Training/post-mortem list"* |
| `Upselling Metrics` | Upsell tracking |
| `Field Safety Audits` / `Safety Crew Metrics` / `Safety Advanced Metrics` / `Safety Audit Raw Data` | Good habits · **OFI / corrective habits** · corrective actions · unique cranes audited · most-audited crane · per-crew and per-observer metrics |
| `Training Roadmap`, `Source Audit`, `Dashboard QA` | Governance sheets |

**Two derived business rules are stated in the workbook's own labels**, and appear nowhere else:

- **A job is "Reactive" at or below $30,000 and "Proactive" above $30,001.** That threshold drives
  the executive summary, the rep scorecards and a whole dashboard.
- **Large lost jobs are those over $30,000**, and they are explicitly a *"training/post-mortem
  list"*.

### 2.4 The backend layer — and its own admissions

`BACKEND_Control` maps each dashboard to its sources and join logic. `BACKEND_Data_Dictionary`
maps 17 raw fields to the dashboard areas that use them, with a *Refresh Sensitivity* rating.
Notes worth carrying: *"Each row represents a quote line/opportunity"*; *"Won/lost logic is based
on status/description rules used during build"*; *"**Customer names may need cleanup for
duplicates/variants**"*; *"Invoice-side rep metric can exceed quote count due to repeat
dispatches/invoices"*.

**`BACKEND_Reconciliation` runs 13 self-checks and four of them do not pass.** Reproduced without
figures:

| Check | Status | The workbook's own note |
| --- | --- | --- |
| Total quote rows / total quote dollars | **PASS** | |
| **Invoice rows vs Rep Scorecard total jobs** | **CHECK** | a difference of several hundred rows |
| **Total billed revenue vs Rep Scorecard billed revenue** | **CHECK** | a multi-million-dollar difference between `InvoiceBeforeTax` and the dashboard figure |
| **Customer revenue total** | **CHECK** | same difference again |
| Customer % of revenue | PASS | |
| **Geographic revenue total** | **REVIEW** | *"Geographic total should be reviewed **if location source is quote-based rather than invoice-based**"* — the two differ by tens of millions |
| Quote-to-invoice checks (5) | PASS | |
| Safety checks (2) | PASS | |

**Backend health as the workbook reports it: 13 checks, 9 PASS, 3 CHECK, 1 REVIEW.**

> **Anyone using this file's numbers must read that sheet first.** Total revenue is reported two
> different ways within the same workbook, and the geography sheet is mixing quote-based and
> invoice-based location. The file says so itself.

## 3. The Sales Dispatch Sheet

A manual crane-by-day board. **Sheets:** `Metrics` · `Month Navigator` · **37 month tabs, `Jun
2026` through `Jun 2029`** · `Lists` · `Metrics Calc`.

**Each month tab** is `Crane × Day`, one column per calendar day (with weekday labels), and
**six rows per crane**:

`Status` · `Job Location / Notes` · `City` · `Permit Time` · `Scheduled Hours` · `Support Trucks`

Cranes are identified by **unit number** (`4001`, `4002`, … — the same numbering the safety audit
data uses).

**The `Lists` sheet holds four vocabularies:**

| List | Values |
| --- | --- |
| **`Status`** | `Scheduled` · `Saved` · `Tentative` · `Hold` · `Canceled` · `Maintenance` · `DISPATCHED` |
| `Scheduled Hours` | 1–24, plus `Custom` |
| `Support Trucks` | 0–20 |
| `City` + `Permit Turnaround` | a second copy of the ~98-city permit lead-time list |

**The `Metrics` sheet defines seven utilisation measures**, each with a stated *"CFO Read"*:

| Metric | Definition given |
| --- | --- |
| **Expected Hours** | *"Total booked hours **excluding canceled/maintenance**"* |
| **Confirmed Scheduled Hours** | *"**Only status = Scheduled**"* |
| **Pipeline Hours** | *"**Saved + tentative + hold** hours"* |
| Canceled / Maintenance Hours | *"Hours blocked by **red statuses**"* |
| Active Crane Days | *"Crane-day boxes with **green/yellow active status**"* |
| **Fleet Utilization %** | *"**Active crane-days / available crane-days**"* |
| Support Trucks Planned | Support trucks committed in the selected period |

It computes Daily / Weekly / Monthly views from a selected date and month, and a 36-month trend of
expected hours, confirmed hours, utilisation % and support trucks.

**Three things this pins down.** The seven-value status vocabulary is a **scheduling state
machine** distinct from both the quote statuses and HubSpot's stages, and it distinguishes
*Scheduled* from *DISPATCHED*. **`Tentative` and `Hold` are the "placeholder" states** the
Executive Playbook's Yellow Path creates
([sales-operating-system/06-value-engine-flow-and-lead-workflow.md](sales-operating-system/06-value-engine-flow-and-lead-workflow.md)).
And **fleet utilisation is defined here** — active crane-days over available crane-days — which is
a metric the vault otherwise does not define.

**The board is essentially empty in the delivered copy** (the Metrics sheet reports a single
`Canceled` and four `Maintenance` entries against 36 months of grid), so it is a **template rather
than a record of operations**.

## 4. Sales Admin 60 day training

**Sheets:** `Dashboard` · `Daily View` · `Master Schedule` (1,921 rows) · `Certifications` ·
`Training Gap Log` · `Fleet Training Cards` · **`FCC SOP Training Guide`** · **`Step Library`** ·
`Resource Library` · `README - How To Use` · `Lists`.

**The `Step Library` is the substantive part** — 60 rows of `Track | Step | Detailed Action | Pass
Criteria | Source / Link`, across five tracks:

| Track | Steps | Source cited |
| --- | ---: | --- |
| **Customer Intake** | 10 | *FCC SOP pages 1-3* — greeting and caller control, crane setup location, site obstructions, item being lifted, item weight, **dimensions**, **radius calculation**, lift height, photos and documents, **lead recap** |
| **FCC Quote SOP** | 16 | `Creating Quotes SOP (1)(3).pdf` — reproduced in [tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md) §9 |
| **3D Lift Planner** | 12 | vendor site and video searches — open and navigate · create project · enter jobsite basics · **add site background** · **set scale/orientation** · place crane · select crane family · **configure boom/jib** · enter load · **check radius and capacity** · create lift path · **export lift plan** |
| **HubSpot CRM** | 9 | HubSpot Academy / Knowledge Base — navigate · create contact · create company · **create deal** · log call/email · create task · **update pipeline** · follow-up cadence · reporting hygiene |
| **Fleet Knowledge** | 13 | manufacturer / fleet internal notes — one step per crane model |

**The fleet, as the training names it** (13 models): Manitex **22101S**, **3051T**, **40124SHL** ·
Link-Belt **RTC-8090 II**, **RTC-8690** · Liebherr **LTM 1040-2.1**, **LTM 1100-5.3**, **LTM
1160-5.2**, **LTM 1220-5.2**, **LTM 1230-5.1**, **LTM 1300-6.2** · Grove **GMK6300L-1**,
**GMK7550**.

**The `Resource Library`** lists 20 external references — HubSpot Academy and Knowledge Base pages,
OSHA's cranes-and-derricks page, NCCCO's video library, 3D Lift Plan's vendor site, and the four
manufacturers' sites — plus one internal: `FCC-SOP`, *"The Crane Guys Creating Quotes SOP…
**Internal SOP uploaded by Ryan; exact FCC quote process**"*.

**How the workbook is meant to be used** (`README`): the Master Schedule takes **Yes / No / In
Progress / N/A** against **Task Pass, Video Complete and Manager Signoff** per task; colours are
*"Green = Yes/Complete, Red = No/Gap, Yellow = In Progress/Open, Orange = N/A"*; *"Any **No** or
repeated **In Progress** should be entered into **Training Gap Log** with corrective action."*

**The `Training Gap Log` is empty** (header row only), and the `Master Schedule` is a blank
template.

## 5. Follow Up Customers — the win-back list

**Sheets:** `Dashboard` · `Customer Entry` (961 rows) · `Salesperson Scoreboard` ·
`Follow-Up Tracker` (992 rows) · `Success Log` (1,915 rows) · `Lists` · `Instructions` ·
`Address Merge Audit`.

Header: *"THE CRANE GUYS - CUSTOMER WIN BACK COMMAND CENTER. Final **inactive-only** win-back
dashboard. **Active/recent customers since 1/31/2026 were removed using company-name matching**,
including near-identical company families."*

**`Customer Entry` — 36 columns**, and this is the schema of a win-back target:

`Priority Rank` · **`Opportunity Tier`** · **`Total Historical Quoted Dollars`** · `Outreach Need`
· `Company Name` · `Contact Name` · `Title` · `Main Phone` · `Work Phone` · `Cell Phone` · `Email`
· `City` · `State` · **`Industry Code`** · **`Last Quote Date`** · **`Quote Count`** ·
`Last / Common Salesperson` · `Assigned Salesperson` · `Outreach Status` · `Contact Method` ·
`Revenue Priority` · `Date Reached Out` · `Reached Out Completed?` · `Outcome` · `Notes` ·
`Next Follow-Up Date` · `Next Follow-Up Time` · `Follow-Up Needed?` · **`Days Until Follow-Up`** ·
`Address 1` · `Address 2` · `Address City` · `Address State` · `Address Zip` ·
`Full Drive Address` · `Address Match Status`.

**The vocabularies** (`Lists` sheet):

| List | Values |
| --- | --- |
| **Opportunity Tier / Revenue Priority** | `A - Highest Priority` · `B - Strong Opportunity` · `C - Nurture / Reconnect` (Revenue Priority's third value reads `C - Standard Follow-Up`) |
| **Outreach Status** (pipeline) | `Not Contacted` · `Contacted / Waiting` · `Follow-Up Needed` · `Meeting Scheduled` · `Quote Requested` · `Won Back` · `Unsuccessful` · **`Do Not Contact`** |
| **Outreach Status** (per-attempt) | `Not Contacted` · `Called - No Answer` · `Voicemail Left` · `Email Sent` · `Spoke with Contact` · `Meeting Scheduled` · `Quote Requested` · `Won Back` · `Not Interested` · `Future Opportunity` · `Bad Contact Info` |
| **Contact Method** | `Phone Call` · `Email` · `Text` · **`LinkedIn`** · `In-Person Visit` · `Referral` · `Other` |
| **Outcome** | `No Answer` · `Left Voicemail` · `Email Sent` · `Spoke with Contact` · `Meeting Scheduled` · `Quote Requested` · `Won Back` · `Not Interested` · `Future Opportunity` · `Bad Contact Info` · `Unsuccessful` |
| Salespeople | a 13-name roster |

**Instructions**: work from Priority Rank #1 down · assign a salesperson (*"This drives the
scoreboard and accountability"*) · record each attempt · enter a next follow-up date and time
(*"The workbook automatically marks **Scheduled, Due Today, or Overdue**"*) · manage from the
Dashboard.

**Two things worth noting for the ERP.** *"Do Not Contact"* is a **suppression state** on a
customer, which nothing in the vault models. And the whole workbook is a manual reimplementation
of **pipeline follow-up on lapsed customers** — which is what TCG asked FCC for on slide 13 of the
billing-codes review: *"we need **detailed information on 'Pending Quotes' so we can follow-up**"*
([fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §5).

The `Dashboard` also reports its own data-quality state: a count of *"Active Companies Removed"*,
*"Inactive Targets Remaining"* and *"Potential Match Review Items"* — the name-matching used to
strip active customers left a review queue. Several `#REF!` errors are present in the delivered
copy.

## 6. What the formulas add (read 2026-09-04)

**KPI tracker.** The dashboards hold **no formulas** — every tile is a pasted value. The only
live logic is `BACKEND_Reconciliation` (82 formulas): it counts/sums the `SOURCE_*` sheets and
compares each to the dashboard figure with `IF(ABS(diff) <= 1, "PASS", "CHECK")` (or `"REVIEW"`),
and `Executive Summary!B99` reads *"Connected / Clean"* only when the CHECK + REVIEW count is
zero. So "backend connected" means: the pasted numbers still reconcile to the pasted sources
within ±1. The 3 CHECK + 1 REVIEW failures noted above are those tolerances being breached.

**Sales Dispatch Sheet.** 32,900 formulas, almost all on the month boards (871 per month, 4
patterns) and the hidden **`Metrics Calc`** sheet. Per month: revenue = `SUMPRODUCT` of the
revenue row where the status row is neither `Canceled` nor `Maintenance`; scheduled revenue =
same where status = `Scheduled`; booked count = cells in any of `Scheduled · Saved · Tentative ·
Hold`. The visible `Metrics` sheet (310 formulas, 118 patterns) filters by a date window
(`$B$6:$B$7`) and a crane (`$E10`) with `INDIRECT` into the chosen month. Status vocabulary in
code: `Scheduled · Saved · Tentative · Hold · Canceled · Maintenance`.

**Follow Up Customers.** `Customer Entry!AB` derives a follow-up state from the next-contact date
`Z`: **`No Date` · `Overdue` (past) · `Due Today` · `Due This Week` (≤ 7 days) · `Future`**; `AC` =
days until. The `Dashboard` and `Salesperson Scoreboard` are `COUNTIF`/`SUMIF` over that column
and over `S` (outcome: `Won Back`, `Meeting Scheduled`, `Quote Requested`, `Not Contacted`),
`W` (`Yes` = contacted) and `R` (salesperson); conversion = won-back ÷ assigned. One dashboard
formula (`A17`) references `#REF!` — a broken link left in the file.

## Source

All four under `3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/`,
converted as per-sheet row dumps:

- `RYAN_ADAMS_KPI_TRACKER_BACKEND_CONNECTED.xlsx` — 7.6 MB of text, 29 sheets. Sheet inventory,
  source map, export column schemas, metric definitions, code values and the reconciliation
  outcomes are captured. **Not copied:** 8,055 quote rows, 6,594 invoice rows, 6,473 quote-status
  rows, 6,473 quote-invoice detail rows, 477 field-audit rows, 1,121 geographic rows, 541
  customer-intelligence rows, 376 lost-job rows — and **all per-salesperson performance figures**,
  which are named individuals' performance data.
- `Follow Up Customers - With Addresses (1).xlsx` — 467 KB, 8 sheets. **Not copied:** 961 customer
  rows and 992 tracker rows, each carrying **named contacts, direct phone numbers and email
  addresses**.
- `Sales Dispatch Sheet.xlsx` — 152 KB, 42 sheets. **Not copied:** the 37 month grids (~173 rows ×
  33 columns each) and the second copy of the 98-city permit list.
- `Sales Admin 60 day training.xlsx` — 866 KB, 11 sheets. **Not copied:** the 1,921-row Master
  Schedule.

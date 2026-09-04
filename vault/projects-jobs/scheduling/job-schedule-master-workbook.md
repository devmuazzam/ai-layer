---
title: Job Schedule Master — the permit-aware scheduling workbook
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__Job Schedule Master (from Ryan 2026-08-11)/Job Schedule Master.xlsx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/dispatch, module/assets, kind/reference, scheduling, permits, daily-allocation, architecture, reporting]
entities: []
---

# Job Schedule Master — the permit-aware scheduling workbook

**What this is.** A single Excel workbook, live-dated **2026-08-11 09:20**, titled
*THE CRANE GUYS — PERMIT-AWARE JOB SCHEDULER*. It is the Scheduling Sheet referred to throughout
the playbooks, and it is the closest thing in this drop to a **working specification of the
scheduling behaviour TCG wants**: it takes a requested date, crane, city, start time and hours, and
computes a Green / Yellow / Red permit path and a latest permit-submission deadline automatically.
48 sheets: 4 front-end sheets, **36 monthly dispatch boards** (Jun 2026 → Jun 2029), and 8 data and
reference sheets. **The board data was not copied** — the workbook shipped empty of live jobs.

This page records its structure and, more importantly, **the rules it states about itself**. Those
rules are on a sheet called `HOW TO USE`, and several of them are not written down anywhere else in
the drop.

## The front end

`SCHEDULER COMMAND CENTER` (A1:H34). Five **scheduling inputs** on the left, ten **automatic
decisions** on the right.

| Inputs | Automatic decision fields |
| --- | --- |
| Requested Job Date · Crane · City / Community · Desired Start Time · Scheduled Hours · Customer / Job # | Crane Calendar Status · **Crane Availability** · **Annual / Blanket Permit** · **Permit Lead Time (Days)** · **TCG Planning Lead Time** · **Countable Permit Days Left** · **Latest Permit Submission** · **Permit Rules / Restrictions** · **FINAL PATH** |

The header carries a live **`Permit Clock`** indicator (`OPEN` in the shipped copy) alongside the
live date and time. The worked state the workbook shipped in: job date 2026-08-16, crane `35001`,
city Anaheim, 08:00, 8 hours → *Crane Availability: UNAVAILABLE*, *Annual/Blanket: NO ACTIVE
ANNUAL*, *Permit Lead Time: 2 DAYS*, *TCG Planning Lead Time: 1 DAYS*, *Countable Permit Days Left:
3*, *Latest Permit Submission: 2026-08-12 17:00*, *Permit Rules: "No active annual/blanket permit —
use city lead-time rule"*, **FINAL PATH: `RED - CRANE UNAVAILABLE`**.

It also shows four **permit metrics** — Current/Valid 182 · Expiring ≤60 days 32 · Expired latest
records 114 · **Active Blanket 5** — and a quick-navigation block to the other sheets.

Three supporting front-end sheets:

- **`Metrics`** (A1:H11) — per selected month: Scheduled Crane-Days · Committed/Held Crane-Days ·
  Scheduled Hours · **GREEN Permit Paths · YELLOW Permit Paths · RED Permit Paths**. All zero in the
  shipped copy.
- **`PERMIT & ASSET LOOKUP`** (A1:H18) — pick a crane and a city; returns crane size/type,
  manufacturer/model, serial, plate, axle count, loaded height/width/overall length, front and rear
  overhang, axle spacing, maximum allowable axle weights — and, for the city, **Annual / Blanket
  Coverage Today (YES/NO)**, Permit Lead Time, TCG Planning Days, and the Permit Restrictions text.
- **`Month Navigator`** (A1:H13) — a 4-across grid of the 36 month sheets.

## The monthly dispatch boards

36 sheets, `Jun 2026` through `Jun 2029`, each A1:AD341 to A1:AG341 depending on month length. Each
is headed *THE CRANE GUYS — <MONTH> PERMIT-AWARE DISPATCH BOARD* with the rule restated in the
header row: **"Thu after 12 PM + Fri/Sat/Sun do not count toward permit lead time."**

Layout: one column per calendar day (with the weekday name under the date), and a **12-row block per
crane**:

`Status` · `Customer / Job #` · `Job Location / Notes` · **`Salesperson`** · **`Sales Admin`** ·
`City` · `Start Time` · **`Permit Path`** · **`Permit Lead Time / Deadline`** ·
**`Permit Rules / Restrictions`** · `Scheduled Hours` · `Support Trucks`

**26 crane blocks × 12 rows = 312 rows** plus headers, hence the 341-row sheets. The crane blocks
are colour-banded so unit boundaries are obvious; the workbook says the **Permit Path green/yellow/red
still overrides the band**.

## The rules the workbook states about itself

Transcribed from the `HOW TO USE` sheet (A1:H26), which is the authoritative statement of this
behaviour in the drop.

**Order of operations.** Start on `SCHEDULER COMMAND CENTER`; choose the real requested job date,
crane, city, start time and hours. Read the path: **GREEN = permit-ready and available. YELLOW =
action / review required. RED = do not schedule.**

**Permit clock rule.** *"Monday–Wednesday count. Thursday counts only before 12:00 PM. Thursday
after noon, Friday, Saturday, and Sunday do not count toward permit scheduling lead time."*
This matches [dispatch-scheduling-path.md](dispatch-scheduling-path.md).

**Annual / blanket permits.** *"A valid crane-specific annual permit covers that crane. A valid
BLANKET permit covers every crane in the fleet for that city. **Permit validity is tested against
the requested future job date**"* — not against today.

**Restrictions.** *"Active permits with special operating rules are **intentionally routed YELLOW**
so Dispatch/Sales Admin reviews the restriction text before committing the job."* **No playbook
states this rule.** It means a job can be Yellow while fully permitted.

**Availability.** *"The front scheduler reads the actual month/date/crane status from the monthly
board. **Scheduled, Saved, Tentative, Hold, and Maintenance are treated as unavailable; blank or
Canceled is available.**"*

**Permit lead-time display rule.** *"For every crane/day, selecting a city displays the city permit
lead time in days and the latest submission deadline. If that crane (or a fleet-wide BLANKET permit)
has an active annual permit on the selected job date, the row displays **"ANNUAL ACTIVE — 0 DAYS"**
instead."*

**Colour / date logic — v3.**

- **GREEN:** crane-specific **or BLANKET** annual permit is valid on that **exact** job date.
  Permit notes stay visible but do not automatically turn the job yellow.
- **YELLOW:** no active annual/blanket permit on that job date, **but enough permit-processing time
  remains**.
- **RED:** **crane unavailable**, **city missing from rules**, **past job date**, or **permit
  lead-time window missed**.
- *"All permit checks use the actual date at the top of each calendar day, not simply today's permit
  status."*

**Team ownership + crane banding — v4.** Every crane/day carries **Salesperson** and **Sales Admin**
dropdowns, maintained on the `TEAM LISTS` sheet.

**Permit applications.** Use `ASSET MASTER` for VIN/serial, plates, dimensions, axle data, weights
and current major-agency permit information when ordering a new permit.

## Where the workbook's rules differ from the playbooks

| | Playbook says | Workbook says |
| --- | --- | --- |
| **GREEN** | The city's standard **72-hour** lead time is satisfied | An **annual or blanket permit is already valid** on that job date |
| **YELLOW** | A longer city-specific lead time (>72 h to 10 days) is satisfied | **No** annual/blanket, but enough processing time remains — **or** a valid permit carries special restrictions needing review |
| **RED** | The applicable lead time is not available | Lead-time window missed **plus** crane unavailable, city missing from rules, or a past job date |

**These are not the same three definitions.** The playbook's colours are about *lead time*; the
workbook's are about *whether a permit already exists*. A job that is Green under the workbook (has
an annual) could be Red under the playbook (booked inside 72 hours), and vice versa. The drop does
not reconcile them and does not say which governs.

## The data sheets

| Sheet | Dimensions | Content |
| --- | --- | --- |
| `PERMIT RULES MASTER` | A1:H501 | **500 jurisdictions**, identical columns and content to the `Local 12 City List` sheet of `City List turn around - Ben.xlsx` — see [../city-permits/permit-lead-times.md](../city-permits/permit-lead-times.md). This is what the path calculation reads. |
| `ANNUAL PERMIT MASTER` | A1:O336 | **335 annual/blanket permit records.** Columns: `Crane / Scope`, `Crane Type`, `Plate / Applicability`, `City / Agency`, `Permit Type`, `Permit #`, `Valid From`, `Expires`, `Days Remaining`, `Current Status`, `Route / Coverage`, `Restrictions / Special Rules`, `Source File`, `Verified`, **`Restriction Flag`** (`REVIEW` / `STANDARD`). The mirror of the Permit Tracker's master table — see [../city-permits/permit-tracker-workbook.md](../city-permits/permit-tracker-workbook.md). `Restriction Flag` is what drives the "route restricted permits YELLOW" rule. |
| `ASSET MASTER` | A1:AJ30 | **29 fleet units × 36 columns** of permit-application data: crane number, size/type, manufacturer/model, serial, plate, axle count, vehicle description, widths, kingpin-to-last-axle, combined and loaded lengths, loaded height/width, front and rear overhang, tires per axle, axle spacing, axle widths at tire sidewall, maximum allowable axle weights; then current Caltrans permit number and dates and travel/pilot-car notes; then LA City permit number, dates, gross weight (tons) and configuration notes; then LA County permit number, dates and coverage/restrictions — each with its source file. **Row data not copied.** |
| `DATA INTEGRITY REVIEW` | A1:F15 | Flags assets present in one source but not the other. *"No unit mapping was guessed."* In Permit/Asset Master but not the Scheduler: `6001`, `6002`, `WIDE LOAD`. In the Scheduler but with no Asset Permit Profile: `65 RT`, `90 RT`, `55001`, `Crawler` — "add VIN/plate/dimensions when available; permit checks still use annual/blanket records." |
| `HOW TO USE` | A1:H26 | The rules quoted above |
| `Lists` | A1:D500 | Four validation lists: **Status** (`Scheduled`, `Saved`, `Tentative`, `Hold`, `Canceled`, `Maintenance`), the crane list, the 500-city list, and the 36-month list |
| `TEAM LISTS` | A1:D51 | Salesperson dropdown (`Unassigned`, Jason, Joe D, Chris, Taylor, Brian, Adam, David) and Sales Admin dropdown (`Unassigned`, David, Hailee), with maintenance instructions |

## What is worth carrying into the product

Stated by the workbook, not inferred:

- Permit validity is tested **against the job date**, not today.
- A **blanket** permit covers the whole fleet for a city; a crane-specific annual covers one unit.
- Five crane statuses block availability (`Scheduled`, `Saved`, `Tentative`, `Hold`, `Maintenance`);
  blank and `Canceled` do not.
- **`City missing from rules` is itself a RED condition** — an unknown jurisdiction is a hard stop,
  not a default.
- A permitted job with restriction text still needs a human to read the restriction before it is
  committed.
- Every crane/day carries a named **Salesperson** and **Sales Admin**.
- The board's per-day fields include `Support Trucks` and `Job Location / Notes` alongside the
  permit fields.

## The formulas — how the workbook actually decides (read 2026-09-04)

The 95,292 formulas were dumped and reduced to their distinct patterns. Everything above was
written from the workbook's labels and values; this is what the cells compute.

**The permit clock (`SCHEDULER COMMAND CENTER!E11`).** Business days until the job are
`NETWORKDAYS.INTL(TODAY(), jobDate − 1, "0000111")` — a **Monday–Thursday week**: Friday,
Saturday and Sunday are all non-working days for permit purposes — **minus one more day if today
is Thursday and it is past 12:00**. `H3` shows *"CLOSED — resumes Monday"* on Friday–Sunday and
on Thursday afternoon, *"OPEN"* otherwise. That is the exact form of the *"Monday–Wednesday
count, Thursday only before noon"* rule quoted above.

**Crane availability (`E6:E7`).** `INDEX/INDIRECT` into the month sheet named by the job date
(`'Jun 2026'!C:AG`) at the crane's row and the day-of-month column; blank or `Canceled` →
*AVAILABLE*; any other value → *UNAVAILABLE – <status>*; a date with no month sheet → *CHECK
DATE*.

**Permit check (`E8:E10`, `E12:E13`, and `C13:C15` on every month board).** One `SUMPRODUCT`
against `ANNUAL PERMIT MASTER`: a permit counts when its `Crane / Scope` equals the crane **or is
`BLANKET`**, its `City / Agency` equals the job's city, `Valid From ≤ jobDate ≤ Valid To`, and its
`Permit Type` is `Annual` or blanket. `E13` then pulls that permit's restriction text (column
`L`) with `LOOKUP(2, 1/(…))` — last matching row wins. On the month boards the same test runs per
crane-row block (rows 13/14/15 of each 12-row crane block: path, permit-present flag, restriction).

**The status line (`E16`).** In order: no date/crane/city → *ENTER JOB DATE, CRANE & CITY*;
`jobDate < TODAY()` → **RED – JOB DATE IS IN THE PAST**; crane not AVAILABLE → **RED – CRANE
UNAVAILABLE**; annual/blanket found → the GREEN/YELLOW/RED wording described above; otherwise
the city's lead time from `PERMIT RULES MASTER` is compared with the business-day count.

**`Metrics`.** Counts per month sheet of cells equal to `Scheduled` (and, for "booked", any of
`Scheduled · Saved · Tentative · Hold`), sums of the revenue rows, and counts of `GREEN*` /
`YELLOW*` / `RED*` path cells across the twelve crane blocks — so the dashboard's colour totals
are literally counts of the path strings, and a crane block starts every twelve rows (rows 6,
18, 30 … 138).

**`PERMIT & ASSET LOOKUP`.** `ASSET MASTER` lookup for the crane's description; the same
annual-permit test against `TODAY()`; and `PERMIT RULES MASTER` columns 2 and 8 for the city's
stated lead time and notes.

**Data validation lists** (defined names): `StatusList` = `Lists!A1:A6`, `CraneList` =
`Lists!B1:B28` (28 crane rows), `CityList` = `Lists!C1:C500`, `MonthList` = `Lists!D1:D37`; the
`Lists` sheet is hidden.

Consequences for the ERP: the workbook's notion of "days available" excludes Fridays outright,
which no playbook states; "blanket" permits are treated as matching every crane; and the
restriction text shown to the scheduler is whichever matching permit row is *last* in the
master, not the most specific.

## Source

`3.1.1_MODULE-CRM-SALES-QUOTES/__Job Schedule Master (from Ryan 2026-08-11)/Job Schedule Master.xlsx`
— 48 sheets, ~456 KB of extracted text, `.xlsx` → per-sheet row dump. Live date stamp inside the
file: **2026-08-11 09:20:19**. **The 36 monthly boards shipped with no scheduled jobs** (every
`Metrics` count is zero), so no job data exists to copy. The 500 permit-rule rows, 335 annual-permit
rows and 29 asset rows were **deliberately not copied** — column headers, closed vocabularies and
stated rules are above.

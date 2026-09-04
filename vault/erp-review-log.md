---
title: TCG ERP review log — client feedback register, all modules
source: shared-folder/Project-Repository-2026-09-04/THE CRANE GUYS - ERP REVIEW LOG.xlsx
migrated: 2026-09-04
updated: 2026-05-05
status: unverified
conflicts_with: []
jira: []
tags: [module/all, kind/source, requirements, open-questions, reporting, permissions-roles, pricing, scheduling, safety, permits]
entities: []
---

# TCG ERP review log — client feedback register, all modules

**What this is.** A workbook TCG maintains as the single log of everything its own people have
asked the ERP to do. It sat loose at the root of the 2026-09-04 Project Repository drop, outside
every numbered archive. Three sheets: a **hand-written log** of 14 dated entries by named TCG
staff (2026-03-18 → 2026-05-05, plus one undated), an **AI-generated extraction** of 69 tracking
items from the 2026-05-05 meeting, and the **validation lists** that drive the log's dropdowns.

**Why it matters.** It is the only artefact in the vault that shows the client's requirements as
*they* recorded them, in their own words, across every module at once — before anything was
sliced into Jira. Several entries state rules the vault holds nowhere else, and several
predate or cut across what was later built. Nothing here has been adjudicated.

> **Status caution.** The log's own `Feedback Type`, `Priority` and `Status` columns are **empty
> for every one of the 14 hand-written rows**. Nothing in this file tells you whether any item
> was accepted, built, rejected or superseded. Do not read an entry as a live requirement without
> checking it against the module's own pages and the decisions folder.

---

## Sheet 1 — the hand-written log

14 rows. Columns are `Module | # | Date | Crane Guys Name | Screen / Feature | Feedback Type |
Priority | Description | Screenshot / Link | CodingCops Response | Status` — of which only
Module, #, Date, Name and Description are ever filled in. Rows 15–103 are empty numbered
placeholders.

| # | Date | Who | Module | What they asked for |
| ---: | --- | --- | --- | --- |
| 1 | 2026-03-18 | Melissa | Dispatch | The system should **text crew directly with a link they can confirm their work** on |
| 2 | 2026-03-31 | Melissa | Quotations | Sent current forms and a sample lift plan packet |
| 3 | 2026-04-02 | Melissa | Accounting | **Automatic customer packet generation** — see below |
| 4 | 2026-04-08 | Melissa | HR | **Union rules to enforce** — see below |
| 5 | 2026-04-18 | Melissa | Dispatch | A **"time verified by GPS"** click-button / checkbox on the job |
| 6 | 2026-05-02 | Melissa | Employees | 9 employee-screen items — see below |
| 7 | 2026-05-02 | Melissa | Asset Management | 6 asset items — see below |
| 8 | 2026-05-02 | Melissa | Customers | 4 customer items — see below |
| 9 | 2026-05-02 | Melissa | Quotations | 8 quote items — see below |
| 10 | 2026-05-02 | Melissa | Billing Codes | 3 billing-code items — see below |
| 11 | 2026-05-03 | Melissa | Safety | Safety must be in the initial build — see below |
| 12 | 2026-05-04 | Corrina | HR | 5 further employee-section items — see below |
| 13 | 2026-05-05 | Ryan | Sales | 5 quote/dispatch notes — see below |
| 14 | *(undated)* | Joe S. | Dispatch | Notify dispatch of each employee's schedule when they are **working more than 10–12 hours**, and of the **time between scheduled jobs/labor**; also notify employee location |

### #3 — Automatic customer packets (Accounting, Melissa, 2026-04-02)

> "Please see the attached sample packets that we have to send to different customers. We would
> like a feature to where these packets can be created automatically. Maybe we create a template
> type for customers where it can pull in all the date. For some customer they do require
> additional forms( waivers ) as well as vendor invoice copies. I also added a copy of our labor
> compliance sheet, this is used by the sales guys and labor compliance. We briefly spoke about
> certified payroll, if there is a feature to where a salesmen can make the job as certified
> payroll the system will prompt them to answer the questions on this sheet."

Three distinct asks: a **per-customer packet template** that assembles the right documents
automatically; **customer-specific extra forms** (waivers, vendor invoice copies) as part of that
packet; and a **certified-payroll flag on the job that prompts the salesperson** through the
labor-compliance questionnaire at quote time.

The sample packets referenced here are the six invoice packets in the same drop
(`TCG_FORMS_(paper_and_electronic)/from Melissa 2026-04-02/`), and the labor compliance sheet is
`Pre-Job_Labor_Compliance_Information_Request_Form_final_polished[48].pdf`.

### #4 — Union rules to enforce (HR, Melissa, 2026-04-08)

Sent with the Master Labor Agreement and the Local 12 Truck Crane Agreement, described as
"**sample** union rules we need incorporated into the system… These are just a few!" — so this is
an illustrative list, not the complete rule set.

- **Holiday pay** is an 8-hour minimum at **triple time**.
- **Union holiday pay for union meetings** — **double time**, 8-hour minimum.
- **Last-crew entitlement.** "The last crew on the equipment on straight time is entitled to the
  overtime work." Worked example as written: Bob and Tom are on Crane 9001 and AT05 for a day job
  06:00–11:00; a night job comes in for the same crane at 19:00 — Bob and Tom are entitled to it
  because their crane is going. **Dispatch has to offer the job to them before giving it to
  anyone else**; if it does not, "we could be liable to pay all 4 employees." The same applies to
  a Friday job carrying entitlement to Saturday. **Entitlement is to the next shift only** — a
  Friday crew is not entitled to Sunday work. *The ask: the system notifies dispatch that an
  action item is required before scheduling.*
- **Dispatch tier order.** Tier 1 Operators → Tier 2 Oilers → Tier 3 Apprentices → Tier 4 Fill-ins.
  *The ask: notify dispatch if it tries to send a lower tier before all of a higher tier have been
  asked* — worked example given is a Tier 4 going out before all Tier 2 employees are asked.
- **Anytime before 06:00 is overtime, and after 17:00.**
- **Job cancels after the employee leaves the yard** → paid a **4-hour minimum**.
- **Job cancels before they leave the yard** → paid a **2-hour minimum**.
- **Holdover jobs** are an 8-hour minimum for work days; **the first and last day are hourly**.
- **Shift work requires a letter to the union.** *The ask: a shift-work button on the project with
  a pop-up reminding the salesperson and HR.*

> Cross-check these against [payroll/rules/](payroll/rules/INDEX.md) before treating any of them
> as settled — several are stated more precisely there, and the tier order and last-crew rule are
> dispatch behaviour that the payroll register does not cover.

### #6 — Employees (Melissa, 2026-05-02)

1. Update the logo top-left to the circle logo. 2. Show icon names on hover over the left
toolbar. 3. **There is no back button** to return to the previous page. 4. Employee birthday
cannot be typed, only scrolled — **add type-in capability**. 5. Automatic calendar notifications
for employee birthdays and anniversaries. 6. **Does not auto-save.** 7. Saving a change on the
employee page does not take effect until the second page's "update employee" — it should save on
the first page. 8. **Expiration dates on attachments.** 9. Employee pay rates and types (hourly /
salary) — "this will be added once we get into the HR side".

### #7 — Assets (Melissa, 2026-05-02)

10. "We need to define how we are doing it" — **Categories** = Mobile Crane or All Terrain Crane;
**Sub Categories** = All Terrain / Tonnage. 11. A **compliance section** with expiration dates on
annual permits and certifications, as attachments with expiry and notifications. 12. Boxes for
**PERP, DOORS, Trucks, etc.** 13. Additional crane info: **main boom length, jib length, luffer,
total number of counterweights, offset jib, main and aux winch, man-basket attachment, load line
size, axle information** (number of axles, weight per axle, tyre size). 14. **Pictures of the
cranes** in their profiles. 15. **Attachments for manuals and load charts.**

### #8 — Customers (Melissa, 2026-05-02)

16. Add **Territory** under industry. 17. Add an **attachment** section. 18. Add a **note**
section. 19. **Link to the project tab, quote tab and invoices**, so all of a customer's projects
and quotes are visible from the customer.

### #9 — Quotes (Melissa, 2026-05-02)

20. Customers in **alphabetical order** in the dropdown. 21. "**Do we need a quote min and
max?**" — an open question, and the 2026-05-05 meeting later concluded the team did not know what
these fields were for. 22. **Rename "plan" to "lift plan".** 23. Boxes for **Needs: FAA Permit,
Street Permits / Traffic Control, Specialty Sub Contractor Required.** 24. **Project type**
checkbox — single trip, multiple trips / holdover. 25. Billing type Hourly — "**do we need to add
Mob and Demob?**" 26. Lift information: **main boom length, jib/luffer length, jib offset,
counterweight, radius, load weight** (with a dropdown if there will be multiple picks),
**capacity at radius** (heaviest / most critical lift), **lift depth, set-up distance, building
height**. 27. "**We need to make templates per crane size.**"

> Item 27 is the earliest written statement of the per-crane estimate templates later documented
> in [quotations/fcc-estimate-templates-by-job-type.md](quotations/fcc-estimate-templates-by-job-type.md).

### #10 — Billing codes (Melissa, 2026-05-02)

28. Billing codes in **alphabetical order** in the dropdown. 29. "We need to add a **% applied for
surcharges**." 30. "When we are quoting and billing a customer that has a **special price list**,
will the rates automatically pop up?" — asked as a question, not asserted.

### #11 — Safety (Melissa, 2026-05-03)

"**Yes safety will need to be built in the initial build.** Currently we are only using FCC for
tracking employee certifications for safety." The programme needs:

- Track **employee certifications and training expirations** with expiry notifications.
- **On-site JSAs.**
- **Audit forms for safety that attach to the jobs**, with pictures, and the data compiled to
  track trends.
- **Employee certifications on the app.**
- Ability to **upload trainings and have employees take them**.
- A **library of safety programmes** for field employees to see.

### #12 — Employees, further (Corrina, 2026-05-04)

1. **Shirt size** tab. 2. "**Insurance codes?** those should be in the employee section for
payroll/insurance purposes." 3. **Emergency contacts** — multiple contacts, each with a
relationship to the employee. 4. Ability to **add more departments to Employee Type**.
5. "**Department — what is this field used for?**" *(open question, unanswered in this file)*

### #13 — Sales (Ryan, 2026-05-05)

- Box to check **if safety should be on-site — high risk**.
- Main / quote information: "**what is quote min or max**" *(the same open question as #21)*.
- **Dates and times put in dispatch** — arrival and leave times for dispatch.
- **FAA permits** — route permit maps.
- Box to check to **let safety know it is high risk**, or a safety site check for the job.

---

## Sheet 2 — 2026-05-05 meeting extraction (AI-generated)

69 tracking items, headed by the sheet's own two disclaimers: "**From meeting on May 5th 2026**"
and "**These were generated with AI… for reference only**". Columns: `Area / Module | Type |
Tracking Item | Notes / Acceptance Criteria`. `Type` is one of Request, Enhancement, Requirement,
Issue, Concern.

**Treat this sheet as an unverified AI summary of a meeting, not as a client statement.** The
client marked it "for reference only" themselves. Where an item here matters, the meeting itself
is the source to go back to.

### Project management (3)

Create a shared feedback tracking log (central place for issues, enhancements, requests and
concerns, possibly split by person or department) · build a 2–3 month ERP roadmap aligning
sprints, daily allocation, tickets, payroll/HR and dependencies · share the vendor's internal
process with TCG, explaining how feedback becomes backlog items, priorities, sprints and releases.

### Dispatch and scheduling (5)

Continue reviewing the Dispatch Figma prototype — Lisette and Dylan need to test the flow before
development · **dispatch testing is blocked by lack of unit/job data** · dispatch uses **final job
timing, not quote timing** — quote timing is tentative, job timing is the operational source of
truth · **Sales can view Dispatch but not edit** (read-only access) · discuss Dylan's daily
allocation view at the next meeting.

### Quotations, jobs and projects (9)

Complete the **quote approval and DocuSign flow** — approval, customer signing and conversion into
job/project are not yet fully built · a signed quote should **create job/project records while the
original quote stays static** · **a project may have multiple quotations**, each convertible into
a job under the same project · **the quote must remain static after signature** — job information
may change later without modifying the signed quote · the job **inherits quote data as a starting
point**, then allows operational updates (site contact, PO, entrance instructions, actual units) ·
optional **estimated start date/time** on the quote, carried to the job · **on-site time and
estimated ending/leave time**, and possibly yard/leave time, for dispatch · **do not show
quoteable items without valid pricing** — sales should only be able to select line items with a
valid billing code and rate · **"Quote Min" and "Quote Max" may be unnecessary** — the team did
not know what they are for and they should likely be removed.

### Pricing, price lists and billing codes (11)

**Billing codes act as the master price list**, with rates tied to billing codes, typically by
subcategory · **flag subcategories with no billing code** — visible indicator or error on the
subcategory page · **bulk-add billing codes to a price list by category** (e.g. all mobile cranes,
or all crane subcategories, at once) · **template or duplicate price lists**, for customer-specific
pricing where many items take the same discount · **the price list customer link/unlink button
default is wrong** — it shows unlink by default and should show link when no customer is linked ·
**special customer pricing overrides master rates** · **price list discounts and price hikes**
apply only to items in that list · **surcharge auto-calculation** — fuel/insurance surcharge as a
percentage across applicable line items · **configure which billing codes receive the surcharge**,
per line / billing code · **the standard surcharge appears on all quotes by default**, made hard
to forget · **surcharge rate may vary by price list**.

### Mobilization / demobilization (3)

A **mob/demob calculator** bundling multiple hidden sub-items into one visible line · **hide the
mobilization sub-items from the customer PDF** — the customer sees only the totals · **crane
working / hook time stays a separate visible line item** from travel, setup and breakdown.

### Quote approval (8)

An approval workflow for discounted quotes — **sales can propose lower rates, but the quote cannot
be sent until approved** · approvals **trigger notifications** to designated managers/executives ·
**multiple approvers**, so absences do not block sales · **approve / deny with a reason**, or
adjust pricing before release · **approval is required only for rates below the allowed price** —
charging *above* standard rate is fine; below standard or price-list rate needs approval ·
support **both line-item and overall discounts** (per item, percentage, or fixed-dollar total) ·
**flag quotes over a dollar threshold** — $50,000 was the figure discussed · **show the review
status to the salesperson** (pending review / approved / rejected / ready to send).

### Job site and permits (2)

**Map-based job-site permit intelligence** — the map should identify FAA airport zones and other
permit triggers · **flag annual permit requirements by city / state / zip**, indicating whether an
annual city permit is already in place or required.

### Safety on the quote (2)

Add a **hazard/safety checklist** to the quote/job — hazardous site, safety required — flagging
the Safety department when needed · **replace scattered permit checkboxes with an expandable
checklist** covering travel permits, lift plan, safety, FAA.

### Employees, HR and permissions (5)

**Review the employee module fields against FCC** — decide which existing FCC fields to keep,
discard or add · **clarify system roles vs work/job roles** — current "roles" appear tied to
permissions rather than employee work functions · **payroll and HR requirements should drive the
final employee field design** · **date/time fields should allow typed entry** — the calendar
picker alone is inefficient, everywhere it appears · **maintain the department/role permission
structure**, configurable.

### Assets and rigging (4)

**Add fields for trucks and other vehicles** — the current asset form is optimised for cranes ·
**define asset categories/subcategories cleanly**, reviewing and standardising FCC wording before
import · **control/manage unit codes** for entered equipment · **add and modify rigging and
tooling records**.

### Data import (3)

**Import selected legacy FCC data in bulk** using a hybrid approach — clean and massage legacy data
first, then import employees, assets, billing codes · **avoid importing bad or messy legacy data**
— review FCC fields, categories and subcategories first · **import enough sample data for
testing** without waiting for the full import, to unblock quotation and allocation testing.

### Vendors and third-party work (7)

**Track third-party crane/vendor usage** — vendor, crane/company used, customer, job — for
analytics and customer protection · **vendor allocation in Dispatch** when TCG has no equipment
available · **capture vendor contact info on the dispatch schedule** — vendor name, phone,
assigned employee/contact, asset info · **track vendor assets and vendor employees** as recurring
data · **a PO requirement/checklist on vendor allocations**, flagging whether a PO is required or
already created · **determine whether a TCG employee must be on site for third-party jobs** —
"not currently set in stone", possibly checklist-driven · **flag third-party jobs requiring a TCG
on-site representative** so dispatch knows.

### Tickets, billing and reporting (3)

**Future electronic tickets should feed billing** — start/stop times flowing into quote/job line
items for faster billing · **final billing may differ from the quote** — actual job times and line
items may vary, and the system must support that without changing the signed quote · **report on
manual rate changes and discounts**, giving visibility into when sales departs from the default
master or price-list rate.

### Training (1)

A **guided training/help button** — a step-by-step walkthrough for new users explaining workflows
and how to complete forms.

---

## Sheet 3 — the log's own vocabularies

The dropdowns behind the log. Useful as the client's own module taxonomy, which does **not** match
this vault's ten-module folder scheme.

| List | Values |
| --- | --- |
| **Module** | Dashboard · Customers · Quotations · Projects · Daily Allocation System · Agencies · Vendors · Planning Tracker · Asset Management · Employees · Departments · Yards · Accounting · Reporting · Safety · HR · IT · Dispatch · Billing Codes · Price Lists · Sales |
| **Crane Guys Name** | Wes · Melissa · Joe S. · Kyle · Brent · Corrina · Lisette · Ryan · Jeff K. · Jeff S. |
| **Feedback Type** | Question · Clarification · Enhancement · Bug |
| **Priority** | High · Medium · Low |
| **Status** | Open · In Progress · Resolved · On Hold |

Note the client's list carries **Safety**, **HR**, **IT**, **Reporting**, **Dashboard**, **Planning
Tracker**, **Departments** and **Yards** as first-class modules. This vault folds those into
`field-ops/`, `payroll/`, `admin/`, `assets/` and `dispatch/` — see [STRUCTURE.md](STRUCTURE.md).

---

## Source

`THE CRANE GUYS - ERP REVIEW LOG.xlsx` — 188 KB, three sheets, sat loose at the root of the
2026-09-04 Project Repository drop outside every numbered archive. Read via an openpyxl row dump.
All three sheets transcribed above in full; no rows omitted. The 89 empty numbered placeholder
rows on sheet 1 are not reproduced.

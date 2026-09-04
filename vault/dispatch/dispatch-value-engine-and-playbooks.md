---
title: The dispatch value engine and its playbooks
source: shared-folder/Project-Repository-2026-09-04/TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG Dispatch - VALUE ENGINES and PLAYBOOKS/ (Dispatch Chart.vsdx, four playbook cover sheets, Set schedule Assigned Equipment - Copy.docx, Sub Out.docx) + 1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/TCG_VE_LEADS_DISPATCH_2025-08-16.pdf
migrated: 2026-09-04
updated: 2026-06-16
status: unverified
conflicts_with: []
jira: []
tags: [module/dispatch, module/quotations, module/vendors-agencies, module/customers, kind/sop, scheduling, permits, purchase-orders, certifications, union-agreement, overtime, compliance]
entities: []
---

# The dispatch value engine and its playbooks

**What this is.** TCG's own description of what its dispatch department does, in TCG's own
documentation format. A **value engine** is a Visio flow of one department's process; a
**playbook** is the written procedure for one step in it. Six files from the
`TCG Dispatch - VALUE ENGINES and PLAYBOOKS` folder of the 2026-06-16 sample set, plus the
company-wide **Leads → Dispatch** value engine dated 2025-08-16.

**Why it matters.** Everything the vault held about dispatch until now came from *discovery
sessions and design reviews* — what dispatchers told CodingCops they need
([dispatcher-needs.md](dispatcher-needs.md)) and what was drawn in response
([daily-allocation-system.md](daily-allocation-system.md)). **This is the first material written by
dispatch, for dispatch, before the ERP existed.** It names four processes, names an owner for each,
and dates them.

> **Written procedure, not adjudicated requirement.** These describe how the department works
> today, on FCC and Excel and OneDrive and SharePoint. Nothing here has been accepted as ERP
> behaviour. Several steps are explicitly about tools the ERP is meant to replace.

| File | Owner | Created | Last updated | Team |
| --- | --- | --- | --- | --- |
| `TCG Dispatch Confirmations - .docx` | **Lisette Anzaldo** | 2026-04-01 | 2026-05-14 | Dispatch |
| `TCG Dispatch Permits-  -.docx` | **Liz Lopez** | 2026-04-01 | 2026-04-01 | Dispatch |
| `TCG Dispatch SetSchedule-Assigned Equipment.docx` | **Lisette Anzaldo** | 2026-05-14 | 2026-05-14 | Dispatch |
| `TCG Dispatch Sub Out Playbook.docx` | **Lisette Anzaldo** | 2026-05-14 | 2026-05-14 | Dispatch |

**All four cover sheets are empty templates.** Each has a header block, a one-line *Overview*, five
blank numbered steps (`Step 1:` … `Step 5:`), and a *Resources* link to the real procedure
elsewhere in SharePoint. Two of those procedures were shipped in the same folder and are the
substance of §4 and §5 below; the other two are the separate pages
[confirmations-playbook.md](confirmations-playbook.md) and
[travel-permits-playbook.md](travel-permits-playbook.md). **The SharePoint URLs carry access tokens
and are not copied here** — they are in the source files.

The one-line overviews are the department's own statement of each rule, so they are quoted in full:

- **Confirmations** — *"All jobs must be confirmed the business day before the job is schedule
  either by email or call."*
- **Permits** — *"All cranes 40 ton or bigger required travel permit, we must apply directly to
  city or permit agency."*
- **Set Scheduled Assigned Equipment** — *"Before all dispatch tickets are created and send out to
  crews, review the schedule with superintendent for the following day and or weekend when it
  applies."*
- **Sub Out** — *"When overbooked with cranes or trucking service and find an approved company that
  can help us cover the job."*

---

## 1. The dispatch value engine

Source: `Dispatch Chart.vsdx`, one Visio page. Shape text only — the connectors are lost in
conversion, so **the sequence below is read from the shape labels and their grouping, not from
arrows.** Where a branch is inferred it is marked.

The chart names **four playbooks** as sub-processes: `Permits PLAYBOOK`, `Confirmations PLAYBOOK`,
`Sub Out PLAYBOOK`, `Set Schedule/Assigned Equipment PLAYBOOK`. Those are the four cover sheets
above, so the chart and the playbook set are the same process seen at two zoom levels.

**Shapes present, grouped by the branch they belong to:**

| Branch | Shapes |
| --- | --- |
| Intake | `Date` · `Availability` · `Email` · `Text` · `Call-Ins` |
| No availability | `Workout Flexibility with Customer` → *(if not)* `Find Crane Company` → `Send Job Detail` → `Confirm details with Crane company` — the `Sub Out PLAYBOOK` branch |
| Permits | `Single Permits` and `Annuals` · `Confirm Permit Lead time` · `Confirm Job Date` · `Order Permits` · `Permits Approved` · `Attached to Job/Permit Folder` |
| Scheduling | `Schedule Job` · `Set Schedule/Assigned Equipment PLAYBOOK` |
| Confirmation | `Confirm Job with Customer` · `Customer confirms Job` → **Yes** / **No** |
| Not confirmed | `Cancel Job` · `Rescheduled` · `Back To Availability` |
| Confirmed | `Dispatch` · `Field Confirmations` · `Schedule` · `Job Complete` |

Two things the chart states that no other dispatch source does:

1. **Permits split into `Single Permits` and `Annuals`**, and the flow runs
   *confirm lead time → confirm job date → order → approved → file*. The annual/single distinction
   was raised in the 2026-08-12 client minutes
   ([meetings/2026-08-12-sell-side-workflow-and-scheduling.md](../meetings/2026-08-12-sell-side-workflow-and-scheduling.md))
   and recorded there as having **no vault coverage**. It has coverage now — see
   [travel-permits-playbook.md](travel-permits-playbook.md) for what "annual" means in practice.
2. **A declined job re-enters the flow at `Back To Availability`** rather than terminating.

---

## 2. Leads → Dispatch, the company-wide value engine

Source: `TCG_VE_LEADS_DISPATCH_2025-08-16.pdf`, one landscape page dated **2025-08-16** — the
oldest document in this group by ten months. Two swimlanes, `LEADS` and `DISPATCH`.

**LEADS lane** — sources (`Cold Calls`, `Google Ads`, `Request a Quote`, `Referrals`,
`Active Job Site`, `Contracts`, `Bids`, `Repeat Customers`) feed a **`Sales Coordinator or
Dispatch?`** decision. Three separate paths are marked **`To: DISPATCH`**:

- **Repeat Customers** go straight to dispatch, bypassing quoting entirely.
- A **New Customer** goes through `Accounting: Set Up Account` → `MSA / Sub / COI` → `Terms` →
  **`To: DISPATCH`**; a `COD` path goes through `Account Approved` → **`To: DISPATCH`**.
- An **Existing Customer** who signs a quote goes `Customer Schedules` → **`To: DISPATCH`**.

The quoting path in between is `Quote?` → `Sales Coordinator` → `Send Quote to Customer` →
`Quote Follow-Up` → `Customer Signs Quote?`.

**DISPATCH lane** — the operational flow, and it matches the Visio chart closely:

`Sub Out?` → **yes**: `WL Sub` → `Check Availability` → `Determine Sub` →
`Email Other Crane Company with Info` → `Confirm Job Schedule with Sub`
→ **no**: `Ask Customer: Is Flexible?` → **yes**: `Collaborate with Customer` → `Pitch Date/Time`
→ **no**: `Customer Finds Crane` (i.e. TCG loses the job)
→ `Availability Found?` → **yes**: `Permits Required?` → **yes**: `Apply for Permit` →
`Obtain Permit` → `Scheduled` → `Confirmations` → `Dispatch Jobs` → `Field Confirmations`

**Two independent documents, ten months apart, describe the same dispatch sequence** —
availability, then sub-out or flex, then permits, then confirmations, then dispatch, then field
confirmation. That agreement is the strongest thing this group establishes.

The same PDF appears twice in the drop (`1.0.1_BUSINESS-REQUIREMENTS/...` and
`TCG_Value_Engine_SAMPLES-ONLY/.../zzzOTHER/...`); the converted text is byte-identical.

---

## 3. Where this sits against the sales-side handoff

The **sales-admin process map** (`__ WORKFLOWS__Sales admin process mapping - Dispatch.pdf`, a
Whimsical board titled *The Crane Guys - Dispatch*, exported **2026-08-06**) covers the same
boundary from the sales side and is the only source that puts **numbers** on the handoff. Its text
is a flowchart export and reads out of order, so only the statements that are unambiguous are
recorded:

- The board is organised into ten stages, of which **stage 7 is `Scheduling & Dispatch`, owned by
  `Sales Admin + Dispatch`**, with steps `7.1 Enter Job in System — Date, Crane, Crew, Address` and
  `7.3 Pre-Job Confirmation — 1-2 Days Before`.
- Scheduling is banded by **permit lead time**, three named paths:
  - **`Green Path`** — *"Normal Permit Lead Time … From Scheduling Sheet within 72 hours Working
    Hours from Thursday before noon"*; standard cities.
  - **`Yellow Path`** — *"Special Circumstances"*, longer permit time than 72 hours.
  - **`Red Path`** — *"Jobs without 72 hour notice"*; also *"Red Path before 72 hours"* and
    *"cities longer than 72 hours before 12pm Thursday"*.
- **`8am Day Prior to Job Start Date Send Email to Customer With Date and Time We will Be Arriving
  To Site`** — a stated time and a stated recipient.
- **`(Working Hours) Sales Admin` versus `(After Hours) Dispatch Responds`** — an explicit
  ownership split by time of day for schedule changes and cancellations.
- On reschedule or cancel: **`Send Accounting a bill to charge for any Permit Costs, Rescheduling
  Fees and Email Customer`** — repeated three times on the board, once per path.
- The information sales must have before handing over (*"Get Required Info"*): new-or-existing
  customer, customer name, billing address, contact info, `Ordered by`, PO number, project name,
  job site address, detailed scope of work, job comments, Davis-Bacon / federally funded / certified
  payroll flag, weight, radius, height, setup distance, **crane configuration**, requested crane,
  **alternate crane options**, rigging, trucking, extra equipment, traffic control, FAA, lift plan,
  job layout, third parties.
- The handoff itself: **`Dispatch Takes Over — Full Hand Off`**, after
  `Job Is Scheduled` and before `Crane and Team are Dispatched` → `Job Confirmed` → `Job is
  Completed`.

> **This closes a named gap.** The 2026-08-12 client minutes record: *"No definition exists for
> **Red Path** — treat it as an undefined domain term"*
> ([meetings/2026-08-12-sell-side-workflow-and-scheduling.md](../meetings/2026-08-12-sell-side-workflow-and-scheduling.md)).
> This board defines all three paths, and defines them by **permit lead time against a 72-hour
> threshold with a Thursday-noon cutoff**. Treat that as *a definition found on a source document*,
> not as a ratified one — no human in the vault has confirmed it, and the board is a sales-side
> artefact that dispatch did not author. It is flagged for the human in this drop's report.

---

## 4. Set Schedule / Assigned Equipment — the review with the superintendent

Source: `Set schedule Assigned Equipment - Copy.docx`. Six bullets, the whole document, reproduced
because each is a distinct check and the file is nothing but the list. The trigger is the cover
sheet's overview: **before dispatch tickets are created and sent to crews**, review the next day's
(or the weekend's) schedule with the superintendent, and:

1. *"Confirm which cranes have permits and must stay on certain jobs"*
2. *"Confirm if any certifications are required for a job and that the employee is qualified"*
3. *"Make sure a crew isn't on double time and if they are that we are charging accordingly"*
4. *"assigned jobs to operators, journeyman and apprentices and that they are working accordantly"*
5. *"Make sure we are following union rules and scheduling based on what operators/field are
   entitle to"*
6. *"Confirm operators are qualified for specific projects"*

**Four of these are corroborated elsewhere and one is not:**

- (1) is the `P/LP/RL/SS` permit column on the dispatch sheet — *"important for a quick view in case
  we need to change the schedule after hours"*
  ([crane-configurations.md](crane-configurations.md) §2), and the reason it is a *quick view* is
  the after-hours split in §3 above.
- (2) and (6) are the `Empolyee Qualification` matrix in
  [dispatch-sheet-workbook.md](dispatch-sheet-workbook.md) §5, and the certification validations
  FCC runs at ticket generation ([fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md) §4).
- (3) is the double-time colour on the dispatch sheet, and the substance of review-log entry **#14**
  — *notify dispatch when an employee is working more than 10–12 hours*
  ([erp-review-log.md](../erp-review-log.md)).
- (4) and (5) are the union rules recorded under review-log entry **#4**: the **dispatch tier
  order** (Tier 1 Operators → Tier 2 Oilers → Tier 3 Apprentices → Tier 4 Fill-ins, with dispatch
  notified if it tries to send a lower tier before every higher tier has been asked) and the
  **last-crew entitlement** rule (*"the last crew on the equipment on straight time is entitled to
  the overtime work"*, dispatch must offer it to them first, entitlement is to the next shift
  only). **The playbook says dispatch performs this check; the review log says what the check is.
  Neither says how the system should enforce it, and no decision has been taken.**

> This is a **manual review meeting** standing between allocation and ticketing. The DAS spec
> ([daily-allocation-system.md](daily-allocation-system.md)) has no equivalent step — its lifecycle
> runs `Open → Allocation Completed → Ticket Sent` with nothing between. **Whether the
> superintendent review survives into the ERP, becomes an approval state, or disappears, is
> unstated everywhere.**

---

## 5. Sub Out — covering a job with another company

Source: `Sub Out.docx`. The fullest of the four procedures shipped in this folder. Its framing:
*"When subbing out work is needed, it is important that everyone is aware and we follow the
necessary steps: getting the right equipment, negotiating rates, providing PO, receiving jobs
tickets, invoicing the customer, etc."*

### Subbing out a crane

**Pre-check.** *"Confirm with project manager/ accounting crane company is an approved vendor."*
Then reach out by email or phone to confirm they have a crane available.

**Once the company confirms, four steps:**

1. **Notify the customer** that TCG is subbing out the equipment.
2. **List the covering company under the "Equipment Section"** — the stated format is
   `40 ton (subbed to Hydraulic)`.
3. **Send job information to the covering company by email, CC project manager and accounting**,
   containing: description of work with equipment required *(including job layout if available)*,
   onsite contact, reporting time, and **PO number** — example given as `OM-1234`, with a
   cross-reference to a separate *PO # Playbook*.
4. **Update the dispatch sheet** — the `Subbed out / Outside Trucking` colour in
   [crane-configurations.md](crane-configurations.md) §2.

### Subbing out trucking

Same pre-check against the approved-vendor list, then reach out **by email or text**; the document
gives the actual text used: *"Hello, do you have a stretch trailer to haul poles?"*

1. **Record it in `Inhouse Comments`** — stated format: *"Piazza Trucking provided a stretch trailer
   to haul poles."* (`In-House Comments` is the FCC job tab described in
   [fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md) §10.)
2. **Text or email the job details** — same four items as a crane sub-out, **plus: *"Make sure to
   ask for the Drivers Contact."***
3. **Update the dispatch sheet.**

**And the standing rule, emphasised in the source:**
***"If we sub a crane, we should do our best to be there the day of onsite."***

> **This corroborates seven separate items in the 2026-05-05 review-log extraction** — the whole
> *Vendors and third-party work* section ([erp-review-log.md](../erp-review-log.md)): vendor
> allocation in dispatch, capturing vendor contact info on the dispatch schedule (the driver's
> contact, above), a PO requirement on vendor allocations, tracking which vendor covered which
> customer's job, and *"determine whether a TCG employee must be on site for third-party jobs —
> not currently set in stone"*. **The playbook's last line is the closest thing to an answer on
> that last point that exists in writing, and it is a "should", not a rule.** It also matches the
> DAS user story *Vendor Management in DAS*
> ([daily-allocation-system.md](daily-allocation-system.md)), which specifies a *Create PO*
> quick-action on vendor assignment — the same PO step this playbook does by hand.

**Not stated:** who maintains the approved-vendor list, what makes a vendor approved, how rates are
negotiated (the framing mentions negotiating rates; no step covers it), or how the sub's job ticket
comes back and reaches invoicing.

---

## 6. Open questions raised by this group

Recorded here as *observed*, not written to any register:

- **Is the 72-hour Green/Yellow/Red threshold real and current?** It is stated on one sales-side
  board and nowhere else, and the vault has an explicit note that Red Path was undefined.
- **Does the superintendent review survive into the ERP** as a step, an approval state, or nothing?
- **How is the union tier order and last-crew entitlement meant to be enforced** — a blocking check,
  a notification, or a report? The review log asks for notification; the playbook describes a human
  check; nothing decides.
- **What makes a sub-out vendor "approved"**, and who owns that list?
- **Who covers dispatch after hours**, given the sales-side board assigns after-hours schedule
  changes to Dispatch and working-hours changes to Sales Admin.

## Source

`shared-folder/Project-Repository-2026-09-04/`

- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG Dispatch - VALUE ENGINES and PLAYBOOKS/Dispatch Chart.vsdx`
  — one Visio page, converted to shape text. **Connectors and layout lost**; §1's grouping is read
  from labels.
- `…/TCG Dispatch Confirmations - .docx`, `…/TCG Dispatch Permits-  -.docx`,
  `…/TCG Dispatch SetSchedule-Assigned Equipment.docx`, `…/TCG Dispatch Sub Out Playbook.docx`
  — four cover sheets, pandoc to GFM. Header block and overview only; all five step slots blank.
- `…/Set schedule Assigned Equipment - Copy.docx` — six bullets, quoted in full in §4.
- `…/Sub Out.docx` — pandoc to GFM. Six screenshots in the source (email examples, the equipment
  section, the dispatch sheet) are not carried; the procedure text is complete.
- `1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/TCG_VE_LEADS_DISPATCH_2025-08-16.pdf`
  — one page, `pdftotext -layout`, dated 2025-08-16. Duplicated byte-for-byte at
  `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/zzzOTHER/FLOWCHARTS_VALUE_ENGINES/TCG_VE_LEADS_DISPATCH_2025-08-16.pdf`.
- `3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/__ WORKFLOWS__Sales admin process mapping - Dispatch.pdf`
  — a **Whimsical** board (`whimsical.com/scalable-co/the-crane-guys-dispatch-…`) exported
  2026-08-06 10:58. `pdftotext -layout` on a flowchart: **text arrives out of reading order and
  connectors are lost**, so only unambiguous statements are recorded in §3. The board's sales-side
  stages 1–6 and 9–10 belong to the quotations and customers modules and are not covered here.

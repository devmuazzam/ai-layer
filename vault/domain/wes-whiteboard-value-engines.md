---
title: Wes's whiteboard value engines — the Visio pages and their AI transcriptions
source: shared-folder/Project-Repository-2026-09-04/TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/zzzOTHER/FLOWCHARTS_VALUE_ENGINES/ (TCG Value Engines SHARED.vsdx, IMAGES_OF_NOTES/*.heic, VS_CODE/AI_GENERATION/ValEng_PIC0*.md)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/all, kind/source, provenance, scheduling, ticket-workflow, invoicing, time-tracking, safety, permits]
entities: []
---

# Wes's whiteboard value engines — the Visio pages and their AI transcriptions

**What this is.** Four end-to-end business processes that TCG's owner **Wes Staley** drew on a
whiteboard, photographed, and then had digitised twice over: once properly, as four pages of a
Visio file, and once loosely, as AI-generated Lucidchart prompts. This page holds both — and keeps
them clearly apart, because **their reliability is not the same.**

**Why it matters.** These four are the widest single view of TCG's operations anywhere in the drop:
accounts payable through collections; field personnel, safety audits and storage; sales lead
through to dispatch; and payroll. They cut across every module in this vault. They are also the
earliest form of the material — the raw sketch that later documents refine.

> ## Provenance — read before citing anything below
>
> **Nothing on this page is a verified statement of TCG's process.** There are three layers, in
> descending order of trust:
>
> 1. **The photographs** — `from_Wes_whiteboard_pic01`–`pic04.heic`, plus
>    `from_Wes_whiteboard_pic02_bp.jpg` and `DISPATCH_FIELD_flowchart.jpg`. They are the only
>    primary source. **Read visually on 2026-09-04 — see *The photographs, read* below.** Three
>    distinct boards, not four, and their numbering does **not** match the AI transcriptions'.
> 2. **`TCG Value Engines SHARED.vsdx`** — four Visio pages someone at TCG drew *from* those
>    photographs. Reliable as a record of what was digitised; the shape labels below are quoted
>    exactly. **But Visio conversion recovers labels only, not connectors** — so the *sequence* of
>    steps is inferred from label order on the page and may be wrong.
> 3. **`ValEng_PIC01`–`PIC04.md`** — **AI-generated Lucidchart prompts**, produced by uploading the
>    photographs to a chatbot and asking it to describe the flowchart. The files retain the
>    assistant's own conversational preamble ("Got it — thanks for uploading this one…", "From the
>    structure, this diagram **looks like**…"). **These are a machine's guess at handwriting.**
>    They contain evident garbling — "LOD met?", "WE good?", "Worker training verified?" — steps
>    that appear in no other TCG document.
>
> **Treat layer 3 as a lead, never as a fact.** Where it and layer 2 disagree, layer 2 wins. Where
> only layer 3 says something, it is unconfirmed. Anything load-bearing must go back to the
> photographs and to a human.

---

## The photographs, read — 2026-09-04

The six image files were converted (`.heic` → JPEG) and read directly. **There are three
whiteboards, photographed five times**, and the `pic0N` numbering does not line up with the
`ValEng_PIC0N` transcriptions that were supposedly made from them:

| Image file | What the board actually is | Matching AI transcription |
| --- | --- | --- |
| `from_Wes_whiteboard_pic01.heic` | **Dispatch + Field** — two lanes divided by a hand-drawn line | `ValEng_PIC02.md` ("Job Dispatch and Operations Workflow") |
| `DISPATCH_FIELD_flowchart.jpg` | **The same Dispatch + Field board**, shot straight-on | same |
| `from_Wes_whiteboard_pic02.heic` | **"Value Engine #1 — Crane Services"**, headed *(How do we get customers?) (How do we fulfill our orders?)* | `ValEng_PIC03.md` ("Sales Lead to Dispatch Workflow") |
| `from_Wes_whiteboard_pic04.heic` | **The same Crane Services board**, re-shot after two stickies moved (*Sales Coordinator* relocated; *Repeat Customers* added to the lead column) | same |
| `from_Wes_whiteboard_pic02_bp.jpg` | **The same Crane Services board**, cropped (the `_bp` copy) | same |
| `from_Wes_whiteboard_pic03.heic` | **Payroll + Billing** — two lanes divided by a wavy line | `ValEng_PIC04.md` ("Payroll Workflow") |
| *(none)* | — | `ValEng_PIC01.md` ("Accounts Payable & Collections Workflow") — **no photograph of this board is in the drop** |

So the pairing table below this section, which assumed `pic01`↔`PIC01`, is wrong by one: the
transcriptions are numbered in the order the Visio pages were drawn, not in the order the photos
were taken, and the AP/collections board was photographed on some file that did not arrive.

What each board says, transcribed from the stickies (arrows read from the marker lines; where a
line was ambiguous the step order is given as it sits on the board):

### Board 1 — Dispatch + Field (`pic01`, `DISPATCH_FIELD_flowchart.jpg`)

**Dispatch lane (top).** *Customer finds crane* → *Check schedule availability* → **Permits
required?** → *Yes* → *Apply for permit* → *Obtain permit* → *Scheduled* → *Confirmations
(customer)* → *Dispatch jobs* → **Field Confirmations**. *No* → *Scheduled* → *Confirmations* →
*Dispatch jobs* → **Field Confirmations** directly.
When availability fails: *Sub out?* → *No* → back to *Customer finds crane*; *Yes* → *We sub* →
*Check availability* → *Sub determined* → *We email other crane co. with job # & schedule* →
*Scheduled* → *Confirmations* → *Dispatch jobs* → **Field Confirmations**. A separate branch,
*Asks for flexibility* → *Yes* → *Collaborates with customer* → *Pick date & time* → *Scheduled*;
*No* → back to *Sub out*. (A red note beside *Asks for flexibility* reads *"customer finds crane"*.)

**Field lane (bottom).** *Receive / confirm dispatch* → *Gather paperwork* → **missing paperwork?**
*Yes* → *Missing paperwork* → *Call on-call dispatcher* → *Pre-trip* → *Yard crew tailboard* →
*Leave for job* → *Arrive to job site* → *Walk job site + contact company rep* → **No** → *Call
dispatch immediately* → *Stage equipment* → *Safety tailboard + paperwork signed* → *Complete
lift* → **COD?** → *Yes* → *Call accounting* → *Customer final signature, leave job* → *Drive back
to yard* → *Fuel / wash equipment & finish paperwork* → *Park equipment* → **Return paperwork to
box**. A pencilled note above the lift step: *"(Taking lunch?)"*.

Every step of the field lane is a step in the FRD's ticket workflow; the dispatch lane is the
same material as [../dispatch/dispatch-value-engine-and-playbooks.md](../dispatch/dispatch-value-engine-and-playbooks.md).
**The COD → "call accounting" gate before the customer signs is the one step no other source
draws.**

### Board 2 — Value Engine #1, Crane Services (`pic02`, `pic04`, `pic02_bp`)

Two questions across the top: **(1) How do we get customers?** and **(2) How do we fulfill our
orders?** Margin notes: *"New emails to be added to marketing list"*, *"Customer satisfaction
calls"*.

**Lead sources** (left column): *Cold calls · Google Ads · Request a quote · Referrals · Active
job sites · Contracts · Repeat customers · Bids* → all feed *Call office or email* → **Salesmen**
or **Sales Coordinator / Dispatch**.

**Salesman path.** *Job walk* → *Quote* → **Schedule?** *Yes* → **Dispatch**; *No* → *Quote
follow-up*. Or *Quote* directly → **Schedule?** (same branch). Or *Direct schedule* → **Dispatch**.

**Sales Coordinator / Dispatch path.** **Quote?** *No* → **Dispatch**; *Yes* → *Send quote to
customer* → **Customer signs quote?** *No* → *Quote follow-up calls*; *Yes* → **Customer
schedules?** → **New customer** → *Goes to accounting to set up account* (MSAs signed / COIs) →
*Account approved* → **COD** → Dispatch, or **Terms** → Dispatch. **Existing customer** → *Goes
to Dispatch to schedule*.

This is the earliest form of the lead-to-dispatch flow that
[../quotations/sales-operating-system/](../quotations/sales-operating-system/INDEX.md) later
formalises, and it is the board the *Lead Workflow* PDF and the *Leads → Dispatch* value engine
were drawn from. The **COD vs Terms** fork after account approval is the same decision the
customer packet documents.

### Board 3 — Payroll + Billing (`pic03`)

Header: *"Payroll — hours verified for billing & paid"*.

**Payroll lane.** *Go to boxes, collect paperwork, check NexGen completed tickets* → *Dispatch
sheet copies* → **Missing?** *Yes* → *Reach out to employees* → *No response* → *Reach out to
crane super if they don't respond* → *Match times in FCC / or manually enter* → *Verify times
via GPS* → **Times correct?** *No* → *Reach out to EE and/or crane super*; *Yes* → *Confirm job
& unit # are correct* → *Enter hours in Excel (auto refresh)* → *Break out boom pay / OT & double
time in Excel* → *Enter into ADP and FCC* → *Email reports to accounting* → *Distribute checks*
→ **EE paid correctly?** *Yes* → *EE paid*; *No* → *Call payroll dept* → *Check re-issued* → *EE
paid*. Side box: **"Weekly Certified Payroll processed and submitted."**

**Billing lane.** *Go to boxes, collect paperwork, check NexGen completed tickets* → *Approved
tickets to bill* → *Open GPS tracking sheet to verify times* → *E-tickets not invoiced on
side tickets, billing* → *Open payroll pre-processor* → **Hold over?** *Yes* → *Create Excel* →
**Job / customer info needs updated?** *Yes* → *Update info* → **Subcontractor?** *Yes* →
*Receive invoice from sub* → *Mock up invoice* → *Salesman to review* → *Notify salesmen invoices
are ready* → *Once approved, export invoice* → *In QB do final steps, make packet, send to
customer*. Below the lane: *Send tickets to customer per contract* → *Receive breakdown from
customer* → *Verify customer's breakdown*; and **Pre-lien?** *Yes* → *Give info to 3rd-party
provider* → *Add subs to collection sheet*.

Both lanes start from the same physical act — **"go to boxes, collect paperwork"** — which is the
paper-ticket return box the Field lane on Board 1 ends at. The billing lane's *"open payroll
pre-processor"* and *"mock up invoice → salesman to review"* are the steps
[../accounting/ap-ar-value-engine-and-whiteboard-flow.md](../accounting/ap-ar-value-engine-and-whiteboard-flow.md)
and [../payroll/payroll-value-engines.md](../payroll/payroll-value-engines.md) describe from the
Visio side.

**What reading the boards changes.** Layer 2 (Visio) and layer 3 (AI prompts) below are now
checkable against the primary source for three of the four processes. Where they disagree with
the boards above, **the boards win**. The AP/collections process (§1 below) remains
photograph-less and therefore still rests on layers 2 and 3 only.

---

## The four processes

The Visio pages and the AI transcriptions cover the same four subjects in the same order, which is
how the pairing below is established. Neither set of files states the pairing explicitly.

| # | Subject | Visio page | AI prompt |
| --- | --- | --- | --- |
| 1 | Accounts payable, receivable and collections | page 1 | `ValEng_PIC01.md` |
| 2 | Field personnel, safety & audits, storage | page 2 | `ValEng_PIC02.md` |
| 3 | Sales lead to dispatch | page 3 | `ValEng_PIC03.md` |
| 4 | Payroll | page 4 | `ValEng_PIC04.md` |

---

## 1 — Accounts payable, receivable and collections

### From the Visio page (layer 2)

The page carries three labelled zones — **Accounts Payable**, **Accounts Receivable** and a
collections tail — plus a payroll-processor strip along one edge.

**Accounts payable.** `Receive Bills` → `Bill Verified` → `Subcontractor?` — **Yes** → `Pay
Subcontractor`, **No** → `Pay Bill`. A parallel strand runs `Collect Paperwork` → `Check
FCC-NexGen` → `Complete Tickets` → `Approve Tickets to Bill`, with `GPS Tracking`, `E-Tickets Not
Invoiced` and `Open` as inputs, and a `Hold Over?` gate — **Yes** → `Create Excel`. Further gates:
`Job/Customer Info Update` (Yes → `FCC`), `Subcontractor` (Yes → `Receive Invoice from Sub`, No →
`Mock Invoice`), and a `Sales Coordinator` / `Notify Sales Coordinator` branch. **`LADWP`** appears
as a named customer path: `Send Customer Tickets` → `Receive Breakdown from Customer` → `Verify
Customer Breakdown` → `Bill Final` → `QuickBooks Steps`. Also on the page: `3rd Party`, `Pre Lien`,
`Add Collection Sheet`.

**Payment methods.** `COD` branching to `Cash`, `Card`, `ACH`, `Check`, with the operational note
**`Cash given to Operator After Confirming with Accounting`** and the sequence `Operator Call
Accounting` → `Gives Total`; also `Sends Customer Invoice`, `Call Accounting for Total`, `Get
Check`.

**Accounts receivable.** `Payment?` — **Yes** → `Creates Invoice` / `Marks as Paid` → `Paid`;
**No** → `Accounting Calls Customer` → `Answer?` — **Yes** → `New Form of Payment`, **No** → `Lien
Alert` → `Paid` or `Continual Collection Process`.

**Deposits.** `Deposit` → `Deposit Determined` → **No** → `Dispatch`; `Check Returned`; `Deposit
Collected`; `Job Cancelled` → `Return Deposit`; `Payment?` — **Yes** → `Notify Sales Coordinator`,
**No** → `Job On Hold`.

**Terms customers and collections.** `Terms` → `Confirm Invoice Received` → `Invoice Issues?` —
**Yes** → `Reach Out to Job Owner`, **No** → `Payment?` — **Yes** → `Invoice Marked as Paid`,
**No** → `Call at Term` → `Follow Collection Process` → `Lien Alert` → `Reach Agreement with
Customer` → `Ownership` → **`Lien at 90 Days`** → `Legal remedy`. `Schedule job` closes the page.

### From the AI transcription (layer 3 — unverified)

`ValEng_PIC01.md` renders the same territory as a 45-step Lucidchart prompt titled *"Accounts
Payable and Collections Workflow"*, which the assistant summarises as three zones: AP (receiving
and verifying vendor bills), the deposit/COD path, and collections (terms customers, disputes,
unpaid invoices, liens, escalation to court). Its steps largely echo the Visio labels, with two
additions that appear **only** here: an explicit `Approval required?` gate after bill entry, and a
`Refund customer` step on job cancellation. Its terminal step is **"Court filing if unpaid 90+
days"**, where the Visio page says `Lien at 90 Days` → `Legal remedy`.

### The archived data-visualizer version

`zz_ARCHIVE/Visio_Data_Visualizer_Flowchart_Template (1).xlsx` holds **this same process as
structured rows** — the only machine-readable form of any of the four. Its `ProcessMap` sheet gives
44 steps with IDs, next-step IDs, branch labels, shape types, and a `Function` swimlane column
whose values are **AP · Accounting · Collections · Ops/COO**, phased as **Intake → Verification →
System Entry → Payment Scheduling → Payment Execution → Deposit Handling → Invoice Terms →
Collections**. Its notes column carries two admissions of the same uncertainty this page is about:
*"From whiteboard: Deposit options / Deposit collected"* and *"Whiteboard: right-side 'Project?'
and other notes — **please verify**"*.

Payment execution in that table branches `Payment method?` → **Cash / Check / EFT**, where cash is
"prepare cash disbursement", check is "issue check & obtain signatures", and EFT is "initiate
electronic transfer (ACH/Wire/Card)"; all three converge on "record payment confirmation".

---

## 2 — Field personnel, safety & audits, storage

### From the Visio page (layer 2)

**Field personnel.** `Paperwork` → `Pre Trip` → `Yard Crew` → `Tailboard` → `Leave for Job` →
`Arrive at Job Site` → `Walk Job Site` → `Contact Customer` → `Call Dispatch` → `Safety Tailboard`
→ `Complete Lift` → `COD` — **Yes** → `Call Accounting`, **No** → `Customer Final Signature` →
`Drive to Yard` → `Fuel & Submit Paperwork` → `Park Equipment` → `Return Paperwork to Box`.

**Safety & audits.** `Self Audits` · `Requested Audits` · `Job Site Audit` → `OFI` → `EE
Disciplinary Action` or `Coaching Moment` → `Track Audit Trends` → `Monthly Customer Reporting`;
and `Training` → `Develop Training & Safety Meetings` → `Safety Meeting`.

**Storage — receive incoming order.** `Receive Incoming Order` → `Appointment?` — **Yes** →
`Accept Delivery`, **No** → `Picture?` → `Figure Out Customer`; then `Forklift` or `Crane` →
`Unload` → `Fill Out Storage Sheet` → `Place Equipment` → `Enter Into Excel` → `Contact Billing`.

**Storage — loading outgoing.** Two strands. `TCG`: `Load` (`Forklift` / `Crane`) → `Delivery
Accepted` — or → `Return to Shop` → `Contact Billing`; `Unload` → `Contact Customer` → `Contact
Billing`. `Storage Customer`: `Receive Order` → `Load` (`Forklift` / `Crane`) → `Contact Billing`.

> `Enter Into Excel` on the storage path is the same spreadsheet dependency the FCC health check
> reports across dispatch and payroll — see
> [../admin/fcc-nexgen-health-check-2025-12-16.md](../admin/fcc-nexgen-health-check-2025-12-16.md).

### From the AI transcription (layer 3 — unverified)

`ValEng_PIC02.md` titles this *"Job Dispatch and Operations Workflow"* — a different framing from
the Visio page's field/safety/storage split — and produces 37 steps. **Several of its steps
correspond to nothing on the Visio page and read like misread handwriting:** "Worker training
verified? — Yes → Vehicle/truck check, No → Assign training", "Buy preparation items", "LOD met? —
Yes → Call accounting", "Coaching done? — Yes → Truck in yard, No → Reschedule audit", "Forklift
available? — No → Contact customer". **Do not treat any of these as TCG process.** The one thing
it adds consistently with the Visio page is that the storage strand ends in billing contact.

`DISPATCH_FIELD_flowchart.jpg` sits in the same folder and is presumably a cleaned-up rendering of
this material. **It is an image, was not converted, and has not been read.**

---

## 3 — Sales lead to dispatch

### From the Visio page (layer 2)

**Lead sources**, listed as a block: `Cold Calls` · `Google Ads` · `Request a Quote` · `Referrals`
· `Active Job Site` · `Contracts` · `Bids` · `Repeat Customers`.

**Sales.** `Call or Email` → `Sales Coordinator` → `Sales Coordinator or Dispatch?` → `Quote?` —
**No** → *to Dispatch*; **Yes** → `Sales Coordinator` → `Send Quote to Customer` → `Customer Signs
Quote?` — **Yes** → `Customer Schedules`. A customer-setup branch distinguishes `NEW Customer` from
`Existing Customer`: new customers go to `Accounting: Set Up Account` with `MSA`, `COI`, `Sub
Account`, `Approved`, and a `COD` / `Terms` split, then *to Dispatch*. `Quote Follow-Up` also
appears on the page.

**Dispatch.** `Sub Out?` — **Yes** → `WL Sub` / `Check Availability` / `Determine Sub`; **No** →
`Customer Finds Crane` / `Email Other Crane Company with Info`. Then `Availability Found?` —
**Yes** → `Permits Required?`; **No** → `Ask Customer: Is Flexible?` — **Yes** → `Collaborate with
Customer`, **No** → `Pitch Date/Time`. `Confirm Job Schedule with Sub`. `Permits Required?` —
**Yes** → `Apply for Permit` → `Obtain Permit`; **No** → onward. Closing steps: `Scheduled
Confirmations` → `Dispatch Jobs` → `Field Confirmations`.

### From the AI transcription (layer 3 — unverified)

`ValEng_PIC03.md`, *"Sales Lead to Dispatch Workflow"*, 36 steps, tracks the Visio page more
closely than the others do — the lead→coordinator→quote→approval→account-setup→availability→
permit→dispatch spine is recognisable throughout. Its garbled step is **"WE good?"** (almost
certainly the Visio page's `WL Sub`). It adds a `Permit approved?` gate with a `Reschedule job`
branch that the Visio page does not show.

---

## 4 — Payroll

### From the Visio page (layer 2)

`Collect Paperwork` → `Check FCC-NexGen` → `Complete Tickets` → `Dispatch Sheet Copied` →
`Missing?` — **Yes** → `Reach Out to EE`; **No** → `Verify Times via GPS` → `Reach Out to Crane
Supervisor`. Then `Match Times in FCC-NexGen` → `Option` → `Time is Correct?` — **Yes** → onward,
**No** → `Reach Out to EE & Crane Supervisor` → `Confirm Job Unit` → `Enter Hours in Excel` with
`Boom Pay` and `DT OT` alongside → `FCC-NexGen` → `Email Reports to Accounting` → `Distribute
Checks` → `EE Paid Correctly?` — **Yes** → `EE Paid`; **No** → `Call Payroll` → `Check Reissued` →
`EE Paid`. Two standing labels close the page: **`Weekly`** and **`Certified Payroll Processed &
Submitted`**.

> Three things here corroborate the FCC health check independently: time is **verified via GPS**
> (Samsara), hours are **entered in Excel** before reaching NexGen, and boom pay and DT/OT are
> handled at that spreadsheet step. See
> [../admin/fcc-nexgen-health-check-2025-12-16.md](../admin/fcc-nexgen-health-check-2025-12-16.md)
> and the payroll module's own pages.

### From the AI transcription (layer 3 — unverified)

`ValEng_PIC04.md`, *"Payroll Workflow"*, 21 steps. It matches the Visio page on the front end
(paperwork, dispatch sheet, verify timesheets, reach out to employee, match to tickets, reach out to
supervisor) and the back end (submit to accounting, call payroll, check reissued, employee paid,
weekly cycle closed). **It introduces an approval stage that appears nowhere on the Visio page:**
"Run payroll draft → Approve payroll (PM / FLC) → Timesheets approved? — Yes → Submit to accounting,
No → Return for correction". *PM* and *FLC* are not expanded anywhere. Unverified.

---

## The prompt template these transcriptions were made with

`VS_CODE/TEMPLATE/AI_PROMPT_TEMPLATE.md` is the reusable prompt behind all four: a fill-in-the-blank
Lucidchart instruction that fixes the shape vocabulary — `[Terminator]` for start/end, `[Process]`
for actions, `[Decision]` for yes/no checks — asks for "Yes →" and "No →" on branches, requires
labels of 2–6 words, and uses numbering for sequence and indentation for child steps. It carries a
worked example ("Customer Support Ticket Handling") that is **not** TCG content.

Worth noting: the template's shape vocabulary is Lucidchart's, and it is **narrower than TCG's own
five-symbol set** ([value-engines-and-playbooks-method.md](value-engines-and-playbooks-method.md))
— there is no *Data* shape and no connector semantics. Anything on the whiteboard that was a data
input or export could not survive this transcription. That is a further reason the AI files lose
information the photographs still hold.

`ValEng_PIC0N_AI.md` files also exist for all four. They are **byte-identical to their
`ValEng_PIC0N.md` counterparts** apart from the horizontal-rule style, and add nothing.

---

## Source

- `TCG Value Engines SHARED.vsdx` — 3.9 KB of extracted shape text, four pages. **Labels only;
  connectors, swimlanes and layout did not convert**, so every arrow shown above is inferred.
- `IMAGES_OF_NOTES/from_Wes_whiteboard_pic01.heic`, `pic02.heic`, `pic03.heic`, `pic04.heic`,
  `from_Wes_whiteboard_pic02_bp.jpg`, `DISPATCH_FIELD_flowchart.jpg` — photographs; converted
  `.heic` → JPEG with `sips` and **read visually on 2026-09-04** (see *The photographs, read*).
  Three boards, five shots; no photograph of the AP/collections board.
  The same six files appear twice in the drop, under
  `1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/IMAGES_OF_NOTES/` and under
  `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/zzzOTHER/FLOWCHARTS_VALUE_ENGINES/IMAGES_OF_NOTES/`.
- `VS_CODE/AI_GENERATION/ValEng_PIC01.md` … `ValEng_PIC04.md` and `ValEng_PIC01_AI.md` …
  `ValEng_PIC04_AI.md` — 1.8–3.1 KB each, plain Markdown, copied as-is. **AI-generated
  transcriptions of the photographs; the `_AI` variants are duplicates.**
- `VS_CODE/TEMPLATE/AI_PROMPT_TEMPLATE.md` — 1.8 KB.
- `zz_ARCHIVE/Visio_Data_Visualizer_Flowchart_Template (1).xlsx` — 9.1 KB as converted text; also
  cited from [value-engines-and-playbooks-method.md](value-engines-and-playbooks-method.md) for its
  authoring mechanism.
- `zz_ARCHIVE/Drawing.vsdx` — 47 bytes of extracted text: **one empty Visio page, no content.**

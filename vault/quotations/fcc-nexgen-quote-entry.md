---
title: FCC quote entry — the NexGen and Atom screens, field by field
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/ (QuotesGuide.v.1.2x.docx, SalesGuide.v.2.2.docx, Sales Guide (Atom)v.1.0.docx — text and the 110 embedded screenshots, read 2026-09-04) plus 1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_ENTER_QUOTES (reviewed by TCG).pptx (notes and the 28 embedded screenshots, read 2026-09-04) and 1.0.1_BUSINESS-REQUIREMENTS/TCG_PRICE_LISTS/Price Lists Process in FCC-NexGen.docx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/customers, module/assets, kind/source, pricing, signatures, tools-rigging, reference-data, lift-plans]
entities: []
---

# FCC quote entry — the NexGen and Atom screens, field by field

**What this is.** The vendor's own end-user manuals for the system TCG is replacing, plus TCG's
annotations on the same screens. Four documents:

| Document | Author / date | What it is |
| --- | --- | --- |
| `QuotesGuide.v.1.2x.docx` | Fleet Cost & Care, David Thornton, **v1.2 draft, 2017-06-01** | NexGen desktop quote entry — **the only one of the three with the DocuSign chapter** |
| `SalesGuide.v.2.2.docx` | Fleet Cost & Care, David Thornton, **v2.2 published, 2018-04-24** | The same manual, later and published; adds *Working with Unit Type Defaults* and a Line Item FAQ; **drops the DocuSign chapter** |
| `Sales Guide (Atom)v.1.0.docx` | Fleet Cost & Care, D. Thornton, **v1.0 draft, 2017-09-12** (v1.1, B. Blastow, 2017-10-12 in the change log) | The **mobile/tablet** app — same tabs, plus customer and job-site creation from inside a quote |
| `FCC_ENTER_QUOTES (reviewed by TCG).pptx` | TCG review, undated (18 slides) | TCG's own margin notes on screenshots of these screens |

**Why it matters.** The vault documents what a quotation *should* do (the flow process, the
punch lists, the estimate templates) but has had no field-level account of the screen the
business actually uses. This is that account, and it is the vendor's, so it says what each
field is *for* rather than what someone wants changed.

> The manuals warn that "some functionality and images in this manual represent options that may
> be turned on or off by the system administrator". Presence in the manual is not evidence TCG
> has the feature switched on — the pptx annotations are where TCG says which parts it uses.

---

## 1. Where quotes live in the menu

`Enter → Quotes → …`, with **three windows** the manuals name:

- **Quotes For Jobs** — crane work. `Enter → Quotes → Job Quotes` in TCG's own SOP wording.
- **Quotes For Trucking** — hauling work, with a Loads tab the job quote does not have.
- A third option the guide mentions without naming ("any of three options… generally
  user-specific").

Price lists are maintained elsewhere: `Maintain → Customers → Price List`, and assigned at
`Maintain → Customers → Customers` — see
[fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md).

## 2. Quotes For Jobs — the tabs

`Main` · `Unit/People` · `Estimate` · `Tools/Rigging` · `Lift Info` · `Line Item`. The Atom
manual adds no tabs; the trucking window adds `Loads`.

### Main tab

Begin by verifying **Company**, **Dept** and **Yard**. Then:

| Field | What the manual says it is |
| --- | --- |
| **Customer** | dropdown; magnifying glass for detailed search; **New** button creates the customer inline |
| **Bill To** | the billing address. **v2.2 note:** *"The Bill To field will only appear for users that are integrated with Great Plains or Sage accounting systems."* |
| **Job Site** | select or add |
| **Quote To** / **Quoted To** | the contact the quote is addressed to |
| **Job Date** | the proposed **start** date for the job |
| **Ending Date** | the proposed **end** date |
| **Final Date** | **the last date to submit bids for the job** |
| **Submitted Date** | the date the quote was submitted |
| **Award Date** | the date the job was awarded |
| **Status** | may be set by default if configured; the "Lost" option may or may not be required |
| **Lost Code** + **Lost Comments** | set when applicable |
| **Quote Min** | *"an optional field, refer to company policy for implementation"* — **the manual never says what it does** |
| **Salesperson**, **Taken By**, **Checked By** | three separate people |
| **Job Type** | *"this may be Hourly, Weekly, Monthly, or any other user-defined measure"* |
| **Equipment Required** | free text — *"additional equipment, material, or other details that the employee would need to see when reviewing the job ticket or E-Ticket"* |
| **Comments** | general |
| **Description of Work** | *"carries through to the invoice; summarize the scope of work"* |
| **In House** | *"internal purposes only… can convey information from one department to another"* |
| **Use Quote Detail Amounts** | checkbox. v1.2/v2.2: controls whether Estimate-tab line items appear; *"Uncheck this checkbox to only include a summary."* Atom words it as *"controls the presence of the Estimate tab"* |
| **Billing Type**, **Footer**, **Terms & Conditions** | selected per quote. The trucking window has **Footer** and **T&C** but **no Billing Type** |

**Four of these settle open vault questions, or sharpen them.**

- **`Job Type` is `Hourly / Weekly / Monthly / user-defined`** — the same dimension that
  [fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md) shows keying
  the estimate template (`Hourly` vs `Hourly w/ Mob`), independently confirmed by the vendor's
  manual.
- **`Quote Min` is undefined even by the vendor.** The ERP review log records TCG asking the same
  question twice — Melissa's *"Do we need a quote min and max?"* and Ryan's *"what is quote min
  or max"* — and the 2026-05-05 meeting concluding the team did not know what they were for. See
  [erp-review-log.md](../erp-review-log.md) → *#9 Quotes*, *#13 Sales*. **The vendor manual does
  not answer it either.** The KPI tracker's FCC export carries both `QuoteMin` and `QuoteMax` as
  real columns, and `QuoteMax` is what the dashboards sum as "quote dollars" —
  [sales-reporting-workbooks.md](sales-reporting-workbooks.md) §2.
- **`Checked By` is a person field, not a workflow step.** [quotations.md](quotations.md) asks to
  *"remove `Checked By` from creation form"*; TCG's own SOP instead prescribes a convention for
  filling it — see [tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md) §4.
- **`Description of Work` flows to the invoice.** That is a stated data path from quote to
  billing that nothing else in the vault records.

### Unit/People tab

Add rows with **Add Unt/Ppl**, `CTRL + A`, or right-click. Three columns per row:

1. **Unit/Emp** — *"select an employee or schedule type"*. The Atom guide is explicit that the
   dropdown lists **Schedule Types**.
2. **Type** — *"a unit type or employee type"*.
3. **Comments** — *"any comments that need to be passed to dispatch or the employee"*.

The trucking window adds a fourth, **Load No**, which *"will only populate if the Loads tab
details are entered"*.

> **Stated best practice, repeated in all three manuals:** *"identify all elements of the job on
> this screen, before it is converted to a job. This means to add each unit (e.g. crane,
> tractor), each support element (e.g. rigging truck, trailer), and each employee (e.g. operator,
> rigger, driver). This information will pass through to dispatching and ensures the
> salesperson's intent is captured."*

Two toolbar affordances the FAQs describe: **Move Line** (double-click a row to move it) for
re-ordering, and **Ins Unit/Ppl** to insert a blank row above the highlighted one.

### Working with Unit Type Defaults — v2.2 only

This section exists in `SalesGuide.v.2.2.docx` and in neither of the other two. Quoted in full,
because it is the vendor's own description of the mechanism
[fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md) documents from a
2026 Teams walkthrough:

> "When creating a quote, the Main tab will function as normal. When working in the Unit/People
> tab, **after the Type column is populated and tabbed out of, then the Unit Type Default details
> will be added.** … When this Unit Type Default is used, **because the Estimate tab was also
> configured, the Estimate tab of the quote will already have the Estimate line items listed.**
> All unit types, employee types, and billing codes that were auto-populated by the Unit Type
> Default may be changed or deleted and new unit types, employee types, and billing codes may be
> added as necessary. Although the image portrays the Quote for Jobs window, **the same concept
> applies to the Schedule Jobs window.**"

Its worked example is *"the 265-ton Hydraulic Crane"*. Three things follow that the 2026 material
did not state:

- The trigger is **tabbing out of the `Type` column**, not saving.
- Everything the template inserts is **freely editable and deletable** on the quote.
- **The same defaults fire on the Schedule Jobs window**, so the template is not quote-only.

`Price Lists Process in FCC-NexGen.docx` shows the same behaviour from TCG's side, step 3:
*"This tab get auto-populated with 'estimate template' based on the Mobile Crane entered… and
then the 'Type' entered (90 Ton in this example)… then the rest automatically populates base on
the pre-defined template… and the 'Estimate' tab also gets automatically populated based on the
same Mobile Crane."*

### Estimate tab

*"used for laying out the plan according to billing codes"* (Atom: *"used for detailing out what
will be presented on the quote and invoice"*). Add rows with **Add Est** / `CTRL + A`:

1. **Billing Code**
2. **Quantity**, **Unit Meas**, and **Rate** *"if not set"* — i.e. the rate normally arrives from
   the price list
3. **Line Item** and **Comments** — Atom: *"Enter any comments that should pass through to the
   invoice"*
4. **Item** checkbox — *"used for summary invoicing. Check the checkbox if the estimate line item
   is a subcomponent of a larger billing concept."*

The manual's note on `Item` is the mob/demob case stated by the vendor, years before TCG raised
it:

> "In many cases, **mobilizations are presented to customers as a single line item; however, the
> organization wants to track the itemized processes of mobilization.** For example, a
> mobilization may include 4 tractors, 4 trailers, travel time to the job site, assembly time,
> permitting, and OT or DT time. If this information should not be shown on the quote, check the
> box."

The Atom guide is vaguer and calls the same flag **Sub-Item**: *"Sub-Item is used to identify an
estimate line item as a sub-item of another estimate line item. This function may or may not be
used; double-check with company management on specific policies."*

**The `Item` checkbox FAQ — the vendor's own procedure.** Reproduced because it describes how
grouping is actually achieved on this screen, which is by **row order**:

1. Initially leave all Item checkboxes unchecked.
2. Populate all necessary billing codes, *"try to follow a logical flow"*. **"Order the billing
   codes in a manner that groups all proposed non-viewable billing codes together."**
3. Add an encompassing billing code, like **Mobilization**.
4. From the top of the group of non-viewable codes, begin checking the Item checkbox.
5. Check all boxes that are to be hidden. *"As this process is executed, the Amounts column will
   change as the estimate line item amounts are 'pushed' toward the encompassing billing code."*
6. **"The summary amount should be visible in the first non-checked Item row. This is the summary
   line that will appear on the quote."**
7. *"This may be completed for multiple groups, just ensure that a summary line item… separates
   each group."*
8. Save.

> **This is the mechanism, not the model.** Brian Petros' 2026 correction — that FCC stores
> `FMS_UNIT_TYPE_ESTIMATE.ParentEstimateID` as an explicit parent link, with `.Item` as a
> separate visibility flag — still stands; see
> [fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md) §3. What the FAQ
> adds is that **the end-user procedure works purely by ordering and ticking**, which is why the
> screen looks like row-order grouping. The stated payoff: *"it enumerates costs to help with
> costing, planning, metrics, and forecasting while offering a simplified quote for the customer.
> It also passes all of the information on to the Dispatcher and Billing so that down-stream
> managers understand the intent of the salesperson."*

### Tools/Rigging tab

*"a listing of any non-serialized, but accountable tools… most rigging does not have serial
numbers, but must be accounted for."* Per row: **Category** (user-definable list, maintained at
`Maintain → Tools → [Categories] or [List]`), **Tool**, **Qty Out**, **Out Date**, **Comments**
(*"a tool modifier like '20′ blues'"* — v2.2 says *"20′ chains"*). On return to the yard the row
is updated with **Qty In** and **In Date**.

TCG's pptx annotation on this screen:

> "**Tools/Rigging:** Inventory for tools/rigging is currently not in FCC. Will need to provide
> list of inventory so we can include this in the Quote so **Warehouse knows what is available
> and Dispatch knows what to include on the Job.**"

So the tab exists but TCG has no inventory behind it — which is why
[assets/tool-and-rigging.md](../assets/tool-and-rigging.md) and the punch-list item *"total
inventory"* in [quotation.md](quotation.md) exist.

### Lift Info tab

*"provides the details of the job to the operator or driver… This information is passed through
to the job ticket and E-Ticket."* And: *"Note: This information is also shown on the quote."*

The manual does not enumerate the fields. TCG's own SOP does, and the real quote OM-36229 prints
them — see [tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md) §6 and
[quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §0.

One vendor observation worth keeping: *"Some organizations may only enter a numerical value in
each field; whereas others enter the unit of measure as well. This is an internal procedure."*
The printed quote confirms TCG enters bare numbers.

### Line Item tab

*"intended to be used as a reference tool, but can be modified when necessary. The records are
populated based on selections in the Estimate tab… Line Items are used by project managers and
management to breakout costs in specific ways like phases; or, for consolidation of billing
items."*

The v2.2 FAQ adds how to create one by hand: on the Line Item tab, **Add Line Item** / `CTRL+A`,
then *"specify whether the Line Item is an **Expense, Revenue, or both**. In most cases, 'Both'
will be the preferred option… The dollar values and Est Hours will populate based on selections
in the Estimate/Est Bill tabs."*

**TCG does not use this tab.** The pptx says so directly: *"**Line Item:** Not used. **Tasks:**
Not used."*

## 3. Quotes For Trucking — what differs

Same six tabs plus **Loads**. On Main, `Job Site` and `Quote To` are replaced by four fields:
**Loc To** (delivery destination), **Cust From** (customer the delivery originates from), **Loc
From** (origin location), **Quoted To**. `Equipment Required` becomes **Items To Ship**;
`Comments` becomes **Instructions**. There is no `Billing Type`.

The **Loads** tab has four sub-tabs of its own:

| Sub-tab | Fields |
| --- | --- |
| **Load Main** | **Load No** (*"an arbitrary number that must be unique for within the job"*) · Commodity · Customer From · Ship From · Customer To · Ship To · Load Date · Load Time · Delivery date · Delivery time |
| **Load Detail** | Permits · Comments · Directions · Routing · Commodity **Weight/Width/Length/Height** · Loaded **Weight/Width/Length/Height** |
| **Load Unit/People** | Unit/Emp (schedule type) · Type (unit type) · Comments |
| **Load Axle Groups** | Steering Weight · Drive Weight · then per **Trailer Group**: group number + **Axle Weight** |

After the Loads tab is filled, *"the Load No will populate on the appropriate unit on the
Unit/People tab"*.

**Nothing in the vault covers trucking quotes.** Whether TCG uses this window at all is not
stated anywhere in the drop.

## 4. Emailing a quote, and DocuSign

Both hang off the **Lightning Bolt** (attachments) icon, which opens **Maintain File Links –
Quote**.

**Generating the PDF.** Click **New Doc**, choose a **quote layout** from the dropdown, OK. This
creates the PDF and adds a row to Maintain File Links with columns **File Name** (*"the address
where the new document is stored"*), **Envelope Status** (blank at first), **Comments**, and
read-only **Created By / Modified By / Created Date / Modified Date**.

**Plain email.** Highlight the document row, click **E-Mail**, fill in and send. *"In some cases,
a variety of formats may be available, but for some configurations, the Adobe Acrobat (PDF) is
the only option and is grayed-out."*

**DocuSign** — from `QuotesGuide.v.1.2x.docx` only, and from the Atom guide's *Generate New Doc*
chapter. The sequence:

1. Generate the quote PDF via **New Doc** first — *"To access DocuSign, a quote document must
   first be generated."*
2. Click **Post Doc**. A success dialog confirms.
3. The customer receives an email *"from an administrator controlled email address"* and clicks
   **Review Document**.
4. The customer must accept DocuSign's terms — **a one-time action; future quotes skip it**.
5. **An email notification goes to the salesperson when the customer opens the document.**
6. Customer signs (Signature → place → **Adopt And Sign**) and clicks **Finish**.
7. NexGen tracks state in the **Envelope Status** column. **Get Status** (only available from
   Maintain File Links) refreshes it.
8. Status → **Delivered** once reviewed; → **Complete** once signed.
9. On Complete, **Download** adds *a new row* whose Envelope Status is **Signed Document**.

**The observed envelope states are therefore: (blank) → Delivered → Complete, plus a separate
downloaded row marked Signed Document.** The Atom flow is identical but routed through the
overflow menu (*DocuSign → Post Document / Get Status / Download Document*), and adds a plain
**Share** option that hands the PDF to whatever the device can send it with.

This is the ancestor of the DocuSign behaviour the punch lists complain about —
[quotations.md](quotations.md) lists duplicate DocuSign emails, *"`Envelope voided` — it should
be user friendly"*, resend confusion and *"Quote attachment should not be sent to docusign"*.
**Neither manual documents voiding an envelope**, so the void path is not described anywhere in
this drop.

## 5. Convert to job, and copy a quote

**Conv Job.** From an open quote, the **Conv Job** toolbar button prompts for confirmation
(*"note the quote number in the dialog box"*), then opens **Schedule Jobs** with a dialog asking
for job times.

Three consequences the manual states:

- **A converted quote is locked.** *"If a quote has already been converted to a job, it will
  appear grayed-out. This is to show that no changes can be made to the quote and all changes
  must occur in the job screen."*
- **The link is a field.** *"Refer to the **Converted To Job** field for a job number reference.
  Double-clicking on the Converted To Job field will open the job screen."*
- **Some fields exist only on the job.** *"A few fields are not available in the Quote window
  that are present in the Schedule Jobs window. Now is a good time to add information to these
  fields, including **PO number, job times, travel time adjustments, specific employee and unit
  assignments, and Report To contact.**"*

That last line independently confirms the lifecycle diagram's *"Log customer PO # — record on
job / schedule tab"* — see
[quote-lifecycle-permits-and-purchase-orders.md](quote-lifecycle-permits-and-purchase-orders.md)
§1. **In FCC the customer PO is a job field, not a quote field.**

**Copy Quote.** *"With the original quote open, click on Copy Quote… The **Copy Job Detail**
window will appear… Unchecking any of the boxes will prevent specific information from being
copied and provide the user with a clean slate for that area. The **Start Date** and **End Date**
are the applicable dates for the new quote."* The copy is unsaved until saved — *"An easy way to
spot the difference… is the missing Quote No in the top left."*

**Nothing in the vault describes copying a quote.** The stated use case is *"The customer wants
the same unit back at the same site."*

## 6. TCG's annotations on these screens — `FCC_ENTER_QUOTES (reviewed by TCG).pptx`

18 slides of screenshots with TCG notes. Every note that carries content:

| Slide | TCG's note |
| --- | --- |
| 1 | "Different types of Quotes" |
| 3 | "Example of a **pop-up Customer Note** when Quote is opened." |
| 4 | **Certified Pay:** *"This should be 'Job specific'. Certified Pay is more granular than Customer (needs to be **per Job or defaulted per Job Site**)."* · **PO Number:** *"This is the 'Customer PO number' — the PO Number that Customer give us."* · **"New" buttons:** *"Can click 'New' to create new Customer, Job Site, etc."* |
| 5, 6 | "This is where the **templates auto populate** (based on the primary crane/vehicle selected)" — slide 6 adds *"And this screen includes the rates (based on the **customer/price list**)"* |
| 7 | **Tools/Rigging** (quoted in §2 above) · **Lift Info:** *"Specific to the Job Quote"* |
| 8 | **Line Item:** *"Not used."* **Tasks:** *"Not used."* |
| 10 | **Job Quote Documents:** *"Lift plans and other documents per Job Quote"* |

Four requirements are stated or implied here and appear **nowhere else in the vault**:

1. **A customer note pops up when a quote is opened.** A blocking/attention behaviour on quote
   open, driven from the customer record.
2. **Certified Pay must be per job, or defaulted per job site — not per customer.** This is a
   direct correction of FCC's data model and bears on certified payroll; the payroll module holds
   the reporting side but not this placement rule.
3. **`PO Number` on the quote screen is the customer's PO** — TCG confirming the direction, which
   matters because the same screen family also carries vendor POs.
4. **Rates on the Estimate tab come from the customer's price list**, stated by TCG, not just by
   the vendor.

## What the guides' screenshots show — read 2026-09-04

The images inside the three `.docx` files were extracted and read directly (Atom: 72 images,
of which 2 are JPEG-XR `.wdp` icon files that could not be rendered; Quotes v1.2: 30;
Sales v2.2: 8 unique — the rest are byte-for-byte duplicates of the v1.2 images). What follows
is only what the screenshots add to the text above; screens the text already describes field by
field are not repeated. Two are noted as **contradictions** of the text. Everything here is FCC's
own 2016–2017 demo database ("Fleet Cost & Care", "Atlanta Yard"), not TCG's configuration — the
TCG screen as configured in 2026 is transcribed in
[fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §4.

### `Sales Guide (Atom)v.1.0.docx` — the mobile app

**The dashboard.** The full tablet home screen (Atom 2.2.86) is grouped into five bands, and the
icon set is the union of every persona, not just sales:

| Band | Icons |
| --- | --- |
| E-Documents | Operator Ticket · LEM Ticket · Trucking Ticket · Load Ticket · My Work Orders · My Labor |
| Maintain | Customers · Customer Job Sites |
| Schedule | Jobs · Trucking |
| Enter | Labor · Quotes For Jobs · Work Orders · Quotes For Trucking · **Quotes For Work Orders** |
| Display | Job Schedule · Unit Schedule · Employee Schedule · Availability Report · Employee Work Order Schedule · **Docusign Dashboard** |

The header overflow menu offers *Display Registration · Contact Support · Request Assistance ·
Change Password*. The text's "three options" under Enter → Quotes are therefore **Jobs, Trucking
and Work Orders** — the desktop menu screenshot (below) confirms the same three names.

**Quote list / search.** Opening *Quotes For Jobs* shows a search form, not a list: **Search
By** (dropdown, `Quote #` shown) · **Search Text** · **View** button · **From** / **To** date
range (defaulted to a wide window, `1/1/15 – 5/30/18` in the capture); a green `+` starts a new
quote. The trucking equivalent is titled *Trucking Quotes* and is identical.

**The quote form.** Tabs `Main · Unit/People · Estimate · Tools · Lift Info · Line Item` (the
mobile tab is *Tools*, not *Tools/Rigging*). Toolbar: **SAVE · CONVERT TO JOB · COPY QUOTE ·
MAP · FILE LINKS**. The **MAP** button is not mentioned in any of the three texts; the Quotes
guide's first image is a Google Maps route-planner window, which is presumably what it opens.
Main-tab fields beyond the text's list: **Quote No** (`AUTO` until saved), **WP / CP / Email**
under Quoted To (the contact's work phone, cell phone and e-mail, auto-filled from the contact),
**Converted To Job**, and **both `Quote Min` and `Quote Max` as editable fields** (both `0.00`
on a new quote). The **Customer** and **Job Site** labels are blue hyperlinks — tapping them
opens the customer / job-site record for editing, which is how the text's "Modify Existing
Customer" works. Defaults visible on a new quote: Status `Pending`, Job Type `Hourly`, Footer
`Thank you`, Terms & Conditions `FCC Quote Terms`, Billing Type `Rental`, `Use Quote Detail
Amounts` ticked. Quote numbers in the demo carry a prefix — a saved trucking quote is
**`ATC-878`**; the File Links window titles the same records `Quote - 844` / `Trucking Quote -
844`.

**Unit/People on mobile.** Rows are cards (Unit · Type · Comments) with a per-card `⋮` menu and
a green `+`. The *Edit Unit/People* form has just **Unit/Emp · Type · Comments**. The **Unit/Emp
dropdown lists Schedule Types**, and the demo's list begins `Employee · Accessories · Aerial ·
Attachment · Crane - Mobile, Hydraulic · Crane - New descr · Customer · ForkLift …` — so a
Schedule Type is a category of resource, one of which is `Employee` and one of which is
`Customer`. The worked example is a nine-row crew for a `Crane - Mobile, Hydraulic / 130 Ton
Mobile Crane`: Employee/`Operater, 1st class`, three Truck/`Tractor`, three Trailer/`Trailer`,
two Employee/`Driver`.

**Estimate on mobile.** *Edit Estimate* has **Billing Code** (typed, with a filter dropdown) ·
**Quantity · Unit Meas · Rate** · **Line Item** (dropdown) · **Comments** · **Sub-Item**
checkbox. The demo billing-code list: `100 Ton Monthly Rate · 110 Ton Mobile Crane - Hourly
Rate · 110 Ton Overtime Rate · 120 Ton Crane and Operator · 130 Ton Mobile Crane - Hourly Rate ·
130 Ton Overtime Rate · 175 Ton Hourly Bare Test · 175 Ton Hourly Rate`; the worked row is `175
Ton Hourly Rate · 8.00 Hours · $288.00 · Line Item "Daily Work" · comment "4-hour minimum"`, and
the trucking equivalent `Tractor/Trailer With Driver · 8.00 Hours · $350.00 · "4 hour minimum"`.
A minimum-hours note typed into the estimate comment — the same practice TCG's SOP prescribes —
is what FCC's own trainer did.

**Tools on mobile.** *Edit Tool*: **Category** (dropdown) · **Tool** (typed, filtered) · **Qty
Out / Out Date** · **Qty In / In Date** · **Size/Comments**. The demo **category list** —
`Electric Tools · Hammer · Hoisting Equipment · Jacking Equipment · Mats · Miscellaneous ·
Packing Material · PERMITS · Rigging Components · Trucking Materials` (plus a `test apple`) — and
the tools under *Rigging Components*: `1"X20' Wire Rope Slings · 1/2 Steel Chokers · 14'
Spreader Bar · 4-Leg Sling Chain · Crosby Shackles - 1" · D Ring 1/2 · D Ring 3/4 · Spreader,
Set - 3/4" x 20'`. That `PERMITS` is a *tool category* in FCC's demo is worth knowing when reading
[quote-lifecycle-permits-and-purchase-orders.md](quote-lifecycle-permits-and-purchase-orders.md).

**Lift Info on mobile — the fields the text does not enumerate.** A single scrolling column:
`Lift Radius · Height · Crane Capacity · Pieces · Total Weight · CWT Config. · Boom Length · Set
Back Fr. Bldg. · Radius · test height · Length · Width · Height · Pieces …`. The desktop
screenshot (below) shows these are two groups, *Lift Info* and *Trucking Info*, flattened on
mobile. The presence of a field literally labelled **`test height`** in FCC's demo, next to two
different `Radius` fields, shows the **labels are tenant-configurable**, which is why TCG's
version of this tab ([tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md) §6: *Main Boom
Length, Jib / Luffer Length, CWT, Radius, Load Weight, Cap at Radius, Lift Depth, Jib Offset,
Setup Distance, Height*) shares only a few names with FCC's. The trucking quote shows the same
Lift Info column.

**Line Item on mobile.** Cards `Line # · Line Item · Exp/Rev/Both · Amnt Quoted · Est Expenses ·
Est Hours`; the demo has two, `Mobilization In & Out` and `On-Site Operation`, both `Both`.

**Trucking quote on mobile.** Tabs `Main · Unit/People · Estimate · Tools · Lift Info · Line
Item` — **there is no Loads tab on Atom.** Main replaces Job Site / Quoted To with `Loc To · Cust
From · Loc From · Quoted To` and `Equipment Required` / `Comments` with `Items to Ship` /
`Instructions`, exactly as the desktop text says; it also shows **no Billing Type** field. The
Convert-Quote-to-Job chapter's screenshot of the same window is a saved trucking quote
(`ATC-878`, Dept `Cranes, Operated`, Status `Awarded`, Quote Max `3255.00`) whose tab strip reads
`Main · Additional Info · Unit/People · Tools · Lift Info · Line Item` — an **Additional Info**
tab in place of *Estimate* — which no text explains. Whether that is a version difference or a
configuration is not stated.

**Convert to job, as seen from mobile.** The result screen is *Schedule Trucking Jobs* for job
`2435`, and it is the only image in the three guides of the **job** screen. Its tabs: `Main ·
Unit/People · Estimate · Act Billing · Tools · Lift Info · Daily · Owner Info · PO · Line Item`.
Main-tab fields that the quote does not have, all visible: **PO No**, **Job Date From / To**
with **Flexible** checkboxes, **Job Time** (`7:30 AM – 4:30 PM`), **Work Weekends** (ticked),
**Dispatched**, **Signed Contract**, **Certified Pay**, **Terms** (`Terms - GA`), **Checklist**,
**Report To** (with WP / CP / E-Mail), **Ordered By** (with WP / CP / E-Mail), and **Quote No**
(`ATC-878`) linking back. Status on the job is `Confirmed`. This is the vendor's screen showing
what the text lists in words — PO number, job times, Report To — and it adds **Signed Contract**
and **Certified Pay as job-level checkboxes**, which bears directly on TCG's pptx note that
Certified Pay must be per job (§6 above).

**Customer and job-site creation from inside a quote.** The text lists the customer fields; the
screenshots add the **defaults**: `Cust Code AUTO`, Status `Active`, Country `USA`, Statement
Type `Open Item`, **Mark Up `%Above Cost` / `10.00`**, and the tab strip `Main · Miscellaneous ·
Billing · Contacts · Invoices · Collection Notes · Certifications · Bill To`. The *Contacts* tab
has a `View: All` filter; a new contact defaults **Ordered By/Report To to `Both`** and Status to
`Active`. *Edit Certificates* is two fields, `Unit/Employee` (default `Unit`) and `Certificate`.
The *Edit Job Site* form — which the text describes but does not list — is: `Job Site · Address
(2 lines) · City · State · Zip · County` | `Fax · Phone · Country · Ordered By (+ WP / CP /
E-Mail) · Report To` | `WP · CP · E-Mail · Alternate Phone · Description · Taxable (checkbox +
tax-code dropdown) · Status (Active)` | `Directions` (full-width free text). Tapping the blue
*Job Site* link on a quote pops a card with **Address · Phone · Fax · Directions** and an *Edit*
button; the *Job Sites* screen has tabs `Main · Contacts · Certifications` and shows sites as
cards (`Job Site · Address · City · Ordered By · Phone`). The demo's example job site is named
**`[Billing Address]`** — a site record that simply mirrors the customer's billing address, a
convention the text does not mention.

**File Links, New Doc and DocuSign on mobile.** The *Quote File Links* screen's toolbar is **TAKE
PHOTO · NEW DOC · UPLOAD PHOTO · UPLOAD FILE**, with the empty state *"Filelinks are empty. Please
add a file from the menu."* **New Doc** opens *Select Document* with four layouts in the demo —
**`Rental Estimate · Quote · Quotes Detail · Quotes Summary`** — and *Generate / Cancel*. (TCG's
SOP tells its staff to pick *"Detail Quote"*; the layout list is evidently tenant-specific.)
Each generated file appears as a card (`844.pdf`, user, timestamp, an *Envelope Status* line)
whose `⋮` menu is **Edit · View · Download · Share · DocuSign**. Posting confirms with *"Document
posted successfully to <contact name> (<e-mail>)"* — i.e. the envelope goes to the **Quoted To
contact's e-mail**, which is the only place any of the guides shows who the recipient is. The
customer-side DocuSign screens are the same captures as the desktop guide (below). **Copy Quote**
on mobile shows the *Copy Job Detail* dialog's actual contents: *"Select the data to copy"* —
**Estimate · Equipment · People** checkboxes (all ticked) and **Start Date / End Date**.

### `QuotesGuide.v.1.2x.docx` — desktop, v1.2 (2017)

**The menu.** `Enter → Quotes →` **`Quotes For Jobs · Quotes For Trucking · Quotes For Work
Orders`** — the third window §1 above could not name. The rest of the *Enter* menu visible in the
capture: `Labor · Materials · Inventory Stock Adjustments · Quotes · Order Entry · Order Pick
Ticket Shipment · Job Parts Shipment · Work Orders`.

**Main tab, as shipped in 2017.** Beyond the text's field list the window carries: `WP / CP /
E-Mail` under Quoted To; a **Bill To Information** panel (address, phone, fax, and **Price List**
— so the customer's price list is displayed on the quote header, read-only); a **Job Site
Information** panel (address, phone, fax); `Created By / Modified By / Created Date / Modified
Date`; and a **Footer** dropdown whose selected value `Thank you` expands to the text *"We thank
you for this opportunity to serve you!!"* beside it. Defaults on a new quote: Status `Pending`,
Job Type `Hourly`, Billing Type `Rental`, Terms & Conditions `FCC Quote Terms`, Quote Min / Max
`$0.00`, Dept `Cranes`, Yard `Atlanta Yard`. **Absent from FCC's 2017 screen but present on
TCG's 2026 screen** ([fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md)
§4): `Certified Payroll`, `PO No`, `Industry Code`, `Report To`, `Job Time / Ending Time`, and
the `Tasks` tab. Those are therefore either later FCC additions or TCG configuration; the guides
do not say which.

A second Main-tab capture (quote `10004`, in the Conv Job chapter) is a converted quote: `Converted
To Job 2299`, Status `Awarded`, Dept `Bare Rer[ntal]`, Billing Type `Rental`, Price List `SCOOBY
DOO`, customer `Abramo Cement & …`, Description of Work *"Front Loader Bare Rental"*, Comments
*"Customer will pick up and drop off unit"*. Its **Checked By is `Customer, Verified`** — FCC's own
demo carries a pseudo-person in the Checked By list for "the customer checked it", which is the
same convention TCG's SOP states in words (*"Always enter 'Customer' unless you have personally
visited the jobsite"* — [tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md) §4). The
convention predates TCG.

**Estimate tab — the v1.2 grid has three tiers.** Column headers are `Billing Code · Quantity ·
Unit Meas · Rate · Amount · Line Item · Item` on the first header row, then **`Quantity2 · Unit
Meas2 · Rate2 · Amount2`** and **`Quantity3 · Unit Meas3 · Rate3 · Amount3`** on the second and
third rows, with `Comments` spanning. Each estimate line can therefore carry up to three
quantity × rate pairs. Nothing in any text mentions the second and third tiers, and the v2.2 and
Atom grids do not show them. Worked example (quote `60434568`): `Mobilization In & Set-UP · 1 Each
· $450` (Line Item *Mobilization In & Out*) · `110 Ton Mobile Crane - Hourly · 1 Hours · $250`
(*On-Site Operation*) · `110 Ton Overtime Rate · 1 Hours · $20` (*SW Ind Test*) · `Mobilization
Out & Disassembly · 1 Each · $450`; **Total Quote `$1,170.00`** is printed under the grid.

**Lift Info tab — the fields, in two groups.** *Lift Info*: `Lift Radius · Height · Crane
Capacity · Pieces · Total Weight` | `CWT Config. · Boom Length · Set Back Fr. Bldg. · Radius ·
test height`. *Trucking Info*: `Length · Width · Height · Pieces · Total Weight`. The trucking
quote's Lift Info tab is identical. TCG's SOP says to ignore *Trucking Info* — this is the group
it means.

**Line Item tab.** `Line # · Line Item · Exp/Rev/Both · Amnt Quoted · Est Expenses · Est Hours`.

**Quotes for Trucking.** Main adds a **Job Site From Information** and **Job Site To
Information** panel below Bill To Information. The v1.2 Unit/People grid has the `Load No`
column the text describes. The **Loads** tab is a grid `Load No · Commodity · Start Date · End
Date · Location From · Location To` above four sub-tabs; *Load Main* has `Customer From` and
`Customer To` each with **New** and a search, `Ship From` / `Ship To` each with **New**, Load Date
/ Time and Delivery date / time (`07:30 AM` / `04:30 PM` in the demo), and *Customer From / To
Information* and *Job Site From / To Information* address panels. *Load Detail* (commodity `HVAC
UNIT`) gives the **units the text omits**: Commodity Weight in **Kg and Lbs**, Commodity Width /
Length / Height in **Ft and In**, Loaded Weight `KG/LBS`, Loaded Width / Length / Height `M/FT`.
*Load Unit/People* is the same three columns as the main Unit/People grid (`Truck / Tractor`,
`Trailer / Test trailor`). The demo's trucking estimate is `100 Ton Monthly Rate · 1.00 Months ·
$2,500.00`.

**Maintain File Links – Quote, and the envelope states actually captured.** The window is a grid
`File Name · Envelope Status · Created By · Modified By` / `Comments · Created Date · Modified
Date`; files are stored as paths (`Y:\FCC_Attachments\TEST3344.pdf`, `c:\quotes\60434568-1.pdf`).
The **E-Mail** dialog is *Email PDF*: `Format (Adobe Acrobat (PDF)) · Destination (Email) · Page
Range All / Pages From–To · To · Cc · Subject · Message`. The DocuSign captures show **envelope
status values the text never names**:

| Moment | Envelope Status shown |
| --- | --- |
| After New Doc | *(blank)* |
| After **Post Doc** | **`sent`** |
| After **Download** | original row → **`Downloaded`**; new row `TEST3344-Completed.pdf` → `Signed Document` |
| On a different quote (`60434568-1.pdf`, in the Conv Job chapter) | **`voided`** |

So the full observed set is **blank → sent → Delivered → Complete → Downloaded**, plus `Signed
Document` on the downloaded copy (named `<quote>-Completed.pdf`), plus **`voided`**. Two
corrections to §4 above follow. (1) The text's *"→ Complete"* is the state at which Download is
allowed; **after Download the original row reads `Downloaded`**, not Complete. (2) §4 says
*"Neither manual documents voiding an envelope"* — the **text** does not, but the v1.2 Conv Job
screenshot shows a `voided` envelope in the grid, so the state exists in the product; how it is
reached is still undocumented. That same capture shows an **`Include On Job`** checkbox column on
the file-links grid — attachments can be flagged to carry over to the job on conversion — which
no text mentions either.

**The customer-side DocuSign screens** are FCC's demo quote `test3344` rendered as *"Fleet Cost &
Care Quotation"*: a header block `Document Date · Customer · Contact · Phone · Fax · Email` on the
left and `Quote No · Contact (the salesperson) · Phone · Fax · Email` on the right; then line
items printed as *description / qty / unit / rate / amount* with the estimate **comment as a
second line under each item** (`8 Hr Minimum per day`, `Per Person - Applicable after/before
normal business hours, and Weekends`, `In & Out - 120 Ton CWT`); a `Fuel Surcharge 4%` line
entered as `1.00 %` at `4.00%` = `$64.00`; **Grand Total**; and a **Description Of Work** box.
The signer places the signature tag freely — the PDF has no pre-anchored signature field — using
DocuSign's left-hand *Fields* palette (`Signature · Initial · Date Signed · Name · First Name ·
Last Name · Email Address · Company · Title · Text · Checkbox`). The signing e-mail comes from
*"Support at Fleet Cost and Care"*.

### `SalesGuide.v.2.2.docx` — desktop, v2.2 (2018)

Only eight images are unique to v2.2; the rest reuse v1.2's. What they add:

**Unit Type Defaults, seen firing.** Selecting `Crane - Mobile, Hydraulic` and then Type
`265-ton Hydraulic Crane` and tabbing out yields **fourteen rows**, each with a comment that
travels from the template:

| Unit/Emp | Type | Comments |
| --- | --- | --- |
| Crane - Mobile, Hydraulic | 265-ton Hydraulic Crane | |
| Employee | Operator | Will operate the 265 |
| Truck | Tractor | |
| Trailer | Trailer | CWT #1 |
| Employee | Driver | Will drive tractor and oil/rig on site |
| Truck / Trailer / Employee | Tractor / Trailer / Driver | CWT #2 · Will drive tractor and return after setup/breakdown |
| Truck / Trailer / Employee | Tractor / Trailer / Driver | CWT #3 · Will drive tractor and return after setup/breakdown |
| Truck / Trailer / Employee | Tractor / Trailer / Driver | CWT #4 · Will drive tractor and return after setup/breakdown |

Four tractor-trailer-driver sets for the counterweight loads, the first driver doubling as
oiler/rigger — the template carries **crew instructions, not just resource types**. Compare TCG's
275-ton configuration in [fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md)
§4 (three tractors, `OL`, `.1`, `.2`), which is the same shape with one fewer load.

**The Estimate grid in v2.2 is labelled `Sub-Item`, not `Item`.** Column headers: `Billing Code ·
Quantity · Unit Meas · Rate · Amount · Line Item · Comments · Sub-Item` — single tier, no
`Quantity2/3`. **This contradicts §2 above**, which (from the text) has v1.2/v2.2 calling the
checkbox `Item` and only Atom calling it `Sub-Item`: the v2.2 *text* still says "Item checkbox"
in its FAQ, but the v2.2 *screen* says `Sub-Item`, matching Atom. The label changed between 2017
and 2018; the FAQ was not updated.

**The `Item` / `Sub-Item` FAQ, worked live** — the 265-ton estimate that the Unit Type Default
also populated. The grid, with the checkbox state:

| Billing Code | Qty | UoM | Rate | Amount | Line Item | Comment | Sub-Item |
| --- | ---: | --- | ---: | ---: | --- | --- | :-: |
| Trucking - Legal Load | 12.00 | Hours | $500.00 | $6,000.00 | Mobilization In | 4 trucks @ 3 hours | ☑ |
| 265-ton AT Crane & Operator | 3.00 | Hours | $575.00 | $1,725.00 | | Travel and on-site | ☑ |
| Permit(s) | 1.00 | Each | $0.00 | $0.00 | Mobilization In & | One-time fee to | ☑ |
| Fuel Surcharge | 1.00 | Each | $35.00 | $35.00 | | Fee to cover fuel | ☑ |
| **Mobilization In & Set-UP** | 1.00 | Each | *$7,760.00* (greyed) | **$7,760.00** | | Travel to job site | ☐ |
| 265-ton AT Crane & Operator | 4.00 | Hours | $575.00 | $2,300.00 | | Hook Time | ☐ |
| Trucking - Legal Load | 12.00 | Hours | $500.00 | $6,000.00 | Mobilization In & | 4 trucks @ 3 hours | ☑ |
| 265-ton AT Crane & Operator | 3.00 | Hours | $575.00 | $1,725.00 | | On-site breakdown | ☑ |
| Fuel Surcharge | 1.00 | Each | $35.00 | $35.00 | | Fee to cover fuel | ☑ |
| **Mobilization Out & Disassembly** | 1.00 | Each | *$7,760.00* (greyed) | **$7,760.00** | | Breakdown of | ☐ |

**Total Quote `$17,820.00`** = 7,760 + 2,300 + 7,760. Three things the FAQ text leaves implicit
are visible here: the ticked rows sit **above** their summary row, and the summary is *"the first
non-checked row"* after them, exactly as step 6 of the FAQ says; the summary row's **Rate is
computed and greyed** (6,000 + 1,725 + 0 + 35 = 7,760), so the operator never types it; and a
`$0.00` `Permit(s)` line is carried as a sub-item purely so it appears on the internal breakdown.
This is the mob/demob presentation TCG wants (§2, *Item checkbox*), demonstrated by the vendor.

**A second v2.2 estimate** (a 500-ton job, `Total Quote $12,896.00`) shows the alternative with
nothing ticked: `500 Ton Crane and Operator 8.00 Hours $650` (*"8 Hr Minimum per"*), `Labor
Overtime 0.00 Hours $30` (*"Applicable during"*), `500 Ton Crane Travel - In / A… 1.00 Hours
$650`, `Trucking - Legal Load 5.00 Each $500`, `Trucking - Permitted Load 1.00 Each $0`,
`Permit(s) 1.00 Each $0`, `Mobilization In & Set-UP 1.00 Each $450`, the mirror set for travel
out, and **`Fuel Surcharge 4% · 1.00 · % · 4.00% · $496.00`** — the surcharge as a
percentage-of-total line with unit of measure `%`, the pattern TCG's estimate template also uses
(*Fuel & Insurance Surcharge · 1.00 Each · 12.00%*).

**Trucking Unit/People in v2.2** shows only `Unit/Emp · Type · Comments` — the `Load No` column
of the v1.2 capture is not there, although the v2.2 text still says the Load No *"will populate
on the appropriate unit on the Unit/People tab"*; screenshot and text disagree within the same
manual. **Line Item tab** in v2.2 shows four user-defined values in
use: `Mobilization In & Out · On-Site Operation · Daily Work · gather ar codes`, all `Both` — the
Line Item list is free-form reference data, not a fixed enumeration.

**The `Include On Job` column and `voided` status** appear in v2.2's *Emailing a quote* capture
too (same quote `60434568`, files `60434568.docx`, `-1.pdf` *voided*, `-2.pdf`, `-3.pdf`).

## What the deck's screenshots show — read 2026-09-04

The 28 images inside `FCC_ENTER_QUOTES (reviewed by TCG).pptx` were extracted and read on
2026-09-04. They are TCG's production system (company `CG`, yard `Main Yard`), walked through a
real quote, **`OM-36519`** for Mastec Network Solutions, created 3/18/2026. What follows records
only what the manuals and TCG's notes above did not already give. Contact names, phone numbers
and e-mail addresses visible on the screens are deliberately not copied.

### Three quote windows, not "three options" (slides 1, 11, 12)

`Enter → Quotes` opens a submenu of exactly **Job Quotes · Trucking Quotes · Work Order Quotes** —
the third window the manual's text left unnamed (§1), which the 2017 guide capture above calls
*Quotes For Work Orders*; on TCG's 2026 system it is **Work Order Quotes**. TCG's slide-1 note
*"Different types of Quotes"* is this submenu. The Job Quotes toolbar reads **New Quote · Del
Quote · First / Previous / Next / Last · Conv Job · Copy Quote · Map · Refresh · Save Layout · Save
· Print · Close**; the Work Order Quotes toolbar swaps in **New WO Quote · Del WO Quote · Convert
to WO · Copy WO Quote**.

### Quote Lookup (slide 2)

The search dialog behind the magnifier: **View By** `All Quotes` · **Use** `Job Date` · a
**From / To** date range (11/01/2025–12/31/2025 in the shot) · columns **Quote No · Customer ·
Status · Quote Max · Quote Lost · Start Date · End Date · Job Site**, with a lower pane listing
the highlighted quote's units (**Sched Type · Unit Type · Unit Code · Comments**) and buttons
**OK · Cancel · Save As · Print · Show Work Desc · Hide Equipment**. Every visible row is
`Pending`, listed newest first from `OM-36540` down to `OM-36505`, with `Quote Max` values from
$1,368.50 to $452,933.20 — **`Quote Max` is the amount column the lookup shows, i.e. the quote
total** (see the `Quote Max` finding in [fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md)
§4). The `OM-` prefix is the department (`OM` = Operated & Maintained) and the number is the
company-level quote counter — [../admin/fcc-nexgen-administration-and-security.md](../admin/fcc-nexgen-administration-and-security.md).

### The customer pop-up (slide 3)

TCG's *"Example of a pop-up Customer Note"* is a modal titled **Customer Notes**, heading
**Pop - Up Message**, listing the customer's note rows over the still-loading quote, with a single
**OK**. For Mastec the two rows read *"Please make sure Mastec is giving you a site id whenever
they are scheduling. If they do not please do not schedule"* and *"Please do not schedule without
a PO#"*. So the pop-up is **one dialog carrying every note flagged for that screen, not one dialog
per note**, and the notes are operational instructions to the scheduler. The Notes tab that feeds
it is on the Customers screen — [../customers/fcc-maintain-customers-tcg-review.md](../customers/fcc-maintain-customers-tcg-review.md).

### Main tab, as populated (slide 4)

Tab strip: **Main · Unit/People · Estimate · Tools/Rigging · Lift Info · Line Item · Tasks ·
Profit Forecast** — eight tabs, two more (`Tasks`, `Profit Forecast`) than the manuals list in §2.
Beyond the field list already in [fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §4:

- **Customer Information** panel: the customer's code (`MAS005` — the three-letter-plus-three-digit
  customer code convention), address, phone/fax, **Price List `PREFERRED 1`**, and a **red
  `Net 30` banner** — billing terms are surfaced on the quote, in red.
- **Job Site Information** panel: site address and phone, read-only.
- **Certified Payroll** is a **Yes/No dropdown on the quote's Main tab** (`No` here). TCG's note
  says certified pay *"is more granular than Customer (needs to be per Job or defaulted per Job
  Site)"*. The screenshot shows the field already exists per quote; **whether its value is
  inherited from the customer is not visible**, so the note and the screen do not strictly
  conflict — but the ask is about where the default comes from, not about adding a field.
- **`PO No` is a field on the quote's Main tab** (bottom right, blank here) — and TCG's note
  explains it as *"the Customer PO number"*. **This contradicts §5 above**, where the vendor
  manual lists *PO number* among the fields that exist only on the job. The screen TCG runs has
  it on the quote as well; the manual is from 2017–2018. Which one the migration extract
  carries is not settled by either.
- `Industry Code` (`Telecom`), `Job Type` (`Hourly`), `Status` (`Pending`), `Equipment Required`
  (*"275 Ton (op + 2) + …"*), `Description Of Work` (*"Cellsite work"*), **Salesperson, Taken By
  and Checked By all the same person** — the convention
  [tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md) §4 describes, seen live. Job Date and
  Ending Date are `00/00/0000` with times 08:00 AM / 04:30 PM — **the times default even when no
  date is set**.
- Every lookup (`Customer`, `Job Site`, `Report To`, `Quoted To`) has a **New** button beside it —
  TCG's *"New buttons"* note.

### Unit/People and Estimate for a 275-ton (slides 5, 6)

**Unit/People**, auto-populated from `Mobile Crane / 275 Ton All Terrain Crane`: Tractor *Tractor -
Semi* · Trailer *Operator Load* · Tractor · Trailer *Support Load 1* · Tractor · Trailer *Support
Load 2* · Tractor · Trailer *Support Load 3* — **four tractors and four trailers**, one more
support load than the real 275-ton job in
[fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §4 carried. No
employee rows in this template, unlike the 90-ton one.

**Estimate**, with **Price List `PREFERRED 1`** shown above the grid:

| Billing Code | Qty | UM | Rate | Amount | Comment |
| --- | ---: | --- | ---: | ---: | --- |
| 275 Ton Crane | 28.00 | Hours | $628.00 | $17,584.00 | |
| Operator Load | 16.00 | Hours | $110.00 | $1,760.00 | *5 hour minimum…* |
| Support Load | 28.00 | Hours | $160.00 | $4,480.00 | |
| Support Load | 28.00 | Hours | $160.00 | $4,480.00 | |
| Overtime | 8.00 | Hours | $260.00 | $2,080.00 | |
| Double Time | 4.00 | Hours | $520.00 | $2,080.00 | |
| Standard Lift Plan | 1.00 | Each | $350.00 | $350.00 | |
| Long Subsistence | 1.00 | Days | $800.00 | $800.00 | |
| Permit & Traffic Control Serv… | 1.00 | *(blank)* | $6,074.00 | $6,074.00 | |
| Travel Permit - 75 Ton and a… | 1.00 | Each | $165.00 | $165.00 | *Subject to change…* |
| Fuel & Insurance Surcharge | 1.00 | Each | **15.00%** | $5,066.85 | |

**Total Quote $44,919.85** — the same figure as `Quote Max` on the Main tab. Three things the
numbers show that no text states:

1. **$5,066.85 is 15% of $33,779, not of the $39,853 subtotal** — exactly the subtotal *minus
   the $6,074 Permit & Traffic Control line*. That is consistent with the per-code **`% Applied`**
   flag on the Billing Codes screen ([fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md)
   §5): a percentage code is applied only to lines whose billing code has it ticked. The
   screenshots do not state the rule; they only show a result consistent with it.
2. **The 275 Ton rate on the quote ($628) matches neither the code's default ($665) nor the
   `PREFERRED 1` list rate ($635)** shown on the Billing Codes → Price Lists tab in the codes
   deck. Either the rate was edited on the quote or the list changed between screenshots; the
   deck does not say.
3. The surcharge here is **15%**, a sixth sighting to add to the five that
   [fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §4 records (15%
   default, 8% BIGGE, 12% template, 10% invoices) — it agrees with the code's default rate, not
   with the estimate template's 12%.

TCG's slides 5–6 notes (*templates auto populate… rates based on the customer/price list*) are
what these two screens illustrate.

### Tools/Rigging, Lift Info, Line Item, Tasks (slides 7, 8)

- **Tools/Rigging** columns: **Category · Tool · Qty Out · Out Date · Qty In · In Date ·
  Size/Comments** — the manual's *Comments* column is labelled *Size/Comments* on screen. Empty.
- **Lift Info** has two groups. *Lift Info:* **Main Boom Length · Jib/Luffer Lgth · CWT · Radius ·
  Load Weight · Cap at Radius · Lift Depth · Jib Offset · Set up Distance · Height**. *Trucking
  Info:* **Length · Width · Height · Pieces · Total Weight**. On this quote only Main Boom Length
  (237), CWT (136,700), Radius (190) and Load Weight (3500) are filled, as bare numbers — the
  vendor's *"some organizations only enter a numerical value"* observation, confirmed. The ten
  labels match [tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md) §6 word for word, and
  are TCG's own labels — the guide captures above show FCC's demo tenant with different ones.
- **Line Item** columns: **Line # · Line Item · Exp/Rev/Both · Amnt Quoted · Est Expenses · Est
  Hours**. **Tasks** columns: **Complete · Title · Priority · Type · Due · Remind · Assignee ·
  Assigner**. Both empty — TCG: *"Not used"*.

### Profit Forecast (slide 9 — no TCG note)

An eighth tab the manuals do not mention. Per estimate line, two rows of columns: **Billing Code ·
Quantity · Rate · Estimated · Direct Cost · Indirect Cost · Total Cost** over **Unit Meas ·
Override Cost ☐ · Sub-Item ☐ · Gross Profit · Gross Profit % · Net Profit · Net Profit %**; a
**Totals** block with Estimated · Direct Cost · Gross Profit · Gross Profit % · Indirect Cost ·
Total Cost · Net Profit · Net Profit %. **Every cost is $0.00 and every margin 100.00%** —
Estimated $44,919.85 = Gross Profit = Net Profit. This is the visible consequence of TCG keeping
no Billing Costs (its *"We don't use/need these 'Billing Costs'"* in the codes deck) — the
feature [quote-profit-forecast.md](quote-profit-forecast.md) documents is switched on but has
nothing to compute with. The Fuel & Insurance Surcharge row alone shows *Override Cost* ticked
(greyed).

### Quote documents (slide 10)

**Maintain File Links – Job Quotes** (`Quote-OM-36519`) has a column the manual's list in §4 does
not: **File Name · Include On Job · Envelope Status · Created By · Modified By**, with **Comments
· Created Date · Modified Date** on a second row. Two files: `OM-36519.pdf` (the generated quote,
*Include On Job* unticked, Envelope Status blank — so this quote was **not** posted to DocuSign
at the time) and `1365 Hill St._Layout.pdf` with comment *"Job layout"* and **Include On Job
ticked**. TCG's note — *"Lift plans and other documents per Job Quote"* — is that second row;
**`Include On Job` is the flag that carries a quote attachment forward to the job** — named by
no text source, seen in the 2017 guide captures above, and here in use on TCG's system: the
layout drawing goes to the job, the quote PDF does not.

### Trucking Quotes (slide 11)

Confirms §3 field for field: `Loc To`, `Cust From`, `Loc From`, `Report To`, `Quoted To`, **Items
to Ship**, **Instructions**, and **no Billing Type** — but *with* `Certified Payroll`, `Use Quote
Detail Amounts` ☑, `PO No`, `Industry Code`, `Description Of Work`, `In House`, `Terms &
Conditions` (`Quote T&C`) and `Footer`, none of which §3 lists. Three address panels at the foot:
**Customer Information · Job Site From Information · Job Site To Information**. Tabs end in
**Loads** and there is no Tasks / Profit Forecast tab visible. The window opens on `AUTO`, Dept
`OPERAT…`, Job Type `Hourly`, Status `Pending`, 08:00 AM–04:30 PM — the same defaults as a job
quote. Nothing in the deck says whether TCG uses this window.

### Work Order Quotes (slides 12–16) — a window the vault had never seen

**WO Quote Lookup:** View By `All WO Quotes` · From/To · columns **WO Quote · Make · Issued ·
Labor Hrs · Labor Exp · Parts Exp · Lost Comments** over **Unit · Model · Work Desc** and
**Serial**. Empty for Nov–Dec 2025.

**Main tab** (tabs **Main · Activities · Parts · Labor**): Quote No `AUTO` · Company · Yard · Dept
`OPERATED & MAINTAINED` · **Job** (lookup) · Customer (New) · **Unit Owner** (`Company` — a
dropdown, so a work order can be quoted on a customer-owned unit) · **Unit Code** · **Make /
Model** · **Serial Number/VIN** · Job Site (New) · Quoted To (New) · WP / CP / E-Mail; right
column **Converted To WO** · **Billable Work Order Default** `%Above Cost` 0.00 · **Quoted Date**
`03/19/2026` · Quote Status `Pending` · Salesperson · Lost Code · Lost Comments · Footer · **Terms
& Conditions `TCG`** · Description Of Work · **Quote Total** $0.00. Note the T&C default here is a
record called `TCG`, not the `Quote T&C` a job quote gets.

**Activities:** buttons *Hide Action List · Add Action Item · Del Action Item*; grid **Activity ·
Comments · Work Finished · Standard Time**; a lower **Action List / Comments** pane. **Labor:**
**Est. Date · Unit Code · Activity · Hours · Billing Rate · Amount**. **Parts:** **Date · Part No
· Description · Activity · Qty · Price · Total**.

TCG wrote nothing on any of these five slides. The `Billable WO` field on the customer is one
TCG marked *"not needed"* in the customers deck, and the Quoted Date of 03/19/2026 is the day the
screenshots were taken; nothing says whether TCG has ever raised a work-order quote.

### Job Types and Quote Status codes (slides 17, 18)

Two reference lists from `Maintain →`, both with a `Status` column, both new to the vault as
complete lists.

**Job Types** — eleven codes, **only four Active**:

| Type | Description | Status |
| --- | --- | --- |
| `B` | Bare | Active |
| `C` | Contract | Inactive |
| `H` | Hourly | Active |
| `M` | Monthly | Inactive |
| `O` | OCCIP/ CCIP | Inactive |
| `P` | Prevailing Wage | Inactive |
| `S` | Storage | Active |
| `U` | PSA / PLA | Inactive |
| `V` | Vacation | Inactive |
| `W` | Weekly | Inactive |
| `Z` | Hourly w/ Mob | Active |

So the vendor's *"Hourly, Weekly, Monthly, or any other user-defined measure"* (§2) is, at TCG,
**Bare · Hourly · Storage · Hourly w/ Mob** — Weekly and Monthly exist but are switched off. The
two the estimate templates key on ([fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md))
are `H` and `Z`. `Bare` is also the Job Type that unlocks Quantity 2/3 in the Admin Guide
([../admin/fcc-nexgen-administration-and-security.md](../admin/fcc-nexgen-administration-and-security.md)).

**Quote Status codes** — five, all Active, with a **Require Lost Quote Code** checkbox per row:

| Code | Description | Require Lost Quote Code |
| --- | --- | :-: |
| `FW1` | Follow Up One | ☐ |
| `FW2` | Follow Up Two | ☐ |
| `LOST` | Lost | ☑ |
| `PEND` | Pending | ☐ |
| `WON` | Won | ☐ |

This bears directly on the *Pending Quotes* ask in
[fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §5: **FCC already has
two follow-up statuses (`FW1`, `FW2`) beside `PEND`**, and the KPI export's
`WON / PEND / LOST` ([sales-reporting-workbooks.md](sales-reporting-workbooks.md) §2) is the
subset actually used in the data. The lost-reason list those `LOST` quotes require is on the
codes deck — same page, §5. The deck does not say whether TCG uses `FW1`/`FW2`, and every quote
in the slide-2 lookup is `Pending`.

### Where the screenshots and the notes disagree

- **PO on the quote** — see *Main tab* above: the screen has `PO No` on both Job and Trucking
  quotes; §5's *"PO number… present [only] in the Schedule Jobs window"* is the 2017 manual and
  is no longer what the screen shows.
- **Certified Payroll** is already per quote; TCG's note asks for it to be per job / per job
  site — a default-source question, not a missing field.
- **Profit Forecast** is on the quote and running; TCG has not commented on it here, while
  rejecting the Billing Costs that would make it meaningful in the codes deck.

## Source

- `1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/QuotesGuide.v.1.2x.docx` —
  pandoc gfm, ~30 KB text, 331 non-blank lines. Version change control: 1.0 (2017-05-18) → 1.1
  (2017-05-25) → 1.2 draft (2017-06-01), David Thornton et al.
- `…/SalesGuide.v.2.2.docx` — pandoc gfm, ~30 KB. Change control adds 2.1 published 2018-01-11
  ("Added 'FAQ: How do I manually add a Line Item to a quote?', reorganized sections… updated
  images") and 2.2 published 2018-04-24 ("Removed watermark; corrected typos").
- `…/Sales Guide (Atom)v.1.0.docx` — pandoc gfm, ~33 KB. Atom is the mobile app; images captured
  on a Samsung Galaxy S8 and a Galaxy Tab A 10″.
- **Embedded screenshots, read 2026-09-04** (section *What the guides' screenshots show*): 72
  images in the Atom guide (2 JPEG-XR `.wdp` icon files unreadable), 30 in QuotesGuide v1.2, 8
  unique in SalesGuide v2.2 (its other 22 are byte-identical to v1.2's). Screens are FCC's own
  demo database, 2016–2018; demo contact phone numbers and e-mail addresses deliberately not
  copied.
- `1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_ENTER_QUOTES (reviewed by TCG).pptx` — 18
  slides; **the screenshots themselves carry no extractable text**, so only the speaker notes
  survive conversion. The **28 embedded screenshots were extracted and read on 2026-09-04** —
  see *What the deck's screenshots show*. Contact names, phones and e-mails on the screens were
  not copied.
- `1.0.1_BUSINESS-REQUIREMENTS/TCG_PRICE_LISTS/Price Lists Process in FCC-NexGen.docx` — steps 3
  and 4 only (quote creation and Conv Job); its price-list half is written up in
  [fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md). The document is
  almost entirely screenshots (30 images) with captions; **no field values were recoverable from
  the images**.

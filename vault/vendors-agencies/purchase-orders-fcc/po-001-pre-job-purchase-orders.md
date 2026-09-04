---
title: P&P PO-001 — Pre-job purchase orders in FCC
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/P&P – PO-001 – Pre-Job Purchase Orders (POs) in FCC.docx (text and its embedded FCC screenshots)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/vendors-agencies, module/dispatch, module/quotations, kind/sop, purchase-orders, permits, requirements]
entities: []
---

# P&P PO-001 — Pre-job purchase orders in FCC

**What this is.** The first of three draft Policy & Procedure documents written by Brian
Petros (Data Analyst) and sent to Melissa McNutt (President) and Wes Staley on
**1 December 2025** for review — see
[commissioning-email-thread.md](commissioning-email-thread.md). It is explicitly a *draft*
("I did the best I could, based on the discussions from our meetings so far"), with the
Effective Date left as `[fill in]`. It describes the **current FCC / NexGen system**, not the
new ERP. It matters because it is the only written statement in the vault of the
**quote-anchored pre-job PO** — the rule that lets a subcontract cost be raised and traced
before a Job Number exists.

| Field | Value |
| --- | --- |
| Policy ID | PO-001 |
| Owner | Operations (Sales & Dispatch) |
| Systems | FCC / NexGen |
| Effective Date | `[fill in]` — never set in the draft |

## Purpose and scope

Standardise how Dispatch and Sales create Purchase Orders in FCC for **subcontracted work**
— trucking, staking, roadway/traffic control, permits — **before a Job is created**, using
the **Quote Number** as the anchor so AP/AR can trace costs and later tie them to the Job.

Scope covers **all POs created before a Job Number exists in FCC**:

- **Dispatch** — trucking / staking vendors (e.g. Piazza); permit vendors *when Dispatch is
  the one ordering*.
- **Sales** — roadway / traffic control (e.g. Roadway, RCS); permits and other pre-job
  services ordered during quote/pre-planning.

## The five key rules

1. **"If you buy it, you PO it."**
   - Sales and Dispatch must **not** use Job Numbers as verbal POs.
   - No vendor order may be placed without a system-generated PO.
   - Sales go directly to the Purchase Order screen.
2. **Quote Number is mandatory if the Job does not exist.** When a Job is not yet
   created/converted, the Quote Number **must be entered in the PO comments/header** to track
   the expense.
3. **The vendor's Estimate/Quote # must be captured** in the **Vendor Order #** field, so AP
   can match the vendor's bill.
4. **Use an estimated cost when the final price is unknown.** For permits, traffic control,
   trucking etc., enter a *reasonable estimated cost* as a placeholder.
5. **Change orders / overruns are handled by PO update or a second PO.** If actual costs
   differ materially from the PO, either the vendor requests a **change order**, or
   Sales/Dispatch **adjust the PO amount**, or — **for rescheduled permits** — a **second PO**
   is issued "to keep history clean."

## Roles and responsibilities

**Sales (roadway / traffic control / permits)** — create POs directly in FCC for Roadway /
RCS / traffic-control services and for pre-job permits ordered during quoting/planning.
Always enter Vendor; Vendor Order # (the vendor's estimate); Quote Number in comments if the
Job does not exist yet; and a clear description (e.g. "Traffic Control – Roadway", "Permit for
OM-12345 quote").

**Dispatch (trucking / staking / certain permits)** — create POs in FCC for trucking/staking
vendors (e.g. Piazza) and for permits ordered by Dispatch ("per Dispatch meeting"). Same data
standards, e.g. description "Trucking – Piazza".

**AP / Back office** — use these POs later to match vendor invoices and to link POs to Jobs
once the Job is created.

## The pre-job PO creation procedure

**Step 1 — Navigate.** FCC menu **Enter → Purchase Orders**, then **Add / New**.

**Step 2 — Header fields.**

| Field | What goes in it |
| --- | --- |
| Vendor | Piazza or similar for trucking/staking; Roadway, RCS, permit agency etc. for roadway/traffic control/permits |
| Vendor Order # | The vendor's Estimate/Quote # (example given: `EST-10657`) |
| Comments / Header | **If no Job exists**, the FCC Quote Number — example: `Quote OM-12345 – Pre-job traffic control` |

The draft calls the Quote-Number-in-comments approach "the agreed method to handle expenses
for jobs not yet scheduled/converted."

> **Caveat on this mechanism, from a different source in the same drop.** In the
> commissioning email thread (Melissa McNutt, 3 December 2025) Melissa writes of the in-house
> comments tab: *"This part we need to work through to see if we would use this step. The
> issue is the in house comments don't come up on reports so it wouldn't help ap find it. I
> think the quote or job # needs to be referened in the po screen, we can confrim with
> Courtney."* That is a direct challenge to the comments-field mechanism PO-001 depends on,
> raised two days after the draft was sent. Nothing in the drop records the outcome. See
> [commissioning-email-thread.md](commissioning-email-thread.md).

**Step 3 — Detail lines.**

- **Description** — Trucking (Dispatch): "Trucking – Piazza", "Trucking/Staking – Piazza".
  Roadway (Sales): "Traffic Control – Roadway", "Lane Closure – RCS". Permits
  (Sales/Dispatch): "Permit – City of LA", "Permit – Quality Permits".
- **Estimated cost** — a realistic estimate based on the vendor quote or experience.
- **Job Number field** — if a Job exists, enter the Job Number on the detail line to link the
  cost directly to the Job. If no Job exists, **leave Job Number blank** and rely on the
  Quote Number in the header for later linking by AP.

The draft states in so many words that Step 3 reconciles two previously conflicting
instructions: "Consultant's instructions to enter Job # in detail when job exists" versus
"your new process where these trucking/roadway POs are often pre-Job and must use Quote #."

**Step 4 — Save and send.** Save the PO, then print or email it from FCC to the vendor, to
"look professional" and to "provide a clear paper trail for disputes."

## Controls and compliance

- **"No PO, No Order"** — vendors should not be engaged without a PO number.
- **Spot checks** — periodic review of recent vendor invoices to confirm each has a
  corresponding PO and Quote Number in FCC.
- **Training** — all Sales and Dispatch staff must be trained on this workflow. The document
  notes the **"Edison" Sales mapping process is retained as a best practice but is outside
  the scope of this policy**; it does not say what that process is.

## What this document does not say

- It does not set an Effective Date, an approver, or a review cadence.
- It does not say what dollar threshold makes a cost difference "material" for rule 5, nor
  who decides between adjusting the PO and issuing a second one (only that rescheduled
  permits get a second PO).
- It does not say whether a PO Requisition / approval-limit step — which the FCC Purchasing
  Guide describes, see [../fcc-nexgen-purchasing-guide.md](../fcc-nexgen-purchasing-guide.md)
  — applies to these Sales/Dispatch POs. Step 1 goes straight to **Enter → Purchase Orders**,
  which shows direct PO entry; it does not say whether the requisition route is deliberately
  bypassed or simply out of scope.

## What the SOP's screenshots show — read 2026-09-04

Fourteen of the fifteen embedded screenshots were extracted and read (image 11, the
*Schedule → Job* menu, was not). The PO *Main* and *Detail* field lists are already
transcribed from the purchasing deck in
[fcc-po-entry-walkthrough.md](fcc-po-entry-walkthrough.md); this section records only what
these particular screens add. All of them are dated **21 Nov – 4 Dec 2025** — the blank PO
screen's `Order Date` defaults to `12/04/2025`, the day after Melissa's email in the
commissioning thread.

**The Quotes menu has a Trucking entry.** `Enter → Quotes` opens `Job Quotes`, **`Trucking
Quotes`**, `Work Order Quotes`. FCC has a separate trucking-quote object; the P&P does not
mention it and does not say whether a Piazza order should originate there.

**Job Quotes screen.** Tabs `Main · Unit/People · Estimate · Tools/Rigging · Lift Info · Line
Item · Tasks`. Main-tab fields (blank form): `Quote No` (`AUTO`) · `Company` · `Dept` · `Yard` ·
`Customer` / `Job Site` / `Report To` / `Quoted To` (each with a **New** button and lookup, WP/CP
phone and E-Mail) · `Converted To Job` · `Job Date`/`Job Time` · `Ending Date`/`Ending Time` ·
`Final Date` · `Submitted Date` · `Award Date` · `Status` (`Pending`) · `Lost Code` · `Lost
Comments` · `Certified Payroll` (`No`) · `Use Quote Detail Amounts ☑` · `Billing Type` (`Rental`)
· `Footer` (`Standard Quote T…`) · `Terms & Conditions` (`Quote T&C`) | `Quote Min` / `Quote Max`
· `Salesperson` · `Taken By` · `Checked By` · `Job Type` (`Hourly`) · `Equipment Required` ·
`Comments` · `Description Of Work` · `In House` · `PO No` · `Industry Code` | *Customer
Information* and *Job Site Information* address blocks · Created/Modified By/Date. The **Quote
Lookup** grid: `View By` (`All Quotes`), `Use` (`Job Date`), `From`/`To`; columns `Quote No ·
Customer · Status · Quote Max · Quote Lost · Start Date · End Date · Job Site`; statuses seen
`Won` and `Pending`. Field-level detail on quoting belongs to
[../../quotations/fcc-nexgen-quote-entry.md](../../quotations/fcc-nexgen-quote-entry.md).

**The worked quote, OM-33923.** `Status Won`, `Award Date 11/18/2025`, **`Converted To Job
OM56195`**, `Certified Payroll Yes`, `Billing Type Rental`, `Job Type Hourly`, `Equipment
Required "40T + RCS"`, `Industry Code Mechanical`, `Price List PREFERRED 1`, a red **`Net 30`**
terms banner over the customer block; `Salesperson` and `Taken By` are the same salesperson and
**`Checked By` is `Customer`**.

**The worked PO, OM-1711.** Main tab: `Vendor RCS Safety LLC` — vendor code **`ROA001`**, i.e.
the vendor the P&P calls "Roadway" is set up in FCC as RCS Safety LLC under a `ROA` code ·
`Vendor Order No EST-01257` · `PO Type General` · `Order Date 11/21/2025` · `Terms Net 30` ·
`Purch Disc % 0.00` · **`Comments` = `OM-33923`** — the quote number alone, not the *"Quote
OM-12345 – Pre-job traffic control"* form the P&P prescribes · `Parts $5,191.58`, `Contract
Labor $0.00`. Detail tab: one line, `Description "Road closure for Seacliff mechanical"`, `Qty
Ord 1.00`, `Unit Meas Each`, `Cost 5,191.5800`, **`Job Number OM56195`**, `Parts/Labor Parts`,
`Tax ☑` yet `Tax $0.00`, `GL Account`, `Comments On PO` and `In House Comments` all blank.
Created 11/21/2025 under the salesperson's login. The Detail toolbar reads `New PO · Add Part ·
Ins Part · Del PO · Del Part · First · Previous · Next · Last · Copy PO · Receiver · Refresh ·
Save Layout · Save · Print · Close`; on the Main tab `Add Part / Ins Part / Del Part` show as
`N/A`.

> **The worked example is not a pre-job PO.** Job OM56195 was created on 11/18/2025 (the Job
> screen's *Created* stamp, matching the quote's Award Date); the PO was created on 11/21/2025
> and already carries the Job Number on its detail line. So every screenshot shows a PO raised
> **after** conversion with both anchors filled. The pre-job case this policy exists for — Job
> Number blank, Comments carrying the quote — is described in the text only; no screenshot
> shows it.

**Schedule > Job.** Left navigation `Main · Parameters · Resources · Estimates · Storage ·
In-House Comments · Job-Related Certificates · E-Ticket Status Report · Attachments`. **Job
Search**: `View By All Jobs`, `From`/`To`, `Include Completed Jobs ☑`, `Include Canceled Jobs ☑`;
grid `Job No · Customer · Start Date · End Date · Job Site · City · PO No`. Main tab: `Job
Number · Company · Yard · Department · Salesperson · Checked By · Taken By · PO Number · Status`
(`Tentative`, green) | `Customer` (with the `Net 30` banner) · `Job Site` · `Report To` · `Ordered
By` · `Description Of Work` · `Comments` · `Equipment Required` | `Job Date` / `To` with a month
calendar, `Work Weekends ☑`, `Date Flexible`, `Time Flexible`, `Job End Date Unknown`. **The
Job's `PO Number` field (and the Job Search `PO No` column) is the customer's PO number, not an
FCC purchase order** — a different thing from the `PO(s)` link below. The *Related Information*
panel: `Quote OM-33923 · PO(s) 1 · Tool(s) none · Lift Info present · Price List PREFERRED 1 |
Storage Item(s) none · Latest Invoice not invoiced · Invoice History none · Daily none`. The
`PO(s)` link opens a *Purchase Orders* grid `PO Number · Vendor · Order Date · Total` whose `+`
expands to `Part Number · Description · Qty Ordered · UM · Cost`; the expanded description
there reads *"Road closure for Seacliff mechanical Project - Vibrant Minds"* — longer than on
the PO Detail line, so the description field holds more text than the grid shows.

## Source

`1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/P&P – PO-001 – Pre-Job Purchase Orders (POs) in FCC.docx`
— .docx converted to GFM by pandoc, ~10 KB of text. The document carries a screenshot
walkthrough after the policy body; that walkthrough is captured separately in
[fcc-po-entry-walkthrough.md](fcc-po-entry-walkthrough.md) because a second file in the same
folder holds the identical walkthrough. 14 of the 15 embedded screenshots were read directly on
2026-09-04 — see *What the SOP's screenshots show* above.

The caveat block quotes
`1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/Re_ FCC Needs - (P&Ps for POs).msg`.

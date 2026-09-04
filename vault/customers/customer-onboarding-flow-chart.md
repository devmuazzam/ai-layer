---
title: Customer onboarding and quote-intake flow chart (Value Engine sample)
source: shared-folder/Project-Repository-2026-09-04/TCG_Value_Engine_SAMPLES-ONLY/2026-06-23 samples/Onboarding customer.xlsx
migrated: 2026-09-04
updated: 2026-06-23
status: unverified
conflicts_with: []
jira: []
tags: [module/customers, module/quotations, module/accounting, kind/source, requirements, invoicing]
entities: []
---

# Customer onboarding and quote-intake flow chart (Value Engine sample)

**What this is.** A two-sheet Excel flow chart of how a lead becomes a quote, a quote becomes a
job, and a new customer gets a credit decision. Every cell in the workbook is empty — **the entire
content is drawing shapes**, which the drop's standard `.xlsx` → text conversion (a per-sheet cell
dump) does not see, so the converted `.txt` for this file looks blank. The shape text below was
recovered from the workbook's `xl/drawings/` parts and is complete; what could **not** be recovered
is the **connector arrows**, so the boxes are given here in their on-canvas position, not in a
proven sequence.

**Read the original for the arrows.** The wiring between these boxes is the whole point of a flow
chart and it is not reproduced here. Do not infer the order of steps from the order of the lists
below beyond the left-to-right / top-to-bottom placement that is stated.

**Provenance caveat.** The file sits under `TCG_Value_Engine_SAMPLES-ONLY/2026-06-23 samples/` —
a folder whose own name marks its contents as samples. Nothing says whether this chart describes
TCG's current process, a proposed one, or an illustration. It is undated inside; the folder dates
it 2026-06-23.

## Sheet 1 — lead to job

Boxes as placed, reading down the canvas. The column number is the box's horizontal position, so
boxes in the same row with rising columns run left to right.

**Top band (row 4–5)** — the main quote path:

`sales coordinator` → `walk job and look at job for quote` → `Quote put together and enter into
FCC` → `send quote to customer for …` → `customer reach out when to schedule may be a part of
another quote/bid` → `hold onto until customer asks for a date` → `sent to dispatch for
scheduling` → `convert quote to job #`

**Second band (rows 12–13)** — entry and routing:

`Lead — Email / Call` (leftmost box on the canvas) → `sales coordinator or dispatch if they need
help` → `review customer to see if they have salesperson already`, with `didnt get job pricing or
other possible options` sitting off to the right.

**Middle (rows 22–48)** — the branch that runs when the customer is new or unassigned:

`send to group chats for who can do it or has time to do it` · `like message by sales
coordinator.` · `send additional information they have to sales coordinator` ·
`A/R reach customer for new customer packet` · `add customer into fcc` ·
`sales person follows up if no customer packet recieved` · `work as a team to follow up to get
packet back`

and, running right along row 34–35, the packet-received chain:

`sales person see/contact that received customer packet` → `note in the job what is received.` →
`confirm customer packet was received with customer and sales person` → `run credit card/check
after first job is done for payment` → `check active state license` → `give terms`, with
`stay cod no terms` below it at row 47.

**Bottom band (rows 58–72)** — a second full pass of the same path, this time with A/R in it:

`create quote in fcc` → `send quote cc A/R` → `Email AR to reach out for customer to get packet` →
`check if received new customer packet back yet` → `hold onto until customer asks for a date` →
`sent to dispatch for scheduling` → `convert quote to job #`, with `didnt get job pricing or other
possible options` beneath.

The workbook's only cell content is on this sheet: two isolated cells reading **`No`** and
**`Yes`**, at rows well above the shapes. They are presumably decision-branch labels; the file
does not say which decision.

## Sheet 2 ("Onboarding") — the packet and credit decision

A tighter chart of the same subject. Boxes as placed, left to right along the main row:

`Email A/R to reach out for customer to get packet` → `A/R reach customer for new customer packet
(playbook)` → `Customer Respond with packet` → `sales person see/contact that received customer
packet` → `note in the job what is received.` → `more than one day lead time` → `do job` →
`collect deposit` → `do job` → `charge for remaining amount` → `paid in 24 hours` →
`look to give terms. check credit application (playbook)` → `check active state license` →
`give terms`

Below the main row: `Do not receive customer packet back` (under *Customer Respond with packet*) ·
`No credit to be extended` (under *paid in 24 hours*) · `stay cod no terms` (under *check active
state license*) · a second `do job`.

Down the left edge, three boxes label the contact channel: **`text`**, **`Email (usually)`**,
**`Call`** — matching the `Lead — Email / Call` box on sheet 1.

Six cells on this sheet hold branch labels — three `Yes` and three `No` — but they sit at
spreadsheet rows above the shapes and cannot be attached to a specific decision box from the file
alone.

## What the chart establishes

Stated plainly by the box text, without inference:

- **Four roles** appear: **sales coordinator**, **dispatch**, **sales person**, and **A/R**. The
  sales coordinator receives the lead; dispatch helps when the coordinator needs it and owns
  scheduling; A/R chases the new-customer packet; the sales person confirms it came back.
- **A quote is entered into FCC**, and later **converted to a job #** — the same two-step the ERP
  models as `Quotation` → `Job`.
- **A customer is added into FCC** as a step in the flow, not as a precondition, and the flow can
  reach *"send quote to customer"* before the customer record exists.
- **The new customer packet gates the credit decision.** The chain is: packet received → check
  active state licence → either **give terms** or **stay COD, no terms**. Where the packet does not
  come back, the outcome box is **"No credit to be extended"**. This is the operational counterpart
  of the paper packet in [new-customer-packet.md](new-customer-packet.md), whose welcome letter
  states the same rule from the customer's side ("all accounts are COD until a credit application
  has been completed, reviewed, and approved") and the same 24-hour payment window
  (*"paid in 24 hours"* here).
- **Deposit before the job, balance after** — `collect deposit` → `do job` → `charge for remaining
  amount`, matching the packet's 50%-deposit-then-COD terms.
- **"more than one day lead time"** appears as a condition on the path, and **"(playbook)"** is
  appended to two boxes — A/R's outreach and the credit-application check — implying a written
  procedure exists for each. Neither playbook is in this drop.
- **`hold onto until customer asks for a date`** appears twice: a quote can sit in a held state
  before it reaches dispatch. The ERP's `QuotationStatus` enum is worth checking against this;
  the chart does not name a status.

## Source

`TCG_Value_Engine_SAMPLES-ONLY/2026-06-23 samples/Onboarding customer.xlsx` — 2 sheets, ~174 KB.
**The standard conversion produced an effectively empty text file**: all content is in
`xl/drawings/drawing1.xml` (34 shapes) and `xl/drawings/drawing2.xml` (20 shapes), read directly
for this page. Shape text is transcribed verbatim including its typos (*"didnt"*, *"recieved"*).
**Connector arrows and the Yes/No branch wiring were not recoverable** — open the workbook for
those.

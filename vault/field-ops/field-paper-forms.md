---
title: The paper the field app replaces — ticket, daily log, and crew intake forms
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/ — TCG Paper Ticket 09-10-2025_1.pdf, Updated LADWP Paper Ticket 2025[96].pdf, NEW DAILY LOG. update 5-14-20.xlsx, HR_PAYROLL - Daily Log and Timesheet.pdf, Synthetic Sling.pdf, TCG Fill In Equipment Qualify List 03-20-2026_Final.pdf, TCG Fill In Required Information 03-20-2026_Final.pdf, from Melissa 2026-04-02/LADWP MYOM-92728.pdf
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/payroll, module/customers, module/assets, kind/source, ticket-workflow, time-tracking, signatures, wtl, certifications, tools-rigging, inspections, pricing, compliance]
entities: []
---

# The paper the field app replaces

**What this is.** Eight blank (or scanned) forms from TCG's own forms folder — the paper artefacts
the Field Operations app is meant to make unnecessary. They fall into three groups: the **field
ticket** (TCG's and its LADWP variant), the **daily log / timesheet** the crew fills in, and the
**crew intake forms** a new field employee completes, plus one **rigging inspection sheet**.

**Why it matters.** Both FRDs open on the same premise — *"fragmented operational processes
currently distributed across Atoms Mobile, **manual paperwork**, and supporting applications"*. This
is that paperwork, in TCG's own words, with its own field names. Where a paper field has no
counterpart in the FRD or in the e-ticket, that is visible here and nowhere else.

> **These are forms, not requirements.** A blank form shows what TCG collects today. It does not say
> the ERP must collect it, and none of these has been adjudicated. Every form here is **blank**
> except the LADWP job scan and the daily-log scan, which were read from the image on 2026-09-04.

---

## 1. The TCG paper ticket

`TCG Paper Ticket 09-10-2025_1.pdf` — a two-sided pre-printed pad, serial `A 18161`, Contractors
Lic. #967520, 10850 Portal Dr., Los Alamitos CA.

**Front — header fields.** Lessee/Customer Name · Phone · Service Date · Job Address / City / State /
Zip · **Crane Size / Unit #** · **Boom Length** · **Load Weight (lbs)** · On-Site Contact · **Job #**
· **P.O. #** · **Operator Name** · **Oiler Name**.

**Two signature panels**, exactly as on the e-ticket:

- `AUTHORIZATION TO START WORK` — Authorized Signer Printed Name + signature, against the TCG
  counter-signature block (pre-printed `Wes Staley`), under a capitalised T&C acknowledgement that
  singles out indemnity, jury-trial waiver and warranty exclusion.
- `HAVE SIGNED AT END OF DAY` — *"The above work verified to be correct. All times verified to be
  correct. Lessee confirms that there have been no accidents involving any of the leased
  equipment."*

**`CRANE CREW TIMES BREAKDOWN`** — a seven-row grid, each row `FROM` / `TO` (with A.M./P.M. boxes) /
`OUT` / `REASON` / `HOURS`:

```
Travel/Portal · Boom Assembly · Permit Stand By · Work
Boom Disassembly · Permit Stand By · Travel Portal
```

plus `Remarks`, a **`Lunch: ☐ Yes ☐ No`** checkbox and **`Total Net Hours`**.

> This is the paper ancestor of the e-ticket's `Time Stamps` checklist, and the two do not match.
> The paper form has **Permit Stand By twice** and an `OUT` and `REASON` column per row; the
> e-ticket's Time Stamps has neither, and adds Subsistence and four lunch slots. Neither FRD lists
> "Permit Stand By" as a workflow position. The demo's `computeHours` models Travel, Boom and Lunch
> only.

**`SAFETY MEETING SIGNATURES`** — six ruled lines, unlabelled. This is the paper JSA sign-off.

**`ADDITIONAL SUPPORT (RIGGER, SUPPORT LOAD, TRUCKING)`** — five identical blocks of
`EMPLOYEE / Start Time / End Time / Lunch ☐Yes ☐No / Comments`. So the paper ticket supports **one
crane crew plus up to five additional people**, each with only start, end and a lunch boolean.

### The Terms and Conditions on the reverse

Fifteen numbered clauses. Most are legal (indemnification, insurance, operation of equipment, ground
and power-line conditions, storage, excuse of performance, access, service charges, legal fees,
damage waiver, permit and fee acknowledgement, authorized signature). **Three carry operational
rules the ERP has to honour, and they are quoted here because they are the customer-facing source
of rules the vault otherwise only sees from the payroll side:**

- **§13 — billing granularity and portal-to-portal.** *"All charges are portal to portal with times
  billed in **30 minute increments** per agreement with I.U.O.E Local 12... All charges begin and end
  with **Pre & Post trip inspections at equipment(s) dispatched location(s)**. Surcharge: **ALL
  CHARGES ARE SUBJECT TO A 12% SURCHARGE** THAT WILL BE APPLIED ON FINAL INVOICES."*
- **§14 — show-up time and cancellations.** *"When crew is requested to show up to The Crane Guys
  location and no work is provided, **(2) hours** shall be billed... If a cancellation is made within
  (2) hours of leave time for crew **(2) hours** shall be billed... If a cancellation is made after
  crew has left The Crane Guys location a **(4) hour minimum or true time** shall be billed."*
- **§15 — meal periods.** *"No employee shall be required to work more than 5 hours consecutively
  without one-half (1/2) hour meal period. If meal periods are worked then customer will be charged
  one-half (1/2) hour of **Crew time Double-time** & one-half (1/2) hour **for all cranes and
  equipment**."*

**§15 is word-for-word the text printed on the e-ticket's `Work Through Lunch Authorization`
checklist** ([e-ticket-worked-example-44944.md](e-ticket-worked-example-44944.md)). The WTL charge
is a contract term the customer has already accepted at start of work, and the ad-hoc checklist
re-presents it at the moment the meal is missed. The rounding rule in §13 — 30-minute increments,
portal to portal — is the same 30 minutes the demo build rounds to.

## 2. The LADWP paper ticket variant

`Updated LADWP Paper Ticket 2025[96].pdf` — **the same form, same serial block, same time grid,
same support blocks**, with the Lessee/Customer Name **pre-printed as `Los Angeles Department of
Water and Power`** and the two attestations rewritten:

| Panel | TCG standard | LADWP variant |
| --- | --- | --- |
| Start | generic capitalised T&C acknowledgement | *"the signer authorizes the start of work under this agreement and acknowledges compliance with **all LADWP requirements, including safety standards, labor laws, and site access provisions**."* |
| End of day | *"The above work verified to be correct. All times verified to be correct. Lessee confirms that there have been no accidents..."* | *"the signer certifies that the above services and times are correct to the best of their knowledge. The signer acknowledges that **all equipment was operated in accordance with applicable safety standards** and that no accidents, injuries, or damages were reported..."* |

**The reverse-side Terms and Conditions are not present on the LADWP variant's converted text.**

> **This is the first hard evidence in the vault of a per-customer ticket variant.** One named
> customer gets a ticket with different attestation wording. Neither FRD mentions customer-specific
> ticket templates or attestation text; `FR-FOP-018 Customer Signatures` (FOP-002) and
> `FR-FOP-016/017` (FOP-001) describe one signature flow. Whether the ERP must support per-customer
> attestation text is unanswered.

### A completed LADWP packet — `from Melissa 2026-04-02/LADWP MYOM-92728.pdf`

A three-page scan, **read from the image on 2026-09-04**. It is one of the six customer packets
Melissa sent as samples (see the review-log entry #3 in [../erp-review-log.md](../erp-review-log.md))
and the only one whose ticket is the LADWP variant. What the three pages are:

1. **The invoice, `MYOM-92728`**, dated 03/10/2026, due 04/09/2026, total **$2,855.76**. Bill To
   *Los Angeles Department of Water and Power, 111 North Hope St., Contract 410B-5*; Ship To
   *Order #9354607, Request #460760123, 3900 S Figueroa St*; P.O. Number `R32352`. The line
   grid is the QuickBooks layout (`DATE · ACTIVITY · DESCRIPTION · QTY · RATE · AMOUNT`) but
   **every activity is an LADWP contract item number**: `56 LADWP Item 56 – 90 Ton Crane` (4 ×
   $80.00), `57 … Portal In-Out` (3.5 × $80.00), `58 … 90 Ton Operator` (4 × $125.00), `72 …
   Support Load` (6.5 × $225.00), `73 … Support Load Overtime` (1 × $260.00), and `79 LADWP Item
   79 Fuel` (**7.50 × $4.434**). The fuel line's description is the **False Claims Act
   certification** (*"Contractor is advised that submission of a false claim for payment to the
   LADWP may subject the Contractor to liability under the False Claims Act (California Government
   Code Section 12650)…"*), printed on the invoice face. Signed *Tia Brenneise*. Fully written up on
   the accounting side in
   [../accounting/invoice-packets-2026-04-worked-examples.md](../accounting/invoice-packets-2026-04-worked-examples.md).
2. **The completed LADWP paper ticket, serial `TCG 298`**, service date 3/10/26. Lessee pre-printed
   *Los Angeles Department of Water and Power*; job address 3900 S Figueroa St, LA 90037; **crane
   size / unit # `9001`**; job # `OM57946`; on-site contact and operator/oiler names hand-written
   (names not copied here). *Authorization to Start Work* signed for TCG by **Wes Staley** (name
   printed under the signature). The **Crane Crew Times Breakdown** grid is filled in:
   Travel/Portal 5:00–7:00 AM (2 hr) · Boom Assembly 8:30–9:00 (30 min) · Permit Stand By
   7:00–8:30 (1.5 hr, reason *"wait for LADWP"*) · Work 9:00 AM–12:00 PM (3 hr) · Boom Disassembly
   12:00–12:30 (30 min) · Travel Portal 12:30–2:00 PM (1.5 hr, reason *"TBD"*). Remarks: *"crane
   broke down 10:45am–11:45am"*; Lunch ☑ Yes; **Total Net Hours 9**. Description of job: *"swap
   out 2× 19ft scissor lifts, lunch 10:30–11:30am"*. Safety-meeting signatures by both crew.
   *Additional Support* rows empty. End-of-day signer block signed.
3. **A printout of the U.S. EIA "Weekly Retail Gasoline and Diesel Prices" page for California**,
   captured 3/26/26, showing the six weekly prices from 02/16/26 to 03/23/26 — attached as the
   backing for the fuel line.

**What this packet shows that no other source does:**

- **A customer that is billed by its own contract item numbers, not by TCG billing codes.** The
  ticket's crew-times grid (Travel/Portal · Boom Assembly · Permit Stand By · Work · Boom
  Disassembly · Travel Portal) maps onto LADWP items 56/57/58/72/73, and the mapping is done by
  hand in accounting.
- **Fuel is a pass-through line priced from a public index** — $4.434/gal is not on the EIA sheet
  as printed (the 03/09/26 regular-gasoline reformulated figure is $5.093; the 02/23/26 figure
  is $4.441), so which cell, or what adjustment, produced $4.434 is **not determinable from the
  packet**. The EIA page is attached as evidence regardless.
- **The time grid on the ticket does not add up to the invoiced quantities by itself.** Crew time
  on the ticket totals 9 net hours; the invoice bills 4 crane hours, 3.5 portal hours and 4
  operator hours plus 6.5 + 1 support-load hours. The reconciliation between the ticket's grid and
  the item quantities is done somewhere the packet does not show.
- **The stand-by reason ("wait for LADWP") and the breakdown remark ("crane broke down
  10:45–11:45")** are both on the ticket, and neither appears on the invoice — the customer paid
  for the stand-by hour (item 57) but the breakdown hour was absorbed inside the 3-hour work line.
  Whether that is policy or a one-off is not stated.

## 3. The daily log and timesheet

`NEW DAILY LOG. update 5-14-20.xlsx` — one sheet, `A1:G62`, a fill-in form, last updated
**2020-05-14**. `HR_PAYROLL - Daily Log and Timesheet.pdf` in the same folder is the **printed
form as a scan** — read from the image on 2026-09-04: it is the same form, field for field, on
TCG letterhead (*"Your Crane Company" · Crane · Rigging · Trucking · 877-357-2729*), with the
certification paragraph and the boxed **"BELOW SECTION FOR OFFICE USE ONLY"** GPS block exactly
as listed below. Nothing on the printed version differs from the XLSX.

Structure, in order:

```
Date · Employee Full Name
Leave Time · Pre Trip End · Crane/Truck #
Job #1 … Job #5, each:
    Invoice # · Customer Name · Boom Length
    Depart for job site · Arrive at job site
    Depart job site · Arrive at next site · Billed Hours
Return time to yard
Meal Break #1 Start / End · Meal Break #2 Start / End
Worked through lunch (customer approved & initialed)
Operators Hours · Customer Billed Hours
Crane Inspection completed · Truck Inspection Completed · JSA Completed
Comments · Employee Signature
[certification paragraph]
GPS Tracker Depart for job site time · GPS Tracker Arrive at yard time at the end of the day
Operators Actual Hours · Customer Billed Hours
```

Five things here are not in either FRD:

1. **Up to five jobs on one day**, each with its own invoice number, customer, boom length and
   *"Arrive at next site"* — the log is built for **multi-stop days**, not one ticket per day.
2. **`Billed Hours` is captured per job**, and **`Operators Hours` vs `Customer Billed Hours` appear
   twice** — once mid-form and again at the bottom next to *"Operators **Actual** Hours"*. Three
   different hour figures on one sheet.
3. **`Pre Trip End` is a distinct timestamp** — the pre-trip's end is a clock event, separate from
   Leave Time.
4. **Two meal breaks**, with a separate `Worked through lunch (customer approved & initialed)` line.
   The e-ticket has four lunch slots; this form has two.
5. **`GPS Tracker Depart` and `GPS Tracker Arrive` are written on the form by hand, next to the
   employee's own times.** The paper process already reconciles device GPS against self-reported
   time — which is the same problem the e-ticket's *"as recorded for the customer"* vs
   *"as recorded by the workflow"* split solves in software, and which the FRD lists as the open
   question *"Samsara reconciliation expectations"*.

**The certification paragraph** is longer than the one on the e-ticket. Alongside the 30-minute meal
by end of the fifth hour and one 10-minute paid rest per four hours, it adds two clauses the
e-ticket version omits: *"**No supervisor or manager has instructed or coerced me to input my
worktime in a false or misleading manner.** I further certify that no supervisor or manager has
interfered with or dissuaded me from taking work-free uninterrupted meal and rest breaks."*

## 4. Crew intake forms

Two matching fill-in forms, both dated **2026-03-20** and both marked `_Final`.

**`TCG Fill In Required Information`** — Full Name · Date of Birth · Cell Phone · Email, then a
`List of Certifications` block of six numbered credentials:

```
Drivers License #  ·  NCCCO Card #  ·  OSHA 10 Card #
OSHA 30 Card #  ·  First Aid/CPR Card #  ·  DOT Physical Card Date
```

and two hand-offs at the foot: *"Please fill out attached **W4 for Payroll**"* and *"Please fill out
attached **Field Availability Options Form for Dispatch**"*. (That availability form is not in this
drop.)

**This is the source list for `FR-FOP-028 Certifications` / `FR-FOP-032/033`** — six credential
types, five of them a card number and one a date. It is also the only document in the vault that
states what a new field employee hands over on day one.

**`TCG Fill In Equipment Qualify List`** — Full Name · Certification Issued By · Certification
Number, then *"Check which machine(s) you know how to operate/oil"* over **fifteen named makes and
models**:

```
Dynalift A118 · Manitex 22101S · Manitex 40124SHL
Link-Belt HTT8660 · HTC3140 · HTC3140 LB · RTC 8090 · RT 8090 · HTC8690 · HTC8660 · HTC86100 · ATC3200
Liebherr LTM 1220 5.2 · LTM 1040
Garland-Goliath
```

> **An employee is qualified per crane make and model, not per crane class**, and the qualification
> is self-declared on this form against one issuing body and certificate number. Neither FRD nor the
> Atom user stories model a machine-level qualification; `FR-FOP-028` is a list of the employee's
> certifications. Whether dispatch may only assign an operator to a unit whose model is ticked here
> is **not stated by any source in this drop** — it is a rule the form implies and nothing states.
> The fifteen models are also a partial cross-check against the fleet in
> [assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md).

## 5. Synthetic sling / wire rope sling inspection form

`Synthetic Sling.pdf`. The PDF has a text layer, but it is **rendered from a rotated table through a
broken font map**: every line comes out mirrored and partially mis-mapped. The structure below was
recovered by reversing and decoding it and should be treated as **approximate on wording, reliable
on structure**.

A per-sling inspection log with a header (`SYNTHETIC SLING / WIRE ROPE SLING — INSPECTION FORM`,
`JOB #`, `JOB NAME`, `DATE`, `INSPECTION BY`) and a row per sling:

`SLING # | SLING SIZE | LENGTH | CONDITION CODE | COMMENTS | ACTION`

with a legend of condition codes, each rated `ACCEPTABLE` or `EXCESSIVE`:

| Code | Condition |
| --- | --- |
| `W` | Wear |
| `BS` | Broken stitches |
| `HD` | Heat damage |
| `CD` | Chemical damage |
| `HT` | Holes or tears |
| `CS` | Cuts or snags |
| `F` | Condition of end fitting |

and the standing instruction — *"Take any piece of rigging with excessive wear or damage out of
service immediately"*, with *"use additional forms if needed"*.

This is the **rigging inspection** the e-ticket's Time Stamps attestation refers to (*"I performed
and completed my Pre Trip Inspection, **Rigging Inspection** and Post Trip Inspection"*). It is a
per-item register with its own identifiers, not a checklist row — nothing in either FRD models
rigging as inspectable inventory. See [assets/tool-and-rigging.md](../assets/tool-and-rigging.md).

## 6. Open points these forms raise

Recorded for a human to route; **not** written to any `gaps.md`.

1. Does the ERP need **per-customer ticket variants** (LADWP wording), and if so is the variation in
   attestation text only, or in fields too?
2. The paper ticket has **Permit Stand By** as a billable time row, twice, and the e-ticket does
   not. Which is current?
3. The daily log supports **five jobs a day**; the e-ticket model is one ticket per job. How does a
   multi-stop day work in the new app?
4. `Operators Hours` vs `Customer Billed Hours` vs `Operators Actual Hours` — three figures on one
   sheet, and `Hours Worked` vs `Derived Hours` on the e-ticket. Are these the same two concepts?
5. **Is machine-level operator qualification enforced** at dispatch, or is the Equipment Qualify
   List an HR record only?
6. Rigging inspection is a **separate per-sling register**. Does it belong in the field app, in
   assets, or nowhere?
7. §13's **12% surcharge** and §14's show-up/cancellation minima are customer-contract rules that
   surface at quotation and invoicing, not in field ops — flagged here only because the field ticket
   is where the customer accepts them.

## Source

| File | Format | Note |
| --- | --- | --- |
| `TCG Paper Ticket 09-10-2025_1.pdf` | PDF, 2 pages, `pdftotext -layout` | blank form + full reverse-side T&Cs |
| `Updated LADWP Paper Ticket 2025[96].pdf` | PDF, 1 page | front only; T&C reverse not in the converted text |
| `NEW DAILY LOG. update 5-14-20.xlsx` | XLSX, 1 sheet `A1:G62`, row dump | blank fill-in form |
| `HR_PAYROLL - Daily Log and Timesheet.pdf` | PDF, 1 page | scan, no text layer — **read from the image 2026-09-04**; identical to the XLSX form |
| `from Melissa 2026-04-02/LADWP MYOM-92728.pdf` | PDF, 3 pages, 3.6 MB | scan, no text layer — **read from the image 2026-09-04**; invoice + completed ticket `TCG 298` + EIA fuel-price printout, transcribed in §2 |
| `TCG Fill In Required Information 03-20-2026_Final.pdf` | PDF, 1 page | blank |
| `TCG Fill In Equipment Qualify List 03-20-2026_Final.pdf` | PDF, 1 page | blank |
| `Synthetic  Sling.pdf` | PDF, 1 MB | text layer present but mirrored/mis-mapped; structure recovered, wording approximate |

All forms are blank; no personal data, licence numbers or card numbers appear in any of them.

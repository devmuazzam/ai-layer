---
title: Customer invoice packets — six worked examples, April 2026
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/from Melissa 2026-04-02/ (covering message + six invoice packet PDFs)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, module/payroll, module/field-ops, kind/source, invoicing, pricing, permits, ticket-workflow, provenance]
entities: []
---

# Customer invoice packets — six worked examples, April 2026

**What this is.** On 2026-04-02 Melissa McNutt (President, TCG) sent CodingCops six real
customer invoice packets — *"the attached sample packets that we have to send to different
customers"* — as the evidence behind a feature request: **generate these packets
automatically from a per-customer template**. The six PDFs are the first real invoice
artefacts in the vault. Everything below is read off those printed documents; the customer
names, job numbers and rates are the client's own, sent for exactly this purpose.

**The covering message and its ask are already written up** in
[../erp-review-log.md](../erp-review-log.md) → *#3 — Automatic customer packets*. That entry is
the **stated intent**; this page is the **shape of the artefact** the intent is about. Read
them together.

> **Nothing here is a specification.** These are printed outputs, not rules. Where an
> arithmetic relationship holds across every exhibit it is stated as arithmetic, and the
> document is quoted for what it does *not* say.

---

## The six packets

| Packet file | Invoice | Customer | Job | Date | Total |
| --- | --- | --- | --- | --- | ---: |
| `93003 packet.pdf` | MYOM-93003 | Southern California Edison (`SOU050`) | OM58305 | 2026-03-28 | $22,903.00 |
| `Asp 92556.pdf` | MYOM-92556 | Asplundh Construction | OM57554 | 2026-03-04 | $10,322.75 |
| `Par 92661.pdf` | MYOM-92661 | PAR Western Line Contractors, Inc. | OM56946 | 2026-03-09 | $8,133.97 |
| `Hotline 92868.pdf` | MYOM-92868 | Hot Line Construction Inc. | OM57915 | 2026-03-19 | $11,327.25 |
| `Faith 92930.pdf` | MYOM-92930 | Faith Electric, LLC | OM57980 | 2026-03-24 | $8,734.34 |
| `lausd 93015.pdf` | MYOM-93015 | Los Angeles Unified School District | OM57052 | 2026-03-27 | $6,275.09 |

Five of the six customers are Southern California Edison line contractors or SCE itself; the
sixth is a school district. Invoice numbers are `MYOM-#####` and run in the same series as the
job/ticket numbering (`OM#####` jobs, five-digit tickets).

---

## Three different invoice layouts in one set

The packets are **not** all produced by the same system, and the differences are structural. Two layouts were visible from the text; a third (LADWP) was read from the scan on 2026-09-04.

### Layout A — the QuickBooks-style invoice (five packets)

92556, 92661, 92868, 92930, 93015. Letterhead is *The Crane Guys, LLC, 10850 Portal Dr, Los
Alamitos, CA 90720*, with `invoices@craneguys.com`, a **"Ways to pay / View and pay"** button,
and the footer *"Please remit payment to … Or email check to Accounting@craneguys.com"*. The
"View and pay" affordance is the QuickBooks online-payment link the 2026-08-28 accounting
walkthrough describes ([../meetings/2026-08-28-accounting-process-discussion.md](../meetings/2026-08-28-accounting-process-discussion.md)).

**Header fields, exactly as printed:**

| Block | Fields |
| --- | --- |
| Top right | `Invoice MYOM-#####` |
| BILL TO | customer legal name, street, city/state/zip — LAUSD's block also carries `Contract No: C9326` |
| SHIP TO | **job-site name + address.** For the SCE contractors the site *name* is the utility's own identifier, e.g. `TD1376463, STR:741050E` or `TD2194368, STR:229635S/5001538E`; for LAUSD it is `University High School` |
| Dates row | `DATE` · `PLEASE PAY` (the amount) · `DUE DATE` |
| `P.O. NUMBER` | free text — `8000121060` (LAUSD), `D18-182541 CM` (Hot Line), `TD2194368, STR:22963` (Faith, truncated on the print). **Absent entirely on the Asplundh invoice.** |
| Line grid | `DATE · ACTIVITY · DESCRIPTION · QTY · RATE · AMOUNT` |
| Total | `TOTAL DUE` |

There is **no** sales-tax line, no subtotal line and no terms field on the face of the
Layout-A invoices; terms appear only on the ticket page behind them.

### Layout B — the NexGen/FCC-generated invoice (one packet)

93003 (Edison). Different form entirely — a two-page document whose header is a labelled block,
not a bill-to/ship-to pair:

```
Invoice        MYOM-93003
Invoice Date:  Saturday, March 28, 2026
Customer:      SOU050
Job No :       OM58305
Salesperson:   Joe Deitrick
Ordered By:    Alex Golson
Job Site :     204539200, 905130066 / 1032 N Sweetzer Ave, West Hollywood, CA 90069
Terms:         Net 10
Customer P.O. No: 204539200, 905130066
Work Performed:   60 C1 pole swap. EMERGENCY JOB
```

Layout B carries **Customer code, Job No, Salesperson, Ordered By, Terms and Work Performed on
the invoice face** — every one of which Layout A either omits or pushes onto the ticket. Its
line grid is `Date · Description · Qty · Unit Meas · Rate · Amount`, and it closes with
`Total Invoice:` and *"Thank you for using The Crane Guys, LLC , we appreciate your business."*

**The `Unit Meas` column is the difference that matters for the ERP.** Layout B states
`Hours` or `Each` per line; Layout A prints a bare quantity with no unit anywhere.

### Layout C — the LADWP contract-item invoice (one packet, read from the scan 2026-09-04)

92728 (LADWP). The packet had no text layer and was recorded above as unread; it was rendered
and read visually on 2026-09-04. It uses the **Layout A form** — same letterhead, same
`DATE · ACTIVITY · DESCRIPTION · QTY · RATE · AMOUNT` grid, same *Ways to pay* footer — but what
fills the grid is a third thing:

```
Invoice MYOM-92728        DATE 03/10/2026   PLEASE PAY $2,855.76   DUE DATE 04/09/2026
BILL TO  Los Angeles Department of Water and Power, 111 North Hope St., Contract 410B-5
SHIP TO  Order#9354607, Request#460760123, 3900 S Figueroa St, Los Angeles, CA 90037
P.O. NUMBER  R32352
03/10/2026  56 LADWP Item 56-90 Ton Crane                     4     80.00     320.00
03/10/2026  57 LADWP Item 57-90 Ton Crane Portal In-Out       3.50  80.00     280.00
03/10/2026  58 LADWP Item 58-90 Ton Operator                  4    125.00     500.00
03/10/2026  72 LADWP Item 72-Support Load                     6.50 225.00   1,462.50
03/10/2026  73 LADWP Item 73-Support Load Overtime            1    260.00     260.00
03/10/2026  79 LADWP Item 79 Fuel   [False Claims Act text]   7.50   4.434     33.26
                                                              TOTAL DUE   $2,855.76
```

Four things distinguish it:

1. **The ACTIVITY is the customer's contract line number.** `56`, `57`, `58`, `72`, `73`, `79`
   are LADWP's own schedule items under contract 410B-5, not TCG billing codes. The "90 Ton
   Crane" wording is LADWP's item title. This is billing in the *customer's* vocabulary — a
   **price list whose keys belong to the customer**, which is what the FCC price-list register's
   `LADWP — MSA rates` entry is (see [../quotations/fcc-billing-data-and-price-lists.md](../quotations/fcc-billing-data-and-price-lists.md)).
2. **Crane and operator are billed as separate items at separate rates** (item 56 crane $80/hr,
   item 58 operator $125/hr) and **portal-to-portal travel is its own item** (57) at the crane
   rate. Compare Layout B's Edison rate card, where crane and craft are also separate codes.
3. **Fuel is an index-priced pass-through**: 7.50 gallons at **$4.434**, backed by an attached
   printout of the U.S. EIA weekly California retail fuel-price table (captured 3/26/26, six
   weekly columns 02/16/26–03/23/26). The exact $4.434 does not appear on that sheet as printed;
   the derivation is not shown.
4. **The False Claims Act certification is printed in the description column of the fuel line**
   — *"Contractor is advised that submission of a false claim for payment to the LADWP may subject
   the Contractor to liability under the False Claims Act (California Government Code Section
   12650). The Contractor certifies that all work performed or materials provided … is in strict
   accordance with the terms and conditions of the subject contract…"* — a per-customer
   compliance statement carried on the invoice face.

**The backing pages.** The completed LADWP-variant paper ticket, serial `TCG 298` (crane `9001`,
job `OM57946`, crew-times grid Travel/Portal 2 hr · Permit Stand By 1.5 hr *"wait for LADWP"* ·
Work 3 hr · Boom Assembly and Disassembly 30 min each · Travel Portal 1.5 hr · Total Net Hours 9;
remark *"crane broke down 10:45am–11:45am"*), and the EIA price sheet. The ticket is transcribed
in [../field-ops/field-paper-forms.md](../field-ops/field-paper-forms.md) §2.

**The reconciliation gap this exposes.** Nine net ticket hours became 4 crane + 3.5 portal + 4
operator + 6.5 support-load + 1 support-OT invoiced hours. The mapping from the ticket's six
time bands to five contract items is done by a person, and the packet does not show the working.
For the ERP this is the clearest example yet of the *"final billing may differ from the quote"*
requirement in [../erp-review-log.md](../erp-review-log.md), and of a **customer-defined billing
vocabulary** that no billing-code catalogue in the vault currently models.

---

## The billing-code vocabulary these invoices reveal

The `ACTIVITY` (Layout A) / `Description` (Layout B) values are the customer-facing billing
codes. Every distinct value across the six packets:

### Equipment — Layout A

| Activity | Seen on | Qty | Rate |
| --- | --- | ---: | ---: |
| `200 Ton Crane` | 92868 | 10.50 | 525.00 |
| `175 Ton Crane` | 92556 | 11.50 | 495.00 |
| `90 Ton Crane` | 92930, 92661 | 13 / 8.50 | 395.00 |
| `LAUSD 25 Ton Crane ST` | 93015 | 5.50 | 178.20 |

### Labour and support — Layout A

| Activity | Description as printed | Qty | Rate |
| --- | --- | ---: | ---: |
| `Operator Load` | *"5 hour minimum with 8 hour max per day"* | 8 | 110.00 |
| `Support Load` | — | 10.50 / 11.50 | 155.00 |
| `Crew Overtime` | — | 0.50–4 | 130.00 / 195.00 / 260.00 |
| `Crew Double Time` | — | 1 | 260.00 |

`Crew Overtime` bills at a **different rate on every invoice** — 130.00 on the two 90-Ton jobs,
195.00 on the 175-Ton job, 260.00 on the 200-Ton job. The documents do not say what the rate is
a function of; the correlation with crane size is visible but unstated.

### Pass-through and surcharge — Layout A

| Activity | Description as printed | Qty | Rate | Amount |
| --- | --- | ---: | ---: | ---: |
| `Permit & Traffic Control Services` | `RCS S9002` / `RCS A89209` | 1 | 5,294.99 | 5,294.99 |
| `Permit & Traffic Control Services` | `RCS S9117` | 1 | 1,078.34 | 1,078.34 |
| `Permit & Traffic Control Services` | `RCS S9103` | 1 | 3,401.22 | 3,401.22 |
| `Permit & Traffic Control Services` | `ProTraffic 249435` | 1 | 200.00 | 200.00 |
| `Travel Permit - 75 Ton and above` | `Barstow` / `Palm Desert` | 1 | 165.00 | 165.00 |
| `Fuel & Insurance Surcharge` | — | *(blank)* | 1.00 | *computed* |

**The `DESCRIPTION` column on the permit line is a vendor-invoice reference**, and the
`Travel Permit` line uses the same column for the destination city. Same column, two different
semantics.

**`Fuel & Insurance Surcharge` prints with an empty QTY and a rate of 1.00** — the amount is
carried in the amount column alone, exactly the "Rate = 1, Amount = full line" shape the QBO
connector uses (see [nexgen-quickbooks-integration/](nexgen-quickbooks-integration/INDEX.md)).

### Edison rate-card codes — Layout B (93003)

The Edison invoice uses a **customer-prefixed** vocabulary. Every line, as printed:

| Description | Qty | Unit Meas | Rate |
| --- | ---: | --- | ---: |
| `Edison 275 Ton` | 13.00 | Hours | 335.00 |
| `Edison Operator OT` | 12.00 | Hours | 200.00 |
| `Edison Operator PT` | 2.00 | Hours | 255.00 |
| `Edison Oiler OT` | 12.00 | Hours | 195.00 |
| `Edison Oiler PT` | 2.00 | Hours | 250.00 |
| `Edison Truck Driver OT` | 12.00 | Hours | 190.00 |
| `Edison Truck Driver PT` | 1.50 / 2.00 | Hours | 245.00 |
| `Edison 2 Man Crew OT` | 8.00 | Hours | 200.00 |
| `Edison 2 Man Crew DT` | 4.00 | Hours | 248.00 |
| `Edison Support Vehicles Truck & Trailer` | 13.00 | Hours | 47.00 |
| `Edison Support Vehicles Counterweight Load` | 13.00 | Hours | 35.00 |
| `Permit & Traffic Control Services` (desc `RCS A89737`) | 1.00 | Each | 165.00 |

Four structural facts about this list:

1. **The customer name is baked into the code** (`Edison …`), not carried as a price-list
   attachment to a generic code. `LAUSD 25 Ton Crane ST` on 93015 does the same thing.
2. **`OT` / `PT` / `DT` are separate billing codes, not modifiers.** `PT` bills *higher* than
   `OT` for every craft on this invoice (Operator 255 vs 200, Oiler 250 vs 195, Truck Driver
   245 vs 190).
3. **The same code repeats as multiple lines.** `Edison Support Vehicles Counterweight Load`
   appears three times and `Edison Truck Driver OT` four times, once per unit/driver — the
   invoice is a per-resource enumeration, not a rolled-up total.
4. **There is no straight-time line on this invoice at all** — every labour line is OT, PT or
   DT. The job was a Saturday emergency call-out (`60 C1 pole swap. EMERGENCY JOB`).

---

## Two arithmetic relationships that hold across every exhibit

Stated as arithmetic on the printed figures. **No document in this set states either as a
rule.**

### 1. `Fuel & Insurance Surcharge` = 10% of every line except the permit line

| Invoice | Lines it is 10% of | Base | Surcharge printed |
| --- | --- | ---: | ---: |
| 92868 | crane + operator load + 2× support load + crew OT | 10,297.50 | **1,029.75** |
| 92556 | crane + operator load + crew OT + support load + travel permit | 9,202.50 | **920.25** |
| 92930 | crane + operator load + crew OT + crew DT + travel permit | 6,960.00 | **696.00** |
| 92661 | crane + operator load + crew OT | 4,302.50 | **430.25** |

`Travel Permit - 75 Ton and above` **is** in the base; `Permit & Traffic Control Services` is
**not**. The two Layout-B/LAUSD invoices carry no surcharge line at all.

### 2. The RCS permit line is billed at the vendor invoice × 1.15

Two packets contain the backing vendor invoice, and both land on 15%:

| Invoice | Vendor invoice in the packet | Vendor total | Billed to customer |
| --- | --- | ---: | ---: |
| 92661 | RCS `S 9103` | 2,957.58 | **3,401.22** (= ×1.15 exactly) |
| 92930 | RCS `S 9117` | 937.68 | **1,078.34** (= ×1.15, ±1¢ rounding) |

**But not universally.** The Pro Traffic invoice `249435` in packet 92556 totals **$200.00**
and is billed at **$200.00** — no markup. And on the Edison invoice, RCS `A 89737` totals
**$2,614.00** while the invoice line reads **$165.00 Each**; the packet does not say whether
the balance is recovered elsewhere.

> **This is a live discrepancy with the vault.** The 2026-08-28 accounting walkthrough records
> *"Permit and traffic control services are manually adjusted with a 10% markup"*
> ([../meetings/2026-08-28-accounting-process-discussion.md](../meetings/2026-08-28-accounting-process-discussion.md)).
> These two March-2026 exhibits both compute to **15%**, and a third exhibit shows **no markup
> at all**. Nothing here says which is current, whether the rate is per-customer or
> per-vendor, or whether the rule changed between March and August 2026. Raise it before
> encoding either number.

---

## What the backing pages contain

A "packet" is the invoice plus everything that substantiates it. The composition differs per
customer — which is precisely why Melissa asked for a **per-customer template**.

| Packet | Pages behind the invoice |
| --- | --- |
| `lausd 93015` | 1 signed FCC job ticket. **No vendor invoice** — despite a $5,294.99 permit line |
| `Hotline 92868` | 1 signed FCC job ticket |
| `Par 92661` | ticket · RCS invoice `S 9103` · RCS handwritten field sales ticket (scan) · **County of Orange OC Public Works encroachment permit** `RE26-0017` with its full standard provisions (scan, poor OCR) |
| `Faith 92930` | ticket · RCS invoice `S 9117` · RCS field sales ticket (scan) · **City of Barstow encroachment permit** `ENCU-26-0066` · the city's cash-register payment receipt |
| `Asp 92556` | ticket · **Pro Traffic Services invoice `249435`** · Pro Traffic's TCP request form · the stamped **temporary traffic-control plan drawing** (CAD sheet, client shown as Southern California Edison) |
| `93003 packet` | **8 pp** of FCC ticket pages (4 tickets: 43359, 43361, 43395, 43396) · **11 pp** of unit/job checklists · **4 pp** of labour detail · RCS invoice `A 89737` · RCS field sales ticket (scan) |

The City of Barstow receipt in the Faith packet shows a card payment
`[partial payment-card digits and a cardholder name are present in the source file — deliberately
not copied; see 'from Melissa 2026-04-02/Faith 92930.pdf']`.

### The ticket page (Layout A packets)

Each Layout-A invoice is backed by one signed FCC job ticket carrying, in this order:
salesperson name + phone · `Job:` · `Ticket:` · `Date:` · **Job Site Information** ·
**Report To** (site contact, phones) · **Customer Information** (`Ordered By`, phone, email,
**`Terms:`**, **`PO:`**) · `Equipment Required:` · `Description of Work:` · `Comments:` ·
**Lift Information** (Main Boom Length, Jib/Luffer Lgth, CWT, Radius, Load Weight, Jib
Offset, Height) · **Team Information** — one block per unit, each with Est Start/End Time,
Comments, **Employee Name**, **Employee Type**, **Worked Through Lunch** · and a time column
(`Start Time · Time Left Yard · Time Arrived Job · Time Left Job · Time Arrived Yard · End
Time`) with two customer signature blocks.

The second signature block carries the disclaimer, verbatim: *"The above times are verified to
be correct. **This is not a time ticket.** There have been no accidents involving any of the
equipment."*

**Employee Type values seen:** `Operator` · `Oiler` · `3rd Man`. **Unit codes seen:** `26503
(200 Ton All Terrain Crane)`, `26503 OL (Operator Load)`, `26502 (175 Ton All Terrain Crane)`,
`10001 (90 Ton Hydraulic Truck Crane)`, `27501 (275 Ton All Terrain Crane)`, `AT11 / AT13 /
AT18 / AT21 / AT22 / AT27 / AT30 / AT31 (Tractor - Semi)`, `26503.1 (Support Load 1)`, `4006
(40 Ton)`. Note the `OL` suffix convention: **`<unit> OL` is the Operator Load** that the
`Operator Load` billing code bills against.

### The labour-detail pages (93003 only)

Four pages the other packets do not have, and the only place in this drop where invoice
evidence and payroll evidence sit on the same document:

```
Employee | Union Code | Craft Code | Hours | Start Time | End Time | Comments
Sablay, Romel   | L12 | L12-G7-A | 13.50 | 5:30 AM | 6:30 PM | Phone man and third man
                                                              (1ST LUNCH TAKEN / 2ND LUNCH
                                                              MISSED - 0.5 DBL 2nd WTL)
Penman, Alex    | L12 | L12-G6-A | 14.00 | 5:30 AM | 6:30 PM | (NO LUNCH TAKEN - MISSING
                                                              AD-HOC WTL - 0.5 DBL 1st WTL
                                                              + 0.5 DBL 2nd WTL)
Sanchez, Miguel | L12 | L12-G2-A | 13.50 | 5:30 AM | 6:30 PM | No 2nd lunch (…0.5 DBL 2nd WTL)
Vigil, William  | L12 | L12-G8-A | 14.00 | 5:30 AM | 6:30 PM | (NO LUNCH TAKEN …)
Bunch, David    | L12 | L12-G7-A | 14.00 | 5:30 AM | 6:30 PM | (NO LUNCH TAKEN …)
```

Craft codes `L12-G2-A`, `L12-G6-A`, `L12-G7-A`, `L12-G8-A` under union code `L12`; hours 13.50
and 14.00 against a ticket span of 5:30 AM–6:30 PM; and **WTL adjudication written as a free-text
comment** — *"0.5 DBL 1st WTL + 0.5 DBL 2nd WTL"*, *"MISSING AD-HOC WTL"*. This is the
work-through-lunch handling of the payroll register
([../payroll/rules/PAY-047-worked-through-lunch-adjustment.md](../payroll/rules/PAY-047-worked-through-lunch-adjustment.md))
appearing as prose in a comment field on a customer-facing packet. The page header reads
`As Recorded on the Ticket: Start Time: 5:30 AM End Time: 6:30 PM` — i.e. the labour line is
explicitly reconciled against the ticket.

**None of these labour hours appear on the invoice.** The invoice bills 12.00 and 13.00-hour
lines against rate-card codes; the labour detail records 13.50 and 14.00 actual. The packet
shows both numbers side by side and says nothing about the relationship.

### The checklist pages (93003 only)

11 pages, per employee per ticket: `Unit Checklist - AT - Tractors Pre-Trip Inspections`
(26 items), `Unit Checklist - Tractor 30 Day Check List`, `Unit Checklist - Crane Pre-Trip
Inspection`, `Job Checklist - JSA 12.18.25` (7 items), and `Unit Checklist - Time Stamps` —
which is where the subsistence prompt (*"If Subsistence is applicable please click deficiency
and note long or short sub in the comments"*), the **Lunch Time** field and the signed
**meal/rest attestation** live. All three are already catalogued in
[2026-07-invoicing-adjustment-taxonomy.md](2026-07-invoicing-adjustment-taxonomy.md) → *What the
ticket screenshots incidentally prove*; **these packets are the second, independent exhibit of
the same three items**, on real signed documents rather than screenshots.

---

### The Asplundh packet's form fields and CAD drawing — read 2026-09-04

`Asp 92556.pdf` is the one packet with live PDF structure. Its **filled AcroForm fields** are the
**Pro Traffic Services TCP request form**, completed by TCG: `Requestor Name` Joe Deitrick ·
`TCPM` **`0062-TCG-26PM`** (Pro Traffic's plan number) · `Contractor` CRANE GUYS · `Customer
Job/PO` `TD1843128` · `Structure` `1570822E, 1570821E` · `Request Description` **Site Specific &
Permit** · `Job Description` **POLE REPLACEMENT** · `Location` Fairway Dr, Palm Desert · `Size` /
`Sheet Size` 11" × 17" · `# of Sheets` 1 · `Stamp Qty` NO · `Today's Date` 2/16/2026 · `WO Map`
Yes · `Rush` and `Stamp` left at *Select One*. A second set of fields — `claimant` THE CRANE
GUYS · `customer` ASPLUNDH CONSTRUCTION · `title` ACCOUNTS RECEIVABLE — belongs to a **lien /
preliminary-notice form** in the same packet, signed for by AR. The **temporary traffic-control
plan** itself is an AutoCAD export: its 434 "annotation" objects are the drawing's own text
labels (MUTCD sign codes `W20-1`, `C20(CA)R`, `R9-11`, the general notes on ADA pedestrian
access and the agency's right to modify the plan, *"NOT TO SCALE"*, the requestor's phone). So
the permit line on this invoice is backed by three documents for one $200 pass-through line:
the TCP request TCG filed, the stamped plan Pro Traffic produced, and Pro Traffic's invoice.

## Capture-quality signals worth naming

Observations on the documents, not judgements on the process.

- **The tonnage on the billing code, the equipment requested and the unit dispatched need not
  agree.** On 93015: billing code `LAUSD 25 Ton Crane ST`, `Equipment Required: 22 Ton + RCS`,
  unit assigned `4006 (40 Ton)`. On 93003: `Edison 275 Ton` billed, `Equip Req: 350 Ton (op +
  3) + RCS`, unit `27501 (275 Ton All Terrain Crane)`.
- **The customer PO and the job-site name are the same string** for the SCE-contractor
  customers — the utility's `TD…, STR:…` identifiers. Faith 92930's PO field is truncated at
  `TD2194368, STR:22963` on the printed invoice while the ticket carries the full
  `TD2194368, STR:229635S/5001538E`.
- **The Asplundh invoice has no P.O. NUMBER at all**, yet its ticket shows `Terms: Net 30` and
  the vendor paperwork carries `TCG-26M-0062`. Nothing says whether a PO was required.
- **Terms vary by customer and appear only on the ticket in Layout A**: Net 45 (LAUSD), Net 30
  (Hot Line, Faith, PAR, Asplundh), Net 10 (Edison, on the invoice face). Net 10 for Edison is
  consistent with the *2% Net 10* recorded on 2026-08-28.
- **`Signer's Name` is free text and inconsistent** — `Chris cabrera` on one signature block
  and `Chris Cabrera / Los Angeles Unified School Distric` (truncated) on the other of
  the same ticket; on 92556 the site contact is `Clint lambert` but both signatures read
  `Dusty Daniels`.

---

## Why this matters to the ERP

The stated ask is packet assembly ([../erp-review-log.md](../erp-review-log.md) #3). What the
packets show is what assembly would have to reach for: the invoice, the signed ticket(s), the
checklists, the labour detail, **and third-party documents that arrive from outside TCG
entirely** — a vendor's invoice, a vendor's field ticket, a city or county permit, a stamped
traffic-control drawing, a municipal payment receipt. Three of the six packets are unique in
composition. The vendor and permit documents are also exactly the `RCS invoices`, `Receivers`
and `Vendor permit sheet` artefacts the accounting team tracks by hand in OneDrive and Excel
([accounting-team-quickbooks-and-spreadsheet-activities.md](accounting-team-quickbooks-and-spreadsheet-activities.md)).

**Not stated anywhere in this set:** which customers require which extra forms, where the
waivers Melissa mentions come from, who assembles a packet today, or whether the packet is
emailed or posted.

## Source

- `1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/from Melissa 2026-04-02/_message from Melissa 2026-04-02.txt` — covering message, plain text
- `…/93003 packet.pdf` — 2 pp invoice + 8 pp tickets + 11 pp checklists + 4 pp labour + RCS invoice + field ticket; `pdftotext -layout`
- `…/Asp 92556.pdf` · `…/Par 92661.pdf` · `…/Hotline 92868.pdf` · `…/Faith 92930.pdf` · `…/lausd 93015.pdf` — same conversion
- Scanned inserts (RCS handwritten field tickets, the County of Orange and City of Barstow permits, the Pro Traffic CAD sheet) came through OCR-degraded; figures quoted from them are only those legible with confidence.

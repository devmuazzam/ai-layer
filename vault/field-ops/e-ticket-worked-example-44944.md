---
title: E-ticket worked example — job OM58859 / ticket 44944, the complete three-part set
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/job ticket - time card - equipment checklists/ (Job E-Ticket - 44944.pdf, Job E-Ticket Checklist - 44944.pdf, Job E-Ticket Labor & Unit Details - 44944.pdf)
migrated: 2026-09-04
updated: 2026-05-12
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/payroll, module/dispatch, module/assets, kind/reference, inspections, time-tracking, signatures, wtl, subsistence, craft-code, craft-modifier, boom, union-agreement, geolocation]
entities: []
---

# E-ticket worked example — ticket 44944

**What this is.** A **complete** printed e-ticket set for one worked day: the customer-facing
**E-Ticket**, its **Checklist** report, and the internal **Labor & Unit Details** report — three
PDFs, one ticket. Southern California Edison, job `OM58859`, ticket `44944`, worked
**Tue 12 May 2026** at 185 Catalina Dr, Oak View CA. Crane `10002` (90-ton hydraulic truck crane),
operator load `10002 OL`, tractor `AT25`. Two crew: an Oiler and an Operator.

**Why it matters.** The vault already holds one completed e-ticket —
[e-ticket-worked-example.md](e-ticket-worked-example.md), ticket 45954, which is the *checklist
report only*. This set is the first time the vault holds **all three parts of one ticket**, and
the third part, `Labor & Unit Details`, is the internal report that carries the union code, craft
code, craft modifier, and the two competing sets of times. It is the closest thing the vault has
to a picture of what the field app must ultimately produce.

> **This is a record of what the legacy system produced, not a requirement.** Nothing here has
> been adjudicated. Where it agrees with the FRD that is corroboration; where it shows something
> the FRD never mentions, that is flagged below and belongs in a decision, not in a spec.
> Employee numbers printed on the source are deliberately not copied; crew are named by first name
> and last initial, matching the convention on the 45954 page.

The FCC feature that produces each of these three tabs is documented by the vendor in
[fcc-e-ticket-and-atom-guides.md](fcc-e-ticket-and-atom-guides.md) — read the two together: this
page is the artifact, that page is the machine that made it.

---

## 1. Part one — the E-Ticket (customer-facing)

The header block repeats on every page: **salesperson** (name and phone), **Job**, **Ticket**,
**Date**; then three columns — `Job Site Information`, `Report To`, `Customer Information`. The
customer block carries `Ordered By`, `Terms: Net 10`, and `PO: 204549074, TD2354870`. The same two
reference numbers appear as the **job-site name**, so on this ticket the site is identified by the
customer's PO/work-order numbers rather than by a site name.

Then, in order:

| Section | Content on this ticket |
| --- | --- |
| `Equipment Required` | `90 Ton + RCS` |
| `Description of Work` | `50ft C1 pole swap` |
| `Comments` | `Leave yard 3AM hook ready 8AM` |
| `Lift Information` | Main Boom Length **140**, Jib/Luffer Length **35**, CWT **39500**, Radius **135**, Load Weight **2,000** |
| `Team Information` | one block per unit — see below |
| Times + two signature panels | see below |

### Team Information is per unit, and each unit block names an employee

Three blocks, one per unit, each with the same five fields: `Est Start Time`, `Est End Time`,
`Comments`, `Employee Name`, `Employee Type`, and a **`Worked Through Lunch`** field.

| Unit | Est start–end | Employee | Employee Type |
| --- | --- | --- | --- |
| `10002` (90 Ton Hydraulic Truck Crane) | 8:00 AM – 4:30 PM | Christopher G | **Oiler** |
| `10002 OL` (Operator Load) | 8:00 AM – 4:30 PM | Ernesto L | **Operator** |
| `AT25` (Tractor - Semi) | 8:00 AM – 4:30 PM | Ernesto L | **Operator** |

Two things this shows. **The Operator is attached to the Operator Load and the tractor, not to the
crane** — the crane block names the Oiler. And **one employee appears on two unit blocks**
(`10002 OL` and `AT25`), so the unit → employee relation on a ticket is not one-to-one.
`Worked Through Lunch` is a printed field on the ticket itself; it is blank here.

### Times and the two signature panels

Down the left margin, six times, and a `Start Time` / `End Time` pair bracketing them:

```
Start Time 3:00 AM · Time Left Yard 3:00 AM · Time Arrived Job 6:00 AM
Time Left Job 4:00 PM · Time Arrived Yard 7:30 PM · End Time 7:30 PM
```

Scheduled was 8:00 AM – 4:30 PM; actual as printed is 3:00 AM – 7:30 PM.

Two signature panels, each with its own attestation, **both signed by the same customer
representative**:

- **At the top** — *"The following terms and conditions governing this rental are understood and
  agreed to. The individual signing has been given the authority to execute this agreement."*
- **At the bottom** — *"The above times are verified to be correct. **This is not a time ticket.**
  There have been no accidents involving any of the equipment."*

The phrase *"This is not a time ticket"* on the customer's copy is worth noting against the third
report below, which is explicitly the time record. The document does not say what the distinction
is for.

---

## 2. Part two — the Checklist report

Same four printed phase headers as ticket 45954: **`Before Left Yard`** → **`After Arrived Job`**
→ **`Before Left Job`** → **`Ad-hoc Checklist`**. Every checklist answers in the same three
columns — `Completed` · `Deficiency` · `N/A`. Which box was ticked does not survive into the text
conversion; the item text and the signatures do.

### Which checklists this ticket carried

| Phase | Checklist | Scope | Items |
| --- | --- | --- | ---: |
| Before Left Yard | `Crane Pre-Trip Inspection` | unit `10002` | 17 |
| Before Left Yard | `Trailer 30 Day Check List` | unit **`10002 OL`** | 4 |
| After Arrived Job | `JSA 12.18.25` | **job** | 6 |
| Before Left Job | `Time Stamps` | unit `10002` | **14** |
| Before Left Job | `Time Stamps` | unit `AT25` | **11** |
| Ad-hoc Checklist | `Work Through Lunch Authorization` | **job** | 1 |

**Compared with ticket 45954** (Air Boss Mechanical, crane `10003`, tractor `AT15`): the two
tickets carry the *same template names* — `Crane Pre-Trip Inspection`, `Trailer 30 Day Check List`
on the `OL`, `Job Checklist - JSA 12.18.25`, `Time Stamps`, `Work Through Lunch Authorization`.
Ticket 45954 additionally carried `AT - Tractors Pre-Trip Inspections` and
`Tractor 30 Day Check List` for its tractor; **this ticket's tractor `AT25` carried no pre-trip at
all**, only `Time Stamps`. The documents do not say whether that is a per-unit configuration
difference or an omission.

### The Crane Pre-Trip Inspection, item by item

The vault held the *count* (17) from ticket 45954 but not the items. They are:

1. Load Line / Hook / Sheaves
2. Straps / Shackles / Tag Line / Air Port Flag / Safety Chains / Rope
3. Spill and Clean Kits / Cones / Wheel Chalks / Fire Extinguisher
4. **Crane Annual and Quad Certification Stickers**
5. Head Lights / Running Lights / Auxiliary Lights
6. Warning Labels
7. Coolant Level
8. Engine Oil
9. Belts and Pulleys
10. Seat Belts
11. Tire and Lugnuts
12. Mud Flats
13. Windows and Mirrors
14. Brake Operation
15. **Compliance: Registration / Tags / Annual Permits / Operating Manual / Load Chart**
16. Annual Permits
17. Additional Comments

Rows 4, 15 and 16 are **certification and permit checks inside the daily pre-trip** — the crew
confirms in the field that the crane's annual and quad certification stickers, registration, tags,
annual permits, operating manual and load chart are present. The FRD's `FR-FOP-028 Certifications`
is about the *employee's* certifications; nothing in it mentions unit certification stickers being
verified on the pre-trip.

The `Trailer 30 Day Check List` on `10002 OL` is four items: Insurance and Registration ·
Wheel Chalks · DOT Tape · Deck Condition — identical in count to the 45954 instance.

### The Time Stamps checklist — 14 items on the crane, 11 on the tractor

Crane `10002`, as filled (all values are free text in a `Comments:` line under the item):

| # | Item | Recorded |
| ---: | --- | --- |
| 1 | Leave Yard | `3:00am` |
| 2 | Arrive Job | `6:00am` |
| 3 | Build Up | `8:00am-830am` |
| 4 | Work | `830am-330pm` |
| 5 | Break Down | `330pm-4:00pm` |
| 6 | Leave Job | `4:00pm` |
| 7 | Arrive Yard | `730pm` |
| 8 | *"If Subsistence is applicable please click deficiency and note long or short sub in the comments"* | — |
| 9 | Lunch Time *(example: Lunch 12 pm to 12:30 pm)* | — |
| 10–12 | Lunch Time: 2nd / 3rd / 4th Lunch | — |
| 13 | Attestation: pre-trip, **rigging** and post-trip inspection performed | — |
| 14 | California meal-and-rest certification (full paragraph) | — |

This **independently confirms every structural observation the 45954 page made**, on a different
ticket, a different crane, a different customer and a month earlier:

- times are free text, with Build Up / Work / Break Down recorded as **ranges** and the other four
  as instants;
- **subsistence is captured as a Deficiency tick plus a `long`/`short` comment token** — no
  distance, no mileage field;
- **four lunch slots** exist on the crane template;
- one signature covers the whole Time Stamps block, and the same signature attests that pre-trip,
  rigging and post-trip inspections were done.

The tractor `AT25` Time Stamps checklist again has **one** lunch slot, not four, and omits the
2nd/3rd/4th rows entirely — so on **both** tickets in the vault the tractor template differs from
the crane template in exactly the same way. That makes template drift on a single ticket an
unlikely explanation; it does not tell us which is intended.

### The JSA is a job checklist, and it is the same dated template

`Job Checklist - JSA 12.18.25`, 6 items — the same versioned template seen on ticket 45954, with
the item text now recorded:

1. Working Near Cranes / Suspended Loads / Falling Objects / Moving Machinery / Tag Lines / Lift
   Barricades / Ladders Used / Tools and Equipment / Sharp Metals
2. PPE: Gloves / High Visibility Vests / Safety Glasses / Fall Arrest Systems
3. Site Conditions: Poor Lighting / Poor Visibility / Slippery Surfaces / Trip Hazards / Working at
   Heights / Flammable and Pressurized Fluids and Materials in Area / Inhalable Dust or Fibers /
   High Noise Area / Communication Difficulties / **Street Permits / Lane Closures / FAA Permit /
   Pedestrian Control**
4. Rigging: Shackles / Chains / Slings / Cables / Spreader Bar
5. Electrical > 4001 AMPS / Multiple Electrical Feeds / Equipment Grounded
6. Safety Meeting Performed

Signed by three people — the two crew and the customer representative.

**This six-item JSA is not either of the 2026 paper JSA forms** TCG also uses. See
[safety-compliance/02-jsa-and-lift-planning-forms.md](safety-compliance/02-jsa-and-lift-planning-forms.md):
the paper forms have dozens of talking points, a Crane Guys Standard gate and a crew roster. What
the e-ticket carries is a six-line acknowledgement. Nothing in the drop says which is authoritative
or whether both are meant to be completed.

### The Work Through Lunch Authorization, with the customer's own words

Filed under `Ad-hoc Checklist`. One item, which reproduces the meal-period charge terms verbatim:

> *"By signing this the customer is authorizing the crew to work through their required lunch and
> approving the charges stated below. **Meal Periods:** No employee shall be required to work more
> than 5 hours consecutively without one-half (1/2) hour meal period. If meal periods are worked
> then customer will be charged one-half (1/2) hour of Crew time Double-time & one-half (1/2) hour
> for all cranes and equipment."*

Its `Comments:` field on this ticket reads **`Didnt take first or second lunch`** — and it is
signed by the **customer** representative. That comment is the field-side counterpart of the payroll
modifier note in part three below (`0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL`), which is the first time the
vault can see **one missed-meal event traced from the customer's signature through to the labor
entry** on the same document set.

The terms text is word-for-word §15 of the paper ticket's Terms and Conditions —
see [field-paper-forms.md](field-paper-forms.md).

### Signature timing on this ticket differs sharply from 45954

Every signature on this ticket is timestamped **late on the same evening**:

| Block | Signer | Timestamp |
| --- | --- | --- |
| Crane Pre-Trip (Before Left Yard) | Chris | **5:53 AM** |
| JSA (After Arrived Job) | Ernesto, Chris, Johnny (customer) | **10:13 PM** |
| Crane Time Stamps (Before Left Job) | Chris | **10:15 PM** |
| Tractor Time Stamps | Chris | **10:16 PM** |
| Work Through Lunch Authorization (ad-hoc) | Johnny (customer) | **10:17 PM** |

On ticket 45954 the JSA was signed at 10:15–10:16 **AM**, in the phase it belongs to, and the WTL
authorization at 10:26 AM — *before* the missed meal. Here every signature after the pre-trip lands
inside four minutes at the end of the day, including the customer's JSA signature (nominally an
on-arrival activity) and the customer's WTL authorization (nominally a pre-authorization). **The
system accepted all of them.** The documents record the timestamps; they do not say whether
signing a phase checklist outside its phase is permitted, expected, or a control gap.

---

## 3. Part three — Labor & Unit Details (internal)

Headed `Labor & Unit Details`, with `Job OM58859`, `(Invoiced)`, `Ticket 44944`, the date, and a
`Location` column that is empty on this print.

### Two parallel sets of times

The report prints **two time columns side by side**:

| Interval | As recorded **for the customer** | As recorded **by the workflow** |
| --- | --- | --- |
| Started | 3:00 AM | 5/12/2026 5:53 AM |
| Left Yard | 3:00 AM | 5/12/2026 5:54 AM |
| Arrived Job | 6:00 AM | 5/12/2026 5:54 AM |
| First Signature | — | 5/12/2026 9:32 AM |
| Second Signature | — | 5/12/2026 10:13 PM |
| Left Job | 4:00 PM | 5/12/2026 10:16 PM |
| Arrived Yard | 7:30 PM | 5/12/2026 10:16 PM |
| Ended | 7:30 PM | 5/12/2026 10:16 PM |
| **Total** | **Customer Hours 16.50** | **Workflow Hours 16.38** |

The workflow column is the moment the button was pressed on the device; the customer column is
what was presented on and signed off from the customer-facing ticket. On this ticket **five of the
six workflow stamps land in two clusters** — 5:53–5:54 AM and 10:13–10:16 PM — while the customer
column is a plausible working day. `First Signature` and `Second Signature` appear only in the
workflow column.

This is FCC's *"Allow modification of all dates and times for Job and LEM Tickets"* option in
action: the vendor guide states that when it is on, the Job E-Ticket Report grows a section called
*"As recorded for customer"*, the original workflow times are still recorded, and **the user must
provide a justification for the modification of a time** — see
[fcc-e-ticket-and-atom-guides.md](fcc-e-ticket-and-atom-guides.md) → *Editable times*. **No
justification text is printed on this report**, and the report does not say whether one was
captured and simply not printed. The vendor guide also says the customer-column times are what
flows to invoicing, and that the workflow times are what flows to the map links.

Two consequences worth stating plainly, because both bear on the ERP:

1. **The ticket carries two answers to "when did this happen", and they differ by 0.12 h here.**
   Any design that treats "the time the button was pressed" as the labor time will not reproduce
   this document.
2. The FRD's `FR-FOP-038 Time Rounding` (FOP-001) and the demo's ±30-minute adjust-with-reason
   control ([field-app-demo-2026-06.md](field-app-demo-2026-06.md)) are both attempts at the same
   problem. Neither document mentions keeping *both* values.

### Team labor totals

`Team Labor Details (As recorded)` lists both employees at **17.00** hours each,
`Total Hours Worked` **34.00**.

### The labor entry — union, craft, modifier, classification

Each employee has a `Labor Entries` table with these columns, and one row:

`Union Code | Craft Code | Modifier | Classification | Start | End | Hours Worked`

| | Primary (Oiler) | Secondary (Operator) |
| --- | --- | --- |
| Union Code | `L12` | `L12` |
| Craft Code | `L12-G3-A` | `L12-G2-A` |
| **Modifier** | `161-180Ft-Oiler` | `161-180Ft-Operator` |
| Classification | `Field Employees` | `Field Employees` |
| Start – End | 3:00 AM – 7:30 PM | 3:00 AM – 7:30 PM |
| Hours Worked | 16.50 | 16.50 |

Under each row, a free-text note: **`LB 8AM-4PM, (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL)`**.

Then, per employee, two different totals:

- `Hours Worked` **17.00**
- `Derived Hours` **16.50**

The vendor guide defines these exactly: *"Hours Worked is the value entered/overwritten in the
Hours field of the ticket; Derived Hours is the difference between the End and Start times."* So
`Derived Hours` 16.50 is 3:00 AM → 7:30 PM, and `Hours Worked` 17.00 is a manual override — 0.5 h
higher, which is the size of one of the two half-hour WTL premiums named in the note. The document
does not state that the two facts are connected.

**What this row establishes:**

- The **craft modifier is a boom-length bracket combined with the seat**: `161-180Ft-Oiler` vs
  `161-180Ft-Operator`. This is what `FR-FOP-024 Boom Pay / Craft Modifier Selection` (FOP-001) and
  the demo's `BOOM_BRACKETS` list are modelling, and it is the first real instance of the value
  format in the vault. The lift information on part one gives Main Boom 140 + Jib 35 — the
  document does not say how the 161–180 ft bracket was derived from those numbers.
- **Craft code encodes the union and a group**: `L12-G3-A` (Oiler) vs `L12-G2-A` (Operator), with
  `Classification` a separate field (`Field Employees`).
- **Work-through-lunch reaches payroll as free text inside the modifier note**, not as a structured
  field: `0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL`. Two WTLs on one day, both at double time, matching
  the customer's comment on the ad-hoc checklist. The `LB 8AM-4PM` prefix appears to be the
  scheduled window; the document does not define the abbreviation.
- `Other Entries` prints **`No non-labor entries were entered`** on both employees. Per the vendor
  guide this is where per diem, missed meals and mileage would appear as `MISC`-type entries — so
  on this ticket the WTL premium was *not* entered as a MISC entry, only as note text.

### Unit details and the location disclaimer

`Unit Details` lists `Unit 10002`, `Unit 10002 OL`, `Unit AT25` with **no hours or odometer values
under any of them**. A caret `^` marks entries *"Recorded on primary device"*, and the footer is
FCC's standard location disclaimer: location was provided with the device user's permission, uses
the device's own capabilities, and a missing location means either no connectivity or a rejected
permission.

---

## 4. What this set adds that the vault did not have

| New here | Where it matters |
| --- | --- |
| The complete **Labor & Unit Details** report | the only view of union code / craft code / craft modifier / classification as the field app emits them |
| **Two parallel time sets** on one ticket, differing | contradicts any single-timestamp model of labor capture |
| `Hours Worked` vs `Derived Hours` as separate printed totals | override is a first-class value, not an exception |
| The **craft-modifier value format** `161-180Ft-Oiler` | makes `FR-FOP-024` concrete |
| **WTL as free text in a modifier note**, two on one day | the WTL capture → payroll path, end to end |
| The **Crane Pre-Trip item list**, incl. certification/permit rows | pre-trip verifies unit compliance documents, unmentioned in either FRD |
| The **JSA 12.18.25 item text** | lets the e-ticket JSA be compared with the two paper JSA forms |
| **`Est Start/End Time` per unit** on the customer ticket | scheduled vs actual is printed for the customer |
| A second ticket with **4 lunch slots on the crane, 1 on the tractor** | makes template difference, not drift, the likelier reading |
| Signatures **batched at end of day**, including customer JSA | the system accepts out-of-phase signing |

## 5. Open points this document raises

These are recorded here for a human to route; they are **not** written to any `gaps.md`.

1. When editable times are on, **which set is the labor record** — customer or workflow — and does
   the ERP have to keep both? Is a justification required, and is it stored?
2. Is the **modifier note** (`LB 8AM-4PM, (0.5 DBL 1st WTL + 0.5 Dbl 2nd WTL)`) parsed by anything
   downstream, or is it prose for a human? If the ERP structures WTL, what happens to it here?
3. **Should a phase checklist be signable outside its phase?** Every non-pre-trip signature on this
   ticket is timestamped at day's end, including a customer JSA signature.
4. Why did the tractor carry **no pre-trip** on this ticket when it did on 45954 — configuration or
   omission?
5. How is the **boom bracket** (`161-180Ft`) derived — from Main Boom + Jib on the lift info, from
   the operator's selection, or from a configuration record?
6. Does `Hours Worked` 17.00 vs `Derived Hours` 16.50 reflect a rule, or a free-hand override?

## Source

- `1.0.1_BUSINESS-REQUIREMENTS/job ticket - time card - equipment checklists/Job E-Ticket - 44944.pdf` — PDF, 2 pages, `pdftotext -layout`
- `1.0.1_BUSINESS-REQUIREMENTS/job ticket - time card - equipment checklists/Job E-Ticket Checklist - 44944.pdf` — PDF, 6 pages, `pdftotext -layout`. Checkbox states (`Completed`/`Deficiency`/`N/A`) do not survive text extraction; item text, comments and signature timestamps do.
- `1.0.1_BUSINESS-REQUIREMENTS/job ticket - time card - equipment checklists/Job E-Ticket Labor & Unit Details - 44944.pdf` — PDF, 2 pages, `pdftotext -layout`

Employee numbers printed on the source, and the phone numbers of the customer contacts, are
deliberately not copied.

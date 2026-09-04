---
title: FCC billing data and price lists — the import contract and the code catalogue
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-IMPORT-Templates/Billing Data v.01.26.xlsx, 1.0.1_BUSINESS-REQUIREMENTS/TCG_PRICE_LISTS/Price Lists Process in FCC-NexGen.docx, 1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_MAINTAIN_CODES-BILLING (reviewed by TCG).pptx (notes and the 23 embedded screenshots, read 2026-09-04)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/accounting, module/assets, kind/source, pricing, reference-data, yards, data-migration, mob-demob]
entities: []
---

# FCC billing data and price lists — the import contract and the code catalogue

**What this is.** Three documents that together define how a billing code is shaped in FCC, how
price lists attach to customers, and what TCG wants changed about both.

| Document | What it is |
| --- | --- |
| `Billing Data v.01.26.xlsx` | **Fleet Cost & Care's own import template** — the required/optional contract for loading billing codes, billing types, price lists and price-list rates, with an examples sheet and a ~185-entry catalogue of real billing-code names |
| `Price Lists Process in FCC-NexGen.docx` | A TCG walkthrough of creating a price list, attaching it to a customer, and seeing it reach a quote |
| `FCC_MAINTAIN_CODES-BILLING (reviewed by TCG).pptx` | TCG's annotations on the FCC billing-code and price-list screens — **14 slides, of which 7 carry notes** |

**Why it matters.** [billing-code-and-price-list.md](billing-code-and-price-list.md) is a
nine-line punch list. This is the underlying structure it is complaining about, in the vendor's
own field definitions, and it answers that page's closing question about yards.

> **This is the FCC template, not TCG's data.** The `1. Billing Codes` sheet is dimensioned
> `A1:AO5252` but is delivered **empty** below the three header rows — every one of ~5,000 rows
> holds only the formula-driven `OK` / `No Match` validation flags. **No TCG billing-code rows
> were shipped in this file.** The named codes in §3 come from the *examples* sheet.

---

## 1. The billing-code import contract

Sheet `2. Billing Code Examples` carries the clean 15-column layout (sheet 1 is the same fields
interleaved with `Match Option` / `Match Length` validation helpers, 41 columns wide).

| Column | Required? | Rule, as the template states it |
| --- | --- | --- |
| **Description** | Required | up to 2000 characters. *"(Recommendation is to follow similar naming schema to aid users in finding billing codes from drop down list)"* |
| **Amount or Percent Calculation** | Required | `A` or `P`. *"(Majority of billing codes will be A - example: **Fuel surcharge will be P**)"* |
| **Default Rate** | Optional | up to 7 digits before the decimal, 2 after. *"leave blank if there is not a standard rate"* |
| **Unit of Measure** | Optional | code from the `General UOM` tab |
| **Credit To** | Optional | a **Schedule Type** code. *"(For equipment facing billing codes - leave blank if billing code if not for equipment)"* |
| **GL Account** | **Required** | *"(Revenue GL account number that the billing code should map to in accounting)"* |
| **Auto Allocate** | **Required** | `Y`/`N`. *"(Select Y if **utilization hours should automatically be allocated to the equipment**)"* |
| **Billing Type** | Optional | code from the `Billing Types` tab |
| **Job Type** | **Required** | **`N` = NA, `O` = Operated, `B` = Bare** |
| **Status** | **Required** | `A` = Active, `T` = Inactive |
| **Unit Type** | Optional | a **Resource Type** code. *"(For equipment facing billing codes - leave blank…)"* |
| **Print Unit Info for Bare Rentals** | Optional | *"(Select Y for bare rental billing codes so the unit's **make, model, etc. prints on an invoice**)"* |
| **Taxable** | **Required** | *"(Select Y if tax should be applied against this billing code)"* |
| **% Applied** | **Required** | *"(**Only for billing codes calculated using an amount** - select Y if it should be **included when calculating billing codes using a percentage**)"* |
| **Default as Sub-Item** | Optional | *"(Select Y if this billing code should be **included as a sub-item rolling into another billing code**)"* |

Four of these are load-bearing and are not documented anywhere else in the vault:

- **`Job Type` here is `NA / Operated / Bare`** — a *different* dimension from the `Job Type` on
  the quote's Main tab (`Hourly / Weekly / Monthly`, see
  [fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §2) and from the estimate-template job
  type (`Hourly` vs `Hourly w/ Mob`, see
  [fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md)). **Three things
  are called "Job Type" in FCC and they are not the same thing.** The template does not
  reconcile them.
- **`% Applied` is the surcharge-base flag.** This is the mechanism behind the 12% Fuel &
  Insurance Surcharge on every TCG quote: percentage codes compute over the sum of the
  amount-codes whose `% Applied` is `Y`. It is exactly what Melissa asked for — *"We need to add
  a **% applied for surcharges**"* ([erp-review-log.md](../erp-review-log.md) → *#10 Billing
  codes*) — and what the 2026-05-05 meeting called *"configure which billing codes receive the
  surcharge, per line / billing code"*. **FCC already has this field; the ask is to keep it.**
- **`Default as Sub-Item` makes the mob/demob roll-up a property of the code**, not only a
  per-quote tick. That is the third leg of the sub-item story alongside the estimate template's
  `.Item` flag and the Estimate-tab checkbox — see
  [fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md) §3.
- **`Auto Allocate` ties a billing code to equipment utilisation hours.** Nothing in the vault
  models utilisation allocation from billing.

### The import template's validation formulas (read 2026-09-04)

`Billing Data v.01.26.xlsx` carries 139,535 formulas — 18 patterns on `1. Billing Codes`, all
validation: description ≤ 2000 chars; **status resolved through `Data List` to `A` / `P`**;
code ≤ 10 chars; **unit of measure must exist in `5. General UOM`** (and its description is
pulled back); **schedule type must exist in `6. Schedule Types`** (column C; column K supplies a
description); **GL account looked up in `8. GL Accounts`** (column H); a `Y/N` flag via
`Data List`; **billing type must exist in `4. Billing Types`**. The three hidden sheets (`9. Price
Lists`, `10. Billing Codes in Price List`, `Data List`) are the lookup tables. So FCC's own
contract for a billing code is: code · description · status (A/P) · UOM (from a closed list) ·
schedule type · GL account · taxable flag · billing type — the same eight things the ERP's
billing-code model needs to carry.

## 2. The other sheets

| Sheet | Dimensions | What it holds |
| --- | --- | --- |
| `1. Billing Codes` | `A1:AO5252` | the 41-column validated import grid — **delivered empty** |
| `2. Billing Code Examples` | `A1:O200` | 12 fully worked rows + a name-only catalogue (§3) |
| `3. Billing Codes Information` | `A2:M142` | **entirely blank in the converted text** |
| `4. Billing Types` | `A1:D31` | `Code` (≤10 chars) + `Billing Type Description` (≤50 chars) — **30 empty rows; no TCG billing types supplied** |
| `5. General UOM` | `A1:A1` | *"Copy and paste from General Units of Measure tab on unit data import sheet"* |
| `6. Schedule Types` | `A1:A1` | *"Copy and paste from Schedule Types tab on unit data import sheet"* |
| `7. Resource Types` | `A1:A1` | *"Copy and paste from Resource Types tab on the unit data import spreadsheet"* |
| `8. GL Accounts` | `A1:A1` | *"Copy and paste from GL Accounts tab on the general company data spreadsheet"* |
| `9. Price Lists` | `A1:G3` | `Code` (≤15 chars) · `Price List Description` (≤50) · **`Sales Discount %`** (optional, 2 dp) · `Status` A/T |
| `10. Billing Codes in Price List` | `A1:G1002` | `Description` (must match a billing code) · `Price List` (must match a price-list code) · **`Default Rate` (required)** · `Status` — **1,000 empty rows** |
| `Data List` | `A1:H3` | the four validation vocabularies: Active `A` / Inactive `T` · Yes `Y` / No `N` · NA `N` / Operated `O` / Bare `B` · Amount `A` / Percentage `P` |

Sheets 5–8 confirm this template is **one of a set** — a unit-data import sheet and a general
company-data sheet exist and are the authorities for UOM, schedule types, resource types and GL
accounts. Neither is in this drop.

**The price-list model, in two facts.** A price list carries **one blanket `Sales Discount %`**,
and separately **an explicit `Default Rate` per billing code in the list** — and that per-code
rate is *required*, not optional. So a price list is simultaneously a discount and a rate
override table, and the template does not say how they interact.

## 3. The billing-code catalogue

`2. Billing Code Examples` carries 12 fully-populated example rows and then ~170 names under
*"Other examples of billing codes"*. This is the closest thing in the drop to TCG's real code
list, but **the sheet does not say which of these are TCG's** — the file is a vendor template.

The 12 worked rows, in full, because they show how the fields combine:

| Description | A/P | Rate | UOM | Credit To | GL | AutoAlloc | Billing Type | JobType | Status | Unit Type | PrintUnit | Taxable | %Applied | SubItem |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 80 Ton Rough Terrain, Hourly Rate | A | 100 | HR | Rough Terrain | 4000 | Y | Operated | O | A | 80 Ton Rough Terrain | N | N | Y | N |
| 80 Ton Rough Terrain, Daily Rate | A | 800 | DY | Rough Terrain | 4000 | Y | Bare | B | A | 80 Ton Rough Terrain | Y | Y | Y | N |
| 80 Ton Rough Terrain, Weekly Rate | A | 4500 | WK | Rough Terrain | 4000 | Y | Bare | B | A | 80 Ton Rough Terrain | Y | Y | Y | N |
| 80 Ton Rough Terrain, Monthly Rate | A | 18000 | MN | Rough Terrain | 4000 | Y | Bare | B | A | 80 Ton Rough Terrain | Y | Y | Y | N |
| Mobilization In | A | — | EA | — | 4000 | N | **Mobilization** | N | A | — | N | N | Y | N |
| Mobilization Out | A | — | EA | — | 4000 | N | **Mobilization** | N | A | — | N | N | Y | N |
| Operator OT | A | 40 | HR | — | **4100** | N | Labor Only | N | A | — | N | N | N | N |
| Rigger ST | A | 75 | HR | — | 4100 | N | Labor Only | N | A | — | N | N | N | N |
| Rigger OT | A | 35 | HR | — | 4100 | N | Labor Only | N | A | — | N | N | N | N |
| Spreader Bar, Daily Rate | A | 25 | DY | — | **4200** | N | Misc | N | A | — | N | Y | N | N |
| **Fuel Surcharge %** | **P** | **8** | **PC** | — | 4000 | N | **Fuel** | N | A | — | N | N | N | N |

Read across the rows and the design is visible:

- **UOM codes**: `HR` hourly · `DY` daily · `WK` weekly · `MN` monthly · `EA` each · `PC` percent.
- **Billing Types seen**: `Operated` · `Bare` · `Mobilization` · `Labor Only` · `Misc` · `Fuel`.
- **GL accounts split by revenue kind**: `4000` equipment and mobilisation, `4100` labour, `4200`
  miscellaneous equipment.
- **Bare rental rows are `Taxable = Y`; operated rows are `N`.** Labour rows are also `N` — and
  crucially **`% Applied = N`**, so on this template *labour is not in the surcharge base while
  equipment and mobilisation are.* TCG's own quote says the opposite: *"ALL charges are subject
  to a 12% Fuel & Insurance Surcharge"*, and the arithmetic on OM-36229 includes the permit and
  lift plan lines. See [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §1. **This is
  the vendor's example data, not TCG's configuration — but it shows the flag can exclude lines,
  which is exactly the per-code control the 2026-05-05 meeting asked for.**
- **`Fuel Surcharge %` is `P`, 8%, UOM `PC`.** The mechanism matches TCG's surcharge line exactly
  — OM-36229 prints it as `Fuel & Insurance Surcharge · 1.00 · Each · 12.00% · $307.80`, a
  quantity-1 line whose "rate" is a percentage.

**The name catalogue** (~170 entries, names only, no rates). It is worth knowing what shape TCG's
code list takes, so the recurring patterns rather than the whole list:

- **`<capacity> Ton <crane type>` with a rate period** — Hourly / Daily / Weekly / Monthly / ST /
  OT / DT / Standby / 24 Hour / Weekend, and Operated vs Bare variants of each. Capacities run
  19, 22, 25, 30, 40, 50, 55, 60, 70, 80, 90, 100, 110, 120, 130, 135, 155, 160, 175, 180, 200,
  220, 242, 250, 265, 270, 275, 300, 330, 350, 400, 422, 423, 440, 450, 500, 550, 600, 660, 800
  ton. Types include All Terrain (AT), Rough Terrain (RT), Crawler, Telecrawler, Boom Truck, Taxi
  Crane, Hydraulic Truck Crane, Gantry.
- **Forklifts** — 8K, 15K, 20K, 25/35, 30K, 40/60, 120K, `Versa Lift 25/35`, `Forklift 5K
  Electric`, `15k forklift sub`.
- **Labour by craft × premium** — `Operator/Oiler/Driver/Foreman × Straight Time / Overtime /
  Doubletime`, plus `Rigger`, `3 Man Rigging Crew` and `3 Man Rigging Crew OT`, `Designated
  Spotter`, `Millwright`, `Escort`.
- **Mobilisation and travel** — `Mobilization In`, `Mobilization Out`, `Travel In`, `Travel Out`,
  `500 Ton Crane Travel - In / Assembly`, `Disassembly and Load Out`, `Loadout`, `Offload`,
  `Pickup`, `Delivery`.
- **Transport** — `3-Axle Tractor`, `4-Axle`, `Tractor Haul - One Way`, `Tractor/Trailer With
  Driver`, `Trailer - Lowboy`, `Trailer Weekly Rate`, `Trucking`.
- **Rigging and site kit** — `Counterweight Load`, `Crane Mat`, `Steel Crane Mats / Customized`,
  `Steel Plate`, `Spreader Bar`, `Man Basket`, `Man Lift Rental`, `Luffer Attachment`, `Tools &
  Equipment`, `Materials`.
- **Services and pass-throughs** — `Lift Plans`, `Engineering`, `Permit(s)`, `Per Diem`,
  `Environmental Charge` (spelled `Envronmental Charge` in the source), `Fuel Surcharge`,
  `Service and Maintenance Fee`, `Price Adjustment`, `Storage Monthly Charge`, `Storage Reload
  Charge`, `Storage Unload Charge`, `Overtime`, `Bare Rental`, `Crane & Operator`.

Two of those names are already known to the vault from a different direction: **`Price
Adjustment`** and **`Crew Time (curfew standby)`-style premium placeholders** appear pre-seeded
at 0.00 in the 100-Ton estimate template
([fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md) §3), and
`Mobilization In` / `Mobilization Out` are the roll-up parents that
[mobilization-and-demobilization.md](mobilization-and-demobilization.md) describes.

## 4. How a price list reaches a quote — `Price Lists Process in FCC-NexGen.docx`

TCG's own five-step walkthrough. It is almost entirely screenshots (30 images), so what survives
is the navigation and the captions.

**Step 1 — Add price list.** `Maintain → Customers → Price List`. *"Price List screen has 3
tabs: **Main**, **Parts**, **Billing Codes**. The selection on the 'Main' tab changes the items
on other tabs."* Worked with two real customers, `DUNKEL BROS` and `SO CAL EDISON`, each showing
a different set on Billing Codes. New list: **Add List** → type → **Save**. *"Same process for
adding 'Billing Codes'… however, there is a dropdown menu for the billing codes."*

**Step 2 — Assign to customer.** `Maintain → Customers → Customers`; the price list is a field on
the customer record. Demonstrated by creating `Z_TEST_CUST_01` in the TEST database and
attaching `Z_TEST_LIST_01`.

**Step 3 — Create job quote.** `Enter → Quotes → Job Quotes`; the Unit/People tab auto-populates
from the estimate template on the Mobile Crane and Type entered (90 Ton in the example), and the
Estimate tab auto-populates too.

**Step 4 — Convert quote to job.** The **Conv Job** button in the top menu.

**Step 5 — Schedule / view job.** `Schedule → Job`. The example is *"a 'real' 275-ton crane job
for Southern California Edison (in the TEST database)"*. Its Main tab *"shows **'Quote' and
'PO(s)' on the bottom-right corner of the screen**"* — and the note that *"The Job above does not
have a Purchase Order attached"*.

The document then walks the **Purchase Orders** screen (`Enter → Purchase Orders`; tabs `Main`,
`Detail`, `Rec/Vouchers`; double-clicking the Vendor Code opens the vendor) and the **Vendors**
screen (`Maintain → Vendors`; tabs `Main`, `Comments`, `Contacts`).

**The `Quote` and `PO(s)` fields on the job's Main tab are the third independent confirmation
that POs live on the job, not the quote** — with the lifecycle SVG and the FCC manual's list of
job-only fields. See
[quote-lifecycle-permits-and-purchase-orders.md](quote-lifecycle-permits-and-purchase-orders.md).
It also shows a **`Rec/Vouchers` tab** on the PO, which is the goods-receipt / three-way-match
leg of the vendor-PO workflow that diagram describes.

### What the 30 screenshots show — read from the images on 2026-09-04

The walkthrough's screenshots were extracted from the `.docx` and read directly. They carry the
field values the caption text does not, and two of them answer questions other pages leave open.

**The price-list register (Maintain → Customers → Price List, Main tab).** 22 lists in the TEST
database at the time of the walkthrough, with the FCC description and the `Sales Discount %`
column as shown:

| Price List | Description | Discount % | Status |
| --- | --- | ---: | --- |
| BIGGE · DUNKEL BROS · JENSEN · JULY 2021 RATES · MINTZ CONCRETE · PAR · POLE CONTRACTOR · PREFERRED 1 · SHARED CRANE · VULCAN MATERIAL · WA RASIC | Special Rates | 0.00 (some blank) | Active |
| FAITH ELECTRIC · HENKELS & MCCOY · HW POWER | Special Rates | 0.00 | **Inactive** |
| **SO CAL EDISON** | Special Rates | **15.00** | Active |
| **SO CAL EDDISON** *(sic)* | Project Name 2026 | **10.00** | Active |
| **LADWP** | **MSA rates** | *(blank)* | Active |
| TESTING ED | special rates | *(blank)* | Active |
| **GREEN · RED · YELLOW** | **General Rates** | *(blank)* | Active |
| Z_TEST_LIST_01 | Special Rates | *(blank)* | Active |

An earlier snapshot of the same screen — the two `SAMPLE_QUOTE/Screenshot 2026-03-09…png`
files beside quote OM-36229 — shows **15 lists**: the same names *without* GREEN, RED, YELLOW,
LADWP, SO CAL EDDISON, TESTING ED and Z_TEST_LIST_01. So between 2026-03-09 and the walkthrough,
TCG added **three "General Rates" lists named by colour**, an **LADWP list described as "MSA
rates"** (see the LADWP contract-item invoice in
[../accounting/invoice-packets-2026-04-worked-examples.md](../accounting/invoice-packets-2026-04-worked-examples.md)),
and a second, misspelt Edison list carrying a **project name and a different discount** — evidence
that price lists are being used to express *per-project* pricing as well as per-customer.

**What "Sales Discount %" does — and does not — do.** SO CAL EDISON carries 15%, but on its
Billing Codes tab the `Rate` column **equals** the `Default Rate` for almost every Edison-prefixed
code (`Edison 2 Man Crew DT` $248 → $248; `Edison Operator ST` $145 → $145; `Edison Oiler PT`
$250 → $250; `Edison 100 Ton` $185 → $157.25 is the one visibly discounted). The 15% is not
applied uniformly; per-code rates are set by hand.

**BIGGE's Billing Codes tab (2026-03-09 snapshot)** — the clearest example of a special-rate list,
default vs. list rate:

| Billing Code | Default Rate | BIGGE Rate |
| --- | ---: | ---: |
| 120 Ton Crane | $530.00 | $427.50 |
| 140 Ton Crane | $540.00 | $445.00 |
| 175 Ton Crane | $585.00 | $475.00 |
| 200 Ton Crane *(Inactive)* | $625.00 | $520.00 |
| 265 Ton All Terrain Crane | $655.00 | $585.00 |
| 40 Ton Hydraulic Crane | $285.00 | $240.00 |
| 60 Ton Crane | $395.00 | $355.00 |
| 75 Ton Crane | $425.00 | $375.00 |
| 90 Ton Crane | $445.00 | $395.00 |
| **Fuel & Insurance Surcharge** | **15.00%** | **8.00%** |

DUNKEL BROS (walkthrough snapshot) carries the same crane codes with 100 Ton at $450 → $400, 140
Ton $540 → $475, 200 Ton $625 → $520, 265 Ton AT $655 → $595, 60 Ton $395 → $355, 75 Ton $425 →
$375, 90 Ton $445 → $400 — and **no surcharge line**.

> **The surcharge now has five different stated values in the vault**, each from a real artefact:
> **15%** as the billing code's default rate (this screen); **8%** on BIGGE's list; **12%** on the
> FCC estimate template and on the paper ticket's T&C (§13); **10%** on the four March-2026
> invoices that carry it. Nothing says which governs, or whether the estimate template's 12% is
> the current default and the code's 15% is stale.

**The Customers screen (Maintain → Customers).** Fields, as shown for `Z_TEST_CUST_01`
(`ZTE001`): Customer Code · Name (two lines) · Address · City / State / Zip · Country · *Avalara
sent* (read-only flag) · Billing Contact 1 & 2 with E-Mail · Salesperson · Last Name First ·
P.O. Required · Insurance · **Price List** (dropdown) with **Expires** date · **Billable Work Order
Default** (`%AboveCost` + value) · Billing Terms (`NEW CUSTOMER` shown) · Discount Percent ·
Calculate Discount Date In / Calculate Due Date In (# of Days / Day of Month) · Status · Phone /
Fax / E-Mail · E-Mail Documents · WebSite · Taxable · Tax Exempt # · Federal Tax ID · Credit
Limit · Contact 1 & 2 Phone · Industry Code · Inter-Company · Entity Use Code. Tabs: Main ·
Comments · Contacts · Certifications · Notes · Tasks. Created by `bpetros` 3/13/2026.

**The Job Quotes screen (Enter → Quotes → Job Quotes).** Tabs: Main · Unit/People · Estimate ·
Tools/Rigging · Lift Info · Line Item · Tasks. Main-tab fields as shown: Quote No (`AUTO`) ·
Company · Dept (`OPERAT…`) · Yard · Customer / Job Site / Report To / Quoted To (each with a
**New** button) · WP / CP phones · E-Mail · Converted To Job · Job Date / Job Time (08:00 AM) ·
Ending Date / Ending Time (04:30 PM) · Final Date · Submitted Date · Award Date · Status
(`Pending`) · Lost Code · Lost Comments · **Certified Payroll** (`No`) · **Use Quote Detail
Amounts** ☑ · **Billing Type** (`Rental`) · **Footer** (`Standard Quote T…`, text *"I have
received and read this quotation and…"*) · **Terms & Conditions** (`Quote T&C`) · **Quote Min
$0.00 / Quote Max $2,794.40** · Salesperson / Taken By / Checked By · **Job Type** (`Hourly`) ·
Equipment Required · Comments · Description Of Work · In House · PO No · Industry Code.

> **`Quote Max` is the quote's computed total.** $2,794.40 is exactly the sum of the Estimate tab
> below ($1,780 + $550 + $165 + $299.40). The review log records TCG asking twice what Quote
> Min/Max are for and considering removing them, and
> [sales-reporting-workbooks.md](sales-reporting-workbooks.md) records that every KPI dashboard
> sums `QuoteMax` as "quote dollars". This screenshot shows why that works: FCC writes the total
> into `Quote Max`. What `Quote Min` holds ($0.00 here) is still unexplained.

**Unit/People tab, auto-populated for `Mobile Crane / 90 Ton Hydraulic Truck Crane`:** Tractor —
*Tractor - Semi* · Trailer — *Operator Load* · Employee — *Operator* · Employee — *Oiler*. This
is the estimate-template crew for the 90-ton documented in
[fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md), seen live.

**Estimate tab, auto-populated for the same crane:**

| Billing Code | Qty | Unit Meas | Rate | Amount | Comments |
| --- | ---: | --- | ---: | ---: | --- |
| 90 Ton Crane | 4.00 | Hours | $445.00 | $1,780.00 | |
| Operator Load | 5.00 | Hours | $110.00 | $550.00 | *5 hour minimum* |
| Travel Permit - 75 Ton and above | 1.00 | Each | $165.00 | $165.00 | *Subject to change* |
| Fuel & Insurance Surcharge | 1.00 | Each | **12.00%** | $299.40 | |

A `Price List` field sits above the grid (blank here); `Line Item` and `Sub-Item` columns are
present. The **Conv Job** button in the toolbar (highlighted in the walkthrough) is step 4.

**Schedule → Job, the "real" SCE job `OM55127`** (TEST database, 10/10/2025 09:00–16:30, status
`Transfer`, *Net 10*). Main tab: Job Number · Company · Yard · Department (`OPERATED &
MAINTAINED`) · Salesperson / Checked By / Taken By (all `Deitrick, Joe`) · PO Number
(`204480165, TD2357760`) · Status · Customer · Job Site · Report To · Ordered By · Description Of
Work (*"45ft pole swap and transformer"*) · Comments (*"Leave yard 630AM hook ready 9AM"*) ·
Equipment Required (*"190 Ton + RCS"*) · Job Date / To · Work Weekends ☑ · Date Flexible · Time
Flexible · Job End Date Unknown. **Related Information** panel: **Quote `OM-32716`** · PO(s)
*none* · Tool(s) *none* · Lift Info *present* · **Price List `SO CAL EDISON`** · Storage Item(s)
*none* · Latest Invoice 10/10/2025 · Invoice History 1 · Daily *none*. Created *Lopez, Lizette
9/22/2025*, modified *Petros, Brian 1/18/2026*. Left-hand tabs: Main · Parameters · Resources ·
Estimates · Storage · In-House Comments (badge 1) · Job-Related Certificates · E-Ticket Status
Report · Attachments (badge 1).

Its **Resources tab** is a complete real crane configuration, and it matches the shape
[../dispatch/crane-configurations.md](../dispatch/crane-configurations.md) describes exactly:

| Schedule Type | Type | Resource |
| --- | --- | --- |
| Mobile Crane | 275 Ton All Terrain Crane | **27501** |
| Employee | Operator | *(name)* |
| Employee | Oiler | *(name)* |
| Tractor | Tractor - Semi | AT24 |
| Trailer | **Operator Load** | **27501 OL** |
| Employee | **3rd Man** | *(name)* |
| Employee | **3rd Man** | *(name)* |
| Tractor | Tractor - Semi | AT29 |
| Trailer | **Support Load 1** | **27501.1** |
| Tractor | Tractor - Semi | AT14 |
| Trailer | **Support Load 2** | **27501.2** |

— three tractors, three trailers (`OL`, `.1`, `.2`), two 3rd Men, all on the same 09:00–16:30
window, all in `Transfer` status. Columns beyond Status: Start · End · Comments · Picked up ·
Returned to yard? · Insurance Amount · Expiration Date · Policy #.

**Enter → Purchase Orders and Maintain → Vendors** — the same screens the PO deck shows; written
up in [../vendors-agencies/purchase-orders-fcc/fcc-po-entry-walkthrough.md](../vendors-agencies/purchase-orders-fcc/fcc-po-entry-walkthrough.md).
Two details from this walkthrough's copies: the PO Lookup here is filtered to **FLEET** and
**SHOP** departments (`FL-16xx`, `SH-11..13`), and vendor `COA003` *Coastline Equipment*'s master
record shows the vendor fields (Vendor Code · Name · Address · Contact 1/2 · Last Name First ·
Taxable · Purch Disc % · Default Expense GL Account · Billing Terms `Net 30` · 1099 Type · Type ·
Tax ID · Account No · Comments tab · Contacts tab with Name / Work Phone / Address / Status /
Email / Cell / City / Position / Address Same As Vendor / Fax / State / Comments).

## 5. What TCG says about these screens — `FCC_MAINTAIN_CODES-BILLING (reviewed by TCG).pptx`

Every slide note that carries content, verbatim:

| Slide | TCG's note |
| --- | --- |
| 3 | **Taxable:** *"Not needed"* · **Billing Codes per Yard:** *"Need to have ability to have **separate Billing Codes per Yard**"* |
| 5 | *"This is the newer version/layout of the FCC Billing Codes"* |
| 6 | *"This is the newer version/layout of the FCC Price Lists"* |
| 7 | *"We don't use/need these **'Exceptions'**"* |
| 8 | **Billing Codes per Yard:** *"Need to have ability to have separate Billing Codes per Yard"* (repeated) |
| 9 | *"We don't use/need these **'Billing Costs'**"* |
| 10 | *"We don't use/need **'Taxable'**"* |
| 13 | *"\*\*\* NEW SECTION/FUNCTIONALITY \*\*\* In addition to these **'Lost Quote' status** we need **detailed information on 'Pending Quotes'** so we can follow-up and will eventually be marked as **'Won' or 'Lost'**"* |
| 14 | **Burden Codes** — quoted in full below |

### The yard question, answered

[billing-code-and-price-list.md](billing-code-and-price-list.md) ends on an unanswered question:

> *"Should we make billing code and price list specific to yards, or will it be same price for
> all yards"*

**TCG answers it twice on these slides: *"Need to have ability to have separate Billing Codes per
Yard."*** The slides say nothing about price lists per yard, so **only half the question is
answered**. The commission workbook shows FCC also scopes *billing costs* by yard (`Yards` is a
column on the Billing Costs tab — see
[quote-profit-forecast.md](quote-profit-forecast.md) §2), so yard-scoping is a pattern FCC
already supports on the cost side.

### Three FCC features TCG rejects

**`Taxable`** (twice), **`Exceptions`** and **`Billing Costs`**. The first two contradict
nothing; the third does. **`Billing Costs` is the entire input to FCC's Quote Profit Forecast
feature** — see [quote-profit-forecast.md](quote-profit-forecast.md). If TCG does not maintain
billing costs, forecast profit cannot be computed per line, which is consistent with
[quotations.md](quotations.md)'s punch-list item *"Remove `Gross Margin`"*. **The documents do
not say whether TCG rejected billing costs because it rejected profit forecasting, or the other
way round.** The same slide deck then asks for Burden Codes, which are also cost data — so the
rejection is not of costing in general.

### Burden Codes — a new ask

Slide 14, in full:

> "**Burden Codes:** Need these Burden Codes to **track overhead expenses per billable labor
> hour.**
>
> \*\*\* EXPECTED FUNCTIONALITY \*\*\* Need ability/functionality to **track the timing of when
> Burden Code(s) was changed along with the effective dates (with ability to backdate, if
> needed)**
>
> \*\*\* EXPECTED FUNCTIONALITY \*\*\* Being able to control/modify 'effective dates' is
> important for **financial reporting, since many financial activities happen *after* data is
> entered into the system.**
>
> \*\*\* EXPECTED FUNCTIONALITY \*\*\* Specifically with Burden Rates… financial reporting should
> have option to **change and/or filter by different Burden Rates.**"

**This is a requirement the vault holds nowhere.** Three distinct asks: burden per billable
labour hour; effective-dated burden rates with backdating; and reporting that can be re-run
against a chosen burden rate. The effective-dating pattern matches what the commission workbook
already does for commission plans (`CommissionStart` / `CommissionEnd` per row, keyed on invoice
date — [sales-commissions.md](sales-commissions.md) §4).

### Pending Quotes — a second new ask

Slide 13 asks for **detailed information on Pending Quotes**, alongside the existing Lost Quote
statuses, *"so we can follow-up and will eventually be marked as 'Won' or 'Lost'"*.

The FCC quote export in the KPI tracker shows those three states as real values —
`QuoteStatusCode` `WON` / `PEND` / `LOST`, with `LostQuoteCode` and `LostQuoteDesc` beside them
([sales-reporting-workbooks.md](sales-reporting-workbooks.md) §2). So the statuses exist; what
TCG is asking for is the **follow-up surface for the pending ones**. That is the same need the
Win-Back workbook and the HubSpot pipeline were built to fill by hand —
[hubspot-sales-playbook.md](hubspot-sales-playbook.md) §2.

## What the deck's screenshots show — read 2026-09-04

The 23 images inside `FCC_MAINTAIN_CODES-BILLING (reviewed by TCG).pptx` were extracted and read
on 2026-09-04. They are TCG's production configuration. The Price List screens (Main, Parts,
Billing Codes tabs) are already transcribed from the walkthrough in §4 and are not repeated;
what follows is the rest of the deck, paired with the §5 notes.

### The menu (slides 1, 4, 11, 13, 14)

`Maintain → Codes` has five entries, and the deck walks them in order: **Billing Codes · Billing
Codes - WPF · Billing Code Types · Lost Quote Codes · Burden Codes.** The first two are the same
data in the legacy and the modernised screen — TCG's slides 5–6 (*"newer version/layout"*) are
the WPF one.

### Billing Codes — legacy screen (slides 2–3)

A **Status** filter (`Active`) and tabs **Main · Price Lists · Taxable · Yard**. The Main tab is a
list of code cards, each a three-row block of fields:

| Row | Fields |
| --- | --- |
| 1 | **Description · Amt / Perc · Default Rate · Unit Meas · Credit To · GL Account · Auto Allocate ☐** |
| 2 | **Billing Type · Job Type · Status · Unit Type · Print Info · Taxable ☐** |
| 3 | **% Applied ☐ · Line Item · Default as Sub-Item ☐ · Avalara Tax ID · Operator Provided ☐** |

The crane codes visible, with their settings (all `Amount`, `Hours`, `Active`, `Auto Allocate`
ticked, `% Applied` ticked, `Taxable` / `Default as Sub-Item` / `Operator Provided` unticked):

| Description | Default Rate | Billing Type | Job Type | Credit To | Unit Type | GL Account |
| --- | ---: | --- | --- | --- | --- | --- |
| 200 Ton All Terrain Crane | $625.00 | Standard Crane | Operated | Mobile Crane | 200 Ton All Terrain Crane | `200INC` |
| 200 Ton Crawler Crane | $0.00 | Crawler Crane | NA | Mobile Crane | 200 Ton Crawler Crane | `200CRAWLERINC` |
| 22 Ton Hydraulic Crane | $175.00 | Standard Crane | Operated | Mobile Crane | **22 Ton Boom Truck** | `22INC` |
| 265 Ton All Terrain Crane | $655.00 | Standard Crane | Operated | Mobile Crane | 265 Ton All Terrain Crane | `265INC` |
| 275 Ton Crane | $665.00 | Standard Crane | Operated | Mobile Crane | 275 Ton All Terrain Crane | `275 TON INC` |
| 30 Ton Self Loader | $230.00 | **Self Loader** | Operated | **Self Loader** | 30 Ton Self Loader | `SL` |
| 330 Ton Crawler Crane | *(blank)* | Crawler Crane | Operated | Mobile Crane | 330 Ton Crawler Crane | *(blank)* |
| 350 Ton Crane | $710.00 | Standard Crane | Operated | Mobile Crane | *(blank)* | `350INC` |
| 360 Ton All Terrain Crane w/Luffer | $810.00 | Standard Crane | NA | Mobile Crane | 360 Ton All Terrain Crane | `360 TON INC` |
| 360 Ton Crane | $720.00 | Standard Crane | NA | Mobile Crane | 360 Ton All Terrain Crane | `360 TON INC` |

Three conventions the import template (§1) could not show: **`Credit To` is a schedule type**
(`Mobile Crane`, `Self Loader`); **`Unit Type` binds the code to a unit type**, which is what
lets the estimate template auto-populate the right code for the crane on the quote
([fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md)); and the **GL
Account is one income account per crane class, named `<tons>INC`** — the per-unit chart of
accounts seen in [../admin/fcc-nexgen-administration-and-security.md](../admin/fcc-nexgen-administration-and-security.md)
→ *GL Accounts*. `Job Type` is `Operated` or `NA` on every code shown; the 360-ton codes are `NA`
while the 200–350-ton ones are `Operated`, and the deck does not say why.

**Price Lists tab** for *275 TON CRANE* (Default Rate $665.00, Hours): **Price List · Description
· Discount % · Rate · Status** — `POLE CONTRACTOR` $595.00 · `PREFERRED 1` **$635.00** · `SHARED
CRANE` $580.00, all *Special Rates*, Active. This is the *per-code* view of the same data the
Price List screen shows *per-list*. (The live Mastec quote in the quotes deck bills this code at
**$628** on `PREFERRED 1` — neither $665 nor $635; see
[fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) → *Unit/People and Estimate*.)

**Taxable tab**: **State · Taxable** — empty. **Yard tab**: **Yard · UnitMeasure · Rate ·
Available for Yard(s) · % Applied** — **empty**. TCG's slide-3 note asks for *"the ability to have
separate Billing Codes per Yard"* **beside a tab that already provides a per-yard rate per
code**. The screen has the ability; TCG has never filled it in. Whether TCG means something
different by "separate billing codes per yard" (a separate *catalogue* per yard, rather than a
per-yard *rate* on one catalogue) is not stated anywhere in the deck.

### Billing Codes – WPF (slides 5–10)

The modernised screen: a left rail **Billing Codes · Price Lists · Yards · Billing Costs ·
Taxable** (the five panes the Admin Guide lists as separately permissible — see
[../admin/fcc-nexgen-administration-and-security.md](../admin/fcc-nexgen-administration-and-security.md)),
a filterable grid with *"Drag a column header and drop it here to group by that column"*, and a
**Data Form** on the right for the selected row.

**Billing Codes pane** (slide 5). Grid columns **Description · Billing Type · Avalara Tax ID ·
Operator Provided · Amt / Perc · Job Type · % Applied**. The Data Form for *275 Ton Crane*
enumerates the whole record: **Description\* · Billing Type** (`Standard Crane`) **· Avalara Tax
ID · Operator Provided ☐ · Amt / Perc** (`Amount`) **· Job Type** (`Operated`) **· % Applied ☑ ·
Default Rate** ($665.00) **· UM** (`Hours`) **· Status** (`Active`) **· Line Item · Credit To**
(`Mobile Crane`) **· Unit Type** (`275 Ton All Terrain Crane`) **· Default as Sub-Item ☐ · GL
Account** (`275 TON INC`) **· Auto Allocate ☑ · Taxable ☐ · Require Credit to Employee ☐**. The
last flag is new to the vault: a billing code can require that its revenue be credited to a named
employee, which is the hook a commission or crew-pay calculation would use; nothing in the deck
says TCG uses it.

The grid rows visible in this pane show two naming families the §3 catalogue does not carry:

- **LADWP contract-item codes**, named by the contract's item number — `107 LADWP Item 107 Group C
  Operator Portal…` (Billing Type *Double Time*), `109 LADWP Item 109 Op Portal ST`
  (*Mobilization*), `110 LADWP Item 110 Op Portal OT` (*Mobilization*), `111 LADWP Item 111
  Support Truck Driver wit…` (*Double Time*), `116 LADWP Item 116 Fuel Surcharge` (*Surcharge*).
  These are the codes behind the LADWP contract-item invoice in
  [../accounting/invoice-packets-2026-04-worked-examples.md](../accounting/invoice-packets-2026-04-worked-examples.md);
  a per-customer code family like SCE's *Edison …* set, but keyed to a public-agency price
  schedule. The Billing Types assigned to them (`Mobilization` for an operator portal-to-portal
  rate) look like what was nearest at hand rather than a taxonomy.
- **Rough-terrain cranes** as their own Billing Type: `110 Ton RT`, `130 Ton RT`, `150 ton RT` are
  *Rough Terrain Crane*, distinct from *Standard Crane* and *Crawler Crane*.

Also visible: `118' Crane` appears to be the one row with **% Applied unticked** — so on a quote carrying
that code the percentage surcharge would not apply to it — and `Job Type` is `NA` on most rows,
`Operated` on some, with no visible pattern.

**Price Lists pane** (slides 6–7) has two tabs, **Price Lists** and **Exceptions**. *Price Lists*
is the same 15-row register as §4's 2026-03-09 snapshot (`SHARED CRANE`, `SO CAL EDISON` and `WA
RASIC` with a blank discount, the rest `0.00`). ***Exceptions*** is the grid TCG says it does not
use: columns **Price List · List Discount % · Billing Description · Billing Type · Def Rate ·
List Rate · UM**, and a Data Form of **Price List\* · Billing Description\* · List Rate** (shown as
`$545.00` with the hint *"(def. $655.00 / Hours)"*) **· Status**. Every visible row belongs to
**`FAITH ELECTRIC`** or **`HW POWER`** — the two Inactive lists, rendered in red — with rates such
as 265 Ton AT $655 → $545, 90 Ton $445 → $365, 120 Ton $530 → $405, 140 Ton $540 → $425, 175
Ton $585 → $450, 200 Ton $625 → $475, 40 Ton Hydraulic $285 → $210, 60 Ton $395 → $315, 75 Ton
$425 → $350, Support Load $165 → $125, Travel Permit $70 → $55, Travel Permit with Runner
Required $300 → $155, and **Operator Load $110 → $500** (almost certainly a data-entry error on a
dead list).

> **What an "Exception" is, and the tension with the note.** The Data Form shows an Exception to
> be *one billing code's list rate on one price list* — the same record the legacy screen shows
> on its Price Lists tab and §4 tabulates for BIGGE and DUNKEL BROS. The deck does not say whether
> the WPF *Exceptions* tab is simply the new name for those per-list rates (in which case TCG uses
> them on every active list and the *"don't use/need"* note is about the *tab*, not the data), or
> a separate override layer. Only inactive lists are visible in the capture, which is consistent
> with either reading. **Do not read slide 7 as TCG rejecting per-list rates.**

**Yards pane** (slide 8): an entry strip **Billing Description\* · Yard\* · Rate · Available for
Yard(s) ☐ · % Applied ☐** over a grid **Alert · Billing Description · Yard · Billing Type ·
Default Rate · UM · Rate · Available for Yard(s) · % Applied** — **empty**, the WPF face of the
legacy Yard tab. TCG's note (per-yard billing codes, repeated) is beside it; same observation as
above.

**Billing Costs pane** (slide 9): grid **Billing Description · UM** and a **Cost** group
**Equipment · Materials · Labor · Direct Cost · Union · WC · Labor Burden …** — **empty**. The Data
Form is the full cost model: *Select Billing Code Options* (**Billing Description\* · UM · Allow
Override Costs ☐**), *Define Billing Costs – Hourly* (**Equipment · Materials · Labor · Direct
Cost** (computed) **· Union · Workers Compensation (WC) · Labor Burden · Material Burden ·
Indirect Cost** (computed) **· Total Cost** (computed)), and ***Select Yard(s) & Effective Dates***
(**Yard(s)** `All Yards` **· Effective Start Date\* · Effective End Date\***). This is the input
side of [quote-profit-forecast.md](quote-profit-forecast.md) §2, seen empty — which is why the
quote's Profit Forecast tab in the quotes deck reports 100% margin on every line.

> Note what this pane already has and TCG asks for elsewhere on the same deck: **yard scope and
> effective-dated rows**. The Burden Codes note (slide 14) asks for effective dates with
> backdating on burden rates; FCC's billing-cost record has exactly that shape, and its burden
> code record (below) does not. The deck does not connect the two.

**Taxable pane** (slide 10): entry strip **Billing Description\* · State\* · Taxable ☐**, grid
**Billing Description · State · Billing Type · Taxable** — empty. TCG: *"don't use/need"*.

### Billing Code Types (slide 12)

The full lookup — **Code · Description · Status**, 37 rows, **all Active**. This is the `Billing
Type` dropdown on every code above, and it is the first complete copy in the vault:

| Code | Description | | Code | Description |
| --- | --- | --- | --- | --- |
| `BR` | Bare Rental | | `OPL` | Operator Load |
| `CO` | Certified Operator | | `OT` | Overtime |
| `COMP` | Compliance Paperwork | | `P&T` | Permits and Traffic Control |
| `CWT` | Counter Weight Truck | | `PI` | Pilot Car |
| `CR` | Crawler Crane | | `PW` | Prevailing Wage |
| `CRW` | Crew Time | | `PA` | Price Adjustment |
| `CUR` | Curfew Stand By Time | | `RCS` | RCS |
| `DEMOB` | DeMobilization | | `RIGGERS` | Riggers |
| `DBL` | Double Time | | `RT` | Rough Terrain Crane |
| `FAA` | FAA Permit | | `SL` | Self Loader |
| `SUR` | Fuel & Insurance Surcharge | | `SPE EQUIP` | Special Equipment |
| `TPL` | Holiday Triple Time | | `ST` | Standard Crane |
| `LT` | Lift Plan | | `STORAGE` | Storage |
| `LBP` | Long Boom Pay | | `SUB` | Subsistence |
| `LSUB` | Long Subsistence | | `SUPP` | Support Load |
| `MOB` | Mobilization | | `SURCHARGE` | Surcharge |
| `NOT` | Notam | | `TP` | Travel Permit |
| `MV` | On-site Move | | `TPR` | Travel Permit with Runner |
| | | | `TRUCKING` | Trucking |

Observations, not rules: the list mixes **equipment classes** (`ST`, `CR`, `RT`, `SL`, `CWT`),
**labour pay types** (`OT`, `DBL`, `TPL`, `PW`, `CO`, `CRW`, `CUR`), **mob/demob and logistics**
(`MOB`, `DEMOB`, `OPL`, `SUPP`, `MV`, `PI`, `TP`, `TPR`, `TRUCKING`), **surcharges and
adjustments** (`SUR` *and* `SURCHARGE`, `PA`), **allowances** (`SUB`, `LSUB`, `LBP`),
**compliance** (`COMP`, `FAA`, `NOT`, `LT`, `P&T`) and **other revenue** (`BR`, `STORAGE`,
`SPE EQUIP`, `RCS`, `RIGGERS`). Two codes overlap in meaning (`SUR` vs `SURCHARGE`). What `RCS`
stands for is not on the screen; the real SCE job's *Equipment Required* reads *"190 Ton + RCS"*
(§4), so it is equipment. `CUR` *Curfew Stand By Time* is the type on the estimate templates'
*Crew Time* line ([fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md)).
This vocabulary is the `Billing Type` the import template's `Billing Types` sheet (§1) was meant
to load.

### Lost Quote Codes (slide 13)

**Code · Reason · Status**, eight rows:

| Code | Reason | Status |
| --- | --- | --- |
| `AVL` | Availibility *(sic)* | Active |
| `CAN` | Cancelled | Active |
| `LOST` | Lost - Price too High | Active |
| `LST` | Lost - Customer Not Awarded | Active |
| `NR` | Non-Responsive | Active |
| `SUB` | Subbed | Active |
| `UN` | Union | Inactive |
| `WN` | Won | Inactive |

These are the `LostQuoteCode` values the KPI export carries
([sales-reporting-workbooks.md](sales-reporting-workbooks.md) §2), which that page could only
observe as codes. Six live reasons; `Won` as a *lost* code has been retired. TCG's slide-13 note
(*Pending Quotes* follow-up) is written on this screen — and the quotes deck shows FCC's Quote
Status list already has **`FW1` Follow Up One** and **`FW2` Follow Up Two** beside `PEND`, with
`LOST` the only status that *requires* one of these codes
([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) → *Job Types and Quote Status codes*).
Whether TCG knows of or uses the two follow-up statuses is not stated.

### Burden Codes (slide 14)

A master–detail screen: header **Burden Code** (`Standard Burden Code`) with a **View** filter
(`Active`); fields **Code `STD` · Description `Standard Burden Code` · Status `Active`**; a detail
grid **Line Description · Type · Amount** with one row — *Standard Burden Code* · **`Hours
Worked`** (a dropdown) · **`100.000`**. Toolbar **New · Add Line · Delete · Del Line**. It also
has its own file-links window (**Maintain File Links – Burden Codes**, `Burden-STD`). **There is
no effective-date, yard or history field anywhere on it** — which is precisely the gap TCG's
three *expected functionality* paragraphs describe. What `100.000` means (a rate per hour, a
percentage, an index) is not shown; the only other Type values are not visible because the
dropdown is closed.

### Where the screenshots and the notes disagree

- **Per-yard billing codes** — asked for twice, beside two screens (legacy *Yard* tab, WPF
  *Yards* pane) that already hold a per-yard rate per code. Either the ask is for something
  else, or the ability was never noticed. The deck cannot tell which.
- **Exceptions** — rejected, but the screen shows an Exception to be a per-list rate, which TCG
  relies on for every active price list. See the boxed note above.
- **Billing Costs** — rejected, yet the Billing Costs record already has the yard scope and
  effective dating the Burden Codes note asks to have added.
- **Taxable** — consistent; both Taxable screens are empty.

## Source

- `1.0.2_FCC-RESOURCES-GUIDES/FCC-IMPORT-Templates/Billing Data v.01.26.xlsx` — 11 sheets,
  per-sheet row dump. **Bulk grid rows were not copied**: sheet 1 truncated at 4,000 rows in
  conversion and is empty of data in any case; sheets 4 and 10 are empty templates. Column
  contracts, worked examples, the name catalogue and the validation vocabularies are transcribed
  in full above.
- `1.0.1_BUSINESS-REQUIREMENTS/TCG_PRICE_LISTS/Price Lists Process in FCC-NexGen.docx` — pandoc
  gfm; 30 embedded screenshots, extracted from the `.docx` and **read visually on 2026-09-04** — see §4. Navigation paths,
  tab names and captions only.
- `1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_MAINTAIN_CODES-BILLING (reviewed by TCG).pptx`
  — 14 slides; the screenshots carry no extractable text, so the speaker notes in §5 are the whole
  of the *text*. The **23 embedded screenshots were extracted and read on 2026-09-04** — see *What
  the deck's screenshots show*.

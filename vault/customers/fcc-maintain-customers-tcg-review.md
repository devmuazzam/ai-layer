---
title: FCC "Maintain Customers" screens, reviewed by TCG
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_MAINTAIN_CUSTOMERS (reviewed by TCG).pptx (notes and the 26 embedded screenshots, read 2026-09-04)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: [customers/customer.md, customers/customer-and-job-sites.md]
jira: []
tags: [module/customers, kind/source, requirements, open-questions, certifications, pricing]
entities: []
---

# FCC "Maintain Customers" screens, reviewed by TCG

**What this is.** A 19-slide deck of screenshots of FCC / NexGen FMS's **Maintain Customers**
screens, annotated by TCG. Each slide is a picture of one FCC tab or dialog with TCG's comment
beside it: *not needed*, *need ability to…*, or a note about how the equivalent should work in the
new ERP. It sits in `1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/` alongside the same treatment
of other FCC menus. The filename itself says "(reviewed by TCG)".

**Eight of the nineteen slides carry no text** — they are screenshots with no annotation, and the
screenshots themselves did not survive text conversion. The first part of this page records TCG's
comments; the screens they refer to were read from the images on 2026-09-04 and are described in
*What the deck's screenshots show* at the end. For the underlying data model
those screens sit on, see
[fcc-legacy-customer-data-model.md](fcc-legacy-customer-data-model.md).

**These are asks, not decisions.** Nothing here has been adjudicated. The deck says what TCG
wants carried forward and what it wants dropped; it does not say who decided, or when.

> **Bearing on the [customers-INDEX.md](customers-INDEX.md) conflict stub.** Slides 11 and 12
> speak directly to the two questions
> [customer-and-job-sites.md](customer-and-job-sites.md) leaves open — *"need to verify from FCC
> if its customer contact or seperate job site contact"* and the same question for certificates.
> The deck's answer to both is **both, at TCG's option** (slide 11) and **as documents per job
> site** (slide 12). Quoted in full below. **This does not resolve the stub** — the deck is one
> more unverified source, and its verdict is unchanged.

## What TCG does not want carried across

Verbatim from slides 2 and 15.

| FCC feature | TCG comment |
| --- | --- |
| Avalara (tax info) | "not needed" (said twice — slides 2 and 15) |
| Insurance | "not needed" |
| Billable WO | "not needed" |
| Entity Use Code | "Not needed" |

`Insurance` and `EntityUseCode` are both columns the migration extract already marks
`IncludeInReport = 0`, and `AvalaraSent` likewise — the deck and the extract scripts agree.

> **This contradicts the vault.** [customer-and-job-sites.md](customer-and-job-sites.md) item 5
> asks for the opposite: *"Insurance - if checked -- show expiry / contract number"*. And the ERP
> has already built it — `Customer.insurance`, `insuranceExpiryDate` and `insuranceContractNumber`
> all exist in `apps/api/prisma/schema.prisma`. The deck is undated relative to that punch list
> (which carries `updated: 2026-06-12`), so which came later is unknown from these sources.

## Customer status

Slide 2 lists the status values TCG wants:

- Active
- Inactive
- Prospect
- **On Hold**

FCC itself has only three (`A` = Active, `T` = Inactive, `P` = Prospect). **On Hold is a fourth
value TCG is adding.** The ERP's `CustomerStatus` enum is `DRAFT | ACTIVE | INACTIVE` — it has
neither Prospect nor On Hold. The deck does not say what On Hold means operationally or what it
blocks.

## Customer comments, notes and pop-ups

Slides 3 and 6 carry the same text:

> "**Customer Comments/Notes:** Need ability to enter comments/notes for each customer.
> Need ability to enable "pop-up" notifications per customer… that would (for example) pop-up when
> user schedules/opens job for that customer, when billing interacts with billing screens, etc."

This is TCG asking to keep FCC's `FMS_CUSTOMER_NOTES` behaviour, which is exactly a pop-up plus a
scope (`DisplayMessage` = All / Invoices / Jobs / Order Entry / Quotes / Work Orders). The two
examples the deck gives — scheduling or opening a job, and billing screens — map onto two of
those six codes. The deck does **not** say whether the ERP should offer the same six scopes, a
different set, or an always-on pop-up.

The ERP currently stores customer notes as `Customer.comments String[]` — plain strings with no
scope and no pop-up mechanism. See
[fcc-legacy-customer-data-model.md](fcc-legacy-customer-data-model.md) → *Notes*.

## Customer tasks

Slide 6, immediately after the notes paragraph:

> "**Customer Tasks:** Need ability to enter tasks for each customer."

> **This contradicts the vault.** [customer-and-job-sites.md](customer-and-job-sites.md) item 1
> under *Customer* is "Remove tasks from customers", and
> [customer.md](customer.md) is silent on tasks. One source asks for the feature and another asks
> to remove it. Neither is verified and neither is dated against the other.

## Customer documents, and certifications as documents

Slides 5 and 7:

> "**Customer Documents:** Contracts/documents uploaded to customer profile"

> "**Customer Certifications:** Could be part of the "Customer Documents" module to upload
> certification documents."

Note the hedge — "**Could** be part of". The deck proposes folding certifications into a documents
module rather than modelling them as their own entity; it does not state that as settled.

> **This contradicts the vault.** [customer.md](customer.md)'s bullet list contains a bare
> "Remove certifricates" [sic]. The deck wants certification *documents* kept, under a documents
> module. Whether "remove certificates" meant remove the structured certificate entity (leaving
> documents) or remove the concept entirely is not stated anywhere.

## Job sites

Slide 9, marked in the deck as new:

> "**MSHA:** https://www.msha.gov/ — For Customer Job Sites associated with (MSHA) Mine Safety and
> Health Administration"
>
> "*** NEW SECTION/FUNCTIONALITY *** **Job Site Requirements:** Custom fields related to each Job
> Site that would allow entering information per Job Site of things that are required and/or
> comments/reminders."

MSHA is not new — `FMS_CUSTOMER_LOCATIONS.MSHA` already exists and is in the migration export.
**Job Site Requirements is** — the deck flags it explicitly as new section/functionality: per-job-site
custom fields for requirements, comments and reminders. The deck does not say what the field
types are, who defines them, or whether they are per-tenant or per-site.

Slide 10:

> "**Customer Job Site Documents:** Contracts/documents uploaded to customer profile (per Job
> Site)"

Slide 12:

> "**Customer "Job Site" Certifications:** Could be part of the "Customer Job Site Documents"
> specific to each Job Site."

Again "Could be" — a proposal, not a decision.

## Job site contacts — the answer to the standing question

Slide 11 is the only slide headed **"*** EXPECTED FUNCTIONALITY ***"**:

> "**Customer Contacts: / Job Site Contacts:** Customer Contacts can be enabled to be associated
> with every Job Site. Also, can have Contacts specific to each Job Site."

So TCG's stated expectation is **both mechanisms**: a customer contact can be flagged to apply to
every job site, *and* a job site can have contacts of its own. That is a superset of what FCC does
— FCC's `FMS_CUSTOMER_LOCATIONS` points at `FMS_CUSTOMER_CONTACTS` by id for its Ordered-By and
Report-To roles and has no job-site-only contact table.

The ERP has neither half: `CustomerContact` hangs off `Customer` only, and `JobSite` has no
contact relation at all. The deck does not say how a contact "enabled for every job site" should
be represented, nor what happens to a site-specific contact when the site is archived.

## Parts pricing

Slide 18:

> "**Price List (Parts):** Currently not using but need ability to have pricing for Parts per
> Customer."

This is the deck confirming what the extract shows: `FMS_PARTS_PRICE_LIST_MASTER` has 16 rows, all
described as "Special Rates" with no discount recorded, and TCG says it is not in use. The ask is
forward-looking — per-customer parts pricing in the new ERP. See
[quotations/billing-code-and-price-list.md](../quotations/billing-code-and-price-list.md) for the
crane-rate side, which is a different mechanism.

## What the deck's screenshots show — read 2026-09-04

The 26 images inside the deck were extracted and read on 2026-09-04. They are TCG's production
NexGen, walked through one real customer — **Southern California Edison, code `SOU050`** — and its
job sites. Only what the annotations above did not already give is recorded. The Contacts tabs
show real people's names and phone numbers; **none are copied**. Tax IDs and credit fields on the
customer record were blank or are not reproduced.

### The menu and the customer record (slides 1–7)

`Maintain → Customers` has five entries: **Customers · Customer Job Sites · Industry Codes ·
Avalara Entity Use Code · Price List** — and the deck walks all five in that order. The Customers
toolbar carries **New Cust · Del Cust · First / Previous / Next / Last · Job Sites · Add Site ·
Refresh · Save Layout · Save · Print · Close**, so job sites are reached from the customer
toolbar as well as from the menu.

**Main tab** (slide 2). The full field list is already transcribed from the price-list
walkthrough in [../quotations/fcc-billing-data-and-price-lists.md](../quotations/fcc-billing-data-and-price-lists.md)
§4 (*The Customers screen*). What this screenshot adds is the values on a real, long-standing
customer rather than a test one:

- Customer selector with **Name / Code** radio buttons and a **Status** filter (`All`).
- **Customer Code `SOU050`** — with `MAS005` (Mastec, in the quotes deck) and `ZTE001` (the test
  customer): the convention is **first three letters of the name + a three-digit sequence**.
- **Status `Active`** — the dropdown is not opened, so the screenshot does not show whether
  FCC's list is the three values the extract has (`A / T / P`) or anything else. TCG's four-value
  list on the same slide (Active · Inactive · Prospect · On Hold) is therefore an ask written
  beside a closed dropdown, not a transcription of it.
- **Industry Code `Utility`** · **Price List `SO CAL E…`** with **Expires `00/00/0000`** ·
  **Billing Terms `Net 10`** · **Calculate Due Date In → # of Days `10`** · Discount Percent and
  discount-date fields blank · **Billable Work Order Default `%AboveCost` 0.00**.
- Checkboxes all **unticked**: Last Name First · P.O. Required · Insurance · E-Mail Documents ·
  Taxable · Inter-Company; **Avalara sent** greyed and unticked. Credit Limit `$0.00`. Billing
  Contact 1 / 2 and Salesperson **blank** — on a customer with dozens of contacts.
- Created by `joes` 10/26/2021; last modified by user **`fcc`** on 11/4/2025 — the vendor's own
  login touched the record.

So on TCG's biggest utility account the fields TCG marks *not needed* (Avalara, Insurance,
Billable WO, Entity Use Code) are all empty or at their defaults, which is consistent with the
ask; the screenshot does not show them in use anywhere.

**Comments tab** (slide 3): a single free-text box, empty for SCE. **Notes tab** (slide 6): a
grid **Pop-Up Message · Display Message In · Comments**, also empty for SCE. TCG's
comments/notes/pop-up paragraph is written beside *both* — the ask is for what the Notes grid
already models (message + display scope), and the quotes deck shows the pop-up firing for a
different customer ([../quotations/fcc-nexgen-quote-entry.md](../quotations/fcc-nexgen-quote-entry.md)
→ *The customer pop-up*). `Display Message In` is the on-screen name of the extract's
`DisplayMessage` scope column.

**Contacts tab** (slide 4): a `View` filter (`All`) over a four-row header — **Name · Work Phone ·
Address · Status** / **Email Address · Cell Phone · City · Salesperson** / **Ordered By/Report To
· Work Fax · State/Prov · Position** / **Address Same As Customer ☐ · Comments**. Every visible
SCE contact has **Ordered By/Report To = `Both`**, State `CA`, Status `Active`, and only a cell
phone. The `Both` value is the default a new contact gets (the Atom guide capture in the quote
page says the same). **Salesperson is a per-contact field**, not only a per-customer one.

**Certifications tab** (slide 5): **Unit/Employee · Certificate · Description**, empty. **Tasks
tab** (slide 6): **Complete · Priority · Type · Title · Due · Remind · Assignee · Assigner**,
empty — the same task grid a quote carries.

**Customer Documents** (slide 7): the lightning-bolt icon opens **Maintain File Links – Customer**
(`Customer-SOU050`): **File Name · Comments · Created By · Modified By / Created Date · Modified
Date**. Empty for SCE — so *"Contracts/documents uploaded to customer profile"* describes what
the window is for, not what is in it.

### Customer Job Sites (slides 8–12)

A separate window with its own toolbar (**Add · Delete · … · Refresh · Map · Save Layout**) and
tabs **Main · Contacts · Certifications**; a **Job Site Status** filter (`Active`) sits above the
list.

**The site list** (slide 9) — columns **Job Site · Address · City · Ordered By · Phone**. For SCE
every visible site is named **`# <9-digit number>, TD<7-digit number>`** (e.g. `# 204007344,
TD1884803`) — **the customer's PO number and TD (work-order) number are used as the job-site
name**, one site per Edison work order, each at a different street address across Long Beach,
Yucaipa, Riverside, Tustin, Santa Ana and Seal Beach. Every row's Ordered By is the same SCE
person. This is the convention behind the `PO Number` `204480165, TD2357760` on the real SCE job
in [../quotations/fcc-billing-data-and-price-lists.md](../quotations/fcc-billing-data-and-price-lists.md)
§4, and it means SCE's "job sites" in FCC are **per-order, not per-location** — a fact that bears
on any migration that assumes a job site is a reusable place.

**The site detail** (slide 9), fields not in the vault's model page: left column **Job Site ·
Address (2 lines) · City · State · Zip · County** (dropdown) **· Phone / Ext · Fax · Country ·
Taxable ☐** (+ tax-code dropdown) **· Directions · Validation Status** (read-only) with a
**`ValidateAddress`** button **· Address Unknown ☐**; right column **Status `Active` · MSHA ☐ ·
Ordered By** (dropdown — showing a bare numeric id, `2937`, rather than a name) with **WP · CP ·
E-Mail · Report To** (dropdown, a name) with **WP · CP · E-Mail · Alternate Phone · Description ·
Email Invoice** (`Customer Only`) **· Entity Use Code**. Zip is blank and Validation Status empty
on this site — address validation exists but was not run.

Two of these are new to the vault: **`Email Invoice`** as a per-site dropdown (value `Customer
Only`; the other options are not shown), and **address validation** (`Validation Status` +
`ValidateAddress`, and `Address Unknown` as an explicit opt-out). TCG's slide-9 notes (MSHA;
*Job Site Requirements* as new) sit beside this screen; the **MSHA checkbox is unticked** on
the SCE site.

**Job-site documents** (slide 10): **Maintain File Links – Customer Job Site** has one column the
customer-level window does not — **`Include on Job \ Quote`** — between File Name and Comments.
So a site document can be flagged to travel onto every job or quote at that site, the same
mechanism the quote's file links have as `Include On Job`.

**Job-site Contacts** (slide 11): a **Contacts Status** filter (`All`) and the **identical
four-row grid** to the customer's Contacts tab — and, for the SCE site shown, **the same
contacts in the same order** as the customer tab. The screenshot cannot show whether these rows
are the customer's contacts displayed at the site or site-level copies; TCG's *expected
functionality* note (customer contacts enabled for every site, plus site-specific ones) is
written beside it. `Ordered By/Report To` is again `Both` on every row.

**Job-site Certifications** (slide 12): **Unit/Employee · Unit/Employee Certification ·
Unit/Employee Description**, empty.

### Industry Codes (slides 13–14)

Grid **Industry Code · Description · Created By · Created Date · Modified By · Modified Date ·
Status**; 33 rows, all Active, the same list
[fcc-legacy-customer-data-model.md](fcc-legacy-customer-data-model.md) transcribes from the
extract (including `GC` General Contractor and `LS` Landscape, created by `joes` in 9/2025, and
the 10/27/2025 batch by `bpetros`). Nothing new; confirms the extract and shows the list is
user-maintained (Created By / Modified By are ordinary user logins).

### Avalara Entity Use Code (slide 15)

A two-column grid **Code · Description** — **empty**. TCG's *"not needed"* on this slide is
against a table with no rows.

### Price List (slides 16–19)

Toolbar **Add List · Del List · Copy List · First … · Refresh · Save Layout · Save · Print ·
Close** — **Copy List** exists, so a new customer list can be cloned from an existing one; no
text source mentions it.

**Main tab** (slide 17): the same **15 lists** as the 2026-03-09 snapshot already tabulated in
[../quotations/fcc-billing-data-and-price-lists.md](../quotations/fcc-billing-data-and-price-lists.md)
§4 — BIGGE through WA RASIC, three Inactive — and here **SO CAL EDISON's Sales Discount % is
blank**, not the `15.00` the later walkthrough screenshot shows. So the 15% was entered between
these two captures; the 7 lists that appear only in the walkthrough (GREEN/RED/YELLOW, LADWP,
SO CAL EDDISON, TESTING ED, Z_TEST_LIST_01) are absent here too.

**Parts tab** (slide 18): header **Price List: SO CAL EDISON · Description: Special Rates ·
Discount: %**; grid **Part No · Company · Selling Price New · Retail Price New · Status** /
**Description · Selling Price Used · Retail Price Used** — new-vs-used and selling-vs-retail
prices per part, per list. **Empty**, matching TCG's *"Currently not using"*.

**Billing Codes tab** (slide 19), for SO CAL EDISON: 28 rows, all but one named **`Edison …`**.
The rates are already sampled in the billing page §4; what the full list shows is the **shape of
a customer-specific code family**: a labour matrix of **role × pay type** — *Edison Operator /
Oiler / Rigger / Truck Driver* each in **ST · OT · PT**, *Edison 1 Man Labor Only* in **DT · OT ·
ST**, *Edison 2 Man Crew* and *3 man Crew* in **DT · OT · ST** — plus crane classes (*Edison 40
Ton · 90 Ton · 100 Ton*), *Edison Support Vehicles Counterweight Load* and *Support Vehicles
Truck & Trailer*, two **Inactive rows shown in red** (*Edison Miscpass through* $0.00 → $1.10;
*Edison Permit and Traffic Control %* 1.10% → 1.10%), and one non-Edison code, *Permit & Traffic
Control Services*, with no rate. `PT` beside `ST/OT/DT` is a pay type the vault has not seen
elsewhere; the screen does not say what it stands for. For every active Edison row **Rate equals
Default Rate** — the customer's pricing lives in the codes themselves, and the list adds nothing
on top.

### Where the screenshots and the notes disagree

- **Customer status**: the note lists four values; the screen shows one selected value and a
  closed dropdown. Nothing on the slides shows `On Hold` exists in FCC.
- **Contacts on job sites**: the note describes two mechanisms; the screen shows one grid whose
  rows are indistinguishable from the customer's.
- **Not needed** items (Avalara, Insurance, Billable WO, Entity Use Code): consistent — all
  unused on the customer shown.
- Everything TCG asks to *keep* — comments, notes with pop-ups, tasks, documents at customer and
  site level, certifications — **already exists as a tab or window in FCC and is empty for this
  customer**. The deck is asking for the containers, not reporting their contents.

## Source

`1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_MAINTAIN_CUSTOMERS (reviewed by TCG).pptx` —
19 slides, converted by per-slide text extraction. Slides 1, 4, 8, 13, 14, 16, 17 and 19 produced
no text: they are FCC screenshots with no annotation. The **26 embedded screenshots were
extracted and read on 2026-09-04** — see *What the deck's screenshots show*; contact names and
phone numbers on the Contacts tabs were not copied. Slides 3
and 6 duplicate the same comments/notes paragraph; slides 2 and 15 both say Avalara is not needed.

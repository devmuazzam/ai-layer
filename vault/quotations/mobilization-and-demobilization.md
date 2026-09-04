---
title: Mobilization & Demobilization
source: confluence/TCG/Mobilization & Demobilization; extended 2026-09-04 with shared-folder/Project-Repository-2026-09-04 — quote OM-36229, the FCC Billing Data import template, and the FCC NexGen Sales/Quotes user guides
migrated: 2026-08-10
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/assets, module/customers, module/projects-jobs, module/quotations, kind/reference, mob-demob, time-tracking, yards]
entities: [mob-demob, quotation, asset, customer, job, field-ticket, build-up, fcc, job-site, yard]
---

> **See also (editorial, added 2026-09-03):** this document describes the bundle as it appears
> on a quote. The layer above it — where the bundle *comes from* — is
> [fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md): in FCC the
> mob/demob line-up is a stored estimate template on the crane, selected by **Job Type**
> (`Hourly w/ Mob` vs `Hourly`), and `Sub-Item` is a generic per-line visibility flag rather
> than a mob/demob-only device — which qualifies **FR-8** below.

## **Mobilization & Demobilization**

### **1. Executive Summary**

* **Mobilization** is the bundled cost of everything it takes to get a crane to a job site and ready to work shown to the [[customers/customers-INDEX|customer]] as a single price.
* **Demobilization** is the bundled cost of everything it takes to pack up and leave once the job is done  also shown as a single price.

* Together, they let the business hide multiple small internal costs behind two clean, simple numbers on a customer's quote, instead of listing 6-7 confusing line items.

This document outlines the current-state process as it exists in FCC today, and the target-state requirements for the new ERP, including the field-side time-capture functionality needed to support billing verification going forward.

## Pain Point 

Today, FCC has a **pricing layer** (Mobilisation/Demobilization bundling on the quote) but no **verification layer**  there is nothing in the system that captures what actually happened in the field and checks it against what was quoted.

The missing layer specifically consists of:

1. **No structured field-time capture.** There is no confirmed mechanism today for a crew to log actual buildup/breakdown time in a way that's tied back to the original quote.
2. **No comparison mechanism.** Even if actual time were captured, there's no system-level process to check it against the quoted Mobilization/Demobilization figure and flag a gap.
3. **No connection between Field Ticketing and Invoicing for this specific purpose.** The Estimate already drives the Invoice, but there's no confirmed path for actual-vs-quoted discrepancies to automatically influence what gets billed.

## **2. Current State (As-Is) in FCC Today**

1. Mobilization and Demobilization are configured on the Estimate tab of a quote.
2. Mobilization is represented as a single line item with an expandable dropdown of sub-items (e.g., travel time, yard preparation, crane setup).
3. Each sub-item has a checkbox; toggling it live-recalculates the parent Mobilization total.
4. Crane/hook working hours are tracked as a separate, independent line item — not bundled into Mobilization or Demobilization.
5. Demobilization uses the same dropdown/checkbox structure as Mobilization, in reverse — covering breakdown, loading, and return travel.
6. When a quote is generated for the customer, all sub-items are automatically collapsed. The customer sees only two final numbers: "Mobilization" and "Demobilization." Sub-item detail is never shown externally.
7. A worked example was confirmed directly in the system: a 265-ton all-terrain crane quote with Mobilization priced at $3,500, and 40 hours of crane time quoted separately for a one-week job.

## **Requirements for New ERP ( Client requirement )** 

#### **3. Quotation / Estimating Module**

* **FR-1:** Mobilization and Demobilization shall each exist as parent line items on the quote's Estimate tab, each containing multiple sub-items.
* **FR-2:** Each sub-item shall have a checkbox toggle; enabling or disabling a sub-item shall live-recalculate the parent total.

**FR-3:** Mobilization shall be scoped to cover: 

* * drive time from the yard,
  * gearing up
  *  travel to the site,
  * crane setup time, ending the moment the crane begins working.
  

**FR-4:** Demobilization shall be scoped to cover: 

* * crane breakdown
  * loading counterweight/trailers
  * and return travel, starting the moment the crane finishes working.
  

* **FR-5:** Crane/hook working time shall be billed as its own separate line item (not bundled into Mobilisation or Demobilisation), based on total hours worked.
* **FR-6:** The customer-facing quote/PDF shall display only the Mobilization and Demobilization totals  sub-items shall never be shown to the customer.
* **FR-7:** The internal/staff-facing view shall retain full visibility of all sub-items and their individual amounts, for later billing verification.
* **FR-8:** This bundling behavior is confirmed as a special case  no other billing categories currently require this pattern

## **Field Ticketing / Mobile App and Relationship to Quotation**  

**REQ-1:** When a job is tagged for mob/demob billing at the [[quotations/quotations-INDEX|quotation]] stage, the field ticketing app shall not automatically carry over or pre-populate the quoted build-up time as actual time worked.

**REQ-2:** Field crews shall be required to independently log the actual buildup/breakdown time on every job, regardless of how the job was originally quoted (hourly vs. mob/demob).

**REQ-3:** The system shall retain both the quoted mobilization figure and the actual logged time as separate data points, so they can be cross-referenced against each other during billing review.

**REQ-4:** This separation is required specifically to catch discrepancies between estimated and actual time (e.g., a job estimated at 3 hours build-up that actually takes 6 hours due to traffic or site conditions).

**REQ-5:** The system shall support background geo-location tracking of arrival and departure at the job site, to provide an independent, automatic data point that can validate the actual drive/build-up time logged by the crew.

---

## Added 2026-09-04 — what the contract, the billing codes and the vendor manual say

*Three sources from the Project Repository drop bear on this page. None contradicts it; each fills
in a layer it does not have.*

### The customer-facing definition of mob/demob

**Every TCG quote carries its own scope definition**, and it is narrower than FR-3 and FR-4 above.
From the Terms and Conditions of quote **OM-36229** (2026-03-08), and identically on OM-35140:

> **Mobilization and Demobilization**
> *"Unless otherwise noted, Mobilization and Demobilization charges consist of the following: **the
> cost to transport and assemble the crane, disassemble the crane and transport back to the
> location it was dispatched from. Time after crane is assembled is hook time/work time.** These
> charges have **all associated costs incorporated in it such as support vehicles, manpower,
> etc.**"*

Read against FR-3/FR-4/FR-5:

| | FR-3 / FR-4 (this page) | The quote's T&C |
| --- | --- | --- |
| Mobilization covers | drive time from the yard · **gearing up** · travel to the site · crane setup, *"ending the moment the crane begins working"* | transport **and assemble** |
| Demobilization covers | crane breakdown · loading counterweight/trailers · return travel, *"starting the moment the crane finishes working"* | disassemble **and** transport back **to the location it was dispatched from** |
| The boundary | *"the moment the crane begins working"* | ***"Time after crane is assembled is hook time/work time."*** |
| What is bundled in | sub-items on the estimate | ***"all associated costs… such as support vehicles, manpower"*** |

**Two additions worth carrying.** The T&C names the return destination as **the dispatch
location**, not "the yard" — which matters when a crane is dispatched from somewhere other than
its home yard. And it states the bundle is **all-inclusive of support vehicles and manpower**,
which is the contractual reason the sub-items exist at all.

The T&C also puts a **floor under the bundle**: clause 8 says *"All cranes are quoted on the basis
of an **eight (8) hour minimum workday**… **This included assembly and disassembly of the crane
equipment.**"* Full contract in
[quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §10.

### Mobilization is a billing type, not just a line pattern

Fleet Cost & Care's own billing-code import template ships **`Mobilization In`** and
**`Mobilization Out`** as worked examples, and both carry `Billing Type = **Mobilization**` — a
first-class billing type alongside `Operated`, `Bare`, `Labor Only`, `Misc` and `Fuel`. Their
configuration, verbatim from the template:

| Description | A/P | Rate | UOM | GL | Auto Allocate | Billing Type | Job Type | % Applied | **Default as Sub-Item** |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Mobilization In | A | *(none)* | **EA** | 4000 | N | **Mobilization** | N | **Y** | **N** |
| Mobilization Out | A | *(none)* | EA | 4000 | N | Mobilization | N | Y | N |

Three facts follow, and all three are new to this page:

- **The roll-up parent is `Each`, with no default rate** — the amount comes from the summed
  children, exactly as FR-1/FR-2 describe.
- **`% Applied = Y`** — mobilization is **inside the fuel & insurance surcharge base**. A $3,500
  mobilization attracts $420 of surcharge at 12%.
- **`Default as Sub-Item` is a billing-code-level default**, so *"is this line hidden from the
  customer"* has a configured default before any quote exists. That is a **third** layer beside
  the estimate template's stored flag and the per-quote checkbox — see
  [fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md) §8.2.

The billing-code catalogue in the same template also lists `Travel In`, `Travel Out`,
`Disassembly and Load Out`, `Loadout`, `Offload`, `Counterweight Load` and `500 Ton Crane Travel -
In / Assembly` as separate codes — the sub-items in named form. See
[fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §3.

### The vendor documented FR-1, FR-2 and FR-6 in 2017

The FCC NexGen quote manual's FAQ on the `Item` checkbox uses **mobilization as its only worked
example**, eight years before this document was written:

> *"In many cases, **mobilizations are presented to customers as a single line item; however, the
> organization wants to track the itemized processes of mobilization.** For example, a mobilization
> may include **4 tractors, 4 trailers, travel time to the job site, assembly time, permitting,
> and OT or DT time.** If this information should not be shown on the quote, check the box."*

**That is the closest thing in the drop to an itemised mob/demob bundle**, and it names
*permitting* and *OT/DT time* as members — neither of which FR-3 lists. The vendor's stated
benefit matches FR-7's rationale: *"it enumerates costs to help with costing, planning, metrics,
and forecasting while offering a simplified quote for the customer. It also passes all of the
information on to the **Dispatcher and Billing**."* Procedure transcribed in
[fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §2.

### Two client statements from the same drop

The ERP review log's 2026-05-05 meeting extraction carries three mob/demob items that restate
FR-1, FR-6 and FR-5 in the client's own words — *"a **mob/demob calculator** bundling multiple
hidden sub-items into one visible line"*, *"**hide the mobilization sub-items from the customer
PDF**"*, *"**crane working / hook time stays a separate visible line item**"* — plus one open
question from Melissa's earlier list: *"Billing type Hourly — **do we need to add Mob and
Demob?**"* See [erp-review-log.md](../erp-review-log.md) → *Mobilization / demobilization* and
*#9 Quotes*.

**Nothing in the drop addresses REQ-1 to REQ-5** — the field-ticketing and geo-location
verification half of this page remains unsupported by any other source.

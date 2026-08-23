---
title: Mobilization & Demobilization
source: confluence/TCG/Mobilization & Demobilization
migrated: 2026-08-10
updated: 2026-08-10
status: unverified
conflicts_with: []
jira: []
topics: [mobilization, quotations, assets, customers, jobs, time-tracking, job-sites, yards]
entities: [mob-demob, quotation, asset, customer, job, field-ticket, build-up, fcc, job-site, yard]
---

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

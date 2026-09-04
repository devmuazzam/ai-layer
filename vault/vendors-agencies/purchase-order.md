---
title: Purchase order
source: confluence/TCG/Purchase order; cross-links and conflict banner added from shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/
migrated: 2026-08-10
updated: 2026-09-04
status: unverified
conflicts_with: [vendors-agencies/purchase-orders-fcc/INDEX.md, vendors-agencies/purchase-orders-fcc/commissioning-email-thread.md]
jira: []
tags: [module/assets, module/customers, module/projects-jobs, module/vendors-agencies, kind/reference, permits, purchase-orders, lift-plans]
entities: [permit, purchase-order, asset, job, vendor, agency, lift-plan, project, customer, quotation]
---

# Purchase Orders (POs)

> **Read the conflict first.** A second, incompatible answer to "what are the two PO types?"
> arrived with the 2026-09-04 Project Repository drop: in an email of 4 December 2025 Melissa
> McNutt defines Type 1 as **the PO the customer gives us** and Type 2 as **the PO we give our
> vendors** — a split by direction, where the split below is by what is bought and which
> department owns it. Neither is verified. Do not answer the question from this page alone —
> see [purchase-orders-fcc/INDEX.md](purchase-orders-fcc/INDEX.md) → *Stated conflict*.
>
> **Read the scope difference too.** This page describes the **future ERP** — a Permit Tracker
> that detects the permit requirement and a **Create PO** button that generates and later
> back-fills the PO. The **current FCC/NexGen** procedure, in which Sales or Dispatch raise a
> PO manually against a **Quote Number** before a Job exists and AP retro-links it afterwards,
> is a separate set of pages: [purchase-orders-fcc/](purchase-orders-fcc/INDEX.md) (three draft
> P&Ps of 1 December 2025, the FCC walkthrough, and the commissioning email thread). What the
> underlying NexGen system itself supports — requisitions, approval limits, receivers,
> vouchers, PO variance — is in
> [fcc-nexgen-purchasing-guide.md](fcc-nexgen-purchasing-guide.md).

## Types of POs

There are **two separate types of Purchase Orders (POs)** in the company.

### Type 1 – Permit & Vendor POs

**Owner:** Liz Lopez (Dispatch)

#### Sub-types

* **City Transportation [[projects-jobs/project-module/05-create-and-track-permits|Permit]]**

    * Purchased directly from the city.
    * Examples:
    
        * City of Vernon
        * City of Culver City
        
    
* **Permit [[vendors-agencies/agencies-vendors-INDEX|Agency]]**

    * Vendor: Quality Permits
    * Used for complex or multi-agency permits (e.g., 360-ton crane requiring Caltrans + LA City + LA County permits).
    
* **Encroachment Permit**

    * Vendors:
    
        * Alcoa
        * Roadway
        
    * Required when a public street must be closed or occupied.
    
* **Sub Hauler**

    * Vendor: Piazza Trucking
    * Used for hauling counterweights, steel plates, or other equipment.
    
* **Third-Party Crane Company**

    * Examples:
    
        * Bragg
        * Hydraulic
        
    * Used when company cranes are unavailable.
    
* **Engineered [[projects-jobs/project-module/04-create-and-approve-lift-plans|Lift Plan]]**

    * Vendor: Outside Engineering Firm
    * Used for complex [[customers/customers-INDEX|customer]] job sites requiring engineered lift plans.
    

---

### Type 2 – Parts & Maintenance POs

**Owner:** Jeff Stricker (Warehouse/Mechanics)

* Used to order crane parts and maintenance supplies.
* Not discussed during the June 18 meeting.
* Brian confirmed this process exists and is managed entirely by Jeff.

---

# When We Create a PO

## Transportation Permit

**Create a PO when:**

* The job is in a city not covered by an annual permit.
* The crane is over **350 tons** (e.g., the 360-ton crane).

**Notes**

* Annual permits are never available for the 360-ton crane.
* Every 360-ton job requires a new permit and a new PO.

---

## Permit Agency (Quality Permits)

**Create a PO when:**

* A city requires an in-person account setup.
* A city requires a physical permit runner.
* A 360-ton crane requires permits from multiple agencies.

**Examples**

* Victorville (account setup)
* Ventura County (physical runner)
* Caltrans + LA City + LA County + destination city

**Important**

* Quality Permits requires the PO number before processing begins.
* Create the PO first, then email it to Quality Permits.

---

## Encroachment Permit

**Create a PO when:**

* A job requires shutting down a public street.

**Process**

* Sales PM or Project Manager identifies the need.
* PM emails Alcoa or Roadway.
* Liz is CC'd to create the PO.

---

## Sub Hauler (Piazza Trucking)

**Create a PO when:**

* A third-party truck is required for:

    * Counterweights
    * Steel plates
    * Equipment
    * Stretch trailers
    

**Process**

* Liz confirms equipment availability with Piazza.
* After confirmation, Liz creates the PO.

---

## Third-Party Crane Company

**Create a PO when:**

* Company cranes are fully booked.
* The job is a simple lift that can be subcontracted.

**Notes**

* Jobs requiring engineered/detailed lift plans are **never** subcontracted.

**Process**

* PM sends job details to the crane company.
* Crane company confirms availability.
* PM asks Liz to create the PO.

---

## Engineered Lift Plan

**Create a PO when:**

* An outside engineering firm is required to prepare a lift plan.

**Note**

* Melissa confirmed this is rare.

---

# When a PO Is NOT Created

## Annual Permits

**No PO is created when:**

* Using existing annual permits such as:

    * Caltrans
    * LA City
    * LA County
    

**Notes**

* Annual permits have already been paid.
* Permit line item still appears on the customer quote.
* The company absorbs the cost.
* No new PO is generated.

---

# New ERP PO Workflow

## Step 1 – Permit Detection

* Permit Tracker automatically detects permit requirements based on:

    * Crane size
    * Quote checkboxes
    * City rules
    
* A permit record is automatically added to Liz's queue.

---

## Step 2 – Create Permit Record

Liz creates a **Permit** record with:

* Permit Type
* Scope of Work
* Required Date
* Agency
* Application Number
* Estimated Cost
* Service Fee
* Finance Charge
* Damage Deposit

---

## Step 3 – Generate PO

* Click **Create PO**.
* System automatically:

    * Creates the Purchase Order.
    * Copies permit information into the PO.
    * Eliminates duplicate data entry.
    

---

## Step 4 – Pending Status

* Status = **Pending**
* Application submitted.
* Permit not yet approved.

---

## Step 5 – Permit Approval

After approval:

* Change status to **Approved**.
* Enter:

    * Final permit cost.
    * Approved permit PDF.
    

---

## Step 6 – PO Update

* System automatically updates the PO with the final permit cost.
* No manual adjustment by Kaitlin is required.

---

## Step 7 – Job Attachment

* System automatically attaches the approved permit to the correct job.
* No manual linking is required.

---

## Related — added 2026-09-04 from the Project Repository drop

- [purchase-orders-fcc/INDEX.md](purchase-orders-fcc/INDEX.md) — the December 2025 P&P set:
  quote-anchored pre-job POs, AP vouchering, retro-linking to the job.
- [fcc-nexgen-purchasing-guide.md](fcc-nexgen-purchasing-guide.md) — Fleet Cost & Care's own
  NexGen purchasing documentation (v2.1, 2017).
- [sub-out-crane-and-trucking.md](sub-out-crane-and-trucking.md) — Dispatch's sub-out
  procedure, which is the operational side of the *Third-Party Crane Company* and *Sub Hauler*
  PO sub-types listed above; it confirms Hydraulic and Piazza as the vendors used.
- [outside-trucking-piazza-invoice-sop.md](outside-trucking-piazza-invoice-sop.md) — how a
  Piazza invoice reaches the customer invoice, with the mark-up arithmetic.

Nothing on this page was changed by that drop other than the two banners and this section; the
drop neither confirmed nor contradicted the permit-driven ERP workflow described above.

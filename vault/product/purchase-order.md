---
title: Purchase order
source: confluence/TCG/Purchase order
migrated: 2026-08-10
updated: 2026-07-03
status: unverified
conflicts_with: []
jira: []
topics: [permits, purchase-orders, assets, jobs, vendors, agencies, lift-plans, customers]
entities: [permit, purchase-order, asset, job, vendor, agency, lift-plan, project, customer, quotation]
---

# Purchase Orders (POs)

## Types of POs

There are **two separate types of Purchase Orders (POs)** in the company.

### Type 1 – Permit & Vendor POs

**Owner:** Liz Lopez (Dispatch)

#### Sub-types

* **City Transportation [[product/project-module/05-create-and-track-permits|Permit]]**

    * Purchased directly from the city.
    * Examples:
    
        * City of Vernon
        * City of Culver City
        
    
* **Permit [[product/agencies-vendors-INDEX|Agency]]**

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
    
* **Engineered [[product/project-module/04-create-and-approve-lift-plans|Lift Plan]]**

    * Vendor: Outside Engineering Firm
    * Used for complex [[product/customers-INDEX|customer]] job sites requiring engineered lift plans.
    

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

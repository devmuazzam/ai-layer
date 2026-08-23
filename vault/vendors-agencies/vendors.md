---
title: Vendors
source: confluence/TCG/Vendors
migrated: 2026-08-10
updated: 2026-04-30
status: unverified
conflicts_with: [vendors-agencies/agencies.md, vendors-agencies/agency-and-vendor.md, vendors-agencies/agencies-module.md]
jira: []
topics: [vendors, assets, categories, dispatch, jobs, agencies, yards, daily-allocation]
entities: [vendor, employee, asset, category, job, agency, yard, das, schedule]
---

### EPIC: Vendor Management

**[[vendors-agencies/agencies-vendors-INDEX|Vendor]] Directory — View & Search All Vendors**

**As a** Dispatch Manager **I want to** see all vendors in one place with their key details and be able to search through them **So that** I can quickly find any vendor without scrolling through spreadsheets or emails

**Acceptance Criteria:**

* A dedicated Vendors section is accessible from the left navigation bar
* All vendors are listed in a table showing: Name, ID, Phone Number, Email, Location
* A search box at the top filters vendors by name in real time
* Each vendor row has an Edit (pencil) and Delete (trash) icon
* Vendors are paginated  Previous and Next buttons navigate between page
* An Import button allows bulk uploading of vendors
* A "Create Vendor" button is visible at the top right

**Create Vendor : Add Company Info, Assets & Employees**

**As a** Dispatch Manager **I want to** create a new vendor record with their company details, associated assets, and employees in one flow **So that** all vendor information is stored in the system and ready to use when assigning them to jobs in [[dispatch/daily-allocation-INDEX|DAS]]

**Acceptance Criteria:**

**General Information:**

* Create Vendor form captures: ID, Name, Phone Number (with country code), Email, Location
* "Save & Next" button saves general info and moves to asset/employee association
* "Cancel" button discards all entries and returns to the vendor list

**Assets Tab:**

* An Assets tab within the Create Vendor form allows associating the vendor's equipment
* Each asset row captures: Unit Code, Serial Number/VIN, Category (dropdown), Sub-Category (dropdown), Capacity (ton), Model Year
* Multiple assets can be added using an "+ Add More" button
* Individual asset rows can be removed using the "Remove" button
* Category and Sub-Category dropdowns are linked — selecting a category filters the available sub-categories

**Employees Tab:**

* An Employees tab allows associating the vendor's workers
* Each employee row captures: Name, Email, Phone Number (with country code), SSN
* Multiple employees can be added using an "+ Add More" button
* Individual employee rows can be removed using the "Remove" button
* Either tab (Assets or Employees) can be filled independently — neither is mandatory to save the vendor

**Vendor Detail Page : View Associated Assets & Employees**

As a Dispatch Manager I want to open any vendor and see all their associated assets and employees in one place So that I know exactly what equipment and people that vendor has available before assigning them to a job

**Acceptance Criteria:**

**Basic Information Section:**

* Vendor detail page shows: Name, Email, Phone Number, Location at the top
* Edit and Delete buttons are visible at the top right
* Edit opens the vendor record for updating; Delete prompts a confirmation before removing

**Assets Tab:**

* Assets tab shows a table of all equipment associated with this vendor
* Table columns: Unit Code, Serial Number/VIN, Category, Sub-Category, Capacity (ton), Model Year, Status
* Status shows Active (green) or Inactive (red) clearly per asset
* Filters available: Unit Type, Schedule Type, Yard, Status
* Search box filters assets within this vendor
* Assets are paginated with Previous / Next navigation
* Each asset row has an Edit icon to update asset details

**Employees Tab:**

* Employees tab shows all workers associated with this vendor
* Table columns: Name, ID, Phone Number, Email, SSN, Status (Active/Inactive toggle)
* Status can be toggled Active or Inactive directly from the list — no need to open the employee record
* An "Invite Employee" button sends an invite to a vendor employee
* An Import button allows bulk importing of vendor employees
* Each employee row has Edit and Delete icons
* Employees are paginated with Previous / Next navigation

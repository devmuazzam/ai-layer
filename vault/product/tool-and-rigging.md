---
title: Tool and rigging
source: confluence/TCG/Tool and rigging
migrated: 2026-08-10
updated: 2026-05-26
status: unverified
conflicts_with: []
jira: []
topics: [tools-rigging, jobs, yards, quotations, assets, dashboard, dispatch, inspections]
entities: [tool-rigging, job, yard, quotation, asset, employee]
---

# **EPIC 1 :  Tools & Rigging Management**

## **Story 1 :  Create and Configure Tool or Rigging Item**

As a yards manager ,I want to create and configure tools and rigging items with custom fields and operational flags,so that tools are tracked properly and loading teams receive the correct handling instructions. 

### **Acceptance Criteria**

* Tools & Rigging exists as a separate section under Asset Management
* Index page displays tool information, availability status, and edit/delete action 
* Tool creation requires mandatory information before saving
* Cover photo upload is supported with supported image formats and size limit
* User can add unlimited custom attributes 
* Custom attribute rows can be deleted individually
* System warns if requested tool already exists on assigned crane
* System alerts if required lift component is missing
* Tool detail page displays:

    * Tool information
    * Availability chart
    * Activity history
    
* Activity history automatically logs all assigned jobs
* Every tool record has a Needs Spotter checkbox that can be turned on or off during creation or editing
* Light tools such as Jensen Lifters and chain falls are not checked by default
* When a Needs Spotter tool is added to a job, a badge appears next to that tool on the loading screen so the yard crew knows two people are required to load it. 

## **Story 3 : Tools & Rigging in Quotations**

As a Salesperson,  
I want to add tools and rigging during [[product/quotations-INDEX|quotation]] creation,  
So that yard and dispatch teams automatically receive correct loading requirements without re-entry.

### **Acceptance Criteria**

* Quotation workflow supports tools and rigging selection
* Tools added during quotation automatically appear on job after quote conversion
* No re-entry is required
* Dylan and Lisette can both view quotation tools in their respective views

## **Story 4  : Loading Process**

As a Loading Crew Member,  
I want a mobile checklist to mark items as loaded and capture photos,  
So that operators can clearly see what equipment was loaded and where it was placed on-site.

### **Acceptance Criteria**

* On mobile and tablet:

    * Loading screen opens in full screen
    
* On desktop:

    * Loading screen opens as pop-up
    
* Loading screen displays:

    * Assets
    * Tools & rigging
    * Employees
    
* All information appears in a single view
* Each tool line item displays:

    * Reference photo from asset record
    
* Each tool line item includes camera icon
* Captured photos are saved against tool item and Linked to job record
* “Needs Spotter” badge appears on flagged items
* Crew can: Tap Start Loading and Mark items completed individually
* Dispatched operator can view trailer loading photos from mobile device

**EPIC 2  :  [[product/yard-operations-jz|Yard Operations]]** 

## **Story 5 :  Dylan’s Yard Dashboard**

As a Yard Manager,  
I want a single dashboard showing all jobs and live tool inventory together,  
So that I can manage the full loading operation from one screen.

### **Acceptance Criteria**

* Left panel displays all jobs for selected date
* Right panel displays Tools ,Rigging and live status bars
* Date picker allows switching between dates without leaving dashboard
* Clicking a job expands assets , employees and requested tools & rigging
* Clicking a tool displays: Jobs requesting that tool and quantity required per job
* Clicking a job from tool panel opens it in left panel for inline quantity adjustment
* Each tool displays live status counters Total , In use and available.
* Dylan can add tools and rigging from this dashboard , a creation pop up will be displayed
* **At end of day Dylan can mark each piece of equipment as returned to yard or still on site** 

---
title: Project Module
source: confluence/TCG/Project Module
migrated: 2026-08-10
updated: 2026-04-30
status: unverified
conflicts_with: []
jira: []
topics: [assets, customers, safety, projects, lift-plans, documents-attachments]
entities: [asset, customer, project, lift-plan, job, quotation]
part_of: product/project-module/INDEX.md
---
# User Story 3: Create and Approve Lift Plans

As a Salesperson or Project Engineer, I want to create a Lift Plan and get it approved before execution so that every crane operation is documented and signed off internally and, if required, by the customer.

## User Flow

* User opens Plans tab and selects “Create New Plan”
* Chooses Lift Plan type or any from modal
* System auto-fills project details
* User enters crane details, load information, site conditions, safety details, and uploads attachments
* Submits plan for approval 
* If created by Salesperson linked to quotation, plan is auto-approved
* If created by anyone else, Salesperson receives notification to review
* Salesperson approves or sends it back with comments for changes
* Once approved, Salesperson may mark Customer Approved if required
* If crane changes after customer approval, Dispatcher is warned

## Acceptance Criteria

* Create Plan modal allows selection between plan types 
* Form auto-fills project, customer, job site, and creator details
* Crane details include category, capacity, beam length, and radius
* Load information includes description, weight, and dimension
* Site conditions and safety sections support detailed text input
* Attachments support drag-and-drop uploads
* Salesperson created plans auto-approve without notification
* Other creators trigger approval workflow to Salesperson
* Salesperson can approve or request changes with comments
* Customer approval is clearly displayed on plan cards
* Changing crane after customer approval triggers a warning (non-blocking)
* A Lift Plan is not required for every job  it is required only when the customer's requirements call for it. The Salesperson flags this at the quotation stage
* Each Lift Plan must be linked to a specific crane/resource so Dispatch knows which plan belongs to which crane
* Multiple Lift Plans can exist for the same job

## **User Story 4: Create a Site Plan**

As a Project Engineer,I want to create a Site Plan that captures all important site details  
so that crane setup, access routes, ground conditions, and hazards are clearly documented before work begins.

## User Flow

* User opens the Plans tab and clicks “Create New Plan”
* Selects Site Plan from the options
* System auto-fills project details
* User enters site details like dimensions, crane position, access routes, obstacles, ground conditions, and safety notes
* User uploads site drawings
* User submits the plan for approval
* Plan goes to Pending Approval and the approve is notified
* Approver reviews and either approves or sends it back with comments
* Once approved, the Site Plan becomes available in the Plans list and can be linked to the job

## Acceptance Criteria

* Site Plan is available as a plan type with a short description
* Form auto-fills project name, customer, job site, and creator
* Site dimensions include length, width, height clearance, and work radius
* Crane setup includes position notes, outrigger space, and setup area
* Access section includes entry/exit routes, access space, and turning radius
* Obstacles section includes nearby structures, overhead obstructions, and underground hazards
* Ground conditions include surface type, access space, and level condition
* Safety section includes risk assessment and safety measures
* Drawings can be uploaded via drag-and-drop
* On submission, status changes to Pending Approval and approver is notified
* Approver can approve or request changes with comments
* Approved Site Plans are shown in the Plans list
* Approved plans can be linked to the job from Job Detail panel


---
title: Project Module
source: confluence/TCG/Project Module
migrated: 2026-08-10
updated: 2026-04-30
status: unverified
conflicts_with: []
jira: []
topics: [jobs, permits, dispatch, lift-plans, assets, scheduling, yards, projects]
entities: [job, permit, asset, lift-plan, schedule, project, yard, quotation, customer, job-site]
part_of: projects-jobs/project-module/INDEX.md
---
# User Story 2: Create and Manage Jobs ( Excluded ) 

As a Dispatcher, I want to create jobs, assign equipment and crew, ensure compliance, and publish them so that field operations are fully prepared and automatically communicated without manual calls.

## User Flow

* Dispatcher opens Jobs tab inside a project
* Views existing jobs, with warning indicators for missing Lift Plans or Permits as per attached assets 
* Clicks “Create Job”, and system auto-fills project data
* Dispatcher only adds dates, billing type, and notes
* Opens job details where customer info, site map, work description, contacts, and schedule are visible
* Quick Access panel shows Lift Plan and Permit status with options to link or request them
* In Resources tab, Dispatcher assigns:

    * Equipment as main rows
    * Crew members as sub-rows under equipment
    * Permits linked per crane
    
* If equipment comes from different yards, Dispatcher selects the yard per asset and system calculates travel time
* Clicks “Publish Job”
* System validates all requirements
* Once validated, job is published and crew is notified automatically

## Acceptance Criteria

* Jobs listing shows Job Number, Status, Customer, Job Site, PO Number, Schedule, Linked Quotation
* Missing Lift Plan shows an orange warning badge that clears once resolved
* Missing Permit shows an orange warning badge that clears once resolved
* Job creation auto-fills project data; only minimal input required
* Each job gets a unique Job Number and starts as Open
* Main tab shows full job overview including map, contacts, schedule, and quotation details
* Quick Access panel shows Lift Plan and Permit status with clear actions
* Resources tab supports structured assignment of equipment and crew
* Yard selection per asset is stored and used for travel time calculation
* Permit column allows linking or creating new permits
* Publish Job requires at least one asset, resolved Lift Plan, and resolved Permit
* If validation fails, job cannot be published and missing items are clearly listed
* On publish, job status becomes Scheduled and crew receives notifications with all job details
* Progress Tracking shows status updates from crew check-in to completion steps

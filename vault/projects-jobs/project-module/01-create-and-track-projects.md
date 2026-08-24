---
title: Project Module
source: confluence/TCG/Project Module
migrated: 2026-08-10
updated: 2026-04-30
status: unverified
conflicts_with: []
jira: []
tags: [module/customers, module/projects-jobs, module/quotations, module/vendors-agencies, kind/reference, permits, purchase-orders]
entities: [project, quotation, customer, job, job-site, permit, purchase-order, attachment]
part_of: projects-jobs/project-module/INDEX.md
---
# User Story 1: Create and Track Projects

As a user, I want to convert a signed quotation into a project in one click so that all customer details, job information, and pricing are carried over automatically and the team can manage everything in one place.

## User Flow

* Salesperson opens a quotation that has been signed by the customer
* Clicks “Create Project” from the Quick Actions panel or create manually from Projects tab
* System automatically creates a project when click Projects from Quick action and pulls in all relevant data such as customer details, job site, PO number, salesperson, billing type, and dates
* A unique project ID is generated and the project opens on the Project Detail page with status set to Open
* Salesperson reviews and edits details if required
* Project becomes visible to the entire team in the All Projects list
* Any team member can search and access the project and its sections according to roles and permissions 

## Acceptance Criteria

* Create Project” button is only visible on quotations , when qoutation is signed 
* Clicking it instantly creates a project with all key data carried over automatically
* Project receives a unique auto-generated ID and Original quotation remains linked and visible inside the Quotations tab
* Users can search by project name or customer and filter by status or date range
* Project Detail page includes a persistent tab bar: Details, Quotations, Jobs, Permits, Plans, Accounting, Activity Log, Comments & attachments.
* Every change is logged with who changed it, what was changed, and when.
* Without creating quotation first,  we can also create project separately.


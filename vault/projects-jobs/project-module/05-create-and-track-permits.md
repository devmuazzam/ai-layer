---
title: Project Module
source: confluence/TCG/Project Module
migrated: 2026-08-10
updated: 2026-04-30
status: unverified
conflicts_with: []
jira: []
tags: [module/assets, module/dispatch, module/projects-jobs, kind/reference, permits, notifications, reporting]
entities: [permit, project, job, asset, attachment, agency, purchase-order, notification, quotation, customer]
part_of: projects-jobs/project-module/INDEX.md
---
# User Story 4: Create and Track Permits

As a  Dispatcher, I want to create and track permits for each asset so that no job is dispatched without valid legal approvals and all costs are properly recorded.

## User Flow

* User opens Permits tab inside a project
* User Views auto-generated Permit Requests from published jobs
* Clicks Create Permit from request or manually creates a new one
* Enters permit details including asset, agency, fees, notes, and uploads documents
* Optionally creates a PO for vendor tracking
* Saves permit as Pending
* Once approved, uploads final permit
* Permit automatically links to job dispatch
* System blocks job publishing if permit is missing
* System sends expiry reminders before permit ends

## Acceptance Criteria

* Permits tab includes All Permits and Permit Requests 
* Permit Requests are auto-generated from job publishing
* Permit form includes auto-generated ID, asset, job link, type, agency, fees, and status
* Supports attachments for application, final permit, and receipts
* PO creation is available within permit
* All Permits table shows full permit tracking details
* Active permits automatically link to job dispatch
* Jobs cannot be published without valid permits
* Notifications are sent for permit requests and expires
* Permit expiry alerts are triggered 30 days in advance

## User Story 5:  Project Dashboard Overview

As an internal user,I want to open a project and immediately see its overall status, financial position, alerts, team activity, and history so that I can understand everything important about the project in one view.

## User Flow

* User opens a project from All Projects
* Dashboard (Details tab) loads by default
* User reviews KPIs, charts, and project overview
* User checks Alerts for issues needing action
* User reads or posts updates in In-House Comments
* User views Activity Log for full history
* Accounting team reviews financial data in Accounting tab
* Users upload/download files in Attachments tab

## Acceptance Criteria

* KPI cards, revenue charts, job status charts, and customer and job site information are shown on the dashboard.
* Alerts are displayed with a count indicator, can be opened for details, and are automatically cleared once resolved.
* The in-house comments section allows users to view and post comments, and notifications are sent to relevant project members.
* The activity log shows full project history with action, user, and timestamp and is read-only.
* The accounting tab shows a financial summary along with quotations and invoices, and payroll status where applicable.
* The attachments section allows users to upload, view, and download project files.


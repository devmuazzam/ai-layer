---
title: Sprint 4 Additional
source: confluence/TCG/Sprint 4 Additional
migrated: 2026-08-10
updated: 2026-06-22
status: unverified
conflicts_with: []
jira: []
topics: [jobs, tools-rigging, purchase-orders, notifications, quotations, vendors, customers, yards]
entities: [job, tool-rigging, purchase-order, notification, quotation, field-ticket, vendor, customer, employee, project]
---

**Epic:** [[product/tool-and-rigging|Tools & Rigging]] Management Linking

**User Story:** As a system user I want tools and rigging added at the quotation level to automatically flow through to the job, yard view, [[product/daily-allocation-INDEX|DAS]], and job ticket, so the same data does not need to be entered multiple times across different modules.

**Acceptance Criteria:**

**[[product/quotations-INDEX|Quotation]] → Job:**

* When a quotation is converted to a job, all tools and rigging items added in the quotation automatically appear in the job  nothing needs to be re-entered
* The job's Tools & Rigging tab shows exactly what was requested from the quotation as the starting point

**Job → Yard (Dylan's View):**

* When Dylan opens a job in the yard view, he sees the tools and rigging that were inherited from the quotation
* Dylan can update quantities and assign each tool/rigging item to a specific asset (crane or support load)  his changes are saved back to the job, not as a separate record

**Job → DAS (Lisette's View):**

* When Lisette opens a job in DAS, the Tools & Rigging section is visible to her in read-only mode
* If Dylan updates tools and rigging after the schedule is set, Lisette sees the updated information on her side automatically no manual refresh needed

**Job → Field Ticket:**

* When a job ticket is sent to the field, the tools and rigging assigned to each asset on that job are included in the ticket automatically
* The field crew can see which tools and rigging are loaded on their specific truck or crane without calling the yard

**All changes go back to the Job:**

* Any update made to tools and rigging  whether by Dylan in the yard view or during load-out  is saved back to the job record as the single source of truth
* The job's Tools & Rigging tab always reflects the latest state

**Epic:** Notifications & Alerts

**User Story:** As a system user I want to receive in-app and email notifications for important events so I never miss something that needs my attention.

**Acceptance Criteria:**

**Dispatch / Lisette:**

* When an employee rejects a job ticket, an in-app notification appears on that job in DAS showing an error that needs to be fixed
* When all employees on a job have accepted their tickets, an in-app notification confirms the allocation is now locked
* When a job is 72 hours away and the pre-checklist is still incomplete, an in-app notification appears with a direct link to that job

**Salesperson:**

* When a [[product/customers-INDEX|customer]] has not responded to a sent quotation, a reminder is sent to the salesperson via in-app and email. The exact number of days needs to be confirmed with the team 3, 7, or 14 days 
* When a customer declines a quotation via DocuSign, an in-app and email notification goes to the salesperson along with the customer's reason for declining
* When a job is 72 hours away and the pre-checklist is still incomplete, an in-app and email notification goes to the assigned salesperson
* When a quotation is sitting in In Review status and no manager has approved it, a reminder is sent via in-app and email. The exact number of days needs to be confirmed with the team  3 days was suggested but not locked

**Field Employees:**

* When a job ticket is sent to them, the employee receives a push notification on their mobile app and a text message with a link to open the ticket
* If the ticket has not been accepted after 1 hour, a reminder push notification is sent
* If the ticket has still not been accepted after 1.5 hours, a second push notification is sent warning that the position may be reassigned
* The 1 hour and 1.5 hour rules apply specifically to allocations made after 6pm

**HR and Office:**

* When an employee certification is 60 days from expiry, a push notification goes to the employee and an in-app and email notification goes to HR
* When the same certification reaches 30 days from expiry, a second push notification goes to the employee and a second in-app and email notification goes to HR

**Epic:** [[product/purchase-order|Purchase Order]] Management 

**User Story:** As a manager and the accounting team I want to create Purchase Orders directly inside a project , link them to the right job and [[product/agencies-vendors-INDEX|vendor]] so that when a vendor sends their invoice the payment can be matched and processed without going to a separate system.

**Acceptance Criteria:**

**Creating a PO:**

* A PO can be created from the PO Numbers tab inside a project
* When creating a PO the user selects the type  Internal or Customer enters the vendor or customer name, what it is for, price, valid till date, and linked asset if applicable
* The system auto-generates a unique PO number on save
* One PO per vendor per job  if the same vendor covers multiple trucks on one job a single PO covers all of them
* An invoice or receipt can be attached directly to the PO

**Linking:**

* Every PO must be linked to a job number this is required, not optional
* If a PO was created at the quotation level it automatically carries over to the project and shows the same PO number  no re-entry needed
* When a vendor is assigned in DAS a Create PO button appears  clicking it generates the PO for that vendor and job without leaving the screen

**Tracking:**

* Each PO shows one of three statuses  Pending, Confirmed, Paid
* The PO list inside the project shows all POs with their type, vendor name, amount, linked job, status, and date created

**Global list( Sidebar ) :**

* A global PO list in the main sidebar shows all POs across all projects and jobs
* The list can be filtered by type Internal or Customer

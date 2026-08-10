---
title: Daily Allocation system
source: confluence/TCG/Daily Allocation system
migrated: 2026-08-10
updated: 2026-04-30
status: unverified
conflicts_with: [product/job-project-das.md]
jira: []
topics: [jobs, assets, dispatch, vendors, daily-allocation, navigation-ui, inspections, scheduling]
entities: [job, employee, asset, field-ticket, vendor, das, schedule, project, quotation, yard]
---

### EPIC 1 : DAILY ALLOCATION SYSTEM  

* Three-Panel  Daily Allocation Screen / view 
* Drag & Drop Resource Allocation with Multi-Day Copy
* Ticket Dispatch Life cycle with Tracking
* Employee & Asset Availability Management
* Managing Pre-Checklist
* Live Asset Map View
* Vendor Management in [[product/daily-allocation-INDEX|DAS]] 
* Temp employee management in DAS  

**USER STORY  : Three-Panel  Daily Allocation Screen \[ 3440 x 1440\]**

As a Dispatch Manager I want to see all jobs, assets, and employees for any selected date on a single screen  with quick date navigation, status filters, sort controls, and a legend So that I can manage the full daily schedule from one place without switching screens

**Acceptance Criteria:**

* Screen is divided into three panes: Assets (left), Jobs (centre), Employees (right)
* Quick-action buttons (Previous Day, Today, Next Day) and a calendar picker are at the top
* KPI counters show Total / Available / Assigned / On Leave for both assets and employees
* Jobs panel has a status filter drop-down covering all statuses (Open → Ticket Submitted)
* Asset panel has sort controls by crane size (Low-to-High, High-to-Low)
* Each panel has its own independent search box
* Toggle switches between Compact chip view and detailed List view for jobs
* A colour legend at the top explains all status chips and role colours
* All three panes refresh automatically when the date changes

### **USER STORY : Drag & Drop Resource Allocation with Multi-Day Copy**

As a Dispatch Manager I want to click any job to open its allocation panel, drag and drop assets and employees onto required slots, save the allocation, and copy it across multiple days in one action So that I can build and replicate the full schedule quickly without repetitive data entry

**Acceptance Criteria:**

* Clicking a job opens a side panel showing all required slots (crane, operator, oiler, support load, etc.) flowing from the [[product/quotations-INDEX|quotation]]
* Eligible assets and employees are highlighted at the top of their panels; unavailable ones are greyed out but still drag-gable with a system warning
* Assignment is time-based (shift start/end), so the same asset can be assigned to two non-overlapping jobs on the same day
* Same Assets for Different Shifts toggle is ON by default assigning to Shift 1 auto-fills Shift 2
* Same Resources for Different Shifts toggle is OFF by default  can be turned on to copy employees across shifts
* Once allocation is saved, employee and asset chips update to "Assigned" with the job number visible
* A Copy Allocations button allows copying the saved config to selected future dates, with check boxes to copy assets only, employees only, or both

### **USER STORY : Ticket Dispatch Life cycle with Tracking**

As a Dispatch Manager, I want to send job tickets to assigned employees, track responses in real time, get push notifications, and auto-lock allocations once all tickets are accepted, so I can dispatch schedules efficiently and ensure confirmed plans aren’t changed accidentally.

**Acceptance Criteria:**

* Job statuses progress: Open → Allocation Completed → Ticket Sent → Load-out → Employees Left Yard → Work in Progress → Completed → Ticket Submitted
* "Send Bulk Tickets" button sends tickets to all assigned employees across all saved jobs in one click; individual send is also available per job
* After sending, each employee chip shows: Ticket Sent / Link Opened / Accepted
* First reminder fires at 1 hour; second warning at 1.5 hours states position may be reassigned
* Dispatcher can remove and replace a non-responding employee directly from the chip
* Once all employees on a job accept, that job's allocation locks automatically
* Locked allocations require a confirmation warning to edit; past-date jobs are fully read-only
* "Send Tickets" button changes to "See Progress" after tickets are sent

### **USER STORY : Employee & Asset Availability Management** 

As a Dispatch Manager I want to mark employees on leave or assets in maintenance directly from the DAS screen, and see role colour coding and flags on all chips So that I always know who and what is truly available without going to a separate module

**Acceptance Criteria:**

* Clicking an employee chip shows a "**Mark Leave**" option with date range and reason field; leave syncs two-way with the HR module
* On-leave employees are greyed out with a "Leave" tag; they remain visible but non-assignable
* Operator chips are pink, oiler chips are blue, apprentice chips are yellow-orange
* A "Previous Night" tag automatically appears on employees who worked the previous night shift, based on shift SOPs
* Clicking an asset chip shows a "**Mark Maintenance**" option with a notes field
* In-Maintenance assets are greyed out with a "Maintenance" tag
* Maintenance status can be approved or reverted by the maintenance team from their own view
* Asset chips show three states: Available / Assigned / In Maintenance

### **USER STORY : Managing Pre-Checklist**

As a Dispatch Manager, I want job cards to show checklist and [[product/project-module/05-create-and-track-permits|permit]] status, with alerts before the job if anything is missing So that all requirements are completed before the job day without last-minute follow-ups

**Acceptance Criteria:**

* Each job card shows a pre-checklist with items: Assets Assigned, Resources Assigned, [[product/project-module/04-create-and-approve-lift-plans|Lift Plan]], Site Plan, Travel Plan green if complete, red if missing
* Clicking a missing item opens a quick link to that section inside the job or shows a "Create Request" shortcut
* Pre-checklist recalculates in real time as items are completed
* System automatically sends a notification to the assigned salesperson 72 hours before any job with an incomplete pre-checklist
* The relevant item turns red on the salesperson's dashboard at the 72-hour mark
* A "Due in 72 hrs" badge appears on the job card visible to Lisette as well

### **USER STORY : Live Asset Map View**

As a Dispatch Manager, I want to toggle a map view showing all field assets with live locations, job assignments, and transit paths, so I can visually monitor equipment for any date without making calls.

**Acceptance Criteria:**

* A Map View toggle in the DAS header switches the centre panel from job list to an interactive map
* Assets are shown as crane-specific icons
* Hovering over an icon shows asset name, assigned job, and status
* Clicking an icon opens a detail sidebar with full job and asset information
* If an asset is in transit, its path and estimated arrival time are displayed
* KPI counters remain visible at the top in map view
* Toggling off returns to the jobs list view

### User story : Vendor Management in DAS

As a Dispatch Manager,  
I want to assign [[product/agencies-vendors-INDEX|vendors]] and share job details with them through a secure link,  
So that external work is handled efficiently without manual coordination.

**Acceptance Criteria:**

* Vendor panel is accessible on the left side of DAS (below assets)
* Vendor can be dragged onto any crane or truck slot in the allocation panel
* When a vendor is assigned, a "Create PO" quick-action button appears and auto-generates a PO for that job
* Jobs fully covered by a vendor crane company display a clear visual so Dylan knows no yard loadout is required
* System generates a unique secure job passport link per vendor per job
* Vendor uses the link and a pass-code (no full portal login) to: Accept the job, Mark In Progress, Mark Completed, Submit billing/ticket data
* Dispatcher sees vendor status update in DAS in real time (Accepted / In Progress / Completed)
* Accounting receives vendor-submitted data and can review, modify, or supplement before including in client billing packets

### Temporary Employee management in DAS

As a Dispatch Manager, I want to assign temporary or fill-in employees to job slots like permanent staff, so I can quickly cover schedule gaps without creating full HR profiles or leaving slots empty

**Acceptance Criteria:**

* Temporary employees appear in the employee panel with a distinct "Temp" tag so they are visually distinguishable from permanent staff
* A temp employee can be dragged onto any employee slot in the job allocation panel  same drag-and-drop behaviour as permanent employees
* If the exact person is not yet confirmed, a "Fill In" placeholder can be assigned dispatcher enters name and contact details in a notes field
* Temp employees receive job information via a secure link — no full portal access is required
* Through the link, the temp employee can accept the job and submit their details upon completion
* Optionally, a temp employee can download the mobile app, enter the job passcode, and operate as a regular field employee
* Payroll and billing teams can see the temp employee assignment and the job it is linked to
* Once a temp employee accepts via the link, their chip in DAS updates to "Accepted"
* Temp employee assignments are included in the allocation lock once all employees on the job have accepted

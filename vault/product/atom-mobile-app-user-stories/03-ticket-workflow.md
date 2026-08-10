---
title: Atom Mobile Application ( User stories )
source: confluence/TCG/Atom Mobile Application ( User stories )
migrated: 2026-08-10
updated: 2026-07-22
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/frd-new-format-draft/INDEX.md]
jira: []
topics: [field-ops-mobile, time-tracking, inspections, customers, safety, signatures]
entities: [employee, field-ticket, customer, signature, tailboard-jsa, job]
part_of: product/atom-mobile-app-user-stories/INDEX.md
---
# EPIC 3 —> Ticket Workflow

## US-5 —> View Ticket Details

### User Story

As a field employee, I want to view ticket details so that I have all required job information before and during work.

### Acceptance Criteria

* Ticket displays customer information.
* Ticket displays on-site contact information.
* Ticket displays comments.
* Ticket displays attachments.
* Ticket displays job location.
* User can launch navigation using the preferred maps application.
* Ticket displays nearest hospital information.
* User can call the on-site contact.
* User can call the nearest hospital.
* User can accept and reject the ticket

## US-6 —> Pre-Trip Inspection

### User Story

As a field employee, I want to complete a pre-trip inspection for assigned assets so that equipment condition is verified before work begins.

### Acceptance Criteria

* Inspection supports multiple assigned assets.
* Inspection items support Completed, Deficiency and N/A states.
* Deficiencies support comments, voice notes, photos and priority selection.
* Employee can upload photos for each assigned asset.
* Assigned asset information displays the operator on record when available.
* Trailer inspections are supported when a trailer asset is assigned to the ticket.
* Inspection completion is mandatory before proceeding.
* Inspection summary is generated.
* Employee signature is required.
* Invalid signatures are rejected.
* Completed inspection can be reviewed after submission.

## US-7 —> Travel to Job Site

### User Story

As a field employee, I want to record departure and arrival activities so that travel to the job site is tracked.

### Acceptance Criteria

* Employee can record Left Yard.
* Departure time supports adjustment.
* When the employee opens the "Left Yard" step, the app shows the current time automatically they don't have to type anything in.
* The app checks the phone's GPS location and confirms whether the employee is actually at the yard. It shows something like "GPS verified
* Employee can add comments.
* Driving screen displays ETA and distance.
* User can launch navigation.
* Dispatch can view ETA information.
* System prompts for arrival when entering the configured geofence.
* Arrival confirmation records arrival time and location.

## US-8 —> Customer First Signature

### User Story

As a field employee, I want to capture the customer's authorization before work begins so that approval is documented.

### Acceptance Criteria

* The customer must enter or confirm their **name** before providing a signature.
* The system displays the applicable **Terms & Conditions** before the customer can sign.
* The customer must explicitly select **Accept** or **Reject** for the Terms & Conditions.
* If the customer selects **Reject**, the system must not allow the signature step to be completed.
* If the customer selects **Accept**, the signature field becomes available and the customer can provide their signature.
* A **customer signature is required** before the step can be completed.
* The system captures the **date and time** when the signature is submitted.
* The system captures the **GPS/location information when available** at the time of signing.
* The system captures the required **customer photo** as part of the signature process.
* If the required customer photo is removed, the customer/employee must retake the photo before completing the step.
* An optional **Comments** field is available for additional information.
* Comment field is available.
* Successful completion advances the workflow.

## US-9 —> JSA / Tailboard

### User Story

As a field employee, I want to complete the JSA/Tailboard before starting work so that job-site hazards and safety requirements are identified and documented.

### Acceptance Criteria

* The **JSA/Tailboard** step becomes available after the required customer authorization/first-signature step is completed.
* The employee must complete the JSA/Tailboard **before Start Work** can be recorded.
* The JSA/Tailboard displays the required **job-site safety checklist/questions**.
* The employee can review and complete each required JSA/Tailboard item.
* The employee can identify and record **job-site hazards**.
* The employee can enter **comments/notes** where applicable.
* All mandatory JSA/Tailboard items must be completed before the employee can submit the step.
* The completed JSA/Tailboard is saved against the **job ticket**.
* The system records the **date and time** of JSA/Tailboard completion.

## US-10 —> Start Work, Build-Up & Boom Time Tracking

### User Story

As a field employee, I want to start the "boom time" clock when I begin work on site so that my actual working hours are tracked accurately for payroll and billing.

### Acceptance Criteria

* Employee can record Start Work.
* Start Work time can be adjusted according to business rules.
* GPS verification is captured when available.
* Employee can record Build-Up Complete.
* Build-Up Complete is captured as a separate timestamp from Start Work.
* Build-Up duration is stored separately.
* Elapsed boom time is displayed.
* Boom time starts after build-up completion.

## US-11 — Lunch Break Management

### User Story

As a field employee, I want to record lunches and worked-through lunches so that meal-period activities are documented.

### Acceptance Criteria

* Lunch events are automatically generated based on configured rules.
* Lunches remain locked until eligible.
* Notifications are generated before lunch is due.
* Employee can take lunch.
* Employee can work through lunch.
* Worked-through lunch requires customer authorization.
* Customer name, signature and photo are captured.
* Comment field is available.
* Customer authorization details are retained as part of the lunch record.
* Lunch history is stored on the ticket.
* Lunch activity is displayed during review.

## US-12 — End Work & Break-Down Tracking & customer signature

### User Story

As a field employee, I want to record work completion activities so that operational work can be finalized.

### Acceptance Criteria

* Employee can record End Work.
* End Work time can be adjusted according to business rules.
* GPS verification is captured when available.
* Total boom time is calculated.
* Break-Down timestamp is captured separately.
* Break-Down information is stored.

## US-13 — Customer Final Signature

### User Story

As a field employee, I want to capture customer sign-off at job completion so that completed work is approved.

### Acceptance Criteria

* Customer final signature is captured.
* Customer photo is automatically captured.
* Location and timestamp are stored with the final signature.
* Completion checklist confirms:

    * Work completed as described.
    * No damage to the site.
    * No accidents or incidents occurred.

* Customer comments can be entered.
* If signature occurs before expected completion, the ticket is flagged as an early departure.
* Early departure acknowledgement is required before submission.
* Early departure information is stored.
* Early departure status is visible during review.

### US-13 — Left Job & Return Travel

**User Story:**
As a field employee, I want to record when I leave the job site and travel back so that my return travel time is accurately tracked.

**Acceptance Criteria**

* Employee can select **Left Job** after required job-site activities are completed.
* Selecting Left Job records the **Left Job timestamp**.
* Left Job time can be adjusted where permitted.
* Available GPS/location information is captured for verification.
* The ticket moves into **Return Travel** status.

### US-14 — Arrive Yard & Post-Trip Inspection

**User Story:**
As a field employee, I want to record my arrival at the yard and complete a post-trip inspection so that my return time and equipment condition are documented.

**Acceptance Criteria**

* Employee can record **Arrive Yard**.
* System records the **Arrive Yard timestamp**.
* Yard arrival/geofence information is captured when available.
* After arrival, employee can complete the **Post-Trip Inspection** for applicable assigned assets.
* Employee can report **deficiencies** with applicable photos/comments.
* Employee signature is required to complete the inspection.

## US-15 — Compliance Checklist & Attestation

### User Story

> As a field employee, I want to complete the required compliance checks and attestation so that the ticket meets all compliance requirements before submission.

### Acceptance Criteria

* Compliance checklist is displayed after post-trip inspection.
* Lunch records summary is displayed.
* Rest verification information is displayed.
* Employee can select Long Sub, Short Sub or N/A.
* Employee attestation is required.
* Employee signature is captured.
* Compliance information is stored with the ticket.

## US-16 — Labor & Unit Details

### User Story

As a field employee, I want to review my labor and assigned unit information so that my worked hours and payroll-related information are accurate before I submit the ticket.

### Acceptance Criteria

* Applicable ticket start and end times automatically flow into the labor record.
* System calculates the employee's labor hours from the applicable ticket times.
* Employee can review and, where permitted, adjust the labor information.
* Employee can select the applicable labor classification / craft code.
* Applicable Boom Pay / Craft Modifier information is included.
* Work Through Lunch information is reflected when applicable.
* Assigned unit/asset information is displayed.
* Employee can add comments when required.

### US-17 — Review & Submit Ticket

**User Story**

> As a field employee, I want to review and submit my completed ticket so that all job and labor information is confirmed and sent for further processing.

**Important Acceptance Criteria**

* Employee can review the completed **ticket information before submission**.
* Review includes applicable **timestamps, inspections/checklists, customer signatures, compliance, and labor information**.
* Employee can correct information that is permitted to be edited before submission.
* System identifies any **missing required information or invalid/conflicting timestamps**.
* Any required validation issues must be resolved before the ticket can be submitted.
* Employee can select **Complete Ticket** once all required information is complete.
* Employee must confirm the Complete Ticket action.
* Once completed, the ticket is marked **Complete** and becomes available for downstream **payroll and billing processing**.
* Employee is returned to the applicable ticket/dashboard view after completion.


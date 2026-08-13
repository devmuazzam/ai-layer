---
title: Atom Mobile Application ( User stories )
source: confluence/TCG/Atom Mobile Application ( User stories )
migrated: 2026-08-10
remigrated: 2026-08-13
confluence_version: 10
updated: 2026-08-11
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/frd-new-format-draft/INDEX.md]
jira: []
topics: [field-ops-mobile, ticket-workflow, inspections, signatures, compliance, time-tracking]
entities: [field-ticket, dispatch, inspection, deficiency, signature, geofence, tailboard-jsa]
part_of: product/atom-mobile-app-user-stories/INDEX.md
---
# EPIC 3 — Ticket Assignment & Details

## US-4 — Receive, Accept or Reject Ticket

**User Story**

As an assigned field employee, I want to receive and respond to my assigned ticket so that
Dispatch knows whether the allocation can proceed.

**Acceptance Criteria**

* Finalised employee allocation makes the applicable ticket available to the assigned employee.
* Employee receives notification of the assigned ticket.
* The allocation is treated as accepted by default when the employee is allocated
* Employees can reject the assigned ticket.
* Sms on phone number.
* When the employee rejects the ticket, Dispatch is notified and worker enter the reason
* The affected job displays a notification/error in the Dispatch Manager view.
* Dispatch must address the rejected allocation.
* Applicable ticket/allocation status is reflected in the Dispatch/Daily view.

## US-5 — View Ticket Details

**User Story**

As a field employee, I want to review my ticket details so that I understand the assigned work
before starting the field workflow.

**Acceptance Criteria**

* Ticket displays applicable customer and on-site contact information.
* Ticket displays the job location, map/location information and applicable assigned equipment.
* Ticket displays applicable comments and attachments.
* Employee can launch navigation to the job location.
* Employees can call the applicable on-site contact.
* Ticket displays the nearest hospital information and supports applicable calling/navigation actions.
* Ticket displays the applicable job workflow/timeline.

# EPIC 4 — Pre-Trip

## US-6 — Pre-Trip Inspection

**User Story**

As a field employee, I want to inspect my assigned equipment before leaving the yard so that
equipment condition is documented before the job.

**Acceptance Criteria**

* System displays the applicable inspection checklist based on the assets assigned to the ticket.
* Inspection supports multiple assigned assets, including applicable Crane, Tractor/Truck and Trailer equipment.
* Each applicable asset uses its corresponding inspection requirements rather than one generic inspection.
* Assigned asset information displays the operator on record where available.
* Inspection items support Completed/OK, Deficiency/Issue and N/A.
* When Deficiency is selected, the employee records the applicable details describing the identified issue.
* Deficiency reporting supports applicable comments/voice input, photos and priority selection.
* Employee can identify an applicable deficiency as an emergency/critical issue.
* Each deficiency is associated with the applicable asset/checklist item and made available for maintenance/mechanics visibility.
* Employee can upload applicable photos for the assigned assets.
* Mandatory inspection items must be completed before the inspection can be completed.
* System generates an Inspection Summary showing the applicable inspection results.
* Employee provides the required inspection signature and Invalid/inadequate signatures are rejected.
* Employee can review completed inspection information.
* Required Pre-Trip inspection must be completed before the employee proceeds to **Left Yard**.

## US-7 — Left Yard

**User Story**

As a field employee, I want to record when I leave the yard so that the beginning of outbound
travel is captured.

**Acceptance Criteria**

* Employee can select Left Yard after completing the required Pre-Trip activities.
* Selecting Left Yard records the applicable departure timestamp.
* Employee can adjust the recorded Left Yard time where permitted.
* When Left Yard time is adjusted, the applicable reason for the adjustment is captured.
* Applicable configured time-adjustment increments are supported.
* Available Samsara/GPS information can be used for timestamp/location reconciliation \[ Later \]
* Left Yard establishes the beginning of outbound travel.

## US-8 — Travel to Job Site

**User Story**

As a field employee, I want my travel to the job site tracked so that the outbound journey and
arrival can be recorded.

**Acceptance Criteria**

* Outbound travel begins after Left Yard.
* The period between **Left Yard and Arrive Job** represents outbound travel.
* Driving view displays applicable ETA and distance information.
* Employee can launch navigation to the job location.
* Applicable ETA information is available to Dispatch.
* Available GPS/Samsara information is used where applicable \[ Later \]
* Application supports the configured job-site geofence for arrival detection.
* When the applicable arrival condition is reached, the application prompts the employee to confirm arrival rather than automatically starting work.

## US-9 — Arrive Job & Customer First Authorization

**User Story**

As a field employee, I want to record my arrival at the job site and obtain customer
authorization so that outbound travel is completed and I am authorized to proceed with pre-work
activities.

**Acceptance Criteria**

* Employee can select **Arrive Job** when they reach the job site.
* Arrive Job is recorded as a separate timestamp from **Left Yard** and **Start Work**.
* Employee can adjust the Arrive Job time according to the permitted ticket time-adjustment rules.
* **Left Yard → Arrive Job** establishes the applicable outbound travel period.
* Arrive Job does **not** automatically start work.
* After Arrive Job, the employee proceeds to **Customer First Authorization**.
* Application captures/confirms the applicable customer/on-site representative's name.
* Applicable **Terms & Conditions** are displayed before customer authorization.
* Customer must accept the Terms & Conditions before signing.
* If the customer rejects the Terms & Conditions, the authorization/signature cannot be completed.
* Customer's first authorization signature is captured and invalid/inadequate signatures are rejected.
* Applicable customer photo is captured as part of the authorization flow; if the required photo is removed, it must be retaken.
* Applicable location and timestamp are retained with the customer authorization.
* Comment capability is available.

## US-10 — JSA / Tailboard

**User Story**

As a field employee, I want to complete the JSA/Tailboard before starting work so that
applicable job-site safety information is documented.

**Acceptance Criteria**

* JSA/Tailboard occurs after the first customer authorization and before Start Work.
* Application captures the applicable job-site safety/hazard information.
* JSA information is stored against the applicable ticket.
* Required safety acknowledgement/signature is captured.
* JSA remains separate from the equipment Pre-Trip/Post-Trip inspection.
* Required JSA must be completed before the employee can proceed to **Start Work**.
* JSA information/completion status is available during final ticket review

---
title: Atom Mobile Application ( User stories )
source: confluence/TCG/Atom Mobile Application ( User stories )
migrated: 2026-08-10
remigrated: 2026-08-13
confluence_version: 10
updated: 2026-08-11
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/frd-new-format-draft/INDEX.md]
jira: []
topics: [field-ops-mobile, signatures, time-tracking, inspections]
entities: [signature, field-ticket, inspection, early-departure, deficiency]
part_of: field-ops/atom-mobile-app-user-stories/INDEX.md
---

> **Migration note.** The source page heads this section **`PIC 10 — Job Completion`** — an
> apparent typo for `EPIC 10`. Reproduced as written. The page has no EPIC 5 through EPIC 9.

# PIC 10 — Job Completion

## US-13 — Customer Final Signature

**User Story**

As a field employee, I want to obtain final customer sign-off after completing the work so that
completion of the job is acknowledged.

**Acceptance Criteria**

* Application captures the applicable customer/on-site representative's **final signature** after work completion.
* Final Customer Signature is retained separately from Customer First Authorization.
* Applicable customer photo is captured as part of the final-signature workflow.
* Applicable location and timestamp are retained with the final signature.
* Customer comments can be recorded.
* Applicable completion confirmations shown in the mobile workflow are captured.
* If the applicable early-departure condition is identified, the ticket is flagged as **Early Departure**.
* Applicable Early Departure acknowledgement/information is retained against the ticket.
* Early Departure information is available during final review.
* Final Customer Signature is completed before the employee proceeds to **Left Job**.

# EPIC 11 — Return Journey

## US-14 — Left Job & Return Travel

**User Story**

As a field employee, I want to record when I leave the job site and travel back so that my
return journey is accurately captured.

**Acceptance Criteria**

* Employee can select **Left Job** after completing the required job-site activities and customer final sign-off.
* Selecting Left Job records a separate Left Job timestamp.
* Employee can adjust Left Job time according to the permitted ticket rules.
* Left Job follows the applicable field-ticket time increment rules.
* Available GPS/location information is retained where applicable.
* Selecting Left Job establishes the beginning of the employee's **return travel**.
* Return travel remains separate from the Start Work–End Work operational period.
* Applicable return-travel timing is retained for ticket/Labor processing.
* Ticket remains active until the required return/end-of-job activities are completed.

## US-15 — Arrive Yard & Job-Related Yard Activities

**User Story**

As a field employee, I want to record my return to the yard so that my return timing and
applicable job-related yard activities are captured.

**Acceptance Criteria**

* Employee can record the applicable **Arrive Yard** activity after returning from the job.
* Arrive Yard timestamp is retained against the applicable ticket.
* Arrive Yard follows the applicable field-ticket time increment rules.
* Employee can correct the applicable Arrive Yard timestamp where permitted.
* Available GPS/Samsara/geofence information can be used for applicable return-time reconciliation.
* Applicable job-related yard activities performed after returning can remain associated with the current ticket.
* Applicable **fueling and paperwork related to the completed job** can remain associated with that ticket.
* Work unrelated to the completed job, such as preparation for a future job, must not be included as part of the completed job's time.

# EPIC 12 — Post-Trip Inspection

## US-16 — Post-Trip Inspection

**User Story**

As a field employee, I want to complete the applicable Post-Trip inspection so that equipment
condition after the job is documented.

**Acceptance Criteria**

* Application displays the applicable Post-Trip checklist based on the assigned asset(s).
* Post-Trip supports applicable **Crane, Tractor/Truck and Trailer** inspections.
* Multiple assigned assets can be inspected where applicable.
* Each applicable asset uses its corresponding equipment-specific inspection checklist.
* Inspection items support the applicable **Completed/OK, Deficiency/Issue and N/A** behaviour.
* When a deficiency is identified, the employee records the applicable details describing the equipment issue.
* Applicable comments and supporting photos can be attached to the reported deficiency.
* Each reported deficiency is associated with the applicable asset/inspection item.
* System generates the applicable Post-Trip Inspection Summary.
* Employee provides the applicable acknowledgement/signature.
* Completed Post-Trip information is retained against the ticket.

**Open:** The transcript did not conclusively finalise whether Post-Trip is mandatory for every
applicable ticket.

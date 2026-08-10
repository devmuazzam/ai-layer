---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, inspections, downtime-delays, time-tracking, lunch-breaks, ticket-workflow]
entities: [field-ticket, lunch-record, yard, job, customer, deficiency]
part_of: product/frd-new-format-draft/INDEX.md
---
## 6. Key User Flows

### Flow 1 — Standard Ticket Execution (Oiler)

* Oiler receives ticket assignment notification and accepts
* Oiler opens ticket detail from Home — reviews job, contacts, equipment, and assigned unit
* Oiler records Leave Yard — system captures exact timestamp
* Oiler completes pre-trip checklist for crane, tractor, trailer, and support loads — any deficiencies are logged with severity
* Oiler travels to job site and records Arrive Job
* Oiler captures initial customer signature — signer name, signature, timestamp, and terms
* Oiler completes JSA/safety checklist — Start Work is not available until this is done
* Oiler records Start Work — boom pay clock begins
* System monitors lunch threshold — Oiler receives alert before lunch is due
* Oiler records Start Lunch and End Lunch
* If lunch is missed, Oiler records work-through-lunch and captures required authorisation
* Oiler records End Work
* Oiler captures final customer signature
* Oiler records Leave Job and travels back to yard
* Oiler records Arrive Yard — compliance checklist becomes available
* Oiler completes compliance checklist including lunch/rest confirmations and per diem indicators
* Oiler reviews labor details — underlying timestamps (Leave Yard → Arrive Yard) are displayed
* Oiler confirms boom pay / craft modifier — reason required if actual differs from planned
* Oiler submits ticket — system validates all required steps are complete
* Ticket moves to Completed or Review Required

### Flow 2 — Delay During Active Work

* Work is in progress on an active ticket
* Unexpected delay occurs — Oiler initiates downtime event from within the ticket
* Oiler selects delay category: Customer Delay, TCG Delay, Weather Delay, Equipment Delay, or Other
* Oiler enters supporting notes and records delay duration
* If category requires it (Customer Delay, Equipment Delay), Oiler captures customer acknowledgement
* Delay is resolved — Oiler resumes work; ticket remains in progress throughout
* Downtime record is attached to the ticket and flows to payroll/billing review

### Flow 3 — Deficiency During Pre-Trip Checklist

* Oiler is completing pre-trip checklist for assigned crane
* Oiler identifies an equipment issue and selects deficiency
* Oiler classifies severity: Normal, Urgent, or Blocking
* If Blocking — system immediately initiates escalation workflow and triggers urgent notification to configured internal teams
* Oiler adds mandatory comment and optional photo
* Deficiency is attached to unit, ticket, job, and user
* Blocking deficiency is visible to Dispatch and maintenance for downstream handling

### Flow 4 — Incomplete Ticket Handling

* Field user starts a ticket but exits the app before completing all required steps
* System auto-saves progress — draft ticket remains visible on Home
* User receives incomplete ticket reminder after configured time
* User resumes ticket — all previously completed steps, timestamps, signatures, and checklist answers are preserved
* If hard-block enforcement is active, user cannot open a subsequent day's ticket until the incomplete ticket is resolved
* User completes missing items and submits

### Flow 5 — Third Man / Laborer Ticket Execution

* Third Man receives ticket assignment independently of Operator/Oiler crew
* Third Man accepts ticket and opens ticket detail
* Third Man records Leave Yard and completes own vehicle/equipment pre-trip checklist
* Third Man records Arrive Job and completes JSA
* Third Man records Start Work, manages own lunch tracking
* Third Man records End Work and Leave Job
* Third Man records Arrive Yard and completes own compliance checklist
* Third Man reviews own labor details with underlying timestamps
* Third Man submits own ticket independently — no main customer signature required

---


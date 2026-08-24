---
title: Dispatcher Needs
source: confluence/TCG/Dispatcher Needs
migrated: 2026-08-10
updated: 2026-04-07
status: unverified
conflicts_with: []
jira: []
tags: [module/assets, module/customers, module/dispatch, module/field-ops, module/projects-jobs, module/vendors-agencies, kind/reference, permits, scheduling, inspections]
entities: [job, permit, asset, customer, vendor, field-ticket, schedule, project, agency, tool-rigging]
---

## **1. Dispatcher Needs (Extracted from Discovery)**

**Objective:** Dispatcher must plan, validate, finalize, and execute next-day jobs without relying on Excel or manual tracking.

**Centralized Job View:** Dispatcher needs a single view of all jobs (today + upcoming) with job details (time, location, [[customers/customers-INDEX|customer]]), status (planned, confirmed, canceled), and special requirements (rigging, mats, permits, etc.).

**Visual Planning Board (Excel Replacement):** Dispatcher needs to place jobs against cranes and crews, plan next-day operations visually, manage holdovers and multi-day jobs, and identify conflicts/overlaps.

**Equipment Awareness:** Dispatcher needs to know where each crane currently is, whether it can reach the next job, and whether it is down or unavailable.

**Crew Availability Awareness:** Dispatcher needs visibility into who is off/unavailable, who is already assigned, and who is at overtime/double-time risk.

**Feasibility Validation:** Dispatcher needs to validate travel feasibility between jobs, crew readiness (night jobs/fatigue), [[projects-jobs/project-module/05-create-and-track-permits|permit]] dependencies, and equipment suitability.

**Customer Confirmation Tracking:** Dispatcher needs to confirm jobs with customers, track confirmation status (confirmed/pending/canceled), and log updates or changes.

**Plan Adjustment Capability:** Dispatcher needs flexibility to reassign cranes, swap crews, and shift jobs quickly.

**Final Resource Assignment:** Dispatcher needs to assign crane, operator, oiler, and supporting crew in a structured way.

**Ticket Generation:** Dispatcher needs the system to generate dispatch tickets automatically with complete job and resource details.

**Crew Communication:** Dispatcher needs to send job details to field crew through the system and reduce dependency on manual texting.

**Acknowledgement Tracking:** Dispatcher needs to track who has received and acknowledged the job and who has not responded (currently handled via Excel).

**Permit & [[vendors-agencies/agencies-vendors-INDEX|Vendor]] Coordination:** Dispatcher needs to identify permit/vendor requirements, create PO linked to job, and track external dependency status.

**Exception Handling:** Dispatcher needs the ability to handle last-minute changes, equipment breakdowns, and urgent job insertions.

**Map Awareness (Optional but High Value):** Dispatcher benefits from viewing job locations, understanding equipment positioning, and evaluating routing/logistics.

---

## **2. Validation Checklist (Design Review Layer)**

**Coverage Check:** System must cover all dispatcher needs above. Nothing should require Excel, calls, or memory outside the system.

**Question-Based Validation:** For each screen, ask “What dispatcher question does this answer?” The system must enable answering: what jobs are scheduled, job status, assigned crane/crew, plan feasibility, confirmed jobs, crew availability, required adjustments, execution readiness, and acknowledgement status.

**Planning Efficiency:** Dispatcher must be able to plan the entire day without Excel. Planning should be fast, visual, and flexible.

**Decision Support:** System should assist with feasibility checks, conflict detection, and availability filtering instead of relying on manual thinking.

**Execution Readiness:** After planning, dispatcher should be able to move to assignment and ticket generation seamlessly without friction.

**Communication & Tracking:** Dispatcher should be able to notify crew and track acknowledgement within the system.

**Dependency Handling:** Permits/vendors should be visible, linked to jobs, and trackable.

**Flexibility Under Change:** Dispatcher should be able to easily modify plans, reassign resources, and adjust schedules.

**System Replacement Test:** Dispatcher should be able to run the full workflow without Excel or external coordination.

---

## **One-Line Summary**

System must fully replace Excel-based dispatch planning and enable end-to-end execution with real-time decision support.

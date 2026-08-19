---
title: AI-generated Meeting Action Items — 2026-03-06
source: user-supplied/meeting-transcript
original_file: "2026-03-06_AI-generated_Meeting-Action-Items.docx"
migrated: 2026-08-19
updated: 2026-03-06
status: reference
conflicts_with: []
jira: []
topics: []
entities: []
meeting_date: 2026-03-06
kind: auto-summary
summary_tool: unknown (AI-generated action items export)
---

# AI-generated Meeting Action Items — 2026-03-06

> Auto-generated action-item extraction, not written or reviewed by a human. There were two
> meetings on this date in the source folder (Sales-Quoting Figma demo, and the quote/project/
> job diagram walkthrough) — this export does not state which one it draws from. See
> `../transcripts/2026-03-06-sales-quoting-figma-demo.md` and
> `../assets/2026-03-06-quote-project-job-diagram-full.html` for the source material.

Meeting Action Items Checklist
TCG / CC Product Sync  —  March 6, 2026
Sales Quoting & System Design Review  |  Duration: 1h 46m
Attendees: Brian Petros, Ryan Adams, Melissa McNutt, Wes Staley, Umer, Ans Nisar, Ehtesham Anwar, Jahanzaib Nadeem, Wasim Ahmed

1.  DESIGN & USER EXPERIENCE  (Quoting Cops — Design Team)

Action Item
Owner / Team
Priority
☐
Prepare additional authentication screen design variations (solid background vs. white background) for client review and selection.
Design Team
High
☐
Define and design the Salesperson and Sales Manager dashboards — determine what KPIs, alerts, and quick-action widgets to display on each role's home screen.
Design Team + Brian / Ryan
High
☐
Update the Quote creation form: make the 'Select Unit' field more generic to also allow selecting People and Roles directly within the same form.
Design Team
High
☐
Add a free-text 'Add Item' button / plain-text line at the bottom of the line-item list in the quote to allow ad hoc items not in inventory (e.g., lift plan fee, certified payroll surcharge).
Design Team
High
☐
Add a Notes / Comments field per Lift Info entry within the Quote (not at the quote level — per individual lift) to capture special on-site instructions.
Design Team
High
☐
Update Lift Info to support multiple lift plans per crane and multiple cranes sharing one lift plan (for tandem lifts).
Design Team
Medium
☐
Add Mobilization / De-mobilization line-item structure to the Quote — where a lump sum is shown to the customer but internal breakdown (travel hours, build-up hours, etc.) is captured.
Design Team
Medium
☐
Add a Certified Payroll checkbox to the main Quote tab. When checked, expose a CPR Contact field and capture certified payroll-specific information at quote creation.
Design Team
High
☐
Add a CPR Contact field to the Customer profile so labor compliance can reach out directly without going through the salesperson.
Design Team
Medium
☐
Design a Certified Payroll Compliance Status tracker at the Job/Project level so labor compliance can update and report status across all CPR jobs.
Design Team
Medium
☐
Add an Attachments tab to the Quote creation flow — with separate upload paths for Lift Plans (specific type) and General Documents. Include drag-and-drop support.
Design Team
Medium
☐
Add a Permits section/flag to the Quotation — identifying permit type, lead time, and cost so sales staff are alerted to permit requirements at quoting time.
Design Team
High
☐
Design the customer-facing Quotation portal view — including the ability for the customer to sign, decline (with comments), or request a preferred start date/time after signing.
Design Team
High
☐
Update the Send Quotation flow to allow selecting multiple recipients (e.g., billing contact, legal contact) — not just the primary contact.
Design Team
Medium
☐
Add an option to send quotation as PDF via email in addition to DocuSign — with email reply tracking integrated into the Correspondence tab.
Design Team
Medium
☐
Consolidate all design feedback from this meeting and update Customers, Quotations, Asset Management, and HR module designs. Present consolidated designs by Tuesday's call.
Design Team (Ehtesham)
High

2.  SYSTEM ARCHITECTURE & BUSINESS LOGIC  (Dev Team)

Action Item
Owner / Team
Priority
☐
Introduce the 'Project' entity layer in the system data model — sitting between Quote and Job. A Project is auto-generated when a Quote is approved and can contain one or more Jobs.
Dev Team
High
☐
Build the Customer Price List feature: support (1) company-wide default pricing per unit and (2) customer-level price list override. When a customer is selected on a quote, auto-apply their price list if one exists.
Dev Team
High
☐
Implement a Pricing Group model: allow price lists to be defined at a group level, with one or more customers assigned to a group. A single customer can belong to one group.
Dev Team
Medium
☐
Build Asset / Inventory linking: allow a crane (unit) to be linked to a required companion crane in the asset management database. When a linked crane is added to a quote, auto-populate the companion crane (with ability to remove).
Dev Team
High
☐
Build the Resource Availability & Reservation engine: when a job is created and resources are assigned, the system should flag conflicts (green = available, red = conflict) and allow the dispatch manager to reserve a resource for a specific date range so it cannot be double-booked.
Dev Team
High
☐
Integrate Google Maps API for automated travel time calculation from yard to job site. Apply vehicle-type speed adjustments (truck vs. car). Factor in time-of-day traffic. Store average speed per asset in asset management.
Dev Team
Medium
☐
Add quote-to-job conversion flow: 'Convert to Job' button on an accepted quote creates a Project and initial Job. Also add a 'Create New Job' quick action to add additional jobs under the same project.
Dev Team
High
☐
Build the Quotation Status & Activity timeline: track all status changes (Draft, Sent, Awaiting Signature, Signed, Declined, Converted to Job), last viewed by customer, and communication history.
Dev Team
High
☐
Implement DocuSign integration for quote sending, signature capture, and status updates. Also support PDF-via-email send with reply tracking.
Dev Team
High
☐
Build quote pending/overdue alert system on the salesperson dashboard — surfacing quotes that have been pending beyond a configurable threshold (e.g., 1 week, 2 weeks) without being marked won/lost.
Dev Team
Medium
☐
Build customer inactivity alert: notify sales manager when a customer has not placed work in X days (configurable threshold — Melissa to define appropriate timeline).
Dev Team
Medium
☐
Build historical job location memory per customer: allow prior job site addresses to be recalled/auto-suggested when creating a new quote for the same customer.
Dev Team
Low
☐
Add industry and location (city/county) fields to the Customer profile for revenue reporting by segment.
Dev Team
Low

3.  THIRD-PARTY INTEGRATIONS

Action Item
Owner / Team
Priority
☐
Confirm Samsara (telematics) API availability and scope integration — pull vehicle location and activity data into the dispatch/job level to verify employee hours vs. reported time. (Jahanzaib confirmed APIs are available.)
Dev Team + Melissa
High
☐
Melissa to send the name / details of the telematics solution (Samsara confirmed) to the dev team so API documentation can be reviewed.
Melissa McNutt
High
☐
Evaluate CRM integration options (HubSpot and/or Salesforce). Ans to schedule a call with Ryan Monday to review the features being proposed by Salesforce/Planhub and assess what can be built natively into the platform vs. purchased externally.
Ans Nisar + Ryan Adams
High
☐
Ryan to share current B2B lead generation program data with the dev team — to assess what customer/prospect data can be captured and integrated into the customer database.
Ryan Adams
Medium
☐
Explore integration of Planhub (B2B lead gen) and CRM prospects into the platform's customer pipeline view — supporting prospect → customer conversion workflow.
Dev Team
Medium
☐
Evaluate permit database integration: leverage RCS/Roadway permit data for permit types, lead times, and costs in the Southern California region. (Wes Staley approved use of RCS data.)
Dev Team + Wes Staley
Medium
☐
Explore open-source CRM alternatives for internal deployment to avoid ongoing SaaS subscription costs — Ans to prepare a proposal for the team.
Ans Nisar
Medium

4.  SAFETY MODULE  (Future Phase)

Action Item
Owner / Team
Priority
☐
Design a Safety Module dashboard for the safety team: list of jobs to inspect, daily schedule routing (optimized by location), and ability to log inspection results (pass/fail checklist, photos, video, comments) directly within the job.
Design Team
Medium
☐
Build safety audit form within the Job: 3-item pass/fail checklist, 4 photo uploads, 1 walk-around video upload — results tied to the specific job and accessible from both the job view and safety dashboard.
Dev Team
Medium
☐
Implement route optimization for safety inspectors: system suggests the optimal order of jobs to inspect based on the inspector's starting location and travel times.
Dev Team
Low
☐
Build safety compliance reporting: allow safety team to generate and send safety audit reports to customers (e.g., SoCal Edison). Track audit notes at the job level.
Dev Team
Low
☐
Implement scale/skills-stop notification: when a crane's route to a job site passes through a weigh station / skills check, automatically notify mechanics to pre-inspect the crane.
Dev Team
Low
☐
Build crew visitation frequency tracker: alert safety team when a crew has not been visited on-site within a configurable number of days, independent of job-specific inspection requirements.
Dev Team
Low
☐
Integrate Samsara driving behavior data into safety portal: flag speeding, hard accelerations, and hard stops — alert safety team and track incidents per driver.
Dev Team
Low

5.  CLIENT ACTION ITEMS  (TCG / Brian Petros' Team)

Action Item
Owner / Team
Priority
☐
Brian / Ryan to provide approval to kick off development by Monday so the team can start setting up DevOps pipelines, basic code architecture, and base frameworks.
Brian Petros
High
☐
Provide current Quote templates (PDF layout, fields, formatting) and email templates currently sent to customers — needed for the customer-facing quote portal and PDF generation.
Melissa McNutt / Brian
High
☐
Provide current Pricing templates / rate sheets — default pricing and any customer-specific price lists (e.g., Edison) currently in use in FCC.
Melissa McNutt
High
☐
Melissa to define the appropriate inactivity threshold (number of days) for the customer inactivity alert feature.
Melissa McNutt
Medium
☐
Ryan to share Salesforce and Planhub pricing / proposal details with Ans Nisar for CRM evaluation and comparison.
Ryan Adams
High
☐
Ryan to share B2B lead generation program details and current data with the dev team for integration scoping.
Ryan Adams
Medium
☐
Melissa to send the name of the telematics solution (Samsara) to Ans / dev team via Teams.
Melissa McNutt
High
☐
Brian / TCG team to provide structured sample data for Asset Management (cranes, linked equipment, tools & rigging) to seed the inventory module.
Brian Petros / Wes Staley
High
☐
Confirm and document the CPR (Certified Payroll) workflow currently tracked on the separate Excel spreadsheet — to be migrated into the system's compliance tracker.
Melissa McNutt
Medium
☐
Brian / Wes to confirm approval for the dev team to reuse applicable data and module designs from the RCS (Roadway Construction Safety) system.
Wes Staley / Brian Petros
High
☐
Have a follow-up discovery session for the Asset Management (Units / Cranes) and HR / Employees modules — designs to be presented by Tuesday's call.
Brian + Dev Team
High

6.  DEVELOPMENT KICKOFF & PROCESS

Action Item
Owner / Team
Priority
☐
Dev team to set up development pipelines, base code architecture, and initial DevOps infrastructure starting Monday pending Brian's approval.
Dev Team (Wasim)
High
☐
Schedule bi-weekly sync meetings (minimum 2x/week) — one for module discovery/design review and one for sprint progress / milestone updates.
Ans Nisar + Brian Petros
High
☐
Introduce Sprint Review and Sprint Planning meetings into the recurring cadence going forward.
Dev Team (Ehtesham)
Medium
☐
Present consolidated designs for Customers, Quotations, Asset Management, and HR modules on Tuesday's call. Finalize all four module designs by Thursday/Friday.
Design Team (Ehtesham)
High
☐
Dev team to send the full list of development resources (team members / roles) required to begin development for Brian's approval.
Ans Nisar
High
☐
Ans to schedule a dedicated CRM solutions call with Ryan Adams to present CRM options (including open-source alternatives), map required features, and recommend a path forward.
Ans Nisar + Ryan Adams
High
☐
Schedule a whiteboarding session with all stakeholders to map all requirements before committing to architecture decisions on modules not yet discussed.
Ehtesham + Brian
Medium
☐
Plan a phased rollout strategy: Phase 1 = mirror existing FCC functionality (customers, quotes, jobs) so TCG can begin transitioning away from FCC within ~6 months; subsequent phases = project layer, safety, CRM, analytics.
Ans Nisar + Brian Petros
High

Priority Legend:
■ High   — Required for Phase 1 / development kickoff or imminent decision needed     ■ Medium   — Important but not blocking Phase 1 start     ■ Low   — Future phase / nice to have
Generated from meeting transcript: TCG CC Product Sync — March 6, 2026

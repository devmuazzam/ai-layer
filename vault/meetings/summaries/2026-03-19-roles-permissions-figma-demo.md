---
title: Roles Permissions Figma Demo — 2026-03-19 (Read.ai summary)
source: user-supplied/meeting-transcript
original_file: "2026-03-19_Roles-Permissions_Figma_demo -Read AI summary.txt"
migrated: 2026-08-19
updated: 2026-03-19
status: reference
conflicts_with: []
jira: []
topics: []
entities: []
meeting_date: 2026-03-19
kind: auto-summary
summary_tool: Read.ai
---

# Roles Permissions Figma Demo — 2026-03-19 (Read.ai auto-summary)

> Third-party AI-generated summary produced by Read.ai at capture time — not written or
> reviewed by a human. See `../transcripts/2026-03-19-roles-permissions-figma-demo.md` for the full transcript this
> summarizes.

TCG | CC Product Sync
Thu, Mar 19, 2026

Summary:

The meeting reviewed the portal UI and implementation approach for departments, roles, and permissions, focusing the scope for initial development. Brian demonstrated a Python script that reorders items and captures FCC screenshots, and reported using AI to draft content from those images for review; the team agreed mock data is not a priority and mockups are illustrative while functionality is primary. Ehtesham presented a departments-first design in which each department contains roles and linked users, with roles owning module-level permissions and quick-start templates for common role types (manager, admin, editor, viewer, contributor, guest).

Discussion covered permission granularity and scope trade-offs, including global versus department-scoped roles, handling employees with multiple roles and temporary/contractor status, and payroll integration concerns flagged for HR follow-up. The group agreed permissions are managed at the role level and can be extended to finer-grained module controls later. The team also defined yard-based data partitioning: company-level access spans all yards, owners can access multiple companies, employees are generally yard-restricted, and dispatch may select assets from other yards while logging deviations for travel-time and billing. Agreed system components include a simple extensible help-desk/ticketing workflow, Google Maps distance/time integration, mobile check-ins for ETA refinement, and a templatized architecture to support future extensions.

Chapters & Topics:

Script, screenshots, and meeting setup
Brian described a Python script he built to reorder items and generate FCC screenshots for comparison, and reported that AI reviewed those images to produce content for review in the next meeting walkthrough. He confirmed the schedule to walk through screens in the upcoming meeting.
* Brian provided a Python script and FCC screenshots to seed comparison materials and used AI to analyze the images for tomorrow’s walkthrough.

Development focus and scope (functionality vs data)
Ehtesham and others reiterated that functionality is the priority over mock data and discussed the future ability to create templates and custom fields so data can be added later. The group agreed to focus on the pieces required to feed into sales quoting as the initial process.
* The primary development priority is implementing system functionality, not populating production data or perfecting mock data.

Employee-related scope and payroll introduction
The team introduced Corrina (payroll/HR manager) to the call to capture payroll requirements, noted payroll logic complexity and union rules, and raised that employee onboarding and related employee work will be significant future work.
* Payroll logic and differences between regular and temporary employees require input from Corrina and additional design consideration.

Departments and roles design overview
Ehtesham presented the departments view where users create departments (code, name, description), manage department roles and linked users, and view role summaries; modules and permissions are listed and can be pre-selected with quick-start templates.
* Departments will be the container for roles and linked users; roles will hold permissions for modules.
* Quick-start role templates (manager/admin/editor/viewer/contributor/guest) will be provided to pre-select common permissions.

Role creation, templates, and permission levels
The team discussed role creation flow, permission levels (no access, view only, edit, full), examples of using templates for managers, and that each role will show associated user counts and a permission accordion for review.

Role vs department decoupling and multi-department users
Participants debated whether roles should be independent of departments or encapsulated under departments; suggestions included creating department administrators or having roles be reusable across departments, and that multiple roles could be assigned to a user to handle cross-department responsibilities.
* The system will support assigning multiple roles to a single employee when necessary.

Permission granularity and special cases
The group discussed granular permission needs (e.g., field-level or pricing visibility within quotations and asset management) and agreed the structure can support additional module-level permission chips later; the current plan is role-level control with the ability to expand granularity as required.
* Permissions are designed to be managed at the role level, with the ability to add more granular module permissions later.

Permissions scope and diagramming the org/yards/modules
The team discussed how permissions should reflect company and yard visibility and whether yards need distinct security rules. Brian offered to create a diagram of companies, yards, and modules to determine what should be siloed versus shared and to guide permission design.
* Brian will create a diagram showing companies, yards, modules, and proposed segregation to inform permissions decisions.
* Ehtesham will add yards and related permissions into the modules/permissions master list.

Access rules for employees, ownership, and multi-company visibility
The group clarified that employees will generally be limited to their yard, owners can view multiple companies, and company-level users have access to all yards within that company; Melissa raised concerns about keeping yard assets separate for operations and reporting.
* Company-level access will grant visibility to all yards within that company, while different companies remain separated.
* Employees should be restricted to view and select assets only for their assigned yard unless they are owners or admins.

Implementation approach for yards, tenant model, and quoting behavior
Participants recommended keeping yard as an attribute now and converting to a tenant/dashboard model later; quotations should be tied to a yard while dispatch can select assets from other yards, with those changes logged to adjust travel time and billing.

IT support, ticketing, and approval workflows
Ryan proposed an IT tab and request/approval flow to track permission changes and issues; the team agreed to include an IT/help-desk ticketing system in the portal with staged rollout and analytics on ticket lead/completion times.
* The team will implement a help-desk/ticketing system and an IT request/approval workflow within the portal.

Dispatch, geofencing, ETA tracking, and integrations
The team agreed to allow dispatch-specific assignment of yard per item, to record asset origins, and to integrate Google Maps plus mobile check-ins so estimated and actual travel times can be compared to improve future ETAs.
* Dispatch must be allowed to change the asset origin yard and those changes should be recorded for travel-time and quoting adjustments.
* Google Maps integration will be used to calculate exact distances and estimated travel times between yard and job locations.
* The portal should capture estimated arrival and actual check-in times to build historical ETA accuracy over time.

Employee types and temporary employees process
The meeting reviewed employee categories: full-time, salaried, and temporary fill-ins; temp employees will be recorded in a separate tab, activated when assigned to a job, and tracked for payroll and timecards with comments for short-term fills.

HR data flow and temporary-employee handling
The team clarified how dispatch provides information to payroll and processing and concluded dispatch users must be able to create temporary employees in the system. Conversation introduced HR items (probationary/full-time flags, reviews, birthdays) and noted these features are desired but lower priority than core functionality.
* HR features such as probationary status, reviews, birthdays, and certifications are requested but will be lower priority than core dispatch and job-processing features.
* Dispatch will supply payroll with temporary-employee information, and dispatch users must be able to create temporary employees in the system.

Scope and prioritization of HR functionality
Brian raised whether to plan a dedicated HR focus or integrate HR features module-by-module; Corrina was asked to list HR-related items like certifications and birthdays to decide what to address now versus later. The team leaned toward integrating HR incrementally while noting some items may need a specific planning session.

Extensibility for yards, unions, and trades
Wes emphasized multi-yard growth with differing union and trade needs and requested a way to encode working rules and codes per person and yard. The dev lead confirmed a templatized approach with roles, permissions, and later addition of trades to avoid redeveloping modules.
* The system must support multiple yards, union types, and trade-specific working rules to reflect varying local staffing needs.
* The system will be built templatized so roles, departments, and trades can be extended without redeveloping modules.

Infrastructure, GitHub, and DNS requirements
The team recommended AWS but remained open to Azure/GCP, and reminded the group that GitHub and a cloud account are required. Brian confirmed the GitHub organization is set up, IT Support reported hosting work in progress, and the devs requested DNS record access for portal and staging links.
* Brian has created a GitHub organization for the project and granted access.
* IT Support is building hosting and will hand it over when ready; DNS access will be required to add portal and staging links.

Prioritization process, follow-ups, and schedule
Joe asked about handling evolving requirements and curveballs; the dev lead described a prioritization process that captures all ideas, implements must-haves first, and converts many future requests into configurable items. The team agreed to hold an internal meeting with Brian, and scheduled development updates next Tuesday and project/jobs updates by next Thursday.
* The team will prioritize capturing all feature requests, then convert many requests into configurations to reduce future development cost.

Action Items:

* Brian Petros will walk through the different screens and screenshots in the next meeting walkthrough
* Corrina will explain the process and distinctions between regular employees and temporary/contractor employees after the departments/permissions discussion
* Brian Petros will create a diagram showing companies, yards, modules, and proposed segregation for permissions
* ehtesham.anwar will add yards and related permissions into the master modules/permissions list
* jahanzaib.nadeem will implement yard-based visibility restrictions in the employee, quotation, and related modules so only assets belonging to the selected yard appear
* ehtesham.anwar will incorporate an IT request/approval tab within the portal to submit and track permission and IT issues
* ehtesham.anwar will implement an initial simple ticketing/help-desk system that routes tickets to departments and captures analytics
* ehtesham.anwar will deliver the first mock-up of jobs and projects by next Thursday
* jahanzaib.nadeem will integrate Google Maps (or equivalent) to calculate distances and travel times between yard coordinates and job locations
* ehtesham.anwar will incorporate mobile check-ins and record estimated vs actual arrival times to build historical ETA accuracy for dispatch planning
* Brian Petros will send the mock-ups to Corrina for review of employee/temp employee requirements
* Brian Petros will check hosting details with Patrick
* IT Support will hand over the hosting environment once the majority of it is built or finished
* IT Support will provide access to the DNS records for the TCG website so the dev team can add portal and staging links
* Meeting participants will hold an internal meeting with Brian tomorrow to process requirements and reprioritize features
* The development team will provide development updates at the next meeting on Tuesday
* The development team will provide updates on project layer and jobs layer by next Thursday
* Brian Petros will record the internal meeting tomorrow and share the recording with the team

Key Questions:

* Should roles be created within each department or should roles be an independent module that can be associated with multiple departments?
* How does the system distinguish employees from other types of people, such as contractors or customer contacts?
* If two employees share the same role, can one employee have tweaked permissions different from the role default?
* How will organizational hierarchy (multiple organizations, companies, or yards) affect roles and permissions?
* If an employee is associated with Yard A but has permission to "view all," does that grant them access to all yards in the organization or only their yard?
* Can a dispatch manager change the yard or select an asset from a different yard when dispatching a quotation assigned to another yard?
* Is each yard associated with a single address/geo-coordinate for distance calculations?
* Can estimated arrival times and actual arrival times be correlated over time to improve ETA accuracy?
* What employee types need to be supported beyond full-time and temporary?
* If requirements or "curveballs" appear during development, are adjustments typically major rework or manageable changes?
* How can the client help the dev team be more efficient with information and requests?

Notepad:

* No notes

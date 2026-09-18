---
title: 17Sep Internal UAT
source: confluence/TCG/17Sep Internal UAT
source_page_id: 174850050
source_url: https://the-crane-guys.atlassian.net/wiki/spaces/TCG/pages/174850050/17Sep+Internal+UAT
source_author: Fouzan Shakil
session_date: 2026-09-17
source_last_modified: 2026-09-17
migrated: 2026-09-19
status: unverified
conflicts_with: []
jira: []
tags: [module/all, kind/source, requirements, open-questions]
---

**Yard**

* Restore functionality for archive is not working properly, name unique is implemented here. Need to check on other places as well
* In-active and archive yard shouldn’t popup anywhere, test throughout the application
* if no expiry in attachment it should be valid by default (tested on yard but need to check throughout the application)
* In yard, the mailing and physical address are being flipped in default state while editing

**Checklist**

* Checklist view should follow the app header theme
* Checklist view list → Go back to checklist option should be at top

**Union-Code**

* Need an option to in-active

**Loss Reasons**

* remove status field

**Craft Code**

* Description shouldn’t be truncated in craft code detail on right side panel
* When adding rate, if the previous date shouldn’t have an effective date so it should add the new rate effective to date to that previous rate and shouldn’t throw an error
* Assign user, primary should only show the employees of the role which is selected during craft code creation
* Search Employees is not working for full name

**Craft Modifiers**

* Need to attach a union
* Remove add row from top

**Payroll Premiums**

* Need to validate the lattice boom premium with craft code groups

**Agencies**

* Permit Submission → Submission Type: email → need to show an email field

**Categories**

* Category Code validation should be on FE first

**Sub-Categories**

* T‌arget Hours Per Month validation error is not showing
* When creating category from sub-category, the field should be disabled
* Need to validate the count of attribute tab when a sub-category is created

**Asset**

* Creating asset, **Additional Info** show unsaved changes even they were added while creating asset
* Attachment deleted successfully showing success message in red (need to change throughout) Success should be green, error in red and warning in yellow

**Tools & Riggings**

* Field value is being saved in negative value
* Need to see the barcode functionality
* Unit check should be based on type

**Customer**

* Customer contact email should be required, and validation should be active for uniqueness

**Quotation**

* Unit Meas: should not be empty (this validation should be on frontend) and error message should say the proper field name
* Need to see mapping of additional info
* Need to remove email pop-up if requesting for approval (tested as a salesperson role)
* the person initiating the action shouldn’t receive notifications (test throughout the application)

Permits/Plan/PO

* Mark Application Submitted → Submitted to should be a dropdown for agency
* PO/Permit/Plan need to research
* Button shouldn’t be enabled if all the required fields are not added
* Have all the errors on the BE and FE

DAS

* Need an option to change craft code and option to change
* Primary craft code should be of the employee type

Yard Operation

* When a tool is dragged, in the modal, select tool name is not selected

**Low Priority**
\- Attachments should be saved in activity logs

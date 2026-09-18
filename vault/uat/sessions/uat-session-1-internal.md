---
title: UAT session 1 ( Internal )
source: confluence/TCG/UAT session 1 ( Internal )
source_page_id: 170229761
source_url: https://the-crane-guys.atlassian.net/wiki/spaces/TCG/pages/170229761/UAT+session+1+Internal
source_author: Umair Khan
session_date: unstated on the page
source_last_modified: 2026-09-14
migrated: 2026-09-19
status: unverified
conflicts_with: []
jira: []
tags: [module/all, kind/source, requirements, open-questions]
---

# **Discussion Points & Action Items**

### **Roles, Departments & Employees**

* We should maintain the relationships between **roles and departments**.
* Confirm the relationship between **departments, roles & crafts, and employees**.
* Figure out the **Yard hierarchy/parent logic internally**.
* Confirm the pending **departments and roles** with Corinna. TCG team to follow up.
* **Departments should be editable.**
* Take a decision on the **archival approach**. For now, we can assume it will be a **soft delete**.

### **Categories & Subcategories**

* While creating a **Category > Subcategory**, the Category dropdown still shows **Mobile Crane** even after it has been archived. Archived categories should not be displayed.
* The **Checklist Type** is currently hardcoded and needs to be fixed.

### **Assets**

* Remove the **Barcode** field from **Assets > Create**.
* Under **Create Assets > Rates**, the **Invoicing Hourly Cost** field can be removed if we do not know why it is being used.
* The system is currently a bit slow and needs to be **optimised for better performance**.

### **Job Sites**

* Remove the **Status** field from **Add Job Site**.

### **Quotations**

* Under **Resources > Positioning**, when hovering over any line item (e.g., Oiler), there should be an **Add New Item** option.

    * **Umer to provide the design for this.**

* Remove **Surcharge** from the line item, as the line item is only applicable to the quotation.

    * **Discussion with the team is required to confirm this.**

* The **Billing Code default rate** should not be zero. Please add a restriction to prevent this.
* Under **Edit Billing Code > Flags and Surcharge**, the checkbox behaviour needs to be confirmed/figured out.
* Confirm with the client whether there is any relationship between **Employee Billing Code and Employee Pay**.
* Under **Resources**, remove the **Amount Total** column that appears on hover.
* Under **Resources > Amount**, the surcharge should only be displayed when hovering. When clicked, it should be marked as **Non-Surcharge**.
* In the **Quotation Email**, the PDF shows an incorrect total quotation amount, and the document does not match the expected quotation.
* On **View & Sign Quote**, an error is displayed when the customer clicks the option. This needs to be fixed.
* **Umer to provide the required states**, e.g., **Sent Quote to Customer, Upload**, and send them to the development state.
* **Request Changes** button — internal discussion is required.
* When a quotation is won, a popup should automatically appear with a **Congratulations** message and options to **Create Project** or **Add to a Project**.

### **Scheduling**

* The **Start Date and End Date** should be populated automatically in the Schedule.
* If someone selects **Saturday**, the Start Date is not shown below and the option to automatically include Saturday is not working correctly in **Edit Schedule**.
* Under **Apply Times to Multiple Days** in Schedule, remove the **collapse/expand** functionality to improve the user experience.

### **Planning & Permits**

* **Tool & Rigging allocation** will be done by Listtee and will come from the quotation.
* In **Yard**, there will be phases such as **Loadout**, etc.
* UI change request for **Requests for Plans and Permits**: show a **consolidated view** in the tracker for Permits and Plans.
* **Planning Tracker:** The current Kanban board flow is incorrect.

    * **Umer and Haris to discuss.**

* If a plan is in the **Cancelled** board, and someone tries to link it through **Quick Access** on the Main Project page, it should not allow the linking. Currently, it is being linked successfully.

### **DAS**

* In DAS, jobs scheduled on **weekends** are not being displayed. This needs to be fixed.
* In DAS, the **Recommendation** section is unnecessarily showing the **Operator Load**.
* In DAS, **Sales Persons** should not be displayed in the **Employees** tab.
* There is a redirection issue when moving from the **Checklist in DAS to the Planning Tracker**. The current flow has too many steps and should be simplified.
* A **Copy Allocation** button is required in DAS, even when the job has been sent.
* Add a **Cancel Job** option under the three-dot menu in DAS.

### **Yard Operations**

* Fix the **Tool & Rigging** adding flow, including **drag-and-drop**, and ensure it works properly.
* The **right-side panel/bar for Tool & Rigging** does not match the design and needs to be fixed.
* When selecting **Start Loadout**, all checklist items should **not automatically be marked as selected**.
* There is currently no functionality to **add a picture**. This functionality needs to be added.

---
title: UAT Session 2
source: confluence/TCG/UAT Session 2
source_page_id: 170360833
source_url: https://the-crane-guys.atlassian.net/wiki/spaces/TCG/pages/170360833/UAT+Session+2
source_author: Umair Khan
session_date: 2026-09-09
source_last_modified: 2026-09-14
migrated: 2026-09-19
status: unverified
conflicts_with: []
jira: []
tags: [module/all, kind/source, requirements, open-questions]
---

# **UAT Session – 9th September**

## **Login / General**

* The next character is written and then hidden. Apply this validation on the App login page.
* The ticket is for the previous day, and the weather is also being shown for the previous day. The weather should be shown for the current date.
* The date should be visible on the ticket, whether it is for the current or previous date. Umer to figure out the best approach, e.g., adding a filter.
* The app is being refreshed every time. Dev team to check this.

## **Web**

* If nothing is added under **Create Quotation > Resources**, there is no need to show the **"Add New Item"** option.
* Changes made to the associated assets do not reflect in the resources. It was discussed that this is not dynamic; the changes were shown only after refreshing.
* The surcharge shown under the amount does not work properly. It is not possible to hover over the surcharge and select/catch it.
* The colour and spacing need to be worked on in **Resources**. Team to coordinate with Umer.
* Figure out the permit functionality in **Resources**. Product team to figure this out. **Not to be included in the 15 September deadline.**
* In **Contacts > Customer**, we are unable to move forward by clicking **Next**. It keeps repeating in a loop, and there is no **Back** option.
* The running total is shown in the **Edit Customer Profile**. It needs to be removed.
* In the main KPIs, remove **Credit Limit, Revenue, and Pipeline** as they are showing the same values.
* Remove the **Running Total** from Quotation as well.
* If there is a **Next** button, a **Back** button should also be added during the creation of quotations and customers (**overall**).
* In **Quotation > Attachments**, there is an error: **"Customer PO: Customer PO should not exist."**
* **Travel Permit** was automatically enabled during quotation creation. We need to figure this out.
* In **Quotation > Tools & Rigging**, the quantity should allow users to add more than the maximum value set. However, a warning message should be displayed.
* Fix and update the UI of the boxes under **Projects > Permits and Plan**.
* In **Job > Scheduling**, the 5 AM slot is for the next day. For the next day, show the date slightly below it.
* In **DAS**, fix the font size. It should scale automatically.
* In **Pre-Job Checklist**, clicking a link should open it in a new tab.
* When clicking on the **Lift Plan** in the Pre-Job Checklist, the plan should go into the tracker.
* **DAS > Pre-Checklist > Permits and Plan Status:** DAS should follow the colours based on the status. For example, if the status is **Draft**, it should show the designated Draft colour.
* **Copy Allocation** should be visible after sending the ticket in the DAS module.
* When clicking **Save Allocation** in DAS, apply the same styling to the **Send Ticket** button.
* In **Copy Allocation**, if today is 9 September, the current date should not be shown in the popup. It should show the next day, e.g., **10 September and onwards**.
* On the last day of the shift, do not show the **Copy Allocation** button.
* **Holdover** functionality should be discussed instead of Copy Allocation, but this is the lowest priority.
* There is no push notification when sending the ticket.
* In DAS, Brian was assigned as an oiler, but another oiler appeared who was not selected. On hover, some employee profile information is also displayed.

## **Mobile App**

* When the field app was closed, the user was automatically logged out. The user should not be logged out when closing the app.
* Add a **Start Work** button in the banner when there are ticket steps. If the user clicks on the notification, they should land on the same page.
* By default, no option should be selected as **OK** in the Pre-Inspection Checklist.
* When adding photos, there should be an option to remove/delete an added picture.
* **Start Work** was not retained when the app was closed. **Mobile App.**
* In the customer's first signature, when the signature...
* In the **Terms and Conditions**, add an indication that the content can be scrolled.
* In the **JSA Checklist**, make it a flat list and only show the questions.
* Add **Build-Up Complete** and **Start Work**.
* Remove the **Boom Time** terminology from Step 7.
* From **Build-Up** to **Break Time**, everything should be considered Boom.
* Remove the **Boom Time Running** step.
* In **Step 7**, move **Report Incident** to **Emergency SOS**.
* The **Identity Photo** should be LIVE.

## **Payroll Management – Web**

* The ticket is not visible in the **Weekly Payroll**.

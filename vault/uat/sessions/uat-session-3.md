---
title: UAT session 3
source: confluence/TCG/UAT session 3
source_page_id: 170491905
source_url: https://the-crane-guys.atlassian.net/wiki/spaces/TCG/pages/170491905/UAT+session+3
source_author: Umair Khan
session_date: unstated on the page
source_last_modified: 2026-09-14
migrated: 2026-09-19
status: unverified
conflicts_with: []
jira: []
tags: [module/all, kind/source, requirements, open-questions]
---

### **Assets Management**

* Serial Number and VIN to be separate fields.
* Only Unit Code should be one unique identifier.
* In Resources > Quotation: Billing Code default is set to 0. If the Billing Code is \[0\], the Billing Code should not be created.
* If I am on Quotation > Resources and have added line items, if I click on any other module on the bar, e.g., Yards, Agencies, etc., there should be a warning message.
* Resolve the cache/reload issue throughout the app.
* Quotation module > Remove the "Margins" name column on Resources and Line Items in the Resources view.
* In the Total Value field in Resources, there should be exact decimal values. There is no need to round off the value in it.
* Add the Job Walk tab after quotation creation and write "Coming Soon!!"
* In Print View:

    * The Internal Use section should be removed.
    * Remove the Adjustment column as well.
    * Review the Billing Type field.
    * Quote Print: The reason for internal approval needs to be removed as well.

* Extract the FCC quotation print view and verify it and find the Terms and Conditions text. Need comparison of FCC and the new ERP — pending on Umr.
* In Quotation, in the \[Others\] section on the right side, add a "Mark as Won" manually option even through DocuSign.

    * He can mark it as won manually even if he hasn't sent it through any source.

* Remove the example in the Billing Codes module listing page, e.g., "$34 → $37/hr" on the top-right side.
* In POs, set the UI for Customer PO.
* In Project Creation, if we don't have a PO, under Project Name, give a PO field — Umr.
* PO state will be changed based on Vendor state.
* Operator Load Configuration needs to be made better — discussion required.

### **DAS**

* Discussion required on the Employee Role Mismatch popup issue on the Oiler slot in DAS.
* Permits are in an Open state, but on the Pre-Checklist, they are shown as green.
* On Copy Allocation popup, fix it by giving a scrollbar and showing the number of selected days and the total number of days for user clarity.
* "Include Sundays in Schedule" was ON, but the Sunday date was not visible in the listing below it > Edit Schedule.
* In the Pre-Job Checklist, if anything is required or open, we have to show a warning.
  Make the Edit Schedule text and buttons stickable. Change it theme-wise; Dev to assign a proper person to it > Edit Schedule.
* If a weekend is selected in the date, that day should be visible in the listing below in Edit Schedule > Project.
* Rigger was removed in Resources > Quotation, but it is shown in the Project as an amount of 0 while viewing it.

### **Atom Mobile App**

* There is no option to reset the password on the Atom Mobile App. Add it.
* In Job Reminder Email > Job Details > At Job Site, give the address for it.
* On the Send Ticket, the email should be shown.
* Issue: Oiler added on 12 September was shown on the 12th, but when the user navigated to 14th September, it was not shown on the other days. We have to fix it.

### **App Issues**

* Fix the Mobile Home UI for it. Add some KPIs, e.g., hours or quick actions.
* On the Listing Page, when we navigate through a notification, add details of the job where ticket steps are shown in case the work time has not started.
* In DAS, when a ticket is sent by the button, the button should change to "View Progress," and it should take you to Project > Progress Tracking page
* The start work button is shown on the previous ticket in App , it should not be shown .
* ETA and distance is hardcoded in driving to the site screen . Fix that guys .
* List of data required that's on screen but not functional  - required from dev
* Live feed of photo - captured when you are signing or at end - Automatic

    * _As per discussion with Umar bhai, photo capture functionality will stay as it is with one addition that it will be required._

* Terms and conditions - selection of checkbox bugs.
* The compliance checklist and labour unit and details are wrong - fix it

Additional Feedback from Umar bhai:

* Add image preview modal with re-take and delete photo option
* Add customer not available and customer leaving before crew option in customer first signature screen as well
* In customer signature photo take, provide remove photo option
* Update ticket code to reflect FCC pattern

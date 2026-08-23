---
title: Customer
source: confluence/TCG/Customer
migrated: 2026-08-10
updated: 2026-07-16
status: unverified
conflicts_with: [customers/customer-and-job-sites.md, assets/user-story-and-tasks.md]
jira: []
topics: [documents-attachments, job-sites, customers, scrum-process, reporting, quotations, permissions-roles, navigation-ui]
entities: [attachment, job-site, field-ticket, customer, industry-code, quotation, employee, vendor, agency, tool-rigging]
---

1. need to change the ? button color, make it consistent
2. make filter design consistent as its in [[quotations/quotations-INDEX|quotation]] module **(across the app)** [**ticket**](SCRUM-652
3. Pagination selection rows dropdown need to be update
4. move pagination , filteration searching(debounce) on backend **(across the app) todo**
5. in activity column, more than 1week icon color should be red
6. we should move the email below the [[customers/customers-INDEX|customer]] name instead customer code and should move customer code in separate column**(across app) (under discussion)**
7. Populate the actual data in Revenue column instead hardcoded data **todo**
8. Need to enable the forecast aslo gather the requirement from **client todo**
9. need to make the logic/rule for pipeline amount, needs attention and  top account **todo**
10. need to slim the PG hero(main header), reduce its height **(across the app)** [**ticket**](SCRUM-652
11. In quick filters above the search bar there must be archived filter**(across the app)** and in customer replace it with recently added filter [ticket](SCRUM-652
12. In action column instead 3 dots, pop their options out  and show their icons to avoild multiple clicks **(across the app)** [**ticket**](SCRUM-652
13. In status column Inactive pill color should be red instead instead grey **(across the app)** [**ticket**](SCRUM-652
14. in view page bottom border need padding as design is getting disturb
15. **We will remove the edit customer button and replace it with archive button, also will update the edit flow:**

    1. Need to update the edit flow, it should be tab wise  **(across the app)** in main tab pencil icon on each section , even one section icon clicked all should be editable **todo**
    2. need to update contact flow for edit (in case of contact we will handle creation , deletion, updation in same screen) **todo**
    
16. at the time of edit we need to remove the save draft button **(across the app)** [**ticket**](SCRUM-652
17. Add draft functionality **(across the app) todo**
18. on attachment view page give button to upload the attachment **(across the app) todo**
19. on note view page, there should be by default button to add new note instead clicking edit and then clicking add new note button and same thing for the jobsite tab by defaullt add jobsite button on view page as well and same for **attachments todo**

    1. notes view need to be updated (design) **todo**
    2. 
    
20. **FINALIZED APPROACH for notes, contacts, attachments and jobsite: **on contacts, notes,jobsite,attachment view pages we ll give button to add button ( single record data) edit and delete button on that specific record(as its on notes record) , **todo**
21. in case of customer create and edit, need to show the revenue ribbon as showing in quotation named as “running total”, also need to add this ribbon on listing page above table **todo**
22. in credit limt zero should be placeholder instead the value
23. in case of create once even few data filled in form and user click oustide in navigation to go to anyother module it should show poup whill will ask do u want to save or save draft or cancel. **todo**
24. need to update the field highlight color from purple to blue **(across the app)** [**ticket**](SCRUM-652
25. need to add the **industry code CRUDS** in setting, also with industry code field give the arrow icon on clicking it 1st as do you wanna save or save draft and redirect it industry code page **todo**
26. taxable dropdown should be same as we are using for industry code  , currently not giving remove option in it
27. Make the dropdown field consistent **(across the app) todo**
28. need to check the save validation if on first page u say save and in 2nd tab something is required then should throw validation error **todo**
29. in 2nd tab po and insurance checkboxes design update, replace with toggles (ux) **todo**
30. give navigation icon on pricelist and billing term field in 2nd tab(ux) **todo**
31. we should allow one column to pin on horizontal scroll **(across the app) todo**
32. need to give tag option u can apply tag **(across the app) todo**
33. in change status we dont need the draft (on bulk click in top row) **todo**
34. in bulk selection while performing any action there must be an alert popup **todo**
35. save note and save jobsite edit should be same as contact edit, no need for save note button **todo**
36. needed activity logs for contacts,jobsite and notes **todo**
37. add jobsite tab at the time of creation as well **todo**
38. need to add billion trillion **todo**

* Billing contact chow page UI
* Remove import button

    * Remove ? tooltip
    
* Top accounts – need to discuss with TCG team
* Need attention – same 
* Pipeline value 
* Sales person should be pre populated in case when sales dept person is logged in 

    * Sales – all roles 
    
* Sales person should be required
* Pipeline value should not be hard coded
* Revenue colum - hard code issue
* Remove select text – unclickable row issue
* Tooltips are very slow
* Show page - industry code – show complete text
* Attachment - show poage – add abiluty to directly add attachment
* Attachment upload – UX issue
* Create attachment sections for ciustomers
* Remove certifricates
* Job site creation - validation is not properly getting handled

Department

* `- OPERATED & MAINTAINED` - wrong name
* Alphabettically sort
* description should match UX
* Need to fix permissions for default sales roles **todo**

Implement authorizations for dept and roles **todo**

**Employees**

DOB for employees - should not be restricted

Employee type – need discussion **todo**

Need to add union code **todo**

header ui

Hiring and joining date validation

standatd burden code - checkbox

rehire date should be below checkboxes

term reason should be big text field

term should be termination

sticky buttons below **todo**

remove buttons from header

form validation errors - on click of next – navigate to field

Authorization issue 

**[[vendors-agencies/agencies-vendors-INDEX|Vendor]]**

next button missing

draft **todo**

Second tab should be contacts

Add category to first tab

taxable – hide dropdown

Default Expense GL Account - missing

**Agency**

date and time picker for travelr restrictions

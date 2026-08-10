---
title: Agencies
source: confluence/TCG/Agencies
migrated: 2026-08-10
updated: 2026-04-30
status: unverified
conflicts_with: [product/vendors.md, product/agency-and-vendor.md, product/agencies-module.md]
jira: []
topics: [agencies, permits, documents-attachments, vendors, projects]
entities: [agency, permit, attachment, project, vendor]
---

## **EPIC : Agencies** 

### User stories : Create & Manage Agencies

As a User , I want to create, view, edit, and manage [[product/agencies-vendors-INDEX|Agencies]] in a centralised module,  
So that all [[product/project-module/05-create-and-track-permits|permit]]-related data is stored once and automatically reused during permit creation without manual lookup

### **User flow :** 

* User opens Agencies Module
* Views Agencies List
* User clicks “Add Agency”
* System opens Create Agency Form
* User fills:

    * General Info
    * Requirements
    * Notes
    * Attachments
    
* User clicks Save
* Agency is stored
* Agency becomes available in:

    * Permit Creation Flow
    

### Acceptance criteria : 

* A dedicated Agencies module exists in the system where all agencies are listed
* New agencies can be created , edited, and viewed
* When creating a permit request, the user can select an agency from this directory and its details auto-populate into the permit form
* Attachments such as plan requirements, submitter applications, and business licenses can be uploaded per agency. 
* We can perform CRUD against agencies 

 

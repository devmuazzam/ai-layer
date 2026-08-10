---
title: Project Module
source: confluence/TCG/Project Module
migrated: 2026-08-10
updated: 2026-04-30
status: unverified
conflicts_with: []
jira: []
topics: [quotations, signatures, time-tracking, customers, projects, documents-attachments]
entities: [quotation, signature, project, customer]
part_of: product/project-module/INDEX.md
---
# Client Reviews and Signs Quotation

## User Story

As a client/customer ,I want to receive a quotation via email though **doc-sign**, review its details, and sign or decline it digitally,So that I can quickly approve or reject the proposal without manual paperwork.

## User Flow

1. Client receives quotation email with summary and **Review & Sign** button.
2. Client clicks the button and opens the quotation document in browser.
3. Client reviews:

    * Project details
    * Line items and resources 
    * Pricing summary
    * Terms & conditions
    
4. Client chooses one of the actions:

    * Sign Document
    * Decline Quotation
    
5. If client clicks **Sign Document**:

    * Signature modal opens (Type / Draw / Upload)
    * Client confirms signature
    * Document is signed successfully and notified to Sales person
    
6. If client clicks **Decline**:

    * Decline modal opens
    * Client enters reason
    * Submits decline
    
7. System records action and updates

## Acceptance Criteria

* Client receives quotation email with **Review & Sign** link.
* Clicking the link opens the quotation document in browser.
* Client can view:

    * Quotation details
    * Pricing summary
    * Terms & conditions
    
* Client can choose:

    * **Sign Document**
    * **Decline Quotation**
    
* If client clicks **Sign**:

    * Signature is captured
    * Quotation status updates to **Signed**
    
* If client clicks **Decline**:

    * Client provides a reason
    * Quotation status updates to **Declined**
    
* Once signed or declined:

    * Further actions are disabled
    
* All actions are recorded with timestamp (viewed, signed, declined, revised )


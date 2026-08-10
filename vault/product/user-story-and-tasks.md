---
title: User story & tasks
source: confluence/~7120204da88543016f4083b9f7669a42b21ef3/User story & tasks
migrated: 2026-08-10
updated: 2026-04-22
status: unverified
conflicts_with: [product/customer.md, product/customer-and-job-sites.md, product/quotation.md, product/quotations.md, product/quotation-flow-process.md]
jira: []
topics: [customers, quotations, yards, authentication, crm-integration, documents-attachments, permissions-roles]
entities: [customer, quotation, yard, attachment]
provenance: personal-space
provenance_note: >
  Migrated from an individual contributor's personal Confluence space
  (Umair Khan), not from the shared TCG space. Personal-space content is
  more likely to be a private draft than agreed specification — treat as
  one person's working notes until product confirms otherwise. This is the
  only source in the vault for the Yard Management, HubSpot sync, and
  email 2FA stories.
---

# EPIC: Yard Management

## User Story 19 — Yard Document Management

**As an Admin user,**I want lease documents stored against yards,
**so that** yard records are centralised.

### Acceptance Criteria

* Upload lease files options
* Download/view files
* Version replacement supported

## User Story 20 — Yard Organisational Profile

**As a user,**
I want each yard treated as an organizational entity,
**so that** operational data is structured.

### Acceptance Criteria

* Yard has contact list
* Yard has org chart
* Yard has responsible personnel

# EPIC: CRM Integration

## User Story  — HubSpot Quote Synchronization

As a business user,I want [[product/quotations-INDEX|quotation]] data synchronized with HubSpot,
so that CRM records stay updated.

### Acceptance Criteria

* Quote data syncs successfully
* [[product/customers-INDEX|Customer]] mapped correctly
* Sync failures logged
* Retry mechanism supported

# EPIC: Security & Authentication

## User Story 13 — Email Two-Factor Authentication

**As a system user,**
I want email verification during login,
**so that** account access is secure.

### Acceptance Criteria

* OTP sent to registered email
* OTP expiry timer enforced
* Invalid OTP rejected
* Successful login only after verification

# **EPIC : Customer management**

## User Story: Manage Customer Records and On-boarding

**As an internal system user,**I want to search, manage, classify, and onboard customer records from a single customer management module,**so that** customer information remains accurate, organised, and easy to maintain.

## Acceptance Criteria

### Customer Search

* User can search customer records by:

    * Customer name
    * Company name

* Partial text matching is supported
* Search results return relevant records quickly

### Customer Listing & Pagination

* Customer listing supports pagination
* Default records per page is **25**
* User can select other page sizes (e.g. 25 / 50 / 100)
* Total number of records is visible

### Customer Status Indicators

* Customer records display status using colour-coded indicators:

    * **Green** = Active
    * **Yellow** = Inactive for 6 months
    * **Red** = Inactive for 1 year

* Status is automatically calculated based on latest activity date

### Sales Team Association

* Customer record supports assignment of:

    * Salesperson
    * Sales Coordinator

* Authorised users can add, edit, or update associations

### Customer Self-Service On boarding

* Admin user can generate and send a secure customer information link
* Customer can submit their own company/contact details through the link
* Submitted record remains in **Pending Approval** status
* Admin team can review, approve, reject, or edit the submission
* Approved submission creates or updates customer record

# **EPIC : Quotation management**

## User Story 1: Send Quotations to Customers

**As a salesperson,**I want to send quotations directly to customers from the system,
**so that** the quotation process is fast and professional.

### Acceptance Criteria

* User can send quotation to customer email address
* User can select recipient from customer record or manually enter email
* Sent date/time is recorded
* Quote status changes to **Sent**
* User receives confirmation after successful send

## User Story 2: Customer Quote Approval

As a customer,I want to review and approve quotations digitally,
so that I can confirm acceptance easily.

### Acceptance Criteria

* Customer can open quotation from received email/link
* Customer can approve quotation
* Approval date/time is recorded
* Quote status changes to **Approved**
* Internal users can view approval status

## User Story 3: Print Quotations

As a salesperson,I want printable quotations,so that I can share hard copies or PDFs when required.

### Acceptance Criteria

* User can open print view
* User can print quotation
* Printed quotation includes:

    * Customer details
    * Quote items
    * Pricing totals
    * Branding/logo

## User Story 4: Quote Delivery Format Options

**As a business user,**I want quotations sent in different formats,**so that** customer communication preferences are supported.

### Acceptance Criteria

* User can choose delivery format:

    * PDF attachment
    * Embedded quotation in email body

* Selected format is applied during send process
* Default delivery format can be configured by admin (optional)

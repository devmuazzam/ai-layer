---
title: Atom Mobile Application ( User stories )
source: confluence/TCG/Atom Mobile Application ( User stories )
migrated: 2026-08-10
remigrated: 2026-08-13
confluence_version: 10
updated: 2026-08-11
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/frd-new-format-draft/INDEX.md]
jira: []
tags: [module/admin, module/field-ops, kind/user-stories, authentication, reporting, certifications]
entities: [employee, otp, vendor, certification, notification]
part_of: field-ops/atom-mobile-app-user-stories/INDEX.md
---
# EPIC 1 — Authentication & Onboarding

## US-1 — Phone Number Sign-In

**User Story**

As a field employee, I want to sign in using my phone number so that I can access the mobile
application without requiring a company email account.

**Acceptance Criteria**

* Employee signs in using the phone number and password associated with their employee profile.
* Login is permitted only when the phone number exists against the applicable employee record.
* If authentication fails, access is not granted and the application does not expose whether the entered phone number exists.
* After successful authentication, the employee remains signed in according to the persistent-login behaviour discussed for the application.
* First-time login displays the applicable introduction/onboarding screens.
* A **Contact Dispatcher** option is available from the login screen and allows the employee to call Dispatch.

## US-2 — Temporary / Vendor OTP Access ( for later )

**User Story**

As a temporary worker or third-party worker, I want to authenticate using a one-time
verification code so that I can access my assigned work.

**Acceptance Criteria**

* Temporary/vendor user enters their phone number.
* System verifies the applicable phone number before sending a verification code.
* System sends an OTP and requires the user to enter the received code to authenticate.
* After successful verification, access is restricted to the applicable assigned ticket(s).
* Temporary/vendor access does not provide unrestricted employee-level access.

# EPIC 2 — Home Dashboard

## US-3 — Dashboard View

**User Story**

As a field employee, I want to view my dashboard and active work so that I can quickly identify
and continue my assigned activities.

**Acceptance Criteria**

* Dashboard displays the employee's active/assigned ticket and applicable completion progress.
* Existing ticket progress is retained when the employee exits and reopens the application.
* Dashboard displays applicable notifications and alerts.
* Dashboard displays applicable certification alerts and allows the employee to upload updated certification information.
* Uploaded certification information is submitted for the applicable review/approval process.
* Dashboard displays applicable weather information.
* Dashboard displays employee-related information including applicable **Hours Worked, Safety and Compliance information**.
* Employee can access applicable past jobs/completed tickets, Labor, Profile, Certifications and Checklist History.

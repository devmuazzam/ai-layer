---
title: Atom Mobile Application ( User stories )
source: confluence/TCG/Atom Mobile Application ( User stories )
migrated: 2026-08-10
updated: 2026-07-22
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/frd-new-format-draft/INDEX.md]
jira: []
topics: [field-ops-mobile, authentication, dispatch, vendors, ticket-workflow, permits]
entities: [field-ticket, vendor, employee, permit]
part_of: product/atom-mobile-app-user-stories/INDEX.md
---
# EPIC 1 —> Authentication & Onboarding

## US-1 —> Phone Number Sign-In

### User Story

As a field employee, I want to sign in using my phone number so that I can access the mobile application without requiring a company email account.

### Acceptance Criteria

* User signs in using phone number and password.
* Login is only permitted when the phone number exists on the employee profile.
* If the phone number does not exist in the system, access is not granted and the system does not indicate whether the phone number exists.
* User remains logged in after successful authentication.
* After the first successful login, the user remains signed in and is not required to enter credentials again unless their account is deactivated.
* A Contact Dispatcher option is available from the login screen and contact Dispatcher initiates a phone call to the configured dispatch number.
* Introduction screens are displayed on first login.

## US-2 —> Temporary / Vendor OTP Access

### User Story

As a temporary worker or third-party vendor, I want to receive a one-time passcode so that I can access only the ticket assigned to me.

### Acceptance Criteria

* User enters phone number.
* System verifies the phone number exists.
* System sends a one-time verification code.
* User enters the verification code to authenticate.
* Access is restricted to assigned ticket(s) only.
* Introduction is not displayed during normal subsequent usage.


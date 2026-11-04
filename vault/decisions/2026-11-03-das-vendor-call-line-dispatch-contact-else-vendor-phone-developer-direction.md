---
title: "DAS vendor cards show who to call: the vendor's flagged dispatch contact (name + phone), else the vendor's main phone, else 'Phone: not set' — one dispatch contact per vendor, set by a checkbox on the vendor form (G250): developer direction"
source: decision/developer direction in a Claude Code session, 2026-11-03 (TCG-3NOV-G250; one structured question, then his own words)
decided: 2026-11-03
decided_by: >-
  The CodingCops developer working ticket G250 (overlay identity asod-cc; platform commits under the
  shared devmohsinakram profile). First a structured question offering "default dispatch contact on
  the vendor form" or "pick a contact per allocation"; he chose the first. After seeing the build he
  set the display rule in his own words, quoted below. This is a developer direction, not a TCG
  product decision, so it is `status: reference`. TCG Dispatch (Melissa McNutt, Lisette Anzaldo) was
  not consulted, and can overrule it. Recorded by the implementing session.
status: reference
supersedes: []
conflicts_with: []
related:
  - ../erp-review-log.md
  - ../dispatch/dispatch-value-engine-and-playbooks.md
  - ../meetings/2026-09-22-erp-live-demo-02-project-schedule-permits-das-allocation-and-vendors.md
  - ../meetings/2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md
tags: [module/dispatch, kind/decision, api, web, vendors, daily-allocation]
---

## Decision

**His words, verbatim (2026-11-03):**

> "ok so we wnat the dispatch contact yes, with a checkbox, 1 conytac can be only dispatch
> contact, if thats not there we will use defaiult number of vendor in the cars the, we can keep
> dispatch thing you creared"

Read as:

1. **A vendor contact can be marked "Dispatch contact"** with a checkbox on the vendor form's
   Contacts tab. **At most one per vendor**: ticking one unticks the others, and the API keeps only
   the first if several arrive (`VendorsService`, the same rule as the billing contact).
2. **On the DAS** (the vendor card in the left panel and the vendor allocation header), the one
   number shown is the **dispatch contact's name and phone**; when no dispatch contact is set, the
   **vendor's main phone** (General Information → Phone Number); with neither, **"Phone: not set"**.
   A flagged contact with no phone shows its name with the vendor's main phone.
3. One line on each card, not two: the design (TCG Platform prototype) shows a single phone on
   both cards.

## Why this was a question

G250's source, the 2026-05-05 ERP review log (AI-extracted, unverified), asks for "vendor name,
phone, **assigned employee/contact**, asset info" on the dispatch schedule. The prototype shows the
vendor phone only, and its person is the vendor employee picked in the slot. The trucking playbook
says to *"ask for the Drivers Contact"*. So "contact" could mean the slot's vendor employee or an
office contact; nobody at TCG has said which. This direction adds the office contact as the call
line and leaves the slot's vendor employee as it was.

## Not decided

- Whether the slot's vendor employee (driver/operator) phone should also show on the DAS.
- Whether TCG wants the dispatch contact at all, or the slot employee instead.

## As built

`vendor_contacts.is_dispatch_contact` (migration `20261103120000_add_vendor_dispatch_contact`);
`GET /das/vendors` adds `phoneNumber` and `dispatchContact`; web `VendorCallLine` in
`features/das/components/vendor-contact-info.tsx`. Platform commit on `fixes/TCG-3NOV-G250`.

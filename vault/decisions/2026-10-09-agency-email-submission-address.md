---
title: An agency whose Submission Type is Email stores the address applications go to — decision
source: decision/Syed Haris
decided: 2026-10-09
decided_by: Syed Haris (developer on TCG), approved when Akif took TCG-144 to him. This is a CodingCops ruling, not a TCG client confirmation. `status: reference` — binding on the build now, open to being overruled by TCG.
status: reference
conflicts_with: []
resolves: TCG-144 open question "Add an email field when Submission Type is Email? One address or several, required, does the app send to it?"
jira: []
tags: [module/vendors-agencies, kind/decision, agencies, permits]
entities: [Agency]
---

## Decision

**When an agency's Submission Type is Email, the agency stores one Submission Email.**

- **One address**, not a list.
- **Required once Email is picked**, the same rule the vendor name (3rd Party Vendor) and
  portal URL (Portal) already follow. Optional and hidden for every other type.
- **Reference only.** The app saves it and shows it; it does **not** send anything to it.
- Shown on the agency details page and recorded in the activity log.
- Switching the type away from Email clears it, as the vendor name and portal login are
  cleared today.

Stored as `agencies.submission_email`. Shipped in TCG-144.

## Why

Every other non-manual submission type records *where* to submit — which vendor, which
portal. Email recorded nothing, so a planner choosing Email had no way to know which address
the permit application goes to.

## Scope — what this does not decide

- **Sending email from the app.** Nothing sends permit applications; that would be a new
  feature.
- **Whether Submission Type and Avg Permit Cost are required.** Still open in
  [`../vendors-agencies/gaps.md`](../vendors-agencies/gaps.md).

Amends row 16 of
[2026-09-15-agency-creation-form-final-fields.md](2026-09-15-agency-creation-form-final-fields.md).

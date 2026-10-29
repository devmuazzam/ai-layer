---
title: Track Permits stays job-only until after 15 Sep 2026 — decision
source: decision/Fouzan Shakil
decided: 2026-09-11
decided_by: >-
  Fouzan Shakil (CodingCops), stated 2026-09-11 in a Claude Code review session
  of branch `fix/das-fixes`, in answer to explicit questions. Not a TCG
  client-side product-owner sign-off. Recorded `status: reference` — binding on
  the CodingCops build, open to being overruled by TCG.
status: superseded
superseded_by: decisions/2026-10-29-all-permits-create-permit-modal.md
provenance_note: >-
  Superseded 2026-10-29 by Syed Haris (developer direction, TCG-132 Q2, `reference`): Track
  Permits lists every permit regardless of job, and asset- and vendor-linked permits get status
  actions. The 15 Sep 2026 interim this note set has ended. Recorded by tcg-scrum.
conflicts_with: []
resolves:
  # part (b), for the interim; (c) stays open
  - projects-jobs/gaps.md#branch-fixdas-fixes--permit-type-remap-job-only-track-permits-projects-list-as-a-table
extends: decisions/2026-09-11-permit-classes-job-only-until-sept-15.md
jira: []
tags: [module/projects-jobs, module/assets, module/vendors-agencies, kind/decision, permits]
---

# Track Permits stays job-only until after 15 Sep 2026

This extends
[2026-09-11-permit-classes-job-only-until-sept-15.md](2026-09-11-permit-classes-job-only-until-sept-15.md).
That note limited permit **creation** to job-class permits until after 15 September 2026. This one
applies the same limit to **tracking**.

## Decision

Fouzan Shakil, 2026-09-11:

1. **Track Permits lists job-linked permits only** until after 15 September 2026. As built, the
   filter is in `permits.repository.ts` `findAllForTracker`, and the same query also backs the
   tracker's All Permits tab.
2. **Existing asset-linked and vendor-linked permits get no status actions** until the
   post-15-Sep general-class work.
3. This is a **known, accepted gap**.

## Why

No reason was stated beyond the deadline scope. It follows the companion note, which defers
general-class handling (asset- and vendor-linked permits) to after 15 Sep. Like that note, this
**defers** tracking for those permits. It does not cancel it.

## What the vault says the other way (surfaced, not resolved)

- [../projects-jobs/project-module/05-create-and-track-permits.md](../projects-jobs/project-module/05-create-and-track-permits.md)
  (`unverified`), line 15: *"create and track permits for each asset"*. Line 37: *"All Permits
  table shows full permit tracking details"*.
- [../projects-jobs/city-permits/permit-tracker-workbook.md](../projects-jobs/city-permits/permit-tracker-workbook.md):15-16
  (`unverified`). TCG's current tracker is the system of record for the annual and blanket travel
  permits it holds per crane.

Until the general-class work lands, the ERP does not track the permits TCG tracks per crane today.
That is the gap being accepted.

## Effect on the vault

- **Done (gaps):**
  [`../projects-jobs/gaps.md#branch-fixdas-fixes--permit-type-remap-job-only-track-permits-projects-list-as-a-table`](../projects-jobs/gaps.md#branch-fixdas-fixes--permit-type-remap-job-only-track-permits-projects-list-as-a-table).
  (b) is resolved for the interim. (c), the projects list as a table, stays open.
- **Done (back-pointer):** a line in
  [2026-09-11-permit-classes-job-only-until-sept-15.md](2026-09-11-permit-classes-job-only-until-sept-15.md)
  *Effect on the vault* points here.

## What this does not settle

- **What "after 15 Sep" delivers for asset- and vendor-linked permits:** tracker scope, status
  actions, and whether annuals are tracked per crane.
- **The tracker's Sub Hauler filter.** The shipped association map scopes `SUB_HAULER` to a vendor
  (`packages/shared/src/constants/permit-association.ts`). A vendor-linked Sub Hauler permit has no
  `jobId`, so it cannot appear under that filter. This falls inside the accepted gap and was not
  decided separately.

---
title: Permit create types are mockup document types — decision
source: decision/working session correcting permit vs PO type confusion
decided: 2026-09-10
decided_by: >-
  Developer directing the PO flow + permit type correction. Supersedes the
  same-day Asset|Permit|Vendor create-type decision after those labels were
  identified as a confusion with association scopes / PO subtypes. Not a
  client-side product owner sign-off. Recorded `status: reference`.
status: reference
provenance_note: >-
  Points 1 and 3 are partly superseded 2026-10-29 by
  decisions/2026-10-29-all-permits-create-permit-modal.md (Syed Haris, TCG-132, `reference`).
  The create catalog is now five types: Annual Travel (`TRAVEL_ANNUAL_PURPLE_PERMIT`) is offered
  on create, including on /permits/create and the project and asset create pages. The "exactly
  one link" rule is relaxed: a Travel permit may also carry an asset and an Annual Travel permit
  may also carry a job. Points 2 and 4 are not addressed. Recorded by tcg-scrum.
conflicts_with:
  - 2026-09-10-permit-association-scope-asset-job-vendor.md
partially_superseded_by: 2026-09-11-permit-classes-job-only-until-sept-15.md
resolves: []
jira: []
tags: [module/projects-jobs, module/vendors-agencies, kind/decision, permits]
entities: [Permit, Plan, PurchaseOrder, Job, Vendor, Agency]
---

# Permit create types = Travel | FAA | Encroachment | Sub Hauler

Supersedes [`2026-09-10-permit-association-scope-asset-job-vendor.md`](2026-09-10-permit-association-scope-asset-job-vendor.md), which offered
`ASSET` / `PERMIT` / `VENDOR` as **permit types**. Those labels were association
scopes (and match outbound PO subtypes), not the mockup document catalog.

## Decision

1. **Job-artifact / mockup permit document types** (quotation → project minting) are:
   - Travel → `TRAVEL_CITY_STREET_PERMIT` (`needTravelPermit`)
   - FAA → `FAA_PERMIT`
   - Encroachment → `ENCROACHMENT_PERMIT`
   - Sub Hauler → `SUB_HAULER`
2. **Plan types** remain `LIFT` | `SITE` only — never offered on permit create.
3. **Association stays type-derived** (exactly one of `assetId` / `jobId` / `vendorId`):
   - Travel, FAA, Encroachment → Job (`jobId`)
   - Sub Hauler → Vendor (`vendorId`)
   - Legacy `TRAVEL_ANNUAL_PURPLE_PERMIT` / `ASSET_LEVEL_CITY_AGENCY_PERMITS` → Asset
     (read/edit existing rows only — **not** offered on create)
4. Fake create values `ASSET` / `PERMIT` / `VENDOR` are not valid permit types.
5. ~~Global create on All Permits remains~~ — **superseded 2026-09-11.** Interim
   policy: hide Create Permit on the Permits tab; only job-class permits via
   quotation → project minting are live until after 15 Sep 2026. See
   [2026-09-11-permit-classes-job-only-until-sept-15.md](2026-09-11-permit-classes-job-only-until-sept-15.md).
   Quotation artifact minting still uses the four mockup keys above (+ Lift/Site plans).

## Related outbound PO subtypes (separate enum)

Purchase Order `poType` is `PERMIT` | `VENDOR` | `ASSET` with status `OPEN` | `CLOSED`
only. That is **not** the permit document type list. Confirmed for the outbound
modal in
[2026-09-11-outbound-po-subtypes-and-modal-fields.md](2026-09-11-outbound-po-subtypes-and-modal-fields.md).

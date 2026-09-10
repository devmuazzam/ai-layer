---
title: Permit type drives association with asset, job, or vendor — decision
source: decision/working session on fix/quotation-permits-plans
decided: 2026-09-10
decided_by: >-
  Developer directing the global scoped permit-creation restore on
  `fix/quotation-permits-plans`; revised the same day so association is
  type-driven (no separate Associated with field). Not a client-side product
  owner sign-off. Recorded `status: reference` rather than `verified` for that
  reason — binding on implementation now, open to being overruled by TCG. Same
  basis as `2026-09-08-artifact-due-date-seeded-from-first-job-day.md`.
status: reference
conflicts_with: []
resolves: projects-jobs/gaps.md#permits-can-no-longer-be-created-outside-the-artifact-flow--and-the-vault-says-they-can
jira: []
tags: [module/projects-jobs, module/assets, module/vendors-agencies, kind/decision, permits]
entities: [Permit, Asset, Job, Vendor]
---

# Permit association: type drives Asset | Job | Vendor (exactly one)

Settles how a **manually created** permit hangs off the rest of the domain — and restores
global create from All Permits.

## Decision

1. **Permit type chooses the association.** There is no separate “Associated with”
   control. Manual create offers exactly three types; each maps 1:1 to a link target.
2. **Create types → link map:**
   - `ASSET` (label **Asset**) → **Asset** (`assetId`)
   - `PERMIT` (label **Permit**) → **Job** (`jobId`) — job-scoped permit
   - `VENDOR` (label **Vendor**) → **Vendor** (`vendorId`)
3. Legacy quotation / travel types (`FAA_PERMIT`, `TRAVEL_ANNUAL_PURPLE_PERMIT`, …)
   remain valid on existing rows and artifact minting; they keep their association map
   but are not offered on All Permits create.
4. **Exactly one** of those three FKs is set. No redundant `associationScope` column —
   derive from which FK is non-null (or from type on create).
5. **Global create** is restored on All Permits (`/permits/create`). The user picks type
   (Asset / Permit / Vendor), then the matching entity picker, then the usual fields.
6. **Asset Management → New Permit** remains a shortcut with an asset prefilled (Asset
   type only).
7. **Quotation → project artifact minting is unchanged.** Artifacts stay job-scoped as
   today (`jobId` set at conversion) with legacy type values.
## Why

Removing "New Permit" from All Permits left only asset-scoped annual create and
quotation-generated job artifacts. The vault still requires a manual path
([`../projects-jobs/project-module/05-create-and-track-permits.md`](../projects-jobs/project-module/05-create-and-track-permits.md):21 —
*"manually creates a new one"*; open gap
`projects-jobs/gaps.md#permits-can-no-longer-be-created-outside-the-artifact-flow--and-the-vault-says-they-can`).

A free-standing association control duplicated what type already implies (travel annual /
asset-level hang on a crane; FAA / encroachment / city-street are job work; Sub Hauler
hangs on a vendor). Type-driven linking keeps one decision for the user.

## What this does not settle

- Prefill create from Job or Vendor detail pages.
- PO creation / Sub Hauler PO rules beyond storing the association.

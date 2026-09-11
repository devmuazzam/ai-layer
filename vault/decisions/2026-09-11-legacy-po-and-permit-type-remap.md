---
title: Legacy PO status, PO type and permit type remap in migration 20260910180000 — decision
source: decision/Fouzan Shakil
decided: 2026-09-11
decided_by: >-
  Fouzan Shakil (CodingCops), stated 2026-09-11 in a Claude Code review session
  of branch `fix/das-fixes`, in answer to explicit questions. Not a TCG
  client-side product-owner sign-off. Recorded `status: reference` — binding on
  the CodingCops build, open to being overruled by TCG.
status: reference
conflicts_with: []
resolves:
  # part (d); part (g) (FCC-imported ACTIVE → CLOSED?) was opened by this note
  - vendors-agencies/gaps.md#branch-fixdas-fixes--one-closed-status-for-invoiced-and-cancelled-pos-and-the-legacy-remap
  # part (a)
  - projects-jobs/gaps.md#branch-fixdas-fixes--permit-type-remap-job-only-track-permits-projects-list-as-a-table
jira: []
tags: [module/vendors-agencies, module/projects-jobs, kind/decision, purchase-orders, permits, data-migration]
---

# Legacy PO and permit values: the remap in `20260910180000_po_permit_type_status_correction`

This is the companion to
[2026-09-11-po-closed-means-closed-out-not-cancelled.md](2026-09-11-po-closed-means-closed-out-not-cancelled.md).
That note says what `CLOSED` means from now on. This one says what existing rows become. The
migration is
`apps/api/prisma/migrations/20260910180000_po_permit_type_status_correction/migration.sql`.

## Decision

Fouzan Shakil, 2026-09-11:

1. **`PurchaseOrderStatus` is remapped by legacy value**, not by whether an invoice number is
   present:

   | Legacy status | Becomes |
   | --- | --- |
   | `PURCHASED`, `ACTIVE`, `CANCELLED`, `INACTIVE` | `CLOSED` |
   | `PENDING`, `DRAFT` | `OPEN` |

   These six are the whole legacy enum (`apps/api/prisma/schema.prisma` at `21a345f7e`, the parent
   of the remap commit).
2. **`PoType`:** `GENERAL` and `CONTRACT` become `VENDOR`. `PERMIT` exists in both the old and the
   new enum and is unchanged.
3. **Legacy permit types `ASSET` / `PERMIT` / `VENDOR` are remapped by the association the row
   actually holds**, not by the legacy label:

   | The row holds | Becomes |
   | --- | --- |
   | an asset | `ASSET_LEVEL_CITY_AGENCY_PERMITS` |
   | a job | `TRAVEL_CITY_STREET_PERMIT` |
   | a vendor | `SUB_HAULER` |

4. **The migration is edited in place**, not followed by a corrective migration, because it had
   only ever been applied to local dev databases.

## Why

- **Statuses.** The stated reason is that the mapping matches the FCC seeder's `mapPoStatus`
  (`apps/api/fcc-seeder/src/lib/seed-helpers.ts`).
  **When this decision was made, one value did not match.** The seeder committed on
  `fix/das-fixes` (`seed-helpers.ts`:112-123) mapped `CLOSED`, `PURCHASED`, `CANCELLED` and
  `INACTIVE` to `CLOSED`, and everything else, **including `ACTIVE`**, to `OPEN`. Later the same
  day a change on the branch, not yet committed when this note was written, added `ACTIVE` to the
  seeder's `CLOSED` list. The seeder and the migration now agree.
  The two read **different vocabularies**:
  - The migration reads the ERP's own legacy enum. There a PO reached `ACTIVE` only by
    auto-promoting from `PENDING` once an invoice number and an attachment both existed
    ([`../vendors-agencies/gaps.md#po-and-vendoragency-rules-the-e2e-suite-asserts-with-no-written-source--pr-488`](../vendors-agencies/gaps.md#po-and-vendoragency-rules-the-e2e-suite-asserts-with-no-written-source--pr-488)
    (a)), which is close to the new closed-out meaning.
  - The seeder reads FCC's source status text.

  So aligning the seeder also changes FCC imports: an FCC PO whose own status is `ACTIVE` now
  imports as `CLOSED`. Nothing recorded says whether that was part of the decision. The ERP
  mapping is **recorded as stated**. The FCC-import consequence is filed as part (g) of the
  vendors-agencies entry, and is not adjudicated here.
- **Permit types.** No reason beyond the mapping was recorded. It follows
  [2026-09-10-permit-create-types-mockup-document-types.md](2026-09-10-permit-create-types-mockup-document-types.md)
  points 3–4. Those made `ASSET` / `PERMIT` / `VENDOR` invalid types and made a permit's
  association exactly one of asset, job or vendor, but said nothing about rows that already
  existed.
- **In place.** Only local dev databases had applied the migration, so no deployed data carries
  the earlier version.

## Effect on the vault

- **Done (gaps):**
  [`../vendors-agencies/gaps.md#branch-fixdas-fixes--one-closed-status-for-invoiced-and-cancelled-pos-and-the-legacy-remap`](../vendors-agencies/gaps.md#branch-fixdas-fixes--one-closed-status-for-invoiced-and-cancelled-pos-and-the-legacy-remap).
  (d) is resolved. (g) is added as open: should an FCC-imported PO whose FCC status is `ACTIVE`
  import as `CLOSED`, now that the seeder was changed to match?
- **Done (gaps):**
  [`../projects-jobs/gaps.md#branch-fixdas-fixes--permit-type-remap-job-only-track-permits-projects-list-as-a-table`](../projects-jobs/gaps.md#branch-fixdas-fixes--permit-type-remap-job-only-track-permits-projects-list-as-a-table).
  (a) is resolved.
- **Consequence for developers, not a ruling.** A local database that applied the earlier version
  of this migration keeps the earlier mapping. Prisma will report the migration as modified after
  it was applied, so that database needs a reset.

## What this does not settle

- **A legacy permit row that holds no association, or more than one.** No precedence was stated.
  The in-place edit makes its own choices for `ASSET`-labelled rows: asset, then job, then vendor,
  and `ASSET_LEVEL_CITY_AGENCY_PERMITS` when the row holds none. These are implementation choices,
  not part of this decision.
- **A `NULL` legacy PO status.** The migration maps it to `OPEN` and explains why in a comment.
  That is also an implementation choice. The decision named the six enum values only.
- **Legacy annuals.** A legacy annual recorded as `ASSET` with an asset becomes
  `ASSET_LEVEL_CITY_AGENCY_PERMITS`, never `TRAVEL_ANNUAL_PURPLE_PERMIT`. Under
  [2026-09-11-permit-approval-requires-linked-po.md](2026-09-11-permit-approval-requires-linked-po.md)
  only `TRAVEL_ANNUAL_PURPLE_PERMIT` is PO-exempt, so such a row would need a PO to be approved.
  Under
  [2026-09-11-track-permits-job-only-until-sept-15.md](2026-09-11-track-permits-job-only-until-sept-15.md)
  asset-linked permits have no status actions until after 15 Sep, so nothing reaches that gate
  before then. Whether "annual" stays expressible at all is still open:
  [`../projects-jobs/gaps.md#po-exemption-swaps-the-annual-vs-single-axis-for-asset-vs-job--and-annual-stops-being-expressible`](../projects-jobs/gaps.md#po-exemption-swaps-the-annual-vs-single-axis-for-asset-vs-job--and-annual-stops-being-expressible)
  (b).
- **Why a job-linked row becomes Travel City/Street** rather than FAA or Encroachment. No reason
  was stated, but the mapping stands as decided.
- **Legacy `CANCELLED` POs now read as closed-out.** The remap does not preserve the legacy
  difference between cancelled and closed.

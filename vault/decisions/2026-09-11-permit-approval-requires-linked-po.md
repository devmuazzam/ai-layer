---
title: Permit approval keeps requiring a linked PO, except the annual purple permit — decision
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
  # part (a), now recorded as a decision rather than only a branch fix; (b) stays open
  - projects-jobs/gaps.md#po-exemption-swaps-the-annual-vs-single-axis-for-asset-vs-job--and-annual-stops-being-expressible
supersedes_partial:
  # point 14, for approval only; the attach / create-and-attach paths stand
  - decisions/2026-09-11-quote-to-project-permits-plans-flow.md
jira: []
tags: [module/projects-jobs, module/vendors-agencies, kind/decision, permits, purchase-orders]
---

# Permit approval keeps requiring a linked PO, except `TRAVEL_ANNUAL_PURPLE_PERMIT`

## Decision

Fouzan Shakil, 2026-09-11:

1. **Approving a permit requires a linked PO.**
2. **The one exemption is `TRAVEL_ANNUAL_PURPLE_PERMIT`.**
3. **This supersedes point 14 of
   [2026-09-11-quote-to-project-permits-plans-flow.md](2026-09-11-quote-to-project-permits-plans-flow.md)
   for approval.** Point 14 said the PO is *"not required in the current flow"*. The rest of point
   14 stands: on the permit form you can attach an existing PO or create one and attach it, and
   removing a linked PO brings back the create option.

## Why

The stated reason is consistency with
[2026-06-18-annual-permits-no-po-single-permits-need-po.md](2026-06-18-annual-permits-no-po-single-permits-need-po.md)
(Brian Petros, confirmed by Melissa McNutt; `reference`). Annual permits are already paid and get
no PO. Single-job permits get one. The exemption therefore stays on the annual-vs-single line
that decision draws (line 71), not on asset-vs-job.

The branch already matches: `PO_EXEMPT_PERMIT_TYPES = ['TRAVEL_ANNUAL_PURPLE_PERMIT']` at
`packages/shared/src/constants/permit-types.ts`:92 (checked 2026-09-11).

## Effect on the vault

- **Done (annotation):**
  [2026-09-11-quote-to-project-permits-plans-flow.md](2026-09-11-quote-to-project-permits-plans-flow.md).
  The approval half of point 14 is struck through and points here. The *What this does not
  settle* bullet on approval is updated. `partially_superseded_by:` is added to its frontmatter.
  The two notes no longer disagree.
- **Done (annotation):**
  [2026-09-05-po-types-and-quote-to-invoice-workflow.md](2026-09-05-po-types-and-quote-to-invoice-workflow.md).
  Its approval bullet cited the Loom's *"PO optional"* as the latest word. It now points here, and
  its *"Still needs Brian"* stays true.
- **Done (gaps):**
  [`../projects-jobs/gaps.md#po-exemption-swaps-the-annual-vs-single-axis-for-asset-vs-job--and-annual-stops-being-expressible`](../projects-jobs/gaps.md#po-exemption-swaps-the-annual-vs-single-axis-for-asset-vs-job--and-annual-stops-being-expressible).
  (a) is now recorded as decided. (b) stays open.

## What this does not settle

- **Brian Petros's confirmation of the approval gate.** Before this note, the gate's only stated
  source was CodingCops, at the 2026-07-29 sprint review (13:52). The 2026-09-05 note says it
  *"still needs Brian"*. This note is also a CodingCops call.
- **Whether "annual" stays expressible when a permit is created**
  ([`../projects-jobs/gaps.md#po-exemption-swaps-the-annual-vs-single-axis-for-asset-vs-job--and-annual-stops-being-expressible`](../projects-jobs/gaps.md#po-exemption-swaps-the-annual-vs-single-axis-for-asset-vs-job--and-annual-stops-being-expressible)
  (b)). Only `TRAVEL_ANNUAL_PURPLE_PERMIT` marks a permit as annual. Legacy annuals remapped to
  `ASSET_LEVEL_CITY_AGENCY_PERMITS` by
  [2026-09-11-legacy-po-and-permit-type-remap.md](2026-09-11-legacy-po-and-permit-type-remap.md)
  are not exempt.
- **What happens to an approved permit when its PO is archived and unlinked.** Still open at
  [`../projects-jobs/gaps.md#permitpo-reverse-cascades-incomplete`](../projects-jobs/gaps.md#permitpo-reverse-cascades-incomplete).

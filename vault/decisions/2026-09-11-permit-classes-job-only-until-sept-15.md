---
title: Permit classes are general and job — job-only create until after 15 Sep — decision
source: decision/Ehtesham Anwar
decided: 2026-09-11
decided_by: >-
  Ehtesham Anwar (CodingCops product manager), stated in a working session
  locking permit scope for the 15 Sep 2026 deadline. Not a TCG client-side
  product-owner sign-off. Recorded `status: reference` — binding on the
  CodingCops build through that deadline, open to being overruled by TCG.
status: reference
provenance_note: >-
  Points 2 and 4 are superseded for All Permits as of 2026-10-29 by
  decisions/2026-10-29-all-permits-create-permit-modal.md (Syed Haris, TCG-132, `reference`).
  Create Permit returns on All Permits as a modal (Travel, Annual Travel, FAA, Encroachment, Sub
  Hauler), with asset linking as the prototype shows. The 15 Sep 2026 deadline has passed. The
  companion tracker note (2026-09-11-track-permits-job-only-until-sept-15) is fully superseded.
  Points 1, 3 and 5 are not addressed by that decision. Recorded by tcg-scrum.
conflicts_with: []
resolves: projects-jobs/gaps.md#permits-can-no-longer-be-created-outside-the-artifact-flow--and-the-vault-says-they-can
supersedes_partial:
  - 2026-09-10-permit-create-types-mockup-document-types.md
jira: []
tags: [module/projects-jobs, module/assets, module/vendors-agencies, kind/decision, permits]
entities: [Permit, Plan, PurchaseOrder, Job, Project, Quotation, Asset]
---

# Permit classes: general | job — only job is live until after 15 Sep 2026

Locks the **interim product scope** for permits through the 15 September 2026
deadline. Does **not** rename document kinds (Travel / FAA / Encroachment /
Sub Hauler) and does **not** invent new schema enums in this note.

## Decision

Ehtesham Anwar, locked 2026-09-11:

1. **Two permit classes:** **general** and **job**.
   - **Job** = permits minted for a job (today: quotation → project conversion
     artifact flow). Aligns with Brian Petros’s 2026-08-27 “permits specific to
     Job” scope.
   - **General** = non-job permits (including future asset-linked / annual /
     standalone handling). Aligns with Brian’s “permits specific to the Asset”
     scope. Product label is **general**, not a third inventable type axis.
2. **Hide Create Permit** on the Permits tab **for now**. There is no working
   direct-create flow in the current delivery window.
3. **Only job-class permits are in scope** for the live app path: created when
   converting a quotation to a project (checklist / document configuration →
   minted artifacts).
4. **General-class handling and permit↔asset linking** happen **after
   15 September 2026**. Do not ship a working direct-create or asset-link flow
   before that deadline as if it were done.
5. In the **projects / quote→project artifact flow**, the permit form surfaces
   **all fields from the PO modal** — see
   [2026-09-11-outbound-po-subtypes-and-modal-fields.md](2026-09-11-outbound-po-subtypes-and-modal-fields.md)
   (PO type, PO number, PO items, Agency dropdown, invoice attachment).

## Why

The 15 Sep deadline concentrates delivery on the quotation→project job-artifact
path that is already demonstrated. Restoring global / All Permits create
(2026-09-10 working session) conflicted with that interim scope. Longer-term
manual create remains a real product need (vault + Ehtesham’s own 2026-06-18
transcript); this decision **defers** it with general/asset work — it does
**not** cancel it.

Document kinds (Travel / FAA / Encroachment / Sub Hauler, plus Lift / Site
plans) stay the **job-artifact catalog**. They are not replaced by general|job;
general|job is the top-level class.

## Effect on the vault

- **Done — gaps:**
  [`../projects-jobs/gaps.md#permits-can-no-longer-be-created-outside-the-artifact-flow--and-the-vault-says-they-can`](../projects-jobs/gaps.md#permits-can-no-longer-be-created-outside-the-artifact-flow--and-the-vault-says-they-can)
  → **resolved for the interim** — hide create until post-15-Sep general/asset
  work; longer-term manual create deferred, not cancelled. Citation: this note.
- **Done — partial supersession:**
  [2026-09-10-permit-create-types-mockup-document-types.md](2026-09-10-permit-create-types-mockup-document-types.md)
  point 5 (“Global create on All Permits remains”) is **superseded**. Points
  1–4 (document-kind catalog + type-derived association for those kinds) **stand**
  for job artifacts.
- **Related:** quote→project flow detail in
  [2026-09-11-quote-to-project-permits-plans-flow.md](2026-09-11-quote-to-project-permits-plans-flow.md).
- **Extended 2026-09-11 to tracking:**
  [2026-09-11-track-permits-job-only-until-sept-15.md](2026-09-11-track-permits-job-only-until-sept-15.md)
  (Fouzan Shakil). Track Permits lists job-linked permits only until after 15 Sep. Existing
  asset- and vendor-linked permits get no status actions until then, which is a known, accepted
  gap.

## What this does not settle

- Exact schema / enum naming for general vs job (no new columns invented here).
- Post-15-Sep UX for general create, asset linking, or restoring All Permits
  create.
- Whether ad-hoc job permits (needs discovered after conversion) eventually
  return via job-page create vs quotation reconfiguration — deferred with
  general work.

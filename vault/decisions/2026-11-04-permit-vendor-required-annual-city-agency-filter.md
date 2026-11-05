---
title: "Annual Travel is tied to one city, matched robustly; Vendor is required on every permit type; agency picker city filter (AI decision, awaiting review): owner direction"
source: decision/Fouzan Shakil, project-owner direction in a TCG-132 code-review follow-up, 2026-11-04 (ticket TCG-132, Trello #132)
decided: 2026-11-04
decided_by: >-
  Fouzan Shakil (CodingCops project owner running TCG-132; Syed Haris is the developer reviewer),
  in the code-review follow-up of 2026-11-04, relayed to tcg-scrum by the coordinating session.
  Parts (a) and (b) are his direction. Part (c) is NOT a human decision: he asked the AI to settle
  the agency picker's city filter from the vault and the implementation, so it is recorded here as
  an AI decision awaiting Syed Haris's review. No TCG product owner (Lisette Anzaldo, Brian Petros
  for permits) was consulted. It is therefore `status: reference`, on the same basis as
  decisions/2026-10-29-all-permits-create-permit-modal.md and the 2026-09-10/11 permit notes it
  amends. It binds the build now, and TCG can overrule it. Recorded by tcg-scrum 2026-11-04.
status: reference
resolves:
  - TCG-132/spec.md#d49
supersedes_partial:
  - decisions/2026-09-10-permit-create-types-mockup-document-types.md
  - decisions/2026-10-29-all-permits-create-permit-modal.md
conflicts_with: []
related:
  - decisions/2026-09-10-permit-association-scope-asset-job-vendor.md
  - decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md
  - dispatch/travel-permits-playbook.md
  - projects-jobs/city-permits/permit-acquisition-process.md
  - projects-jobs/gaps.md#branch-fixdas-fixes--the-artifacts-city-becomes-read-only-and-is-driven-by-the-agency-on-plans-as-well-as-permits
  - ../aidlc/TCG-132/spec.md
jira: []
tags: [module/projects-jobs, module/vendors-agencies, module/dispatch, kind/decision, permits, purchase-orders]
entities: [Permit, Agency, Vendor, Job, JobSite, Asset, PurchaseOrder]
---

# Permit city and vendor rules (TCG-132): owner direction, plus one AI decision

**Read the labels.** Parts **(a)** and **(b)** are a human direction (Fouzan Shakil, 2026-11-04).
Part **(c)** is an **AI decision** that no person has approved yet. It is recorded here because the
owner asked for it to be settled and written down, and it stays open to Syed Haris's review.

## Decision

### (a) Annual Travel is tied to one city, and the match is robust. HUMAN, Fouzan Shakil

An Annual Travel permit (`TRAVEL_ANNUAL_PURPLE_PERMIT`) is valid for **one city**. City / Authority is
required on an Annual. Matching that city against a job's city must be **robust, not a brittle exact
string compare**:

- names are compared **normalised** (case, punctuation, diacritics, "City of …" / "… City", St / Saint,
  Ft / Fort, Mt / Mount);
- an agency covers a city through a **broader jurisdiction** as well as through its own city (see
  part (c) for the same coverage rule on the picker);
- **editing the city** of an Annual re-runs the check against the jobs it is linked to.

This **supersedes the prototype's "City / Authority optional on Annual" line** (the approved
prototype, `aidlc/TCG-132/intent.md` Appendix A) and **resolves AI decision D49** in
`aidlc/TCG-132/spec.md` §11b. The build detail is AI decision **D50** there.

### (b) Vendor is required on every permit type. HUMAN, Fouzan Shakil

**Vendor is required on Travel, Annual Travel, FAA, Encroachment and Sub Hauler.** The owner's words:
*"vendors are required for POs since permits come from vendors against POs"*.

This **supersedes**, for vendors:

- point 3 of `decisions/2026-09-10-permit-create-types-mockup-document-types.md` (*exactly one of
  `assetId` / `jobId` / `vendorId`*, with Vendor only on Sub Hauler);
- spec AI decision **D3** (`aidlc/TCG-132/spec.md` §11b), which kept vendor as Sub Hauler's required
  link and no other type's;
- the updated prototype's **optional** Vendor field.

How legacy rows with no vendor are handled is AI decision **D51** in the spec.

### (c) Agency picker city filter. AI DECISION, awaiting Syed Haris's review

**Not decided by a person.** The owner asked the AI to settle this from the vault and the
implementation. Recorded as spec AI decision **D52** (`needs developer: yes`).

When a city is selected, the agency picker lists the agencies that **cover** that city:

- an agency whose own city is that city (normalised compare, as in (a)); **or**
- an agency of a **broader jurisdiction** (County, State, Federal, Special District, Other) in the
  **same state** (a blank state on either side counts as the same); **or**
- an agency with **no city and no jurisdiction type**, because nothing says it does not cover it.

Agencies of **another specific city** (City, Town, Unincorporated / CDP, Township, Borough, Village)
are hidden. The rule is `agencyCoversCity` in `packages/shared/src/utils/city-match.ts` (shared by
the API and the web).

## Why

- **(a) A city mismatch must not refuse a valid permit.** The city is stored as a name on the permit
  and as an address string on the job site, so the same city arrives spelled differently. An exact
  compare would block real annuals; normalising keeps the one-city rule without that failure.
- **(b) In the owner's words:** permits come from vendors against POs, so every permit needs its
  vendor.
- **(c), the AI's reasons from the vault (all sources `unverified`):**
  - TCG's permit library is **keyed by jurisdiction, and broader jurisdictions issue for cities
    under them.** `projects-jobs/city-permits/permit-acquisition-process.md`:56-62 lists cities that
    do not issue their own permit and are covered by Caltrans, by the county ("See County of
    Imperial"), or by "the LA City / LA County annual". Lines 64-85 list **stacked** permits, where
    one move needs a county and a city together. A filter that showed only same-city agencies would
    hide the county and state authorities dispatch actually applies to.
  - **The state-level annual is real and held per crane.** `dispatch/travel-permits-playbook.md`:40-46:
    40-350 t cranes "have Caltrans Annual Permits and are covered on the freeway", a statewide
    permit. So a State agency must stay visible for any city in its state.
  - **Showing every agency was the previous state, and it was flagged.** The city filter was removed on
    branch `fix/permits-pos` (`projects-jobs/gaps.md#branch-fixdas-fixes--the-artifacts-city-becomes-read-only-and-is-driven-by-the-agency-on-plans-as-well-as-permits`,
    item (c): *"the agency picker also stops filtering by city"*). That entry is **open** (owner:
    Lisette Anzaldo). Hiding other cities' own agencies narrows the list without hiding any
    authority that could issue for the selected city.
  - **Unknown is kept, not hidden,** because an agency with no city and no jurisdiction cannot be
    shown not to cover the city. Hiding it would make it unpickable everywhere.

## What this does not settle

- **Whether TCG agrees.** Nobody at TCG signed (a), (b) or (c) off. Lisette Anzaldo and Brian Petros
  own permits on the TCG side.
- **Vendor on PO-exempt permits.** The owner's reason ties the vendor to POs, but Annual Travel is
  PO-exempt under `decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md` (Brian
  Petros, `reference`). The direction still names every type, Annual included, so the build requires
  the vendor on Annual. This note does not change the PO-exemption rule.
- **Stacked jurisdictions on one permit.** One permit still carries one agency and one city.
  `permit-acquisition-process.md`:64-85 shows moves that need several. Not addressed.
- **The open `projects-jobs/gaps.md` entry** on the agency-driven City (State lock, Area, a permit
  with no city) stays **open**. Part (c) is an AI decision, not its owners' answer.
- **Two questions raised in the same review**, now open for Lisette Anzaldo in
  `aidlc/TCG-132/spec.md` §12: Q19 (does allocating an asset auto-link the job's Travel permit, and
  does Unlink stop it re-linking) and Q20 (does linking another permit to a (job, asset) replace the
  existing link, and does the job-level permit count as coverage after Unlink).

## Effect on the vault

Done 2026-11-04 by tcg-scrum, in the same pass as this note:

- **This note** written.
- **`aidlc/TCG-132/spec.md` §12:** Q19 and Q20 added, each `Status: open`, owner Lisette Anzaldo.
- **Partially superseded (done, frontmatter `provenance_note:` only; `status: reference` kept because
  their other points stand):**
  - `decisions/2026-09-10-permit-create-types-mockup-document-types.md`: point 3, for vendors
    (appended to its existing `provenance_note:`).
  - `decisions/2026-10-29-all-permits-create-permit-modal.md`: point 1, the prototype's optional
    City on Annual and optional Vendor (new `provenance_note:`).

Not done by tcg-scrum (outside its write access), proposed in the tcg-scrum handoff:

- **`aidlc/TCG-132/spec.md` §11b:** rows D50, D51, D52, and D49's row pointing at this note.
- **`INDEX.md`** decisions row for this note, and the 2026-10-29 row's wording.

**No file was flipped to `verified`.** (a) and (b) are a CodingCops owner direction, not a TCG
adjudication, and (c) is an AI decision.

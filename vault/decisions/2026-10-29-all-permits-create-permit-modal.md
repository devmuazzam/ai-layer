---
title: "All Permits gets a Create Permit modal built to the TCG Whole App prototype; every new permit starts at Open; Track Permits lists every permit; PO gains PO date and Bill to customer: developer direction"
source: decision/Syed Haris, developer direction in a Claude Code session, 2026-10-29 (ticket TCG-132, Trello #132)
decided: 2026-10-29
decided_by: >-
  Syed Haris (CodingCops developer), instructing in the Claude Code session that elaborated and
  decomposed TCG-132 on 2026-10-29. He confirmed the "TCG Whole App" HTML prototype (captured in
  aidlc/TCG-132/intent.md Appendix A) as the approved spec and answered spec.md §12 Q1-Q6, relayed
  to tcg-scrum by the coordinating session. This is a developer direction, not a TCG client
  sign-off: no TCG product owner (Brian Petros, Lisette Anzaldo for permits) was consulted. It is
  therefore `status: reference`, on the same basis as the 2026-09-11 permit notes it reverses
  (themselves CodingCops `reference` decisions by Ehtesham Anwar and Fouzan Shakil). It binds the
  build now, and TCG can overrule it. Recorded by tcg-scrum 2026-10-29.
status: reference
resolves:
  - TCG-132/spec.md#q1
  - TCG-132/spec.md#q2
  - TCG-132/spec.md#q3
  - TCG-132/spec.md#q4
  - TCG-132/spec.md#q5
  - TCG-132/spec.md#q6
  - TCG-132/spec.md#q7
  - TCG-132/spec.md#q9
  - TCG-132/spec.md#q13
  - TCG-132/spec.md#q15
  - TCG-132/spec.md#q16
  - TCG-132/spec.md#q17
  - TCG-132/spec.md#q18
  - projects-jobs/gaps.md#permits-can-no-longer-be-created-outside-the-artifact-flow--and-the-vault-says-they-can
supersedes:
  - decisions/2026-09-11-track-permits-job-only-until-sept-15.md
supersedes_partial:
  - decisions/2026-09-11-permit-classes-job-only-until-sept-15.md
  - decisions/2026-09-10-permit-create-types-mockup-document-types.md
  - decisions/2026-09-11-outbound-po-subtypes-and-modal-fields.md
  - decisions/2026-10-08-po-fee-typed-by-user-approval-leaves-po-alone.md
conflicts_with: []
related:
  - decisions/2026-09-10-permit-association-scope-asset-job-vendor.md
  - decisions/2026-09-11-permit-approval-requires-linked-po.md
  - decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md
  - projects-jobs/project-module/05-create-and-track-permits.md
  - projects-jobs/gaps.md#branch-fixdas-fixes--permit-type-remap-job-only-track-permits-projects-list-as-a-table
  - ../aidlc/TCG-132/spec.md
jira: []
tags: [module/projects-jobs, module/vendors-agencies, module/assets, kind/decision, permits, purchase-orders]
entities: [Permit, PurchaseOrder, Job, JobSite, Yard, Asset, Vendor, Employee]
---

# All Permits Create Permit modal (TCG-132): developer direction

## Decision

Syed Haris, 2026-10-29, in the TCG-132 session. Answers as relayed; the full question text and
options are in `aidlc/TCG-132/spec.md` §12.

1. **The "TCG Whole App" HTML prototype is the approved spec** for TCG-132 (captured in
   `aidlc/TCG-132/intent.md` Appendix A).
2. **Create Permit returns on All Permits, as a modal.** This reverses points 2 and 4 of
   `decisions/2026-09-11-permit-classes-job-only-until-sept-15.md` **for All Permits**: the
   "hide Create Permit" interim and the "no direct-create flow before 15 Sep" deferral. The
   15 Sep 2026 deadline those points served has passed.
3. **The modal's types are Travel, Annual Travel, FAA, Encroachment and Sub Hauler**, each with
   its own form (prototype). Annual Travel is added to the shared create catalog, and Haris
   **accepted that it therefore also appears** on the `/permits/create`, project and asset create
   pages, which the ticket otherwise leaves untouched.
4. **Association follows the prototype:** a Travel permit may also carry an asset and an Annual
   Travel permit may also carry a job, beyond the one link each type requires. (How that is
   encoded is AI decision D3 in the spec, reviewed in the PR, not part of this direction.)
5. **Route: Origin is the yard, Destination is the job site.** Add **Valid from** and
   **Travel from / Travel to**; Valid till is no longer required. **Assigned Planner is an
   employee picker**, not free text. (Q3: accepted, option A, Origin = yard, against the
   unverified freeway-exit wording in `dispatch/travel-permits-playbook.md` §1.)
6. **Q1: the inline "Create new" PO matches the prototype.** It shows PO date, PO fee,
   Description, Invoice and a Bill to customer toggle, and omits Agency and PO items.
   `PurchaseOrder` gains two columns, **PO date** (`po_date`) and **Bill to customer**
   (`bill_to_customer`). Column types, defaults and which other PO screens show them were
   delegated to the spec (D12, D13). The PO fee in that nested modal is prefilled from the
   permit's service fee and stays editable (prototype).
7. **Q2: Track Permits lists every permit**, with or without a job (drop the job-only filter in
   `findAllForTracker`). Asset-linked and vendor-linked permits get working status actions.
   This **supersedes** `decisions/2026-09-11-track-permits-job-only-until-sept-15.md`.
8. **Q4: a modal-created permit starts at Open.** The Application submitted and Permit received
   dates are stored as typed and never drive the status.
9. **Q5: type labels from the prototype are modal-only.** `PERMIT_TYPE_LABELS` and every other
   list, filter, tracker, print and DAS label stay unchanged.
10. **Q6: every create caller starts at Open**, not only the modal. This **confirms AI decision
    D11** (`PermitsService.create` sets `OPEN` for every caller of `POST /permits`, including the
    three untouched create pages). TCG-132 U1 updates the three existing E2E assertions,
    `qa-automation/e2e/specs/permits/create.spec.ts:97` and
    `qa-automation/e2e/specs/permits/status.spec.ts:20` and `:61`, from
    `APPLICATION_SUBMITTED` to `OPEN`. That is an edit of existing tests, not a new test, and
    does not conflict with `decisions/2026-10-21-no-new-tests-unless-asked.md`.

## Why

- **The deadline that justified the interim has passed.** The 2026-09-11 notes hid create and
  kept the tracker job-only *until after 15 Sep 2026*, explicitly as a deferral, not a
  cancellation. Their own *What this does not settle* sections left the post-deadline UX open.
  This direction is the post-deadline answer for All Permits.
- **The vault wanted a manual path all along.** `projects-jobs/project-module/05-create-and-track-permits.md`
  (`unverified`) line 21, *"or manually creates a new one"*, and line 15, *"create and track permits
  for each asset"*. `projects-jobs/city-permits/permit-tracker-workbook.md` (`unverified`) shows TCG
  tracks annual and blanket permits per crane today. Both were the "other way" that the
  2026-09-11 notes accepted as a known gap.
- **One start status for every caller (Q6).** `PermitsService.create` cannot tell the modal from
  the old pages. A flag letting the client choose its starting workflow state was rejected (spec
  D11). Moving every caller keeps one rule.
- **PO columns (Q1).** No vault file mentions a PO date or a bill-to-customer flag. The prototype
  is the only source, and Haris chose to follow it rather than keep the 2026-09-11 locked set for
  this modal.

## What this does not settle

- **What Bill to customer does downstream** (invoice, quote, statement, reporting). Stored and
  shown only. Money-adjacent: ask before anything reads it.
- **What Valid from does to the computed status.** Stored and shown; no effect (spec D7). No
  source says otherwise.
- **The PO picker scope for a permit with neither a job nor a project** (spec D14, executor's
  call, recorded in the PR).
- **The prototype's PO Notes field.** Not stored; Haris named two columns only.
- **Whether TCG agrees.** Nobody at TCG signed this off. Lisette Anzaldo and Brian Petros own
  permits on the TCG side (`projects-jobs/gaps.md` owners).
- **Fix/das-fixes residuals:** (c), the projects list as a table, and the residual of (a), legacy
  rows with no association or several, stay open in
  `projects-jobs/gaps.md#branch-fixdas-fixes--permit-type-remap-job-only-track-permits-projects-list-as-a-table`.

## Effect on the vault

All done 2026-10-29 by tcg-scrum, in the same pass as this note. Frontmatter only; no file body
was edited except the `Status:` lines of the gap entries.

- **Superseded (done):** `decisions/2026-09-11-track-permits-job-only-until-sept-15.md` now has
  `status: superseded` and `superseded_by: decisions/2026-10-29-all-permits-create-permit-modal.md`.
- **Partially superseded (done, `provenance_note:` added; `status: reference` kept because their
  other points stand):**
  - `decisions/2026-09-11-permit-classes-job-only-until-sept-15.md`: points 2 and 4 superseded
    for All Permits.
  - `decisions/2026-09-10-permit-create-types-mockup-document-types.md`: point 1 (catalog now
    five, including Annual Travel) and point 3 (Travel may carry an asset, Annual may carry a
    job, Annual offered on create).
  - `decisions/2026-09-11-outbound-po-subtypes-and-modal-fields.md`: the locked modal set is
    superseded for the Create Permit modal's nested PO. It stands elsewhere, and other PO
    screens gain PO date and Bill to customer.
  - `decisions/2026-10-08-po-fee-typed-by-user-approval-leaves-po-alone.md`: the create-time fee
    default is settled for the Create Permit modal only.
- **Already superseded, pointer added (done, `provenance_note:`):**
  `decisions/2026-09-10-permit-association-scope-asset-job-vendor.md`. Its "exactly one link"
  rule, carried into the create-types note, is relaxed for Travel and Annual Travel.
- **Gaps (done):** `projects-jobs/gaps.md`
  - *Permits can no longer be created outside the artifact flow*: `Status:` is now resolved, see
    this note.
  - *Branch fix/das-fixes*: `Status:` now says (b) is superseded by this note; (c) and the (a)
    residual stay open.
- **Ticket (done):** `aidlc/TCG-132/spec.md` §12 Q1-Q6 now read `resolved`, see this note.
- **No file flipped to `verified`.** This is a developer direction, so nothing in it is a product
  adjudication.
- **Not done by tcg-scrum (outside its write access):** the `INDEX.md` decisions rows. A row for
  this note and updated wording for the rows of the notes above are proposed in the tcg-scrum
  handoff for whoever maintains `INDEX.md`.

## Addendum 2026-10-30: PR review close-out (Q7, Q9, Q13)

Syed Haris (developer) reviewed the TCG-132 stack in the Claude Code session of 2026-10-29/30.
After running the live test he listed three issues:

- (a) the permit detail and edit pages should show and edit the new fields;
- (b) the "Not filled in yet" banner should not show on modal-created permits;
- (c) the Annual type label should read "Annual Travel Permit".

He then instructed "fix all the issues and make the code ready to merge". The coordinator relayed this to
tcg-scrum, which recorded it on 2026-10-30. The basis is the same as above: a developer direction,
`status: reference`, which TCG can overrule. Nobody at TCG signed it off.

11. **Q9: the permit edit page and the PATCH of the new fields are in TCG-132.** The following stay in
    this ticket:
    - the edit page `/permits/:id/edit` for the five modal types;
    - `PATCH /permits` accepting `validFrom`, `travelFrom`/`travelTo`, `originYardId`,
      `destinationJobSiteId` and the application-submitted and permit-received dates;
    - the scoped project and asset edit routes rendered through `PermitEditRouteGate`.

    This amends the spec's earlier scope ("PATCH not changed by this ticket", REQ-04 *Edges*; edit pages
    a follow-up, §11c / §13). Source: issue (a).
12. **Q13: the Annual type is renamed app-wide.** `PERMIT_TYPE_LABELS.TRAVEL_ANNUAL_PURPLE_PERMIT` reads
    "Annual Travel Permit" everywhere: lists, filters, tracker, print and DAS. This **reverses point 9 (Q5)
    and spec D8 for this one label only**. Every other type's prototype label stays modal-only. Source:
    issue (c).
13. **Q7: a directly created permit counts as filled in.** `savedAt` is set on every direct
    `POST /permits`, so no directly created permit shows the "Not filled in yet" banner. Permits minted from
    a quotation still start with `savedAt` null and show the banner until their first save. Issue (b) named
    only modal-created permits. Extending the rule to the three older create pages applies the
    one-rule-for-every-caller reasoning Haris confirmed in Q6 (point 10).

### Why (addendum)

- **The edit page was already built and live-tested.** Haris asked for it after the live test.
  Reverting it would remove what he asked for, so the spec's scope line is amended rather than the code
  reverted.
- **One label, not the whole set.** He asked about the Annual label only. Q5 stands for the other four
  types.
- **One start state for every direct caller.** `PermitsService.create` cannot tell the modal from the
  older pages (same reason as D11 / Q6).

### Not settled by this addendum

These were **not answered by a person**. Each is recorded as an AI decision in `aidlc/TCG-132/spec.md`
§11b with `needs developer: yes`, awaiting developer review:

- **Q8 (D20).** An Annual permit with a job and an asset takes no (job, asset) slot, on create or update.
- **Q10 (D21).** Valid to cannot be cleared on edit once set.
- **Q11 (D22, D23).** The PO is hidden on edit, and the scoped edit routes render in place.
- **Q12 (D24).** A Type alone is not unsaved data.
- **Q14 (D25).** A PO may be shared across permits, and the picker for a job-less, project-less permit
  lists all tenant POs. This conflicts with the still-open
  `projects-jobs/gaps.md#permitpo-reverse-cascades-incomplete`. That entry stays open and has a pointer
  added on 2026-10-30.

### Effect on the vault (addendum)

Done 2026-10-30 by tcg-scrum:

- `aidlc/TCG-132/spec.md` §12: Q7, Q9 and Q13 now read `resolved`, pointing at this note. Q8, Q10, Q11,
  Q12 and Q14 read `recorded as AI decision …, awaiting developer review — not resolved`.
- `projects-jobs/gaps.md#permitpo-reverse-cascades-incomplete`: an *Update 2026-10-30* pointer bullet was
  added. `Status:` stays `open`.

No frontmatter of any other file changed, and nothing was flipped to `verified`.

## Addendum 2026-11-03: prototype re-exploration (Q15–Q18)

After the 2026-10-30 close-out, the approved prototype was explored again and compared with the built app in an
88-row gap analysis. That analysis listed eleven decisions, D-1 to D-11. Syed Haris (developer) answered four
of them directly in the Claude Code session of 2026-10-30 to 2026-11-03. The coordinator relayed them to
tcg-scrum, which recorded them on 2026-11-03. The basis is the same as above: a developer direction,
`status: reference`, which TCG can overrule. Nobody at TCG signed it off. The full question text is in
`aidlc/TCG-132/spec.md` §12 Q15–Q18.

14. **Q15 (D-1): a Valid to in the past stays blocked on create.** The web keeps its min date and the API
    keeps `IsNotBeforeToday`. Under Valid to the app shows an amber "Expires in N days" banner and a green
    "Valid until {date}" banner (the prototype's 30-day line). Detail and edit show a red "expired" note for
    a permit that has already expired.
15. **Q16 (D-3): a successful Create Permit opens the new permit.** The modal closes and the app goes to the
    new permit's detail page with **no** success toast. The failure toasts for the PO and attachment steps
    stay.
16. **Q17 (D-4): a second active Annual permit for the same asset, type and city is allowed.** The API's
    duplicate-annual 409 (`assertNoActiveDuplicatePermit` / `findActiveDuplicate`) is removed. The green
    banner under Asset is advisory. This **supersedes spec AI decision D27** (the duplicate rule scoped to
    asset types) and the one-active-annual rule before it. No decision note ever wrote that rule down. It was
    code, asserted by `qa-automation/e2e/specs/permits/duplicates.spec.ts`, and that existing spec now asserts
    the opposite (commits `de3452a5b`, `919bcc34a`).
17. **Q18 (D-10): a linked Annual counts toward the DAS pre-checklist Permits row only when it is APPROVED.**
    The existing checklist logic is kept. A modal-created Annual starts at Open (point 10), so linking it
    does not turn the row green until it is approved.

### Why (addendum 2026-11-03)

- **Q15:** a past-dated create has no known business use. Allowing it would change an API rule shared with
  three other create pages. The banners give the prototype's feedback without that change.
- **Q16:** this is what the approved prototype does. The partial-failure toasts still show after the route
  change.
- **Q17:** this follows the prototype, where the found-annual banner does not block. The gap analysis
  recommended keeping the 409, and Haris chose otherwise. It also fits TCG's own tracker, which keeps
  current, future and historical permits for a city as separate records
  (`projects-jobs/city-permits/permit-tracker-workbook.md`:120-124, `unverified`).
- **Q18:** an annual that is not yet approved does not cover the crane.

### Not settled by this addendum

- **The open vault question on the duplicate guard.** Item (d) of
  `projects-jobs/gaps.md#permit-rules-the-e2e-suite-asserts-with-no-written-source--pr-488` asks its owners
  (Lisette Anzaldo, Liz Lopez) whether the guard is one active annual per (asset, type, city). Point 16 is a
  developer direction for the build, not their answer, so the entry stays **open**. It now has a pointer.
- **The other gap-analysis decisions (D-2, D-5 to D-9, D-11) and the build choices of U11–U16.** No person
  answered these. They are AI decisions D34 onward in `aidlc/TCG-132/spec.md` §11b, `needs developer: yes`,
  awaiting developer review. Among them are the Asset ⓘ popover, which stays open until toggled (an owner
  instruction relayed with the build; it is not recorded here as a decision), and the DAS "Link annual
  permit" flow.

### Effect on the vault (addendum 2026-11-03)

Done 2026-11-03 by tcg-scrum:

- `aidlc/TCG-132/spec.md` §12: Q15–Q18 were added, each reading `resolved`, with a pointer to this addendum.
  The §12 intro now says where they came from.
- `projects-jobs/gaps.md#permit-rules-the-e2e-suite-asserts-with-no-written-source--pr-488`: an
  *Update 2026-11-03* pointer bullet was added. `Status:` stays `open`.
- This note: `resolves:` gains `TCG-132/spec.md#q15` to `#q18`.

No frontmatter of any other file changed, and nothing was flipped to `verified`. AI decision D27 lives in
the spec's §11b, which tcg-scrum does not write, so marking it superseded there is a handoff. The same goes
for the `INDEX.md` row.

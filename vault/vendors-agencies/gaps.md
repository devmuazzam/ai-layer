---
title: Vendors Agencies — open questions
status: reference
kind: gaps
updated: 2026-09-15
tags: [module/vendors-agencies, kind/gaps, open-questions]
---

# Vendors Agencies — open questions

Live register per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*. Ticket-raised
questions do **not** go here — they belong in that ticket's `spec.md` §12.

Entry format (unchanged from the retired registers, so the global sweep still works):

```markdown
## <question title>
- **Status:** open
- **Asked:** YYYY-MM-DD — by whom / which work raised it
- **Question:** one paragraph
- **Sources checked:** what was read before declaring this open
```

## Purchase orders at three levels — Joe and Ryan on tape, nothing written

- Question: may a PO be created **standalone** — not linked to any job — and should a PO created at
  the **quotation** level be cancelled automatically when the quote is lost?
- Candidates:
  - Recording **2026-03-12 "Sales-Pricing in FCC"** — the strongest attribution in the whole product
    set; this transcript carries reliable speaker labels. **Joe Schacatano at 1:15:04**: *"Freely at
    any point if we wanted to just create a PO in general. So really having it at the quotation…
    Also having the ability to do it within a job again if that was just a scheduled job with no
    quotation."* At **1:15:23**: *"And then third, completely separately if we just need to create a
    PO in general for for the business for a vendor."* At **1:18:47**: *"Yeah, yeah, really. Yeah.
    **Any level** and have the ability to tie it to something… **It's got to have a trail. It's got
    to lead us to a reason of why it's even in there** to begin with, right?"* And at 1:15:x he gives
    the reason: in FCC a PO created before the job *"can get lost in translation because it's not
    tied to anything."*
  - Same recording, **Ryan Adams at 1:16:59**: *"either quote is pending won or lost and **if it's
    lost it closes out the PO**. If it's won it processes the PO to go to the next level… so that way
    we don't get a backlog in our system."* **Joe Schacatano at 1:17:42: *"I agree with that."***
  - `meetings/2026-06-22-sprint-4-additional.md:91` (`conflicts_with: []`, updated **2026-06-22** — three months
    *after* the recording) — *"Every PO must be linked to a job number this is required, not
    optional"*. Note :92 already grants quotation-level POs carrying over, and :102 already grants a
    global PO list, **so the only genuine contradiction is the standalone case.**
  - `SCRUM-518` *PO Implementation on projects and global level* — **Done**, **`description: null`**.
    Its QA comment lists the four creation surfaces actually built — *"1. yards 2. assets 3. projects
    4. main side bar"* — **none of which is the quotation** — and complains at item 16 that the form
    *"is allwoing the creation of empty records"*, i.e. the job link was not enforced.
  - `SCRUM-473` *Add PO to main side navigation* — **Done**. *"PO creation **allows** linking to a
    specific project, job, and vendor"* — permissive, not mandatory. `SCRUM-478`, the parent
    **Purchase Order epic**, is still **To Do** with `description: null`, untouched since 2026-05-25.
  - `vendors-agencies/purchase-order.md` (`conflicts_with: []`) — documents only the **permit-driven** path
    and names **Liz Lopez** and **Jeff Stricker** as the two PO owners. It never mentions the
    quotation level, standalone POs, or the mandatory-job-link rule.
- Note: on the standalone half the vault line is simply **wrong about the built system** —
  `model PurchaseOrder` has `jobId String?` (**nullable**), `poType PoType? @default(GENERAL)`, and
  **no quotation relation at all**. So the recording and the code agree and
  `meetings/2026-06-22-sprint-4-additional.md:91` is the outlier — yet that file carries `conflicts_with: []`,
  so an agent reading it has no signal to doubt it. The rest is state (d): **two named TCG people
  specified three creation levels, a mandatory audit trail, and a quote-lost→PO-closed rule on a
  reliably-labelled transcript, and none of it is written anywhere.** The quotation-level PO and the
  quote-lost rule were **never built and have no ticket** — invisible rather than merely contested.
- Blocked: `SCRUM-478` (epic, To Do, empty); the PO audit-trail requirement; any quotation-level PO
  work; the accounting reconciliation Ryan described.
- Owner: Joe Schacatano (stated the three levels) and Ryan Adams (stated the cancellation rule) —
  sales & quotation. Liz Lopez for how it meets the permit-driven PO path she owns.
- **Status:** open — needs confirmation on standalone POs, the mandatory audit trail, and the quote-lost → PO-closed rule. **PO type taxonomy resolved 2026-09-05** (Brian Petros) — see the update at the end of this entry.
- **From (frozen original):** [gaps.md#purchase-orders-at-three-levels-joe-and-ryan-on-tape-nothing-written](../gaps.md#purchase-orders-at-three-levels-joe-and-ryan-on-tape-nothing-written)
- Update 2026-09-04 (Project Repository ingest): the December 2025 draft P&P set in
  [purchase-orders-fcc/](purchase-orders-fcc/INDEX.md) is the first written material on either half
  of this question — and all of it is **FCC practice, not a TCG decision for the new ERP**; all three
  P&Ps are drafts by Brian Petros with Effective Date `[fill in]`, never shown approved.
  **(a) Standalone.** FCC does not require a Job on a PO: the Job Number sits on the *Detail* line
  and both the policy and the walkthrough say to leave it blank when no Job exists —
  [po-001](purchase-orders-fcc/po-001-pre-job-purchase-orders.md) → *Step 3 — Detail lines*;
  [fcc-po-entry-walkthrough](purchase-orders-fcc/fcc-po-entry-walkthrough.md) → *[Detail] tab*:
  *"Include the Job Number — if there is no Job yet, leave it blank"*.
  [po-002](purchase-orders-fcc/po-002-vendor-billing-and-customer-invoicing.md) rule 2:
  *"Quote-anchored POs are valid even if no Job exists yet"*, and AP may voucher against them. The
  Fleet parts POs in the purchasing-guide screenshots (`FL-1723`, from requisition `FL-1628`) hang
  off a Work Order and Unit, never a job
  ([fcc-nexgen-purchasing-guide](fcc-nexgen-purchasing-guide.md) → *The requisition-to-PO link*).
  So FCC's own record sides with the built `jobId?` and with Joe, and
  `meetings/2026-06-22-sprint-4-additional.md:91` stays the outlier. **But every no-job PO in the
  drop is still anchored to something** — a Quote Number, which PO-001 rule 2 makes *mandatory* when
  no Job exists, or a work order — which matches Joe's "it's got to have a trail"; a PO tied to
  nothing at all (his third, "for the business" case) appears nowhere in the drop, and
  [dispatch/travel-permits-playbook.md](../dispatch/travel-permits-playbook.md) has Dispatch
  *"create a PO# against the job number"* for permits.
  **(b) Quote lost → PO closed.** Nothing automatic exists in FCC. In FCC a PO is closed by a
  voucher (fcc-nexgen-purchasing-guide → *The four-stage chain*), not by a quote outcome;
  [po-003](purchase-orders-fcc/po-003-linking-pre-job-pos-to-jobs.md) → *Step 5* and *Controls* has
  AP *periodically* review POs carrying a Quote Number but no Job Number, establish with
  Sales/Dispatch whether the Job was *"cancelled, never booked, or still pending"*, and *"link or
  close out"* by hand — no report named, no frequency set. The page itself records that it *"does
  not say what to do with a quote-only PO whose Job was cancelled, beyond 'resolve' it"*, and PO-002
  says the same for a Job cancelled after AP has vouchered. The mechanism all three P&Ps rely on —
  the quote number in a comments field — also carries Melissa McNutt's unanswered 3 Dec 2025
  objection ([commissioning-email-thread](purchase-orders-fcc/commissioning-email-thread.md) →
  *The unresolved objection*).
  **Still needs the client:** whether the new ERP requires an anchor (job, quotation, work order or
  other) on every PO or allows a truly unanchored one; whether quote-lost → PO-closed is automatic
  (Ryan and Joe on tape) or stays a periodic AP audit (PO-003); and the same person must dispose of
  the 2026-06-22 "every PO must be linked to a job number" line, which the drop contradicts for FCC
  but does not overrule for the ERP.

- Update 2026-09-05 (**Brian Petros**, written message + quote-to-job-to-invoice workflow diagram —
  [decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md](../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md)):
  **partial — two of Joe's three levels are now confirmed by a named human, the third is still not.**
  Brian: the vendor PO *"kicks off when the Quote is created and/or after the Job is created (when
  third-party services are involved), and loops again if there's a change order."* The diagram shows
  both, as a dashed optional *"Issue vendor PO — optional, early, at quote stage"* off *Add resources
  & line items*, and as *"Issue vendor PO — via permit, or directly to job"* after conversion. So
  **quotation-level and job-level vendor POs are confirmed wanted**, which was Joe's point at 1:15:04.
  **Standalone POs are not mentioned at all** — Joe's third level (1:15:23, *"completely separately if
  we just need to create a PO in general for the business for a vendor"*) remains unconfirmed, as does
  his mandatory audit trail (1:18:47).
  **Ryan's quote-lost → PO-closed rule is neither confirmed nor contradicted.** The diagram's only
  revision path is *"Change order needed? → Update vendor PO → back to Submit to customer"* — a
  re-issue loop, not a cancellation. A lost quote does not appear on the diagram at all.
  Separately, Brian's message **does** settle the PO *taxonomy* that
  [purchase-orders-fcc/INDEX.md](purchase-orders-fcc/INDEX.md) recorded as needing a human: it is
  **Type 1 Customer (inbound) / Type 2 Vendor (outbound)** — Melissa's direction-based split, not
  `purchase-order.md`'s who-owns-the-process split, and not the undefined `Internal / Customer` pair
  in `meetings/2026-06-22-sprint-4-additional.md:81`.

- Update 2026-09-11 (**Syed Haris** after **Umer Islam**, CodingCops —
  [decisions/2026-09-11-outbound-po-subtypes-and-modal-fields.md](../decisions/2026-09-11-outbound-po-subtypes-and-modal-fields.md)):
  **outbound subtype + modal fields + OPEN|CLOSED status locked** (`status: reference`). Outbound
  `PurchaseOrder.poType` is **`PERMIT` | `VENDOR` | `ASSET`**. Modal fields: PO type, PO number,
  PO items, **Agency** (not Vendor), invoice attachment. Statuses in the permit attach flow:
  **`OPEN` | `CLOSED`**. Does **not** settle Joe’s standalone level, the audit trail, or Ryan’s
  quote-lost → PO-closed rule — those remain open above. Orthogonal to Brian’s inbound/outbound
  direction taxonomy.

## PO and vendor/agency rules the E2E suite asserts with no written source — PR #488

- **Status:** open
- **Asked:** 2026-09-07 — raised reviewing **PR #488** (`qa-automation-employees`). The specs
  under `qa-automation/e2e/specs/purchase-orders/` (`auto-activation.spec.ts`, `line-items.spec.ts`,
  `validation.spec.ts`, `lifecycle.spec.ts`), `.../vendors/` (`duplicates.spec.ts`,
  `billing.spec.ts`, `lifecycle.spec.ts`, `references.spec.ts`, `validation.spec.ts`) and
  `.../agencies/` (`duplicates.spec.ts`, `restrictions.spec.ts`, `lifecycle.spec.ts`,
  `references.spec.ts`) assert rules **reverse-engineered from the running build** — their case docs
  say *"verified against the live API on 2026-09-07"*, which verifies them against the code, not
  against anyone's intent. Merging freezes current behaviour as expected behaviour.
- **Question:** nine rules, each answerable in a line. **Purchase orders — (a)** does a `PENDING` PO
  **auto-promote to `ACTIVE`** once an invoice number *and* an attachment both exist, and does
  `DRAFT` never promote? **(b)** Is the PO total *line subtotals − discount* with the **PO fee
  excluded**, and does a discount over 100% floor at 0? **(c)** Does a `belongsToAsset` toggle
  switch a line between an `assetId` and a *part + description* pair, nulling the other side?
  **Vendors / agencies — (d)** do duplicate **name** (case-insensitive, trimmed) and duplicate
  **email** each return 409, does archiving **not** free them, and is a record updating itself
  exempt? **(e)** Are vendor codes auto-minted as `VEND-#####`? **(f)** What are the vendor billing
  enums — type, category, **eleven** billing terms, 1099 type, due-date type? **(g)** Should an
  unreferenced vendor or agency **hard-delete** (204, cascading to children)? **(h)** What are the
  agency **time-restriction** mechanics? **(i)** Should vendor/agency routes carry a permission
  guard at all?
- **Sources checked:** **Nothing states any of the nine.** (a) and (b) are **already declared
  unspecified by a decision** — [../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md](../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md)
  §*What this does NOT settle* (`status: reference`): *"**PO status values.** The 7 steps are
  lifecycle stages, not necessarily stored statuses"*, with `Pending / Confirmed / Paid` and Ryan
  Adams' *"open PO until it's closed out"* left *"unreconciled"*; and *"**The `area`, `city`, `PO
  fee`, `discount %` and `invoice #` fields** now built and mocked up. **Still unspecified.**"* That
  line is the vault's only mention of `PO fee` anywhere. The one written status list —
  [../meetings/2026-06-22-sprint-4-additional.md](../meetings/2026-06-22-sprint-4-additional.md):97
  (`status: unverified`), *"Each PO shows one of three statuses  Pending, Confirmed, Paid"* — has
  **no `DRAFT` and no `ACTIVE`**, so the specs' vocabulary is a fourth one. The same file :87 notes
  an invoice or receipt can be attached but attaches **no consequence** to it. (c) `belongsToAsset`
  appears nowhere; the nearest is a form-field list, :84, *"and linked asset if applicable"*.
  (d), (e), (g): no 409, no 204, no `VEND-` anywhere — the only legacy vendor codes are FCC's
  three-letter form (`ROA001`, `COA003`, demo *"AUTO SU"*,
  [fcc-nexgen-purchasing-guide.md](fcc-nexgen-purchasing-guide.md):314), and
  [vendors.md](vendors.md):37 lists the create form with **no uniqueness constraint at all**.
  On (g), [../decisions/2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md)
  §*What this does NOT settle* names the question and **declines it** — *"Whether the `DELETE`
  endpoints stay… is undecided"*, *"Whether an admin hard-delete escape hatch exists… **Do not
  build one and do not assume its absence**"* — and leaves the cascade half open too. So the shipped
  hard-delete is neither sanctioned nor forbidden.
  **(f) is Conflicted — note only, do not answer from one file.** Per
  [agencies-vendors-INDEX.md](agencies-vendors-INDEX.md) (`kind: conflict-stub`): *"**None of these
  is verified. Do not answer from one of them alone.**"* — `vendors.md` 3.7 KB / 2026-04-30 (user
  stories) · `agencies.md` 1.0 KB / 2026-04-30 (user stories) · `agencies-module.md` 1.4 KB /
  2026-07-22 (punch list) · `agency-and-vendor.md` 0.2 KB / 2026-06-22 (punch list), with the stub's
  own warning that *"the two **newest** files are the two **smallest**, and both are punch lists…
  Ordering by date discards the specification and keeps the bug list."* The entire written basis for
  the billing enums is four bare bullets in the smallest of them,
  [agency-and-vendor.md](agency-and-vendor.md):15-19 — *"Add category inside vendor to make them sub
  contractor · add contact information · add billing terms · Taxable related fields"* — **no values
  and no counts**, so the number **eleven** is sourced nowhere. `1099` returns **zero hits
  vault-wide**; the `Net 15/30/45/60/90` tables are **customer** terms in FCC/QuickBooks legacy data
  ([../customers/fcc-legacy-customer-data-model.md](../customers/fcc-legacy-customer-data-model.md):344-351),
  as is the only `dueDateType`. A vendor **type** was asked for on tape and never specified —
  Melissa McNutt @ 21:59, [../meetings/transcripts/2026-06-17-erp-sprint-review.md](../meetings/transcripts/2026-06-17-erp-sprint-review.md):153,
  *"vendor type would be helpful… service or parts or subcontractor."*
  **(h): existence only, mechanics nowhere.** Two punch-list lines
  ([agencies-module.md](agencies-module.md):28 *"time restrictions layout need to be change at view
  page"*; [agency-and-vendor.md](agency-and-vendor.md):23 *"Add travel restrictions for agencies"*)
  state no window semantics, no evaluation against a job date, and no effect when violated. The only
  mechanic-shaped material is a **CodingCops proposal**, not a decision — jahanzaib.nadeem @ 17:26,
  same transcript :135: *"we should add a field or maybe a checkbox… labeled as travel restrictions.
  And once that checkbox is checked, then we can show the exact time, like the from time and a to
  time"* — answering Melissa's **city** example @ 16:24, not an agency rule.
- **Related, already open — do not duplicate:** [*Purchase orders at three levels — Joe and Ryan on
  tape, nothing written*](#purchase-orders-at-three-levels--joe-and-ryan-on-tape-nothing-written)
  in this file holds the standalone-PO and audit-trail half. **(i) is an instance of** the unbuilt
  authorization layer — [../admin/gaps.md#departments-roles-and-their-capabilities--the-authorization-layer-is-unbuilt-and-the-list-is-unwritten](../admin/gaps.md#departments-roles-and-their-capabilities--the-authorization-layer-is-unbuilt-and-the-list-is-unwritten)
  (Abdul Rehman, 2026-09-01: *"right now we haven't implemented any authorization layer based on
  these department and roles"*; *"**Blocked:** every permission check in the app"*). Do not answer
  (i) here.
- **Blocked:** merging PR #488's PO, vendor and agency specs as a behavioural contract; `SCRUM-478`
  (PO epic, To Do, empty description) still cannot be specified without (a) and (b).
- **Owner:** product team — Joe Schacatano and Ryan Adams for the PO lifecycle (they own the related
  entry above), Liz Lopez for the permit-driven PO path, Melissa McNutt for the vendor type and
  billing terms she raised on 2026-06-17.

## The PO sidebar flattens to one leaf — and the two things "tracking" could have meant are both unbuilt

- **Status:** open
- **Asked:** 2026-09-09 — PR review of `fix/quotation-permits-plans`, commit `92bc9ea3d` (no ticket, no `processed.log` row, no ticket folder).
- **Question:** the branch collapses the sidebar's expandable **"PO's"** group — children *"All PO's"* (`/pos/all-pos`) and *"Track PO's"* (`/pos/track-pos`) — into a single leaf at `/pos`, hosts the listing there, and redirects `track-pos`. **Nothing in the vault ever asked for a "Track PO's" page**, so removing it matches the record. Two things do not: **(a)** the epic's global-list AC requires the list *"can be filtered by type Internal or Customer"*, which is unbuilt and whose two type names the 2026-09-05 decision supersedes anyway — what is the filter now, `GENERAL`/`CONTRACT`, Brian's Type 1/Type 2, or nothing? **(b)** the one real "PO tracking" ask on tape is **customer-PO balance burn-down**, and it has no home at all. Does it belong on this page, on the project, or in accounting?
- **Sources checked:** [../meetings/2026-06-22-sprint-4-additional.md](../meetings/2026-06-22-sprint-4-additional.md):100-103 — the **only** written PO navigation requirement, and it asks for **one** list: *"A global PO list in the main sidebar shows all POs across all projects and jobs"* / *"The list can be filtered by type Internal or Customer"*. The word *"Tracking"* does head :95-98 in the same AC, but its two bullets are the three PO **statuses** (`Pending, Confirmed, Paid`) and the **in-project** list — not a second page. `SCRUM-473` is titled *"Add PO to main side **navigation**"* (singular) and `SCRUM-518` *"PO Implementation on projects and global level"* — both **Done**, both quoted in the entry above; `SCRUM-478`, the epic, is still **To Do** with `description: null`. [../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md](../decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md):46 — the build survey calls the shipped module *"global POs"*, one module, a peer of *"global permits"*. [../erp-review-log.md](../erp-review-log.md):322 — the client's own module list has **no PO module at all**. Every *tracker* in the vault is the Permit Tracker or the Planning Tracker; the PO's only relationship to one is the reverse direction — a *Create PO* button **on** the permit tracker ([../meetings/transcripts/2026-07-29-erp-review-dispatch-das-update.md](../meetings/transcripts/2026-07-29-erp-review-dispatch-das-update.md):82).
- **Note on (b):** **Melissa McNutt @ 44:17**, [../meetings/transcripts/2026-07-07-cc-tcg-erp-system.md](../meetings/transcripts/2026-07-07-cc-tcg-erp-system.md):205 — *"for the POs, customers POs right now, they give us, it usually has a number and amount, and then like a term on it. **So if we could track that**… we would need indicators to tell us, hey, you know, **you have 30% of your PO left**, so then we can reach out to them to increase it with the change order."* Corroborated by Sammy Garrett describing the Excel he does it in today ([../meetings/transcripts/2026-07-30-invoice-processing.md](../meetings/transcripts/2026-07-30-invoice-processing.md):52, :55) and by Melissa again at [../meetings/transcripts/2026-07-28-invoicing-details-contracts-certs-trainings.md](../meetings/transcripts/2026-07-28-invoicing-details-contracts-certs-trainings.md):357. That thread is registered under **accounting**, not here — [../accounting/gaps.md](../accounting/gaps.md) → project-level accounting / contract-amounts tracker, where Melissa answers *"Yes"* to wanting it and nobody has specified it. It is a **customer**-PO balance against a contract amount, so it is Type 1 and belongs nowhere near the vendor-PO listing; recorded here only so the retired route name is not mistaken for it later.
- **Blocked:** nothing — the flatten matches the one written nav requirement. Recorded so (a) and (b) are not lost with the route.
- **Owner:** Melissa McNutt for the balance-tracking ask (she raised it three times); Brian Petros for what the type filter should now say, since his 2026-09-05 taxonomy replaced *Internal / Customer*.

## What makes a permit PO-exempt — see projects-jobs/gaps.md

- Cross-module pointer (no status of its own — the sweep counts it once, in `projects-jobs/gaps.md`).
  `fix/quotation-permits-plans` (2026-09-10) adds the new generic `ASSET` permit type to
  `PO_EXEMPT_PERMIT_TYPES`, replacing the **annual-vs-single** axis this module's PO record
  states ([purchase-order.md](purchase-order.md):97-109 / :198-216, `unverified`;
  [../decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md](../decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md),
  `reference`, Brian Petros + Melissa McNutt) with an **asset-vs-job** one that no source states.
  The PO rule is owned here; the entry sits with the other permit-artifact questions.
  Full entry: [projects-jobs/gaps.md](../projects-jobs/gaps.md#po-exemption-swaps-the-annual-vs-single-axis-for-asset-vs-job--and-annual-stops-being-expressible).

## Branch fix/das-fixes — one CLOSED status for invoiced and cancelled POs, and the legacy remap

- **Status:** open, for the second half of (c), (e), (f) and (g) only. (a), (b), the first half of (c), and (d) were resolved 2026-09-11; see the next bullet.
- **Resolved in part 2026-09-11, by Fouzan Shakil (CodingCops, `reference`, not a TCG sign-off):**
  - **(a), (b), first half of (c).** Settled by [../decisions/2026-09-11-po-closed-means-closed-out-not-cancelled.md](../decisions/2026-09-11-po-closed-means-closed-out-not-cancelled.md):
    - `CLOSED` means closed-out, not cancelled. A closed PO keeps its permit links and its type, and stays visible on the permit tracker.
    - It auto-closes **only** when an attachment in an Invoice category is uploaded. Archiving never closes it, and an invoice number alone does not.
    - There is an explicit Close/Reopen control. The PO auto-reopens when its last Invoice-category attachment is removed.
    - Archive is the path that unlinks permits.
  - **(d).** Settled by [../decisions/2026-09-11-legacy-po-and-permit-type-remap.md](../decisions/2026-09-11-legacy-po-and-permit-type-remap.md). Rows are remapped by legacy status, not by invoice number:
    - `PURCHASED`, `ACTIVE`, `CANCELLED`, `INACTIVE` → `CLOSED`; `PENDING`, `DRAFT` → `OPEN`.
    - `GENERAL`, `CONTRACT` → `VENDOR`.
    - The migration is edited in place, since only local dev databases had applied it.
  - **Still open:**
    - Second half of (c): may a `CLOSED` PO be **newly** attached to a permit?
    - (e) and (f).
    - **(g), new 2026-09-11 (yes/no).** Should an **FCC-imported** PO whose FCC status is `ACTIVE` import as `CLOSED`? Background:
      - The decision maps the ERP's legacy `ACTIVE` → `CLOSED` and gives the FCC seeder's `mapPoStatus` as its basis.
      - The seeder committed on the branch mapped `ACTIVE` → `OPEN` (`apps/api/fcc-seeder/src/lib/seed-helpers.ts`:112-123).
      - A same-day change, uncommitted when this was written, moves the seeder's `ACTIVE` to `CLOSED` so that the two agree.
      - They read different vocabularies. The ERP's legacy `ACTIVE` was reached only by auto-promotion once an invoice number and an attachment both existed (see (a) of the PR #488 entry below). FCC's `ACTIVE` is FCC's own status text, and nothing recorded says it means closed-out.

      The ERP half is decided; the FCC-import half is not. Owner: Fouzan Shakil. Blocks: the next FCC import run with the changed seeder.
- **Asked:** 2026-09-11 — PR review of branch `fix/das-fixes` (no ticket, no `.ai/aidlc/` folder); tcg-scrum escalation. Commits `da4551792` (enums, migration `20260910180000_po_permit_type_status_correction`, create/update rules) and `48d93f9f6` (permit-tracker PO filter).
- **Question:** the 2026-09-11 lock fixes the *vocabulary* (`OPEN | CLOSED`, `PERMIT | VENDOR | ASSET`) but not what moves a PO between the two statuses, nor what `CLOSED` means. The branch gives `CLOSED` two meanings. Six parts, each answerable in a line. **(a)** Does `CLOSED` mean *invoiced / fulfilled* or *cancelled*, and if both occur, is a third status needed? The branch closes a PO when an attachment is uploaded (`purchase-orders.service.ts` `activateIfReady`: *"invoice attachment closes the PO"*). But a `CLOSED` set through the edit form is treated as a cancellation: it unlinks the PO's permits, clears `permitId`, reclassifies `poType` to `VENDOR` and logs the permit's PO as `'cancelled'`. The permit tracker filters `CLOSED` out with the comment *"CLOSED is the cancelled state"* (`apps/api/src/service/permits/permits.repository.ts`). So a permit's PO drops off its tracker card as soon as an invoice is attached. **(b)** Does uploading **any** attachment close the PO, only an invoice, or only an explicit user action? An invoice number on its own no longer changes status. **(c)** When a permit-linked PO closes, does the permit keep it? May a `CLOSED` PO be attached to a permit? The branch removes the guard that used to refuse this. **(d)** Legacy rows: should `CANCELLED`, `INACTIVE`, `DRAFT` and `PENDING` POs with no invoice number become `OPEN` (so cancelled POs re-open), and should every `GENERAL` / `CONTRACT` PO become `VENDOR`? The migration closes a PO when `invoice_number` is non-empty, which is the opposite of the runtime rule in (b). **(e)** On create, may status and valid-till be left out (status defaulting to `OPEN`), and should PO fee default to the line-item total? **(f)** What is an `ASSET` PO for, given the branch forbids linking one to a vendor asset and strips asset links from its lines?
- **Sources checked:** [../decisions/2026-09-11-outbound-po-subtypes-and-modal-fields.md](../decisions/2026-09-11-outbound-po-subtypes-and-modal-fields.md) (`status: reference`; Syed Haris after Umer Islam, not a TCG sign-off) locks the two vocabularies and the modal fields (type, number, items, Agency, invoice attachment). It states no transition, gives `CLOSED` no meaning, and says nothing about `ASSET` POs beyond the name. [../decisions/2026-09-11-quote-to-project-permits-plans-flow.md](../decisions/2026-09-11-quote-to-project-permits-plans-flow.md) point 16 says only *"PO statuses in this flow: Open and Closed"*. [../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md](../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md) records PO fee as *"Still unspecified"*, and its 7-step vendor cycle closes through goods receipt and three-way match, not an upload. [../meetings/2026-06-22-sprint-4-additional.md](../meetings/2026-06-22-sprint-4-additional.md) (`unverified`): :84 lists *"valid till date"* among the create fields without saying whether it is required; :87 *"An invoice or receipt can be attached directly to the PO"* attaches no consequence; :97 gives *Pending, Confirmed, Paid*. FCC practice, not an ERP rule: [fcc-nexgen-purchasing-guide.md](fcc-nexgen-purchasing-guide.md):44 (`unverified`), *"Vouchers are vendor invoices, used to close out purchase orders"*. On tape (`reference`): Ryan Adams, `../meetings/transcripts/2026-03-12-sales-pricing-in-fcc.md`:384, says a lost quote *"closes out the PO"* (closing as cancellation). Brian Petros, `../meetings/transcripts/2026-06-18-dispatch-permits.md`:194: *"we would not be able to cancel a PO"*; Melissa McNutt, :195: *"maybe we can cancel the job and not the not the PO"*. **Nothing written on remapping legacy PO statuses or types.** Jira not checked (no Jira MCP in this session).
- **Related, already open — do not duplicate:** [*PO and vendor/agency rules the E2E suite asserts… PR #488*](#po-and-vendoragency-rules-the-e2e-suite-asserts-with-no-written-source--pr-488) (a) covers the old `PENDING → ACTIVE` promotion this branch replaces, (b) PO fee in the total, (c) `belongsToAsset`. [*Purchase orders at three levels*](#purchase-orders-at-three-levels--joe-and-ryan-on-tape-nothing-written) covers quote-lost → PO closed. [projects-jobs/gaps.md → *Permit↔PO reverse cascades incomplete*](../projects-jobs/gaps.md#permitpo-reverse-cascades-incomplete) asks what the permit side does when a PO is cancelled; this entry asks the question before it, whether `CLOSED` *is* cancelled.
- **Blocked:** merging `fix/das-fixes`' migration and how the permit tracker displays POs were blocked on (a)–(d), settled 2026-09-11 (above). The status remap is lossy: the six legacy statuses collapse to `OPEN | CLOSED` (`PURCHASED`/`ACTIVE`/`CANCELLED`/`INACTIVE` → `CLOSED`, `PENDING`/`DRAFT`/`NULL` → `OPEN`), and the original value is not kept. (g) blocks the next FCC import run with the changed seeder.
- **Owner:** Brian Petros and Liz Lopez (the PO process); Syed Haris and Umer Islam for what their 2026-09-11 `OPEN | CLOSED` lock meant.

## Agency form 2026-09-15 — jurisdiction values on Ben's sheet that the dropdown cannot hold
- **Status:** partly resolved 2026-09-15 — Syed Haris added **Unincorporated / CDP** to the dropdown (PR `feat/agency-form-rework`). Still open for `Town` (3 rows) and `Community / Jurupa Valley Area` (3 rows).
- **Asked:** 2026-09-15 — building the final agency form ([../decisions/2026-09-15-agency-creation-form-final-fields.md](../decisions/2026-09-15-agency-creation-form-final-fields.md)) against `City List turn around - Ben.xlsx`
- **Question:** Ben's 500-row sheet uses five jurisdiction values — `City` (239), `Unincorporated / CDP` (243), `Unincorporated Community` (12), `Town` (3), `Community / Jurupa Valley Area` (3). Ehtesham's dropdown is City · County · Township · Borough · Village · State · Federal · Special District · Other. Half the sheet is *Unincorporated / CDP*, which has no entry; `Town` has none either. Should the dropdown gain **Unincorporated / CDP** and **Town**, or do those rows import as `County` (the permit authority for unincorporated areas) / `Other`? The build ships Ehtesham's list unchanged.
- **Sources checked:** the sheet (all three tabs); `agencies.md`, `agencies-module.md`, `agency-and-vendor.md`; transcripts 2026-03-26 and 2026-06-18; decisions 2026-09-11 (permit flow, PO modal).

## Agency form 2026-09-15 — the sheet's "Estimated TCG Planning Lead Time" has no field
- **Status:** open
- **Asked:** 2026-09-15 — same work as above
- **Question:** Ben's sheet carries two lead times per city: the agency's *Permit Lead Time* (on the form) and an *Estimated TCG Planning Lead Time (Days)* (5 for 431 rows, 3/4 for Orange-County-style overrides), with the note that the latter is "a planning estimate for internal scheduling, not an official agency commitment". The form has only the first. Is the planning estimate a second agency field, a tenant-level default, or not stored at all? Not built.
- **Sources checked:** as above; `vault/quotations/` and `projects-jobs/` for any planning-lead-time requirement (none).

## Agency form 2026-09-15 — Submission Type and Avg Permit Cost: required or not?
- **Status:** open
- **Asked:** 2026-09-15 — same work
- **Question:** Every field on Ehtesham's list carries a Required / Not Required marker except the last two, *Submission Type* and *Avg Permit Cost*. The build treats both as optional (vendor name required once *3rd Party Vendor* is picked; portal URL required once *Portal* is picked). Confirm, or make Submission Type required.
- **Sources checked:** the request text; `agencies.md` (silent); 2026-06-18 recording (describes Quality Permits and portal accounts, says nothing about a required field).

## Agency form 2026-09-15 — portal credentials are stored in clear text
- **Status:** open
- **Asked:** 2026-09-15 — same work
- **Question:** "Portal (Credentials)" is built as a username + password pair on the agency row, returned to any user who can read agencies and shown masked-with-reveal on the detail page. Nothing else in the platform stores a third-party login. Is that acceptable for an internal directory, or should the password be encrypted at rest / restricted to a permission level / replaced by a "credentials are in the password manager" note? Excluded from the activity log diff either way.
- **Sources checked:** the request text; `apps/api` for any existing secret-at-rest pattern (none besides bcrypt user passwords and hashed refresh tokens).

## Agency form 2026-09-15 — is a bulk import of Ben's city list wanted?
- **Status:** open
- **Asked:** 2026-09-15 — same work
- **Question:** The sheet is 500 rows in exactly the form's shape (city, lead time, county, state, jurisdiction, coverage note). Typing them by hand through the form is a week of data entry. Should there be a one-off seed / CSV import for it, and if so which tenant, and what fills the fields the sheet lacks (agency name — presumably "City of X" —, agency type, coverage area, the mandatory time restriction and attachment)? Not built; the form's required rules make a mechanical import impossible without answers.
- **Sources checked:** the sheet; `apps/api/prisma/seed.ts` (no agency seed); `sync/project-repository-2026-09-04.md` (the 894-file city-permit library was dispositioned, never imported).

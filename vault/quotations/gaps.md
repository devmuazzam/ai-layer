---
title: Quotations — open questions
status: reference
kind: gaps
updated: 2026-08-31
tags: [module/quotations, kind/gaps, open-questions]
---

# Quotations — open questions

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

## Sell-side scheduling artefacts — no vault coverage

- Question: what are the Job Schedule Master, the Ready-to-Schedule Checklist, the One-Page
  Customer Intake, the Geographic Heat Map, and "Red Path"?
- Candidates: [meetings/2026-08-12-sell-side-workflow-and-scheduling.md](meetings/2026-08-12-sell-side-workflow-and-scheduling.md)
  only. Brian Petros shared source files in the meeting; **those files are not in the vault**.
- Note: **"Red Path" is undefined.** It is used as though established. Add it to the undefined-terms
  list. Two scheduling rules stated in the meeting — cranes under maintenance must not be
  selectable, and double booking must be *supported* where short jobs allow — belong to the Daily
  Allocation System, and neither of that area's two conflicting sources covers either rule.
- Note also: **permits** (annual vs job-specific, city eligibility, crane-travel permits) have no
  vault coverage. The field-ops FRD lists permits only as a *Pending* BRS topic.
- Blocked: the Customer Intake action item on CC, which depends on TCG confirming the intake
  questions, fields and business rules.
- Owner: TCG team for intake questions/fields/rules; Brian Petros for the workflow source files.
- Status: open
- **From (frozen original):** [gaps.md#sell-side-scheduling-artefacts-no-vault-coverage](../gaps.md#sell-side-scheduling-artefacts-no-vault-coverage)

## "Customer PO" on the quotation — which of three things does it mean?

- Question: does `quotations/quotation.md:26` *"Customer PO"* mean (a) a PO-number field on the
  quotation form, (b) the Customer PO workflow that `SCRUM-575` shipped between Sent-to-Customer and
  Won, or (c) associating customer POs with the customer record — and is a PO number on the
  quotation wanted at all?
- Candidates:
  - Recording **2026-03-06**, `ehtesham.anwar` (**CodingCops**) at 9:13, transcript line 170: *"the
    PO number is going to be available. This functionality is going to be available right there. You
    can create within the quotation as well."* Again the vendor describing his own mockup; the
    2026-03-06 action-items file contains **no** PO item at all.
  - `SCRUM-149` *PO number field — remove it* — **Done**, reporter Aiman Farooq, created 2026-04-22.
    **`description: null`** — no description, no AC, no rationale, no requester. Its only comment
    (Abdul Muazzam) is what establishes the field was on the quotation at all.
  - `SCRUM-575` *Pre-Quote Data Form & Customer PO Form* — **Done**, reporter Umair Khan, created
    2026-06-25, label `Feedback.Sprint.4`. Description in full: *"Add Pre-Quote Data Form and
    Customer PO workflow between Sent to Customer and Won stages."* Its closing comment says it
    shipped under two different names — *"1. new customer packet 2. job and labor compliance
    information request form"*.
  - `quotations/quotation.md:26` (JZ punch list, 2026-06-23) — the bare bullet *"Customer PO"*, one of
    ~20 unelaborated bullets, **post-dating `SCRUM-149`** by two months.
  - `customers/customer-and-job-sites.md:28` — *"Need to associate customer POs with customer -- need
    to ask TCG team to provide customer PO form / data"*. **Phrased as an open question to TCG**,
    never answered.
  - `vendors-agencies/purchase-order.md` — `conflicts_with: []`, and entirely about **vendor and permit** POs
    owned by Liz Lopez and Jeff Stricker. Says nothing about a customer PO on a quotation.
- Note: the built state is unambiguous and is the reason this is answerable in one line —
  `model Quotation` has **no** `poNumber`; `model Project` and `model Job` both do. A vestigial
  `poNumber?: string | null` survives in `apps/web/src/features/quotations/types/quotation-api.ts`
  with no form field and no consumer. So the field was removed and the workflow was built elsewhere
  under other names. What is genuinely unresolved is only what the punch-list bullet is asking for,
  and it was written **after** the removal — which is why it cannot be dismissed as stale.
- Blocked: any spec work citing `quotations/quotation.md`; whether the vestigial web type should be
  deleted; the pre-quote package scope.
- Owner: Ryan Adams / Joe Schacatano (sales & quotation).
- Status: open
- **From (frozen original):** [gaps.md#customer-po-on-the-quotation-which-of-three-things-does-it-mean](../gaps.md#customer-po-on-the-quotation-which-of-three-things-does-it-mean)

## Billing-rate effective dating for pricing sheets — raised by the client, no design yet

- **Status:** open
- **Asked:** 2026-08-24 — client-message batch (Brian Petros, rate-rollover message; payroll-side counterpart on `payroll/rules/PAY-008`)
- **Question:** union *wage* rates change every fiscal year and the ERP will effective-date them
  (PAY-008). The client is "not sure yet about the FCC billing rates for invoicing (pricing
  sheets)" and expects the ERP to do better. Where do billing rates live in the ERP
  (price-listings / billing codes), and how are they versioned over time so an old job invoices
  at the rate in force on its work date?
- **Sources checked:** FCC `UNION_CRAFT.BillingRate` exists but is **0.000 on every sampled row**
  — a dead path; billing actually comes from pricing sheets. Vault: [billing-code-and-price-list.md](billing-code-and-price-list.md)
  (status draft/in-progress/active discussed 2026-03-12, no effective-dating design anywhere).

## Billing-code create form prefill — six query params, no producer, no source

- **Status:** open
- **Asked:** 2026-08-31 — PR review of branch `fix/auto-select-issue` (PR #432, commit
  `0d000632`). **Not a ticket question:** the branch carries no `SCRUM-###`, no
  `.ai/aidlc/SCRUM-###/` folder and no `processed.log` row, so there is no `spec.md` §12 to
  hold it. The assets-side half of the same review — asset and sub-category create prefill,
  plus the dirty-state and invalid-ID questions that apply to this form too — is at
  [assets/gaps.md](../assets/gaps.md#create-form-prefill-from-url-query-params--the-whole-contract-is-unwritten).
- **Question:** should the billing-code create form read `name`/`defaultName`,
  `subCategoryId`, `categoryId`, `employeeTypeId`, `customTypeId` from the URL and set
  `BillingCodeTypeCategory` from whichever is present — i.e. **is there an intended "create a
  billing code from here" entry point**, and if so which surfaces should produce those links
  (a sub-category page, an employee type, a custom type, or the quotation line with no billing
  code)? As shipped this is a **consumer with no producer**: nothing in `apps/web` builds such
  a URL — `features/billing-codes/view/billing-codes-list.tsx` pushes bare
  `/accounting/billing-codes/create` — so the branch adds 73 lines of unreachable behaviour.
- **Sources checked:** [INDEX.md](INDEX.md); [billing-code-and-price-list.md](billing-code-and-price-list.md)
  (`status: unverified`, punch list) — has *"Add billing code type CRUD"* and *"For custom – we
  should be able to re-use same sub categories multiple times"*, **neither of which is a
  prefilled create form**; this register's other three entries; and the nearest text match in
  the vault, [projects-jobs/job-project-das.md](../projects-jobs/job-project-das.md):23
  *"Pre populated custom billing code in prioce list creation"* — **a different surface**
  (price-list creation, not the billing-code form) and a punch list, which
  [gaps.md](../gaps.md#feedback-punch-lists-are-not-scoped-to-the-module-they-are-filed-under)
  warns is a cross-module bug list rather than a specification. **Jira was not checked: no Jira
  MCP was available in this session.**
- **Note:** there *is* one recorded conversation about an entry point into billing-code
  creation, and it points the other way. In `meetings/transcripts/2026-05-05-tcg-erp-system.md`
  Melissa McNutt asks for a quick-add (:460, *"could it auto-populate as a billing code where
  we don't have to go back and create a billing code?"*), mohsin.ali proposes an inline **add
  new billing code** button (:486), and ehtesham.anwar closes the thread against it (:487) —
  *"the problem with that is we don't know if the person has the right access … let's add this
  to the approval system instead of creating new functionality"*, with ans.nisar (:469)
  preferring to flag the missing code rather than create one inline. That is a **meeting
  record, not a commitment** (agent §6), it concerns the quotation line-item surface rather
  than sub-category or employee-type pages, and it says nothing about URL params. So it is
  adjacent context for whoever answers, not a source — but it means "add a create-from-here
  path" should not be assumed wanted just because the code now supports one.
- **Blocked:** whether the shipped prefill code is kept, reverted as dead code, or completed
  with the producer links it implies.
- **Owner:** needs assignment — Ryan Adams / Joe Schacatano (sales & quotation) for whether the
  entry point is wanted; ehtesham.anwar owns the 2026-05-05 access-control objection above.


## Sub-category association cycles — rejected at self-reference only, not at multi-hop

- **Status:** open
- **Asked:** 2026-08-31 — quotation resource nesting fix (duplicate/wrong-nesting defect on the
  Resources tab)
- **Question:** `SubCategoryAssociatedResource` lets a sub-category associate other sub-categories,
  employee types or custom types, and the quotation Resources tab expands those associations
  recursively into child rows. `sub-categories.service.ts` rejects a sub-category associated to
  **itself**, but nothing rejects a loop through a second one (`A -> B -> A`), and the schema has no
  cycle constraint. Such a catalog recursed to `MAX_QUOTATION_RESOURCE_DEPTH` and materialised five
  levels of alternating, apparently unrelated rows under one line item. Should the API reject
  multi-hop association cycles **at configuration time**, so every consumer is safe, or is guarding
  per consumer the intent? Related: association lookup matches on **item name** against
  sub-category names, so an employee type or custom type sharing a name with a sub-category
  inherits that sub-category's associations — is name matching intended, or should it key on the
  resolved FK id?
- **Sources checked:** `apps/api/prisma/schema.prisma` → `model SubCategoryAssociatedResource`
  (three unique constraints, no cycle constraint);
  `apps/api/src/usecase/asset-management/sub-categories/sub-categories.service.ts` (the
  self-association check, *"A sub-category cannot be associated to itself"*);
  [decisions/2026-08-31-quotation-associated-child-merge-semantics.md](../decisions/2026-08-31-quotation-associated-child-merge-semantics.md)
  (records the client-side cycle guard shipped as the interim fix);
  [billing-code-and-price-list.md](billing-code-and-price-list.md) and this register's other
  entries — none covers association topology. **Jira was not checked: no Jira lookup in this
  session.**
- **Blocked:** nothing is blocked. The Resources tab now guards the ancestor path, so a looping
  catalog no longer produces garbage rows. This asks whether the rule belongs in the API instead.
- **Owner:** needs assignment — whoever owns asset-management catalog rules.


## Quotation duplicate — what a copy carries, and what a fresh copy resets

- **Status:** open
- **Asked:** 2026-08-31 — PR review of branch `fix/quotation-das-resources` (commit `d89acfd8`,
  which changed the resource clone to depth-first). **Not a ticket question:** the branch carries
  no `SCRUM-###`, no `.ai/aidlc/SCRUM-###/` folder and no ticket id on its `processed.log` row, so
  there is no `spec.md` §12 to hold it.
- **Question:** the Duplicate action on a quotation is a **deep copy with no written contract**.
  As implemented (`quotations.service.ts` → `cloneInternal`) it mints a new `QUOT-#####`, resets
  `status` to `DRAFT` and `validUntil` to `null`, carries every other commercial and customer
  scalar including `subtotal`/`tax`/`total`, copies the resource tree and the tool rows — and
  copies **nothing else**. Quotation attachments (stored as `Attachment` records keyed by feature
  `QUOTATION` + quote number, not as a quotation relation) are silently dropped, as is anything
  else held outside the quotation row, its resources and its tools. Is that the intended product
  behaviour? Specifically: (a) should a duplicate carry attachments, lift information and
  pre-quote/customer-package documents, or deliberately start clean; (b) should the copied
  per-line `discountValidUntil` be reset the way the header `validUntil` is, given a duplicate
  restarts its validity window; (c) should the stored `subtotal`/`tax`/`total` be carried or
  recomputed on the copy?
- **Sources checked:** [INDEX.md](INDEX.md); [quotations-INDEX.md](quotations-INDEX.md) and all
  four of its candidates ([quotation.md](quotation.md), [quotations.md](quotations.md),
  [quotation-flow-process.md](quotation-flow-process.md),
  [../assets/user-story-and-tasks.md](../assets/user-story-and-tasks.md)) — **none mentions
  Duplicate at all**; this register's other entries;
  [../decisions/2026-08-31-quotation-qty-not-das-sets.md](../decisions/2026-08-31-quotation-qty-not-das-sets.md)
  (covers convert-to-job, not duplicate). Jira **was** checked: no ticket in `SCRUM` names a
  quotation duplicate/copy/clone — the "duplicate" hits are unrelated defects (`SCRUM-613` toast,
  `SCRUM-678` DocuSign email, `SCRUM-665` rigging summary). The only account of the feature
  existing at all is a meeting record — `meetings/transcripts/2026-06-23-mobile-app-payroll-adp-and-draft-workflows.md`
  (ehtesham.anwar, describing the mobile parity list: *"we can send this quotation to the customer,
  edit, duplicate … just like we're sending from the web portal"*) — which is a **record, not a
  commitment** (agent §6) and says nothing about what a copy contains.
- **Note:** the depth-first change itself needs no product answer. Copying a tree parent-before-child
  is a correctness fix — the previous order-dependent copy orphaned grandchildren, which is data
  loss under any reading. What is unwritten is the **scope** of the copy, above.
- **Blocked:** nothing is blocked. The Duplicate action works and the tree now survives it. This
  asks whether the dropped attachments and the carried-over stored totals are intended.
- **Owner:** needs assignment — Ryan Adams / Joe Schacatano (sales & quotation) for what a re-quote
  should carry.

## Long-boom billing has no model — the pay-side boom table is not it

- **Status:** open
- **Asked:** 2026-09-01 — processing quote OM-35140, supplied by Melissa McNutt 2026-08-31.
- **Question:** the quote's terms promise an hourly uplift for long boom, in **three** brackets with
  a **separate rate per premium tier** — 200′–240′ at $13.00 ST / $19.50 OT / $26.00 DT / $30.00 TT;
  241′–280′ at $15.00 / $21.50 / $29.00 / $38.00; 281′–340′ at $17.00 / $27.00 / $35.00 / $45.00.
  Nothing in the ERP prices this. Is it a billing code, a per-resource modifier, or a rule on the
  quotation line — and where do the four tier rates live, given a billing code carries one rate?
- **Sources checked:**
  [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §4 for the table.
  `packages/shared/src/constants/craft-modifiers.ts` `CRAFT_MODIFIER_BRACKETS` — **17** brackets in
  20-foot steps from `080-100` to `421-440`, one operator rate and one oiler rate each, $0.75–$13.50
  per hour, no OT/DT/TT variants. That is **employee pay** under decision 23099 and is a different
  table in every dimension: bracket count, bracket boundaries, rate axis and magnitude.
  `apps/web/src/features/payroll/components/payroll-employee.helpers.ts` `longBoomHours()` and the
  `Long Boom Pay` premium in `apps/api/src/utility/seed-data.ts` are both payroll-side.
  `grep -riE "long ?boom"` across `apps/`, `packages/` and the vault returns **no billing-side
  implementation or requirement**. [billing-code-and-price-list.md](billing-code-and-price-list.md)
  does not mention boom.
- **Note:** the two tables must not be merged. A quoting change that reuses
  `CRAFT_MODIFIER_BRACKETS` would bill the customer $4.50/h where the contract says $13.00/h, and
  would silently couple a customer price to a union-negotiated pay rate. Also unresolved: the
  billing brackets start at 200′ and stop at 340′, while cranes in the fleet carry boom past 400′
  (the pay table runs to `421-440`) — what is billed above 340′ is unstated.

## The surcharge is blanket in the contract but per-resource in the model, and it has no name

- **Status:** open
- **Asked:** 2026-09-01 — processing quote OM-35140, supplied by Melissa McNutt 2026-08-31.
- **Question:** three sub-questions on the 12% surcharge. (a) The T&C is unconditional — *"ALL
  CHARGES ARE SUBJECT TO A 12% FUEL & INSURANCE SURCHARGE"* — but `Surcharge` is stored per price
  listing and applied per **quotation resource** via `surchargeEnabled` / `surchargePercentage`,
  then summed. Per-resource summing equals a subtotal-wide 12% **only if every resource is enabled
  at the same rate**; should the ERP enforce that, or is per-line opt-out intended? (b) The printed
  quote shows one customer-visible line labelled **"Fuel & Insurance Surcharge"**, and the
  `Surcharge` model has `enabled` and `percentage` but **no label field** — where does the printed
  name come from? (c) The T&C says the surcharge *"WILL BE APPLIED ON FINAL INVOICES"*, so the quote
  figure is an estimate over estimated hours — does invoicing recompute it against actual time, and
  against which subtotal?
- **Sources checked:** [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §1 — the worked
  arithmetic from the real quote: subtotal $4,605.00 (including the $165 travel permit, so permits
  **are** surchargeable) × 12% = $552.60, total $5,157.60.
  `apps/api/prisma/schema.prisma` `model Surcharge` (`enabled`, `percentage`, `priceListingId`,
  unique per price listing). `apps/api/src/service/quotations/quotations.repository.ts:365-367,
  453-455` — the three per-resource fields. `apps/web/src/features/quotations/workspace/detail/
  detail-format.ts:127-139` — `acc.surcharge + surcharge + child.surcharge`, the sum.
  [billing-code-and-price-list.md](billing-code-and-price-list.md):31-32 is the only prior vault
  mention and is UI feedback only — *"Re-design surcharge placement"*, *"Apply surcharge heading
  should be"* (the sentence is truncated in the source).
- **Note:** a fourth item from the same page is unmodelled anywhere and is not part of this
  question, but should not be lost: *"ALL SUBCONTRACTORS WILL BE BILLED AT A MINIMUM OF 10% MARK
  UP."*

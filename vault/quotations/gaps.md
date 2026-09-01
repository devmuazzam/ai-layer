---
title: Quotations — open questions
status: reference
kind: gaps
updated: 2026-09-01
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

## Billable hour minimums and maximums are contractual but have nowhere to live

- **Status:** open
- **Asked:** 2026-09-01 — PR review of branch `fix/quotation-das-resources`, reading the rate
  card added the same day. Registered because the commit that added the rate card (`86a0836`)
  filed the long-boom and surcharge questions from it but not this one.
- **Question:** the customer contract sets a **minimum billable hours** figure per resource
  kind, and in one case a maximum: 22-ton crane 3 h in normal hours and 4 h after hours; any
  work before 06:00, after 17:00, Saturday or Sunday 4 h; 30-ton and above, trucks, support
  equipment, riggers and signalpersons 4 h; **Operator Load 5 h minimum and 8 h maximum**;
  support vehicle and pilot car 4 h; a crane that works under 8 h and stays on site overnight
  bills Crew Time at 8 h. None of it exists in the model. Three sub-questions. (a) Should a
  billing code carry its own min/max hours, or is the minimum a property of the **crane size
  band and the time of day**, which no single code knows? (b) On a quote line, does a figure
  below the minimum get **defaulted up** silently, **warned** about, or **rejected** the way a
  fractional rate now is? (c) Is the minimum a quoting-time rule, an invoicing-time rule, or
  both — the surcharge question above shows the contract already distinguishes the two, and
  several of these minimums (show-up, cancellation) can only be known after the fact.
- **Sources checked:** [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §2, the
  full minimums table, and §3 for the per-charge `4 h min` notes. `apps/api/prisma/
  schema.prisma:1246-1266` — `model BillingCode` carries `unitMeas`, `defaultRate`, `unitCost`,
  `applySurcharge`, `taxable`, `percentApplied` and **no hours field of any kind**. `minHours`,
  `maxHours`, `minimumHours` return zero hits across `apps/api/src` and `apps/web/src`
  (grepped 2026-09-01). The rate-card commit's own two gap entries above do not cover it.
- **Note:** the Operator Load line is the one with a written cross-module consequence — the
  rule is *printed on the quote line itself* (*"5 hour minimum with 8 hour max per day"*), and
  `../dispatch/gaps.md` is separately unsure whether an operator load is an Asset, a crane
  configuration, or a billable line. It is at least a billable line: `OPL` is seeded in
  `apps/api/src/utility/seed-data.ts:86`.

## Is the $50,000 approval threshold inclusive or exclusive?

- **Status:** open
- **Asked:** 2026-09-01 — end-to-end defect audit of the quotation module
  ([`docs/quotation-module-audit-2026-09-01.md`](../../../docs/quotation-module-audit-2026-09-01.md)).
- **Question:** does a quotation totalling **exactly** $50,000.00 require Sales Manager
  escalation, or not? The code uses a strict `>`, so $50,000.00 does **not** count as
  exceeding the limit. This is not a cosmetic boundary: the trigger it produces changes the
  routing chain. At exactly $50,000 the trigger falls through to `MANDATORY`, which plans a
  single `EITHER` stage that a Sales Coordinator can finalise on their own; at $50,000.01 the
  trigger is `TOTAL_EXCEEDS_LIMIT`, which plans `EITHER` followed by a mandatory
  `MANAGER_ONLY` stage. So one cent decides whether a manager ever sees the quote. The same
  question applies to the rate-below-minimum comparison if that is also strict.
- **Sources checked:** `apps/api/src/usecase/quotation-approvals/quotation-approvals.service.ts:231`
  — `const totalExceedsLimit = totalAmount > approvalThreshold;`.
  `apps/api/src/config/quotations.config.ts` — `DEFAULT_APPROVAL_TOTAL_THRESHOLD = 50_000`,
  overridable per deployment via `QUOTATION_APPROVAL_TOTAL_THRESHOLD`; its own doc comment
  reads *"Quotation total **above** this triggers manager approval before sending"*, which is
  consistent with the strict `>` but is a restatement of the code, not a sourced requirement.
  `apps/api/src/usecase/quotation-approvals/approval-routing.ts:89-131` for the routing
  consequence described above. No vault file states the threshold or its inclusivity; the
  web copy at `apps/web/src/features/quotation-approvals/components/approval-request-modal.tsx`
  says only *"Total Exceeds"*, which inherits the same ambiguity.
- **Note:** the threshold is environment-configurable, so whatever is decided should be stated
  as a rule about the comparison ("at or above" vs "above"), not about the number $50,000.

## Does "Valid until <date>" mean end of that day, or the instant of midnight?

- **Status:** open
- **Asked:** 2026-09-01 — end-to-end defect audit of the quotation module.
- **Question:** a salesperson setting *Valid until 15 Sep* presumably expects the quote to be
  live for the whole of 15 September. The expiry sweep treats `validUntil` as an instant and
  expires anything strictly earlier than the moment the job starts, so a quote stored as
  `2026-09-15T00:00:00.000Z` is expired by the 01:00 run **on** 15 September — the customer
  loses the last day. Should validity be inclusive of the named calendar day, and if so, in
  whose timezone is that day defined? The column is `timestamptz`, the cron fires at 01:00
  server time, and the web form parses the picker value at local midnight, so the answer also
  determines whether a quote's lifetime currently varies by the salesperson's timezone.
- **Sources checked:** `apps/api/src/usecase/quotations/quotation-expiry.service.ts:49-81` —
  `@Cron(CronExpression.EVERY_DAY_AT_1AM)`, `validUntil: { not: null, lt: startedAt }` where
  `startedAt = new Date()` at job start. `apps/api/prisma/schema.prisma:1737` — `validUntil
  DateTime? @map("valid_until") @db.Timestamptz()`. `apps/web/src/features/quotations/views/
  create-quotation.helpers.ts` `parseDateInput` for the client-side parse. No vault file
  defines what a validity period means; `quote-terms-and-rate-card.md` covers rates and terms
  but not the expiry boundary.

## Should editing a quotation adopt the customer's current price list?

- **Status:** open
- **Asked:** 2026-09-01 — end-to-end defect audit of the quotation module.
- **Question:** when a saved quotation is reopened for editing, the form overwrites the
  quotation's stored `priceList` with whatever price list the customer record currently
  carries, and forces `priceListSource` to `master` when the customer has none. The behaviour
  is deliberate — the code says so in a comment — but no product source establishes it. If a
  customer's price list has changed since the quote was written, reopening and saving the
  quote silently re-prices it against the new list, and the person editing an unrelated field
  gets no warning. Which is intended: does an edit re-price to today's list, or does a saved
  quotation keep the list it was written against until someone changes it deliberately?
- **Sources checked:** `apps/web/src/features/quotations/views/use-quotation-customer-data.ts:26-51`
  — the customer query runs with `staleTime: 0` and `refetchOnMount: 'always'`, and the effect
  is commented *"Apply the customer's current price list whenever fresh data arrives — in both
  create and edit mode."* `apps/web/src/features/quotations/views/create-quotation-form-model.ts`
  for `onPriceListUpdate`, and `edit-quotation.mapper.ts:161` for the initial seed from
  `quotation.priceList` that this then replaces.
  [billing-code-and-price-list.md](billing-code-and-price-list.md) describes how price lists
  resolve a rate but says nothing about re-pricing an existing quotation on edit.

## Should a quotation with a past job date or valid-until still be editable?

- **Status:** open
- **Asked:** 2026-09-01 — end-to-end defect audit of the quotation module (finding Q-12).
- **Question:** today it is not, on either surface, and the effect is that a quotation becomes
  permanently uneditable once any of its three dates passes. That includes **every** expired
  quotation, since `validUntil` being in the past is what made it expire. The `not before
  today` rule is sound on create — nobody should book a job in the past — but it is inherited
  by the update path unchanged, so re-saving an old quote fails on a date the user never
  touched. Should the rule apply only to create, only to a date the user actually changed, or
  should past dates be editable but flagged? This blocks the reactivate-to-draft flow too: a
  reopened lost quote with a past job date cannot then be edited.
- **Sources checked:** `apps/api/src/presentation/quotations/dto/create-quotation.dto.ts:283,
  289, 461` — `@IsNotBeforeToday()` on `jobDate`, `jobEndDate`, `validUntil`.
  `apps/api/src/presentation/quotations/dto/update-quotation.dto.ts:10-12` — `PartialType(
  OmitType(CreateQuotationDto, ['quoteNo']))` inherits all three validators.
  `apps/web/src/features/quotations/views/create-quotation.helpers.ts:182-203` — the client
  applies the same rule with no edit-mode exemption, so Save is blocked before any request.
  `apps/api/src/usecase/quotations/quotations.service.ts:338-346` — the service's own contract
  comment lists expired among the statuses that *"remain editable"*, which the DTO
  contradicts. Nothing in the vault states whether past-dated quotations are editable.

## Does uploading a plan or document notify the customer, and do those files ride the DocuSign envelope?

- **Status:** open
- **Asked:** 2026-09-01 — PR review of branch `fix/quotation-das-resources` (no ticket;
  `processed.log` Path C row covers qty/DAS only); tcg-scrum escalation
- **Question:** two parts, each answerable in a line. (a) When a user uploads a plan or drawing
  to a quotation, should the customer be emailed it **on upload** (previous behaviour — the route
  was `attachments/upload-and-email`, with a `quotation.attachments_emailed` notification), or
  should upload **only store**, with the files reaching the customer when the quote is sent
  (the branch's new behaviour)? (b) Should `PLAN_OR_DOC` attachments be included in the **DocuSign
  envelope** at send time? The branch relies on them doing so via `buildAdditionalDocuments`, but
  the Mohsin punch list says the opposite — see the conflict below. If (b) is "no", (a)'s answer
  leaves the DocuSign path with no delivery route for uploaded documents at all.
- **Conflict, unresolved:** [quotations.md](quotations.md) — *"Quote attachment should not be sent
  to docusign"*. `status: unverified`, punch list, 2026-07-14. The branch's premise is that both
  send paths already carry uploaded documents, which is what that line appears to prohibit. The
  line is one clause with no elaboration and may mean the quote's own PDF rather than user
  uploads; it cannot be read either way with confidence.
- **Sources checked:** [quotation-flow-process.md](quotation-flow-process.md) Step 11 (*"Upload
  Attachments"*) and Step 21 (*"Send quotations to the customer via Email or DocuSign"*) — the
  flow separates the two steps but states no rule about notification on upload;
  [quotations.md](quotations.md) (the conflicting line above, plus *"Docusign email - duplicate"*
  / *"Remove second email"*, which show the client objecting to redundant customer mail but say
  nothing about upload); [../assets/user-story-and-tasks.md](../assets/user-story-and-tasks.md)
  §Quotation management US1 — *"User can select recipient from customer record or manually enter
  email"* on the **send** flow, which is the closest written support for not mailing silently on
  upload, but is personal-space provenance and is about sending, not uploading;
  [quotations-INDEX.md](quotations-INDEX.md); `decisions/` (21 notes, none on attachments or
  delivery); `.ai/aidlc/` (no ticket covers this).
- **Blocked:** whether branch `fix/quotation-das-resources` commit `00d8e83a` ships as-is. Nothing
  else is blocked — both behaviours are complete and self-consistent.
- **Owner:** product team

## After embedded signing returns, should the app pull DocuSign status immediately or wait for the webhook?

- **Status:** open
- **Asked:** 2026-09-01 — PR review of branch `fix/quotation-das-resources` (no ticket);
  tcg-scrum escalation
- **Question:** when the customer finishes embedded signing and the browser returns,
  `syncFromSigningReturn` now pulls envelope status from DocuSign so the quotation shows **WON**
  without waiting for the webhook or a page reload. Is a proactive pull on return the intended
  behaviour, or should the webhook remain the single writer of signature state with the UI
  showing "pending" until it arrives? The trade-off is stated, not decided: the pull removes a
  visible lag the client has complained about in the adjacent case, and it adds a second writer
  to a status field that [#q-13](#q-13--syncfromsigningreturn-can-resurrect-a-locally-voided-envelope)
  and [#q-14](#q-14--webhook-and-sync-can-downgrade-a-completed-signature) already show is not
  guarded against out-of-order or regressive transitions.
- **Sources checked:** [../projects-jobs/project-module/06-client-reviews-and-signs-quotation.md](../projects-jobs/project-module/06-client-reviews-and-signs-quotation.md)
  — *"Quotation status updates to **Signed**"*, and *"All actions are recorded with timestamp"*,
  but no statement about when the app learns of it;
  [../assets/user-story-and-tasks.md](../assets/user-story-and-tasks.md) US2 — *"Quote status
  changes to **Approved**"*, same silence on timing (and both name a status the code calls `WON`);
  [quotations.md](quotations.md) — *"When mark as lost - it didnt refreshed without refresh"*, the
  nearest written expectation, showing the client treats a status that needs a manual refresh as a
  defect, but for the **lost** path, not signing. Q-13 and Q-14 in this file question the same
  method for different reasons and neither settles this. `decisions/` — nothing on signature
  timing.
- **Owner:** product team

## Is a salesperson required on quotation create?

- **Status:** open
- **Asked:** 2026-09-01 — PR review of branch `fix/quotation-das-resources` (no ticket);
  tcg-scrum escalation
- **Question:** the branch makes **Salesperson** a required field on the quotation create form.
  Is that the intended rule, and if so does it match the customer-record rule (see below) — is the
  quotation's salesperson defaulted from the logged-in user when they hold a sales role, and what
  happens when a non-sales user (dispatch, admin) creates a quotation and has nobody to default to?
- **Sources checked:** **Nothing states this for quotations.** The nearest is
  [../customers/customer.md](../customers/customer.md):68-72 — *"Sales person should be pre
  populated in case when sales dept person is logged in"*, *"Sales – all roles"*, *"Sales person
  should be required"* — but that is the **customer** punch list and those three lines sit inside
  a run of customer-record items (Pipeline value, Revenue column, Top accounts), so on its face it
  is about the customer record, not the quotation. It cannot simply be transferred: the punch
  lists are known to wander across modules
  ([../gaps.md#feedback-punch-lists-are-not-scoped-to-the-module-they-are-filed-under](../gaps.md#feedback-punch-lists-are-not-scoped-to-the-module-they-are-filed-under)),
  which makes the scope of these lines genuinely uncertain rather than clearly one or the other.
  Also checked: [quotation-flow-process.md](quotation-flow-process.md) Step 7 (*"Enter general
  quotation details (description, tentative schedule, customer contact, notes, etc.)"* — the
  "etc." is the whole answer it gives on required fields); [quotations.md](quotations.md);
  [quotation.md](quotation.md); [../assets/user-story-and-tasks.md](../assets/user-story-and-tasks.md);
  `decisions/`; `.ai/aidlc/`.
- **Owner:** product team

## Can a Report To contact be created inline from the quotation form?

- **Status:** open
- **Asked:** 2026-09-01 — PR review of branch `fix/quotation-das-resources` (no ticket);
  tcg-scrum escalation
- **Question:** the branch adds a modal that creates a new customer contact ("Report To") without
  leaving the quotation create form. Is creating a customer-owned record from inside the quotation
  form intended, and if so what does it write — a full contact on the customer, or something
  quotation-local? Related and unanswered: does the new contact need the same required fields and
  validation as the customer module's own contact create, and should the quotation form be able to
  create the **Quote To** contact the same way, since the punch list names both fields together?
- **Sources checked:** [quotations.md](quotations.md) — *"Show all contacts in reported to and
  quote to fields"*, which is about **listing existing** contacts in those two fields and says
  nothing about creating one; [quotation-flow-process.md](quotation-flow-process.md) Step 6
  (*"Select or create the Customer and Job Site"* — establishes that inline create is acceptable
  for **customer and job site**, and conspicuously does not name contacts) and Step 7 (*"customer
  contact"* listed as a detail to enter); [../customers/customer.md](../customers/customer.md);
  [../customers/customers-INDEX.md](../customers/customers-INDEX.md);
  [../assets/user-story-and-tasks.md](../assets/user-story-and-tasks.md); `decisions/`; `.ai/aidlc/`.
- **Owner:** product team

## Should a per-resource surcharge column be shown on quotation resource rows?

- **Status:** open
- **Asked:** 2026-09-01 — PR review of branch `fix/quotation-das-resources` (no ticket);
  tcg-scrum escalation
- **Question:** the branch adds a **Surcharge** column before **Amount** on every quotation
  resource row. Should surcharge be visible and attributable per resource at all, and if so is
  before-Amount the intended position? This is not only a layout question: the surcharge is
  contractually blanket (*"ALL CHARGES ARE SUBJECT TO A 12% FUEL & INSURANCE SURCHARGE"*) and only
  per-resource in the model, and whether that per-line modelling is intended is itself open — see
  [The surcharge is blanket in the contract but per-resource in the model](#the-surcharge-is-blanket-in-the-contract-but-per-resource-in-the-model-and-it-has-no-name).
  Surfacing a per-row surcharge in the UI makes the contested model the one users work in and
  reason about, so answering the layout question in isolation would prejudge the modelling one.
- **Sources checked:** [billing-code-and-price-list.md](billing-code-and-price-list.md):31-32 —
  *"Re-design surcharge placement"* and *"Apply surcharge heading should be"* (the second sentence
  is truncated in the source). This is the only vault statement about surcharge placement anywhere,
  it is UI feedback with no target layout, and it sits under a **Price list** heading, so it is
  most likely about the price-list screen rather than quotation resource rows.
  [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §1 gives the customer-facing
  arithmetic and shows **one** surcharge line on the printed quote, not per-resource — which is
  evidence about the printed document, not the editing UI. Also checked: [quotations.md](quotations.md);
  [quotation.md](quotation.md); `decisions/`; `.ai/aidlc/` (the nearest is `processed.log`
  `SCRUM-873`, *"resources surcharge chip from billing codes"*, a Path C fix with no spec folder
  and no acceptance criteria).
- **Owner:** product team
- **Update 2026-09-01** — a second branch, `fix/subcategory-asset-dropdown-surcharge` (no ticket),
  now **removes** the Surcharge column from the create/edit Resources tab while leaving it on the
  read-only detail tab. The stated reason is that the column was read-only inside a form — the
  percentage resolves from the billing code or price-list item and could never be typed into. The
  underlying values (`surchargeEnabled`, `surchargePercentage`, `surchargeAmount`) stay in form
  state, the payload, the Amount tooltip and the footer totals, and the sidebar surcharge section,
  the pricing chips and the print path are untouched. **The question above is still open**, and the
  removal answers half of it (not on create/edit, yes on detail) without a decision — so it is
  recorded here rather than closed.
  **Jira was checked this time**, and two issues bear on it, neither settling it:
  `SCRUM-873` (QA, updated 2026-09-01) Create Flow item 4 — *"In the Resources tab, the surcharge
  is displayed as Inactive even though the surcharge is active. Please fix the status display"* —
  is a client ask to **fix**, not remove, a surcharge indicator on the create-flow Resources tab.
  It most likely names the chip rather than the column (the branch leaves the chips alone), but the
  two cannot be told apart from the ticket text, and it establishes that surcharge visibility on
  the create flow is something the client tracks. `SCRUM-567` (Done) — *"Unit, Rate, and Amount
  should remain synchronized based on Billing Code. Unit should be displayed as a disabled field.
  Surcharge must automatically recalculate when quantity, rate, or amount changes"* — a shipped
  requirement describing live surcharge recalculation while a line is being edited, alongside a
  field that is **displayed but disabled**; whether "recalculate" implies "visible while editing"
  is exactly what is unstated. `SCRUM-401` (Done) — *"system-generated and not manually entered by
  the salesperson so nobody ever forgets it"* — supports the read-only premise but says nothing
  about per-row display. Whoever answers the heading question should answer these together.
- **Update 2026-09-01 (PR review, branch `fix/subcategory-asset-dropdown-surcharge`)** —
  **Merge blocker (product):** comprehensive PR review recommends **do not ship** until product
  explicitly confirms removing the Surcharge column from create/edit. Primary tension: `SCRUM-873`
  Create Flow item 4 asks to **fix** surcharge status display on the create-flow Resources tab,
  not remove a surcharge indicator; the ticket text cannot distinguish the pricing chip from the
  dedicated column (the branch leaves chips and sidebar surcharge sections untouched). A client QA
  ticket and an unsourced UI removal on the same tab is a high-risk combination without sign-off.
  **Split UX now shipped without a decision:** create/edit users see surcharge only inside the
  Amount cell tooltip and footer totals; the read-only detail tab still shows a dedicated Surcharge
  column (`detail-resources-tab.tsx`). Whether that asymmetry is intended is unstated.
  **Engineering gaps:** no `qa-automation/e2e/` spec references the column or grid layout;
  `packages/shared` unchanged (web-only). Branch has no `.ai/aidlc/` folder and no ticket on the
  branch itself — ad-hoc work routed here per [STRUCTURE.md](../STRUCTURE.md).
- **Update 2026-09-01 (post-merge, PR #451 → main)** — merged to `main` without closing this
  question. Create/edit no longer show a dedicated Surcharge column; detail tab still does.
  Product must still confirm whether that split and the removal itself match client intent
  (see `SCRUM-873` tension above). Reverting the column is a one-file web change if product
  decides against the removal.

## May the send-signature modal close before the quotation data has refetched?

- **Status:** open
- **Asked:** 2026-09-01 — PR review of branch `fix/quotation-das-resources` (no ticket);
  tcg-scrum escalation
- **Question:** the branch closes the send-signature modal immediately on success rather than
  holding it open until the refetch settles. The user therefore returns to the quotation a moment
  before it shows the new signature state. Is closing immediately acceptable, or must the user
  never see a stale state after a successful action? Judgement note: this is close to the
  product/implementation line and may not need a product answer at all — it is filed because the
  one written expectation nearby is a client complaint about exactly this failure mode, so
  "acceptable" needs to be someone's decision rather than an assumption.
- **Sources checked:** [quotations.md](quotations.md) — *"When mark as lost - it didnt refreshed
  without refresh"*, the only written expectation in this area and a complaint about a **manual
  page refresh** being needed, which is a stronger failure than a brief refetch lag; it does not
  say whether a short stale window is acceptable. [#q-22](#q-22--inbox-approval-resolve-leaves-quotation-detail-caches-stale)
  in this file is the same class of defect (stale quotation caches after an action) and is open.
  Also checked: [../assets/user-story-and-tasks.md](../assets/user-story-and-tasks.md) US1 —
  *"User receives confirmation after successful send"*, which requires confirmation but not that
  the underlying data has refreshed first. `decisions/`; `.ai/aidlc/`.
- **Owner:** product team

## Company identity on customer-facing email — see admin

- **Status:** open
- **Asked:** 2026-09-01 — PR review of branch `fix/quotation-das-resources`; tcg-scrum escalation
- **Question:** cross-module pointer. The branch defaults TCG's postal address, billing email and
  phone in `apps/api` config so quotation delivery emails never render a blank footer. Whether a
  tenant's own identity may be a code default is an **admin/tenancy** question and is recorded
  there: [../admin/gaps.md#whose-company-identity-do-customer-facing-emails-carry-when-a-deployment-sets-no-env](../admin/gaps.md#whose-company-identity-do-customer-facing-emails-carry-when-a-deployment-sets-no-env).
  It surfaces on quotation delivery mail because that is the only customer-facing email path today.
- **Owner:** product team


## Quotation module defect audit (2026-09-01)

Defect findings from the end-to-end quotation audit. Full narrative, evidence
tags, dismissed claims and gate results live in
[`docs/quotation-module-audit-2026-09-01.md`](../../../docs/quotation-module-audit-2026-09-01.md).
Product-judgement items from the same audit are the four entries above this
heading ($50k threshold, valid-until boundary, price-list-on-edit, past-date
editability). Each entry below is a concrete code defect still open until fixed.

### Critical

## Q-01 — Public PDF endpoint has no authentication

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** critical
- **Evidence:** confirmed (code read this session)
- **Question:** `GET /quotations/:quoteNo/pdf` is `@Public()`, takes only a sequential
  `QUOT-*` number, and renders the full quotation PDF with no token, no status
  check and no ownership check. Its own summary string still says "local testing".
  Anyone who can reach the API can enumerate quote numbers and download pricing,
  customer identity, job site and resource breakdown for every quotation on the
  platform, including drafts. Should this route require auth, a signing token, or
  both — and should the "local testing" controller be removed from production?
- **Sources checked:** `apps/api/src/presentation/quotations/quotation-pdf.controller.ts:17-29`;
  quote minting at `apps/api/src/usecase/quotations/quotations.service.ts:749-754`.
  Audit: [`docs/quotation-module-audit-2026-09-01.md`](../../../docs/quotation-module-audit-2026-09-01.md)#q-01.

## Q-02 — Public signed-document endpoint has no authentication

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** critical
- **Evidence:** confirmed
- **Question:** `GET …/signature/signed-document` is `@Public()` and keyed on
  `quoteNo` alone — no signing token. It streams the signed PDF for a completed
  signature, and falls back to the standard quotation PDF when no signed artefact
  exists. The docstring says the link must be openable from a browser tab, but
  the link carries no secret. How should a customer download a signed PDF without
  granting the same URL to the whole internet?
- **Sources checked:** `apps/api/src/presentation/quotation-signatures/quotation-signatures.controller.ts:251-273`.
  Audit: #q-02.

## Q-03 — Public routes resolve quoteNo across tenants

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** critical
- **Evidence:** confirmed
- **Question:** on `@Public()` routes there is no tenant context, so the Prisma
  extension returns the query unscoped. `findByCodeWithRelations` is
  `findFirst({ where: { quoteNo } })` and `quoteNo` is unique only per tenant.
  Two tenants can both own `QUOT-00001`; a public request returns whichever row
  Postgres reaches first — wrong tenant's PDF/signed doc, or a broken signing
  link when the envelope belongs to the other tenant. Public quotation lookups
  need an explicit tenant key (or a globally unique, unguessable token). How
  should public document and signing URLs be scoped?
- **Sources checked:** `apps/api/src/service/quotations/quotations.repository.ts:160-165`;
  `apps/api/src/orm/prisma.service.ts:224-228`;
  `apps/api/prisma/schema.prisma` `@@unique([tenantCompanyId, quoteNo])`.
  Audit: #q-03.

## Q-04 — DocuSign webhook HMAC verification is optional

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** critical
- **Evidence:** confirmed
- **Question:** `verifySignature` returns immediately when
  `DOCUSIGN_WEBHOOK_HMAC_KEY` is unset. The public webhook can then apply a
  forged `completed` event and mark a quotation `WON`. The comparison itself is
  sound when a key is present. Should the key be mandatory in every environment
  that accepts DocuSign webhooks, and should the handler refuse unsigned events
  when it is missing?
- **Sources checked:** `apps/api/src/presentation/docusign/docusign-webhook.controller.ts:93-95`.
  Audit: #q-04.

## Q-05 — Client-supplied resource ids re-parent rows across quotations and tenants

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** critical
- **Evidence:** confirmed
- **Question:** `quotationResource.upsert({ where: { id: resource.id } })` trusts a
  client-generated UUID. `QuotationResource` has no `tenant_company_id` and is
  not in the tenant allowlist. Nothing checks that an incoming id belongs to the
  quotation being saved. Saving quotation B with a row id from quotation A
  re-points that row at B; A silently loses a line item and its derived total
  changes with no activity log. Same works across tenants. Should sync reject ids
  that do not already belong to this quotation (or that belong to another
  tenant), and should resource rows carry tenant scope?
- **Sources checked:** `apps/api/src/service/quotations/quotations.repository.ts:474-478`;
  `apps/api/src/presentation/quotations/dto/create-quotation.dto.ts:43-45`;
  `apps/api/src/orm/prisma.service.ts` tenant allowlist;
  `apps/api/prisma/schema.prisma` `QuotationResource` (no tenant column).
  Audit: #q-05.

## Q-06 — Content editable while approval pending without a revision bump

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** critical
- **Evidence:** confirmed
- **Question:** only `WON`/`LOST` lock content. `PENDING_INTERNAL_APPROVAL` is not
  a revision trigger, and `editWarrantsRevision` only matches *resolved*
  approvals. Editing rates/totals while a manager's request is open does not
  increment `revisionNumber`. `assertSendable` gates on
  `findApprovedByRevision(id, revisionNumber)`, so the old approval still
  validates and the customer can receive numbers nobody approved. Should an edit
  during pending approval bump the revision (and void the pending request), or
  should content be locked until the request is resolved?
- **Sources checked:** `apps/api/src/usecase/quotations/quotations.service.ts:347-350,
  413-418, 463-488`; `apps/api/src/usecase/quotation-approvals/quotation-approvals.service.ts:1044-1064`;
  `apps/api/src/service/quotation-approvals/quotation-approvals.repository.ts:63-76`.
  Audit: #q-06.

## Q-07 — requestApproval ignores current quotation status

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** critical
- **Evidence:** confirmed
- **Question:** `requestApproval` always writes `PENDING_INTERNAL_APPROVAL` without
  reading `quotation.status`. A quote already `INTERNAL_APPROVED`,
  `SENT_TO_CUSTOMER`, `WON`, `LOST` or `EXPIRED` can be pulled back into the
  approval queue via the API. Which statuses may start a new approval request?
- **Sources checked:** `apps/api/src/usecase/quotation-approvals/quotation-approvals.service.ts:439-496`.
  Audit: #q-07.

## Q-08 — resolveApproval is a check-then-act race

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** critical
- **Evidence:** confirmed
- **Question:** the guard reads `status === PENDING`, then `updateStatus` writes
  with `where: { id }` only — no `status: PENDING` in the write, no transaction
  spanning read and write. Two concurrent approvers can both succeed, finalise
  twice, or spawn two pending `MANAGER_ONLY` children. Should the update be
  conditional on still being `PENDING`, and should stage advance / finalise be
  atomic with the quotation status write?
- **Sources checked:** `apps/api/src/usecase/quotation-approvals/quotation-approvals.service.ts:592-599`;
  `apps/api/src/service/quotation-approvals/quotation-approvals.repository.ts:82-99`.
  Audit: #q-08.

## Q-09 — Signing-link tokens never expire and are not single-use

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** critical
- **Evidence:** confirmed
- **Question:** tokens HMAC `quoteNo|envelopeId|signerEmail` with no timestamp or
  nonce. `parseSigningLinkToken` verifies the HMAC only. The user-facing message
  says "Invalid or expired signing link" but no expiry check exists. Void/resend
  (new envelope id) does invalidate old links; time-based expiry and single-use
  do not. What TTL and single-use policy should branded signing links have?
- **Sources checked:** `apps/api/src/usecase/quotation-signatures/quotation-signatures.service.ts:504-537`.
  Audit: #q-09.

### Major

## Q-10 — status is writable on create and update

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** major
- **Evidence:** confirmed
- **Question:** `CreateQuotationDto` / `UpdateQuotationDto` accept `status` as a
  plain enum. The service only blocks create-as-`LOST` and update-to-`LOST` /
  back-to-`DRAFT`. `PATCH … {"status":"WON"}` skips `markWon`'s sales-role check,
  eligibility gate, `awardDate` and notification; `INTERNAL_APPROVED` skips the
  approval chain. Web edit omits status; mobile and direct API callers do not.
  Should status transitions be restricted to dedicated action endpoints only?
- **Sources checked:** `apps/api/src/presentation/quotations/dto/create-quotation.dto.ts:245-248`;
  `update-quotation.dto.ts:10-12`; `quotations.service.ts:743-747, 1280-1295`;
  `create-quotation-save.ts:250-256`. Audit: #q-10.

## Q-11 — Archive, unarchive, upload and signature routes lack permission checks

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** major
- **Evidence:** confirmed
- **Question:** `PermissionsGuard` returns `true` when no `@RequirePermission` is
  declared. Create/update require `quotations:edit`; duplicate/mark-won/lost/
  reactivate call `assertSalesOrAdmin`. Archive, unarchive,
  `POST :quoteNo/attachments/upload`, and every authenticated signature route
  (send, void, resend, mark-signed, decline, request-changes) have neither.
  Any authenticated tenant user can archive quotes, attach files that ride the
  next send, or send/void envelopes. Which roles may perform each action?
- **Sources checked:** `quotations.controller.ts:300-346, 461-474`;
  `quotation-signatures.controller.ts` (whole file); `permissions.guard.ts:25-29`.
  Audit: #q-11.

## Q-13 — syncFromSigningReturn can resurrect a locally voided envelope

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** major
- **Evidence:** confirmed
- **Question:** after embedded signing, `syncFromSigningReturn` early-returns only
  for `COMPLETED`, not `VOIDED`/`DECLINED`, then pulls DocuSign status onto the
  local row. A customer hitting sign-complete after a local void can overwrite
  `VOIDED` back to `SENT`/`DELIVERED`. The webhook path ignores events on locally
  voided envelopes; this path does not. Should sync refuse to move a voided or
  declined signature, and should local void always void the remote envelope too?
- **Sources checked:** `quotation-signatures.service.ts:1779-1809` (and parallel audit
  notes on `voidEnvelope` / webhook void guard). Audit: #q-13.

## Q-14 — Webhook and sync can downgrade a COMPLETED signature

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** major
- **Evidence:** reported (parallel signatures audit; not independently re-read)
- **Question:** `applyWebhookEvent` ignores only local `VOIDED`, not `COMPLETED`.
  Sync maps remote status onto the local row without a monotonicity rule. A late
  `sent`/`delivered` event can move `COMPLETED → SENT` and take the quotation off
  `WON`. Should signature status transitions be one-way for terminal states?
- **Sources checked:** audit #q-14 cites `quotation-signatures.service.ts:2809-2870,
  816-892`.

## Q-15 — resendEnvelope has no terminal-state guard

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** major
- **Evidence:** reported
- **Question:** resend proceeds without checking `COMPLETED`/`VOIDED`/`DECLINED`,
  creating a second envelope and resetting the signature to `SENT`. Void guards
  those states; resend does not. May a won, voided or declined quote be resent?
- **Sources checked:** audit #q-15 cites `quotation-signatures.service.ts:2414-2590`.

## Q-16 — markAsSigned accepts DECLINED and CHANGES_REQUESTED

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** major
- **Evidence:** reported
- **Question:** manual mark-as-signed no-ops on `COMPLETED` and rejects `VOIDED`,
  but allows other statuses. An internal user can mark a declined /
  changes-requested email quote `COMPLETED` and promote it to `WON` without
  customer acceptance. Which signature statuses may be manually completed?
- **Sources checked:** audit #q-16 cites `quotation-signatures.service.ts:2592-2644`.

## Q-17 — Customer email is sent before signature state is persisted

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** major
- **Evidence:** reported
- **Question:** `sendViaEmail` calls `notify` before creating/updating the
  signature row, activity and quotation status, with no `$transaction`. A DB
  failure after SES succeeds leaves the customer with the email and the app with
  no delivery record; retry may hit the "active envelope" guard. Should persist
  happen before send, or should send be deferred until after a successful write?
- **Sources checked:** audit #q-17 cites `quotation-signatures.service.ts:2003-2122`.

## Q-18 — DocuSign send reports success when branded email fails

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** major
- **Evidence:** reported
- **Question:** after the envelope is persisted as `SENT`, branded delivery
  failures are only logged. Embedded flow suppresses DocuSign's own invite, so
  SES is the only delivery path — API returns 201 and UI shows "sent" when the
  customer never received the link. Should a failed branded email fail the send,
  or surface a recoverable "sent but email failed" state?
- **Sources checked:** audit #q-18 cites `quotation-signatures.service.ts:1367-1512,
  1704-1709`.

## Q-19 — Approval stage advance and finalise are non-atomic

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** major
- **Evidence:** reported
- **Question:** `advanceToManagerStage` marks stage 1 approved then creates stage 2
  separately. If create fails, no pending row exists but the quotation stays
  `PENDING_INTERNAL_APPROVAL` — stuck with an empty inbox. Finalise paths split
  approval-row and quotation-row updates the same way. Should both steps run in
  one transaction?
- **Sources checked:** audit #q-19 cites `quotation-approvals.service.ts:674-710,
  632-649`.

## Q-20 — Approver pool includes inactive / invite-only users

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** major
- **Evidence:** reported
- **Question:** `findApproverPoolByRoles` does not filter `user.status === ACTIVE`.
  A `PENDING_INVITE` user (cannot log in) can be the only entry in `approverIds`,
  so the request is created and nobody can resolve it. Should the pool require
  active users only, and fail closed when the filtered pool is empty?
- **Sources checked:** audit #q-20 cites `apps/api/src/service/users/users.repository.ts:153-168`;
  `access-token.strategy.ts:33-35`.

## Q-21 — Web rate resolution has no latest-wins guard

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** major
- **Evidence:** reported
- **Question:** `resolveAndApplyRate` applies whichever `fetchQuery` settles last
  for a row, with no sequencing or cancel. Fast item changes can leave another
  item's rate/discount/surcharge on the row until re-select. Should in-flight
  resolves be cancelled or ignored when a newer request for the same row starts?
- **Sources checked:** audit #q-21 cites
  `apps/web/src/features/quotations/hooks/use-resource-pricing.ts:107-184`.

## Q-22 — Inbox approval resolve leaves quotation detail caches stale

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** major
- **Evidence:** reported
- **Question:** `useResolveApprovalFromInbox` invalidates inbox and activity logs
  but not approval status/check or quotation detail keys — unlike
  `useResolveApproval(quoteNo)`. After approving from the inbox the quote page
  still shows "Approval Pending" until cache expiry. Should inbox resolve
  invalidate the same keys as the detail-page resolve?
- **Sources checked:** audit #q-22 cites
  `apps/web/src/features/quotation-approvals/hooks/use-quotation-approval.ts:99-115`
  (contrast `:77-84`).

## Q-23 — Mobile quotation approval and edit-mode tests failing

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** major
- **Evidence:** confirmed (suite run + isolated reproduction)
- **Question:** nine mobile quotation tests fail. Four in
  `quotes/[id].test.tsx` never find `approve-approval` (reproduces in isolation:
  `jest -t 'shows Approve/Request Changes/Reject…'` → 1 failed, 39 skipped). Five
  more fail in `quotes/create.test.tsx` edit-mode. Branch diff to `[id].tsx` is
  only import/label/comment changes, so failures likely predate this branch.
  Root cause not found; `departmentRole` schema and API→client mapping were
  checked and are sound. Needs a focused debug of identity stub vs
  `getStatus`/`approverIds`/`canResolve`.
- **Sources checked:** `pnpm nx run-many -t test`; isolated jest on
  `apps/mobile/app/(sales)/quotes/[id].test.tsx`;
  `identity.contract.ts:18`; `identity.http.ts:22`;
  `git diff origin/main...HEAD` on the two mobile files. Audit: #q-23.

### Minor

## Q-24 — List and summary disagree on resource-less quotation totals

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** minor
- **Evidence:** confirmed
- **Question:** `getSummary` falls back to the stored `total` when there are no
  resource rows; `findAll` overwrites with computed `0`. A resource-less quote
  shows `$0` in the list while the KPI strip still counts the stored value.
  Should both paths use the same fallback?
- **Sources checked:** `quotations.service.ts:1000-1006` vs `:1200-1208`. Audit: #q-24.

## Q-25 — Archived rows inflate status tab counts under includeArchived

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** minor
- **Evidence:** confirmed
- **Question:** under `includeArchived`, an archived row increments
  `buckets[bucket]` but increments `buckets.all` only when `onlyArchived` is set,
  so status tabs can sum to more than All. Should archive membership and All
  membership stay aligned for every archive flag combination?
- **Sources checked:** `quotations.service.ts:1008-1022`. Audit: #q-25.

## Q-26 — Web types expose poNumber and crane/lift fields the API never returns

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** minor
- **Evidence:** reported
- **Question:** web `Quotation` types declare `poNumber` and crane/lift columns
  that are not on the Prisma quotation model (PO lives on Project/Job). Screens
  reading `quotation.poNumber` always show `—`. Payload types also declare DTO-
  forbidden fields; `forbidNonWhitelisted: true` would 400 any future spread of
  those into update. Remove the phantom fields, or add real wire support?
- **Sources checked:** audit #q-26 cites `quotation-api.ts:164, 195-208`,
  `quotation-payloads.ts:81-94`, `schema.prisma` Quotation model, `main.ts`
  ValidationPipe.

## Q-27 — certifiedPayroll nullable on API, required in web types

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** minor
- **Evidence:** reported
- **Question:** Prisma `certifiedPayroll Boolean?`; web types it as required
  `boolean` and the edit mapper maps `null` → `'no'`, so "never set" and
  "explicitly No" are indistinguishable. Should the web type and form treat
  unset as a third state?
- **Sources checked:** audit #q-27 cites `schema.prisma:1718`,
  `quotation-api.ts:187`, `edit-quotation.mapper.ts:236`.

## Q-28 — DocuSign resend drops CC recipients

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** minor
- **Evidence:** reported
- **Question:** initial send forwards `ccEmails`; resend hard-codes `ccEmails: []`.
  Coordinators copied on the original send are omitted on resend. Should resend
  reuse the original CC list (or accept a new one)?
- **Sources checked:** audit #q-28 cites `quotation-signatures.service.ts:2580-2588`.

## Q-29 — QuotationStatus duplicated outside @tcg/shared

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** minor
- **Evidence:** reported
- **Question:** Prisma, web and mobile each maintain their own `QuotationStatus`
  (and related approval/signature) unions. They agree today; a new Prisma member
  will silently blank badges until every copy is updated. Should status enums
  live in `@tcg/shared`?
- **Sources checked:** audit #q-29 cites `schema.prisma:1667-1677`,
  `quotation-api.ts:3-25`, `quotation.contract.ts:9-19`; no export under
  `packages/shared/src/`.

## Q-30 — Stale comments misdescribe tenant scoping on groupBy and expiry

- **Status:** open
- **Asked:** 2026-09-01 — quotation module E2E audit
- **Severity:** minor
- **Evidence:** confirmed
- **Question:** `getLossAnalytics` says `groupBy` is not covered by the tenant
  middleware — it is (`groupBy` ∈ `readActions`). `QuotationExpiryService` says
  the extension never applies because there is no HTTP context — true for the
  cron, but the same method is exposed as `GET /quotations/expire-now` where a
  request context *does* exist and the sweep is tenant-scoped. Comments should
  match behaviour so the next reader does not "fix" the wrong thing.
- **Sources checked:** `quotations.service.ts:1084-1085`;
  `quotation-expiry.service.ts:45-47`; `prisma.service.ts:81-94`;
  `quotations.controller.ts:88-94`. Audit: #q-30.

### Checked and found sound (not open defects)

Recorded so they are not re-filed. Full evidence in the audit doc.

- Group-parent totals do **not** persist as $0: client may send a stale parent
  amount, but `syncResources` calls `applyGroupRollups` before persist.
- Mobile `departmentRole` is mapped correctly at `identity.http.ts:22`.
- Self-approval is blocked (requester excluded from approver pool).
- Expiry is idempotent; WON/LOST are not expired; advisory lock covers replicas.
- Web and mobile `calculateResourcePricing` match.
- All nine `QuotationStatus` members have labels and matching status buckets.
- Empty approver pool throws; it does not auto-approve.

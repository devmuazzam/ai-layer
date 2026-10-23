---
title: Quotations — open questions
status: reference
kind: gaps
updated: 2026-10-07
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
- Candidates: [meetings/2026-08-12-sell-side-workflow-and-scheduling.md](../meetings/2026-08-12-sell-side-workflow-and-scheduling.md)
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
- **Status:** resolved 2026-09-04 — answered from the record, no client question needed. All five are
  now in the vault from the client's own source files (the 2026-09-04 Project Repository drop): a
  permit-aware scheduling workbook, a pre-Dispatch checklist playbook, a 94-question call sheet, a
  KPI-tracker sheet, and the short-notice permit path in the Green/Yellow/Red playbook.
- Resolution (a) — **Job Schedule Master**: the Excel workbook *THE CRANE GUYS — PERMIT-AWARE JOB
  SCHEDULER* (`__Job Schedule Master (from Ryan 2026-08-11)/Job Schedule Master.xlsx`), written up in
  [projects-jobs/scheduling/job-schedule-master-workbook.md](../projects-jobs/scheduling/job-schedule-master-workbook.md).
  A `SCHEDULER COMMAND CENTER` takes job date · crane · city · start time · hours and computes crane
  availability, annual/blanket permit coverage, permit lead time, latest permit submission and a
  `FINAL PATH` (Green/Yellow/Red); 36 monthly dispatch boards behind it. Client artefact; shipped empty
  of live jobs.
- Resolution (b) — **Ready-to-Schedule Checklist**: the *Ready to Schedule* playbook (plus the
  *Sales Coordinator Scheduling* and *Scheduling Sheet* playbooks, same source set), written up in
  [projects-jobs/scheduling/ready-to-schedule.md](../projects-jobs/scheduling/ready-to-schedule.md).
  Eight sections (Customer · Project · Compliance · Crane · …) that must all be complete before the
  Sales Coordinator contacts Dispatch — *"cannot be scheduled until every required item has been
  collected"*. Owned by the Sales Coordinator role.
- Resolution (c) — **One-Page Customer Intake**: sheet `One Page Intake` of
  `The_Crane_Guys_Intake_JobWalk_DATABASE_v13….xlsx` — *"SALES COORDINATOR CRANE JOB INTAKE — ONE PAGE
  CALL SHEET"*, 94 questions in 15 sections, each with a Required flag and a named dropdown, with the
  companion Job Walk Sheet; written up in [sales-intake-and-job-walk.md](sales-intake-and-job-walk.md)
  §1–§3. Its Sources sheet attributes the questions to the *"Sales Coordinator questionnaire uploaded
  by Ryan"*. This is the field list; it is `status: unverified`, and **it is not a TCG confirmation
  that these are the ERP's intake fields** — the 2026-08-12 action item on the TCG team stands.
- Resolution (d) — **Geographic Heat Map**: a sheet of `RYAN_ADAMS_KPI_TRACKER_BACKEND_CONNECTED.xlsx`
  — a **city-level grouping of quote/invoice location**, fed from the `SOURCE_Invoices` FCC export;
  [sales-reporting-workbooks.md](sales-reporting-workbooks.md) §2.1 and §2.3. It is a report sheet,
  not a map artefact, which matches the meeting's *"reviewed … to analyze company activity by city"*.
- Resolution (e) — **"Red Path"**: defined by two client documents. The *Dispatch Scheduling — Green /
  Yellow / Red Path Playbook* ([projects-jobs/scheduling/dispatch-scheduling-path.md](../projects-jobs/scheduling/dispatch-scheduling-path.md))
  — Red is any job for which *"the full applicable [permit] lead time is unavailable"*, counted on a
  permit clock that excludes Thursday noon → Monday morning; automatic triggers include *"less than
  72 eligible working hours of notice"*; a Red job needs the customer permit waiver **and** direct
  Dispatch approval before it may be scheduled. The *Sales admin process mapping — Dispatch* board
  ([dispatch/dispatch-value-engine-and-playbooks.md](../dispatch/dispatch-value-engine-and-playbooks.md)
  §3) says the same in fewer words: *"Jobs without 72 hour notice"*. Brian Petros used the term the
  same way on the 2026-08-11 recording (44:52, *"red path is before 72 hours of the job"*). Both are
  client statements of practice; no human has ratified them, and the two Yellow definitions and the
  workbook's extra Red reason (crane unavailable) disagree — see the *Two places the sources disagree*
  section of the path page.
- Also closed by the same drop, though not part of the question: **permits** now have a section
  ([projects-jobs/city-permits/INDEX.md](../projects-jobs/city-permits/INDEX.md) — annual vs
  job-specific, city eligibility, lead times, waiver, FAA) and a travel-permit SOP
  ([dispatch/travel-permits-playbook.md](../dispatch/travel-permits-playbook.md)); and the
  *cranes under maintenance must not be selectable* rule is stated by the workbook (*"Scheduled, Saved,
  Tentative, Hold, and Maintenance are treated as unavailable"*). The *double booking must be
  supported* rule is still stated nowhere, and the workbook's rule that a `Scheduled` crane is
  unavailable is the opposite instinct — that remains for the Daily Allocation System.
- Sources checked: `projects-jobs/scheduling/{job-schedule-master-workbook,ready-to-schedule,dispatch-scheduling-path,INDEX}.md`,
  `quotations/sales-intake-and-job-walk.md` §1–§2, `quotations/sales-reporting-workbooks.md` §2,
  `dispatch/dispatch-value-engine-and-playbooks.md` §3, `projects-jobs/city-permits/INDEX.md`,
  `dispatch/travel-permits-playbook.md`, `meetings/2026-08-12-sell-side-workflow-and-scheduling.md`,
  `meetings/transcripts/2026-08-11-sales-process.md` (grep for the five terms only),
  `sync/project-repository-2026-09-04.md`.
- Owner: answered; no client action outstanding on this question. The 2026-08-12 action item — TCG to
  confirm the intake questions, fields and business rules — is unaffected and stays on the meeting page.
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
- **Status:** **largely resolved** 2026-09-05 — the ERP home for the customer PO is answered by a named human; residual questions (JZ's punch-list bullet, the vestigial web type) still open
- Update 2026-09-04 (Project Repository ingest): the drop shows where the customer PO lives **today**,
  and it lives in three places at once — evidence of FCC practice, not a TCG decision on (a)/(b)/(c).
  (1) **On the quote:** FCC's Job Quote *Main* tab carries a `PO No` field, and TCG's own review note
  on that screen reads *"This is the 'Customer PO number' — the PO Number that Customer give us"*
  ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §6 slide 4 and *Main tab, as populated*).
  The printed quote's acceptance block is *"Date · Print · Sign · PO Number"*, and its preamble
  makes a customer PO one of three artefacts that confirm a job (*"a signed copy of the estimate,
  written confirmation of the quote's approval, or a PO for the project"*)
  ([quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §8 and the acceptance block). (2) **On
  the job:** `FMS_JOB_MASTER.PoNumb` and `CustPOAmount`
  (`../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_JOB_MASTER_Raw.sql:14, 187`); the job screen
  shows `PO Number` on Main and a `PO(s)` panel ([fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md)
  §4); the 2017 vendor manual lists *PO number* among fields that exist *only* on the job
  (quote-entry §5), which the live screen contradicts. (3) **On the customer:** `FMS_CUSTOMERS.PORequire`
  and `POBeforeTicket` flags (`…/ddl/stg.FMS_CUSTOMERS_Raw.sql:24, 88`;
  [../customers/fcc-legacy-customer-data-model.md](../customers/fcc-legacy-customer-data-model.md)),
  and a customer pop-up note in use — *"Please do not schedule without a PO#"* (quote-entry, *The
  customer pop-up*). TCG's March 2026 design diagrams disagree with each other on the same point: the
  lifecycle SVG says *"Log customer PO # — record on job / schedule tab"* and *"reference it on our
  invoice"*, while the entity-hierarchy page puts a `PO Number` pill on the Quote
  ([quote-lifecycle-permits-and-purchase-orders.md](quote-lifecycle-permits-and-purchase-orders.md)
  §1–§2, §4). The playbooks treat the PO as a scheduling gate, not a quote field — *"Purchase order
  received"* on the Ready-to-Schedule checklist
  ([../projects-jobs/scheduling/ready-to-schedule.md](../projects-jobs/scheduling/ready-to-schedule.md)),
  *"Purchase order required"* asked at intake ([sales-intake-and-job-walk.md](sales-intake-and-job-walk.md)
  §1 sect. 14), *"Get PO for Job or COD needed to schedule"*
  ([sales-operating-system/06-value-engine-flow-and-lead-workflow.md](sales-operating-system/06-value-engine-flow-and-lead-workflow.md)).
  **What still needs the client:** nothing in the drop says what JZ's punch-list bullet asked for,
  whether the field `SCRUM-149` removed should return, or which of quote / job / customer TCG wants as
  the ERP's home for the number. `customers/customer-and-job-sites.md:41` is still the unanswered
  ask for a customer-PO form. `Q-26` in this register now defers to this entry for the product answer.
- Update 2026-09-05 (**Brian Petros**, written message + quote-to-job-to-invoice workflow diagram):
  **answered — the customer PO is not a quotation field.** Verbatim: *"PO Type 1 (Customer PO): Simple
  and passive on our end... the customer sends it, we log it, we put it on the invoice. It shows up at
  the moment the customer approves the quote, and again at invoicing."* The diagram's Type 1 panel gives
  three steps — *"Customer provides their PO #"* → *"Log it on the job (schedule tab) — no internal
  reporting required"* → *"Reference it on our invoice"*. So of the three candidate homes, TCG wants
  **the job / schedule tab**, surfacing at quote approval and again at invoicing. This matches the
  March 2026 lifecycle SVG (*"record on job / schedule tab"*) and settles it against the
  entity-hierarchy page's `PO Number` pill on the Quote. It also vindicates `SCRUM-149` (field removed
  from the quotation) and confirms the built columns `Project.poNumber` / `Job.poNumber` are the right
  shape — though **nothing writes them today**, so the number Brian requires on the invoice cannot yet
  be captured. Full note: [decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md](../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md).
  **Still open:** what JZ's 2026-06-23 punch-list bullet asked for, and whether the vestigial
  `poNumber` in `quotation-api.ts` should be deleted.
- **From (frozen original):** [gaps.md#customer-po-on-the-quotation-which-of-three-things-does-it-mean](../gaps.md#customer-po-on-the-quotation-which-of-three-things-does-it-mean)
- **Update 2026-09-09 (PR review of `fix/quotation-permits-plans`, no ticket):** the branch **re-adds a customer PO field to the quotation** — a new `Quotation.customerPo` column (migration `20260909120000_add_quotation_customer_po`, `VARCHAR(100)`, schema comment *"Type 1 Customer PO captured on the quotation; copied to Job.poNumber on convert"*), a **Customer PO** input on the quotation Main tab (`apps/web/src/features/quotations/components/molecules/customer-po-field.tsx`), carried by quotation duplicate, and copied to `Job.poNumber` at convert (`projects.service.ts`). That is the field `SCRUM-149` removed and the field the 2026-09-05 decision calls **not a quotation field** — four days after the decision. It is **not** the vestigial `poNumber` this entry left open: that web-only type still exists untouched, and the new column is a separate, real one. The branch's implicit reasoning is timing rather than location, and that question is now its own entry — see *The customer PO arrives before the job exists — may the quotation capture it?* below. **Nothing here is adjudicated;** the decision stands as written until Brian Petros says otherwise.

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
- **Update 2026-09-04 (Project Repository ingest):** legacy practice only, no decision. FCC does not
  version billing-code or price-list rates at all — a rate is one `Default Rate` per code and one
  `Rate` per (code, list)
  ([fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §4 *BIGGE's Billing
  Codes tab*, and *Billing Codes – WPF*). What FCC dates is the **assignment**: the customer record
  carries `Price List` with an **`Expires`** date (§4 *The Customers screen*;
  `../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_CUSTOMERS_Raw.sql:40-41` `PriceList` /
  `PriceExpires`), the job site carries the same pair
  ([../customers/fcc-legacy-customer-data-model.md](../customers/fcc-legacy-customer-data-model.md)),
  and **the job carries its own copy** (`ddl/stg.FMS_JOB_MASTER_Raw.sql:109,171`; the real SCE job
  `OM55127` shows *Price List `SO CAL EDISON`* in its Related Information panel, §4) — so an old job
  invoices at whatever its list says *now*, not at the rate in force on its work date. The only
  effective-dated, yard-scoped rate record FCC has is the **Billing Costs** row (*Effective Start /
  End Date*, §*Billing Costs pane*), which TCG says it does not use — while TCG's slide-14 note asks
  for effective-dated, backdatable **burden** rates for financial reporting (§5), a TCG requirement
  about cost, not billing. Still needs the client: whether ERP billing rates / price-list rates are
  to be effective-dated at all, at which grain (code, list, or assignment), and whether the
  burden-rate ask extends to them.

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
- **Update 2026-09-04 (Project Repository ingest):** the legacy system has a written copy contract,
  and it is narrower than ours. FCC's **Copy Quote** opens a *Copy Job Detail* dialog — *"Select the
  data to copy"* — with three checkboxes, **Estimate · Equipment · People**, all ticked by default,
  plus **Start Date / End Date** for the new quote; unticking a box *"provide[s] the user with a
  clean slate for that area"*, the copy is unsaved until saved, and the stated use case is *"the
  customer wants the same unit back at the same site"*
  ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §5, and the Atom capture under *`Sales
  Guide (Atom)v.1.0.docx`*). Documents are not among the options — quote files live in a separate
  *Maintain File Links* window with their own `Include On Job` flag (*Quote documents*, slide 10).
  So in FCC a copy is the resource tree and the estimate lines, chosen per area, with new dates and
  no documents; FCC's only stored header total is `Quote Max`, the estimate sum
  ([fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §4), and whether a
  copy recomputes it is not shown. That is legacy behaviour, not a TCG decision — (a) attachments,
  (b) `discountValidUntil`, and (c) carry-vs-recompute of stored totals still need Ryan / Joe.

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
- **Update 2026-09-04 (Project Repository ingest):** two things, neither a decision. (a) The second
  real quote, OM-36229 (2026-03-08, a 40-ton job), prints the **identical** three-bracket /
  four-tier long-boom table — *"identical to OM-35140 and … confirmed, not changed"*
  ([quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §9) — so the table is standing
  boilerplate on every quote, not a per-job term. (b) On the billing side FCC has **`LBP` — Long
  Boom Pay** as one of its 37 **Billing Code Types**
  ([fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §*Billing Code
  Types*), i.e. a category a billing code can belong to — but no long-boom billing *code* appears in
  the §3 catalogue, on either estimate template, on the two real quotes' rate tables, or on the six
  April 2026 invoice packets
  ([../accounting/invoice-packets-2026-04-worked-examples.md](../accounting/invoice-packets-2026-04-worked-examples.md)).
  So the legacy system classifies long boom as a billing type and holds no priced code for it in
  anything seen, which is consistent with the uplift being billed by hand, if at all. Where the four
  tier rates should live, and what is billed above 340′, still need the client.

## The surcharge is blanket in the contract but per-resource in the model, and it has no name

- **Status:** resolved 2026-09-02 — (a), (b) and (c) all answered; see the resolution notes below
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
- **Resolved 2026-09-02 — (a) and (b).** See
  [decisions/2026-09-02-one-surcharge-per-quote.md](../decisions/2026-09-02-one-surcharge-per-quote.md).
  The client had already answered (a) in the 2026-05-05 ERP review, which this entry had not
  reached: **ans.nisar @ 1:13:10** asked *"does it affect surcharge for all the quotations, or does
  it vary?"* and **Melissa McNutt @ 1:13:29** answered *"One line for all the quotations. Yeah, one
  price. Actually, on price list there may be different, but we can set those up per the price
  list."* One rate per quote, price list overriding the tenant-wide default; per-line variation is
  membership only (`BillingCode.applySurcharge`), never rate. (b) is answered by adding
  `Surcharge.label`, defaulted to `Fuel & Insurance Surcharge` and editable — a column rather than a
  constant because TCG asked to rename it and the industry bills emissions and environmental
  surcharges through the same mechanism.
- **A third fault this entry did not name, found 2026-09-02 and fixed with it.** `resolveRate`
  decided the surcharge *rate* per item, so a mixed quote — some lines priced from the price list,
  some falling back to their billing code — carried **two different rates in one total**, matching
  no stated percentage. This was arithmetic rather than policy: reproduced against quote OM-35140,
  which came out at $5,616.80 instead of $5,157.60 with every line 12% high. The printed quote also
  folded the surcharge into each line's amount and showed no named row; it now prints clean line
  amounts plus `Fuel & Insurance Surcharge  1.00  Each  12.00%  $552.60`, reconciling to $5,157.60.
- **Resolved 2026-09-02 — (c). Yes: invoicing recomputes it, against the invoice's own lines.**
  Micaela Dipane walks the whole flow in `meetings/transcripts/2026-07-23-accounting-invoicing.md`.
  She corrects the hours to actual — **@ 18:34** *"So then in here, **we'll do 5 hours**. The
  overtime and double time aren't applicable in this one. And if you leave it zero, it erases it
  automatically."* — adds anything the quote missed (**@ 18:03** *"if that wasn't in there… you just
  add your overtime or double time line item"*), and only then **@ 18:49** *"From the invoice, we'll
  add in the NOTAM, the travel permit, and then **our surcharge**. And then we hit save."* The
  surcharge is applied to the corrected invoice, not carried across from the quote. Melissa McNutt
  states the recompute rule in general terms on 2026-06-17 @ 30:52 — *"The one thing that would need
  to auto change is a surcharge. It would need to calculate everything."*
  **Consequence:** `QuotationResource.finalAmount` keeping the surcharge inside it is harmless — the
  invoice does not inherit that figure, it recalculates from its own lines. The quote's surcharge is
  an estimate over quoted hours, exactly as the T&C implies.
  **An earlier note on this entry said no recording addressed (c). That was wrong** — it read
  Micaela's line about *adding* the surcharge without the six lines above it where she edits the
  hours.

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
- **Update 2026-09-04 (Project Repository ingest):** the record shows *where* the minimum lives
  today and *how* it is applied, but states no rule for the ERP. (i) **Quoting time — a default
  quantity plus a comment.** The estimate template seeds the crane line at 4.00 h, and the live
  90-ton quote seeds *Operator Load* at 5.00 h with the comment *"5 hour minimum"*
  ([fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §4 *Estimate tab*;
  [fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md) §2); TCG's own SOP
  says *"FCC will automatically generate the crane and the minimum hours for the machine you are
  quoting"* ([tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md) §5). Nothing enforces it — the
  vendor manual says every seeded line *"may be changed or deleted"*. (ii) **Invoicing time — by
  hand.** The April 2026 packets bill *Operator Load* at **qty 8** under the printed text *"5 hour
  minimum with 8 hour max per day"*, and cranes at their actual hours (8.50, 11.50, 13)
  ([../accounting/invoice-packets-2026-04-worked-examples.md](../accounting/invoice-packets-2026-04-worked-examples.md)
  *Labour and support — Layout A*), so the max is applied by whoever enters the quantity. (iii)
  **The customer-facing statement** is per equipment class — 22-ton 3 h, everything else in the
  fleet 4 h ([../customers/new-customer-packet.md](../customers/new-customer-packet.md) *Hour
  minimums by equipment class*) — while the contract adds an **8-hour minimum workday** including
  assembly / disassembly (clause 8) and an 8-hour crew minimum for cranes left on site (clause 11)
  ([quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §10), and the E-Ticket T&C the
  4-hour-or-true-time cancellation rule
  ([../field-ops/field-paper-forms.md](../field-ops/field-paper-forms.md) §14). The Sales OS lists
  *"minimums"* as a required quote-development input
  ([sales-operating-system/03-sales-coordinator-operations-manual.md](sales-operating-system/03-sales-coordinator-operations-manual.md)
  §4, phase 4). All legacy practice and contract text; (a) where the min / max is modelled, (b)
  default-up / warn / reject, and (c) quote-time vs invoice-time enforcement still need the client.

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
- **Update 2026-09-04 (Project Repository ingest):** the boundary is stated twice by the client and
  the two statements disagree, so this stays open. Ryan Adams, 2026-05-05
  ([transcript](../meetings/transcripts/2026-05-05-tcg-erp-system.md) 1:20:25): *"if we picked a
  number, let's say 50,000, **any quote over 50,000** that it had to be reviewed"* — exclusive. Wes
  Staley, 2026-06-17 sprint review
  ([transcript](../meetings/transcripts/2026-06-17-erp-sprint-review.md) 50:36): *"the manager would
  be notified for the **50,000 and over**, and the reduced rate"* — inclusive. Neither was a
  decision — both were describing the idea — and the AI extraction of the May meeting records only
  *"flag quotes over a dollar threshold — $50,000 was the figure discussed"*
  ([../erp-review-log.md](../erp-review-log.md) → *Quote approval*). TCG's own Sales Operating
  System lists *"Confirm approval thresholds for discounts, free lift plans, invoice adjustments and
  strategic concessions"* as an **unfinished** governance decision
  ([sales-operating-system/01-operating-system-architecture.md](sales-operating-system/01-operating-system-architecture.md)
  §12, item 7), and TCG's quoting SOP makes supervisor approval **unconditional** before any quote
  is sent ([tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md) §7) — a different regime from a
  threshold altogether. Still needs the client: "at or above" vs "above", stated as a rule about the
  comparison.
- **Update 2026-10-22 (10-20 call and the code):** the documentation CodingCops handed TCG on 2026-10-20
  says a quotation needs approval when it is **above 50K** or when *"there is an amount that is changed
  from the billing code"* (ehtesham.anwar, 7:01 — [2026-10-20-erp-documentation-portal-set-up-order-test-login-and-staging.md](../meetings/2026-10-20-erp-documentation-portal-set-up-order-test-login-and-staging.md) §1). The build is
  narrower: `apps/api/src/usecase/quotation-approvals/quotation-approvals.service.ts` computes
  `RATE_BELOW_MINIMUM` (a rate **below** the reference rate), `TOTAL_EXCEEDS_LIMIT`, `BOTH`, or else
  `MANDATORY` — so every quote is routed for approval, and a rate changed **upwards** is not a trigger.
  The build matches the review log (*"charging above standard rate is fine"*) and the SOP's unconditional
  approval; **the documentation's wording overstates it**. Nothing on the call answered the
  inclusive/exclusive question. The wording is CodingCops' to correct, not a question for TCG.
- **Update 2026-10-23 (10-22 walkthrough part 2):** ehtesham.anwar repeated the documentation's wording
  on the call: internal approval when the quote is *"50,000 and above"* and on *"any change from the billing
  code that we have added"* (41:34). It is still broader than the build (a rate **below** the reference
  rate, or the total over the threshold), and *"and above"* is inclusive where the code is exclusive
  (`totalAmount > approvalThreshold`). Nobody from TCG commented. Source: [2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md](../meetings/2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md) §6.

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
- **Update 2026-09-04 (Project Repository ingest):** the validity *period* is now sourced; the
  *boundary* is not. Both real quotes carry the same preamble — *"This is not a contract and **will
  expire 30 days from issue.** After the 30 days rates are subject to change without notice"* — and
  clause 17 of the numbered T&C repeats *"Quote valid 30 days, subject to equipment availability at
  time of order"* ([quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §8, §10). The Sales
  OS *Quote Sent* email template requires the **expiration** to be stated in the covering email as
  well as the PDF
  ([sales-operating-system/05-forms-and-records-matrix.md](sales-operating-system/05-forms-and-records-matrix.md)
  §8), and the punch list asks for a *"`Valid Until` placement update"*
  ([quotations.md](quotations.md)). FCC itself has no valid-until field — its quote dates are `Job
  Date`, `Ending Date`, `Final Date` (*"the last date to submit bids"*), `Submitted Date`, `Award
  Date`, all date-only ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §2 *Main tab*) — so
  there is no legacy precedent for an instant. What follows for the ERP, none of it decided: the
  client's own paper puts the default at **issue date + 30 days**, expressed in calendar days, not
  instants; whether the 30th day is inside or outside, and in whose timezone, is not stated
  anywhere. Still needs the client.
- **Update 2026-09-09 (SCRUM-TZ decisions) — the *"in whose timezone"* half is answered; the
  boundary half is not:** the day is defined in the **tenant's business timezone**, and that day
  starts at **00:00 local**. See
  [../decisions/2026-09-09-business-timezone-is-a-tenant-property.md](../decisions/2026-09-09-business-timezone-is-a-tenant-property.md)
  (the zone is a tenant property),
  [../decisions/2026-09-09-business-day-starts-at-midnight-local.md](../decisions/2026-09-09-business-day-starts-at-midnight-local.md)
  (the day starts at midnight, local) and
  [../decisions/2026-09-09-tenant-timezone-configuration.md](../decisions/2026-09-09-tenant-timezone-configuration.md)
  (configuration and display) — all `status: reference`, decided by Syed Haris (developer/owner),
  **not** by a TCG product owner, so all three are open to being overruled. That does resolve the
  variability this entry flags: with the tenant's zone as the reference, a quote's lifetime no
  longer depends on the salesperson's browser zone parsing the picker at *their* local midnight.
  **Still unanswered, and it is the half the customer loses a day to:** whether *Valid until
  15 Sep* is inclusive of the whole of 15 September, or expires at the instant that day begins.
  Knowing the zone does not decide inclusivity. **Stays open.**

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
- **Update 2026-09-04 (Project Repository ingest):** legacy practice only, no decision. In FCC the
  price list is fixed **at creation** and travels with the record rather than being re-read from the
  customer: the lifecycle diagram's first node is *"Create quotation — customer + price list
  selected"*
  ([quote-lifecycle-permits-and-purchase-orders.md](quote-lifecycle-permits-and-purchase-orders.md)
  §1); the quote's Estimate tab has its own `Price List` field above the grid, and the Customer
  Information panel shows the list the quote was priced on
  ([fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §4;
  [fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) *Main tab, as populated*); a line's rate
  arrives from the list *"if not set"* at entry, i.e. once
  ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §2 *Estimate tab*); and the **job carries
  its own `PriceList` / `PriceExpires` columns**
  (`../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_JOB_MASTER_Raw.sql:109,171`), shown live as
  *Price List `SO CAL EDISON`* on job `OM55127`. TCG's own annotation says only that the estimate
  *"includes the rates (based on the customer/price list)"*
  ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §6, slide 6) — silent on re-pricing. So
  the legacy default is "keep the list it was written against"; whether the ERP should re-price on
  edit still needs the client.
- **See also (2026-09-17):** Brian's FCC deep dive ([fcc-billing-resource-configuration-deep-dive-2026-09-16.md](fcc-billing-resource-configuration-deep-dive-2026-09-16.md) §7–§9, recommendation) reports these FCC numbers:
  - of historical quote lines, 11,284 took the price-list rate and kept it, and 458 took it and were then edited;
  - `OriginalRate` stores the resolved rate and `Rate` the final one.

  It recommends freezing the resolved rate, its source and the final rate on the line, so that *"changing the PREFERRED Price List next month must not alter this historical Quote"*. That supports keeping a saved quotation's rates. It does not say what an edit should do to the quotation's price-list **selection**. Not a ruling.

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
- **Update 2026-09-04 (Project Repository ingest):** the legacy system locks a quote on
  **conversion**, not on a date. *"If a quote has already been converted to a job, it will appear
  grayed-out… no changes can be made to the quote and all changes must occur in the job screen"*
  ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §5); the March 2026 lifecycle diagram's
  node 6 is *"Convert to job — quotation locked in system"*
  ([quote-lifecycle-permits-and-purchase-orders.md](quote-lifecycle-permits-and-purchase-orders.md)
  §1); and the review log's extraction says *"the quote must remain static after signature"*
  ([../erp-review-log.md](../erp-review-log.md) → *Quotations, jobs and projects*). FCC's Job Date /
  Ending Date are optional — the live Mastec quote shows both as `00/00/0000`
  ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) *Main tab, as populated*) — and its `PEND`
  / `FW1` / `FW2` statuses exist so an unconverted quote can be followed up over time (*Job Types
  and Quote Status codes*). None of that states a rule about past dates on edit; it shows the
  client's current tool has no such rule. Still needs the client.

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
- **Update 2026-09-04 (Project Repository ingest):** legacy practice on (a), nothing on (b). In FCC
  a file added to a quote's *Maintain File Links* is **stored only**; sending it is a separate,
  deliberate action — highlight the row and click **E-Mail**, or **Post Doc** to DocuSign, and *"to
  access DocuSign, a quote document must first be generated"*
  ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §4). Each file row carries an **`Include
  On Job`** flag, and on TCG's own system the layout drawing (*"Job layout"*) is ticked while the
  quote PDF is not — uploads are routed to the *job*, with TCG's note *"Lift plans and other
  documents per Job Quote"* beside it (*Quote documents*, slide 10); job-site files have the same
  flag as `Include on Job \ Quote`
  ([../customers/fcc-maintain-customers-tcg-review.md](../customers/fcc-maintain-customers-tcg-review.md)).
  Whether Post Doc can carry more than the generated quote PDF is not shown by any capture, so (b) —
  and the [quotations.md](quotations.md) conflict line — stand as they were. (a)'s answer in the
  legacy system is "store, then send explicitly"; whether the ERP should match it still needs the
  client.

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
- **Update 2026-09-04 (Project Repository ingest):** legacy practice only. In FCC envelope state is
  refreshed by a manual **Get Status** button on *Maintain File Links* — there is no push — and the
  salesperson receives *"an email notification … when the customer opens the document"*; observed
  states are blank → Delivered → Complete, with a separate `Downloaded` / `Signed Document` row
  after download ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §4, and the v1.2 / v2.2
  capture notes). So the client's current tool is pull-on-demand, and the lag complained about in
  the ERP is one FCC never hid. That is evidence of what they are used to, not a decision on
  pull-on-return vs webhook; still needs the product team.

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
- **Update 2026-09-04 (Project Repository ingest):** TCG's own quoting procedure fills the field
  every time, but as a convention, not a validation rule. The Creating Quotes SOP prescribes
  **Salesperson — *"Enter your name (the person creating the quote)"*** and **Taken By — *"Enter
  your name (you are the person taking the call or entering the info)"***
  ([tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md) §4), and the live Mastec quote shows
  Salesperson, Taken By and Checked By as the same person
  ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) *Main tab, as populated*). Two things cut
  against "salesperson = logged-in user": FCC's salesperson is a **separate 33-row lookup**
  (`FMS_SALES_PERSON`, `UserID` nullable —
  `../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_SALES_PERSON_Raw.sql`), distinct from *Taken
  By* (`FMS_CHECKED_TAKEN`, 31 coordinator rows —
  [../payroll/tcg-rawfms-staging-database/data/fcc-checked-taken-list.md](../payroll/tcg-rawfms-staging-database/data/fcc-checked-taken-list.md)),
  with commissions keyed on the salesperson and coordinator pay on Taken By
  ([sales-commissions.md](sales-commissions.md) §11); and Melissa described sales coordinators
  drafting quotes *for* a salesperson — *"salesperson Jason, quote done by [the coordinator]"* as
  two distinct names ([2026-06-17 sprint
  review](../meetings/transcripts/2026-06-17-erp-sprint-review.md) 45:35, 48:05). The Sales OS makes
  *"assigned salesperson"* a required lead-intake input
  ([sales-operating-system/03-sales-coordinator-operations-manual.md](sales-operating-system/03-sales-coordinator-operations-manual.md)
  §4, phase 1) and HubSpot requires an assigned owner on every opportunity
  ([hubspot-sales-playbook.md](hubspot-sales-playbook.md)). So the record supports a salesperson
  being **always present** and **not necessarily the creator**; it does not state "required" as a
  rule, nor what a non-sales creator defaults to. Still needs the client.

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
- **Update 2026-09-04 (Project Repository ingest):** legacy practice only, no decision. On FCC's
  quote Main tab **every lookup — Customer, Job Site, Report To, Quoted To — has a `New` button
  beside it**, and TCG's own annotation is *"Can click 'New' to create new Customer, Job Site,
  etc."* ([fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §4 *The Job
  Quotes screen*; [fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §6 slide 4, and *Main tab,
  as populated*). So inline creation of both contacts exists in the tool the client uses today, for
  Quote To as well as Report To. On what it writes: FCC's contacts are customer-owned rows
  (`FMS_CUSTOMER_CONTACTS`, `ContactType` Ordered By / Report To / Both —
  [../customers/fcc-legacy-customer-data-model.md](../customers/fcc-legacy-customer-data-model.md)),
  and the job-site Contacts tab shows the same rows as the customer's
  ([../customers/fcc-maintain-customers-tcg-review.md](../customers/fcc-maintain-customers-tcg-review.md),
  slide 11); the 2026-06-23 FCC copy holds no quote-level contact table, but it holds no quote
  tables at all, so that does not prove where the `New` button writes. TCG's SOP minimum for a
  contact is *"name and phone number"* ([tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md)
  §4). Whether the ERP should do the same, and with the customer module's validation, still needs
  the client.

## Should a per-resource surcharge column be shown on quotation resource rows?

- **Status:** resolved 2026-09-02 — **no.** Removed; replaced by a per-row membership badge
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
- **Resolved 2026-09-02 — the column is removed.** The entry deferred to the modelling question,
  which is now decided:
  [decisions/2026-09-02-one-surcharge-per-quote.md](../decisions/2026-09-02-one-surcharge-per-quote.md).
  With one rate per quote the column showed **the same percentage repeated down the page**, and an
  amount that is `line × that rate`. It also displayed the per-line model the decision replaced, on
  the screen where users form their mental model of how the charge works — which was the reason this
  question was blocked rather than a layout preference.
  **Nothing was lost.** The per-row surcharge amount and percentage were already in the Amount
  tooltip (`Surcharge (12%)  +$427.20`), and they stay there. What the row now carries instead is
  the one fact not derivable from anywhere else: a **Surcharged / No surcharge** badge saying
  whether the line is inside the surcharge base — the opt-out Melissa McNutt describes at
  2026-05-05 @ 1:03:10, which had no UI at all until the same day. The rate itself is stated once,
  on the existing quote-level Surcharge chip.
  This also aligns the editing view with the customer document: the printed quote shows one named
  surcharge line, not a per-row column.
  **What this does not decide:** whether the badge is the right *treatment* — nobody has yet exempted
  a line in practice (Joe Schacatano, 2026-05-05 @ 1:03:44: *"I can't give you like a single example.
  I would just say we have to have the option"*), so the exempt state is currently unexercised. If
  TCG starts using it and the badge proves too quiet, that is a new question, not this one.
  `ResourceSurchargeCell` is deleted; the read-only detail grid drops from eight columns to seven.
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
- **Correction 2026-09-04 — the resolution's *"Nothing was lost"* no longer holds.** Branch
  `fix/customer-quotation-3sep` (no ticket) removes the surcharge line, the `Exempt` line and the
  pricing-source label **from the Amount tooltip as well**, and gates the info icon and arrows on
  discount/hike only — so the per-row surcharge amount and percentage that this entry cited as
  still available now have **no UI anywhere on create/edit**. The same branch makes the
  *Surcharged* badge hover-only, which is the *"proves too quiet"* case this entry anticipated.
  The resolution above is left standing as the record of what was decided on 2026-09-02 and why;
  what changed since is a separate open question —
  [Per-row surcharge now has no UI on create/edit, and "Final Amount" means two different
  numbers](#per-row-surcharge-now-has-no-ui-on-createedit-and-final-amount-means-two-different-numbers).

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

## Is "New Item" allowed to be hover-only, when it is the only way to add a child row?

- **Status:** open
- **Asked:** 2026-09-04 — PR review of branch `fix/customer-quotation-3sep` (no ticket, no
  `.ai/aidlc/processed.log` row, no `SCRUM-###/spec.md` to hold this); tcg-scrum escalation
- **Question:** the branch replaces the always-visible **New Item** strip under a parent resource
  row (`add-child-item-button.tsx`, an indented tinted band that sat permanently beneath the row)
  with an insert line that **appears only while the pointer is over the row**
  (`resource-row.add-child-insert.tsx` + `useAddChildInsertHover`). The capability, the label and
  the handler are unchanged; what changed is that the only route to a manually added child is now
  invisible until hovered. Is a hover-revealed affordance acceptable for an action a salesperson has
  to find unprompted, on the screen where a quote is built? Judgement note: this is close to the
  product/implementation line and may not need a product answer at all — it is filed because it is
  the **second** affordance in three days to be moved behind hover with no source, so the pattern
  needs someone's decision rather than a per-branch preference.
- **Sources checked:** **Vault — nothing on discoverability, hover or progressive disclosure.**
  [quotations/INDEX.md](INDEX.md) and the conflict stub [quotations-INDEX.md](quotations-INDEX.md);
  [quotation-flow-process.md](quotation-flow-process.md) (steps 1–27 — no UI detail at this level);
  [quotations.md](quotations.md) and [quotation.md](quotation.md) (the two punch lists — neither
  mentions adding child rows); this register; `../decisions/` (26 notes — the only app-wide UI
  conventions decided are post-save navigation and archive-instead-of-delete, neither about
  affordance visibility); vault-wide grep for `hover|tooltip` outside `meetings/` returns four hits,
  three of them this register's own surcharge entries and one an assets user story about a map pin
  hover — **no convention anywhere.**
- **The same question is already open app-wide, from a different module.**
  [assets/gaps.md → *Save and Cancel hidden until a section is dirty — intended, or an affordance
  nobody finds?*](../assets/gaps.md#save-and-cancel-hidden-until-a-section-is-dirty--intended-or-an-affordance-nobody-finds)
  was raised 2026-09-02 on `feat/asset-tabs-inline-edit` and says in terms that **the question is
  app-wide, not assets-only**. This is the same underlying question — what the UI owes a user who
  has not yet interacted — reached from the quotations side, and it is cheapest to settle **once**,
  the way post-save navigation was, rather than per module. Whoever answers that one should answer
  this with it.
- **Not in question:** that a manual child row can be added at all, or the *placement* of the
  control at the start of the Item column under its parent — the deleted component was already
  indented to the child's depth for the same reason. Only the hover gating is unsourced. The branch
  does handle touch: `(hover: none)` pointers keep the slot permanently open, so the regression is
  desktop-only.
- **Jira: not consulted — unavailable this session.** The Atlassian MCP returns
  `403 Tenant is restricted: suspended-payment`, so a QA or client ticket asking for a quieter
  Resources tab is unseen and would settle this.
- **Blocked:** nothing technically; sign-off of `fix/customer-quotation-3sep` as product-correct,
  and the next screen that hides an affordance behind hover on this precedent.
- **Owner:** Fouzan Shakil — an internal UI convention, same class as post-save navigation, and he
  already owns the assets entry above. Worth one line from Melissa McNutt if salespeople are the
  ones expected to discover it.

## Per-row surcharge now has no UI on create/edit, and "Final Amount" means two different numbers

- **Status:** open
- **Asked:** 2026-09-04 — PR review of branch `fix/customer-quotation-3sep` (no ticket, no
  `.ai/aidlc/processed.log` row, no `SCRUM-###/spec.md` to hold this); tcg-scrum escalation
- **Question:** [decisions/2026-09-02-one-surcharge-per-quote.md](../decisions/2026-09-02-one-surcharge-per-quote.md)
  settles that a quotation carries **one** surcharge, resolved at quote level, printed as one named
  row above clean line amounts. The branch takes three further steps that the decision does not
  authorise, each answerable in a line. **(a) Per-row surcharge attribution now has no UI anywhere
  on create/edit.** The Amount tooltip dropped its `Surcharge (12%)  +$427.20` line, its `Exempt`
  line and its pricing-source label, and the info icon and up/down arrows now render **only** when a
  discount or price hike exists — so a surcharged row is visually identical to an exempt one except
  for the badge. This **voids the recorded rationale for removing the Surcharge column two days
  earlier**, which was explicitly *"Nothing was lost… they stay there"* (see the entry above). Is
  the quote-level footer line sufficient, or must a salesperson still be able to see what the
  surcharge did to a given line? **(b) The "Surcharged" badge is now hover-only.** The default
  (in-base) state renders at `opacity-0` until the row is hovered or the control is focused; only
  the exception, *No surcharge*, stays visible. The same entry that introduced this badge on
  2026-09-02 left open *"whether the badge is the right treatment"* and said that if it *"proves too
  quiet, that is a new question"* — this makes it quieter still, two days later, with nobody having
  reported it too loud. **(c) The tooltip's "Final Amount" is no longer the final amount.** It now
  shows `amountBeforeDiscount − discount + hike`, excluding surcharge, while
  `QuotationResource.finalAmount` — the field of the same name, which the decision deliberately left
  surcharge-inclusive because redefining it reaches invoicing — is a different number. One label,
  two meanings, on the same screen. Should the tooltip row be renamed (e.g. *After adjustments*), or
  should it keep matching the stored field?
- **Sources checked:** [decisions/2026-09-02-one-surcharge-per-quote.md](../decisions/2026-09-02-one-surcharge-per-quote.md)
  — it settles the *model* and the *printed document* and says nothing about the editing UI beyond
  what the column entry recorded; its *What it does not settle* names the per-resource UI question
  as still open. [Should a per-resource surcharge column be shown on quotation resource
  rows?](#should-a-per-resource-surcharge-column-be-shown-on-quotation-resource-rows) — the
  originating entry, whose resolution this branch partly invalidates. [The surcharge is blanket in
  the contract but per-resource in the model](#the-surcharge-is-blanket-in-the-contract-but-per-resource-in-the-model-and-it-has-no-name)
  — resolved, and confirms invoicing recomputes the surcharge from its own lines, so nothing
  downstream depends on the quote's per-row figure being *visible*.
  [billing-code-and-price-list.md](billing-code-and-price-list.md):31-32 — *"Re-design surcharge
  placement"*, still the only vault statement about surcharge placement, still UI feedback with no
  target layout. [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §1 — the printed
  document shows one surcharge line, which is evidence about the customer document and not the
  editing screen. Also checked: [quotations.md](quotations.md); [quotation.md](quotation.md);
  `../decisions/` (26 notes); `.ai/aidlc/` (no folder or `processed.log` row for this branch).
  Verified in code that the **quote-level** named surcharge row in the Resources table footer
  (`resources-table-content.tsx` `SurchargeLineRow`) is untouched by this branch — it predates it
  and still renders, so the one-surcharge model itself is intact.
- **The strongest counter-signal is a client QA ticket, and it cannot be read this session.**
  `SCRUM-873` Create Flow item 4 — quoted verbatim in the entry above as *"In the Resources tab, the
  surcharge is displayed as Inactive even though the surcharge is active. Please fix the status
  display"* — is a client ask to **fix**, not hide, surcharge status on the create-flow Resources
  tab. (b) hides the fixed state behind hover. That combination is exactly the tension that entry
  flagged as *"a high-risk combination without sign-off"*, and it has now happened a second time.
  **Jira: not consulted — unavailable this session** (Atlassian MCP returns `403 Tenant is
  restricted: suspended-payment`), so `SCRUM-873`'s current text and status are unverified here and
  the quote is second-hand from this register. Re-read `SCRUM-873`, `SCRUM-567` and `SCRUM-401`
  before answering — the entry above lists why each bears on this.
- **Blocked:** sign-off of `fix/customer-quotation-3sep` as product-correct. Also blocked by
  consequence: the read-only **detail** tab still shows a dedicated Surcharge column
  (`detail-resources-tab.tsx`), so create/edit and detail now disagree about per-row surcharge by
  two steps rather than one, and that asymmetry is still unstated.
- **Owner:** product team — Melissa McNutt on (a) and (b), as the client voice who described the
  per-line opt-out and asked for the surcharge to be unmissable (*"a standard that shows up on every
  quote so nobody forgets it ever"*, Brian Petros, 2026-05-05 @ 1:03:00); Fouzan Shakil on (c),
  which is naming rather than policy.

- **Update 2026-09-19 (UAT register) — UAT 1 asks for the hover total to be removed, which is weaker than it looks.**
  [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → NOT DONE *Remove the hover total in Resources*, [UAT 1]:
  *"No column named 'Amount Total' ever existed — the headers are Item / Quantity / Measuring Unit / Rate / Amount / Comments.
  The surcharge lines were removed from the hover tooltip, but a **'Final Amount' total still appears on hover whenever a
  discount or price hike is present**."* `resource-row.amount-cell.tsx:75`.
  Against [../decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md](../decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md)
  rule 2 — *"Each resource row's Amount is the amount **before** any adjustment"* — and rule 3 — *"**The footer rows carry the
  adjustment money**"*. A per-row *Final Amount* on hover is adjustment money surfacing on the row, which is what that
  decision routes to the footer, and it is the second of the two numbers this entry already names as *"Final Amount"*.
  **Flagged as the weakest of the six conflicts logged this day**, and deliberately so: the decision governs the **Amount
  column**, and a tooltip is not the column. It may be exactly the residual UI this entry was opened for, or it may be
  harmless. The UAT row also mis-names the thing it wants removed, so the request itself is not clean. **Do not treat
  this as a contradiction to resolve; treat it as one more reason to answer this entry.** Nothing adjudicated.

- **Update 2026-10-17 (TCG-218 close-out) — the customer-document decision does not reach this entry.**
  [../decisions/2026-10-17-customer-documents-show-no-discount-every-line-net.md](../decisions/2026-10-17-customer-documents-show-no-discount-every-line-net.md)
  (`verified` for Joe Schacatano's rules 1–3) changes 09-11 rules 2–3 **for customer documents only** — the PDF and print show
  every line net, with no Discount / Price Hike rows. It states that internal screens (create/edit, detail, approvals) keep
  the 09-11 on-screen rules, so the create/edit hover tooltip, its *"Final Amount"* row and parts (a)–(c) here are untouched.
  Do not read the 10-17 note as answering this entry. **Status unchanged: open.**

## Estimate defaults per resource type / job type / yard — FCC has them, TCG has no job type at all

- **Status:** open
- **Asked:** 2026-09-03 — Brian Petros, Teams message to ehtesham.anwar, following Joe (Schacatano)
  raising in that day's meeting that quotation estimates are per crane **and** differ per Job
  Type. Not a ticket question: no `SCRUM-###` is in flight on quotation estimate defaults.
- **Question:** does the ERP adopt FCC's estimate-template model — a **Job Type** dimension, and
  a default set of estimate lines held per **(resource type, job type, yard)** that seeds a
  quotation's resources — or do estimators keep assembling every quote by hand as they do today?
  Six sub-questions the message does not settle: **(a)** what is the full job-type list, is it
  tenant-configurable, and does every resource type carry the same list? **(b)** does a job type
  also vary the *Unit/People* set (the message says "potentially different"; the 100 Ton's two
  job types are identical) — **unanswerable from a migrated tenant**, because the seeder dropped
  `JobTypeYardID` from all 161 equipment and 117 employee rows (see the flattening entry below)?
  **(c)** ~~is the yard slot ever narrower than *All Yards*~~ — **answered by the
  2026-09-02 extract README**: absence of a `FMS_UNITTYPE_YARDS` row *is* All Yards, and exactly
  **4 of the 75 production configurations are specifically Main Yard**. What remains is an ERP
  design question, not an FCC one: what resolves a tie when a yard-specific and an all-yards
  template both match? **(d)** FCC stores **both** an explicit
  parent/child link *and* an independent per-line `Sub-Item` visibility flag (Brian's follow-up
  the same day: the screen "doesn't display the line item and sub-item relationship very well",
  but "in the database this appears to me more clear, with parent/child relationship"). TCG has
  the parent link only and derives visibility from it — `quotation-pdf.service.ts` hides every
  child of an `isGroup` parent. Does a line need to be able to be a child *and* visible? **(e)** when a
  template changes, do existing quotations re-seed or stay a snapshot? **(f)** does the job type
  sit on the quotation as a whole or per resource row — FCC keys it per resource type, so one
  quote could in principle mix an *Hourly* crane with an *Hourly w/ Mob* one. **(g)** the
  anomalies Brian flagged on delivery (2026-09-04) — a 110 Ton All Terrain Crane requiring
  **Operator + Oiler**, a *Lift Plan* requiring a **Sales Admin**, a *Qualified Rigger and
  Signalman* requiring a **Rigger** — *"do we need to continue to do anything special with
  these?"* His question, for Joe. **(h)** ~~what a configuration with no job type means~~ — **answered
  by the same README, and it forbids the obvious reading**: *"No Job Type child row is retained as
  NULL / No Job Type Stored; do not automatically convert it to All Job Types."* **29 of the 75
  production configurations carry no job type.** The ERP's job-type slot is therefore nullable and
  NULL is a distinct value — what a NULL configuration should *do* when a quote is priced is still
  unanswered, and is now the live half of this. **(i)** the README says `OptionFlag_Raw` is
  preserved *"its business meaning was not assumed in this package"*, and every current row is
  `M` — while our seeder reads `OptFlag === 'M'` as `isRequired`. What does `M` mean?
- **Sources checked:** [fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md)
  — the three messages transcribed, including Brian's FCC table map (§5): the configuration hangs
  off `FMS_UNIT_TYPE_JOBTYPE_YARD.JobTypeYardID`, with job type, yard, equipment, employees and
  estimate lines as its children, `Item` = sub-item and `ParentEstimateID` = parent line;
  [mobilization-and-demobilization.md](mobilization-and-demobilization.md) — covers the mob/demob
  bundle and its sub-item behaviour but **not the template above it**, and its FR-8 "special case"
  claim is sharpened rather than contradicted; [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md)
  for the four-hour minimum that appears as the `Hourly` template's 4.00-hour default;
  [assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md) for the
  resource-type ↔ sub-category mapping. Built state: no job-type concept exists in
  `apps/api/prisma/schema.prisma`, `packages/shared` or `apps/web`
  (`Quotation.billingType` is a display-only `Rental`/`Parts` select, not this);
  `SubCategoryAssociatedResource` is the *Unit/People* equivalent but is keyed by parent
  sub-category alone; nothing seeds quotation resource rows from any template.
- **Blocked:** any spec that would seed quotation resources or automate mob/demob assembly;
  whether these FCC tables are in migration scope; whether `isIncluded`/`isGroup` need a
  per-line visibility flag beside them.
- **Owner:** Joe Schacatano / Ryan Adams (sales & quotation) for whether job type ships, what the
  job-type list is, and the (g) anomalies — Brian has explicitly routed those to Joe; Brian Petros
  for `Quantity2/3` and the `EmployeeRequirementScope` question.
- **Sourcing upgraded 2026-09-02 — the module owner asked for it directly.** In the sprint demo
  Joe Schacatano, unprompted and correcting Brian's "schedule types": *"you need to share with
  them the pictures of the **resource types**, which is how the quotes populate currently, because
  **that's how they should be populated on the quotes**. And the additional items like the riggers,
  we can add them specific to the job. We don't want that to populate."* That is the owner of
  sales and quotation stating the requirement — template-driven quote lines from the resource
  type, with job-specific additions made by hand. It does not answer the design sub-questions
  below, but it removes any doubt that the behaviour is wanted.
  [meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md) §2.
  Ehtesham put *"schedule types vs asset configurations"* on the 2026-09-03 agenda.
- **Extract status:** **delivered 2026-09-04** — `FCC_UNITS-ASSETS-ResourceTypes_20260902.xlsx`
  (prepared 2026-09-02), SharePoint *Project Repository → 2.1.1_DATA-MIGRATION → NexGenFMS_for_ERP*.
  **Its README sheet has been read and is transcribed in §7 of the source doc; the five data sheets
  have not been opened** and are not in the repo. The README answered (c) and the FCC half of (h);
  (a) the job-type list and (b) whether *Unit/People* varies by job type are now a group-and-compare
  away in `02_JobType_Yard` and `03_UnitPeople_Resources`. Production scale: 76 resource types,
  75 configurations, 328 equipment rows, 4 employee rows, 701 estimate lines (432 sub-items).
- **Update 2026-09-04 (Project Repository ingest):** four of the nine sub-questions move; none
  closes. **(a) The job-type list is now known** — FCC's `Maintain → Job Types` holds **11 codes,
  four with `Status` on**: `B` Bare, `H` Hourly, `S` Storage, `Z` Hourly w/ Mob (Contract, Monthly,
  Weekly, OCIP/CCIP, Prevailing Wage, PSA/PLA, Vacation switched off) — the same list on the quote
  deck and in the 2026-06-23 database ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) *Job
  Types and Quote Status codes*;
  [../payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md](../payroll/tcg-rawfms-staging-database/data/fcc-job-status-type-and-department-codes.md)).
  It is a user-maintained lookup with a Status flag, so tenant-configurable in FCC. **Not every
  resource type carries the same list**: `FMS_UNITTYPE_JOBTYPES` is a 42-row allow-list — `H` on 22
  unit types, `Z` on 18, `B` and `O` on one each — and **18 unit types carry both `H` and `Z`**
  ([../payroll/tcg-rawfms-staging-database/data/fcc-unittype-jobtype-allow-list.md](../payroll/tcg-rawfms-staging-database/data/fcc-unittype-jobtype-allow-list.md)).
  **(e)** The vendor's 2018 manual describes the template as a seed — it fires *"after the Type
  column is populated and tabbed out of"*, everything it inserts *"may be changed or deleted"*, and
  *"the same concept applies to the Schedule Jobs window"*
  ([fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md) §8.1); nothing
  describes re-seeding an existing quote, so FCC behaviour is snapshot-on-insert, and the template
  is not quote-only. **(f)** In FCC the job type sits in **both** places — `Job Type` is a field on
  the quote's Main tab (*Hourly* on the live quote) *and* the key of each resource type's
  configuration — and §8.4 of the same page shows the term carrying three meanings in FCC, so any
  ERP spec must say which it adopts. **(d)** `Sub-Item` has a third layer, a billing-code-level
  *Default as Sub-Item* (§8.2). Unchanged: (b) still needs `03_UnitPeople_Resources` opened; (g)
  still Joe's; (h) the NULL-configuration behaviour; (i) what `M` means. All of this is FCC as held,
  not a TCG decision on what the ERP adopts.

- **Update 2026-09-16 (Joe Schacatano, dedicated call).** The owner narrowed what the template seeds on the **quote**: its **estimate billing codes only**. The *Unit/People* half is a dispatch requirement and must not populate the quote ([../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md)). So the main question splits: estimate lines seed the quotation, and the Unit/People set seeds the job and dispatch side. (b) now matters for dispatch, not for quoting.
  - **(d) moves.** Joe (24:27) wants the mob/demob roll-up *"so that we're not showing 50 billing codes"*. He also wants (24:46) *"something on our billing codes to have the option of adding it all up to where it totals into our mob and demobs"*. That is a billing-code-level option, like FCC's *Default as Sub-Item* (§8.2 of the source doc), which TCG does not have.
  - The customer quote shows only the mob line, the demob line and the lines after demob. This confirms FR-1/2/6/7 of [mobilization-and-demobilization.md](mobilization-and-demobilization.md).
  - The lines after demob come from the template. Crew OT/DT and traffic control on quote OM-29537 were added by hand (26:03).
  - **Configurations are separate resource types.** Joe: *"after this job, we made separate ones for the different configurations"* (26:31; FCC ID 76 *360 Ton All Terrain w/Luffer*).
  - Ryan has built a spreadsheet mob/demob tool, and Joe offered to show it on a separate call. The mob/demob walkthrough is deferred to the week of 2026-09-28.

  Source: [../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md](../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md) §1, §3, §4.

- **Update 2026-10-17 (TCG-218 close-out) — (e) and (f): ticket-owner rulings exist; neither sub-question is closed.**
  - **(f).** Syed Haris (TCG-218 ticket owner, CodingCops) ruled that the Quotation Type — *Hourly* / *Hourly w/ Mob*, FCC's `H` / `Z` — is chosen **once per quotation** (*"q17: once per quote"*, 2026-10-08): [../decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md](../decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md) point 2, `reference`. TCG-218 shipped it that way (Linear TCG-218, merged by 2026-10-17). Joe Schacatano was **not** asked whether one quote may mix an hourly crane with a mob/demob crane — which is (f). Stays open with its owners, as that note itself says.
  - **(e).** [../decisions/2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md](../decisions/2026-10-16-a-quote-keeps-the-asset-configuration-it-went-out-with.md) (`reference`, ticket owner) decides that a change to a sub-category's **asset configuration** — which TCG-218 now uses to auto-fill quote lines — reaches only quotes not yet gone out: a quote keeps a snapshot from its first send / Mark as Won / conversion, never refreshed. **It does not answer (e)**: (1) (e) asks about FCC's job-type estimate template, which TCG does not have; (2) it does not decide whether a saved quote's existing lines are re-seeded when the configuration changes — that they are not today is a code finding recorded in TCG-218 spec §12 Q51, not a decision; (3) the owners named here were not asked. It is the nearest precedent for whoever answers (e).
  - **Status unchanged: open.**

## FCC estimate templates were already extracted — and the seeder flattened them to one FK

- **Status:** open
- **Asked:** 2026-09-03 — found while recording Brian Petros' FCC table map
  ([fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md) §5–6). Not a
  ticket question: no `SCRUM-###` covers estimate templates or this part of the seeder.
- **Question:** the FCC test extract already carried every table behind the Resource Type
  configuration, and the seeder discarded the structure. `FMS_UNIT_TYPE_ESTIMATE` — **564 rows** —
  is not inserted at all: `linked-seed-files.ts:385-400` reads `Quantity`, `MeasureCode`, `Rate`,
  `Amount`, `PrimaryEst`, `Status` and **never reads `JobTypeYardID`, `Item`, `ParentEstimateID`,
  `LineNumb` or `Comments`**, and `link-billing-codes.ts:225-241` then uses those rows only to
  order candidates before writing a single `BillingCode.subCategoryId`, first-wins. So: **is the
  flattening intended and permanent, or a first-pass shortcut to be undone once the ERP has
  somewhere to put a template?** And separately — `FMS_UNIT_TYPE_EQUIPMENT` (161 rows) and
  `FMS_UNIT_TYPE_EMPLOYEES` (117) were seeded onto `SubCategoryAssociatedResource` with
  **`JobTypeYardID` dropped on every row** (`fcc-seeder/docs/field-gaps.md:589,610`): if any
  resource type's two job types differ in *Unit/People*, that difference is already gone in a
  migrated tenant, and rows may have merged or collided. **Nobody has checked whether any do.**
- **Why it is not merely a migration detail:** it decides what the promised full extract has to
  contain, and it is the difference between "we need new data from the client" and "we need to
  stop throwing away the data we have". The columns are populated upstream and therefore
  recoverable — `field-gaps.md:630-650` records `Item` 564/564, `JobTypeYardID` 564/564, `LineNumb`
  564/564, `ParentEstimateID` **322/564** (57% of estimate lines are children), `Comments` 201/564.
- **Also unexplained, but smaller than it looked:** `Quantity2/3`, `Rate2/3`, `Amount2/3` are
  non-null on all 564 test-extract rows. The production README says the neighbouring `PrimaryEst`,
  `Multiplier`, `MeasureCode2` and `MeasureCode3` *"are not used"* by current active data, so these
  are probably zero-filled too — ask Brian, do not design around them. One consequence is already
  real: `link-billing-codes.ts:227` orders candidates by **`PrimaryEst`**, a field production data
  does not use, so the first-wins pick is effectively input order.
- **Sources checked:** `apps/api/fcc-seeder/docs/linked-tables-mapping.md:20-32`,
  `docs/seed-files-index.md:20,42-49`, `docs/fcc-unmapped-entities.md:30-40`,
  `docs/field-gaps.md:585-655`, `src/linked-seed-files.ts:385-400`,
  `src/lib/link-billing-codes.ts:225-241`;
  [meetings/2026-08-26-fcc-migration-client-brief.md](../meetings/2026-08-26-fcc-migration-client-brief.md):78,
  which already listed *"unit-type estimate templates"* among the things **extracted but with no
  TCG home** — this entry is that line, costed.
- **Two defects now provable, not just fidelity loss** (both from the production README's
  confirmed behaviours, §7 of the source doc): **(1)** a requirement expressed as a schedule type
  with no unit type — the README's named case is **Bare Rental**, *"Unit/People = Mobile Crane and
  Type is blank"* — is **silently skipped** at insert, because `linked-seed-files.ts:337` fills the
  association from `EquipUnitTypeID` alone and `seed-all.ts:1433` drops rows with no association.
  **(2)** `assocSeen` keys on `(parent, associated)` (`seed-all.ts:1439`), so one companion
  required by two job-type configurations of the same resource type collapses to **one row,
  first-wins**, taking whichever `isRequired` came first — 328 production equipment rows fold onto
  at most 76 sub-categories and nobody has counted the collisions.
- **Blocked:** any decision on whether a migrated tenant's associated resources need re-seeding.
  **No longer blocking the ask** — the full extract was delivered 2026-09-04
  (`FCC_UNITS-ASSETS-ResourceTypes_20260902.xlsx`); the open half is now whether the seeder is
  changed to preserve what that file proves is there.
- **Owner:** CodingCops (seeder) for the flattening and the collision check; TCG via Brian Petros
  for what `Quantity2/3` etc. are.
- **Update 2026-09-04 (Project Repository ingest):** the collision is now countable from the
  client's own database rather than the test extract. The 2026-06-23 FCC copy's
  `FMS_UNITTYPE_JOBTYPES` — printed in full at
  [../payroll/tcg-rawfms-staging-database/data/fcc-unittype-jobtype-allow-list.md](../payroll/tcg-rawfms-staging-database/data/fcc-unittype-jobtype-allow-list.md)
  — has 42 `(JobTypeYardID, JobTypeCode, UnitTypeID)` rows, and **18 unit types carry two
  configurations**, an `H` and a `Z` each (unit types 3, 4, 5, 6, 7, 8, 9, 20, 21, 22, 23, 28, 34,
  56, 63, 65, 67, 70). Every one of those 18 is a place where `assocSeen` keyed on `(parent,
  associated)` folds two job-type configurations into one row, first-wins. `FMS_UNIT_TYPE_ESTIMATE`
  and `FMS_UNIT_TYPE_EQUIPMENT` are **not** in that copy (`ddl/` has `FMS_UNIT_TYPES`,
  `FMS_UNIT_TYPE_DETAILS`, `FMS_UNITTYPE_JOBTYPES` only), so whether the two configurations actually
  differ in *Unit/People* still needs the delivered workbook's `03_UnitPeople_Resources` opened. The
  vendor manual adds that the same defaults fire on **Schedule Jobs**
  ([fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md) §8.1), so a
  flattened seed affects jobs, not only quotes. Whether the seeder is changed remains CodingCops';
  `Quantity2/3` remains Brian's.

## Quotation module defect audit (2026-09-01)

Defect findings from the end-to-end quotation audit. Full narrative, evidence
tags, dismissed claims and gate results live in
[`docs/quotation-module-audit-2026-09-01.md`](../../../docs/quotation-module-audit-2026-09-01.md).
Product-judgement items from the same audit are the four entries above this
heading ($50k threshold, valid-until boundary, price-list-on-edit, past-date
editability). Each entry below is a concrete code defect still open until fixed.

### Critical

## Q-01 — Public PDF endpoint has no authentication

- **Status:** **resolved 2026-09-22** — [decisions/2026-09-22-public-quotation-pdf-route-deleted.md](../decisions/2026-09-22-public-quotation-pdf-route-deleted.md).
  Answer: **delete the controller**, not gate it. Nothing consumed the route, and the
  customer receives the PDF as a MIME attachment on the delivery email. The status
  question ("should a DRAFT be downloadable") is answered in the same note as
  **SENT-or-later only**, recorded as the rule for any future public link even though
  the deletion makes it moot. Shipped on `fix/tcg-88-public-quotation-pdf-route` (TCG-88).
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

- **Status:** **resolved 2026-09-15** — fixed in `0a01900b0`, whose message says
  *"Answers gaps Q-02"*. **This entry was stale: it stayed `open` for a week after the
  code was fixed.** At HEAD the route carries no `@Public()` and takes
  `@GetCurrentUser`, and its docstring explains the reasoning: *"Signed in, so the
  quotation lookup is tenant-scoped — as a public route it had no tenant, and a quote
  number is only unique within one."* Dispositioned 2026-09-22 during TCG-88.
  **This staleness had a downstream cost:** the `register-2026-09-18` row that became
  TCG-88 names two routes as not tenant-scoped, and the `signed-document` half was
  already false when the register was written — see the correction note under Q-03.
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

- **Status:** **resolved for the routes it named, 2026-09-22** —
  [decisions/2026-09-22-public-quotation-pdf-route-deleted.md](../decisions/2026-09-22-public-quotation-pdf-route-deleted.md). The PDF route is
  deleted; `signed-document` was fixed in `0a01900b0` (see Q-02); the three remaining
  public signature routes resolve by **DocuSign envelope id**, globally unique, so they
  are tenant-correct with no tenant context. The decision note records the standing rule
  for any future public quotation link: resolve by a globally unique unguessable key,
  verify the secret before any DB read, and never rely on the `$extends` extension.
- ⚠️ **The underlying hazard is NOT fixed.** `findByCodeWithRelations` is still
  `findFirst({ where: { quoteNo } })` with no `tenantCompanyId`; TCG-88 removed its one
  public caller and corrected its JSDoc, nothing more. Any new `@Public()` route that
  reaches it reintroduces this. The guard is a source-level tripwire —
  `apps/api/src/presentation/public-route-allowlist.spec.ts` pins the set of `@Public()`
  routes and fails the build when it changes. **If you want this closed by construction**,
  that is a separate change: give the method a required `tenantCompanyId`.
- 📌 **Register correction owed.** `uat/register-2026-09-18.md` (and the Confluence
  "UAT Final Doc" row `id-181`) says *"Two public quote routes are not tenant-scoped"*.
  Only one was still open when that was written — the `signed-document` fix
  (`0a01900b0`, 15 Sep) is an ancestor of the register's own base commit. Left unedited
  here because the register is a dated snapshot; flagged for whoever maintains it.
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
- **Update 2026-09-04 (Project Repository ingest):** the premise *"PO lives on Project/Job"* is now
  contested by the client's own screens. FCC's quote Main tab has a **`PO No`** field and TCG
  annotated it *"This is the 'Customer PO number' — the PO Number that Customer give us"*
  ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §6 slide 4, and *Main tab, as populated*),
  while the 2017 vendor manual (§5), TCG's March 2026 lifecycle diagram (*"Log customer PO # —
  record on job / schedule tab"*,
  [quote-lifecycle-permits-and-purchase-orders.md](quote-lifecycle-permits-and-purchase-orders.md)
  §1) and the job screen's `PO(s)` panel
  ([fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §4) put it on the job.
  `FMS_JOB_MASTER.PoNumb` exists
  (`../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_JOB_MASTER_Raw.sql:14`); the 2026-06-23 copy
  holds no quote table to check the quote side. So "remove the phantom field" is not safe to assume
  — the product answer is the *Customer PO* entry above, and this finding should follow it.

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

## Who picks the approvers — the requester, or the role?

- **Status:** open
- **Asked:** 2026-09-02 — PR review of branch `feat/move-dropdowns-BE` (no ticket, no
  `.ai/aidlc/` folder, no `processed.log` row); tcg-scrum escalation.
- **Question:** The branch converts the approval-request approver checklist
  (`apps/web/src/features/quotation-approvals/components/approver-list.tsx`) to a
  **server-searched, page-at-a-time roster** with a debounced search box, replacing a call that
  loaded every eligible approver. Reviewing it surfaced a prior question the paging change only
  makes sharper: **is a requester supposed to choose a subset of approvers at all?** The two
  written sources describe a role-derived pool that is notified in full, not a hand-picked list:
  - **`SCRUM-573`** *Notify All Sales Managers for Approval* (Done, 2026-06-25, Umair Khan) —
    *"the system shall notify **all users assigned the Sales Manager role**, allowing **any**
    authorized manager to review and approve… ensure approval requests are **visible to all
    eligible approvers**."*
  - **`SCRUM-397`** *Quotation Approval System: Two Trigger Rules* (Done, 2026-05-08, Umair Khan)
    AC 3 — *"Approval notification email goes to **multiple managers so there is no
    single-person bottleneck if someone is sick**."*
  If the pool is the role and everyone in it is notified, a picker that lets a requester select
  three of eleven managers **reintroduces exactly the bottleneck `SCRUM-397` was written to
  prevent** — and searching and paging that picker is a second-order question that only exists
  because the picker does. Two parts: (a) does the requester choose approvers, or does the role
  define them? (b) if the requester does choose, **what did that decision supersede in
  `SCRUM-573`/`SCRUM-397`, and where is it written?**
- **Sources checked:** **Vault — nothing names an approver or an approver-selection step.**
  `INDEX.md`; [quotations-INDEX.md](quotations-INDEX.md) and all four candidates;
  [quotation-flow-process.md](quotation-flow-process.md) steps 18–20 — *"Check whether internal
  approval is required… **Manager** reviews the quotation… Approve / Reject / Request changes"* —
  a single unnamed manager, **no selection step at any point in the 27 steps**;
  [../assets/user-story-and-tasks.md](../assets/user-story-and-tasks.md) (the only
  acceptance-criteria-level quotation source — covers send, customer approval, print and delivery
  format, **not internal approval**); `../decisions/` (24 notes, none on approvers). Grep across
  `quotations/` content files for `approver` / `eligible approver` — **no matches outside this
  register.** Jira: `SCRUM-574`, `SCRUM-658`, `SCRUM-822` touch approval permissions, emails and
  button colour; none introduces approver selection.
- **Note:** this is adjacent to but distinct from **Q-20** above (*Approver pool includes
  inactive / invite-only users*). Q-20 asks who may be **in** the pool; this asks whether a human
  **narrows** it. Answering Q-20 alone leaves the picker's existence unexplained, and if (a) comes
  back "the role defines them" then Q-20's fix changes shape entirely.
- **Blocked:** sign-off of `feat/move-dropdowns-BE`'s approver changes as product-correct.
  Nothing ships broken — the paged roster works.
- **Owner:** Brian Petros or Mohsin Ali — whoever owns the quotation approval chain; the two
  Done tickets are Umair Khan's write-up of it.
- **Update 2026-09-04 (Project Repository ingest):** the client's own process documents name a
  **role**, never a picker, and the one recorded design conversation contradicts itself. Sales OS:
  *"Final pricing approval remains with the salesperson/manager under the approval matrix"*
  ([sales-operating-system/03-sales-coordinator-operations-manual.md](sales-operating-system/03-sales-coordinator-operations-manual.md)
  §2); discounts escalate to *"Salesperson / Sales Manager"* (§7); the Commercial Decision Form
  records a *"named approver"* after the fact
  ([sales-operating-system/05-forms-and-records-matrix.md](sales-operating-system/05-forms-and-records-matrix.md)
  §7); and the *approval matrix* itself is missing from the drop, with *"confirm approval
  thresholds"* listed as undone
  ([sales-operating-system/01-operating-system-architecture.md](sales-operating-system/01-operating-system-architecture.md)
  §12). The review log's May extraction says *"notifications to designated managers/executives ·
  multiple approvers, so absences do not block sales"* ([../erp-review-log.md](../erp-review-log.md)
  → *Quote approval*). In the [2026-06-17 sprint
  review](../meetings/transcripts/2026-06-17-erp-sprint-review.md) (48:37–50:36) Ehtesham first said
  *"Nobody will be able to select who is reviewing. We are going to automatically pick"*, then
  *"they can select any particular sales manager"*; ans.nisar proposed notifying **all** managers;
  Melissa: *"we only have one right now."* No TCG statement chooses. (a) and (b) still need Brian or
  Mohsin.

## Was the New Customer Packet gate on quotation send meant to be retired, and should the toggle default on only for new customers?

- **Status:** open
- **Asked:** 2026-09-07 — review of branch `feat/customer-billing-pre-labor-forms` (craneguys-platform
  PR #490 / `dacf6dc1`). **Not a ticket question:** the branch carries no `SCRUM-###`, no
  `.ai/aidlc/SCRUM-###/` folder (Path C `processed.log` row added 2026-09-08).
- **Question:** the branch removes the `customerPreQuoteComplete` prop from the whole send path
  (`send-quotation-modal.tsx`, `signature-status-panel.tsx`, `signature-status-panel.view.tsx`,
  `detail-left-panel.tsx`) along with `QuotationCustomer.preQuoteDataCompletedAt`. The prop was
  already inert on `main` — `formsToggleLocked` is a hardcoded `const … = false`, so the customer's
  completion state has locked nothing for some time; the branch deletes the dead wiring, not a live
  gate. Two things still need a person: (a) was the lock *intended* to be retired, or was
  `formsToggleLocked = false` a temporary stub that was never wired back up and has now been made
  unrecoverable? (b) separately, `usePreQuoteFormsSelection` defaults the "Include New Customer
  Packet" toggle **ON for every customer**, new or existing, while the only written account of the
  feature says it should be automatic **only when the customer is new**.
- **Sources checked:** [INDEX.md](INDEX.md), [quotations-INDEX.md](quotations-INDEX.md) and all four
  of its candidates; this register; [../decisions/](../decisions/) (nothing on send gating).
  The only account of the behaviour is
  [../meetings/transcripts/2026-07-29-erp-review-dispatch-das-update.md](../meetings/transcripts/2026-07-29-erp-review-dispatch-das-update.md)
  L68 — `ehtesham.anwar` (**CodingCops**, describing his own build): *"If it's a new customer,
  automatically it's going to be turned on, and it's going to include a new customer packet. And
  also if somebody wants, they can just check job and labor compliance information request form as
  well… **And if we don't want that, even if it's a new customer, we can just turn it off.**"*
  `status: reference`, vendor voice, unadjudicated — but it describes a **default-on, always
  overridable** toggle, i.e. no hard lock, which is consistent with the prop's removal and
  inconsistent with the unconditional default. Earlier, weaker corroboration that the packet should
  ride along with a new customer: [../meetings/transcripts/2026-03-26-tcg-cc-product-sync-demo.md](../meetings/transcripts/2026-03-26-tcg-cc-product-sync-demo.md)
  L437 (Melissa McNutt) and [../meetings/transcripts/2026-06-25-cc-tcg-erp-system.md](../meetings/transcripts/2026-06-25-cc-tcg-erp-system.md)
  L238–243 (Ryan Adams asks whether the packet should go out on customer create; answered by the
  vendor, not by TCG). Jira could **not** be checked — the MCP server returns `403 Tenant is
  restricted: suspended-payment`.
- **Note:** (a) is low risk — the prop removal matches the only written source. (b) is a live
  behavioural divergence from that same source and is answerable in one line.
- **Blocked:** nothing hard; the packet's own content is open in
  [../customers/gaps.md](../customers/gaps.md) → *Billing Information and Pre Labor Form tabs*.
- **Owner:** Ryan Adams / Melissa McNutt (sales send behaviour and packet policy).
- **Update (2026-09-12, tcg-scrum re-sweep for the PR review of the same branch):** the section is
  now a **master "Include Customer Forms" toggle** gating a **Pre Labor Form** checkbox
  (`send-quotation-modal.use-forms-selection.ts`, `send-quotation-modal.parts.tsx`
  `PreQuoteFormsSection`), not two independent checkboxes. Three separable points, and only one is
  still (b):
  - **Pre Labor Form defaults OFF** — **sourced**, weakly, by the same 2026-07-29 transcript L68
    this entry already cites: *"if somebody wants, they can just **check** job and labor compliance
    information request form as well"*, i.e. opt-in. Vendor voice, `status: reference`. Not a new
    question.
  - **The master toggle defaults ON unconditionally** — this is **(b), unchanged**. The rename from
    "Include New Customer Packet" to "Include Customer Forms" does not alter the divergence: the
    only written account still says automatic **only when the customer is new**.
  - **The section-title rename itself** follows the staff-facing/customer-facing asymmetry set by
    [../decisions/2026-09-07-pre-labor-pdf-and-structured-tabs-complementary.md](../decisions/2026-09-07-pre-labor-pdf-and-structured-tabs-complementary.md)
    → *Consequence already applied*, which authorised the two **checkbox labels**. Extending it to
    the section heading is consistent with that note and is not treated here as a new question.

## Pointer — cascading resource picker completeness

The quotation Resources tab is the largest consumer of the cascading resource picker, whose
capped browse state is open in
[../assets/gaps.md](../assets/gaps.md) → *The cascading resource picker may now show an
incomplete tree — is that acceptable?* (2026-09-02). Answered there, not here.

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

## The signing email should come from the salesperson, not from DocuSign

- **Status:** open
- **Asked:** 2026-09-02 — Joe Schacatano, in the sprint demo
  ([meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md) §1;
  transcript 15:46–17:50).
- **Question:** *"Is that the only option? … I'm not a fan of DocuSign. It's not us, it's not our
  voice. Whereas if it's an e-mail from the person, the salesperson, yet it has the digital
  signature capability."* Ehtesham offered two answers in the call: **(a)** before the first scope
  closes, integrate the salesperson's **Outlook** so the system sends from their own address —
  Joe said yes to this; **(b)** after it, a **customer portal** where the quotation, the
  first-time-customer packet and the signature all live, which is *"already planned after the
  first scope."* Neither is specified. What is owed: does (a) mean per-user OAuth to Microsoft
  365 and sending as the individual, or a from-name/reply-to change on the existing
  `support@craneguys.com` path — and does DocuSign remain the signing rail underneath either?
- **Sources checked:** the DocuSign envelope path as built (`apps/api/src/usecase/docusign/`,
  branded email + webhook); [*Company identity on customer-facing email*](#company-identity-on-customer-facing-email--see-admin)
  above, which is the tenant-identity half of the same surface and points at
  [../admin/gaps.md](../admin/gaps.md); [quotation-flow-process.md](quotation-flow-process.md)
  steps 1–27, which name DocuSign as the mechanism and say nothing about the sender.
- **Note:** this is a *presentation* objection, not a signing-technology one — Joe's own summary
  was *"everything else that you guys have is perfect."* Solving it with a from-address change is
  cheap; solving it with a portal is a scope item. Do not conflate them.
- **Owner:** Joe Schacatano (accepted the Outlook answer in the call); CodingCops for which
  mechanism, and Patrick for Microsoft 365 permissions if it is per-user OAuth.
- **Update 2026-09-04 (Project Repository ingest):** context, no mechanism. The objection has a
  legacy root: FCC's DocuSign invite goes out *"from an administrator controlled email address"*
  (vendor manual, [fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §4), so Joe has never had a
  signing email from the salesperson. Against that, the printed quote already carries the
  **salesperson's own cell and email** in its Customer Information block
  ([quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §8); TCG's Sales OS names
  **Outlook** as the system of record for customer correspondence and approvals
  ([sales-operating-system/01-operating-system-architecture.md](sales-operating-system/01-operating-system-architecture.md)
  §9;
  [sales-operating-system/03-sales-coordinator-operations-manual.md](sales-operating-system/03-sales-coordinator-operations-manual.md)
  §3); and its *Quote Sent* template fixes what the covering email must contain — quote number,
  scope, exclusions, expiration, next steps, required customer forms
  ([sales-operating-system/05-forms-and-records-matrix.md](sales-operating-system/05-forms-and-records-matrix.md)
  §8). The March 2026 lifecycle diagram says only *"Submit to customer — digital signature via
  email"*
  ([quote-lifecycle-permits-and-purchase-orders.md](quote-lifecycle-permits-and-purchase-orders.md)
  §1). Nothing in the drop says per-user Microsoft 365 sending vs a from-name / reply-to change, or
  whether DocuSign stays underneath. Still Joe's and CodingCops'.

- **Update 2026-09-17 (2026-09-15 ERP live demo 01, [../meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md](../meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md) §4–§5):**
  Joe raised it again (57:16), now as **retiring DocuSign altogether** — *"I would like to get away
  from DocuSign completely… I want it to be personal"*; *"We can get rid of DocuSign. We're not paying
  a subscription on it"* — **self-labelled "just my opinion from the salesperson"**, so not a
  decision. Ryan Adams: *"I think you nailed it"* (58:52). As built on 2026-09-15, *send quotation to
  customer* offers **send via DocuSign** or **send via e-mail**, and the e-mail path has **no
  electronic signature** (Ehtesham 57:47). Brian suggested a later *send through the portal* option
  (57:59). Ehtesham (59:04–59:22): *"we are going to get rid of DocuSign. We have already discussed
  and finalized"* a **customer portal** with electronic signature or email reply and **one-time
  customer credentials** — no decision note, ticket or scope in the vault records that finalisation.
  Ryan (59:39) wants to show CodingCops a platform he uses as a model (the name did not transcribe);
  Joe will schedule a separate call. **New, same surface — redlines** (Ryan 54:21–57:14): when a
  customer redlines the DocuSign contract and terms are agreed by email, where does the revised
  contract go so **Accounting can see the governing terms**? Answered only with attachments /
  internal change request; nothing marks a redlined agreement as superseding the signed quote. The
  entry now asks: **(i)** is DocuSign retired for in-house portal signing, and when; **(ii)** until
  then, does *send via e-mail* need a signing path; **(iii)** where does a redlined, email-agreed
  contract live, and how does accounting know it governs? Owner unchanged, plus Ryan Adams for (iii).

## Billing-code and price-list rules the E2E suite asserts with no written source — PR #488

- **Status:** open
- **Asked:** 2026-09-07 — raised reviewing **PR #488** (`qa-automation-employees`). The specs live
  under `qa-automation/e2e/specs/accounting/` (`billing-code-surcharge.spec.ts`,
  `billing-code-pricing.spec.ts`, `billing-code-lifecycle.spec.ts`, `billing-code-validation.spec.ts`,
  `price-list-pricing.spec.ts`, `price-list-lifecycle.spec.ts`, `price-list-references.spec.ts`,
  `price-list-validation.spec.ts`, `price-list-items.spec.ts`) but the questions are **quotations'** —
  [../accounting/INDEX.md](../accounting/INDEX.md) routes billing codes and price lists here, per
  [../STRUCTURE.md](../STRUCTURE.md). The specs assert rules **reverse-engineered from the running
  build** (*"verified against the live API on 2026-09-07"* — verified against the code, not against
  intent). Merging freezes current behaviour as expected behaviour.
- **Question:** seven rules, each answerable in a line. **(a)** Is the surcharge percentage bounded
  to **−100..100** — and are negative surcharges intended at all? **(b)** Do only **ACTIVE** billing
  codes price a row, with DRAFT/archived yielding no rate or zero? **(c)** When **two ACTIVE billing
  codes** sit on one sub-category, which wins — the specs accept **either** rate, so the build is
  non-deterministic; is that acceptable, or is a tie-break required? **(d)** Does an **archived**
  price list stop overriding while an **INACTIVE** one still prices? **(e)** Are **discount** and
  **price hike** mutually exclusive, given the UI enforces it and the API applies both? **(f)** Is
  the customer↔price-list binding by **name string** — so renaming a list migrates its customers but
  orphans quotations? **(g)** Does an archived list's **name become reusable**, with restore then
  refused?
- **Sources checked:** **None of the seven is written.** **(a)** no bound, sign rule or precision
  for the surcharge percentage appears anywhere — not in
  [../decisions/2026-09-02-one-surcharge-per-quote.md](../decisions/2026-09-02-one-surcharge-per-quote.md),
  and not in [fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md):80-92, which
  transcribes FCC's **entire** import validation contract (18 patterns) and contains **no percentage
  range at all**. **(b)** billing-code status exists but its **pricing effect is unwritten**: FCC's
  contract is *"code · description · status (A/P) · UOM"* (same file :89) with the `Data List`
  vocabulary *"Active `A` / Inactive `T`"* (:107), and the only status behaviour recorded anywhere is
  **display** — *"Inactive billing codes render in red"*
  ([../dispatch/fcc-nexgen-dispatch-guide.md](../dispatch/fcc-nexgen-dispatch-guide.md):458). The
  word **DRAFT never appears for a billing code**; the only draft-status ask is for **price lists**,
  in a meeting summary — *"add status states for price lists (draft/in progress/active)"*
  ([../meetings/summaries/2026-03-12-sales-pricing-in-fcc.md](../meetings/summaries/2026-03-12-sales-pricing-in-fcc.md):56)
  — with no pricing semantics. **(c)** the client wishlist covers only the **zero** case — *"rates
  tied to billing codes, typically by subcategory · **flag subcategories with no billing code**"*
  ([../erp-review-log.md](../erp-review-log.md):225-227, `status: unverified`) — never the two case.
  This register already holds the same non-determinism as a **defect**, not a rule: [*FCC estimate
  templates were already extracted — and the seeder flattened them to one
  FK*](#fcc-estimate-templates-were-already-extracted--and-the-seeder-flattened-them-to-one-fk)
  records *"`link-billing-codes.ts:225-241` … **first-wins**"* ordered by *"`PrimaryEst`, a field
  production data does not use, so the first-wins pick is effectively input order."* **A spec that
  accepts either rate ratifies that defect.** **(d)** and **(g)** are **explicitly unsettled** by
  [../decisions/2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md)
  §*What this does NOT settle* — *"what an archived record still participates in (search, reports,
  references from live records)"* and *"who may unarchive"*. FCC price lists carry Active/Inactive
  only, with **no behaviour attached** ([fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md):105,
  :237-245); no vault file combines "price list" with "archiv*". **(e)** the two appear only as a
  **pair**, never as an exclusion — *"price list discounts and price hikes apply only to items in
  that list"* ([../erp-review-log.md](../erp-review-log.md):229). **(f)** the binding is described
  only as *"the price list is a field on the customer record"*
  ([fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md):202-204) — **no key
  type**. The one name-string-orphaning precedent is a **different entity** and must not be
  transferred: [../decisions/2026-09-02-sub-category-names-tenant-unique.md](../decisions/2026-09-02-sub-category-names-tenant-unique.md):65-67
  is `Plan.craneCategory` → `SubCategory`. On **(g)** the same decision's nearest precedent points
  the **opposite** way — an archived sub-category *"keeps its name **reserved forever** … That is
  shipped behaviour, not a ratified rule."*
- **On the conflict flag — the premise needs correcting.** No conflict stub names
  [billing-code-and-price-list.md](billing-code-and-price-list.md); [quotations-INDEX.md](quotations-INDEX.md)
  lists four other candidates and not this file, and it is not among the nine open conflicts in
  [../INDEX.md](../INDEX.md):52-62. The file is conflict-**marked in its own frontmatter**, against
  exactly one document: `conflicts_with: [meetings/2026-06-26-discussion-points-with-tcg-team.md]`
  — this file 3.4 KB / `updated: 2026-09-04` vs that one 1.5 KB / `updated: 2026-06-25`, **neither
  `verified`**. The overlap is **literal duplication of the yards question**, *"Should we make
  billing code and price list specific to yards"*
  ([../customers/customers-INDEX.md](../customers/customers-INDEX.md):39-40), which is **half
  answered** (*"Billing Codes per Yard: Need to have ability to have separate Billing Codes per
  Yard"*; *"Nothing on the slides says anything about price lists per yard"*, :52-59). **So the
  conflict does not bear on any of (a)–(g)** — the file is a 3.4 KB punch list whose only pricing
  content is *"Add billing code type CRUD"* and *"Discount toggle should not be red"*. Cite it for
  the yard question, not for these.
- **Related, already open — do not duplicate:** (f) is adjacent to [*Should editing a quotation
  adopt the customer's current price list?*](#should-editing-a-quotation-adopt-the-customers-current-price-list)
  — that one asks whether an edit **re-prices**, this one asks what the binding is **keyed on**;
  answer the key first. The surcharge **model** is settled and is not reopened here:
  [../decisions/2026-09-02-one-surcharge-per-quote.md](../decisions/2026-09-02-one-surcharge-per-quote.md)
  (`status: verified`) fixes one rate per quote, price list replacing the tenant-wide default, with
  per-line **membership** via `BillingCode.applySurcharge`. Only the **bound** in (a) is open.
- **Blocked:** merging PR #488's accounting specs as a behavioural contract. (c) additionally blocks
  a deterministic seeder; (f) blocks any price-list rename being safe.
- **Owner:** product team — Melissa McNutt and Joe Schacatano (they set the surcharge and price-list
  rules on 2026-05-05 and 2026-03-12); Ryan Adams for price-list administration.

## The customer PO arrives before the job exists — may the quotation capture it?

- **Status:** open
- **Asked:** 2026-09-09 — PR review of `fix/quotation-permits-plans` (no ticket, no `processed.log` row, no ticket folder). Split out of *"Customer PO" on the quotation — which of three things does it mean?* above, whose location half is answered.
- **Question:** one line answers it. Brian Petros's own diagram sequences the customer PO as **`Customer approved? → Log customer PO # → Convert to job`** — the number arrives **before the job record exists** — while the same decision says it **lives on the job / schedule tab and is not a quotation field**. So: should the ERP **capture** the number on the quotation at approval and copy it to `Job.poNumber` on convert (the branch's answer), or should capture wait until the job exists, with the quote-approval moment being only when the customer *hands it over*, not when the system stores it?
- **Sources checked:** [../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md](../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md) — the flow diagram at §*Where each PO sits in the flow* (`Log customer PO # (record on job / schedule tab)` sits **above** `Convert to job`), against :59 and :111 (*"It is **not** a quotation field"*, *"Where the customer PO lives | **Job / schedule tab**"*); its :168-170 records the field as unbuilt on both sides. [../vendors-agencies/purchase-orders-fcc/commissioning-email-thread.md](../vendors-agencies/purchase-orders-fcc/commissioning-email-thread.md):69-71 — Melissa McNutt, 4 Dec 2025, same placement, no timing statement. [quote-lifecycle-permits-and-purchase-orders.md](quote-lifecycle-permits-and-purchase-orders.md):181 — the entity-hierarchy diagram's `PO Number` pill **on the Quote**, and :116, :132 — the DB-schema diagram's `CUSTOMER_PO.job_id`, i.e. TCG's own two March 2026 diagrams disagree on exactly this. [fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §6 — FCC does carry a `PO No` field on the **quote Main tab**, annotated by TCG *"This is the 'Customer PO number' — the PO Number that Customer give us"*, so the incumbent captures at quote stage **and** on the job. [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §8 — the printed quote's acceptance block is *"Date · Print · Sign · PO Number"*, i.e. the customer writes the number **on the quote** when accepting.
- **Note:** the two readings are not equivalent for reporting. Capture-on-quote makes the number available on a **lost** quote and on a quote that never converts; capture-on-job does not. Nothing addresses which is wanted. Note also that the branch writes only `Job.poNumber` — `Project.poNumber` stays unwritten, so the project level of the same decision is still unbuilt whichever way this goes.
- **Blocked:** whether `fix/quotation-permits-plans` ships its `Quotation.customerPo` column as-is. Nothing else — `Job.poNumber` capture is correct on either reading.
- **Owner:** Brian Petros — he drew the diagram and made the 2026-09-05 call; this is the one ambiguity inside it.

## Is "Company" on a quotation the tenant's own name, or a value the quote carries?

- **Status:** open
- **Asked:** 2026-09-11 — PR review of `feat/table-timestamps` (PR 524; no ticket, no ticket folder; `.ai/aidlc/processed.log` row written retroactively 2026-09-10). tcg-scrum escalation.
- **Question:** the create, edit and detail screens show a read-only **Company** field. It was the literal string `The Crane Guys, LLC`; the branch binds it to the signed-in user's live `TenantCompany.name`, read from `GET /users/me`, and persists nothing. Two things are unsettled, each answerable in a line. **(a) Is Company a display of the tenant, or a field of the quote?** In FCC it is the second: the quote's Main tab opens with *"Begin by verifying **Company**, **Dept** and **Yard**"*, a user has a **Default Company** plus a **My Companies** set, and the quote counter is company-level — so a quote is *raised under* a company that the user may change. Our `Quotation` model has no company column at all and no department; it persists `yard` as a plain string, i.e. one of FCC's three verify-fields is on the quote and the other two are not. **(b) If it is a display, should it be the company's name *now* or its name *when the quote was raised*?** As built, renaming the tenant silently rewrites the Company line on every historical quote and on its detail page, including quotes already signed by a customer.
- **Sources checked:** **Nothing states the intended behaviour of this field.** [quotations-INDEX.md](quotations-INDEX.md) — the four-way conflict stub; none of the four candidates mentions Company, and the stub itself records that *"nothing here defines quotation data structure"*. [quotation-flow-process.md](quotation-flow-process.md), [quotations.md](quotations.md), [quotation.md](quotation.md), [tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md), [../assets/user-story-and-tasks.md](../assets/user-story-and-tasks.md) — "company" appears only as the *customer's* company name and in PDF file naming (`OM-12345_Company.pdf`), never as a quote field. [fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §2 *Main tab* — the verify-Company-Dept-Yard instruction; §*Quote Lookup (slide 2)* — the `OM-` prefix is the department and the number is the **company-level** counter. [../admin/fcc-nexgen-administration-and-security.md](../admin/fcc-nexgen-administration-and-security.md) §4 *`Admin > Users`* — Default Company / My Companies; §*Company (slides 2–9)* — company `CG`, *The Crane Guys, LLC*, with the Quote No counter held at company level; §*GL Accounts (slides 19–21)* — a **second company, *The Repair Guys***, whose status as a full company the deck explicitly leaves unresolved. `../decisions/` (50 notes — none on company identity or on quotation header fields). `.ai/aidlc/` — no ticket, no spec. Every source above is `status: unverified`.
- **Related, do not answer separately:** [../admin/gaps.md#whose-company-identity-do-customer-facing-emails-carry-when-a-deployment-sets-no-env](../admin/gaps.md#whose-company-identity-do-customer-facing-emails-carry-when-a-deployment-sets-no-env) names the same unstated assumption — whether company identity is per-tenant data or per-deployment config, and whether the platform is single- or multi-tenant in practice. That entry's 2026-09-04 update records FCC as **per-company in data, single-company in deployment**, which is exactly the ambiguity (a) turns on. Whoever answers one should answer both.
- **Note:** the branch's change is strictly better than what it replaces regardless of the answer — the hardcode meant any second tenant saw *The Crane Guys, LLC* on its own quotes, which is wrong rather than merely unspecified. This is not a reason to hold the merge. It is a reason not to treat the new behaviour as settled: if (a) comes back "a field of the quote", the read-only tenant binding has to become a persisted, selectable column, and the same screens on **mobile** still carry the literal string (`components/sales/quote-detail-main-tab.tsx`, `components/sales/quote-create-main-info.tsx`, asserted by `app/(sales)/quotes/create.test.tsx`), so the two surfaces now disagree.
- **Blocked:** nothing before merge. Blocks mobile being brought into line, and blocks any second tenant being onboarded with confidence that its quotes read correctly.
- **Owner:** product team — Ehtesham Anwar for the single- vs multi-tenant half (he owns it on the admin entry above), Brian Petros or Ryan Adams for whether a quote is raised under a company the salesperson picks.
## Branch fix/das-fixes — archive gate, rate-error precedence, discount and price-hike footer rows

- **Status:** open, for (b) and (d) only. (a) and the on-screen half of (c) were resolved 2026-09-11; the printed-quote half of (c) was resolved 2026-10-17 — see decisions/2026-10-17-customer-documents-show-no-discount-every-line-net.md. See the next two bullets.
- **Resolved in part 2026-09-11, by Fouzan Shakil (CodingCops, `reference`, not a TCG sign-off):**
  - **(a).** Settled by [../decisions/2026-09-11-quotation-archive-blocked-by-in-flight-jobs.md](../decisions/2026-09-11-quotation-archive-blocked-by-in-flight-jobs.md). Archive is blocked while any linked job is `ACTIVE` or `ON_HOLD`. It is allowed once every linked job is `COMPLETED`, `INVOICED` or `CANCELLED`, which covers the whole `JobStatus` enum. No other blocker was named, including a linked project.
  - **(c), on-screen half.** Settled by [../decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md](../decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md):
    - Discount and Price Hike footer rows work exactly like the Fuel & Insurance Surcharge row, on create/edit and on detail.
    - Each resource row's Amount is the amount before discount, hike and surcharge: qty × rate, or for a Mob/Demob group parent, the sum of its included children.
    - The footer rows carry the adjustment money, so the Amount column sums to the Total.
  - **Still open:**
    - (b).
    - ~~Whether the **printed** quote carries the same rows (the second question of (c)).~~ Resolved 2026-10-17, next bullet.
    - (d), below.
- **Resolved in part 2026-10-17 — the printed-quote half of (c):** no, the customer's copy carries neither row. **Discount row — Joe Schacatano** (TCG VP of Sales, an owner named for (c)), written Teams reply, `verified`: *"Discount kept internal. We don't want a discount line to show to the customer."* **Price Hike row — Syed Haris** (TCG-218 ticket owner, `reference`, not asked of Joe): price hikes are treated like discounts, every line prints net of both, and the Surcharge row stays. Internal screens keep the on-screen rules above. See [../decisions/2026-10-17-customer-documents-show-no-discount-every-line-net.md](../decisions/2026-10-17-customer-documents-show-no-discount-every-line-net.md) rules 2–4 and 7.
- **(d), added 2026-09-11 and left open by the archive decision.** Should archiving a **WON** quotation remove its value from the WON revenue KPIs and from the customer's revenue figure, or should both keep counting it? As built, it removes it from the customer's figure. `apps/api/src/service/quotations/quotations.repository.ts` `findManyForCustomerMetrics` filters `archivedAt: null`. The field it feeds is named `revenueYtd` but holds all-time won revenue (`apps/api/src/usecase/customers/customer-quotation-metrics.ts`:9). The other WON-revenue KPIs were not checked. Blocks: nothing hard, only reporting correctness once won quotations start being archived. Owner: as for (a).
- **Asked:** 2026-09-11 — PR review of branch `fix/das-fixes` (no ticket, no `.ai/aidlc/` folder); tcg-scrum escalation. Commits `b81f1b0b5`, `48d93f9f6`, `c11bba5c2`.
- **Question:** three parts, each answerable in a line. **(a)** May a quotation be archived while it still has a linked project, or linked jobs that are not `ACTIVE`? The branch now blocks archive **only** on `ACTIVE` jobs (`archive-reference.service.ts`). A linked project, or a job in any other state, no longer blocks. **(b)** When a resource line has no billing code, should its Rate cell also show *"Rate must be greater than 0"*, or only *"Billing Code missing."*? The branch hides the rate message in that case. The row cannot be saved either way. **(c)** Should quote-level **Discount** and **Price Hike** rows sit in the Resources footer beside the Fuel & Insurance Surcharge row, on create/edit and on the detail tab? Each is summed from the lines and shows a shared percentage when the lines agree. If yes, should the printed quote carry the same rows?
- **Sources checked:** **(a)** [../decisions/2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md) (`reference`, Fouzan Shakil) sets no archive preconditions. It leaves open *"what an archived record still participates in (search, reports, references from live records)"* (:61-63). This register's *Q-11* (who may archive) and [projects-jobs/gaps.md → *Job COMPLETED does not close Project / quotation*](../projects-jobs/gaps.md#job-completed-does-not-close-project--quotation) are nearby, but neither covers the gate. **(b)** [../decisions/2026-08-31-quotation-resource-rate-whole-dollars.md](../decisions/2026-08-31-quotation-resource-rate-whole-dollars.md) (`reference`, Jahanzaib Nadeem) fixes the two rate messages: `<= 0` gets *greater than 0*, cents get *whole number*. It says nothing about which message wins when the billing code is missing. The other half of the same commit is not asked here because it **matches** that decision: a sub-$1 catalog rate is now kept rather than truncated to 0, so it trips the cents message. Nearest talk (`reference`): ans.nisar, `../meetings/transcripts/2026-05-05-tcg-erp-system.md`:469, on a line with no billing code, *"mark it as red and just tell them there's no pricing attached to it"*. **(c)** [../decisions/2026-09-02-one-surcharge-per-quote.md](../decisions/2026-09-02-one-surcharge-per-quote.md) (`verified`, Melissa McNutt) settles one named surcharge row (:24) and says nothing about discount or hike rows. The real TCG quote in [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md):50-52 (`unverified`) prints Subtotal, surcharge and Estimate Total, with no discount or hike row. Discount and hike appear as price-list features in `../meetings/transcripts/2026-05-05-tcg-erp-system.md`:151 (`reference`) and [../erp-review-log.md](../erp-review-log.md):231, :250 (AI-generated sheet, `unverified`). None of these puts them in the table footer. Jira not checked (no Jira MCP in this session).
- **Related, already open — do not duplicate:** [*Per-row surcharge now has no UI on create/edit, and "Final Amount" means two different numbers*](#per-row-surcharge-now-has-no-ui-on-createedit-and-final-amount-means-two-different-numbers) concerns the same footer, one row over. [*Billing-code and price-list rules… PR #488*](#billing-code-and-price-list-rules-the-e2e-suite-asserts-with-no-written-source--pr-488) (e) asks whether discount and hike are mutually exclusive, which decides whether both rows can be non-zero at once.
- **Blocked:** nothing hard, since each is a small reversible guard or UI change. (a) is the one with data consequences: an archived quotation's project and non-active jobs keep pointing at it.
- **Owner:** Fouzan Shakil (the archive convention) with Ryan Adams / Joe Schacatano for (a); Jahanzaib Nadeem, author of the rate decision, for (b); Ryan Adams / Joe Schacatano for (c).

## Is the job walk part of the quotation record, and if so, is it on create as well as edit?

- **Status:** open
- **Asked:** 2026-09-12 — PR review of uncommitted `apps/web` changes (overlay handle `abdulrehmanbcsf11`, git user `devmohsinakram`; no ticket, no `processed.log` row, no ticket folder; author and motive unknown, no client or PM cited). tcg-scrum escalation.
- **Question:** two parts, each answerable in a line. **(a)** Should a job walk be a section **of the quotation** (a tab on its view and edit screens), or a separate record that feeds the quote — filling in what it can, as Ryan Adams described on 2026-06-25 — or both? **(b)** If it is on the quote, does the **create** wizard carry it too? The change adds a **Job Walk** tab to the view page and a sixth **Job Walk** step to the edit wizard, both between Additional Information and Attachments, and leaves create at five steps (`apps/web/src/features/quotations/views/create-quotation-wizard-nav.tsx` `CREATE_WIZARD_STEPS` vs `EDIT_WIZARD_STEPS`; `view-quotation.tsx`:157; `utils/activity-tab.ts`:18; `create-quotation-save.ts`:138). Both render only `EmptyState title="Coming Soon!!"`.
- **Sources checked:** **Nothing written puts a job walk on the quotation record — as a tab or otherwise — or leaves it off create.** [quotations-INDEX.md](quotations-INDEX.md) — four unverified, conflicting candidates; the stub records that *"nothing here defines quotation data structure"*. [quotation-flow-process.md](quotation-flow-process.md) (`unverified`, `conflicts_with` non-empty) — the job walk is Step 4, **before** Step 5 *"Create a new quotation"*, and is not among the quote inputs of Steps 6–12. [sales-intake-and-job-walk.md](sales-intake-and-job-walk.md) §2 (`unverified`) — the Job Walk Sheet is its own form that *"pulls key intake answers"*. [sales-operating-system/02-master-process-map.md](sales-operating-system/02-master-process-map.md):53, :79 (`unverified`) — stage 3, *"Job walk scheduled, completed and **attached**"* (to what is not stated), ahead of stage 4 Quote Development and *"before final crane selection or quote release"*. [sales-operating-system/01-operating-system-architecture.md](sales-operating-system/01-operating-system-architecture.md):194 (`unverified`) — *"job walk information"* is a **Company File Storage** record, not an FCC quote record. [hubspot-sales-playbook.md](hubspot-sales-playbook.md):54 (`unverified`) — job-walk photos *"uploaded into HubSpot"*. FCC's quote screen has no job-walk tab ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §2: Main, Unit/People, Estimate, Tools/Rigging, Lift Info, Line Item) — and FCC is never a requirement source. `decisions/`: no hit. `aidlc/`: no hit. Jira not checked (no Jira MCP in this session).
- **Nearest talk (`status: reference`, unadjudicated):** [../meetings/transcripts/2026-06-23-mobile-app-payroll-adp-and-draft-workflows.md](../meetings/transcripts/2026-06-23-mobile-app-payroll-adp-and-draft-workflows.md):88–90 — Wes Staley wants a salesman button that opens a job-walk form, *"so they could attach a job walk form to the quote"*. [../meetings/transcripts/2026-06-25-cc-tcg-erp-system.md](../meetings/transcripts/2026-06-25-cc-tcg-erp-system.md):123–127 — asked whether the job walk is attached to the quotation, Melissa McNutt: *"the job box should be part of the quote"* ("job box" is the auto-transcription of "job walk"; the question at :123 says so); Ryan Adams: the sheet *"should automatically flow over to the quote and fill in whatever it can… but the job walk sheet itself should not be seen by the customer"*. Same file :172–175 — Joe Schacatano: the job-walk process is *"all being built out. This is new"*; Melissa McNutt: *"we'll have to add that on after"*. These are wants and a deferral, not a spec; **none names a tab, a screen, or create vs edit.**
- **Note:** the build already has the job walk hanging off something else — the mobile sales app starts one from a **customer** (`apps/mobile/app/(sales)/customers/[id].tsx`:347–357, `job-walk.tsx`), and its `save()` only toasts, resets the draft and navigates back. There is no job-walk model in `apps/api`, so the web tab has no record it could ever show. Existing code is not a source; this is recorded only because the two surfaces already disagree on what a job walk belongs to.
- **Related, do not answer separately:** whether a visible *"Coming Soon"* tab is acceptable at all is (b) of [../accounting/gaps.md → *Project detail Accounting tab — what it shows, and what it shows before the module exists*](../accounting/gaps.md#project-detail-accounting-tab--what-it-shows-and-what-it-shows-before-the-module-exists) — app-wide, open, owner Fouzan Shakil. This change is one more instance of it.
- **Blocked:** whether this change ships the view tab and the edit-only step; the data model of any job-walk build (quote-owned, or a separate record linked to customer / job site / quote).
- **Owner:** Ryan Adams (author of the Job Walk Sheet; described sheet → quote on 2026-06-25), with Melissa McNutt (said on tape it should be part of the quote). The placeholder half: Fouzan Shakil, per the accounting entry.

## Branch feat/quotation-manual-mark-won — manual Won from Draft, auto-void on Won, Void renamed Cancel

- **Status:** open
- **Asked:** 2026-09-12. Raised in the PR review of branch `feat/quotation-manual-mark-won` and escalated by tcg-scrum. No ticket, no `.ai/aidlc/` folder.
  - The asks came from the implementing developer (git `devmohsinakram`, overlay `abdulrehmanbcsf11`) in his own Claude Code session. He cites no client or PM as their origin.
  - The engagement directory gives neither identity a product role. So **no decision note was written**: the instructions are the change under review, not an answer to it.
- **Question:** four parts, each answerable in a line.
  - **(a) Won from Draft.** May a salesperson mark a **`DRAFT`** quote Won, meaning one never approved or sent in the system? If yes, is the manager-approval gate enough (`assertSendable`, the $50,000 threshold), or must the quote reach `INTERNAL_APPROVED` first? As built, a Draft under the threshold goes to Won with **no approval at all**.
  - **(b) Live envelope.** If a quote is marked Won while a DocuSign envelope is still live, which of these should happen?
    1. Void the envelope automatically.
    2. Refuse until the salesperson voids it.
    3. Leave the envelope live.

    If (1): may the customer see the void reason *"Quotation marked as Won manually"*? The branch does (1), with that text.
  - **(c) Visibility.** Should **Mark as Won** remain available after a DocuSign send, and on `DRAFT` / `CHANGES_REQUESTED`? Web previously showed it only on `INTERNAL_APPROVED` quotes never sent. Mobile (`WON_ELIGIBLE_STATUSES`) keeps the old list, so the two surfaces now disagree.
  - **(d) Label.** Should the envelope action read **Cancel** instead of **Void**? It still voids.
- **Sources checked:** **nothing written describes a manual Mark as Won, from any status.**
  - [quotation-flow-process.md](quotation-flow-process.md) (`unverified`; one of four candidates in the [quotations-INDEX.md](quotations-INDEX.md) conflict), Steps 16–27: Draft → internal approval → send → *"Customer approves and signs"* → Project. This is the happy path; it neither permits nor forbids a manual Won.
  - For (a), two approval rules disagree:
    - [tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md) §7 (`unverified`): supervisor approval before a quote reaches the customer is *"unconditional"*.
    - [../erp-review-log.md](../erp-review-log.md) → *Quote approval* (`unverified`, AI-extracted): approval is needed only below price-list rates, plus a $50,000 flag.
  - Signing and conversion:
    - [../projects-jobs/project-module/01-create-and-track-projects.md](../projects-jobs/project-module/01-create-and-track-projects.md):29 (`unverified`): Create Project is visible *"when qoutation is signed"*. It does not say what happens for a Won quote with no signature.
    - [../projects-jobs/project-module/06-client-reviews-and-signs-quotation.md](../projects-jobs/project-module/06-client-reviews-and-signs-quotation.md) (`unverified`): nothing about the sender withdrawing an envelope.
  - Legacy practice, not a rule:
    - FCC has a manual `WON` status code ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md), `unverified`).
    - HubSpot requires *"Closed Won"* once the outcome is known ([hubspot-sales-playbook.md](hubspot-sales-playbook.md), `unverified`).
    - Neither says from which states. FCC's void path is undocumented (fcc-nexgen-quote-entry.md §4).
  - For (d): [quotations.md](quotations.md):44 says *"`Envelope voided` - it should be user friendly"*, and [quotation.md](quotation.md):20–21 asks for void component and page changes. Both are `unverified`, both are conflicting punch lists, and neither names the button or "Cancel".
  - `decisions/`: [2026-09-14-quotation-mark-won-requires-comment-or-attachment.md](../decisions/2026-09-14-quotation-mark-won-requires-comment-or-attachment.md) covers the comment-or-`WON_EVIDENCE` OR gate (`status: reference` only — TCG ratification still open below). Nothing on voiding / Cancel label.
  - Transcripts: no hit for a manual Won.
  - Jira was not checked (no MCP).
  - `qa-automation/docs/testinyCases/quotations.md` QUOT-011 step 3 (*mark-won on DRAFT → 409*) records the old code, not a spec. The branch breaks it.
- **Related, already open. Do not answer separately:**
  - [Q-10](#q-10--status-is-writable-on-create-and-update): transitions only via action endpoints.
  - [Q-11](#q-11--archive-unarchive-upload-and-signature-routes-lack-permission-checks): who may void.
  - [Q-13](#q-13--syncfromsigningreturn-can-resurrect-a-locally-voided-envelope): *"should local void always void the remote envelope too?"*, the same call as (b).
  - [Q-16](#q-16--markassigned-accepts-declined-and-changes_requested): Won without customer acceptance.
- **Blocked:** whether `feat/quotation-manual-mark-won` merges as-is. Parts differ in weight:
  - (b) is visible to the customer.
  - (a) loosens an approval control.
  - (c) and (d) are reversible UI.
- **Owner:** product team. Ryan Adams (Sales Manager) for (a)–(d); Brian Petros for the approval half of (a).

## Structured Billing / Pre-Labor tabs vs the static-PDF quotation-send flow

- **Status:** **resolved** — [decisions/2026-09-07-pre-labor-pdf-and-structured-tabs-complementary.md](../decisions/2026-09-07-pre-labor-pdf-and-structured-tabs-complementary.md)
- **Asked:** 2026-09-07 — review of ad-hoc branch `feat/customer-billing-pre-labor-forms`
  (craneguys-platform PR #490 / `dacf6dc1`, no ticket; Path C `processed.log` row added 2026-09-08);
  tcg-scrum escalation
- **Question:** the ERP now captures the *same two documents twice*. Which is intended?
  (a) the structured web tabs **replace** the emailed PDFs; (b) they **complement** them — TCG
  still emails the PDF, and staff key the returned answers into the tabs; (c) the customer fills
  the structured form themselves (self-service), and the PDFs are retired; or (d) this is an
  uncoordinated duplicate build. One line settles it, and it decides whether
  `PRE_QUOTE_FORM_FILES` and the send-email appendix get deleted.
- **The duplication, concretely:** `packages/shared/src/constants/pre-quote-forms.ts` attaches two
  static PDFs to a quotation send — `CUSTOMER_PACKET: 'New Customer Packet.pdf'` and
  `JOB_LABOR_COMPLIANCE: 'Pre Job Labor Compliance Information Request Form final polished.pdf'` —
  with `buildPreQuoteFormsEmailAppendix()` asking the customer to *"review and complete this
  form, then reply to this email"*. The branch's two new Customer tabs capture the **same two
  documents as structured fields**: Billing Information (Credit Card Authorization, Credit
  Application, Deposit, Preliminary Notice) and Pre Labor Form. Neither side references the other
  in code or in the commit message, which cites only *"the Pre-Quote Data pattern and Figma
  layouts"*.
- **Sources checked — nothing addresses the relationship:**
  - [customers/new-customer-packet.md](../customers/new-customer-packet.md) — the packet itself,
    `status: unverified`, migrated 2026-09-04, source dated **2025-10-23**. Its own framing is
    decisive about what is *not* written: **"The packet is a paper/PDF process. Nothing in it says
    any of this should be, or is being, built into the ERP."** It lists the four forms that match
    the new Billing Information tab and notes the ERP *"already has a `preQuoteData` JSON blob on
    `Customer` waiting to hold something of this shape"* — while stating the correspondence is
    **unverified** and the packet is **not cited** as the blob's source.
  - [sales-operating-system/05-forms-and-records-matrix.md](sales-operating-system/05-forms-and-records-matrix.md)
    §1 — the nearest thing to a rule, and it argues for structured capture without naming this
    build: *"Completed forms must be stored in the designated **system of record rather than only
    in email**."* It does not say the ERP is that system of record for either form (row 1 names
    "FCC, HubSpot, Accounting files"; row 2 names "FCC job record").
  - [erp-review-log.md](../erp-review-log.md) entry #3 (Melissa, Accounting, 2026-04-02) asks for
    **automatic customer packet generation** — assembling the right documents per customer. That is
    a third shape again (generate a PDF), and nobody has reconciled it with either of the two built.
  - This register's *"Customer PO" on the quotation* entry above — `SCRUM-575` *Pre-Quote Data
    Form & Customer PO Form* (Done, 2026-06-25) closed with the comment that it shipped under two
    names, **"1. new customer packet 2. job and labor compliance information request form"**.
    That is the *only* written link between the two names and the ERP, it is a closing comment
    rather than a requirement, and the entry it sits in is open for unrelated reasons.
  - `vault/decisions/` (31 notes on overlay `main`) — **nothing** on either form's channel.
  - Jira **not consulted — unavailable** (Atlassian MCP not mounted this session; tenant was
    `403 suspended-payment` as of 2026-08-25). `SCRUM-575` may carry more than its closing comment.
- **Note:** the branch initially also added `20260907120000_drop_customer_pre_quote_data`; that
  migration was **removed from PR #490** (2026-09-08). Whether `pre_quote_data` may ever be dropped
  remains a separate Product question.
- **Blocked:** sign-off of `feat/customer-billing-pre-labor-forms`; whether
  `PRE_QUOTE_FORM_FILES`, `buildPreQuoteFormsEmailAppendix()` and the two committed PDFs should be
  removed, kept, or wired to the new tabs.
- **Owner:** Ryan Adams / Joe Schacatano (sales & quotation) for the send flow; Melissa McNutt
  (Accounting) for the packet, since the automatic-generation ask is hers.
- **Cross-link:** [customers/gaps.md → *Pre-Labor / labor-compliance capture — one customer-level
  blob, or one record per job/quote?*](../customers/gaps.md#pre-labor--labor-compliance-capture--one-customer-level-blob-or-one-record-per-jobquote)
- **Resolution (2026-09-07):** answer (b) — the two mechanisms are **intentionally
  complementary**, joined by a **manual, sequential workflow**: TCG emails the static PDFs
  from the Send-to-Customer modal → the customer fills the PDF by hand and emails it back →
  a TCG staff member **transcribes** the answers into the customer's Billing Information and
  Pre Labor Form tabs. **No OCR/automatic extraction is planned; no customer self-service;
  the PDF flow is not being replaced.** So `PRE_QUOTE_FORM_FILES`,
  `buildPreQuoteFormsEmailAppendix()` and the two committed PDFs **stay, unwired to the
  tabs, by design** — the PDF is the collection instrument, the tabs are the system of
  record. Product decided this **verbally**, relayed by Jahanzaib Nadeem; **no individual
  Product person is named** (Ryan Adams / Joe Schacatano own the send flow, Melissa McNutt
  the packet — none is recorded as having said it), so re-confirm with a named owner before
  deleting anything on the strength of it.
  **Applied as a consequence:** the modal's staff-facing checkbox copy now reads "Billing
  Information" / "Pre Labor Form" to match the tabs; the PDF filenames, prop names and the
  **numbered PDF titles** in the customer-facing email appendix were deliberately left
  unchanged. **Correction (2026-09-08):** the appendix **intro line**
  (`PRE_QUOTE_FORMS_EMAIL_APPENDIX_INTRO`) was later rewritten in PR #490 `dcaa7bf0` from
  *"our Pre-Quote documentation"* to *"our customer documentation"* — that change is **not**
  covered by this decision (see the open entry below). Do not treat the whole email body as
  frozen by this note.
  **Still open, and not closed by this:** whether `pre_quote_data` may be dropped (migration
  removed from PR #490 pending Product); Melissa's automatic customer-packet-generation ask
  ([erp-review-log.md](../erp-review-log.md) #3), a third shape neither addressed nor dismissed;
  and `SCRUM-575`, still unread (Jira unreachable this session).

## Is "Pre-Quote" being retired in customer-facing copy, and who signs off the send-email text?

- **Status:** open
- **Asked:** 2026-09-08 — review of `feat/customer-billing-pre-labor-forms` (commit `dcaa7bf0`),
  main-repo PR #490. **Not a ticket question:** no `SCRUM-###`, no `.ai/aidlc/SCRUM-###/`
  folder (Path C `processed.log` row added 2026-09-08).
- **Question:** the commit rewrites the customer-facing first line of the quotation-send email
  appendix (`packages/shared/src/constants/pre-quote-forms.ts`,
  `PRE_QUOTE_FORMS_EMAIL_APPENDIX_INTRO`) from *"our Pre-Quote documentation"* to *"our customer
  documentation"*. Two things need a person: (a) is "Pre-Quote" being deliberately retired from
  copy the customer reads, or was this an incidental tidy-up? (b) who owns the wording of this
  email at all — `quotations/quotations.md:32` records that TCG never supplied it.
- **Candidates:** `quotations/quotations.md:32-33` (punch list, 2026-07-14) — *"Need to
  demand text from TCG team for email"*, and a rename request pointing at *"new customer
  packet"*, the opposite direction from this change;
  `quotations/sales-operating-system/05-forms-and-records-matrix.md` section 8 *Quote Sent* —
  content requirements, explicitly **not** wording; `meetings/transcripts/2026-08-11-sales-process.md:211`
  (Brian Petros, TCG, 2026-08-11) still says "pre-quote" in TCG's own voice. Nothing in
  `quotations-INDEX.md`'s four candidates, `decisions/`, or `SCRUM-575` as transcribed in this
  register addresses email copy. Jira re-checked 2026-09-08: still `403 suspended-payment`.
- **Note:** `decisions/2026-09-07-pre-labor-pdf-and-structured-tabs-complementary.md` originally
  said the customer-facing email body was "deliberately left unchanged"; that is true of the
  numbered PDF titles only, not of this intro line. The decision note carries a correcting line
  as of 2026-09-08.
- **Blocked:** nothing hard — the string ships either way. But if "Pre-Quote" is *not* being
  retired, the customer-facing term now diverges from the PDF titles the same email lists, and
  from the `PRE_QUOTE_*` identifiers, filenames and DB column that keep the old name.
- **Owner:** Ryan Adams / Joe Schacatano (quotation send), with Melissa McNutt on packet naming.

## "Max travel time" on the quotation detail — meaning, traffic model, origin yard, and degraded state

- **Status:** open
- **Asked:** 2026-09-12 — review of main-repo PR #530 (branch
  `feat/quotation-yard-jobsite-duration`), which replaces the *"Coming soon"* placeholder
  labelled **Max travel time** on the quotation detail Main tab (Job Site Information card,
  `apps/web/src/features/quotations/workspace/detail/detail-info-cards.tsx`) with a live Google
  Routes API driving duration. **Not a ticket question:** no `SCRUM-###`; Path C, logged in
  `aidlc/processed.log` via overlay PR #71. The placeholder itself arrived in main-repo commit
  `1242f593e` (*"iPad and Mobile responsiveness Web 1.0"*, 2026-08-19, mohsinakram) with no
  ticket reference and no source for the label. tcg-scrum escalation.
- **Question:** four parts, each answerable in a line.
  (a) **What is the figure?** One-way yard → job-site drive time, round trip, the worst case
  across the tenant's yards, or a padded/rounded figure meant to feed the Travel In / Travel
  Out billing lines? The label says *Max*; nothing written says max of what.
  (b) **Static or live?** Should it be a traffic-unaware estimate (what PR #530 ships:
  `routingPreference: TRAFFIC_UNAWARE`), or traffic-aware for the quoted schedule window — and
  should it be routed as a **truck**, with a per-asset speed adjustment, or as a car?
  (c) **Origin.** Is the quotation's single `yard` field the right origin? It is a free
  `String? @db.VarChar(100)` on `Quotation` (`apps/api/prisma/schema.prisma:1739`, no foreign
  key), so PR #530 resolves it by *name* to a `Yard` row's physical address. If a quote can
  draw equipment from more than one yard, which yard is the origin?
  (d) **Degraded state.** When the yard has no street address, should the row be **hidden**
  (PR #530), or shown with an em dash so the salesperson sees the figure is missing?
- **Candidates:**
  - `meetings/transcripts/2026-03-06-sales-quoting-figma-demo.md:208-225` (107.9 KB,
    2026-03-06, `reference`) — **the only written origin of the row, and it is a demo
    transcript, not a spec.** ehtesham.anwar (42:01) proposes it on the quotation creation
    view: *"This system automatically checks with the Google Maps and calculates the travel
    time from your yard location to the actual job site"* — singular yard, one direction
    implied, no "max". Melissa McNutt (43:32) asks for it to be adjusted per crane size /
    speed, and (44:31) whether it follows time of day like Google does; ehtesham.anwar (44:44,
    44:53) answers *"based on the schedule"* and defers the exact leave-yard-time figure to a
    later flow. Ryan Adams (45:17): semi trucks, scale stops, max speed 55 — *"something that
    would normally be 45 minutes away is going to take us an hour, hour and 15 minutes compared
    to what Google is"*; ehtesham.anwar (45:43) says Google can route as a truck. None of this
    was recorded as a decision; §6 of the scrum procedure applies — a record, not a commitment.
  - `meetings/summaries/2026-03-06-ai-generated-meeting-action-items.md:126` (13.7 KB,
    `reference`, **auto-generated, not human-reviewed**) — High-priority Dev Team item:
    *"Integrate Google Maps API for automated travel time calculation from yard to job site.
    Apply vehicle-type speed adjustments (truck vs. car). Factor in time-of-day traffic. Store
    average speed per asset in asset management."* — three of those four are **not** in PR #530.
  - `meetings/transcripts/2026-05-07-loading-and-project-module-overview.md:181` (79.2 KB,
    2026-05-07, `reference`) — Brian Petros, on job leave-time: *"we can't rely on Google Maps
    because they have special routes"*; wants a guess from basic data first, then Samsara
    history. Job context, but the same objection applies to a raw Routes API number.
  - `quotations/mobilization-and-demobilization.md:57-63,117-121` (12.3 KB, 2026-09-04,
    `unverified`) — FR-3 scopes Mobilization to *"drive time from the yard"*; the T&C names the
    return origin as **the dispatch location, not "the yard"**, which bears on (c).
  - `quotations/tcg-creating-quotes-sop.md:127-135` (15.1 KB, 2026-05-11, `unverified`) — the
    five quoted-hour components include *"Travel to the jobsite (portal to portal)"* and
    *"Travel back to the yard"* — i.e. quoted travel is **two legs**, which bears on (a).
  - `quotations/quote-terms-and-rate-card.md:105` (26.7 KB, 2026-09-04, `unverified`) —
    subsistence is priced on **yard-to-job distance** (miles), the only other yard→site figure
    a quote uses; no time figure on the printed quote's Job Site Information panel (:218-220).
  - `quotations/fcc-nexgen-quote-entry.md:323-327` (64.1 KB, 2026-09-04, `unverified`) — in
    FCC, *"travel time adjustments"* live on the **job**, not the quote.
  - `projects-jobs/project-module/07-create-and-manage-jobs-excluded.md:31,46` (2.7 KB,
    2026-04-30, `unverified`, **excluded scope**) — *"If equipment comes from different yards,
    Dispatcher selects the yard per asset and system calculates travel time"* — per-asset
    yard, at the job, which is the multi-yard case (c) asks about.
  - `admin/gaps.md#map-provider-no-key-fallback-and-which-table-owns-address-coordinates`
    (open since 2026-08-25) — no vault file names TCG's map/routing provider; PR #530 commits
    to Google Routes with that question still open.
  - `decisions/2026-09-10-das-map-transit-path-and-eta-deferred.md` (`reference`) — deferred
    a routing-provider dependency out of SCRUM-252 for want of any source naming one, and
    warns that a wrong ETA *"looks authoritative"*; a quotation figure has the same exposure.
  - **Searched, nothing:** vault-wide grep for `max travel|max_travel|maxTravel` — zero hits;
    `INDEX.md`, `quotations/INDEX.md`, `quotations/quotations-INDEX.md`, this register,
    `dispatch/gaps.md:220` (Joe Schacatano 2026-09-03 yard-arrival ETA — dispatch, not
    quotes), `customers/quickbooks-customer-table-audit.md` (per-customer *Travel Time* free
    text, inactive), `meetings/transcripts/2026-05-18-quotation-and-job-lifecycle.md`,
    `2026-03-26-tcg-cc-product-sync-demo.md`, `2026-05-05-tcg-erp-system.md` (Job Site
    Information → map, :205-212; no travel figure), `aidlc/SCRUM-877`, `aidlc/SCRUM-PROGRESS`,
    `decisions/`. Jira not reachable (Atlassian MCP unauthenticated this session).
- **Note:** the 2026-03-06 transcript is the closest thing to an ask and it points the *other*
  way on two of the four parts — the client asked for truck routing with a per-asset speed
  factor and for time-of-day sensitivity; PR #530 ships car routing, traffic-unaware. That is
  not a defect finding (nothing was decided), but it means "matches what was discussed" cannot
  be claimed for the PR either. The word *Max* has no written source at all.
- **Blocked:** nothing hard — the row renders a number either way. Soft: whether the figure
  may be quoted to a customer or used to seed Travel In / Travel Out; whether the origin
  resolution by yard *name* is acceptable given `Quotation.yard` is unconstrained text; and
  whether the no-address case should be visible rather than silent.
- **Owner:** Melissa McNutt (asked for the adjustable figure, 2026-03-06) with Ryan Adams
  (truck routing) and Brian Petros (map provider, per `admin/gaps.md`).

## Branch fix/12-sep-uat — after DocuSign COMPLETED, branded SES to customer with signed PDF attached

- **Status:** open
- **Asked:** 2026-09-12 — PR review Path C branch `fix/12-sep-uat` (no ticket, no `.ai/aidlc/` folder); tcg-scrum escalation.
- **Question:** when a DocuSign envelope reaches **COMPLETED** (webhook or sync), should the system (a) send the **customer** a **branded SES email with the signed PDF attached**, (b) **not** use the separate email-sign / `sendViaEmail` path or manual **mark-as-signed** for that completion, and (c) leave the **salesperson acceptance / internal notify** path unchanged? One line per part.
- **Sources checked:** [quotation-flow-process.md](quotation-flow-process.md) Steps 16–27 (`unverified`, [quotations-INDEX.md](quotations-INDEX.md) conflict) — send and customer sign, silent on post-completion delivery. [fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §4 (`unverified`) — DocuSign post/download, not a customer SES copy. [*The signing email should come from the salesperson, not from DocuSign*](#the-signing-email-should-come-from-the-salesperson-not-from-docusign) — **sender/voice at send time**, not post-sign PDF delivery. [Q-18](#q-18--docusign-send-reports-success-when-branded-email-fails) — branded SES on **send**, failures logged. [Q-02](#q-02--public-signed-document-endpoint-has-no-authentication) — public signed-PDF download, not email. `decisions/` — no note on COMPLETED → customer email. Jira unavailable (403 suspended-payment).
- **Note:** embedded DocuSign suppresses DocuSign's invite ([Q-18](#q-18--docusign-send-reports-success-when-branded-email-fails)); if (a) is yes, SES becomes the customer's only signed-artifact delivery unless they use an in-app link.
- **Blocked:** Path C `fix/12-sep-uat` quotation-signature completion UX; reconciling with Joe Schacatano's salesperson-sender ask if the COMPLETED email is platform-branded.
- **Owner:** Joe Schacatano / Ryan Adams (customer correspondence); Patrick if Outlook per-user sending is required instead.
- **Update 2026-09-28 (Jz-Nd, TCG-21 — developer, not product).** Related, does not answer this entry: the platform now stores its own copy of the signed PDF as a *Signed Quotation* attachment on the quotation and its projects and jobs ([../decisions/2026-09-28-docusign-signed-copy-stored-as-attachment.md](../decisions/2026-09-28-docusign-signed-copy-stored-as-attachment.md), `reference`). Customer delivery stays open here.

## Manual Mark as Won — must comment or dialog attachment satisfy the gate?

- **Status:** open
- **Asked:** 2026-09-14 — PR review of merged branch `feat/won-quotation-comments-attachments` (TCG PR #567 / overlay PR #82; Path C, no ticket); tcg-scrum escalation.
- **Question:** for manual **Mark as Won** (web dialog + `POST …/mark-won`), must the user supply **at least one of** (1) a non-empty free-text comment persisted on the quotation, or (2) a file uploaded **in that dialog** stored as a quotation attachment with category **`WON_EVIDENCE`** (existing quotation attachments do **not** count)? If yes, is the intent symmetric to Mark as Lost (reason + comments), or is either field optional for Won?
- **Sources checked:** [quotations-INDEX.md](quotations-INDEX.md) — four unverified candidates; none defines manual Mark as Won evidence. [quotation-flow-process.md](quotation-flow-process.md) Step 26 — Lost Reason and comments on **customer rejection**, not manual Won. [gaps.md → Branch feat/quotation-manual-mark-won](#branch-featquotation-manual-mark-won--manual-won-from-draft-auto-void-on-won-void-renamed-cancel) — open on Draft Won, envelope void, visibility, Cancel label; **silent on comment/attachment**. `decisions/2026-09-14-quotation-mark-won-requires-comment-or-attachment.md` — documents the OR gate as **`status: reference`**, **`decided_by`** names no TCG or CodingCops product owner (Cursor implementation session only); explicitly not client PO sign-off. Not `verified`.
- **Note:** merged code implements the OR gate; this entry asks whether TCG ratifies it.
- **Blocked:** treating PR #567 behaviour as settled product spec; mobile Mark Won parity (out of scope in the reference note).
- **Owner:** product team (Ryan Adams / Brian Petros).

## After manual Mark as Won — show comment and WON_EVIDENCE on the green Quick Actions banner?

- **Status:** open
- **Asked:** 2026-09-14 — same PR review as above; tcg-scrum escalation.
- **Question:** when a quotation is **`WON`** via manual mark-won, should the **Quick Actions** panel show a **green** banner with the persisted won comment and/or links to **`WON_EVIDENCE`** attachments (as shipped in PR #567), or should won evidence live elsewhere (Attachments tab only, activity log, or not at all)?
- **Sources checked:** same quotation sources as above — **nothing written** on displaying manual-won evidence. `decisions/2026-09-14-quotation-mark-won-requires-comment-or-attachment.md` § *What this does not settle* — explicitly leaves detail-page display open. [quotations.md](quotations.md) — *decline reason should be shown on UI* (`unverified` punch list); no parallel line for Won evidence.
- **Blocked:** whether the Quick Actions banner UX is correct or should be removed/reduced pending TCG answer.
- **Owner:** product team.

## Branch fix/quotation-signed-copy-and-customer-po — DocuSign return page and signed-copy download

- **Status:** open
- **Asked:** 2026-09-15 — PR review of uncommitted `apps/api` + `apps/web` changes for branch `fix/quotation-signed-copy-and-customer-po` (Path C, no ticket, no ticket folder; overlay handle `abdulrehmanbcsf11`, git user `devmohsinakram`). Its `processed.log` row is filed under `fix/quotation-signed-copy-download` and covers this entry only, not the next one. tcg-scrum escalation.
- **Question:** three parts, each answerable in a line. **(a)** When the customer returns from embedded signing (`GET /quotations/:quoteNo/signature/sign-complete`), should the page report the synced signature status? As built: **COMPLETED** shows *"Quotation X is signed"* plus a **Download signed quotation (PDF)** button. **DECLINED / CHANGES_REQUESTED** shows *"Your response has been recorded"*. **VOIDED** shows *"no longer available"*. Anything else shows *"Not signed yet — use the link in your email"*. Before, the page always said *"Your response … has been recorded"*. **(b)** Should the customer be able to download the signed PDF themselves from that page, through a public route gated by the **signing-link token** (`…/signature/signed-copy?token=…`, resolved by the token's envelope)? At the same time the internal `GET …/signature/signed-document` becomes **login-only**. **(c)** When the local signature is not yet COMPLETED, may a *download* request on either route pull the envelope status from DocuSign, and so, as a side effect, move the quotation to **WON** and send the signed-copy email?
- **Sources checked:** **Nothing written specifies the return page's per-status wording, a customer self-download of the signed PDF, or a status pull triggered by a download.**
  - [../projects-jobs/project-module/06-client-reviews-and-signs-quotation.md](../projects-jobs/project-module/06-client-reviews-and-signs-quotation.md) (`unverified`) covers sign or decline, *"notified to Sales person"* and *"Once signed or declined: Further actions are disabled"*. It has no return page and no customer copy.
  - [quotation-flow-process.md](quotation-flow-process.md) Steps 21–25 and [../assets/user-story-and-tasks.md](../assets/user-story-and-tasks.md) US2 are silent after signing. Both are `unverified` and both are in the [quotations-INDEX.md](quotations-INDEX.md) conflict. The second comes from a personal space.
  - [quotations.md](quotations.md) (*"docusign page should ne good"*, *"`Envelope voided` - it should be user friendly"*) and [quotation.md](quotation.md) (*"Void docusign page customization"*) are `unverified` punch lists that ask for better page copy. They give no wording and no status set.
  - [fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §4 (`unverified`): in FCC the **salesperson** downloads the completed PDF (the *Signed Document* row). Nothing is customer-side.
  - [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) preamble (`unverified`): a *"signed copy of the estimate"* confirms a job. It says nothing about the customer getting a copy back.
  - [../decisions/2026-09-14-quotation-mark-won-requires-comment-or-attachment.md](../decisions/2026-09-14-quotation-mark-won-requires-comment-or-attachment.md) (`reference`) puts DocuSign WON paths explicitly out of scope.
  - `.ai/aidlc/SCRUM-TZ/spec.md` §12 Q22 (open, ticket-scoped) asks whether the public signed-document route should stop being public. It is unanswered.
  - Jira was not checked (no Jira MCP in this session).
- **Related, do not answer separately:**
  - [*After embedded signing returns, should the app pull DocuSign status…*](#after-embedded-signing-returns-should-the-app-pull-docusign-status-immediately-or-wait-for-the-webhook): (a) displays what that pull produces, and (c) extends the same pull to the two download routes.
  - [Q-02](#q-02--public-signed-document-endpoint-has-no-authentication): (b) is one answer to its question.
  - [Q-09](#q-09--signing-link-tokens-never-expire-and-are-not-single-use): the signing-link token now also unlocks the signed PDF, so the token's missing expiry becomes that PDF's exposure window.
  - [Q-13](#q-13--syncfromsigningreturn-can-resurrect-a-locally-voided-envelope) and [Q-14](#q-14--webhook-and-sync-can-downgrade-a-completed-signature): the same sync has unguarded status transitions.
  - [*Branch fix/12-sep-uat — …*](#branch-fix12-sep-uat--after-docusign-completed-branded-ses-to-customer-with-signed-pdf-attached): the email in (c) is that entry's (a). The email and (b) are two customer delivery paths for the same signed PDF.
- **Blocked:** treating the return-page wording, customer self-download and download-triggered WON as settled spec.
- **Owner:** Joe Schacatano / Ryan Adams (customer-facing signing experience); whoever owns tenancy, for the public-route shape in (b).
- **Update 2026-09-28 (Jz-Nd, TCG-21 — developer, not product).** Related, does not answer (a)–(c): the signed PDF is now also stored as a *Signed Quotation* attachment on the quotation and its projects and jobs, and envelopes completed before that change are stored lazily on first signed-PDF download ([../decisions/2026-09-28-docusign-signed-copy-stored-as-attachment.md](../decisions/2026-09-28-docusign-signed-copy-stored-as-attachment.md), `reference`).

## Branch fix/quotation-signed-copy-and-customer-po — acceptance block Customer Name and Customer PO, and PO write-back on completion

- **Status:** open
- **Asked:** 2026-09-15 — same review as the entry above (branch `fix/quotation-signed-copy-and-customer-po`, Path C, no ticket). The branch's `processed.log` row does not mention it. tcg-scrum escalation.
- **Question:** four parts, each answerable in a line. **(a)** Should the quotation PDF's acceptance block replace **Printed Name** and **Title (Contractor's Representative)** with **Customer Name** and **Customer PO No.**? TCG's own printed quote reads *Date · Print · Sign · PO Number*, so this also asks whether the signer's own printed name is dropped in favour of the customer company's name. **(b)** Should Customer Name be printed from the customer record and be **not editable** in DocuSign? **(c)** Should Customer PO No. be printed and **locked** when the quotation already holds `customerPo`, and be an **optional, editable** DocuSign text field when it is empty? **(d)** On DocuSign completion (webhook or status sync), should a PO the customer typed be written to `quotation.customerPo`, and only when that is still empty? The reviewer proposed (d); no one has confirmed it.
- **Sources checked:**
  - [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md):177-178 and :346-349 (`unverified`; it calls itself *"client artifacts describing what is charged today"*, not ERP requirements) gives *"Company Representative Acceptance: Date · Print · Sign · PO Number"*. That supports a PO line captured at acceptance. It includes **Print** (the signer's name), which (a) removes, and has **no** customer-name line and **no** title line. No vault source covers the removed *"Title (Contractor's Representative)"* label either.
  - [../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md](../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md) (`reference`, Brian Petros, TCG): the customer PO *"shows up at the moment the customer approves the quote"* (:27-28), which is consistent with capture at signing. But it *"is **not** a quotation field"* and is logged *"on the job / schedule tab"* (:60-61, :113). That is in tension with (c) reading `quotation.customerPo` and (d) writing it.
  - [quote-lifecycle-permits-and-purchase-orders.md](quote-lifecycle-permits-and-purchase-orders.md):49 (`unverified`): *"Log customer PO # — record on job / schedule tab"*.
  - **(b), (c) and (d) have no written source.** The developer working under git identity `devmohsinakram` stated (b) and (c) in the implementing session on 2026-09-15. [../decisions/2026-09-11-progress-tracking-chat-and-reminders-shown-disabled.md](../decisions/2026-09-11-progress-tracking-chat-and-reminders-shown-disabled.md):8 records that identity as this machine's shared identity. His words: *"customer name from customer and that should not be editable on docusign"*; *"on docusign po number will only editable if it is empty not if anyone write it on quotation"*; *"optional if not already entered, disabled if anything is already entered in quotation portal"*. That is implementer direction, not a product decision. It also builds on a quotation field that a TCG decision says is not one. So **no decision note was written**.
  - `decisions/` has nothing on the acceptance block, DocuSign field locking or PO write-back. `.ai/aidlc/` has no ticket. Jira was not checked.
- **Related, do not answer separately:**
  - [*The customer PO arrives before the job exists — may the quotation capture it?*](#the-customer-po-arrives-before-the-job-exists--may-the-quotation-capture-it): (c) and (d) both assume `Quotation.customerPo` is a legitimate home for the PO. That is exactly what that entry asks Brian Petros, and his answer settles the location half of (c) and (d). Its *Note* also applies to (d): capturing the PO on the quote keeps the number on a quote that never converts.
  - [*"Customer PO" on the quotation — which of three things does it mean?*](#customer-po-on-the-quotation--which-of-three-things-does-it-mean): its 2026-09-05 answer and 2026-09-09 update.
- **Blocked:** treating the relabelled acceptance block, the DocuSign field locking and the write-back as settled spec.
- **Owner:** Brian Petros for the location in (c) and (d) (his 2026-09-05 call); Ryan Adams / Joe Schacatano for the printed acceptance block in (a) and (b).

## Quote line items vs dispatch resources — the associated set auto-fills the quote, and the sales owner says dispatch resources must not be quoted

- **Status:** open — **principle decided 2026-09-16** ([../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md)): the quote carries billing codes, resources are dispatch-side. The model — (a)–(d) in the 2026-09-16 update below — is still open
- **Asked:** 2026-09-15 — Joe Schacatano (VP of Sales), ERP live demo 01, while the *100 Ton* sub-category's associated set auto-filled a quotation's Resources ([../meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md](../meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md) §2; transcript 39:38–45:27). Ehtesham Anwar called it *"a critical thing that we have missed a while in the discovery"* (45:10) and, at close, *the* missing configuration step — *"assets configurations for the field versus asset configuration for the quotation"* (1:16:04). No ticket.
- **Question:** three parts. **(a)** Confirm the principle Joe stated: a quotation carries only **charged line items** — for a 100-ton job *"100 ton operator load, travel permit, and a surcharge. That's it."* (40:17) — while **dispatch resources** (*"Oiler, operator, semi, those things don't get charged. Those are the resources utilized in dispatching"*, 39:45) are never quote rows: *"you don't want the 10 resources populating with it, with charges for it"* (42:33). If so, associated-field-asset sets stop auto-populating quotations. **(b)** What is the relationship between **billing codes, resources and field assets** — which charged line implies which dispatch resources, and where is that configured? (Ehtesham's proposal, 44:36: a resources tab or flag on the sub-category; Joe, 42:33: it *"could be a subcategory… we have to just keep them separate when it's quoted"*.) **(c)** Joe (43:28) says a customer's price list applies *"when you're quoting for that customer **or scheduling** that customer"* — what does a price list do at scheduling time?
- **Sources checked:**
  - [../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md](../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md) (`reference`, CodingCops design, acknowledged once by Ryan Adams) — associated children auto-populate **onto the quotation** and *Always Included* ones cannot be removed. (a) contradicts this for dispatch-only resources such as the oiler and operator.
  - [../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md](../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md) (`reference`, Syed Haris) — job resources and DAS slots are materialised from the quotation's priced lines plus *Always Included* children. If dispatch resources leave the quote, the DAS needs another source for those slots.
  - [../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md) item 2 — Joe: quotes populate from resource types; *"the additional items like the riggers… We don't want that to populate."* Same direction, two weeks earlier.
  - [*Estimate defaults per resource type / job type / yard*](#estimate-defaults-per-resource-type--job-type--yard--fcc-has-them-tcg-has-no-job-type-at-all) above — FCC's template model; its (g) (a 110 Ton requiring Operator + Oiler) is already Joe's to answer.
  - Adjacent, not the same question: [../dispatch/gaps.md](../dispatch/gaps.md) → *Requested vs dispatched resources*; [../assets/gaps.md](../assets/gaps.md) → *Nomenclature for the template level*.
  - Joe (41:07) says he already showed Brian the difference; Brian (41:38) says he sent it to CodingCops. That material is not in the vault.
- **Blocked:** quotation Resources auto-fill from the sub-category; the sub-category associated-field-asset configuration; conversion → job resources → DAS slots.
- **Owner:** Joe Schacatano with Ryan Adams (the billing-code / resource / field-asset relationship), relayed by Brian Petros; CodingCops for the model.
- **Update 2026-09-16 — the principle is decided; the model is not.** On a dedicated follow-up call ([../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md](../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md) §1–2) Joe Schacatano explained the relationship Ehtesham asked for on 09-15 (44:43), and confirmed it when asked directly:
  - The estimate carries **billing codes only**. Unit/People resources do not populate the quote (6:11 *"Correct."*).
  - *"the billing codes should dictate the resources and the assets for dispatch to assign"* (7:09).
  - A load's tractor, trailer and driver have **no billing code** of their own: *"their costs are built into that code"* (10:48–11:10).
  - The salesperson picks the machine from one drop-down, with **no unit-type step** (15:00).

  Recorded as [../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md) (`verified`; conflicts with the 2026-09-04 Always Included note). Part (a) above is answered; (b) and (c) continue as the open items below.

  **Still open, each answerable in a line:**
  - **(a)** Is the dispatch requirement held on the resource type × job type configuration (FCC's Unit/People; `SubCategoryAssociatedResource` today), or on the billing code (Joe 6:43: *"the codes should generate the resources"*)?
  - **(b)** What happens to the Unit/People rows already on quotations, and to the Always Included no-delete rule on the quotation screen?
  - **(c)** With the category step gone, how does the one drop-down reach non-machine lines (tools and rigging, employee types, permits, lift plans)?
  - **(d)** Who keeps billing-code amounts right? Joe answered *"Right"* to *"the stakeholder team"* (11:21), probably an ASR error for *sales team*.
  - The 09-15 price-list-at-scheduling question (part (c) above) was not raised on 09-16 and stays open.

  Ehtesham (15:35) is designing the change against the build. The mob/demob session with Joe is the week of 2026-09-28.
- **Update 2026-09-17: Brian's FCC deep dive** ([fcc-billing-resource-configuration-deep-dive-2026-09-16.md](fcc-billing-resource-configuration-deep-dive-2026-09-16.md); his and TCG's AI model, a recommendation, not a decision). On (a) it recommends **both**: requirements may come from a billing-code rule (Operator Load → tractor, trailer, crew), a service-profile rule (the 350 package), a profile variant (Hourly w/ Mob adds a tractor), or a manual Dispatch add. It models this as a *Dispatch Requirement Template* beside a *Billing Bundle Template*, both hung off a *Service Profile*. FCC evidence it adds:
  - quote OM-40439 stored type-level Unit/People placeholders only, with every `UnitCode` NULL;
  - job OM60788 resolved them to real units and employees;
  - job OM60788 also ran a 40 Ton (4003) with **no billing line**;
  - FCC's 350 configuration has no usable personnel template.

  (a) stays Joe's to confirm. The document's own §34 lists it as open too.

- **Conflict logged 2026-09-19 — the whole UAT Resources screen is built on the reading this decision rejects, and the register never mentions the decision.**
  [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) carries **20-plus rows** that treat quotation
  **Resources** as priced lines and argue about their pricing chrome — the Margins column removed from Resources,
  the Adjustment column off the print, the hover total on a resource row, *Resources Total Value should not round*,
  *Permit line items in Resources*, the removed rigger showing at $0, the unsaved-resources warning, and the rest.
  Every one of them presupposes that a resource is a **priced quotation line**.
  [../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md)
  — **`status: verified`, Joe Schacatano (TCG VP of Sales), and the only `verified` quotation decision in the vault** —
  says the opposite: *"At the quoting stage, the estimate is **billing codes only**"*, *"**Resources exist for dispatch**"*,
  *"A resource **has no billing code of its own**"*. On tape, 39:45: *"Oiler, operator, semi, those things don't get charged."*
  **The register was assembled on 2026-09-18, two days after that decision, and never cites it.** Its rows are
  checked against `origin/main @ f800a3972`, i.e. against the build — and the decision note already records that
  the build contradicts it (*"As built (Ehtesham, 5:46 and 14:25): the quotation populates Unit/People rows"*).
  **What this means for anyone working the register:** a Resources row marked DONE is DONE against the current
  screen, not against Joe's model; and a Resources row marked NOT DONE may be work that should not be done at all.
  This is **not** an adjudication — the principle is decided, the model (a)–(d) in the 2026-09-16 update above is
  still open, and nothing here reverses a shipped row. It is a warning that the register and this entry are
  describing two different products. A UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md).

## Resources Total Value — UAT asks for exact decimals, the code deliberately strips cents

- **Status:** open
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register into the module registers. Not a ticket question.
- **Question:** may a quotation **resource rate** carry cents? The UAT 3 ask reads as a display complaint but lands on a **pricing rule**: if rates stay whole-dollar, the Total Value cannot show anything but a whole number, and no formatter change will satisfy it.
- **Sources checked:**
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → NOT DONE *Resources Total Value should not round*, [UAT 3]. The session sheet: *"In the Total Value field in Resources, there should be exact decimal values. There is no need to round off."* The register's finding: *"Display formatting is not the culprit — rates are deliberately whole-dollar: cents are stripped on keystroke and rejected with 'Rate must be a whole number (no cents)'. The complaint stands, but this is a pricing rule to revisit with the client, not a formatter to fix."*
  - **The rule it collides with:** [../decisions/2026-08-31-quotation-resource-rate-whole-dollars.md](../decisions/2026-08-31-quotation-resource-rate-whole-dollars.md) — *"A resource line's **Rate must be a positive whole number**"*. In code: `apps/web/src/features/quotations/utils/resource-rate.ts:33-35` — `Rate must be greater than 0` and ``Rate must be a whole number (no cents) — got …``.
  - Nothing in [../decisions/](../decisions/) revisits whole-dollar rates, and nothing anywhere says the **Total** is computed to a different precision than its rows.
- **Note:** a UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md). Read literally the row asks for a formatter change, and a formatter change will not produce cents that the rate never held. Whoever answers must answer the pricing question, not the display one. Two sub-questions, each a line: **(a)** may a rate carry cents? **(b)** if rates stay whole, may a **computed** total (qty × rate, or a mob/demob parent sum) ever be non-integral — and if not, is there anything left of the complaint?
- **Blocked:** any change to `resource-rate.ts` rounding; the Total Value display; whether [2026-08-31-quotation-resource-rate-whole-dollars.md](../decisions/2026-08-31-quotation-resource-rate-whole-dollars.md) needs revisiting.
- **Owner:** Joe Schacatano (sales, quotation pricing) with Melissa McNutt. Fouzan Shakil wrote the whole-dollar rule and can say what it was protecting.
- **Update 2026-09-29 (TCG-99 close, PR #697):** sub-question **(b)** has an answer from the code, not from a human: yes, a computed line total is routinely non-integral even with whole-dollar rates, because discount and surcharge percentages may carry decimals (`Decimal(5,2)` / `Decimal(8,2)`). 5 × $3,000, −7.5%, +12.5% surcharge computes to `15609.375`. TCG-99 took only the part that needed no product call: amounts are rounded to cents in the app before saving (web and API; mobile is TCG-197), and every total displays at 2 decimals. That touches the *Total Value display* this entry lists as blocked, but only to make three formatters agree at 2dp, not to decide the precision a total should carry. **(a), may a rate carry cents, is untouched and still open.** Nothing here is adjudicated.

## Permits in Resources — is a permit a quotation line at all

- **Status:** open
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register into the module registers. Raised in **UAT 2 (2026-09-09)**, explicitly deferred past the 15 September deadline and assigned to the product team; never answered since.
- **Question:** does a **permit** appear on a quotation's **Resources** table — as a priced line, an unpriced line, or not at all — and if it does, what does converting it to a job produce?
- **Sources checked:**
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → NOT DONE *Permit line items in Resources*, [UAT 2]. The session sheet: *"Figure out the permit functionality in **Resources**. Product team to figure this out. **Not to be included in the 15 September deadline.**"* The register: *"Still deferred. The product team owns the definition… Still undefined."*
  - **The one adjacent client statement, and it cuts across this:** [../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md) (`status: verified`, Joe Schacatano) — a quotation carries **billing codes only**; resources are dispatch-side. Quoted in that note, Joe at 40:17 names what a 100-ton quote contains: *"100 ton operator load, **travel permit**, and a surcharge. That's it."* **So a permit is on his estimate as a billing code — which is an answer to a different question than the one UAT 2 asked**, because UAT 2 asks about the *Resources* table. Do not read the one as settling the other.
  - [../decisions/2026-09-11-quote-to-project-permits-plans-flow.md](../decisions/2026-09-11-quote-to-project-permits-plans-flow.md) covers the quote→project permit flow but not a Resources line.
  - [../decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md](../decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md) — Melissa McNutt: *"we don't bill the annuals to customers"*, so at least one permit class is not a customer-facing line at all.
  - Related, already open — do not duplicate: [*Quote line items vs dispatch resources…*](#quote-line-items-vs-dispatch-resources--the-associated-set-auto-fills-the-quote-and-the-sales-owner-says-dispatch-resources-must-not-be-quoted), which asks what the Resources table is *for*. This entry is a sub-case of it and should be answered after it.
- **Note:** a UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md). This one is unusual: the row is itself a **deferral**, so the register records that nobody has decided, which matches the vault.
- **Blocked:** any permit work on the quotation Resources tab; the post-15-Sep permit-class work.
- **Owner:** the product team, per the UAT 2 sheet's own words — Joe Schacatano for what belongs on an estimate, Liz Lopez for the permit side.

## Billing Code Flags and Surcharge checkboxes — the expected behaviour was never defined

- **Status:** open
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register into the module registers. Raised in **UAT 1**, never answered.
- **Question:** on **Edit Billing Code → Flags and Surcharge**, what is each checkbox supposed to do? Specifically, what does `applySurcharge` mean for a code that is never quoted, what do the other flags on that panel gate, and does any of them interact with the one-surcharge-per-quote rule?
- **Sources checked:**
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → NOT DONE *Billing Code Flags and Surcharge checkbox behaviour*, [UAT 1]. The session sheet: *"Under **Edit Billing Code > Flags and Surcharge**, the checkbox behaviour needs to be confirmed/figured out."* The register: *"Deferred to the product team — the expected behaviour was never defined, so there is nothing to build or verify against."*
  - **The nearest written rule, which covers only one of the checkboxes:** [../decisions/2026-09-02-one-surcharge-per-quote.md](../decisions/2026-09-02-one-surcharge-per-quote.md) (Melissa McNutt, `status: verified`) — *"Per line, only **membership** varies — `BillingCode.applySurcharge` decides whether a line is inside the surcharge base."* That gives `applySurcharge` a meaning; it gives the rest of the panel none.
  - Still open next to it: [*The surcharge is blanket in the contract but per-resource in the model, and it has no name*](#the-surcharge-is-blanket-in-the-contract-but-per-resource-in-the-model-and-it-has-no-name) — (a) *"The T&C is unconditional…; should the ERP enforce that, or is per-line opt-out intended?"* **That is the same question this UAT row asks, from the contract end.** Answer them together.
  - [billing-code-and-price-list.md](billing-code-and-price-list.md) — no per-flag semantics. [../decisions/2026-09-11-billing-code-type-master-dropped.md](../decisions/2026-09-11-billing-code-type-master-dropped.md) touches the type field, not the flags.
- **Note:** a UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md). This row asks for a definition rather than a change, so there is nothing here to build from and nothing to verify against; that is the finding.
- **Blocked:** verification of the Flags and Surcharge panel (QA has no expected behaviour); the per-line surcharge opt-out question above.
- **Owner:** Melissa McNutt (she owns the surcharge rule) with Joe Schacatano.
- **Update 2026-10-22 (10-21 walkthrough, CodingCops describing the build, `unverified`):** ehtesham.anwar
  showed the edit form with **taxable** and **apply surcharge**. With apply surcharge **off**, the line
  takes **no** surcharge — neither the general one nor a customer price list's — and his example was the
  **operator** (36:55). That is the build's meaning, consistent with
  [../decisions/2026-09-02-one-surcharge-per-quote.md](../decisions/2026-09-02-one-surcharge-per-quote.md);
  no TCG owner confirmed it or said what **taxable** gates. Source: [2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md](../meetings/2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md) §7.

## A billing code rate may never be zero — shipped and enforced at every layer, adjudicated by nobody

- **Status:** open
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register into the module registers. Not a ticket question: the work is done; what is missing is the decision behind it.
- **Question:** is *"a billing code's default rate must be greater than zero"* a **product rule**, or an expedient? It is in production, enforced on create and on edit, server and client, and **no named human is recorded as having decided it.** Two halves need a line each: **(a)** may a billing code legitimately have a `0` rate — a no-charge or included code — and if so how is that expressed now? **(b)** the UAT 3 wording asks for a different thing from the UAT 1 wording (see below) — is a zero rate *invalid input*, or a *reason not to create the code at all*?
- **Sources checked:**
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) → **DONE** *Billing code rate can never be zero*, [UAT 1] — *"Enforced at every layer — API validation on create and edit, and the same rule client-side. Also fixed for price listings in the same commit. Raised again in UAT 3."* sha `ba99841ee`.
  - The two session sheets do **not** say the same thing. UAT 1: *"The **Billing Code default rate** should not be zero. Please add a restriction to prevent this."* UAT 3: *"In Resources > Quotation: Billing Code default is set to 0. **If the Billing Code is [0], the Billing Code should not be created.**"* The first is a field validation; the second is a creation gate keyed on a value the *quotation* showed. One row was built; nobody checked whether the other was the same request.
  - In code, as shipped: `apps/api/src/presentation/billing-codes/dto/create-billing-code.dto.ts:57-60` — `@IsNumber() @IsPositive() defaultRate!: number`; `update-billing-code.dto.ts` extends `PartialType(CreateBillingCodeDto)`, so edit inherits it; `apps/web/src/features/billing-codes/schemas/billing-code.schema.ts:33-39` — *"Default rate must be greater than 0"*; `apps/web/src/features/billing-codes/views/create-billing-code-modal-base-fields.tsx:79`.
  - [../decisions/](../decisions/) — **nothing.** No note decides a billing-code rate floor. The only adjacent rule is about a different object: [../decisions/2026-08-31-quotation-resource-rate-whole-dollars.md](../decisions/2026-08-31-quotation-resource-rate-whole-dollars.md), a **quotation resource** rate — *"not a number, or `<= 0` → `Rate must be greater than 0`"*.
  - **Evidence that zero rates exist upstream, not against the rule but worth answering first:** [*Billing-rate effective dating for pricing sheets — raised by the client, no design yet*](#billing-rate-effective-dating-for-pricing-sheets--raised-by-the-client-no-design-yet) records that FCC's `UNION_CRAFT.BillingRate` is *"0.000 on every sampled row"* — a dead path there, but it means a `0` rate is representable in the system this one imports from.
- **Note:** a UAT row is an ask, not intent — [../uat/INDEX.md](../uat/INDEX.md). This is the pattern most worth flagging: **a pricing rule reached production from a UAT bullet, with no decision note behind it.** Recording it does not question the rule; it gives it a place to be confirmed or unwound.
- **Blocked:** nothing hard — the rule is shipped and reversible. Recorded so it does not become settled product intent by being old.
- **Owner:** Joe Schacatano (billing codes are his to price) with Melissa McNutt.

## Employee Billing Code and Employee Pay — pointer, owned by payroll

- **Status:** open — **answer owned by payroll**, per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*.
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register.
- **Why it lands here too:** billing codes are this module's object. If an employee's pay ever derives from, or constrains, their billing code, then a billing code stops being purely a pricing artefact and the create/edit rules in this register change shape.
- **Read:** [../payroll/gaps.md → *Employee Billing Code and Employee Pay…*](../payroll/gaps.md#employee-billing-code-and-employee-pay--asked-in-uat-1-never-answered-and-the-schema-keeps-them-independent)

## Tool and Rigging allocation from the quotation — pointer, owned by assets

- **Status:** open — **answer owned by assets**, per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*.
- **Asked:** 2026-09-19 — logging the 2026-09-18 UAT register.
- **Why it lands here too:** the UAT 1 ask is that tool & rigging allocation *"come from the quotation"*, so it asserts a quotation→job carry-over for a resource class. It runs straight into [*Quote line items vs dispatch resources…*](#quote-line-items-vs-dispatch-resources--the-associated-set-auto-fills-the-quote-and-the-sales-owner-says-dispatch-resources-must-not-be-quoted) and the `verified` [2026-09-16 decision](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md), under which dispatch-side resources are not quotation lines at all.
- **Read:** [../assets/gaps.md → *Tool and Rigging allocation from the quotation…*](../assets/gaps.md#tool-and-rigging-allocation-from-the-quotation--who-supplies-it-in-what-form-and-how-it-reaches-the-job)

## Is the quotation builder supported on tablet, and at which breakpoint?

- **Status:** resolved — see [decisions/2026-09-22-tablet-is-an-active-conversion-target-for-the-web-portal.md](../decisions/2026-09-22-tablet-is-an-active-conversion-target-for-the-web-portal.md). **Partially:** the build-scope half of (a) is answered; the client-facing support claim and half (b) are carried forward as separate open entries — see *Resolution* below. Everything above and below this line is left intact as the record of what was in question.
- **Asked:** 2026-09-21 — PR review of the Resources-table surcharge toggle hit-target / touch-visibility fix (`fix/quotation-surcharge-toggle`). Corrected 2026-09-22 on PR #630 / overlay #104 review: the first draft filed this as Unsourced and omitted the RFP device matrix. No ticket.
- **Question:** two halves. **(a)** Is the **quotation builder** (create/edit Resources table, including hover-revealed per-row affordances) a supported surface on **tablet** for Sales / Estimating? **(b)** If yes, at which breakpoint (e.g. `md` 768 / `xl` 1280)? Half (a) already has a written answer that says *no*; half (b) has no number attached to this screen.
- **Sources checked:**
  - **[Contradicts "yes"]** [../admin/tcg-erp-rfp-2026-02-26.md](../admin/tcg-erp-rfp-2026-02-26.md) §5 *User base* (≈line 155), `status: unverified`, `conflicts_with: []` — the vault's **only device matrix**. Sales / Estimating → *"Desktop (Mac/Windows)"*; Dispatch, Field Crew, and Mechanics each get tablet explicitly. The quotation builder is the Sales / Estimating surface. That is a written *no*, not a blank. **Weigh it honestly:** the file is a **draft** RFP (Feb 2026, pre-vendor-selection); an "access method" column is not a breakpoint spec; it names **no breakpoint** at all; nobody has adjudicated it.
  - [../admin/responsive-design-and-security-posture.md](../admin/responsive-design-and-security-posture.md) §Part 1 (≈lines 42–43), `status: unverified` — nearest breakpoint numbers in the vault: Tailwind v4 defaults, noted as exceeding *"the client's stated minimum of 768px and 1280px."* That is a **vendor paraphrase** of a client requirement whose original is not in the vault. It does not name the quotation builder. Belongs here as the nearest miss for half (b), not as a settlement of half (a).
  - [../claude/contexts/web.md](../../claude/contexts/web.md) → *Misc* — *"Touch targets ≥ 44px."* Build rail only; names no supported device set.
  - **Documented vs shipped, not doc vs doc.** Main-repo commit `1242f593e` *"iPad and Mobile responsiveness Web 1.0"* (2026-08-19) shipped iPad responsiveness app-wide with no ticket and no source, against the February RFP that said desktop for Sales. Nobody reconciled the two. Same commit already recorded as sourceless in [*Max travel time on the quotation detail…*](#max-travel-time-on-the-quotation-detail--meaning-traffic-model-origin-yard-and-degraded-state) (≈line 2213) — cross-link rather than restate.
  - Code precedent only (not product intent): the Resources-table **"New Item"** insert already forces itself open on `(hover: none)`; the surcharge toggle on this branch mirrors that. Precedent in code ≠ overturning the RFP matrix.
  - This module's INDEX / quotation.md / quotations.md — no tablet-support statement for the builder. No `vault/conflicts/` stub (`conflicts_with: []` on the RFP).
- **Note:** the `(hover: none)` half of `fix/quotation-surcharge-toggle` permanently reveals **Surcharged** on coarse pointers — it **assumes yes** on half (a). That assumption sits on the unadjudicated `1242f593e` base, not on a product decision. Half (a) should be confirmed or walked back by a named human; half (b) stays open until then (or forever, if half (a) stays *no*).
- **Blocked:** nothing on the 44px hit-target half of the PR (build rail). Blocked: treating tablet quotation-builder support as settled, or claiming a breakpoint for this screen, without Brian Petros reconciling the RFP matrix against `1242f593e`.
- **Owner:** Brian Petros — he owns both sides of the divergence (RFP author / submission contact, and the client addressee of the responsiveness posture).
- **Resolution (build scope only), 2026-09-22** — **Syed Haris** (hariscops, syed.haris@codingcops.com), CodingCops developer, in a Claude Code session during closeout of `fix/quotation-surcharge-toggle` (main-repo PR #630, overlay PR #104). He requested and reviewed that work. Verbatim: *"we've desktop first, now converting to tablet, so it shouldn't be any issue"*, and earlier that providing tablet-responsive UI *"is an engineering and product decision"*. Meaning: RFP §5's `Sales / Estimating → Desktop (Mac/Windows)` describes the **pre-conversion** state and is **stale**, not a live constraint; tablet is an **active conversion target** for the web portal including the quotation builder; `1242f593e` was that conversion starting, **not** a violation of the RFP. Recorded in [decisions/2026-09-22-tablet-is-an-active-conversion-target-for-the-web-portal.md](../decisions/2026-09-22-tablet-is-an-active-conversion-target-for-the-web-portal.md), `status: reference` — a vendor-side engineering statement, binding on the CodingCops build, open to being overruled by TCG.
- **Not resolved — do not read the above as more than it is.** **Not** adjudicated by Brian Petros, by TCG product, or by anyone client-side; Brian never answered. So (i) the **client-facing support claim** — whether TCG is *promised* tablet support for Sales / Estimating, which drives QA / UAT device coverage and what may be claimed contractually — is **still open**, and (ii) Haris named **no breakpoint**, so half (b) is **still open** and no number is attached to this screen. Both carried forward in [*Is TCG promised tablet support for Sales / Estimating…*](#is-tcg-promised-tablet-support-for-sales--estimating-and-at-which-breakpoint). A consequence of tablet entering scope is filed in [*Touch-target rail for a tablet-targeted web surface…*](#touch-target-rail-for-a-tablet-targeted-web-surface--44px-or-48px).

## Is TCG promised tablet support for Sales / Estimating, and at which breakpoint?

- **Status:** open — the unanswered remainder of [*Is the quotation builder supported on tablet…*](#is-the-quotation-builder-supported-on-tablet-and-at-which-breakpoint), which the 2026-09-22 decision closed only on build scope. Nobody client-side has answered.
- **Asked:** 2026-09-22 — closeout of `fix/quotation-surcharge-toggle` (main-repo PR #630, overlay PR #104), splitting the client-facing half off the resolved entry so it does not vanish with it. No ticket.
- **Question:** two halves, both still blank. **(a)** Is TCG **promised** tablet support for Sales / Estimating — i.e. is tablet a *supported device* for the quotation builder in the sense that QA / UAT must cover it and that it may be claimed contractually? **(b)** If yes, at which breakpoint (e.g. `md` 768 / `xl` 1280)? A **one-line reply resolves (a)**: *"Is tablet a supported device for Sales / Estimating in the delivered platform — yes or no? If yes, down to what width?"*
- **Why this is not answered by the 2026-09-22 decision:** that decision is a **vendor developer's** statement about build direction ([decisions/2026-09-22-tablet-is-an-active-conversion-target-for-the-web-portal.md](../decisions/2026-09-22-tablet-is-an-active-conversion-target-for-the-web-portal.md), `status: reference`). "We are converting to tablet" is not TCG accepting a supported-device commitment. Converting a surface and being contractually on the hook for it are different claims with different owners.
- **Sources checked:** unchanged from the parent entry — [../admin/tcg-erp-rfp-2026-02-26.md](../admin/tcg-erp-rfp-2026-02-26.md) §5 (the vault's only device matrix, `status: unverified`, draft, names no breakpoint) and [../admin/responsive-design-and-security-posture.md](../admin/responsive-design-and-security-posture.md) §Part 1 (a vendor paraphrase of *"the client's stated minimum of 768px and 1280px"*, original not in the vault, names no screen). Nothing added since.
- **Blocked:** QA / UAT device coverage for Sales / Estimating screens; any contractual or status-report claim of tablet support; attaching a breakpoint number to the quotation builder.
- **Owner:** Brian Petros — RFP author / submission contact, and the client addressee of the responsiveness posture. Unchanged from the parent entry; he has not answered.

## Touch-target rail for a tablet-targeted web surface — 44px or 48px?

- **Status:** open
- **Asked:** 2026-09-22 — closeout of `fix/quotation-surcharge-toggle`, as a consequence of [decisions/2026-09-22-tablet-is-an-active-conversion-target-for-the-web-portal.md](../decisions/2026-09-22-tablet-is-an-active-conversion-target-for-the-web-portal.md) putting tablet in scope for the **web** portal. No ticket.
- **Question:** which touch-target minimum applies to a **tablet-targeted `apps/web` surface** — the quotation builder among them? The two build rails disagree and neither covers the case: [../../claude/contexts/web.md](../../claude/contexts/web.md) → *Misc* says *"Touch targets ≥ 44px"*, [../../claude/contexts/mobile.md](../../claude/contexts/mobile.md) says *"Touch targets ≥ 48px, not web's 44px"*. A coarse-pointer web surface sits between them and **nothing written says which applies**. A one-line reply resolves it: *"On a coarse pointer in `apps/web`, is the minimum 44px or 48px?"*
- **Note:** **cross-module, filed here only because this work surfaced it.** It is a *build rail*, not product intent: its answer belongs in `claude/contexts/web.md` (and/or `mobile.md`), written by a human from an accepted reflection per `CLAUDE.md` → *One memory, every tool*. It is **not** the WCAG / conformance question open in [../admin/gaps.md](../admin/gaps.md), which is about the conformance target itself and stays open and untouched. No answer is invented here: the 44px half of `fix/quotation-surcharge-toggle` shipped against the existing web rail, which is what the rail said at the time.
- **Blocked:** nothing shipped. Blocked: stating a single touch-target minimum for tablet-targeted web work, and reviewing such work against one.
- **Owner:** CodingCops engineering — the rails in `claude/contexts/` are internal build conventions, not a TCG decision.

## Send Quotation modal — what the preview shows when the Subject box is empty

- **Status:** open
- **Asked:** 2026-09-24 — PR review of `fix/tcg-40-empty-subject-email-preview` (Linear TCG-40, Path C — `aidlc/processed.log:140`). No `SCRUM-###`. tcg-scrum escalation.
- **Question:** when the Subject box is empty and the API preview subject has not loaded yet, should the web preview show **(a)** a neutral note — the branch ships *"(default subject will be used)"* — or **(b)** the real API-seeded subject (`Your New TCG Quotation — <quoteNo>`), waiting on it if necessary? A one-line reply resolves it: *"Empty Subject in the Send Quotation preview: show the note, or show the real default subject?"*
- **Candidates:**
  - [../uat/sessions/uat-session-4.md](../uat/sessions/uat-session-4.md) item 9 (Umair Khan, session 2026-09-14, `unverified`) — asks that the email subject become *"Your New TCG Quotation"* instead of *"Your Crane Service Quotation"*. It is about the **sent** subject. It says nothing about the preview, the empty state, or a ` — <quoteNo>` suffix.
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md) line 215 (Fouzan Shakil, 2026-09-18, `unverified`) — NOT DONE. Records that the modal still falls back to the old wording in preview. That is an as-built observation. The register says of itself that it is *"never a source for a spec"*.
  - [quotations.md](quotations.md) lines 31–32 (punch list, 2026-07-14, `unverified`) — *"Need to demand text from TCG team for email"*; *"Add TCG: in subject"*. That second item asks for a different subject form from both the UAT ask and the string the API sends. Nobody has reconciled them.
  - [*Is "Pre-Quote" being retired in customer-facing copy, and who signs off the send-email text?*](#is-pre-quote-being-retired-in-customer-facing-copy-and-who-signs-off-the-send-email-text) (open) — covers who owns the send-email wording in general. It does **not** cover the subject preview or its empty state. Cited here, not restated.
  - `decisions/` — nothing on the email subject or the preview.
- **Note:** retiring the old wording from the preview is sourced as a UAT **ask**, not as adjudicated intent. Neither option (a) nor option (b) is sourced. The API's ` — <quoteNo>` suffix is also unsourced against UAT 4 #9's bare *"Your New TCG Quotation"*. The branch changes only the preview; the delivered subject is untouched.
- **Blocked:** nothing hard — send is unaffected. Blocked: calling the TCG-40 empty-state preview behaviour sourced, and closing the UAT register row 215 as "preview matches what is sent".
- **Owner:** Ryan Adams / Joe Schacatano (quotation send), as in the send-email-text entry above.

## Availability at quote time — what sales can see before quoting

- **Status:** open
- **Asked:** 2026-09-24 — ingesting [../meetings/2026-09-22-erp-live-demo-02-project-schedule-permits-das-allocation-and-vendors.md](../meetings/2026-09-22-erp-live-demo-02-project-schedule-permits-das-allocation-and-vendors.md) §2–§3.
- **Question:** what should a salesperson see about **equipment availability** while quoting, and how far ahead? Brian Petros raised it on the 2026-09-22 demo (transcript 1:04:53–1:05:48) as the *"feedback loop"* from dispatch back to sales: *"the sales coordinators are saying, okay, now we need to find out what is available"*. He wants something flexible enough for *"last minute emergency jobs"* that also shows *"the best availability of allocation"* for *"two months, six months from now"*. He called it *"a struggle… in our current system"* and deferred it to *"maybe next time"*.
- **Dev response (not scope):** ehtesham.anwar floated (1:07:20) a quick hint of how many of the chosen crane class are free on the quoted dates, and later an availability-first flow (pick crane and dates, see availability, then *Create quotation*). He put the second after the accounting loop. He also floated an emergency-SLA notification to DAS for won quotations starting within 2, 6 or 12 hours.
- **Sources checked:** [*Sell-side scheduling artefacts — no vault coverage*](#sell-side-scheduling-artefacts--no-vault-coverage) (the Job Schedule Master and Geographic Heat Map were shared on 2026-08-12 but are not in the vault); [*Quote line items vs dispatch resources…*](#quote-line-items-vs-dispatch-resources--the-associated-set-auto-fills-the-quote-and-the-sales-owner-says-dispatch-resources-must-not-be-quoted). If quoting and dispatch schedule different things (Ehtesham, 8:27 on the same call), then "availability" at quote time has to be defined against one of them. Nothing written defines it.
- **Blocked:** any availability indicator on the quotation builder; any "emergency job" definition or SLA.
- **Owner:** Brian Petros (raised it), with Joe Schacatano / Ryan Adams for what sales needs to see.

## Does a quotation carry sales tax at all, and if so on which amount?

- **Status:** open
- **Asked:** 2026-09-28. Linear TCG-51 (quotation PDF total), which asks this in its own words: *"Should quotes have tax at all? If yes, on which amount (before or after discount)? A named person must decide."* `.ai/aidlc/` has no TCG-51 folder, so there is no `spec.md` §12 to hold it. tcg-scrum.
- **Question:** three one-line answers. **(a)** Does a TCG quotation carry sales tax, yes or no? **(b)** If yes, is it charged on the pre-discount subtotal or on the total after discount, price hike and surcharge? **(c)** If yes, must it also show on the quotation screens, the print view and the send-email body, not only on the PDF?
- **Candidates:**
  - [../decisions/2026-09-28-quotation-pdf-carries-no-tax.md](../decisions/2026-09-28-quotation-pdf-carries-no-tax.md) (Jz-Nd, TCG-51, `reference`, **developer, not product**). An interim ruling: the PDF prints no tax and no Sales Tax row until this is answered. It does not answer (a)–(c).
  - [billing-code-and-price-list.md](billing-code-and-price-list.md):73 and [fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md):383, :389 (2026-09-04, `unverified`). TCG on the FCC billing-code slides: *"Taxable: Not needed"*, *"We don't use/need 'Taxable'"*. This covers the per-billing-code flag only. It does not say TCG charges no tax, and it says nothing about quotation-level tax.
  - [../meetings/transcripts/2026-03-20-fcc-fields-screens-review.md](../meetings/transcripts/2026-03-20-fcc-fields-screens-review.md):83 (meeting statement, not a decision, `unverified`). On the customer *Taxable* field: *"The taxable we don't charge sales tax unless it's a. I would keep taxable because if we do bare rentals and stuff, I think ideally we're supposed to be charging tax."*
  - [../meetings/transcripts/2026-07-28-invoicing-details-contracts-certs-trainings.md](../meetings/transcripts/2026-07-28-invoicing-details-contracts-certs-trainings.md):133, :135, :142 (meeting statements, not decisions, `unverified`). Kyle Harlow: *"we should be charging the customer sales tax based on their location"*; *"every county and city, well, not everyone, but they all have their own sales tax. And that's something we'll have to build out for anything that we charge."* ehtesham.anwar: *"We are going to add that sales tax only to tools and rankings that we are billing for the adding within the invoice for the customer."* **Contrary evidence:** these are about invoices and bare rentals, not the quotation PDF, so they do not conflict with the interim PDF ruling. They do show tax is a live concern for TCG, so (a) is **not** presumptively "no".
  - [../accounting/avalara-sales-tax-in-nexgen.md](../accounting/avalara-sales-tax-in-nexgen.md):36–40 (FCC guide, 2024-07-01, `unverified`). Avalara taxes invoices only, and quote tax is *"not available in this release"*. This is FCC reference, not a TCG requirement.
  - [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md):224 (UAT 1, `unverified`). *Quotation email PDF shows the wrong total*, NOT DONE. The mismatch came from tax that only the PDF added.
- **Note:** before TCG-51, the PDF was the only surface that added tax. It printed a Sales Tax row on every quote ($0.00 for web-created ones), on a base that counted grouped lines two or three times ($1,448 → $231.61 at 9.5% instead of $137.56). `isTaxable` has no web writer, so only API, seed, import or migration quotes could be taxable. Related open entries, not re-raised here: [*"Final Amount" means two different numbers*](#per-row-surcharge-now-has-no-ui-on-createedit-and-final-amount-means-two-different-numbers) and [Q-24](#q-24--list-and-summary-disagree-on-resource-less-quotation-totals).
- **Blocked:** printing any tax on the quotation PDF or showing it on screens; the meaning of the stored `tax` column (send no longer rewrites it, and see [*Quotation duplicate*](#quotation-duplicate--what-a-copy-carries-and-what-a-fresh-copy-resets) (c)); product sign-off of TCG-51.
- **Owner:** Joe Schacatano (sales, quotation pricing) with Melissa McNutt, and Ryan Adams (quotation send). Accounting should be consulted if invoice tax must match.
- **Update 2026-10-22 (10-21 walkthrough, `unverified`) — new evidence for (a), not an answer.** Ryan
  Adams (Sales Manager, speaking on the room microphone labelled "Brian Petros", 51:59–52:41): materials
  going to a site are taxed at **that city's rate**; he wants the tax set **on the quote, editable**, and
  carried through to the invoice — *"if we were going to buy something, it would go into the quote, but
  we would need somewhere where we could change the amount of tax"*. ehtesham.anwar: not possible now,
  *"We'll update the functionality while adding in the quotations"* (52:57). The billing code and the
  vendor in the build both carry a **taxable** flag (§7, §9), against TCG's *"Taxable: Not needed"* on
  the FCC slides. Sources: [2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md](../meetings/2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md) §9 and *Against the vault*; transcript
  [2026-10-21-erp-demo-walkthrough-part-1.md](../meetings/transcripts/2026-10-21-erp-demo-walkthrough-part-1.md). This is the second TCG manager (after Kyle, 2026-07-28) to want tax by
  job-site location, so (a) leans **yes, on taxable lines**; Joe has still not ruled.

## Additional Information on a quotation — does a sent quote freeze it, and what is the PDF heading called?

- **Status:** open
- **Asked:** 2026-09-28. Linear TCG-123 (UAT remediation, *"Additional Info: saving a sub-category template wipes saved answers"*), whose **Blocked / needs decision** section asks both (a) and (b) in its own words and says *"Ask before choosing."* `.ai/aidlc/` has no TCG-123 folder, so there is no `spec.md` §12 to hold them. Raised from UAT: `17sep-internal-uat.md:84`, *"Need to see mapping of additional info"*, via [../uat/register-2026-09-18.md](../uat/register-2026-09-18.md).
- **Question:** three answers. **(a)** When a quote is sent (or signed), should it keep a fixed copy of its Additional Information: the field labels, section names and answers as they were at that moment? Or should it always re-render against the sub-category's current template? **(b)** The customer PDF and the browser print show a quote's Additional Information under the heading **"Other Information"**. That name is already used for a different group on the same quotation: Billing Type, Industry Code, Valid Until, Certified Payroll and Lost Reason (`other-info-section.tsx:12`, `main-tab.tsx:754`). Should the PDF and print heading be renamed to "Additional Information", as on the quote editor and view tab? The asset tab says "Additional Info". **(c)** Lower priority: should a template field carry a unit (ft, tons, lbs)? And may a field's type be changed after answers exist? No unit is modelled anywhere. Numbers and ranges are stored as strings. `CustomField.type` is a free `VarChar(100)`, editable after the fact, and nothing migrates the answers already saved under the old type.
- **Why it matters:**
  - **(a)** `QuotationRevision` (`schema.prisma`, `QuotationRevision`) stores status, totals and resources only, not Additional Information. A quote sent in March re-renders its Additional Information against today's template, so a signed PDF and a later re-print of the same quote can disagree about labels and sections. Answers are kept by field id since TCG-123, so a rename changes the label but not the value.
  - **(b)** Two different things print under one name on a customer-facing document.
- **Candidates:** none. No `decisions/` note covers quotation snapshotting or this heading. [../assets/gaps.md](../assets/gaps.md) → *"Saving a sub-category template re-mints every field id…"* is the related identity question, which TCG-123 fixed in code (update 2026-09-28 there); it does not answer (a)–(c).
- **Note:** what TCG-123 did ship, on branch `fix/misc-fixes-2026-09-25`:
  - A template save now keeps field ids.
  - The editor, view, print and PDF all resolve a line's sub-category by its stored id, with a name fallback only for lines saved without one. Archived sub-categories are included.
  - The PDF no longer dumps raw `fieldId: value` pairs, and it looks up sub-categories with the quote's tenant explicit.
  - The PDF heading was **left as "Other Information"**, and no snapshot was added, pending this entry.
  - The public PDF route itself is unchanged. It remains [Q-01](#q-01--public-pdf-endpoint-has-no-authentication) / Q-03 / Q-05's to fix.
- **Blocked:** any snapshot of Additional Information on send, revision or sign; renaming the PDF and print heading; unit or type-change handling on template fields; product sign-off of TCG-123.
- **Owner:**
  - (a) Ryan Adams (quotation send) with Joe Schacatano (sales), because it decides what a signed quote legally showed.
  - (b) Joe Schacatano.
  - (c) Brian Petros, who owns template field identity in the assets entry.
- **Update 2026-10-23 (10-22 walkthrough part 2):** ehtesham.anwar (41:34) said the sub-category
  attributes on a quote line had two intended uses — details of the asset, and lift information like
  FCC's — and that lift planning *"now … we need to figure out … separately, so we might want to change
  this structure."* If lift information leaves the attributes, (a) and (b) here cover asset details only.
  Where lift information lives is not decided: FCC holds it per job quote
  ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md), `unverified`). Source: [2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md](../meetings/2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md) §6.

## Editing a quotation — should opening it re-apply the customer's price list, and re-price a draft?

- **Status:** open
- **Asked:** 2026-09-28, from a read-only audit of false "unsaved changes" warnings (the leave-page modal appearing on forms nobody edited), on branch `fix/misc-fixes-2026-09-25`. No ticket; Jz-Nd.
- **Question:** two answers. **(a)** When someone opens an existing quotation to edit it, should the form re-apply the customer's **current** price list, or keep the one the quote was saved with? **(b)** When someone opens a **draft** quotation's Resources tab, should its lines be re-priced to today's rates automatically? And if so, is that a change the user must save or discard, triggering the leave warning?
- **Why it matters:**
  - **(a)** `views/use-quotation-customer-data.ts` refetches the customer on every open (`refetchOnMount: 'always'`) and calls `handlePriceListUpdate` (`create-quotation-form-model.ts`). That overwrites `customerPriceList`, and sets `priceListSource: 'master'` when the customer has none. The edit mapper seeds `customerPriceList` from `quotation.priceList ?? customer.priceList` (`edit-quotation.mapper.ts`).
  - When the two differ, the result depends on timing. The dirty check snapshots its baseline 500 ms after mount (`use-quotation-dirty.ts`, `SETTLE_MS`). If the fetch lands later, the untouched quote shows the leave warning. If it lands earlier, the change is silently folded in and saved with the next edit. Either way nobody decided it.
  - **(b)** `useRepriceDraftResources` (`components/organisms/resources-tab.tsx`) runs `applyResolvedPricing` on first mount of the Resources tab. It rewrites rate, unit, discount, surcharge and amount on draft lines, so the draft then counts as edited.
- **Candidates:** none found. No `decisions/` note covers re-applying a price list on edit or re-pricing drafts.
- **Note:** fixed separately on the same branch: the display-only `referenceRate` that the Resources tab resolves on open no longer counts as an edit. The timing-dependent 500 ms baseline itself is fragile and should go once (a) and (b) are settled. The baseline would then be the mapped quote, not "whatever the form looks like after half a second".
- **Blocked:** a deterministic dirty check for quotation edit; any work on re-pricing drafts.
- **Owner:** Joe Schacatano (sales, quotation pricing), with Melissa McNutt for the customer price-list side.

## Several main cranes on one quotation — how are the crane packages grouped, and how does dispatch see them?

- **Status:** open
- **Asked:** 2026-09-28, from Brian Petros's Teams thread of Thursday 2026-09-24 (early morning PKT), pasted into the session by syed.haris on 2026-09-28. Not otherwise in the vault. Raised originally by **Ryan Adams**, relayed by Brian.
- **Question:** When one job needs **two or more main cranes, each with its own crew and support
  loads** (Brian's example: a 550-ton package plus a 90-ton package), is that **one quotation / one
  job with explicit crane groups**, or does sales keep splitting it into separate quotations / jobs
  as it does in FCC today? And if it is one quotation, what do the customer PDF, the job and DAS show
  per group?
- **What TCG said:**
  - Brian (relaying Ryan): *"sales is currently creating two separate quotes/jobs… so that dispatch
    can easily see (and assign) the vehicles/employees separately (in groups)… even though they are
    both for the same Job."* He expects the ERP to *"record 'groupings' of vehicles/employees… so that
    we have a single Quote/Job for the customer… AND… dispatch will still be able to easily
    see/assign the vehicles/employees in specific 'groups'."* He wants Joe, Kyle and Ryan to explain
    it on the next crane-configuration call.
  - A second message in the thread reports an **FCC data query**. FCC quotations do carry 2, 3, 4, 5,
    7 and even 9 main-crane `QuoteUnit` rows (MC/CR/RT/SL). The grouping is **implicit, by line
    order only**. `OM-40822` is a 550 Ton Main Crane at line 1, its tractors, operator load and
    support loads 1–10 on lines 2–23, then a 90 Ton Main Crane at line 24 with tractor and operator
    load on 25–26. `OM-40920` is a 190-ton crane at line 1 (support to line 8), then a 175-ton crane
    at line 9. The raw `QuoteUnit` has **no parent / group / configuration key** (`QuoteUnitID,
    QuoteNumb, LineNumb, UnitSchedType, UnitTypeID, UnitCode, LoadNo`). `LoadNo` and
    `SourceUnitCode` are empty on every multi-main example, and `GroupNumb` is header-level.
    **`OM-40959` has two main cranes both on `LineNumb = 1`**, so line number is not a usable key.
    The message recommends *"an explicit Main Crane Group identifier rather than… infer[ring] grouping
    from FCC line order"*, *"for us to discuss with Joe/Kyle/Ryan/Lisette."*
  - abdulrehman replied in the thread that the current ERP already supports several cranes, each with
    its own crew and support load, and that a meeting would still help.
- **What the build does (checked 2026-09-28, not a product answer):** grouping is **explicit**.
  `QuotationResource.parentId` and `JobResource.parentId` (`apps/api/prisma/schema.prisma`) form a
  tree per crane. The associated set hangs under its crane row, and
  `apps/api/src/usecase/projects/materialize-job-resources.ts` builds each crane's deeper levels
  under that crane on conversion. DAS computes missing components per parent
  (`usecase/das/missing-required-components.util.ts`). So two crane packages on one quotation are two
  separate trees. That is the key the FCC query found missing. Still unchecked against TCG's
  expectation: whether the **customer PDF** shows the packages as groups, and whether the DAS job card
  **visually groups** slots by crane.
- **Related:** the 2026-09-22 demo showed per-crane **permit coverage** on a two-crane quotation
  (*Individual* vs *Combined*): [../projects-jobs/gaps.md → *Artifact coverage model*](../projects-jobs/gaps.md#artifact-coverage-model--individual-vs-combined-and-whether-the-choice-is-permanent).
  What a quote line is at all is still open:
  [*Quote line items vs dispatch resources…*](#quote-line-items-vs-dispatch-resources--the-associated-set-auto-fills-the-quote-and-the-sales-owner-says-dispatch-resources-must-not-be-quoted).
  For the *assist* crane that is needed only on some days, see
  [../dispatch/gaps.md → *An assist crane needed only on some days of a multi-day job*](../dispatch/gaps.md#an-assist-crane-needed-only-on-some-days-of-a-multi-day-job--setup-and-breakdown).
- **Migration note:** FCC history can't be split into groups reliably (implicit order, duplicate line
  numbers). Any import of multi-main FCC quotes needs a rule or a manual pass.
- **Blocked:** nothing in the build today. Blocked: calling multi-crane quotations "done", the PDF
  layout for multi-crane quotes, and FCC quote migration.
- **Owner:** Ryan Adams / Joe Schacatano (how sales quotes it), Lisette Anzaldo (how dispatch needs
  to see it), Kyle Harlow. To be taken on the next crane-configuration call, as Brian proposed.

## Surcharge stepper — one save per burst, and which step size?

- **Status:** **resolved** — [decisions/2026-10-07-surcharge-failed-save-falls-back-to-server-value.md](../decisions/2026-10-07-surcharge-failed-save-falls-back-to-server-value.md)
- **Asked:** 2026-10-07 — Linear **TCG-103**; UAT register row *"Surcharge +/- fires a toast on every click"* ([../uat/register-2026-09-18.md](../uat/register-2026-09-18.md)), which could not be traced to any UAT session.
- **Question:** on the Billing Codes and Price Listing **Surcharge** cards each +/- click saves at once and raises a success toast, so five clicks give five saves and five toasts. (a) Who raised this, and do they want one save and one toast per burst of clicks (a short debounce, or no success toast for the stepper)? (b) The +/- buttons move by **1** but the box accepts **0.01** steps. Which is right? (c) Should the Billing Codes card use the shared `AdjustmentCard` stepper (44px buttons, already used on Price Listing)?
- **Sources checked:** the six UAT session sheets, the whole vault and the meeting transcripts (by the register and the TCG-103 ticket notes, 2026-09-23). No source found.
- **Update 2026-10-07:** (a) **built on TCG-103** — a burst of +/- clicks is one save and one toast (500 ms trailing debounce), approved by Akif. (b) **both**: +/- move the whole-number part by 1 and keep the decimals (12.5 → 13.5), the arrow keys fine-tune by 0.01, on all surcharge, discount and price hike cards, decided by Akif; a step that followed the typed decimals was built and dropped the same day (too many edge cases in testing). (c) **built on TCG-103** — the Billing Codes stepper restyled to 44px buttons like `AdjustmentCard` (the card itself not replaced), decided by Akif.
- **Resolution (2026-10-07):** all three decided and built on TCG-103, together with the failed-save fix and a single toast slot (`surcharge-update`). The original reporter was never traced; the team decided without them.
- **Owner:** Akif (CodingCops web team), as a UX convention call.

## Invoice lines vs quote lines — pointer, owned by accounting

- **Status:** open — see [../accounting/gaps.md → *Does the invoice carry exactly the quotation's lines*](../accounting/gaps.md#does-the-invoice-carry-exactly-the-quotations-lines--including-the-lines-hidden-inside-mobilizationdemobilization).
  ehtesham.anwar's 2026-10-01 11:34 assumption, unanswered by Joe Schacatano. Filed 2026-10-07;
  ported to overlay main 2026-10-09.

## Email letterhead heading copy and dropped social icons — see admin

- **Status:** open — pointer. The quotation approval, delivery and pre-quote emails are among those
  affected by [../admin/gaps.md#email-letterhead-headings--who-owns-the-heading-text-each-email-shows](../admin/gaps.md#email-letterhead-headings--who-owns-the-heading-text-each-email-shows)
  and [../admin/gaps.md#social-media-icon-rows-removed-from-ticket-and-pre-quote-emails--intended](../admin/gaps.md#social-media-icon-rows-removed-from-ticket-and-pre-quote-emails--intended).
  Filed 2026-10-13 from tcg branch `fix/13-oct-uat` (TCG-37).
- **Owner:** product team

## Should the API enforce billing codes and whole-dollar rates on quote lines?

- **Status:** open
- **Asked:** 2026-10-16 — raised by tcg-executor building TCG-218 U6 (spec §12 Q38c); deferred by the ticket owner (Syed Haris: "No, follow-up").
- **Question:** today only the web blocks a quote line with no billing code ("Billing Code missing.") and rounds ordinary rates to whole dollars; the API (`create-quotation.dto.ts`, `quotations.service.ts` `syncResources`) accepts code-less lines and cents on any line, so another client (mobile, a script) can save what the web would refuse. Should the server enforce both? If so: (a) look the item's billing code up itself, or trust the client's `pricingSource`; (b) custom types only, or every resource type; (c) keep the TCG-218 exceptions — a "Price Adjustment" line inside a Mobilization/Demobilization group may be code-less with a cents rate (D9a, Q38b).
- **Sources checked:** TCG-218 spec REQ-13, D9a, Q38; `units.md` U6 test row (which assumed server rejection).
- **Owner:** ticket owner of a follow-up ticket (none yet).
- **Update 2026-10-23 (10-22 walkthrough part 2, CodingCops describing the build):** a quote on a
  sub-category with no billing code shows *"billing code missing"* to **users with the right access, and
  salespeople do not see it** (ehtesham.anwar, 27:44). The role-based hiding is not in the vault, and it
  sits against [../erp-review-log.md](../erp-review-log.md) *Quotations, jobs and projects (9)*: *"do not
  show quoteable items without valid pricing"*. Source: [2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md](../meetings/2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md) §3.

## Price-list discount plus the quote's own discount or price hike — added, compounded, or exclusive?

- **Status:** open
- **Asked:** 2026-10-21 — ERP demo walkthrough part 1. Brian Petros (41:33–41:53): *"there's a difference
  between a price list that is applied for specific billing codes and a general type of discount because
  … the quote itself … has an option to give a general discount on the entire quote or a price hike … So
  when there's a price list selected and then we also apply that general discount or price hike, it's going
  to combine both of those things together, right?"* ehtesham.anwar answered only on **surcharge**
  precedence (42:09–42:30). Source: [2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md](../meetings/2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md) §8. Filed 2026-10-22.
- **Question:** when a customer's price list carries a **discount %** and the quote also has a
  **quote-level discount or price hike**, which applies? **(a)** both, added (10% + 5% = 15%); **(b)**
  both, in sequence (price-list discount first, then the quote's); **(c)** only one — and if so, which
  wins? Follow-up: is the price-list discount on **its own codes only**, or on the whole quote?
- **Sources checked:**
  - [../decisions/2026-09-02-one-surcharge-per-quote.md](../decisions/2026-09-02-one-surcharge-per-quote.md)
    (`verified`) — settles surcharge only: the price list's surcharge, else the general one.
  - [../decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md](../decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md)
    (`reference`) — the quote-level rows; says nothing of a price-list discount.
  - [fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) (`unverified`) — FCC's price
    list has a blanket Sales Discount % and per-code rates, and *"does not say how they interact"*.
  - [../erp-review-log.md](../erp-review-log.md) (`unverified`) — *"price list discounts and price hikes
    apply only to items in that list"*: bears on the follow-up, not on the combination.
  - [*Billing-code and price-list rules the E2E suite asserts with no written source — PR #488*](#billing-code-and-price-list-rules-the-e2e-suite-asserts-with-no-written-source--pr-488)
    item (e) — whether the quote's discount and price hike are mutually exclusive. Answer them together.
- **Blocked:** the quote total whenever a price-list customer is also given a quote-level discount.
- **Owner:** Melissa McNutt (pricing) with Joe Schacatano (quotations); Kaitlin Kiesel can check against
  Edison's current pricing.

## Branch fixes/TCG-22-OCT-UAT (PR #926) — quotation hero Subtotal and workspace KPIs now show money in full, not compact

- **Status:** resolved — see [../decisions/2026-10-23-pr-926-won-popup-craneguys-domain-full-money-as-built.md](../decisions/2026-10-23-pr-926-won-popup-craneguys-domain-full-money-as-built.md). Asad Amanullah decided on 2026-10-23 (`reference`). Four figures show the full amount, 2 decimals, no K/M: Total Amount and Subtotal on the quotation detail hero, and Won value and Pipeline value on the workspace KPIs. Tables, the pipeline board and the other compact (`qmoney`) displays are not covered by this decision.
- **Asked:** 2026-10-23, in the PR #926 review (tcg-scrum escalation). Path C, no ticket.
- **Question:** On the quotation detail hero (Subtotal) and the quotations workspace KPI ribbon (Won value, Pipeline value), should money show in full to the cent ($267,580.00) or compact ($267.58K)? The branch leaves tables and the pipeline board compact. Is that split intended?
- **Sources checked:** A vault-wide grep outside `meetings/transcripts/` for compact money, K/M, abbreviated amounts, `Won value` and `Pipeline value` finds nothing on display format. [*Resources Total Value — UAT asks for exact decimals*](#resources-total-value--uat-asks-for-exact-decimals-the-code-deliberately-strips-cents) covers a different surface (the Resources Total Value field, UAT 3) and is a pricing question. [../projects-jobs/job-project-das.md](../projects-jobs/job-project-das.md):36 (`unverified`, punch list) asks only for consistent *naming* of budget, pipeline and won value. `uat/sessions/` has no 2026-10-22 session. `.ai/aidlc/processed.log:245` records "UAT feedback 2026-10-22" with no written source.
- **Blocked:** nothing. The change is display-only and reversible. The UAT ask still needs writing down (who asked, and where), or the next formatter change may revert it.
- **Owner:** whoever raised it at the 2026-10-22 UAT. Otherwise Joe Schacatano / Ryan Adams (sales).

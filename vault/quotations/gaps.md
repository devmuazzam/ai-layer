---
title: Quotations — open questions
status: reference
kind: gaps
updated: 2026-09-11
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

- **Status:** open, for (b), the printed-quote half of (c), and (d) only. (a) and the on-screen half of (c) were resolved 2026-09-11; see the next bullet.
- **Resolved in part 2026-09-11, by Fouzan Shakil (CodingCops, `reference`, not a TCG sign-off):**
  - **(a).** Settled by [../decisions/2026-09-11-quotation-archive-blocked-by-in-flight-jobs.md](../decisions/2026-09-11-quotation-archive-blocked-by-in-flight-jobs.md). Archive is blocked while any linked job is `ACTIVE` or `ON_HOLD`. It is allowed once every linked job is `COMPLETED`, `INVOICED` or `CANCELLED`, which covers the whole `JobStatus` enum. No other blocker was named, including a linked project.
  - **(c), on-screen half.** Settled by [../decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md](../decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md):
    - Discount and Price Hike footer rows work exactly like the Fuel & Insurance Surcharge row, on create/edit and on detail.
    - Each resource row's Amount is the amount before discount, hike and surcharge: qty × rate, or for a Mob/Demob group parent, the sum of its included children.
    - The footer rows carry the adjustment money, so the Amount column sums to the Total.
  - **Still open:**
    - (b).
    - Whether the **printed** quote carries the same rows (the second question of (c)).
    - (d), below.
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
  - `decisions/`: nothing on mark-won or voiding.
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

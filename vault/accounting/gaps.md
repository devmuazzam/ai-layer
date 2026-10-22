---
title: Accounting — open questions
status: reference
kind: gaps
updated: 2026-10-20
tags: [module/accounting, kind/gaps, open-questions]
---

# Accounting — open questions

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

*No entries yet. Pre-2026-08-20 questions remain in the retired registers
([gaps.md](../gaps.md)); disposition into module files is phase 3.*

## Wishlist vs committed scope — nobody has tiered the accounting list

- **Status:** open
- **Asked:** 2026-08-24 — on capturing the July 2026 accounting-team wishlist
- **Question:** the [wishlist](2026-07-accounting-team-erp-wishlist.md) spans core accounting
  (GL/AR/AP/job costing) through heavy AI ambitions (OCR, predictions, collections assistant,
  customer portal). Which tier is committed ERP scope, which is later, which is out? The module
  is slated to start ~October–November 2026; tiering is the first kickoff decision.
- **Sources checked:** no FRD, no matrix, no ticket exists for accounting; the wishlist is the
  only source. Payroll-integration rows already live in the payroll register; mobile time entry
  is largely the Atom app; job-document storage overlaps field-ops/projects attachments.
- **The outer edge was answered on 2026-09-01 — decision-shaped, no decision note yet.** Brent
  Wagstaff put the question directly (*"are we maintaining the books in this new ERP or are we
  not?"*) and ehtesham.anwar answered: **QuickBooks keeps the books** — *"all of the workflows
  that are in QuickBooks should remain in QuickBooks because we are not creating again an
  invoicing software… that would be foolish to build within the ERP"* — while the **ERP takes the
  reporting**, fed from QuickBooks by webhook and joined to customers, projects, jobs and
  quotations. **Journal entries, trial balance, P&L and balance-sheet accounts are out**, named by
  Brent and left out by both parties. **Integration is by API, not QODBC** (Patrick asked; same
  path as ADP and Samsara). A **self-service report builder** is wanted and explicitly deferred
  until the essentials exist. Brent's reading back — *"you're going to build the side that feeds
  an accounting system, but the new ERP is also going to take information back and build
  reports"* — was confirmed. Source:
  [meetings/2026-09-01-accounting-boundary-and-erp-onboarding.md](../meetings/2026-09-01-accounting-boundary-and-erp-onboarding.md) §1.
  **This tiers the wishlist's top by exclusion, not by listing:** core GL/AR/AP ledger work is
  out; reporting, automation and the ERP-side joins are in. It does **not** tier the AI ambitions
  (OCR, predictions, collections assistant) or the customer portal. A `decisions/` note is owed —
  the parties are named and the statement is unambiguous, which is exactly the shape `tcg-scrum`
  writes up.
- **Update 2026-09-04 (Project Repository ingest):** four things bear on the tiering; none is a
  tiering decision. **(a)** The client's own RFP of 2026-02-26
  ([admin/tcg-erp-rfp-2026-02-26.md](../admin/tcg-erp-rfp-2026-02-26.md) §3–§4) is the only
  client-authored phasing on record: *Invoicing & Billing* (generation, recurring billing, payment
  tracking) sits in **Phase 2** (Sep–Nov 2026 on its timeline), *Reporting & Analytics* (finance and
  executive KPI dashboards) in **Phase 3** (Q1 2027), *QuickBooks Online — bi-directional sync for
  invoices, payments, GL* is a **High**-priority required integration, and a *customer portal for
  quote approval and invoice review* is listed as **nice-to-have**. It predates both the July
  wishlist and the 2026-09-01 boundary, and says nothing about OCR, predictions or a collections
  assistant. **(b)** The accounting team's activity inventory
  ([accounting-team-quickbooks-and-spreadsheet-activities.md](accounting-team-quickbooks-and-spreadsheet-activities.md))
  shows the wishlist's budgeting, cash-flow, expense-report and month-end items are descriptions
  of fifteen spreadsheets that already exist — evidence of current practice, not a scope
  statement — and the AR-collections history a "collections assistant" would need currently lives
  as prose in a QuickBooks customer note field
  ([nexgen-quickbooks-integration/06-quickbooks-customer-contact-export.md](nexgen-quickbooks-integration/06-quickbooks-customer-contact-export.md)).
  **(c)** The customer portal was placed *after the first scope closes* on 2026-09-02 — by
  CodingCops (Ehtesham), not by a named TCG decision-maker
  ([meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md)
  → *Product questions raised* #1). **(d)** Two client sources sit uneasily beside "QuickBooks keeps
  the books": Brian Petros's draft P&P PO-002 of 1 Dec 2025 lists its systems as *"FCC / NexGen,
  QuickBooks (current), Sage (future)"*
  ([vendors-agencies/purchase-orders-fcc/po-002-vendor-billing-and-customer-invoicing.md](../vendors-agencies/purchase-orders-fcc/po-002-vendor-billing-and-customer-invoicing.md)),
  and Melissa McNutt on 2026-07-23 said *"We feel like we've outgrown QuickBooks, so we've talked
  about, you know, Sage or NetSuite, Oracle"*
  (`meetings/transcripts/2026-07-23-accounting-invoicing.md:201`). Both predate 2026-09-01 and
  neither was retracted on tape; the 2026-09-01 exchange did not mention Sage. Separately, the
  `3.8.1_MODULE-ACCOUNTING-AP-AR` archive in the drop arrived truncated (one text file, an empty
  `Ariba/` folder), so the AP/AR process documents that would inform the tiering are still
  missing. **Still needs the client:** a tier per wishlist item (in particular OCR, predictions,
  the collections assistant and the portal), whether a Sage move is live or abandoned, and the
  `decisions/` note for the 2026-09-01 boundary.
- **Update 2026-10-15 (decision, not a tiering).** Brent Wagstaff chose, on the 2026-10-13 call, a
  collections worklist **per customer, not per invoice**:
  [../decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md](../decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md)
  (`verified`). That shows a manual collections check-in is wanted in the ERP. It does **not** tier
  the wishlist's AI collections assistant (automated reminders and escalation), and nothing else in
  this entry is answered. The entry stays open.

## Project detail Accounting tab — what it shows, and what it shows before the module exists

- **Status:** open
- **Asked:** 2026-08-24 — `SCRUM-897` (path C, `feat/SCRUM-897`); tcg-scrum during PR review
- **Question:** Two questions, and they need separate answers. (a) **Content:** what does the
  project detail Accounting tab show? The only written AC is
  `projects-jobs/project-module/05-create-and-track-permits.md:64` — *"The accounting tab shows a
  financial summary along with quotations and invoices, and payroll status where applicable"* —
  a 2026-04-30 page, `status: unverified`, and its subject was reopened on tape three months
  later without settling (below). (b) **Interim:** until the accounting module ships (~Oct–Nov
  2026), should the tab render a *"Coming Soon"* placeholder, be hidden from the tab bar
  entirely, or something else? Is a "Coming Soon" panel an accepted app-wide interim for a
  shipped-but-empty tab, or is it a per-PR improvisation? **Nothing written answers (b).**
- **Sources checked:** `vault/INDEX.md`; `accounting/INDEX.md` (module not yet built, kickoff
  ~Oct–Nov 2026); this register; `projects-jobs/INDEX.md` and `projects-jobs/gaps.md`;
  `projects-jobs/project-module/INDEX.md`, `01-create-and-track-projects.md:33` (tab bar lists
  Accounting), `05-create-and-track-permits.md:55,64` (the AC, under *User Story 5: Project
  Dashboard Overview*); `2026-07-accounting-team-erp-wishlist.md`;
  `2026-07-invoicing-adjustment-taxonomy.md`; all of `decisions/` (no accounting-tab or
  placeholder/deferral decision); vault-wide grep for `coming soon|placeholder`; the six
  `module/accounting` meeting files; `aidlc/processed.log`; no `aidlc/SCRUM-897/` folder exists
  (correct for path C).
- **Note — the content question is live on tape, not settled by the 2026-04-30 AC.** In
  `meetings/transcripts/2026-07-29-erp-review-dispatch-das-update.md`, `ehtesham.anwar`
  (CodingCops) at 30:11 demos a project-level Accounting structure (contracts, contract amounts,
  CORs/SCOs, invoices linked to contracts) and asks *"do we need something of a contract amounts
  tracker within the projects, within the TCG platform or not?"*. **Melissa McNutt answers at
  32:45: "Yes."** — and at 29:40, to the same theme, *"No, we want it."* But she immediately
  qualifies it at 32:58: *"we're currently not doing it. We're not really tracking it. We're only
  tracking Edison on an Excel… maybe we'll add Ryan to the call tomorrow"*, and Ehtesham defers:
  *"let's talk about this in detail tomorrow"*. The next-day call
  (`meetings/transcripts/2026-07-30-invoice-processing.md`, lines 44, 69, 73) is still open
  design — customer-level contracts whose amount is consumed by projects, with jobs selected in
  or billed separately — and ends with TCG owing the vendor their workflow. **So a named TCG
  person has confirmed she wants project-level accounting; nobody has specified it, dated it, or
  reconciled it with the 2026-04-30 AC (which mentions contracts nowhere).** That is a want on
  record, not a requirement, and it does not settle (b) either way.
- **Note — the weakest of weak precedents for (b).**
  `customers/customer-and-job-sites.md:38` — *"Make need attention tab - coming soon"*, under
  *Feedback on new Design*, `status: unverified`. It is a design-feedback punch-list line for a
  **different module's** tab, and punch lists are cross-module and unscoped
  (`gaps.md#feedback-punch-lists-are-not-scoped-to-the-module-they-are-filed-under`). It shows
  the pattern has been *asked for* once; **it is not an app-wide convention and must not be cited
  as one.** In the build, "Coming Soon" is already shipped in ~15 places, including the same
  `EmptyState title="Coming Soon"` on `/reporting` and a per-tab variant on job details — but
  that is a **build habit with no written product backing**, and existing code is not evidence of
  a convention.
- **Blocked:** `SCRUM-897` review cannot label the Accounting tab as spec-conformant either way;
  any future project-accounting ticket; the tiering question above, which must place
  project-level contract/invoice tracking in a tier before (a) can be answered.
- **Owner:** Melissa McNutt (she is the one on record wanting it), with Ryan Adams for contracts
  — for (a). For (b), the interim-placeholder convention is app-wide UI policy: Fouzan Shakil,
  as with `decisions/2026-08-20-archive-instead-of-delete-app-wide.md` and
  `decisions/2026-08-20-post-save-navigation-convention.md`.

## GL codes — FCC/ERP chart vs QuickBooks, and who owns the mapping

- **Status:** open
- **Asked:** 2026-08-27 — Brian Petros, written message to the TCG team, 2026-08-27 ("A couple things that came up in my discussion with CodingCops today, that we'll discuss in future meetings"), following the 2026-08-26 ERP sprint review — logged in [payroll/client-message-findings.md](../payroll/client-message-findings.md#cross-module--2026-08-27-follow-ups-after-the-fcc-migration-first-pass-brian-petros)
- **Question:** Brian: "need to provide CodingCops with better understanding of GL codes in
  FCC/ERP versus QuickBooks". Are FCC's GL codes and QuickBooks's chart of accounts the same list,
  a mapped pair, or independent? Which one does the ERP's `expense-gl-accounts` carry, and which
  is the system of record when invoicing and payroll post to QuickBooks?
- **Candidates:** the annotated migration brief, [meetings/2026-08-26-fcc-migration-client-brief.md](../meetings/2026-08-26-fcc-migration-client-brief.md) — FCC `FMS_GL_ACCOUNTS` (296, loaded, "Need Clarification from TCG Team") plus `FMS_GL_ACCOUNTS_COMPANY` (592 per-company rows, **no TCG GL–company join**) and departments' expense-account field, all unmapped. `expense-gl-accounts` usecase (built; source of its list unknown); the 2026-08-25
  accounting transcript's ADP/QuickBooks custom-field discussion
  (`../meetings/transcripts/2026-08-25-accounting-process.md`, ~51:19 onward); nothing in the
  vault names a GL code.
- **Blocked:** invoicing → QuickBooks posting; payroll GL export; the accounting wishlist tiering
  above.
- **Owner:** TCG accounting (Brent / Micaela Dipane) via Brian Petros.
- **Update 2026-09-04 (Project Repository ingest):** the first part of the question — same list,
  mapped pair, or independent — is now answered by the record; the other two parts are not, so the
  entry stays open. **(a) Two independent lists, joined per account by `FMS_GL_ACCOUNTS.GLLINK` (a
  QuickBooks `ListID`), with no synchronisation.** FCC's own connector document, attached by FCC
  support to case 39995 in November 2025: *"we don't have any GL Sync to update the GLLINK column
  in FMS_GL_ACCOUNTS table. They update from Export Invoice when the GLLINK not found in the table
  it updates"* — `Account.AccountNumber ← GLAcctCode`, and invoice, credit-memo and voucher lines
  reach QuickBooks as **GL account + amount only**
  ([nexgen-quickbooks-integration/01-fcc-connector-field-mapping.md](nexgen-quickbooks-integration/01-fcc-connector-field-mapping.md)
  → *GL Account*). That is a system fact about the legacy seam, not a TCG decision. The practice
  side agrees: Sam runs the QuickBooks chart-of-accounts report *"to add General Ledger codes to
  match FCC"*
  ([accounting-team-quickbooks-and-spreadsheet-activities.md](accounting-team-quickbooks-and-spreadsheet-activities.md)
  → *Sam*) — QuickBooks is edited by hand to follow FCC — and FCC's QBO setup sheet says billing-code
  names copy to QuickBooks items for *"only Revenue accounts not expense accounts. No GL number
  comes over"*
  ([nexgen-quickbooks-integration/04-quickbooks-online-setup-guides.md](nexgen-quickbooks-integration/04-quickbooks-online-setup-guides.md)).
  TCG already knew the lists differ: on 2026-03-20, looking at the FCC GL Accounts screen, staff
  (unattributed in the transcript) said *"That's not the GL account… The code, that's how it's
  mapped to QuickBooks… There's got to be some other mapping mechanism because… those aren't GL
  accounts"* and parked it *"for the discussion with CodingCops… when they start getting the
  financial stuff"* (`meetings/transcripts/2026-03-20-fcc-fields-screens-review.md:186-207`).
  **(b) What FCC's list looks like.** The `Maintain → Company → GL Accounts` screen shows a
  per-unit / per-crane-class chart — `100INC` *100 Ton Income*, `10001RM` *Repairs & Maintenance*,
  `14001BD`, `1201` *Accounts Receivable (A/R)*, with A/P `2000` on the company screen — each
  account ticked valid for **two companies, The Crane Guys, LLC and The Repair Guys**
  ([admin/fcc-nexgen-administration-and-security.md](../admin/fcc-nexgen-administration-and-security.md)
  → *GL Accounts (slides 19–21)*); TCG's note on that slide is *"GL Accounts to be discussed more.
  Need to be integrated with accounting software (QuickBooks Online)."* A real PO books a fleet
  repair to `SL03 Expenses`, a GL account named after the unit
  ([vendors-agencies/purchase-orders-fcc/fcc-po-entry-walkthrough.md](../vendors-agencies/purchase-orders-fcc/fcc-po-entry-walkthrough.md)),
  whereas FCC's billing-code import template expects revenue accounts by kind — `4000` equipment
  and mobilisation, `4100` labour, `4200` miscellaneous
  ([quotations/fcc-billing-data-and-price-lists.md](../quotations/fcc-billing-data-and-price-lists.md)
  §3) — a template convention the live `<tons>INC` accounts on the screenshots do not follow. GL
  codes are carried on units (five each: `GlAcctTm`, `GLAcctBare`, `GLAcctOper`, `GLAcctDelPickup`,
  `GLAcctPermit`), crafts (`GLAcctCode` plus `AcctIntCode`, the QuickBooks wage-item `ListID`),
  employees, jobs and labour-payroll rows (`GLAcctCode`), and departments carry an `ExpAcct` flag
  (`payroll/tcg-rawfms-staging-database/ddl/stg.FMS_UNITS_Raw.sql:71-75`,
  `stg.FMS_CRAFTS_Raw.sql:13,19`, `stg.FMS_EMPLOYEES_Raw.sql:42`, `stg.FMS_JOB_MASTER_Raw.sql:50`,
  `stg.FMS_LABOR_PAYROLL_Raw.sql:32`, `stg.FMS_DEPARTMENTS_Raw.sql:18`); `FMS_GL_ACCOUNTS` itself is
  **not** in the staging extract. **(c) Ownership, as far as the record goes.** TCG's own
  integration checklist answers *"who is allowed to change integration settings (GL links, AR/AP
  accounts, TERMS)"* with *"This was setup by FCC, so they have to do the updates/changes"*
  ([nexgen-quickbooks-integration/02-integration-review-checklist.md](nexgen-quickbooks-integration/02-integration-review-checklist.md)),
  and its reimplementation proposal states *"QuickBooks Online = accounting 'source of truth' —
  Chart of accounts, terms, payroll items"*
  ([nexgen-quickbooks-integration/03-proposed-reimplementation.md](nexgen-quickbooks-integration/03-proposed-reimplementation.md))
  — a proposal to the owner/CFO with no evidence of approval, so not a decision. Brian's draft P&P
  PO-002 records one mapping defect in the client's words: Traffic Control and Permits *"must map
  to Subcontractor Expense"*, not *"LLC Safety"*, and *"department codes must be cleaned up to
  support this"*
  ([vendors-agencies/purchase-orders-fcc/po-002-vendor-billing-and-customer-invoicing.md](../vendors-agencies/purchase-orders-fcc/po-002-vendor-billing-and-customer-invoicing.md)).
  **(d) What the ERP's `expense-gl-accounts` carries — unanswered.** `expense_gl_accounts` is an
  empty admin-managed picklist (`code`, `label`, `description`, `status`;
  `apps/api/prisma/schema.prisma:2575`) with no seed, no QuickBooks identifier column and no link
  to FCC's 296 rows, which the migration brief still marks *"Need Clarification from TCG Team"*;
  a vendor's `defaultExpenseGlAccount` is a free-text string. **Still needs the client:** whether
  the ERP's list is FCC's per-unit chart, QuickBooks's chart, or a mapping table between them; who
  owns that mapping once FCC is gone; and which system is the record for payroll GL, given labour
  reaches QuickBooks via `FMS_CRAFTS.AcctIntCode` while payroll runs in ADP (Brian, 2026-08-25
  50:33: the ADP position ID is held in a QuickBooks custom field).

## Invoicing a travel permit that is not tied to a job — Brian named the case, nothing covers it

- **Status:** open
- **Asked:** 2026-09-05 — **Brian Petros**, written message to Ehtesham
- **Question:** Brian named this case verbatim, with no further elaboration:

  > *"Creating invoices for RCS (Roadway Construction Services) travel permits that are not tied
  > to a specific job in FCC (Fleet Cost & Care FCC-NexGen)"*

  Read literally it is a **customer-invoicing (AR) scenario for a permit with no Job Number**.
  Whether Brian meant it as (a) a description of current FCC practice, (b) a pain point he wants
  the ERP to fix, or (c) the title of a document he was about to send, **is not stated** — the
  message arrived alongside a separate shared-folder note and carries no verb of intent. Do not
  build from it until he confirms which.
- **Why it is not already answered:** the vault covers the **procurement half** of job-less
  permit spend in detail and the **AR half** not at all.
  - `vendors-agencies/purchase-orders-fcc/po-001-pre-job-purchase-orders.md` — pre-job POs for
    *"roadway / traffic control (e.g. Roadway, RCS); permits and other pre-job services ordered
    during quote/pre-planning"*, anchored on the **Quote Number** when no Job exists.
  - `po-002-vendor-billing-and-customer-invoicing.md:19,39` — AP may voucher a PO with no Job
    Number; AR *holds* customer billing while waiting. **Holding is not the same as invoicing a
    permit that will never have a job.**
  - `po-003-linking-pre-job-pos-to-jobs.md:70` — a periodic AP review of POs carrying a Quote
    Number but no Job Number. Again procurement-side.
  - `dispatch/travel-permits-playbook.md` — operational permit acquisition; no invoicing.
  - Nothing anywhere states how the **customer** gets billed for such a permit, against what
    document, or whether the ERP must support an invoice with no job at all.
- **Why it matters now:** it bears directly on the still-open standalone-PO question in
  [../vendors-agencies/gaps.md](../vendors-agencies/gaps.md) → *Purchase orders at three levels*.
  Joe Schacatano's third level — *"completely separately if we just need to create a PO in general
  for the business for a vendor"* — is unconfirmed, and Brian's 2026-09-05 workflow diagram
  ([../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md](../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md))
  shows **only** quote-anchored and job-anchored vendor POs. If TCG invoices job-less permits,
  something must anchor that invoice, and no source says what.
  It also collides with `meetings/2026-06-22-sprint-4-additional.md:91` — *"Every PO must be
  linked to a job number — this is required, not optional"* — already flagged as an outlier.
- **Blocked:** the accounting module's AR scope; `SCRUM-478` (PO epic); whether the ERP's invoice
  entity requires a job FK.
- **Owner:** Brian Petros (raised it); Melissa McNutt for the AR policy call.
- **Update 2026-10-15: a related decision, which does not answer this.**
  [../decisions/2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md](../decisions/2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md)
  (`verified`, Brent Wagstaff) says accounting invoices ticketed job work by selecting whole days
  of a job. A permit with no job has no day or ticket to select, and the 2026-10-13 call did not
  mention one. Do not read the decision as "every invoice needs a job". Whether a job-less invoice
  exists is still this entry's question. The entry stays open.

## Billable hours — the recordings say portal to portal, the Jira decision says boom time plus WTL

- **Status:** open
- **Asked:** 2026-09-07 — syed.haris, reviewing what the record says billable hours are, with the
  instruction to weigh recordings and client messages over Jira. Sweep of 18 transcripts and the
  client-supplied billing documents.
- **Question:** what span of a labor ticket is invoiced to the customer, and how does it map to
  invoice lines? Two TCG-stated models coexist and a third is inferred from an invoice.
  **(i) Portal to portal, hourly** — billing starts at the yard (pre-trip / dispatch start) and ends
  on return to the yard: Lisette Anzaldo 2026-05-21 10:46 *"the customer gets charged the second
  they leave from here"*; Melissa McNutt 05-21 48:56 / 49:37 *"we charge portal to portal… we bill
  from our portal to our portal for every job"*; Melissa 2026-06-04 45:56 *"their labor hours
  should always match the billing hours to the customer"*; Brian Petros 05-21 11:50–12:40 (three
  chunks: portal, work, portal back); Corrina Bustos and Kyle Harlow 2026-06-16 24:39–24:47 and
  2026-09-03 47:10–47:57 (yard start); LEM ticket T&C §13 *"All charges begin and end with Pre &
  Post trip inspections at equipment(s) dispatched location(s)"*. **(ii) Mob / crane time / demob,
  bundled** — Brian 2026-05-05 57:37–59:13 with Joe Schacatano concurring: drive and set-up inside
  *mobilization*, *"we bill off the total hours of the crane working"*, breakdown and drive back
  inside *demobilization*; Ryan Adams 2026-06-16 38:59 frames (i) and (ii) as **alternatives per
  quote**. **(iii) Travel as its own hourly line** — LADWP invoice item 57 *Portal In-Out 3.50 h* at
  the crane rate beside crane hours and operator hours
  ([invoice-packets-2026-04-worked-examples.md](invoice-packets-2026-04-worked-examples.md)).
  Against all three stands the vault's own decision note
  [../decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md](../decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md):
  *net billable hours = boom time + 30 min per WTL, yard and travel excluded* — sourced from Jira
  comments by `tcgproject12`, an account not tied to a named speaker. **No TCG person says that in
  any recording.** Every TCG statement that defines boom / hook time (Corrina 2026-06-09 37:33,
  Melissa 2026-05-19 44:37 and 2026-05-28 46:46, Kyle 2026-09-03 45:34) attaches it to **boom pay**,
  the payroll premium, never to what the customer is billed. *"Net billable hours"* itself is a
  CodingCops screen label (ehtesham.anwar 2026-06-16 34:14), and the June demo computed it as
  yard-to-yard minus lunch — the opposite of the Jira formula.
  Sub-questions: (a) which model is the default and who chooses per quote; (b) is the Jira
  "boom + WTL" a real billing rule from a named person, or a boom-**pay** statement mislabelled
  billable; (c) the customer signature: it is the evidentiary basis for the billed times (Melissa
  05-21 37:15, Corrina 2026-05-26 17:17, signed tickets travel with LADWP invoices) but never the
  boundary — invoiced times are deliberately back-dated to the yard and lifted to minimums
  (Melissa 05-21 47:22–49:18: *"the employee would show 2 hours, for the invoice we would show 4"*);
  (d) standby: Melissa 2026-07-01 25:08 avoids charging it, the LADWP ticket bills *Permit Stand By
  1.5 h*; (e) the contract bills to a post-trip Melissa says TCG does not perform
  ([../field-ops/gaps.md](../field-ops/gaps.md) post-trip conflict).
- **Sources checked:** meetings/transcripts 2026-05-05, 05-14, 05-18, 05-19, 05-21, 05-26, 05-28,
  06-04, 06-09, 06-16, 07-01, 07-28, 07-30, 09-02, 09-03; [2026-07-invoicing-adjustment-taxonomy.md](2026-07-invoicing-adjustment-taxonomy.md);
  [../quotations/quote-terms-and-rate-card.md](../quotations/quote-terms-and-rate-card.md) §7;
  [../field-ops/field-paper-forms.md](../field-ops/field-paper-forms.md) §13–14;
  [../quotations/gaps.md](../quotations/gaps.md) → *Billable hour minimums and maximums* (the
  minimums half of the same question); `payroll/rules/PAY-004` (payable ≠ billable principle).
- **Blocked:** the ticket-to-invoice hours mapping (the reconciliation the April packets show being
  done by hand), the Labor & Unit *net billable* figure on the field ticket, and any automatic
  invoice from actual hours.
- **Owner:** Melissa McNutt (billing model per quote), with Brian Petros to say whether the
  SCRUM-877 comments were his and meant billing or boom pay; Micaela Dipane for what AR invoices.
- **Update 2026-09-16 (Joe Schacatano).**
  - The customer sees only the **estimate** lines on the invoice, never the dispatch resources: *"customers only gonna get the estimate"* (17:20).
  - The invoice goes out with *"a packet with the final tickets for each individual resource"* (17:46). That widens (c) beyond LADWP: tickets travel with every invoice, one per resource.
  - It does not say how ticket hours map onto estimate lines, which stays this entry's open core.
  - Ehtesham (16:19) said creating an invoice from the job is affected by separating quote lines from resources ([../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md)). Joe: *"Correct."*

  Source: [../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md](../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md) §5.
- **Update 2026-10-07: Melissa McNutt, provisional, on holdover days.**
  - In written Teams answers posted on or before 2026-10-06
    ([../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md](../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md),
    `reference`, T4): on a holdover day 2+, the oiler's *"billable time"* starts when he *"arrives at
    the job site"*. The crew reports there directly.
  - The question used *billable* for what may have meant pay. Her answer does not say which.
  - If it means customer billing, it fits model (i) with no portal leg on the days between. Her
    2026-05-21 53:44 statement agrees: *"you still need to do the travel in and travel out on the
    1st and last day"*.
  - If it means pay, it conflicts with the verified yard-to-yard span. That is filed in
    [../payroll/gaps.md → *Holdover days 2+*](../payroll/gaps.md#holdover-days-2--does-paid-time-start-on-arrival-at-the-job-site-and-where-does-each-day-end).
  - On (e): she said yes to a post-trip at the end of a holdover's final day. That is still open in
    field-ops.
  - Also: a late completion should show internally only, *"We don't want it on the customer's
    paperwork."*
  - TCG asked to hold these answers until an updated version is sent. Nothing here closes.
- **Update 2026-10-15: a related decision, which does not settle the span.**
  [../decisions/2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md](../decisions/2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md)
  (`verified`, Brent Wagstaff) makes the invoice unit a whole day of a job and holds a day with a
  payroll-flagged ticket. Melissa McNutt's reason (2026-10-13, 15:06): *"we charge based off the
  hours. So if that one's flagged and it's an hour issue, we don't want to bill the customer and have
  to rebill if the guy charged more hours."* So the invoice follows the ticket hours that payroll
  settles. It says nothing about which span of those hours is billed (models i–iii) or how hours map
  onto invoice lines. The entry stays open.


## Paper Job Tickets — pointer, owned by field-ops

- **Status:** open
- **Asked:** 2026-09-10 — Brian Petros, Teams message ahead of that day's call (relayed 2026-09-11).
- **Question:** **Pointer only — the question lives in
  [../field-ops/gaps.md](../field-ops/gaps.md) → *Paper Job Tickets — will they remain an option,
  and how does the ERP price and pay one?*** Registered here because Brian names **billing** as
  one of the two consequences, and because a completed paper ticket is already a production
  billing artefact: the LADWP-variant original, serial `TCG 298`, is a backing page in a real
  April 2026 invoice packet ([invoice-packets-2026-04-worked-examples.md](invoice-packets-2026-04-worked-examples.md)). If paper survives, the
  ERP needs a stated path from a paper original to an invoice line; if it does not, someone has
  to say so.
- **Sources checked:** see the field-ops entry — it carries the full source list.
- **Blocked:** nothing today.
- **Owner:** TCG accounting for the billing side; field-ops owns the question.

## Does the invoice carry exactly the quotation's lines — including the lines hidden inside Mobilization/Demobilization?

- **Status:** open
- **Asked:** 2026-10-01. ehtesham.anwar (CodingCops) stated it as an assumption to Joe Schacatano on
  the "Quotes and Billing Codes" call, 11:34: *"we have decided that everything that we see in
  quotation is are going to be the same things that we are going to [port over to] invoices. That
  was my assumption. Do you think that's the right approach or are we missing anything here?"*
  Joe's next turn (13:37) answered a different point, the nested associations. Nobody answered this.
  Filed 2026-10-07 by tcg-scrum while recording Linear TCG-218's decisions (TCG-218 excludes
  invoices from its scope, so this belongs to no ticket); ported to overlay main 2026-10-09.
- **Question:** *"When a quotation becomes an invoice, does the invoice carry exactly the quote's
  customer-facing lines (Mobilization and Demobilization as single totals plus the main items), or
  does it itemise the lines inside Mob/Demob?"* Two follow-ups, each a one-line answer: **(a)** Are
  quote quantities replaced by actuals from tickets (Joe 33:29–33:48 wants quoted-vs-actual mob
  hours compared), or invoiced as quoted? **(b)** Does a quote-hidden association (an "also brings
  along" row, or an association with Show off) ever reach the invoice?
- **Sources checked:**
  - `meetings/2026-10-01-quotes-and-billing-codes-associated-assets-mob-demob-and-holdover.md` §2 and §10 Q4
    (`unverified`), and the transcript at 11:34 / 13:37 (`reference`).
  - `quotations/mobilization-and-demobilization.md` (`unverified`), *Pain Point* 3: *"The Estimate
    already drives the Invoice"* (FCC as-is), with no rule for the ERP.
  - `decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md`: the PO flow only; says
    nothing about invoice lines.
  - `decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md` (`verified`):
    the customer **quote** shows mob, demob and the main items only. It says nothing about the
    invoice.
  - `decisions/2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md`
    (`verified`): one invoice per job with two cranes. Says nothing about line itemisation.
  - `meetings/2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md` §2
    (`unverified`): invoice lines come from tickets linked to the quoted resources, *"follows the
    quotation configuration"*, with a quoted-vs-actual flag (partly bears on (a)); Joe (27:20): *"the
    only thing that's going to push through are the billing codes, correct?"* — ehtesham.anwar:
    *"Yes."* Bears on the question but does not say whether Mob/Demob is invoiced as one line or
    itemised.
- **Blocked:** the invoicing module's line source for a Mob/Demob quote.
- **Owner:** Joe Schacatano (what the customer is billed against the quote) with Corrina Bustos /
  TCG accounting (invoice presentation). Relayed by Brian Petros. Brian (2026-10-01, 1:04:34) named
  invoicing as the phase not yet covered.

## Billing cadence — what sets monthly instead of weekly, what a billing week is, and what "billed daily" means

- **Status:** open
- **Asked:** 2026-10-19. Umer (CodingCops) asked Brent Wagstaff (cc Brian Petros, Melissa McNutt)
  in the client thread how a long job is invoiced. Melissa McNutt answered on 2026-10-20, and her
  answer settles most of it:
  [../decisions/2026-10-20-holdovers-billed-weekly-or-monthly-other-jobs-daily-one-job-per-invoice.md](../decisions/2026-10-20-holdovers-billed-weekly-or-monthly-other-jobs-daily-one-job-per-invoice.md)
  (`verified`). Her words: *"We like to bill holdovers weekly, there are times when customers only
  want monthly billing. All other jobs are billed daily."* Filed by tcg-scrum on 2026-10-20 for what
  her answer leaves open. No ticket owns invoicing.
- **Settled (do not re-ask):** a holdover is **not** invoiced once at the end. It is billed
  **weekly**, or **monthly** when the customer wants only that. Every other job is billed **daily**.
  This answers item 1 of
  [../meetings/2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md](../meetings/2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md)
  §10, which was never filed here.
- **Question:** *"When a customer wants monthly billing for holdovers, is that set once on the
  customer (all their holdover jobs), or agreed per job or contract?"* Follow-ups, each a one-line
  answer:
  - **(a) The billing week and month.** Which day does a weekly holdover invoice close on: a
    fixed weekday (which?), the payroll week, or every 7 days from the job's first day? Is monthly
    the calendar month?
  - **(b) "Billed daily".** On a non-holdover job that runs several days, does each working day
    get its **own invoice**? Or are days billed as they complete, with several days allowed on one
    invoice (the 2026-10-13 decision, point 4, *permitted*)?
  - **(c) A payroll-flagged day inside a billing week.** A flagged day waits and days are
    independent (2026-10-13, points 2–3). Does the weekly invoice wait for that day, or go out
    without it, with the day billed on a later invoice?
  - **(d) Monthly beyond holdovers.** Can a customer who wants monthly billing also have its
    non-holdover jobs billed monthly, or does monthly apply only to holdovers?
  - **(e) Which "holdover".** Is the job billed weekly the one with *Make Holdover* set
    (`JobResource.isHoldover`), the one with payroll's subsistence holdover, or Joe's *"the
    machine stays on site"* (2026-10-07 sprint review §6)? See the pointer in
    [../dispatch/gaps.md → *Is the DAS holdover the same thing as payroll's subsistence holdover?*](../dispatch/gaps.md#is-the-das-holdover-the-same-thing-as-payrolls-subsistence-holdover).
- **Sources checked:**
  - [../decisions/2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md](../decisions/2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md)
    (`verified`): the invoice unit is a whole day of a job. It left holdover invoicing open.
  - [fcc-invoicing-in-nexgen.md](fcc-invoicing-in-nexgen.md) → *Recurring billing* (`unverified`):
    FCC's `Frequency` (days, weeks or months) and `Next Bill` date per job. This is how the legacy
    system does it, not a rule for the ERP.
  - [2026-07-accounting-team-erp-wishlist.md](2026-07-accounting-team-erp-wishlist.md) → *Billing*
    (`unverified`): *"hourly · daily · weekly · monthly rental …"* is a list of billing **methods**,
    which may mean rate units rather than invoice frequency. It does not answer this.
  - `meetings/2026-10-13-…` §2 and §10, and its transcript at 17:34–17:54. Tia's holdover remark
    (*"I went bill each day individually"*) is unresolved in the transcript.
  - The 2026-10-16 accounting demo (Collections, Cash Forecast) is CodingCops' proposal and
    settles nothing here.
- **Blocked:** invoice generation for holdover and multi-day jobs (when an invoice is due, which
  days it carries); any per-customer billing-cadence setting; Cash Forecast dates that depend on
  invoice dates.
- **Owner:** Melissa McNutt / Brent Wagstaff, with Tia Brenneise (Accounts Receivable) for (a)–(c).

## One job per invoice / PO — what are the exceptions to "typically"?

- **Status:** open
- **Asked:** 2026-10-19. This was Umer's question 3 (CodingCops, client thread): *"Can a customer
  require split invoices for one job (per PO line / per location), or strictly one job, one
  invoice?"* Melissa McNutt answered on 2026-10-20: *"We typically do 1 job per invoice / PO."*
  ([../decisions/2026-10-20-holdovers-billed-weekly-or-monthly-other-jobs-daily-one-job-per-invoice.md](../decisions/2026-10-20-holdovers-billed-weekly-or-monthly-other-jobs-daily-one-job-per-invoice.md),
  `verified`). Filed by tcg-scrum on 2026-10-20.
- **Settled (do not re-ask):** an invoice normally covers one job and one customer PO. Because a
  holdover is billed weekly, one job can still have several invoices over time.
- **Question:** *"Apart from Joe's two cases (one crane stays longer than the other, or the customer
  asks), does TCG ever split one job across invoices by PO line or by location, or put more than
  one job on one invoice?"*
  - Follow-up, a one-line answer: can one job carry **more than one customer PO**? If it can, does
    each PO get its own invoice?
- **Sources checked:**
  - [../decisions/2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md](../decisions/2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md)
    (`verified`, point 3). Joe Schacatano at 40:06: *"It should be all on one invoice, right, for
    the same job. The only time you're going to see separate invoices is, let's say, if one machine
    ends up staying longer than the other."* And at 40:32: *"Or if the customer just asked for
    it."* He said this about two cranes on one job.
  - [../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md](../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md)
    (Brian Petros): the customer PO lives on the job / schedule tab and is printed on the final
    invoice. It does not say whether a job can carry several POs.
  - [invoice-packets-2026-04-worked-examples.md](invoice-packets-2026-04-worked-examples.md)
    (`unverified`): six real packets. Each shows one job. That is consistent with the norm, but it
    shows no exceptions.
- **Blocked:** whether the invoice entity holds one job or several, and one PO or several; any
  "split invoice" action.
- **Owner:** Melissa McNutt / Brent Wagstaff, with Tia Brenneise (Accounts Receivable).

## Vendor-bill flow — when is the QuickBooks bill created, and which bills wait for the customer's payment?

- **Status:** open
- **Asked:** 2026-10-16. Ehtesham Anwar (CodingCops) proposed a simplified vendor-bill flow to
  Brent Wagstaff by e-mail, and asked whether it aligns with his process. **Unanswered.** Source:
  [../meetings/2026-10-16-accounting-prototype-review-email-brent-wagstaff-and-ehtesham-anwar.md](../meetings/2026-10-16-accounting-prototype-review-email-brent-wagstaff-and-ehtesham-anwar.md)
  §2. This entry also files two questions that had been listed but never filed: 2026-10-08 §9 Q6 and
  2026-10-13 §10 Q2. Filed by tcg-scrum on 2026-10-20.
- **Question:** *"Should the ERP create the QuickBooks bill only when a vendor bill is ready to
  pay, as proposed? Or at receipt, as demoed on 10-08 and 10-13?"* Follow-ups, each a one-line
  answer:
  - **(a)** Which vendor bills wait until the customer pays TCG (Case 1): subcontractors only, or
    every vendor bill, including permits and plans?
  - **(b)** Which bills must be paid **before** the customer invoice is sent (Case 2)? Is it only
    LADWP jobs' subcontractors?
  - **(c)** In Case 2, must the ERP block the customer invoice until the vendor is paid?
  - **(d)** Is it acceptable that a held bill is not in QuickBooks' AP, or its aging, until it is
    released?
- **The three timings on record. None is a TCG decision:**
  1. **At receipt.** 2026-10-08 §4 and 2026-10-13 §3: *Create bill* sends it to QuickBooks at the
     invoice amount.
  2. **After the customer invoice is processed.** The prototype's statuses: Requested · To Verify ·
     Ready to Bill · Held · Released · Paid.
  3. **When ready to pay.** The proposal:
     - Case 1: `PO Open → Invoice Received → Held → Released / Ready to Bill → Pending Payment → Paid`
     - Case 2: `PO Open → Invoice Received → Requested → Ready to Bill → Pending Payment → Paid`
- **Sources checked:**
  - [../decisions/2026-10-13-vendor-invoice-attachment-goes-to-quickbooks-with-the-bill.md](../decisions/2026-10-13-vendor-invoice-attachment-goes-to-quickbooks-with-the-bill.md)
    (`verified`). The document goes with the bill, whenever the bill is created. Its *What was not
    decided* says the hold until the customer pays was not confirmed, and the bills-received blocker
    was proposed, not agreed.
  - `meetings/2026-10-08-…` §4 and §7 (`unverified`). ehtesham.anwar stated the subcontractor rule:
    TCG is paid first, except LADWP, where subs are paid before TCG bills. Melissa asked for a
    paid-job notification so the sub can be paid.
  - `meetings/2026-10-13-…` §3 and *Against the vault* (`unverified`). The hold was shown on a
    **permit** bill.
  - [../vendors-agencies/purchase-orders-fcc/po-002-vendor-billing-and-customer-invoicing.md](../vendors-agencies/purchase-orders-fcc/po-002-vendor-billing-and-customer-invoicing.md)
    (`unverified`, FCC draft SOP). The customer invoice is held *"Waiting on Sub"* until sub bills
    are **received**. It says nothing about payment.
  - [ap-ar-value-engine-and-whiteboard-flow.md](ap-ar-value-engine-and-whiteboard-flow.md)
    (`unverified`). Shows a subcontractor branch and an LADWP path, with no timing for the bill.
  - [../decisions/2026-09-11-po-closed-means-closed-out-not-cancelled.md](../decisions/2026-09-11-po-closed-means-closed-out-not-cancelled.md)
    (`reference`, CodingCops). A PO auto-closes on an Invoice-category attachment. The 10-08 design
    closes it when the bill is paid. The proposal does not say when.
- **Blocked:** the vendor-bill status model, *Create Bill* timing, the customer-invoice blocker for
  Case 2, and the AP figures read from QuickBooks.
- **Owner:** Brent Wagstaff (CFO), with Melissa McNutt on the subcontractor and LADWP rule.

## Invoice-approval reminders — what interval, and by what channel?

- **Status:** open
- **Asked:** 2026-10-16. Brent Wagstaff by e-mail: *"when invoices are waiting for approval what
  kind of reminders are sent(interval)?"* Ehtesham Anwar replied that in-app notifications are
  planned and e-mail is possible, and asked Brent what interval he wants. **Unanswered.** Source:
  [../meetings/2026-10-16-accounting-prototype-review-email-brent-wagstaff-and-ehtesham-anwar.md](../meetings/2026-10-16-accounting-prototype-review-email-brent-wagstaff-and-ehtesham-anwar.md).
  Filed by tcg-scrum on 2026-10-20.
- **Question:** *"How long after an invoice is sent for sales approval should the first reminder
  go out, how often after that, and in-app, e-mail, or both?"* Follow-up, a one-line answer: does a
  reminder ever escalate to someone other than the approving salesperson?
- **Related, never filed (2026-10-08 §9 Q5):** which salesperson approves (the quote's?), and is
  every invoice routed for approval, or only some? Sales approval itself is CodingCops design
  (2026-10-08 §3).
- **Sources checked:**
  - [../vendors-agencies/purchase-orders-fcc/po-002-vendor-billing-and-customer-invoicing.md](../vendors-agencies/purchase-orders-fcc/po-002-vendor-billing-and-customer-invoicing.md)
    Step 4 (`unverified`). In FCC the salesperson runs a report of invoices awaiting approval. No
    reminders are described.
  - [2026-07-accounting-team-erp-wishlist.md](2026-07-accounting-team-erp-wishlist.md). It lists
    approval routing (*"e.g. >$500 → PM → Accounting → Owner"*), and collection reminders at days
    15/30/45. Neither is about invoice-approval reminders.
- **Blocked:** the notification schedule and channel for *Pending Approval* invoices.
- **Owner:** Brent Wagstaff.

## "An AR tab like Accounts Payable v2" — what does Brent want on it?

- **Status:** open
- **Asked:** 2026-10-16. Brent Wagstaff by e-mail: *"Can we have a tab made for Accounts Receivable
  like Accounts Payable v2?"* Ehtesham Anwar asked him which layout or features he means.
  **Unanswered.** Source:
  [../meetings/2026-10-16-accounting-prototype-review-email-brent-wagstaff-and-ehtesham-anwar.md](../meetings/2026-10-16-accounting-prototype-review-email-brent-wagstaff-and-ehtesham-anwar.md).
  Filed by tcg-scrum on 2026-10-20.
- **Question:** *"Which parts of AP v2 should the AR tab copy: the per-party view with owed / paid /
  partial and totals that follow the filter, the layout, or something else?"*
- **Sources checked:** `meetings/2026-10-13-…` §6 (`unverified`). AP per vendor with paid, unpaid
  and partially paid, and totals that follow the filter. Brent (31:05) asked for *"paid and unpaid
  per party"* and said it replaces a side spreadsheet. `meetings/2026-10-08-…` §4 (`unverified`):
  the AR list design.
- **Blocked:** the AR tab's design.
- **Owner:** Brent Wagstaff.

## AP payment marking — selecting bills for payment, "sent to bank", and partial payments: ERP or QuickBooks?

- **Status:** open
- **Asked:** 2026-10-16. Brent Wagstaff by e-mail, under *Accounts Payable v2*: *"Can we mark
  invoices to be paid? We send for payment to bank and they are paid?"* and *"Can we mark invoices
  for partial payment?"* Ehtesham Anwar replied:
  - Bills are created and managed in QuickBooks, and their paid status syncs to the ERP.
  - Selecting bills for payment and tracking *"Sent to Bank"* would be an additional workflow.
  - A partial payment is recorded against the bill in QuickBooks, and the ERP shows the status and
    the outstanding balance.

  Source:
  [../meetings/2026-10-16-accounting-prototype-review-email-brent-wagstaff-and-ehtesham-anwar.md](../meetings/2026-10-16-accounting-prototype-review-email-brent-wagstaff-and-ehtesham-anwar.md).
  Filed by tcg-scrum on 2026-10-20.
- **Question:** *"Does TCG want to select vendor bills for payment and mark them 'sent to bank' in
  the ERP, or is QuickBooks' paid status, synced back, enough?"* Follow-up, a one-line answer: is
  recording partial payments in QuickBooks, shown in the ERP, what Brent meant? Or does he want to
  mark a partial payment in the ERP?
- **Sources checked:**
  - [accounting-team-quickbooks-and-spreadsheet-activities.md](accounting-team-quickbooks-and-spreadsheet-activities.md)
    (`unverified`): *"Marking invoices paid"* (Kaitlin), *"Record payments"* (Tia), and bank
    matching (Sammy), all in QuickBooks today. Nothing on how vendor payments are sent to the bank.
  - The 2026-09-01 boundary: QuickBooks keeps the books. See
    [*Wishlist vs committed scope*](#wishlist-vs-committed-scope--nobody-has-tiered-the-accounting-list).
    A payment workflow in the ERP sits at that edge.
  - `meetings/2026-10-13-…` §6 (`unverified`): AP shows paid, unpaid and partial from QuickBooks.
- **Blocked:** the AP v2 actions, and whether the ERP holds any payment state of its own.
- **Owner:** Brent Wagstaff.

## Forecast vs actual cash flow — what it covers, how often, and from which balances

- **Status:** open
- **Asked:** 2026-10-16. Brent Wagstaff by e-mail: *"Can we have a Forecasted cashflow and actual
  cashflow?"* Ehtesham Anwar said the page today compares forecast customer collections with actual
  QuickBooks receipts, and asked four things back. **Unanswered.** Source:
  [../meetings/2026-10-16-accounting-prototype-review-email-brent-wagstaff-and-ehtesham-anwar.md](../meetings/2026-10-16-accounting-prototype-review-email-brent-wagstaff-and-ehtesham-anwar.md).
  Filed by tcg-scrum on 2026-10-20.
- **Question:** *"Should the cash-flow view put forecast against actual for both money in and money
  out, with the difference shown?"* Follow-ups, each a one-line answer:
  - **(a) Scope.** Customer receipts and vendor payments only, or also payroll, overhead, taxes and
    loans?
  - **(b) Cadence.** Weekly, monthly, or both?
  - **(c) Balances.** Opening and closing cash from QuickBooks bank data?
  - **(d) A sample.** Can TCG send an existing cash-flow report?
- **Sources checked:**
  - [2026-07-accounting-team-erp-wishlist.md](2026-07-accounting-team-erp-wishlist.md)
    (`unverified`, never tiered): *"Cash-flow forecasting — 13-week projected balance (payroll,
    vendors, collections, loans, taxes)"*. This bears on (a)–(c) but is a wishlist, not an answer.
  - [accounting-team-quickbooks-and-spreadsheet-activities.md](accounting-team-quickbooks-and-spreadsheet-activities.md):
    the *Cashflow Tracker* (*"tracking all payments needed / payments received"*), *SCE cash
    forecasting* and *AR cashflow daily check-in* sheets. These are the likely samples for (d).
  - `meetings/2026-10-08-…` §6: Brent's AR movement (opening balance, plus billed, minus received)
    and days-to-pay projection. `meetings/2026-10-13-…` §6: the overview design.
- **Blocked:** the Cash Flow Overview's data model and the Cash Forecast report.
- **Owner:** Brent Wagstaff.

## Accounting reports — what breakdowns each View Reports report needs, and the days-to-pay bands

- **Status:** open
- **Asked:** 2026-10-16. Brent Wagstaff by e-mail: *"Are View reports buttons available for use?
  Doesn't seem to work."* Ehtesham Anwar replied that they are now built (AR & AP Ageing, Cash
  Forecast, Collections Performance), and asked which breakdowns each should include.
  **Unanswered.** The same day's demo update added *Avg. days to pay* per customer, with bands green
  ≤45, amber 46–60 and red >60. That was CodingCops' choice. Source:
  [../meetings/2026-10-16-accounting-prototype-review-email-brent-wagstaff-and-ehtesham-anwar.md](../meetings/2026-10-16-accounting-prototype-review-email-brent-wagstaff-and-ehtesham-anwar.md).
  Filed by tcg-scrum on 2026-10-20.
- **Question:** *"For each report (AR & AP Ageing, Cash Forecast, Collections Performance), what
  must it break down by: customer or vendor, job, ageing bucket, week, or something else?"*
  Follow-up, a one-line answer: are 45 and 60 days the right thresholds for the days-to-pay colours?
- **Sources checked:**
  - `meetings/2026-10-08-…` §6: AR and AP totals in ageing buckets, *"as of a date"*, and AR by
    service type (Brian, §7).
  - `meetings/2026-10-13-…` §6: Brent asked that little time be spent loading past data for the
    days-to-pay forecast.
  - [../decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md](../decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md)
    (`verified`): collections are per customer.
  - The wishlist: *"payment history with average-days-outstanding"*. Nothing anywhere sets
    thresholds.
- **Blocked:** the report definitions, and the days-to-pay colour bands.
- **Owner:** Brent Wagstaff.

## QuickBooks direction for vendors and billing codes — does the ERP pull vendors, and push billing codes?

- **Status:** open
- **Asked:** 2026-10-21 — ERP demo walkthrough part 1. Source: [2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md](../meetings/2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md) §9 and
  *Against the vault*. Filed 2026-10-22.
  - Melissa McNutt (47:02): *"Will it sync like FCC syncs right now? So when we're connected to QuickBooks,
    will the vendors auto populate and it'll all match?"* ehtesham.anwar: not discussed yet; if the
    vendors are in QuickBooks, *"we will create a functionality to fetch that"*.
  - Micaela Dipane (56:00): if a billing code changes in the ERP, does QuickBooks change too? Melissa
    (56:22): in FCC *"if we update a billing code, we have to go manually do it in QuickBooks too"*; she
    wants both updated. ehtesham.anwar: no QuickBooks link for billing codes yet; planned once it is known
    where they live in QuickBooks.
  - Melissa (57:08): QuickBooks holds **no cranes**; *"it's not set up like the assets are set up in FCC"*.
- **Question:** **(a)** Which system is the master for **vendors** — does the ERP read them from
  QuickBooks, or create them and push them (as the FCC connector mapping says)? **(b)** Should a billing-code
  change in the ERP update a **QuickBooks item**, and which QuickBooks list holds them today?
- **Sources checked:**
  - [nexgen-quickbooks-integration/01-fcc-connector-field-mapping.md](nexgen-quickbooks-integration/01-fcc-connector-field-mapping.md)
    (`unverified`) — *"Direction is NexGen → QuickBooks throughout"*, Vendor pushed in the same shape as
    Customer; invoice lines go as GL-coded amounts, with no item. **This contradicts (a) as Melissa
    described FCC**, and makes (b) new.
  - [*GL codes — FCC/ERP chart vs QuickBooks, and who owns the mapping*](#gl-codes--fccerp-chart-vs-quickbooks-and-who-owns-the-mapping)
    — the GL side of the same mapping.
- **Blocked:** vendor import for production; any QuickBooks write of billing codes.
- **Owner:** Brent Wagstaff (CFO) with Melissa McNutt; Micaela Dipane for the billing-code maintenance
  she does today.

## Back-to-back jobs billed portal to portal — billed time overlaps, crew time must not

- **Status:** open
- **Asked:** 2026-10-22 — ERP demo walkthrough part 2. Source: [2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md](../meetings/2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md) §5;
  transcript [2026-10-22-erp-demo-walkthrough-part-2.md](../meetings/transcripts/2026-10-22-erp-demo-walkthrough-part-2.md). Filed 2026-10-23.
  - Brian Petros (37:00): FCC's scheduling board shows the same vehicle in up to three cities at the same
    minute. ehtesham.anwar (37:41): the ERP allows **no overlapping allocation** of an asset or employee.
  - **Melissa McNutt (38:21):** billing is portal to portal from the yard, not from job one to job two.
    *"For the 22 tons, they have three hour minimums, but we have to pay the guys 4 hours."* Small cranes
    are **doubled up** on back-to-back jobs to recover that, *"so they look like they're in the same place
    at the same time, but they're not."*
  - **Kyle Harlow (38:57–40:55):** it is a billing matter. Each job bills its own three-hour minimum; the
    crew is never in two places, is paid only for time worked, and the contract forbids working two jobs
    at once.
  - **Melissa (40:03):** set the jobs' start and end times so they do not overlap; the customer is billed
    from the **ticket times**.
  - ehtesham.anwar (41:34): start, onsite and estimated end all need setting on both jobs, without
    overcomplicating dispatch or billing. *"Another thing that we need to dive deeper into."*
- **Question:** **(a)** On the second of two back-to-back jobs, what does the invoice bill: portal to
  portal from the **yard** (so the two invoices together bill more hours than the crew worked), or from
  the end of job one? **(b)** Does each job's **billing minimum** (3 h for a 22-ton, 4 h otherwise) apply
  in full to each job, even when the jobs share a trip? **(c)** If the invoice is built from ticket times,
  where does the extra billed travel come from — a separate line, an adjusted time, or the minimum alone?
  **(d)** Is Melissa's answer (schedule without overlap, bill from ticket times) the rule, so nothing in
  DAS changes?
- **Sources checked:**
  - [*Billable hours — the recordings say portal to portal, the Jira decision says boom time plus WTL*](#billable-hours--the-recordings-say-portal-to-portal-the-jira-decision-says-boom-time-plus-wtl)
    — the span billed on one job. This entry is the two-job case.
  - [../customers/new-customer-packet.md](../customers/new-customer-packet.md) (`unverified`) — *"22 Ton
    Boom Truck: 3 hour"*, the one exception to a 4-hour minimum. [../payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md)
    PAY-040 — the crew's daily 4-hour minimum.
  - [../meetings/2026-08-12-sell-side-workflow-and-scheduling.md](../meetings/2026-08-12-sell-side-workflow-and-scheduling.md)
    (`unverified`) — *"support double booking when short jobs allow the same crane to perform multiple
    jobs in one day"*. Read on 10-22 as billing-only overlap.
  - [../dispatch/admin-to-field-communication.md](../dispatch/admin-to-field-communication.md) (`unverified`)
    — *"Double stack jobs"* is TCG's term for it.
  - [../quotations/gaps.md](../quotations/gaps.md) *Billable hour minimums and maximums are contractual but
    have nowhere to live*.
- **Blocked:** invoice lines for back-to-back jobs; whether DAS ever needs an intentional-overlap flag.
- **Owner:** Melissa McNutt with Brent Wagstaff (billing); Kyle Harlow for the crew side.
- **Update 2026-10-23:** (d) is answered for the schedule only. Back-to-back jobs are scheduled without overlap, and DAS needs no intentional-overlap flag ([../decisions/2026-10-22-back-to-back-jobs-scheduled-without-overlap-overlap-is-billing-only.md](../decisions/2026-10-22-back-to-back-jobs-scheduled-without-overlap-overlap-is-billing-only.md), Melissa McNutt with Kyle Harlow, `verified`). (a)–(c), what the second job's invoice bills and whether each job carries its full minimum, stay open.

## Fuel cost per job — where the fuel figure comes from, and whether the ERP reports profit per job

- **Status:** open
- **Asked:** 2026-10-22 — ERP demo walkthrough part 2. Source: [2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md](../meetings/2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md) §4. Filed 2026-10-23.
  - Brian Petros (34:28, 35:01): track fuel per vehicle (fuel card, unit number, mileage) to give a **P&L
    per job**, and add the crane's cost and interest for a P&L per job per day. **Brent Wagstaff (CFO),
    35:17:** *"details on the cost for each job is super helpful."*
  - Melissa McNutt (35:25–35:42): trucks fill at the yard the night before, so fuel is not always tied to
    the next day's job; fuel is delivered on site (*"wet fuel"*) sometimes, on holdovers.
  - Brian (35:44): a keypad on the yard pump asking for a code, unit number and miles. Jeff Stricker
    (36:07): Samsara already tracks fuel (the asset showed 88%). Kyle Harlow (36:22): the shop needs a
    better system; a daily entry of mileage and job number is the only accurate record.
  - ehtesham.anwar (34:43, 36:45): can be added to the ERP and the mobile app; how the sources connect is
    not worked out.
- **Question:** **(a)** Which record of fuel is the source: Samsara's fuel level, fuel-card transactions,
  a yard-pump entry, a mobile entry, or several? **(b)** How is fuel bought the night before allocated to
  the next day's job, and wet fuel on a holdover? **(c)** Is a per-job (or per-job-per-day) profit report
  in scope for the ERP, and with which costs — fuel, crane ownership cost, interest, labour?
- **Sources checked:**
  - [2026-07-accounting-team-erp-wishlist.md](2026-07-accounting-team-erp-wishlist.md) (`unverified`) —
    *"every dollar should tie back to a job: crane costs, truck costs, fuel…"*.
  - [../assets/asset-record-requested-additions.md](../assets/asset-record-requested-additions.md)
    (`unverified`) — *"App to be used at the fueling station … to track fuel usage"*, upper and lower
    engines separately.
  - [*Wishlist vs committed scope — nobody has tiered the accounting list*](#wishlist-vs-committed-scope--nobody-has-tiered-the-accounting-list)
    — Brent (09-01): P&L and balance-sheet accounts stay in QuickBooks. A per-job profit **report** is not
    ruled out by that.
- **Blocked:** any fuel capture on mobile or at the yard; job costing.
- **Owner:** Brent Wagstaff (CFO) for scope; Jeff Stricker and Kyle Harlow for how fuel is captured.

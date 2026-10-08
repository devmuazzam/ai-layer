---
title: Accounting — open questions
status: reference
kind: gaps
updated: 2026-10-07
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

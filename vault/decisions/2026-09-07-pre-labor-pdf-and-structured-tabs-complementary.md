---
title: Emailed PDFs and structured Billing/Pre-Labor tabs are complementary, joined by manual transcription — decision
source: decision/product team (verbal), relayed by Jahanzaib Nadeem
decided: 2026-09-07
decided_by: >-
  Product team, verbally, in an undated discussion. Relayed to this session on 2026-09-07 by
  Jahanzaib Nadeem (jahanzaib.nadeem@codingcops.com, git `Jz-Nd`), the developer of branch
  `feat/customer-billing-pre-labor-forms`. **No individual Product person is named and no
  meeting, message or recording is citable.** This is a second-hand report of a verbal
  decision. Ryan Adams / Joe Schacatano own the send flow and Melissa McNutt owns the packet
  — none of the three is recorded here as having said it. Re-confirm with a named owner
  before deleting anything on the strength of this note.
status: verified
resolves: quotations/gaps.md#structured-billing--pre-labor-tabs-vs-the-static-pdf-quotation-send-flow
tags: [module/quotations, module/customers, kind/decision, compliance, requirements]
---

## Decision

Option (b) of the gap entry. The two mechanisms are **intentionally complementary, not
duplicative**, and they are joined by a **manual, sequential workflow**:

1. **Outbound PDF.** When sending a quotation, TCG staff tick boxes in the Send-to-Customer
   modal (`apps/web/src/features/quotation-signatures/components/send-quotation-modal.parts.tsx`,
   `PreQuoteFormsSection`) to email the customer the static PDFs —
   `New Customer Packet.pdf` and
   `Pre Job Labor Compliance Information Request Form final polished.pdf`
   (`packages/shared/src/constants/pre-quote-forms.ts`).
2. **Customer fills it by hand** and emails the completed PDF back.
3. **Inbound manual entry.** A TCG staff member reads the returned PDF and **transcribes**
   its answers into the customer's structured **Billing Information** and **Pre Labor Form**
   tabs on the Customer record
   (`apps/web/src/features/customers/workspace/detail/customer-billing-information-tab.tsx`,
   `customer-pre-labor-tab.tsx`).

Explicitly ruled out, both ways:

- **No automatic extraction or OCR** from the returned PDF is planned. Step 3 is a person
  reading a document and typing.
- **No replacement of the PDF-attachment flow.** `PRE_QUOTE_FORM_FILES`,
  `buildPreQuoteFormsEmailAppendix()` and the two committed PDFs **stay**. Nothing here
  authorises deleting them.
- **No customer self-service.** The customer does not fill the structured form; only TCG
  staff key into it.

## Why

The structured tabs exist to satisfy the rule the forms matrix already states — completed
forms belong in a **system of record rather than only in email**
([quotations/sales-operating-system/05-forms-and-records-matrix.md](../quotations/sales-operating-system/05-forms-and-records-matrix.md)
§1). The PDFs exist because that is the artefact the customer will actually complete and
return; a customer-facing structured form is a different and larger product.

So the pair is outbound-PDF / inbound-manual-entry by design: the PDF is the **collection
instrument**, the tabs are the **system of record**. What looked in review like an
uncoordinated duplicate build is one workflow whose two halves were built without either
referencing the other in code or commit message.

The reasoning to carry forward: **finding the same document represented twice in this
codebase is not by itself evidence of duplication** — check whether one is a customer-facing
artefact and the other an internal record before proposing to delete either.

## Consequence already applied — send-modal copy

Because the modal's checkboxes name the documents staff will later transcribe **into**, the
on-screen copy was changed in the same session to match the Customer tab names:

- `send-quotation-modal.parts.tsx` — checkbox labels now read **"Billing Information"**
  (line ~99) and **"Pre Labor Form"** (line ~107), replacing the stale "New Customer
  Packet" / "Job & Labor Compliance Information Request Form".
- `send-quotation-modal.use-forms-selection.ts` — comments updated to the same terminology.

Deliberately **left unchanged** on the PDF side (this is still the load-bearing half):

- The PDF **filenames** in `packages/shared/src/constants/pre-quote-forms.ts`
  (`CUSTOMER_PACKET`, `JOB_LABOR_COMPLIANCE`).
- The **prop and state names** (`includeJobLaborCompliance`, `onToggleJobLaborCompliance`, …).
- The **numbered PDF titles** in the email appendix (`pre-quote-forms.ts` — *"New Customer
  Packet"*, *"Job & Labor Compliance Information Request Form"*), because that is what the
  customer receives as an attachment and the email must name the file they are opening.

**Correction (2026-09-08 review / PR #490 `dcaa7bf0`):** the customer-facing **intro line**
(`PRE_QUOTE_FORMS_EMAIL_APPENDIX_INTRO`) was **not** left unchanged — it was rewritten from
*"our Pre-Quote documentation"* to *"our customer documentation"*. That string change is
**unsourced** (see [quotations/gaps.md](../quotations/gaps.md#is-pre-quote-being-retired-in-customer-facing-copy-and-who-signs-off-the-send-email-text));
this note only authorised staff-facing checkbox rename and keeping the PDF titles. Do not
treat the intro rewrite as covered by this decision.

The intended asymmetry remains: **staff-facing copy uses the ERP tab names, customer-facing
copy uses the PDF titles** (for the attachment list). Do not "fix" that list by aligning
it to the tabs.

## What stays open

- [erp-review-log.md](../erp-review-log.md) entry #3 (Melissa McNutt, Accounting, 2026-04-02) asks for
  **automatic customer-packet generation** — assembling the right documents per customer.
  That is a third shape, and this decision does not address or dismiss it.
- Dropping `customers.pre_quote_data` / `pre_quote_data_completed_at` was **not put to Product
  and is not authorised here.** Platform PR #490 **removed** migration
  `20260907120000_drop_customer_pre_quote_data` from the branch; the columns stay until a
  named Product decision authorises a drop or backfill.
- `SCRUM-575` was never read this session (Atlassian MCP not mounted; tenant was
  `403 suspended-payment` as of 2026-08-25). It may carry acceptance criteria that sharpen
  or contradict this; check it when Jira is reachable.

## Effect on the vault

- **No winner/loser flip applies, and none was made.** No vault document specified the
  relationship between the two mechanisms — the gap recorded that *nothing* addressed it,
  which is why the question went to a person. Per [README.md](../README.md) → *How a gap
  gets closed*, steps 2 and 3 are written for conflict sets and do not apply.
- **No `status:`, `verified_because:`, `superseded_by:` or `conflicts_with:` field on any
  product file was changed.** [customers/new-customer-packet.md](../customers/new-customer-packet.md)
  stays `status: unverified`: its statement that *"nothing in it says any of this should be,
  or is being, built into the ERP"* remains an accurate description of the packet document,
  and this decision adds the ERP relationship from outside it rather than verifying it.
- [quotations/gaps.md#structured-billing--pre-labor-tabs-vs-the-static-pdf-quotation-send-flow](../quotations/gaps.md#structured-billing--pre-labor-tabs-vs-the-static-pdf-quotation-send-flow)
  → `Status: resolved` — **done**, in this pass.

## Effect on the branch

Sign-off of `feat/customer-billing-pre-labor-forms` is unblocked **on this question only**.
The answer to *"should `PRE_QUOTE_FORM_FILES`, `buildPreQuoteFormsEmailAppendix()` and the
two PDFs be removed?"* is **no — keep them, unwired to the tabs, by design.** The
`pre_quote_data` drop remains undecided (and is no longer shipping on PR #490).

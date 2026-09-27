---
title: A completed DocuSign envelope's signed PDF is kept as an attachment on the quotation and every project and job made from it, visible to everyone for now (Jz-Nd, TCG-21) — decision
source: decision/Jz-Nd (CodingCops developer) — TCG-21, Claude Code session 2026-09-25 to 2026-09-28
decided: 2026-09-28
decided_by: >-
  The developer working ticket TCG-21, git identity "Jz-Nd"
  <jahanzaib.nadeem@codingcops.com>, in a Claude Code session between
  2026-09-25 and 2026-09-28, as an explicitly interim product call ("for now").
  Not confirmed by product: the owners of customer-facing signing on
  quotations/gaps.md are Joe Schacatano / Ryan Adams, and neither has seen or
  ratified this. A developer ruling, not a TCG sign-off, so `status: reference`:
  binding on the CodingCops build now, open to being overruled by TCG.
status: reference
conflicts_with: []
resolves: []
jira: [TCG-21]
tags: [module/quotations, module/projects-jobs, kind/decision, signatures, integrations]
---

# A completed DocuSign envelope's signed PDF is stored as an attachment

## Decision

In the developer's words: *"for project/job, add it in the quotations/projects/jobs
attachments column"* and *"for now let everyone see it"*.

1. **The platform keeps its own copy.** When a DocuSign envelope completes, the platform
   stores the sealed signed PDF — DocuSign's combined document, including the Certificate
   of Completion — rather than only fetching it from DocuSign on demand.
2. **Where it is filed.** That copy is an attachment, category **Signed Quotation**, file
   name **`<quoteNo>-signed.pdf`**, on:
   - the quotation;
   - every project and every job created from that quotation, **including ones created by
     a later conversion** (after the envelope has already completed).
3. **Who sees it — interim.** Anyone who can see the attachments of that quotation,
   project or job can see the signed copy. No extra restriction. This is explicitly a
   "for now" call.

**Envelopes completed before this change are not bulk-backfilled.** Their copy is stored
lazily, the first time someone downloads the signed PDF.

## Why

- **The signed contract could be lost.** UAT session 5 reported *"Signed document is
  missing from the DocuSign flow"* ([uat/sessions/uat-session-5.md](../uat/sessions/uat-session-5.md):22).
  The UAT register row *Signed DocuSign copy stored* was **NOT DONE**: the signed PDF was
  fetched from DocuSign on demand and emailed, never stored, so a DocuSign outage or an
  envelope purge would lose the signed copy
  ([uat/register-2026-09-18.md](../uat/register-2026-09-18.md):198, `unverified`).
- **Nothing written said where it should go or who should see it.** No vault source
  specified a storage location or visibility for the signed copy before this note.
- **Precedent only — FCC.** The old FCC system kept the downloaded signed copy as a
  file link on the quote (`<quote>-Completed.pdf`, Envelope Status *Signed Document*),
  and its file-links grid had an **Include On Job** checkbox to carry attachments over on
  conversion ([quotations/fcc-nexgen-quote-entry.md](../quotations/fcc-nexgen-quote-entry.md):298,
  :581–585, :591, `unverified`). The platform follows the same shape but carries the
  signed copy to projects and jobs always, with no per-file flag. This is how FCC did it,
  not a TCG requirement that the ERP must.

## What this does not settle

- **Visibility.** Whether the signed copy should later be restricted (for example to
  sales and accounting only). "Everyone" is interim.
- **Retention.** How long the stored copy is kept, and whether it survives archive or
  deletion of the quotation, project or job.
- **Whether DocuSign stays at all.** At the 2026-09-15 demo Joe Schacatano said he would
  like to move away from DocuSign — self-labelled as his opinion, with no ticket
  ([meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md](../meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md)
  §5). If signing moves off DocuSign, this note covers only the DocuSign path.
- **Customer delivery.** Whether and how the customer receives the signed copy (email
  after completion, self-download from the return page) stays open on
  [quotations/gaps.md](../quotations/gaps.md) →
  [*Branch fix/12-sep-uat — after DocuSign COMPLETED…*](../quotations/gaps.md#branch-fix12-sep-uat--after-docusign-completed-branded-ses-to-customer-with-signed-pdf-attached)
  and [*Branch fix/quotation-signed-copy-and-customer-po — DocuSign return page…*](../quotations/gaps.md#branch-fixquotation-signed-copy-and-customer-po--docusign-return-page-and-signed-copy-download).
  This note is about the platform's internal copy only.
- **Product ratification.** Joe Schacatano / Ryan Adams should confirm or overrule all
  three clauses.

## Effect on the vault

- No vault file is verified or superseded: nothing in the vault specified this, so there
  is no winner or loser, and no frontmatter was changed.
- The two related `quotations/gaps.md` entries above carry a one-line pointer to this
  note. Both stay **open** — neither asked this question.
- `uat/register-2026-09-18.md`:198 is a verbatim Confluence transcription and was not
  edited.
- Shipped on branch `fix/misc-fixes-2026-09-25` under TCG-21.

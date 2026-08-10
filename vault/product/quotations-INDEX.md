---
title: Quotations — conflict stub
source: generated/conflict-stub
migrated: 2026-08-10
updated: 2026-08-10
status: unverified
kind: conflict-stub
gap: gaps.md#quotations
conflicts_with: [product/quotation.md, product/quotations.md, product/quotation-flow-process.md, product/user-story-and-tasks.md]
jira: []
topics: [quotations, tools-rigging, customers, jobs, signatures, daily-allocation, billing-codes, assets]
entities: [quotation, tool-rigging, customer, job, asset, billing-code, das, task, project, purchase-order]
---

# Quotations — four overlapping sources

**None of these is verified. Do not answer from one of them alone.**

These are four *different kinds* of document about quotations, not four versions of
one. The answer to most questions is probably "read more than one".

| Candidate | Size | Updated | Kind | What it uniquely covers |
| --- | --- | --- | --- | --- |
| [quotation-flow-process.md](quotation-flow-process.md) | 1.9 KB | 2026-07-09 | Process flow | The only end-to-end lifecycle: lead intake → job walk → build quotation → internal approval → send via email/DocuSign → customer approve/reject/revise → convert to Project. Numbered Step 1–27. |
| [user-story-and-tasks.md](user-story-and-tasks.md) | 4.3 KB | 2026-04-22 | User stories | The only acceptance-criteria-level spec: send to customer, customer digital approval, print view, and PDF-vs-embedded delivery format options. **From a personal space** — see its `provenance_note`. |
| [quotations.md](quotations.md) | 1.8 KB | 2026-07-14 | Punch list | Mohsin feedback. DocuSign defects (duplicate emails, envelope voided wording, resend behaviour), revisions/change requests, Gross Margin removal, email templates. Also carries unrelated Assets / Tools & Rigging / Billing code notes. |
| [quotation.md](quotation.md) | 0.8 KB | 2026-06-23 | Punch list | JZ feedback. Industry code dropdown, unit-of-measure disabling, "add tool" rename, pre-quote customer package, Customer PO. Also carries unrelated Job and DAS notes. |

## Notes for whoever resolves this

- The two punch lists are **not scoped to quotations** — both trail off into Assets,
  Tools & Rigging, Billing code, Job and DAS items. Splitting them by module may be
  more useful than picking a winner.
- Nothing here defines quotation *data structure*; the flow document names the inputs
  (Resources, Tools & Rigging, Lift Information, Attachments) without specifying them.
- The flow document skips from Step 12 to Step 16 — steps 13–15 do not exist in the
  source page. That is a gap in the original, not a migration loss.

See the full entry in [`gaps.md`](../gaps.md) → *Quotations*.

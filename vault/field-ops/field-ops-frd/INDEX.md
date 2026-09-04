---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD; same document also received as PDF in shared-folder/Project-Repository-2026-09-04/CC_FRD-Field-Ops-Mobile-App_2026-06-11/TCG-Field Operations App - FRD-110626-200533.pdf
migrated: 2026-08-10
updated: 2026-09-04
status: unverified
conflicts_with: [field-ops/frd-new-format-draft/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/field-ops, kind/reference, requirements, open-questions]
entities: []
parts:
  - 00-document-header.md
  - 01-executive-overview.md
  - 02-problem-statement.md
  - 03-objectives.md
  - 04-scope.md
  - 05-role-definitions.md
  - 06-operational-workflow-overview.md
  - 07-functional-requirements-summary.md
  - 08-functional-requirements/INDEX.md
  - 09-workflow-affecting-business-rules.md
  - 10-brs-references.md
  - 11-open-questions-future-considerations.md
---

# Field Operations App - FRD — section index

This document was split because it exceeded 15 KB. Every byte of the original
page lives in exactly one part below; nothing was merged, dropped, or rewritten.

> **Confirmed against the PDF export, 2026-09-04.** The Project Repository drop contains
> `CC_FRD-Field-Ops-Mobile-App_2026-06-11/TCG-Field Operations App - FRD-110626-200533.pdf` — and a
> second copy, `...pdf M.pdf`, whose converted text is byte-identical — **but whose PDF annotation
> layer is not** (read 2026-09-04; see *Melissa's review annotations* at the end of this page). **It is this same document**:
> FR-TCG-FOP-002, v2.0, DRAFT, June 2026, CodingCops, and the same eleven sections with the same
> thirty `FR-FOP-nnn` requirements. The folder's `.url` shortcut resolves to the Confluence page
> these parts were migrated from, which settles the provenance.
>
> **Nothing new was added; two deltas are worth knowing.** (1) The PDF's §10 *BRS References* table
> shows `Pending` in the Status column for **every** row and an empty *Client Documents links*
> column — the SharePoint links recorded in
> [10-brs-references.md](10-brs-references.md) survived only in the Confluence original, so the
> vault's copy is the richer one. (2) The four BRS reference documents themselves shipped alongside
> the PDF in this drop and are **already in the vault** from the 2026-08-13 OneDrive migration; see
> that same file for where each one landed.

| Part | Section | Size |
| --- | --- | --- |
| [00-document-header.md](00-document-header.md) | TCG Platform — Mobile Application | 0.3 KB |
| [01-executive-overview.md](01-executive-overview.md) | 1. Executive Overview | 0.7 KB |
| [02-problem-statement.md](02-problem-statement.md) | 2. Problem Statement | 0.7 KB |
| [03-objectives.md](03-objectives.md) | 3. Objectives | 0.5 KB |
| [04-scope.md](04-scope.md) | 4. Scope | 0.9 KB |
| [05-role-definitions.md](05-role-definitions.md) | 5. Role Definitions | 1.5 KB |
| [06-operational-workflow-overview.md](06-operational-workflow-overview.md) | 6. Operational Workflow Overview | 0.5 KB |
| [07-functional-requirements-summary.md](07-functional-requirements-summary.md) | 7. Functional Requirements Summary | 1.4 KB |
| [08-functional-requirements/INDEX.md](08-functional-requirements/INDEX.md) | 8. Functional Requirements — **split further, 31 parts** | 38.0 KB |
| [09-workflow-affecting-business-rules.md](09-workflow-affecting-business-rules.md) | 9. Workflow-Affecting Business Rules | 0.6 KB |
| [10-brs-references.md](10-brs-references.md) | 10. BRS References | 0.4 KB |
| [11-open-questions-future-considerations.md](11-open-questions-future-considerations.md) | 11. Open Questions / Future Considerations | 0.7 KB |

## Melissa's review annotations on the `M.pdf` copy — read 2026-09-04

The ` M.pdf` copy was dismissed as a duplicate because its *text* is identical. Its **annotation
layer** is not: it carries eight sticky-note comments by **Melissa Di Pane** — the client's
review of this FRD, which exists nowhere else in the vault. Verbatim, by PDF page:

| Page | Melissa's comment |
| --- | --- |
| 4 | *"Field Employees 1. Operator and Oiler 2. All other Support Loads are the Third man 2. Riggers 3. Truck Driver"* — a four-role taxonomy of field employees, in which **every support-load driver is a "Third Man"** |
| 5 | *"Yes we would like the employees to click a button to confirm"* |
| 5 | *"During the pre lift tailboard we'd like the crews to have an option to do the WTL if the customer says ahead of time that they are approving it"* — **worked-through-lunch pre-approval captured at the tailboard**, not after the fact |
| 5 | *"The Compliance check list should be done after they arrive at the yard but before they complete their ticket time"* — **compliance checklist after Arrive Yard, before ticket close** |
| 5 | *"Customer signature needs to be before the crew leaves the job. We'd like them to have the option to get this signed at any point once they arrive at the job"* — this bears directly on the step-order contradiction recorded in [../field-app-demo-2026-06.md](../field-app-demo-2026-06.md) (demo: signature on site; this FRD §6: signature last): the client wants it **on site, any time after arrival, before departure** |
| 9 | *"Show job attachements"* |
| 14 | *"All in 30 minute increments"* — on the time-entry section |
| 15 | *"We want as much information as possible to auto fill from the job. Job #, equipment, employees on site, job address, nearest hospital with address link, etc"* — the JSA/tailboard pre-fill list, including **nearest hospital with an address link** |

These are the client's own words on the requirements document — review feedback, not a new
requirement source. Recovered with `pypdf` from the PDF's `/Text` annotations; the file's other
eight annotation objects are the pop-up windows for these.

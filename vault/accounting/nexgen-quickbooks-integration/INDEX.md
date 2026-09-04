---
title: NexGen ↔ QuickBooks Online integration — index
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/QB_Connector/ and .../FCC-USER-GUIDES/ (QuickBooks setup PDFs)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, kind/index, integrations, invoicing, architecture, provenance]
entities: []
---

# NexGen ↔ QuickBooks Online integration

**What this is.** The complete `QB_Connector` folder from the 2026-09-04 Project Repository
drop, plus the two QuickBooks-side setup guides that sat with the FCC user guides. Together
they document **how TCG's operations system (FCC NexGen) posts to its accounting system
(QuickBooks Online) today**, what is wrong with that integration, and what TCG asked FCC to
change.

**Why it matters.** Accounting stays in QuickBooks — that was settled on 2026-09-01: *"all of
the workflows that are in QuickBooks should remain in QuickBooks… the ERP takes the
reporting"*, and **integration is to be by API, not QODBC**
([../gaps.md](../gaps.md#wishlist-vs-committed-scope--nobody-has-tiered-the-accounting-list)).
So this material is not a build spec. It is the **only written description of the seam the ERP
will replace**, and it names, field by field, every value that has to survive the swap. It also
contains TCG's own analysis of where the current seam breaks — which is the closest thing the
vault has to acceptance criteria for the replacement.

> **Vintage and authorship.** The FCC field-mapping document is the vendor's own product
> documentation and is undated. The checklist, the reimplementation overview and the detailed
> specs are **TCG-side documents** written after the November 2025 sync incident, addressed to
> *"IT Manager, FCC Integration Team, CFO"*. They are proposals, not agreements — nothing in
> the drop shows FCC accepting any of them.

## Pages

| File | Answers |
| --- | --- |
| [01-fcc-connector-field-mapping.md](01-fcc-connector-field-mapping.md) | **What the connector actually maps today**, table by table — FCC's own vendor documentation |
| [02-integration-review-checklist.md](02-integration-review-checklist.md) | **What TCG thinks is wrong with it** — the field-by-field review checklist, in prose and workbook form |
| [03-proposed-reimplementation.md](03-proposed-reimplementation.md) | **What TCG asked FCC to change** — ID-based joins, system-of-record rules, the CFO-facing case |
| [04-quickbooks-online-setup-guides.md](04-quickbooks-online-setup-guides.md) | **The QuickBooks-side configuration** the connector depends on — account numbers, items ↔ billing codes |
| [05-case-39995-data-sync-incident.md](05-case-39995-data-sync-incident.md) | **What went wrong in November 2025** and what TCG committed to as a result |
| [06-quickbooks-customer-contact-export.md](06-quickbooks-customer-contact-export.md) | **What is actually in the QuickBooks customer file** — 6,073 records, structure and code lists only |

## Read with

- [../gaps.md](../gaps.md#gl-codes--fccerp-chart-vs-quickbooks-and-who-owns-the-mapping) — the
  open GL-mapping question these documents partly answer
- [../invoice-packets-2026-04-worked-examples.md](../invoice-packets-2026-04-worked-examples.md)
  — the printed output of the invoices this connector posts
- [../fcc-invoicing-in-nexgen.md](../fcc-invoicing-in-nexgen.md) — the NexGen side: how an
  invoice gets to `Export OK` in the first place
- [../../meetings/2026-08-26-fcc-migration-client-brief.md](../../meetings/2026-08-26-fcc-migration-client-brief.md)
  — the FCC table inventory, including `FMS_GL_ACCOUNTS`

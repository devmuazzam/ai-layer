---
title: Accounting — module index
status: reference
kind: index
updated: 2026-09-04
tags: [module/accounting, kind/reference]
---

# Accounting

Invoicing and accounting (module not yet built). Backend usecases: `billing, expense-gl-accounts`. Organized per [STRUCTURE.md](../STRUCTURE.md).

> **The boundary, settled 2026-09-01:** QuickBooks keeps the books; the ERP takes the
> reporting. Journal entries, trial balance, P&L and balance-sheet accounts are out. See
> [gaps.md](gaps.md#wishlist-vs-committed-scope--nobody-has-tiered-the-accounting-list).
> Most of what follows therefore documents **the system the ERP will read from and report on**,
> not a system it will replace.

> **⚠️ The `3.8.1_MODULE-ACCOUNTING-AP-AR` archive in the 2026-09-04 drop arrived truncated** —
> one text file and an empty `AR - Billing Processes/Ariba/` folder, nothing else. Everything
> else that archive should have held **must be re-requested from the client** before this
> module is specified. Detail:
> [accounting-team-quickbooks-and-spreadsheet-activities.md](accounting-team-quickbooks-and-spreadsheet-activities.md).

## Files

| File | Answers | KB |
| --- | --- | --- |
| [2026-07-invoicing-adjustment-taxonomy.md](2026-07-invoicing-adjustment-taxonomy.md) | **Which ticket events deduct from the invoice, which don't, which bill extra** — Tia & Micaela's taxonomy with live exhibits | 4 |
| [../payroll/payable-vs-billable-hours.md](../payroll/payable-vs-billable-hours.md) | **How billable hours differ from payable hours** — same yard-to-yard span, then contract minimums and downtime deductions on the billing side; the open billing-model question (added 2026-09-07) | 6 |
| [2026-07-accounting-team-erp-wishlist.md](2026-07-accounting-team-erp-wishlist.md) | **What the accounting team wants from the ERP** — the July 2026 client wishlist, cross-linked into payroll/quotations/assets. Start here when the module kicks off (~Oct–Nov 2026) | 8 |
| [invoice-packets-2026-04-worked-examples.md](invoice-packets-2026-04-worked-examples.md) | **What a TCG invoice and its packet actually look like** — six real April 2026 packets: header fields, line shape, the real billing-code vocabulary, the surcharge and permit-markup arithmetic, and what the backing pages contain | 20 |
| [accounting-team-quickbooks-and-spreadsheet-activities.md](accounting-team-quickbooks-and-spreadsheet-activities.md) | **Who does what in QuickBooks today, and the 15 Excel sheets and 4 OneDrive folders the department runs on** — plus the truncated-archive flag | 9 |
| [nexgen-quickbooks-integration/](nexgen-quickbooks-integration/INDEX.md) | **How FCC posts to QuickBooks today, what's broken, and what TCG asked for** — 6 pages: the as-built field mapping, TCG's audit checklist, the reimplementation proposal, the QBO-side setup, the Nov-2025 sync incident, the customer-file audit export | 41 |
| [fcc-invoicing-in-nexgen.md](fcc-invoicing-in-nexgen.md) | **How an invoice is built and reaches `Export OK`** — the four invoice types, `Qty To Bill` vs `Qty Quoted`, taxability-by-billing-code, invoice approval, recurring billing, billing codes and price lists | 15 |
| [avalara-sales-tax-in-nexgen.md](avalara-sales-tax-in-nexgen.md) | **How sales tax is calculated on an invoice** — AvaTax setup, the fully-taxable default, the job-site address-validation gate, and the invoice-number lock | 11 |
| [ap-ar-value-engine-and-whiteboard-flow.md](ap-ar-value-engine-and-whiteboard-flow.md) | **The AP and AR process end to end, as TCG drew it** — the Aug-2025 value-engine flowchart plus the whiteboard workbook with its swimlanes and the 90-day lien escalation | 12 |

## Open questions

[gaps.md](gaps.md) — this module's live register (entry format inside). Ticket questions stay in that ticket's `spec.md` §12.

## Cross-module

- [../erp-review-log.md](../erp-review-log.md) — the client's own feedback register; entry **#3**
  is the covering ask behind the invoice packets (automatic per-customer packet generation), and
  its *Tickets, billing and reporting* section is accounting material
- [../quotations/billing-code-and-price-list.md](../quotations/billing-code-and-price-list.md) —
  billing codes and price lists as a quotations concern
- [../payroll/rules/INDEX.md](../payroll/rules/INDEX.md) — craft codes, WTL and subsistence, all
  of which surface on the invoice packets' labour pages

## Meetings

11 meeting files carry `module/accounting` — list them:

```
grep -rl 'module/accounting' vault/meetings/
```

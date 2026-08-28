---
title: TCG – Discussion Points (28 August 2026)
source: user-supplied/meeting-minutes
migrated: 2026-08-28
updated: 2026-08-28
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, module/vendors-agencies, kind/meeting-notes, accounts-receivable, accounts-payable, purchase-orders, quickbooks, chart-of-accounts, invoicing]
entities: [credit-memo, remittance-advice, ach-payment, cash-flow-daily-check-in, purchase-order, voucher, chart-of-accounts]
meeting_date: 2026-08-28
---

# TCG – Discussion Points, 28 August 2026

**Accounting discovery — Edison AR, general AR/invoicing, Sam's AP/PO workflow.** TCG walked
CodingCops through the current manual accounting process. No transcript is filed for this date;
these are the minutes as supplied.

> **Forward-looking, like the other accounting-discovery minutes in this folder.** See the note
> in [2026-08-05-payroll-module-design-review.md](2026-08-05-payroll-module-design-review.md) —
> the `meetings/` retrospective caveat does not apply to these client minutes.

## Discussion points

**Edison remittance and credit-memo process**

- Southern California Edison sends remittance details with a list of invoices whenever a
  payment is made, on **2% Net 10** payment terms.
- The process is handled in QuickBooks: locate Southern California Edison under Customers and
  Leads, create an **Issue Credit Memo**, and use the credit-memo amount listed at the bottom of
  the remittance.
- After the credit memo, the payment is recorded through **Create → Receive Payment**, selecting
  Southern California Edison.
- Edison payments arrive as **one ACH payment covering multiple invoices**.
- Edison applies the **2% discount** per the payment terms.
- The QuickBooks payment total is matched against the remittance total to confirm every invoice
  is included.
- **Permit and traffic control services** are manually adjusted with a **10% markup**.

**Regular customer invoicing workflow**

- Invoices are exported from FCC to QuickBooks, checked against FCC, and then individually
  emailed to customers with a PDF invoice and a QuickBooks payment link.
- **FCC has no accounting functionality** — it does not track open/paid invoices, customer
  balances, or direct payments.
- QuickBooks tracks when customers receive and view invoices.
- Recorded payments are also entered into the **AR Cash Flow Daily Check-In KPI spreadsheet**,
  which tracks payment dates and amounts and supports cash forecasting and collections.
- Regular customer invoices are created in FCC, exported to QuickBooks, and emailed individually
  to customers through QuickBooks.

**Sam's Accounts Payable (AP) workflow**

- Invoices are received through shared OneDrive folders.
- Invoices with **no PO** (fuel, tires, Samsara, etc.) are manually entered into QuickBooks
  against the required vendor.
- **PO-based invoices** are matched to the related PO in FCC using the PO number.

**Other topics touched**

- PO receiving & voucher process.
- Chart of accounts.

## Action items

| Owner | Action |
| --- | --- |
| CC Team | Review the SOP document and assess the documented accounting process. |
| CC Team | Review and follow up on the AR Cash Flow spreadsheet in the shared folder. |
| TCG Team | Provide the CC Team a QuickBooks user account — view-only is sufficient. |
| TCG Team | Continue on the Accounting module next Tuesday (2026-09-02). |

## How this lands against the vault

- **Confirms, rather than adds to,** the AR/cash-forecasting gap already open in
  [accounting/gaps.md](../accounting/gaps.md) — this session is the first walkthrough of the
  actual mechanics (Edison credit-memo flow, ACH-covers-multiple-invoices, the 2% discount, the
  10% permit/traffic-control markup) behind that gap, not a new requirement.
- **FCC has no accounting functionality** is a direct, unambiguous statement — accounting stays
  entirely QuickBooks-side today; nothing here changes the standing read that accounting is out
  of the current ERP build scope.
- The **AR Cash Flow Daily Check-In KPI spreadsheet** is a source not previously named in the
  vault; it is the mechanism behind the cash-forecasting reporting ask already logged in
  [accounting/2026-07-accounting-team-erp-wishlist.md](../accounting/2026-07-accounting-team-erp-wishlist.md).
  Read that spreadsheet before specifying AR/cash-forecast reporting.
- **PO-number matching in FCC** for AP is new detail on the PO/voucher side; no vault source
  previously described how an AP invoice is tied back to its PO.
- Not recorded in this meeting: a GL owner/mapping answer — the open question in
  [accounting/gaps.md](../accounting/gaps.md#gl-codes--fccerp-chart-vs-quickbooks-and-who-owns-the-mapping)
  stays open.

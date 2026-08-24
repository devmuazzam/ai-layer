---
title: Accounting team ERP wishlist — client message, July 2026
source: client message (Brian Petros relay of the accounting team), ~July 2026; captured into the vault 2026-08-24 from the message batch
status: unverified
kind: source
updated: 2026-08-24
tags: [module/accounting, module/payroll, module/assets, module/customers, kind/source, requirements, invoicing, reporting, purchase-orders]
---

# Accounting team ERP wishlist — July 2026

**What this is:** the accounting team's own list of what they want from the ERP, relayed by
the client with *"Let me know any questions you have."* Captured verbatim-in-structure so the
October/November accounting kickoff starts here, not in a chat scrollback. **Nothing here is
scoped, tiered, or committed** — see [gaps.md](gaps.md).

**Read with:** the payroll register ([../payroll/rules/INDEX.md](../payroll/rules/INDEX.md))
for everything under *Payroll Integration*; the quotations pricing gap
([../quotations/gaps.md](../quotations/gaps.md)) for billing-rate versioning; the
2026-06-30 ADP data-ownership decision
([../decisions/2026-06-30-adp-erp-employee-data-ownership.md](../decisions/2026-06-30-adp-erp-employee-data-ownership.md)).

## Core accounting

- **General Accounting:** General Ledger · Accounts Receivable · Accounts Payable · Bank
  reconciliation · Financial statements · Budgeting · Fixed asset management · Sales tax
  management · Audit trail
- **Job Costing — "every dollar should tie back to a job":** crane costs, truck costs, fuel,
  operator wages, riggers, per diem, hotels, rentals, permits, subcontractors, materials.
  Acceptance bar, verbatim: *"What was the actual profit on Job #4528?" — answerable within
  seconds.*
- **Equipment Cost Tracking** (per crane): purchase value, depreciation, insurance,
  maintenance, fuel, repairs, tires, licensing, GPS costs, **internal hourly ownership cost**
  → true profitability reporting. *(→ assets module)*

## Payroll integration *(all already in the payroll register)*

Certified payroll · Davis-Bacon · prevailing wage → **[PAY-072](../payroll/rules/PAY-072-certified-payroll-davis-bacon-reporting.md) — third independent demand signal, still ownerless** ·
union wages → PAY-010 · multiple pay rates → PAY-015 · overtime rules → PAY-022–027 ·
per diem → PAY-048/049 (subsistence) · shift differential → PAY-036/037 ·
operator certifications → field-ops.

## Billing

Methods: hourly · daily · weekly · monthly rental · lump sum · time & material ·
**mobilization/demobilization** *(→ [../quotations/mob-demob-INDEX.md](../quotations/mob-demob-INDEX.md))* ·
standby · weather delays · cancellation fees.
**Nuanced requirement, verbatim intent:** *cancel charges recorded for our records, but the
customer invoice does not show the charge and cancellation.* (Internal-only charge lines.)

## Customer management (accounting view)

Credit limit · aging · insurance certificates · tax-exempt forms · outstanding balance ·
payment history with average-days-outstanding (report across all customers).

## Purchase orders → jobs

POs connect directly to jobs: *purchase fuel → assigned to Job 5531 → appears in job cost
automatically.* *(BE: `purchase-orders`, `job-vendor-asset-po-assignments` already exist.)*

## Inventory

Rigging · blocks · slings · wire rope · outriggers · spreader bars · misc supplies.
*(→ assets module; tools-rigging.)*

## Reporting

Job profitability · equipment profitability · customer profitability · monthly P&L ·
cash flow · aging · **WIP report** · utilization.

## Automation & AI ambitions *(unscoped — tier before committing)*

- **OCR invoice processing:** vendor email → ERP reads → match to PO → suggest GL account
  (job comes from the PO) → route PO+invoice for approval → post automatically
- **Approval workflows:** e.g. >$500 → PM → Accounting → Owner, automatic routing
- **Credit-card integration:** Visa/MC/AMEX import, auto-categorize
- **Digital expense reports:** employee uploads receipt; AI reads vendor/amount/date/tax
- **Electronic vendor payments:** ACH · check printing · Positive Pay · payment scheduling
- **Customer portal:** view invoices · pay online · auto-send statements · ERP reads manual
  checks and applies them
- **Mobile time entry** (operators: hours, travel, standby, fuel, mileage, notes → feeds
  payroll) — *largely the Atom app already being built (field-ops)*
- **Job document storage — "mandatory before moving forward":** quotes, lift plans,
  invoices, photos, contracts, tickets, change orders on every job
- **Maintenance integration:** repair bills auto-update equipment cost, maintenance
  history, downtime
- **Budget vs actual, live** · **real-time profitability dashboard** (worked example:
  revenue 48,000 − labor 14,500 − fuel 2,240 − repairs 900 − transport 4,800 = 25,560, live)
- **AI job-cost predictions** ("burning labor 18% faster than estimate")
- **AI invoice matching** (invoice ↔ PO ↔ receiving ↔ job, flag discrepancies)
- **Equipment profitability score** per crane (revenue, operating cost, maintenance,
  downtime, ROI)
- **Predictive maintenance costing** (accrue before the repair lands)
- **Cash-flow forecasting** — 13-week projected balance (payroll, vendors, collections,
  loans, taxes)
- **Automatic WIP calculations** (percent complete, earned revenue, under/overbilling)
- **AI collections assistant** (reminders day 15/30/45, call at 46, hold at 90 — flag
  customer: no more quotes, talk to AR)
- **Executive dashboard** (revenue today, active jobs, profit today, cash on hand,
  crane/hour utilization, AR, AP, payroll due, fuel this week, largest overdue invoices)

## The integration thesis (verbatim in substance)

A single job flows end to end: sales quotes → customer approves → dispatch schedules →
operators clock in via mobile → GPS confirms travel/arrival → fuel, labor, maintenance post
to the job automatically → digital lift tickets signed on-site → **invoice generated from
actual hours and approved change orders** → customer pays online → financials update with no
re-entry. Accounting becomes a real-time consumer of operational data, not a separate
department.

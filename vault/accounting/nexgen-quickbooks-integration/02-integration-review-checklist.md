---
title: QBO integration review checklist — TCG's own field-by-field audit
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/QB_Connector/NexGen_QBO_Integration_Checklist.docx and .xlsx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, module/payroll, module/vendors-agencies, kind/reference, integrations, invoicing, open-questions, compliance, architecture]
entities: []
---

# QBO integration review checklist — TCG's own field-by-field audit

**What this is.** Two forms of the same TCG-authored review of the FCC connector: a **prose
checklist** (`.docx`) that walks the mapping section by section and asks what needs deciding,
and a **workbook** (`.xlsx`) that turns the same content into a nine-sheet tracker with
Review Status / Issues / Change Required / Owner / Target Date columns. It cites the FCC
mapping document ([01-fcc-connector-field-mapping.md](01-fcc-connector-field-mapping.md)) by
page throughout.

**Why it matters.** It is the client's own list of what is broken and what has never been
decided about their accounting integration — written before any ERP replacement was scoped. As
input to the ERP's accounting-reporting seam it is worth more than the mapping itself, because
it separates *what the connector does* from *what TCG actually needs it to do*.

> **Status.** The workbook's `Review Status`, `Issues / Notes`, `Change Required?`, `Owner` and
> `Target Date` columns are **empty on every row**. This is an unstarted tracker. Only the
> Global/Integration Setup section of the prose version has answers filled in.

## The four answers TCG did record

Section 1 of the prose checklist is the only part with responses:

| Question | TCG's answer, verbatim |
| --- | --- |
| Confirm you are using the QODBC driver **for QuickBooks Online**, not desktop | *"Using QODBC driver"* |
| Confirm which QBO company file this NexGen database points to | *"Points to production database"* |
| Document who is allowed to change integration settings (GL links, AR/AP accounts, TERMS) | ***"This was setup by FCC, so they have to do the updates/changes"*** |
| Confirm you have a test company or test connection | ***"We have a TEST FCC database, but don't have a test QBO account"*** |

Those last two are the operative facts. **TCG cannot change its own integration settings** —
FCC must — and **there is no non-production QuickBooks to test against.** Any change to the
accounting seam is therefore a vendor request executed against live books.

## What the checklist says is wrong, by area

Only the substance is reproduced; the workbook's per-row scaffolding is not.

### Invoice numbers — named as the root cause

> *"VERY important for your reconciliation and commission work: Check that users **cannot
> change the NexGen invoice code after posting** (this is the root of your mismatch pain)."*

and, in the recommendations:

> *"**Lock down invoice numbers in NexGen.** Since RefNumber in QBO = NexGen Invoice Code, this
> must be treated as **immutable** to avoid reconciliation hell."*

### Job code and ticket number reach QuickBooks nowhere

> *"The current spec doesn't mention job codes at all… For your commissions, job costing, and
> matching FCC ↔ QBO, I'd strongly consider: QBO **Custom field** 'FCC Job Code', or use
> **Class** or **Location** to carry job or branch info."*

The workbook carries this as an explicit *(Potential Enhancement)* row on the Invoices sheet,
marked **Critical = Y** — the only enhancement row so marked.

### Invoice lines carry no quantity or rate

> *"With InvoiceLineRate = 1, your QBO invoice lines are just 'one lump amount.' … You lose
> **qty × rate visibility** in QBO; everything becomes 'one line for X dollars.'"*

Suggested remedies: map to Items (*"Crane Rental," "Permits"*) rather than raw GL, and put
job / ticket / crane / hours into line-level descriptions.

### GLLINK is populated by accident

> *"The 'no GL sync; GLLINK updates only when missing' can create silent mismatches. I'd add a
> periodic check or a simple report for **NexGen GL accounts without valid GLLINK** and require
> accounting sign-off when new GLs are added."*

The workbook's `GL_GLLINK` sheet carries *(Process) New GL Account creation* and *(Validation)
Missing GLLINK entries* as rows in their own right, both Critical = Y.

### SSN flows to QuickBooks

> *"SSN is included — verify you're comfortable with this flowing into QBO from a **security and
> compliance** standpoint."*

The workbook repeats it on the Employees sheet: *"Employee social security number
(security/compliance concern)"*, Critical = Y.

### TimeTracking may not be wanted at all

> *"Confirm **which hours** are being sent (total vs ST/OT/DT/HT split). The doc shows only
> 'Worked Hours'…"* · *"Verify EndPayDt is the right date (e.g. you might want **actual work
> date** instead of pay period end)."* · *"If you don't actually cut paychecks from QBO
> (because you use ADP), you might not want to send as much payroll detail into QBO at all —
> just summarized GL entries."*

### Defaults nobody has revisited

`IsPending = 0` — *"Make sure you truly never use pending invoices in QBO."*
`IsToBePrinted = 0` — *"If you use QBO to batch print/email invoices, a permanent '0' might not
be what you want."* TCG **does** email invoices from QuickBooks
([../../meetings/2026-08-28-accounting-process-discussion.md](../../meetings/2026-08-28-accounting-process-discussion.md)),
so this flag is worth checking against practice.

### Questions the checklist raises and leaves open

Reproduced because each is a real unknown, not a rhetorical prompt:

- Is `CustCode` stable and unique — *"do users ever change it after the customer is created?"*
- Do you need a **different display name vs legal name**? The mapping forces them equal.
- Is **billing contact vs site contact** enough, or is a separate **AR email** needed in QBO?
- Is NexGen or QBO the system of record for **credit limits**?
- Does every NexGen terms code have a matching QBO term, and are users choosing the right one?
- Do you ever need **more than one AR account**? Which AP account(s)?
- Are you using **GL-based invoices** in QBO, or Items as well (undocumented either way)?
- Should time entries ever be **billable** in QBO — they are forced to `NotBillable`.
- Should Job codes, regions or industries land in QBO as **Classes, Locations or custom
  fields**?

## The testing protocol it proposes

Worth keeping as-is; it is a usable acceptance procedure for any replacement seam.

1. Pick **3–5 representative jobs** — a mix of standard work, complex work, permits, credits.
2. Trace each: job → NexGen invoice → export views → QBO invoice and GL detail.
3. Confirm per job: customer, terms and AR account correct; **invoice number unchanged, no
   manual renumbering**; PO number, job code and other key references present somewhere in QBO;
   line amounts and GL accounts agree with what commissions and revenue-by-type need; credits
   reverse the right revenue/GL.
4. Run a **trial-balance / GL-detail comparison** for a period — NexGen revenue/AP/AR vs QBO.
5. **Document any manual adjustments accounting regularly makes in QBO**, and decide whether
   each should instead be handled in NexGen or in the mapping.

Step 5 is the one to hold on to: the 10%/15% permit markup and the Fuel & Insurance surcharge
seen on the real invoices
([../invoice-packets-2026-04-worked-examples.md](../invoice-packets-2026-04-worked-examples.md))
are exactly the kind of manual adjustment it is asking to be enumerated.

## Workbook structure

Eleven sheets — `Overview`, `specs-proposed` *(empty)*, `Customers` (11 rows), `Invoices` (11),
`InvoiceLines` (5), `Employees` (9), `TimeTracking` (7), `Vendors` (6), `Bills_Credits` (9),
`GL_GLLINK` (4), `Testing_Controls` (5). Columns: `NexGen Table / Source | NexGen Field / Logic
| QBO Object | QBO Field | Purpose / Description | Critical? (Y/N) | Review Status | Issues /
Notes | Change Required? (Y/N) | Owner | Target Date`. The `Critical?` column uses **Y / M / L**,
not Y/N as its header claims.

The workbook's mapping rows restate
[01-fcc-connector-field-mapping.md](01-fcc-connector-field-mapping.md) and are not duplicated
here; the rows it adds beyond the vendor mapping are the *(Potential Enhancement)*,
*(Process)*, *(Validation)*, *(Testing)* and *(Control)* rows quoted above.

## Source

- `1.0.2_FCC-RESOURCES-GUIDES/QB_Connector/NexGen_QBO_Integration_Checklist.docx` — pandoc gfm
- `…/NexGen_QBO_Integration_Checklist.xlsx` — 11 sheets, per-sheet row dump. Same content in
  tracker form; the two are not in conflict.

---
title: Sales commissions — the invoice-driven commission engine
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/Copy of Sales Commissions Process/ — TCG_Sales_Commissions_with_Coord_SOP_v7.1.docx (text and its 47 embedded screenshots) and TCG_HR_SALES_COMMISSIONS_with Coord_v7.1.xlsm
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/payroll, module/accounting, kind/sop, pricing, integrations, reporting, invoicing, architecture]
entities: []
---

# Sales commissions — the invoice-driven commission engine

**What this is.** TCG's monthly sales-commission process: a 12-section **SOP v7.1 (effective
2026-07-27)** and the **macro-enabled Excel application** it operates. Document Owner: *Data
Engineer*; Department: *Accounting / Sales Operations*; System: *"Excel workbook + Power Query +
SQL + VBA; FCC-NexGen + QuickBooks Online"*.

> ### Where this belongs
>
> **This is compensation, and it may belong with payroll rather than quotations.** It is filed
> here because *what* is commissioned is a **quote/deal outcome** — the salesperson and sales
> coordinator on the FCC quote, the customer and customer group on the deal, and the invoice the
> quote produced. The *payment* side (how the commission reaches a paycheque) is payroll's.
> **A human should decide which module owns it**; nothing about the content changes either way.

**Why it matters.** It is the only document in the drop that describes an operating integration
between **FCC and QuickBooks Online**, and the only one that states rules about *which revenue is
commissionable*. Those exclusions (subsistence, travel permits) are billing-code-level decisions
that the ERP's billing model would have to be able to express.

---

## 1. The pipeline

```
FCC (Operations)          QuickBooks Online          Commission Workbook          Power BI
  Invoice source     →    Payment/credit status  →    Review + output      →     Reporting
```

**Inputs**

- **FCC invoices** for a start/end date range — *"Automatically imported directly from FCC"* via a
  live SQL connection.
- **QBO invoice header and detail** — *"Two reports run in QBO and copy/pasted into this Sales
  Commission file."* **This half is manual.**
- Commission plan settings/configuration and override rules.
- User-entered **Payroll Notes**.

**Outputs**

- Final commission rate and commission amount per eligible invoice.
- Exception flags and status labels for review.
- Payroll Notes log for audit and follow-up.
- A **Power BI app with row-level security** — *"email address/username is used to determine which
  rows to show, where **each salesperson can see their own and managers can see all**."*

**Roles:** Commission Runner (Payroll Manager) runs the refresh, reviews exceptions, logs notes
and prepares the payroll export; Finance Reviewer validates totals, approves
exceptions/overrides and signs off; Data/IT Support maintains connections and business rules.

## 2. The date rule, and its known hole

Start/End dates are **based on the FCC `Invoice Date`**. The SOP flags the consequence itself:

> *"There is a chance that **a single Job may have Invoices inside AND outside of the dates
> selected**… (**only** the invoices within the selected date range will be included)."*

So commission is invoice-period based, not job based, and a multi-invoice job can straddle
periods.

## 3. The workbook's sheets

| Sheet | Visible? | What it is |
| --- | --- | --- |
| `START` | ✔ | Start/End date entry and the **Refresh All** button. *"Note: this button does not save Payroll Notes."* |
| `QboInvHeader`, `QboInvDetail` | ✔ | QBO custom-report exports, **pasted in by hand** (values only), with the report date range and run time recorded at the top |
| `QboExcluded` | ✔ | The services excluded from commission (§5) |
| `Salespersons_SETTINGS` | ✔ | The salesperson roster pulled live from FCC, plus **all salesperson plan configuration** |
| `Coordinators_SETTINGS` | ✔ | The sales-coordinator roster from FCC, plus **coordinator plan configuration** |
| `Exceptions_Duplicates` | ✔ | Invoice codes with multiple rows — *"usually caused by a single Invoice in FCC-NexGen that has multiple rows/records in QBO (usually due to one or more credit memos)"* |
| `Sales_Commissions` | ✔ | **The working sheet** — the calculated result, with slicers and the Payroll Notes column |
| `__hiddenParams` | ✖ | Org name, app name, app version, **FCC server name and `NexGenFMS` database name**, calendar start/end (2025-01-01 → 2026-12-31) and a generated month calendar. `[The FCC server address is in the source file — deliberately not copied.]` |
| `__Data_Log` | ✖ | The stored Payroll Notes table |
| `VersionUpdateNotes` | ✖ | Change notes between versions (§7) |
| `FccInvoices` | ✖ | Raw FCC query results |
| `FccInvoices_with_QBO` | ✖ | *"the **master** results of all sales commissions calculations/columns for all Salespersons and Sales Coordinators"* — the visible sheet is a column subset of this |

**Operational constraints stated in the SOP:** the file *"must be opened using Excel on the
computer (**it will not work in Excel in the browser**)"*; macros and content must be enabled; and
on first open, Power Query's Privacy option must be set and saved before the database queries will
run.

## 4. The commission plan model

**Salesperson plan** — one row per plan period, per salesperson:

| Field | Meaning |
| --- | --- |
| `SpersonCode` | must match a code in the FCC-derived *TCG Sales Team* table |
| `SalespersonName` | auto-fills from the code |
| `BaseRate` | base commission rate % |
| `HasThresholdRule` | TRUE/FALSE — *"is there a point at which the sales commission rate changes"* |
| `MonthlyThreshold` | the **$ amount, per calendar month**, at which the rate switches |
| `RateAboveThreshold` | the rate applied above the threshold |
| `CommissionStart` / `CommissionEnd` | **effective dates, based on the Invoice Date** |
| `Notes` | free text |

> *"Note: can create **multiple rows for the same salesperson with different Commission Start/End
> dates**."*

**Customer-level overrides.** A second table assigns special rates per **`Customer`** or
**`Customer Group`**, with `AppliesToType` (`CustCode` or `CustGroup`), `OverrideRate`,
`StartDate`, `EndDate`, a numeric **`Priority`** (*"higher # is higher priority… priority is for
this table only… will not conflict with other tables"*) and a description. A third table defines
the customer groups themselves (`CustGroup` + `GroupDescription`, then group membership rows), and
a fourth applies per-customer adjustments with `AdjustField` / `AdjustType` (e.g. *"Reduce Amount
by 2%"*).

**Sales coordinator plan** — one row per coordinator, keyed on **`CheckTakenID`** (the FCC *Taken
By* field), with `BaseRate`, and additionally a paired `SpersonCode` / `SalespersonName` and a
**`SalesAndCoordRate`**:

> *"If both 'CoordinatorName' and 'SalespersonName' are filled in, then it uses this
> '**SalesAndCoordRate**'… **if the 'Salesperson' and 'TakenBy' codes match for that Job**."*

So a coordinator can carry a different rate on jobs where they are also the salesperson.
Coordinators have the same threshold and effective-date fields.

**One named exclusion rule**, stated in the SOP: *"**All jobs with the salesperson of 'Joe
Deitrick' (SalespersonCode: JD55) are automatically excluded from commissions for all Sales
Coordinators.**"*

> **Individual rates, thresholds and per-customer overrides were deliberately not copied** — they
> are named individuals' compensation terms. The structure above is complete; the values are in
> `Salespersons_SETTINGS` and `Coordinators_SETTINGS` in the source workbook.

**Two identity fields do double duty in FCC.** The SOP notes for both settings sheets that *"the
'**Taken By**' field in FCC"* is what identifies the salesperson **and** the coordinator — which
is consistent with the FCC quote screen carrying `Salesperson`, `Taken By` and `Checked By` as
three separate people ([fcc-nexgen-quote-entry.md](fcc-nexgen-quote-entry.md) §2). **Commission
therefore depends on quote-entry discipline**, and TCG's own SOP prescribes exactly how those
three fields are filled ([tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md) §4).

## 5. What is excluded from the commission base

Sheet `QboExcluded` defines exclusions by **QuickBooks Product/Service name**, in three groups:

| Group | Rule | Members |
| --- | --- | --- |
| Subsistence | *"All 'Product/Service' with **subsistence**"* — excluded | `Long Subsistence` · `Short Subsistence` |
| Travel permits | *"All 'Product/Service' with **travel permit**… also excludes **oversize permit**"* | `Permits:Oversize Permits` · `Travel Permit:Travel Permit` · `Travel Permit:Travel Permit - 75 Ton and above` |
| Permits (selective) | *"All 'Product/Service' with **permit**… **(only ones in the table on the left are excluded)**"* | `FAA Permit` · `Permit & Traffic Control Services` · `Permits:Edison 2 Man Crew DT / OT / ST` · `Permits:Edison 3 man Crew OT` · `Permits:Oversize Permits` · `Permits:Permits` · `Travel Permit:Travel Permit` · `Travel Permit:Travel Permit - 75 Ton and above` |

The `VersionUpdateNotes` sheet records the instruction that set this, in the client's own words:
*"Hey Brian, **keep excluding subsistence, travel permit:Travel permit, Travel Permit: Travel
Permit -75 ton and above and Permit: Oversize permit**."*

**These are pass-through costs, and the same items are separately-rated lines on the quote** —
subsistence at $85/$200 per man, travel permits at $65/$165/$300
([quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §3). The exclusion is by
**QuickBooks product/service name string matching**, not by billing-code attribute. **An ERP
would need a commissionable flag on the billing code to express the same rule without string
matching.** Note the third group's caveat — some permit-named services *are* commissionable and
the list is explicit rather than a pattern.

## 6. The calculated result — `Sales_Commissions`

The visible sheet's columns, as the SOP defines them:

| Column | Source | Meaning |
| --- | --- | --- |
| `InvYearMonth` | FCC | *"The invoice year and month bucket used for **monthly commission-threshold tracking**"* |
| `InvoiceCode` | FCC | Invoice identifier |
| `JobCode` | FCC | Job number associated with the invoice |
| `InvDate` | FCC | *"used to determine the **applicable commission plan** and monthly running total order"* |
| `CustomerName` | FCC | |
| `InvoiceBeforeTax` | FCC | Original invoice amount before tax |
| `SpersonCode`, `SalespersonName` | FCC | Salesperson assigned to the invoice |
| `TakenID`, `CoordinatorName` | FCC | Sales coordinator assigned to the invoice |
| `Num` | QBO | Matched accounting/reference number |
| `Subsistence` | QBO | Portion identified as subsistence, **excluded when applicable** |
| `TravelPermits` | QBO | Portion identified as travel/permit charges, **excluded when applicable** |
| `TotalExcluded` | QBO | *"usually the sum of Subsistence and TravelPermits"* |
| `Amount` | QBO | *"The **raw** QBO amount… **This is the amount used to build the monthly threshold running total.**"* |
| `Payment date` | QBO | *"Blank means no payment date was found"* |
| `CollectionAlert` | derived | *"A warning flag for **unpaid or ageing invoices** that may need follow-up"* |
| `CommissionBase` | derived | **`Amount – TotalExcluded`** |
| `EligibleCommissionAdjusted` | derived | *"final commissionable amount after exclusions and any commission eligibility/adjustment logic (CommissionBase **and special 'Customer' and/or 'Customer Group' settings** applied). **Note: will be blank if no matching QBO invoice has been paid within 90-days.**"* |
| `CommissionAmount` | derived | The salesperson's commission dollars for the row |
| `AboveOrBelowThreshold` | derived | *"showing whether the row is **below threshold, split across the threshold, or fully above threshold**"* |
| `CoordinatorAmount` | derived | The sales coordinator's commission dollars for the row |
| `CommissionStatus` | derived | *"such as **paid within 90 days, paid after 90 days, unpaid, or no QBO match found**"* |
| `RunningTotal_QboAmount` | derived | *"The month-to-date running total of **raw QBO Amount** for the salesperson and month. This is the value used to determine whether the monthly threshold has been reached."* |
| `Payroll Notes`, `Timestamp` | user | Notes and their save time |

**The rule that most needs stating**, from the SOP:

> *"**The monthly threshold is evaluated using `RunningTotal_QboAmount` based on raw QBO `Amount`,
> while the actual `CommissionAmount` is calculated from `EligibleCommissionAdjusted`.
> Therefore, a row may help a salesperson reach threshold even if the full raw amount is not
> commissionable.**"*

**And the payment condition:** commission is not payable — `EligibleCommissionAdjusted` is blank —
unless the matching QBO invoice **has been paid within 90 days**. So commission is earned on
*collected* revenue with a **90-day collection window**, which is why `CollectionAlert` exists.

Slicers filter on `InvYearMonth`, `SalespersonName`, `CollectionAlert`, `ExceptionFlag` and
`CommissionStatus`.

## 7. Payroll notes, and closing a batch

**Notes do not persist with the file.** *"These Payroll Notes **do not save when saving the Excel
file**. To save the notes in this column, the '**Save Payroll Notes**' button must be clicked."*
They are written to the hidden `__Data_Log` sheet with a timestamp. Typing `DELETE` in the cell
and saving removes a note.

**Closing out a batch** — and the reason it matters:

> *"After saving the Payroll Notes in this file, then **copy/paste all the payroll data from this
> file into the separate file that records 'closed out/processed' batches** of paid sales
> commissions. The reason for doing this is **to retain the data at the time the sales commission
> was actually paid**, because this Sales Commission App file will update with the new data
> available in FCC and QBO in the future (when the data is refreshed)."*

**The live workbook is not a record.** It is a recomputation of current FCC and QBO state, so the
historical record of what was paid lives in a *separate* file. **An ERP replacing this would need
an immutable commission run.**

## 8. Exceptions, controls and troubleshooting

**Exception categories** (filter on `ExceptionFlag`): *FCC exported but no match in QBO · FCC not
exported to QBO · Paid/Unpaid timing rules · missing rate/plan.*

**Required actions:** verify FCC export status and invoice number formatting · confirm the QBO
invoice exists and is paid, validate the payment date · if a commission plan is missing, confirm
customer group and salesperson plan setup.

**Minimum controls each cycle:**

- Confirm the FCC date range matches the commission period
- **Confirm row count is reasonable vs prior months** (investigate large variance)
- **Spot-check at least 5 paid invoices** across different salespeople — base, rate, exclusions,
  amount
- Review all rows with a non-blank `ExceptionFlag` and all rows with **`Rate=null` in
  `OverrideAudit`**

**Reconciliation checkpoints named:** `InvoiceBeforeTax` vs the `Amount` used as base ·
`TotalExcluded` items and the resulting eligible base · **`FinalRate` selection and
`OverrideAudit` reason codes** · the `CommissionAmount` calculation.

> `OverrideAudit` and `FinalRate` are named in §9 of the SOP but **do not appear in the column
> table in §7.3.7**. They are presumably columns of the hidden `FccInvoices_with_QBO` master
> sheet. The SOP does not say.

**Troubleshooting**: refresh/credentials failures go to IT/Data Support; *"No QBO match found"* →
verify the invoice was exported from FCC and the number formatting matches, and that the QBO
invoice is not a credit memo or void; *"Rate=null / NO PLAN"* → confirm customer-group mapping and
salesperson plan configuration, add a Payroll Note and escalate.

**Version history** (`VersionUpdateNotes`): v6.1 → v6.5 changed the running total from *"Qbo
Amount minus TotalExcluded"* to **raw Qbo Amount**, and stopped `AboveOrBelowThreshold` populating
when there is no `CommissionAmount`. v6.5 → v7.0 (2026-07-16) **added the coordinator settings
sheet** and renamed the salesperson settings sheet. **v7.0 → v7.1 has no notes recorded.**

## 9. Distribution

Weekly history/backups and the Power BI file live in a Microsoft Teams location (`TCG HR Team →
HR - Sales Commissions`); the Power BI workspace is *"TCG HR - Sales Commissions"* and the
distributed app is *"HR_Sales_Commissions_for_Sales_Team"*. **Row-level security by
email/username** is what makes it distributable to the sales team.

## 10. The workbook's VBA — read 2026-09-04

`TCG_HR_SALES_COMMISSIONS_with Coord_v7.1.xlsm` carries a `vbaProject.bin`; it was dumped with
`olevba`. Twelve sheet modules are empty. Four standard modules hold the logic, and none of it
calculates a commission — **every macro is plumbing around Power Query tables**; the commission
arithmetic lives in the queries and formulas the SOP describes, not in code.

| Module | What it does |
| --- | --- |
| `mod_RefreshAllDataInFile` | Loops every `ListObject` in the workbook and, for tables whose `SourceType` is a query or external connection, calls `QueryTable.Refresh BackgroundQuery:=False` (synchronous), then refreshes every PivotTable. Ends with *"All data and pivot tables have been refreshed safely!"* |
| `mod_RefreshAllDataOnSheet` | Same, scoped to the active sheet |
| `mod_ClearSlicersAndFilters` | Clears filters on the table **`ref_FccWithQbo_SalesCommissions`**, then every other table's AutoFilter, the sheet's range AutoFilter, all PivotTable filters and every slicer whose cache is used on the sheet |
| `mod_DataLog_SavePayrollNotes` | **The one business procedure.** Appends notes typed into the `Payroll Notes` column of table **`FccWithQbo_UserView`** on sheet **`Sales_Commissions`** into the append-only log table **`tbLOG_PayrollNotes`** on sheet **`__Data_Log`**, keyed by **`InvoiceCode`**, with a timestamp. Dedupes against the latest logged note per invoice (bottom-up scan of the log) and against notes already saved in the same run. Typing **`DELETE`** as the note clears it from the report on refresh while keeping the history. Then refreshes the query **`PayrollNotes_Latest`** and re-loads `FccWithQbo_UserView`, and reports counts (saved / marked DELETE / skipped blank / skipped duplicate) with up to ten `InvoiceCode --> note` examples. Written *"Mac + Windows compatible"* — Collections instead of Scripting.Dictionary, no ActiveX |
| `mod_0_ResetExcelState` | Restores `ScreenUpdating`, `EnableEvents`, calculation mode and the status bar after a failed macro |

**What this settles.** The commission workbook's notes are **per invoice** (`InvoiceCode`), and
they are journaled — every edit is appended with a timestamp and the latest wins, which is the
same append-only-log pattern the ADP payroll workbook uses. The table and query names
(`ref_FccWithQbo_SalesCommissions`, `FccWithQbo_UserView`, `PayrollNotes_Latest`) confirm the
pipeline in §1: an FCC-joined-with-QuickBooks ("FccWithQbo") result set is the base, and the
user-facing view is a Power Query over it.

## 11. The Power Query engine — where the commission is actually computed (read 2026-09-04)

The VBA in §10 is plumbing. The arithmetic is in the workbook's Power Query — 25 queries,
171 KB of M in a UTF-16 `DataMashup` part (which is why the first two extraction attempts found
nothing). Read in full on 2026-09-04. This section states what the code does; it does not
restate the SOP's description of the same steps except where the code is more precise or
disagrees.

### The sources

| Query | Reads | What it returns |
| --- | --- | --- |
| `FccInvCommissions` | **FCC SQL** — `FMS_INVOICE_MASTER` joined to `FMS_SALES_PERSON`, `FMS_CUSTOMERS`, `FMS_JOB_MASTER` and **`FMS_CHECKED_TAKEN`** (`FMS_JOB_MASTER.TakenID → FMS_CHECKED_TAKEN.CheckTakenID`), filtered to the invoice-date window in the START sheet's named ranges | One row per FCC invoice: `InvoiceCode, JobCode, InvDate, CustCode, CustomerName, InvoiceBeforeTax, SpersonCode, SalespersonName, TakenID, CoordinatorName, ExportOk` |
| `FccSalespersons` · `FccCoordinators` · `FccCustomers` | `FMS_SALES_PERSON` · `FMS_CHECKED_TAKEN` · `FMS_CUSTOMERS` | Reference lists. **A "coordinator" in this workbook is FCC's *Checked/Taken By* person** — the `TakenID` on the job |
| `QboInvHeader` · `QboInvDetail_*` | Excel tables pasted from QuickBooks Online exports | The QBO invoice and its lines |
| `CommissionPlan_Salesperson` · `CommissionOverride_Rate` · `CommissionBaseAdjust_Customer` · `CustGroup` · `CustGroupMember` · `CommissionPlan_Coordinator` | Excel settings tables | The plan |

### How an FCC invoice is matched to its QuickBooks twin

Both sides get a composite key **`StrippedNum + Date + Customer`**, where the stripped number is
the digits of the invoice number from the first digit onward (max 35). Voided QBO invoices are
dropped. **Test invoices are excluded** and duplicate invoice codes on either side are listed
separately (`*_ListDupInvoiceCode`). `MatchConfidence = 1 − |QBO amount − FCC amount| /
max(|QBO|, |FCC|)`; opposite signs score 0; **below 0.80 the row is flagged `research/fix`**
(`ExceptionFlag`). `CommissionStatus` is overridden to *"FCC: NOT exported to QBO"* when
`ExportOk ≠ 2`, and to *"FCC: exported, but NO match found in QBO"* when it was exported but no
QBO transaction matched.

### What is taken out of the base

From the QBO **detail** lines, every Product/Service whose name contains **"permit"** and every
one containing **"subsistence"** is summed per transaction into `TravelPermits` and
`Subsistence`; `TotalExcluded = Subsistence + TravelPermits`. That is the whole exclusion list
in code — §5 of this page lists what the SOP *says* is excluded; the code implements exactly
these two, by substring match on the QBO item name.

Then a **customer-level adjustment**: `tbCommissionBaseAdjust_Customer` gives an
`AmountAdjustRate` per customer (or group), date-bounded; the rate is clamped to 0–1 and
`EligibleCommissionAdjusted = EligibleCommissionBase × (1 − rate)`.

### The salesperson rule, as the code applies it

For each invoice, on its invoice date:

1. **Plan** — the `CommissionPlan_Salesperson` row for that `SpersonCode` whose
   `CommissionStart`/`CommissionEnd` bracket the date. It carries `BaseRate`,
   `HasThresholdRule`, `MonthlyThreshold`, `RateAboveThreshold`.
2. **Override** — from `CommissionOverride_Rate`, date-bounded, by `AppliesToType`
   **`CUSTCODE`** (specificity 2) or **`CUSTGROUP`** (specificity 1, via `CustGroupMember`); the
   most specific wins. The override rate replaces the base rate as `RateBelowThreshold`.
3. **Running total** — invoices are grouped by salesperson × `InvYearMonth`, sorted, and a
   running total of the *QBO* amount is accumulated.
4. **Threshold split** — if the plan has a threshold: the share of *this* invoice that lies
   above the monthly threshold (`(runningTotal − threshold) / amount`, clamped 0–1; 1 if the
   prior total was already over; 0 if the running total is still under) is paid at
   `RateAboveThreshold`, the rest at `RateBelowThreshold`:
   `CommissionAmount = adjustedBelow × rateBelow + adjustedAbove × rateAbove`. Without a
   threshold rule: `adjusted × rate`. The split is recorded as `AboveOrBelowThreshold`.

### The coordinator rule

A separate plan table, `tbCommissionPlan_Coordinator`, keyed by **`TakenID`**. Only invoices
whose job `TakenID` is in that table show a coordinator at all. The active plan row (latest
start/end wins) gives `BaseRate`, an optional threshold pair, and **`SalesAndCoordRate`** —
applied *instead* when the invoice's `SpersonCode` equals the `SpersonCode` configured on the
coordinator's own row, i.e. when the coordinator was also the salesperson. **`SpersonCode JD55`
is excluded from coordinator commissions and from coordinator thresholds** (the same exclusion
the settings sheet states in prose; JD55 is the code for Joe Deitrick). `CoordinatorAmount` is
computed separately from `CommissionAmount`.

### Two things only the code says

- **`CollectionAlert`** — if the QBO `A/R paid` field is not `PAID`/`YES`, the row is tagged
  *"⚠️ 30+ / 60+ / 90+ DAYS UNPAID"* by comparing today with invoice date + 30/60/90. Nothing in
  the SOP text mentions a collection flag on the commission report.
- The user view (`FccWithQbo_UserView`) exposes exactly: `InvYearMonth · InvoiceCode · JobCode ·
  InvDate · CustomerName · InvoiceBeforeTax · SpersonCode · SalespersonName · TakenID ·
  CoordinatorName · Num · Subsistence · TravelPermits · TotalExcluded · Amount ·
  AmountAdjustDescription · Payment date · CollectionAlert · CommissionBase ·
  EligibleCommissionAdjusted · ExceptionFlag · CommissionAmount · AboveOrBelowThreshold ·
  CoordinatorAmount · CommissionStatus · RunningTotal_QboAmount`, plus the latest payroll note.

The plan tables' actual rates were not copied (compensation of named individuals).

> The `FMS_CHECKED_TAKEN` rows the coordinator plan keys on (31 people, `Flag` B/C, active flag) are printed in [../payroll/tcg-rawfms-staging-database/data/fcc-checked-taken-list.md](../payroll/tcg-rawfms-staging-database/data/fcc-checked-taken-list.md) (from the 2026-06-23 FCC copy, read 2026-09-04).

## What the SOP's screenshots show — read 2026-09-04

The docx embeds 60 images; 47 were extracted and read (13 were not
recoverable). They are of workbook **v7.0** on every sheet except
`Coordinators_SETTINGS`, whose header reads **v7.1** — the v7.1 SOP re-shot only the sheet
that version added. Only what the text above does not already say is recorded here.

**Where the file lives, and the tab strip.** The OneDrive folder `…/Sales Comission/
TCG_SALES_COMMISSIONS_APP/` holds `_Archive`, `QBO_Invoice_and_CM_reports` and the `.xlsm`,
opened with *Open → Open in app*. The tab strip is colour-coded: `START` (grey) ·
`QboInvHeader`, `QboInvDetail` (green) · `QboExcluded` (grey-green) · `Salespersons_SETTINGS`,
`Coordinators_SETTINGS` (brown) · `Exceptions_Duplicates` (pink) · `Sales_Commissions`
(purple). Every sheet carries the banner *"The Crane Guys — Sales Commissions with
Coordinators v7.0"* and a green `Refresh Sheet` button.

**START sheet — the timing method the text alludes to.** A box titled *FCC Invoice Report*
holds `Start Date` / `End Date`, the line *"Update QuickBooks sheets **before** clicking
Refresh All"*, the `Refresh All` button and *"Note: this button does **not** save Payroll
Notes"*. Beside it is a diagram, *"Report Timeline Comparison: FCC Invoice vs. QBO Invoice
Report"*: the FCC pull has *"Defined Start and End Dates for Segment"*; the QBO report has the
**same start date but "Ends at Current Date (Today)"**. So the QBO export is deliberately run
open-ended to today — that is how a payment received after the FCC period closes is visible to
the 90-day paid test in §6. The completion dialog reads *"All data and pivot tables have been
refreshed safely!"* (the string in `mod_RefreshAllDataInFile`, §10).

**The two QBO reports.** In QBO's *Custom reports* a group `INVOICE_REPORTS` holds four
reports: `Sales by Customer Detail - SoCalEdison`, `TCG – Invoice Header Detail - by Num
Filter`, `TCG – Invoice and CM Detail for Commissions`, `TCG – Invoice and CM Header for
Commissions`. The two *"for Commissions"* reports are run with *Report period = Custom dates*
and exported. Their layout on the sheets:

| Sheet | Report title on the sheet | Columns |
| --- | --- | --- |
| `QboInvHeader` | *TCG – Invoice and CM Header for Commissions* / The Crane Guys, LLC / date range / hand-typed `ran: <date> at <time>` | `Transaction ID · Transaction type · Num · FccJobCode · Date · Customer · Voided · Amount · A/R paid · Payment date · Open balance` |
| `QboInvDetail` | *TCG – Invoice and CM Detail for Commissions* | `Transaction ID · Transaction type · Num · Transaction date · Customer · Product/Service · Amount · A/R paid` |

`Transaction type` is `Invoice` or `Credit Memo`; `A/R paid` is `Paid` / `Unpaid`; `Voided` is
`No`/`Yes`. `Num` is the FCC invoice code as QuickBooks holds it; forms visible include
`MYOM-#####`, `R#####`, `TRG###`, plain numbers, and one `MYOM-#####R` — the SOP does not say
what the suffix means. `FccJobCode` is empty in every row shown. The exported CSV ends with a
`TOTAL` row, which is why the copy step backs up one row; the paste is *Paste Values* (the
`123` icon); Excel's CSV prompt *"Remove leading zeros … Convert / Don't Convert"* is the one
answered *Don't Convert*.

**QboExcluded.** Titled *"QBO Services (excluded from commissions)"* with the current data
date range under it. The three tables are headed `Product/Service_with_Subsistence`,
`Product/Service_with_Travel Permit`, `Product/Service_with_Permit`. The permit table lists
`Permits:Edison 2 Man Crew DT`, `… OT` and `… ST` as three separate rows (§5 compressed them).
Otherwise identical to §5.

**Salespersons_SETTINGS — the tables as laid out.** Title *"Salesperson Settings/Configuration
Tables"*. Left: `TCG Sales Team` (*"All salespersons in FCC database"*) with columns
`SpersonCode · SalespersonName · StatusInFcc` (`Active` / `Inactive`), about 37 rows. Codes are
mostly four-digit numbers, but several are initials-style (`JD55`, `CV`, `CR`, `GF50`, `WA`) —
FCC's salesperson code is free text, not a sequence. Right: the plan table, with a colour
legend row above the headers — dark = *"must match"*, tan = *"fills in automatically"*, *"TRUE
or FALSE"*, *"must be formatted as %"* — and headers exactly `SpersonCode · SalespersonName ·
BaseRate · HasThresholdRule · MonthlyThreshold · RateAboveThreshold · CommissionStart ·
CommissionEnd · Notes`. Six salespeople have plan rows; one has **two rows** — the first with a
`CommissionEnd` date, the second with `CommissionStart` the following day and a different
base rate and threshold, with the change described in `Notes`. That is the §4 effective-dating
convention in use; blank start/end means open-ended. Values were not copied.

The customer-override table's headers are `SpersonCode · SalespersonName · AppliesToType ·
CustGroup · CustCode · CustName_or_GroupDescription · OverrideRate · StartDate · EndDate ·
Priority · Description`, with the legend *"CustCode = Customer Code or CustGroup = Customer
Group"* and *"Options in: TCG Customer GROUPS table"*. Three rows exist, all for one
salesperson: two `CustCode` rows (Southern California Edison, LA Department of Water and
Power) at `Priority` 100 and one `CustGroup` row (`PoleContractors`) at 90. In this table the
salesperson's code is typed as `JD` while the Sales Team table lists that person as `JD55`;
the name column is filled, so the screenshot does not show whether the lookup tolerates the
mismatch or the name was typed. Rates were not copied.

A second block, *"Customer Sales Commission Configuration Tables"*, holds: `TCG Customers`
(*"All customers in FCC database"*: `CustCode · Name1 · CustGroup`; codes are three letters plus
three digits, e.g. `ACC017`); `TCG Customer GROUPS` (`CustGroup · GroupDescription`) — **one
group exists, `PoleContractors` / "pole customer group"**; and the membership table
`CustGroup · CustCode · CustName · StartDate · EndDate` with six member customers, all
utility-line contractors. The per-customer adjustment table is headed `CustCode · CustName ·
AdjustField · AdjustType · AdjustValue · StartDate · EndDate · Priority · Description`, with
the legend *"(this **reduces** the Invoice Amount)"*, and has one row: **`SOU050` Southern
California Edison — `Amount` / `Percent` / `2.00%` / Priority 100 / "Reduce Amount by 2%"**.
This is a rule about a customer, not a person, so it is quoted; the SOP does not say why SCE
invoices are reduced 2% before commission.

**Coordinators_SETTINGS (v7.1).** Left: `TCG Sales COORDINATORS` (*"All Sales Coordinators in
FCC database"*) with `CheckTakenID · CoordinatorName · StatusInFcc`. `CheckTakenID` is a small
integer (1–33) — this is FCC's *Chk\Taken By* maintenance list, not the salesperson code —
and it **includes an entry named `Customer`** (ID 2): FCC's Taken By / Checked By pick-list
carries a pseudo-person for "the customer". Right: `CheckTakenID · CoordinatorName · BaseRate
· SpersonCode · SalespersonName · SalesAndCoordRate · HasThresholdRule · MonthlyThreshold ·
RateAboveThreshold · CommissionStart · CommissionEnd · Notes`. Two coordinators are configured;
one is paired with a `SpersonCode` (the same person under both identities) and has a
`SalesAndCoordRate`; both have `HasThresholdRule = FALSE`. Two note boxes on the sheet restate
the §4 rules: *"If both 'CoordinatorName' and 'SalespersonName' are filled in (above), then it
uses the 'SalesAndCoordRate'… if the Job has both for 'Salesperson' and 'TakenBy'"* and the
JD55 exclusion.

> **Contradiction with the text (and with §4 above).** The captions say *"the 'Taken By' field
> in FCC [is] used to identify the Salesperson"* and repeat it for the coordinator. The
> screenshots show otherwise: the salesperson picture highlights the **`Salesperson`** field on
> the FCC *Schedule > Job* screen; the coordinator picture highlights **`Taken By`**. Read §4
> as: **`Salesperson` → `SpersonCode`; `Taken By` → `CheckTakenID`** — which is also what the
> `Sales_Commissions` columns `SpersonCode` and `TakenID` say. In both example jobs the same
> person occupies Salesperson and Taken By; in one, `Checked By` is `Customer`. The Job screen
> fields visible: Job Number · Company · Yard · Department · Salesperson · Checked By · Taken By
> · PO Number · Status | Customer · Job Site · Report To · Ordered By · Description Of Work ·
> Comments · Equipment Required.

**Exceptions_Duplicates.** Titled *"FCC Invoices with QBO Invoices (exceptions: DUPLICATE
Invoice Codes)"*, sub-caption *"Duplicate InvoiceCode in FCC **after** matching with QBO"*.
Columns: `TakenID · InvYearMonth · SpersonCode · InvoiceCode · JobCode · InvDate · CustCode ·
CustomerName · InvoiceBeforeTax · SalespersonName · CoordinatorName · ExportC… · Transaction… ·
Num · Subsistence · TravelPermits · TotalExcluded · Amount · …`. Every duplicate pair in view is
one FCC invoice `MYOM-#####` matched to two QBO rows: the invoice itself and a **credit memo
numbered `CM#####` with the same digits** and a negative `Amount`. So QBO credit memos are
keyed to the FCC invoice number and the match is on the numeric part; the SOP does not say
which of the two rows the commission run keeps. Job codes are `OM#####`.

**Sales_Commissions.** Buttons `Refresh Sheet` (green) and `Save Payroll Notes` (purple). A
left panel shows *FCC Invoices* with the start/end dates, `FCC Rows: n`, `Rows below: n`, *QBO
Invoices & Credit Memos*, a `SHOW ALL ROWS` button and `Rows VISIBLE: n` (in the v7.0 capture
3,066 FCC rows against 3,072 below — six duplicates). There are **six slicers, not the five the
text lists**: `InvYearMonth`, `SalespersonName`, **`CoordinatorName`**, `CollectionAlert`,
`ExceptionFlag`, `CommissionStatus`. Their values are the closed enumerations behind §6's
"such as":

| Slicer | Values |
| --- | --- |
| `CollectionAlert` | `⚠ 30+ DAYS UNPAID` · `⚠ 60+ DAYS UNPAID` · `⚠ 90+ DAYS UNPAID` · (blank) |
| `ExceptionFlag` | `research/fix` · (blank) — a single flag value |
| `CommissionStatus` | `FCC: exported, but NO match found in QBO` · `FCC: NOT exported to QBO` · `Paid in full (in 90 days)` · `Paid in full (past 90 days)` · `Unpaid (in 90 days)` · `Unpaid (past 90 days)` |

The table's leading columns are as §6 lists them (`InvYearMonth · InvoiceCode · JobCode ·
InvDate · CustomerName · InvoiceBeforeTax · SpersonCode · SalespersonName · TakenID ·
CoordinatorName · Num · Subsistence · TravelPermits …`); `CommissionAmount` has a totals row
and is followed by `Payroll Notes` and `Timestamp`. In the §8 pictures the save button is
labelled **`Save & Refresh`** — an older label than `Save Payroll Notes` on the v7.0 sheet;
the text uses both. The dialogs: *"Confirm Save — Save Payroll Notes to the log? • Notes will
be appended to the history table with a timestamp. • Type DELETE to clear the note in the
report (history is still kept)."* then *"Payroll Notes Saved — Completed save + refresh. Saved
to history log: n / Marked DELETE (clears on refresh): n / Skipped (blank InvoiceCode or note):
n / Skipped (duplicate): n / Examples saved: <InvoiceCode> --> <note>"*. Timestamps are
`m/d/yy hh:mm`. The example notes are of the form *"Check 1234"* — **the payroll note is used
to record the cheque number the commission was paid on.** Invoice-code forms in the examples:
`MYOM-#####`, `MYOM-R#####`, `MY-#####-10`, `MY-#####-11`, `MY-RL#####` — prefixes `MY-` and
`MYOM-`, `R`/`RL` infixes and `-10`/`-11` suffixes; the SOP does not explain them.

**Power Query.** The Options screenshot shows the workbook's query tree — *Queries [23]* in
groups `01_PARAMETERS_CALENDAR`, `02_FCC_SALES_PERSON_CUSTOMERS`, `03_FCC_INVOICES`,
`04_QBO_INVOICES`, `05_FCC_WITH_QBO`, `DATA_LOG`. The privacy option enabled is *"Allow
combining data from multiple sources. This could expose sensitive or confidential data to an
unauthorized person"*. The Excel *Data* menu offers *From SQL Server ODBC* (Mac Excel).

**Distribution.** The Teams channel *HR - Sales Commissions* (Shared tab) holds `_Archive`,
`HR_Sales_Commissions_for_Sales_Team.pbix` and `HR_Sales_Commissions_for_Sales_Team.xlsx`. The
Power BI workspace *TCG HR - Sales Commissions* contains a *Report* and a *Semantic model* both
named `HR_Sales_Commissions_for_Sales_Team`, with the *Update app* button. The published report
page is titled *"Sales Commissions — Collection Status — as of <date>"*, with slicers
`Salesperson · Coordinator · Invoice Year-Month · Collection Alert · Commission Status` and a
table `Salesperson · Coordinator · Invoice Year-Mo · Customer · JobCode · Collection Alert ·
Commission Status · Invoice Amt`. **On the page captured, what the sales team sees is invoice
amount and collection status — not commission amounts.** Whether other pages exist is not
shown.

## Source

- `3.1.1_MODULE-CRM-SALES-QUOTES/Copy of Sales Commissions Process/TCG_Sales_Commissions_with_Coord_SOP_v7.1.docx`
  — 33 KB docx → pandoc gfm; 12 sections. The SOP is screenshot-heavy for the UI steps; the
  prose was migrated first, and on 2026-09-04 the 47 extractable embedded images were read
  directly and folded in as the section *What the SOP's screenshots show*.
- `…/TCG_HR_SALES_COMMISSIONS_with Coord_v7.1.xlsm` — 4.8 MB, **13 sheets**, per-sheet row dump
  (~23,500 lines). **Structure, formulas-as-described, column definitions, the exclusion lists and
  the version notes are captured above. Row data was deliberately not copied**: 3,004 commission
  rows, 3,320 QBO header rows, 23,147 QBO detail rows, 3,017 FCC invoice rows, ~6,150 rows of
  customer/salesperson reference data, and 3,003 payroll-note log rows. **Individual commission
  rates, thresholds and per-customer override rates were also deliberately not copied** — they are
  named employees' compensation data. The FCC server address in `__hiddenParams` was not copied.

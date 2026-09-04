---
title: Quote Profit Forecast — FCC's margin feature, and why TCG switched it off
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/NexGen_Atom_Quote_Profit_Forecast_User_Guide_v1.0.pdf
migrated: 2026-09-04
updated: 2022-12-01
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/accounting, kind/source, pricing, reporting, yards]
entities: []
---

# Quote Profit Forecast — FCC's margin feature, and why TCG switched it off

**What this is.** Fleet Cost & Care's user guide (**v1.0, December 2022**, 30 pages) for the
*Quote Profit Forecast* feature in NexGen and Atom. It is an **optional, admin-toggled** module
that puts a cost figure behind every estimate line and computes gross and net profit per line and
per quote.

**Why it matters.** Two vault items point at this feature without naming it.
[quotations.md](quotations.md) asks to *"Remove `Gross Margin`"* and *"Verify `Subtotal`"*, and
TCG's billing-codes review says *"We don't use/need these **'Billing Costs'**"* — and Billing
Costs is the sole input this feature runs on. This page is what those two lines are about.

> **Nothing here says TCG uses it.** The evidence in the drop points the other way (§6). It is
> recorded because it is the only written model of *cost-side* pricing data in FCC, and because
> the same shape recurs in the burden-code ask.

---

## 1. Turning it on

`Admin → Set System Defaults → Features` → tick **Quote Profit Forecast**.

> *"This feature is turned off by default and administrator can turn it on when the operations
> team is ready to use this feature. **When this feature is turned on, the Billing Codes WPF
> feature is turned on automatically** to enable configuring the billing costs."*

So the feature and the Billing Costs tab arrive together — one switch.

Its stated purpose: *"provides visibility into the **forecasted profit % on the quotes and at the
individual estimate line items** for the Salespersons and Managers to review and adjust the quote
estimates to keep the profit margins at the acceptable levels."*

## 2. Billing Costs — the cost model

Configured at `Maintain → Codes → Billing Codes – WPF → Billing Costs` tab. The guide states the
three formulas up front:

```
Direct Cost   $ = Equipment + Materials + Labor
Indirect Cost $ = Union + WC + Union Burden + Materials Burden
Total Cost    $ = Direct Cost + Indirect Cost
```

> *"The system expects the above costs to be represented in **'Hourly.'** On the Quotes – Profit
> Forecast tab, the system will apply the **conversion of costs from hourly to the selected unit
> of measure.**"*

| Field | Definition |
| --- | --- |
| **Billing Description** | dropdown selecting the existing billing code to cost |
| **UM (Unit of Measure)** | **set to "Hourly"; read-only** |
| **Equipment Cost $** | hourly equipment cost, if applicable |
| **Materials Cost $** | hourly materials cost, if applicable |
| **Labor Cost $** | hourly labour cost, if applicable |
| **Direct Cost $** | calculated, read-only |
| **Union Cost $** | hourly union cost related to the labour |
| **Workers Compensation (WC) $** | hourly WC cost related to the labour |
| **Labor Burden $** | hourly burden related to the labour |
| **Materials Burden $** | hourly burden related to the materials |
| **Indirect Cost $** | calculated |
| **Total Cost $** | calculated |
| **Allow Override Costs** | *"Check this option to allow the Salesperson or Manager to manually enter or override the costs on the job quotes."* |
| **Yards** | *"Select the Yard(s) to apply the Billing Costs entered. **If the Yard cost varies for the Billing Code, then add a new record with adjusted costs and select appropriate Yard(s).**"* |
| **Effective Start/End Dates** | *"Set the dates to adjust the costs for **historical or future dates** on the Job Quotes – Profit Forecast calculations."* |

And one exclusion: *"**the percentage billing codes are excluded from configuring the billing
costs.** Salesperson or Manager should be able to apply that manual calculation at the individual
quote level."* So the fuel/insurance surcharge line has no cost model.

**Three structural points worth carrying regardless of whether TCG adopts the feature:**

- **Cost is effective-dated and yard-scoped.** That is precisely the shape TCG asks for on
  *burden codes* — *"track the timing of when Burden Code(s) was changed along with the effective
  dates (with ability to backdate)"* — see
  [fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §5. FCC already
  implements effective-dated, yard-scoped cost rows here.
- **Indirect cost is a labour-burden model**: union, workers' comp, labour burden, materials
  burden. That is the same cost stack the payroll module computes from the other side.
- **A cost is stored hourly and converted to the line's UOM at quote time.** A daily or "each"
  line therefore derives its cost from an hourly figure by a conversion the guide does not spell
  out.

**Bulk load.** *"To Mass Update billing costs for the Billing Codes, the **Import Billing Costs**
feature can be utilized… Create a CSV file with the above column layout and adjust the **Column
No** field to match with your CSV file template."* The column layout itself is shown only as a
screenshot and is **not recoverable from this PDF**.

## 3. The Profit Forecast tab on a quote

*"The Profit Forecast tab shows up **next to the Tasks tab (Sales Assistant)** on both
Job/Trucking Quotes screens."* It populates on save, and for an existing quote *"the costs will
be applied **based on the last modified date of each of the estimated line items**"* — i.e. the
effective-dated cost row is chosen per line, by that line's own modified date.

| Column | Definition |
| --- | --- |
| **Billing Code** | from the Estimate tab |
| **Quantity**, **Rate**, **Estimated** | from the Estimate tab |
| **Direct Cost** | `Equipment + Materials + Labor` |
| **Indirect Cost** | `Union + WC + Union Burden + Materials Burden` |
| **Total Cost** | `Direct + Indirect` |
| **Unit Meas** | UOM from the Estimate tab |
| **Override Cost** | ticked when the billing code allows override; *"This would allow the user to edit the costs and improve the accuracy of the profit forecast."* |
| **Gross Profit $** | `Estimated Amount – Direct Costs` |
| **Gross Profit %** | `Gross Profit $ / Estimated Amount` |
| **Net Profit $** | `Estimated Amount – Total Cost` |
| **Net Profit %** | `Net Profit $ / Estimated Amount` |

**Gross excludes indirect cost; net includes it.** Double-clicking a Direct or Indirect cell
opens the breakdown.

**Override.** *"The Billing costs for some of the product/services **cannot be determined upfront
and the cost could vary on a quote-to-quote basis, E.g., 3rd party trucking billing codes.**"*
Where the administrator has ticked *Allow Override Costs*, the salesperson double-clicks the
Direct or Indirect amount and edits it. The guide's worked example is *"**AT Mob In & Out**
billing codes"* configured for override, with a $1,200 direct cost being edited. In Atom the
cost fields are editable only when the flag is true, read-only otherwise.

**That third-party-trucking rationale is the same problem TCG's quote states commercially** —
*"ALL SUBCONTRACTORS WILL BE BILLED AT A MINIMUM OF 10% MARK UP"*
([quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §1). FCC's answer is a per-quote
cost override; TCG's is a blanket markup. **Nothing reconciles them.**

## 4. Reporting

`Reports → Quotes → Quote Profit Forecast`, rendered by **Telerik**. Two views —
**Summary** (per quote) and **Detail** (per estimate line item).

Default filters as shipped: Company *All Companies* · Yard *All Yards* · Dept *All Departments* ·
Salesperson *All Salespeople* · Quote *NA* · Quote Status *All* · **Group By** *Quote* · **Use
Date** *Quote Created Date, Job Date* · **From/To** *Quote Created Date — current month's start
and end* · **View By** *Summary*.

`Group By` accepts **Company, Yard, Department, Salesperson and Quote**. Both views sort on any
column and offer Email, Export and Print from the Telerik toolbar.

## 5. Atom and Power BI

Atom shows **Net Profit $ and Net Profit %** on the quote card, with the full per-billing-code
breakdown on the Quote Profit Forecast tab and the direct/indirect split behind the overflow
menu.

A **Power BI dashboard is a paid add-on** (*"Please reach out to the Sales Team, if you are
interested in adding this PBI Dashboard/Reports to your workspace"*). What it adds:

- Profit margin % and $ **by salesperson and by customer**, drilling through to the quote.
- **Forecast vs. actual** — *"customers can get… the chance to compare Quote Profit Forecast
  Profit margin with **Jobs Profit Margin**. This can be done by **defining the billing costs for
  the previous years by setting up the costs with effective dates in the past** and comparing the
  profit margin on the quotes with profit margin on the job. PBI also calculates the **variance**
  between these two KPI's."*

**Retrospective forecast-vs-actual is the same shape as the mob/demob verification gap.**
[mobilization-and-demobilization.md](mobilization-and-demobilization.md) names the missing layer
as *"no comparison mechanism"* between quoted and actual. This feature does that comparison for
*money*; the mob/demob requirement asks for it on *time*. Neither is built at TCG.

## 6. What the drop says about TCG using this

Three signals, all negative, none conclusive:

1. **`FCC_MAINTAIN_CODES-BILLING (reviewed by TCG).pptx`, slide 9:** *"We don't use/need these
   'Billing Costs'."* Without billing costs there is nothing for the feature to compute from.
2. **[quotations.md](quotations.md)** asks to *"Remove `Gross Margin`"* from the new ERP's
   quotation screen — the punch list treats a margin figure as unwanted, not as under-specified.
3. The **KPI tracker** Ryan Adams built computes revenue, win rate and quote dollars from FCC and
   QuickBooks exports, and carries **no cost or margin column at all** —
   [sales-reporting-workbooks.md](sales-reporting-workbooks.md) §2. If profit forecast were in
   use it would be the obvious source.

Against that: the same slide deck asks for **Burden Codes** to *"track overhead expenses per
billable labor hour"* with effective dates and re-runnable reporting — which is a cost model
with the same shape as `Labor Burden $` here. **So TCG rejects FCC's implementation while asking
for something structurally similar. Nothing in the drop explains the difference, and no one
should assume the ERP does or does not need per-line costing on this evidence.**

## Source

`1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/NexGen_Atom_Quote_Profit_Forecast_User_Guide_v1.0.pdf`
— 30 pages, `pdftotext -layout`. Version 1.0, December 2022, Fleet Cost & Care. The guide is
screenshot-heavy; **the Import Billing Costs CSV column layout, the report layouts and the Power
BI visuals exist only as images and were not recoverable.** All field tables, formulas and
default filters above are transcribed from the PDF's own text.

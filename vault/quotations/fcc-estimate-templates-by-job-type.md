---
title: FCC estimate templates — Resource Type × Job Type × Yard
source: teams-message/client — 2026-09-03, Brian Petros to ehtesham.anwar (CodingCops), 9 FCC screenshots
migrated: 2026-09-03
updated: 2026-09-03
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/assets, kind/source, fcc, mob-demob, pricing, requirements, migration]
entities: [quotation, estimate, billing-code, unit-type, sub-category, yard, mob-demob]
---

# FCC estimate templates — Resource Type × Job Type × Yard

**What this is.** A Teams message from **Brian Petros** of **2026-09-03**, sent to
ehtesham.anwar after that day's meeting in which **Joe** raised that quotation estimates are per
crane *and* differ per **Job Type**. The message shows where those defaults live in FCC (NexGen
FMS), walks the **100 Ton Hydraulic Truck Crane** through both of its job types, and states that
a full export of every estimate configuration in FCC is being prepared and will follow.

> Sender confirmed 2026-09-03 (attribution was pending in this file's first revision). *Joe* is
> Joe Schacatano (sales & quotation owner in this module's register).

> **Forward-looking, not adjudicated.** This is a description of the legacy system plus an
> implicit ask; nothing in it has been decided for the ERP. The open question it raises is
> [gaps.md → Estimate defaults per resource type × job type](gaps.md#estimate-defaults-per-resource-type--job-type--yard--fcc-has-them-tcg-has-no-job-type-at-all).

## 1. Where it lives in FCC

`Main menu → Maintain → Resources → Resource Types`
([screenshot](assets/2026-09-03_fcc-resource-types-02-menu-path.png)). The sibling entries under
*Resources* are Units, Components & Tools, Ad-hoc Checklists, Customer Owned Units, Resource
Types, Schedule Types, Down Reasons.

The screen has four tabs and a master/detail shape — pick a row on **Main**, and the other three
tabs re-scope to it ([screenshot](assets/2026-09-03_fcc-resource-types-03-main-tab.png)):

| Tab | Holds |
| --- | --- |
| **Main** | the resource-type list — `Description`, `Additional Info`, `Target Hours/Month`, `Schedule Type`, `Category`, `Status`. Rows sampled: 75/90/100 Ton Hydraulic Truck Crane, 90 Ton RT, 110 Ton All Terrain Crane, 130 Ton RT — all `Target Hours/Month` 160, `Category` **Unit** |
| **Job Type/Yard** | the **job types this resource type is configured for**, each with a Yard and Comments |
| **Unit/People** | what the resource type drags along — one row per `Unit/People` + `Type` |
| **Estimate** | the **default estimate lines** — `Billing Code`, `Quantity`, `Unit of Measure`, `Comments`, `Sub-Item` |

**The load-bearing structure:** *Unit/People* and *Estimate* are **not properties of the resource
type**. They are properties of the **(resource type, job type, yard)** triple — both tabs carry
the selected `Job Type` and `Yard` in their header, and both re-populate when a different Job
Type/Yard row is selected. One crane therefore owns as many estimate templates as it has job
types.

`Description` = *100 Ton Hydraulic Truck Crane*, `Yard` = **All Yards** on every row sampled —
so the yard slot is a real dimension, and "All Yards" is its wildcard, but no yard-specific
variant has been seen yet.

## 2. The 100 Ton Hydraulic Truck Crane, both job types

Its **Job Type/Yard** tab has exactly two rows
([Hourly selected](assets/2026-09-03_fcc-resource-types-04-job-type-yard-hourly.png) ·
[Hourly w/ Mob selected](assets/2026-09-03_fcc-resource-types-07-job-type-yard-hourly-w-mob.png)):

| Job Type | Yard | Comments |
| --- | --- | --- |
| `Hourly w/ Mob` | All Yards | — |
| `Hourly` | All Yards | — |

*Mob = mobilization; `Hourly` is the no-mobilization variant.*

### Unit/People — identical across both job types

Both [Hourly](assets/2026-09-03_fcc-resource-types-05-unit-people-hourly.png) and
[Hourly w/ Mob](assets/2026-09-03_fcc-resource-types-08-unit-people-hourly-w-mob.png) show:

| Unit/People | Type |
| --- | --- |
| Tractor | Tractor - Semi |
| Trailer | Operator Load |

The message's own framing is *"potentially different Unit/People configuration"* — for this
crane they happen to match. Do not read that as a rule.

### Estimate — `Hourly`

[Screenshot](assets/2026-09-03_fcc-resource-types-06-estimate-hourly.png). Four lines, **no
`Sub-Item` ticked**, so all four print on the customer's estimate:

| Billing Code | Qty | UoM | Comments | Sub-Item |
| --- | --- | --- | --- | --- |
| 100 Ton Crane | 4.00 | Hours | | ☐ |
| Operator Load | 1.00 | Each | | ☐ |
| Travel Permit - 75 Ton and abo… | 1.00 | Each | *"Subject to change pending …"* (truncated) | ☐ |
| Fuel & Insurance Surcharge | 1.00 | Each | | ☐ |

The **4.00 default hours** is the four-hour minimum, priced here as a default quantity rather
than a rule — cross-check [quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) minimums.

### Estimate — `Hourly w/ Mob`

[Screenshot](assets/2026-09-03_fcc-resource-types-09-estimate-hourly-w-mob.png). **Twenty** lines
in this order — two ticked blocks, each closed by an unticked roll-up row:

| # | Billing Code | Qty | UoM | Comments | Sub-Item |
| --- | --- | --- | --- | --- | --- |
| 1 | 100 Ton Crane | 0.00 | Hours | Travel in and Build up | ☑ |
| 2 | Operator Load | 0.00 | Each | Operator Load | ☑ |
| 3 | Travel Permit - 75 Ton and abo… | 0.00 | Each | Travel Permit | ☑ |
| 4 | Crew Time | 0.00 | Hours | Curfew Stand By Time | ☑ |
| 5 | Price Adjustment | 0.00 | Each | Price Adjustment | ☑ |
| 6 | Crew Overtime | 0.00 | Hours | Overtime Rate | ☑ |
| 7 | Crew Double Time | 0.00 | Hours | Double Time Rate | ☑ |
| 8 | Crew Time | 0.00 | Hours | | ☑ |
| **9** | **Mobilization** | **1.00** | **Each** | | **☐** |
| 10 | 100 Ton Crane | 0.00 | Hours | 4 Hour Minimum Portal to Portal | ☑ |
| 11 | Operator Load | 0.00 | Each | Operator Load | ☑ |
| 12 | Travel Permit - 75 Ton and abo… | 0.00 | Each | Travel Permit | ☑ |
| 13 | Crew Time | 0.00 | Hours | Curfew Stand by Time | ☑ |
| 14 | Price Adjustment | 0.00 | Each | Price Adjustments | ☑ |
| 15 | Crew Overtime | 0.00 | Hours | Overtime Rate | ☑ |
| 16 | Crew Double Time | 0.00 | Hours | Double Time Rate | ☑ |
| 17 | Crew Time | 0.00 | Hours | | ☑ |
| **18** | **De-Mobilization** | **1.00** | **Each** | | **☐** |
| 19 | 100 Ton Crane | 0.00 | Hours | | ☐ |
| 20 | Fuel & Insurance Surcharge | 1.00 | Each | | ☐ |

So the customer sees four lines here too — **Mobilization**, **De-Mobilization**, the crane's
own hours (19) and the surcharge (20) — and the sixteen ticked lines are the internal build-up
behind the two bundles.

## 3. What `Sub-Item` means

The message states it directly: *"the 'Sub-Item' boxes that are checked means that those line
items do not show on the estimate for the customer"*, and, of the `Hourly` template, *"all
'Sub-Item' are not checked… so all of these display on the estimate."*

**It is a per-line visibility flag, not a parent/child link.** Nothing in the screen draws a
child to a parent: membership is positional — a ticked run belongs to the unticked roll-up row
that closes it. That is a real difference from how TCG models the same idea (§4).

Three details worth carrying:

- **The bundle is a mini-estimate, not just travel and setup.** Alongside crane hours, operator
  load and the travel permit sit **Crew Time (curfew standby)**, **Price Adjustment**, **Crew
  Overtime** and **Crew Double Time** — premium and adjustment placeholders, pre-seeded at 0.00
  so the estimator fills in what applies.
- **The mob and demob blocks are near-mirrors** (8 lines each) and differ only in the comment on
  the crane line: *Travel in and Build up* vs *4 Hour Minimum Portal to Portal*.
- **Quantities are the template's own defaults** — 0.00 on every sub-item, 1.00 Each on the
  roll-ups and the surcharge, 4.00 Hours on the `Hourly` crane line. Rates are not on this
  screen; they come from the price list.

## 4. Against what TCG has built — verified

| FCC concept | TCG today | Verdict |
| --- | --- | --- |
| Resource type (`100 Ton Hydraulic Truck Crane`) | `SubCategory`; also `UnitType` from the FCC extract (`schema.prisma:1006`) | ✅ exists — see [assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md) |
| *Unit/People* rows | `SubCategoryAssociatedResource` (`schema.prisma:630`) — asset sub-category / employee type / custom type, with `isRequired` | ✅ close equivalent, **but keyed only by parent sub-category — no job type** |
| *Estimate* default lines | **nothing** | 🆕 **no such model.** `Template`/`CustomSection`/`CustomField` (`schema.prisma:695`) is the custom-**field** designer for categories, not a line template |
| `Job Type` (`Hourly`, `Hourly w/ Mob`) | **nothing.** `Quotation.billingType` is the closest name and is unrelated — a hardcoded two-value select, `Rental` / `Parts` (`apps/web/src/features/quotations/components/molecules/other-info-section.tsx:60`), display-only on the detail and print views | 🆕 **the dimension does not exist**, anywhere in schema, shared types or web |
| `Yard` on the template key | `Quotation.yard` is a free `VarChar(100)` on the quote; nothing keys defaults by it | 🆕 |
| `Sub-Item` (hidden from customer) | `QuotationResource.isGroup` + `parentId`; the PDF hides **every child of a group parent** (`apps/api/src/usecase/docusign/quotation-pdf.service.ts:562-566`), and `isIncluded` controls whether a child counts toward the parent total | ⚠️ **same outcome, different mechanism** — TCG derives hiding from parenthood, FCC flags each line. A line that is a child *and* visible is expressible in FCC, not in TCG |
| Mob/demob roll-up rows | `isGroup` parents summing checked children (`apps/api/src/usecase/quotations/quotation-resource-totals.ts:4`) | ✅ agrees with [mobilization-and-demobilization.md](mobilization-and-demobilization.md) FR-1/FR-2/FR-6 |
| The template *itself* — defaults arriving on a new quote | **nothing.** Adding a resource to a quotation pulls no associated resources and no default lines; grouping is generic and hand-built per quote (no `Mobilization` preset anywhere in `apps/web/src/features/quotations`) | 🆕 **this is the gap** |

**It sharpens one existing vault claim.** `mobilization-and-demobilization.md` **FR-8** says the
bundling pattern is *"a special case — no other billing categories currently require this
pattern."* The templates agree in effect (only the mob/demob job type uses sub-items) but show
*why*: sub-item is a **generic per-line flag on every estimate template**, and the `Hourly`
template simply ticks none of them. Build the flag as general; the special case is the data.

**It does not contradict anything in the vault.** It adds the layer above mob/demob that no
document covered: mob/demob is not a thing an estimator assembles per quote in FCC — it is a
**job type on the crane** whose template already contains it.

## 5. Incoming

Brian is extracting **all** of these configurations out of FCC into a report and will send it. When it lands: file it under `assets/` here, and it becomes the source for how many job
types exist, whether any is yard-specific, and how far the templates vary across the fleet —
none of which this message answers.

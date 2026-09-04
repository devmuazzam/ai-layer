---
title: FCC Union Codes User Guide — how a union's rules are configured in NexGen
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/Union Codes User Guide.docx (text and its 13 embedded screenshots, read 2026-09-04)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, union-agreement, craft-code, craft-modifier, shift-differential, fringe, overtime, reference-data, pricing]
entities: []
---

# FCC Union Codes User Guide

**What this is.** The vendor user guide for `MAINTAIN → EMPLOYEES → UNION CODES` in NexGen — the
screen where a union's entire pay configuration lives. Five tabs plus two reports. Undated and
unattributed in the extracted text; it documents screens the 2017
[Payroll Guide](fcc-nexgen-payroll-processing.md) does not mention, so it is the later document.

**Why it matters.** The [Payroll Guide](fcc-nexgen-payroll-processing.md) says the processor runs
labor "against a series of payroll defaults" and never says what those are. **This is what they
are.** It is therefore the closest thing in the record to a specification of the configuration
surface the ERP has to replace — and it shows that FCC already models, as configuration, several
things the ERP rule register still treats as open questions.

The guide opens with its own warning, which belongs in any ERP design conversation too:

> **IMPORTANT:** *"Review information in each union's collective bargaining agreements and current
> wage/benefit rate sheets for specific rules when setting up each union code."*

## 1. Main tab — identity and shift premiums

Beyond name and address (code ≤ 10 chars, description ≤ 60), the main tab carries the **shift
premium model**, and it is more general than TCG's current use of it:

| Field | What it does |
| --- | --- |
| **Shift Premium Type** | `Amount` (a dollar figure) or `Percent` (a percentage) — chosen once for the whole union |
| **Pay Rate Options** | Set per shift (**2nd and 3rd only**). `OT` = pay the entire shift at the overtime rate. `DT` = the entire shift at doubletime. `Default` = use the ST/OT/DB premium fields below. *"Shift selection on labor entries will become available when information is selected here"* — configuring this is what makes shift selectable on a labor entry at all |
| **ST / OT / DB Premium** | Per shift, per rate band: the amount-per-hour or percentage-of-gross added to straight-time, overtime and doubletime amounts respectively |
| **Ignore Time Slots** | Per shift: if checked, the **Payroll Defaults** tab's time-slot rules are ignored when calculating that shift's premium |

**Three things the ERP register does not currently model.** (a) A shift premium can be a
**percentage of gross**, not only a dollar adder — the whole into-the-rate-vs-on-top argument at
[PAY-011](rules/PAY-011-l12-modifier-boom-rate.md) / [PAY-036](rules/PAY-036-second-shift.md)
assumes an amount. (b) The premium can be set **separately for ST, OT and DB**, so it need not
scale with the multiplier at all. (c) **`Ignore Time Slots`** is an explicit escape hatch letting a
shift bypass the time-of-day rules — nothing in the register has an equivalent. TCG's actual L12
values ($3.00 / $4.00 flat, per the
[dependency matrix](payroll-rule-dependency-matrix.md) §7) are one configuration of this surface,
not the surface itself. **The document shows the capability; it does not say which option TCG has
selected.**

Note also that only **2nd and 3rd shift** have premium configuration. There is no 1st-shift row —
consistent with the dependency matrix's *"Shift 1: $0 differential"*.

## 2. Benefits tab — union fringes

Each benefit is a line item with a description (≤ 30 chars) and:

| Field | Values / behaviour |
| --- | --- |
| **Type** | `Percent Gross` (gross wages × a percentage) · `Percent hrs Worked` · `Hours Worked` (hours × a dollar rate) · `Hours Paid` (hours paid × a dollar rate) |
| **Amount** | The dollar or percentage rate |
| **Union/Vac** | `Vac` if the benefit is vacation; `Union` for everything else |
| **Optional** | An optional *employee* field (set up under `Maintain → Field Names → Employee Tab`) used to decide **which employees** get this benefit; ticked per employee on the Additional Info tab |
| **Effect On Employee Pay** | `Add to Gross` and/or `Subtract from Net` |
| **Apply This To** | `All` · **`Only Apprentice's`** · **`Everyone Except Apprentice's`** |
| **Include Gross Adds to Pay for this Benefit Calculation** | Include other benefits flagged `Add to Gross` in this benefit's base |
| **Include All Benefits for this Benefit Calculation** | Include every other calculated benefit in this benefit's base |
| **Applies To** | Which earnings count: `ST Earnings`, `OT Earnings`, `DB Earnings` |
| **Maximums** | Daily / Weekly / Monthly caps, each typed as `Amount` or `Hours` |

**"Hours Paid" has a stated definition, and it is load-bearing:** *"1 hour for each straight-time
hour, 1.5 hours for each overtime hour, and 2 hours for each doubletime hour."* A fringe on an
overtime hour therefore costs 1.5 fringe-hours, not 1. The guide repeats this definition three
times — in the benefits tab, the union report and the employee benefit detail report.

**This is the mechanism behind [PAY-051](rules/PAY-051-step-i-pension-exclusion.md) (Step I pension
exclusion).** `Apply This To → Everyone Except Apprentice's` is exactly how a fringe is withheld
from apprentices, and the guide adds the pattern for a *different* apprentice rate: *"create two
different line items of benefits and use this selection box to determine how each line is
calculated."* Likewise the guide's advice for a fringe with different ST/OT/DB rates — create
multiple lines and use `Applies To`. **The document describes the configuration mechanism; it does
not say which fringes TCG has configured or at what rates.** For those, see
[PAY-050](rules/PAY-050-union-fringe-contributions.md) and the
[MLA funds and contributions extract](mcog-l12-mla-2025-2028/04-articles-vi-to-xv-funds-and-contributions.md).

## 3. Pay Rates tab — the craft rate table

One line per craft code, per union:

- **Craft Code** — chosen from `Maintain → Employees → Craft Codes`. *"Craft codes must be created
  before setting up union codes. Add each applicable craft code pertaining to straight-time,
  overtime, and doubletime hours."*
- **Description** and **Pay Type** — read-only, inherited from the craft code definition.
- **Pay Rate** — the dollar rate for this craft code in this union.
- **Billing Rate** — *"used for time and material jobs"*, a separate customer-facing rate on the
  same row.
- **Comments.**

**The structural fact worth carrying:** ST, OT and DT are **separate craft codes with separate
stored rates**, not one rate times a multiplier. TCG's live table bears this out — `L12-G2-A`
67.18, `L12-G2-B` 100.77, `L12-G2-C` 134.36, exactly 1× / 1.5× / 2× (see
[fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md)). Nothing in the
schema enforces that ratio; the multiplier is a convention of how the rows were filled in.
**That sits awkwardly beside the [dependency matrix](payroll-rule-dependency-matrix.md)'s "one
controlling multiplier per 30-minute slice" model, which assumes a single base rate that rules
multiply.** Both can be true — the ERP can store base and derive — but a migration that copies FCC
rows one-for-one inherits the pre-multiplied form. Not adjudicated anywhere.

The **Billing Rate on the pay-rate row** is also worth flagging: pay and billing for T&M work are
configured together, on the union craft record. That is a payroll↔quotations seam the vault has not
drawn.

## 4. Craft Modifier tab — additional pay

Craft modifiers are created under `Maintain → Employees → Craft Modifier` and must exist before the
union is set up. Per union, each modifier carries:

- **Pay Rate Change ST** — dollars *added to the straight-time hourly rate* when this modifier is selected
- **Pay Rate Change OT** — dollars added to the overtime hourly rate
- **Pay Rate Change DB** — dollars added to the doubletime hourly rate
- **Status** — Active / Inactive per union

**This is the FCC-side model for boom, lattice, military and similar premiums**
([PAY-011](rules/PAY-011-l12-modifier-boom-rate.md), [PAY-043](rules/PAY-043-long-boom-premium.md),
[PAY-044](rules/PAY-044-lattice-boom-premium.md), [PAY-071](rules/PAY-071-military-base-premium.md)),
and it settles one question about *shape* while leaving the TCG values open: a modifier is a
**flat dollar adder, configured separately for each of the three rate bands** — so the vendor model
supports both a modifier that scales with the multiplier (enter 1×/1.5×/2× amounts) and one that
does not (enter the same amount three times). The TCG-annotated
[Maintain Employees deck](fcc-employee-master-reference-data.md) says only *"The Craft Modifiers
are used for qualifying additional pay"*. **Which of the two shapes TCG uses is not stated in
either document.**

## 5. Payroll Defaults tab — the overtime engine

The guide is explicit about precedence, and the order is not the obvious one:

> *"Payroll defaults entered on this tab pertain to this union code only. These payroll defaults
> will take precedence over any companywide payroll defaults set up under `Maintain → Company →
> Company → Payroll Defaults Tab` **and over any payroll defaults set up under individual
> employees' profiles** under `Maintain → Employees → Employees → Payroll Defaults Tab` on any
> entries tied to this union code."*

**Union beats employee beats company** — the per-employee override is the *weakest* of the three
for a union employee, not the strongest. Any ERP that models employee-level payroll defaults as an
override on top of the union will invert the incumbent behaviour.

| Field | Options |
| --- | --- |
| **Split Multiple Days** | Whether a time entry spanning days ("for example working overnight") is **split into different days** before ST/OT/DT breakout. A checkbox — cross-midnight handling is configurable, and can be off |
| **OT Eligible** | `Day` / `Week` / `Day and Week`, each with an hours threshold |
| **DT Eligible** | `Day` / `Week` / `Day and Week`, each with an hours threshold |
| **Saturday** | `OT All Time` · `OT After Hours Worked per week` (+ hrs) · `OT Base + DT After` (+ hrs) |
| **Sunday** | `OT All Time` · `OT After Hours Worked per week` (+ hrs) · `DT All Time` · `DT After Hrs Worked per week` (+ hrs) |
| **Round Time To** | Blank = keep actual time · `15` = **round down** to the nearest 15 minutes · `30` = **round down** to the nearest 30 minutes |
| **Time Slot** | Per weekday: a **Time Start**, **Time End** and **Pay Type** (`ST`/`OT`/`DT`). This is the time-of-day window mechanism |
| **Exclude Craft Codes** | Craft codes that "should not follow the rules of payroll defaults". Stated examples: **per diem, travel, holiday, and training** |

Five things to note against the register:

1. **`Time Slot` is the generic form of [PAY-021](rules/PAY-021-l12-standard-work-window.md)** (the
   06:00–17:00 L12 window) — a per-weekday table of start/end/pay-type rows. The ERP register
   treats the window as an L12 constant; FCC treats it as rows.
2. **`Round Time To` rounds *down* only**, in 15- or 30-minute steps. The TCG decision
   [2026-08-24-payroll-time-rounding-method](../decisions/2026-08-24-payroll-time-rounding-method.md)
   is *start down, end up, 30-minute increments* — **an asymmetric rule the FCC field cannot
   express.** Either TCG does not use this field, or the rounding happens elsewhere. Unresolved,
   and worth asking about: it bears directly on
   [PAY-020](rules/PAY-020-half-hour-reckoning.md).
3. **`Split Multiple Days` is a checkbox**, so the incumbent system can be configured *not* to split
   an overnight entry — which is the behaviour [PAY-019](rules/PAY-019-cross-midnight-processing.md)
   is `conflicted` about and the [dependency matrix](payroll-rule-dependency-matrix.md) §4 insists
   must always happen. The document does not say how TCG has it set.
4. **`Exclude Craft Codes`** is the mechanism by which per diem, travel, holiday and training escape
   the OT engine — relevant to [PAY-048](rules/PAY-048-standard-subsistence.md)/
   [PAY-049](rules/PAY-049-weekend-subsistence.md) (subsistence is not worked hours) and to the
   `SUB`, `HOLIDAY` and `SYS-ACCESS` craft codes in the live table.
5. **There is no seventh-day option** anywhere on this tab, and no holiday or special-Saturday
   option — only Saturday and Sunday. [PAY-026](rules/PAY-026-seventh-consecutive-day.md),
   [PAY-033](rules/PAY-033-holiday-pay.md) and
   [PAY-034](rules/PAY-034-june-december-special-saturday.md) have no home in this configuration
   surface. That is consistent with TCG running a separate Payroll App for the union rules.

## 6. The two union reports

**`REPORTS → UNION → UNION REPORT`** — main tab: per employee, per union, for the period: total ST
hours, OT hours, DT hours, hours worked, **hours paid** (1 / 1.5 / 2 weighting), and gross pay.
Summary tab: the benefit breakdown — method of calculation, rate, total hours or amount used, and
**total due to the union**. Printable as both tabs or either.

**`REPORTS → UNION → EMPLOYEE UNION BENEFIT DETAIL`** — the same benefits for one employee or all,
over a date range or all time.

Both reports carry the same two warnings, and the second is a genuine operating constraint:

> *"All payroll pertaining to the dates selected… must be processed before running the report."*
>
> *"Union benefit totals are calculated using the rates and rules entered in NexGen **at the time
> the payroll is processed**. Make sure all payroll is processed for the period when rates and
> benefits apply **BEFORE updating to new rates and rules** in NexGen."*

**That is the incumbent system's whole answer to effective dating: there isn't one.** Rates are
current-value fields; the only way to get historically correct fringe totals is to process payroll
before you change the rates. It is the exact failure mode the
[dependency matrix](payroll-rule-dependency-matrix.md) §13 names — *"a rate table update should
never silently change what the ERP says was actually paid last month"* — and
[PAY-008](rules/PAY-008-effective-dated-configuration.md) is the register's answer to it. The union
craft table does carry `StartDate`/`EndDate` columns
([reference data](fcc-employee-master-reference-data.md)), so the schema has some effective-dating
the guide does not describe; **the guide's warning implies the reports do not use it.** Not
adjudicated.

## Source

`1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/Union Codes User Guide.docx` — 672 KB `.docx`,
converted by pandoc to GitHub-flavoured Markdown (~37 KB of text). Structured as field-by-field
tables per tab, plus screenshots that do not survive text conversion — §1–§6 are from the field tables
only; the 13 screenshots were extracted and viewed on 2026-09-04 — see *What the screenshots
show*. No author, date or version in the extracted text.

## What the screenshots show — read 2026-09-04

All 13 images embedded in `Union Codes User Guide.docx` were extracted and viewed on
2026-09-04: the five tabs of the Union Codes window, the toolbar as it changes per tab, and
three report views. Only what the field tables above did not already give is recorded.

### Dating the guide

The text carries no date. **Every report screenshot is stamped `4/3/2024`**, against demo
data for a test company and two test unions with February 2024 pay periods. The guide is
therefore **no earlier than April 2024** — seven years after the Payroll Guide, and on a
visibly newer NexGen UI generation (flat window chrome, the `Payroll Defaults` tab).

### Window, tabs and toolbar

Window title **Union Codes**; a **Union Code** dropdown in the header selects the record; the
attachments lightning bolt is present. Tabs, in order: **Main · Benefits · Pay Rates · Craft
Modifier · Payroll Defaults**. The toolbar is `New Union · <add> · Del Union · <delete> · First ·
Previous · Next · Last · Copy Union · Refresh · Save Layout · Save · Print · Close`, where the
add/delete pair is relabelled per tab — **Add Benefit / Del Benefit**, **Add Rate / Del
Rate**, **Add Item / Del Item** (Craft Modifier) — and reads `N/A` on Main and Payroll
Defaults. **`Copy Union`** exists on every tab; the text never mentions it. What it copies is
not shown.

### Main tab — fields the table omits, and the defaults

- A **Status** dropdown beside Code, defaulting to **`Active`** — union codes can be
  deactivated, which the text does not say.
- Address block: **Address1 · Address2 · City · State** (dropdown) · **Zip · Phone** (with
  `Ext.`) · **Fax**.
- **Shift Information** group: **Shift Premium Type** radio defaults to **`Amount`**; the two
  **Pay Rate Options** dropdowns (one per shift) default to **`Default`**; the premium grid is
  two columns headed **2nd Shift · 3rd Shift** and three rows **ST Premium · OT Premium · DB
  Premium**, each defaulting to `0.000` — premiums are held to **three decimals**; **Ignore
  Time Slots** is one checkbox per shift.

### Benefits tab

Grid columns **Line Description · Type · Amount · Union / Vac**. A new line defaults to
**Type `Percent Gross`**, **Amount `0.0000`** (four decimals), **Union / Vac `Union`**. Below
the grid the edit pane defaults: **Effect On Employee Pay** — both boxes unticked; **Applies
To** — **ST, OT and DB Earnings all ticked**; **Apply This To** — `All`; both *Include…*
boxes unticked; **Maximums** — Daily / Weekly / Monthly each with an Amount box and a Type
dropdown defaulting to **`Amount`**. So a freshly added benefit applies to every hour band
and to everyone unless narrowed.

### Pay Rates tab

Grid columns **Craft Code** (dropdown) **· Description · Pay Type · Pay Rate · Billing Rate ·
Comments**. **Pay Rate is held to three decimals (`$0.000`); Billing Rate to two (`$0.00`)** —
the pay side is stored at finer precision than the billing side.

### Craft Modifier tab

Grid columns **Craft Modifier** (dropdown) **· Description · Pay Rate Change ST · Pay Rate
Change OT · Pay Rate Change DB · Status**, Status defaulting to **`Active`**. It is a grid
only — no edit pane beneath.

### Payroll Defaults tab

Layout, top to bottom: **Split Multiple Days** checkbox; **OT Eligible · DT Eligible ·
Saturday · Sunday** dropdowns (the hours thresholds the text describes are not visible until
an option is chosen); a field labelled **`Time Round To`** followed by **`Mins.`** — the text
calls it *Round Time To*; same field; then two grids side by side, each with its own **Add /
Delete** buttons: **Time Slot** with columns **Week Days · Time Start · Time End · Pay Type**,
and **Exclude Craft Codes** with a single **Craft Code** column. All blank in the screenshot.

### Union Report — layout

Window header: **Company** dropdown · **Union Code** dropdown (default **`All Unions`**) ·
**View**; two tabs **Main · Summary**.

**Main** prints, per union, the union's name and address block, then an **Employee Detail**
table: **Emp ID · Name · Soc Sec # · S.T.Hours · O.T.Hours · D.B.Hours · Hrs Worked · Hrs Paid
· Gross Pay**, a `Total for <union>` line, and a `Total for <company>` line. Beneath an
employee's name the report prints the names of any **optional employee flags** set for them
(demo: `Voluntary Vacation`, `PAC`) — the *Optional* mechanism of §2 made visible.
**The report prints the employee's Social Security number** on every row; the demo values are
placeholders and are not copied here. The demo confirms the *Hours Paid* weighting exactly:
24 ST + 4 OT = 28 worked, **30 paid**; 160 ST + 20 OT + 30 DB = 210 worked, **250 paid**.

**Summary** is titled **Benefit Summary** and lists, per union: **Description · Type · Max
Amnt · Max Type · Rate · Hours/Amount · Due To Union**, then `Total Due to Union <name>`.
Type values print as **`Hrs Worked`** and **`Percent`**; for a Percent line the
*Hours/Amount* column carries the gross-pay base instead of hours. `Max Amnt` prints `-` when
no maximum is set. The demo benefit lines are an Ironworkers-local set (health & welfare,
pension, supplemental pension, apprenticeship, annuity, IMPACT fund, dues assessment as a
percent, PAE, organizing, vacation fund) — vendor sample data, not TCG's fringes.

### Employee Union Benefit Detail — layout

Header: **Company** · **Employee Name** (search + dropdown, **Name / ID** radio) · **From /
To** dates, where `00/00/0000` in both means **All Dates**. The report is headed with the
employee's name, *Union Benefit Detail*, the date scope, and the union as `<code> <name>`
(demo union code `MR1` — a short alphanumeric code). Rows group by benefit, one line per
**Pay End Date**, with **Type · Max Amnt · Max Type · Rate · Hours/Amount · Due To Union** and
a per-benefit subtotal. Because each row carries the rate used, this report is the only place
in the guide where a **historical rate per pay period** is visible — which bears on the
effective-dating question in §6: the detail rows show the rate that was applied at the time,
even though the guide says the rate fields themselves are not effective-dated.

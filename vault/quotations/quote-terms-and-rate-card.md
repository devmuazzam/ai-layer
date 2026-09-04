---
title: Quote terms and rate card — the customer-facing charge structure
source: client-message/Melissa McNutt — quote OM-35140 (2026-01-21) + LEM ticket Terms and Conditions of Contract (CA), supplied 2026-08-31; extended 2026-09-04 with shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_QUOTES/SAMPLE_QUOTE/OM-36229[35].pdf and 1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/Damage Waiver final  2018.pdf
migrated: 2026-08-31
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/accounting, module/payroll, module/field-ops, kind/reference, pricing, surcharge, minimums, boom, subsistence, permits]
entities: [quotation, billing-code, price-list, surcharge, job, job-ticket, employee, permit, asset]
---

# Quote terms and rate card

Sources: [assets/2026-08-31_quote-OM-35140.pdf](assets/2026-08-31_quote-OM-35140.pdf) — a real
5-page quote (Air Boss Mechanical, 90-ton, 2026-01-21) — plus the **Terms and Conditions of
Contract (CA)** Melissa pasted, which are *"the T&C's that get signed from the LEM ticket on the
job"*. Two different documents that bind at two different moments.

**Read this as billing, not payroll.** Every figure below is what TCG *charges a customer*. What
TCG *pays an employee* comes from the L12 union rates (`FMS_UNION_CRAFT`) and the payroll engine.
The two tables are different shapes and different numbers, and conflating them is the easiest
mistake this document invites — see §4.

Before this file the vault held **no customer-facing rate card at all**:
[billing-code-and-price-list.md](billing-code-and-price-list.md) is UI feedback, and its only
mentions of surcharge are *"Re-design surcharge placement"* and *"Apply surcharge heading should
be"*.

---

## 1. The surcharge, and how it lands on the total

The T&C is blanket and unconditional:

> **ALL CHARGES ARE SUBJECT TO A 12% FUEL & INSURANCE SURCHARGE THAT WILL BE APPLIED ON FINAL
> INVOICES**
>
> ALL SUBCONTRACTORS WILL BE BILLED AT A MINIMUM OF 10% MARK UP

On the quote it is one line at the foot of the rate table, and the arithmetic is checkable:

| Line | Amount |
| --- | ---: |
| 90 Ton Crane — 8.00 h @ $445.00 | $3,560.00 |
| Operator Load — 8.00 h @ $110.00 | $880.00 |
| Crew Overtime — 0.00 h @ $140.00 | $0.00 |
| Crew Double Time — 0.00 h @ $280.00 | $0.00 |
| Travel Permit, 75 Ton and above — 1 @ $165.00 | $165.00 |
| **Subtotal** | **$4,605.00** |
| Fuel & Insurance Surcharge — 12.00% | $552.60 |
| **Estimate Total** | **$5,157.60** |

`4,605.00 × 0.12 = 552.60`. Four facts follow, and each one bears on the implementation:

- **It applies to every line, permits included.** The $165 travel permit is inside the base.
- **It is one customer-visible line with a name** — *"Fuel & Insurance Surcharge"* — not a
  per-line adjustment. `Surcharge` in the schema has `enabled` and `percentage` but **no label
  field**, so the name on the printed quote has nowhere to come from.
- **It is blanket, not opt-in.** The T&C says *all* charges. Our model is per-quotation-resource
  (`surchargeEnabled` / `surchargePercentage` / `surchargeAmount` on each resource, summed in
  `apps/web/src/features/quotations/workspace/detail/detail-format.ts`). Per-resource summing
  equals a subtotal-wide percentage **only when every resource is enabled at the same rate** —
  which the T&C requires but the model does not enforce.
- **It is applied on final invoices**, so it is an invoice-time charge that the quote merely
  estimates. Whether the ERP recomputes it at invoicing against actual time is unstated.

The subcontractor 10% markup is a separate rule and is **not** modelled anywhere.

## 2. Minimums, show-up and cancellation

| Rule | Value |
| --- | --- |
| 22-ton crane, normal hours | 3 h minimum |
| 22-ton, after hours | 4 h minimum |
| Any work before 06:00, after 17:00, Sat or Sun | 4 h minimum |
| 30-ton and above, trucks, support equipment, riggers/signalpersons | 4 h minimum |
| **Operator Load** | **5 h minimum, 8 h maximum** |
| Crane works < 8 h and stays on site overnight | Crew Time 8 h minimum |
| Crew shows up, no work provided | 2 h billed |
| Cancelled within 2 h of crew leave time | 2 h billed |
| Cancelled after crew has left | 4 h minimum, or true time |

The Operator Load rule is printed on the quote line itself (*"5 hour minimum with 8 hour max per
day"*), which independently confirms the OL unit convention in
[dispatch/crane-configurations.md](../dispatch/crane-configurations.md) — an operator load is a
separately dispatched, separately priced unit with its own minimum.

## 3. Labour and premium charges (customer side)

| Charge | Rate | Trigger |
| --- | --- | --- |
| Overtime | $70.00 /person/h | > 8 h/day, before 06:00, after 17:00, or Saturday |
| Double-time | $140.00 /person/h | > 12 h, Sundays, or *"while with a double-time craft"* |
| Triple-time | $210.00 /person/h | Holidays (§5), 8 h guaranteed |
| Crew & Standby | $150.00 /person/h | Portal travel first/last day of multi-day jobs, holdover, standby |
| Qualified Rigger & Signal Person | $160.00 /h | Additional crew |
| Support Vehicle | $165.00 /h | 4 h min — fuel, counterweight, rigging haul |
| Pilot Car | $135.00 /h | 4 h min |
| **Special Equipment** | **$300.00 /day/item** | Man Baskets, Material Bins, Hopper, Pallet Lifters |
| Permits | $65 ≤ 40 T · $165 ≥ 75 T · $300 with runner | City/state travel |
| Lift plan | $500 standard · $950 premium · $145/h revisions · $1,300 engineer stamp | |
| Certified payroll / OCIP / CCIP | $500/project + 3% of invoice per trip after the first | Written notice required *before* job date |
| FAA permit · NOTAM | $115/permit · $25/case | |
| Subsistence | $85/man ≥ 45 mi · $200/man/day > 77.5 mi | Yard-to-job distance |

**Special Equipment is the loading list.** Material Bins, Hopper and Pallet Lifters are items
#21–25 on [assets/loading-list.md](../assets/loading-list.md). So part of Dylan's pick-list is
separately billable at $300/day/item, and the loading screen's selections have a revenue
consequence — nothing in the tools & rigging epic says so.

## 4. Long Boom Charges — a *second*, unrelated boom table

> Where cranes are required to have the following lengths of boom (including jib) the hourly
> rates shall be increased in the amount of:

| Boom length | Straight time | Overtime | Double-time | Triple-time |
| --- | ---: | ---: | ---: | ---: |
| 200′ – 240′ | $13.00 | $19.50 | $26.00 | $30.00 |
| 241′ – 280′ | $15.00 | $21.50 | $29.00 | $38.00 |
| 281′ – 340′ | $17.00 | $27.00 | $35.00 | $45.00 |

This is **not** the boom table we have built. `CRAFT_MODIFIER_BRACKETS`
(`packages/shared/src/constants/craft-modifiers.ts`, decision 23099) is the **pay** side: 17
brackets in 20-foot steps from `080-100` to `421-440`, one operator rate and one oiler rate each,
$0.75 → $13.50/h, with no OT/DT/TT variants.

| | Pay side (built) | Billing side (this quote) |
| --- | --- | --- |
| Brackets | 17, 20-ft steps, 80–440 ft | 3, uneven, 200–340 ft |
| Rate axis | operator / oiler | ST / OT / DT / TT |
| Range | $0.75 – $13.50 /h | $13.00 – $45.00 /h |

Nothing in the codebase or the vault models the billing side. `longBoomHours()` in
`apps/web/src/features/payroll/components/payroll-employee.helpers.ts` and `Long Boom Pay` in the
seed are both payroll. **Quoting a long-boom job today cannot produce the surcharge the T&C
promises.**

## 5. Holiday schedule (I.U.O.E. Local 12)

Ten named holidays: New Year's Day · Presidents' Day · Memorial Day · Independence Day ·
**Day After Independence Day** · Labor Day · Veterans Day · Thanksgiving Day · Day After
Thanksgiving · Christmas Day.

Plus two union general membership meeting days — *"the (1st) Saturday following the (1st) Friday
in the months of June and December."*

Both of those carry problems that are registered in [payroll/gaps.md](../payroll/gaps.md), not
resolved here: the engine's holiday table is missing one of the ten, and the quote contradicts
itself on what the meeting days pay.

## 6. Meal periods — and a three-way disagreement

The same rule is written three ways across the three documents, and they do not say the same thing:

| Source | Text |
| --- | --- |
| Quote T&C p.3 | *"customer will be charged one-half (1/2) hour of Crew time Double-time **at the rate $270/hour per crew member** for every missed meal period"* |
| LEM ticket T&C §15 | *"customer will be charged one-half (1/2) hour of Crew time Double-time"* — no rate, no equipment |
| E-ticket WTL authorization | *"charged one-half (1/2) hour of Crew time Double-time **& one-half (1/2) hour for all cranes and equipment**"* |

Only the e-ticket charges equipment. Only the quote names $270/h — which is not twice the $150
Crew & Standby rate. Registered in [payroll/gaps.md](../payroll/gaps.md).

## 7. Contract terms worth knowing before building billing

- **Portal to portal, billed in 30-minute increments**, per the L12 agreement. Charges *"begin
  and end with Pre & Post trip inspections at equipment(s) dispatched location(s)"* — see the
  post-trip conflict in [field-ops/gaps.md](../field-ops/gaps.md).
- **Inclement weather** — suspension after work began bills ≥ 4 h; > 4 h worked bills actual;
  ≥ 6 h worked bills actual.
- **Quote validity** 30 days. First-time customers COD with 50% deposit, then net 15 on approval.
  3% credit-card processing fee. 1.5%/month (18% APR) past 30 days. $35 returned-check fee.
- **Jobs over $500 are pre-liened** per California law.
- **Invoice discrepancies** must be raised in writing within 14 days; COD within 24 hours.
- **Cancellations** must be 4 hours before scheduled job time.
- Signed acceptance carries **Date / Print / Sign / PO Number** — the PO number is captured at
  acceptance, which is where `Quotation` should expect it.
- Standard insurance (Exhibit TCG): GL $1M/occurrence, Auto $1M/occurrence, Workers' Comp $1M.

Nothing here is adjudicated. These are client artifacts describing what is charged today.

---

# Added 2026-09-04 — a second real quote, and the numbered contract terms

**Source for everything below:** `1.0.1_BUSINESS-REQUIREMENTS/TCG_QUOTES/SAMPLE_QUOTE/OM-36229[35].pdf`
— a complete 5-page quote for **Air Control Systems Inc**, job *The Hub at Ontario*, dated
**2026-03-08**, salesperson Brian Cellier — plus
`1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/Damage Waiver final  2018.pdf`.

Two months later than OM-35140 and a different crane class, and **the T&C pages are the same
document**. What it adds is the *shape of the printed quote*, the full numbered contract, and
three places where the printed rates disagree with the printed terms.

## 8. What a quote document actually contains

Page 1 is the quote proper. Its blocks, in order:

**Header** — `Quote #` (`OM-36229`) · `Date` · `Initials` · page N of 5 on every page.

**The standing preamble**, which carries four commercial rules the rate card does not:

> *"The estimate is based upon information provided by the customer. **This is not a contract and
> will expire 30 days from issue.** After the 30 days rates are subject to change without notice.
> **The job will not be confirmed until we receive either a signed copy of the estimate, written
> confirmation of the quote's approval, or a PO for the project.** All terms and conditions in
> this estimate including all pages are applicable. **All hours are referenced from The Crane
> Guys, LLC "E-Ticket" system. Terms and conditions on the "E-Ticket" are applicable at all
> times.**"*

Three of those are directly implementable: **any one of three artefacts confirms a job** (signed
estimate, written approval, or a customer PO); **the E-Ticket is the authority for hours**; and
**the E-Ticket's own T&C bind as well as the quote's**.

**Two side-by-side panels:**

| CUSTOMER INFORMATION | PROJECT/JOB SITE INFORMATION |
| --- | --- |
| Company Name · Address · Phone Number · **Salesperson** · **Salesperson Cell** · **Salesperson Email** | **Job/Project Name** · Address · **Contact** · **Contact Email** · Contact Phone Number |

So the printed quote carries the salesperson's own cell and email, and the job site's own contact
— which is the `Quoted To` / `Report To` distinction the FCC screens make.

**Description of Work** — free text, and on this quote it carries the scheduling assumption
inline: *"Lift and set 2 units on roof as directed · Crane to setup onsite · **Based on (1) day of
work portal to portal during normal business hours**"*.

**The Lift Info block** — printed as a 3-column grid of exactly the ten fields TCG's SOP defines
([tcg-creating-quotes-sop.md](tcg-creating-quotes-sop.md) §6):

| | | |
| --- | --- | --- |
| Main Boom Length `123` | Height `40` | Jib/Luffer Lgth *(blank)* |
| CWT *(blank)* | Radius `65` | Load Weight `700` |
| Cap at Radius *(blank)* | Lift Depth `30` | Jib Offset *(blank)* |
| Set up Distance `35` | | |

**Bare numbers, no units**, and four fields left empty — consistent with the SOP's instructions
(leave CWT empty on a 40-ton, leave Cap at Radius empty unless required, leave jib fields empty if
no jib).

**Equipment Required** — `40T + LP + NOTAM`. The SOP's shorthand convention, and it encodes the
three chargeable items on the quote.

**The rate table** — `Item Description | Quantity | Unit Meas | Rate | Amount | Comments`:

| Item Description | Qty | Unit Meas | Rate | Amount | Comments |
| --- | ---: | --- | ---: | ---: | --- |
| 40 Ton Hydraulic Crane | 8.00 | Hours | $265.00 | $2,120.00 | |
| Overtime | 0.00 | Hours | $65.00 | $0.00 | *If needed* |
| Travel Permit | 1.00 | Each | $70.00 | $70.00 | *Subject to change pending city and/or agency fees* |
| Standard Lift Plan | 1.00 | Each | $350.00 | $350.00 | *If needed* |
| NOTAM | 1.00 | Each | $25.00 | $25.00 | |
| **Fuel & Insurance Surcharge** | **1.00** | **Each** | **12.00%** | **$307.80** | |
| | | | **Estimate Total:** | **$2,872.80** | |

### The surcharge is a line item, not a footer

**This is different from OM-35140 and it matters.** On OM-35140 the surcharge sat below a printed
`Subtotal` row. Here there is **no Subtotal row at all**: the surcharge is an ordinary rate-table
line with `Quantity 1.00`, `Unit Meas Each`, and a **percentage in the Rate column**.

The arithmetic still works over the other lines: `2,120 + 70 + 350 + 25 = 2,565`, and
`2,565 × 0.12 = 307.80`, giving `2,872.80`.

Three consequences:

- **The surcharge is modelled as a percentage-type line**, exactly as FCC's billing-code import
  template describes: `Amount or Percent Calculation = P`, UOM `PC`, with the base being every
  amount-line flagged `% Applied = Y`. See
  [fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §1. **The two
  documents independently describe the same mechanism.**
- **The permit and the lift plan are inside the surcharge base**, confirming the OM-35140 reading
  that it applies to everything, not just equipment.
- **A quote may print with or without a Subtotal row.** Two real quotes, two layouts. The FCC
  manuals say the New Doc dropdown offers a **choice of quote layouts** and TCG's SOP picks
  *"Detail Quote"* — so layout choice is probably the explanation, but **neither document says
  so**.

## 9. Where the printed rates disagree with the printed terms

Same PDF, pages 1 and 2. **Three of the five priced lines carry a rate the T&C pages contradict.**

| Line on page 1 | Rate charged | What the T&C on pages 2–3 say | Difference |
| --- | ---: | --- | --- |
| **Overtime** | **$65.00** /h | *"Overtime Charges: **$70.00 Per Person Per Hour**"* | −$5.00 |
| **Travel Permit** | **$70.00** each | *"Required city or state travel permits will be billed at a **minimum rate of $65.00 for 40 Tons and below**"* | +$5.00 — *above* the stated minimum, so consistent, but the quoted figure is not the printed one |
| **Standard Lift Plan** | **$350.00** each | *"Standard Lift Plan…………$500.00/per plan"* | **−$150.00** |

The lift-plan gap is the large one. The T&C also carries a **separate** rate for plan work —
*"Any site or customer requirements for lift packages or site plans will be invoiced at a rate of
**$150 per hour** in addition to the lift plan charges listed below"* — and the Additional Items
list gives *"Lift Plan Revisions……$145.000/per hour"*. So **three different hourly-or-flat lift-plan
figures appear on one document** ($350 quoted, $500 standard, $150/h evaluation, $145/h revision).

Two readings are available and **the document supports neither over the other**: the page-1 rates
come from the *customer's price list* and legitimately override the standard T&C; or the T&C pages
are a stale boilerplate. **The quote does not say which, and no other source in the drop settles
it.** What it does establish is that **the rate card printed on a quote is not the rate charged on
that quote**, which is a real risk for anyone treating §3 above as authoritative pricing.

The 12% surcharge, the long-boom table, the holiday schedule, the minimums, the meal-period rule
and the subsistence rates are **identical to OM-35140** and are confirmed, not changed, by this
quote.

## 10. The 27 numbered Standard Terms and Conditions

Pages 4–5, headed *"STANDARD TERMS AND CONDITIONS FOR PRICING OF OPERATED AND MAINTAINED CRANE
RENTAL"*. §7 above summarised a handful; here is what each clause is, because several impose
obligations that a job or dispatch record would have to carry.

| # | What it says |
| ---: | --- |
| 1 | **Customer provides free, clear, safe, compacted all-weather access**, and assumes all responsibility for ground and soil conditions. If the ground cannot safely support the equipment the customer must remedy it first. *"The customer is responsible for communication of all potential hazards… **hills, power lines, underground obstructions**"* |
| 2 | **Customer performs all pre-lift planning and furnishes rigging and rigging services** unless agreed otherwise in writing; riggers must be qualified per **OSHA 1926.1401** |
| 3 | Customer provides competent personnel to direct operation including **signalmen** per **OSHA 29 CFR 1926.1428**; **ANSI / ASME B30.5-2021 ch. 5-3** and **29 CFR Subpart CC (1926.1400–1926.1442)** apply. TCG can supply a qualified rigger or signalman *"upon request with applicable hourly charges"*. **"The customer will be invoiced for any damaged rigging."** Testing and certification of rigging costs extra |
| 4 | **All traffic control, street use or OSHA permits are furnished by the Customer** unless the quote provides otherwise. *"**Customer shall provide a copy of all permits 24 hours prior to the scheduled job.** If a permit copy is not given… customer shall be responsible for the **crane minimum and additional portal charges**"* |
| 5 | **Timber mats, steel plates and site protections cost extra**; loading and unloading of special equipment is invoiced |
| 6 | Customer furnishes free, clear, safe access for **buildup and break down**; work performed to **O.S.H.A. and C.D.A.C.** standards |
| 7 | Customer furnishes warning signs, devices, **spotters**, and arranges for **overhead utilities to be marked, re-located or de-energized** before lifting |
| 8 | **Inclement weather** — suspension after work began bills **≥ 4 h**; > 4 h worked bills actual; ≥ 6 h worked bills actual. *"All cranes are quoted on the basis of an **eight (8) hour minimum workday**, unless work is suspended or terminated due to inclement weather. **This included assembly and disassembly.**"* |
| 9 | **Extra Boom and Accessories** — transport of accessories, counterweights, rigging and jib sections is invoiced at **$155.00 per straight-time hour, 4-hour minimum, per truck**. Premium time applies |
| 10 | TCG not responsible for delays from equipment malfunction, weather or causes beyond its control |
| 11 | **Minimum charges** — cranes left on site for the next day, or where day-to-day work is anticipated, earn the crew **a minimum of 8 hours' pay** at the applicable crew rate |
| 12 | All rates are based on information the customer supplied at quotation time |
| 13 | ***"This is an estimate only. It does not reflect actual time, equipment, or costs to be billed. If estimated hours and / or days are exceeded customer shall be invoiced additional applicable rates."*** |
| 14 | **Site-specific training, 90-day current testing or orientation of TCG personnel is invoiced at applicable rates** |
| 15 | **All cranes are erected and dismantled during straight time in a continuous operation by Operating Engineers (IUOE).** If another craft is required per the L12 MLA or customer requirement, **the customer furnishes that personnel at no cost to TCG** unless agreed in writing |
| 16 | ***"A Waiver of Liability releasing The Crane Guys, LLC from site damage caused by normal crane operation must be signed prior to work but is agreed to if directed to work by customer even without customer's signature."*** — see §11 |
| 17 | Quote valid **30 days**, subject to equipment availability at time of order. Account holders **net 15, no retention**; first-time customers **COD**; **3% credit-card processing fee** |
| 18 | Customer pays all costs of collection including interest, attorney's fees *"(even if suit is filed)"* and collection-agency fees |
| 19 | TCG provides standard insurance per **Exhibit "TCG"**; proofs on request. ***"Additional insured certificates cannot be issued after job has been completed."*** **Bonding is invoiced at cost plus 10%** |
| 20 | **All jobs over $500 are pre-liened per California law**; if the job site is liened for non-payment the customer pays all legal fees |
| 21 | **First-time customers: first job COD with a 50% deposit**; following jobs net 15 **upon credit approval** |
| 22 | **All cancellations must be made 4 hours prior to scheduled job time to avoid charges** |
| 23 | **Invoice discrepancies in writing within 14 days**; **COD discrepancies within 24 hours**; discrepancies raised after the due date are *"null and voided"* |
| 24 | **1.5% per month (18% APR)** on accounts 30 days past due |
| 25 | **$35.00 returned-check fee** |
| 26 | All work performed in accordance with the **IUOE Local 12 Master Labor Agreements** |
| 27 | *"Acknowledgement"* — the signature block |

**Exhibit TCG — Standard Insurance Coverages:** General Liability **$1M per occurrence** ·
Automobile **$1M per occurrence** · Workers' Compensation **$1M**.

**The acceptance block:** *"All estimates must be signed and returned before we can dispatch
equipment and personnel. I have received and read this quotation and understand all terms and
conditions set forth herein."* → **Company Representative Acceptance: Date · Print · Sign · PO
Number.**

**Four clauses create data the ERP would need to hold, and none of them is modelled anywhere in
the vault:**

- **Clause 4** — a **customer-supplied permit copy, due 24 hours before the job**, with a stated
  billing consequence if it is missing. That is a dated, chaseable obligation on the job.
- **Clause 15** — a **non-IUOE craft requirement** the customer must furnish, which is a
  scheduling fact discovered at quote time.
- **Clause 16** — the **Damage Waiver is required before work**, and is deemed accepted without a
  signature if the customer directs work anyway (§11).
- **Clause 19** — **additional-insured certificates cannot be issued after job completion**, which
  makes COI timing a hard pre-job gate, matching the Contracts and COI SOP's urgency trigger
  *"the customer will not allow the crew onsite without the COI"*
  ([contracts-and-coi-sop.md](contracts-and-coi-sop.md) §5).

## 11. The Damage Waiver

`Damage Waiver final  2018.pdf` — a one-page form on TCG letterhead (the **14480 Alondra Blvd, La
Mirada** address), undated beyond its 2018 filename. The whole operative text:

> "The Crane Guys LLC, employees and drivers are **not responsible for damages incurred from
> setup, rigging, loading, and lifting** with respect to any and all real or personal property on
> or adjacent to the worksite location.
>
> Customer hereby acknowledges that The Crane Guys LLC services requested **could potentially
> result in consequential damages to sidewalks, lawns, driveways and other real and or personal
> property.** Customer agrees to assume all risks and liabilities for the aforementioned damages
> and further agrees to hold The Crane Guys LLC employees, agents, officers and owners harmless of
> any and all resulting damages.
>
> The conditions of this waiver apply to damages resulting **under normal work conditions, and not
> as a result of negligence** on the part of The Crane Guys LLC. Additionally, The Crane Guys LLC
> is **not responsible for delays and cost overruns** directly resulting from performance of the
> job requested."

**Fields:** Company Name · **Job Site Address** · Printed Name and Title of responsible party ·
Customer Signature/Title · Date. *"Signature above notes acceptance of the terms contained
herein."*

**It is job-site scoped, not customer scoped** — the form asks for a job site address, so a waiver
is per job, not per account. Combined with clause 16, that makes it **a per-job document with a
signed/unsigned/deemed-accepted state**, due before work starts. Nothing in the vault models it,
and it is not on the Forms and Records Matrix's list of 14 controlled forms
([sales-operating-system/05-forms-and-records-matrix.md](sales-operating-system/05-forms-and-records-matrix.md)
§2) — **so the governance set does not track the one form the contract makes mandatory.**

## Source (2026-09-04 additions)

- `1.0.1_BUSINESS-REQUIREMENTS/TCG_QUOTES/SAMPLE_QUOTE/OM-36229[35].pdf` — 5 pages,
  `pdftotext -layout`. Complete; transcribed in full above and in §1–§7.
- `1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/Damage Waiver final  2018.pdf` —
  1 page, `pdftotext -layout`. Complete.
- Two PNG screenshots sit beside the quote in `SAMPLE_QUOTE/`
  (`Screenshot 2026-03-09 at 11.09.06 AM.png`, `…11.09.11 AM.png`). **Read visually on
  2026-09-04.** They are not of the quote: they are FCC's **Price List** screen — the register of
  15 customer price lists as of 2026-03-09, and BIGGE's Billing Codes tab showing default vs.
  special rates (e.g. 120 Ton Crane $530 → $427.50; Fuel & Insurance Surcharge 15% → 8%).
  Transcribed in [fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md) §4.


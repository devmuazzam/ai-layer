---
title: Quote terms and rate card — the customer-facing charge structure
source: client-message/Melissa McNutt — quote OM-35140 (2026-01-21) + LEM ticket Terms and Conditions of Contract (CA), supplied 2026-08-31
migrated: 2026-08-31
updated: 2026-08-31
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

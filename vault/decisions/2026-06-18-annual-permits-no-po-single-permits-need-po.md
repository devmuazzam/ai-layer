---
title: Annual permits get no PO; single-job transportation permits do — Brian Petros and Melissa McNutt
source: CC TCG ERP System-20260618_184936UTC-Meeting Recording (2026-06-18, 1h39m) — transcript meetings/transcripts/2026-06-18-dispatch-permits.md; written up (unverified) in vendors-agencies/purchase-order.md
migrated: 2026-09-05
updated: 2026-09-05
status: reference
conflicts_with: []
jira: [SCRUM-478]
tags: [module/dispatch, module/vendors-agencies, module/assets, module/projects-jobs, kind/decision, permits, purchase-orders]
entities: [Permit, PurchaseOrder, Asset, Agency, Job]
---

# Annual permits: no PO. Single-job transportation permits: PO.

Stated on the **2026-06-18** recording by **Brian Petros** (who does the permit POs) and confirmed
by **Melissa McNutt** (President). Recorded as a decision on 2026-09-05 because the built rule in
`packages/shared/src/constants/permit-types.ts` had been attributed to nothing, and this is where it
comes from — **partially**. The Confluence write-up of this meeting,
[../vendors-agencies/purchase-order.md](../vendors-agencies/purchase-order.md) §*When We Create a
PO* / §*When a PO Is NOT Created*, is `status: unverified`; the recording below is what verifies it.

## The rule, in their words

**Single transportation permits get a PO.** Brian at **13:04**:

> *"usually I would go if I do the POs for transportation permits, or if we need to create a PO
> for an encroachment permit… a transportation permit would be any permit that all our cranes need
> transportation permits because they're oversized vehicles. When we have annuals, it covers us the
> whole year. When we need to get a single permit, it's usually because cities don't offer annual
> permits or because we don't go off into that city that it's not worth us getting a whole annual."*

At **16:18–16:55** he walks through creating exactly that PO in FCC — department *Operated &
Maintained*, the **city as the vendor** (*"city of Alhambra, Aliso, Anaheim, all these cities"*),
noting *"in the new system we were talking about storing them as agencies."*

**Annual permits get no PO.** Brian at **1:03:29**:

> *"let's say on Monday we have another job for Orange… You would charge the customer the rate,
> which would be the permit rate that the guys quote on their jobs, but I wouldn't get a permit
> because I already got an annual. So I wouldn't do a purchase order for that one because I know I
> have an annual that's going to cover me there… the charge would go through to the customer, but
> we wouldn't have another purchase order in the system."*

Ehtesham put it directly at **1:06:52** — *"if we are using an annual permit on a job, do we bill
it to the customer? … and do we create a PO for that?"* — and **Melissa** answered at **1:07:08**:

> *"I don't think we do. We could and tie it to the machine just to get the cost of the machine,
> but we don't bill the annuals to customers."*

The Confluence write-up states the same, tabulated: create a transportation-permit PO when *"the
job is in a city not covered by an annual permit"* or *"the crane is over 350 tons"* (annuals are
never available for the 360-ton crane); no PO when using existing annuals (*Caltrans, LA City, LA
County*) — *"Annual permits have already been paid. Permit line item still appears on the customer
quote. The company absorbs the cost. No new PO is generated."*

**Permit → PO, in Brian's framing.** At **38:27** Brian himself articulated the mechanism:
*"instead of creating a purchase order, maybe we're going to be creating a permit and… it'll
capture enough information for the system to automatically create the purchase order"* — and at
**39:26**: *"And then it shows up to Accounting as a purchase order, as a permit purchase order.
That sounds cool."* Recap at **1:10:32** (Ehtesham): *"POs for cranes, POs for permits, POs for
third-party vendors — three major categories"*; Brian at **1:11:08**: *"No"* — nothing else.

## What this settles

| | PO? | Billed to customer? |
| --- | --- | --- |
| **Annual** permit (Caltrans "purple", LA City, LA County annuals; held per crane) | **No** — already paid, company absorbs | **No** |
| **Single-job** city transportation permit (city has no annual, or crane > 350 t) | **Yes** — city/agency is the vendor | Yes — permit rate on the quote |
| Encroachment (RCS / Roadway), permit-agency (Quality Permits), 360-ton multi-agency | Yes | — |

The distinction is **annual vs single**, not travel vs non-travel.

## How the build maps to it

`packages/shared/src/constants/permit-types.ts` exempts **both** travel types from the PO gate:

| `PermitType` | Built | Per this decision |
| --- | --- | --- |
| `TRAVEL_ANNUAL_PURPLE_PERMIT` | exempt | **correct** |
| `TRAVEL_CITY_STREET_PERMIT` | exempt | **wrong** — this is the single-job permit Brian raises POs for |

The exemption is over-broad by one type, and it is the type that matters most: the quotation's
`needTravelPermit` flag is converted into permit requests of exactly `TRAVEL_CITY_STREET_PERMIT`
(`apps/api/src/usecase/projects/generate-automated-job-requests.ts:42`), so **every
auto-generated job travel-permit request is currently exempt from a PO**. The `generate-po`
endpoint also refuses them outright (`permits.service.ts:250`, *"Travel permits do not require a
purchase order."*).

The 2026-09-05 UI mockup puts its PO widget on the quotation-driven Travel Permit artifact — which
is the city/street case — and is therefore **consistent** with this decision where the build is not.

## What this does not settle

- Whether permit **approval** must wait for the PO (the built gate, `permits.service.ts:202`).
  Brian accepted permit→PO auto-creation here (38:27–39:26); the *approval* gate was first stated
  by CodingCops on 2026-07-29 @ 13:52. See
  [2026-09-05-po-types-and-quote-to-invoice-workflow.md](2026-09-05-po-types-and-quote-to-invoice-workflow.md).
- The 350-ton boundary is Brian's; Kyle Harlow at **1:00:54** says *"it's actually 350 and
  below… the 360 is a single"* — consistent, but the threshold value is worth confirming in the
  asset model.
- PO statuses; standalone POs; the quote-lost rule — all still open in
  [../vendors-agencies/gaps.md](../vendors-agencies/gaps.md).

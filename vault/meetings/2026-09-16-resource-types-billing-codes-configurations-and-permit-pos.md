---
title: Resource types and billing codes — the quote carries codes, dispatch carries resources; crane configurations, mob/demob roll-up, invoice content, permit POs (16 September 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-09-16_Resource Types and Billing Codes - transcript.docx"
migrated: 2026-09-17
updated: 2026-09-16
status: unverified
conflicts_with: [decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md]
jira: []
tags: [module/quotations, module/assets, module/dispatch, module/accounting, module/projects-jobs, kind/meeting-notes, pricing, mob-demob, permits, purchase-orders, invoicing, requirements]
entities: []
meeting_date: 2026-09-16
---

# Resource types and billing codes — 16 September 2026

Curated from [transcripts/2026-09-16-resource-types-and-billing-codes.md](transcripts/2026-09-16-resource-types-and-billing-codes.md)
(28 m 30 s, recording "ERP PricingResources"). Labelled speakers: **Joe Schacatano** (TCG, VP of
Sales — the sales and quotation owner, per
[../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md)),
**Brian Petros** (TCG; his account drives the shared FCC NexGen screen), ehtesham.anwar (CodingCops).
Ryan and Wes are addressed on the call but have no label of their own, and neither says anything
attributable.

> **Forward-looking.** Below is what named people said on the call. The one binding statement is
> recorded as a decision note:
> [../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md).
> Everything else is registered as a gap, and each section says where. **Client statements and
> CodingCops proposals are kept apart** (§8).

> **What the call was.** Joe walked Brian through FCC NexGen's *Maintain → Resources → Resource
> Types* screen (Main, Job Type/Yard, Unit/People and Estimate tabs), using job `OM60788` and its
> quote, a 350-ton crane, and quote `OM-29537` (360 ton w/ luffer, *Hourly w/ Mob*). The screen is
> already transcribed in
> [../quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md).
> This call adds **what Joe wants the ERP to do differently from it.** Joe had to leave for another
> meeting at 22:24 and 27:53, so the mob/demob walkthrough was cut short.

## 1. The quote carries billing codes; resources exist for dispatch (2:39 – 7:19, 14:25 – 15:35)

**Joe Schacatano, stated unprompted, then confirmed on direct questions.** This is the decision
note's substance.

- **The FCC screen is not the model to copy.** Joe (2:39): *"in our new system, it doesn't have to
  mimic this, although you have to have a population of assets and resources. Really on the
  quoting stage, we just need the billing codes to populate, and then when it transfers to a job,
  whatever billing codes are populated, it has to be able to have the resources for dispatch to tie
  in the assets and the personnel."*
- **Unit/People must not populate the estimate.** Ehtesham (5:46): *"in our current system, we are
  populating unit people directly in estimates. You are saying an estimate directly them should not
  be populated, right?"* Joe (6:11): **"Correct."**
- **FCC's direction is backwards.** Joe (6:43): *"the way that FCC built this is, is it populates
  the unit and the resources, then the codes. I think it's backwards. I think the codes should
  generate the resources and the assets that are need when it's in dispatch."* And (7:09): *"why
  does it matter to sales or to a quote what assets and what resources are needed? It's a billing
  code thing. The billing codes should dictate the resources and the assets for dispatch to assign,
  you know, appropriately as the job is set up."*
- **No unit-type pre-selection.** Ehtesham (14:25) described the current flow, *"first select unit
  type mobile crane… Shouldn't they be just selecting 350 ton crane?"* Joe (15:00): *"if the 350 has
  its profile and it's tagged to the type, no, we don't need to select that. It should just be a
  drop down of selecting the machine. It transfers to the quote, the associated billing codes that
  we want it to populate."* And (15:19): *"when it transfers to a job, whatever unit people,
  resources, whatever you want to call, it would then show up on the dispatch end because that's
  all it's used for… It should just be the 350. We don't need any of that other crap."*
- **What a resource type seeds on the quote**, as shown live on a new FCC quote (14:25, Ehtesham
  reading it): the 350, **operator load, support load, support load, travel permit, fuel & insurance**.
  Each is its own billing code. Joe (9:23): *"they're all their own codes"*; (9:28): *"any code that
  populates is its own code."*

**How this sits with the vault.**

- **Follows up the previous day.** Joe raised the same objection against the working quotation on
  the 2026-09-15 live demo
  ([2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md](2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md)
  §2, 39:45–42:33). There, Ehtesham asked for *"the relationship between the billing codes and the
  resources and the field assets"* (44:43), and Joe offered a screen-share. This call is that
  screen-share.
- **Confirms and sharpens** Joe's 2026-09-02 ask that quotes populate from resource types
  ([2026-09-02 notes](2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md) §2). What
  the resource type seeds on the quote is its **estimate billing codes, not its Unit/People
  rows**.
- **Contradicts the as-built quotation, and the design note that describes it.** Per
  [../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md](../decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md)
  (`reference`, a CodingCops design never ratified by a TCG decision-maker), associated resources
  (`SubCategoryAssociatedResource`) are auto-populated onto the quotation, and Always Included rows
  cannot be removed. Ehtesham stated the as-built at 5:46. **Joe says those rows do not belong on
  the quote at all.**
- **Compatible with** the job side: Always Included associations are already materialised onto the
  job when a quote is converted
  ([../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md](../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md)).
  That is dispatch-side resource generation. Note that its "job Resources tab mirrors the
  quotation's priced lines" rule assumes resources arrive through the quote.
- **Consistent with** [../dispatch/gaps.md](../dispatch/gaps.md) → *Crane configuration — which
  loads are mandatory* (resolved 2026-09-03: **sales picks** the configuration at quotation time).
  Under Joe's model, sales still picks it, through the operator-load and support-load **billing
  codes**.
- **Not settled on the call.** Ehtesham (15:35): *"I want to figure out the solution to this one
  as compared to what we have built."* Still open: where the resource requirement is stored (the
  resource type × job type configuration, as FCC does it, or the billing code, as Joe's wording
  suggests) and what happens to the existing Unit/People rows on quotations. Registered in
  [../quotations/gaps.md](../quotations/gaps.md), as a 2026-09-16 update to the entry the 09-15
  notes open on quote line items vs dispatch resources.

## 2. Resources carry no billing code; a bundling code prices them (9:43 – 11:33)

- **Joe (10:19, 10:48, 11:10):** *"the operator load has a billing code, right? And then the
  resources, correct, would be you're tying in the tractor, trailer, and then operator or whatever
  personnel to it. So you're not going to have a code for those… the operator load, because it has
  a charge, is the code because basically the resources, the person, the trailer, and the tractor
  are what's needed to operate that. So you're not going to have individual codes for those. **Their
  costs are built into that code** and that charge to the customer."*
- **Who keeps the code amounts right.** Ehtesham (11:14–11:21): *"that takes the responsibility of
  making sure that any billing code on the estimate that is pulling up, it has the right amount. And
  its responsibility is going to go to the stakeholder team, right?"* Joe (11:32): **"Right."**
  ⚠️ *"stakeholder team"* is probably an ASR error, most likely for *sales team*. Which team owns
  it is therefore **not established** by this line.
- **Brian (11:36–11:57):** in FCC it is *"not very apparent, very clear in the system"* how the
  `880` Operator Load code connects to the tractor and trailer lines on the Unit/People tab.
- Agrees with [../dispatch/crane-configuration-rules.md](../dispatch/crane-configuration-rules.md)
  §7 (every additional load is billable; `OPL` / `CWT` / `SUPP` are billing codes). It adds that the
  tractor, trailer and driver **inside** a load have no code of their own.

## 3. One asset, one type — and one crane, several configurations (3:33 – 5:46, 25:05 – 27:41)

Ehtesham asked twice whether one thing can sit under two definitions. The two answers need reading
together.

- **One type per asset.** Joe (4:25): *"No, it shouldn't have two definitions."* (4:53): *"it's
  just going to be one specific type."* (4:59): **"Whatever the asset is, it can only have one type
  to it. It can't have multiple types. There's no way because it's only built for a specific
  purpose. Now, can you utilize it? Derated to cover other equipment sizes in the same type,
  absolutely, but you're never going to change the type."** Brian (4:41) put it as *"there's only
  one schedule type"*, and (5:22): *"this is mobile crane, but like a 90 ton, which is also a mobile
  crane, can do that job. The 75 or whatever, maybe not a 40."*
- **A truck crane and an RT are never the same.** Ehtesham (5:23): the 90 ton hydraulic truck crane
  and the 90 ton RT are two different assets? Joe (5:44): **"Totally, totally different, can never
  be the same."**
- **But one crane can have several configurations.** Joe (26:31): quote OM-29537 reads *"360 ton
  with luffer"* because **"after this job, we made separate ones for the different
  configurations"**. Before that the resource type *"would have just said 360 ton current"*
(26:51; "current" is probably an ASR error for *crane*, left unchanged). Ehtesham
  (26:59): *"360 ton crane… with luffer and without luffer, they are the same cranes, right?"* Joe
  (27:13): **"Same cranes, different configurations."** Ehtesham (27:16): *"our main resource type
  configuration can have… one asset and two configurations"*. Joe (27:33): **"Yes."** Brian
  (27:34): *"That's the first time I think we talked about that being the same asset, two
  different… configurations here, same type."*

**Reading.** "Type" in Joe's first answer is the **schedule type** (Brian's word at 4:41): mobile
crane, RT, crawler. An asset has one of those. It may still stand for **several resource types**:
smaller sizes of the same schedule type by derating, and configurations of itself (w/ and w/o
luffer). FCC data already has this shape. `FMS_UNIT_TYPE_DETAILS` gives 48 of 358 units more than
one type, and resource type 76 *360 Ton All Terrain w/Luffer* is new since July
([../assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md) §5, §6).
**Built state:** `Asset.subCategoryId` is a single FK (`apps/api/prisma/schema.prisma`, `model Asset`),
and `SubCategorySubstitution` pairs sub-categories, not assets. How a configuration is modelled is
open. Registered in [../assets/gaps.md](../assets/gaps.md) (new entry, *One asset, one type*).

## 4. Mob/demob roll-up — confirmed, and Joe wants it on the billing code (22:24 – 26:25)

Joe, on quote `OM-29537` against the 360 ton w/ luffer *Hourly w/ Mob* template:

- (22:45): *"all these billing codes. This is everything it takes to build out a mob/demob. If you
  notice the sub items where they're all checked off."* (23:07): *"it adds up whatever amount you put
  in and on the mobilization line, it's totaled out on the mob line and it's totaled out on the
  demob line."*
- (24:27): **"see how it only shows the mob, demob, and then the line items after the mob? So
  basically we need something to calculate mobilizations and demobilizations so that we're not
  showing 50 billing codes."** Brian (24:42): *"It's nice, nice and short."*
- (24:46): **"we just need something on our billing codes to have the option of adding it all up to
  where it totals into our mob and demobs and then it only populates like this on our actual quote
  to the customer."** He also said Ryan has built a similar tool on a spreadsheet, and offered a
  separate call to show it.
- **Lines after the demob come from the template.** Ehtesham (25:05) asked whether the 360 ton
  lines after the demob were entered by hand. Joe (25:15, 25:42): *"No, they are"* from the resource
  type. The template has them *"after demobilization"* (the crane's working time, 16 hours on this
  quote, 23:52). **Crew overtime, crew double time and traffic control services were added by
  hand** (26:03): *"that's not something that should populate… this job was on a Saturday and
  Sunday and it was in a street closure."*

**Against the vault:** this confirms
[../quotations/mobilization-and-demobilization.md](../quotations/mobilization-and-demobilization.md)
FR-1, FR-2, FR-6 and FR-7, and the template reading in
[../quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md)
§2–3. *"On our billing codes… the option"* points at the billing-code-level **Default as Sub-Item**
flag (§8.2 of that page), which the ERP does not have. Brian's `ParentEstimateID` correction still
stands: which line is whose child is stored, not read off row order. TCG's `isGroup` roll-up is
already built. What is missing is the template that seeds it. Registered as an update to
[../quotations/gaps.md](../quotations/gaps.md) → *Estimate defaults per resource type / job type /
yard*.

**The dedicated mob/demob session was deferred.** Ehtesham (15:35) asked to hold it until he had
worked out §1. Joe (16:07) is *"in Omaha all next week"*, so anything involving him happens the week
after, **from 2026-09-28**.

## 5. Invoice content and the customer packet (16:19 – 17:55)

- **The customer sees only the estimate.** Ehtesham (16:45) asked whether the invoice shows the
  quotation's estimate tab or the resources. Joe (17:20): **"customers only gonna get the
  estimate."**
- **Tickets travel with the invoice.** Joe (17:46): **"we would send a packet with the final
  tickets for each individual resource."** He had first taken the question to mean internal
  tickets (17:35, *"To internally to our people"*).
- Ehtesham (16:19): the accounting flow, *"creation of invoice directly from here"*, is affected by
  §1. Joe (16:34): *"Correct."*

**Against the vault:** consistent with
[../accounting/gaps.md](../accounting/gaps.md) → *Billable hours* (c), where signed tickets travel
with LADWP invoices. This call says it of invoices generally, not only for LADWP. It does not say
how ticket hours map to estimate lines, which is that entry's open core. Registered as an update
there.

## 6. Purchase orders for permits (17:55 – 22:15)

- **Why FCC uses POs for permits.** Joe (18:24): *"We just use PO so when we get the billing for it,
  we can tie it to a job."* Typically a third party (18:40). The other case is a city paid directly
  (18:40): *"they tie the PO to the city that we paid direct for it, so that when we get the invoice
  from the city, we have it tied to the specific job."*
- **Per permit, not a standing account.** Joe (20:33): *"No, it's on an individual basis."* (20:38):
  *"it would be on a yearly is if we're getting annual permits."*
- **A PO for every job cost.** Asked whether a permit ever needs no PO, Joe (20:57): **"there should
  be a PO for anything or where there's associated costs that are tied to a job."** (21:10): *"So we
  should be able to do a PO for anything within a job."*
- **Who invoices.** Brian asked (21:38). Joe: *"If we're doing it directly, they invoice us, if
  it's through the third party, the third party does it all."* Ehtesham (22:07): *"third party gives
  us the invoice with the PO number that we provided with them."* Joe (22:11): *"Exactly."*

**Against the vault:** consistent with
[../decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md](../decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md)
(annual permits no PO, single permits with the city as vendor) and with
[../decisions/2026-09-11-permit-approval-requires-linked-po.md](../decisions/2026-09-11-permit-approval-requires-linked-po.md)
(`reference`, which records that *"Brian's confirmation still wanted"*). Joe is a second TCG voice
for the job-tied rule. He did **not** say whether an annual permit, which is not tied to a job, gets
a PO. For the as-built claim Ehtesham made, see §8. Registered as an update to
[../projects-jobs/gaps.md](../projects-jobs/gaps.md) → *PO exemption swaps the annual-vs-single
axis*.

## 7. Next steps stated on the call

- Mob/demob deep-dive with Joe: the week of **2026-09-28** (§4). Ryan's spreadsheet tool: a separate
  call, not scheduled.
- Brian (28:04) will confirm whether Lisette can attend *"tomorrow or Friday or Tuesday"*. Ehtesham
  (28:12) asked to be told whether there is a meeting on 09-17 or 09-18.
- Ehtesham (27:53): *"I'll start processing this and see what changes in the current system."*
- Ehtesham (16:19): demo feedback is expected from Lisette and others meanwhile.

## 8. What CodingCops proposed or asserted — not client decisions

- **Ehtesham (15:35):** defer mob/demob and redesign §1 first, *"as compared to what we have built"*,
  as the first priority.
- **Ehtesham (21:22), describing the build:** *"whenever you're going to upload a permit… it's going
  to ask you to create a PO. If you don't have a PO, it becomes required when you upload the final
  permit."* Joe (21:36): *"Perfect."* ⚠️ The recorded rule is that **approval** requires a linked PO
  ([2026-09-11 decision](../decisions/2026-09-11-permit-approval-requires-linked-po.md)). Final-permit
  **upload** was not checked against the build here. Joe's "Perfect" endorses a PO being required.
  It is not a ruling on the trigger.
- **Ehtesham (11:14):** that ownership of billing-code amounts moves to the "stakeholder" team (§2).
  It was his framing, answered with a one-word "Right".
- **Ehtesham (3:54 – 5:46) and (26:59 – 27:16):** the "one thing, two definitions" questions (§3)
  were his, and so was the phrasing "one asset and two configurations" that Joe affirmed.

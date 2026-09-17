---
title: "The quotation carries billing codes only; resources (Unit/People) are a dispatch-side requirement with no billing code of their own — decision"
source: decision/client recorded call (Joe Schacatano, 2026-09-16)
decided: 2026-09-16
decided_by: >-
  Joe Schacatano (TCG, VP of Sales; the sales and quotation owner, per
  admin/engagement-directory-and-org-charts.md), on the recorded 2026-09-16 "ERP PricingResources"
  call. Some statements were unprompted (2:39, 6:43, 7:09, 10:19–11:10, 15:00–15:19). Others
  answered direct questions from Ehtesham Anwar (CodingCops): 6:11 "Correct.", 9:23, 9:28.
  Brian Petros (TCG) was present and did not object. Joe first raised the same principle against
  working software on the 2026-09-15 live demo (39:45–42:33, meetings/2026-09-15-erp-live-demo-01-*).
  That ingest logged it as a gap, because he had not yet explained the model. This dedicated call
  was the explanation. Not confirmed in writing. How the ERP implements it was left open on the
  call by Ehtesham (15:35).
status: verified
conflicts_with: [decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md]
resolves: []
jira: []
tags: [module/quotations, module/dispatch, module/assets, kind/decision, pricing, requirements]
---

# Decision

Joe Schacatano, 2026-09-16:

1. **At the quoting stage, the estimate is billing codes only.** A quotation does not carry the
   resource type's *Unit/People* rows: the tractor, trailer, operator and other personnel.
2. **Resources exist for dispatch.** When the quote becomes a job, the billing codes it carries
   must bring with them the resources dispatch needs to assign assets and personnel.
3. **A resource has no billing code of its own.** A load's tractor, trailer and driver are priced
   inside the load's code (Operator Load, Support Load). Every line that does populate on the
   estimate is its own billing code.
4. **The salesperson picks the machine directly.** A drop-down of resource types (for example
   "350 ton crane"), with no unit-type or category chosen first. The resource type's profile
   already carries its type, and it brings its associated billing codes onto the quote.

## The client's words

`meetings/transcripts/2026-09-16-resource-types-and-billing-codes.md`:

- **2:39.** *"in our new system, it doesn't have to mimic this, although you have to have a
  population of assets and resources. Really on the quoting stage, we just need the billing codes to
  populate, and then when it transfers to a job, whatever billing codes are populated, it has to be
  able to have the resources for dispatch to tie in the assets and the personnel."*
- **5:46 → 6:11.** Ehtesham: *"in our current system, we are populating unit people directly in
  estimates. You are saying an estimate directly them should not be populated, right?"* Joe:
  **"Correct."**
- **6:43.** *"the way that FCC built this is, is it populates the unit and the resources, then the
  codes. I think it's backwards. I think the codes should generate the resources and the assets that
  are need when it's in dispatch."*
- **7:09.** *"why does it matter to sales or to a quote what assets and what resources are needed?
  It's a billing code thing. The billing codes should dictate the resources and the assets for
  dispatch to assign, you know, appropriately as the job is set up."*
- **9:23, 9:28.** *"they're all their own codes"*; *"any code that populates is its own code."*
- **10:48 – 11:10.** *"the operator load, because it has a charge, is the code because basically the
  resources, the person, the trailer, and the tractor are what's needed to operate that. So you're
  not going to have individual codes for those. Their costs are built into that code and that charge
  to the customer."*
- **15:00.** *"if the 350 has its profile and it's tagged to the type, no, we don't need to select
  that. It should just be a drop down of selecting the machine. It transfers to the quote, the
  associated billing codes that we want it to populate."*
- **15:19.** *"when it transfers to a job, whatever unit people, resources, whatever you want to
  call, it would then show up on the dispatch end because that's all it's used for… It should just
  be the 350. We don't need any of that other crap."*

**The day before**, on the 2026-09-15 live demo
([../meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md](../meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md)
§2), Joe said it of the working quotation screen at 39:45: *"Oiler, operator, semi, those things
don't get charged. Those are the resources utilized in dispatching."* At 42:33: *"you don't want
the 10 resources populating with it, with charges for it."* That note records it as a gap
because the model was still owed. This call was the follow-up that explained it, and Joe
confirmed the principle on direct questions.

## Why

Joe gave the reason at 7:09: the resources behind a code are a dispatch concern, not a sales one.
A quote is priced by billing codes, and the customer is billed by billing codes. Joe, 17:20:
*"customers only gonna get the estimate."* Physical resources matter only when dispatch assigns
them. This also removes the problem Brian raised at 11:36: in FCC it is *"not very apparent"*
which Unit/People rows a code such as `880` Operator Load stands for.

It **extends** Joe's own 2026-09-02 statement that quotes should populate from resource types
([../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md](../meetings/2026-09-02-sprint-demo-tickets-payroll-and-crew-configuration.md)
§2). This decision says **what** populates: the billing codes.

## What this decision does not settle

These are open, and registered in `quotations/gaps.md`: the entry the 2026-09-15 ingest opens on
quote line items vs dispatch resources, with a 2026-09-16 update:

- **Where the resource requirement is stored.** It may stay on the (resource type × job type ×
  yard) configuration, as FCC's *Unit/People* tab does and `SubCategoryAssociatedResource`
  approximates. Or it may move onto the billing code, as Joe's *"the codes should generate the
  resources"* could be read. Joe did not choose between these.
- **What happens to existing quotations** that carry associated-resource rows.
- **How the drop-down covers non-machine resources** (tools and rigging, employee types, permits),
  now that the category step is gone.
- **Who maintains billing-code amounts.** The 11:21 answer is to an ASR-garbled "stakeholder team".
- **Mob/demob.** It is a separate walkthrough, deferred to the week of 2026-09-28.

## Conflicts

- **[2026-09-04-always-included-associated-children-cannot-be-removed.md](2026-09-04-always-included-associated-children-cannot-be-removed.md)**
  (`reference`; a CodingCops design demoed three times and never ratified by a TCG decision-maker).
  It rules on how auto-populated associated-resource rows behave **on a quotation**. This decision
  says those rows should not be on a quotation at all. Its inclusion-type semantics still matter
  on the job and dispatch side, where
  [2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md](2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md)
  already materialises Always Included associations at conversion. That note's "the job Resources
  tab mirrors the quotation's priced lines" assumes resources reach the job through the quote. It
  must be re-read against this decision, but it is not contradicted outright.
- **As built** (Ehtesham, 5:46 and 14:25): the quotation populates Unit/People rows, and the
  salesperson selects a unit type before the machine. Both contradict this decision.
- **Not a conflict:** [../dispatch/gaps.md](../dispatch/gaps.md) → *Crane configuration — which
  loads are mandatory* (resolved 2026-09-03, sales picks the configuration). Sales still picks it,
  through the Operator Load and Support Load billing codes.

## Effect on the vault

Not applied in this pass. The ingest ran alongside another transcript ingest and was told not to
touch shared files. These edits are proposed to the caller:

- `decisions/2026-09-04-always-included-associated-children-cannot-be-removed.md`: add
  `decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md` to
  `conflicts_with:`. No supersession: that note's rule still describes the job/dispatch side, and
  nothing yet replaces the quotation-side behaviour.
- `quotations/gaps.md`: an update to the 2026-09-15 quote-lines-vs-dispatch-resources entry,
  marking the principle decided and the model still open. Also an update to *Estimate defaults per
  resource type / job type / yard*.
- `quotations/INDEX.md`, `dispatch/INDEX.md`, `assets/INDEX.md`, and the `vault/INDEX.md` decisions
  table: a line each.

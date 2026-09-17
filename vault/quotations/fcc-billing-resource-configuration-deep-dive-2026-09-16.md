---
title: "Brian's FCC deep dive — billing codes, price lists, resource recipes and crane configurations, with ERP recommendations (16 September 2026)"
source: user-supplied/client-authored recommendations — `CraneConfigurationsAndBillingCodes_FCCvsERP.pdf` (32 pp.), Project Repository shared folder, announced by Brian Petros in Teams 2026-09-17 01:50 PKT. Written with TCG's own AI model from read-only queries against the NexGenFMS database; addressed "To: Ehtesham / CodingCops", dated 2026-09-16
original_file: "CraneConfigurationsAndBillingCodes_FCCvsERP.pdf"
migrated: 2026-09-17
updated: 2026-09-17
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/dispatch, module/assets, kind/source, fcc, pricing, price-list, billing-code, mob-demob, requirements, crane-configuration, migration]
entities: [quotation, quote-line, billing-code, price-list, unit-type, sub-category, asset, job, dispatch-requirement, mob-demob]
---

# Brian's FCC deep dive — billing, pricing, resource configuration and dispatch

The PDF is stored at
[assets/2026-09-16-brian-crane-configurations-and-billing-codes-fcc-vs-erp.pdf](assets/2026-09-16-brian-crane-configurations-and-billing-codes-fcc-vs-erp.pdf).
This page summarises it by section and says how much weight each part carries.

## How to read this document

- **It is a recommendation, not a decision.** Brian Petros had TCG's AI model write it the
  evening of the 2026-09-16 call with Joe Schacatano. The model queried FCC's NexGenFMS database
  directly, read-only. The PDF still carries the chat framing: it opens *"Worked for 1m 2s. Below
  is the version I would send to Ehtesham"*, and it cites the call as
  `2026-09-16_Resource Types and B…`, the same recording as
  [../meetings/transcripts/2026-09-16-resource-types-and-billing-codes.md](../meetings/transcripts/2026-09-16-resource-types-and-billing-codes.md).
- **Three kinds of content, weighted differently:**
  1. **What Joe said on the call.** It is paraphrased and matches our own notes
     ([../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md](../meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md)).
     The binding part is already recorded in
     [../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md).
  2. **FCC database facts**: table row counts, one quote and job traced, price-list statistics.
     These are useful evidence, but the query output was not supplied and CodingCops has not
     reproduced them against its own extract.
  3. **Recommended ERP model**: *Service Profile, Billing Bundle, Dispatch Requirement Template*,
     and so on. This is the client side's proposed design. **No TCG decision-maker has adopted
     it.** Joe stated the principle. The object model is Brian's and his model's.
- Brian's covering message calls it *"one of the biggest improvements (behind-the-scenes) in the
  ERP"* and suggests feeding it to our AI tooling. It is here as a source to design against. It
  is **not** a spec and does not answer the open questions for Joe.

## FCC facts it reports (§2–§12, §17, §19, §21)

| # | Finding | Evidence given | Already in the vault? |
| --- | --- | --- | --- |
| §2 | FCC keeps estimate lines (`FMS_QUOTE_DETAILS` / `FMS_JOB_DETAILS`) apart from Unit/People (`FMS_QUOTE_UNITS`, `_EMPLOYEES`, `_RESOURCES`, and the `FMS_JOB_*` equivalents) | table list | Yes: [fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md) |
| §3 | `FMS_UNIT_TYPES` mixes real equipment (350 Ton AT, Tractor - Semi) with *Operator Load*, *Support Load 1–4*, *Travel Permit*, *Lift Plan*, *Certified Payroll*, *Mobilization* | row names | Partly: [../assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md) |
| §4 | `FMS_UNIT_TYPE_ESTIMATE` is the billing template per unit type × job type. 350 Ton AT / Hourly = 350 Ton, Operator Load, Support Load × 4, Travel Permit 75 T+, Fuel & Insurance Surcharge | rows | Yes, as the template structure; this line list is new |
| §5 | **Template rates are stale, and quotes do not use them.** 350 Ton: template $675 vs billing-code default $790. Operator Load $500 vs $880. Support Load $125 vs $177.50. Surcharge 6.5 vs 15.0. Quote OM-40439 and job OM60788 both used the billing-code rates | one quote, one job | **New.** The ERP seeder does not carry the template rate into any priced field: it uses the rows only to link a billing code to a sub-category ([gaps.md](gaps.md) → *FCC estimate templates were already extracted…*) |
| §6 | Price lists are **sparse overrides**. `FMS_BILLING_CODES_PRICE_LIST` has 304 rows. `FMS_UNIT_PRICE_LIST`, `FMS_PRICING_MATRIX(_DETAILS)`, `FMS_BILLING_CODE_YARDS` and `FMS_BILLING_YARDS` have 0. The rule: the price-list rate if the code is on the list, else the billing-code default. Lists include PREFERRED, PREMIER, SHARED CRANE, SO CAL EDISON, PAR, POLE CONTRACTOR, VULCAN MATERIAL | row counts | The rule matches TCG's *Price Lists Process* doc ([fcc-estimate-templates-by-job-type.md](fcc-estimate-templates-by-job-type.md)). The counts are new |
| §7 | Historical quote lines: OriginalRate = price list with no later change **11,284**; price list then changed **458**; global default unchanged **34**; global default then changed **2**. 350 Ton: default $790, PREFERRED $750, PREMIER $702.50, SHARED CRANE $675. OriginalRate is the resolved rate; Rate is the final, editable one | aggregate query, compared with *current* price lists (the PDF itself says this makes "OTHER" cases unreliable) | New |
| §9 | Of 133,000+ job-detail rows, 107,000+ keep a `UnitTypeEstID`, and 103,000+ still match a template row. Some matched IDs now mean something else. Job OM30033: ID 82 = *Counter Weight Truck* then, *Operator Load* now | counts and one example | New |
| §10 | `FMS_UNIT_TYPE_EQUIPMENT`: 350 Ton / Hourly = 5 × Tractor - Semi, Operator Load, Support Load 1–4. 350 Ton / Hourly w/ Mob = **6** tractors, same loads. Job-type codes **H = Hourly, Z = Hourly w/ Mob** | rows | Recipe structure yes; **the H / Z codes are new** |
| §11 | Quote OM-40439's Unit/People copied that recipe (11 lines), **every `UnitCode` NULL**, 0 quote resource rows, 0 quote employee rows: type-level placeholders only | one quote | New |
| §12 | Job OM60788: crane 35001, tractors AT29, AT13, 306149, AT18, AT14. The load rows stay placeholders. Employees: Operator, Oiler, Operator, 3rd Man × 4. `FMS_JOB_RESOURCES` pairs units with employees | one job | New |
| §17 | OM60788 also ran **40 Ton unit 4003 with an operator and no 40 Ton billing line** (job description *"350 Ton + Jib + 40 Ton + RCS"*) | one job | New: an operational-only resource |
| §19 | Unit **36001** is linked to both *360 Ton All Terrain Crane* (PrimaryType = 1) and *360 Ton All Terrain w/Luffer* (PrimaryType = 0) | rows | Consistent with the primary/secondary type model in [../assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md) §5 |
| §21 | *Hourly w/ Mob* templates have Mobilization / Demobilization parent rows whose children are crane, loads, crew time, OT, DT, permit, price adjustment | rows | Yes: `ParentEstimateID` in the template doc and the seeder entry |
| §34 | FCC's 350 configuration has **no useful personnel-template rows**, even though the job ran an Operator, an Oiler and 3rd Men | stated | New |

## What it recommends (§1, §8–§9, §13–§35)

- **Split FCC's Unit Type into separate objects:**
  - *Asset Type*, *Asset*, *Asset Configuration*;
  - *Service Profile* (what Sales picks) and *Service Profile Variant* (Hourly, Hourly w/ Mob,
    Bare);
  - *Billing Code*, *Billing Bundle Template* (which codes a profile populates), *Price List* /
    *Price List Rate*;
  - *Quote Line* (frozen) and *Quote Line Group* (the mob/demob roll-up);
  - *Dispatch Requirement Template*, *Dispatch Requirement*, *Personnel Requirement*;
  - *Asset / Employee Assignment*.

  Table names are left to CodingCops (§25).
- **Pricing precedence (§8):** billing code → customer price list rate if present, else the
  code's default → optional authorised Sales override → final rate, frozen on the quote and
  carried to the job. Each line keeps `ResolvedBaseRate`, `RateSourceType`
  (DEFAULT / PRICE_LIST / MANUAL_OVERRIDE / CONTRACT / OTHER), `RateSourceID`, `FinalRate`,
  `ResolvedAt` and `ResolvedBy`.
- **Profile templates hold no authoritative rate (§5).** A profile-specific rate, if supported,
  is an explicit override with documented precedence.
- **Snapshots (§9):** an accepted quote or job must not depend on today's template. Each line
  snapshots the code, description, quantity, UOM, resolved and final rate, rate source,
  parent/roll-up link and profile/template version.
- **Billing code ≠ resource (§14–§17).** One code yields 0..n requirements. Surcharges, price
  adjustments, OT/DT and travel permits yield none; a travel permit may start a permit workflow.
  Operations may need resources with no billing code at all.
- **Where requirements come from (§18):** a billing-code rule (Operator Load → its logistics), a
  service-profile rule (the 350 package), a profile variant (mob → an extra tractor), a manual
  operations add (a 40 Ton assist crane), safety/compliance, or a customer-specific requirement.
- **Configurations (§19, §31):** one asset record with supported configurations (Standard,
  Luffer). A profile requires *type + configuration*. No duplicate asset for *w/Luffer*.
- **Service Profile ≠ Asset Type (§20):** often one-to-one, but separate records, to allow bare
  rental, operated-and-maintained, a premium package and the like.
- **Mob/demob (§21–§22, §33):** real parent/child quote lines, each with `CustomerVisible` /
  `IncludedInParentTotal`. The children stay available for audit, cost analysis, dispatch and
  billing reconciliation.
- **Line behaviours (§23):** DEFAULT / OPTIONAL / MANUAL / CONDITIONAL. Crew OT/DT and traffic
  control on the mob example were manual, which matches what Joe said at 26:03.
- **Acceptance scenarios (§28–§33):**
  - 350 Ton / Hourly bundle;
  - PREFERRED $750 then overridden to $775, which must survive a later price-list change;
  - Operator Load $880 with requirements but no extra codes;
  - 360 w/Luffer on asset 36001;
  - 40 Ton assist crane with no billing code;
  - Mob/demob roll-up.
- **Its own open list (§34):**
  - how FCC picks a price list (customer vs location vs other);
  - which requirements come from billing codes and which from profiles;
  - personnel templates;
  - who may override rates, and with what approval;
  - what happens when codes or the profile change after the job exists;
  - substitution rules;
  - when an operational resource becomes a new charge;
  - mob/demob child edit rules.

## Where it lands against the record

| Open question | What this document adds |
| --- | --- |
| [gaps.md](gaps.md) → *Quote line items vs dispatch resources*, (a) where the dispatch requirement lives | A recommendation for **both**: billing-code rules and profile rules, plus manual adds. Still Joe's to confirm |
| same entry, (c) how one drop-down reaches non-machine lines | Not answered directly. The Service Profile / Bundle split implies non-machine lines sit in bundles or are added manually (§23) |
| [../assets/gaps.md](../assets/gaps.md) → *One asset, one type…*, (b) where the many-to-one lives | FCC evidence (36001) and a recommendation: asset plus supported configurations |
| [../dispatch/gaps.md](../dispatch/gaps.md) → *Requested vs dispatched resources* | An operational-only resource with no billing line (4003 on OM60788), which Dispatch must be able to add |
| [gaps.md](gaps.md) → *Should editing a quotation adopt the customer's current price list?* | A recommendation that the resolved rate and its source are frozen, and that a later price-list change must not alter a historical quote. This bears on the edit path, but it is not a ruling on it |
| [gaps.md](gaps.md) → *Estimate defaults per resource type / job type / yard* | Job-type codes **H** and **Z**. It says nothing on `OptionFlag_Raw = 'M'` (that entry's (i)), which is still open |

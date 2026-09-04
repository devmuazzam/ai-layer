---
title: Sales intake and job walk — the one-page call sheet, the site survey and their vocabularies
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Intake_JobWalk_DATABASE_v13_HTC3140SB_ADDED (4).xlsx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/customers, module/assets, module/projects-jobs, kind/source, reference-data, lift-plans, permits, safety, requirements]
entities: []
---

# Sales intake and job walk — the one-page call sheet, the site survey and their vocabularies

**What this is.** A large working workbook Ryan Adams built (with ChatGPT, per its own Build
Tracker) that holds **two structured forms and their dropdown vocabularies**, bolted onto a
half-finished crane load-chart database. Its Sources sheet names the provenance: *"Sales
Coordinator questionnaire uploaded by Ryan"* for the intake questions, *"Ryan permit city
turnaround list"* for the city dropdown, *"Ryan full crane fleet list"* for the crane dropdowns,
and *"Best-practice crane job walk structure"* for the survey.

**Why it matters.** The vault's quotation flow says *"Decide whether a Job Walk is required"* and
*"Record site notes, photos, lift requirements, measurements, access restrictions, and safety
observations"* ([quotation-flow-process.md](quotation-flow-process.md), steps 4 and 5) without
ever listing a field. **This is the field list — 94 intake questions and 64 job-walk items, each
with a required flag, an owner and a named dropdown.** It is also the only place in the vault
where those dropdowns' allowed values are written down.

> **Two halves, very different maturity.** The forms are complete and in use. The **crane
> recommendation engine behind them is not built**: its Build Tracker marks phase 4 *"Pending
> Ryan review"* and phase 5 *"Not Started — Will not connect until validation is approved"*, and
> two of six engine rules are marked *"Future engine rule"*. Do not treat the automatic crane
> recommendation as a described behaviour.

---

## 1. The One Page Intake — 94 questions in 15 sections

Sheet `One Page Intake`. Header: *"THE CRANE GUYS - SALES COORDINATOR CRANE JOB INTAKE - ONE PAGE
CALL SHEET… All original questions are kept in one page. Dropdowns are used where possible.
**Crane selection now includes full fleet and backup crane options.**"*

Columns per row: `# | Section | Original Question / Prompt | Answer / Selection | **Required** |
Dropdown / Entry Type | Automatic Flags / Notes`.

| § | Section | Rows | Questions asked (abbreviated where the wording repeats) |
| --- | --- | ---: | --- |
| 1 | **Customer & Job Basics** | 1–12 | Company name · **Permit city / jurisdiction** · **Permit turnaround time** (`Formula`, derived) · Contact name · Phone · Email · **Job site address — exact location plus ZIP** · Contact — quoting to · Contact — on site · New or existing account · Industry · Project name |
| 2 | **Scope of Work** | 13–16 | What exactly are you lifting · How many picks total · Single lift or multiple over time · Setting on grade, roof, structure, or into tight space |
| 2A | **Crane Selection / Dispatch Flexibility** | 17–35 | Recommended/primary crane · **Alternative crane #1, #2, #3 if the recommended crane is already dispatched** · Reason recommended crane was selected · Reason alternates will work · **Minimum crane capacity required in tons** · Preferred crane · **Smallest crane that will work** · **Largest crane that will fit** · Customer requested crane? · Customer requested a specific crane number? · **Can crane be substituted?** · **Dispatcher may upsize without approval?** · **Dispatcher may downsize if charts allow?** · Counterweight required · Jib required · Luffer required · Fly required |
| 3 | **Load Details** | 36–41 | **Exact weight — "not estimated - verified?"** · **Weight verification source** · Does that include rigging, spreader bars, attachments · Dimensions L×W×H · Pick points / lifting lugs · Fragile, wind-sensitive, or awkward |
| 4 | **Geometry** | 42–46 | Setup distance structure→crane centre pin · Lift height (final set elevation) · Lift depth (obstruction edge→set point) · Picking over or around anything · Drawing available |
| 5 | **Site Conditions** | 47–54 | Ground conditions · Outrigger pads or crane mats for ground bearing pressure · Site access width · Site slope · Tight turns · Trailer access · Multiple setup locations · Private or public property |
| 6 | **Hazards & Obstructions** | 55–59 | Overhead power lines + distance · Buildings, canopies, trees, signage · **Load travelling over people or occupied areas** · Airspace restrictions · Underground hazards/utilities marked |
| 7 | **Environment & Conditions** | 60–62 | Weather constraints — wind limits, rain, heat · Night work · Noise or neighbourhood restrictions |
| 8 | **Rigging & Equipment Needs** | 63–66 | Rigging provided by whom · Slings, shackles, spreader bar, lifting beam · Special attachments · **Engineered rigging required** |
| 9 | **Personnel & Responsibilities** | 67–69 | Rigger · Signal person · Are all personnel certified |
| 10 | **Schedule & Logistics** | 70–76 | Date of lift · Time window start/end · Duration · Schedule constraints or shutdowns · Standby · **Multiple mobilizations** · Night/weekend premium |
| 11 | **Permits, Logistics & Compliance** | 77–79 | Do permits need to be pulled · Street closures or traffic control · Insurance requirements |
| 12 | **Critical Lift Screening** | 80–83 | **"Does the lift require a certain capacity of the crane? example 75% or less"** · Multiple cranes involved · **Lifting personnel** · Complex rigging or unusual load |
| 13 | **Documentation** | 84–87 | Photos of jobsite · Site drawings · Structural drawings · Load spec sheet |
| 14 | **Commercial Questions** | 88–91 | **Purchase order required** · Billing contact · **Credit terms / new account setup** · **Bid work or time & materials** |
| 15 | **Close the Call Like a Pro** | 92–94 | *"Based on what you told me, we are looking at summary"* · *"Anything unusual I should know?"* · *"I will size the crane and get you a quote by ____"* |

**Two derived fields.** `Permit turnaround time` is marked `Formula` and driven from the permit
city (the Sources sheet says *"Used in Lookup A:B and Intake D7 formula"*). A second automatic
flag, **`Job Walk Needed?`**, is annotated *"Review based on missing info / job complexity"* —
so the trigger is stated as a judgement, **not as a rule the sheet computes**.

**What this adds to the vault's picture of a quote.** Sections 2A, 12 and 14 have no counterpart
anywhere:

- **Dispatch substitution latitude is captured at intake** — three named alternates, smallest/
  largest bounds, and explicit permission flags for the dispatcher to upsize or downsize. That is
  a *quote-time* answer to a *dispatch-time* problem, and the 2026-05-05 meeting's note that
  *"Sales can view Dispatch but not edit"* ([erp-review-log.md](../erp-review-log.md)) makes it
  more load-bearing, not less.
- **Critical-lift screening happens on the call**, with a percent-of-capacity threshold, a
  multiple-crane flag and a personnel-lifting flag.
- **Commercial terms are asked at intake**, not after award: PO required, credit terms, bid vs
  T&M.

## 2. The Job Walk Sheet — 19 crane-selection confirmations + 45 survey items + 22 dispatch adders

Sheet `Job Walk Sheet`: *"Use this tab when a job walk is needed. **It pulls key intake answers**
and captures detailed technical information needed to quote, dispatch, permit, and execute
safely."*

The sheet is in three blocks.

**Block A — Crane Selection, confirmed during the job walk (CS-1 … CS-19).** The same 19 crane
questions from intake section 2A, now with `Intake Answer` beside `Field Verified Answer`, a
Priority (High/Medium) and an owner (*Sales / Estimator*). Each row states a **Quote Impact /
Action**, e.g. CS-1 *"Confirm chart, radius, boom length, counterweight, setup"*; CS-7 *"Enter
calculated minimum requirement"*; CS-13 *"**Controls dispatch flexibility**"*.

**Block B — 45 survey items in 9 sections**, columns `# | Section | Job Walk Question / Data
Needed | Intake Answer | Field Verified Answer | Dropdown | Measurements / Notes | **Photo
Needed?** | Owner | Quote Impact / Action`. Owner is *Sales / Walker* throughout; Photo Needed is
`Required` on nearly all of them.

| § | Section | Items | Notable content |
| --- | --- | ---: | --- |
| 1 | Walk Basics | 1–5 | **GPS pin / address verified** · is the lift location the same as the jobsite address · best setup location · alternate setup locations · private / public / both |
| 2 | Load Verification | 6–12 | Description · **weight verified from tag, spec sheet, drawing or manufacturer** — *"**No crane sizing without verified weight**"* · does weight include rigging, spreader bars, attachments, **fluids, packaging** · dimensions · **centre of gravity known/marked** · **pick points verified and rated** — *"May require engineered rigging"* · fragile/wind-sensitive/top-heavy/awkward |
| 3 | Lift Geometry | 13–20 | **Measure centre pin → pick point radius** · **centre pin → set point radius** · obstruction edge → set point depth · final set elevation · **maximum obstruction height on pick path** · **swing path clear for counterweight / tail swing** · picking over or around anything · drawing or sketch made |
| 4 | Ground / Setup | 21–25 | Ground condition at setup · **outrigger setup area dimensions measured** · pads or mats · **underground utilities or vaults under the setup area** · **ground bearing pressure requirement provided** |
| 5 | Access / Mobilization | 26–29 | **Road width, gate width and turn radius** · trailer / counterweight truck access · **low wires, trees, bridges, signs on route** · staging area for trucks and counterweights |
| 6 | Hazards | 30–33 | **Overhead powerline distance verified** — *"OSHA clearance / utility coordination"* · occupied building, people, public path, traffic or critical equipment under load path · **airspace / airport / heliport** — *"FAA/NOTAM"* · railroad, utility or agency coordination |
| 7 | Rigging / Crew | 34–38 | Rigging supplied by whom · rigging gear required · spreader bar / lifting beam / engineered rigging · riggers required · **signal person / lift director responsibility confirmed** |
| 8 | Permits / Traffic | 39–42 | Permit jurisdiction confirmed · street/lane closure, flagging, police, pedestrian control · **permit lead time matches requested schedule** · FAA permit or NOTAM required |
| 9 | Commercial / Quote | 43–45 | **Quote assumptions captured clearly** — *"Protect against change orders"* · any missing data preventing quote · **quote readiness after job walk** |

**Block C — Dispatch Notes / Operational Adders**, a 22-row checklist with `Item | Status | Owner
| Notes | Quote / Dispatch Impact`:

`Escort Required` · `Permit Ordered` · `Permit Approved` · `Route Verified` · `Counterweight
Truck Required` · `Dolly Required` · `Jeep Required` · `Booster Required` · `Crane Mats
Required` · `Outrigger Pads Required` · `Pole Permit Required` · `Railroad Coordination` ·
`Utility Coordination` · `Street Sweeper Required` · `Flaggers Required` · `Police Escort
Required` · `Pilot Cars Required` · `Night Delivery Required` · `Weekend Delivery Required` ·
`Fuel Truck Required` · `Mechanic Standby` · `Spare Parts Needed`

**Every one of those 22 is a billable or schedulable item, and most map to something already in
the vault** — pilot cars, escorts, permits and support vehicles all carry published rates on the
quote ([quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §3), and mats, dollies,
jeeps and boosters are transport configuration. This list is the closest thing the drop has to a
checklist of what must be *added to a quote* after a job walk. The Operating System Architecture
makes the same point as a rule: *"NO THIRD PARTY WITHOUT DOCUMENTED COST AND AUTHORIZATION"*.

## 3. The dropdown vocabularies

Sheet `Lookup` carries 40 named lists. These are the closed vocabularies both forms validate
against — reference data the ERP would need. Transcribed in full except the city list.

| List | Values |
| --- | --- |
| `CustomerType` | New Customer · Existing Account · Existing Customer - New Job · National Account · Bid Invitation · Emergency Customer · One-Time Customer |
| `Industry` | General Contractor · Electrical Utility · Transmission · Distribution · Civil · Bridge · Structural Steel · Mechanical / HVAC · Industrial · Manufacturing · Renewable Energy / Solar · Telecommunications · Government / Public Works · School District · Commercial · Residential · Other |
| `LoadType` | HVAC Unit / RTU · Steel Beam · Structural Steel · Generator · Transformer · Pole · Truss · Tank · Precast Panel · Tilt Panel · Shipping Container · Glass · Cooling Tower · Chiller · Mechanical Equipment · Electrical Equipment · Tower Crane Component · Machinery · Other |
| `PickCount` | 1 · 2-5 · 6-10 · 11-25 · 26-50 · 50+ · Unknown |
| `LiftFrequency` | Single lift · Multiple lifts same day · Multiple lifts over time · All-day crane · Multi-day crane · Weekly rental · Monthly rental · Unknown |
| `Placement` | On grade · Roof · Structure · Basement / below grade · Shaft · Inside building · Over building · Utility pole · Transmission tower · Bridge · Tight alley · Confined area · Unknown |
| `WeightVerified` | Verified exact weight · Customer estimate · Manufacturer specs · Drawing / submittal · Tag / nameplate · Unknown |
| `YesNoUnknown` | Yes · No · Unknown · N/A |
| `LoadSensitivity` | No special concern · Fragile · Wind-sensitive · Awkward shape · Top-heavy · Long load · Glass / breakable · High value equipment · Unknown |
| `Ground` | Concrete · Asphalt · Compacted aggregate · Dirt · Gravel · Sand · Soft soil · Structural deck · Bridge deck · Existing crane pad · Unknown |
| `Mats` | No · Yes - outrigger pads · Yes - crane mats · Engineering review required · Unknown |
| `Access` | Wide / open access · Standard street access · Narrow access · Alley access · Driveway access · Trailer access concern · Requires site check · Unknown |
| `Slope` | Flat · Slight slope · Moderate slope · Steep slope · Unknown |
| `Traffic` | None · Flaggers · Lane closure · Full street closure · CHP / police · Pedestrian control · Unknown |
| `PropertyType` | Private property · Public street · Public right-of-way · City property · County property · State property · Both private and public · Unknown |
| `JW_FieldStatus` | Confirmed on site · Customer stated only · Needs measurement · Needs documentation · Not verified · N/A |
| `JW_Setup` | Single setup · Multiple setups · Pick and carry not allowed/verify · Setup constrained · Alternate setup available · No safe setup identified · Unknown |
| `PowerLines` | None · Under 10 ft · 10-20 ft · 20-50 ft · Over 50 ft · Unknown |
| `Airspace` | None · FAA review likely · NOTAM likely · Near airport · Hospital heliport · Military airspace · Unknown |
| `RiggingProvider` | Customer provides rigging · The Crane Guys provides rigging · Third-party rigging · Unknown |
| `RiggingGear` | Nylon slings · Wire rope slings · Chain slings · Shackles · Spreader bar · Lifting beam · Plate clamps · Vacuum lift · Custom rigging · Unknown |
| `RiggerCount` | Customer provides · None needed · 1 rigger · 2 riggers · 3+ riggers · Unknown |
| `Duration` | 1 hour · 2-3 hours · Half day · Full day · 2 days · 3 days · 1 week · Multi-week · Monthly · Unknown |
| `Permit` | No · Yes - city permit · Yes - county permit · Yes - state permit · Yes - utility permit · Unknown |
| `Insurance` | Standard COI · Additional insured required · Waiver of subrogation · Primary/non-contributory · Project-specific endorsement · Unknown |
| `BidType` | Bid work · Time & materials · Lump sum · Daily rate · Weekly rate · Monthly rate · Project pricing · Unknown |
| `CreditTerms` | COD · Credit app required · Existing account · Net 15 · Net 30 · Net 45 · Net 60 · Unknown |
| `CapacityLimit` | No special capacity limit · 75% or less required · 80% or less required · Customer-specified limit · Unknown |
| `CraneSub` | Yes - substitution allowed · No - exact crane required · Allowed if charts confirm · Ask salesperson first · Unknown |
| `Counterweight` | Standard counterweight · Heavy counterweight · Full counterweight · Reduced counterweight · No counterweight / boom truck |
| `JibFly` | No · Jib required · Fly required · Luffer required · Jib or fly possible |
| `DispatcherApproval` | Yes · No · Only if charts allow · Only with salesperson approval · Unknown |
| `DocStatus` | Received · Customer will send · Requested · Not available · N/A |
| `PhotoReq` | Required · Recommended · Taken on job walk · Customer to provide · N/A |
| `Readiness` | Ready to quote · Quote with assumptions · Needs customer info · Needs engineering · Needs job walk · Not ready |
| `DispatchItem` | Not required · Required · Ordered · Approved · Customer responsibility · The Crane Guys responsibility · Unknown |
| `CraneSize` | 22 Ton Boom Truck · 40 Ton · 65 Ton RT · 90 Ton RT · 90 Ton · 100 Ton · 110 Ton · 140 Ton · 140 Ton 5 Axle · 190 Ton · 200 Ton · 265 Ton · 275 Ton · 350 Ton · 350 Ton with Luffer · 360 Ton · 550 Ton · 550 Ton with Luffer · 660 Ton Crawler Crane |
| `City` + `Permit Turnaround` | **98 Southern California cities**, each with a stated turnaround — see §4 |

Three of these deserve to be read as requirements rather than as dropdown content:

- **`CreditTerms` on the intake sheet already offers Net 15/30/45/60**, which is at odds with the
  Welcome Letter's *"first-time customers COD with 50% deposit, then net 15"*
  ([new-customer-onboarding.md](new-customer-onboarding.md)). The New Customer Playbook resolves
  this deliberately — Tier 1 customers may skip the deposit — but **the packet and the playbook
  state different defaults**, which the Operating System Architecture itself flags as unfinished
  governance.
- **`Readiness` is a six-state quote-readiness enum** (`Ready to quote` → `Not ready`), which is
  a quote *pre*-status the ERP has no counterpart for. FCC's `QuoteStatusCode` starts at `PEND`.
- **`CraneSize` is a 19-value fleet list by capacity, not by asset**, and it is what both forms
  and dispatch substitution work in. `assets/` holds the asset register; this is the
  *sales-facing* naming of the same fleet.

## 4. The permit city turnaround list

`Lookup` columns A:B pair **98 cities** with a stated permit turnaround, and the intake sheet
derives `Permit turnaround time` from it by formula. Values range from **24 hours** (Brea, Los
Alamitos, Ontario) through 48 hours / 2–3 days / 3–5 days / 4 days / 5 days to **10 days**
(Culver City, Fullerton, Glendale, La Verne, Manhattan Beach). Many carry a qualifier —
*"(some annuals)"*, *"(annuals)"* — and several city names are suffixed `(LIC)` or `(Lic)`.

**The list is not transcribed here.** The same list is the whole content of `City Permit Turn
Around Time.xlsx` elsewhere in this drop, and a near-identical copy (with different spellings and
typos) is the `Lists` sheet of `Sales Dispatch Sheet.xlsx` — see
[sales-reporting-workbooks.md](sales-reporting-workbooks.md) §3. **Several copies of the same
reference data exist in this drop and they do not match character-for-character.**
[projects-jobs/city-permits/permit-lead-times.md](../projects-jobs/city-permits/permit-lead-times.md),
written from the same drop, compares three of those datasets and is the place to settle which is
authoritative.

This connects directly to the 2026-05-05 meeting's ask for **map-based job-site permit
intelligence** and *"flag annual permit requirements by city / state / zip, indicating whether an
annual city permit is already in place or required"*
([erp-review-log.md](../erp-review-log.md) → *Job site and permits*). The *"(annuals)"*
annotations in this list are the manual version of exactly that.

## 5. The crane database half — structure only, and unfinished

The remaining ~30 sheets are a load-chart extraction project. **This belongs to assets/lift
planning rather than quotations and is recorded here only because it shares the file.** A parallel
and more developed effort by the same author is written up as
[assets/crane-selection-and-load-chart-model.md](../assets/crane-selection-and-load-chart-model.md)
from `New Updated Crane Chart Sheet.xlsx` — **the two workbooks are separate attempts at the same
thing** and should be compared before either is trusted.

Sheets, grouped: `Fleet Master` / `Fleet_Master` · `Specification Database` /
`Fleet_Specifications` · `Configuration Database` / `Configuration_Database` · `Main Boom Load
Chart Database` / `Fleet_LoadCharts_Main` · `Extension Load Chart Database` /
`Fleet_LoadCharts_Extension` · `Engineering Notes Database` / `Fleet_Notes` · `Source Reference
Database` · `Validation Test Lift` / `Fleet_Validation` · `Manual Extraction Log` · `Engine
Rules` · `Build Tracker` / `Build_Tracker` · `Project_Control` · and per-crane chart views
(`22101S`, `3051T`, `40124SHL`, `LTM1040`, `LTM1100`, `HTC8690`, `RTC8090`, `HTC86100`,
`HTC3140LB`, `HTC3140SB`). **The v13/newer sheets duplicate the earlier ones under
underscore-separated names; both generations are present.**

**Load-chart rows were not copied** — `Fleet_LoadCharts_Main` alone is ~7,000 rows and
`Fleet_LoadCharts_Extension` ~12,800.

Only one crane is fully entered. `Fleet Master` holds a single row:
`TCG-022-MANITEX-22101S` — 22 Ton, Manitex / Manitowoc Boom Trucks, model 22101S, Boom Truck,
rated **44,000 lb / 22 ton**, primary chart basis *"Full outriggers / main boom / LMI Code #1"*,
extension basis *"29.4 ft fixed jib / full outriggers / LMI Code #2"*, max main boom *"101.4 ft
chart / 101 ft 5.3 in specs"*, full outrigger footprint *"237.75 in width ref (19 ft 9-3/4 in)"*.
The `Build Tracker` notes a second extraction: *"HTC-3140 SB added: 330 main boom rows and 3,312
extension/fly rows."*

**The six `Engine Rules`, verbatim, because they are stated screening policy:**

| ID | Rule | Status |
| --- | --- | --- |
| RULE-001 | *"Use actual OEM rated chart capacity. **Do not reduce chart values by another 85%.**"* | **Locked** — *"User confirmed chart ratings are the basis."* |
| RULE-002 | *"Default chart basis is **highest-capacity practical chart: full outriggers + full counterweight + main boom.**"* | **Locked** |
| RULE-003 | *"Store extension chart separately from crane-only chart."* | **Locked** |
| RULE-004 | *"If radius is **between chart rows, use next longer radius** for conservative screening."* | **Future engine rule** |
| RULE-005 | *"If boom length is **between chart columns, use lesser rating** between next shorter and next longer boom lengths."* | **Future engine rule** |
| RULE-006 | *"**If required inputs are missing, do not recommend a crane; request missing data/job walk.**"* | **Future engine rule** — *"Will be implemented after fleet database is complete."* |

RULE-001 is worth flagging: it is an explicit instruction *not* to derate, recorded as
user-confirmed. RULE-006 is the automated form of the `Job Walk Needed?` flag.

The `Validation Test Lift` sheet holds five pass/fail checks against OEM chart page 8 for the
22101S (e.g. *"69 ft boom @ 25 ft radius → 9,460 lb, boom angle 71°"* — Pass), which is the
method by which extracted chart values are meant to be signed off. The `Manual Extraction Log`
records both source PDFs and marks validation **"Pending Ryan review"**.

## 6. The one formula that matters (read 2026-09-04)

Of the workbook's 27 formulas, one carries policy — `One Page Intake!G8`, the **job-walk
recommendation**:

```
=IF(OR(D45="Soft soil", D46="Engineering review required",
       D56="FAA review likely", D56="NOTAM likely",
       D72="Yes", D73="Yes", D74="Yes"),
   "YES - JOB WALK / REVIEW RECOMMENDED",
   "Review based on missing info / job complexity")
```

So a job walk is recommended automatically when the intake records **soft soil**, an
**engineering review**, a likely **FAA review or NOTAM**, or a *Yes* in any of the three
flag rows 72–74. `D7` resolves the customer via `VLOOKUP` into `Lookup!A:B`; the `Job Walk
Sheet` mirrors the intake's job name. The `Validation Test Lift` and `Fleet_Validation` sheets
check the load-chart databases with `SUMIFS` by crane, boom length and radius and print
*Pass* / *Review* — the same 85%/exact-chart concern documented in
[../assets/crane-selection-and-load-chart-model.md](../assets/crane-selection-and-load-chart-model.md).

## Source

`3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Intake_JobWalk_DATABASE_v13_HTC3140SB_ADDED (4).xlsx`
— 2.6 MB, **38 sheets**, per-sheet row dump. The two form sheets, the Lookup vocabularies, the
Sources, Build Tracker, Fleet Master, Engine Rules, Validation and Manual Extraction Log sheets
are transcribed or summarised above. **All load-chart, specification and configuration row data
was deliberately not copied** (~21,000 rows across five sheets); so was the 98-row city list, for
the duplication reason in §4.

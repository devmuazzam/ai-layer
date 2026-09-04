---
title: The incident investigation report — TCG's post-incident form
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/Incident Investigation Rpt Form.docx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/payroll, kind/source, safety, compliance, reporting, notifications, signatures]
entities: []
---

# The incident investigation report

**What this is.** TCG's blank **Incident Investigation Report** — a multi-page form with a case
number, OSHA-style classification, four code lists, a causal analysis and a corrective-action
register. Undated in the file itself; migrated from the general forms folder.

**Why it matters.** It is the **only document in the vault that defines what TCG records after
something goes wrong**, and it is the data source for the `TRIR` and `DART` metrics the safety
department's platform brief asks for ([01](01-ideal-single-safety-platform.md) §3). The June 2026
demo build has an in-app incident reporter — four types, three severities, description, photo — which
is a small fraction of this. Neither Field Ops FRD contains an incident requirement at all.

> **A blank form, not a requirement.** Nothing here is adjudicated. It is also **not obviously
> TCG-authored**: it refers to *"Corporate Safety"*, a *"Division Manager"*, a *"Project
> Superintendent"* and a *"Division"*, and its occurrence-location list is dominated by heavy civil
> and construction settings (bridge deck, paving operation, pile driving, geo-grid/liner, mine
> support, trenching) with no crane-specific entry. It reads as a general contractor's form adopted
> as-is. **The drop does not say whether it is in current use.**

---

## 1. The rules printed on the form

> *"**INSTRUCTIONS:** This form should be completed within **24 hours** after occurrence or
> notification and submitted to the **Safety Department** with copies to: **President, Division
> Manager, Project File**."*
>
> *"**All incidents must be investigated.**"*
>
> *"**NOTE:** Shaded area will be completed by **Corporate Safety**."*

Three rules, none of which appears in any requirement document: a **24-hour deadline**, a **fixed
distribution list of four**, and a **section only Corporate Safety may complete** — i.e. the form has
**field-level authorship restrictions**, which is a permissions question if it is ever built.

## 2. Classification — the OSHA grid

A `CASE #` and a 5 × 2 grid, `Injury` and `Illness` columns against:

```
Fatality · Lost Time · Restricted Duty · Recordable · First Aid/Doctor
```

**`Recordable`, `Lost Time` and `Restricted Duty` are precisely the inputs to TRIR and DART.** The
demo's three severities (`First Aid Only` / `Medical Treatment` / `Lost Time`) map onto part of this
grid but do not distinguish injury from illness and have no `Recordable` flag.

## 3. Who and when

| Field group | Fields |
| --- | --- |
| Person | Employee Name · Employee # · Age · Job Title/Classification · Division |
| Job | Project Number/Name · Project Superintendent · General Foreman · Immediate Supervisor/Foreman |
| Time | Date and Time of **Incident** · Date and Time **Reported** |
| Tenure | **Length of Employment** — `<1 week` / `<1 month` / `<6 months` / `>6 months` |
| Experience | **Experience at this Job Title** — same four bands |
| **Fatigue** | **`Consecutive days and hours worked prior to Incident: Days ___ Hours ___`** |
| Other | Witnesses? Y/N (*"If Yes, Attach Supplemental Witness Statement"*) · Occurred on premises? Y/N/Unknown · Work Related? Y/N/Unknown |

Two of these connect straight to other modules. **`Consecutive days and hours worked prior to
Incident`** is a fatigue field answerable only from the labor record — the same territory as the
demo's *"8-Hour Rest Verification"* double-time rule. And **`Date and Time of Incident` vs
`Date and Time Reported`** are captured separately, which is the reporting-lag measure behind the
24-hour rule.

## 4. Four coded lists, each "check only one"

**`TYPE OF INCIDENT`** (21 values):

```
Caught in, on, between · Fall on same level · Fall on different level · Fighting
Insect bite/sting · Slip (not a fall) · Overexertion · Struck against object
Struck by flying object · Struck by moving object · Trip
Exposure - Chemical · Exposure - Temperature Extreme · Contact - Electrical Current
Property Damage · Equipment Damage · Environmental Incident · General Liability
Motor Vehicles · Near-Miss (no injury or damage) · Other (specify)
```

**`BODY PART`** — around 60 values, left/right split where anatomy allows (ears, eyes, hips, knees,
lower/upper arms and legs, feet, ankles, wrists, elbows, hands, shoulders, lungs), plus internal
organs (heart, kidneys, liver), `Multiple Body`, `Other (specify)` and `None`.

**`ACTIVITY`** (17):

```
Lifting · Pushing/Pulling · Carrying · Walking · Standing · Sitting · Climbing · Pouring · Bending
Opening Container/Vessel · Welding · Equipment Op. (specify) · Vehicle Operation (specify)
Using Hand Tools (specify) · Using Power Tools (specify) · Equipment Maint./Repair · Other (specify)
```

**`OCCURRANCE LOCATION`** (27) — the block that most clearly betrays the form's origin:

```
Home Office · Project Office · Equipment Yard · Public Roads · Project Roads · Welding Shop
Sea-Can · Lay Down Area · Fuel Area · Parking Lot · Bridge Deck · Paving Operation · Break Area
Building Const. · Structural Steel Op. · Equipment Setting · Piping (above/below grade)
Earthwork Operation · Trenching Operation · Clearing/Grubbing Op. · Geo-grid/Liner Operation
Concrete Operation · Decontamination Area · Pile Driving Operation · Concrete Cutting
Mine Support · Other (specify)
```

**`INJURY TYPE`** (17): Death · Amputation · Burn (thermal) · Burn (chemical) · Eye irritation ·
Crushed · Cut/Scrape · Bruise · Puncture/Sting · Fracture · Sprain/Strain · Body System ·
Heat Stress · Hernia · Cumulative Trauma · Other · None.

**`OCCUPATIONAL ILLNESSES`** (8): Skin Disease or Disorder · Lung Disease - Dusts ·
Respiratory due to Toxins · Poisoning · Disorders by Physical Agent · Repeated Trauma ·
All Others · None.

**`PPE`** — a two-column grid, **`1 = Required`, `2 = Being Used`**, over: Hardhat · Safety Glasses ·
Respirator · Hearing Protection · Mono-goggles · Face Shield · Chemical Suit · Safety Shoes · Gloves ·
Shin Guards · Chain Saw Chaps · Welding Protection · High Visibility Vest · Other.

> **The PPE grid records the gap between what was required and what was worn**, per item. Every other
> PPE capture in the vault — the JSA forms, the field audit, the demo — records only presence.

## 5. Narrative, cause and corrective action

**`Describe incident`** — *"Describe how the incident occurred. Be as detailed as possible. Include
facts leading to the incident; what the employee was doing at the time... Give specific times, exact
locations, etc. **Attach drawings, diagrams, and photos** which will aid in the description. What,
Where, When, Extent."*

**`Identify possible causes`** — *"Behaviors, conditions, differences, events, personal factors"* —
over two checklists:

| **PERSONAL ACTS** | **PHYSICAL CONDITIONS** |
| --- | --- |
| Working Unsafely · Unauthorized Operations · Altering Safety Devices · Operating at Unsafe Speeds · Use of Improper Equipment · Unsafe Use of Equipment · **Failure to report an incident** · Failure to Use PPE | Inadequate Mechanical Guarding · Defective Equipment · Unsafe Design/Construction · Hazardous Operation/Arrangement · Inadequate Illumination · Inadequate Ventilation · Other |

**`Root causes`** — *"Most possible cause verified through analysis"*, six values:

```
Execution · Knowledge · Mechanical · Procedure · Human Error · Other
```

**Corrective Action register** — a table of `Corrective Action | PPR | Target Date | Completion Date`,
three rows. `PPR` is not expanded on the form.

> This is the **`Corrective Actions`** panel of the safety platform brief — *"Open findings ·
> Responsible party · Due dates · Escalation status"* — as it exists today: three ruled rows on paper,
> with a responsible party, a target and a completion date, and no escalation.

**Sign-off — four signatures:**

```
Investigated By (with Title) · Employee · Supervisor · Safety Representative
```

each with a date. An incident is closed by **four people**, one of whom is the injured employee.

## 6. Open points

Recorded for a human to route; **not** written to any `gaps.md`.

1. **Is this form in current use at TCG?** Its vocabulary is a general contractor's, not a crane
   company's, and it names roles (Corporate Safety, Division Manager) that appear nowhere else in the
   vault.
2. Is incident capture **in scope for the field app**? The demo built a four-field reporter; neither
   FRD has a requirement. If it is, does the app capture the field portion and hand off to a full
   investigation, or all of it?
3. Who may complete the **Corporate Safety** section — and does that imply role-scoped field-level
   permissions on a single record?
4. **Where does the 24-hour clock live**, and what escalates when it expires?
5. Are `Recordable` / `Lost Time` / `Restricted Duty` the intended inputs to **TRIR and DART**, and
   does the ERP compute them?
6. `Consecutive days and hours worked prior to Incident` needs the **labor record**. Is that a
   payroll query, and does it cross the incident/payroll boundary?
7. What is **`PPR`** in the corrective-action table?

## Source

`1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/Incident Investigation Rpt Form.docx` —
144 KB, pandoc gfm. Converts cleanly as HTML tables; every checkbox list survived. One embedded logo
image (`image1.emf`) was not converted. The form is blank — no case, employee or incident data appears
in it.

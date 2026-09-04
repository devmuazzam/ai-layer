---
title: Field audits and the Safety Value programme — how TCG measures and sells safety
source: shared-folder/Project-Repository-2026-09-04/3.6.1_MODULE-SAFETY-COMPLIANCE/Safety FORMS/TCG 2026 Safety Value Assessment Form 05-20-2026_1.pdf and Quarterly Safety Value Report 05-01-2026_2.pdf; 1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/TCG Field Crane Audit Form . rev 9.01.21.pdf
migrated: 2026-09-04
updated: 2026-05-20
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/customers, kind/source, safety, compliance, inspections, reporting, lift-plans, permits, tools-rigging, signatures]
entities: []
---

# Field audits and the Safety Value programme

**What this is.** Three forms that make up TCG's safety measurement loop:

| Form | Dated | Role in the loop |
| --- | --- | --- |
| `TCG Field Crane Audit Form . rev 9.01.21.pdf` | **rev 2021-09-01**, titled *"Field Audit Form - 2023"* | the **long-form observation** — a safety observer's record of one job |
| `TCG 2026 Safety Value Assessment Form 05-20-2026_1.pdf` | **2026-05-20** | the **current short-form audit** — a gate plus a customer-satisfaction interview |
| `Quarterly Safety Value Report 05-01-2026_2.pdf` | **2026-05-01** | the **customer-facing roll-up** — the metrics the audits produce |

**Why it matters.** This is the *"audit forms for safety that attach to the jobs, with pictures, and
the data compiled to track trends"* the client asked for on 2026-05-03
([erp-review-log.md](../../erp-review-log.md) #11) — asked for **two weeks after the report form was
dated and two weeks before the assessment form**. And it is the operational content of the
`Safety & Audits` lane in
[value-engine-field-safety-storage.md](../value-engine-field-safety-storage.md): `Self Audits` /
`Requested Audits` → `Job Site Audit` → **`OFI`** → `Track Audit Trends` → `Monthly Customer
Reporting`, with `OFI` forking to `EE Disciplinary Action` or `Coaching Moment`. Every one of those
labels is a field on one of these three forms.

> **Blank forms, not requirements.** None is adjudicated. Note also the **cadence conflict**: the
> value engine says *Monthly* Customer Reporting; the report form is titled *Quarterly*. Nothing
> resolves it.

---

## 1. The Field Crane Audit Form — the long-form observation

Headed *"The Crane Guys – Field Audit Form - 2023"* despite a `rev 9.01.21` filename.

**Page 1 — the conditions record.** `Date` · `Job #` · `Address` · `City` · `Observer Name` ·
`Time AM/PM` · `Customer - Contractor(s)` · `Operator Name` · `Oiler Name` · `Crane Unit #` ·
`Crane Make` · `Capacity`, then a structured site description:

| Field | Values |
| --- | --- |
| Where is it set up? | free text |
| Any Slope? | Yes/No + **`Size of slope?`** |
| Ground Conditions? | Good/Bad + Street · Dirt · Sidewalk · Gravel · Grass · **Soil: loose / solid** |
| Trailer on site? | Yes/No + **`Where was trailer parked?`** |
| Weather | Good/Bad + Bright · Dry · Hot · Cloudy · Wet · Cold; **`Windy Yes/No (wind speed?)`**; **`Average Temperature °F or °C`** |
| Overhead Powerlines | Yes/No + Trees · Buildings · **close to Airport (FAA flag)** |
| Neighborhood conditions | Commercial · Residential · People · Animals · Traffic |
| **Crane Arrival time** | **Early / On-time / Late + `Reasons:`** |

and an **`At the time of Pick`** block of six measurements:

```
Boom Length · Boom angle · Weight of Load
Boom Tip Height · Load Radius · Counterweight (in pounds)
```

> These six are **as-executed lift values recorded by an observer**, distinct from the planned values
> on the on-site scope of work and from the `Lift Information` printed on the e-ticket. Nothing in
> the vault reconciles planned, ticketed and observed lift figures.
>
> **`Crane Arrival time: Early / On-time / Late + Reasons`** is a punctuality measure captured on a
> safety form. The Safety Value Assessment asks the customer the same thing (*"Was the crew on
> time?"*), and the demo's home screen shows no such concept.

**Page 2 — a `Yes/No` audit grid** with a `Comments/Photos` column per row, roughly thirty rows:

```
Pre-Trip Inspection before leaving Yard
Traffic Control — who was responsible for setting it up · Pedestrian Traffic Control
Permit: City, other · Cones needed · Wheel chocks · Spill Kits · Critical Lift Plans
Chain up for Outriggers and rear swing
JSA – On Operators Tablet — Hazards, any issues or concerns
Lift Plan — working off front, side, back, corner
Set-up: Outrigger pads, wood, or plates?
  + Crane Level?  + LMI working?  + Jib in use (angle 2, 15, 45), Jib Length half/full
  + Load Weight / Counterweight Amount  + Fall Zone identified and communicated?
  + Were people "kept out" from under the load swing?
Pre-Pick Conference / Tailboard
Customer: Friendly, cooperative, Hurried, Pressure to go faster?
Customer Tailboard: we attended? Participated? Did we sign it?
Radios used? Were directions given
Rigging: TCG's or Customer?
  + Tag line used?  + What kind of rigging (synthetic sling, wire rope, chain)?
  + Our Rigging or the Customers?  + Who inspected the sling, wire rope or chain prior to use?
  + Was the inspection documented?  + Capable to support the Load Weight?  + List of Rigging used
Fire Extinguisher: charged and within expiry?  ·  First Aid Kit: stocked appropriately?
Crew is CPR / First Aid Certified? (at least two)
PPE: Head, Hand, Feet, Eye, High visible clothing?
Buildings under the crane and load have been evacuated?
```

ending with **`Total Score: ____`** and `Notes`.

Four rows are worth pulling out:

- **`JSA – On Operators Tablet`** — as of this form the JSA was already expected to be *on a tablet*,
  which is the FCC/Atom e-ticket job checklist.
- **The rigging sub-block asks who inspected the rigging and whether the inspection was
  documented** — i.e. it audits against the sling inspection sheet in
  [field-paper-forms.md](../field-paper-forms.md) §5, and asks for a **list of rigging used**, per
  job.
- **`Customer Tailboard: we attended? Participated? Did we sign it?`** — TCG crews sign the
  *customer's* safety paperwork as well as their own. No requirement models an inbound customer
  document the crew must acknowledge.
- **`Crew is CPR / First Aid Certified? (at least two)`** — a **crew-composition rule**: at least two
  certified people on site. That is a dispatch constraint expressed on a safety form, and it appears
  nowhere in dispatch's own material.

## 2. The Safety Value Assessment — the current short-form

Dated 2026-05-20, and the form the value engine's `Job Site Audit` box now points at.

**The audit strip**, identical to the one heading the 2026-06-09 JSA
([02](02-jsa-and-lift-planning-forms.md)):

```
Safety Crew Auditor Name ______   Start Time ______
☐ Full Counterweights  ☐ Management Approval for Less Counterweight ☐Yes ☐No
☐ TCG Approved Outrigger Mats  ☐ Completed Paperwork  ☐ Chalks  ☐ PPE  ☐ Meets Crane Guys Standards
☐ Pictures - All Sides of Crane (4)  ☐ Pictures - Completed Paper Work  ☐ Video - 360° Walk Around
                    ( For The Crane Guys Internal Audit Use Only )
```

> **The evidence requirement is explicit and countable: four crane photographs, a photograph of the
> completed paperwork, and a 360° walk-around video.** That is the *"with pictures"* in the client's
> 2026-05-03 request, specified. The demo captures named condition photos per unit on the pre-trip;
> nothing in the vault captures a walk-around video.

**The job block:** `Job Site Address` · `Job Number` · `Date` · `Description of Job` ·
**`THE CRANE GUYS EQUIPMENT ONSITE (Example: 36001, AT12)`** — fifteen blanks, so the audit records
**unit codes** and can be joined to units · **`Opportunity for Improvement`** ·
**`Coaching Moment Name`** and **`Topic`** · **`THE CRANE GUYS ROLES AND RESPONSIBILITIES (Example:
Wes Staley, Management)`** — fifteen blanks.

**The crew block** mirrors the JSA: `TCG Onsite Crew Leader` · `Customer Onsite Crew Leader` ·
`Customer Crew Total` · `TCG Crew Total` · `Total`, a customer-crew list at
*first name + last-name initial minimum*, the same
`All Crew Present to Sign ☐Yes ☐No` with `Manager Confirms Responsibility to Notify Crew` /
`Onsite Crew Leader Refused to Sign`, and two signatures with
*"By signing I certify all information is true and correct to my knowledge."*

**The Crane Guys Standard** is reprinted in full, with the same gate wording as the JSA — see
[02](02-jsa-and-lift-planning-forms.md) §3 — plus one extra duty:
*"Crew Auditor will also be responsible to collect all the information on the Job Safety Analysis /
Job Planning Form."*

### The scoring scale and the customer interview

A single scale governs the whole programme:

```
0-3 Below Standard · 4-7 Meets Standard · 8 Above Standard · 9 Excellence · 10 Creating Value
```

**Questions to Ask the Customer**

- *"How is our crews customer service today on a scale of 0-10?"* → `Score ___/10`
- *"Was the crew on time?"* ☐Yes ☐No
- *"Do you have any safety suggestions for The Crane Guys?"*
- *"Based off of todays job, how can we improve?"*
- *"How is our crews attitude today on a scale of 0-10?"* → `Score ___/10`

**Questions to Ask Our Crew Auditor**

- *"How do you feel our team represented The Crane Guys brand today?"*
- *"How can we improve today?"* · *"What did we do good today?"*
- *"Evaluate the crew moral on a scale of 0-10."* → `Score ___/10`

Closing: `Time Finished` and **`Total Customer Service Score`**.

> **A safety audit that also captures a customer-satisfaction score and a crew-morale score, per
> job.** Three 0–10 scores and a computed total. Nothing in the vault — field-ops, customers or
> reporting — models a per-job customer satisfaction capture. The mission statement printed on both
> forms frames it: *"The Crane Guys mission is to become the best version of yourself and help create
> the best version of The Crane Guys."*

## 3. The Quarterly Safety Value Report — what goes to the customer

A one-page customer-facing report: `Reporting Period` · `Prepared For` · `Prepared By`, and at the
foot `Report By: Name / Title / Date`. Its left column is marketing narrative; its right column is
the numbers, and those are the requirement.

**`Our Safety Program Minimum Standards`** — the Crane Guys Standard again, restated for the
customer:

```
The Crane Guys approved mats · Full counterweights available · Completed paperwork
Chalks – trailer / dolly · Wearing the proper PPE
```

**Operational Performance**

| Metric | |
| --- | --- |
| Total Jobs Performed | count |
| **Safety Audits Conducted** | count |
| **Percentage of Jobs Audited** | % |
| Total Man Hours Worked | count |
| **Jobs Completed Without Incident** | % |

**Safety Performance Snapshot**

| Metric | |
| --- | --- |
| **EMR** | current value |

**Leading Indicators Activity**

| Metric | |
| --- | --- |
| **Opportunity for Improvement Submitted** | count |
| **Tailgate Meetings Held** | count |
| **Stop-Work Authority Exercised** | count |
| **Passed Audits** / **Failed Audits** | counts |

plus **`Opportunity for Improvement Focus for the Quarter`** — three free-text priorities.

> **This is a computed report, and every input is a countable event elsewhere in the system.** Jobs,
> man-hours and incident-free completions come from the job and ticket record; audits, passes,
> failures and OFIs from the assessment form; tailgate meetings from the JSA; and **`Stop-Work
> Authority Exercised`** from — nothing. Stop-work authority is a talking point on the JSA and a
> counted metric here, but **no form in the drop captures the event of it being used**.
>
> **`EMR`** (Experience Modification Rate) is an insurance figure, not a system output.
>
> `Passed Audits` / `Failed Audits` implies the Safety Value Assessment has a **pass/fail outcome**.
> The assessment form itself has no pass/fail box — only the Crane Guys Standard tick and the 0–10
> scores. How an audit is scored pass or fail is not written anywhere in the drop.

## 4. Open points

Recorded for a human to route; **not** written to any `gaps.md`.

1. **Monthly or quarterly** customer safety reporting? The value engine says monthly, the form says
   quarterly.
2. **What makes an audit pass or fail?** The roll-up counts passes and failures; no form defines the
   outcome.
3. Where does **`Stop-Work Authority Exercised`** get captured? It is reported and never recorded.
4. Is the **Field Crane Audit Form (2021/2023) still live**, or fully replaced by the 2026 Safety
   Value Assessment? They are very different instruments — one is a thirty-row observation grid, the
   other a gate plus an interview.
5. Is the **per-job customer satisfaction score** in ERP scope, and if so does it belong to safety,
   to customers, or to reporting?
6. Does the app need to capture **4 photos + paperwork photo + 360° video** as a required evidence
   set on an audit?
7. Is *"at least two crew CPR/First Aid certified"* a **dispatch assignment rule**?

## Source

| File | Format | Note |
| --- | --- | --- |
| `1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/TCG Field Crane Audit Form . rev 9.01.21.pdf` | PDF, 2 pages, `pdftotext -layout` | blank; the `Yes/No` grid's left column reflows as literal `Yes/No` labels |
| `3.6.1_MODULE-SAFETY-COMPLIANCE/Safety FORMS/TCG 2026 Safety Value Assessment Form 05-20-2026_1.pdf` | PDF, 2 pages, `pdftotext -layout` | blank |
| `3.6.1_MODULE-SAFETY-COMPLIANCE/Safety FORMS/Quarterly Safety Value Report 05-01-2026_2.pdf` | PDF, 1 page, `pdftotext -layout` | blank; all metric values are empty underscores in the source |

All three are blank forms. `Wes Staley` appears only as a printed worked example of the roles field,
and is reproduced here as such.

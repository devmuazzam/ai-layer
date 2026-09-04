---
title: JSA and lift planning — three different forms called a JSA
source: shared-folder/Project-Repository-2026-09-04/3.6.1_MODULE-SAFETY-COMPLIANCE/Safety FORMS/TCG 2026 JSA Form 06-09-2026_1.pdf and TCG On-Site Scope of Work (paper version).jpg; 1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/TCG JSA 2026 PDF Final 3.28.26.pdf and TCG_On-site scope of work form.pdf
migrated: 2026-09-04
updated: 2026-06-09
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, kind/source, safety, compliance, lift-plans, permits, signatures, inspections, tools-rigging]
entities: []
---

# JSA and lift planning

**What this is.** Three blank TCG forms that all sit at the same moment in the day — after the crane
is on site and before the lift starts:

| Form | Dated | Shape |
| --- | --- | --- |
| `TCG JSA 2026 PDF Final 3.28.26.pdf` | **2026-03-28** | A 2-page checkbox JSA plus a printed hazard-and-control reference |
| `TCG 2026 JSA Form 06-09-2026_1.pdf` | **2026-06-09** | A 2-page **Job Safety Analysis \| Job Planning** form built around a *Crew Auditor* and the *Crane Guys Standard* |
| `TCG_On-site scope of work form.pdf` | undated | A 1-page **lift capacity calculation** sheet, signed by operator and foreman |

**Why it matters.** `FR-FOP-011 Job Safety Analysis (JSA)` is one requirement in each FRD, and the
demo build implements a topic-plus-hazards screen. **TCG has at least three distinct paper artefacts
here and a fourth in the e-ticket**, and no two agree on what a JSA contains, who signs it, or what
it gates.

> **Blank forms, not requirements.** None of these has been adjudicated. Two carry dates three months
> apart in the same year and **the drop does not say which supersedes which** — or whether both are
> live for different purposes.

---

## 1. The four JSA shapes side by side

| | e-ticket `JSA 12.18.25` | JSA 3.28.26 | JSA/Job Planning 6.9.26 | Demo build |
| --- | --- | --- | --- | --- |
| Where | a **job checklist** inside the e-ticket | paper | paper | app screen |
| Content | **6** grouped items | ~50 checkboxes in 8 blocks + a printed control reference | ~30 pre-lift talking points + roles/responsibilities roster | 6 topics + 9 hazards |
| Hazard list | one item, grouped | `Hazard Check – Check all that Apply`, 11 boxes | folded into the talking points | 9 hazards, each with a mitigation field |
| Crew roster | no | no | **yes** — TCG + subcontractor roles, and a customer crew list | no |
| Signatures | **3** (2 crew + customer) | up to **12** ruled lines | **2** (TCG crew leader + customer crew leader) + crew-leader initials | **none** |
| A gate on starting the lift | no | no | **yes** — the Crane Guys Standard | no |
| Nearest hospital | no | no | **yes** | on the ticket header (demo `TICKET.hospital`) |

Detail on the two paper forms follows.

## 2. `TCG JSA 2026 PDF Final 3.28.26` — the checkbox JSA

**Page 1 — site information and eight checkbox blocks.**

Header: `Date` · `Job Number` · `Job Site Address` · `Equipment Number` · `Operator` · `Oiler`.

| Block | Items |
| --- | --- |
| **Pre Job Check – Required** | Pre-job meeting completed · All crew trained & qualified · Site induction complete · Permits verified (if required) · **Lift plan reviewed (if required)** |
| **Critical Controls** | Exclusion zone established · Tag lines in use · Proper PPE worn · Load path planned & clear · Communication · **Rigging Inspected** · **`Power Line Clearance: ____ ft`** |
| **Lift Execution Check** | Rigging inspected (slings, chains, hooks) · Load secured properly · **No personnel under load** · Controlled lift (no sudden movement) · Weather monitored during lift |
| **Site Conditions** | Ground stable & level · Outrigger pads in place · Weather acceptable (wind/heat) · Adequate lighting · Access/egress clear · Barricades |
| **Communication** | **`Radios (Channel: ____)`** · Hand signals · Signal person assigned · **`Wind Speed Limit: ____ mph`** |
| **Pack Up Check** | Load secured · Equipment stowed · Work area clean · No hazards left behind |
| **Hazard Check – Check all that Apply** | Power line · Suspended loads · Traffic · Poor ground · Weather · Working at heights · Pinch points · Falling objects · Poor visibility · Manual handling · Equipment hazards · Other |
| **PPE** | Hard Hat · High Vis · Gloves · Safety Glasses · Steel Toe Boots · Hearing Protection (if needed) · Harness (if needed) |
| **Emergency Ready** | First Aid Kit Available · Fire Extinguisher · Spill Kit · **AED** · Emergency plan known |

Two of these are **numeric fields, not ticks** — `Power Line Clearance ___ ft` and `Wind Speed Limit
___ mph` — plus a radio `Channel`. Nothing in the FRDs or the demo captures a measured clearance or
a wind limit; the demo shows wind as a **weather-service reading with a 35 mph warning banner**, not
as a limit the crew records.

**Pages 1–2 also carry a printed reference**, not a form: a `General Safety Overview` of hazard
categories with control measures — dropped loads, rigging inspection (tears, cracks, faulty lifting
gear), tailgate meeting, overhead power lines, uneven surfaces, environmental conditions, crush
injuries, crane set-up, crane tipping from outrigger instability — and then a **six-step lift
sequence**, each step with its own hazards and controls:

```
Step 1 Preparing the load  ·  Step 2 Attaching chains or slings / Loading counterweights
Step 3 Spreader bar attachment  ·  Step 4 Lifting the load
Step 5 Setting load in final position  ·  Step 6 Exit site
```

plus counterweight-truck and dolly-trailer procedures. **Responsible person on site will be the crane
operator**, stated at the foot above twelve ruled signature lines.

> One artefact of this form's provenance is worth flagging: a power-line clause reads *"keep the
> required safe distance between the crane and the powerlines **according to NSW**"* and gives
> clearances as **`3m/6m/8m`**. NSW is New South Wales, Australia, and the units are metric. **This
> section was adapted from a non-US source and not fully localised** — TCG's own SCE plan and the
> e-ticket both work to OSHA/Cal-OSHA. Treat the clearance figures on this form with caution.

## 3. `TCG 2026 JSA Form 06-09-2026_1` — Job Safety Analysis \| Job Planning

A different document with the same name, three months later. Its distinguishing feature is a
**gate**.

### The audit strip at the top

Before the JSA proper, the form opens with the same strip that heads the
[Safety Value Assessment](03-field-audit-and-safety-value.md):

```
Crew Auditor Name ______  Time ______
☐ Full Counterweights   ☐ Management Approval for Less Counterweight  ☐ Yes ☐ No
☐ TCG Approved Outrigger Mats  ☐ Completed Paperwork  ☐ Chocks  ☐ PPE  ☐ Meets Crane Guys Standards
☐ Pictures - All Sides of Crane (4)  ☐ Pictures - Completed Paper Work  ☐ Video - 360° Walk Around
                    ( For The Crane Guys Internal Audit Use Only )
```

### The Crane Guys Standard is a hard gate on starting the lift

Printed on page 2 and repeated verbatim on the Safety Value Assessment:

> *"**The only way you begin the lift is if the Crane Guys Standard is met.**"*
>
> - **Mats** — Crane Guys approved mats or pads **under all outrigger floats**.
> - **Full Counterweight** — all available counterweight on site, loaded on the crane.
> - **Less than Full Counterweight** — *"Must call **crane superintendent** and get approval to check
>   box."*
> - **Paperwork Completed** — *"**JSA, lift scope** and any other applicable paperwork needed to be
>   signed and understood **before starting the lift**."*
> - **Chocks** — trailers and dollies.
> - **Proper PPE** — all employees present.
> - **Meets Crane Guys Standard** — *"can **'Only'** be checked if mats, full counterweight or
>   management approved less counterweight, paperwork completed, chocks and proper PPE boxes are all
>   checked. **You can only begin the crane lift once The Crane Guys Standard has been met, and The
>   Crane Guys standard box is checked.**"*

> **This is the clearest workflow gate in the entire drop, and no requirement document contains it.**
> It is a computed boolean over five other booleans, one of which requires a **named person's verbal
> approval** (the crane superintendent), and it blocks the start of work. The FRDs' `FR-FOP-012 Start
> Work` has no precondition of this kind, and the demo's Start Work step has none either. It also
> names **"lift scope"** — the on-site scope-of-work form in §4 below — as required paperwork,
> which no FRD mentions at all.

### Roles, roster and talking points

- **`THE CRANE GUYS AND SUBCONTRACTOR ROLES AND RESPONSIBILITIES`** — five rows of three columns,
  *"INCLUDES: 3rd Man, Riggers, Signal Men, Traffic Control (TC), Trucking, Superintendent, Mechanic,
  Safety Team (ST), Management. (Example: Bob Smith, Flagger, Company Name)"*. **Every person on site,
  TCG or not, is listed by name, role and company.** The FRDs model a TCG crew on a ticket; they do
  not model subcontractor personnel on site.
- **`Pre-lift Meeting Talking Points. Please Check Off if Discussed.`** — around thirty boxes in three
  columns, including: Introduce Crane Guys Onsite · Give Responsibilities · Lift Area · Lift Path ·
  Crane on Slope · **Crane on Slope Over 6% Grade** · Discuss Rigging · Confirm Rigging Inspection ·
  Stay Out From Under Load - Tag Line · Working Near Cranes · Communication (**Radio / Hand / Voice**)
  · **Stop Work Authority** · Working Near Power Lines · Crane Grounded · **`Wind Speed ____ MPH`** ·
  Proper PPE · **Mark if Missing: First Aid / Spill Kit / Fire Extinguisher / AED** · Review Lift
  Plan · Confirm Traffic Control Plan Area · **Confirm Doors Have Been Knocked** · Confirm Stop
  Operator if Pedestrians are Present · Full Street Closure · Partial Street Closure ·
  **Partially Open - High Visibility Vests** · Ask Customer to Discuss Emergency Plan · plus a free
  `Additional Safety Concern` with a `Mitigation Step`.
- **Crew counting and signatures.** `Customer Onsite Crew Leader (Print)` · `Customer Crew Total` ·
  `TCG Crew and Subcontractor Total` · `Total`, with a customer-crew list captured as
  **first name and last-name initial minimum**. Then:

  ```
  All Crew Present to Sign ☐ Yes ☐ No   *If no select one of the boxes below
    1. ☐ Manager Confirms Responsibility to Notify Crew   Onsite Crew Leader Initials ____
    2. ☐ Onsite Crew Leader Refused to Sign
  ```

  **"Onsite Crew Leader Refused to Sign" is a recorded outcome, not an error state.** The demo's
  *"Customer not available for final signature"* is the nearest analogue, and it is on a different
  signature.
- **`Nearest Hospital Address ______ Distance ______`** and a final `Crew Leader Initials` line.

### Reconciling the two 2026 JSA forms

They overlap heavily (PPE, power lines, rigging, wind, stop-work) but differ in kind: **3.28.26 is a
checklist of conditions; 6.9.26 is a meeting script plus a gate plus a roster.** The later one adds
the Crane Guys Standard, the roles roster, the crew count, the hospital and the refusal-to-sign
outcome; it drops the printed hazard-and-control reference and the numeric power-line clearance
field. Neither is marked superseded. **The e-ticket, meanwhile, carries neither** — it carries the
six-item `JSA 12.18.25`.

## 4. `TCG_On-site scope of work form` — the lift calculation

A one-page capacity worksheet. Its instruction line is a **frequency rule**:

> *"**MUST be completed before any crane operations begin and each time crane configuration
> changes**"*

and a three-step procedure:

> *"(Step 1) Inspect the site, crane, and attachments; Complete calculations below; **Set outriggers
> and crane to level within 1% of grade** (if needed, use cribbing with no gaps). (Step 2) **Show
> on-site supervisor this form and related chart(s) to prove the operation meets manufacturer
> specifications; Both sign form and keep with supervisor.** (Step 3) Operate to plan"*

**The calculation.**

```
Crane Description:  Unit # · Make · Model · Capacity
Jib:                Will jib be used?  Y/N     Will jib be stowed?  Y/N
Outrigger Position (circle one — use correct chart):   0%   50%   100%
Counterweight (in pounds): ______

Deductions:  Rigging · Headache Ball · Weight of Wire Rope · Load Block · Jib (if any) · Other
             → Total Deductions

Gross Capacity (based on current configuration) − Total Deductions = Net Capacity
Weight of Load · Rated Line Pull · Parts of Line Needed
```

**Two critical-lift triggers**, each a starred Yes:

```
Is the crane at 75% or more of the net capacity?        *Yes / No
Does the lift require (2) or more machines?             *Yes / No
```

**And a platform trigger:**

```
Will there be a personnel platform attached?            *Yes / No
If yes, is max load 50% of the Net Capacity?            *Yes / No
  *If "Yes" to the platform area above, a Personnel Platform packet MUST be completed*
```

Signed by **Operator** and **Foreman**, each print/signature/date, under:
*"Signing this form proves this operation meets manufacturer recommendations as indicated in the
load-chart(s)."*

> **This is a lift plan, and it is the "lift scope" the Crane Guys Standard requires before the
> lift.** Three things in it exist nowhere in the field-ops requirement set: a **computed net
> capacity** with a named deduction list; a **75%-of-net-capacity critical-lift threshold**; and a
> **re-do trigger on configuration change**, which means one job may need several of these forms —
> while the e-ticket carries one lift-information block per ticket. `FR-FOP-004 Ticket Details`
> displays lift information; nothing calculates or gates on it.
>
> The field crane audit form asks *"Critical Lift Plans — Yes/No"* as a single tick
> ([03](03-field-audit-and-safety-value.md)), and the printed e-ticket's `Lift Information` block
> gives Main Boom, Jib, CWT, Radius and Load Weight but **no capacity, no deductions and no
> percentage** — the numbers this form starts from, not the ones it produces.

`3.6.1_MODULE-SAFETY-COMPLIANCE/Safety FORMS/TCG On-Site Scope of Work (paper version).jpg` is a
**photograph of the printed form**, read on 2026-09-04: identical to the PDF field for field —
the three-step Directions (inspect and level within 1% of grade with gapless cribbing; show the
supervisor the form and chart(s); operate to plan), Crane Description (Unit # · Make · Model ·
Capacity), Jib used/stowed, Outrigger Position 0% / 50% / 100%, Counterweight (lb), Gross
Capacity → Total Deductions → Net Capacity, Weight of Load, Rated Line Pull, Parts of Line
Needed, the two **Critical Lift Criteria** questions (crane at ≥ 75% of net capacity? two or
more machines?), the two **Platform** questions (personnel platform attached? max load 50% of
net capacity?) with *"a Personnel Platform packet MUST be completed"*, Operator and Foreman
print/sign/date, and the crane diagram with Boom Length · Boom Tip Height · Boom Angle · Load
Radius · Weight of Load fill-ins. Nothing on the paper version differs from the PDF.

## 5. Open points

Recorded for a human to route; **not** written to any `gaps.md`.

1. **Which JSA is current** — 3.28.26, 6.9.26, or the e-ticket's `JSA 12.18.25`? Are they for
   different job types, or has one superseded another?
2. **Is the Crane Guys Standard a gate the ERP must enforce** before Start Work? If so, how is
   *"call the crane superintendent and get approval"* represented — a checkbox, a named approver, a
   push notification?
3. Does the app need to model **subcontractor and customer personnel on site** by name and role, as
   the 6.9.26 roster does?
4. **Is the on-site scope of work in scope for the field app?** It is required paperwork by the
   Crane Guys Standard, it is a per-configuration document, and nothing in either FRD mentions it.
5. What happens when the **crew leader refuses to sign**? The form records it; no requirement does.
6. Should the crew record a **measured power-line clearance and a wind-speed limit**, as 3.28.26
   asks? And should the *NSW / metric* clearance text on that form be corrected?
7. Who holds the signed JSA — *"Both sign form and keep with supervisor"* is a paper custody rule
   with no digital equivalent specified.

## Source

| File | Format | Note |
| --- | --- | --- |
| `1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/TCG JSA 2026 PDF Final 3.28.26.pdf` | PDF, 2 pages, `pdftotext -layout` | blank; multi-column control reference reflows imperfectly but is legible |
| `3.6.1_MODULE-SAFETY-COMPLIANCE/Safety FORMS/TCG 2026 JSA Form 06-09-2026_1.pdf` | PDF, 2 pages, `pdftotext -layout` | blank |
| `1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/TCG_On-site scope of work form.pdf` | PDF, 1 page, `pdftotext -layout` | blank |
| `3.6.1_MODULE-SAFETY-COMPLIANCE/Safety FORMS/TCG On-Site Scope of Work (paper version).jpg` | JPEG, 2.3 MB | photograph, **read 2026-09-04** — identical to the PDF form |

All four are blank forms; no personal data appears in any of them.

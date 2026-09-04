---
title: The ideal single safety platform — what TCG's safety department asked for
source: shared-folder/Project-Repository-2026-09-04/3.6.1_MODULE-SAFETY-COMPLIANCE/Ideal Single Safety Platform 2026-07-23.docx
migrated: 2026-09-04
updated: 2026-07-23
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/payroll, module/assets, module/admin, kind/source, safety, compliance, certifications, inspections, reporting, notifications, integrations, geolocation]
entities: []
---

# The ideal single safety platform

**What this is.** A one-and-a-half page brief, dated **2026-07-23**, written by TCG's safety
department, describing the system they want. It is written entirely in the conditional — *"would
connect"*, *"would see"*, *"should track"* — and closes by naming four commercial EHS platforms that
*"Already Do Most of This"*.

**Why it matters.** It is the **only requirements-shaped document for safety anywhere in the vault**,
and it is dated **two months after** the client's *"safety will need to be built in the initial
build"* ([erp-review-log.md](../../erp-review-log.md) #11, 2026-05-03) and **six weeks after** the
last Field Ops FRD. It is therefore the newest statement of intent in this area — and its scope is
several times what either FRD covers.

> **A wish-list, not an accepted scope.** Nothing here is adjudicated, prioritised, or costed. The
> document names no owner, no dates and no phasing, and there is no CodingCops response to it in the
> drop. Crucially, **it does not say the ERP should do this** — it says a platform should, and then
> names four existing products.

The stated purpose, verbatim:

> *"The ideal platform for our safety department would connect the following into a single dashboard
> that automatically **tracks requirements, sends alerts, generates reports, and provides audit-ready
> documentation**. This would eliminate duplicate data entry, spreadsheets, paper files, and missed
> compliance deadlines."*

---

## 1. Twelve domains in one dashboard

```
Safety Training · OSHA & Cal/OSHA Compliance · DOT Compliance
Driver Qualification Files (DQF) · Drug & Alcohol Programs · Fleet Management
Environmental Compliance · Equipment Inspections · Safety Committee Actions
Incident & Near-Miss Reporting · Corrective Actions · Employee Certifications
```

Of these twelve, the Field Ops FRDs touch **three** — equipment inspections (`FR-FOP-008/021`),
incident/near-miss (only in the demo build, not in either FRD as a requirement), and employee
certifications (`FR-FOP-028`). **DOT compliance, driver qualification files, drug and alcohol
programmes, environmental compliance and safety committee actions appear in no other document in
the vault.**

## 2. One electronic profile per employee

> *"Every employee would have **one electronic profile** containing:"*

| Block | Contents |
| --- | --- |
| **Training Records** | Orientation · OSHA training · **Rigging** certifications · **Signal Person** certifications · **Forklift** certifications · **Aerial lift** certifications · CPR/First Aid · **Smith System driver training** |
| **Compliance Tracking** | Training expiration dates · License expiration dates · **Medical card** expiration dates · Badge and credential expirations |
| **Safety History** | Safety observations · Incident involvement · Near misses · Corrective actions assigned · **Recognition awards** |

> *"The system would automatically notify **employees, supervisors, HR, and the safety team** before
> anything expires."*

Two things to note against what the vault already has. The training list is **broader than the crew
intake form's six credentials** (`Drivers License · NCCCO · OSHA 10 · OSHA 30 · First Aid/CPR · DOT
Physical` — [field-paper-forms.md](../field-paper-forms.md) §4): it adds rigging, signal person,
forklift, aerial lift, orientation and Smith System. And the **notification audience is four
parties**, not just the employee — `FR-FOP-033 Certification Expiry Notification and Upload`
(FOP-001) and the demo both notify only the employee.

**Safety history on the employee profile** — observations, incident involvement, corrective actions
assigned, awards — has no counterpart anywhere else in the vault.

## 3. The Safety Department command centre

A real-time dashboard in five panels:

| Panel | Contents |
| --- | --- |
| **Training Compliance** | Overall training percentage · Overdue training · Upcoming expirations |
| **Fleet Safety** | **Samsara safety trends** · Accidents · Near misses · Driver coaching opportunities |
| **Shop Safety** | Open hazards · Environmental findings · Equipment inspection status |
| **Corrective Actions** | Open findings · **Responsible party** · Due dates · **Escalation status** |
| **Safety Metrics** | **TRIR** · **DART** · Near-miss reporting rate · Inspection completion rate · Safety observation participation |

**`TRIR` and `DART`** are the OSHA recordable-incident and days-away/restricted/transfer rates. They
are computable only from an incident register with classifications and lost-time data — which is
exactly what the [incident investigation form](04-incident-investigation-form.md) collects on paper.
The two documents are the two halves of one metric.

**Samsara** appears here as a fleet-safety data source. FOP-002's open question #10 is
*"Samsara reconciliation expectations"*, and the paper daily log has hand-written
`GPS Tracker Depart` / `GPS Tracker Arrive` lines. Three sources now point at the same unbuilt
integration.

## 4. A dedicated DOT and driver compliance module

| Block | Contents |
| --- | --- |
| **Driver Qualification Files** | Driver applications · MVR reviews · Road tests · CDL licenses · Medical cards |
| **FMCSA Compliance** | Drug and alcohol testing · **Random testing pool status** · **Clearinghouse queries** · Annual reviews |
| **Vehicle Compliance** | **Daily Driver Vehicle Inspection Reports (DVIRs)** · Preventive maintenance · Registration · Insurance · Annual inspections |
| **Driver Safety Data** | Speeding events · Harsh braking · Seatbelt usage · Distracted driving · **Samsara safety scores** |

> *"The system would automatically alert management **before a compliance issue becomes a
> violation**."*

**`DVIR` is the regulated name for the daily vehicle inspection** — i.e. the pre-trip and post-trip
the field app already captures (`FR-FOP-008` / `FR-FOP-021`, and the `Crane Pre-Trip Inspection` and
`Trailer 30 Day Check List` on TCG's real tickets). **This is the only document in the vault that
frames the field pre-trip as a DOT record with a retention and audit obligation**, rather than as a
workflow step. The demo's `Checklist History — Retained 3 yrs (DOT)` is the same idea from the other
side; the FRD lists inspection retention as still *Pending*.

Registration, insurance and annual inspections also appear as rows **inside** the crane pre-trip
checklist on ticket 44944 (items 4, 15, 16), so the same facts are being verified daily in the field
and tracked centrally here.

## 5. Shop, environmental and hazard-communication tracking

**Shop safety:** Lockout/Tagout inspections · Welding inspections · Grinder inspections · PPE
compliance · Housekeeping audits · **Hot work permits**.

**Environmental compliance:** Oil storage inspections · Waste oil disposal records · Used filter
disposal · Battery disposal tracking · Spill prevention inspections · **Hazardous waste manifests**.

**Hazard communication:** **SDS library** · Chemical inventory · Label inspections · HazCom training.

**Environmental dashboard**, called out separately *"because environmental compliance is increasing
in importance"*: chemical inventory · SDS management · HazCom compliance · **wash rack inspections** ·
**drain inspections**.

All of this is **yard and shop** work, not field work. It sits closest to `assets/` and to the
mechanic and yard personnel roles that **FOP-002 §4 explicitly excludes from scope**. No document in
the vault covers it.

## 6. The document names its own competitors

It closes with a bare list under *"Existing Platforms That Already Do Most of This"*:

```
1. Intelex   2. Cority   3. Enablon   4. Site Docs
```

No comparison, no recommendation, no pricing — just the four names. **The document does not say
whether the safety department wants the ERP to build this or wants one of these products bought**,
and nothing else in the drop answers that. Given the scope above — DOT/FMCSA, drug and alcohol
programmes, SDS and hazardous waste — it is a question worth asking before any of it is specified.

## 7. Open points

Recorded for a human to route; **not** written to any `gaps.md`.

1. **Build or buy?** The document names four commercial platforms and does not choose. This is the
   first question, and it governs every other one here.
2. If build: **what is in the initial build?** #11 (2026-05-03) named six things; this document names
   roughly forty. Nothing reconciles them.
3. Is the field **pre-trip a DVIR** — i.e. does it carry a DOT retention obligation, and for how
   long? The demo says 3 years, the FRD says *Pending*, FCC's Atom shows 90 days by default.
4. Who owns the **employee safety profile** — this platform, the ERP's employee module, or FCC (which
   the client says is where certifications live today)?
5. Does **Samsara** integrate, and with which of: field time reconciliation, fleet safety scores, or
   both?
6. Are **shop, environmental and HazCom** tracking in ERP scope at all, given FOP-002 excludes
   mechanic and yard personnel workflows?

## Source

`3.6.1_MODULE-SAFETY-COMPLIANCE/Ideal Single Safety Platform 2026-07-23.docx` — 28 KB, pandoc gfm.
Plain bulleted prose, no tables or images in the original; the conversion is complete. The document
carries no author name, no distribution list and no revision history beyond the date in its filename.

---
title: Safety & Compliance Data Platform — Requirements Specification — the AbInBev360 reference, sent by Dennene Jones as an example for accident and injury submissions (2026-09-30)
source: user-supplied/3.6.1_MODULE-SAFETY-COMPLIANCE.zip (2026-10-01) — Safety Module Ideas/Safety & Compliance Data Platform — Requirements Specification.docx; covering e-mail Dennene Jones → Brian Petros (text relayed by syed.haris, 2026-10-01)
migrated: 2026-10-01
updated: 2026-09-30
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/admin, module/payroll, kind/requirements, safety, compliance, incidents, inspections, reporting, notifications, samsara]
entities: [certification]
---

# Safety & Compliance Data Platform — Requirements Specification (the AbInBev360 reference)

**What this is.** A requirements specification of about 12 KB, **dated 30 September 2026 and bylined
Dennene Jones**, TCG's Safety Manager. It was written **the day after** the
[2026-09-29 safety discussion](../../meetings/2026-09-29-safety-discussion-onboarding-certifications-incidents-and-facility-compliance.md).
It specifies five modules, the cross-cutting requirements, three build phases with gates, and eight
open questions. It is reproduced in full below, apart from light reformatting. The two diagrams are
described in text.

**How it reached us: Dee's covering e-mail to Brian Petros** (2026-09-30, relayed by syed.haris on
2026-10-01):

> *"Here are the specifications to the Abinbev360 platform used at Anheuser Busch for the safety
> compliance department. They wrote their own ERP as well, and it worked. Can we share this with
> coding cops as an example of what we are looking for concerning accidents and injury submissions in
> safety?"*

Three things follow from the e-mail, and they govern how every section below should be read.

1. **It is an example, not TCG's spec.** It describes how the **AbInBev360** platform, *"AB InBev's
   instance of UL Solutions' 360 platform"* (§1), works at Anheuser-Busch. The TCG/TRG naming,
   hierarchy and phasing are the example adapted to TCG. They are not TCG requirements that anyone
   has agreed.
2. **Its stated purpose is narrower than the document.** Dee offers it as an example *"concerning
   accidents and injury submissions"*. That is **Module 1** (incident reporting) and **Module 2**
   (corrective actions), which is also the spec's own MVP (§9). Modules 3–5 (metrics, inspections,
   dashboards) come along with the example. **Nothing says TCG wants them in this form.**
3. **It leans towards building.** *"They wrote their own ERP as well, and it worked"* is the first
   signal from the safety department on build-or-buy. The July wish-list ([01](01-ideal-single-safety-platform.md) §6)
   named four commercial products and did not choose. The spec's own open question 1 still says
   *"build custom, or configure an existing … product? Get a quote for both."* So this is a lean,
   not a decision.

**Why it matters.** It is the most concrete safety material in the vault. It is the first to come
from the person who will use the system, and the first tied to a named, working reference system. On
accident and injury reporting it is far more specific than the July wish-list.

> **Not an accepted scope.** No CodingCops response exists, no ticket exists, and nothing here has
> been adjudicated.
>
> **Provenance note:** the .docx metadata (`docProps/core.xml`) records it as exported from **Claude
> Docs** at revision 12. The body is written in the first person (*"We are building one system"*),
> which reads as the reference platform's own description rather than TCG's. Read it through the
> e-mail above, not at face value.

---

## 1. Purpose and scope

> *"We are building one system where every location reports safety events and monthly metrics, every
> submission is reviewed and approved, rates are calculated automatically, and corrective actions are
> tracked to closure."*

- **Reference model: AB InBev's instance of UL Solutions' 360 platform** (formerly *Credit360*).
  *"We are copying its functions, not its code or look."*
- **It serves two companies: The Crane Guys (TCG) and The Repair Guys (TRG).** It must produce the
  data that clients and **prequalification platforms** ask for.
- **In scope:** incident, near-miss and hazard reporting; corrective actions; monthly safety metrics;
  inspections and audits; dashboards and exports.
- **Out of scope for now:** environmental and sustainability *metrics* (energy, emissions, water),
  **payroll**, and **dispatch**.

## 2. Users, roles and locations

Access depends on **role × assigned locations**. A user sees only data **at or below** the locations
they are assigned to.

| Role | Who | Can do |
| --- | --- | --- |
| Field reporter | Operators, riggers, drivers, mechanics | Submit incident, near-miss and hazard reports; see their own reports; complete assigned inspections |
| Supervisor | Foremen, yard leads | All of the above; review their crew's reports; **enter monthly hours**; own corrective actions |
| Safety manager | Safety & Compliance staff | Investigate; assign and verify actions; **approve monthly data**; build forms and checklists; run all reports |
| Executive | Owners, managers | **Read-only** dashboards across all locations |
| Admin | IT or designated staff | Users, locations, roles, system settings |
| Guest reporter | Subcontractors, visitors, clients | Submit a hazard or incident report through a **public link, with no account** |

One person can hold several roles. **Every role change is logged.**

**Organisational hierarchy (diagram 1).** It has four levels: **All companies → Company (TCG, TRG) →
Divisions → Yard or shop / Jobsite**. Reports and monthly numbers are entered only at the **yard/shop
and jobsite** level and roll up automatically. Admins add, rename and retire locations on a settings
screen. A **jobsite** is short-lived: it can be opened and closed without losing its history, and it
records its **client and its start and end dates**.

## 3. Module 1 — Incident, near-miss and hazard reporting

The goal is a field report *"from a phone in under two minutes"*, which the safety team then
investigates and closes.

**Report types:** injury/illness · near miss · property or equipment damage · vehicle incident · hazard
observation · environmental release · good catch (a positive observation).

**Captured at submission:**

- date, time and location (jobsite picked from a list, or the phone's GPS)
- report type and a short description
- **equipment involved** (crane unit number, truck number, rigging gear)
- the people involved and any witnesses
- photos and video, taken straight from the camera
- the immediate actions taken
- the reporter's name, or **an anonymous option for hazard reports**

**After submission:**

1. The safety manager and the location's supervisor are alerted by **e-mail and text**. Injury and
   serious-incident reports send an **urgent** alert.
2. The safety manager classifies the report: severity, **OSHA recordable** yes/no, **DART case**
   yes/no, days away or restricted, and **whether a client must be notified**.
3. For reports that need one, an **investigation form** opens: timeline, contributing factors, root
   cause (**5 Whys** or a pick list), and statements.
4. Corrective actions are created from the investigation (Module 2).
5. **The report closes only when all its actions are verified closed.**

**Rules:**

- The status moves through **Submitted → Under review → Investigating → Actions open → Closed**.
- Recordable cases feed the **OSHA 300 log** automatically.
- **Client-notification deadlines appear as a countdown** on the report, for example a utility client
  that requires notice within 24 hours.

## 4. Module 2 — Corrective and preventive actions

Every finding, from any source, becomes one tracked action with an owner and a due date. **It stays
open until someone other than the owner verifies the fix.**

- **Sources:** incident investigations, inspections, audits, safety committee meetings, client audit
  findings, and manual entry.
- **Fields:**
  - description and source (linked back to the report or audit), location, owner, due date;
  - priority (high / medium / low);
  - **action type**: engineering control · training · procedure change · **discipline** · equipment
    repair;
  - **evidence of completion**: a photo, document or training record.
- **Workflow:**
  1. The safety manager or a supervisor creates the action and assigns an owner.
  2. The owner is notified, and reminded **3 days before the due date**.
  3. The owner marks it complete and attaches evidence.
  4. The safety manager **verifies and closes** it, or sends it back with a note.
- **Escalation:** an overdue action notifies the owner **daily**, and the owner's manager **after 7
  days**. Overdue counts appear on the dashboard by location and by owner.

## 5. Module 3 — Monthly metrics and indicators

Each location enters a few numbers once a month. The system combines them with incident data to
calculate every rate.

**Indicators are defined by an admin, not hard-coded.** Each has a name, unit, frequency (monthly by
default), entry owner, and an entered-or-calculated setting.

| Indicator | Entered / calculated | Source or formula |
| --- | --- | --- |
| Hours worked (employees) | Entered | Payroll or timesheets |
| Hours worked (subcontractors) | Entered | Subcontractor reports |
| Employee headcount | Entered | HR |
| Vehicle miles driven | Entered | Fleet or ELD records |
| Recordable cases | Calculated | Module 1 |
| DART cases, days away, days restricted | Calculated | Module 1 |
| Near misses and hazard reports | Calculated | Module 1 |
| **TRIR** | Calculated | Recordables × 200,000 ÷ hours |
| **DART rate** | Calculated | DART cases × 200,000 ÷ hours |
| **Lost workday rate** | Calculated | Days-away cases × 200,000 ÷ hours |
| **Preventable vehicle incident rate** | Calculated | Preventable incidents × 1,000,000 ÷ miles |
| **Near-miss to recordable ratio** | Calculated | Near misses ÷ recordables |

- **Approval:** the supervisor enters the numbers **by the 5th of the following month**, and the
  safety manager approves them.
  - **Approved months lock.**
  - Changing a locked month needs a safety manager to unlock it, with a written reason.
- **Variance flag:** a value **more than 30% above or below the location's 3-month average** is
  flagged. The submitter must explain it before it can be approved.
- **Reminders:** a notice on the **1st**, a reminder on the **4th**, and escalation to the safety
  manager on the **6th** if the numbers are still missing.

## 6. Module 4 — Inspections and audits

The safety team builds each checklist once. Supervisors complete them on a phone. **Every failed item
becomes a corrective action automatically.**

- **Checklist builder:**
  - Question types: pass/fail/N/A, yes/no, number, text, photo, and signature.
  - **Templates are versioned**, so an old inspection keeps the questions it was done with.
- **Example templates:** jobsite safety inspection · crane pre-use and frequent inspection · rigging
  gear inspection · **vehicle DVIR** · yard and shop inspection · internal programme audit.
- **Scheduling:** inspections can be assigned to a person or a location on a repeating schedule
  (daily / weekly / monthly). A missed inspection shows as overdue.
- **Scoring:** each inspection gets a percentage score, trended by location and by template.
- **Findings:** a failed item needs a comment and a photo. It creates a Module 2 action pre-filled with
  the location and the item.

## 7. Module 5 — Dashboards and reporting

**The dashboard can be filtered by entity, division, location and date range.** It shows:

- TRIR, DART and the lost workday rate, for the current year and as a 3-year trend;
- incident and near-miss counts by type, month and location;
- open and overdue corrective actions;
- the inspection completion rate and the average score;
- months with missing or unapproved data.

**Standard reports:**

| Report | Used for | Format |
| --- | --- | --- |
| OSHA 300 log and 300A summary | OSHA recordkeeping and posting | PDF, Excel |
| Annual statistics by entity (hours, recordables, DART, fatalities, EMR entry) | **ISNetworld and Avetta** annual updates | Excel |
| Monthly labour hours and incidents | Client monthly reporting (utility and line-clearance clients) | Excel |
| Incident summary | Client notification and follow-up | PDF |
| Corrective action status | Safety committee meetings | PDF, Excel |
| Raw data export | Custom analysis | CSV |

**Reports use only approved data**, and each export records who ran it and when.

## 8. Cross-cutting requirements

These are marked *"built in from the start, because adding them later is costly"*.

- **Audit trail:** every create, edit, approval and delete records who, when, the old value and the
  new value. **Records are never hard-deleted.** They are voided, with a reason.
- **Mobile first:** all field forms work **in a phone browser**. They **save drafts and submit when
  signal returns**.
- **Notifications:** e-mail and text. Each user chooses which alerts they get, but **urgent incident
  alerts can't be turned off**.
- **Document storage:** photos, statements, certificates and evidence are attached to their record.
  The admin sets the file-size limit.
- **Security:** individual logins; **MFA for supervisor and above**; role and location permissions
  **enforced on the server**.
- **Privacy:** injury and medical details are visible only to the safety manager and admin.
  **Privacy-case names are masked on the OSHA 300 log.**
- **Retention:** OSHA records are kept **at least 5 years** after the year they cover; everything else
  **7 years** unless an admin changes it.
- **Configuration without code:** an admin adds forms, fields, indicators, checklists and locations
  through screens.
- **Backups:** daily, with a tested restore.

## 9. Phased build plan (diagram 2)

*"Launch incident reporting first, then add metrics and inspections."*

| Phase | Contents | Gate to the next phase |
| --- | --- | --- |
| **1 — MVP** | Users, roles, locations · incident and hazard reports · corrective actions · audit trail, mobile forms | **Crews using it at a pilot location** |
| **2 — Metrics** | Monthly hours and miles · approvals and variance flags · calculated rates · dashboard, OSHA 300/300A | **One month closed fully in the system** |
| **3 — Full programme** | Inspection checklists · client and prequalification exports · guest reporting link · past-data import | — |

The MVP is incident reporting plus corrective actions, *"because that is where field data starts and
where a paper process costs the most"*. The cross-cutting requirements belong to Phase 1.

## 10. The author's open questions (verbatim, all unchecked in the source)

1. Build custom, or configure an existing low-code or EHS product? *"Get a quote for both before
   committing."*
2. Where will hours worked come from: manual entry, or an automatic feed from payroll?
3. Should vehicle miles come from the ELD or telematics system automatically?
4. Will TCG and TRG share one system with separate entities, or need fully separate data?
5. Which client reports have fixed templates we must match exactly? Collect a sample of each.
6. Do guest reporters (subcontractors, clients) need to see the status of what they reported?
7. Who hosts it, who supports it after launch, and what is the budget?
8. What existing records (past incidents, OSHA logs, prior years' hours) must be imported at launch,
   and how many years back?

---

## 11. Against the rest of the vault

These are observations for whoever picks this up. None of them is a decision. Read the "absent"
rows with the covering e-mail in mind: the document was sent as an example for **accidents and
injuries**. That it leaves out certifications doesn't mean TCG has dropped them.

**Against the 2026-09-29 call, the day before.**

| On the call | In this spec |
| --- | --- |
| Most of the call was about **certifications and training**: the expiry matrix, 60/30-day alerts, self-upload with Safety's verification, and Step (Gallagher) training assignment | **Absent.** None of the five modules covers certifications, training records or expiry. "Certificates" appears only as a kind of attachment. |
| Close-out confirmed by **Safety, the manager and the employee** | Closed when **all actions are verified** by someone other than the owner. The employee and manager do not confirm. |
| "Corrective action" as the umbrella term, covering retraining and discipline (Joe) | **Matches.** `discipline` and `training` are both action types. |
| A **regulatory submissions list** and a **compliance calendar** (Dee) | Not in the spec. It arrived as a separate file: [07-environmental-compliance-calendar.md](07-environmental-compliance-calendar.md). |
| Monthly **facility walkthrough** by QR-code form | Covered by Module 4 (yard and shop inspection, scoring, trend). |
| Tie accidents to **Samsara**, **pre-trip** inspections and repair status | Only indirectly: vehicle miles from *"ELD or telematics"* (open question 3) and a DVIR template. |

**Against the ERP as it stands.**

- **"Phone browser" vs the native app.** The ERP's field users work in the **Expo mobile app**.
  §8's "mobile first … phone browser" with offline drafts is a requirement *shape*. It isn't
  necessarily a request for a web form.
- **A public guest link with no account** is new: nothing in the ERP accepts an unauthenticated
  submission today.
- **TCG + TRG** maps naturally to the ERP's tenant-company model. Whether that means one tenant with
  two entities, or two tenants, is open question 4. Company → Division → Location is a hierarchy the
  ERP does not currently model.
- **Hours worked** is the payroll module's output, yet payroll is out of scope (open question 2). The
  crane-unit and truck numbers in Module 1 are the ERP's asset records.
- **"Monthly hours" and the payroll module.** Module 3's supervisor-entered monthly hours would
  duplicate data the ERP already captures on job tickets.

**Against the earlier safety material.**

- [01](01-ideal-single-safety-platform.md) (July): its build-or-buy question is **still open** here
  (question 1). The covering e-mail's *"they wrote their own ERP as well, and it worked"* leans
  towards building. This spec is narrower. It drops the DOT/driver module, SDS, HazCom and the
  per-employee training profile. It adds the metrics approval workflow, the location hierarchy, OSHA
  300/300A and the phasing.
- [04-incident-investigation-form.md](04-incident-investigation-form.md): Modules 1–2 are the
  electronic form of that paper report. Its `Recordable / Lost Time / Restricted Duty` fields are
  Module 1's classification step, and its corrective-action register is Module 2.
- [03-field-audit-and-safety-value.md](03-field-audit-and-safety-value.md): the Quarterly Safety Value
  Report's **EMR** and audit metrics reappear in Module 5's annual statistics.
- [05-customer-imposed-safety-requirements.md](05-customer-imposed-safety-requirements.md): SCE's
  notice and reporting duties are what the client-notification countdown and the "utility and
  line-clearance" monthly report are for.
- [FR-FOP-033](../frd-new-format-draft/05-functional-requirements/fr-fop-033-certification-expiry-notification-and-upload.md)
  still carries the certification-expiry requirement that this spec omits.

## Source

`3.6.1_MODULE-SAFETY-COMPLIANCE/Safety Module Ideas/Safety & Compliance Data Platform — Requirements
Specification.docx` — 145 KB, converted with pandoc gfm. Complete. The two embedded PNGs
(1344 × 752 hierarchy, 1344 × 438 phasing) were read and are described in §2 and §9; they weren't
copied into the vault. The document properties give the title and revision 12. Its byline is
*"Sep 30, 2026 · @Dennene Jones"*.

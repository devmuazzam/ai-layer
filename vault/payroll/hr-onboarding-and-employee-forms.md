---
title: HR onboarding and employee forms — the value engines, the 19-item checklist, and the paper record
source: shared-folder/Project-Repository-2026-09-04 — TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 and 2026-06-23 samples, 1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/
migrated: 2026-09-04
updated: 2026-06-23
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, module/admin, kind/sop, compliance, certifications, safety, adp, reference-data]
entities: []
---

# HR onboarding and employee forms

**What this is.** The first HR-process documentation in the vault. Two onboarding value engines
(union and non-union), the ADP-setup playbook and the 19-item onboarding checklist behind them,
and four employee forms TCG uses on paper today. Authored by **Corrina Bustos**, Human Resources,
**2026-05-11** (the playbooks) with the value engines dated **2026-06-16** and **2026-06-23**.

**Why it matters for this module.** `payroll/` owns the employee entity
([STRUCTURE.md](../STRUCTURE.md): *employee\*, departments*). These documents say what has to exist
on an employee before they can be paid or dispatched, which systems hold it, and in what order —
and they name **eleven systems and registers** outside the ERP that an employee record propagates
to. Nothing in the vault has described employee onboarding before.

---

## 1. The two value engines

Both `2026-06-23 samples`. Same spine; the union lane adds two steps.

**Non-union:** Coordinate Date/Time with New Hire Group and EE → **HR sends HR ADP packet via ADP
link** *(PB)* → *Did EE complete ADP link?* → **No** → *Have EE complete link*; **Yes** → **Verify
all HR docs with EE** → **Issue: Employee Handbook · Key FOB · ADP app set-up doc · Atom App ·
Provide Uniforms (if necessary)** *(PB)* → **Office Walkthrough + introductions** → **Add to systems
and complete HR checklist** *(PB)* → **Employee Onboarded**.

**Union:** identical up to the ADP link, then inserts a **safety gate** and a **dispatch gate**:

- *Safety Orientation Completed?* → **No** → **Safety Completes Department Orientation** →
  rejoins. → **Yes** → Verify all HR docs with EE.
- *Does EE have **Local 12 Dispatch Slip**?* → **No** → **Reach out to Super to get EE dispatched**.
  → **Yes** → **Bring EE to meet with Super** — annotated *"(has their own processes)"*.

Then the same issue-and-walkthrough tail, ending **EE Onboarded**. Uniforms are unconditional for
union hires; *"if necessary"* for non-union.

**Three facts worth carrying:**

1. **The Local 12 dispatch slip is a precondition of union employment at TCG** — the employee is
   dispatched *by the union* before TCG can put them to work. This is the operational counterpart
   of the dispatch tier order and last-crew entitlement recorded in
   [erp-review-log.md](../erp-review-log.md) §4.
2. **Safety orientation gates union onboarding** and is owned by a separate Safety department.
3. **The `(PB)` markers** indicate steps with their own playbook. Two of those playbooks are in this
   drop (§2, §3); the rest are not.

## 2. The ADP-setup playbook

`TCG HR - Union and Non Union Employee Onboarding Template.docx` — Corrina Bustos, created and last
updated **2026-05-11**, owner **Human Resources**. Overview: *"New union and non union employee ADP
set up. Link sent to employee."*

1. Log onto **ADP Workforce Now**.
2. Toolbar: **Process → HR Dashboard → Hire Someone**.
3. Click **Hire Someone → HR + Payroll (system)**.
4. Enter **Name, Phone Number, personal email** (tick *"use for notification"*), **Hire Date,
   Reason for Hire, Company Code**.
5. Click **"Ask the New Hire"**, scroll up, **Save and exit**.
6. The new hire completes the link, selecting **Standard (system)**.

Resource: `https://workforcenow.adp.com/theme/index.html#/Process/processHRDashboard`. The
walkthrough-video section is an unfilled template placeholder.

**This is the ERP↔ADP employee-creation boundary, stated concretely.** The employee record is
**born in ADP**, from six fields, and the new hire completes the rest themselves through ADP's
own onboarding link. It is consistent with the decision
[2026-06-30-adp-erp-employee-data-ownership](../decisions/2026-06-30-adp-erp-employee-data-ownership.md),
and with [adp-integration-capabilities.md](adp-integration-capabilities.md)'s
`applicant.onboard` V2 notes. **Company Code** is entered at hire — the same per-company code
(`4RZ` and others) the ADP exports carry.

## 3. The onboarding checklist — 19 items, eleven destinations

`TCG HR- Union and Non Union Onboarding Checklist.pdf` — same author and date; the playbook body is
just *"Step 1: See attached Checklist"*, and the checklist is the substance. Overview: *"Full
Checklist of items that are needed in order for the employee to be fully onboarded in the company.
Once completed, they will be fully compliant."*

Every item is a paired **Added \_\_\_ / Removed \_\_\_** blank — the same list runs forwards for a
hire and backwards for a termination.

| # | Item | Note |
| ---: | --- | --- |
| 1 | TCG Contact List | |
| 2 | Hire Date Chart / Calendar | |
| 3 | Birthdate Chart / Calendar | matches review-log #6's ask for birthday/anniversary notifications |
| 4 | **Union Start Date Chart** | a *third* date register, union-specific |
| 5 | ADP | |
| 6 | **I-9 & W-4 filing** | |
| 7 | **KEY FOB # \_\_\_ Brivo** | physical access control, by fob number |
| 8 | **FCC Profile** | *"Notify Dispatch and Dispatch Assistant that profile is created. Dispatch Assistant will then add new hires **certifications** to profile and **dropbox**."* |
| 9 | **Send last 4 of SS number for fuel code** | to a named individual `[name in the source form — deliberately not copied]` |
| 10 | **Megan's Law check** | |
| 11 | Send welcome email company-wide | |
| 12 | Send removal email company-wide | the termination counterpart |
| 13 | **Field Availability List given to Dispatch** | |
| 14 | **Employee Navigator (Non Union)** | benefits platform, non-union only |
| 15 | Create Cubby Box Label | |
| 16 | **Enrol in ADP Training** — *Harassment Training, Workplace Violence* | |
| 17 | Previous Employer Report | |
| 18 | **TCG Email** | *"Created By IT"* |
| 19 | **FCC Log-In Credentials** | *"Created By IT"* |

**What this tells the ERP.** An employee record today is scattered across **ADP, FCC, Brivo,
Employee Navigator, Dropbox, email/IT, three separate date charts, a contact list, a field
availability list and a fuel-code system** — and the checklist exists because nothing joins them.
Item 8 is the one that matters most for this module: **certifications are attached to the FCC
profile by the Dispatch Assistant, and duplicated into Dropbox** — so the certificate expiry data
in `FMS_EMP_CERTIFICATES`
([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §6) is maintained
by dispatch, not HR, and has a shadow copy. Review-log #6 item 8 asks for *"expiration dates on
attachments"* and #12 for emergency contacts; this checklist is why.

Item 9 involves transmitting part of an SSN by email for a fuel code. Recorded as a fact about the
current process; the receiving individual's name is in the source form and is not copied here.

## 4. The employee forms

Four forms from `1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/`. Three are DOT
compliance documents; one is the absence request.

### 4.1 Absence Request — `Day off Request.docx`

Titled **"Absence Request"** with the header **"\*\* 2 Week Minimum Notice Required \*\*"**.

- **Header fields:** Employee Name · Date Requested · **Department** · **Manager**.
- **Type of Absence** (eight options): **Sick · Vacation · Bereavement · Time Off Without Pay ·
  Military · Jury Duty · Maternity/Paternity · Other**.
- Dates of Absence From / To · Reason for Absence · Employee Signature + Date.
- **Manager Approval:** Approved / Rejected · Comments · Manager Signature + Date.

Two internal inconsistencies in the form itself, both worth noting rather than resolving: the
header demands **two weeks'** notice while the body's fine print says *"You must submit requests for
absences, other than sick leave, **two days** prior to the first day you will be absent"*; and
`Department` and `Manager` are free-text fields, which is the same `Department` whose purpose
Corrina asks about in [erp-review-log.md](../erp-review-log.md) §12.

**Against the register:** the eight absence types map onto
[PAY-073](rules/PAY-073-sick-pto-on-call-pay.md) (sick/PTO/on-call) and the FCC classifications
`SICK`, `ADMIN PTO`, `BER` (Bereavement) — but **Military, Jury Duty and Maternity/Paternity have
no classification and no rule**. [PAY-057](rules/PAY-057-vacation-eligibility-pay.md) covers
vacation eligibility. Whether any of these are paid, and at what rate, **this form does not say**;
it is a request form, not a pay rule.

### 4.2 DOT / FMCSA forms — three, all dated 03-20-2026 "Final"

| Form | What it does | Payroll-relevant detail |
| --- | --- | --- |
| **Driver's Receipt** | Acknowledges receipt of the **FMCSR Pocketbook (347)** and agreement to familiarise with 49 CFR Parts 40, 380, 382, 383, 387, 390–397, 399. Driver signs; **a supervisor or carrier representative countersigns** | *"place in the driver's **qualification file**"* — a named document set per driver |
| **FMCSA Drug & Alcohol Clearinghouse Consent for Limited Query** | Consent for TCG to run a **limited Clearinghouse query once each year** while employed | *"if I refuse to provide consent… Company **must prohibit me from performing safety-sensitive functions**, including driving a commercial motor vehicle"* — a hard dispatch eligibility gate, renewed annually |
| **Acknowledgement of Receipt of Drug Policy** (new hire) | Acknowledges the Drug-Free Workplace Program Policy under 49 CFR Part 382 and Part 40; consent to release results to the **MRO** | *"Refusal to submit… may result in disciplinary action, including but not limited to **suspension (with or without pay)** or termination"*. Footer: *FMCSA Policy revised 4/2025*. *"This certificate should be retained in a **secured file**"* |

**The annual Clearinghouse consent is the operationally significant one**: it is a *recurring*
compliance artefact with an expiry, like a certification, and its absence removes the employee from
safety-sensitive work. FCC's certificate catalogue has `MEDICAL` (Medical Card, 24-month) and `DL`
(Drivers License, 60-month) but **no Clearinghouse-consent entry**
([fcc-employee-master-reference-data.md](fcc-employee-master-reference-data.md) §6), so the annual
renewal is tracked outside the certificate system, if at all.

The drug-policy acknowledgement has an **Employee Social Security Number** field on the form.
The copies in this drop are **blank templates** — no employee data is present in them, and none has
been copied here. Recorded because it means executed copies of this form are SSN-bearing documents;
the form's own instruction to keep it in a secured file applies to any ERP that stores it.

## 5. Open, and not answered by any of these documents

- **Is the absence request an ERP workflow?** Every other value engine in this drop ends in a
  system; this one ends in two signatures. Nothing says where an approved absence is recorded, or
  whether it becomes a payroll classification (`SICK` / `ADMIN PTO` / `BER`) automatically.
- **Which of the 19 checklist destinations the ERP is expected to replace or integrate with** — the
  checklist is a description of the current state, with no target.
- **Whether Military, Jury Duty and Maternity/Paternity absences are paid**, and under what rule.

## Source

| File | Format | Covers |
| --- | --- | --- |
| `TCG_Value_Engine_SAMPLES-ONLY/2026-06-23 samples/Union Employee Onboarding.pdf` | PDF, 1 page, `pdftotext -layout` | §1 |
| `TCG_Value_Engine_SAMPLES-ONLY/2026-06-23 samples/Non Union Employee Onboarding.pdf` | PDF, 1 page | §1 |
| `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG HR - Union and Non Union Employee Onboarding Template.docx` | 2.4 MB `.docx` → pandoc | §2 |
| `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG HR- Union and Non Union Onboarding Checklist.pdf` | PDF, 3 pages | §3 |
| `1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/Day off Request.docx` | `.docx` → pandoc, tables preserved | §4.1 |
| `…/TCG Driver's Receipt Form 03-20-2026_Final.pdf` | PDF, 1 page | §4.2 |
| `…/TCG Drug & Alcohol Clearinghouse Consent 03-20-2026_Final.pdf` | PDF, 1 page | §4.2 |
| `…/TCG New Hire Acknowlegement of Receipt of Drug Policy 03-20-2026_Final.pdf` | PDF, 1 page | §4.2 |

The onboarding value engines are Visio-style flowcharts rendered to PDF; branch structure is read
from the `-layout` spatial rendering. All four forms are **blank templates** — no completed copy,
and therefore no employee data, is present in any of them.

---
title: Safety Discussion — onboarding and safety training, the certification matrix, accident / injury / incident reporting, facility compliance, and a dev environment (29 September 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-09-29_Safety discussion - transcript.docx"
migrated: 2026-10-01
updated: 2026-10-01
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/payroll, module/quotations, module/dispatch, module/admin, kind/meeting-notes, safety, certifications, inspections, incidents, adp, samsara, environments]
entities: [employee, certification]
meeting_date: 2026-09-29
---

# Safety Discussion — onboarding, certifications, incidents and facility compliance — 29 September 2026

Curated from [transcripts/2026-09-29-safety-discussion.md](transcripts/2026-09-29-safety-discussion.md)
(1 h 6 m 24 s, the regular CC/TCG ERP slot). **ehtesham.anwar** led the call as the first discovery
session for a **Safety and Compliance module** (*"eventually we need it as a module within the ERP"*,
5:02). TCG speakers: **Dennene "Dee" Jones** (Safety Manager), **Joe Schacatano** (VP of Sales),
**Melissa McNutt** (President), **Brian Petros**, **Corrina Bustos**, **Micaela Dipane**, and "IT
Support" (probably **Patrick McKiernan**, IT Manager). CodingCops: ehtesham.anwar, abdulrehman,
syed.haris.

> **Speaker labels are wrong for most of this call.** Dee speaks on Brian Petros's microphone. Every
> safety-process statement below that the transcript labels "Brian Petros" is attributed here to Dee.
> The transcript header lists the evidence and the turns that are probably Brian's own.

> **Everything in §2–§7 is TCG describing its current, largely manual process and what it would like.**
> It is a first-hand source for requirements discovery, not an agreed spec. The vault had **no safety
> module** before this call (`STRUCTURE.md` has a `safety` tag and no module folder), and no ticket
> exists for it. ehtesham.anwar agreed to each idea in principle ("absolutely"), but nothing was scoped,
> prioritised or signed off. The file is `status: unverified`, and no decision note was written.

## 1. Before the safety topic: field-worker login by e-mail (2:06–4:45)

- **abdulrehman asked why the mobile app allows login by phone number only**, when ADP onboarding
  invites employees by e-mail.
- **Corrina (2:36):** ADP holds the employee's **personal e-mail and their work e-mail**. The employee
  chooses which one gets notifications. She didn't know why the app is phone-only.
- **ehtesham.anwar (3:17–3:38):** keep the phone number for field workers. Field staff who aren't
  tech-savvy often sign up with a relative's or friend's e-mail, but *"phone number is always going to
  be theirs"*. The ERP should still **store the e-mails** that ADP has.
- **abdulrehman (4:29):** *"either they can log in via e-mail or they can also log in via phone"*.
  This was a developer proposal. Nobody from TCG confirmed it.

## 2. New hire → safety onboarding and training (Dee, 5:46–11:04)

**What happens today:**

1. HR sends Dee a chat message that someone was hired, with their **phone number and e-mail**.
2. Dee welcomes them and asks for their **shirt size for PPE**.
3. She asks for a **copy of their ID**, to print the **chain of custody** for the **drug test**.
4. She asks for a copy of **every credential they already hold** (forklift, OSHA, and so on), *"so I
   don't double make them take classes that they already have credentials for"*.
5. She sends a **calendar invite for the first day**.
6. Once the first day is scheduled, she enters them in an **external training platform** and
   **pre-assigns online safety trainings by position**. She gives them a login.
7. **Position-specific documents must be signed.** For example, **CDL holders** sign certain documents.
8. **First day:** drug test → **instructor-led training first** (CPR, safe driving, depending on
   position) → then the online trainings.

**The external platform** is **"Step" from Gallagher**, TCG's insurance **broker** (Joe, 44:34). It
is free and was adopted about two months ago. The name was spelled out on the call as "STEP"; the
exact product name is unconfirmed.

**Dee's ask (6:44):** when a new hire is set up in ADP, **pre-assign their safety trainings
automatically**, because *"it's the safety trainings that they got to get done so we can stay
compliant"*.

**ehtesham.anwar's response:**

- Possible if the platform allows integration, *"just like we are doing with ADP"* and Samsara. The
  assignment would follow rules TCG supplies.
- There are **two kinds of training**: in-house instructor-led and online. The ERP **needs a way to
  record in-house training results** (9:24, Dee agreed).
- **abdulrehman and Haris are to check whether Step has an API** (10:25, 11:04).

## 3. Certifications, the expiry matrix, and self-upload (11:41–20:52)

**Documents collected from new hires:** TWIC card, CPR card, crane operator certification, forklift
safety training and other certificates. They are kept **both digitally and on paper**. **Every
document has an expiration date** (Dee, 12:27).

**The matrix (screen-shared, 13:00–17:55).** This is an Excel workbook in the Safety team's Teams
files. The transcript names it *"DQ Fox 2026 matrix"*, probably *DQ (driver qualification) files*.

- A **roster** tab lists each employee and the **expiry date of each certification**, all entered
  **by hand**.
- It shows status as **expired / 30 days out / 60 days out / good**, and can be sorted.
- When an employee leaves, they are moved to a **past-employees file** and drop off the matrix.
- **Each operator also has an individual folder** of their documents, searchable by name.
- Dee saw the resemblance to the ERP's **employee attached documents**. She asked whether safety should
  live there or in a separate safety section of the employee (18:11).
- **ehtesham.anwar (18:17):** most of this goes **into the employee profile**, replacing the separate
  sheets. He called it *"pretty basic stuff"*. His one concern was the Step integration.

**Self-upload and verification.**

- **Joe (19:07):** when a certification is about to expire and the employee is alerted, they should be
  able to **upload a photo of the renewal in the app** and have it update the record, instead of
  handing a copy to Dee.
- **ehtesham.anwar (19:44):** this will be in the field employees' mobile app. He asked whether
  uploads should be auto-accepted.
- **Dee (19:55): no auto-accept.** She wants to *"see that it's uploaded and then verify it"*.
- **ehtesham.anwar (20:10):** a **verification queue** in the matrix. Dee accepts or rejects with a
  reason, and **the reason goes back to the employee's phone**.
- **Alerts (Dee, 20:32): at 60 days, at 30 days, and before it goes red (expires).** ehtesham.anwar:
  these will be automatic, with no setup needed.

> **Compare with the existing requirement.**
> [FR-FOP-033](../field-ops/frd-new-format-draft/05-functional-requirements/fr-fop-033-certification-expiry-notification-and-upload.md)
> (Confluence, `unverified`) already specifies an expiry alert, a renewal upload, a review status, and
> *"certification approval is not automatic"*. That agrees with Dee. It differs in two details:
> FR-FOP-033 names **HR/admin** as the reviewer, and here the reviewer is **Safety (Dee)**. FR-FOP-033
> says alerts are *"per configured rules"*, and here Dee named **60 and 30 days** and ehtesham.anwar
> said no setup would be needed.

## 4. Customer- and site-specific qualifications for Sales (20:57–26:47)

- **Operators don't all hold the same certifications, so not all of them can go to every job.**
  Sales regularly asks Dee who is authorised for a site.
- **Examples:** **Union Pacific Railroad** and **BNSF** site passes, which need a class that only some
  operators have taken. There is also **a document listing which operator may operate which specific
  crane** (22:03).
- Today Dee keeps these in shared-drive folders **sorted by certification type** and updates them by
  hand.
- **Dee's ask (21:16):** Sales can **filter employees by certification** and see **when each one
  expires**.
- **Joe's proposal (23:04–24:03):**
  - Add a **dropdown of required certifications "outside of the norm"** on the sales side.
  - Carry it through the quote to the job.
  - When **dispatch is prompted with suggested employees** for the job's assets, show **only those who
    hold the qualification**.
  - When the customer needs copies of the certificates, the export includes **only the selected
    people**. Sales would not have to dig through Safety's records.
- **Joe (25:26–25:53):** information is often *"lost in the translation"* between sales and the job,
  so the requirement must **start at quoting and carry through to dispatch**.
- **ehtesham.anwar (24:03):** a guided **sales flow** is planned. Sales on a customer call answers
  *"do you have guys with these certifications … on this date?"*, sees availability, and ends by
  creating the quotation. This was **deprioritised until the major operations are built**.

## 5. Accidents, injuries and incidents (26:49–49:30)

### 5.1 Terms as TCG used them

- **Accident:** typically a vehicle accident. It goes to insurance as a claim.
- **Injury:** goes to **workers' comp**.
- **Incident:** *"something broke or something went wrong during the job. It's not necessarily an
  accident … Still, we have to report it"* (Dee, 35:53). Incidents are investigated **in-house**.

### 5.2 How it works today

- **Reporting chain (36:38):** field employee → **their manager** → the manager posts in a Teams
  **incident chat** → Safety takes over. *"Kyle plugs the address in the chat right now"* (Dee,
  37:47). ehtesham.anwar asked *"is that manager Kyle? Crane Super"*, and no answer was captured. The
  org chart lists **Kyle Harlow** as VP of Fleet and Field Operations and **Jeff Kelley** as Crane
  Superintendent, so which "manager" posts it is unconfirmed.
- **Safety goes on scene whenever it can (32:57, 33:36).** For every accident, preventable or not,
  Safety **picks up the employee and takes them for a drug test**. It does the same when damage is
  found only after the crane returns to the yard (34:26).
- **Employee incident report:** a **handwritten legal document**. Crossings-out and misspellings
  *"reflect"* on the company. Employees often wait for Safety rather than write it themselves.
- **Photos** are texted from the employee's phone.
- **The investigation** is written up as a **PowerPoint deck with images**, which TCG calls an
  **"IRCR"** (the transcript's spelling).
- It is filed in Teams under **incident reporting → *year* accidents**, one folder per event, named by
  **date and employee**.
- **Vehicle accident → insurance claim (38:58–40:08).** Dee sends an **e-mail from a fixed template**
  with the pictures to the insurer. The whole claim, including any **police report**, stays **in that
  one e-mail thread**. TCG has **no in-house claims team**.
- **Injury → workers' comp (43:25–45:21).** It follows the same flow through the broker **Gallagher**,
  who involves the insurer. **Joe (45:15): the insurer gets the same documents, no different format.**
  **Light duty** must then be accommodated.
- **Incident → in-house investigation (40:13).** Safety determines what happened and whether it was
  **preventable or non-preventable**, works out a solution so it doesn't recur, and coaches the
  employee.
- **On a customer's site**, for example **Edison's yard**, the customer's own claims process applies
  as well. TCG enters the same information on **Edison's platform**. TCG's own investigation does not
  change (41:05–42:07).

### 5.3 What TCG asked for

- **Report on the phone, not on paper.** The employee starts the report while waiting for Safety,
  *"while their memory is fresh"*.
  - **Dropdowns** (name and the rest), so that the data can be aggregated.
  - Typed text with spell check.
  - The form **prompts for photos** while they type.
  - The **employee's signature is still required, and e-sign is acceptable** (32:36).
- **Alert Safety with the crew's location.** ehtesham.anwar proposed sending the job address, or the
  **live location** if the crew is en route (37:59).
- **Emergency contacts shown to Safety immediately** when an event is raised (Joe, 37:02).
- **An auto-accident form** filled in by the driver, which populates the report (Joe, 37:02). TCG will
  share its forms.
- **Close-out with sign-offs (Dee, 42:15–43:06).** An accident, injury or incident **isn't closed**
  until:
  - the investigation is complete and all information is gathered;
  - the employee has been coached;
  - a preventive solution exists;
  - it has been reported and communicated.

  Each step must be **checked and confirmed by Safety, the employee's manager, and the employee**.
- **Track the claim lifecycle:** claim sent, case closed, the employee on light duty or continuing.
- **Build an evidence package** (46:08–47:43):
  - pull in the vehicle's **pre-trip / post-trip inspections** (whether the driver reported a defect
    beforehand);
  - the **vehicle's repair status** (whether it was dispatched before or after a reported repair);
  - for injuries, **when the employee was trained** not to do what caused it.

  ehtesham.anwar: an **audit trail** from which Safety selects items into the packet. *"You guys need
  to show to the agencies that we did everything to prevent this."*
- **Samsara (Joe, 46:05):** tie in Samsara events such as **speeding**.
- **Trend reporting (Melissa, 45:47; Dee, 27:17).** Reports on certifications, **accident status**,
  **leading causes**, and **employees involved repeatedly**. *"We don't have anything like that right
  now."*

### 5.4 Corrective action (47:46–49:30)

- **abdulrehman** asked whether the system should record **disciplinary action** when an investigation
  finds operator negligence.
- **Dee:** if it was preventable had the employee followed the **SOP**, they are **retrained and
  coached**. Depending on the situation, it is **escalated to HR** for a write-up or other next step.
- **Joe (49:00):** use the term **"corrective action"** for every case, *"because corrective action
  could be retraining … could be disciplinary action"*.

## 6. Vehicles, the shop, and facility compliance (49:33–54:58)

- **Vehicle compliance overlaps with maintenance (49:33).** Vehicle certifications and qualifications
  belong to **Jeff Stricker** (Fleet Manager). The example given: a crane returns with a headlight out,
  and it matters whether it went back out **before or after the repair**.
- **Joe (50:26):** anything **out of compliance**, whether found by maintenance or the shop, **must be
  posted to Safety**, so Safety can make sure it is back in compliance.
- **Monthly facility walkthrough (Dee, 50:46–54:48).** Dee implemented it recently as a **QR-code form
  filled in on the phone**, with pictures. The goal is *"anybody can do it"*.
  - **It covers** fire extinguishers, eye-wash stations, walking-working surfaces, daisy-chained
    extension cords, first-aid kits, ladder inspections and fall-protection inspections.
  - **It spans the whole facility**, including the mechanics' warehouse and the yard.
  - Each walkthrough is **scored**. Results land in a **spreadsheet**, compared **month over month**.
    *"We want to be all blue."*
  - **Example:** after repeated fire-extinguisher notes, a safety auditor numbered and tagged every
    extinguisher.
  - **The ask:** automate it. The purpose is to be ready for any agency visit: *"we don't want to have
    any violations."*

## 7. Regulatory submissions and a compliance calendar (54:58–57:58)

> **Answered the next day.** Dee sent the list as a spreadsheet on 2026-09-30, and it confirms **CERS** and **CUPA**. It is recorded at [../field-ops/safety-compliance/07-environmental-compliance-calendar.md](../field-ops/safety-compliance/07-environmental-compliance-calendar.md). With it she sent the AbInBev360 reference spec for accident and injury reporting: [../field-ops/safety-compliance/06-safety-data-platform-requirements-spec.md](../field-ops/safety-compliance/06-safety-data-platform-requirements-spec.md).

- **Regular regulatory submissions** include **CERS** and **CUPA** (the California Environmental
  Reporting System, and the local agency it reports to). *"California has the most stringent
  submissions"* (55:16). The acronyms are corrected from the ASR text; see the transcript header.
- **ehtesham.anwar asked Dee for the list of every submission and what goes in each**, so that the
  ERP can generate them from its own data (55:30, 57:28).
- **An automated compliance calendar with alerts (Dee, 55:49–57:07).** Some obligations are due monthly,
  yearly, every two years or every five years. Today Dee keeps them on her personal calendar and gets
  no alert.
  - **Examples:** the **annual sprinkler-head inspection** and the **annual exit-sign illumination
    check**.
  - The point is documented proof: *"I'm held to that whether someone's coming or not."*

## 8. Not covered — next session

- **Melissa (52:07):** **daily observations / field audits** were not reached. *"Let's make sure we get
  there."*
- **ehtesham.anwar (52:24, 1:02:50):** Dee's Teams folders include **job audits** and **next-day job
  audits**. These are to be discussed in detail **on Thursday** (1 October 2026).
- **Also Thursday:** the **configuration change** that ehtesham.anwar has open questions on, with Joe,
  and a prototype to show Joe (5:02, 1:03:39).

## 9. Not safety: a separate dev environment, and testers (58:02–1:02:50)

- **The problem (abdulrehman).** There is **one environment**. The dev team pushes daily updates to the
  same portal that TCG is testing on, which can break things.
- **The ask:** approval for a **separate dev environment**. The current portal would become production,
  and a **dev subdomain** (*dev.craneguys.com*) would run the same **ECS containerised** stack on AWS.
- **Cost:** roughly **double the current AWS cost**. abdulrehman proposed starting it with **minimal
  resources**.
- **IT Support (59:04):** a QA environment *"wouldn't be a problem at all"*. They will put numbers
  together for *"the powers that be"*. **They asked for a release routine from QA to production**
  (59:58). ehtesham.anwar: a release process will come with the second environment.
- **Status: pending TCG's cost approval**, not approved. The environment naming ("dev", "QA", "stage")
  was not settled on the call.
- **abdulrehman asked TCG for at least three testers**, one each from **sales, dispatch and the field
  workers**, to test the **quotation workflow**, which he described as *"completed except some minor
  updates"* (1:02:09).

## 10. Questions this raises (not yet filed)

None of these were answered on the call. When a ticket takes up the safety module, they belong in its
spec §12. Until then, they are candidates for a module `gaps.md`. There is no safety module folder yet,
and `field-ops/` is the nearest one.

1. **Who reviews an uploaded certification: Safety or HR/admin?** FR-FOP-033 says HR/admin. On this
   call, Dee said she verifies.
2. **Is phone-or-e-mail login for field workers wanted?** It was proposed by abdulrehman and not
   confirmed by TCG.
3. **Which certifications are "outside the norm" and customer- or site-specific?** And is the
   operator-to-specific-crane authorisation a certification, or a separate list?
4. **Where does the safety module live:** in the employee profile, or in a separate Safety section?
   ehtesham.anwar leaned towards the employee profile, and Dee asked the question without answering it.
5. **Does Step (Gallagher) have an API?** Assigned to abdulrehman and Haris on the call.

---
title: ADP Integration Sync — onboarding stays in ADP, three employee types, three weekly worksheets, temp rate and the paydata CSV (28 September 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-09-28_ADP Integration Sync - transcript.docx"
migrated: 2026-09-28
updated: 2026-09-28
status: unverified
conflicts_with: [decisions/2026-06-30-adp-erp-employee-data-ownership.md]
jira: []
tags: [module/payroll, module/admin, kind/meeting-notes, adp, integrations, onboarding, employee-types, craft-code, craft-modifier, boom, temp-rate, paydata-csv, earning-codes]
entities: [employee, adp-company-code, adp-code]
meeting_date: 2026-09-28
---

# ADP Integration Sync — onboarding, employee types, weekly worksheets, temp rate and the paydata CSV — 28 September 2026

Curated from [transcripts/2026-09-28-adp-integration-sync.md](transcripts/2026-09-28-adp-integration-sync.md)
(1 h 8 m 51 s). Labelled speakers: **abdulrehman** (who called the meeting), **Brian Petros**,
**Corrina Bustos** (payroll, sharing her ADP session) and **Micaela Dipane**. syed.haris and
umer.islam were invited during the call but have no labelled turn.

**Purpose (abdulrehman, 3:48).** The ERP can create employees, log hours from the field app and
calculate ST/OT and long-boom hours. The blocker is that **ERP employees are not linked to ADP**.
The call was for Corrina to show how she hires an employee in ADP and runs payroll against them,
so the team can see how far the ADP API can automate it.

> **Most of §1 is TCG describing its own current process in ADP.** That makes it a first-hand
> source for how payroll works today. It is not a requirement for the ERP. Nothing here has been
> checked against ADP itself, and the file is `status: unverified`.

> **One statement on this call reverses the direction of a verified decision.** See §5.1. No
> decision note was written. Recording a decision is `tcg-scrum`'s job, and the call ended with no
> explicit sign-off.

## 1. What TCG showed and said about ADP today

### 1.1 Company codes and a test company

- **`4RZ` is the live company** (*"our Crane Guys one"*, Corrina 6:43).
- **`4RY` is *"a dead code"***, made *"because we were going to use it for something else, but
  they're deleting it"* (Corrina 6:43, 14:33). ADP was about to cancel it. At abdulrehman's request
  (13:46), Corrina went to tell ADP **not** to cancel it, so it can serve as a test company (14:11).
- **`4RY` can't take a new hire as it stands.** Corrina tried and stopped: *"none of this is set up
  … we haven't set up this company code on the back end, so it's not going to let me proceed with
  a new hire"* (15:21). abdulrehman had also noted it has no pay codes or other required data (13:12).
  The test hire was done in **`4RZ`** instead (16:06).
- **abdulrehman on the sandbox (6:58):** ADP support says there is **no separate sandbox
  environment**. This matches the vault's 2026-08-17 finding.
- **An SSN is required to create an employee** (Corrina 7:39). Brian posted the SSA's
  never-issued test SSNs to the Teams general channel (9:08–10:03).

### 1.2 New hire in ADP (Corrina, 10:10–18:39, screen-shared)

Path: **Process → HR Dashboard → Hire someone → "HR + Payroll TCG"**. The TCG template is custom.
The other two templates are generic ADP ones that TCG doesn't use (1:07:06).

1. Enter name and contact details. ADP **auto-generates the associate ID**.
2. Set the hire date, reason (*existing position*) and company code **4RZ**.
3. Pick the onboarding **packet**. There is **one for union and one for non-union** employees.
4. Set **worked-in state** (*"these are the four we have so far"*) and **lived-in state**. FLSA
   *does not qualify*. I-9 is electronic. No work address.
5. Save. **ADP e-mails the new hire**, who completes their profile, taxes, emergency contacts, I-9,
   signs every company policy, and uploads certifications. A **driver's licence is required**.
   TWIC, NCCCO and anything else are optional. Corrina approves or rejects each document.
6. ADP tracks each step (not started / in progress / completed). At *completed* the profile is
   live, and **ADP generates the file number / position ID** (18:46).

- **Everyone goes through ADP.** That covers field, office, owners, and **temps / fill-ins / vendor
  employees alike** (8:52, 19:02–19:27). **ADP doesn't distinguish a temp**: *"They look the
  same"* (26:39). *Fill-in* is a union term that exists only in TCG's own records (26:41).
- **ADP keeps every person's whole history.** Someone who filled in 12 years ago was reactivated,
  not re-hired from scratch (31:34).
- **Fill-ins are hired and terminated in ADP every time they start and stop working** (23:03).

### 1.3 Employee types and the pay profile

- **There are three pay types: union hourly, non-union hourly and salary** (Corrina 26:00). There is
  no separate temp type (26:15). Non-union hourly people work either in the office or in the yard
  (35:04).
- **Pay profile** (35:04–37:23), under *People → Pay profile*:
  - **Salary:** the annual salary is entered, and ADP breaks it down per pay period and per hour.
  - **Hourly:** the hourly rate, **standard hours 40**, and **pay frequency always weekly**. There
    is no daily pay. A change of rate needs a **reason** and can't be left blank.
  - **"Eligible for qualified overtime compensation"** must be checked for **every hourly
    employee**. Corrina called it *"a bill that got passed this past January"*.
  - The profile also holds deductions, tax withholding, PTO, year-to-date accumulators and yearly
    tax statements.
- **Corrina enters deductions herself.** The employee doesn't, because deductions *"are different
  for every employee depending on what they qualify for"* (37:44).
- **Setting up a union employee** (Corrina, 52:56–55:20, on abdulrehman's test hire):
  - **Worker category `L12` (Local 12)** is set **only** for Local 12. It is left unset for
    non-union employees.
  - **Insurance code** is required on **every** person, by insurance group.
  - **Home department** is one of **field, salary, admin or yard**. *"Field is all union people."*
  - There is also a benefits flag and status *active*.
- **No direct deposit.** *"All payroll is live checks"* (55:27–55:40).
- **Craft code and craft modifier are not held in ADP.** abdulrehman at 1:02:04: *"these groups and
  craft code and craft modifier information, we don't have that in ADP."* Corrina: *"Yes."*

### 1.4 Running payroll: the Payroll Dashboard and three worksheets

Path: **Process → Payroll → Payroll Dashboard**, then the current week (due date, days left, pay
period, pay date), then **Manage payroll** (Corrina 37:52). This is the new Payroll Dashboard
screen, not the classic *Payroll Cycle* screen. See §5.3.

**There are three worksheets every week** (Corrina 41:47–42:06):

| Worksheet | Who is on it | How it gets there |
| --- | --- | --- |
| **Salary sheet** | All **office / admin** staff, salaried **and** hourly | Keyed and verified by Corrina. She adds PTO, sick, bereavement, on-call pay, and subsistence pay (*"a special agreement"*). |
| **Time-off worksheet** | Only employees who **qualify** for PTO / sick | Added by hand every week. It is how ADP knows to accrue PTO for the hours logged. |
| **Field worksheet** | **Union hourly** field employees, plus **non-union yard** (Samuel Capp given as a non-union yard example, 46:03) | Made by **importing the CSV**, which ADP turns into a worksheet with every pay code filled in (46:03). |

- **Union employees get no sick leave or PTO**, under their union agreement. Regular non-union
  field (yard) staff do (42:29).
- **The CSV only creates columns for codes it uses.** If someone worked lattice operator, that
  column appears (47:17).
- **Salaried payroll is triggered manually too**, not automatic (33:49).
- **Salaried staff are not in TCG's current ERP (FCC).** Corrina: *"they said they already factored
  all that into the burden rate"* (43:14). She called whether the new ERP should hold them *"an
  ownership question"*.
- **Rate increases are keyed twice today.** Brian updated the recent union rate increase in FCC,
  and Corrina still has to update everyone again in ADP (53:47).
- **ADP doesn't show the history of a past week's import** (45:31). To show one, Corrina
  re-imported a saved CSV that Micaela had kept.

### 1.5 Temp rate, rate multipliers and the long-boom rows (Brian and Corrina, 48:09–1:02:53)

- **Earning codes are the same across the two company codes** (Brian 48:09). There are validation
  tables under ADP setup.
- **A code's rate multiplier is hidden.** Brian asked ADP (Josie) where the multiplier on OT/DT is.
  The answer was *"it's built into the background"*. You can't see it (48:24).
- **A temp rate overrides the base rate for the whole row.** Brian 50:15: *"if there is a temp rate
  on that row, everything on that row is affected by that temp rate … it overrides the base
  rate."* Without a temp rate, the row uses the employee's rate (shown as `H 69.66` in the demo),
  and OT/DT apply their hidden multipliers.
- **A temp rate is not only for boom hours.** It can apply to regular, OT and DT hours when a job
  owes a different rate. Corrina's example (50:58): Carlos, base **68.87**, was owed **72.16** for
  6 h ST, 1.5 h OT and 0.5 h DT on one job.
- **So a different rate needs a separate row.** Boom regular, boom OT and boom DT are three
  columns. If the adder differs between ST and OT, that is a separate row with its own temp rate
  (49:18, 1:02:24).
- **The long-boom value depends only on boom length.** It starts at about 80 ft and goes up in 20 ft
  steps (Brian 1:00:43). Crane size and craft code don't affect it. Corrina 1:00:13: *"It doesn't
  matter what size crane they're in."* And at 1:01:50: *"they could be in craft code group 9, but
  still qualify for craft modifier 80 to 100 feet … those two don't really correlate."* So **one
  `LB` code can carry different amounts**, and the amount is in the temp-rate field (1:01:25:
  *"It looks to the temp rate field … $3 per hour, $2 an hour"*).
- **Every hourly employee has hours in regular, OT or DT.** Long boom is occasional (1:02:40).

### 1.6 The import file `EPI4RZ36.csv` (Brian, 56:40–59:23, Project Repository → HR → *PAYROLL for ADP v5.1 – current*)

- It's the file **created to import into ADP**, not something ADP sends back (57:07).
- ADP's worksheet shows the **employee name** where the file has the file-number column (57:30).
- **Columns come in pairs.** A code column is followed immediately by its amount column, and ADP
  links them purely by order (57:53, 59:05).
- **ADP has two code types, 3 and 4.** Brian was told the difference doesn't matter for TCG's
  setup. He **made every code that goes with a temp rate a type 4**, *"just to make it easier to
  recognize"* (57:53).
- Brian has **documentation specific to the import file** (1:05:02). The same day, a OneDrive drop
  held ADP's generic *Importing Paydata* guide (the `wfn_importing_paydata.pdf` already in
  [../payroll/source-manifest.md](../payroll/source-manifest.md)) and a 2022 ADP *Payroll Dashboard
  vs Payroll Cycle* guide. Whether either is what Brian meant hasn't been confirmed.

## 2. What was agreed on the call (none of it signed off as a decision)

- **Onboarding stays in ADP, and the ERP links to it.** abdulrehman summed up (31:13–31:22):
  *"keep this onboarding process within the ADP and … there would be always an employee present in
  the ADP and we just need to bind their file number in our ERP in order to process the payroll."*
  Corrina: *"Yes, yes"* (31:34). Brian had proposed it at 22:04. **This conflicts with the
  2026-06-30 decision; see §5.1.**
- **Corrina wants fill-ins activated and deactivated from the ERP** (23:03): *"have a trigger …
  their profile can be activated or deactivated through the ERP and then it links to ADP, because
  every time there's a fill-in, we have to go in and hire them and then terminate them."*
  abdulrehman: *"Okay, yeah, we can do that"* (23:55).
- **Phase 1 covers union field employees only.** abdulrehman (42:42): the ERP calculates union
  field payroll, and every other type stays in ADP, handled by Corrina as today. Brian: *"I think
  so"*. Corrina's reply was the ownership question in §1.4. Corrina confirmed at 1:07:43 that union
  **mechanics** are not included yet either. abdulrehman: *"our goal is just first to figure out all
  the ADP and ERP things for the union employees"* (53:21).
- **The API writes a worksheet, and Corrina still approves it.** Brian (40:16) expects the API to
  *"send it into this worksheet, and that'll be the end point"*. Corrina reviews and pushes it
  through by hand, as she does with the CSV today. Corrina: *"Yeah."* abdulrehman: once all types
  are in the ERP, all three worksheets could be filled by API, but phase 1 is the field worksheet
  (43:35).
- **Testing happens in the live `4RZ` company, with test employees.** Brian's suggestion (1:05:08):
  a test API post will most likely appear as a **separate worksheet** under Manage payroll, which
  Corrina deletes. Corrina: *"We'd have to delete it."* Brian (1:05:50): coordinate with Corrina,
  *"let her know ahead of time"*, *"we might as well test it"*, after checking with ADP support.
  abdulrehman: the team has only made GET calls so far, because a POST would land in Corrina's real
  payroll (1:05:48).

## 3. Dev-team statements of intent (no ticket, no written scope)

- **Test employees (1:06:20–1:06:55):**
  - abdulrehman was hired during the call as a **union hourly oiler** (L12) in `4RZ`. The
    self-signup failed with *"invalid record"* until the name matched exactly. It then logged into
    Ehtesham's shared API account and had to be switched (24:33–29:47).
  - syed.haris to be invited as an **operator**.
  - Ehtesham's existing account to be set up as a **rigger or third man**.
  - Corrina offered test employees who can be filtered out of real check runs (1:03:11).
- **Explore the API further**, then ask ADP's technical contact how a worksheet POST behaves
  (1:03:11).
- **Whether the ERP tracks PTO** depends on how far the ERP's HR module goes. abdulrehman said
  that's Ehtesham's call (44:17).

## 4. Actions

- **Corrina** asks ADP **not to cancel `4RY`** (14:11). Status unknown.
- **Brian** contacts **Josie at ADP** about a test account or company with two or three test
  employees, ideally one per pay type (25:06, 27:18).
- **Corrina** invites **syed.haris** (operator) once abdulrehman sends his e-mail, and **re-sends
  Ehtesham** the *HR + Payroll TCG* onboarding, which he can't access (1:06:43, 1:07:27).
- **abdulrehman** completes his ADP onboarding as the test oiler.
- **Brian** has import-file documentation; abdulrehman asked for any TCG-specific ADP setup notes
  (1:04:13–1:05:02).
- **Dev team** explores the API. A follow-up with ADP's technical contact is to be scheduled if
  blocked (1:08:02).

## 5. Where this meets the vault

### 5.1 Conflict: where the employee lifecycle starts

[../decisions/2026-06-30-adp-erp-employee-data-ownership.md](../decisions/2026-06-30-adp-erp-employee-data-ownership.md)
(`status: verified`, Brian Petros + Ehtesham Anwar) says: *"The ERP **initiates**, ADP
**performs**, the ERP **records the result**"*. The ERP creates a pending record and pushes
creation to ADP.

On this call **Brian argued the opposite** (22:04): *"It seems more natural for the employee
information to originate in ADP. First."* Corrina agreed, and abdulrehman restated it as the
working assumption (§2). The rest of the decision's ownership table still holds: ADP owns the
legal record, and the ERP stores the file number and never generates it.

**Not resolved here.** The same person has moved position, and the earlier record is verified.
This needs `tcg-scrum` to record a superseding decision (or a confirmation of the old one) with
Brian and Ehtesham. Registered in [../payroll/gaps.md](../payroll/gaps.md) → *Where the employee
lifecycle starts — ERP-initiated (06-30) or ADP-first (09-28)?*

### 5.2 Consistent with the vault

- **No client sandbox.** This matches [../payroll/gaps.md → *ADP product, API Central entitlement
  and sandbox*](../payroll/gaps.md#adp-product-api-central-entitlement-and-sandbox). That entry's
  "test company requested from TCG 2026-08-17" now has a partial answer (§1.1, §2).
- **`4RY` is dormant.** The 2026-08-13 API finding matches, and Corrina settles that entry's
  residual "future use or legacy?" question as **legacy, being deleted**, though it may now be kept
  for testing. It was described as *"made for something else"*. The vault's label for it, "The
  Crane Guys, LLC - Ventura", was not mentioned.
- **Long boom depends on boom length, independent of craft group.** This matches the
  `FMS_UNION_CRAFT_MODIFIER` finding in [../gaps.md](../gaps.md) (retired, historical).
- **Temp-rate rows**, one per `File # + code + temp rate`. This matches
  [../payroll/adp-workbook-power-query-engine.md](../payroll/adp-workbook-power-query-engine.md) and
  [../payroll/adp-workbook-column-rules.md](../payroll/adp-workbook-column-rules.md).
- **The three populations.** This extends [../payroll/gaps.md → *Payroll has three populations, and
  the ERP has scoped one*](../payroll/gaps.md#payroll-has-three-populations-and-the-erp-has-scoped-one--work-orders-yard-techs-and-salaried-staff):
  the salaried route to ADP is now known (a hand-keyed salary worksheet), and so is where yard
  labor lands (the field CSV).

### 5.3 The ADP screens have moved

The vault's ADP documents are keyed to **classic WFN** ([../payroll/gaps.md → *ADP product…*](../payroll/gaps.md#adp-product-api-central-entitlement-and-sandbox),
[../payroll/adp-read-write-boundary-2026-08-18.md](../payroll/adp-read-write-boundary-2026-08-18.md)).
Corrina runs payroll from **Payroll Dashboard → Manage payroll**, the new screen flow that ADP's
2022 guide maps from the classic *Payroll Cycle* screen. [../payroll/adp-sop-v5.1.md](../payroll/adp-sop-v5.1.md)
already describes the same path. **Unconfirmed:** whether this is just the new screens inside
classic WFN or the "Next Generation" upgrade Patrick mentioned on 2026-08-24.

## Where each item is registered

| Item | Registered in |
| --- | --- |
| §5.1 lifecycle direction | [../payroll/gaps.md](../payroll/gaps.md) → *Where the employee lifecycle starts — ERP-initiated (06-30) or ADP-first (09-28)?* (new) |
| §2 activate/deactivate fill-ins from the ERP | [../payroll/gaps.md](../payroll/gaps.md) → *Fill-in field employees vs the ADP-onboarding dispatch block* (update) |
| §1.1, §2 test company and testing in `4RZ` | [../payroll/gaps.md](../payroll/gaps.md) → *ADP product, API Central entitlement and sandbox* (update) |
| §1.1 `4RY` legacy / being deleted | [../payroll/gaps.md](../payroll/gaps.md) → *Ventura — a second ADP company nobody has mentioned* (update) |
| §1.4, §2 three worksheets, phase 1 union-field only, salaried not in the ERP | [../payroll/gaps.md](../payroll/gaps.md) → *Payroll has three populations…* (update) |
| §5.3 Payroll Dashboard vs classic | [../payroll/gaps.md](../payroll/gaps.md) → *ADP product, API Central entitlement and sandbox* (same update) |
| §1.3 qualified-overtime flag, L12 worker category, insurance code, home department, live checks | not registered. These are current-practice facts about ADP setup and nothing is asked |
| §1.5 temp rate and hidden multipliers, §1.6 type 3/4 codes | not registered. They are consistent with the existing workbook docs |

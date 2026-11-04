---
title: ERP Demo Walkthrough Part 3 — installing the mobile app, holdover in the DAS, the holdover field ticket, weekly payroll and the ADP export, field beta testers (27 October 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-10-27_ERP DEMO-WALKTHROUGH Part 3 - transcript.docx"
migrated: 2026-10-29
updated: 2026-10-29
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/dispatch, module/payroll, module/accounting, module/admin, kind/meeting-notes, holdover, daily-allocation, das, samsara, subsistence, time-tracking, inspections, signatures, geolocation, craft-modifier, boom, temp-rate, rest-period, adp, earning-codes, paydata-csv, onboarding, quickbooks, fcc, environments, requirements]
meeting_date: 2026-10-27
---

# ERP Demo Walkthrough Part 3 — mobile install, the holdover ticket, payroll and ADP — 27 October 2026

Curated from [transcripts/2026-10-27-erp-demo-walkthrough-part-3.md](transcripts/2026-10-27-erp-demo-walkthrough-part-3.md)
(transcribed 0:42–57:52; the recording header reads 4 h). It continues
[Part 2](2026-10-22-erp-demo-walkthrough-part-2-assets-double-booking-quotation-to-project-das-and-permits.md),
which stopped at progress tracking. **abdulrehman** showed how to install the iOS app. **syed.haris**
showed holdover in the DAS, a holdover day on the mobile ticket with the web job progress beside it, and
the weekly payroll through to the ADP file. TCG speakers: **Kyle Harlow** (VP of Fleet), **Joe Schacatano**
(VP of Operations), **Melissa McNutt** (President), **Micaela Dipane**, **Patrick McKiernan** (IT Manager),
**Brent Wagstaff** (CFO). CodingCops: abdulrehman, syed.haris, ehtesham.anwar, ans.nisar. Roles are from
[../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md).

> **Timestamps.** The long demo turns carry only their start (abdulrehman 5:12, 6:46, 8:16, 48:40;
> syed.haris 12:51, 21:44, 28:16, 30:47, 38:17, 41:33, 46:55). A point made inside one is cited by that
> start time.

> **Status.** §1, §2 and §4–§6 are CodingCops describing what is **built** in the test tenant. TCG raised
> four things of its own: Samsara mileage for subsistence (§3, Joe), *holdover job* instead of *holdover
> crane* (§4, Joe), the scope of a special rate (§6, Micaela) and 30-minute rounding (§6, Melissa). Kyle
> agreed to pick field testers (§7). The file is `status: unverified`.

## 1. Installing the mobile app (5:12–12:51)

- **iOS goes through Apple, not the public App Store.** The app is not published yet, so each person is
  invited one by one (abdulrehman, 5:12). In **App Store Connect** (*Users and Access*) an admin adds the
  person's first name, last name, e-mail and a role (*"maybe developer"*; the role only lets them install).
  The person needs an **Apple ID**. They accept the e-mailed invite, set a password and confirm an OTP. Once
  active, they are added as a tester in **TestFlight**, install the TestFlight app from the App Store and
  open the TCG build from it. They should always install **the latest build** (6:46, 8:16). A redeem code
  is only for someone who was already a tester (syed.haris, 11:36).
- **Android:** CodingCops shares an APK, installed in one click (11:46).
- **Who does it:** the videos and written steps are for **Patrick McKiernan** and **Brian Petros**. TCG
  invites the field workers who need the app (5:12). abdulrehman e-mailed Patrick the document on the call
  (21:15, *"Got it. Thank you."*). The module documentation is also live under the third-last sidebar item
  (20:44).

## 2. Holdover in the DAS (syed.haris, 12:51)

- **A job can be made holdover after it is scheduled**, not only when it is scheduled. *Make holdover* on
  the DAS lets you pick which assets and which resources to hold over. The resources list shows which
  operator goes with which operator load.
- Held-over units carry a **holdover badge**. On the next day the job shows a holdover icon, and whatever
  is allocated to a held-over placeholder carries over to the following day.
- **Copy allocation** covers the units that come back from site each night: copy one day's allocation to
  target days, by shift, all assets / all employees or a selection.
- **Job progress on the web** (*View progress* → progress tracking) shows a completed ticket's pre-trip
  form and photos, left-yard / driving / arrived times — *"all the stuff that we have on the mobile app"*.

## 3. Samsara mileage for subsistence (18:05–19:09, 38:03)

- **Joe Schacatano (VP of Operations), 18:05:** show the machine's **Samsara mileage** on that report, so it
  shows whether the job is in the **short or long subsistence zone** — *"the 45 and the 77 and a half
  mile. So that way it just shows up on the report and we're not having to actually track that
  ourselves."* He repeats at 18:54: *"we just needed to show the mileage though as well."*
- syed.haris: Samsara is integrated. Per-job fuel (from the 10-22 call) is *"already written down"*; the
  job's ticket times will be compared with Samsara tracking to pull per-job figures into reports (18:33).
  He showed an asset's Samsara view: route, distance today, time on site, fuel (19:09).
- **abdulrehman, 38:03:** *"we need to display a short sub and long sub here as well as Joe mentioned"* —
  on the ticket's labor table in job progress. syed.haris: *"Yes."*

## 4. The holdover field ticket on mobile (syed.haris, 21:44–38:03)

Logged in as the oiler (Kevin) on an iPhone, on day 2 of a three-day holdover job (27–29 October).

- **Sign-in:** e-mail and password, or phone number. Home lists active and upcoming tickets (an
  *Upcoming* badge); the Tickets tab filters not started / in progress / completed (21:44).
- **Where are you starting from?** A holdover day asks for the start location. The app offers **Yard**
  (*Pre-Trip → Left Yard → Driving to Site*) and **Home** (*drive straight to the job site · no pre-trip or
  yard departure*). syed.haris also said *"from an hotel"*, but the app has no hotel option. abdulrehman,
  26:00: the rest of the flow follows the choice. The web job progress updated live, side by side.
  syed.haris chose Home and still did the pre-trip, as the step list requires — the Home subtitle is
  wrong (see *Against the vault*).
- **Steps shown:** arrived at job site (system time), pre-trip inspection with photos (crane, then
  tractor and trailer — the oiler does every unit; 21:44); customer's first signature with the terms and
  conditions and a photo; **JSA — Tailboard** with the customer's signature (28:16).
- **Start work:** *"The crane was left set up yesterday … no build up needed today"* — straight to boom
  time. **End work** offers **Leave crane set up** or **Start Breakdown** (28:16).
- **Joe Schacatano, 30:27:** *"Instead of hold over crane where it says [End], can we call it hold over
  job?"* — syed.haris: *"Yes, we can."* The sheet is titled *End Work · holdover crane*.
- **Summary before the final signature:** total work time, build-up, boom time, breakdown, lunch / pause
  and non-boom time. Final signature: name prefilled, a checklist (no damage, work completed as described,
  no accidents or incidents), photo, signature, optional comments. Then *left job site* (30:47).
- **Labor & Unit:** total hours are calculated from the ticket. Then the craft modifier and the boom
  bracket; a pick on one crew member is mirrored to the other (Kevin → Derek; 30:47).
- **Post-trip inspection is required** to complete the ticket — syed.haris had skipped it and was sent back.
  A **deficiency** carries a description and a priority: *low, medium, high* or *emergency — blocking*
  (*"blocking the work on that job or the next day job"*). Review shows the step history, then submit
  (30:47).
- **After submit:** completed tickets can be opened. **Request approval** asks the payroll manager to make
  a ticket editable again to adjust the times (30:47).
- **On the web:** the deficiency count and its detail; the customer signature and photo. The **GPS
  location of the signature** is captured and can be compared with the job location entered on the quote
  (30:47).

## 5. ADP — what is live and what is next (26:50–28:08, 48:40)

- abdulrehman: **payroll is submitted to ADP by API** and the worksheet is created by API. Micaela helped
  last week. **Next sprint:** employee onboarding into ADP. Creating an employee in the ERP would create
  them in ADP and bring back the **file number and position ID**. Status changes (inactive → active after
  onboarding) would sync back. CodingCops is working with ADP support to enable these API capabilities
  (26:50, 48:40).
- syed.haris: after Melissa approved data access, ADP gave access. CodingCops wants to watch the next real
  worksheet submission to see the data arrive. **Micaela:** *"we're going to submit it this afternoon, so
  I'll send you a message when it's done"* (27:44–28:08).
- **Two ways out of the ERP** (abdulrehman, 48:40): **export** the worksheet and import it into ADP by
  hand, as Corrina and Micaela do now; or **Submit to ADP**, which creates the worksheets by API.
  CodingCops recommends the second.

## 6. Weekly payroll (syed.haris, 38:17–48:40)

- **The week view** (24–30 October): approved count (*1 of 4*), total payable, employees and average
  **utilization** — *"right now we are using like 8 hours per day minimum, but we can adjust"* (e.g. 10).
  Filters: needs review, has issues, approved (38:17).
- **An employee's week:** outstanding tickets (here the 29 October holdover day), pay, utilization, ST/OT
  hours, daily summaries (38:17).
- **Manage override** — a special rate replacing the employee's craft-code rate, with a comment (the
  *135.14* from one of Micaela's sheets; 38:17). **abdulrehman asked whether it is for a whole job or a
  single ticket. Micaela Dipane, 40:54: *"It'll be on a specific ticket."*** abdulrehman restated it as
  *"on the job level"*. Micaela, 41:02: *"sometimes it'll only apply to like one job if the employee was
  sent out as an operator and like he gets a different pay rate for that specific … work that he did, then
  that's for the base rate would get and then for that specific [job] ticket."* See *Against the vault*.
- **A ticket's calculation** (41:33): craft code, modifier, start / end, long boom, ST / OT; the
  payroll-manager corrections and resolved flags; the *Shift & pay* rule explanation (ST to 8 h, override
  rate, long-boom ST and OT premium, the **military base premium** chosen on the job, one meal taken and
  one worked through). The breakdown prices each **half-hour slice** and shows its bucket (9–5 ST, OT
  after 5). **Guaranteed hours** — e.g. *"4 hours minimum on a boom"*: two hours worked add two. The
  **rest-period audit** checks for an 8-hour gap (none here: the previous week was empty).
- **Brian is writing the payroll rules.** syed.haris, 41:33: *"since Brian is working on the payroll
  rules … once he finalizes all the document and it's being reviewed by Micaela and Corrina, then we will
  implement that."*
- **Returned entries** (41:33, abdulrehman 45:29): automated events flag a ticket with wrong data (e.g. the
  wrong long boom or craft modifier). The payroll admin or manager either fixes the times — lunches and
  boom pay segregated, a note required — or returns the ticket to the field worker. Then approval and
  ADP.
- **Earning codes tab** (46:23, 46:55): every ADP earning code, copied in, with an *Add mapping* button
  *not yet tested against the ADP API* (*"there was some limited access, but now it has been provided"*).
- **The export file** (46:55): a spreadsheet for one approved employee (Anthony Vasquez), with the columns
  and codes from Micaela's four sheets. The file number and position ID are placeholders until the ADP
  data is processed.
- **Melissa McNutt, 46:40:** *"for the ticket times and the payroll times, are we still able to make it
  where it automatically rounds the time into 30 minute increments?"* syed.haris and ehtesham.anwar:
  *"Yes, we are."*

## 7. Field beta test (52:03–55:52)

- abdulrehman: CodingCops needs **field employees to install the app and stress-test it** against real
  jobs — holdover, build-up / breakdown, boom time, starting from home with no breakdown yesterday (52:03,
  52:23). syed.haris: the **Samsara payroll flags** (claimed arrival 1 pm vs Samsara 3 pm) can only be
  tested on a real job (52:51).
- **Kyle Harlow, 53:41:** *"you guys want to put actual jobs in the system that they're doing currently
  and have them do it in FCC and do it in your system"* — abdulrehman: yes; extra effort at first; the ERP
  is in beta and *"not production ready as yet"* (53:57–54:21).
- **How many:** Kyle has *"60 something members"* in the field. abdulrehman: **one operator, one oiler, one
  third man and one rigger** (54:45). **Kyle will pick them with the superintendent** for good buy-in
  (55:52).
- **ans.nisar, 55:01–55:20:** treat it as mock testing; it also trains whoever sets up projects and jobs.
  Later, *"start doing maybe just one project within this system because we don't want to completely move
  over at once"*. Kyle: *"that makes good sense."*

## 8. Accounting, QuickBooks and training (50:42–57:38)

- **Thursday 2026-10-29:** the second pass on the accounting designs, using Brent's notes and the Teams
  replies; the aim is accounting designs ready **within a week** of Thursday, then development
  (ehtesham.anwar, 51:11, 56:26). abdulrehman: accounting *"loopholes or issues"* are still being worked
  through (48:40).
- **QuickBooks access:** ehtesham.anwar asked for one CodingCops member in the **real QuickBooks**, not
  only the sandbox, to see TCG's data. abdulrehman: *"Melissa, just invite me on QB for now"* (57:06,
  57:38).
- **Training:** Melissa, on whether the demos helped: *"definitely hope to see the step by step because
  we're going to have to train it"* (51:02). ehtesham.anwar: dedicated training sessions per department
  can follow. The management team should start onboarding themselves from the documentation (51:11).

## 9. Next

- **TCG:** Kyle Harlow picks four field testers (operator, oiler, third man, rigger) with the
  superintendent (55:52). Micaela messages syed.haris when the 10-27 payroll is submitted (28:08). Melissa
  invites abdulrehman to the real QuickBooks (57:38). Patrick and Brian invite the people who need the iOS
  app (5:12, 21:15).
- **CodingCops:** Samsara mileage and short / long sub on job progress (§3); rename *holdover crane* to
  *holdover job* (§4); test the earning-code mapping against the ADP API (§6); ADP onboarding and status
  sync next sprint (§5).
- **Thursday 2026-10-29:** the accounting designs, second pass (§8).

## Against the vault

Checked 2026-10-29 against the vault, the open ticket specs and, where marked, the code. Most of the
ticket flow repeats the 2026-10-15 holdover decision
([../decisions/2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md](../decisions/2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md),
`reference`). Only the conflicts and the new points are listed here.

- **The special rate's scope conflicts with the build** (§6). The build stores one override per **employee
  per pay period** (`PayrollBaseRateOverride`, grain decided by Ali Riaz 2026-10-16;
  [../decisions/2026-10-19-pm-pa-manual-base-rate-override-kept-as-built.md](../decisions/2026-10-19-pm-pa-manual-base-rate-override-kept-as-built.md),
  pending Corrina and Brian). Micaela now puts it on **a specific ticket** (40:54), and abdulrehman heard
  *job*. Her 2026-10-08 Teams line said *"a special agreement for that employee"*. The verified
  [../decisions/2026-08-20-craft-locked-rate-override.md](../decisions/2026-08-20-craft-locked-rate-override.md)
  still forbids a free-text dollar override. Corrina's 09-28 example (72.16 *"on one job"*,
  [2026-09-28 notes](2026-09-28-adp-integration-sync-onboarding-worksheets-and-temp-rate.md) §1.5)
  supports a job scope. Filed on ADP-PAYDATA-EXPORT §12 Q32.
- **A Home start keeps the pre-trip; the card says it does not** (§4). DN-1 H7 and the shared step list
  (`FULL_HOLDOVER_MIDDLE_DAY_HOME_STEP_KEYS`: `arriveJob`, `pretrip`, …) keep Pre-Trip on a Home start, and
  the demo did one. The Home card's subtitle reads *"no pre-trip or yard departure"*, and abdulrehman's
  26:00 explanation matched the card. The copy is CodingCops' to fix. There is no **hotel** option
  (`TICKET_DAY_STARTS = ['YARD','HOME']`), and TCG did not ask for one.
- **30-minute rounding agrees** (§6) with the verified
  [../decisions/2026-08-24-payroll-time-rounding-method.md](../decisions/2026-08-24-payroll-time-rounding-method.md):
  start times round down and end times round up, to 30 minutes, for everyone.
- **Subsistence figures agree; the mileage source is new** (§3). 45–77.5 mi short and beyond 77.5 long,
  yard to job, are in [../payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md) and
  PAY-048. [../decisions/2026-09-01-subsistence-not-a-craft-attribute.md](../decisions/2026-09-01-subsistence-not-a-craft-attribute.md)
  makes it per job on the **permitted** route, *"possibly from Samsara"*. Joe himself said *"No, it's the
  permitted route"* on 2026-06-09. Samsara's travelled mileage is not the permitted route. The engine takes
  manual miles today.
- **The Samsara arrival flag may not be the one verified** (§7). syed.haris's example compared the claimed
  **job-site arrival** with Samsara. The verified flag list
  ([../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](../decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md),
  flag 7) checks the **start and end of the day**, and PAYROLL-FLAGS REQ-51 compares Left Yard / Arrived at
  Yard.
- **ADP by API is reported as live; the vault still has the path undecided** (§5). [../payroll/adp-api-test-2026-10-09.md](../payroll/adp-api-test-2026-10-09.md)
  is *"evidence that the API is viable, not a decision"*, and no TCG owner chose on this call either.
  ERP-initiated onboarding matches the verified
  [../decisions/2026-06-30-adp-erp-employee-data-ownership.md](../decisions/2026-06-30-adp-erp-employee-data-ownership.md),
  against the 09-28 ADP-first account. No ticket folder exists for onboarding or status sync.
- **Brian's rules document** (§6) is still the open deliverable in [../payroll/gaps.md](../payroll/gaps.md).
  Micaela is named as a reviewer for the first time. The vault spells her both *Dipane* and *Slykhuis*;
  whether they are one person is open (`decisions/2026-09-29-…` item 5).
- **Post-trip as required** (§4) runs into [../field-ops/gaps.md](../field-ops/gaps.md) *Post-trip
  inspection — Melissa says it does not happen, two signed documents say it does* (open). Nobody raised it.
- **Agrees:** deficiency priorities (low / medium / high / emergency — blocking, as the 2026-06 field-app
  demo); *request approval* to reopen a ticket ([../decisions/2026-10-15-late-and-incomplete-tickets.md](../decisions/2026-10-15-late-and-incomplete-tickets.md)
  L3); TestFlight for iOS (the 2026-09-15 demo §7); the 4-hour long-boom minimum and the 8-hour rest gap
  (provenance, Confirmed). **New, unwritten:** the Android APK; signature GPS compared with the job
  location; the payroll utilization figure (§6); the four tester roles and an FCC parallel run (§7); the
  10-29 accounting second pass. Real QuickBooks access repeats the unclosed 10-08 action.

## Candidates for a decision note (for `tcg-scrum`)

1. **"Holdover job", not "holdover crane"** (§4). Joe Schacatano (VP of Operations) asked for it and
   CodingCops agreed. It is a copy request, not a choice between alternatives, so it was filed as evidence
   on the open copy question (TICKET-FLOW-SLOTS-HOLDOVER §12 Q18) rather than a decision note.
2. **The special rate applies to a ticket** (§6). Micaela answered a direct either/or (*whole job or a
   single ticket?*) with *"a specific ticket"*. That is close to a choice between named options. But
   abdulrehman's restatement (*job level*) went uncorrected, and the rule's owners are Corrina and Brian
   (the 10-19 note awaits their ratification). It was filed on Q32, not written as a decision.

Nothing else on the call was a TCG owner choosing between alternatives.

## 10. Questions this raises — filed 2026-10-29

1. **Override scope** (§6). Update on [ADP-PAYDATA-EXPORT spec §12 *Q32*](../../aidlc/ADP-PAYDATA-EXPORT/spec.md)
   and a pointer on [../payroll/gaps.md](../payroll/gaps.md) *`BASE RATE OVERRIDE` — a per-row base-rate
   mechanism in the live workbook, purpose unstated*.
2. **"Holdover job"** (§4). Update on [TICKET-FLOW-SLOTS-HOLDOVER spec §12 *Q18*](../../aidlc/TICKET-FLOW-SLOTS-HOLDOVER/spec.md).
3. **Home card copy and the hotel mention** (§4). Update on [TICKET-FLOW-SLOTS-HOLDOVER spec §12 *Q15*](../../aidlc/TICKET-FLOW-SLOTS-HOLDOVER/spec.md).
   This is CodingCops' to fix.
4. **Samsara mileage for subsistence, signature GPS, the arrival flag** (§3, §4, §7). Update on
   [../dispatch/gaps.md](../dispatch/gaps.md) *GPS-verified time on a job — what is being verified?*.
5. **ADP by API** (§5). Update on [../payroll/gaps.md](../payroll/gaps.md) *Excel or API — the ADP
   submission path is not decided*.
6. **ERP-initiated onboarding** (§5). Update on [../payroll/gaps.md](../payroll/gaps.md) *Where the
   employee lifecycle starts — ERP-initiated (06-30) or ADP-first (09-28)?*.
7. **Brian's rules** (§6). Update on [../payroll/gaps.md](../payroll/gaps.md) *Payroll calculation logic —
   Brian owes a revised version*.
8. **Payroll utilization** (§6). New: [../payroll/gaps.md](../payroll/gaps.md) *Weekly payroll utilization
   — an 8-hours-a-day basis shown to TCG, never specified*.
9. **Field beta and the FCC parallel run** (§7). New: [../admin/gaps.md](../admin/gaps.md) *Field beta test
   and parallel run with FCC — four field testers chosen by Kyle, no plan written*.

---
title: The Field Ops app demo build — what the 2026-06 prototype actually implements
source: shared-folder/Project-Repository-2026-09-04/CC_FRD-Field-Ops-Mobile-App_DEMOs/ — TCG Field App DEMO 2026-06-16.html and TCG Field App DEMO 2026-06-23.html (byte-identical)
migrated: 2026-09-04
updated: 2026-06-23
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/payroll, kind/reference, ticket-workflow, time-tracking, inspections, signatures, wtl, subsistence, boom, craft-modifier, offline, geolocation, notifications, authentication, per-diem, overtime, safety]
entities: []
---

# The Field Ops app demo build, June 2026

**What this is.** The **built demo** of the Field Operations mobile app that CodingCops walked TCG
through on 2026-06-16 — a self-contained React single-page app packed into one HTML file, shipped
in the drop under two filenames dated a week apart. It is the running artefact behind the meeting
transcript [meetings/transcripts/2026-06-16-field-ops-mobile-app-demo.md](../meetings/transcripts/2026-06-16-field-ops-mobile-app-demo.md),
where the demo is described on the call as *"a demo on the web, but later on it's going to be
developed on the mobile."*

> **The two files are the same build.** `TCG Field App DEMO 2026-06-16.html` and
> `TCG Field App DEMO 2026-06-23.html` are **byte-identical** (same MD5, both 1,855,968 bytes).
> There is one demo, filed twice with two dates. **Do not cite them as two iterations.**

**Why it matters.** The vault holds three written specifications of this app that
[disagree with each other](field-ops-mobile-INDEX.md). This is the one artefact that shows **which
reading was actually built**, with real thresholds and real state machines instead of prose. Several
values here appear in no written document at all.

> **A demo is not a specification and not an accepted requirement.** Its sample data is fictional —
> the customer, crane, addresses and crew are invented, and the app's own `<title>` is
> *"Meridian Crane — Field Operations"*, not TCG. Numbers below (boom-pay dollar values, wage rates,
> hospital names) are **demo placeholders, not TCG rates**. What is evidence here is the *structure*:
> which steps exist, in what order, with what gates.

**How this was read.** The HTML is a self-extracting bundle: a 29-entry JSON manifest of gzip'd,
base64'd modules. Eighteen JavaScript modules were decompressed and read as source. **No markup is
reproduced below** — only the behaviour the source encodes.

---

## 1. Fifteen steps, not thirty and not forty

The demo hard-codes a `STEPS` array of **15 guided steps**, each with a number, key, icon and an
English and Spanish title:

| # | Step | # | Step |
| ---: | --- | ---: | --- |
| 1 | Pre-Trip Inspection | 9 | Customer Final Signature |
| 2 | Left Yard | 10 | Left Job Site |
| 3 | Driving to Site | 11 | Arrive Yard |
| 4 | Arrive Job | 12 | Post-Trip Inspection |
| 5 | Customer First Signature | 13 | Compliance Checklist |
| 6 | JSA — Tailboard | 14 | Labor & Unit Details |
| 7 | Start Work (Boom Time) | 15 | Review & Complete |

Two orderings differ from **both** FRDs. **Pre-trip comes before Left Yard here** (FOP-002 §6 has
`Pre-Trip Checklist → Leave Yard`, which agrees; FOP-001 numbers `008 Leave Yard` before
`009 Pre-Trip Checklist`, which does not). And **the customer's final signature is step 9, before
Left Job / Arrive Yard / Post-Trip** — whereas FOP-002's workflow overview puts
`Customer Signature` **last**, after Post-Trip and immediately before Submit. The demo signs the
customer off on site and then drives home; FOP-002 signs after returning to the yard.

There is also a **`Driving to Site` step with no counterpart in either FRD** — a live drive timer
with ETA and distance, a Navigate button, and a **geofence prompt** that appears when the crew is
*"within 500m of the job site"* and offers *"Yes, arrive at job"*.

A separate **`Labor & Unit Details`** step (14) carries the same name as the FCC e-ticket's internal
tab ([fcc-e-ticket-and-atom-guides.md](fcc-e-ticket-and-atom-guides.md)).

## 2. Time capture: 30-minute rounding "in your favor", with a reason

Every clock event runs through one helper:

```
roundFavor(date, dir)   // dir = 'down' when leaving, 'up' when arriving
```

It floors to a **30-minute** boundary on `down` and ceilings on `up`. Applied as: **Left Yard rounds
down, Arrive Job rounds up.** The UI says so explicitly — *"Rounded down/up to 30 min in your favor ·
adjust as needed"*.

This is the first concrete implementation of `FR-FOP-038 Time Rounding` (FOP-001), which the vault
otherwise holds only as a title. It matches the paper ticket's contractual
*"times billed in **30 minute increments** per agreement with I.U.O.E Local 12"*
([field-paper-forms.md](field-paper-forms.md) §1) — but the paper clause is about **billing**, and
what the demo rounds is the **employee's recorded time**, in the employee's favour. No source says
whether those are meant to be the same rounding.

**Adjustment is ±30 minutes at a time and requires a reason.** Once a time is adjusted the record is
flagged `adjusted: true` and a reason becomes mandatory, from a closed list of four:

```
Forgot to record · Corrected actual time · System error · Other
```

`FR-FOP-038` does not name a reason list. FCC's *"the user must provide a justification for the
modification of a time"* is the same rule from the legacy side, but FCC's justification is free text.

Each time step also shows a **GPS card** (`GPS verified`, an address and a ±metre accuracy) and an
optional free-text comment *"for dispatch"*.

## 3. Lunch: three breaks, a 5-hour rolling clock, and a mandatory third

The most specified thing in the build. Constants:

```
LUNCH_WORK_MS = 5 hours   // of work before a break unlocks
LUNCH_WARN_MS = 1 hour    // reminder before it unlocks
```

Three lunch records, each `pending → available → taken | workedThrough`.

**Unlock is rolling, not absolute.** Break 1 unlocks at `startWork + 5h`. Break *n* unlocks at
**`5h` after break *n−1* was resolved** — from `endTime` if it was taken, from `wtlTime` if it was
worked through. A break that has not been resolved never unlocks the next. The card label states it:
*"30 min · After (n × 5) hrs of work"*, and a locked card reads *"Available after Break n is
resolved"*.

**Taking a break writes a fixed 30 minutes.** `handleStart` sets `startTime = now` and
`endTime = now + 30 min` in the same operation — the demo does not measure the actual break.

**The third break is mandatory if the first two were worked through.**

```
break3Mandatory = lunch[0].workedThrough && lunch[1].workedThrough
```

When true, break 3 renders as `MANDATORY`, the *Work Through* button is **removed**, and the card
says *"You worked through breaks 1 & 2. This break is mandatory and cannot be skipped."*

> **No written source in the vault states this rule.** Not the BRS, not either FRD, not the Atom user
> stories. It is a two-WTL cap, implemented.

**Work-through-lunch takes a customer signature.** The WTL path is: acknowledge the penalty
(*"A WTL penalty will be recorded in payroll for this break period"*) → tick *"I authorize working
through this break. WTL penalty acknowledged."* → a bottom sheet titled
`Lunch Break n — Customer Authorization` requiring the **customer or authorized representative's
name, a live identity photo, and their signature**. Only then is `workedThrough` recorded, with a
toast *"⚠ Work Through Lunch n applied to payroll"*.

That matches ticket 45954, where the WTL authorization is signed by the customer mid-day, and
ticket 44944, where it is signed by the customer at day's end
([e-ticket-worked-example-44944.md](e-ticket-worked-example-44944.md)).

**Three, not four.** The e-ticket's crane `Time Stamps` checklist has **four** lunch slots on both
tickets in the vault; `brs.md` BRS-LUNCH-002 lists **three**; the payroll module models **four**; the
demo implements **three** with a hard cap of two WTLs. Nothing reconciles these.

The demo **cannot advance past Start Work while a break is active** (`disabled={!!activeLunch}`).

## 4. Checklists: three answers, four priorities, and an emergency path

One `ChecklistEngine` serves both pre-trip (step 2) and post-trip (step 12), in a **stepper view and
a list view**, with a **per-unit tab bar** and per-unit progress.

**Answers are the same three as FCC's e-ticket:** `OK / Inspected & good` · `Issue / Needs attention`
· `N/A / Skip item` — i.e. `pass` · `deficiency` · `na`.

**A deficiency demands a comment and a priority before it can be saved.** Four priorities, and the
fourth is not a severity but a state:

```
Low · Medium · High · EMERGENCY — Blocking
```

Choosing `EMERGENCY` raises a banner — *"Emergency deficiency reported. **Dispatch and Mechanics have
been notified. A chat thread is open.**"* — over a machine-readable line
`EMERGENCY · Crane #<n> · <employee> · Job #<n>`. `FR-FOP-025 Deficiency Reporting` calls for
*"deficiency selection with mandatory comment and priority"*, which matches; **the four priority
values and the emergency escalation-to-chat behaviour are the demo's own**. The printed e-tickets
show no priority column at all.

Each deficiency can carry a photo, captured *"GPS stamped"*. Each unit also has a set of named
**condition photo slots** before its items — the demo's crane has `Front · Rear · Left side ·
Right side`, its tractor `Front corner · Rear`. Post-trip uses different ones
(`Front corner · Boom stowed · Left side · Right side`).

The pre-trip step's own instruction line is *"As oiler, you inspect the crane and tractor. Answer
each item — **scan the QR** or pick a unit"* — QR-code unit selection appears in no written source.

An **Operator accordion** on the checklist shows the operator of record with Name, Craft, Union and
Tractor — the oiler completing the pre-trip sees who the operator is.

## 5. JSA — a topic, a hazard list, and per-hazard mitigation

Step 6 is a tailboard. A required **toolbox-talk topic** from a fixed list of six:

```
Fall Protection · Rigging Safety · Power Line Clearance
Load Charts · Signal Person Procedures · Heat Illness Prevention
```

and a **nine-item hazard list**, each tickable with a free-text `Mitigation…` field that appears when
ticked, plus a tri-state select-all:

```
Overhead power lines · Ground conditions / soil bearing · Weather & wind · Traffic control
Pedestrians · Underground utilities · Adjacent structures · Slope / grade · Lift path clearance
```

Only the topic is required to complete the step.

> **This is a third JSA shape.** The e-ticket carries a **6-item** `JSA 12.18.25` job checklist; TCG's
> two 2026 paper JSA forms carry dozens of talking points, a crew roster and a Crane Guys Standard
> gate ([safety-compliance/02-jsa-and-lift-planning-forms.md](safety-compliance/02-jsa-and-lift-planning-forms.md));
> the demo has 6 topics + 9 hazards + mitigations. No two agree, and **the demo's JSA collects no crew
> signatures**, while both the e-ticket and the paper forms do.

## 6. Compliance and labor — the two steps that feed payroll

**Step 13, Compliance.** Three questions, each answered on the same `pass / deficiency / na` pills:

| Row | Question |
| --- | --- |
| Per Diem / Subsistence | *"Do you qualify for per diem today?"* |
| Pre-trip / Post-trip | *"All inspections performed?"* |
| Compliance Attestation | *"All lunches, rest periods & breaks accounted for?"* |

Answering the per-diem row `pass` reveals a two-button choice: **`Long Sub` / `Short Sub`**. That is
exactly the token pair the e-ticket's Time Stamps item 8 asks for in free text (*"note long or short
sub in the comments"*) and the legacy `SUB_SHORT` / `SUB_LONG` model in
[payroll/legacy-payroll-app-db-extract](../payroll/legacy-payroll-app-db-extract/rules-plain-language.md).
**Three independent sources now agree subsistence is a two-value token, not a computed distance.**

The step also shows the lunch records **auto-filled from step 7**, read-only, and an
**8-Hour Rest Verification** card:

```
restHrs = 6.5 ; doubleTime = restHrs < 8
→ "Only 6.5 hrs since last shift (11:30 PM → 6:00 AM). DOUBLE TIME applies."
```

The 6.5 is hard-coded demo data, but **the rule is not**: less than 8 hours' rest since the previous
shift ⇒ double time, computed by the app and flagged on the ticket. The employee then signs.
Nothing in either FRD mentions an 8-hour rest rule; it belongs to the union agreement side of the
vault.

**Step 14, Labor & Unit Details.** An auto-calculated block, then a per-crew-member accordion.

```
travel = (arriveJob − leftYard) + (arriveYard − leftJob)
boom   = endWork − startWork
lunch  = Σ (lunch.end − lunch.start)          // taken breaks only
total  = arriveYard − leftYard
net    = max(0, total − lunch)
```

Displayed as `Total (yard → yard)` · `Travel time` · `Boom time` · `Lunch deduction` (negative) ·
**`Net billable hours`**, all to one decimal. So in the demo, **travel is part of net hours** and
**only lunch is deducted** — portal to portal, matching paper-ticket §13.

Per crew member: read-only `Union class` and `Craft code` (`Operator (OP)` / `Oiler (OI)`), an
editable `Total hours` whose edit toasts *"Hours edited — modification tracked"*, and a
**`Craft modifier — Boom Pay`** select.

The boom brackets, with a **suggested** value pre-selected *"Auto-suggested from crane
configuration"*:

```
none (< 80 ft) · 80–100 · 100–120 · 120–140 · 140–160 · 160–180 ★ · 180–200 · 200–220
```

**Changing away from the suggested bracket flags the entry `Modified`, requires a free-text reason,
and states `Notifies salesperson`.** The step cannot advance while any crew member has a modified
bracket without a reason.

> The 20-foot brackets line up with the real craft modifier on TCG's ticket 44944 —
> **`161-180Ft-Oiler` / `161-180Ft-Operator`** — which is the demo's `160-180` bracket combined with
> the seat. That is the strongest single corroboration in this drop that the demo modelled the real
> data. The dollar values attached to each bracket in the demo (`+$1.50/hr` … `+$6.00/hr`) are
> placeholders and **must not be read as TCG rates**.

## 7. Review, submit, and what submission means

Step 15 shows a `TIME CARD` timeline of the six workflow times, a per-step summary line, the lunch
records inline, `Net billable`, a signature panel (first customer signature, final customer
signature, employee signature — each Signed/Pending), and a **ticket PDF preview**.

Submission is behind a confirmation sheet:

> *"This submits Job #\<n\> **to payroll and billing**. You won't be able to edit it after."*

and the success screen reads *"\<n\> net hours sent to payroll and billing"*. A second button offers
**`Email ticket PDF to customer`**.

**The final customer signature has three escape hatches** the FRDs do not describe:

1. Three tick-boxes the customer must confirm — *"No damages to job site"*, *"Work completed as
   described"*, *"No accidents or incidents occurred"* — the third being the same assertion the paper
   ticket's end-of-day panel makes.
2. **"Customer leaving before the crew finishes wrap-up?"** — an expandable acknowledgement:
   *"I understand I'm approving the end of the job before the crew has finished wrapping up on site.
   I accept the work performed today and release the crew from a final on-site walk-through."*
   Without it, early sign-off is blocked.
3. **"Customer not available for final signature"**, which replaces the signature with a mandatory
   free-text reason (*"e.g. customer left at 2 PM"*) and records `unavail`.

Both signature steps also take an **identity photo of the signer** through a live camera, alongside
the signature pad and a GPS stamp. `FR-FOP-018 Signature Quality / Fraud Prevention` (FOP-001) is a
title in the vault; this is what it was built as.

## 8. Everything around the ticket

- **Login** is **phone number + password**, with a *"Contact dispatcher"* link that starts an SMS
  one-time-code flow: phone → 6-digit code → *"Temp access ends when your ticket is complete."*
  That is the **temporary/vendor OTP access** the Atom user stories describe. The login footer
  reads `GPS & audit logging active · FOP v2.0` — the build identifies itself against
  **FR-TCG-FOP-002**, the DRAFT document, not the REVIEWED one.
- **Bilingual throughout.** A complete EN/ES string table; the language toggle is a first-class
  control and every step title carries a Spanish variant.
- **Onboarding** — four slides whose claims are the app's own pitch: a guided 15-step **LEM ticket**;
  *"Works offline, never loses data"*; safety built in (pre-trip, JSA, weather alerts, one-tap SOS);
  *"Photos, signatures, and timestamps are GPS-stamped for compliance."*
- **SOS** is a persistent floating button on every screen. Confirming sends
  *"your GPS location, name, and job number to **Dispatch, the Safety Officer, and 911
  simultaneously**"*. Neither FRD mentions an SOS or a 911 path.
- **Bottom navigation** is four tabs — `Home` · `Jobs` · `Alerts` · `Menu` — with unread badges.
  `FR-FOP-001 Bottom Navigation` exists in both FRDs; neither lists the tabs.
- **Home** carries a job-site weather pill with a **`HIGH WIND WARNING`** state —
  *"35 mph gusts at job site. Crane operations may be unsafe — contact dispatch before proceeding"* —
  and a certification-expiry banner.
- **An incomplete ticket blocks the next one.** `openTicket()` refuses with *"Resolve the incomplete
  ticket first"* while yesterday's ticket is open. Home states it as *"1 incomplete ticket from
  06/07 — Complete it before starting today's work."* This is `FR-FOP-026 Incomplete Ticket
  Handling` (FOP-001) implemented as a **hard gate**, which the requirement title does not say.
- **Incident / near-miss reporting** sits inside Start Work: type
  (`Injury · Near-Miss · Property Damage · Environmental Spill`), severity
  (`First Aid Only · Medical Treatment · Lost Time`), description with voice input, photo/video
  evidence, and it mints an `OSHA-nnnn` reference and toasts *"Incident reported · Safety Officer
  notified"*. Compare TCG's own paper
  [safety-compliance/04-incident-investigation-form.md](safety-compliance/04-incident-investigation-form.md),
  which is far larger and has a 24-hour submission rule.
- **Menu** → `My Labor` (hours and pay class by shift), `My Certifications`, `My Tasks`,
  **`Checklist History` — subtitled `Retained 3 yrs (DOT)`**. That retention figure appears in no
  other source; the FRD lists *"Inspection retention requirements"* as still Pending and FCC's Atom
  defaults its history view to **90 days**.
- **Certifications** list name, number, expiry and a days-left count, with an
  `Expiring soon` state and an `Upload Renewal` action — *"Upload renewal before \<date\> to avoid
  **work stoppage**."*
- **Notifications** cover new ticket assigned, certification expiring, weather alert, deficiency
  resolved, and — notably — **`Payroll modification: Job #8842 hours adjusted 8.5 → 8.0`**. The
  employee is told when the office changes their hours.
- **Crew Chat** has three channels: the job, `Mechanics / Maintenance`, and
  `Company Announcements`.
- **Accessibility and preference**: three themes (`Light` / `Dark` / **`HC` high-contrast**) and four
  font scales (S/M/L/XL), persisted. Neither FRD's non-functional section mentions high contrast or
  text scaling.
- **Persistence** is `localStorage` for theme, language, font scale, tab, current step, ticket-done
  and incomplete-ticket flags — the auto-save of `FR-FOP-039`, in prototype form.
- **Offline** is a manual toggle in the demo, toasting *"Offline — work saved locally, will sync when
  back online"* / *"Synced — all data uploaded"*. It is a simulation, **not** an offline
  implementation, and it does not reproduce FCC's real constraint that labor entry and ticket
  completion are the two things that cannot be done offline.

## 9. Where the demo contradicts the written record

| Subject | Demo | Written sources |
| --- | --- | --- |
| Step count | **15** | FOP-002: 30 requirements, 15-node workflow · FOP-001: 40 requirements |
| Final customer signature | step **9**, on site, before leaving | FOP-002 §6: **after** Post-Trip, last before Submit |
| Lunch breaks | **3**, rolling 5-h unlock, 3rd mandatory after two WTLs | e-ticket: **4** slots · BRS-LUNCH-002: **3** · payroll: **4** |
| Lunch duration | fixed **30 min** written on start | e-ticket: free text, *"Lunch 12 pm to 12:30 pm"* |
| Time rounding | **30 min, in the employee's favour**, reason from a list of 4 | `FR-FOP-038` titled only · FCC: free-text justification |
| Two time records | **no** — one adjustable time per event | FCC + ticket 44944: **customer times and workflow times both kept** |
| JSA | 6 topics + 9 hazards + mitigations, **no crew signatures** | e-ticket: 6 items, **3 signatures** · paper: dozens of points + roster |
| Deficiency priority | 4 values, `EMERGENCY` escalates to dispatch + mechanics | FCC: priority list is configurable; printed tickets show no priority |
| Inspection retention | **`Retained 3 yrs (DOT)`** | FRD: *Pending* · FCC Atom: 90-day default view |
| Offline | simulated toggle | FCC: labor entry and completion are **blocked** offline |
| Boom pay | 8 brackets of 20 ft with dollar values | ticket 44944: modifier `161-180Ft-<seat>`, no rate on the ticket |

## 10. Open points

Recorded for a human to route; **not** written to any `gaps.md`.

1. **Three or four lunches?** And is the demo's *"third break is mandatory after two WTLs"* a real
   TCG rule, a union rule, or an invention of the prototype?
2. Does the rounding of the *employee's* time in their favour follow from the contract's 30-minute
   *billing* increment, or are they two different rules that happen to share a number?
3. Should the app keep **both** a workflow time and a customer time, as the current system does? The
   demo keeps one.
4. Is **`Retained 3 yrs (DOT)`** sourced from anything, or is it demo copy?
5. Where does the **8-hour rest ⇒ double time** rule come from, and does the field app own it or does
   payroll?
6. Does the final customer signature belong **on site** (demo) or **after returning to the yard**
   (FOP-002)?
7. Is **SOS to 911** in scope? It appears in no requirement document.

## Source

`CC_FRD-Field-Ops-Mobile-App_DEMOs/TCG Field App DEMO 2026-06-16.html` and
`CC_FRD-Field-Ops-Mobile-App_DEMOs/TCG Field App DEMO 2026-06-23.html` — 1.8 MB each,
**MD5-identical**. `pandoc` conversion yields only the loading placeholder (988 bytes), because the
page is a self-extracting bundle. Read by parsing the `__bundler/manifest` JSON (29 entries) and
gzip-decompressing its 18 JavaScript modules: app root, iOS device frame, design primitives ×2, icon
set, sample data + i18n, login/onboarding, home, shell extras (nav/SOS/profile/chat/tickets/
notifications), guided-flow shared parts, checklist engine, step views 1–6, 7–12, 13–15, plus React
and ReactDOM vendor bundles. Seven JPEG/PNG assets and four WOFF2 fonts were not extracted. **No
markup or source code is reproduced on this page.**

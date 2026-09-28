---
title: ERP live demo 02 — won quotation to project, job schedule, permit and plan trackers, DAS allocation and vendor assets (22 September 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-09-22_ERP LIVE DEMO 02 - transcript.docx"
migrated: 2026-09-24
updated: 2026-09-22
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/projects-jobs, module/dispatch, module/assets, module/vendors-agencies, module/field-ops, module/payroll, kind/meeting-notes, permits, lift-plans, purchase-orders, daily-allocation, craft-code, tools-rigging, geolocation, integrations, sprint-planning]
entities: []
meeting_date: 2026-09-22
---

# ERP live demo 02 — won quotation to project, job schedule, trackers, DAS allocation and vendors — 22 September 2026

Curated from [transcripts/2026-09-22-erp-live-demo-02.md](transcripts/2026-09-22-erp-live-demo-02.md)
(1 h 13 m 44 s). Labelled speakers: Brian Petros, Wes Staley, Kyle Harlow, Corrina Bustos, Ryan Adams
(Sales Manager), "IT Support" (Patrick), ehtesham.anwar (presenting), abdulrehman, syed.haris.
**Lisette Anzaldo was present on Brian's conference-room microphone**, so her turns are labelled
*Brian Petros*; the transcript header lists which turns are almost certainly hers. Where this note
says "Lisette", it relies on that attribution. Joe Schacatano was not on the call.

This is the second from-scratch walkthrough. It picks up where
[demo 01](2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md) (§9) left
off: detailed DAS, the trackers and progress tracking, **with Lisette present**. That was the reason
for timing it this way.

> **A demo describes shipped code. It is not a source for a spec.** §1 records what CodingCops
> showed on 2026-09-22, as a dated description of the build. It does not show that anyone at TCG
> asked for or accepted that behaviour. Lisette's approval in §2 is a reaction to a demo, not a
> sign-off on any rule.

> **No binding client decision was made on this call**, so no decision note was written. §2 is what
> TCG people said, §3 is what the dev team said it intends, and each item says where it is registered.

## 1. What was demonstrated (dev team, as built on 2026-09-22)

The walkthrough used one 100-ton job (**job 006**, scheduled 23–30 September), then two multi-crane
jobs (**007**, **008**) to show permit coverage.

| At | Area | What was shown, and what the presenter said about it |
| --- | --- | --- |
| 9:38 | Duplicate quotation | A quick action on a quotation in any state. If the quotation belongs to a project, it asks whether the copy stays in that project or becomes standalone. |
| 9:38 | Won quotation → project | **Create Project** is offered on a *Won* quotation. The project name defaults to the quotation name. Customer PO is optional because it may arrive later. Conversion auto-detects required artefacts (here a **travel permit** for the 100 ton, plus a plan) and creates the project, attaches the quotation, **creates the job inside the project**, and mints the plan and permit artefacts in *open*. Stated reason for the project wrapper: later quotations and jobs for the same customer and site collect in one place. **Presented as a change from FCC**, where the job was created directly. |
| 9:38–17:48 | Job → Schedule tab | Start and end dates carry over from the quotation and are editable. Each day has **leave-yard, on-site and estimated-end** times. Editing a row changes only that day; a collapsed panel sets one set of times and applies it to all selected days. |
| 19:03 | Scope of the Schedule tab | The tab schedules the job only. **Per-day resource scheduling is done in DAS.** |
| 19:03–20:33 | DAS job card | Status (*open*); **pre-checklist** covering lift plan, site plan, permits, assets (3 needed), employees (2 needed) and tools and rigging; quick actions for sending tickets. |
| 20:33 | Permit tracker | Statuses: **open → application submitted → approved**, plus cancelled. *Mark application submitted* takes the application attachment (a portal screenshot is enough) and an **expected permit-receiving date**. That date is captured *"for the first three to six months"* to compare against Ryan's per-agency turnaround figures. The artefact is tagged *due today* because the job starts on the 23rd. |
| 20:33 | Plan tracker | Plans have three states: **open, approved, cancelled**. |
| 20:33 | Permit PO | A PO can be created inline while the permit is open. It has permit type, agency, job, PO fee and discount, and **stays open until Accounting links an invoice**, so dispatch never closes it. **A PO is required before the approved permit can be uploaded.** The approval upload takes the file, cost, application number, date received (defaults to today), service fee, finance charge, damage deposit and notes. The approved file is **attached to tickets automatically**. |
| 20:33 | Live two-way status | Approving a permit, or uploading a plan straight from the DAS card, turns that checklist dot **green** on the board and in the trackers. |
| 20:33 | DAS layout | Before a job is opened, nothing is recommended. Assets are on the left and employees on the right, each with a hover status, job and times. |
| 20:33 | Allocation | Opening a job shows **recommended** available and eligible assets and people (102 for the 100 ton; Nathan as oiler; an operator load; any truck; an operator). **Unsaved allocations persist while you move between jobs but are not final.** *Save allocations* completes the counts and moves the job **open → allocation completed**. That unlocks **Send tickets** and **Copy allocations**. |
| 34:25–36:36 | Copy allocations | **Mark it holdover** copies every asset and person to all remaining scheduled days. Otherwise the user picks the target days, and can copy **assets only** or **employees only**. Permits and plans attach to every scheduled day automatically and go out on each day's tickets. |
| 36:36 | Partial allocation | A partially saved allocation leaves the job *open*, and **Send tickets stays disabled** until every slot is filled. |
| 39:55 | Send tickets | The dialog asks whether **payroll premiums** apply to the job (military base premium shown) and lists the employees who get a ticket. |
| 40:46–44:35 | Vendor assets (Ryan's question, §2) | Vendors appear in the DAS asset panel. A slot can go to a vendor (**Piazza** for the operator load in the demo). Vendor units need only a **unit code** (serial optional). A vendor operator needs only a **name**; e-mail and phone are optional. Allocating a vendor **prompts for a PO**. Units created this way are saved to the vendor profile's associated assets and can be picked again on later jobs (unit 117). |
| 44:41 | Project → job tabs | Schedule, tools and rigging, additional information (configured at asset level, empty here), POs, permits and plans (updating in real time), and **progress tracking**, which shows each ticket and its status plus the DAS job status. *View progress* on DAS opens the same page. Mobile updates are stated to reflect in real time. |
| 44:41 | Craft-code mismatch | Dropping an employee into a role that doesn't match their profile, such as a rigger into an oiler slot, prompts for a craft code **for this allocation only**. It is **not** written to the profile, and the prompt returns on the next such job. An employee whose profile already carries the role's craft code gets no prompt. |
| 44:41 | Asset / employee status | After tickets go out, asset 102 and tractor A12 show **assigned** with job and time. Counters show available, assigned, on hold and in maintenance. **Maintenance** (start/end, scheduled) blocks assignment. For employees: unavailable, profile, and **mark leave**, which writes to their employment leaves. |
| 51:35 | Map view | Live asset positions from **Samsara**, with *view details* and the job. The presenter noted the data will only be accurate once the system is live. |
| 51:58–55:48 | Multi-crane permits | For a quotation with two cranes (190 ton and 120 ton), conversion offers permit coverage per document: **Individual** (job 007: two travel permits, one per crane, plus one site plan) or **Combined** (job 008: one travel permit covering both crane categories). **Presenter-noted defect:** the combined permit's resource field shows only one crane and should show all of them. |
| 57:17 | Annual permits (Lisette's question, §2) | The agency, state and city are auto-detected on a permit. **Annual permits are "being worked on"**: they will live on each asset, and DAS will flag a recommended asset that carries an applicable annual. Applying it creates the permit requirement. Not shown working. |
| 58:49–1:03:42 | Schedule limits and second shift | **The schedule only handles leave-yard to estimated-end within 24 hours today.** Longer spans are *"just the interpretation"*. Updating it so leave-yard, on-site and end can fall on different dates is planned for this week. A **second shift** checkbox is available per day, and shift one must end before shift two starts. DAS shows both shifts, with options to reuse shift one's assets and employees or allocate differently. |
| 1:10:07 | Not reached | Field application, ticket receipt and updates, what they trigger on the web, SOS, ticket completion and payroll. Deferred to Thursday. |

## 2. What TCG said

- **Lisette, on DAS (50:52).** *"I really like the pre-checklist… for the permits and all the
  documents… being able to see it on this dashboard without having to open every single job. It's
  like a quick view of where everything is at… I love the color coding."* This is a reaction to the
  demo. It is not approval of any status rule.
- **Brian, on multi-day jobs (18:42).** These are *"a small percentage"* of jobs *"but they take up a
  lot of space… on these screens and they're hard to view"*. He called one job spanning several
  days *"the solution for that"*, and added that the resources can differ day to day (*"different
  people, different cranes"*).
- **Brian, on saving allocations (32:53).** It is *"almost better to… save the allocation so that we
  can see what's booked on the asset section… because if not, it's going to show as available."*
  Ehtesham agreed. **An unsaved allocation does not reserve the asset.**
- **A 100-ton job is two people (33:15–34:22).** Ryan asked whether it needs three because there is
  a tractor. The answer, probably Lisette's: *"it's going to be tractor, crane, and trailer, but the
  tractor takes the trailer, so just two people."* Ehtesham pointed to the sub-category's associated
  field assets as where this is configured. Ryan: *"That way you get utilization for the trailer and
  the tractor."* Background: [../dispatch/gaps.md → *Crane configuration — is a support load an
  Asset, or a line on the crane?*](../dispatch/gaps.md#crane-configuration--is-a-support-load-an-asset-or-a-line-on-the-crane).
- **Ryan, on outside trucking (40:24–40:37).** *"Do you ever run into a challenge where your
  counterweights need to be hauled by… a third-party trucking company?"* The answer was *"Yes."*
  He asked for a way to assign a third-party company to counterweight loads, and the vendor-asset
  flow in §1 was the reply (*"Yes, thank you very much"*, 44:35). The vendor record is in
  [../vendors-agencies/outside-trucking-piazza-invoice-sop.md](../vendors-agencies/outside-trucking-piazza-invoice-sop.md).
- **Relayed by Ehtesham, not said on this call (41:21):** *"Lisette mentioned that we will have their
  name and their phone number. That's the maximum information that we'll have"* about a vendor's
  operator. Only the name is required as built. Ehtesham offered to make phone required as well,
  but nobody decided it.
- **Lisette or Brian, on annual permits (57:00).** *"Certain cranes in certain cities do have
  annuals… do I have to attach the annual permit every single time?"* The dev answer is in §1
  (57:17): the feature is in progress, not built. The existing record says annuals are held per
  crane and get no PO: [../decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md](../decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md),
  [../projects-jobs/gaps.md → *PO exemption swaps the annual-vs-single axis…*](../projects-jobs/gaps.md#po-exemption-swaps-the-annual-vs-single-axis-for-asset-vs-job--and-annual-stops-being-expressible).
- **Brian, on the sales feedback loop (1:04:53–1:05:48).** He raised it for *"maybe next time"*.
  Once assets are matched to jobs, sales coordinators need to know *"what do we have that is
  available"*. The goal is something flexible enough for *"last minute emergency jobs"* that also
  tells sales about availability *"two months, six months from now"*. He called it *"a struggle…
  in our current system"*. **Registered**, see *Where each item is registered*.
- **Brian, overall (1:03:56).** *"This is amazing… it's built really well… it opens up possibilities
  in the future."* He described the current build as foundation and structure.

## 3. Dev-team statements of intent (no ticket, no written scope)

- **Estimate scheduling ≠ dispatch resource scheduling (8:27).** Ehtesham said that in a discussion
  with Brian and Joe it came out that *"during the discovery, somebody forgot to mention that we have
  scheduling for estimate versus scheduling for the resources for Dispatch. Both of them are
  different."* There are open questions, and a focus session with Joe is planned for 2026-09-23 or
  Thursday. This is the same fault line as demo 01 §2:
  [../quotations/gaps.md → *Quote line items vs dispatch resources…*](../quotations/gaps.md#quote-line-items-vs-dispatch-resources--the-associated-set-auto-fills-the-quote-and-the-sales-owner-says-dispatch-resources-must-not-be-quoted).
- **Jobs longer than 24 hours (58:49, 1:05:52)** are to be supported this week. Demo 01 said *"within
  the next two weeks"*. Related open question:
  [../dispatch/gaps.md → *Overnight DAS shifts*](../dispatch/gaps.md#overnight-das-shifts--may-a-shift-cross-midnight-and-what-does-the-board-show-when-it-does).
- **Holdover vs copy allocation (1:05:52).** Ehtesham: *"what we finalized [during discovery] was
  whenever we are going to have copy allocation, it automatically becomes holdover"*. As built, that
  is not the case, so Lisette has to mark the job as a holdover separately, and this is being worked
  on. **No written source for the claimed discovery decision was found.** Registered, see below.
- **DAS notifications and emergency SLA (1:05:52–1:07:20).** Field updates that need Lisette's action
  will show on the DAS page. If a won quotation is scheduled within a set window (2, 6 or 12 hours
  were floated, and *"we can define what are the emergency"* jobs), Lisette is notified in DAS.
  Ehtesham described this as *"thinking out loud"*.
- **Availability at quote time (1:07:20).** A quick version: when sales picks a crane class and dates
  on a quotation, show how many are free. A later version is availability-first: pick crane and
  dates, see availability, then *Create quotation* from it. This is **deferred until after the
  accounting loop is complete**. Brian added at 1:10:02, garbled: *"Maybe a sign in the Corrina in the
  quote"*.
- **Annual permits on assets** (57:17) and the **combined-permit resource defect** (51:58), both in §1.
- **Hand-over:** the same data-configuration tenant will be shared so that Ryan's team can create
  quotations and convert them, and Lisette can take jobs to *allocation completed*. Thursday starts
  from *Send tickets* (56:01). Onboarding employees (office or field) is not being demoed. TCG does
  it after hand-over, which will show what works (1:11:58–1:12:18).

## 4. Actions and housekeeping

- **Samsara / FCC data cleanup (4:11–5:51).** Brian is working with **Jeff Stricker**, per Kyle, and
  hoped to finish by the end of the week. Jeff was out sick, so Kyle said *"he's not ignoring you"*.
  syed.haris: not urgent. Brian's aim is that make, model, licence plate and above all **VIN** match
  exactly between the two systems. Context:
  [../assets/gaps.md → *Which dispatchable cranes are untracked…*](../assets/gaps.md#which-dispatchable-cranes-are-untracked-and-what-stands-in-for-them--asked-twice-unanswered-twice).
- **Quoting review (8:02).** Ryan went through quoting with Brian on Thursday 2026-09-17 and will send
  an update. *"So far it looks pretty good."* Ehtesham confirmed the team has received *"some of the
  playbooks"*.
- **Ehtesham → Ryan (7:28):** *"did you get to look into the portal?"* Ryan was away and it wasn't
  followed up.
- **Mobile beta testers (1:10:53).** abdulrehman still needs the list of field employees to beta-test
  the mobile app, and so far has invited only Brian. **Kyle: "I'll get those together."**
- **Safety session moved.** Brian had invited Safety to Thursday and will move that topic to Tuesday
  2026-09-29 (1:11:34).
- **Documentation:** Ehtesham undertook to share written documentation of the quotation-to-won flow
  and the asset configuration during the week (9:38).

## 5. Next session

**Thursday 2026-09-24**: the field application. That covers how tickets arrive and are updated, what
they trigger on the web for Lisette and others, SOS, ticket completion and payroll (1:10:07). It
starts from *Send tickets* on a job that TCG has taken to *allocation completed* in the shared tenant.

## Where each item is registered

| Item | Registered in |
| --- | --- |
| §3 copy allocation vs holdover, and the claimed discovery decision | [../dispatch/gaps.md](../dispatch/gaps.md) → *Does copying allocations make a job a holdover?* (new) |
| §2 Brian's sales feedback loop and §3 availability at quote time | [../quotations/gaps.md](../quotations/gaps.md) → *Availability at quote time — what sales can see before quoting* (new) |
| §3 estimate vs dispatch scheduling | existing entry, [../quotations/gaps.md → *Quote line items vs dispatch resources…*](../quotations/gaps.md#quote-line-items-vs-dispatch-resources--the-associated-set-auto-fills-the-quote-and-the-sales-owner-says-dispatch-resources-must-not-be-quoted). Not updated; the Joe focus session is pending |
| §1 jobs over 24 h, second shift | existing entry, [../dispatch/gaps.md → *Overnight DAS shifts*](../dispatch/gaps.md#overnight-das-shifts--may-a-shift-cross-midnight-and-what-does-the-board-show-when-it-does) |
| §1 Individual vs Combined permit coverage | existing entry, [../projects-jobs/gaps.md → *Artifact coverage model*](../projects-jobs/gaps.md#artifact-coverage-model--individual-vs-combined-and-whether-the-choice-is-permanent). The combined-resource defect is a dev-noted bug, not a question |
| §2 annual permits | existing records, cited in §2. Not registered again |
| §2 vendor operator: name only vs name and phone | not registered. Lisette's statement is relayed second-hand and nobody decided anything |
| §2 unsaved allocation leaves the asset available | not registered. It describes the build and TCG accepted the workflow |

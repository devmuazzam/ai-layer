---
title: Value Engine flow and the Lead Workflow diagram — the red/yellow/green scheduling paths
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Executive_Playbook_Package_Part_2_Value_Engine.docx and TCG_Value_Engine_SAMPLES-ONLY/2026-06-23 samples/Lead Workflow 4282026 - Copy - Copy (1).pdf
migrated: 2026-09-04
updated: 2026-08-06
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/dispatch, kind/reference, permits, scheduling, requirements]
entities: []
---

# Value Engine flow and the Lead Workflow diagram

**What this is.** Two attempts at drawing the same thing: how a customer request becomes a
scheduled crane job. The first is **Part 2 of an Executive Playbook Package** (2026-08-06), which
defines a three-colour routing rule driven by permit lead time. The second is an earlier
hand-built **Lead Workflow** flowchart from the `TCG_Value_Engine_SAMPLES-ONLY / 2026-06-23
samples` set, dated `4282026` in its filename.

---

## 1. The Value Engine flow — Executive Playbook Part 2

Its framing: *"This section defines the operational decision tree used by Sales Coordinators to
move a customer request into a fully scheduled crane job. **Every scheduling request must follow
this flow without exception.**"*

The executive flow, transcribed from the document's ASCII diagram:

```
Customer Calls / Emails / Texts
            ↓
   Verify Required Information
            ↓
    Information Complete?
      ├── NO  → Collect Missing Information ─┐
      └── YES → Ready to Schedule ←──────────┘
                     ↓
            Select Crane & City
                     ↓
              Scheduling Sheet
         ┌───────────┼───────────┐
      RED PATH    YELLOW       GREEN
         ↓           ↓           ↓
      Dispatch    Lead        Standard
      Approval    Time        Schedule
         └────┬──────┴───────────┘
                     ↓
              Job Scheduled
                     ↓
          Customer Confirmation
                     ↓
             Outlook Reminder
                     ↓
           Dispatch Takes Over
                     ↓
              Job Completed
```

**The three paths, verbatim:**

| Path | Definition |
| --- | --- |
| **Green** | *"**Standard permit timeline.** Sales Coordinator schedules the crane, reserves the slot, emails Dispatch with the job number and supporting documentation, and Dispatch finalizes the assignment."* |
| **Yellow** | *"The city requires **permit lead times longer than the standard travel permit window**. The Scheduling Sheet displays the required lead time. If the requested date complies, **create a placeholder** and email Dispatch."* |
| **Red** | *"The request falls **inside the 72-hour permit window (Monday–Thursday before 12:00 PM)**. **Dispatch approval is mandatory. A customer Permit Waiver is required before approval.** If approval or waiver is denied, return to Ready to Schedule."* |

**Loop-back rules:**

- Missing information → return to *Verify Required Information*.
- Dispatch denies Red Path → return to *Ready to Schedule*.
- **Customer changes schedule → *bill applicable costs*, then return to Ready to Schedule.**
- Customer cancels → follow the cancellation workflow, then return to Ready to Schedule if
  rescheduling.

**This is the only place in the vault that states a permit-driven routing rule.** Three things
follow that a build would need:

- **The route is computed from (crane, city, requested date)** — "Select Crane & City" precedes
  the fork, and the Scheduling Sheet is what *"displays the required lead time"*. The city→lead
  time table is the 98-row list in
  [../sales-intake-and-job-walk.md](../sales-intake-and-job-walk.md) §4.
- **72 hours, and specifically "Monday–Thursday before 12:00 PM".** That is a business-day window,
  not a rolling 72 hours, and it lines up with the Operations Manual's *"Before 12:00 p.m.
  Scheduling Push"* rhythm
  ([03-sales-coordinator-operations-manual.md](03-sales-coordinator-operations-manual.md) §6).
  **The document does not say what happens to a Friday request.**
- **Yellow creates a "placeholder"**, which is a scheduling state distinct from both "reserved"
  and "scheduled". The Sales Dispatch Sheet's own status list has `Tentative` and `Hold` alongside
  `Scheduled` and `Saved` — see
  [../sales-reporting-workbooks.md](../sales-reporting-workbooks.md) §3.

The document ends with a note on its own status: *"This draft establishes the flow logic. The
final executive edition will replace the text diagram with a professionally designed color-coded
flowchart."* **So this is a draft, and Part 1 of the Executive Playbook Package is not in the
drop.**

## 2. The Lead Workflow diagram — partially recoverable

`Lead Workflow 4282026 - Copy - Copy (1).pdf` is a wide, landscape flowchart. **Its text extracts
as fragments whose reading order is not recoverable** — boxes were laid out in a grid and
`pdftotext -layout` interleaves columns. The node labels below are transcribed verbatim; **their
sequence and their branch conditions are not, and must not be inferred from the order here.**

**Lead sources shown:** *"Cold jobsite visit, random meeting, associations, events"* · *"Lead
generator planhub, construct connect"* · *"Lead push from Joe or Ryan"* · *"Via direct phone call
or email"* · Dispatch *"Sends text for an available salesperson to take lead via group chat"*.

**Sales-side nodes:** *"Salesperson calls or emails potential customer"* · *"Salesperson gathers
customers company name and persons name from the company"* · *"Salesperson gathers address,
scope, dates"* · *"understands if it is a GC or Owner"* · *"Sales references prior jobs, email
history, payment terms, past issues"* · *"Sales flags the customer as new mentally with credit
risk expectations"* · *"Salesperson enters information into FCC and makes quote"* · *"Salesperson
sends quote to customer"*.

**Decisions shown as diamonds:** *"New Customer or existing customer (Playbook)"* · *"Is Job Scope
Clear"* · *"Is the correct crane available"* · *"Is 3d lift plan needed (Playbook)"* · *"Is lift
planning required"* · *"Is it emergency or same day lift"* · *"Is labor compliance needed"* ·
*"Does customer request a contract"* · *"does customer request coi"* · *"Any changes to job site
or scope"* · *"Customer disputes charges"*.

**Job-walk and engineering branch:** *"Sales schedules a job walk"* · *"Sales visits the jobsite
and evaluates access and set up, ground conditions, pick path, obstructions, sequencing and to
cover expectations and documents findings"* · *"Project engineer reviews job walk notes and
photos"* · *"Project engineer assesses crane site suitability and configuration"* · *"Sales sends
info to project engineer"* · *"Project engineer builds lift plans"* · *"Sales alerts operations
and project engineering immediately and parallel processing occurs"*.

**Contract / COI branch:** *"Sales send contract to project engineer"* — *"Project engineer sends
to insurance and waits 24 to 48 hours to receive redline"* — *"Contract sent back to customer"* ·
*"Project engineer sends COI and copies in sales"* · *"Customer does not need their contract
signed and signs our terms and cond."* · *"Customer does not request coi"*.

**Compliance branch:** *"Customer fills out sheet that was sent with email"* · *"Labor compliance
lets sales know when it is completed"* · *"Customer does not need labor compliance"*.

**Commercial / close branch:** *"Get PO for Job or COD needed to schedule"* · *"Sales informs
dispatch of date and crane size"* · *"Sales confirms hours and total price"* · *"Job Completion"*
· *"Sales sends to accounting"* · *"Sales documents no challenges"* · *"Sales informs customer of
extra charges via quote and sends to customer"* · *"Sales proposes alternate crane, date or hires
another crane company"* · *"Job is executed"* · *"**Sales watches 90 day sheet and follows up if
payment is not received**"* · *"Works with project engineer"* · *"Customer is contacted by sales"*
· *"Sales reaches out to customer to resolve"*.

**Four things this diagram carries that the August governance set does not:**

1. **Dispatch is a lead source** — an available salesperson is recruited by group text.
2. **Lead-generation vendors are named**: PlanHub and ConstructConnect.
3. **The Project Engineer, not the Sales Manager, routes contracts and COIs**, waiting *24 to 48
   hours* for insurance redlines. **The August *Contracts and COI SOP* routes them through the
   Sales Manager instead** — see [../contracts-and-coi-sop.md](../contracts-and-coi-sop.md). This
   is a real change of owner between June and August 2026, and the SOP describes itself as a new
   process (*"The Crane Guys **now** has an internal program available to assist with contract
   review"*), so the diagram is probably the superseded state. **Nothing says so explicitly.**
4. **A "90 day sheet"** is watched for non-payment — an artefact named nowhere else.

## Source

- `3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Executive_Playbook_Package_Part_2_Value_Engine.docx`
  — 2.7 KB docx → pandoc gfm. Complete; **Part 1 of the package is not in the drop.**
- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-23 samples/Lead Workflow 4282026 - Copy - Copy (1).pdf` —
  32 KB of extracted text from a wide landscape flowchart, `pdftotext -layout`. **Node labels are
  verbatim; the diagram's edges, branch conditions and reading order did not survive conversion
  and were deliberately not reconstructed.** Re-reading the original PDF is required before
  anyone treats this as a process definition.

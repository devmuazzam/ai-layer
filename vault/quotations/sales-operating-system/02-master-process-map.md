---
title: Master Sales Coordinator Process Map — lead intake through job closeout
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Master_Sales_Coordinator_Process_Map_Print_Safe.docx
migrated: 2026-09-04
updated: 2026-08-06
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/dispatch, module/projects-jobs, kind/reference, scheduling, permits, compliance, requirements, purchase-orders]
entities: []
---

# Master Sales Coordinator Process Map — lead intake through job closeout

**What this is.** Version 1.0. Process Owner **Sales Manager**; Primary User **Sales
Coordinator**; Supporting Teams *Sales, Project Engineering, Labor Compliance, Accounting,
Dispatch and Operations*. Its stated purpose: *"Provide one controlled workflow from first
customer contact through scheduling, execution support and closeout."*

> **CONTROL STANDARD: No job reaches Dispatch without complete, approved and executable
> information.**

The document is explicit about its own scope: *"It does not replace the supporting playbooks. It
identifies **when each playbook is triggered, who owns the next action, what must be complete
before the job advances, and where the process loops backward** when information changes or an
approval is missing."*

---

## 1. Core rules

- Every opportunity must have an **owner, current status, next action and due date**.
- **No quote is released without required internal review and approval.**
- No customer approval is treated as complete without written support, required PO/contract
  status and **payment readiness**.
- Labor compliance, permits, lift plans, insurance and third-party requirements must be
  **identified early and resolved before execution**.
- **Dispatch has the right to reject an incomplete handoff and return it to the Sales
  Coordinator.**
- Any change to date, time, location, crane, scope or vendor support **triggers a schedule-change
  review**.
- Additional permit, lift-plan and third-party costs created by a change must be **communicated,
  approved and billed**.
- The Sales Coordinator remains responsible for tracking the job until the required handoff or
  closeout is complete.

## 2. The 13 stages

| # | Stage | Primary owner | Required output / exit gate | Supporting playbook(s) |
| ---: | --- | --- | --- | --- |
| 1 | **Lead Intake** | Sales Coordinator | Lead entered in **CRM/FCC** with complete minimum intake, owner, urgency, next action and **customer acknowledgment** | This map; New Customer Playbook when new |
| 2 | **Qualification** | Sales Coordinator + Salesperson | **Quote path selected**: direct quote, job walk, bid, engineering review, or decline/no-fit | Creating Quotes SOP; Commercial Decision Playbook when pricing pressure exists |
| 3 | **Job Walk Decision** | Sales Coordinator + Qualified Representative | Job walk scheduled, completed and **attached**; or documented measurements and customer-supplied information support the quote | Job Walk process; Creating Quotes SOP; 3D Lift Plan Playbook |
| 4 | **Quote Development** | Sales Coordinator | FCC quote complete with **crane, crew, travel, minimums, rigging, permits, lift-plan charges, third parties, compliance and exclusions** | Creating Quotes in FCC Playbook; Creating Quotes SOP; 3D Lift Plan; Lift Plan Submission; NOTAM; FAA Permit A1 Survey |
| 5 | **Internal Approval** | Salesperson / Sales Manager | Quote approved, revised, escalated or declined. **No customer release before approval.** | Commercial Decision Playbook; Contracts and COI SOP for unusual terms |
| 6 | **Customer Approval & Commercial Clearance** | Sales Coordinator | **Written approval/signed quote received**; PO, contract, new-customer setup, deposit/payment terms and billing information cleared | New Customer Playbook; New Customer Packet; Contracts and COI SOP; COI Request Playbook |
| 7 | **Compliance / Engineering / Vendor Gates** | Sales Coordinator + Functional Owner | All applicable compliance, permits, lift plans, FAA/NOTAM, **vendor POs** and customer approvals complete **or controlled by an approved exception** | Labor Compliance; Davis-Bacon; Certified Payroll; NOTAMS; FAA Permit A1 Survey; Lift Plan Submission; Permit Waiver; Vendor Coordination |
| 8 | **Ready to Schedule** | Sales Coordinator | Ready-to-Schedule checklist complete; **job sheet and scheduling sheet contain executable information** | Ready to Schedule; Scheduling Sheet; Post-Scheduling Lift Plan Completion when approved |
| 9 | **Dispatch Handoff & Acceptance** | Sales Coordinator → **Dispatch** | Dispatch receives the complete packet, reviews it, **accepts** it and confirms scheduling. **Rejection returns to the Sales Coordinator.** | Scheduling with Dispatch Value Engine; Scheduling Sheet |
| 10 | **Pre-Job Confirmation** | Sales Coordinator | Customer confirmation email **scheduled for 8:00 a.m. the day before**; Dispatch CC'd | Day-Prior Automatic Email Playbook |
| 11 | **Schedule-Change Control** | Sales Coordinator + Dispatch | Every change reviewed for operational, permit, lift-plan and third-party **cost** impact; **customer approval documented before finalizing** | Schedule Change; Permit Waiver; Lift Plan Submission |
| 12 | **Job Execution Support** | Dispatch + Operations; SC supports | Active issues, customer requests and documentation changes routed to the correct owner **without bypassing Dispatch** | Applicable exception playbook |
| 13 | **Job Closeout** | Sales Coordinator + Accounting / Salesperson | CRM/job record updated; missing PO/compliance/billing support resolved; customer follow-up completed; **opportunity closed or next opportunity created** | Commercial Decision Playbook if adjustment/concession; Invoice Adjustment Request; post-job follow-up |

**Against [quotation-flow-process.md](../quotation-flow-process.md).** That page's 27 steps cover
stages 1–6 here and then jump straight to *"Approved quotation is converted into a Project"*.
Stages 7–13 — compliance/engineering/vendor gates, the ready-to-schedule gate, the Dispatch
acceptance handshake, day-prior confirmation, change control and closeout — **have no counterpart
in the vault at all**. Conversely, the flow page's DocuSign detail (send, track, revise, sign)
does not appear here: this map says only *"written approval/signed quote received"*.

## 3. Decision points and loop-backs

Nine yes/no decisions, each with both branches stated:

| Question | Yes / Unknown | No |
| --- | --- | --- |
| Is the customer new? | Run the New Customer Playbook and **obtain AR/payment clearance** | Confirm existing account, billing contact, current terms and job-specific requirements |
| Is a job walk required? | Schedule and complete **before final crane selection or quote release** | Continue **only when** reliable measurements, photos and site information are documented |
| Is a lift plan required? | Determine package, **quote the charge**, submit the request and track completion | **Document why a plan is not required** and maintain adequate lift information |
| Near an airport / FAA review? | Evaluate FAA permit, NOTAM, waiver and A1 Survey requirements | Continue through normal permit review |
| Does labor compliance apply, **or remain unknown**? | Send and obtain the Labor Compliance form; route to Labor Compliance **before scheduling** | Document the customer response and continue |
| Contract or COI requirements present? | Route the full request through the Sales Manager; **do not sign, accept or promise coverage** | Continue with standard commercial clearance |
| Third parties required? | Obtain **pricing, customer approval, vendor PO, availability and confirmation** before handoff | Note not applicable |
| Any required item incomplete at Dispatch review? | **Dispatch rejects the packet** and identifies the missing item; SC corrects and resubmits | Dispatch accepts and schedules |
| Customer changed schedule or scope? | Trigger Schedule Change review and **re-open affected permits, lift plans, vendors, pricing and approvals** | Continue to day-prior confirmation |
| Did a change create additional cost? | **Customer must be informed and written approval obtained before the change is finalized** | Document the no-cost impact and proceed |

Note the *"or remain unknown"* on labor compliance: **unknown is treated as yes.** The Operations
Manual states the same principle generally — *"Unknown compliance, permit, contract, insurance or
engineering requirements are treated as unresolved—not as 'not applicable.'"*

## 4. The Dispatch handoff package

Thirteen checkbox lines. This is the most concrete requirement statement in the whole set,
because it enumerates what must exist before a job can be scheduled:

☐ Customer legal name, quote/job number, salesperson and **billing status**
☐ Confirmed job date, requested on-site time, **leave time** or timing requirements
☐ Complete jobsite address, site contact, phone number, **access and arrival instructions**
☐ Clear scope of work, load description, **verified weight**, pick/set information, radius, height and known obstructions
☐ Crane, crew, rigging, trucking, support equipment and **special personnel** requirements
☐ Job sheet and **Scheduling Sheet** completed and attached
☐ Customer **written approval, signed quote, PO/contract status** and new-customer payment clearance
☐ **Labor compliance status** and completed forms when applicable
☐ **Permit status, FAA/NOTAM status and permit waiver status** when applicable
☐ **Lift plan status**: complete and attached, **or an approved *Lift Plan Pending* exception clearly identified**
☐ Third-party vendor details, **POs, arrival times and confirmed availability**
☐ Safety concerns, ground/access limitations, site restrictions and special instructions
☐ All customer emails, drawings, plans, pictures and supporting documents required for execution

## 5. Dispatch's four possible responses

| Decision | Meaning | Required next action |
| --- | --- | --- |
| **ACCEPTED** | Packet is executable and resources can be scheduled | Dispatch confirms acceptance and scheduling. SC updates **CRM/FCC to Scheduled** and begins pre-job confirmation |
| **RETURNED – MISSING INFORMATION** | One or more required items incomplete, unclear or unsupported | Dispatch identifies the missing item. SC obtains/corrects it and **resubmits the complete packet** |
| **DATE / RESOURCE CONFLICT** | Requested crane, crew or timing unavailable | SC coordinates alternatives with Dispatch and customer. Any customer-approved change **triggers the Schedule Change Playbook** |
| **SCOPE / RISK ISSUE** | Packet reveals a crane, engineering, safety, permit or scope concern | Return to quoting, job walk, lift planning, compliance or management review. **Do not schedule until released.** |

> **Scheduling Completion Standard** — *"A job is considered scheduled **only after Dispatch
> accepts the handoff and confirms the scheduled date/resources**. A customer request, tentative
> date, quote note or calendar entry does not replace Dispatch acceptance."*

**This is a stated state-machine requirement for the ERP.** "Scheduled" is not a status the sales
side can set; it is the result of an acceptance action by Dispatch, with three distinct rejection
reasons that route to different places. Nothing in the vault models a Dispatch acceptance step —
[dispatch/daily-allocation-system.md](../../dispatch/daily-allocation-system.md) starts from the
assumption that the job exists and is allocable.

## 6. Pre-job confirmation and the schedule-change loop

**Day-prior confirmation** — six checks:

☐ Schedule the customer confirmation email for **8:00 a.m. the day before** the job
☐ **CC Dispatch on every confirmation email**
☐ Confirm job date, timing, location, site contact, arrival instructions and major scope details
☐ Confirm vendor timing and special requirements
☐ Log the communication in the job record or CRM
☐ Any new information that changes execution **triggers the Schedule Change Playbook**

**Schedule-change loop** — eight ordered steps:

1. Record exactly **what changed and who requested it**.
2. Notify Dispatch immediately; **do not promise the new schedule before availability is
   confirmed**.
3. Review impact on crane/crew, permits, FAA/NOTAM, lift plans, compliance and third parties.
4. **Calculate additional permit, lift-plan, vendor, cancellation, rescheduling, mobilization or
   other costs.**
5. Communicate the impact and obtain **written customer approval**.
6. Update the quote/change order, job sheet, Scheduling Sheet, CRM/FCC and supporting documents.
7. **Resubmit the revised package to Dispatch for acceptance.**
8. **Replace or cancel the previously scheduled day-prior email and set the correct one.**

Step 6 names a **change order** as an artefact that updates alongside the quote — the same object
the March 2026 schema models as `CHANGE_ORDER` hanging off the job, with `amount_delta` and
`approved_at`
([../quote-lifecycle-permits-and-purchase-orders.md](../quote-lifecycle-permits-and-purchase-orders.md)
§3). **These two documents are the only places in the vault where change orders appear.**

## 7. Job closeout

☐ Confirm the job status is **completed** in the appropriate system
☐ Resolve missing **PO, billing contact, compliance record, signed ticket** or customer documentation
☐ Route invoice adjustment or concession requests through the approved commercial decision process
☐ Update CRM notes, outcome, revenue opportunity, customer issues and next action
☐ Capture customer feedback and future work when assigned
☐ **Close the opportunity as won, lost, completed or converted to a new opportunity**
☐ Retain the final job record, approvals, permits, lift plans, vendor records and customer communications

## 8. The supporting playbook directory

A 13-row trigger table mapping Value Engines to their documents. It is the same registry as
[01-operating-system-architecture.md](01-operating-system-architecture.md) §5 in a shorter form,
with one addition worth noting: the **Billing / Adjustments** row's trigger is *"Post-job charge,
credit, discount or invoice correction is requested"*, routing to *Invoice Adjustment Request;
Commercial Decision Playbook*.

## Source

`3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Master_Sales_Coordinator_Process_Map_Print_Safe.docx`
— 15 KB docx → pandoc gfm. Version 1.0 | Master Process Map. All nine sections transcribed or
tabulated above.

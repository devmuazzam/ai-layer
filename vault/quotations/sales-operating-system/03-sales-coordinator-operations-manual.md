---
title: Sales Coordinator Operations Manual — the role in detail
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Sales_Coordinator_Operations_Manual.docx
migrated: 2026-09-04
updated: 2026-08-06
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/dispatch, module/admin, kind/sop, requirements, compliance, scheduling, permissions-roles, reporting]
entities: []
---

# Sales Coordinator Operations Manual — the role in detail

**What this is.** Volume 1 of the seven operating manuals the architecture calls for, and the
only one delivered. *"This manual converts the Master Sales Coordinator Process Map into detailed
operating instructions. It defines what the Sales Coordinator must do, when the work begins, what
information is required, which approvals are needed, which systems must be updated and how
ownership is transferred between departments."*

**Why it matters for the ERP.** §2 is a stated **permissions model** — a list of things this role
may and may not do — and §4 gives every phase its required inputs, exit gate, decision owner,
systems to update and handoff target. That is closer to a specification than anything else in the
governance set.

---

## 1. Scope and core principles

**Scope** — crane rental, operated crane service, rigging, transportation, permits, lift
planning, third-party support and related service opportunities. Begins at *"a lead, request for
quote, bid invitation, repeat-customer request or internal handoff"*. Explicitly **does not**
authorise the coordinator to *"select unsafe equipment, approve legal terms, waive charges,
promise unavailable resources or override a functional owner."*

**Core operating principles**, verbatim:

- *"Every opportunity has **one owner, one current status, one next action and one due date**."*
- *"**Written customer approval is required; verbal approval alone is not a complete commercial
  record.**"*
- *"**Unknown** compliance, permit, contract, insurance or engineering requirements are treated as
  **unresolved—not as 'not applicable.'**"*
- *"**Dispatch acceptance is the scheduling gate.** A tentative date, calendar note or customer
  request does not mean the job is scheduled."*
- *"Any change to date, time, location, crane, scope, access, vendor support or compliance
  requirement **reopens the affected review gates**."*
- *"The Sales Coordinator documents facts, routes decisions to the correct owner and follows
  through **until the next owner formally accepts the handoff**."*

## 2. Role definition and authority limits

**This table is a permissions specification in prose.**

| Area | Responsibility | **Authority limit** |
| --- | --- | --- |
| Workflow Control | Maintain the opportunity record, checklist, deadlines, documents and handoffs | **May not bypass required review gates** |
| Customer Communication | Collect missing information, confirm requirements, communicate approved next steps, document changes | **May not promise crane availability, legal acceptance, free services or unapproved pricing** |
| Quote Support | Build or coordinate FCC quotes using approved rates, scope, exclusions and supporting inputs | **Final pricing approval remains with the salesperson/manager under the approval matrix** |
| Scheduling Readiness | Assemble the executable job packet and submit it to Dispatch | **May not represent a job as scheduled until Dispatch accepts it** |
| Compliance Coordination | Trigger forms and route records to Labor Compliance, Payroll, Accounting, Engineering or other owners | **May not interpret legal obligations or certify payroll requirements independently** |
| Change Control | Document changes, notify Dispatch, reopen affected approvals | **May not approve extra cost, credits, discounts or customer concessions outside delegated limits** |
| Closeout | Resolve administrative gaps and preserve the record for billing and future sales activity | **Accounting controls final invoicing and credit decisions** |

The vault's own permissions material (`admin/`, and the 2026-05-05 note that *"Sales can view
Dispatch but not edit"*) is thinner than this. **Nothing says these limits have been translated
into roles.**

## 3. Systems and records

| System / record | Required use | Minimum standard |
| --- | --- | --- |
| **HubSpot CRM** | Lead/opportunity ownership, activity, follow-up, stage, next action, customer history | Current status, next action, due date and meaningful notes maintained |
| **Fleet Cost & Care (FCC)** | Customer/job record, quote, scope, line items, operational notes, job status | **Quote and job information matches the approved commercial and operational package** |
| **Outlook / Email** | Customer approvals, confirmations, changes, vendor commitments, internal handoffs | Material decisions documented in writing and retained with the job record |
| **Scheduling Sheet** | Structured job details for the Dispatch handoff | All required fields complete, readable and **consistent with FCC** |
| **Approved Forms** | New customer, labor compliance, permit waiver, invoice adjustment and other controlled forms | Current approved version used and routed to the correct owner |
| **Supporting Files** | Photos, plans, lift information, permits, COIs, contracts, vendor quotes, POs | Clearly named and attached to the record or handoff package |

> **System-of-Record Rule** — *"When information appears in more than one place, the Sales
> Coordinator **must reconcile differences before handoff**. Dispatch must not receive conflicting
> times, addresses, crane sizes, contacts, scope notes or vendor instructions."*

**That rule exists because there are six systems and no integration.** An ERP that unified
HubSpot, FCC, the Scheduling Sheet and the forms would eliminate the manual reconciliation this
manual makes a duty.

## 4. Phases 1–13 — the control table

Each phase has the same six controls: Trigger · Required Inputs · Required Output / Exit Gate ·
Approvals / Decision Owner · Systems / Records · Handoff. Condensed here to the inputs and the
exit gate, which are the parts that constrain a build.

| Phase | Required inputs | Exit gate | Handoff |
| --- | --- | --- | --- |
| **1 Lead Intake** | Customer/company name; contact information; **request source**; jobsite city/address if known; requested date; high-level scope; **urgency**; assigned salesperson | Lead entered; customer acknowledged; owner and next action established | SC → assigned salesperson or qualification owner |
| **2 Qualification** | Scope, weight, pick/set details, radius/height if available, site conditions, schedule, **commercial fit**, customer status, **service area** | Path selected: direct quote / job walk / engineering-lift-plan review / bid / decline / request more information | SC → quoting owner / job walk owner / manager |
| **3 Job Walk** | Site contact; access; address; equipment/load information; photos/drawings; known restrictions; requested date | Job walk scheduled and completed, **or a documented manager decision that it is not required**. Findings attached | SC → qualified field representative → quoting owner |
| **4 Quote Development** | Crane/crew assumptions; travel; **minimums**; rigging; trucking; permits; lift plan; third-party costs; compliance; **exclusions**; schedule assumptions | Complete FCC quote ready for internal review | SC → salesperson/manager for approval |
| **5 Internal Approval** | Quote, scope, assumptions, **margin/discount facts, competitor facts if relevant**, unusual terms, supporting cost information | Approved quote released, revision requested, escalation made or opportunity declined | Approver → SC → customer |
| **6 Customer Approval & Commercial Clearance** | **Written acceptance; signed quote; PO; billing contact; contract; new-customer documents; deposit/payment requirements** | Commercially cleared job **or a documented list of outstanding items** | SC → Accounting/AR, contract owner or next readiness gate |
| **7 Compliance / Engineering / Vendor Gates** | Completed customer forms; project/funding details; contract requirements; site data; **vendor quotes**; drawings; dates | Each applicable gate complete, formally accepted by the owner, **or controlled by an approved exception** | SC → functional owner → SC for readiness confirmation |
| **8 Ready to Schedule** | Final scope; date/time request; address; contact; crane/crew; lift plan; permits; compliance; vendors; payment/PO status; safety/access notes | Ready-to-Schedule checklist **and** Scheduling Sheet complete | SC → Dispatch |
| **9 Dispatch Handoff** | The full Dispatch handoff package (§5) | Accepted and scheduled, returned for missing information, resource conflict, or scope/risk escalation. **"Dispatch has final acceptance authority for scheduling."** | Dispatch → SC **with explicit status** |
| **10 Pre-Job Confirmation** | Accepted schedule, site contact, arrival instructions, vendor timing, latest scope | Confirmation email scheduled for **8:00 a.m. the day before**; Dispatch copied; response or changes tracked | SC → customer and Dispatch |
| **11 Schedule / Scope Change Control** | Exact requested change; **requester**; timing; operational impact; permit/lift-plan/vendor impact; **added cost** | Approved revised plan and resubmitted Dispatch package, **or documented rejection/cancellation** | SC coordinates all affected owners, returns to Dispatch |
| **12 Execution Support** | Dispatch/field report, customer request, documentation need or unexpected condition | Issue routed to the correct owner **without bypassing Dispatch**; customer record updated | SC supports Dispatch and customer communication as assigned |
| **13 Job Closeout** | Job status; **signed tickets**; PO/billing support; compliance records; customer issues; adjustment requests; follow-up opportunity | Clean administrative record supporting invoice, customer follow-up and opportunity closure | SC → Accounting and salesperson; unresolved items escalated |

Three exception-rule callouts are repeated verbatim after phases 3, 7, 9 and 11:

> *"If the required information is incomplete, conflicting or changed, **stop advancement**,
> identify the missing item, assign the next action and **return to the prior responsible phase.
> Do not create a workaround that hides the gap.**"*

## 5. Compliance and specialty triggers

Nine trigger questions, each with a "yes or unknown" route. **Unknown routes the same way as
yes** throughout.

| Trigger question | If yes **or unknown** |
| --- | --- |
| Is the customer new or are payment terms changing? | Start customer setup; **obtain AR/payment clearance before scheduling** |
| Is the work public works, prevailing wage, Davis-Bacon, federally funded, PLA, OCCIP/CCIP **or unknown**? | Send the Labor Compliance form and route it **before scheduling** |
| Is the site near an airport or does FAA review apply? | Evaluate FAA permit, NOTAM and A1 Survey requirements **immediately** |
| Is a lift plan or engineered package required? | **Define the package, quote the charge**, submit and track completion |
| Did the customer provide a contract, PO terms or insurance requirements? | Route the full document; **do not accept, sign or promise coverage** |
| Are third-party vendors required? | Obtain **cost, customer approval, vendor PO, availability and timing** |
| Is a permit unavailable before the requested date? | **Use only the controlled waiver route** and document risk/approval |
| Is a discount, free service, match or concession requested? | Prepare facts and route through the approval matrix |
| Is an invoice correction or post-job credit requested? | Use the controlled adjustment process; **preserve original facts** |

## 6. Daily operating rhythm

The only place in the drop that states a working-day cadence, and it carries one hard scheduling
deadline.

| Time / cadence | Required activity | Control standard |
| --- | --- | --- |
| **Start of Day** | Review today's jobs, next-day jobs, overdue tasks, new leads, customer replies, **Dispatch returns** and compliance/engineering deadlines | No urgent or overdue item remains unassigned |
| Morning Priority Block | Same-day customer responses, quote inputs, Dispatch corrections, deadline-driven permit/compliance actions | **Work highest operational risk first** |
| Midday Control Check | Review opportunities awaiting customer approval, internal approval, PO/payment, contracts, compliance, lift plans, permits or vendors | **Every blocked item has a named owner and follow-up date** |
| **Before 12:00 p.m. Scheduling Push** | Submit complete standard scheduling requests and resolve known Dispatch questions | ***"Do not send partial packages to 'hold a spot.'"*** |
| Afternoon Follow-Up | Advance quotes, schedule job walks, confirm vendors, update CRM/FCC, prepare next-day customer confirmations | Systems reflect the latest facts before end of day |
| End-of-Day Close | Review open tasks, tomorrow's deadlines, scheduled-job changes, unanswered customers, escalations | ***"No material commitment or change exists only in personal notes or memory."*** |
| Weekly | Pipeline aging, quote turnaround, Dispatch returns, missing information, compliance delays, open closeout items **with manager** | Patterns identified and corrective action assigned |

**The noon scheduling deadline matters.** It matches the Executive Playbook's Red Path
definition — *"the request falls inside the **72-hour permit window (Monday–Thursday before 12:00
PM)**"* — see
[06-value-engine-flow-and-lead-workflow.md](06-value-engine-flow-and-lead-workflow.md).

## 7. Escalation

Ten issue types, each with an escalation target and an immediate action. Several are stated as
prohibitions and are worth reading as rules:

| Issue | Escalate to | Immediate action |
| --- | --- | --- |
| Crane selection, capacity, radius, ground, access or lift-method uncertainty | Qualified salesperson, Project Engineering or Operations | **Stop final quote/scheduling**; collect facts and route for technical review |
| Discount, free service, unusual margin or competitor match | Salesperson / Sales Manager | Prepare commercial facts, math and **give-get** recommendation |
| Contract language, indemnity, insurance or flow-down terms | Sales Manager / designated contract reviewer | **Do not accept, sign or assure the customer** |
| New-customer credit, deposit, payment or delinquency issue | Accounting/AR and Sales Manager | **Hold commercial clearance until written release** |
| Public works, prevailing wage or certified payroll uncertainty | Labor Compliance / Payroll | **Treat as applicable or unknown until formally cleared** |
| FAA, NOTAM, permit or A1 Survey deadline risk | Permit/engineering owner and Sales Manager | Notify customer of risk and possible added cost; **do not promise approval** |
| Dispatch rejection, resource conflict or unsafe scope | Dispatch and Sales Manager | Document status, **stop customer promise**, coordinate alternatives |
| Customer schedule/scope change after acceptance | **Dispatch first**, then Salesperson/Manager and affected owners | Trigger Schedule Change Playbook; obtain **written** customer approval |
| Customer complaint, field dispute or requested concession | Sales Manager; Dispatch/Operations for active job | Preserve facts; **do not admit fault or promise credit** |
| Repeated missing information or process failure | Sales Manager | Identify root cause, corrective action and training need |

**Escalation message format** — six required parts: *Situation · Customer commitment or deadline ·
Known facts · **Missing decision** (exactly what approval or answer is needed) · Recommendation ·
Owner and follow-up time.*

## 8. Quality-control checklists

**Before quote release**

- Customer and jobsite information is accurate
- Scope and load details are sufficient and **internally consistent**
- Crane/crew/travel/**minimums**/rigging/trucking are included as applicable
- Permit, lift-plan, FAA/NOTAM, labor-compliance and vendor costs are addressed
- **Exclusions and customer responsibilities are clear**
- Pricing and exceptions have required approval
- **Quote is saved in FCC and the customer-facing document matches the approved version**

**Before Dispatch handoff**

- Written customer approval and commercial clearance are present
- Required compliance, engineering, permit and vendor gates are complete or formally excepted
- **FCC and Scheduling Sheet match**
- Date, time, address, contact, crane, scope and support requirements are confirmed
- Attachments are readable and clearly named
- **No conflicting or outdated instructions remain in the package**

**Before closeout**

- Job status and customer outcome are recorded
- **Signed tickets, PO and billing contact** are available or assigned for follow-up
- Compliance and supporting records are complete
- Customer complaint or adjustment request routed through the approved process
- CRM has outcome, notes, next opportunity and follow-up task
- Open administrative issues have an owner and due date

## 9. Training, ramp and scorecard

**Eight training phases**, each with required competencies and *evidence of completion* — the
evidence is behavioural, not a quiz: *"Five accurate supervised opportunities"* (Intake), *"**Five
approved quotes with no material omissions**"* (Quote Support), *"**Five Dispatch packages
accepted without material return**"* (Scheduling Readiness), *"Two supervised change events or
simulations"* (Change Control), *"Five complete closeouts reviewed by manager"* (Closeout),
ending in Independent Certification on manager signoff.

**30/60/90.** First 30 days: understands workflow, systems, playbook triggers and basic intake,
work closely reviewed. Days 31–60: standard intake, quote support, customer follow-up and
readiness prep with decreasing supervision. Days 61–90: **owns standard opportunities through
Dispatch handoff and closeout**. After 90: maintains assigned pipeline independently.

**The 12-metric scorecard** — the operational measures the role is judged on:

| Metric | Definition |
| --- | --- |
| Lead Response Time | Receipt → customer acknowledgment and assigned next action |
| Quote Turnaround | Complete input → approved customer quote |
| Quote Completeness | % of reviewed quotes without material omissions or correction |
| **Dispatch First-Pass Acceptance** | % of submitted packages accepted **without return** |
| Missing-Information Rate | Packages or quotes returned for **avoidable** gaps |
| CRM/FCC Record Quality | Audit score for status, next action, due date, notes, attachments |
| Compliance Gate Accuracy | Correct identification and routing of labor, FAA, lift-plan, contract and permit triggers |
| Customer Confirmation Completion | Scheduled jobs receiving correct day-prior confirmation **with Dispatch copied** |
| Change-Control Compliance | Changes documented, priced, approved and resubmitted **before execution** |
| Closeout Aging | Time to resolve missing PO, ticket, billing or compliance records |
| Customer Responsiveness | Timely, professional updates when information is missing or status changes |
| Process Improvement | Useful issues, root causes and improvement ideas identified |

> **Performance Balance** — *"Speed is not success when it creates rework, risk or incomplete
> handoffs. Quality is not success when the work sits without follow-up."*

**Dispatch First-Pass Acceptance and Missing-Information Rate are only measurable if the ERP
records a Dispatch rejection as an event with a reason.** Nothing in the vault does.

## 10. Manager audit guide

Eight audit areas, each with a review question and the evidence to look at: Pipeline Control
(HubSpot activity/task review) · Quote Quality (FCC quote sample) · Approval Discipline (approval
email/form) · Specialty Trigger Recognition (forms and routed records) · Dispatch Handoff
(Scheduling Sheet and Dispatch response) · Change Control (revised quote, email, system record) ·
Closeout (FCC/CRM and accounting support) · Professional Ownership (correspondence and manager
observation).

## Source

`3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Sales_Coordinator_Operations_Manual.docx`
— 35 KB docx → pandoc gfm, 441 non-blank lines, 16 sections. Sections 13 (conduct standards), 14
(playbook reference matrix — a duplicate of the architecture's registry) and 16 (final success
standard) are summarised rather than transcribed; everything else above is from the source.

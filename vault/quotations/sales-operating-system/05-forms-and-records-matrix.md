---
title: Forms, Templates and Required Records Matrix
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Forms_Templates_and_Required_Records_Matrix.docx
migrated: 2026-09-04
updated: 2026-08-06
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/accounting, module/dispatch, module/payroll, kind/reference, compliance, permits, certified-payroll, lift-plans, purchase-orders, invoicing, requirements]
entities: []
---

# Forms, Templates and Required Records Matrix

**What this is.** *"Controlled Document and Workflow Reference"* — Document Owner **Sales
Operations**, Version 1.0, Review Cycle *"At least annually or whenever a process/form changes"*,
Status *"Controlled Operating Document"*. Its purpose: *"Establish one source of truth for every
operational form, template, approval record, and supporting document used from customer setup
through dispatch, billing, and closeout."*

**Why it matters.** It is the inventory of **artefacts** the workflow produces, with a stated
completion standard, approver, system of record and controlling playbook for each. If the ERP
replaces any of these forms, this table says what the replacement must capture and who must
approve it.

---

## 1. Document control policy

- **Only the current approved version** of a form or template may be used.
- The document owner controls revisions, naming, required fields and **retirement of obsolete
  versions**.
- *"Completed forms must be stored in the designated **system of record rather than only in
  email**."*
- *"**A job may not move forward when a required record is incomplete, unapproved, or missing.**"*
- *"Email approval is acceptable **only when the applicable playbook permits it** and the approval
  is saved with the job record."*
- When procedures overlap, the controlling playbook identified in this matrix governs.

> **Core Control Rule** — *"No form is considered complete until **all required fields,
> attachments, approvals, and storage steps** are finished."*

## 2. The 14 controlled forms

Columns in the source: `# | Document | Phase | Trigger | Owner | Required Output | Approval |
System of Record | Controlling Playbook | Next Process`. Condensed to trigger, output, approver
and system of record.

| # | Document | Trigger | Required output | Approval | System of record |
| ---: | --- | --- | --- | --- | --- |
| 1 | **New Customer Packet** | New customer or **material customer information change** | Customer-completed packet; credit and contact data | Sales Manager / Accounting as required | FCC, HubSpot, Accounting files |
| 2 | **Labor Compliance & Payroll Requirement Form** | Quote involves public works, prevailing wage, certified payroll, **LAUSD**, Davis-Bacon, OCCIP/CCIP, **or status is unknown** | Completed requirement form **and attached agency packet** | Labor Compliance **and** Payroll | **FCC job record** and compliance folder |
| 3 | **Permit Waiver** | Customer requests scheduling before permit lead time, or required permit is issued | **Signed customer waiver and Dispatch acknowledgment** | Sales Manager / Dispatch as required | FCC and job folder |
| 4 | **Scheduling Sheet** | Job is ready to enter the scheduling workflow | Complete scheduling record with quote number, scope, dates, resources, **permit/compliance status** | **Dispatch acceptance** | Scheduling system / FCC |
| 5 | **Ready-to-Schedule Checklist** | Coordinator believes all prerequisites complete | **Pass/fail checklist** and supporting attachments | Dispatch acceptance | FCC and scheduling record |
| 6 | **Lift Plan Request** | Lift plan requested or required by customer, contract, site or **risk level** | Complete lift data package, drawings, photos, load details, radius, height, setup constraints | Project Engineering / Sales approval as applicable | FCC, 3D Lift Plan folder |
| 7 | **Day-Prior Customer Confirmation Email** | Scheduled job reaches the day-prior window | Written confirmation of time, address, contact, scope, access, readiness **and changes** | Customer confirmation; **Dispatch informed of changes** | Outlook, FCC, job file |
| 8 | **Schedule Change Record** | Customer changes date, time, scope, address, access, crane or readiness | Documented change, **cost impact**, approvals and revised schedule data | Sales Manager / Dispatch / Engineering as applicable | FCC, email, scheduling system |
| 9 | **Commercial Decision Form** | Discount, concession, quote change, competitive response or **margin exception** requested | **Facts, math, job economics, give-get terms, decision** | Sales Manager / senior management **per authority** | HubSpot/FCC and approval record |
| 10 | **Invoice Adjustment Form** | Credit, discount, write-off, correction or invoice dispute requested | Reason, amount, job information, **responsibility, recovery plan**, approval | Sales Manager / Accounting / Management **per threshold** | Accounting system and job file |
| 11 | **COI Request / Insurance Record** | Customer or contract requires insurance evidence or endorsements | Accurate requirements submitted; COI and endorsements returned | Contract/management review **if nonstandard** | Job folder / FCC |
| 12 | **Contract Review Record** | Customer contract, PO, **flow-down** or terms require review | Approved, redlined or rejected agreement | Sales Manager / Management / **counsel as required** | Contract folder / FCC |
| 13 | **FAA / NOTAM Request** | Crane height and location trigger aviation review | Submitted FAA/NOTAM data and **determination** | Project Engineering / **customer cost approval for A1 survey** | Permit folder / FCC |
| 14 | **Certified Payroll Packet** | Covered job requires certified payroll reporting | Complete certified payroll submission package | Labor Compliance approval | Compliance records |

**Two things bind other modules.** Form 2 says the labor-compliance form's output lands *in the
FCC job record* — a compliance flag on the job, not a filed PDF. Form 14 is the sales-side trigger
for the certified-payroll machinery documented in `payroll/`.

## 3. Labor compliance and public works records

A second table, keyed on when each record is required and what releases the gate:

| Record | When required | Required evidence | Release gate |
| --- | --- | --- | --- |
| **Labor Compliance & Payroll Requirement Form** | ***Sent with every quote***; mandatory review whenever funding or public-work status may apply | Customer selections, **public agency, project number, wage determination/funding status**, required packet attachments | **No scheduling release before compliance review when covered or unknown** |
| Prevailing Wage / Public Works Packet | State, federal, blended **or unknown** public works | Applicable packet completed and attached | Compliance clearance |
| Davis-Bacon Record | Federally funded or federal-only work | Federal funding identification, wage determination, reporting obligations | Payroll setup and reporting plan |
| Certified Payroll Packet | Certified payroll required | Worker classifications, hours, **wage/fringe data**, submission records | Ongoing reporting and closeout |
| **LAUSD School Code** | LAUSD work | **Valid school code before labor hours are reported** | Required before LAUSD reporting |
| **OCCIP/CCIP Enrollment** | Project has a controlled insurance program | Enrollment confirmation | ***"Company cannot be onsite without required enrollment."*** |

**The LAUSD school code and OCCIP/CCIP enrolment are specific, blocking data items that appear
nowhere else in the vault.** Both are job-level attributes that must exist before work happens,
and both originate on the sales side.

## 4. Lift Plan Request — the minimum data set

Listed because it defines what the quote must have collected before Engineering will act:

- Customer and project name, exact jobsite address, **quote number**, requested date
- Load description, **exact weight**, dimensions, lifting points, **centre-of-gravity information
  when available**
- **Pick radius, set radius, required hook height**, obstructions, structure clearances, travel
  path
- Crane setup area, **outrigger restrictions, ground conditions**, access restrictions, site
  photographs
- Customer drawings, equipment data sheets, roof plans, site plans, **any required engineer
  format**
- Requested crane configuration, **boom/jib/luffer need**, and required plan due date

> **Engineering Stop Rule** — *"Project Engineering may **reject or return** a lift-plan request
> that lacks enough verified information to produce a safe and accurate plan."*

Every item here is captured by the Job Walk Sheet —
[../sales-intake-and-job-walk.md](../sales-intake-and-job-walk.md) §2 — which is presumably why
that sheet exists.

## 5. Scheduling and dispatch records — complete vs rejected

| Record | Complete means | Rejected when | Next step |
| --- | --- | --- | --- |
| **Scheduling Sheet** | Customer, quote number, site, scope, requested date/time, crane/resources, permit status, compliance status, contract/COI status, billing requirements and customer contacts are recorded | **Required field missing, scope unclear, approvals incomplete, or conflicting information exists** | Ready-to-Schedule quality gate |
| **Ready-to-Schedule Checklist** | Every prerequisite marked complete **or an approved exception attached** | ***"Any required item is assumed, verbal only, expired, or unsupported."*** | Formal email/system handoff to Dispatch |
| **Permit Waiver** | Customer accepts permit risk **in writing** and internal approvals/Dispatch confirmation documented | Waiver unsigned, **does not describe risk**, or company cannot legally/safely proceed | Conditional scheduling or denial |
| **Day-Prior Confirmation** | Customer confirms job date, **leave/on-site time**, contact, scope, address, access, readiness and changes in writing | Customer does not respond **or reports a material change** | Dispatch update, escalation or rescheduling |
| **Schedule Change Record** | Original schedule, requested change, **cause**, cost impact, permit/lift-plan impact, approvals and new confirmation documented | Change entered **without rechecking** resources, permits, compliance, engineering and cost | Reissue handoff and notify affected teams |

*"Any required item is **assumed, verbal only, expired, or unsupported**"* is a four-way
definition of an invalid record and is a directly implementable validation rule.

## 6. Definition of a complete Dispatch handoff

> *"Dispatch receives **one complete, internally consistent package** that can be scheduled and
> executed **without searching through email chains or repeatedly contacting Sales** for missing
> information."*

| Element | Minimum standard |
| --- | --- |
| Customer and billing identity | Exact approved customer name **and quote number** |
| Jobsite and contacts | Exact address, project name, **ordered-by contact, onsite contact**, phone numbers, access instructions |
| Date and timing | Requested date, **leave time, onsite time, duration assumptions**, any hard shutdown/arrival requirement |
| Scope | Work description, load, weight, dimensions, pick/set conditions, included services |
| Equipment and labor | Requested/approved crane, riggers, trucks, forklifts, **traffic control**, other resources |
| Engineering | Lift plan status **and current approved version attached** when required |
| Permits | Permit status, issued permit, **waiver, restrictions, lead-time issues** |
| Compliance | Labor compliance review complete; Davis-Bacon, prevailing wage, certified payroll, LAUSD, OCCIP/CCIP identified |
| Commercial and contractual | Approved quote, PO/contract status, **billing instructions, exclusions, approved exceptions** |
| Customer confirmation | Latest written confirmation and any changes documented |
| **Acceptance** | **Dispatch confirms acceptance. *Silence is not acceptance.*** |

## 7. Commercial Decision Form — required fields

The Commercial Decision Playbook is missing from the drop; **this is the only description of what
it requires**.

| Field | Required content |
| --- | --- |
| Customer and job | Customer, **quote/invoice number**, project, salesperson |
| Decision requested | Discount, price match, scope concession, quote revision, credit, write-off, or other exception |
| **Dollar impact** | **Original amount, requested reduction, revised amount, gross-dollar impact, estimated profit impact** |
| Facts | Customer reason, **competitor information**, service issue, documentation, timeline |
| **Give-get** | *"What the company receives in exchange: **immediate payment, broader scope, future commitment, schedule flexibility, reduced risk**, or other measurable value."* |
| Responsibility | Whether the cause is **customer-driven, company-driven, shared, or unknown** |
| Approval | **Named approver, date/time, approved amount, conditions, and expiration if applicable** |
| System update | FCC/HubSpot/accounting updated and approval attached |

*"Estimated profit impact"* requires a cost figure per line — which is what FCC's Quote Profit
Forecast computes and TCG says it does not use. See
[../quote-profit-forecast.md](../quote-profit-forecast.md) §6. **Nothing in the drop says where
the profit number for a concession decision comes from.**

**Invoice adjustment controls:**

- *"**Accounting does not process a reduction solely from an informal salesperson request.**"*
- The request must include invoice amount, requested adjustment, reason, **job profitability
  information**, supporting evidence and approval.
- *"Any **recoverable amount, back-charge, rebill, insurance claim, or customer responsibility**
  must be identified before approval."*
- *"Approved adjustments must be **traceable to the final accounting entry** and customer
  communication."*

## 8. Nine controlled email templates

| Template | Trigger | Required content | Recordkeeping |
| --- | --- | --- | --- |
| **Missing Information** | A required field, attachment, approval or customer answer is absent | Specific missing items, **why each is needed**, requested deadline, workflow impact | HubSpot/FCC or job file |
| **Quote Sent** | Approved quote is transmitted | **Quote number, scope summary, exclusions, expiration, next steps, required customer forms** | Log in HubSpot |
| **Permit Delay** | Permit may not be issued by requested date | Status, agency timing, risks, **waiver options if allowed**, decision deadline | Save with permit record |
| **Lift Plan Submission** | Plan ready for customer review | **Version/date, assumptions, approval request, limitations, change-control warning** | Save with current plan |
| **Day-Prior Confirmation** | Job scheduled for next-day execution | Date/time, location, onsite contact, scope, access, readiness, **reply request** | Save confirmation; notify Dispatch |
| **Schedule Change** | Customer requests or confirms a change | Original details, revised details, **cost/permit/engineering impact**, approval, next steps | Save with schedule change record |
| **Contract Redlines** | Revised agreement returned | Professional summary, attached redlines, contact invitation, execution next step | Save in contract folder |
| **COI Request** | Insurance evidence needed | **Exact certificate holder, coverage limits, endorsements**, job/customer, deadline | Save request and returned documents |
| **Invoice Follow-Up** | Invoice disputed or overdue | Invoice number, amount, due date, issue, requested action, supporting records | Log with accounting/customer record |

**The *Quote Sent* template is the closest thing in the drop to a specification for the
quote-delivery email** the punch lists complain about — [../quotations.md](../quotations.md) asks
for *"proper email templates for quotation"*, an added `TCG: ` subject prefix, and *"Need to
demand text from TCG team for email"*. **This is that text's content requirement, though not its
wording.** Note that it requires **exclusions and expiration** in the covering email, not only in
the PDF.

## 9. Required records by workflow gate

| Record | Before Dispatch | Before Billing | Before Closeout | Owner |
| --- | --- | --- | --- | --- |
| Approved customer setup | Required | Required | Required | SC / Accounting |
| Approved quote and scope | Required | Required | Required | Salesperson / SC |
| PO / contract status | Required as applicable | **Required** | Required | SC |
| COI / endorsements | Required as applicable | Reference | Archive | SC |
| Permit / waiver | **Required** | Reference | Archive | SC |
| Lift plan / approval | Required as applicable | Reference | **Archive current version** | Engineering / SC |
| Labor compliance clearance | **Required** | **Required for compliant billing** | **Required reporting complete** | Labor Compliance |
| Scheduling sheet / Dispatch acceptance | Required | Reference | Archive | SC / Dispatch |
| Day-prior confirmation | Required | Reference | Archive | SC |
| **Field tickets / time records** | **Not yet** | **Required** | Required | Dispatch / Field Operations |
| Change orders / schedule changes | Required when known | Required | Required | Sales / SC |
| Commercial approvals / invoice adjustments | As applicable | Required | Required | Sales Manager / Accounting |
| Final invoice and payment record | No | Required | Required | Accounting |

## 10. Missing-documentation escalation matrix

| Issue | Immediate action | Escalate to | **Stop / release rule** |
| --- | --- | --- | --- |
| Missing customer information | Send specific missing-information request; **hold dependent work** | Salesperson → Sales Manager | No release until critical information is verified |
| Missing permit or permit uncertainty | Confirm agency requirement and timing; document status | Sales Manager, Dispatch; Engineering if height/site impacts | **No scheduling unless issued or an approved waiver path is valid** |
| Incomplete lift-plan data | Return request with missing-data list | Salesperson, Project Engineering | **No plan completion or execution based on assumptions** |
| Unknown labor compliance status | Route form for review; identify funding/agency | Labor Compliance, Sales Manager | **No scheduling until reviewed** |
| Unsigned contract / unacceptable terms | Hold execution; route for review | Sales Manager, Management, counsel | No commitment beyond approved authority |
| **No Dispatch acceptance** | Follow up directly; document conflict or missing items | Dispatch Manager / Sales Manager | ***"Job is not considered scheduled."*** |
| Invoice adjustment without facts | Return request for job economics and documentation | Sales Manager / Accounting | No accounting adjustment without approval |
| Customer changes after confirmation | Record change; revalidate all affected requirements | Dispatch, Engineering, Compliance, Sales Manager | **"Do not rely on prior approval when the change is material."** |

## 11. File naming and version control

- **`Customer_Project_QuoteNumber_DocumentType_YYYY-MM-DD_Version`**
- Identify drafts clearly; **only approved versions may be marked FINAL or APPROVED**
- Replace superseded operational copies in shared locations **while preserving required audit
  history**
- *"**Never overwrite an approved lift plan, contract, permit, or commercial approval** without
  preserving the prior version."*
- *"**Email attachments must match the version stored in the system of record.**"*

**This convention differs from both the other naming standards in the drop** — the Creating Quotes
SOP uses `QuoteNumber_Company.pdf`, and the Value Engine index proposes
`TCG_[Department]_[Process]_[Type]_v[X.Y]_[Date].docx`. Three naming standards, one document set.

## 12. Duplicate and overlapping procedure register

A second, differently-framed conflict register from the one in
[04-value-engine-and-playbook-index.md](04-value-engine-and-playbook-index.md) §5. Its distinct
entries:

| Overlap | Risk | Controlling rule |
| --- | --- | --- |
| **Permit Waiver vs. Scheduling rules** | *"Employees may think a **waiver guarantees scheduling**"* | *"Waiver documents customer risk; **Dispatch still must accept** and legal/safety restrictions still apply."* Recommended action: **"Add explicit no-guarantee language."** |
| **Day Prior Email vs. Schedule Change** | *"**Changes may be buried in confirmation email.**"* | *"Any material change activates the Schedule Change process."* Attach or link the change record |
| **Labor Compliance Form vs. Certified Payroll / Davis-Bacon** | *"**Initial identification may be mistaken for completion.**"* | *"The form identifies requirements; specialist playbooks govern execution."* Recommended: **staged statuses — `identified`, `reviewed`, `cleared`, `reporting complete`** |

That last row proposes a **four-state compliance status enum**, which is the most directly
implementable suggestion in the document.

## 13. Manager audit checklist

Ten checks, of which these are the ones a system could enforce:

☐ Current approved versions available; obsolete forms removed from active use
☐ New customer records **match FCC/accounting** and include required approvals
☐ **Every public-works or unknown-funding quote includes the labor compliance form** and required packet
☐ **No job released to Dispatch without a complete scheduling sheet and Dispatch acceptance**
☐ Permit waivers are signed, specific, approved and **do not override legal or safety restrictions**
☐ Lift-plan requests include verified technical information and current attachments
☐ Day-prior confirmations documented and material changes activated change control
☐ Discounts and invoice adjustments contain **facts, math, approval, and system updates**
☐ Controlled emails stored with the related job or customer record
☐ ***"Completed records are retrievable without relying on one employee's inbox."***

## Source

`3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Forms_Templates_and_Required_Records_Matrix.docx`
— 24 KB docx → pandoc gfm. Version 1.0. All 15 sections transcribed or tabulated above; §15 is an
**unsigned approval block** for Sales Manager, Dispatch Manager, Accounting, Labor Compliance and
Executive Management.

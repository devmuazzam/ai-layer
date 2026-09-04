---
title: Operating System Architecture — the master blueprint
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Operating_System_Architecture_Print_Safe.docx
migrated: 2026-09-04
updated: 2026-08-06
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/dispatch, module/accounting, module/payroll, kind/reference, requirements, compliance, permits, pricing, reporting, open-questions]
entities: []
---

# Operating System Architecture — the master blueprint

**What this is.** *"Master Blueprint for Sales Operations, Sales Coordination, Engineering,
Compliance, Dispatch, and Finance."* Document Type: Operating Architecture · Process Owner: Sales
Manager / Executive Leadership · Version 1.0. It is the highest-level document in the set and
says so: *"This architecture is the control document for building the final Sales Coordinator
Process Map and departmental operating manuals. **Detailed playbooks remain the source of truth
for execution.**"*

---

## 1. The design standard

> **OPERATING PRINCIPLE** — *"The **Process Map** explains what happens next. Each **Value
> Engine playbook** explains exactly how the work is completed. **Forms, templates, and
> checklists** provide evidence that the step is complete."*

Five rules:

- **One source of truth** — the governing playbook controls the detailed procedure.
- **Clear ownership** — every Value Engine has one primary owner and named supporting functions.
- **Defined gates** — work cannot advance until the exit requirement is met.
- **Visible exceptions** — schedule changes, permit waivers, pending lift plans, commercial
  concessions and compliance issues follow controlled exception paths.
- **Billing protection** — permits, lift plans, third-party costs, rush work, revisions and
  concessions must be visible, approved and captured.

## 2. Seven operating manuals

| Volume | Manual | Scope |
| --- | --- | --- |
| 1 | Sales Coordinator Operating Manual | Lead intake → dispatch handoff and customer confirmation |
| 2 | Sales Operations & Commercial Governance | Pricing decisions, quote changes, expenses, CRM discipline, sales management controls |
| 3 | Engineering & Permit Operations | Lift planning, lift-plan submissions, FAA permits, A1 surveys, NOTAMs |
| 4 | Compliance & Risk Management | Contracts, COIs, labor compliance, public works, Davis-Bacon, certified payroll, PLA, OCCIP/CCIP |
| 5 | Dispatch & Scheduling Operations | Ready-to-schedule gate, scheduling sheet, dispatch acceptance, schedule changes, pre-job alignment |
| 6 | Finance & Customer Administration | New customer setup, credit/deposits, preliminary notices, invoice adjustments, billing support, closeout |
| 7 | People & Administrative Controls | Time off, administrative forms, training, role accountability |

**Only Volume 1 exists** —
[03-sales-coordinator-operations-manual.md](03-sales-coordinator-operations-manual.md). The other
six are named here and nowhere else.

## 3. The 12-step process backbone

1 Lead / Customer Intake → 2 Qualification & Scope Control → 3 Quote Development → 4 Commercial
Approval → 5 Customer Approval & Financial Clearance → 6 Risk, Compliance & Technical Readiness →
7 Ready to Schedule Gate → 8 Scheduling Sheet & Dispatch Acceptance → 9 Pre-Job Confirmation →
10 Exception Management → 11 Job Execution Support → 12 Billing & Closeout.

**This is 12 steps; the Master Process Map is 13 stages; the HubSpot playbook is 12 CRM stages
with different names.** The three do not correspond one-to-one — see
[02-master-process-map.md](02-master-process-map.md) §2 and
[../hubspot-sales-playbook.md](../hubspot-sales-playbook.md) §2.

## 4. The Master Gate Matrix — 10 gates

The most reusable thing in the document: each gate has one exit requirement and one owner.

| Gate | Exit requirement | Owner |
| --- | --- | --- |
| **1 — Qualified Opportunity** | Customer, jobsite, requested date, scope, weight, radius/reach, height, access, contact and next action are documented | Sales Coordinator |
| **2 — Quote Ready** | FCC quote complete, supporting information attached, pricing reviewed, **salesperson/supervisor approval documented** | Sales Coordinator / Salesperson |
| **3 — Commercially Approved** | Any discount, free lift plan, competitor match, quote change or concession has **documented facts, math, give-get, and approval** | Sales Manager |
| **4 — Financially Cleared** | New customer setup, signed quote, deposit/COD or terms, PO and billing information complete as applicable | Sales Coordinator / AR |
| **5 — Risk & Compliance Cleared** | Contract, COI, labor compliance, public works, PLA, OCCIP/CCIP, certified payroll and permit requirements complete **or formally controlled** | Sales Manager / Compliance |
| **6 — Technically Ready** | Crane scope, lift plan, engineering, NOTAM/FAA, vendor coordination and site information complete | Engineering / Sales Coordinator |
| **7 — Ready to Schedule** | Complete job packet assembled; no unresolved blocker unless an approved exception playbook applies | Sales Coordinator |
| **8 — Dispatch Accepted** | Dispatch has reviewed and accepted the Scheduling Sheet and job packet | **Dispatch** |
| **9 — Customer Confirmed** | Day-prior email scheduled for 8:00 a.m.; Dispatch CC'd; changes routed through Schedule Change | Sales Coordinator |
| **10 — Billing Protected** | Revisions, permits, lift plans, third-party charges, cancellations, schedule changes and approved concessions documented for billing | Sales Coordinator / Accounting |

**Gate 2 makes supervisor approval a hard gate on every quote**, matching the Creating Quotes SOP
([../tcg-creating-quotes-sop.md](../tcg-creating-quotes-sop.md) §7). **Gate 3 is separate and
conditional** — it fires only when a concession is requested. So the architecture has *two*
approval gates where the vault's punch lists and the 2026-05-05 meeting discuss only one.

## 5. The Value Engine registry

Twenty domains, each with governing playbook, trigger, required output and owner. Reproduced
because it is the most complete inventory of TCG's sales-side processes anywhere in the drop.

| Domain | Governing playbook | Trigger | Required output | Owner |
| --- | --- | --- | --- | --- |
| Customer Intake | New Customer Playbook | New customer or new legal entity | Customer packet complete; AR/payment path confirmed | Sales Coordinator / AR |
| Customer Intake | Creating Quotes SOP / FCC Quote Playbook | Qualified quote request | **Approved FCC quote and PDF** | Sales Coordinator |
| Engineering | 3D Lift Plan Playbook | Lift plan required or job complexity triggers planning | Internally reviewed plan | Sales / Engineering |
| Engineering | Lift Plan Submission Playbook | Plan requested from designer | **Request logged, FCC marked, plan delivered** | Sales Coordinator |
| Permitting | NOTAM Playbook | Crane within airport proximity / aviation concern | NOTAM number documented | Sales Coordinator / Operations |
| Permitting | FAA Permit A1 Survey Playbook | FAA requires survey, mitigation or additional review | Final FAA approval and project release | Permit Coordinator / Sales |
| Risk | Contracts & COI SOP | Contract, PO terms, insurance requirement or COI request received | Sales Manager confirms completion | Sales Manager |
| Compliance | Labor Compliance Form Distribution | **Every quote**; completed form required when applicable | Form reviewed, **FCC updated**, routed internally | Sales / Labor Compliance |
| Compliance | Davis-Bacon / Federally Funded Jobs | Federal funding or Davis-Bacon applies | Requirements identified and routed | Sales Coordinator / Compliance |
| Compliance | Certified Payroll | Certified payroll requirement identified | Payroll/compliance readiness confirmed | Labor Compliance / Payroll |
| Scheduling | Ready to Schedule | Customer approval received and scheduling requested | Complete job packet / Go decision | Sales Coordinator |
| Scheduling | Scheduling Sheet | Job ready for dispatch handoff | Dispatch-ready scheduling record | Sales Coordinator |
| Scheduling | Permit Waiver | Permit cannot be obtained in standard timeframe **or customer elects risk path** | Signed waiver and management/dispatch visibility | Sales / Management |
| Scheduling | Post-Scheduling Lift Plan Pending | Job scheduled before lift plan completion under controlled exception | **Plan completed before execution or job stopped** | Sales Coordinator / Engineering |
| Scheduling | Schedule Change | Customer or internal party changes date, time, location, scope or resource | Updated schedule, approved charges, dispatch confirmation | Sales Coordinator / Dispatch |
| Scheduling | Day-Prior Automatic Email | Job accepted and scheduled | 8:00 a.m. email scheduled; Dispatch CC'd | Sales Coordinator |
| Commercial | Commercial Decision Playbook | Discount, quote change, competitor claim, free lift plan or concession requested | Approved/denied decision documented | Sales Manager |
| Administration | Sales Expense Report SOP | Sales expense report submitted | Approved report routed to Accounting | Sales Manager |
| Finance | Invoice Adjustment Request | Invoice correction, discount, credit or adjustment requested | Documented approval and accounting action | Management / Accounting |
| People | Absence Request Form | Employee requests time away | Manager approval/rejection documented | Employee / Manager |

**"Labor Compliance Form Distribution — trigger: every quote"** is a stated unconditional rule: a
labour-compliance form goes out with *every* quote, and its output includes **updating FCC**. The
vault holds nothing else on this.

## 6. Cross-functional ownership

The document asks for swimlanes and names nine roles. The framing sentence is the useful part:
*"The Sales Coordinator acts as **the control tower but does not replace** technical, compliance,
management, dispatch, or accounting authority."*

| Role | System responsibility |
| --- | --- |
| Customer | Accurate scope, documentation, approvals, schedule confirmation |
| **Sales Coordinator** | Information flow, forms, tracking, quote administration, readiness checks, handoffs, follow-up, documentation |
| Salesperson | Customer relationship, technical/commercial escalation, customer approvals, opportunity strategy |
| Sales Manager | Contracts/COI routing, commercial decisions, exceptions, escalations, process governance |
| Engineering / Lift Planning | Lift plan design, technical review, revisions, engineering deliverables |
| Labor Compliance / Payroll | Prevailing wage, certified payroll, apprenticeship, PLA, agency, payroll reporting |
| **Dispatch** | **Resource acceptance**, crane/crew scheduling, operational confirmation, final dispatch planning |
| Accounting / AR | Customer setup, payment terms, deposits, invoice processing, credits, financial records |
| Third-Party Vendors | Permits, traffic control, surveys, trucking, police detail, other contracted services |

## 7. Controlled exception paths

Nine, each with its route:

- **Schedule changes** → Schedule Change Playbook; reassess permit, lift plan, labor, vendor,
  crane/crew and billing impacts **before Dispatch updates the schedule**.
- **Lift plan pending after scheduling** → Post-Scheduling exception; *"FCC/job record must show
  pending status; ownership and deadline must be clear."*
- **Permit unavailable or waived** → Permit Waiver Playbook; *"**waiver does not erase operational
  risk**."*
- **FAA additional review / A1 survey** → notify immediately; *"obtain survey pricing and
  **written customer authorization before ordering**."*
- **Commercial concession** → Commercial Decision Playbook; *"**No undocumented discount, free
  lift plan, hidden quote adjustment, or competitor match.**"*
- **Contract or COI issue** → complete request to Sales Manager; coordinator/salesperson **may
  not** independently approve or alter legal or insurance documents.
- **Labor compliance uncertainty** → *"**Treat as a blocker.** Customer must clarify; Labor
  Compliance reviews before work is scheduled."*
- **Third-party cancellation or rescheduling** → vendor cost impact, notify customer, secure
  approval, **capture the charge**.
- **Same-day / emergency job** → escalate immediately to Dispatch and management; complete as
  many gates as possible and **document every approved exception**.

## 8. The billing-protection layer

> *"Billing protection is **not a final accounting step**. It is embedded throughout the
> workflow."*

Costs that must be visible in the quote, change approval, job record or invoice adjustment:

- Permit application, revision, extension, reissuance or waiver-related costs
- Lift plan packages, revisions, engineering, **P.E. stamps**, ground-bearing work and rush fees
- A1 surveys and FAA-related third-party costs
- Traffic control, police detail, pilot cars, trucking, matting, barricades and other vendors
- **Mobilization, demobilization, travel, standby, overtime, double time, holiday premiums and
  cancellation charges**
- Schedule-change costs and vendor rescheduling/cancellation fees
- Commercial discounts, credits, free work and customer concessions
- Labor compliance, certified payroll or project-specific administrative burdens when billable

> **NO COST IMPACT SHOULD DISAPPEAR BETWEEN THE CUSTOMER REQUEST, QUOTE, SCHEDULING HANDOFF, JOB
> EXECUTION, AND FINAL INVOICE.**

Every item on that list has a published rate on the quote —
[../quote-terms-and-rate-card.md](../quote-terms-and-rate-card.md) §3 — so this is a list of
things TCG *can* bill and believes it currently loses.

## 9. Systems of record

| System | Required record |
| --- | --- |
| **HubSpot / CRM** | Opportunity status, owner, next action, follow-up, customer communications, quote status, **lost reason** |
| **FCC / NexgenFMS** | Customer/jobsite, quote, job number, equipment, lift information, comments, **lift-plan indicators, compliance parameters**, operational job record |
| **Outlook** | Customer correspondence, approvals, contract/COI routing, lift-plan requests, **scheduled day-prior emails**, documented change approvals |
| **Company File Storage** | Quotes, signed approvals, job walk information, lift plans, permits, surveys, contracts, COIs, vendor documents, compliance records |
| **Accounting / QuickBooks** | Customer billing contact, invoices, deposits, credits, payments, final financial records |
| **FAA / External Portals** | FAA case records, determinations, surveys, NOTAMs, public agency or customer compliance submissions |

**Six systems of record, and the ERP would be replacing at least two of them.** The document
lists *lift-plan indicators* and *compliance parameters* as FCC fields — neither appears in the
FCC quote manuals, so they are presumably local configuration.

## 10. Operating metrics

Seven families, listed here because they are the measures TCG says it wants:

| Family | Measures |
| --- | --- |
| **Flow** | First response time · quote turnaround · approval cycle time · ready-to-schedule cycle time · **dispatch rejection rate** |
| **Quality** | CRM completeness · quote error rate · missing-document rate · job packet completeness · repeat correction rate |
| **Commercial** | Discount requests · approved concessions · **dollar value given away** · margin before/after concessions · free lift plans requested |
| **Compliance** | Labor compliance completion · certified payroll readiness · COI/contract turnaround · permit and FAA approval status |
| **Scheduling** | Schedule changes · late changes · customer confirmation completion · vendor confirmation · dispatch acceptance |
| **Financial** | Deposit collection · PO collection · invoice adjustments · **unbilled third-party costs** · unbilled lift-plan/permit revisions |
| **Training** | Playbook usage · audit findings · incomplete requests returned · recurring coaching themes |

## 11. Implementation sequence

Eight steps, of which three matter to anyone building the ERP:

- **Step 3 — Standardize playbook format**: *"Use one structure: **Purpose, Trigger, Inputs,
  Roles, Workflow, Gate, Forms, Emails, System Updates, Billing, Errors, Audit, Success
  Standard.**"*
- **Step 6 — Resolve duplicates and conflicts**: *"Select one governing procedure where older SOPs
  overlap or contain outdated rules."*
- **Step 7 — Create document control index**: owner, version, effective date, review date, status.

## 12. The eight governance decisions still open

Transcribed in full, because they are TCG's own list of what it has not decided:

1. Confirm the official system name — *"The Crane Guys Operating System"* or another
   leadership-approved title.
2. Confirm whether **the Sales Coordinator or the Salesperson owns each customer-facing
   communication** at every stage.
3. Confirm the final internal routing and owners for Labor Compliance, Project Coordinator,
   Payroll, Dispatch and Accounting.
4. **Confirm the governing software terms where documents refer to FCC, NexgenFMS, iCraneTrax, or
   other systems.**
5. Confirm the final payment policy **where the New Customer Playbook and New Customer Packet
   contain different default deposit/COD rules.**
6. **Confirm current company address, fleet ranges, EMR, contacts, rates, and vendor information
   before republishing customer-facing material.**
7. Confirm **approval thresholds** for discounts, free lift plans, invoice adjustments and
   strategic concessions.
8. Confirm document retention location and naming convention for each Value Engine.

**Four of these are live problems the vault can see independently.** #4 names **iCraneTrax**,
which appears nowhere else in the vault. #5 is real — see
[../new-customer-onboarding.md](../new-customer-onboarding.md) §2. #6 is real — the drop carries
**two TCG addresses** (10850 Portal Dr., Los Alamitos and 14480 Alondra Blvd, La Mirada). #7 is
the same gap the 2026-05-05 meeting hit when it discussed a $50,000 flag without settling it
([../../erp-review-log.md](../../erp-review-log.md) → *Quote approval*).

## Source

`3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Operating_System_Architecture_Print_Safe.docx`
— 18 KB docx → pandoc gfm. Version 1.0. All 13 sections transcribed or tabulated above; nothing
material omitted.

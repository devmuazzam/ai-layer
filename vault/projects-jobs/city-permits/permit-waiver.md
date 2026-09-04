---
title: Permit waiver — the exception that lets a short-notice job be scheduled
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Playbook_-_Permit_Waiver.docx and 1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/TCG Permit Waiver.pdf
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/dispatch, module/customers, kind/sop, permits, compliance, scheduling, signatures]
entities: []
---

# Permit waiver — the exception that lets a short-notice job be scheduled

**What this is.** Two documents: the **Permit Waiver playbook**, a Value Engine describing when a
waiver is required and who has to sign what before the job can move; and the **signed customer
form** itself, "PERMIT FEE & ACKNOWLEDGEMENT WAIVER", a one-page PDF on The Crane Guys letterhead.
The waiver is the mechanism that makes the Red Path in
[../scheduling/dispatch-scheduling-path.md](../scheduling/dispatch-scheduling-path.md) possible.

## When a waiver is required

The playbook lists four triggers:

- The customer requests **expedited scheduling**.
- **Permit lead times cannot be met.**
- Required permits **cannot be guaranteed before mobilization**.
- **Dispatch determines a waiver is necessary.**

The Value Engine begins when a customer asks to schedule inside the required permit lead time, when
permits cannot be obtained on the normal timeline, or when the job **falls into the Red Path of the
Scheduling Value Engine**.

**Standard rule, verbatim:** "Permit Waivers are an exception process and should only be used when
normal permit timelines cannot be met. **They do not replace the standard permit process.**"

## Who does what

| Role | Responsibilities |
| --- | --- |
| **Sales Coordinator** | Identify that a waiver is needed · send the **approved** Permit Waiver form · obtain the signed waiver · attach it to the job file · notify Dispatch |
| **Customer** | Review and sign · **understand that permit approval cannot be guaranteed** |
| **Dispatch** | Review the waiver · approve or deny scheduling · proceed only after approval |

## The workflow

1. Customer requests expedited scheduling.
2. Sales Coordinator determines a Permit Waiver is required.
3. Send the company Permit Waiver form.
4. Customer signs and returns it.
5. **Attach the signed waiver to the job record.**
6. Dispatch reviews the request.
7. Dispatch approves or denies scheduling.
8. If approved, proceed to scheduling; **if denied, coordinate a new date.**

## What must be on file before the job goes

The playbook's required-documentation checklist — eight items, all of which must be present:

`Signed Permit Waiver` · `Job Number` · `Customer Name` · `Requested Crane` · `Requested Job Date` ·
`Permit Status` · `Sales Coordinator Notes` · `Dispatch Approval`

**GO:** signed waiver received, Dispatch approves, and all other scheduling requirements are
complete. **NO-GO:** the waiver is unsigned, missing from the job file, Dispatch denies approval, or
required scheduling information is incomplete.

Note the two-lock rule this creates, stated more bluntly in the Dispatch Scheduling Path playbook:
**a permit waiver does not by itself authorise the job. The waiver and direct Dispatch approval are
both required.**

## Common mistakes the playbook calls out

- Scheduling **before** receiving the signed waiver.
- Forgetting to attach the waiver to the job.
- Failing to notify Dispatch.
- Using a waiver when normal permit timelines **were** available.
- Treating the waiver as a substitute for proper planning.

Manager audit asks: was a waiver actually required · was the approved company form used · was it
signed **before** scheduling · was it attached to the job · did Dispatch approve before scheduling ·
were communications documented.

## What the customer actually signs

`TCG Permit Waiver.pdf` — one page, The Crane Guys, LLC letterhead (14480 Alondra Blvd, La Mirada,
CA 90638; CA Lic #967520). Headed **PERMIT FEE & ACKNOWLEDGEMENT WAIVER**. Its four operative
paragraphs:

1. **Scope.** The work requires some or all of: street closure, lane closure, traffic control
   measures, travel permit **and/or FAA permit**.
2. **Fees and citations.** The customer accepts **full responsibility for any and all fees and
   citations, including impound fees and the equipment hourly rate during impound**, levied by
   local, county or state agencies as a direct result of the work.
3. **Indemnity.** The customer indemnifies and holds the contractor harmless for **any and all
   damage to streets, curbs, sidewalks or underground utilities** that an agency may assert was
   caused during the work.
4. **Work stoppage.** If an agency stops the contractor from completing work **due to the absence
   of required permits and proper traffic control**, the customer agrees to pay the total due for
   all services rendered — including travel, setup and teardown of equipment, work completed, and
   **any additional overtime charges for labor and equipment**.

Signature block fields: `Company Name` · `Job Site Address` · `Printed Name and Title of responsible
party` · `Customer Signature/Title` · `Date`. The form states that the signature above notes
acceptance of the terms.

**The form is generic** — it does not carry a job number, crane, permit type or date of intended
work, even though the playbook's checklist requires all of those to be on file. Nothing in either
document says how a signed waiver is tied to the specific job it covers, or whether a waiver
expires. The letterhead address (La Mirada) also differs from the address on the lift-plan
submission procedure and the lift-plan packages (10850 Portal Dr, Los Alamitos), which suggests the
waiver PDF is the older artefact.

## Source

- `3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Playbook_-_Permit_Waiver.docx`
  — ~3.3 KB, `.docx` → pandoc GFM. Untitled version; references "The Crane Guys Permit Waiver Form
  (Current Approved Version)".
- `1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/TCG Permit Waiver.pdf`
  — 1 page, `pdftotext -layout`. Full operative text is summarised above; the form is short enough
  that nothing material was omitted.

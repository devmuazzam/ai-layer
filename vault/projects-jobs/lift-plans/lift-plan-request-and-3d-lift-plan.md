---
title: Requesting a lift plan, and building a 3D Lift Plan
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/TCG - Lift Plan Submission Procedure[34].pdf and 3D Lift Plan Playbook Sheet.docx
migrated: 2026-09-04
updated: 2026-05-11
status: unverified
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/quotations, kind/sop, lift-plans, safety, pricing, requirements]
entities: []
---

# Requesting a lift plan, and building a 3D Lift Plan

**What this is.** Two documents covering opposite ends of the same artefact. The **Lift Plan
Submission Procedure** is the one-page rule sheet a Sales Coordinator follows to *order* a lift plan
from the designer. The **3D Lift Plan Playbook Sheet** (created by **Ryan Adams, 11 May 2026**,
team Sales) is a five-step summary of how the designer *builds* one.

Together they answer: what a lift-plan request must contain, what the deliverable options are, and
what the standard turnaround is. What is produced at the end is described in
[lift-plan-package-anatomy.md](lift-plan-package-anatomy.md).

## Requesting a lift plan

**How.** A **written request by email** to the designated Lift Plan Designer. The request **must
reference the job quote or job number** in the email, and the subject line must clearly include
**"Lift Plan Request"**.

**What the request must include.**

- The associated **NexgenFMS/FCC** job/quote number.
- Any relevant attachments — site layout, drawings, screenshots.
- A clear subject line containing "Lift Plan Request".
- **Which deliverable is wanted** (see the four tiers below).

### The four deliverable tiers, plus one add-on

| Option | What it includes |
| --- | --- |
| **Ground Bearing Pressures** | Includes a generic load case |
| **Standard Lift Plan Package** | Load case, **load chart, certs and set-up layout** |
| **Premium Lift Plan Package** | A **branded submittal package with site-specific documents** |
| **Lift Plan Revision(s) and/or additions** | — |
| **P.E. Stamp** | **Per plan, in addition to the Premium Lift Plan Package** |

This is the only place in the drop where lift-plan deliverables are enumerated as priced tiers. The
Ready to Schedule playbook separately requires that a lift plan attached to a job be a
**billable line item** ([../scheduling/ready-to-schedule.md](../scheduling/ready-to-schedule.md)),
and the Schedule Change playbook requires that **lift plan revisions be reviewed for billable
engineering time** — so the tier chosen has a commercial consequence at both ends. The rate sheet
itself is not in this drop.

### Minimum required information

Twelve items:

`Weight of the load` · `Load dimensions (L × W × H)` · `Pick points (if known)` ·
`Radius — centre of crane rotation to load centre` · `Lifting height` ·
`Setback (from middle of set-up)` · `Load distance into building (if applicable)` ·
`Ground bearing pressure report / outrigger loads (if required or applicable)` ·
`Rigging configurations` · `Load cut / specification sheets` ·
`Crane configuration (if known / specific)` ·
`Attachments — job layout, site plan, customer drawings and any associated jobsite documents`

**For a new job site:** note **"New Jobsite"** in the request and include any available site plans
if Google Maps imagery is not current — **a plan-view drawing is preferred in this scenario**.

### Rush and after-hours requests

- **Call the Lift Plan Designer immediately, before sending the email request.**
- For after-hours requests, **inform the customer of rush fees that may apply** (per the current
  rate sheet).

### Recording it on the job

In the job/job screen in **NexgenFMS/FCC**, mark **"Lift Plan"** in the comments, **or enter "LP"
in the equipment required field**.

### Turnaround

**Standard turnaround is 24 hours from the time of request.** If a delay occurs, **communicate the
reason to the customer promptly.**

That 24-hour standard is the number the post-scheduling exception playbook is written against — see
[post-scheduling-lift-plan-completion.md](post-scheduling-lift-plan-completion.md).

## Building a 3D Lift Plan — five steps

From the 3D Lift Plan Playbook Sheet. Its header block records: created by **Ryan Adams**,
11 May 2026, last update 11 May 2026, associated Value Engine **Leads**, team **Sales**. The
"Playbook Owner(s)" field is **blank** and the "Resources" section is an **unfilled template
placeholder** ("Resource/Tool" twice).

**Step 1 — Project intake and site verification.** Gather customer information, site address, load
dimensions, **verified weights**, pick/set locations, schedule needs, access limits, drawings,
photos and site measurements. **Confirm all load weights before moving forward.**

**Step 2 — Plan the lift strategy.** Select the crane on **actual job conditions** — setup space,
radius, boom length, ground conditions, counterweight, access and site restrictions. **Keep the lift
plan as simple and safe as possible.**

**Step 3 — Build the plan in 3D Lift Plan.** Create the project, import site drawings or images,
**verify scale**, build the site environment, configure the crane, position the crane, and model the
load and rigging accurately.

**Step 4 — Simulate, review and approve.** Run the **full lift sequence**; check clearances, swing
path, boom interference, capacity, outrigger reactions and ground bearing. **Review internally with
operations, safety, project management and the crane operator before customer approval.**

**Step 5 — Final package, execution and post-job review.** Prepare the final package with drawings,
crane charts, rigging details, ground-bearing calculations, logistics and safety notes. On lift day,
**verify field conditions, hold a pre-lift meeting, stop if conditions change**, and document
lessons learned after the job.

The sheet points at a fuller `3D Lift Plan Playbook.docx` on TCG's SharePoint (TCGSalesTeam →
Sales - General); **that document is not in this drop**. Its "Walkthrough Video" link is a Google
search results URL, not a curated video.

## How this compares with what the vault already holds

`projects-jobs/project-module/04-create-and-approve-lift-plans.md` (Confluence, 2026-04-30)
specifies the **in-product** Plans tab: create-plan modal, plan types, auto-filled project/customer/
job-site/creator, crane details (category, capacity, beam length, radius), load information,
site conditions, safety sections, drag-and-drop attachments, and an approval workflow where a
salesperson-created plan auto-approves and anyone else's routes to the salesperson.

**These two documents describe the real-world process the product page does not cover:**

- The plan is **ordered from a named designer by email**, not authored in-app.
- There are **four priced deliverable tiers plus a P.E. stamp**, which the product page's single
  "Lift Plan type" does not model.
- The stated standard turnaround is **24 hours**, which the product page does not mention.
- Internal review is by **operations, safety, project management and the crane operator** — four
  roles, where the product page's approval step names only the salesperson.

**Neither source says the product should adopt the tiers, the turnaround, or the four-role review.**
They are recorded here as what the business currently does.

## Source

- `3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/TCG - Lift Plan Submission Procedure[34].pdf`
  — 1 page, ~2.8 KB, `pdftotext -layout`. Letterhead: The Crane Guys, LLC, 10850 Portal Dr,
  Los Alamitos, CA 90720, CA Lic #967520. No version or date on the document.
- `3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/3D Lift Plan Playbook Sheet.docx`
  — ~2.5 KB, `.docx` → pandoc GFM.

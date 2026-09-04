---
title: TCG IT's own value engines — App Development and Change Management
source: shared-folder/Project-Repository-2026-09-04/TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG IT - VALUE ENGINES and PLAYBOOKS/ (2 .vsdx + 9 .docx playbooks)
migrated: 2026-09-04
updated: 2026-05-11
status: unverified
conflicts_with: []
jira: []
tags: [module/admin, kind/sop, architecture, integrations, permissions-roles, compliance, requirements]
entities: []
---

# TCG IT's own value engines — App Development and Change Management

**What this is.** Two value engines authored by **Brian Petros** (TCG IT, ERP project
coordinator) — *TCG IT Custom App Development* and *TCG IT Change Management* — as Visio diagrams
dated **2026-04-29**, plus the **nine playbooks** that document their steps, all dated
**2026-05-11**. Together they are the client's own written statement of how software work is
supposed to flow through TCG.

**Why it matters.** The vault's six `domain/` SOPs describe the **vendor's** process — CodingCops'
sprints, Jira, grooming, reviews. This is the **client's** process, and the two meet: playbook #2
routes work to "the ERP backlog (CodingCops)", playbook #5 assumes a shared Jira, and playbook #6
requires a Change Ticket before any production deployment. Anyone asking "how is a request
supposed to reach us, and what has to happen before we ship to production?" has two answers, and
this is the one nobody had written down here.

> **Status.** These are TCG IT's *intended* processes as of May 2026, written by one person and
> not marked as approved by anyone. Several steps reference artefacts that did not yet exist —
> playbook #1 says the intake form is "*not yet created*", and every playbook's Resources section
> is an unfilled placeholder ("Resource/Tool"). Read them as a design for a process, not a record
> of one running. **Nothing here has been agreed with CodingCops in any document in this drop.**

---

## Value engine 1 — TCG IT Custom App Development

The flowchart's spine, read from the Visio page text:

```
App / Automation Needed
  → Submit App Request → Triage Request → [Enough Info?] ──No──→ Clarify Request ──┐
                                              │Yes                                  │
                                              ▼                                     │
                              [Build, buy or hybrid?] ──→ Vendor / ERP  ←───────────┘
                                              │
                                              ▼
                              Discovery & Requirements
                                              │
                              [Scope / Priority Approved?] ──No──→ Backlog / Parked
                                              │Yes
                                              ▼
                                    Solution Design
                                              │
                    Architecture / Integration / Security Review
                                              │
                                      [Approved?] ──No──→ Revise Design
                                              │Yes
                                              ▼
                        Project Setup & Backlog → Develop / Configure
                                              │
                            QA & Integration Testing → [Passed?] ──No──→ Fix / Retest
                                              │Yes
                                              ▼
                    Release Planning & Change Ticket → Deploy to Production
                                              │
                                      [Issues?] ──Yes──→ Rollback / Hotfix
                                              │No
                                              ▼
        Support handoff & documentation → Training documents & User Training → App Live & Owned
```

The diagram also carries a standing note listing the **key systems** every request is checked
against: **Entra ID (Microsoft) · SQL Server · FCC NexGen · Samsara · QuickBooks Online**, and the
request-details note: **sponsor · users · system/data · desired outcome · urgency**.

### Playbook #1 — Custom App Request Intake and Triage

*Use when a department requests a new internal app, automation, integration, report, or
enhancement.* Purpose: capture every request in one backlog and triage it quickly with clear scope,
ownership and next steps.

Inputs required: problem statement and desired outcome (success criteria) · business sponsor and
primary requester · users (office/field) and access approach (**Entra ID or alternative**) ·
systems/data touched **and sensitivity (PII, payroll, customer data)** · timeline/urgency and hard
deadlines.

Steps: submit via the standard intake form/ticket (**"not yet created"**) → IT reviews for
completeness, categorises it (**App / Report / Integration / Automation / Enhancement**) and sets
an initial priority → confirm users, access method and impacted systems (NexGen, SQL Server,
Samsara, QBO, M365) → mark incomplete requests **Needs Info** and pause until updated → when
complete, move to **Ready for Build-vs-Buy**.

**Decision rules.** "Enough info to proceed" = sponsor + desired outcome + user group +
systems/data touched + urgency/timeline are all known. **A production outage or security issue is
not an app request** — route it to incident response or IT Change Management instead.

**Tools.** Jira service portal form + backlog, "**preferred so CodingCops and IT can share one
system of record**"; Teams/Email + Confluence/SharePoint for coordination.

### Playbook #2 — Build vs Buy vs Hybrid Decision and Vendor Engagement

*Use after triage, before deep discovery.* Steps: check whether it can be solved inside existing
tools first (**configure or report before building**) → **confirm whether it belongs in the new ERP
scope (CodingCops); if so, route to the ERP backlog and link the ticket** → evaluate Buy options
(fit, cost, SSO, **data ownership**, integrations) → evaluate Build vs Hybrid on complexity,
security, timeline and capacity → record the decision in Jira.

**Decision rules.** Route to the ERP when the feature is part of the ERP replacement scope · **Buy**
when a strong-fit SaaS exists and SSO/integration/security requirements can be met · **Build or
Hybrid** when the workflow is unique or needs tight integration, **Hybrid meaning CodingCops builds
the core and IT owns integrations and adjacent tools**.

> This is the only document in the vault that states the rule for what belongs in this platform's
> scope and what does not. It is TCG IT's rule, unilaterally written.

### Playbook #3 — Discovery and Requirements Definition

*For Build/Hybrid requests.* Steps: assign a **single Business Owner** accountable for decisions
and acceptance → time-boxed discovery sessions with the Business Owner and key users → document
the **as-is and to-be workflows** → capture requirements as **user stories plus acceptance
criteria** → confirm data needs and integrations (**source of truth, read vs write, frequency,
vendor limitations**) → capture non-functional requirements (**security, audit logging,
performance, mobile/web access, retention**) → produce a rough estimate and propose an **MVP
(Phase 1) vs Phase 2+** → get scope/priority approval, or park with a review date.

**Decision rules.** Approve when business value is clear, scope is reasonable and timing aligns
with IT/CodingCops capacity. **"If scope keeps changing, pause and re-baseline before moving
forward."** Definition of done: a **Requirements Brief** exists and the sponsor has approved
building or parking.

### Playbook #4 — Architecture, Integration and Security Review

*After requirements are approved, before project setup.* Steps: select the platform approach —
**Power Apps vs Node.js vs Python vs SQL/reporting** — on users, integrations and long-term
support → define environments and hosting (**Dev/Test/UAT/Prod**) and who owns each → design
integrations and data flow (source of truth, read/write rules, API/ETL) → define authN/authZ using
**Entra ID groups and roles, least privilege**, and confirm how field users will access the app →
define security controls (**secrets management, logging/audit trails, backups, data retention**) →
review with system and data owners, **and with HR/Payroll if payroll or PII is involved** → record
approval in the ticket.

**Decision rules.** Approve when least-privilege access is defined, data flows are documented and
logging/audit covers critical actions. And, stated as a hard rule:

> **"Do not allow direct write access to vendor-owned databases unless explicitly supported and
> approved (prefer APIs/integration methods)."**

Inputs include a **data sensitivity classification** — PII, payroll, customer data, operational
data.

### Playbook #5 — Development, QA and Backlog Management

Steps: set up the Jira epic/project and confirm milestones → confirm the **Git repository and
branching approach**, with **secrets stored outside the codebase** → build in small increments,
each tied to a Jira story with acceptance criteria → developer checks (**code review checklist,
linting, unit tests where practical**) → QA and integration testing against **NexGen/Samsara/SQL/
QBO**, validating **permissions and logging** → **UAT with the Business Owner and key users**,
defects into Jira → fix and retest → prepare release notes and hand off to playbook #6.

**Decision rules.** A story is done when it meets acceptance criteria, is tested, and introduces no
critical issues. **"If UAT feedback changes scope materially, pause and re-scope before
continuing."**

### Playbook #6 — Release, Deployment and Support Handoff

*After UAT approval, before **any** production deployment or configuration change.*

Step 1 is the hinge between the two value engines: **create a Change Ticket and follow the IT
Change Management Value Engine for approvals and scheduling.** Then: confirm deployment steps and
rollback plan **including database scripts and integration configuration** → schedule the release
window and notify impacted users → deploy (publish, apply config, run migrations) and capture what
was deployed → **validate with a smoke test of critical workflows and integrations**, monitoring
logs and alerts → roll back or hotfix on failure, logging follow-up in Jira → complete **support
handoff: runbook, admin notes, training, monitoring/alerts, and ownership (who supports what)** →
close with links to documentation and the maintenance plan.

**Decision rules.** Deployment is successful when critical workflows pass, integrations work and
there are **no Sev1 issues** after validation. A change affecting multiple systems or vendors is
treated as higher risk, with stakeholders notified and available.

---

## Value engine 2 — TCG IT Change Management

```
Change Needed → Submit Change Request → [Change Type?]
      ├─ Standard Change ─────────────────────────────┐
      ├─ Normal    → Review Normal Change → [Approved?] ──No──→ Rejected / Send Back
      └─ Emergency → Process Emergency Change          │Yes
                                                       ▼
                                Schedule & notify stakeholders
                                                       │
                                        Implement Change → Validate Results
                                                       │
                                        [Successful?] ──No──→ Rollback / Remediate
                                                       │Yes
                                                       ▼
                    Close Change Request → Change Request Completed & Documented
```

The diagram's standing notes: change request details are **impacted systems · risk/impact ·
testing plan · rollback plan**, and the tools are **Jira Service Management · a change calendar ·
approved notes**.

### Playbook #1 — Change Request Submission and Classification

*"Anytime a production app, database, integration, report, or system setting needs to change
(including vendor-led changes)."*

Inputs: what is changing and why · impacted systems and environment (Prod/Test/Dev) · desired
change window and constraints · risk/impact notes · **testing plan and success criteria** ·
**rollback plan**. Steps: submit in Jira → IT checks completeness → identify impacted systems and
stakeholders → **classify: Standard, Normal or Emergency** → record an initial risk rating
(Low/Medium/High) → route to approval, or straight to scheduling for Standard changes.

**Classification rules.** **Standard** = low-risk, repeatable, pre-approved — **still must be
logged**. **Normal** = planned, non-routine; requires review and approval before scheduling.
**Emergency** = urgent to restore service or avoid major disruption; **document and review after**.

### Playbook #2 — Change Review and Approval

*Applies to all Normal changes, all Emergency changes, and any Standard change not already on the
approved list.* Steps: review business impact (**ops, dispatch, payroll, billing, field users**) →
confirm the testing plan and who validates → confirm the rollback plan → identify required
approvers by risk and system criticality → approve, reject or request revisions → record the
decision and conditions in Jira.

**Approval matrix — the most reusable rule in either engine:**

| Risk | Approvers required |
| --- | --- |
| Low | IT Change Owner alone |
| Medium | IT **+ department/system owner** |
| High | IT + department/system owner **+ executive** |
| Emergency | Fastest available business approver; **post-change review required** |

Tools: Jira for approvals and status transitions; Teams for a **"CAB Lite" review meeting, weekly
or ad hoc**.

### Playbook #3 — Scheduling, Deployment, Validation and Closure

Steps: schedule and notify stakeholders **before** the window → implement during the approved
window, **recording start and end** → validate (**smoke test plus business validation**) → roll
back or remediate on failure, then re-validate → close the record with evidence, notes and links.
Inputs include **any required backups or snapshots**.

**Decision rules.** **"Do not implement without documented approval (except true emergencies)."**
Roll back and communicate if validation fails or user impact is high. **Close only after validation
and documentation are complete.**

---

## How this compares with the vendor SOPs already in the vault

The six `domain/` SOPs — [development-process-sop.md](development-process-sop.md),
[jira-sop.md](jira-sop.md), [sprint-planning-sop.md](sprint-planning-sop.md),
[backlog-grooming-sop.md](backlog-grooming-sop.md),
[daily-scrum-sop.md](daily-scrum-sop.md), [sprint-closing-sop.md](sprint-closing-sop.md) —
are CodingCops' internal delivery process, migrated from the Confluence TPD space. These nine
playbooks are TCG IT's. They **overlap without contradicting**, and the differences are worth
knowing:

- **Both use Jira, and TCG says so deliberately** — playbook #1 names a shared Jira as "preferred
  so CodingCops and IT can share one system of record". Neither side's SOP describes the other's
  workflow states.
- **The vendor SOP has no intake stage.** `development-process-sop.md` begins at Planning with a
  groomed backlog; TCG's playbooks #1–#3 are entirely about how something *becomes* a backlog item,
  including the build-vs-buy gate that decides whether it reaches CodingCops at all.
- **TCG adds a security/architecture gate the vendor SOP does not have.** Playbook #4 — Entra ID
  least privilege, data sensitivity classification, secrets management, HR/Payroll review for PII,
  and the no-direct-write-to-vendor-databases rule — has no counterpart in the vendor's SDLC.
- **TCG adds a change-management gate before production.** The vendor's release conditions are
  internal; TCG's playbook #6 step 1 requires a Change Ticket and the approval matrix above before
  anything is deployed. **No document in this drop says whether that gate applies to this
  platform's releases.** It is an open question worth putting to a human.
- **Definition of Done differs in kind.** The vendor SOP defines done per ticket; TCG defines it
  per playbook step, and playbook #6's is "live, validated, documented, and has an agreed support
  owner" — an ownership handover the vendor SOP does not describe.

## Source

All eleven files under
`TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG IT - VALUE ENGINES and PLAYBOOKS/`:

- `TCG IT - App Development - VALUE ENGINE 2026-04-29.vsdx` (1.2 KB of extracted page text) and
  `TCG IT - Change Mgmt - VALUE ENGINE 2026-04-29.vsdx` (725 bytes) — Visio, one page each. The
  shape *labels* extract; the **connections and layout do not**, so the flow diagrams above are
  reconstructed from label order and from the playbooks' own step sequences, and the branch routing
  should be checked against the original `.vsdx` before being relied on.
- Six `TCG IT - App Development 0[1-6] … 2026-05-11.docx` and three
  `TCG IT - Change Mgmt 0[1-3] … 2026-05-11.docx` — 2.2–2.8 KB each as converted text, pandoc GFM.
  All nine share the same template; every section with content is represented above. The
  **Walkthrough Video** and **Resources** sections are unfilled placeholders in all nine.

The form these documents take is described in
[value-engines-and-playbooks-method.md](value-engines-and-playbooks-method.md).

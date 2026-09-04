---
title: CodingCops engagement — NDA, contract and Sprint 1 Statement of Work
source: shared-folder/Project-Repository-2026-09-04/1.2.1_TECHNICAL-SPECS/CRANEGUYS_Executive Summary & SOW.docx (and .pdf; text and its one embedded image read) + 0.0.1_PROJECT-ADMIN/NDA_CodingCops_TCG_2026-01-15_unsigned-template.docx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/admin, kind/source, requirements, sprint-planning, architecture, permissions-roles, authentication]
entities: []
---

# CodingCops engagement — NDA, contract and Sprint 1 Statement of Work

**What this is.** The commercial paperwork behind the build: the unsigned NDA template
(effective 2026-01-15), the Statement of Work dated **6 March 2026** that adopts an Independent
Contractor Agreement dated **30 January 2026**, and the SOW's Exhibit A — the Sprint 1 scope
document with a feature-by-feature hour estimate. Prepared by CodingCops for The Crane Guys.

**Why it matters.** With the RFP ([tcg-erp-rfp-2026-02-26.md](tcg-erp-rfp-2026-02-26.md)) this is
the written scope of the engagement. Exhibit A is also the earliest written description of the
platform's architecture and of exactly what Sprint 1 was supposed to deliver — the vault held
nothing like it before this drop.

> The **Independent Contractor Agreement of 30 January 2026** that this SOW incorporates by
> reference is **not in the drop**. Its terms are unknown; the SOW says capitalised terms it does
> not define take their meaning from that agreement.

---

## The parties

| | |
| --- | --- |
| **Consultant** | CodingCops LLC, 1 E Erie St Suite 525-2841, Chicago, IL 60611 |
| **Client** | THE CRANE GUYS, LLC, 10850 Portal Dr., Los Alamitos, CA 90720 |
| **Signatories on the SOW** | Zaeem Asif (CTO & Co-Founder, CodingCops) · Wes Staley (Owner) and Melissa McNutt (President), TCG |

## The NDA (unsigned template, effective 2026-01-15)

A one-way NDA — TCG is *Owner*, CodingCops is *Recipient* — for the stated purpose of determining
whether CodingCops can assist TCG with software development. The template in the drop is
**unsigned**; both signature blocks are blank. Terms worth knowing because they constrain how this
material may be handled:

- **Confidential Information** is broadly defined: anything proprietary to TCG obtained through
  direct or indirect contact, "regardless of whether specifically identified as confidential",
  expressly including business records and plans, trade secrets, technical data, product ideas,
  contracts, financial information, **pricing structure and discounts**, computer programs, source
  and object code, IP, sales leads, partners, and **customer and client lists**.
- **Employee application.** Confidential Information may be disclosed only to those Recipient
  employees who need it for the limited purposes of the agreement, and each may be required to
  sign a substantially similar NDA.
- **Non-circumvention** for five years after the term: no doing business with contacts introduced
  by TCG in a way that circumvents TCG.
- **Return of materials** on written request, with a signed certification within five days.
- **Term:** obligations survive **ten years** from the effective date, or until TCG releases the
  Recipient in writing; protection of information received during the term continues indefinitely
  after that.
- Governed by **California** law; not assignable by either party. Includes a Defend Trade Secrets
  Act whistleblower-immunity clause.

Signatories named in the template: Wes Staley for TCG, Zaeem Asif for CodingCops.

## The SOW — commercial terms

- **Engagement model:** full-time **Dedicated Team**. Each developer is available for any
  development task for **160 hours a month** (8 h/day × 5 days).
- **Rate:** **USD $40 per hour** for all resources. Invoices generated **bi-monthly** against
  hours spent, **raised in advance**, **Net-10** payment terms.
- **Start date:** 9 March 2026. Term runs month-to-month after an initial two-month period unless
  terminated; renewal requires mutual written agreement.
- **Leave:** engineers take sick, casual and annual leave plus public holidays; invoices are
  reduced pro-rata for unavailability.
- **Scaling:** additional resources by mutual agreement, with up to a four-week lead time.
  Additional hours beyond the standard allocation are billed on actual usage with **no fixed upper
  cap**, subject to Client approval.
- **Resource replacement:** the Client may request replacement of a resource deemed unskilled or
  inappropriate, with a detailed explanation and examples of failed work.
- **On-site:** a separate hourly rate applies, plus reimbursement of actual and reasonable travel
  and living expenses.
- **Change requests:** any change to scope, features, integrations or performance expectations not
  in the Exhibit must be a written Change Request approved by both parties **before** execution,
  billed at $40/hour, and may adjust timelines.
- **Communication:** primary channel **Slack**; regular check-ins; **weekly progress demos or
  checkpoints**; a shared tracking sheet for hours, milestones and deliverables.
- **Client responsibilities:** keep the task list prioritised and planned ahead — "ideally there
  needs to be a dedicated product manager who can create and prioritize the backlog"; provide
  timely access to code, documentation and servers; be available for calls and meetings.

### Sprint 1 commercial breakdown

| Sprint / feature area | Utilisation | Rate | Fee |
| --- | ---: | ---: | ---: |
| Authentication & Authorization | 90 h | $40 | $3,600 |
| Customer (Core CRUD) | 170 h | $40 | $6,800 |
| Quote Management (Basic CRUD) | 110 h | $40 | $4,400 |
| Infrastructure & Shared Services | 270 h | $40 | $10,800 |
| Product and Design (already in progress) | 320 h | $40 | $12,800 |
| **Total** | **960 h** | **$40** | **$38,400** |

Subsequent sprints were to be scoped the same way at the start of each month.

---

## Exhibit A — Sprint 1 scope

Document date 6 March 2026 · start 9 March 2026 · **sprint cycle 4 weeks** · team size 6 ·
status *Draft — For Client Review* · 17 features · 960 total hours.

### The delivery process it describes

A structured process running **three threads in parallel** — discovery, design, development:

1. **Product discovery (ongoing)** — structured sessions with operational departments (Dispatch
   named as current, "upcoming departments" to follow) to capture workflows, dependencies, current
   system usage and pain points.
2. **UX/UI conceptualisation** — discovery insights translated into flows and UI concepts in
   **Figma**. Sales insights were already being translated at the time of writing.
3. **Design review and feedback loop** — structured sessions with the TCG team to validate that
   the system reflects real operational workflows.
4. **Client approval and development readiness** — development begins only after designs are
   validated and approved.
5. **Sprint-based development** of the approved designs.

### Sprint 1 objectives

Secure role-based authentication with **JWT sessions and a permission matrix** · complete customer
record management (core CRUD) · foundational quote creation, listing and status management ·
shared infrastructure (database schema, API architecture, UI component library, CI/CD) · a
deployable, demo-ready application on staging by the end of the sprint.

### Feature breakdown (FE / BE hours)

**1. Authentication & Authorization — 90 h.** Login page & branding (14) · JWT auth & session
management (18) · role-based access control (20) · password reset flow (18) · user profile &
settings (20).

**2. Customer (core CRUD) — 170 h.** Customer list/search/filter (28) · create customer wizard
(28) · customer main tab (30) · contacts tab (24) · **customer locations (job sites)** (34) ·
**bill-to management** (26).

**3. Quote Management (basic CRUD) — 110 h.** Quote list/dashboard (24) · **quote number
auto-generation** (10) · main tab header form (36) · job schedule fields (12) · job description
fields (14) · quote status workflow (14).

**4. Infrastructure & Shared Services — 270 h.** PostgreSQL DB schema & migrations (50) · NestJS
API architecture (24) · shared UI component library (25) · **DevOps & deployment (171)**.

Grand total: Sprint 1 development 640 h + product and design 320 h = 960 h (6 devs/devops × 8 h/day).

### Deliverables

**Working software on staging** — the authentication, customer and quote features above, reachable
at an agreed staging URL.

**Technical assets** — PostgreSQL schema, migrations and seed data for lookups; a **NestJS REST
API with auto-generated Swagger/OpenAPI docs**; a **Next.js** front end in a private Git
repository; **Docker Compose** for local and staging; a **GitHub Actions** CI/CD pipeline (lint,
test, build, deploy); a shared UI component library of **17+ reusable Tailwind-styled components**.

**Documentation** — Swagger at the staging URL, an environment setup and deployment guide, and a
Sprint 1 completion report with Sprint 2 recommendations.

> **Discrepancy worth flagging.** Deliverable 5.2 says "**TypeORM** migrations". The platform as
> built uses **Prisma**, and the CodingCops security response written three days later
> ([responsive-design-and-security-posture.md](responsive-design-and-security-posture.md)) already
> names Prisma ORM. The SOW's mention of TypeORM appears to be stale; this document does not say
> when or why the choice changed.

### Timeline

9 March – 3 April 2026, four weekly sprints:

| Week | Days | Focus |
| --- | --- | --- |
| 1 | 1–5 | Environment setup, DB schema, NestJS API architecture, CI/CD, authentication backend |
| 2 | 6–10 | Auth front end (login, RBAC, password reset), shared UI component library, customer list & create wizard |
| 3 | 11–15 | Customer main tab, contacts, locations, bill-to; quote list, number generation, header form |
| 4 | 16–20 | Quote schedule, description, status workflow; integration testing, UAT, staging deployment |

### Team structure

Product Manager (leads department discovery, documents workflows, defines requirements, prioritises
features, coordinates design-to-development handoff) · UX/UI Designer (flows, wireframes,
high-fidelity Figma) · Frontend Lead (Next.js app, shared UI library, customer & quote front end,
auth UI) · Backend Lead (NestJS REST API, JWT auth, business logic, **auto-population engine**,
Swagger) · DB (PostgreSQL schema & migrations) · DevOps (**Redis caching**, Docker Compose, GitHub
Actions).

> The section header says "three (3) dedicated full-stack developers" while the table lists six
> roles and the commercial section bills six resources. The document is internally inconsistent
> on this point; it does not say which is right.

### Acceptance criteria

All 17 in-scope features functional on staging · UAT completed with **no outstanding critical (P1)
defects** · **all three user roles — Admin, Sales Person, Customer — demonstrable end to end** ·
Swagger API documentation available at the staging URL · CI/CD deploys successfully on merge to
`main` · database migrations execute cleanly from a fresh schema.

> The three roles named here (Admin, Sales Person, Customer) do not match the three named in the
> security response three days later (CUSTOMER, HR, ADMIN). Neither document explains the
> difference.

---

## What the embedded images show — read 2026-09-04

The `.docx` carries one image, `media/image5.jpeg`, placed after the "three coordinated threads"
paragraph of Exhibit A. It is a five-node circular diagram titled **"TCG Field Management System
Development Cycle"** (footer *Made with Napkin*), read clockwise from the top: **Product
Discovery** — *Understand workflows and requirements* → **UX/UI Conceptualization** — *Translate
insights into designs* → **Design Review & Feedback** — *Validate and refine designs* → **Client
Approval & Readiness** — *Ensure agreement and prepare for development* → **Development** —
*Implement approved designs in sprints* → back to Product Discovery. It is the five-step delivery
process above drawn as a loop. What it adds: the process is presented as a **repeating cycle**
rather than a one-off sequence, and the product is named the *TCG Field Management System*. Not a
logo; no credentials.

## Source

- `1.2.1_TECHNICAL-SPECS/CRANEGUYS_Executive Summary & SOW.docx` — 39.3 KB as converted text,
  pandoc GFM; its single embedded image (`media/image5.jpeg`) was read on 2026-09-04 — see
  *What the embedded images show*. **The `.pdf` in the same folder is the same document** (25.4 KB via `pdftotext
  -layout`); the two were compared and carry identical content, so only one is cited here.
- `0.0.1_PROJECT-ADMIN/NDA_CodingCops_TCG_2026-01-15_unsigned-template.docx` — 9.8 KB as converted
  text, pandoc GFM. Fourteen numbered articles plus two blank signature blocks.

No credentials, staging URLs or repository addresses appear in either source.

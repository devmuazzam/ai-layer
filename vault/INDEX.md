# TCG vault index

Read this first. 153 files, migrated from Confluence 2026-08-10.

## Read these four lines before you answer anything

1. **Nothing here is verified except the six `domain/` SOP files.** Everything else is `status: unverified` — migrated faithfully, never adjudicated. It is not necessarily current.
2. **Eight open conflicts.** If a file's `conflicts_with` is non-empty, do not pick one and answer from it. Read the conflict stub instead. List below. One of the eight was found *after* the migration, by a drift check against Confluence — the source keeps moving, so this list is not closed.
3. **`FR-FOP-NNN` ids are ambiguous.** Both field-ops FRDs number their requirements from 001, so `FR-FOP-013` is *Lunch Monitoring* in one document and *Lunch Timer and Alerts* in the other. **Always cite the document as well as the id.** A bare "FR-FOP-013" identifies nothing.
4. **`meetings/` is retrospective, not forward-looking.** Every sprint plan there was written after its sprint had already started; one was written four days after it ended. Do not read them as commitments.

## Start here

| If you're asked… | Read |
| --- | --- |
| anything about quotations | [product/quotations-INDEX.md](product/quotations-INDEX.md) first — 4 sources disagree |
| anything about customers or job sites | [product/customers-INDEX.md](product/customers-INDEX.md) first — 5 sources, 3 are copies |
| anything about the mobile / field-worker app | [product/field-ops-mobile-INDEX.md](product/field-ops-mobile-INDEX.md) first — 3 competing documents |
| anything about vendors or agencies | [product/agencies-vendors-INDEX.md](product/agencies-vendors-INDEX.md) first — 4 sources, 2 entities |
| anything about dispatch / DAS | [product/daily-allocation-INDEX.md](product/daily-allocation-INDEX.md) first |
| anything about mobilization / demobilization | [product/mob-demob-INDEX.md](product/mob-demob-INDEX.md) first — 2 sources, only 1 migrated |
| a specific field-ops requirement | the FR-FOP tables at the bottom of this file, then the leaf file |
| how the team runs sprints / Jira / reviews | the six SOP files in `domain/` — the only `verified` content in the vault |
| what `FCC` or `NexGen` means | [domain/fcc-nexgen-fms.md](domain/fcc-nexgen-fms.md) — the only glossary entry. Every other domain term is still undefined; see "Undefined terms" below |
| why something is missing | [README.md](README.md) → *What this vault does not contain* |

## Open conflicts — all unresolved

Full entries with candidates, sizes and dates in [gaps.md](gaps.md).

| Conflict | Sources | Stub |
| --- | --- | --- |
| Field operations mobile app | 3 | [field-ops-mobile-INDEX.md](product/field-ops-mobile-INDEX.md) |
| Quotations | 4 | [quotations-INDEX.md](product/quotations-INDEX.md) |
| Customer | 5 | [customers-INDEX.md](product/customers-INDEX.md) |
| Agencies and vendors | 4 | [agencies-vendors-INDEX.md](product/agencies-vendors-INDEX.md) |
| Daily Allocation System | 2 | [daily-allocation-INDEX.md](product/daily-allocation-INDEX.md) |
| Mobilization & Demobilization | 2 (1 migrated) | [mob-demob-INDEX.md](product/mob-demob-INDEX.md) — found by drift check 2026-08-11, not by the migration |
| Sprint 7 date range | — | [gaps.md](gaps.md) — unrecoverable from the page; 30 seconds to fix with Jira access |
| Punch lists not scoped to their module | 4 | [gaps.md](gaps.md) — structural, deliberately not fixed |

---

## domain/ — team process (the only `verified` files)

| File | Answers | KB |
| --- | --- | --- |
| [domain/development-process-sop.md](domain/development-process-sop.md) | What is our full SDLC, from planning to monitoring? | 5.3 |
| [domain/sprint-planning-sop.md](domain/sprint-planning-sop.md) | How is sprint planning meant to run? | 5.6 |
| [domain/daily-scrum-sop.md](domain/daily-scrum-sop.md) | How is the daily standup meant to run? | 3.9 |
| [domain/backlog-grooming-sop.md](domain/backlog-grooming-sop.md) | How is refinement meant to run? | 3.4 |
| [domain/sprint-closing-sop.md](domain/sprint-closing-sop.md) | How does a sprint get formally closed? | 3.8 |
| [domain/jira-sop.md](domain/jira-sop.md) | What must a ticket contain before it enters a sprint? | 2.9 |

## meetings/ — sprint plans (retrospective, see caveat 4)

| File | Answers | KB |
| --- | --- | --- |
| [meetings/2026-05-20-sprint-3-planning.md](meetings/2026-05-20-sprint-3-planning.md) | What was in Sprint 3, per developer? (26 tickets) | 1.0 |
| [meetings/2026-06-09-sprint-4-planning.md](meetings/2026-06-09-sprint-4-planning.md) | What was in Sprint 4, per developer? (12 tickets) | 0.8 |
| [meetings/2026-06-17-sprint-5-planning.md](meetings/2026-06-17-sprint-5-planning.md) | What was Sprint 5's goal? (body misdated 2025) | 0.7 |
| [meetings/2026-07-14-sprint-6-plan.md](meetings/2026-07-14-sprint-6-plan.md) | What was Sprint 6's scope? | 1.1 |
| [meetings/2026-07-30-sprint-8-planning.md](meetings/2026-07-30-sprint-8-planning.md) | What was Sprint 8's scope? (83 work items) | 0.9 |

## decisions/ — empty by design

Nothing in the source was a clean dated decision. See README for how a resolved gap lands here.

---

## product/ — mobile & field operations

| File | Answers | KB |
| --- | --- | --- |
| [field-ops-mobile-INDEX.md](product/field-ops-mobile-INDEX.md) | **Which field-ops document is authoritative?** (none) | 2.3 |
| [field-ops-frd/INDEX.md](product/field-ops-frd/INDEX.md) | FR-TCG-FOP-**002** v2.0 DRAFT — 12 sections, 30 requirements | 1.5 |
| ├ [01](product/field-ops-frd/01-executive-overview.md) · [02](product/field-ops-frd/02-problem-statement.md) · [03](product/field-ops-frd/03-objectives.md) · [04](product/field-ops-frd/04-scope.md) | Overview, problem, objectives, scope | 2.8 |
| ├ [05-role-definitions.md](product/field-ops-frd/05-role-definitions.md) | Which field roles exist and what can each do? | 1.5 |
| ├ [06](product/field-ops-frd/06-operational-workflow-overview.md) · [07](product/field-ops-frd/07-functional-requirements-summary.md) | Workflow overview and requirements summary | 1.9 |
| ├ [08-functional-requirements/](product/field-ops-frd/08-functional-requirements/INDEX.md) | **30 FR-FOP requirements** — see table below | 38.0 |
| └ [09](product/field-ops-frd/09-workflow-affecting-business-rules.md) · [10](product/field-ops-frd/10-brs-references.md) · [11](product/field-ops-frd/11-open-questions-future-considerations.md) | Business rules, omitted BRS refs, open questions | 1.7 |
| [frd-new-format-draft/INDEX.md](product/frd-new-format-draft/INDEX.md) | FR-TCG-FOP-**001** v1.1 REVIEWED — 9 sections, 40 requirements | 1.1 |
| ├ [01](product/frd-new-format-draft/01-overview.md) · [02](product/frd-new-format-draft/02-problem-statement.md) · [03](product/frd-new-format-draft/03-feature-scope.md) · [04](product/frd-new-format-draft/04-role-responsibility-model.md) | Overview, problem, scope, role model | 4.1 |
| ├ [05-functional-requirements/](product/frd-new-format-draft/05-functional-requirements/INDEX.md) | **40 FR-FOP requirements** — see table below | 44.4 |
| └ [06](product/frd-new-format-draft/06-key-user-flows.md) · [07](product/frd-new-format-draft/07-non-functional-requirements.md) · [08](product/frd-new-format-draft/08-open-questions.md) | User flows, non-functional reqs, open questions | 6.7 |
| [atom-mobile-app-user-stories/INDEX.md](product/atom-mobile-app-user-stories/INDEX.md) | Same app as user stories — 20 stories, 5 EPICs | 0.9 |
| ├ [01-authentication-onboarding.md](product/atom-mobile-app-user-stories/01-authentication-onboarding.md) | How do field staff and temp/vendor users sign in? | 1.4 |
| ├ [02-home-dashboard.md](product/atom-mobile-app-user-stories/02-home-dashboard.md) | What does the crew see on opening the app? | 0.7 |
| ├ [03-ticket-workflow.md](product/atom-mobile-app-user-stories/03-ticket-workflow.md) | The whole ticket lifecycle, US-5 → US-17 | 10.4 |
| └ [04-safety-emergency.md](product/atom-mobile-app-user-stories/04-safety-emergency.md) · [05-employee-self-service.md](product/atom-mobile-app-user-stories/05-employee-self-service.md) | Incident reporting, SOS; profile and history | 1.3 |
| [brs.md](product/brs.md) | Business requirements behind the field-ops app | 9.2 |

## product/ — quotations

| File | Answers | KB |
| --- | --- | --- |
| [quotations-INDEX.md](product/quotations-INDEX.md) | **Which quotation source is authoritative?** (none) | 2.1 |
| [quotation-flow-process.md](product/quotation-flow-process.md) | Lead → job walk → approval → DocuSign → Project. Steps 1–27 | 1.9 |
| [quotations.md](product/quotations.md) | Mohsin punch list: DocuSign defects, revisions, email templates | 1.8 |
| [quotation.md](product/quotation.md) | JZ punch list: industry codes, pre-quote package, Customer PO | 0.8 |

## product/ — customers & job sites

| File | Answers | KB |
| --- | --- | --- |
| [customers-INDEX.md](product/customers-INDEX.md) | **Which customer source is authoritative?** (none) | 2.5 |
| [customer.md](product/customer.md) | Mohsin punch list — mostly UI consistency | 6.1 |
| [customer-and-job-sites.md](product/customer-and-job-sites.md) | JZ punch list: job-site contacts/certs, insurance, billing terms | 1.2 |
| [discussion-points-with-tcg-team.md](product/discussion-points-with-tcg-team.md) | Open questions for the client, several modules | 0.8 |
| [discussion-points-with-mohsin.md](product/discussion-points-with-mohsin.md) | Two job-site questions (copy of a section above) | 0.2 |

## product/ — vendors & agencies

| File | Answers | KB |
| --- | --- | --- |
| [agencies-vendors-INDEX.md](product/agencies-vendors-INDEX.md) | **Which source is authoritative?** (none) | 1.9 |
| [vendors.md](product/vendors.md) | Vendor directory and search, from Dispatch Manager's view | 3.7 |
| [agencies.md](product/agencies.md) | Agencies as a directory that auto-populates permit forms | 1.0 |
| [agencies-module.md](product/agencies-module.md) | Agency UI punch list + cross-app items | 1.4 |
| [agency-and-vendor.md](product/agency-and-vendor.md) | 8-line punch list: sub-contractor category, travel restrictions | 0.2 |

## product/ — dispatch & daily allocation

| File | Answers | KB |
| --- | --- | --- |
| [daily-allocation-INDEX.md](product/daily-allocation-INDEX.md) | **DAS sources — complementary, not rival** | 1.9 |
| [daily-allocation-system.md](product/daily-allocation-system.md) | The DAS spec: drag & drop allocation, dispatch lifecycle, availability, live asset map | 8.7 |
| [job-project-das.md](product/job-project-das.md) | Cross-module punch list; DAS is 1 of 9 sections | 1.7 |
| [dispatcher-needs.md](product/dispatcher-needs.md) | What dispatchers said they need (discovery) | 3.9 |

## product/ — projects, jobs, permits & plans

| File | Answers | KB |
| --- | --- | --- |
| [project-module/INDEX.md](product/project-module/INDEX.md) | Project module — **its own section numbering is unreliable, see index** | 2.2 |
| ├ [01-create-and-track-projects.md](product/project-module/01-create-and-track-projects.md) | How are projects created and tracked? | 1.6 |
| ├ [02-view-manage-job-details.md](product/project-module/02-view-manage-job-details.md) · [03-create-manage-job-schedule.md](product/project-module/03-create-manage-job-schedule.md) | Job details and job scheduling | 4.4 |
| ├ [04-create-and-approve-lift-plans.md](product/project-module/04-create-and-approve-lift-plans.md) | How are lift plans created and approved? | 3.5 |
| ├ [05-create-and-track-permits.md](product/project-module/05-create-and-track-permits.md) | How are permits created and tracked? | 2.6 |
| └ [06-client-reviews-and-signs-quotation.md](product/project-module/06-client-reviews-and-signs-quotation.md) · [07-create-and-manage-jobs-excluded.md](product/project-module/07-create-and-manage-jobs-excluded.md) | Client signing; jobs (**marked excluded**) | 3.9 |

## product/ — yards, tooling, billing, other

| File | Answers | KB |
| --- | --- | --- |
| [user-story-and-tasks.md](product/user-story-and-tasks.md) | **Only** source for yard management, HubSpot sync, email 2FA. From a personal space — check `provenance_note` | 4.3 |
| [yard-operations-jz.md](product/yard-operations-jz.md) | Yard operations punch list | 0.6 |
| [tool-and-rigging.md](product/tool-and-rigging.md) | Tools & rigging management, incl. the yard dashboard | 3.7 |
| [mobilization-and-demobilization.md](product/mobilization-and-demobilization.md) | Mob/demob process — newest content in the vault | 5.0 |
| [purchase-order.md](product/purchase-order.md) | Purchase order handling | 4.7 |
| [billing-code-and-price-list.md](product/billing-code-and-price-list.md) | Billing code and price list punch list | 0.5 |
| [categories-and-sub-categories.md](product/categories-and-sub-categories.md) | Category/sub-category questions (2 tags — thin) | 0.3 |
| [tcg-documents.md](product/tcg-documents.md) | Document and attachment handling | 1.8 |
| [sprint-4-additional.md](product/sprint-4-additional.md) | Extra Sprint 4 stories — tools/rigging in yard & load-out views | 5.4 |

---

## FR-FOP requirements — the two sets are NOT the same numbering

**`product/field-ops-frd/08-functional-requirements/` — FOP-002 v2.0 DRAFT, 30 reqs**

```
001 Bottom Navigation · 002 Home Dashboard · 003 Jobs List · 004 Ticket Details
005 Ticket Acceptance · 006 Ticket Rejection · 007 Ticket Draft Management · 008 Pre-Trip Checklist
009 Leave Yard · 010 Arrive Job Site · 011 Job Safety Analysis (JSA) · 012 Start Work
013 Lunch Monitoring · 014 Lunch Recording · 015 Work Through Lunch · 016 End Work
017 Compliance Checklist · 018 Customer Signatures · 019 Leave Job Site · 020 Arrive Yard
021 Post-Trip Checklist · 022 Submit Ticket · 023 Labor Details · 024 Downtime Management
025 Deficiency Reporting · 026 Escalation Handling · 027 Notification Center · 028 Certifications
029 Tasks · 030 Inspection History
```

**`product/frd-new-format-draft/05-functional-requirements/` — FOP-001 v1.1 REVIEWED, 40 reqs**

```
001 Bottom Navigation · 002 Home Dashboard · 003 Jobs List · 004 Ticket Notification
005 Accept / Reject Ticket · 006 Ticket Detail View · 007 Guided Ticket Workflow · 008 Leave Yard
009 Pre-Trip Checklist · 010 Arrive Job · 011 JSA / Safety Checklist · 012 Start Work
013 Lunch Timer and Alerts · 014 Start / End Lunch · 015 Work-Through-Lunch Authorization · 016 Initial Customer Signature
017 Final Customer Signature · 018 Signature Quality / Fraud Prevention · 019 End Work · 020 Leave Job
021 Arrive Yard · 022 Compliance Checklist · 023 Labor Detail Entry · 024 Boom Pay / Craft Modifier Selection
025 Submit Ticket · 026 Incomplete Ticket Handling · 027 Deficiency Capture · 028 Blocking Issue / Emergency Escalation
029 Notification Center · 030 Downtime and Delay Capture · 031 Live Ticket Visibility · 032 View Certifications
033 Certification Expiry Notification and Upload · 034 Field Task List · 035 Labor History and Audit · 036 Field User Profile
037 Emergency Contacts · 038 Time Rounding · 039 Auto-Save · 040 Audit Trail
```

Filenames are `fr-fop-NNN-<slug>.md` inside the folder above. Only 001, 002, 003, 008/009 (Leave Yard), 012 (Start Work) and 021/020 (Arrive Yard) describe roughly the same thing in both sets — everything else diverges.

---

## Tag vocabulary

Every file carries `topics:` (subject area) and `entities:` (what it actually specifies). Search these rather than grepping prose.

**topics (50)** — `agencies` `assets` `authentication` `billing-codes` `categories` `certifications` `compliance` `crm-integration` `customers` `daily-allocation` `dashboard` `deficiencies` `dispatch` `document-metadata` `documents-attachments` `downtime-delays` `engineering-process` `escalation` `field-ops-mobile` `geolocation` `inspections` `job-sites` `jobs` `labor-payroll` `lift-plans` `lunch-breaks` `mobilization` `navigation-ui` `notifications` `offline-reliability` `open-questions` `permissions-roles` `permits` `pricing` `projects` `purchase-orders` `quotations` `reporting` `requirements-spec` `safety` `scheduling` `scrum-process` `signatures` `sprint-planning` `ticket-workflow` `time-tracking` `tools-rigging` `vendors` `yard-operations` `yards`

**entities (40)** — `agency` `asset` `attachment` `billing-code` `boom-time` `build-up` `category` `certification` `craft-code` `customer` `das` `deficiency` `downtime` `employee` `fcc` `field-ticket` `industry-code` `inspection` `job` `job-site` `labor-record` `lift-plan` `loadout` `lunch-record` `mob-demob` `notification` `permit` `price-list` `project` `purchase-order` `quotation` `schedule` `signature` `sprint` `tailboard-jsa` `task` `tool-rigging` `union-code` `vendor` `yard`

`field-ops-mobile` is an anchor tag on all 102 field-ops files, so it finds the area but does not discriminate within it. Every other topic tag discriminates.

## Undefined terms — the glossary has one entry

**Defined:** `fcc` (and `nexgen`, `atom`) — [domain/fcc-nexgen-fms.md](domain/fcc-nexgen-fms.md), `status: reference`. It resolves the term only: FCC is the legacy Fleet Cost & Care system this platform replaces. **It is not a requirement source** — no spec may cite "FCC/NexGen does X" unless that behaviour is written down in the vault or a ticket.

**Still undefined**, used throughout as if understood and defined nowhere. Ordered by usage, which is the order to ask about them:

`tailboard-jsa` (13 files) · `das` (12) · `boom-time` (9) · `craft-code` (6) · `build-up` (4) · `loadout` (4) · `mob-demob` (1)

`comp-code` is an eighth: it exists in the domain but its only documentation was in the excluded personnel content, so it must be sourced from a person. Definitions land in `domain/`: `status: reference` when sourced externally or from a team member (not migrated content), `status: unverified` when migrated from a page but not yet adjudicated.

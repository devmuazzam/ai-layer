# TCG vault index

Read this first — **then read only what the tables point you at.** 153 files migrated from Confluence
2026-08-10, plus 37 payroll files from a OneDrive drop 2026-08-13, plus 66 client-meeting files
(transcripts/summaries/assets) from a OneDrive drop, plus 34 per-file payroll source pages
(`payroll/sources/`), all added 2026-08-19. This index is a routing table: it tells you which file
answers which question, and it is the only vault file meant to be read whole.

## Read these five lines before you answer anything

1. **Nothing here is verified except the six `domain/` SOP files.** Everything else is `status: unverified` — migrated faithfully, never adjudicated. It is not necessarily current.
2. **Nine open conflicts.** If a file's `conflicts_with` is non-empty, do not pick one and answer from it. Read the conflict stub instead. List below. One of the nine was found *after* the migration, by a drift check against Confluence, and one by reading the meeting recordings against the vault — the source keeps moving, so this list is not closed.
3. **`FR-FOP-NNN` ids are ambiguous.** Both field-ops FRDs number their requirements from 001, so `FR-FOP-013` is *Lunch Monitoring* in one document and *Lunch Timer and Alerts* in the other. **Always cite the document as well as the id.** A bare "FR-FOP-013" identifies nothing.
4. **`PR-NNN` ids are ambiguous too, and for the same reason.** The payroll requirements document and the payroll rule matrix each number their rules from 001, so `PR-010` is *Non-Union Salary Rate* in one and *L12 union base rate* in the other. Cite the document. See [payroll/INDEX.md](payroll/INDEX.md).
5. **`meetings/` is retrospective, not forward-looking.** Every sprint plan there was written after its sprint had already started; one was written four days after it ended. Do not read them as commitments.

## Start here

| If you're asked… | Read |
| --- | --- |
| anything about quotations | [product/quotations-INDEX.md](product/quotations-INDEX.md) first — 4 sources disagree |
| anything about customers or job sites | [product/customers-INDEX.md](product/customers-INDEX.md) first — 5 sources, 3 are copies |
| anything about the mobile / field-worker app | [product/field-ops-mobile-INDEX.md](product/field-ops-mobile-INDEX.md) first — 3 competing documents |
| anything about vendors or agencies | [product/agencies-vendors-INDEX.md](product/agencies-vendors-INDEX.md) first — 4 sources, 2 entities |
| anything about dispatch / DAS | [product/daily-allocation-INDEX.md](product/daily-allocation-INDEX.md) first |
| quantity N on a quote becoming N DAS/Yard sets | [decisions/2026-08-20-quantity-based-das-sets.md](decisions/2026-08-20-quantity-based-das-sets.md) — named decision, SCRUM-907 |
| when a Project Job becomes Completed after DAS/Yard | [decisions/2026-08-20-job-completed-on-last-day-offload.md](decisions/2026-08-20-job-completed-on-last-day-offload.md) — named decision, SCRUM-903 |
| anything about mobilization / demobilization | [product/mob-demob-INDEX.md](product/mob-demob-INDEX.md) first — 2 sources, only 1 migrated |
| **anything about payroll, wages, overtime, union rules or ADP** | [payroll/INDEX.md](payroll/INDEX.md) first — a separate source, a separate migration, and its own four caveats |
| a specific field-ops requirement | [product/fr-fop-numbering.md](product/fr-fop-numbering.md) to pick the right document, then the leaf file |
| how the team runs sprints / Jira / reviews | the six SOP files in `domain/` — the only `verified` content in the vault |
| what `FCC` or `NexGen` means | [domain/fcc-nexgen-fms.md](domain/fcc-nexgen-fms.md) — the only glossary entry. Every other domain term is still undefined; see "Undefined terms" below |
| why something is missing | [README.md](README.md) → *What this vault does not contain* |

## Open conflicts — all unresolved

Full entries with candidates, sizes and dates in [gaps.md](gaps.md). Payroll and ADP questions are
in [payroll/gaps.md](payroll/gaps.md). **Read either by section** (`grep -n '^## '`), never whole.
Questions a ticket raised are not here — they live in §12 of that ticket's
`.ai/aidlc/SCRUM-###/spec.md` (`grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md`).

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
| Meeting recordings vs the vault (2026-08-19 review) | 32 pairs | [gaps.md](gaps.md) (21 product) and [payroll/gaps.md](payroll/gaps.md) (11 payroll) — a recording says one thing, a vault file or ticket says another; unadjudicated |

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

## meetings/ — sprint plans (retrospective, see caveat 5) and client minutes

**Two different kinds of file live here.** The sprint plans are retrospective Confluence pages;
caveat 5 applies to them. The client meeting minutes are **forward-looking**, carry named action
items, and caveat 5 does **not** apply.

### Sprint plans (retrospective)

Six files, `meetings/2026-0[5-7]-*-sprint-*-{planning,plan,report}.md`, one per sprint 3–6 and two
for sprint 8. Each answers only "what was in sprint N, per developer". Sprint 8's report carries the
goal and the four in-scope field-worker statements; nothing else lists its 83 items.

### Client meeting minutes (forward-looking, added 2026-08-13)

| File | Answers | KB |
| --- | --- | --- |
| [meetings/2026-08-05-payroll-module-design-review.md](meetings/2026-08-05-payroll-module-design-review.md) | What was agreed about the Payroll Management module, and what does TCG owe us? | 6.5 |
| [meetings/2026-08-07-labor-compliance-certified-payroll.md](meetings/2026-08-07-labor-compliance-certified-payroll.md) | **What is Labor Compliance / Certified Payroll?** The only source for a module with no other coverage | 7.5 |
| [meetings/2026-08-12-sell-side-workflow-and-scheduling.md](meetings/2026-08-12-sell-side-workflow-and-scheduling.md) | What is the sell-side workflow — scheduling, permits, customer intake? | 6.0 |

**Every action item in these three is outstanding** unless someone has confirmed otherwise. They
are itemised in [gaps.md](gaps.md) (modules, integrations) and [payroll/gaps.md](payroll/gaps.md) (ADP).

### Raw transcripts and auto-summaries (added 2026-08-19, kept separate from the above)

The three curated files above are **human-written minutes** — someone read the meeting and wrote
what mattered. The two folders below are **not that**: they are the underlying source material,
migrated as-is, so a claim like "the client said X" can be checked against what was actually said
instead of taken on trust.

| Folder | What's in it | Index |
| --- | --- | --- |
| `meetings/transcripts/` | 57 raw client-meeting transcripts, 2026-01-15 → 2026-08-18, one file per meeting date | [meetings/transcripts/INDEX.md](meetings/transcripts/INDEX.md) |
| `meetings/summaries/` | 7 third-party AI-generated summaries (Read.ai / Fireflies / an unnamed export) — not human-written, not curated | [meetings/summaries/INDEX.md](meetings/summaries/INDEX.md) |
| `meetings/assets/` | Non-text artifacts from a meeting (currently one diagram from 2026-03-06) | [meetings/assets/README.md](meetings/assets/README.md) |

**Do not treat these as adjudicated.** They carry `status: reference`, not `verified` — nobody has
checked a transcript's claims against the rest of the vault yet, which is exactly what the
*Recordings vs. Confluence Audit* is doing separately, meeting by meeting. Two dates
(2026-07-14, 2026-07-15) have no recording at all; three early dates (01-15, 01-26, 02-09) are an
invite thread or an agenda, not a transcript — each says so in its own frontmatter (`kind:`).

## decisions/ — dated, named, agreed

Nothing in the *migrated source* was a clean dated decision; these were decided since. See README
for how a resolved gap lands here.

| Decision | What it settles |
| --- | --- |
| [decisions/2026-06-30-adp-erp-employee-data-ownership.md](decisions/2026-06-30-adp-erp-employee-data-ownership.md) | Who owns which employee field — ADP vs ERP vs QuickBooks — and that the ERP *initiates* onboarding while ADP performs it. Brian Petros + Ehtesham Anwar, agreed 2026-06-30 |
| [decisions/2026-08-12-plan-comments-page-scope.md](decisions/2026-08-12-plan-comments-page-scope.md) | Which screen "the Plan Comments page" means in `SCRUM-757` |

---

## payroll/ — the payroll module (separate source, migrated 2026-08-13)

**Not from Confluence** — a OneDrive drop of 37 files, plus two written from chat and research
(the Foreman/Military premiums, and what ADP's API permits). Confluence had no payroll content of
its own until 2026-08-18, when two user-story pages appeared (`Payroll management`, `Craft codes`
— **unmigrated**, see [payroll/gaps.md](payroll/gaps.md) → *Confluence payroll user stories*); the
field-ops FRD's *BRS References* table is the formal link between the two areas.
Read [payroll/INDEX.md](payroll/INDEX.md) first — it carries its own caveats and its own gaps
register.

| File | Answers | KB |
| --- | --- | --- |
| [payroll/INDEX.md](payroll/INDEX.md) | **Where do payroll answers come from, and what is unsettled?** | 6.0 |
| [payroll/erp-payroll-module-frd/INDEX.md](payroll/erp-payroll-module-frd/INDEX.md) | What must the ERP payroll module do? Draft 0.1, 11 parts, 55 `PR-###` rules | 47.0 |
| [payroll/codingcops-rule-matrix.md](payroll/codingcops-rule-matrix.md) | **Which rule do I build, and what is still undecided about it?** 68 rules | 20.8 |
| [payroll/mcog-l12-mla-2025-2028/INDEX.md](payroll/mcog-l12-mla-2025-2028/INDEX.md) | What does the union contract actually say? 5 parts | 74.0 |
| [payroll/payroll-app-current-state/INDEX.md](payroll/payroll-app-current-state/INDEX.md) | How does the legacy Payroll App behave today? 9 files (2026-06 pack; corrected by the db-extract) | 51.0 |
| [payroll/legacy-payroll-app-db-extract/INDEX.md](payroll/legacy-payroll-app-db-extract/INDEX.md) | **How does the legacy Payroll App actually calculate pay?** Full DB extract 2026-08-18 — all SQL, all config, worked examples, ADP worksheet layout | 12.6 |
| [payroll/adp-bucket-crosswalk.md](payroll/adp-bucket-crosswalk.md) | How does a pay component become an ADP paydata field? 9 open decisions | 22.3 |
| [payroll/adp-hour-earning-codes.md](payroll/adp-hour-earning-codes.md) | Which ADP Hours/Earnings codes exist? (partial export) | 2.9 |
| [payroll/adp-sop-v3.8.md](payroll/adp-sop-v3.8.md) | How is payroll produced today, step by step? (the process being replaced) | 11.7 |
| [payroll/payroll-concepts-shift-job-labor-entry.md](payroll/payroll-concepts-shift-job-labor-entry.md) | What is a Shift vs a Job vs a Labor Entry, and what is the anchor date? | 3.0 |
| [payroll/wtl-charts.md](payroll/wtl-charts.md) | How do worked-through-lunch penalties land against Reg/OT/DT? 3 charts | 24.0 |
| [payroll/rule-examples-catalog.md](payroll/rule-examples-catalog.md) | Which real labor entry demonstrates this rule? 28 test seeds | 11.4 |
| [payroll/source-manifest.md](payroll/source-manifest.md) | Was this source file migrated, and if not why? All 33 | 7.1 |
| [payroll/sources/INDEX.md](payroll/sources/INDEX.md) | **Is `<filename>` in the vault?** One page per source file, named after the file, all 33 | 4.0 |
| [payroll/adp-workbook-column-rules.md](payroll/adp-workbook-column-rules.md) | What does each column in the weekly ADP workbook mean, and what rule governs it? No employee data | 11.0 |
| [payroll/source-attribution-and-conflicts.md](payroll/source-attribution-and-conflicts.md) | **Who says a payroll rule, and where do the four source families disagree?** 21-item conflict register | 28.0 |

Three source PDFs of the union agreement **could not be read at all** — they are scans with no
text layer. See the manifest.

---

## product/ — mobile & field operations

| File | Answers | KB |
| --- | --- | --- |
| [field-ops-mobile-INDEX.md](product/field-ops-mobile-INDEX.md) | **Which field-ops document is authoritative?** (none) | 2.3 |
| [field-ops-frd/INDEX.md](product/field-ops-frd/INDEX.md) | FR-TCG-FOP-**002** v2.0 DRAFT — 12 sections, 30 requirements | 1.5 |
| ├ [01](product/field-ops-frd/01-executive-overview.md) · [02](product/field-ops-frd/02-problem-statement.md) · [03](product/field-ops-frd/03-objectives.md) · [04](product/field-ops-frd/04-scope.md) | Overview, problem, objectives, scope | 2.8 |
| ├ [05-role-definitions.md](product/field-ops-frd/05-role-definitions.md) | Which field roles exist and what can each do? | 1.5 |
| ├ [06](product/field-ops-frd/06-operational-workflow-overview.md) · [07](product/field-ops-frd/07-functional-requirements-summary.md) | Workflow overview and requirements summary | 1.9 |
| ├ [08-functional-requirements/](product/field-ops-frd/08-functional-requirements/INDEX.md) | **30 FR-FOP requirements** — see [fr-fop-numbering.md](product/fr-fop-numbering.md) | 38.0 |
| └ [09](product/field-ops-frd/09-workflow-affecting-business-rules.md) · [10](product/field-ops-frd/10-brs-references.md) · [11](product/field-ops-frd/11-open-questions-future-considerations.md) | Business rules, omitted BRS refs, open questions | 1.7 |
| [frd-new-format-draft/INDEX.md](product/frd-new-format-draft/INDEX.md) | FR-TCG-FOP-**001** v1.1 REVIEWED — 9 sections, 40 requirements | 1.1 |
| ├ [01](product/frd-new-format-draft/01-overview.md) · [02](product/frd-new-format-draft/02-problem-statement.md) · [03](product/frd-new-format-draft/03-feature-scope.md) · [04](product/frd-new-format-draft/04-role-responsibility-model.md) | Overview, problem, scope, role model | 4.1 |
| ├ [05-functional-requirements/](product/frd-new-format-draft/05-functional-requirements/INDEX.md) | **40 FR-FOP requirements** — see [fr-fop-numbering.md](product/fr-fop-numbering.md) | 44.4 |
| └ [06](product/frd-new-format-draft/06-key-user-flows.md) · [07](product/frd-new-format-draft/07-non-functional-requirements.md) · [08](product/frd-new-format-draft/08-open-questions.md) | User flows, non-functional reqs, open questions | 6.7 |
| [atom-mobile-app-user-stories/INDEX.md](product/atom-mobile-app-user-stories/INDEX.md) | Same app as user stories — **re-migrated 2026-08-13 from Confluence v10: now 22 stories, EPIC 1–17** | 4.0 |
| ├ [00-overview.md](product/atom-mobile-app-user-stories/00-overview.md) · [01-authentication-and-dashboard.md](product/atom-mobile-app-user-stories/01-authentication-and-dashboard.md) | Workflow summary; sign-in, vendor OTP, dashboard | 4.2 |
| ├ [02-ticket-assignment-and-pre-trip.md](product/atom-mobile-app-user-stories/02-ticket-assignment-and-pre-trip.md) | Accept/reject, ticket details, pre-trip, left yard, travel, arrival, JSA | 7.4 |
| ├ [03-work-execution-and-lunch.md](product/atom-mobile-app-user-stories/03-work-execution-and-lunch.md) | Boom time, build-up/breakdown — and **lunch thresholds that contradict the payroll charts** | 6.7 |
| ├ [04-completion-and-return.md](product/atom-mobile-app-user-stories/04-completion-and-return.md) | Final signature, return travel, arrive yard, post-trip | 5.0 |
| ├ [05-compliance-labor-and-review.md](product/atom-mobile-app-user-stories/05-compliance-labor-and-review.md) | **The payroll handoff** — compliance attestation, labor & unit details, review | 6.4 |
| └ [06-safety-and-self-service.md](product/atom-mobile-app-user-stories/06-safety-and-self-service.md) | Incident reporting, SOS; profile and certifications | 2.8 |
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

## FR-FOP requirements — two numberings

The two field-ops FRDs number from 001 and diverge after 003. Both lists, side by side, are in
[product/fr-fop-numbering.md](product/fr-fop-numbering.md). Cite the document with the id — see caveat 3.

---

## Tag vocabulary

Every file carries `topics:` and `entities:` frontmatter — search those rather than grepping prose.
The 50 topics and 40 entities are listed in [tags.md](tags.md).

## Undefined terms — the glossary has one entry

**Defined:** `fcc` (and `nexgen`, `atom`) — [domain/fcc-nexgen-fms.md](domain/fcc-nexgen-fms.md), `status: reference`. It resolves the term only: FCC is the legacy Fleet Cost & Care system this platform replaces. **It is not a requirement source** — no spec may cite "FCC/NexGen does X" unless that behaviour is written down in the vault or a ticket.

**Still undefined**, used throughout as if understood and defined nowhere. Ordered by usage, which is the order to ask about them:

`tailboard-jsa` (13 files) · `das` (12) · `boom-time` (9) · `craft-code` (6) · `build-up` (4) · `loadout` (4) · `mob-demob` (1)

`comp-code` is an eighth: it exists in the domain but its only documentation was in the excluded personnel content, so it must be sourced from a person. Definitions land in `domain/`: `status: reference` when sourced externally or from a team member (not migrated content), `status: unverified` when migrated from a page but not yet adjudicated.

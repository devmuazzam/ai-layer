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
| anything about quotations | [quotations/quotations-INDEX.md](quotations/quotations-INDEX.md) first — 4 sources disagree |
| anything about customers or job sites | [customers/customers-INDEX.md](customers/customers-INDEX.md) first — 5 sources, 3 are copies |
| anything about the mobile / field-worker app | [field-ops/field-ops-mobile-INDEX.md](field-ops/field-ops-mobile-INDEX.md) first — 3 competing documents |
| anything about vendors or agencies | [vendors-agencies/agencies-vendors-INDEX.md](vendors-agencies/agencies-vendors-INDEX.md) first — 4 sources, 2 entities |
| anything about dispatch / DAS | [dispatch/daily-allocation-INDEX.md](dispatch/daily-allocation-INDEX.md) first |
| quantity on a quote vs DAS/Yard sets | [decisions/2026-08-31-quotation-qty-not-das-sets.md](decisions/2026-08-31-quotation-qty-not-das-sets.md) — qty is billing only, one set per root; supersedes 2026-08-20 |
| where a Save button leaves the user | [decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md](decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md) — create **and** edit both land on the entity's detail page, app-wide; supersedes the create half of 2026-08-20 |
| when a Project Job becomes Completed after DAS/Yard | [decisions/2026-08-20-job-completed-on-last-day-offload.md](decisions/2026-08-20-job-completed-on-last-day-offload.md) — named decision, SCRUM-903 |
| SCRUM-903 vendor/backfill scope (none in that ticket) | [decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md](decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md) — named decision |
| Completed Project Jobs editable? | [decisions/2026-08-25-completed-job-view-only.md](decisions/2026-08-25-completed-job-view-only.md) — hard view-only, SCRUM-903 Q5 |
| anything about mobilization / demobilization | [quotations/mob-demob-INDEX.md](quotations/mob-demob-INDEX.md) first — 2 sources, only 1 migrated |
| **anything about payroll, wages, overtime, union rules or ADP** | [payroll/INDEX.md](payroll/INDEX.md) first — a separate source, a separate migration, and its own four caveats |
| a specific field-ops requirement | [field-ops/fr-fop-numbering.md](field-ops/fr-fop-numbering.md) to pick the right document, then the leaf file |
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
| Field operations mobile app | 3 | [field-ops-mobile-INDEX.md](field-ops/field-ops-mobile-INDEX.md) |
| Quotations | 4 | [quotations-INDEX.md](quotations/quotations-INDEX.md) |
| Customer | 5 | [customers-INDEX.md](customers/customers-INDEX.md) |
| Agencies and vendors | 4 | [agencies-vendors-INDEX.md](vendors-agencies/agencies-vendors-INDEX.md) |
| Daily Allocation System | 2 | [daily-allocation-INDEX.md](dispatch/daily-allocation-INDEX.md) |
| Mobilization & Demobilization | 2 (1 migrated) | [mob-demob-INDEX.md](quotations/mob-demob-INDEX.md) — found by drift check 2026-08-11, not by the migration |
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
| [meetings/2026-08-26-fcc-migration-client-brief.md](meetings/2026-08-26-fcc-migration-client-brief.md) | **What did TCG say about the FCC test migration?** CodingCops' brief with the client's annotations; 13 asks + 2 seeder defects, all open (added 2026-08-27) | 8.7 |

**Every action item in these four is outstanding** unless someone has confirmed otherwise. They
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
| [decisions/2026-08-31-quotation-qty-not-das-sets.md](decisions/2026-08-31-quotation-qty-not-das-sets.md) | Quotation qty is a billing scalar — not DAS/Yard set count; child qty independent. Fouzan Shakil, supersedes `2026-08-20-quantity-based-das-sets` (`SCRUM-907` / `SCRUM-892`) |
| [decisions/2026-08-20-archive-instead-of-delete-app-wide.md](decisions/2026-08-20-archive-instead-of-delete-app-wide.md) | Archive replaces delete **app-wide**, on the existing `archivedAt` pattern — `Plan` included. Fouzan Shakil, resolves `SCRUM-896` §12 Q1. Delete endpoints and an admin hard-delete escape hatch are **not** settled |
| [decisions/2026-08-20-post-save-navigation-convention.md](decisions/2026-08-20-post-save-navigation-convention.md) | After **edit** → the entity's detail page; after **create** → the listing page. App-wide. Fouzan Shakil, resolves `SCRUM-896` §12 Q2. **The create half is superseded** by `2026-09-01-post-save-navigation-create-goes-to-detail`; the edit half stands |
| [decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md](decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md) | After **create** → the **new entity's detail page**, app-wide — reversing the create half of `2026-08-20-post-save-navigation-convention`. Edit → detail unchanged; nested, draft, cancel/error, "save and add another", mobile and retro-fit sequencing all still open. Fouzan Shakil |
| [decisions/2026-08-20-planning-tracker-archived-filter.md](decisions/2026-08-20-planning-tracker-archived-filter.md) | The Planning Tracker must have a **filter that shows archived plans** — the tracker's `archivedAt: null` exclude is a default, not permanent. **Implementation deferred to a follow-up ticket.** Fouzan Shakil, resolves `SCRUM-896` §12 Q3. Filter shape, restore-from-tracker and the **Permits** tracker are **not** settled |

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

## The modules — read the module INDEX first

One folder per product module, mirroring the backend ([STRUCTURE.md](STRUCTURE.md) has the standard,
the BE mapping, the tag facets, and the old→new redirect map). **A new module question (no ticket)
goes in that module's `gaps.md`** — see STRUCTURE.md → *Where a question goes*.

| Module | Read first | Also holds |
| --- | --- | --- |
| `payroll/` | [payroll/INDEX.md](payroll/INDEX.md) | Payroll — separate migration, own caveats — — source files, gaps.md |
| `field-ops/` | [field-ops/INDEX.md](field-ops/INDEX.md) | The Atom field-worker mobile app · conflict stub — 4 source files, gaps.md |
| `quotations/` | [quotations/INDEX.md](quotations/INDEX.md) | Quotations, pricing, billing codes, mob/demob · conflict stub — 6 source files, gaps.md |
| `dispatch/` | [dispatch/INDEX.md](dispatch/INDEX.md) | DAS, scheduling, yard operations · conflict stub — 4 source files, gaps.md |
| `customers/` | [customers/INDEX.md](customers/INDEX.md) | Customers, customer contacts, job sites · conflict stub — 3 source files, gaps.md |
| `vendors-agencies/` | [vendors-agencies/INDEX.md](vendors-agencies/INDEX.md) | Vendors, agencies, purchase orders · conflict stub — 6 source files, gaps.md |
| `projects-jobs/` | [projects-jobs/INDEX.md](projects-jobs/INDEX.md) | Projects, jobs, plans, permits — 2 source files, gaps.md |
| `assets/` | [assets/INDEX.md](assets/INDEX.md) | Assets, yards-as-records, tools & rigging, categories — 3 source files, gaps.md |
| `accounting/` | [accounting/INDEX.md](accounting/INDEX.md) | Invoicing and accounting (module not yet built) — — source files, gaps.md |
| `admin/` | [admin/INDEX.md](admin/INDEX.md) | Auth, users, tenancy, settings, reference data — 1 source files, gaps.md |

Cross-cutting, tag-routed: `meetings/` (chronological — [transcripts INDEX](meetings/transcripts/INDEX.md), [summaries INDEX](meetings/summaries/INDEX.md); `grep -rl 'module/<x>' vault/meetings/`),
[decisions/](decisions/) (flat; tagged `module/<x>`), [domain/](domain/) (process SOPs), [brs.md](brs.md) (product-wide BRS).

## FR-FOP requirements — two numberings

The two field-ops FRDs number from 001 and diverge after 003. Both lists, side by side, are in
[field-ops/fr-fop-numbering.md](field-ops/fr-fop-numbering.md). Cite the document with the id — see caveat 3.

---

## Tag vocabulary

Every file carries Obsidian-native `tags:` — facets `module/<x>` and `kind/<y>` plus closed
subject tags, defined in [STRUCTURE.md](STRUCTURE.md). Search tags, not prose:
`grep -rl 'module/dispatch' vault/`. (`topics:`/`entities:` are retired; old vocabulary in [tags.md](tags.md).)

## Undefined terms — the glossary has one entry

**Defined:** `fcc` (and `nexgen`, `atom`) — [domain/fcc-nexgen-fms.md](domain/fcc-nexgen-fms.md), `status: reference`. It resolves the term only: FCC is the legacy Fleet Cost & Care system this platform replaces. **It is not a requirement source** — no spec may cite "FCC/NexGen does X" unless that behaviour is written down in the vault or a ticket.

**Still undefined**, used throughout as if understood and defined nowhere. Ordered by usage, which is the order to ask about them:

`tailboard-jsa` (13 files) · `das` (12) · `boom-time` (9) · `craft-code` (6) · `build-up` (4) · `loadout` (4) · `mob-demob` (1)

`comp-code` is an eighth: it exists in the domain but its only documentation was in the excluded personnel content, so it must be sourced from a person. Definitions land in `domain/`: `status: reference` when sourced externally or from a team member (not migrated content), `status: unverified` when migrated from a page but not yet adjudicated.

# TCG vault index

Read this first — **then read only what the tables point you at.** 153 files migrated from Confluence
2026-08-10, plus 37 payroll files from a OneDrive drop 2026-08-13, plus 66 client-meeting files
(transcripts/summaries/assets) from a OneDrive drop, plus 34 per-file payroll source pages
(`payroll/sources/`), all added 2026-08-19, plus **~100 pages from the client's SharePoint
"Project Repository" (17 archives, 894-file city-permit library, 482 source files) added
2026-09-04** — every source file dispositioned in
[sync/project-repository-2026-09-04.md](sync/project-repository-2026-09-04.md). This index is a
routing table: it tells you which file answers which question, and it is the only vault file meant
to be read whole.

## Read these five lines before you answer anything

1. **Nothing here is verified except the six `domain/` *SOP* files** (`development-process`, `sprint-planning`, `daily-scrum`, `backlog-grooming`, `sprint-closing`, `jira`). `domain/` now holds four more pages — `fcc-nexgen-fms` and the three value-engine pages from the 2026-09-04 drop — and those are **`unverified` like everything else**. Everything else is `status: unverified` — migrated faithfully, never adjudicated. It is not necessarily current.
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
| employees in yard loadout / Start Loadout pre-tick / DAS steal on reassignment | [decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md](decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md) — Ehtesham Anwar, `fix/15-sep` as built; employees are **not** loaded; handover opens unchecked; plain allocations are stolen even off ticket-sent jobs. Supersedes parts of 2026-09-14 |
| quotation print/PDF letterhead | [decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md](decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md) — Lovable seal letterhead + Portal Dr fallbacks; does **not** adjudicate the quotations conflict stub |
| quantity on a quote vs DAS/Yard sets | [decisions/2026-08-31-quotation-qty-not-das-sets.md](decisions/2026-08-31-quotation-qty-not-das-sets.md) — qty is billing only, one set per root; supersedes 2026-08-20 |
| where a Save button leaves the user | [decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md](decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md) — create **and** edit both land on the entity's detail page, app-wide; supersedes the create half of 2026-08-20 |
| dirty leave / unsaved-changes modal buttons | [decisions/2026-09-12-edit-leave-confirmation-offers-save.md](decisions/2026-09-12-edit-leave-confirmation-offers-save.md) — edit = Cancel/Leave/Save; create = Leave/Cancel (or Save Draft); failed Save keeps the dialog open |
| when a Project Job becomes Completed after DAS/Yard | [decisions/2026-08-20-job-completed-on-last-day-offload.md](decisions/2026-08-20-job-completed-on-last-day-offload.md) — named decision, SCRUM-903 |
| SCRUM-903 vendor/backfill scope (none in that ticket) | [decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md](decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md) — named decision |
| Completed Project Jobs editable? | [decisions/2026-08-25-completed-job-view-only.md](decisions/2026-08-25-completed-job-view-only.md) — hard view-only, SCRUM-903 Q5 |
| anything about mobilization / demobilization | [quotations/mob-demob-INDEX.md](quotations/mob-demob-INDEX.md) first — 2 sources, only 1 migrated |
| **anything about payroll, wages, overtime, union rules or ADP** | [payroll/INDEX.md](payroll/INDEX.md) first — a separate source, a separate migration, and its own four caveats |
| a specific field-ops requirement | [field-ops/fr-fop-numbering.md](field-ops/fr-fop-numbering.md) to pick the right document, then the leaf file |
| how the team runs sprints / Jira / reviews | the six SOP files in `domain/` — the only `verified` content in the vault |
| what `FCC` or `NexGen` means | [domain/fcc-nexgen-fms.md](domain/fcc-nexgen-fms.md) — the only glossary entry. Every other domain term is still undefined; see "Undefined terms" below |
| what the client themselves asked for, across every module | [erp-review-log.md](erp-review-log.md) — TCG's own feedback register: 14 dated entries by named staff + 69 AI-extracted items. **Nothing in it is adjudicated** |
| what was raised in UAT, and whether it was built | [uat/INDEX.md](uat/INDEX.md) — six sessions (9–17 Sep 2026) and the 252-row register checked against `origin/main` at `f800a3972`. **A record of requests and their build status, never a source for a spec** |
| the name of *any* file that was in the 2026-09-04 SharePoint drop (now deleted locally) | [sync/project-repository-2026-09-04-file-inventory.md](sync/project-repository-2026-09-04-file-inventory.md) — all 1,446 paths with sizes and duplicate groups; `grep` it |
| where a file from the 2026-09-04 SharePoint drop went | [sync/project-repository-2026-09-04.md](sync/project-repository-2026-09-04.md) — every source file, including the ones deliberately not migrated |
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

## domain/ — team process (the six SOPs are the only `verified` files)

| File | Answers | KB |
| --- | --- | --- |
| [domain/development-process-sop.md](domain/development-process-sop.md) | What is our full SDLC, from planning to monitoring? | 5.3 |
| [domain/sprint-planning-sop.md](domain/sprint-planning-sop.md) | How is sprint planning meant to run? | 5.6 |
| [domain/daily-scrum-sop.md](domain/daily-scrum-sop.md) | How is the daily standup meant to run? | 3.9 |
| [domain/backlog-grooming-sop.md](domain/backlog-grooming-sop.md) | How is refinement meant to run? | 3.4 |
| [domain/sprint-closing-sop.md](domain/sprint-closing-sop.md) | How does a sprint get formally closed? | 3.8 |
| [domain/jira-sop.md](domain/jira-sop.md) | What must a ticket contain before it enters a sprint? | 2.9 |

**Also in `domain/`, and `unverified`** — how TCG itself works, not how we work:

| File | Answers | KB |
| --- | --- | --- |
| [domain/INDEX.md](domain/INDEX.md) | Router for this folder | — |
| [domain/fcc-nexgen-fms.md](domain/fcc-nexgen-fms.md) | What `FCC` / `NexGen` / `Atom` mean — term resolution only, **never a requirement source** | — |
| [domain/value-engines-and-playbooks-method.md](domain/value-engines-and-playbooks-method.md) | **What a "value engine" and a "playbook" are** — TCG's house process-mapping method, its five symbols and how one is authored. Read this before reading any value-engine instance | — |
| [domain/tcg-it-value-engines-and-playbooks.md](domain/tcg-it-value-engines-and-playbooks.md) | TCG IT's own app-development and change-management process — including a change-approval gate whose applicability to our releases is **unanswered** | — |
| [domain/wes-whiteboard-value-engines.md](domain/wes-whiteboard-value-engines.md) | AI transcriptions of whiteboard photographs — **transcription, not verified process** | — |

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
| [meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md](meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md) | **What did TCG decide about lunches, paid-time boundaries, the boom window and July-1 rate updates on 2026-09-03?** Wes Staley's ruling that *paid straight through* is not to be built; yard-to-yard paid span; bulk rate path (added 2026-09-07) | 5.9 |
| [meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md](meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md) | **What did TCG say at the first from-scratch walkthrough (2026-09-15)?** Joe Schacatano: quote line items are not dispatch resources — oiler/operator/semi are never charged; Joe and Ryan want off DocuSign; sign-in identity (Entra vs phone/SMS) unsettled. The demo table is an as-built record, not a spec (added 2026-09-17) | 22.2 |
| [meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md](meetings/2026-09-16-resource-types-billing-codes-configurations-and-permit-pos.md) | **What did Joe say a quote carries, and what belongs to dispatch, on 2026-09-16?** Quote = billing codes only; resources are dispatch-side with no code of their own; pick the machine directly. One asset, one schedule type, but several configurations. Mob/demob roll-up as a billing-code option. The customer sees the estimate plus a ticket packet. A PO for every job cost (added 2026-09-17) | 18.6 |
| [meetings/2026-09-28-adp-integration-sync-onboarding-worksheets-and-temp-rate.md](meetings/2026-09-28-adp-integration-sync-onboarding-worksheets-and-temp-rate.md) | **How does TCG hire and pay an employee in ADP today, and what did the 2026-09-28 ADP sync agree?** Onboarding stays in ADP and the ERP binds the file number, which **conflicts with the 06-30 ERP-initiated decision**. Three pay types and three weekly worksheets; phase 1 covers union field only; temp rate overrides the whole row; long boom depends on boom length only; `4RY` is a dead code; testing happens in live `4RZ` with test employees | 19.2 |
| [meetings/2026-10-01-quotes-and-billing-codes-associated-assets-mob-demob-and-holdover.md](meetings/2026-10-01-quotes-and-billing-codes-associated-assets-mob-demob-and-holdover.md) | **What did Joe say goes on a quote, and how do mob/demob quantities work, on 2026-10-01?** An association's own associations never go on the quote (Operator Load is one billing code); every mob/demob line has its own editable quantity, demob starts at 0, the mob line's quantity must be editable; a main item means it stays on the job; quoted-vs-scheduled hours alert wanted. Six open questions (added 2026-10-02) | 16.4 |
| [meetings/2026-10-07-sprint-review-offline-tickets-holdover-and-mob-demob-sign-off.md](meetings/2026-10-07-sprint-review-offline-tickets-holdover-and-mob-demob-sign-off.md) | **What did the 2026-10-07 sprint review show and settle?** Offline job tickets and payroll-admin entry fixes demoed. Joe defined holdover as the machine staying on site, however many days, and wants it chosen on the quote with a days dropdown. TCG wants new words for loadout/offload. Joe approved per-association, configurable quote visibility for mob/demob. Two cranes on one job get one quote with separate mob/demob per crane, while options and phases are separate quotes. Six open questions (added 2026-10-08) | 18.3 |
| [meetings/2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md](meetings/2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md) | **What did the 2026-10-08 accounting demo show, and what did TCG ask for?** Designs, not shipped code: invoices built from payroll-clean, completed tickets with a preview, a quoted-vs-actual flag and an auto-gathered customer packet; created in the ERP and QuickBooks together; a sales approval loop; AR with aging buckets, retention and projections; AP bills from vendor POs with the PDF attached; QuickBooks statuses pulled back. Open: which system sends the invoice, where credit memos live, retention and the 10-day discount (unsourced). TCG asks: Brent's weekly collections checklist, AR movement and days-to-pay projections, AR by service type, a paid-job notification to pay subcontractors (LADWP pays subs before billing), one view over two QuickBooks companies (TCG and TRG). |
| [meetings/2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md](meetings/2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md) | **What did the 2026-10-13 accounting follow-up settle, and what did Safety say about field audits?** Brent and Tia agreed to invoice by **whole day of a job, never per ticket**: a payroll-flagged ticket blocks its day, and several days can share an invoice. Holdover invoicing was not decided there (ehtesham.anwar's "invoiced once, as a whole" is superseded by Melissa's 2026-10-20 answer: holdovers billed weekly). Designs, not shipped code: vendor bills against POs (markup only on the customer invoice, attachment to QuickBooks, payment held until the customer pays), a customer setting that pulls vendor documents into the packet, a customer-level collections tab with promise-to-pay, AP per vendor, and a cash-flow overview. Safety (Dee, on Brian's mic): paper audits typed into Excel, with photos in Teams. Asks: one place per job, per-employee audit recency with route suggestions, crane-superintendent sign-off, a forms dropdown, and e-mailing JSAs from site. Open: the paper on-site scope of work. Seven open questions | 20.5 |
| [meetings/2026-10-16-accounting-prototype-review-email-brent-wagstaff-and-ehtesham-anwar.md](meetings/2026-10-16-accounting-prototype-review-email-brent-wagstaff-and-ehtesham-anwar.md) | **What did Brent ask in his written review of the accounting prototype, and what did CodingCops answer?** E-mail, 2026-10-16, `unverified`. Brent's e-mail verbatim: client asks for per-customer average days-to-pay (for payment forecasting), an AR tab like AP v2, marking AP bills to be paid / sent to bank, partial payments, forecast vs actual cash flow, and approval-reminder intervals. Ehtesham's reply is CodingCops' answers and proposals only: status meanings, a proposed vendor-bill flow that creates the QuickBooks bill only when ready to pay (Case 1 after the customer pays, Case 2 before the customer invoice), days-to-pay bands 45/60, reports now built. No decision. Six open questions filed in accounting/gaps.md | 17.8 |

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
| [decisions/2026-09-11-po-closed-means-closed-out-not-cancelled.md](decisions/2026-09-11-po-closed-means-closed-out-not-cancelled.md) | PO `CLOSED` = **closed-out, not cancelled**: keeps permit links and type, stays on the permit tracker; auto-closes only on an Invoice-category attachment, auto-reopens when the last is removed, explicit Close/Reopen; **archive** unlinks permits. Fouzan Shakil (CodingCops, `reference`), `fix/das-fixes` review |
| [decisions/2026-09-11-legacy-po-and-permit-type-remap.md](decisions/2026-09-11-legacy-po-and-permit-type-remap.md) | Legacy remap in migration `20260910180000`: PO status by legacy value (`PURCHASED/ACTIVE/CANCELLED/INACTIVE` → `CLOSED`, `PENDING/DRAFT` → `OPEN`), `GENERAL/CONTRACT` → `VENDOR`, permit types by the association held. Fouzan Shakil, `reference`. **FCC-import `ACTIVE` → `CLOSED` not confirmed** |
| [decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md](decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md) | Discount and Price Hike are **footer rows like the surcharge row**; row Amount is pre-adjustment (qty × rate; Mob/Demob parent = sum of included children) so the column sums to the Total. Fouzan Shakil, `reference`. Printed quote not settled |
| [decisions/2026-09-11-billing-code-type-master-dropped.md](decisions/2026-09-11-billing-code-type-master-dropped.md) | `billing_code_types`, its status enum and `billing_codes.billing_code_type_id` **dropped** (migration `20260911040000`); supersedes the *"Add billing code type CRUD"* ask. Fouzan Shakil, `reference`. TCG never rejected the FCC lookup — re-seed record in `quotations/` |
| [decisions/2026-09-11-track-permits-job-only-until-sept-15.md](decisions/2026-09-11-track-permits-job-only-until-sept-15.md) | **Track Permits lists job-linked permits only** until after 15 Sep 2026; asset-/vendor-linked permits get no status actions — a known, accepted gap. Fouzan Shakil, `reference`; extends the job-only create note |
| [decisions/2026-09-11-quotation-archive-blocked-by-in-flight-jobs.md](decisions/2026-09-11-quotation-archive-blocked-by-in-flight-jobs.md) | Quotation archive **blocked while any linked job is `ACTIVE` or `ON_HOLD`**; allowed once all are `COMPLETED`/`INVOICED`/`CANCELLED`. Fouzan Shakil, `reference`. Effect on WON revenue KPIs **left open** |
| [decisions/2026-09-14-quotation-mark-won-requires-comment-or-attachment.md](decisions/2026-09-14-quotation-mark-won-requires-comment-or-attachment.md) | Manual Mark as Won requires **comment or dialog-uploaded `WON_EVIDENCE` attachment** (web + API). Existing attachments do not count. Mobile evidence UI and DocuSign auto-WON out of scope. `reference` |
| [decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md](decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md) | **One job ticket per asset group per day, never per employee.** Crane set with an Oiler seat → Oiler is primary and fills it, Operator is a second employee on the *same* ticket with a separate labor record entered by the Oiler; no Oiler → Operator fills it; each support load is its own ticket. Lisette-approved `ASSETS_DISPATCH` sheet + 05-14/05-19/05-21/06-04 calls. Supersedes PR #561's read-only copy; closes field-ops *Who fills the ticket* and FR-TCG-FOP-001 Q11. `reference` |
| [decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md](decisions/2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md) | Engineering shape for the above: ticket keyed by the **primary's allocation** (no asset-group entity), new **`ticket_employees`** row per employee with `isPrimary` + Labor & Unit fields, `TicketTimeEntry` stays per ticket, payroll prices per ticket-employee; migrate live pairs only, COMPLETE pairs stay two rows; Operator sees step status only. `reference` |
| [decisions/2026-09-11-permit-approval-requires-linked-po.md](decisions/2026-09-11-permit-approval-requires-linked-po.md) | Permit **approval keeps requiring a linked PO**, except `TRAVEL_ANNUAL_PURPLE_PERMIT` (annual-vs-single, per 2026-06-18). Fouzan Shakil, `reference`; supersedes point 14 of the quote→project flow note for approval. Brian's confirmation still wanted |
| [decisions/2026-09-14-yard-unassigned-slots-not-loadable.md](decisions/2026-09-14-yard-unassigned-slots-not-loadable.md) | Unassigned asset/employee slots are not loadable; card warns; Mark Available disabled only when nothing is loadable; REQ-10 Partial Loadout is a label. Syed Haris, `reference`. **Q3 employees-as-loadable, Q7(a) copy, REQ-04 pre-tick superseded** by 2026-09-15 |
| [decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md](decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md) | Branch `fix/15-sep` **as built**: employees not loaded/offloaded; handover unchecked; yard lock hard-blocks save; steal of `ALLOCATED` even off ticket-sent; same-shift no stacking; Cancel Allocations; unbound tools; conversion travel linked to assets; vendor PO Done = CLOSED; Lovable letterhead. Ehtesham Anwar (PM), `reference` |
| [decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md) | The quotation carries **billing codes only**. Unit/People resources are dispatch-side and have **no billing code** (priced inside Operator/Support Load). The salesperson picks the resource type directly, with no unit-type step. Joe Schacatano (VP of Sales), recorded call, `verified`. **Conflicts with** the 2026-09-04 Always Included quotation note and the as-built quotation. Where the resource requirement is stored is still open |
| [decisions/2026-09-24-payroll-run-records-configuration-and-source-data-used.md](decisions/2026-09-24-payroll-run-records-configuration-and-source-data-used.md) | What a payroll run's "version" records (PAY-064 / FRD PR-052): the rates and settings in effect plus the ticket data used, not only an engine version. Syed Haris, PR #656 review, 2026-09-24 |
| [decisions/2026-09-24-payroll-failed-recalculation-keeps-last-good-run-and-blocks-approval.md](decisions/2026-09-24-payroll-failed-recalculation-keeps-last-good-run-and-blocks-approval.md) | After a failed recalculation: last good run shown with a warning, approve/export blocked until success or manager confirmation, failure logged. Departs from legacy. Syed Haris, PR #656 review, 2026-09-24 |
| [decisions/2026-09-30-sub-category-target-hours-per-month-whole-number-0-to-744.md](decisions/2026-09-30-sub-category-target-hours-per-month-whole-number-0-to-744.md) | Sub-category **Target Hours Per Month**: optional, whole number, 0–744 (24 x 31), validated on web (create + edit, as typed) and API (`@IsInt @Min(0) @Max(744)`). Syed Haris (CodingCops developer, `reference`), TCG-153 — not product; may be revisited. Does **not** settle the duplicate sub-category name question |
| [decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md](decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md) | **Provisional, on hold — not a ruling.** Melissa McNutt's written answers on holdover-day oiler workflow and paid time, and on late and incomplete tickets (24 h self-completion, then manager or payroll approval). TCG asked us on 2026-10-06 to hold for an updated version. `reference`; tensions with five verified notes listed |
| [decisions/2026-10-08-po-fee-typed-by-user-approval-leaves-po-alone.md](decisions/2026-10-08-po-fee-typed-by-user-approval-leaves-po-alone.md) | **PO Fee is typed by the user**: permit approval no longer writes it (Permit Cost and PO Fee stay separate) and leaves a `CLOSED` PO untouched (reopen to change); PO total = line items − discount, nothing computed. Create-time fee default not settled. Syed Haris (CodingCops, `reference`), TCG-89 |
| [decisions/2026-10-08-project-detail-selected-schedule-per-job.md](decisions/2026-10-08-project-detail-selected-schedule-per-job.md) | **Project Detail shows each job's selected schedule**: a "Selected Schedule" card, one row per job, with Job Duration Days, Selected Working Days and Selected Second Shifts computed exactly as the job's Schedule tab does (shared `summarizeScheduleEntries`). No project total. Umair Khan's confirmation of the UAT 4 #21 reading outstanding. Syed Haris (CodingCops, `reference`), TCG-101 |
| [quotations/mob-demob-current-rules.md](quotations/mob-demob-current-rules.md) | **Mob/Demob — current rules**: every rule from the notes below, with its status (client / ticket owner / CodingCops / interpretation). Start here for TCG-218 / TCG-220 |
| [decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md](decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md) | Mob/Demob on the quote: several billing codes rolled into one line, editable Mobilization quantity, Demob at 0, customer sees mob/demob/main items only, groups at the bottom, add mirrors to Demob (Joe Schacatano, `verified`); 2026-10-08 update: rename/delete mirror (ticket owner) |
| [decisions/2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md](decisions/2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md) | Operator Load is one billing code; its tractor/operator hidden on the quote **by default**, configurable (Joe, 2026-10-01 + 2026-10-07, `verified`); tractor/operator keep codes for one-offs; Certified Operator is its own code |
| [decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md](decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md) | Per-association Hourly Show and Mob/Demob Show + Main/Sub item, configurable from the front end (approved by Joe 2026-10-07, `verified`); the two Show settings independent (ticket owner) |
| [decisions/2026-10-06-employee-type-associations-start-hidden-on-the-quote.md](decisions/2026-10-06-employee-type-associations-start-hidden-on-the-quote.md) | Employee-type associations start hidden, can be ticked (Joe 2026-10-07, `verified`); backfill keeps saved quotes (ticket owner) |
| [decisions/2026-10-06-nested-association-quote-visibility-stored-per-parent.md](decisions/2026-10-06-nested-association-quote-visibility-stored-per-parent.md) | "Also brings along" rows carry the same settings, per parent, hidden by default — configurable (Joe 2026-10-07, `verified`); conflict with the 10-01 Operator Load note closed |
| [decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md](decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md) | Quotation Type Hourly / Hourly w/ Mob, once per quote; confirm before a row-changing switch; existing quotes Hourly (Syed Haris, ticket owner, `reference`) |
| [decisions/2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md](decisions/2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md) | Mobilization quantity = visits; lines per visit; amount = visits × summed lines (**client-confirmed by Joe, Teams, 2026-10-08**, `verified`, exchange quoted verbatim); Demob same, Mob/Demob only, adjustments × visits (ticket owner) |
| [decisions/2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md](decisions/2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md) | Two cranes on one job: one quote, a Mob/Demob per crane labelled with the crane, one invoice; options/phases are separate quotes under one project (Joe, 2026-10-07, `verified`) |
| [decisions/2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md](decisions/2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md) | Only the "Price Adjustment" item (FCC `PA`) is hand-priced inside Mob/Demob, may carry cents (Syed Haris, ticket owner, `reference`); supersedes 2026-10-07 any-custom-type |
| [decisions/2026-10-07-unbilled-custom-type-in-a-mob-demob-group-is-a-price-adjustment.md](decisions/2026-10-07-unbilled-custom-type-in-a-mob-demob-group-is-a-price-adjustment.md) | **Superseded** 2026-10-08 — any code-less custom line in a group was hand-priced |
| [decisions/2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md](decisions/2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md) | Equipment quoted only inside Mob/Demob goes out first and last day (Joe) and on every visit (ticket owner); Operator Load / Sub items the same — interpretation, not confirmed (`reference`) |
| [decisions/2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md](decisions/2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md) | TCG-218 question log: the ticket owner's answers Q1–Q31 (`reference`); show/hide is quote-only, every billable association is a DAS slot — **conflicts with 2026-09-12** |
| [decisions/2026-10-07-field-assets-configuration-tab-rename-and-activity-log.md](decisions/2026-10-07-field-assets-configuration-tab-rename-and-activity-log.md) | Sub-category tab renamed Field Assets Configuration, with its own activity log (ehtesham.anwar, CodingCops, `reference`) |
| [decisions/2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md](decisions/2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md) | **Invoices are built from whole days of a job, never from single tickets.** Every ticket that day is included. A day with a payroll-flagged ticket waits. Days are independent, and several can share an invoice. Brent Wagstaff (CFO), recorded call, `verified`; replaces the 10-08 "whole day or one ticket" design. Holdover cadence: see 2026-10-20 |
| [decisions/2026-10-20-holdovers-billed-weekly-or-monthly-other-jobs-daily-one-job-per-invoice.md](decisions/2026-10-20-holdovers-billed-weekly-or-monthly-other-jobs-daily-one-job-per-invoice.md) | **Holdovers are billed weekly; some customers want only monthly. All other jobs are billed daily. Typically one job per invoice / PO.** Melissa McNutt (President), written reply, `verified`. Contradicts the 10-13 "holdover invoiced once as a whole job" remark. What sets monthly, the billing week, "billed daily" and the exceptions are open (`accounting/gaps.md`) |
| [decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md](decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md) | **Collections worklist is per customer, not per invoice.** Brent Wagstaff (CFO), recorded call, `verified`. Promise-to-pay, weekly done/still-to-contact, the week selector and the 30-day entry are design, not decided |
| [decisions/2026-10-13-vendor-invoice-attachment-goes-to-quickbooks-with-the-bill.md](decisions/2026-10-13-vendor-invoice-attachment-goes-to-quickbooks-with-the-bill.md) | **The vendor's invoice document goes to QuickBooks with the vendor bill.** Brent Wagstaff (CFO), recorded call, `verified`. Whether the ERP keeps a copy, the vendor-documents customer setting and the bills-received blocker (proposed, **not agreed**) are open |

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
| [payroll/tcg-rawfms-staging-database/INDEX.md](payroll/tcg-rawfms-staging-database/INDEX.md) | **What do FCC's core tables really look like, and how does the legacy app copy them nightly?** `TCG_RawFMS` restored from the 2026-06-23 backup: 44 DDL files, 98 SQL objects, ticket-status matrix, every checklist question, the 52-bracket craft-modifier master | 14.7 |
| [payroll/legacy-payroll-app-db-backup-2026-06-23.md](payroll/legacy-payroll-app-db-backup-2026-06-23.md) | What state was the legacy app's database in on 2026-06-23? Code identical to the extract; pay periods, run logs, the *Refresh from NexGen* permission story | 7.2 |
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

| Module | Read first | Also holds *(page counts as of 2026-09-04, INDEX and gaps excluded)* |
| --- | --- | --- |
| `payroll/` | [payroll/INDEX.md](payroll/INDEX.md) | Payroll — separate migration, own caveats — 180 pages, gaps.md |
| `field-ops/` | [field-ops/INDEX.md](field-ops/INDEX.md) | The Atom field-worker mobile app · conflict stub — 112 pages, gaps.md |
| `quotations/` | [quotations/INDEX.md](quotations/INDEX.md) | Quotations, pricing, billing codes, mob/demob · conflict stub — 27 pages, gaps.md |
| `dispatch/` | [dispatch/INDEX.md](dispatch/INDEX.md) | DAS, scheduling, yard operations · conflict stub — 13 pages, gaps.md |
| `customers/` | [customers/INDEX.md](customers/INDEX.md) | Customers, customer contacts, job sites · conflict stub — 9 pages, gaps.md |
| `vendors-agencies/` | [vendors-agencies/INDEX.md](vendors-agencies/INDEX.md) | Vendors, agencies, purchase orders · conflict stub — 14 pages, gaps.md |
| `projects-jobs/` | [projects-jobs/INDEX.md](projects-jobs/INDEX.md) | Projects, jobs, plans, permits — 26 pages, gaps.md |
| `assets/` | [assets/INDEX.md](assets/INDEX.md) | Assets, yards-as-records, tools & rigging, categories — 12 pages, gaps.md |
| `accounting/` | [accounting/INDEX.md](accounting/INDEX.md) | Invoicing and accounting (module not yet built) — 13 pages, gaps.md |
| `admin/` | [admin/INDEX.md](admin/INDEX.md) | Auth, users, tenancy, settings, reference data — 11 pages, gaps.md |

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

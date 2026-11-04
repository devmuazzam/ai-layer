---
title: Vault structure standard — modules, tags, routing
status: reference
kind: standard
updated: 2026-08-24
tags: [kind/standard]
---

# Vault structure — how this vault is organized and how to find things

Adopted 2026-08-24. Two organizing dimensions, strictly divided:

- **Folders carry the module.** One folder per product module, mirroring the backend at
  product level. A file lives in exactly one folder.
- **Tags carry everything folders cannot.** A meeting spanning three modules, a decision
  touching two — multi-valued `module/` tags do what a single path cannot.

## Routing protocol — read this instead of grepping everywhere

Working a ticket:

1. Name the module(s) the ticket touches (table below maps BE folders → modules).
2. Read `vault/<module>/INDEX.md` — it routes to that module's sources, decisions,
   open questions, and the meetings that matter.
3. Need cross-cutting material? Search tags, not text:
   `grep -rl 'module/dispatch' vault/meetings/ vault/decisions/`
4. Only then fall back to full-text search.

## The modules

| Module | Backend usecase folders (rolled up) |
| --- | --- |
| `customers/` | customers, customer-contacts, job-site |
| `quotations/` | quotations, quotation-approvals/-signatures/-loss-reasons, billing-codes*, price-listings, surcharges, docusign |
| `projects-jobs/` | projects, jobs, sub-jobs, plans*, permits*, job-*-assignments, checklists |
| `dispatch/` | das, das-allocations, das-loadout, job-tickets |
| `field-ops/` | field-tickets, ticket-* (attachments, breakdowns, comments, incidents, lunch-breaks, signatures), pre-checklist, checklist-assignments |
| `assets/` | asset-management, parts, manufacturers, yards, categories, sub-category-substitutions |
| `vendors-agencies/` | vendors, agencies, purchase-orders |
| `payroll/` | employee*, departments, (payroll module when built) |
| `accounting/` | billing, expense-gl-accounts, invoicing (upcoming) |
| `admin/` | auth, users, permissions, tenant-companies, admin, email, geocoding, notifications, invitations, reference data (addresses, cities, states, countries, industries), seed |

Every module folder has the same skeleton (payroll/ is the model):

```
<module>/
  INDEX.md      ← router: what's here, what's settled, what's open, which decisions apply
  sources/…     ← migrated documents (only where volume warrants a subfolder)
  gaps.md       ← the module's open questions — exists from day one, see next section
  rules/        ← payroll only: the rule register (73 `PAY-###` rules, see payroll/rules/INDEX.md)
```

## Where a question goes — the gap system, un-retired

| The question… | Write it in |
| --- | --- |
| was raised by a ticket | `.ai/aidlc/SCRUM-###/spec.md` §12 — **unchanged** |
| belongs to a module, no ticket | `vault/<module>/gaps.md` — **this is the redesign the retired files were waiting for** |
| spans modules | the module most likely to **own the answer**; other modules' gaps.md get a one-line pointer to it |
| is about process, not product | still this conversation / a reflection — gaps.md files are product questions only |

Every module ships with a `gaps.md` from day one (created in phase 2, even if empty apart
from the header). Entry format is unchanged from the retired registers — a `##` heading per
question with a stable anchor, `- **Status:** open` / `answered`, sources cited — so the
existing sweep still works, now across modules:

```
grep -rn '^- \*\*Status:\*\* open' vault/*/gaps.md .ai/aidlc/[A-Z]*/spec.md
```

**Phase 3 landed 2026-08-24.** The retired registers' open entries were dispositioned into
module registers, each with a *From (frozen original)* backlink; closed/resolved entries stay
only in the frozen snapshots (`vault/gaps.md`, `vault/payroll/gaps-2026-08-20-retired.md` —
bannered, citable by anchor, never appended). Payroll's live register is `payroll/gaps.md`,
with `Rules: PAY-###` cross-links into `payroll/rules/`. Six root stub-summaries and three
meta-entries (sprint-7 dates, punch-list scoping, phased rollout) were left retired-only.

**Cross-cutting folders stay flat, tags route into them:**
`meetings/` (chronological — a meeting spans modules), `decisions/` (written by tcg-scrum;
one home even for cross-module decisions), `domain/` (process SOPs), `sync/` (infrastructure),
`uat/` (UAT sessions and their request register — a record of asks, not a spec source).

## Tags — Obsidian-native

Frontmatter key **`tags:`** (Obsidian indexes this key; the old `topics:` key was invisible
to it and is retired). Nested tags group in Obsidian's tag pane.

```yaml
tags: [module/payroll, module/field-ops, kind/transcript, wtl, subsistence]
```

Three facets:

1. **`module/<name>`** — one or more of the ten module names above. Every file gets at
   least one (cross-cutting files get all that apply; genuinely product-wide files get
   `module/all`).
2. **`kind/<name>`** — exactly one: `transcript` · `summary` · `discussion` · `frd` ·
   `user-stories` · `sop` · `decision` · `conflict-stub` · `source` · `standard` ·
   `sync-report` · `meeting-notes` · `gaps` · `rule` · `index` · `reference`.
3. **Bare subject tags** — from the closed vocabulary below. Add none rather than invent.

`status:` stays a plain frontmatter key (verified/unverified/reference/superseded), not a tag.
`entities:` is retired — existing values are harmless; do not add new ones.

### Subject vocabulary (closed — extend by editing this table)

| Tag | Absorbs (old topics) |
| --- | --- |
| adp | adp-integration, adp-api, adp-export, adp-code, adp |
| wtl | work-through-lunch, lunch-breaks, meal-period |
| craft-code | craft-codes |
| craft-modifier | boom-premium (modifier aspect) |
| boom | boom-time |
| subsistence | — |
| rest-period | rest-period-premium |
| shift-differential | — |
| overtime | ca-nonunion-ot |
| guaranteed-hours | — |
| fringe | fringe-benefits, trust-funds, contribution-rates |
| certified-payroll | labor-compliance, davis-bacon |
| union-agreement | l12-mla, union-rules, mcog |
| payroll-rules | payroll-rule |
| earning-codes | adp-code (earnings aspect), deduction-codes |
| time-tracking | time-reconstruction |
| ticket-workflow | — |
| inspections | deficiencies |
| signatures | — |
| safety | — |
| compliance | — |
| certifications | — |
| permits | — |
| lift-plans | — |
| scheduling | — |
| daily-allocation | — |
| yards | yard-operations |
| tools-rigging | — |
| mob-demob | mobilization |
| pricing | billing-codes, billing, pricing-engine, rates, wage-rates |
| invoicing | accounting-invoicing |
| purchase-orders | — |
| permissions-roles | roles-permissions, security-roles |
| authentication | — |
| notifications | — |
| integrations | integration, crm-integration, webhooks, api, api-contract |
| geolocation | — |
| offline | offline-reliability |
| reporting | dashboard |
| reference-data | code-list, code-lists, validation-tables, glossary, terminology |
| data-migration | migration, employee-data, employee-master |
| requirements | requirements-spec, acceptance-criteria, user-stories (as subject) |
| sprint-planning | sprint-planning, erp-sprint-review, scrum-process, sprint |
| open-questions | open-decisions |
| architecture | data-model, data-flow, database, sql-first, sql-objects |
| provenance | source-file, source-attribution, source-manifest, source-data, contract-source |
| holidays | — |
| per-diem | — |
| legacy-payroll-app | payroll-app, legacy-process, current-state |

Everything else in the old 173-tag vocabulary is dropped (singletons, template leakage,
module names now carried by `module/`).

## Reference integrity

Moves are `git mv` (history preserved). Every move rewrites all references in the same
commit: `conflicts_with:` lists, `[[wikilinks]]`, relative markdown links, `gaps.md`
citations, `sync/manifest.json` vaultPaths. A dangling-reference check runs before commit.
The migration map below is the permanent redirect table for anything missed.

---

# Appendix — migration map, 2026-08-24 (product/ → modules)

| From | To |
| --- | --- |
| customers/customer.md | customers/customer.md |
| customers/customer-and-job-sites.md | customers/customer-and-job-sites.md |
| customers/customers-INDEX.md | customers/customers-INDEX.md *(conflict stub — linked from customers/INDEX.md)* |
| quotations/quotation.md | quotations/quotation.md |
| quotations/quotations.md | quotations/quotations.md |
| quotations/quotation-flow-process.md | quotations/quotation-flow-process.md |
| quotations/quotations-INDEX.md | quotations/quotations-INDEX.md *(stub)* |
| quotations/billing-code-and-price-list.md | quotations/billing-code-and-price-list.md |
| quotations/mobilization-and-demobilization.md | quotations/mobilization-and-demobilization.md |
| quotations/mob-demob-INDEX.md | quotations/mob-demob-INDEX.md *(conflict stub)* |
| projects-jobs/project-module/ (9 files) | projects-jobs/project-module/ |
| projects-jobs/job-project-das.md | projects-jobs/job-project-das.md *(tags: module/dispatch too)* |
| dispatch/daily-allocation-system.md | dispatch/daily-allocation-system.md |
| dispatch/daily-allocation-INDEX.md | dispatch/daily-allocation-INDEX.md *(stub)* |
| dispatch/dispatcher-needs.md | dispatch/dispatcher-needs.md |
| dispatch/yard-operations-jz.md | dispatch/yard-operations-jz.md *(operational; yards-as-entities → assets)* |
| field-ops/atom-mobile-app-user-stories/ (8 files) | field-ops/atom-mobile-app-user-stories/ |
| field-ops/field-ops-frd/ (12 files) | field-ops/field-ops-frd/ |
| field-ops/frd-new-format-draft/ (9 files) | field-ops/frd-new-format-draft/ |
| field-ops/field-ops-mobile-INDEX.md | field-ops/field-ops-mobile-INDEX.md *(stub)* |
| field-ops/fr-fop-numbering.md | field-ops/fr-fop-numbering.md |
| assets/categories-and-sub-categories.md | assets/categories-and-sub-categories.md |
| assets/tool-and-rigging.md | assets/tool-and-rigging.md |
| assets/user-story-and-tasks.md | assets/user-story-and-tasks.md *(yard document mgmt / yard org profile)* |
| vendors-agencies/agencies.md | vendors-agencies/agencies.md |
| vendors-agencies/agencies-module.md | vendors-agencies/agencies-module.md |
| vendors-agencies/agency-and-vendor.md | vendors-agencies/agency-and-vendor.md |
| vendors-agencies/vendors.md | vendors-agencies/vendors.md |
| vendors-agencies/agencies-vendors-INDEX.md | vendors-agencies/agencies-vendors-INDEX.md *(stub)* |
| vendors-agencies/purchase-order.md | vendors-agencies/purchase-order.md |
| meetings/2026-06-26-discussion-points-with-mohsin.md | meetings/2026-06-26-discussion-points-with-mohsin.md *(kind/discussion)* |
| meetings/2026-06-26-discussion-points-with-tcg-team.md | meetings/2026-06-26-discussion-points-with-tcg-team.md *(kind/discussion)* |
| meetings/2026-06-22-sprint-4-additional.md | meetings/2026-06-22-sprint-4-additional.md |
| brs.md | brs.md *(vault root — product-wide, module/all)* |
| admin/tcg-documents.md | admin/tcg-documents.md *(verify on read; move stands unless content contradicts)* |
| assets/user-story-and-tasks.md — personal-space page | *(see assets row above)* |

New folders created empty except INDEX.md: `accounting/` (no migrated sources yet — its
INDEX points at tagged meetings), `admin/`. `product/` is deleted once empty.

Root `gaps.md` and `payroll/gaps.md` stay retired and in place (anchors citable). Every
module folder gets its live `gaps.md` **in phase 2** (payroll: `gaps-live.md`, renamed in
phase 3 — see *Where a question goes*); phase 3 dispositions the 74 retired entries into them.

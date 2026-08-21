---
title: Archive replaces delete, app-wide — decision
source: decision/Fouzan Shakil
decided: 2026-08-20
decided_by: Fouzan Shakil (developer on TCG, assignee on SCRUM-896's branch) — stated directly in chat on 2026-08-20, against `SCRUM-896/spec.md` §12 Q1. He is not the client-side product owner; `spec.md` §12 Q1 nominated "product team (named product owner — not QA)" as owner. This is therefore an internal engineering-and-product convention decided by a named person on the team, binding on implementation now, and open to being overruled by the client if they say otherwise. `status: reference` rather than `verified` for that reason, matching `decisions/2026-08-20-quantity-based-das-sets.md`.
status: reference
conflicts_with: []
resolves: SCRUM-896/spec.md#q1
jira: [SCRUM-896]
topics: [navigation-ui, requirements-spec, lift-plans, customers, vendors, tools-rigging]
entities: [lift-plan, customer, vendor, tool-rigging]
---

## Decision

**Everything should be archivable instead of deletable, like other entities already have.**

Those are Fouzan Shakil's words on 2026-08-20. Two things follow directly and nothing else does:

1. Archive is the entity-removal action across the app, not delete. Where a user today
   removes a record, the action becomes archive.
2. The pattern is the one already in the codebase, not a new one — the `archivedAt`
   soft-delete carried by 17 Prisma models today (verified 2026-08-20 by
   `awk '/^model /{m=$2} /archivedAt/{print m}' apps/api/prisma/schema.prisma | sort -u`).
   "Like other entities already have" is the whole of the design guidance given.

This settles the scope question `SCRUM-896` raised: the claim *"across the app we are
replacing delete functionality with archive"* is **app-wide, not plan-only**. `Plan` is
in scope precisely because it is one of the entities that does not yet have what the
others do.

## Why

The clause existed only on a QA ticket (`SCRUM-896`, reported by Aiman Farooq), and a QA
ticket is not a product decision — which is why the spec stopped and asked rather than
building against it. `spec.md` §12 Q1 records the evidence on both sides: `product/customer.md`
item 11 asks for an archived quick filter "**(across the app)**" while `product/vendors.md`
and `product/tool-and-rigging.md` still specify Delete icons, and no vault file mentions plan
deletion or plan archiving at all. Nothing written could settle it, so a person had to.

The reason to record the *pattern* and not just the verdict: "like other entities already
have" is the load-bearing half of the sentence. It means the next module does not get to
invent a second archive mechanism — a status enum, a `deletedAt`, a separate archive
table — and it means the answer to "how should archive behave here?" is "read one of the
17".

## What this does NOT settle

Recorded explicitly so that nobody reads a broader mandate out of one sentence. Each of
these is **still open** and none of them was answered:

- **Whether the `DELETE` endpoints stay.** Fouzan spoke about what users can do, not about
  the API surface. Whether `DELETE /plans/:planId` and its siblings are withdrawn, kept for
  internal use, or repurposed to archive is undecided.
- **Whether an admin hard-delete escape hatch exists**, and who would hold it. Not raised,
  not answered. Do not build one and do not assume its absence.
- **What "everything" includes at the sub-record level** — notes, contacts, attachments,
  job-site rows, custom-attribute rows. `product/customer.md` item 20 currently specifies
  edit **and delete** on individual note/contact/job-site/attachment records. Whether those
  are "entities" under this decision, or child rows outside it, was not asked.
- **Retention, permissions and reversal** — who may archive, who may unarchive, whether
  archived records are ever purged, and what an archived record still participates in
  (search, reports, references from live records).
- **Sequencing and backfill** — which modules convert first, and what happens to rows
  already hard-deleted. Nothing here authorises a data migration beyond adding the column.

## Effect on the vault

- **No winner/loser flip applies.** This is not a conflict set between vault documents.
  No vault file specifies plan deletion or plan archiving, and the delete text that does
  exist (`product/vendors.md` lines 24, 66–67, 86; `product/tool-and-rigging.md` line 22)
  is a **line inside an otherwise unaffected file**, not a rival specification of this
  question. Marking those whole files `superseded` would be wrong and would lose the rest
  of their content. No `status:`, `superseded_by:` or `conflicts_with:` field changes on
  any product file.
- **Residual tension, left open deliberately:** those Delete-icon lines in
  `product/vendors.md` and `product/tool-and-rigging.md` now contradict this decision at
  the line level. Both files remain `status: unverified`. They are not corrected here —
  editing a vault body is outside this agent's access, and the correction is content work
  for whoever owns those pages.
- `vault/gaps.md#feedback-punch-lists-are-not-scoped-to-the-module-they-are-filed-under`
  is **not** closed by this. Its question is structural — whether cross-module punch lists
  should be split by module — and remains open. Only its SCRUM-896 sub-note is now answered,
  via `spec.md` §12.
- `.ai/aidlc/SCRUM-896/spec.md` §12 Q1 → `Status: resolved — see this note`.

## Effect on SCRUM-896

Q1 is answered in the direction the ticket asked for, which means **the branch as it stands
does not yet meet the ticket's goal**. What the answer now authorises, none of which is built:

- `Plan.archivedAt` — a nullable timestamp matching the 17 existing models, plus the migration.
- Archive / unarchive on plans, and an archived quick filter on the project Plans tab.
- Removing the hard-delete control from the plan **edit** page (the listing's row and bulk
  delete are already gone on branch `scrum-896`).
- `DELETE /plans/:planId` — **still undecided**, see *What this does not settle*. It is a hard
  delete today. Nothing here says to remove it, and nothing here says to keep it.

The workaround recorded in Q1 is no longer a workaround for the *scope* question, but the
ship remains partial until the archive work above lands.

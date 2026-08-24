# Reflections index — the loop's memory across tickets

One line per defect per ticket. Append-only.

This exists so that **"has this happened before?" is a grep, not a re-read.** The
third-occurrence rule is the most valuable thing the reflector does and the first thing to
stop working at scale: it originally required reading every earlier
`SCRUM-*/reflection.md`, which is a linear scan that is free at two tickets, tedious at ten,
and quietly skipped at thirty — precisely when recurrence starts to matter.

It is also the **queue for proposed rule changes**. The reflector proposes and cannot apply;
without a queue, an accepted proposal and an ignored one look identical a week later. The
`Status` column is what distinguishes them.

## How to use it

**Before writing a reflection** — for each defect, grep the class:

```bash
grep -i 'invented-value' .ai/aidlc/reflections/INDEX.md
```

Three or more prior lines in the same class means this defect is **at its third occurrence**
and §4 of the reflector applies: escalate structurally, and say why the previous fix did not
hold.

**After writing a reflection** — append one row per defect recorded in §1 and §2 of that
reflection. Never edit or delete an existing row; a defect that turned out to be a
non-issue gets a new row with `Status: withdrawn` and a note, because the fact that it was
raised is itself data about where the loop is noisy.

**When you apply a rule change**, edit only that row's `Status` to `applied` and add the
date. That edit is the exception to append-only, and it is the whole point of the column.

## Columns

| Column | Meaning |
| --- | --- |
| `Date` | The date the reflection was written, `YYYY-MM-DD` |
| `Ticket` | `SCRUM-###` |
| `ID` | The defect id inside that reflection — `SD-1`, `ED-2` |
| `Class` | From the vocabulary below. **The grep key** — free text here breaks the count |
| `Defect` | One line. What went wrong, attributed to an artifact, never to a person |
| `Proposal` | The file and section the rule change targets, or `none` |
| `Status` | `open` · `proposed` · `applied` · `escalated` · `withdrawn` |

## Class vocabulary

Controlled on purpose. A class invented per ticket never reaches three occurrences, so the
escalation rule silently stops firing — which is the same failure this index exists to
prevent, one level up.

| Class | The defect |
| --- | --- |
| `invented-value` | A concrete value in the diff that traces to no requirement — length, default, page size, timeout, sort order, error copy |
| `missing-requirement` | The spec was silent on something the build could not proceed without |
| `open-built-anyway` | An `[OPEN]` requirement was resolved during the build instead of stopping |
| `unverified-permanent` | An `[UNVERIFIED]` source made expensive to reverse — a one-way migration, a backfill, an enum, a response shape |
| `unit-not-vertical` | A unit shipped that could not be demonstrated alone — a layer split |
| `duplicate-component` | Something was created that already existed in one of the nine `components/` directories |
| `layer-violation` | An upward import, or any module-boundary breach |
| `hardcoded-colour` | A literal colour where a theme variable exists |
| `contract-drift` | A DTO or response shape moved without tracing web and mobile callers |
| `tenancy-gap` | A model holding tenant data outside the scoping allowlist, or isolation not checked |
| `gate-illusion` | Lint and build passed while a documented convention was violated |
| `doc-conflict` | Two loaded instruction files stated contradictory things |
| `stale-reference` | A path, count, or fact in the AI layer that no longer resolves |

**Adding a class is allowed and sometimes correct** — this list was written from the defects
this codebase had already documented, not from a complete theory of what can go wrong. If
you add one, add its row to this table in the same commit and say so in the reflection.
An undocumented class is indistinguishable from a typo in an existing one.

---

## Index

| Date | Ticket | ID | Class | Defect | Proposal | Status |
| --- | --- | --- | --- | --- | --- | --- |
| 2026-08-24 | SCRUM-877 | SD-1 | missing-requirement | Stale labor hours when ticket work timestamps update post-labor entry | `.ai/claude/contexts/api.md` | applied |
| 2026-08-24 | SCRUM-877 | SD-2 | missing-requirement | Dynamic crane main boom length bracket suggestion fallback to No Pay | none | applied |
| 2026-08-24 | SCRUM-877 | ED-1 | tenancy-gap | Prisma scoping allowlist conflict on rebase | `apps/api/src/orm/prisma.service.ts` | applied |
| 2026-08-24 | SCRUM-877 | ED-2 | contract-drift | Asset numeric DTO validation broken for Web asset form inputs | `apps/api/.../create-asset.dto.ts` | applied |

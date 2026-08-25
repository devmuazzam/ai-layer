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
| `refactor-untested` | A refactor or extraction changed the behaviour of existing, already-shipped code, but the unit's test plan required coverage only for the new call site, leaving the existing consumer unverified — added `2026-08-25` by the SCRUM-900 reflection |
| `contradicted-source` | Built behaviour contradicts a specific, findable, already-`[VERIFIED]` source (a decision note, a rule doc, or an existing sibling implementation of the same rule) that was not consulted before writing new code for the same rule — distinct from `unverified-permanent`, whose source was never verified in the first place; added `2026-08-26` by the SCRUM-926 reflection |

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
| 2026-08-25 | SCRUM-900 | SD-1 | refactor-untested | `units.md` asked for `isScheduleDayClosed` extraction but not for regression coverage of `findToolIdsBlockedFromArchive`, its pre-existing (still untested) consumer | `.ai/aidlc/agents/inception/tcg-decomposer.md` | proposed |
| 2026-08-25 | SCRUM-900 | ED-1 | gate-illusion | `dasStage` widened to `string` instead of Prisma's `SubJobStage` enum; test fixture uses `'IN_PROGRESS'`, not a real enum member | `.ai/claude/contexts/prisma.md` §Conventions | proposed |
| 2026-08-25 | SCRUM-900 | ED-2 | gate-illusion | `units.md`'s promised integration test for the utilization endpoint was not built; unit still reported complete | `.ai/aidlc/agents/construction/tcg-executor.md` §Output shape | proposed |
| 2026-08-25 | SCRUM-900 | ED-3 | stale-reference | `units.md` records `built — c0e8d227`, a SHA that does not exist on the platform repo after rebase/squash (actual tip `37c4a554`) | `.ai/aidlc/templates/units.md` — Status column fill rule | proposed |
| 2026-08-25 | SCRUM-817 | SD-1 | contract-drift | RecipientSpec employee payload shape mapping in NotificationService call | `.ai/claude/contexts/api.md` | applied |
| 2026-08-25 | SCRUM-817 | ED-1 | test-mock-drift | NotificationService missing from DasAllocationsService unit test setup | none | applied |
| 2026-08-26 | SCRUM-926 | SD-1 | doc-conflict | `spec.md` REQ-08 quotes `SCRUM-935` as excluding off-list secondary-craft rejection from the resolver; the live ticket text changed after and now requires it, and the spec was never re-diffed against it | `.ai/aidlc/agents/inception/tcg-elaborator.md` | proposed |
| 2026-08-26 | SCRUM-926 | SD-2 | doc-conflict | `spec.md` REQ-07's acceptance line ("updating one that has none is rejected") contradicts its own executor note ("continues to load, save and appear in lists") in the same requirement block | `.ai/aidlc/agents/inception/tcg-elaborator.md` | proposed |
| 2026-08-26 | SCRUM-926 | ED-1 | contradicted-source | Boom-adder resolver returns null/$0 on missing-range and empty-cell cases a `[VERIFIED]` 2026-08-21 decision already resolved, and RESOLVED-with-null instead of BLOCKED on an empty modifier table against REQ-18 — the correct fallback was already shipped in a sibling `packages/shared` file | `.ai/aidlc/agents/construction/tcg-executor.md` §3 | proposed |
| 2026-08-26 | SCRUM-926 | ED-2 | unverified-permanent | U2 (SCRUM-934) shipped a persisted, admin-editable `CraftModifier` bracket table with a generator endpoint instead of REQ-11/12/13/14/16's specified pure-function, nothing-persisted `CraftModifierScale` — no commit, spec line, or decision note records the substitution | `.ai/claude/contexts/prisma.md` §Migrations | proposed |
| 2026-08-26 | SCRUM-926 | ED-3 | stale-reference | `CraftCode.startDate`/`endDate` (REQ-06, `units.md` U1) were added then dropped two migrations later on the same branch; `spec.md`/`units.md` still describe the fields and U1's own demo line now 400s instead of 201s | `.ai/claude/contexts/prisma.md` §Migrations | proposed |
| 2026-08-26 | SCRUM-926 | ED-4 | gate-illusion | `spec.md`/`units.md` for all 5 tickets in this epic stayed off the vault overlay through merge; `commit`/`close-ticket` never ran; `processed.log` rows were backfilled post-merge; CI checks lint/build/test only, nothing about `.ai/aidlc/` state — **3rd occurrence, escalated** | `.github/workflows/affected.yml`; `.ai/claude/skills/close-ticket/SKILL.md` §6 | escalated |
| 2026-08-26 | SCRUM-926 | ED-5 | gate-illusion | ~2,100 lines / 51 files of `apps/web` shipped against four ticket sources and `spec.md` §5/§6 all stating backend-only, with no PR description or decision note acknowledging the scope change | `.ai/claude/contexts/web.md` | proposed |

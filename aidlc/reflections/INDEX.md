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
| `duplicated-logic` | The same domain computation, mapping, or taxonomy is implemented independently in two or more places instead of extracted once, and the copies diverge in behaviour — added `2026-09-10` by the SCRUM-252 reflection |
| `unverified-stale` | An `[UNVERIFIED]` vault source was built against as-is, without reverification, and proved wrong or outdated when checked — distinct from `unverified-permanent`, which tracks irreversibility rather than accuracy; added `2026-09-10` by the SCRUM-252 reflection |

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
| 2026-08-25 | SCRUM-900 | SD-1 | refactor-untested | `units.md` asked for `isScheduleDayClosed` extraction but not for regression coverage of `findToolIdsBlockedFromArchive`, its pre-existing (still untested) consumer | `.ai/aidlc/agents/inception/tcg-decomposer.md` | applied 2026-08-28 |
| 2026-08-25 | SCRUM-900 | ED-1 | gate-illusion | `dasStage` widened to `string` instead of Prisma's `SubJobStage` enum; test fixture uses `'IN_PROGRESS'`, not a real enum member | `.ai/claude/contexts/prisma.md` §Conventions | proposed |
| 2026-08-25 | SCRUM-900 | ED-2 | gate-illusion | `units.md`'s promised integration test for the utilization endpoint was not built; unit still reported complete | `.ai/aidlc/agents/construction/tcg-executor.md` §Output shape | proposed |
| 2026-08-25 | SCRUM-900 | ED-3 | stale-reference | `units.md` records `built — c0e8d227`, a SHA that does not exist on the platform repo after rebase/squash (actual tip `37c4a554`) | `.ai/aidlc/templates/units.md` — Status column fill rule | proposed |
| 2026-08-25 | SCRUM-817 | SD-1 | contract-drift | RecipientSpec employee payload shape mapping in NotificationService call | `.ai/claude/contexts/api.md` | applied |
| 2026-08-25 | SCRUM-817 | ED-1 | test-mock-drift | NotificationService missing from DasAllocationsService unit test setup | none | applied |
| 2026-08-26 | SCRUM-926 | SD-1 | doc-conflict | `spec.md` REQ-08 quotes `SCRUM-935` as excluding off-list secondary-craft rejection from the resolver; the live ticket text changed after and now requires it, and the spec was never re-diffed against it | `.ai/aidlc/agents/inception/tcg-elaborator.md` | applied |
| 2026-08-26 | SCRUM-926 | SD-2 | doc-conflict | `spec.md` REQ-07's acceptance line ("updating one that has none is rejected") contradicts its own executor note ("continues to load, save and appear in lists") in the same requirement block | `.ai/aidlc/agents/inception/tcg-elaborator.md` | applied |
| 2026-08-26 | SCRUM-926 | ED-1 | contradicted-source | Boom-adder resolver returns null/$0 on missing-range and empty-cell cases a `[VERIFIED]` 2026-08-21 decision already resolved, and RESOLVED-with-null instead of BLOCKED on an empty modifier table against REQ-18 — the correct fallback was already shipped in a sibling `packages/shared` file | `.ai/aidlc/agents/construction/tcg-executor.md` §3 | applied |
| 2026-08-26 | SCRUM-926 | ED-2 | unverified-permanent | U2 (SCRUM-934) shipped a persisted, admin-editable `CraftModifier` bracket table with a generator endpoint instead of REQ-11/12/13/14/16's specified pure-function, nothing-persisted `CraftModifierScale` — no commit, spec line, or decision note records the substitution | `.ai/claude/contexts/prisma.md` §Migrations | applied |
| 2026-08-26 | SCRUM-926 | ED-3 | stale-reference | `CraftCode.startDate`/`endDate` (REQ-06, `units.md` U1) were added then dropped two migrations later on the same branch; `spec.md`/`units.md` still describe the fields and U1's own demo line now 400s instead of 201s | `.ai/claude/contexts/prisma.md` §Migrations | applied |
| 2026-08-26 | SCRUM-926 | ED-4 | gate-illusion | `spec.md`/`units.md` for all 5 tickets in this epic stayed off the vault overlay through merge; `commit`/`close-ticket` never ran; `processed.log` rows were backfilled post-merge; CI checks lint/build/test only, nothing about `.ai/aidlc/` state — **3rd occurrence, escalated** | `.github/workflows/affected.yml`; `.ai/claude/skills/close-ticket/SKILL.md` §6 | applied |
| 2026-08-26 | SCRUM-926 | ED-5 | gate-illusion | ~2,100 lines / 51 files of `apps/web` shipped against four ticket sources and `spec.md` §5/§6 all stating backend-only, with no PR description or decision note acknowledging the scope change | `.ai/claude/contexts/web.md` | applied |
| 2026-09-10 | SCRUM-252 | SD-1 | unverified-stale | Sole written source for the whole feature (`dispatch/daily-allocation-system.md` → Live Asset Map View, `status: unverified`, 2026-04-30) was built against without reverification; 3 of 7 acceptance criteria proved wrong or stale, discovered only at PR review | `.ai/aidlc/agents/inception/tcg-elaborator.md` | proposed |
| 2026-09-10 | SCRUM-252 | SD-2 | contradicted-source | DAS map's `shiftInstant` implicitly assumes a shift never crosses midnight, contradicting a `[VERIFIED]` decision note that presumes cross-midnight shifts exist and two already-shipped modules that already treat `end < start` as legitimate; unit reads "Completed" while a shift is in progress — live, unfixed | `.ai/aidlc/agents/construction/tcg-executor.md` §3 | proposed |
| 2026-09-10 | SCRUM-252 | SD-3 | missing-requirement | Nothing written defines `isActive` on a job-schedule interval; the new DAS map query and the existing jobs-board query silently disagree on whether to filter by it — caught by the developer, not by any written rule — 3rd occurrence, escalated | `.ai/claude/contexts/prisma.md` §Conventions | proposed |
| 2026-09-10 | SCRUM-252 | SD-4 | missing-requirement | No written rule states a Samsara feed fetch must stay id-filtered to bound cost; the invariant lived only as an unstated property of `useVehicles`'s parameter, and a retry path violated it, caught only in review — second instance of this reflection's own escalation | `.ai/claude/contexts/web.md` | proposed |
| 2026-09-10 | SCRUM-252 | ED-1 | gate-illusion | Branch shipped 57 files as PR 522 with no `.ai/aidlc/SCRUM-252/` folder, no `processed.log` row, and none of elaborator/decomposer/units/executor ever ran; discovered three review rounds in. The CI ledger check applied at SCRUM-926 ED-4 for exactly this did not fire — soft-warns instead of failing because `AI_LAYER_DEPLOY_KEY` was never provisioned, and its case-sensitive branch regex would not have matched this branch's actual name (`scrum-252`) even with the secret present — 5th occurrence, escalated | `.github/workflows/affected.yml` (AI-DLC ledger check step) | proposed |
| 2026-09-10 | SCRUM-252 | ED-2 | duplicated-logic | `das-map.service.ts` and `map-das-job-to-dylen-card.ts` independently reimplement the `SubJobStage` → display-bucket mapping; a code comment in one asserts the two can never disagree, and they did — `CANCELLED` fell through to `pending-loadout` on the Yard Ops board | `.ai/aidlc/agents/construction/tcg-executor.md` §3 | proposed |
| 2026-09-10 | SCRUM-252 | ED-3 | duplicated-logic | `DasService` and `DasMapService` each carry a private copy of `resolveDate` that differs on empty-string handling — second instance of the same defect class within this one ticket | `.ai/aidlc/agents/construction/tcg-executor.md` §3 | proposed |
| 2026-09-10 | SCRUM-252 | ED-4 | refactor-untested | `TruckMarker`'s rewrite, shared with the existing vehicle-tracking map, silently dropped that screen's brand-coloured selection ring; not in ticket scope, not tested, not mentioned in the diff | `.ai/aidlc/agents/construction/tcg-executor.md` §4 | proposed |
| 2026-09-10 | SCRUM-252 | ED-5 | stale-reference | `spec.md` §0 and §13 cite "`CLAUDE.md` → *Vehicle tracking (Samsara)*" twice as a consulted/existing rule source; no such section exists in any `CLAUDE.md` in the repository — fabricated, not merely stale — 3rd occurrence, escalated | `.ai/claude/contexts/web.md` (new §Vehicle tracking) | proposed |
| 2026-09-14 | SCRUM-LOADOUT-UNASSIGNED | SD-1 | stale-reference | `spec.md` REQ-03's Ripple field cites its own grep result as proof `loadout-workflow-utils.ts`'s helpers are "the existing single gate," when that same grep result (matches only inside the helpers' own definition file) shows the opposite — they are dead code; caught and corrected by the decomposer in `units.md` before build — 4th occurrence | `.ai/aidlc/agents/inception/tcg-elaborator.md` | proposed |
| 2026-09-14 | SCRUM-LOADOUT-UNASSIGNED | ED-1 | gate-illusion | REQ-10 (Partial Loadout) was added to `spec.md` mid-build but never given a unit in `units.md`; shipped (`fcf499dbe`) with no slice-contents, risk, ripple or test row, while `units.md`'s own ledger still claims "all 9 requirements... covered" — 6th occurrence, escalated | `.ai/aidlc/templates/units.md` | proposed |
| 2026-09-14 | SCRUM-LOADOUT-UNASSIGNED | ED-2 | gate-illusion | Two commits merged in PR #571 (`c01ba4103` realtime emit, `575ca630c` photo-loader/stale-thumb fix) carry no REQ or unit reference anywhere in `spec.md`/`units.md`, unlike a third extra commit in the same PR that a concurrent vault sweep did trace back — 7th occurrence, escalated | `.ai/claude/skills/commit/SKILL.md` | proposed |

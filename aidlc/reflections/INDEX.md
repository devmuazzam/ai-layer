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
| `undecided-structure` | A table, column, enum member, relation, exported function/service, endpoint or dependency shipped with no developer recorded as having chosen it (`spec.md` §11b or the PR's _Developer decisions_) — the AI or whoever was typing decided; added `2026-10-09` by Haris |
| `over-built` | Structure beyond what the requirement needed — a one-to-one table with no history, a child repeating its parent's key, a persisted table where a function was specified, a model duplicating an existing one, a speculative field. Distinct from `undecided-structure`: this one can be decided and still be over-built; added `2026-10-09` by Haris |
| `pattern-drift` | A recurring shape (`.ai/claude/contexts/patterns.md`) built differently from its reference, or a change made to one instance and never offered to its siblings, so instances of the same job now behave or are built differently; added `2026-10-09` by Haris |
| `branch-ops` | A git or PR operation landed work on the wrong base or disturbed the developer's running checkout — a stacked PR merged into or opened against a base that is not `main`, or a branch created in the primary checkout under a live dev server; distinct from `pattern-drift`/`gate-illusion`, which describe the diff, not the branch it travelled on; added `2026-10-17` by the TCG-218 reflection |
| `over-broad-condition` | A rule, guard or effect built to fire on a wider set than the spec's qualifier (all flows instead of STANDARD, any request kind instead of one, all steps instead of the sequential ones), found by review and not by tests; added `2026-10-19` by the TICKET-FLOW-SLOTS-HOLDOVER reflection |

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
| 2026-08-25 | SCRUM-900 | ED-1 | gate-illusion | `dasStage` widened to `string` instead of Prisma's `SubJobStage` enum; test fixture uses `'IN_PROGRESS'`, not a real enum member | `.ai/claude/contexts/prisma.md` §Conventions | applied 2026-10-20 |
| 2026-08-25 | SCRUM-900 | ED-2 | gate-illusion | `units.md`'s promised integration test for the utilization endpoint was not built; unit still reported complete | `.ai/aidlc/agents/construction/tcg-executor.md` §Output shape | applied 2026-10-20 |
| 2026-08-25 | SCRUM-900 | ED-3 | stale-reference | `units.md` records `built — c0e8d227`, a SHA that does not exist on the platform repo after rebase/squash (actual tip `37c4a554`) | `.ai/aidlc/templates/units.md` — Status column fill rule | applied 2026-10-20 |
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
| 2026-09-10 | SCRUM-252 | SD-2 | contradicted-source | DAS map's `shiftInstant` implicitly assumes a shift never crosses midnight, contradicting a `[VERIFIED]` decision note that presumes cross-midnight shifts exist and two already-shipped modules that already treat `end < start` as legitimate; unit reads "Completed" while a shift is in progress — live, unfixed | `.ai/aidlc/agents/construction/tcg-executor.md` §3 | applied 2026-10-20 |
| 2026-09-10 | SCRUM-252 | SD-3 | missing-requirement | Nothing written defines `isActive` on a job-schedule interval; the new DAS map query and the existing jobs-board query silently disagree on whether to filter by it — caught by the developer, not by any written rule — 3rd occurrence, escalated | `.ai/claude/contexts/prisma.md` §Conventions | applied 2026-10-20 |
| 2026-09-10 | SCRUM-252 | SD-4 | missing-requirement | No written rule states a Samsara feed fetch must stay id-filtered to bound cost; the invariant lived only as an unstated property of `useVehicles`'s parameter, and a retry path violated it, caught only in review — second instance of this reflection's own escalation | `.ai/claude/contexts/web.md` | applied 2026-10-20 |
| 2026-09-10 | SCRUM-252 | ED-1 | gate-illusion | Branch shipped 57 files as PR 522 with no `.ai/aidlc/SCRUM-252/` folder, no `processed.log` row, and none of elaborator/decomposer/units/executor ever ran; discovered three review rounds in. The CI ledger check applied at SCRUM-926 ED-4 for exactly this did not fire — soft-warns instead of failing because `AI_LAYER_DEPLOY_KEY` was never provisioned, and its case-sensitive branch regex would not have matched this branch's actual name (`scrum-252`) even with the secret present — 5th occurrence, escalated | `.github/workflows/affected.yml` (AI-DLC ledger check step) | proposed |
| 2026-09-10 | SCRUM-252 | ED-2 | duplicated-logic | `das-map.service.ts` and `map-das-job-to-dylen-card.ts` independently reimplement the `SubJobStage` → display-bucket mapping; a code comment in one asserts the two can never disagree, and they did — `CANCELLED` fell through to `pending-loadout` on the Yard Ops board | `.ai/aidlc/agents/construction/tcg-executor.md` §3 | applied 2026-10-20 |
| 2026-09-10 | SCRUM-252 | ED-3 | duplicated-logic | `DasService` and `DasMapService` each carry a private copy of `resolveDate` that differs on empty-string handling — second instance of the same defect class within this one ticket | `.ai/aidlc/agents/construction/tcg-executor.md` §3 | applied 2026-10-20 |
| 2026-09-10 | SCRUM-252 | ED-4 | refactor-untested | `TruckMarker`'s rewrite, shared with the existing vehicle-tracking map, silently dropped that screen's brand-coloured selection ring; not in ticket scope, not tested, not mentioned in the diff | `.ai/aidlc/agents/construction/tcg-executor.md` §4 | applied 2026-10-20 |
| 2026-09-10 | SCRUM-252 | ED-5 | stale-reference | `spec.md` §0 and §13 cite "`CLAUDE.md` → *Vehicle tracking (Samsara)*" twice as a consulted/existing rule source; no such section exists in any `CLAUDE.md` in the repository — fabricated, not merely stale — 3rd occurrence, escalated | `.ai/claude/contexts/web.md` (new §Vehicle tracking) | applied 2026-10-20 |
| 2026-09-14 | SCRUM-LOADOUT-UNASSIGNED | SD-1 | stale-reference | `spec.md` REQ-03's Ripple field cites its own grep result as proof `loadout-workflow-utils.ts`'s helpers are "the existing single gate," when that same grep result (matches only inside the helpers' own definition file) shows the opposite — they are dead code; caught and corrected by the decomposer in `units.md` before build — 4th occurrence | `.ai/aidlc/agents/inception/tcg-elaborator.md` | applied 2026-10-20 |
| 2026-09-14 | SCRUM-LOADOUT-UNASSIGNED | ED-1 | gate-illusion | REQ-10 (Partial Loadout) was added to `spec.md` mid-build but never given a unit in `units.md`; shipped (`fcf499dbe`) with no slice-contents, risk, ripple or test row, while `units.md`'s own ledger still claims "all 9 requirements... covered" — 6th occurrence, escalated | `.ai/aidlc/templates/units.md` | applied 2026-10-20 |
| 2026-09-14 | SCRUM-LOADOUT-UNASSIGNED | ED-2 | gate-illusion | Two commits merged in PR #571 (`c01ba4103` realtime emit, `575ca630c` photo-loader/stale-thumb fix) carry no REQ or unit reference anywhere in `spec.md`/`units.md`, unlike a third extra commit in the same PR that a concurrent vault sweep did trace back — 7th occurrence, escalated | `.ai/claude/skills/commit/SKILL.md` | proposed |
| 2026-10-07 | PAYROLL-FLAGS | SD-1 | missing-requirement | `payroll.entry_corrected` was dispatched in `submitCorrection` and rendered in the catalog/templates but never added to `NOTIFICATION_TYPES` in `@tcg/shared`; TypeScript cannot catch this because the catalog uses a plain string key — the type array and catalog can silently diverge | `.ai/claude/contexts/api.md` — note that notification type arrays and catalog entries must be kept in sync; add a cross-check | applied 2026-10-20 |
| 2026-10-07 | PAYROLL-FLAGS | SD-2 | missing-requirement | `crane-supervisor-retired.spec.ts` listed `payroll.entry_corrected` in `RETIRED_TYPES` — a payroll-admin action misclassified as a retired crane-supervisor action; spec never stated which types belong to each role boundary | none | open |
| 2026-10-07 | PAYROLL-FLAGS | SD-3 | missing-requirement | RESUBMITTED status was not handled in the corrections admin page: `QueryReturnedEntriesDto` only accepted `SENT_BACK | CORRECTED`, `submitCorrection` threw 409 for `RESUBMITTED`, no tab existed in the UI — entries vanished after employee resubmit | `.ai/claude/contexts/api.md` — enumerate every valid send-back status in DTO validators when a new status is added | applied 2026-10-20 |
| 2026-10-07 | PAYROLL-FLAGS | SD-4 | missing-requirement | `CorrectionDialogHeader` status badge was binary (`SENT_BACK → 'Sent Back'`, else → `'Corrected'`); RESUBMITTED showed "Corrected" — spec never listed which badge each status maps to in the corrections dialog | none | applied 2026-10-20 |
| 2026-10-07 | PAYROLL-FLAGS | SD-5 | missing-requirement | Employee `responseNote` in the correction detail was not surfaced in the dialog; admins reviewing a RESUBMITTED entry could not see what the employee wrote — spec did not describe what information to display when reviewing a resubmitted entry | none | open |
| 2026-10-17 | TCG-218 | SD-1 | missing-requirement | No requirement stated whether quote/job/board read the asset configuration live or as quoted; found by the ticket owner asking mid-build, cost U11a-1/a-2/b | `.ai/aidlc/templates/spec.md` §11a — required `Read time` column (R1) | applied 2026-10-20 |
| 2026-10-17 | TCG-218 | SD-2 | missing-requirement | Snapshot trigger specified as "any send path"; Mark as Won from Draft and direct PATCH to WON never enumerated — found by a hand-run scenario (Q58), Q59 still open | `.ai/aidlc/templates/spec.md` §2 — required `Reached by` field (R2) | applied 2026-10-20 |
| 2026-10-17 | TCG-218 | SD-3 | missing-requirement | REQ-07 (crane absent from its own Mob pair) contradicted the vault's FCC estimate template for the same artefact, not compared at elaboration; found in U7 browser review, added U4d | `.ai/aidlc/agents/inception/tcg-elaborator.md` Sources — `Differs from <file>` (R3) | applied 2026-10-20 |
| 2026-10-17 | TCG-218 | SD-4 | missing-requirement | Mob/Demob twin rule specified for add Mob→Demob only; add-in-Demob, quantities per direction unspecified — found while testing U9, added unit Q50 + Q53 | `.ai/aidlc/templates/spec.md` §2 — operation × side `Matrix` field (R4) | applied 2026-10-20 |
| 2026-10-17 | TCG-218 | SD-5 | missing-requirement | Customer-document presentation scoped to Mob/Demob lines; client question asked the narrow case first, a narrow U12 was built then widened to every line net (Joe 2026-10-17); reverses the 2026-09-11 footer decision | `.ai/aidlc/agents/inception/tcg-elaborator.md` client questions — scope first (R5) | applied 2026-10-20 |
| 2026-10-17 | TCG-218 | SD-6 | unit-not-vertical | Units flagged "at risk" or "size not estimated" were split at build along API/web halves (U2a/b, U4a-c, U5a/b, U11a/b); U4b PR states "nothing deploys between U4 and U6" | `.ai/aidlc/agents/inception/tcg-decomposer.md` — refuse at-risk/unestimated units (R6) | applied 2026-10-20 |
| 2026-10-17 | TCG-218 | SD-7 | over-built | `jobs.configuration_snapshot` added in U11a-1 as a copy of the quote's never-changing snapshot reachable via `jobs.quotation_id`; dropped by U13 one day later (Q64); redundancy test never ran against a recorded developer decision | `.ai/claude/contexts/prisma.md` §Conventions + `tcg-prisma-guardian.md` (R7) | applied 2026-10-20 |
| 2026-10-17 | TCG-218 | ED-1 | invented-value | Snapshot reader added an `id` tie-break to `createdAt` ordering that the live read does not have, reordering brought-along lines on frozen quotes/jobs; found by the analyst (Q61) | `.ai/claude/contexts/api.md` — frozen-copy readers share the live `orderBy` constant (R8) | applied 2026-10-20 |
| 2026-10-17 | TCG-218 | ED-2 | branch-ops | Two stacked-PR mishaps on one ticket: #791 merged into its parent branch, #797 closed when its base went away; a prose warning in #797's own body did not prevent the second | `.ai/claude/skills/commit/SKILL.md` §1 + `.github/workflows/pr-base.yml` (R9) | applied 2026-10-20 |
| 2026-10-17 | TCG-218 | ED-3 | branch-ops | Branch creation in the primary checkout moved the live dev checkout onto a newer origin/main mid-test (session-observed, not in any PR); worktree use is advised not required | `.ai/aidlc/agents/construction/tcg-executor.md` — branch via `pnpm worktree:add` (R10) | applied 2026-10-20 |
| 2026-10-17 | TCG-218 | ED-4 | gate-illusion | No lint/build/test ran on any unit (developer deferral, recorded); end-of-ticket `pnpm lint && pnpm build` failed on pre-existing main breakage (#709 calendar.tsx, #827 DAS test) with no earlier baseline, so no gate can certify TCG-218 — 8th gate-illusion row, escalated | `.ai/aidlc/templates/units.md` — `Gate baseline` header + restore pre-push `nx affected` (R11) | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | SD-1 | invented-value | UI copy (Q14-20, 23, 26), closing-soon threshold, reason cap, cron look-back and list page size left unspecified; shipped as labelled provisional values, late-tickets lists unpaginated | `.ai/aidlc/templates/spec.md` §9 (R3) | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | SD-2 | missing-requirement | REQ-30-33 / Q1-Q4 product questions open through the build; correctly not built, workarounds labelled — 3rd+ occurrence, escalated | none (tracked in spec §12) | proposed |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | SD-3 | missing-requirement | Nine structural questions (Q9, 10, 13, 21-25) first surfaced during build: FK on-delete, backfill, DI graph, replay idempotency — 3rd+ occurrence, escalated | `.ai/aidlc/templates/spec.md` requirement block (R1) | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | SD-4 | missing-requirement | H3 changed `TicketHoldoverService`'s constructor while H6 wired it into `JobProgressModule`; units.md gave both only an H2 edge | `.ai/aidlc/agents/inception/tcg-decomposer.md` (R4) | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | SD-5 | missing-requirement | No behaviour stated for an absent slot or `stepFlow` (`getTicketTotal(undefined)=14`, submit guard without `slotTypeName`, `matchPreviousTicket` on a shared slot line) — 3rd+ occurrence, escalated | `.ai/aidlc/templates/spec.md` requirement block (R1) | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | SD-6 | missing-requirement | REQ-28 has no trust statement for the client `X-Captured-At` header; a forged value can push a write past the window — 3rd+ occurrence, escalated | `.ai/aidlc/templates/spec.md` (R1); spec Q27 | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | SD-7 | stale-reference | `spec.md` §2 still says OPEN for REQ-02/09/15/22 after §12 resolved them, §14 unticked, Q22 left open, and `units.md` ledger reads `not started` for all 35 built units — 5th occurrence, escalated | `.ai/aidlc/agents/construction/tcg-executor.md` §Output shape (R5) | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | ED-1 | over-broad-condition | U5 web progress: a floating step's own capture raised the sequential high-water mark so earlier steps inferred done; fixed | `.ai/aidlc/templates/spec.md` + `templates/units.md` (R2) | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | ED-2 | over-broad-condition | U3 `leftJob` closed `WORK_AT_JOB_SITE_TIME` for every flow, spec said STANDARD; fixed | `.ai/aidlc/templates/spec.md` + `templates/units.md` (R2) | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | ED-3 | over-broad-condition | Window guard accepted any APPROVED request, so an approved `LATE_COMPLETION` unlocked edits like `SUBMITTED_EDIT`; fixed | `.ai/aidlc/templates/spec.md` + `templates/units.md` (R2) | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | ED-4 | contradicted-source | Replayed submit of a COMPLETE ticket after the window returned 409, contradicting the labelled Q22 workaround and the offline-outbox idempotency path; fixed — 3rd occurrence, escalated | `.ai/aidlc/templates/units.md` test plan (R2) | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | ED-5 | gate-illusion | H3 + H6 each passed their own tests but the API would not boot merged (DI: `JobProgressModule` provides a service whose constructor now needs `JobTicketsService`); fixed, module-init test added — 3rd+ occurrence, escalated | `.ai/claude/contexts/api.md` Testing (R6) | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | ED-6 | gate-illusion | Two consolidated branches sit on different bases (`1056f2aa6` vs `d09a8209f`) because LT executors fetched a newer origin/main mid-run; nothing checks a ticket's units share a base | `.ai/aidlc/agents/construction/tcg-executor.md` §1 (R7) | proposed |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | ED-7 | gate-illusion | REQ-21 `submittedAt` never written; uniqueness violation (`P2002`) has no 409 mapping; tests asserted the index, not the response | `.ai/aidlc/templates/units.md` test plan (R2) | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | ED-8 | gate-illusion | Reminder cron writes dedup before notify (failed notify never retried) and has no offset upper bound | `.ai/aidlc/templates/units.md` test plan (R2) | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | ED-9 | gate-illusion | Returned-ticket resubmit bypasses the REQ-04 missing-steps block; `visibleFlowStepKeys` wrapper still used in `compose-ticket-detail.ts` | `.ai/aidlc/templates/units.md` test plan (R2) | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | ED-10 | gate-illusion | H2 (451), LT6 (690, split) and LT16 (545) over the ~400-line cap; ledger size column S/M carried no line estimate, so the cap was met after the build | `.ai/aidlc/templates/units.md` Size column (R8) | applied 2026-10-20 |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | ED-11 | undecided-structure | Q13 (Option C) and Q21 (FK targets/on-delete) recorded as Haris's decision 'delegated to the AI' / 'via the AI driving the loop'; root CLAUDE.md says an AI never fills Decided by | `.ai/aidlc/templates/spec.md` Decision line (R9) | proposed |
| 2026-10-19 | TICKET-FLOW-SLOTS-HOLDOVER | ED-12 | layer-violation | A `service/` file has a type-only import from `usecase/`; lint has no rule for module boundaries | root `eslint.config` import-x/no-restricted-paths (R10) | proposed |

# Reflection — SCRUM-900 Update Tool and Rigging Usage Logic After Job Completion

## 0. Context

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-900` |
| Spec | `.ai/aidlc/SCRUM-900/spec.md`, elaborated `2026-08-21`; Q1–Q3 resolved `2026-08-24` |
| Units | U1 — *shipped* (merged as platform PR #394, merge commit `93d5b568`, branch `scrum-900` tip `37c4a554`) |
| Reflected on | `2026-08-25` |
| Reviewer(s) | `review-pr` skill (automated, 2026-08-25) — ship with follow-ups. No human PR review recorded on GitHub (PR #394 has zero `reviews`); merged by `devCodingcops` |
| Open questions at build time | 3 (Q1–Q3), all answered by Fouzan Shakil on 2026-08-24, before U1 started — 0 open when the executor began |
| `[UNVERIFIED]` requirements built | 1 — REQ-01's Jira source. Turned out wrong or stale: 0 — the decision corroborated it and the shipped behaviour matches |
| Unverified × irreversible | 0 — `units.md` flagged REQ-01 `[UNVERIFIED]` but the change is code-only (no migration, no write path), trivially reversible by reverting the file; flagged correctly *before* the build, not discovered during it |

---

## 1. Spec defects — what the spec missed

### SD-1 — `units.md` asked for a shared-helper extraction but not for regression coverage of its existing consumer

- **Where:** `units.md` U1 → Slice contents → Tests row; Risk → Blast radius note
- **What the executor needed to know:** `units.md`'s own Risk section told the executor to
  "extract the [closed-stage] check into a shared helper to keep the two in sync" —
  `findToolIdsBlockedFromArchive` and the new `findUtilizationByDateRange` filter both now
  call `isScheduleDayClosed`. Once that extraction touches an existing, already-shipped
  function, does the unit's test plan need to prove that function's behaviour is unchanged?
- **What the spec said:** The Tests row lists four unit cases and one integration test, all
  scoped to `findUtilizationByDateRange` (the new call site). Nothing named
  `findToolIdsBlockedFromArchive` as needing coverage, even though the Risk note explicitly
  asked for the extraction to touch it.
- **What was decided instead, and by whom:** The executor performed the extraction
  (confirmed behaviour-preserving by diff inspection: `closedStages`/inline checks became
  `CLOSED_SCHEDULE_DAY_STAGES`/`isScheduleDayClosed`, same predicate) and added no test for
  `findToolIdsBlockedFromArchive` — which had **zero** test coverage before this ticket and
  still has zero after (`grep -rl findToolIdsBlockedFromArchive apps/api/src --include=*.spec.ts`
  returns nothing).
- **Was the decision right:** Still unknown — the analyst tagged this `[INFERRED]`, not
  `[VERIFIED]`: "behaviour-preserving but has no test coverage." Nothing actually proves it.
- **Cost:** None yet; latent. `findToolIdsBlockedFromArchive` gates whether a tool can be
  archived — a regression here either silently blocks a valid archive or silently allows
  archiving a tool still scheduled, and nothing in CI would catch it.
- **Class:** `refactor-untested` — **new class**, see §5.
- **Fix:** R1, §4.

---

## 2. Executor defects — what was built against the spec

### ED-1 — `dasStage` typed as `string` instead of Prisma's `SubJobStage` enum

- **Where:** `apps/api/src/service/asset-management/tools/tools.repository.ts` — the
  `ScheduleDaySubJob` type (`dasStage: string`) and `CLOSED_SCHEDULE_DAY_STAGES` (a
  `Set<string>` of literals); `apps/api/src/service/asset-management/tools/tools.repository.spec.ts` —
  `openSubJob()` uses `dasStage: 'IN_PROGRESS'`.
- **Spec said:** REQ-01's notes say to reuse the closed-stage exclusion already in
  `findToolIdsBlockedFromArchive`. `apps/api/prisma/schema.prisma` already types
  `SubJob.dasStage` as the generated enum `SubJobStage` (`OPEN`, `ALLOCATION_COMPLETED`,
  `TICKET_SENT`, `LOADOUT`, `EMPLOYEE_LEFT_YARD`, `WORK_IN_PROGRESS`, `COMPLETED`,
  `TICKET_SUBMITTED`, `CANCELLED`) — there is no `IN_PROGRESS` member.
- **Built:** A local type that widens the field back to `string`, and a test fixture that
  uses `'IN_PROGRESS'`, which is not a real `SubJobStage` value (`WORK_IN_PROGRESS` is).
  TypeScript did not catch this because `dasStage: string` accepts any literal.
- **Caught by:** Not caught — the analyst flagged it `[INFERRED]`, not verified as a live
  bug. Every existing test still passes because `'IN_PROGRESS'` fails every closed-stage
  check exactly the way a real open stage would — but the "open" fixture is exercising a
  state that can never occur in production, not the real one.
- **Class:** `gate-illusion` — lint, build and jest all report green (4/4, 0 errors), which
  reads as "the open-vs-closed boundary is under test," while the actual `SubJobStage` enum
  is never checked against and one of the two test fixtures uses a value the type system
  should have rejected.
- **Fix:** R3, §4.

### ED-2 — `units.md`'s promised integration test was not built, and the unit was still reported as complete

- **Where:** `units.md` U1 → Slice contents → Tests row (integration test:
  `GET /api/v1/asset-management/tools/:toolCode/utilization?date=<today>` returns correct
  `inUse` after schedule-day sub-job transitions to `COMPLETED`); shipped diff contains only
  `tools.repository.spec.ts` (unit tests).
- **Spec said:** `aidlc/agents/construction/tcg-executor.md` §1: "Build the unit you were
  given, completely — every row of its slice-contents table, its tests, and its migration
  if it has one. Then stop." The Tests row is one row, and it names both a unit level and
  an integration level.
- **Built:** Only the unit-level spec. No integration test exists anywhere in the merged
  diff or the repo for this endpoint.
- **Caught by:** Not caught by any gate — `pnpm api:test` is green because it never asked
  for an integration test to exist. Surfaced only by the analyst's `review-pr` pass reading
  `units.md` against the diff.
- **Class:** `gate-illusion` — the unit's own status column reads `built`, and every gate
  (lint 0 errors, build success, jest 4/4) is green, which gives the same impression the
  Tests row promised: unit **and** integration coverage. Only one of the two shipped.
- **Fix:** R2, §4.

### ED-3 — `units.md`'s build-status SHA does not resolve on the platform repo

- **Where:** `units.md` U1 unit-ledger row — `Status: built — c0e8d227`.
- **Spec said:** No documented format for the `Status` column's `built` state exists in
  `aidlc/templates/units.md` (only `not started` is shown as an example) — this finding is
  as much a template gap as an executor slip.
- **Built:** `c0e8d227` does not exist anywhere in the platform repo's history
  (`git log --all | grep c0e8d227` — no hits). The actual tip of `scrum-900` that got
  merged is `37c4a554` (`git log --all --oneline | grep 37c4a554` → `fix(tools): exclude
  closed schedule days from utilization inUse`), reached via merge commit `93d5b568`
  (PR #394). The recorded SHA is a pre-rebase/pre-squash local commit that stopped
  resolving once the branch was rewritten before push.
- **Caught by:** Not caught by any gate — surfaced by the analyst cross-checking the SHA
  against the platform repo during `review-pr`.
- **Class:** `stale-reference` — a fact in the AI layer (`units.md`) that no longer
  resolves.
- **Fix:** R4, §4.

---

## 3. Source and vault findings

- **Sources that turned out to be wrong or stale:** None. REQ-01's Jira source was
  `[UNVERIFIED]`; the build and the decision both corroborate it rather than contradict it —
  one data point toward "the tag doesn't always mean wrong," not enough to draw a trend from.
- **Unverified requirements made hard to reverse:** None — REQ-01 was `[UNVERIFIED]` but the
  change is code-only, and `units.md` flagged that explicitly and correctly *before* the
  build (see §0).
- **Conflicts that surfaced only during build:** One, and it is not a conflict between vault
  documents — it is a pre-existing code inconsistency the analyst found while reviewing this
  diff: `findToolIdsBlockedFromArchive`'s assignment query filters
  `jobTool: { replacedAt: null }`; `findUtilizationByDateRange` (the function this ticket
  modified) has never filtered `replacedAt` at all, before or after SCRUM-900. Nobody had
  written this down anywhere before this review. **Written to `spec.md` §12 as Q4** (below) —
  this ticket did not introduce it and did not need to fix it to ship REQ-01–03, but it
  bears directly on what "in use" means for the same query REQ-01–03 modified, so it should
  not stay unrecorded.
- **Questions answered by a named human during the build:** Yes — Q1/Q2/Q3, by Fouzan
  Shakil, 2026-08-24. **Written?** Yes —
  `vault/decisions/2026-08-24-tool-in-use-after-completion.md`. This path worked correctly
  end to end: blocking questions raised, answered by a named human, decision file written
  with `resolves:` pointing back at `spec.md#q1/#q2/#q3`, spec.md §12 updated to
  `resolved`.
- **A named follow-up that has nowhere to live:** The decision's Q2 answer names a explicit
  follow-up — "converge on one server-side utilization both [Dylan's yard dashboard and the
  detail page] consume (do not silently leave permanent duplication)." That sentence exists
  only inside the decision file's prose. It is not in `vault/assets/gaps.md` (currently
  empty — "No entries yet"), so the standard sweep
  (`grep -rn '^- **Status:** open' .ai/vault/*/gaps.md`) will never surface it. **I do not
  have write access to `vault/assets/gaps.md`** (reflector tool scope is read-only there) —
  recommending, not filing: `tcg-scrum` or a human should add an entry there in the format
  `vault/assets/gaps.md` already documents, sourced to this decision file.
- **`gaps.md` entries this ticket should close:** None — no existing entry addressed this
  area.
- **Undefined terms hit:** None new — intent.md's "In Use" / "reset" / "associated job is
  completed" were fully resolved into REQ-01–03 by the elaborator before this reflection.

---

## 4. Rule changes proposed

| # | File | Section | Exact change | Prevents | Accepted |
| --- | --- | --- | --- | --- | --- |
| R1 | `.ai/aidlc/agents/inception/tcg-decomposer.md` | Slicing a unit's Tests row | Add: "If a unit's slice contents extract or modify logic already used by another shipped function (a shared-helper extraction, an inline check pulled into a common utility), the Tests row must name a regression test for **every existing consumer** of that logic, not only the new call site — even if that consumer had no prior coverage." | SD-1 | pending |
| R2 | `.ai/aidlc/agents/construction/tcg-executor.md` | §Output shape | Change the `tests <what, and what they assert>` line to require, when the unit's Tests row names more than one level (unit / integration / E2E): one sub-line per level, each marked `built — <what it asserts>` or `not built — <reason>`. Silently dropping a promised level must not be absorbed into a single prose line. | ED-2 | pending |
| R3 | `.ai/claude/contexts/prisma.md` | `## Conventions` | Add: "A field typed as a Prisma enum in `schema.prisma` (e.g. `SubJobStage`) must be typed with that generated enum everywhere it is read or compared in application code — never re-declared as `string` or matched against a `Set<string>` of hand-typed literals. If a local type mirrors an enum-backed Prisma field, import the enum." | ED-1 | pending |
| R4 | `.ai/aidlc/templates/units.md` | Unit ledger → `Status` column | Add to Fill rules: "`built` must record the SHA reachable from `origin/main` **after** the unit's branch is rebased and pushed for merge — never a pre-rebase local commit SHA. If the unit ledger is updated before the final rebase, mark it `built — pending final SHA` and let the ticket-close step (`close-ticket` / the reflector) fill in the resolved SHA from the merge commit." | ED-3 | pending |

- **Rejected proposals, and why:** None outright rejected. One considered and set aside:
  folding SD-1 into the existing `missing-requirement` class instead of adding
  `refactor-untested`. Rejected because `missing-requirement`'s definition
  ("the spec was silent on something the build could not proceed without") doesn't hold
  here — the build proceeded fine without the regression test; the risk is latent, not
  blocking. Forcing the label to make it the third `missing-requirement` occurrence would
  have triggered §4's escalation for a mechanism (regression coverage for refactors) that
  has nothing to do with why SCRUM-877's two `missing-requirement` rows happened
  (undocumented domain calculation rules). Escalating the wrong mechanism wastes the
  escalation's credibility for when a real third occurrence lands.

---

## 5. Recurrence check

Checked against `.ai/aidlc/reflections/INDEX.md` by grepping each defect's class before
writing this reflection.

| Defect | Class | Prior rows | Occurrence | Why the previous fix did not hold |
| --- | --- | --- | --- | --- |
| SD-1 | `refactor-untested` | none — new class | 1st | N/A |
| ED-1 | `gate-illusion` | none | 1st | N/A |
| ED-2 | `gate-illusion` | none (ED-1 is the same ticket, same reflection) | 1st | N/A |
| ED-3 | `stale-reference` | none | 1st | N/A |

- **Escalate:** None. No class in this reflection has a prior row in the index at all, so
  nothing reaches a third occurrence.
- **New class added to the index?** Yes — `refactor-untested`: "A refactor or extraction
  changed the behaviour of existing, already-shipped code, but the unit's test plan required
  coverage only for the new call site, leaving the existing consumer unverified." None of
  the 13 existing classes describe this — closest candidates (`missing-requirement`,
  `gate-illusion`) were checked and rejected in §4's rejected-proposals note.
- **Rows appended to `reflections/INDEX.md`:** Yes — one per defect above, plus the new
  class row.

---

## 6. Kept as-is

- **`units.md` marking REQ-01's Jira source `[UNVERIFIED]` while treating the decision as
  `[VERIFIED]` and proceeding** — correct. The decision resolves the interpretation; the
  Jira text is corroborative, not the sole source. No change needed.
- **Intent.md's DoR failure flag, and the three blocking questions it produced** — the
  process worked exactly as designed: `intent.md` correctly flagged "ticket has no
  acceptance criteria" as `OPEN` per `domain/jira-sop.md`, the elaborator turned that into
  three named blocking questions (Q1–Q3), and Fouzan Shakil answered all three *before* the
  executor started — `units.md` shows 0 units blocked on an open question at build time.
  This is the loop doing what it is supposed to do, not a defect.
- **The overlay-branch conflict on `aidlc/processed.log` during `worktree:done`, resolved by
  union** — this is not a new failure. `scripts/worktree-done.sh` already documents this
  exact case ("Append-only files (`processed.log`, `reflections/INDEX.md`) conflict
  trivially") and the resolution taken matches what the script tells the operator to do.
  Working as designed.
- **`findUtilizationByDateRange` not filtering `jobTool.replacedAt`** — real, but explicitly
  *not* a defect of this ticket: the analyst confirmed it predates SCRUM-900 and this diff
  never touched that `where` clause. Recorded as Q4 in `spec.md` §12 instead of as an ED,
  because REQ-01–03 did not ask the executor to fix it and REQ-02's notes explicitly scope
  this ticket to closed-day exclusion only.

---
title: Capability first — the AI decides structure, stops only at guardrails, no PR size budget — decision
source: decision/Syed Haris
decided: 2026-10-21
decided_by: >-
  Syed Haris (git: hariscops, syed.haris@codingcops.com), AI-layer owner, in a Claude Code
  session on 2026-10-21. He reviewed a written draft of this change and replied "apply all
  of it". These are engineering-process rules about the AI-DLC loop. They do not describe
  product behaviour.
status: verified
resolves: >-
  none (no open §12 or module gaps.md entry asked this; raised directly in the session).
  Supersedes §2 of decisions/2026-10-20-sole-unverified-source-confirmed-structure-not-delegable-api-layering-linted.md
  and amends its §1. Supersedes §1–§3 (the structure and siblings half) of
  decisions/2026-10-09-developers-decide-structure-siblings-and-haris-only-tooling.md; its
  §4 (tooling is Haris-only) stands. Supersedes the size-budget part of
  decisions/2026-10-09-one-unit-or-one-task-per-pr-with-size-budget.md (§8 below); its
  one-unit-per-PR, stacked-PR and sweep rules stand
tags: [module/all, kind/decision, architecture, sprint-planning]
---

## Decision

**Capability first, guardrails at the edges.** The framing comes from a session on agentic
systems that Haris attended: "AI systems are built by unleashing a capable model first, then
putting guardrails around it."

### 1. The AI decides how to build, and records every choice

- The AI decides **how** to build. That covers tables, columns, a new function versus reuse,
  endpoints, request and response shapes, defaults, sort orders, page sizes and sibling
  changes.
- It chooses in this order:
  1. what `.ai/claude/contexts/patterns.md` fixes
  2. the nearest existing code
  3. the simplest option
- It **records** every choice:
  - **Path A:** `spec.md` §11b *AI decisions — reviewed by a developer*
  - **Paths B and C:** the *AI decisions* table in the PR description
- A developer reviews the record in the PR. To overturn a choice, the developer leaves a
  review comment.

This supersedes:

- **§2 of `decisions/2026-10-20-sole-unverified-source-confirmed-structure-not-delegable-api-layering-linted.md`**
  ("a developer cannot delegate a structural choice to the AI")
- **the structure and siblings half of
  `decisions/2026-10-09-developers-decide-structure-siblings-and-haris-only-tooling.md`**
  (its §1–§3). Its §4, *tooling is Haris-only*, **stands**.

### 2. The AI stops only at six guardrails

| # | Guardrail | What happens |
| --- | --- | --- |
| G1 | Client-facing behaviour nobody specified: a business rule, eligibility, money, or what a customer sees | A §12 question, sent in the batch (§4) |
| G2 | Destroying or rewriting existing data | Developer approval, and the migration guard run against a copy of staging data |
| G3 | Tenant data | `tcg-prisma-guardian`, and an isolation test |
| G4 | Pay rules | The source in `payroll/payroll-rules-provenance.md` |
| G5 | A new dependency, or a changed response shape | Dependency: ask. Response shape: `tcg-contract-tracer` |
| G6 | A push to `main`, or secrets | The hooks |

### 3. When a path escalates to Path A

A path escalates to A **only** for G1, or for picking one side of a vault conflict. An
unstated default, an unstated order or an unstated structure no longer escalates a path.

### 4. Questions go out in one batch, and big tickets are split first

- All questions go out in **one batch, at the end of elaboration**.
- A ticket over about **8 REQs, 6 units or a 40 KB spec** is proposed as a split first.

### 5. Amends §1 of 2026-10-20: a sole `[UNVERIFIED]` source no longer blocks by itself

- A client-facing requirement whose only source is `[UNVERIFIED]` still gets a confirmation
  question, but in the batch (§4).
- It does **not** block the build, unless it is also irreversible.

The rest of 2026-10-20 §1 is unchanged: a second source of any status, or a `[VERIFIED]`
source, still lifts it.

### 6. Siblings are applied or listed, no longer asked

- Within the PR size budget: the sibling change is applied in the same PR.
- Over the budget: it is listed as a follow-up.
- Either way, it is recorded.

### 7. Reviewers report against the record

`review-pr`, `tcg-analyst` and `tcg-prisma-guardian` now report each structural choice as
one of:

- **Recorded** — judged on its merit
- **Unrecorded**
- **Guardrail skipped** — blocking
- **Contradicts record**

### 8. The PR size budget is removed from the AI layer

> "it's not worth it."

- **Removed:** the budget of about 400 changed source lines and 25 source files per PR,
  together with the stops that enforced it in `tcg-executor`, the `commit` skill and
  `review-pr`. The `size-exception` label no longer has a role in the AI layer.
- **Not removed by this decision:** one AI-DLC unit (Path A) or one independent task
  (Paths B/C) per PR, stacked PRs for dependent units, and "sweeps are their own PR".
  `decisions/2026-10-09-one-unit-or-one-task-per-pr-with-size-budget.md` states each of
  these as its own rule (§1 first two bullets, §2, §4), and §4 gives a reason for the sweep
  rule that is not about size: a sweep inside a feature PR hides the feature's real
  changes. So none of them is stated *only* as part of the budget, and all of them stand.
- **The client-repo check still exists.** `.github/workflows/pr-size.yml` is still in the
  client repo and still posts a red check and a split comment over budget. Removing it is a
  client-repo change that Haris has not made. Until it is removed, its red check is noise
  that this decision has made non-binding.

This supersedes, in part, the size-budget half of
`decisions/2026-10-09-one-unit-or-one-task-per-pr-with-size-budget.md`: §1's *Budget*,
*Not counted* and *Over budget* bullets, and §3's enforcement. Two other notes become moot
on the budget point. Each now carries a frontmatter pointer:

- the "order of the sweep PRs under the ~400-line PR budget" item that
  `decisions/2026-10-20-sole-unverified-source-confirmed-structure-not-delegable-api-layering-linted.md`
  §3 left open
- `decisions/2026-10-20-ship-ticket-flow-slots-holdover-over-budget-single-pr.md`, a
  one-PR exception to a budget that no longer binds the AI layer

## Why

TCG-237 (role and department) showed the cost of the control-every-step model:

- **Time.** Haris's account is about 21 hours in one orchestrating session. The overlay's
  own commits on `aidlc/TCG-237` run from 2026-10-20 05:28 to 2026-10-21 00:46 (+05:00),
  about 19 hours 20 minutes.
- **Spec size.** `.ai/aidlc/TCG-237/spec.md` is 172,540 bytes, and
  `.ai/aidlc/TCG-237/units.md` is 110,492 bytes (`wc -c`, 2026-10-21).
- **Questions.** §12 holds 70 questions. 61 of them carry a developer (Haris) answer, mostly
  marked "developer, open to TCG challenge". One was answered by a client (Brian Petros),
  and one has no stated answerer. Four are open, and three are superseded. Most of the
  questions were structural or developer questions, not client questions, and the developer
  answered them anyway.
- **Branches.** There are 41 local and 40 remote `tcg-237` branches (64 distinct names).
  They collapsed into PR #890 (`feat/tcg-237-fixups-b`, merged 2026-10-20 23:37 +05:00):
  9,984 source lines in 350 files, measured with the root `CLAUDE.md` exclusion filter
  (11,957 lines and 404 files in total).
- **Staging failure.** After the merge, U20d failed on staging on unmapped employee types.
  It was fixed by #893 (map Job Foreman, Apprentice and Default to roles) and #894 (delete
  the type-only sub-category rows still unmapped, Q72).

TICKET-FLOW-SLOTS-HOLDOVER also ran long:

- `spec.md` is 106,734 bytes and `units.md` is 108,556 bytes.
- §12 holds 29 questions.

Pre-approving every structural choice did not prevent the failure that mattered: U20d's
staging break was a data-rewrite problem, which is G2. It did multiply questions the
developer answered for himself. The control belongs where a wrong choice is expensive or
irreversible (G1–G6). Everywhere else, a recorded choice that a developer reviews in the PR
is cheaper and leaves the same audit trail.

**Rejected alternative.** Keep pre-approval of structure, and front-load the decisions into
a design pass. Rejected because it keeps the control-every-step model and only moves where
the questions are asked.

**What it gives up.** A structural choice the developer would have made differently reaches
the PR before the developer sees it. The mitigation is the recorded *AI decisions* table:
every such choice is visible in review, and overturning it is one comment.

## Mechanism

The main session made the tooling edits for this decision. This note did not make them, and
it is their source. All are **applied**, uncommitted in the overlay as of this note. Each
was checked by `grep` on 2026-10-21; line numbers are as of that check.

- **§1 and §3 (the AI decides how, records it; escalation to A only for G1 or a conflict):**
  - root `.ai/claude/CLAUDE.md` lines 63–66 (triage) and 72–96, *The AI decides how; it
    stops only at the guardrails*
  - `.ai/aidlc/templates/spec.md` line 119 and §11b *AI decisions — reviewed by a
    developer* (line 312)
  - `.ai/claude/skills/commit/SKILL.md` *AI decisions* (line 223)
  - `.ai/aidlc/agents/construction/tcg-executor.md` §2 *Stop on `[OPEN]` and the
    guardrails. Decide the rest.* (lines 119–144) and its report lines 301–303
  - `.ai/aidlc/agents/inception/tcg-elaborator.md` lines 329 and 489–520
- **§2 (G1–G6):** root `.ai/claude/CLAUDE.md` lines 84–93; `tcg-executor.md` line 122;
  `.ai/aidlc/agents/tools/tcg-prisma-guardian.md` lines 67–69 (G2 staging-copy guard run)
- **§4 (one batch; split above ~8 REQs / ~6 units / ~40 KB):** `tcg-elaborator.md`
  lines 82–84
- **§5 (sole `[UNVERIFIED]` does not block unless irreversible):** `tcg-elaborator.md`
  line 76 and line 259
- **§6 (siblings recorded, not asked):** root `.ai/claude/CLAUDE.md` lines 98–108,
  *Siblings get the same change — recorded, not asked*; `tcg-executor.md` §4b
  (lines 221–232); `.ai/claude/skills/commit/SKILL.md` *Siblings* (line 228)
- **§7 (Recorded / Unrecorded / Guardrail skipped / Contradicts record):**
  - `.ai/claude/skills/review-pr/SKILL.md` lines 159–167 hold all four labels.
  - `.ai/aidlc/agents/construction/tcg-analyst.md` line 131 judges recorded choices on
    merit, makes an unrecorded one a finding and a skipped guardrail blocking, and points
    at `review-pr` §4b for the method.
  - `tcg-prisma-guardian.md` lines 67–69 and 146 report `UNRECORDED STRUCTURE`.
- **§8 (no PR size budget):**
  - Root `.ai/claude/CLAUDE.md` lines 114–126, *One unit, or one independent task, per
    PR*, says "no line or file budget". It keeps the unit, stacked-PR and sweep rules, and
    says `pr-size.yml` is no longer an AI-layer rule.
  - `grep -rn -i '~400\|25 source files\|size-exception\|size budget\|within budget'`
    over `.ai/claude`, `.ai/aidlc/agents`, `.ai/aidlc/templates` and
    `.ai/aidlc/GUIDE.md` returns **no hits**.
- **Also changed in the same pass:** `.ai/aidlc/GUIDE.md`, `.ai/aidlc/templates/units.md`,
  `.ai/aidlc/agents/inception/tcg-decomposer.md`, `.ai/claude/contexts/patterns.md`.

**Not applied:** the client repo's `.github/workflows/pr-size.yml` still exists and still
posts a red check. Removing it is a client-repo change Haris has not made.

## Effect on the vault

- **Winner:** none. This is a process decision, and no product vault file states or
  contradicts it.
- **Superseded in part, done:**
  `decisions/2026-10-20-sole-unverified-source-confirmed-structure-not-delegable-api-layering-linted.md`
  — its frontmatter now has `superseded_by:` this note (§2 only) and a `provenance_note:`
  saying §1 is amended and §3 stands. Its `status:` stays `verified`, because §3 and the
  rest of §1 still bind. Its body is unchanged.
- **Superseded in part, done:**
  `decisions/2026-10-09-developers-decide-structure-siblings-and-haris-only-tooling.md`
  (§1–§3, structure and siblings). Its frontmatter now has `superseded_by:` this note, with
  the comment "structure and siblings only; Haris-only tooling stands", and a
  `provenance_note:`. Its `status:` stays `verified`, because §4 (tooling is Haris-only)
  still binds. Its body is unchanged.
- **Superseded in part, done:**
  `decisions/2026-10-09-one-unit-or-one-task-per-pr-with-size-budget.md`. It covers the
  size budget and its enforcement (§8). Its frontmatter now has `superseded_by:` this note
  (budget only) and a `provenance_note:` saying the unit, stacked-PR and sweep rules stand.
  Its `status:` stays `verified`, and its body is unchanged.
- **Moot on the budget point, done:**
  `decisions/2026-10-20-ship-ticket-flow-slots-holdover-over-budget-single-pr.md` — a
  `provenance_note:` now says the budget it excepted no longer exists. Its `status:`
  (`reference`) and body are unchanged.
- **INDEX:** the 2026-10-20 sole-unverified row in `INDEX.md` now ends with a pointer to
  this note.
- **Gap entry:** none to close.

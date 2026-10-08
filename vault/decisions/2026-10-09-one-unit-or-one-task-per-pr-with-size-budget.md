---
title: One unit or one independent task per PR, with a size budget — decision
source: decision/Syed Haris
decided: 2026-10-09
decided_by: >-
  Syed Haris (git: hariscops, syed.haris@codingcops.com), in a Claude Code session on
  2026-10-09. Binding on every developer from 2026-10-09. No team acknowledgment is
  needed: he said so earlier the same day for his process rulings (see
  decisions/2026-10-09-developers-decide-structure-siblings-and-haris-only-tooling.md).
  This is an engineering-process rule about how work is cut into pull requests. It says
  nothing about product behaviour.
status: verified
resolves: none (no open §12 or module gaps.md entry asked this; raised directly in the session)
tags: [module/all, kind/decision, sprint-planning]
---

## Decision

### 1. One PR is one unit or one independent task, within a size budget

- **Path A:** a PR is one AI-DLC unit.
- **Paths B and C:** a PR is one independent task.
- **Budget:** about **400 changed source lines** and **25 source files**.
- **Not counted:** tests, migrations, lockfiles and snapshots.
- **Over budget:** a developer adds the `size-exception` label and writes the reason in
  the PR. **An AI never sets this label.**

### 2. Dependent units ship as stacked PRs

U2 branches from U1's branch and targets it. When U1 merges, GitHub retargets U2 to `main`.

**Rejected: waiting for U1 to merge before starting U2.** Waiting creates friction, and
that friction pushes people to bundle units into one PR.

### 3. Enforcement is a CI check plus agent rules

- **CI:** a new main-repo workflow, `.github/workflows/pr-size.yml`. It measures the
  source-only diff. Over budget, it posts a red check and a comment that lists the commits
  to split along. With `size-exception` set, it posts a warning instead of failing.
- **Agents:** the executor, the decomposer, the `commit` skill (§1 and §7) and `review-pr`
  measure the PR size and stop when it is over budget.

**The check cannot block a merge.** On the free plan, the main repo has no branch
protection. Rulesets need GitHub Pro, and `devCodingcops` is not an admin. The red check
and the comment are the only signal.

**Rejected: agent rules only.** A rule that only an agent reads is invisible to a
developer who opens a PR by hand.

### 4. One PR for all units is no longer a developer choice

`units.md` can no longer declare "same branch, one PR for all units" as the developer's
choice.

**Sweeps always get their own PR.** A sweep is any of these:

- a lint or format autofix
- an import-order change
- an SDK or dependency upgrade
- an unrelated fix

### 5. Haris retires his own "one branch, many commits" habit

He used to stack fixes as commits on one branch. That habit is retired. **Every fix and
every unit gets its own PR, including his.**

## Why

The evidence below was checked on 2026-10-09.

### PR #709 (PAYROLL-FLAGS, merged 2026-10-07)

- **Whole PR:** 958 files, +61,156 / −4,622, 28 commits holding U1–U21. Source:
  `gh pr view 709 --json changedFiles,additions,deletions`.
- **Source only:** 784 files.
  - Lines: the session measured 35,108.
  - Re-measured for this note: **32,929 lines**. This used the GitHub PR files API and
    `pr-size.yml`'s exclusion regex.
  - The file count matches. The line gap is likely a difference between the measurement
    methods (API per-file counts versus `git diff --numstat`). It does not change the
    conclusion: either figure is about 80 times the budget.
- **A lint/import-order sweep rode along.** Of the web files, 370 out of 609 changed by 4
  lines or fewer. The re-measurement found 371 out of 610.
- **Two other unrelated changes also rode along:** a Postgres job queue and test repairs
  for mobile SDK 57.

**The loop did run.** It was Path A, on overlay branch `feat/PAYROLL-FLAGS-foundation`.
That branch's `aidlc/processed.log` line 152 is the row
`PAYROLL-FLAGS  A  feat/PAYROLL-FLAGS-foundation  haris  pr: 709`.

**But each units file declared a single PR as the developer's choice:**

- `aidlc/PAYROLL-FLAGS/units.md:21`: "Git layout — one branch, one PR, five commits,
  developer's explicit choice"
- `units-u6-u13.md:24`: "same branch, same PR as U1–U5, one commit per unit, developer's
  choice"
- `units-u14-u21.md:51`: "same branch, same PR, one commit per unit, after U13"

All three are read from `origin/feat/PAYROLL-FLAGS-foundation`. Those declarations
overrode the `commit` skill's one-unit-per-PR rule. A rule that a units file can opt out
of did not hold.

### Other large merged PRs

Figures are from `gh pr view`, all files:

| PR | Files | Lines |
| --- | --- | --- |
| #695 | 217 | +2,770 / −1,320 |
| #708 | 137 | +5,966 / −783 |
| #714 | 131 | +8,797 / −1,535 |
| #745 | 63 | +1,828 / −462 |

For #745, the source-only count is **1,749 lines in 55 files**.

### The underlying reasoning

A reviewer cannot hold a PR of this size in their head. A sweep hidden inside a feature PR
makes the feature's real changes invisible. The rule therefore has to:

- live where every developer sees it (a CI check on the PR), not only in agent prompts
- remove the opt-out a units file could declare

## Observation (not part of the decision)

**The PAYROLL-FLAGS overlay branch was never merged into overlay `main`.**

- `feat/PAYROLL-FLAGS-foundation` holds 6 commits not on `origin/main`, from `2850e9a` to
  `837ac17`. One of them is `f2b618d`, the spec and units for U1–U21.
- PR #709 merged on 2026-10-07, but its `processed.log` row exists only on that branch.
- So `close-ticket` did not run for PAYROLL-FLAGS. Its spec, units and decision commits
  have not reached the team.
- This note records that fact only. It does not merge or close anything.

## Effect on the vault

- **No product file changes status.** This decision is about process, and it resolves no
  product gap.
- **Companion rule changes** are separate from this note. At the time of writing they were
  uncommitted edits in the overlay: `claude/CLAUDE.md`, `claude/skills/commit/SKILL.md`,
  `claude/skills/review-pr/SKILL.md`, `aidlc/agents/inception/tcg-decomposer.md`,
  `aidlc/agents/construction/tcg-executor.md` and `aidlc/templates/units.md`.
- **The main-repo workflow** `.github/workflows/pr-size.yml` was untracked on main-repo
  branch `chore/pr-size-check` at the time of writing.

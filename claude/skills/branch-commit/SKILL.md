---
name: branch-commit
description: Create the branch for a unit or ticket, rebase it onto main, and write conventional commits. Use when starting work on a unit, before pushing, or when asked to commit, stage, or write a commit message.
---

The git workflow for one unit of work. Mechanical — no judgement about *what* to build,
only about how the branch and the commits are shaped.

## 1. Branch — one per unit, not per ticket

```
<type>/SCRUM-###-u<n>-<slug>      feat/SCRUM-757-u1-comment-capture
<type>/SCRUM-###-<slug>           fix/SCRUM-863-permit-travel-type
```

Use the second form only when the work is not a unit from a `units.md` — a hotfix, a
chore, a doc change.

`<type>` is a conventional-commit type and must match what the work actually is:
`feat` `fix` `refactor` `docs` `chore` `style` `test` `perf` `build` `ci`.

`<slug>` is 2-4 words, kebab-case, describing the outcome — not the layer. `comment-capture`,
not `add-model-and-endpoint`.

**One unit per branch, one branch per PR.** Two units on one branch is one unreviewed unit,
which defeats the point of slicing them.

The client repo currently has three competing conventions in flight — `task/SCRUM-864`,
`scrum-866`, `fixes/minor-ui-11aug`. Use the form above for new work; do not rename
anyone's existing branch.

## 2. Rebase onto main — at start, and before pushing

```bash
git fetch origin
git switch -c <type>/SCRUM-###-u<n>-<slug> origin/main   # starting
# ... work ...
git fetch origin && git rebase origin/main               # before pushing
```

**Always branch from `origin/main`, never from local `main`.** Local `main` is stale more
often than not — on this project it was once 10 commits behind, and branching from it would
have silently reverted merged work into the new branch with nothing complaining.

Rebase before pushing so the branch carries whatever else has landed. If the rebase
conflicts, stop and say so — do not resolve someone else's conflict on their behalf.

Never rebase a branch someone else has checked out, and never force-push `main`.

## 3. Commit message — conventional, with a body that explains why

```
<type>(<scope>): <description>

<body — what changed and why, not how. Wrap at ~90 columns.>

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
```

**Header:** imperative mood, lowercase, no trailing period. Scope is the module or area —
`api`, `web`, `mobile`, `vault`, `aidlc`, `setup`, or a feature name like `quotations`.

**Body**, and this is where the value is:

- Say **what changed and why**, never how — the diff already shows how.
- For anything non-trivial, use short section headings rather than one long paragraph.
- **State what was deliberately not done**, and why. A reader cannot tell an omission from
  an oversight, and next week neither can you.
- Where a claim is checkable, give the evidence — the count, the command, the file.
- If something was found and left alone, say so. Silent findings get re-found.

Match the existing history: `git log` in either repo shows the house style, and it is
deliberately fuller than a one-line summary.

## 4. Rules

- **Only commit when explicitly asked.** Finishing a unit is not permission to commit it.
- **Never commit to `main` directly.** Branch first, even for a one-line fix.
- Run `git status` and `git diff --staged` before writing the message — describe what is
  actually staged, not what you remember doing.
- Stage deliberately. `git add -A` in this repo can pick up someone else's in-flight work,
  because the AI overlay and the client repo share a working tree.
- If a pre-existing gate failure blocks the commit, say which failures are pre-existing and
  which are yours. Never `--no-verify` to get past it.

## 5. Check before you hand back

```bash
git log --oneline origin/main..HEAD    # only your commits, nothing inherited
git status --short                      # nothing unintended staged or stray
```

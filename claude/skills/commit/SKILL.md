---
name: commit
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

## 2. Rebase onto main — at three moments, not one

**Starting a unit:**

```bash
git fetch origin
git switch -c <type>/SCRUM-###-u<n>-<slug> origin/main
pnpm install          # in a linked worktree: required, or the tracked hooks refuse to commit
```

**Then log it — every path, not just A.** Append one line to `.ai/aidlc/processed.log`:
date, ticket, path (A/B/C — see `aidlc/GUIDE.md` §2), branch name, you, `pr: -` (filled in
by `close-ticket` once opened), one-line note. This is the only record that a bug or small
change ever entered the loop at all, since paths B and C never get a `SCRUM-###/` folder.
Do this once per branch, at creation — not on resume.

**Resuming one — the next morning, or after any break:**

```bash
git stash list                                    # anything set aside last session?
git fetch origin
git switch <type>/SCRUM-###-u<n>-<slug>           # no -c; the branch already exists
git rebase origin/main
```

`git switch -c` on day two fails with `a branch named ... already exists`, and that failure
is the harmless case — you see it and fix it. The expensive case is the branch resumed
*without* the fetch and built on for three days against a `main` that moved on day one.
Nothing complains, and the conflict surfaces at the PR, where it is three days deep and
partly someone else's to untangle.

Rebase on resume, not only before pushing. Rebasing daily means resolving one day of drift
at a time against changes you still remember.

Check `git stash list` **before** you start, not after. A stash from a previous session is
invisible otherwise — the overlay repo is currently carrying one (`SCRUM-757 spec — set
aside 2026-08-11, not committed anywhere`) that survived precisely because nothing in this
procedure told anyone to look.

If you have uncommitted work when you resume, `git stash` before the rebase and
`git stash pop` after.

**Before pushing:**

```bash
git fetch origin && git rebase origin/main
```

**Always branch from `origin/main`, never from local `main`.** Local `main` is stale more
often than not — on this project it was once 10 commits behind, and branching from it would
have silently reverted merged work into the new branch with nothing complaining.

Rebase before pushing so the branch carries whatever else has landed. If the rebase
conflicts, stop and say so — do not resolve someone else's conflict on their behalf.

Never rebase a branch someone else has checked out, and never force-push `main`.

After a rebase, updating your own PR branch needs `git push --force-with-lease` — never a
bare `--force`, which discards a teammate's push to that branch without telling you.

**One of these is now enforced, by the client repo itself.** Since the Nx merge (PR #363)
the hooks are tracked files in `.husky/` and run in the main checkout and every linked worktree
(`pnpm install` sets `core.hooksPath=.husky`). `pre-push` refuses a direct push of `main`, then
runs `nx affected` lint (web excluded), typecheck (mobile excluded) and build against
`origin/main`. `SKIP_GATES=1 git push` skips the gates, never the branch guard; `--no-verify`
skips everything — treat that as a decision, not a habit. **The rebase-behind check is not
enforced by anything any more** — `.ai/setup.sh` no longer installs its own hook, because two
`core.hooksPath` values cannot coexist and the tracked hooks won — so *rebase before you push*
is back to being your discipline. Branch naming is not checked either.

`pre-commit` runs `lint-staged` (ESLint `--fix` + Prettier on the staged files) and then
`nx affected -t build`. Two consequences: the hook can rewrite what you staged, so re-read
`git diff --staged` if the commit was rejected and retried; and a worktree without
`node_modules` refuses to commit at all — `pnpm install` there first (fast, linked from the
store).

## 3. Commit message — conventional, with a body that explains why

```
<type>(<scope>): <description>

<body — what changed and why, not how. Wrap at ~90 columns.>
```

No `Co-Authored-By` / "Generated with" trailer on commits or PRs in either repo — that was
asked for explicitly and repeatedly.

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

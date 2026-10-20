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
which defeats the point of slicing them. Not even as "one commit per unit" on a shared
branch — PAYROLL-FLAGS shipped 21 units that way as #709 (958 files). A `units.md` that
declares "same branch, one PR" is overruled by this rule.

**A unit that depends on an unmerged unit stacks on it.** Branch from the dependency's
branch, not from `main`, and open the PR **against that branch**:

```bash
git fetch origin
git switch -c feat/SCRUM-757-u2-<slug> origin/feat/SCRUM-757-u1-<slug>
gh pr create --base feat/SCRUM-757-u1-<slug> ...
```

Open a stacked PR as **draft**. Before merging a parent, run
`gh pr list --base <parent-branch>` and retarget each result with
`gh pr edit <n> --base main` **first** — GitHub closes a PR whose base branch is deleted
unless it was retargeted (TCG-218). Mark the child ready only once its base shows `main`.
If U1 changes under review, `git rebase
origin/feat/SCRUM-757-u1-<slug>` in U2. Each PR's diff shows only its own unit.

**Sweeps never ride along.** Lint/format autofixes, import reordering, dependency or SDK
upgrades and unrelated fixes are their own branch and PR (`chore/…`, `style/…`). If
`lint-staged` reformatted whole files you only touched, that reformat goes in its own PR
first.

The client repo currently has three competing conventions in flight — `task/SCRUM-864`,
`scrum-866`, `fixes/minor-ui-11aug`. Use the form above for new work; do not rename
anyone's existing branch.

**Mirror the branch in the overlay repo, at creation — not only at `close-ticket`.** The
overlay (`.ai/`) is a separate git repo (§ "One memory, every tool" in `CLAUDE.md`), and
any `.ai/` file a ticket touches (spec, units, decisions, processed.log) is work-in-progress
on that ticket, same as the client-repo code. Leaving it uncommitted in the overlay until
`close-ticket` is why the overlay has carried unreviewed, unpushed changes past a ticket
that was otherwise done — the loop ran, the client repo shipped, and the overlay's record
of it sat local, on `main`, indistinguishable from every other tool's uncommitted scratch
state. Create the same branch name in `.ai/` the moment you branch the client repo:

```bash
cd .ai && git fetch origin && git switch -c <type>/SCRUM-###-u<n>-<slug> origin/main
```

Use the identical branch name in both repos — that is what makes `git status` in `.ai/`
during a review answer "which ticket is this" without cross-referencing anything. Commit
`.ai/` changes into that branch as they happen (spec updates, unit files, `processed.log`
append), not as one batch at the end.

**In a linked worktree (`pnpm worktree:add`), the mirror already exists.** Bootstrap created
an overlay worktree on the client branch name and symlinked it as `.ai` — do **not**
`git switch` inside it (each overlay worktree is pinned to its branch). Just commit into
`.ai/` as above. Remember the branch is invisible to the team until published:
`pnpm worktree:done` at close merges it into overlay main.

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

**Resuming one — the next morning, or after any break:** if the ticket has a folder, read
its `state.md` → **Resume** first; it says what was last done and what is next.

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

**Do this in both repos, every time — never push one without the other.** A push that
updates the client repo's branch but leaves `.ai/`'s matching branch behind (or vice versa)
is how the two repos drift out of the "one memory, every tool" invariant: the branch name
matches but the content behind it doesn't, which is worse than an obvious mismatch because
nothing flags it. Fetch and rebase `.ai/` onto its `origin/main` in the same pass as the
client repo, then push both:

```bash
cd .ai && git fetch origin && git rebase origin/main && git push
cd ..    && git fetch origin && git rebase origin/main && git push
```

If one push succeeds and the other fails (conflict, rejected, gate failure), stop and
resolve it before continuing — do not leave the two repos' branches pointing at
inconsistent states of the same ticket.

**Always branch from `origin/main`, never from local `main`.** Local `main` is stale more
often than not — on this project it was once 10 commits behind, and branching from it would
have silently reverted merged work into the new branch with nothing complaining.

Rebase before pushing so the branch carries whatever else has landed. If the rebase
conflicts, stop and say so — do not resolve someone else's conflict on their behalf.

Never rebase a branch someone else has checked out, and never force-push `main`.

After a rebase, updating your own PR branch needs `git push --force-with-lease` — never a
bare `--force`, which discards a teammate's push to that branch without telling you.

**Only the branch guard is enforced.** Since the Nx merge (PR #363) the hooks are tracked
files in `.husky/` and run in the main checkout and every linked worktree (`pnpm install` sets
`core.hooksPath=.husky`). `pre-push` refuses a direct push of `main` — and nothing else: its
`nx affected` lint/typecheck/build block is commented out, `SKIP_GATES=1` is a no-op, and the
hook's own comment "CI runs them on the PR instead" is false — CI runs only `deploy.yml` and
`pr-size.yml`. **Run the gates yourself before you push.** `--no-verify` skips the branch
guard too — treat that as a decision, not a habit. **The rebase-behind check is not
enforced by anything any more** — `.ai/setup.sh` no longer installs its own hook, because two
`core.hooksPath` values cannot coexist and the tracked hooks won — so *rebase before you push*
is back to being your discipline. Branch naming is not checked either.

`pre-commit` runs `lint-staged` only (ESLint `--fix` + Prettier on the staged files) —
no build. Two consequences: the hook can rewrite what you staged, so re-read
`git diff --staged` if the commit was rejected and retried; and a worktree without
`node_modules` refuses to commit at all — `pnpm install` there first (fast, linked from the
store). Build, lint, and typecheck stay on `pre-push`.

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

- **Strict developer identity**: Author and Committer MUST strictly be the human developer. NEVER designate Claude or any AI tool as author or committer, and NEVER include `Co-Authored-By`, `Committer: Claude`, or AI attribution trailers in commit messages or git metadata.
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

## 6. PR description — the record for Paths B and C

Path A records structural decisions in `spec.md`. Paths B and C have no spec, so the PR
description is the only record — and `review-pr` reads it. Every PR carries these two
sections, even when they say "none":

```markdown
## AI decisions
| Decision | Chosen | Why | Alternatives |
| --- | --- | --- | --- |
| New column `foo.bar` vs reuse `foo.baz` | reuse `foo.baz` | same value, one source | new column; derived value |

## Siblings
| Sibling (pattern) | Same change? | Done here / follow-up / why not |
| --- | --- | --- |
| `apps/api/src/usecase/agencies` (P1) | yes | done in this PR |
| `apps/api/src/usecase/yards` (P1) | yes | follow-up — separate job, own ticket |
```

- **Structural** means a new table/column/enum/relation, a new exported function vs reuse, a
  new endpoint or shape, a pattern choice or deviation. Private helpers do not go here.
- **The AI fills the table**, including its own choices — every one, with why. **The
  reviewer approves the table by approving the PR**; a choice they would make differently is
  a review comment. A guardrail item (root `CLAUDE.md` → G1–G5) is not decided here — it was
  asked before the build.
- **Siblings** come from `.ai/claude/contexts/patterns.md` plus a `git grep`. "None — no
  pattern entry and no other instance found by `<command>`" is a valid row; an empty
  section is not.

## 7. Size

No line or file budget (removed 2026-10-21). Before pushing, check only that the diff holds
this unit or task and nothing else — a sweep or an unrelated fix comes out into its own PR.

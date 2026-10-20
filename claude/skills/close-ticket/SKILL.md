---
name: close-ticket
description: Run the writeback after a PR merges — reflection, gap disposition, decision notes, the reflections index, the demo walkthrough, and pushing the overlay. Use when a PR is merged, when a ticket is being closed, or when asked what still needs recording from work that has shipped.
---

What the loop learned, written down before the context is gone.

Merging is the moment the loop's memory either updates or silently does not. Everything
here is recoverable for about a day and expensive to reconstruct after that — which is why
this is a checklist and not a habit.

**Not every step runs on every ticket.** Steps 1, 4, 6 and 7 always run. Steps 2, 3 and 5
depend on the path the ticket took, and §"How much of this runs" says which.

---

## The one thing this never does

**Shipped behaviour does not become product memory.** Do not write what was built into
`.ai/vault/<module>/` content folders. Not as an update, not as a note, not as a "clarification".

The vault answers *what should this do?* If code becomes an answer there, the next spec is
sourced from the last implementation and the loop is validating itself — a decision someone
made in ten seconds while building becomes a requirement, and nobody can tell it from one a
human made. That is the failure the whole design is arranged to prevent, and merge day is
when the temptation is strongest, because the code is right there and the vault is visibly
stale.

The honest handling of that staleness is **step 3**: record where the vault turned out to be
wrong as findings and gaps, so a human adjudicates it. Not as edits.

---

## 1. Confirm what actually merged

```bash
git fetch origin
git log --oneline origin/main --grep='SCRUM-###'     # what landed
gh pr list --state merged --search 'SCRUM-###'        # which PRs, and when
```

Name the units that shipped, and the ones that did not. A unit that was cut, abandoned, or
partly built is the most valuable line in the reflection and the easiest to forget once the
branch is deleted. In `units.md`'s ledger, flip each merged unit's Status from `built — <branch>`
to `merged — PR #<n>` (the executor writes the cell up to `built`; this is the only other
writer).

If units are still open, this is not a close — it is a checkpoint. Do steps 4, 6 and 7 and
stop.

## 2. Reflect — `tcg-reflector`

Give it the spec, the units, the merged diff and the analyst's verdict. It reads
`.ai/aidlc/reflections/INDEX.md` first, writes `.ai/aidlc/SCRUM-###/reflection.md`, and
appends one row per defect.

**It proposes rule changes and cannot apply them.** Applying is yours, and it is a separate
decision from accepting: a proposal you agree with but do not apply is `proposed` in the
index, not `applied`. Do not mark rows `applied` for edits you have not made.

## 3. Disposition §3 — the vault findings

§3 of the reflection is the feedback path into the vault and the step most often skipped,
because nothing downstream fails when you skip it. Every line needs an outcome:

| Finding | What it becomes |
| --- | --- |
| A source that turned out wrong or stale | A `spec.md` §12 question. **Never an edit to the source** |
| A conflict that surfaced during the build | A `spec.md` §12 question, or evidence appended to an existing one |
| A question a named human answered during the build | `tcg-scrum` → `vault/decisions/YYYY-MM-DD-topic.md`, **now** |
| A gap this ticket should close | `tcg-scrum` → the four-step closure, in one pass |
| An undefined term hit | `spec.md` §12, tagged with the term |

The one with a deadline is the third. An answer given in a call during the build exists
only in whoever's memory and in the code that assumed it; a week later nobody can say
whether it was decided or inferred. If it is not written, the same question is asked again
next sprint and may get a different answer.

## 4. Gaps opened during the work

Whatever path the ticket took, the executor and analyst may have appended questions to §12
of the ticket's `spec.md`. Check they are phrased so a one-line reply resolves them, and that
each names an owner. A gap nobody owns is a note.

Ticket questions stay in §12 — they are not promoted to the vault at close. What does move
is the **answer**: a question a human settled during the build becomes
`vault/decisions/YYYY-MM-DD-topic.md` via `tcg-scrum`, and the §12 entry's `Status:` line is
flipped to point at it.

```bash
git -C .ai diff origin/main -- aidlc/SCRUM-###/spec.md
git -C .ai diff origin/main -- vault/gaps.md vault/payroll/gaps.md   # should be empty for a ticket
grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/[A-Z]*/spec.md               # everything still open, all tickets
```

## 5. Keep the demo walkthrough true

`claude/skills/demo-walkthrough/WALKTHROUGH.md` pins the platform's surfaces — URLs, sidebar
labels, required form fields, expected payroll numbers, and a ranked list of live defects. A
merged ticket routinely makes some of that wrong, and **nothing fails when it does**: the file
is only read on demo day, by which point the person reading it is in front of an audience.

**This is not vault content and this step is not an exception to §"The one thing this never
does".** The walkthrough answers *how do I make it do the thing?*; the vault answers *what
should it do?* Updating a runbook to match shipped code is correct. Writing shipped behaviour
into `vault/<module>/` is still forbidden, and still step 3's job to route as a finding.

Decide in ten seconds — does this ticket's diff touch a pinned surface?

```bash
git diff --name-only origin/main~1 origin/main | grep -E \
  'app/\(protected\)/|components/sidebar/|-form\.ts|\.schema\.ts|payroll-engine/|usecase/payroll/|seed-data|\.env'
```

| Hit | Update |
| --- | --- |
| `app/(protected)/**` | the URL in that phase |
| `components/sidebar/**` | §1.3's sidebar map, and every `**Sidebar:**` line it changed |
| a form schema | the required-field list in that phase |
| `payroll-engine/**`, `usecase/payroll/**` | phase 13's expected numbers |
| seeding / provisioning / env | phase 0 and Appendix C |

**And the one nobody remembers: if this ticket fixed something in Appendix B, strike the row.**
Move it to Appendix B → *Fixed*, with the PR number. A defect list that still cries wolf about
last sprint's fix gets ignored wholesale, which loses the entries that are still real — and a
struck row kept with its PR is what makes a later regression legible as a regression.

No hits, no edit. Say so in the hand-back rather than leaving it ambiguous.

## 6. Fill in the ledger row

Find this ticket's row in `.ai/aidlc/processed.log` (written by `commit` at branch
creation) and fill in the `pr` column with the merged PR number — that row is the only
proof, for a path B/C ticket, that it ever ran the loop. Never edit any other column.

If the ticket has a folder, mark **Merged** (with the PR number) and **Closed** in its
`state.md` and rewrite **Resume** to `closed — nothing pending`, or to whatever this run left
open. A folder without a `state.md` predates the file; create one from
`.ai/aidlc/templates/state.md` only if work on the ticket is still pending.

## 7. Push the overlay

```bash
git -C .ai status --short
git -C .ai add -A && git -C .ai commit && git -C .ai push
```

The overlay is a separate repo on purpose. The consequence is that **every artifact above
lives on one laptop until this runs** — the reflection, the decision notes, the gap entries,
the index rows, the walkthrough edits. None of it is memory yet.

**In a linked worktree, this push is not enough.** `.ai` there is an overlay worktree on a
per-ticket branch, so the push above lands on that branch — which nobody reads. Finish with:

```bash
pnpm worktree:done        # from the client worktree
```

It merges the ticket overlay branch into overlay **main**, pushes, and retires the overlay
worktree. A fact on a ticket overlay branch is not memory yet; only overlay main is.

Check `git -C .ai stash list` too. A stash from an earlier session is invisible otherwise,
and this repo has already lost a spec that way.

---

## How much of this runs

Matching the paths in `aidlc/GUIDE.md` → *Not every ticket runs the full loop*:

| Path | Steps |
| --- | --- |
| **A — full loop** | All seven |
| **B — bug fix** | 1, 4, 6, 7 always. Step 2 when the bug had a cause worth recording — a missing rule, or a third occurrence of something. Step 3 whenever the bug came from the documentation being wrong, which for a bug is common. Step 5 when the grep hits — **and a bug fix is the likeliest path to strike an Appendix B row** |
| **C — small change** | 1, 4, 6, 7. Reflection almost never. Step 5 when the grep hits — a one-line route or label change is exactly the kind that does |

**Steps 4, 6 and 7 have no exemption.** They are the ones that cost nothing and lose
everything — an unpushed overlay makes every other step on this list private, a C-path
change that opened a gap is exactly as important as an A-path one that did, and a ledger row
never filled in with its PR number is the only place a path B/C ticket's completion was ever
going to be recorded.

**Step 5 is conditional on purpose.** Most tickets touch nothing the walkthrough pins, and a
mandatory step that is usually a no-op is a step people stop reading. The grep decides it, not
judgment.

---

## Hand back

```
Ticket closed: SCRUM-###

Shipped:      U1…Un  <or: which shipped, which did not, and why>
Reflection:   <path | skipped — path B/C, no cause worth recording>
Index rows:   <n appended, classes — or none>
Decisions:    <paths written | none — no human answered anything during the build>
Gaps:         opened <n>, closed <n>, partially closed <n — name them>
Walkthrough:  <phases updated, Appendix B rows struck → Fixed | untouched — grep found no pinned surface>
Ledger:       processed.log row filled in with PR #<n> | NOT FOUND — <why>
Overlay:      pushed <sha> | NOT PUSHED — <why>
Rule changes: <n proposed, n applied by me, n left as proposed>
Stale queue:  <n proposed rows in reflections/INDEX.md older than this ticket's close, classes — or none>
```

Anything partially closed, or an unpushed overlay, goes **first**.

Before printing the hand-back, grep `.ai/aidlc/reflections/INDEX.md` for `Status: proposed`
rows older than the immediately preceding ticket's close, and list their count and classes
in the hand-back even when this ticket did not cause them. A proposal queue that only
close-ticket ever reads is a queue nobody reads — `gate-illusion` hit its 3rd occurrence
(SCRUM-900, then SCRUM-926) with the first two proposals still sitting unapplied the whole
time (`.ai/aidlc/SCRUM-926/reflection.md` ED-4).

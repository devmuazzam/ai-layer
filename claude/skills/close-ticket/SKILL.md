---
name: close-ticket
description: Run the writeback after a PR merges — reflection, gap disposition, decision notes, the reflections index, and pushing the overlay. Use when a PR is merged, when a ticket is being closed, or when asked what still needs recording from work that has shipped.
---

What the loop learned, written down before the context is gone.

Merging is the moment the loop's memory either updates or silently does not. Everything
here is recoverable for about a day and expensive to reconstruct after that — which is why
this is a checklist and not a habit.

**Not every step runs on every ticket.** Steps 1, 4, 5 and 6 always run. Steps 2 and 3
depend on the path the ticket took, and §"How much of this runs" says which.

---

## The one thing this never does

**Shipped behaviour does not become product memory.** Do not write what was built into
`.ai/vault/product/`. Not as an update, not as a note, not as a "clarification".

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
branch is deleted.

If units are still open, this is not a close — it is a checkpoint. Do steps 4, 5 and 6 and
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
grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md                # everything still open, all tickets
```

## 5. Fill in the ledger row, then push the overlay

Find this ticket's row in `.ai/aidlc/processed.log` (written by `commit` at branch
creation) and fill in the `pr` column with the merged PR number — that row is the only
proof, for a path B/C ticket, that it ever ran the loop. Never edit any other column.

## 6. Push the overlay

```bash
git -C .ai status --short
git -C .ai add -A && git -C .ai commit && git -C .ai push
```

The overlay is a separate repo on purpose. The consequence is that **every artifact above
lives on one laptop until this runs** — the reflection, the decision notes, the gap entries,
the index rows. None of it is memory yet.

Check `git -C .ai stash list` too. A stash from an earlier session is invisible otherwise,
and this repo has already lost a spec that way.

---

## How much of this runs

Matching the paths in `aidlc/GUIDE.md` → *Not every ticket runs the full loop*:

| Path | Steps |
| --- | --- |
| **A — full loop** | All six |
| **B — bug fix** | 1, 4, 5, 6 always. Step 2 when the bug had a cause worth recording — a missing rule, or a third occurrence of something. Step 3 whenever the bug came from the documentation being wrong, which for a bug is common |
| **C — small change** | 1, 4, 5, 6. Reflection almost never |

**Steps 4, 5 and 6 have no exemption.** They are the ones that cost nothing and lose
everything — an unpushed overlay makes every other step on this list private, a C-path
change that opened a gap is exactly as important as an A-path one that did, and a ledger row
never filled in with its PR number is the only place a path B/C ticket's completion was ever
going to be recorded.

---

## Hand back

```
Ticket closed: SCRUM-###

Shipped:      U1…Un  <or: which shipped, which did not, and why>
Reflection:   <path | skipped — path B/C, no cause worth recording>
Index rows:   <n appended, classes — or none>
Decisions:    <paths written | none — no human answered anything during the build>
Gaps:         opened <n>, closed <n>, partially closed <n — name them>
Ledger:       processed.log row filled in with PR #<n> | NOT FOUND — <why>
Overlay:      pushed <sha> | NOT PUSHED — <why>
Rule changes: <n proposed, n applied by me, n left as proposed>
```

Anything partially closed, or an unpushed overlay, goes **first**.

# AI-DLC — how it works, end to end

Read this before running a ticket through the loop for the first time.

The reference documents describe each piece. This one describes how they fit together, why
each part exists, and what to expect on a real run.

---

## 1. What this solves

Eight developers, four surfaces, and a product record that is mostly **unverified**: 157
vault files, of which only 6 (the `domain/` SOP set) have been adjudicated by a human, with
13 open questions and 6 topics where several documents disagree.

In that situation the expensive failure is not bad code. It is **a plausible answer to an
unanswered question**, written confidently, built, reviewed, merged, and depended on. By the
time it surfaces, three modules read from it and the person who could have settled it in one
line never knew they were asked.

AI-DLC is built around one property: **the loop stops rather than guesses.** Every phase can
refuse. That is the feature, and it is the part that will feel wrong on day one.

---

## 2. The loop

```
  ticket
    │
    ▼
┌─ INCEPTION ─────────────────────────────────────────────┐
│  intent.md  ──elaborator──▶  spec.md  ──decomposer──▶  units.md
│                  │ stops and asks          │ never resolves an [OPEN]
└──────────────────┼──────────────────────────┼───────────┘
                   │                          ▼
                   │            ┌─ CONSTRUCTION ──────────────────┐
                   │            │  one unit ──executor──▶ code    │
                   │            │       │ stops on [OPEN]         │
                   │            │       ▼                         │
                   │            │  code ──analyst──▶ verdict      │
                   │            └──────────────┼──────────────────┘
                   │                           ▼
                   │            ┌─ REFLECTION ────────────────────┐
                   │            │  what shipped ──reflector──▶    │
                   │            │       reflection.md + proposed  │
                   │            │       rule changes              │
                   │            └─────────────────────────────────┘
                   │
              tcg-scrum ── runs alongside all of it, unblocking from written
                           sources or escalating honestly
```

**One artifact per phase, and the next phase reads it.** Nothing is passed by conversation.

### Not every ticket runs the full loop

The diagram above is the **feature** path. Running it for a bug or a one-line UI change is
absurd, and pretending otherwise is how a process gets abandoned in week two.

The expensive half of the loop — elaboration and decomposition — exists to answer *"what
should this do?"* On most bugs and small changes that answer already exists: the system
claims a behaviour and fails to deliver it, or the change is stated on the ticket. Skipping
those phases is not cutting a corner. It is not paying twice for an answer you have.

| Ticket | Path | What runs |
| --- | --- | --- |
| **New behaviour**, anything needing product intent | **A — full loop** | intent → spec → units → execute → analyse → reflect |
| **Bug** — the behaviour is specified, or the bug *is* the deviation | **B — repro → fix → check** | reproduce, `tcg-executor` against the repro, `tcg-analyst`. No spec, no units |
| **Small change** — copy, spacing, a column, a variant | **C — just build it** | `find-component` if it is UI, build, self-review. One branch, one PR |

Reflection is worth running on B whenever the bug had a *cause worth recording* — a missing
rule, a third repeat. It is almost never worth it on C.

### The escalation rule is what makes B and C safe

**A path becomes Path A only when the work needs client-facing behaviour nobody specified,
or one side of a vault conflict** (root `CLAUDE.md` → guardrail G1). Everything else nobody
specified is decided and recorded, not escalated — that is what keeps B and C fast without
hiding choices: the PR's _AI decisions_ table makes each one visible to the reviewer.

Escalate when:

- **Fixing the bug means deciding client-facing behaviour** — what a customer sees, who may
  act, what money moves. "Fix the sort order" is *not* one: pick the order the nearest
  screen uses and record it.
- The ticket says *"make it consistent with X"* and X is one side of an open vault conflict.

Schema, tenancy and API shape call `tcg-prisma-guardian` / `tcg-contract-tracer` on every
path, without escalating. A value nobody stated — a length, a default, a page size — is
decided and recorded, not escalated.

TCG-237 (role and department) and TICKET-FLOW-SLOTS-HOLDOVER are why: escalating every
unstated value produced 70+ questions per ticket, most answered by the developer, and turned
a day's build into several (`vault/decisions/2026-10-21-capability-first-…`).

### Every path leaves one line, even the ones with no folder

Path A gets `.ai/aidlc/SCRUM-###/` as visible proof it ran. Paths B and C are designed to
skip that folder — and by design, that also means nothing anywhere records that they ran at
all. There is no way to tell "path C, correctly skipped the folder" from "never touched the
loop" apart from this.

The `commit` skill appends one line to `.ai/aidlc/processed.log` at branch creation, on
every path: ticket, path taken, branch, date, who. `close-ticket` fills in the PR number
once it merges. It is the one artifact every ticket produces regardless of path, and it is
what "was this ticket processed?" actually greps.

### What runs on every path

The tools and skills are phase-independent **by design**, which is exactly why this works:

- `commit` — one unit or ticket, one branch, one PR. Always.
- `tcg-prisma-guardian` / `tcg-contract-tracer` — whenever schema or a contract moves.
- `tcg-scrum` — whenever anyone is blocked on how something is meant to work.
- `review-pr` — the ad-hoc review path when there is no unit for `tcg-analyst` to check
  against. This is the normal reviewer for B and C.

So a bug fix still gets the isolation check, the contract check, the branch discipline and a
vault-aware review. It just does not get a spec it did not need.

---

## 3. Three rules that bind everything

Everything else follows from these.

**Rules govern *how* we build, never *what* to build.** `contexts/api.md` can tell you a
repository must not import a controller. It can never tell you the feature needs an approval
step. A rule can make a requirement unnecessary; it can never make one true.

**Sources are cited and status-tagged.** Every requirement names where it came from and
whether a human ever checked it. Almost everything is `unverified` — that does not mean
wrong, it means nobody confirmed. A spec that hides that has laundered its sources, and the
executor will treat all of them as settled.

**Conflicts are surfaced, never resolved and never merged.** Where documents disagree, name
every candidate and stop. Merging two disagreeing documents produces a third that nobody
wrote and nobody can be asked about. It reads as synthesis; it is fabrication with better
prose. *Recency is not authority* — the newest field-ops document is the smallest and the
one marked DRAFT.

---

## 4. Inception — what are we building?

### `tcg-elaborator` · intent → `spec.md` · Sonnet default, Opus on escalation

Reads the ticket, the vault (index first, then the conflict stub, then the file), and the
rules for the surfaces involved. Produces a spec where every requirement carries its sources
and their status, then **stops and asks** whatever it could not source.

**It never implements.** Not a scaffold, not "a quick shape to show the idea". A scaffold
commits the file layout, the DTO fields and the route identity before the open questions are
answered — and scaffolds get filled in, not revisited.

**A thin ticket is not an invitation to reconstruct.** It will read the code, because on
brownfield work you cannot describe a change without knowing what exists. But reading code
yields *questions*, never a filled requirement. Three files agreeing in the codebase is
still zero sources — it means one person was consistent.

*Expect:* on a thin ticket, a spec that is mostly `[OPEN]`. That is correct output.

### `tcg-decomposer` · spec → `units.md` · Sonnet default, Opus on escalation

Slices an approved spec into **vertical units**: schema → API → UI → tests for one piece of
behaviour, each reviewable alone.

The test for every unit: *if this ships alone, what can someone do that they could not
before?* If the answer is "nothing, it's the backend half", it is not a unit.

**Layer splits are the failure it exists to prevent** — "add the model", "write the
endpoints", "build the UI" looks like a plan and produces PRs that merge without delivering
anything, with a reviewer who has nothing to check the schema against.

**A unit may not depend on an `[OPEN]` requirement.** It either gets cut down to the part
that does not, or it waits.

### Why two agents and not one

They fail differently. The elaborator's risk is inventing requirements; the decomposer's is
slicing badly. One agent doing both would resolve its own open questions while slicing —
which is the laundering both exist to prevent.

---

## 5. Construction — build it, then check it honestly

### `tcg-executor` · one unit → code · inherits the session — set it to Sonnet

Branches from `origin/main` (`<type>/SCRUM-###-u<n>-<slug>`), builds the unit completely,
runs the gates, stops.

**The gaps it fills silently are the ones that cost.** A field length, a default, a status
enum, an error string — each is a one-line decision while building and none looks like a
decision afterwards. It lands in a migration, three modules read from it, and nobody knows
it was ever chosen. So: hit something the spec never settled → **stop that part**, build the
rest, log the question.

`NOT SPECIFIED` is a complete answer. A unit 80% built with a named blocker beats one 100%
built on four invented details.

**Existing code is not permission.** This repo will actively mislead you: 421 upward API
import lines across 151 files, 593 hardcoded colour values, three overlapping component
libraries. Matching a violation is not consistency.

Read those counts precisely — **most of the 421 are type-only imports that compile away**,
and 11 are genuine runtime inversions. The distinction matters here because the raw number
is what makes upward imports look normal, and the eleven are what actually couple the
layers. `.ai/SUCCESS.md` §1 carries the split and how it was measured.

### `tcg-analyst` · code → verdict · Sonnet default, Opus on escalation

Reviews the built unit against the unit and the spec. **Every finding is tagged VERIFIED
(with the command that established it) or INFERRED (reasoned from reading), never blended.**

That tagging is the product, not bookkeeping. A review that mixes them spends the reviewer's
trust on claims that did not earn it, and is indistinguishable from a careful one until
someone acts on a wrong finding.

Its distinctive pass — the one only it does: take every **concrete detail** in the diff and
ask *which requirement says this?* A `pageSize = 25` that traces to nothing is an invented
decision, and it is nearly invisible in a normal review because it always looks reasonable.

**Know what green means here.** Lint enforces no module boundaries, no duplication, no
hardcoded colour, and `any` is only a warning. It also fails on ~14 pre-existing errors in
`apps/web`. Passing lint is not evidence a convention was followed.

### Why the builder and the checker are separate

The context that makes an executor good at building makes it bad at reviewing itself. It
knows what it *meant*, so it reads the diff as the intention rather than as the bytes. Every
gap it filled is invisible to it, because from the inside those were not decisions.

---

## 6. Reflection — so the next ticket is cheaper

### `tcg-reflector` · what shipped → `reflection.md` · Sonnet default, Opus on third occurrence

Three questions: what did the spec miss, what did the executor build against it, and which
rule would have prevented it.

**A guess that turned out right is still a spec defect.** The next person in the same hole
guesses differently, and nobody will know why the first guess was allowed to stand.

**Third occurrence escalates structurally.** Once is noise, twice a coincidence, three times
is a property of the system — and fixing it in the ticket again is choosing to pay for it
forever. When it escalates, it must say *why the previous fix did not hold*: the rule was
never written, was written where nobody reads, or was written and ignored. Those need
different remedies.

**It proposes rule changes; it never applies them.** And a proposal must be applicable
without rewriting — the exact sentence, not "clarify the migration rule". Prefer a rail over
a reminder: this codebase has documented cases of rules that were present, correct, and
violated hundreds of times because nothing checked them.

---

## 7. Alongside: `tcg-scrum` · Opus — the one agent that keeps it

Not a phase. Answers *"how is this supposed to work?"* from written sources at any point in
the loop, or escalates honestly.

It is the only agent with write access to `.ai/vault/decisions/`, so when a human answers a
question during a build, **scrum is what makes the answer durable**. Otherwise it is lost
and the same question gets asked next sprint.

---

## 8. Tools — called by any phase

Two specialists in `agents/tools/`. They run in their own context, report, and never fix.

**`tcg-contract-tracer`** · mid tier — *"this API shape changed; what breaks?"* The monorepo
has 177 DTOs, ~90 web callers, ~25 mobile callers, and only the ~124 files importing
`@tcg/shared` are compile-checked. Everything else models responses locally, so a renamed
field lands as `undefined` at runtime while API tests stay green. Four independent search
passes, because each finds callers the others miss. Mobile grades **higher** than web — its
own client, and a shipped build cannot be hotfixed.

**`tcg-prisma-guardian`** · mid tier — *"is this schema change safe and isolated?"* Isolation
first, because tenant scoping here is a `$extends` client extension with an allowlist and
three skip conditions (no request context, `SUPER_ADMIN`, model not in the allowlist), and
**nothing enforces it**. A model holding tenant data but absent from the allowlist leaks
across tenants and passes every gate.

### Why tools are separate from phases

They are not a step. An executor calls the tracer mid-build; an analyst calls it during
review; a decomposer might call it while slicing to see how wide a change reaches. Binding
them to a phase would mean duplicating them into three.

They sit at **mid tier deliberately**: exhaustive checking against a known rule, where
breadth matters more than judgement and the failure mode is *missing* something rather than
*misjudging* it. Where either hits a real decision, it reports and stops.

---

## 9. Skills — task-triggered, no phase

| Skill | Fires on |
| --- | --- |
| `commit` | Branch naming, rebase from `origin/main` at start **and on resume**, conventional commits |
| `close-ticket` | A PR merged — the writeback that merging does not do by itself |
| `review-pr` | Ad-hoc PR review — **against the vault as well as the code** |
| `lint-triage` | Which failures are mine vs the pre-existing ones (37 in `apps/web` as of 2026-08-19) |
| `find-component` | Search all nine `components/` directories before creating |
| `debug-api` | Failing endpoint — four global guards, tenancy checked early |
| `demo-walkthrough` | Fresh tenant → calculated payroll; kept true by `close-ticket` step 5 |

Skills are procedures the current session follows. Agents get their own context and model
tier. Cheap mechanical work belongs in a skill; judgement belongs in an agent.

`review-pr` overlaps `tcg-analyst` deliberately: the analyst owns the verdict for a unit
built through the loop; the skill is the ad-hoc path for a PR with no unit behind it.

---

## 10. Where things live

```
.ai/aidlc/SCRUM-###/   (also TCG-### and named folders — sweep them as .ai/aidlc/[A-Z]*/)
  state.md        where the ticket is in the loop: one row per phase, and a Resume
                  paragraph the next session reads first. Progress only — it points at
                  units.md and §12, never copies them. Every phase agent updates it once,
                  at the end of its run
  intent.md       ticket capture, before elaboration
  spec.md         the elaborator's output — what an executor builds from
  units.md        the decomposer's output — vertical slices
  reflection.md   after units ship, before the ticket closes

.ai/aidlc/processed.log
                  one line per ticket, every path — written by `commit` at branch
                  creation, PR number filled in by `close-ticket`. The only record that
                  a path B/C ticket ever entered the loop

.ai/aidlc/reflections/INDEX.md
                  every defect from every ticket, one line each — the loop's memory
                  across tickets, and the queue for proposed rule changes

.ai/vault/        product knowledge — INDEX.md first, always
.ai/vault/<module>/gaps.md  open questions belonging to no ticket, one register per
                  module (payroll included) — read by section. The root vault/gaps.md
                  and payroll/gaps-2026-08-20-retired.md are retired and frozen
.ai/vault/decisions/  what a named human settled, and why
.ai/claude/contexts/  how to build, per surface
```

**Where a fact goes, and who writes it.** Never in a tool's own memory, rules or saved
prompts — a fact kept there is invisible to the other developers and tools, and nothing
reports the divergence. If deleting your tool's local state would lose it, it is not memory
yet.

| What you learned | Where it goes | Who writes it |
| --- | --- | --- |
| A named human decided something | `.ai/vault/decisions/` | `tcg-scrum` |
| An open question raised by a ticket | `.ai/aidlc/<TICKET>/spec.md` §12 | any agent, append |
| An open question belonging to no ticket | `.ai/vault/<module>/gaps.md` (`vault/STRUCTURE.md` → _Where a question goes_) | any agent, append |
| How we build — a convention, a rail | `.ai/claude/contexts/` (recurring shapes: `patterns.md`) | Haris only |
| A defect the loop made | `.ai/aidlc/reflections/INDEX.md` | `tcg-reflector` |

Sweeps: every ticket `grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/[A-Z]*/spec.md` · every
module `grep -rn '^- \*\*Status:\*\* open' .ai/vault/*/gaps.md`. A fact reaches the team only
once the overlay is pushed — in a linked worktree, once `pnpm worktree:done` merges its
branch into overlay `main`. Skills and subagents are Claude Code features; on other tools,
open `.ai/claude/skills/<name>/SKILL.md` and `.ai/aidlc/agents/` by path.

**Three memories, three clocks, and they are not interchangeable.** `vault/` is what the
product should do and only a human changes it. `contexts/` is how we build and only an
accepted reflection changes it. `aidlc/SCRUM-###/` is one ticket and goes inert when it
closes. `reflections/INDEX.md` is the only thing that spans tickets, which is why the
recurrence rule reads it rather than the reflections themselves.

**Nothing writes shipped behaviour back into `vault/`, ever.** That is not an omission. If
code becomes a source there, the next spec is sourced from the last implementation and the
loop validates itself.

**Templates fix the field set.** A field is never deleted; an unfillable one is marked
`NOT SPECIFIED`, `N/A — <reason>` or `OPEN — <question>`. A blank field and a deleted field
are indistinguishable to the next agent, and underfilled artifacts are the expected failure
mode with eight people filling them.

---

## 11. A pass, end to end

1. **Capture** the ticket into `.ai/aidlc/SCRUM-###/intent.md` from the template. Fields it
   cannot fill get `NOT ON TICKET` — those markers are findings.
2. **Elaborate.** `tcg-elaborator` → `spec.md`, then stops with its questions. Answer what
   you can. Where a named human answers, have `tcg-scrum` write it into `vault/decisions/`
   or it is lost.
3. **Decompose.** Once the blocking questions are answered, `tcg-decomposer` → `units.md`.
   Check the first unit proves something about the rest of the plan.
4. **Build U1.** `tcg-executor` branches, builds, runs gates, reports what it stopped on.
5. **Review.** `tcg-analyst` — and delegate to `prisma-guardian` if the schema moved, or
   `contract-tracer` if a response shape changed.
6. **Merge, then repeat 4–5** for each unit.
7. **Close the ticket** — the `close-ticket` skill. Reflect, disposition the reflection's
   vault findings, write any decision a human gave you during the build, append to
   `reflections/INDEX.md`, push the overlay. Apply the rule changes you accept; the
   reflector proposes, humans apply.

   **Merging updates no memory by itself.** Nothing fails when this step is skipped, which
   is exactly why it needs to be a step: the branch is deleted, the reflection is never
   written, and the answer a human gave in a call on day two exists only in the code that
   assumed it.

---

## 12. Running it for real — what to expect

Every phase agent has now run on real tickets (`reflections/INDEX.md` holds defects from nine
of them). The **third-occurrence escalation** first ran on 2026-10-20, after
`missing-requirement` had reached 19 rows and `gate-illusion` 14: each became one structural
rule (the spec template's **Edges** block; the units template's **Gate baseline**) and 41
queued proposals were applied in one pass. Keep the queue short — a proposal left `proposed`
for weeks is how a class reaches 19.

Expect, in rough order of likelihood:

- **Lots of `[OPEN]`.** 13 gaps are already open and most of the vault is unverified. A spec
  that is half questions is the system working, not failing.
- **The stop will feel wrong.** Someone will ask the elaborator to "just scaffold it". The
  refusal costs real time and is still correct — that is the whole design.
- **Template/agent mismatches.** The templates were written before some of the agents.
  Where they disagree, the template's field list is the contract; note the mismatch for the
  reflector.
- **A unit that is not really vertical.** Apply the ships-alone test hard on the first pass;
  it is the easiest thing to get wrong and the most expensive to discover at merge.
- **Stale references.** A sweep on 2026-08-12 repointed the templates, the elaborator's
  surface table and the skill references at their current paths. Expect more: this layer has
  been restructured twice and a reference that still resolves is not proof it is current.
  Propose fixes through the reflector rather than editing mid-run.

### Make sure the agent actually has the context

**Check it mechanically. Do not ask the model.**

Both lines go in the **Claude Code chat**, not in a terminal:

```
read apps/api/src/main.ts
/context
```

Then look under **Memory files** for `apps/api/CLAUDE.md`.

`/context` is a Claude Code slash command — typing it in a shell just gives you
`no such file or directory`. It reports which instruction files actually loaded, which is an
observation rather than a self-report. That distinction is the whole reason PRE-FLIGHT 0 sat
open: asking a model what is in its own context is the single method that cannot be trusted
for this. For a permanent record, the `InstructionsLoaded` hook logs which files load, when,
and why.

**What counts as the trigger — confirmed in Claude Code's documentation**, not inferred:
subdirectory `CLAUDE.md` files are *"included when Claude reads files in those directories"*
rather than loaded at launch.

| | Loads the nested context? |
| --- | --- |
| Claude using its **Read tool** on a file in that directory | **yes** |
| A `cd` inside a bash command | no |
| **You** running `cat` in your own terminal | no — Claude is not involved at all |
| Claude running `cat` via bash | probably not — the trigger is reading a file, so ask it to *read* |

Related: after `/compact`, nested contexts are **not** re-injected — they reload the next
time Claude reads a file in that directory.

**Status as of 2026-08-12: the root `CLAUDE.md` is confirmed to load. No run has yet
confirmed a nested surface context loading** — but every run so far explored the surfaces
with `find` and `ls` only, so the mechanism was never actually exercised. `/context` settles
it in seconds.

The history is worth reading, because it is a good example of a test that could not fail
correctly:

Two sessions were asked *"how is this app organised?"* Both answered well — versions,
tenancy as a `$extends` client extension rather than middleware, the sanctioned
module-registration exception, the lint caveat, the vault routing. That looked like strong
evidence the layer was landing. **It was not.** Every one of those facts also appears in the
root `CLAUDE.md`, so the test could not distinguish "the root loaded" from "everything
loaded".

Both sessions also described `apps/web` as an atomic-design hierarchy — and that turned out
to be **a defect in the root file, not a loading failure.** The root still carried the old
`atoms → molecules → organisms` line, written before the FE drift was discovered and never
corrected when `contexts/web.md` was. The agents read it correctly and repeated it. Two
loaded files contradicting each other, which is the same failure this layer documents
elsewhere as D3.

Both are now fixed: the root states feature-first and explicitly says it is not atomic
design, and the essence test in `verify.sh` is split into two tiers — Tier A answerable from
the root alone, Tier B answerable **only** from a nested context. Tier B is the one that
settles the open question.

Practically, until Tier B passes somewhere: **have an agent open a file in the surface
before asking it to reason about that surface.** A single `Read` is enough, and the executor
does it as its first act anyway — so this mostly bites on the questions asked *before* work
starts, which is when a wrong mental model is cheapest to acquire and most expensive to keep.

**Pick a small, well-specified ticket first.** The loop's value shows on a thin one, but its
*failure modes* are much easier to read on a ticket where you already know the answer.

**Do not fight the stop.** If it refuses, the cheapest possible moment to answer that
question is right now — before the code exists.

---

## 13. Not built

- **`test-author`** — deliberately absent. `apps/web` does not glob its tests;
  `package.json` passes 14 filenames explicitly to `node --test`, so a test not hand-added
  never runs and nothing says so. Fix the runner first.
- **The design intake** — being redesigned around the UI team's HTML/CSS handoff. The token
  map (their ~30 CSS variables → `theme.css`'s ~455) does not exist yet, and that gap is the
  likeliest origin of the ~593 hardcoded colour values.
- **Mechanical rails** — nothing enforces module boundaries, duplication, reuse, or
  hardcoded colour. Every one of those is currently a reminder, and the reflector is written
  to escalate when a reminder fails three times. The only rules enforced mechanically are in
  `.claude/hooks/guard-edits.mjs` (Claude Code, Edit/Write only): no client-repo edit on
  `main`, and no tooling edit unless the overlay email is Haris's.

---

## 14. Token budget — the rules, per tool

Everyone on the team is on a $20 plan. The loop as first written assumed the top model tier
on five of eight agents and treated context as free; by the second sprint people were hitting
their window mid-unit. What follows is what changed on 2026-08-17 and the discipline that
keeps it fixed. **These are rules on how we run the loop, same standing as §3.**

### What actually costs

The fixed context — `CLAUDE.md`, the surface context, an agent's own prompt — is sent once
and cached; it is not where the budget goes. **The budget goes on what gets read into the
conversation and re-sent on every turn after that**: an 88 KB `gaps.md` read whole, a 40 KB
spec, a full `git diff` of a long branch, a pasted log. And on the model multiplier — an
Opus turn draws roughly five times what a Sonnet turn does from the same window. So the two
levers, in order: **which model**, then **what you read**.

### The rules

1. **Sonnet is the default for every agent and every session.** `tcg-elaborator`,
   `tcg-decomposer`, `tcg-analyst`, `tcg-reflector` and both tools declare `model: sonnet`;
   `tcg-executor` inherits, so **set the session to Sonnet before invoking it.** Only
   `tcg-scrum` stays on Opus — it runs rarely and briefly. Each agent's *Model tier* section
   names its own escalation triggers (open conflict, payroll/ADP, prisma/tenancy/auth, a
   third occurrence). Escalate **for one run, explicitly** — "run tcg-elaborator on opus" —
   never by changing the default back.
2. **Read by section, never whole.** `gaps.md`, `payroll/gaps.md`, any spec over ~15 KB, any
   vault file over ~20 KB: `grep -n '^#'` first, then `sed -n` the section you need. The
   only vault file meant to be read whole is `INDEX.md`, and it is a routing table — follow
   its pointer, do not also read the neighbours.
3. **One unit per session.** Start a fresh session (Claude Code) or chat (Cursor,
   Antigravity) for each unit, and for each phase boundary. `units.md` is written to be
   read cold; if it is not, that is a decomposer defect for the reflector, not a reason to
   keep one long session.
4. **Pick the path (§2) before you pick the agent.** Path B and C exist because running
   inception on a bug is the most expensive way to learn the answer was on the ticket.
5. **Tail, do not paste.** Logs, test output, diffs — the last 40 lines, or the failing
   test, or `git diff --stat` and then one file. The agent can ask for more.
6. **Worked examples are on demand.** Each loop agent's three examples now live in
   `aidlc/agents/examples/<agent>.md` and are read only when a case is ambiguous. Do not
   paste them back into the agent prompt.
7. **Search with a cheap reader.** In Claude Code, broad "where is X used" questions go to
   the built-in read-only Explore agent, not the main session. In Cursor, use codebase
   search / `@` a specific file — never `@` a whole folder such as `.ai/vault` or
   `.ai/aidlc`.

### Per tool

| | Model | Session hygiene | Check |
| --- | --- | --- | --- |
| **Claude Code** | `/model sonnet` at start. Agents carry their own `model:`; override per run by asking for it. | `/clear` between units. `/compact` if `/context` shows >60% before a long phase. Disable MCP servers and plugins this repo does not need — every attached server adds tool schemas to every session (`claude mcp list`, `/plugins`). | `/context` at start, `/usage` at end. |
| **Cursor** | Model picker per chat: a Sonnet-class model or *Auto* for executor and analyst. **MAX mode off** for loop work. | New chat per unit. Open agent files by path (`.cursor/agents/<phase>/tcg-*.md`) — they are procedures, not attachments. `@` specific files, never folders. Root `AGENTS.md` is always attached, which is why nothing gets added to it casually. | Cursor's usage page in settings. |
| **Antigravity** | Model picker per conversation, same rule as Cursor. | New conversation per unit; open `.agent/agents/...` by path. Its auto-load behaviour is unverified (README §4.3), so assume nothing is loaded that you did not open. | Its own usage view. |
| **GitHub Copilot** (if used) | Its model picker; Sonnet-class. | Reads root `AGENTS.md` and nested `apps/*/AGENTS.md` like Cursor does; the same read-by-section and one-unit rules apply. | — |

### What changed on 2026-08-17, with numbers

- Agent defaults: four loop agents Opus → Sonnet; executor documented as "set the session".
- `vault/gaps.md` 88 KB → 24 KB, payroll and ADP entries moved to `vault/payroll/gaps.md`
  (64 KB, and read by section). Product-loop agents no longer carry the payroll register.
- `vault/INDEX.md` 24 KB → 19 KB: FR-FOP numbering tables → `field-ops/fr-fop-numbering.md`,
  tag vocabulary → `tags.md`, payroll narrative and sprint-plan rows collapsed to pointers.
- Agent prompts: worked examples moved to `aidlc/agents/examples/` — elaborator 25 → 21 KB,
  scrum 21 → 15 KB, executor 14 → 12 KB, reflector 13 → 10 KB, decomposer 12 → 10 KB,
  analyst 11 → 10 KB.

If the window is still the constraint after this, the next lever is not more trimming — it is
moving the one or two people who run inception most onto a higher plan, which is cheaper than
the whole team stalling mid-unit.

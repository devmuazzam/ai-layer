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

### `tcg-elaborator` · intent → `spec.md` · strong tier

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

### `tcg-decomposer` · spec → `units.md` · strong tier

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

### `tcg-executor` · one unit → code · mid tier

Branches from `origin/main` (`<type>/SCRUM-###-u<n>-<slug>`), builds the unit completely,
runs the gates, stops.

**The gaps it fills silently are the ones that cost.** A field length, a default, a status
enum, an error string — each is a one-line decision while building and none looks like a
decision afterwards. It lands in a migration, three modules read from it, and nobody knows
it was ever chosen. So: hit something the spec never settled → **stop that part**, build the
rest, log the question.

`NOT SPECIFIED` is a complete answer. A unit 80% built with a named blocker beats one 100%
built on four invented details.

**Existing code is not permission.** This repo will actively mislead you: ~142 upward API
imports, ~593 hardcoded colour values, three overlapping component libraries. Matching a
violation is not consistency.

### `tcg-analyst` · code → verdict · strong tier

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

### `tcg-reflector` · what shipped → `reflection.md` · strong tier

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

## 7. Alongside: `tcg-scrum` · strong tier

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
| `commit` | Branch naming, rebase from `origin/main`, conventional commits |
| `review-pr` | Ad-hoc PR review — **against the vault as well as the code** |
| `lint-triage` | Which failures are mine vs the ~14 pre-existing |
| `find-component` | Search all nine `components/` directories before creating |
| `debug-api` | Failing endpoint — four global guards, tenancy checked early |

Skills are procedures the current session follows. Agents get their own context and model
tier. Cheap mechanical work belongs in a skill; judgement belongs in an agent.

`review-pr` overlaps `tcg-analyst` deliberately: the analyst owns the verdict for a unit
built through the loop; the skill is the ad-hoc path for a PR with no unit behind it.

---

## 10. Where things live

```
.ai/aidlc/SCRUM-###/
  intent.md       ticket capture, before elaboration
  spec.md         the elaborator's output — what an executor builds from
  units.md        the decomposer's output — vertical slices
  reflection.md   after units ship, before the ticket closes

.ai/vault/        product knowledge — INDEX.md first, always
.ai/vault/gaps.md the open-question register — 13 open today
.ai/claude/contexts/  how to build, per surface
```

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
7. **Reflect** once the units have shipped. Apply the rule changes you accept — the
   reflector proposes, humans apply.

---

## 12. Running it for real — what to expect

**Only the elaborator and scrum have ever been run.** The other four are written against the
current context layer but have never executed. The first pass is as much a test of the
agents as of the ticket.

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

```bash
cat apps/api/src/main.ts     # reading a file in the directory is the trigger
/context                      # look under "Memory files"
```

`/context` reports which instruction files actually loaded. That is an observation rather
than a self-report, which matters: asking a model what is in its own context is the single
method that cannot be trusted for this, and it is the reason PRE-FLIGHT 0 sat open. For a
permanent record, the `InstructionsLoaded` hook logs which files load, when, and why.

**Why reading a file is the trigger — confirmed in Claude Code's documentation**, not
inferred: subdirectory `CLAUDE.md` files are *"included when Claude reads files in those
directories"* rather than loaded at launch. A `cd` inside a bash command does not count.
Related: after `/compact`, nested contexts are **not** re-injected — they reload the next
time a file in that directory is read.

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
  to escalate when a reminder fails three times.

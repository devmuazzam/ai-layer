# AI-DLC agents

The delivery loop this layer is built around. A Jira ticket becomes an **intent**; the
intent becomes a sourced **spec**; the spec is decomposed into shippable **units**; units
are **built** and **checked**; and a **reflection** feeds what was missed back into the
rules.

## Layout — phases are folders, roles are filenames

```
agents/
├── inception/      tcg-elaborator, tcg-decomposer
├── construction/   tcg-executor, tcg-analyst
├── reflection/     tcg-reflector
├── tools/          tcg-contract-tracer, tcg-prisma-guardian
├── examples/       each agent's three worked cases — read on demand, not loaded with the agent
└── tcg-scrum.md    the unblocker — outside the phase model
```

`examples/` files are deliberately **not** named `tcg-*.md`: `setup.sh` flat-links every
`tcg-*.md` into `claude/agents/` as a registered subagent, and an examples file must not
register as one.

**Agent names stay role-based; only the folders carry phase.** A role is what an agent
*is* and it does not change; a phase is *when it runs* and it may. Renaming files to match
phases would break every reference the moment an agent moved, so the phase lives in the one
place that is cheap to change.

`tcg-scrum` sits at the root because it is not a phase. It runs alongside the entire loop,
answering "how is this supposed to work" whenever someone is blocked, and it is equally
reachable from inception and construction.

## The handoff contract

Each phase produces exactly one artifact, and the next phase reads it. The templates in
[`../templates/`](../templates/) fix the field set for each.

| Phase | Reads | Produces |
| --- | --- | --- |
| inception | the ticket, the vault, the rules | `intent.md` → `spec.md` → `units.md` |
| construction | one unit, the surface contexts | code, then a verdict on it |
| reflection | what shipped vs what was specified | `reflection.md` |

**A phase never skips ahead.** The elaborator does not build. The decomposer does not
resolve open questions. The executor does not invent requirements the spec omitted. Every
one of them stops instead, because the alternative — filling a gap with something plausible
— produces work that is indistinguishable from specified work and survives review.

**But not every ticket enters at inception.** The full loop is the *feature* path. A bug
whose correct behaviour is already specified goes straight to construction — reproduce,
executor, analyst — and a one-line UI change needs no phase at all. Elaboration and
decomposition exist to answer "what should this do?", so skipping them when that is already
answered is not a shortcut.

The valve that keeps the short paths honest: **any path becomes the full loop the moment
someone has to decide something nobody specified.** See
[`../GUIDE.md`](../GUIDE.md) → *Not every ticket runs the full loop*.

## What every agent in here shares

- **Sources are cited and status-tagged.** A claim that cannot be cited is not made. Most of
  the vault is unverified and says so; a spec that hides that has laundered its sources.
- **The two tags do different jobs, and only one of them stops work.** `[OPEN]` — nobody has
  answered — blocks a unit outright at every phase. `[UNVERIFIED]` — someone answered and
  nobody confirmed it is current — blocks nothing, because it applies to almost every
  requirement there is. It travels with the requirement as a **reversibility constraint**:
  build it, but do not make it expensive to undo without saying so first. The pair
  *unverified × irreversible* is what each phase watches for, and the reflection is where the
  layer finds out whether the tag ever predicted anything.
- **Conflicts are surfaced, never resolved and never merged.** Merging two disagreeing
  documents invents a third that nobody wrote and nobody can be asked about.
- **Rules govern how we build, never what to build.** A rule can make a requirement
  unnecessary. It can never make one true.
- **Stopping is a result.** "Nothing is written about this" is a finding, delivered with the
  question that would settle it — not a failure to be worked around.

## Model tier — Sonnet by default, Opus by explicit escalation

| Default | Agents | Why |
| --- | --- | --- |
| **Opus** | scrum | Runs rarely and briefly — one question, one answer — and the answer becomes a durable decision. The judgement is worth the spend and the spend is small |
| **Sonnet** | elaborator, decomposer, analyst, reflector, contract-tracer, prisma-guardian | Every seat is on a $20 plan; an Opus elaboration can spend most of a five-hour window on its own. Each of these agents names, in its own *Model tier* section, the cases where one Opus run is worth it — an open conflict, payroll/ADP, prisma/tenancy/auth, a third occurrence — and the run is requested explicitly ("run tcg-elaborator on opus"), never made the default |
| **Inherits the session** | executor | Set the session to Sonnet before invoking it. Building to a fixed spec does not need the top tier; the one judgement call it has to make was rewritten as a lookup — see below |

The original design put the first four on Opus, on the argument that judgement work fails
*in the same direction* on a weaker model — toward the confident, complete, fabricated
answer. That argument is still right, which is why every one of those agents also carries a
procedural check a Sonnet run can be held to (the source-count self-check, the coverage
table, the refutation pass, §5's applicability test), and why the escalation triggers exist.
The full budget discipline is `aidlc/GUIDE.md` §14.

**The executor is the awkward one, and the resolution is structural rather than a caveat.**
Its most important behaviour — stopping when the spec is silent — is a judgement call, which
is exactly what the row above says mid-tier models get wrong in the same direction. An
earlier version of this README noted that as a caveat and left it there. A caveat is not a
resolution: it names a mismatch and then tolerates it.

So the stop was rewritten to stop being a judgement. The executor's authorised surface is
**the rows of its unit's slice-contents table plus the `REQ-nn` items it covers**, and
anything not traceable to one of those is out of scope *by rule*
([`construction/tcg-executor.md`](construction/tcg-executor.md) §2). That converts "notice
you are guessing" — which fails precisely when an invented default feels like knowledge —
into "check whether this is on the list", which is a lookup and does not depend on the model
correctly assessing its own certainty.

That is this layer's own thesis applied to itself: **a rule that depends on remembering is
not a rule.** If the first live tickets show executors filling gaps anyway, the honest read
is that the mechanical rule was insufficient — and the fix is one Opus run on the units
that keep failing, not a firmer reminder.

Cheap-tier work — commit messages, branch naming, running a gate — is not agent work at
all. That belongs in a skill; see `claude/skills/commit/`.

## Tools — phase-independent specialists

`tools/` holds agents that answer one narrow question on demand rather than owning a phase:
`tcg-contract-tracer` (what breaks in web and mobile when an API shape changes) and
`tcg-prisma-guardian` (is this schema change safe, isolated and efficient). Any phase may
call them. See [`tools/README.md`](tools/README.md).

## Status

**All six are written**: elaborator, decomposer, executor, analyst, reflector, scrum, plus
the two tools. None has yet been run against a real ticket end to end — the first live
exercise is what turns "written" into "works", and the phase READMEs record what each is
built to prevent so the first run can be read against that.

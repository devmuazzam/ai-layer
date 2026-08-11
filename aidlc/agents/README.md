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
└── tcg-scrum.md    the unblocker — outside the phase model
```

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
- **Conflicts are surfaced, never resolved and never merged.** Merging two disagreeing
  documents invents a third that nobody wrote and nobody can be asked about.
- **Rules govern how we build, never what to build.** A rule can make a requirement
  unnecessary. It can never make one true.
- **Stopping is a result.** "Nothing is written about this" is a finding, delivered with the
  question that would settle it — not a failure to be worked around.

## Model tier — assigned by how much judgement the task needs

| Tier | Agents | Why |
| --- | --- | --- |
| **Strong** (Opus-class) | elaborator, decomposer, analyst, reflector, scrum | Judgement: is this requirement genuinely sourced, do these documents actually conflict, does this unit ship alone, does this finding survive refutation. A weaker model gets all of those wrong **in the same direction** — toward the confident, complete, fabricated answer |
| **Mid** (Sonnet-class) | executor, contract-tracer, prisma-guardian | Building to a fixed spec, or exhaustive checking against a known rule. Breadth matters more than judgement, and the failure mode is *missing* something rather than *misjudging* it |

The executor sits at mid tier with one caveat stated in its own file: the part that does
need care is noticing it has hit something the spec never specified, and stopping instead of
filling it in.

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

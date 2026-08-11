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

## What every agent in here shares

- **Sources are cited and status-tagged.** A claim that cannot be cited is not made. Most of
  the vault is unverified and says so; a spec that hides that has laundered its sources.
- **Conflicts are surfaced, never resolved and never merged.** Merging two disagreeing
  documents invents a third that nobody wrote and nobody can be asked about.
- **Rules govern how we build, never what to build.** A rule can make a requirement
  unnecessary. It can never make one true.
- **Stopping is a result.** "Nothing is written about this" is a finding, delivered with the
  question that would settle it — not a failure to be worked around.

## Model tier

Every agent here states its own tier, and they all ask for the **stronger** model available
in whatever tool is running them. That is not padding: each one's core work is judgement —
whether a requirement is genuinely sourced, whether two documents actually conflict,
whether a unit ships alone, whether a finding is real. A weaker model gets all of those
wrong **in the same direction**, toward the confident, complete, fabricated answer.

Cheap-tier work — commit messages, formatting, running a gate — is not phase work and does
not belong to an agent in this folder.

## Status

Built: `tcg-elaborator`, `tcg-scrum`. The rest are being written against the trimmed
context layer so they are authored once rather than reworked after it moves. Each phase
README records what is real and what is not.

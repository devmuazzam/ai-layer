# Inception

**Turning a ticket into something buildable — and refusing to build it.**

| Agent | Does |
| --- | --- |
| [`tcg-elaborator.md`](tcg-elaborator.md) | intent → sourced `spec.md`, then stops and asks |
| `tcg-decomposer.md` | approved `spec.md` → `units.md`, vertical slices that ship alone |

## Why these two are the same phase

Both answer *"what are we building?"* and neither touches code. That shared property is
the reason they are grouped rather than split: the failure mode is identical for both, and
it is **drifting forward into implementation**.

An elaborator that scaffolds a module has decided the file layout, the DTO fields and the
route identity before anyone answered the open questions. A decomposer that starts building
its first unit has committed to a slicing that was never reviewed. In both cases the work
looks like progress and is actually a set of decisions nobody made deliberately.

So the phase boundary is not bureaucratic. It is the last point where a wrong assumption
costs a conversation instead of a migration.

## Why inception owns two agents rather than one

They fail differently, and merging them would hide one failure inside the other.

- The elaborator's risk is **inventing requirements** — writing a plausible sentence that
  no source supports, in the same voice as the sourced ones.
- The decomposer's risk is **slicing badly** — units that cannot ship alone, so the first
  one merges and delivers nothing a user can do.

An agent doing both would resolve its own open questions while slicing, which is exactly
the laundering both are built to prevent. Keeping them separate means the spec is fixed and
reviewable *before* anything is decomposed against it.

## What leaves this phase

A `units.md` whose slices each answer *"if this ships alone, what can someone now do?"* —
with any `[OPEN]` requirement still marked open, not quietly resolved on the way through.

Open questions from either agent are appended to §12 of the ticket's `spec.md` — a ticket
has no `gaps.md`, and a question a ticket raised stays in the file the next person opens.
[`../../../vault/gaps.md`](../../../vault/gaps.md) is read-only to both agents, for citing an
entry that already exists.
Neither agent resolves a gap; recording a decision belongs to `tcg-scrum`, which has the
write path and the escalation context for it.

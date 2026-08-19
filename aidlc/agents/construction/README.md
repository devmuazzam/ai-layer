# Construction

**Building one unit, and checking it honestly.**

| Agent | Does |
| --- | --- |
| `tcg-executor.md` | one unit → working code, following the surface contexts |
| `tcg-analyst.md` | reviews what was built against the unit and the spec |

## Why the builder and the checker are separate

The same context that makes an executor good at building makes it bad at reviewing its own
work. It knows what it *meant*, so it reads the diff as the intention rather than as the
bytes. Every gap it filled while building — a field length, a default, an error string —
is invisible to it, because from the inside those were not decisions.

A separate analyst reads only what is there. That is the entire value, and it disappears
the moment one agent does both.

## The failure this phase is built against

Documented, not hypothetical. The skill this layer used to review PRs asked *"no upward
imports?"* and *"existing components reused?"* — questions nothing in the repo can answer,
because no lint rule enforces either. It had no instruction to run anything and no field
separating a checked claim from a read one. So its findings arrived in one voice, with
`file:line` precision, whether they came from a tool or from a guess.

**The analyst's output must therefore separate what was verified from what was inferred**,
and must say which command produced each verified claim. A review that blends them is worse
than no review: it spends the reviewer's trust on claims that did not earn it.

That matters here more than anywhere, because this codebase enforces very little
mechanically. Layering, reuse and hardcoded colours are all convention, all violated in
places, and all invisible to `pnpm lint`. An analyst that assumes a green gate means a
clean diff will be wrong in exactly the cases that cost most.

## What the executor must not do

Build past the unit. If a unit depends on something the spec marked `[OPEN]`, the executor
**stops** and says which requirement blocked it. It does not choose a sensible default and
carry on, because a sensible default becomes a schema, and a schema becomes the thing three
modules read from.

Existing code is not a source of intent. Half the patterns in this repo are the first
implementation that worked, and several are documented defects. Matching a neighbouring
module is a reason to ask, not a licence to proceed.

## What leaves this phase

Merged code for one unit, plus the analyst's verdict — findings ranked, each tagged with
how it was established. Anything the executor had to stop on goes to
§12 of the ticket's `spec.md` with the question that would unblock it — not to
[`../../../vault/gaps.md`](../../../vault/gaps.md), which is only for questions belonging to
no ticket.

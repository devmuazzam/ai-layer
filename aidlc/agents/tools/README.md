# Tools — phase-independent specialists

Agents that answer one narrow, high-consequence question, invoked on demand rather than
owning a phase. They run in their own context and return a conclusion.

| Agent | Model | Answers |
| --- | --- | --- |
| [`tcg-contract-tracer.md`](tcg-contract-tracer.md) | Sonnet | "This API response shape changed — what breaks in web and mobile?" |
| [`tcg-prisma-guardian.md`](tcg-prisma-guardian.md) | Sonnet | "Is this schema change safe, isolated, and efficient?" |

## Why these are agents and not skills

A skill is a procedure the current session follows. These need two things a skill cannot
carry: **their own context window**, because tracing 115 call sites or auditing a schema
would otherwise flood the caller's context with files it does not need afterwards; and
**their own model tier**, because both are mechanical enough not to need the strongest one.

## Why they are not phase agents

They are not a step in the loop. An executor calls the tracer mid-build; an analyst calls
it during review; a decomposer might call it while slicing to find out how wide a change
reaches. Binding them to a phase would mean duplicating them into three.

Same reasoning as `tcg-scrum` sitting outside the phase folders — being useful at every
point is a property, not an absence of one.

## Model tier — lower than the phase agents, deliberately

The phase agents ask for the strongest tier because their work is judgement: whether a
requirement is sourced, whether two documents conflict, whether a finding survives
refutation.

These two are different. Both do **exhaustive mechanical work against a known rule** — find
every caller of a changed shape; check a schema against a fixed list of hazards. Breadth
matters more than judgement, and the failure mode is *missing a call site*, not
*misjudging one*. A mid tier does that reliably and can be run on every change without
anyone weighing the cost.

Where either hits something that needs a judgement call, it reports and stops rather than
deciding. That boundary is what keeps the tier honest.

## What they must not do

- **Neither writes code.** They report. A tracer that fixes the callers it found has made
  itself unreviewable.
- **Neither approves.** "No breaks found" is a finding, not a merge signal — `tcg-analyst`
  owns the verdict.
- **Both distinguish what they verified from what they inferred**, for the same reason the
  analyst does: a confident wrong answer about a call site costs more than no answer.

## Not built

`test-author` is deliberately absent. `apps/web` does not glob its tests — `package.json`
passes the filenames explicitly to `node --test` (16 as of the Nx merge, 2026-08-19; it was
14 when this was written), so any test not hand-added to that string never runs and nothing
reports it — and `pnpm nx run @tcg/web:test` will happily replay a cached green over it. An agent authoring web tests would produce green-looking
work that executes nothing. Fix the runner first; `apps/api` and `apps/mobile` use jest and
would be fine today.

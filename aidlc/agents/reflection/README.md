# Reflection

**Feeding what went wrong back into the rules, so the next ticket is cheaper.**

| Agent | Does |
| --- | --- |
| `tcg-reflector.md` | after units ship → `reflection.md`, and the rule changes it implies |

## Why this phase exists at all

Without it the loop has no memory. The same missing requirement gets asked for on three
tickets, the same convention gets violated in four modules, and each one is fixed locally
as though it were the first. The cost is invisible because it is spread across people.

Reflection is the only phase whose output is aimed at the *layer* rather than the ticket. A
spec defect becomes a template field. An executor defect becomes a line in a surface
context. A repeated conflict becomes an escalation.

## The one rule that makes it work

**Third occurrence escalates structurally.** A defect seen once is noise; twice is a
coincidence; three times is a property of the system, and fixing it in the ticket again is
choosing to pay for it forever.

That threshold is deliberate and it is the reflector's main judgement call. Escalating too
early buries real work under process changes; escalating too late is how a codebase ends up
with 593 hardcoded colour values and a rule that says not to.

## Why reflection is separate from analysis

The analyst asks *"is this diff correct?"* The reflector asks *"why did this diff need
fixing, and what would have prevented it?"* Those are different questions with different
evidence — one reads a change, the other reads a pattern across changes — and an agent
asked to do both will answer the first and skip the second, because the first has a
deadline attached.

## What leaves this phase

A `reflection.md` per ticket, and where the third-occurrence rule fires, a concrete
proposal: which file changes, what it says instead, and what evidence supports it.

**The reflector proposes; it does not edit the rules.** A convention that changes because
an agent decided it should is exactly the drift this layer exists to remove. Rule changes
go through review like any other change.

## Status

Not built. The template is written and its field contract is fixed —
[`../../templates/reflection.md`](../../templates/reflection.md). Nothing consumes it yet.

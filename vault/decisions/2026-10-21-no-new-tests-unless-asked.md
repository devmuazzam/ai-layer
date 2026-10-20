---
title: No new tests unless the developer asks — decision
source: decision/Syed Haris
decided: 2026-10-21
decided_by: >-
  Syed Haris (git: hariscops, syed.haris@codingcops.com), AI-layer owner, in a Claude Code
  session on 2026-10-21. His words: "also add a rule in AI-DLC, don't add test cases until
  asked or prompted". This is an engineering-process rule about the AI-DLC loop. It does not
  describe product behaviour.
status: verified
resolves: >-
  none (no open §12 or module gaps.md entry asked this; raised directly in the session).
  Narrows the test-adding parts of two TICKET-FLOW-SLOTS-HOLDOVER reflection proposals
  applied on 2026-10-20 (R2 and R6; see "Effect on earlier records")
tags: [module/all, kind/decision, architecture, sprint-planning]
---

## Decision

> "also add a rule in AI-DLC, don't add test cases until asked or prompted"

- The AI writes **no new tests**, meaning no new spec files and no new test cases. This holds
  in a unit, a fix or a sweep, unless the developer's prompt or the ticket asks for them.
- **Existing tests are still run.**
- Where a template has a tests row, it defaults to `not requested`.
- **An existing consumer that a change reaches must still be checked.** Use an existing test
  or a check run by hand (a route, a request or a screen), and name the check. That check is
  not a new test, and leaving it out still makes the unit incomplete. This keeps the
  SCRUM-900 SD-1 (`refactor-untested`) rule, and drops only its demand for a *new* test.

## Why

Haris gave the rule without a stated reason. This note does not invent one. The surrounding
context is `decisions/2026-10-21-capability-first-ai-decides-structure-guardrails-only.md`,
made the same day, which moved control to where a wrong choice is expensive or
irreversible. The consumer-check bullet above is what keeps the protection that the
SCRUM-900 rule existed for.

## Mechanism

The main session made the tooling edits for this decision. This note did not make them, and
it is their source. All are **applied**, uncommitted in the overlay as of this note. Each
was checked by `grep` on 2026-10-21; line numbers are as of that check.

- **The rule:** root `.ai/claude/CLAUDE.md` line 53, *No new tests unless the developer
  asks*, directly under the G1–G6 guardrails.
- **`.ai/aidlc/templates/units.md`:**
  - line 100: the Tests row reads `not requested`
  - line 102: *If the developer asks for tests*, which lists the tests worth writing and says
    unasked cases are checked by hand
  - line 128: the ripple column is now *How we know it still works*
- **`.ai/aidlc/templates/spec.md`:**
  - line 124: the Edges *Does not apply when* line says each case is checked in `units.md`,
    "by a test only if the developer asked for tests"
  - lines 278–280: §10 *Tests* is `not requested` unless asked
- **`.ai/aidlc/agents/inception/tcg-decomposer.md`:**
  - line 200: "The regression **check** for an existing consumer", where it used to say
    regression *test*
  - line 217: the ripple block asks how we know the consumer still works
- **`.ai/aidlc/agents/construction/tcg-executor.md`:**
  - lines 288–289: the output has a `tests <not requested | asked: …>` line and a
    `checked` line
  - line 315: no new tests unless asked, and a unit whose existing consumers nobody checked
    is not complete
- **`.ai/claude/contexts/api.md`:** *Testing* (lines 130–134). A unit that changes a
  provider constructor or a module's `providers` / `imports` boots the API once
  (`pnpm api:dev`) instead of adding a module-compile spec.
- **`.ai/claude/skills/review-pr/SKILL.md`:** lines 227–229. Ponytail's *Missing test*
  findings are suggestions only and never cap the verdict. An existing consumer that nobody
  checked is still a finding.

## Effect on earlier records

This decision narrows the test-adding parts of two proposals from the TICKET-FLOW-SLOTS-HOLDOVER
reflection (`.ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/reflection.md` §4). Both are marked
`applied 2026-10-20` in `.ai/aidlc/reflections/INDEX.md`:

- **R2** (`over-broad-condition`, ED-1–ED-3, first escalation of that class; it also covered
  ED-4, ED-7, ED-8 and ED-9). Its rule was one negative test row per *Does not apply when*
  item in `units.md`, plus API-level and workaround test rows. The *Does not apply when*
  field stays required, and each case is still checked. A **test** for it is written only
  when the developer asks.
- **R6** (`gate-illusion`, ED-5). Its rule was a Nest module-compile test in
  `contexts/api.md` *Testing*. That is replaced by booting the API once. A DI break must
  still show before the PR, but it no longer needs a new spec file.

The reflection rows themselves are not edited: they record what was applied on
2026-10-20, and that history stays true. A reader following R2 or R6 should read this note
as the current rule.

## Effect on the vault

- **Winner:** none. This is a process decision, and no product vault file states or
  contradicts it.
- **Superseded:** none. No earlier decision note required new tests. The narrowed rules
  lived in reflection proposals, not in decision notes.
- **INDEX:** a row for this note sits in `INDEX.md`, directly after the 2026-10-21
  capability-first row.
- **Gap entry:** none to close.

---
title: Build prompts enter AI-DLC through triage — decision
source: decision/Syed Haris
decided: 2026-10-09
decided_by: >-
  Syed Haris (git: hariscops), developer on the TCG platform, in a Claude Code
  session on 2026-10-09, deciding for the team's AI tooling. This is a process
  rule about how work moves through AI-DLC, not a product behaviour. It was set
  by one of the eight developers, and the vault records no delegation that lets
  one developer bind the other seven. So it applies from today but is **pending
  team acknowledgment**: the team can overrule or amend it. Until they do, treat
  it as binding.
status: verified
resolves: none (no open §12 or module gaps.md entry asked this; raised directly in the session)
topics: []
entities: []
tags: [module/all, kind/decision, sprint-planning]
---

## Decision

**Every prompt that asks to build, change or fix code enters AI-DLC, and it enters
through triage, not the full loop.** Before any code is written, the agent:

1. **Names the ticket**, or says plainly that there is none.
2. **Classifies it as Path A, B or C** per `.ai/aidlc/GUIDE.md` §2
   (*Not every ticket runs the full loop*):
   - **A**: new behaviour, or anything needing product intent → the full loop
     (intent → spec → units → execute → analyse → reflect).
   - **B**: a bug where the behaviour is specified, or the bug *is* the deviation →
     repro → `tcg-executor` → `tcg-analyst`.
   - **C**: a small stated change → just build it (`find-component` first if it is UI).
3. **States the path** before writing code.

**GUIDE §2's escalation rule applies unchanged:** any path becomes Path A the moment
something nobody specified has to be decided (GUIDE §2, *The escalation rule is what
makes B and C safe*).

**Out of scope, and these do not enter the loop:** questions, debugging and diagnosis,
reviews, exploration.

## Why

Until now nothing routed prompts into AI-DLC. Checked against overlay `HEAD` on
2026-10-09:

- `claude/settings.json` defined no hooks.
- `claude/CLAUDE.md`, the root context that every tool reads, mentions AI-DLC only as
  "that is AI-DLC's job" and in the `.ai/aidlc/agents/` pointer. It never points at
  `aidlc/GUIDE.md`.

So whether an agent used the loop depended only on how the model read the agent
descriptions, and the same prompt could go either way. Paths B and C also left no record
unless the `commit` skill ran, because `commit` is what appends the line to
`.ai/aidlc/processed.log` (GUIDE §2, *Every path leaves one line*). Making triage the
fixed entry step means every build prompt picks a path, and says which, before code
exists. Because the step is triage, the cheap paths stay cheap.

### Rejected alternatives

1. **Run the full loop (Path A) on every build prompt.** GUIDE §2 calls this "absurd"
   for a bug or a one-line UI change, and warns it "is how a process gets abandoned in
   week two."
2. **A hook that classifies prompts by regex.** A regex can't reliably tell a build
   request from a question, so it would misroute in both directions.

### Mechanism

1. **A section in the root `.ai/claude/CLAUDE.md`.** `AGENTS.md` resolves to it
   (`AGENTS.md → .claude/AGENTS.md → CLAUDE.md`, with `.claude → .ai/claude`), so it
   reaches the non-Claude tools too. This is the portable part.
2. **A `UserPromptSubmit` hook in `.ai/claude/settings.json`** that adds a one-paragraph
   triage reminder to every prompt. It works only in Claude Code. It guarantees the
   reminder is present, but the classification itself is still model judgment.

The main session is making both edits in the same change. This note does not make them.

## Effect on the vault

- Winner: none. This is a process decision, and no product vault file states or
  contradicts it.
- Superseded: none.
- Frontmatter edits: none required, none made.
- Gap entry: none to close.
- Outside the vault: `.ai/claude/CLAUDE.md` (new triage section) and
  `.ai/claude/settings.json` (new `UserPromptSubmit` hook) are the enforcement. The
  main session is editing them, not this note. Their source for this rule is this note.

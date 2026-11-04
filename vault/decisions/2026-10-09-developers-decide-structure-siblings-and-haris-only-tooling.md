---
title: Developers decide structure, siblings get asked, tooling is Haris-only — decision
source: decision/Syed Haris
decided: 2026-10-09
decided_by: >-
  Syed Haris (git: hariscops, syed.haris@codingcops.com), in a Claude Code session on
  2026-10-09. He stated directly that no team acknowledgment is needed: this binds every
  developer from 2026-10-09. It is an engineering-process rule about how code gets built
  and who changes the AI tooling. It does not describe product behaviour.
status: verified
resolves: none (no open §12 or module gaps.md entry asked this; raised directly in the session)
tags: [module/all, kind/decision, architecture, sprint-planning]
superseded_by: decisions/2026-10-21-capability-first-ai-decides-structure-guardrails-only.md  # structure and siblings only; Haris-only tooling stands
provenance_note: >-
  §1–§3 (developers decide structure, where it is recorded, siblings asked first) are
  superseded by decisions/2026-10-21-capability-first-ai-decides-structure-guardrails-only.md:
  the AI decides structure and records it for developer review, and siblings are applied
  or listed, not asked. §4 (tooling is Haris-only) stands. Body unchanged.
---

## Decision

### 1. Developers decide structure. AI proposes.

> "If a function can be reused or a new function, what column a table should have, a
> developer should drive the decision not the ai suggestion, if asked for ai suggestion he
> should evaluate, ai is a tool, not the final building machine."

**Scope: structural decisions only.** That means:

- a new table, column, enum member or relation
- a new exported function, service, hook or component, versus reusing an existing one
- a new endpoint or response shape
- a new dependency
- choosing a pattern, or deviating from one

Private helpers inside a single file are **out of scope**.

An AI may propose an option. A developer evaluates it and makes the choice.

### 2. Where structural decisions are recorded

- **Path A:** `spec.md` §11b *Developer decisions*.
- **Paths B and C:** the *Developer decisions* table in the PR description.

**An AI never fills *Decided by*.**

### 3. Siblings get the same change, and the developer is asked first

> "I don't want 4 cruds being developed in 4 different ways."

When a change is made to one instance of a recurring shape, the AI names every sibling and
**asks the developer**.

- **Yes:** the change goes to the siblings in the same PR.
- **No:** the reason is recorded.

In his words: "apply, but should ask the dev, so it's not unknown to him."

### 4. Tooling changes are Haris-only

> "tooling change should be done by Haris only."

Tooling means these paths:

- `.ai/claude/**`
- `.ai/aidlc/agents/**`
- `.ai/aidlc/templates/**`
- `.ai/aidlc/GUIDE.md`
- `.ai/setup.sh`
- `.ai/verify.sh`
- `.ai/README.md`

**Enforcement is an agent rule only:**

- AI tools refuse to edit tooling unless `git -C .ai config user.email` is
  `syed.haris@codingcops.com`.
- `review-pr` flags any tooling commit made by another author.

Rejected alternatives:

1. **GitHub CODEOWNERS plus branch protection.** The overlay repo is private on a free
   personal account. The branch-protection API returned "Upgrade to GitHub Pro", so this
   would need a paid plan.
2. **A GitHub Action that flags tooling pushes.** It only reports after the change has
   landed, and the agent rule stops the change before it is made.

### 5. Open item: pattern reference implementations (not decided)

`.ai/claude/contexts/patterns.md` names two patterns: **P1** (business-entity CRUD) and
**P2** (reference-code list). Their reference implementations are **UNDECIDED. Haris is
to pick them.** A survey on 2026-10-09 found 3 API variants and 4 web variants. Until he
picks, no variant is the reference, and nobody should treat any existing variant as the
template on the strength of this note.

## Why

A review on 2026-10-09 found that nothing in the loop asked whether a structure should
exist at all:

- `aidlc/reflections/INDEX.md` had no class for over-building.
- `tcg-prisma-guardian` checked whether a schema change was safe. It never asked whether
  the model should exist.
- The spec template asked "reuse before creating" for web only, not for the API or the
  schema.

**The concrete case:** commit `3ba609f38` (TCG-140, 2026-09-25, *"each union code has its
own craft code modifiers"*) added `unionCodeId` to `CraftModifier`. `CraftModifierRate`
already carries its own `unionCodeId` (`apps/api/prisma/schema.prisma`, models
`CraftModifier` and `CraftModifierRate`), so the child now repeats a key its parent holds.
That goes against the structure `decisions/2026-09-25-boom-adders-single-union-per-company.md`
says to keep: "union-neutral brackets (ft ranges) plus one `CraftModifierRate` row per
(bracket, union)". The TPM objected to the two-table split. Nobody on record chose this
structure. It shipped because the AI or whoever was typing produced it.

The sibling rule addresses the same failure across features: the same shape built several
ways (the 3 API and 4 web variants above). Tooling ownership keeps the rules that enforce
all of this from drifting under eight developers on four or more AI tools.

## Mechanism

The main session made these edits. This note did not make them, and it is their source.

- **Root `.ai/claude/CLAUDE.md`:** three new sections, plus a row in the ownership table.
- **New `.ai/claude/contexts/patterns.md`:** the pattern registry (P1, P2; references
  undecided).
- **`.ai/aidlc/templates/spec.md`:**
  - §3 existing models considered
  - §4 pattern and reuse
  - new §11b *Developer decisions*
  - new §11c *Siblings*
  - §14 sign-off
- **`tcg-elaborator` §10.**
- **`tcg-executor`:** structural stop, API reuse, §4b.
- **`tcg-prisma-guardian` §1b.**
- **`tcg-analyst`:** hazards.
- **`review-pr`:**
  - §4 pattern and tooling authorship
  - §4b decisions
  - §4c siblings
  - output and verdict rules
- **`commit` skill §6:** the PR description.
- **`.ai/aidlc/reflections/INDEX.md`:** new classes `undecided-structure`, `over-built` and
  `pattern-drift`.

## Effect on the vault

- **Winner:** none. This is a process decision, and no product vault file states or
  contradicts it.
- **Superseded:** none.
- **Frontmatter edits:** none required, and none made.
- **Gap entry:** none to close.
- **Still open:** the P1 and P2 reference implementations (§5 above). Haris decides them.
  When he does, record that as a new decision note, or as an amendment that cites this one.

---
title: Sole-unverified-source confirmation, no delegated structure, API layering linted — decision
source: decision/Syed Haris
decided: 2026-10-20
decided_by: >-
  Syed Haris (git: hariscops, syed.haris@codingcops.com), AI-layer owner, in a Claude Code
  session on 2026-10-20. He chose among lettered options presented to him for three
  proposals in `.ai/aidlc/reflections/INDEX.md`. These are engineering-process rules about
  the AI-DLC loop. They do not describe product behaviour.
status: verified
resolves: >-
  none (no open §12 or module gaps.md entry asked this). Raised by three `proposed` rows in
  `.ai/aidlc/reflections/INDEX.md`: SCRUM-252 SD-1, TICKET-FLOW-SLOTS-HOLDOVER ED-11,
  TICKET-FLOW-SLOTS-HOLDOVER ED-12
tags: [module/all, kind/decision, architecture, sprint-planning]
---

## Decision

### 1. A requirement whose only source is `[UNVERIFIED]` is confirmed before it is built

Raised by **SCRUM-252 SD-1** (class `unverified-stale`). Haris chose **option A of three**.

- A requirement whose **only** source is `[UNVERIFIED]` gets a §12 confirmation question to
  the owner, with these options:
  - `A. Yes, as written`
  - `B. No — say what changed`
  - `X. Other`
- The requirement is flagged `[OPEN]` until the question is answered.
- A **second source of any status**, or a **`[VERIFIED]` source**, lifts it.

Rejected alternatives:

- **B.** Keep the old rule that `[UNVERIFIED]` never blocks.
- **C.** Every `[UNVERIFIED]` requirement needs confirmation. Rejected because most of the
  vault is unverified, so this would stall most tickets.

### 2. A developer cannot delegate a structural choice to the AI

Raised by **TICKET-FLOW-SLOTS-HOLDOVER ED-11** (class `undecided-structure`). Haris chose
**option A of two**.

- "You decide" is recorded as `AI proposal — pending developer confirmation`, and it still
  blocks.
- A one-letter reply to lettered options is enough to make the developer the decider.

Rejected alternative:

- **B.** Allow delegation, recorded as "delegated by <dev>".

### 3. API layering is enforced by lint, after a sweep

Raised by **TICKET-FLOW-SLOTS-HOLDOVER ED-12** (class `layer-violation`). Haris chose
**option B of three**.

- The API layering `presentation → usecase → service → orm` is enforced with
  `import-x/no-restricted-paths` in the `apps/api` ESLint config, at **`error`** level.
- The rule lands **after** a dedicated sweep PR fixes the existing violations. Per
  `.ai/aidlc/agents/construction/tcg-executor.md`, those are about 151 files and 421 import
  lines.
- The sweep is its own PR. Under root `CLAUDE.md`, a sweep never rides in a feature PR.

Rejected alternatives:

- **A.** Add the rule as a warning now.
- **C.** Withdraw the proposal and keep layering as a convention only.

**Not settled by this decision.** These are left to the eventual ticket, not decided here:

- whether **type-only imports** are exempt from the rule. `tcg-executor.md` notes that most
  of the 421 lines are type-only and only 11 are runtime inversions, so the answer changes
  the size of the sweep.
- the **order of the sweep PRs** under the ~400-line PR budget. The sweep will need either a
  `size-exception` label or several PRs.

## Why

- **§1:** On SCRUM-252, the only written source for the whole feature was
  `dispatch/daily-allocation-system.md` (Live Asset Map View, `status: unverified`). It was
  built against without anyone re-checking it. Three of seven acceptance criteria proved
  wrong or stale, and that was found only at PR review. Confirming every unverified
  requirement would block most tickets. Confirming only a sole unverified source targets the
  case that failed.
- **§2:** On TICKET-FLOW-SLOTS-HOLDOVER, Q13 and Q21 were recorded as Haris's decision
  "delegated to the AI". That conflicts with the rule that an AI never fills *Decided by*
  (`decisions/2026-10-09-developers-decide-structure-siblings-and-haris-only-tooling.md`).
  Allowing delegation would let the AI become the decider under a developer's name. Lettered
  options keep the cost of a real decision to one letter.
- **§3:** On TICKET-FLOW-SLOTS-HOLDOVER, a `service/` file imported a type from `usecase/`,
  and nothing caught it, because lint has no module-boundary rule. A warning would join the
  existing violations and be ignored. An `error` rule cannot land on top of about 151
  violating files, so the sweep has to come first.

## Mechanism

The main session made the edits for §1 and §2. This note did not make them, and it is
their source.

- **§1 (applied):**
  - `.ai/aidlc/agents/inception/tcg-elaborator.md` §4
  - `.ai/aidlc/agents/inception/tcg-decomposer.md` §2b
  - `.ai/aidlc/templates/units.md`
- **§2 (applied):**
  - root `.ai/claude/CLAUDE.md`, *Developers decide structure*
  - `.ai/aidlc/templates/spec.md` §11b
  - `commit` skill §6
- **§3 (not applied):** the sweep and the ESLint rule are both client-repo changes. They need
  their own ticket and PRs.

## Effect on the vault

- **Winner:** none. This is a process decision, and no product vault file states or
  contradicts it.
- **Superseded:** none.
- **Frontmatter edits:** none required, and none made.
- **Gap entry:** none to close.
- **Still open:** §3 is decided but not built. The type-only exemption and the sweep PR
  order are for the ticket that implements it.

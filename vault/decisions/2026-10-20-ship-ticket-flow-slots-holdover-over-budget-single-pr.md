---
title: "Ship TICKET-FLOW-SLOTS-HOLDOVER as a single over-budget PR (#831), not split — decision"
source: decision/Syed Haris (CodingCops) — developer direction in Claude Code session, 2026-10-20
decided: 2026-10-20
decided_by: >-
  Syed Haris (CodingCops, syed.haris@codingcops.com). A developer process decision on PR structure,
  made in a Claude Code session on 2026-10-20 and owned entirely by the developer — it decides how
  this ticket's work is packaged for review, not product intent, so it needs no TCG ratification.
  Recorded as status: reference because it is developer direction, consistent with DN-1 / DN-2.
status: reference
conflicts_with: []
resolves: []
related_tickets:
  - TICKET-FLOW-SLOTS-HOLDOVER
  - PR #831
jira: []
tags: [module/field-ops, kind/decision, pr-size, process]
provenance_note: >-
  The ~400-line / 25-file PR size budget this decision made an exception to no longer
  exists in the AI layer as of 2026-10-21 (decisions/2026-10-21-capability-first-ai-decides-structure-guardrails-only.md §8).
  The decision stays as the record of how PR #831 shipped. Body unchanged.
---

# Ship PR #831 as one over-budget PR, not split

## Decision

PR #831 (branch `feat/ticket-flow-uhm-series`, ticket `TICKET-FLOW-SLOTS-HOLDOVER`) ships **18
units in a single PR**: U1–U6 (slot-driven step flow), H1–H6 (holdover API), M1–M6 (holdover
mobile). Measured size: **4508 source lines across 87 source files** (tests, migrations,
lockfiles and snapshots excluded).

Syed Haris, as the developer, **knowingly accepts the over-budget PR** and ships it as one PR.
It is **not** split into stacked per-unit PRs, and it is **not** carried under the
`size-exception` label.

## Why

The budget in root `CLAUDE.md` → _One unit, or one independent task, per PR_ is one unit (Path A)
or one independent task per PR, at most ~400 changed source lines in 25 source files, with the
only sanctioned way over the budget being a per-PR `size-exception` label plus a written reason.
PR #831 is far past that on every axis (18 units, 4508 lines, 87 files).

The developer judged the 18 units to be one coherent, interdependent change (slot-driven steps,
holdover flow across shared/api/mobile, and the late/incomplete work) that reviews better whole
than as a stack, and chose to ship it as a single PR rather than take the `size-exception` route.
That is a developer's structural call to make, and it is recorded here so it is a named decision
and not silent drift.

**This deliberately repeats the PAYROLL-FLAGS #709 pattern** (21 units, 35,108 source lines, 784
files) that the one-unit-per-PR rule was written to prevent. The difference this time is that it
is a **deliberate, named decision by a specific developer**, recorded durably — not an
after-the-fact discovery of drift. The rule stands; this is a knowing, logged exception to it.

## Consequences to expect

- `.github/workflows/pr-size.yml` will post a **red check** and a comment listing the commits to
  split along. On the free GitHub plan that check **cannot block the merge**, so the red check is
  informational only.
- `review-pr` (and the executor / `commit` size gates) **will flag the size again on any later
  pass** unless this decision note is cited as the authority for the exception. Reviewers citing
  this note should treat the size finding as resolved-by-decision, not open.

## Effect on the vault

- **No frontmatter changes.** This note closes no gap and adjudicates no conflict; it records a
  developer process decision. No file's `status` changes.
- No new gap filed. The open product questions for this ticket remain in
  `.ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/spec.md` §12 and are addressed in the companion note,
  `decisions/2026-10-20-ship-q1-q4-ticket-flow-workarounds-defer-real-behaviour.md`.

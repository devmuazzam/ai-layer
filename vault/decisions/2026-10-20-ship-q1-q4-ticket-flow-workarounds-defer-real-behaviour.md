---
title: "Ship the Q1–Q4 labelled workarounds for TICKET-FLOW-SLOTS-HOLDOVER and defer the real behaviour — decision"
source: decision/Syed Haris (CodingCops) — developer direction in Claude Code session, 2026-10-20
decided: 2026-10-20
decided_by: >-
  Syed Haris (CodingCops, syed.haris@codingcops.com). A developer decision in a Claude Code session
  on 2026-10-20 to ship the labelled workarounds already written into the spec for the four open
  questions, deferring the real behaviour. This does NOT answer the product questions — they stay
  open and owned by TCG (Melissa McNutt, Kyle Harlow). Recorded as status: reference because it is
  developer direction, not a TCG product ruling.
status: reference
conflicts_with: []
resolves: []
related_tickets:
  - TICKET-FLOW-SLOTS-HOLDOVER
  - PR #831
related_decisions:
  - 2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md
  - 2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md
jira: []
tags: [module/field-ops, module/payroll, kind/decision, ticket-workflow, workaround, deferred]
---

# Ship the Q1–Q4 workarounds; the real paths are deferred

## Decision

PR #831 ships the **labelled workarounds already written into
`.ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/spec.md` §12** for the four open questions. The four product
questions **remain open and owned** — this note is not an answer to any of them.

- **Q1 / REQ-30** (Operator on an Oiler's ticket): ship **the verified 2026-09-14 rule as it reads
  today** (`decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md`, clause 2 — the
  Oiler enters the labor, the folded Operator has no fill/complete/sign/submit step). The provisional
  "Operators complete their own" answer is **not** built.
- **Q2 / REQ-31** (departed employee with incomplete tickets): ship **no departed-employee path** at
  all. Nothing finishes, cancels or reassigns a terminated worker's incomplete tickets.
- **Q3 / REQ-32** (overdue previous-ticket enforcement strength): ship **no gate beyond today's
  `isFutureFieldTicket` date-order guard** (REQ-07). An overdue or incomplete earlier ticket does not
  warn, soft-block or hard-block the next one.
- **Q4 / REQ-33** (two Operator slots, no Oiler): ship **both Operators FULL** (today's behaviour,
  DN-1 D3). No STANDARD designation.

The real paths for all four are **deferred to follow-up work**. The four §12 questions stay
`open` and owned: **Melissa McNutt** for Q1–Q3 (with Corrina Bustos for Q2 payroll, Lisette Anzaldo
for Q1/Q3 dispatch), **Kyle Harlow** for Q4.

## Why

The developer chose to unblock the ticket by shipping the smallest behaviour that does not depend on
the unknown answer — exactly the workaround each §12 entry already labels — rather than hold the
whole flow until TCG answers four questions. Each workaround is a conservative default: Q1 builds the
only **verified** rule that exists, Q2 adds nothing, Q3 keeps the existing guard and nothing more, Q4
keeps current behaviour. None of them forecloses the real answer; each can be replaced when TCG
decides. These are workarounds, labelled as such, not decisions on product intent.

## REQ-03 — related open item that is NOT a workaround, needs a human

Separately flag, because it is a different and worse case than Q1–Q4: **REQ-03** (Pre-Trip,
Post-Trip and JSA float — always tappable, never block the next step, block only submit) ships as
**built code that deviates from the vault on an unverified conflict.**

- The behaviour contradicts the sequential rule in **FR-TCG-FOP-002**
  (`field-ops/field-ops-frd/08-functional-requirements/fr-fop-011-job-safety-analysis-jsa.md`,
  `fr-fop-012-start-work.md`) and **Atom stories 78 / 149**
  (`field-ops/atom-mobile-app-user-stories/02-ticket-assignment-and-pre-trip.md`).
- The spec **does not adjudicate** this: the conflict stub `field-ops/field-ops-mobile-INDEX.md`
  (candidates FR-TCG-FOP-001, FR-TCG-FOP-002, Atom) stays unadjudicated, and all three are
  `status: unverified`.
- The **only** direction to deviate is **DN-1**
  (`decisions/2026-10-15-slot-driven-steps-floating-checklists-holdover-flow.md`, D6 / H10 / D9),
  which is itself `status: reference` / `[UNVERIFIED]` and explicitly does **not** verify or
  supersede any FOP document.

So REQ-03 is **not** a workaround — it is **shipped behaviour with no verified backing**, resting on
one unverified decision note that overrides unverified vault specs. **A human must verify which FOP
document is current** and whether the float rule is correct. This is **deferred, not resolved**; the
conflict remains live at the `field-ops/field-ops-mobile-INDEX.md` stub.

## Effect on the vault

- **No frontmatter changes.** This note closes no gap and adjudicates no conflict. Q1–Q4 stay
  `open`; the REQ-03 FOP conflict stays unadjudicated under its existing stub. No file's `status`
  changes.
- **`.ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/spec.md` §12 Q1–Q4:** a one-line deferral annotation added
  to each `Status:` line pointing at this note. The questions remain `open` and owned — the
  annotation records only that a labelled workaround shipped in PR #831 and the real path is
  deferred.

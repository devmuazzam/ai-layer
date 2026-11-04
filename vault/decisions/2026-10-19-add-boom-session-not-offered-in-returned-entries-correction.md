---
title: "Returned Entries correction — adding a new boom/buildup/breakdown session is not offered (edit and remove are unaffected) — decision"
source: decision/Ali Riaz — developer direction in Claude Code session, 2026-10-19 (PR #788)
decided: 2026-10-19
decided_by: >-
  Ali Riaz (CodingCops developer, git user devmohsinakram). Directed in a Claude Code
  session on branch `feat/adp-paydata-export` (PR #788) that the ability to ADD a new
  boom / build-up / break-down session in the Returned Entries correction dialog
  (`apps/web` `features/payroll-corrections`) be removed. The plumbing existed but was
  never wired to any UI control — it was dead code. Editing and removing existing
  sessions is not touched. This is a **developer direction**, not a client-side product
  decision, so it is `status: reference` on the same basis as the two notes it adjusts
  (2026-09-28 and 2026-10-06, both `reference`). It binds implementation now; TCG can
  overrule it.
status: reference
pending_ratification: >-
  Corrina Bustos (Payroll Manager) — she is the named payroll-side ratifier of
  decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md,
  whose clause 4 and 2026-09-29 addendum (item A) contemplate adding a new boom session
  and adding build-up / break-down. Neither note is verified and neither was ratified by
  her, so this deferral supersedes no verified decision. But whether a Payroll Admin
  should ever be able to ADD a session during a correction is a payroll product question
  in her scope. Recorded as decided-by-Ali-for-implementation-now, pending Corrina
  ratification — not settled product truth.
conflicts_with: []
related:
  - decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md
  - decisions/2026-10-06-returned-entries-correction-flow-and-send-back.md
  - decisions/2026-09-29-payroll-flags-go-to-payroll-admin-and-manager-not-crane-superintendent.md
tags: [module/payroll, kind/decision, web, api, payroll-review, boom-length]
entities: [PayrollCorrection, PayrollSendBack]
---

# Returned Entries correction — adding a new session is not offered

## Decision

In the Returned Entries correction dialog (`apps/web`,
`features/payroll-corrections`), the ability to **ADD a new boom / build-up / break-down
session** is intentionally **not offered**.

- The feature's plumbing existed in the codebase but was **never wired to any UI
  control** — dead code — and has been **removed** in PR #788 (commit on branch
  `feat/adp-paydata-export`).
- **Editing and removing existing sessions is unaffected.** Only *adding* a new session
  is not offered.

Because the add path was never exposed in the UI, no behaviour a user could reach
changes: this removes unreachable code, it does not withdraw a working capability.

Decided by **Ali Riaz** (CodingCops developer, git `devmohsinakram`), 2026-10-19.

## Why

A PR #788 review (Syed Haris, 2026-10-19) flagged a tension worth stating plainly: two
earlier notes describe a Payroll Admin (or, before the role was retired, a Crane
Supervisor) being able to add/edit boom sessions, and no prior decision drops the *add*
capability. This note defers it and records exactly why that is safe to do at the
developer level, and what is still open.

**The two notes the reviewer cited, and their status.** Both are `status: reference`
(not `verified`) and both are explicit **developer** directions, not client-side product
decisions:

- `decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md`
  (91 KB, decided 2026-09-28, updated 2026-09-30; `status: reference`). Clause 4 (the
  reviewer's "cl.4"), under *What they may edit*, says *"Missing captures can be added …
  and a new boom session"*, and its **Addendum 2026-09-29, item A** says the correcting
  role *"may also edit, add (when missing) and remove"* build-up (`BUILDUP_TIME`) and
  break-down (`BREAKDOWN_TIME`). The addendum states in its own words: *"this is a
  developer's decision at `status: reference` … Nobody on the client side has ratified
  any of it."* Its `decided_by` names the CodingCops developer (git `devmohsinakram`).
- `decisions/2026-10-06-returned-entries-correction-flow-and-send-back.md` (4.9 KB,
  `status: reference`). Its flow lists the Payroll Admin able to *"Adjust the entry
  directly — edit times, boom sessions, meals, craft modifier"*. Its `decided_by` names
  **Ali Riaz** and says *"This is a developer direction, not a client-side product
  decision."*

**Why no verified decision is being superseded.** Corrina Bustos (Payroll Manager) is a
*named ratifier* of the 2026-09-28 note's payroll side — she has not ratified it. Her
only written, verified amendments to that note (the two 2026-09-29 client amendments)
changed **who** corrects (Payroll Admin / Manager, not Crane Supervisor) and the **scope**
of a correction (individual employee, not whole crew). They did **not** grant, verify, or
even address the *add-a-new-session* capability. So the add capability has only ever stood
at developer `reference` level. A developer-level `reference` decision can be adjusted by
another developer-level `reference` decision, which is what this note is.

**Why it is nonetheless recorded as pending Corrina's ratification.** Whether a Payroll
Admin should ever be able to add a boom / build-up / break-down session during a
correction is a payroll product question, and Corrina is the named owner for exactly that
(payroll-side ratifier of the 2026-09-28 note). This note is authoritative for *what ships
now*; it is **not** the settled product answer. If Corrina later wants the add capability,
that is future work, not a reversal of a verified decision.

## Effect on the vault

No file's status is changed. There is **no verified winner** to promote and **no verified
loser** to supersede — this deferral adjusts two `reference`-level developer notes at the
same `reference` level, and the underlying product question is left open pending Corrina
Bustos. Per the gap-closing procedure, frontmatter status is flipped only when a named
human's verified decision closes a conflict; that condition is not met here, so:

- `decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md`
  — **unchanged** (`status: reference`). Clause 4 / addendum A's add-session language is
  adjusted by this note for implementation, not superseded in frontmatter.
- `decisions/2026-10-06-returned-entries-correction-flow-and-send-back.md` — **unchanged**
  (`status: reference`). Edit of existing boom sessions (its wording) still holds; only
  *add* is deferred.
- This note: `status: reference`, `pending_ratification: Corrina Bustos`.

## Deferred follow-up

Adding boom / build-up / break-down sessions during a correction remains **possible future
work**. One implementation detail to carry forward: the backend currently **hardcodes a
new session to `BOOM_TIME`**, so it cannot yet distinguish a newly added build-up
(`BUILDUP_TIME`) or break-down (`BREAKDOWN_TIME`) from a boom session. Re-introducing the
add capability means wiring a UI control *and* letting the backend set the session type,
not just re-exposing the removed plumbing.

**What would resolve the open product question:** a one-line answer from Corrina Bustos
(Payroll Manager) to — *"When a Payroll Admin corrects a returned entry, should they be
able to ADD a new boom / build-up / break-down session, or only edit and remove the
sessions already captured on the ticket?"* A "yes" turns the deferred follow-up above into
a ticket; a "no" ratifies this decision as settled.

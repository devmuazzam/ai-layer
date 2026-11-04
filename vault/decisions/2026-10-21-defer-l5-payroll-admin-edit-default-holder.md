---
title: "Defer L5 — no default payroll-admin:edit holder is seeded; E2 stands for now — decision"
source: decision/Syed Haris — developer direction in Claude Code session, 2026-10-21 (TICKET-FLOW-SLOTS-HOLDOVER Part 3 rebase)
decided: 2026-10-21
decided_by: >-
  Syed Haris (CodingCops, git syed.haris@codingcops.com). Answered a direct question in a
  Claude Code session during the lt-series rebase on 2026-10-21: whether to carry LT3 (decision
  L5) across the rebase onto main, now that main's TCG-237 role refactor had removed the role
  L5 targeted. He directed that L5 be deferred and E2 kept. This is a developer direction taken
  during a rebase, not a client-side TCG product decision, so it is `status: reference` on the
  same basis as the note it adjusts (2026-10-15-late-and-incomplete-tickets.md, `reference`).
  It binds implementation now; TCG can overrule it, and L5 is revisited once a role in the
  TCG-237 structure is chosen to hold the permission.
status: reference
conflicts_with: []
defers:
  - decisions/2026-10-15-late-and-incomplete-tickets.md#l5 (the seed + data-migration portion only)
related:
  - decisions/2026-10-15-late-and-incomplete-tickets.md
  - decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md
  - decisions/2026-10-13-fix-entry-roundtrip-attribution-and-pm-pa-split.md
tags: [module/payroll, module/field-ops, kind/decision, api, permissions, late-tickets]
---

## Decision

**Defer L5 (decision 2026-10-15); keep E2 (decision 2026-09-30).** During the
TICKET-FLOW-SLOTS-HOLDOVER Part 3 rebase onto main (2026-10-21), **drop LT3's seed grant and
its SQL data migration.** No role is granted `payroll-admin:edit` by default. The permission is
granted **by hand**, per tenant, in Departments (role settings) until L5 is revisited against
the TCG-237 role structure.

The late/incomplete-ticket feature (Part 3, LT1–LT17) ships and works as specified: the approver
of a late or post-submit edit is still a `payroll-admin:edit` holder (L5/L7 unchanged on that
point). What is deferred is only **who holds that permission out of the box** — approvers are
granted it manually rather than by a seeded default.

This **reverses the reversal.** L5 (2026-10-15) had reversed E2 (2026-09-30, "no role holds
`payroll-admin` by default — it is a Department Roles setting") by seeding the grant. L5 is now
deferred, not cancelled, so **E2 stands for now.**

## Why

L5's build step (LT3) was: grant the `payroll-admin:edit` permission to the **`Payroll Manager`**
role (`ROLE-ACCOUNTS-PM`) in the seed, plus a SQL data migration inserting that role-permission
row for every existing tenant.

Between L5 being written (2026-10-15) and this rebase (2026-10-21), **main's TCG-237 role
refactor removed the `Payroll Manager` / `ROLE-ACCOUNTS-PM` role and keyed roles by name.**
There is no longer a role that LT3 could target. Carrying LT3 across the rebase would mean
inventing which role in the new structure should hold the permission — a product decision nobody
has made (TCG-237 REQ-08 places a "Payroll Administrator" under HR; REQ-02 fixes the exact role
name; both are still open there).

Rather than guess a target role to keep a seed step alive, defer the default-holder question and
let the feature ship. Granting `payroll-admin:edit` by hand in Departments is the existing E2
mechanism and needs no schema or seed change; it is reversible and loses nothing when L5 is
revisited. Deferral is cheaper and more honest than a seeded grant pointed at a role chosen by
the AI during a rebase.

## What is still open

Which role in the TCG-237 structure (e.g. the HR "Payroll Admin"/"Payroll Administrator" of
REQ-08) should hold `payroll-admin:edit` by default, and whether to re-seed it, is **deferred,
not cancelled.** Revisit L5 once TCG-237 settles the role name and placement (its REQ-02 / REQ-08
/ Q1). Until then, E2 governs: the permission is a per-tenant Department Roles setting, granted
by hand.

## Effect on the vault

**Frontmatter — no changes, and why.**
- `decisions/2026-10-15-late-and-incomplete-tickets.md` is **not** superseded. Only its L5 seed
  portion is deferred; L1–L18 otherwise still govern the Part 3 build. It stays `status: reference`.
  This note records the deferral; the 2026-10-15 note's body is not edited (a developer direction
  supersedes another by recording the newer one, not by editing the older).
- `decisions/2026-09-30-developer-answers-multi-day-and-flagged-entry-gaps.md` (E2) stays
  `status: reference` and is **not** re-flagged verified. E2 simply stands again; neither note was
  ever `verified`, so there is no status flip to make.
- No winner/loser pair exists here, so no `superseded_by:`/`verified_because:` edits apply.

**Gaps — updated, not reopened.**
- `payroll/gaps.md` → *"Who may complete or correct a ticket on a worker's behalf, and who
  approves a late or post-submit edit — manager or payroll"* stays **resolved**. The answer (a
  `payroll-admin:edit` holder approves) is unchanged; a one-line pointer to this note is added to
  its Status line so a reader who finds no seeded grant in the code understands why.

**Spec / units — out of this note's scope, flagged for the rebase.**
- `TICKET-FLOW-SLOTS-HOLDOVER/spec.md` REQ-22 and §12 Q6, and `units.md` LT3, describe the seed +
  data migration that this note drops. They are the ticket author's to adjust during the rebase;
  `tcg-scrum` does not edit ticket spec/unit bodies.

---
title: "Home-start holdover days — payable window is Start Work → End Work — decision"
source: decision/owner — answer Q2 in HOLDOVER-PAYROLL spec §12, 2026-10-26
decided: 2026-10-26
decided_by: >-
  The product owner (Syed Haris, CodingCops), answer Q2 (option X), captured in
  .ai/aidlc/HOLDOVER-PAYROLL/spec.md §12 Q2 on 2026-10-26, relayed by the elaboration
  coordinator (no direct written owner message in the vault). Settles the
  self-contradiction in the verified note
  decisions/2026-10-16-home-start-holdover-paid-time-boundary.md (headline "Left Job
  Site" vs body "closes at submit"). A pay-rule decision (G4). TCG client ratification
  was not sought — see Why.
status: verified
resolves: HOLDOVER-PAYROLL/spec.md#q2
conflicts_with:
  - decisions/2026-10-16-home-start-holdover-paid-time-boundary.md
tags: [module/payroll, module/field-ops, kind/decision, api]
entities: [WORK_TIME, BREAKDOWN_TIME, BOOM_TIME, BUILDUP_TIME]
---

# Home-start holdover days — payable window — the decision

## Decision

On a Day-2+ holdover ticket whose `dayStartFrom` is HOME there is no yard leg, and
payable hours are measured **Start Work → End Work** — the employee's `WORK_TIME`
own-window — where:

- the window **start** is the Start Work instant (the member's own-window start where
  present, i.e. `member.workStartedAt`), and
- the **End Work** instant is the one the window-close precedence chain resolves
  (break-down end → boom end → build-up end:
  `decisions/2026-10-26-holdover-window-close-precedence-breakdown-boom-buildup.md`,
  reaching Home-start days per this note).

Neither literal boundary from the 2026-10-16 note is the payable one: **not** "Arrive
Job Site → Left Job Site" (its headline), **not** "closes at submit" (its body).
Arrive On Site / Left Job Site remain ordinary job-site fields
(`WORK_AT_JOB_SITE_TIME` / `JOB_SITE_TIME`), not the payable boundary. Yard legs stay
absent on Home-start days.

Owner (answer Q2 = X, spec §12, 2026-10-26): payable hours are measured Start Work →
End Work (the employee's `WORK_TIME` own-window), where the End Work instant is the
one the Q1 chain resolves; this supersedes both the note's "Left Job Site" headline
and its "closes at submit" body as the payable boundary.

## Why

The verified note `decisions/2026-10-16-home-start-holdover-paid-time-boundary.md`
names two different ends — "Arrive Job Site to Left Job Site" in its headline and
"closes at submit" in its body — so the plan could not tell which boundary prices the
day. The owner settled it: the payable boundary is the employee's own work window,
Start Work → End Work, with the End Work instant resolved by the same precedence chain
that governs every other holdover day, so Home-start days are not a separate pricing
rule. The surviving findings of the 2026-10-16 note — that a Home-start day has no
yard leg, and that the STANDARD-ticket meal fallback ships without payroll sign-off —
are unchanged.

**Not a client ruling.** The only source is the owner's answer, relayed by the
coordinator; no TCG client member has ratified it. To be confirmed at payroll sign-off.

## Effect on the vault

- **Partial supersede:** `decisions/2026-10-16-home-start-holdover-paid-time-boundary.md`
  (verified) is **partly** superseded by this note — only its *payable boundary* ("Arrive
  Job Site → Left Job Site" / "closes at submit"). Its other findings (no yard leg on
  Home-start days; STANDARD meal fallback ships as-is) survive. It therefore keeps
  `status: verified`; its `conflicts_with:` now points at this note and a
  `provenance_note:` records the partial supersede. Done in this pass.
- This note's `conflicts_with:` points at the 2026-10-16 note.
- Provenance: `payroll/payroll-rules-provenance.md` Home-start row (REQ-03) is updated
  to the Start Work → End Work boundary and cites this note (G4), in the same pass.

## Effect on the spec

- `.ai/aidlc/HOLDOVER-PAYROLL/spec.md` §12 Q2 — marked resolved, pointing at this
  note. Unblocks REQ-03, REQ-08.

---
title: "Home-start holdover days — paid-time boundary — decision"
source: decision/Syed Haris — answer in TICKET-FLOW-SLOTS-HOLDOVER spec §12 Q5, 2026-10-16
decided: 2026-10-16
decided_by: >-
  Syed Haris (CodingCops, git syed.haris@codingcops.com). Answered Q5 in
  .ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/spec.md §12 on 2026-10-16. This is a
  pay-rule change for Home-start holdover days plus a release decision that
  the STANDARD ticket meal fallback ships without payroll sign-off.
status: verified
resolves: TICKET-FLOW-SLOTS-HOLDOVER/spec.md#q5
conflicts_with: []
tags: [module/field-ops, module/payroll, kind/decision, api]
entities: [WORK_TIME]
---

# Home-start holdover days — paid-time boundary — the decision

## Decision

On a Day 2+ (holdover) ticket that starts from Home — no Left Yard step, no
Driving — paid time runs **Arrive Job Site to Left Job Site**. There is no yard
step, so the yard-to-yard paid-time boundary does not apply to these days.

The `WORK_TIME` entry on a Home-start holdover day **opens at `arriveJob`** and
**closes at submit** (REQ-11), or **at `leftJob` for a STANDARD ticket**.

STANDARD 3rd-man and Rigger tickets, which now use the payroll engine's fallback
meal schedule (D10), **ship as-is without payroll sign-off**.

In Haris's words (spec §12 Q5, 2026-10-16): "Home-start holdover days: paid time
= Arrive Job Site to Left Job Site (no yard step, so yard-to-yard does not
apply). STANDARD ticket meal fallback ships as-is without payroll sign-off."

## Why

A holdover day that begins at Home has no yard leg, so the existing yard-to-yard
rule has no anchor to start from. Pinning paid time to the job-site transitions
(arrive → leave) is the only boundary the day actually records. Clearing the
STANDARD meal fallback to ship without payroll adjudication unblocks the release
rather than holding it on a sign-off that the fallback schedule does not need.

## Effect on the vault

- No existing vault file is superseded or verified by this note — it records a
  net-new pay-rule decision, not the resolution of a vault conflict.
- A provenance entry in `payroll/payroll-rules-provenance.md` is required per
  `contexts/payroll-engine.md`; that row, citing this note, is added by the
  ticket owner (not by this note).

## Effect on the spec

- `.ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/spec.md` §12 Q5 — marked resolved,
  pointing at this note. Unblocks REQ-09, REQ-15, REQ-02.

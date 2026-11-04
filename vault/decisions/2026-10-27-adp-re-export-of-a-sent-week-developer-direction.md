---
title: "ADP re-export: an already-sent employee week can be sent again from its frozen figures; the stamp is overwritten, nothing is recalled — developer direction"
source: decision/Syed Haris — developer direction in Claude Code session, 2026-10-27 (ADP-PAYDATA-EXPORT P5)
decided: 2026-10-27
decided_by: >-
  Syed Haris (CodingCops, git syed.haris@codingcops.com). Asked for a re-export option after
  observing that an exported ADP file cannot be produced again. Chose, from three readings put to
  him, "fresh send, overwrite the mark", and chose to build on developer direction rather than
  batch a client question first. This is a developer direction, not a TCG product decision, so it
  is `status: reference` on the same basis as 2026-10-21-defer-l5-payroll-admin-edit-default-holder.md.
  It binds implementation now; TCG can overrule it.
status: reference
conflicts_with: []
related:
  - decisions/2026-10-22-adp-guaranteed-hours-fold-into-st-dt.md
  - ../payroll/rules/PAY-066-payroll-snapshot.md
  - ../payroll/gaps.md
tags: [module/payroll, kind/decision, api, web, adp-export]
---

## Decision

**A `payroll-admin:edit` holder may export an already-sent employee week again.** The send
carries `reexport: true` on the existing `POST periods/:id/export` body; the server then does not
refuse the already-exported weeks in the selection. Everything else about the send is unchanged:

- The file is built from the figures **in force** — which, for a sent week, are the figures frozen
  at its first send (P2b carry-forward). A re-export therefore reproduces what ADP already
  received unless a later recalculation changed what the freeze carried (it does not).
- The week's `exportedAt`, `exportedById` and `exportBatchLabel` are **overwritten** by the new
  send. No history row is kept; the earlier send is not recalled or marked.
- Every other gate still applies (approval, open send-backs, incomplete tickets, open flags, ADP
  file number, component validation, period-wide recalculation holds). The period's `EXPORTED`
  stamp is unchanged; an `EXPORTED` period stays `EXPORTED`.
- Without `reexport`, or for a reader without `payroll-admin:edit`, an already-sent week is refused
  exactly as before.

Surfaces: the worklist's Export to ADP dialog lists sent employees with a checkbox (unticked by
default, with a warning that the earlier file is not recalled); the employee-week detail hero shows
a "Re-export" button beside the Sent badge, behind a confirm.

## Why

The ask was operational: a file that was lost, rejected on import, or needed again could not be
produced. The three readings put to the developer were (A) re-download without re-stamping, (B)
fresh send overwriting the stamp, (C) automatic un-send on an entry fix. He chose B.

## What this does not decide

- **Re-export of an amended week.** A sent week is frozen (PAY-066, P2b); entry fixes refuse on an
  approved or exported period and on an approved week. So a correction cannot reach a sent week,
  and this re-export cannot carry one. The amended-week story stays the open PAY-066 / PAY-068
  correction-policy gap in `payroll/gaps.md`.
- **Whether ADP accepts a second paydata file for the same batch id.** Not asked of the client
  (developer chose to build first). The file name and batch id of a re-export are the period's,
  identical to the first send. Owner: Brian Petros, when the correction policy is discussed.

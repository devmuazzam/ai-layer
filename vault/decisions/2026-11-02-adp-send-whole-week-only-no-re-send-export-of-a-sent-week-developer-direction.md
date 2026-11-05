---
title: "ADP send is all or nothing for the week, with no individual or partial send and no re-send; a sent week can be exported again from its frozen figures, stamping nothing: developer direction"
source: decision/Syed Haris (CodingCops), developer direction in a Claude Code session, 2026-11-02
decided: 2026-11-02
decided_by: >-
  Syed Haris (CodingCops, git syed.haris@codingcops.com), stated directly in a Claude Code session
  on 2026-11-02. tcg-scrum did not see the session. The two quotes below are his words as relayed
  by the session that launched it, and the four numbered clauses are that session's statement of
  what he decided. This is a developer direction, not a TCG product decision, so it is
  `status: reference`, on the same basis as
  2026-10-27-adp-re-export-of-a-sent-week-developer-direction.md. It binds implementation now. TCG
  was not consulted, on this or on either decision it reverses, and TCG can overrule it.
status: reference
resolves:
  - ADP-PAYDATA-EXPORT/spec.md#q35
  - ADP-PAYDATA-EXPORT/spec.md#q39
supersedes:
  - decisions/2026-10-27-adp-re-export-of-a-sent-week-developer-direction.md
supersedes_partial:
  - ADP-PAYDATA-EXPORT/spec.md#q35 (Ali Riaz, 2026-10-16; the partial per-employee send and P4 only)
conflicts_with: []
related:
  - decisions/2026-10-27-adp-re-export-of-a-sent-week-developer-direction.md
  - decisions/2026-10-28-auto-recalc-reprices-pending-weeks-keeps-approved-weeks-frozen-developer-direction.md
  - ../payroll/rules/PAY-066-payroll-snapshot.md
  - ../payroll/rules/PAY-067-adp-export.md
  - ../payroll/gaps.md#excel-or-api--the-adp-submission-path-is-not-decided
  - ../payroll/gaps.md#a-labor-entry-edit-can-reprice-an-approved-week--and-the-erp-has-no-path-for-it
  - ../../aidlc/ADP-PAYDATA-EXPORT/spec.md
tags: [module/payroll, kind/decision, api, web, adp]
---

## Decision

In his words:

> "there is never a case, where indiviual or half employees will be sent to adp."

and, on re-sending:

> "for now no, add the export option for now, but for API call no need for re-send"

As relayed:

1. **Send to ADP is all or nothing for the week.** No individual employee and no subset is ever
   sent. Send stays disabled until no employee has an alert. The population is still union-field
   only (`L12_FIELD`, phase 1, `ADP-PAYDATA-EXPORT/spec.md` §12.5 Q14).
2. **No re-send to ADP.**
3. **For now there is an Export option on a week already sent.** It rebuilds the whole week's CSV
   from the frozen figures and downloads it. It is not a send and does not change the export stamp
   or the batch label. Whole week only.
4. **The API enforces this too.** `POST /payroll/periods/:id/export` refuses a selection that leaves
   out any eligible union-field employee.

## What this reverses

**A colleague's decision.** `ADP-PAYDATA-EXPORT/spec.md` Q35 records Ali Riaz's call of 2026-10-16:
per-employee partial export, where the PM/PA sends the clean employees now and the rest later. The
single-employee Export to ADP button (P4) came from it. Clauses 1 and 4 reverse that call, and P4
with it. Nothing relayed to tcg-scrum says Ali Riaz took part in this reversal.

Q35's route shape is not reversed: clause 4 keeps `POST periods/:id/export` as the send route. On
the export model, the spec's §12.5 Q16 ("replace … per-employee export entirely") again describes
the direction, which is the re-adjudication Q35 said was owed.

**His own earlier note.** `decisions/2026-10-27-adp-re-export-of-a-sent-week-developer-direction.md`
(Q39, reading B) let a sent week be sent again, overwriting its stamp. Clause 2 ends that. Clause 3
is close to reading A, which was put to him on 2026-10-27 and not chosen, but it covers only the
whole week.

**TCG was not consulted on either decision, and is not on this one.** All three are CodingCops
developer calls. This note is not a client ruling and must not be cited as one.

## Why

His stated reason is the first quote: the case does not exist. tcg-scrum was given no further
reasoning and adds none.

What follows from the clauses, stated so it can be overruled knowingly: one employee with an alert
holds the send for the whole union-field week. Q35's case, sending the clean employees now and the
rest later, is no longer served.

## What this does not decide

- **Excel or Pay Data Input API.** Still open:
  `payroll/gaps.md#excel-or-api--the-adp-submission-path-is-not-decided`. Clause 2 is his statement
  about the eventual API path. It does not choose that path.
- **Correcting a sent week.** A sent week is frozen and clause 3 reproduces its figures, so it
  cannot carry a correction. That stays the PAY-066 / PAY-068 gap:
  `payroll/gaps.md#a-labor-entry-edit-can-reprice-an-approved-week--and-the-erp-has-no-path-for-it`.
- **What "alert" and "eligible" cover.** Neither word is defined in what was relayed. This note does
  not widen or narrow the existing export gates, or the payroll-hold exclusion in
  `payroll/payroll-rules-provenance.md`.
- **A week already partly sent under Q35.** Whether any exists, and how its remaining employees go,
  was not addressed.
- **Q36** (`ADP-PAYDATA-EXPORT/spec.md`, which holds are scoped to the selection). Its owner has not
  answered it. Under clause 4 a send no longer has a partial selection to scope to, so it needs
  closing or rewording by Ali Riaz / Brian Petros. It is annotated and left open.

## The readable sheet returns (added the same day)

Syed Haris asked for the old *PAYROLL for ADP* sheet back, in the same style and with the same
function, and chose `exceljs` as the way to do it. This reverses the removal in
`aidlc/ADP-PAYDATA-EXPORT/units.md` U9 for that sheet only. It is a separate button from Send to ADP
and from Export, it downloads at any time (the old sheet needed every week approved; he chose any
time), and it stamps nothing. It is not the ADP import file. An employee with no ADP file number now
stays in the sheet with File # blank, which the implementation decided, since the old rule of
dropping them protected ADP from a short file and this sheet does not go to ADP.

## Effect on the vault

Done in the same pass:

- `decisions/2026-10-27-adp-re-export-of-a-sent-week-developer-direction.md` → `status: superseded`,
  `superseded_by:` this note. No winner is flipped to `verified`, because no client adjudicated
  anything here. This note stays `reference`.
- `aidlc/ADP-PAYDATA-EXPORT/spec.md` §12: Q35 and Q39 marked reversed with a pointer here, Q36
  annotated and still open.
- `payroll/gaps.md`: dated updates on *Excel or API* (still open) and on
  *A labor-entry edit can reprice an approved week* (its 2026-10-27 update is now stale).

Applied the same day by the session that asked for this note, on Syed Haris's approval:

- `payroll/INDEX.md`, *Decisions that bind this module*: a line for this note.
- `payroll/payroll-rules-provenance.md`: the row *ADP re-export of an already-sent week (PAY-066)*
  is now *ADP send and export of a sent week (PAY-066)*.
- `aidlc/ADP-PAYDATA-EXPORT/units.md` (P5) and `state.md` (Resume): dated notes at the top; the older
  text stays as the record of what was built.

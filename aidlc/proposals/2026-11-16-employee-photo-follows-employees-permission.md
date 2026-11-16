# Proposal — `patterns.md` P3: an employee's picture follows the Employees permission

**Status:** proposed, not applied (`contexts/patterns.md` is Haris-only) · **Date:** 2026-11-16 · **Proposed by:** fouzan (Claude Code session) · **Source:** Trello #246, `.ai/aidlc/Trello-246/state.md`

## The problem

`claude/contexts/patterns.md` P3 (_Entity photos and profile pictures_) says an employee's picture can be
changed by "ADMIN only". The API no longer works that way (commit `46ff517b0`, client branch
`feat/hide-actions-without-permission`, not merged): `PHOTO_ACCESS.EMPLOYEE.change` is employees Create or
Edit, and portal admins still pass. The same statement is in `TCG-241/spec.md` (line 318, "Trust boundary") and
`TCG-241/state.md` (U13) — those are a closed ticket's record and carry a "superseded" note instead of an edit.

## The change

In the P3 table, row EMPLOYEE, column "Who may change them":

| | Before | After |
| --- | --- | --- |
| EMPLOYEE | ADMIN only | anyone with employees Create or Edit (portal admins included); View alone may not |

Apply when the PR for Trello #246 merges, not before, so `patterns.md` never describes unmerged behaviour.
The employee form already offered the control to every role that can open the form, so this makes the
API match the UI; "who may change it" otherwise stays as PHOTO-REUSE U2 shipped it.

## Not part of this proposal

A `vault/decisions/` note. The rule came from the developer in a session ("edit access can upload, view-only
cannot"), not from TCG; if TCG should own it, `tcg-scrum` writes the note once someone there answers.

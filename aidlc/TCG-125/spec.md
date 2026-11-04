# Spec — TCG-125 Associated Field Assets: Inclusion caption and empty state

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-125` — "Operator Load setup screen needs improving" |
| Elaborated on | `2026-10-16`, in a working session with devmohsinakram |
| Product source | `.ai/vault/uat/register-2026-09-18.md:292` — UAT 3 (NOT DONE) |
| Code read at | `fixes/TCG-15-OCT` @ `2fed5e65b` |
| Built in | `craneguys-platform` `a15c4c868` (1 web file, +14 / −1) |

## 1. Requirements

| Req | Requirement | Source |
| --- | --- | --- |
| REQ-01 | On the sub-category detail screen, the Always Included / Optional radios carry the "Inclusion" caption, as on create (it had been commented out in `associated-assets-tab-content.tsx`) | ticket "Done when" |
| REQ-02 | On the detail screen, an empty list shows "No associated resources configured." with an "Add your first association" link — the create screen's empty state | ticket "Done when" |
| REQ-03 | What "Always Included" saves and means is unchanged (boom pay) | ticket note |

## 2. Verification

- `apps/web` ESLint and typecheck clean. No visual check yet.

## 12. Open questions

- **Q1 — Should the Operator Load setup differ by job type and yard?** Brian Petros to decide. Blocks
  row order, loop checks and matching by ID. **Status:** open.
- **Q2 — The half-save ("a save should not half-save and ask you to save again").** Not built.
  Cause found: `sub-categories.service.ts` `create` / `update` write in separate steps (sub-category
  row → template → validate + replace associations → required-assets count → substitutions). A
  failure part-way leaves the earlier steps saved. Example on create: a substitute from another
  category is rejected after the sub-category is created, so the second save fails with "A sub-category
  with this name already exists". Proposed fix: validate first, then run every write in one
  transaction via a `runInTransaction` repository method and an optional transaction client on
  `replaceAssociatedResources`, `upsertTemplateForSubCategory`, `deleteTemplateBySubCategoryId` and the
  substitutions repository / service (~100 lines, 4 API files). It needs one line added to the repository
  mock in `sub-categories.service.spec.ts` (`runInTransaction: jest.fn((work) => work(undefined))`),
  without which 3 of its 9 tests fail. Decided 2026-10-16 by devmohsinakram (developer): not now —
  safest scope; revisit after reproducing it or seeing the ticket's first comment. **Status:** open.
- **Q3 — The web's multi-tab save** (leaving the page with edits on several tabs sends one PATCH per
  tab, in sequence; a later failure leaves earlier tabs saved and asks to save again). Not covered by
  the transaction alone; would need one combined request. **Status:** open.

## 13. Deliberately out of scope

- API, database, and tests — untouched.
- Row order, loop checks, matching by ID — blocked on Q1.

## 14. Rebuilt on current main for its PR (2026-10-16)

`origin/main` (`1056f2aa6`) had moved 47 commits, including TCG-218 (hariscops), which rewrote
`associated-assets-tab-content.tsx` and **already restored the "Inclusion" caption** (as a headed
column, TCG-218 U1). Cherry-picking `a15c4c868` conflicted, so the ticket was rebuilt on
`fixes/TCG-15-OCT-TCG-125` as `ced874d4e`: **the empty-list message only** (+13 lines). REQ-01 is now
satisfied by main; REQ-02 by `ced874d4e`. `a15c4c868` on `fixes/TCG-15-OCT` is superseded for the PR.

---
title: "Mobile certificate view — own employee certificates only, one 'View / Download / Share' button, disabled when no document — developer decisions"
source: decision/haris (developer) — answers in chat during the MOBILE-CERT-VIEW build, 2026-11-10
decided: 2026-11-10
decided_by: >-
  haris (Syed Haris, CodingCops), developer on the MOBILE-CERT-VIEW build, answering in chat
  on 2026-11-10 (the intent questions recorded in `.ai/aidlc/MOBILE-CERT-VIEW/intent.md` §4
  and spec §2, §11b D5/D6 and §12 Q1). Merged to staging 2026-11-11 in PR #1062 (merge
  c86612c06: 76c675a90, 8bc848789) and PR #1063 (merge 63e30c1ff: c3fb9b2b5). These are a
  developer's decisions for this build, not a TCG client ruling: recorded as
  `status: reference`, binding on MOBILE-CERT-VIEW, open to being overruled by the TCG
  product team.
status: reference
resolves:
  - MOBILE-CERT-VIEW/spec.md#q1
supersedes_partial:
  - "decisions/2026-11-04-mobile-presigned-reads-viewers-approved-employee-files-owner-or-admin.md (Decision 1, certifications bullet: the 'View / Share Document' label only. The approval of the viewer and Decision 2's owner-or-admin rule stand)"
conflicts_with: []
related_tickets:
  - MOBILE-CERT-VIEW
  - MOBILE-REMAINING-PRESIGNED-FILES
related_decisions:
  - 2026-11-04-mobile-presigned-reads-viewers-approved-employee-files-owner-or-admin.md
  - 2026-11-03-mobile-remaining-presigned-files-scope.md
tags: [module/field-ops, kind/decision, requirements]
---

# Mobile certificate view — developer decisions for MOBILE-CERT-VIEW

## Status of this note

These are **developer decisions by haris**, made in chat on 2026-11-10, not a ruling by the
TCG client or product team. Status is `reference`, not `verified`. No vault page specifies a
mobile certificate viewer; the field-ops mobile source conflict
(`field-ops/field-ops-mobile-INDEX.md`) is not adjudicated by this note.

Numbering: decisions 1–5 answer the intent questions (`intent.md` §4, spec S1). Decision 6
is spec §11b D6 (REQ-04). Decision 7 is REQ-05. Decision 8 answers spec §12 Q1. Spec §12
Q2 is **not** resolved here.

## Decision 1 — employee certificates only

The mobile certificates screen shows employee certificates only. Asset and crane
certificates are out of scope.

## Decision 2 — a user sees only their own certificates

The logged-in employee sees only their own certificates. There is no crew-on-job view and no
office-staff view in the mobile app. Certificates are not shown in progress tracking.

## Decision 3 — opening a document keeps the current behaviour

Opening a document downloads it through a presigned S3 link and hands it to the native share
sheet (`openStoredAttachment`, `apps/mobile/lib/attachment-links.ts`). No in-app preview. No
new dependency.

## Decision 4 — no document: disabled button plus message

A certification with no document shows the button disabled, plus the line
"No document on file".

## Decision 5 — one button, labelled "View / Download / Share"

There is one button, labelled "View / Download / Share". No second button. This supersedes
the "View / Share Document" label approved in Decision 1 of
`decisions/2026-11-04-mobile-presigned-reads-viewers-approved-employee-files-owner-or-admin.md`;
that note's approval of the viewer itself and its owner-or-admin access rule are unchanged.

## Decision 6 — the card's document is the winning row's own attachment

In `GET /me/certifications`, the certification card's document is the attachment of the row
that won the dedupe (latest expiry), not the newest attachment that shares its name.

- When the winner is a name-and-expiry-only row (no attachment of its own), it falls back to
  the newest same-name upload, so those rows keep the document they show today.
- Ties between two attachment rows with equal expiry, or both non-expiring, go to the newest
  upload, then the highest id, so the result does not depend on database row order.

Response shape unchanged.

## Decision 7 — "no longer available" only on a 404 from the links route

"This document is no longer available" shows only when `GET /attachments/:id/links` answers
404. When the S3 object itself has been deleted, the app keeps the generic toast "Could not
open the certificate. Please try again.", because `expo-file-system` reports the HTTP status
only inside the error message string. Whether that path should also say "no longer
available" is still open: `MOBILE-CERT-VIEW/spec.md` §12 Q2, owner haris.

## Decision 8 — base branch

The work was based on `origin/staging` (spec §12 Q1, answer X. Other). The PRs target
staging; the feature reaches `main` only after the presigned-reads work does.

## Why

- Decisions 1–5: no reasoning beyond the answers themselves was recorded in the chat. The
  context was Trello card #180 (employees view and download their certificates, done when
  tested on a real phone) and the open path already approved in the 2026-11-04 note.
- Decision 6: the old code took the expiry from one row and the document from another row of
  the same name, so a card could open a different file than the one it described. Dropping the
  fallback was rejected because name-only rows would lose a document they show today.
- Decision 7: never show "no longer available" for what may be a plain network failure; only
  the 404 is unambiguous.
- Decision 8: the code this ticket edits existed only on staging, not on `main`.

## Effect on the vault

- None. No vault file is promoted to `verified` or marked `superseded`, and no frontmatter
  was changed: these are developer decisions, not a product ruling.
- `decisions/2026-11-04-mobile-presigned-reads-viewers-approved-employee-files-owner-or-admin.md`
  was not edited. The partial supersession of its label is recorded only in this note's
  `supersedes_partial:`.
- `MOBILE-CERT-VIEW/spec.md` §12 Q1 marked resolved, pointing here. Q2 left open.
